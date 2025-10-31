#include "memlayout.h"
.section .text.trampoline, "ax"
.globl  trampoline
.globl  uservec
.globl  userret
.globl  kernelvec
.globl  usertrap
trampoline:
.align 4

uservec:
    # 1. 取 trapframe 指针
    csrrw a0, sscratch, a0      # a0 = TRAPFRAME (用户页表下可访问), sscratch = user a0

    # 2. 在切换页表前，先读出关键字段到 t3–t6
    ld   t3, 0(a0)              # t3 = kernel_satp
    ld   t4, 8(a0)              # t4 = kernel_sp
    ld   t5, 264(a0)            # t5 = usertrap
	ld   t6, 272(a0)			# t6 = kernel_vec

    # 3. 保存用户寄存器到 trapframe（仍在用户页表下）
    sd   ra, 48(a0)
    sd   sp, 56(a0)
    sd   gp, 64(a0)
    sd   tp, 72(a0)
    sd   t0, 80(a0)
    sd   t1, 88(a0)
    sd   t2, 96(a0)
    sd   s0, 104(a0)
    sd   s1, 112(a0)

    # 保存用户 a0：先取回 sscratch 里的原值
    csrr t2, sscratch
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

    # 保存控制寄存器
    csrr t0, sstatus
    sd   t0, 24(a0)
    csrr t1, sepc
    sd   t1, 32(a0)

    # 4. 切换到内核页表
    csrw satp, t3
    sfence.vma x0, x0

    # 5. 切换到内核栈
    mv   sp, t4

    # 6. 设置 stvec 并跳转到 C 层 usertrap
    csrw stvec, t6
    jr   t5
userret:
        mv t0, a0
        mv a0, a1
        csrw satp, a0
        sfence.vma zero, zero
        mv a0, t0
        ld ra, 48(a0)
        ld sp, 56(a0)
        ld gp, 64(a0)
        ld tp, 72(a0)
        ld t0, 80(a0)
        ld t1, 88(a0)
        ld t2, 96(a0)
        ld s0, 104(a0)
        ld s1, 112(a0)
        ld a1, 128(a0)
        ld a2, 136(a0)
        ld a3, 144(a0)
        ld a4, 152(a0)
        ld a5, 160(a0)
        ld a6, 168(a0)
        ld a7, 176(a0)
        ld s2, 184(a0)
        ld s3, 192(a0)
        ld s4, 200(a0)
        ld s5, 208(a0)
        ld s6, 216(a0)
        ld s7, 224(a0)
        ld s8, 232(a0)
        ld s9, 240(a0)
        ld s10, 248(a0)
        ld s11, 256(a0)

        ld t1, 32(a0)      # 恢复 sepc
        csrw sepc, t1
        ld t2, 24(a0)      # 恢复 sstatus
        csrw sstatus, t2
		csrw sscratch, a0
		ld a0, 120(a0)
        sret