#include "types.h"
#include "memlayout.h"
#include "riscv.h"

void plicinit(void) {
    // 使用明确的内存访问模式
    for (int i = 1; i <= 32; i++) {
        uint64 addr = PLIC + i * 4;
        write32(addr, 0);
    }
    
    // 设置 UART 和 VIRTIO 优先级
    write32(PLIC + UART0_IRQ * 4, 1);
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
}

void plicinithart(void) {
    int hart = r_tp();
    
    // 分解地址计算和访问，确保地址是4字节对齐的
    uint64 senable_addr = PLIC_SENABLE(hart);
    uint64 spriority_addr = PLIC_SPRIORITY(hart);
    
    write32(senable_addr, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    write32(spriority_addr, 0);
}

void plic_enable(int irq) {
    int hart = r_tp();
    uint64 addr = PLIC_SENABLE(hart);
    
    uint32 old = read32(addr);
    write32(addr, old | (1 << irq));
}

void plic_disable(int irq) {
    int hart = r_tp();
    uint64 addr = PLIC_SENABLE(hart);
    
    uint32 old = read32(addr);
    write32(addr, old & ~(1 << irq));
}

int plic_claim(void) {
    int hart = r_tp();
    uint64 addr = PLIC_SCLAIM(hart);
    return read32(addr);
}

void plic_complete(int irq) {
    int hart = r_tp();
    uint64 addr = PLIC_SCLAIM(hart);
    write32(addr, irq);
}