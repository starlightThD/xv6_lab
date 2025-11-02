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
	.align	1
	.globl	usr_build_string_with_three_ints
	.type	usr_build_string_with_three_ints, @function
usr_build_string_with_three_ints:
	addi	sp,sp,-176
	sd	s0,160(sp)
	sd	s3,136(sp)
	sd	s4,128(sp)
	sd	s5,120(sp)
	sd	s6,112(sp)
	sd	s7,104(sp)
	sd	s8,96(sp)
	sd	ra,168(sp)
	sd	s1,152(sp)
	sd	s2,144(sp)
	mv	s5,a0
	mv	s7,a1
	mv	s6,a3
	mv	s0,a4
	mv	s4,a5
	mv	s8,a6
	mv	s3,a7
	beq	a2,zero,.L150
	mv	s2,sp
	mv	a1,s2
	mv	a0,a2
	call	usr_itoa.part.0
	beq	s0,zero,.L151
.L104:
	addi	s1,sp,32
	mv	a1,s1
	mv	a0,s0
	call	usr_itoa.part.0
	beq	s8,zero,.L152
.L106:
	addi	s0,sp,64
	mv	a1,s0
	mv	a0,s8
	call	usr_itoa.part.0
.L107:
	mv	a5,s5
.L108:
	lbu	a4,0(s7)
	addi	a5,a5,1
	addi	s7,s7,1
	sb	a4,-1(a5)
	bne	a4,zero,.L108
	lbu	a5,0(s5)
	beq	a5,zero,.L127
	addi	a4,s5,1
	mv	a6,a4
.L110:
	lbu	a5,0(a6)
	mv	a2,a6
	addi	a6,a6,1
	bne	a5,zero,.L110
.L109:
	mv	a1,s2
.L111:
	lbu	a5,0(a1)
	addi	a2,a2,1
	addi	a1,a1,1
	sb	a5,-1(a2)
	bne	a5,zero,.L111
	lbu	a5,0(s5)
	beq	a5,zero,.L128
	mv	a6,a4
.L113:
	lbu	a5,0(a6)
	mv	a2,a6
	addi	a6,a6,1
	bne	a5,zero,.L113
.L114:
	lbu	a5,0(s6)
	addi	a2,a2,1
	addi	s6,s6,1
	sb	a5,-1(a2)
	bne	a5,zero,.L114
.L153:
	lbu	a5,0(s5)
	beq	a5,zero,.L129
	mv	a2,a4
.L116:
	lbu	a5,0(a2)
	mv	a3,a2
	addi	a2,a2,1
	bne	a5,zero,.L116
.L115:
	mv	a1,s1
.L117:
	lbu	a5,0(a1)
	addi	a3,a3,1
	addi	a1,a1,1
	sb	a5,-1(a3)
	bne	a5,zero,.L117
	lbu	a5,0(s5)
	beq	a5,zero,.L130
	mv	a2,a4
.L119:
	lbu	a5,0(a2)
	mv	a3,a2
	addi	a2,a2,1
	bne	a5,zero,.L119
.L120:
	lbu	a5,0(s4)
	addi	a3,a3,1
	addi	s4,s4,1
	sb	a5,-1(a3)
	bne	a5,zero,.L120
.L154:
	lbu	a5,0(s5)
	beq	a5,zero,.L131
	mv	a3,a4
.L122:
	lbu	a2,0(a3)
	mv	a5,a3
	addi	a3,a3,1
	bne	a2,zero,.L122
.L121:
	mv	a1,s0
.L123:
	lbu	a3,0(a1)
	addi	a5,a5,1
	addi	a1,a1,1
	sb	a3,-1(a5)
	bne	a3,zero,.L123
	lbu	a5,0(s5)
	beq	a5,zero,.L126
.L125:
	lbu	a5,0(a4)
	addi	a4,a4,1
	bne	a5,zero,.L125
.L126:
	lbu	a5,0(s3)
	addi	a4,a4,1
	addi	s3,s3,1
	sb	a5,-2(a4)
	bne	a5,zero,.L126
	ld	ra,168(sp)
	ld	s0,160(sp)
	ld	s1,152(sp)
	ld	s2,144(sp)
	ld	s3,136(sp)
	ld	s4,128(sp)
	ld	s5,120(sp)
	ld	s6,112(sp)
	ld	s7,104(sp)
	ld	s8,96(sp)
	addi	sp,sp,176
	jr	ra
.L150:
	li	a5,48
	sh	a5,0(sp)
	mv	s2,sp
	bne	s0,zero,.L104
.L151:
	li	a5,48
	sh	a5,32(sp)
	addi	s1,sp,32
	bne	s8,zero,.L106
.L152:
	li	a5,48
	sh	a5,64(sp)
	addi	s0,sp,64
	j	.L107
.L131:
	mv	a5,s5
	j	.L121
.L127:
	mv	a2,s5
	addi	a4,s5,1
	j	.L109
.L128:
	lbu	a5,0(s6)
	mv	a2,s5
	addi	a2,a2,1
	sb	a5,-1(a2)
	addi	s6,s6,1
	bne	a5,zero,.L114
	j	.L153
.L129:
	mv	a3,s5
	j	.L115
.L130:
	lbu	a5,0(s4)
	mv	a3,s5
	addi	a3,a3,1
	sb	a5,-1(a3)
	addi	s4,s4,1
	bne	a5,zero,.L120
	j	.L154
	.size	usr_build_string_with_three_ints, .-usr_build_string_with_three_ints
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	" ===\n"
	.align	3
.LC1:
	.string	" ppid="
	.align	3
.LC2:
	.string	"=== Initial process: pid="
	.align	3
.LC3:
	.string	" started\n"
	.align	3
.LC4:
	.string	"[L1-Child1] pid="
	.align	3
.LC5:
	.string	" working\n"
	.align	3
.LC6:
	.string	"[L2-GChild1] pid="
	.align	3
.LC7:
	.string	"[L2-GChild2] pid="
	.align	3
.LC8:
	.string	", waiting...\n"
	.align	3
.LC9:
	.string	" and "
	.align	3
.LC10:
	.string	"[L1-Child1] created grandchildren: "
	.align	3
.LC11:
	.string	" exit\n"
	.align	3
.LC12:
	.string	"child "
	.align	3
.LC13:
	.string	"[L1-Child1] fork grandchild2 failed\n"
	.align	3
.LC14:
	.string	"[L1-Child1] fork grandchild1 failed\n"
	.align	3
.LC15:
	.string	"[L1-Child2] pid="
	.align	3
.LC16:
	.string	"[L2-GChild3] pid="
	.align	3
.LC17:
	.string	"[L2-GChild4] pid="
	.align	3
.LC18:
	.string	"[L1-Child2] created grandchildren: "
	.align	3
.LC19:
	.string	"[L1-Child2] fork grandchild4 failed\n"
	.align	3
.LC20:
	.string	"[L1-Child2] fork grandchild3 failed\n"
	.align	3
.LC21:
	.string	"[L0-Parent] created children: "
	.align	3
.LC22:
	.string	"=== Multi-level fork test completed successfully! ===\n"
	.align	3
.LC23:
	.string	"[L0-Parent] fork child2 failed\n"
	.align	3
.LC24:
	.string	"[L0-Parent] fork child1 failed\n"
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-288
	sd	ra,280(sp)
	sd	s0,272(sp)
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
	lui	s0,%hi(.LC1)
	lui	a5,%hi(.LC0)
	lui	a1,%hi(.LC2)
	sext.w	a4,a0
	addi	a5,a5,%lo(.LC0)
	mv	a0,sp
	addi	a3,s0,%lo(.LC1)
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
	li	a7,220
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	sext.w	a2,a0
	beq	a2,zero,.L182
	ble	a2,zero,.L166
	li	a0,0
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	sext.w	a4,a0
	beq	a4,zero,.L183
	bgt	a4,zero,.L184
	lui	a0,%hi(.LC23)
	addi	a0,a0,%lo(.LC23)
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
.L179:
	j	.L179
.L166:
	lui	a0,%hi(.LC24)
	addi	a0,a0,%lo(.LC24)
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
.L180:
	j	.L180
.L182:
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
	lui	a5,%hi(.LC3)
	lui	a1,%hi(.LC4)
	sext.w	a4,a0
	addi	a5,a5,%lo(.LC3)
	mv	a0,sp
	addi	a3,s0,%lo(.LC1)
	addi	a1,a1,%lo(.LC4)
	call	usr_build_string_with_two_ints
	mv	a0,sp
	li	a7,2
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a0,0
	li	a7,220
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	sext.w	a2,a0
	beq	a2,zero,.L185
	ble	a2,zero,.L159
	li	a0,0
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	sext.w	a4,a0
	beq	a4,zero,.L186
	bgt	a4,zero,.L187
	lui	a0,%hi(.LC13)
	addi	a0,a0,%lo(.LC13)
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
.L164:
	j	.L164
.L184:
	lui	a5,%hi(.LC8)
	lui	a3,%hi(.LC9)
	lui	a1,%hi(.LC21)
	mv	a0,sp
	addi	a5,a5,%lo(.LC8)
	addi	a3,a3,%lo(.LC9)
	addi	a1,a1,%lo(.LC21)
	sd	s1,264(sp)
	call	usr_build_string_with_two_ints
	mv	a0,sp
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
	lui	s1,%hi(.LC11)
	lui	s0,%hi(.LC12)
	sext.w	a2,a0
	addi	a3,s1,%lo(.LC11)
	mv	a0,sp
	addi	a1,s0,%lo(.LC12)
	call	usr_build_string_with_int
	mv	a0,sp
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
	sext.w	a2,a0
	addi	a3,s1,%lo(.LC11)
	mv	a0,sp
	addi	a1,s0,%lo(.LC12)
	call	usr_build_string_with_int
	mv	a0,sp
	li	a7,2
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	lui	a0,%hi(.LC22)
	addi	a0,a0,%lo(.LC22)
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
.L178:
	j	.L178
.L159:
	lui	a0,%hi(.LC14)
	addi	a0,a0,%lo(.LC14)
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
.L165:
	j	.L165
.L183:
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
	lui	a5,%hi(.LC3)
	lui	a1,%hi(.LC15)
	sext.w	a4,a0
	addi	a5,a5,%lo(.LC3)
	mv	a0,sp
	addi	a3,s0,%lo(.LC1)
	addi	a1,a1,%lo(.LC15)
	call	usr_build_string_with_two_ints
	mv	a0,sp
	li	a7,2
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	li	a0,0
	li	a7,220
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	sext.w	a2,a0
	beq	a2,zero,.L188
	ble	a2,zero,.L170
	li	a0,0
 #APP
# 14 "../syscall.h" 1
	ecall
# 0 "" 2
 #NO_APP
	sext.w	a4,a0
	beq	a4,zero,.L189
	bgt	a4,zero,.L190
	lui	a0,%hi(.LC19)
	addi	a0,a0,%lo(.LC19)
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
.L175:
	j	.L175
.L185:
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
	lui	a5,%hi(.LC5)
	lui	a1,%hi(.LC6)
	sext.w	a4,a0
	addi	a5,a5,%lo(.LC5)
	mv	a0,sp
	addi	a3,s0,%lo(.LC1)
	addi	a1,a1,%lo(.LC6)
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
.L158:
	j	.L158
.L189:
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
	lui	a5,%hi(.LC5)
	lui	a1,%hi(.LC17)
	sext.w	a4,a0
	addi	a5,a5,%lo(.LC5)
	mv	a0,sp
	addi	a3,s0,%lo(.LC1)
	addi	a1,a1,%lo(.LC17)
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
.L172:
	j	.L172
.L188:
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
	lui	a5,%hi(.LC5)
	lui	a1,%hi(.LC16)
	sext.w	a4,a0
	addi	a5,a5,%lo(.LC5)
	mv	a0,sp
	addi	a3,s0,%lo(.LC1)
	addi	a1,a1,%lo(.LC16)
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
.L169:
	j	.L169
.L186:
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
	lui	a5,%hi(.LC5)
	lui	a1,%hi(.LC7)
	sext.w	a4,a0
	addi	a5,a5,%lo(.LC5)
	mv	a0,sp
	addi	a3,s0,%lo(.LC1)
	addi	a1,a1,%lo(.LC7)
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
.L161:
	j	.L161
.L187:
	lui	a5,%hi(.LC8)
	lui	a3,%hi(.LC9)
	lui	a1,%hi(.LC10)
	mv	a0,sp
	addi	a5,a5,%lo(.LC8)
	addi	a3,a3,%lo(.LC9)
	addi	a1,a1,%lo(.LC10)
	sd	s1,264(sp)
	call	usr_build_string_with_two_ints
	mv	a0,sp
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
	lui	s1,%hi(.LC11)
	lui	s0,%hi(.LC12)
	sext.w	a2,a0
	addi	a3,s1,%lo(.LC11)
	mv	a0,sp
	addi	a1,s0,%lo(.LC12)
	call	usr_build_string_with_int
	mv	a0,sp
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
	sext.w	a2,a0
	addi	a3,s1,%lo(.LC11)
	mv	a0,sp
	addi	a1,s0,%lo(.LC12)
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
.L163:
	j	.L163
.L170:
	lui	a0,%hi(.LC20)
	addi	a0,a0,%lo(.LC20)
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
.L176:
	j	.L176
.L190:
	lui	a5,%hi(.LC8)
	lui	a3,%hi(.LC9)
	lui	a1,%hi(.LC18)
	mv	a0,sp
	addi	a5,a5,%lo(.LC8)
	addi	a3,a3,%lo(.LC9)
	addi	a1,a1,%lo(.LC18)
	sd	s1,264(sp)
	call	usr_build_string_with_two_ints
	mv	a0,sp
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
	lui	s1,%hi(.LC11)
	lui	s0,%hi(.LC12)
	sext.w	a2,a0
	addi	a3,s1,%lo(.LC11)
	mv	a0,sp
	addi	a1,s0,%lo(.LC12)
	call	usr_build_string_with_int
	mv	a0,sp
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
	sext.w	a2,a0
	addi	a3,s1,%lo(.LC11)
	mv	a0,sp
	addi	a1,s0,%lo(.LC12)
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
.L174:
	j	.L174
	.size	main, .-main
	.ident	"GCC: (13.2.0-11ubuntu1+12) 13.2.0"
