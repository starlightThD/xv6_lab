#include "defs.h"
// 内核页表全局变量
pagetable_t kernel_pagetable = 0;
uint64 trampoline_phys_addr = 0; // 保存trampoline物理地址
uint64 trapframe_phys_addr = 0; // 保存trapframe物理地址
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
pte_t* walk_lookup(pagetable_t pt, uint64 va) {
	va = sv39_sign_extend(va);
	if (!sv39_check_valid(va))
		panic("va out of sv39 range");
    for (int level = 2; level > 0; level--) {
        pte_t *pte = &pt[px(level, va)];
        if (!pte) {
            printf("[WALK_LOOKUP] pte is NULL at level %d\n", level);
            return 0;
        }
        if (*pte & PTE_V) {
            uint64 pa = PTE2PA(*pte);
            // 防御性检测：物理地址必须在合法物理内存范围
            if (pa < KERNBASE || pa >= PHYSTOP) {
                printf("[WALK_LOOKUP] 非法页表物理地址: 0x%lx (level %d, va=0x%lx)\n", pa, level, va);
                return 0;
            }
            pt = (pagetable_t)pa;
        } else {
            printf("[WALK_LOOKUP] 页表项无效: level=%d va=0x%lx\n", level, va);
            return 0;
        }
    }
    return &pt[px(0, va)];
}

// 辅助函数：查找或分配
static pte_t* walk_create(pagetable_t pt, uint64 va) {
	va = sv39_sign_extend(va);
	if (!sv39_check_valid(va))
		panic("va out of sv39 range");
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
    struct proc *p = myproc();
    // 如果是用户进程，禁止映射内核空间
	if (p && p->is_user && va >= 0x80000000
		&& va != TRAMPOLINE
		&& va != TRAPFRAME) {
		warning("map_page: 用户进程禁止映射内核空间");
		exit_proc(-1);
	}
    if ((va % PGSIZE) != 0)
        panic("map_page: va not aligned");

    pte_t *pte = walk_create(pt, va);
    if (!pte)
        return -1;
    if (va >= 0x80000000)
        perm &= ~PTE_U;

    // 检查是否已经映射
    if (*pte & PTE_V) {
        if (PTE2PA(*pte) == pa) {
            int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
            if (va >= 0x80000000)
                new_perm &= ~PTE_U;
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
    if (!kpgtbl){
        panic("kvmmake: alloc failed");
	}
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
        int perm = PTE_R | PTE_W;
        // 如果是代码段，提升为可执行
        extern char etext[];
        if (pa < (uint64)etext)
            perm = PTE_R | PTE_X;
        if (map_page(kpgtbl, pa, pa, perm) != 0)
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
    
    //// 4. 扩大SBI调用区域映射
	//for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
	//	if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
	//		panic("kvmmake: low memory map failed");
	//}

	//// 特别映射包含0xfd02080的页
	//uint64 sbi_special = 0xfd02000;  // 页对齐
	//if (map_page(kpgtbl, sbi_special, sbi_special, PTE_R | PTE_W) != 0)
	//	panic("kvmmake: sbi special area map failed");
	// 分配一页物理内存用于 trampoline
	void *tramp_phys = alloc_page();
	if (!tramp_phys)
		panic("kvmmake: alloc trampoline page failed");
	extern char trampoline[];
	memcpy(tramp_phys, trampoline, PGSIZE);

	// 分配一页物理内存用于 trapframe
	void *trapframe_phys = alloc_page();
	if (!trapframe_phys)
		panic("kvmmake: alloc trapframe page failed");
	memset(trapframe_phys, 0, PGSIZE);

	// 映射 trampoline
	if (map_page(kpgtbl, TRAMPOLINE, (uint64)tramp_phys, PTE_R | PTE_X) != 0){
		panic("kvmmake: trampoline map failed");
	}

	// 映射 trapframe（只需内核可读写，无需执行权限）
	if (map_page(kpgtbl, TRAPFRAME, (uint64)trapframe_phys, PTE_R | PTE_W) != 0){
		panic("kvmmake: trapframe map failed");
	}

	// 保存物理地址供后续使用
	trampoline_phys_addr = (uint64)tramp_phys;
	trapframe_phys_addr = (uint64)trapframe_phys;
	printf("trampoline_phy_addr = %lx\n",trampoline_phys_addr);
	printf("trapframe_phys_addr = %lx\n",trapframe_phys_addr);
    return kpgtbl;
}
// 启用分页（单核只需设置一次 satp 并刷新 TLB）
static inline void w_satp(uint64 x) {
    asm volatile("csrw satp, %0" : : "r"(x));
}

inline void sfence_vma(void) {
    asm volatile("sfence.vma zero, zero");
}

// 初始化内核页表
void kvminit(void) {
    kernel_pagetable = kvmmake();
    sfence_vma();
    w_satp(MAKE_SATP(kernel_pagetable));
    sfence_vma();
    printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
}
// 获取当前页表
pagetable_t get_current_pagetable(void) {
    return kernel_pagetable;  // 在没有进程时返回内核页表
}
void print_pagetable(pagetable_t pagetable, int level, uint64 va_base) {
    for (int i = 0; i < 512; i++) {
        pte_t pte = pagetable[i];
        if (pte & PTE_V) {
            uint64 pa = PTE2PA(pte);
            uint64 va = va_base + (i << (12 + 9 * (2 - level)));
            for (int l = 0; l < level; l++) printf("  "); // 缩进
            printf("L%d[%3d] VA:0x%lx -> PA:0x%lx flags:0x%lx\n", level, i, va, pa, pte & 0x3FF);
            if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // 不是叶子
                print_pagetable((pagetable_t)pa, level + 1, va);
            }
        }
    }
}
// 处理页面故障（按需分配内存）
// type: 1=指令页，2=读数据页，3=写数据页
int handle_page_fault(uint64 va, int type) {
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);

    uint64 page_va = (va / PGSIZE) * PGSIZE;
    if (page_va >= MAXVA) {
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
        return 0;
    }

    struct proc *p = myproc();
    pagetable_t pt = kernel_pagetable;
    //int is_user = 0;
    if (p && p->pagetable && p->is_user) {
        pt = p->pagetable;
        //is_user = 1;
    }

    // 先检查是否已经有映射
    pte_t *pte = walk_lookup(pt, page_va);
    if (pte && (*pte & PTE_V)) {
        int need_perm = 0;
        if (type == 1) need_perm = PTE_X;
        else if (type == 2) need_perm = PTE_R;
        else if (type == 3) need_perm = PTE_R | PTE_W;

        if ((*pte & need_perm) != need_perm) {
            *pte |= need_perm;
            sfence_vma();
            printf("[PAGE FAULT] 已更新页面权限\n");
            return 1;
        }

        printf("[PAGE FAULT] 页面已映射且权限正确\n");
        return 1;
    }

    //// 只为用户进程分配新页
    //if (!is_user) {
    //    printf("[PAGE FAULT] 系统进程/内核不应分配新页，直接失败\n");
    //    return 0;
    //}

    void* page = alloc_page();
    if (page == 0) {
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
        return 0;
    }
    memset(page, 0, PGSIZE);

    int perm = 0;
    if (type == 1) perm = PTE_X | PTE_R | PTE_U;
    else if (type == 2) perm = PTE_R | PTE_U;
    else if (type == 3) perm = PTE_R | PTE_W | PTE_U;

    if (map_page(pt, page_va, (uint64)page, perm) != 0) {
        free_page(page);
        printf("[PAGE FAULT] 页面映射失败\n");
        return 0;
    }

    sfence_vma();
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    return 1;
}
void test_pagetable(void) {
    printf("[PT TEST] 创建页表...\n");
    pagetable_t pt = create_pagetable();
    assert(pt != 0);
    printf("[PT TEST] 页表创建通过\n");

    // 构造不同L2/L1/L0索引的虚拟地址
    uint64 va[] = {
        0x00000001000,      // L2=0, L1=0, L0=1
        0x00000002000,      // L2=0, L1=0, L0=2
        0x00002000000,      // L2=0, L1=1, L0=0
        0x00400000000,      // L2=2, L1=0, L0=0
        0x07f00000000,      // L2=255, L1=0, L0=0
    };
    int n = sizeof(va) / sizeof(va[0]);
    uint64 pa[n];

    // 分配物理页并建立映射
    for (int i = 0; i < n; i++) {
        pa[i] = (uint64)alloc_page();
        assert(pa[i]);
        printf("[PT TEST] 分配物理页 pa[%d]=0x%lx\n", i, pa[i]);
        int ret = map_page(pt, va[i], pa[i], PTE_R | PTE_W);
        printf("[PT TEST] 映射 va=0x%lx -> pa=0x%lx %s\n", va[i], pa[i], ret == 0 ? "成功" : "失败");
        assert(ret == 0);
    }

    printf("[PT TEST] 多级映射测试通过\n");

    // 检查映射是否生效
    for (int i = 0; i < n; i++) {
        pte_t *pte = walk_lookup(pt, va[i]);
        if (pte && (*pte & PTE_V)) {
            printf("[PT TEST] 检查映射: va=0x%lx -> pa=0x%lx, pte=0x%lx\n", va[i], PTE2PA(*pte), *pte);
        } else {
            printf("[PT TEST] 检查映射: va=0x%lx 未映射\n", va[i]);
        }
    }

    // 打印整个页表结构
    printf("[PT TEST] 打印页表结构（递归）\n");
    print_pagetable(pt, 0, 0);

    // 清理
    for (int i = 0; i < n; i++) {
        free_page((void*)pa[i]);
        printf("[PT TEST] 释放物理页 pa[%d]=0x%lx\n", i, pa[i]);
    }
    free_pagetable(pt);
    printf("[PT TEST] 释放页表完成\n");

    printf("[PT TEST] 所有页表测试通过\n");
}
void check_mapping(uint64 va) {
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    if(pte && (*pte & PTE_V)) {
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
		volatile unsigned char *p = (unsigned char*)va;
        printf("Try to read [0x%lx]: 0x%02x\n", va, *p);
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
		if (i < 0x80000000)
			flags |= PTE_U;
		else
			flags &= ~PTE_U;
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