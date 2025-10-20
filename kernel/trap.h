#ifndef TRAP_H
#define TRAP_H

#include "types.h"
#include "proc.h"
#define MAX_IRQ 64


struct trap_info {
    uint64 sepc;    // 保存在 tf->epc 中
    uint64 sstatus; // 需要单独保存
    uint64 scause;  // 需要单独保存
    uint64 stval;   // 需要单独保存
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

void handle_exception(struct trapframe *tf, struct trap_info *info);
void handle_syscall(struct trapframe *tf, struct trap_info *info);
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info);
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info);
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info);
int handle_page_fault(uint64 va, int type);

void test_timer_interrupt(void);
void test_exception(void);

#endif // TRAP_H