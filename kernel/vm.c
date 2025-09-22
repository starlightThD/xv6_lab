#include "vm.h"
#include "memlayout.h"
#include "pm.h"
#include "printf.h"
#include "mem.h"
#include "assert.h"

#define PTE_V   0x001
#define PTE_R   0x002
#define PTE_W   0x004
#define PTE_X   0x008
#define PTE_U   0x010
#define PTE_FLAGS 0x3FF
#define PGSIZE 4096

#define VPN_SHIFT(level) (12 + 9 * (level))
#define VPN_MASK(va, level) (((va) >> VPN_SHIFT(level)) & 0x1FF)
#define PA2PTE(pa) ((((uint64)(pa)) >> 12) << 10)
#define PTE2PA(pte) (((pte) >> 10) << 12)

#define SATP_MODE_SV39 (8L << 60)
#define MAKE_SATP(pgtbl) (SATP_MODE_SV39 | (((uint64)(pgtbl)) >> 12))


// 内核页表全局变量
pagetable_t kernel_pagetable = 0;

static inline uint64 px(int level, uint64 va) {
    return VPN_MASK(va, level);
}

// 创建空页表
pagetable_t create_pagetable(void) {
    pagetable_t pt = (pagetable_t)alloc_page();
    if (!pt)
        return 0;
    memset(pt, 0, PGSIZE);
    return pt;
}
// 辅助函数：仅查找
static pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    if (va >= MAXVA)
        panic("walk_lookup: va out of range");
    for (int level = 2; level > 0; level--) {
        pte_t *pte = &pt[px(level, va)];
        if (*pte & PTE_V) {
            pt = (pagetable_t)PTE2PA(*pte);
        } else {
            return 0;
        }
    }
    return &pt[px(0, va)];
}

// 辅助函数：查找或分配
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    if (va >= MAXVA)
        panic("walk_create: va out of range");
    for (int level = 2; level > 0; level--) {
        pte_t *pte = &pt[px(level, va)];
        if (*pte & PTE_V) {
            pt = (pagetable_t)PTE2PA(*pte);
        } else {
            pagetable_t new_pt = (pagetable_t)alloc_page();
            if (!new_pt)
                return 0;
            memset(new_pt, 0, PGSIZE);
            *pte = PA2PTE(new_pt) | PTE_V;
            pt = new_pt;
        }
    }
    return &pt[px(0, va)];
}

// 建立映射
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    if ((va % PGSIZE) != 0)
        panic("map_page: va not aligned");
    pte_t *pte = walk_create(pt, va);
    if (!pte)
        return -1;
    if (*pte & PTE_V)
        panic("map_page: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    return 0;
}
// 递归释放页表
void free_pagetable(pagetable_t pt) {
    for (int i = 0; i < 512; i++) {
        pte_t pte = pt[i];
        // 只释放中间页表
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
            pagetable_t child = (pagetable_t)PTE2PA(pte);
            free_pagetable(child);
            pt[i] = 0;
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
            pt[i] = 0;
        }
    }
    free_page(pt);
}

// 内核页表构建（仅映射内核代码和数据，实际可根据需要扩展）
static pagetable_t kvmmake(void) {
    pagetable_t kpgtbl = create_pagetable();
    if (!kpgtbl)
        panic("kvmmake: alloc failed");

    // 映射内核物理内存（例如 KERNBASE ~ PHYSTOP）
    for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W | PTE_X) != 0)
            panic("kvmmake: map_page failed");
    }
	    // 映射UART设备内存（只读写，不可执行）
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
        panic("kvmmake: uart map_page failed");

    return kpgtbl;
}

// 初始化内核页表
void kvminit(void) {
    kernel_pagetable = kvmmake();
}

// 启用分页（单核只需设置一次 satp 并刷新 TLB）
static inline void w_satp(uint64 x) {
    asm volatile("csrw satp, %0" : : "r"(x));
}

static inline void sfence_vma(void) {
    asm volatile("sfence.vma zero, zero");
}

void kvminithart(void) {
    sfence_vma();
    w_satp(MAKE_SATP(kernel_pagetable));
    sfence_vma();
}

void test_pagetable(void) {
    printf("[PT TEST] 创建页表...\n");
    pagetable_t pt = create_pagetable();
    assert(pt != 0);
    printf("[PT TEST] 页表创建通过\n");

    // 测试基本映射
    uint64 va = 0x1000000;
    uint64 pa = (uint64)alloc_page();
    assert(pa != 0);
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0);
    printf("[PT TEST] 映射测试通过\n");

    // 测试地址转换
    pte_t *pte = walk_lookup(pt, va);
    assert(pte != 0 && (*pte & PTE_V));
    assert(PTE2PA(*pte) == pa);
    printf("[PT TEST] 地址转换测试通过\n");

    // 测试权限位
    assert(*pte & PTE_R);
    assert(*pte & PTE_W);
    assert(!(*pte & PTE_X));
    printf("[PT TEST] 权限测试通过\n");

    // 清理
    free_page((void*)pa);
    free_pagetable(pt);

    printf("[PT TEST] 所有页表测试通过\n");
}