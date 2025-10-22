#include "defs.h"
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
// 处理系统调用
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    printf("System call from sepc=0x%lx, syscall number=%ld\n", info->sepc, tf->a7);
    
    // 系统调用返回值存放在a0寄存器
    // tf->a0 = sys_call(tf->a7, tf->a0, tf->a1, tf->a2, tf->a3, tf->a4, tf->a5);
    
    // 系统调用完成后，sepc应该指向下一条指令
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
// 获取当前时间的辅助函数
uint64 get_time(void) {
    return sbi_get_time();
}

// 时钟中断测试函数
void test_timer_interrupt(void) {
    printf("Testing timer interrupt...\n");

    // 记录中断前的时间
    uint64 start_time = get_time();
    int interrupt_count = 0;
	int last_count = interrupt_count;
    // 设置测试标志
    interrupt_test_flag = &interrupt_count;

    // 等待几次中断
    while (interrupt_count < 5) {
        if(last_count != interrupt_count) {
			last_count = interrupt_count;
			printf("Received interrupt %d\n", interrupt_count);
		}
        // 简单延时
        for (volatile int i = 0; i < 1000000; i++);
    }

    // 测试结束，清除标志
    interrupt_test_flag = 0;

    uint64 end_time = get_time();
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
           interrupt_count, end_time - start_time);
}

// 修改测试异常处理函数
void test_exception(void) {
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    
    // 1. 测试非法指令异常
    printf("1. 测试非法指令异常...\n");
    asm volatile (".word 0xffffffff");  // 非法RISC-V指令
    printf("✓ 非法指令异常处理成功\n\n");
    
    // 2. 测试存储页故障
    printf("2. 测试存储页故障异常...\n");
    volatile uint64 *invalid_ptr = 0;
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
        if (check_is_mapped(addr) == 0) {
            invalid_ptr = (uint64*)addr;
            printf("找到未映射地址: 0x%lx\n", addr);
            break;
        }
    }
    
    if (invalid_ptr != 0) {
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
        *invalid_ptr = 42;  // 触发存储页故障
        printf("✓ 存储页故障异常处理成功\n\n");
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    }
    
    // 3. 测试加载页故障
    printf("3. 测试加载页故障异常...\n");
    invalid_ptr = 0;
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
        if (check_is_mapped(addr) == 0) {
            invalid_ptr = (uint64*)addr;
            printf("找到未映射地址: 0x%lx\n", addr);
            break;
        }
    }
    
    if (invalid_ptr != 0) {
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
        printf("✓ 加载页故障异常处理成功\n\n");
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    }
    
    // 4. 测试存储地址未对齐异常
    printf("4. 测试存储地址未对齐异常...\n");
    uint64 aligned_addr = (uint64)alloc_page();
    if (aligned_addr != 0) {
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
        
        // 使用内联汇编进行未对齐访问，因为编译器可能会自动对齐
        asm volatile (
            "sd %0, 0(%1)"
            : 
            : "r" (0xdeadbeef), "r" (misaligned_addr)
            : "memory"
        );
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    } else {
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    }
    
    // 5. 测试加载地址未对齐异常
    printf("5. 测试加载地址未对齐异常...\n");
    if (aligned_addr != 0) {
        uint64 misaligned_addr = aligned_addr + 1;
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
        
        uint64 value = 0;
        asm volatile (
            "ld %0, 0(%1)"
            : "=r" (value)
            : "r" (misaligned_addr)
            : "memory"
        );
        printf("读取的值: 0x%lx\n", value);
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    } else {
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    }

	// 6. 测试断点异常
	printf("6. 测试断点异常...\n");
	asm volatile (
		"nop\n\t"      // 确保ebreak前有有效指令
		"ebreak\n\t"   // 断点指令
		"nop\n\t"      // 确保ebreak后有有效指令
	);
	printf("✓ 断点异常处理成功\n\n");
    // 7. 测试环境调用异常
    printf("7. 测试环境调用异常...\n");
    asm volatile ("ecall");  // 从S模式生成环境调用
    printf("✓ 环境调用异常处理成功\n\n");
    
    printf("===== 异常处理测试完成 =====\n\n");
}
