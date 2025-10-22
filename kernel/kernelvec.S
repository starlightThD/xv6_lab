.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
        sd gp, 16(sp)
        sd tp, 24(sp)
        sd t0, 32(sp)
        sd t1, 40(sp)
        sd t2, 48(sp)
        sd s0, 56(sp)    # 保存s0/fp
        sd s1, 64(sp)    # 保存s1
        sd a0, 72(sp)
        sd a1, 80(sp)
        sd a2, 88(sp)
        sd a3, 96(sp)
        sd a4, 104(sp)
        sd a5, 112(sp)
        sd a6, 120(sp)
        sd a7, 128(sp)
        sd s2, 136(sp)   # 保存s2
        sd s3, 144(sp)   # 保存s3
        sd s4, 152(sp)   # 保存s4
        sd s5, 160(sp)   # 保存s5
        sd s6, 168(sp)   # 保存s6
        sd s7, 176(sp)   # 保存s7
        sd s8, 184(sp)   # 保存s8
        sd s9, 192(sp)   # 保存s9
        sd s10, 200(sp)  # 保存s10
        sd s11, 208(sp)  # 保存s11
        sd t3, 216(sp)
        sd t4, 224(sp)
        sd t5, 232(sp)
        sd t6, 240(sp)

        # call the C trap handler in trap.c
        call kerneltrap

        # restore ALL registers
        ld ra, 0(sp)
        # 不恢复sp
        ld gp, 16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
        ld t1, 40(sp)
        ld t2, 48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
        ld s1, 64(sp)    # 恢复s1
        ld a0, 72(sp)
        ld a1, 80(sp)
        ld a2, 88(sp)
        ld a3, 96(sp)
        ld a4, 104(sp)
        ld a5, 112(sp)
        ld a6, 120(sp)
        ld a7, 128(sp)
        ld s2, 136(sp)   # 恢复s2
        ld s3, 144(sp)   # 恢复s3
        ld s4, 152(sp)   # 恢复s4
        ld s5, 160(sp)   # 恢复s5
        ld s6, 168(sp)   # 恢复s6
        ld s7, 176(sp)   # 恢复s7
        ld s8, 184(sp)   # 恢复s8
        ld s9, 192(sp)   # 恢复s9
        ld s10, 200(sp)  # 恢复s10
        ld s11, 208(sp)  # 恢复s11
        ld t3, 216(sp)
        ld t4, 224(sp)
        ld t5, 232(sp)
        ld t6, 240(sp)

        addi sp, sp, 256

        # return to whatever we were doing in the kernel.
        sret