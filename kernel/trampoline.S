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

    # 2. 按新的trapframe结构保存寄存器
    sd   ra, 64(a0)             # ra offset: 64
    sd   sp, 72(a0)             # sp offset: 72
    sd   gp, 80(a0)             # gp offset: 80
    sd   tp, 88(a0)             # tp offset: 88
    sd   t0, 96(a0)             # t0 offset: 96
    sd   t1, 104(a0)            # t1 offset: 104
    sd   t2, 112(a0)            # t2 offset: 112
    sd   t3, 120(a0)            # t3 offset: 120
    sd   t4, 128(a0)            # t4 offset: 128
    sd   t5, 136(a0)            # t5 offset: 136
    sd   t6, 144(a0)            # t6 offset: 144
    sd   s0, 152(a0)            # s0 offset: 152
    sd   s1, 160(a0)            # s1 offset: 160

    # 继续保存其他寄存器
    sd   a1, 176(a0)            # a1 offset: 176
    sd   a2, 184(a0)            # a2 offset: 184
    sd   a3, 192(a0)            # a3 offset: 192
    sd   a4, 200(a0)            # a4 offset: 200
    sd   a5, 208(a0)            # a5 offset: 208
    sd   a6, 216(a0)            # a6 offset: 216
    sd   a7, 224(a0)            # a7 offset: 224
    sd   s2, 232(a0)            # s2 offset: 232
    sd   s3, 240(a0)            # s3 offset: 240
    sd   s4, 248(a0)            # s4 offset: 248
    sd   s5, 256(a0)            # s5 offset: 256
    sd   s6, 264(a0)            # s6 offset: 264
    sd   s7, 272(a0)            # s7 offset: 272
    sd   s8, 280(a0)            # s8 offset: 280
    sd   s9, 288(a0)            # s9 offset: 288
    sd   s10, 296(a0)           # s10 offset: 296
    sd   s11, 304(a0)           # s11 offset: 304

	# 保存用户 a0：先取回 sscratch 里的原值
    csrr t0, sscratch
    sd   t0, 168(a0)

    # 保存控制寄存器
    csrr t0, sstatus
    sd   t0, 48(a0)
    csrr t1, sepc
    sd   t1, 56(a0)

	# 在切换页表前，先读出关键字段到 t3–t6
    ld   t3, 0(a0)              # t3 = kernel_satp
    ld   t4, 8(a0)              # t4 = kernel_sp
    ld   t5, 24(a0)            # t5 = usertrap
	ld   t6, 32(a0)			# t6 = kernel_vec

    # 4. 切换到内核页表
    csrw satp, t3
    sfence.vma x0, x0

    # 5. 切换到内核栈
    mv   sp, t4

    # 6. 设置 stvec 并跳转到 C 层 usertrap
    csrw stvec, t6
    jr   t5
userret:
        csrw satp, a1
        sfence.vma zero, zero
    # 2. 按新的偏移量恢复寄存器
    ld   ra, 64(a0)
    ld   sp, 72(a0)
    ld   gp, 80(a0)
    ld   tp, 88(a0)
    ld   t0, 96(a0)
    ld   t1, 104(a0)
    ld   t2, 112(a0)
    ld   t3, 120(a0)
    ld   t4, 128(a0)
    ld   t5, 136(a0)
    ld   t6, 144(a0)
    ld   s0, 152(a0)
    ld   s1, 160(a0)
    ld   a1, 176(a0)
    ld   a2, 184(a0)
    ld   a3, 192(a0)
    ld   a4, 200(a0)
    ld   a5, 208(a0)
    ld   a6, 216(a0)
    ld   a7, 224(a0)
    ld   s2, 232(a0)
    ld   s3, 240(a0)
    ld   s4, 248(a0)
    ld   s5, 256(a0)
    ld   s6, 264(a0)
    ld   s7, 272(a0)
    ld   s8, 280(a0)
    ld   s9, 288(a0)
    ld   s10, 296(a0)
    ld   s11, 304(a0)

        # 使用临时变量恢复控制寄存器
        ld t0, 56(a0)      # 恢复 sepc
        csrw sepc, t0
        ld t0, 48(a0)      # 恢复 sstatus
        csrw sstatus, t0
		csrw sscratch, a0
		ld a0, 168(a0)
        sret