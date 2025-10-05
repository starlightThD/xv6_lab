#ifndef TRAP_H
#define TRAP_H

#include "types.h"

#define MAX_IRQ 64

// 保存中断/异常上下文的结构体
struct trapframe {
    uint64 ra;     // 返回地址
    uint64 sp;     // 栈指针
    uint64 gp;     // 全局指针
    uint64 tp;     // 线程指针
    uint64 t0;     // 临时寄存器
    uint64 t1;
    uint64 t2;
    uint64 s0;     // 保存寄存器
    uint64 s1;
    uint64 a0;     // 参数寄存器
    uint64 a1;
    uint64 a2;
    uint64 a3;
    uint64 a4;
    uint64 a5;
    uint64 a6;
    uint64 a7;
    uint64 s2;
    uint64 s3;
    uint64 s4;
    uint64 s5;
    uint64 s6;
    uint64 s7;
    uint64 s8;
    uint64 s9;
    uint64 s10;
    uint64 s11;
    uint64 t3;
    uint64 t4;
    uint64 t5;
    uint64 t6;
    uint64 sepc;   // 异常程序计数器
    uint64 sstatus;// 状态寄存器
    uint64 scause; // 异常原因
    uint64 stval;  // 异常值
};
typedef  void (*interrupt_handler_t)(void);
extern interrupt_handler_t interrupt_vector[MAX_IRQ];

void register_interrupt(int irq, interrupt_handler_t h);
void unregister_interrupt(int irq);

void enable_interrupts(int irq);
void disable_interrupts(int irq);

void interrupt_dispatch(int irq);

uint64 get_time(void);
pagetable_t get_current_pagetable(void);
void sfence_vma(void);

void trap_init(void);
void kerneltrap(void);

void handle_exception(struct trapframe *tf);
void handle_syscall(struct trapframe *tf);
void handle_instruction_page_fault(struct trapframe *tf);
void handle_load_page_fault(struct trapframe *tf);
void handle_store_page_fault(struct trapframe *tf);
int handle_page_fault(uint64 va, int type);

void test_timer_interrupt(void);
void test_exception(void);

#endif // TRAP_H