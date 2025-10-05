
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80200000:	00005117          	auipc	sp,0x5
    80200004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80200008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8020000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8020000c:	00006517          	auipc	a0,0x6
    80200010:	01450513          	addi	a0,a0,20 # 80206020 <kernel_pagetable>
        la a1,_bss_end
    80200014:	00006597          	auipc	a1,0x6
    80200018:	2ac58593          	addi	a1,a1,684 # 802062c0 <_bss_end>

000000008020001c <clear_bss>:
clear_bss:
        bgeu a0,a1,bss_done
    8020001c:	00b57663          	bgeu	a0,a1,80200028 <bss_done>
        sw zero,0(a0)
    80200020:	00052023          	sw	zero,0(a0)
        addi a0,a0,4
    80200024:	0511                	addi	a0,a0,4
        j clear_bss
    80200026:	bfdd                	j	8020001c <clear_bss>

0000000080200028 <bss_done>:
bss_done:
        call start # 跳转到start函数
    80200028:	00000097          	auipc	ra,0x0
    8020002c:	068080e7          	jalr	104(ra) # 80200090 <start>

0000000080200030 <spin>:
spin:
        j spin # 无限循环，防止程序退出
    80200030:	a001                	j	80200030 <spin>

0000000080200032 <r_sstatus>:
void test_basic_colors(void);
void clear_screen(void);
// start函数：内核的C语言入口
void start(){
	// 初始化内核的重要组件
	// 内存页分配器
    80200032:	1101                	addi	sp,sp,-32 # 80204fe0 <small_numbers+0x1e40>
    80200034:	ec22                	sd	s0,24(sp)
    80200036:	1000                	addi	s0,sp,32
	pmm_init();
	// 虚拟内存
    80200038:	100027f3          	csrr	a5,sstatus
    8020003c:	fef43423          	sd	a5,-24(s0)
	printf("[VP TEST] 尝试启用分页模式\n");
    80200040:	fe843783          	ld	a5,-24(s0)
	kvminit();
    80200044:	853e                	mv	a0,a5
    80200046:	6462                	ld	s0,24(sp)
    80200048:	6105                	addi	sp,sp,32
    8020004a:	8082                	ret

000000008020004c <w_sstatus>:
    kvminithart();
    8020004c:	1101                	addi	sp,sp,-32
    8020004e:	ec22                	sd	s0,24(sp)
    80200050:	1000                	addi	s0,sp,32
    80200052:	fea43423          	sd	a0,-24(s0)

    80200056:	fe843783          	ld	a5,-24(s0)
    8020005a:	10079073          	csrw	sstatus,a5
    // 进入操作系统后立即清屏
    8020005e:	0001                	nop
    80200060:	6462                	ld	s0,24(sp)
    80200062:	6105                	addi	sp,sp,32
    80200064:	8082                	ret

0000000080200066 <intr_on>:
    // 输出操作系统启动横幅
    uart_puts("===============================================\n");
    uart_puts("        RISC-V Operating System v1.0         \n");
    uart_puts("===============================================\n\n");
    //printf("[VP TEST] 当前已启用分页模式\n");

    80200066:	1141                	addi	sp,sp,-16
    80200068:	e406                	sd	ra,8(sp)
    8020006a:	e022                	sd	s0,0(sp)
    8020006c:	0800                	addi	s0,sp,16
	trap_init();
    8020006e:	00000097          	auipc	ra,0x0
    80200072:	fc4080e7          	jalr	-60(ra) # 80200032 <r_sstatus>
    80200076:	87aa                	mv	a5,a0
    80200078:	0027e793          	ori	a5,a5,2
    8020007c:	853e                	mv	a0,a5
    8020007e:	00000097          	auipc	ra,0x0
    80200082:	fce080e7          	jalr	-50(ra) # 8020004c <w_sstatus>
    uart_puts("\nSystem ready. Entering main loop...\n");
    80200086:	0001                	nop
    80200088:	60a2                	ld	ra,8(sp)
    8020008a:	6402                	ld	s0,0(sp)
    8020008c:	0141                	addi	sp,sp,16
    8020008e:	8082                	ret

0000000080200090 <start>:
void start(){
    80200090:	1141                	addi	sp,sp,-16
    80200092:	e406                	sd	ra,8(sp)
    80200094:	e022                	sd	s0,0(sp)
    80200096:	0800                	addi	s0,sp,16
	pmm_init();
    80200098:	00002097          	auipc	ra,0x2
    8020009c:	ea8080e7          	jalr	-344(ra) # 80201f40 <pmm_init>
	printf("[VP TEST] 尝试启用分页模式\n");
    802000a0:	00003517          	auipc	a0,0x3
    802000a4:	f6050513          	addi	a0,a0,-160 # 80203000 <etext>
    802000a8:	00000097          	auipc	ra,0x0
    802000ac:	50c080e7          	jalr	1292(ra) # 802005b4 <printf>
	kvminit();
    802000b0:	00002097          	auipc	ra,0x2
    802000b4:	bb0080e7          	jalr	-1104(ra) # 80201c60 <kvminit>
    kvminithart();
    802000b8:	00002097          	auipc	ra,0x2
    802000bc:	bfa080e7          	jalr	-1030(ra) # 80201cb2 <kvminithart>
    clear_screen();
    802000c0:	00001097          	auipc	ra,0x1
    802000c4:	8ec080e7          	jalr	-1812(ra) # 802009ac <clear_screen>
    uart_puts("===============================================\n");
    802000c8:	00003517          	auipc	a0,0x3
    802000cc:	f6050513          	addi	a0,a0,-160 # 80203028 <etext+0x28>
    802000d0:	00000097          	auipc	ra,0x0
    802000d4:	116080e7          	jalr	278(ra) # 802001e6 <uart_puts>
    uart_puts("        RISC-V Operating System v1.0         \n");
    802000d8:	00003517          	auipc	a0,0x3
    802000dc:	f8850513          	addi	a0,a0,-120 # 80203060 <etext+0x60>
    802000e0:	00000097          	auipc	ra,0x0
    802000e4:	106080e7          	jalr	262(ra) # 802001e6 <uart_puts>
    uart_puts("===============================================\n\n");
    802000e8:	00003517          	auipc	a0,0x3
    802000ec:	fa850513          	addi	a0,a0,-88 # 80203090 <etext+0x90>
    802000f0:	00000097          	auipc	ra,0x0
    802000f4:	0f6080e7          	jalr	246(ra) # 802001e6 <uart_puts>
	trap_init();
    802000f8:	00002097          	auipc	ra,0x2
    802000fc:	3d4080e7          	jalr	980(ra) # 802024cc <trap_init>
    uart_puts("\nSystem ready. Entering main loop...\n");
    80200100:	00003517          	auipc	a0,0x3
    80200104:	fc850513          	addi	a0,a0,-56 # 802030c8 <etext+0xc8>
    80200108:	00000097          	auipc	ra,0x0
    8020010c:	0de080e7          	jalr	222(ra) # 802001e6 <uart_puts>
	// 允许中断
    intr_on();
    80200110:	00000097          	auipc	ra,0x0
    80200114:	f56080e7          	jalr	-170(ra) # 80200066 <intr_on>
	test_timer_interrupt();
    80200118:	00002097          	auipc	ra,0x2
    8020011c:	55c080e7          	jalr	1372(ra) # 80202674 <test_timer_interrupt>
	printf("[KERNEL] Timer interrupt test finished!\n");
    80200120:	00003517          	auipc	a0,0x3
    80200124:	fd050513          	addi	a0,a0,-48 # 802030f0 <etext+0xf0>
    80200128:	00000097          	auipc	ra,0x0
    8020012c:	48c080e7          	jalr	1164(ra) # 802005b4 <printf>
	uart_init();
    80200130:	00000097          	auipc	ra,0x0
    80200134:	01c080e7          	jalr	28(ra) # 8020014c <uart_init>
	printf("外部中断：键盘输入已经注册，请尝试输入字符并观察UART输出\n");
    80200138:	00003517          	auipc	a0,0x3
    8020013c:	fe850513          	addi	a0,a0,-24 # 80203120 <etext+0x120>
    80200140:	00000097          	auipc	ra,0x0
    80200144:	474080e7          	jalr	1140(ra) # 802005b4 <printf>
    // 主循环
	while(1){
    80200148:	0001                	nop
    8020014a:	bffd                	j	80200148 <start+0xb8>

000000008020014c <uart_init>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))


// UART初始化函数
void uart_init(void) {
    8020014c:	1141                	addi	sp,sp,-16
    8020014e:	e406                	sd	ra,8(sp)
    80200150:	e022                	sd	s0,0(sp)
    80200152:	0800                	addi	s0,sp,16

    WriteReg(IER, 0x00);
    80200154:	100007b7          	lui	a5,0x10000
    80200158:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    8020015a:	00078023          	sb	zero,0(a5)
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8020015e:	100007b7          	lui	a5,0x10000
    80200162:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x701ffffe>
    80200164:	471d                	li	a4,7
    80200166:	00e78023          	sb	a4,0(a5)
    WriteReg(IER, IER_RX_ENABLE);
    8020016a:	100007b7          	lui	a5,0x10000
    8020016e:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    80200170:	4705                	li	a4,1
    80200172:	00e78023          	sb	a4,0(a5)
    register_interrupt(UART0_IRQ, uart_intr);//注册键盘输入的中断处理函数
    80200176:	00000597          	auipc	a1,0x0
    8020017a:	12858593          	addi	a1,a1,296 # 8020029e <uart_intr>
    8020017e:	4529                	li	a0,10
    80200180:	00002097          	auipc	ra,0x2
    80200184:	1c8080e7          	jalr	456(ra) # 80202348 <register_interrupt>
    enable_interrupts(UART0_IRQ);
    80200188:	4529                	li	a0,10
    8020018a:	00002097          	auipc	ra,0x2
    8020018e:	248080e7          	jalr	584(ra) # 802023d2 <enable_interrupts>
    printf("UART initialized with input support\n");
    80200192:	00003517          	auipc	a0,0x3
    80200196:	fe650513          	addi	a0,a0,-26 # 80203178 <etext+0x178>
    8020019a:	00000097          	auipc	ra,0x0
    8020019e:	41a080e7          	jalr	1050(ra) # 802005b4 <printf>
}
    802001a2:	0001                	nop
    802001a4:	60a2                	ld	ra,8(sp)
    802001a6:	6402                	ld	s0,0(sp)
    802001a8:	0141                	addi	sp,sp,16
    802001aa:	8082                	ret

00000000802001ac <uart_putc>:

// 发送单个字符
void uart_putc(char c) {
    802001ac:	1101                	addi	sp,sp,-32
    802001ae:	ec22                	sd	s0,24(sp)
    802001b0:	1000                	addi	s0,sp,32
    802001b2:	87aa                	mv	a5,a0
    802001b4:	fef407a3          	sb	a5,-17(s0)
    // 等待发送缓冲区空闲
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    802001b8:	0001                	nop
    802001ba:	100007b7          	lui	a5,0x10000
    802001be:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    802001c0:	0007c783          	lbu	a5,0(a5)
    802001c4:	0ff7f793          	zext.b	a5,a5
    802001c8:	2781                	sext.w	a5,a5
    802001ca:	0207f793          	andi	a5,a5,32
    802001ce:	2781                	sext.w	a5,a5
    802001d0:	d7ed                	beqz	a5,802001ba <uart_putc+0xe>
    WriteReg(THR, c);
    802001d2:	100007b7          	lui	a5,0x10000
    802001d6:	fef44703          	lbu	a4,-17(s0)
    802001da:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
}
    802001de:	0001                	nop
    802001e0:	6462                	ld	s0,24(sp)
    802001e2:	6105                	addi	sp,sp,32
    802001e4:	8082                	ret

00000000802001e6 <uart_puts>:

void uart_puts(char *s) {
    802001e6:	7179                	addi	sp,sp,-48
    802001e8:	f422                	sd	s0,40(sp)
    802001ea:	1800                	addi	s0,sp,48
    802001ec:	fca43c23          	sd	a0,-40(s0)
    if (!s) return;
    802001f0:	fd843783          	ld	a5,-40(s0)
    802001f4:	c7b5                	beqz	a5,80200260 <uart_puts+0x7a>
    
    while (*s) {
    802001f6:	a8b9                	j	80200254 <uart_puts+0x6e>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    802001f8:	0001                	nop
    802001fa:	100007b7          	lui	a5,0x10000
    802001fe:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200200:	0007c783          	lbu	a5,0(a5)
    80200204:	0ff7f793          	zext.b	a5,a5
    80200208:	2781                	sext.w	a5,a5
    8020020a:	0207f793          	andi	a5,a5,32
    8020020e:	2781                	sext.w	a5,a5
    80200210:	d7ed                	beqz	a5,802001fa <uart_puts+0x14>
        int sent_count = 0;
    80200212:	fe042623          	sw	zero,-20(s0)
        while (*s && sent_count < 4) { 
    80200216:	a01d                	j	8020023c <uart_puts+0x56>
            WriteReg(THR, *s);
    80200218:	100007b7          	lui	a5,0x10000
    8020021c:	fd843703          	ld	a4,-40(s0)
    80200220:	00074703          	lbu	a4,0(a4)
    80200224:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
            s++;
    80200228:	fd843783          	ld	a5,-40(s0)
    8020022c:	0785                	addi	a5,a5,1
    8020022e:	fcf43c23          	sd	a5,-40(s0)
            sent_count++;
    80200232:	fec42783          	lw	a5,-20(s0)
    80200236:	2785                	addiw	a5,a5,1
    80200238:	fef42623          	sw	a5,-20(s0)
        while (*s && sent_count < 4) { 
    8020023c:	fd843783          	ld	a5,-40(s0)
    80200240:	0007c783          	lbu	a5,0(a5)
    80200244:	cb81                	beqz	a5,80200254 <uart_puts+0x6e>
    80200246:	fec42783          	lw	a5,-20(s0)
    8020024a:	0007871b          	sext.w	a4,a5
    8020024e:	478d                	li	a5,3
    80200250:	fce7d4e3          	bge	a5,a4,80200218 <uart_puts+0x32>
    while (*s) {
    80200254:	fd843783          	ld	a5,-40(s0)
    80200258:	0007c783          	lbu	a5,0(a5)
    8020025c:	ffd1                	bnez	a5,802001f8 <uart_puts+0x12>
    8020025e:	a011                	j	80200262 <uart_puts+0x7c>
    if (!s) return;
    80200260:	0001                	nop
        }
    }
}
    80200262:	7422                	ld	s0,40(sp)
    80200264:	6145                	addi	sp,sp,48
    80200266:	8082                	ret

0000000080200268 <uart_getc>:

int uart_getc(void) {
    80200268:	1141                	addi	sp,sp,-16
    8020026a:	e422                	sd	s0,8(sp)
    8020026c:	0800                	addi	s0,sp,16
    if ((ReadReg(LSR) & LSR_RX_READY) == 0)
    8020026e:	100007b7          	lui	a5,0x10000
    80200272:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200274:	0007c783          	lbu	a5,0(a5)
    80200278:	0ff7f793          	zext.b	a5,a5
    8020027c:	2781                	sext.w	a5,a5
    8020027e:	8b85                	andi	a5,a5,1
    80200280:	2781                	sext.w	a5,a5
    80200282:	e399                	bnez	a5,80200288 <uart_getc+0x20>
        return -1; 
    80200284:	57fd                	li	a5,-1
    80200286:	a801                	j	80200296 <uart_getc+0x2e>
    return ReadReg(RHR); 
    80200288:	100007b7          	lui	a5,0x10000
    8020028c:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    80200290:	0ff7f793          	zext.b	a5,a5
    80200294:	2781                	sext.w	a5,a5
}
    80200296:	853e                	mv	a0,a5
    80200298:	6422                	ld	s0,8(sp)
    8020029a:	0141                	addi	sp,sp,16
    8020029c:	8082                	ret

000000008020029e <uart_intr>:

// UART中断处理函数
void uart_intr(void) {
    8020029e:	1101                	addi	sp,sp,-32
    802002a0:	ec06                	sd	ra,24(sp)
    802002a2:	e822                	sd	s0,16(sp)
    802002a4:	1000                	addi	s0,sp,32
    while (ReadReg(LSR) & LSR_RX_READY) {
    802002a6:	a041                	j	80200326 <uart_intr+0x88>
        char c = ReadReg(RHR);
    802002a8:	100007b7          	lui	a5,0x10000
    802002ac:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    802002b0:	fef407a3          	sb	a5,-17(s0)
                // 处理特殊字符
        if (c == 127 || c == 8) {  // Backspace
    802002b4:	fef44783          	lbu	a5,-17(s0)
    802002b8:	0ff7f713          	zext.b	a4,a5
    802002bc:	07f00793          	li	a5,127
    802002c0:	00f70963          	beq	a4,a5,802002d2 <uart_intr+0x34>
    802002c4:	fef44783          	lbu	a5,-17(s0)
    802002c8:	0ff7f713          	zext.b	a4,a5
    802002cc:	47a1                	li	a5,8
    802002ce:	02f71363          	bne	a4,a5,802002f4 <uart_intr+0x56>
            // 输出退格序列：退格，空格，再退格
            uart_putc('\b');  // 退格
    802002d2:	4521                	li	a0,8
    802002d4:	00000097          	auipc	ra,0x0
    802002d8:	ed8080e7          	jalr	-296(ra) # 802001ac <uart_putc>
            uart_putc(' ');   // 覆盖之前的字符
    802002dc:	02000513          	li	a0,32
    802002e0:	00000097          	auipc	ra,0x0
    802002e4:	ecc080e7          	jalr	-308(ra) # 802001ac <uart_putc>
            uart_putc('\b');  // 再次退格
    802002e8:	4521                	li	a0,8
    802002ea:	00000097          	auipc	ra,0x0
    802002ee:	ec2080e7          	jalr	-318(ra) # 802001ac <uart_putc>
    802002f2:	a815                	j	80200326 <uart_intr+0x88>
        }
        else if (c == 13) {  // Enter/Return
    802002f4:	fef44783          	lbu	a5,-17(s0)
    802002f8:	0ff7f713          	zext.b	a4,a5
    802002fc:	47b5                	li	a5,13
    802002fe:	00f71d63          	bne	a4,a5,80200318 <uart_intr+0x7a>
            // 输出回车换行
            uart_putc('\r');  // 回车
    80200302:	4535                	li	a0,13
    80200304:	00000097          	auipc	ra,0x0
    80200308:	ea8080e7          	jalr	-344(ra) # 802001ac <uart_putc>
            uart_putc('\n');  // 换行
    8020030c:	4529                	li	a0,10
    8020030e:	00000097          	auipc	ra,0x0
    80200312:	e9e080e7          	jalr	-354(ra) # 802001ac <uart_putc>
    80200316:	a801                	j	80200326 <uart_intr+0x88>
        }
        else {
            // 普通字符直接回显
            uart_putc(c);
    80200318:	fef44783          	lbu	a5,-17(s0)
    8020031c:	853e                	mv	a0,a5
    8020031e:	00000097          	auipc	ra,0x0
    80200322:	e8e080e7          	jalr	-370(ra) # 802001ac <uart_putc>
    while (ReadReg(LSR) & LSR_RX_READY) {
    80200326:	100007b7          	lui	a5,0x10000
    8020032a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    8020032c:	0007c783          	lbu	a5,0(a5)
    80200330:	0ff7f793          	zext.b	a5,a5
    80200334:	2781                	sext.w	a5,a5
    80200336:	8b85                	andi	a5,a5,1
    80200338:	2781                	sext.w	a5,a5
    8020033a:	f7bd                	bnez	a5,802002a8 <uart_intr+0xa>
        }
    }
}
    8020033c:	0001                	nop
    8020033e:	0001                	nop
    80200340:	60e2                	ld	ra,24(sp)
    80200342:	6442                	ld	s0,16(sp)
    80200344:	6105                	addi	sp,sp,32
    80200346:	8082                	ret

0000000080200348 <flush_printf_buffer>:
#define PRINTF_BUFFER_SIZE 128
extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    80200348:	1141                	addi	sp,sp,-16
    8020034a:	e406                	sd	ra,8(sp)
    8020034c:	e022                	sd	s0,0(sp)
    8020034e:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    80200350:	00006797          	auipc	a5,0x6
    80200354:	d6078793          	addi	a5,a5,-672 # 802060b0 <printf_buf_pos>
    80200358:	439c                	lw	a5,0(a5)
    8020035a:	02f05c63          	blez	a5,80200392 <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    8020035e:	00006797          	auipc	a5,0x6
    80200362:	d5278793          	addi	a5,a5,-686 # 802060b0 <printf_buf_pos>
    80200366:	439c                	lw	a5,0(a5)
    80200368:	00006717          	auipc	a4,0x6
    8020036c:	cc870713          	addi	a4,a4,-824 # 80206030 <printf_buffer>
    80200370:	97ba                	add	a5,a5,a4
    80200372:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80200376:	00006517          	auipc	a0,0x6
    8020037a:	cba50513          	addi	a0,a0,-838 # 80206030 <printf_buffer>
    8020037e:	00000097          	auipc	ra,0x0
    80200382:	e68080e7          	jalr	-408(ra) # 802001e6 <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200386:	00006797          	auipc	a5,0x6
    8020038a:	d2a78793          	addi	a5,a5,-726 # 802060b0 <printf_buf_pos>
    8020038e:	0007a023          	sw	zero,0(a5)
	}
}
    80200392:	0001                	nop
    80200394:	60a2                	ld	ra,8(sp)
    80200396:	6402                	ld	s0,0(sp)
    80200398:	0141                	addi	sp,sp,16
    8020039a:	8082                	ret

000000008020039c <buffer_char>:
static void buffer_char(char c) {
    8020039c:	1101                	addi	sp,sp,-32
    8020039e:	ec06                	sd	ra,24(sp)
    802003a0:	e822                	sd	s0,16(sp)
    802003a2:	1000                	addi	s0,sp,32
    802003a4:	87aa                	mv	a5,a0
    802003a6:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    802003aa:	00006797          	auipc	a5,0x6
    802003ae:	d0678793          	addi	a5,a5,-762 # 802060b0 <printf_buf_pos>
    802003b2:	439c                	lw	a5,0(a5)
    802003b4:	873e                	mv	a4,a5
    802003b6:	07e00793          	li	a5,126
    802003ba:	02e7ca63          	blt	a5,a4,802003ee <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    802003be:	00006797          	auipc	a5,0x6
    802003c2:	cf278793          	addi	a5,a5,-782 # 802060b0 <printf_buf_pos>
    802003c6:	439c                	lw	a5,0(a5)
    802003c8:	0017871b          	addiw	a4,a5,1
    802003cc:	0007069b          	sext.w	a3,a4
    802003d0:	00006717          	auipc	a4,0x6
    802003d4:	ce070713          	addi	a4,a4,-800 # 802060b0 <printf_buf_pos>
    802003d8:	c314                	sw	a3,0(a4)
    802003da:	00006717          	auipc	a4,0x6
    802003de:	c5670713          	addi	a4,a4,-938 # 80206030 <printf_buffer>
    802003e2:	97ba                	add	a5,a5,a4
    802003e4:	fef44703          	lbu	a4,-17(s0)
    802003e8:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    802003ec:	a825                	j	80200424 <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    802003ee:	00000097          	auipc	ra,0x0
    802003f2:	f5a080e7          	jalr	-166(ra) # 80200348 <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    802003f6:	00006797          	auipc	a5,0x6
    802003fa:	cba78793          	addi	a5,a5,-838 # 802060b0 <printf_buf_pos>
    802003fe:	439c                	lw	a5,0(a5)
    80200400:	0017871b          	addiw	a4,a5,1
    80200404:	0007069b          	sext.w	a3,a4
    80200408:	00006717          	auipc	a4,0x6
    8020040c:	ca870713          	addi	a4,a4,-856 # 802060b0 <printf_buf_pos>
    80200410:	c314                	sw	a3,0(a4)
    80200412:	00006717          	auipc	a4,0x6
    80200416:	c1e70713          	addi	a4,a4,-994 # 80206030 <printf_buffer>
    8020041a:	97ba                	add	a5,a5,a4
    8020041c:	fef44703          	lbu	a4,-17(s0)
    80200420:	00e78023          	sb	a4,0(a5)
}
    80200424:	0001                	nop
    80200426:	60e2                	ld	ra,24(sp)
    80200428:	6442                	ld	s0,16(sp)
    8020042a:	6105                	addi	sp,sp,32
    8020042c:	8082                	ret

000000008020042e <consputc>:
    "70", "71", "72", "73", "74", "75", "76", "77", "78", "79",
    "80", "81", "82", "83", "84", "85", "86", "87", "88", "89",
    "90", "91", "92", "93", "94", "95", "96", "97", "98", "99"
};

static void consputc(int c){
    8020042e:	1101                	addi	sp,sp,-32
    80200430:	ec06                	sd	ra,24(sp)
    80200432:	e822                	sd	s0,16(sp)
    80200434:	1000                	addi	s0,sp,32
    80200436:	87aa                	mv	a5,a0
    80200438:	fef42623          	sw	a5,-20(s0)
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
    8020043c:	fec42783          	lw	a5,-20(s0)
    80200440:	0ff7f793          	zext.b	a5,a5
    80200444:	853e                	mv	a0,a5
    80200446:	00000097          	auipc	ra,0x0
    8020044a:	d66080e7          	jalr	-666(ra) # 802001ac <uart_putc>
}
    8020044e:	0001                	nop
    80200450:	60e2                	ld	ra,24(sp)
    80200452:	6442                	ld	s0,16(sp)
    80200454:	6105                	addi	sp,sp,32
    80200456:	8082                	ret

0000000080200458 <consputs>:
static void consputs(const char *s){
    80200458:	7179                	addi	sp,sp,-48
    8020045a:	f406                	sd	ra,40(sp)
    8020045c:	f022                	sd	s0,32(sp)
    8020045e:	1800                	addi	s0,sp,48
    80200460:	fca43c23          	sd	a0,-40(s0)
	char *str = (char *)s;
    80200464:	fd843783          	ld	a5,-40(s0)
    80200468:	fef43423          	sd	a5,-24(s0)
	// 直接调用uart_puts输出字符串
	uart_puts(str);
    8020046c:	fe843503          	ld	a0,-24(s0)
    80200470:	00000097          	auipc	ra,0x0
    80200474:	d76080e7          	jalr	-650(ra) # 802001e6 <uart_puts>
}
    80200478:	0001                	nop
    8020047a:	70a2                	ld	ra,40(sp)
    8020047c:	7402                	ld	s0,32(sp)
    8020047e:	6145                	addi	sp,sp,48
    80200480:	8082                	ret

0000000080200482 <printint>:
static void printint(long long xx,int base,int sign){
    80200482:	715d                	addi	sp,sp,-80
    80200484:	e486                	sd	ra,72(sp)
    80200486:	e0a2                	sd	s0,64(sp)
    80200488:	0880                	addi	s0,sp,80
    8020048a:	faa43c23          	sd	a0,-72(s0)
    8020048e:	87ae                	mv	a5,a1
    80200490:	8732                	mv	a4,a2
    80200492:	faf42a23          	sw	a5,-76(s0)
    80200496:	87ba                	mv	a5,a4
    80200498:	faf42823          	sw	a5,-80(s0)
	// 模仿xv6的printint
	static char digits[] = "0123456789abcdef";
	char buf[20]; // 增大缓冲区以处理64位整数
	int i;
	unsigned long long x;
	if (sign && (sign = xx < 0)) // 符号处理
    8020049c:	fb042783          	lw	a5,-80(s0)
    802004a0:	2781                	sext.w	a5,a5
    802004a2:	c39d                	beqz	a5,802004c8 <printint+0x46>
    802004a4:	fb843783          	ld	a5,-72(s0)
    802004a8:	93fd                	srli	a5,a5,0x3f
    802004aa:	0ff7f793          	zext.b	a5,a5
    802004ae:	faf42823          	sw	a5,-80(s0)
    802004b2:	fb042783          	lw	a5,-80(s0)
    802004b6:	2781                	sext.w	a5,a5
    802004b8:	cb81                	beqz	a5,802004c8 <printint+0x46>
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    802004ba:	fb843783          	ld	a5,-72(s0)
    802004be:	40f007b3          	neg	a5,a5
    802004c2:	fef43023          	sd	a5,-32(s0)
    802004c6:	a029                	j	802004d0 <printint+0x4e>
	else
		x = xx;
    802004c8:	fb843783          	ld	a5,-72(s0)
    802004cc:	fef43023          	sd	a5,-32(s0)

	if (base == 10 && x < 100) {
    802004d0:	fb442783          	lw	a5,-76(s0)
    802004d4:	0007871b          	sext.w	a4,a5
    802004d8:	47a9                	li	a5,10
    802004da:	02f71763          	bne	a4,a5,80200508 <printint+0x86>
    802004de:	fe043703          	ld	a4,-32(s0)
    802004e2:	06300793          	li	a5,99
    802004e6:	02e7e163          	bltu	a5,a4,80200508 <printint+0x86>
		// 使用查表法处理小数字
		consputs(small_numbers[x]);
    802004ea:	fe043783          	ld	a5,-32(s0)
    802004ee:	00279713          	slli	a4,a5,0x2
    802004f2:	00003797          	auipc	a5,0x3
    802004f6:	cae78793          	addi	a5,a5,-850 # 802031a0 <small_numbers>
    802004fa:	97ba                	add	a5,a5,a4
    802004fc:	853e                	mv	a0,a5
    802004fe:	00000097          	auipc	ra,0x0
    80200502:	f5a080e7          	jalr	-166(ra) # 80200458 <consputs>
    80200506:	a05d                	j	802005ac <printint+0x12a>
		return;
	}
	i = 0;
    80200508:	fe042623          	sw	zero,-20(s0)
	do{
		buf[i] = digits[x % base];
    8020050c:	fb442783          	lw	a5,-76(s0)
    80200510:	fe043703          	ld	a4,-32(s0)
    80200514:	02f777b3          	remu	a5,a4,a5
    80200518:	00006717          	auipc	a4,0x6
    8020051c:	ae870713          	addi	a4,a4,-1304 # 80206000 <digits.0>
    80200520:	97ba                	add	a5,a5,a4
    80200522:	0007c703          	lbu	a4,0(a5)
    80200526:	fec42783          	lw	a5,-20(s0)
    8020052a:	17c1                	addi	a5,a5,-16
    8020052c:	97a2                	add	a5,a5,s0
    8020052e:	fce78c23          	sb	a4,-40(a5)
		i++;
    80200532:	fec42783          	lw	a5,-20(s0)
    80200536:	2785                	addiw	a5,a5,1
    80200538:	fef42623          	sw	a5,-20(s0)
	}while((x/=base) !=0);
    8020053c:	fb442783          	lw	a5,-76(s0)
    80200540:	fe043703          	ld	a4,-32(s0)
    80200544:	02f757b3          	divu	a5,a4,a5
    80200548:	fef43023          	sd	a5,-32(s0)
    8020054c:	fe043783          	ld	a5,-32(s0)
    80200550:	ffd5                	bnez	a5,8020050c <printint+0x8a>
	if (sign){
    80200552:	fb042783          	lw	a5,-80(s0)
    80200556:	2781                	sext.w	a5,a5
    80200558:	cf91                	beqz	a5,80200574 <printint+0xf2>
		buf[i] = '-';
    8020055a:	fec42783          	lw	a5,-20(s0)
    8020055e:	17c1                	addi	a5,a5,-16
    80200560:	97a2                	add	a5,a5,s0
    80200562:	02d00713          	li	a4,45
    80200566:	fce78c23          	sb	a4,-40(a5)
		i++;
    8020056a:	fec42783          	lw	a5,-20(s0)
    8020056e:	2785                	addiw	a5,a5,1
    80200570:	fef42623          	sw	a5,-20(s0)
	}
	i--;
    80200574:	fec42783          	lw	a5,-20(s0)
    80200578:	37fd                	addiw	a5,a5,-1
    8020057a:	fef42623          	sw	a5,-20(s0)
	while( i>=0){
    8020057e:	a015                	j	802005a2 <printint+0x120>
		consputc(buf[i]);
    80200580:	fec42783          	lw	a5,-20(s0)
    80200584:	17c1                	addi	a5,a5,-16
    80200586:	97a2                	add	a5,a5,s0
    80200588:	fd87c783          	lbu	a5,-40(a5)
    8020058c:	2781                	sext.w	a5,a5
    8020058e:	853e                	mv	a0,a5
    80200590:	00000097          	auipc	ra,0x0
    80200594:	e9e080e7          	jalr	-354(ra) # 8020042e <consputc>
		i--;
    80200598:	fec42783          	lw	a5,-20(s0)
    8020059c:	37fd                	addiw	a5,a5,-1
    8020059e:	fef42623          	sw	a5,-20(s0)
	while( i>=0){
    802005a2:	fec42783          	lw	a5,-20(s0)
    802005a6:	2781                	sext.w	a5,a5
    802005a8:	fc07dce3          	bgez	a5,80200580 <printint+0xfe>
	}
}
    802005ac:	60a6                	ld	ra,72(sp)
    802005ae:	6406                	ld	s0,64(sp)
    802005b0:	6161                	addi	sp,sp,80
    802005b2:	8082                	ret

00000000802005b4 <printf>:
void printf(const char *fmt, ...) {
    802005b4:	7171                	addi	sp,sp,-176
    802005b6:	f486                	sd	ra,104(sp)
    802005b8:	f0a2                	sd	s0,96(sp)
    802005ba:	1880                	addi	s0,sp,112
    802005bc:	f8a43c23          	sd	a0,-104(s0)
    802005c0:	e40c                	sd	a1,8(s0)
    802005c2:	e810                	sd	a2,16(s0)
    802005c4:	ec14                	sd	a3,24(s0)
    802005c6:	f018                	sd	a4,32(s0)
    802005c8:	f41c                	sd	a5,40(s0)
    802005ca:	03043823          	sd	a6,48(s0)
    802005ce:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    802005d2:	04040793          	addi	a5,s0,64
    802005d6:	f8f43823          	sd	a5,-112(s0)
    802005da:	f9043783          	ld	a5,-112(s0)
    802005de:	fc878793          	addi	a5,a5,-56
    802005e2:	fcf43023          	sd	a5,-64(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    802005e6:	fe042623          	sw	zero,-20(s0)
    802005ea:	a671                	j	80200976 <printf+0x3c2>
        if(c != '%'){
    802005ec:	fe842783          	lw	a5,-24(s0)
    802005f0:	0007871b          	sext.w	a4,a5
    802005f4:	02500793          	li	a5,37
    802005f8:	00f70c63          	beq	a4,a5,80200610 <printf+0x5c>
            buffer_char(c);
    802005fc:	fe842783          	lw	a5,-24(s0)
    80200600:	0ff7f793          	zext.b	a5,a5
    80200604:	853e                	mv	a0,a5
    80200606:	00000097          	auipc	ra,0x0
    8020060a:	d96080e7          	jalr	-618(ra) # 8020039c <buffer_char>
            continue;
    8020060e:	aeb9                	j	8020096c <printf+0x3b8>
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    80200610:	00000097          	auipc	ra,0x0
    80200614:	d38080e7          	jalr	-712(ra) # 80200348 <flush_printf_buffer>
        c = fmt[++i] & 0xff;
    80200618:	fec42783          	lw	a5,-20(s0)
    8020061c:	2785                	addiw	a5,a5,1
    8020061e:	fef42623          	sw	a5,-20(s0)
    80200622:	fec42783          	lw	a5,-20(s0)
    80200626:	f9843703          	ld	a4,-104(s0)
    8020062a:	97ba                	add	a5,a5,a4
    8020062c:	0007c783          	lbu	a5,0(a5)
    80200630:	fef42423          	sw	a5,-24(s0)
        if(c == 0)
    80200634:	fe842783          	lw	a5,-24(s0)
    80200638:	2781                	sext.w	a5,a5
    8020063a:	34078d63          	beqz	a5,80200994 <printf+0x3e0>
            break;
            
        // 检查是否有长整型标记'l'
        int is_long = 0;
    8020063e:	fc042e23          	sw	zero,-36(s0)
        if(c == 'l') {
    80200642:	fe842783          	lw	a5,-24(s0)
    80200646:	0007871b          	sext.w	a4,a5
    8020064a:	06c00793          	li	a5,108
    8020064e:	02f71863          	bne	a4,a5,8020067e <printf+0xca>
            is_long = 1;
    80200652:	4785                	li	a5,1
    80200654:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    80200658:	fec42783          	lw	a5,-20(s0)
    8020065c:	2785                	addiw	a5,a5,1
    8020065e:	fef42623          	sw	a5,-20(s0)
    80200662:	fec42783          	lw	a5,-20(s0)
    80200666:	f9843703          	ld	a4,-104(s0)
    8020066a:	97ba                	add	a5,a5,a4
    8020066c:	0007c783          	lbu	a5,0(a5)
    80200670:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    80200674:	fe842783          	lw	a5,-24(s0)
    80200678:	2781                	sext.w	a5,a5
    8020067a:	30078f63          	beqz	a5,80200998 <printf+0x3e4>
                break;
        }
        
        switch(c){
    8020067e:	fe842783          	lw	a5,-24(s0)
    80200682:	0007871b          	sext.w	a4,a5
    80200686:	02500793          	li	a5,37
    8020068a:	2af70063          	beq	a4,a5,8020092a <printf+0x376>
    8020068e:	fe842783          	lw	a5,-24(s0)
    80200692:	0007871b          	sext.w	a4,a5
    80200696:	02500793          	li	a5,37
    8020069a:	28f74f63          	blt	a4,a5,80200938 <printf+0x384>
    8020069e:	fe842783          	lw	a5,-24(s0)
    802006a2:	0007871b          	sext.w	a4,a5
    802006a6:	07800793          	li	a5,120
    802006aa:	28e7c763          	blt	a5,a4,80200938 <printf+0x384>
    802006ae:	fe842783          	lw	a5,-24(s0)
    802006b2:	0007871b          	sext.w	a4,a5
    802006b6:	06200793          	li	a5,98
    802006ba:	26f74f63          	blt	a4,a5,80200938 <printf+0x384>
    802006be:	fe842783          	lw	a5,-24(s0)
    802006c2:	f9e7869b          	addiw	a3,a5,-98
    802006c6:	0006871b          	sext.w	a4,a3
    802006ca:	47d9                	li	a5,22
    802006cc:	26e7e663          	bltu	a5,a4,80200938 <printf+0x384>
    802006d0:	02069793          	slli	a5,a3,0x20
    802006d4:	9381                	srli	a5,a5,0x20
    802006d6:	00279713          	slli	a4,a5,0x2
    802006da:	00003797          	auipc	a5,0x3
    802006de:	c7a78793          	addi	a5,a5,-902 # 80203354 <small_numbers+0x1b4>
    802006e2:	97ba                	add	a5,a5,a4
    802006e4:	439c                	lw	a5,0(a5)
    802006e6:	0007871b          	sext.w	a4,a5
    802006ea:	00003797          	auipc	a5,0x3
    802006ee:	c6a78793          	addi	a5,a5,-918 # 80203354 <small_numbers+0x1b4>
    802006f2:	97ba                	add	a5,a5,a4
    802006f4:	8782                	jr	a5
        case 'd':
            if(is_long)
    802006f6:	fdc42783          	lw	a5,-36(s0)
    802006fa:	2781                	sext.w	a5,a5
    802006fc:	c385                	beqz	a5,8020071c <printf+0x168>
                printint(va_arg(ap, long long), 10, 1);
    802006fe:	fc043783          	ld	a5,-64(s0)
    80200702:	00878713          	addi	a4,a5,8
    80200706:	fce43023          	sd	a4,-64(s0)
    8020070a:	639c                	ld	a5,0(a5)
    8020070c:	4605                	li	a2,1
    8020070e:	45a9                	li	a1,10
    80200710:	853e                	mv	a0,a5
    80200712:	00000097          	auipc	ra,0x0
    80200716:	d70080e7          	jalr	-656(ra) # 80200482 <printint>
            else
                printint(va_arg(ap, int), 10, 1);
            break;
    8020071a:	ac89                	j	8020096c <printf+0x3b8>
                printint(va_arg(ap, int), 10, 1);
    8020071c:	fc043783          	ld	a5,-64(s0)
    80200720:	00878713          	addi	a4,a5,8
    80200724:	fce43023          	sd	a4,-64(s0)
    80200728:	439c                	lw	a5,0(a5)
    8020072a:	4605                	li	a2,1
    8020072c:	45a9                	li	a1,10
    8020072e:	853e                	mv	a0,a5
    80200730:	00000097          	auipc	ra,0x0
    80200734:	d52080e7          	jalr	-686(ra) # 80200482 <printint>
            break;
    80200738:	ac15                	j	8020096c <printf+0x3b8>
        case 'x':
            if(is_long)
    8020073a:	fdc42783          	lw	a5,-36(s0)
    8020073e:	2781                	sext.w	a5,a5
    80200740:	c385                	beqz	a5,80200760 <printf+0x1ac>
                printint(va_arg(ap, long long), 16, 0);
    80200742:	fc043783          	ld	a5,-64(s0)
    80200746:	00878713          	addi	a4,a5,8
    8020074a:	fce43023          	sd	a4,-64(s0)
    8020074e:	639c                	ld	a5,0(a5)
    80200750:	4601                	li	a2,0
    80200752:	45c1                	li	a1,16
    80200754:	853e                	mv	a0,a5
    80200756:	00000097          	auipc	ra,0x0
    8020075a:	d2c080e7          	jalr	-724(ra) # 80200482 <printint>
            else
                printint(va_arg(ap, int), 16, 0);
            break;
    8020075e:	a439                	j	8020096c <printf+0x3b8>
                printint(va_arg(ap, int), 16, 0);
    80200760:	fc043783          	ld	a5,-64(s0)
    80200764:	00878713          	addi	a4,a5,8
    80200768:	fce43023          	sd	a4,-64(s0)
    8020076c:	439c                	lw	a5,0(a5)
    8020076e:	4601                	li	a2,0
    80200770:	45c1                	li	a1,16
    80200772:	853e                	mv	a0,a5
    80200774:	00000097          	auipc	ra,0x0
    80200778:	d0e080e7          	jalr	-754(ra) # 80200482 <printint>
            break;
    8020077c:	aac5                	j	8020096c <printf+0x3b8>
        case 'u':
            if(is_long)
    8020077e:	fdc42783          	lw	a5,-36(s0)
    80200782:	2781                	sext.w	a5,a5
    80200784:	c385                	beqz	a5,802007a4 <printf+0x1f0>
                printint(va_arg(ap, unsigned long long), 10, 0);
    80200786:	fc043783          	ld	a5,-64(s0)
    8020078a:	00878713          	addi	a4,a5,8
    8020078e:	fce43023          	sd	a4,-64(s0)
    80200792:	639c                	ld	a5,0(a5)
    80200794:	4601                	li	a2,0
    80200796:	45a9                	li	a1,10
    80200798:	853e                	mv	a0,a5
    8020079a:	00000097          	auipc	ra,0x0
    8020079e:	ce8080e7          	jalr	-792(ra) # 80200482 <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0);
            break;
    802007a2:	a2e9                	j	8020096c <printf+0x3b8>
                printint(va_arg(ap, unsigned int), 10, 0);
    802007a4:	fc043783          	ld	a5,-64(s0)
    802007a8:	00878713          	addi	a4,a5,8
    802007ac:	fce43023          	sd	a4,-64(s0)
    802007b0:	439c                	lw	a5,0(a5)
    802007b2:	1782                	slli	a5,a5,0x20
    802007b4:	9381                	srli	a5,a5,0x20
    802007b6:	4601                	li	a2,0
    802007b8:	45a9                	li	a1,10
    802007ba:	853e                	mv	a0,a5
    802007bc:	00000097          	auipc	ra,0x0
    802007c0:	cc6080e7          	jalr	-826(ra) # 80200482 <printint>
            break;
    802007c4:	a265                	j	8020096c <printf+0x3b8>
        case 'c':
            consputc(va_arg(ap, int));
    802007c6:	fc043783          	ld	a5,-64(s0)
    802007ca:	00878713          	addi	a4,a5,8
    802007ce:	fce43023          	sd	a4,-64(s0)
    802007d2:	439c                	lw	a5,0(a5)
    802007d4:	853e                	mv	a0,a5
    802007d6:	00000097          	auipc	ra,0x0
    802007da:	c58080e7          	jalr	-936(ra) # 8020042e <consputc>
            break;
    802007de:	a279                	j	8020096c <printf+0x3b8>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    802007e0:	fc043783          	ld	a5,-64(s0)
    802007e4:	00878713          	addi	a4,a5,8
    802007e8:	fce43023          	sd	a4,-64(s0)
    802007ec:	639c                	ld	a5,0(a5)
    802007ee:	fef43023          	sd	a5,-32(s0)
    802007f2:	fe043783          	ld	a5,-32(s0)
    802007f6:	e799                	bnez	a5,80200804 <printf+0x250>
                s = "(null)";
    802007f8:	00003797          	auipc	a5,0x3
    802007fc:	b3878793          	addi	a5,a5,-1224 # 80203330 <small_numbers+0x190>
    80200800:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    80200804:	fe043503          	ld	a0,-32(s0)
    80200808:	00000097          	auipc	ra,0x0
    8020080c:	c50080e7          	jalr	-944(ra) # 80200458 <consputs>
            break;
    80200810:	aab1                	j	8020096c <printf+0x3b8>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    80200812:	fc043783          	ld	a5,-64(s0)
    80200816:	00878713          	addi	a4,a5,8
    8020081a:	fce43023          	sd	a4,-64(s0)
    8020081e:	639c                	ld	a5,0(a5)
    80200820:	fcf43823          	sd	a5,-48(s0)
            consputs("0x");
    80200824:	00003517          	auipc	a0,0x3
    80200828:	b1450513          	addi	a0,a0,-1260 # 80203338 <small_numbers+0x198>
    8020082c:	00000097          	auipc	ra,0x0
    80200830:	c2c080e7          	jalr	-980(ra) # 80200458 <consputs>
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    80200834:	fc042c23          	sw	zero,-40(s0)
    80200838:	a0a1                	j	80200880 <printf+0x2cc>
                int shift = (15 - i) * 4;
    8020083a:	47bd                	li	a5,15
    8020083c:	fd842703          	lw	a4,-40(s0)
    80200840:	9f99                	subw	a5,a5,a4
    80200842:	2781                	sext.w	a5,a5
    80200844:	0027979b          	slliw	a5,a5,0x2
    80200848:	fcf42623          	sw	a5,-52(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    8020084c:	fcc42783          	lw	a5,-52(s0)
    80200850:	873e                	mv	a4,a5
    80200852:	fd043783          	ld	a5,-48(s0)
    80200856:	00e7d7b3          	srl	a5,a5,a4
    8020085a:	8bbd                	andi	a5,a5,15
    8020085c:	00003717          	auipc	a4,0x3
    80200860:	ae470713          	addi	a4,a4,-1308 # 80203340 <small_numbers+0x1a0>
    80200864:	97ba                	add	a5,a5,a4
    80200866:	0007c703          	lbu	a4,0(a5)
    8020086a:	fd842783          	lw	a5,-40(s0)
    8020086e:	17c1                	addi	a5,a5,-16
    80200870:	97a2                	add	a5,a5,s0
    80200872:	fae78c23          	sb	a4,-72(a5)
            for (i = 0; i < 16; i++) {
    80200876:	fd842783          	lw	a5,-40(s0)
    8020087a:	2785                	addiw	a5,a5,1
    8020087c:	fcf42c23          	sw	a5,-40(s0)
    80200880:	fd842783          	lw	a5,-40(s0)
    80200884:	0007871b          	sext.w	a4,a5
    80200888:	47bd                	li	a5,15
    8020088a:	fae7d8e3          	bge	a5,a4,8020083a <printf+0x286>
            }
            buf[16] = '\0';
    8020088e:	fa040c23          	sb	zero,-72(s0)
            consputs(buf);
    80200892:	fa840793          	addi	a5,s0,-88
    80200896:	853e                	mv	a0,a5
    80200898:	00000097          	auipc	ra,0x0
    8020089c:	bc0080e7          	jalr	-1088(ra) # 80200458 <consputs>
            break;
    802008a0:	a0f1                	j	8020096c <printf+0x3b8>
        case 'b':
            if(is_long)
    802008a2:	fdc42783          	lw	a5,-36(s0)
    802008a6:	2781                	sext.w	a5,a5
    802008a8:	c385                	beqz	a5,802008c8 <printf+0x314>
                printint(va_arg(ap, long long), 2, 0);
    802008aa:	fc043783          	ld	a5,-64(s0)
    802008ae:	00878713          	addi	a4,a5,8
    802008b2:	fce43023          	sd	a4,-64(s0)
    802008b6:	639c                	ld	a5,0(a5)
    802008b8:	4601                	li	a2,0
    802008ba:	4589                	li	a1,2
    802008bc:	853e                	mv	a0,a5
    802008be:	00000097          	auipc	ra,0x0
    802008c2:	bc4080e7          	jalr	-1084(ra) # 80200482 <printint>
            else
                printint(va_arg(ap, int), 2, 0);
            break;
    802008c6:	a05d                	j	8020096c <printf+0x3b8>
                printint(va_arg(ap, int), 2, 0);
    802008c8:	fc043783          	ld	a5,-64(s0)
    802008cc:	00878713          	addi	a4,a5,8
    802008d0:	fce43023          	sd	a4,-64(s0)
    802008d4:	439c                	lw	a5,0(a5)
    802008d6:	4601                	li	a2,0
    802008d8:	4589                	li	a1,2
    802008da:	853e                	mv	a0,a5
    802008dc:	00000097          	auipc	ra,0x0
    802008e0:	ba6080e7          	jalr	-1114(ra) # 80200482 <printint>
            break;
    802008e4:	a061                	j	8020096c <printf+0x3b8>
        case 'o':
            if(is_long)
    802008e6:	fdc42783          	lw	a5,-36(s0)
    802008ea:	2781                	sext.w	a5,a5
    802008ec:	c385                	beqz	a5,8020090c <printf+0x358>
                printint(va_arg(ap, long long), 8, 0);
    802008ee:	fc043783          	ld	a5,-64(s0)
    802008f2:	00878713          	addi	a4,a5,8
    802008f6:	fce43023          	sd	a4,-64(s0)
    802008fa:	639c                	ld	a5,0(a5)
    802008fc:	4601                	li	a2,0
    802008fe:	45a1                	li	a1,8
    80200900:	853e                	mv	a0,a5
    80200902:	00000097          	auipc	ra,0x0
    80200906:	b80080e7          	jalr	-1152(ra) # 80200482 <printint>
            else
                printint(va_arg(ap, int), 8, 0);
            break;
    8020090a:	a08d                	j	8020096c <printf+0x3b8>
                printint(va_arg(ap, int), 8, 0);
    8020090c:	fc043783          	ld	a5,-64(s0)
    80200910:	00878713          	addi	a4,a5,8
    80200914:	fce43023          	sd	a4,-64(s0)
    80200918:	439c                	lw	a5,0(a5)
    8020091a:	4601                	li	a2,0
    8020091c:	45a1                	li	a1,8
    8020091e:	853e                	mv	a0,a5
    80200920:	00000097          	auipc	ra,0x0
    80200924:	b62080e7          	jalr	-1182(ra) # 80200482 <printint>
            break;
    80200928:	a091                	j	8020096c <printf+0x3b8>
        case '%':
            buffer_char('%');
    8020092a:	02500513          	li	a0,37
    8020092e:	00000097          	auipc	ra,0x0
    80200932:	a6e080e7          	jalr	-1426(ra) # 8020039c <buffer_char>
            break;
    80200936:	a81d                	j	8020096c <printf+0x3b8>
        default:
            buffer_char('%');
    80200938:	02500513          	li	a0,37
    8020093c:	00000097          	auipc	ra,0x0
    80200940:	a60080e7          	jalr	-1440(ra) # 8020039c <buffer_char>
            if(is_long) buffer_char('l');
    80200944:	fdc42783          	lw	a5,-36(s0)
    80200948:	2781                	sext.w	a5,a5
    8020094a:	c799                	beqz	a5,80200958 <printf+0x3a4>
    8020094c:	06c00513          	li	a0,108
    80200950:	00000097          	auipc	ra,0x0
    80200954:	a4c080e7          	jalr	-1460(ra) # 8020039c <buffer_char>
            buffer_char(c);
    80200958:	fe842783          	lw	a5,-24(s0)
    8020095c:	0ff7f793          	zext.b	a5,a5
    80200960:	853e                	mv	a0,a5
    80200962:	00000097          	auipc	ra,0x0
    80200966:	a3a080e7          	jalr	-1478(ra) # 8020039c <buffer_char>
            break;
    8020096a:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8020096c:	fec42783          	lw	a5,-20(s0)
    80200970:	2785                	addiw	a5,a5,1
    80200972:	fef42623          	sw	a5,-20(s0)
    80200976:	fec42783          	lw	a5,-20(s0)
    8020097a:	f9843703          	ld	a4,-104(s0)
    8020097e:	97ba                	add	a5,a5,a4
    80200980:	0007c783          	lbu	a5,0(a5)
    80200984:	fef42423          	sw	a5,-24(s0)
    80200988:	fe842783          	lw	a5,-24(s0)
    8020098c:	2781                	sext.w	a5,a5
    8020098e:	c4079fe3          	bnez	a5,802005ec <printf+0x38>
    80200992:	a021                	j	8020099a <printf+0x3e6>
            break;
    80200994:	0001                	nop
    80200996:	a011                	j	8020099a <printf+0x3e6>
                break;
    80200998:	0001                	nop
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    8020099a:	00000097          	auipc	ra,0x0
    8020099e:	9ae080e7          	jalr	-1618(ra) # 80200348 <flush_printf_buffer>
    va_end(ap);
}
    802009a2:	0001                	nop
    802009a4:	70a6                	ld	ra,104(sp)
    802009a6:	7406                	ld	s0,96(sp)
    802009a8:	614d                	addi	sp,sp,176
    802009aa:	8082                	ret

00000000802009ac <clear_screen>:
// 清屏功能
void clear_screen(void) {
    802009ac:	1141                	addi	sp,sp,-16
    802009ae:	e406                	sd	ra,8(sp)
    802009b0:	e022                	sd	s0,0(sp)
    802009b2:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    802009b4:	00003517          	auipc	a0,0x3
    802009b8:	9fc50513          	addi	a0,a0,-1540 # 802033b0 <small_numbers+0x210>
    802009bc:	00000097          	auipc	ra,0x0
    802009c0:	82a080e7          	jalr	-2006(ra) # 802001e6 <uart_puts>
	uart_puts(CURSOR_HOME);
    802009c4:	00003517          	auipc	a0,0x3
    802009c8:	9f450513          	addi	a0,a0,-1548 # 802033b8 <small_numbers+0x218>
    802009cc:	00000097          	auipc	ra,0x0
    802009d0:	81a080e7          	jalr	-2022(ra) # 802001e6 <uart_puts>
}
    802009d4:	0001                	nop
    802009d6:	60a2                	ld	ra,8(sp)
    802009d8:	6402                	ld	s0,0(sp)
    802009da:	0141                	addi	sp,sp,16
    802009dc:	8082                	ret

00000000802009de <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    802009de:	1101                	addi	sp,sp,-32
    802009e0:	ec06                	sd	ra,24(sp)
    802009e2:	e822                	sd	s0,16(sp)
    802009e4:	1000                	addi	s0,sp,32
    802009e6:	87aa                	mv	a5,a0
    802009e8:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    802009ec:	fec42783          	lw	a5,-20(s0)
    802009f0:	2781                	sext.w	a5,a5
    802009f2:	02f05d63          	blez	a5,80200a2c <cursor_up+0x4e>
    consputc('\033');
    802009f6:	456d                	li	a0,27
    802009f8:	00000097          	auipc	ra,0x0
    802009fc:	a36080e7          	jalr	-1482(ra) # 8020042e <consputc>
    consputc('[');
    80200a00:	05b00513          	li	a0,91
    80200a04:	00000097          	auipc	ra,0x0
    80200a08:	a2a080e7          	jalr	-1494(ra) # 8020042e <consputc>
    printint(lines, 10, 0);
    80200a0c:	fec42783          	lw	a5,-20(s0)
    80200a10:	4601                	li	a2,0
    80200a12:	45a9                	li	a1,10
    80200a14:	853e                	mv	a0,a5
    80200a16:	00000097          	auipc	ra,0x0
    80200a1a:	a6c080e7          	jalr	-1428(ra) # 80200482 <printint>
    consputc('A');
    80200a1e:	04100513          	li	a0,65
    80200a22:	00000097          	auipc	ra,0x0
    80200a26:	a0c080e7          	jalr	-1524(ra) # 8020042e <consputc>
    80200a2a:	a011                	j	80200a2e <cursor_up+0x50>
    if (lines <= 0) return;
    80200a2c:	0001                	nop
}
    80200a2e:	60e2                	ld	ra,24(sp)
    80200a30:	6442                	ld	s0,16(sp)
    80200a32:	6105                	addi	sp,sp,32
    80200a34:	8082                	ret

0000000080200a36 <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    80200a36:	1101                	addi	sp,sp,-32
    80200a38:	ec06                	sd	ra,24(sp)
    80200a3a:	e822                	sd	s0,16(sp)
    80200a3c:	1000                	addi	s0,sp,32
    80200a3e:	87aa                	mv	a5,a0
    80200a40:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    80200a44:	fec42783          	lw	a5,-20(s0)
    80200a48:	2781                	sext.w	a5,a5
    80200a4a:	02f05d63          	blez	a5,80200a84 <cursor_down+0x4e>
    consputc('\033');
    80200a4e:	456d                	li	a0,27
    80200a50:	00000097          	auipc	ra,0x0
    80200a54:	9de080e7          	jalr	-1570(ra) # 8020042e <consputc>
    consputc('[');
    80200a58:	05b00513          	li	a0,91
    80200a5c:	00000097          	auipc	ra,0x0
    80200a60:	9d2080e7          	jalr	-1582(ra) # 8020042e <consputc>
    printint(lines, 10, 0);
    80200a64:	fec42783          	lw	a5,-20(s0)
    80200a68:	4601                	li	a2,0
    80200a6a:	45a9                	li	a1,10
    80200a6c:	853e                	mv	a0,a5
    80200a6e:	00000097          	auipc	ra,0x0
    80200a72:	a14080e7          	jalr	-1516(ra) # 80200482 <printint>
    consputc('B');
    80200a76:	04200513          	li	a0,66
    80200a7a:	00000097          	auipc	ra,0x0
    80200a7e:	9b4080e7          	jalr	-1612(ra) # 8020042e <consputc>
    80200a82:	a011                	j	80200a86 <cursor_down+0x50>
    if (lines <= 0) return;
    80200a84:	0001                	nop
}
    80200a86:	60e2                	ld	ra,24(sp)
    80200a88:	6442                	ld	s0,16(sp)
    80200a8a:	6105                	addi	sp,sp,32
    80200a8c:	8082                	ret

0000000080200a8e <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    80200a8e:	1101                	addi	sp,sp,-32
    80200a90:	ec06                	sd	ra,24(sp)
    80200a92:	e822                	sd	s0,16(sp)
    80200a94:	1000                	addi	s0,sp,32
    80200a96:	87aa                	mv	a5,a0
    80200a98:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80200a9c:	fec42783          	lw	a5,-20(s0)
    80200aa0:	2781                	sext.w	a5,a5
    80200aa2:	02f05d63          	blez	a5,80200adc <cursor_right+0x4e>
    consputc('\033');
    80200aa6:	456d                	li	a0,27
    80200aa8:	00000097          	auipc	ra,0x0
    80200aac:	986080e7          	jalr	-1658(ra) # 8020042e <consputc>
    consputc('[');
    80200ab0:	05b00513          	li	a0,91
    80200ab4:	00000097          	auipc	ra,0x0
    80200ab8:	97a080e7          	jalr	-1670(ra) # 8020042e <consputc>
    printint(cols, 10, 0);
    80200abc:	fec42783          	lw	a5,-20(s0)
    80200ac0:	4601                	li	a2,0
    80200ac2:	45a9                	li	a1,10
    80200ac4:	853e                	mv	a0,a5
    80200ac6:	00000097          	auipc	ra,0x0
    80200aca:	9bc080e7          	jalr	-1604(ra) # 80200482 <printint>
    consputc('C');
    80200ace:	04300513          	li	a0,67
    80200ad2:	00000097          	auipc	ra,0x0
    80200ad6:	95c080e7          	jalr	-1700(ra) # 8020042e <consputc>
    80200ada:	a011                	j	80200ade <cursor_right+0x50>
    if (cols <= 0) return;
    80200adc:	0001                	nop
}
    80200ade:	60e2                	ld	ra,24(sp)
    80200ae0:	6442                	ld	s0,16(sp)
    80200ae2:	6105                	addi	sp,sp,32
    80200ae4:	8082                	ret

0000000080200ae6 <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    80200ae6:	1101                	addi	sp,sp,-32
    80200ae8:	ec06                	sd	ra,24(sp)
    80200aea:	e822                	sd	s0,16(sp)
    80200aec:	1000                	addi	s0,sp,32
    80200aee:	87aa                	mv	a5,a0
    80200af0:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80200af4:	fec42783          	lw	a5,-20(s0)
    80200af8:	2781                	sext.w	a5,a5
    80200afa:	02f05d63          	blez	a5,80200b34 <cursor_left+0x4e>
    consputc('\033');
    80200afe:	456d                	li	a0,27
    80200b00:	00000097          	auipc	ra,0x0
    80200b04:	92e080e7          	jalr	-1746(ra) # 8020042e <consputc>
    consputc('[');
    80200b08:	05b00513          	li	a0,91
    80200b0c:	00000097          	auipc	ra,0x0
    80200b10:	922080e7          	jalr	-1758(ra) # 8020042e <consputc>
    printint(cols, 10, 0);
    80200b14:	fec42783          	lw	a5,-20(s0)
    80200b18:	4601                	li	a2,0
    80200b1a:	45a9                	li	a1,10
    80200b1c:	853e                	mv	a0,a5
    80200b1e:	00000097          	auipc	ra,0x0
    80200b22:	964080e7          	jalr	-1692(ra) # 80200482 <printint>
    consputc('D');
    80200b26:	04400513          	li	a0,68
    80200b2a:	00000097          	auipc	ra,0x0
    80200b2e:	904080e7          	jalr	-1788(ra) # 8020042e <consputc>
    80200b32:	a011                	j	80200b36 <cursor_left+0x50>
    if (cols <= 0) return;
    80200b34:	0001                	nop
}
    80200b36:	60e2                	ld	ra,24(sp)
    80200b38:	6442                	ld	s0,16(sp)
    80200b3a:	6105                	addi	sp,sp,32
    80200b3c:	8082                	ret

0000000080200b3e <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    80200b3e:	1141                	addi	sp,sp,-16
    80200b40:	e406                	sd	ra,8(sp)
    80200b42:	e022                	sd	s0,0(sp)
    80200b44:	0800                	addi	s0,sp,16
    consputc('\033');
    80200b46:	456d                	li	a0,27
    80200b48:	00000097          	auipc	ra,0x0
    80200b4c:	8e6080e7          	jalr	-1818(ra) # 8020042e <consputc>
    consputc('[');
    80200b50:	05b00513          	li	a0,91
    80200b54:	00000097          	auipc	ra,0x0
    80200b58:	8da080e7          	jalr	-1830(ra) # 8020042e <consputc>
    consputc('s');
    80200b5c:	07300513          	li	a0,115
    80200b60:	00000097          	auipc	ra,0x0
    80200b64:	8ce080e7          	jalr	-1842(ra) # 8020042e <consputc>
}
    80200b68:	0001                	nop
    80200b6a:	60a2                	ld	ra,8(sp)
    80200b6c:	6402                	ld	s0,0(sp)
    80200b6e:	0141                	addi	sp,sp,16
    80200b70:	8082                	ret

0000000080200b72 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    80200b72:	1141                	addi	sp,sp,-16
    80200b74:	e406                	sd	ra,8(sp)
    80200b76:	e022                	sd	s0,0(sp)
    80200b78:	0800                	addi	s0,sp,16
    consputc('\033');
    80200b7a:	456d                	li	a0,27
    80200b7c:	00000097          	auipc	ra,0x0
    80200b80:	8b2080e7          	jalr	-1870(ra) # 8020042e <consputc>
    consputc('[');
    80200b84:	05b00513          	li	a0,91
    80200b88:	00000097          	auipc	ra,0x0
    80200b8c:	8a6080e7          	jalr	-1882(ra) # 8020042e <consputc>
    consputc('u');
    80200b90:	07500513          	li	a0,117
    80200b94:	00000097          	auipc	ra,0x0
    80200b98:	89a080e7          	jalr	-1894(ra) # 8020042e <consputc>
}
    80200b9c:	0001                	nop
    80200b9e:	60a2                	ld	ra,8(sp)
    80200ba0:	6402                	ld	s0,0(sp)
    80200ba2:	0141                	addi	sp,sp,16
    80200ba4:	8082                	ret

0000000080200ba6 <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    80200ba6:	1101                	addi	sp,sp,-32
    80200ba8:	ec06                	sd	ra,24(sp)
    80200baa:	e822                	sd	s0,16(sp)
    80200bac:	1000                	addi	s0,sp,32
    80200bae:	87aa                	mv	a5,a0
    80200bb0:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    80200bb4:	fec42783          	lw	a5,-20(s0)
    80200bb8:	2781                	sext.w	a5,a5
    80200bba:	00f04563          	bgtz	a5,80200bc4 <cursor_to_column+0x1e>
    80200bbe:	4785                	li	a5,1
    80200bc0:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    80200bc4:	456d                	li	a0,27
    80200bc6:	00000097          	auipc	ra,0x0
    80200bca:	868080e7          	jalr	-1944(ra) # 8020042e <consputc>
    consputc('[');
    80200bce:	05b00513          	li	a0,91
    80200bd2:	00000097          	auipc	ra,0x0
    80200bd6:	85c080e7          	jalr	-1956(ra) # 8020042e <consputc>
    printint(col, 10, 0);
    80200bda:	fec42783          	lw	a5,-20(s0)
    80200bde:	4601                	li	a2,0
    80200be0:	45a9                	li	a1,10
    80200be2:	853e                	mv	a0,a5
    80200be4:	00000097          	auipc	ra,0x0
    80200be8:	89e080e7          	jalr	-1890(ra) # 80200482 <printint>
    consputc('G');
    80200bec:	04700513          	li	a0,71
    80200bf0:	00000097          	auipc	ra,0x0
    80200bf4:	83e080e7          	jalr	-1986(ra) # 8020042e <consputc>
}
    80200bf8:	0001                	nop
    80200bfa:	60e2                	ld	ra,24(sp)
    80200bfc:	6442                	ld	s0,16(sp)
    80200bfe:	6105                	addi	sp,sp,32
    80200c00:	8082                	ret

0000000080200c02 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80200c02:	1101                	addi	sp,sp,-32
    80200c04:	ec06                	sd	ra,24(sp)
    80200c06:	e822                	sd	s0,16(sp)
    80200c08:	1000                	addi	s0,sp,32
    80200c0a:	87aa                	mv	a5,a0
    80200c0c:	872e                	mv	a4,a1
    80200c0e:	fef42623          	sw	a5,-20(s0)
    80200c12:	87ba                	mv	a5,a4
    80200c14:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    80200c18:	456d                	li	a0,27
    80200c1a:	00000097          	auipc	ra,0x0
    80200c1e:	814080e7          	jalr	-2028(ra) # 8020042e <consputc>
    consputc('[');
    80200c22:	05b00513          	li	a0,91
    80200c26:	00000097          	auipc	ra,0x0
    80200c2a:	808080e7          	jalr	-2040(ra) # 8020042e <consputc>
    printint(row, 10, 0);
    80200c2e:	fec42783          	lw	a5,-20(s0)
    80200c32:	4601                	li	a2,0
    80200c34:	45a9                	li	a1,10
    80200c36:	853e                	mv	a0,a5
    80200c38:	00000097          	auipc	ra,0x0
    80200c3c:	84a080e7          	jalr	-1974(ra) # 80200482 <printint>
    consputc(';');
    80200c40:	03b00513          	li	a0,59
    80200c44:	fffff097          	auipc	ra,0xfffff
    80200c48:	7ea080e7          	jalr	2026(ra) # 8020042e <consputc>
    printint(col, 10, 0);
    80200c4c:	fe842783          	lw	a5,-24(s0)
    80200c50:	4601                	li	a2,0
    80200c52:	45a9                	li	a1,10
    80200c54:	853e                	mv	a0,a5
    80200c56:	00000097          	auipc	ra,0x0
    80200c5a:	82c080e7          	jalr	-2004(ra) # 80200482 <printint>
    consputc('H');
    80200c5e:	04800513          	li	a0,72
    80200c62:	fffff097          	auipc	ra,0xfffff
    80200c66:	7cc080e7          	jalr	1996(ra) # 8020042e <consputc>
}
    80200c6a:	0001                	nop
    80200c6c:	60e2                	ld	ra,24(sp)
    80200c6e:	6442                	ld	s0,16(sp)
    80200c70:	6105                	addi	sp,sp,32
    80200c72:	8082                	ret

0000000080200c74 <reset_color>:
// 颜色控制
void reset_color(void) {
    80200c74:	1141                	addi	sp,sp,-16
    80200c76:	e406                	sd	ra,8(sp)
    80200c78:	e022                	sd	s0,0(sp)
    80200c7a:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    80200c7c:	00002517          	auipc	a0,0x2
    80200c80:	74450513          	addi	a0,a0,1860 # 802033c0 <small_numbers+0x220>
    80200c84:	fffff097          	auipc	ra,0xfffff
    80200c88:	562080e7          	jalr	1378(ra) # 802001e6 <uart_puts>
}
    80200c8c:	0001                	nop
    80200c8e:	60a2                	ld	ra,8(sp)
    80200c90:	6402                	ld	s0,0(sp)
    80200c92:	0141                	addi	sp,sp,16
    80200c94:	8082                	ret

0000000080200c96 <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    80200c96:	1101                	addi	sp,sp,-32
    80200c98:	ec06                	sd	ra,24(sp)
    80200c9a:	e822                	sd	s0,16(sp)
    80200c9c:	1000                	addi	s0,sp,32
    80200c9e:	87aa                	mv	a5,a0
    80200ca0:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    80200ca4:	fec42783          	lw	a5,-20(s0)
    80200ca8:	0007871b          	sext.w	a4,a5
    80200cac:	47f5                	li	a5,29
    80200cae:	04e7d563          	bge	a5,a4,80200cf8 <set_fg_color+0x62>
    80200cb2:	fec42783          	lw	a5,-20(s0)
    80200cb6:	0007871b          	sext.w	a4,a5
    80200cba:	02500793          	li	a5,37
    80200cbe:	02e7cd63          	blt	a5,a4,80200cf8 <set_fg_color+0x62>
	consputc('\033');
    80200cc2:	456d                	li	a0,27
    80200cc4:	fffff097          	auipc	ra,0xfffff
    80200cc8:	76a080e7          	jalr	1898(ra) # 8020042e <consputc>
	consputc('[');
    80200ccc:	05b00513          	li	a0,91
    80200cd0:	fffff097          	auipc	ra,0xfffff
    80200cd4:	75e080e7          	jalr	1886(ra) # 8020042e <consputc>
	printint(color, 10, 0);
    80200cd8:	fec42783          	lw	a5,-20(s0)
    80200cdc:	4601                	li	a2,0
    80200cde:	45a9                	li	a1,10
    80200ce0:	853e                	mv	a0,a5
    80200ce2:	fffff097          	auipc	ra,0xfffff
    80200ce6:	7a0080e7          	jalr	1952(ra) # 80200482 <printint>
	consputc('m');
    80200cea:	06d00513          	li	a0,109
    80200cee:	fffff097          	auipc	ra,0xfffff
    80200cf2:	740080e7          	jalr	1856(ra) # 8020042e <consputc>
    80200cf6:	a011                	j	80200cfa <set_fg_color+0x64>
	if (color < 30 || color > 37) return; // 支持30-37
    80200cf8:	0001                	nop
}
    80200cfa:	60e2                	ld	ra,24(sp)
    80200cfc:	6442                	ld	s0,16(sp)
    80200cfe:	6105                	addi	sp,sp,32
    80200d00:	8082                	ret

0000000080200d02 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    80200d02:	1101                	addi	sp,sp,-32
    80200d04:	ec06                	sd	ra,24(sp)
    80200d06:	e822                	sd	s0,16(sp)
    80200d08:	1000                	addi	s0,sp,32
    80200d0a:	87aa                	mv	a5,a0
    80200d0c:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    80200d10:	fec42783          	lw	a5,-20(s0)
    80200d14:	0007871b          	sext.w	a4,a5
    80200d18:	02700793          	li	a5,39
    80200d1c:	04e7d563          	bge	a5,a4,80200d66 <set_bg_color+0x64>
    80200d20:	fec42783          	lw	a5,-20(s0)
    80200d24:	0007871b          	sext.w	a4,a5
    80200d28:	02f00793          	li	a5,47
    80200d2c:	02e7cd63          	blt	a5,a4,80200d66 <set_bg_color+0x64>
	consputc('\033');
    80200d30:	456d                	li	a0,27
    80200d32:	fffff097          	auipc	ra,0xfffff
    80200d36:	6fc080e7          	jalr	1788(ra) # 8020042e <consputc>
	consputc('[');
    80200d3a:	05b00513          	li	a0,91
    80200d3e:	fffff097          	auipc	ra,0xfffff
    80200d42:	6f0080e7          	jalr	1776(ra) # 8020042e <consputc>
	printint(color, 10, 0);
    80200d46:	fec42783          	lw	a5,-20(s0)
    80200d4a:	4601                	li	a2,0
    80200d4c:	45a9                	li	a1,10
    80200d4e:	853e                	mv	a0,a5
    80200d50:	fffff097          	auipc	ra,0xfffff
    80200d54:	732080e7          	jalr	1842(ra) # 80200482 <printint>
	consputc('m');
    80200d58:	06d00513          	li	a0,109
    80200d5c:	fffff097          	auipc	ra,0xfffff
    80200d60:	6d2080e7          	jalr	1746(ra) # 8020042e <consputc>
    80200d64:	a011                	j	80200d68 <set_bg_color+0x66>
	if (color < 40 || color > 47) return; // 支持40-47
    80200d66:	0001                	nop
}
    80200d68:	60e2                	ld	ra,24(sp)
    80200d6a:	6442                	ld	s0,16(sp)
    80200d6c:	6105                	addi	sp,sp,32
    80200d6e:	8082                	ret

0000000080200d70 <color_red>:
// 简易文字颜色
void color_red(void) {
    80200d70:	1141                	addi	sp,sp,-16
    80200d72:	e406                	sd	ra,8(sp)
    80200d74:	e022                	sd	s0,0(sp)
    80200d76:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    80200d78:	457d                	li	a0,31
    80200d7a:	00000097          	auipc	ra,0x0
    80200d7e:	f1c080e7          	jalr	-228(ra) # 80200c96 <set_fg_color>
}
    80200d82:	0001                	nop
    80200d84:	60a2                	ld	ra,8(sp)
    80200d86:	6402                	ld	s0,0(sp)
    80200d88:	0141                	addi	sp,sp,16
    80200d8a:	8082                	ret

0000000080200d8c <color_green>:
void color_green(void) {
    80200d8c:	1141                	addi	sp,sp,-16
    80200d8e:	e406                	sd	ra,8(sp)
    80200d90:	e022                	sd	s0,0(sp)
    80200d92:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    80200d94:	02000513          	li	a0,32
    80200d98:	00000097          	auipc	ra,0x0
    80200d9c:	efe080e7          	jalr	-258(ra) # 80200c96 <set_fg_color>
}
    80200da0:	0001                	nop
    80200da2:	60a2                	ld	ra,8(sp)
    80200da4:	6402                	ld	s0,0(sp)
    80200da6:	0141                	addi	sp,sp,16
    80200da8:	8082                	ret

0000000080200daa <color_yellow>:
void color_yellow(void) {
    80200daa:	1141                	addi	sp,sp,-16
    80200dac:	e406                	sd	ra,8(sp)
    80200dae:	e022                	sd	s0,0(sp)
    80200db0:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    80200db2:	02100513          	li	a0,33
    80200db6:	00000097          	auipc	ra,0x0
    80200dba:	ee0080e7          	jalr	-288(ra) # 80200c96 <set_fg_color>
}
    80200dbe:	0001                	nop
    80200dc0:	60a2                	ld	ra,8(sp)
    80200dc2:	6402                	ld	s0,0(sp)
    80200dc4:	0141                	addi	sp,sp,16
    80200dc6:	8082                	ret

0000000080200dc8 <color_blue>:
void color_blue(void) {
    80200dc8:	1141                	addi	sp,sp,-16
    80200dca:	e406                	sd	ra,8(sp)
    80200dcc:	e022                	sd	s0,0(sp)
    80200dce:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    80200dd0:	02200513          	li	a0,34
    80200dd4:	00000097          	auipc	ra,0x0
    80200dd8:	ec2080e7          	jalr	-318(ra) # 80200c96 <set_fg_color>
}
    80200ddc:	0001                	nop
    80200dde:	60a2                	ld	ra,8(sp)
    80200de0:	6402                	ld	s0,0(sp)
    80200de2:	0141                	addi	sp,sp,16
    80200de4:	8082                	ret

0000000080200de6 <color_purple>:
void color_purple(void) {
    80200de6:	1141                	addi	sp,sp,-16
    80200de8:	e406                	sd	ra,8(sp)
    80200dea:	e022                	sd	s0,0(sp)
    80200dec:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80200dee:	02300513          	li	a0,35
    80200df2:	00000097          	auipc	ra,0x0
    80200df6:	ea4080e7          	jalr	-348(ra) # 80200c96 <set_fg_color>
}
    80200dfa:	0001                	nop
    80200dfc:	60a2                	ld	ra,8(sp)
    80200dfe:	6402                	ld	s0,0(sp)
    80200e00:	0141                	addi	sp,sp,16
    80200e02:	8082                	ret

0000000080200e04 <color_cyan>:
void color_cyan(void) {
    80200e04:	1141                	addi	sp,sp,-16
    80200e06:	e406                	sd	ra,8(sp)
    80200e08:	e022                	sd	s0,0(sp)
    80200e0a:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    80200e0c:	02400513          	li	a0,36
    80200e10:	00000097          	auipc	ra,0x0
    80200e14:	e86080e7          	jalr	-378(ra) # 80200c96 <set_fg_color>
}
    80200e18:	0001                	nop
    80200e1a:	60a2                	ld	ra,8(sp)
    80200e1c:	6402                	ld	s0,0(sp)
    80200e1e:	0141                	addi	sp,sp,16
    80200e20:	8082                	ret

0000000080200e22 <color_reverse>:
void color_reverse(void){
    80200e22:	1141                	addi	sp,sp,-16
    80200e24:	e406                	sd	ra,8(sp)
    80200e26:	e022                	sd	s0,0(sp)
    80200e28:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    80200e2a:	02500513          	li	a0,37
    80200e2e:	00000097          	auipc	ra,0x0
    80200e32:	e68080e7          	jalr	-408(ra) # 80200c96 <set_fg_color>
}
    80200e36:	0001                	nop
    80200e38:	60a2                	ld	ra,8(sp)
    80200e3a:	6402                	ld	s0,0(sp)
    80200e3c:	0141                	addi	sp,sp,16
    80200e3e:	8082                	ret

0000000080200e40 <set_color>:
void set_color(int fg, int bg) {
    80200e40:	1101                	addi	sp,sp,-32
    80200e42:	ec06                	sd	ra,24(sp)
    80200e44:	e822                	sd	s0,16(sp)
    80200e46:	1000                	addi	s0,sp,32
    80200e48:	87aa                	mv	a5,a0
    80200e4a:	872e                	mv	a4,a1
    80200e4c:	fef42623          	sw	a5,-20(s0)
    80200e50:	87ba                	mv	a5,a4
    80200e52:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    80200e56:	fe842783          	lw	a5,-24(s0)
    80200e5a:	853e                	mv	a0,a5
    80200e5c:	00000097          	auipc	ra,0x0
    80200e60:	ea6080e7          	jalr	-346(ra) # 80200d02 <set_bg_color>
	set_fg_color(fg);
    80200e64:	fec42783          	lw	a5,-20(s0)
    80200e68:	853e                	mv	a0,a5
    80200e6a:	00000097          	auipc	ra,0x0
    80200e6e:	e2c080e7          	jalr	-468(ra) # 80200c96 <set_fg_color>
}
    80200e72:	0001                	nop
    80200e74:	60e2                	ld	ra,24(sp)
    80200e76:	6442                	ld	s0,16(sp)
    80200e78:	6105                	addi	sp,sp,32
    80200e7a:	8082                	ret

0000000080200e7c <clear_line>:
void clear_line(){
    80200e7c:	1141                	addi	sp,sp,-16
    80200e7e:	e406                	sd	ra,8(sp)
    80200e80:	e022                	sd	s0,0(sp)
    80200e82:	0800                	addi	s0,sp,16
	consputc('\033');
    80200e84:	456d                	li	a0,27
    80200e86:	fffff097          	auipc	ra,0xfffff
    80200e8a:	5a8080e7          	jalr	1448(ra) # 8020042e <consputc>
	consputc('[');
    80200e8e:	05b00513          	li	a0,91
    80200e92:	fffff097          	auipc	ra,0xfffff
    80200e96:	59c080e7          	jalr	1436(ra) # 8020042e <consputc>
	consputc('2');
    80200e9a:	03200513          	li	a0,50
    80200e9e:	fffff097          	auipc	ra,0xfffff
    80200ea2:	590080e7          	jalr	1424(ra) # 8020042e <consputc>
	consputc('K');
    80200ea6:	04b00513          	li	a0,75
    80200eaa:	fffff097          	auipc	ra,0xfffff
    80200eae:	584080e7          	jalr	1412(ra) # 8020042e <consputc>
}
    80200eb2:	0001                	nop
    80200eb4:	60a2                	ld	ra,8(sp)
    80200eb6:	6402                	ld	s0,0(sp)
    80200eb8:	0141                	addi	sp,sp,16
    80200eba:	8082                	ret

0000000080200ebc <panic>:

void panic(const char *msg) {
    80200ebc:	1101                	addi	sp,sp,-32
    80200ebe:	ec06                	sd	ra,24(sp)
    80200ec0:	e822                	sd	s0,16(sp)
    80200ec2:	1000                	addi	s0,sp,32
    80200ec4:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    80200ec8:	00000097          	auipc	ra,0x0
    80200ecc:	ea8080e7          	jalr	-344(ra) # 80200d70 <color_red>
	printf("panic: %s\n", msg);
    80200ed0:	fe843583          	ld	a1,-24(s0)
    80200ed4:	00002517          	auipc	a0,0x2
    80200ed8:	4f450513          	addi	a0,a0,1268 # 802033c8 <small_numbers+0x228>
    80200edc:	fffff097          	auipc	ra,0xfffff
    80200ee0:	6d8080e7          	jalr	1752(ra) # 802005b4 <printf>
	reset_color();
    80200ee4:	00000097          	auipc	ra,0x0
    80200ee8:	d90080e7          	jalr	-624(ra) # 80200c74 <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    80200eec:	0001                	nop
    80200eee:	bffd                	j	80200eec <panic+0x30>

0000000080200ef0 <test_printf_precision>:
}
void test_printf_precision(void) {
    80200ef0:	1101                	addi	sp,sp,-32
    80200ef2:	ec06                	sd	ra,24(sp)
    80200ef4:	e822                	sd	s0,16(sp)
    80200ef6:	1000                	addi	s0,sp,32
	clear_screen();
    80200ef8:	00000097          	auipc	ra,0x0
    80200efc:	ab4080e7          	jalr	-1356(ra) # 802009ac <clear_screen>
    printf("=== 详细的Printf测试 ===\n");
    80200f00:	00002517          	auipc	a0,0x2
    80200f04:	4d850513          	addi	a0,a0,1240 # 802033d8 <small_numbers+0x238>
    80200f08:	fffff097          	auipc	ra,0xfffff
    80200f0c:	6ac080e7          	jalr	1708(ra) # 802005b4 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    80200f10:	00002517          	auipc	a0,0x2
    80200f14:	4e850513          	addi	a0,a0,1256 # 802033f8 <small_numbers+0x258>
    80200f18:	fffff097          	auipc	ra,0xfffff
    80200f1c:	69c080e7          	jalr	1692(ra) # 802005b4 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    80200f20:	0ff00593          	li	a1,255
    80200f24:	00002517          	auipc	a0,0x2
    80200f28:	4ec50513          	addi	a0,a0,1260 # 80203410 <small_numbers+0x270>
    80200f2c:	fffff097          	auipc	ra,0xfffff
    80200f30:	688080e7          	jalr	1672(ra) # 802005b4 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    80200f34:	6585                	lui	a1,0x1
    80200f36:	00002517          	auipc	a0,0x2
    80200f3a:	4fa50513          	addi	a0,a0,1274 # 80203430 <small_numbers+0x290>
    80200f3e:	fffff097          	auipc	ra,0xfffff
    80200f42:	676080e7          	jalr	1654(ra) # 802005b4 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    80200f46:	1234b7b7          	lui	a5,0x1234b
    80200f4a:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    80200f4e:	00002517          	auipc	a0,0x2
    80200f52:	50250513          	addi	a0,a0,1282 # 80203450 <small_numbers+0x2b0>
    80200f56:	fffff097          	auipc	ra,0xfffff
    80200f5a:	65e080e7          	jalr	1630(ra) # 802005b4 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    80200f5e:	00002517          	auipc	a0,0x2
    80200f62:	50a50513          	addi	a0,a0,1290 # 80203468 <small_numbers+0x2c8>
    80200f66:	fffff097          	auipc	ra,0xfffff
    80200f6a:	64e080e7          	jalr	1614(ra) # 802005b4 <printf>
    printf("  正数: %d\n", 42);
    80200f6e:	02a00593          	li	a1,42
    80200f72:	00002517          	auipc	a0,0x2
    80200f76:	50e50513          	addi	a0,a0,1294 # 80203480 <small_numbers+0x2e0>
    80200f7a:	fffff097          	auipc	ra,0xfffff
    80200f7e:	63a080e7          	jalr	1594(ra) # 802005b4 <printf>
    printf("  负数: %d\n", -42);
    80200f82:	fd600593          	li	a1,-42
    80200f86:	00002517          	auipc	a0,0x2
    80200f8a:	50a50513          	addi	a0,a0,1290 # 80203490 <small_numbers+0x2f0>
    80200f8e:	fffff097          	auipc	ra,0xfffff
    80200f92:	626080e7          	jalr	1574(ra) # 802005b4 <printf>
    printf("  零: %d\n", 0);
    80200f96:	4581                	li	a1,0
    80200f98:	00002517          	auipc	a0,0x2
    80200f9c:	50850513          	addi	a0,a0,1288 # 802034a0 <small_numbers+0x300>
    80200fa0:	fffff097          	auipc	ra,0xfffff
    80200fa4:	614080e7          	jalr	1556(ra) # 802005b4 <printf>
    printf("  大数: %d\n", 123456789);
    80200fa8:	075bd7b7          	lui	a5,0x75bd
    80200fac:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    80200fb0:	00002517          	auipc	a0,0x2
    80200fb4:	50050513          	addi	a0,a0,1280 # 802034b0 <small_numbers+0x310>
    80200fb8:	fffff097          	auipc	ra,0xfffff
    80200fbc:	5fc080e7          	jalr	1532(ra) # 802005b4 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80200fc0:	00002517          	auipc	a0,0x2
    80200fc4:	50050513          	addi	a0,a0,1280 # 802034c0 <small_numbers+0x320>
    80200fc8:	fffff097          	auipc	ra,0xfffff
    80200fcc:	5ec080e7          	jalr	1516(ra) # 802005b4 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80200fd0:	55fd                	li	a1,-1
    80200fd2:	00002517          	auipc	a0,0x2
    80200fd6:	50650513          	addi	a0,a0,1286 # 802034d8 <small_numbers+0x338>
    80200fda:	fffff097          	auipc	ra,0xfffff
    80200fde:	5da080e7          	jalr	1498(ra) # 802005b4 <printf>
    printf("  零：%u\n", 0U);
    80200fe2:	4581                	li	a1,0
    80200fe4:	00002517          	auipc	a0,0x2
    80200fe8:	50c50513          	addi	a0,a0,1292 # 802034f0 <small_numbers+0x350>
    80200fec:	fffff097          	auipc	ra,0xfffff
    80200ff0:	5c8080e7          	jalr	1480(ra) # 802005b4 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80200ff4:	678d                	lui	a5,0x3
    80200ff6:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    80200ffa:	00002517          	auipc	a0,0x2
    80200ffe:	50650513          	addi	a0,a0,1286 # 80203500 <small_numbers+0x360>
    80201002:	fffff097          	auipc	ra,0xfffff
    80201006:	5b2080e7          	jalr	1458(ra) # 802005b4 <printf>

	// 测试边界
	printf("边界测试:\n");
    8020100a:	00002517          	auipc	a0,0x2
    8020100e:	50e50513          	addi	a0,a0,1294 # 80203518 <small_numbers+0x378>
    80201012:	fffff097          	auipc	ra,0xfffff
    80201016:	5a2080e7          	jalr	1442(ra) # 802005b4 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    8020101a:	800007b7          	lui	a5,0x80000
    8020101e:	fff7c593          	not	a1,a5
    80201022:	00002517          	auipc	a0,0x2
    80201026:	50650513          	addi	a0,a0,1286 # 80203528 <small_numbers+0x388>
    8020102a:	fffff097          	auipc	ra,0xfffff
    8020102e:	58a080e7          	jalr	1418(ra) # 802005b4 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    80201032:	800005b7          	lui	a1,0x80000
    80201036:	00002517          	auipc	a0,0x2
    8020103a:	50250513          	addi	a0,a0,1282 # 80203538 <small_numbers+0x398>
    8020103e:	fffff097          	auipc	ra,0xfffff
    80201042:	576080e7          	jalr	1398(ra) # 802005b4 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    80201046:	55fd                	li	a1,-1
    80201048:	00002517          	auipc	a0,0x2
    8020104c:	50050513          	addi	a0,a0,1280 # 80203548 <small_numbers+0x3a8>
    80201050:	fffff097          	auipc	ra,0xfffff
    80201054:	564080e7          	jalr	1380(ra) # 802005b4 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    80201058:	55fd                	li	a1,-1
    8020105a:	00002517          	auipc	a0,0x2
    8020105e:	4fe50513          	addi	a0,a0,1278 # 80203558 <small_numbers+0x3b8>
    80201062:	fffff097          	auipc	ra,0xfffff
    80201066:	552080e7          	jalr	1362(ra) # 802005b4 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    8020106a:	00002517          	auipc	a0,0x2
    8020106e:	50650513          	addi	a0,a0,1286 # 80203570 <small_numbers+0x3d0>
    80201072:	fffff097          	auipc	ra,0xfffff
    80201076:	542080e7          	jalr	1346(ra) # 802005b4 <printf>
    printf("  空字符串: '%s'\n", "");
    8020107a:	00002597          	auipc	a1,0x2
    8020107e:	50e58593          	addi	a1,a1,1294 # 80203588 <small_numbers+0x3e8>
    80201082:	00002517          	auipc	a0,0x2
    80201086:	50e50513          	addi	a0,a0,1294 # 80203590 <small_numbers+0x3f0>
    8020108a:	fffff097          	auipc	ra,0xfffff
    8020108e:	52a080e7          	jalr	1322(ra) # 802005b4 <printf>
    printf("  单字符: '%s'\n", "X");
    80201092:	00002597          	auipc	a1,0x2
    80201096:	51658593          	addi	a1,a1,1302 # 802035a8 <small_numbers+0x408>
    8020109a:	00002517          	auipc	a0,0x2
    8020109e:	51650513          	addi	a0,a0,1302 # 802035b0 <small_numbers+0x410>
    802010a2:	fffff097          	auipc	ra,0xfffff
    802010a6:	512080e7          	jalr	1298(ra) # 802005b4 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    802010aa:	00002597          	auipc	a1,0x2
    802010ae:	51e58593          	addi	a1,a1,1310 # 802035c8 <small_numbers+0x428>
    802010b2:	00002517          	auipc	a0,0x2
    802010b6:	53650513          	addi	a0,a0,1334 # 802035e8 <small_numbers+0x448>
    802010ba:	fffff097          	auipc	ra,0xfffff
    802010be:	4fa080e7          	jalr	1274(ra) # 802005b4 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    802010c2:	00002597          	auipc	a1,0x2
    802010c6:	53e58593          	addi	a1,a1,1342 # 80203600 <small_numbers+0x460>
    802010ca:	00002517          	auipc	a0,0x2
    802010ce:	68650513          	addi	a0,a0,1670 # 80203750 <small_numbers+0x5b0>
    802010d2:	fffff097          	auipc	ra,0xfffff
    802010d6:	4e2080e7          	jalr	1250(ra) # 802005b4 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    802010da:	00002517          	auipc	a0,0x2
    802010de:	69650513          	addi	a0,a0,1686 # 80203770 <small_numbers+0x5d0>
    802010e2:	fffff097          	auipc	ra,0xfffff
    802010e6:	4d2080e7          	jalr	1234(ra) # 802005b4 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    802010ea:	0ff00693          	li	a3,255
    802010ee:	f0100613          	li	a2,-255
    802010f2:	0ff00593          	li	a1,255
    802010f6:	00002517          	auipc	a0,0x2
    802010fa:	69250513          	addi	a0,a0,1682 # 80203788 <small_numbers+0x5e8>
    802010fe:	fffff097          	auipc	ra,0xfffff
    80201102:	4b6080e7          	jalr	1206(ra) # 802005b4 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80201106:	00002517          	auipc	a0,0x2
    8020110a:	6aa50513          	addi	a0,a0,1706 # 802037b0 <small_numbers+0x610>
    8020110e:	fffff097          	auipc	ra,0xfffff
    80201112:	4a6080e7          	jalr	1190(ra) # 802005b4 <printf>
	printf("  100%% 完成!\n");
    80201116:	00002517          	auipc	a0,0x2
    8020111a:	6b250513          	addi	a0,a0,1714 # 802037c8 <small_numbers+0x628>
    8020111e:	fffff097          	auipc	ra,0xfffff
    80201122:	496080e7          	jalr	1174(ra) # 802005b4 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    80201126:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    8020112a:	00002517          	auipc	a0,0x2
    8020112e:	6b650513          	addi	a0,a0,1718 # 802037e0 <small_numbers+0x640>
    80201132:	fffff097          	auipc	ra,0xfffff
    80201136:	482080e7          	jalr	1154(ra) # 802005b4 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    8020113a:	fe843583          	ld	a1,-24(s0)
    8020113e:	00002517          	auipc	a0,0x2
    80201142:	6ba50513          	addi	a0,a0,1722 # 802037f8 <small_numbers+0x658>
    80201146:	fffff097          	auipc	ra,0xfffff
    8020114a:	46e080e7          	jalr	1134(ra) # 802005b4 <printf>
	
	// 测试指针格式
	int var = 42;
    8020114e:	02a00793          	li	a5,42
    80201152:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    80201156:	00002517          	auipc	a0,0x2
    8020115a:	6ba50513          	addi	a0,a0,1722 # 80203810 <small_numbers+0x670>
    8020115e:	fffff097          	auipc	ra,0xfffff
    80201162:	456080e7          	jalr	1110(ra) # 802005b4 <printf>
	printf("  Address of var: %p\n", &var);
    80201166:	fe440793          	addi	a5,s0,-28
    8020116a:	85be                	mv	a1,a5
    8020116c:	00002517          	auipc	a0,0x2
    80201170:	6b450513          	addi	a0,a0,1716 # 80203820 <small_numbers+0x680>
    80201174:	fffff097          	auipc	ra,0xfffff
    80201178:	440080e7          	jalr	1088(ra) # 802005b4 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    8020117c:	00002517          	auipc	a0,0x2
    80201180:	6bc50513          	addi	a0,a0,1724 # 80203838 <small_numbers+0x698>
    80201184:	fffff097          	auipc	ra,0xfffff
    80201188:	430080e7          	jalr	1072(ra) # 802005b4 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    8020118c:	55fd                	li	a1,-1
    8020118e:	00002517          	auipc	a0,0x2
    80201192:	6ca50513          	addi	a0,a0,1738 # 80203858 <small_numbers+0x6b8>
    80201196:	fffff097          	auipc	ra,0xfffff
    8020119a:	41e080e7          	jalr	1054(ra) # 802005b4 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    8020119e:	00002517          	auipc	a0,0x2
    802011a2:	6d250513          	addi	a0,a0,1746 # 80203870 <small_numbers+0x6d0>
    802011a6:	fffff097          	auipc	ra,0xfffff
    802011aa:	40e080e7          	jalr	1038(ra) # 802005b4 <printf>
	printf("  Binary of 5: %b\n", 5);
    802011ae:	4595                	li	a1,5
    802011b0:	00002517          	auipc	a0,0x2
    802011b4:	6d850513          	addi	a0,a0,1752 # 80203888 <small_numbers+0x6e8>
    802011b8:	fffff097          	auipc	ra,0xfffff
    802011bc:	3fc080e7          	jalr	1020(ra) # 802005b4 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    802011c0:	45a1                	li	a1,8
    802011c2:	00002517          	auipc	a0,0x2
    802011c6:	6de50513          	addi	a0,a0,1758 # 802038a0 <small_numbers+0x700>
    802011ca:	fffff097          	auipc	ra,0xfffff
    802011ce:	3ea080e7          	jalr	1002(ra) # 802005b4 <printf>
	printf("=== Printf测试结束 ===\n");
    802011d2:	00002517          	auipc	a0,0x2
    802011d6:	6e650513          	addi	a0,a0,1766 # 802038b8 <small_numbers+0x718>
    802011da:	fffff097          	auipc	ra,0xfffff
    802011de:	3da080e7          	jalr	986(ra) # 802005b4 <printf>
}
    802011e2:	0001                	nop
    802011e4:	60e2                	ld	ra,24(sp)
    802011e6:	6442                	ld	s0,16(sp)
    802011e8:	6105                	addi	sp,sp,32
    802011ea:	8082                	ret

00000000802011ec <test_curse_move>:
void test_curse_move(){
    802011ec:	1101                	addi	sp,sp,-32
    802011ee:	ec06                	sd	ra,24(sp)
    802011f0:	e822                	sd	s0,16(sp)
    802011f2:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    802011f4:	fffff097          	auipc	ra,0xfffff
    802011f8:	7b8080e7          	jalr	1976(ra) # 802009ac <clear_screen>
	printf("=== 光标移动测试 ===\n");
    802011fc:	00002517          	auipc	a0,0x2
    80201200:	6dc50513          	addi	a0,a0,1756 # 802038d8 <small_numbers+0x738>
    80201204:	fffff097          	auipc	ra,0xfffff
    80201208:	3b0080e7          	jalr	944(ra) # 802005b4 <printf>
	for (int i = 3; i <= 7; i++) {
    8020120c:	478d                	li	a5,3
    8020120e:	fef42623          	sw	a5,-20(s0)
    80201212:	a881                	j	80201262 <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    80201214:	4785                	li	a5,1
    80201216:	fef42423          	sw	a5,-24(s0)
    8020121a:	a805                	j	8020124a <test_curse_move+0x5e>
			goto_rc(i, j);
    8020121c:	fe842703          	lw	a4,-24(s0)
    80201220:	fec42783          	lw	a5,-20(s0)
    80201224:	85ba                	mv	a1,a4
    80201226:	853e                	mv	a0,a5
    80201228:	00000097          	auipc	ra,0x0
    8020122c:	9da080e7          	jalr	-1574(ra) # 80200c02 <goto_rc>
			printf("*");
    80201230:	00002517          	auipc	a0,0x2
    80201234:	6c850513          	addi	a0,a0,1736 # 802038f8 <small_numbers+0x758>
    80201238:	fffff097          	auipc	ra,0xfffff
    8020123c:	37c080e7          	jalr	892(ra) # 802005b4 <printf>
		for (int j = 1; j <= 10; j++) {
    80201240:	fe842783          	lw	a5,-24(s0)
    80201244:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdf9d41>
    80201246:	fef42423          	sw	a5,-24(s0)
    8020124a:	fe842783          	lw	a5,-24(s0)
    8020124e:	0007871b          	sext.w	a4,a5
    80201252:	47a9                	li	a5,10
    80201254:	fce7d4e3          	bge	a5,a4,8020121c <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    80201258:	fec42783          	lw	a5,-20(s0)
    8020125c:	2785                	addiw	a5,a5,1
    8020125e:	fef42623          	sw	a5,-20(s0)
    80201262:	fec42783          	lw	a5,-20(s0)
    80201266:	0007871b          	sext.w	a4,a5
    8020126a:	479d                	li	a5,7
    8020126c:	fae7d4e3          	bge	a5,a4,80201214 <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201270:	4585                	li	a1,1
    80201272:	4525                	li	a0,9
    80201274:	00000097          	auipc	ra,0x0
    80201278:	98e080e7          	jalr	-1650(ra) # 80200c02 <goto_rc>
	save_cursor();
    8020127c:	00000097          	auipc	ra,0x0
    80201280:	8c2080e7          	jalr	-1854(ra) # 80200b3e <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201284:	4515                	li	a0,5
    80201286:	fffff097          	auipc	ra,0xfffff
    8020128a:	758080e7          	jalr	1880(ra) # 802009de <cursor_up>
	cursor_right(2);
    8020128e:	4509                	li	a0,2
    80201290:	fffff097          	auipc	ra,0xfffff
    80201294:	7fe080e7          	jalr	2046(ra) # 80200a8e <cursor_right>
	printf("+++++");
    80201298:	00002517          	auipc	a0,0x2
    8020129c:	66850513          	addi	a0,a0,1640 # 80203900 <small_numbers+0x760>
    802012a0:	fffff097          	auipc	ra,0xfffff
    802012a4:	314080e7          	jalr	788(ra) # 802005b4 <printf>
	cursor_down(2);
    802012a8:	4509                	li	a0,2
    802012aa:	fffff097          	auipc	ra,0xfffff
    802012ae:	78c080e7          	jalr	1932(ra) # 80200a36 <cursor_down>
	cursor_left(5);
    802012b2:	4515                	li	a0,5
    802012b4:	00000097          	auipc	ra,0x0
    802012b8:	832080e7          	jalr	-1998(ra) # 80200ae6 <cursor_left>
	printf("-----");
    802012bc:	00002517          	auipc	a0,0x2
    802012c0:	64c50513          	addi	a0,a0,1612 # 80203908 <small_numbers+0x768>
    802012c4:	fffff097          	auipc	ra,0xfffff
    802012c8:	2f0080e7          	jalr	752(ra) # 802005b4 <printf>
	restore_cursor();
    802012cc:	00000097          	auipc	ra,0x0
    802012d0:	8a6080e7          	jalr	-1882(ra) # 80200b72 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    802012d4:	00002517          	auipc	a0,0x2
    802012d8:	63c50513          	addi	a0,a0,1596 # 80203910 <small_numbers+0x770>
    802012dc:	fffff097          	auipc	ra,0xfffff
    802012e0:	2d8080e7          	jalr	728(ra) # 802005b4 <printf>
}
    802012e4:	0001                	nop
    802012e6:	60e2                	ld	ra,24(sp)
    802012e8:	6442                	ld	s0,16(sp)
    802012ea:	6105                	addi	sp,sp,32
    802012ec:	8082                	ret

00000000802012ee <test_basic_colors>:

void test_basic_colors(void) {
    802012ee:	1141                	addi	sp,sp,-16
    802012f0:	e406                	sd	ra,8(sp)
    802012f2:	e022                	sd	s0,0(sp)
    802012f4:	0800                	addi	s0,sp,16
    clear_screen();
    802012f6:	fffff097          	auipc	ra,0xfffff
    802012fa:	6b6080e7          	jalr	1718(ra) # 802009ac <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    802012fe:	00002517          	auipc	a0,0x2
    80201302:	63a50513          	addi	a0,a0,1594 # 80203938 <small_numbers+0x798>
    80201306:	fffff097          	auipc	ra,0xfffff
    8020130a:	2ae080e7          	jalr	686(ra) # 802005b4 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    8020130e:	00002517          	auipc	a0,0x2
    80201312:	64a50513          	addi	a0,a0,1610 # 80203958 <small_numbers+0x7b8>
    80201316:	fffff097          	auipc	ra,0xfffff
    8020131a:	29e080e7          	jalr	670(ra) # 802005b4 <printf>
    color_red();    printf("红色文字 ");
    8020131e:	00000097          	auipc	ra,0x0
    80201322:	a52080e7          	jalr	-1454(ra) # 80200d70 <color_red>
    80201326:	00002517          	auipc	a0,0x2
    8020132a:	64a50513          	addi	a0,a0,1610 # 80203970 <small_numbers+0x7d0>
    8020132e:	fffff097          	auipc	ra,0xfffff
    80201332:	286080e7          	jalr	646(ra) # 802005b4 <printf>
    color_green();  printf("绿色文字 ");
    80201336:	00000097          	auipc	ra,0x0
    8020133a:	a56080e7          	jalr	-1450(ra) # 80200d8c <color_green>
    8020133e:	00002517          	auipc	a0,0x2
    80201342:	64250513          	addi	a0,a0,1602 # 80203980 <small_numbers+0x7e0>
    80201346:	fffff097          	auipc	ra,0xfffff
    8020134a:	26e080e7          	jalr	622(ra) # 802005b4 <printf>
    color_yellow(); printf("黄色文字 ");
    8020134e:	00000097          	auipc	ra,0x0
    80201352:	a5c080e7          	jalr	-1444(ra) # 80200daa <color_yellow>
    80201356:	00002517          	auipc	a0,0x2
    8020135a:	63a50513          	addi	a0,a0,1594 # 80203990 <small_numbers+0x7f0>
    8020135e:	fffff097          	auipc	ra,0xfffff
    80201362:	256080e7          	jalr	598(ra) # 802005b4 <printf>
    color_blue();   printf("蓝色文字 ");
    80201366:	00000097          	auipc	ra,0x0
    8020136a:	a62080e7          	jalr	-1438(ra) # 80200dc8 <color_blue>
    8020136e:	00002517          	auipc	a0,0x2
    80201372:	63250513          	addi	a0,a0,1586 # 802039a0 <small_numbers+0x800>
    80201376:	fffff097          	auipc	ra,0xfffff
    8020137a:	23e080e7          	jalr	574(ra) # 802005b4 <printf>
    color_purple(); printf("紫色文字 ");
    8020137e:	00000097          	auipc	ra,0x0
    80201382:	a68080e7          	jalr	-1432(ra) # 80200de6 <color_purple>
    80201386:	00002517          	auipc	a0,0x2
    8020138a:	62a50513          	addi	a0,a0,1578 # 802039b0 <small_numbers+0x810>
    8020138e:	fffff097          	auipc	ra,0xfffff
    80201392:	226080e7          	jalr	550(ra) # 802005b4 <printf>
    color_cyan();   printf("青色文字 ");
    80201396:	00000097          	auipc	ra,0x0
    8020139a:	a6e080e7          	jalr	-1426(ra) # 80200e04 <color_cyan>
    8020139e:	00002517          	auipc	a0,0x2
    802013a2:	62250513          	addi	a0,a0,1570 # 802039c0 <small_numbers+0x820>
    802013a6:	fffff097          	auipc	ra,0xfffff
    802013aa:	20e080e7          	jalr	526(ra) # 802005b4 <printf>
    color_reverse();  printf("反色文字");
    802013ae:	00000097          	auipc	ra,0x0
    802013b2:	a74080e7          	jalr	-1420(ra) # 80200e22 <color_reverse>
    802013b6:	00002517          	auipc	a0,0x2
    802013ba:	61a50513          	addi	a0,a0,1562 # 802039d0 <small_numbers+0x830>
    802013be:	fffff097          	auipc	ra,0xfffff
    802013c2:	1f6080e7          	jalr	502(ra) # 802005b4 <printf>
    reset_color();
    802013c6:	00000097          	auipc	ra,0x0
    802013ca:	8ae080e7          	jalr	-1874(ra) # 80200c74 <reset_color>
    printf("\n\n");
    802013ce:	00002517          	auipc	a0,0x2
    802013d2:	61250513          	addi	a0,a0,1554 # 802039e0 <small_numbers+0x840>
    802013d6:	fffff097          	auipc	ra,0xfffff
    802013da:	1de080e7          	jalr	478(ra) # 802005b4 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    802013de:	00002517          	auipc	a0,0x2
    802013e2:	60a50513          	addi	a0,a0,1546 # 802039e8 <small_numbers+0x848>
    802013e6:	fffff097          	auipc	ra,0xfffff
    802013ea:	1ce080e7          	jalr	462(ra) # 802005b4 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    802013ee:	02900513          	li	a0,41
    802013f2:	00000097          	auipc	ra,0x0
    802013f6:	910080e7          	jalr	-1776(ra) # 80200d02 <set_bg_color>
    802013fa:	00002517          	auipc	a0,0x2
    802013fe:	60650513          	addi	a0,a0,1542 # 80203a00 <small_numbers+0x860>
    80201402:	fffff097          	auipc	ra,0xfffff
    80201406:	1b2080e7          	jalr	434(ra) # 802005b4 <printf>
    8020140a:	00000097          	auipc	ra,0x0
    8020140e:	86a080e7          	jalr	-1942(ra) # 80200c74 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80201412:	02a00513          	li	a0,42
    80201416:	00000097          	auipc	ra,0x0
    8020141a:	8ec080e7          	jalr	-1812(ra) # 80200d02 <set_bg_color>
    8020141e:	00002517          	auipc	a0,0x2
    80201422:	5f250513          	addi	a0,a0,1522 # 80203a10 <small_numbers+0x870>
    80201426:	fffff097          	auipc	ra,0xfffff
    8020142a:	18e080e7          	jalr	398(ra) # 802005b4 <printf>
    8020142e:	00000097          	auipc	ra,0x0
    80201432:	846080e7          	jalr	-1978(ra) # 80200c74 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80201436:	02b00513          	li	a0,43
    8020143a:	00000097          	auipc	ra,0x0
    8020143e:	8c8080e7          	jalr	-1848(ra) # 80200d02 <set_bg_color>
    80201442:	00002517          	auipc	a0,0x2
    80201446:	5de50513          	addi	a0,a0,1502 # 80203a20 <small_numbers+0x880>
    8020144a:	fffff097          	auipc	ra,0xfffff
    8020144e:	16a080e7          	jalr	362(ra) # 802005b4 <printf>
    80201452:	00000097          	auipc	ra,0x0
    80201456:	822080e7          	jalr	-2014(ra) # 80200c74 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    8020145a:	02c00513          	li	a0,44
    8020145e:	00000097          	auipc	ra,0x0
    80201462:	8a4080e7          	jalr	-1884(ra) # 80200d02 <set_bg_color>
    80201466:	00002517          	auipc	a0,0x2
    8020146a:	5ca50513          	addi	a0,a0,1482 # 80203a30 <small_numbers+0x890>
    8020146e:	fffff097          	auipc	ra,0xfffff
    80201472:	146080e7          	jalr	326(ra) # 802005b4 <printf>
    80201476:	fffff097          	auipc	ra,0xfffff
    8020147a:	7fe080e7          	jalr	2046(ra) # 80200c74 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    8020147e:	02f00513          	li	a0,47
    80201482:	00000097          	auipc	ra,0x0
    80201486:	880080e7          	jalr	-1920(ra) # 80200d02 <set_bg_color>
    8020148a:	00002517          	auipc	a0,0x2
    8020148e:	5b650513          	addi	a0,a0,1462 # 80203a40 <small_numbers+0x8a0>
    80201492:	fffff097          	auipc	ra,0xfffff
    80201496:	122080e7          	jalr	290(ra) # 802005b4 <printf>
    8020149a:	fffff097          	auipc	ra,0xfffff
    8020149e:	7da080e7          	jalr	2010(ra) # 80200c74 <reset_color>
    printf("\n\n");
    802014a2:	00002517          	auipc	a0,0x2
    802014a6:	53e50513          	addi	a0,a0,1342 # 802039e0 <small_numbers+0x840>
    802014aa:	fffff097          	auipc	ra,0xfffff
    802014ae:	10a080e7          	jalr	266(ra) # 802005b4 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    802014b2:	00002517          	auipc	a0,0x2
    802014b6:	59e50513          	addi	a0,a0,1438 # 80203a50 <small_numbers+0x8b0>
    802014ba:	fffff097          	auipc	ra,0xfffff
    802014be:	0fa080e7          	jalr	250(ra) # 802005b4 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    802014c2:	02c00593          	li	a1,44
    802014c6:	457d                	li	a0,31
    802014c8:	00000097          	auipc	ra,0x0
    802014cc:	978080e7          	jalr	-1672(ra) # 80200e40 <set_color>
    802014d0:	00002517          	auipc	a0,0x2
    802014d4:	59850513          	addi	a0,a0,1432 # 80203a68 <small_numbers+0x8c8>
    802014d8:	fffff097          	auipc	ra,0xfffff
    802014dc:	0dc080e7          	jalr	220(ra) # 802005b4 <printf>
    802014e0:	fffff097          	auipc	ra,0xfffff
    802014e4:	794080e7          	jalr	1940(ra) # 80200c74 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    802014e8:	02d00593          	li	a1,45
    802014ec:	02100513          	li	a0,33
    802014f0:	00000097          	auipc	ra,0x0
    802014f4:	950080e7          	jalr	-1712(ra) # 80200e40 <set_color>
    802014f8:	00002517          	auipc	a0,0x2
    802014fc:	58050513          	addi	a0,a0,1408 # 80203a78 <small_numbers+0x8d8>
    80201500:	fffff097          	auipc	ra,0xfffff
    80201504:	0b4080e7          	jalr	180(ra) # 802005b4 <printf>
    80201508:	fffff097          	auipc	ra,0xfffff
    8020150c:	76c080e7          	jalr	1900(ra) # 80200c74 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201510:	02f00593          	li	a1,47
    80201514:	02000513          	li	a0,32
    80201518:	00000097          	auipc	ra,0x0
    8020151c:	928080e7          	jalr	-1752(ra) # 80200e40 <set_color>
    80201520:	00002517          	auipc	a0,0x2
    80201524:	56850513          	addi	a0,a0,1384 # 80203a88 <small_numbers+0x8e8>
    80201528:	fffff097          	auipc	ra,0xfffff
    8020152c:	08c080e7          	jalr	140(ra) # 802005b4 <printf>
    80201530:	fffff097          	auipc	ra,0xfffff
    80201534:	744080e7          	jalr	1860(ra) # 80200c74 <reset_color>
    printf("\n\n");
    80201538:	00002517          	auipc	a0,0x2
    8020153c:	4a850513          	addi	a0,a0,1192 # 802039e0 <small_numbers+0x840>
    80201540:	fffff097          	auipc	ra,0xfffff
    80201544:	074080e7          	jalr	116(ra) # 802005b4 <printf>
	reset_color();
    80201548:	fffff097          	auipc	ra,0xfffff
    8020154c:	72c080e7          	jalr	1836(ra) # 80200c74 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201550:	00002517          	auipc	a0,0x2
    80201554:	54850513          	addi	a0,a0,1352 # 80203a98 <small_numbers+0x8f8>
    80201558:	fffff097          	auipc	ra,0xfffff
    8020155c:	05c080e7          	jalr	92(ra) # 802005b4 <printf>
	cursor_up(1); // 光标上移一行
    80201560:	4505                	li	a0,1
    80201562:	fffff097          	auipc	ra,0xfffff
    80201566:	47c080e7          	jalr	1148(ra) # 802009de <cursor_up>
	clear_line();
    8020156a:	00000097          	auipc	ra,0x0
    8020156e:	912080e7          	jalr	-1774(ra) # 80200e7c <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201572:	00002517          	auipc	a0,0x2
    80201576:	55e50513          	addi	a0,a0,1374 # 80203ad0 <small_numbers+0x930>
    8020157a:	fffff097          	auipc	ra,0xfffff
    8020157e:	03a080e7          	jalr	58(ra) # 802005b4 <printf>
    80201582:	0001                	nop
    80201584:	60a2                	ld	ra,8(sp)
    80201586:	6402                	ld	s0,0(sp)
    80201588:	0141                	addi	sp,sp,16
    8020158a:	8082                	ret

000000008020158c <memset>:
#include "mem.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    8020158c:	7139                	addi	sp,sp,-64
    8020158e:	fc22                	sd	s0,56(sp)
    80201590:	0080                	addi	s0,sp,64
    80201592:	fca43c23          	sd	a0,-40(s0)
    80201596:	87ae                	mv	a5,a1
    80201598:	fcc43423          	sd	a2,-56(s0)
    8020159c:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    802015a0:	fd843783          	ld	a5,-40(s0)
    802015a4:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    802015a8:	a829                	j	802015c2 <memset+0x36>
        *p++ = (unsigned char)c;
    802015aa:	fe843783          	ld	a5,-24(s0)
    802015ae:	00178713          	addi	a4,a5,1
    802015b2:	fee43423          	sd	a4,-24(s0)
    802015b6:	fd442703          	lw	a4,-44(s0)
    802015ba:	0ff77713          	zext.b	a4,a4
    802015be:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    802015c2:	fc843783          	ld	a5,-56(s0)
    802015c6:	fff78713          	addi	a4,a5,-1
    802015ca:	fce43423          	sd	a4,-56(s0)
    802015ce:	fff1                	bnez	a5,802015aa <memset+0x1e>
    return dst;
    802015d0:	fd843783          	ld	a5,-40(s0)
    802015d4:	853e                	mv	a0,a5
    802015d6:	7462                	ld	s0,56(sp)
    802015d8:	6121                	addi	sp,sp,64
    802015da:	8082                	ret

00000000802015dc <assert>:
#include "vm.h"
#include "memlayout.h"
#include "pm.h"
    802015dc:	1101                	addi	sp,sp,-32
    802015de:	ec06                	sd	ra,24(sp)
    802015e0:	e822                	sd	s0,16(sp)
    802015e2:	1000                	addi	s0,sp,32
    802015e4:	87aa                	mv	a5,a0
    802015e6:	fef42623          	sw	a5,-20(s0)
#include "printf.h"
    802015ea:	fec42783          	lw	a5,-20(s0)
    802015ee:	2781                	sext.w	a5,a5
    802015f0:	e795                	bnez	a5,8020161c <assert+0x40>
#include "mem.h"
    802015f2:	4615                	li	a2,5
    802015f4:	00002597          	auipc	a1,0x2
    802015f8:	4fc58593          	addi	a1,a1,1276 # 80203af0 <small_numbers+0x950>
    802015fc:	00002517          	auipc	a0,0x2
    80201600:	50450513          	addi	a0,a0,1284 # 80203b00 <small_numbers+0x960>
    80201604:	fffff097          	auipc	ra,0xfffff
    80201608:	fb0080e7          	jalr	-80(ra) # 802005b4 <printf>
#include "assert.h"
    8020160c:	00002517          	auipc	a0,0x2
    80201610:	51c50513          	addi	a0,a0,1308 # 80203b28 <small_numbers+0x988>
    80201614:	00000097          	auipc	ra,0x0
    80201618:	8a8080e7          	jalr	-1880(ra) # 80200ebc <panic>

#define PTE_V   0x001
    8020161c:	0001                	nop
    8020161e:	60e2                	ld	ra,24(sp)
    80201620:	6442                	ld	s0,16(sp)
    80201622:	6105                	addi	sp,sp,32
    80201624:	8082                	ret

0000000080201626 <px>:


// 内核页表全局变量
pagetable_t kernel_pagetable = 0;

static inline uint64 px(int level, uint64 va) {
    80201626:	1101                	addi	sp,sp,-32
    80201628:	ec22                	sd	s0,24(sp)
    8020162a:	1000                	addi	s0,sp,32
    8020162c:	87aa                	mv	a5,a0
    8020162e:	feb43023          	sd	a1,-32(s0)
    80201632:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    80201636:	fec42783          	lw	a5,-20(s0)
    8020163a:	873e                	mv	a4,a5
    8020163c:	87ba                	mv	a5,a4
    8020163e:	0037979b          	slliw	a5,a5,0x3
    80201642:	9fb9                	addw	a5,a5,a4
    80201644:	2781                	sext.w	a5,a5
    80201646:	27b1                	addiw	a5,a5,12
    80201648:	2781                	sext.w	a5,a5
    8020164a:	873e                	mv	a4,a5
    8020164c:	fe043783          	ld	a5,-32(s0)
    80201650:	00e7d7b3          	srl	a5,a5,a4
    80201654:	1ff7f793          	andi	a5,a5,511
}
    80201658:	853e                	mv	a0,a5
    8020165a:	6462                	ld	s0,24(sp)
    8020165c:	6105                	addi	sp,sp,32
    8020165e:	8082                	ret

0000000080201660 <create_pagetable>:

// 创建空页表
pagetable_t create_pagetable(void) {
    80201660:	1101                	addi	sp,sp,-32
    80201662:	ec06                	sd	ra,24(sp)
    80201664:	e822                	sd	s0,16(sp)
    80201666:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    80201668:	00001097          	auipc	ra,0x1
    8020166c:	900080e7          	jalr	-1792(ra) # 80201f68 <alloc_page>
    80201670:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    80201674:	fe843783          	ld	a5,-24(s0)
    80201678:	e399                	bnez	a5,8020167e <create_pagetable+0x1e>
        return 0;
    8020167a:	4781                	li	a5,0
    8020167c:	a819                	j	80201692 <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    8020167e:	6605                	lui	a2,0x1
    80201680:	4581                	li	a1,0
    80201682:	fe843503          	ld	a0,-24(s0)
    80201686:	00000097          	auipc	ra,0x0
    8020168a:	f06080e7          	jalr	-250(ra) # 8020158c <memset>
    return pt;
    8020168e:	fe843783          	ld	a5,-24(s0)
}
    80201692:	853e                	mv	a0,a5
    80201694:	60e2                	ld	ra,24(sp)
    80201696:	6442                	ld	s0,16(sp)
    80201698:	6105                	addi	sp,sp,32
    8020169a:	8082                	ret

000000008020169c <walk_lookup>:
// 辅助函数：仅查找
static pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    8020169c:	7179                	addi	sp,sp,-48
    8020169e:	f406                	sd	ra,40(sp)
    802016a0:	f022                	sd	s0,32(sp)
    802016a2:	1800                	addi	s0,sp,48
    802016a4:	fca43c23          	sd	a0,-40(s0)
    802016a8:	fcb43823          	sd	a1,-48(s0)
    if (va >= MAXVA)
    802016ac:	fd043703          	ld	a4,-48(s0)
    802016b0:	57fd                	li	a5,-1
    802016b2:	83e5                	srli	a5,a5,0x19
    802016b4:	00e7fa63          	bgeu	a5,a4,802016c8 <walk_lookup+0x2c>
        panic("walk_lookup: va out of range");
    802016b8:	00002517          	auipc	a0,0x2
    802016bc:	47850513          	addi	a0,a0,1144 # 80203b30 <small_numbers+0x990>
    802016c0:	fffff097          	auipc	ra,0xfffff
    802016c4:	7fc080e7          	jalr	2044(ra) # 80200ebc <panic>
    for (int level = 2; level > 0; level--) {
    802016c8:	4789                	li	a5,2
    802016ca:	fef42623          	sw	a5,-20(s0)
    802016ce:	a0a9                	j	80201718 <walk_lookup+0x7c>
        pte_t *pte = &pt[px(level, va)];
    802016d0:	fec42783          	lw	a5,-20(s0)
    802016d4:	fd043583          	ld	a1,-48(s0)
    802016d8:	853e                	mv	a0,a5
    802016da:	00000097          	auipc	ra,0x0
    802016de:	f4c080e7          	jalr	-180(ra) # 80201626 <px>
    802016e2:	87aa                	mv	a5,a0
    802016e4:	078e                	slli	a5,a5,0x3
    802016e6:	fd843703          	ld	a4,-40(s0)
    802016ea:	97ba                	add	a5,a5,a4
    802016ec:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    802016f0:	fe043783          	ld	a5,-32(s0)
    802016f4:	639c                	ld	a5,0(a5)
    802016f6:	8b85                	andi	a5,a5,1
    802016f8:	cb89                	beqz	a5,8020170a <walk_lookup+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    802016fa:	fe043783          	ld	a5,-32(s0)
    802016fe:	639c                	ld	a5,0(a5)
    80201700:	83a9                	srli	a5,a5,0xa
    80201702:	07b2                	slli	a5,a5,0xc
    80201704:	fcf43c23          	sd	a5,-40(s0)
    80201708:	a019                	j	8020170e <walk_lookup+0x72>
        } else {
            return 0;
    8020170a:	4781                	li	a5,0
    8020170c:	a03d                	j	8020173a <walk_lookup+0x9e>
    for (int level = 2; level > 0; level--) {
    8020170e:	fec42783          	lw	a5,-20(s0)
    80201712:	37fd                	addiw	a5,a5,-1
    80201714:	fef42623          	sw	a5,-20(s0)
    80201718:	fec42783          	lw	a5,-20(s0)
    8020171c:	2781                	sext.w	a5,a5
    8020171e:	faf049e3          	bgtz	a5,802016d0 <walk_lookup+0x34>
        }
    }
    return &pt[px(0, va)];
    80201722:	fd043583          	ld	a1,-48(s0)
    80201726:	4501                	li	a0,0
    80201728:	00000097          	auipc	ra,0x0
    8020172c:	efe080e7          	jalr	-258(ra) # 80201626 <px>
    80201730:	87aa                	mv	a5,a0
    80201732:	078e                	slli	a5,a5,0x3
    80201734:	fd843703          	ld	a4,-40(s0)
    80201738:	97ba                	add	a5,a5,a4
}
    8020173a:	853e                	mv	a0,a5
    8020173c:	70a2                	ld	ra,40(sp)
    8020173e:	7402                	ld	s0,32(sp)
    80201740:	6145                	addi	sp,sp,48
    80201742:	8082                	ret

0000000080201744 <walk_create>:

// 辅助函数：查找或分配
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    80201744:	7139                	addi	sp,sp,-64
    80201746:	fc06                	sd	ra,56(sp)
    80201748:	f822                	sd	s0,48(sp)
    8020174a:	0080                	addi	s0,sp,64
    8020174c:	fca43423          	sd	a0,-56(s0)
    80201750:	fcb43023          	sd	a1,-64(s0)
    if (va >= MAXVA)
    80201754:	fc043703          	ld	a4,-64(s0)
    80201758:	57fd                	li	a5,-1
    8020175a:	83e5                	srli	a5,a5,0x19
    8020175c:	00e7fa63          	bgeu	a5,a4,80201770 <walk_create+0x2c>
        panic("walk_create: va out of range");
    80201760:	00002517          	auipc	a0,0x2
    80201764:	3f050513          	addi	a0,a0,1008 # 80203b50 <small_numbers+0x9b0>
    80201768:	fffff097          	auipc	ra,0xfffff
    8020176c:	754080e7          	jalr	1876(ra) # 80200ebc <panic>
    for (int level = 2; level > 0; level--) {
    80201770:	4789                	li	a5,2
    80201772:	fef42623          	sw	a5,-20(s0)
    80201776:	a059                	j	802017fc <walk_create+0xb8>
        pte_t *pte = &pt[px(level, va)];
    80201778:	fec42783          	lw	a5,-20(s0)
    8020177c:	fc043583          	ld	a1,-64(s0)
    80201780:	853e                	mv	a0,a5
    80201782:	00000097          	auipc	ra,0x0
    80201786:	ea4080e7          	jalr	-348(ra) # 80201626 <px>
    8020178a:	87aa                	mv	a5,a0
    8020178c:	078e                	slli	a5,a5,0x3
    8020178e:	fc843703          	ld	a4,-56(s0)
    80201792:	97ba                	add	a5,a5,a4
    80201794:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80201798:	fe043783          	ld	a5,-32(s0)
    8020179c:	639c                	ld	a5,0(a5)
    8020179e:	8b85                	andi	a5,a5,1
    802017a0:	cb89                	beqz	a5,802017b2 <walk_create+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    802017a2:	fe043783          	ld	a5,-32(s0)
    802017a6:	639c                	ld	a5,0(a5)
    802017a8:	83a9                	srli	a5,a5,0xa
    802017aa:	07b2                	slli	a5,a5,0xc
    802017ac:	fcf43423          	sd	a5,-56(s0)
    802017b0:	a089                	j	802017f2 <walk_create+0xae>
        } else {
            pagetable_t new_pt = (pagetable_t)alloc_page();
    802017b2:	00000097          	auipc	ra,0x0
    802017b6:	7b6080e7          	jalr	1974(ra) # 80201f68 <alloc_page>
    802017ba:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    802017be:	fd843783          	ld	a5,-40(s0)
    802017c2:	e399                	bnez	a5,802017c8 <walk_create+0x84>
                return 0;
    802017c4:	4781                	li	a5,0
    802017c6:	a8a1                	j	8020181e <walk_create+0xda>
            memset(new_pt, 0, PGSIZE);
    802017c8:	6605                	lui	a2,0x1
    802017ca:	4581                	li	a1,0
    802017cc:	fd843503          	ld	a0,-40(s0)
    802017d0:	00000097          	auipc	ra,0x0
    802017d4:	dbc080e7          	jalr	-580(ra) # 8020158c <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    802017d8:	fd843783          	ld	a5,-40(s0)
    802017dc:	83b1                	srli	a5,a5,0xc
    802017de:	07aa                	slli	a5,a5,0xa
    802017e0:	0017e713          	ori	a4,a5,1
    802017e4:	fe043783          	ld	a5,-32(s0)
    802017e8:	e398                	sd	a4,0(a5)
            pt = new_pt;
    802017ea:	fd843783          	ld	a5,-40(s0)
    802017ee:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    802017f2:	fec42783          	lw	a5,-20(s0)
    802017f6:	37fd                	addiw	a5,a5,-1
    802017f8:	fef42623          	sw	a5,-20(s0)
    802017fc:	fec42783          	lw	a5,-20(s0)
    80201800:	2781                	sext.w	a5,a5
    80201802:	f6f04be3          	bgtz	a5,80201778 <walk_create+0x34>
        }
    }
    return &pt[px(0, va)];
    80201806:	fc043583          	ld	a1,-64(s0)
    8020180a:	4501                	li	a0,0
    8020180c:	00000097          	auipc	ra,0x0
    80201810:	e1a080e7          	jalr	-486(ra) # 80201626 <px>
    80201814:	87aa                	mv	a5,a0
    80201816:	078e                	slli	a5,a5,0x3
    80201818:	fc843703          	ld	a4,-56(s0)
    8020181c:	97ba                	add	a5,a5,a4
}
    8020181e:	853e                	mv	a0,a5
    80201820:	70e2                	ld	ra,56(sp)
    80201822:	7442                	ld	s0,48(sp)
    80201824:	6121                	addi	sp,sp,64
    80201826:	8082                	ret

0000000080201828 <map_page>:

// 建立映射，允许重映射到相同物理地址
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    80201828:	7139                	addi	sp,sp,-64
    8020182a:	fc06                	sd	ra,56(sp)
    8020182c:	f822                	sd	s0,48(sp)
    8020182e:	0080                	addi	s0,sp,64
    80201830:	fca43c23          	sd	a0,-40(s0)
    80201834:	fcb43823          	sd	a1,-48(s0)
    80201838:	fcc43423          	sd	a2,-56(s0)
    8020183c:	87b6                	mv	a5,a3
    8020183e:	fcf42223          	sw	a5,-60(s0)
    if ((va % PGSIZE) != 0)
    80201842:	fd043703          	ld	a4,-48(s0)
    80201846:	6785                	lui	a5,0x1
    80201848:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    8020184a:	8ff9                	and	a5,a5,a4
    8020184c:	cb89                	beqz	a5,8020185e <map_page+0x36>
        panic("map_page: va not aligned");
    8020184e:	00002517          	auipc	a0,0x2
    80201852:	32250513          	addi	a0,a0,802 # 80203b70 <small_numbers+0x9d0>
    80201856:	fffff097          	auipc	ra,0xfffff
    8020185a:	666080e7          	jalr	1638(ra) # 80200ebc <panic>
    pte_t *pte = walk_create(pt, va);
    8020185e:	fd043583          	ld	a1,-48(s0)
    80201862:	fd843503          	ld	a0,-40(s0)
    80201866:	00000097          	auipc	ra,0x0
    8020186a:	ede080e7          	jalr	-290(ra) # 80201744 <walk_create>
    8020186e:	fea43423          	sd	a0,-24(s0)
    if (!pte)
    80201872:	fe843783          	ld	a5,-24(s0)
    80201876:	e399                	bnez	a5,8020187c <map_page+0x54>
        return -1;
    80201878:	57fd                	li	a5,-1
    8020187a:	a069                	j	80201904 <map_page+0xdc>
    
    // 检查是否已经映射
	if (*pte & PTE_V) {
    8020187c:	fe843783          	ld	a5,-24(s0)
    80201880:	639c                	ld	a5,0(a5)
    80201882:	8b85                	andi	a5,a5,1
    80201884:	c3b5                	beqz	a5,802018e8 <map_page+0xc0>
		if (PTE2PA(*pte) == pa) {
    80201886:	fe843783          	ld	a5,-24(s0)
    8020188a:	639c                	ld	a5,0(a5)
    8020188c:	83a9                	srli	a5,a5,0xa
    8020188e:	07b2                	slli	a5,a5,0xc
    80201890:	fc843703          	ld	a4,-56(s0)
    80201894:	04f71263          	bne	a4,a5,802018d8 <map_page+0xb0>
			// 只允许提升权限，不允许降低权限
			int new_perm = ((*pte & PTE_FLAGS) | perm) & PTE_FLAGS;
    80201898:	fe843783          	ld	a5,-24(s0)
    8020189c:	639c                	ld	a5,0(a5)
    8020189e:	2781                	sext.w	a5,a5
    802018a0:	3ff7f793          	andi	a5,a5,1023
    802018a4:	0007871b          	sext.w	a4,a5
    802018a8:	fc442783          	lw	a5,-60(s0)
    802018ac:	8fd9                	or	a5,a5,a4
    802018ae:	2781                	sext.w	a5,a5
    802018b0:	2781                	sext.w	a5,a5
    802018b2:	3ff7f793          	andi	a5,a5,1023
    802018b6:	fef42223          	sw	a5,-28(s0)
			*pte = PA2PTE(pa) | new_perm | PTE_V;
    802018ba:	fc843783          	ld	a5,-56(s0)
    802018be:	83b1                	srli	a5,a5,0xc
    802018c0:	00a79713          	slli	a4,a5,0xa
    802018c4:	fe442783          	lw	a5,-28(s0)
    802018c8:	8fd9                	or	a5,a5,a4
    802018ca:	0017e713          	ori	a4,a5,1
    802018ce:	fe843783          	ld	a5,-24(s0)
    802018d2:	e398                	sd	a4,0(a5)
			return 0;
    802018d4:	4781                	li	a5,0
    802018d6:	a03d                	j	80201904 <map_page+0xdc>
		} else {
			panic("map_page: remap to different physical address");
    802018d8:	00002517          	auipc	a0,0x2
    802018dc:	2b850513          	addi	a0,a0,696 # 80203b90 <small_numbers+0x9f0>
    802018e0:	fffff097          	auipc	ra,0xfffff
    802018e4:	5dc080e7          	jalr	1500(ra) # 80200ebc <panic>
		}
	}
    
    *pte = PA2PTE(pa) | perm | PTE_V;
    802018e8:	fc843783          	ld	a5,-56(s0)
    802018ec:	83b1                	srli	a5,a5,0xc
    802018ee:	00a79713          	slli	a4,a5,0xa
    802018f2:	fc442783          	lw	a5,-60(s0)
    802018f6:	8fd9                	or	a5,a5,a4
    802018f8:	0017e713          	ori	a4,a5,1
    802018fc:	fe843783          	ld	a5,-24(s0)
    80201900:	e398                	sd	a4,0(a5)
    return 0;
    80201902:	4781                	li	a5,0
}
    80201904:	853e                	mv	a0,a5
    80201906:	70e2                	ld	ra,56(sp)
    80201908:	7442                	ld	s0,48(sp)
    8020190a:	6121                	addi	sp,sp,64
    8020190c:	8082                	ret

000000008020190e <free_pagetable>:
// 递归释放页表
void free_pagetable(pagetable_t pt) {
    8020190e:	7139                	addi	sp,sp,-64
    80201910:	fc06                	sd	ra,56(sp)
    80201912:	f822                	sd	s0,48(sp)
    80201914:	0080                	addi	s0,sp,64
    80201916:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    8020191a:	fe042623          	sw	zero,-20(s0)
    8020191e:	a8a5                	j	80201996 <free_pagetable+0x88>
        pte_t pte = pt[i];
    80201920:	fec42783          	lw	a5,-20(s0)
    80201924:	078e                	slli	a5,a5,0x3
    80201926:	fc843703          	ld	a4,-56(s0)
    8020192a:	97ba                	add	a5,a5,a4
    8020192c:	639c                	ld	a5,0(a5)
    8020192e:	fef43023          	sd	a5,-32(s0)
        // 只释放中间页表
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80201932:	fe043783          	ld	a5,-32(s0)
    80201936:	8b85                	andi	a5,a5,1
    80201938:	cb95                	beqz	a5,8020196c <free_pagetable+0x5e>
    8020193a:	fe043783          	ld	a5,-32(s0)
    8020193e:	8bb9                	andi	a5,a5,14
    80201940:	e795                	bnez	a5,8020196c <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    80201942:	fe043783          	ld	a5,-32(s0)
    80201946:	83a9                	srli	a5,a5,0xa
    80201948:	07b2                	slli	a5,a5,0xc
    8020194a:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    8020194e:	fd843503          	ld	a0,-40(s0)
    80201952:	00000097          	auipc	ra,0x0
    80201956:	fbc080e7          	jalr	-68(ra) # 8020190e <free_pagetable>
            pt[i] = 0;
    8020195a:	fec42783          	lw	a5,-20(s0)
    8020195e:	078e                	slli	a5,a5,0x3
    80201960:	fc843703          	ld	a4,-56(s0)
    80201964:	97ba                	add	a5,a5,a4
    80201966:	0007b023          	sd	zero,0(a5)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    8020196a:	a00d                	j	8020198c <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    8020196c:	fe043783          	ld	a5,-32(s0)
    80201970:	8b85                	andi	a5,a5,1
    80201972:	cf89                	beqz	a5,8020198c <free_pagetable+0x7e>
    80201974:	fe043783          	ld	a5,-32(s0)
    80201978:	8bb9                	andi	a5,a5,14
    8020197a:	cb89                	beqz	a5,8020198c <free_pagetable+0x7e>
            pt[i] = 0;
    8020197c:	fec42783          	lw	a5,-20(s0)
    80201980:	078e                	slli	a5,a5,0x3
    80201982:	fc843703          	ld	a4,-56(s0)
    80201986:	97ba                	add	a5,a5,a4
    80201988:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    8020198c:	fec42783          	lw	a5,-20(s0)
    80201990:	2785                	addiw	a5,a5,1
    80201992:	fef42623          	sw	a5,-20(s0)
    80201996:	fec42783          	lw	a5,-20(s0)
    8020199a:	0007871b          	sext.w	a4,a5
    8020199e:	1ff00793          	li	a5,511
    802019a2:	f6e7dfe3          	bge	a5,a4,80201920 <free_pagetable+0x12>
        }
    }
    free_page(pt);
    802019a6:	fc843503          	ld	a0,-56(s0)
    802019aa:	00000097          	auipc	ra,0x0
    802019ae:	62a080e7          	jalr	1578(ra) # 80201fd4 <free_page>
}
    802019b2:	0001                	nop
    802019b4:	70e2                	ld	ra,56(sp)
    802019b6:	7442                	ld	s0,48(sp)
    802019b8:	6121                	addi	sp,sp,64
    802019ba:	8082                	ret

00000000802019bc <kvmmake>:

// 内核页表构建（仅映射内核代码和数据，实际可根据需要扩展）
static pagetable_t kvmmake(void) {
    802019bc:	711d                	addi	sp,sp,-96
    802019be:	ec86                	sd	ra,88(sp)
    802019c0:	e8a2                	sd	s0,80(sp)
    802019c2:	1080                	addi	s0,sp,96
    pagetable_t kpgtbl = create_pagetable();
    802019c4:	00000097          	auipc	ra,0x0
    802019c8:	c9c080e7          	jalr	-868(ra) # 80201660 <create_pagetable>
    802019cc:	faa43c23          	sd	a0,-72(s0)
    if (!kpgtbl)
    802019d0:	fb843783          	ld	a5,-72(s0)
    802019d4:	eb89                	bnez	a5,802019e6 <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    802019d6:	00002517          	auipc	a0,0x2
    802019da:	1ea50513          	addi	a0,a0,490 # 80203bc0 <small_numbers+0xa20>
    802019de:	fffff097          	auipc	ra,0xfffff
    802019e2:	4de080e7          	jalr	1246(ra) # 80200ebc <panic>
    // 1. 映射内核代码和数据区域（只读+执行 / 读写）
    extern char etext[];  // 在kernel.ld中定义，内核代码段结束位置
    extern char end[];    // 在kernel.ld中定义，内核数据段结束位置
    
    // 内核代码段 - 只读可执行
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    802019e6:	4785                	li	a5,1
    802019e8:	07fe                	slli	a5,a5,0x1f
    802019ea:	fef43423          	sd	a5,-24(s0)
    802019ee:	a825                	j	80201a26 <kvmmake+0x6a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_X) != 0)
    802019f0:	46a9                	li	a3,10
    802019f2:	fe843603          	ld	a2,-24(s0)
    802019f6:	fe843583          	ld	a1,-24(s0)
    802019fa:	fb843503          	ld	a0,-72(s0)
    802019fe:	00000097          	auipc	ra,0x0
    80201a02:	e2a080e7          	jalr	-470(ra) # 80201828 <map_page>
    80201a06:	87aa                	mv	a5,a0
    80201a08:	cb89                	beqz	a5,80201a1a <kvmmake+0x5e>
            panic("kvmmake: code map failed");
    80201a0a:	00002517          	auipc	a0,0x2
    80201a0e:	1ce50513          	addi	a0,a0,462 # 80203bd8 <small_numbers+0xa38>
    80201a12:	fffff097          	auipc	ra,0xfffff
    80201a16:	4aa080e7          	jalr	1194(ra) # 80200ebc <panic>
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    80201a1a:	fe843703          	ld	a4,-24(s0)
    80201a1e:	6785                	lui	a5,0x1
    80201a20:	97ba                	add	a5,a5,a4
    80201a22:	fef43423          	sd	a5,-24(s0)
    80201a26:	00001797          	auipc	a5,0x1
    80201a2a:	5da78793          	addi	a5,a5,1498 # 80203000 <etext>
    80201a2e:	fe843703          	ld	a4,-24(s0)
    80201a32:	faf76fe3          	bltu	a4,a5,802019f0 <kvmmake+0x34>
    }
    
    // 内核数据段 - 可读写
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    80201a36:	00001797          	auipc	a5,0x1
    80201a3a:	5ca78793          	addi	a5,a5,1482 # 80203000 <etext>
    80201a3e:	fef43023          	sd	a5,-32(s0)
    80201a42:	a825                	j	80201a7a <kvmmake+0xbe>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201a44:	4699                	li	a3,6
    80201a46:	fe043603          	ld	a2,-32(s0)
    80201a4a:	fe043583          	ld	a1,-32(s0)
    80201a4e:	fb843503          	ld	a0,-72(s0)
    80201a52:	00000097          	auipc	ra,0x0
    80201a56:	dd6080e7          	jalr	-554(ra) # 80201828 <map_page>
    80201a5a:	87aa                	mv	a5,a0
    80201a5c:	cb89                	beqz	a5,80201a6e <kvmmake+0xb2>
            panic("kvmmake: data map failed");
    80201a5e:	00002517          	auipc	a0,0x2
    80201a62:	19a50513          	addi	a0,a0,410 # 80203bf8 <small_numbers+0xa58>
    80201a66:	fffff097          	auipc	ra,0xfffff
    80201a6a:	456080e7          	jalr	1110(ra) # 80200ebc <panic>
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    80201a6e:	fe043703          	ld	a4,-32(s0)
    80201a72:	6785                	lui	a5,0x1
    80201a74:	97ba                	add	a5,a5,a4
    80201a76:	fef43023          	sd	a5,-32(s0)
    80201a7a:	00005797          	auipc	a5,0x5
    80201a7e:	84678793          	addi	a5,a5,-1978 # 802062c0 <_bss_end>
    80201a82:	fe043703          	ld	a4,-32(s0)
    80201a86:	faf76fe3          	bltu	a4,a5,80201a44 <kvmmake+0x88>
    }
    
	// 2. 映射内核堆区域 - 可读写
	uint64 aligned_end = ((uint64)end + PGSIZE - 1) & ~(PGSIZE - 1); // 向上对齐到页边界
    80201a8a:	00005717          	auipc	a4,0x5
    80201a8e:	83670713          	addi	a4,a4,-1994 # 802062c0 <_bss_end>
    80201a92:	6785                	lui	a5,0x1
    80201a94:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80201a96:	973e                	add	a4,a4,a5
    80201a98:	77fd                	lui	a5,0xfffff
    80201a9a:	8ff9                	and	a5,a5,a4
    80201a9c:	faf43823          	sd	a5,-80(s0)
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    80201aa0:	fb043783          	ld	a5,-80(s0)
    80201aa4:	fcf43c23          	sd	a5,-40(s0)
    80201aa8:	a825                	j	80201ae0 <kvmmake+0x124>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201aaa:	4699                	li	a3,6
    80201aac:	fd843603          	ld	a2,-40(s0)
    80201ab0:	fd843583          	ld	a1,-40(s0)
    80201ab4:	fb843503          	ld	a0,-72(s0)
    80201ab8:	00000097          	auipc	ra,0x0
    80201abc:	d70080e7          	jalr	-656(ra) # 80201828 <map_page>
    80201ac0:	87aa                	mv	a5,a0
    80201ac2:	cb89                	beqz	a5,80201ad4 <kvmmake+0x118>
			panic("kvmmake: heap map failed");
    80201ac4:	00002517          	auipc	a0,0x2
    80201ac8:	15450513          	addi	a0,a0,340 # 80203c18 <small_numbers+0xa78>
    80201acc:	fffff097          	auipc	ra,0xfffff
    80201ad0:	3f0080e7          	jalr	1008(ra) # 80200ebc <panic>
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    80201ad4:	fd843703          	ld	a4,-40(s0)
    80201ad8:	6785                	lui	a5,0x1
    80201ada:	97ba                	add	a5,a5,a4
    80201adc:	fcf43c23          	sd	a5,-40(s0)
    80201ae0:	fd843703          	ld	a4,-40(s0)
    80201ae4:	47c5                	li	a5,17
    80201ae6:	07ee                	slli	a5,a5,0x1b
    80201ae8:	fcf761e3          	bltu	a4,a5,80201aaa <kvmmake+0xee>
	}
    
    // 3. 映射设备区域 - 只读写，不可执行
    // UART 串口设备
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    80201aec:	4699                	li	a3,6
    80201aee:	10000637          	lui	a2,0x10000
    80201af2:	100005b7          	lui	a1,0x10000
    80201af6:	fb843503          	ld	a0,-72(s0)
    80201afa:	00000097          	auipc	ra,0x0
    80201afe:	d2e080e7          	jalr	-722(ra) # 80201828 <map_page>
    80201b02:	87aa                	mv	a5,a0
    80201b04:	cb89                	beqz	a5,80201b16 <kvmmake+0x15a>
        panic("kvmmake: uart map failed");
    80201b06:	00002517          	auipc	a0,0x2
    80201b0a:	13250513          	addi	a0,a0,306 # 80203c38 <small_numbers+0xa98>
    80201b0e:	fffff097          	auipc	ra,0xfffff
    80201b12:	3ae080e7          	jalr	942(ra) # 80200ebc <panic>
    
    // PLIC 中断控制器
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80201b16:	0c0007b7          	lui	a5,0xc000
    80201b1a:	fcf43823          	sd	a5,-48(s0)
    80201b1e:	a825                	j	80201b56 <kvmmake+0x19a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201b20:	4699                	li	a3,6
    80201b22:	fd043603          	ld	a2,-48(s0)
    80201b26:	fd043583          	ld	a1,-48(s0)
    80201b2a:	fb843503          	ld	a0,-72(s0)
    80201b2e:	00000097          	auipc	ra,0x0
    80201b32:	cfa080e7          	jalr	-774(ra) # 80201828 <map_page>
    80201b36:	87aa                	mv	a5,a0
    80201b38:	cb89                	beqz	a5,80201b4a <kvmmake+0x18e>
            panic("kvmmake: plic map failed");
    80201b3a:	00002517          	auipc	a0,0x2
    80201b3e:	11e50513          	addi	a0,a0,286 # 80203c58 <small_numbers+0xab8>
    80201b42:	fffff097          	auipc	ra,0xfffff
    80201b46:	37a080e7          	jalr	890(ra) # 80200ebc <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80201b4a:	fd043703          	ld	a4,-48(s0)
    80201b4e:	6785                	lui	a5,0x1
    80201b50:	97ba                	add	a5,a5,a4
    80201b52:	fcf43823          	sd	a5,-48(s0)
    80201b56:	fd043703          	ld	a4,-48(s0)
    80201b5a:	0c4007b7          	lui	a5,0xc400
    80201b5e:	fcf761e3          	bltu	a4,a5,80201b20 <kvmmake+0x164>
    }
    
    // CLINT 本地中断控制器 - 完善映射
    // 确保整个 CLINT 区域被映射，特别是 mtimecmp 和 mtime 寄存器
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80201b62:	020007b7          	lui	a5,0x2000
    80201b66:	fcf43423          	sd	a5,-56(s0)
    80201b6a:	a825                	j	80201ba2 <kvmmake+0x1e6>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201b6c:	4699                	li	a3,6
    80201b6e:	fc843603          	ld	a2,-56(s0)
    80201b72:	fc843583          	ld	a1,-56(s0)
    80201b76:	fb843503          	ld	a0,-72(s0)
    80201b7a:	00000097          	auipc	ra,0x0
    80201b7e:	cae080e7          	jalr	-850(ra) # 80201828 <map_page>
    80201b82:	87aa                	mv	a5,a0
    80201b84:	cb89                	beqz	a5,80201b96 <kvmmake+0x1da>
            panic("kvmmake: clint map failed");
    80201b86:	00002517          	auipc	a0,0x2
    80201b8a:	0f250513          	addi	a0,a0,242 # 80203c78 <small_numbers+0xad8>
    80201b8e:	fffff097          	auipc	ra,0xfffff
    80201b92:	32e080e7          	jalr	814(ra) # 80200ebc <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80201b96:	fc843703          	ld	a4,-56(s0)
    80201b9a:	6785                	lui	a5,0x1
    80201b9c:	97ba                	add	a5,a5,a4
    80201b9e:	fcf43423          	sd	a5,-56(s0)
    80201ba2:	fc843703          	ld	a4,-56(s0)
    80201ba6:	020107b7          	lui	a5,0x2010
    80201baa:	fcf761e3          	bltu	a4,a5,80201b6c <kvmmake+0x1b0>
	}
    
    // VIRTIO 设备
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    80201bae:	4699                	li	a3,6
    80201bb0:	10001637          	lui	a2,0x10001
    80201bb4:	100015b7          	lui	a1,0x10001
    80201bb8:	fb843503          	ld	a0,-72(s0)
    80201bbc:	00000097          	auipc	ra,0x0
    80201bc0:	c6c080e7          	jalr	-916(ra) # 80201828 <map_page>
    80201bc4:	87aa                	mv	a5,a0
    80201bc6:	cb89                	beqz	a5,80201bd8 <kvmmake+0x21c>
        panic("kvmmake: virtio map failed");
    80201bc8:	00002517          	auipc	a0,0x2
    80201bcc:	0d050513          	addi	a0,a0,208 # 80203c98 <small_numbers+0xaf8>
    80201bd0:	fffff097          	auipc	ra,0xfffff
    80201bd4:	2ec080e7          	jalr	748(ra) # 80200ebc <panic>
    
    // 4. 扩大SBI调用区域映射
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    80201bd8:	fc043023          	sd	zero,-64(s0)
    80201bdc:	a825                	j	80201c14 <kvmmake+0x258>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201bde:	4699                	li	a3,6
    80201be0:	fc043603          	ld	a2,-64(s0)
    80201be4:	fc043583          	ld	a1,-64(s0)
    80201be8:	fb843503          	ld	a0,-72(s0)
    80201bec:	00000097          	auipc	ra,0x0
    80201bf0:	c3c080e7          	jalr	-964(ra) # 80201828 <map_page>
    80201bf4:	87aa                	mv	a5,a0
    80201bf6:	cb89                	beqz	a5,80201c08 <kvmmake+0x24c>
			panic("kvmmake: low memory map failed");
    80201bf8:	00002517          	auipc	a0,0x2
    80201bfc:	0c050513          	addi	a0,a0,192 # 80203cb8 <small_numbers+0xb18>
    80201c00:	fffff097          	auipc	ra,0xfffff
    80201c04:	2bc080e7          	jalr	700(ra) # 80200ebc <panic>
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    80201c08:	fc043703          	ld	a4,-64(s0)
    80201c0c:	6785                	lui	a5,0x1
    80201c0e:	97ba                	add	a5,a5,a4
    80201c10:	fcf43023          	sd	a5,-64(s0)
    80201c14:	fc043703          	ld	a4,-64(s0)
    80201c18:	001007b7          	lui	a5,0x100
    80201c1c:	fcf761e3          	bltu	a4,a5,80201bde <kvmmake+0x222>
	}

	// 特别映射包含0xfd02080的页
	uint64 sbi_special = 0xfd02000;  // 页对齐
    80201c20:	0fd027b7          	lui	a5,0xfd02
    80201c24:	faf43423          	sd	a5,-88(s0)
	if (map_page(kpgtbl, sbi_special, sbi_special, PTE_R | PTE_W) != 0)
    80201c28:	4699                	li	a3,6
    80201c2a:	fa843603          	ld	a2,-88(s0)
    80201c2e:	fa843583          	ld	a1,-88(s0)
    80201c32:	fb843503          	ld	a0,-72(s0)
    80201c36:	00000097          	auipc	ra,0x0
    80201c3a:	bf2080e7          	jalr	-1038(ra) # 80201828 <map_page>
    80201c3e:	87aa                	mv	a5,a0
    80201c40:	cb89                	beqz	a5,80201c52 <kvmmake+0x296>
		panic("kvmmake: sbi special area map failed");
    80201c42:	00002517          	auipc	a0,0x2
    80201c46:	09650513          	addi	a0,a0,150 # 80203cd8 <small_numbers+0xb38>
    80201c4a:	fffff097          	auipc	ra,0xfffff
    80201c4e:	272080e7          	jalr	626(ra) # 80200ebc <panic>
    
    return kpgtbl;
    80201c52:	fb843783          	ld	a5,-72(s0)
}
    80201c56:	853e                	mv	a0,a5
    80201c58:	60e6                	ld	ra,88(sp)
    80201c5a:	6446                	ld	s0,80(sp)
    80201c5c:	6125                	addi	sp,sp,96
    80201c5e:	8082                	ret

0000000080201c60 <kvminit>:
// 初始化内核页表
void kvminit(void) {
    80201c60:	1141                	addi	sp,sp,-16
    80201c62:	e406                	sd	ra,8(sp)
    80201c64:	e022                	sd	s0,0(sp)
    80201c66:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    80201c68:	00000097          	auipc	ra,0x0
    80201c6c:	d54080e7          	jalr	-684(ra) # 802019bc <kvmmake>
    80201c70:	872a                	mv	a4,a0
    80201c72:	00004797          	auipc	a5,0x4
    80201c76:	3ae78793          	addi	a5,a5,942 # 80206020 <kernel_pagetable>
    80201c7a:	e398                	sd	a4,0(a5)
}
    80201c7c:	0001                	nop
    80201c7e:	60a2                	ld	ra,8(sp)
    80201c80:	6402                	ld	s0,0(sp)
    80201c82:	0141                	addi	sp,sp,16
    80201c84:	8082                	ret

0000000080201c86 <w_satp>:

// 启用分页（单核只需设置一次 satp 并刷新 TLB）
static inline void w_satp(uint64 x) {
    80201c86:	1101                	addi	sp,sp,-32
    80201c88:	ec22                	sd	s0,24(sp)
    80201c8a:	1000                	addi	s0,sp,32
    80201c8c:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    80201c90:	fe843783          	ld	a5,-24(s0)
    80201c94:	18079073          	csrw	satp,a5
}
    80201c98:	0001                	nop
    80201c9a:	6462                	ld	s0,24(sp)
    80201c9c:	6105                	addi	sp,sp,32
    80201c9e:	8082                	ret

0000000080201ca0 <sfence_vma>:

static inline void sfence_vma(void) {
    80201ca0:	1141                	addi	sp,sp,-16
    80201ca2:	e422                	sd	s0,8(sp)
    80201ca4:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    80201ca6:	12000073          	sfence.vma
}
    80201caa:	0001                	nop
    80201cac:	6422                	ld	s0,8(sp)
    80201cae:	0141                	addi	sp,sp,16
    80201cb0:	8082                	ret

0000000080201cb2 <kvminithart>:

void kvminithart(void) {
    80201cb2:	1141                	addi	sp,sp,-16
    80201cb4:	e406                	sd	ra,8(sp)
    80201cb6:	e022                	sd	s0,0(sp)
    80201cb8:	0800                	addi	s0,sp,16
    sfence_vma();
    80201cba:	00000097          	auipc	ra,0x0
    80201cbe:	fe6080e7          	jalr	-26(ra) # 80201ca0 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    80201cc2:	00004797          	auipc	a5,0x4
    80201cc6:	35e78793          	addi	a5,a5,862 # 80206020 <kernel_pagetable>
    80201cca:	639c                	ld	a5,0(a5)
    80201ccc:	00c7d713          	srli	a4,a5,0xc
    80201cd0:	57fd                	li	a5,-1
    80201cd2:	17fe                	slli	a5,a5,0x3f
    80201cd4:	8fd9                	or	a5,a5,a4
    80201cd6:	853e                	mv	a0,a5
    80201cd8:	00000097          	auipc	ra,0x0
    80201cdc:	fae080e7          	jalr	-82(ra) # 80201c86 <w_satp>
    sfence_vma();
    80201ce0:	00000097          	auipc	ra,0x0
    80201ce4:	fc0080e7          	jalr	-64(ra) # 80201ca0 <sfence_vma>
}
    80201ce8:	0001                	nop
    80201cea:	60a2                	ld	ra,8(sp)
    80201cec:	6402                	ld	s0,0(sp)
    80201cee:	0141                	addi	sp,sp,16
    80201cf0:	8082                	ret

0000000080201cf2 <test_pagetable>:

void test_pagetable(void) {
    80201cf2:	7179                	addi	sp,sp,-48
    80201cf4:	f406                	sd	ra,40(sp)
    80201cf6:	f022                	sd	s0,32(sp)
    80201cf8:	1800                	addi	s0,sp,48
    printf("[PT TEST] 创建页表...\n");
    80201cfa:	00002517          	auipc	a0,0x2
    80201cfe:	00650513          	addi	a0,a0,6 # 80203d00 <small_numbers+0xb60>
    80201d02:	fffff097          	auipc	ra,0xfffff
    80201d06:	8b2080e7          	jalr	-1870(ra) # 802005b4 <printf>
    pagetable_t pt = create_pagetable();
    80201d0a:	00000097          	auipc	ra,0x0
    80201d0e:	956080e7          	jalr	-1706(ra) # 80201660 <create_pagetable>
    80201d12:	fea43423          	sd	a0,-24(s0)
    assert(pt != 0);
    80201d16:	fe843783          	ld	a5,-24(s0)
    80201d1a:	00f037b3          	snez	a5,a5
    80201d1e:	0ff7f793          	zext.b	a5,a5
    80201d22:	2781                	sext.w	a5,a5
    80201d24:	853e                	mv	a0,a5
    80201d26:	00000097          	auipc	ra,0x0
    80201d2a:	8b6080e7          	jalr	-1866(ra) # 802015dc <assert>
    printf("[PT TEST] 页表创建通过\n");
    80201d2e:	00002517          	auipc	a0,0x2
    80201d32:	ff250513          	addi	a0,a0,-14 # 80203d20 <small_numbers+0xb80>
    80201d36:	fffff097          	auipc	ra,0xfffff
    80201d3a:	87e080e7          	jalr	-1922(ra) # 802005b4 <printf>

    // 测试基本映射
    uint64 va = 0x1000000;
    80201d3e:	010007b7          	lui	a5,0x1000
    80201d42:	fef43023          	sd	a5,-32(s0)
    uint64 pa = (uint64)alloc_page();
    80201d46:	00000097          	auipc	ra,0x0
    80201d4a:	222080e7          	jalr	546(ra) # 80201f68 <alloc_page>
    80201d4e:	87aa                	mv	a5,a0
    80201d50:	fcf43c23          	sd	a5,-40(s0)
    assert(pa != 0);
    80201d54:	fd843783          	ld	a5,-40(s0)
    80201d58:	00f037b3          	snez	a5,a5
    80201d5c:	0ff7f793          	zext.b	a5,a5
    80201d60:	2781                	sext.w	a5,a5
    80201d62:	853e                	mv	a0,a5
    80201d64:	00000097          	auipc	ra,0x0
    80201d68:	878080e7          	jalr	-1928(ra) # 802015dc <assert>
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0);
    80201d6c:	4699                	li	a3,6
    80201d6e:	fd843603          	ld	a2,-40(s0)
    80201d72:	fe043583          	ld	a1,-32(s0)
    80201d76:	fe843503          	ld	a0,-24(s0)
    80201d7a:	00000097          	auipc	ra,0x0
    80201d7e:	aae080e7          	jalr	-1362(ra) # 80201828 <map_page>
    80201d82:	87aa                	mv	a5,a0
    80201d84:	0017b793          	seqz	a5,a5
    80201d88:	0ff7f793          	zext.b	a5,a5
    80201d8c:	2781                	sext.w	a5,a5
    80201d8e:	853e                	mv	a0,a5
    80201d90:	00000097          	auipc	ra,0x0
    80201d94:	84c080e7          	jalr	-1972(ra) # 802015dc <assert>
    printf("[PT TEST] 映射测试通过\n");
    80201d98:	00002517          	auipc	a0,0x2
    80201d9c:	fa850513          	addi	a0,a0,-88 # 80203d40 <small_numbers+0xba0>
    80201da0:	fffff097          	auipc	ra,0xfffff
    80201da4:	814080e7          	jalr	-2028(ra) # 802005b4 <printf>

    // 测试地址转换
    pte_t *pte = walk_lookup(pt, va);
    80201da8:	fe043583          	ld	a1,-32(s0)
    80201dac:	fe843503          	ld	a0,-24(s0)
    80201db0:	00000097          	auipc	ra,0x0
    80201db4:	8ec080e7          	jalr	-1812(ra) # 8020169c <walk_lookup>
    80201db8:	fca43823          	sd	a0,-48(s0)
    assert(pte != 0 && (*pte & PTE_V));
    80201dbc:	fd043783          	ld	a5,-48(s0)
    80201dc0:	cb81                	beqz	a5,80201dd0 <test_pagetable+0xde>
    80201dc2:	fd043783          	ld	a5,-48(s0)
    80201dc6:	639c                	ld	a5,0(a5)
    80201dc8:	8b85                	andi	a5,a5,1
    80201dca:	c399                	beqz	a5,80201dd0 <test_pagetable+0xde>
    80201dcc:	4785                	li	a5,1
    80201dce:	a011                	j	80201dd2 <test_pagetable+0xe0>
    80201dd0:	4781                	li	a5,0
    80201dd2:	853e                	mv	a0,a5
    80201dd4:	00000097          	auipc	ra,0x0
    80201dd8:	808080e7          	jalr	-2040(ra) # 802015dc <assert>
    assert(PTE2PA(*pte) == pa);
    80201ddc:	fd043783          	ld	a5,-48(s0)
    80201de0:	639c                	ld	a5,0(a5)
    80201de2:	83a9                	srli	a5,a5,0xa
    80201de4:	07b2                	slli	a5,a5,0xc
    80201de6:	fd843703          	ld	a4,-40(s0)
    80201dea:	40f707b3          	sub	a5,a4,a5
    80201dee:	0017b793          	seqz	a5,a5
    80201df2:	0ff7f793          	zext.b	a5,a5
    80201df6:	2781                	sext.w	a5,a5
    80201df8:	853e                	mv	a0,a5
    80201dfa:	fffff097          	auipc	ra,0xfffff
    80201dfe:	7e2080e7          	jalr	2018(ra) # 802015dc <assert>
    printf("[PT TEST] 地址转换测试通过\n");
    80201e02:	00002517          	auipc	a0,0x2
    80201e06:	f5e50513          	addi	a0,a0,-162 # 80203d60 <small_numbers+0xbc0>
    80201e0a:	ffffe097          	auipc	ra,0xffffe
    80201e0e:	7aa080e7          	jalr	1962(ra) # 802005b4 <printf>

    // 测试权限位
    assert(*pte & PTE_R);
    80201e12:	fd043783          	ld	a5,-48(s0)
    80201e16:	639c                	ld	a5,0(a5)
    80201e18:	2781                	sext.w	a5,a5
    80201e1a:	8b89                	andi	a5,a5,2
    80201e1c:	2781                	sext.w	a5,a5
    80201e1e:	853e                	mv	a0,a5
    80201e20:	fffff097          	auipc	ra,0xfffff
    80201e24:	7bc080e7          	jalr	1980(ra) # 802015dc <assert>
    assert(*pte & PTE_W);
    80201e28:	fd043783          	ld	a5,-48(s0)
    80201e2c:	639c                	ld	a5,0(a5)
    80201e2e:	2781                	sext.w	a5,a5
    80201e30:	8b91                	andi	a5,a5,4
    80201e32:	2781                	sext.w	a5,a5
    80201e34:	853e                	mv	a0,a5
    80201e36:	fffff097          	auipc	ra,0xfffff
    80201e3a:	7a6080e7          	jalr	1958(ra) # 802015dc <assert>
    assert(!(*pte & PTE_X));
    80201e3e:	fd043783          	ld	a5,-48(s0)
    80201e42:	639c                	ld	a5,0(a5)
    80201e44:	8ba1                	andi	a5,a5,8
    80201e46:	0017b793          	seqz	a5,a5
    80201e4a:	0ff7f793          	zext.b	a5,a5
    80201e4e:	2781                	sext.w	a5,a5
    80201e50:	853e                	mv	a0,a5
    80201e52:	fffff097          	auipc	ra,0xfffff
    80201e56:	78a080e7          	jalr	1930(ra) # 802015dc <assert>
    printf("[PT TEST] 权限测试通过\n");
    80201e5a:	00002517          	auipc	a0,0x2
    80201e5e:	f2e50513          	addi	a0,a0,-210 # 80203d88 <small_numbers+0xbe8>
    80201e62:	ffffe097          	auipc	ra,0xffffe
    80201e66:	752080e7          	jalr	1874(ra) # 802005b4 <printf>

    // 清理
    free_page((void*)pa);
    80201e6a:	fd843783          	ld	a5,-40(s0)
    80201e6e:	853e                	mv	a0,a5
    80201e70:	00000097          	auipc	ra,0x0
    80201e74:	164080e7          	jalr	356(ra) # 80201fd4 <free_page>
    free_pagetable(pt);
    80201e78:	fe843503          	ld	a0,-24(s0)
    80201e7c:	00000097          	auipc	ra,0x0
    80201e80:	a92080e7          	jalr	-1390(ra) # 8020190e <free_pagetable>

    printf("[PT TEST] 所有页表测试通过\n");
    80201e84:	00002517          	auipc	a0,0x2
    80201e88:	f2450513          	addi	a0,a0,-220 # 80203da8 <small_numbers+0xc08>
    80201e8c:	ffffe097          	auipc	ra,0xffffe
    80201e90:	728080e7          	jalr	1832(ra) # 802005b4 <printf>
    80201e94:	0001                	nop
    80201e96:	70a2                	ld	ra,40(sp)
    80201e98:	7402                	ld	s0,32(sp)
    80201e9a:	6145                	addi	sp,sp,48
    80201e9c:	8082                	ret

0000000080201e9e <assert>:
#include "pm.h"
#include "memlayout.h"
#include "types.h"
    80201e9e:	1101                	addi	sp,sp,-32
    80201ea0:	ec06                	sd	ra,24(sp)
    80201ea2:	e822                	sd	s0,16(sp)
    80201ea4:	1000                	addi	s0,sp,32
    80201ea6:	87aa                	mv	a5,a0
    80201ea8:	fef42623          	sw	a5,-20(s0)
#include "printf.h"
    80201eac:	fec42783          	lw	a5,-20(s0)
    80201eb0:	2781                	sext.w	a5,a5
    80201eb2:	e795                	bnez	a5,80201ede <assert+0x40>
#include "mem.h"
    80201eb4:	4615                	li	a2,5
    80201eb6:	00002597          	auipc	a1,0x2
    80201eba:	f1a58593          	addi	a1,a1,-230 # 80203dd0 <small_numbers+0xc30>
    80201ebe:	00002517          	auipc	a0,0x2
    80201ec2:	f2250513          	addi	a0,a0,-222 # 80203de0 <small_numbers+0xc40>
    80201ec6:	ffffe097          	auipc	ra,0xffffe
    80201eca:	6ee080e7          	jalr	1774(ra) # 802005b4 <printf>
#include "assert.h"
    80201ece:	00002517          	auipc	a0,0x2
    80201ed2:	f3a50513          	addi	a0,a0,-198 # 80203e08 <small_numbers+0xc68>
    80201ed6:	fffff097          	auipc	ra,0xfffff
    80201eda:	fe6080e7          	jalr	-26(ra) # 80200ebc <panic>

struct run {
    80201ede:	0001                	nop
    80201ee0:	60e2                	ld	ra,24(sp)
    80201ee2:	6442                	ld	s0,16(sp)
    80201ee4:	6105                	addi	sp,sp,32
    80201ee6:	8082                	ret

0000000080201ee8 <freerange>:

static struct run *freelist = 0;

extern char end[];

static void freerange(void *pa_start, void *pa_end) {
    80201ee8:	7179                	addi	sp,sp,-48
    80201eea:	f406                	sd	ra,40(sp)
    80201eec:	f022                	sd	s0,32(sp)
    80201eee:	1800                	addi	s0,sp,48
    80201ef0:	fca43c23          	sd	a0,-40(s0)
    80201ef4:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    80201ef8:	fd843703          	ld	a4,-40(s0)
    80201efc:	6785                	lui	a5,0x1
    80201efe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80201f00:	973e                	add	a4,a4,a5
    80201f02:	77fd                	lui	a5,0xfffff
    80201f04:	8ff9                	and	a5,a5,a4
    80201f06:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80201f0a:	a829                	j	80201f24 <freerange+0x3c>
    free_page(p);
    80201f0c:	fe843503          	ld	a0,-24(s0)
    80201f10:	00000097          	auipc	ra,0x0
    80201f14:	0c4080e7          	jalr	196(ra) # 80201fd4 <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80201f18:	fe843703          	ld	a4,-24(s0)
    80201f1c:	6785                	lui	a5,0x1
    80201f1e:	97ba                	add	a5,a5,a4
    80201f20:	fef43423          	sd	a5,-24(s0)
    80201f24:	fe843703          	ld	a4,-24(s0)
    80201f28:	6785                	lui	a5,0x1
    80201f2a:	97ba                	add	a5,a5,a4
    80201f2c:	fd043703          	ld	a4,-48(s0)
    80201f30:	fcf77ee3          	bgeu	a4,a5,80201f0c <freerange+0x24>
  }
}
    80201f34:	0001                	nop
    80201f36:	0001                	nop
    80201f38:	70a2                	ld	ra,40(sp)
    80201f3a:	7402                	ld	s0,32(sp)
    80201f3c:	6145                	addi	sp,sp,48
    80201f3e:	8082                	ret

0000000080201f40 <pmm_init>:

void pmm_init(void) {
    80201f40:	1141                	addi	sp,sp,-16
    80201f42:	e406                	sd	ra,8(sp)
    80201f44:	e022                	sd	s0,0(sp)
    80201f46:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    80201f48:	47c5                	li	a5,17
    80201f4a:	01b79593          	slli	a1,a5,0x1b
    80201f4e:	00004517          	auipc	a0,0x4
    80201f52:	37250513          	addi	a0,a0,882 # 802062c0 <_bss_end>
    80201f56:	00000097          	auipc	ra,0x0
    80201f5a:	f92080e7          	jalr	-110(ra) # 80201ee8 <freerange>
}
    80201f5e:	0001                	nop
    80201f60:	60a2                	ld	ra,8(sp)
    80201f62:	6402                	ld	s0,0(sp)
    80201f64:	0141                	addi	sp,sp,16
    80201f66:	8082                	ret

0000000080201f68 <alloc_page>:

void* alloc_page(void) {
    80201f68:	1101                	addi	sp,sp,-32
    80201f6a:	ec06                	sd	ra,24(sp)
    80201f6c:	e822                	sd	s0,16(sp)
    80201f6e:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80201f70:	00004797          	auipc	a5,0x4
    80201f74:	14878793          	addi	a5,a5,328 # 802060b8 <freelist>
    80201f78:	639c                	ld	a5,0(a5)
    80201f7a:	fef43423          	sd	a5,-24(s0)
  if(r)
    80201f7e:	fe843783          	ld	a5,-24(s0)
    80201f82:	cb89                	beqz	a5,80201f94 <alloc_page+0x2c>
    freelist = r->next;
    80201f84:	fe843783          	ld	a5,-24(s0)
    80201f88:	6398                	ld	a4,0(a5)
    80201f8a:	00004797          	auipc	a5,0x4
    80201f8e:	12e78793          	addi	a5,a5,302 # 802060b8 <freelist>
    80201f92:	e398                	sd	a4,0(a5)
  if(r)
    80201f94:	fe843783          	ld	a5,-24(s0)
    80201f98:	cf99                	beqz	a5,80201fb6 <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    80201f9a:	fe843783          	ld	a5,-24(s0)
    80201f9e:	00878713          	addi	a4,a5,8
    80201fa2:	6785                	lui	a5,0x1
    80201fa4:	ff878613          	addi	a2,a5,-8 # ff8 <_entry-0x801ff008>
    80201fa8:	4595                	li	a1,5
    80201faa:	853a                	mv	a0,a4
    80201fac:	fffff097          	auipc	ra,0xfffff
    80201fb0:	5e0080e7          	jalr	1504(ra) # 8020158c <memset>
    80201fb4:	a809                	j	80201fc6 <alloc_page+0x5e>
  else
    panic("alloc_page: out of memory");
    80201fb6:	00002517          	auipc	a0,0x2
    80201fba:	e5a50513          	addi	a0,a0,-422 # 80203e10 <small_numbers+0xc70>
    80201fbe:	fffff097          	auipc	ra,0xfffff
    80201fc2:	efe080e7          	jalr	-258(ra) # 80200ebc <panic>
  return (void*)r;
    80201fc6:	fe843783          	ld	a5,-24(s0)
}
    80201fca:	853e                	mv	a0,a5
    80201fcc:	60e2                	ld	ra,24(sp)
    80201fce:	6442                	ld	s0,16(sp)
    80201fd0:	6105                	addi	sp,sp,32
    80201fd2:	8082                	ret

0000000080201fd4 <free_page>:

void free_page(void* page) {
    80201fd4:	7179                	addi	sp,sp,-48
    80201fd6:	f406                	sd	ra,40(sp)
    80201fd8:	f022                	sd	s0,32(sp)
    80201fda:	1800                	addi	s0,sp,48
    80201fdc:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    80201fe0:	fd843783          	ld	a5,-40(s0)
    80201fe4:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    80201fe8:	fd843703          	ld	a4,-40(s0)
    80201fec:	6785                	lui	a5,0x1
    80201fee:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80201ff0:	8ff9                	and	a5,a5,a4
    80201ff2:	ef99                	bnez	a5,80202010 <free_page+0x3c>
    80201ff4:	fd843703          	ld	a4,-40(s0)
    80201ff8:	00004797          	auipc	a5,0x4
    80201ffc:	2c878793          	addi	a5,a5,712 # 802062c0 <_bss_end>
    80202000:	00f76863          	bltu	a4,a5,80202010 <free_page+0x3c>
    80202004:	fd843703          	ld	a4,-40(s0)
    80202008:	47c5                	li	a5,17
    8020200a:	07ee                	slli	a5,a5,0x1b
    8020200c:	00f76a63          	bltu	a4,a5,80202020 <free_page+0x4c>
    panic("free_page: invalid page address");
    80202010:	00002517          	auipc	a0,0x2
    80202014:	e2050513          	addi	a0,a0,-480 # 80203e30 <small_numbers+0xc90>
    80202018:	fffff097          	auipc	ra,0xfffff
    8020201c:	ea4080e7          	jalr	-348(ra) # 80200ebc <panic>
  r->next = freelist;
    80202020:	00004797          	auipc	a5,0x4
    80202024:	09878793          	addi	a5,a5,152 # 802060b8 <freelist>
    80202028:	6398                	ld	a4,0(a5)
    8020202a:	fe843783          	ld	a5,-24(s0)
    8020202e:	e398                	sd	a4,0(a5)
  freelist = r;
    80202030:	00004797          	auipc	a5,0x4
    80202034:	08878793          	addi	a5,a5,136 # 802060b8 <freelist>
    80202038:	fe843703          	ld	a4,-24(s0)
    8020203c:	e398                	sd	a4,0(a5)
}
    8020203e:	0001                	nop
    80202040:	70a2                	ld	ra,40(sp)
    80202042:	7402                	ld	s0,32(sp)
    80202044:	6145                	addi	sp,sp,48
    80202046:	8082                	ret

0000000080202048 <test_physical_memory>:

void test_physical_memory(void) {
    80202048:	7179                	addi	sp,sp,-48
    8020204a:	f406                	sd	ra,40(sp)
    8020204c:	f022                	sd	s0,32(sp)
    8020204e:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    80202050:	00002517          	auipc	a0,0x2
    80202054:	e0050513          	addi	a0,a0,-512 # 80203e50 <small_numbers+0xcb0>
    80202058:	ffffe097          	auipc	ra,0xffffe
    8020205c:	55c080e7          	jalr	1372(ra) # 802005b4 <printf>
    void *page1 = alloc_page();
    80202060:	00000097          	auipc	ra,0x0
    80202064:	f08080e7          	jalr	-248(ra) # 80201f68 <alloc_page>
    80202068:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    8020206c:	00000097          	auipc	ra,0x0
    80202070:	efc080e7          	jalr	-260(ra) # 80201f68 <alloc_page>
    80202074:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    80202078:	fe843783          	ld	a5,-24(s0)
    8020207c:	00f037b3          	snez	a5,a5
    80202080:	0ff7f793          	zext.b	a5,a5
    80202084:	2781                	sext.w	a5,a5
    80202086:	853e                	mv	a0,a5
    80202088:	00000097          	auipc	ra,0x0
    8020208c:	e16080e7          	jalr	-490(ra) # 80201e9e <assert>
    assert(page2 != 0);
    80202090:	fe043783          	ld	a5,-32(s0)
    80202094:	00f037b3          	snez	a5,a5
    80202098:	0ff7f793          	zext.b	a5,a5
    8020209c:	2781                	sext.w	a5,a5
    8020209e:	853e                	mv	a0,a5
    802020a0:	00000097          	auipc	ra,0x0
    802020a4:	dfe080e7          	jalr	-514(ra) # 80201e9e <assert>
    assert(page1 != page2);
    802020a8:	fe843703          	ld	a4,-24(s0)
    802020ac:	fe043783          	ld	a5,-32(s0)
    802020b0:	40f707b3          	sub	a5,a4,a5
    802020b4:	00f037b3          	snez	a5,a5
    802020b8:	0ff7f793          	zext.b	a5,a5
    802020bc:	2781                	sext.w	a5,a5
    802020be:	853e                	mv	a0,a5
    802020c0:	00000097          	auipc	ra,0x0
    802020c4:	dde080e7          	jalr	-546(ra) # 80201e9e <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    802020c8:	fe843703          	ld	a4,-24(s0)
    802020cc:	6785                	lui	a5,0x1
    802020ce:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802020d0:	8ff9                	and	a5,a5,a4
    802020d2:	0017b793          	seqz	a5,a5
    802020d6:	0ff7f793          	zext.b	a5,a5
    802020da:	2781                	sext.w	a5,a5
    802020dc:	853e                	mv	a0,a5
    802020de:	00000097          	auipc	ra,0x0
    802020e2:	dc0080e7          	jalr	-576(ra) # 80201e9e <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    802020e6:	fe043703          	ld	a4,-32(s0)
    802020ea:	6785                	lui	a5,0x1
    802020ec:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802020ee:	8ff9                	and	a5,a5,a4
    802020f0:	0017b793          	seqz	a5,a5
    802020f4:	0ff7f793          	zext.b	a5,a5
    802020f8:	2781                	sext.w	a5,a5
    802020fa:	853e                	mv	a0,a5
    802020fc:	00000097          	auipc	ra,0x0
    80202100:	da2080e7          	jalr	-606(ra) # 80201e9e <assert>
    printf("[PM TEST] 分配测试通过\n");
    80202104:	00002517          	auipc	a0,0x2
    80202108:	d6c50513          	addi	a0,a0,-660 # 80203e70 <small_numbers+0xcd0>
    8020210c:	ffffe097          	auipc	ra,0xffffe
    80202110:	4a8080e7          	jalr	1192(ra) # 802005b4 <printf>

    printf("[PM TEST] 数据写入测试...\n");
    80202114:	00002517          	auipc	a0,0x2
    80202118:	d7c50513          	addi	a0,a0,-644 # 80203e90 <small_numbers+0xcf0>
    8020211c:	ffffe097          	auipc	ra,0xffffe
    80202120:	498080e7          	jalr	1176(ra) # 802005b4 <printf>
    *(int*)page1 = 0x12345678;
    80202124:	fe843783          	ld	a5,-24(s0)
    80202128:	12345737          	lui	a4,0x12345
    8020212c:	67870713          	addi	a4,a4,1656 # 12345678 <_entry-0x6deba988>
    80202130:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    80202132:	fe843783          	ld	a5,-24(s0)
    80202136:	439c                	lw	a5,0(a5)
    80202138:	873e                	mv	a4,a5
    8020213a:	123457b7          	lui	a5,0x12345
    8020213e:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6deba988>
    80202142:	40f707b3          	sub	a5,a4,a5
    80202146:	0017b793          	seqz	a5,a5
    8020214a:	0ff7f793          	zext.b	a5,a5
    8020214e:	2781                	sext.w	a5,a5
    80202150:	853e                	mv	a0,a5
    80202152:	00000097          	auipc	ra,0x0
    80202156:	d4c080e7          	jalr	-692(ra) # 80201e9e <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    8020215a:	00002517          	auipc	a0,0x2
    8020215e:	d5e50513          	addi	a0,a0,-674 # 80203eb8 <small_numbers+0xd18>
    80202162:	ffffe097          	auipc	ra,0xffffe
    80202166:	452080e7          	jalr	1106(ra) # 802005b4 <printf>

    printf("[PM TEST] 释放与重新分配测试...\n");
    8020216a:	00002517          	auipc	a0,0x2
    8020216e:	d7650513          	addi	a0,a0,-650 # 80203ee0 <small_numbers+0xd40>
    80202172:	ffffe097          	auipc	ra,0xffffe
    80202176:	442080e7          	jalr	1090(ra) # 802005b4 <printf>
    free_page(page1);
    8020217a:	fe843503          	ld	a0,-24(s0)
    8020217e:	00000097          	auipc	ra,0x0
    80202182:	e56080e7          	jalr	-426(ra) # 80201fd4 <free_page>
    void *page3 = alloc_page();
    80202186:	00000097          	auipc	ra,0x0
    8020218a:	de2080e7          	jalr	-542(ra) # 80201f68 <alloc_page>
    8020218e:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    80202192:	fd843783          	ld	a5,-40(s0)
    80202196:	00f037b3          	snez	a5,a5
    8020219a:	0ff7f793          	zext.b	a5,a5
    8020219e:	2781                	sext.w	a5,a5
    802021a0:	853e                	mv	a0,a5
    802021a2:	00000097          	auipc	ra,0x0
    802021a6:	cfc080e7          	jalr	-772(ra) # 80201e9e <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    802021aa:	00002517          	auipc	a0,0x2
    802021ae:	d6650513          	addi	a0,a0,-666 # 80203f10 <small_numbers+0xd70>
    802021b2:	ffffe097          	auipc	ra,0xffffe
    802021b6:	402080e7          	jalr	1026(ra) # 802005b4 <printf>

    free_page(page2);
    802021ba:	fe043503          	ld	a0,-32(s0)
    802021be:	00000097          	auipc	ra,0x0
    802021c2:	e16080e7          	jalr	-490(ra) # 80201fd4 <free_page>
    free_page(page3);
    802021c6:	fd843503          	ld	a0,-40(s0)
    802021ca:	00000097          	auipc	ra,0x0
    802021ce:	e0a080e7          	jalr	-502(ra) # 80201fd4 <free_page>

    printf("[PM TEST] 所有物理内存管理测试通过\n");
    802021d2:	00002517          	auipc	a0,0x2
    802021d6:	d6e50513          	addi	a0,a0,-658 # 80203f40 <small_numbers+0xda0>
    802021da:	ffffe097          	auipc	ra,0xffffe
    802021de:	3da080e7          	jalr	986(ra) # 802005b4 <printf>
    802021e2:	0001                	nop
    802021e4:	70a2                	ld	ra,40(sp)
    802021e6:	7402                	ld	s0,32(sp)
    802021e8:	6145                	addi	sp,sp,48
    802021ea:	8082                	ret

00000000802021ec <sbi_set_time>:
#include "printf.h"

// SBI ecall 编号
#define SBI_SET_TIME 0x0

void sbi_set_time(uint64 time) {
    802021ec:	1101                	addi	sp,sp,-32
    802021ee:	ec22                	sd	s0,24(sp)
    802021f0:	1000                	addi	s0,sp,32
    802021f2:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    802021f6:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    802021fa:	4881                	li	a7,0
    asm volatile ("ecall"
    802021fc:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    80202200:	0001                	nop
    80202202:	6462                	ld	s0,24(sp)
    80202204:	6105                	addi	sp,sp,32
    80202206:	8082                	ret

0000000080202208 <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    80202208:	1101                	addi	sp,sp,-32
    8020220a:	ec22                	sd	s0,24(sp)
    8020220c:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    8020220e:	c01027f3          	rdtime	a5
    80202212:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    80202216:	fe843783          	ld	a5,-24(s0)
    8020221a:	853e                	mv	a0,a5
    8020221c:	6462                	ld	s0,24(sp)
    8020221e:	6105                	addi	sp,sp,32
    80202220:	8082                	ret

0000000080202222 <timeintr>:
#include "trap.h"
#include "riscv.h"  // 确保包含了这个头文件

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    80202222:	1141                	addi	sp,sp,-16
    80202224:	e422                	sd	s0,8(sp)
    80202226:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    80202228:	00004797          	auipc	a5,0x4
    8020222c:	e0078793          	addi	a5,a5,-512 # 80206028 <interrupt_test_flag>
    80202230:	639c                	ld	a5,0(a5)
    80202232:	cb99                	beqz	a5,80202248 <timeintr+0x26>
        (*interrupt_test_flag)++;
    80202234:	00004797          	auipc	a5,0x4
    80202238:	df478793          	addi	a5,a5,-524 # 80206028 <interrupt_test_flag>
    8020223c:	639c                	ld	a5,0(a5)
    8020223e:	4398                	lw	a4,0(a5)
    80202240:	2701                	sext.w	a4,a4
    80202242:	2705                	addiw	a4,a4,1
    80202244:	2701                	sext.w	a4,a4
    80202246:	c398                	sw	a4,0(a5)
    80202248:	0001                	nop
    8020224a:	6422                	ld	s0,8(sp)
    8020224c:	0141                	addi	sp,sp,16
    8020224e:	8082                	ret

0000000080202250 <r_sie>:
#include "plic.h"
#include "memlayout.h"
#include "timer.h"
#include "riscv.h"
#include "printf.h"
#include "sbi.h"
    80202250:	1101                	addi	sp,sp,-32
    80202252:	ec22                	sd	s0,24(sp)
    80202254:	1000                	addi	s0,sp,32
#include "uart.h"

    80202256:	104027f3          	csrr	a5,sie
    8020225a:	fef43423          	sd	a5,-24(s0)
// 全局测试变量，用于中断测试
    8020225e:	fe843783          	ld	a5,-24(s0)
volatile int *interrupt_test_flag = 0;
    80202262:	853e                	mv	a0,a5
    80202264:	6462                	ld	s0,24(sp)
    80202266:	6105                	addi	sp,sp,32
    80202268:	8082                	ret

000000008020226a <w_sie>:
extern void kernelvec();
interrupt_handler_t interrupt_vector[MAX_IRQ];
    8020226a:	1101                	addi	sp,sp,-32
    8020226c:	ec22                	sd	s0,24(sp)
    8020226e:	1000                	addi	s0,sp,32
    80202270:	fea43423          	sd	a0,-24(s0)
void register_interrupt(int irq, interrupt_handler_t h) {
    80202274:	fe843783          	ld	a5,-24(s0)
    80202278:	10479073          	csrw	sie,a5
    if (irq >= 0 && irq < MAX_IRQ){
    8020227c:	0001                	nop
    8020227e:	6462                	ld	s0,24(sp)
    80202280:	6105                	addi	sp,sp,32
    80202282:	8082                	ret

0000000080202284 <r_sstatus>:
        interrupt_vector[irq] = h;
	}
    80202284:	1101                	addi	sp,sp,-32
    80202286:	ec22                	sd	s0,24(sp)
    80202288:	1000                	addi	s0,sp,32
}

    8020228a:	100027f3          	csrr	a5,sstatus
    8020228e:	fef43423          	sd	a5,-24(s0)
void unregister_interrupt(int irq) {
    80202292:	fe843783          	ld	a5,-24(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    80202296:	853e                	mv	a0,a5
    80202298:	6462                	ld	s0,24(sp)
    8020229a:	6105                	addi	sp,sp,32
    8020229c:	8082                	ret

000000008020229e <w_sstatus>:
        interrupt_vector[irq] = 0;
    8020229e:	1101                	addi	sp,sp,-32
    802022a0:	ec22                	sd	s0,24(sp)
    802022a2:	1000                	addi	s0,sp,32
    802022a4:	fea43423          	sd	a0,-24(s0)
}
    802022a8:	fe843783          	ld	a5,-24(s0)
    802022ac:	10079073          	csrw	sstatus,a5
void enable_interrupts(int irq) {
    802022b0:	0001                	nop
    802022b2:	6462                	ld	s0,24(sp)
    802022b4:	6105                	addi	sp,sp,32
    802022b6:	8082                	ret

00000000802022b8 <w_sepc>:
    plic_enable(irq);
}

    802022b8:	1101                	addi	sp,sp,-32
    802022ba:	ec22                	sd	s0,24(sp)
    802022bc:	1000                	addi	s0,sp,32
    802022be:	fea43423          	sd	a0,-24(s0)
void disable_interrupts(int irq) {
    802022c2:	fe843783          	ld	a5,-24(s0)
    802022c6:	14179073          	csrw	sepc,a5
    plic_disable(irq);
    802022ca:	0001                	nop
    802022cc:	6462                	ld	s0,24(sp)
    802022ce:	6105                	addi	sp,sp,32
    802022d0:	8082                	ret

00000000802022d2 <intr_off>:
}

void interrupt_dispatch(int irq) {
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
		interrupt_vector[irq]();
	}
    802022d2:	1141                	addi	sp,sp,-16
    802022d4:	e406                	sd	ra,8(sp)
    802022d6:	e022                	sd	s0,0(sp)
    802022d8:	0800                	addi	s0,sp,16
}
    802022da:	00000097          	auipc	ra,0x0
    802022de:	faa080e7          	jalr	-86(ra) # 80202284 <r_sstatus>
    802022e2:	87aa                	mv	a5,a0
    802022e4:	9bf5                	andi	a5,a5,-3
    802022e6:	853e                	mv	a0,a5
    802022e8:	00000097          	auipc	ra,0x0
    802022ec:	fb6080e7          	jalr	-74(ra) # 8020229e <w_sstatus>
// 处理外部中断
    802022f0:	0001                	nop
    802022f2:	60a2                	ld	ra,8(sp)
    802022f4:	6402                	ld	s0,0(sp)
    802022f6:	0141                	addi	sp,sp,16
    802022f8:	8082                	ret

00000000802022fa <w_stvec>:
void handle_external_interrupt(void) {
    // 从PLIC获取中断号
    int irq = plic_claim();
    802022fa:	1101                	addi	sp,sp,-32
    802022fc:	ec22                	sd	s0,24(sp)
    802022fe:	1000                	addi	s0,sp,32
    80202300:	fea43423          	sd	a0,-24(s0)
    
    80202304:	fe843783          	ld	a5,-24(s0)
    80202308:	10579073          	csrw	stvec,a5
    if (irq == 0) {
    8020230c:	0001                	nop
    8020230e:	6462                	ld	s0,24(sp)
    80202310:	6105                	addi	sp,sp,32
    80202312:	8082                	ret

0000000080202314 <r_scause>:
        return;
    }
    interrupt_dispatch(irq);
    plic_complete(irq);
}

    80202314:	1101                	addi	sp,sp,-32
    80202316:	ec22                	sd	s0,24(sp)
    80202318:	1000                	addi	s0,sp,32
void trap_init(void) {
	intr_off();
    8020231a:	142027f3          	csrr	a5,scause
    8020231e:	fef43423          	sd	a5,-24(s0)
	printf("trap_init...\n");
    80202322:	fe843783          	ld	a5,-24(s0)
	w_stvec((uint64)kernelvec);
    80202326:	853e                	mv	a0,a5
    80202328:	6462                	ld	s0,24(sp)
    8020232a:	6105                	addi	sp,sp,32
    8020232c:	8082                	ret

000000008020232e <r_sepc>:
	for(int i = 0; i < MAX_IRQ; i++){
		interrupt_vector[i] = 0;
    8020232e:	1101                	addi	sp,sp,-32
    80202330:	ec22                	sd	s0,24(sp)
    80202332:	1000                	addi	s0,sp,32
	}
	plic_init();
    80202334:	141027f3          	csrr	a5,sepc
    80202338:	fef43423          	sd	a5,-24(s0)
    uint64 sie = r_sie();
    8020233c:	fe843783          	ld	a5,-24(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    80202340:	853e                	mv	a0,a5
    80202342:	6462                	ld	s0,24(sp)
    80202344:	6105                	addi	sp,sp,32
    80202346:	8082                	ret

0000000080202348 <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    80202348:	1101                	addi	sp,sp,-32
    8020234a:	ec22                	sd	s0,24(sp)
    8020234c:	1000                	addi	s0,sp,32
    8020234e:	87aa                	mv	a5,a0
    80202350:	feb43023          	sd	a1,-32(s0)
    80202354:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    80202358:	fec42783          	lw	a5,-20(s0)
    8020235c:	2781                	sext.w	a5,a5
    8020235e:	0207c563          	bltz	a5,80202388 <register_interrupt+0x40>
    80202362:	fec42783          	lw	a5,-20(s0)
    80202366:	0007871b          	sext.w	a4,a5
    8020236a:	03f00793          	li	a5,63
    8020236e:	00e7cd63          	blt	a5,a4,80202388 <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    80202372:	00004717          	auipc	a4,0x4
    80202376:	d4e70713          	addi	a4,a4,-690 # 802060c0 <interrupt_vector>
    8020237a:	fec42783          	lw	a5,-20(s0)
    8020237e:	078e                	slli	a5,a5,0x3
    80202380:	97ba                	add	a5,a5,a4
    80202382:	fe043703          	ld	a4,-32(s0)
    80202386:	e398                	sd	a4,0(a5)
}
    80202388:	0001                	nop
    8020238a:	6462                	ld	s0,24(sp)
    8020238c:	6105                	addi	sp,sp,32
    8020238e:	8082                	ret

0000000080202390 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    80202390:	1101                	addi	sp,sp,-32
    80202392:	ec22                	sd	s0,24(sp)
    80202394:	1000                	addi	s0,sp,32
    80202396:	87aa                	mv	a5,a0
    80202398:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    8020239c:	fec42783          	lw	a5,-20(s0)
    802023a0:	2781                	sext.w	a5,a5
    802023a2:	0207c463          	bltz	a5,802023ca <unregister_interrupt+0x3a>
    802023a6:	fec42783          	lw	a5,-20(s0)
    802023aa:	0007871b          	sext.w	a4,a5
    802023ae:	03f00793          	li	a5,63
    802023b2:	00e7cc63          	blt	a5,a4,802023ca <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    802023b6:	00004717          	auipc	a4,0x4
    802023ba:	d0a70713          	addi	a4,a4,-758 # 802060c0 <interrupt_vector>
    802023be:	fec42783          	lw	a5,-20(s0)
    802023c2:	078e                	slli	a5,a5,0x3
    802023c4:	97ba                	add	a5,a5,a4
    802023c6:	0007b023          	sd	zero,0(a5)
}
    802023ca:	0001                	nop
    802023cc:	6462                	ld	s0,24(sp)
    802023ce:	6105                	addi	sp,sp,32
    802023d0:	8082                	ret

00000000802023d2 <enable_interrupts>:
void enable_interrupts(int irq) {
    802023d2:	1101                	addi	sp,sp,-32
    802023d4:	ec06                	sd	ra,24(sp)
    802023d6:	e822                	sd	s0,16(sp)
    802023d8:	1000                	addi	s0,sp,32
    802023da:	87aa                	mv	a5,a0
    802023dc:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    802023e0:	fec42783          	lw	a5,-20(s0)
    802023e4:	853e                	mv	a0,a5
    802023e6:	00000097          	auipc	ra,0x0
    802023ea:	4a4080e7          	jalr	1188(ra) # 8020288a <plic_enable>
}
    802023ee:	0001                	nop
    802023f0:	60e2                	ld	ra,24(sp)
    802023f2:	6442                	ld	s0,16(sp)
    802023f4:	6105                	addi	sp,sp,32
    802023f6:	8082                	ret

00000000802023f8 <disable_interrupts>:
void disable_interrupts(int irq) {
    802023f8:	1101                	addi	sp,sp,-32
    802023fa:	ec06                	sd	ra,24(sp)
    802023fc:	e822                	sd	s0,16(sp)
    802023fe:	1000                	addi	s0,sp,32
    80202400:	87aa                	mv	a5,a0
    80202402:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    80202406:	fec42783          	lw	a5,-20(s0)
    8020240a:	853e                	mv	a0,a5
    8020240c:	00000097          	auipc	ra,0x0
    80202410:	4d6080e7          	jalr	1238(ra) # 802028e2 <plic_disable>
}
    80202414:	0001                	nop
    80202416:	60e2                	ld	ra,24(sp)
    80202418:	6442                	ld	s0,16(sp)
    8020241a:	6105                	addi	sp,sp,32
    8020241c:	8082                	ret

000000008020241e <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    8020241e:	1101                	addi	sp,sp,-32
    80202420:	ec06                	sd	ra,24(sp)
    80202422:	e822                	sd	s0,16(sp)
    80202424:	1000                	addi	s0,sp,32
    80202426:	87aa                	mv	a5,a0
    80202428:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    8020242c:	fec42783          	lw	a5,-20(s0)
    80202430:	2781                	sext.w	a5,a5
    80202432:	0207ce63          	bltz	a5,8020246e <interrupt_dispatch+0x50>
    80202436:	fec42783          	lw	a5,-20(s0)
    8020243a:	0007871b          	sext.w	a4,a5
    8020243e:	03f00793          	li	a5,63
    80202442:	02e7c663          	blt	a5,a4,8020246e <interrupt_dispatch+0x50>
    80202446:	00004717          	auipc	a4,0x4
    8020244a:	c7a70713          	addi	a4,a4,-902 # 802060c0 <interrupt_vector>
    8020244e:	fec42783          	lw	a5,-20(s0)
    80202452:	078e                	slli	a5,a5,0x3
    80202454:	97ba                	add	a5,a5,a4
    80202456:	639c                	ld	a5,0(a5)
    80202458:	cb99                	beqz	a5,8020246e <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    8020245a:	00004717          	auipc	a4,0x4
    8020245e:	c6670713          	addi	a4,a4,-922 # 802060c0 <interrupt_vector>
    80202462:	fec42783          	lw	a5,-20(s0)
    80202466:	078e                	slli	a5,a5,0x3
    80202468:	97ba                	add	a5,a5,a4
    8020246a:	639c                	ld	a5,0(a5)
    8020246c:	9782                	jalr	a5
}
    8020246e:	0001                	nop
    80202470:	60e2                	ld	ra,24(sp)
    80202472:	6442                	ld	s0,16(sp)
    80202474:	6105                	addi	sp,sp,32
    80202476:	8082                	ret

0000000080202478 <handle_external_interrupt>:
void handle_external_interrupt(void) {
    80202478:	1101                	addi	sp,sp,-32
    8020247a:	ec06                	sd	ra,24(sp)
    8020247c:	e822                	sd	s0,16(sp)
    8020247e:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    80202480:	00000097          	auipc	ra,0x0
    80202484:	4c0080e7          	jalr	1216(ra) # 80202940 <plic_claim>
    80202488:	87aa                	mv	a5,a0
    8020248a:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    8020248e:	fec42783          	lw	a5,-20(s0)
    80202492:	2781                	sext.w	a5,a5
    80202494:	eb91                	bnez	a5,802024a8 <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    80202496:	00002517          	auipc	a0,0x2
    8020249a:	ada50513          	addi	a0,a0,-1318 # 80203f70 <small_numbers+0xdd0>
    8020249e:	ffffe097          	auipc	ra,0xffffe
    802024a2:	116080e7          	jalr	278(ra) # 802005b4 <printf>
        return;
    802024a6:	a839                	j	802024c4 <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    802024a8:	fec42783          	lw	a5,-20(s0)
    802024ac:	853e                	mv	a0,a5
    802024ae:	00000097          	auipc	ra,0x0
    802024b2:	f70080e7          	jalr	-144(ra) # 8020241e <interrupt_dispatch>
    plic_complete(irq);
    802024b6:	fec42783          	lw	a5,-20(s0)
    802024ba:	853e                	mv	a0,a5
    802024bc:	00000097          	auipc	ra,0x0
    802024c0:	4ac080e7          	jalr	1196(ra) # 80202968 <plic_complete>
}
    802024c4:	60e2                	ld	ra,24(sp)
    802024c6:	6442                	ld	s0,16(sp)
    802024c8:	6105                	addi	sp,sp,32
    802024ca:	8082                	ret

00000000802024cc <trap_init>:
void trap_init(void) {
    802024cc:	1101                	addi	sp,sp,-32
    802024ce:	ec06                	sd	ra,24(sp)
    802024d0:	e822                	sd	s0,16(sp)
    802024d2:	1000                	addi	s0,sp,32
	intr_off();
    802024d4:	00000097          	auipc	ra,0x0
    802024d8:	dfe080e7          	jalr	-514(ra) # 802022d2 <intr_off>
	printf("trap_init...\n");
    802024dc:	00002517          	auipc	a0,0x2
    802024e0:	ab450513          	addi	a0,a0,-1356 # 80203f90 <small_numbers+0xdf0>
    802024e4:	ffffe097          	auipc	ra,0xffffe
    802024e8:	0d0080e7          	jalr	208(ra) # 802005b4 <printf>
	w_stvec((uint64)kernelvec);
    802024ec:	00000797          	auipc	a5,0x0
    802024f0:	4b478793          	addi	a5,a5,1204 # 802029a0 <kernelvec>
    802024f4:	853e                	mv	a0,a5
    802024f6:	00000097          	auipc	ra,0x0
    802024fa:	e04080e7          	jalr	-508(ra) # 802022fa <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    802024fe:	fe042623          	sw	zero,-20(s0)
    80202502:	a005                	j	80202522 <trap_init+0x56>
		interrupt_vector[i] = 0;
    80202504:	00004717          	auipc	a4,0x4
    80202508:	bbc70713          	addi	a4,a4,-1092 # 802060c0 <interrupt_vector>
    8020250c:	fec42783          	lw	a5,-20(s0)
    80202510:	078e                	slli	a5,a5,0x3
    80202512:	97ba                	add	a5,a5,a4
    80202514:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    80202518:	fec42783          	lw	a5,-20(s0)
    8020251c:	2785                	addiw	a5,a5,1
    8020251e:	fef42623          	sw	a5,-20(s0)
    80202522:	fec42783          	lw	a5,-20(s0)
    80202526:	0007871b          	sext.w	a4,a5
    8020252a:	03f00793          	li	a5,63
    8020252e:	fce7dbe3          	bge	a5,a4,80202504 <trap_init+0x38>
	plic_init();
    80202532:	00000097          	auipc	ra,0x0
    80202536:	2ba080e7          	jalr	698(ra) # 802027ec <plic_init>
    uint64 sie = r_sie();
    8020253a:	00000097          	auipc	ra,0x0
    8020253e:	d16080e7          	jalr	-746(ra) # 80202250 <r_sie>
    80202542:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    80202546:	fe043783          	ld	a5,-32(s0)
    8020254a:	2207e793          	ori	a5,a5,544
    8020254e:	853e                	mv	a0,a5
    80202550:	00000097          	auipc	ra,0x0
    80202554:	d1a080e7          	jalr	-742(ra) # 8020226a <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80202558:	00000097          	auipc	ra,0x0
    8020255c:	cb0080e7          	jalr	-848(ra) # 80202208 <sbi_get_time>
    80202560:	872a                	mv	a4,a0
    80202562:	000f47b7          	lui	a5,0xf4
    80202566:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    8020256a:	97ba                	add	a5,a5,a4
    8020256c:	853e                	mv	a0,a5
    8020256e:	00000097          	auipc	ra,0x0
    80202572:	c7e080e7          	jalr	-898(ra) # 802021ec <sbi_set_time>
	printf("trap_init complete.\n");
    80202576:	00002517          	auipc	a0,0x2
    8020257a:	a2a50513          	addi	a0,a0,-1494 # 80203fa0 <small_numbers+0xe00>
    8020257e:	ffffe097          	auipc	ra,0xffffe
    80202582:	036080e7          	jalr	54(ra) # 802005b4 <printf>
}
    80202586:	0001                	nop
    80202588:	60e2                	ld	ra,24(sp)
    8020258a:	6442                	ld	s0,16(sp)
    8020258c:	6105                	addi	sp,sp,32
    8020258e:	8082                	ret

0000000080202590 <kerneltrap>:
// 中断处理函数
void kerneltrap(void) {
    80202590:	7179                	addi	sp,sp,-48
    80202592:	f406                	sd	ra,40(sp)
    80202594:	f022                	sd	s0,32(sp)
    80202596:	1800                	addi	s0,sp,48
    // 保存当前中断状态
    uint64 sstatus = r_sstatus();
    80202598:	00000097          	auipc	ra,0x0
    8020259c:	cec080e7          	jalr	-788(ra) # 80202284 <r_sstatus>
    802025a0:	fea43423          	sd	a0,-24(s0)
    uint64 scause = r_scause();
    802025a4:	00000097          	auipc	ra,0x0
    802025a8:	d70080e7          	jalr	-656(ra) # 80202314 <r_scause>
    802025ac:	fea43023          	sd	a0,-32(s0)
    uint64 sepc = r_sepc();
    802025b0:	00000097          	auipc	ra,0x0
    802025b4:	d7e080e7          	jalr	-642(ra) # 8020232e <r_sepc>
    802025b8:	fca43c23          	sd	a0,-40(s0)
    
    if((scause & 0x8000000000000000) && ((scause & 0xff) == 5)) {
    802025bc:	fe043783          	ld	a5,-32(s0)
    802025c0:	0207dd63          	bgez	a5,802025fa <kerneltrap+0x6a>
    802025c4:	fe043783          	ld	a5,-32(s0)
    802025c8:	0ff7f713          	zext.b	a4,a5
    802025cc:	4795                	li	a5,5
    802025ce:	02f71663          	bne	a4,a5,802025fa <kerneltrap+0x6a>
        // 调用时钟中断处理函数
        timeintr();
    802025d2:	00000097          	auipc	ra,0x0
    802025d6:	c50080e7          	jalr	-944(ra) # 80202222 <timeintr>
        // 设置下一次时钟中断 - 使用较短间隔用于测试
        sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802025da:	00000097          	auipc	ra,0x0
    802025de:	c2e080e7          	jalr	-978(ra) # 80202208 <sbi_get_time>
    802025e2:	872a                	mv	a4,a0
    802025e4:	000f47b7          	lui	a5,0xf4
    802025e8:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802025ec:	97ba                	add	a5,a5,a4
    802025ee:	853e                	mv	a0,a5
    802025f0:	00000097          	auipc	ra,0x0
    802025f4:	bfc080e7          	jalr	-1028(ra) # 802021ec <sbi_set_time>
    802025f8:	a83d                	j	80202636 <kerneltrap+0xa6>
    }else if((scause & 0x8000000000000000) && ((scause & 0xff) == 9)) {
    802025fa:	fe043783          	ld	a5,-32(s0)
    802025fe:	0007de63          	bgez	a5,8020261a <kerneltrap+0x8a>
    80202602:	fe043783          	ld	a5,-32(s0)
    80202606:	0ff7f713          	zext.b	a4,a5
    8020260a:	47a5                	li	a5,9
    8020260c:	00f71763          	bne	a4,a5,8020261a <kerneltrap+0x8a>
        // 处理外部中断
        handle_external_interrupt();
    80202610:	00000097          	auipc	ra,0x0
    80202614:	e68080e7          	jalr	-408(ra) # 80202478 <handle_external_interrupt>
    80202618:	a839                	j	80202636 <kerneltrap+0xa6>
    }else {
        printf("kerneltrap: unexpected scause=%lx sepc=%lx\n", scause, sepc);
    8020261a:	fd843603          	ld	a2,-40(s0)
    8020261e:	fe043583          	ld	a1,-32(s0)
    80202622:	00002517          	auipc	a0,0x2
    80202626:	99650513          	addi	a0,a0,-1642 # 80203fb8 <small_numbers+0xe18>
    8020262a:	ffffe097          	auipc	ra,0xffffe
    8020262e:	f8a080e7          	jalr	-118(ra) # 802005b4 <printf>
        while(1); // 出现问题时挂起系统
    80202632:	0001                	nop
    80202634:	bffd                	j	80202632 <kerneltrap+0xa2>
    }
    
    // 恢复中断现场
    w_sepc(sepc);
    80202636:	fd843503          	ld	a0,-40(s0)
    8020263a:	00000097          	auipc	ra,0x0
    8020263e:	c7e080e7          	jalr	-898(ra) # 802022b8 <w_sepc>
    w_sstatus(sstatus);
    80202642:	fe843503          	ld	a0,-24(s0)
    80202646:	00000097          	auipc	ra,0x0
    8020264a:	c58080e7          	jalr	-936(ra) # 8020229e <w_sstatus>
}
    8020264e:	0001                	nop
    80202650:	70a2                	ld	ra,40(sp)
    80202652:	7402                	ld	s0,32(sp)
    80202654:	6145                	addi	sp,sp,48
    80202656:	8082                	ret

0000000080202658 <get_time>:

// 获取当前时间的辅助函数
uint64 get_time(void) {
    80202658:	1141                	addi	sp,sp,-16
    8020265a:	e406                	sd	ra,8(sp)
    8020265c:	e022                	sd	s0,0(sp)
    8020265e:	0800                	addi	s0,sp,16
    return sbi_get_time();
    80202660:	00000097          	auipc	ra,0x0
    80202664:	ba8080e7          	jalr	-1112(ra) # 80202208 <sbi_get_time>
    80202668:	87aa                	mv	a5,a0
}
    8020266a:	853e                	mv	a0,a5
    8020266c:	60a2                	ld	ra,8(sp)
    8020266e:	6402                	ld	s0,0(sp)
    80202670:	0141                	addi	sp,sp,16
    80202672:	8082                	ret

0000000080202674 <test_timer_interrupt>:

// 时钟中断测试函数
void test_timer_interrupt(void) {
    80202674:	7179                	addi	sp,sp,-48
    80202676:	f406                	sd	ra,40(sp)
    80202678:	f022                	sd	s0,32(sp)
    8020267a:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    8020267c:	00002517          	auipc	a0,0x2
    80202680:	96c50513          	addi	a0,a0,-1684 # 80203fe8 <small_numbers+0xe48>
    80202684:	ffffe097          	auipc	ra,0xffffe
    80202688:	f30080e7          	jalr	-208(ra) # 802005b4 <printf>

    // 记录中断前的时间
    uint64 start_time = get_time();
    8020268c:	00000097          	auipc	ra,0x0
    80202690:	fcc080e7          	jalr	-52(ra) # 80202658 <get_time>
    80202694:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    80202698:	fc042a23          	sw	zero,-44(s0)
	int last_count = interrupt_count;
    8020269c:	fd442783          	lw	a5,-44(s0)
    802026a0:	fef42623          	sw	a5,-20(s0)
    // 设置测试标志
    interrupt_test_flag = &interrupt_count;
    802026a4:	00004797          	auipc	a5,0x4
    802026a8:	98478793          	addi	a5,a5,-1660 # 80206028 <interrupt_test_flag>
    802026ac:	fd440713          	addi	a4,s0,-44
    802026b0:	e398                	sd	a4,0(a5)

    // 等待几次中断
    while (interrupt_count < 5) {
    802026b2:	a899                	j	80202708 <test_timer_interrupt+0x94>
        if(last_count != interrupt_count) {
    802026b4:	fd442703          	lw	a4,-44(s0)
    802026b8:	fec42783          	lw	a5,-20(s0)
    802026bc:	2781                	sext.w	a5,a5
    802026be:	02e78163          	beq	a5,a4,802026e0 <test_timer_interrupt+0x6c>
			last_count = interrupt_count;
    802026c2:	fd442783          	lw	a5,-44(s0)
    802026c6:	fef42623          	sw	a5,-20(s0)
			printf("Received interrupt %d\n", interrupt_count);
    802026ca:	fd442783          	lw	a5,-44(s0)
    802026ce:	85be                	mv	a1,a5
    802026d0:	00002517          	auipc	a0,0x2
    802026d4:	93850513          	addi	a0,a0,-1736 # 80204008 <small_numbers+0xe68>
    802026d8:	ffffe097          	auipc	ra,0xffffe
    802026dc:	edc080e7          	jalr	-292(ra) # 802005b4 <printf>
		}
        // 简单延时
        for (volatile int i = 0; i < 1000000; i++);
    802026e0:	fc042823          	sw	zero,-48(s0)
    802026e4:	a801                	j	802026f4 <test_timer_interrupt+0x80>
    802026e6:	fd042783          	lw	a5,-48(s0)
    802026ea:	2781                	sext.w	a5,a5
    802026ec:	2785                	addiw	a5,a5,1
    802026ee:	2781                	sext.w	a5,a5
    802026f0:	fcf42823          	sw	a5,-48(s0)
    802026f4:	fd042783          	lw	a5,-48(s0)
    802026f8:	2781                	sext.w	a5,a5
    802026fa:	873e                	mv	a4,a5
    802026fc:	000f47b7          	lui	a5,0xf4
    80202700:	23f78793          	addi	a5,a5,575 # f423f <_entry-0x8010bdc1>
    80202704:	fee7d1e3          	bge	a5,a4,802026e6 <test_timer_interrupt+0x72>
    while (interrupt_count < 5) {
    80202708:	fd442783          	lw	a5,-44(s0)
    8020270c:	873e                	mv	a4,a5
    8020270e:	4791                	li	a5,4
    80202710:	fae7d2e3          	bge	a5,a4,802026b4 <test_timer_interrupt+0x40>
    }

    // 测试结束，清除标志
    interrupt_test_flag = 0;
    80202714:	00004797          	auipc	a5,0x4
    80202718:	91478793          	addi	a5,a5,-1772 # 80206028 <interrupt_test_flag>
    8020271c:	0007b023          	sd	zero,0(a5)

    uint64 end_time = get_time();
    80202720:	00000097          	auipc	ra,0x0
    80202724:	f38080e7          	jalr	-200(ra) # 80202658 <get_time>
    80202728:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    8020272c:	fd442683          	lw	a3,-44(s0)
    80202730:	fd843703          	ld	a4,-40(s0)
    80202734:	fe043783          	ld	a5,-32(s0)
    80202738:	40f707b3          	sub	a5,a4,a5
    8020273c:	863e                	mv	a2,a5
    8020273e:	85b6                	mv	a1,a3
    80202740:	00002517          	auipc	a0,0x2
    80202744:	8e050513          	addi	a0,a0,-1824 # 80204020 <small_numbers+0xe80>
    80202748:	ffffe097          	auipc	ra,0xffffe
    8020274c:	e6c080e7          	jalr	-404(ra) # 802005b4 <printf>
           interrupt_count, end_time - start_time);
    80202750:	0001                	nop
    80202752:	70a2                	ld	ra,40(sp)
    80202754:	7402                	ld	s0,32(sp)
    80202756:	6145                	addi	sp,sp,48
    80202758:	8082                	ret

000000008020275a <write32>:
    8020275a:	7179                	addi	sp,sp,-48
    8020275c:	f406                	sd	ra,40(sp)
    8020275e:	f022                	sd	s0,32(sp)
    80202760:	1800                	addi	s0,sp,48
    80202762:	fca43c23          	sd	a0,-40(s0)
    80202766:	87ae                	mv	a5,a1
    80202768:	fcf42a23          	sw	a5,-44(s0)
    8020276c:	fd843783          	ld	a5,-40(s0)
    80202770:	8b8d                	andi	a5,a5,3
    80202772:	eb99                	bnez	a5,80202788 <write32+0x2e>
    80202774:	fd843783          	ld	a5,-40(s0)
    80202778:	fef43423          	sd	a5,-24(s0)
    8020277c:	fe843783          	ld	a5,-24(s0)
    80202780:	fd442703          	lw	a4,-44(s0)
    80202784:	c398                	sw	a4,0(a5)
    80202786:	a819                	j	8020279c <write32+0x42>
    80202788:	fd843583          	ld	a1,-40(s0)
    8020278c:	00002517          	auipc	a0,0x2
    80202790:	8cc50513          	addi	a0,a0,-1844 # 80204058 <small_numbers+0xeb8>
    80202794:	ffffe097          	auipc	ra,0xffffe
    80202798:	e20080e7          	jalr	-480(ra) # 802005b4 <printf>
    8020279c:	0001                	nop
    8020279e:	70a2                	ld	ra,40(sp)
    802027a0:	7402                	ld	s0,32(sp)
    802027a2:	6145                	addi	sp,sp,48
    802027a4:	8082                	ret

00000000802027a6 <read32>:
    802027a6:	7179                	addi	sp,sp,-48
    802027a8:	f406                	sd	ra,40(sp)
    802027aa:	f022                	sd	s0,32(sp)
    802027ac:	1800                	addi	s0,sp,48
    802027ae:	fca43c23          	sd	a0,-40(s0)
    802027b2:	fd843783          	ld	a5,-40(s0)
    802027b6:	8b8d                	andi	a5,a5,3
    802027b8:	eb91                	bnez	a5,802027cc <read32+0x26>
    802027ba:	fd843783          	ld	a5,-40(s0)
    802027be:	fef43423          	sd	a5,-24(s0)
    802027c2:	fe843783          	ld	a5,-24(s0)
    802027c6:	439c                	lw	a5,0(a5)
    802027c8:	2781                	sext.w	a5,a5
    802027ca:	a821                	j	802027e2 <read32+0x3c>
    802027cc:	fd843583          	ld	a1,-40(s0)
    802027d0:	00002517          	auipc	a0,0x2
    802027d4:	8b850513          	addi	a0,a0,-1864 # 80204088 <small_numbers+0xee8>
    802027d8:	ffffe097          	auipc	ra,0xffffe
    802027dc:	ddc080e7          	jalr	-548(ra) # 802005b4 <printf>
    802027e0:	4781                	li	a5,0
    802027e2:	853e                	mv	a0,a5
    802027e4:	70a2                	ld	ra,40(sp)
    802027e6:	7402                	ld	s0,32(sp)
    802027e8:	6145                	addi	sp,sp,48
    802027ea:	8082                	ret

00000000802027ec <plic_init>:
void plic_init(void) {
    802027ec:	1101                	addi	sp,sp,-32
    802027ee:	ec06                	sd	ra,24(sp)
    802027f0:	e822                	sd	s0,16(sp)
    802027f2:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    802027f4:	4785                	li	a5,1
    802027f6:	fef42623          	sw	a5,-20(s0)
    802027fa:	a805                	j	8020282a <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    802027fc:	fec42783          	lw	a5,-20(s0)
    80202800:	0027979b          	slliw	a5,a5,0x2
    80202804:	2781                	sext.w	a5,a5
    80202806:	873e                	mv	a4,a5
    80202808:	0c0007b7          	lui	a5,0xc000
    8020280c:	97ba                	add	a5,a5,a4
    8020280e:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80202812:	4581                	li	a1,0
    80202814:	fe043503          	ld	a0,-32(s0)
    80202818:	00000097          	auipc	ra,0x0
    8020281c:	f42080e7          	jalr	-190(ra) # 8020275a <write32>
    for (int i = 1; i <= 32; i++) {
    80202820:	fec42783          	lw	a5,-20(s0)
    80202824:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    80202826:	fef42623          	sw	a5,-20(s0)
    8020282a:	fec42783          	lw	a5,-20(s0)
    8020282e:	0007871b          	sext.w	a4,a5
    80202832:	02000793          	li	a5,32
    80202836:	fce7d3e3          	bge	a5,a4,802027fc <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    8020283a:	4585                	li	a1,1
    8020283c:	0c0007b7          	lui	a5,0xc000
    80202840:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    80202844:	00000097          	auipc	ra,0x0
    80202848:	f16080e7          	jalr	-234(ra) # 8020275a <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    8020284c:	4585                	li	a1,1
    8020284e:	0c0007b7          	lui	a5,0xc000
    80202852:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    80202856:	00000097          	auipc	ra,0x0
    8020285a:	f04080e7          	jalr	-252(ra) # 8020275a <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    8020285e:	40200593          	li	a1,1026
    80202862:	0c0027b7          	lui	a5,0xc002
    80202866:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    8020286a:	00000097          	auipc	ra,0x0
    8020286e:	ef0080e7          	jalr	-272(ra) # 8020275a <write32>
    write32(PLIC_THRESHOLD, 0);
    80202872:	4581                	li	a1,0
    80202874:	0c201537          	lui	a0,0xc201
    80202878:	00000097          	auipc	ra,0x0
    8020287c:	ee2080e7          	jalr	-286(ra) # 8020275a <write32>
}
    80202880:	0001                	nop
    80202882:	60e2                	ld	ra,24(sp)
    80202884:	6442                	ld	s0,16(sp)
    80202886:	6105                	addi	sp,sp,32
    80202888:	8082                	ret

000000008020288a <plic_enable>:
void plic_enable(int irq) {
    8020288a:	7179                	addi	sp,sp,-48
    8020288c:	f406                	sd	ra,40(sp)
    8020288e:	f022                	sd	s0,32(sp)
    80202890:	1800                	addi	s0,sp,48
    80202892:	87aa                	mv	a5,a0
    80202894:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80202898:	0c0027b7          	lui	a5,0xc002
    8020289c:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802028a0:	00000097          	auipc	ra,0x0
    802028a4:	f06080e7          	jalr	-250(ra) # 802027a6 <read32>
    802028a8:	87aa                	mv	a5,a0
    802028aa:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    802028ae:	fdc42783          	lw	a5,-36(s0)
    802028b2:	873e                	mv	a4,a5
    802028b4:	4785                	li	a5,1
    802028b6:	00e797bb          	sllw	a5,a5,a4
    802028ba:	2781                	sext.w	a5,a5
    802028bc:	2781                	sext.w	a5,a5
    802028be:	fec42703          	lw	a4,-20(s0)
    802028c2:	8fd9                	or	a5,a5,a4
    802028c4:	2781                	sext.w	a5,a5
    802028c6:	85be                	mv	a1,a5
    802028c8:	0c0027b7          	lui	a5,0xc002
    802028cc:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802028d0:	00000097          	auipc	ra,0x0
    802028d4:	e8a080e7          	jalr	-374(ra) # 8020275a <write32>
}
    802028d8:	0001                	nop
    802028da:	70a2                	ld	ra,40(sp)
    802028dc:	7402                	ld	s0,32(sp)
    802028de:	6145                	addi	sp,sp,48
    802028e0:	8082                	ret

00000000802028e2 <plic_disable>:
void plic_disable(int irq) {
    802028e2:	7179                	addi	sp,sp,-48
    802028e4:	f406                	sd	ra,40(sp)
    802028e6:	f022                	sd	s0,32(sp)
    802028e8:	1800                	addi	s0,sp,48
    802028ea:	87aa                	mv	a5,a0
    802028ec:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    802028f0:	0c0027b7          	lui	a5,0xc002
    802028f4:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802028f8:	00000097          	auipc	ra,0x0
    802028fc:	eae080e7          	jalr	-338(ra) # 802027a6 <read32>
    80202900:	87aa                	mv	a5,a0
    80202902:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    80202906:	fdc42783          	lw	a5,-36(s0)
    8020290a:	873e                	mv	a4,a5
    8020290c:	4785                	li	a5,1
    8020290e:	00e797bb          	sllw	a5,a5,a4
    80202912:	2781                	sext.w	a5,a5
    80202914:	fff7c793          	not	a5,a5
    80202918:	2781                	sext.w	a5,a5
    8020291a:	2781                	sext.w	a5,a5
    8020291c:	fec42703          	lw	a4,-20(s0)
    80202920:	8ff9                	and	a5,a5,a4
    80202922:	2781                	sext.w	a5,a5
    80202924:	85be                	mv	a1,a5
    80202926:	0c0027b7          	lui	a5,0xc002
    8020292a:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    8020292e:	00000097          	auipc	ra,0x0
    80202932:	e2c080e7          	jalr	-468(ra) # 8020275a <write32>
}
    80202936:	0001                	nop
    80202938:	70a2                	ld	ra,40(sp)
    8020293a:	7402                	ld	s0,32(sp)
    8020293c:	6145                	addi	sp,sp,48
    8020293e:	8082                	ret

0000000080202940 <plic_claim>:
int plic_claim(void) {
    80202940:	1141                	addi	sp,sp,-16
    80202942:	e406                	sd	ra,8(sp)
    80202944:	e022                	sd	s0,0(sp)
    80202946:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    80202948:	0c2017b7          	lui	a5,0xc201
    8020294c:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80202950:	00000097          	auipc	ra,0x0
    80202954:	e56080e7          	jalr	-426(ra) # 802027a6 <read32>
    80202958:	87aa                	mv	a5,a0
    8020295a:	2781                	sext.w	a5,a5
    8020295c:	2781                	sext.w	a5,a5
}
    8020295e:	853e                	mv	a0,a5
    80202960:	60a2                	ld	ra,8(sp)
    80202962:	6402                	ld	s0,0(sp)
    80202964:	0141                	addi	sp,sp,16
    80202966:	8082                	ret

0000000080202968 <plic_complete>:
void plic_complete(int irq) {
    80202968:	1101                	addi	sp,sp,-32
    8020296a:	ec06                	sd	ra,24(sp)
    8020296c:	e822                	sd	s0,16(sp)
    8020296e:	1000                	addi	s0,sp,32
    80202970:	87aa                	mv	a5,a0
    80202972:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    80202976:	fec42783          	lw	a5,-20(s0)
    8020297a:	85be                	mv	a1,a5
    8020297c:	0c2017b7          	lui	a5,0xc201
    80202980:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80202984:	00000097          	auipc	ra,0x0
    80202988:	dd6080e7          	jalr	-554(ra) # 8020275a <write32>
    8020298c:	0001                	nop
    8020298e:	60e2                	ld	ra,24(sp)
    80202990:	6442                	ld	s0,16(sp)
    80202992:	6105                	addi	sp,sp,32
    80202994:	8082                	ret
	...

00000000802029a0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    802029a0:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    802029a2:	e006                	sd	ra,0(sp)
        # 注意：不保存sp，因为我们已经修改了它
        sd gp, 16(sp)
    802029a4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    802029a6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    802029a8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    802029aa:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    802029ac:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    802029ae:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    802029b0:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    802029b2:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    802029b4:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    802029b6:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    802029b8:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    802029ba:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    802029bc:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    802029be:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    802029c0:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    802029c2:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    802029c4:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    802029c6:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    802029c8:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    802029ca:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    802029cc:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    802029ce:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    802029d0:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    802029d2:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    802029d4:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    802029d6:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    802029d8:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    802029da:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    802029dc:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    802029de:	00000097          	auipc	ra,0x0
    802029e2:	bb2080e7          	jalr	-1102(ra) # 80202590 <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    802029e6:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    802029e8:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    802029ea:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    802029ec:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    802029ee:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    802029f0:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    802029f2:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    802029f4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    802029f6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    802029f8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    802029fa:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    802029fc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    802029fe:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80202a00:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80202a02:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80202a04:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80202a06:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80202a08:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    80202a0a:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    80202a0c:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    80202a0e:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80202a10:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80202a12:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80202a14:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80202a16:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80202a18:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80202a1a:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80202a1c:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80202a1e:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80202a20:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80202a22:	10200073          	sret
    80202a26:	0001                	nop
    80202a28:	00000013          	nop
    80202a2c:	00000013          	nop
	...
