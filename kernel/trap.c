#include "defs.h"
extern char trampoline[],uservec[], userret[];
extern pagetable_t kernel_pagetable;
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    tf->epc = sepc;
    // 其他字段需要保存在全局变量或函数参数中
}

static inline uint64 get_sepc(struct trapframe *tf) {
    return tf->epc;
}

static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    tf->epc = sepc;
}

// 全局测试变量，用于中断测试
volatile int *interrupt_test_flag = 0;
extern void kernelvec();
interrupt_handler_t interrupt_vector[MAX_IRQ];
void register_interrupt(int irq, interrupt_handler_t h) {
    if (irq >= 0 && irq < MAX_IRQ){
        interrupt_vector[irq] = h;
	}
}

void unregister_interrupt(int irq) {
    if (irq >= 0 && irq < MAX_IRQ)
        interrupt_vector[irq] = 0;
}
void enable_interrupts(int irq) {
    plic_enable(irq);
}

void disable_interrupts(int irq) {
    plic_disable(irq);
}

void interrupt_dispatch(int irq) {
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
		interrupt_vector[irq]();
	}
}
// 处理外部中断
void handle_external_interrupt(void) {
    // 从PLIC获取中断号
    int irq = plic_claim();
    
    if (irq == 0) {
        // 虚假中断
        printf("Spurious external interrupt\n");
        return;
    }
    interrupt_dispatch(irq);
    plic_complete(irq);
}

void trap_init(void) {
	intr_off();
	printf("trap_init...\n");
	w_stvec((uint64)kernelvec);
	for(int i = 0; i < MAX_IRQ; i++){
		interrupt_vector[i] = 0;
	}
	plic_init();
    uint64 sie = r_sie();
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
	printf("trap_init complete.\n");
}
void kerneltrap(void) {
    // 保存当前中断状态
    uint64 sstatus = r_sstatus();
    uint64 scause = r_scause();
    uint64 sepc = r_sepc();
    uint64 stval = r_stval();
    
    // 检查是否为中断（最高位为1表示中断）
    if(scause & 0x8000000000000000) {
        // 处理中断
        if((scause & 0xff) == 5) {
            // 时钟中断
            timeintr();
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
        } else if((scause & 0xff) == 9) {
            // 外部中断
            handle_external_interrupt();
        } else {
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
        }
    } else {
        // 处理异常（最高位为0）
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
        
        // 构造trapframe结构
        struct trapframe tf;
        save_exception_info(&tf, sepc, sstatus, scause, stval);
        
        // 创建一个trap_info用于传递额外信息
        struct trap_info info;
        info.sepc = sepc;
        info.sstatus = sstatus;
        info.scause = scause;
        info.stval = stval;
        
        // 调用异常处理函数
        handle_exception(&tf, &info);
        
        // 更新sepc
        sepc = get_sepc(&tf);
    }
    
    // 恢复中断现场
    w_sepc(sepc);
    w_sstatus(sstatus);
}
// 修改函数声明
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    uint64 cause = info->scause;  // 使用info中的字段
    
    switch (cause) {
        case 0:  // 指令地址未对齐
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
            break;
            
        case 1:  // 指令访问故障
            printf("Instruction access fault: 0x%lx\n", info->stval);
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
            break;
            
        case 2:  // 非法指令
            printf("Illegal instruction at 0x%lx: 0x%lx\n", info->sepc, info->stval);
			set_sepc(tf, info->sepc + 4); 
            break;
            
        case 3:  // 断点
            printf("Breakpoint at 0x%lx\n", info->sepc);
            set_sepc(tf, info->sepc + 4);
            break;
            
        case 4:  // 加载地址未对齐
            printf("Load address misaligned: 0x%lx\n", info->stval);
			set_sepc(tf, info->sepc + 4); 
            break;
            
		case 5:  // 加载访问故障
			printf("Load access fault: 0x%lx\n", info->stval);
			// 尝试先增加页权限
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
				return; // 成功处理
			}
			// 如果无法处理或不是权限问题，则跳过错误指令
			set_sepc(tf, info->sepc + 4);
			break;
            
        case 6:  // 存储地址未对齐
            printf("Store address misaligned: 0x%lx\n", info->stval);
			set_sepc(tf, info->sepc + 4); 
            break;
            
		case 7:  // 存储访问故障
			printf("Store access fault: 0x%lx\n", info->stval);
			// 尝试先增加页权限
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
				return; // 成功处理
			}
			// 如果无法处理或不是权限问题，则跳过错误指令
			set_sepc(tf, info->sepc + 4);
			break;
            
        case 8:  // 用户模式环境调用
            handle_syscall(tf,info);
            break;
            
        case 9:  // 监督模式环境调用
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
			set_sepc(tf, info->sepc + 4); 
            break;
            
        case 12:  // 指令页故障
            handle_instruction_page_fault(tf,info);
            break;
            
        case 13:  // 加载页故障
            handle_load_page_fault(tf,info);
            break;
            
        case 15:  // 存储页故障
            handle_store_page_fault(tf,info);
            break;
            
        default:
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
                   cause, info->sepc, info->stval);
            panic("Unknown exception");
            break;
    }
}
// 将用户虚拟地址 va 转换为物理地址，失败返回0
void* user_va2pa(pagetable_t pagetable, uint64 va) {
    pte_t *pte = walk_lookup(pagetable, va);
    if (!pte) return 0;
    if (!(*pte & PTE_V)) return 0;
    if (!(*pte & PTE_U)) return 0; // 必须是用户可访问
    uint64 pa = (PTE2PA(*pte)) | (va & 0xFFF); // 物理页基址 + 页内偏移
    return (void*)pa;
}
int copyin(char *dst, uint64 srcva, int maxlen) {
    struct proc *p = myproc();
    for (int i = 0; i < maxlen; i++) {
        // 你需要 walk_lookup 查 srcva+i 是否有效并有PTE_U权限
        char *pa = user_va2pa(p->pagetable, srcva + i); // 你需要实现 user_va2pa
        if (!pa) return -1;
        dst[i] = *pa;
        if (dst[i] == 0) return 0;
    }
    return 0;
}
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    // 约定 a7 为系统调用号
    switch (tf->a7) {
        case 1: // 打印整数
            printf("[syscall] print int: %ld\n", tf->a0);
            break;

        case 2: // 打印字符串
            char buf[128];
            copyin(buf, tf->a0, sizeof(buf)-1); // 从用户空间拷贝
            buf[sizeof(buf)-1] = 0;
            printf("[syscall] print str: %s\n", buf);
            break;

        case 93: // sys_exit (Linux ABI)
            printf("[syscall] exit(%ld)\n", tf->a0);
            exit_proc((int)tf->a0); // 使用 a0 作为退出码
            break;

        case 220: // sys_fork (Linux ABI: clone/fork)
            int child_pid = fork_proc();
            tf->a0 = child_pid;
            printf("[syscall] fork -> %d\n", child_pid);
            break;

        case 0xFFF: // 自定义 sys_step
            printf("[syscall] step enabled but we do not realize it\n");
            break;

        default:
            printf("[syscall] unknown syscall: %ld\n", tf->a7);
            tf->a0 = -1; // 返回错误
            break;
    }

    // 别忘了推进 sepc，否则会重复执行同一条 ecall
    set_sepc(tf, info->sepc + 4);
}



// 处理指令页故障
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled instruction page fault");
}

// 处理加载页故障
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled load page fault");
}

// 处理存储页故障
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled store page fault");
}

void usertrap(void) {
    struct proc *p = myproc();
    struct trapframe *tf = p->trapframe;

    uint64 scause = r_scause();
    uint64 stval  = r_stval();
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存

    uint64 code = scause & 0xff;
    uint64 is_intr = (scause >> 63);

    if (!is_intr && code == 8) { // 用户态 ecall
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
        handle_syscall(tf, &info);
        // handle_syscall 应该已 set_sepc(tf, sepc+4)
    } else if (is_intr) {
        if (code == 5) {
            timeintr();
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
        } else if (code == 9) {
            handle_external_interrupt();
        } else {
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
        }
    } else {
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
        handle_exception(tf, &info);
    }

    usertrapret();
}

void usertrapret(void) {
    struct proc *p = myproc();
	
    // stvec 指向 trampoline.uservec
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    w_stvec(uservec_va);

    w_sscratch((uint64)TRAPFRAME);

    // 用户页表 satp
    uint64 user_satp = MAKE_SATP(p->pagetable);

    // a0 = trapframe 的高地址映射
    register uint64 a0 asm("a0") = TRAPFRAME;
    register uint64 a1 asm("a1") = user_satp;
    register void (*userret_fn)(uint64, uint64) asm("t0") = (void*)userret;
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(userret_fn) : "memory");
}
