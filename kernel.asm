
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    80200000:	00006117          	auipc	sp,0x6
    80200004:	00010113          	mv	sp,sp
    80200008:	6511                	lui	a0,0x4
    8020000a:	912a                	add	sp,sp,a0
    8020000c:	00007517          	auipc	a0,0x7
    80200010:	01450513          	addi	a0,a0,20 # 80207020 <main_loop_start>
    80200014:	00007597          	auipc	a1,0x7
    80200018:	22c58593          	addi	a1,a1,556 # 80207240 <_bss_end>

000000008020001c <clear_bss>:
    8020001c:	00b57663          	bgeu	a0,a1,80200028 <bss_done>
    80200020:	00052023          	sw	zero,0(a0)
    80200024:	0511                	addi	a0,a0,4
    80200026:	bfdd                	j	8020001c <clear_bss>

0000000080200028 <bss_done>:
    80200028:	00000097          	auipc	ra,0x0
    8020002c:	090080e7          	jalr	144(ra) # 802000b8 <start>

0000000080200030 <spin>:
    80200030:	a001                	j	80200030 <spin>

0000000080200032 <r_sstatus>:
    80200032:	1101                	addi	sp,sp,-32 # 80205fe0 <initialized_global+0xfe0>
    80200034:	ec22                	sd	s0,24(sp)
    80200036:	1000                	addi	s0,sp,32
    80200038:	100027f3          	csrr	a5,sstatus
    8020003c:	fef43423          	sd	a5,-24(s0)
    80200040:	fe843783          	ld	a5,-24(s0)
    80200044:	853e                	mv	a0,a5
    80200046:	6462                	ld	s0,24(sp)
    80200048:	6105                	addi	sp,sp,32
    8020004a:	8082                	ret

000000008020004c <w_sstatus>:
    8020004c:	1101                	addi	sp,sp,-32
    8020004e:	ec22                	sd	s0,24(sp)
    80200050:	1000                	addi	s0,sp,32
    80200052:	fea43423          	sd	a0,-24(s0)
    80200056:	fe843783          	ld	a5,-24(s0)
    8020005a:	10079073          	csrw	sstatus,a5
    8020005e:	0001                	nop
    80200060:	6462                	ld	s0,24(sp)
    80200062:	6105                	addi	sp,sp,32
    80200064:	8082                	ret

0000000080200066 <intr_on>:
    80200066:	1141                	addi	sp,sp,-16
    80200068:	e406                	sd	ra,8(sp)
    8020006a:	e022                	sd	s0,0(sp)
    8020006c:	0800                	addi	s0,sp,16
    8020006e:	00000097          	auipc	ra,0x0
    80200072:	fc4080e7          	jalr	-60(ra) # 80200032 <r_sstatus>
    80200076:	87aa                	mv	a5,a0
    80200078:	0027e793          	ori	a5,a5,2
    8020007c:	853e                	mv	a0,a5
    8020007e:	00000097          	auipc	ra,0x0
    80200082:	fce080e7          	jalr	-50(ra) # 8020004c <w_sstatus>
    80200086:	0001                	nop
    80200088:	60a2                	ld	ra,8(sp)
    8020008a:	6402                	ld	s0,0(sp)
    8020008c:	0141                	addi	sp,sp,16
    8020008e:	8082                	ret

0000000080200090 <intr_off>:
    80200090:	1141                	addi	sp,sp,-16
    80200092:	e406                	sd	ra,8(sp)
    80200094:	e022                	sd	s0,0(sp)
    80200096:	0800                	addi	s0,sp,16
    80200098:	00000097          	auipc	ra,0x0
    8020009c:	f9a080e7          	jalr	-102(ra) # 80200032 <r_sstatus>
    802000a0:	87aa                	mv	a5,a0
    802000a2:	9bf5                	andi	a5,a5,-3
    802000a4:	853e                	mv	a0,a5
    802000a6:	00000097          	auipc	ra,0x0
    802000aa:	fa6080e7          	jalr	-90(ra) # 8020004c <w_sstatus>
    802000ae:	0001                	nop
    802000b0:	60a2                	ld	ra,8(sp)
    802000b2:	6402                	ld	s0,0(sp)
    802000b4:	0141                	addi	sp,sp,16
    802000b6:	8082                	ret

00000000802000b8 <start>:
    802000b8:	1101                	addi	sp,sp,-32
    802000ba:	ec06                	sd	ra,24(sp)
    802000bc:	e822                	sd	s0,16(sp)
    802000be:	1000                	addi	s0,sp,32
    802000c0:	00002097          	auipc	ra,0x2
    802000c4:	e24080e7          	jalr	-476(ra) # 80201ee4 <pmm_init>
    802000c8:	00001097          	auipc	ra,0x1
    802000cc:	888080e7          	jalr	-1912(ra) # 80200950 <clear_screen>
    802000d0:	00003517          	auipc	a0,0x3
    802000d4:	f3050513          	addi	a0,a0,-208 # 80203000 <etext>
    802000d8:	00000097          	auipc	ra,0x0
    802000dc:	192080e7          	jalr	402(ra) # 8020026a <uart_puts>
    802000e0:	00003517          	auipc	a0,0x3
    802000e4:	f5850513          	addi	a0,a0,-168 # 80203038 <etext+0x38>
    802000e8:	00000097          	auipc	ra,0x0
    802000ec:	182080e7          	jalr	386(ra) # 8020026a <uart_puts>
    802000f0:	00003517          	auipc	a0,0x3
    802000f4:	f7850513          	addi	a0,a0,-136 # 80203068 <etext+0x68>
    802000f8:	00000097          	auipc	ra,0x0
    802000fc:	172080e7          	jalr	370(ra) # 8020026a <uart_puts>
    80200100:	00002097          	auipc	ra,0x2
    80200104:	358080e7          	jalr	856(ra) # 80202458 <trap_init>
    80200108:	00003517          	auipc	a0,0x3
    8020010c:	f9850513          	addi	a0,a0,-104 # 802030a0 <etext+0xa0>
    80200110:	00000097          	auipc	ra,0x0
    80200114:	15a080e7          	jalr	346(ra) # 8020026a <uart_puts>
    80200118:	00000097          	auipc	ra,0x0
    8020011c:	f4e080e7          	jalr	-178(ra) # 80200066 <intr_on>
    80200120:	fe042623          	sw	zero,-20(s0)
    80200124:	00000717          	auipc	a4,0x0
    80200128:	05070713          	addi	a4,a4,80 # 80200174 <start+0xbc>
    8020012c:	00007797          	auipc	a5,0x7
    80200130:	ef478793          	addi	a5,a5,-268 # 80207020 <main_loop_start>
    80200134:	e398                	sd	a4,0(a5)
    80200136:	00000797          	auipc	a5,0x0
    8020013a:	0f878793          	addi	a5,a5,248 # 8020022e <start+0x176>
    8020013e:	01078713          	addi	a4,a5,16
    80200142:	00007797          	auipc	a5,0x7
    80200146:	ee678793          	addi	a5,a5,-282 # 80207028 <main_loop_end>
    8020014a:	e398                	sd	a4,0(a5)
    8020014c:	00007797          	auipc	a5,0x7
    80200150:	ed478793          	addi	a5,a5,-300 # 80207020 <main_loop_start>
    80200154:	6398                	ld	a4,0(a5)
    80200156:	00007797          	auipc	a5,0x7
    8020015a:	ed278793          	addi	a5,a5,-302 # 80207028 <main_loop_end>
    8020015e:	639c                	ld	a5,0(a5)
    80200160:	863e                	mv	a2,a5
    80200162:	85ba                	mv	a1,a4
    80200164:	00003517          	auipc	a0,0x3
    80200168:	f6450513          	addi	a0,a0,-156 # 802030c8 <etext+0xc8>
    8020016c:	00000097          	auipc	ra,0x0
    80200170:	3ec080e7          	jalr	1004(ra) # 80200558 <printf>
    80200174:	fec42783          	lw	a5,-20(s0)
    80200178:	2785                	addiw	a5,a5,1
    8020017a:	fef42623          	sw	a5,-20(s0)
    8020017e:	00000097          	auipc	ra,0x0
    80200182:	f12080e7          	jalr	-238(ra) # 80200090 <intr_off>
    80200186:	0001                	nop
    80200188:	00000617          	auipc	a2,0x0
    8020018c:	03660613          	addi	a2,a2,54 # 802001be <start+0x106>
    80200190:	00000597          	auipc	a1,0x0
    80200194:	01858593          	addi	a1,a1,24 # 802001a8 <start+0xf0>
    80200198:	00003517          	auipc	a0,0x3
    8020019c:	f5850513          	addi	a0,a0,-168 # 802030f0 <etext+0xf0>
    802001a0:	00000097          	auipc	ra,0x0
    802001a4:	3b8080e7          	jalr	952(ra) # 80200558 <printf>
    802001a8:	fec42783          	lw	a5,-20(s0)
    802001ac:	85be                	mv	a1,a5
    802001ae:	00003517          	auipc	a0,0x3
    802001b2:	f6250513          	addi	a0,a0,-158 # 80203110 <etext+0x110>
    802001b6:	00000097          	auipc	ra,0x0
    802001ba:	3a2080e7          	jalr	930(ra) # 80200558 <printf>
    802001be:	0001                	nop
    802001c0:	00000597          	auipc	a1,0x0
    802001c4:	02058593          	addi	a1,a1,32 # 802001e0 <start+0x128>
    802001c8:	00003517          	auipc	a0,0x3
    802001cc:	f6850513          	addi	a0,a0,-152 # 80203130 <etext+0x130>
    802001d0:	00000097          	auipc	ra,0x0
    802001d4:	388080e7          	jalr	904(ra) # 80200558 <printf>
    802001d8:	00000097          	auipc	ra,0x0
    802001dc:	e8e080e7          	jalr	-370(ra) # 80200066 <intr_on>
    802001e0:	fe042423          	sw	zero,-24(s0)
    802001e4:	a809                	j	802001f6 <start+0x13e>
    802001e6:	0001                	nop
    802001e8:	fe842783          	lw	a5,-24(s0)
    802001ec:	2781                	sext.w	a5,a5
    802001ee:	2785                	addiw	a5,a5,1
    802001f0:	2781                	sext.w	a5,a5
    802001f2:	fef42423          	sw	a5,-24(s0)
    802001f6:	fe842783          	lw	a5,-24(s0)
    802001fa:	2781                	sext.w	a5,a5
    802001fc:	873e                	mv	a4,a5
    802001fe:	3e700793          	li	a5,999
    80200202:	fee7d2e3          	bge	a5,a4,802001e6 <start+0x12e>
    80200206:	00000097          	auipc	ra,0x0
    8020020a:	e8a080e7          	jalr	-374(ra) # 80200090 <intr_off>
    8020020e:	00000597          	auipc	a1,0x0
    80200212:	02058593          	addi	a1,a1,32 # 8020022e <start+0x176>
    80200216:	00003517          	auipc	a0,0x3
    8020021a:	f3a50513          	addi	a0,a0,-198 # 80203150 <etext+0x150>
    8020021e:	00000097          	auipc	ra,0x0
    80200222:	33a080e7          	jalr	826(ra) # 80200558 <printf>
    80200226:	00000097          	auipc	ra,0x0
    8020022a:	e40080e7          	jalr	-448(ra) # 80200066 <intr_on>
    8020022e:	b799                	j	80200174 <start+0xbc>

0000000080200230 <uart_putc>:
    80200230:	1101                	addi	sp,sp,-32
    80200232:	ec22                	sd	s0,24(sp)
    80200234:	1000                	addi	s0,sp,32
    80200236:	87aa                	mv	a5,a0
    80200238:	fef407a3          	sb	a5,-17(s0)
    8020023c:	0001                	nop
    8020023e:	100007b7          	lui	a5,0x10000
    80200242:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200244:	0007c783          	lbu	a5,0(a5)
    80200248:	0ff7f793          	zext.b	a5,a5
    8020024c:	2781                	sext.w	a5,a5
    8020024e:	0207f793          	andi	a5,a5,32
    80200252:	2781                	sext.w	a5,a5
    80200254:	d7ed                	beqz	a5,8020023e <uart_putc+0xe>
    80200256:	100007b7          	lui	a5,0x10000
    8020025a:	fef44703          	lbu	a4,-17(s0)
    8020025e:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
    80200262:	0001                	nop
    80200264:	6462                	ld	s0,24(sp)
    80200266:	6105                	addi	sp,sp,32
    80200268:	8082                	ret

000000008020026a <uart_puts>:
    8020026a:	7179                	addi	sp,sp,-48
    8020026c:	f422                	sd	s0,40(sp)
    8020026e:	1800                	addi	s0,sp,48
    80200270:	fca43c23          	sd	a0,-40(s0)
    80200274:	fd843783          	ld	a5,-40(s0)
    80200278:	c7b5                	beqz	a5,802002e4 <uart_puts+0x7a>
    8020027a:	a8b9                	j	802002d8 <uart_puts+0x6e>
    8020027c:	0001                	nop
    8020027e:	100007b7          	lui	a5,0x10000
    80200282:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200284:	0007c783          	lbu	a5,0(a5)
    80200288:	0ff7f793          	zext.b	a5,a5
    8020028c:	2781                	sext.w	a5,a5
    8020028e:	0207f793          	andi	a5,a5,32
    80200292:	2781                	sext.w	a5,a5
    80200294:	d7ed                	beqz	a5,8020027e <uart_puts+0x14>
    80200296:	fe042623          	sw	zero,-20(s0)
    8020029a:	a01d                	j	802002c0 <uart_puts+0x56>
    8020029c:	100007b7          	lui	a5,0x10000
    802002a0:	fd843703          	ld	a4,-40(s0)
    802002a4:	00074703          	lbu	a4,0(a4)
    802002a8:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
    802002ac:	fd843783          	ld	a5,-40(s0)
    802002b0:	0785                	addi	a5,a5,1
    802002b2:	fcf43c23          	sd	a5,-40(s0)
    802002b6:	fec42783          	lw	a5,-20(s0)
    802002ba:	2785                	addiw	a5,a5,1
    802002bc:	fef42623          	sw	a5,-20(s0)
    802002c0:	fd843783          	ld	a5,-40(s0)
    802002c4:	0007c783          	lbu	a5,0(a5)
    802002c8:	cb81                	beqz	a5,802002d8 <uart_puts+0x6e>
    802002ca:	fec42783          	lw	a5,-20(s0)
    802002ce:	0007871b          	sext.w	a4,a5
    802002d2:	478d                	li	a5,3
    802002d4:	fce7d4e3          	bge	a5,a4,8020029c <uart_puts+0x32>
    802002d8:	fd843783          	ld	a5,-40(s0)
    802002dc:	0007c783          	lbu	a5,0(a5)
    802002e0:	ffd1                	bnez	a5,8020027c <uart_puts+0x12>
    802002e2:	a011                	j	802002e6 <uart_puts+0x7c>
    802002e4:	0001                	nop
    802002e6:	7422                	ld	s0,40(sp)
    802002e8:	6145                	addi	sp,sp,48
    802002ea:	8082                	ret

00000000802002ec <flush_printf_buffer>:
    802002ec:	1141                	addi	sp,sp,-16
    802002ee:	e406                	sd	ra,8(sp)
    802002f0:	e022                	sd	s0,0(sp)
    802002f2:	0800                	addi	s0,sp,16
    802002f4:	00007797          	auipc	a5,0x7
    802002f8:	e0478793          	addi	a5,a5,-508 # 802070f8 <printf_buf_pos>
    802002fc:	439c                	lw	a5,0(a5)
    802002fe:	02f05c63          	blez	a5,80200336 <flush_printf_buffer+0x4a>
    80200302:	00007797          	auipc	a5,0x7
    80200306:	df678793          	addi	a5,a5,-522 # 802070f8 <printf_buf_pos>
    8020030a:	439c                	lw	a5,0(a5)
    8020030c:	00007717          	auipc	a4,0x7
    80200310:	d6c70713          	addi	a4,a4,-660 # 80207078 <printf_buffer>
    80200314:	97ba                	add	a5,a5,a4
    80200316:	00078023          	sb	zero,0(a5)
    8020031a:	00007517          	auipc	a0,0x7
    8020031e:	d5e50513          	addi	a0,a0,-674 # 80207078 <printf_buffer>
    80200322:	00000097          	auipc	ra,0x0
    80200326:	f48080e7          	jalr	-184(ra) # 8020026a <uart_puts>
    8020032a:	00007797          	auipc	a5,0x7
    8020032e:	dce78793          	addi	a5,a5,-562 # 802070f8 <printf_buf_pos>
    80200332:	0007a023          	sw	zero,0(a5)
    80200336:	0001                	nop
    80200338:	60a2                	ld	ra,8(sp)
    8020033a:	6402                	ld	s0,0(sp)
    8020033c:	0141                	addi	sp,sp,16
    8020033e:	8082                	ret

0000000080200340 <buffer_char>:
    80200340:	1101                	addi	sp,sp,-32
    80200342:	ec06                	sd	ra,24(sp)
    80200344:	e822                	sd	s0,16(sp)
    80200346:	1000                	addi	s0,sp,32
    80200348:	87aa                	mv	a5,a0
    8020034a:	fef407a3          	sb	a5,-17(s0)
    8020034e:	00007797          	auipc	a5,0x7
    80200352:	daa78793          	addi	a5,a5,-598 # 802070f8 <printf_buf_pos>
    80200356:	439c                	lw	a5,0(a5)
    80200358:	873e                	mv	a4,a5
    8020035a:	07e00793          	li	a5,126
    8020035e:	02e7ca63          	blt	a5,a4,80200392 <buffer_char+0x52>
    80200362:	00007797          	auipc	a5,0x7
    80200366:	d9678793          	addi	a5,a5,-618 # 802070f8 <printf_buf_pos>
    8020036a:	439c                	lw	a5,0(a5)
    8020036c:	0017871b          	addiw	a4,a5,1
    80200370:	0007069b          	sext.w	a3,a4
    80200374:	00007717          	auipc	a4,0x7
    80200378:	d8470713          	addi	a4,a4,-636 # 802070f8 <printf_buf_pos>
    8020037c:	c314                	sw	a3,0(a4)
    8020037e:	00007717          	auipc	a4,0x7
    80200382:	cfa70713          	addi	a4,a4,-774 # 80207078 <printf_buffer>
    80200386:	97ba                	add	a5,a5,a4
    80200388:	fef44703          	lbu	a4,-17(s0)
    8020038c:	00e78023          	sb	a4,0(a5)
    80200390:	a825                	j	802003c8 <buffer_char+0x88>
    80200392:	00000097          	auipc	ra,0x0
    80200396:	f5a080e7          	jalr	-166(ra) # 802002ec <flush_printf_buffer>
    8020039a:	00007797          	auipc	a5,0x7
    8020039e:	d5e78793          	addi	a5,a5,-674 # 802070f8 <printf_buf_pos>
    802003a2:	439c                	lw	a5,0(a5)
    802003a4:	0017871b          	addiw	a4,a5,1
    802003a8:	0007069b          	sext.w	a3,a4
    802003ac:	00007717          	auipc	a4,0x7
    802003b0:	d4c70713          	addi	a4,a4,-692 # 802070f8 <printf_buf_pos>
    802003b4:	c314                	sw	a3,0(a4)
    802003b6:	00007717          	auipc	a4,0x7
    802003ba:	cc270713          	addi	a4,a4,-830 # 80207078 <printf_buffer>
    802003be:	97ba                	add	a5,a5,a4
    802003c0:	fef44703          	lbu	a4,-17(s0)
    802003c4:	00e78023          	sb	a4,0(a5)
    802003c8:	0001                	nop
    802003ca:	60e2                	ld	ra,24(sp)
    802003cc:	6442                	ld	s0,16(sp)
    802003ce:	6105                	addi	sp,sp,32
    802003d0:	8082                	ret

00000000802003d2 <consputc>:
    802003d2:	1101                	addi	sp,sp,-32
    802003d4:	ec06                	sd	ra,24(sp)
    802003d6:	e822                	sd	s0,16(sp)
    802003d8:	1000                	addi	s0,sp,32
    802003da:	87aa                	mv	a5,a0
    802003dc:	fef42623          	sw	a5,-20(s0)
    802003e0:	fec42783          	lw	a5,-20(s0)
    802003e4:	0ff7f793          	zext.b	a5,a5
    802003e8:	853e                	mv	a0,a5
    802003ea:	00000097          	auipc	ra,0x0
    802003ee:	e46080e7          	jalr	-442(ra) # 80200230 <uart_putc>
    802003f2:	0001                	nop
    802003f4:	60e2                	ld	ra,24(sp)
    802003f6:	6442                	ld	s0,16(sp)
    802003f8:	6105                	addi	sp,sp,32
    802003fa:	8082                	ret

00000000802003fc <consputs>:
    802003fc:	7179                	addi	sp,sp,-48
    802003fe:	f406                	sd	ra,40(sp)
    80200400:	f022                	sd	s0,32(sp)
    80200402:	1800                	addi	s0,sp,48
    80200404:	fca43c23          	sd	a0,-40(s0)
    80200408:	fd843783          	ld	a5,-40(s0)
    8020040c:	fef43423          	sd	a5,-24(s0)
    80200410:	fe843503          	ld	a0,-24(s0)
    80200414:	00000097          	auipc	ra,0x0
    80200418:	e56080e7          	jalr	-426(ra) # 8020026a <uart_puts>
    8020041c:	0001                	nop
    8020041e:	70a2                	ld	ra,40(sp)
    80200420:	7402                	ld	s0,32(sp)
    80200422:	6145                	addi	sp,sp,48
    80200424:	8082                	ret

0000000080200426 <printint>:
    80200426:	715d                	addi	sp,sp,-80
    80200428:	e486                	sd	ra,72(sp)
    8020042a:	e0a2                	sd	s0,64(sp)
    8020042c:	0880                	addi	s0,sp,80
    8020042e:	faa43c23          	sd	a0,-72(s0)
    80200432:	87ae                	mv	a5,a1
    80200434:	8732                	mv	a4,a2
    80200436:	faf42a23          	sw	a5,-76(s0)
    8020043a:	87ba                	mv	a5,a4
    8020043c:	faf42823          	sw	a5,-80(s0)
    80200440:	fb042783          	lw	a5,-80(s0)
    80200444:	2781                	sext.w	a5,a5
    80200446:	c39d                	beqz	a5,8020046c <printint+0x46>
    80200448:	fb843783          	ld	a5,-72(s0)
    8020044c:	93fd                	srli	a5,a5,0x3f
    8020044e:	0ff7f793          	zext.b	a5,a5
    80200452:	faf42823          	sw	a5,-80(s0)
    80200456:	fb042783          	lw	a5,-80(s0)
    8020045a:	2781                	sext.w	a5,a5
    8020045c:	cb81                	beqz	a5,8020046c <printint+0x46>
    8020045e:	fb843783          	ld	a5,-72(s0)
    80200462:	40f007b3          	neg	a5,a5
    80200466:	fef43023          	sd	a5,-32(s0)
    8020046a:	a029                	j	80200474 <printint+0x4e>
    8020046c:	fb843783          	ld	a5,-72(s0)
    80200470:	fef43023          	sd	a5,-32(s0)
    80200474:	fb442783          	lw	a5,-76(s0)
    80200478:	0007871b          	sext.w	a4,a5
    8020047c:	47a9                	li	a5,10
    8020047e:	02f71763          	bne	a4,a5,802004ac <printint+0x86>
    80200482:	fe043703          	ld	a4,-32(s0)
    80200486:	06300793          	li	a5,99
    8020048a:	02e7e163          	bltu	a5,a4,802004ac <printint+0x86>
    8020048e:	fe043783          	ld	a5,-32(s0)
    80200492:	00279713          	slli	a4,a5,0x2
    80200496:	00003797          	auipc	a5,0x3
    8020049a:	cea78793          	addi	a5,a5,-790 # 80203180 <small_numbers>
    8020049e:	97ba                	add	a5,a5,a4
    802004a0:	853e                	mv	a0,a5
    802004a2:	00000097          	auipc	ra,0x0
    802004a6:	f5a080e7          	jalr	-166(ra) # 802003fc <consputs>
    802004aa:	a05d                	j	80200550 <printint+0x12a>
    802004ac:	fe042623          	sw	zero,-20(s0)
    802004b0:	fb442783          	lw	a5,-76(s0)
    802004b4:	fe043703          	ld	a4,-32(s0)
    802004b8:	02f777b3          	remu	a5,a4,a5
    802004bc:	00007717          	auipc	a4,0x7
    802004c0:	b4470713          	addi	a4,a4,-1212 # 80207000 <digits.0>
    802004c4:	97ba                	add	a5,a5,a4
    802004c6:	0007c703          	lbu	a4,0(a5)
    802004ca:	fec42783          	lw	a5,-20(s0)
    802004ce:	17c1                	addi	a5,a5,-16
    802004d0:	97a2                	add	a5,a5,s0
    802004d2:	fce78c23          	sb	a4,-40(a5)
    802004d6:	fec42783          	lw	a5,-20(s0)
    802004da:	2785                	addiw	a5,a5,1
    802004dc:	fef42623          	sw	a5,-20(s0)
    802004e0:	fb442783          	lw	a5,-76(s0)
    802004e4:	fe043703          	ld	a4,-32(s0)
    802004e8:	02f757b3          	divu	a5,a4,a5
    802004ec:	fef43023          	sd	a5,-32(s0)
    802004f0:	fe043783          	ld	a5,-32(s0)
    802004f4:	ffd5                	bnez	a5,802004b0 <printint+0x8a>
    802004f6:	fb042783          	lw	a5,-80(s0)
    802004fa:	2781                	sext.w	a5,a5
    802004fc:	cf91                	beqz	a5,80200518 <printint+0xf2>
    802004fe:	fec42783          	lw	a5,-20(s0)
    80200502:	17c1                	addi	a5,a5,-16
    80200504:	97a2                	add	a5,a5,s0
    80200506:	02d00713          	li	a4,45
    8020050a:	fce78c23          	sb	a4,-40(a5)
    8020050e:	fec42783          	lw	a5,-20(s0)
    80200512:	2785                	addiw	a5,a5,1
    80200514:	fef42623          	sw	a5,-20(s0)
    80200518:	fec42783          	lw	a5,-20(s0)
    8020051c:	37fd                	addiw	a5,a5,-1
    8020051e:	fef42623          	sw	a5,-20(s0)
    80200522:	a015                	j	80200546 <printint+0x120>
    80200524:	fec42783          	lw	a5,-20(s0)
    80200528:	17c1                	addi	a5,a5,-16
    8020052a:	97a2                	add	a5,a5,s0
    8020052c:	fd87c783          	lbu	a5,-40(a5)
    80200530:	2781                	sext.w	a5,a5
    80200532:	853e                	mv	a0,a5
    80200534:	00000097          	auipc	ra,0x0
    80200538:	e9e080e7          	jalr	-354(ra) # 802003d2 <consputc>
    8020053c:	fec42783          	lw	a5,-20(s0)
    80200540:	37fd                	addiw	a5,a5,-1
    80200542:	fef42623          	sw	a5,-20(s0)
    80200546:	fec42783          	lw	a5,-20(s0)
    8020054a:	2781                	sext.w	a5,a5
    8020054c:	fc07dce3          	bgez	a5,80200524 <printint+0xfe>
    80200550:	60a6                	ld	ra,72(sp)
    80200552:	6406                	ld	s0,64(sp)
    80200554:	6161                	addi	sp,sp,80
    80200556:	8082                	ret

0000000080200558 <printf>:
    80200558:	7171                	addi	sp,sp,-176
    8020055a:	f486                	sd	ra,104(sp)
    8020055c:	f0a2                	sd	s0,96(sp)
    8020055e:	1880                	addi	s0,sp,112
    80200560:	f8a43c23          	sd	a0,-104(s0)
    80200564:	e40c                	sd	a1,8(s0)
    80200566:	e810                	sd	a2,16(s0)
    80200568:	ec14                	sd	a3,24(s0)
    8020056a:	f018                	sd	a4,32(s0)
    8020056c:	f41c                	sd	a5,40(s0)
    8020056e:	03043823          	sd	a6,48(s0)
    80200572:	03143c23          	sd	a7,56(s0)
    80200576:	04040793          	addi	a5,s0,64
    8020057a:	f8f43823          	sd	a5,-112(s0)
    8020057e:	f9043783          	ld	a5,-112(s0)
    80200582:	fc878793          	addi	a5,a5,-56
    80200586:	fcf43023          	sd	a5,-64(s0)
    8020058a:	fe042623          	sw	zero,-20(s0)
    8020058e:	a671                	j	8020091a <printf+0x3c2>
    80200590:	fe842783          	lw	a5,-24(s0)
    80200594:	0007871b          	sext.w	a4,a5
    80200598:	02500793          	li	a5,37
    8020059c:	00f70c63          	beq	a4,a5,802005b4 <printf+0x5c>
    802005a0:	fe842783          	lw	a5,-24(s0)
    802005a4:	0ff7f793          	zext.b	a5,a5
    802005a8:	853e                	mv	a0,a5
    802005aa:	00000097          	auipc	ra,0x0
    802005ae:	d96080e7          	jalr	-618(ra) # 80200340 <buffer_char>
    802005b2:	aeb9                	j	80200910 <printf+0x3b8>
    802005b4:	00000097          	auipc	ra,0x0
    802005b8:	d38080e7          	jalr	-712(ra) # 802002ec <flush_printf_buffer>
    802005bc:	fec42783          	lw	a5,-20(s0)
    802005c0:	2785                	addiw	a5,a5,1
    802005c2:	fef42623          	sw	a5,-20(s0)
    802005c6:	fec42783          	lw	a5,-20(s0)
    802005ca:	f9843703          	ld	a4,-104(s0)
    802005ce:	97ba                	add	a5,a5,a4
    802005d0:	0007c783          	lbu	a5,0(a5)
    802005d4:	fef42423          	sw	a5,-24(s0)
    802005d8:	fe842783          	lw	a5,-24(s0)
    802005dc:	2781                	sext.w	a5,a5
    802005de:	34078d63          	beqz	a5,80200938 <printf+0x3e0>
    802005e2:	fc042e23          	sw	zero,-36(s0)
    802005e6:	fe842783          	lw	a5,-24(s0)
    802005ea:	0007871b          	sext.w	a4,a5
    802005ee:	06c00793          	li	a5,108
    802005f2:	02f71863          	bne	a4,a5,80200622 <printf+0xca>
    802005f6:	4785                	li	a5,1
    802005f8:	fcf42e23          	sw	a5,-36(s0)
    802005fc:	fec42783          	lw	a5,-20(s0)
    80200600:	2785                	addiw	a5,a5,1
    80200602:	fef42623          	sw	a5,-20(s0)
    80200606:	fec42783          	lw	a5,-20(s0)
    8020060a:	f9843703          	ld	a4,-104(s0)
    8020060e:	97ba                	add	a5,a5,a4
    80200610:	0007c783          	lbu	a5,0(a5)
    80200614:	fef42423          	sw	a5,-24(s0)
    80200618:	fe842783          	lw	a5,-24(s0)
    8020061c:	2781                	sext.w	a5,a5
    8020061e:	30078f63          	beqz	a5,8020093c <printf+0x3e4>
    80200622:	fe842783          	lw	a5,-24(s0)
    80200626:	0007871b          	sext.w	a4,a5
    8020062a:	02500793          	li	a5,37
    8020062e:	2af70063          	beq	a4,a5,802008ce <printf+0x376>
    80200632:	fe842783          	lw	a5,-24(s0)
    80200636:	0007871b          	sext.w	a4,a5
    8020063a:	02500793          	li	a5,37
    8020063e:	28f74f63          	blt	a4,a5,802008dc <printf+0x384>
    80200642:	fe842783          	lw	a5,-24(s0)
    80200646:	0007871b          	sext.w	a4,a5
    8020064a:	07800793          	li	a5,120
    8020064e:	28e7c763          	blt	a5,a4,802008dc <printf+0x384>
    80200652:	fe842783          	lw	a5,-24(s0)
    80200656:	0007871b          	sext.w	a4,a5
    8020065a:	06200793          	li	a5,98
    8020065e:	26f74f63          	blt	a4,a5,802008dc <printf+0x384>
    80200662:	fe842783          	lw	a5,-24(s0)
    80200666:	f9e7869b          	addiw	a3,a5,-98
    8020066a:	0006871b          	sext.w	a4,a3
    8020066e:	47d9                	li	a5,22
    80200670:	26e7e663          	bltu	a5,a4,802008dc <printf+0x384>
    80200674:	02069793          	slli	a5,a3,0x20
    80200678:	9381                	srli	a5,a5,0x20
    8020067a:	00279713          	slli	a4,a5,0x2
    8020067e:	00003797          	auipc	a5,0x3
    80200682:	cb678793          	addi	a5,a5,-842 # 80203334 <small_numbers+0x1b4>
    80200686:	97ba                	add	a5,a5,a4
    80200688:	439c                	lw	a5,0(a5)
    8020068a:	0007871b          	sext.w	a4,a5
    8020068e:	00003797          	auipc	a5,0x3
    80200692:	ca678793          	addi	a5,a5,-858 # 80203334 <small_numbers+0x1b4>
    80200696:	97ba                	add	a5,a5,a4
    80200698:	8782                	jr	a5
    8020069a:	fdc42783          	lw	a5,-36(s0)
    8020069e:	2781                	sext.w	a5,a5
    802006a0:	c385                	beqz	a5,802006c0 <printf+0x168>
    802006a2:	fc043783          	ld	a5,-64(s0)
    802006a6:	00878713          	addi	a4,a5,8
    802006aa:	fce43023          	sd	a4,-64(s0)
    802006ae:	639c                	ld	a5,0(a5)
    802006b0:	4605                	li	a2,1
    802006b2:	45a9                	li	a1,10
    802006b4:	853e                	mv	a0,a5
    802006b6:	00000097          	auipc	ra,0x0
    802006ba:	d70080e7          	jalr	-656(ra) # 80200426 <printint>
    802006be:	ac89                	j	80200910 <printf+0x3b8>
    802006c0:	fc043783          	ld	a5,-64(s0)
    802006c4:	00878713          	addi	a4,a5,8
    802006c8:	fce43023          	sd	a4,-64(s0)
    802006cc:	439c                	lw	a5,0(a5)
    802006ce:	4605                	li	a2,1
    802006d0:	45a9                	li	a1,10
    802006d2:	853e                	mv	a0,a5
    802006d4:	00000097          	auipc	ra,0x0
    802006d8:	d52080e7          	jalr	-686(ra) # 80200426 <printint>
    802006dc:	ac15                	j	80200910 <printf+0x3b8>
    802006de:	fdc42783          	lw	a5,-36(s0)
    802006e2:	2781                	sext.w	a5,a5
    802006e4:	c385                	beqz	a5,80200704 <printf+0x1ac>
    802006e6:	fc043783          	ld	a5,-64(s0)
    802006ea:	00878713          	addi	a4,a5,8
    802006ee:	fce43023          	sd	a4,-64(s0)
    802006f2:	639c                	ld	a5,0(a5)
    802006f4:	4601                	li	a2,0
    802006f6:	45c1                	li	a1,16
    802006f8:	853e                	mv	a0,a5
    802006fa:	00000097          	auipc	ra,0x0
    802006fe:	d2c080e7          	jalr	-724(ra) # 80200426 <printint>
    80200702:	a439                	j	80200910 <printf+0x3b8>
    80200704:	fc043783          	ld	a5,-64(s0)
    80200708:	00878713          	addi	a4,a5,8
    8020070c:	fce43023          	sd	a4,-64(s0)
    80200710:	439c                	lw	a5,0(a5)
    80200712:	4601                	li	a2,0
    80200714:	45c1                	li	a1,16
    80200716:	853e                	mv	a0,a5
    80200718:	00000097          	auipc	ra,0x0
    8020071c:	d0e080e7          	jalr	-754(ra) # 80200426 <printint>
    80200720:	aac5                	j	80200910 <printf+0x3b8>
    80200722:	fdc42783          	lw	a5,-36(s0)
    80200726:	2781                	sext.w	a5,a5
    80200728:	c385                	beqz	a5,80200748 <printf+0x1f0>
    8020072a:	fc043783          	ld	a5,-64(s0)
    8020072e:	00878713          	addi	a4,a5,8
    80200732:	fce43023          	sd	a4,-64(s0)
    80200736:	639c                	ld	a5,0(a5)
    80200738:	4601                	li	a2,0
    8020073a:	45a9                	li	a1,10
    8020073c:	853e                	mv	a0,a5
    8020073e:	00000097          	auipc	ra,0x0
    80200742:	ce8080e7          	jalr	-792(ra) # 80200426 <printint>
    80200746:	a2e9                	j	80200910 <printf+0x3b8>
    80200748:	fc043783          	ld	a5,-64(s0)
    8020074c:	00878713          	addi	a4,a5,8
    80200750:	fce43023          	sd	a4,-64(s0)
    80200754:	439c                	lw	a5,0(a5)
    80200756:	1782                	slli	a5,a5,0x20
    80200758:	9381                	srli	a5,a5,0x20
    8020075a:	4601                	li	a2,0
    8020075c:	45a9                	li	a1,10
    8020075e:	853e                	mv	a0,a5
    80200760:	00000097          	auipc	ra,0x0
    80200764:	cc6080e7          	jalr	-826(ra) # 80200426 <printint>
    80200768:	a265                	j	80200910 <printf+0x3b8>
    8020076a:	fc043783          	ld	a5,-64(s0)
    8020076e:	00878713          	addi	a4,a5,8
    80200772:	fce43023          	sd	a4,-64(s0)
    80200776:	439c                	lw	a5,0(a5)
    80200778:	853e                	mv	a0,a5
    8020077a:	00000097          	auipc	ra,0x0
    8020077e:	c58080e7          	jalr	-936(ra) # 802003d2 <consputc>
    80200782:	a279                	j	80200910 <printf+0x3b8>
    80200784:	fc043783          	ld	a5,-64(s0)
    80200788:	00878713          	addi	a4,a5,8
    8020078c:	fce43023          	sd	a4,-64(s0)
    80200790:	639c                	ld	a5,0(a5)
    80200792:	fef43023          	sd	a5,-32(s0)
    80200796:	fe043783          	ld	a5,-32(s0)
    8020079a:	e799                	bnez	a5,802007a8 <printf+0x250>
    8020079c:	00003797          	auipc	a5,0x3
    802007a0:	b7478793          	addi	a5,a5,-1164 # 80203310 <small_numbers+0x190>
    802007a4:	fef43023          	sd	a5,-32(s0)
    802007a8:	fe043503          	ld	a0,-32(s0)
    802007ac:	00000097          	auipc	ra,0x0
    802007b0:	c50080e7          	jalr	-944(ra) # 802003fc <consputs>
    802007b4:	aab1                	j	80200910 <printf+0x3b8>
    802007b6:	fc043783          	ld	a5,-64(s0)
    802007ba:	00878713          	addi	a4,a5,8
    802007be:	fce43023          	sd	a4,-64(s0)
    802007c2:	639c                	ld	a5,0(a5)
    802007c4:	fcf43823          	sd	a5,-48(s0)
    802007c8:	00003517          	auipc	a0,0x3
    802007cc:	b5050513          	addi	a0,a0,-1200 # 80203318 <small_numbers+0x198>
    802007d0:	00000097          	auipc	ra,0x0
    802007d4:	c2c080e7          	jalr	-980(ra) # 802003fc <consputs>
    802007d8:	fc042c23          	sw	zero,-40(s0)
    802007dc:	a0a1                	j	80200824 <printf+0x2cc>
    802007de:	47bd                	li	a5,15
    802007e0:	fd842703          	lw	a4,-40(s0)
    802007e4:	9f99                	subw	a5,a5,a4
    802007e6:	2781                	sext.w	a5,a5
    802007e8:	0027979b          	slliw	a5,a5,0x2
    802007ec:	fcf42623          	sw	a5,-52(s0)
    802007f0:	fcc42783          	lw	a5,-52(s0)
    802007f4:	873e                	mv	a4,a5
    802007f6:	fd043783          	ld	a5,-48(s0)
    802007fa:	00e7d7b3          	srl	a5,a5,a4
    802007fe:	8bbd                	andi	a5,a5,15
    80200800:	00003717          	auipc	a4,0x3
    80200804:	b2070713          	addi	a4,a4,-1248 # 80203320 <small_numbers+0x1a0>
    80200808:	97ba                	add	a5,a5,a4
    8020080a:	0007c703          	lbu	a4,0(a5)
    8020080e:	fd842783          	lw	a5,-40(s0)
    80200812:	17c1                	addi	a5,a5,-16
    80200814:	97a2                	add	a5,a5,s0
    80200816:	fae78c23          	sb	a4,-72(a5)
    8020081a:	fd842783          	lw	a5,-40(s0)
    8020081e:	2785                	addiw	a5,a5,1
    80200820:	fcf42c23          	sw	a5,-40(s0)
    80200824:	fd842783          	lw	a5,-40(s0)
    80200828:	0007871b          	sext.w	a4,a5
    8020082c:	47bd                	li	a5,15
    8020082e:	fae7d8e3          	bge	a5,a4,802007de <printf+0x286>
    80200832:	fa040c23          	sb	zero,-72(s0)
    80200836:	fa840793          	addi	a5,s0,-88
    8020083a:	853e                	mv	a0,a5
    8020083c:	00000097          	auipc	ra,0x0
    80200840:	bc0080e7          	jalr	-1088(ra) # 802003fc <consputs>
    80200844:	a0f1                	j	80200910 <printf+0x3b8>
    80200846:	fdc42783          	lw	a5,-36(s0)
    8020084a:	2781                	sext.w	a5,a5
    8020084c:	c385                	beqz	a5,8020086c <printf+0x314>
    8020084e:	fc043783          	ld	a5,-64(s0)
    80200852:	00878713          	addi	a4,a5,8
    80200856:	fce43023          	sd	a4,-64(s0)
    8020085a:	639c                	ld	a5,0(a5)
    8020085c:	4601                	li	a2,0
    8020085e:	4589                	li	a1,2
    80200860:	853e                	mv	a0,a5
    80200862:	00000097          	auipc	ra,0x0
    80200866:	bc4080e7          	jalr	-1084(ra) # 80200426 <printint>
    8020086a:	a05d                	j	80200910 <printf+0x3b8>
    8020086c:	fc043783          	ld	a5,-64(s0)
    80200870:	00878713          	addi	a4,a5,8
    80200874:	fce43023          	sd	a4,-64(s0)
    80200878:	439c                	lw	a5,0(a5)
    8020087a:	4601                	li	a2,0
    8020087c:	4589                	li	a1,2
    8020087e:	853e                	mv	a0,a5
    80200880:	00000097          	auipc	ra,0x0
    80200884:	ba6080e7          	jalr	-1114(ra) # 80200426 <printint>
    80200888:	a061                	j	80200910 <printf+0x3b8>
    8020088a:	fdc42783          	lw	a5,-36(s0)
    8020088e:	2781                	sext.w	a5,a5
    80200890:	c385                	beqz	a5,802008b0 <printf+0x358>
    80200892:	fc043783          	ld	a5,-64(s0)
    80200896:	00878713          	addi	a4,a5,8
    8020089a:	fce43023          	sd	a4,-64(s0)
    8020089e:	639c                	ld	a5,0(a5)
    802008a0:	4601                	li	a2,0
    802008a2:	45a1                	li	a1,8
    802008a4:	853e                	mv	a0,a5
    802008a6:	00000097          	auipc	ra,0x0
    802008aa:	b80080e7          	jalr	-1152(ra) # 80200426 <printint>
    802008ae:	a08d                	j	80200910 <printf+0x3b8>
    802008b0:	fc043783          	ld	a5,-64(s0)
    802008b4:	00878713          	addi	a4,a5,8
    802008b8:	fce43023          	sd	a4,-64(s0)
    802008bc:	439c                	lw	a5,0(a5)
    802008be:	4601                	li	a2,0
    802008c0:	45a1                	li	a1,8
    802008c2:	853e                	mv	a0,a5
    802008c4:	00000097          	auipc	ra,0x0
    802008c8:	b62080e7          	jalr	-1182(ra) # 80200426 <printint>
    802008cc:	a091                	j	80200910 <printf+0x3b8>
    802008ce:	02500513          	li	a0,37
    802008d2:	00000097          	auipc	ra,0x0
    802008d6:	a6e080e7          	jalr	-1426(ra) # 80200340 <buffer_char>
    802008da:	a81d                	j	80200910 <printf+0x3b8>
    802008dc:	02500513          	li	a0,37
    802008e0:	00000097          	auipc	ra,0x0
    802008e4:	a60080e7          	jalr	-1440(ra) # 80200340 <buffer_char>
    802008e8:	fdc42783          	lw	a5,-36(s0)
    802008ec:	2781                	sext.w	a5,a5
    802008ee:	c799                	beqz	a5,802008fc <printf+0x3a4>
    802008f0:	06c00513          	li	a0,108
    802008f4:	00000097          	auipc	ra,0x0
    802008f8:	a4c080e7          	jalr	-1460(ra) # 80200340 <buffer_char>
    802008fc:	fe842783          	lw	a5,-24(s0)
    80200900:	0ff7f793          	zext.b	a5,a5
    80200904:	853e                	mv	a0,a5
    80200906:	00000097          	auipc	ra,0x0
    8020090a:	a3a080e7          	jalr	-1478(ra) # 80200340 <buffer_char>
    8020090e:	0001                	nop
    80200910:	fec42783          	lw	a5,-20(s0)
    80200914:	2785                	addiw	a5,a5,1
    80200916:	fef42623          	sw	a5,-20(s0)
    8020091a:	fec42783          	lw	a5,-20(s0)
    8020091e:	f9843703          	ld	a4,-104(s0)
    80200922:	97ba                	add	a5,a5,a4
    80200924:	0007c783          	lbu	a5,0(a5)
    80200928:	fef42423          	sw	a5,-24(s0)
    8020092c:	fe842783          	lw	a5,-24(s0)
    80200930:	2781                	sext.w	a5,a5
    80200932:	c4079fe3          	bnez	a5,80200590 <printf+0x38>
    80200936:	a021                	j	8020093e <printf+0x3e6>
    80200938:	0001                	nop
    8020093a:	a011                	j	8020093e <printf+0x3e6>
    8020093c:	0001                	nop
    8020093e:	00000097          	auipc	ra,0x0
    80200942:	9ae080e7          	jalr	-1618(ra) # 802002ec <flush_printf_buffer>
    80200946:	0001                	nop
    80200948:	70a6                	ld	ra,104(sp)
    8020094a:	7406                	ld	s0,96(sp)
    8020094c:	614d                	addi	sp,sp,176
    8020094e:	8082                	ret

0000000080200950 <clear_screen>:
    80200950:	1141                	addi	sp,sp,-16
    80200952:	e406                	sd	ra,8(sp)
    80200954:	e022                	sd	s0,0(sp)
    80200956:	0800                	addi	s0,sp,16
    80200958:	00003517          	auipc	a0,0x3
    8020095c:	a3850513          	addi	a0,a0,-1480 # 80203390 <small_numbers+0x210>
    80200960:	00000097          	auipc	ra,0x0
    80200964:	90a080e7          	jalr	-1782(ra) # 8020026a <uart_puts>
    80200968:	00003517          	auipc	a0,0x3
    8020096c:	a3050513          	addi	a0,a0,-1488 # 80203398 <small_numbers+0x218>
    80200970:	00000097          	auipc	ra,0x0
    80200974:	8fa080e7          	jalr	-1798(ra) # 8020026a <uart_puts>
    80200978:	0001                	nop
    8020097a:	60a2                	ld	ra,8(sp)
    8020097c:	6402                	ld	s0,0(sp)
    8020097e:	0141                	addi	sp,sp,16
    80200980:	8082                	ret

0000000080200982 <cursor_up>:
    80200982:	1101                	addi	sp,sp,-32
    80200984:	ec06                	sd	ra,24(sp)
    80200986:	e822                	sd	s0,16(sp)
    80200988:	1000                	addi	s0,sp,32
    8020098a:	87aa                	mv	a5,a0
    8020098c:	fef42623          	sw	a5,-20(s0)
    80200990:	fec42783          	lw	a5,-20(s0)
    80200994:	2781                	sext.w	a5,a5
    80200996:	02f05d63          	blez	a5,802009d0 <cursor_up+0x4e>
    8020099a:	456d                	li	a0,27
    8020099c:	00000097          	auipc	ra,0x0
    802009a0:	a36080e7          	jalr	-1482(ra) # 802003d2 <consputc>
    802009a4:	05b00513          	li	a0,91
    802009a8:	00000097          	auipc	ra,0x0
    802009ac:	a2a080e7          	jalr	-1494(ra) # 802003d2 <consputc>
    802009b0:	fec42783          	lw	a5,-20(s0)
    802009b4:	4601                	li	a2,0
    802009b6:	45a9                	li	a1,10
    802009b8:	853e                	mv	a0,a5
    802009ba:	00000097          	auipc	ra,0x0
    802009be:	a6c080e7          	jalr	-1428(ra) # 80200426 <printint>
    802009c2:	04100513          	li	a0,65
    802009c6:	00000097          	auipc	ra,0x0
    802009ca:	a0c080e7          	jalr	-1524(ra) # 802003d2 <consputc>
    802009ce:	a011                	j	802009d2 <cursor_up+0x50>
    802009d0:	0001                	nop
    802009d2:	60e2                	ld	ra,24(sp)
    802009d4:	6442                	ld	s0,16(sp)
    802009d6:	6105                	addi	sp,sp,32
    802009d8:	8082                	ret

00000000802009da <cursor_down>:
    802009da:	1101                	addi	sp,sp,-32
    802009dc:	ec06                	sd	ra,24(sp)
    802009de:	e822                	sd	s0,16(sp)
    802009e0:	1000                	addi	s0,sp,32
    802009e2:	87aa                	mv	a5,a0
    802009e4:	fef42623          	sw	a5,-20(s0)
    802009e8:	fec42783          	lw	a5,-20(s0)
    802009ec:	2781                	sext.w	a5,a5
    802009ee:	02f05d63          	blez	a5,80200a28 <cursor_down+0x4e>
    802009f2:	456d                	li	a0,27
    802009f4:	00000097          	auipc	ra,0x0
    802009f8:	9de080e7          	jalr	-1570(ra) # 802003d2 <consputc>
    802009fc:	05b00513          	li	a0,91
    80200a00:	00000097          	auipc	ra,0x0
    80200a04:	9d2080e7          	jalr	-1582(ra) # 802003d2 <consputc>
    80200a08:	fec42783          	lw	a5,-20(s0)
    80200a0c:	4601                	li	a2,0
    80200a0e:	45a9                	li	a1,10
    80200a10:	853e                	mv	a0,a5
    80200a12:	00000097          	auipc	ra,0x0
    80200a16:	a14080e7          	jalr	-1516(ra) # 80200426 <printint>
    80200a1a:	04200513          	li	a0,66
    80200a1e:	00000097          	auipc	ra,0x0
    80200a22:	9b4080e7          	jalr	-1612(ra) # 802003d2 <consputc>
    80200a26:	a011                	j	80200a2a <cursor_down+0x50>
    80200a28:	0001                	nop
    80200a2a:	60e2                	ld	ra,24(sp)
    80200a2c:	6442                	ld	s0,16(sp)
    80200a2e:	6105                	addi	sp,sp,32
    80200a30:	8082                	ret

0000000080200a32 <cursor_right>:
    80200a32:	1101                	addi	sp,sp,-32
    80200a34:	ec06                	sd	ra,24(sp)
    80200a36:	e822                	sd	s0,16(sp)
    80200a38:	1000                	addi	s0,sp,32
    80200a3a:	87aa                	mv	a5,a0
    80200a3c:	fef42623          	sw	a5,-20(s0)
    80200a40:	fec42783          	lw	a5,-20(s0)
    80200a44:	2781                	sext.w	a5,a5
    80200a46:	02f05d63          	blez	a5,80200a80 <cursor_right+0x4e>
    80200a4a:	456d                	li	a0,27
    80200a4c:	00000097          	auipc	ra,0x0
    80200a50:	986080e7          	jalr	-1658(ra) # 802003d2 <consputc>
    80200a54:	05b00513          	li	a0,91
    80200a58:	00000097          	auipc	ra,0x0
    80200a5c:	97a080e7          	jalr	-1670(ra) # 802003d2 <consputc>
    80200a60:	fec42783          	lw	a5,-20(s0)
    80200a64:	4601                	li	a2,0
    80200a66:	45a9                	li	a1,10
    80200a68:	853e                	mv	a0,a5
    80200a6a:	00000097          	auipc	ra,0x0
    80200a6e:	9bc080e7          	jalr	-1604(ra) # 80200426 <printint>
    80200a72:	04300513          	li	a0,67
    80200a76:	00000097          	auipc	ra,0x0
    80200a7a:	95c080e7          	jalr	-1700(ra) # 802003d2 <consputc>
    80200a7e:	a011                	j	80200a82 <cursor_right+0x50>
    80200a80:	0001                	nop
    80200a82:	60e2                	ld	ra,24(sp)
    80200a84:	6442                	ld	s0,16(sp)
    80200a86:	6105                	addi	sp,sp,32
    80200a88:	8082                	ret

0000000080200a8a <cursor_left>:
    80200a8a:	1101                	addi	sp,sp,-32
    80200a8c:	ec06                	sd	ra,24(sp)
    80200a8e:	e822                	sd	s0,16(sp)
    80200a90:	1000                	addi	s0,sp,32
    80200a92:	87aa                	mv	a5,a0
    80200a94:	fef42623          	sw	a5,-20(s0)
    80200a98:	fec42783          	lw	a5,-20(s0)
    80200a9c:	2781                	sext.w	a5,a5
    80200a9e:	02f05d63          	blez	a5,80200ad8 <cursor_left+0x4e>
    80200aa2:	456d                	li	a0,27
    80200aa4:	00000097          	auipc	ra,0x0
    80200aa8:	92e080e7          	jalr	-1746(ra) # 802003d2 <consputc>
    80200aac:	05b00513          	li	a0,91
    80200ab0:	00000097          	auipc	ra,0x0
    80200ab4:	922080e7          	jalr	-1758(ra) # 802003d2 <consputc>
    80200ab8:	fec42783          	lw	a5,-20(s0)
    80200abc:	4601                	li	a2,0
    80200abe:	45a9                	li	a1,10
    80200ac0:	853e                	mv	a0,a5
    80200ac2:	00000097          	auipc	ra,0x0
    80200ac6:	964080e7          	jalr	-1692(ra) # 80200426 <printint>
    80200aca:	04400513          	li	a0,68
    80200ace:	00000097          	auipc	ra,0x0
    80200ad2:	904080e7          	jalr	-1788(ra) # 802003d2 <consputc>
    80200ad6:	a011                	j	80200ada <cursor_left+0x50>
    80200ad8:	0001                	nop
    80200ada:	60e2                	ld	ra,24(sp)
    80200adc:	6442                	ld	s0,16(sp)
    80200ade:	6105                	addi	sp,sp,32
    80200ae0:	8082                	ret

0000000080200ae2 <save_cursor>:
    80200ae2:	1141                	addi	sp,sp,-16
    80200ae4:	e406                	sd	ra,8(sp)
    80200ae6:	e022                	sd	s0,0(sp)
    80200ae8:	0800                	addi	s0,sp,16
    80200aea:	456d                	li	a0,27
    80200aec:	00000097          	auipc	ra,0x0
    80200af0:	8e6080e7          	jalr	-1818(ra) # 802003d2 <consputc>
    80200af4:	05b00513          	li	a0,91
    80200af8:	00000097          	auipc	ra,0x0
    80200afc:	8da080e7          	jalr	-1830(ra) # 802003d2 <consputc>
    80200b00:	07300513          	li	a0,115
    80200b04:	00000097          	auipc	ra,0x0
    80200b08:	8ce080e7          	jalr	-1842(ra) # 802003d2 <consputc>
    80200b0c:	0001                	nop
    80200b0e:	60a2                	ld	ra,8(sp)
    80200b10:	6402                	ld	s0,0(sp)
    80200b12:	0141                	addi	sp,sp,16
    80200b14:	8082                	ret

0000000080200b16 <restore_cursor>:
    80200b16:	1141                	addi	sp,sp,-16
    80200b18:	e406                	sd	ra,8(sp)
    80200b1a:	e022                	sd	s0,0(sp)
    80200b1c:	0800                	addi	s0,sp,16
    80200b1e:	456d                	li	a0,27
    80200b20:	00000097          	auipc	ra,0x0
    80200b24:	8b2080e7          	jalr	-1870(ra) # 802003d2 <consputc>
    80200b28:	05b00513          	li	a0,91
    80200b2c:	00000097          	auipc	ra,0x0
    80200b30:	8a6080e7          	jalr	-1882(ra) # 802003d2 <consputc>
    80200b34:	07500513          	li	a0,117
    80200b38:	00000097          	auipc	ra,0x0
    80200b3c:	89a080e7          	jalr	-1894(ra) # 802003d2 <consputc>
    80200b40:	0001                	nop
    80200b42:	60a2                	ld	ra,8(sp)
    80200b44:	6402                	ld	s0,0(sp)
    80200b46:	0141                	addi	sp,sp,16
    80200b48:	8082                	ret

0000000080200b4a <cursor_to_column>:
    80200b4a:	1101                	addi	sp,sp,-32
    80200b4c:	ec06                	sd	ra,24(sp)
    80200b4e:	e822                	sd	s0,16(sp)
    80200b50:	1000                	addi	s0,sp,32
    80200b52:	87aa                	mv	a5,a0
    80200b54:	fef42623          	sw	a5,-20(s0)
    80200b58:	fec42783          	lw	a5,-20(s0)
    80200b5c:	2781                	sext.w	a5,a5
    80200b5e:	00f04563          	bgtz	a5,80200b68 <cursor_to_column+0x1e>
    80200b62:	4785                	li	a5,1
    80200b64:	fef42623          	sw	a5,-20(s0)
    80200b68:	456d                	li	a0,27
    80200b6a:	00000097          	auipc	ra,0x0
    80200b6e:	868080e7          	jalr	-1944(ra) # 802003d2 <consputc>
    80200b72:	05b00513          	li	a0,91
    80200b76:	00000097          	auipc	ra,0x0
    80200b7a:	85c080e7          	jalr	-1956(ra) # 802003d2 <consputc>
    80200b7e:	fec42783          	lw	a5,-20(s0)
    80200b82:	4601                	li	a2,0
    80200b84:	45a9                	li	a1,10
    80200b86:	853e                	mv	a0,a5
    80200b88:	00000097          	auipc	ra,0x0
    80200b8c:	89e080e7          	jalr	-1890(ra) # 80200426 <printint>
    80200b90:	04700513          	li	a0,71
    80200b94:	00000097          	auipc	ra,0x0
    80200b98:	83e080e7          	jalr	-1986(ra) # 802003d2 <consputc>
    80200b9c:	0001                	nop
    80200b9e:	60e2                	ld	ra,24(sp)
    80200ba0:	6442                	ld	s0,16(sp)
    80200ba2:	6105                	addi	sp,sp,32
    80200ba4:	8082                	ret

0000000080200ba6 <goto_rc>:
    80200ba6:	1101                	addi	sp,sp,-32
    80200ba8:	ec06                	sd	ra,24(sp)
    80200baa:	e822                	sd	s0,16(sp)
    80200bac:	1000                	addi	s0,sp,32
    80200bae:	87aa                	mv	a5,a0
    80200bb0:	872e                	mv	a4,a1
    80200bb2:	fef42623          	sw	a5,-20(s0)
    80200bb6:	87ba                	mv	a5,a4
    80200bb8:	fef42423          	sw	a5,-24(s0)
    80200bbc:	456d                	li	a0,27
    80200bbe:	00000097          	auipc	ra,0x0
    80200bc2:	814080e7          	jalr	-2028(ra) # 802003d2 <consputc>
    80200bc6:	05b00513          	li	a0,91
    80200bca:	00000097          	auipc	ra,0x0
    80200bce:	808080e7          	jalr	-2040(ra) # 802003d2 <consputc>
    80200bd2:	fec42783          	lw	a5,-20(s0)
    80200bd6:	4601                	li	a2,0
    80200bd8:	45a9                	li	a1,10
    80200bda:	853e                	mv	a0,a5
    80200bdc:	00000097          	auipc	ra,0x0
    80200be0:	84a080e7          	jalr	-1974(ra) # 80200426 <printint>
    80200be4:	03b00513          	li	a0,59
    80200be8:	fffff097          	auipc	ra,0xfffff
    80200bec:	7ea080e7          	jalr	2026(ra) # 802003d2 <consputc>
    80200bf0:	fe842783          	lw	a5,-24(s0)
    80200bf4:	4601                	li	a2,0
    80200bf6:	45a9                	li	a1,10
    80200bf8:	853e                	mv	a0,a5
    80200bfa:	00000097          	auipc	ra,0x0
    80200bfe:	82c080e7          	jalr	-2004(ra) # 80200426 <printint>
    80200c02:	04800513          	li	a0,72
    80200c06:	fffff097          	auipc	ra,0xfffff
    80200c0a:	7cc080e7          	jalr	1996(ra) # 802003d2 <consputc>
    80200c0e:	0001                	nop
    80200c10:	60e2                	ld	ra,24(sp)
    80200c12:	6442                	ld	s0,16(sp)
    80200c14:	6105                	addi	sp,sp,32
    80200c16:	8082                	ret

0000000080200c18 <reset_color>:
    80200c18:	1141                	addi	sp,sp,-16
    80200c1a:	e406                	sd	ra,8(sp)
    80200c1c:	e022                	sd	s0,0(sp)
    80200c1e:	0800                	addi	s0,sp,16
    80200c20:	00002517          	auipc	a0,0x2
    80200c24:	78050513          	addi	a0,a0,1920 # 802033a0 <small_numbers+0x220>
    80200c28:	fffff097          	auipc	ra,0xfffff
    80200c2c:	642080e7          	jalr	1602(ra) # 8020026a <uart_puts>
    80200c30:	0001                	nop
    80200c32:	60a2                	ld	ra,8(sp)
    80200c34:	6402                	ld	s0,0(sp)
    80200c36:	0141                	addi	sp,sp,16
    80200c38:	8082                	ret

0000000080200c3a <set_fg_color>:
    80200c3a:	1101                	addi	sp,sp,-32
    80200c3c:	ec06                	sd	ra,24(sp)
    80200c3e:	e822                	sd	s0,16(sp)
    80200c40:	1000                	addi	s0,sp,32
    80200c42:	87aa                	mv	a5,a0
    80200c44:	fef42623          	sw	a5,-20(s0)
    80200c48:	fec42783          	lw	a5,-20(s0)
    80200c4c:	0007871b          	sext.w	a4,a5
    80200c50:	47f5                	li	a5,29
    80200c52:	04e7d563          	bge	a5,a4,80200c9c <set_fg_color+0x62>
    80200c56:	fec42783          	lw	a5,-20(s0)
    80200c5a:	0007871b          	sext.w	a4,a5
    80200c5e:	02500793          	li	a5,37
    80200c62:	02e7cd63          	blt	a5,a4,80200c9c <set_fg_color+0x62>
    80200c66:	456d                	li	a0,27
    80200c68:	fffff097          	auipc	ra,0xfffff
    80200c6c:	76a080e7          	jalr	1898(ra) # 802003d2 <consputc>
    80200c70:	05b00513          	li	a0,91
    80200c74:	fffff097          	auipc	ra,0xfffff
    80200c78:	75e080e7          	jalr	1886(ra) # 802003d2 <consputc>
    80200c7c:	fec42783          	lw	a5,-20(s0)
    80200c80:	4601                	li	a2,0
    80200c82:	45a9                	li	a1,10
    80200c84:	853e                	mv	a0,a5
    80200c86:	fffff097          	auipc	ra,0xfffff
    80200c8a:	7a0080e7          	jalr	1952(ra) # 80200426 <printint>
    80200c8e:	06d00513          	li	a0,109
    80200c92:	fffff097          	auipc	ra,0xfffff
    80200c96:	740080e7          	jalr	1856(ra) # 802003d2 <consputc>
    80200c9a:	a011                	j	80200c9e <set_fg_color+0x64>
    80200c9c:	0001                	nop
    80200c9e:	60e2                	ld	ra,24(sp)
    80200ca0:	6442                	ld	s0,16(sp)
    80200ca2:	6105                	addi	sp,sp,32
    80200ca4:	8082                	ret

0000000080200ca6 <set_bg_color>:
    80200ca6:	1101                	addi	sp,sp,-32
    80200ca8:	ec06                	sd	ra,24(sp)
    80200caa:	e822                	sd	s0,16(sp)
    80200cac:	1000                	addi	s0,sp,32
    80200cae:	87aa                	mv	a5,a0
    80200cb0:	fef42623          	sw	a5,-20(s0)
    80200cb4:	fec42783          	lw	a5,-20(s0)
    80200cb8:	0007871b          	sext.w	a4,a5
    80200cbc:	02700793          	li	a5,39
    80200cc0:	04e7d563          	bge	a5,a4,80200d0a <set_bg_color+0x64>
    80200cc4:	fec42783          	lw	a5,-20(s0)
    80200cc8:	0007871b          	sext.w	a4,a5
    80200ccc:	02f00793          	li	a5,47
    80200cd0:	02e7cd63          	blt	a5,a4,80200d0a <set_bg_color+0x64>
    80200cd4:	456d                	li	a0,27
    80200cd6:	fffff097          	auipc	ra,0xfffff
    80200cda:	6fc080e7          	jalr	1788(ra) # 802003d2 <consputc>
    80200cde:	05b00513          	li	a0,91
    80200ce2:	fffff097          	auipc	ra,0xfffff
    80200ce6:	6f0080e7          	jalr	1776(ra) # 802003d2 <consputc>
    80200cea:	fec42783          	lw	a5,-20(s0)
    80200cee:	4601                	li	a2,0
    80200cf0:	45a9                	li	a1,10
    80200cf2:	853e                	mv	a0,a5
    80200cf4:	fffff097          	auipc	ra,0xfffff
    80200cf8:	732080e7          	jalr	1842(ra) # 80200426 <printint>
    80200cfc:	06d00513          	li	a0,109
    80200d00:	fffff097          	auipc	ra,0xfffff
    80200d04:	6d2080e7          	jalr	1746(ra) # 802003d2 <consputc>
    80200d08:	a011                	j	80200d0c <set_bg_color+0x66>
    80200d0a:	0001                	nop
    80200d0c:	60e2                	ld	ra,24(sp)
    80200d0e:	6442                	ld	s0,16(sp)
    80200d10:	6105                	addi	sp,sp,32
    80200d12:	8082                	ret

0000000080200d14 <color_red>:
    80200d14:	1141                	addi	sp,sp,-16
    80200d16:	e406                	sd	ra,8(sp)
    80200d18:	e022                	sd	s0,0(sp)
    80200d1a:	0800                	addi	s0,sp,16
    80200d1c:	457d                	li	a0,31
    80200d1e:	00000097          	auipc	ra,0x0
    80200d22:	f1c080e7          	jalr	-228(ra) # 80200c3a <set_fg_color>
    80200d26:	0001                	nop
    80200d28:	60a2                	ld	ra,8(sp)
    80200d2a:	6402                	ld	s0,0(sp)
    80200d2c:	0141                	addi	sp,sp,16
    80200d2e:	8082                	ret

0000000080200d30 <color_green>:
    80200d30:	1141                	addi	sp,sp,-16
    80200d32:	e406                	sd	ra,8(sp)
    80200d34:	e022                	sd	s0,0(sp)
    80200d36:	0800                	addi	s0,sp,16
    80200d38:	02000513          	li	a0,32
    80200d3c:	00000097          	auipc	ra,0x0
    80200d40:	efe080e7          	jalr	-258(ra) # 80200c3a <set_fg_color>
    80200d44:	0001                	nop
    80200d46:	60a2                	ld	ra,8(sp)
    80200d48:	6402                	ld	s0,0(sp)
    80200d4a:	0141                	addi	sp,sp,16
    80200d4c:	8082                	ret

0000000080200d4e <color_yellow>:
    80200d4e:	1141                	addi	sp,sp,-16
    80200d50:	e406                	sd	ra,8(sp)
    80200d52:	e022                	sd	s0,0(sp)
    80200d54:	0800                	addi	s0,sp,16
    80200d56:	02100513          	li	a0,33
    80200d5a:	00000097          	auipc	ra,0x0
    80200d5e:	ee0080e7          	jalr	-288(ra) # 80200c3a <set_fg_color>
    80200d62:	0001                	nop
    80200d64:	60a2                	ld	ra,8(sp)
    80200d66:	6402                	ld	s0,0(sp)
    80200d68:	0141                	addi	sp,sp,16
    80200d6a:	8082                	ret

0000000080200d6c <color_blue>:
    80200d6c:	1141                	addi	sp,sp,-16
    80200d6e:	e406                	sd	ra,8(sp)
    80200d70:	e022                	sd	s0,0(sp)
    80200d72:	0800                	addi	s0,sp,16
    80200d74:	02200513          	li	a0,34
    80200d78:	00000097          	auipc	ra,0x0
    80200d7c:	ec2080e7          	jalr	-318(ra) # 80200c3a <set_fg_color>
    80200d80:	0001                	nop
    80200d82:	60a2                	ld	ra,8(sp)
    80200d84:	6402                	ld	s0,0(sp)
    80200d86:	0141                	addi	sp,sp,16
    80200d88:	8082                	ret

0000000080200d8a <color_purple>:
    80200d8a:	1141                	addi	sp,sp,-16
    80200d8c:	e406                	sd	ra,8(sp)
    80200d8e:	e022                	sd	s0,0(sp)
    80200d90:	0800                	addi	s0,sp,16
    80200d92:	02300513          	li	a0,35
    80200d96:	00000097          	auipc	ra,0x0
    80200d9a:	ea4080e7          	jalr	-348(ra) # 80200c3a <set_fg_color>
    80200d9e:	0001                	nop
    80200da0:	60a2                	ld	ra,8(sp)
    80200da2:	6402                	ld	s0,0(sp)
    80200da4:	0141                	addi	sp,sp,16
    80200da6:	8082                	ret

0000000080200da8 <color_cyan>:
    80200da8:	1141                	addi	sp,sp,-16
    80200daa:	e406                	sd	ra,8(sp)
    80200dac:	e022                	sd	s0,0(sp)
    80200dae:	0800                	addi	s0,sp,16
    80200db0:	02400513          	li	a0,36
    80200db4:	00000097          	auipc	ra,0x0
    80200db8:	e86080e7          	jalr	-378(ra) # 80200c3a <set_fg_color>
    80200dbc:	0001                	nop
    80200dbe:	60a2                	ld	ra,8(sp)
    80200dc0:	6402                	ld	s0,0(sp)
    80200dc2:	0141                	addi	sp,sp,16
    80200dc4:	8082                	ret

0000000080200dc6 <color_reverse>:
    80200dc6:	1141                	addi	sp,sp,-16
    80200dc8:	e406                	sd	ra,8(sp)
    80200dca:	e022                	sd	s0,0(sp)
    80200dcc:	0800                	addi	s0,sp,16
    80200dce:	02500513          	li	a0,37
    80200dd2:	00000097          	auipc	ra,0x0
    80200dd6:	e68080e7          	jalr	-408(ra) # 80200c3a <set_fg_color>
    80200dda:	0001                	nop
    80200ddc:	60a2                	ld	ra,8(sp)
    80200dde:	6402                	ld	s0,0(sp)
    80200de0:	0141                	addi	sp,sp,16
    80200de2:	8082                	ret

0000000080200de4 <set_color>:
    80200de4:	1101                	addi	sp,sp,-32
    80200de6:	ec06                	sd	ra,24(sp)
    80200de8:	e822                	sd	s0,16(sp)
    80200dea:	1000                	addi	s0,sp,32
    80200dec:	87aa                	mv	a5,a0
    80200dee:	872e                	mv	a4,a1
    80200df0:	fef42623          	sw	a5,-20(s0)
    80200df4:	87ba                	mv	a5,a4
    80200df6:	fef42423          	sw	a5,-24(s0)
    80200dfa:	fe842783          	lw	a5,-24(s0)
    80200dfe:	853e                	mv	a0,a5
    80200e00:	00000097          	auipc	ra,0x0
    80200e04:	ea6080e7          	jalr	-346(ra) # 80200ca6 <set_bg_color>
    80200e08:	fec42783          	lw	a5,-20(s0)
    80200e0c:	853e                	mv	a0,a5
    80200e0e:	00000097          	auipc	ra,0x0
    80200e12:	e2c080e7          	jalr	-468(ra) # 80200c3a <set_fg_color>
    80200e16:	0001                	nop
    80200e18:	60e2                	ld	ra,24(sp)
    80200e1a:	6442                	ld	s0,16(sp)
    80200e1c:	6105                	addi	sp,sp,32
    80200e1e:	8082                	ret

0000000080200e20 <clear_line>:
    80200e20:	1141                	addi	sp,sp,-16
    80200e22:	e406                	sd	ra,8(sp)
    80200e24:	e022                	sd	s0,0(sp)
    80200e26:	0800                	addi	s0,sp,16
    80200e28:	456d                	li	a0,27
    80200e2a:	fffff097          	auipc	ra,0xfffff
    80200e2e:	5a8080e7          	jalr	1448(ra) # 802003d2 <consputc>
    80200e32:	05b00513          	li	a0,91
    80200e36:	fffff097          	auipc	ra,0xfffff
    80200e3a:	59c080e7          	jalr	1436(ra) # 802003d2 <consputc>
    80200e3e:	03200513          	li	a0,50
    80200e42:	fffff097          	auipc	ra,0xfffff
    80200e46:	590080e7          	jalr	1424(ra) # 802003d2 <consputc>
    80200e4a:	04b00513          	li	a0,75
    80200e4e:	fffff097          	auipc	ra,0xfffff
    80200e52:	584080e7          	jalr	1412(ra) # 802003d2 <consputc>
    80200e56:	0001                	nop
    80200e58:	60a2                	ld	ra,8(sp)
    80200e5a:	6402                	ld	s0,0(sp)
    80200e5c:	0141                	addi	sp,sp,16
    80200e5e:	8082                	ret

0000000080200e60 <panic>:
    80200e60:	1101                	addi	sp,sp,-32
    80200e62:	ec06                	sd	ra,24(sp)
    80200e64:	e822                	sd	s0,16(sp)
    80200e66:	1000                	addi	s0,sp,32
    80200e68:	fea43423          	sd	a0,-24(s0)
    80200e6c:	00000097          	auipc	ra,0x0
    80200e70:	ea8080e7          	jalr	-344(ra) # 80200d14 <color_red>
    80200e74:	fe843583          	ld	a1,-24(s0)
    80200e78:	00002517          	auipc	a0,0x2
    80200e7c:	53050513          	addi	a0,a0,1328 # 802033a8 <small_numbers+0x228>
    80200e80:	fffff097          	auipc	ra,0xfffff
    80200e84:	6d8080e7          	jalr	1752(ra) # 80200558 <printf>
    80200e88:	00000097          	auipc	ra,0x0
    80200e8c:	d90080e7          	jalr	-624(ra) # 80200c18 <reset_color>
    80200e90:	0001                	nop
    80200e92:	bffd                	j	80200e90 <panic+0x30>

0000000080200e94 <test_printf_precision>:
    80200e94:	1101                	addi	sp,sp,-32
    80200e96:	ec06                	sd	ra,24(sp)
    80200e98:	e822                	sd	s0,16(sp)
    80200e9a:	1000                	addi	s0,sp,32
    80200e9c:	00000097          	auipc	ra,0x0
    80200ea0:	ab4080e7          	jalr	-1356(ra) # 80200950 <clear_screen>
    80200ea4:	00002517          	auipc	a0,0x2
    80200ea8:	51450513          	addi	a0,a0,1300 # 802033b8 <small_numbers+0x238>
    80200eac:	fffff097          	auipc	ra,0xfffff
    80200eb0:	6ac080e7          	jalr	1708(ra) # 80200558 <printf>
    80200eb4:	00002517          	auipc	a0,0x2
    80200eb8:	52450513          	addi	a0,a0,1316 # 802033d8 <small_numbers+0x258>
    80200ebc:	fffff097          	auipc	ra,0xfffff
    80200ec0:	69c080e7          	jalr	1692(ra) # 80200558 <printf>
    80200ec4:	0ff00593          	li	a1,255
    80200ec8:	00002517          	auipc	a0,0x2
    80200ecc:	52850513          	addi	a0,a0,1320 # 802033f0 <small_numbers+0x270>
    80200ed0:	fffff097          	auipc	ra,0xfffff
    80200ed4:	688080e7          	jalr	1672(ra) # 80200558 <printf>
    80200ed8:	6585                	lui	a1,0x1
    80200eda:	00002517          	auipc	a0,0x2
    80200ede:	53650513          	addi	a0,a0,1334 # 80203410 <small_numbers+0x290>
    80200ee2:	fffff097          	auipc	ra,0xfffff
    80200ee6:	676080e7          	jalr	1654(ra) # 80200558 <printf>
    80200eea:	1234b7b7          	lui	a5,0x1234b
    80200eee:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    80200ef2:	00002517          	auipc	a0,0x2
    80200ef6:	53e50513          	addi	a0,a0,1342 # 80203430 <small_numbers+0x2b0>
    80200efa:	fffff097          	auipc	ra,0xfffff
    80200efe:	65e080e7          	jalr	1630(ra) # 80200558 <printf>
    80200f02:	00002517          	auipc	a0,0x2
    80200f06:	54650513          	addi	a0,a0,1350 # 80203448 <small_numbers+0x2c8>
    80200f0a:	fffff097          	auipc	ra,0xfffff
    80200f0e:	64e080e7          	jalr	1614(ra) # 80200558 <printf>
    80200f12:	02a00593          	li	a1,42
    80200f16:	00002517          	auipc	a0,0x2
    80200f1a:	54a50513          	addi	a0,a0,1354 # 80203460 <small_numbers+0x2e0>
    80200f1e:	fffff097          	auipc	ra,0xfffff
    80200f22:	63a080e7          	jalr	1594(ra) # 80200558 <printf>
    80200f26:	fd600593          	li	a1,-42
    80200f2a:	00002517          	auipc	a0,0x2
    80200f2e:	54650513          	addi	a0,a0,1350 # 80203470 <small_numbers+0x2f0>
    80200f32:	fffff097          	auipc	ra,0xfffff
    80200f36:	626080e7          	jalr	1574(ra) # 80200558 <printf>
    80200f3a:	4581                	li	a1,0
    80200f3c:	00002517          	auipc	a0,0x2
    80200f40:	54450513          	addi	a0,a0,1348 # 80203480 <small_numbers+0x300>
    80200f44:	fffff097          	auipc	ra,0xfffff
    80200f48:	614080e7          	jalr	1556(ra) # 80200558 <printf>
    80200f4c:	075bd7b7          	lui	a5,0x75bd
    80200f50:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    80200f54:	00002517          	auipc	a0,0x2
    80200f58:	53c50513          	addi	a0,a0,1340 # 80203490 <small_numbers+0x310>
    80200f5c:	fffff097          	auipc	ra,0xfffff
    80200f60:	5fc080e7          	jalr	1532(ra) # 80200558 <printf>
    80200f64:	00002517          	auipc	a0,0x2
    80200f68:	53c50513          	addi	a0,a0,1340 # 802034a0 <small_numbers+0x320>
    80200f6c:	fffff097          	auipc	ra,0xfffff
    80200f70:	5ec080e7          	jalr	1516(ra) # 80200558 <printf>
    80200f74:	55fd                	li	a1,-1
    80200f76:	00002517          	auipc	a0,0x2
    80200f7a:	54250513          	addi	a0,a0,1346 # 802034b8 <small_numbers+0x338>
    80200f7e:	fffff097          	auipc	ra,0xfffff
    80200f82:	5da080e7          	jalr	1498(ra) # 80200558 <printf>
    80200f86:	4581                	li	a1,0
    80200f88:	00002517          	auipc	a0,0x2
    80200f8c:	54850513          	addi	a0,a0,1352 # 802034d0 <small_numbers+0x350>
    80200f90:	fffff097          	auipc	ra,0xfffff
    80200f94:	5c8080e7          	jalr	1480(ra) # 80200558 <printf>
    80200f98:	678d                	lui	a5,0x3
    80200f9a:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    80200f9e:	00002517          	auipc	a0,0x2
    80200fa2:	54250513          	addi	a0,a0,1346 # 802034e0 <small_numbers+0x360>
    80200fa6:	fffff097          	auipc	ra,0xfffff
    80200faa:	5b2080e7          	jalr	1458(ra) # 80200558 <printf>
    80200fae:	00002517          	auipc	a0,0x2
    80200fb2:	54a50513          	addi	a0,a0,1354 # 802034f8 <small_numbers+0x378>
    80200fb6:	fffff097          	auipc	ra,0xfffff
    80200fba:	5a2080e7          	jalr	1442(ra) # 80200558 <printf>
    80200fbe:	800007b7          	lui	a5,0x80000
    80200fc2:	fff7c593          	not	a1,a5
    80200fc6:	00002517          	auipc	a0,0x2
    80200fca:	54250513          	addi	a0,a0,1346 # 80203508 <small_numbers+0x388>
    80200fce:	fffff097          	auipc	ra,0xfffff
    80200fd2:	58a080e7          	jalr	1418(ra) # 80200558 <printf>
    80200fd6:	800005b7          	lui	a1,0x80000
    80200fda:	00002517          	auipc	a0,0x2
    80200fde:	53e50513          	addi	a0,a0,1342 # 80203518 <small_numbers+0x398>
    80200fe2:	fffff097          	auipc	ra,0xfffff
    80200fe6:	576080e7          	jalr	1398(ra) # 80200558 <printf>
    80200fea:	55fd                	li	a1,-1
    80200fec:	00002517          	auipc	a0,0x2
    80200ff0:	53c50513          	addi	a0,a0,1340 # 80203528 <small_numbers+0x3a8>
    80200ff4:	fffff097          	auipc	ra,0xfffff
    80200ff8:	564080e7          	jalr	1380(ra) # 80200558 <printf>
    80200ffc:	55fd                	li	a1,-1
    80200ffe:	00002517          	auipc	a0,0x2
    80201002:	53a50513          	addi	a0,a0,1338 # 80203538 <small_numbers+0x3b8>
    80201006:	fffff097          	auipc	ra,0xfffff
    8020100a:	552080e7          	jalr	1362(ra) # 80200558 <printf>
    8020100e:	00002517          	auipc	a0,0x2
    80201012:	54250513          	addi	a0,a0,1346 # 80203550 <small_numbers+0x3d0>
    80201016:	fffff097          	auipc	ra,0xfffff
    8020101a:	542080e7          	jalr	1346(ra) # 80200558 <printf>
    8020101e:	00002597          	auipc	a1,0x2
    80201022:	54a58593          	addi	a1,a1,1354 # 80203568 <small_numbers+0x3e8>
    80201026:	00002517          	auipc	a0,0x2
    8020102a:	54a50513          	addi	a0,a0,1354 # 80203570 <small_numbers+0x3f0>
    8020102e:	fffff097          	auipc	ra,0xfffff
    80201032:	52a080e7          	jalr	1322(ra) # 80200558 <printf>
    80201036:	00002597          	auipc	a1,0x2
    8020103a:	55258593          	addi	a1,a1,1362 # 80203588 <small_numbers+0x408>
    8020103e:	00002517          	auipc	a0,0x2
    80201042:	55250513          	addi	a0,a0,1362 # 80203590 <small_numbers+0x410>
    80201046:	fffff097          	auipc	ra,0xfffff
    8020104a:	512080e7          	jalr	1298(ra) # 80200558 <printf>
    8020104e:	00002597          	auipc	a1,0x2
    80201052:	55a58593          	addi	a1,a1,1370 # 802035a8 <small_numbers+0x428>
    80201056:	00002517          	auipc	a0,0x2
    8020105a:	57250513          	addi	a0,a0,1394 # 802035c8 <small_numbers+0x448>
    8020105e:	fffff097          	auipc	ra,0xfffff
    80201062:	4fa080e7          	jalr	1274(ra) # 80200558 <printf>
    80201066:	00002597          	auipc	a1,0x2
    8020106a:	57a58593          	addi	a1,a1,1402 # 802035e0 <small_numbers+0x460>
    8020106e:	00002517          	auipc	a0,0x2
    80201072:	6c250513          	addi	a0,a0,1730 # 80203730 <small_numbers+0x5b0>
    80201076:	fffff097          	auipc	ra,0xfffff
    8020107a:	4e2080e7          	jalr	1250(ra) # 80200558 <printf>
    8020107e:	00002517          	auipc	a0,0x2
    80201082:	6d250513          	addi	a0,a0,1746 # 80203750 <small_numbers+0x5d0>
    80201086:	fffff097          	auipc	ra,0xfffff
    8020108a:	4d2080e7          	jalr	1234(ra) # 80200558 <printf>
    8020108e:	0ff00693          	li	a3,255
    80201092:	f0100613          	li	a2,-255
    80201096:	0ff00593          	li	a1,255
    8020109a:	00002517          	auipc	a0,0x2
    8020109e:	6ce50513          	addi	a0,a0,1742 # 80203768 <small_numbers+0x5e8>
    802010a2:	fffff097          	auipc	ra,0xfffff
    802010a6:	4b6080e7          	jalr	1206(ra) # 80200558 <printf>
    802010aa:	00002517          	auipc	a0,0x2
    802010ae:	6e650513          	addi	a0,a0,1766 # 80203790 <small_numbers+0x610>
    802010b2:	fffff097          	auipc	ra,0xfffff
    802010b6:	4a6080e7          	jalr	1190(ra) # 80200558 <printf>
    802010ba:	00002517          	auipc	a0,0x2
    802010be:	6ee50513          	addi	a0,a0,1774 # 802037a8 <small_numbers+0x628>
    802010c2:	fffff097          	auipc	ra,0xfffff
    802010c6:	496080e7          	jalr	1174(ra) # 80200558 <printf>
    802010ca:	fe043423          	sd	zero,-24(s0)
    802010ce:	00002517          	auipc	a0,0x2
    802010d2:	6f250513          	addi	a0,a0,1778 # 802037c0 <small_numbers+0x640>
    802010d6:	fffff097          	auipc	ra,0xfffff
    802010da:	482080e7          	jalr	1154(ra) # 80200558 <printf>
    802010de:	fe843583          	ld	a1,-24(s0)
    802010e2:	00002517          	auipc	a0,0x2
    802010e6:	6f650513          	addi	a0,a0,1782 # 802037d8 <small_numbers+0x658>
    802010ea:	fffff097          	auipc	ra,0xfffff
    802010ee:	46e080e7          	jalr	1134(ra) # 80200558 <printf>
    802010f2:	02a00793          	li	a5,42
    802010f6:	fef42223          	sw	a5,-28(s0)
    802010fa:	00002517          	auipc	a0,0x2
    802010fe:	6f650513          	addi	a0,a0,1782 # 802037f0 <small_numbers+0x670>
    80201102:	fffff097          	auipc	ra,0xfffff
    80201106:	456080e7          	jalr	1110(ra) # 80200558 <printf>
    8020110a:	fe440793          	addi	a5,s0,-28
    8020110e:	85be                	mv	a1,a5
    80201110:	00002517          	auipc	a0,0x2
    80201114:	6f050513          	addi	a0,a0,1776 # 80203800 <small_numbers+0x680>
    80201118:	fffff097          	auipc	ra,0xfffff
    8020111c:	440080e7          	jalr	1088(ra) # 80200558 <printf>
    80201120:	00002517          	auipc	a0,0x2
    80201124:	6f850513          	addi	a0,a0,1784 # 80203818 <small_numbers+0x698>
    80201128:	fffff097          	auipc	ra,0xfffff
    8020112c:	430080e7          	jalr	1072(ra) # 80200558 <printf>
    80201130:	55fd                	li	a1,-1
    80201132:	00002517          	auipc	a0,0x2
    80201136:	70650513          	addi	a0,a0,1798 # 80203838 <small_numbers+0x6b8>
    8020113a:	fffff097          	auipc	ra,0xfffff
    8020113e:	41e080e7          	jalr	1054(ra) # 80200558 <printf>
    80201142:	00002517          	auipc	a0,0x2
    80201146:	70e50513          	addi	a0,a0,1806 # 80203850 <small_numbers+0x6d0>
    8020114a:	fffff097          	auipc	ra,0xfffff
    8020114e:	40e080e7          	jalr	1038(ra) # 80200558 <printf>
    80201152:	4595                	li	a1,5
    80201154:	00002517          	auipc	a0,0x2
    80201158:	71450513          	addi	a0,a0,1812 # 80203868 <small_numbers+0x6e8>
    8020115c:	fffff097          	auipc	ra,0xfffff
    80201160:	3fc080e7          	jalr	1020(ra) # 80200558 <printf>
    80201164:	45a1                	li	a1,8
    80201166:	00002517          	auipc	a0,0x2
    8020116a:	71a50513          	addi	a0,a0,1818 # 80203880 <small_numbers+0x700>
    8020116e:	fffff097          	auipc	ra,0xfffff
    80201172:	3ea080e7          	jalr	1002(ra) # 80200558 <printf>
    80201176:	00002517          	auipc	a0,0x2
    8020117a:	72250513          	addi	a0,a0,1826 # 80203898 <small_numbers+0x718>
    8020117e:	fffff097          	auipc	ra,0xfffff
    80201182:	3da080e7          	jalr	986(ra) # 80200558 <printf>
    80201186:	0001                	nop
    80201188:	60e2                	ld	ra,24(sp)
    8020118a:	6442                	ld	s0,16(sp)
    8020118c:	6105                	addi	sp,sp,32
    8020118e:	8082                	ret

0000000080201190 <test_curse_move>:
    80201190:	1101                	addi	sp,sp,-32
    80201192:	ec06                	sd	ra,24(sp)
    80201194:	e822                	sd	s0,16(sp)
    80201196:	1000                	addi	s0,sp,32
    80201198:	fffff097          	auipc	ra,0xfffff
    8020119c:	7b8080e7          	jalr	1976(ra) # 80200950 <clear_screen>
    802011a0:	00002517          	auipc	a0,0x2
    802011a4:	71850513          	addi	a0,a0,1816 # 802038b8 <small_numbers+0x738>
    802011a8:	fffff097          	auipc	ra,0xfffff
    802011ac:	3b0080e7          	jalr	944(ra) # 80200558 <printf>
    802011b0:	478d                	li	a5,3
    802011b2:	fef42623          	sw	a5,-20(s0)
    802011b6:	a881                	j	80201206 <test_curse_move+0x76>
    802011b8:	4785                	li	a5,1
    802011ba:	fef42423          	sw	a5,-24(s0)
    802011be:	a805                	j	802011ee <test_curse_move+0x5e>
    802011c0:	fe842703          	lw	a4,-24(s0)
    802011c4:	fec42783          	lw	a5,-20(s0)
    802011c8:	85ba                	mv	a1,a4
    802011ca:	853e                	mv	a0,a5
    802011cc:	00000097          	auipc	ra,0x0
    802011d0:	9da080e7          	jalr	-1574(ra) # 80200ba6 <goto_rc>
    802011d4:	00002517          	auipc	a0,0x2
    802011d8:	70450513          	addi	a0,a0,1796 # 802038d8 <small_numbers+0x758>
    802011dc:	fffff097          	auipc	ra,0xfffff
    802011e0:	37c080e7          	jalr	892(ra) # 80200558 <printf>
    802011e4:	fe842783          	lw	a5,-24(s0)
    802011e8:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdf8dc1>
    802011ea:	fef42423          	sw	a5,-24(s0)
    802011ee:	fe842783          	lw	a5,-24(s0)
    802011f2:	0007871b          	sext.w	a4,a5
    802011f6:	47a9                	li	a5,10
    802011f8:	fce7d4e3          	bge	a5,a4,802011c0 <test_curse_move+0x30>
    802011fc:	fec42783          	lw	a5,-20(s0)
    80201200:	2785                	addiw	a5,a5,1
    80201202:	fef42623          	sw	a5,-20(s0)
    80201206:	fec42783          	lw	a5,-20(s0)
    8020120a:	0007871b          	sext.w	a4,a5
    8020120e:	479d                	li	a5,7
    80201210:	fae7d4e3          	bge	a5,a4,802011b8 <test_curse_move+0x28>
    80201214:	4585                	li	a1,1
    80201216:	4525                	li	a0,9
    80201218:	00000097          	auipc	ra,0x0
    8020121c:	98e080e7          	jalr	-1650(ra) # 80200ba6 <goto_rc>
    80201220:	00000097          	auipc	ra,0x0
    80201224:	8c2080e7          	jalr	-1854(ra) # 80200ae2 <save_cursor>
    80201228:	4515                	li	a0,5
    8020122a:	fffff097          	auipc	ra,0xfffff
    8020122e:	758080e7          	jalr	1880(ra) # 80200982 <cursor_up>
    80201232:	4509                	li	a0,2
    80201234:	fffff097          	auipc	ra,0xfffff
    80201238:	7fe080e7          	jalr	2046(ra) # 80200a32 <cursor_right>
    8020123c:	00002517          	auipc	a0,0x2
    80201240:	6a450513          	addi	a0,a0,1700 # 802038e0 <small_numbers+0x760>
    80201244:	fffff097          	auipc	ra,0xfffff
    80201248:	314080e7          	jalr	788(ra) # 80200558 <printf>
    8020124c:	4509                	li	a0,2
    8020124e:	fffff097          	auipc	ra,0xfffff
    80201252:	78c080e7          	jalr	1932(ra) # 802009da <cursor_down>
    80201256:	4515                	li	a0,5
    80201258:	00000097          	auipc	ra,0x0
    8020125c:	832080e7          	jalr	-1998(ra) # 80200a8a <cursor_left>
    80201260:	00002517          	auipc	a0,0x2
    80201264:	68850513          	addi	a0,a0,1672 # 802038e8 <small_numbers+0x768>
    80201268:	fffff097          	auipc	ra,0xfffff
    8020126c:	2f0080e7          	jalr	752(ra) # 80200558 <printf>
    80201270:	00000097          	auipc	ra,0x0
    80201274:	8a6080e7          	jalr	-1882(ra) # 80200b16 <restore_cursor>
    80201278:	00002517          	auipc	a0,0x2
    8020127c:	67850513          	addi	a0,a0,1656 # 802038f0 <small_numbers+0x770>
    80201280:	fffff097          	auipc	ra,0xfffff
    80201284:	2d8080e7          	jalr	728(ra) # 80200558 <printf>
    80201288:	0001                	nop
    8020128a:	60e2                	ld	ra,24(sp)
    8020128c:	6442                	ld	s0,16(sp)
    8020128e:	6105                	addi	sp,sp,32
    80201290:	8082                	ret

0000000080201292 <test_basic_colors>:
    80201292:	1141                	addi	sp,sp,-16
    80201294:	e406                	sd	ra,8(sp)
    80201296:	e022                	sd	s0,0(sp)
    80201298:	0800                	addi	s0,sp,16
    8020129a:	fffff097          	auipc	ra,0xfffff
    8020129e:	6b6080e7          	jalr	1718(ra) # 80200950 <clear_screen>
    802012a2:	00002517          	auipc	a0,0x2
    802012a6:	67650513          	addi	a0,a0,1654 # 80203918 <small_numbers+0x798>
    802012aa:	fffff097          	auipc	ra,0xfffff
    802012ae:	2ae080e7          	jalr	686(ra) # 80200558 <printf>
    802012b2:	00002517          	auipc	a0,0x2
    802012b6:	68650513          	addi	a0,a0,1670 # 80203938 <small_numbers+0x7b8>
    802012ba:	fffff097          	auipc	ra,0xfffff
    802012be:	29e080e7          	jalr	670(ra) # 80200558 <printf>
    802012c2:	00000097          	auipc	ra,0x0
    802012c6:	a52080e7          	jalr	-1454(ra) # 80200d14 <color_red>
    802012ca:	00002517          	auipc	a0,0x2
    802012ce:	68650513          	addi	a0,a0,1670 # 80203950 <small_numbers+0x7d0>
    802012d2:	fffff097          	auipc	ra,0xfffff
    802012d6:	286080e7          	jalr	646(ra) # 80200558 <printf>
    802012da:	00000097          	auipc	ra,0x0
    802012de:	a56080e7          	jalr	-1450(ra) # 80200d30 <color_green>
    802012e2:	00002517          	auipc	a0,0x2
    802012e6:	67e50513          	addi	a0,a0,1662 # 80203960 <small_numbers+0x7e0>
    802012ea:	fffff097          	auipc	ra,0xfffff
    802012ee:	26e080e7          	jalr	622(ra) # 80200558 <printf>
    802012f2:	00000097          	auipc	ra,0x0
    802012f6:	a5c080e7          	jalr	-1444(ra) # 80200d4e <color_yellow>
    802012fa:	00002517          	auipc	a0,0x2
    802012fe:	67650513          	addi	a0,a0,1654 # 80203970 <small_numbers+0x7f0>
    80201302:	fffff097          	auipc	ra,0xfffff
    80201306:	256080e7          	jalr	598(ra) # 80200558 <printf>
    8020130a:	00000097          	auipc	ra,0x0
    8020130e:	a62080e7          	jalr	-1438(ra) # 80200d6c <color_blue>
    80201312:	00002517          	auipc	a0,0x2
    80201316:	66e50513          	addi	a0,a0,1646 # 80203980 <small_numbers+0x800>
    8020131a:	fffff097          	auipc	ra,0xfffff
    8020131e:	23e080e7          	jalr	574(ra) # 80200558 <printf>
    80201322:	00000097          	auipc	ra,0x0
    80201326:	a68080e7          	jalr	-1432(ra) # 80200d8a <color_purple>
    8020132a:	00002517          	auipc	a0,0x2
    8020132e:	66650513          	addi	a0,a0,1638 # 80203990 <small_numbers+0x810>
    80201332:	fffff097          	auipc	ra,0xfffff
    80201336:	226080e7          	jalr	550(ra) # 80200558 <printf>
    8020133a:	00000097          	auipc	ra,0x0
    8020133e:	a6e080e7          	jalr	-1426(ra) # 80200da8 <color_cyan>
    80201342:	00002517          	auipc	a0,0x2
    80201346:	65e50513          	addi	a0,a0,1630 # 802039a0 <small_numbers+0x820>
    8020134a:	fffff097          	auipc	ra,0xfffff
    8020134e:	20e080e7          	jalr	526(ra) # 80200558 <printf>
    80201352:	00000097          	auipc	ra,0x0
    80201356:	a74080e7          	jalr	-1420(ra) # 80200dc6 <color_reverse>
    8020135a:	00002517          	auipc	a0,0x2
    8020135e:	65650513          	addi	a0,a0,1622 # 802039b0 <small_numbers+0x830>
    80201362:	fffff097          	auipc	ra,0xfffff
    80201366:	1f6080e7          	jalr	502(ra) # 80200558 <printf>
    8020136a:	00000097          	auipc	ra,0x0
    8020136e:	8ae080e7          	jalr	-1874(ra) # 80200c18 <reset_color>
    80201372:	00002517          	auipc	a0,0x2
    80201376:	64e50513          	addi	a0,a0,1614 # 802039c0 <small_numbers+0x840>
    8020137a:	fffff097          	auipc	ra,0xfffff
    8020137e:	1de080e7          	jalr	478(ra) # 80200558 <printf>
    80201382:	00002517          	auipc	a0,0x2
    80201386:	64650513          	addi	a0,a0,1606 # 802039c8 <small_numbers+0x848>
    8020138a:	fffff097          	auipc	ra,0xfffff
    8020138e:	1ce080e7          	jalr	462(ra) # 80200558 <printf>
    80201392:	02900513          	li	a0,41
    80201396:	00000097          	auipc	ra,0x0
    8020139a:	910080e7          	jalr	-1776(ra) # 80200ca6 <set_bg_color>
    8020139e:	00002517          	auipc	a0,0x2
    802013a2:	64250513          	addi	a0,a0,1602 # 802039e0 <small_numbers+0x860>
    802013a6:	fffff097          	auipc	ra,0xfffff
    802013aa:	1b2080e7          	jalr	434(ra) # 80200558 <printf>
    802013ae:	00000097          	auipc	ra,0x0
    802013b2:	86a080e7          	jalr	-1942(ra) # 80200c18 <reset_color>
    802013b6:	02a00513          	li	a0,42
    802013ba:	00000097          	auipc	ra,0x0
    802013be:	8ec080e7          	jalr	-1812(ra) # 80200ca6 <set_bg_color>
    802013c2:	00002517          	auipc	a0,0x2
    802013c6:	62e50513          	addi	a0,a0,1582 # 802039f0 <small_numbers+0x870>
    802013ca:	fffff097          	auipc	ra,0xfffff
    802013ce:	18e080e7          	jalr	398(ra) # 80200558 <printf>
    802013d2:	00000097          	auipc	ra,0x0
    802013d6:	846080e7          	jalr	-1978(ra) # 80200c18 <reset_color>
    802013da:	02b00513          	li	a0,43
    802013de:	00000097          	auipc	ra,0x0
    802013e2:	8c8080e7          	jalr	-1848(ra) # 80200ca6 <set_bg_color>
    802013e6:	00002517          	auipc	a0,0x2
    802013ea:	61a50513          	addi	a0,a0,1562 # 80203a00 <small_numbers+0x880>
    802013ee:	fffff097          	auipc	ra,0xfffff
    802013f2:	16a080e7          	jalr	362(ra) # 80200558 <printf>
    802013f6:	00000097          	auipc	ra,0x0
    802013fa:	822080e7          	jalr	-2014(ra) # 80200c18 <reset_color>
    802013fe:	02c00513          	li	a0,44
    80201402:	00000097          	auipc	ra,0x0
    80201406:	8a4080e7          	jalr	-1884(ra) # 80200ca6 <set_bg_color>
    8020140a:	00002517          	auipc	a0,0x2
    8020140e:	60650513          	addi	a0,a0,1542 # 80203a10 <small_numbers+0x890>
    80201412:	fffff097          	auipc	ra,0xfffff
    80201416:	146080e7          	jalr	326(ra) # 80200558 <printf>
    8020141a:	fffff097          	auipc	ra,0xfffff
    8020141e:	7fe080e7          	jalr	2046(ra) # 80200c18 <reset_color>
    80201422:	02f00513          	li	a0,47
    80201426:	00000097          	auipc	ra,0x0
    8020142a:	880080e7          	jalr	-1920(ra) # 80200ca6 <set_bg_color>
    8020142e:	00002517          	auipc	a0,0x2
    80201432:	5f250513          	addi	a0,a0,1522 # 80203a20 <small_numbers+0x8a0>
    80201436:	fffff097          	auipc	ra,0xfffff
    8020143a:	122080e7          	jalr	290(ra) # 80200558 <printf>
    8020143e:	fffff097          	auipc	ra,0xfffff
    80201442:	7da080e7          	jalr	2010(ra) # 80200c18 <reset_color>
    80201446:	00002517          	auipc	a0,0x2
    8020144a:	57a50513          	addi	a0,a0,1402 # 802039c0 <small_numbers+0x840>
    8020144e:	fffff097          	auipc	ra,0xfffff
    80201452:	10a080e7          	jalr	266(ra) # 80200558 <printf>
    80201456:	00002517          	auipc	a0,0x2
    8020145a:	5da50513          	addi	a0,a0,1498 # 80203a30 <small_numbers+0x8b0>
    8020145e:	fffff097          	auipc	ra,0xfffff
    80201462:	0fa080e7          	jalr	250(ra) # 80200558 <printf>
    80201466:	02c00593          	li	a1,44
    8020146a:	457d                	li	a0,31
    8020146c:	00000097          	auipc	ra,0x0
    80201470:	978080e7          	jalr	-1672(ra) # 80200de4 <set_color>
    80201474:	00002517          	auipc	a0,0x2
    80201478:	5d450513          	addi	a0,a0,1492 # 80203a48 <small_numbers+0x8c8>
    8020147c:	fffff097          	auipc	ra,0xfffff
    80201480:	0dc080e7          	jalr	220(ra) # 80200558 <printf>
    80201484:	fffff097          	auipc	ra,0xfffff
    80201488:	794080e7          	jalr	1940(ra) # 80200c18 <reset_color>
    8020148c:	02d00593          	li	a1,45
    80201490:	02100513          	li	a0,33
    80201494:	00000097          	auipc	ra,0x0
    80201498:	950080e7          	jalr	-1712(ra) # 80200de4 <set_color>
    8020149c:	00002517          	auipc	a0,0x2
    802014a0:	5bc50513          	addi	a0,a0,1468 # 80203a58 <small_numbers+0x8d8>
    802014a4:	fffff097          	auipc	ra,0xfffff
    802014a8:	0b4080e7          	jalr	180(ra) # 80200558 <printf>
    802014ac:	fffff097          	auipc	ra,0xfffff
    802014b0:	76c080e7          	jalr	1900(ra) # 80200c18 <reset_color>
    802014b4:	02f00593          	li	a1,47
    802014b8:	02000513          	li	a0,32
    802014bc:	00000097          	auipc	ra,0x0
    802014c0:	928080e7          	jalr	-1752(ra) # 80200de4 <set_color>
    802014c4:	00002517          	auipc	a0,0x2
    802014c8:	5a450513          	addi	a0,a0,1444 # 80203a68 <small_numbers+0x8e8>
    802014cc:	fffff097          	auipc	ra,0xfffff
    802014d0:	08c080e7          	jalr	140(ra) # 80200558 <printf>
    802014d4:	fffff097          	auipc	ra,0xfffff
    802014d8:	744080e7          	jalr	1860(ra) # 80200c18 <reset_color>
    802014dc:	00002517          	auipc	a0,0x2
    802014e0:	4e450513          	addi	a0,a0,1252 # 802039c0 <small_numbers+0x840>
    802014e4:	fffff097          	auipc	ra,0xfffff
    802014e8:	074080e7          	jalr	116(ra) # 80200558 <printf>
    802014ec:	fffff097          	auipc	ra,0xfffff
    802014f0:	72c080e7          	jalr	1836(ra) # 80200c18 <reset_color>
    802014f4:	00002517          	auipc	a0,0x2
    802014f8:	58450513          	addi	a0,a0,1412 # 80203a78 <small_numbers+0x8f8>
    802014fc:	fffff097          	auipc	ra,0xfffff
    80201500:	05c080e7          	jalr	92(ra) # 80200558 <printf>
    80201504:	4505                	li	a0,1
    80201506:	fffff097          	auipc	ra,0xfffff
    8020150a:	47c080e7          	jalr	1148(ra) # 80200982 <cursor_up>
    8020150e:	00000097          	auipc	ra,0x0
    80201512:	912080e7          	jalr	-1774(ra) # 80200e20 <clear_line>
    80201516:	00002517          	auipc	a0,0x2
    8020151a:	59a50513          	addi	a0,a0,1434 # 80203ab0 <small_numbers+0x930>
    8020151e:	fffff097          	auipc	ra,0xfffff
    80201522:	03a080e7          	jalr	58(ra) # 80200558 <printf>
    80201526:	0001                	nop
    80201528:	60a2                	ld	ra,8(sp)
    8020152a:	6402                	ld	s0,0(sp)
    8020152c:	0141                	addi	sp,sp,16
    8020152e:	8082                	ret

0000000080201530 <memset>:
    80201530:	7139                	addi	sp,sp,-64
    80201532:	fc22                	sd	s0,56(sp)
    80201534:	0080                	addi	s0,sp,64
    80201536:	fca43c23          	sd	a0,-40(s0)
    8020153a:	87ae                	mv	a5,a1
    8020153c:	fcc43423          	sd	a2,-56(s0)
    80201540:	fcf42a23          	sw	a5,-44(s0)
    80201544:	fd843783          	ld	a5,-40(s0)
    80201548:	fef43423          	sd	a5,-24(s0)
    8020154c:	a829                	j	80201566 <memset+0x36>
    8020154e:	fe843783          	ld	a5,-24(s0)
    80201552:	00178713          	addi	a4,a5,1
    80201556:	fee43423          	sd	a4,-24(s0)
    8020155a:	fd442703          	lw	a4,-44(s0)
    8020155e:	0ff77713          	zext.b	a4,a4
    80201562:	00e78023          	sb	a4,0(a5)
    80201566:	fc843783          	ld	a5,-56(s0)
    8020156a:	fff78713          	addi	a4,a5,-1
    8020156e:	fce43423          	sd	a4,-56(s0)
    80201572:	fff1                	bnez	a5,8020154e <memset+0x1e>
    80201574:	fd843783          	ld	a5,-40(s0)
    80201578:	853e                	mv	a0,a5
    8020157a:	7462                	ld	s0,56(sp)
    8020157c:	6121                	addi	sp,sp,64
    8020157e:	8082                	ret

0000000080201580 <assert>:
    80201580:	1101                	addi	sp,sp,-32
    80201582:	ec06                	sd	ra,24(sp)
    80201584:	e822                	sd	s0,16(sp)
    80201586:	1000                	addi	s0,sp,32
    80201588:	87aa                	mv	a5,a0
    8020158a:	fef42623          	sw	a5,-20(s0)
    8020158e:	fec42783          	lw	a5,-20(s0)
    80201592:	2781                	sext.w	a5,a5
    80201594:	e795                	bnez	a5,802015c0 <assert+0x40>
    80201596:	4615                	li	a2,5
    80201598:	00002597          	auipc	a1,0x2
    8020159c:	53858593          	addi	a1,a1,1336 # 80203ad0 <small_numbers+0x950>
    802015a0:	00002517          	auipc	a0,0x2
    802015a4:	54050513          	addi	a0,a0,1344 # 80203ae0 <small_numbers+0x960>
    802015a8:	fffff097          	auipc	ra,0xfffff
    802015ac:	fb0080e7          	jalr	-80(ra) # 80200558 <printf>
    802015b0:	00002517          	auipc	a0,0x2
    802015b4:	55850513          	addi	a0,a0,1368 # 80203b08 <small_numbers+0x988>
    802015b8:	00000097          	auipc	ra,0x0
    802015bc:	8a8080e7          	jalr	-1880(ra) # 80200e60 <panic>
    802015c0:	0001                	nop
    802015c2:	60e2                	ld	ra,24(sp)
    802015c4:	6442                	ld	s0,16(sp)
    802015c6:	6105                	addi	sp,sp,32
    802015c8:	8082                	ret

00000000802015ca <px>:
    802015ca:	1101                	addi	sp,sp,-32
    802015cc:	ec22                	sd	s0,24(sp)
    802015ce:	1000                	addi	s0,sp,32
    802015d0:	87aa                	mv	a5,a0
    802015d2:	feb43023          	sd	a1,-32(s0)
    802015d6:	fef42623          	sw	a5,-20(s0)
    802015da:	fec42783          	lw	a5,-20(s0)
    802015de:	873e                	mv	a4,a5
    802015e0:	87ba                	mv	a5,a4
    802015e2:	0037979b          	slliw	a5,a5,0x3
    802015e6:	9fb9                	addw	a5,a5,a4
    802015e8:	2781                	sext.w	a5,a5
    802015ea:	27b1                	addiw	a5,a5,12
    802015ec:	2781                	sext.w	a5,a5
    802015ee:	873e                	mv	a4,a5
    802015f0:	fe043783          	ld	a5,-32(s0)
    802015f4:	00e7d7b3          	srl	a5,a5,a4
    802015f8:	1ff7f793          	andi	a5,a5,511
    802015fc:	853e                	mv	a0,a5
    802015fe:	6462                	ld	s0,24(sp)
    80201600:	6105                	addi	sp,sp,32
    80201602:	8082                	ret

0000000080201604 <create_pagetable>:
    80201604:	1101                	addi	sp,sp,-32
    80201606:	ec06                	sd	ra,24(sp)
    80201608:	e822                	sd	s0,16(sp)
    8020160a:	1000                	addi	s0,sp,32
    8020160c:	00001097          	auipc	ra,0x1
    80201610:	900080e7          	jalr	-1792(ra) # 80201f0c <alloc_page>
    80201614:	fea43423          	sd	a0,-24(s0)
    80201618:	fe843783          	ld	a5,-24(s0)
    8020161c:	e399                	bnez	a5,80201622 <create_pagetable+0x1e>
    8020161e:	4781                	li	a5,0
    80201620:	a819                	j	80201636 <create_pagetable+0x32>
    80201622:	6605                	lui	a2,0x1
    80201624:	4581                	li	a1,0
    80201626:	fe843503          	ld	a0,-24(s0)
    8020162a:	00000097          	auipc	ra,0x0
    8020162e:	f06080e7          	jalr	-250(ra) # 80201530 <memset>
    80201632:	fe843783          	ld	a5,-24(s0)
    80201636:	853e                	mv	a0,a5
    80201638:	60e2                	ld	ra,24(sp)
    8020163a:	6442                	ld	s0,16(sp)
    8020163c:	6105                	addi	sp,sp,32
    8020163e:	8082                	ret

0000000080201640 <walk_lookup>:
    80201640:	7179                	addi	sp,sp,-48
    80201642:	f406                	sd	ra,40(sp)
    80201644:	f022                	sd	s0,32(sp)
    80201646:	1800                	addi	s0,sp,48
    80201648:	fca43c23          	sd	a0,-40(s0)
    8020164c:	fcb43823          	sd	a1,-48(s0)
    80201650:	fd043703          	ld	a4,-48(s0)
    80201654:	57fd                	li	a5,-1
    80201656:	83e5                	srli	a5,a5,0x19
    80201658:	00e7fa63          	bgeu	a5,a4,8020166c <walk_lookup+0x2c>
    8020165c:	00002517          	auipc	a0,0x2
    80201660:	4b450513          	addi	a0,a0,1204 # 80203b10 <small_numbers+0x990>
    80201664:	fffff097          	auipc	ra,0xfffff
    80201668:	7fc080e7          	jalr	2044(ra) # 80200e60 <panic>
    8020166c:	4789                	li	a5,2
    8020166e:	fef42623          	sw	a5,-20(s0)
    80201672:	a0a9                	j	802016bc <walk_lookup+0x7c>
    80201674:	fec42783          	lw	a5,-20(s0)
    80201678:	fd043583          	ld	a1,-48(s0)
    8020167c:	853e                	mv	a0,a5
    8020167e:	00000097          	auipc	ra,0x0
    80201682:	f4c080e7          	jalr	-180(ra) # 802015ca <px>
    80201686:	87aa                	mv	a5,a0
    80201688:	078e                	slli	a5,a5,0x3
    8020168a:	fd843703          	ld	a4,-40(s0)
    8020168e:	97ba                	add	a5,a5,a4
    80201690:	fef43023          	sd	a5,-32(s0)
    80201694:	fe043783          	ld	a5,-32(s0)
    80201698:	639c                	ld	a5,0(a5)
    8020169a:	8b85                	andi	a5,a5,1
    8020169c:	cb89                	beqz	a5,802016ae <walk_lookup+0x6e>
    8020169e:	fe043783          	ld	a5,-32(s0)
    802016a2:	639c                	ld	a5,0(a5)
    802016a4:	83a9                	srli	a5,a5,0xa
    802016a6:	07b2                	slli	a5,a5,0xc
    802016a8:	fcf43c23          	sd	a5,-40(s0)
    802016ac:	a019                	j	802016b2 <walk_lookup+0x72>
    802016ae:	4781                	li	a5,0
    802016b0:	a03d                	j	802016de <walk_lookup+0x9e>
    802016b2:	fec42783          	lw	a5,-20(s0)
    802016b6:	37fd                	addiw	a5,a5,-1
    802016b8:	fef42623          	sw	a5,-20(s0)
    802016bc:	fec42783          	lw	a5,-20(s0)
    802016c0:	2781                	sext.w	a5,a5
    802016c2:	faf049e3          	bgtz	a5,80201674 <walk_lookup+0x34>
    802016c6:	fd043583          	ld	a1,-48(s0)
    802016ca:	4501                	li	a0,0
    802016cc:	00000097          	auipc	ra,0x0
    802016d0:	efe080e7          	jalr	-258(ra) # 802015ca <px>
    802016d4:	87aa                	mv	a5,a0
    802016d6:	078e                	slli	a5,a5,0x3
    802016d8:	fd843703          	ld	a4,-40(s0)
    802016dc:	97ba                	add	a5,a5,a4
    802016de:	853e                	mv	a0,a5
    802016e0:	70a2                	ld	ra,40(sp)
    802016e2:	7402                	ld	s0,32(sp)
    802016e4:	6145                	addi	sp,sp,48
    802016e6:	8082                	ret

00000000802016e8 <walk_create>:
    802016e8:	7139                	addi	sp,sp,-64
    802016ea:	fc06                	sd	ra,56(sp)
    802016ec:	f822                	sd	s0,48(sp)
    802016ee:	0080                	addi	s0,sp,64
    802016f0:	fca43423          	sd	a0,-56(s0)
    802016f4:	fcb43023          	sd	a1,-64(s0)
    802016f8:	fc043703          	ld	a4,-64(s0)
    802016fc:	57fd                	li	a5,-1
    802016fe:	83e5                	srli	a5,a5,0x19
    80201700:	00e7fa63          	bgeu	a5,a4,80201714 <walk_create+0x2c>
    80201704:	00002517          	auipc	a0,0x2
    80201708:	42c50513          	addi	a0,a0,1068 # 80203b30 <small_numbers+0x9b0>
    8020170c:	fffff097          	auipc	ra,0xfffff
    80201710:	754080e7          	jalr	1876(ra) # 80200e60 <panic>
    80201714:	4789                	li	a5,2
    80201716:	fef42623          	sw	a5,-20(s0)
    8020171a:	a059                	j	802017a0 <walk_create+0xb8>
    8020171c:	fec42783          	lw	a5,-20(s0)
    80201720:	fc043583          	ld	a1,-64(s0)
    80201724:	853e                	mv	a0,a5
    80201726:	00000097          	auipc	ra,0x0
    8020172a:	ea4080e7          	jalr	-348(ra) # 802015ca <px>
    8020172e:	87aa                	mv	a5,a0
    80201730:	078e                	slli	a5,a5,0x3
    80201732:	fc843703          	ld	a4,-56(s0)
    80201736:	97ba                	add	a5,a5,a4
    80201738:	fef43023          	sd	a5,-32(s0)
    8020173c:	fe043783          	ld	a5,-32(s0)
    80201740:	639c                	ld	a5,0(a5)
    80201742:	8b85                	andi	a5,a5,1
    80201744:	cb89                	beqz	a5,80201756 <walk_create+0x6e>
    80201746:	fe043783          	ld	a5,-32(s0)
    8020174a:	639c                	ld	a5,0(a5)
    8020174c:	83a9                	srli	a5,a5,0xa
    8020174e:	07b2                	slli	a5,a5,0xc
    80201750:	fcf43423          	sd	a5,-56(s0)
    80201754:	a089                	j	80201796 <walk_create+0xae>
    80201756:	00000097          	auipc	ra,0x0
    8020175a:	7b6080e7          	jalr	1974(ra) # 80201f0c <alloc_page>
    8020175e:	fca43c23          	sd	a0,-40(s0)
    80201762:	fd843783          	ld	a5,-40(s0)
    80201766:	e399                	bnez	a5,8020176c <walk_create+0x84>
    80201768:	4781                	li	a5,0
    8020176a:	a8a1                	j	802017c2 <walk_create+0xda>
    8020176c:	6605                	lui	a2,0x1
    8020176e:	4581                	li	a1,0
    80201770:	fd843503          	ld	a0,-40(s0)
    80201774:	00000097          	auipc	ra,0x0
    80201778:	dbc080e7          	jalr	-580(ra) # 80201530 <memset>
    8020177c:	fd843783          	ld	a5,-40(s0)
    80201780:	83b1                	srli	a5,a5,0xc
    80201782:	07aa                	slli	a5,a5,0xa
    80201784:	0017e713          	ori	a4,a5,1
    80201788:	fe043783          	ld	a5,-32(s0)
    8020178c:	e398                	sd	a4,0(a5)
    8020178e:	fd843783          	ld	a5,-40(s0)
    80201792:	fcf43423          	sd	a5,-56(s0)
    80201796:	fec42783          	lw	a5,-20(s0)
    8020179a:	37fd                	addiw	a5,a5,-1
    8020179c:	fef42623          	sw	a5,-20(s0)
    802017a0:	fec42783          	lw	a5,-20(s0)
    802017a4:	2781                	sext.w	a5,a5
    802017a6:	f6f04be3          	bgtz	a5,8020171c <walk_create+0x34>
    802017aa:	fc043583          	ld	a1,-64(s0)
    802017ae:	4501                	li	a0,0
    802017b0:	00000097          	auipc	ra,0x0
    802017b4:	e1a080e7          	jalr	-486(ra) # 802015ca <px>
    802017b8:	87aa                	mv	a5,a0
    802017ba:	078e                	slli	a5,a5,0x3
    802017bc:	fc843703          	ld	a4,-56(s0)
    802017c0:	97ba                	add	a5,a5,a4
    802017c2:	853e                	mv	a0,a5
    802017c4:	70e2                	ld	ra,56(sp)
    802017c6:	7442                	ld	s0,48(sp)
    802017c8:	6121                	addi	sp,sp,64
    802017ca:	8082                	ret

00000000802017cc <map_page>:
    802017cc:	7139                	addi	sp,sp,-64
    802017ce:	fc06                	sd	ra,56(sp)
    802017d0:	f822                	sd	s0,48(sp)
    802017d2:	0080                	addi	s0,sp,64
    802017d4:	fca43c23          	sd	a0,-40(s0)
    802017d8:	fcb43823          	sd	a1,-48(s0)
    802017dc:	fcc43423          	sd	a2,-56(s0)
    802017e0:	87b6                	mv	a5,a3
    802017e2:	fcf42223          	sw	a5,-60(s0)
    802017e6:	fd043703          	ld	a4,-48(s0)
    802017ea:	6785                	lui	a5,0x1
    802017ec:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802017ee:	8ff9                	and	a5,a5,a4
    802017f0:	cb89                	beqz	a5,80201802 <map_page+0x36>
    802017f2:	00002517          	auipc	a0,0x2
    802017f6:	35e50513          	addi	a0,a0,862 # 80203b50 <small_numbers+0x9d0>
    802017fa:	fffff097          	auipc	ra,0xfffff
    802017fe:	666080e7          	jalr	1638(ra) # 80200e60 <panic>
    80201802:	fd043583          	ld	a1,-48(s0)
    80201806:	fd843503          	ld	a0,-40(s0)
    8020180a:	00000097          	auipc	ra,0x0
    8020180e:	ede080e7          	jalr	-290(ra) # 802016e8 <walk_create>
    80201812:	fea43423          	sd	a0,-24(s0)
    80201816:	fe843783          	ld	a5,-24(s0)
    8020181a:	e399                	bnez	a5,80201820 <map_page+0x54>
    8020181c:	57fd                	li	a5,-1
    8020181e:	a069                	j	802018a8 <map_page+0xdc>
    80201820:	fe843783          	ld	a5,-24(s0)
    80201824:	639c                	ld	a5,0(a5)
    80201826:	8b85                	andi	a5,a5,1
    80201828:	c3b5                	beqz	a5,8020188c <map_page+0xc0>
    8020182a:	fe843783          	ld	a5,-24(s0)
    8020182e:	639c                	ld	a5,0(a5)
    80201830:	83a9                	srli	a5,a5,0xa
    80201832:	07b2                	slli	a5,a5,0xc
    80201834:	fc843703          	ld	a4,-56(s0)
    80201838:	04f71263          	bne	a4,a5,8020187c <map_page+0xb0>
    8020183c:	fe843783          	ld	a5,-24(s0)
    80201840:	639c                	ld	a5,0(a5)
    80201842:	2781                	sext.w	a5,a5
    80201844:	3ff7f793          	andi	a5,a5,1023
    80201848:	0007871b          	sext.w	a4,a5
    8020184c:	fc442783          	lw	a5,-60(s0)
    80201850:	8fd9                	or	a5,a5,a4
    80201852:	2781                	sext.w	a5,a5
    80201854:	2781                	sext.w	a5,a5
    80201856:	3ff7f793          	andi	a5,a5,1023
    8020185a:	fef42223          	sw	a5,-28(s0)
    8020185e:	fc843783          	ld	a5,-56(s0)
    80201862:	83b1                	srli	a5,a5,0xc
    80201864:	00a79713          	slli	a4,a5,0xa
    80201868:	fe442783          	lw	a5,-28(s0)
    8020186c:	8fd9                	or	a5,a5,a4
    8020186e:	0017e713          	ori	a4,a5,1
    80201872:	fe843783          	ld	a5,-24(s0)
    80201876:	e398                	sd	a4,0(a5)
    80201878:	4781                	li	a5,0
    8020187a:	a03d                	j	802018a8 <map_page+0xdc>
    8020187c:	00002517          	auipc	a0,0x2
    80201880:	2f450513          	addi	a0,a0,756 # 80203b70 <small_numbers+0x9f0>
    80201884:	fffff097          	auipc	ra,0xfffff
    80201888:	5dc080e7          	jalr	1500(ra) # 80200e60 <panic>
    8020188c:	fc843783          	ld	a5,-56(s0)
    80201890:	83b1                	srli	a5,a5,0xc
    80201892:	00a79713          	slli	a4,a5,0xa
    80201896:	fc442783          	lw	a5,-60(s0)
    8020189a:	8fd9                	or	a5,a5,a4
    8020189c:	0017e713          	ori	a4,a5,1
    802018a0:	fe843783          	ld	a5,-24(s0)
    802018a4:	e398                	sd	a4,0(a5)
    802018a6:	4781                	li	a5,0
    802018a8:	853e                	mv	a0,a5
    802018aa:	70e2                	ld	ra,56(sp)
    802018ac:	7442                	ld	s0,48(sp)
    802018ae:	6121                	addi	sp,sp,64
    802018b0:	8082                	ret

00000000802018b2 <free_pagetable>:
    802018b2:	7139                	addi	sp,sp,-64
    802018b4:	fc06                	sd	ra,56(sp)
    802018b6:	f822                	sd	s0,48(sp)
    802018b8:	0080                	addi	s0,sp,64
    802018ba:	fca43423          	sd	a0,-56(s0)
    802018be:	fe042623          	sw	zero,-20(s0)
    802018c2:	a8a5                	j	8020193a <free_pagetable+0x88>
    802018c4:	fec42783          	lw	a5,-20(s0)
    802018c8:	078e                	slli	a5,a5,0x3
    802018ca:	fc843703          	ld	a4,-56(s0)
    802018ce:	97ba                	add	a5,a5,a4
    802018d0:	639c                	ld	a5,0(a5)
    802018d2:	fef43023          	sd	a5,-32(s0)
    802018d6:	fe043783          	ld	a5,-32(s0)
    802018da:	8b85                	andi	a5,a5,1
    802018dc:	cb95                	beqz	a5,80201910 <free_pagetable+0x5e>
    802018de:	fe043783          	ld	a5,-32(s0)
    802018e2:	8bb9                	andi	a5,a5,14
    802018e4:	e795                	bnez	a5,80201910 <free_pagetable+0x5e>
    802018e6:	fe043783          	ld	a5,-32(s0)
    802018ea:	83a9                	srli	a5,a5,0xa
    802018ec:	07b2                	slli	a5,a5,0xc
    802018ee:	fcf43c23          	sd	a5,-40(s0)
    802018f2:	fd843503          	ld	a0,-40(s0)
    802018f6:	00000097          	auipc	ra,0x0
    802018fa:	fbc080e7          	jalr	-68(ra) # 802018b2 <free_pagetable>
    802018fe:	fec42783          	lw	a5,-20(s0)
    80201902:	078e                	slli	a5,a5,0x3
    80201904:	fc843703          	ld	a4,-56(s0)
    80201908:	97ba                	add	a5,a5,a4
    8020190a:	0007b023          	sd	zero,0(a5)
    8020190e:	a00d                	j	80201930 <free_pagetable+0x7e>
    80201910:	fe043783          	ld	a5,-32(s0)
    80201914:	8b85                	andi	a5,a5,1
    80201916:	cf89                	beqz	a5,80201930 <free_pagetable+0x7e>
    80201918:	fe043783          	ld	a5,-32(s0)
    8020191c:	8bb9                	andi	a5,a5,14
    8020191e:	cb89                	beqz	a5,80201930 <free_pagetable+0x7e>
    80201920:	fec42783          	lw	a5,-20(s0)
    80201924:	078e                	slli	a5,a5,0x3
    80201926:	fc843703          	ld	a4,-56(s0)
    8020192a:	97ba                	add	a5,a5,a4
    8020192c:	0007b023          	sd	zero,0(a5)
    80201930:	fec42783          	lw	a5,-20(s0)
    80201934:	2785                	addiw	a5,a5,1
    80201936:	fef42623          	sw	a5,-20(s0)
    8020193a:	fec42783          	lw	a5,-20(s0)
    8020193e:	0007871b          	sext.w	a4,a5
    80201942:	1ff00793          	li	a5,511
    80201946:	f6e7dfe3          	bge	a5,a4,802018c4 <free_pagetable+0x12>
    8020194a:	fc843503          	ld	a0,-56(s0)
    8020194e:	00000097          	auipc	ra,0x0
    80201952:	62a080e7          	jalr	1578(ra) # 80201f78 <free_page>
    80201956:	0001                	nop
    80201958:	70e2                	ld	ra,56(sp)
    8020195a:	7442                	ld	s0,48(sp)
    8020195c:	6121                	addi	sp,sp,64
    8020195e:	8082                	ret

0000000080201960 <kvmmake>:
    80201960:	711d                	addi	sp,sp,-96
    80201962:	ec86                	sd	ra,88(sp)
    80201964:	e8a2                	sd	s0,80(sp)
    80201966:	1080                	addi	s0,sp,96
    80201968:	00000097          	auipc	ra,0x0
    8020196c:	c9c080e7          	jalr	-868(ra) # 80201604 <create_pagetable>
    80201970:	faa43c23          	sd	a0,-72(s0)
    80201974:	fb843783          	ld	a5,-72(s0)
    80201978:	eb89                	bnez	a5,8020198a <kvmmake+0x2a>
    8020197a:	00002517          	auipc	a0,0x2
    8020197e:	22650513          	addi	a0,a0,550 # 80203ba0 <small_numbers+0xa20>
    80201982:	fffff097          	auipc	ra,0xfffff
    80201986:	4de080e7          	jalr	1246(ra) # 80200e60 <panic>
    8020198a:	4785                	li	a5,1
    8020198c:	07fe                	slli	a5,a5,0x1f
    8020198e:	fef43423          	sd	a5,-24(s0)
    80201992:	a825                	j	802019ca <kvmmake+0x6a>
    80201994:	46a9                	li	a3,10
    80201996:	fe843603          	ld	a2,-24(s0)
    8020199a:	fe843583          	ld	a1,-24(s0)
    8020199e:	fb843503          	ld	a0,-72(s0)
    802019a2:	00000097          	auipc	ra,0x0
    802019a6:	e2a080e7          	jalr	-470(ra) # 802017cc <map_page>
    802019aa:	87aa                	mv	a5,a0
    802019ac:	cb89                	beqz	a5,802019be <kvmmake+0x5e>
    802019ae:	00002517          	auipc	a0,0x2
    802019b2:	20a50513          	addi	a0,a0,522 # 80203bb8 <small_numbers+0xa38>
    802019b6:	fffff097          	auipc	ra,0xfffff
    802019ba:	4aa080e7          	jalr	1194(ra) # 80200e60 <panic>
    802019be:	fe843703          	ld	a4,-24(s0)
    802019c2:	6785                	lui	a5,0x1
    802019c4:	97ba                	add	a5,a5,a4
    802019c6:	fef43423          	sd	a5,-24(s0)
    802019ca:	00001797          	auipc	a5,0x1
    802019ce:	63678793          	addi	a5,a5,1590 # 80203000 <etext>
    802019d2:	fe843703          	ld	a4,-24(s0)
    802019d6:	faf76fe3          	bltu	a4,a5,80201994 <kvmmake+0x34>
    802019da:	00001797          	auipc	a5,0x1
    802019de:	62678793          	addi	a5,a5,1574 # 80203000 <etext>
    802019e2:	fef43023          	sd	a5,-32(s0)
    802019e6:	a825                	j	80201a1e <kvmmake+0xbe>
    802019e8:	4699                	li	a3,6
    802019ea:	fe043603          	ld	a2,-32(s0)
    802019ee:	fe043583          	ld	a1,-32(s0)
    802019f2:	fb843503          	ld	a0,-72(s0)
    802019f6:	00000097          	auipc	ra,0x0
    802019fa:	dd6080e7          	jalr	-554(ra) # 802017cc <map_page>
    802019fe:	87aa                	mv	a5,a0
    80201a00:	cb89                	beqz	a5,80201a12 <kvmmake+0xb2>
    80201a02:	00002517          	auipc	a0,0x2
    80201a06:	1d650513          	addi	a0,a0,470 # 80203bd8 <small_numbers+0xa58>
    80201a0a:	fffff097          	auipc	ra,0xfffff
    80201a0e:	456080e7          	jalr	1110(ra) # 80200e60 <panic>
    80201a12:	fe043703          	ld	a4,-32(s0)
    80201a16:	6785                	lui	a5,0x1
    80201a18:	97ba                	add	a5,a5,a4
    80201a1a:	fef43023          	sd	a5,-32(s0)
    80201a1e:	00006797          	auipc	a5,0x6
    80201a22:	82278793          	addi	a5,a5,-2014 # 80207240 <_bss_end>
    80201a26:	fe043703          	ld	a4,-32(s0)
    80201a2a:	faf76fe3          	bltu	a4,a5,802019e8 <kvmmake+0x88>
    80201a2e:	00006717          	auipc	a4,0x6
    80201a32:	81270713          	addi	a4,a4,-2030 # 80207240 <_bss_end>
    80201a36:	6785                	lui	a5,0x1
    80201a38:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80201a3a:	973e                	add	a4,a4,a5
    80201a3c:	77fd                	lui	a5,0xfffff
    80201a3e:	8ff9                	and	a5,a5,a4
    80201a40:	faf43823          	sd	a5,-80(s0)
    80201a44:	fb043783          	ld	a5,-80(s0)
    80201a48:	fcf43c23          	sd	a5,-40(s0)
    80201a4c:	a825                	j	80201a84 <kvmmake+0x124>
    80201a4e:	4699                	li	a3,6
    80201a50:	fd843603          	ld	a2,-40(s0)
    80201a54:	fd843583          	ld	a1,-40(s0)
    80201a58:	fb843503          	ld	a0,-72(s0)
    80201a5c:	00000097          	auipc	ra,0x0
    80201a60:	d70080e7          	jalr	-656(ra) # 802017cc <map_page>
    80201a64:	87aa                	mv	a5,a0
    80201a66:	cb89                	beqz	a5,80201a78 <kvmmake+0x118>
    80201a68:	00002517          	auipc	a0,0x2
    80201a6c:	19050513          	addi	a0,a0,400 # 80203bf8 <small_numbers+0xa78>
    80201a70:	fffff097          	auipc	ra,0xfffff
    80201a74:	3f0080e7          	jalr	1008(ra) # 80200e60 <panic>
    80201a78:	fd843703          	ld	a4,-40(s0)
    80201a7c:	6785                	lui	a5,0x1
    80201a7e:	97ba                	add	a5,a5,a4
    80201a80:	fcf43c23          	sd	a5,-40(s0)
    80201a84:	fd843703          	ld	a4,-40(s0)
    80201a88:	47c5                	li	a5,17
    80201a8a:	07ee                	slli	a5,a5,0x1b
    80201a8c:	fcf761e3          	bltu	a4,a5,80201a4e <kvmmake+0xee>
    80201a90:	4699                	li	a3,6
    80201a92:	10000637          	lui	a2,0x10000
    80201a96:	100005b7          	lui	a1,0x10000
    80201a9a:	fb843503          	ld	a0,-72(s0)
    80201a9e:	00000097          	auipc	ra,0x0
    80201aa2:	d2e080e7          	jalr	-722(ra) # 802017cc <map_page>
    80201aa6:	87aa                	mv	a5,a0
    80201aa8:	cb89                	beqz	a5,80201aba <kvmmake+0x15a>
    80201aaa:	00002517          	auipc	a0,0x2
    80201aae:	16e50513          	addi	a0,a0,366 # 80203c18 <small_numbers+0xa98>
    80201ab2:	fffff097          	auipc	ra,0xfffff
    80201ab6:	3ae080e7          	jalr	942(ra) # 80200e60 <panic>
    80201aba:	0c0007b7          	lui	a5,0xc000
    80201abe:	fcf43823          	sd	a5,-48(s0)
    80201ac2:	a825                	j	80201afa <kvmmake+0x19a>
    80201ac4:	4699                	li	a3,6
    80201ac6:	fd043603          	ld	a2,-48(s0)
    80201aca:	fd043583          	ld	a1,-48(s0)
    80201ace:	fb843503          	ld	a0,-72(s0)
    80201ad2:	00000097          	auipc	ra,0x0
    80201ad6:	cfa080e7          	jalr	-774(ra) # 802017cc <map_page>
    80201ada:	87aa                	mv	a5,a0
    80201adc:	cb89                	beqz	a5,80201aee <kvmmake+0x18e>
    80201ade:	00002517          	auipc	a0,0x2
    80201ae2:	15a50513          	addi	a0,a0,346 # 80203c38 <small_numbers+0xab8>
    80201ae6:	fffff097          	auipc	ra,0xfffff
    80201aea:	37a080e7          	jalr	890(ra) # 80200e60 <panic>
    80201aee:	fd043703          	ld	a4,-48(s0)
    80201af2:	6785                	lui	a5,0x1
    80201af4:	97ba                	add	a5,a5,a4
    80201af6:	fcf43823          	sd	a5,-48(s0)
    80201afa:	fd043703          	ld	a4,-48(s0)
    80201afe:	0c4007b7          	lui	a5,0xc400
    80201b02:	fcf761e3          	bltu	a4,a5,80201ac4 <kvmmake+0x164>
    80201b06:	020007b7          	lui	a5,0x2000
    80201b0a:	fcf43423          	sd	a5,-56(s0)
    80201b0e:	a825                	j	80201b46 <kvmmake+0x1e6>
    80201b10:	4699                	li	a3,6
    80201b12:	fc843603          	ld	a2,-56(s0)
    80201b16:	fc843583          	ld	a1,-56(s0)
    80201b1a:	fb843503          	ld	a0,-72(s0)
    80201b1e:	00000097          	auipc	ra,0x0
    80201b22:	cae080e7          	jalr	-850(ra) # 802017cc <map_page>
    80201b26:	87aa                	mv	a5,a0
    80201b28:	cb89                	beqz	a5,80201b3a <kvmmake+0x1da>
    80201b2a:	00002517          	auipc	a0,0x2
    80201b2e:	12e50513          	addi	a0,a0,302 # 80203c58 <small_numbers+0xad8>
    80201b32:	fffff097          	auipc	ra,0xfffff
    80201b36:	32e080e7          	jalr	814(ra) # 80200e60 <panic>
    80201b3a:	fc843703          	ld	a4,-56(s0)
    80201b3e:	6785                	lui	a5,0x1
    80201b40:	97ba                	add	a5,a5,a4
    80201b42:	fcf43423          	sd	a5,-56(s0)
    80201b46:	fc843703          	ld	a4,-56(s0)
    80201b4a:	020107b7          	lui	a5,0x2010
    80201b4e:	fcf761e3          	bltu	a4,a5,80201b10 <kvmmake+0x1b0>
    80201b52:	4699                	li	a3,6
    80201b54:	10001637          	lui	a2,0x10001
    80201b58:	100015b7          	lui	a1,0x10001
    80201b5c:	fb843503          	ld	a0,-72(s0)
    80201b60:	00000097          	auipc	ra,0x0
    80201b64:	c6c080e7          	jalr	-916(ra) # 802017cc <map_page>
    80201b68:	87aa                	mv	a5,a0
    80201b6a:	cb89                	beqz	a5,80201b7c <kvmmake+0x21c>
    80201b6c:	00002517          	auipc	a0,0x2
    80201b70:	10c50513          	addi	a0,a0,268 # 80203c78 <small_numbers+0xaf8>
    80201b74:	fffff097          	auipc	ra,0xfffff
    80201b78:	2ec080e7          	jalr	748(ra) # 80200e60 <panic>
    80201b7c:	fc043023          	sd	zero,-64(s0)
    80201b80:	a825                	j	80201bb8 <kvmmake+0x258>
    80201b82:	4699                	li	a3,6
    80201b84:	fc043603          	ld	a2,-64(s0)
    80201b88:	fc043583          	ld	a1,-64(s0)
    80201b8c:	fb843503          	ld	a0,-72(s0)
    80201b90:	00000097          	auipc	ra,0x0
    80201b94:	c3c080e7          	jalr	-964(ra) # 802017cc <map_page>
    80201b98:	87aa                	mv	a5,a0
    80201b9a:	cb89                	beqz	a5,80201bac <kvmmake+0x24c>
    80201b9c:	00002517          	auipc	a0,0x2
    80201ba0:	0fc50513          	addi	a0,a0,252 # 80203c98 <small_numbers+0xb18>
    80201ba4:	fffff097          	auipc	ra,0xfffff
    80201ba8:	2bc080e7          	jalr	700(ra) # 80200e60 <panic>
    80201bac:	fc043703          	ld	a4,-64(s0)
    80201bb0:	6785                	lui	a5,0x1
    80201bb2:	97ba                	add	a5,a5,a4
    80201bb4:	fcf43023          	sd	a5,-64(s0)
    80201bb8:	fc043703          	ld	a4,-64(s0)
    80201bbc:	001007b7          	lui	a5,0x100
    80201bc0:	fcf761e3          	bltu	a4,a5,80201b82 <kvmmake+0x222>
    80201bc4:	0fd027b7          	lui	a5,0xfd02
    80201bc8:	faf43423          	sd	a5,-88(s0)
    80201bcc:	4699                	li	a3,6
    80201bce:	fa843603          	ld	a2,-88(s0)
    80201bd2:	fa843583          	ld	a1,-88(s0)
    80201bd6:	fb843503          	ld	a0,-72(s0)
    80201bda:	00000097          	auipc	ra,0x0
    80201bde:	bf2080e7          	jalr	-1038(ra) # 802017cc <map_page>
    80201be2:	87aa                	mv	a5,a0
    80201be4:	cb89                	beqz	a5,80201bf6 <kvmmake+0x296>
    80201be6:	00002517          	auipc	a0,0x2
    80201bea:	0d250513          	addi	a0,a0,210 # 80203cb8 <small_numbers+0xb38>
    80201bee:	fffff097          	auipc	ra,0xfffff
    80201bf2:	272080e7          	jalr	626(ra) # 80200e60 <panic>
    80201bf6:	fb843783          	ld	a5,-72(s0)
    80201bfa:	853e                	mv	a0,a5
    80201bfc:	60e6                	ld	ra,88(sp)
    80201bfe:	6446                	ld	s0,80(sp)
    80201c00:	6125                	addi	sp,sp,96
    80201c02:	8082                	ret

0000000080201c04 <kvminit>:
    80201c04:	1141                	addi	sp,sp,-16
    80201c06:	e406                	sd	ra,8(sp)
    80201c08:	e022                	sd	s0,0(sp)
    80201c0a:	0800                	addi	s0,sp,16
    80201c0c:	00000097          	auipc	ra,0x0
    80201c10:	d54080e7          	jalr	-684(ra) # 80201960 <kvmmake>
    80201c14:	872a                	mv	a4,a0
    80201c16:	00005797          	auipc	a5,0x5
    80201c1a:	42278793          	addi	a5,a5,1058 # 80207038 <kernel_pagetable>
    80201c1e:	e398                	sd	a4,0(a5)
    80201c20:	0001                	nop
    80201c22:	60a2                	ld	ra,8(sp)
    80201c24:	6402                	ld	s0,0(sp)
    80201c26:	0141                	addi	sp,sp,16
    80201c28:	8082                	ret

0000000080201c2a <w_satp>:
    80201c2a:	1101                	addi	sp,sp,-32
    80201c2c:	ec22                	sd	s0,24(sp)
    80201c2e:	1000                	addi	s0,sp,32
    80201c30:	fea43423          	sd	a0,-24(s0)
    80201c34:	fe843783          	ld	a5,-24(s0)
    80201c38:	18079073          	csrw	satp,a5
    80201c3c:	0001                	nop
    80201c3e:	6462                	ld	s0,24(sp)
    80201c40:	6105                	addi	sp,sp,32
    80201c42:	8082                	ret

0000000080201c44 <sfence_vma>:
    80201c44:	1141                	addi	sp,sp,-16
    80201c46:	e422                	sd	s0,8(sp)
    80201c48:	0800                	addi	s0,sp,16
    80201c4a:	12000073          	sfence.vma
    80201c4e:	0001                	nop
    80201c50:	6422                	ld	s0,8(sp)
    80201c52:	0141                	addi	sp,sp,16
    80201c54:	8082                	ret

0000000080201c56 <kvminithart>:
    80201c56:	1141                	addi	sp,sp,-16
    80201c58:	e406                	sd	ra,8(sp)
    80201c5a:	e022                	sd	s0,0(sp)
    80201c5c:	0800                	addi	s0,sp,16
    80201c5e:	00000097          	auipc	ra,0x0
    80201c62:	fe6080e7          	jalr	-26(ra) # 80201c44 <sfence_vma>
    80201c66:	00005797          	auipc	a5,0x5
    80201c6a:	3d278793          	addi	a5,a5,978 # 80207038 <kernel_pagetable>
    80201c6e:	639c                	ld	a5,0(a5)
    80201c70:	00c7d713          	srli	a4,a5,0xc
    80201c74:	57fd                	li	a5,-1
    80201c76:	17fe                	slli	a5,a5,0x3f
    80201c78:	8fd9                	or	a5,a5,a4
    80201c7a:	853e                	mv	a0,a5
    80201c7c:	00000097          	auipc	ra,0x0
    80201c80:	fae080e7          	jalr	-82(ra) # 80201c2a <w_satp>
    80201c84:	00000097          	auipc	ra,0x0
    80201c88:	fc0080e7          	jalr	-64(ra) # 80201c44 <sfence_vma>
    80201c8c:	0001                	nop
    80201c8e:	60a2                	ld	ra,8(sp)
    80201c90:	6402                	ld	s0,0(sp)
    80201c92:	0141                	addi	sp,sp,16
    80201c94:	8082                	ret

0000000080201c96 <test_pagetable>:
    80201c96:	7179                	addi	sp,sp,-48
    80201c98:	f406                	sd	ra,40(sp)
    80201c9a:	f022                	sd	s0,32(sp)
    80201c9c:	1800                	addi	s0,sp,48
    80201c9e:	00002517          	auipc	a0,0x2
    80201ca2:	04250513          	addi	a0,a0,66 # 80203ce0 <small_numbers+0xb60>
    80201ca6:	fffff097          	auipc	ra,0xfffff
    80201caa:	8b2080e7          	jalr	-1870(ra) # 80200558 <printf>
    80201cae:	00000097          	auipc	ra,0x0
    80201cb2:	956080e7          	jalr	-1706(ra) # 80201604 <create_pagetable>
    80201cb6:	fea43423          	sd	a0,-24(s0)
    80201cba:	fe843783          	ld	a5,-24(s0)
    80201cbe:	00f037b3          	snez	a5,a5
    80201cc2:	0ff7f793          	zext.b	a5,a5
    80201cc6:	2781                	sext.w	a5,a5
    80201cc8:	853e                	mv	a0,a5
    80201cca:	00000097          	auipc	ra,0x0
    80201cce:	8b6080e7          	jalr	-1866(ra) # 80201580 <assert>
    80201cd2:	00002517          	auipc	a0,0x2
    80201cd6:	02e50513          	addi	a0,a0,46 # 80203d00 <small_numbers+0xb80>
    80201cda:	fffff097          	auipc	ra,0xfffff
    80201cde:	87e080e7          	jalr	-1922(ra) # 80200558 <printf>
    80201ce2:	010007b7          	lui	a5,0x1000
    80201ce6:	fef43023          	sd	a5,-32(s0)
    80201cea:	00000097          	auipc	ra,0x0
    80201cee:	222080e7          	jalr	546(ra) # 80201f0c <alloc_page>
    80201cf2:	87aa                	mv	a5,a0
    80201cf4:	fcf43c23          	sd	a5,-40(s0)
    80201cf8:	fd843783          	ld	a5,-40(s0)
    80201cfc:	00f037b3          	snez	a5,a5
    80201d00:	0ff7f793          	zext.b	a5,a5
    80201d04:	2781                	sext.w	a5,a5
    80201d06:	853e                	mv	a0,a5
    80201d08:	00000097          	auipc	ra,0x0
    80201d0c:	878080e7          	jalr	-1928(ra) # 80201580 <assert>
    80201d10:	4699                	li	a3,6
    80201d12:	fd843603          	ld	a2,-40(s0)
    80201d16:	fe043583          	ld	a1,-32(s0)
    80201d1a:	fe843503          	ld	a0,-24(s0)
    80201d1e:	00000097          	auipc	ra,0x0
    80201d22:	aae080e7          	jalr	-1362(ra) # 802017cc <map_page>
    80201d26:	87aa                	mv	a5,a0
    80201d28:	0017b793          	seqz	a5,a5
    80201d2c:	0ff7f793          	zext.b	a5,a5
    80201d30:	2781                	sext.w	a5,a5
    80201d32:	853e                	mv	a0,a5
    80201d34:	00000097          	auipc	ra,0x0
    80201d38:	84c080e7          	jalr	-1972(ra) # 80201580 <assert>
    80201d3c:	00002517          	auipc	a0,0x2
    80201d40:	fe450513          	addi	a0,a0,-28 # 80203d20 <small_numbers+0xba0>
    80201d44:	fffff097          	auipc	ra,0xfffff
    80201d48:	814080e7          	jalr	-2028(ra) # 80200558 <printf>
    80201d4c:	fe043583          	ld	a1,-32(s0)
    80201d50:	fe843503          	ld	a0,-24(s0)
    80201d54:	00000097          	auipc	ra,0x0
    80201d58:	8ec080e7          	jalr	-1812(ra) # 80201640 <walk_lookup>
    80201d5c:	fca43823          	sd	a0,-48(s0)
    80201d60:	fd043783          	ld	a5,-48(s0)
    80201d64:	cb81                	beqz	a5,80201d74 <test_pagetable+0xde>
    80201d66:	fd043783          	ld	a5,-48(s0)
    80201d6a:	639c                	ld	a5,0(a5)
    80201d6c:	8b85                	andi	a5,a5,1
    80201d6e:	c399                	beqz	a5,80201d74 <test_pagetable+0xde>
    80201d70:	4785                	li	a5,1
    80201d72:	a011                	j	80201d76 <test_pagetable+0xe0>
    80201d74:	4781                	li	a5,0
    80201d76:	853e                	mv	a0,a5
    80201d78:	00000097          	auipc	ra,0x0
    80201d7c:	808080e7          	jalr	-2040(ra) # 80201580 <assert>
    80201d80:	fd043783          	ld	a5,-48(s0)
    80201d84:	639c                	ld	a5,0(a5)
    80201d86:	83a9                	srli	a5,a5,0xa
    80201d88:	07b2                	slli	a5,a5,0xc
    80201d8a:	fd843703          	ld	a4,-40(s0)
    80201d8e:	40f707b3          	sub	a5,a4,a5
    80201d92:	0017b793          	seqz	a5,a5
    80201d96:	0ff7f793          	zext.b	a5,a5
    80201d9a:	2781                	sext.w	a5,a5
    80201d9c:	853e                	mv	a0,a5
    80201d9e:	fffff097          	auipc	ra,0xfffff
    80201da2:	7e2080e7          	jalr	2018(ra) # 80201580 <assert>
    80201da6:	00002517          	auipc	a0,0x2
    80201daa:	f9a50513          	addi	a0,a0,-102 # 80203d40 <small_numbers+0xbc0>
    80201dae:	ffffe097          	auipc	ra,0xffffe
    80201db2:	7aa080e7          	jalr	1962(ra) # 80200558 <printf>
    80201db6:	fd043783          	ld	a5,-48(s0)
    80201dba:	639c                	ld	a5,0(a5)
    80201dbc:	2781                	sext.w	a5,a5
    80201dbe:	8b89                	andi	a5,a5,2
    80201dc0:	2781                	sext.w	a5,a5
    80201dc2:	853e                	mv	a0,a5
    80201dc4:	fffff097          	auipc	ra,0xfffff
    80201dc8:	7bc080e7          	jalr	1980(ra) # 80201580 <assert>
    80201dcc:	fd043783          	ld	a5,-48(s0)
    80201dd0:	639c                	ld	a5,0(a5)
    80201dd2:	2781                	sext.w	a5,a5
    80201dd4:	8b91                	andi	a5,a5,4
    80201dd6:	2781                	sext.w	a5,a5
    80201dd8:	853e                	mv	a0,a5
    80201dda:	fffff097          	auipc	ra,0xfffff
    80201dde:	7a6080e7          	jalr	1958(ra) # 80201580 <assert>
    80201de2:	fd043783          	ld	a5,-48(s0)
    80201de6:	639c                	ld	a5,0(a5)
    80201de8:	8ba1                	andi	a5,a5,8
    80201dea:	0017b793          	seqz	a5,a5
    80201dee:	0ff7f793          	zext.b	a5,a5
    80201df2:	2781                	sext.w	a5,a5
    80201df4:	853e                	mv	a0,a5
    80201df6:	fffff097          	auipc	ra,0xfffff
    80201dfa:	78a080e7          	jalr	1930(ra) # 80201580 <assert>
    80201dfe:	00002517          	auipc	a0,0x2
    80201e02:	f6a50513          	addi	a0,a0,-150 # 80203d68 <small_numbers+0xbe8>
    80201e06:	ffffe097          	auipc	ra,0xffffe
    80201e0a:	752080e7          	jalr	1874(ra) # 80200558 <printf>
    80201e0e:	fd843783          	ld	a5,-40(s0)
    80201e12:	853e                	mv	a0,a5
    80201e14:	00000097          	auipc	ra,0x0
    80201e18:	164080e7          	jalr	356(ra) # 80201f78 <free_page>
    80201e1c:	fe843503          	ld	a0,-24(s0)
    80201e20:	00000097          	auipc	ra,0x0
    80201e24:	a92080e7          	jalr	-1390(ra) # 802018b2 <free_pagetable>
    80201e28:	00002517          	auipc	a0,0x2
    80201e2c:	f6050513          	addi	a0,a0,-160 # 80203d88 <small_numbers+0xc08>
    80201e30:	ffffe097          	auipc	ra,0xffffe
    80201e34:	728080e7          	jalr	1832(ra) # 80200558 <printf>
    80201e38:	0001                	nop
    80201e3a:	70a2                	ld	ra,40(sp)
    80201e3c:	7402                	ld	s0,32(sp)
    80201e3e:	6145                	addi	sp,sp,48
    80201e40:	8082                	ret

0000000080201e42 <assert>:
    80201e42:	1101                	addi	sp,sp,-32
    80201e44:	ec06                	sd	ra,24(sp)
    80201e46:	e822                	sd	s0,16(sp)
    80201e48:	1000                	addi	s0,sp,32
    80201e4a:	87aa                	mv	a5,a0
    80201e4c:	fef42623          	sw	a5,-20(s0)
    80201e50:	fec42783          	lw	a5,-20(s0)
    80201e54:	2781                	sext.w	a5,a5
    80201e56:	e795                	bnez	a5,80201e82 <assert+0x40>
    80201e58:	4615                	li	a2,5
    80201e5a:	00002597          	auipc	a1,0x2
    80201e5e:	f5658593          	addi	a1,a1,-170 # 80203db0 <small_numbers+0xc30>
    80201e62:	00002517          	auipc	a0,0x2
    80201e66:	f5e50513          	addi	a0,a0,-162 # 80203dc0 <small_numbers+0xc40>
    80201e6a:	ffffe097          	auipc	ra,0xffffe
    80201e6e:	6ee080e7          	jalr	1774(ra) # 80200558 <printf>
    80201e72:	00002517          	auipc	a0,0x2
    80201e76:	f7650513          	addi	a0,a0,-138 # 80203de8 <small_numbers+0xc68>
    80201e7a:	fffff097          	auipc	ra,0xfffff
    80201e7e:	fe6080e7          	jalr	-26(ra) # 80200e60 <panic>
    80201e82:	0001                	nop
    80201e84:	60e2                	ld	ra,24(sp)
    80201e86:	6442                	ld	s0,16(sp)
    80201e88:	6105                	addi	sp,sp,32
    80201e8a:	8082                	ret

0000000080201e8c <freerange>:
    80201e8c:	7179                	addi	sp,sp,-48
    80201e8e:	f406                	sd	ra,40(sp)
    80201e90:	f022                	sd	s0,32(sp)
    80201e92:	1800                	addi	s0,sp,48
    80201e94:	fca43c23          	sd	a0,-40(s0)
    80201e98:	fcb43823          	sd	a1,-48(s0)
    80201e9c:	fd843703          	ld	a4,-40(s0)
    80201ea0:	6785                	lui	a5,0x1
    80201ea2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80201ea4:	973e                	add	a4,a4,a5
    80201ea6:	77fd                	lui	a5,0xfffff
    80201ea8:	8ff9                	and	a5,a5,a4
    80201eaa:	fef43423          	sd	a5,-24(s0)
    80201eae:	a829                	j	80201ec8 <freerange+0x3c>
    80201eb0:	fe843503          	ld	a0,-24(s0)
    80201eb4:	00000097          	auipc	ra,0x0
    80201eb8:	0c4080e7          	jalr	196(ra) # 80201f78 <free_page>
    80201ebc:	fe843703          	ld	a4,-24(s0)
    80201ec0:	6785                	lui	a5,0x1
    80201ec2:	97ba                	add	a5,a5,a4
    80201ec4:	fef43423          	sd	a5,-24(s0)
    80201ec8:	fe843703          	ld	a4,-24(s0)
    80201ecc:	6785                	lui	a5,0x1
    80201ece:	97ba                	add	a5,a5,a4
    80201ed0:	fd043703          	ld	a4,-48(s0)
    80201ed4:	fcf77ee3          	bgeu	a4,a5,80201eb0 <freerange+0x24>
    80201ed8:	0001                	nop
    80201eda:	0001                	nop
    80201edc:	70a2                	ld	ra,40(sp)
    80201ede:	7402                	ld	s0,32(sp)
    80201ee0:	6145                	addi	sp,sp,48
    80201ee2:	8082                	ret

0000000080201ee4 <pmm_init>:
    80201ee4:	1141                	addi	sp,sp,-16
    80201ee6:	e406                	sd	ra,8(sp)
    80201ee8:	e022                	sd	s0,0(sp)
    80201eea:	0800                	addi	s0,sp,16
    80201eec:	47c5                	li	a5,17
    80201eee:	01b79593          	slli	a1,a5,0x1b
    80201ef2:	00005517          	auipc	a0,0x5
    80201ef6:	34e50513          	addi	a0,a0,846 # 80207240 <_bss_end>
    80201efa:	00000097          	auipc	ra,0x0
    80201efe:	f92080e7          	jalr	-110(ra) # 80201e8c <freerange>
    80201f02:	0001                	nop
    80201f04:	60a2                	ld	ra,8(sp)
    80201f06:	6402                	ld	s0,0(sp)
    80201f08:	0141                	addi	sp,sp,16
    80201f0a:	8082                	ret

0000000080201f0c <alloc_page>:
    80201f0c:	1101                	addi	sp,sp,-32
    80201f0e:	ec06                	sd	ra,24(sp)
    80201f10:	e822                	sd	s0,16(sp)
    80201f12:	1000                	addi	s0,sp,32
    80201f14:	00005797          	auipc	a5,0x5
    80201f18:	1ec78793          	addi	a5,a5,492 # 80207100 <freelist>
    80201f1c:	639c                	ld	a5,0(a5)
    80201f1e:	fef43423          	sd	a5,-24(s0)
    80201f22:	fe843783          	ld	a5,-24(s0)
    80201f26:	cb89                	beqz	a5,80201f38 <alloc_page+0x2c>
    80201f28:	fe843783          	ld	a5,-24(s0)
    80201f2c:	6398                	ld	a4,0(a5)
    80201f2e:	00005797          	auipc	a5,0x5
    80201f32:	1d278793          	addi	a5,a5,466 # 80207100 <freelist>
    80201f36:	e398                	sd	a4,0(a5)
    80201f38:	fe843783          	ld	a5,-24(s0)
    80201f3c:	cf99                	beqz	a5,80201f5a <alloc_page+0x4e>
    80201f3e:	fe843783          	ld	a5,-24(s0)
    80201f42:	00878713          	addi	a4,a5,8
    80201f46:	6785                	lui	a5,0x1
    80201f48:	ff878613          	addi	a2,a5,-8 # ff8 <_entry-0x801ff008>
    80201f4c:	4595                	li	a1,5
    80201f4e:	853a                	mv	a0,a4
    80201f50:	fffff097          	auipc	ra,0xfffff
    80201f54:	5e0080e7          	jalr	1504(ra) # 80201530 <memset>
    80201f58:	a809                	j	80201f6a <alloc_page+0x5e>
    80201f5a:	00002517          	auipc	a0,0x2
    80201f5e:	e9650513          	addi	a0,a0,-362 # 80203df0 <small_numbers+0xc70>
    80201f62:	fffff097          	auipc	ra,0xfffff
    80201f66:	efe080e7          	jalr	-258(ra) # 80200e60 <panic>
    80201f6a:	fe843783          	ld	a5,-24(s0)
    80201f6e:	853e                	mv	a0,a5
    80201f70:	60e2                	ld	ra,24(sp)
    80201f72:	6442                	ld	s0,16(sp)
    80201f74:	6105                	addi	sp,sp,32
    80201f76:	8082                	ret

0000000080201f78 <free_page>:
    80201f78:	7179                	addi	sp,sp,-48
    80201f7a:	f406                	sd	ra,40(sp)
    80201f7c:	f022                	sd	s0,32(sp)
    80201f7e:	1800                	addi	s0,sp,48
    80201f80:	fca43c23          	sd	a0,-40(s0)
    80201f84:	fd843783          	ld	a5,-40(s0)
    80201f88:	fef43423          	sd	a5,-24(s0)
    80201f8c:	fd843703          	ld	a4,-40(s0)
    80201f90:	6785                	lui	a5,0x1
    80201f92:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80201f94:	8ff9                	and	a5,a5,a4
    80201f96:	ef99                	bnez	a5,80201fb4 <free_page+0x3c>
    80201f98:	fd843703          	ld	a4,-40(s0)
    80201f9c:	00005797          	auipc	a5,0x5
    80201fa0:	2a478793          	addi	a5,a5,676 # 80207240 <_bss_end>
    80201fa4:	00f76863          	bltu	a4,a5,80201fb4 <free_page+0x3c>
    80201fa8:	fd843703          	ld	a4,-40(s0)
    80201fac:	47c5                	li	a5,17
    80201fae:	07ee                	slli	a5,a5,0x1b
    80201fb0:	00f76a63          	bltu	a4,a5,80201fc4 <free_page+0x4c>
    80201fb4:	00002517          	auipc	a0,0x2
    80201fb8:	e5c50513          	addi	a0,a0,-420 # 80203e10 <small_numbers+0xc90>
    80201fbc:	fffff097          	auipc	ra,0xfffff
    80201fc0:	ea4080e7          	jalr	-348(ra) # 80200e60 <panic>
    80201fc4:	00005797          	auipc	a5,0x5
    80201fc8:	13c78793          	addi	a5,a5,316 # 80207100 <freelist>
    80201fcc:	6398                	ld	a4,0(a5)
    80201fce:	fe843783          	ld	a5,-24(s0)
    80201fd2:	e398                	sd	a4,0(a5)
    80201fd4:	00005797          	auipc	a5,0x5
    80201fd8:	12c78793          	addi	a5,a5,300 # 80207100 <freelist>
    80201fdc:	fe843703          	ld	a4,-24(s0)
    80201fe0:	e398                	sd	a4,0(a5)
    80201fe2:	0001                	nop
    80201fe4:	70a2                	ld	ra,40(sp)
    80201fe6:	7402                	ld	s0,32(sp)
    80201fe8:	6145                	addi	sp,sp,48
    80201fea:	8082                	ret

0000000080201fec <test_physical_memory>:
    80201fec:	7179                	addi	sp,sp,-48
    80201fee:	f406                	sd	ra,40(sp)
    80201ff0:	f022                	sd	s0,32(sp)
    80201ff2:	1800                	addi	s0,sp,48
    80201ff4:	00002517          	auipc	a0,0x2
    80201ff8:	e3c50513          	addi	a0,a0,-452 # 80203e30 <small_numbers+0xcb0>
    80201ffc:	ffffe097          	auipc	ra,0xffffe
    80202000:	55c080e7          	jalr	1372(ra) # 80200558 <printf>
    80202004:	00000097          	auipc	ra,0x0
    80202008:	f08080e7          	jalr	-248(ra) # 80201f0c <alloc_page>
    8020200c:	fea43423          	sd	a0,-24(s0)
    80202010:	00000097          	auipc	ra,0x0
    80202014:	efc080e7          	jalr	-260(ra) # 80201f0c <alloc_page>
    80202018:	fea43023          	sd	a0,-32(s0)
    8020201c:	fe843783          	ld	a5,-24(s0)
    80202020:	00f037b3          	snez	a5,a5
    80202024:	0ff7f793          	zext.b	a5,a5
    80202028:	2781                	sext.w	a5,a5
    8020202a:	853e                	mv	a0,a5
    8020202c:	00000097          	auipc	ra,0x0
    80202030:	e16080e7          	jalr	-490(ra) # 80201e42 <assert>
    80202034:	fe043783          	ld	a5,-32(s0)
    80202038:	00f037b3          	snez	a5,a5
    8020203c:	0ff7f793          	zext.b	a5,a5
    80202040:	2781                	sext.w	a5,a5
    80202042:	853e                	mv	a0,a5
    80202044:	00000097          	auipc	ra,0x0
    80202048:	dfe080e7          	jalr	-514(ra) # 80201e42 <assert>
    8020204c:	fe843703          	ld	a4,-24(s0)
    80202050:	fe043783          	ld	a5,-32(s0)
    80202054:	40f707b3          	sub	a5,a4,a5
    80202058:	00f037b3          	snez	a5,a5
    8020205c:	0ff7f793          	zext.b	a5,a5
    80202060:	2781                	sext.w	a5,a5
    80202062:	853e                	mv	a0,a5
    80202064:	00000097          	auipc	ra,0x0
    80202068:	dde080e7          	jalr	-546(ra) # 80201e42 <assert>
    8020206c:	fe843703          	ld	a4,-24(s0)
    80202070:	6785                	lui	a5,0x1
    80202072:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80202074:	8ff9                	and	a5,a5,a4
    80202076:	0017b793          	seqz	a5,a5
    8020207a:	0ff7f793          	zext.b	a5,a5
    8020207e:	2781                	sext.w	a5,a5
    80202080:	853e                	mv	a0,a5
    80202082:	00000097          	auipc	ra,0x0
    80202086:	dc0080e7          	jalr	-576(ra) # 80201e42 <assert>
    8020208a:	fe043703          	ld	a4,-32(s0)
    8020208e:	6785                	lui	a5,0x1
    80202090:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80202092:	8ff9                	and	a5,a5,a4
    80202094:	0017b793          	seqz	a5,a5
    80202098:	0ff7f793          	zext.b	a5,a5
    8020209c:	2781                	sext.w	a5,a5
    8020209e:	853e                	mv	a0,a5
    802020a0:	00000097          	auipc	ra,0x0
    802020a4:	da2080e7          	jalr	-606(ra) # 80201e42 <assert>
    802020a8:	00002517          	auipc	a0,0x2
    802020ac:	da850513          	addi	a0,a0,-600 # 80203e50 <small_numbers+0xcd0>
    802020b0:	ffffe097          	auipc	ra,0xffffe
    802020b4:	4a8080e7          	jalr	1192(ra) # 80200558 <printf>
    802020b8:	00002517          	auipc	a0,0x2
    802020bc:	db850513          	addi	a0,a0,-584 # 80203e70 <small_numbers+0xcf0>
    802020c0:	ffffe097          	auipc	ra,0xffffe
    802020c4:	498080e7          	jalr	1176(ra) # 80200558 <printf>
    802020c8:	fe843783          	ld	a5,-24(s0)
    802020cc:	12345737          	lui	a4,0x12345
    802020d0:	67870713          	addi	a4,a4,1656 # 12345678 <_entry-0x6deba988>
    802020d4:	c398                	sw	a4,0(a5)
    802020d6:	fe843783          	ld	a5,-24(s0)
    802020da:	439c                	lw	a5,0(a5)
    802020dc:	873e                	mv	a4,a5
    802020de:	123457b7          	lui	a5,0x12345
    802020e2:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6deba988>
    802020e6:	40f707b3          	sub	a5,a4,a5
    802020ea:	0017b793          	seqz	a5,a5
    802020ee:	0ff7f793          	zext.b	a5,a5
    802020f2:	2781                	sext.w	a5,a5
    802020f4:	853e                	mv	a0,a5
    802020f6:	00000097          	auipc	ra,0x0
    802020fa:	d4c080e7          	jalr	-692(ra) # 80201e42 <assert>
    802020fe:	00002517          	auipc	a0,0x2
    80202102:	d9a50513          	addi	a0,a0,-614 # 80203e98 <small_numbers+0xd18>
    80202106:	ffffe097          	auipc	ra,0xffffe
    8020210a:	452080e7          	jalr	1106(ra) # 80200558 <printf>
    8020210e:	00002517          	auipc	a0,0x2
    80202112:	db250513          	addi	a0,a0,-590 # 80203ec0 <small_numbers+0xd40>
    80202116:	ffffe097          	auipc	ra,0xffffe
    8020211a:	442080e7          	jalr	1090(ra) # 80200558 <printf>
    8020211e:	fe843503          	ld	a0,-24(s0)
    80202122:	00000097          	auipc	ra,0x0
    80202126:	e56080e7          	jalr	-426(ra) # 80201f78 <free_page>
    8020212a:	00000097          	auipc	ra,0x0
    8020212e:	de2080e7          	jalr	-542(ra) # 80201f0c <alloc_page>
    80202132:	fca43c23          	sd	a0,-40(s0)
    80202136:	fd843783          	ld	a5,-40(s0)
    8020213a:	00f037b3          	snez	a5,a5
    8020213e:	0ff7f793          	zext.b	a5,a5
    80202142:	2781                	sext.w	a5,a5
    80202144:	853e                	mv	a0,a5
    80202146:	00000097          	auipc	ra,0x0
    8020214a:	cfc080e7          	jalr	-772(ra) # 80201e42 <assert>
    8020214e:	00002517          	auipc	a0,0x2
    80202152:	da250513          	addi	a0,a0,-606 # 80203ef0 <small_numbers+0xd70>
    80202156:	ffffe097          	auipc	ra,0xffffe
    8020215a:	402080e7          	jalr	1026(ra) # 80200558 <printf>
    8020215e:	fe043503          	ld	a0,-32(s0)
    80202162:	00000097          	auipc	ra,0x0
    80202166:	e16080e7          	jalr	-490(ra) # 80201f78 <free_page>
    8020216a:	fd843503          	ld	a0,-40(s0)
    8020216e:	00000097          	auipc	ra,0x0
    80202172:	e0a080e7          	jalr	-502(ra) # 80201f78 <free_page>
    80202176:	00002517          	auipc	a0,0x2
    8020217a:	daa50513          	addi	a0,a0,-598 # 80203f20 <small_numbers+0xda0>
    8020217e:	ffffe097          	auipc	ra,0xffffe
    80202182:	3da080e7          	jalr	986(ra) # 80200558 <printf>
    80202186:	0001                	nop
    80202188:	70a2                	ld	ra,40(sp)
    8020218a:	7402                	ld	s0,32(sp)
    8020218c:	6145                	addi	sp,sp,48
    8020218e:	8082                	ret

0000000080202190 <sbi_set_timer>:
    80202190:	1101                	addi	sp,sp,-32
    80202192:	ec22                	sd	s0,24(sp)
    80202194:	1000                	addi	s0,sp,32
    80202196:	fea43423          	sd	a0,-24(s0)
    8020219a:	fe843503          	ld	a0,-24(s0)
    8020219e:	4881                	li	a7,0
    802021a0:	00000073          	ecall
    802021a4:	0001                	nop
    802021a6:	6462                	ld	s0,24(sp)
    802021a8:	6105                	addi	sp,sp,32
    802021aa:	8082                	ret

00000000802021ac <sbi_get_time>:
    802021ac:	1141                	addi	sp,sp,-16
    802021ae:	e422                	sd	s0,8(sp)
    802021b0:	0800                	addi	s0,sp,16
    802021b2:	4501                	li	a0,0
    802021b4:	4885                	li	a7,1
    802021b6:	00000073          	ecall
    802021ba:	87aa                	mv	a5,a0
    802021bc:	853e                	mv	a0,a5
    802021be:	6422                	ld	s0,8(sp)
    802021c0:	0141                	addi	sp,sp,16
    802021c2:	8082                	ret

00000000802021c4 <timeintr>:
    802021c4:	1141                	addi	sp,sp,-16
    802021c6:	e422                	sd	s0,8(sp)
    802021c8:	0800                	addi	s0,sp,16
    802021ca:	00005797          	auipc	a5,0x5
    802021ce:	f3e78793          	addi	a5,a5,-194 # 80207108 <ticks>
    802021d2:	439c                	lw	a5,0(a5)
    802021d4:	2785                	addiw	a5,a5,1
    802021d6:	0007871b          	sext.w	a4,a5
    802021da:	00005797          	auipc	a5,0x5
    802021de:	f2e78793          	addi	a5,a5,-210 # 80207108 <ticks>
    802021e2:	c398                	sw	a4,0(a5)
    802021e4:	00005797          	auipc	a5,0x5
    802021e8:	e5c78793          	addi	a5,a5,-420 # 80207040 <interrupt_test_flag>
    802021ec:	639c                	ld	a5,0(a5)
    802021ee:	cb99                	beqz	a5,80202204 <timeintr+0x40>
    802021f0:	00005797          	auipc	a5,0x5
    802021f4:	e5078793          	addi	a5,a5,-432 # 80207040 <interrupt_test_flag>
    802021f8:	639c                	ld	a5,0(a5)
    802021fa:	4398                	lw	a4,0(a5)
    802021fc:	2701                	sext.w	a4,a4
    802021fe:	2705                	addiw	a4,a4,1
    80202200:	2701                	sext.w	a4,a4
    80202202:	c398                	sw	a4,0(a5)
    80202204:	0001                	nop
    80202206:	6422                	ld	s0,8(sp)
    80202208:	0141                	addi	sp,sp,16
    8020220a:	8082                	ret

000000008020220c <r_sie>:
    8020220c:	1101                	addi	sp,sp,-32
    8020220e:	ec22                	sd	s0,24(sp)
    80202210:	1000                	addi	s0,sp,32
    80202212:	104027f3          	csrr	a5,sie
    80202216:	fef43423          	sd	a5,-24(s0)
    8020221a:	fe843783          	ld	a5,-24(s0)
    8020221e:	853e                	mv	a0,a5
    80202220:	6462                	ld	s0,24(sp)
    80202222:	6105                	addi	sp,sp,32
    80202224:	8082                	ret

0000000080202226 <w_sie>:
    80202226:	1101                	addi	sp,sp,-32
    80202228:	ec22                	sd	s0,24(sp)
    8020222a:	1000                	addi	s0,sp,32
    8020222c:	fea43423          	sd	a0,-24(s0)
    80202230:	fe843783          	ld	a5,-24(s0)
    80202234:	10479073          	csrw	sie,a5
    80202238:	0001                	nop
    8020223a:	6462                	ld	s0,24(sp)
    8020223c:	6105                	addi	sp,sp,32
    8020223e:	8082                	ret

0000000080202240 <r_sstatus>:
    80202240:	1101                	addi	sp,sp,-32
    80202242:	ec22                	sd	s0,24(sp)
    80202244:	1000                	addi	s0,sp,32
    80202246:	100027f3          	csrr	a5,sstatus
    8020224a:	fef43423          	sd	a5,-24(s0)
    8020224e:	fe843783          	ld	a5,-24(s0)
    80202252:	853e                	mv	a0,a5
    80202254:	6462                	ld	s0,24(sp)
    80202256:	6105                	addi	sp,sp,32
    80202258:	8082                	ret

000000008020225a <w_sstatus>:
    8020225a:	1101                	addi	sp,sp,-32
    8020225c:	ec22                	sd	s0,24(sp)
    8020225e:	1000                	addi	s0,sp,32
    80202260:	fea43423          	sd	a0,-24(s0)
    80202264:	fe843783          	ld	a5,-24(s0)
    80202268:	10079073          	csrw	sstatus,a5
    8020226c:	0001                	nop
    8020226e:	6462                	ld	s0,24(sp)
    80202270:	6105                	addi	sp,sp,32
    80202272:	8082                	ret

0000000080202274 <w_sepc>:
    80202274:	1101                	addi	sp,sp,-32
    80202276:	ec22                	sd	s0,24(sp)
    80202278:	1000                	addi	s0,sp,32
    8020227a:	fea43423          	sd	a0,-24(s0)
    8020227e:	fe843783          	ld	a5,-24(s0)
    80202282:	14179073          	csrw	sepc,a5
    80202286:	0001                	nop
    80202288:	6462                	ld	s0,24(sp)
    8020228a:	6105                	addi	sp,sp,32
    8020228c:	8082                	ret

000000008020228e <intr_on>:
    8020228e:	1141                	addi	sp,sp,-16
    80202290:	e406                	sd	ra,8(sp)
    80202292:	e022                	sd	s0,0(sp)
    80202294:	0800                	addi	s0,sp,16
    80202296:	00000097          	auipc	ra,0x0
    8020229a:	faa080e7          	jalr	-86(ra) # 80202240 <r_sstatus>
    8020229e:	87aa                	mv	a5,a0
    802022a0:	0027e793          	ori	a5,a5,2
    802022a4:	853e                	mv	a0,a5
    802022a6:	00000097          	auipc	ra,0x0
    802022aa:	fb4080e7          	jalr	-76(ra) # 8020225a <w_sstatus>
    802022ae:	0001                	nop
    802022b0:	60a2                	ld	ra,8(sp)
    802022b2:	6402                	ld	s0,0(sp)
    802022b4:	0141                	addi	sp,sp,16
    802022b6:	8082                	ret

00000000802022b8 <intr_off>:
    802022b8:	1141                	addi	sp,sp,-16
    802022ba:	e406                	sd	ra,8(sp)
    802022bc:	e022                	sd	s0,0(sp)
    802022be:	0800                	addi	s0,sp,16
    802022c0:	00000097          	auipc	ra,0x0
    802022c4:	f80080e7          	jalr	-128(ra) # 80202240 <r_sstatus>
    802022c8:	87aa                	mv	a5,a0
    802022ca:	9bf5                	andi	a5,a5,-3
    802022cc:	853e                	mv	a0,a5
    802022ce:	00000097          	auipc	ra,0x0
    802022d2:	f8c080e7          	jalr	-116(ra) # 8020225a <w_sstatus>
    802022d6:	0001                	nop
    802022d8:	60a2                	ld	ra,8(sp)
    802022da:	6402                	ld	s0,0(sp)
    802022dc:	0141                	addi	sp,sp,16
    802022de:	8082                	ret

00000000802022e0 <w_stvec>:
    802022e0:	1101                	addi	sp,sp,-32
    802022e2:	ec22                	sd	s0,24(sp)
    802022e4:	1000                	addi	s0,sp,32
    802022e6:	fea43423          	sd	a0,-24(s0)
    802022ea:	fe843783          	ld	a5,-24(s0)
    802022ee:	10579073          	csrw	stvec,a5
    802022f2:	0001                	nop
    802022f4:	6462                	ld	s0,24(sp)
    802022f6:	6105                	addi	sp,sp,32
    802022f8:	8082                	ret

00000000802022fa <r_scause>:
    802022fa:	1101                	addi	sp,sp,-32
    802022fc:	ec22                	sd	s0,24(sp)
    802022fe:	1000                	addi	s0,sp,32
    80202300:	142027f3          	csrr	a5,scause
    80202304:	fef43423          	sd	a5,-24(s0)
    80202308:	fe843783          	ld	a5,-24(s0)
    8020230c:	853e                	mv	a0,a5
    8020230e:	6462                	ld	s0,24(sp)
    80202310:	6105                	addi	sp,sp,32
    80202312:	8082                	ret

0000000080202314 <r_sepc>:
    80202314:	1101                	addi	sp,sp,-32
    80202316:	ec22                	sd	s0,24(sp)
    80202318:	1000                	addi	s0,sp,32
    8020231a:	141027f3          	csrr	a5,sepc
    8020231e:	fef43423          	sd	a5,-24(s0)
    80202322:	fe843783          	ld	a5,-24(s0)
    80202326:	853e                	mv	a0,a5
    80202328:	6462                	ld	s0,24(sp)
    8020232a:	6105                	addi	sp,sp,32
    8020232c:	8082                	ret

000000008020232e <register_interrupt>:
    8020232e:	1101                	addi	sp,sp,-32
    80202330:	ec22                	sd	s0,24(sp)
    80202332:	1000                	addi	s0,sp,32
    80202334:	87aa                	mv	a5,a0
    80202336:	feb43023          	sd	a1,-32(s0)
    8020233a:	fef42623          	sw	a5,-20(s0)
    8020233e:	fec42783          	lw	a5,-20(s0)
    80202342:	2781                	sext.w	a5,a5
    80202344:	0207c463          	bltz	a5,8020236c <register_interrupt+0x3e>
    80202348:	fec42783          	lw	a5,-20(s0)
    8020234c:	0007871b          	sext.w	a4,a5
    80202350:	47fd                	li	a5,31
    80202352:	00e7cd63          	blt	a5,a4,8020236c <register_interrupt+0x3e>
    80202356:	00005717          	auipc	a4,0x5
    8020235a:	dba70713          	addi	a4,a4,-582 # 80207110 <interrupt_vector>
    8020235e:	fec42783          	lw	a5,-20(s0)
    80202362:	078e                	slli	a5,a5,0x3
    80202364:	97ba                	add	a5,a5,a4
    80202366:	fe043703          	ld	a4,-32(s0)
    8020236a:	e398                	sd	a4,0(a5)
    8020236c:	0001                	nop
    8020236e:	6462                	ld	s0,24(sp)
    80202370:	6105                	addi	sp,sp,32
    80202372:	8082                	ret

0000000080202374 <unregister_interrupt>:
    80202374:	1101                	addi	sp,sp,-32
    80202376:	ec22                	sd	s0,24(sp)
    80202378:	1000                	addi	s0,sp,32
    8020237a:	87aa                	mv	a5,a0
    8020237c:	fef42623          	sw	a5,-20(s0)
    80202380:	fec42783          	lw	a5,-20(s0)
    80202384:	2781                	sext.w	a5,a5
    80202386:	0207c363          	bltz	a5,802023ac <unregister_interrupt+0x38>
    8020238a:	fec42783          	lw	a5,-20(s0)
    8020238e:	0007871b          	sext.w	a4,a5
    80202392:	47fd                	li	a5,31
    80202394:	00e7cc63          	blt	a5,a4,802023ac <unregister_interrupt+0x38>
    80202398:	00005717          	auipc	a4,0x5
    8020239c:	d7870713          	addi	a4,a4,-648 # 80207110 <interrupt_vector>
    802023a0:	fec42783          	lw	a5,-20(s0)
    802023a4:	078e                	slli	a5,a5,0x3
    802023a6:	97ba                	add	a5,a5,a4
    802023a8:	0007b023          	sd	zero,0(a5)
    802023ac:	0001                	nop
    802023ae:	6462                	ld	s0,24(sp)
    802023b0:	6105                	addi	sp,sp,32
    802023b2:	8082                	ret

00000000802023b4 <enable_interrupts>:
    802023b4:	1101                	addi	sp,sp,-32
    802023b6:	ec06                	sd	ra,24(sp)
    802023b8:	e822                	sd	s0,16(sp)
    802023ba:	1000                	addi	s0,sp,32
    802023bc:	87aa                	mv	a5,a0
    802023be:	fef42623          	sw	a5,-20(s0)
    802023c2:	fec42783          	lw	a5,-20(s0)
    802023c6:	853e                	mv	a0,a5
    802023c8:	00000097          	auipc	ra,0x0
    802023cc:	676080e7          	jalr	1654(ra) # 80202a3e <plic_enable>
    802023d0:	0001                	nop
    802023d2:	60e2                	ld	ra,24(sp)
    802023d4:	6442                	ld	s0,16(sp)
    802023d6:	6105                	addi	sp,sp,32
    802023d8:	8082                	ret

00000000802023da <disable_interrupts>:
    802023da:	1101                	addi	sp,sp,-32
    802023dc:	ec06                	sd	ra,24(sp)
    802023de:	e822                	sd	s0,16(sp)
    802023e0:	1000                	addi	s0,sp,32
    802023e2:	87aa                	mv	a5,a0
    802023e4:	fef42623          	sw	a5,-20(s0)
    802023e8:	fec42783          	lw	a5,-20(s0)
    802023ec:	853e                	mv	a0,a5
    802023ee:	00000097          	auipc	ra,0x0
    802023f2:	6c8080e7          	jalr	1736(ra) # 80202ab6 <plic_disable>
    802023f6:	0001                	nop
    802023f8:	60e2                	ld	ra,24(sp)
    802023fa:	6442                	ld	s0,16(sp)
    802023fc:	6105                	addi	sp,sp,32
    802023fe:	8082                	ret

0000000080202400 <interrupt_dispatch>:
    80202400:	1101                	addi	sp,sp,-32
    80202402:	ec06                	sd	ra,24(sp)
    80202404:	e822                	sd	s0,16(sp)
    80202406:	1000                	addi	s0,sp,32
    80202408:	87aa                	mv	a5,a0
    8020240a:	fef42623          	sw	a5,-20(s0)
    8020240e:	fec42783          	lw	a5,-20(s0)
    80202412:	2781                	sext.w	a5,a5
    80202414:	0207cd63          	bltz	a5,8020244e <interrupt_dispatch+0x4e>
    80202418:	fec42783          	lw	a5,-20(s0)
    8020241c:	0007871b          	sext.w	a4,a5
    80202420:	47fd                	li	a5,31
    80202422:	02e7c663          	blt	a5,a4,8020244e <interrupt_dispatch+0x4e>
    80202426:	00005717          	auipc	a4,0x5
    8020242a:	cea70713          	addi	a4,a4,-790 # 80207110 <interrupt_vector>
    8020242e:	fec42783          	lw	a5,-20(s0)
    80202432:	078e                	slli	a5,a5,0x3
    80202434:	97ba                	add	a5,a5,a4
    80202436:	639c                	ld	a5,0(a5)
    80202438:	cb99                	beqz	a5,8020244e <interrupt_dispatch+0x4e>
    8020243a:	00005717          	auipc	a4,0x5
    8020243e:	cd670713          	addi	a4,a4,-810 # 80207110 <interrupt_vector>
    80202442:	fec42783          	lw	a5,-20(s0)
    80202446:	078e                	slli	a5,a5,0x3
    80202448:	97ba                	add	a5,a5,a4
    8020244a:	639c                	ld	a5,0(a5)
    8020244c:	9782                	jalr	a5
    8020244e:	0001                	nop
    80202450:	60e2                	ld	ra,24(sp)
    80202452:	6442                	ld	s0,16(sp)
    80202454:	6105                	addi	sp,sp,32
    80202456:	8082                	ret

0000000080202458 <trap_init>:
    80202458:	1101                	addi	sp,sp,-32
    8020245a:	ec06                	sd	ra,24(sp)
    8020245c:	e822                	sd	s0,16(sp)
    8020245e:	1000                	addi	s0,sp,32
    80202460:	00000097          	auipc	ra,0x0
    80202464:	e58080e7          	jalr	-424(ra) # 802022b8 <intr_off>
    80202468:	00002517          	auipc	a0,0x2
    8020246c:	ae850513          	addi	a0,a0,-1304 # 80203f50 <small_numbers+0xdd0>
    80202470:	ffffe097          	auipc	ra,0xffffe
    80202474:	0e8080e7          	jalr	232(ra) # 80200558 <printf>
    80202478:	fe042623          	sw	zero,-20(s0)
    8020247c:	a005                	j	8020249c <trap_init+0x44>
    8020247e:	00005717          	auipc	a4,0x5
    80202482:	c9270713          	addi	a4,a4,-878 # 80207110 <interrupt_vector>
    80202486:	fec42783          	lw	a5,-20(s0)
    8020248a:	078e                	slli	a5,a5,0x3
    8020248c:	97ba                	add	a5,a5,a4
    8020248e:	0007b023          	sd	zero,0(a5)
    80202492:	fec42783          	lw	a5,-20(s0)
    80202496:	2785                	addiw	a5,a5,1
    80202498:	fef42623          	sw	a5,-20(s0)
    8020249c:	fec42783          	lw	a5,-20(s0)
    802024a0:	0007871b          	sext.w	a4,a5
    802024a4:	47fd                	li	a5,31
    802024a6:	fce7dce3          	bge	a5,a4,8020247e <trap_init+0x26>
    802024aa:	00000797          	auipc	a5,0x0
    802024ae:	72678793          	addi	a5,a5,1830 # 80202bd0 <kernelvec>
    802024b2:	853e                	mv	a0,a5
    802024b4:	00000097          	auipc	ra,0x0
    802024b8:	e2c080e7          	jalr	-468(ra) # 802022e0 <w_stvec>
    802024bc:	00000597          	auipc	a1,0x0
    802024c0:	d0858593          	addi	a1,a1,-760 # 802021c4 <timeintr>
    802024c4:	4515                	li	a0,5
    802024c6:	00000097          	auipc	ra,0x0
    802024ca:	e68080e7          	jalr	-408(ra) # 8020232e <register_interrupt>
    802024ce:	00000097          	auipc	ra,0x0
    802024d2:	d3e080e7          	jalr	-706(ra) # 8020220c <r_sie>
    802024d6:	fea43023          	sd	a0,-32(s0)
    802024da:	fe043783          	ld	a5,-32(s0)
    802024de:	0207e793          	ori	a5,a5,32
    802024e2:	853e                	mv	a0,a5
    802024e4:	00000097          	auipc	ra,0x0
    802024e8:	d42080e7          	jalr	-702(ra) # 80202226 <w_sie>
    802024ec:	00000097          	auipc	ra,0x0
    802024f0:	cc0080e7          	jalr	-832(ra) # 802021ac <sbi_get_time>
    802024f4:	872a                	mv	a4,a0
    802024f6:	009897b7          	lui	a5,0x989
    802024fa:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f876980>
    802024fe:	97ba                	add	a5,a5,a4
    80202500:	853e                	mv	a0,a5
    80202502:	00000097          	auipc	ra,0x0
    80202506:	c8e080e7          	jalr	-882(ra) # 80202190 <sbi_set_timer>
    8020250a:	00002517          	auipc	a0,0x2
    8020250e:	a5650513          	addi	a0,a0,-1450 # 80203f60 <small_numbers+0xde0>
    80202512:	ffffe097          	auipc	ra,0xffffe
    80202516:	046080e7          	jalr	70(ra) # 80200558 <printf>
    8020251a:	0001                	nop
    8020251c:	60e2                	ld	ra,24(sp)
    8020251e:	6442                	ld	s0,16(sp)
    80202520:	6105                	addi	sp,sp,32
    80202522:	8082                	ret

0000000080202524 <kerneltrap>:
    80202524:	7139                	addi	sp,sp,-64
    80202526:	fc06                	sd	ra,56(sp)
    80202528:	f822                	sd	s0,48(sp)
    8020252a:	0080                	addi	s0,sp,64
    8020252c:	00000097          	auipc	ra,0x0
    80202530:	d14080e7          	jalr	-748(ra) # 80202240 <r_sstatus>
    80202534:	fea43023          	sd	a0,-32(s0)
    80202538:	00000097          	auipc	ra,0x0
    8020253c:	dc2080e7          	jalr	-574(ra) # 802022fa <r_scause>
    80202540:	fca43c23          	sd	a0,-40(s0)
    80202544:	00000097          	auipc	ra,0x0
    80202548:	dd0080e7          	jalr	-560(ra) # 80202314 <r_sepc>
    8020254c:	fca43823          	sd	a0,-48(s0)
    80202550:	878a                	mv	a5,sp
    80202552:	fcf43423          	sd	a5,-56(s0)
    80202556:	8786                	mv	a5,ra
    80202558:	fcf43023          	sd	a5,-64(s0)
    8020255c:	fc043603          	ld	a2,-64(s0)
    80202560:	fc843583          	ld	a1,-56(s0)
    80202564:	00002517          	auipc	a0,0x2
    80202568:	a1450513          	addi	a0,a0,-1516 # 80203f78 <small_numbers+0xdf8>
    8020256c:	ffffe097          	auipc	ra,0xffffe
    80202570:	fec080e7          	jalr	-20(ra) # 80200558 <printf>
    80202574:	fd843783          	ld	a5,-40(s0)
    80202578:	1407d063          	bgez	a5,802026b8 <kerneltrap+0x194>
    8020257c:	fd843783          	ld	a5,-40(s0)
    80202580:	0ff7f713          	zext.b	a4,a5
    80202584:	4795                	li	a5,5
    80202586:	12f71963          	bne	a4,a5,802026b8 <kerneltrap+0x194>
    8020258a:	fd043603          	ld	a2,-48(s0)
    8020258e:	fd043583          	ld	a1,-48(s0)
    80202592:	00002517          	auipc	a0,0x2
    80202596:	a0650513          	addi	a0,a0,-1530 # 80203f98 <small_numbers+0xe18>
    8020259a:	ffffe097          	auipc	ra,0xffffe
    8020259e:	fbe080e7          	jalr	-66(ra) # 80200558 <printf>
    802025a2:	fd043703          	ld	a4,-48(s0)
    802025a6:	40100793          	li	a5,1025
    802025aa:	07d6                	slli	a5,a5,0x15
    802025ac:	0ff78793          	addi	a5,a5,255
    802025b0:	00e7fb63          	bgeu	a5,a4,802025c6 <kerneltrap+0xa2>
    802025b4:	fd043703          	ld	a4,-48(s0)
    802025b8:	40100793          	li	a5,1025
    802025bc:	07d6                	slli	a5,a5,0x15
    802025be:	30078793          	addi	a5,a5,768
    802025c2:	0ce7f763          	bgeu	a5,a4,80202690 <kerneltrap+0x16c>
    802025c6:	fd043583          	ld	a1,-48(s0)
    802025ca:	00002517          	auipc	a0,0x2
    802025ce:	9fe50513          	addi	a0,a0,-1538 # 80203fc8 <small_numbers+0xe48>
    802025d2:	ffffe097          	auipc	ra,0xffffe
    802025d6:	f86080e7          	jalr	-122(ra) # 80200558 <printf>
    802025da:	fd043583          	ld	a1,-48(s0)
    802025de:	00002517          	auipc	a0,0x2
    802025e2:	a1a50513          	addi	a0,a0,-1510 # 80203ff8 <small_numbers+0xe78>
    802025e6:	ffffe097          	auipc	ra,0xffffe
    802025ea:	f72080e7          	jalr	-142(ra) # 80200558 <printf>
    802025ee:	00005797          	auipc	a5,0x5
    802025f2:	c2278793          	addi	a5,a5,-990 # 80207210 <sepc_idx.1>
    802025f6:	439c                	lw	a5,0(a5)
    802025f8:	00005717          	auipc	a4,0x5
    802025fc:	c2070713          	addi	a4,a4,-992 # 80207218 <last_sepcs.0>
    80202600:	078e                	slli	a5,a5,0x3
    80202602:	97ba                	add	a5,a5,a4
    80202604:	fd043703          	ld	a4,-48(s0)
    80202608:	e398                	sd	a4,0(a5)
    8020260a:	00005797          	auipc	a5,0x5
    8020260e:	c0678793          	addi	a5,a5,-1018 # 80207210 <sepc_idx.1>
    80202612:	439c                	lw	a5,0(a5)
    80202614:	2785                	addiw	a5,a5,1
    80202616:	2781                	sext.w	a5,a5
    80202618:	873e                	mv	a4,a5
    8020261a:	4795                	li	a5,5
    8020261c:	02f767bb          	remw	a5,a4,a5
    80202620:	0007871b          	sext.w	a4,a5
    80202624:	00005797          	auipc	a5,0x5
    80202628:	bec78793          	addi	a5,a5,-1044 # 80207210 <sepc_idx.1>
    8020262c:	c398                	sw	a4,0(a5)
    8020262e:	00002517          	auipc	a0,0x2
    80202632:	9f250513          	addi	a0,a0,-1550 # 80204020 <small_numbers+0xea0>
    80202636:	ffffe097          	auipc	ra,0xffffe
    8020263a:	f22080e7          	jalr	-222(ra) # 80200558 <printf>
    8020263e:	fe042623          	sw	zero,-20(s0)
    80202642:	a805                	j	80202672 <kerneltrap+0x14e>
    80202644:	00005717          	auipc	a4,0x5
    80202648:	bd470713          	addi	a4,a4,-1068 # 80207218 <last_sepcs.0>
    8020264c:	fec42783          	lw	a5,-20(s0)
    80202650:	078e                	slli	a5,a5,0x3
    80202652:	97ba                	add	a5,a5,a4
    80202654:	639c                	ld	a5,0(a5)
    80202656:	85be                	mv	a1,a5
    80202658:	00002517          	auipc	a0,0x2
    8020265c:	9e850513          	addi	a0,a0,-1560 # 80204040 <small_numbers+0xec0>
    80202660:	ffffe097          	auipc	ra,0xffffe
    80202664:	ef8080e7          	jalr	-264(ra) # 80200558 <printf>
    80202668:	fec42783          	lw	a5,-20(s0)
    8020266c:	2785                	addiw	a5,a5,1
    8020266e:	fef42623          	sw	a5,-20(s0)
    80202672:	fec42783          	lw	a5,-20(s0)
    80202676:	0007871b          	sext.w	a4,a5
    8020267a:	4791                	li	a5,4
    8020267c:	fce7d4e3          	bge	a5,a4,80202644 <kerneltrap+0x120>
    80202680:	00002517          	auipc	a0,0x2
    80202684:	9c850513          	addi	a0,a0,-1592 # 80204048 <small_numbers+0xec8>
    80202688:	ffffe097          	auipc	ra,0xffffe
    8020268c:	ed0080e7          	jalr	-304(ra) # 80200558 <printf>
    80202690:	00000097          	auipc	ra,0x0
    80202694:	b34080e7          	jalr	-1228(ra) # 802021c4 <timeintr>
    80202698:	00000097          	auipc	ra,0x0
    8020269c:	b14080e7          	jalr	-1260(ra) # 802021ac <sbi_get_time>
    802026a0:	872a                	mv	a4,a0
    802026a2:	009897b7          	lui	a5,0x989
    802026a6:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f876980>
    802026aa:	97ba                	add	a5,a5,a4
    802026ac:	853e                	mv	a0,a5
    802026ae:	00000097          	auipc	ra,0x0
    802026b2:	ae2080e7          	jalr	-1310(ra) # 80202190 <sbi_set_timer>
    802026b6:	a839                	j	802026d4 <kerneltrap+0x1b0>
    802026b8:	fd043603          	ld	a2,-48(s0)
    802026bc:	fd843583          	ld	a1,-40(s0)
    802026c0:	00002517          	auipc	a0,0x2
    802026c4:	99050513          	addi	a0,a0,-1648 # 80204050 <small_numbers+0xed0>
    802026c8:	ffffe097          	auipc	ra,0xffffe
    802026cc:	e90080e7          	jalr	-368(ra) # 80200558 <printf>
    802026d0:	0001                	nop
    802026d2:	bffd                	j	802026d0 <kerneltrap+0x1ac>
    802026d4:	fe043603          	ld	a2,-32(s0)
    802026d8:	fd043583          	ld	a1,-48(s0)
    802026dc:	00002517          	auipc	a0,0x2
    802026e0:	9a450513          	addi	a0,a0,-1628 # 80204080 <small_numbers+0xf00>
    802026e4:	ffffe097          	auipc	ra,0xffffe
    802026e8:	e74080e7          	jalr	-396(ra) # 80200558 <printf>
    802026ec:	fd043503          	ld	a0,-48(s0)
    802026f0:	00000097          	auipc	ra,0x0
    802026f4:	b84080e7          	jalr	-1148(ra) # 80202274 <w_sepc>
    802026f8:	fe043503          	ld	a0,-32(s0)
    802026fc:	00000097          	auipc	ra,0x0
    80202700:	b5e080e7          	jalr	-1186(ra) # 8020225a <w_sstatus>
    80202704:	0001                	nop
    80202706:	70e2                	ld	ra,56(sp)
    80202708:	7442                	ld	s0,48(sp)
    8020270a:	6121                	addi	sp,sp,64
    8020270c:	8082                	ret

000000008020270e <register_interrupt_test>:
    8020270e:	1101                	addi	sp,sp,-32
    80202710:	ec22                	sd	s0,24(sp)
    80202712:	1000                	addi	s0,sp,32
    80202714:	fea43423          	sd	a0,-24(s0)
    80202718:	00005797          	auipc	a5,0x5
    8020271c:	92878793          	addi	a5,a5,-1752 # 80207040 <interrupt_test_flag>
    80202720:	fe843703          	ld	a4,-24(s0)
    80202724:	e398                	sd	a4,0(a5)
    80202726:	0001                	nop
    80202728:	6462                	ld	s0,24(sp)
    8020272a:	6105                	addi	sp,sp,32
    8020272c:	8082                	ret

000000008020272e <unregister_interrupt_test>:
    8020272e:	1141                	addi	sp,sp,-16
    80202730:	e422                	sd	s0,8(sp)
    80202732:	0800                	addi	s0,sp,16
    80202734:	00005797          	auipc	a5,0x5
    80202738:	90c78793          	addi	a5,a5,-1780 # 80207040 <interrupt_test_flag>
    8020273c:	0007b023          	sd	zero,0(a5)
    80202740:	0001                	nop
    80202742:	6422                	ld	s0,8(sp)
    80202744:	0141                	addi	sp,sp,16
    80202746:	8082                	ret

0000000080202748 <test_timer_interrupt>:
    80202748:	7179                	addi	sp,sp,-48
    8020274a:	f406                	sd	ra,40(sp)
    8020274c:	f022                	sd	s0,32(sp)
    8020274e:	1800                	addi	s0,sp,48
    80202750:	00002517          	auipc	a0,0x2
    80202754:	95850513          	addi	a0,a0,-1704 # 802040a8 <small_numbers+0xf28>
    80202758:	ffffe097          	auipc	ra,0xffffe
    8020275c:	e00080e7          	jalr	-512(ra) # 80200558 <printf>
    80202760:	fc042a23          	sw	zero,-44(s0)
    80202764:	fd440793          	addi	a5,s0,-44
    80202768:	853e                	mv	a0,a5
    8020276a:	00000097          	auipc	ra,0x0
    8020276e:	fa4080e7          	jalr	-92(ra) # 8020270e <register_interrupt_test>
    80202772:	00000097          	auipc	ra,0x0
    80202776:	a3a080e7          	jalr	-1478(ra) # 802021ac <sbi_get_time>
    8020277a:	fea43023          	sd	a0,-32(s0)
    8020277e:	00000097          	auipc	ra,0x0
    80202782:	b10080e7          	jalr	-1264(ra) # 8020228e <intr_on>
    80202786:	00000597          	auipc	a1,0x0
    8020278a:	02c58593          	addi	a1,a1,44 # 802027b2 <test_timer_interrupt+0x6a>
    8020278e:	00002517          	auipc	a0,0x2
    80202792:	93a50513          	addi	a0,a0,-1734 # 802040c8 <small_numbers+0xf48>
    80202796:	ffffe097          	auipc	ra,0xffffe
    8020279a:	dc2080e7          	jalr	-574(ra) # 80200558 <printf>
    8020279e:	fe042623          	sw	zero,-20(s0)
    802027a2:	00002517          	auipc	a0,0x2
    802027a6:	94650513          	addi	a0,a0,-1722 # 802040e8 <small_numbers+0xf68>
    802027aa:	ffffe097          	auipc	ra,0xffffe
    802027ae:	dae080e7          	jalr	-594(ra) # 80200558 <printf>
    802027b2:	a869                	j	8020284c <test_timer_interrupt+0x104>
    802027b4:	00000597          	auipc	a1,0x0
    802027b8:	01858593          	addi	a1,a1,24 # 802027cc <test_timer_interrupt+0x84>
    802027bc:	00002517          	auipc	a0,0x2
    802027c0:	94c50513          	addi	a0,a0,-1716 # 80204108 <small_numbers+0xf88>
    802027c4:	ffffe097          	auipc	ra,0xffffe
    802027c8:	d94080e7          	jalr	-620(ra) # 80200558 <printf>
    802027cc:	fd442703          	lw	a4,-44(s0)
    802027d0:	fec42783          	lw	a5,-20(s0)
    802027d4:	2781                	sext.w	a5,a5
    802027d6:	02e78163          	beq	a5,a4,802027f8 <test_timer_interrupt+0xb0>
    802027da:	fd442783          	lw	a5,-44(s0)
    802027de:	85be                	mv	a1,a5
    802027e0:	00002517          	auipc	a0,0x2
    802027e4:	94850513          	addi	a0,a0,-1720 # 80204128 <small_numbers+0xfa8>
    802027e8:	ffffe097          	auipc	ra,0xffffe
    802027ec:	d70080e7          	jalr	-656(ra) # 80200558 <printf>
    802027f0:	fd442783          	lw	a5,-44(s0)
    802027f4:	fef42623          	sw	a5,-20(s0)
    802027f8:	fec42783          	lw	a5,-20(s0)
    802027fc:	85be                	mv	a1,a5
    802027fe:	00002517          	auipc	a0,0x2
    80202802:	94250513          	addi	a0,a0,-1726 # 80204140 <small_numbers+0xfc0>
    80202806:	ffffe097          	auipc	ra,0xffffe
    8020280a:	d52080e7          	jalr	-686(ra) # 80200558 <printf>
    8020280e:	fd442783          	lw	a5,-44(s0)
    80202812:	85be                	mv	a1,a5
    80202814:	00002517          	auipc	a0,0x2
    80202818:	93c50513          	addi	a0,a0,-1732 # 80204150 <small_numbers+0xfd0>
    8020281c:	ffffe097          	auipc	ra,0xffffe
    80202820:	d3c080e7          	jalr	-708(ra) # 80200558 <printf>
    80202824:	fc042823          	sw	zero,-48(s0)
    80202828:	a801                	j	80202838 <test_timer_interrupt+0xf0>
    8020282a:	fd042783          	lw	a5,-48(s0)
    8020282e:	2781                	sext.w	a5,a5
    80202830:	2785                	addiw	a5,a5,1
    80202832:	2781                	sext.w	a5,a5
    80202834:	fcf42823          	sw	a5,-48(s0)
    80202838:	fd042783          	lw	a5,-48(s0)
    8020283c:	2781                	sext.w	a5,a5
    8020283e:	873e                	mv	a4,a5
    80202840:	0007a7b7          	lui	a5,0x7a
    80202844:	11f78793          	addi	a5,a5,287 # 7a11f <_entry-0x80185ee1>
    80202848:	fee7d1e3          	bge	a5,a4,8020282a <test_timer_interrupt+0xe2>
    8020284c:	fd442783          	lw	a5,-44(s0)
    80202850:	873e                	mv	a4,a5
    80202852:	4791                	li	a5,4
    80202854:	f6e7d0e3          	bge	a5,a4,802027b4 <test_timer_interrupt+0x6c>
    80202858:	00002517          	auipc	a0,0x2
    8020285c:	91050513          	addi	a0,a0,-1776 # 80204168 <small_numbers+0xfe8>
    80202860:	ffffe097          	auipc	ra,0xffffe
    80202864:	cf8080e7          	jalr	-776(ra) # 80200558 <printf>
    80202868:	00000097          	auipc	ra,0x0
    8020286c:	944080e7          	jalr	-1724(ra) # 802021ac <sbi_get_time>
    80202870:	fca43c23          	sd	a0,-40(s0)
    80202874:	00000097          	auipc	ra,0x0
    80202878:	eba080e7          	jalr	-326(ra) # 8020272e <unregister_interrupt_test>
    8020287c:	fd442683          	lw	a3,-44(s0)
    80202880:	fd843703          	ld	a4,-40(s0)
    80202884:	fe043783          	ld	a5,-32(s0)
    80202888:	40f707b3          	sub	a5,a4,a5
    8020288c:	863e                	mv	a2,a5
    8020288e:	85b6                	mv	a1,a3
    80202890:	00002517          	auipc	a0,0x2
    80202894:	8f050513          	addi	a0,a0,-1808 # 80204180 <small_numbers+0x1000>
    80202898:	ffffe097          	auipc	ra,0xffffe
    8020289c:	cc0080e7          	jalr	-832(ra) # 80200558 <printf>
    802028a0:	0001                	nop
    802028a2:	70a2                	ld	ra,40(sp)
    802028a4:	7402                	ld	s0,32(sp)
    802028a6:	6145                	addi	sp,sp,48
    802028a8:	8082                	ret

00000000802028aa <r_tp>:
    802028aa:	1101                	addi	sp,sp,-32
    802028ac:	ec22                	sd	s0,24(sp)
    802028ae:	1000                	addi	s0,sp,32
    802028b0:	8792                	mv	a5,tp
    802028b2:	fef43423          	sd	a5,-24(s0)
    802028b6:	fe843783          	ld	a5,-24(s0)
    802028ba:	853e                	mv	a0,a5
    802028bc:	6462                	ld	s0,24(sp)
    802028be:	6105                	addi	sp,sp,32
    802028c0:	8082                	ret

00000000802028c2 <write32>:
    802028c2:	7179                	addi	sp,sp,-48
    802028c4:	f406                	sd	ra,40(sp)
    802028c6:	f022                	sd	s0,32(sp)
    802028c8:	1800                	addi	s0,sp,48
    802028ca:	fca43c23          	sd	a0,-40(s0)
    802028ce:	87ae                	mv	a5,a1
    802028d0:	fcf42a23          	sw	a5,-44(s0)
    802028d4:	fd843783          	ld	a5,-40(s0)
    802028d8:	8b8d                	andi	a5,a5,3
    802028da:	eb99                	bnez	a5,802028f0 <write32+0x2e>
    802028dc:	fd843783          	ld	a5,-40(s0)
    802028e0:	fef43423          	sd	a5,-24(s0)
    802028e4:	fe843783          	ld	a5,-24(s0)
    802028e8:	fd442703          	lw	a4,-44(s0)
    802028ec:	c398                	sw	a4,0(a5)
    802028ee:	a819                	j	80202904 <write32+0x42>
    802028f0:	fd843583          	ld	a1,-40(s0)
    802028f4:	00002517          	auipc	a0,0x2
    802028f8:	8c450513          	addi	a0,a0,-1852 # 802041b8 <small_numbers+0x1038>
    802028fc:	ffffe097          	auipc	ra,0xffffe
    80202900:	c5c080e7          	jalr	-932(ra) # 80200558 <printf>
    80202904:	0001                	nop
    80202906:	70a2                	ld	ra,40(sp)
    80202908:	7402                	ld	s0,32(sp)
    8020290a:	6145                	addi	sp,sp,48
    8020290c:	8082                	ret

000000008020290e <read32>:
    8020290e:	7179                	addi	sp,sp,-48
    80202910:	f406                	sd	ra,40(sp)
    80202912:	f022                	sd	s0,32(sp)
    80202914:	1800                	addi	s0,sp,48
    80202916:	fca43c23          	sd	a0,-40(s0)
    8020291a:	fd843783          	ld	a5,-40(s0)
    8020291e:	8b8d                	andi	a5,a5,3
    80202920:	eb91                	bnez	a5,80202934 <read32+0x26>
    80202922:	fd843783          	ld	a5,-40(s0)
    80202926:	fef43423          	sd	a5,-24(s0)
    8020292a:	fe843783          	ld	a5,-24(s0)
    8020292e:	439c                	lw	a5,0(a5)
    80202930:	2781                	sext.w	a5,a5
    80202932:	a821                	j	8020294a <read32+0x3c>
    80202934:	fd843583          	ld	a1,-40(s0)
    80202938:	00002517          	auipc	a0,0x2
    8020293c:	8b050513          	addi	a0,a0,-1872 # 802041e8 <small_numbers+0x1068>
    80202940:	ffffe097          	auipc	ra,0xffffe
    80202944:	c18080e7          	jalr	-1000(ra) # 80200558 <printf>
    80202948:	4781                	li	a5,0
    8020294a:	853e                	mv	a0,a5
    8020294c:	70a2                	ld	ra,40(sp)
    8020294e:	7402                	ld	s0,32(sp)
    80202950:	6145                	addi	sp,sp,48
    80202952:	8082                	ret

0000000080202954 <plicinit>:
    80202954:	1101                	addi	sp,sp,-32
    80202956:	ec06                	sd	ra,24(sp)
    80202958:	e822                	sd	s0,16(sp)
    8020295a:	1000                	addi	s0,sp,32
    8020295c:	4785                	li	a5,1
    8020295e:	fef42623          	sw	a5,-20(s0)
    80202962:	a805                	j	80202992 <plicinit+0x3e>
    80202964:	fec42783          	lw	a5,-20(s0)
    80202968:	0027979b          	slliw	a5,a5,0x2
    8020296c:	2781                	sext.w	a5,a5
    8020296e:	873e                	mv	a4,a5
    80202970:	0c0007b7          	lui	a5,0xc000
    80202974:	97ba                	add	a5,a5,a4
    80202976:	fef43023          	sd	a5,-32(s0)
    8020297a:	4581                	li	a1,0
    8020297c:	fe043503          	ld	a0,-32(s0)
    80202980:	00000097          	auipc	ra,0x0
    80202984:	f42080e7          	jalr	-190(ra) # 802028c2 <write32>
    80202988:	fec42783          	lw	a5,-20(s0)
    8020298c:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    8020298e:	fef42623          	sw	a5,-20(s0)
    80202992:	fec42783          	lw	a5,-20(s0)
    80202996:	0007871b          	sext.w	a4,a5
    8020299a:	02000793          	li	a5,32
    8020299e:	fce7d3e3          	bge	a5,a4,80202964 <plicinit+0x10>
    802029a2:	4585                	li	a1,1
    802029a4:	0c0007b7          	lui	a5,0xc000
    802029a8:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    802029ac:	00000097          	auipc	ra,0x0
    802029b0:	f16080e7          	jalr	-234(ra) # 802028c2 <write32>
    802029b4:	4585                	li	a1,1
    802029b6:	0c0007b7          	lui	a5,0xc000
    802029ba:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    802029be:	00000097          	auipc	ra,0x0
    802029c2:	f04080e7          	jalr	-252(ra) # 802028c2 <write32>
    802029c6:	0001                	nop
    802029c8:	60e2                	ld	ra,24(sp)
    802029ca:	6442                	ld	s0,16(sp)
    802029cc:	6105                	addi	sp,sp,32
    802029ce:	8082                	ret

00000000802029d0 <plicinithart>:
    802029d0:	7179                	addi	sp,sp,-48
    802029d2:	f406                	sd	ra,40(sp)
    802029d4:	f022                	sd	s0,32(sp)
    802029d6:	1800                	addi	s0,sp,48
    802029d8:	00000097          	auipc	ra,0x0
    802029dc:	ed2080e7          	jalr	-302(ra) # 802028aa <r_tp>
    802029e0:	87aa                	mv	a5,a0
    802029e2:	fef42623          	sw	a5,-20(s0)
    802029e6:	fec42783          	lw	a5,-20(s0)
    802029ea:	0087979b          	slliw	a5,a5,0x8
    802029ee:	2781                	sext.w	a5,a5
    802029f0:	873e                	mv	a4,a5
    802029f2:	0c0027b7          	lui	a5,0xc002
    802029f6:	08078793          	addi	a5,a5,128 # c002080 <_entry-0x741fdf80>
    802029fa:	97ba                	add	a5,a5,a4
    802029fc:	fef43023          	sd	a5,-32(s0)
    80202a00:	fec42783          	lw	a5,-20(s0)
    80202a04:	00d7979b          	slliw	a5,a5,0xd
    80202a08:	2781                	sext.w	a5,a5
    80202a0a:	873e                	mv	a4,a5
    80202a0c:	0c2017b7          	lui	a5,0xc201
    80202a10:	97ba                	add	a5,a5,a4
    80202a12:	fcf43c23          	sd	a5,-40(s0)
    80202a16:	40200593          	li	a1,1026
    80202a1a:	fe043503          	ld	a0,-32(s0)
    80202a1e:	00000097          	auipc	ra,0x0
    80202a22:	ea4080e7          	jalr	-348(ra) # 802028c2 <write32>
    80202a26:	4581                	li	a1,0
    80202a28:	fd843503          	ld	a0,-40(s0)
    80202a2c:	00000097          	auipc	ra,0x0
    80202a30:	e96080e7          	jalr	-362(ra) # 802028c2 <write32>
    80202a34:	0001                	nop
    80202a36:	70a2                	ld	ra,40(sp)
    80202a38:	7402                	ld	s0,32(sp)
    80202a3a:	6145                	addi	sp,sp,48
    80202a3c:	8082                	ret

0000000080202a3e <plic_enable>:
    80202a3e:	7139                	addi	sp,sp,-64
    80202a40:	fc06                	sd	ra,56(sp)
    80202a42:	f822                	sd	s0,48(sp)
    80202a44:	0080                	addi	s0,sp,64
    80202a46:	87aa                	mv	a5,a0
    80202a48:	fcf42623          	sw	a5,-52(s0)
    80202a4c:	00000097          	auipc	ra,0x0
    80202a50:	e5e080e7          	jalr	-418(ra) # 802028aa <r_tp>
    80202a54:	87aa                	mv	a5,a0
    80202a56:	fef42623          	sw	a5,-20(s0)
    80202a5a:	fec42783          	lw	a5,-20(s0)
    80202a5e:	0087979b          	slliw	a5,a5,0x8
    80202a62:	2781                	sext.w	a5,a5
    80202a64:	873e                	mv	a4,a5
    80202a66:	0c0027b7          	lui	a5,0xc002
    80202a6a:	08078793          	addi	a5,a5,128 # c002080 <_entry-0x741fdf80>
    80202a6e:	97ba                	add	a5,a5,a4
    80202a70:	fef43023          	sd	a5,-32(s0)
    80202a74:	fe043503          	ld	a0,-32(s0)
    80202a78:	00000097          	auipc	ra,0x0
    80202a7c:	e96080e7          	jalr	-362(ra) # 8020290e <read32>
    80202a80:	87aa                	mv	a5,a0
    80202a82:	fcf42e23          	sw	a5,-36(s0)
    80202a86:	fcc42783          	lw	a5,-52(s0)
    80202a8a:	873e                	mv	a4,a5
    80202a8c:	4785                	li	a5,1
    80202a8e:	00e797bb          	sllw	a5,a5,a4
    80202a92:	2781                	sext.w	a5,a5
    80202a94:	2781                	sext.w	a5,a5
    80202a96:	fdc42703          	lw	a4,-36(s0)
    80202a9a:	8fd9                	or	a5,a5,a4
    80202a9c:	2781                	sext.w	a5,a5
    80202a9e:	85be                	mv	a1,a5
    80202aa0:	fe043503          	ld	a0,-32(s0)
    80202aa4:	00000097          	auipc	ra,0x0
    80202aa8:	e1e080e7          	jalr	-482(ra) # 802028c2 <write32>
    80202aac:	0001                	nop
    80202aae:	70e2                	ld	ra,56(sp)
    80202ab0:	7442                	ld	s0,48(sp)
    80202ab2:	6121                	addi	sp,sp,64
    80202ab4:	8082                	ret

0000000080202ab6 <plic_disable>:
    80202ab6:	7139                	addi	sp,sp,-64
    80202ab8:	fc06                	sd	ra,56(sp)
    80202aba:	f822                	sd	s0,48(sp)
    80202abc:	0080                	addi	s0,sp,64
    80202abe:	87aa                	mv	a5,a0
    80202ac0:	fcf42623          	sw	a5,-52(s0)
    80202ac4:	00000097          	auipc	ra,0x0
    80202ac8:	de6080e7          	jalr	-538(ra) # 802028aa <r_tp>
    80202acc:	87aa                	mv	a5,a0
    80202ace:	fef42623          	sw	a5,-20(s0)
    80202ad2:	fec42783          	lw	a5,-20(s0)
    80202ad6:	0087979b          	slliw	a5,a5,0x8
    80202ada:	2781                	sext.w	a5,a5
    80202adc:	873e                	mv	a4,a5
    80202ade:	0c0027b7          	lui	a5,0xc002
    80202ae2:	08078793          	addi	a5,a5,128 # c002080 <_entry-0x741fdf80>
    80202ae6:	97ba                	add	a5,a5,a4
    80202ae8:	fef43023          	sd	a5,-32(s0)
    80202aec:	fe043503          	ld	a0,-32(s0)
    80202af0:	00000097          	auipc	ra,0x0
    80202af4:	e1e080e7          	jalr	-482(ra) # 8020290e <read32>
    80202af8:	87aa                	mv	a5,a0
    80202afa:	fcf42e23          	sw	a5,-36(s0)
    80202afe:	fcc42783          	lw	a5,-52(s0)
    80202b02:	873e                	mv	a4,a5
    80202b04:	4785                	li	a5,1
    80202b06:	00e797bb          	sllw	a5,a5,a4
    80202b0a:	2781                	sext.w	a5,a5
    80202b0c:	fff7c793          	not	a5,a5
    80202b10:	2781                	sext.w	a5,a5
    80202b12:	2781                	sext.w	a5,a5
    80202b14:	fdc42703          	lw	a4,-36(s0)
    80202b18:	8ff9                	and	a5,a5,a4
    80202b1a:	2781                	sext.w	a5,a5
    80202b1c:	85be                	mv	a1,a5
    80202b1e:	fe043503          	ld	a0,-32(s0)
    80202b22:	00000097          	auipc	ra,0x0
    80202b26:	da0080e7          	jalr	-608(ra) # 802028c2 <write32>
    80202b2a:	0001                	nop
    80202b2c:	70e2                	ld	ra,56(sp)
    80202b2e:	7442                	ld	s0,48(sp)
    80202b30:	6121                	addi	sp,sp,64
    80202b32:	8082                	ret

0000000080202b34 <plic_claim>:
    80202b34:	1101                	addi	sp,sp,-32
    80202b36:	ec06                	sd	ra,24(sp)
    80202b38:	e822                	sd	s0,16(sp)
    80202b3a:	1000                	addi	s0,sp,32
    80202b3c:	00000097          	auipc	ra,0x0
    80202b40:	d6e080e7          	jalr	-658(ra) # 802028aa <r_tp>
    80202b44:	87aa                	mv	a5,a0
    80202b46:	fef42623          	sw	a5,-20(s0)
    80202b4a:	fec42783          	lw	a5,-20(s0)
    80202b4e:	00d7979b          	slliw	a5,a5,0xd
    80202b52:	2781                	sext.w	a5,a5
    80202b54:	873e                	mv	a4,a5
    80202b56:	0c2017b7          	lui	a5,0xc201
    80202b5a:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73ffeffc>
    80202b5c:	97ba                	add	a5,a5,a4
    80202b5e:	fef43023          	sd	a5,-32(s0)
    80202b62:	fe043503          	ld	a0,-32(s0)
    80202b66:	00000097          	auipc	ra,0x0
    80202b6a:	da8080e7          	jalr	-600(ra) # 8020290e <read32>
    80202b6e:	87aa                	mv	a5,a0
    80202b70:	2781                	sext.w	a5,a5
    80202b72:	2781                	sext.w	a5,a5
    80202b74:	853e                	mv	a0,a5
    80202b76:	60e2                	ld	ra,24(sp)
    80202b78:	6442                	ld	s0,16(sp)
    80202b7a:	6105                	addi	sp,sp,32
    80202b7c:	8082                	ret

0000000080202b7e <plic_complete>:
    80202b7e:	7179                	addi	sp,sp,-48
    80202b80:	f406                	sd	ra,40(sp)
    80202b82:	f022                	sd	s0,32(sp)
    80202b84:	1800                	addi	s0,sp,48
    80202b86:	87aa                	mv	a5,a0
    80202b88:	fcf42e23          	sw	a5,-36(s0)
    80202b8c:	00000097          	auipc	ra,0x0
    80202b90:	d1e080e7          	jalr	-738(ra) # 802028aa <r_tp>
    80202b94:	87aa                	mv	a5,a0
    80202b96:	fef42623          	sw	a5,-20(s0)
    80202b9a:	fec42783          	lw	a5,-20(s0)
    80202b9e:	00d7979b          	slliw	a5,a5,0xd
    80202ba2:	2781                	sext.w	a5,a5
    80202ba4:	873e                	mv	a4,a5
    80202ba6:	0c2017b7          	lui	a5,0xc201
    80202baa:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73ffeffc>
    80202bac:	97ba                	add	a5,a5,a4
    80202bae:	fef43023          	sd	a5,-32(s0)
    80202bb2:	fdc42783          	lw	a5,-36(s0)
    80202bb6:	85be                	mv	a1,a5
    80202bb8:	fe043503          	ld	a0,-32(s0)
    80202bbc:	00000097          	auipc	ra,0x0
    80202bc0:	d06080e7          	jalr	-762(ra) # 802028c2 <write32>
    80202bc4:	0001                	nop
    80202bc6:	70a2                	ld	ra,40(sp)
    80202bc8:	7402                	ld	s0,32(sp)
    80202bca:	6145                	addi	sp,sp,48
    80202bcc:	8082                	ret
	...

0000000080202bd0 <kernelvec>:
    80202bd0:	7111                	addi	sp,sp,-256
    80202bd2:	e006                	sd	ra,0(sp)
    80202bd4:	e80e                	sd	gp,16(sp)
    80202bd6:	ec12                	sd	tp,24(sp)
    80202bd8:	f016                	sd	t0,32(sp)
    80202bda:	f41a                	sd	t1,40(sp)
    80202bdc:	f81e                	sd	t2,48(sp)
    80202bde:	fc22                	sd	s0,56(sp)
    80202be0:	e0a6                	sd	s1,64(sp)
    80202be2:	e4aa                	sd	a0,72(sp)
    80202be4:	e8ae                	sd	a1,80(sp)
    80202be6:	ecb2                	sd	a2,88(sp)
    80202be8:	f0b6                	sd	a3,96(sp)
    80202bea:	f4ba                	sd	a4,104(sp)
    80202bec:	f8be                	sd	a5,112(sp)
    80202bee:	fcc2                	sd	a6,120(sp)
    80202bf0:	e146                	sd	a7,128(sp)
    80202bf2:	e54a                	sd	s2,136(sp)
    80202bf4:	e94e                	sd	s3,144(sp)
    80202bf6:	ed52                	sd	s4,152(sp)
    80202bf8:	f156                	sd	s5,160(sp)
    80202bfa:	f55a                	sd	s6,168(sp)
    80202bfc:	f95e                	sd	s7,176(sp)
    80202bfe:	fd62                	sd	s8,184(sp)
    80202c00:	e1e6                	sd	s9,192(sp)
    80202c02:	e5ea                	sd	s10,200(sp)
    80202c04:	e9ee                	sd	s11,208(sp)
    80202c06:	edf2                	sd	t3,216(sp)
    80202c08:	f1f6                	sd	t4,224(sp)
    80202c0a:	f5fa                	sd	t5,232(sp)
    80202c0c:	f9fe                	sd	t6,240(sp)
    80202c0e:	00000097          	auipc	ra,0x0
    80202c12:	916080e7          	jalr	-1770(ra) # 80202524 <kerneltrap>
    80202c16:	6082                	ld	ra,0(sp)
    80202c18:	61c2                	ld	gp,16(sp)
    80202c1a:	7282                	ld	t0,32(sp)
    80202c1c:	7322                	ld	t1,40(sp)
    80202c1e:	73c2                	ld	t2,48(sp)
    80202c20:	7462                	ld	s0,56(sp)
    80202c22:	6486                	ld	s1,64(sp)
    80202c24:	6526                	ld	a0,72(sp)
    80202c26:	65c6                	ld	a1,80(sp)
    80202c28:	6666                	ld	a2,88(sp)
    80202c2a:	7686                	ld	a3,96(sp)
    80202c2c:	7726                	ld	a4,104(sp)
    80202c2e:	77c6                	ld	a5,112(sp)
    80202c30:	7866                	ld	a6,120(sp)
    80202c32:	688a                	ld	a7,128(sp)
    80202c34:	692a                	ld	s2,136(sp)
    80202c36:	69ca                	ld	s3,144(sp)
    80202c38:	6a6a                	ld	s4,152(sp)
    80202c3a:	7a8a                	ld	s5,160(sp)
    80202c3c:	7b2a                	ld	s6,168(sp)
    80202c3e:	7bca                	ld	s7,176(sp)
    80202c40:	7c6a                	ld	s8,184(sp)
    80202c42:	6c8e                	ld	s9,192(sp)
    80202c44:	6d2e                	ld	s10,200(sp)
    80202c46:	6dce                	ld	s11,208(sp)
    80202c48:	6e6e                	ld	t3,216(sp)
    80202c4a:	7e8e                	ld	t4,224(sp)
    80202c4c:	7f2e                	ld	t5,232(sp)
    80202c4e:	7fce                	ld	t6,240(sp)
    80202c50:	6111                	addi	sp,sp,256
    80202c52:	10200073          	sret
    80202c56:	0001                	nop
    80202c58:	00000013          	nop
    80202c5c:	00000013          	nop
	...
