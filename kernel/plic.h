#pragma once
// 每个hart的使能寄存器偏移（单核时hart=0）
#define PLIC_SENABLE(hart)   (PLIC + 0x2080 + (hart) * 0x100)

// 每个hart的优先级阈值寄存器
#define PLIC_SPRIORITY(hart) (PLIC + 0x201000 + (hart) * 0x2000)

// 每个hart的claim/complete寄存器
#define PLIC_SCLAIM(hart)    (PLIC + 0x201004 + (hart) * 0x2000)


void plicinit(void);
void plicinithart(void);
void plic_enable(int irq);
void plic_disable(int irq);
int  plic_claim(void);
void plic_complete(int irq);