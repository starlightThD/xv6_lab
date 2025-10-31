#include "memlayout.h"
.section .text.trampoline, "ax"
.globl trampoline
.globl usertrap
trampoline:
.align 4
uservec:
    # 1. 保存 a0 (用户态的 a0) 到 sscratch
    csrrw a0, sscratch, a0

    # 2. a0 现在是 trapframe 地址，读取关键字段
    ld   t3, 0(a0)        # kernel_satp
    ld   t4, 8(a0)        # kernel_sp
    ld   t5, 264(a0)      # usertrap (C 函数入口)
    ld   t6, 272(a0)      # kernel_vec (内核 trap 向量)

    # 3. 保存用户寄存器到 trapframe
    sd   ra, 48(a0)
    sd   sp, 56(a0)
    sd   gp, 64(a0)
    sd   tp, 72(a0)
    sd   t0, 80(a0)
    sd   t1, 88(a0)
    sd   t2, 96(a0)
    sd   s0, 104(a0)
    sd   s1, 112(a0)

    csrr t2, sscratch     # 恢复用户 a0
    sd   t2, 120(a0)

    sd   a1, 128(a0)
    sd   a2, 136(a0)
    sd   a3, 144(a0)
    sd   a4, 152(a0)
    sd   a5, 160(a0)
    sd   a6, 168(a0)
    sd   a7, 176(a0)
    sd   s2, 184(a0)
    sd   s3, 192(a0)
    sd   s4, 200(a0)
    sd   s5, 208(a0)
    sd   s6, 216(a0)
    sd   s7, 224(a0)
    sd   s8, 232(a0)
    sd   s9, 240(a0)
    sd   s10, 248(a0)
    sd   s11, 256(a0)

    # 保存 CSR
    csrr t0, sstatus
    sd   t0, 24(a0)
    csrr t1, sepc
    sd   t1, 32(a0)

    # 4. 切换到内核页表和栈
    csrw satp, t3
    sfence.vma x0, x0
    mv   sp, t4

    # 5. 设置 stvec = kernelvec
    csrw stvec, t6

    # 6. 跳转到 C 层 usertrap
    jr   t5

# ------------------------------------------------------
userret:
    # a0 = trapframe 地址
    ld   t0, 0(a0)        # kernel_satp
    ld   t1, 32(a0)       # sepc
    ld   t2, 24(a0)       # sstatus

    # 恢复 sepc/sstatus
    csrw sepc, t1
    csrw sstatus, t2

    # 设置 stvec = uservec (trampoline 地址)
    la   t3, uservec
    csrw stvec, t3

    # 切换回用户页表
    csrw satp, t0
    sfence.vma x0, x0

    # 恢复用户寄存器
    ld   ra, 48(a0)
    ld   sp, 56(a0)
    ld   gp, 64(a0)
    ld   tp, 72(a0)
    ld   t0, 80(a0)
    ld   t1, 88(a0)
    ld   t2, 96(a0)
    ld   s0, 104(a0)
    ld   s1, 112(a0)
    ld   a0, 120(a0)
    ld   a1, 128(a0)
    ld   a2, 136(a0)
    ld   a3, 144(a0)
    ld   a4, 152(a0)
    ld   a5, 160(a0)
    ld   a6, 168(a0)
    ld   a7, 176(a0)
    ld   s2, 184(a0)
    ld   s3, 192(a0)
    ld   s4, 200(a0)
    ld   s5, 208(a0)
    ld   s6, 216(a0)
    ld   s7, 224(a0)
    ld   s8, 232(a0)
    ld   s9, 240(a0)
    ld   s10, 248(a0)
    ld   s11, 256(a0)

    # 最后返回用户态
    sret
