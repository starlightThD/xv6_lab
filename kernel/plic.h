#pragma once
// 单核系统中，hart ID 始终为0
#define HART_ID 0

// 单核系统的 PLIC 寄存器地址宏定义
#define PLIC_ENABLE     (PLIC + 0x2080)  // hart 0 的S模式中断使能
#define PLIC_PRIORITY   (PLIC + 0x0)     // 中断优先级
#define PLIC_THRESHOLD  (PLIC + 0x201000) // hart 0 的S模式优先级阈值
#define PLIC_CLAIM      (PLIC + 0x201004) // hart 0 的S模式claim/complete

void plic_init(void);

void plic_enable(int irq);
void plic_disable(int irq);
int  plic_claim(void);
void plic_complete(int irq);