	.file	"min_test.c"
	.option nopic
	.option norelax
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	li	a0,1
	li	a7,1
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
