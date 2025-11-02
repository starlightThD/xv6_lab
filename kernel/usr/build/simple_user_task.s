	.file	"simple_user_task.c"
	.option nopic
	.option norelax
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"Simple kernel task running in pid: "
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	lui	a0,%hi(.LC0)
	addi	a0,a0,%lo(.LC0)
	li	a7,2
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a0,0
	li	a7,172
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a7,1
	sext.w	a0,a0
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a0,0
	li	a7,93
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
.L2:
	j	.L2
	.size	main, .-main
	.ident	"GCC: (13.2.0-11ubuntu1+12) 13.2.0"
