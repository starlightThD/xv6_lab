
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80200000:	00006117          	auipc	sp,0x6
    80200004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80200008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8020000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8020000c:	00007517          	auipc	a0,0x7
    80200010:	01450513          	addi	a0,a0,20 # 80207020 <kernel_pagetable>
        la a1,_bss_end
    80200014:	00007597          	auipc	a1,0x7
    80200018:	2ac58593          	addi	a1,a1,684 # 802072c0 <_bss_end>

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
    80200032:	1101                	addi	sp,sp,-32 # 80205fe0 <small_numbers+0x1e18>
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
    8020009c:	16e080e7          	jalr	366(ra) # 80202206 <pmm_init>
	printf("[VP TEST] 尝试启用分页模式\n");
    802000a0:	00004517          	auipc	a0,0x4
    802000a4:	f6050513          	addi	a0,a0,-160 # 80204000 <etext>
    802000a8:	00000097          	auipc	ra,0x0
    802000ac:	4c0080e7          	jalr	1216(ra) # 80200568 <printf>
	kvminit();
    802000b0:	00002097          	auipc	ra,0x2
    802000b4:	b64080e7          	jalr	-1180(ra) # 80201c14 <kvminit>
    kvminithart();
    802000b8:	00002097          	auipc	ra,0x2
    802000bc:	bae080e7          	jalr	-1106(ra) # 80201c66 <kvminithart>
    clear_screen();
    802000c0:	00001097          	auipc	ra,0x1
    802000c4:	8a0080e7          	jalr	-1888(ra) # 80200960 <clear_screen>
    uart_puts("===============================================\n");
    802000c8:	00004517          	auipc	a0,0x4
    802000cc:	f6050513          	addi	a0,a0,-160 # 80204028 <etext+0x28>
    802000d0:	00000097          	auipc	ra,0x0
    802000d4:	12e080e7          	jalr	302(ra) # 802001fe <uart_puts>
    uart_puts("        RISC-V Operating System v1.0         \n");
    802000d8:	00004517          	auipc	a0,0x4
    802000dc:	f8850513          	addi	a0,a0,-120 # 80204060 <etext+0x60>
    802000e0:	00000097          	auipc	ra,0x0
    802000e4:	11e080e7          	jalr	286(ra) # 802001fe <uart_puts>
    uart_puts("===============================================\n\n");
    802000e8:	00004517          	auipc	a0,0x4
    802000ec:	fa850513          	addi	a0,a0,-88 # 80204090 <etext+0x90>
    802000f0:	00000097          	auipc	ra,0x0
    802000f4:	10e080e7          	jalr	270(ra) # 802001fe <uart_puts>
	trap_init();
    802000f8:	00002097          	auipc	ra,0x2
    802000fc:	6b4080e7          	jalr	1716(ra) # 802027ac <trap_init>
    uart_puts("\nSystem ready. Entering main loop...\n");
    80200100:	00004517          	auipc	a0,0x4
    80200104:	fc850513          	addi	a0,a0,-56 # 802040c8 <etext+0xc8>
    80200108:	00000097          	auipc	ra,0x0
    8020010c:	0f6080e7          	jalr	246(ra) # 802001fe <uart_puts>
	// 允许中断
    intr_on();
    80200110:	00000097          	auipc	ra,0x0
    80200114:	f56080e7          	jalr	-170(ra) # 80200066 <intr_on>
	test_timer_interrupt();
    80200118:	00003097          	auipc	ra,0x3
    8020011c:	cc6080e7          	jalr	-826(ra) # 80202dde <test_timer_interrupt>
	printf("[KERNEL] Timer interrupt test finished!\n");
    80200120:	00004517          	auipc	a0,0x4
    80200124:	fd050513          	addi	a0,a0,-48 # 802040f0 <etext+0xf0>
    80200128:	00000097          	auipc	ra,0x0
    8020012c:	440080e7          	jalr	1088(ra) # 80200568 <printf>
	test_exception();
    80200130:	00003097          	auipc	ra,0x3
    80200134:	d94080e7          	jalr	-620(ra) # 80202ec4 <test_exception>
	printf("[KERNEL] Exception test finished!\n");
    80200138:	00004517          	auipc	a0,0x4
    8020013c:	fe850513          	addi	a0,a0,-24 # 80204120 <etext+0x120>
    80200140:	00000097          	auipc	ra,0x0
    80200144:	428080e7          	jalr	1064(ra) # 80200568 <printf>
	uart_init();
    80200148:	00000097          	auipc	ra,0x0
    8020014c:	01c080e7          	jalr	28(ra) # 80200164 <uart_init>
	printf("外部中断：键盘输入已经注册，请尝试输入字符并观察UART输出\n");
    80200150:	00004517          	auipc	a0,0x4
    80200154:	ff850513          	addi	a0,a0,-8 # 80204148 <etext+0x148>
    80200158:	00000097          	auipc	ra,0x0
    8020015c:	410080e7          	jalr	1040(ra) # 80200568 <printf>
    // 主循环
	while(1){
    80200160:	0001                	nop
    80200162:	bffd                	j	80200160 <start+0xd0>

0000000080200164 <uart_init>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))


// UART初始化函数
void uart_init(void) {
    80200164:	1141                	addi	sp,sp,-16
    80200166:	e406                	sd	ra,8(sp)
    80200168:	e022                	sd	s0,0(sp)
    8020016a:	0800                	addi	s0,sp,16

    WriteReg(IER, 0x00);
    8020016c:	100007b7          	lui	a5,0x10000
    80200170:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    80200172:	00078023          	sb	zero,0(a5)
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80200176:	100007b7          	lui	a5,0x10000
    8020017a:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x701ffffe>
    8020017c:	471d                	li	a4,7
    8020017e:	00e78023          	sb	a4,0(a5)
    WriteReg(IER, IER_RX_ENABLE);
    80200182:	100007b7          	lui	a5,0x10000
    80200186:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    80200188:	4705                	li	a4,1
    8020018a:	00e78023          	sb	a4,0(a5)
    register_interrupt(UART0_IRQ, uart_intr);//注册键盘输入的中断处理函数
    8020018e:	00000597          	auipc	a1,0x0
    80200192:	12858593          	addi	a1,a1,296 # 802002b6 <uart_intr>
    80200196:	4529                	li	a0,10
    80200198:	00002097          	auipc	ra,0x2
    8020019c:	490080e7          	jalr	1168(ra) # 80202628 <register_interrupt>
    enable_interrupts(UART0_IRQ);
    802001a0:	4529                	li	a0,10
    802001a2:	00002097          	auipc	ra,0x2
    802001a6:	510080e7          	jalr	1296(ra) # 802026b2 <enable_interrupts>
    printf("UART initialized with input support\n");
    802001aa:	00004517          	auipc	a0,0x4
    802001ae:	ff650513          	addi	a0,a0,-10 # 802041a0 <etext+0x1a0>
    802001b2:	00000097          	auipc	ra,0x0
    802001b6:	3b6080e7          	jalr	950(ra) # 80200568 <printf>
}
    802001ba:	0001                	nop
    802001bc:	60a2                	ld	ra,8(sp)
    802001be:	6402                	ld	s0,0(sp)
    802001c0:	0141                	addi	sp,sp,16
    802001c2:	8082                	ret

00000000802001c4 <uart_putc>:

// 发送单个字符
void uart_putc(char c) {
    802001c4:	1101                	addi	sp,sp,-32
    802001c6:	ec22                	sd	s0,24(sp)
    802001c8:	1000                	addi	s0,sp,32
    802001ca:	87aa                	mv	a5,a0
    802001cc:	fef407a3          	sb	a5,-17(s0)
    // 等待发送缓冲区空闲
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    802001d0:	0001                	nop
    802001d2:	100007b7          	lui	a5,0x10000
    802001d6:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    802001d8:	0007c783          	lbu	a5,0(a5)
    802001dc:	0ff7f793          	zext.b	a5,a5
    802001e0:	2781                	sext.w	a5,a5
    802001e2:	0207f793          	andi	a5,a5,32
    802001e6:	2781                	sext.w	a5,a5
    802001e8:	d7ed                	beqz	a5,802001d2 <uart_putc+0xe>
    WriteReg(THR, c);
    802001ea:	100007b7          	lui	a5,0x10000
    802001ee:	fef44703          	lbu	a4,-17(s0)
    802001f2:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
}
    802001f6:	0001                	nop
    802001f8:	6462                	ld	s0,24(sp)
    802001fa:	6105                	addi	sp,sp,32
    802001fc:	8082                	ret

00000000802001fe <uart_puts>:

void uart_puts(char *s) {
    802001fe:	7179                	addi	sp,sp,-48
    80200200:	f422                	sd	s0,40(sp)
    80200202:	1800                	addi	s0,sp,48
    80200204:	fca43c23          	sd	a0,-40(s0)
    if (!s) return;
    80200208:	fd843783          	ld	a5,-40(s0)
    8020020c:	c7b5                	beqz	a5,80200278 <uart_puts+0x7a>
    
    while (*s) {
    8020020e:	a8b9                	j	8020026c <uart_puts+0x6e>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80200210:	0001                	nop
    80200212:	100007b7          	lui	a5,0x10000
    80200216:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200218:	0007c783          	lbu	a5,0(a5)
    8020021c:	0ff7f793          	zext.b	a5,a5
    80200220:	2781                	sext.w	a5,a5
    80200222:	0207f793          	andi	a5,a5,32
    80200226:	2781                	sext.w	a5,a5
    80200228:	d7ed                	beqz	a5,80200212 <uart_puts+0x14>
        int sent_count = 0;
    8020022a:	fe042623          	sw	zero,-20(s0)
        while (*s && sent_count < 4) { 
    8020022e:	a01d                	j	80200254 <uart_puts+0x56>
            WriteReg(THR, *s);
    80200230:	100007b7          	lui	a5,0x10000
    80200234:	fd843703          	ld	a4,-40(s0)
    80200238:	00074703          	lbu	a4,0(a4)
    8020023c:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
            s++;
    80200240:	fd843783          	ld	a5,-40(s0)
    80200244:	0785                	addi	a5,a5,1
    80200246:	fcf43c23          	sd	a5,-40(s0)
            sent_count++;
    8020024a:	fec42783          	lw	a5,-20(s0)
    8020024e:	2785                	addiw	a5,a5,1
    80200250:	fef42623          	sw	a5,-20(s0)
        while (*s && sent_count < 4) { 
    80200254:	fd843783          	ld	a5,-40(s0)
    80200258:	0007c783          	lbu	a5,0(a5)
    8020025c:	cb81                	beqz	a5,8020026c <uart_puts+0x6e>
    8020025e:	fec42783          	lw	a5,-20(s0)
    80200262:	0007871b          	sext.w	a4,a5
    80200266:	478d                	li	a5,3
    80200268:	fce7d4e3          	bge	a5,a4,80200230 <uart_puts+0x32>
    while (*s) {
    8020026c:	fd843783          	ld	a5,-40(s0)
    80200270:	0007c783          	lbu	a5,0(a5)
    80200274:	ffd1                	bnez	a5,80200210 <uart_puts+0x12>
    80200276:	a011                	j	8020027a <uart_puts+0x7c>
    if (!s) return;
    80200278:	0001                	nop
        }
    }
}
    8020027a:	7422                	ld	s0,40(sp)
    8020027c:	6145                	addi	sp,sp,48
    8020027e:	8082                	ret

0000000080200280 <uart_getc>:

int uart_getc(void) {
    80200280:	1141                	addi	sp,sp,-16
    80200282:	e422                	sd	s0,8(sp)
    80200284:	0800                	addi	s0,sp,16
    if ((ReadReg(LSR) & LSR_RX_READY) == 0)
    80200286:	100007b7          	lui	a5,0x10000
    8020028a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    8020028c:	0007c783          	lbu	a5,0(a5)
    80200290:	0ff7f793          	zext.b	a5,a5
    80200294:	2781                	sext.w	a5,a5
    80200296:	8b85                	andi	a5,a5,1
    80200298:	2781                	sext.w	a5,a5
    8020029a:	e399                	bnez	a5,802002a0 <uart_getc+0x20>
        return -1; 
    8020029c:	57fd                	li	a5,-1
    8020029e:	a801                	j	802002ae <uart_getc+0x2e>
    return ReadReg(RHR); 
    802002a0:	100007b7          	lui	a5,0x10000
    802002a4:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    802002a8:	0ff7f793          	zext.b	a5,a5
    802002ac:	2781                	sext.w	a5,a5
}
    802002ae:	853e                	mv	a0,a5
    802002b0:	6422                	ld	s0,8(sp)
    802002b2:	0141                	addi	sp,sp,16
    802002b4:	8082                	ret

00000000802002b6 <uart_intr>:

// UART中断处理函数
void uart_intr(void) {
    802002b6:	1101                	addi	sp,sp,-32
    802002b8:	ec06                	sd	ra,24(sp)
    802002ba:	e822                	sd	s0,16(sp)
    802002bc:	1000                	addi	s0,sp,32
    while (ReadReg(LSR) & LSR_RX_READY) {
    802002be:	a831                	j	802002da <uart_intr+0x24>
        char c = ReadReg(RHR);
    802002c0:	100007b7          	lui	a5,0x10000
    802002c4:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    802002c8:	fef407a3          	sb	a5,-17(s0)
        uart_putc(c);
    802002cc:	fef44783          	lbu	a5,-17(s0)
    802002d0:	853e                	mv	a0,a5
    802002d2:	00000097          	auipc	ra,0x0
    802002d6:	ef2080e7          	jalr	-270(ra) # 802001c4 <uart_putc>
    while (ReadReg(LSR) & LSR_RX_READY) {
    802002da:	100007b7          	lui	a5,0x10000
    802002de:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    802002e0:	0007c783          	lbu	a5,0(a5)
    802002e4:	0ff7f793          	zext.b	a5,a5
    802002e8:	2781                	sext.w	a5,a5
    802002ea:	8b85                	andi	a5,a5,1
    802002ec:	2781                	sext.w	a5,a5
    802002ee:	fbe9                	bnez	a5,802002c0 <uart_intr+0xa>
    }
}
    802002f0:	0001                	nop
    802002f2:	0001                	nop
    802002f4:	60e2                	ld	ra,24(sp)
    802002f6:	6442                	ld	s0,16(sp)
    802002f8:	6105                	addi	sp,sp,32
    802002fa:	8082                	ret

00000000802002fc <flush_printf_buffer>:
#define PRINTF_BUFFER_SIZE 128
extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    802002fc:	1141                	addi	sp,sp,-16
    802002fe:	e406                	sd	ra,8(sp)
    80200300:	e022                	sd	s0,0(sp)
    80200302:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    80200304:	00007797          	auipc	a5,0x7
    80200308:	dac78793          	addi	a5,a5,-596 # 802070b0 <printf_buf_pos>
    8020030c:	439c                	lw	a5,0(a5)
    8020030e:	02f05c63          	blez	a5,80200346 <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200312:	00007797          	auipc	a5,0x7
    80200316:	d9e78793          	addi	a5,a5,-610 # 802070b0 <printf_buf_pos>
    8020031a:	439c                	lw	a5,0(a5)
    8020031c:	00007717          	auipc	a4,0x7
    80200320:	d1470713          	addi	a4,a4,-748 # 80207030 <printf_buffer>
    80200324:	97ba                	add	a5,a5,a4
    80200326:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    8020032a:	00007517          	auipc	a0,0x7
    8020032e:	d0650513          	addi	a0,a0,-762 # 80207030 <printf_buffer>
    80200332:	00000097          	auipc	ra,0x0
    80200336:	ecc080e7          	jalr	-308(ra) # 802001fe <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    8020033a:	00007797          	auipc	a5,0x7
    8020033e:	d7678793          	addi	a5,a5,-650 # 802070b0 <printf_buf_pos>
    80200342:	0007a023          	sw	zero,0(a5)
	}
}
    80200346:	0001                	nop
    80200348:	60a2                	ld	ra,8(sp)
    8020034a:	6402                	ld	s0,0(sp)
    8020034c:	0141                	addi	sp,sp,16
    8020034e:	8082                	ret

0000000080200350 <buffer_char>:
static void buffer_char(char c) {
    80200350:	1101                	addi	sp,sp,-32
    80200352:	ec06                	sd	ra,24(sp)
    80200354:	e822                	sd	s0,16(sp)
    80200356:	1000                	addi	s0,sp,32
    80200358:	87aa                	mv	a5,a0
    8020035a:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    8020035e:	00007797          	auipc	a5,0x7
    80200362:	d5278793          	addi	a5,a5,-686 # 802070b0 <printf_buf_pos>
    80200366:	439c                	lw	a5,0(a5)
    80200368:	873e                	mv	a4,a5
    8020036a:	07e00793          	li	a5,126
    8020036e:	02e7ca63          	blt	a5,a4,802003a2 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200372:	00007797          	auipc	a5,0x7
    80200376:	d3e78793          	addi	a5,a5,-706 # 802070b0 <printf_buf_pos>
    8020037a:	439c                	lw	a5,0(a5)
    8020037c:	0017871b          	addiw	a4,a5,1
    80200380:	0007069b          	sext.w	a3,a4
    80200384:	00007717          	auipc	a4,0x7
    80200388:	d2c70713          	addi	a4,a4,-724 # 802070b0 <printf_buf_pos>
    8020038c:	c314                	sw	a3,0(a4)
    8020038e:	00007717          	auipc	a4,0x7
    80200392:	ca270713          	addi	a4,a4,-862 # 80207030 <printf_buffer>
    80200396:	97ba                	add	a5,a5,a4
    80200398:	fef44703          	lbu	a4,-17(s0)
    8020039c:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    802003a0:	a825                	j	802003d8 <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    802003a2:	00000097          	auipc	ra,0x0
    802003a6:	f5a080e7          	jalr	-166(ra) # 802002fc <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    802003aa:	00007797          	auipc	a5,0x7
    802003ae:	d0678793          	addi	a5,a5,-762 # 802070b0 <printf_buf_pos>
    802003b2:	439c                	lw	a5,0(a5)
    802003b4:	0017871b          	addiw	a4,a5,1
    802003b8:	0007069b          	sext.w	a3,a4
    802003bc:	00007717          	auipc	a4,0x7
    802003c0:	cf470713          	addi	a4,a4,-780 # 802070b0 <printf_buf_pos>
    802003c4:	c314                	sw	a3,0(a4)
    802003c6:	00007717          	auipc	a4,0x7
    802003ca:	c6a70713          	addi	a4,a4,-918 # 80207030 <printf_buffer>
    802003ce:	97ba                	add	a5,a5,a4
    802003d0:	fef44703          	lbu	a4,-17(s0)
    802003d4:	00e78023          	sb	a4,0(a5)
}
    802003d8:	0001                	nop
    802003da:	60e2                	ld	ra,24(sp)
    802003dc:	6442                	ld	s0,16(sp)
    802003de:	6105                	addi	sp,sp,32
    802003e0:	8082                	ret

00000000802003e2 <consputc>:
    "70", "71", "72", "73", "74", "75", "76", "77", "78", "79",
    "80", "81", "82", "83", "84", "85", "86", "87", "88", "89",
    "90", "91", "92", "93", "94", "95", "96", "97", "98", "99"
};

static void consputc(int c){
    802003e2:	1101                	addi	sp,sp,-32
    802003e4:	ec06                	sd	ra,24(sp)
    802003e6:	e822                	sd	s0,16(sp)
    802003e8:	1000                	addi	s0,sp,32
    802003ea:	87aa                	mv	a5,a0
    802003ec:	fef42623          	sw	a5,-20(s0)
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
    802003f0:	fec42783          	lw	a5,-20(s0)
    802003f4:	0ff7f793          	zext.b	a5,a5
    802003f8:	853e                	mv	a0,a5
    802003fa:	00000097          	auipc	ra,0x0
    802003fe:	dca080e7          	jalr	-566(ra) # 802001c4 <uart_putc>
}
    80200402:	0001                	nop
    80200404:	60e2                	ld	ra,24(sp)
    80200406:	6442                	ld	s0,16(sp)
    80200408:	6105                	addi	sp,sp,32
    8020040a:	8082                	ret

000000008020040c <consputs>:
static void consputs(const char *s){
    8020040c:	7179                	addi	sp,sp,-48
    8020040e:	f406                	sd	ra,40(sp)
    80200410:	f022                	sd	s0,32(sp)
    80200412:	1800                	addi	s0,sp,48
    80200414:	fca43c23          	sd	a0,-40(s0)
	char *str = (char *)s;
    80200418:	fd843783          	ld	a5,-40(s0)
    8020041c:	fef43423          	sd	a5,-24(s0)
	// 直接调用uart_puts输出字符串
	uart_puts(str);
    80200420:	fe843503          	ld	a0,-24(s0)
    80200424:	00000097          	auipc	ra,0x0
    80200428:	dda080e7          	jalr	-550(ra) # 802001fe <uart_puts>
}
    8020042c:	0001                	nop
    8020042e:	70a2                	ld	ra,40(sp)
    80200430:	7402                	ld	s0,32(sp)
    80200432:	6145                	addi	sp,sp,48
    80200434:	8082                	ret

0000000080200436 <printint>:
static void printint(long long xx,int base,int sign){
    80200436:	715d                	addi	sp,sp,-80
    80200438:	e486                	sd	ra,72(sp)
    8020043a:	e0a2                	sd	s0,64(sp)
    8020043c:	0880                	addi	s0,sp,80
    8020043e:	faa43c23          	sd	a0,-72(s0)
    80200442:	87ae                	mv	a5,a1
    80200444:	8732                	mv	a4,a2
    80200446:	faf42a23          	sw	a5,-76(s0)
    8020044a:	87ba                	mv	a5,a4
    8020044c:	faf42823          	sw	a5,-80(s0)
	// 模仿xv6的printint
	static char digits[] = "0123456789abcdef";
	char buf[20]; // 增大缓冲区以处理64位整数
	int i;
	unsigned long long x;
	if (sign && (sign = xx < 0)) // 符号处理
    80200450:	fb042783          	lw	a5,-80(s0)
    80200454:	2781                	sext.w	a5,a5
    80200456:	c39d                	beqz	a5,8020047c <printint+0x46>
    80200458:	fb843783          	ld	a5,-72(s0)
    8020045c:	93fd                	srli	a5,a5,0x3f
    8020045e:	0ff7f793          	zext.b	a5,a5
    80200462:	faf42823          	sw	a5,-80(s0)
    80200466:	fb042783          	lw	a5,-80(s0)
    8020046a:	2781                	sext.w	a5,a5
    8020046c:	cb81                	beqz	a5,8020047c <printint+0x46>
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    8020046e:	fb843783          	ld	a5,-72(s0)
    80200472:	40f007b3          	neg	a5,a5
    80200476:	fef43023          	sd	a5,-32(s0)
    8020047a:	a029                	j	80200484 <printint+0x4e>
	else
		x = xx;
    8020047c:	fb843783          	ld	a5,-72(s0)
    80200480:	fef43023          	sd	a5,-32(s0)

	if (base == 10 && x < 100) {
    80200484:	fb442783          	lw	a5,-76(s0)
    80200488:	0007871b          	sext.w	a4,a5
    8020048c:	47a9                	li	a5,10
    8020048e:	02f71763          	bne	a4,a5,802004bc <printint+0x86>
    80200492:	fe043703          	ld	a4,-32(s0)
    80200496:	06300793          	li	a5,99
    8020049a:	02e7e163          	bltu	a5,a4,802004bc <printint+0x86>
		// 使用查表法处理小数字
		consputs(small_numbers[x]);
    8020049e:	fe043783          	ld	a5,-32(s0)
    802004a2:	00279713          	slli	a4,a5,0x2
    802004a6:	00004797          	auipc	a5,0x4
    802004aa:	d2278793          	addi	a5,a5,-734 # 802041c8 <small_numbers>
    802004ae:	97ba                	add	a5,a5,a4
    802004b0:	853e                	mv	a0,a5
    802004b2:	00000097          	auipc	ra,0x0
    802004b6:	f5a080e7          	jalr	-166(ra) # 8020040c <consputs>
    802004ba:	a05d                	j	80200560 <printint+0x12a>
		return;
	}
	i = 0;
    802004bc:	fe042623          	sw	zero,-20(s0)
	do{
		buf[i] = digits[x % base];
    802004c0:	fb442783          	lw	a5,-76(s0)
    802004c4:	fe043703          	ld	a4,-32(s0)
    802004c8:	02f777b3          	remu	a5,a4,a5
    802004cc:	00007717          	auipc	a4,0x7
    802004d0:	b3470713          	addi	a4,a4,-1228 # 80207000 <digits.0>
    802004d4:	97ba                	add	a5,a5,a4
    802004d6:	0007c703          	lbu	a4,0(a5)
    802004da:	fec42783          	lw	a5,-20(s0)
    802004de:	17c1                	addi	a5,a5,-16
    802004e0:	97a2                	add	a5,a5,s0
    802004e2:	fce78c23          	sb	a4,-40(a5)
		i++;
    802004e6:	fec42783          	lw	a5,-20(s0)
    802004ea:	2785                	addiw	a5,a5,1
    802004ec:	fef42623          	sw	a5,-20(s0)
	}while((x/=base) !=0);
    802004f0:	fb442783          	lw	a5,-76(s0)
    802004f4:	fe043703          	ld	a4,-32(s0)
    802004f8:	02f757b3          	divu	a5,a4,a5
    802004fc:	fef43023          	sd	a5,-32(s0)
    80200500:	fe043783          	ld	a5,-32(s0)
    80200504:	ffd5                	bnez	a5,802004c0 <printint+0x8a>
	if (sign){
    80200506:	fb042783          	lw	a5,-80(s0)
    8020050a:	2781                	sext.w	a5,a5
    8020050c:	cf91                	beqz	a5,80200528 <printint+0xf2>
		buf[i] = '-';
    8020050e:	fec42783          	lw	a5,-20(s0)
    80200512:	17c1                	addi	a5,a5,-16
    80200514:	97a2                	add	a5,a5,s0
    80200516:	02d00713          	li	a4,45
    8020051a:	fce78c23          	sb	a4,-40(a5)
		i++;
    8020051e:	fec42783          	lw	a5,-20(s0)
    80200522:	2785                	addiw	a5,a5,1
    80200524:	fef42623          	sw	a5,-20(s0)
	}
	i--;
    80200528:	fec42783          	lw	a5,-20(s0)
    8020052c:	37fd                	addiw	a5,a5,-1
    8020052e:	fef42623          	sw	a5,-20(s0)
	while( i>=0){
    80200532:	a015                	j	80200556 <printint+0x120>
		consputc(buf[i]);
    80200534:	fec42783          	lw	a5,-20(s0)
    80200538:	17c1                	addi	a5,a5,-16
    8020053a:	97a2                	add	a5,a5,s0
    8020053c:	fd87c783          	lbu	a5,-40(a5)
    80200540:	2781                	sext.w	a5,a5
    80200542:	853e                	mv	a0,a5
    80200544:	00000097          	auipc	ra,0x0
    80200548:	e9e080e7          	jalr	-354(ra) # 802003e2 <consputc>
		i--;
    8020054c:	fec42783          	lw	a5,-20(s0)
    80200550:	37fd                	addiw	a5,a5,-1
    80200552:	fef42623          	sw	a5,-20(s0)
	while( i>=0){
    80200556:	fec42783          	lw	a5,-20(s0)
    8020055a:	2781                	sext.w	a5,a5
    8020055c:	fc07dce3          	bgez	a5,80200534 <printint+0xfe>
	}
}
    80200560:	60a6                	ld	ra,72(sp)
    80200562:	6406                	ld	s0,64(sp)
    80200564:	6161                	addi	sp,sp,80
    80200566:	8082                	ret

0000000080200568 <printf>:
void printf(const char *fmt, ...) {
    80200568:	7171                	addi	sp,sp,-176
    8020056a:	f486                	sd	ra,104(sp)
    8020056c:	f0a2                	sd	s0,96(sp)
    8020056e:	1880                	addi	s0,sp,112
    80200570:	f8a43c23          	sd	a0,-104(s0)
    80200574:	e40c                	sd	a1,8(s0)
    80200576:	e810                	sd	a2,16(s0)
    80200578:	ec14                	sd	a3,24(s0)
    8020057a:	f018                	sd	a4,32(s0)
    8020057c:	f41c                	sd	a5,40(s0)
    8020057e:	03043823          	sd	a6,48(s0)
    80200582:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    80200586:	04040793          	addi	a5,s0,64
    8020058a:	f8f43823          	sd	a5,-112(s0)
    8020058e:	f9043783          	ld	a5,-112(s0)
    80200592:	fc878793          	addi	a5,a5,-56
    80200596:	fcf43023          	sd	a5,-64(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8020059a:	fe042623          	sw	zero,-20(s0)
    8020059e:	a671                	j	8020092a <printf+0x3c2>
        if(c != '%'){
    802005a0:	fe842783          	lw	a5,-24(s0)
    802005a4:	0007871b          	sext.w	a4,a5
    802005a8:	02500793          	li	a5,37
    802005ac:	00f70c63          	beq	a4,a5,802005c4 <printf+0x5c>
            buffer_char(c);
    802005b0:	fe842783          	lw	a5,-24(s0)
    802005b4:	0ff7f793          	zext.b	a5,a5
    802005b8:	853e                	mv	a0,a5
    802005ba:	00000097          	auipc	ra,0x0
    802005be:	d96080e7          	jalr	-618(ra) # 80200350 <buffer_char>
            continue;
    802005c2:	aeb9                	j	80200920 <printf+0x3b8>
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    802005c4:	00000097          	auipc	ra,0x0
    802005c8:	d38080e7          	jalr	-712(ra) # 802002fc <flush_printf_buffer>
        c = fmt[++i] & 0xff;
    802005cc:	fec42783          	lw	a5,-20(s0)
    802005d0:	2785                	addiw	a5,a5,1
    802005d2:	fef42623          	sw	a5,-20(s0)
    802005d6:	fec42783          	lw	a5,-20(s0)
    802005da:	f9843703          	ld	a4,-104(s0)
    802005de:	97ba                	add	a5,a5,a4
    802005e0:	0007c783          	lbu	a5,0(a5)
    802005e4:	fef42423          	sw	a5,-24(s0)
        if(c == 0)
    802005e8:	fe842783          	lw	a5,-24(s0)
    802005ec:	2781                	sext.w	a5,a5
    802005ee:	34078d63          	beqz	a5,80200948 <printf+0x3e0>
            break;
            
        // 检查是否有长整型标记'l'
        int is_long = 0;
    802005f2:	fc042e23          	sw	zero,-36(s0)
        if(c == 'l') {
    802005f6:	fe842783          	lw	a5,-24(s0)
    802005fa:	0007871b          	sext.w	a4,a5
    802005fe:	06c00793          	li	a5,108
    80200602:	02f71863          	bne	a4,a5,80200632 <printf+0xca>
            is_long = 1;
    80200606:	4785                	li	a5,1
    80200608:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    8020060c:	fec42783          	lw	a5,-20(s0)
    80200610:	2785                	addiw	a5,a5,1
    80200612:	fef42623          	sw	a5,-20(s0)
    80200616:	fec42783          	lw	a5,-20(s0)
    8020061a:	f9843703          	ld	a4,-104(s0)
    8020061e:	97ba                	add	a5,a5,a4
    80200620:	0007c783          	lbu	a5,0(a5)
    80200624:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    80200628:	fe842783          	lw	a5,-24(s0)
    8020062c:	2781                	sext.w	a5,a5
    8020062e:	30078f63          	beqz	a5,8020094c <printf+0x3e4>
                break;
        }
        
        switch(c){
    80200632:	fe842783          	lw	a5,-24(s0)
    80200636:	0007871b          	sext.w	a4,a5
    8020063a:	02500793          	li	a5,37
    8020063e:	2af70063          	beq	a4,a5,802008de <printf+0x376>
    80200642:	fe842783          	lw	a5,-24(s0)
    80200646:	0007871b          	sext.w	a4,a5
    8020064a:	02500793          	li	a5,37
    8020064e:	28f74f63          	blt	a4,a5,802008ec <printf+0x384>
    80200652:	fe842783          	lw	a5,-24(s0)
    80200656:	0007871b          	sext.w	a4,a5
    8020065a:	07800793          	li	a5,120
    8020065e:	28e7c763          	blt	a5,a4,802008ec <printf+0x384>
    80200662:	fe842783          	lw	a5,-24(s0)
    80200666:	0007871b          	sext.w	a4,a5
    8020066a:	06200793          	li	a5,98
    8020066e:	26f74f63          	blt	a4,a5,802008ec <printf+0x384>
    80200672:	fe842783          	lw	a5,-24(s0)
    80200676:	f9e7869b          	addiw	a3,a5,-98
    8020067a:	0006871b          	sext.w	a4,a3
    8020067e:	47d9                	li	a5,22
    80200680:	26e7e663          	bltu	a5,a4,802008ec <printf+0x384>
    80200684:	02069793          	slli	a5,a3,0x20
    80200688:	9381                	srli	a5,a5,0x20
    8020068a:	00279713          	slli	a4,a5,0x2
    8020068e:	00004797          	auipc	a5,0x4
    80200692:	cee78793          	addi	a5,a5,-786 # 8020437c <small_numbers+0x1b4>
    80200696:	97ba                	add	a5,a5,a4
    80200698:	439c                	lw	a5,0(a5)
    8020069a:	0007871b          	sext.w	a4,a5
    8020069e:	00004797          	auipc	a5,0x4
    802006a2:	cde78793          	addi	a5,a5,-802 # 8020437c <small_numbers+0x1b4>
    802006a6:	97ba                	add	a5,a5,a4
    802006a8:	8782                	jr	a5
        case 'd':
            if(is_long)
    802006aa:	fdc42783          	lw	a5,-36(s0)
    802006ae:	2781                	sext.w	a5,a5
    802006b0:	c385                	beqz	a5,802006d0 <printf+0x168>
                printint(va_arg(ap, long long), 10, 1);
    802006b2:	fc043783          	ld	a5,-64(s0)
    802006b6:	00878713          	addi	a4,a5,8
    802006ba:	fce43023          	sd	a4,-64(s0)
    802006be:	639c                	ld	a5,0(a5)
    802006c0:	4605                	li	a2,1
    802006c2:	45a9                	li	a1,10
    802006c4:	853e                	mv	a0,a5
    802006c6:	00000097          	auipc	ra,0x0
    802006ca:	d70080e7          	jalr	-656(ra) # 80200436 <printint>
            else
                printint(va_arg(ap, int), 10, 1);
            break;
    802006ce:	ac89                	j	80200920 <printf+0x3b8>
                printint(va_arg(ap, int), 10, 1);
    802006d0:	fc043783          	ld	a5,-64(s0)
    802006d4:	00878713          	addi	a4,a5,8
    802006d8:	fce43023          	sd	a4,-64(s0)
    802006dc:	439c                	lw	a5,0(a5)
    802006de:	4605                	li	a2,1
    802006e0:	45a9                	li	a1,10
    802006e2:	853e                	mv	a0,a5
    802006e4:	00000097          	auipc	ra,0x0
    802006e8:	d52080e7          	jalr	-686(ra) # 80200436 <printint>
            break;
    802006ec:	ac15                	j	80200920 <printf+0x3b8>
        case 'x':
            if(is_long)
    802006ee:	fdc42783          	lw	a5,-36(s0)
    802006f2:	2781                	sext.w	a5,a5
    802006f4:	c385                	beqz	a5,80200714 <printf+0x1ac>
                printint(va_arg(ap, long long), 16, 0);
    802006f6:	fc043783          	ld	a5,-64(s0)
    802006fa:	00878713          	addi	a4,a5,8
    802006fe:	fce43023          	sd	a4,-64(s0)
    80200702:	639c                	ld	a5,0(a5)
    80200704:	4601                	li	a2,0
    80200706:	45c1                	li	a1,16
    80200708:	853e                	mv	a0,a5
    8020070a:	00000097          	auipc	ra,0x0
    8020070e:	d2c080e7          	jalr	-724(ra) # 80200436 <printint>
            else
                printint(va_arg(ap, int), 16, 0);
            break;
    80200712:	a439                	j	80200920 <printf+0x3b8>
                printint(va_arg(ap, int), 16, 0);
    80200714:	fc043783          	ld	a5,-64(s0)
    80200718:	00878713          	addi	a4,a5,8
    8020071c:	fce43023          	sd	a4,-64(s0)
    80200720:	439c                	lw	a5,0(a5)
    80200722:	4601                	li	a2,0
    80200724:	45c1                	li	a1,16
    80200726:	853e                	mv	a0,a5
    80200728:	00000097          	auipc	ra,0x0
    8020072c:	d0e080e7          	jalr	-754(ra) # 80200436 <printint>
            break;
    80200730:	aac5                	j	80200920 <printf+0x3b8>
        case 'u':
            if(is_long)
    80200732:	fdc42783          	lw	a5,-36(s0)
    80200736:	2781                	sext.w	a5,a5
    80200738:	c385                	beqz	a5,80200758 <printf+0x1f0>
                printint(va_arg(ap, unsigned long long), 10, 0);
    8020073a:	fc043783          	ld	a5,-64(s0)
    8020073e:	00878713          	addi	a4,a5,8
    80200742:	fce43023          	sd	a4,-64(s0)
    80200746:	639c                	ld	a5,0(a5)
    80200748:	4601                	li	a2,0
    8020074a:	45a9                	li	a1,10
    8020074c:	853e                	mv	a0,a5
    8020074e:	00000097          	auipc	ra,0x0
    80200752:	ce8080e7          	jalr	-792(ra) # 80200436 <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0);
            break;
    80200756:	a2e9                	j	80200920 <printf+0x3b8>
                printint(va_arg(ap, unsigned int), 10, 0);
    80200758:	fc043783          	ld	a5,-64(s0)
    8020075c:	00878713          	addi	a4,a5,8
    80200760:	fce43023          	sd	a4,-64(s0)
    80200764:	439c                	lw	a5,0(a5)
    80200766:	1782                	slli	a5,a5,0x20
    80200768:	9381                	srli	a5,a5,0x20
    8020076a:	4601                	li	a2,0
    8020076c:	45a9                	li	a1,10
    8020076e:	853e                	mv	a0,a5
    80200770:	00000097          	auipc	ra,0x0
    80200774:	cc6080e7          	jalr	-826(ra) # 80200436 <printint>
            break;
    80200778:	a265                	j	80200920 <printf+0x3b8>
        case 'c':
            consputc(va_arg(ap, int));
    8020077a:	fc043783          	ld	a5,-64(s0)
    8020077e:	00878713          	addi	a4,a5,8
    80200782:	fce43023          	sd	a4,-64(s0)
    80200786:	439c                	lw	a5,0(a5)
    80200788:	853e                	mv	a0,a5
    8020078a:	00000097          	auipc	ra,0x0
    8020078e:	c58080e7          	jalr	-936(ra) # 802003e2 <consputc>
            break;
    80200792:	a279                	j	80200920 <printf+0x3b8>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80200794:	fc043783          	ld	a5,-64(s0)
    80200798:	00878713          	addi	a4,a5,8
    8020079c:	fce43023          	sd	a4,-64(s0)
    802007a0:	639c                	ld	a5,0(a5)
    802007a2:	fef43023          	sd	a5,-32(s0)
    802007a6:	fe043783          	ld	a5,-32(s0)
    802007aa:	e799                	bnez	a5,802007b8 <printf+0x250>
                s = "(null)";
    802007ac:	00004797          	auipc	a5,0x4
    802007b0:	bac78793          	addi	a5,a5,-1108 # 80204358 <small_numbers+0x190>
    802007b4:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    802007b8:	fe043503          	ld	a0,-32(s0)
    802007bc:	00000097          	auipc	ra,0x0
    802007c0:	c50080e7          	jalr	-944(ra) # 8020040c <consputs>
            break;
    802007c4:	aab1                	j	80200920 <printf+0x3b8>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    802007c6:	fc043783          	ld	a5,-64(s0)
    802007ca:	00878713          	addi	a4,a5,8
    802007ce:	fce43023          	sd	a4,-64(s0)
    802007d2:	639c                	ld	a5,0(a5)
    802007d4:	fcf43823          	sd	a5,-48(s0)
            consputs("0x");
    802007d8:	00004517          	auipc	a0,0x4
    802007dc:	b8850513          	addi	a0,a0,-1144 # 80204360 <small_numbers+0x198>
    802007e0:	00000097          	auipc	ra,0x0
    802007e4:	c2c080e7          	jalr	-980(ra) # 8020040c <consputs>
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    802007e8:	fc042c23          	sw	zero,-40(s0)
    802007ec:	a0a1                	j	80200834 <printf+0x2cc>
                int shift = (15 - i) * 4;
    802007ee:	47bd                	li	a5,15
    802007f0:	fd842703          	lw	a4,-40(s0)
    802007f4:	9f99                	subw	a5,a5,a4
    802007f6:	2781                	sext.w	a5,a5
    802007f8:	0027979b          	slliw	a5,a5,0x2
    802007fc:	fcf42623          	sw	a5,-52(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80200800:	fcc42783          	lw	a5,-52(s0)
    80200804:	873e                	mv	a4,a5
    80200806:	fd043783          	ld	a5,-48(s0)
    8020080a:	00e7d7b3          	srl	a5,a5,a4
    8020080e:	8bbd                	andi	a5,a5,15
    80200810:	00004717          	auipc	a4,0x4
    80200814:	b5870713          	addi	a4,a4,-1192 # 80204368 <small_numbers+0x1a0>
    80200818:	97ba                	add	a5,a5,a4
    8020081a:	0007c703          	lbu	a4,0(a5)
    8020081e:	fd842783          	lw	a5,-40(s0)
    80200822:	17c1                	addi	a5,a5,-16
    80200824:	97a2                	add	a5,a5,s0
    80200826:	fae78c23          	sb	a4,-72(a5)
            for (i = 0; i < 16; i++) {
    8020082a:	fd842783          	lw	a5,-40(s0)
    8020082e:	2785                	addiw	a5,a5,1
    80200830:	fcf42c23          	sw	a5,-40(s0)
    80200834:	fd842783          	lw	a5,-40(s0)
    80200838:	0007871b          	sext.w	a4,a5
    8020083c:	47bd                	li	a5,15
    8020083e:	fae7d8e3          	bge	a5,a4,802007ee <printf+0x286>
            }
            buf[16] = '\0';
    80200842:	fa040c23          	sb	zero,-72(s0)
            consputs(buf);
    80200846:	fa840793          	addi	a5,s0,-88
    8020084a:	853e                	mv	a0,a5
    8020084c:	00000097          	auipc	ra,0x0
    80200850:	bc0080e7          	jalr	-1088(ra) # 8020040c <consputs>
            break;
    80200854:	a0f1                	j	80200920 <printf+0x3b8>
        case 'b':
            if(is_long)
    80200856:	fdc42783          	lw	a5,-36(s0)
    8020085a:	2781                	sext.w	a5,a5
    8020085c:	c385                	beqz	a5,8020087c <printf+0x314>
                printint(va_arg(ap, long long), 2, 0);
    8020085e:	fc043783          	ld	a5,-64(s0)
    80200862:	00878713          	addi	a4,a5,8
    80200866:	fce43023          	sd	a4,-64(s0)
    8020086a:	639c                	ld	a5,0(a5)
    8020086c:	4601                	li	a2,0
    8020086e:	4589                	li	a1,2
    80200870:	853e                	mv	a0,a5
    80200872:	00000097          	auipc	ra,0x0
    80200876:	bc4080e7          	jalr	-1084(ra) # 80200436 <printint>
            else
                printint(va_arg(ap, int), 2, 0);
            break;
    8020087a:	a05d                	j	80200920 <printf+0x3b8>
                printint(va_arg(ap, int), 2, 0);
    8020087c:	fc043783          	ld	a5,-64(s0)
    80200880:	00878713          	addi	a4,a5,8
    80200884:	fce43023          	sd	a4,-64(s0)
    80200888:	439c                	lw	a5,0(a5)
    8020088a:	4601                	li	a2,0
    8020088c:	4589                	li	a1,2
    8020088e:	853e                	mv	a0,a5
    80200890:	00000097          	auipc	ra,0x0
    80200894:	ba6080e7          	jalr	-1114(ra) # 80200436 <printint>
            break;
    80200898:	a061                	j	80200920 <printf+0x3b8>
        case 'o':
            if(is_long)
    8020089a:	fdc42783          	lw	a5,-36(s0)
    8020089e:	2781                	sext.w	a5,a5
    802008a0:	c385                	beqz	a5,802008c0 <printf+0x358>
                printint(va_arg(ap, long long), 8, 0);
    802008a2:	fc043783          	ld	a5,-64(s0)
    802008a6:	00878713          	addi	a4,a5,8
    802008aa:	fce43023          	sd	a4,-64(s0)
    802008ae:	639c                	ld	a5,0(a5)
    802008b0:	4601                	li	a2,0
    802008b2:	45a1                	li	a1,8
    802008b4:	853e                	mv	a0,a5
    802008b6:	00000097          	auipc	ra,0x0
    802008ba:	b80080e7          	jalr	-1152(ra) # 80200436 <printint>
            else
                printint(va_arg(ap, int), 8, 0);
            break;
    802008be:	a08d                	j	80200920 <printf+0x3b8>
                printint(va_arg(ap, int), 8, 0);
    802008c0:	fc043783          	ld	a5,-64(s0)
    802008c4:	00878713          	addi	a4,a5,8
    802008c8:	fce43023          	sd	a4,-64(s0)
    802008cc:	439c                	lw	a5,0(a5)
    802008ce:	4601                	li	a2,0
    802008d0:	45a1                	li	a1,8
    802008d2:	853e                	mv	a0,a5
    802008d4:	00000097          	auipc	ra,0x0
    802008d8:	b62080e7          	jalr	-1182(ra) # 80200436 <printint>
            break;
    802008dc:	a091                	j	80200920 <printf+0x3b8>
        case '%':
            buffer_char('%');
    802008de:	02500513          	li	a0,37
    802008e2:	00000097          	auipc	ra,0x0
    802008e6:	a6e080e7          	jalr	-1426(ra) # 80200350 <buffer_char>
            break;
    802008ea:	a81d                	j	80200920 <printf+0x3b8>
        default:
            buffer_char('%');
    802008ec:	02500513          	li	a0,37
    802008f0:	00000097          	auipc	ra,0x0
    802008f4:	a60080e7          	jalr	-1440(ra) # 80200350 <buffer_char>
            if(is_long) buffer_char('l');
    802008f8:	fdc42783          	lw	a5,-36(s0)
    802008fc:	2781                	sext.w	a5,a5
    802008fe:	c799                	beqz	a5,8020090c <printf+0x3a4>
    80200900:	06c00513          	li	a0,108
    80200904:	00000097          	auipc	ra,0x0
    80200908:	a4c080e7          	jalr	-1460(ra) # 80200350 <buffer_char>
            buffer_char(c);
    8020090c:	fe842783          	lw	a5,-24(s0)
    80200910:	0ff7f793          	zext.b	a5,a5
    80200914:	853e                	mv	a0,a5
    80200916:	00000097          	auipc	ra,0x0
    8020091a:	a3a080e7          	jalr	-1478(ra) # 80200350 <buffer_char>
            break;
    8020091e:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200920:	fec42783          	lw	a5,-20(s0)
    80200924:	2785                	addiw	a5,a5,1
    80200926:	fef42623          	sw	a5,-20(s0)
    8020092a:	fec42783          	lw	a5,-20(s0)
    8020092e:	f9843703          	ld	a4,-104(s0)
    80200932:	97ba                	add	a5,a5,a4
    80200934:	0007c783          	lbu	a5,0(a5)
    80200938:	fef42423          	sw	a5,-24(s0)
    8020093c:	fe842783          	lw	a5,-24(s0)
    80200940:	2781                	sext.w	a5,a5
    80200942:	c4079fe3          	bnez	a5,802005a0 <printf+0x38>
    80200946:	a021                	j	8020094e <printf+0x3e6>
            break;
    80200948:	0001                	nop
    8020094a:	a011                	j	8020094e <printf+0x3e6>
                break;
    8020094c:	0001                	nop
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    8020094e:	00000097          	auipc	ra,0x0
    80200952:	9ae080e7          	jalr	-1618(ra) # 802002fc <flush_printf_buffer>
    va_end(ap);
}
    80200956:	0001                	nop
    80200958:	70a6                	ld	ra,104(sp)
    8020095a:	7406                	ld	s0,96(sp)
    8020095c:	614d                	addi	sp,sp,176
    8020095e:	8082                	ret

0000000080200960 <clear_screen>:
// 清屏功能
void clear_screen(void) {
    80200960:	1141                	addi	sp,sp,-16
    80200962:	e406                	sd	ra,8(sp)
    80200964:	e022                	sd	s0,0(sp)
    80200966:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    80200968:	00004517          	auipc	a0,0x4
    8020096c:	a7050513          	addi	a0,a0,-1424 # 802043d8 <small_numbers+0x210>
    80200970:	00000097          	auipc	ra,0x0
    80200974:	88e080e7          	jalr	-1906(ra) # 802001fe <uart_puts>
	uart_puts(CURSOR_HOME);
    80200978:	00004517          	auipc	a0,0x4
    8020097c:	a6850513          	addi	a0,a0,-1432 # 802043e0 <small_numbers+0x218>
    80200980:	00000097          	auipc	ra,0x0
    80200984:	87e080e7          	jalr	-1922(ra) # 802001fe <uart_puts>
}
    80200988:	0001                	nop
    8020098a:	60a2                	ld	ra,8(sp)
    8020098c:	6402                	ld	s0,0(sp)
    8020098e:	0141                	addi	sp,sp,16
    80200990:	8082                	ret

0000000080200992 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    80200992:	1101                	addi	sp,sp,-32
    80200994:	ec06                	sd	ra,24(sp)
    80200996:	e822                	sd	s0,16(sp)
    80200998:	1000                	addi	s0,sp,32
    8020099a:	87aa                	mv	a5,a0
    8020099c:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    802009a0:	fec42783          	lw	a5,-20(s0)
    802009a4:	2781                	sext.w	a5,a5
    802009a6:	02f05d63          	blez	a5,802009e0 <cursor_up+0x4e>
    consputc('\033');
    802009aa:	456d                	li	a0,27
    802009ac:	00000097          	auipc	ra,0x0
    802009b0:	a36080e7          	jalr	-1482(ra) # 802003e2 <consputc>
    consputc('[');
    802009b4:	05b00513          	li	a0,91
    802009b8:	00000097          	auipc	ra,0x0
    802009bc:	a2a080e7          	jalr	-1494(ra) # 802003e2 <consputc>
    printint(lines, 10, 0);
    802009c0:	fec42783          	lw	a5,-20(s0)
    802009c4:	4601                	li	a2,0
    802009c6:	45a9                	li	a1,10
    802009c8:	853e                	mv	a0,a5
    802009ca:	00000097          	auipc	ra,0x0
    802009ce:	a6c080e7          	jalr	-1428(ra) # 80200436 <printint>
    consputc('A');
    802009d2:	04100513          	li	a0,65
    802009d6:	00000097          	auipc	ra,0x0
    802009da:	a0c080e7          	jalr	-1524(ra) # 802003e2 <consputc>
    802009de:	a011                	j	802009e2 <cursor_up+0x50>
    if (lines <= 0) return;
    802009e0:	0001                	nop
}
    802009e2:	60e2                	ld	ra,24(sp)
    802009e4:	6442                	ld	s0,16(sp)
    802009e6:	6105                	addi	sp,sp,32
    802009e8:	8082                	ret

00000000802009ea <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    802009ea:	1101                	addi	sp,sp,-32
    802009ec:	ec06                	sd	ra,24(sp)
    802009ee:	e822                	sd	s0,16(sp)
    802009f0:	1000                	addi	s0,sp,32
    802009f2:	87aa                	mv	a5,a0
    802009f4:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    802009f8:	fec42783          	lw	a5,-20(s0)
    802009fc:	2781                	sext.w	a5,a5
    802009fe:	02f05d63          	blez	a5,80200a38 <cursor_down+0x4e>
    consputc('\033');
    80200a02:	456d                	li	a0,27
    80200a04:	00000097          	auipc	ra,0x0
    80200a08:	9de080e7          	jalr	-1570(ra) # 802003e2 <consputc>
    consputc('[');
    80200a0c:	05b00513          	li	a0,91
    80200a10:	00000097          	auipc	ra,0x0
    80200a14:	9d2080e7          	jalr	-1582(ra) # 802003e2 <consputc>
    printint(lines, 10, 0);
    80200a18:	fec42783          	lw	a5,-20(s0)
    80200a1c:	4601                	li	a2,0
    80200a1e:	45a9                	li	a1,10
    80200a20:	853e                	mv	a0,a5
    80200a22:	00000097          	auipc	ra,0x0
    80200a26:	a14080e7          	jalr	-1516(ra) # 80200436 <printint>
    consputc('B');
    80200a2a:	04200513          	li	a0,66
    80200a2e:	00000097          	auipc	ra,0x0
    80200a32:	9b4080e7          	jalr	-1612(ra) # 802003e2 <consputc>
    80200a36:	a011                	j	80200a3a <cursor_down+0x50>
    if (lines <= 0) return;
    80200a38:	0001                	nop
}
    80200a3a:	60e2                	ld	ra,24(sp)
    80200a3c:	6442                	ld	s0,16(sp)
    80200a3e:	6105                	addi	sp,sp,32
    80200a40:	8082                	ret

0000000080200a42 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    80200a42:	1101                	addi	sp,sp,-32
    80200a44:	ec06                	sd	ra,24(sp)
    80200a46:	e822                	sd	s0,16(sp)
    80200a48:	1000                	addi	s0,sp,32
    80200a4a:	87aa                	mv	a5,a0
    80200a4c:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80200a50:	fec42783          	lw	a5,-20(s0)
    80200a54:	2781                	sext.w	a5,a5
    80200a56:	02f05d63          	blez	a5,80200a90 <cursor_right+0x4e>
    consputc('\033');
    80200a5a:	456d                	li	a0,27
    80200a5c:	00000097          	auipc	ra,0x0
    80200a60:	986080e7          	jalr	-1658(ra) # 802003e2 <consputc>
    consputc('[');
    80200a64:	05b00513          	li	a0,91
    80200a68:	00000097          	auipc	ra,0x0
    80200a6c:	97a080e7          	jalr	-1670(ra) # 802003e2 <consputc>
    printint(cols, 10, 0);
    80200a70:	fec42783          	lw	a5,-20(s0)
    80200a74:	4601                	li	a2,0
    80200a76:	45a9                	li	a1,10
    80200a78:	853e                	mv	a0,a5
    80200a7a:	00000097          	auipc	ra,0x0
    80200a7e:	9bc080e7          	jalr	-1604(ra) # 80200436 <printint>
    consputc('C');
    80200a82:	04300513          	li	a0,67
    80200a86:	00000097          	auipc	ra,0x0
    80200a8a:	95c080e7          	jalr	-1700(ra) # 802003e2 <consputc>
    80200a8e:	a011                	j	80200a92 <cursor_right+0x50>
    if (cols <= 0) return;
    80200a90:	0001                	nop
}
    80200a92:	60e2                	ld	ra,24(sp)
    80200a94:	6442                	ld	s0,16(sp)
    80200a96:	6105                	addi	sp,sp,32
    80200a98:	8082                	ret

0000000080200a9a <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    80200a9a:	1101                	addi	sp,sp,-32
    80200a9c:	ec06                	sd	ra,24(sp)
    80200a9e:	e822                	sd	s0,16(sp)
    80200aa0:	1000                	addi	s0,sp,32
    80200aa2:	87aa                	mv	a5,a0
    80200aa4:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80200aa8:	fec42783          	lw	a5,-20(s0)
    80200aac:	2781                	sext.w	a5,a5
    80200aae:	02f05d63          	blez	a5,80200ae8 <cursor_left+0x4e>
    consputc('\033');
    80200ab2:	456d                	li	a0,27
    80200ab4:	00000097          	auipc	ra,0x0
    80200ab8:	92e080e7          	jalr	-1746(ra) # 802003e2 <consputc>
    consputc('[');
    80200abc:	05b00513          	li	a0,91
    80200ac0:	00000097          	auipc	ra,0x0
    80200ac4:	922080e7          	jalr	-1758(ra) # 802003e2 <consputc>
    printint(cols, 10, 0);
    80200ac8:	fec42783          	lw	a5,-20(s0)
    80200acc:	4601                	li	a2,0
    80200ace:	45a9                	li	a1,10
    80200ad0:	853e                	mv	a0,a5
    80200ad2:	00000097          	auipc	ra,0x0
    80200ad6:	964080e7          	jalr	-1692(ra) # 80200436 <printint>
    consputc('D');
    80200ada:	04400513          	li	a0,68
    80200ade:	00000097          	auipc	ra,0x0
    80200ae2:	904080e7          	jalr	-1788(ra) # 802003e2 <consputc>
    80200ae6:	a011                	j	80200aea <cursor_left+0x50>
    if (cols <= 0) return;
    80200ae8:	0001                	nop
}
    80200aea:	60e2                	ld	ra,24(sp)
    80200aec:	6442                	ld	s0,16(sp)
    80200aee:	6105                	addi	sp,sp,32
    80200af0:	8082                	ret

0000000080200af2 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    80200af2:	1141                	addi	sp,sp,-16
    80200af4:	e406                	sd	ra,8(sp)
    80200af6:	e022                	sd	s0,0(sp)
    80200af8:	0800                	addi	s0,sp,16
    consputc('\033');
    80200afa:	456d                	li	a0,27
    80200afc:	00000097          	auipc	ra,0x0
    80200b00:	8e6080e7          	jalr	-1818(ra) # 802003e2 <consputc>
    consputc('[');
    80200b04:	05b00513          	li	a0,91
    80200b08:	00000097          	auipc	ra,0x0
    80200b0c:	8da080e7          	jalr	-1830(ra) # 802003e2 <consputc>
    consputc('s');
    80200b10:	07300513          	li	a0,115
    80200b14:	00000097          	auipc	ra,0x0
    80200b18:	8ce080e7          	jalr	-1842(ra) # 802003e2 <consputc>
}
    80200b1c:	0001                	nop
    80200b1e:	60a2                	ld	ra,8(sp)
    80200b20:	6402                	ld	s0,0(sp)
    80200b22:	0141                	addi	sp,sp,16
    80200b24:	8082                	ret

0000000080200b26 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    80200b26:	1141                	addi	sp,sp,-16
    80200b28:	e406                	sd	ra,8(sp)
    80200b2a:	e022                	sd	s0,0(sp)
    80200b2c:	0800                	addi	s0,sp,16
    consputc('\033');
    80200b2e:	456d                	li	a0,27
    80200b30:	00000097          	auipc	ra,0x0
    80200b34:	8b2080e7          	jalr	-1870(ra) # 802003e2 <consputc>
    consputc('[');
    80200b38:	05b00513          	li	a0,91
    80200b3c:	00000097          	auipc	ra,0x0
    80200b40:	8a6080e7          	jalr	-1882(ra) # 802003e2 <consputc>
    consputc('u');
    80200b44:	07500513          	li	a0,117
    80200b48:	00000097          	auipc	ra,0x0
    80200b4c:	89a080e7          	jalr	-1894(ra) # 802003e2 <consputc>
}
    80200b50:	0001                	nop
    80200b52:	60a2                	ld	ra,8(sp)
    80200b54:	6402                	ld	s0,0(sp)
    80200b56:	0141                	addi	sp,sp,16
    80200b58:	8082                	ret

0000000080200b5a <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    80200b5a:	1101                	addi	sp,sp,-32
    80200b5c:	ec06                	sd	ra,24(sp)
    80200b5e:	e822                	sd	s0,16(sp)
    80200b60:	1000                	addi	s0,sp,32
    80200b62:	87aa                	mv	a5,a0
    80200b64:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    80200b68:	fec42783          	lw	a5,-20(s0)
    80200b6c:	2781                	sext.w	a5,a5
    80200b6e:	00f04563          	bgtz	a5,80200b78 <cursor_to_column+0x1e>
    80200b72:	4785                	li	a5,1
    80200b74:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    80200b78:	456d                	li	a0,27
    80200b7a:	00000097          	auipc	ra,0x0
    80200b7e:	868080e7          	jalr	-1944(ra) # 802003e2 <consputc>
    consputc('[');
    80200b82:	05b00513          	li	a0,91
    80200b86:	00000097          	auipc	ra,0x0
    80200b8a:	85c080e7          	jalr	-1956(ra) # 802003e2 <consputc>
    printint(col, 10, 0);
    80200b8e:	fec42783          	lw	a5,-20(s0)
    80200b92:	4601                	li	a2,0
    80200b94:	45a9                	li	a1,10
    80200b96:	853e                	mv	a0,a5
    80200b98:	00000097          	auipc	ra,0x0
    80200b9c:	89e080e7          	jalr	-1890(ra) # 80200436 <printint>
    consputc('G');
    80200ba0:	04700513          	li	a0,71
    80200ba4:	00000097          	auipc	ra,0x0
    80200ba8:	83e080e7          	jalr	-1986(ra) # 802003e2 <consputc>
}
    80200bac:	0001                	nop
    80200bae:	60e2                	ld	ra,24(sp)
    80200bb0:	6442                	ld	s0,16(sp)
    80200bb2:	6105                	addi	sp,sp,32
    80200bb4:	8082                	ret

0000000080200bb6 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80200bb6:	1101                	addi	sp,sp,-32
    80200bb8:	ec06                	sd	ra,24(sp)
    80200bba:	e822                	sd	s0,16(sp)
    80200bbc:	1000                	addi	s0,sp,32
    80200bbe:	87aa                	mv	a5,a0
    80200bc0:	872e                	mv	a4,a1
    80200bc2:	fef42623          	sw	a5,-20(s0)
    80200bc6:	87ba                	mv	a5,a4
    80200bc8:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    80200bcc:	456d                	li	a0,27
    80200bce:	00000097          	auipc	ra,0x0
    80200bd2:	814080e7          	jalr	-2028(ra) # 802003e2 <consputc>
    consputc('[');
    80200bd6:	05b00513          	li	a0,91
    80200bda:	00000097          	auipc	ra,0x0
    80200bde:	808080e7          	jalr	-2040(ra) # 802003e2 <consputc>
    printint(row, 10, 0);
    80200be2:	fec42783          	lw	a5,-20(s0)
    80200be6:	4601                	li	a2,0
    80200be8:	45a9                	li	a1,10
    80200bea:	853e                	mv	a0,a5
    80200bec:	00000097          	auipc	ra,0x0
    80200bf0:	84a080e7          	jalr	-1974(ra) # 80200436 <printint>
    consputc(';');
    80200bf4:	03b00513          	li	a0,59
    80200bf8:	fffff097          	auipc	ra,0xfffff
    80200bfc:	7ea080e7          	jalr	2026(ra) # 802003e2 <consputc>
    printint(col, 10, 0);
    80200c00:	fe842783          	lw	a5,-24(s0)
    80200c04:	4601                	li	a2,0
    80200c06:	45a9                	li	a1,10
    80200c08:	853e                	mv	a0,a5
    80200c0a:	00000097          	auipc	ra,0x0
    80200c0e:	82c080e7          	jalr	-2004(ra) # 80200436 <printint>
    consputc('H');
    80200c12:	04800513          	li	a0,72
    80200c16:	fffff097          	auipc	ra,0xfffff
    80200c1a:	7cc080e7          	jalr	1996(ra) # 802003e2 <consputc>
}
    80200c1e:	0001                	nop
    80200c20:	60e2                	ld	ra,24(sp)
    80200c22:	6442                	ld	s0,16(sp)
    80200c24:	6105                	addi	sp,sp,32
    80200c26:	8082                	ret

0000000080200c28 <reset_color>:
// 颜色控制
void reset_color(void) {
    80200c28:	1141                	addi	sp,sp,-16
    80200c2a:	e406                	sd	ra,8(sp)
    80200c2c:	e022                	sd	s0,0(sp)
    80200c2e:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    80200c30:	00003517          	auipc	a0,0x3
    80200c34:	7b850513          	addi	a0,a0,1976 # 802043e8 <small_numbers+0x220>
    80200c38:	fffff097          	auipc	ra,0xfffff
    80200c3c:	5c6080e7          	jalr	1478(ra) # 802001fe <uart_puts>
}
    80200c40:	0001                	nop
    80200c42:	60a2                	ld	ra,8(sp)
    80200c44:	6402                	ld	s0,0(sp)
    80200c46:	0141                	addi	sp,sp,16
    80200c48:	8082                	ret

0000000080200c4a <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    80200c4a:	1101                	addi	sp,sp,-32
    80200c4c:	ec06                	sd	ra,24(sp)
    80200c4e:	e822                	sd	s0,16(sp)
    80200c50:	1000                	addi	s0,sp,32
    80200c52:	87aa                	mv	a5,a0
    80200c54:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    80200c58:	fec42783          	lw	a5,-20(s0)
    80200c5c:	0007871b          	sext.w	a4,a5
    80200c60:	47f5                	li	a5,29
    80200c62:	04e7d563          	bge	a5,a4,80200cac <set_fg_color+0x62>
    80200c66:	fec42783          	lw	a5,-20(s0)
    80200c6a:	0007871b          	sext.w	a4,a5
    80200c6e:	02500793          	li	a5,37
    80200c72:	02e7cd63          	blt	a5,a4,80200cac <set_fg_color+0x62>
	consputc('\033');
    80200c76:	456d                	li	a0,27
    80200c78:	fffff097          	auipc	ra,0xfffff
    80200c7c:	76a080e7          	jalr	1898(ra) # 802003e2 <consputc>
	consputc('[');
    80200c80:	05b00513          	li	a0,91
    80200c84:	fffff097          	auipc	ra,0xfffff
    80200c88:	75e080e7          	jalr	1886(ra) # 802003e2 <consputc>
	printint(color, 10, 0);
    80200c8c:	fec42783          	lw	a5,-20(s0)
    80200c90:	4601                	li	a2,0
    80200c92:	45a9                	li	a1,10
    80200c94:	853e                	mv	a0,a5
    80200c96:	fffff097          	auipc	ra,0xfffff
    80200c9a:	7a0080e7          	jalr	1952(ra) # 80200436 <printint>
	consputc('m');
    80200c9e:	06d00513          	li	a0,109
    80200ca2:	fffff097          	auipc	ra,0xfffff
    80200ca6:	740080e7          	jalr	1856(ra) # 802003e2 <consputc>
    80200caa:	a011                	j	80200cae <set_fg_color+0x64>
	if (color < 30 || color > 37) return; // 支持30-37
    80200cac:	0001                	nop
}
    80200cae:	60e2                	ld	ra,24(sp)
    80200cb0:	6442                	ld	s0,16(sp)
    80200cb2:	6105                	addi	sp,sp,32
    80200cb4:	8082                	ret

0000000080200cb6 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    80200cb6:	1101                	addi	sp,sp,-32
    80200cb8:	ec06                	sd	ra,24(sp)
    80200cba:	e822                	sd	s0,16(sp)
    80200cbc:	1000                	addi	s0,sp,32
    80200cbe:	87aa                	mv	a5,a0
    80200cc0:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    80200cc4:	fec42783          	lw	a5,-20(s0)
    80200cc8:	0007871b          	sext.w	a4,a5
    80200ccc:	02700793          	li	a5,39
    80200cd0:	04e7d563          	bge	a5,a4,80200d1a <set_bg_color+0x64>
    80200cd4:	fec42783          	lw	a5,-20(s0)
    80200cd8:	0007871b          	sext.w	a4,a5
    80200cdc:	02f00793          	li	a5,47
    80200ce0:	02e7cd63          	blt	a5,a4,80200d1a <set_bg_color+0x64>
	consputc('\033');
    80200ce4:	456d                	li	a0,27
    80200ce6:	fffff097          	auipc	ra,0xfffff
    80200cea:	6fc080e7          	jalr	1788(ra) # 802003e2 <consputc>
	consputc('[');
    80200cee:	05b00513          	li	a0,91
    80200cf2:	fffff097          	auipc	ra,0xfffff
    80200cf6:	6f0080e7          	jalr	1776(ra) # 802003e2 <consputc>
	printint(color, 10, 0);
    80200cfa:	fec42783          	lw	a5,-20(s0)
    80200cfe:	4601                	li	a2,0
    80200d00:	45a9                	li	a1,10
    80200d02:	853e                	mv	a0,a5
    80200d04:	fffff097          	auipc	ra,0xfffff
    80200d08:	732080e7          	jalr	1842(ra) # 80200436 <printint>
	consputc('m');
    80200d0c:	06d00513          	li	a0,109
    80200d10:	fffff097          	auipc	ra,0xfffff
    80200d14:	6d2080e7          	jalr	1746(ra) # 802003e2 <consputc>
    80200d18:	a011                	j	80200d1c <set_bg_color+0x66>
	if (color < 40 || color > 47) return; // 支持40-47
    80200d1a:	0001                	nop
}
    80200d1c:	60e2                	ld	ra,24(sp)
    80200d1e:	6442                	ld	s0,16(sp)
    80200d20:	6105                	addi	sp,sp,32
    80200d22:	8082                	ret

0000000080200d24 <color_red>:
// 简易文字颜色
void color_red(void) {
    80200d24:	1141                	addi	sp,sp,-16
    80200d26:	e406                	sd	ra,8(sp)
    80200d28:	e022                	sd	s0,0(sp)
    80200d2a:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    80200d2c:	457d                	li	a0,31
    80200d2e:	00000097          	auipc	ra,0x0
    80200d32:	f1c080e7          	jalr	-228(ra) # 80200c4a <set_fg_color>
}
    80200d36:	0001                	nop
    80200d38:	60a2                	ld	ra,8(sp)
    80200d3a:	6402                	ld	s0,0(sp)
    80200d3c:	0141                	addi	sp,sp,16
    80200d3e:	8082                	ret

0000000080200d40 <color_green>:
void color_green(void) {
    80200d40:	1141                	addi	sp,sp,-16
    80200d42:	e406                	sd	ra,8(sp)
    80200d44:	e022                	sd	s0,0(sp)
    80200d46:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    80200d48:	02000513          	li	a0,32
    80200d4c:	00000097          	auipc	ra,0x0
    80200d50:	efe080e7          	jalr	-258(ra) # 80200c4a <set_fg_color>
}
    80200d54:	0001                	nop
    80200d56:	60a2                	ld	ra,8(sp)
    80200d58:	6402                	ld	s0,0(sp)
    80200d5a:	0141                	addi	sp,sp,16
    80200d5c:	8082                	ret

0000000080200d5e <color_yellow>:
void color_yellow(void) {
    80200d5e:	1141                	addi	sp,sp,-16
    80200d60:	e406                	sd	ra,8(sp)
    80200d62:	e022                	sd	s0,0(sp)
    80200d64:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    80200d66:	02100513          	li	a0,33
    80200d6a:	00000097          	auipc	ra,0x0
    80200d6e:	ee0080e7          	jalr	-288(ra) # 80200c4a <set_fg_color>
}
    80200d72:	0001                	nop
    80200d74:	60a2                	ld	ra,8(sp)
    80200d76:	6402                	ld	s0,0(sp)
    80200d78:	0141                	addi	sp,sp,16
    80200d7a:	8082                	ret

0000000080200d7c <color_blue>:
void color_blue(void) {
    80200d7c:	1141                	addi	sp,sp,-16
    80200d7e:	e406                	sd	ra,8(sp)
    80200d80:	e022                	sd	s0,0(sp)
    80200d82:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    80200d84:	02200513          	li	a0,34
    80200d88:	00000097          	auipc	ra,0x0
    80200d8c:	ec2080e7          	jalr	-318(ra) # 80200c4a <set_fg_color>
}
    80200d90:	0001                	nop
    80200d92:	60a2                	ld	ra,8(sp)
    80200d94:	6402                	ld	s0,0(sp)
    80200d96:	0141                	addi	sp,sp,16
    80200d98:	8082                	ret

0000000080200d9a <color_purple>:
void color_purple(void) {
    80200d9a:	1141                	addi	sp,sp,-16
    80200d9c:	e406                	sd	ra,8(sp)
    80200d9e:	e022                	sd	s0,0(sp)
    80200da0:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80200da2:	02300513          	li	a0,35
    80200da6:	00000097          	auipc	ra,0x0
    80200daa:	ea4080e7          	jalr	-348(ra) # 80200c4a <set_fg_color>
}
    80200dae:	0001                	nop
    80200db0:	60a2                	ld	ra,8(sp)
    80200db2:	6402                	ld	s0,0(sp)
    80200db4:	0141                	addi	sp,sp,16
    80200db6:	8082                	ret

0000000080200db8 <color_cyan>:
void color_cyan(void) {
    80200db8:	1141                	addi	sp,sp,-16
    80200dba:	e406                	sd	ra,8(sp)
    80200dbc:	e022                	sd	s0,0(sp)
    80200dbe:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    80200dc0:	02400513          	li	a0,36
    80200dc4:	00000097          	auipc	ra,0x0
    80200dc8:	e86080e7          	jalr	-378(ra) # 80200c4a <set_fg_color>
}
    80200dcc:	0001                	nop
    80200dce:	60a2                	ld	ra,8(sp)
    80200dd0:	6402                	ld	s0,0(sp)
    80200dd2:	0141                	addi	sp,sp,16
    80200dd4:	8082                	ret

0000000080200dd6 <color_reverse>:
void color_reverse(void){
    80200dd6:	1141                	addi	sp,sp,-16
    80200dd8:	e406                	sd	ra,8(sp)
    80200dda:	e022                	sd	s0,0(sp)
    80200ddc:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    80200dde:	02500513          	li	a0,37
    80200de2:	00000097          	auipc	ra,0x0
    80200de6:	e68080e7          	jalr	-408(ra) # 80200c4a <set_fg_color>
}
    80200dea:	0001                	nop
    80200dec:	60a2                	ld	ra,8(sp)
    80200dee:	6402                	ld	s0,0(sp)
    80200df0:	0141                	addi	sp,sp,16
    80200df2:	8082                	ret

0000000080200df4 <set_color>:
void set_color(int fg, int bg) {
    80200df4:	1101                	addi	sp,sp,-32
    80200df6:	ec06                	sd	ra,24(sp)
    80200df8:	e822                	sd	s0,16(sp)
    80200dfa:	1000                	addi	s0,sp,32
    80200dfc:	87aa                	mv	a5,a0
    80200dfe:	872e                	mv	a4,a1
    80200e00:	fef42623          	sw	a5,-20(s0)
    80200e04:	87ba                	mv	a5,a4
    80200e06:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    80200e0a:	fe842783          	lw	a5,-24(s0)
    80200e0e:	853e                	mv	a0,a5
    80200e10:	00000097          	auipc	ra,0x0
    80200e14:	ea6080e7          	jalr	-346(ra) # 80200cb6 <set_bg_color>
	set_fg_color(fg);
    80200e18:	fec42783          	lw	a5,-20(s0)
    80200e1c:	853e                	mv	a0,a5
    80200e1e:	00000097          	auipc	ra,0x0
    80200e22:	e2c080e7          	jalr	-468(ra) # 80200c4a <set_fg_color>
}
    80200e26:	0001                	nop
    80200e28:	60e2                	ld	ra,24(sp)
    80200e2a:	6442                	ld	s0,16(sp)
    80200e2c:	6105                	addi	sp,sp,32
    80200e2e:	8082                	ret

0000000080200e30 <clear_line>:
void clear_line(){
    80200e30:	1141                	addi	sp,sp,-16
    80200e32:	e406                	sd	ra,8(sp)
    80200e34:	e022                	sd	s0,0(sp)
    80200e36:	0800                	addi	s0,sp,16
	consputc('\033');
    80200e38:	456d                	li	a0,27
    80200e3a:	fffff097          	auipc	ra,0xfffff
    80200e3e:	5a8080e7          	jalr	1448(ra) # 802003e2 <consputc>
	consputc('[');
    80200e42:	05b00513          	li	a0,91
    80200e46:	fffff097          	auipc	ra,0xfffff
    80200e4a:	59c080e7          	jalr	1436(ra) # 802003e2 <consputc>
	consputc('2');
    80200e4e:	03200513          	li	a0,50
    80200e52:	fffff097          	auipc	ra,0xfffff
    80200e56:	590080e7          	jalr	1424(ra) # 802003e2 <consputc>
	consputc('K');
    80200e5a:	04b00513          	li	a0,75
    80200e5e:	fffff097          	auipc	ra,0xfffff
    80200e62:	584080e7          	jalr	1412(ra) # 802003e2 <consputc>
}
    80200e66:	0001                	nop
    80200e68:	60a2                	ld	ra,8(sp)
    80200e6a:	6402                	ld	s0,0(sp)
    80200e6c:	0141                	addi	sp,sp,16
    80200e6e:	8082                	ret

0000000080200e70 <panic>:

void panic(const char *msg) {
    80200e70:	1101                	addi	sp,sp,-32
    80200e72:	ec06                	sd	ra,24(sp)
    80200e74:	e822                	sd	s0,16(sp)
    80200e76:	1000                	addi	s0,sp,32
    80200e78:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    80200e7c:	00000097          	auipc	ra,0x0
    80200e80:	ea8080e7          	jalr	-344(ra) # 80200d24 <color_red>
	printf("panic: %s\n", msg);
    80200e84:	fe843583          	ld	a1,-24(s0)
    80200e88:	00003517          	auipc	a0,0x3
    80200e8c:	56850513          	addi	a0,a0,1384 # 802043f0 <small_numbers+0x228>
    80200e90:	fffff097          	auipc	ra,0xfffff
    80200e94:	6d8080e7          	jalr	1752(ra) # 80200568 <printf>
	reset_color();
    80200e98:	00000097          	auipc	ra,0x0
    80200e9c:	d90080e7          	jalr	-624(ra) # 80200c28 <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    80200ea0:	0001                	nop
    80200ea2:	bffd                	j	80200ea0 <panic+0x30>

0000000080200ea4 <test_printf_precision>:
}
void test_printf_precision(void) {
    80200ea4:	1101                	addi	sp,sp,-32
    80200ea6:	ec06                	sd	ra,24(sp)
    80200ea8:	e822                	sd	s0,16(sp)
    80200eaa:	1000                	addi	s0,sp,32
	clear_screen();
    80200eac:	00000097          	auipc	ra,0x0
    80200eb0:	ab4080e7          	jalr	-1356(ra) # 80200960 <clear_screen>
    printf("=== 详细的Printf测试 ===\n");
    80200eb4:	00003517          	auipc	a0,0x3
    80200eb8:	54c50513          	addi	a0,a0,1356 # 80204400 <small_numbers+0x238>
    80200ebc:	fffff097          	auipc	ra,0xfffff
    80200ec0:	6ac080e7          	jalr	1708(ra) # 80200568 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    80200ec4:	00003517          	auipc	a0,0x3
    80200ec8:	55c50513          	addi	a0,a0,1372 # 80204420 <small_numbers+0x258>
    80200ecc:	fffff097          	auipc	ra,0xfffff
    80200ed0:	69c080e7          	jalr	1692(ra) # 80200568 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    80200ed4:	0ff00593          	li	a1,255
    80200ed8:	00003517          	auipc	a0,0x3
    80200edc:	56050513          	addi	a0,a0,1376 # 80204438 <small_numbers+0x270>
    80200ee0:	fffff097          	auipc	ra,0xfffff
    80200ee4:	688080e7          	jalr	1672(ra) # 80200568 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    80200ee8:	6585                	lui	a1,0x1
    80200eea:	00003517          	auipc	a0,0x3
    80200eee:	56e50513          	addi	a0,a0,1390 # 80204458 <small_numbers+0x290>
    80200ef2:	fffff097          	auipc	ra,0xfffff
    80200ef6:	676080e7          	jalr	1654(ra) # 80200568 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    80200efa:	1234b7b7          	lui	a5,0x1234b
    80200efe:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    80200f02:	00003517          	auipc	a0,0x3
    80200f06:	57650513          	addi	a0,a0,1398 # 80204478 <small_numbers+0x2b0>
    80200f0a:	fffff097          	auipc	ra,0xfffff
    80200f0e:	65e080e7          	jalr	1630(ra) # 80200568 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    80200f12:	00003517          	auipc	a0,0x3
    80200f16:	57e50513          	addi	a0,a0,1406 # 80204490 <small_numbers+0x2c8>
    80200f1a:	fffff097          	auipc	ra,0xfffff
    80200f1e:	64e080e7          	jalr	1614(ra) # 80200568 <printf>
    printf("  正数: %d\n", 42);
    80200f22:	02a00593          	li	a1,42
    80200f26:	00003517          	auipc	a0,0x3
    80200f2a:	58250513          	addi	a0,a0,1410 # 802044a8 <small_numbers+0x2e0>
    80200f2e:	fffff097          	auipc	ra,0xfffff
    80200f32:	63a080e7          	jalr	1594(ra) # 80200568 <printf>
    printf("  负数: %d\n", -42);
    80200f36:	fd600593          	li	a1,-42
    80200f3a:	00003517          	auipc	a0,0x3
    80200f3e:	57e50513          	addi	a0,a0,1406 # 802044b8 <small_numbers+0x2f0>
    80200f42:	fffff097          	auipc	ra,0xfffff
    80200f46:	626080e7          	jalr	1574(ra) # 80200568 <printf>
    printf("  零: %d\n", 0);
    80200f4a:	4581                	li	a1,0
    80200f4c:	00003517          	auipc	a0,0x3
    80200f50:	57c50513          	addi	a0,a0,1404 # 802044c8 <small_numbers+0x300>
    80200f54:	fffff097          	auipc	ra,0xfffff
    80200f58:	614080e7          	jalr	1556(ra) # 80200568 <printf>
    printf("  大数: %d\n", 123456789);
    80200f5c:	075bd7b7          	lui	a5,0x75bd
    80200f60:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    80200f64:	00003517          	auipc	a0,0x3
    80200f68:	57450513          	addi	a0,a0,1396 # 802044d8 <small_numbers+0x310>
    80200f6c:	fffff097          	auipc	ra,0xfffff
    80200f70:	5fc080e7          	jalr	1532(ra) # 80200568 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80200f74:	00003517          	auipc	a0,0x3
    80200f78:	57450513          	addi	a0,a0,1396 # 802044e8 <small_numbers+0x320>
    80200f7c:	fffff097          	auipc	ra,0xfffff
    80200f80:	5ec080e7          	jalr	1516(ra) # 80200568 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80200f84:	55fd                	li	a1,-1
    80200f86:	00003517          	auipc	a0,0x3
    80200f8a:	57a50513          	addi	a0,a0,1402 # 80204500 <small_numbers+0x338>
    80200f8e:	fffff097          	auipc	ra,0xfffff
    80200f92:	5da080e7          	jalr	1498(ra) # 80200568 <printf>
    printf("  零：%u\n", 0U);
    80200f96:	4581                	li	a1,0
    80200f98:	00003517          	auipc	a0,0x3
    80200f9c:	58050513          	addi	a0,a0,1408 # 80204518 <small_numbers+0x350>
    80200fa0:	fffff097          	auipc	ra,0xfffff
    80200fa4:	5c8080e7          	jalr	1480(ra) # 80200568 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80200fa8:	678d                	lui	a5,0x3
    80200faa:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    80200fae:	00003517          	auipc	a0,0x3
    80200fb2:	57a50513          	addi	a0,a0,1402 # 80204528 <small_numbers+0x360>
    80200fb6:	fffff097          	auipc	ra,0xfffff
    80200fba:	5b2080e7          	jalr	1458(ra) # 80200568 <printf>

	// 测试边界
	printf("边界测试:\n");
    80200fbe:	00003517          	auipc	a0,0x3
    80200fc2:	58250513          	addi	a0,a0,1410 # 80204540 <small_numbers+0x378>
    80200fc6:	fffff097          	auipc	ra,0xfffff
    80200fca:	5a2080e7          	jalr	1442(ra) # 80200568 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    80200fce:	800007b7          	lui	a5,0x80000
    80200fd2:	fff7c593          	not	a1,a5
    80200fd6:	00003517          	auipc	a0,0x3
    80200fda:	57a50513          	addi	a0,a0,1402 # 80204550 <small_numbers+0x388>
    80200fde:	fffff097          	auipc	ra,0xfffff
    80200fe2:	58a080e7          	jalr	1418(ra) # 80200568 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    80200fe6:	800005b7          	lui	a1,0x80000
    80200fea:	00003517          	auipc	a0,0x3
    80200fee:	57650513          	addi	a0,a0,1398 # 80204560 <small_numbers+0x398>
    80200ff2:	fffff097          	auipc	ra,0xfffff
    80200ff6:	576080e7          	jalr	1398(ra) # 80200568 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    80200ffa:	55fd                	li	a1,-1
    80200ffc:	00003517          	auipc	a0,0x3
    80201000:	57450513          	addi	a0,a0,1396 # 80204570 <small_numbers+0x3a8>
    80201004:	fffff097          	auipc	ra,0xfffff
    80201008:	564080e7          	jalr	1380(ra) # 80200568 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    8020100c:	55fd                	li	a1,-1
    8020100e:	00003517          	auipc	a0,0x3
    80201012:	57250513          	addi	a0,a0,1394 # 80204580 <small_numbers+0x3b8>
    80201016:	fffff097          	auipc	ra,0xfffff
    8020101a:	552080e7          	jalr	1362(ra) # 80200568 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    8020101e:	00003517          	auipc	a0,0x3
    80201022:	57a50513          	addi	a0,a0,1402 # 80204598 <small_numbers+0x3d0>
    80201026:	fffff097          	auipc	ra,0xfffff
    8020102a:	542080e7          	jalr	1346(ra) # 80200568 <printf>
    printf("  空字符串: '%s'\n", "");
    8020102e:	00003597          	auipc	a1,0x3
    80201032:	58258593          	addi	a1,a1,1410 # 802045b0 <small_numbers+0x3e8>
    80201036:	00003517          	auipc	a0,0x3
    8020103a:	58250513          	addi	a0,a0,1410 # 802045b8 <small_numbers+0x3f0>
    8020103e:	fffff097          	auipc	ra,0xfffff
    80201042:	52a080e7          	jalr	1322(ra) # 80200568 <printf>
    printf("  单字符: '%s'\n", "X");
    80201046:	00003597          	auipc	a1,0x3
    8020104a:	58a58593          	addi	a1,a1,1418 # 802045d0 <small_numbers+0x408>
    8020104e:	00003517          	auipc	a0,0x3
    80201052:	58a50513          	addi	a0,a0,1418 # 802045d8 <small_numbers+0x410>
    80201056:	fffff097          	auipc	ra,0xfffff
    8020105a:	512080e7          	jalr	1298(ra) # 80200568 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    8020105e:	00003597          	auipc	a1,0x3
    80201062:	59258593          	addi	a1,a1,1426 # 802045f0 <small_numbers+0x428>
    80201066:	00003517          	auipc	a0,0x3
    8020106a:	5aa50513          	addi	a0,a0,1450 # 80204610 <small_numbers+0x448>
    8020106e:	fffff097          	auipc	ra,0xfffff
    80201072:	4fa080e7          	jalr	1274(ra) # 80200568 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80201076:	00003597          	auipc	a1,0x3
    8020107a:	5b258593          	addi	a1,a1,1458 # 80204628 <small_numbers+0x460>
    8020107e:	00003517          	auipc	a0,0x3
    80201082:	6fa50513          	addi	a0,a0,1786 # 80204778 <small_numbers+0x5b0>
    80201086:	fffff097          	auipc	ra,0xfffff
    8020108a:	4e2080e7          	jalr	1250(ra) # 80200568 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    8020108e:	00003517          	auipc	a0,0x3
    80201092:	70a50513          	addi	a0,a0,1802 # 80204798 <small_numbers+0x5d0>
    80201096:	fffff097          	auipc	ra,0xfffff
    8020109a:	4d2080e7          	jalr	1234(ra) # 80200568 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    8020109e:	0ff00693          	li	a3,255
    802010a2:	f0100613          	li	a2,-255
    802010a6:	0ff00593          	li	a1,255
    802010aa:	00003517          	auipc	a0,0x3
    802010ae:	70650513          	addi	a0,a0,1798 # 802047b0 <small_numbers+0x5e8>
    802010b2:	fffff097          	auipc	ra,0xfffff
    802010b6:	4b6080e7          	jalr	1206(ra) # 80200568 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    802010ba:	00003517          	auipc	a0,0x3
    802010be:	71e50513          	addi	a0,a0,1822 # 802047d8 <small_numbers+0x610>
    802010c2:	fffff097          	auipc	ra,0xfffff
    802010c6:	4a6080e7          	jalr	1190(ra) # 80200568 <printf>
	printf("  100%% 完成!\n");
    802010ca:	00003517          	auipc	a0,0x3
    802010ce:	72650513          	addi	a0,a0,1830 # 802047f0 <small_numbers+0x628>
    802010d2:	fffff097          	auipc	ra,0xfffff
    802010d6:	496080e7          	jalr	1174(ra) # 80200568 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    802010da:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    802010de:	00003517          	auipc	a0,0x3
    802010e2:	72a50513          	addi	a0,a0,1834 # 80204808 <small_numbers+0x640>
    802010e6:	fffff097          	auipc	ra,0xfffff
    802010ea:	482080e7          	jalr	1154(ra) # 80200568 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    802010ee:	fe843583          	ld	a1,-24(s0)
    802010f2:	00003517          	auipc	a0,0x3
    802010f6:	72e50513          	addi	a0,a0,1838 # 80204820 <small_numbers+0x658>
    802010fa:	fffff097          	auipc	ra,0xfffff
    802010fe:	46e080e7          	jalr	1134(ra) # 80200568 <printf>
	
	// 测试指针格式
	int var = 42;
    80201102:	02a00793          	li	a5,42
    80201106:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    8020110a:	00003517          	auipc	a0,0x3
    8020110e:	72e50513          	addi	a0,a0,1838 # 80204838 <small_numbers+0x670>
    80201112:	fffff097          	auipc	ra,0xfffff
    80201116:	456080e7          	jalr	1110(ra) # 80200568 <printf>
	printf("  Address of var: %p\n", &var);
    8020111a:	fe440793          	addi	a5,s0,-28
    8020111e:	85be                	mv	a1,a5
    80201120:	00003517          	auipc	a0,0x3
    80201124:	72850513          	addi	a0,a0,1832 # 80204848 <small_numbers+0x680>
    80201128:	fffff097          	auipc	ra,0xfffff
    8020112c:	440080e7          	jalr	1088(ra) # 80200568 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80201130:	00003517          	auipc	a0,0x3
    80201134:	73050513          	addi	a0,a0,1840 # 80204860 <small_numbers+0x698>
    80201138:	fffff097          	auipc	ra,0xfffff
    8020113c:	430080e7          	jalr	1072(ra) # 80200568 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201140:	55fd                	li	a1,-1
    80201142:	00003517          	auipc	a0,0x3
    80201146:	73e50513          	addi	a0,a0,1854 # 80204880 <small_numbers+0x6b8>
    8020114a:	fffff097          	auipc	ra,0xfffff
    8020114e:	41e080e7          	jalr	1054(ra) # 80200568 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201152:	00003517          	auipc	a0,0x3
    80201156:	74650513          	addi	a0,a0,1862 # 80204898 <small_numbers+0x6d0>
    8020115a:	fffff097          	auipc	ra,0xfffff
    8020115e:	40e080e7          	jalr	1038(ra) # 80200568 <printf>
	printf("  Binary of 5: %b\n", 5);
    80201162:	4595                	li	a1,5
    80201164:	00003517          	auipc	a0,0x3
    80201168:	74c50513          	addi	a0,a0,1868 # 802048b0 <small_numbers+0x6e8>
    8020116c:	fffff097          	auipc	ra,0xfffff
    80201170:	3fc080e7          	jalr	1020(ra) # 80200568 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201174:	45a1                	li	a1,8
    80201176:	00003517          	auipc	a0,0x3
    8020117a:	75250513          	addi	a0,a0,1874 # 802048c8 <small_numbers+0x700>
    8020117e:	fffff097          	auipc	ra,0xfffff
    80201182:	3ea080e7          	jalr	1002(ra) # 80200568 <printf>
	printf("=== Printf测试结束 ===\n");
    80201186:	00003517          	auipc	a0,0x3
    8020118a:	75a50513          	addi	a0,a0,1882 # 802048e0 <small_numbers+0x718>
    8020118e:	fffff097          	auipc	ra,0xfffff
    80201192:	3da080e7          	jalr	986(ra) # 80200568 <printf>
}
    80201196:	0001                	nop
    80201198:	60e2                	ld	ra,24(sp)
    8020119a:	6442                	ld	s0,16(sp)
    8020119c:	6105                	addi	sp,sp,32
    8020119e:	8082                	ret

00000000802011a0 <test_curse_move>:
void test_curse_move(){
    802011a0:	1101                	addi	sp,sp,-32
    802011a2:	ec06                	sd	ra,24(sp)
    802011a4:	e822                	sd	s0,16(sp)
    802011a6:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    802011a8:	fffff097          	auipc	ra,0xfffff
    802011ac:	7b8080e7          	jalr	1976(ra) # 80200960 <clear_screen>
	printf("=== 光标移动测试 ===\n");
    802011b0:	00003517          	auipc	a0,0x3
    802011b4:	75050513          	addi	a0,a0,1872 # 80204900 <small_numbers+0x738>
    802011b8:	fffff097          	auipc	ra,0xfffff
    802011bc:	3b0080e7          	jalr	944(ra) # 80200568 <printf>
	for (int i = 3; i <= 7; i++) {
    802011c0:	478d                	li	a5,3
    802011c2:	fef42623          	sw	a5,-20(s0)
    802011c6:	a881                	j	80201216 <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    802011c8:	4785                	li	a5,1
    802011ca:	fef42423          	sw	a5,-24(s0)
    802011ce:	a805                	j	802011fe <test_curse_move+0x5e>
			goto_rc(i, j);
    802011d0:	fe842703          	lw	a4,-24(s0)
    802011d4:	fec42783          	lw	a5,-20(s0)
    802011d8:	85ba                	mv	a1,a4
    802011da:	853e                	mv	a0,a5
    802011dc:	00000097          	auipc	ra,0x0
    802011e0:	9da080e7          	jalr	-1574(ra) # 80200bb6 <goto_rc>
			printf("*");
    802011e4:	00003517          	auipc	a0,0x3
    802011e8:	73c50513          	addi	a0,a0,1852 # 80204920 <small_numbers+0x758>
    802011ec:	fffff097          	auipc	ra,0xfffff
    802011f0:	37c080e7          	jalr	892(ra) # 80200568 <printf>
		for (int j = 1; j <= 10; j++) {
    802011f4:	fe842783          	lw	a5,-24(s0)
    802011f8:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdf8d41>
    802011fa:	fef42423          	sw	a5,-24(s0)
    802011fe:	fe842783          	lw	a5,-24(s0)
    80201202:	0007871b          	sext.w	a4,a5
    80201206:	47a9                	li	a5,10
    80201208:	fce7d4e3          	bge	a5,a4,802011d0 <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    8020120c:	fec42783          	lw	a5,-20(s0)
    80201210:	2785                	addiw	a5,a5,1
    80201212:	fef42623          	sw	a5,-20(s0)
    80201216:	fec42783          	lw	a5,-20(s0)
    8020121a:	0007871b          	sext.w	a4,a5
    8020121e:	479d                	li	a5,7
    80201220:	fae7d4e3          	bge	a5,a4,802011c8 <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201224:	4585                	li	a1,1
    80201226:	4525                	li	a0,9
    80201228:	00000097          	auipc	ra,0x0
    8020122c:	98e080e7          	jalr	-1650(ra) # 80200bb6 <goto_rc>
	save_cursor();
    80201230:	00000097          	auipc	ra,0x0
    80201234:	8c2080e7          	jalr	-1854(ra) # 80200af2 <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201238:	4515                	li	a0,5
    8020123a:	fffff097          	auipc	ra,0xfffff
    8020123e:	758080e7          	jalr	1880(ra) # 80200992 <cursor_up>
	cursor_right(2);
    80201242:	4509                	li	a0,2
    80201244:	fffff097          	auipc	ra,0xfffff
    80201248:	7fe080e7          	jalr	2046(ra) # 80200a42 <cursor_right>
	printf("+++++");
    8020124c:	00003517          	auipc	a0,0x3
    80201250:	6dc50513          	addi	a0,a0,1756 # 80204928 <small_numbers+0x760>
    80201254:	fffff097          	auipc	ra,0xfffff
    80201258:	314080e7          	jalr	788(ra) # 80200568 <printf>
	cursor_down(2);
    8020125c:	4509                	li	a0,2
    8020125e:	fffff097          	auipc	ra,0xfffff
    80201262:	78c080e7          	jalr	1932(ra) # 802009ea <cursor_down>
	cursor_left(5);
    80201266:	4515                	li	a0,5
    80201268:	00000097          	auipc	ra,0x0
    8020126c:	832080e7          	jalr	-1998(ra) # 80200a9a <cursor_left>
	printf("-----");
    80201270:	00003517          	auipc	a0,0x3
    80201274:	6c050513          	addi	a0,a0,1728 # 80204930 <small_numbers+0x768>
    80201278:	fffff097          	auipc	ra,0xfffff
    8020127c:	2f0080e7          	jalr	752(ra) # 80200568 <printf>
	restore_cursor();
    80201280:	00000097          	auipc	ra,0x0
    80201284:	8a6080e7          	jalr	-1882(ra) # 80200b26 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80201288:	00003517          	auipc	a0,0x3
    8020128c:	6b050513          	addi	a0,a0,1712 # 80204938 <small_numbers+0x770>
    80201290:	fffff097          	auipc	ra,0xfffff
    80201294:	2d8080e7          	jalr	728(ra) # 80200568 <printf>
}
    80201298:	0001                	nop
    8020129a:	60e2                	ld	ra,24(sp)
    8020129c:	6442                	ld	s0,16(sp)
    8020129e:	6105                	addi	sp,sp,32
    802012a0:	8082                	ret

00000000802012a2 <test_basic_colors>:

void test_basic_colors(void) {
    802012a2:	1141                	addi	sp,sp,-16
    802012a4:	e406                	sd	ra,8(sp)
    802012a6:	e022                	sd	s0,0(sp)
    802012a8:	0800                	addi	s0,sp,16
    clear_screen();
    802012aa:	fffff097          	auipc	ra,0xfffff
    802012ae:	6b6080e7          	jalr	1718(ra) # 80200960 <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    802012b2:	00003517          	auipc	a0,0x3
    802012b6:	6ae50513          	addi	a0,a0,1710 # 80204960 <small_numbers+0x798>
    802012ba:	fffff097          	auipc	ra,0xfffff
    802012be:	2ae080e7          	jalr	686(ra) # 80200568 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    802012c2:	00003517          	auipc	a0,0x3
    802012c6:	6be50513          	addi	a0,a0,1726 # 80204980 <small_numbers+0x7b8>
    802012ca:	fffff097          	auipc	ra,0xfffff
    802012ce:	29e080e7          	jalr	670(ra) # 80200568 <printf>
    color_red();    printf("红色文字 ");
    802012d2:	00000097          	auipc	ra,0x0
    802012d6:	a52080e7          	jalr	-1454(ra) # 80200d24 <color_red>
    802012da:	00003517          	auipc	a0,0x3
    802012de:	6be50513          	addi	a0,a0,1726 # 80204998 <small_numbers+0x7d0>
    802012e2:	fffff097          	auipc	ra,0xfffff
    802012e6:	286080e7          	jalr	646(ra) # 80200568 <printf>
    color_green();  printf("绿色文字 ");
    802012ea:	00000097          	auipc	ra,0x0
    802012ee:	a56080e7          	jalr	-1450(ra) # 80200d40 <color_green>
    802012f2:	00003517          	auipc	a0,0x3
    802012f6:	6b650513          	addi	a0,a0,1718 # 802049a8 <small_numbers+0x7e0>
    802012fa:	fffff097          	auipc	ra,0xfffff
    802012fe:	26e080e7          	jalr	622(ra) # 80200568 <printf>
    color_yellow(); printf("黄色文字 ");
    80201302:	00000097          	auipc	ra,0x0
    80201306:	a5c080e7          	jalr	-1444(ra) # 80200d5e <color_yellow>
    8020130a:	00003517          	auipc	a0,0x3
    8020130e:	6ae50513          	addi	a0,a0,1710 # 802049b8 <small_numbers+0x7f0>
    80201312:	fffff097          	auipc	ra,0xfffff
    80201316:	256080e7          	jalr	598(ra) # 80200568 <printf>
    color_blue();   printf("蓝色文字 ");
    8020131a:	00000097          	auipc	ra,0x0
    8020131e:	a62080e7          	jalr	-1438(ra) # 80200d7c <color_blue>
    80201322:	00003517          	auipc	a0,0x3
    80201326:	6a650513          	addi	a0,a0,1702 # 802049c8 <small_numbers+0x800>
    8020132a:	fffff097          	auipc	ra,0xfffff
    8020132e:	23e080e7          	jalr	574(ra) # 80200568 <printf>
    color_purple(); printf("紫色文字 ");
    80201332:	00000097          	auipc	ra,0x0
    80201336:	a68080e7          	jalr	-1432(ra) # 80200d9a <color_purple>
    8020133a:	00003517          	auipc	a0,0x3
    8020133e:	69e50513          	addi	a0,a0,1694 # 802049d8 <small_numbers+0x810>
    80201342:	fffff097          	auipc	ra,0xfffff
    80201346:	226080e7          	jalr	550(ra) # 80200568 <printf>
    color_cyan();   printf("青色文字 ");
    8020134a:	00000097          	auipc	ra,0x0
    8020134e:	a6e080e7          	jalr	-1426(ra) # 80200db8 <color_cyan>
    80201352:	00003517          	auipc	a0,0x3
    80201356:	69650513          	addi	a0,a0,1686 # 802049e8 <small_numbers+0x820>
    8020135a:	fffff097          	auipc	ra,0xfffff
    8020135e:	20e080e7          	jalr	526(ra) # 80200568 <printf>
    color_reverse();  printf("反色文字");
    80201362:	00000097          	auipc	ra,0x0
    80201366:	a74080e7          	jalr	-1420(ra) # 80200dd6 <color_reverse>
    8020136a:	00003517          	auipc	a0,0x3
    8020136e:	68e50513          	addi	a0,a0,1678 # 802049f8 <small_numbers+0x830>
    80201372:	fffff097          	auipc	ra,0xfffff
    80201376:	1f6080e7          	jalr	502(ra) # 80200568 <printf>
    reset_color();
    8020137a:	00000097          	auipc	ra,0x0
    8020137e:	8ae080e7          	jalr	-1874(ra) # 80200c28 <reset_color>
    printf("\n\n");
    80201382:	00003517          	auipc	a0,0x3
    80201386:	68650513          	addi	a0,a0,1670 # 80204a08 <small_numbers+0x840>
    8020138a:	fffff097          	auipc	ra,0xfffff
    8020138e:	1de080e7          	jalr	478(ra) # 80200568 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80201392:	00003517          	auipc	a0,0x3
    80201396:	67e50513          	addi	a0,a0,1662 # 80204a10 <small_numbers+0x848>
    8020139a:	fffff097          	auipc	ra,0xfffff
    8020139e:	1ce080e7          	jalr	462(ra) # 80200568 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    802013a2:	02900513          	li	a0,41
    802013a6:	00000097          	auipc	ra,0x0
    802013aa:	910080e7          	jalr	-1776(ra) # 80200cb6 <set_bg_color>
    802013ae:	00003517          	auipc	a0,0x3
    802013b2:	67a50513          	addi	a0,a0,1658 # 80204a28 <small_numbers+0x860>
    802013b6:	fffff097          	auipc	ra,0xfffff
    802013ba:	1b2080e7          	jalr	434(ra) # 80200568 <printf>
    802013be:	00000097          	auipc	ra,0x0
    802013c2:	86a080e7          	jalr	-1942(ra) # 80200c28 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    802013c6:	02a00513          	li	a0,42
    802013ca:	00000097          	auipc	ra,0x0
    802013ce:	8ec080e7          	jalr	-1812(ra) # 80200cb6 <set_bg_color>
    802013d2:	00003517          	auipc	a0,0x3
    802013d6:	66650513          	addi	a0,a0,1638 # 80204a38 <small_numbers+0x870>
    802013da:	fffff097          	auipc	ra,0xfffff
    802013de:	18e080e7          	jalr	398(ra) # 80200568 <printf>
    802013e2:	00000097          	auipc	ra,0x0
    802013e6:	846080e7          	jalr	-1978(ra) # 80200c28 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    802013ea:	02b00513          	li	a0,43
    802013ee:	00000097          	auipc	ra,0x0
    802013f2:	8c8080e7          	jalr	-1848(ra) # 80200cb6 <set_bg_color>
    802013f6:	00003517          	auipc	a0,0x3
    802013fa:	65250513          	addi	a0,a0,1618 # 80204a48 <small_numbers+0x880>
    802013fe:	fffff097          	auipc	ra,0xfffff
    80201402:	16a080e7          	jalr	362(ra) # 80200568 <printf>
    80201406:	00000097          	auipc	ra,0x0
    8020140a:	822080e7          	jalr	-2014(ra) # 80200c28 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    8020140e:	02c00513          	li	a0,44
    80201412:	00000097          	auipc	ra,0x0
    80201416:	8a4080e7          	jalr	-1884(ra) # 80200cb6 <set_bg_color>
    8020141a:	00003517          	auipc	a0,0x3
    8020141e:	63e50513          	addi	a0,a0,1598 # 80204a58 <small_numbers+0x890>
    80201422:	fffff097          	auipc	ra,0xfffff
    80201426:	146080e7          	jalr	326(ra) # 80200568 <printf>
    8020142a:	fffff097          	auipc	ra,0xfffff
    8020142e:	7fe080e7          	jalr	2046(ra) # 80200c28 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201432:	02f00513          	li	a0,47
    80201436:	00000097          	auipc	ra,0x0
    8020143a:	880080e7          	jalr	-1920(ra) # 80200cb6 <set_bg_color>
    8020143e:	00003517          	auipc	a0,0x3
    80201442:	62a50513          	addi	a0,a0,1578 # 80204a68 <small_numbers+0x8a0>
    80201446:	fffff097          	auipc	ra,0xfffff
    8020144a:	122080e7          	jalr	290(ra) # 80200568 <printf>
    8020144e:	fffff097          	auipc	ra,0xfffff
    80201452:	7da080e7          	jalr	2010(ra) # 80200c28 <reset_color>
    printf("\n\n");
    80201456:	00003517          	auipc	a0,0x3
    8020145a:	5b250513          	addi	a0,a0,1458 # 80204a08 <small_numbers+0x840>
    8020145e:	fffff097          	auipc	ra,0xfffff
    80201462:	10a080e7          	jalr	266(ra) # 80200568 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201466:	00003517          	auipc	a0,0x3
    8020146a:	61250513          	addi	a0,a0,1554 # 80204a78 <small_numbers+0x8b0>
    8020146e:	fffff097          	auipc	ra,0xfffff
    80201472:	0fa080e7          	jalr	250(ra) # 80200568 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201476:	02c00593          	li	a1,44
    8020147a:	457d                	li	a0,31
    8020147c:	00000097          	auipc	ra,0x0
    80201480:	978080e7          	jalr	-1672(ra) # 80200df4 <set_color>
    80201484:	00003517          	auipc	a0,0x3
    80201488:	60c50513          	addi	a0,a0,1548 # 80204a90 <small_numbers+0x8c8>
    8020148c:	fffff097          	auipc	ra,0xfffff
    80201490:	0dc080e7          	jalr	220(ra) # 80200568 <printf>
    80201494:	fffff097          	auipc	ra,0xfffff
    80201498:	794080e7          	jalr	1940(ra) # 80200c28 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    8020149c:	02d00593          	li	a1,45
    802014a0:	02100513          	li	a0,33
    802014a4:	00000097          	auipc	ra,0x0
    802014a8:	950080e7          	jalr	-1712(ra) # 80200df4 <set_color>
    802014ac:	00003517          	auipc	a0,0x3
    802014b0:	5f450513          	addi	a0,a0,1524 # 80204aa0 <small_numbers+0x8d8>
    802014b4:	fffff097          	auipc	ra,0xfffff
    802014b8:	0b4080e7          	jalr	180(ra) # 80200568 <printf>
    802014bc:	fffff097          	auipc	ra,0xfffff
    802014c0:	76c080e7          	jalr	1900(ra) # 80200c28 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    802014c4:	02f00593          	li	a1,47
    802014c8:	02000513          	li	a0,32
    802014cc:	00000097          	auipc	ra,0x0
    802014d0:	928080e7          	jalr	-1752(ra) # 80200df4 <set_color>
    802014d4:	00003517          	auipc	a0,0x3
    802014d8:	5dc50513          	addi	a0,a0,1500 # 80204ab0 <small_numbers+0x8e8>
    802014dc:	fffff097          	auipc	ra,0xfffff
    802014e0:	08c080e7          	jalr	140(ra) # 80200568 <printf>
    802014e4:	fffff097          	auipc	ra,0xfffff
    802014e8:	744080e7          	jalr	1860(ra) # 80200c28 <reset_color>
    printf("\n\n");
    802014ec:	00003517          	auipc	a0,0x3
    802014f0:	51c50513          	addi	a0,a0,1308 # 80204a08 <small_numbers+0x840>
    802014f4:	fffff097          	auipc	ra,0xfffff
    802014f8:	074080e7          	jalr	116(ra) # 80200568 <printf>
	reset_color();
    802014fc:	fffff097          	auipc	ra,0xfffff
    80201500:	72c080e7          	jalr	1836(ra) # 80200c28 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201504:	00003517          	auipc	a0,0x3
    80201508:	5bc50513          	addi	a0,a0,1468 # 80204ac0 <small_numbers+0x8f8>
    8020150c:	fffff097          	auipc	ra,0xfffff
    80201510:	05c080e7          	jalr	92(ra) # 80200568 <printf>
	cursor_up(1); // 光标上移一行
    80201514:	4505                	li	a0,1
    80201516:	fffff097          	auipc	ra,0xfffff
    8020151a:	47c080e7          	jalr	1148(ra) # 80200992 <cursor_up>
	clear_line();
    8020151e:	00000097          	auipc	ra,0x0
    80201522:	912080e7          	jalr	-1774(ra) # 80200e30 <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201526:	00003517          	auipc	a0,0x3
    8020152a:	5d250513          	addi	a0,a0,1490 # 80204af8 <small_numbers+0x930>
    8020152e:	fffff097          	auipc	ra,0xfffff
    80201532:	03a080e7          	jalr	58(ra) # 80200568 <printf>
    80201536:	0001                	nop
    80201538:	60a2                	ld	ra,8(sp)
    8020153a:	6402                	ld	s0,0(sp)
    8020153c:	0141                	addi	sp,sp,16
    8020153e:	8082                	ret

0000000080201540 <memset>:
#include "mem.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201540:	7139                	addi	sp,sp,-64
    80201542:	fc22                	sd	s0,56(sp)
    80201544:	0080                	addi	s0,sp,64
    80201546:	fca43c23          	sd	a0,-40(s0)
    8020154a:	87ae                	mv	a5,a1
    8020154c:	fcc43423          	sd	a2,-56(s0)
    80201550:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201554:	fd843783          	ld	a5,-40(s0)
    80201558:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    8020155c:	a829                	j	80201576 <memset+0x36>
        *p++ = (unsigned char)c;
    8020155e:	fe843783          	ld	a5,-24(s0)
    80201562:	00178713          	addi	a4,a5,1
    80201566:	fee43423          	sd	a4,-24(s0)
    8020156a:	fd442703          	lw	a4,-44(s0)
    8020156e:	0ff77713          	zext.b	a4,a4
    80201572:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    80201576:	fc843783          	ld	a5,-56(s0)
    8020157a:	fff78713          	addi	a4,a5,-1
    8020157e:	fce43423          	sd	a4,-56(s0)
    80201582:	fff1                	bnez	a5,8020155e <memset+0x1e>
    return dst;
    80201584:	fd843783          	ld	a5,-40(s0)
    80201588:	853e                	mv	a0,a5
    8020158a:	7462                	ld	s0,56(sp)
    8020158c:	6121                	addi	sp,sp,64
    8020158e:	8082                	ret

0000000080201590 <assert>:
#include "vm.h"
#include "memlayout.h"
#include "pm.h"
    80201590:	1101                	addi	sp,sp,-32
    80201592:	ec06                	sd	ra,24(sp)
    80201594:	e822                	sd	s0,16(sp)
    80201596:	1000                	addi	s0,sp,32
    80201598:	87aa                	mv	a5,a0
    8020159a:	fef42623          	sw	a5,-20(s0)
#include "printf.h"
    8020159e:	fec42783          	lw	a5,-20(s0)
    802015a2:	2781                	sext.w	a5,a5
    802015a4:	e795                	bnez	a5,802015d0 <assert+0x40>
#include "mem.h"
    802015a6:	4615                	li	a2,5
    802015a8:	00003597          	auipc	a1,0x3
    802015ac:	57058593          	addi	a1,a1,1392 # 80204b18 <small_numbers+0x950>
    802015b0:	00003517          	auipc	a0,0x3
    802015b4:	57850513          	addi	a0,a0,1400 # 80204b28 <small_numbers+0x960>
    802015b8:	fffff097          	auipc	ra,0xfffff
    802015bc:	fb0080e7          	jalr	-80(ra) # 80200568 <printf>
#include "assert.h"
    802015c0:	00003517          	auipc	a0,0x3
    802015c4:	59050513          	addi	a0,a0,1424 # 80204b50 <small_numbers+0x988>
    802015c8:	00000097          	auipc	ra,0x0
    802015cc:	8a8080e7          	jalr	-1880(ra) # 80200e70 <panic>

#define PTE_FLAGS 0x3FF
    802015d0:	0001                	nop
    802015d2:	60e2                	ld	ra,24(sp)
    802015d4:	6442                	ld	s0,16(sp)
    802015d6:	6105                	addi	sp,sp,32
    802015d8:	8082                	ret

00000000802015da <px>:


// 内核页表全局变量
pagetable_t kernel_pagetable = 0;

static inline uint64 px(int level, uint64 va) {
    802015da:	1101                	addi	sp,sp,-32
    802015dc:	ec22                	sd	s0,24(sp)
    802015de:	1000                	addi	s0,sp,32
    802015e0:	87aa                	mv	a5,a0
    802015e2:	feb43023          	sd	a1,-32(s0)
    802015e6:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    802015ea:	fec42783          	lw	a5,-20(s0)
    802015ee:	873e                	mv	a4,a5
    802015f0:	87ba                	mv	a5,a4
    802015f2:	0037979b          	slliw	a5,a5,0x3
    802015f6:	9fb9                	addw	a5,a5,a4
    802015f8:	2781                	sext.w	a5,a5
    802015fa:	27b1                	addiw	a5,a5,12
    802015fc:	2781                	sext.w	a5,a5
    802015fe:	873e                	mv	a4,a5
    80201600:	fe043783          	ld	a5,-32(s0)
    80201604:	00e7d7b3          	srl	a5,a5,a4
    80201608:	1ff7f793          	andi	a5,a5,511
}
    8020160c:	853e                	mv	a0,a5
    8020160e:	6462                	ld	s0,24(sp)
    80201610:	6105                	addi	sp,sp,32
    80201612:	8082                	ret

0000000080201614 <create_pagetable>:

// 创建空页表
pagetable_t create_pagetable(void) {
    80201614:	1101                	addi	sp,sp,-32
    80201616:	ec06                	sd	ra,24(sp)
    80201618:	e822                	sd	s0,16(sp)
    8020161a:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    8020161c:	00001097          	auipc	ra,0x1
    80201620:	c12080e7          	jalr	-1006(ra) # 8020222e <alloc_page>
    80201624:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    80201628:	fe843783          	ld	a5,-24(s0)
    8020162c:	e399                	bnez	a5,80201632 <create_pagetable+0x1e>
        return 0;
    8020162e:	4781                	li	a5,0
    80201630:	a819                	j	80201646 <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    80201632:	6605                	lui	a2,0x1
    80201634:	4581                	li	a1,0
    80201636:	fe843503          	ld	a0,-24(s0)
    8020163a:	00000097          	auipc	ra,0x0
    8020163e:	f06080e7          	jalr	-250(ra) # 80201540 <memset>
    return pt;
    80201642:	fe843783          	ld	a5,-24(s0)
}
    80201646:	853e                	mv	a0,a5
    80201648:	60e2                	ld	ra,24(sp)
    8020164a:	6442                	ld	s0,16(sp)
    8020164c:	6105                	addi	sp,sp,32
    8020164e:	8082                	ret

0000000080201650 <walk_lookup>:
// 辅助函数：仅查找
static pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    80201650:	7179                	addi	sp,sp,-48
    80201652:	f406                	sd	ra,40(sp)
    80201654:	f022                	sd	s0,32(sp)
    80201656:	1800                	addi	s0,sp,48
    80201658:	fca43c23          	sd	a0,-40(s0)
    8020165c:	fcb43823          	sd	a1,-48(s0)
    if (va >= MAXVA)
    80201660:	fd043703          	ld	a4,-48(s0)
    80201664:	57fd                	li	a5,-1
    80201666:	83e5                	srli	a5,a5,0x19
    80201668:	00e7fa63          	bgeu	a5,a4,8020167c <walk_lookup+0x2c>
        panic("walk_lookup: va out of range");
    8020166c:	00003517          	auipc	a0,0x3
    80201670:	4ec50513          	addi	a0,a0,1260 # 80204b58 <small_numbers+0x990>
    80201674:	fffff097          	auipc	ra,0xfffff
    80201678:	7fc080e7          	jalr	2044(ra) # 80200e70 <panic>
    for (int level = 2; level > 0; level--) {
    8020167c:	4789                	li	a5,2
    8020167e:	fef42623          	sw	a5,-20(s0)
    80201682:	a0a9                	j	802016cc <walk_lookup+0x7c>
        pte_t *pte = &pt[px(level, va)];
    80201684:	fec42783          	lw	a5,-20(s0)
    80201688:	fd043583          	ld	a1,-48(s0)
    8020168c:	853e                	mv	a0,a5
    8020168e:	00000097          	auipc	ra,0x0
    80201692:	f4c080e7          	jalr	-180(ra) # 802015da <px>
    80201696:	87aa                	mv	a5,a0
    80201698:	078e                	slli	a5,a5,0x3
    8020169a:	fd843703          	ld	a4,-40(s0)
    8020169e:	97ba                	add	a5,a5,a4
    802016a0:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    802016a4:	fe043783          	ld	a5,-32(s0)
    802016a8:	639c                	ld	a5,0(a5)
    802016aa:	8b85                	andi	a5,a5,1
    802016ac:	cb89                	beqz	a5,802016be <walk_lookup+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    802016ae:	fe043783          	ld	a5,-32(s0)
    802016b2:	639c                	ld	a5,0(a5)
    802016b4:	83a9                	srli	a5,a5,0xa
    802016b6:	07b2                	slli	a5,a5,0xc
    802016b8:	fcf43c23          	sd	a5,-40(s0)
    802016bc:	a019                	j	802016c2 <walk_lookup+0x72>
        } else {
            return 0;
    802016be:	4781                	li	a5,0
    802016c0:	a03d                	j	802016ee <walk_lookup+0x9e>
    for (int level = 2; level > 0; level--) {
    802016c2:	fec42783          	lw	a5,-20(s0)
    802016c6:	37fd                	addiw	a5,a5,-1
    802016c8:	fef42623          	sw	a5,-20(s0)
    802016cc:	fec42783          	lw	a5,-20(s0)
    802016d0:	2781                	sext.w	a5,a5
    802016d2:	faf049e3          	bgtz	a5,80201684 <walk_lookup+0x34>
        }
    }
    return &pt[px(0, va)];
    802016d6:	fd043583          	ld	a1,-48(s0)
    802016da:	4501                	li	a0,0
    802016dc:	00000097          	auipc	ra,0x0
    802016e0:	efe080e7          	jalr	-258(ra) # 802015da <px>
    802016e4:	87aa                	mv	a5,a0
    802016e6:	078e                	slli	a5,a5,0x3
    802016e8:	fd843703          	ld	a4,-40(s0)
    802016ec:	97ba                	add	a5,a5,a4
}
    802016ee:	853e                	mv	a0,a5
    802016f0:	70a2                	ld	ra,40(sp)
    802016f2:	7402                	ld	s0,32(sp)
    802016f4:	6145                	addi	sp,sp,48
    802016f6:	8082                	ret

00000000802016f8 <walk_create>:

// 辅助函数：查找或分配
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    802016f8:	7139                	addi	sp,sp,-64
    802016fa:	fc06                	sd	ra,56(sp)
    802016fc:	f822                	sd	s0,48(sp)
    802016fe:	0080                	addi	s0,sp,64
    80201700:	fca43423          	sd	a0,-56(s0)
    80201704:	fcb43023          	sd	a1,-64(s0)
    if (va >= MAXVA)
    80201708:	fc043703          	ld	a4,-64(s0)
    8020170c:	57fd                	li	a5,-1
    8020170e:	83e5                	srli	a5,a5,0x19
    80201710:	00e7fa63          	bgeu	a5,a4,80201724 <walk_create+0x2c>
        panic("walk_create: va out of range");
    80201714:	00003517          	auipc	a0,0x3
    80201718:	46450513          	addi	a0,a0,1124 # 80204b78 <small_numbers+0x9b0>
    8020171c:	fffff097          	auipc	ra,0xfffff
    80201720:	754080e7          	jalr	1876(ra) # 80200e70 <panic>
    for (int level = 2; level > 0; level--) {
    80201724:	4789                	li	a5,2
    80201726:	fef42623          	sw	a5,-20(s0)
    8020172a:	a059                	j	802017b0 <walk_create+0xb8>
        pte_t *pte = &pt[px(level, va)];
    8020172c:	fec42783          	lw	a5,-20(s0)
    80201730:	fc043583          	ld	a1,-64(s0)
    80201734:	853e                	mv	a0,a5
    80201736:	00000097          	auipc	ra,0x0
    8020173a:	ea4080e7          	jalr	-348(ra) # 802015da <px>
    8020173e:	87aa                	mv	a5,a0
    80201740:	078e                	slli	a5,a5,0x3
    80201742:	fc843703          	ld	a4,-56(s0)
    80201746:	97ba                	add	a5,a5,a4
    80201748:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    8020174c:	fe043783          	ld	a5,-32(s0)
    80201750:	639c                	ld	a5,0(a5)
    80201752:	8b85                	andi	a5,a5,1
    80201754:	cb89                	beqz	a5,80201766 <walk_create+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    80201756:	fe043783          	ld	a5,-32(s0)
    8020175a:	639c                	ld	a5,0(a5)
    8020175c:	83a9                	srli	a5,a5,0xa
    8020175e:	07b2                	slli	a5,a5,0xc
    80201760:	fcf43423          	sd	a5,-56(s0)
    80201764:	a089                	j	802017a6 <walk_create+0xae>
        } else {
            pagetable_t new_pt = (pagetable_t)alloc_page();
    80201766:	00001097          	auipc	ra,0x1
    8020176a:	ac8080e7          	jalr	-1336(ra) # 8020222e <alloc_page>
    8020176e:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    80201772:	fd843783          	ld	a5,-40(s0)
    80201776:	e399                	bnez	a5,8020177c <walk_create+0x84>
                return 0;
    80201778:	4781                	li	a5,0
    8020177a:	a8a1                	j	802017d2 <walk_create+0xda>
            memset(new_pt, 0, PGSIZE);
    8020177c:	6605                	lui	a2,0x1
    8020177e:	4581                	li	a1,0
    80201780:	fd843503          	ld	a0,-40(s0)
    80201784:	00000097          	auipc	ra,0x0
    80201788:	dbc080e7          	jalr	-580(ra) # 80201540 <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    8020178c:	fd843783          	ld	a5,-40(s0)
    80201790:	83b1                	srli	a5,a5,0xc
    80201792:	07aa                	slli	a5,a5,0xa
    80201794:	0017e713          	ori	a4,a5,1
    80201798:	fe043783          	ld	a5,-32(s0)
    8020179c:	e398                	sd	a4,0(a5)
            pt = new_pt;
    8020179e:	fd843783          	ld	a5,-40(s0)
    802017a2:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    802017a6:	fec42783          	lw	a5,-20(s0)
    802017aa:	37fd                	addiw	a5,a5,-1
    802017ac:	fef42623          	sw	a5,-20(s0)
    802017b0:	fec42783          	lw	a5,-20(s0)
    802017b4:	2781                	sext.w	a5,a5
    802017b6:	f6f04be3          	bgtz	a5,8020172c <walk_create+0x34>
        }
    }
    return &pt[px(0, va)];
    802017ba:	fc043583          	ld	a1,-64(s0)
    802017be:	4501                	li	a0,0
    802017c0:	00000097          	auipc	ra,0x0
    802017c4:	e1a080e7          	jalr	-486(ra) # 802015da <px>
    802017c8:	87aa                	mv	a5,a0
    802017ca:	078e                	slli	a5,a5,0x3
    802017cc:	fc843703          	ld	a4,-56(s0)
    802017d0:	97ba                	add	a5,a5,a4
}
    802017d2:	853e                	mv	a0,a5
    802017d4:	70e2                	ld	ra,56(sp)
    802017d6:	7442                	ld	s0,48(sp)
    802017d8:	6121                	addi	sp,sp,64
    802017da:	8082                	ret

00000000802017dc <map_page>:

// 建立映射，允许重映射到相同物理地址
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    802017dc:	7139                	addi	sp,sp,-64
    802017de:	fc06                	sd	ra,56(sp)
    802017e0:	f822                	sd	s0,48(sp)
    802017e2:	0080                	addi	s0,sp,64
    802017e4:	fca43c23          	sd	a0,-40(s0)
    802017e8:	fcb43823          	sd	a1,-48(s0)
    802017ec:	fcc43423          	sd	a2,-56(s0)
    802017f0:	87b6                	mv	a5,a3
    802017f2:	fcf42223          	sw	a5,-60(s0)
    if ((va % PGSIZE) != 0)
    802017f6:	fd043703          	ld	a4,-48(s0)
    802017fa:	6785                	lui	a5,0x1
    802017fc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802017fe:	8ff9                	and	a5,a5,a4
    80201800:	cb89                	beqz	a5,80201812 <map_page+0x36>
        panic("map_page: va not aligned");
    80201802:	00003517          	auipc	a0,0x3
    80201806:	39650513          	addi	a0,a0,918 # 80204b98 <small_numbers+0x9d0>
    8020180a:	fffff097          	auipc	ra,0xfffff
    8020180e:	666080e7          	jalr	1638(ra) # 80200e70 <panic>
    pte_t *pte = walk_create(pt, va);
    80201812:	fd043583          	ld	a1,-48(s0)
    80201816:	fd843503          	ld	a0,-40(s0)
    8020181a:	00000097          	auipc	ra,0x0
    8020181e:	ede080e7          	jalr	-290(ra) # 802016f8 <walk_create>
    80201822:	fea43423          	sd	a0,-24(s0)
    if (!pte)
    80201826:	fe843783          	ld	a5,-24(s0)
    8020182a:	e399                	bnez	a5,80201830 <map_page+0x54>
        return -1;
    8020182c:	57fd                	li	a5,-1
    8020182e:	a069                	j	802018b8 <map_page+0xdc>
    
    // 检查是否已经映射
	if (*pte & PTE_V) {
    80201830:	fe843783          	ld	a5,-24(s0)
    80201834:	639c                	ld	a5,0(a5)
    80201836:	8b85                	andi	a5,a5,1
    80201838:	c3b5                	beqz	a5,8020189c <map_page+0xc0>
		if (PTE2PA(*pte) == pa) {
    8020183a:	fe843783          	ld	a5,-24(s0)
    8020183e:	639c                	ld	a5,0(a5)
    80201840:	83a9                	srli	a5,a5,0xa
    80201842:	07b2                	slli	a5,a5,0xc
    80201844:	fc843703          	ld	a4,-56(s0)
    80201848:	04f71263          	bne	a4,a5,8020188c <map_page+0xb0>
			// 只允许提升权限，不允许降低权限
			int new_perm = ((*pte & PTE_FLAGS) | perm) & PTE_FLAGS;
    8020184c:	fe843783          	ld	a5,-24(s0)
    80201850:	639c                	ld	a5,0(a5)
    80201852:	2781                	sext.w	a5,a5
    80201854:	3ff7f793          	andi	a5,a5,1023
    80201858:	0007871b          	sext.w	a4,a5
    8020185c:	fc442783          	lw	a5,-60(s0)
    80201860:	8fd9                	or	a5,a5,a4
    80201862:	2781                	sext.w	a5,a5
    80201864:	2781                	sext.w	a5,a5
    80201866:	3ff7f793          	andi	a5,a5,1023
    8020186a:	fef42223          	sw	a5,-28(s0)
			*pte = PA2PTE(pa) | new_perm | PTE_V;
    8020186e:	fc843783          	ld	a5,-56(s0)
    80201872:	83b1                	srli	a5,a5,0xc
    80201874:	00a79713          	slli	a4,a5,0xa
    80201878:	fe442783          	lw	a5,-28(s0)
    8020187c:	8fd9                	or	a5,a5,a4
    8020187e:	0017e713          	ori	a4,a5,1
    80201882:	fe843783          	ld	a5,-24(s0)
    80201886:	e398                	sd	a4,0(a5)
			return 0;
    80201888:	4781                	li	a5,0
    8020188a:	a03d                	j	802018b8 <map_page+0xdc>
		} else {
			panic("map_page: remap to different physical address");
    8020188c:	00003517          	auipc	a0,0x3
    80201890:	32c50513          	addi	a0,a0,812 # 80204bb8 <small_numbers+0x9f0>
    80201894:	fffff097          	auipc	ra,0xfffff
    80201898:	5dc080e7          	jalr	1500(ra) # 80200e70 <panic>
		}
	}
    
    *pte = PA2PTE(pa) | perm | PTE_V;
    8020189c:	fc843783          	ld	a5,-56(s0)
    802018a0:	83b1                	srli	a5,a5,0xc
    802018a2:	00a79713          	slli	a4,a5,0xa
    802018a6:	fc442783          	lw	a5,-60(s0)
    802018aa:	8fd9                	or	a5,a5,a4
    802018ac:	0017e713          	ori	a4,a5,1
    802018b0:	fe843783          	ld	a5,-24(s0)
    802018b4:	e398                	sd	a4,0(a5)
    return 0;
    802018b6:	4781                	li	a5,0
}
    802018b8:	853e                	mv	a0,a5
    802018ba:	70e2                	ld	ra,56(sp)
    802018bc:	7442                	ld	s0,48(sp)
    802018be:	6121                	addi	sp,sp,64
    802018c0:	8082                	ret

00000000802018c2 <free_pagetable>:
// 递归释放页表
void free_pagetable(pagetable_t pt) {
    802018c2:	7139                	addi	sp,sp,-64
    802018c4:	fc06                	sd	ra,56(sp)
    802018c6:	f822                	sd	s0,48(sp)
    802018c8:	0080                	addi	s0,sp,64
    802018ca:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    802018ce:	fe042623          	sw	zero,-20(s0)
    802018d2:	a8a5                	j	8020194a <free_pagetable+0x88>
        pte_t pte = pt[i];
    802018d4:	fec42783          	lw	a5,-20(s0)
    802018d8:	078e                	slli	a5,a5,0x3
    802018da:	fc843703          	ld	a4,-56(s0)
    802018de:	97ba                	add	a5,a5,a4
    802018e0:	639c                	ld	a5,0(a5)
    802018e2:	fef43023          	sd	a5,-32(s0)
        // 只释放中间页表
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    802018e6:	fe043783          	ld	a5,-32(s0)
    802018ea:	8b85                	andi	a5,a5,1
    802018ec:	cb95                	beqz	a5,80201920 <free_pagetable+0x5e>
    802018ee:	fe043783          	ld	a5,-32(s0)
    802018f2:	8bb9                	andi	a5,a5,14
    802018f4:	e795                	bnez	a5,80201920 <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    802018f6:	fe043783          	ld	a5,-32(s0)
    802018fa:	83a9                	srli	a5,a5,0xa
    802018fc:	07b2                	slli	a5,a5,0xc
    802018fe:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    80201902:	fd843503          	ld	a0,-40(s0)
    80201906:	00000097          	auipc	ra,0x0
    8020190a:	fbc080e7          	jalr	-68(ra) # 802018c2 <free_pagetable>
            pt[i] = 0;
    8020190e:	fec42783          	lw	a5,-20(s0)
    80201912:	078e                	slli	a5,a5,0x3
    80201914:	fc843703          	ld	a4,-56(s0)
    80201918:	97ba                	add	a5,a5,a4
    8020191a:	0007b023          	sd	zero,0(a5)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    8020191e:	a00d                	j	80201940 <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    80201920:	fe043783          	ld	a5,-32(s0)
    80201924:	8b85                	andi	a5,a5,1
    80201926:	cf89                	beqz	a5,80201940 <free_pagetable+0x7e>
    80201928:	fe043783          	ld	a5,-32(s0)
    8020192c:	8bb9                	andi	a5,a5,14
    8020192e:	cb89                	beqz	a5,80201940 <free_pagetable+0x7e>
            pt[i] = 0;
    80201930:	fec42783          	lw	a5,-20(s0)
    80201934:	078e                	slli	a5,a5,0x3
    80201936:	fc843703          	ld	a4,-56(s0)
    8020193a:	97ba                	add	a5,a5,a4
    8020193c:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    80201940:	fec42783          	lw	a5,-20(s0)
    80201944:	2785                	addiw	a5,a5,1
    80201946:	fef42623          	sw	a5,-20(s0)
    8020194a:	fec42783          	lw	a5,-20(s0)
    8020194e:	0007871b          	sext.w	a4,a5
    80201952:	1ff00793          	li	a5,511
    80201956:	f6e7dfe3          	bge	a5,a4,802018d4 <free_pagetable+0x12>
        }
    }
    free_page(pt);
    8020195a:	fc843503          	ld	a0,-56(s0)
    8020195e:	00001097          	auipc	ra,0x1
    80201962:	93c080e7          	jalr	-1732(ra) # 8020229a <free_page>
}
    80201966:	0001                	nop
    80201968:	70e2                	ld	ra,56(sp)
    8020196a:	7442                	ld	s0,48(sp)
    8020196c:	6121                	addi	sp,sp,64
    8020196e:	8082                	ret

0000000080201970 <kvmmake>:

// 内核页表构建（仅映射内核代码和数据，实际可根据需要扩展）
static pagetable_t kvmmake(void) {
    80201970:	711d                	addi	sp,sp,-96
    80201972:	ec86                	sd	ra,88(sp)
    80201974:	e8a2                	sd	s0,80(sp)
    80201976:	1080                	addi	s0,sp,96
    pagetable_t kpgtbl = create_pagetable();
    80201978:	00000097          	auipc	ra,0x0
    8020197c:	c9c080e7          	jalr	-868(ra) # 80201614 <create_pagetable>
    80201980:	faa43c23          	sd	a0,-72(s0)
    if (!kpgtbl)
    80201984:	fb843783          	ld	a5,-72(s0)
    80201988:	eb89                	bnez	a5,8020199a <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    8020198a:	00003517          	auipc	a0,0x3
    8020198e:	25e50513          	addi	a0,a0,606 # 80204be8 <small_numbers+0xa20>
    80201992:	fffff097          	auipc	ra,0xfffff
    80201996:	4de080e7          	jalr	1246(ra) # 80200e70 <panic>
    // 1. 映射内核代码和数据区域（只读+执行 / 读写）
    extern char etext[];  // 在kernel.ld中定义，内核代码段结束位置
    extern char end[];    // 在kernel.ld中定义，内核数据段结束位置
    
    // 内核代码段 - 只读可执行
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    8020199a:	4785                	li	a5,1
    8020199c:	07fe                	slli	a5,a5,0x1f
    8020199e:	fef43423          	sd	a5,-24(s0)
    802019a2:	a825                	j	802019da <kvmmake+0x6a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_X) != 0)
    802019a4:	46a9                	li	a3,10
    802019a6:	fe843603          	ld	a2,-24(s0)
    802019aa:	fe843583          	ld	a1,-24(s0)
    802019ae:	fb843503          	ld	a0,-72(s0)
    802019b2:	00000097          	auipc	ra,0x0
    802019b6:	e2a080e7          	jalr	-470(ra) # 802017dc <map_page>
    802019ba:	87aa                	mv	a5,a0
    802019bc:	cb89                	beqz	a5,802019ce <kvmmake+0x5e>
            panic("kvmmake: code map failed");
    802019be:	00003517          	auipc	a0,0x3
    802019c2:	24250513          	addi	a0,a0,578 # 80204c00 <small_numbers+0xa38>
    802019c6:	fffff097          	auipc	ra,0xfffff
    802019ca:	4aa080e7          	jalr	1194(ra) # 80200e70 <panic>
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    802019ce:	fe843703          	ld	a4,-24(s0)
    802019d2:	6785                	lui	a5,0x1
    802019d4:	97ba                	add	a5,a5,a4
    802019d6:	fef43423          	sd	a5,-24(s0)
    802019da:	00002797          	auipc	a5,0x2
    802019de:	62678793          	addi	a5,a5,1574 # 80204000 <etext>
    802019e2:	fe843703          	ld	a4,-24(s0)
    802019e6:	faf76fe3          	bltu	a4,a5,802019a4 <kvmmake+0x34>
    }
    
    // 内核数据段 - 可读写
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    802019ea:	00002797          	auipc	a5,0x2
    802019ee:	61678793          	addi	a5,a5,1558 # 80204000 <etext>
    802019f2:	fef43023          	sd	a5,-32(s0)
    802019f6:	a825                	j	80201a2e <kvmmake+0xbe>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802019f8:	4699                	li	a3,6
    802019fa:	fe043603          	ld	a2,-32(s0)
    802019fe:	fe043583          	ld	a1,-32(s0)
    80201a02:	fb843503          	ld	a0,-72(s0)
    80201a06:	00000097          	auipc	ra,0x0
    80201a0a:	dd6080e7          	jalr	-554(ra) # 802017dc <map_page>
    80201a0e:	87aa                	mv	a5,a0
    80201a10:	cb89                	beqz	a5,80201a22 <kvmmake+0xb2>
            panic("kvmmake: data map failed");
    80201a12:	00003517          	auipc	a0,0x3
    80201a16:	20e50513          	addi	a0,a0,526 # 80204c20 <small_numbers+0xa58>
    80201a1a:	fffff097          	auipc	ra,0xfffff
    80201a1e:	456080e7          	jalr	1110(ra) # 80200e70 <panic>
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    80201a22:	fe043703          	ld	a4,-32(s0)
    80201a26:	6785                	lui	a5,0x1
    80201a28:	97ba                	add	a5,a5,a4
    80201a2a:	fef43023          	sd	a5,-32(s0)
    80201a2e:	00006797          	auipc	a5,0x6
    80201a32:	89278793          	addi	a5,a5,-1902 # 802072c0 <_bss_end>
    80201a36:	fe043703          	ld	a4,-32(s0)
    80201a3a:	faf76fe3          	bltu	a4,a5,802019f8 <kvmmake+0x88>
    }
    
	// 2. 映射内核堆区域 - 可读写
	uint64 aligned_end = ((uint64)end + PGSIZE - 1) & ~(PGSIZE - 1); // 向上对齐到页边界
    80201a3e:	00006717          	auipc	a4,0x6
    80201a42:	88270713          	addi	a4,a4,-1918 # 802072c0 <_bss_end>
    80201a46:	6785                	lui	a5,0x1
    80201a48:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80201a4a:	973e                	add	a4,a4,a5
    80201a4c:	77fd                	lui	a5,0xfffff
    80201a4e:	8ff9                	and	a5,a5,a4
    80201a50:	faf43823          	sd	a5,-80(s0)
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    80201a54:	fb043783          	ld	a5,-80(s0)
    80201a58:	fcf43c23          	sd	a5,-40(s0)
    80201a5c:	a825                	j	80201a94 <kvmmake+0x124>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201a5e:	4699                	li	a3,6
    80201a60:	fd843603          	ld	a2,-40(s0)
    80201a64:	fd843583          	ld	a1,-40(s0)
    80201a68:	fb843503          	ld	a0,-72(s0)
    80201a6c:	00000097          	auipc	ra,0x0
    80201a70:	d70080e7          	jalr	-656(ra) # 802017dc <map_page>
    80201a74:	87aa                	mv	a5,a0
    80201a76:	cb89                	beqz	a5,80201a88 <kvmmake+0x118>
			panic("kvmmake: heap map failed");
    80201a78:	00003517          	auipc	a0,0x3
    80201a7c:	1c850513          	addi	a0,a0,456 # 80204c40 <small_numbers+0xa78>
    80201a80:	fffff097          	auipc	ra,0xfffff
    80201a84:	3f0080e7          	jalr	1008(ra) # 80200e70 <panic>
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    80201a88:	fd843703          	ld	a4,-40(s0)
    80201a8c:	6785                	lui	a5,0x1
    80201a8e:	97ba                	add	a5,a5,a4
    80201a90:	fcf43c23          	sd	a5,-40(s0)
    80201a94:	fd843703          	ld	a4,-40(s0)
    80201a98:	47c5                	li	a5,17
    80201a9a:	07ee                	slli	a5,a5,0x1b
    80201a9c:	fcf761e3          	bltu	a4,a5,80201a5e <kvmmake+0xee>
	}
    
    // 3. 映射设备区域 - 只读写，不可执行
    // UART 串口设备
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    80201aa0:	4699                	li	a3,6
    80201aa2:	10000637          	lui	a2,0x10000
    80201aa6:	100005b7          	lui	a1,0x10000
    80201aaa:	fb843503          	ld	a0,-72(s0)
    80201aae:	00000097          	auipc	ra,0x0
    80201ab2:	d2e080e7          	jalr	-722(ra) # 802017dc <map_page>
    80201ab6:	87aa                	mv	a5,a0
    80201ab8:	cb89                	beqz	a5,80201aca <kvmmake+0x15a>
        panic("kvmmake: uart map failed");
    80201aba:	00003517          	auipc	a0,0x3
    80201abe:	1a650513          	addi	a0,a0,422 # 80204c60 <small_numbers+0xa98>
    80201ac2:	fffff097          	auipc	ra,0xfffff
    80201ac6:	3ae080e7          	jalr	942(ra) # 80200e70 <panic>
    
    // PLIC 中断控制器
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80201aca:	0c0007b7          	lui	a5,0xc000
    80201ace:	fcf43823          	sd	a5,-48(s0)
    80201ad2:	a825                	j	80201b0a <kvmmake+0x19a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201ad4:	4699                	li	a3,6
    80201ad6:	fd043603          	ld	a2,-48(s0)
    80201ada:	fd043583          	ld	a1,-48(s0)
    80201ade:	fb843503          	ld	a0,-72(s0)
    80201ae2:	00000097          	auipc	ra,0x0
    80201ae6:	cfa080e7          	jalr	-774(ra) # 802017dc <map_page>
    80201aea:	87aa                	mv	a5,a0
    80201aec:	cb89                	beqz	a5,80201afe <kvmmake+0x18e>
            panic("kvmmake: plic map failed");
    80201aee:	00003517          	auipc	a0,0x3
    80201af2:	19250513          	addi	a0,a0,402 # 80204c80 <small_numbers+0xab8>
    80201af6:	fffff097          	auipc	ra,0xfffff
    80201afa:	37a080e7          	jalr	890(ra) # 80200e70 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80201afe:	fd043703          	ld	a4,-48(s0)
    80201b02:	6785                	lui	a5,0x1
    80201b04:	97ba                	add	a5,a5,a4
    80201b06:	fcf43823          	sd	a5,-48(s0)
    80201b0a:	fd043703          	ld	a4,-48(s0)
    80201b0e:	0c4007b7          	lui	a5,0xc400
    80201b12:	fcf761e3          	bltu	a4,a5,80201ad4 <kvmmake+0x164>
    }
    
    // CLINT 本地中断控制器 - 完善映射
    // 确保整个 CLINT 区域被映射，特别是 mtimecmp 和 mtime 寄存器
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80201b16:	020007b7          	lui	a5,0x2000
    80201b1a:	fcf43423          	sd	a5,-56(s0)
    80201b1e:	a825                	j	80201b56 <kvmmake+0x1e6>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201b20:	4699                	li	a3,6
    80201b22:	fc843603          	ld	a2,-56(s0)
    80201b26:	fc843583          	ld	a1,-56(s0)
    80201b2a:	fb843503          	ld	a0,-72(s0)
    80201b2e:	00000097          	auipc	ra,0x0
    80201b32:	cae080e7          	jalr	-850(ra) # 802017dc <map_page>
    80201b36:	87aa                	mv	a5,a0
    80201b38:	cb89                	beqz	a5,80201b4a <kvmmake+0x1da>
            panic("kvmmake: clint map failed");
    80201b3a:	00003517          	auipc	a0,0x3
    80201b3e:	16650513          	addi	a0,a0,358 # 80204ca0 <small_numbers+0xad8>
    80201b42:	fffff097          	auipc	ra,0xfffff
    80201b46:	32e080e7          	jalr	814(ra) # 80200e70 <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80201b4a:	fc843703          	ld	a4,-56(s0)
    80201b4e:	6785                	lui	a5,0x1
    80201b50:	97ba                	add	a5,a5,a4
    80201b52:	fcf43423          	sd	a5,-56(s0)
    80201b56:	fc843703          	ld	a4,-56(s0)
    80201b5a:	020107b7          	lui	a5,0x2010
    80201b5e:	fcf761e3          	bltu	a4,a5,80201b20 <kvmmake+0x1b0>
	}
    
    // VIRTIO 设备
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    80201b62:	4699                	li	a3,6
    80201b64:	10001637          	lui	a2,0x10001
    80201b68:	100015b7          	lui	a1,0x10001
    80201b6c:	fb843503          	ld	a0,-72(s0)
    80201b70:	00000097          	auipc	ra,0x0
    80201b74:	c6c080e7          	jalr	-916(ra) # 802017dc <map_page>
    80201b78:	87aa                	mv	a5,a0
    80201b7a:	cb89                	beqz	a5,80201b8c <kvmmake+0x21c>
        panic("kvmmake: virtio map failed");
    80201b7c:	00003517          	auipc	a0,0x3
    80201b80:	14450513          	addi	a0,a0,324 # 80204cc0 <small_numbers+0xaf8>
    80201b84:	fffff097          	auipc	ra,0xfffff
    80201b88:	2ec080e7          	jalr	748(ra) # 80200e70 <panic>
    
    // 4. 扩大SBI调用区域映射
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    80201b8c:	fc043023          	sd	zero,-64(s0)
    80201b90:	a825                	j	80201bc8 <kvmmake+0x258>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201b92:	4699                	li	a3,6
    80201b94:	fc043603          	ld	a2,-64(s0)
    80201b98:	fc043583          	ld	a1,-64(s0)
    80201b9c:	fb843503          	ld	a0,-72(s0)
    80201ba0:	00000097          	auipc	ra,0x0
    80201ba4:	c3c080e7          	jalr	-964(ra) # 802017dc <map_page>
    80201ba8:	87aa                	mv	a5,a0
    80201baa:	cb89                	beqz	a5,80201bbc <kvmmake+0x24c>
			panic("kvmmake: low memory map failed");
    80201bac:	00003517          	auipc	a0,0x3
    80201bb0:	13450513          	addi	a0,a0,308 # 80204ce0 <small_numbers+0xb18>
    80201bb4:	fffff097          	auipc	ra,0xfffff
    80201bb8:	2bc080e7          	jalr	700(ra) # 80200e70 <panic>
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    80201bbc:	fc043703          	ld	a4,-64(s0)
    80201bc0:	6785                	lui	a5,0x1
    80201bc2:	97ba                	add	a5,a5,a4
    80201bc4:	fcf43023          	sd	a5,-64(s0)
    80201bc8:	fc043703          	ld	a4,-64(s0)
    80201bcc:	001007b7          	lui	a5,0x100
    80201bd0:	fcf761e3          	bltu	a4,a5,80201b92 <kvmmake+0x222>
	}

	// 特别映射包含0xfd02080的页
	uint64 sbi_special = 0xfd02000;  // 页对齐
    80201bd4:	0fd027b7          	lui	a5,0xfd02
    80201bd8:	faf43423          	sd	a5,-88(s0)
	if (map_page(kpgtbl, sbi_special, sbi_special, PTE_R | PTE_W) != 0)
    80201bdc:	4699                	li	a3,6
    80201bde:	fa843603          	ld	a2,-88(s0)
    80201be2:	fa843583          	ld	a1,-88(s0)
    80201be6:	fb843503          	ld	a0,-72(s0)
    80201bea:	00000097          	auipc	ra,0x0
    80201bee:	bf2080e7          	jalr	-1038(ra) # 802017dc <map_page>
    80201bf2:	87aa                	mv	a5,a0
    80201bf4:	cb89                	beqz	a5,80201c06 <kvmmake+0x296>
		panic("kvmmake: sbi special area map failed");
    80201bf6:	00003517          	auipc	a0,0x3
    80201bfa:	10a50513          	addi	a0,a0,266 # 80204d00 <small_numbers+0xb38>
    80201bfe:	fffff097          	auipc	ra,0xfffff
    80201c02:	272080e7          	jalr	626(ra) # 80200e70 <panic>
    
    return kpgtbl;
    80201c06:	fb843783          	ld	a5,-72(s0)
}
    80201c0a:	853e                	mv	a0,a5
    80201c0c:	60e6                	ld	ra,88(sp)
    80201c0e:	6446                	ld	s0,80(sp)
    80201c10:	6125                	addi	sp,sp,96
    80201c12:	8082                	ret

0000000080201c14 <kvminit>:
// 初始化内核页表
void kvminit(void) {
    80201c14:	1141                	addi	sp,sp,-16
    80201c16:	e406                	sd	ra,8(sp)
    80201c18:	e022                	sd	s0,0(sp)
    80201c1a:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    80201c1c:	00000097          	auipc	ra,0x0
    80201c20:	d54080e7          	jalr	-684(ra) # 80201970 <kvmmake>
    80201c24:	872a                	mv	a4,a0
    80201c26:	00005797          	auipc	a5,0x5
    80201c2a:	3fa78793          	addi	a5,a5,1018 # 80207020 <kernel_pagetable>
    80201c2e:	e398                	sd	a4,0(a5)
}
    80201c30:	0001                	nop
    80201c32:	60a2                	ld	ra,8(sp)
    80201c34:	6402                	ld	s0,0(sp)
    80201c36:	0141                	addi	sp,sp,16
    80201c38:	8082                	ret

0000000080201c3a <w_satp>:

// 启用分页（单核只需设置一次 satp 并刷新 TLB）
static inline void w_satp(uint64 x) {
    80201c3a:	1101                	addi	sp,sp,-32
    80201c3c:	ec22                	sd	s0,24(sp)
    80201c3e:	1000                	addi	s0,sp,32
    80201c40:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    80201c44:	fe843783          	ld	a5,-24(s0)
    80201c48:	18079073          	csrw	satp,a5
}
    80201c4c:	0001                	nop
    80201c4e:	6462                	ld	s0,24(sp)
    80201c50:	6105                	addi	sp,sp,32
    80201c52:	8082                	ret

0000000080201c54 <sfence_vma>:

inline void sfence_vma(void) {
    80201c54:	1141                	addi	sp,sp,-16
    80201c56:	e422                	sd	s0,8(sp)
    80201c58:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    80201c5a:	12000073          	sfence.vma
}
    80201c5e:	0001                	nop
    80201c60:	6422                	ld	s0,8(sp)
    80201c62:	0141                	addi	sp,sp,16
    80201c64:	8082                	ret

0000000080201c66 <kvminithart>:

void kvminithart(void) {
    80201c66:	1141                	addi	sp,sp,-16
    80201c68:	e406                	sd	ra,8(sp)
    80201c6a:	e022                	sd	s0,0(sp)
    80201c6c:	0800                	addi	s0,sp,16
    sfence_vma();
    80201c6e:	00000097          	auipc	ra,0x0
    80201c72:	fe6080e7          	jalr	-26(ra) # 80201c54 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    80201c76:	00005797          	auipc	a5,0x5
    80201c7a:	3aa78793          	addi	a5,a5,938 # 80207020 <kernel_pagetable>
    80201c7e:	639c                	ld	a5,0(a5)
    80201c80:	00c7d713          	srli	a4,a5,0xc
    80201c84:	57fd                	li	a5,-1
    80201c86:	17fe                	slli	a5,a5,0x3f
    80201c88:	8fd9                	or	a5,a5,a4
    80201c8a:	853e                	mv	a0,a5
    80201c8c:	00000097          	auipc	ra,0x0
    80201c90:	fae080e7          	jalr	-82(ra) # 80201c3a <w_satp>
    sfence_vma();
    80201c94:	00000097          	auipc	ra,0x0
    80201c98:	fc0080e7          	jalr	-64(ra) # 80201c54 <sfence_vma>
}
    80201c9c:	0001                	nop
    80201c9e:	60a2                	ld	ra,8(sp)
    80201ca0:	6402                	ld	s0,0(sp)
    80201ca2:	0141                	addi	sp,sp,16
    80201ca4:	8082                	ret

0000000080201ca6 <get_current_pagetable>:
// 获取当前页表
pagetable_t get_current_pagetable(void) {
    80201ca6:	1141                	addi	sp,sp,-16
    80201ca8:	e422                	sd	s0,8(sp)
    80201caa:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    80201cac:	00005797          	auipc	a5,0x5
    80201cb0:	37478793          	addi	a5,a5,884 # 80207020 <kernel_pagetable>
    80201cb4:	639c                	ld	a5,0(a5)
}
    80201cb6:	853e                	mv	a0,a5
    80201cb8:	6422                	ld	s0,8(sp)
    80201cba:	0141                	addi	sp,sp,16
    80201cbc:	8082                	ret

0000000080201cbe <handle_page_fault>:

// 处理页面故障（按需分配内存）
// type: 1=指令页，2=读数据页，3=写数据页
int handle_page_fault(uint64 va, int type) {
    80201cbe:	7139                	addi	sp,sp,-64
    80201cc0:	fc06                	sd	ra,56(sp)
    80201cc2:	f822                	sd	s0,48(sp)
    80201cc4:	0080                	addi	s0,sp,64
    80201cc6:	fca43423          	sd	a0,-56(s0)
    80201cca:	87ae                	mv	a5,a1
    80201ccc:	fcf42223          	sw	a5,-60(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    80201cd0:	fc442783          	lw	a5,-60(s0)
    80201cd4:	863e                	mv	a2,a5
    80201cd6:	fc843583          	ld	a1,-56(s0)
    80201cda:	00003517          	auipc	a0,0x3
    80201cde:	04e50513          	addi	a0,a0,78 # 80204d28 <small_numbers+0xb60>
    80201ce2:	fffff097          	auipc	ra,0xfffff
    80201ce6:	886080e7          	jalr	-1914(ra) # 80200568 <printf>
    
    // 页对齐地址
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    80201cea:	fc843703          	ld	a4,-56(s0)
    80201cee:	77fd                	lui	a5,0xfffff
    80201cf0:	8ff9                	and	a5,a5,a4
    80201cf2:	fef43023          	sd	a5,-32(s0)
    
    // 检查地址是否合法
    if (page_va >= MAXVA) {
    80201cf6:	fe043703          	ld	a4,-32(s0)
    80201cfa:	57fd                	li	a5,-1
    80201cfc:	83e5                	srli	a5,a5,0x19
    80201cfe:	00e7fc63          	bgeu	a5,a4,80201d16 <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    80201d02:	00003517          	auipc	a0,0x3
    80201d06:	05650513          	addi	a0,a0,86 # 80204d58 <small_numbers+0xb90>
    80201d0a:	fffff097          	auipc	ra,0xfffff
    80201d0e:	85e080e7          	jalr	-1954(ra) # 80200568 <printf>
        return 0; // 地址超出最大虚拟地址空间
    80201d12:	4781                	li	a5,0
    80201d14:	a275                	j	80201ec0 <handle_page_fault+0x202>
    }
    
    // 先检查是否已经有映射
    pte_t *pte = walk_lookup(kernel_pagetable, page_va);
    80201d16:	00005797          	auipc	a5,0x5
    80201d1a:	30a78793          	addi	a5,a5,778 # 80207020 <kernel_pagetable>
    80201d1e:	639c                	ld	a5,0(a5)
    80201d20:	fe043583          	ld	a1,-32(s0)
    80201d24:	853e                	mv	a0,a5
    80201d26:	00000097          	auipc	ra,0x0
    80201d2a:	92a080e7          	jalr	-1750(ra) # 80201650 <walk_lookup>
    80201d2e:	fca43c23          	sd	a0,-40(s0)
    if (pte && (*pte & PTE_V)) {
    80201d32:	fd843783          	ld	a5,-40(s0)
    80201d36:	c3dd                	beqz	a5,80201ddc <handle_page_fault+0x11e>
    80201d38:	fd843783          	ld	a5,-40(s0)
    80201d3c:	639c                	ld	a5,0(a5)
    80201d3e:	8b85                	andi	a5,a5,1
    80201d40:	cfd1                	beqz	a5,80201ddc <handle_page_fault+0x11e>
        // 检查是否只是权限不足
        int need_perm = 0;
    80201d42:	fe042623          	sw	zero,-20(s0)
        if (type == 1) need_perm = PTE_X;
    80201d46:	fc442783          	lw	a5,-60(s0)
    80201d4a:	0007871b          	sext.w	a4,a5
    80201d4e:	4785                	li	a5,1
    80201d50:	00f71663          	bne	a4,a5,80201d5c <handle_page_fault+0x9e>
    80201d54:	47a1                	li	a5,8
    80201d56:	fef42623          	sw	a5,-20(s0)
    80201d5a:	a035                	j	80201d86 <handle_page_fault+0xc8>
        else if (type == 2) need_perm = PTE_R;
    80201d5c:	fc442783          	lw	a5,-60(s0)
    80201d60:	0007871b          	sext.w	a4,a5
    80201d64:	4789                	li	a5,2
    80201d66:	00f71663          	bne	a4,a5,80201d72 <handle_page_fault+0xb4>
    80201d6a:	4789                	li	a5,2
    80201d6c:	fef42623          	sw	a5,-20(s0)
    80201d70:	a819                	j	80201d86 <handle_page_fault+0xc8>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    80201d72:	fc442783          	lw	a5,-60(s0)
    80201d76:	0007871b          	sext.w	a4,a5
    80201d7a:	478d                	li	a5,3
    80201d7c:	00f71563          	bne	a4,a5,80201d86 <handle_page_fault+0xc8>
    80201d80:	4799                	li	a5,6
    80201d82:	fef42623          	sw	a5,-20(s0)
        
        if ((*pte & need_perm) != need_perm) {
    80201d86:	fd843783          	ld	a5,-40(s0)
    80201d8a:	6398                	ld	a4,0(a5)
    80201d8c:	fec42783          	lw	a5,-20(s0)
    80201d90:	8f7d                	and	a4,a4,a5
    80201d92:	fec42783          	lw	a5,-20(s0)
    80201d96:	02f70963          	beq	a4,a5,80201dc8 <handle_page_fault+0x10a>
            // 更新权限
            *pte |= need_perm;
    80201d9a:	fd843783          	ld	a5,-40(s0)
    80201d9e:	6398                	ld	a4,0(a5)
    80201da0:	fec42783          	lw	a5,-20(s0)
    80201da4:	8f5d                	or	a4,a4,a5
    80201da6:	fd843783          	ld	a5,-40(s0)
    80201daa:	e398                	sd	a4,0(a5)
            sfence_vma();
    80201dac:	00000097          	auipc	ra,0x0
    80201db0:	ea8080e7          	jalr	-344(ra) # 80201c54 <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    80201db4:	00003517          	auipc	a0,0x3
    80201db8:	fcc50513          	addi	a0,a0,-52 # 80204d80 <small_numbers+0xbb8>
    80201dbc:	ffffe097          	auipc	ra,0xffffe
    80201dc0:	7ac080e7          	jalr	1964(ra) # 80200568 <printf>
            return 1;
    80201dc4:	4785                	li	a5,1
    80201dc6:	a8ed                	j	80201ec0 <handle_page_fault+0x202>
        }
        
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80201dc8:	00003517          	auipc	a0,0x3
    80201dcc:	fe050513          	addi	a0,a0,-32 # 80204da8 <small_numbers+0xbe0>
    80201dd0:	ffffe097          	auipc	ra,0xffffe
    80201dd4:	798080e7          	jalr	1944(ra) # 80200568 <printf>
        return 1;
    80201dd8:	4785                	li	a5,1
    80201dda:	a0dd                	j	80201ec0 <handle_page_fault+0x202>
    }
    
    // 分配物理页
    void* page = alloc_page();
    80201ddc:	00000097          	auipc	ra,0x0
    80201de0:	452080e7          	jalr	1106(ra) # 8020222e <alloc_page>
    80201de4:	fca43823          	sd	a0,-48(s0)
    if (page == 0) {
    80201de8:	fd043783          	ld	a5,-48(s0)
    80201dec:	eb99                	bnez	a5,80201e02 <handle_page_fault+0x144>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    80201dee:	00003517          	auipc	a0,0x3
    80201df2:	fea50513          	addi	a0,a0,-22 # 80204dd8 <small_numbers+0xc10>
    80201df6:	ffffe097          	auipc	ra,0xffffe
    80201dfa:	772080e7          	jalr	1906(ra) # 80200568 <printf>
        return 0; // 内存不足
    80201dfe:	4781                	li	a5,0
    80201e00:	a0c1                	j	80201ec0 <handle_page_fault+0x202>
    }
    
    // 清零内存
    memset(page, 0, PGSIZE);
    80201e02:	6605                	lui	a2,0x1
    80201e04:	4581                	li	a1,0
    80201e06:	fd043503          	ld	a0,-48(s0)
    80201e0a:	fffff097          	auipc	ra,0xfffff
    80201e0e:	736080e7          	jalr	1846(ra) # 80201540 <memset>
    
    // 设置权限
    int perm = 0;
    80201e12:	fe042423          	sw	zero,-24(s0)
    if (type == 1) {  // 指令页
    80201e16:	fc442783          	lw	a5,-60(s0)
    80201e1a:	0007871b          	sext.w	a4,a5
    80201e1e:	4785                	li	a5,1
    80201e20:	00f71663          	bne	a4,a5,80201e2c <handle_page_fault+0x16e>
        perm = PTE_X | PTE_R;  // 可执行页通常也需要可读
    80201e24:	47a9                	li	a5,10
    80201e26:	fef42423          	sw	a5,-24(s0)
    80201e2a:	a035                	j	80201e56 <handle_page_fault+0x198>
    } else if (type == 2) {  // 读数据页
    80201e2c:	fc442783          	lw	a5,-60(s0)
    80201e30:	0007871b          	sext.w	a4,a5
    80201e34:	4789                	li	a5,2
    80201e36:	00f71663          	bne	a4,a5,80201e42 <handle_page_fault+0x184>
        perm = PTE_R;
    80201e3a:	4789                	li	a5,2
    80201e3c:	fef42423          	sw	a5,-24(s0)
    80201e40:	a819                	j	80201e56 <handle_page_fault+0x198>
    } else if (type == 3) {  // 写数据页
    80201e42:	fc442783          	lw	a5,-60(s0)
    80201e46:	0007871b          	sext.w	a4,a5
    80201e4a:	478d                	li	a5,3
    80201e4c:	00f71563          	bne	a4,a5,80201e56 <handle_page_fault+0x198>
        perm = PTE_R | PTE_W;
    80201e50:	4799                	li	a5,6
    80201e52:	fef42423          	sw	a5,-24(s0)
    }
    
    // 映射页面
    if (map_page(kernel_pagetable, page_va, (uint64)page, perm) != 0) {
    80201e56:	00005797          	auipc	a5,0x5
    80201e5a:	1ca78793          	addi	a5,a5,458 # 80207020 <kernel_pagetable>
    80201e5e:	639c                	ld	a5,0(a5)
    80201e60:	fd043703          	ld	a4,-48(s0)
    80201e64:	fe842683          	lw	a3,-24(s0)
    80201e68:	863a                	mv	a2,a4
    80201e6a:	fe043583          	ld	a1,-32(s0)
    80201e6e:	853e                	mv	a0,a5
    80201e70:	00000097          	auipc	ra,0x0
    80201e74:	96c080e7          	jalr	-1684(ra) # 802017dc <map_page>
    80201e78:	87aa                	mv	a5,a0
    80201e7a:	c38d                	beqz	a5,80201e9c <handle_page_fault+0x1de>
        free_page(page);
    80201e7c:	fd043503          	ld	a0,-48(s0)
    80201e80:	00000097          	auipc	ra,0x0
    80201e84:	41a080e7          	jalr	1050(ra) # 8020229a <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    80201e88:	00003517          	auipc	a0,0x3
    80201e8c:	f8050513          	addi	a0,a0,-128 # 80204e08 <small_numbers+0xc40>
    80201e90:	ffffe097          	auipc	ra,0xffffe
    80201e94:	6d8080e7          	jalr	1752(ra) # 80200568 <printf>
        return 0; // 映射失败
    80201e98:	4781                	li	a5,0
    80201e9a:	a01d                	j	80201ec0 <handle_page_fault+0x202>
    }
    
    // 刷新TLB
    sfence_vma();
    80201e9c:	00000097          	auipc	ra,0x0
    80201ea0:	db8080e7          	jalr	-584(ra) # 80201c54 <sfence_vma>
    
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    80201ea4:	fd043783          	ld	a5,-48(s0)
    80201ea8:	863e                	mv	a2,a5
    80201eaa:	fe043583          	ld	a1,-32(s0)
    80201eae:	00003517          	auipc	a0,0x3
    80201eb2:	f8250513          	addi	a0,a0,-126 # 80204e30 <small_numbers+0xc68>
    80201eb6:	ffffe097          	auipc	ra,0xffffe
    80201eba:	6b2080e7          	jalr	1714(ra) # 80200568 <printf>
    return 1; // 处理成功
    80201ebe:	4785                	li	a5,1
}
    80201ec0:	853e                	mv	a0,a5
    80201ec2:	70e2                	ld	ra,56(sp)
    80201ec4:	7442                	ld	s0,48(sp)
    80201ec6:	6121                	addi	sp,sp,64
    80201ec8:	8082                	ret

0000000080201eca <test_pagetable>:
void test_pagetable(void) {
    80201eca:	7179                	addi	sp,sp,-48
    80201ecc:	f406                	sd	ra,40(sp)
    80201ece:	f022                	sd	s0,32(sp)
    80201ed0:	1800                	addi	s0,sp,48
    printf("[PT TEST] 创建页表...\n");
    80201ed2:	00003517          	auipc	a0,0x3
    80201ed6:	f9e50513          	addi	a0,a0,-98 # 80204e70 <small_numbers+0xca8>
    80201eda:	ffffe097          	auipc	ra,0xffffe
    80201ede:	68e080e7          	jalr	1678(ra) # 80200568 <printf>
    pagetable_t pt = create_pagetable();
    80201ee2:	fffff097          	auipc	ra,0xfffff
    80201ee6:	732080e7          	jalr	1842(ra) # 80201614 <create_pagetable>
    80201eea:	fea43423          	sd	a0,-24(s0)
    assert(pt != 0);
    80201eee:	fe843783          	ld	a5,-24(s0)
    80201ef2:	00f037b3          	snez	a5,a5
    80201ef6:	0ff7f793          	zext.b	a5,a5
    80201efa:	2781                	sext.w	a5,a5
    80201efc:	853e                	mv	a0,a5
    80201efe:	fffff097          	auipc	ra,0xfffff
    80201f02:	692080e7          	jalr	1682(ra) # 80201590 <assert>
    printf("[PT TEST] 页表创建通过\n");
    80201f06:	00003517          	auipc	a0,0x3
    80201f0a:	f8a50513          	addi	a0,a0,-118 # 80204e90 <small_numbers+0xcc8>
    80201f0e:	ffffe097          	auipc	ra,0xffffe
    80201f12:	65a080e7          	jalr	1626(ra) # 80200568 <printf>

    // 测试基本映射
    uint64 va = 0x1000000;
    80201f16:	010007b7          	lui	a5,0x1000
    80201f1a:	fef43023          	sd	a5,-32(s0)
    uint64 pa = (uint64)alloc_page();
    80201f1e:	00000097          	auipc	ra,0x0
    80201f22:	310080e7          	jalr	784(ra) # 8020222e <alloc_page>
    80201f26:	87aa                	mv	a5,a0
    80201f28:	fcf43c23          	sd	a5,-40(s0)
    assert(pa != 0);
    80201f2c:	fd843783          	ld	a5,-40(s0)
    80201f30:	00f037b3          	snez	a5,a5
    80201f34:	0ff7f793          	zext.b	a5,a5
    80201f38:	2781                	sext.w	a5,a5
    80201f3a:	853e                	mv	a0,a5
    80201f3c:	fffff097          	auipc	ra,0xfffff
    80201f40:	654080e7          	jalr	1620(ra) # 80201590 <assert>
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0);
    80201f44:	4699                	li	a3,6
    80201f46:	fd843603          	ld	a2,-40(s0)
    80201f4a:	fe043583          	ld	a1,-32(s0)
    80201f4e:	fe843503          	ld	a0,-24(s0)
    80201f52:	00000097          	auipc	ra,0x0
    80201f56:	88a080e7          	jalr	-1910(ra) # 802017dc <map_page>
    80201f5a:	87aa                	mv	a5,a0
    80201f5c:	0017b793          	seqz	a5,a5
    80201f60:	0ff7f793          	zext.b	a5,a5
    80201f64:	2781                	sext.w	a5,a5
    80201f66:	853e                	mv	a0,a5
    80201f68:	fffff097          	auipc	ra,0xfffff
    80201f6c:	628080e7          	jalr	1576(ra) # 80201590 <assert>
    printf("[PT TEST] 映射测试通过\n");
    80201f70:	00003517          	auipc	a0,0x3
    80201f74:	f4050513          	addi	a0,a0,-192 # 80204eb0 <small_numbers+0xce8>
    80201f78:	ffffe097          	auipc	ra,0xffffe
    80201f7c:	5f0080e7          	jalr	1520(ra) # 80200568 <printf>

    // 测试地址转换
    pte_t *pte = walk_lookup(pt, va);
    80201f80:	fe043583          	ld	a1,-32(s0)
    80201f84:	fe843503          	ld	a0,-24(s0)
    80201f88:	fffff097          	auipc	ra,0xfffff
    80201f8c:	6c8080e7          	jalr	1736(ra) # 80201650 <walk_lookup>
    80201f90:	fca43823          	sd	a0,-48(s0)
    assert(pte != 0 && (*pte & PTE_V));
    80201f94:	fd043783          	ld	a5,-48(s0)
    80201f98:	cb81                	beqz	a5,80201fa8 <test_pagetable+0xde>
    80201f9a:	fd043783          	ld	a5,-48(s0)
    80201f9e:	639c                	ld	a5,0(a5)
    80201fa0:	8b85                	andi	a5,a5,1
    80201fa2:	c399                	beqz	a5,80201fa8 <test_pagetable+0xde>
    80201fa4:	4785                	li	a5,1
    80201fa6:	a011                	j	80201faa <test_pagetable+0xe0>
    80201fa8:	4781                	li	a5,0
    80201faa:	853e                	mv	a0,a5
    80201fac:	fffff097          	auipc	ra,0xfffff
    80201fb0:	5e4080e7          	jalr	1508(ra) # 80201590 <assert>
    assert(PTE2PA(*pte) == pa);
    80201fb4:	fd043783          	ld	a5,-48(s0)
    80201fb8:	639c                	ld	a5,0(a5)
    80201fba:	83a9                	srli	a5,a5,0xa
    80201fbc:	07b2                	slli	a5,a5,0xc
    80201fbe:	fd843703          	ld	a4,-40(s0)
    80201fc2:	40f707b3          	sub	a5,a4,a5
    80201fc6:	0017b793          	seqz	a5,a5
    80201fca:	0ff7f793          	zext.b	a5,a5
    80201fce:	2781                	sext.w	a5,a5
    80201fd0:	853e                	mv	a0,a5
    80201fd2:	fffff097          	auipc	ra,0xfffff
    80201fd6:	5be080e7          	jalr	1470(ra) # 80201590 <assert>
    printf("[PT TEST] 地址转换测试通过\n");
    80201fda:	00003517          	auipc	a0,0x3
    80201fde:	ef650513          	addi	a0,a0,-266 # 80204ed0 <small_numbers+0xd08>
    80201fe2:	ffffe097          	auipc	ra,0xffffe
    80201fe6:	586080e7          	jalr	1414(ra) # 80200568 <printf>

    // 测试权限位
    assert(*pte & PTE_R);
    80201fea:	fd043783          	ld	a5,-48(s0)
    80201fee:	639c                	ld	a5,0(a5)
    80201ff0:	2781                	sext.w	a5,a5
    80201ff2:	8b89                	andi	a5,a5,2
    80201ff4:	2781                	sext.w	a5,a5
    80201ff6:	853e                	mv	a0,a5
    80201ff8:	fffff097          	auipc	ra,0xfffff
    80201ffc:	598080e7          	jalr	1432(ra) # 80201590 <assert>
    assert(*pte & PTE_W);
    80202000:	fd043783          	ld	a5,-48(s0)
    80202004:	639c                	ld	a5,0(a5)
    80202006:	2781                	sext.w	a5,a5
    80202008:	8b91                	andi	a5,a5,4
    8020200a:	2781                	sext.w	a5,a5
    8020200c:	853e                	mv	a0,a5
    8020200e:	fffff097          	auipc	ra,0xfffff
    80202012:	582080e7          	jalr	1410(ra) # 80201590 <assert>
    assert(!(*pte & PTE_X));
    80202016:	fd043783          	ld	a5,-48(s0)
    8020201a:	639c                	ld	a5,0(a5)
    8020201c:	8ba1                	andi	a5,a5,8
    8020201e:	0017b793          	seqz	a5,a5
    80202022:	0ff7f793          	zext.b	a5,a5
    80202026:	2781                	sext.w	a5,a5
    80202028:	853e                	mv	a0,a5
    8020202a:	fffff097          	auipc	ra,0xfffff
    8020202e:	566080e7          	jalr	1382(ra) # 80201590 <assert>
    printf("[PT TEST] 权限测试通过\n");
    80202032:	00003517          	auipc	a0,0x3
    80202036:	ec650513          	addi	a0,a0,-314 # 80204ef8 <small_numbers+0xd30>
    8020203a:	ffffe097          	auipc	ra,0xffffe
    8020203e:	52e080e7          	jalr	1326(ra) # 80200568 <printf>

    // 清理
    free_page((void*)pa);
    80202042:	fd843783          	ld	a5,-40(s0)
    80202046:	853e                	mv	a0,a5
    80202048:	00000097          	auipc	ra,0x0
    8020204c:	252080e7          	jalr	594(ra) # 8020229a <free_page>
    free_pagetable(pt);
    80202050:	fe843503          	ld	a0,-24(s0)
    80202054:	00000097          	auipc	ra,0x0
    80202058:	86e080e7          	jalr	-1938(ra) # 802018c2 <free_pagetable>

    printf("[PT TEST] 所有页表测试通过\n");
    8020205c:	00003517          	auipc	a0,0x3
    80202060:	ebc50513          	addi	a0,a0,-324 # 80204f18 <small_numbers+0xd50>
    80202064:	ffffe097          	auipc	ra,0xffffe
    80202068:	504080e7          	jalr	1284(ra) # 80200568 <printf>
}
    8020206c:	0001                	nop
    8020206e:	70a2                	ld	ra,40(sp)
    80202070:	7402                	ld	s0,32(sp)
    80202072:	6145                	addi	sp,sp,48
    80202074:	8082                	ret

0000000080202076 <check_mapping>:
void check_mapping(uint64 va) {
    80202076:	7179                	addi	sp,sp,-48
    80202078:	f406                	sd	ra,40(sp)
    8020207a:	f022                	sd	s0,32(sp)
    8020207c:	1800                	addi	s0,sp,48
    8020207e:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    80202082:	00005797          	auipc	a5,0x5
    80202086:	f9e78793          	addi	a5,a5,-98 # 80207020 <kernel_pagetable>
    8020208a:	639c                	ld	a5,0(a5)
    8020208c:	fd843583          	ld	a1,-40(s0)
    80202090:	853e                	mv	a0,a5
    80202092:	fffff097          	auipc	ra,0xfffff
    80202096:	5be080e7          	jalr	1470(ra) # 80201650 <walk_lookup>
    8020209a:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    8020209e:	fe843783          	ld	a5,-24(s0)
    802020a2:	c78d                	beqz	a5,802020cc <check_mapping+0x56>
    802020a4:	fe843783          	ld	a5,-24(s0)
    802020a8:	639c                	ld	a5,0(a5)
    802020aa:	8b85                	andi	a5,a5,1
    802020ac:	c385                	beqz	a5,802020cc <check_mapping+0x56>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    802020ae:	fe843783          	ld	a5,-24(s0)
    802020b2:	639c                	ld	a5,0(a5)
    802020b4:	863e                	mv	a2,a5
    802020b6:	fd843583          	ld	a1,-40(s0)
    802020ba:	00003517          	auipc	a0,0x3
    802020be:	e8650513          	addi	a0,a0,-378 # 80204f40 <small_numbers+0xd78>
    802020c2:	ffffe097          	auipc	ra,0xffffe
    802020c6:	4a6080e7          	jalr	1190(ra) # 80200568 <printf>
    802020ca:	a821                	j	802020e2 <check_mapping+0x6c>
    } else {
        printf("Address 0x%lx is NOT mapped\n", va);
    802020cc:	fd843583          	ld	a1,-40(s0)
    802020d0:	00003517          	auipc	a0,0x3
    802020d4:	e9850513          	addi	a0,a0,-360 # 80204f68 <small_numbers+0xda0>
    802020d8:	ffffe097          	auipc	ra,0xffffe
    802020dc:	490080e7          	jalr	1168(ra) # 80200568 <printf>
    }
}
    802020e0:	0001                	nop
    802020e2:	0001                	nop
    802020e4:	70a2                	ld	ra,40(sp)
    802020e6:	7402                	ld	s0,32(sp)
    802020e8:	6145                	addi	sp,sp,48
    802020ea:	8082                	ret

00000000802020ec <check_is_mapped>:
int check_is_mapped(uint64 va) {
    802020ec:	7179                	addi	sp,sp,-48
    802020ee:	f406                	sd	ra,40(sp)
    802020f0:	f022                	sd	s0,32(sp)
    802020f2:	1800                	addi	s0,sp,48
    802020f4:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    802020f8:	00000097          	auipc	ra,0x0
    802020fc:	bae080e7          	jalr	-1106(ra) # 80201ca6 <get_current_pagetable>
    80202100:	87aa                	mv	a5,a0
    80202102:	fd843583          	ld	a1,-40(s0)
    80202106:	853e                	mv	a0,a5
    80202108:	fffff097          	auipc	ra,0xfffff
    8020210c:	548080e7          	jalr	1352(ra) # 80201650 <walk_lookup>
    80202110:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    80202114:	fe843783          	ld	a5,-24(s0)
    80202118:	c795                	beqz	a5,80202144 <check_is_mapped+0x58>
    8020211a:	fe843783          	ld	a5,-24(s0)
    8020211e:	639c                	ld	a5,0(a5)
    80202120:	8b85                	andi	a5,a5,1
    80202122:	c38d                	beqz	a5,80202144 <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80202124:	fe843783          	ld	a5,-24(s0)
    80202128:	639c                	ld	a5,0(a5)
    8020212a:	863e                	mv	a2,a5
    8020212c:	fd843583          	ld	a1,-40(s0)
    80202130:	00003517          	auipc	a0,0x3
    80202134:	e1050513          	addi	a0,a0,-496 # 80204f40 <small_numbers+0xd78>
    80202138:	ffffe097          	auipc	ra,0xffffe
    8020213c:	430080e7          	jalr	1072(ra) # 80200568 <printf>
        return 1;
    80202140:	4785                	li	a5,1
    80202142:	a821                	j	8020215a <check_is_mapped+0x6e>
    } else {
        printf("Address 0x%lx is NOT mapped\n", va);
    80202144:	fd843583          	ld	a1,-40(s0)
    80202148:	00003517          	auipc	a0,0x3
    8020214c:	e2050513          	addi	a0,a0,-480 # 80204f68 <small_numbers+0xda0>
    80202150:	ffffe097          	auipc	ra,0xffffe
    80202154:	418080e7          	jalr	1048(ra) # 80200568 <printf>
        return 0;
    80202158:	4781                	li	a5,0
    }
    8020215a:	853e                	mv	a0,a5
    8020215c:	70a2                	ld	ra,40(sp)
    8020215e:	7402                	ld	s0,32(sp)
    80202160:	6145                	addi	sp,sp,48
    80202162:	8082                	ret

0000000080202164 <assert>:
#include "pm.h"
#include "memlayout.h"
#include "types.h"
    80202164:	1101                	addi	sp,sp,-32
    80202166:	ec06                	sd	ra,24(sp)
    80202168:	e822                	sd	s0,16(sp)
    8020216a:	1000                	addi	s0,sp,32
    8020216c:	87aa                	mv	a5,a0
    8020216e:	fef42623          	sw	a5,-20(s0)
#include "printf.h"
    80202172:	fec42783          	lw	a5,-20(s0)
    80202176:	2781                	sext.w	a5,a5
    80202178:	e795                	bnez	a5,802021a4 <assert+0x40>
#include "mem.h"
    8020217a:	4615                	li	a2,5
    8020217c:	00003597          	auipc	a1,0x3
    80202180:	e0c58593          	addi	a1,a1,-500 # 80204f88 <small_numbers+0xdc0>
    80202184:	00003517          	auipc	a0,0x3
    80202188:	e1450513          	addi	a0,a0,-492 # 80204f98 <small_numbers+0xdd0>
    8020218c:	ffffe097          	auipc	ra,0xffffe
    80202190:	3dc080e7          	jalr	988(ra) # 80200568 <printf>
#include "assert.h"
    80202194:	00003517          	auipc	a0,0x3
    80202198:	e2c50513          	addi	a0,a0,-468 # 80204fc0 <small_numbers+0xdf8>
    8020219c:	fffff097          	auipc	ra,0xfffff
    802021a0:	cd4080e7          	jalr	-812(ra) # 80200e70 <panic>

struct run {
    802021a4:	0001                	nop
    802021a6:	60e2                	ld	ra,24(sp)
    802021a8:	6442                	ld	s0,16(sp)
    802021aa:	6105                	addi	sp,sp,32
    802021ac:	8082                	ret

00000000802021ae <freerange>:

static struct run *freelist = 0;

extern char end[];

static void freerange(void *pa_start, void *pa_end) {
    802021ae:	7179                	addi	sp,sp,-48
    802021b0:	f406                	sd	ra,40(sp)
    802021b2:	f022                	sd	s0,32(sp)
    802021b4:	1800                	addi	s0,sp,48
    802021b6:	fca43c23          	sd	a0,-40(s0)
    802021ba:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    802021be:	fd843703          	ld	a4,-40(s0)
    802021c2:	6785                	lui	a5,0x1
    802021c4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802021c6:	973e                	add	a4,a4,a5
    802021c8:	77fd                	lui	a5,0xfffff
    802021ca:	8ff9                	and	a5,a5,a4
    802021cc:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802021d0:	a829                	j	802021ea <freerange+0x3c>
    free_page(p);
    802021d2:	fe843503          	ld	a0,-24(s0)
    802021d6:	00000097          	auipc	ra,0x0
    802021da:	0c4080e7          	jalr	196(ra) # 8020229a <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802021de:	fe843703          	ld	a4,-24(s0)
    802021e2:	6785                	lui	a5,0x1
    802021e4:	97ba                	add	a5,a5,a4
    802021e6:	fef43423          	sd	a5,-24(s0)
    802021ea:	fe843703          	ld	a4,-24(s0)
    802021ee:	6785                	lui	a5,0x1
    802021f0:	97ba                	add	a5,a5,a4
    802021f2:	fd043703          	ld	a4,-48(s0)
    802021f6:	fcf77ee3          	bgeu	a4,a5,802021d2 <freerange+0x24>
  }
}
    802021fa:	0001                	nop
    802021fc:	0001                	nop
    802021fe:	70a2                	ld	ra,40(sp)
    80202200:	7402                	ld	s0,32(sp)
    80202202:	6145                	addi	sp,sp,48
    80202204:	8082                	ret

0000000080202206 <pmm_init>:

void pmm_init(void) {
    80202206:	1141                	addi	sp,sp,-16
    80202208:	e406                	sd	ra,8(sp)
    8020220a:	e022                	sd	s0,0(sp)
    8020220c:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    8020220e:	47c5                	li	a5,17
    80202210:	01b79593          	slli	a1,a5,0x1b
    80202214:	00005517          	auipc	a0,0x5
    80202218:	0ac50513          	addi	a0,a0,172 # 802072c0 <_bss_end>
    8020221c:	00000097          	auipc	ra,0x0
    80202220:	f92080e7          	jalr	-110(ra) # 802021ae <freerange>
}
    80202224:	0001                	nop
    80202226:	60a2                	ld	ra,8(sp)
    80202228:	6402                	ld	s0,0(sp)
    8020222a:	0141                	addi	sp,sp,16
    8020222c:	8082                	ret

000000008020222e <alloc_page>:

void* alloc_page(void) {
    8020222e:	1101                	addi	sp,sp,-32
    80202230:	ec06                	sd	ra,24(sp)
    80202232:	e822                	sd	s0,16(sp)
    80202234:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80202236:	00005797          	auipc	a5,0x5
    8020223a:	e8278793          	addi	a5,a5,-382 # 802070b8 <freelist>
    8020223e:	639c                	ld	a5,0(a5)
    80202240:	fef43423          	sd	a5,-24(s0)
  if(r)
    80202244:	fe843783          	ld	a5,-24(s0)
    80202248:	cb89                	beqz	a5,8020225a <alloc_page+0x2c>
    freelist = r->next;
    8020224a:	fe843783          	ld	a5,-24(s0)
    8020224e:	6398                	ld	a4,0(a5)
    80202250:	00005797          	auipc	a5,0x5
    80202254:	e6878793          	addi	a5,a5,-408 # 802070b8 <freelist>
    80202258:	e398                	sd	a4,0(a5)
  if(r)
    8020225a:	fe843783          	ld	a5,-24(s0)
    8020225e:	cf99                	beqz	a5,8020227c <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    80202260:	fe843783          	ld	a5,-24(s0)
    80202264:	00878713          	addi	a4,a5,8
    80202268:	6785                	lui	a5,0x1
    8020226a:	ff878613          	addi	a2,a5,-8 # ff8 <_entry-0x801ff008>
    8020226e:	4595                	li	a1,5
    80202270:	853a                	mv	a0,a4
    80202272:	fffff097          	auipc	ra,0xfffff
    80202276:	2ce080e7          	jalr	718(ra) # 80201540 <memset>
    8020227a:	a809                	j	8020228c <alloc_page+0x5e>
  else
    panic("alloc_page: out of memory");
    8020227c:	00003517          	auipc	a0,0x3
    80202280:	d4c50513          	addi	a0,a0,-692 # 80204fc8 <small_numbers+0xe00>
    80202284:	fffff097          	auipc	ra,0xfffff
    80202288:	bec080e7          	jalr	-1044(ra) # 80200e70 <panic>
  return (void*)r;
    8020228c:	fe843783          	ld	a5,-24(s0)
}
    80202290:	853e                	mv	a0,a5
    80202292:	60e2                	ld	ra,24(sp)
    80202294:	6442                	ld	s0,16(sp)
    80202296:	6105                	addi	sp,sp,32
    80202298:	8082                	ret

000000008020229a <free_page>:

void free_page(void* page) {
    8020229a:	7179                	addi	sp,sp,-48
    8020229c:	f406                	sd	ra,40(sp)
    8020229e:	f022                	sd	s0,32(sp)
    802022a0:	1800                	addi	s0,sp,48
    802022a2:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    802022a6:	fd843783          	ld	a5,-40(s0)
    802022aa:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    802022ae:	fd843703          	ld	a4,-40(s0)
    802022b2:	6785                	lui	a5,0x1
    802022b4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802022b6:	8ff9                	and	a5,a5,a4
    802022b8:	ef99                	bnez	a5,802022d6 <free_page+0x3c>
    802022ba:	fd843703          	ld	a4,-40(s0)
    802022be:	00005797          	auipc	a5,0x5
    802022c2:	00278793          	addi	a5,a5,2 # 802072c0 <_bss_end>
    802022c6:	00f76863          	bltu	a4,a5,802022d6 <free_page+0x3c>
    802022ca:	fd843703          	ld	a4,-40(s0)
    802022ce:	47c5                	li	a5,17
    802022d0:	07ee                	slli	a5,a5,0x1b
    802022d2:	00f76a63          	bltu	a4,a5,802022e6 <free_page+0x4c>
    panic("free_page: invalid page address");
    802022d6:	00003517          	auipc	a0,0x3
    802022da:	d1250513          	addi	a0,a0,-750 # 80204fe8 <small_numbers+0xe20>
    802022de:	fffff097          	auipc	ra,0xfffff
    802022e2:	b92080e7          	jalr	-1134(ra) # 80200e70 <panic>
  r->next = freelist;
    802022e6:	00005797          	auipc	a5,0x5
    802022ea:	dd278793          	addi	a5,a5,-558 # 802070b8 <freelist>
    802022ee:	6398                	ld	a4,0(a5)
    802022f0:	fe843783          	ld	a5,-24(s0)
    802022f4:	e398                	sd	a4,0(a5)
  freelist = r;
    802022f6:	00005797          	auipc	a5,0x5
    802022fa:	dc278793          	addi	a5,a5,-574 # 802070b8 <freelist>
    802022fe:	fe843703          	ld	a4,-24(s0)
    80202302:	e398                	sd	a4,0(a5)
}
    80202304:	0001                	nop
    80202306:	70a2                	ld	ra,40(sp)
    80202308:	7402                	ld	s0,32(sp)
    8020230a:	6145                	addi	sp,sp,48
    8020230c:	8082                	ret

000000008020230e <test_physical_memory>:

void test_physical_memory(void) {
    8020230e:	7179                	addi	sp,sp,-48
    80202310:	f406                	sd	ra,40(sp)
    80202312:	f022                	sd	s0,32(sp)
    80202314:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    80202316:	00003517          	auipc	a0,0x3
    8020231a:	cf250513          	addi	a0,a0,-782 # 80205008 <small_numbers+0xe40>
    8020231e:	ffffe097          	auipc	ra,0xffffe
    80202322:	24a080e7          	jalr	586(ra) # 80200568 <printf>
    void *page1 = alloc_page();
    80202326:	00000097          	auipc	ra,0x0
    8020232a:	f08080e7          	jalr	-248(ra) # 8020222e <alloc_page>
    8020232e:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    80202332:	00000097          	auipc	ra,0x0
    80202336:	efc080e7          	jalr	-260(ra) # 8020222e <alloc_page>
    8020233a:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    8020233e:	fe843783          	ld	a5,-24(s0)
    80202342:	00f037b3          	snez	a5,a5
    80202346:	0ff7f793          	zext.b	a5,a5
    8020234a:	2781                	sext.w	a5,a5
    8020234c:	853e                	mv	a0,a5
    8020234e:	00000097          	auipc	ra,0x0
    80202352:	e16080e7          	jalr	-490(ra) # 80202164 <assert>
    assert(page2 != 0);
    80202356:	fe043783          	ld	a5,-32(s0)
    8020235a:	00f037b3          	snez	a5,a5
    8020235e:	0ff7f793          	zext.b	a5,a5
    80202362:	2781                	sext.w	a5,a5
    80202364:	853e                	mv	a0,a5
    80202366:	00000097          	auipc	ra,0x0
    8020236a:	dfe080e7          	jalr	-514(ra) # 80202164 <assert>
    assert(page1 != page2);
    8020236e:	fe843703          	ld	a4,-24(s0)
    80202372:	fe043783          	ld	a5,-32(s0)
    80202376:	40f707b3          	sub	a5,a4,a5
    8020237a:	00f037b3          	snez	a5,a5
    8020237e:	0ff7f793          	zext.b	a5,a5
    80202382:	2781                	sext.w	a5,a5
    80202384:	853e                	mv	a0,a5
    80202386:	00000097          	auipc	ra,0x0
    8020238a:	dde080e7          	jalr	-546(ra) # 80202164 <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    8020238e:	fe843703          	ld	a4,-24(s0)
    80202392:	6785                	lui	a5,0x1
    80202394:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80202396:	8ff9                	and	a5,a5,a4
    80202398:	0017b793          	seqz	a5,a5
    8020239c:	0ff7f793          	zext.b	a5,a5
    802023a0:	2781                	sext.w	a5,a5
    802023a2:	853e                	mv	a0,a5
    802023a4:	00000097          	auipc	ra,0x0
    802023a8:	dc0080e7          	jalr	-576(ra) # 80202164 <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    802023ac:	fe043703          	ld	a4,-32(s0)
    802023b0:	6785                	lui	a5,0x1
    802023b2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802023b4:	8ff9                	and	a5,a5,a4
    802023b6:	0017b793          	seqz	a5,a5
    802023ba:	0ff7f793          	zext.b	a5,a5
    802023be:	2781                	sext.w	a5,a5
    802023c0:	853e                	mv	a0,a5
    802023c2:	00000097          	auipc	ra,0x0
    802023c6:	da2080e7          	jalr	-606(ra) # 80202164 <assert>
    printf("[PM TEST] 分配测试通过\n");
    802023ca:	00003517          	auipc	a0,0x3
    802023ce:	c5e50513          	addi	a0,a0,-930 # 80205028 <small_numbers+0xe60>
    802023d2:	ffffe097          	auipc	ra,0xffffe
    802023d6:	196080e7          	jalr	406(ra) # 80200568 <printf>

    printf("[PM TEST] 数据写入测试...\n");
    802023da:	00003517          	auipc	a0,0x3
    802023de:	c6e50513          	addi	a0,a0,-914 # 80205048 <small_numbers+0xe80>
    802023e2:	ffffe097          	auipc	ra,0xffffe
    802023e6:	186080e7          	jalr	390(ra) # 80200568 <printf>
    *(int*)page1 = 0x12345678;
    802023ea:	fe843783          	ld	a5,-24(s0)
    802023ee:	12345737          	lui	a4,0x12345
    802023f2:	67870713          	addi	a4,a4,1656 # 12345678 <_entry-0x6deba988>
    802023f6:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    802023f8:	fe843783          	ld	a5,-24(s0)
    802023fc:	439c                	lw	a5,0(a5)
    802023fe:	873e                	mv	a4,a5
    80202400:	123457b7          	lui	a5,0x12345
    80202404:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6deba988>
    80202408:	40f707b3          	sub	a5,a4,a5
    8020240c:	0017b793          	seqz	a5,a5
    80202410:	0ff7f793          	zext.b	a5,a5
    80202414:	2781                	sext.w	a5,a5
    80202416:	853e                	mv	a0,a5
    80202418:	00000097          	auipc	ra,0x0
    8020241c:	d4c080e7          	jalr	-692(ra) # 80202164 <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    80202420:	00003517          	auipc	a0,0x3
    80202424:	c5050513          	addi	a0,a0,-944 # 80205070 <small_numbers+0xea8>
    80202428:	ffffe097          	auipc	ra,0xffffe
    8020242c:	140080e7          	jalr	320(ra) # 80200568 <printf>

    printf("[PM TEST] 释放与重新分配测试...\n");
    80202430:	00003517          	auipc	a0,0x3
    80202434:	c6850513          	addi	a0,a0,-920 # 80205098 <small_numbers+0xed0>
    80202438:	ffffe097          	auipc	ra,0xffffe
    8020243c:	130080e7          	jalr	304(ra) # 80200568 <printf>
    free_page(page1);
    80202440:	fe843503          	ld	a0,-24(s0)
    80202444:	00000097          	auipc	ra,0x0
    80202448:	e56080e7          	jalr	-426(ra) # 8020229a <free_page>
    void *page3 = alloc_page();
    8020244c:	00000097          	auipc	ra,0x0
    80202450:	de2080e7          	jalr	-542(ra) # 8020222e <alloc_page>
    80202454:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    80202458:	fd843783          	ld	a5,-40(s0)
    8020245c:	00f037b3          	snez	a5,a5
    80202460:	0ff7f793          	zext.b	a5,a5
    80202464:	2781                	sext.w	a5,a5
    80202466:	853e                	mv	a0,a5
    80202468:	00000097          	auipc	ra,0x0
    8020246c:	cfc080e7          	jalr	-772(ra) # 80202164 <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    80202470:	00003517          	auipc	a0,0x3
    80202474:	c5850513          	addi	a0,a0,-936 # 802050c8 <small_numbers+0xf00>
    80202478:	ffffe097          	auipc	ra,0xffffe
    8020247c:	0f0080e7          	jalr	240(ra) # 80200568 <printf>

    free_page(page2);
    80202480:	fe043503          	ld	a0,-32(s0)
    80202484:	00000097          	auipc	ra,0x0
    80202488:	e16080e7          	jalr	-490(ra) # 8020229a <free_page>
    free_page(page3);
    8020248c:	fd843503          	ld	a0,-40(s0)
    80202490:	00000097          	auipc	ra,0x0
    80202494:	e0a080e7          	jalr	-502(ra) # 8020229a <free_page>

    printf("[PM TEST] 所有物理内存管理测试通过\n");
    80202498:	00003517          	auipc	a0,0x3
    8020249c:	c6050513          	addi	a0,a0,-928 # 802050f8 <small_numbers+0xf30>
    802024a0:	ffffe097          	auipc	ra,0xffffe
    802024a4:	0c8080e7          	jalr	200(ra) # 80200568 <printf>
    802024a8:	0001                	nop
    802024aa:	70a2                	ld	ra,40(sp)
    802024ac:	7402                	ld	s0,32(sp)
    802024ae:	6145                	addi	sp,sp,48
    802024b0:	8082                	ret

00000000802024b2 <sbi_set_time>:
#include "printf.h"

// SBI ecall 编号
#define SBI_SET_TIME 0x0

void sbi_set_time(uint64 time) {
    802024b2:	1101                	addi	sp,sp,-32
    802024b4:	ec22                	sd	s0,24(sp)
    802024b6:	1000                	addi	s0,sp,32
    802024b8:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    802024bc:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    802024c0:	4881                	li	a7,0
    asm volatile ("ecall"
    802024c2:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    802024c6:	0001                	nop
    802024c8:	6462                	ld	s0,24(sp)
    802024ca:	6105                	addi	sp,sp,32
    802024cc:	8082                	ret

00000000802024ce <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    802024ce:	1101                	addi	sp,sp,-32
    802024d0:	ec22                	sd	s0,24(sp)
    802024d2:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    802024d4:	c01027f3          	rdtime	a5
    802024d8:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    802024dc:	fe843783          	ld	a5,-24(s0)
    802024e0:	853e                	mv	a0,a5
    802024e2:	6462                	ld	s0,24(sp)
    802024e4:	6105                	addi	sp,sp,32
    802024e6:	8082                	ret

00000000802024e8 <timeintr>:
#include "trap.h"
#include "riscv.h"  // 确保包含了这个头文件

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    802024e8:	1141                	addi	sp,sp,-16
    802024ea:	e422                	sd	s0,8(sp)
    802024ec:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    802024ee:	00005797          	auipc	a5,0x5
    802024f2:	b3a78793          	addi	a5,a5,-1222 # 80207028 <interrupt_test_flag>
    802024f6:	639c                	ld	a5,0(a5)
    802024f8:	cb99                	beqz	a5,8020250e <timeintr+0x26>
        (*interrupt_test_flag)++;
    802024fa:	00005797          	auipc	a5,0x5
    802024fe:	b2e78793          	addi	a5,a5,-1234 # 80207028 <interrupt_test_flag>
    80202502:	639c                	ld	a5,0(a5)
    80202504:	4398                	lw	a4,0(a5)
    80202506:	2701                	sext.w	a4,a4
    80202508:	2705                	addiw	a4,a4,1
    8020250a:	2701                	sext.w	a4,a4
    8020250c:	c398                	sw	a4,0(a5)
    8020250e:	0001                	nop
    80202510:	6422                	ld	s0,8(sp)
    80202512:	0141                	addi	sp,sp,16
    80202514:	8082                	ret

0000000080202516 <r_sie>:
#include "plic.h"
#include "memlayout.h"
#include "timer.h"
#include "riscv.h"
#include "printf.h"
#include "sbi.h"
    80202516:	1101                	addi	sp,sp,-32
    80202518:	ec22                	sd	s0,24(sp)
    8020251a:	1000                	addi	s0,sp,32
#include "uart.h"
#include "vm.h"
    8020251c:	104027f3          	csrr	a5,sie
    80202520:	fef43423          	sd	a5,-24(s0)
#include "mem.h"
    80202524:	fe843783          	ld	a5,-24(s0)
#include "pm.h"
    80202528:	853e                	mv	a0,a5
    8020252a:	6462                	ld	s0,24(sp)
    8020252c:	6105                	addi	sp,sp,32
    8020252e:	8082                	ret

0000000080202530 <w_sie>:

// 全局测试变量，用于中断测试
    80202530:	1101                	addi	sp,sp,-32
    80202532:	ec22                	sd	s0,24(sp)
    80202534:	1000                	addi	s0,sp,32
    80202536:	fea43423          	sd	a0,-24(s0)
volatile int *interrupt_test_flag = 0;
    8020253a:	fe843783          	ld	a5,-24(s0)
    8020253e:	10479073          	csrw	sie,a5
extern void kernelvec();
    80202542:	0001                	nop
    80202544:	6462                	ld	s0,24(sp)
    80202546:	6105                	addi	sp,sp,32
    80202548:	8082                	ret

000000008020254a <r_sstatus>:
interrupt_handler_t interrupt_vector[MAX_IRQ];
void register_interrupt(int irq, interrupt_handler_t h) {
    8020254a:	1101                	addi	sp,sp,-32
    8020254c:	ec22                	sd	s0,24(sp)
    8020254e:	1000                	addi	s0,sp,32
    if (irq >= 0 && irq < MAX_IRQ){
        interrupt_vector[irq] = h;
    80202550:	100027f3          	csrr	a5,sstatus
    80202554:	fef43423          	sd	a5,-24(s0)
	}
    80202558:	fe843783          	ld	a5,-24(s0)
}
    8020255c:	853e                	mv	a0,a5
    8020255e:	6462                	ld	s0,24(sp)
    80202560:	6105                	addi	sp,sp,32
    80202562:	8082                	ret

0000000080202564 <w_sstatus>:

    80202564:	1101                	addi	sp,sp,-32
    80202566:	ec22                	sd	s0,24(sp)
    80202568:	1000                	addi	s0,sp,32
    8020256a:	fea43423          	sd	a0,-24(s0)
void unregister_interrupt(int irq) {
    8020256e:	fe843783          	ld	a5,-24(s0)
    80202572:	10079073          	csrw	sstatus,a5
    if (irq >= 0 && irq < MAX_IRQ)
    80202576:	0001                	nop
    80202578:	6462                	ld	s0,24(sp)
    8020257a:	6105                	addi	sp,sp,32
    8020257c:	8082                	ret

000000008020257e <w_sepc>:
        interrupt_vector[irq] = 0;
}
void enable_interrupts(int irq) {
    8020257e:	1101                	addi	sp,sp,-32
    80202580:	ec22                	sd	s0,24(sp)
    80202582:	1000                	addi	s0,sp,32
    80202584:	fea43423          	sd	a0,-24(s0)
    plic_enable(irq);
    80202588:	fe843783          	ld	a5,-24(s0)
    8020258c:	14179073          	csrw	sepc,a5
}
    80202590:	0001                	nop
    80202592:	6462                	ld	s0,24(sp)
    80202594:	6105                	addi	sp,sp,32
    80202596:	8082                	ret

0000000080202598 <intr_off>:

void disable_interrupts(int irq) {
    plic_disable(irq);
}

void interrupt_dispatch(int irq) {
    80202598:	1141                	addi	sp,sp,-16
    8020259a:	e406                	sd	ra,8(sp)
    8020259c:	e022                	sd	s0,0(sp)
    8020259e:	0800                	addi	s0,sp,16
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    802025a0:	00000097          	auipc	ra,0x0
    802025a4:	faa080e7          	jalr	-86(ra) # 8020254a <r_sstatus>
    802025a8:	87aa                	mv	a5,a0
    802025aa:	9bf5                	andi	a5,a5,-3
    802025ac:	853e                	mv	a0,a5
    802025ae:	00000097          	auipc	ra,0x0
    802025b2:	fb6080e7          	jalr	-74(ra) # 80202564 <w_sstatus>
		interrupt_vector[irq]();
    802025b6:	0001                	nop
    802025b8:	60a2                	ld	ra,8(sp)
    802025ba:	6402                	ld	s0,0(sp)
    802025bc:	0141                	addi	sp,sp,16
    802025be:	8082                	ret

00000000802025c0 <w_stvec>:
	}
}
// 处理外部中断
    802025c0:	1101                	addi	sp,sp,-32
    802025c2:	ec22                	sd	s0,24(sp)
    802025c4:	1000                	addi	s0,sp,32
    802025c6:	fea43423          	sd	a0,-24(s0)
void handle_external_interrupt(void) {
    802025ca:	fe843783          	ld	a5,-24(s0)
    802025ce:	10579073          	csrw	stvec,a5
    // 从PLIC获取中断号
    802025d2:	0001                	nop
    802025d4:	6462                	ld	s0,24(sp)
    802025d6:	6105                	addi	sp,sp,32
    802025d8:	8082                	ret

00000000802025da <r_scause>:
    if (irq == 0) {
        // 虚假中断
        printf("Spurious external interrupt\n");
        return;
    }
    interrupt_dispatch(irq);
    802025da:	1101                	addi	sp,sp,-32
    802025dc:	ec22                	sd	s0,24(sp)
    802025de:	1000                	addi	s0,sp,32
    plic_complete(irq);
}
    802025e0:	142027f3          	csrr	a5,scause
    802025e4:	fef43423          	sd	a5,-24(s0)

    802025e8:	fe843783          	ld	a5,-24(s0)
void trap_init(void) {
    802025ec:	853e                	mv	a0,a5
    802025ee:	6462                	ld	s0,24(sp)
    802025f0:	6105                	addi	sp,sp,32
    802025f2:	8082                	ret

00000000802025f4 <r_sepc>:
	intr_off();
	printf("trap_init...\n");
    802025f4:	1101                	addi	sp,sp,-32
    802025f6:	ec22                	sd	s0,24(sp)
    802025f8:	1000                	addi	s0,sp,32
	w_stvec((uint64)kernelvec);
	for(int i = 0; i < MAX_IRQ; i++){
    802025fa:	141027f3          	csrr	a5,sepc
    802025fe:	fef43423          	sd	a5,-24(s0)
		interrupt_vector[i] = 0;
    80202602:	fe843783          	ld	a5,-24(s0)
	}
    80202606:	853e                	mv	a0,a5
    80202608:	6462                	ld	s0,24(sp)
    8020260a:	6105                	addi	sp,sp,32
    8020260c:	8082                	ret

000000008020260e <r_stval>:
	plic_init();
    uint64 sie = r_sie();
    8020260e:	1101                	addi	sp,sp,-32
    80202610:	ec22                	sd	s0,24(sp)
    80202612:	1000                	addi	s0,sp,32
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80202614:	143027f3          	csrr	a5,stval
    80202618:	fef43423          	sd	a5,-24(s0)
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    8020261c:	fe843783          	ld	a5,-24(s0)
	printf("trap_init complete.\n");
    80202620:	853e                	mv	a0,a5
    80202622:	6462                	ld	s0,24(sp)
    80202624:	6105                	addi	sp,sp,32
    80202626:	8082                	ret

0000000080202628 <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    80202628:	1101                	addi	sp,sp,-32
    8020262a:	ec22                	sd	s0,24(sp)
    8020262c:	1000                	addi	s0,sp,32
    8020262e:	87aa                	mv	a5,a0
    80202630:	feb43023          	sd	a1,-32(s0)
    80202634:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    80202638:	fec42783          	lw	a5,-20(s0)
    8020263c:	2781                	sext.w	a5,a5
    8020263e:	0207c563          	bltz	a5,80202668 <register_interrupt+0x40>
    80202642:	fec42783          	lw	a5,-20(s0)
    80202646:	0007871b          	sext.w	a4,a5
    8020264a:	03f00793          	li	a5,63
    8020264e:	00e7cd63          	blt	a5,a4,80202668 <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    80202652:	00005717          	auipc	a4,0x5
    80202656:	a6e70713          	addi	a4,a4,-1426 # 802070c0 <interrupt_vector>
    8020265a:	fec42783          	lw	a5,-20(s0)
    8020265e:	078e                	slli	a5,a5,0x3
    80202660:	97ba                	add	a5,a5,a4
    80202662:	fe043703          	ld	a4,-32(s0)
    80202666:	e398                	sd	a4,0(a5)
}
    80202668:	0001                	nop
    8020266a:	6462                	ld	s0,24(sp)
    8020266c:	6105                	addi	sp,sp,32
    8020266e:	8082                	ret

0000000080202670 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    80202670:	1101                	addi	sp,sp,-32
    80202672:	ec22                	sd	s0,24(sp)
    80202674:	1000                	addi	s0,sp,32
    80202676:	87aa                	mv	a5,a0
    80202678:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    8020267c:	fec42783          	lw	a5,-20(s0)
    80202680:	2781                	sext.w	a5,a5
    80202682:	0207c463          	bltz	a5,802026aa <unregister_interrupt+0x3a>
    80202686:	fec42783          	lw	a5,-20(s0)
    8020268a:	0007871b          	sext.w	a4,a5
    8020268e:	03f00793          	li	a5,63
    80202692:	00e7cc63          	blt	a5,a4,802026aa <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    80202696:	00005717          	auipc	a4,0x5
    8020269a:	a2a70713          	addi	a4,a4,-1494 # 802070c0 <interrupt_vector>
    8020269e:	fec42783          	lw	a5,-20(s0)
    802026a2:	078e                	slli	a5,a5,0x3
    802026a4:	97ba                	add	a5,a5,a4
    802026a6:	0007b023          	sd	zero,0(a5)
}
    802026aa:	0001                	nop
    802026ac:	6462                	ld	s0,24(sp)
    802026ae:	6105                	addi	sp,sp,32
    802026b0:	8082                	ret

00000000802026b2 <enable_interrupts>:
void enable_interrupts(int irq) {
    802026b2:	1101                	addi	sp,sp,-32
    802026b4:	ec06                	sd	ra,24(sp)
    802026b6:	e822                	sd	s0,16(sp)
    802026b8:	1000                	addi	s0,sp,32
    802026ba:	87aa                	mv	a5,a0
    802026bc:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    802026c0:	fec42783          	lw	a5,-20(s0)
    802026c4:	853e                	mv	a0,a5
    802026c6:	00001097          	auipc	ra,0x1
    802026ca:	c26080e7          	jalr	-986(ra) # 802032ec <plic_enable>
}
    802026ce:	0001                	nop
    802026d0:	60e2                	ld	ra,24(sp)
    802026d2:	6442                	ld	s0,16(sp)
    802026d4:	6105                	addi	sp,sp,32
    802026d6:	8082                	ret

00000000802026d8 <disable_interrupts>:
void disable_interrupts(int irq) {
    802026d8:	1101                	addi	sp,sp,-32
    802026da:	ec06                	sd	ra,24(sp)
    802026dc:	e822                	sd	s0,16(sp)
    802026de:	1000                	addi	s0,sp,32
    802026e0:	87aa                	mv	a5,a0
    802026e2:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    802026e6:	fec42783          	lw	a5,-20(s0)
    802026ea:	853e                	mv	a0,a5
    802026ec:	00001097          	auipc	ra,0x1
    802026f0:	c58080e7          	jalr	-936(ra) # 80203344 <plic_disable>
}
    802026f4:	0001                	nop
    802026f6:	60e2                	ld	ra,24(sp)
    802026f8:	6442                	ld	s0,16(sp)
    802026fa:	6105                	addi	sp,sp,32
    802026fc:	8082                	ret

00000000802026fe <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    802026fe:	1101                	addi	sp,sp,-32
    80202700:	ec06                	sd	ra,24(sp)
    80202702:	e822                	sd	s0,16(sp)
    80202704:	1000                	addi	s0,sp,32
    80202706:	87aa                	mv	a5,a0
    80202708:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    8020270c:	fec42783          	lw	a5,-20(s0)
    80202710:	2781                	sext.w	a5,a5
    80202712:	0207ce63          	bltz	a5,8020274e <interrupt_dispatch+0x50>
    80202716:	fec42783          	lw	a5,-20(s0)
    8020271a:	0007871b          	sext.w	a4,a5
    8020271e:	03f00793          	li	a5,63
    80202722:	02e7c663          	blt	a5,a4,8020274e <interrupt_dispatch+0x50>
    80202726:	00005717          	auipc	a4,0x5
    8020272a:	99a70713          	addi	a4,a4,-1638 # 802070c0 <interrupt_vector>
    8020272e:	fec42783          	lw	a5,-20(s0)
    80202732:	078e                	slli	a5,a5,0x3
    80202734:	97ba                	add	a5,a5,a4
    80202736:	639c                	ld	a5,0(a5)
    80202738:	cb99                	beqz	a5,8020274e <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    8020273a:	00005717          	auipc	a4,0x5
    8020273e:	98670713          	addi	a4,a4,-1658 # 802070c0 <interrupt_vector>
    80202742:	fec42783          	lw	a5,-20(s0)
    80202746:	078e                	slli	a5,a5,0x3
    80202748:	97ba                	add	a5,a5,a4
    8020274a:	639c                	ld	a5,0(a5)
    8020274c:	9782                	jalr	a5
}
    8020274e:	0001                	nop
    80202750:	60e2                	ld	ra,24(sp)
    80202752:	6442                	ld	s0,16(sp)
    80202754:	6105                	addi	sp,sp,32
    80202756:	8082                	ret

0000000080202758 <handle_external_interrupt>:
void handle_external_interrupt(void) {
    80202758:	1101                	addi	sp,sp,-32
    8020275a:	ec06                	sd	ra,24(sp)
    8020275c:	e822                	sd	s0,16(sp)
    8020275e:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    80202760:	00001097          	auipc	ra,0x1
    80202764:	c42080e7          	jalr	-958(ra) # 802033a2 <plic_claim>
    80202768:	87aa                	mv	a5,a0
    8020276a:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    8020276e:	fec42783          	lw	a5,-20(s0)
    80202772:	2781                	sext.w	a5,a5
    80202774:	eb91                	bnez	a5,80202788 <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    80202776:	00003517          	auipc	a0,0x3
    8020277a:	9b250513          	addi	a0,a0,-1614 # 80205128 <small_numbers+0xf60>
    8020277e:	ffffe097          	auipc	ra,0xffffe
    80202782:	dea080e7          	jalr	-534(ra) # 80200568 <printf>
        return;
    80202786:	a839                	j	802027a4 <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    80202788:	fec42783          	lw	a5,-20(s0)
    8020278c:	853e                	mv	a0,a5
    8020278e:	00000097          	auipc	ra,0x0
    80202792:	f70080e7          	jalr	-144(ra) # 802026fe <interrupt_dispatch>
    plic_complete(irq);
    80202796:	fec42783          	lw	a5,-20(s0)
    8020279a:	853e                	mv	a0,a5
    8020279c:	00001097          	auipc	ra,0x1
    802027a0:	c2e080e7          	jalr	-978(ra) # 802033ca <plic_complete>
}
    802027a4:	60e2                	ld	ra,24(sp)
    802027a6:	6442                	ld	s0,16(sp)
    802027a8:	6105                	addi	sp,sp,32
    802027aa:	8082                	ret

00000000802027ac <trap_init>:
void trap_init(void) {
    802027ac:	1101                	addi	sp,sp,-32
    802027ae:	ec06                	sd	ra,24(sp)
    802027b0:	e822                	sd	s0,16(sp)
    802027b2:	1000                	addi	s0,sp,32
	intr_off();
    802027b4:	00000097          	auipc	ra,0x0
    802027b8:	de4080e7          	jalr	-540(ra) # 80202598 <intr_off>
	printf("trap_init...\n");
    802027bc:	00003517          	auipc	a0,0x3
    802027c0:	98c50513          	addi	a0,a0,-1652 # 80205148 <small_numbers+0xf80>
    802027c4:	ffffe097          	auipc	ra,0xffffe
    802027c8:	da4080e7          	jalr	-604(ra) # 80200568 <printf>
	w_stvec((uint64)kernelvec);
    802027cc:	00001797          	auipc	a5,0x1
    802027d0:	c3478793          	addi	a5,a5,-972 # 80203400 <kernelvec>
    802027d4:	853e                	mv	a0,a5
    802027d6:	00000097          	auipc	ra,0x0
    802027da:	dea080e7          	jalr	-534(ra) # 802025c0 <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    802027de:	fe042623          	sw	zero,-20(s0)
    802027e2:	a005                	j	80202802 <trap_init+0x56>
		interrupt_vector[i] = 0;
    802027e4:	00005717          	auipc	a4,0x5
    802027e8:	8dc70713          	addi	a4,a4,-1828 # 802070c0 <interrupt_vector>
    802027ec:	fec42783          	lw	a5,-20(s0)
    802027f0:	078e                	slli	a5,a5,0x3
    802027f2:	97ba                	add	a5,a5,a4
    802027f4:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    802027f8:	fec42783          	lw	a5,-20(s0)
    802027fc:	2785                	addiw	a5,a5,1
    802027fe:	fef42623          	sw	a5,-20(s0)
    80202802:	fec42783          	lw	a5,-20(s0)
    80202806:	0007871b          	sext.w	a4,a5
    8020280a:	03f00793          	li	a5,63
    8020280e:	fce7dbe3          	bge	a5,a4,802027e4 <trap_init+0x38>
	plic_init();
    80202812:	00001097          	auipc	ra,0x1
    80202816:	a3c080e7          	jalr	-1476(ra) # 8020324e <plic_init>
    uint64 sie = r_sie();
    8020281a:	00000097          	auipc	ra,0x0
    8020281e:	cfc080e7          	jalr	-772(ra) # 80202516 <r_sie>
    80202822:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    80202826:	fe043783          	ld	a5,-32(s0)
    8020282a:	2207e793          	ori	a5,a5,544
    8020282e:	853e                	mv	a0,a5
    80202830:	00000097          	auipc	ra,0x0
    80202834:	d00080e7          	jalr	-768(ra) # 80202530 <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80202838:	00000097          	auipc	ra,0x0
    8020283c:	c96080e7          	jalr	-874(ra) # 802024ce <sbi_get_time>
    80202840:	872a                	mv	a4,a0
    80202842:	000f47b7          	lui	a5,0xf4
    80202846:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    8020284a:	97ba                	add	a5,a5,a4
    8020284c:	853e                	mv	a0,a5
    8020284e:	00000097          	auipc	ra,0x0
    80202852:	c64080e7          	jalr	-924(ra) # 802024b2 <sbi_set_time>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    80202856:	00000597          	auipc	a1,0x0
    8020285a:	50a58593          	addi	a1,a1,1290 # 80202d60 <handle_store_page_fault>
    8020285e:	00003517          	auipc	a0,0x3
    80202862:	8fa50513          	addi	a0,a0,-1798 # 80205158 <small_numbers+0xf90>
    80202866:	ffffe097          	auipc	ra,0xffffe
    8020286a:	d02080e7          	jalr	-766(ra) # 80200568 <printf>
	printf("trap_init complete.\n");
    8020286e:	00003517          	auipc	a0,0x3
    80202872:	92250513          	addi	a0,a0,-1758 # 80205190 <small_numbers+0xfc8>
    80202876:	ffffe097          	auipc	ra,0xffffe
    8020287a:	cf2080e7          	jalr	-782(ra) # 80200568 <printf>
}
    8020287e:	0001                	nop
    80202880:	60e2                	ld	ra,24(sp)
    80202882:	6442                	ld	s0,16(sp)
    80202884:	6105                	addi	sp,sp,32
    80202886:	8082                	ret

0000000080202888 <kerneltrap>:
// 中断和异常处理函数
void kerneltrap(void) {
    80202888:	714d                	addi	sp,sp,-336
    8020288a:	e686                	sd	ra,328(sp)
    8020288c:	e2a2                	sd	s0,320(sp)
    8020288e:	0a80                	addi	s0,sp,336
    // 保存当前中断状态
    uint64 sstatus = r_sstatus();
    80202890:	00000097          	auipc	ra,0x0
    80202894:	cba080e7          	jalr	-838(ra) # 8020254a <r_sstatus>
    80202898:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    8020289c:	00000097          	auipc	ra,0x0
    802028a0:	d3e080e7          	jalr	-706(ra) # 802025da <r_scause>
    802028a4:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    802028a8:	00000097          	auipc	ra,0x0
    802028ac:	d4c080e7          	jalr	-692(ra) # 802025f4 <r_sepc>
    802028b0:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    802028b4:	00000097          	auipc	ra,0x0
    802028b8:	d5a080e7          	jalr	-678(ra) # 8020260e <r_stval>
    802028bc:	fca43823          	sd	a0,-48(s0)
    
    // 检查是否为中断（最高位为1表示中断）
    if(scause & 0x8000000000000000) {
    802028c0:	fd843783          	ld	a5,-40(s0)
    802028c4:	0607d663          	bgez	a5,80202930 <kerneltrap+0xa8>
        // 处理中断
        if((scause & 0xff) == 5) {
    802028c8:	fd843783          	ld	a5,-40(s0)
    802028cc:	0ff7f713          	zext.b	a4,a5
    802028d0:	4795                	li	a5,5
    802028d2:	02f71663          	bne	a4,a5,802028fe <kerneltrap+0x76>
            // 时钟中断
            timeintr();
    802028d6:	00000097          	auipc	ra,0x0
    802028da:	c12080e7          	jalr	-1006(ra) # 802024e8 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802028de:	00000097          	auipc	ra,0x0
    802028e2:	bf0080e7          	jalr	-1040(ra) # 802024ce <sbi_get_time>
    802028e6:	872a                	mv	a4,a0
    802028e8:	000f47b7          	lui	a5,0xf4
    802028ec:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802028f0:	97ba                	add	a5,a5,a4
    802028f2:	853e                	mv	a0,a5
    802028f4:	00000097          	auipc	ra,0x0
    802028f8:	bbe080e7          	jalr	-1090(ra) # 802024b2 <sbi_set_time>
    802028fc:	a059                	j	80202982 <kerneltrap+0xfa>
        } else if((scause & 0xff) == 9) {
    802028fe:	fd843783          	ld	a5,-40(s0)
    80202902:	0ff7f713          	zext.b	a4,a5
    80202906:	47a5                	li	a5,9
    80202908:	00f71763          	bne	a4,a5,80202916 <kerneltrap+0x8e>
            // 外部中断
            handle_external_interrupt();
    8020290c:	00000097          	auipc	ra,0x0
    80202910:	e4c080e7          	jalr	-436(ra) # 80202758 <handle_external_interrupt>
    80202914:	a0bd                	j	80202982 <kerneltrap+0xfa>
        } else {
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    80202916:	fe843603          	ld	a2,-24(s0)
    8020291a:	fd843583          	ld	a1,-40(s0)
    8020291e:	00003517          	auipc	a0,0x3
    80202922:	88a50513          	addi	a0,a0,-1910 # 802051a8 <small_numbers+0xfe0>
    80202926:	ffffe097          	auipc	ra,0xffffe
    8020292a:	c42080e7          	jalr	-958(ra) # 80200568 <printf>
    8020292e:	a891                	j	80202982 <kerneltrap+0xfa>
        }
    } else {
        // 处理异常（最高位为0）
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    80202930:	fd043683          	ld	a3,-48(s0)
    80202934:	fe843603          	ld	a2,-24(s0)
    80202938:	fd843583          	ld	a1,-40(s0)
    8020293c:	00003517          	auipc	a0,0x3
    80202940:	8a450513          	addi	a0,a0,-1884 # 802051e0 <small_numbers+0x1018>
    80202944:	ffffe097          	auipc	ra,0xffffe
    80202948:	c24080e7          	jalr	-988(ra) # 80200568 <printf>
        
        // 构造trapframe结构
        struct trapframe tf;
        tf.sepc = sepc;
    8020294c:	fe843783          	ld	a5,-24(s0)
    80202950:	faf43823          	sd	a5,-80(s0)
        tf.sstatus = sstatus;
    80202954:	fe043783          	ld	a5,-32(s0)
    80202958:	faf43c23          	sd	a5,-72(s0)
        tf.scause = scause;
    8020295c:	fd843783          	ld	a5,-40(s0)
    80202960:	fcf43023          	sd	a5,-64(s0)
        tf.stval = stval;
    80202964:	fd043783          	ld	a5,-48(s0)
    80202968:	fcf43423          	sd	a5,-56(s0)
        
        // 调用异常处理函数
        handle_exception(&tf);
    8020296c:	eb840793          	addi	a5,s0,-328
    80202970:	853e                	mv	a0,a5
    80202972:	00000097          	auipc	ra,0x0
    80202976:	032080e7          	jalr	50(ra) # 802029a4 <handle_exception>
		sepc = tf.sepc; // 更新sepc
    8020297a:	fb043783          	ld	a5,-80(s0)
    8020297e:	fef43423          	sd	a5,-24(s0)
    }
    
    // 恢复中断现场
    w_sepc(sepc);
    80202982:	fe843503          	ld	a0,-24(s0)
    80202986:	00000097          	auipc	ra,0x0
    8020298a:	bf8080e7          	jalr	-1032(ra) # 8020257e <w_sepc>
    w_sstatus(sstatus);
    8020298e:	fe043503          	ld	a0,-32(s0)
    80202992:	00000097          	auipc	ra,0x0
    80202996:	bd2080e7          	jalr	-1070(ra) # 80202564 <w_sstatus>
}
    8020299a:	0001                	nop
    8020299c:	60b6                	ld	ra,328(sp)
    8020299e:	6416                	ld	s0,320(sp)
    802029a0:	6171                	addi	sp,sp,336
    802029a2:	8082                	ret

00000000802029a4 <handle_exception>:
// 处理异常
void handle_exception(struct trapframe *tf) {
    802029a4:	7179                	addi	sp,sp,-48
    802029a6:	f406                	sd	ra,40(sp)
    802029a8:	f022                	sd	s0,32(sp)
    802029aa:	1800                	addi	s0,sp,48
    802029ac:	fca43c23          	sd	a0,-40(s0)
    uint64 cause = tf->scause;
    802029b0:	fd843783          	ld	a5,-40(s0)
    802029b4:	1087b783          	ld	a5,264(a5)
    802029b8:	fef43423          	sd	a5,-24(s0)
    
    switch (cause) {
    802029bc:	fe843703          	ld	a4,-24(s0)
    802029c0:	47bd                	li	a5,15
    802029c2:	24e7e763          	bltu	a5,a4,80202c10 <handle_exception+0x26c>
    802029c6:	fe843783          	ld	a5,-24(s0)
    802029ca:	00279713          	slli	a4,a5,0x2
    802029ce:	00003797          	auipc	a5,0x3
    802029d2:	9ce78793          	addi	a5,a5,-1586 # 8020539c <small_numbers+0x11d4>
    802029d6:	97ba                	add	a5,a5,a4
    802029d8:	439c                	lw	a5,0(a5)
    802029da:	0007871b          	sext.w	a4,a5
    802029de:	00003797          	auipc	a5,0x3
    802029e2:	9be78793          	addi	a5,a5,-1602 # 8020539c <small_numbers+0x11d4>
    802029e6:	97ba                	add	a5,a5,a4
    802029e8:	8782                	jr	a5
        case 0:  // 指令地址未对齐
            printf("Instruction address misaligned: 0x%lx\n", tf->stval);
    802029ea:	fd843783          	ld	a5,-40(s0)
    802029ee:	1107b783          	ld	a5,272(a5)
    802029f2:	85be                	mv	a1,a5
    802029f4:	00003517          	auipc	a0,0x3
    802029f8:	81c50513          	addi	a0,a0,-2020 # 80205210 <small_numbers+0x1048>
    802029fc:	ffffe097          	auipc	ra,0xffffe
    80202a00:	b6c080e7          	jalr	-1172(ra) # 80200568 <printf>
			tf->sepc += 4; 
    80202a04:	fd843783          	ld	a5,-40(s0)
    80202a08:	7ffc                	ld	a5,248(a5)
    80202a0a:	00478713          	addi	a4,a5,4
    80202a0e:	fd843783          	ld	a5,-40(s0)
    80202a12:	fff8                	sd	a4,248(a5)
            break;
    80202a14:	ac2d                	j	80202c4e <handle_exception+0x2aa>
            
        case 1:  // 指令访问故障
            printf("Instruction access fault: 0x%lx\n", tf->stval);
    80202a16:	fd843783          	ld	a5,-40(s0)
    80202a1a:	1107b783          	ld	a5,272(a5)
    80202a1e:	85be                	mv	a1,a5
    80202a20:	00003517          	auipc	a0,0x3
    80202a24:	81850513          	addi	a0,a0,-2024 # 80205238 <small_numbers+0x1070>
    80202a28:	ffffe097          	auipc	ra,0xffffe
    80202a2c:	b40080e7          	jalr	-1216(ra) # 80200568 <printf>
			tf->sepc += 4; 
    80202a30:	fd843783          	ld	a5,-40(s0)
    80202a34:	7ffc                	ld	a5,248(a5)
    80202a36:	00478713          	addi	a4,a5,4
    80202a3a:	fd843783          	ld	a5,-40(s0)
    80202a3e:	fff8                	sd	a4,248(a5)
            break;
    80202a40:	a439                	j	80202c4e <handle_exception+0x2aa>
            
        case 2:  // 非法指令
            printf("Illegal instruction at 0x%lx: 0x%lx\n", tf->sepc, tf->stval);
    80202a42:	fd843783          	ld	a5,-40(s0)
    80202a46:	7ff8                	ld	a4,248(a5)
    80202a48:	fd843783          	ld	a5,-40(s0)
    80202a4c:	1107b783          	ld	a5,272(a5)
    80202a50:	863e                	mv	a2,a5
    80202a52:	85ba                	mv	a1,a4
    80202a54:	00003517          	auipc	a0,0x3
    80202a58:	80c50513          	addi	a0,a0,-2036 # 80205260 <small_numbers+0x1098>
    80202a5c:	ffffe097          	auipc	ra,0xffffe
    80202a60:	b0c080e7          	jalr	-1268(ra) # 80200568 <printf>
			tf->sepc += 4; 
    80202a64:	fd843783          	ld	a5,-40(s0)
    80202a68:	7ffc                	ld	a5,248(a5)
    80202a6a:	00478713          	addi	a4,a5,4
    80202a6e:	fd843783          	ld	a5,-40(s0)
    80202a72:	fff8                	sd	a4,248(a5)
            break;
    80202a74:	aae9                	j	80202c4e <handle_exception+0x2aa>
            
        case 3:  // 断点
            printf("Breakpoint at 0x%lx\n", tf->sepc);
    80202a76:	fd843783          	ld	a5,-40(s0)
    80202a7a:	7ffc                	ld	a5,248(a5)
    80202a7c:	85be                	mv	a1,a5
    80202a7e:	00003517          	auipc	a0,0x3
    80202a82:	80a50513          	addi	a0,a0,-2038 # 80205288 <small_numbers+0x10c0>
    80202a86:	ffffe097          	auipc	ra,0xffffe
    80202a8a:	ae2080e7          	jalr	-1310(ra) # 80200568 <printf>
            tf->sepc += 4;
    80202a8e:	fd843783          	ld	a5,-40(s0)
    80202a92:	7ffc                	ld	a5,248(a5)
    80202a94:	00478713          	addi	a4,a5,4
    80202a98:	fd843783          	ld	a5,-40(s0)
    80202a9c:	fff8                	sd	a4,248(a5)
            break;
    80202a9e:	aa45                	j	80202c4e <handle_exception+0x2aa>
            
        case 4:  // 加载地址未对齐
            printf("Load address misaligned: 0x%lx\n", tf->stval);
    80202aa0:	fd843783          	ld	a5,-40(s0)
    80202aa4:	1107b783          	ld	a5,272(a5)
    80202aa8:	85be                	mv	a1,a5
    80202aaa:	00002517          	auipc	a0,0x2
    80202aae:	7f650513          	addi	a0,a0,2038 # 802052a0 <small_numbers+0x10d8>
    80202ab2:	ffffe097          	auipc	ra,0xffffe
    80202ab6:	ab6080e7          	jalr	-1354(ra) # 80200568 <printf>
			tf->sepc += 4; 
    80202aba:	fd843783          	ld	a5,-40(s0)
    80202abe:	7ffc                	ld	a5,248(a5)
    80202ac0:	00478713          	addi	a4,a5,4
    80202ac4:	fd843783          	ld	a5,-40(s0)
    80202ac8:	fff8                	sd	a4,248(a5)
            break;
    80202aca:	a251                	j	80202c4e <handle_exception+0x2aa>
            
		case 5:  // 加载访问故障
			printf("Load access fault: 0x%lx\n", tf->stval);
    80202acc:	fd843783          	ld	a5,-40(s0)
    80202ad0:	1107b783          	ld	a5,272(a5)
    80202ad4:	85be                	mv	a1,a5
    80202ad6:	00002517          	auipc	a0,0x2
    80202ada:	7ea50513          	addi	a0,a0,2026 # 802052c0 <small_numbers+0x10f8>
    80202ade:	ffffe097          	auipc	ra,0xffffe
    80202ae2:	a8a080e7          	jalr	-1398(ra) # 80200568 <printf>
			// 尝试先增加页权限
			if (check_is_mapped(tf->stval) && handle_page_fault(tf->stval, 2)) {
    80202ae6:	fd843783          	ld	a5,-40(s0)
    80202aea:	1107b783          	ld	a5,272(a5)
    80202aee:	853e                	mv	a0,a5
    80202af0:	fffff097          	auipc	ra,0xfffff
    80202af4:	5fc080e7          	jalr	1532(ra) # 802020ec <check_is_mapped>
    80202af8:	87aa                	mv	a5,a0
    80202afa:	cf91                	beqz	a5,80202b16 <handle_exception+0x172>
    80202afc:	fd843783          	ld	a5,-40(s0)
    80202b00:	1107b783          	ld	a5,272(a5)
    80202b04:	4589                	li	a1,2
    80202b06:	853e                	mv	a0,a5
    80202b08:	fffff097          	auipc	ra,0xfffff
    80202b0c:	1b6080e7          	jalr	438(ra) # 80201cbe <handle_page_fault>
    80202b10:	87aa                	mv	a5,a0
    80202b12:	12079b63          	bnez	a5,80202c48 <handle_exception+0x2a4>
				return; // 成功处理
			}
			// 如果无法处理或不是权限问题，则跳过错误指令
			tf->sepc += 4;
    80202b16:	fd843783          	ld	a5,-40(s0)
    80202b1a:	7ffc                	ld	a5,248(a5)
    80202b1c:	00478713          	addi	a4,a5,4
    80202b20:	fd843783          	ld	a5,-40(s0)
    80202b24:	fff8                	sd	a4,248(a5)
			break;
    80202b26:	a225                	j	80202c4e <handle_exception+0x2aa>
            
        case 6:  // 存储地址未对齐
            printf("Store address misaligned: 0x%lx\n", tf->stval);
    80202b28:	fd843783          	ld	a5,-40(s0)
    80202b2c:	1107b783          	ld	a5,272(a5)
    80202b30:	85be                	mv	a1,a5
    80202b32:	00002517          	auipc	a0,0x2
    80202b36:	7ae50513          	addi	a0,a0,1966 # 802052e0 <small_numbers+0x1118>
    80202b3a:	ffffe097          	auipc	ra,0xffffe
    80202b3e:	a2e080e7          	jalr	-1490(ra) # 80200568 <printf>
			tf->sepc += 4; 
    80202b42:	fd843783          	ld	a5,-40(s0)
    80202b46:	7ffc                	ld	a5,248(a5)
    80202b48:	00478713          	addi	a4,a5,4
    80202b4c:	fd843783          	ld	a5,-40(s0)
    80202b50:	fff8                	sd	a4,248(a5)
            break;
    80202b52:	a8f5                	j	80202c4e <handle_exception+0x2aa>
            
		case 7:  // 存储访问故障
			printf("Store access fault: 0x%lx\n", tf->stval);
    80202b54:	fd843783          	ld	a5,-40(s0)
    80202b58:	1107b783          	ld	a5,272(a5)
    80202b5c:	85be                	mv	a1,a5
    80202b5e:	00002517          	auipc	a0,0x2
    80202b62:	7aa50513          	addi	a0,a0,1962 # 80205308 <small_numbers+0x1140>
    80202b66:	ffffe097          	auipc	ra,0xffffe
    80202b6a:	a02080e7          	jalr	-1534(ra) # 80200568 <printf>
			// 尝试先增加页权限
			if (check_is_mapped(tf->stval) && handle_page_fault(tf->stval, 3)) {
    80202b6e:	fd843783          	ld	a5,-40(s0)
    80202b72:	1107b783          	ld	a5,272(a5)
    80202b76:	853e                	mv	a0,a5
    80202b78:	fffff097          	auipc	ra,0xfffff
    80202b7c:	574080e7          	jalr	1396(ra) # 802020ec <check_is_mapped>
    80202b80:	87aa                	mv	a5,a0
    80202b82:	cf89                	beqz	a5,80202b9c <handle_exception+0x1f8>
    80202b84:	fd843783          	ld	a5,-40(s0)
    80202b88:	1107b783          	ld	a5,272(a5)
    80202b8c:	458d                	li	a1,3
    80202b8e:	853e                	mv	a0,a5
    80202b90:	fffff097          	auipc	ra,0xfffff
    80202b94:	12e080e7          	jalr	302(ra) # 80201cbe <handle_page_fault>
    80202b98:	87aa                	mv	a5,a0
    80202b9a:	ebcd                	bnez	a5,80202c4c <handle_exception+0x2a8>
				return; // 成功处理
			}
			// 如果无法处理或不是权限问题，则跳过错误指令
			tf->sepc += 4;
    80202b9c:	fd843783          	ld	a5,-40(s0)
    80202ba0:	7ffc                	ld	a5,248(a5)
    80202ba2:	00478713          	addi	a4,a5,4
    80202ba6:	fd843783          	ld	a5,-40(s0)
    80202baa:	fff8                	sd	a4,248(a5)
			break;
    80202bac:	a04d                	j	80202c4e <handle_exception+0x2aa>
            
        case 8:  // 用户模式环境调用
            handle_syscall(tf);
    80202bae:	fd843503          	ld	a0,-40(s0)
    80202bb2:	00000097          	auipc	ra,0x0
    80202bb6:	0a4080e7          	jalr	164(ra) # 80202c56 <handle_syscall>
            break;
    80202bba:	a851                	j	80202c4e <handle_exception+0x2aa>
            
        case 9:  // 监督模式环境调用
            printf("Supervisor environment call at 0x%lx\n", tf->sepc);
    80202bbc:	fd843783          	ld	a5,-40(s0)
    80202bc0:	7ffc                	ld	a5,248(a5)
    80202bc2:	85be                	mv	a1,a5
    80202bc4:	00002517          	auipc	a0,0x2
    80202bc8:	76450513          	addi	a0,a0,1892 # 80205328 <small_numbers+0x1160>
    80202bcc:	ffffe097          	auipc	ra,0xffffe
    80202bd0:	99c080e7          	jalr	-1636(ra) # 80200568 <printf>
			tf->sepc += 4; 
    80202bd4:	fd843783          	ld	a5,-40(s0)
    80202bd8:	7ffc                	ld	a5,248(a5)
    80202bda:	00478713          	addi	a4,a5,4
    80202bde:	fd843783          	ld	a5,-40(s0)
    80202be2:	fff8                	sd	a4,248(a5)
            break;
    80202be4:	a0ad                	j	80202c4e <handle_exception+0x2aa>
            
        case 12:  // 指令页故障
            handle_instruction_page_fault(tf);
    80202be6:	fd843503          	ld	a0,-40(s0)
    80202bea:	00000097          	auipc	ra,0x0
    80202bee:	0b2080e7          	jalr	178(ra) # 80202c9c <handle_instruction_page_fault>
            break;
    80202bf2:	a8b1                	j	80202c4e <handle_exception+0x2aa>
            
        case 13:  // 加载页故障
            handle_load_page_fault(tf);
    80202bf4:	fd843503          	ld	a0,-40(s0)
    80202bf8:	00000097          	auipc	ra,0x0
    80202bfc:	106080e7          	jalr	262(ra) # 80202cfe <handle_load_page_fault>
            break;
    80202c00:	a0b9                	j	80202c4e <handle_exception+0x2aa>
            
        case 15:  // 存储页故障
            handle_store_page_fault(tf);
    80202c02:	fd843503          	ld	a0,-40(s0)
    80202c06:	00000097          	auipc	ra,0x0
    80202c0a:	15a080e7          	jalr	346(ra) # 80202d60 <handle_store_page_fault>
            break;
    80202c0e:	a081                	j	80202c4e <handle_exception+0x2aa>
            
        default:
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    80202c10:	fd843783          	ld	a5,-40(s0)
    80202c14:	7ff8                	ld	a4,248(a5)
    80202c16:	fd843783          	ld	a5,-40(s0)
    80202c1a:	1107b783          	ld	a5,272(a5)
    80202c1e:	86be                	mv	a3,a5
    80202c20:	863a                	mv	a2,a4
    80202c22:	fe843583          	ld	a1,-24(s0)
    80202c26:	00002517          	auipc	a0,0x2
    80202c2a:	72a50513          	addi	a0,a0,1834 # 80205350 <small_numbers+0x1188>
    80202c2e:	ffffe097          	auipc	ra,0xffffe
    80202c32:	93a080e7          	jalr	-1734(ra) # 80200568 <printf>
                   cause, tf->sepc, tf->stval);
            panic("Unknown exception");
    80202c36:	00002517          	auipc	a0,0x2
    80202c3a:	75250513          	addi	a0,a0,1874 # 80205388 <small_numbers+0x11c0>
    80202c3e:	ffffe097          	auipc	ra,0xffffe
    80202c42:	232080e7          	jalr	562(ra) # 80200e70 <panic>
            break;
    80202c46:	a021                	j	80202c4e <handle_exception+0x2aa>
				return; // 成功处理
    80202c48:	0001                	nop
    80202c4a:	a011                	j	80202c4e <handle_exception+0x2aa>
				return; // 成功处理
    80202c4c:	0001                	nop
    }
}
    80202c4e:	70a2                	ld	ra,40(sp)
    80202c50:	7402                	ld	s0,32(sp)
    80202c52:	6145                	addi	sp,sp,48
    80202c54:	8082                	ret

0000000080202c56 <handle_syscall>:
// 处理系统调用
void handle_syscall(struct trapframe *tf) {
    80202c56:	1101                	addi	sp,sp,-32
    80202c58:	ec06                	sd	ra,24(sp)
    80202c5a:	e822                	sd	s0,16(sp)
    80202c5c:	1000                	addi	s0,sp,32
    80202c5e:	fea43423          	sd	a0,-24(s0)
    printf("System call from sepc=0x%lx, syscall number=%ld\n", tf->sepc, tf->a7);
    80202c62:	fe843783          	ld	a5,-24(s0)
    80202c66:	7ff8                	ld	a4,248(a5)
    80202c68:	fe843783          	ld	a5,-24(s0)
    80202c6c:	63dc                	ld	a5,128(a5)
    80202c6e:	863e                	mv	a2,a5
    80202c70:	85ba                	mv	a1,a4
    80202c72:	00002517          	auipc	a0,0x2
    80202c76:	76e50513          	addi	a0,a0,1902 # 802053e0 <small_numbers+0x1218>
    80202c7a:	ffffe097          	auipc	ra,0xffffe
    80202c7e:	8ee080e7          	jalr	-1810(ra) # 80200568 <printf>
    
    // 系统调用返回值存放在a0寄存器
    // tf->a0 = sys_call(tf->a7, tf->a0, tf->a1, tf->a2, tf->a3, tf->a4, tf->a5);
    
    // 系统调用完成后，sepc应该指向下一条指令
    tf->sepc += 4;
    80202c82:	fe843783          	ld	a5,-24(s0)
    80202c86:	7ffc                	ld	a5,248(a5)
    80202c88:	00478713          	addi	a4,a5,4
    80202c8c:	fe843783          	ld	a5,-24(s0)
    80202c90:	fff8                	sd	a4,248(a5)
}
    80202c92:	0001                	nop
    80202c94:	60e2                	ld	ra,24(sp)
    80202c96:	6442                	ld	s0,16(sp)
    80202c98:	6105                	addi	sp,sp,32
    80202c9a:	8082                	ret

0000000080202c9c <handle_instruction_page_fault>:


// 处理指令页故障
void handle_instruction_page_fault(struct trapframe *tf) {
    80202c9c:	1101                	addi	sp,sp,-32
    80202c9e:	ec06                	sd	ra,24(sp)
    80202ca0:	e822                	sd	s0,16(sp)
    80202ca2:	1000                	addi	s0,sp,32
    80202ca4:	fea43423          	sd	a0,-24(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", tf->stval, tf->sepc);
    80202ca8:	fe843783          	ld	a5,-24(s0)
    80202cac:	1107b703          	ld	a4,272(a5)
    80202cb0:	fe843783          	ld	a5,-24(s0)
    80202cb4:	7ffc                	ld	a5,248(a5)
    80202cb6:	863e                	mv	a2,a5
    80202cb8:	85ba                	mv	a1,a4
    80202cba:	00002517          	auipc	a0,0x2
    80202cbe:	75e50513          	addi	a0,a0,1886 # 80205418 <small_numbers+0x1250>
    80202cc2:	ffffe097          	auipc	ra,0xffffe
    80202cc6:	8a6080e7          	jalr	-1882(ra) # 80200568 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(tf->stval, 1)) {  // 1表示指令页
    80202cca:	fe843783          	ld	a5,-24(s0)
    80202cce:	1107b783          	ld	a5,272(a5)
    80202cd2:	4585                	li	a1,1
    80202cd4:	853e                	mv	a0,a5
    80202cd6:	fffff097          	auipc	ra,0xfffff
    80202cda:	fe8080e7          	jalr	-24(ra) # 80201cbe <handle_page_fault>
    80202cde:	87aa                	mv	a5,a0
    80202ce0:	eb91                	bnez	a5,80202cf4 <handle_instruction_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled instruction page fault");
    80202ce2:	00002517          	auipc	a0,0x2
    80202ce6:	76650513          	addi	a0,a0,1894 # 80205448 <small_numbers+0x1280>
    80202cea:	ffffe097          	auipc	ra,0xffffe
    80202cee:	186080e7          	jalr	390(ra) # 80200e70 <panic>
    80202cf2:	a011                	j	80202cf6 <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80202cf4:	0001                	nop
}
    80202cf6:	60e2                	ld	ra,24(sp)
    80202cf8:	6442                	ld	s0,16(sp)
    80202cfa:	6105                	addi	sp,sp,32
    80202cfc:	8082                	ret

0000000080202cfe <handle_load_page_fault>:

// 处理加载页故障
void handle_load_page_fault(struct trapframe *tf) {
    80202cfe:	1101                	addi	sp,sp,-32
    80202d00:	ec06                	sd	ra,24(sp)
    80202d02:	e822                	sd	s0,16(sp)
    80202d04:	1000                	addi	s0,sp,32
    80202d06:	fea43423          	sd	a0,-24(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", tf->stval, tf->sepc);
    80202d0a:	fe843783          	ld	a5,-24(s0)
    80202d0e:	1107b703          	ld	a4,272(a5)
    80202d12:	fe843783          	ld	a5,-24(s0)
    80202d16:	7ffc                	ld	a5,248(a5)
    80202d18:	863e                	mv	a2,a5
    80202d1a:	85ba                	mv	a1,a4
    80202d1c:	00002517          	auipc	a0,0x2
    80202d20:	75450513          	addi	a0,a0,1876 # 80205470 <small_numbers+0x12a8>
    80202d24:	ffffe097          	auipc	ra,0xffffe
    80202d28:	844080e7          	jalr	-1980(ra) # 80200568 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(tf->stval, 2)) {  // 2表示读数据页
    80202d2c:	fe843783          	ld	a5,-24(s0)
    80202d30:	1107b783          	ld	a5,272(a5)
    80202d34:	4589                	li	a1,2
    80202d36:	853e                	mv	a0,a5
    80202d38:	fffff097          	auipc	ra,0xfffff
    80202d3c:	f86080e7          	jalr	-122(ra) # 80201cbe <handle_page_fault>
    80202d40:	87aa                	mv	a5,a0
    80202d42:	eb91                	bnez	a5,80202d56 <handle_load_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled load page fault");
    80202d44:	00002517          	auipc	a0,0x2
    80202d48:	75c50513          	addi	a0,a0,1884 # 802054a0 <small_numbers+0x12d8>
    80202d4c:	ffffe097          	auipc	ra,0xffffe
    80202d50:	124080e7          	jalr	292(ra) # 80200e70 <panic>
    80202d54:	a011                	j	80202d58 <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80202d56:	0001                	nop
}
    80202d58:	60e2                	ld	ra,24(sp)
    80202d5a:	6442                	ld	s0,16(sp)
    80202d5c:	6105                	addi	sp,sp,32
    80202d5e:	8082                	ret

0000000080202d60 <handle_store_page_fault>:

// 处理存储页故障
void handle_store_page_fault(struct trapframe *tf) {
    80202d60:	1101                	addi	sp,sp,-32
    80202d62:	ec06                	sd	ra,24(sp)
    80202d64:	e822                	sd	s0,16(sp)
    80202d66:	1000                	addi	s0,sp,32
    80202d68:	fea43423          	sd	a0,-24(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", tf->stval, tf->sepc);
    80202d6c:	fe843783          	ld	a5,-24(s0)
    80202d70:	1107b703          	ld	a4,272(a5)
    80202d74:	fe843783          	ld	a5,-24(s0)
    80202d78:	7ffc                	ld	a5,248(a5)
    80202d7a:	863e                	mv	a2,a5
    80202d7c:	85ba                	mv	a1,a4
    80202d7e:	00002517          	auipc	a0,0x2
    80202d82:	74250513          	addi	a0,a0,1858 # 802054c0 <small_numbers+0x12f8>
    80202d86:	ffffd097          	auipc	ra,0xffffd
    80202d8a:	7e2080e7          	jalr	2018(ra) # 80200568 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(tf->stval, 3)) {  // 3表示写数据页
    80202d8e:	fe843783          	ld	a5,-24(s0)
    80202d92:	1107b783          	ld	a5,272(a5)
    80202d96:	458d                	li	a1,3
    80202d98:	853e                	mv	a0,a5
    80202d9a:	fffff097          	auipc	ra,0xfffff
    80202d9e:	f24080e7          	jalr	-220(ra) # 80201cbe <handle_page_fault>
    80202da2:	87aa                	mv	a5,a0
    80202da4:	eb91                	bnez	a5,80202db8 <handle_store_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled store page fault");
    80202da6:	00002517          	auipc	a0,0x2
    80202daa:	74a50513          	addi	a0,a0,1866 # 802054f0 <small_numbers+0x1328>
    80202dae:	ffffe097          	auipc	ra,0xffffe
    80202db2:	0c2080e7          	jalr	194(ra) # 80200e70 <panic>
    80202db6:	a011                	j	80202dba <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80202db8:	0001                	nop
}
    80202dba:	60e2                	ld	ra,24(sp)
    80202dbc:	6442                	ld	s0,16(sp)
    80202dbe:	6105                	addi	sp,sp,32
    80202dc0:	8082                	ret

0000000080202dc2 <get_time>:
// 获取当前时间的辅助函数
uint64 get_time(void) {
    80202dc2:	1141                	addi	sp,sp,-16
    80202dc4:	e406                	sd	ra,8(sp)
    80202dc6:	e022                	sd	s0,0(sp)
    80202dc8:	0800                	addi	s0,sp,16
    return sbi_get_time();
    80202dca:	fffff097          	auipc	ra,0xfffff
    80202dce:	704080e7          	jalr	1796(ra) # 802024ce <sbi_get_time>
    80202dd2:	87aa                	mv	a5,a0
}
    80202dd4:	853e                	mv	a0,a5
    80202dd6:	60a2                	ld	ra,8(sp)
    80202dd8:	6402                	ld	s0,0(sp)
    80202dda:	0141                	addi	sp,sp,16
    80202ddc:	8082                	ret

0000000080202dde <test_timer_interrupt>:

// 时钟中断测试函数
void test_timer_interrupt(void) {
    80202dde:	7179                	addi	sp,sp,-48
    80202de0:	f406                	sd	ra,40(sp)
    80202de2:	f022                	sd	s0,32(sp)
    80202de4:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    80202de6:	00002517          	auipc	a0,0x2
    80202dea:	72a50513          	addi	a0,a0,1834 # 80205510 <small_numbers+0x1348>
    80202dee:	ffffd097          	auipc	ra,0xffffd
    80202df2:	77a080e7          	jalr	1914(ra) # 80200568 <printf>

    // 记录中断前的时间
    uint64 start_time = get_time();
    80202df6:	00000097          	auipc	ra,0x0
    80202dfa:	fcc080e7          	jalr	-52(ra) # 80202dc2 <get_time>
    80202dfe:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    80202e02:	fc042a23          	sw	zero,-44(s0)
	int last_count = interrupt_count;
    80202e06:	fd442783          	lw	a5,-44(s0)
    80202e0a:	fef42623          	sw	a5,-20(s0)
    // 设置测试标志
    interrupt_test_flag = &interrupt_count;
    80202e0e:	00004797          	auipc	a5,0x4
    80202e12:	21a78793          	addi	a5,a5,538 # 80207028 <interrupt_test_flag>
    80202e16:	fd440713          	addi	a4,s0,-44
    80202e1a:	e398                	sd	a4,0(a5)

    // 等待几次中断
    while (interrupt_count < 5) {
    80202e1c:	a899                	j	80202e72 <test_timer_interrupt+0x94>
        if(last_count != interrupt_count) {
    80202e1e:	fd442703          	lw	a4,-44(s0)
    80202e22:	fec42783          	lw	a5,-20(s0)
    80202e26:	2781                	sext.w	a5,a5
    80202e28:	02e78163          	beq	a5,a4,80202e4a <test_timer_interrupt+0x6c>
			last_count = interrupt_count;
    80202e2c:	fd442783          	lw	a5,-44(s0)
    80202e30:	fef42623          	sw	a5,-20(s0)
			printf("Received interrupt %d\n", interrupt_count);
    80202e34:	fd442783          	lw	a5,-44(s0)
    80202e38:	85be                	mv	a1,a5
    80202e3a:	00002517          	auipc	a0,0x2
    80202e3e:	6f650513          	addi	a0,a0,1782 # 80205530 <small_numbers+0x1368>
    80202e42:	ffffd097          	auipc	ra,0xffffd
    80202e46:	726080e7          	jalr	1830(ra) # 80200568 <printf>
		}
        // 简单延时
        for (volatile int i = 0; i < 1000000; i++);
    80202e4a:	fc042823          	sw	zero,-48(s0)
    80202e4e:	a801                	j	80202e5e <test_timer_interrupt+0x80>
    80202e50:	fd042783          	lw	a5,-48(s0)
    80202e54:	2781                	sext.w	a5,a5
    80202e56:	2785                	addiw	a5,a5,1
    80202e58:	2781                	sext.w	a5,a5
    80202e5a:	fcf42823          	sw	a5,-48(s0)
    80202e5e:	fd042783          	lw	a5,-48(s0)
    80202e62:	2781                	sext.w	a5,a5
    80202e64:	873e                	mv	a4,a5
    80202e66:	000f47b7          	lui	a5,0xf4
    80202e6a:	23f78793          	addi	a5,a5,575 # f423f <_entry-0x8010bdc1>
    80202e6e:	fee7d1e3          	bge	a5,a4,80202e50 <test_timer_interrupt+0x72>
    while (interrupt_count < 5) {
    80202e72:	fd442783          	lw	a5,-44(s0)
    80202e76:	873e                	mv	a4,a5
    80202e78:	4791                	li	a5,4
    80202e7a:	fae7d2e3          	bge	a5,a4,80202e1e <test_timer_interrupt+0x40>
    }

    // 测试结束，清除标志
    interrupt_test_flag = 0;
    80202e7e:	00004797          	auipc	a5,0x4
    80202e82:	1aa78793          	addi	a5,a5,426 # 80207028 <interrupt_test_flag>
    80202e86:	0007b023          	sd	zero,0(a5)

    uint64 end_time = get_time();
    80202e8a:	00000097          	auipc	ra,0x0
    80202e8e:	f38080e7          	jalr	-200(ra) # 80202dc2 <get_time>
    80202e92:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    80202e96:	fd442683          	lw	a3,-44(s0)
    80202e9a:	fd843703          	ld	a4,-40(s0)
    80202e9e:	fe043783          	ld	a5,-32(s0)
    80202ea2:	40f707b3          	sub	a5,a4,a5
    80202ea6:	863e                	mv	a2,a5
    80202ea8:	85b6                	mv	a1,a3
    80202eaa:	00002517          	auipc	a0,0x2
    80202eae:	69e50513          	addi	a0,a0,1694 # 80205548 <small_numbers+0x1380>
    80202eb2:	ffffd097          	auipc	ra,0xffffd
    80202eb6:	6b6080e7          	jalr	1718(ra) # 80200568 <printf>
           interrupt_count, end_time - start_time);
}
    80202eba:	0001                	nop
    80202ebc:	70a2                	ld	ra,40(sp)
    80202ebe:	7402                	ld	s0,32(sp)
    80202ec0:	6145                	addi	sp,sp,48
    80202ec2:	8082                	ret

0000000080202ec4 <test_exception>:

// 修改测试异常处理函数
void test_exception(void) {
    80202ec4:	715d                	addi	sp,sp,-80
    80202ec6:	e486                	sd	ra,72(sp)
    80202ec8:	e0a2                	sd	s0,64(sp)
    80202eca:	0880                	addi	s0,sp,80
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    80202ecc:	00002517          	auipc	a0,0x2
    80202ed0:	6b450513          	addi	a0,a0,1716 # 80205580 <small_numbers+0x13b8>
    80202ed4:	ffffd097          	auipc	ra,0xffffd
    80202ed8:	694080e7          	jalr	1684(ra) # 80200568 <printf>
    
    // 1. 测试非法指令异常
    printf("1. 测试非法指令异常...\n");
    80202edc:	00002517          	auipc	a0,0x2
    80202ee0:	6d450513          	addi	a0,a0,1748 # 802055b0 <small_numbers+0x13e8>
    80202ee4:	ffffd097          	auipc	ra,0xffffd
    80202ee8:	684080e7          	jalr	1668(ra) # 80200568 <printf>
    80202eec:	ffffffff          	.word	0xffffffff
    asm volatile (".word 0xffffffff");  // 非法RISC-V指令
    printf("✓ 非法指令异常处理成功\n\n");
    80202ef0:	00002517          	auipc	a0,0x2
    80202ef4:	6e050513          	addi	a0,a0,1760 # 802055d0 <small_numbers+0x1408>
    80202ef8:	ffffd097          	auipc	ra,0xffffd
    80202efc:	670080e7          	jalr	1648(ra) # 80200568 <printf>
    
    // 2. 测试存储页故障
    printf("2. 测试存储页故障异常...\n");
    80202f00:	00002517          	auipc	a0,0x2
    80202f04:	6f850513          	addi	a0,a0,1784 # 802055f8 <small_numbers+0x1430>
    80202f08:	ffffd097          	auipc	ra,0xffffd
    80202f0c:	660080e7          	jalr	1632(ra) # 80200568 <printf>
    volatile uint64 *invalid_ptr = 0;
    80202f10:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80202f14:	47a5                	li	a5,9
    80202f16:	07f2                	slli	a5,a5,0x1c
    80202f18:	fef43023          	sd	a5,-32(s0)
    80202f1c:	a835                	j	80202f58 <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    80202f1e:	fe043503          	ld	a0,-32(s0)
    80202f22:	fffff097          	auipc	ra,0xfffff
    80202f26:	1ca080e7          	jalr	458(ra) # 802020ec <check_is_mapped>
    80202f2a:	87aa                	mv	a5,a0
    80202f2c:	e385                	bnez	a5,80202f4c <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    80202f2e:	fe043783          	ld	a5,-32(s0)
    80202f32:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80202f36:	fe043583          	ld	a1,-32(s0)
    80202f3a:	00002517          	auipc	a0,0x2
    80202f3e:	6e650513          	addi	a0,a0,1766 # 80205620 <small_numbers+0x1458>
    80202f42:	ffffd097          	auipc	ra,0xffffd
    80202f46:	626080e7          	jalr	1574(ra) # 80200568 <printf>
            break;
    80202f4a:	a829                	j	80202f64 <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80202f4c:	fe043703          	ld	a4,-32(s0)
    80202f50:	6785                	lui	a5,0x1
    80202f52:	97ba                	add	a5,a5,a4
    80202f54:	fef43023          	sd	a5,-32(s0)
    80202f58:	fe043703          	ld	a4,-32(s0)
    80202f5c:	47cd                	li	a5,19
    80202f5e:	07ee                	slli	a5,a5,0x1b
    80202f60:	faf76fe3          	bltu	a4,a5,80202f1e <test_exception+0x5a>
        }
    }
    
    if (invalid_ptr != 0) {
    80202f64:	fe843783          	ld	a5,-24(s0)
    80202f68:	cb95                	beqz	a5,80202f9c <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80202f6a:	fe843783          	ld	a5,-24(s0)
    80202f6e:	85be                	mv	a1,a5
    80202f70:	00002517          	auipc	a0,0x2
    80202f74:	6d050513          	addi	a0,a0,1744 # 80205640 <small_numbers+0x1478>
    80202f78:	ffffd097          	auipc	ra,0xffffd
    80202f7c:	5f0080e7          	jalr	1520(ra) # 80200568 <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    80202f80:	fe843783          	ld	a5,-24(s0)
    80202f84:	02a00713          	li	a4,42
    80202f88:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    80202f8a:	00002517          	auipc	a0,0x2
    80202f8e:	6e650513          	addi	a0,a0,1766 # 80205670 <small_numbers+0x14a8>
    80202f92:	ffffd097          	auipc	ra,0xffffd
    80202f96:	5d6080e7          	jalr	1494(ra) # 80200568 <printf>
    80202f9a:	a809                	j	80202fac <test_exception+0xe8>
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80202f9c:	00002517          	auipc	a0,0x2
    80202fa0:	6fc50513          	addi	a0,a0,1788 # 80205698 <small_numbers+0x14d0>
    80202fa4:	ffffd097          	auipc	ra,0xffffd
    80202fa8:	5c4080e7          	jalr	1476(ra) # 80200568 <printf>
    }
    
    // 3. 测试加载页故障
    printf("3. 测试加载页故障异常...\n");
    80202fac:	00002517          	auipc	a0,0x2
    80202fb0:	72450513          	addi	a0,a0,1828 # 802056d0 <small_numbers+0x1508>
    80202fb4:	ffffd097          	auipc	ra,0xffffd
    80202fb8:	5b4080e7          	jalr	1460(ra) # 80200568 <printf>
    invalid_ptr = 0;
    80202fbc:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80202fc0:	4795                	li	a5,5
    80202fc2:	07f6                	slli	a5,a5,0x1d
    80202fc4:	fcf43c23          	sd	a5,-40(s0)
    80202fc8:	a835                	j	80203004 <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    80202fca:	fd843503          	ld	a0,-40(s0)
    80202fce:	fffff097          	auipc	ra,0xfffff
    80202fd2:	11e080e7          	jalr	286(ra) # 802020ec <check_is_mapped>
    80202fd6:	87aa                	mv	a5,a0
    80202fd8:	e385                	bnez	a5,80202ff8 <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    80202fda:	fd843783          	ld	a5,-40(s0)
    80202fde:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80202fe2:	fd843583          	ld	a1,-40(s0)
    80202fe6:	00002517          	auipc	a0,0x2
    80202fea:	63a50513          	addi	a0,a0,1594 # 80205620 <small_numbers+0x1458>
    80202fee:	ffffd097          	auipc	ra,0xffffd
    80202ff2:	57a080e7          	jalr	1402(ra) # 80200568 <printf>
            break;
    80202ff6:	a829                	j	80203010 <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80202ff8:	fd843703          	ld	a4,-40(s0)
    80202ffc:	6785                	lui	a5,0x1
    80202ffe:	97ba                	add	a5,a5,a4
    80203000:	fcf43c23          	sd	a5,-40(s0)
    80203004:	fd843703          	ld	a4,-40(s0)
    80203008:	47d5                	li	a5,21
    8020300a:	07ee                	slli	a5,a5,0x1b
    8020300c:	faf76fe3          	bltu	a4,a5,80202fca <test_exception+0x106>
        }
    }
    
    if (invalid_ptr != 0) {
    80203010:	fe843783          	ld	a5,-24(s0)
    80203014:	c7a9                	beqz	a5,8020305e <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80203016:	fe843783          	ld	a5,-24(s0)
    8020301a:	85be                	mv	a1,a5
    8020301c:	00002517          	auipc	a0,0x2
    80203020:	6dc50513          	addi	a0,a0,1756 # 802056f8 <small_numbers+0x1530>
    80203024:	ffffd097          	auipc	ra,0xffffd
    80203028:	544080e7          	jalr	1348(ra) # 80200568 <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    8020302c:	fe843783          	ld	a5,-24(s0)
    80203030:	639c                	ld	a5,0(a5)
    80203032:	faf43823          	sd	a5,-80(s0)
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    80203036:	fb043783          	ld	a5,-80(s0)
    8020303a:	85be                	mv	a1,a5
    8020303c:	00002517          	auipc	a0,0x2
    80203040:	6ec50513          	addi	a0,a0,1772 # 80205728 <small_numbers+0x1560>
    80203044:	ffffd097          	auipc	ra,0xffffd
    80203048:	524080e7          	jalr	1316(ra) # 80200568 <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    8020304c:	00002517          	auipc	a0,0x2
    80203050:	6f450513          	addi	a0,a0,1780 # 80205740 <small_numbers+0x1578>
    80203054:	ffffd097          	auipc	ra,0xffffd
    80203058:	514080e7          	jalr	1300(ra) # 80200568 <printf>
    8020305c:	a809                	j	8020306e <test_exception+0x1aa>
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    8020305e:	00002517          	auipc	a0,0x2
    80203062:	63a50513          	addi	a0,a0,1594 # 80205698 <small_numbers+0x14d0>
    80203066:	ffffd097          	auipc	ra,0xffffd
    8020306a:	502080e7          	jalr	1282(ra) # 80200568 <printf>
    }
    
    // 4. 测试存储地址未对齐异常
    printf("4. 测试存储地址未对齐异常...\n");
    8020306e:	00002517          	auipc	a0,0x2
    80203072:	6fa50513          	addi	a0,a0,1786 # 80205768 <small_numbers+0x15a0>
    80203076:	ffffd097          	auipc	ra,0xffffd
    8020307a:	4f2080e7          	jalr	1266(ra) # 80200568 <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    8020307e:	fffff097          	auipc	ra,0xfffff
    80203082:	1b0080e7          	jalr	432(ra) # 8020222e <alloc_page>
    80203086:	87aa                	mv	a5,a0
    80203088:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    8020308c:	fd043783          	ld	a5,-48(s0)
    80203090:	c3a1                	beqz	a5,802030d0 <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    80203092:	fd043783          	ld	a5,-48(s0)
    80203096:	0785                	addi	a5,a5,1 # 1001 <_entry-0x801fefff>
    80203098:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    8020309c:	fc843583          	ld	a1,-56(s0)
    802030a0:	00002517          	auipc	a0,0x2
    802030a4:	6f850513          	addi	a0,a0,1784 # 80205798 <small_numbers+0x15d0>
    802030a8:	ffffd097          	auipc	ra,0xffffd
    802030ac:	4c0080e7          	jalr	1216(ra) # 80200568 <printf>
        
        // 使用内联汇编进行未对齐访问，因为编译器可能会自动对齐
        asm volatile (
    802030b0:	deadc7b7          	lui	a5,0xdeadc
    802030b4:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8d4c2f>
    802030b8:	fc843703          	ld	a4,-56(s0)
    802030bc:	e31c                	sd	a5,0(a4)
            "sd %0, 0(%1)"
            : 
            : "r" (0xdeadbeef), "r" (misaligned_addr)
            : "memory"
        );
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    802030be:	00002517          	auipc	a0,0x2
    802030c2:	6fa50513          	addi	a0,a0,1786 # 802057b8 <small_numbers+0x15f0>
    802030c6:	ffffd097          	auipc	ra,0xffffd
    802030ca:	4a2080e7          	jalr	1186(ra) # 80200568 <printf>
    802030ce:	a809                	j	802030e0 <test_exception+0x21c>
    } else {
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    802030d0:	00002517          	auipc	a0,0x2
    802030d4:	71850513          	addi	a0,a0,1816 # 802057e8 <small_numbers+0x1620>
    802030d8:	ffffd097          	auipc	ra,0xffffd
    802030dc:	490080e7          	jalr	1168(ra) # 80200568 <printf>
    }
    
    // 5. 测试加载地址未对齐异常
    printf("5. 测试加载地址未对齐异常...\n");
    802030e0:	00002517          	auipc	a0,0x2
    802030e4:	74850513          	addi	a0,a0,1864 # 80205828 <small_numbers+0x1660>
    802030e8:	ffffd097          	auipc	ra,0xffffd
    802030ec:	480080e7          	jalr	1152(ra) # 80200568 <printf>
    if (aligned_addr != 0) {
    802030f0:	fd043783          	ld	a5,-48(s0)
    802030f4:	cbb1                	beqz	a5,80203148 <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    802030f6:	fd043783          	ld	a5,-48(s0)
    802030fa:	0785                	addi	a5,a5,1
    802030fc:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80203100:	fc043583          	ld	a1,-64(s0)
    80203104:	00002517          	auipc	a0,0x2
    80203108:	69450513          	addi	a0,a0,1684 # 80205798 <small_numbers+0x15d0>
    8020310c:	ffffd097          	auipc	ra,0xffffd
    80203110:	45c080e7          	jalr	1116(ra) # 80200568 <printf>
        
        uint64 value = 0;
    80203114:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    80203118:	fc043783          	ld	a5,-64(s0)
    8020311c:	639c                	ld	a5,0(a5)
    8020311e:	faf43c23          	sd	a5,-72(s0)
            "ld %0, 0(%1)"
            : "=r" (value)
            : "r" (misaligned_addr)
            : "memory"
        );
        printf("读取的值: 0x%lx\n", value);
    80203122:	fb843583          	ld	a1,-72(s0)
    80203126:	00002517          	auipc	a0,0x2
    8020312a:	73250513          	addi	a0,a0,1842 # 80205858 <small_numbers+0x1690>
    8020312e:	ffffd097          	auipc	ra,0xffffd
    80203132:	43a080e7          	jalr	1082(ra) # 80200568 <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80203136:	00002517          	auipc	a0,0x2
    8020313a:	73a50513          	addi	a0,a0,1850 # 80205870 <small_numbers+0x16a8>
    8020313e:	ffffd097          	auipc	ra,0xffffd
    80203142:	42a080e7          	jalr	1066(ra) # 80200568 <printf>
    80203146:	a809                	j	80203158 <test_exception+0x294>
    } else {
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80203148:	00002517          	auipc	a0,0x2
    8020314c:	6a050513          	addi	a0,a0,1696 # 802057e8 <small_numbers+0x1620>
    80203150:	ffffd097          	auipc	ra,0xffffd
    80203154:	418080e7          	jalr	1048(ra) # 80200568 <printf>
    }

	// 6. 测试断点异常
	printf("6. 测试断点异常...\n");
    80203158:	00002517          	auipc	a0,0x2
    8020315c:	74850513          	addi	a0,a0,1864 # 802058a0 <small_numbers+0x16d8>
    80203160:	ffffd097          	auipc	ra,0xffffd
    80203164:	408080e7          	jalr	1032(ra) # 80200568 <printf>
	asm volatile (
    80203168:	0001                	nop
    8020316a:	9002                	ebreak
    8020316c:	0001                	nop
		"nop\n\t"      // 确保ebreak前有有效指令
		"ebreak\n\t"   // 断点指令
		"nop\n\t"      // 确保ebreak后有有效指令
	);
	printf("✓ 断点异常处理成功\n\n");
    8020316e:	00002517          	auipc	a0,0x2
    80203172:	75250513          	addi	a0,a0,1874 # 802058c0 <small_numbers+0x16f8>
    80203176:	ffffd097          	auipc	ra,0xffffd
    8020317a:	3f2080e7          	jalr	1010(ra) # 80200568 <printf>
    // 7. 测试环境调用异常
    printf("7. 测试环境调用异常...\n");
    8020317e:	00002517          	auipc	a0,0x2
    80203182:	76250513          	addi	a0,a0,1890 # 802058e0 <small_numbers+0x1718>
    80203186:	ffffd097          	auipc	ra,0xffffd
    8020318a:	3e2080e7          	jalr	994(ra) # 80200568 <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    8020318e:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    80203192:	00002517          	auipc	a0,0x2
    80203196:	76e50513          	addi	a0,a0,1902 # 80205900 <small_numbers+0x1738>
    8020319a:	ffffd097          	auipc	ra,0xffffd
    8020319e:	3ce080e7          	jalr	974(ra) # 80200568 <printf>
    
    printf("===== 异常处理测试完成 =====\n\n");
    802031a2:	00002517          	auipc	a0,0x2
    802031a6:	78650513          	addi	a0,a0,1926 # 80205928 <small_numbers+0x1760>
    802031aa:	ffffd097          	auipc	ra,0xffffd
    802031ae:	3be080e7          	jalr	958(ra) # 80200568 <printf>
}
    802031b2:	0001                	nop
    802031b4:	60a6                	ld	ra,72(sp)
    802031b6:	6406                	ld	s0,64(sp)
    802031b8:	6161                	addi	sp,sp,80
    802031ba:	8082                	ret

00000000802031bc <write32>:
    802031bc:	7179                	addi	sp,sp,-48
    802031be:	f406                	sd	ra,40(sp)
    802031c0:	f022                	sd	s0,32(sp)
    802031c2:	1800                	addi	s0,sp,48
    802031c4:	fca43c23          	sd	a0,-40(s0)
    802031c8:	87ae                	mv	a5,a1
    802031ca:	fcf42a23          	sw	a5,-44(s0)
    802031ce:	fd843783          	ld	a5,-40(s0)
    802031d2:	8b8d                	andi	a5,a5,3
    802031d4:	eb99                	bnez	a5,802031ea <write32+0x2e>
    802031d6:	fd843783          	ld	a5,-40(s0)
    802031da:	fef43423          	sd	a5,-24(s0)
    802031de:	fe843783          	ld	a5,-24(s0)
    802031e2:	fd442703          	lw	a4,-44(s0)
    802031e6:	c398                	sw	a4,0(a5)
    802031e8:	a819                	j	802031fe <write32+0x42>
    802031ea:	fd843583          	ld	a1,-40(s0)
    802031ee:	00002517          	auipc	a0,0x2
    802031f2:	76250513          	addi	a0,a0,1890 # 80205950 <small_numbers+0x1788>
    802031f6:	ffffd097          	auipc	ra,0xffffd
    802031fa:	372080e7          	jalr	882(ra) # 80200568 <printf>
    802031fe:	0001                	nop
    80203200:	70a2                	ld	ra,40(sp)
    80203202:	7402                	ld	s0,32(sp)
    80203204:	6145                	addi	sp,sp,48
    80203206:	8082                	ret

0000000080203208 <read32>:
    80203208:	7179                	addi	sp,sp,-48
    8020320a:	f406                	sd	ra,40(sp)
    8020320c:	f022                	sd	s0,32(sp)
    8020320e:	1800                	addi	s0,sp,48
    80203210:	fca43c23          	sd	a0,-40(s0)
    80203214:	fd843783          	ld	a5,-40(s0)
    80203218:	8b8d                	andi	a5,a5,3
    8020321a:	eb91                	bnez	a5,8020322e <read32+0x26>
    8020321c:	fd843783          	ld	a5,-40(s0)
    80203220:	fef43423          	sd	a5,-24(s0)
    80203224:	fe843783          	ld	a5,-24(s0)
    80203228:	439c                	lw	a5,0(a5)
    8020322a:	2781                	sext.w	a5,a5
    8020322c:	a821                	j	80203244 <read32+0x3c>
    8020322e:	fd843583          	ld	a1,-40(s0)
    80203232:	00002517          	auipc	a0,0x2
    80203236:	74e50513          	addi	a0,a0,1870 # 80205980 <small_numbers+0x17b8>
    8020323a:	ffffd097          	auipc	ra,0xffffd
    8020323e:	32e080e7          	jalr	814(ra) # 80200568 <printf>
    80203242:	4781                	li	a5,0
    80203244:	853e                	mv	a0,a5
    80203246:	70a2                	ld	ra,40(sp)
    80203248:	7402                	ld	s0,32(sp)
    8020324a:	6145                	addi	sp,sp,48
    8020324c:	8082                	ret

000000008020324e <plic_init>:
void plic_init(void) {
    8020324e:	1101                	addi	sp,sp,-32
    80203250:	ec06                	sd	ra,24(sp)
    80203252:	e822                	sd	s0,16(sp)
    80203254:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80203256:	4785                	li	a5,1
    80203258:	fef42623          	sw	a5,-20(s0)
    8020325c:	a805                	j	8020328c <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    8020325e:	fec42783          	lw	a5,-20(s0)
    80203262:	0027979b          	slliw	a5,a5,0x2
    80203266:	2781                	sext.w	a5,a5
    80203268:	873e                	mv	a4,a5
    8020326a:	0c0007b7          	lui	a5,0xc000
    8020326e:	97ba                	add	a5,a5,a4
    80203270:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80203274:	4581                	li	a1,0
    80203276:	fe043503          	ld	a0,-32(s0)
    8020327a:	00000097          	auipc	ra,0x0
    8020327e:	f42080e7          	jalr	-190(ra) # 802031bc <write32>
    for (int i = 1; i <= 32; i++) {
    80203282:	fec42783          	lw	a5,-20(s0)
    80203286:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    80203288:	fef42623          	sw	a5,-20(s0)
    8020328c:	fec42783          	lw	a5,-20(s0)
    80203290:	0007871b          	sext.w	a4,a5
    80203294:	02000793          	li	a5,32
    80203298:	fce7d3e3          	bge	a5,a4,8020325e <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    8020329c:	4585                	li	a1,1
    8020329e:	0c0007b7          	lui	a5,0xc000
    802032a2:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    802032a6:	00000097          	auipc	ra,0x0
    802032aa:	f16080e7          	jalr	-234(ra) # 802031bc <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    802032ae:	4585                	li	a1,1
    802032b0:	0c0007b7          	lui	a5,0xc000
    802032b4:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    802032b8:	00000097          	auipc	ra,0x0
    802032bc:	f04080e7          	jalr	-252(ra) # 802031bc <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    802032c0:	40200593          	li	a1,1026
    802032c4:	0c0027b7          	lui	a5,0xc002
    802032c8:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802032cc:	00000097          	auipc	ra,0x0
    802032d0:	ef0080e7          	jalr	-272(ra) # 802031bc <write32>
    write32(PLIC_THRESHOLD, 0);
    802032d4:	4581                	li	a1,0
    802032d6:	0c201537          	lui	a0,0xc201
    802032da:	00000097          	auipc	ra,0x0
    802032de:	ee2080e7          	jalr	-286(ra) # 802031bc <write32>
}
    802032e2:	0001                	nop
    802032e4:	60e2                	ld	ra,24(sp)
    802032e6:	6442                	ld	s0,16(sp)
    802032e8:	6105                	addi	sp,sp,32
    802032ea:	8082                	ret

00000000802032ec <plic_enable>:
void plic_enable(int irq) {
    802032ec:	7179                	addi	sp,sp,-48
    802032ee:	f406                	sd	ra,40(sp)
    802032f0:	f022                	sd	s0,32(sp)
    802032f2:	1800                	addi	s0,sp,48
    802032f4:	87aa                	mv	a5,a0
    802032f6:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    802032fa:	0c0027b7          	lui	a5,0xc002
    802032fe:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80203302:	00000097          	auipc	ra,0x0
    80203306:	f06080e7          	jalr	-250(ra) # 80203208 <read32>
    8020330a:	87aa                	mv	a5,a0
    8020330c:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    80203310:	fdc42783          	lw	a5,-36(s0)
    80203314:	873e                	mv	a4,a5
    80203316:	4785                	li	a5,1
    80203318:	00e797bb          	sllw	a5,a5,a4
    8020331c:	2781                	sext.w	a5,a5
    8020331e:	2781                	sext.w	a5,a5
    80203320:	fec42703          	lw	a4,-20(s0)
    80203324:	8fd9                	or	a5,a5,a4
    80203326:	2781                	sext.w	a5,a5
    80203328:	85be                	mv	a1,a5
    8020332a:	0c0027b7          	lui	a5,0xc002
    8020332e:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80203332:	00000097          	auipc	ra,0x0
    80203336:	e8a080e7          	jalr	-374(ra) # 802031bc <write32>
}
    8020333a:	0001                	nop
    8020333c:	70a2                	ld	ra,40(sp)
    8020333e:	7402                	ld	s0,32(sp)
    80203340:	6145                	addi	sp,sp,48
    80203342:	8082                	ret

0000000080203344 <plic_disable>:
void plic_disable(int irq) {
    80203344:	7179                	addi	sp,sp,-48
    80203346:	f406                	sd	ra,40(sp)
    80203348:	f022                	sd	s0,32(sp)
    8020334a:	1800                	addi	s0,sp,48
    8020334c:	87aa                	mv	a5,a0
    8020334e:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80203352:	0c0027b7          	lui	a5,0xc002
    80203356:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    8020335a:	00000097          	auipc	ra,0x0
    8020335e:	eae080e7          	jalr	-338(ra) # 80203208 <read32>
    80203362:	87aa                	mv	a5,a0
    80203364:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    80203368:	fdc42783          	lw	a5,-36(s0)
    8020336c:	873e                	mv	a4,a5
    8020336e:	4785                	li	a5,1
    80203370:	00e797bb          	sllw	a5,a5,a4
    80203374:	2781                	sext.w	a5,a5
    80203376:	fff7c793          	not	a5,a5
    8020337a:	2781                	sext.w	a5,a5
    8020337c:	2781                	sext.w	a5,a5
    8020337e:	fec42703          	lw	a4,-20(s0)
    80203382:	8ff9                	and	a5,a5,a4
    80203384:	2781                	sext.w	a5,a5
    80203386:	85be                	mv	a1,a5
    80203388:	0c0027b7          	lui	a5,0xc002
    8020338c:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80203390:	00000097          	auipc	ra,0x0
    80203394:	e2c080e7          	jalr	-468(ra) # 802031bc <write32>
}
    80203398:	0001                	nop
    8020339a:	70a2                	ld	ra,40(sp)
    8020339c:	7402                	ld	s0,32(sp)
    8020339e:	6145                	addi	sp,sp,48
    802033a0:	8082                	ret

00000000802033a2 <plic_claim>:
int plic_claim(void) {
    802033a2:	1141                	addi	sp,sp,-16
    802033a4:	e406                	sd	ra,8(sp)
    802033a6:	e022                	sd	s0,0(sp)
    802033a8:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    802033aa:	0c2017b7          	lui	a5,0xc201
    802033ae:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    802033b2:	00000097          	auipc	ra,0x0
    802033b6:	e56080e7          	jalr	-426(ra) # 80203208 <read32>
    802033ba:	87aa                	mv	a5,a0
    802033bc:	2781                	sext.w	a5,a5
    802033be:	2781                	sext.w	a5,a5
}
    802033c0:	853e                	mv	a0,a5
    802033c2:	60a2                	ld	ra,8(sp)
    802033c4:	6402                	ld	s0,0(sp)
    802033c6:	0141                	addi	sp,sp,16
    802033c8:	8082                	ret

00000000802033ca <plic_complete>:
void plic_complete(int irq) {
    802033ca:	1101                	addi	sp,sp,-32
    802033cc:	ec06                	sd	ra,24(sp)
    802033ce:	e822                	sd	s0,16(sp)
    802033d0:	1000                	addi	s0,sp,32
    802033d2:	87aa                	mv	a5,a0
    802033d4:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    802033d8:	fec42783          	lw	a5,-20(s0)
    802033dc:	85be                	mv	a1,a5
    802033de:	0c2017b7          	lui	a5,0xc201
    802033e2:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    802033e6:	00000097          	auipc	ra,0x0
    802033ea:	dd6080e7          	jalr	-554(ra) # 802031bc <write32>
    802033ee:	0001                	nop
    802033f0:	60e2                	ld	ra,24(sp)
    802033f2:	6442                	ld	s0,16(sp)
    802033f4:	6105                	addi	sp,sp,32
    802033f6:	8082                	ret
	...

0000000080203400 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80203400:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80203402:	e006                	sd	ra,0(sp)
        # 注意：不保存sp，因为我们已经修改了它
        sd gp, 16(sp)
    80203404:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80203406:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80203408:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8020340a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8020340c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    8020340e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80203410:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80203412:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80203414:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80203416:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80203418:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    8020341a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    8020341c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8020341e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80203420:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80203422:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80203424:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80203426:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80203428:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    8020342a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    8020342c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    8020342e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80203430:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80203432:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80203434:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80203436:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80203438:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    8020343a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    8020343c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    8020343e:	fffff097          	auipc	ra,0xfffff
    80203442:	44a080e7          	jalr	1098(ra) # 80202888 <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80203446:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80203448:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8020344a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8020344c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    8020344e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80203450:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80203452:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80203454:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80203456:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80203458:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8020345a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8020345c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8020345e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80203460:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80203462:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80203464:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80203466:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80203468:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    8020346a:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    8020346c:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    8020346e:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80203470:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80203472:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80203474:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80203476:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80203478:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    8020347a:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    8020347c:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8020347e:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80203480:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80203482:	10200073          	sret
    80203486:	0001                	nop
    80203488:	00000013          	nop
    8020348c:	00000013          	nop
	...
