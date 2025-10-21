#include "defs.h"
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

// 建立映射，允许重映射到相同物理地址
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    if ((va % PGSIZE) != 0)
        panic("map_page: va not aligned");
    pte_t *pte = walk_create(pt, va);
    if (!pte)
        return -1;
    
    // 检查是否已经映射
	if (*pte & PTE_V) {
		if (PTE2PA(*pte) == pa) {
			// 只允许提升权限，不允许降低权限
			int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
			*pte = PA2PTE(pa) | new_perm | PTE_V;
			return 0;
		} else {
			panic("map_page: remap to different physical address");
		}
	}
    
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

    // 1. 映射内核代码和数据区域（只读+执行 / 读写）
    extern char etext[];  // 在kernel.ld中定义，内核代码段结束位置
    extern char end[];    // 在kernel.ld中定义，内核数据段结束位置
    
    // 内核代码段 - 只读可执行
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_X) != 0)
            panic("kvmmake: code map failed");
    }
    
    // 内核数据段 - 可读写
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
            panic("kvmmake: data map failed");
    }
    
	// 2. 映射内核堆区域 - 可读写
	uint64 aligned_end = ((uint64)end + PGSIZE - 1) & ~(PGSIZE - 1); // 向上对齐到页边界
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
			panic("kvmmake: heap map failed");
	}
    
    // 3. 映射设备区域 - 只读写，不可执行
    // UART 串口设备
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
        panic("kvmmake: uart map failed");
    
    // PLIC 中断控制器
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
            panic("kvmmake: plic map failed");
    }
    
    // CLINT 本地中断控制器 - 完善映射
    // 确保整个 CLINT 区域被映射，特别是 mtimecmp 和 mtime 寄存器
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
            panic("kvmmake: clint map failed");
	}
    
    // VIRTIO 设备
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
        panic("kvmmake: virtio map failed");
    
    // 4. 扩大SBI调用区域映射
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
			panic("kvmmake: low memory map failed");
	}

	// 特别映射包含0xfd02080的页
	uint64 sbi_special = 0xfd02000;  // 页对齐
	if (map_page(kpgtbl, sbi_special, sbi_special, PTE_R | PTE_W) != 0)
		panic("kvmmake: sbi special area map failed");
    
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

inline void sfence_vma(void) {
    asm volatile("sfence.vma zero, zero");
}

void kvminithart(void) {
    sfence_vma();
    w_satp(MAKE_SATP(kernel_pagetable));
    sfence_vma();
	printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
}
// 获取当前页表
pagetable_t get_current_pagetable(void) {
    return kernel_pagetable;  // 在没有进程时返回内核页表
}

// 处理页面故障（按需分配内存）
// type: 1=指令页，2=读数据页，3=写数据页
int handle_page_fault(uint64 va, int type) {
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    
    // 页对齐地址
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    
    // 检查地址是否合法
    if (page_va >= MAXVA) {
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
        return 0; // 地址超出最大虚拟地址空间
    }
    
    // 先检查是否已经有映射
    pte_t *pte = walk_lookup(kernel_pagetable, page_va);
    if (pte && (*pte & PTE_V)) {
        // 检查是否只是权限不足
        int need_perm = 0;
        if (type == 1) need_perm = PTE_X;
        else if (type == 2) need_perm = PTE_R;
        else if (type == 3) need_perm = PTE_R | PTE_W;
        
        if ((*pte & need_perm) != need_perm) {
            // 更新权限
            *pte |= need_perm;
            sfence_vma();
            printf("[PAGE FAULT] 已更新页面权限\n");
            return 1;
        }
        
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
        return 1;
    }
    
    // 分配物理页
    void* page = alloc_page();
    if (page == 0) {
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
        return 0; // 内存不足
    }
    
    // 清零内存
    memset(page, 0, PGSIZE);
    
    // 设置权限
    int perm = 0;
    if (type == 1) {  // 指令页
        perm = PTE_X | PTE_R;  // 可执行页通常也需要可读
    } else if (type == 2) {  // 读数据页
        perm = PTE_R;
    } else if (type == 3) {  // 写数据页
        perm = PTE_R | PTE_W;
    }
    
    // 映射页面
    if (map_page(kernel_pagetable, page_va, (uint64)page, perm) != 0) {
        free_page(page);
        printf("[PAGE FAULT] 页面映射失败\n");
        return 0; // 映射失败
    }
    
    // 刷新TLB
    sfence_vma();
    
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    return 1; // 处理成功
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
void check_mapping(uint64 va) {
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    if(pte && (*pte & PTE_V)) {
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    } else {
        printf("Address 0x%lx is NOT mapped\n", va);
    }
}
int check_is_mapped(uint64 va) {
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    if (pte && (*pte & PTE_V)) {
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
        return 1;
    } else {
        printf("Address 0x%lx is NOT mapped\n", va);
        return 0;
    }
}
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    for (uint64 i = 0; i < sz; i += PGSIZE) {
        pte_t *pte = walk_lookup(old, i);
        if (pte == 0 || (*pte & PTE_V) == 0)
            continue; // 跳过未分配的页

        uint64 pa = PTE2PA(*pte);
        int flags = PTE_FLAGS(*pte);

        void *mem = alloc_page();
        if (mem == 0)
            return -1; // 分配失败

        memmove(mem, (void*)pa, PGSIZE);

        if (map_page(new, i, (uint64)mem, flags) != 0) {
            free_page(mem);
            return -1;
        }
    }
    return 0;
}