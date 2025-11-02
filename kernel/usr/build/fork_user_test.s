	.file	"fork_user_test.c"
	.option nopic
	.option norelax
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.type	usr_itoa.part.0, @function
usr_itoa.part.0:
	blt	a0,zero,.L17
	li	t3,0
	beq	a0,zero,.L18
.L5:
	mv	a4,a1
	mv	a2,a1
	li	a5,0
	li	a6,10
.L3:
	remw	a3,a0,a6
	addi	a2,a2,1
	addiw	a7,a5,1
	mv	t1,a5
	sext.w	a5,a7
	divw	a0,a0,a6
	addiw	a3,a3,48
	sb	a3,-1(a2)
	bne	a0,zero,.L3
	beq	t3,zero,.L7
	addiw	a3,t1,2
	add	a5,a1,a5
	li	a2,45
	sb	a2,0(a5)
	add	a5,a1,a3
	sb	zero,0(a5)
	sraiw	t1,a3,1
	mv	a5,a3
.L8:
	addiw	a5,a5,-1
	add	a5,a1,a5
	add	a1,a1,t1
.L9:
	lbu	a2,0(a5)
	lbu	a3,0(a4)
	addi	a4,a4,1
	addi	a5,a5,-1
	sb	a2,-1(a4)
	sb	a3,1(a5)
	bne	a1,a4,.L9
	ret
.L7:
	add	a3,a1,a5
	sb	zero,0(a3)
	sraiw	t1,a7,1
	bne	t1,zero,.L8
	ret
.L18:
	sb	zero,0(a1)
	ret
.L17:
	negw	a0,a0
	li	t3,1
	j	.L5
	.size	usr_itoa.part.0, .-usr_itoa.part.0
	.align	1
	.globl	usr_strlen
	.type	usr_strlen, @function
usr_strlen:
	lbu	a5,0(a0)
	beq	a5,zero,.L22
	addi	a0,a0,1
	mv	a5,a0
.L21:
	lbu	a4,0(a5)
	mv	a3,a5
	addi	a5,a5,1
	bne	a4,zero,.L21
	subw	a0,a3,a0
	addiw	a0,a0,1
	ret
.L22:
	li	a0,0
	ret
	.size	usr_strlen, .-usr_strlen
	.align	1
	.globl	usr_strcpy
	.type	usr_strcpy, @function
usr_strcpy:
.L25:
	lbu	a5,0(a1)
	addi	a0,a0,1
	addi	a1,a1,1
	sb	a5,-1(a0)
	bne	a5,zero,.L25
	ret
	.size	usr_strcpy, .-usr_strcpy
	.align	1
	.globl	usr_strcat
	.type	usr_strcat, @function
usr_strcat:
	lbu	a5,0(a0)
	beq	a5,zero,.L30
	addi	a5,a0,1
.L29:
	lbu	a4,0(a5)
	mv	a0,a5
	addi	a5,a5,1
	bne	a4,zero,.L29
.L30:
	lbu	a5,0(a1)
	addi	a0,a0,1
	addi	a1,a1,1
	sb	a5,-1(a0)
	bne	a5,zero,.L30
	ret
	.size	usr_strcat, .-usr_strcat
	.align	1
	.globl	usr_itoa
	.type	usr_itoa, @function
usr_itoa:
	beq	a0,zero,.L40
	tail	usr_itoa.part.0
.L40:
	li	a4,48
	sb	a4,0(a1)
	sb	zero,1(a1)
	ret
	.size	usr_itoa, .-usr_itoa
	.align	1
	.globl	usr_build_string_with_int
	.type	usr_build_string_with_int, @function
usr_build_string_with_int:
	addi	sp,sp,-80
	sd	s1,56(sp)
	sd	s2,48(sp)
	sd	s3,40(sp)
	sd	ra,72(sp)
	sd	s0,64(sp)
	mv	s3,a0
	mv	s2,a1
	mv	s1,a3
	beq	a2,zero,.L62
	mv	s0,sp
	mv	a0,a2
	mv	a1,s0
	call	usr_itoa.part.0
.L43:
	mv	a5,s3
.L44:
	lbu	a4,0(s2)
	addi	a5,a5,1
	addi	s2,s2,1
	sb	a4,-1(a5)
	bne	a4,zero,.L44
	lbu	a5,0(s3)
	beq	a5,zero,.L51
	addi	a5,s3,1
	mv	a2,a5
.L46:
	lbu	a3,0(a2)
	mv	a4,a2
	addi	a2,a2,1
	bne	a3,zero,.L46
.L45:
	mv	a1,s0
.L47:
	lbu	a3,0(a1)
	addi	a4,a4,1
	addi	a1,a1,1
	sb	a3,-1(a4)
	bne	a3,zero,.L47
	lbu	a4,0(s3)
	beq	a4,zero,.L50
.L49:
	lbu	a4,0(a5)
	addi	a5,a5,1
	bne	a4,zero,.L49
.L50:
	lbu	a4,0(s1)
	addi	a5,a5,1
	addi	s1,s1,1
	sb	a4,-2(a5)
	bne	a4,zero,.L50
	ld	ra,72(sp)
	ld	s0,64(sp)
	ld	s1,56(sp)
	ld	s2,48(sp)
	ld	s3,40(sp)
	addi	sp,sp,80
	jr	ra
.L62:
	li	a5,48
	sh	a5,0(sp)
	mv	s0,sp
	j	.L43
.L51:
	mv	a4,s3
	addi	a5,s3,1
	j	.L45
	.size	usr_build_string_with_int, .-usr_build_string_with_int
	.align	1
	.globl	usr_build_string_with_two_ints
	.type	usr_build_string_with_two_ints, @function
usr_build_string_with_two_ints:
	addi	sp,sp,-128
	sd	s2,96(sp)
	sd	s3,88(sp)
	sd	s4,80(sp)
	sd	s5,72(sp)
	sd	s6,64(sp)
	sd	ra,120(sp)
	sd	s0,112(sp)
	sd	s1,104(sp)
	mv	s5,a0
	mv	s4,a1
	mv	s3,a3
	mv	s6,a4
	mv	s2,a5
	beq	a2,zero,.L98
	mv	s1,sp
	mv	a1,s1
	mv	a0,a2
	call	usr_itoa.part.0
	beq	s6,zero,.L99
.L66:
	addi	s0,sp,32
	mv	a1,s0
	mv	a0,s6
	call	usr_itoa.part.0
.L67:
	mv	a5,s5
.L68:
	lbu	a4,0(s4)
	addi	a5,a5,1
	addi	s4,s4,1
	sb	a4,-1(a5)
	bne	a4,zero,.L68
	lbu	a5,0(s5)
	beq	a5,zero,.L81
	addi	a4,s5,1
	mv	a6,a4
.L70:
	lbu	a5,0(a6)
	mv	a2,a6
	addi	a6,a6,1
	bne	a5,zero,.L70
.L69:
	mv	a1,s1
.L71:
	lbu	a5,0(a1)
	addi	a2,a2,1
	addi	a1,a1,1
	sb	a5,-1(a2)
	bne	a5,zero,.L71
	lbu	a5,0(s5)
	beq	a5,zero,.L82
	mv	a6,a4
.L73:
	lbu	a5,0(a6)
	mv	a2,a6
	addi	a6,a6,1
	bne	a5,zero,.L73
.L74:
	lbu	a5,0(s3)
	addi	a2,a2,1
	addi	s3,s3,1
	sb	a5,-1(a2)
	bne	a5,zero,.L74
.L100:
	lbu	a5,0(s5)
	beq	a5,zero,.L83
	mv	a2,a4
.L76:
	lbu	a5,0(a2)
	mv	a3,a2
	addi	a2,a2,1
	bne	a5,zero,.L76
.L75:
	mv	a1,s0
.L77:
	lbu	a5,0(a1)
	addi	a3,a3,1
	addi	a1,a1,1
	sb	a5,-1(a3)
	bne	a5,zero,.L77
	lbu	a5,0(s5)
	beq	a5,zero,.L80
.L79:
	lbu	a5,0(a4)
	addi	a4,a4,1
	bne	a5,zero,.L79
.L80:
	lbu	a5,0(s2)
	addi	a4,a4,1
	addi	s2,s2,1
	sb	a5,-2(a4)
	bne	a5,zero,.L80
	ld	ra,120(sp)
	ld	s0,112(sp)
	ld	s1,104(sp)
	ld	s2,96(sp)
	ld	s3,88(sp)
	ld	s4,80(sp)
	ld	s5,72(sp)
	ld	s6,64(sp)
	addi	sp,sp,128
	jr	ra
.L98:
	li	a5,48
	sh	a5,0(sp)
	mv	s1,sp
	bne	s6,zero,.L66
.L99:
	li	a5,48
	sh	a5,32(sp)
	addi	s0,sp,32
	j	.L67
.L81:
	mv	a2,s5
	addi	a4,s5,1
	j	.L69
.L82:
	lbu	a5,0(s3)
	mv	a2,s5
	addi	a2,a2,1
	sb	a5,-1(a2)
	addi	s3,s3,1
	bne	a5,zero,.L74
	j	.L100
.L83:
	mv	a3,s5
	j	.L75
	.size	usr_build_string_with_two_ints, .-usr_build_string_with_two_ints
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"\n"
	.align	3
.LC1:
	.string	" ppid="
	.align	3
.LC2:
	.string	"child: "
	.align	3
.LC3:
	.string	" forked child="
	.align	3
.LC4:
	.string	"parent: "
	.align	3
.LC5:
	.string	"before wait\n"
	.align	3
.LC6:
	.string	"after wait\n"
	.align	3
.LC7:
	.string	" exited\n"
	.align	3
.LC8:
	.string	"parent: child "
	.align	3
.LC9:
	.string	"fork failed!\n"
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-272
	sd	ra,264(sp)
	li	a0,0
	li	a7,220
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	sext.w	a4,a0
	beq	a4,zero,.L108
	bgt	a4,zero,.L109
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
.L106:
	j	.L106
.L109:
	li	a0,0
	li	a7,172
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	lui	a5,%hi(.LC0)
	lui	a3,%hi(.LC3)
	lui	a1,%hi(.LC4)
	sext.w	a2,a0
	addi	a5,a5,%lo(.LC0)
	mv	a0,sp
	addi	a3,a3,%lo(.LC3)
	addi	a1,a1,%lo(.LC4)
	call	usr_build_string_with_two_ints
	mv	a0,sp
	li	a7,2
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	lui	a0,%hi(.LC5)
	addi	a0,a0,%lo(.LC5)
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
	sext.w	a2,a0
	lui	a0,%hi(.LC6)
	addi	a0,a0,%lo(.LC6)
	li	a7,2
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	lui	a3,%hi(.LC7)
	lui	a1,%hi(.LC8)
	mv	a0,sp
	addi	a3,a3,%lo(.LC7)
	addi	a1,a1,%lo(.LC8)
	call	usr_build_string_with_int
	mv	a0,sp
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
.L105:
	j	.L105
.L108:
	li	a0,0
	li	a7,172
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a7,173
	sext.w	a2,a0
	li	a0,0
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	lui	a5,%hi(.LC0)
	lui	a3,%hi(.LC1)
	lui	a1,%hi(.LC2)
	sext.w	a4,a0
	addi	a5,a5,%lo(.LC0)
	mv	a0,sp
	addi	a3,a3,%lo(.LC1)
	addi	a1,a1,%lo(.LC2)
	call	usr_build_string_with_two_ints
	mv	a0,sp
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
.L103:
	j	.L103
	.size	main, .-main
	.ident	"GCC: (13.2.0-11ubuntu1+12) 13.2.0"
