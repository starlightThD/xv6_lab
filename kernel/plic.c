#include "defs.h"
void plic_init(void) {
    // 清零所有中断源的优先级
    for (int i = 1; i <= 32; i++) {
        uint64 addr = PLIC + i * 4;
        write32(addr, 0);
    }
    
    // 设置需要的中断源优先级
    write32(PLIC + UART0_IRQ * 4, 1);
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    
    // 启用指定中断（原plic_inithart功能）
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    
    // 设置中断优先级阈值为0（接受所有中断）
    write32(PLIC_THRESHOLD, 0);
}


// 启用指定中断
void plic_enable(int irq) {
    uint32 old = read32(PLIC_ENABLE);
    write32(PLIC_ENABLE, old | (1 << irq));
}

// 禁用指定中断
void plic_disable(int irq) {
    uint32 old = read32(PLIC_ENABLE);
    write32(PLIC_ENABLE, old & ~(1 << irq));
}

// 获取当前中断号
int plic_claim(void) {
    return read32(PLIC_CLAIM);
}

// 完成中断处理
void plic_complete(int irq) {
    write32(PLIC_CLAIM, irq);
}