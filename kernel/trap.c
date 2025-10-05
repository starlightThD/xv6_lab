#include "trap.h"
#include "types.h"
#include "plic.h"
#include "memlayout.h"
#include "timer.h"
#include "riscv.h"
#include "printf.h"
#include "sbi.h"
#include "uart.h"

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
	printf("trap_init complete.\n");
}
// 中断处理函数
void kerneltrap(void) {
    // 保存当前中断状态
    uint64 sstatus = r_sstatus();
    uint64 scause = r_scause();
    uint64 sepc = r_sepc();
    
    if((scause & 0x8000000000000000) && ((scause & 0xff) == 5)) {
        // 调用时钟中断处理函数
        timeintr();
        // 设置下一次时钟中断 - 使用较短间隔用于测试
        sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    }else if((scause & 0x8000000000000000) && ((scause & 0xff) == 9)) {
        // 处理外部中断
        handle_external_interrupt();
    }else {
        printf("kerneltrap: unexpected scause=%lx sepc=%lx\n", scause, sepc);
        while(1); // 出现问题时挂起系统
    }
    
    // 恢复中断现场
    w_sepc(sepc);
    w_sstatus(sstatus);
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