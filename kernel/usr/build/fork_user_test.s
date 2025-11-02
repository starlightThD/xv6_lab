	.file	"fork_user_test.c"
	.option nopic
	.option norelax
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"child: "
	.align	3
.LC1:
	.string	" ppid="
	.align	3
.LC2:
	.string	"\n"
	.align	3
.LC3:
	.string	"parent: "
	.align	3
.LC4:
	.string	" forked child="
	.align	3
.LC5:
	.string	"before wait\n"
	.align	3
.LC6:
	.string	"after wait\n"
	.align	3
.LC7:
	.string	"parent: child "
	.align	3
.LC8:
	.string	" exited"
	.align	3
.LC9:
	.string	"fork failed!\n"
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	li	a0,0
	li	a7,220
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	sext.w	a5,a0
	bne	a5,zero,.L2
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
	lui	a0,%hi(.LC1)
	addi	a0,a0,%lo(.LC1)
	li	a7,2
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a0,0
	li	a7,173
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
	lui	a0,%hi(.LC2)
	addi	a0,a0,%lo(.LC2)
	li	a7,2
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
.L3:
	j	.L3
.L2:
	ble	a5,zero,.L4
	lui	a0,%hi(.LC3)
	addi	a0,a0,%lo(.LC3)
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
	lui	a0,%hi(.LC4)
	addi	a0,a0,%lo(.LC4)
	li	a7,2
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a7,1
	mv	a0,a5
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	lui	a0,%hi(.LC5)
	addi	a0,a0,%lo(.LC5)
	li	a7,2
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a0,0
	li	a7,221
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	sext.w	a5,a0
	lui	a0,%hi(.LC6)
	addi	a0,a0,%lo(.LC6)
	li	a7,2
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	lui	a0,%hi(.LC7)
	addi	a0,a0,%lo(.LC7)
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a7,1
	mv	a0,a5
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	lui	a0,%hi(.LC8)
	addi	a0,a0,%lo(.LC8)
	li	a7,2
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	lui	a0,%hi(.LC2)
	addi	a0,a0,%lo(.LC2)
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
.L5:
	j	.L5
.L4:
	lui	a0,%hi(.LC9)
	addi	a0,a0,%lo(.LC9)
	li	a7,2
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
.L6:
	j	.L6
	.size	main, .-main
	.ident	"GCC: (13.2.0-11ubuntu1+12) 13.2.0"
