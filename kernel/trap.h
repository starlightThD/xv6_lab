#ifndef TRAP_H
#define TRAP_H

#include "types.h"

#define MAX_IRQ 64

typedef  void (*interrupt_handler_t)(void);
extern interrupt_handler_t interrupt_vector[MAX_IRQ];

void register_interrupt(int irq, interrupt_handler_t h);
void unregister_interrupt(int irq);

void enable_interrupts(int irq);
void disable_interrupts(int irq);

void interrupt_dispatch(int irq);

void trap_init(void);
void kerneltrap(void);

void test_timer_interrupt(void);
uint64 get_time(void);
#endif // TRAP_H