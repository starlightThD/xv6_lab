
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80200000:	00009117          	auipc	sp,0x9
    80200004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80200008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8020000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8020000c:	0000a517          	auipc	a0,0xa
    80200010:	01450513          	addi	a0,a0,20 # 8020a020 <kernel_pagetable>
        la a1,_bss_end
    80200014:	0000d597          	auipc	a1,0xd
    80200018:	53c58593          	addi	a1,a1,1340 # 8020d550 <_bss_end>

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
void clear_screen(void);
// start函数：内核的C语言入口
void start(){
	// 初始化内核的重要组件
	// 内存页分配器
	pmm_init();
    80200032:	1101                	addi	sp,sp,-32 # 80208fe0 <wait_channel.0+0xfd8>
    80200034:	ec22                	sd	s0,24(sp)
    80200036:	1000                	addi	s0,sp,32
	// 虚拟内存
	printf("[VP TEST] 尝试启用分页模式\n");
    80200038:	100027f3          	csrr	a5,sstatus
    8020003c:	fef43423          	sd	a5,-24(s0)
	kvminit();
    80200040:	fe843783          	ld	a5,-24(s0)
    kvminithart();
    80200044:	853e                	mv	a0,a5
    80200046:	6462                	ld	s0,24(sp)
    80200048:	6105                	addi	sp,sp,32
    8020004a:	8082                	ret

000000008020004c <w_sstatus>:
    // 进入操作系统后立即清屏
    8020004c:	1101                	addi	sp,sp,-32
    8020004e:	ec22                	sd	s0,24(sp)
    80200050:	1000                	addi	s0,sp,32
    80200052:	fea43423          	sd	a0,-24(s0)
    clear_screen();
    80200056:	fe843783          	ld	a5,-24(s0)
    8020005a:	10079073          	csrw	sstatus,a5
    // 输出操作系统启动横幅
    8020005e:	0001                	nop
    80200060:	6462                	ld	s0,24(sp)
    80200062:	6105                	addi	sp,sp,32
    80200064:	8082                	ret

0000000080200066 <intr_on>:
    uart_puts("        RISC-V Operating System v1.0         \n");
    uart_puts("===============================================\n\n");
    printf("[VP TEST] 当前已启用分页模式\n");

	trap_init();
    uart_puts("\nSystem ready. Entering main loop...\n");
    80200066:	1141                	addi	sp,sp,-16
    80200068:	e406                	sd	ra,8(sp)
    8020006a:	e022                	sd	s0,0(sp)
    8020006c:	0800                	addi	s0,sp,16
	// 允许中断
    8020006e:	00000097          	auipc	ra,0x0
    80200072:	fc4080e7          	jalr	-60(ra) # 80200032 <r_sstatus>
    80200076:	87aa                	mv	a5,a0
    80200078:	0027e793          	ori	a5,a5,2
    8020007c:	853e                	mv	a0,a5
    8020007e:	00000097          	auipc	ra,0x0
    80200082:	fce080e7          	jalr	-50(ra) # 8020004c <w_sstatus>
    intr_on();
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
    8020009c:	39c080e7          	jalr	924(ra) # 80202434 <pmm_init>
	printf("[VP TEST] 尝试启用分页模式\n");
    802000a0:	00005517          	auipc	a0,0x5
    802000a4:	f6050513          	addi	a0,a0,-160 # 80205000 <etext>
    802000a8:	00000097          	auipc	ra,0x0
    802000ac:	4f0080e7          	jalr	1264(ra) # 80200598 <printf>
	kvminit();
    802000b0:	00002097          	auipc	ra,0x2
    802000b4:	cb6080e7          	jalr	-842(ra) # 80201d66 <kvminit>
    kvminithart();
    802000b8:	00002097          	auipc	ra,0x2
    802000bc:	d00080e7          	jalr	-768(ra) # 80201db8 <kvminithart>
    clear_screen();
    802000c0:	00001097          	auipc	ra,0x1
    802000c4:	8d0080e7          	jalr	-1840(ra) # 80200990 <clear_screen>
    uart_puts("===============================================\n");
    802000c8:	00005517          	auipc	a0,0x5
    802000cc:	f6050513          	addi	a0,a0,-160 # 80205028 <etext+0x28>
    802000d0:	00000097          	auipc	ra,0x0
    802000d4:	15e080e7          	jalr	350(ra) # 8020022e <uart_puts>
    uart_puts("        RISC-V Operating System v1.0         \n");
    802000d8:	00005517          	auipc	a0,0x5
    802000dc:	f8850513          	addi	a0,a0,-120 # 80205060 <etext+0x60>
    802000e0:	00000097          	auipc	ra,0x0
    802000e4:	14e080e7          	jalr	334(ra) # 8020022e <uart_puts>
    uart_puts("===============================================\n\n");
    802000e8:	00005517          	auipc	a0,0x5
    802000ec:	fa850513          	addi	a0,a0,-88 # 80205090 <etext+0x90>
    802000f0:	00000097          	auipc	ra,0x0
    802000f4:	13e080e7          	jalr	318(ra) # 8020022e <uart_puts>
    printf("[VP TEST] 当前已启用分页模式\n");
    802000f8:	00005517          	auipc	a0,0x5
    802000fc:	fd050513          	addi	a0,a0,-48 # 802050c8 <etext+0xc8>
    80200100:	00000097          	auipc	ra,0x0
    80200104:	498080e7          	jalr	1176(ra) # 80200598 <printf>
	trap_init();
    80200108:	00003097          	auipc	ra,0x3
    8020010c:	936080e7          	jalr	-1738(ra) # 80202a3e <trap_init>
    uart_puts("\nSystem ready. Entering main loop...\n");
    80200110:	00005517          	auipc	a0,0x5
    80200114:	fe050513          	addi	a0,a0,-32 # 802050f0 <etext+0xf0>
    80200118:	00000097          	auipc	ra,0x0
    8020011c:	116080e7          	jalr	278(ra) # 8020022e <uart_puts>
    intr_on();
    80200120:	00000097          	auipc	ra,0x0
    80200124:	f46080e7          	jalr	-186(ra) # 80200066 <intr_on>
	test_timer_interrupt();
    80200128:	00003097          	auipc	ra,0x3
    8020012c:	fb0080e7          	jalr	-80(ra) # 802030d8 <test_timer_interrupt>
	printf("[KERNEL] Timer interrupt test finished!\n");
    80200130:	00005517          	auipc	a0,0x5
    80200134:	fe850513          	addi	a0,a0,-24 # 80205118 <etext+0x118>
    80200138:	00000097          	auipc	ra,0x0
    8020013c:	460080e7          	jalr	1120(ra) # 80200598 <printf>
	test_exception();
    80200140:	00003097          	auipc	ra,0x3
    80200144:	07e080e7          	jalr	126(ra) # 802031be <test_exception>
	printf("[KERNEL] Exception test finished!\n");
    80200148:	00005517          	auipc	a0,0x5
    8020014c:	00050513          	mv	a0,a0
    80200150:	00000097          	auipc	ra,0x0
    80200154:	448080e7          	jalr	1096(ra) # 80200598 <printf>
	test_proc_functions();
    80200158:	00004097          	auipc	ra,0x4
    8020015c:	6fc080e7          	jalr	1788(ra) # 80204854 <test_proc_functions>
	test_proc_manager();
    80200160:	00005097          	auipc	ra,0x5
    80200164:	9f8080e7          	jalr	-1544(ra) # 80204b58 <test_proc_manager>
	printf("[KERNEL] Process manager test finished!\n");
    80200168:	00005517          	auipc	a0,0x5
    8020016c:	00850513          	addi	a0,a0,8 # 80205170 <etext+0x170>
    80200170:	00000097          	auipc	ra,0x0
    80200174:	428080e7          	jalr	1064(ra) # 80200598 <printf>
	uart_init();
    80200178:	00000097          	auipc	ra,0x0
    8020017c:	01c080e7          	jalr	28(ra) # 80200194 <uart_init>
	printf("外部中断：键盘输入已经注册，请尝试输入字符并观察UART输出\n");
    80200180:	00005517          	auipc	a0,0x5
    80200184:	02050513          	addi	a0,a0,32 # 802051a0 <etext+0x1a0>
    80200188:	00000097          	auipc	ra,0x0
    8020018c:	410080e7          	jalr	1040(ra) # 80200598 <printf>
    // 主循环
	while(1){
    80200190:	0001                	nop
    80200192:	bffd                	j	80200190 <start+0x100>

0000000080200194 <uart_init>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))


// UART初始化函数
void uart_init(void) {
    80200194:	1141                	addi	sp,sp,-16
    80200196:	e406                	sd	ra,8(sp)
    80200198:	e022                	sd	s0,0(sp)
    8020019a:	0800                	addi	s0,sp,16

    WriteReg(IER, 0x00);
    8020019c:	100007b7          	lui	a5,0x10000
    802001a0:	0785                	addi	a5,a5,1 # 10000001 <userret+0xfffff65>
    802001a2:	00078023          	sb	zero,0(a5)
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    802001a6:	100007b7          	lui	a5,0x10000
    802001aa:	0789                	addi	a5,a5,2 # 10000002 <userret+0xfffff66>
    802001ac:	471d                	li	a4,7
    802001ae:	00e78023          	sb	a4,0(a5)
    WriteReg(IER, IER_RX_ENABLE);
    802001b2:	100007b7          	lui	a5,0x10000
    802001b6:	0785                	addi	a5,a5,1 # 10000001 <userret+0xfffff65>
    802001b8:	4705                	li	a4,1
    802001ba:	00e78023          	sb	a4,0(a5)
    register_interrupt(UART0_IRQ, uart_intr);//注册键盘输入的中断处理函数
    802001be:	00000597          	auipc	a1,0x0
    802001c2:	12858593          	addi	a1,a1,296 # 802002e6 <uart_intr>
    802001c6:	4529                	li	a0,10
    802001c8:	00002097          	auipc	ra,0x2
    802001cc:	6f2080e7          	jalr	1778(ra) # 802028ba <register_interrupt>
    enable_interrupts(UART0_IRQ);
    802001d0:	4529                	li	a0,10
    802001d2:	00002097          	auipc	ra,0x2
    802001d6:	772080e7          	jalr	1906(ra) # 80202944 <enable_interrupts>
    printf("UART initialized with input support\n");
    802001da:	00005517          	auipc	a0,0x5
    802001de:	01e50513          	addi	a0,a0,30 # 802051f8 <etext+0x1f8>
    802001e2:	00000097          	auipc	ra,0x0
    802001e6:	3b6080e7          	jalr	950(ra) # 80200598 <printf>
}
    802001ea:	0001                	nop
    802001ec:	60a2                	ld	ra,8(sp)
    802001ee:	6402                	ld	s0,0(sp)
    802001f0:	0141                	addi	sp,sp,16
    802001f2:	8082                	ret

00000000802001f4 <uart_putc>:

// 发送单个字符
void uart_putc(char c) {
    802001f4:	1101                	addi	sp,sp,-32
    802001f6:	ec22                	sd	s0,24(sp)
    802001f8:	1000                	addi	s0,sp,32
    802001fa:	87aa                	mv	a5,a0
    802001fc:	fef407a3          	sb	a5,-17(s0)
    // 等待发送缓冲区空闲
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80200200:	0001                	nop
    80200202:	100007b7          	lui	a5,0x10000
    80200206:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    80200208:	0007c783          	lbu	a5,0(a5)
    8020020c:	0ff7f793          	zext.b	a5,a5
    80200210:	2781                	sext.w	a5,a5
    80200212:	0207f793          	andi	a5,a5,32
    80200216:	2781                	sext.w	a5,a5
    80200218:	d7ed                	beqz	a5,80200202 <uart_putc+0xe>
    WriteReg(THR, c);
    8020021a:	100007b7          	lui	a5,0x10000
    8020021e:	fef44703          	lbu	a4,-17(s0)
    80200222:	00e78023          	sb	a4,0(a5) # 10000000 <userret+0xfffff64>
}
    80200226:	0001                	nop
    80200228:	6462                	ld	s0,24(sp)
    8020022a:	6105                	addi	sp,sp,32
    8020022c:	8082                	ret

000000008020022e <uart_puts>:

void uart_puts(char *s) {
    8020022e:	7179                	addi	sp,sp,-48
    80200230:	f422                	sd	s0,40(sp)
    80200232:	1800                	addi	s0,sp,48
    80200234:	fca43c23          	sd	a0,-40(s0)
    if (!s) return;
    80200238:	fd843783          	ld	a5,-40(s0)
    8020023c:	c7b5                	beqz	a5,802002a8 <uart_puts+0x7a>
    
    while (*s) {
    8020023e:	a8b9                	j	8020029c <uart_puts+0x6e>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80200240:	0001                	nop
    80200242:	100007b7          	lui	a5,0x10000
    80200246:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    80200248:	0007c783          	lbu	a5,0(a5)
    8020024c:	0ff7f793          	zext.b	a5,a5
    80200250:	2781                	sext.w	a5,a5
    80200252:	0207f793          	andi	a5,a5,32
    80200256:	2781                	sext.w	a5,a5
    80200258:	d7ed                	beqz	a5,80200242 <uart_puts+0x14>
        int sent_count = 0;
    8020025a:	fe042623          	sw	zero,-20(s0)
        while (*s && sent_count < 4) { 
    8020025e:	a01d                	j	80200284 <uart_puts+0x56>
            WriteReg(THR, *s);
    80200260:	100007b7          	lui	a5,0x10000
    80200264:	fd843703          	ld	a4,-40(s0)
    80200268:	00074703          	lbu	a4,0(a4)
    8020026c:	00e78023          	sb	a4,0(a5) # 10000000 <userret+0xfffff64>
            s++;
    80200270:	fd843783          	ld	a5,-40(s0)
    80200274:	0785                	addi	a5,a5,1
    80200276:	fcf43c23          	sd	a5,-40(s0)
            sent_count++;
    8020027a:	fec42783          	lw	a5,-20(s0)
    8020027e:	2785                	addiw	a5,a5,1
    80200280:	fef42623          	sw	a5,-20(s0)
        while (*s && sent_count < 4) { 
    80200284:	fd843783          	ld	a5,-40(s0)
    80200288:	0007c783          	lbu	a5,0(a5)
    8020028c:	cb81                	beqz	a5,8020029c <uart_puts+0x6e>
    8020028e:	fec42783          	lw	a5,-20(s0)
    80200292:	0007871b          	sext.w	a4,a5
    80200296:	478d                	li	a5,3
    80200298:	fce7d4e3          	bge	a5,a4,80200260 <uart_puts+0x32>
    while (*s) {
    8020029c:	fd843783          	ld	a5,-40(s0)
    802002a0:	0007c783          	lbu	a5,0(a5)
    802002a4:	ffd1                	bnez	a5,80200240 <uart_puts+0x12>
    802002a6:	a011                	j	802002aa <uart_puts+0x7c>
    if (!s) return;
    802002a8:	0001                	nop
        }
    }
}
    802002aa:	7422                	ld	s0,40(sp)
    802002ac:	6145                	addi	sp,sp,48
    802002ae:	8082                	ret

00000000802002b0 <uart_getc>:

int uart_getc(void) {
    802002b0:	1141                	addi	sp,sp,-16
    802002b2:	e422                	sd	s0,8(sp)
    802002b4:	0800                	addi	s0,sp,16
    if ((ReadReg(LSR) & LSR_RX_READY) == 0)
    802002b6:	100007b7          	lui	a5,0x10000
    802002ba:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    802002bc:	0007c783          	lbu	a5,0(a5)
    802002c0:	0ff7f793          	zext.b	a5,a5
    802002c4:	2781                	sext.w	a5,a5
    802002c6:	8b85                	andi	a5,a5,1
    802002c8:	2781                	sext.w	a5,a5
    802002ca:	e399                	bnez	a5,802002d0 <uart_getc+0x20>
        return -1; 
    802002cc:	57fd                	li	a5,-1
    802002ce:	a801                	j	802002de <uart_getc+0x2e>
    return ReadReg(RHR); 
    802002d0:	100007b7          	lui	a5,0x10000
    802002d4:	0007c783          	lbu	a5,0(a5) # 10000000 <userret+0xfffff64>
    802002d8:	0ff7f793          	zext.b	a5,a5
    802002dc:	2781                	sext.w	a5,a5
}
    802002de:	853e                	mv	a0,a5
    802002e0:	6422                	ld	s0,8(sp)
    802002e2:	0141                	addi	sp,sp,16
    802002e4:	8082                	ret

00000000802002e6 <uart_intr>:

// UART中断处理函数
void uart_intr(void) {
    802002e6:	1101                	addi	sp,sp,-32
    802002e8:	ec06                	sd	ra,24(sp)
    802002ea:	e822                	sd	s0,16(sp)
    802002ec:	1000                	addi	s0,sp,32
    while (ReadReg(LSR) & LSR_RX_READY) {
    802002ee:	a831                	j	8020030a <uart_intr+0x24>
        char c = ReadReg(RHR);
    802002f0:	100007b7          	lui	a5,0x10000
    802002f4:	0007c783          	lbu	a5,0(a5) # 10000000 <userret+0xfffff64>
    802002f8:	fef407a3          	sb	a5,-17(s0)
        uart_putc(c);
    802002fc:	fef44783          	lbu	a5,-17(s0)
    80200300:	853e                	mv	a0,a5
    80200302:	00000097          	auipc	ra,0x0
    80200306:	ef2080e7          	jalr	-270(ra) # 802001f4 <uart_putc>
    while (ReadReg(LSR) & LSR_RX_READY) {
    8020030a:	100007b7          	lui	a5,0x10000
    8020030e:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    80200310:	0007c783          	lbu	a5,0(a5)
    80200314:	0ff7f793          	zext.b	a5,a5
    80200318:	2781                	sext.w	a5,a5
    8020031a:	8b85                	andi	a5,a5,1
    8020031c:	2781                	sext.w	a5,a5
    8020031e:	fbe9                	bnez	a5,802002f0 <uart_intr+0xa>
    }
}
    80200320:	0001                	nop
    80200322:	0001                	nop
    80200324:	60e2                	ld	ra,24(sp)
    80200326:	6442                	ld	s0,16(sp)
    80200328:	6105                	addi	sp,sp,32
    8020032a:	8082                	ret

000000008020032c <flush_printf_buffer>:
#define PRINTF_BUFFER_SIZE 128
extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    8020032c:	1141                	addi	sp,sp,-16
    8020032e:	e406                	sd	ra,8(sp)
    80200330:	e022                	sd	s0,0(sp)
    80200332:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    80200334:	0000a797          	auipc	a5,0xa
    80200338:	d8c78793          	addi	a5,a5,-628 # 8020a0c0 <printf_buf_pos>
    8020033c:	439c                	lw	a5,0(a5)
    8020033e:	02f05c63          	blez	a5,80200376 <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200342:	0000a797          	auipc	a5,0xa
    80200346:	d7e78793          	addi	a5,a5,-642 # 8020a0c0 <printf_buf_pos>
    8020034a:	439c                	lw	a5,0(a5)
    8020034c:	0000a717          	auipc	a4,0xa
    80200350:	cf470713          	addi	a4,a4,-780 # 8020a040 <printf_buffer>
    80200354:	97ba                	add	a5,a5,a4
    80200356:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    8020035a:	0000a517          	auipc	a0,0xa
    8020035e:	ce650513          	addi	a0,a0,-794 # 8020a040 <printf_buffer>
    80200362:	00000097          	auipc	ra,0x0
    80200366:	ecc080e7          	jalr	-308(ra) # 8020022e <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    8020036a:	0000a797          	auipc	a5,0xa
    8020036e:	d5678793          	addi	a5,a5,-682 # 8020a0c0 <printf_buf_pos>
    80200372:	0007a023          	sw	zero,0(a5)
	}
}
    80200376:	0001                	nop
    80200378:	60a2                	ld	ra,8(sp)
    8020037a:	6402                	ld	s0,0(sp)
    8020037c:	0141                	addi	sp,sp,16
    8020037e:	8082                	ret

0000000080200380 <buffer_char>:
static void buffer_char(char c) {
    80200380:	1101                	addi	sp,sp,-32
    80200382:	ec06                	sd	ra,24(sp)
    80200384:	e822                	sd	s0,16(sp)
    80200386:	1000                	addi	s0,sp,32
    80200388:	87aa                	mv	a5,a0
    8020038a:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    8020038e:	0000a797          	auipc	a5,0xa
    80200392:	d3278793          	addi	a5,a5,-718 # 8020a0c0 <printf_buf_pos>
    80200396:	439c                	lw	a5,0(a5)
    80200398:	873e                	mv	a4,a5
    8020039a:	07e00793          	li	a5,126
    8020039e:	02e7ca63          	blt	a5,a4,802003d2 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    802003a2:	0000a797          	auipc	a5,0xa
    802003a6:	d1e78793          	addi	a5,a5,-738 # 8020a0c0 <printf_buf_pos>
    802003aa:	439c                	lw	a5,0(a5)
    802003ac:	0017871b          	addiw	a4,a5,1
    802003b0:	0007069b          	sext.w	a3,a4
    802003b4:	0000a717          	auipc	a4,0xa
    802003b8:	d0c70713          	addi	a4,a4,-756 # 8020a0c0 <printf_buf_pos>
    802003bc:	c314                	sw	a3,0(a4)
    802003be:	0000a717          	auipc	a4,0xa
    802003c2:	c8270713          	addi	a4,a4,-894 # 8020a040 <printf_buffer>
    802003c6:	97ba                	add	a5,a5,a4
    802003c8:	fef44703          	lbu	a4,-17(s0)
    802003cc:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    802003d0:	a825                	j	80200408 <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    802003d2:	00000097          	auipc	ra,0x0
    802003d6:	f5a080e7          	jalr	-166(ra) # 8020032c <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    802003da:	0000a797          	auipc	a5,0xa
    802003de:	ce678793          	addi	a5,a5,-794 # 8020a0c0 <printf_buf_pos>
    802003e2:	439c                	lw	a5,0(a5)
    802003e4:	0017871b          	addiw	a4,a5,1
    802003e8:	0007069b          	sext.w	a3,a4
    802003ec:	0000a717          	auipc	a4,0xa
    802003f0:	cd470713          	addi	a4,a4,-812 # 8020a0c0 <printf_buf_pos>
    802003f4:	c314                	sw	a3,0(a4)
    802003f6:	0000a717          	auipc	a4,0xa
    802003fa:	c4a70713          	addi	a4,a4,-950 # 8020a040 <printf_buffer>
    802003fe:	97ba                	add	a5,a5,a4
    80200400:	fef44703          	lbu	a4,-17(s0)
    80200404:	00e78023          	sb	a4,0(a5)
}
    80200408:	0001                	nop
    8020040a:	60e2                	ld	ra,24(sp)
    8020040c:	6442                	ld	s0,16(sp)
    8020040e:	6105                	addi	sp,sp,32
    80200410:	8082                	ret

0000000080200412 <consputc>:
    "70", "71", "72", "73", "74", "75", "76", "77", "78", "79",
    "80", "81", "82", "83", "84", "85", "86", "87", "88", "89",
    "90", "91", "92", "93", "94", "95", "96", "97", "98", "99"
};

static void consputc(int c){
    80200412:	1101                	addi	sp,sp,-32
    80200414:	ec06                	sd	ra,24(sp)
    80200416:	e822                	sd	s0,16(sp)
    80200418:	1000                	addi	s0,sp,32
    8020041a:	87aa                	mv	a5,a0
    8020041c:	fef42623          	sw	a5,-20(s0)
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
    80200420:	fec42783          	lw	a5,-20(s0)
    80200424:	0ff7f793          	zext.b	a5,a5
    80200428:	853e                	mv	a0,a5
    8020042a:	00000097          	auipc	ra,0x0
    8020042e:	dca080e7          	jalr	-566(ra) # 802001f4 <uart_putc>
}
    80200432:	0001                	nop
    80200434:	60e2                	ld	ra,24(sp)
    80200436:	6442                	ld	s0,16(sp)
    80200438:	6105                	addi	sp,sp,32
    8020043a:	8082                	ret

000000008020043c <consputs>:
static void consputs(const char *s){
    8020043c:	7179                	addi	sp,sp,-48
    8020043e:	f406                	sd	ra,40(sp)
    80200440:	f022                	sd	s0,32(sp)
    80200442:	1800                	addi	s0,sp,48
    80200444:	fca43c23          	sd	a0,-40(s0)
	char *str = (char *)s;
    80200448:	fd843783          	ld	a5,-40(s0)
    8020044c:	fef43423          	sd	a5,-24(s0)
	// 直接调用uart_puts输出字符串
	uart_puts(str);
    80200450:	fe843503          	ld	a0,-24(s0)
    80200454:	00000097          	auipc	ra,0x0
    80200458:	dda080e7          	jalr	-550(ra) # 8020022e <uart_puts>
}
    8020045c:	0001                	nop
    8020045e:	70a2                	ld	ra,40(sp)
    80200460:	7402                	ld	s0,32(sp)
    80200462:	6145                	addi	sp,sp,48
    80200464:	8082                	ret

0000000080200466 <printint>:
static void printint(long long xx,int base,int sign){
    80200466:	715d                	addi	sp,sp,-80
    80200468:	e486                	sd	ra,72(sp)
    8020046a:	e0a2                	sd	s0,64(sp)
    8020046c:	0880                	addi	s0,sp,80
    8020046e:	faa43c23          	sd	a0,-72(s0)
    80200472:	87ae                	mv	a5,a1
    80200474:	8732                	mv	a4,a2
    80200476:	faf42a23          	sw	a5,-76(s0)
    8020047a:	87ba                	mv	a5,a4
    8020047c:	faf42823          	sw	a5,-80(s0)
	// 模仿xv6的printint
	static char digits[] = "0123456789abcdef";
	char buf[20]; // 增大缓冲区以处理64位整数
	int i;
	unsigned long long x;
	if (sign && (sign = xx < 0)) // 符号处理
    80200480:	fb042783          	lw	a5,-80(s0)
    80200484:	2781                	sext.w	a5,a5
    80200486:	c39d                	beqz	a5,802004ac <printint+0x46>
    80200488:	fb843783          	ld	a5,-72(s0)
    8020048c:	93fd                	srli	a5,a5,0x3f
    8020048e:	0ff7f793          	zext.b	a5,a5
    80200492:	faf42823          	sw	a5,-80(s0)
    80200496:	fb042783          	lw	a5,-80(s0)
    8020049a:	2781                	sext.w	a5,a5
    8020049c:	cb81                	beqz	a5,802004ac <printint+0x46>
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    8020049e:	fb843783          	ld	a5,-72(s0)
    802004a2:	40f007b3          	neg	a5,a5
    802004a6:	fef43023          	sd	a5,-32(s0)
    802004aa:	a029                	j	802004b4 <printint+0x4e>
	else
		x = xx;
    802004ac:	fb843783          	ld	a5,-72(s0)
    802004b0:	fef43023          	sd	a5,-32(s0)

	if (base == 10 && x < 100) {
    802004b4:	fb442783          	lw	a5,-76(s0)
    802004b8:	0007871b          	sext.w	a4,a5
    802004bc:	47a9                	li	a5,10
    802004be:	02f71763          	bne	a4,a5,802004ec <printint+0x86>
    802004c2:	fe043703          	ld	a4,-32(s0)
    802004c6:	06300793          	li	a5,99
    802004ca:	02e7e163          	bltu	a5,a4,802004ec <printint+0x86>
		// 使用查表法处理小数字
		consputs(small_numbers[x]);
    802004ce:	fe043783          	ld	a5,-32(s0)
    802004d2:	00279713          	slli	a4,a5,0x2
    802004d6:	00005797          	auipc	a5,0x5
    802004da:	d4a78793          	addi	a5,a5,-694 # 80205220 <small_numbers>
    802004de:	97ba                	add	a5,a5,a4
    802004e0:	853e                	mv	a0,a5
    802004e2:	00000097          	auipc	ra,0x0
    802004e6:	f5a080e7          	jalr	-166(ra) # 8020043c <consputs>
    802004ea:	a05d                	j	80200590 <printint+0x12a>
		return;
	}
	i = 0;
    802004ec:	fe042623          	sw	zero,-20(s0)
	do{
		buf[i] = digits[x % base];
    802004f0:	fb442783          	lw	a5,-76(s0)
    802004f4:	fe043703          	ld	a4,-32(s0)
    802004f8:	02f777b3          	remu	a5,a4,a5
    802004fc:	0000a717          	auipc	a4,0xa
    80200500:	b0470713          	addi	a4,a4,-1276 # 8020a000 <digits.0>
    80200504:	97ba                	add	a5,a5,a4
    80200506:	0007c703          	lbu	a4,0(a5)
    8020050a:	fec42783          	lw	a5,-20(s0)
    8020050e:	17c1                	addi	a5,a5,-16
    80200510:	97a2                	add	a5,a5,s0
    80200512:	fce78c23          	sb	a4,-40(a5)
		i++;
    80200516:	fec42783          	lw	a5,-20(s0)
    8020051a:	2785                	addiw	a5,a5,1
    8020051c:	fef42623          	sw	a5,-20(s0)
	}while((x/=base) !=0);
    80200520:	fb442783          	lw	a5,-76(s0)
    80200524:	fe043703          	ld	a4,-32(s0)
    80200528:	02f757b3          	divu	a5,a4,a5
    8020052c:	fef43023          	sd	a5,-32(s0)
    80200530:	fe043783          	ld	a5,-32(s0)
    80200534:	ffd5                	bnez	a5,802004f0 <printint+0x8a>
	if (sign){
    80200536:	fb042783          	lw	a5,-80(s0)
    8020053a:	2781                	sext.w	a5,a5
    8020053c:	cf91                	beqz	a5,80200558 <printint+0xf2>
		buf[i] = '-';
    8020053e:	fec42783          	lw	a5,-20(s0)
    80200542:	17c1                	addi	a5,a5,-16
    80200544:	97a2                	add	a5,a5,s0
    80200546:	02d00713          	li	a4,45
    8020054a:	fce78c23          	sb	a4,-40(a5)
		i++;
    8020054e:	fec42783          	lw	a5,-20(s0)
    80200552:	2785                	addiw	a5,a5,1
    80200554:	fef42623          	sw	a5,-20(s0)
	}
	i--;
    80200558:	fec42783          	lw	a5,-20(s0)
    8020055c:	37fd                	addiw	a5,a5,-1
    8020055e:	fef42623          	sw	a5,-20(s0)
	while( i>=0){
    80200562:	a015                	j	80200586 <printint+0x120>
		consputc(buf[i]);
    80200564:	fec42783          	lw	a5,-20(s0)
    80200568:	17c1                	addi	a5,a5,-16
    8020056a:	97a2                	add	a5,a5,s0
    8020056c:	fd87c783          	lbu	a5,-40(a5)
    80200570:	2781                	sext.w	a5,a5
    80200572:	853e                	mv	a0,a5
    80200574:	00000097          	auipc	ra,0x0
    80200578:	e9e080e7          	jalr	-354(ra) # 80200412 <consputc>
		i--;
    8020057c:	fec42783          	lw	a5,-20(s0)
    80200580:	37fd                	addiw	a5,a5,-1
    80200582:	fef42623          	sw	a5,-20(s0)
	while( i>=0){
    80200586:	fec42783          	lw	a5,-20(s0)
    8020058a:	2781                	sext.w	a5,a5
    8020058c:	fc07dce3          	bgez	a5,80200564 <printint+0xfe>
	}
}
    80200590:	60a6                	ld	ra,72(sp)
    80200592:	6406                	ld	s0,64(sp)
    80200594:	6161                	addi	sp,sp,80
    80200596:	8082                	ret

0000000080200598 <printf>:
void printf(const char *fmt, ...) {
    80200598:	7171                	addi	sp,sp,-176
    8020059a:	f486                	sd	ra,104(sp)
    8020059c:	f0a2                	sd	s0,96(sp)
    8020059e:	1880                	addi	s0,sp,112
    802005a0:	f8a43c23          	sd	a0,-104(s0)
    802005a4:	e40c                	sd	a1,8(s0)
    802005a6:	e810                	sd	a2,16(s0)
    802005a8:	ec14                	sd	a3,24(s0)
    802005aa:	f018                	sd	a4,32(s0)
    802005ac:	f41c                	sd	a5,40(s0)
    802005ae:	03043823          	sd	a6,48(s0)
    802005b2:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    802005b6:	04040793          	addi	a5,s0,64
    802005ba:	f8f43823          	sd	a5,-112(s0)
    802005be:	f9043783          	ld	a5,-112(s0)
    802005c2:	fc878793          	addi	a5,a5,-56
    802005c6:	fcf43023          	sd	a5,-64(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    802005ca:	fe042623          	sw	zero,-20(s0)
    802005ce:	a671                	j	8020095a <printf+0x3c2>
        if(c != '%'){
    802005d0:	fe842783          	lw	a5,-24(s0)
    802005d4:	0007871b          	sext.w	a4,a5
    802005d8:	02500793          	li	a5,37
    802005dc:	00f70c63          	beq	a4,a5,802005f4 <printf+0x5c>
            buffer_char(c);
    802005e0:	fe842783          	lw	a5,-24(s0)
    802005e4:	0ff7f793          	zext.b	a5,a5
    802005e8:	853e                	mv	a0,a5
    802005ea:	00000097          	auipc	ra,0x0
    802005ee:	d96080e7          	jalr	-618(ra) # 80200380 <buffer_char>
            continue;
    802005f2:	aeb9                	j	80200950 <printf+0x3b8>
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    802005f4:	00000097          	auipc	ra,0x0
    802005f8:	d38080e7          	jalr	-712(ra) # 8020032c <flush_printf_buffer>
        c = fmt[++i] & 0xff;
    802005fc:	fec42783          	lw	a5,-20(s0)
    80200600:	2785                	addiw	a5,a5,1
    80200602:	fef42623          	sw	a5,-20(s0)
    80200606:	fec42783          	lw	a5,-20(s0)
    8020060a:	f9843703          	ld	a4,-104(s0)
    8020060e:	97ba                	add	a5,a5,a4
    80200610:	0007c783          	lbu	a5,0(a5)
    80200614:	fef42423          	sw	a5,-24(s0)
        if(c == 0)
    80200618:	fe842783          	lw	a5,-24(s0)
    8020061c:	2781                	sext.w	a5,a5
    8020061e:	34078d63          	beqz	a5,80200978 <printf+0x3e0>
            break;
            
        // 检查是否有长整型标记'l'
        int is_long = 0;
    80200622:	fc042e23          	sw	zero,-36(s0)
        if(c == 'l') {
    80200626:	fe842783          	lw	a5,-24(s0)
    8020062a:	0007871b          	sext.w	a4,a5
    8020062e:	06c00793          	li	a5,108
    80200632:	02f71863          	bne	a4,a5,80200662 <printf+0xca>
            is_long = 1;
    80200636:	4785                	li	a5,1
    80200638:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    8020063c:	fec42783          	lw	a5,-20(s0)
    80200640:	2785                	addiw	a5,a5,1
    80200642:	fef42623          	sw	a5,-20(s0)
    80200646:	fec42783          	lw	a5,-20(s0)
    8020064a:	f9843703          	ld	a4,-104(s0)
    8020064e:	97ba                	add	a5,a5,a4
    80200650:	0007c783          	lbu	a5,0(a5)
    80200654:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    80200658:	fe842783          	lw	a5,-24(s0)
    8020065c:	2781                	sext.w	a5,a5
    8020065e:	30078f63          	beqz	a5,8020097c <printf+0x3e4>
                break;
        }
        
        switch(c){
    80200662:	fe842783          	lw	a5,-24(s0)
    80200666:	0007871b          	sext.w	a4,a5
    8020066a:	02500793          	li	a5,37
    8020066e:	2af70063          	beq	a4,a5,8020090e <printf+0x376>
    80200672:	fe842783          	lw	a5,-24(s0)
    80200676:	0007871b          	sext.w	a4,a5
    8020067a:	02500793          	li	a5,37
    8020067e:	28f74f63          	blt	a4,a5,8020091c <printf+0x384>
    80200682:	fe842783          	lw	a5,-24(s0)
    80200686:	0007871b          	sext.w	a4,a5
    8020068a:	07800793          	li	a5,120
    8020068e:	28e7c763          	blt	a5,a4,8020091c <printf+0x384>
    80200692:	fe842783          	lw	a5,-24(s0)
    80200696:	0007871b          	sext.w	a4,a5
    8020069a:	06200793          	li	a5,98
    8020069e:	26f74f63          	blt	a4,a5,8020091c <printf+0x384>
    802006a2:	fe842783          	lw	a5,-24(s0)
    802006a6:	f9e7869b          	addiw	a3,a5,-98
    802006aa:	0006871b          	sext.w	a4,a3
    802006ae:	47d9                	li	a5,22
    802006b0:	26e7e663          	bltu	a5,a4,8020091c <printf+0x384>
    802006b4:	02069793          	slli	a5,a3,0x20
    802006b8:	9381                	srli	a5,a5,0x20
    802006ba:	00279713          	slli	a4,a5,0x2
    802006be:	00005797          	auipc	a5,0x5
    802006c2:	d1678793          	addi	a5,a5,-746 # 802053d4 <small_numbers+0x1b4>
    802006c6:	97ba                	add	a5,a5,a4
    802006c8:	439c                	lw	a5,0(a5)
    802006ca:	0007871b          	sext.w	a4,a5
    802006ce:	00005797          	auipc	a5,0x5
    802006d2:	d0678793          	addi	a5,a5,-762 # 802053d4 <small_numbers+0x1b4>
    802006d6:	97ba                	add	a5,a5,a4
    802006d8:	8782                	jr	a5
        case 'd':
            if(is_long)
    802006da:	fdc42783          	lw	a5,-36(s0)
    802006de:	2781                	sext.w	a5,a5
    802006e0:	c385                	beqz	a5,80200700 <printf+0x168>
                printint(va_arg(ap, long long), 10, 1);
    802006e2:	fc043783          	ld	a5,-64(s0)
    802006e6:	00878713          	addi	a4,a5,8
    802006ea:	fce43023          	sd	a4,-64(s0)
    802006ee:	639c                	ld	a5,0(a5)
    802006f0:	4605                	li	a2,1
    802006f2:	45a9                	li	a1,10
    802006f4:	853e                	mv	a0,a5
    802006f6:	00000097          	auipc	ra,0x0
    802006fa:	d70080e7          	jalr	-656(ra) # 80200466 <printint>
            else
                printint(va_arg(ap, int), 10, 1);
            break;
    802006fe:	ac89                	j	80200950 <printf+0x3b8>
                printint(va_arg(ap, int), 10, 1);
    80200700:	fc043783          	ld	a5,-64(s0)
    80200704:	00878713          	addi	a4,a5,8
    80200708:	fce43023          	sd	a4,-64(s0)
    8020070c:	439c                	lw	a5,0(a5)
    8020070e:	4605                	li	a2,1
    80200710:	45a9                	li	a1,10
    80200712:	853e                	mv	a0,a5
    80200714:	00000097          	auipc	ra,0x0
    80200718:	d52080e7          	jalr	-686(ra) # 80200466 <printint>
            break;
    8020071c:	ac15                	j	80200950 <printf+0x3b8>
        case 'x':
            if(is_long)
    8020071e:	fdc42783          	lw	a5,-36(s0)
    80200722:	2781                	sext.w	a5,a5
    80200724:	c385                	beqz	a5,80200744 <printf+0x1ac>
                printint(va_arg(ap, long long), 16, 0);
    80200726:	fc043783          	ld	a5,-64(s0)
    8020072a:	00878713          	addi	a4,a5,8
    8020072e:	fce43023          	sd	a4,-64(s0)
    80200732:	639c                	ld	a5,0(a5)
    80200734:	4601                	li	a2,0
    80200736:	45c1                	li	a1,16
    80200738:	853e                	mv	a0,a5
    8020073a:	00000097          	auipc	ra,0x0
    8020073e:	d2c080e7          	jalr	-724(ra) # 80200466 <printint>
            else
                printint(va_arg(ap, int), 16, 0);
            break;
    80200742:	a439                	j	80200950 <printf+0x3b8>
                printint(va_arg(ap, int), 16, 0);
    80200744:	fc043783          	ld	a5,-64(s0)
    80200748:	00878713          	addi	a4,a5,8
    8020074c:	fce43023          	sd	a4,-64(s0)
    80200750:	439c                	lw	a5,0(a5)
    80200752:	4601                	li	a2,0
    80200754:	45c1                	li	a1,16
    80200756:	853e                	mv	a0,a5
    80200758:	00000097          	auipc	ra,0x0
    8020075c:	d0e080e7          	jalr	-754(ra) # 80200466 <printint>
            break;
    80200760:	aac5                	j	80200950 <printf+0x3b8>
        case 'u':
            if(is_long)
    80200762:	fdc42783          	lw	a5,-36(s0)
    80200766:	2781                	sext.w	a5,a5
    80200768:	c385                	beqz	a5,80200788 <printf+0x1f0>
                printint(va_arg(ap, unsigned long long), 10, 0);
    8020076a:	fc043783          	ld	a5,-64(s0)
    8020076e:	00878713          	addi	a4,a5,8
    80200772:	fce43023          	sd	a4,-64(s0)
    80200776:	639c                	ld	a5,0(a5)
    80200778:	4601                	li	a2,0
    8020077a:	45a9                	li	a1,10
    8020077c:	853e                	mv	a0,a5
    8020077e:	00000097          	auipc	ra,0x0
    80200782:	ce8080e7          	jalr	-792(ra) # 80200466 <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0);
            break;
    80200786:	a2e9                	j	80200950 <printf+0x3b8>
                printint(va_arg(ap, unsigned int), 10, 0);
    80200788:	fc043783          	ld	a5,-64(s0)
    8020078c:	00878713          	addi	a4,a5,8
    80200790:	fce43023          	sd	a4,-64(s0)
    80200794:	439c                	lw	a5,0(a5)
    80200796:	1782                	slli	a5,a5,0x20
    80200798:	9381                	srli	a5,a5,0x20
    8020079a:	4601                	li	a2,0
    8020079c:	45a9                	li	a1,10
    8020079e:	853e                	mv	a0,a5
    802007a0:	00000097          	auipc	ra,0x0
    802007a4:	cc6080e7          	jalr	-826(ra) # 80200466 <printint>
            break;
    802007a8:	a265                	j	80200950 <printf+0x3b8>
        case 'c':
            consputc(va_arg(ap, int));
    802007aa:	fc043783          	ld	a5,-64(s0)
    802007ae:	00878713          	addi	a4,a5,8
    802007b2:	fce43023          	sd	a4,-64(s0)
    802007b6:	439c                	lw	a5,0(a5)
    802007b8:	853e                	mv	a0,a5
    802007ba:	00000097          	auipc	ra,0x0
    802007be:	c58080e7          	jalr	-936(ra) # 80200412 <consputc>
            break;
    802007c2:	a279                	j	80200950 <printf+0x3b8>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    802007c4:	fc043783          	ld	a5,-64(s0)
    802007c8:	00878713          	addi	a4,a5,8
    802007cc:	fce43023          	sd	a4,-64(s0)
    802007d0:	639c                	ld	a5,0(a5)
    802007d2:	fef43023          	sd	a5,-32(s0)
    802007d6:	fe043783          	ld	a5,-32(s0)
    802007da:	e799                	bnez	a5,802007e8 <printf+0x250>
                s = "(null)";
    802007dc:	00005797          	auipc	a5,0x5
    802007e0:	bd478793          	addi	a5,a5,-1068 # 802053b0 <small_numbers+0x190>
    802007e4:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    802007e8:	fe043503          	ld	a0,-32(s0)
    802007ec:	00000097          	auipc	ra,0x0
    802007f0:	c50080e7          	jalr	-944(ra) # 8020043c <consputs>
            break;
    802007f4:	aab1                	j	80200950 <printf+0x3b8>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    802007f6:	fc043783          	ld	a5,-64(s0)
    802007fa:	00878713          	addi	a4,a5,8
    802007fe:	fce43023          	sd	a4,-64(s0)
    80200802:	639c                	ld	a5,0(a5)
    80200804:	fcf43823          	sd	a5,-48(s0)
            consputs("0x");
    80200808:	00005517          	auipc	a0,0x5
    8020080c:	bb050513          	addi	a0,a0,-1104 # 802053b8 <small_numbers+0x198>
    80200810:	00000097          	auipc	ra,0x0
    80200814:	c2c080e7          	jalr	-980(ra) # 8020043c <consputs>
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    80200818:	fc042c23          	sw	zero,-40(s0)
    8020081c:	a0a1                	j	80200864 <printf+0x2cc>
                int shift = (15 - i) * 4;
    8020081e:	47bd                	li	a5,15
    80200820:	fd842703          	lw	a4,-40(s0)
    80200824:	9f99                	subw	a5,a5,a4
    80200826:	2781                	sext.w	a5,a5
    80200828:	0027979b          	slliw	a5,a5,0x2
    8020082c:	fcf42623          	sw	a5,-52(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80200830:	fcc42783          	lw	a5,-52(s0)
    80200834:	873e                	mv	a4,a5
    80200836:	fd043783          	ld	a5,-48(s0)
    8020083a:	00e7d7b3          	srl	a5,a5,a4
    8020083e:	8bbd                	andi	a5,a5,15
    80200840:	00005717          	auipc	a4,0x5
    80200844:	b8070713          	addi	a4,a4,-1152 # 802053c0 <small_numbers+0x1a0>
    80200848:	97ba                	add	a5,a5,a4
    8020084a:	0007c703          	lbu	a4,0(a5)
    8020084e:	fd842783          	lw	a5,-40(s0)
    80200852:	17c1                	addi	a5,a5,-16
    80200854:	97a2                	add	a5,a5,s0
    80200856:	fae78c23          	sb	a4,-72(a5)
            for (i = 0; i < 16; i++) {
    8020085a:	fd842783          	lw	a5,-40(s0)
    8020085e:	2785                	addiw	a5,a5,1
    80200860:	fcf42c23          	sw	a5,-40(s0)
    80200864:	fd842783          	lw	a5,-40(s0)
    80200868:	0007871b          	sext.w	a4,a5
    8020086c:	47bd                	li	a5,15
    8020086e:	fae7d8e3          	bge	a5,a4,8020081e <printf+0x286>
            }
            buf[16] = '\0';
    80200872:	fa040c23          	sb	zero,-72(s0)
            consputs(buf);
    80200876:	fa840793          	addi	a5,s0,-88
    8020087a:	853e                	mv	a0,a5
    8020087c:	00000097          	auipc	ra,0x0
    80200880:	bc0080e7          	jalr	-1088(ra) # 8020043c <consputs>
            break;
    80200884:	a0f1                	j	80200950 <printf+0x3b8>
        case 'b':
            if(is_long)
    80200886:	fdc42783          	lw	a5,-36(s0)
    8020088a:	2781                	sext.w	a5,a5
    8020088c:	c385                	beqz	a5,802008ac <printf+0x314>
                printint(va_arg(ap, long long), 2, 0);
    8020088e:	fc043783          	ld	a5,-64(s0)
    80200892:	00878713          	addi	a4,a5,8
    80200896:	fce43023          	sd	a4,-64(s0)
    8020089a:	639c                	ld	a5,0(a5)
    8020089c:	4601                	li	a2,0
    8020089e:	4589                	li	a1,2
    802008a0:	853e                	mv	a0,a5
    802008a2:	00000097          	auipc	ra,0x0
    802008a6:	bc4080e7          	jalr	-1084(ra) # 80200466 <printint>
            else
                printint(va_arg(ap, int), 2, 0);
            break;
    802008aa:	a05d                	j	80200950 <printf+0x3b8>
                printint(va_arg(ap, int), 2, 0);
    802008ac:	fc043783          	ld	a5,-64(s0)
    802008b0:	00878713          	addi	a4,a5,8
    802008b4:	fce43023          	sd	a4,-64(s0)
    802008b8:	439c                	lw	a5,0(a5)
    802008ba:	4601                	li	a2,0
    802008bc:	4589                	li	a1,2
    802008be:	853e                	mv	a0,a5
    802008c0:	00000097          	auipc	ra,0x0
    802008c4:	ba6080e7          	jalr	-1114(ra) # 80200466 <printint>
            break;
    802008c8:	a061                	j	80200950 <printf+0x3b8>
        case 'o':
            if(is_long)
    802008ca:	fdc42783          	lw	a5,-36(s0)
    802008ce:	2781                	sext.w	a5,a5
    802008d0:	c385                	beqz	a5,802008f0 <printf+0x358>
                printint(va_arg(ap, long long), 8, 0);
    802008d2:	fc043783          	ld	a5,-64(s0)
    802008d6:	00878713          	addi	a4,a5,8
    802008da:	fce43023          	sd	a4,-64(s0)
    802008de:	639c                	ld	a5,0(a5)
    802008e0:	4601                	li	a2,0
    802008e2:	45a1                	li	a1,8
    802008e4:	853e                	mv	a0,a5
    802008e6:	00000097          	auipc	ra,0x0
    802008ea:	b80080e7          	jalr	-1152(ra) # 80200466 <printint>
            else
                printint(va_arg(ap, int), 8, 0);
            break;
    802008ee:	a08d                	j	80200950 <printf+0x3b8>
                printint(va_arg(ap, int), 8, 0);
    802008f0:	fc043783          	ld	a5,-64(s0)
    802008f4:	00878713          	addi	a4,a5,8
    802008f8:	fce43023          	sd	a4,-64(s0)
    802008fc:	439c                	lw	a5,0(a5)
    802008fe:	4601                	li	a2,0
    80200900:	45a1                	li	a1,8
    80200902:	853e                	mv	a0,a5
    80200904:	00000097          	auipc	ra,0x0
    80200908:	b62080e7          	jalr	-1182(ra) # 80200466 <printint>
            break;
    8020090c:	a091                	j	80200950 <printf+0x3b8>
        case '%':
            buffer_char('%');
    8020090e:	02500513          	li	a0,37
    80200912:	00000097          	auipc	ra,0x0
    80200916:	a6e080e7          	jalr	-1426(ra) # 80200380 <buffer_char>
            break;
    8020091a:	a81d                	j	80200950 <printf+0x3b8>
        default:
            buffer_char('%');
    8020091c:	02500513          	li	a0,37
    80200920:	00000097          	auipc	ra,0x0
    80200924:	a60080e7          	jalr	-1440(ra) # 80200380 <buffer_char>
            if(is_long) buffer_char('l');
    80200928:	fdc42783          	lw	a5,-36(s0)
    8020092c:	2781                	sext.w	a5,a5
    8020092e:	c799                	beqz	a5,8020093c <printf+0x3a4>
    80200930:	06c00513          	li	a0,108
    80200934:	00000097          	auipc	ra,0x0
    80200938:	a4c080e7          	jalr	-1460(ra) # 80200380 <buffer_char>
            buffer_char(c);
    8020093c:	fe842783          	lw	a5,-24(s0)
    80200940:	0ff7f793          	zext.b	a5,a5
    80200944:	853e                	mv	a0,a5
    80200946:	00000097          	auipc	ra,0x0
    8020094a:	a3a080e7          	jalr	-1478(ra) # 80200380 <buffer_char>
            break;
    8020094e:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200950:	fec42783          	lw	a5,-20(s0)
    80200954:	2785                	addiw	a5,a5,1
    80200956:	fef42623          	sw	a5,-20(s0)
    8020095a:	fec42783          	lw	a5,-20(s0)
    8020095e:	f9843703          	ld	a4,-104(s0)
    80200962:	97ba                	add	a5,a5,a4
    80200964:	0007c783          	lbu	a5,0(a5)
    80200968:	fef42423          	sw	a5,-24(s0)
    8020096c:	fe842783          	lw	a5,-24(s0)
    80200970:	2781                	sext.w	a5,a5
    80200972:	c4079fe3          	bnez	a5,802005d0 <printf+0x38>
    80200976:	a021                	j	8020097e <printf+0x3e6>
            break;
    80200978:	0001                	nop
    8020097a:	a011                	j	8020097e <printf+0x3e6>
                break;
    8020097c:	0001                	nop
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    8020097e:	00000097          	auipc	ra,0x0
    80200982:	9ae080e7          	jalr	-1618(ra) # 8020032c <flush_printf_buffer>
    va_end(ap);
}
    80200986:	0001                	nop
    80200988:	70a6                	ld	ra,104(sp)
    8020098a:	7406                	ld	s0,96(sp)
    8020098c:	614d                	addi	sp,sp,176
    8020098e:	8082                	ret

0000000080200990 <clear_screen>:
// 清屏功能
void clear_screen(void) {
    80200990:	1141                	addi	sp,sp,-16
    80200992:	e406                	sd	ra,8(sp)
    80200994:	e022                	sd	s0,0(sp)
    80200996:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    80200998:	00005517          	auipc	a0,0x5
    8020099c:	a9850513          	addi	a0,a0,-1384 # 80205430 <small_numbers+0x210>
    802009a0:	00000097          	auipc	ra,0x0
    802009a4:	88e080e7          	jalr	-1906(ra) # 8020022e <uart_puts>
	uart_puts(CURSOR_HOME);
    802009a8:	00005517          	auipc	a0,0x5
    802009ac:	a9050513          	addi	a0,a0,-1392 # 80205438 <small_numbers+0x218>
    802009b0:	00000097          	auipc	ra,0x0
    802009b4:	87e080e7          	jalr	-1922(ra) # 8020022e <uart_puts>
}
    802009b8:	0001                	nop
    802009ba:	60a2                	ld	ra,8(sp)
    802009bc:	6402                	ld	s0,0(sp)
    802009be:	0141                	addi	sp,sp,16
    802009c0:	8082                	ret

00000000802009c2 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    802009c2:	1101                	addi	sp,sp,-32
    802009c4:	ec06                	sd	ra,24(sp)
    802009c6:	e822                	sd	s0,16(sp)
    802009c8:	1000                	addi	s0,sp,32
    802009ca:	87aa                	mv	a5,a0
    802009cc:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    802009d0:	fec42783          	lw	a5,-20(s0)
    802009d4:	2781                	sext.w	a5,a5
    802009d6:	02f05d63          	blez	a5,80200a10 <cursor_up+0x4e>
    consputc('\033');
    802009da:	456d                	li	a0,27
    802009dc:	00000097          	auipc	ra,0x0
    802009e0:	a36080e7          	jalr	-1482(ra) # 80200412 <consputc>
    consputc('[');
    802009e4:	05b00513          	li	a0,91
    802009e8:	00000097          	auipc	ra,0x0
    802009ec:	a2a080e7          	jalr	-1494(ra) # 80200412 <consputc>
    printint(lines, 10, 0);
    802009f0:	fec42783          	lw	a5,-20(s0)
    802009f4:	4601                	li	a2,0
    802009f6:	45a9                	li	a1,10
    802009f8:	853e                	mv	a0,a5
    802009fa:	00000097          	auipc	ra,0x0
    802009fe:	a6c080e7          	jalr	-1428(ra) # 80200466 <printint>
    consputc('A');
    80200a02:	04100513          	li	a0,65
    80200a06:	00000097          	auipc	ra,0x0
    80200a0a:	a0c080e7          	jalr	-1524(ra) # 80200412 <consputc>
    80200a0e:	a011                	j	80200a12 <cursor_up+0x50>
    if (lines <= 0) return;
    80200a10:	0001                	nop
}
    80200a12:	60e2                	ld	ra,24(sp)
    80200a14:	6442                	ld	s0,16(sp)
    80200a16:	6105                	addi	sp,sp,32
    80200a18:	8082                	ret

0000000080200a1a <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    80200a1a:	1101                	addi	sp,sp,-32
    80200a1c:	ec06                	sd	ra,24(sp)
    80200a1e:	e822                	sd	s0,16(sp)
    80200a20:	1000                	addi	s0,sp,32
    80200a22:	87aa                	mv	a5,a0
    80200a24:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    80200a28:	fec42783          	lw	a5,-20(s0)
    80200a2c:	2781                	sext.w	a5,a5
    80200a2e:	02f05d63          	blez	a5,80200a68 <cursor_down+0x4e>
    consputc('\033');
    80200a32:	456d                	li	a0,27
    80200a34:	00000097          	auipc	ra,0x0
    80200a38:	9de080e7          	jalr	-1570(ra) # 80200412 <consputc>
    consputc('[');
    80200a3c:	05b00513          	li	a0,91
    80200a40:	00000097          	auipc	ra,0x0
    80200a44:	9d2080e7          	jalr	-1582(ra) # 80200412 <consputc>
    printint(lines, 10, 0);
    80200a48:	fec42783          	lw	a5,-20(s0)
    80200a4c:	4601                	li	a2,0
    80200a4e:	45a9                	li	a1,10
    80200a50:	853e                	mv	a0,a5
    80200a52:	00000097          	auipc	ra,0x0
    80200a56:	a14080e7          	jalr	-1516(ra) # 80200466 <printint>
    consputc('B');
    80200a5a:	04200513          	li	a0,66
    80200a5e:	00000097          	auipc	ra,0x0
    80200a62:	9b4080e7          	jalr	-1612(ra) # 80200412 <consputc>
    80200a66:	a011                	j	80200a6a <cursor_down+0x50>
    if (lines <= 0) return;
    80200a68:	0001                	nop
}
    80200a6a:	60e2                	ld	ra,24(sp)
    80200a6c:	6442                	ld	s0,16(sp)
    80200a6e:	6105                	addi	sp,sp,32
    80200a70:	8082                	ret

0000000080200a72 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    80200a72:	1101                	addi	sp,sp,-32
    80200a74:	ec06                	sd	ra,24(sp)
    80200a76:	e822                	sd	s0,16(sp)
    80200a78:	1000                	addi	s0,sp,32
    80200a7a:	87aa                	mv	a5,a0
    80200a7c:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80200a80:	fec42783          	lw	a5,-20(s0)
    80200a84:	2781                	sext.w	a5,a5
    80200a86:	02f05d63          	blez	a5,80200ac0 <cursor_right+0x4e>
    consputc('\033');
    80200a8a:	456d                	li	a0,27
    80200a8c:	00000097          	auipc	ra,0x0
    80200a90:	986080e7          	jalr	-1658(ra) # 80200412 <consputc>
    consputc('[');
    80200a94:	05b00513          	li	a0,91
    80200a98:	00000097          	auipc	ra,0x0
    80200a9c:	97a080e7          	jalr	-1670(ra) # 80200412 <consputc>
    printint(cols, 10, 0);
    80200aa0:	fec42783          	lw	a5,-20(s0)
    80200aa4:	4601                	li	a2,0
    80200aa6:	45a9                	li	a1,10
    80200aa8:	853e                	mv	a0,a5
    80200aaa:	00000097          	auipc	ra,0x0
    80200aae:	9bc080e7          	jalr	-1604(ra) # 80200466 <printint>
    consputc('C');
    80200ab2:	04300513          	li	a0,67
    80200ab6:	00000097          	auipc	ra,0x0
    80200aba:	95c080e7          	jalr	-1700(ra) # 80200412 <consputc>
    80200abe:	a011                	j	80200ac2 <cursor_right+0x50>
    if (cols <= 0) return;
    80200ac0:	0001                	nop
}
    80200ac2:	60e2                	ld	ra,24(sp)
    80200ac4:	6442                	ld	s0,16(sp)
    80200ac6:	6105                	addi	sp,sp,32
    80200ac8:	8082                	ret

0000000080200aca <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    80200aca:	1101                	addi	sp,sp,-32
    80200acc:	ec06                	sd	ra,24(sp)
    80200ace:	e822                	sd	s0,16(sp)
    80200ad0:	1000                	addi	s0,sp,32
    80200ad2:	87aa                	mv	a5,a0
    80200ad4:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80200ad8:	fec42783          	lw	a5,-20(s0)
    80200adc:	2781                	sext.w	a5,a5
    80200ade:	02f05d63          	blez	a5,80200b18 <cursor_left+0x4e>
    consputc('\033');
    80200ae2:	456d                	li	a0,27
    80200ae4:	00000097          	auipc	ra,0x0
    80200ae8:	92e080e7          	jalr	-1746(ra) # 80200412 <consputc>
    consputc('[');
    80200aec:	05b00513          	li	a0,91
    80200af0:	00000097          	auipc	ra,0x0
    80200af4:	922080e7          	jalr	-1758(ra) # 80200412 <consputc>
    printint(cols, 10, 0);
    80200af8:	fec42783          	lw	a5,-20(s0)
    80200afc:	4601                	li	a2,0
    80200afe:	45a9                	li	a1,10
    80200b00:	853e                	mv	a0,a5
    80200b02:	00000097          	auipc	ra,0x0
    80200b06:	964080e7          	jalr	-1692(ra) # 80200466 <printint>
    consputc('D');
    80200b0a:	04400513          	li	a0,68
    80200b0e:	00000097          	auipc	ra,0x0
    80200b12:	904080e7          	jalr	-1788(ra) # 80200412 <consputc>
    80200b16:	a011                	j	80200b1a <cursor_left+0x50>
    if (cols <= 0) return;
    80200b18:	0001                	nop
}
    80200b1a:	60e2                	ld	ra,24(sp)
    80200b1c:	6442                	ld	s0,16(sp)
    80200b1e:	6105                	addi	sp,sp,32
    80200b20:	8082                	ret

0000000080200b22 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    80200b22:	1141                	addi	sp,sp,-16
    80200b24:	e406                	sd	ra,8(sp)
    80200b26:	e022                	sd	s0,0(sp)
    80200b28:	0800                	addi	s0,sp,16
    consputc('\033');
    80200b2a:	456d                	li	a0,27
    80200b2c:	00000097          	auipc	ra,0x0
    80200b30:	8e6080e7          	jalr	-1818(ra) # 80200412 <consputc>
    consputc('[');
    80200b34:	05b00513          	li	a0,91
    80200b38:	00000097          	auipc	ra,0x0
    80200b3c:	8da080e7          	jalr	-1830(ra) # 80200412 <consputc>
    consputc('s');
    80200b40:	07300513          	li	a0,115
    80200b44:	00000097          	auipc	ra,0x0
    80200b48:	8ce080e7          	jalr	-1842(ra) # 80200412 <consputc>
}
    80200b4c:	0001                	nop
    80200b4e:	60a2                	ld	ra,8(sp)
    80200b50:	6402                	ld	s0,0(sp)
    80200b52:	0141                	addi	sp,sp,16
    80200b54:	8082                	ret

0000000080200b56 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    80200b56:	1141                	addi	sp,sp,-16
    80200b58:	e406                	sd	ra,8(sp)
    80200b5a:	e022                	sd	s0,0(sp)
    80200b5c:	0800                	addi	s0,sp,16
    consputc('\033');
    80200b5e:	456d                	li	a0,27
    80200b60:	00000097          	auipc	ra,0x0
    80200b64:	8b2080e7          	jalr	-1870(ra) # 80200412 <consputc>
    consputc('[');
    80200b68:	05b00513          	li	a0,91
    80200b6c:	00000097          	auipc	ra,0x0
    80200b70:	8a6080e7          	jalr	-1882(ra) # 80200412 <consputc>
    consputc('u');
    80200b74:	07500513          	li	a0,117
    80200b78:	00000097          	auipc	ra,0x0
    80200b7c:	89a080e7          	jalr	-1894(ra) # 80200412 <consputc>
}
    80200b80:	0001                	nop
    80200b82:	60a2                	ld	ra,8(sp)
    80200b84:	6402                	ld	s0,0(sp)
    80200b86:	0141                	addi	sp,sp,16
    80200b88:	8082                	ret

0000000080200b8a <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    80200b8a:	1101                	addi	sp,sp,-32
    80200b8c:	ec06                	sd	ra,24(sp)
    80200b8e:	e822                	sd	s0,16(sp)
    80200b90:	1000                	addi	s0,sp,32
    80200b92:	87aa                	mv	a5,a0
    80200b94:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    80200b98:	fec42783          	lw	a5,-20(s0)
    80200b9c:	2781                	sext.w	a5,a5
    80200b9e:	00f04563          	bgtz	a5,80200ba8 <cursor_to_column+0x1e>
    80200ba2:	4785                	li	a5,1
    80200ba4:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    80200ba8:	456d                	li	a0,27
    80200baa:	00000097          	auipc	ra,0x0
    80200bae:	868080e7          	jalr	-1944(ra) # 80200412 <consputc>
    consputc('[');
    80200bb2:	05b00513          	li	a0,91
    80200bb6:	00000097          	auipc	ra,0x0
    80200bba:	85c080e7          	jalr	-1956(ra) # 80200412 <consputc>
    printint(col, 10, 0);
    80200bbe:	fec42783          	lw	a5,-20(s0)
    80200bc2:	4601                	li	a2,0
    80200bc4:	45a9                	li	a1,10
    80200bc6:	853e                	mv	a0,a5
    80200bc8:	00000097          	auipc	ra,0x0
    80200bcc:	89e080e7          	jalr	-1890(ra) # 80200466 <printint>
    consputc('G');
    80200bd0:	04700513          	li	a0,71
    80200bd4:	00000097          	auipc	ra,0x0
    80200bd8:	83e080e7          	jalr	-1986(ra) # 80200412 <consputc>
}
    80200bdc:	0001                	nop
    80200bde:	60e2                	ld	ra,24(sp)
    80200be0:	6442                	ld	s0,16(sp)
    80200be2:	6105                	addi	sp,sp,32
    80200be4:	8082                	ret

0000000080200be6 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80200be6:	1101                	addi	sp,sp,-32
    80200be8:	ec06                	sd	ra,24(sp)
    80200bea:	e822                	sd	s0,16(sp)
    80200bec:	1000                	addi	s0,sp,32
    80200bee:	87aa                	mv	a5,a0
    80200bf0:	872e                	mv	a4,a1
    80200bf2:	fef42623          	sw	a5,-20(s0)
    80200bf6:	87ba                	mv	a5,a4
    80200bf8:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    80200bfc:	456d                	li	a0,27
    80200bfe:	00000097          	auipc	ra,0x0
    80200c02:	814080e7          	jalr	-2028(ra) # 80200412 <consputc>
    consputc('[');
    80200c06:	05b00513          	li	a0,91
    80200c0a:	00000097          	auipc	ra,0x0
    80200c0e:	808080e7          	jalr	-2040(ra) # 80200412 <consputc>
    printint(row, 10, 0);
    80200c12:	fec42783          	lw	a5,-20(s0)
    80200c16:	4601                	li	a2,0
    80200c18:	45a9                	li	a1,10
    80200c1a:	853e                	mv	a0,a5
    80200c1c:	00000097          	auipc	ra,0x0
    80200c20:	84a080e7          	jalr	-1974(ra) # 80200466 <printint>
    consputc(';');
    80200c24:	03b00513          	li	a0,59
    80200c28:	fffff097          	auipc	ra,0xfffff
    80200c2c:	7ea080e7          	jalr	2026(ra) # 80200412 <consputc>
    printint(col, 10, 0);
    80200c30:	fe842783          	lw	a5,-24(s0)
    80200c34:	4601                	li	a2,0
    80200c36:	45a9                	li	a1,10
    80200c38:	853e                	mv	a0,a5
    80200c3a:	00000097          	auipc	ra,0x0
    80200c3e:	82c080e7          	jalr	-2004(ra) # 80200466 <printint>
    consputc('H');
    80200c42:	04800513          	li	a0,72
    80200c46:	fffff097          	auipc	ra,0xfffff
    80200c4a:	7cc080e7          	jalr	1996(ra) # 80200412 <consputc>
}
    80200c4e:	0001                	nop
    80200c50:	60e2                	ld	ra,24(sp)
    80200c52:	6442                	ld	s0,16(sp)
    80200c54:	6105                	addi	sp,sp,32
    80200c56:	8082                	ret

0000000080200c58 <reset_color>:
// 颜色控制
void reset_color(void) {
    80200c58:	1141                	addi	sp,sp,-16
    80200c5a:	e406                	sd	ra,8(sp)
    80200c5c:	e022                	sd	s0,0(sp)
    80200c5e:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    80200c60:	00004517          	auipc	a0,0x4
    80200c64:	7e050513          	addi	a0,a0,2016 # 80205440 <small_numbers+0x220>
    80200c68:	fffff097          	auipc	ra,0xfffff
    80200c6c:	5c6080e7          	jalr	1478(ra) # 8020022e <uart_puts>
}
    80200c70:	0001                	nop
    80200c72:	60a2                	ld	ra,8(sp)
    80200c74:	6402                	ld	s0,0(sp)
    80200c76:	0141                	addi	sp,sp,16
    80200c78:	8082                	ret

0000000080200c7a <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    80200c7a:	1101                	addi	sp,sp,-32
    80200c7c:	ec06                	sd	ra,24(sp)
    80200c7e:	e822                	sd	s0,16(sp)
    80200c80:	1000                	addi	s0,sp,32
    80200c82:	87aa                	mv	a5,a0
    80200c84:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    80200c88:	fec42783          	lw	a5,-20(s0)
    80200c8c:	0007871b          	sext.w	a4,a5
    80200c90:	47f5                	li	a5,29
    80200c92:	04e7d563          	bge	a5,a4,80200cdc <set_fg_color+0x62>
    80200c96:	fec42783          	lw	a5,-20(s0)
    80200c9a:	0007871b          	sext.w	a4,a5
    80200c9e:	02500793          	li	a5,37
    80200ca2:	02e7cd63          	blt	a5,a4,80200cdc <set_fg_color+0x62>
	consputc('\033');
    80200ca6:	456d                	li	a0,27
    80200ca8:	fffff097          	auipc	ra,0xfffff
    80200cac:	76a080e7          	jalr	1898(ra) # 80200412 <consputc>
	consputc('[');
    80200cb0:	05b00513          	li	a0,91
    80200cb4:	fffff097          	auipc	ra,0xfffff
    80200cb8:	75e080e7          	jalr	1886(ra) # 80200412 <consputc>
	printint(color, 10, 0);
    80200cbc:	fec42783          	lw	a5,-20(s0)
    80200cc0:	4601                	li	a2,0
    80200cc2:	45a9                	li	a1,10
    80200cc4:	853e                	mv	a0,a5
    80200cc6:	fffff097          	auipc	ra,0xfffff
    80200cca:	7a0080e7          	jalr	1952(ra) # 80200466 <printint>
	consputc('m');
    80200cce:	06d00513          	li	a0,109
    80200cd2:	fffff097          	auipc	ra,0xfffff
    80200cd6:	740080e7          	jalr	1856(ra) # 80200412 <consputc>
    80200cda:	a011                	j	80200cde <set_fg_color+0x64>
	if (color < 30 || color > 37) return; // 支持30-37
    80200cdc:	0001                	nop
}
    80200cde:	60e2                	ld	ra,24(sp)
    80200ce0:	6442                	ld	s0,16(sp)
    80200ce2:	6105                	addi	sp,sp,32
    80200ce4:	8082                	ret

0000000080200ce6 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    80200ce6:	1101                	addi	sp,sp,-32
    80200ce8:	ec06                	sd	ra,24(sp)
    80200cea:	e822                	sd	s0,16(sp)
    80200cec:	1000                	addi	s0,sp,32
    80200cee:	87aa                	mv	a5,a0
    80200cf0:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    80200cf4:	fec42783          	lw	a5,-20(s0)
    80200cf8:	0007871b          	sext.w	a4,a5
    80200cfc:	02700793          	li	a5,39
    80200d00:	04e7d563          	bge	a5,a4,80200d4a <set_bg_color+0x64>
    80200d04:	fec42783          	lw	a5,-20(s0)
    80200d08:	0007871b          	sext.w	a4,a5
    80200d0c:	02f00793          	li	a5,47
    80200d10:	02e7cd63          	blt	a5,a4,80200d4a <set_bg_color+0x64>
	consputc('\033');
    80200d14:	456d                	li	a0,27
    80200d16:	fffff097          	auipc	ra,0xfffff
    80200d1a:	6fc080e7          	jalr	1788(ra) # 80200412 <consputc>
	consputc('[');
    80200d1e:	05b00513          	li	a0,91
    80200d22:	fffff097          	auipc	ra,0xfffff
    80200d26:	6f0080e7          	jalr	1776(ra) # 80200412 <consputc>
	printint(color, 10, 0);
    80200d2a:	fec42783          	lw	a5,-20(s0)
    80200d2e:	4601                	li	a2,0
    80200d30:	45a9                	li	a1,10
    80200d32:	853e                	mv	a0,a5
    80200d34:	fffff097          	auipc	ra,0xfffff
    80200d38:	732080e7          	jalr	1842(ra) # 80200466 <printint>
	consputc('m');
    80200d3c:	06d00513          	li	a0,109
    80200d40:	fffff097          	auipc	ra,0xfffff
    80200d44:	6d2080e7          	jalr	1746(ra) # 80200412 <consputc>
    80200d48:	a011                	j	80200d4c <set_bg_color+0x66>
	if (color < 40 || color > 47) return; // 支持40-47
    80200d4a:	0001                	nop
}
    80200d4c:	60e2                	ld	ra,24(sp)
    80200d4e:	6442                	ld	s0,16(sp)
    80200d50:	6105                	addi	sp,sp,32
    80200d52:	8082                	ret

0000000080200d54 <color_red>:
// 简易文字颜色
void color_red(void) {
    80200d54:	1141                	addi	sp,sp,-16
    80200d56:	e406                	sd	ra,8(sp)
    80200d58:	e022                	sd	s0,0(sp)
    80200d5a:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    80200d5c:	457d                	li	a0,31
    80200d5e:	00000097          	auipc	ra,0x0
    80200d62:	f1c080e7          	jalr	-228(ra) # 80200c7a <set_fg_color>
}
    80200d66:	0001                	nop
    80200d68:	60a2                	ld	ra,8(sp)
    80200d6a:	6402                	ld	s0,0(sp)
    80200d6c:	0141                	addi	sp,sp,16
    80200d6e:	8082                	ret

0000000080200d70 <color_green>:
void color_green(void) {
    80200d70:	1141                	addi	sp,sp,-16
    80200d72:	e406                	sd	ra,8(sp)
    80200d74:	e022                	sd	s0,0(sp)
    80200d76:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    80200d78:	02000513          	li	a0,32
    80200d7c:	00000097          	auipc	ra,0x0
    80200d80:	efe080e7          	jalr	-258(ra) # 80200c7a <set_fg_color>
}
    80200d84:	0001                	nop
    80200d86:	60a2                	ld	ra,8(sp)
    80200d88:	6402                	ld	s0,0(sp)
    80200d8a:	0141                	addi	sp,sp,16
    80200d8c:	8082                	ret

0000000080200d8e <color_yellow>:
void color_yellow(void) {
    80200d8e:	1141                	addi	sp,sp,-16
    80200d90:	e406                	sd	ra,8(sp)
    80200d92:	e022                	sd	s0,0(sp)
    80200d94:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    80200d96:	02100513          	li	a0,33
    80200d9a:	00000097          	auipc	ra,0x0
    80200d9e:	ee0080e7          	jalr	-288(ra) # 80200c7a <set_fg_color>
}
    80200da2:	0001                	nop
    80200da4:	60a2                	ld	ra,8(sp)
    80200da6:	6402                	ld	s0,0(sp)
    80200da8:	0141                	addi	sp,sp,16
    80200daa:	8082                	ret

0000000080200dac <color_blue>:
void color_blue(void) {
    80200dac:	1141                	addi	sp,sp,-16
    80200dae:	e406                	sd	ra,8(sp)
    80200db0:	e022                	sd	s0,0(sp)
    80200db2:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    80200db4:	02200513          	li	a0,34
    80200db8:	00000097          	auipc	ra,0x0
    80200dbc:	ec2080e7          	jalr	-318(ra) # 80200c7a <set_fg_color>
}
    80200dc0:	0001                	nop
    80200dc2:	60a2                	ld	ra,8(sp)
    80200dc4:	6402                	ld	s0,0(sp)
    80200dc6:	0141                	addi	sp,sp,16
    80200dc8:	8082                	ret

0000000080200dca <color_purple>:
void color_purple(void) {
    80200dca:	1141                	addi	sp,sp,-16
    80200dcc:	e406                	sd	ra,8(sp)
    80200dce:	e022                	sd	s0,0(sp)
    80200dd0:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80200dd2:	02300513          	li	a0,35
    80200dd6:	00000097          	auipc	ra,0x0
    80200dda:	ea4080e7          	jalr	-348(ra) # 80200c7a <set_fg_color>
}
    80200dde:	0001                	nop
    80200de0:	60a2                	ld	ra,8(sp)
    80200de2:	6402                	ld	s0,0(sp)
    80200de4:	0141                	addi	sp,sp,16
    80200de6:	8082                	ret

0000000080200de8 <color_cyan>:
void color_cyan(void) {
    80200de8:	1141                	addi	sp,sp,-16
    80200dea:	e406                	sd	ra,8(sp)
    80200dec:	e022                	sd	s0,0(sp)
    80200dee:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    80200df0:	02400513          	li	a0,36
    80200df4:	00000097          	auipc	ra,0x0
    80200df8:	e86080e7          	jalr	-378(ra) # 80200c7a <set_fg_color>
}
    80200dfc:	0001                	nop
    80200dfe:	60a2                	ld	ra,8(sp)
    80200e00:	6402                	ld	s0,0(sp)
    80200e02:	0141                	addi	sp,sp,16
    80200e04:	8082                	ret

0000000080200e06 <color_reverse>:
void color_reverse(void){
    80200e06:	1141                	addi	sp,sp,-16
    80200e08:	e406                	sd	ra,8(sp)
    80200e0a:	e022                	sd	s0,0(sp)
    80200e0c:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    80200e0e:	02500513          	li	a0,37
    80200e12:	00000097          	auipc	ra,0x0
    80200e16:	e68080e7          	jalr	-408(ra) # 80200c7a <set_fg_color>
}
    80200e1a:	0001                	nop
    80200e1c:	60a2                	ld	ra,8(sp)
    80200e1e:	6402                	ld	s0,0(sp)
    80200e20:	0141                	addi	sp,sp,16
    80200e22:	8082                	ret

0000000080200e24 <set_color>:
void set_color(int fg, int bg) {
    80200e24:	1101                	addi	sp,sp,-32
    80200e26:	ec06                	sd	ra,24(sp)
    80200e28:	e822                	sd	s0,16(sp)
    80200e2a:	1000                	addi	s0,sp,32
    80200e2c:	87aa                	mv	a5,a0
    80200e2e:	872e                	mv	a4,a1
    80200e30:	fef42623          	sw	a5,-20(s0)
    80200e34:	87ba                	mv	a5,a4
    80200e36:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    80200e3a:	fe842783          	lw	a5,-24(s0)
    80200e3e:	853e                	mv	a0,a5
    80200e40:	00000097          	auipc	ra,0x0
    80200e44:	ea6080e7          	jalr	-346(ra) # 80200ce6 <set_bg_color>
	set_fg_color(fg);
    80200e48:	fec42783          	lw	a5,-20(s0)
    80200e4c:	853e                	mv	a0,a5
    80200e4e:	00000097          	auipc	ra,0x0
    80200e52:	e2c080e7          	jalr	-468(ra) # 80200c7a <set_fg_color>
}
    80200e56:	0001                	nop
    80200e58:	60e2                	ld	ra,24(sp)
    80200e5a:	6442                	ld	s0,16(sp)
    80200e5c:	6105                	addi	sp,sp,32
    80200e5e:	8082                	ret

0000000080200e60 <clear_line>:
void clear_line(){
    80200e60:	1141                	addi	sp,sp,-16
    80200e62:	e406                	sd	ra,8(sp)
    80200e64:	e022                	sd	s0,0(sp)
    80200e66:	0800                	addi	s0,sp,16
	consputc('\033');
    80200e68:	456d                	li	a0,27
    80200e6a:	fffff097          	auipc	ra,0xfffff
    80200e6e:	5a8080e7          	jalr	1448(ra) # 80200412 <consputc>
	consputc('[');
    80200e72:	05b00513          	li	a0,91
    80200e76:	fffff097          	auipc	ra,0xfffff
    80200e7a:	59c080e7          	jalr	1436(ra) # 80200412 <consputc>
	consputc('2');
    80200e7e:	03200513          	li	a0,50
    80200e82:	fffff097          	auipc	ra,0xfffff
    80200e86:	590080e7          	jalr	1424(ra) # 80200412 <consputc>
	consputc('K');
    80200e8a:	04b00513          	li	a0,75
    80200e8e:	fffff097          	auipc	ra,0xfffff
    80200e92:	584080e7          	jalr	1412(ra) # 80200412 <consputc>
}
    80200e96:	0001                	nop
    80200e98:	60a2                	ld	ra,8(sp)
    80200e9a:	6402                	ld	s0,0(sp)
    80200e9c:	0141                	addi	sp,sp,16
    80200e9e:	8082                	ret

0000000080200ea0 <panic>:

void panic(const char *msg) {
    80200ea0:	1101                	addi	sp,sp,-32
    80200ea2:	ec06                	sd	ra,24(sp)
    80200ea4:	e822                	sd	s0,16(sp)
    80200ea6:	1000                	addi	s0,sp,32
    80200ea8:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    80200eac:	00000097          	auipc	ra,0x0
    80200eb0:	ea8080e7          	jalr	-344(ra) # 80200d54 <color_red>
	printf("panic: %s\n", msg);
    80200eb4:	fe843583          	ld	a1,-24(s0)
    80200eb8:	00004517          	auipc	a0,0x4
    80200ebc:	59050513          	addi	a0,a0,1424 # 80205448 <small_numbers+0x228>
    80200ec0:	fffff097          	auipc	ra,0xfffff
    80200ec4:	6d8080e7          	jalr	1752(ra) # 80200598 <printf>
	reset_color();
    80200ec8:	00000097          	auipc	ra,0x0
    80200ecc:	d90080e7          	jalr	-624(ra) # 80200c58 <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    80200ed0:	0001                	nop
    80200ed2:	bffd                	j	80200ed0 <panic+0x30>

0000000080200ed4 <test_printf_precision>:
}
void test_printf_precision(void) {
    80200ed4:	1101                	addi	sp,sp,-32
    80200ed6:	ec06                	sd	ra,24(sp)
    80200ed8:	e822                	sd	s0,16(sp)
    80200eda:	1000                	addi	s0,sp,32
	clear_screen();
    80200edc:	00000097          	auipc	ra,0x0
    80200ee0:	ab4080e7          	jalr	-1356(ra) # 80200990 <clear_screen>
    printf("=== 详细的Printf测试 ===\n");
    80200ee4:	00004517          	auipc	a0,0x4
    80200ee8:	57450513          	addi	a0,a0,1396 # 80205458 <small_numbers+0x238>
    80200eec:	fffff097          	auipc	ra,0xfffff
    80200ef0:	6ac080e7          	jalr	1708(ra) # 80200598 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    80200ef4:	00004517          	auipc	a0,0x4
    80200ef8:	58450513          	addi	a0,a0,1412 # 80205478 <small_numbers+0x258>
    80200efc:	fffff097          	auipc	ra,0xfffff
    80200f00:	69c080e7          	jalr	1692(ra) # 80200598 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    80200f04:	0ff00593          	li	a1,255
    80200f08:	00004517          	auipc	a0,0x4
    80200f0c:	58850513          	addi	a0,a0,1416 # 80205490 <small_numbers+0x270>
    80200f10:	fffff097          	auipc	ra,0xfffff
    80200f14:	688080e7          	jalr	1672(ra) # 80200598 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    80200f18:	6585                	lui	a1,0x1
    80200f1a:	00004517          	auipc	a0,0x4
    80200f1e:	59650513          	addi	a0,a0,1430 # 802054b0 <small_numbers+0x290>
    80200f22:	fffff097          	auipc	ra,0xfffff
    80200f26:	676080e7          	jalr	1654(ra) # 80200598 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    80200f2a:	1234b7b7          	lui	a5,0x1234b
    80200f2e:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <userret+0x1234ab31>
    80200f32:	00004517          	auipc	a0,0x4
    80200f36:	59e50513          	addi	a0,a0,1438 # 802054d0 <small_numbers+0x2b0>
    80200f3a:	fffff097          	auipc	ra,0xfffff
    80200f3e:	65e080e7          	jalr	1630(ra) # 80200598 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    80200f42:	00004517          	auipc	a0,0x4
    80200f46:	5a650513          	addi	a0,a0,1446 # 802054e8 <small_numbers+0x2c8>
    80200f4a:	fffff097          	auipc	ra,0xfffff
    80200f4e:	64e080e7          	jalr	1614(ra) # 80200598 <printf>
    printf("  正数: %d\n", 42);
    80200f52:	02a00593          	li	a1,42
    80200f56:	00004517          	auipc	a0,0x4
    80200f5a:	5aa50513          	addi	a0,a0,1450 # 80205500 <small_numbers+0x2e0>
    80200f5e:	fffff097          	auipc	ra,0xfffff
    80200f62:	63a080e7          	jalr	1594(ra) # 80200598 <printf>
    printf("  负数: %d\n", -42);
    80200f66:	fd600593          	li	a1,-42
    80200f6a:	00004517          	auipc	a0,0x4
    80200f6e:	5a650513          	addi	a0,a0,1446 # 80205510 <small_numbers+0x2f0>
    80200f72:	fffff097          	auipc	ra,0xfffff
    80200f76:	626080e7          	jalr	1574(ra) # 80200598 <printf>
    printf("  零: %d\n", 0);
    80200f7a:	4581                	li	a1,0
    80200f7c:	00004517          	auipc	a0,0x4
    80200f80:	5a450513          	addi	a0,a0,1444 # 80205520 <small_numbers+0x300>
    80200f84:	fffff097          	auipc	ra,0xfffff
    80200f88:	614080e7          	jalr	1556(ra) # 80200598 <printf>
    printf("  大数: %d\n", 123456789);
    80200f8c:	075bd7b7          	lui	a5,0x75bd
    80200f90:	d1578593          	addi	a1,a5,-747 # 75bcd15 <userret+0x75bcc79>
    80200f94:	00004517          	auipc	a0,0x4
    80200f98:	59c50513          	addi	a0,a0,1436 # 80205530 <small_numbers+0x310>
    80200f9c:	fffff097          	auipc	ra,0xfffff
    80200fa0:	5fc080e7          	jalr	1532(ra) # 80200598 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80200fa4:	00004517          	auipc	a0,0x4
    80200fa8:	59c50513          	addi	a0,a0,1436 # 80205540 <small_numbers+0x320>
    80200fac:	fffff097          	auipc	ra,0xfffff
    80200fb0:	5ec080e7          	jalr	1516(ra) # 80200598 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80200fb4:	55fd                	li	a1,-1
    80200fb6:	00004517          	auipc	a0,0x4
    80200fba:	5a250513          	addi	a0,a0,1442 # 80205558 <small_numbers+0x338>
    80200fbe:	fffff097          	auipc	ra,0xfffff
    80200fc2:	5da080e7          	jalr	1498(ra) # 80200598 <printf>
    printf("  零：%u\n", 0U);
    80200fc6:	4581                	li	a1,0
    80200fc8:	00004517          	auipc	a0,0x4
    80200fcc:	5a850513          	addi	a0,a0,1448 # 80205570 <small_numbers+0x350>
    80200fd0:	fffff097          	auipc	ra,0xfffff
    80200fd4:	5c8080e7          	jalr	1480(ra) # 80200598 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80200fd8:	678d                	lui	a5,0x3
    80200fda:	03978593          	addi	a1,a5,57 # 3039 <userret+0x2f9d>
    80200fde:	00004517          	auipc	a0,0x4
    80200fe2:	5a250513          	addi	a0,a0,1442 # 80205580 <small_numbers+0x360>
    80200fe6:	fffff097          	auipc	ra,0xfffff
    80200fea:	5b2080e7          	jalr	1458(ra) # 80200598 <printf>

	// 测试边界
	printf("边界测试:\n");
    80200fee:	00004517          	auipc	a0,0x4
    80200ff2:	5aa50513          	addi	a0,a0,1450 # 80205598 <small_numbers+0x378>
    80200ff6:	fffff097          	auipc	ra,0xfffff
    80200ffa:	5a2080e7          	jalr	1442(ra) # 80200598 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    80200ffe:	800007b7          	lui	a5,0x80000
    80201002:	fff7c593          	not	a1,a5
    80201006:	00004517          	auipc	a0,0x4
    8020100a:	5a250513          	addi	a0,a0,1442 # 802055a8 <small_numbers+0x388>
    8020100e:	fffff097          	auipc	ra,0xfffff
    80201012:	58a080e7          	jalr	1418(ra) # 80200598 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    80201016:	800005b7          	lui	a1,0x80000
    8020101a:	00004517          	auipc	a0,0x4
    8020101e:	59e50513          	addi	a0,a0,1438 # 802055b8 <small_numbers+0x398>
    80201022:	fffff097          	auipc	ra,0xfffff
    80201026:	576080e7          	jalr	1398(ra) # 80200598 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    8020102a:	55fd                	li	a1,-1
    8020102c:	00004517          	auipc	a0,0x4
    80201030:	59c50513          	addi	a0,a0,1436 # 802055c8 <small_numbers+0x3a8>
    80201034:	fffff097          	auipc	ra,0xfffff
    80201038:	564080e7          	jalr	1380(ra) # 80200598 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    8020103c:	55fd                	li	a1,-1
    8020103e:	00004517          	auipc	a0,0x4
    80201042:	59a50513          	addi	a0,a0,1434 # 802055d8 <small_numbers+0x3b8>
    80201046:	fffff097          	auipc	ra,0xfffff
    8020104a:	552080e7          	jalr	1362(ra) # 80200598 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    8020104e:	00004517          	auipc	a0,0x4
    80201052:	5a250513          	addi	a0,a0,1442 # 802055f0 <small_numbers+0x3d0>
    80201056:	fffff097          	auipc	ra,0xfffff
    8020105a:	542080e7          	jalr	1346(ra) # 80200598 <printf>
    printf("  空字符串: '%s'\n", "");
    8020105e:	00004597          	auipc	a1,0x4
    80201062:	5aa58593          	addi	a1,a1,1450 # 80205608 <small_numbers+0x3e8>
    80201066:	00004517          	auipc	a0,0x4
    8020106a:	5aa50513          	addi	a0,a0,1450 # 80205610 <small_numbers+0x3f0>
    8020106e:	fffff097          	auipc	ra,0xfffff
    80201072:	52a080e7          	jalr	1322(ra) # 80200598 <printf>
    printf("  单字符: '%s'\n", "X");
    80201076:	00004597          	auipc	a1,0x4
    8020107a:	5b258593          	addi	a1,a1,1458 # 80205628 <small_numbers+0x408>
    8020107e:	00004517          	auipc	a0,0x4
    80201082:	5b250513          	addi	a0,a0,1458 # 80205630 <small_numbers+0x410>
    80201086:	fffff097          	auipc	ra,0xfffff
    8020108a:	512080e7          	jalr	1298(ra) # 80200598 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    8020108e:	00004597          	auipc	a1,0x4
    80201092:	5ba58593          	addi	a1,a1,1466 # 80205648 <small_numbers+0x428>
    80201096:	00004517          	auipc	a0,0x4
    8020109a:	5d250513          	addi	a0,a0,1490 # 80205668 <small_numbers+0x448>
    8020109e:	fffff097          	auipc	ra,0xfffff
    802010a2:	4fa080e7          	jalr	1274(ra) # 80200598 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    802010a6:	00004597          	auipc	a1,0x4
    802010aa:	5da58593          	addi	a1,a1,1498 # 80205680 <small_numbers+0x460>
    802010ae:	00004517          	auipc	a0,0x4
    802010b2:	72250513          	addi	a0,a0,1826 # 802057d0 <small_numbers+0x5b0>
    802010b6:	fffff097          	auipc	ra,0xfffff
    802010ba:	4e2080e7          	jalr	1250(ra) # 80200598 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    802010be:	00004517          	auipc	a0,0x4
    802010c2:	73250513          	addi	a0,a0,1842 # 802057f0 <small_numbers+0x5d0>
    802010c6:	fffff097          	auipc	ra,0xfffff
    802010ca:	4d2080e7          	jalr	1234(ra) # 80200598 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    802010ce:	0ff00693          	li	a3,255
    802010d2:	f0100613          	li	a2,-255
    802010d6:	0ff00593          	li	a1,255
    802010da:	00004517          	auipc	a0,0x4
    802010de:	72e50513          	addi	a0,a0,1838 # 80205808 <small_numbers+0x5e8>
    802010e2:	fffff097          	auipc	ra,0xfffff
    802010e6:	4b6080e7          	jalr	1206(ra) # 80200598 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    802010ea:	00004517          	auipc	a0,0x4
    802010ee:	74650513          	addi	a0,a0,1862 # 80205830 <small_numbers+0x610>
    802010f2:	fffff097          	auipc	ra,0xfffff
    802010f6:	4a6080e7          	jalr	1190(ra) # 80200598 <printf>
	printf("  100%% 完成!\n");
    802010fa:	00004517          	auipc	a0,0x4
    802010fe:	74e50513          	addi	a0,a0,1870 # 80205848 <small_numbers+0x628>
    80201102:	fffff097          	auipc	ra,0xfffff
    80201106:	496080e7          	jalr	1174(ra) # 80200598 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    8020110a:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    8020110e:	00004517          	auipc	a0,0x4
    80201112:	75250513          	addi	a0,a0,1874 # 80205860 <small_numbers+0x640>
    80201116:	fffff097          	auipc	ra,0xfffff
    8020111a:	482080e7          	jalr	1154(ra) # 80200598 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    8020111e:	fe843583          	ld	a1,-24(s0)
    80201122:	00004517          	auipc	a0,0x4
    80201126:	75650513          	addi	a0,a0,1878 # 80205878 <small_numbers+0x658>
    8020112a:	fffff097          	auipc	ra,0xfffff
    8020112e:	46e080e7          	jalr	1134(ra) # 80200598 <printf>
	
	// 测试指针格式
	int var = 42;
    80201132:	02a00793          	li	a5,42
    80201136:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    8020113a:	00004517          	auipc	a0,0x4
    8020113e:	75650513          	addi	a0,a0,1878 # 80205890 <small_numbers+0x670>
    80201142:	fffff097          	auipc	ra,0xfffff
    80201146:	456080e7          	jalr	1110(ra) # 80200598 <printf>
	printf("  Address of var: %p\n", &var);
    8020114a:	fe440793          	addi	a5,s0,-28
    8020114e:	85be                	mv	a1,a5
    80201150:	00004517          	auipc	a0,0x4
    80201154:	75050513          	addi	a0,a0,1872 # 802058a0 <small_numbers+0x680>
    80201158:	fffff097          	auipc	ra,0xfffff
    8020115c:	440080e7          	jalr	1088(ra) # 80200598 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80201160:	00004517          	auipc	a0,0x4
    80201164:	75850513          	addi	a0,a0,1880 # 802058b8 <small_numbers+0x698>
    80201168:	fffff097          	auipc	ra,0xfffff
    8020116c:	430080e7          	jalr	1072(ra) # 80200598 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201170:	55fd                	li	a1,-1
    80201172:	00004517          	auipc	a0,0x4
    80201176:	76650513          	addi	a0,a0,1894 # 802058d8 <small_numbers+0x6b8>
    8020117a:	fffff097          	auipc	ra,0xfffff
    8020117e:	41e080e7          	jalr	1054(ra) # 80200598 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201182:	00004517          	auipc	a0,0x4
    80201186:	76e50513          	addi	a0,a0,1902 # 802058f0 <small_numbers+0x6d0>
    8020118a:	fffff097          	auipc	ra,0xfffff
    8020118e:	40e080e7          	jalr	1038(ra) # 80200598 <printf>
	printf("  Binary of 5: %b\n", 5);
    80201192:	4595                	li	a1,5
    80201194:	00004517          	auipc	a0,0x4
    80201198:	77450513          	addi	a0,a0,1908 # 80205908 <small_numbers+0x6e8>
    8020119c:	fffff097          	auipc	ra,0xfffff
    802011a0:	3fc080e7          	jalr	1020(ra) # 80200598 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    802011a4:	45a1                	li	a1,8
    802011a6:	00004517          	auipc	a0,0x4
    802011aa:	77a50513          	addi	a0,a0,1914 # 80205920 <small_numbers+0x700>
    802011ae:	fffff097          	auipc	ra,0xfffff
    802011b2:	3ea080e7          	jalr	1002(ra) # 80200598 <printf>
	printf("=== Printf测试结束 ===\n");
    802011b6:	00004517          	auipc	a0,0x4
    802011ba:	78250513          	addi	a0,a0,1922 # 80205938 <small_numbers+0x718>
    802011be:	fffff097          	auipc	ra,0xfffff
    802011c2:	3da080e7          	jalr	986(ra) # 80200598 <printf>
}
    802011c6:	0001                	nop
    802011c8:	60e2                	ld	ra,24(sp)
    802011ca:	6442                	ld	s0,16(sp)
    802011cc:	6105                	addi	sp,sp,32
    802011ce:	8082                	ret

00000000802011d0 <test_curse_move>:
void test_curse_move(){
    802011d0:	1101                	addi	sp,sp,-32
    802011d2:	ec06                	sd	ra,24(sp)
    802011d4:	e822                	sd	s0,16(sp)
    802011d6:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    802011d8:	fffff097          	auipc	ra,0xfffff
    802011dc:	7b8080e7          	jalr	1976(ra) # 80200990 <clear_screen>
	printf("=== 光标移动测试 ===\n");
    802011e0:	00004517          	auipc	a0,0x4
    802011e4:	77850513          	addi	a0,a0,1912 # 80205958 <small_numbers+0x738>
    802011e8:	fffff097          	auipc	ra,0xfffff
    802011ec:	3b0080e7          	jalr	944(ra) # 80200598 <printf>
	for (int i = 3; i <= 7; i++) {
    802011f0:	478d                	li	a5,3
    802011f2:	fef42623          	sw	a5,-20(s0)
    802011f6:	a881                	j	80201246 <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    802011f8:	4785                	li	a5,1
    802011fa:	fef42423          	sw	a5,-24(s0)
    802011fe:	a805                	j	8020122e <test_curse_move+0x5e>
			goto_rc(i, j);
    80201200:	fe842703          	lw	a4,-24(s0)
    80201204:	fec42783          	lw	a5,-20(s0)
    80201208:	85ba                	mv	a1,a4
    8020120a:	853e                	mv	a0,a5
    8020120c:	00000097          	auipc	ra,0x0
    80201210:	9da080e7          	jalr	-1574(ra) # 80200be6 <goto_rc>
			printf("*");
    80201214:	00004517          	auipc	a0,0x4
    80201218:	76450513          	addi	a0,a0,1892 # 80205978 <small_numbers+0x758>
    8020121c:	fffff097          	auipc	ra,0xfffff
    80201220:	37c080e7          	jalr	892(ra) # 80200598 <printf>
		for (int j = 1; j <= 10; j++) {
    80201224:	fe842783          	lw	a5,-24(s0)
    80201228:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdf2ab1>
    8020122a:	fef42423          	sw	a5,-24(s0)
    8020122e:	fe842783          	lw	a5,-24(s0)
    80201232:	0007871b          	sext.w	a4,a5
    80201236:	47a9                	li	a5,10
    80201238:	fce7d4e3          	bge	a5,a4,80201200 <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    8020123c:	fec42783          	lw	a5,-20(s0)
    80201240:	2785                	addiw	a5,a5,1
    80201242:	fef42623          	sw	a5,-20(s0)
    80201246:	fec42783          	lw	a5,-20(s0)
    8020124a:	0007871b          	sext.w	a4,a5
    8020124e:	479d                	li	a5,7
    80201250:	fae7d4e3          	bge	a5,a4,802011f8 <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201254:	4585                	li	a1,1
    80201256:	4525                	li	a0,9
    80201258:	00000097          	auipc	ra,0x0
    8020125c:	98e080e7          	jalr	-1650(ra) # 80200be6 <goto_rc>
	save_cursor();
    80201260:	00000097          	auipc	ra,0x0
    80201264:	8c2080e7          	jalr	-1854(ra) # 80200b22 <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201268:	4515                	li	a0,5
    8020126a:	fffff097          	auipc	ra,0xfffff
    8020126e:	758080e7          	jalr	1880(ra) # 802009c2 <cursor_up>
	cursor_right(2);
    80201272:	4509                	li	a0,2
    80201274:	fffff097          	auipc	ra,0xfffff
    80201278:	7fe080e7          	jalr	2046(ra) # 80200a72 <cursor_right>
	printf("+++++");
    8020127c:	00004517          	auipc	a0,0x4
    80201280:	70450513          	addi	a0,a0,1796 # 80205980 <small_numbers+0x760>
    80201284:	fffff097          	auipc	ra,0xfffff
    80201288:	314080e7          	jalr	788(ra) # 80200598 <printf>
	cursor_down(2);
    8020128c:	4509                	li	a0,2
    8020128e:	fffff097          	auipc	ra,0xfffff
    80201292:	78c080e7          	jalr	1932(ra) # 80200a1a <cursor_down>
	cursor_left(5);
    80201296:	4515                	li	a0,5
    80201298:	00000097          	auipc	ra,0x0
    8020129c:	832080e7          	jalr	-1998(ra) # 80200aca <cursor_left>
	printf("-----");
    802012a0:	00004517          	auipc	a0,0x4
    802012a4:	6e850513          	addi	a0,a0,1768 # 80205988 <small_numbers+0x768>
    802012a8:	fffff097          	auipc	ra,0xfffff
    802012ac:	2f0080e7          	jalr	752(ra) # 80200598 <printf>
	restore_cursor();
    802012b0:	00000097          	auipc	ra,0x0
    802012b4:	8a6080e7          	jalr	-1882(ra) # 80200b56 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    802012b8:	00004517          	auipc	a0,0x4
    802012bc:	6d850513          	addi	a0,a0,1752 # 80205990 <small_numbers+0x770>
    802012c0:	fffff097          	auipc	ra,0xfffff
    802012c4:	2d8080e7          	jalr	728(ra) # 80200598 <printf>
}
    802012c8:	0001                	nop
    802012ca:	60e2                	ld	ra,24(sp)
    802012cc:	6442                	ld	s0,16(sp)
    802012ce:	6105                	addi	sp,sp,32
    802012d0:	8082                	ret

00000000802012d2 <test_basic_colors>:

void test_basic_colors(void) {
    802012d2:	1141                	addi	sp,sp,-16
    802012d4:	e406                	sd	ra,8(sp)
    802012d6:	e022                	sd	s0,0(sp)
    802012d8:	0800                	addi	s0,sp,16
    clear_screen();
    802012da:	fffff097          	auipc	ra,0xfffff
    802012de:	6b6080e7          	jalr	1718(ra) # 80200990 <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    802012e2:	00004517          	auipc	a0,0x4
    802012e6:	6d650513          	addi	a0,a0,1750 # 802059b8 <small_numbers+0x798>
    802012ea:	fffff097          	auipc	ra,0xfffff
    802012ee:	2ae080e7          	jalr	686(ra) # 80200598 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    802012f2:	00004517          	auipc	a0,0x4
    802012f6:	6e650513          	addi	a0,a0,1766 # 802059d8 <small_numbers+0x7b8>
    802012fa:	fffff097          	auipc	ra,0xfffff
    802012fe:	29e080e7          	jalr	670(ra) # 80200598 <printf>
    color_red();    printf("红色文字 ");
    80201302:	00000097          	auipc	ra,0x0
    80201306:	a52080e7          	jalr	-1454(ra) # 80200d54 <color_red>
    8020130a:	00004517          	auipc	a0,0x4
    8020130e:	6e650513          	addi	a0,a0,1766 # 802059f0 <small_numbers+0x7d0>
    80201312:	fffff097          	auipc	ra,0xfffff
    80201316:	286080e7          	jalr	646(ra) # 80200598 <printf>
    color_green();  printf("绿色文字 ");
    8020131a:	00000097          	auipc	ra,0x0
    8020131e:	a56080e7          	jalr	-1450(ra) # 80200d70 <color_green>
    80201322:	00004517          	auipc	a0,0x4
    80201326:	6de50513          	addi	a0,a0,1758 # 80205a00 <small_numbers+0x7e0>
    8020132a:	fffff097          	auipc	ra,0xfffff
    8020132e:	26e080e7          	jalr	622(ra) # 80200598 <printf>
    color_yellow(); printf("黄色文字 ");
    80201332:	00000097          	auipc	ra,0x0
    80201336:	a5c080e7          	jalr	-1444(ra) # 80200d8e <color_yellow>
    8020133a:	00004517          	auipc	a0,0x4
    8020133e:	6d650513          	addi	a0,a0,1750 # 80205a10 <small_numbers+0x7f0>
    80201342:	fffff097          	auipc	ra,0xfffff
    80201346:	256080e7          	jalr	598(ra) # 80200598 <printf>
    color_blue();   printf("蓝色文字 ");
    8020134a:	00000097          	auipc	ra,0x0
    8020134e:	a62080e7          	jalr	-1438(ra) # 80200dac <color_blue>
    80201352:	00004517          	auipc	a0,0x4
    80201356:	6ce50513          	addi	a0,a0,1742 # 80205a20 <small_numbers+0x800>
    8020135a:	fffff097          	auipc	ra,0xfffff
    8020135e:	23e080e7          	jalr	574(ra) # 80200598 <printf>
    color_purple(); printf("紫色文字 ");
    80201362:	00000097          	auipc	ra,0x0
    80201366:	a68080e7          	jalr	-1432(ra) # 80200dca <color_purple>
    8020136a:	00004517          	auipc	a0,0x4
    8020136e:	6c650513          	addi	a0,a0,1734 # 80205a30 <small_numbers+0x810>
    80201372:	fffff097          	auipc	ra,0xfffff
    80201376:	226080e7          	jalr	550(ra) # 80200598 <printf>
    color_cyan();   printf("青色文字 ");
    8020137a:	00000097          	auipc	ra,0x0
    8020137e:	a6e080e7          	jalr	-1426(ra) # 80200de8 <color_cyan>
    80201382:	00004517          	auipc	a0,0x4
    80201386:	6be50513          	addi	a0,a0,1726 # 80205a40 <small_numbers+0x820>
    8020138a:	fffff097          	auipc	ra,0xfffff
    8020138e:	20e080e7          	jalr	526(ra) # 80200598 <printf>
    color_reverse();  printf("反色文字");
    80201392:	00000097          	auipc	ra,0x0
    80201396:	a74080e7          	jalr	-1420(ra) # 80200e06 <color_reverse>
    8020139a:	00004517          	auipc	a0,0x4
    8020139e:	6b650513          	addi	a0,a0,1718 # 80205a50 <small_numbers+0x830>
    802013a2:	fffff097          	auipc	ra,0xfffff
    802013a6:	1f6080e7          	jalr	502(ra) # 80200598 <printf>
    reset_color();
    802013aa:	00000097          	auipc	ra,0x0
    802013ae:	8ae080e7          	jalr	-1874(ra) # 80200c58 <reset_color>
    printf("\n\n");
    802013b2:	00004517          	auipc	a0,0x4
    802013b6:	6ae50513          	addi	a0,a0,1710 # 80205a60 <small_numbers+0x840>
    802013ba:	fffff097          	auipc	ra,0xfffff
    802013be:	1de080e7          	jalr	478(ra) # 80200598 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    802013c2:	00004517          	auipc	a0,0x4
    802013c6:	6a650513          	addi	a0,a0,1702 # 80205a68 <small_numbers+0x848>
    802013ca:	fffff097          	auipc	ra,0xfffff
    802013ce:	1ce080e7          	jalr	462(ra) # 80200598 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    802013d2:	02900513          	li	a0,41
    802013d6:	00000097          	auipc	ra,0x0
    802013da:	910080e7          	jalr	-1776(ra) # 80200ce6 <set_bg_color>
    802013de:	00004517          	auipc	a0,0x4
    802013e2:	6a250513          	addi	a0,a0,1698 # 80205a80 <small_numbers+0x860>
    802013e6:	fffff097          	auipc	ra,0xfffff
    802013ea:	1b2080e7          	jalr	434(ra) # 80200598 <printf>
    802013ee:	00000097          	auipc	ra,0x0
    802013f2:	86a080e7          	jalr	-1942(ra) # 80200c58 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    802013f6:	02a00513          	li	a0,42
    802013fa:	00000097          	auipc	ra,0x0
    802013fe:	8ec080e7          	jalr	-1812(ra) # 80200ce6 <set_bg_color>
    80201402:	00004517          	auipc	a0,0x4
    80201406:	68e50513          	addi	a0,a0,1678 # 80205a90 <small_numbers+0x870>
    8020140a:	fffff097          	auipc	ra,0xfffff
    8020140e:	18e080e7          	jalr	398(ra) # 80200598 <printf>
    80201412:	00000097          	auipc	ra,0x0
    80201416:	846080e7          	jalr	-1978(ra) # 80200c58 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    8020141a:	02b00513          	li	a0,43
    8020141e:	00000097          	auipc	ra,0x0
    80201422:	8c8080e7          	jalr	-1848(ra) # 80200ce6 <set_bg_color>
    80201426:	00004517          	auipc	a0,0x4
    8020142a:	67a50513          	addi	a0,a0,1658 # 80205aa0 <small_numbers+0x880>
    8020142e:	fffff097          	auipc	ra,0xfffff
    80201432:	16a080e7          	jalr	362(ra) # 80200598 <printf>
    80201436:	00000097          	auipc	ra,0x0
    8020143a:	822080e7          	jalr	-2014(ra) # 80200c58 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    8020143e:	02c00513          	li	a0,44
    80201442:	00000097          	auipc	ra,0x0
    80201446:	8a4080e7          	jalr	-1884(ra) # 80200ce6 <set_bg_color>
    8020144a:	00004517          	auipc	a0,0x4
    8020144e:	66650513          	addi	a0,a0,1638 # 80205ab0 <small_numbers+0x890>
    80201452:	fffff097          	auipc	ra,0xfffff
    80201456:	146080e7          	jalr	326(ra) # 80200598 <printf>
    8020145a:	fffff097          	auipc	ra,0xfffff
    8020145e:	7fe080e7          	jalr	2046(ra) # 80200c58 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201462:	02f00513          	li	a0,47
    80201466:	00000097          	auipc	ra,0x0
    8020146a:	880080e7          	jalr	-1920(ra) # 80200ce6 <set_bg_color>
    8020146e:	00004517          	auipc	a0,0x4
    80201472:	65250513          	addi	a0,a0,1618 # 80205ac0 <small_numbers+0x8a0>
    80201476:	fffff097          	auipc	ra,0xfffff
    8020147a:	122080e7          	jalr	290(ra) # 80200598 <printf>
    8020147e:	fffff097          	auipc	ra,0xfffff
    80201482:	7da080e7          	jalr	2010(ra) # 80200c58 <reset_color>
    printf("\n\n");
    80201486:	00004517          	auipc	a0,0x4
    8020148a:	5da50513          	addi	a0,a0,1498 # 80205a60 <small_numbers+0x840>
    8020148e:	fffff097          	auipc	ra,0xfffff
    80201492:	10a080e7          	jalr	266(ra) # 80200598 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201496:	00004517          	auipc	a0,0x4
    8020149a:	63a50513          	addi	a0,a0,1594 # 80205ad0 <small_numbers+0x8b0>
    8020149e:	fffff097          	auipc	ra,0xfffff
    802014a2:	0fa080e7          	jalr	250(ra) # 80200598 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    802014a6:	02c00593          	li	a1,44
    802014aa:	457d                	li	a0,31
    802014ac:	00000097          	auipc	ra,0x0
    802014b0:	978080e7          	jalr	-1672(ra) # 80200e24 <set_color>
    802014b4:	00004517          	auipc	a0,0x4
    802014b8:	63450513          	addi	a0,a0,1588 # 80205ae8 <small_numbers+0x8c8>
    802014bc:	fffff097          	auipc	ra,0xfffff
    802014c0:	0dc080e7          	jalr	220(ra) # 80200598 <printf>
    802014c4:	fffff097          	auipc	ra,0xfffff
    802014c8:	794080e7          	jalr	1940(ra) # 80200c58 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    802014cc:	02d00593          	li	a1,45
    802014d0:	02100513          	li	a0,33
    802014d4:	00000097          	auipc	ra,0x0
    802014d8:	950080e7          	jalr	-1712(ra) # 80200e24 <set_color>
    802014dc:	00004517          	auipc	a0,0x4
    802014e0:	61c50513          	addi	a0,a0,1564 # 80205af8 <small_numbers+0x8d8>
    802014e4:	fffff097          	auipc	ra,0xfffff
    802014e8:	0b4080e7          	jalr	180(ra) # 80200598 <printf>
    802014ec:	fffff097          	auipc	ra,0xfffff
    802014f0:	76c080e7          	jalr	1900(ra) # 80200c58 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    802014f4:	02f00593          	li	a1,47
    802014f8:	02000513          	li	a0,32
    802014fc:	00000097          	auipc	ra,0x0
    80201500:	928080e7          	jalr	-1752(ra) # 80200e24 <set_color>
    80201504:	00004517          	auipc	a0,0x4
    80201508:	60450513          	addi	a0,a0,1540 # 80205b08 <small_numbers+0x8e8>
    8020150c:	fffff097          	auipc	ra,0xfffff
    80201510:	08c080e7          	jalr	140(ra) # 80200598 <printf>
    80201514:	fffff097          	auipc	ra,0xfffff
    80201518:	744080e7          	jalr	1860(ra) # 80200c58 <reset_color>
    printf("\n\n");
    8020151c:	00004517          	auipc	a0,0x4
    80201520:	54450513          	addi	a0,a0,1348 # 80205a60 <small_numbers+0x840>
    80201524:	fffff097          	auipc	ra,0xfffff
    80201528:	074080e7          	jalr	116(ra) # 80200598 <printf>
	reset_color();
    8020152c:	fffff097          	auipc	ra,0xfffff
    80201530:	72c080e7          	jalr	1836(ra) # 80200c58 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201534:	00004517          	auipc	a0,0x4
    80201538:	5e450513          	addi	a0,a0,1508 # 80205b18 <small_numbers+0x8f8>
    8020153c:	fffff097          	auipc	ra,0xfffff
    80201540:	05c080e7          	jalr	92(ra) # 80200598 <printf>
	cursor_up(1); // 光标上移一行
    80201544:	4505                	li	a0,1
    80201546:	fffff097          	auipc	ra,0xfffff
    8020154a:	47c080e7          	jalr	1148(ra) # 802009c2 <cursor_up>
	clear_line();
    8020154e:	00000097          	auipc	ra,0x0
    80201552:	912080e7          	jalr	-1774(ra) # 80200e60 <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201556:	00004517          	auipc	a0,0x4
    8020155a:	5fa50513          	addi	a0,a0,1530 # 80205b50 <small_numbers+0x930>
    8020155e:	fffff097          	auipc	ra,0xfffff
    80201562:	03a080e7          	jalr	58(ra) # 80200598 <printf>
    80201566:	0001                	nop
    80201568:	60a2                	ld	ra,8(sp)
    8020156a:	6402                	ld	s0,0(sp)
    8020156c:	0141                	addi	sp,sp,16
    8020156e:	8082                	ret

0000000080201570 <memset>:
#include "mem.h"
#include "types.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201570:	7139                	addi	sp,sp,-64
    80201572:	fc22                	sd	s0,56(sp)
    80201574:	0080                	addi	s0,sp,64
    80201576:	fca43c23          	sd	a0,-40(s0)
    8020157a:	87ae                	mv	a5,a1
    8020157c:	fcc43423          	sd	a2,-56(s0)
    80201580:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201584:	fd843783          	ld	a5,-40(s0)
    80201588:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    8020158c:	a829                	j	802015a6 <memset+0x36>
        *p++ = (unsigned char)c;
    8020158e:	fe843783          	ld	a5,-24(s0)
    80201592:	00178713          	addi	a4,a5,1
    80201596:	fee43423          	sd	a4,-24(s0)
    8020159a:	fd442703          	lw	a4,-44(s0)
    8020159e:	0ff77713          	zext.b	a4,a4
    802015a2:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    802015a6:	fc843783          	ld	a5,-56(s0)
    802015aa:	fff78713          	addi	a4,a5,-1
    802015ae:	fce43423          	sd	a4,-56(s0)
    802015b2:	fff1                	bnez	a5,8020158e <memset+0x1e>
    return dst;
    802015b4:	fd843783          	ld	a5,-40(s0)
}
    802015b8:	853e                	mv	a0,a5
    802015ba:	7462                	ld	s0,56(sp)
    802015bc:	6121                	addi	sp,sp,64
    802015be:	8082                	ret

00000000802015c0 <memmove>:
void *memmove(void *dst, const void *src, unsigned long n) {
    802015c0:	7139                	addi	sp,sp,-64
    802015c2:	fc22                	sd	s0,56(sp)
    802015c4:	0080                	addi	s0,sp,64
    802015c6:	fca43c23          	sd	a0,-40(s0)
    802015ca:	fcb43823          	sd	a1,-48(s0)
    802015ce:	fcc43423          	sd	a2,-56(s0)
	unsigned char *d = dst;
    802015d2:	fd843783          	ld	a5,-40(s0)
    802015d6:	fef43423          	sd	a5,-24(s0)
	const unsigned char *s = src;
    802015da:	fd043783          	ld	a5,-48(s0)
    802015de:	fef43023          	sd	a5,-32(s0)
	if (d < s) {
    802015e2:	fe843703          	ld	a4,-24(s0)
    802015e6:	fe043783          	ld	a5,-32(s0)
    802015ea:	02f77b63          	bgeu	a4,a5,80201620 <memmove+0x60>
		while (n-- > 0)
    802015ee:	a00d                	j	80201610 <memmove+0x50>
			*d++ = *s++;
    802015f0:	fe043703          	ld	a4,-32(s0)
    802015f4:	00170793          	addi	a5,a4,1
    802015f8:	fef43023          	sd	a5,-32(s0)
    802015fc:	fe843783          	ld	a5,-24(s0)
    80201600:	00178693          	addi	a3,a5,1
    80201604:	fed43423          	sd	a3,-24(s0)
    80201608:	00074703          	lbu	a4,0(a4)
    8020160c:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201610:	fc843783          	ld	a5,-56(s0)
    80201614:	fff78713          	addi	a4,a5,-1
    80201618:	fce43423          	sd	a4,-56(s0)
    8020161c:	fbf1                	bnez	a5,802015f0 <memmove+0x30>
    8020161e:	a889                	j	80201670 <memmove+0xb0>
	} else {
		d += n;
    80201620:	fe843703          	ld	a4,-24(s0)
    80201624:	fc843783          	ld	a5,-56(s0)
    80201628:	97ba                	add	a5,a5,a4
    8020162a:	fef43423          	sd	a5,-24(s0)
		s += n;
    8020162e:	fe043703          	ld	a4,-32(s0)
    80201632:	fc843783          	ld	a5,-56(s0)
    80201636:	97ba                	add	a5,a5,a4
    80201638:	fef43023          	sd	a5,-32(s0)
		while (n-- > 0)
    8020163c:	a01d                	j	80201662 <memmove+0xa2>
			*(--d) = *(--s);
    8020163e:	fe043783          	ld	a5,-32(s0)
    80201642:	17fd                	addi	a5,a5,-1
    80201644:	fef43023          	sd	a5,-32(s0)
    80201648:	fe843783          	ld	a5,-24(s0)
    8020164c:	17fd                	addi	a5,a5,-1
    8020164e:	fef43423          	sd	a5,-24(s0)
    80201652:	fe043783          	ld	a5,-32(s0)
    80201656:	0007c703          	lbu	a4,0(a5)
    8020165a:	fe843783          	ld	a5,-24(s0)
    8020165e:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201662:	fc843783          	ld	a5,-56(s0)
    80201666:	fff78713          	addi	a4,a5,-1
    8020166a:	fce43423          	sd	a4,-56(s0)
    8020166e:	fbe1                	bnez	a5,8020163e <memmove+0x7e>
	}
	return dst;
    80201670:	fd843783          	ld	a5,-40(s0)
}
    80201674:	853e                	mv	a0,a5
    80201676:	7462                	ld	s0,56(sp)
    80201678:	6121                	addi	sp,sp,64
    8020167a:	8082                	ret

000000008020167c <memcpy>:
void *memcpy(void *dst, const void *src, size_t n) {
    8020167c:	715d                	addi	sp,sp,-80
    8020167e:	e4a2                	sd	s0,72(sp)
    80201680:	0880                	addi	s0,sp,80
    80201682:	fca43423          	sd	a0,-56(s0)
    80201686:	fcb43023          	sd	a1,-64(s0)
    8020168a:	fac43c23          	sd	a2,-72(s0)
    char *d = dst;
    8020168e:	fc843783          	ld	a5,-56(s0)
    80201692:	fef43023          	sd	a5,-32(s0)
    const char *s = src;
    80201696:	fc043783          	ld	a5,-64(s0)
    8020169a:	fcf43c23          	sd	a5,-40(s0)
    for (size_t i = 0; i < n; i++) {
    8020169e:	fe043423          	sd	zero,-24(s0)
    802016a2:	a025                	j	802016ca <memcpy+0x4e>
        d[i] = s[i];
    802016a4:	fd843703          	ld	a4,-40(s0)
    802016a8:	fe843783          	ld	a5,-24(s0)
    802016ac:	973e                	add	a4,a4,a5
    802016ae:	fe043683          	ld	a3,-32(s0)
    802016b2:	fe843783          	ld	a5,-24(s0)
    802016b6:	97b6                	add	a5,a5,a3
    802016b8:	00074703          	lbu	a4,0(a4)
    802016bc:	00e78023          	sb	a4,0(a5)
    for (size_t i = 0; i < n; i++) {
    802016c0:	fe843783          	ld	a5,-24(s0)
    802016c4:	0785                	addi	a5,a5,1
    802016c6:	fef43423          	sd	a5,-24(s0)
    802016ca:	fe843703          	ld	a4,-24(s0)
    802016ce:	fb843783          	ld	a5,-72(s0)
    802016d2:	fcf769e3          	bltu	a4,a5,802016a4 <memcpy+0x28>
    }
    return dst;
    802016d6:	fc843783          	ld	a5,-56(s0)
    802016da:	853e                	mv	a0,a5
    802016dc:	6426                	ld	s0,72(sp)
    802016de:	6161                	addi	sp,sp,80
    802016e0:	8082                	ret

00000000802016e2 <assert>:
#include "vm.h"
#include "memlayout.h"
#include "pm.h"
    802016e2:	1101                	addi	sp,sp,-32
    802016e4:	ec06                	sd	ra,24(sp)
    802016e6:	e822                	sd	s0,16(sp)
    802016e8:	1000                	addi	s0,sp,32
    802016ea:	87aa                	mv	a5,a0
    802016ec:	fef42623          	sw	a5,-20(s0)
#include "printf.h"
    802016f0:	fec42783          	lw	a5,-20(s0)
    802016f4:	2781                	sext.w	a5,a5
    802016f6:	e795                	bnez	a5,80201722 <assert+0x40>
#include "mem.h"
    802016f8:	4615                	li	a2,5
    802016fa:	00004597          	auipc	a1,0x4
    802016fe:	47658593          	addi	a1,a1,1142 # 80205b70 <small_numbers+0x950>
    80201702:	00004517          	auipc	a0,0x4
    80201706:	47e50513          	addi	a0,a0,1150 # 80205b80 <small_numbers+0x960>
    8020170a:	fffff097          	auipc	ra,0xfffff
    8020170e:	e8e080e7          	jalr	-370(ra) # 80200598 <printf>
#include "assert.h"
    80201712:	00004517          	auipc	a0,0x4
    80201716:	49650513          	addi	a0,a0,1174 # 80205ba8 <small_numbers+0x988>
    8020171a:	fffff097          	auipc	ra,0xfffff
    8020171e:	786080e7          	jalr	1926(ra) # 80200ea0 <panic>


    80201722:	0001                	nop
    80201724:	60e2                	ld	ra,24(sp)
    80201726:	6442                	ld	s0,16(sp)
    80201728:	6105                	addi	sp,sp,32
    8020172a:	8082                	ret

000000008020172c <px>:


// 内核页表全局变量
pagetable_t kernel_pagetable = 0;

static inline uint64 px(int level, uint64 va) {
    8020172c:	1101                	addi	sp,sp,-32
    8020172e:	ec22                	sd	s0,24(sp)
    80201730:	1000                	addi	s0,sp,32
    80201732:	87aa                	mv	a5,a0
    80201734:	feb43023          	sd	a1,-32(s0)
    80201738:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    8020173c:	fec42783          	lw	a5,-20(s0)
    80201740:	873e                	mv	a4,a5
    80201742:	87ba                	mv	a5,a4
    80201744:	0037979b          	slliw	a5,a5,0x3
    80201748:	9fb9                	addw	a5,a5,a4
    8020174a:	2781                	sext.w	a5,a5
    8020174c:	27b1                	addiw	a5,a5,12
    8020174e:	2781                	sext.w	a5,a5
    80201750:	873e                	mv	a4,a5
    80201752:	fe043783          	ld	a5,-32(s0)
    80201756:	00e7d7b3          	srl	a5,a5,a4
    8020175a:	1ff7f793          	andi	a5,a5,511
}
    8020175e:	853e                	mv	a0,a5
    80201760:	6462                	ld	s0,24(sp)
    80201762:	6105                	addi	sp,sp,32
    80201764:	8082                	ret

0000000080201766 <create_pagetable>:

// 创建空页表
pagetable_t create_pagetable(void) {
    80201766:	1101                	addi	sp,sp,-32
    80201768:	ec06                	sd	ra,24(sp)
    8020176a:	e822                	sd	s0,16(sp)
    8020176c:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    8020176e:	00001097          	auipc	ra,0x1
    80201772:	cee080e7          	jalr	-786(ra) # 8020245c <alloc_page>
    80201776:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    8020177a:	fe843783          	ld	a5,-24(s0)
    8020177e:	e399                	bnez	a5,80201784 <create_pagetable+0x1e>
        return 0;
    80201780:	4781                	li	a5,0
    80201782:	a819                	j	80201798 <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    80201784:	6605                	lui	a2,0x1
    80201786:	4581                	li	a1,0
    80201788:	fe843503          	ld	a0,-24(s0)
    8020178c:	00000097          	auipc	ra,0x0
    80201790:	de4080e7          	jalr	-540(ra) # 80201570 <memset>
    return pt;
    80201794:	fe843783          	ld	a5,-24(s0)
}
    80201798:	853e                	mv	a0,a5
    8020179a:	60e2                	ld	ra,24(sp)
    8020179c:	6442                	ld	s0,16(sp)
    8020179e:	6105                	addi	sp,sp,32
    802017a0:	8082                	ret

00000000802017a2 <walk_lookup>:
// 辅助函数：仅查找
static pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    802017a2:	7179                	addi	sp,sp,-48
    802017a4:	f406                	sd	ra,40(sp)
    802017a6:	f022                	sd	s0,32(sp)
    802017a8:	1800                	addi	s0,sp,48
    802017aa:	fca43c23          	sd	a0,-40(s0)
    802017ae:	fcb43823          	sd	a1,-48(s0)
    if (va >= MAXVA)
    802017b2:	fd043703          	ld	a4,-48(s0)
    802017b6:	57fd                	li	a5,-1
    802017b8:	83e5                	srli	a5,a5,0x19
    802017ba:	00e7fa63          	bgeu	a5,a4,802017ce <walk_lookup+0x2c>
        panic("walk_lookup: va out of range");
    802017be:	00004517          	auipc	a0,0x4
    802017c2:	3f250513          	addi	a0,a0,1010 # 80205bb0 <small_numbers+0x990>
    802017c6:	fffff097          	auipc	ra,0xfffff
    802017ca:	6da080e7          	jalr	1754(ra) # 80200ea0 <panic>
    for (int level = 2; level > 0; level--) {
    802017ce:	4789                	li	a5,2
    802017d0:	fef42623          	sw	a5,-20(s0)
    802017d4:	a0a9                	j	8020181e <walk_lookup+0x7c>
        pte_t *pte = &pt[px(level, va)];
    802017d6:	fec42783          	lw	a5,-20(s0)
    802017da:	fd043583          	ld	a1,-48(s0)
    802017de:	853e                	mv	a0,a5
    802017e0:	00000097          	auipc	ra,0x0
    802017e4:	f4c080e7          	jalr	-180(ra) # 8020172c <px>
    802017e8:	87aa                	mv	a5,a0
    802017ea:	078e                	slli	a5,a5,0x3
    802017ec:	fd843703          	ld	a4,-40(s0)
    802017f0:	97ba                	add	a5,a5,a4
    802017f2:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    802017f6:	fe043783          	ld	a5,-32(s0)
    802017fa:	639c                	ld	a5,0(a5)
    802017fc:	8b85                	andi	a5,a5,1
    802017fe:	cb89                	beqz	a5,80201810 <walk_lookup+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    80201800:	fe043783          	ld	a5,-32(s0)
    80201804:	639c                	ld	a5,0(a5)
    80201806:	83a9                	srli	a5,a5,0xa
    80201808:	07b2                	slli	a5,a5,0xc
    8020180a:	fcf43c23          	sd	a5,-40(s0)
    8020180e:	a019                	j	80201814 <walk_lookup+0x72>
        } else {
            return 0;
    80201810:	4781                	li	a5,0
    80201812:	a03d                	j	80201840 <walk_lookup+0x9e>
    for (int level = 2; level > 0; level--) {
    80201814:	fec42783          	lw	a5,-20(s0)
    80201818:	37fd                	addiw	a5,a5,-1
    8020181a:	fef42623          	sw	a5,-20(s0)
    8020181e:	fec42783          	lw	a5,-20(s0)
    80201822:	2781                	sext.w	a5,a5
    80201824:	faf049e3          	bgtz	a5,802017d6 <walk_lookup+0x34>
        }
    }
    return &pt[px(0, va)];
    80201828:	fd043583          	ld	a1,-48(s0)
    8020182c:	4501                	li	a0,0
    8020182e:	00000097          	auipc	ra,0x0
    80201832:	efe080e7          	jalr	-258(ra) # 8020172c <px>
    80201836:	87aa                	mv	a5,a0
    80201838:	078e                	slli	a5,a5,0x3
    8020183a:	fd843703          	ld	a4,-40(s0)
    8020183e:	97ba                	add	a5,a5,a4
}
    80201840:	853e                	mv	a0,a5
    80201842:	70a2                	ld	ra,40(sp)
    80201844:	7402                	ld	s0,32(sp)
    80201846:	6145                	addi	sp,sp,48
    80201848:	8082                	ret

000000008020184a <walk_create>:

// 辅助函数：查找或分配
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    8020184a:	7139                	addi	sp,sp,-64
    8020184c:	fc06                	sd	ra,56(sp)
    8020184e:	f822                	sd	s0,48(sp)
    80201850:	0080                	addi	s0,sp,64
    80201852:	fca43423          	sd	a0,-56(s0)
    80201856:	fcb43023          	sd	a1,-64(s0)
    if (va >= MAXVA)
    8020185a:	fc043703          	ld	a4,-64(s0)
    8020185e:	57fd                	li	a5,-1
    80201860:	83e5                	srli	a5,a5,0x19
    80201862:	00e7fa63          	bgeu	a5,a4,80201876 <walk_create+0x2c>
        panic("walk_create: va out of range");
    80201866:	00004517          	auipc	a0,0x4
    8020186a:	36a50513          	addi	a0,a0,874 # 80205bd0 <small_numbers+0x9b0>
    8020186e:	fffff097          	auipc	ra,0xfffff
    80201872:	632080e7          	jalr	1586(ra) # 80200ea0 <panic>
    for (int level = 2; level > 0; level--) {
    80201876:	4789                	li	a5,2
    80201878:	fef42623          	sw	a5,-20(s0)
    8020187c:	a059                	j	80201902 <walk_create+0xb8>
        pte_t *pte = &pt[px(level, va)];
    8020187e:	fec42783          	lw	a5,-20(s0)
    80201882:	fc043583          	ld	a1,-64(s0)
    80201886:	853e                	mv	a0,a5
    80201888:	00000097          	auipc	ra,0x0
    8020188c:	ea4080e7          	jalr	-348(ra) # 8020172c <px>
    80201890:	87aa                	mv	a5,a0
    80201892:	078e                	slli	a5,a5,0x3
    80201894:	fc843703          	ld	a4,-56(s0)
    80201898:	97ba                	add	a5,a5,a4
    8020189a:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    8020189e:	fe043783          	ld	a5,-32(s0)
    802018a2:	639c                	ld	a5,0(a5)
    802018a4:	8b85                	andi	a5,a5,1
    802018a6:	cb89                	beqz	a5,802018b8 <walk_create+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    802018a8:	fe043783          	ld	a5,-32(s0)
    802018ac:	639c                	ld	a5,0(a5)
    802018ae:	83a9                	srli	a5,a5,0xa
    802018b0:	07b2                	slli	a5,a5,0xc
    802018b2:	fcf43423          	sd	a5,-56(s0)
    802018b6:	a089                	j	802018f8 <walk_create+0xae>
        } else {
            pagetable_t new_pt = (pagetable_t)alloc_page();
    802018b8:	00001097          	auipc	ra,0x1
    802018bc:	ba4080e7          	jalr	-1116(ra) # 8020245c <alloc_page>
    802018c0:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    802018c4:	fd843783          	ld	a5,-40(s0)
    802018c8:	e399                	bnez	a5,802018ce <walk_create+0x84>
                return 0;
    802018ca:	4781                	li	a5,0
    802018cc:	a8a1                	j	80201924 <walk_create+0xda>
            memset(new_pt, 0, PGSIZE);
    802018ce:	6605                	lui	a2,0x1
    802018d0:	4581                	li	a1,0
    802018d2:	fd843503          	ld	a0,-40(s0)
    802018d6:	00000097          	auipc	ra,0x0
    802018da:	c9a080e7          	jalr	-870(ra) # 80201570 <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    802018de:	fd843783          	ld	a5,-40(s0)
    802018e2:	83b1                	srli	a5,a5,0xc
    802018e4:	07aa                	slli	a5,a5,0xa
    802018e6:	0017e713          	ori	a4,a5,1
    802018ea:	fe043783          	ld	a5,-32(s0)
    802018ee:	e398                	sd	a4,0(a5)
            pt = new_pt;
    802018f0:	fd843783          	ld	a5,-40(s0)
    802018f4:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    802018f8:	fec42783          	lw	a5,-20(s0)
    802018fc:	37fd                	addiw	a5,a5,-1
    802018fe:	fef42623          	sw	a5,-20(s0)
    80201902:	fec42783          	lw	a5,-20(s0)
    80201906:	2781                	sext.w	a5,a5
    80201908:	f6f04be3          	bgtz	a5,8020187e <walk_create+0x34>
        }
    }
    return &pt[px(0, va)];
    8020190c:	fc043583          	ld	a1,-64(s0)
    80201910:	4501                	li	a0,0
    80201912:	00000097          	auipc	ra,0x0
    80201916:	e1a080e7          	jalr	-486(ra) # 8020172c <px>
    8020191a:	87aa                	mv	a5,a0
    8020191c:	078e                	slli	a5,a5,0x3
    8020191e:	fc843703          	ld	a4,-56(s0)
    80201922:	97ba                	add	a5,a5,a4
}
    80201924:	853e                	mv	a0,a5
    80201926:	70e2                	ld	ra,56(sp)
    80201928:	7442                	ld	s0,48(sp)
    8020192a:	6121                	addi	sp,sp,64
    8020192c:	8082                	ret

000000008020192e <map_page>:

// 建立映射，允许重映射到相同物理地址
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    8020192e:	7139                	addi	sp,sp,-64
    80201930:	fc06                	sd	ra,56(sp)
    80201932:	f822                	sd	s0,48(sp)
    80201934:	0080                	addi	s0,sp,64
    80201936:	fca43c23          	sd	a0,-40(s0)
    8020193a:	fcb43823          	sd	a1,-48(s0)
    8020193e:	fcc43423          	sd	a2,-56(s0)
    80201942:	87b6                	mv	a5,a3
    80201944:	fcf42223          	sw	a5,-60(s0)
    if ((va % PGSIZE) != 0)
    80201948:	fd043703          	ld	a4,-48(s0)
    8020194c:	6785                	lui	a5,0x1
    8020194e:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80201950:	8ff9                	and	a5,a5,a4
    80201952:	cb89                	beqz	a5,80201964 <map_page+0x36>
        panic("map_page: va not aligned");
    80201954:	00004517          	auipc	a0,0x4
    80201958:	29c50513          	addi	a0,a0,668 # 80205bf0 <small_numbers+0x9d0>
    8020195c:	fffff097          	auipc	ra,0xfffff
    80201960:	544080e7          	jalr	1348(ra) # 80200ea0 <panic>
    pte_t *pte = walk_create(pt, va);
    80201964:	fd043583          	ld	a1,-48(s0)
    80201968:	fd843503          	ld	a0,-40(s0)
    8020196c:	00000097          	auipc	ra,0x0
    80201970:	ede080e7          	jalr	-290(ra) # 8020184a <walk_create>
    80201974:	fea43423          	sd	a0,-24(s0)
    if (!pte)
    80201978:	fe843783          	ld	a5,-24(s0)
    8020197c:	e399                	bnez	a5,80201982 <map_page+0x54>
        return -1;
    8020197e:	57fd                	li	a5,-1
    80201980:	a069                	j	80201a0a <map_page+0xdc>
    
    // 检查是否已经映射
	if (*pte & PTE_V) {
    80201982:	fe843783          	ld	a5,-24(s0)
    80201986:	639c                	ld	a5,0(a5)
    80201988:	8b85                	andi	a5,a5,1
    8020198a:	c3b5                	beqz	a5,802019ee <map_page+0xc0>
		if (PTE2PA(*pte) == pa) {
    8020198c:	fe843783          	ld	a5,-24(s0)
    80201990:	639c                	ld	a5,0(a5)
    80201992:	83a9                	srli	a5,a5,0xa
    80201994:	07b2                	slli	a5,a5,0xc
    80201996:	fc843703          	ld	a4,-56(s0)
    8020199a:	04f71263          	bne	a4,a5,802019de <map_page+0xb0>
			// 只允许提升权限，不允许降低权限
			int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
    8020199e:	fe843783          	ld	a5,-24(s0)
    802019a2:	639c                	ld	a5,0(a5)
    802019a4:	2781                	sext.w	a5,a5
    802019a6:	3ff7f793          	andi	a5,a5,1023
    802019aa:	0007871b          	sext.w	a4,a5
    802019ae:	fc442783          	lw	a5,-60(s0)
    802019b2:	8fd9                	or	a5,a5,a4
    802019b4:	2781                	sext.w	a5,a5
    802019b6:	2781                	sext.w	a5,a5
    802019b8:	3ff7f793          	andi	a5,a5,1023
    802019bc:	fef42223          	sw	a5,-28(s0)
			*pte = PA2PTE(pa) | new_perm | PTE_V;
    802019c0:	fc843783          	ld	a5,-56(s0)
    802019c4:	83b1                	srli	a5,a5,0xc
    802019c6:	00a79713          	slli	a4,a5,0xa
    802019ca:	fe442783          	lw	a5,-28(s0)
    802019ce:	8fd9                	or	a5,a5,a4
    802019d0:	0017e713          	ori	a4,a5,1
    802019d4:	fe843783          	ld	a5,-24(s0)
    802019d8:	e398                	sd	a4,0(a5)
			return 0;
    802019da:	4781                	li	a5,0
    802019dc:	a03d                	j	80201a0a <map_page+0xdc>
		} else {
			panic("map_page: remap to different physical address");
    802019de:	00004517          	auipc	a0,0x4
    802019e2:	23250513          	addi	a0,a0,562 # 80205c10 <small_numbers+0x9f0>
    802019e6:	fffff097          	auipc	ra,0xfffff
    802019ea:	4ba080e7          	jalr	1210(ra) # 80200ea0 <panic>
		}
	}
    
    *pte = PA2PTE(pa) | perm | PTE_V;
    802019ee:	fc843783          	ld	a5,-56(s0)
    802019f2:	83b1                	srli	a5,a5,0xc
    802019f4:	00a79713          	slli	a4,a5,0xa
    802019f8:	fc442783          	lw	a5,-60(s0)
    802019fc:	8fd9                	or	a5,a5,a4
    802019fe:	0017e713          	ori	a4,a5,1
    80201a02:	fe843783          	ld	a5,-24(s0)
    80201a06:	e398                	sd	a4,0(a5)
    return 0;
    80201a08:	4781                	li	a5,0
}
    80201a0a:	853e                	mv	a0,a5
    80201a0c:	70e2                	ld	ra,56(sp)
    80201a0e:	7442                	ld	s0,48(sp)
    80201a10:	6121                	addi	sp,sp,64
    80201a12:	8082                	ret

0000000080201a14 <free_pagetable>:
// 递归释放页表
void free_pagetable(pagetable_t pt) {
    80201a14:	7139                	addi	sp,sp,-64
    80201a16:	fc06                	sd	ra,56(sp)
    80201a18:	f822                	sd	s0,48(sp)
    80201a1a:	0080                	addi	s0,sp,64
    80201a1c:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    80201a20:	fe042623          	sw	zero,-20(s0)
    80201a24:	a8a5                	j	80201a9c <free_pagetable+0x88>
        pte_t pte = pt[i];
    80201a26:	fec42783          	lw	a5,-20(s0)
    80201a2a:	078e                	slli	a5,a5,0x3
    80201a2c:	fc843703          	ld	a4,-56(s0)
    80201a30:	97ba                	add	a5,a5,a4
    80201a32:	639c                	ld	a5,0(a5)
    80201a34:	fef43023          	sd	a5,-32(s0)
        // 只释放中间页表
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80201a38:	fe043783          	ld	a5,-32(s0)
    80201a3c:	8b85                	andi	a5,a5,1
    80201a3e:	cb95                	beqz	a5,80201a72 <free_pagetable+0x5e>
    80201a40:	fe043783          	ld	a5,-32(s0)
    80201a44:	8bb9                	andi	a5,a5,14
    80201a46:	e795                	bnez	a5,80201a72 <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    80201a48:	fe043783          	ld	a5,-32(s0)
    80201a4c:	83a9                	srli	a5,a5,0xa
    80201a4e:	07b2                	slli	a5,a5,0xc
    80201a50:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    80201a54:	fd843503          	ld	a0,-40(s0)
    80201a58:	00000097          	auipc	ra,0x0
    80201a5c:	fbc080e7          	jalr	-68(ra) # 80201a14 <free_pagetable>
            pt[i] = 0;
    80201a60:	fec42783          	lw	a5,-20(s0)
    80201a64:	078e                	slli	a5,a5,0x3
    80201a66:	fc843703          	ld	a4,-56(s0)
    80201a6a:	97ba                	add	a5,a5,a4
    80201a6c:	0007b023          	sd	zero,0(a5)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80201a70:	a00d                	j	80201a92 <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    80201a72:	fe043783          	ld	a5,-32(s0)
    80201a76:	8b85                	andi	a5,a5,1
    80201a78:	cf89                	beqz	a5,80201a92 <free_pagetable+0x7e>
    80201a7a:	fe043783          	ld	a5,-32(s0)
    80201a7e:	8bb9                	andi	a5,a5,14
    80201a80:	cb89                	beqz	a5,80201a92 <free_pagetable+0x7e>
            pt[i] = 0;
    80201a82:	fec42783          	lw	a5,-20(s0)
    80201a86:	078e                	slli	a5,a5,0x3
    80201a88:	fc843703          	ld	a4,-56(s0)
    80201a8c:	97ba                	add	a5,a5,a4
    80201a8e:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    80201a92:	fec42783          	lw	a5,-20(s0)
    80201a96:	2785                	addiw	a5,a5,1
    80201a98:	fef42623          	sw	a5,-20(s0)
    80201a9c:	fec42783          	lw	a5,-20(s0)
    80201aa0:	0007871b          	sext.w	a4,a5
    80201aa4:	1ff00793          	li	a5,511
    80201aa8:	f6e7dfe3          	bge	a5,a4,80201a26 <free_pagetable+0x12>
        }
    }
    free_page(pt);
    80201aac:	fc843503          	ld	a0,-56(s0)
    80201ab0:	00001097          	auipc	ra,0x1
    80201ab4:	a18080e7          	jalr	-1512(ra) # 802024c8 <free_page>
}
    80201ab8:	0001                	nop
    80201aba:	70e2                	ld	ra,56(sp)
    80201abc:	7442                	ld	s0,48(sp)
    80201abe:	6121                	addi	sp,sp,64
    80201ac0:	8082                	ret

0000000080201ac2 <kvmmake>:

// 内核页表构建（仅映射内核代码和数据，实际可根据需要扩展）
static pagetable_t kvmmake(void) {
    80201ac2:	711d                	addi	sp,sp,-96
    80201ac4:	ec86                	sd	ra,88(sp)
    80201ac6:	e8a2                	sd	s0,80(sp)
    80201ac8:	1080                	addi	s0,sp,96
    pagetable_t kpgtbl = create_pagetable();
    80201aca:	00000097          	auipc	ra,0x0
    80201ace:	c9c080e7          	jalr	-868(ra) # 80201766 <create_pagetable>
    80201ad2:	faa43c23          	sd	a0,-72(s0)
    if (!kpgtbl)
    80201ad6:	fb843783          	ld	a5,-72(s0)
    80201ada:	eb89                	bnez	a5,80201aec <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    80201adc:	00004517          	auipc	a0,0x4
    80201ae0:	16450513          	addi	a0,a0,356 # 80205c40 <small_numbers+0xa20>
    80201ae4:	fffff097          	auipc	ra,0xfffff
    80201ae8:	3bc080e7          	jalr	956(ra) # 80200ea0 <panic>
    // 1. 映射内核代码和数据区域（只读+执行 / 读写）
    extern char etext[];  // 在kernel.ld中定义，内核代码段结束位置
    extern char end[];    // 在kernel.ld中定义，内核数据段结束位置
    
    // 内核代码段 - 只读可执行
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    80201aec:	4785                	li	a5,1
    80201aee:	07fe                	slli	a5,a5,0x1f
    80201af0:	fef43423          	sd	a5,-24(s0)
    80201af4:	a825                	j	80201b2c <kvmmake+0x6a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_X) != 0)
    80201af6:	46a9                	li	a3,10
    80201af8:	fe843603          	ld	a2,-24(s0)
    80201afc:	fe843583          	ld	a1,-24(s0)
    80201b00:	fb843503          	ld	a0,-72(s0)
    80201b04:	00000097          	auipc	ra,0x0
    80201b08:	e2a080e7          	jalr	-470(ra) # 8020192e <map_page>
    80201b0c:	87aa                	mv	a5,a0
    80201b0e:	cb89                	beqz	a5,80201b20 <kvmmake+0x5e>
            panic("kvmmake: code map failed");
    80201b10:	00004517          	auipc	a0,0x4
    80201b14:	14850513          	addi	a0,a0,328 # 80205c58 <small_numbers+0xa38>
    80201b18:	fffff097          	auipc	ra,0xfffff
    80201b1c:	388080e7          	jalr	904(ra) # 80200ea0 <panic>
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    80201b20:	fe843703          	ld	a4,-24(s0)
    80201b24:	6785                	lui	a5,0x1
    80201b26:	97ba                	add	a5,a5,a4
    80201b28:	fef43423          	sd	a5,-24(s0)
    80201b2c:	00003797          	auipc	a5,0x3
    80201b30:	4d478793          	addi	a5,a5,1236 # 80205000 <etext>
    80201b34:	fe843703          	ld	a4,-24(s0)
    80201b38:	faf76fe3          	bltu	a4,a5,80201af6 <kvmmake+0x34>
    }
    
    // 内核数据段 - 可读写
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    80201b3c:	00003797          	auipc	a5,0x3
    80201b40:	4c478793          	addi	a5,a5,1220 # 80205000 <etext>
    80201b44:	fef43023          	sd	a5,-32(s0)
    80201b48:	a825                	j	80201b80 <kvmmake+0xbe>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201b4a:	4699                	li	a3,6
    80201b4c:	fe043603          	ld	a2,-32(s0)
    80201b50:	fe043583          	ld	a1,-32(s0)
    80201b54:	fb843503          	ld	a0,-72(s0)
    80201b58:	00000097          	auipc	ra,0x0
    80201b5c:	dd6080e7          	jalr	-554(ra) # 8020192e <map_page>
    80201b60:	87aa                	mv	a5,a0
    80201b62:	cb89                	beqz	a5,80201b74 <kvmmake+0xb2>
            panic("kvmmake: data map failed");
    80201b64:	00004517          	auipc	a0,0x4
    80201b68:	11450513          	addi	a0,a0,276 # 80205c78 <small_numbers+0xa58>
    80201b6c:	fffff097          	auipc	ra,0xfffff
    80201b70:	334080e7          	jalr	820(ra) # 80200ea0 <panic>
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    80201b74:	fe043703          	ld	a4,-32(s0)
    80201b78:	6785                	lui	a5,0x1
    80201b7a:	97ba                	add	a5,a5,a4
    80201b7c:	fef43023          	sd	a5,-32(s0)
    80201b80:	0000c797          	auipc	a5,0xc
    80201b84:	9d078793          	addi	a5,a5,-1584 # 8020d550 <_bss_end>
    80201b88:	fe043703          	ld	a4,-32(s0)
    80201b8c:	faf76fe3          	bltu	a4,a5,80201b4a <kvmmake+0x88>
    }
    
	// 2. 映射内核堆区域 - 可读写
	uint64 aligned_end = ((uint64)end + PGSIZE - 1) & ~(PGSIZE - 1); // 向上对齐到页边界
    80201b90:	0000c717          	auipc	a4,0xc
    80201b94:	9c070713          	addi	a4,a4,-1600 # 8020d550 <_bss_end>
    80201b98:	6785                	lui	a5,0x1
    80201b9a:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80201b9c:	973e                	add	a4,a4,a5
    80201b9e:	77fd                	lui	a5,0xfffff
    80201ba0:	8ff9                	and	a5,a5,a4
    80201ba2:	faf43823          	sd	a5,-80(s0)
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    80201ba6:	fb043783          	ld	a5,-80(s0)
    80201baa:	fcf43c23          	sd	a5,-40(s0)
    80201bae:	a825                	j	80201be6 <kvmmake+0x124>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201bb0:	4699                	li	a3,6
    80201bb2:	fd843603          	ld	a2,-40(s0)
    80201bb6:	fd843583          	ld	a1,-40(s0)
    80201bba:	fb843503          	ld	a0,-72(s0)
    80201bbe:	00000097          	auipc	ra,0x0
    80201bc2:	d70080e7          	jalr	-656(ra) # 8020192e <map_page>
    80201bc6:	87aa                	mv	a5,a0
    80201bc8:	cb89                	beqz	a5,80201bda <kvmmake+0x118>
			panic("kvmmake: heap map failed");
    80201bca:	00004517          	auipc	a0,0x4
    80201bce:	0ce50513          	addi	a0,a0,206 # 80205c98 <small_numbers+0xa78>
    80201bd2:	fffff097          	auipc	ra,0xfffff
    80201bd6:	2ce080e7          	jalr	718(ra) # 80200ea0 <panic>
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    80201bda:	fd843703          	ld	a4,-40(s0)
    80201bde:	6785                	lui	a5,0x1
    80201be0:	97ba                	add	a5,a5,a4
    80201be2:	fcf43c23          	sd	a5,-40(s0)
    80201be6:	fd843703          	ld	a4,-40(s0)
    80201bea:	47c5                	li	a5,17
    80201bec:	07ee                	slli	a5,a5,0x1b
    80201bee:	fcf761e3          	bltu	a4,a5,80201bb0 <kvmmake+0xee>
	}
    
    // 3. 映射设备区域 - 只读写，不可执行
    // UART 串口设备
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    80201bf2:	4699                	li	a3,6
    80201bf4:	10000637          	lui	a2,0x10000
    80201bf8:	100005b7          	lui	a1,0x10000
    80201bfc:	fb843503          	ld	a0,-72(s0)
    80201c00:	00000097          	auipc	ra,0x0
    80201c04:	d2e080e7          	jalr	-722(ra) # 8020192e <map_page>
    80201c08:	87aa                	mv	a5,a0
    80201c0a:	cb89                	beqz	a5,80201c1c <kvmmake+0x15a>
        panic("kvmmake: uart map failed");
    80201c0c:	00004517          	auipc	a0,0x4
    80201c10:	0ac50513          	addi	a0,a0,172 # 80205cb8 <small_numbers+0xa98>
    80201c14:	fffff097          	auipc	ra,0xfffff
    80201c18:	28c080e7          	jalr	652(ra) # 80200ea0 <panic>
    
    // PLIC 中断控制器
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80201c1c:	0c0007b7          	lui	a5,0xc000
    80201c20:	fcf43823          	sd	a5,-48(s0)
    80201c24:	a825                	j	80201c5c <kvmmake+0x19a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201c26:	4699                	li	a3,6
    80201c28:	fd043603          	ld	a2,-48(s0)
    80201c2c:	fd043583          	ld	a1,-48(s0)
    80201c30:	fb843503          	ld	a0,-72(s0)
    80201c34:	00000097          	auipc	ra,0x0
    80201c38:	cfa080e7          	jalr	-774(ra) # 8020192e <map_page>
    80201c3c:	87aa                	mv	a5,a0
    80201c3e:	cb89                	beqz	a5,80201c50 <kvmmake+0x18e>
            panic("kvmmake: plic map failed");
    80201c40:	00004517          	auipc	a0,0x4
    80201c44:	09850513          	addi	a0,a0,152 # 80205cd8 <small_numbers+0xab8>
    80201c48:	fffff097          	auipc	ra,0xfffff
    80201c4c:	258080e7          	jalr	600(ra) # 80200ea0 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80201c50:	fd043703          	ld	a4,-48(s0)
    80201c54:	6785                	lui	a5,0x1
    80201c56:	97ba                	add	a5,a5,a4
    80201c58:	fcf43823          	sd	a5,-48(s0)
    80201c5c:	fd043703          	ld	a4,-48(s0)
    80201c60:	0c4007b7          	lui	a5,0xc400
    80201c64:	fcf761e3          	bltu	a4,a5,80201c26 <kvmmake+0x164>
    }
    
    // CLINT 本地中断控制器 - 完善映射
    // 确保整个 CLINT 区域被映射，特别是 mtimecmp 和 mtime 寄存器
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80201c68:	020007b7          	lui	a5,0x2000
    80201c6c:	fcf43423          	sd	a5,-56(s0)
    80201c70:	a825                	j	80201ca8 <kvmmake+0x1e6>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201c72:	4699                	li	a3,6
    80201c74:	fc843603          	ld	a2,-56(s0)
    80201c78:	fc843583          	ld	a1,-56(s0)
    80201c7c:	fb843503          	ld	a0,-72(s0)
    80201c80:	00000097          	auipc	ra,0x0
    80201c84:	cae080e7          	jalr	-850(ra) # 8020192e <map_page>
    80201c88:	87aa                	mv	a5,a0
    80201c8a:	cb89                	beqz	a5,80201c9c <kvmmake+0x1da>
            panic("kvmmake: clint map failed");
    80201c8c:	00004517          	auipc	a0,0x4
    80201c90:	06c50513          	addi	a0,a0,108 # 80205cf8 <small_numbers+0xad8>
    80201c94:	fffff097          	auipc	ra,0xfffff
    80201c98:	20c080e7          	jalr	524(ra) # 80200ea0 <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80201c9c:	fc843703          	ld	a4,-56(s0)
    80201ca0:	6785                	lui	a5,0x1
    80201ca2:	97ba                	add	a5,a5,a4
    80201ca4:	fcf43423          	sd	a5,-56(s0)
    80201ca8:	fc843703          	ld	a4,-56(s0)
    80201cac:	020107b7          	lui	a5,0x2010
    80201cb0:	fcf761e3          	bltu	a4,a5,80201c72 <kvmmake+0x1b0>
	}
    
    // VIRTIO 设备
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    80201cb4:	4699                	li	a3,6
    80201cb6:	10001637          	lui	a2,0x10001
    80201cba:	100015b7          	lui	a1,0x10001
    80201cbe:	fb843503          	ld	a0,-72(s0)
    80201cc2:	00000097          	auipc	ra,0x0
    80201cc6:	c6c080e7          	jalr	-916(ra) # 8020192e <map_page>
    80201cca:	87aa                	mv	a5,a0
    80201ccc:	cb89                	beqz	a5,80201cde <kvmmake+0x21c>
        panic("kvmmake: virtio map failed");
    80201cce:	00004517          	auipc	a0,0x4
    80201cd2:	04a50513          	addi	a0,a0,74 # 80205d18 <small_numbers+0xaf8>
    80201cd6:	fffff097          	auipc	ra,0xfffff
    80201cda:	1ca080e7          	jalr	458(ra) # 80200ea0 <panic>
    
    // 4. 扩大SBI调用区域映射
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    80201cde:	fc043023          	sd	zero,-64(s0)
    80201ce2:	a825                	j	80201d1a <kvmmake+0x258>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201ce4:	4699                	li	a3,6
    80201ce6:	fc043603          	ld	a2,-64(s0)
    80201cea:	fc043583          	ld	a1,-64(s0)
    80201cee:	fb843503          	ld	a0,-72(s0)
    80201cf2:	00000097          	auipc	ra,0x0
    80201cf6:	c3c080e7          	jalr	-964(ra) # 8020192e <map_page>
    80201cfa:	87aa                	mv	a5,a0
    80201cfc:	cb89                	beqz	a5,80201d0e <kvmmake+0x24c>
			panic("kvmmake: low memory map failed");
    80201cfe:	00004517          	auipc	a0,0x4
    80201d02:	03a50513          	addi	a0,a0,58 # 80205d38 <small_numbers+0xb18>
    80201d06:	fffff097          	auipc	ra,0xfffff
    80201d0a:	19a080e7          	jalr	410(ra) # 80200ea0 <panic>
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    80201d0e:	fc043703          	ld	a4,-64(s0)
    80201d12:	6785                	lui	a5,0x1
    80201d14:	97ba                	add	a5,a5,a4
    80201d16:	fcf43023          	sd	a5,-64(s0)
    80201d1a:	fc043703          	ld	a4,-64(s0)
    80201d1e:	001007b7          	lui	a5,0x100
    80201d22:	fcf761e3          	bltu	a4,a5,80201ce4 <kvmmake+0x222>
	}

	// 特别映射包含0xfd02080的页
	uint64 sbi_special = 0xfd02000;  // 页对齐
    80201d26:	0fd027b7          	lui	a5,0xfd02
    80201d2a:	faf43423          	sd	a5,-88(s0)
	if (map_page(kpgtbl, sbi_special, sbi_special, PTE_R | PTE_W) != 0)
    80201d2e:	4699                	li	a3,6
    80201d30:	fa843603          	ld	a2,-88(s0)
    80201d34:	fa843583          	ld	a1,-88(s0)
    80201d38:	fb843503          	ld	a0,-72(s0)
    80201d3c:	00000097          	auipc	ra,0x0
    80201d40:	bf2080e7          	jalr	-1038(ra) # 8020192e <map_page>
    80201d44:	87aa                	mv	a5,a0
    80201d46:	cb89                	beqz	a5,80201d58 <kvmmake+0x296>
		panic("kvmmake: sbi special area map failed");
    80201d48:	00004517          	auipc	a0,0x4
    80201d4c:	01050513          	addi	a0,a0,16 # 80205d58 <small_numbers+0xb38>
    80201d50:	fffff097          	auipc	ra,0xfffff
    80201d54:	150080e7          	jalr	336(ra) # 80200ea0 <panic>
    
    return kpgtbl;
    80201d58:	fb843783          	ld	a5,-72(s0)
}
    80201d5c:	853e                	mv	a0,a5
    80201d5e:	60e6                	ld	ra,88(sp)
    80201d60:	6446                	ld	s0,80(sp)
    80201d62:	6125                	addi	sp,sp,96
    80201d64:	8082                	ret

0000000080201d66 <kvminit>:
// 初始化内核页表
void kvminit(void) {
    80201d66:	1141                	addi	sp,sp,-16
    80201d68:	e406                	sd	ra,8(sp)
    80201d6a:	e022                	sd	s0,0(sp)
    80201d6c:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    80201d6e:	00000097          	auipc	ra,0x0
    80201d72:	d54080e7          	jalr	-684(ra) # 80201ac2 <kvmmake>
    80201d76:	872a                	mv	a4,a0
    80201d78:	00008797          	auipc	a5,0x8
    80201d7c:	2a878793          	addi	a5,a5,680 # 8020a020 <kernel_pagetable>
    80201d80:	e398                	sd	a4,0(a5)
}
    80201d82:	0001                	nop
    80201d84:	60a2                	ld	ra,8(sp)
    80201d86:	6402                	ld	s0,0(sp)
    80201d88:	0141                	addi	sp,sp,16
    80201d8a:	8082                	ret

0000000080201d8c <w_satp>:

// 启用分页（单核只需设置一次 satp 并刷新 TLB）
static inline void w_satp(uint64 x) {
    80201d8c:	1101                	addi	sp,sp,-32
    80201d8e:	ec22                	sd	s0,24(sp)
    80201d90:	1000                	addi	s0,sp,32
    80201d92:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    80201d96:	fe843783          	ld	a5,-24(s0)
    80201d9a:	18079073          	csrw	satp,a5
}
    80201d9e:	0001                	nop
    80201da0:	6462                	ld	s0,24(sp)
    80201da2:	6105                	addi	sp,sp,32
    80201da4:	8082                	ret

0000000080201da6 <sfence_vma>:

inline void sfence_vma(void) {
    80201da6:	1141                	addi	sp,sp,-16
    80201da8:	e422                	sd	s0,8(sp)
    80201daa:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    80201dac:	12000073          	sfence.vma
}
    80201db0:	0001                	nop
    80201db2:	6422                	ld	s0,8(sp)
    80201db4:	0141                	addi	sp,sp,16
    80201db6:	8082                	ret

0000000080201db8 <kvminithart>:

void kvminithart(void) {
    80201db8:	1141                	addi	sp,sp,-16
    80201dba:	e406                	sd	ra,8(sp)
    80201dbc:	e022                	sd	s0,0(sp)
    80201dbe:	0800                	addi	s0,sp,16
    sfence_vma();
    80201dc0:	00000097          	auipc	ra,0x0
    80201dc4:	fe6080e7          	jalr	-26(ra) # 80201da6 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    80201dc8:	00008797          	auipc	a5,0x8
    80201dcc:	25878793          	addi	a5,a5,600 # 8020a020 <kernel_pagetable>
    80201dd0:	639c                	ld	a5,0(a5)
    80201dd2:	00c7d713          	srli	a4,a5,0xc
    80201dd6:	57fd                	li	a5,-1
    80201dd8:	17fe                	slli	a5,a5,0x3f
    80201dda:	8fd9                	or	a5,a5,a4
    80201ddc:	853e                	mv	a0,a5
    80201dde:	00000097          	auipc	ra,0x0
    80201de2:	fae080e7          	jalr	-82(ra) # 80201d8c <w_satp>
    sfence_vma();
    80201de6:	00000097          	auipc	ra,0x0
    80201dea:	fc0080e7          	jalr	-64(ra) # 80201da6 <sfence_vma>
}
    80201dee:	0001                	nop
    80201df0:	60a2                	ld	ra,8(sp)
    80201df2:	6402                	ld	s0,0(sp)
    80201df4:	0141                	addi	sp,sp,16
    80201df6:	8082                	ret

0000000080201df8 <get_current_pagetable>:
// 获取当前页表
pagetable_t get_current_pagetable(void) {
    80201df8:	1141                	addi	sp,sp,-16
    80201dfa:	e422                	sd	s0,8(sp)
    80201dfc:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    80201dfe:	00008797          	auipc	a5,0x8
    80201e02:	22278793          	addi	a5,a5,546 # 8020a020 <kernel_pagetable>
    80201e06:	639c                	ld	a5,0(a5)
}
    80201e08:	853e                	mv	a0,a5
    80201e0a:	6422                	ld	s0,8(sp)
    80201e0c:	0141                	addi	sp,sp,16
    80201e0e:	8082                	ret

0000000080201e10 <handle_page_fault>:

// 处理页面故障（按需分配内存）
// type: 1=指令页，2=读数据页，3=写数据页
int handle_page_fault(uint64 va, int type) {
    80201e10:	7139                	addi	sp,sp,-64
    80201e12:	fc06                	sd	ra,56(sp)
    80201e14:	f822                	sd	s0,48(sp)
    80201e16:	0080                	addi	s0,sp,64
    80201e18:	fca43423          	sd	a0,-56(s0)
    80201e1c:	87ae                	mv	a5,a1
    80201e1e:	fcf42223          	sw	a5,-60(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    80201e22:	fc442783          	lw	a5,-60(s0)
    80201e26:	863e                	mv	a2,a5
    80201e28:	fc843583          	ld	a1,-56(s0)
    80201e2c:	00004517          	auipc	a0,0x4
    80201e30:	f5450513          	addi	a0,a0,-172 # 80205d80 <small_numbers+0xb60>
    80201e34:	ffffe097          	auipc	ra,0xffffe
    80201e38:	764080e7          	jalr	1892(ra) # 80200598 <printf>
    
    // 页对齐地址
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    80201e3c:	fc843703          	ld	a4,-56(s0)
    80201e40:	77fd                	lui	a5,0xfffff
    80201e42:	8ff9                	and	a5,a5,a4
    80201e44:	fef43023          	sd	a5,-32(s0)
    
    // 检查地址是否合法
    if (page_va >= MAXVA) {
    80201e48:	fe043703          	ld	a4,-32(s0)
    80201e4c:	57fd                	li	a5,-1
    80201e4e:	83e5                	srli	a5,a5,0x19
    80201e50:	00e7fc63          	bgeu	a5,a4,80201e68 <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    80201e54:	00004517          	auipc	a0,0x4
    80201e58:	f5c50513          	addi	a0,a0,-164 # 80205db0 <small_numbers+0xb90>
    80201e5c:	ffffe097          	auipc	ra,0xffffe
    80201e60:	73c080e7          	jalr	1852(ra) # 80200598 <printf>
        return 0; // 地址超出最大虚拟地址空间
    80201e64:	4781                	li	a5,0
    80201e66:	a275                	j	80202012 <handle_page_fault+0x202>
    }
    
    // 先检查是否已经有映射
    pte_t *pte = walk_lookup(kernel_pagetable, page_va);
    80201e68:	00008797          	auipc	a5,0x8
    80201e6c:	1b878793          	addi	a5,a5,440 # 8020a020 <kernel_pagetable>
    80201e70:	639c                	ld	a5,0(a5)
    80201e72:	fe043583          	ld	a1,-32(s0)
    80201e76:	853e                	mv	a0,a5
    80201e78:	00000097          	auipc	ra,0x0
    80201e7c:	92a080e7          	jalr	-1750(ra) # 802017a2 <walk_lookup>
    80201e80:	fca43c23          	sd	a0,-40(s0)
    if (pte && (*pte & PTE_V)) {
    80201e84:	fd843783          	ld	a5,-40(s0)
    80201e88:	c3dd                	beqz	a5,80201f2e <handle_page_fault+0x11e>
    80201e8a:	fd843783          	ld	a5,-40(s0)
    80201e8e:	639c                	ld	a5,0(a5)
    80201e90:	8b85                	andi	a5,a5,1
    80201e92:	cfd1                	beqz	a5,80201f2e <handle_page_fault+0x11e>
        // 检查是否只是权限不足
        int need_perm = 0;
    80201e94:	fe042623          	sw	zero,-20(s0)
        if (type == 1) need_perm = PTE_X;
    80201e98:	fc442783          	lw	a5,-60(s0)
    80201e9c:	0007871b          	sext.w	a4,a5
    80201ea0:	4785                	li	a5,1
    80201ea2:	00f71663          	bne	a4,a5,80201eae <handle_page_fault+0x9e>
    80201ea6:	47a1                	li	a5,8
    80201ea8:	fef42623          	sw	a5,-20(s0)
    80201eac:	a035                	j	80201ed8 <handle_page_fault+0xc8>
        else if (type == 2) need_perm = PTE_R;
    80201eae:	fc442783          	lw	a5,-60(s0)
    80201eb2:	0007871b          	sext.w	a4,a5
    80201eb6:	4789                	li	a5,2
    80201eb8:	00f71663          	bne	a4,a5,80201ec4 <handle_page_fault+0xb4>
    80201ebc:	4789                	li	a5,2
    80201ebe:	fef42623          	sw	a5,-20(s0)
    80201ec2:	a819                	j	80201ed8 <handle_page_fault+0xc8>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    80201ec4:	fc442783          	lw	a5,-60(s0)
    80201ec8:	0007871b          	sext.w	a4,a5
    80201ecc:	478d                	li	a5,3
    80201ece:	00f71563          	bne	a4,a5,80201ed8 <handle_page_fault+0xc8>
    80201ed2:	4799                	li	a5,6
    80201ed4:	fef42623          	sw	a5,-20(s0)
        
        if ((*pte & need_perm) != need_perm) {
    80201ed8:	fd843783          	ld	a5,-40(s0)
    80201edc:	6398                	ld	a4,0(a5)
    80201ede:	fec42783          	lw	a5,-20(s0)
    80201ee2:	8f7d                	and	a4,a4,a5
    80201ee4:	fec42783          	lw	a5,-20(s0)
    80201ee8:	02f70963          	beq	a4,a5,80201f1a <handle_page_fault+0x10a>
            // 更新权限
            *pte |= need_perm;
    80201eec:	fd843783          	ld	a5,-40(s0)
    80201ef0:	6398                	ld	a4,0(a5)
    80201ef2:	fec42783          	lw	a5,-20(s0)
    80201ef6:	8f5d                	or	a4,a4,a5
    80201ef8:	fd843783          	ld	a5,-40(s0)
    80201efc:	e398                	sd	a4,0(a5)
            sfence_vma();
    80201efe:	00000097          	auipc	ra,0x0
    80201f02:	ea8080e7          	jalr	-344(ra) # 80201da6 <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    80201f06:	00004517          	auipc	a0,0x4
    80201f0a:	ed250513          	addi	a0,a0,-302 # 80205dd8 <small_numbers+0xbb8>
    80201f0e:	ffffe097          	auipc	ra,0xffffe
    80201f12:	68a080e7          	jalr	1674(ra) # 80200598 <printf>
            return 1;
    80201f16:	4785                	li	a5,1
    80201f18:	a8ed                	j	80202012 <handle_page_fault+0x202>
        }
        
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80201f1a:	00004517          	auipc	a0,0x4
    80201f1e:	ee650513          	addi	a0,a0,-282 # 80205e00 <small_numbers+0xbe0>
    80201f22:	ffffe097          	auipc	ra,0xffffe
    80201f26:	676080e7          	jalr	1654(ra) # 80200598 <printf>
        return 1;
    80201f2a:	4785                	li	a5,1
    80201f2c:	a0dd                	j	80202012 <handle_page_fault+0x202>
    }
    
    // 分配物理页
    void* page = alloc_page();
    80201f2e:	00000097          	auipc	ra,0x0
    80201f32:	52e080e7          	jalr	1326(ra) # 8020245c <alloc_page>
    80201f36:	fca43823          	sd	a0,-48(s0)
    if (page == 0) {
    80201f3a:	fd043783          	ld	a5,-48(s0)
    80201f3e:	eb99                	bnez	a5,80201f54 <handle_page_fault+0x144>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    80201f40:	00004517          	auipc	a0,0x4
    80201f44:	ef050513          	addi	a0,a0,-272 # 80205e30 <small_numbers+0xc10>
    80201f48:	ffffe097          	auipc	ra,0xffffe
    80201f4c:	650080e7          	jalr	1616(ra) # 80200598 <printf>
        return 0; // 内存不足
    80201f50:	4781                	li	a5,0
    80201f52:	a0c1                	j	80202012 <handle_page_fault+0x202>
    }
    
    // 清零内存
    memset(page, 0, PGSIZE);
    80201f54:	6605                	lui	a2,0x1
    80201f56:	4581                	li	a1,0
    80201f58:	fd043503          	ld	a0,-48(s0)
    80201f5c:	fffff097          	auipc	ra,0xfffff
    80201f60:	614080e7          	jalr	1556(ra) # 80201570 <memset>
    
    // 设置权限
    int perm = 0;
    80201f64:	fe042423          	sw	zero,-24(s0)
    if (type == 1) {  // 指令页
    80201f68:	fc442783          	lw	a5,-60(s0)
    80201f6c:	0007871b          	sext.w	a4,a5
    80201f70:	4785                	li	a5,1
    80201f72:	00f71663          	bne	a4,a5,80201f7e <handle_page_fault+0x16e>
        perm = PTE_X | PTE_R;  // 可执行页通常也需要可读
    80201f76:	47a9                	li	a5,10
    80201f78:	fef42423          	sw	a5,-24(s0)
    80201f7c:	a035                	j	80201fa8 <handle_page_fault+0x198>
    } else if (type == 2) {  // 读数据页
    80201f7e:	fc442783          	lw	a5,-60(s0)
    80201f82:	0007871b          	sext.w	a4,a5
    80201f86:	4789                	li	a5,2
    80201f88:	00f71663          	bne	a4,a5,80201f94 <handle_page_fault+0x184>
        perm = PTE_R;
    80201f8c:	4789                	li	a5,2
    80201f8e:	fef42423          	sw	a5,-24(s0)
    80201f92:	a819                	j	80201fa8 <handle_page_fault+0x198>
    } else if (type == 3) {  // 写数据页
    80201f94:	fc442783          	lw	a5,-60(s0)
    80201f98:	0007871b          	sext.w	a4,a5
    80201f9c:	478d                	li	a5,3
    80201f9e:	00f71563          	bne	a4,a5,80201fa8 <handle_page_fault+0x198>
        perm = PTE_R | PTE_W;
    80201fa2:	4799                	li	a5,6
    80201fa4:	fef42423          	sw	a5,-24(s0)
    }
    
    // 映射页面
    if (map_page(kernel_pagetable, page_va, (uint64)page, perm) != 0) {
    80201fa8:	00008797          	auipc	a5,0x8
    80201fac:	07878793          	addi	a5,a5,120 # 8020a020 <kernel_pagetable>
    80201fb0:	639c                	ld	a5,0(a5)
    80201fb2:	fd043703          	ld	a4,-48(s0)
    80201fb6:	fe842683          	lw	a3,-24(s0)
    80201fba:	863a                	mv	a2,a4
    80201fbc:	fe043583          	ld	a1,-32(s0)
    80201fc0:	853e                	mv	a0,a5
    80201fc2:	00000097          	auipc	ra,0x0
    80201fc6:	96c080e7          	jalr	-1684(ra) # 8020192e <map_page>
    80201fca:	87aa                	mv	a5,a0
    80201fcc:	c38d                	beqz	a5,80201fee <handle_page_fault+0x1de>
        free_page(page);
    80201fce:	fd043503          	ld	a0,-48(s0)
    80201fd2:	00000097          	auipc	ra,0x0
    80201fd6:	4f6080e7          	jalr	1270(ra) # 802024c8 <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    80201fda:	00004517          	auipc	a0,0x4
    80201fde:	e8650513          	addi	a0,a0,-378 # 80205e60 <small_numbers+0xc40>
    80201fe2:	ffffe097          	auipc	ra,0xffffe
    80201fe6:	5b6080e7          	jalr	1462(ra) # 80200598 <printf>
        return 0; // 映射失败
    80201fea:	4781                	li	a5,0
    80201fec:	a01d                	j	80202012 <handle_page_fault+0x202>
    }
    
    // 刷新TLB
    sfence_vma();
    80201fee:	00000097          	auipc	ra,0x0
    80201ff2:	db8080e7          	jalr	-584(ra) # 80201da6 <sfence_vma>
    
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    80201ff6:	fd043783          	ld	a5,-48(s0)
    80201ffa:	863e                	mv	a2,a5
    80201ffc:	fe043583          	ld	a1,-32(s0)
    80202000:	00004517          	auipc	a0,0x4
    80202004:	e8850513          	addi	a0,a0,-376 # 80205e88 <small_numbers+0xc68>
    80202008:	ffffe097          	auipc	ra,0xffffe
    8020200c:	590080e7          	jalr	1424(ra) # 80200598 <printf>
    return 1; // 处理成功
    80202010:	4785                	li	a5,1
}
    80202012:	853e                	mv	a0,a5
    80202014:	70e2                	ld	ra,56(sp)
    80202016:	7442                	ld	s0,48(sp)
    80202018:	6121                	addi	sp,sp,64
    8020201a:	8082                	ret

000000008020201c <test_pagetable>:
void test_pagetable(void) {
    8020201c:	7179                	addi	sp,sp,-48
    8020201e:	f406                	sd	ra,40(sp)
    80202020:	f022                	sd	s0,32(sp)
    80202022:	1800                	addi	s0,sp,48
    printf("[PT TEST] 创建页表...\n");
    80202024:	00004517          	auipc	a0,0x4
    80202028:	ea450513          	addi	a0,a0,-348 # 80205ec8 <small_numbers+0xca8>
    8020202c:	ffffe097          	auipc	ra,0xffffe
    80202030:	56c080e7          	jalr	1388(ra) # 80200598 <printf>
    pagetable_t pt = create_pagetable();
    80202034:	fffff097          	auipc	ra,0xfffff
    80202038:	732080e7          	jalr	1842(ra) # 80201766 <create_pagetable>
    8020203c:	fea43423          	sd	a0,-24(s0)
    assert(pt != 0);
    80202040:	fe843783          	ld	a5,-24(s0)
    80202044:	00f037b3          	snez	a5,a5
    80202048:	0ff7f793          	zext.b	a5,a5
    8020204c:	2781                	sext.w	a5,a5
    8020204e:	853e                	mv	a0,a5
    80202050:	fffff097          	auipc	ra,0xfffff
    80202054:	692080e7          	jalr	1682(ra) # 802016e2 <assert>
    printf("[PT TEST] 页表创建通过\n");
    80202058:	00004517          	auipc	a0,0x4
    8020205c:	e9050513          	addi	a0,a0,-368 # 80205ee8 <small_numbers+0xcc8>
    80202060:	ffffe097          	auipc	ra,0xffffe
    80202064:	538080e7          	jalr	1336(ra) # 80200598 <printf>

    // 测试基本映射
    uint64 va = 0x1000000;
    80202068:	010007b7          	lui	a5,0x1000
    8020206c:	fef43023          	sd	a5,-32(s0)
    uint64 pa = (uint64)alloc_page();
    80202070:	00000097          	auipc	ra,0x0
    80202074:	3ec080e7          	jalr	1004(ra) # 8020245c <alloc_page>
    80202078:	87aa                	mv	a5,a0
    8020207a:	fcf43c23          	sd	a5,-40(s0)
    assert(pa != 0);
    8020207e:	fd843783          	ld	a5,-40(s0)
    80202082:	00f037b3          	snez	a5,a5
    80202086:	0ff7f793          	zext.b	a5,a5
    8020208a:	2781                	sext.w	a5,a5
    8020208c:	853e                	mv	a0,a5
    8020208e:	fffff097          	auipc	ra,0xfffff
    80202092:	654080e7          	jalr	1620(ra) # 802016e2 <assert>
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0);
    80202096:	4699                	li	a3,6
    80202098:	fd843603          	ld	a2,-40(s0)
    8020209c:	fe043583          	ld	a1,-32(s0)
    802020a0:	fe843503          	ld	a0,-24(s0)
    802020a4:	00000097          	auipc	ra,0x0
    802020a8:	88a080e7          	jalr	-1910(ra) # 8020192e <map_page>
    802020ac:	87aa                	mv	a5,a0
    802020ae:	0017b793          	seqz	a5,a5
    802020b2:	0ff7f793          	zext.b	a5,a5
    802020b6:	2781                	sext.w	a5,a5
    802020b8:	853e                	mv	a0,a5
    802020ba:	fffff097          	auipc	ra,0xfffff
    802020be:	628080e7          	jalr	1576(ra) # 802016e2 <assert>
    printf("[PT TEST] 映射测试通过\n");
    802020c2:	00004517          	auipc	a0,0x4
    802020c6:	e4650513          	addi	a0,a0,-442 # 80205f08 <small_numbers+0xce8>
    802020ca:	ffffe097          	auipc	ra,0xffffe
    802020ce:	4ce080e7          	jalr	1230(ra) # 80200598 <printf>

    // 测试地址转换
    pte_t *pte = walk_lookup(pt, va);
    802020d2:	fe043583          	ld	a1,-32(s0)
    802020d6:	fe843503          	ld	a0,-24(s0)
    802020da:	fffff097          	auipc	ra,0xfffff
    802020de:	6c8080e7          	jalr	1736(ra) # 802017a2 <walk_lookup>
    802020e2:	fca43823          	sd	a0,-48(s0)
    assert(pte != 0 && (*pte & PTE_V));
    802020e6:	fd043783          	ld	a5,-48(s0)
    802020ea:	cb81                	beqz	a5,802020fa <test_pagetable+0xde>
    802020ec:	fd043783          	ld	a5,-48(s0)
    802020f0:	639c                	ld	a5,0(a5)
    802020f2:	8b85                	andi	a5,a5,1
    802020f4:	c399                	beqz	a5,802020fa <test_pagetable+0xde>
    802020f6:	4785                	li	a5,1
    802020f8:	a011                	j	802020fc <test_pagetable+0xe0>
    802020fa:	4781                	li	a5,0
    802020fc:	853e                	mv	a0,a5
    802020fe:	fffff097          	auipc	ra,0xfffff
    80202102:	5e4080e7          	jalr	1508(ra) # 802016e2 <assert>
    assert(PTE2PA(*pte) == pa);
    80202106:	fd043783          	ld	a5,-48(s0)
    8020210a:	639c                	ld	a5,0(a5)
    8020210c:	83a9                	srli	a5,a5,0xa
    8020210e:	07b2                	slli	a5,a5,0xc
    80202110:	fd843703          	ld	a4,-40(s0)
    80202114:	40f707b3          	sub	a5,a4,a5
    80202118:	0017b793          	seqz	a5,a5
    8020211c:	0ff7f793          	zext.b	a5,a5
    80202120:	2781                	sext.w	a5,a5
    80202122:	853e                	mv	a0,a5
    80202124:	fffff097          	auipc	ra,0xfffff
    80202128:	5be080e7          	jalr	1470(ra) # 802016e2 <assert>
    printf("[PT TEST] 地址转换测试通过\n");
    8020212c:	00004517          	auipc	a0,0x4
    80202130:	dfc50513          	addi	a0,a0,-516 # 80205f28 <small_numbers+0xd08>
    80202134:	ffffe097          	auipc	ra,0xffffe
    80202138:	464080e7          	jalr	1124(ra) # 80200598 <printf>

    // 测试权限位
    assert(*pte & PTE_R);
    8020213c:	fd043783          	ld	a5,-48(s0)
    80202140:	639c                	ld	a5,0(a5)
    80202142:	2781                	sext.w	a5,a5
    80202144:	8b89                	andi	a5,a5,2
    80202146:	2781                	sext.w	a5,a5
    80202148:	853e                	mv	a0,a5
    8020214a:	fffff097          	auipc	ra,0xfffff
    8020214e:	598080e7          	jalr	1432(ra) # 802016e2 <assert>
    assert(*pte & PTE_W);
    80202152:	fd043783          	ld	a5,-48(s0)
    80202156:	639c                	ld	a5,0(a5)
    80202158:	2781                	sext.w	a5,a5
    8020215a:	8b91                	andi	a5,a5,4
    8020215c:	2781                	sext.w	a5,a5
    8020215e:	853e                	mv	a0,a5
    80202160:	fffff097          	auipc	ra,0xfffff
    80202164:	582080e7          	jalr	1410(ra) # 802016e2 <assert>
    assert(!(*pte & PTE_X));
    80202168:	fd043783          	ld	a5,-48(s0)
    8020216c:	639c                	ld	a5,0(a5)
    8020216e:	8ba1                	andi	a5,a5,8
    80202170:	0017b793          	seqz	a5,a5
    80202174:	0ff7f793          	zext.b	a5,a5
    80202178:	2781                	sext.w	a5,a5
    8020217a:	853e                	mv	a0,a5
    8020217c:	fffff097          	auipc	ra,0xfffff
    80202180:	566080e7          	jalr	1382(ra) # 802016e2 <assert>
    printf("[PT TEST] 权限测试通过\n");
    80202184:	00004517          	auipc	a0,0x4
    80202188:	dcc50513          	addi	a0,a0,-564 # 80205f50 <small_numbers+0xd30>
    8020218c:	ffffe097          	auipc	ra,0xffffe
    80202190:	40c080e7          	jalr	1036(ra) # 80200598 <printf>

    // 清理
    free_page((void*)pa);
    80202194:	fd843783          	ld	a5,-40(s0)
    80202198:	853e                	mv	a0,a5
    8020219a:	00000097          	auipc	ra,0x0
    8020219e:	32e080e7          	jalr	814(ra) # 802024c8 <free_page>
    free_pagetable(pt);
    802021a2:	fe843503          	ld	a0,-24(s0)
    802021a6:	00000097          	auipc	ra,0x0
    802021aa:	86e080e7          	jalr	-1938(ra) # 80201a14 <free_pagetable>

    printf("[PT TEST] 所有页表测试通过\n");
    802021ae:	00004517          	auipc	a0,0x4
    802021b2:	dc250513          	addi	a0,a0,-574 # 80205f70 <small_numbers+0xd50>
    802021b6:	ffffe097          	auipc	ra,0xffffe
    802021ba:	3e2080e7          	jalr	994(ra) # 80200598 <printf>
}
    802021be:	0001                	nop
    802021c0:	70a2                	ld	ra,40(sp)
    802021c2:	7402                	ld	s0,32(sp)
    802021c4:	6145                	addi	sp,sp,48
    802021c6:	8082                	ret

00000000802021c8 <check_mapping>:
void check_mapping(uint64 va) {
    802021c8:	7179                	addi	sp,sp,-48
    802021ca:	f406                	sd	ra,40(sp)
    802021cc:	f022                	sd	s0,32(sp)
    802021ce:	1800                	addi	s0,sp,48
    802021d0:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    802021d4:	00008797          	auipc	a5,0x8
    802021d8:	e4c78793          	addi	a5,a5,-436 # 8020a020 <kernel_pagetable>
    802021dc:	639c                	ld	a5,0(a5)
    802021de:	fd843583          	ld	a1,-40(s0)
    802021e2:	853e                	mv	a0,a5
    802021e4:	fffff097          	auipc	ra,0xfffff
    802021e8:	5be080e7          	jalr	1470(ra) # 802017a2 <walk_lookup>
    802021ec:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    802021f0:	fe843783          	ld	a5,-24(s0)
    802021f4:	c78d                	beqz	a5,8020221e <check_mapping+0x56>
    802021f6:	fe843783          	ld	a5,-24(s0)
    802021fa:	639c                	ld	a5,0(a5)
    802021fc:	8b85                	andi	a5,a5,1
    802021fe:	c385                	beqz	a5,8020221e <check_mapping+0x56>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80202200:	fe843783          	ld	a5,-24(s0)
    80202204:	639c                	ld	a5,0(a5)
    80202206:	863e                	mv	a2,a5
    80202208:	fd843583          	ld	a1,-40(s0)
    8020220c:	00004517          	auipc	a0,0x4
    80202210:	d8c50513          	addi	a0,a0,-628 # 80205f98 <small_numbers+0xd78>
    80202214:	ffffe097          	auipc	ra,0xffffe
    80202218:	384080e7          	jalr	900(ra) # 80200598 <printf>
    8020221c:	a821                	j	80202234 <check_mapping+0x6c>
    } else {
        printf("Address 0x%lx is NOT mapped\n", va);
    8020221e:	fd843583          	ld	a1,-40(s0)
    80202222:	00004517          	auipc	a0,0x4
    80202226:	d9e50513          	addi	a0,a0,-610 # 80205fc0 <small_numbers+0xda0>
    8020222a:	ffffe097          	auipc	ra,0xffffe
    8020222e:	36e080e7          	jalr	878(ra) # 80200598 <printf>
    }
}
    80202232:	0001                	nop
    80202234:	0001                	nop
    80202236:	70a2                	ld	ra,40(sp)
    80202238:	7402                	ld	s0,32(sp)
    8020223a:	6145                	addi	sp,sp,48
    8020223c:	8082                	ret

000000008020223e <check_is_mapped>:
int check_is_mapped(uint64 va) {
    8020223e:	7179                	addi	sp,sp,-48
    80202240:	f406                	sd	ra,40(sp)
    80202242:	f022                	sd	s0,32(sp)
    80202244:	1800                	addi	s0,sp,48
    80202246:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    8020224a:	00000097          	auipc	ra,0x0
    8020224e:	bae080e7          	jalr	-1106(ra) # 80201df8 <get_current_pagetable>
    80202252:	87aa                	mv	a5,a0
    80202254:	fd843583          	ld	a1,-40(s0)
    80202258:	853e                	mv	a0,a5
    8020225a:	fffff097          	auipc	ra,0xfffff
    8020225e:	548080e7          	jalr	1352(ra) # 802017a2 <walk_lookup>
    80202262:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    80202266:	fe843783          	ld	a5,-24(s0)
    8020226a:	c795                	beqz	a5,80202296 <check_is_mapped+0x58>
    8020226c:	fe843783          	ld	a5,-24(s0)
    80202270:	639c                	ld	a5,0(a5)
    80202272:	8b85                	andi	a5,a5,1
    80202274:	c38d                	beqz	a5,80202296 <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80202276:	fe843783          	ld	a5,-24(s0)
    8020227a:	639c                	ld	a5,0(a5)
    8020227c:	863e                	mv	a2,a5
    8020227e:	fd843583          	ld	a1,-40(s0)
    80202282:	00004517          	auipc	a0,0x4
    80202286:	d1650513          	addi	a0,a0,-746 # 80205f98 <small_numbers+0xd78>
    8020228a:	ffffe097          	auipc	ra,0xffffe
    8020228e:	30e080e7          	jalr	782(ra) # 80200598 <printf>
        return 1;
    80202292:	4785                	li	a5,1
    80202294:	a821                	j	802022ac <check_is_mapped+0x6e>
    } else {
        printf("Address 0x%lx is NOT mapped\n", va);
    80202296:	fd843583          	ld	a1,-40(s0)
    8020229a:	00004517          	auipc	a0,0x4
    8020229e:	d2650513          	addi	a0,a0,-730 # 80205fc0 <small_numbers+0xda0>
    802022a2:	ffffe097          	auipc	ra,0xffffe
    802022a6:	2f6080e7          	jalr	758(ra) # 80200598 <printf>
        return 0;
    802022aa:	4781                	li	a5,0
    }
}
    802022ac:	853e                	mv	a0,a5
    802022ae:	70a2                	ld	ra,40(sp)
    802022b0:	7402                	ld	s0,32(sp)
    802022b2:	6145                	addi	sp,sp,48
    802022b4:	8082                	ret

00000000802022b6 <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    802022b6:	711d                	addi	sp,sp,-96
    802022b8:	ec86                	sd	ra,88(sp)
    802022ba:	e8a2                	sd	s0,80(sp)
    802022bc:	1080                	addi	s0,sp,96
    802022be:	faa43c23          	sd	a0,-72(s0)
    802022c2:	fab43823          	sd	a1,-80(s0)
    802022c6:	fac43423          	sd	a2,-88(s0)
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    802022ca:	fe043423          	sd	zero,-24(s0)
    802022ce:	a075                	j	8020237a <uvmcopy+0xc4>
        pte_t *pte = walk_lookup(old, i);
    802022d0:	fe843583          	ld	a1,-24(s0)
    802022d4:	fb843503          	ld	a0,-72(s0)
    802022d8:	fffff097          	auipc	ra,0xfffff
    802022dc:	4ca080e7          	jalr	1226(ra) # 802017a2 <walk_lookup>
    802022e0:	fea43023          	sd	a0,-32(s0)
        if (pte == 0 || (*pte & PTE_V) == 0)
    802022e4:	fe043783          	ld	a5,-32(s0)
    802022e8:	c3d1                	beqz	a5,8020236c <uvmcopy+0xb6>
    802022ea:	fe043783          	ld	a5,-32(s0)
    802022ee:	639c                	ld	a5,0(a5)
    802022f0:	8b85                	andi	a5,a5,1
    802022f2:	cfad                	beqz	a5,8020236c <uvmcopy+0xb6>
            continue; // 跳过未分配的页

        uint64 pa = PTE2PA(*pte);
    802022f4:	fe043783          	ld	a5,-32(s0)
    802022f8:	639c                	ld	a5,0(a5)
    802022fa:	83a9                	srli	a5,a5,0xa
    802022fc:	07b2                	slli	a5,a5,0xc
    802022fe:	fcf43c23          	sd	a5,-40(s0)
        int flags = PTE_FLAGS(*pte);
    80202302:	fe043783          	ld	a5,-32(s0)
    80202306:	639c                	ld	a5,0(a5)
    80202308:	2781                	sext.w	a5,a5
    8020230a:	3ff7f793          	andi	a5,a5,1023
    8020230e:	fcf42a23          	sw	a5,-44(s0)

        void *mem = alloc_page();
    80202312:	00000097          	auipc	ra,0x0
    80202316:	14a080e7          	jalr	330(ra) # 8020245c <alloc_page>
    8020231a:	fca43423          	sd	a0,-56(s0)
        if (mem == 0)
    8020231e:	fc843783          	ld	a5,-56(s0)
    80202322:	e399                	bnez	a5,80202328 <uvmcopy+0x72>
            return -1; // 分配失败
    80202324:	57fd                	li	a5,-1
    80202326:	a08d                	j	80202388 <uvmcopy+0xd2>

        memmove(mem, (void*)pa, PGSIZE);
    80202328:	fd843783          	ld	a5,-40(s0)
    8020232c:	6605                	lui	a2,0x1
    8020232e:	85be                	mv	a1,a5
    80202330:	fc843503          	ld	a0,-56(s0)
    80202334:	fffff097          	auipc	ra,0xfffff
    80202338:	28c080e7          	jalr	652(ra) # 802015c0 <memmove>

        if (map_page(new, i, (uint64)mem, flags) != 0) {
    8020233c:	fc843783          	ld	a5,-56(s0)
    80202340:	fd442703          	lw	a4,-44(s0)
    80202344:	86ba                	mv	a3,a4
    80202346:	863e                	mv	a2,a5
    80202348:	fe843583          	ld	a1,-24(s0)
    8020234c:	fb043503          	ld	a0,-80(s0)
    80202350:	fffff097          	auipc	ra,0xfffff
    80202354:	5de080e7          	jalr	1502(ra) # 8020192e <map_page>
    80202358:	87aa                	mv	a5,a0
    8020235a:	cb91                	beqz	a5,8020236e <uvmcopy+0xb8>
            free_page(mem);
    8020235c:	fc843503          	ld	a0,-56(s0)
    80202360:	00000097          	auipc	ra,0x0
    80202364:	168080e7          	jalr	360(ra) # 802024c8 <free_page>
            return -1;
    80202368:	57fd                	li	a5,-1
    8020236a:	a839                	j	80202388 <uvmcopy+0xd2>
            continue; // 跳过未分配的页
    8020236c:	0001                	nop
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    8020236e:	fe843703          	ld	a4,-24(s0)
    80202372:	6785                	lui	a5,0x1
    80202374:	97ba                	add	a5,a5,a4
    80202376:	fef43423          	sd	a5,-24(s0)
    8020237a:	fe843703          	ld	a4,-24(s0)
    8020237e:	fa843783          	ld	a5,-88(s0)
    80202382:	f4f767e3          	bltu	a4,a5,802022d0 <uvmcopy+0x1a>
        }
    }
    return 0;
    80202386:	4781                	li	a5,0
    80202388:	853e                	mv	a0,a5
    8020238a:	60e6                	ld	ra,88(sp)
    8020238c:	6446                	ld	s0,80(sp)
    8020238e:	6125                	addi	sp,sp,96
    80202390:	8082                	ret

0000000080202392 <assert>:
#include "pm.h"
#include "memlayout.h"
#include "types.h"
    80202392:	1101                	addi	sp,sp,-32
    80202394:	ec06                	sd	ra,24(sp)
    80202396:	e822                	sd	s0,16(sp)
    80202398:	1000                	addi	s0,sp,32
    8020239a:	87aa                	mv	a5,a0
    8020239c:	fef42623          	sw	a5,-20(s0)
#include "printf.h"
    802023a0:	fec42783          	lw	a5,-20(s0)
    802023a4:	2781                	sext.w	a5,a5
    802023a6:	e795                	bnez	a5,802023d2 <assert+0x40>
#include "mem.h"
    802023a8:	4615                	li	a2,5
    802023aa:	00004597          	auipc	a1,0x4
    802023ae:	c3658593          	addi	a1,a1,-970 # 80205fe0 <small_numbers+0xdc0>
    802023b2:	00004517          	auipc	a0,0x4
    802023b6:	c3e50513          	addi	a0,a0,-962 # 80205ff0 <small_numbers+0xdd0>
    802023ba:	ffffe097          	auipc	ra,0xffffe
    802023be:	1de080e7          	jalr	478(ra) # 80200598 <printf>
#include "assert.h"
    802023c2:	00004517          	auipc	a0,0x4
    802023c6:	c5650513          	addi	a0,a0,-938 # 80206018 <small_numbers+0xdf8>
    802023ca:	fffff097          	auipc	ra,0xfffff
    802023ce:	ad6080e7          	jalr	-1322(ra) # 80200ea0 <panic>

struct run {
    802023d2:	0001                	nop
    802023d4:	60e2                	ld	ra,24(sp)
    802023d6:	6442                	ld	s0,16(sp)
    802023d8:	6105                	addi	sp,sp,32
    802023da:	8082                	ret

00000000802023dc <freerange>:

static struct run *freelist = 0;

extern char end[];

static void freerange(void *pa_start, void *pa_end) {
    802023dc:	7179                	addi	sp,sp,-48
    802023de:	f406                	sd	ra,40(sp)
    802023e0:	f022                	sd	s0,32(sp)
    802023e2:	1800                	addi	s0,sp,48
    802023e4:	fca43c23          	sd	a0,-40(s0)
    802023e8:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    802023ec:	fd843703          	ld	a4,-40(s0)
    802023f0:	6785                	lui	a5,0x1
    802023f2:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    802023f4:	973e                	add	a4,a4,a5
    802023f6:	77fd                	lui	a5,0xfffff
    802023f8:	8ff9                	and	a5,a5,a4
    802023fa:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802023fe:	a829                	j	80202418 <freerange+0x3c>
    free_page(p);
    80202400:	fe843503          	ld	a0,-24(s0)
    80202404:	00000097          	auipc	ra,0x0
    80202408:	0c4080e7          	jalr	196(ra) # 802024c8 <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8020240c:	fe843703          	ld	a4,-24(s0)
    80202410:	6785                	lui	a5,0x1
    80202412:	97ba                	add	a5,a5,a4
    80202414:	fef43423          	sd	a5,-24(s0)
    80202418:	fe843703          	ld	a4,-24(s0)
    8020241c:	6785                	lui	a5,0x1
    8020241e:	97ba                	add	a5,a5,a4
    80202420:	fd043703          	ld	a4,-48(s0)
    80202424:	fcf77ee3          	bgeu	a4,a5,80202400 <freerange+0x24>
  }
}
    80202428:	0001                	nop
    8020242a:	0001                	nop
    8020242c:	70a2                	ld	ra,40(sp)
    8020242e:	7402                	ld	s0,32(sp)
    80202430:	6145                	addi	sp,sp,48
    80202432:	8082                	ret

0000000080202434 <pmm_init>:

void pmm_init(void) {
    80202434:	1141                	addi	sp,sp,-16
    80202436:	e406                	sd	ra,8(sp)
    80202438:	e022                	sd	s0,0(sp)
    8020243a:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    8020243c:	47c5                	li	a5,17
    8020243e:	01b79593          	slli	a1,a5,0x1b
    80202442:	0000b517          	auipc	a0,0xb
    80202446:	10e50513          	addi	a0,a0,270 # 8020d550 <_bss_end>
    8020244a:	00000097          	auipc	ra,0x0
    8020244e:	f92080e7          	jalr	-110(ra) # 802023dc <freerange>
}
    80202452:	0001                	nop
    80202454:	60a2                	ld	ra,8(sp)
    80202456:	6402                	ld	s0,0(sp)
    80202458:	0141                	addi	sp,sp,16
    8020245a:	8082                	ret

000000008020245c <alloc_page>:

void* alloc_page(void) {
    8020245c:	1101                	addi	sp,sp,-32
    8020245e:	ec06                	sd	ra,24(sp)
    80202460:	e822                	sd	s0,16(sp)
    80202462:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80202464:	00008797          	auipc	a5,0x8
    80202468:	c6478793          	addi	a5,a5,-924 # 8020a0c8 <freelist>
    8020246c:	639c                	ld	a5,0(a5)
    8020246e:	fef43423          	sd	a5,-24(s0)
  if(r)
    80202472:	fe843783          	ld	a5,-24(s0)
    80202476:	cb89                	beqz	a5,80202488 <alloc_page+0x2c>
    freelist = r->next;
    80202478:	fe843783          	ld	a5,-24(s0)
    8020247c:	6398                	ld	a4,0(a5)
    8020247e:	00008797          	auipc	a5,0x8
    80202482:	c4a78793          	addi	a5,a5,-950 # 8020a0c8 <freelist>
    80202486:	e398                	sd	a4,0(a5)
  if(r)
    80202488:	fe843783          	ld	a5,-24(s0)
    8020248c:	cf99                	beqz	a5,802024aa <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    8020248e:	fe843783          	ld	a5,-24(s0)
    80202492:	00878713          	addi	a4,a5,8
    80202496:	6785                	lui	a5,0x1
    80202498:	ff878613          	addi	a2,a5,-8 # ff8 <userret+0xf5c>
    8020249c:	4595                	li	a1,5
    8020249e:	853a                	mv	a0,a4
    802024a0:	fffff097          	auipc	ra,0xfffff
    802024a4:	0d0080e7          	jalr	208(ra) # 80201570 <memset>
    802024a8:	a809                	j	802024ba <alloc_page+0x5e>
  else
    panic("alloc_page: out of memory");
    802024aa:	00004517          	auipc	a0,0x4
    802024ae:	b7650513          	addi	a0,a0,-1162 # 80206020 <small_numbers+0xe00>
    802024b2:	fffff097          	auipc	ra,0xfffff
    802024b6:	9ee080e7          	jalr	-1554(ra) # 80200ea0 <panic>
  return (void*)r;
    802024ba:	fe843783          	ld	a5,-24(s0)
}
    802024be:	853e                	mv	a0,a5
    802024c0:	60e2                	ld	ra,24(sp)
    802024c2:	6442                	ld	s0,16(sp)
    802024c4:	6105                	addi	sp,sp,32
    802024c6:	8082                	ret

00000000802024c8 <free_page>:

void free_page(void* page) {
    802024c8:	7179                	addi	sp,sp,-48
    802024ca:	f406                	sd	ra,40(sp)
    802024cc:	f022                	sd	s0,32(sp)
    802024ce:	1800                	addi	s0,sp,48
    802024d0:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    802024d4:	fd843783          	ld	a5,-40(s0)
    802024d8:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    802024dc:	fd843703          	ld	a4,-40(s0)
    802024e0:	6785                	lui	a5,0x1
    802024e2:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    802024e4:	8ff9                	and	a5,a5,a4
    802024e6:	ef99                	bnez	a5,80202504 <free_page+0x3c>
    802024e8:	fd843703          	ld	a4,-40(s0)
    802024ec:	0000b797          	auipc	a5,0xb
    802024f0:	06478793          	addi	a5,a5,100 # 8020d550 <_bss_end>
    802024f4:	00f76863          	bltu	a4,a5,80202504 <free_page+0x3c>
    802024f8:	fd843703          	ld	a4,-40(s0)
    802024fc:	47c5                	li	a5,17
    802024fe:	07ee                	slli	a5,a5,0x1b
    80202500:	00f76a63          	bltu	a4,a5,80202514 <free_page+0x4c>
    panic("free_page: invalid page address");
    80202504:	00004517          	auipc	a0,0x4
    80202508:	b3c50513          	addi	a0,a0,-1220 # 80206040 <small_numbers+0xe20>
    8020250c:	fffff097          	auipc	ra,0xfffff
    80202510:	994080e7          	jalr	-1644(ra) # 80200ea0 <panic>
  r->next = freelist;
    80202514:	00008797          	auipc	a5,0x8
    80202518:	bb478793          	addi	a5,a5,-1100 # 8020a0c8 <freelist>
    8020251c:	6398                	ld	a4,0(a5)
    8020251e:	fe843783          	ld	a5,-24(s0)
    80202522:	e398                	sd	a4,0(a5)
  freelist = r;
    80202524:	00008797          	auipc	a5,0x8
    80202528:	ba478793          	addi	a5,a5,-1116 # 8020a0c8 <freelist>
    8020252c:	fe843703          	ld	a4,-24(s0)
    80202530:	e398                	sd	a4,0(a5)
}
    80202532:	0001                	nop
    80202534:	70a2                	ld	ra,40(sp)
    80202536:	7402                	ld	s0,32(sp)
    80202538:	6145                	addi	sp,sp,48
    8020253a:	8082                	ret

000000008020253c <test_physical_memory>:

void test_physical_memory(void) {
    8020253c:	7179                	addi	sp,sp,-48
    8020253e:	f406                	sd	ra,40(sp)
    80202540:	f022                	sd	s0,32(sp)
    80202542:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    80202544:	00004517          	auipc	a0,0x4
    80202548:	b1c50513          	addi	a0,a0,-1252 # 80206060 <small_numbers+0xe40>
    8020254c:	ffffe097          	auipc	ra,0xffffe
    80202550:	04c080e7          	jalr	76(ra) # 80200598 <printf>
    void *page1 = alloc_page();
    80202554:	00000097          	auipc	ra,0x0
    80202558:	f08080e7          	jalr	-248(ra) # 8020245c <alloc_page>
    8020255c:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    80202560:	00000097          	auipc	ra,0x0
    80202564:	efc080e7          	jalr	-260(ra) # 8020245c <alloc_page>
    80202568:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    8020256c:	fe843783          	ld	a5,-24(s0)
    80202570:	00f037b3          	snez	a5,a5
    80202574:	0ff7f793          	zext.b	a5,a5
    80202578:	2781                	sext.w	a5,a5
    8020257a:	853e                	mv	a0,a5
    8020257c:	00000097          	auipc	ra,0x0
    80202580:	e16080e7          	jalr	-490(ra) # 80202392 <assert>
    assert(page2 != 0);
    80202584:	fe043783          	ld	a5,-32(s0)
    80202588:	00f037b3          	snez	a5,a5
    8020258c:	0ff7f793          	zext.b	a5,a5
    80202590:	2781                	sext.w	a5,a5
    80202592:	853e                	mv	a0,a5
    80202594:	00000097          	auipc	ra,0x0
    80202598:	dfe080e7          	jalr	-514(ra) # 80202392 <assert>
    assert(page1 != page2);
    8020259c:	fe843703          	ld	a4,-24(s0)
    802025a0:	fe043783          	ld	a5,-32(s0)
    802025a4:	40f707b3          	sub	a5,a4,a5
    802025a8:	00f037b3          	snez	a5,a5
    802025ac:	0ff7f793          	zext.b	a5,a5
    802025b0:	2781                	sext.w	a5,a5
    802025b2:	853e                	mv	a0,a5
    802025b4:	00000097          	auipc	ra,0x0
    802025b8:	dde080e7          	jalr	-546(ra) # 80202392 <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    802025bc:	fe843703          	ld	a4,-24(s0)
    802025c0:	6785                	lui	a5,0x1
    802025c2:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    802025c4:	8ff9                	and	a5,a5,a4
    802025c6:	0017b793          	seqz	a5,a5
    802025ca:	0ff7f793          	zext.b	a5,a5
    802025ce:	2781                	sext.w	a5,a5
    802025d0:	853e                	mv	a0,a5
    802025d2:	00000097          	auipc	ra,0x0
    802025d6:	dc0080e7          	jalr	-576(ra) # 80202392 <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    802025da:	fe043703          	ld	a4,-32(s0)
    802025de:	6785                	lui	a5,0x1
    802025e0:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    802025e2:	8ff9                	and	a5,a5,a4
    802025e4:	0017b793          	seqz	a5,a5
    802025e8:	0ff7f793          	zext.b	a5,a5
    802025ec:	2781                	sext.w	a5,a5
    802025ee:	853e                	mv	a0,a5
    802025f0:	00000097          	auipc	ra,0x0
    802025f4:	da2080e7          	jalr	-606(ra) # 80202392 <assert>
    printf("[PM TEST] 分配测试通过\n");
    802025f8:	00004517          	auipc	a0,0x4
    802025fc:	a8850513          	addi	a0,a0,-1400 # 80206080 <small_numbers+0xe60>
    80202600:	ffffe097          	auipc	ra,0xffffe
    80202604:	f98080e7          	jalr	-104(ra) # 80200598 <printf>

    printf("[PM TEST] 数据写入测试...\n");
    80202608:	00004517          	auipc	a0,0x4
    8020260c:	a9850513          	addi	a0,a0,-1384 # 802060a0 <small_numbers+0xe80>
    80202610:	ffffe097          	auipc	ra,0xffffe
    80202614:	f88080e7          	jalr	-120(ra) # 80200598 <printf>
    *(int*)page1 = 0x12345678;
    80202618:	fe843783          	ld	a5,-24(s0)
    8020261c:	12345737          	lui	a4,0x12345
    80202620:	67870713          	addi	a4,a4,1656 # 12345678 <userret+0x123455dc>
    80202624:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    80202626:	fe843783          	ld	a5,-24(s0)
    8020262a:	439c                	lw	a5,0(a5)
    8020262c:	873e                	mv	a4,a5
    8020262e:	123457b7          	lui	a5,0x12345
    80202632:	67878793          	addi	a5,a5,1656 # 12345678 <userret+0x123455dc>
    80202636:	40f707b3          	sub	a5,a4,a5
    8020263a:	0017b793          	seqz	a5,a5
    8020263e:	0ff7f793          	zext.b	a5,a5
    80202642:	2781                	sext.w	a5,a5
    80202644:	853e                	mv	a0,a5
    80202646:	00000097          	auipc	ra,0x0
    8020264a:	d4c080e7          	jalr	-692(ra) # 80202392 <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    8020264e:	00004517          	auipc	a0,0x4
    80202652:	a7a50513          	addi	a0,a0,-1414 # 802060c8 <small_numbers+0xea8>
    80202656:	ffffe097          	auipc	ra,0xffffe
    8020265a:	f42080e7          	jalr	-190(ra) # 80200598 <printf>

    printf("[PM TEST] 释放与重新分配测试...\n");
    8020265e:	00004517          	auipc	a0,0x4
    80202662:	a9250513          	addi	a0,a0,-1390 # 802060f0 <small_numbers+0xed0>
    80202666:	ffffe097          	auipc	ra,0xffffe
    8020266a:	f32080e7          	jalr	-206(ra) # 80200598 <printf>
    free_page(page1);
    8020266e:	fe843503          	ld	a0,-24(s0)
    80202672:	00000097          	auipc	ra,0x0
    80202676:	e56080e7          	jalr	-426(ra) # 802024c8 <free_page>
    void *page3 = alloc_page();
    8020267a:	00000097          	auipc	ra,0x0
    8020267e:	de2080e7          	jalr	-542(ra) # 8020245c <alloc_page>
    80202682:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    80202686:	fd843783          	ld	a5,-40(s0)
    8020268a:	00f037b3          	snez	a5,a5
    8020268e:	0ff7f793          	zext.b	a5,a5
    80202692:	2781                	sext.w	a5,a5
    80202694:	853e                	mv	a0,a5
    80202696:	00000097          	auipc	ra,0x0
    8020269a:	cfc080e7          	jalr	-772(ra) # 80202392 <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    8020269e:	00004517          	auipc	a0,0x4
    802026a2:	a8250513          	addi	a0,a0,-1406 # 80206120 <small_numbers+0xf00>
    802026a6:	ffffe097          	auipc	ra,0xffffe
    802026aa:	ef2080e7          	jalr	-270(ra) # 80200598 <printf>

    free_page(page2);
    802026ae:	fe043503          	ld	a0,-32(s0)
    802026b2:	00000097          	auipc	ra,0x0
    802026b6:	e16080e7          	jalr	-490(ra) # 802024c8 <free_page>
    free_page(page3);
    802026ba:	fd843503          	ld	a0,-40(s0)
    802026be:	00000097          	auipc	ra,0x0
    802026c2:	e0a080e7          	jalr	-502(ra) # 802024c8 <free_page>

    printf("[PM TEST] 所有物理内存管理测试通过\n");
    802026c6:	00004517          	auipc	a0,0x4
    802026ca:	a8a50513          	addi	a0,a0,-1398 # 80206150 <small_numbers+0xf30>
    802026ce:	ffffe097          	auipc	ra,0xffffe
    802026d2:	eca080e7          	jalr	-310(ra) # 80200598 <printf>
    802026d6:	0001                	nop
    802026d8:	70a2                	ld	ra,40(sp)
    802026da:	7402                	ld	s0,32(sp)
    802026dc:	6145                	addi	sp,sp,48
    802026de:	8082                	ret

00000000802026e0 <sbi_set_time>:
#include "printf.h"

// SBI ecall 编号
#define SBI_SET_TIME 0x0

void sbi_set_time(uint64 time) {
    802026e0:	1101                	addi	sp,sp,-32
    802026e2:	ec22                	sd	s0,24(sp)
    802026e4:	1000                	addi	s0,sp,32
    802026e6:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    802026ea:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    802026ee:	4881                	li	a7,0
    asm volatile ("ecall"
    802026f0:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    802026f4:	0001                	nop
    802026f6:	6462                	ld	s0,24(sp)
    802026f8:	6105                	addi	sp,sp,32
    802026fa:	8082                	ret

00000000802026fc <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    802026fc:	1101                	addi	sp,sp,-32
    802026fe:	ec22                	sd	s0,24(sp)
    80202700:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    80202702:	c01027f3          	rdtime	a5
    80202706:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    8020270a:	fe843783          	ld	a5,-24(s0)
    8020270e:	853e                	mv	a0,a5
    80202710:	6462                	ld	s0,24(sp)
    80202712:	6105                	addi	sp,sp,32
    80202714:	8082                	ret

0000000080202716 <timeintr>:
#include "trap.h"
#include "riscv.h"  // 确保包含了这个头文件

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    80202716:	1141                	addi	sp,sp,-16
    80202718:	e422                	sd	s0,8(sp)
    8020271a:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    8020271c:	00008797          	auipc	a5,0x8
    80202720:	90c78793          	addi	a5,a5,-1780 # 8020a028 <interrupt_test_flag>
    80202724:	639c                	ld	a5,0(a5)
    80202726:	cb99                	beqz	a5,8020273c <timeintr+0x26>
        (*interrupt_test_flag)++;
    80202728:	00008797          	auipc	a5,0x8
    8020272c:	90078793          	addi	a5,a5,-1792 # 8020a028 <interrupt_test_flag>
    80202730:	639c                	ld	a5,0(a5)
    80202732:	4398                	lw	a4,0(a5)
    80202734:	2701                	sext.w	a4,a4
    80202736:	2705                	addiw	a4,a4,1
    80202738:	2701                	sext.w	a4,a4
    8020273a:	c398                	sw	a4,0(a5)
    8020273c:	0001                	nop
    8020273e:	6422                	ld	s0,8(sp)
    80202740:	0141                	addi	sp,sp,16
    80202742:	8082                	ret

0000000080202744 <r_sie>:
#include "timer.h"
#include "riscv.h"
#include "printf.h"
#include "sbi.h"
#include "uart.h"
#include "vm.h"
    80202744:	1101                	addi	sp,sp,-32
    80202746:	ec22                	sd	s0,24(sp)
    80202748:	1000                	addi	s0,sp,32
#include "mem.h"
#include "pm.h"
    8020274a:	104027f3          	csrr	a5,sie
    8020274e:	fef43423          	sd	a5,-24(s0)

    80202752:	fe843783          	ld	a5,-24(s0)

    80202756:	853e                	mv	a0,a5
    80202758:	6462                	ld	s0,24(sp)
    8020275a:	6105                	addi	sp,sp,32
    8020275c:	8082                	ret

000000008020275e <w_sie>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    tf->epc = sepc;
    8020275e:	1101                	addi	sp,sp,-32
    80202760:	ec22                	sd	s0,24(sp)
    80202762:	1000                	addi	s0,sp,32
    80202764:	fea43423          	sd	a0,-24(s0)
    // 其他字段需要保存在全局变量或函数参数中
    80202768:	fe843783          	ld	a5,-24(s0)
    8020276c:	10479073          	csrw	sie,a5
}
    80202770:	0001                	nop
    80202772:	6462                	ld	s0,24(sp)
    80202774:	6105                	addi	sp,sp,32
    80202776:	8082                	ret

0000000080202778 <r_sstatus>:

static inline uint64 get_sepc(struct trapframe *tf) {
    80202778:	1101                	addi	sp,sp,-32
    8020277a:	ec22                	sd	s0,24(sp)
    8020277c:	1000                	addi	s0,sp,32
    return tf->epc;
}
    8020277e:	100027f3          	csrr	a5,sstatus
    80202782:	fef43423          	sd	a5,-24(s0)

    80202786:	fe843783          	ld	a5,-24(s0)
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    8020278a:	853e                	mv	a0,a5
    8020278c:	6462                	ld	s0,24(sp)
    8020278e:	6105                	addi	sp,sp,32
    80202790:	8082                	ret

0000000080202792 <w_sstatus>:
    tf->epc = sepc;
    80202792:	1101                	addi	sp,sp,-32
    80202794:	ec22                	sd	s0,24(sp)
    80202796:	1000                	addi	s0,sp,32
    80202798:	fea43423          	sd	a0,-24(s0)
}
    8020279c:	fe843783          	ld	a5,-24(s0)
    802027a0:	10079073          	csrw	sstatus,a5

    802027a4:	0001                	nop
    802027a6:	6462                	ld	s0,24(sp)
    802027a8:	6105                	addi	sp,sp,32
    802027aa:	8082                	ret

00000000802027ac <w_sepc>:
// 全局测试变量，用于中断测试
volatile int *interrupt_test_flag = 0;
extern void kernelvec();
    802027ac:	1101                	addi	sp,sp,-32
    802027ae:	ec22                	sd	s0,24(sp)
    802027b0:	1000                	addi	s0,sp,32
    802027b2:	fea43423          	sd	a0,-24(s0)
interrupt_handler_t interrupt_vector[MAX_IRQ];
    802027b6:	fe843783          	ld	a5,-24(s0)
    802027ba:	14179073          	csrw	sepc,a5
void register_interrupt(int irq, interrupt_handler_t h) {
    802027be:	0001                	nop
    802027c0:	6462                	ld	s0,24(sp)
    802027c2:	6105                	addi	sp,sp,32
    802027c4:	8082                	ret

00000000802027c6 <intr_off>:
    if (irq >= 0 && irq < MAX_IRQ){
        interrupt_vector[irq] = h;
	}
}

void unregister_interrupt(int irq) {
    802027c6:	1141                	addi	sp,sp,-16
    802027c8:	e406                	sd	ra,8(sp)
    802027ca:	e022                	sd	s0,0(sp)
    802027cc:	0800                	addi	s0,sp,16
    if (irq >= 0 && irq < MAX_IRQ)
    802027ce:	00000097          	auipc	ra,0x0
    802027d2:	faa080e7          	jalr	-86(ra) # 80202778 <r_sstatus>
    802027d6:	87aa                	mv	a5,a0
    802027d8:	9bf5                	andi	a5,a5,-3
    802027da:	853e                	mv	a0,a5
    802027dc:	00000097          	auipc	ra,0x0
    802027e0:	fb6080e7          	jalr	-74(ra) # 80202792 <w_sstatus>
        interrupt_vector[irq] = 0;
    802027e4:	0001                	nop
    802027e6:	60a2                	ld	ra,8(sp)
    802027e8:	6402                	ld	s0,0(sp)
    802027ea:	0141                	addi	sp,sp,16
    802027ec:	8082                	ret

00000000802027ee <w_stvec>:
}
void enable_interrupts(int irq) {
    plic_enable(irq);
    802027ee:	1101                	addi	sp,sp,-32
    802027f0:	ec22                	sd	s0,24(sp)
    802027f2:	1000                	addi	s0,sp,32
    802027f4:	fea43423          	sd	a0,-24(s0)
}
    802027f8:	fe843783          	ld	a5,-24(s0)
    802027fc:	10579073          	csrw	stvec,a5

    80202800:	0001                	nop
    80202802:	6462                	ld	s0,24(sp)
    80202804:	6105                	addi	sp,sp,32
    80202806:	8082                	ret

0000000080202808 <r_scause>:
}

void interrupt_dispatch(int irq) {
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
		interrupt_vector[irq]();
	}
    80202808:	1101                	addi	sp,sp,-32
    8020280a:	ec22                	sd	s0,24(sp)
    8020280c:	1000                	addi	s0,sp,32
}
// 处理外部中断
    8020280e:	142027f3          	csrr	a5,scause
    80202812:	fef43423          	sd	a5,-24(s0)
void handle_external_interrupt(void) {
    80202816:	fe843783          	ld	a5,-24(s0)
    // 从PLIC获取中断号
    8020281a:	853e                	mv	a0,a5
    8020281c:	6462                	ld	s0,24(sp)
    8020281e:	6105                	addi	sp,sp,32
    80202820:	8082                	ret

0000000080202822 <r_sepc>:
    int irq = plic_claim();
    
    80202822:	1101                	addi	sp,sp,-32
    80202824:	ec22                	sd	s0,24(sp)
    80202826:	1000                	addi	s0,sp,32
    if (irq == 0) {
        // 虚假中断
    80202828:	141027f3          	csrr	a5,sepc
    8020282c:	fef43423          	sd	a5,-24(s0)
        printf("Spurious external interrupt\n");
    80202830:	fe843783          	ld	a5,-24(s0)
        return;
    80202834:	853e                	mv	a0,a5
    80202836:	6462                	ld	s0,24(sp)
    80202838:	6105                	addi	sp,sp,32
    8020283a:	8082                	ret

000000008020283c <r_stval>:
    }
    interrupt_dispatch(irq);
    8020283c:	1101                	addi	sp,sp,-32
    8020283e:	ec22                	sd	s0,24(sp)
    80202840:	1000                	addi	s0,sp,32
    plic_complete(irq);
}
    80202842:	143027f3          	csrr	a5,stval
    80202846:	fef43423          	sd	a5,-24(s0)

    8020284a:	fe843783          	ld	a5,-24(s0)
void trap_init(void) {
    8020284e:	853e                	mv	a0,a5
    80202850:	6462                	ld	s0,24(sp)
    80202852:	6105                	addi	sp,sp,32
    80202854:	8082                	ret

0000000080202856 <save_exception_info>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    80202856:	7139                	addi	sp,sp,-64
    80202858:	fc22                	sd	s0,56(sp)
    8020285a:	0080                	addi	s0,sp,64
    8020285c:	fea43423          	sd	a0,-24(s0)
    80202860:	feb43023          	sd	a1,-32(s0)
    80202864:	fcc43c23          	sd	a2,-40(s0)
    80202868:	fcd43823          	sd	a3,-48(s0)
    8020286c:	fce43423          	sd	a4,-56(s0)
    tf->epc = sepc;
    80202870:	fe843783          	ld	a5,-24(s0)
    80202874:	fe043703          	ld	a4,-32(s0)
    80202878:	ef98                	sd	a4,24(a5)
}
    8020287a:	0001                	nop
    8020287c:	7462                	ld	s0,56(sp)
    8020287e:	6121                	addi	sp,sp,64
    80202880:	8082                	ret

0000000080202882 <get_sepc>:
static inline uint64 get_sepc(struct trapframe *tf) {
    80202882:	1101                	addi	sp,sp,-32
    80202884:	ec22                	sd	s0,24(sp)
    80202886:	1000                	addi	s0,sp,32
    80202888:	fea43423          	sd	a0,-24(s0)
    return tf->epc;
    8020288c:	fe843783          	ld	a5,-24(s0)
    80202890:	6f9c                	ld	a5,24(a5)
}
    80202892:	853e                	mv	a0,a5
    80202894:	6462                	ld	s0,24(sp)
    80202896:	6105                	addi	sp,sp,32
    80202898:	8082                	ret

000000008020289a <set_sepc>:
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    8020289a:	1101                	addi	sp,sp,-32
    8020289c:	ec22                	sd	s0,24(sp)
    8020289e:	1000                	addi	s0,sp,32
    802028a0:	fea43423          	sd	a0,-24(s0)
    802028a4:	feb43023          	sd	a1,-32(s0)
    tf->epc = sepc;
    802028a8:	fe843783          	ld	a5,-24(s0)
    802028ac:	fe043703          	ld	a4,-32(s0)
    802028b0:	ef98                	sd	a4,24(a5)
}
    802028b2:	0001                	nop
    802028b4:	6462                	ld	s0,24(sp)
    802028b6:	6105                	addi	sp,sp,32
    802028b8:	8082                	ret

00000000802028ba <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    802028ba:	1101                	addi	sp,sp,-32
    802028bc:	ec22                	sd	s0,24(sp)
    802028be:	1000                	addi	s0,sp,32
    802028c0:	87aa                	mv	a5,a0
    802028c2:	feb43023          	sd	a1,-32(s0)
    802028c6:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    802028ca:	fec42783          	lw	a5,-20(s0)
    802028ce:	2781                	sext.w	a5,a5
    802028d0:	0207c563          	bltz	a5,802028fa <register_interrupt+0x40>
    802028d4:	fec42783          	lw	a5,-20(s0)
    802028d8:	0007871b          	sext.w	a4,a5
    802028dc:	03f00793          	li	a5,63
    802028e0:	00e7cd63          	blt	a5,a4,802028fa <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    802028e4:	00007717          	auipc	a4,0x7
    802028e8:	7ec70713          	addi	a4,a4,2028 # 8020a0d0 <interrupt_vector>
    802028ec:	fec42783          	lw	a5,-20(s0)
    802028f0:	078e                	slli	a5,a5,0x3
    802028f2:	97ba                	add	a5,a5,a4
    802028f4:	fe043703          	ld	a4,-32(s0)
    802028f8:	e398                	sd	a4,0(a5)
}
    802028fa:	0001                	nop
    802028fc:	6462                	ld	s0,24(sp)
    802028fe:	6105                	addi	sp,sp,32
    80202900:	8082                	ret

0000000080202902 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    80202902:	1101                	addi	sp,sp,-32
    80202904:	ec22                	sd	s0,24(sp)
    80202906:	1000                	addi	s0,sp,32
    80202908:	87aa                	mv	a5,a0
    8020290a:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    8020290e:	fec42783          	lw	a5,-20(s0)
    80202912:	2781                	sext.w	a5,a5
    80202914:	0207c463          	bltz	a5,8020293c <unregister_interrupt+0x3a>
    80202918:	fec42783          	lw	a5,-20(s0)
    8020291c:	0007871b          	sext.w	a4,a5
    80202920:	03f00793          	li	a5,63
    80202924:	00e7cc63          	blt	a5,a4,8020293c <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    80202928:	00007717          	auipc	a4,0x7
    8020292c:	7a870713          	addi	a4,a4,1960 # 8020a0d0 <interrupt_vector>
    80202930:	fec42783          	lw	a5,-20(s0)
    80202934:	078e                	slli	a5,a5,0x3
    80202936:	97ba                	add	a5,a5,a4
    80202938:	0007b023          	sd	zero,0(a5)
}
    8020293c:	0001                	nop
    8020293e:	6462                	ld	s0,24(sp)
    80202940:	6105                	addi	sp,sp,32
    80202942:	8082                	ret

0000000080202944 <enable_interrupts>:
void enable_interrupts(int irq) {
    80202944:	1101                	addi	sp,sp,-32
    80202946:	ec06                	sd	ra,24(sp)
    80202948:	e822                	sd	s0,16(sp)
    8020294a:	1000                	addi	s0,sp,32
    8020294c:	87aa                	mv	a5,a0
    8020294e:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    80202952:	fec42783          	lw	a5,-20(s0)
    80202956:	853e                	mv	a0,a5
    80202958:	00001097          	auipc	ra,0x1
    8020295c:	c8e080e7          	jalr	-882(ra) # 802035e6 <plic_enable>
}
    80202960:	0001                	nop
    80202962:	60e2                	ld	ra,24(sp)
    80202964:	6442                	ld	s0,16(sp)
    80202966:	6105                	addi	sp,sp,32
    80202968:	8082                	ret

000000008020296a <disable_interrupts>:
void disable_interrupts(int irq) {
    8020296a:	1101                	addi	sp,sp,-32
    8020296c:	ec06                	sd	ra,24(sp)
    8020296e:	e822                	sd	s0,16(sp)
    80202970:	1000                	addi	s0,sp,32
    80202972:	87aa                	mv	a5,a0
    80202974:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    80202978:	fec42783          	lw	a5,-20(s0)
    8020297c:	853e                	mv	a0,a5
    8020297e:	00001097          	auipc	ra,0x1
    80202982:	cc0080e7          	jalr	-832(ra) # 8020363e <plic_disable>
}
    80202986:	0001                	nop
    80202988:	60e2                	ld	ra,24(sp)
    8020298a:	6442                	ld	s0,16(sp)
    8020298c:	6105                	addi	sp,sp,32
    8020298e:	8082                	ret

0000000080202990 <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    80202990:	1101                	addi	sp,sp,-32
    80202992:	ec06                	sd	ra,24(sp)
    80202994:	e822                	sd	s0,16(sp)
    80202996:	1000                	addi	s0,sp,32
    80202998:	87aa                	mv	a5,a0
    8020299a:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    8020299e:	fec42783          	lw	a5,-20(s0)
    802029a2:	2781                	sext.w	a5,a5
    802029a4:	0207ce63          	bltz	a5,802029e0 <interrupt_dispatch+0x50>
    802029a8:	fec42783          	lw	a5,-20(s0)
    802029ac:	0007871b          	sext.w	a4,a5
    802029b0:	03f00793          	li	a5,63
    802029b4:	02e7c663          	blt	a5,a4,802029e0 <interrupt_dispatch+0x50>
    802029b8:	00007717          	auipc	a4,0x7
    802029bc:	71870713          	addi	a4,a4,1816 # 8020a0d0 <interrupt_vector>
    802029c0:	fec42783          	lw	a5,-20(s0)
    802029c4:	078e                	slli	a5,a5,0x3
    802029c6:	97ba                	add	a5,a5,a4
    802029c8:	639c                	ld	a5,0(a5)
    802029ca:	cb99                	beqz	a5,802029e0 <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    802029cc:	00007717          	auipc	a4,0x7
    802029d0:	70470713          	addi	a4,a4,1796 # 8020a0d0 <interrupt_vector>
    802029d4:	fec42783          	lw	a5,-20(s0)
    802029d8:	078e                	slli	a5,a5,0x3
    802029da:	97ba                	add	a5,a5,a4
    802029dc:	639c                	ld	a5,0(a5)
    802029de:	9782                	jalr	a5
}
    802029e0:	0001                	nop
    802029e2:	60e2                	ld	ra,24(sp)
    802029e4:	6442                	ld	s0,16(sp)
    802029e6:	6105                	addi	sp,sp,32
    802029e8:	8082                	ret

00000000802029ea <handle_external_interrupt>:
void handle_external_interrupt(void) {
    802029ea:	1101                	addi	sp,sp,-32
    802029ec:	ec06                	sd	ra,24(sp)
    802029ee:	e822                	sd	s0,16(sp)
    802029f0:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    802029f2:	00001097          	auipc	ra,0x1
    802029f6:	caa080e7          	jalr	-854(ra) # 8020369c <plic_claim>
    802029fa:	87aa                	mv	a5,a0
    802029fc:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    80202a00:	fec42783          	lw	a5,-20(s0)
    80202a04:	2781                	sext.w	a5,a5
    80202a06:	eb91                	bnez	a5,80202a1a <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    80202a08:	00003517          	auipc	a0,0x3
    80202a0c:	77850513          	addi	a0,a0,1912 # 80206180 <small_numbers+0xf60>
    80202a10:	ffffe097          	auipc	ra,0xffffe
    80202a14:	b88080e7          	jalr	-1144(ra) # 80200598 <printf>
        return;
    80202a18:	a839                	j	80202a36 <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    80202a1a:	fec42783          	lw	a5,-20(s0)
    80202a1e:	853e                	mv	a0,a5
    80202a20:	00000097          	auipc	ra,0x0
    80202a24:	f70080e7          	jalr	-144(ra) # 80202990 <interrupt_dispatch>
    plic_complete(irq);
    80202a28:	fec42783          	lw	a5,-20(s0)
    80202a2c:	853e                	mv	a0,a5
    80202a2e:	00001097          	auipc	ra,0x1
    80202a32:	c96080e7          	jalr	-874(ra) # 802036c4 <plic_complete>
}
    80202a36:	60e2                	ld	ra,24(sp)
    80202a38:	6442                	ld	s0,16(sp)
    80202a3a:	6105                	addi	sp,sp,32
    80202a3c:	8082                	ret

0000000080202a3e <trap_init>:
void trap_init(void) {
    80202a3e:	1101                	addi	sp,sp,-32
    80202a40:	ec06                	sd	ra,24(sp)
    80202a42:	e822                	sd	s0,16(sp)
    80202a44:	1000                	addi	s0,sp,32
	intr_off();
    80202a46:	00000097          	auipc	ra,0x0
    80202a4a:	d80080e7          	jalr	-640(ra) # 802027c6 <intr_off>
	printf("trap_init...\n");
    80202a4e:	00003517          	auipc	a0,0x3
    80202a52:	75250513          	addi	a0,a0,1874 # 802061a0 <small_numbers+0xf80>
    80202a56:	ffffe097          	auipc	ra,0xffffe
    80202a5a:	b42080e7          	jalr	-1214(ra) # 80200598 <printf>
	w_stvec((uint64)kernelvec);
    80202a5e:	00001797          	auipc	a5,0x1
    80202a62:	ca278793          	addi	a5,a5,-862 # 80203700 <kernelvec>
    80202a66:	853e                	mv	a0,a5
    80202a68:	00000097          	auipc	ra,0x0
    80202a6c:	d86080e7          	jalr	-634(ra) # 802027ee <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    80202a70:	fe042623          	sw	zero,-20(s0)
    80202a74:	a005                	j	80202a94 <trap_init+0x56>
		interrupt_vector[i] = 0;
    80202a76:	00007717          	auipc	a4,0x7
    80202a7a:	65a70713          	addi	a4,a4,1626 # 8020a0d0 <interrupt_vector>
    80202a7e:	fec42783          	lw	a5,-20(s0)
    80202a82:	078e                	slli	a5,a5,0x3
    80202a84:	97ba                	add	a5,a5,a4
    80202a86:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    80202a8a:	fec42783          	lw	a5,-20(s0)
    80202a8e:	2785                	addiw	a5,a5,1
    80202a90:	fef42623          	sw	a5,-20(s0)
    80202a94:	fec42783          	lw	a5,-20(s0)
    80202a98:	0007871b          	sext.w	a4,a5
    80202a9c:	03f00793          	li	a5,63
    80202aa0:	fce7dbe3          	bge	a5,a4,80202a76 <trap_init+0x38>
	}
	plic_init();
    80202aa4:	00001097          	auipc	ra,0x1
    80202aa8:	aa4080e7          	jalr	-1372(ra) # 80203548 <plic_init>
    uint64 sie = r_sie();
    80202aac:	00000097          	auipc	ra,0x0
    80202ab0:	c98080e7          	jalr	-872(ra) # 80202744 <r_sie>
    80202ab4:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    80202ab8:	fe043783          	ld	a5,-32(s0)
    80202abc:	2207e793          	ori	a5,a5,544
    80202ac0:	853e                	mv	a0,a5
    80202ac2:	00000097          	auipc	ra,0x0
    80202ac6:	c9c080e7          	jalr	-868(ra) # 8020275e <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80202aca:	00000097          	auipc	ra,0x0
    80202ace:	c32080e7          	jalr	-974(ra) # 802026fc <sbi_get_time>
    80202ad2:	872a                	mv	a4,a0
    80202ad4:	000f47b7          	lui	a5,0xf4
    80202ad8:	24078793          	addi	a5,a5,576 # f4240 <userret+0xf41a4>
    80202adc:	97ba                	add	a5,a5,a4
    80202ade:	853e                	mv	a0,a5
    80202ae0:	00000097          	auipc	ra,0x0
    80202ae4:	c00080e7          	jalr	-1024(ra) # 802026e0 <sbi_set_time>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    80202ae8:	00000597          	auipc	a1,0x0
    80202aec:	57258593          	addi	a1,a1,1394 # 8020305a <handle_store_page_fault>
    80202af0:	00003517          	auipc	a0,0x3
    80202af4:	6c050513          	addi	a0,a0,1728 # 802061b0 <small_numbers+0xf90>
    80202af8:	ffffe097          	auipc	ra,0xffffe
    80202afc:	aa0080e7          	jalr	-1376(ra) # 80200598 <printf>
	printf("trap_init complete.\n");
    80202b00:	00003517          	auipc	a0,0x3
    80202b04:	6e850513          	addi	a0,a0,1768 # 802061e8 <small_numbers+0xfc8>
    80202b08:	ffffe097          	auipc	ra,0xffffe
    80202b0c:	a90080e7          	jalr	-1392(ra) # 80200598 <printf>
}
    80202b10:	0001                	nop
    80202b12:	60e2                	ld	ra,24(sp)
    80202b14:	6442                	ld	s0,16(sp)
    80202b16:	6105                	addi	sp,sp,32
    80202b18:	8082                	ret

0000000080202b1a <kerneltrap>:
void kerneltrap(void) {
    80202b1a:	7149                	addi	sp,sp,-368
    80202b1c:	f686                	sd	ra,360(sp)
    80202b1e:	f2a2                	sd	s0,352(sp)
    80202b20:	1a80                	addi	s0,sp,368
    // 保存当前中断状态
    uint64 sstatus = r_sstatus();
    80202b22:	00000097          	auipc	ra,0x0
    80202b26:	c56080e7          	jalr	-938(ra) # 80202778 <r_sstatus>
    80202b2a:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    80202b2e:	00000097          	auipc	ra,0x0
    80202b32:	cda080e7          	jalr	-806(ra) # 80202808 <r_scause>
    80202b36:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    80202b3a:	00000097          	auipc	ra,0x0
    80202b3e:	ce8080e7          	jalr	-792(ra) # 80202822 <r_sepc>
    80202b42:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    80202b46:	00000097          	auipc	ra,0x0
    80202b4a:	cf6080e7          	jalr	-778(ra) # 8020283c <r_stval>
    80202b4e:	fca43823          	sd	a0,-48(s0)
    
    // 检查是否为中断（最高位为1表示中断）
    if(scause & 0x8000000000000000) {
    80202b52:	fd843783          	ld	a5,-40(s0)
    80202b56:	0607d663          	bgez	a5,80202bc2 <kerneltrap+0xa8>
        // 处理中断
        if((scause & 0xff) == 5) {
    80202b5a:	fd843783          	ld	a5,-40(s0)
    80202b5e:	0ff7f713          	zext.b	a4,a5
    80202b62:	4795                	li	a5,5
    80202b64:	02f71663          	bne	a4,a5,80202b90 <kerneltrap+0x76>
            // 时钟中断
            timeintr();
    80202b68:	00000097          	auipc	ra,0x0
    80202b6c:	bae080e7          	jalr	-1106(ra) # 80202716 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80202b70:	00000097          	auipc	ra,0x0
    80202b74:	b8c080e7          	jalr	-1140(ra) # 802026fc <sbi_get_time>
    80202b78:	872a                	mv	a4,a0
    80202b7a:	000f47b7          	lui	a5,0xf4
    80202b7e:	24078793          	addi	a5,a5,576 # f4240 <userret+0xf41a4>
    80202b82:	97ba                	add	a5,a5,a4
    80202b84:	853e                	mv	a0,a5
    80202b86:	00000097          	auipc	ra,0x0
    80202b8a:	b5a080e7          	jalr	-1190(ra) # 802026e0 <sbi_set_time>
    80202b8e:	a855                	j	80202c42 <kerneltrap+0x128>
        } else if((scause & 0xff) == 9) {
    80202b90:	fd843783          	ld	a5,-40(s0)
    80202b94:	0ff7f713          	zext.b	a4,a5
    80202b98:	47a5                	li	a5,9
    80202b9a:	00f71763          	bne	a4,a5,80202ba8 <kerneltrap+0x8e>
            // 外部中断
            handle_external_interrupt();
    80202b9e:	00000097          	auipc	ra,0x0
    80202ba2:	e4c080e7          	jalr	-436(ra) # 802029ea <handle_external_interrupt>
    80202ba6:	a871                	j	80202c42 <kerneltrap+0x128>
        } else {
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    80202ba8:	fe843603          	ld	a2,-24(s0)
    80202bac:	fd843583          	ld	a1,-40(s0)
    80202bb0:	00003517          	auipc	a0,0x3
    80202bb4:	65050513          	addi	a0,a0,1616 # 80206200 <small_numbers+0xfe0>
    80202bb8:	ffffe097          	auipc	ra,0xffffe
    80202bbc:	9e0080e7          	jalr	-1568(ra) # 80200598 <printf>
    80202bc0:	a049                	j	80202c42 <kerneltrap+0x128>
        }
    } else {
        // 处理异常（最高位为0）
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    80202bc2:	fd043683          	ld	a3,-48(s0)
    80202bc6:	fe843603          	ld	a2,-24(s0)
    80202bca:	fd843583          	ld	a1,-40(s0)
    80202bce:	00003517          	auipc	a0,0x3
    80202bd2:	66a50513          	addi	a0,a0,1642 # 80206238 <small_numbers+0x1018>
    80202bd6:	ffffe097          	auipc	ra,0xffffe
    80202bda:	9c2080e7          	jalr	-1598(ra) # 80200598 <printf>
        
        // 构造trapframe结构
        struct trapframe tf;
        save_exception_info(&tf, sepc, sstatus, scause, stval);
    80202bde:	eb040793          	addi	a5,s0,-336
    80202be2:	fd043703          	ld	a4,-48(s0)
    80202be6:	fd843683          	ld	a3,-40(s0)
    80202bea:	fe043603          	ld	a2,-32(s0)
    80202bee:	fe843583          	ld	a1,-24(s0)
    80202bf2:	853e                	mv	a0,a5
    80202bf4:	00000097          	auipc	ra,0x0
    80202bf8:	c62080e7          	jalr	-926(ra) # 80202856 <save_exception_info>
        
        // 创建一个trap_info用于传递额外信息
        struct trap_info info;
        info.sepc = sepc;
    80202bfc:	fe843783          	ld	a5,-24(s0)
    80202c00:	e8f43823          	sd	a5,-368(s0)
        info.sstatus = sstatus;
    80202c04:	fe043783          	ld	a5,-32(s0)
    80202c08:	e8f43c23          	sd	a5,-360(s0)
        info.scause = scause;
    80202c0c:	fd843783          	ld	a5,-40(s0)
    80202c10:	eaf43023          	sd	a5,-352(s0)
        info.stval = stval;
    80202c14:	fd043783          	ld	a5,-48(s0)
    80202c18:	eaf43423          	sd	a5,-344(s0)
        
        // 调用异常处理函数
        handle_exception(&tf, &info);
    80202c1c:	e9040713          	addi	a4,s0,-368
    80202c20:	eb040793          	addi	a5,s0,-336
    80202c24:	85ba                	mv	a1,a4
    80202c26:	853e                	mv	a0,a5
    80202c28:	00000097          	auipc	ra,0x0
    80202c2c:	03c080e7          	jalr	60(ra) # 80202c64 <handle_exception>
        
        // 更新sepc
        sepc = get_sepc(&tf);
    80202c30:	eb040793          	addi	a5,s0,-336
    80202c34:	853e                	mv	a0,a5
    80202c36:	00000097          	auipc	ra,0x0
    80202c3a:	c4c080e7          	jalr	-948(ra) # 80202882 <get_sepc>
    80202c3e:	fea43423          	sd	a0,-24(s0)
    }
    
    // 恢复中断现场
    w_sepc(sepc);
    80202c42:	fe843503          	ld	a0,-24(s0)
    80202c46:	00000097          	auipc	ra,0x0
    80202c4a:	b66080e7          	jalr	-1178(ra) # 802027ac <w_sepc>
    w_sstatus(sstatus);
    80202c4e:	fe043503          	ld	a0,-32(s0)
    80202c52:	00000097          	auipc	ra,0x0
    80202c56:	b40080e7          	jalr	-1216(ra) # 80202792 <w_sstatus>
}
    80202c5a:	0001                	nop
    80202c5c:	70b6                	ld	ra,360(sp)
    80202c5e:	7416                	ld	s0,352(sp)
    80202c60:	6175                	addi	sp,sp,368
    80202c62:	8082                	ret

0000000080202c64 <handle_exception>:
// 修改函数声明
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    80202c64:	7179                	addi	sp,sp,-48
    80202c66:	f406                	sd	ra,40(sp)
    80202c68:	f022                	sd	s0,32(sp)
    80202c6a:	1800                	addi	s0,sp,48
    80202c6c:	fca43c23          	sd	a0,-40(s0)
    80202c70:	fcb43823          	sd	a1,-48(s0)
    uint64 cause = info->scause;  // 使用info中的字段
    80202c74:	fd043783          	ld	a5,-48(s0)
    80202c78:	6b9c                	ld	a5,16(a5)
    80202c7a:	fef43423          	sd	a5,-24(s0)
    
    switch (cause) {
    80202c7e:	fe843703          	ld	a4,-24(s0)
    80202c82:	47bd                	li	a5,15
    80202c84:	26e7ef63          	bltu	a5,a4,80202f02 <handle_exception+0x29e>
    80202c88:	fe843783          	ld	a5,-24(s0)
    80202c8c:	00279713          	slli	a4,a5,0x2
    80202c90:	00003797          	auipc	a5,0x3
    80202c94:	76478793          	addi	a5,a5,1892 # 802063f4 <small_numbers+0x11d4>
    80202c98:	97ba                	add	a5,a5,a4
    80202c9a:	439c                	lw	a5,0(a5)
    80202c9c:	0007871b          	sext.w	a4,a5
    80202ca0:	00003797          	auipc	a5,0x3
    80202ca4:	75478793          	addi	a5,a5,1876 # 802063f4 <small_numbers+0x11d4>
    80202ca8:	97ba                	add	a5,a5,a4
    80202caa:	8782                	jr	a5
        case 0:  // 指令地址未对齐
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80202cac:	fd043783          	ld	a5,-48(s0)
    80202cb0:	6f9c                	ld	a5,24(a5)
    80202cb2:	85be                	mv	a1,a5
    80202cb4:	00003517          	auipc	a0,0x3
    80202cb8:	5b450513          	addi	a0,a0,1460 # 80206268 <small_numbers+0x1048>
    80202cbc:	ffffe097          	auipc	ra,0xffffe
    80202cc0:	8dc080e7          	jalr	-1828(ra) # 80200598 <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80202cc4:	fd043783          	ld	a5,-48(s0)
    80202cc8:	639c                	ld	a5,0(a5)
    80202cca:	0791                	addi	a5,a5,4
    80202ccc:	85be                	mv	a1,a5
    80202cce:	fd843503          	ld	a0,-40(s0)
    80202cd2:	00000097          	auipc	ra,0x0
    80202cd6:	bc8080e7          	jalr	-1080(ra) # 8020289a <set_sepc>
            break;
    80202cda:	a495                	j	80202f3e <handle_exception+0x2da>
            
        case 1:  // 指令访问故障
            printf("Instruction access fault: 0x%lx\n", info->stval);
    80202cdc:	fd043783          	ld	a5,-48(s0)
    80202ce0:	6f9c                	ld	a5,24(a5)
    80202ce2:	85be                	mv	a1,a5
    80202ce4:	00003517          	auipc	a0,0x3
    80202ce8:	5ac50513          	addi	a0,a0,1452 # 80206290 <small_numbers+0x1070>
    80202cec:	ffffe097          	auipc	ra,0xffffe
    80202cf0:	8ac080e7          	jalr	-1876(ra) # 80200598 <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80202cf4:	fd043783          	ld	a5,-48(s0)
    80202cf8:	639c                	ld	a5,0(a5)
    80202cfa:	0791                	addi	a5,a5,4
    80202cfc:	85be                	mv	a1,a5
    80202cfe:	fd843503          	ld	a0,-40(s0)
    80202d02:	00000097          	auipc	ra,0x0
    80202d06:	b98080e7          	jalr	-1128(ra) # 8020289a <set_sepc>
            break;
    80202d0a:	ac15                	j	80202f3e <handle_exception+0x2da>
            
        case 2:  // 非法指令
            printf("Illegal instruction at 0x%lx: 0x%lx\n", info->sepc, info->stval);
    80202d0c:	fd043783          	ld	a5,-48(s0)
    80202d10:	6398                	ld	a4,0(a5)
    80202d12:	fd043783          	ld	a5,-48(s0)
    80202d16:	6f9c                	ld	a5,24(a5)
    80202d18:	863e                	mv	a2,a5
    80202d1a:	85ba                	mv	a1,a4
    80202d1c:	00003517          	auipc	a0,0x3
    80202d20:	59c50513          	addi	a0,a0,1436 # 802062b8 <small_numbers+0x1098>
    80202d24:	ffffe097          	auipc	ra,0xffffe
    80202d28:	874080e7          	jalr	-1932(ra) # 80200598 <printf>
			set_sepc(tf, info->sepc + 4); 
    80202d2c:	fd043783          	ld	a5,-48(s0)
    80202d30:	639c                	ld	a5,0(a5)
    80202d32:	0791                	addi	a5,a5,4
    80202d34:	85be                	mv	a1,a5
    80202d36:	fd843503          	ld	a0,-40(s0)
    80202d3a:	00000097          	auipc	ra,0x0
    80202d3e:	b60080e7          	jalr	-1184(ra) # 8020289a <set_sepc>
            break;
    80202d42:	aaf5                	j	80202f3e <handle_exception+0x2da>
            
        case 3:  // 断点
            printf("Breakpoint at 0x%lx\n", info->sepc);
    80202d44:	fd043783          	ld	a5,-48(s0)
    80202d48:	639c                	ld	a5,0(a5)
    80202d4a:	85be                	mv	a1,a5
    80202d4c:	00003517          	auipc	a0,0x3
    80202d50:	59450513          	addi	a0,a0,1428 # 802062e0 <small_numbers+0x10c0>
    80202d54:	ffffe097          	auipc	ra,0xffffe
    80202d58:	844080e7          	jalr	-1980(ra) # 80200598 <printf>
            set_sepc(tf, info->sepc + 4);
    80202d5c:	fd043783          	ld	a5,-48(s0)
    80202d60:	639c                	ld	a5,0(a5)
    80202d62:	0791                	addi	a5,a5,4
    80202d64:	85be                	mv	a1,a5
    80202d66:	fd843503          	ld	a0,-40(s0)
    80202d6a:	00000097          	auipc	ra,0x0
    80202d6e:	b30080e7          	jalr	-1232(ra) # 8020289a <set_sepc>
            break;
    80202d72:	a2f1                	j	80202f3e <handle_exception+0x2da>
            
        case 4:  // 加载地址未对齐
            printf("Load address misaligned: 0x%lx\n", info->stval);
    80202d74:	fd043783          	ld	a5,-48(s0)
    80202d78:	6f9c                	ld	a5,24(a5)
    80202d7a:	85be                	mv	a1,a5
    80202d7c:	00003517          	auipc	a0,0x3
    80202d80:	57c50513          	addi	a0,a0,1404 # 802062f8 <small_numbers+0x10d8>
    80202d84:	ffffe097          	auipc	ra,0xffffe
    80202d88:	814080e7          	jalr	-2028(ra) # 80200598 <printf>
			set_sepc(tf, info->sepc + 4); 
    80202d8c:	fd043783          	ld	a5,-48(s0)
    80202d90:	639c                	ld	a5,0(a5)
    80202d92:	0791                	addi	a5,a5,4
    80202d94:	85be                	mv	a1,a5
    80202d96:	fd843503          	ld	a0,-40(s0)
    80202d9a:	00000097          	auipc	ra,0x0
    80202d9e:	b00080e7          	jalr	-1280(ra) # 8020289a <set_sepc>
            break;
    80202da2:	aa71                	j	80202f3e <handle_exception+0x2da>
            
		case 5:  // 加载访问故障
			printf("Load access fault: 0x%lx\n", info->stval);
    80202da4:	fd043783          	ld	a5,-48(s0)
    80202da8:	6f9c                	ld	a5,24(a5)
    80202daa:	85be                	mv	a1,a5
    80202dac:	00003517          	auipc	a0,0x3
    80202db0:	56c50513          	addi	a0,a0,1388 # 80206318 <small_numbers+0x10f8>
    80202db4:	ffffd097          	auipc	ra,0xffffd
    80202db8:	7e4080e7          	jalr	2020(ra) # 80200598 <printf>
			// 尝试先增加页权限
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
    80202dbc:	fd043783          	ld	a5,-48(s0)
    80202dc0:	6f9c                	ld	a5,24(a5)
    80202dc2:	853e                	mv	a0,a5
    80202dc4:	fffff097          	auipc	ra,0xfffff
    80202dc8:	47a080e7          	jalr	1146(ra) # 8020223e <check_is_mapped>
    80202dcc:	87aa                	mv	a5,a0
    80202dce:	cf89                	beqz	a5,80202de8 <handle_exception+0x184>
    80202dd0:	fd043783          	ld	a5,-48(s0)
    80202dd4:	6f9c                	ld	a5,24(a5)
    80202dd6:	4589                	li	a1,2
    80202dd8:	853e                	mv	a0,a5
    80202dda:	fffff097          	auipc	ra,0xfffff
    80202dde:	036080e7          	jalr	54(ra) # 80201e10 <handle_page_fault>
    80202de2:	87aa                	mv	a5,a0
    80202de4:	14079a63          	bnez	a5,80202f38 <handle_exception+0x2d4>
				return; // 成功处理
			}
			// 如果无法处理或不是权限问题，则跳过错误指令
			set_sepc(tf, info->sepc + 4);
    80202de8:	fd043783          	ld	a5,-48(s0)
    80202dec:	639c                	ld	a5,0(a5)
    80202dee:	0791                	addi	a5,a5,4
    80202df0:	85be                	mv	a1,a5
    80202df2:	fd843503          	ld	a0,-40(s0)
    80202df6:	00000097          	auipc	ra,0x0
    80202dfa:	aa4080e7          	jalr	-1372(ra) # 8020289a <set_sepc>
			break;
    80202dfe:	a281                	j	80202f3e <handle_exception+0x2da>
            
        case 6:  // 存储地址未对齐
            printf("Store address misaligned: 0x%lx\n", info->stval);
    80202e00:	fd043783          	ld	a5,-48(s0)
    80202e04:	6f9c                	ld	a5,24(a5)
    80202e06:	85be                	mv	a1,a5
    80202e08:	00003517          	auipc	a0,0x3
    80202e0c:	53050513          	addi	a0,a0,1328 # 80206338 <small_numbers+0x1118>
    80202e10:	ffffd097          	auipc	ra,0xffffd
    80202e14:	788080e7          	jalr	1928(ra) # 80200598 <printf>
			set_sepc(tf, info->sepc + 4); 
    80202e18:	fd043783          	ld	a5,-48(s0)
    80202e1c:	639c                	ld	a5,0(a5)
    80202e1e:	0791                	addi	a5,a5,4
    80202e20:	85be                	mv	a1,a5
    80202e22:	fd843503          	ld	a0,-40(s0)
    80202e26:	00000097          	auipc	ra,0x0
    80202e2a:	a74080e7          	jalr	-1420(ra) # 8020289a <set_sepc>
            break;
    80202e2e:	aa01                	j	80202f3e <handle_exception+0x2da>
            
		case 7:  // 存储访问故障
			printf("Store access fault: 0x%lx\n", info->stval);
    80202e30:	fd043783          	ld	a5,-48(s0)
    80202e34:	6f9c                	ld	a5,24(a5)
    80202e36:	85be                	mv	a1,a5
    80202e38:	00003517          	auipc	a0,0x3
    80202e3c:	52850513          	addi	a0,a0,1320 # 80206360 <small_numbers+0x1140>
    80202e40:	ffffd097          	auipc	ra,0xffffd
    80202e44:	758080e7          	jalr	1880(ra) # 80200598 <printf>
			// 尝试先增加页权限
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
    80202e48:	fd043783          	ld	a5,-48(s0)
    80202e4c:	6f9c                	ld	a5,24(a5)
    80202e4e:	853e                	mv	a0,a5
    80202e50:	fffff097          	auipc	ra,0xfffff
    80202e54:	3ee080e7          	jalr	1006(ra) # 8020223e <check_is_mapped>
    80202e58:	87aa                	mv	a5,a0
    80202e5a:	cf81                	beqz	a5,80202e72 <handle_exception+0x20e>
    80202e5c:	fd043783          	ld	a5,-48(s0)
    80202e60:	6f9c                	ld	a5,24(a5)
    80202e62:	458d                	li	a1,3
    80202e64:	853e                	mv	a0,a5
    80202e66:	fffff097          	auipc	ra,0xfffff
    80202e6a:	faa080e7          	jalr	-86(ra) # 80201e10 <handle_page_fault>
    80202e6e:	87aa                	mv	a5,a0
    80202e70:	e7f1                	bnez	a5,80202f3c <handle_exception+0x2d8>
				return; // 成功处理
			}
			// 如果无法处理或不是权限问题，则跳过错误指令
			set_sepc(tf, info->sepc + 4);
    80202e72:	fd043783          	ld	a5,-48(s0)
    80202e76:	639c                	ld	a5,0(a5)
    80202e78:	0791                	addi	a5,a5,4
    80202e7a:	85be                	mv	a1,a5
    80202e7c:	fd843503          	ld	a0,-40(s0)
    80202e80:	00000097          	auipc	ra,0x0
    80202e84:	a1a080e7          	jalr	-1510(ra) # 8020289a <set_sepc>
			break;
    80202e88:	a85d                	j	80202f3e <handle_exception+0x2da>
            
        case 8:  // 用户模式环境调用
            handle_syscall(tf,info);
    80202e8a:	fd043583          	ld	a1,-48(s0)
    80202e8e:	fd843503          	ld	a0,-40(s0)
    80202e92:	00000097          	auipc	ra,0x0
    80202e96:	0b4080e7          	jalr	180(ra) # 80202f46 <handle_syscall>
            break;
    80202e9a:	a055                	j	80202f3e <handle_exception+0x2da>
            
        case 9:  // 监督模式环境调用
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    80202e9c:	fd043783          	ld	a5,-48(s0)
    80202ea0:	639c                	ld	a5,0(a5)
    80202ea2:	85be                	mv	a1,a5
    80202ea4:	00003517          	auipc	a0,0x3
    80202ea8:	4dc50513          	addi	a0,a0,1244 # 80206380 <small_numbers+0x1160>
    80202eac:	ffffd097          	auipc	ra,0xffffd
    80202eb0:	6ec080e7          	jalr	1772(ra) # 80200598 <printf>
			set_sepc(tf, info->sepc + 4); 
    80202eb4:	fd043783          	ld	a5,-48(s0)
    80202eb8:	639c                	ld	a5,0(a5)
    80202eba:	0791                	addi	a5,a5,4
    80202ebc:	85be                	mv	a1,a5
    80202ebe:	fd843503          	ld	a0,-40(s0)
    80202ec2:	00000097          	auipc	ra,0x0
    80202ec6:	9d8080e7          	jalr	-1576(ra) # 8020289a <set_sepc>
            break;
    80202eca:	a895                	j	80202f3e <handle_exception+0x2da>
            
        case 12:  // 指令页故障
            handle_instruction_page_fault(tf,info);
    80202ecc:	fd043583          	ld	a1,-48(s0)
    80202ed0:	fd843503          	ld	a0,-40(s0)
    80202ed4:	00000097          	auipc	ra,0x0
    80202ed8:	0c2080e7          	jalr	194(ra) # 80202f96 <handle_instruction_page_fault>
            break;
    80202edc:	a08d                	j	80202f3e <handle_exception+0x2da>
            
        case 13:  // 加载页故障
            handle_load_page_fault(tf,info);
    80202ede:	fd043583          	ld	a1,-48(s0)
    80202ee2:	fd843503          	ld	a0,-40(s0)
    80202ee6:	00000097          	auipc	ra,0x0
    80202eea:	112080e7          	jalr	274(ra) # 80202ff8 <handle_load_page_fault>
            break;
    80202eee:	a881                	j	80202f3e <handle_exception+0x2da>
            
        case 15:  // 存储页故障
            handle_store_page_fault(tf,info);
    80202ef0:	fd043583          	ld	a1,-48(s0)
    80202ef4:	fd843503          	ld	a0,-40(s0)
    80202ef8:	00000097          	auipc	ra,0x0
    80202efc:	162080e7          	jalr	354(ra) # 8020305a <handle_store_page_fault>
            break;
    80202f00:	a83d                	j	80202f3e <handle_exception+0x2da>
            
        default:
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    80202f02:	fd043783          	ld	a5,-48(s0)
    80202f06:	6398                	ld	a4,0(a5)
    80202f08:	fd043783          	ld	a5,-48(s0)
    80202f0c:	6f9c                	ld	a5,24(a5)
    80202f0e:	86be                	mv	a3,a5
    80202f10:	863a                	mv	a2,a4
    80202f12:	fe843583          	ld	a1,-24(s0)
    80202f16:	00003517          	auipc	a0,0x3
    80202f1a:	49250513          	addi	a0,a0,1170 # 802063a8 <small_numbers+0x1188>
    80202f1e:	ffffd097          	auipc	ra,0xffffd
    80202f22:	67a080e7          	jalr	1658(ra) # 80200598 <printf>
                   cause, info->sepc, info->stval);
            panic("Unknown exception");
    80202f26:	00003517          	auipc	a0,0x3
    80202f2a:	4ba50513          	addi	a0,a0,1210 # 802063e0 <small_numbers+0x11c0>
    80202f2e:	ffffe097          	auipc	ra,0xffffe
    80202f32:	f72080e7          	jalr	-142(ra) # 80200ea0 <panic>
            break;
    80202f36:	a021                	j	80202f3e <handle_exception+0x2da>
				return; // 成功处理
    80202f38:	0001                	nop
    80202f3a:	a011                	j	80202f3e <handle_exception+0x2da>
				return; // 成功处理
    80202f3c:	0001                	nop
    }
}
    80202f3e:	70a2                	ld	ra,40(sp)
    80202f40:	7402                	ld	s0,32(sp)
    80202f42:	6145                	addi	sp,sp,48
    80202f44:	8082                	ret

0000000080202f46 <handle_syscall>:
// 处理系统调用
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    80202f46:	1101                	addi	sp,sp,-32
    80202f48:	ec06                	sd	ra,24(sp)
    80202f4a:	e822                	sd	s0,16(sp)
    80202f4c:	1000                	addi	s0,sp,32
    80202f4e:	fea43423          	sd	a0,-24(s0)
    80202f52:	feb43023          	sd	a1,-32(s0)
    printf("System call from sepc=0x%lx, syscall number=%ld\n", info->sepc, tf->a7);
    80202f56:	fe043783          	ld	a5,-32(s0)
    80202f5a:	6398                	ld	a4,0(a5)
    80202f5c:	fe843783          	ld	a5,-24(s0)
    80202f60:	77dc                	ld	a5,168(a5)
    80202f62:	863e                	mv	a2,a5
    80202f64:	85ba                	mv	a1,a4
    80202f66:	00003517          	auipc	a0,0x3
    80202f6a:	4d250513          	addi	a0,a0,1234 # 80206438 <small_numbers+0x1218>
    80202f6e:	ffffd097          	auipc	ra,0xffffd
    80202f72:	62a080e7          	jalr	1578(ra) # 80200598 <printf>
    
    // 系统调用返回值存放在a0寄存器
    // tf->a0 = sys_call(tf->a7, tf->a0, tf->a1, tf->a2, tf->a3, tf->a4, tf->a5);
    
    // 系统调用完成后，sepc应该指向下一条指令
    set_sepc(tf, info->sepc + 4);
    80202f76:	fe043783          	ld	a5,-32(s0)
    80202f7a:	639c                	ld	a5,0(a5)
    80202f7c:	0791                	addi	a5,a5,4
    80202f7e:	85be                	mv	a1,a5
    80202f80:	fe843503          	ld	a0,-24(s0)
    80202f84:	00000097          	auipc	ra,0x0
    80202f88:	916080e7          	jalr	-1770(ra) # 8020289a <set_sepc>
}
    80202f8c:	0001                	nop
    80202f8e:	60e2                	ld	ra,24(sp)
    80202f90:	6442                	ld	s0,16(sp)
    80202f92:	6105                	addi	sp,sp,32
    80202f94:	8082                	ret

0000000080202f96 <handle_instruction_page_fault>:


// 处理指令页故障
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    80202f96:	1101                	addi	sp,sp,-32
    80202f98:	ec06                	sd	ra,24(sp)
    80202f9a:	e822                	sd	s0,16(sp)
    80202f9c:	1000                	addi	s0,sp,32
    80202f9e:	fea43423          	sd	a0,-24(s0)
    80202fa2:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80202fa6:	fe043783          	ld	a5,-32(s0)
    80202faa:	6f98                	ld	a4,24(a5)
    80202fac:	fe043783          	ld	a5,-32(s0)
    80202fb0:	639c                	ld	a5,0(a5)
    80202fb2:	863e                	mv	a2,a5
    80202fb4:	85ba                	mv	a1,a4
    80202fb6:	00003517          	auipc	a0,0x3
    80202fba:	4ba50513          	addi	a0,a0,1210 # 80206470 <small_numbers+0x1250>
    80202fbe:	ffffd097          	auipc	ra,0xffffd
    80202fc2:	5da080e7          	jalr	1498(ra) # 80200598 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    80202fc6:	fe043783          	ld	a5,-32(s0)
    80202fca:	6f9c                	ld	a5,24(a5)
    80202fcc:	4585                	li	a1,1
    80202fce:	853e                	mv	a0,a5
    80202fd0:	fffff097          	auipc	ra,0xfffff
    80202fd4:	e40080e7          	jalr	-448(ra) # 80201e10 <handle_page_fault>
    80202fd8:	87aa                	mv	a5,a0
    80202fda:	eb91                	bnez	a5,80202fee <handle_instruction_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled instruction page fault");
    80202fdc:	00003517          	auipc	a0,0x3
    80202fe0:	4c450513          	addi	a0,a0,1220 # 802064a0 <small_numbers+0x1280>
    80202fe4:	ffffe097          	auipc	ra,0xffffe
    80202fe8:	ebc080e7          	jalr	-324(ra) # 80200ea0 <panic>
    80202fec:	a011                	j	80202ff0 <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80202fee:	0001                	nop
}
    80202ff0:	60e2                	ld	ra,24(sp)
    80202ff2:	6442                	ld	s0,16(sp)
    80202ff4:	6105                	addi	sp,sp,32
    80202ff6:	8082                	ret

0000000080202ff8 <handle_load_page_fault>:

// 处理加载页故障
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    80202ff8:	1101                	addi	sp,sp,-32
    80202ffa:	ec06                	sd	ra,24(sp)
    80202ffc:	e822                	sd	s0,16(sp)
    80202ffe:	1000                	addi	s0,sp,32
    80203000:	fea43423          	sd	a0,-24(s0)
    80203004:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80203008:	fe043783          	ld	a5,-32(s0)
    8020300c:	6f98                	ld	a4,24(a5)
    8020300e:	fe043783          	ld	a5,-32(s0)
    80203012:	639c                	ld	a5,0(a5)
    80203014:	863e                	mv	a2,a5
    80203016:	85ba                	mv	a1,a4
    80203018:	00003517          	auipc	a0,0x3
    8020301c:	4b050513          	addi	a0,a0,1200 # 802064c8 <small_numbers+0x12a8>
    80203020:	ffffd097          	auipc	ra,0xffffd
    80203024:	578080e7          	jalr	1400(ra) # 80200598 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    80203028:	fe043783          	ld	a5,-32(s0)
    8020302c:	6f9c                	ld	a5,24(a5)
    8020302e:	4589                	li	a1,2
    80203030:	853e                	mv	a0,a5
    80203032:	fffff097          	auipc	ra,0xfffff
    80203036:	dde080e7          	jalr	-546(ra) # 80201e10 <handle_page_fault>
    8020303a:	87aa                	mv	a5,a0
    8020303c:	eb91                	bnez	a5,80203050 <handle_load_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled load page fault");
    8020303e:	00003517          	auipc	a0,0x3
    80203042:	4ba50513          	addi	a0,a0,1210 # 802064f8 <small_numbers+0x12d8>
    80203046:	ffffe097          	auipc	ra,0xffffe
    8020304a:	e5a080e7          	jalr	-422(ra) # 80200ea0 <panic>
    8020304e:	a011                	j	80203052 <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80203050:	0001                	nop
}
    80203052:	60e2                	ld	ra,24(sp)
    80203054:	6442                	ld	s0,16(sp)
    80203056:	6105                	addi	sp,sp,32
    80203058:	8082                	ret

000000008020305a <handle_store_page_fault>:

// 处理存储页故障
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    8020305a:	1101                	addi	sp,sp,-32
    8020305c:	ec06                	sd	ra,24(sp)
    8020305e:	e822                	sd	s0,16(sp)
    80203060:	1000                	addi	s0,sp,32
    80203062:	fea43423          	sd	a0,-24(s0)
    80203066:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    8020306a:	fe043783          	ld	a5,-32(s0)
    8020306e:	6f98                	ld	a4,24(a5)
    80203070:	fe043783          	ld	a5,-32(s0)
    80203074:	639c                	ld	a5,0(a5)
    80203076:	863e                	mv	a2,a5
    80203078:	85ba                	mv	a1,a4
    8020307a:	00003517          	auipc	a0,0x3
    8020307e:	49e50513          	addi	a0,a0,1182 # 80206518 <small_numbers+0x12f8>
    80203082:	ffffd097          	auipc	ra,0xffffd
    80203086:	516080e7          	jalr	1302(ra) # 80200598 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    8020308a:	fe043783          	ld	a5,-32(s0)
    8020308e:	6f9c                	ld	a5,24(a5)
    80203090:	458d                	li	a1,3
    80203092:	853e                	mv	a0,a5
    80203094:	fffff097          	auipc	ra,0xfffff
    80203098:	d7c080e7          	jalr	-644(ra) # 80201e10 <handle_page_fault>
    8020309c:	87aa                	mv	a5,a0
    8020309e:	eb91                	bnez	a5,802030b2 <handle_store_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled store page fault");
    802030a0:	00003517          	auipc	a0,0x3
    802030a4:	4a850513          	addi	a0,a0,1192 # 80206548 <small_numbers+0x1328>
    802030a8:	ffffe097          	auipc	ra,0xffffe
    802030ac:	df8080e7          	jalr	-520(ra) # 80200ea0 <panic>
    802030b0:	a011                	j	802030b4 <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802030b2:	0001                	nop
}
    802030b4:	60e2                	ld	ra,24(sp)
    802030b6:	6442                	ld	s0,16(sp)
    802030b8:	6105                	addi	sp,sp,32
    802030ba:	8082                	ret

00000000802030bc <get_time>:
// 获取当前时间的辅助函数
uint64 get_time(void) {
    802030bc:	1141                	addi	sp,sp,-16
    802030be:	e406                	sd	ra,8(sp)
    802030c0:	e022                	sd	s0,0(sp)
    802030c2:	0800                	addi	s0,sp,16
    return sbi_get_time();
    802030c4:	fffff097          	auipc	ra,0xfffff
    802030c8:	638080e7          	jalr	1592(ra) # 802026fc <sbi_get_time>
    802030cc:	87aa                	mv	a5,a0
}
    802030ce:	853e                	mv	a0,a5
    802030d0:	60a2                	ld	ra,8(sp)
    802030d2:	6402                	ld	s0,0(sp)
    802030d4:	0141                	addi	sp,sp,16
    802030d6:	8082                	ret

00000000802030d8 <test_timer_interrupt>:

// 时钟中断测试函数
void test_timer_interrupt(void) {
    802030d8:	7179                	addi	sp,sp,-48
    802030da:	f406                	sd	ra,40(sp)
    802030dc:	f022                	sd	s0,32(sp)
    802030de:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    802030e0:	00003517          	auipc	a0,0x3
    802030e4:	48850513          	addi	a0,a0,1160 # 80206568 <small_numbers+0x1348>
    802030e8:	ffffd097          	auipc	ra,0xffffd
    802030ec:	4b0080e7          	jalr	1200(ra) # 80200598 <printf>

    // 记录中断前的时间
    uint64 start_time = get_time();
    802030f0:	00000097          	auipc	ra,0x0
    802030f4:	fcc080e7          	jalr	-52(ra) # 802030bc <get_time>
    802030f8:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    802030fc:	fc042a23          	sw	zero,-44(s0)
	int last_count = interrupt_count;
    80203100:	fd442783          	lw	a5,-44(s0)
    80203104:	fef42623          	sw	a5,-20(s0)
    // 设置测试标志
    interrupt_test_flag = &interrupt_count;
    80203108:	00007797          	auipc	a5,0x7
    8020310c:	f2078793          	addi	a5,a5,-224 # 8020a028 <interrupt_test_flag>
    80203110:	fd440713          	addi	a4,s0,-44
    80203114:	e398                	sd	a4,0(a5)

    // 等待几次中断
    while (interrupt_count < 5) {
    80203116:	a899                	j	8020316c <test_timer_interrupt+0x94>
        if(last_count != interrupt_count) {
    80203118:	fd442703          	lw	a4,-44(s0)
    8020311c:	fec42783          	lw	a5,-20(s0)
    80203120:	2781                	sext.w	a5,a5
    80203122:	02e78163          	beq	a5,a4,80203144 <test_timer_interrupt+0x6c>
			last_count = interrupt_count;
    80203126:	fd442783          	lw	a5,-44(s0)
    8020312a:	fef42623          	sw	a5,-20(s0)
			printf("Received interrupt %d\n", interrupt_count);
    8020312e:	fd442783          	lw	a5,-44(s0)
    80203132:	85be                	mv	a1,a5
    80203134:	00003517          	auipc	a0,0x3
    80203138:	45450513          	addi	a0,a0,1108 # 80206588 <small_numbers+0x1368>
    8020313c:	ffffd097          	auipc	ra,0xffffd
    80203140:	45c080e7          	jalr	1116(ra) # 80200598 <printf>
		}
        // 简单延时
        for (volatile int i = 0; i < 1000000; i++);
    80203144:	fc042823          	sw	zero,-48(s0)
    80203148:	a801                	j	80203158 <test_timer_interrupt+0x80>
    8020314a:	fd042783          	lw	a5,-48(s0)
    8020314e:	2781                	sext.w	a5,a5
    80203150:	2785                	addiw	a5,a5,1
    80203152:	2781                	sext.w	a5,a5
    80203154:	fcf42823          	sw	a5,-48(s0)
    80203158:	fd042783          	lw	a5,-48(s0)
    8020315c:	2781                	sext.w	a5,a5
    8020315e:	873e                	mv	a4,a5
    80203160:	000f47b7          	lui	a5,0xf4
    80203164:	23f78793          	addi	a5,a5,575 # f423f <userret+0xf41a3>
    80203168:	fee7d1e3          	bge	a5,a4,8020314a <test_timer_interrupt+0x72>
    while (interrupt_count < 5) {
    8020316c:	fd442783          	lw	a5,-44(s0)
    80203170:	873e                	mv	a4,a5
    80203172:	4791                	li	a5,4
    80203174:	fae7d2e3          	bge	a5,a4,80203118 <test_timer_interrupt+0x40>
    }

    // 测试结束，清除标志
    interrupt_test_flag = 0;
    80203178:	00007797          	auipc	a5,0x7
    8020317c:	eb078793          	addi	a5,a5,-336 # 8020a028 <interrupt_test_flag>
    80203180:	0007b023          	sd	zero,0(a5)

    uint64 end_time = get_time();
    80203184:	00000097          	auipc	ra,0x0
    80203188:	f38080e7          	jalr	-200(ra) # 802030bc <get_time>
    8020318c:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    80203190:	fd442683          	lw	a3,-44(s0)
    80203194:	fd843703          	ld	a4,-40(s0)
    80203198:	fe043783          	ld	a5,-32(s0)
    8020319c:	40f707b3          	sub	a5,a4,a5
    802031a0:	863e                	mv	a2,a5
    802031a2:	85b6                	mv	a1,a3
    802031a4:	00003517          	auipc	a0,0x3
    802031a8:	3fc50513          	addi	a0,a0,1020 # 802065a0 <small_numbers+0x1380>
    802031ac:	ffffd097          	auipc	ra,0xffffd
    802031b0:	3ec080e7          	jalr	1004(ra) # 80200598 <printf>
           interrupt_count, end_time - start_time);
}
    802031b4:	0001                	nop
    802031b6:	70a2                	ld	ra,40(sp)
    802031b8:	7402                	ld	s0,32(sp)
    802031ba:	6145                	addi	sp,sp,48
    802031bc:	8082                	ret

00000000802031be <test_exception>:

// 修改测试异常处理函数
void test_exception(void) {
    802031be:	715d                	addi	sp,sp,-80
    802031c0:	e486                	sd	ra,72(sp)
    802031c2:	e0a2                	sd	s0,64(sp)
    802031c4:	0880                	addi	s0,sp,80
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    802031c6:	00003517          	auipc	a0,0x3
    802031ca:	41250513          	addi	a0,a0,1042 # 802065d8 <small_numbers+0x13b8>
    802031ce:	ffffd097          	auipc	ra,0xffffd
    802031d2:	3ca080e7          	jalr	970(ra) # 80200598 <printf>
    
    // 1. 测试非法指令异常
    printf("1. 测试非法指令异常...\n");
    802031d6:	00003517          	auipc	a0,0x3
    802031da:	43250513          	addi	a0,a0,1074 # 80206608 <small_numbers+0x13e8>
    802031de:	ffffd097          	auipc	ra,0xffffd
    802031e2:	3ba080e7          	jalr	954(ra) # 80200598 <printf>
    802031e6:	ffffffff          	.word	0xffffffff
    asm volatile (".word 0xffffffff");  // 非法RISC-V指令
    printf("✓ 非法指令异常处理成功\n\n");
    802031ea:	00003517          	auipc	a0,0x3
    802031ee:	43e50513          	addi	a0,a0,1086 # 80206628 <small_numbers+0x1408>
    802031f2:	ffffd097          	auipc	ra,0xffffd
    802031f6:	3a6080e7          	jalr	934(ra) # 80200598 <printf>
    
    // 2. 测试存储页故障
    printf("2. 测试存储页故障异常...\n");
    802031fa:	00003517          	auipc	a0,0x3
    802031fe:	45650513          	addi	a0,a0,1110 # 80206650 <small_numbers+0x1430>
    80203202:	ffffd097          	auipc	ra,0xffffd
    80203206:	396080e7          	jalr	918(ra) # 80200598 <printf>
    volatile uint64 *invalid_ptr = 0;
    8020320a:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    8020320e:	47a5                	li	a5,9
    80203210:	07f2                	slli	a5,a5,0x1c
    80203212:	fef43023          	sd	a5,-32(s0)
    80203216:	a835                	j	80203252 <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    80203218:	fe043503          	ld	a0,-32(s0)
    8020321c:	fffff097          	auipc	ra,0xfffff
    80203220:	022080e7          	jalr	34(ra) # 8020223e <check_is_mapped>
    80203224:	87aa                	mv	a5,a0
    80203226:	e385                	bnez	a5,80203246 <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    80203228:	fe043783          	ld	a5,-32(s0)
    8020322c:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80203230:	fe043583          	ld	a1,-32(s0)
    80203234:	00003517          	auipc	a0,0x3
    80203238:	44450513          	addi	a0,a0,1092 # 80206678 <small_numbers+0x1458>
    8020323c:	ffffd097          	auipc	ra,0xffffd
    80203240:	35c080e7          	jalr	860(ra) # 80200598 <printf>
            break;
    80203244:	a829                	j	8020325e <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80203246:	fe043703          	ld	a4,-32(s0)
    8020324a:	6785                	lui	a5,0x1
    8020324c:	97ba                	add	a5,a5,a4
    8020324e:	fef43023          	sd	a5,-32(s0)
    80203252:	fe043703          	ld	a4,-32(s0)
    80203256:	47cd                	li	a5,19
    80203258:	07ee                	slli	a5,a5,0x1b
    8020325a:	faf76fe3          	bltu	a4,a5,80203218 <test_exception+0x5a>
        }
    }
    
    if (invalid_ptr != 0) {
    8020325e:	fe843783          	ld	a5,-24(s0)
    80203262:	cb95                	beqz	a5,80203296 <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80203264:	fe843783          	ld	a5,-24(s0)
    80203268:	85be                	mv	a1,a5
    8020326a:	00003517          	auipc	a0,0x3
    8020326e:	42e50513          	addi	a0,a0,1070 # 80206698 <small_numbers+0x1478>
    80203272:	ffffd097          	auipc	ra,0xffffd
    80203276:	326080e7          	jalr	806(ra) # 80200598 <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    8020327a:	fe843783          	ld	a5,-24(s0)
    8020327e:	02a00713          	li	a4,42
    80203282:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    80203284:	00003517          	auipc	a0,0x3
    80203288:	44450513          	addi	a0,a0,1092 # 802066c8 <small_numbers+0x14a8>
    8020328c:	ffffd097          	auipc	ra,0xffffd
    80203290:	30c080e7          	jalr	780(ra) # 80200598 <printf>
    80203294:	a809                	j	802032a6 <test_exception+0xe8>
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80203296:	00003517          	auipc	a0,0x3
    8020329a:	45a50513          	addi	a0,a0,1114 # 802066f0 <small_numbers+0x14d0>
    8020329e:	ffffd097          	auipc	ra,0xffffd
    802032a2:	2fa080e7          	jalr	762(ra) # 80200598 <printf>
    }
    
    // 3. 测试加载页故障
    printf("3. 测试加载页故障异常...\n");
    802032a6:	00003517          	auipc	a0,0x3
    802032aa:	48250513          	addi	a0,a0,1154 # 80206728 <small_numbers+0x1508>
    802032ae:	ffffd097          	auipc	ra,0xffffd
    802032b2:	2ea080e7          	jalr	746(ra) # 80200598 <printf>
    invalid_ptr = 0;
    802032b6:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802032ba:	4795                	li	a5,5
    802032bc:	07f6                	slli	a5,a5,0x1d
    802032be:	fcf43c23          	sd	a5,-40(s0)
    802032c2:	a835                	j	802032fe <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    802032c4:	fd843503          	ld	a0,-40(s0)
    802032c8:	fffff097          	auipc	ra,0xfffff
    802032cc:	f76080e7          	jalr	-138(ra) # 8020223e <check_is_mapped>
    802032d0:	87aa                	mv	a5,a0
    802032d2:	e385                	bnez	a5,802032f2 <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    802032d4:	fd843783          	ld	a5,-40(s0)
    802032d8:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    802032dc:	fd843583          	ld	a1,-40(s0)
    802032e0:	00003517          	auipc	a0,0x3
    802032e4:	39850513          	addi	a0,a0,920 # 80206678 <small_numbers+0x1458>
    802032e8:	ffffd097          	auipc	ra,0xffffd
    802032ec:	2b0080e7          	jalr	688(ra) # 80200598 <printf>
            break;
    802032f0:	a829                	j	8020330a <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802032f2:	fd843703          	ld	a4,-40(s0)
    802032f6:	6785                	lui	a5,0x1
    802032f8:	97ba                	add	a5,a5,a4
    802032fa:	fcf43c23          	sd	a5,-40(s0)
    802032fe:	fd843703          	ld	a4,-40(s0)
    80203302:	47d5                	li	a5,21
    80203304:	07ee                	slli	a5,a5,0x1b
    80203306:	faf76fe3          	bltu	a4,a5,802032c4 <test_exception+0x106>
        }
    }
    
    if (invalid_ptr != 0) {
    8020330a:	fe843783          	ld	a5,-24(s0)
    8020330e:	c7a9                	beqz	a5,80203358 <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80203310:	fe843783          	ld	a5,-24(s0)
    80203314:	85be                	mv	a1,a5
    80203316:	00003517          	auipc	a0,0x3
    8020331a:	43a50513          	addi	a0,a0,1082 # 80206750 <small_numbers+0x1530>
    8020331e:	ffffd097          	auipc	ra,0xffffd
    80203322:	27a080e7          	jalr	634(ra) # 80200598 <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    80203326:	fe843783          	ld	a5,-24(s0)
    8020332a:	639c                	ld	a5,0(a5)
    8020332c:	faf43823          	sd	a5,-80(s0)
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    80203330:	fb043783          	ld	a5,-80(s0)
    80203334:	85be                	mv	a1,a5
    80203336:	00003517          	auipc	a0,0x3
    8020333a:	44a50513          	addi	a0,a0,1098 # 80206780 <small_numbers+0x1560>
    8020333e:	ffffd097          	auipc	ra,0xffffd
    80203342:	25a080e7          	jalr	602(ra) # 80200598 <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    80203346:	00003517          	auipc	a0,0x3
    8020334a:	45250513          	addi	a0,a0,1106 # 80206798 <small_numbers+0x1578>
    8020334e:	ffffd097          	auipc	ra,0xffffd
    80203352:	24a080e7          	jalr	586(ra) # 80200598 <printf>
    80203356:	a809                	j	80203368 <test_exception+0x1aa>
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80203358:	00003517          	auipc	a0,0x3
    8020335c:	39850513          	addi	a0,a0,920 # 802066f0 <small_numbers+0x14d0>
    80203360:	ffffd097          	auipc	ra,0xffffd
    80203364:	238080e7          	jalr	568(ra) # 80200598 <printf>
    }
    
    // 4. 测试存储地址未对齐异常
    printf("4. 测试存储地址未对齐异常...\n");
    80203368:	00003517          	auipc	a0,0x3
    8020336c:	45850513          	addi	a0,a0,1112 # 802067c0 <small_numbers+0x15a0>
    80203370:	ffffd097          	auipc	ra,0xffffd
    80203374:	228080e7          	jalr	552(ra) # 80200598 <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    80203378:	fffff097          	auipc	ra,0xfffff
    8020337c:	0e4080e7          	jalr	228(ra) # 8020245c <alloc_page>
    80203380:	87aa                	mv	a5,a0
    80203382:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    80203386:	fd043783          	ld	a5,-48(s0)
    8020338a:	c3a1                	beqz	a5,802033ca <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    8020338c:	fd043783          	ld	a5,-48(s0)
    80203390:	0785                	addi	a5,a5,1 # 1001 <userret+0xf65>
    80203392:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80203396:	fc843583          	ld	a1,-56(s0)
    8020339a:	00003517          	auipc	a0,0x3
    8020339e:	45650513          	addi	a0,a0,1110 # 802067f0 <small_numbers+0x15d0>
    802033a2:	ffffd097          	auipc	ra,0xffffd
    802033a6:	1f6080e7          	jalr	502(ra) # 80200598 <printf>
        
        // 使用内联汇编进行未对齐访问，因为编译器可能会自动对齐
        asm volatile (
    802033aa:	deadc7b7          	lui	a5,0xdeadc
    802033ae:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8ce99f>
    802033b2:	fc843703          	ld	a4,-56(s0)
    802033b6:	e31c                	sd	a5,0(a4)
            "sd %0, 0(%1)"
            : 
            : "r" (0xdeadbeef), "r" (misaligned_addr)
            : "memory"
        );
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    802033b8:	00003517          	auipc	a0,0x3
    802033bc:	45850513          	addi	a0,a0,1112 # 80206810 <small_numbers+0x15f0>
    802033c0:	ffffd097          	auipc	ra,0xffffd
    802033c4:	1d8080e7          	jalr	472(ra) # 80200598 <printf>
    802033c8:	a809                	j	802033da <test_exception+0x21c>
    } else {
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    802033ca:	00003517          	auipc	a0,0x3
    802033ce:	47650513          	addi	a0,a0,1142 # 80206840 <small_numbers+0x1620>
    802033d2:	ffffd097          	auipc	ra,0xffffd
    802033d6:	1c6080e7          	jalr	454(ra) # 80200598 <printf>
    }
    
    // 5. 测试加载地址未对齐异常
    printf("5. 测试加载地址未对齐异常...\n");
    802033da:	00003517          	auipc	a0,0x3
    802033de:	4a650513          	addi	a0,a0,1190 # 80206880 <small_numbers+0x1660>
    802033e2:	ffffd097          	auipc	ra,0xffffd
    802033e6:	1b6080e7          	jalr	438(ra) # 80200598 <printf>
    if (aligned_addr != 0) {
    802033ea:	fd043783          	ld	a5,-48(s0)
    802033ee:	cbb1                	beqz	a5,80203442 <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    802033f0:	fd043783          	ld	a5,-48(s0)
    802033f4:	0785                	addi	a5,a5,1
    802033f6:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    802033fa:	fc043583          	ld	a1,-64(s0)
    802033fe:	00003517          	auipc	a0,0x3
    80203402:	3f250513          	addi	a0,a0,1010 # 802067f0 <small_numbers+0x15d0>
    80203406:	ffffd097          	auipc	ra,0xffffd
    8020340a:	192080e7          	jalr	402(ra) # 80200598 <printf>
        
        uint64 value = 0;
    8020340e:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    80203412:	fc043783          	ld	a5,-64(s0)
    80203416:	639c                	ld	a5,0(a5)
    80203418:	faf43c23          	sd	a5,-72(s0)
            "ld %0, 0(%1)"
            : "=r" (value)
            : "r" (misaligned_addr)
            : "memory"
        );
        printf("读取的值: 0x%lx\n", value);
    8020341c:	fb843583          	ld	a1,-72(s0)
    80203420:	00003517          	auipc	a0,0x3
    80203424:	49050513          	addi	a0,a0,1168 # 802068b0 <small_numbers+0x1690>
    80203428:	ffffd097          	auipc	ra,0xffffd
    8020342c:	170080e7          	jalr	368(ra) # 80200598 <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80203430:	00003517          	auipc	a0,0x3
    80203434:	49850513          	addi	a0,a0,1176 # 802068c8 <small_numbers+0x16a8>
    80203438:	ffffd097          	auipc	ra,0xffffd
    8020343c:	160080e7          	jalr	352(ra) # 80200598 <printf>
    80203440:	a809                	j	80203452 <test_exception+0x294>
    } else {
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80203442:	00003517          	auipc	a0,0x3
    80203446:	3fe50513          	addi	a0,a0,1022 # 80206840 <small_numbers+0x1620>
    8020344a:	ffffd097          	auipc	ra,0xffffd
    8020344e:	14e080e7          	jalr	334(ra) # 80200598 <printf>
    }

	// 6. 测试断点异常
	printf("6. 测试断点异常...\n");
    80203452:	00003517          	auipc	a0,0x3
    80203456:	4a650513          	addi	a0,a0,1190 # 802068f8 <small_numbers+0x16d8>
    8020345a:	ffffd097          	auipc	ra,0xffffd
    8020345e:	13e080e7          	jalr	318(ra) # 80200598 <printf>
	asm volatile (
    80203462:	0001                	nop
    80203464:	9002                	ebreak
    80203466:	0001                	nop
		"nop\n\t"      // 确保ebreak前有有效指令
		"ebreak\n\t"   // 断点指令
		"nop\n\t"      // 确保ebreak后有有效指令
	);
	printf("✓ 断点异常处理成功\n\n");
    80203468:	00003517          	auipc	a0,0x3
    8020346c:	4b050513          	addi	a0,a0,1200 # 80206918 <small_numbers+0x16f8>
    80203470:	ffffd097          	auipc	ra,0xffffd
    80203474:	128080e7          	jalr	296(ra) # 80200598 <printf>
    // 7. 测试环境调用异常
    printf("7. 测试环境调用异常...\n");
    80203478:	00003517          	auipc	a0,0x3
    8020347c:	4c050513          	addi	a0,a0,1216 # 80206938 <small_numbers+0x1718>
    80203480:	ffffd097          	auipc	ra,0xffffd
    80203484:	118080e7          	jalr	280(ra) # 80200598 <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    80203488:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    8020348c:	00003517          	auipc	a0,0x3
    80203490:	4cc50513          	addi	a0,a0,1228 # 80206958 <small_numbers+0x1738>
    80203494:	ffffd097          	auipc	ra,0xffffd
    80203498:	104080e7          	jalr	260(ra) # 80200598 <printf>
    
    printf("===== 异常处理测试完成 =====\n\n");
    8020349c:	00003517          	auipc	a0,0x3
    802034a0:	4e450513          	addi	a0,a0,1252 # 80206980 <small_numbers+0x1760>
    802034a4:	ffffd097          	auipc	ra,0xffffd
    802034a8:	0f4080e7          	jalr	244(ra) # 80200598 <printf>
}
    802034ac:	0001                	nop
    802034ae:	60a6                	ld	ra,72(sp)
    802034b0:	6406                	ld	s0,64(sp)
    802034b2:	6161                	addi	sp,sp,80
    802034b4:	8082                	ret

00000000802034b6 <write32>:
    802034b6:	7179                	addi	sp,sp,-48
    802034b8:	f406                	sd	ra,40(sp)
    802034ba:	f022                	sd	s0,32(sp)
    802034bc:	1800                	addi	s0,sp,48
    802034be:	fca43c23          	sd	a0,-40(s0)
    802034c2:	87ae                	mv	a5,a1
    802034c4:	fcf42a23          	sw	a5,-44(s0)
    802034c8:	fd843783          	ld	a5,-40(s0)
    802034cc:	8b8d                	andi	a5,a5,3
    802034ce:	eb99                	bnez	a5,802034e4 <write32+0x2e>
    802034d0:	fd843783          	ld	a5,-40(s0)
    802034d4:	fef43423          	sd	a5,-24(s0)
    802034d8:	fe843783          	ld	a5,-24(s0)
    802034dc:	fd442703          	lw	a4,-44(s0)
    802034e0:	c398                	sw	a4,0(a5)
    802034e2:	a819                	j	802034f8 <write32+0x42>
    802034e4:	fd843583          	ld	a1,-40(s0)
    802034e8:	00003517          	auipc	a0,0x3
    802034ec:	4c050513          	addi	a0,a0,1216 # 802069a8 <small_numbers+0x1788>
    802034f0:	ffffd097          	auipc	ra,0xffffd
    802034f4:	0a8080e7          	jalr	168(ra) # 80200598 <printf>
    802034f8:	0001                	nop
    802034fa:	70a2                	ld	ra,40(sp)
    802034fc:	7402                	ld	s0,32(sp)
    802034fe:	6145                	addi	sp,sp,48
    80203500:	8082                	ret

0000000080203502 <read32>:
    80203502:	7179                	addi	sp,sp,-48
    80203504:	f406                	sd	ra,40(sp)
    80203506:	f022                	sd	s0,32(sp)
    80203508:	1800                	addi	s0,sp,48
    8020350a:	fca43c23          	sd	a0,-40(s0)
    8020350e:	fd843783          	ld	a5,-40(s0)
    80203512:	8b8d                	andi	a5,a5,3
    80203514:	eb91                	bnez	a5,80203528 <read32+0x26>
    80203516:	fd843783          	ld	a5,-40(s0)
    8020351a:	fef43423          	sd	a5,-24(s0)
    8020351e:	fe843783          	ld	a5,-24(s0)
    80203522:	439c                	lw	a5,0(a5)
    80203524:	2781                	sext.w	a5,a5
    80203526:	a821                	j	8020353e <read32+0x3c>
    80203528:	fd843583          	ld	a1,-40(s0)
    8020352c:	00003517          	auipc	a0,0x3
    80203530:	4ac50513          	addi	a0,a0,1196 # 802069d8 <small_numbers+0x17b8>
    80203534:	ffffd097          	auipc	ra,0xffffd
    80203538:	064080e7          	jalr	100(ra) # 80200598 <printf>
    8020353c:	4781                	li	a5,0
    8020353e:	853e                	mv	a0,a5
    80203540:	70a2                	ld	ra,40(sp)
    80203542:	7402                	ld	s0,32(sp)
    80203544:	6145                	addi	sp,sp,48
    80203546:	8082                	ret

0000000080203548 <plic_init>:
void plic_init(void) {
    80203548:	1101                	addi	sp,sp,-32
    8020354a:	ec06                	sd	ra,24(sp)
    8020354c:	e822                	sd	s0,16(sp)
    8020354e:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80203550:	4785                	li	a5,1
    80203552:	fef42623          	sw	a5,-20(s0)
    80203556:	a805                	j	80203586 <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    80203558:	fec42783          	lw	a5,-20(s0)
    8020355c:	0027979b          	slliw	a5,a5,0x2
    80203560:	2781                	sext.w	a5,a5
    80203562:	873e                	mv	a4,a5
    80203564:	0c0007b7          	lui	a5,0xc000
    80203568:	97ba                	add	a5,a5,a4
    8020356a:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    8020356e:	4581                	li	a1,0
    80203570:	fe043503          	ld	a0,-32(s0)
    80203574:	00000097          	auipc	ra,0x0
    80203578:	f42080e7          	jalr	-190(ra) # 802034b6 <write32>
    for (int i = 1; i <= 32; i++) {
    8020357c:	fec42783          	lw	a5,-20(s0)
    80203580:	2785                	addiw	a5,a5,1 # c000001 <userret+0xbffff65>
    80203582:	fef42623          	sw	a5,-20(s0)
    80203586:	fec42783          	lw	a5,-20(s0)
    8020358a:	0007871b          	sext.w	a4,a5
    8020358e:	02000793          	li	a5,32
    80203592:	fce7d3e3          	bge	a5,a4,80203558 <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    80203596:	4585                	li	a1,1
    80203598:	0c0007b7          	lui	a5,0xc000
    8020359c:	02878513          	addi	a0,a5,40 # c000028 <userret+0xbffff8c>
    802035a0:	00000097          	auipc	ra,0x0
    802035a4:	f16080e7          	jalr	-234(ra) # 802034b6 <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    802035a8:	4585                	li	a1,1
    802035aa:	0c0007b7          	lui	a5,0xc000
    802035ae:	00478513          	addi	a0,a5,4 # c000004 <userret+0xbffff68>
    802035b2:	00000097          	auipc	ra,0x0
    802035b6:	f04080e7          	jalr	-252(ra) # 802034b6 <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    802035ba:	40200593          	li	a1,1026
    802035be:	0c0027b7          	lui	a5,0xc002
    802035c2:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    802035c6:	00000097          	auipc	ra,0x0
    802035ca:	ef0080e7          	jalr	-272(ra) # 802034b6 <write32>
    write32(PLIC_THRESHOLD, 0);
    802035ce:	4581                	li	a1,0
    802035d0:	0c201537          	lui	a0,0xc201
    802035d4:	00000097          	auipc	ra,0x0
    802035d8:	ee2080e7          	jalr	-286(ra) # 802034b6 <write32>
}
    802035dc:	0001                	nop
    802035de:	60e2                	ld	ra,24(sp)
    802035e0:	6442                	ld	s0,16(sp)
    802035e2:	6105                	addi	sp,sp,32
    802035e4:	8082                	ret

00000000802035e6 <plic_enable>:
void plic_enable(int irq) {
    802035e6:	7179                	addi	sp,sp,-48
    802035e8:	f406                	sd	ra,40(sp)
    802035ea:	f022                	sd	s0,32(sp)
    802035ec:	1800                	addi	s0,sp,48
    802035ee:	87aa                	mv	a5,a0
    802035f0:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    802035f4:	0c0027b7          	lui	a5,0xc002
    802035f8:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    802035fc:	00000097          	auipc	ra,0x0
    80203600:	f06080e7          	jalr	-250(ra) # 80203502 <read32>
    80203604:	87aa                	mv	a5,a0
    80203606:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    8020360a:	fdc42783          	lw	a5,-36(s0)
    8020360e:	873e                	mv	a4,a5
    80203610:	4785                	li	a5,1
    80203612:	00e797bb          	sllw	a5,a5,a4
    80203616:	2781                	sext.w	a5,a5
    80203618:	2781                	sext.w	a5,a5
    8020361a:	fec42703          	lw	a4,-20(s0)
    8020361e:	8fd9                	or	a5,a5,a4
    80203620:	2781                	sext.w	a5,a5
    80203622:	85be                	mv	a1,a5
    80203624:	0c0027b7          	lui	a5,0xc002
    80203628:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    8020362c:	00000097          	auipc	ra,0x0
    80203630:	e8a080e7          	jalr	-374(ra) # 802034b6 <write32>
}
    80203634:	0001                	nop
    80203636:	70a2                	ld	ra,40(sp)
    80203638:	7402                	ld	s0,32(sp)
    8020363a:	6145                	addi	sp,sp,48
    8020363c:	8082                	ret

000000008020363e <plic_disable>:
void plic_disable(int irq) {
    8020363e:	7179                	addi	sp,sp,-48
    80203640:	f406                	sd	ra,40(sp)
    80203642:	f022                	sd	s0,32(sp)
    80203644:	1800                	addi	s0,sp,48
    80203646:	87aa                	mv	a5,a0
    80203648:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    8020364c:	0c0027b7          	lui	a5,0xc002
    80203650:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203654:	00000097          	auipc	ra,0x0
    80203658:	eae080e7          	jalr	-338(ra) # 80203502 <read32>
    8020365c:	87aa                	mv	a5,a0
    8020365e:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    80203662:	fdc42783          	lw	a5,-36(s0)
    80203666:	873e                	mv	a4,a5
    80203668:	4785                	li	a5,1
    8020366a:	00e797bb          	sllw	a5,a5,a4
    8020366e:	2781                	sext.w	a5,a5
    80203670:	fff7c793          	not	a5,a5
    80203674:	2781                	sext.w	a5,a5
    80203676:	2781                	sext.w	a5,a5
    80203678:	fec42703          	lw	a4,-20(s0)
    8020367c:	8ff9                	and	a5,a5,a4
    8020367e:	2781                	sext.w	a5,a5
    80203680:	85be                	mv	a1,a5
    80203682:	0c0027b7          	lui	a5,0xc002
    80203686:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    8020368a:	00000097          	auipc	ra,0x0
    8020368e:	e2c080e7          	jalr	-468(ra) # 802034b6 <write32>
}
    80203692:	0001                	nop
    80203694:	70a2                	ld	ra,40(sp)
    80203696:	7402                	ld	s0,32(sp)
    80203698:	6145                	addi	sp,sp,48
    8020369a:	8082                	ret

000000008020369c <plic_claim>:
int plic_claim(void) {
    8020369c:	1141                	addi	sp,sp,-16
    8020369e:	e406                	sd	ra,8(sp)
    802036a0:	e022                	sd	s0,0(sp)
    802036a2:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    802036a4:	0c2017b7          	lui	a5,0xc201
    802036a8:	00478513          	addi	a0,a5,4 # c201004 <userret+0xc200f68>
    802036ac:	00000097          	auipc	ra,0x0
    802036b0:	e56080e7          	jalr	-426(ra) # 80203502 <read32>
    802036b4:	87aa                	mv	a5,a0
    802036b6:	2781                	sext.w	a5,a5
    802036b8:	2781                	sext.w	a5,a5
}
    802036ba:	853e                	mv	a0,a5
    802036bc:	60a2                	ld	ra,8(sp)
    802036be:	6402                	ld	s0,0(sp)
    802036c0:	0141                	addi	sp,sp,16
    802036c2:	8082                	ret

00000000802036c4 <plic_complete>:
void plic_complete(int irq) {
    802036c4:	1101                	addi	sp,sp,-32
    802036c6:	ec06                	sd	ra,24(sp)
    802036c8:	e822                	sd	s0,16(sp)
    802036ca:	1000                	addi	s0,sp,32
    802036cc:	87aa                	mv	a5,a0
    802036ce:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    802036d2:	fec42783          	lw	a5,-20(s0)
    802036d6:	85be                	mv	a1,a5
    802036d8:	0c2017b7          	lui	a5,0xc201
    802036dc:	00478513          	addi	a0,a5,4 # c201004 <userret+0xc200f68>
    802036e0:	00000097          	auipc	ra,0x0
    802036e4:	dd6080e7          	jalr	-554(ra) # 802034b6 <write32>
    802036e8:	0001                	nop
    802036ea:	60e2                	ld	ra,24(sp)
    802036ec:	6442                	ld	s0,16(sp)
    802036ee:	6105                	addi	sp,sp,32
    802036f0:	8082                	ret
	...

0000000080203700 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80203700:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80203702:	e006                	sd	ra,0(sp)
        # 注意：不保存sp，因为我们已经修改了它
        sd gp, 16(sp)
    80203704:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80203706:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80203708:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8020370a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8020370c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    8020370e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80203710:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80203712:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80203714:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80203716:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80203718:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    8020371a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    8020371c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8020371e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80203720:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80203722:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80203724:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80203726:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80203728:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    8020372a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    8020372c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    8020372e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80203730:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80203732:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80203734:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80203736:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80203738:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    8020373a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    8020373c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    8020373e:	fffff097          	auipc	ra,0xfffff
    80203742:	3dc080e7          	jalr	988(ra) # 80202b1a <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80203746:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80203748:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8020374a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8020374c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    8020374e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80203750:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80203752:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80203754:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80203756:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80203758:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8020375a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8020375c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8020375e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80203760:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80203762:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80203764:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80203766:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80203768:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    8020376a:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    8020376c:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    8020376e:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80203770:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80203772:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80203774:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80203776:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80203778:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    8020377a:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    8020377c:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8020377e:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80203780:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80203782:	10200073          	sret
    80203786:	0001                	nop
    80203788:	00000013          	nop
    8020378c:	00000013          	nop

0000000080203790 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80203790:	00153023          	sd	ra,0(a0) # c201000 <userret+0xc200f64>
        sd sp, 8(a0)
    80203794:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80203798:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8020379a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8020379c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    802037a0:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    802037a4:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    802037a8:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    802037ac:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    802037b0:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    802037b4:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    802037b8:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    802037bc:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    802037c0:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    802037c4:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    802037c8:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    802037cc:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    802037ce:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    802037d0:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    802037d4:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    802037d8:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    802037dc:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    802037e0:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    802037e4:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    802037e8:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    802037ec:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    802037f0:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    802037f4:	0685bd83          	ld	s11,104(a1)
        
        ret
    802037f8:	8082                	ret

00000000802037fa <r_sstatus>:

struct proc* myproc(void) {
    return current_proc;
}
// 添加CPU初始化函数
void init_cpu(void) {
    802037fa:	1101                	addi	sp,sp,-32
    802037fc:	ec22                	sd	s0,24(sp)
    802037fe:	1000                	addi	s0,sp,32
    // 假设只有一个CPU
    static struct cpu cpu_instance;
    80203800:	100027f3          	csrr	a5,sstatus
    80203804:	fef43423          	sd	a5,-24(s0)
    // 初始化CPU结构体
    80203808:	fe843783          	ld	a5,-24(s0)
    memset(&cpu_instance, 0, sizeof(struct cpu));
    8020380c:	853e                	mv	a0,a5
    8020380e:	6462                	ld	s0,24(sp)
    80203810:	6105                	addi	sp,sp,32
    80203812:	8082                	ret

0000000080203814 <w_sstatus>:
    current_cpu = &cpu_instance;
    80203814:	1101                	addi	sp,sp,-32
    80203816:	ec22                	sd	s0,24(sp)
    80203818:	1000                	addi	s0,sp,32
    8020381a:	fea43423          	sd	a0,-24(s0)
    printf("CPU initialized: %p\n", current_cpu);
    8020381e:	fe843783          	ld	a5,-24(s0)
    80203822:	10079073          	csrw	sstatus,a5
}
    80203826:	0001                	nop
    80203828:	6462                	ld	s0,24(sp)
    8020382a:	6105                	addi	sp,sp,32
    8020382c:	8082                	ret

000000008020382e <intr_on>:
    if (current_cpu == 0) {
        printf("WARNING: current_cpu is NULL, initializing...\n");
        init_cpu();
    }
    return current_cpu;
}
    8020382e:	1141                	addi	sp,sp,-16
    80203830:	e406                	sd	ra,8(sp)
    80203832:	e022                	sd	s0,0(sp)
    80203834:	0800                	addi	s0,sp,16

    80203836:	00000097          	auipc	ra,0x0
    8020383a:	fc4080e7          	jalr	-60(ra) # 802037fa <r_sstatus>
    8020383e:	87aa                	mv	a5,a0
    80203840:	0027e793          	ori	a5,a5,2
    80203844:	853e                	mv	a0,a5
    80203846:	00000097          	auipc	ra,0x0
    8020384a:	fce080e7          	jalr	-50(ra) # 80203814 <w_sstatus>
void return_to_user(void){
    8020384e:	0001                	nop
    80203850:	60a2                	ld	ra,8(sp)
    80203852:	6402                	ld	s0,0(sp)
    80203854:	0141                	addi	sp,sp,16
    80203856:	8082                	ret

0000000080203858 <intr_off>:
    struct proc *p = myproc();
    if (p == 0) {
    80203858:	1141                	addi	sp,sp,-16
    8020385a:	e406                	sd	ra,8(sp)
    8020385c:	e022                	sd	s0,0(sp)
    8020385e:	0800                	addi	s0,sp,16
        panic("return_to_user: no current process");
    80203860:	00000097          	auipc	ra,0x0
    80203864:	f9a080e7          	jalr	-102(ra) # 802037fa <r_sstatus>
    80203868:	87aa                	mv	a5,a0
    8020386a:	9bf5                	andi	a5,a5,-3
    8020386c:	853e                	mv	a0,a5
    8020386e:	00000097          	auipc	ra,0x0
    80203872:	fa6080e7          	jalr	-90(ra) # 80203814 <w_sstatus>
    }
    80203876:	0001                	nop
    80203878:	60a2                	ld	ra,8(sp)
    8020387a:	6402                	ld	s0,0(sp)
    8020387c:	0141                	addi	sp,sp,16
    8020387e:	8082                	ret

0000000080203880 <w_stvec>:
    
    printf("return_to_user: 进程 %d 尝试返回用户态\n", p->pid);
    
    80203880:	1101                	addi	sp,sp,-32
    80203882:	ec22                	sd	s0,24(sp)
    80203884:	1000                	addi	s0,sp,32
    80203886:	fea43423          	sd	a0,-24(s0)
    // 检测是否在测试模式
    8020388a:	fe843783          	ld	a5,-24(s0)
    8020388e:	10579073          	csrw	stvec,a5
    if (p->trapframe->kernel_satp == 0) {
    80203892:	0001                	nop
    80203894:	6462                	ld	s0,24(sp)
    80203896:	6105                	addi	sp,sp,32
    80203898:	8082                	ret

000000008020389a <myproc>:
struct proc* myproc(void) {
    8020389a:	1141                	addi	sp,sp,-16
    8020389c:	e422                	sd	s0,8(sp)
    8020389e:	0800                	addi	s0,sp,16
    return current_proc;
    802038a0:	00006797          	auipc	a5,0x6
    802038a4:	79078793          	addi	a5,a5,1936 # 8020a030 <current_proc>
    802038a8:	639c                	ld	a5,0(a5)
}
    802038aa:	853e                	mv	a0,a5
    802038ac:	6422                	ld	s0,8(sp)
    802038ae:	0141                	addi	sp,sp,16
    802038b0:	8082                	ret

00000000802038b2 <init_cpu>:
void init_cpu(void) {
    802038b2:	1141                	addi	sp,sp,-16
    802038b4:	e406                	sd	ra,8(sp)
    802038b6:	e022                	sd	s0,0(sp)
    802038b8:	0800                	addi	s0,sp,16
    memset(&cpu_instance, 0, sizeof(struct cpu));
    802038ba:	07800613          	li	a2,120
    802038be:	4581                	li	a1,0
    802038c0:	0000a517          	auipc	a0,0xa
    802038c4:	c1050513          	addi	a0,a0,-1008 # 8020d4d0 <cpu_instance.1>
    802038c8:	ffffe097          	auipc	ra,0xffffe
    802038cc:	ca8080e7          	jalr	-856(ra) # 80201570 <memset>
    current_cpu = &cpu_instance;
    802038d0:	00006797          	auipc	a5,0x6
    802038d4:	76878793          	addi	a5,a5,1896 # 8020a038 <current_cpu>
    802038d8:	0000a717          	auipc	a4,0xa
    802038dc:	bf870713          	addi	a4,a4,-1032 # 8020d4d0 <cpu_instance.1>
    802038e0:	e398                	sd	a4,0(a5)
    printf("CPU initialized: %p\n", current_cpu);
    802038e2:	00006797          	auipc	a5,0x6
    802038e6:	75678793          	addi	a5,a5,1878 # 8020a038 <current_cpu>
    802038ea:	639c                	ld	a5,0(a5)
    802038ec:	85be                	mv	a1,a5
    802038ee:	00003517          	auipc	a0,0x3
    802038f2:	11a50513          	addi	a0,a0,282 # 80206a08 <small_numbers+0x17e8>
    802038f6:	ffffd097          	auipc	ra,0xffffd
    802038fa:	ca2080e7          	jalr	-862(ra) # 80200598 <printf>
}
    802038fe:	0001                	nop
    80203900:	60a2                	ld	ra,8(sp)
    80203902:	6402                	ld	s0,0(sp)
    80203904:	0141                	addi	sp,sp,16
    80203906:	8082                	ret

0000000080203908 <mycpu>:
struct cpu* mycpu(void) {
    80203908:	1141                	addi	sp,sp,-16
    8020390a:	e406                	sd	ra,8(sp)
    8020390c:	e022                	sd	s0,0(sp)
    8020390e:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80203910:	00006797          	auipc	a5,0x6
    80203914:	72878793          	addi	a5,a5,1832 # 8020a038 <current_cpu>
    80203918:	639c                	ld	a5,0(a5)
    8020391a:	ef89                	bnez	a5,80203934 <mycpu+0x2c>
        printf("WARNING: current_cpu is NULL, initializing...\n");
    8020391c:	00003517          	auipc	a0,0x3
    80203920:	10450513          	addi	a0,a0,260 # 80206a20 <small_numbers+0x1800>
    80203924:	ffffd097          	auipc	ra,0xffffd
    80203928:	c74080e7          	jalr	-908(ra) # 80200598 <printf>
        init_cpu();
    8020392c:	00000097          	auipc	ra,0x0
    80203930:	f86080e7          	jalr	-122(ra) # 802038b2 <init_cpu>
    return current_cpu;
    80203934:	00006797          	auipc	a5,0x6
    80203938:	70478793          	addi	a5,a5,1796 # 8020a038 <current_cpu>
    8020393c:	639c                	ld	a5,0(a5)
}
    8020393e:	853e                	mv	a0,a5
    80203940:	60a2                	ld	ra,8(sp)
    80203942:	6402                	ld	s0,0(sp)
    80203944:	0141                	addi	sp,sp,16
    80203946:	8082                	ret

0000000080203948 <return_to_user>:
void return_to_user(void){
    80203948:	7179                	addi	sp,sp,-48
    8020394a:	f406                	sd	ra,40(sp)
    8020394c:	f022                	sd	s0,32(sp)
    8020394e:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80203950:	00000097          	auipc	ra,0x0
    80203954:	f4a080e7          	jalr	-182(ra) # 8020389a <myproc>
    80203958:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    8020395c:	fe843783          	ld	a5,-24(s0)
    80203960:	eb89                	bnez	a5,80203972 <return_to_user+0x2a>
        panic("return_to_user: no current process");
    80203962:	00003517          	auipc	a0,0x3
    80203966:	0ee50513          	addi	a0,a0,238 # 80206a50 <small_numbers+0x1830>
    8020396a:	ffffd097          	auipc	ra,0xffffd
    8020396e:	536080e7          	jalr	1334(ra) # 80200ea0 <panic>
    printf("return_to_user: 进程 %d 尝试返回用户态\n", p->pid);
    80203972:	fe843783          	ld	a5,-24(s0)
    80203976:	4f9c                	lw	a5,24(a5)
    80203978:	85be                	mv	a1,a5
    8020397a:	00003517          	auipc	a0,0x3
    8020397e:	0fe50513          	addi	a0,a0,254 # 80206a78 <small_numbers+0x1858>
    80203982:	ffffd097          	auipc	ra,0xffffd
    80203986:	c16080e7          	jalr	-1002(ra) # 80200598 <printf>
    if (p->trapframe->kernel_satp == 0) {
    8020398a:	fe843783          	ld	a5,-24(s0)
    8020398e:	63bc                	ld	a5,64(a5)
    80203990:	639c                	ld	a5,0(a5)
    80203992:	e3a9                	bnez	a5,802039d4 <return_to_user+0x8c>
        printf("return_to_user: 在测试模式下，不返回用户态\n");
    80203994:	00003517          	auipc	a0,0x3
    80203998:	11c50513          	addi	a0,a0,284 # 80206ab0 <small_numbers+0x1890>
    8020399c:	ffffd097          	auipc	ra,0xffffd
    802039a0:	bfc080e7          	jalr	-1028(ra) # 80200598 <printf>
        printf("设置进程为RUNNABLE并调度\n");
    802039a4:	00003517          	auipc	a0,0x3
    802039a8:	14c50513          	addi	a0,a0,332 # 80206af0 <small_numbers+0x18d0>
    802039ac:	ffffd097          	auipc	ra,0xffffd
    802039b0:	bec080e7          	jalr	-1044(ra) # 80200598 <printf>
        p->state = RUNNABLE;
    802039b4:	fe843783          	ld	a5,-24(s0)
    802039b8:	470d                	li	a4,3
    802039ba:	c398                	sw	a4,0(a5)
        schedule();
    802039bc:	00000097          	auipc	ra,0x0
    802039c0:	6f2080e7          	jalr	1778(ra) # 802040ae <schedule>
        panic("return_to_user should not return");
    802039c4:	00003517          	auipc	a0,0x3
    802039c8:	15450513          	addi	a0,a0,340 # 80206b18 <small_numbers+0x18f8>
    802039cc:	ffffd097          	auipc	ra,0xffffd
    802039d0:	4d4080e7          	jalr	1236(ra) # 80200ea0 <panic>
    }
    
    // 正常的用户态返回逻辑
    w_stvec(TRAMPOLINE);
    802039d4:	080007b7          	lui	a5,0x8000
    802039d8:	17fd                	addi	a5,a5,-1 # 7ffffff <userret+0x7ffff63>
    802039da:	00c79513          	slli	a0,a5,0xc
    802039de:	00000097          	auipc	ra,0x0
    802039e2:	ea2080e7          	jalr	-350(ra) # 80203880 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    802039e6:	00000737          	lui	a4,0x0
    802039ea:	09c70713          	addi	a4,a4,156 # 9c <userret>
    802039ee:	000007b7          	lui	a5,0x0
    802039f2:	00078793          	mv	a5,a5
    802039f6:	8f1d                	sub	a4,a4,a5
    802039f8:	080007b7          	lui	a5,0x8000
    802039fc:	17fd                	addi	a5,a5,-1 # 7ffffff <userret+0x7ffff63>
    802039fe:	07b2                	slli	a5,a5,0xc
    80203a00:	97ba                	add	a5,a5,a4
    80203a02:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    80203a06:	fe843783          	ld	a5,-24(s0)
    80203a0a:	7f9c                	ld	a5,56(a5)
    80203a0c:	00c7d713          	srli	a4,a5,0xc
    80203a10:	57fd                	li	a5,-1
    80203a12:	17fe                	slli	a5,a5,0x3f
    80203a14:	8fd9                	or	a5,a5,a4
    80203a16:	fcf43c23          	sd	a5,-40(s0)
    ((void(*)(uint64))trampoline_userret)(satp);
    80203a1a:	fe043783          	ld	a5,-32(s0)
    80203a1e:	fd843503          	ld	a0,-40(s0)
    80203a22:	9782                	jalr	a5
}
    80203a24:	0001                	nop
    80203a26:	70a2                	ld	ra,40(sp)
    80203a28:	7402                	ld	s0,32(sp)
    80203a2a:	6145                	addi	sp,sp,48
    80203a2c:	8082                	ret

0000000080203a2e <forkret>:
void forkret(void){
    80203a2e:	1101                	addi	sp,sp,-32
    80203a30:	ec06                	sd	ra,24(sp)
    80203a32:	e822                	sd	s0,16(sp)
    80203a34:	1000                	addi	s0,sp,32
    // 检查栈指针是否有效
    uint64 sp_val;
    asm volatile("mv %0, sp" : "=r"(sp_val));
    80203a36:	878a                	mv	a5,sp
    80203a38:	fef43423          	sd	a5,-24(s0)
    printf("forkret: 进入函数，当前sp=%p\n", (void*)sp_val);
    80203a3c:	fe843783          	ld	a5,-24(s0)
    80203a40:	85be                	mv	a1,a5
    80203a42:	00003517          	auipc	a0,0x3
    80203a46:	0fe50513          	addi	a0,a0,254 # 80206b40 <small_numbers+0x1920>
    80203a4a:	ffffd097          	auipc	ra,0xffffd
    80203a4e:	b4e080e7          	jalr	-1202(ra) # 80200598 <printf>
    
    struct proc *p = myproc();
    80203a52:	00000097          	auipc	ra,0x0
    80203a56:	e48080e7          	jalr	-440(ra) # 8020389a <myproc>
    80203a5a:	fea43023          	sd	a0,-32(s0)
    if (p == 0) {
    80203a5e:	fe043783          	ld	a5,-32(s0)
    80203a62:	eb89                	bnez	a5,80203a74 <forkret+0x46>
        panic("forkret: no current process");
    80203a64:	00003517          	auipc	a0,0x3
    80203a68:	10450513          	addi	a0,a0,260 # 80206b68 <small_numbers+0x1948>
    80203a6c:	ffffd097          	auipc	ra,0xffffd
    80203a70:	434080e7          	jalr	1076(ra) # 80200ea0 <panic>
    }
    
    printf("forkret: 进程 %d (状态 %d), 栈范围 [%p, %p]\n", 
    80203a74:	fe043783          	ld	a5,-32(s0)
    80203a78:	4f8c                	lw	a1,24(a5)
           p->pid, p->state, (void*)p->kstack, (void*)(p->kstack + PGSIZE));
    80203a7a:	fe043783          	ld	a5,-32(s0)
    80203a7e:	4390                	lw	a2,0(a5)
    80203a80:	fe043783          	ld	a5,-32(s0)
    80203a84:	779c                	ld	a5,40(a5)
    printf("forkret: 进程 %d (状态 %d), 栈范围 [%p, %p]\n", 
    80203a86:	86be                	mv	a3,a5
           p->pid, p->state, (void*)p->kstack, (void*)(p->kstack + PGSIZE));
    80203a88:	fe043783          	ld	a5,-32(s0)
    80203a8c:	7798                	ld	a4,40(a5)
    80203a8e:	6785                	lui	a5,0x1
    80203a90:	97ba                	add	a5,a5,a4
    printf("forkret: 进程 %d (状态 %d), 栈范围 [%p, %p]\n", 
    80203a92:	873e                	mv	a4,a5
    80203a94:	00003517          	auipc	a0,0x3
    80203a98:	0f450513          	addi	a0,a0,244 # 80206b88 <small_numbers+0x1968>
    80203a9c:	ffffd097          	auipc	ra,0xffffd
    80203aa0:	afc080e7          	jalr	-1284(ra) # 80200598 <printf>
    
    // 验证栈地址
    if (sp_val < p->kstack || sp_val >= p->kstack + PGSIZE) {
    80203aa4:	fe043783          	ld	a5,-32(s0)
    80203aa8:	779c                	ld	a5,40(a5)
    80203aaa:	fe843703          	ld	a4,-24(s0)
    80203aae:	00f76b63          	bltu	a4,a5,80203ac4 <forkret+0x96>
    80203ab2:	fe043783          	ld	a5,-32(s0)
    80203ab6:	7798                	ld	a4,40(a5)
    80203ab8:	6785                	lui	a5,0x1
    80203aba:	97ba                	add	a5,a5,a4
    80203abc:	fe843703          	ld	a4,-24(s0)
    80203ac0:	02f76e63          	bltu	a4,a5,80203afc <forkret+0xce>
        printf("错误: 栈指针 %p 不在有效范围 [%p, %p]\n",
    80203ac4:	fe843583          	ld	a1,-24(s0)
               (void*)sp_val, (void*)p->kstack, (void*)(p->kstack + PGSIZE));
    80203ac8:	fe043783          	ld	a5,-32(s0)
    80203acc:	779c                	ld	a5,40(a5)
        printf("错误: 栈指针 %p 不在有效范围 [%p, %p]\n",
    80203ace:	863e                	mv	a2,a5
               (void*)sp_val, (void*)p->kstack, (void*)(p->kstack + PGSIZE));
    80203ad0:	fe043783          	ld	a5,-32(s0)
    80203ad4:	7798                	ld	a4,40(a5)
    80203ad6:	6785                	lui	a5,0x1
    80203ad8:	97ba                	add	a5,a5,a4
        printf("错误: 栈指针 %p 不在有效范围 [%p, %p]\n",
    80203ada:	86be                	mv	a3,a5
    80203adc:	00003517          	auipc	a0,0x3
    80203ae0:	0e450513          	addi	a0,a0,228 # 80206bc0 <small_numbers+0x19a0>
    80203ae4:	ffffd097          	auipc	ra,0xffffd
    80203ae8:	ab4080e7          	jalr	-1356(ra) # 80200598 <printf>
        panic("forkret: 无效的栈指针");
    80203aec:	00003517          	auipc	a0,0x3
    80203af0:	10c50513          	addi	a0,a0,268 # 80206bf8 <small_numbers+0x19d8>
    80203af4:	ffffd097          	auipc	ra,0xffffd
    80203af8:	3ac080e7          	jalr	940(ra) # 80200ea0 <panic>
    }
    
    // 其余代码不变...
    if (p->trapframe == 0) {
    80203afc:	fe043783          	ld	a5,-32(s0)
    80203b00:	63bc                	ld	a5,64(a5)
    80203b02:	eb8d                	bnez	a5,80203b34 <forkret+0x106>
        printf("forkret: trapframe为NULL，设为RUNNABLE并调度\n");
    80203b04:	00003517          	auipc	a0,0x3
    80203b08:	11450513          	addi	a0,a0,276 # 80206c18 <small_numbers+0x19f8>
    80203b0c:	ffffd097          	auipc	ra,0xffffd
    80203b10:	a8c080e7          	jalr	-1396(ra) # 80200598 <printf>
        p->state = RUNNABLE;
    80203b14:	fe043783          	ld	a5,-32(s0)
    80203b18:	470d                	li	a4,3
    80203b1a:	c398                	sw	a4,0(a5)
        schedule();
    80203b1c:	00000097          	auipc	ra,0x0
    80203b20:	592080e7          	jalr	1426(ra) # 802040ae <schedule>
        panic("forkret should not return after schedule");
    80203b24:	00003517          	auipc	a0,0x3
    80203b28:	12c50513          	addi	a0,a0,300 # 80206c50 <small_numbers+0x1a30>
    80203b2c:	ffffd097          	auipc	ra,0xffffd
    80203b30:	374080e7          	jalr	884(ra) # 80200ea0 <panic>
    }
    
    // 如果是simple_task测试进程，不调用return_to_user
    if (p->trapframe->epc == (uint64)simple_task) {
    80203b34:	fe043783          	ld	a5,-32(s0)
    80203b38:	63bc                	ld	a5,64(a5)
    80203b3a:	6f98                	ld	a4,24(a5)
    80203b3c:	00001797          	auipc	a5,0x1
    80203b40:	c0878793          	addi	a5,a5,-1016 # 80204744 <simple_task>
    80203b44:	04f71763          	bne	a4,a5,80203b92 <forkret+0x164>
        printf("forkret: 检测到测试进程，执行simple_task\n");
    80203b48:	00003517          	auipc	a0,0x3
    80203b4c:	13850513          	addi	a0,a0,312 # 80206c80 <small_numbers+0x1a60>
    80203b50:	ffffd097          	auipc	ra,0xffffd
    80203b54:	a48080e7          	jalr	-1464(ra) # 80200598 <printf>
        // 直接调用函数而不是通过return_to_user
        ((void(*)())p->trapframe->epc)();
    80203b58:	fe043783          	ld	a5,-32(s0)
    80203b5c:	63bc                	ld	a5,64(a5)
    80203b5e:	6f9c                	ld	a5,24(a5)
    80203b60:	9782                	jalr	a5
        printf("forkret: simple_task返回，调度新进程\n");
    80203b62:	00003517          	auipc	a0,0x3
    80203b66:	15650513          	addi	a0,a0,342 # 80206cb8 <small_numbers+0x1a98>
    80203b6a:	ffffd097          	auipc	ra,0xffffd
    80203b6e:	a2e080e7          	jalr	-1490(ra) # 80200598 <printf>
        p->state = ZOMBIE;
    80203b72:	fe043783          	ld	a5,-32(s0)
    80203b76:	4715                	li	a4,5
    80203b78:	c398                	sw	a4,0(a5)
        schedule();
    80203b7a:	00000097          	auipc	ra,0x0
    80203b7e:	534080e7          	jalr	1332(ra) # 802040ae <schedule>
        panic("forkret should not return");
    80203b82:	00003517          	auipc	a0,0x3
    80203b86:	16650513          	addi	a0,a0,358 # 80206ce8 <small_numbers+0x1ac8>
    80203b8a:	ffffd097          	auipc	ra,0xffffd
    80203b8e:	316080e7          	jalr	790(ra) # 80200ea0 <panic>
    }
    
    printf("forkret: 调用return_to_user\n");
    80203b92:	00003517          	auipc	a0,0x3
    80203b96:	17650513          	addi	a0,a0,374 # 80206d08 <small_numbers+0x1ae8>
    80203b9a:	ffffd097          	auipc	ra,0xffffd
    80203b9e:	9fe080e7          	jalr	-1538(ra) # 80200598 <printf>
    return_to_user();
    80203ba2:	00000097          	auipc	ra,0x0
    80203ba6:	da6080e7          	jalr	-602(ra) # 80203948 <return_to_user>
}
    80203baa:	0001                	nop
    80203bac:	60e2                	ld	ra,24(sp)
    80203bae:	6442                	ld	s0,16(sp)
    80203bb0:	6105                	addi	sp,sp,32
    80203bb2:	8082                	ret

0000000080203bb4 <init_proc>:
void init_proc(void){
    80203bb4:	1101                	addi	sp,sp,-32
    80203bb6:	ec22                	sd	s0,24(sp)
    80203bb8:	1000                	addi	s0,sp,32
    for(int i=0; i<PROC; i++){
    80203bba:	fe042623          	sw	zero,-20(s0)
    80203bbe:	a0b9                	j	80203c0c <init_proc+0x58>
        struct proc *p = &proc_table[i];
    80203bc0:	fec42703          	lw	a4,-20(s0)
    80203bc4:	0c800793          	li	a5,200
    80203bc8:	02f70733          	mul	a4,a4,a5
    80203bcc:	00006797          	auipc	a5,0x6
    80203bd0:	70478793          	addi	a5,a5,1796 # 8020a2d0 <proc_table>
    80203bd4:	97ba                	add	a5,a5,a4
    80203bd6:	fef43023          	sd	a5,-32(s0)
        p->state = UNUSED;
    80203bda:	fe043783          	ld	a5,-32(s0)
    80203bde:	0007a023          	sw	zero,0(a5)
        p->pid = 0;
    80203be2:	fe043783          	ld	a5,-32(s0)
    80203be6:	0007ac23          	sw	zero,24(a5)
        p->kstack = 0;  // 不预先设置栈地址，而是在 alloc_proc 中分配
    80203bea:	fe043783          	ld	a5,-32(s0)
    80203bee:	0207b423          	sd	zero,40(a5)
        p->parent = 0;
    80203bf2:	fe043783          	ld	a5,-32(s0)
    80203bf6:	0207b023          	sd	zero,32(a5)
        p->chan = 0;
    80203bfa:	fe043783          	ld	a5,-32(s0)
    80203bfe:	0007b423          	sd	zero,8(a5)
    for(int i=0; i<PROC; i++){
    80203c02:	fec42783          	lw	a5,-20(s0)
    80203c06:	2785                	addiw	a5,a5,1
    80203c08:	fef42623          	sw	a5,-20(s0)
    80203c0c:	fec42783          	lw	a5,-20(s0)
    80203c10:	0007871b          	sext.w	a4,a5
    80203c14:	03f00793          	li	a5,63
    80203c18:	fae7d4e3          	bge	a5,a4,80203bc0 <init_proc+0xc>
    }
}
    80203c1c:	0001                	nop
    80203c1e:	0001                	nop
    80203c20:	6462                	ld	s0,24(sp)
    80203c22:	6105                	addi	sp,sp,32
    80203c24:	8082                	ret

0000000080203c26 <alloc_proc>:
struct proc* alloc_proc(void) {
    80203c26:	1101                	addi	sp,sp,-32
    80203c28:	ec06                	sd	ra,24(sp)
    80203c2a:	e822                	sd	s0,16(sp)
    80203c2c:	1000                	addi	s0,sp,32
    struct proc *p;
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    80203c2e:	00006797          	auipc	a5,0x6
    80203c32:	6a278793          	addi	a5,a5,1698 # 8020a2d0 <proc_table>
    80203c36:	fef43423          	sd	a5,-24(s0)
    80203c3a:	aa61                	j	80203dd2 <alloc_proc+0x1ac>
        if(p->state == UNUSED) {
    80203c3c:	fe843783          	ld	a5,-24(s0)
    80203c40:	439c                	lw	a5,0(a5)
    80203c42:	18079263          	bnez	a5,80203dc6 <alloc_proc+0x1a0>
            p->pid = nextpid++;
    80203c46:	00004797          	auipc	a5,0x4
    80203c4a:	3ba78793          	addi	a5,a5,954 # 80208000 <nextpid>
    80203c4e:	439c                	lw	a5,0(a5)
    80203c50:	0017871b          	addiw	a4,a5,1
    80203c54:	0007069b          	sext.w	a3,a4
    80203c58:	00004717          	auipc	a4,0x4
    80203c5c:	3a870713          	addi	a4,a4,936 # 80208000 <nextpid>
    80203c60:	c314                	sw	a3,0(a4)
    80203c62:	fe843703          	ld	a4,-24(s0)
    80203c66:	cf1c                	sw	a5,24(a4)
            p->state = USED;
    80203c68:	fe843783          	ld	a5,-24(s0)
    80203c6c:	4705                	li	a4,1
    80203c6e:	c398                	sw	a4,0(a5)

            // 分配 trapframe
            p->trapframe = (struct trapframe*)alloc_page();
    80203c70:	ffffe097          	auipc	ra,0xffffe
    80203c74:	7ec080e7          	jalr	2028(ra) # 8020245c <alloc_page>
    80203c78:	872a                	mv	a4,a0
    80203c7a:	fe843783          	ld	a5,-24(s0)
    80203c7e:	e3b8                	sd	a4,64(a5)
            if(p->trapframe == 0){
    80203c80:	fe843783          	ld	a5,-24(s0)
    80203c84:	63bc                	ld	a5,64(a5)
    80203c86:	eb99                	bnez	a5,80203c9c <alloc_proc+0x76>
                p->state = UNUSED;
    80203c88:	fe843783          	ld	a5,-24(s0)
    80203c8c:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80203c90:	fe843783          	ld	a5,-24(s0)
    80203c94:	0007ac23          	sw	zero,24(a5)
                return 0;
    80203c98:	4781                	li	a5,0
    80203c9a:	a2a9                	j	80203de4 <alloc_proc+0x1be>
            }

            // 分配页表
            p->pagetable = create_pagetable();
    80203c9c:	ffffe097          	auipc	ra,0xffffe
    80203ca0:	aca080e7          	jalr	-1334(ra) # 80201766 <create_pagetable>
    80203ca4:	872a                	mv	a4,a0
    80203ca6:	fe843783          	ld	a5,-24(s0)
    80203caa:	ff98                	sd	a4,56(a5)
            if(p->pagetable == 0){
    80203cac:	fe843783          	ld	a5,-24(s0)
    80203cb0:	7f9c                	ld	a5,56(a5)
    80203cb2:	e79d                	bnez	a5,80203ce0 <alloc_proc+0xba>
                free_page(p->trapframe);
    80203cb4:	fe843783          	ld	a5,-24(s0)
    80203cb8:	63bc                	ld	a5,64(a5)
    80203cba:	853e                	mv	a0,a5
    80203cbc:	fffff097          	auipc	ra,0xfffff
    80203cc0:	80c080e7          	jalr	-2036(ra) # 802024c8 <free_page>
                p->trapframe = 0;
    80203cc4:	fe843783          	ld	a5,-24(s0)
    80203cc8:	0407b023          	sd	zero,64(a5)
                p->state = UNUSED;
    80203ccc:	fe843783          	ld	a5,-24(s0)
    80203cd0:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80203cd4:	fe843783          	ld	a5,-24(s0)
    80203cd8:	0007ac23          	sw	zero,24(a5)
                return 0;
    80203cdc:	4781                	li	a5,0
    80203cde:	a219                	j	80203de4 <alloc_proc+0x1be>
            }
            
            // 分配实际内核栈（关键修复）
            void *kstack_mem = alloc_page();
    80203ce0:	ffffe097          	auipc	ra,0xffffe
    80203ce4:	77c080e7          	jalr	1916(ra) # 8020245c <alloc_page>
    80203ce8:	fea43023          	sd	a0,-32(s0)
            if(kstack_mem == 0) {
    80203cec:	fe043783          	ld	a5,-32(s0)
    80203cf0:	e3b9                	bnez	a5,80203d36 <alloc_proc+0x110>
                free_page(p->trapframe);
    80203cf2:	fe843783          	ld	a5,-24(s0)
    80203cf6:	63bc                	ld	a5,64(a5)
    80203cf8:	853e                	mv	a0,a5
    80203cfa:	ffffe097          	auipc	ra,0xffffe
    80203cfe:	7ce080e7          	jalr	1998(ra) # 802024c8 <free_page>
                free_pagetable(p->pagetable);
    80203d02:	fe843783          	ld	a5,-24(s0)
    80203d06:	7f9c                	ld	a5,56(a5)
    80203d08:	853e                	mv	a0,a5
    80203d0a:	ffffe097          	auipc	ra,0xffffe
    80203d0e:	d0a080e7          	jalr	-758(ra) # 80201a14 <free_pagetable>
                p->trapframe = 0;
    80203d12:	fe843783          	ld	a5,-24(s0)
    80203d16:	0407b023          	sd	zero,64(a5)
                p->pagetable = 0;
    80203d1a:	fe843783          	ld	a5,-24(s0)
    80203d1e:	0207bc23          	sd	zero,56(a5)
                p->state = UNUSED;
    80203d22:	fe843783          	ld	a5,-24(s0)
    80203d26:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80203d2a:	fe843783          	ld	a5,-24(s0)
    80203d2e:	0007ac23          	sw	zero,24(a5)
                return 0;
    80203d32:	4781                	li	a5,0
    80203d34:	a845                	j	80203de4 <alloc_proc+0x1be>
            }
            
            p->kstack = (uint64)kstack_mem;
    80203d36:	fe043703          	ld	a4,-32(s0)
    80203d3a:	fe843783          	ld	a5,-24(s0)
    80203d3e:	f798                	sd	a4,40(a5)
            printf("分配进程 %d 内核栈: %p\n", p->pid, (void*)p->kstack);
    80203d40:	fe843783          	ld	a5,-24(s0)
    80203d44:	4f98                	lw	a4,24(a5)
    80203d46:	fe843783          	ld	a5,-24(s0)
    80203d4a:	779c                	ld	a5,40(a5)
    80203d4c:	863e                	mv	a2,a5
    80203d4e:	85ba                	mv	a1,a4
    80203d50:	00003517          	auipc	a0,0x3
    80203d54:	fd850513          	addi	a0,a0,-40 # 80206d28 <small_numbers+0x1b08>
    80203d58:	ffffd097          	auipc	ra,0xffffd
    80203d5c:	840080e7          	jalr	-1984(ra) # 80200598 <printf>

            // 初始化上下文
            memset(&p->context, 0, sizeof(p->context));
    80203d60:	fe843783          	ld	a5,-24(s0)
    80203d64:	04878793          	addi	a5,a5,72
    80203d68:	07000613          	li	a2,112
    80203d6c:	4581                	li	a1,0
    80203d6e:	853e                	mv	a0,a5
    80203d70:	ffffe097          	auipc	ra,0xffffe
    80203d74:	800080e7          	jalr	-2048(ra) # 80201570 <memset>
            p->context.ra = (uint64)forkret;
    80203d78:	00000717          	auipc	a4,0x0
    80203d7c:	cb670713          	addi	a4,a4,-842 # 80203a2e <forkret>
    80203d80:	fe843783          	ld	a5,-24(s0)
    80203d84:	e7b8                	sd	a4,72(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    80203d86:	fe843783          	ld	a5,-24(s0)
    80203d8a:	7798                	ld	a4,40(a5)
    80203d8c:	6785                	lui	a5,0x1
    80203d8e:	17c1                	addi	a5,a5,-16 # ff0 <userret+0xf54>
    80203d90:	973e                	add	a4,a4,a5
    80203d92:	fe843783          	ld	a5,-24(s0)
    80203d96:	ebb8                	sd	a4,80(a5)
            printf("初始化进程 %d 上下文: ra=%p, sp=%p\n",
    80203d98:	fe843783          	ld	a5,-24(s0)
    80203d9c:	4f98                	lw	a4,24(a5)
                   p->pid, (void*)p->context.ra, (void*)p->context.sp);
    80203d9e:	fe843783          	ld	a5,-24(s0)
    80203da2:	67bc                	ld	a5,72(a5)
            printf("初始化进程 %d 上下文: ra=%p, sp=%p\n",
    80203da4:	863e                	mv	a2,a5
                   p->pid, (void*)p->context.ra, (void*)p->context.sp);
    80203da6:	fe843783          	ld	a5,-24(s0)
    80203daa:	6bbc                	ld	a5,80(a5)
            printf("初始化进程 %d 上下文: ra=%p, sp=%p\n",
    80203dac:	86be                	mv	a3,a5
    80203dae:	85ba                	mv	a1,a4
    80203db0:	00003517          	auipc	a0,0x3
    80203db4:	f9850513          	addi	a0,a0,-104 # 80206d48 <small_numbers+0x1b28>
    80203db8:	ffffc097          	auipc	ra,0xffffc
    80203dbc:	7e0080e7          	jalr	2016(ra) # 80200598 <printf>
                   
            return p;
    80203dc0:	fe843783          	ld	a5,-24(s0)
    80203dc4:	a005                	j	80203de4 <alloc_proc+0x1be>
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    80203dc6:	fe843783          	ld	a5,-24(s0)
    80203dca:	0c878793          	addi	a5,a5,200
    80203dce:	fef43423          	sd	a5,-24(s0)
    80203dd2:	fe843703          	ld	a4,-24(s0)
    80203dd6:	00009797          	auipc	a5,0x9
    80203dda:	6fa78793          	addi	a5,a5,1786 # 8020d4d0 <cpu_instance.1>
    80203dde:	e4f76fe3          	bltu	a4,a5,80203c3c <alloc_proc+0x16>
        }
    }
    return 0;
    80203de2:	4781                	li	a5,0
}
    80203de4:	853e                	mv	a0,a5
    80203de6:	60e2                	ld	ra,24(sp)
    80203de8:	6442                	ld	s0,16(sp)
    80203dea:	6105                	addi	sp,sp,32
    80203dec:	8082                	ret

0000000080203dee <free_proc>:

void free_proc(struct proc *p){
    80203dee:	1101                	addi	sp,sp,-32
    80203df0:	ec06                	sd	ra,24(sp)
    80203df2:	e822                	sd	s0,16(sp)
    80203df4:	1000                	addi	s0,sp,32
    80203df6:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    80203dfa:	fe843783          	ld	a5,-24(s0)
    80203dfe:	63bc                	ld	a5,64(a5)
    80203e00:	cb89                	beqz	a5,80203e12 <free_proc+0x24>
        free_page(p->trapframe);
    80203e02:	fe843783          	ld	a5,-24(s0)
    80203e06:	63bc                	ld	a5,64(a5)
    80203e08:	853e                	mv	a0,a5
    80203e0a:	ffffe097          	auipc	ra,0xffffe
    80203e0e:	6be080e7          	jalr	1726(ra) # 802024c8 <free_page>
    p->trapframe = 0;
    80203e12:	fe843783          	ld	a5,-24(s0)
    80203e16:	0407b023          	sd	zero,64(a5)
    
    if(p->pagetable)
    80203e1a:	fe843783          	ld	a5,-24(s0)
    80203e1e:	7f9c                	ld	a5,56(a5)
    80203e20:	cb89                	beqz	a5,80203e32 <free_proc+0x44>
        free_pagetable(p->pagetable);
    80203e22:	fe843783          	ld	a5,-24(s0)
    80203e26:	7f9c                	ld	a5,56(a5)
    80203e28:	853e                	mv	a0,a5
    80203e2a:	ffffe097          	auipc	ra,0xffffe
    80203e2e:	bea080e7          	jalr	-1046(ra) # 80201a14 <free_pagetable>
    p->pagetable = 0;
    80203e32:	fe843783          	ld	a5,-24(s0)
    80203e36:	0207bc23          	sd	zero,56(a5)
    
    // 释放内核栈（如果存在）
    if(p->kstack)
    80203e3a:	fe843783          	ld	a5,-24(s0)
    80203e3e:	779c                	ld	a5,40(a5)
    80203e40:	cb89                	beqz	a5,80203e52 <free_proc+0x64>
        free_page((void*)p->kstack);
    80203e42:	fe843783          	ld	a5,-24(s0)
    80203e46:	779c                	ld	a5,40(a5)
    80203e48:	853e                	mv	a0,a5
    80203e4a:	ffffe097          	auipc	ra,0xffffe
    80203e4e:	67e080e7          	jalr	1662(ra) # 802024c8 <free_page>
    p->kstack = 0;
    80203e52:	fe843783          	ld	a5,-24(s0)
    80203e56:	0207b423          	sd	zero,40(a5)
    
    p->pid = 0;
    80203e5a:	fe843783          	ld	a5,-24(s0)
    80203e5e:	0007ac23          	sw	zero,24(a5)
    p->state = UNUSED;
    80203e62:	fe843783          	ld	a5,-24(s0)
    80203e66:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    80203e6a:	fe843783          	ld	a5,-24(s0)
    80203e6e:	0207b023          	sd	zero,32(a5)
    p->chan = 0;
    80203e72:	fe843783          	ld	a5,-24(s0)
    80203e76:	0007b423          	sd	zero,8(a5)
}
    80203e7a:	0001                	nop
    80203e7c:	60e2                	ld	ra,24(sp)
    80203e7e:	6442                	ld	s0,16(sp)
    80203e80:	6105                	addi	sp,sp,32
    80203e82:	8082                	ret

0000000080203e84 <create_proc>:
int create_proc(void (*entry)(void)) {
    80203e84:	7179                	addi	sp,sp,-48
    80203e86:	f406                	sd	ra,40(sp)
    80203e88:	f022                	sd	s0,32(sp)
    80203e8a:	1800                	addi	s0,sp,48
    80203e8c:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc();
    80203e90:	00000097          	auipc	ra,0x0
    80203e94:	d96080e7          	jalr	-618(ra) # 80203c26 <alloc_proc>
    80203e98:	fea43423          	sd	a0,-24(s0)
    if (!p)
    80203e9c:	fe843783          	ld	a5,-24(s0)
    80203ea0:	e399                	bnez	a5,80203ea6 <create_proc+0x22>
        return -1;
    80203ea2:	57fd                	li	a5,-1
    80203ea4:	a889                	j	80203ef6 <create_proc+0x72>
    
    p->trapframe->epc = (uint64)entry;
    80203ea6:	fe843783          	ld	a5,-24(s0)
    80203eaa:	63bc                	ld	a5,64(a5)
    80203eac:	fd843703          	ld	a4,-40(s0)
    80203eb0:	ef98                	sd	a4,24(a5)
    p->state = RUNNABLE;
    80203eb2:	fe843783          	ld	a5,-24(s0)
    80203eb6:	470d                	li	a4,3
    80203eb8:	c398                	sw	a4,0(a5)
    
    // 安全地设置父进程
    struct proc *parent = myproc();
    80203eba:	00000097          	auipc	ra,0x0
    80203ebe:	9e0080e7          	jalr	-1568(ra) # 8020389a <myproc>
    80203ec2:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    80203ec6:	fe043783          	ld	a5,-32(s0)
    80203eca:	c799                	beqz	a5,80203ed8 <create_proc+0x54>
        p->parent = parent;
    80203ecc:	fe843783          	ld	a5,-24(s0)
    80203ed0:	fe043703          	ld	a4,-32(s0)
    80203ed4:	f398                	sd	a4,32(a5)
    80203ed6:	a829                	j	80203ef0 <create_proc+0x6c>
    } else {
        printf("Warning: creating process with no parent\n");
    80203ed8:	00003517          	auipc	a0,0x3
    80203edc:	ea050513          	addi	a0,a0,-352 # 80206d78 <small_numbers+0x1b58>
    80203ee0:	ffffc097          	auipc	ra,0xffffc
    80203ee4:	6b8080e7          	jalr	1720(ra) # 80200598 <printf>
        p->parent = 0;
    80203ee8:	fe843783          	ld	a5,-24(s0)
    80203eec:	0207b023          	sd	zero,32(a5)
    }
    
    return p->pid;
    80203ef0:	fe843783          	ld	a5,-24(s0)
    80203ef4:	4f9c                	lw	a5,24(a5)
}
    80203ef6:	853e                	mv	a0,a5
    80203ef8:	70a2                	ld	ra,40(sp)
    80203efa:	7402                	ld	s0,32(sp)
    80203efc:	6145                	addi	sp,sp,48
    80203efe:	8082                	ret

0000000080203f00 <exit_proc>:
void exit_proc(int status) {
    80203f00:	7179                	addi	sp,sp,-48
    80203f02:	f406                	sd	ra,40(sp)
    80203f04:	f022                	sd	s0,32(sp)
    80203f06:	1800                	addi	s0,sp,48
    80203f08:	87aa                	mv	a5,a0
    80203f0a:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    80203f0e:	00000097          	auipc	ra,0x0
    80203f12:	98c080e7          	jalr	-1652(ra) # 8020389a <myproc>
    80203f16:	fea43423          	sd	a0,-24(s0)
    p->exit_status = status;
    80203f1a:	fe843783          	ld	a5,-24(s0)
    80203f1e:	fdc42703          	lw	a4,-36(s0)
    80203f22:	cbd8                	sw	a4,20(a5)
    kexit();
    80203f24:	00000097          	auipc	ra,0x0
    80203f28:	4fe080e7          	jalr	1278(ra) # 80204422 <kexit>
}
    80203f2c:	0001                	nop
    80203f2e:	70a2                	ld	ra,40(sp)
    80203f30:	7402                	ld	s0,32(sp)
    80203f32:	6145                	addi	sp,sp,48
    80203f34:	8082                	ret

0000000080203f36 <wait_proc>:

int wait_proc(int *status) {
    80203f36:	1101                	addi	sp,sp,-32
    80203f38:	ec06                	sd	ra,24(sp)
    80203f3a:	e822                	sd	s0,16(sp)
    80203f3c:	1000                	addi	s0,sp,32
    80203f3e:	fea43423          	sd	a0,-24(s0)
	printf("wait_proc called\n");
    80203f42:	00003517          	auipc	a0,0x3
    80203f46:	e6650513          	addi	a0,a0,-410 # 80206da8 <small_numbers+0x1b88>
    80203f4a:	ffffc097          	auipc	ra,0xffffc
    80203f4e:	64e080e7          	jalr	1614(ra) # 80200598 <printf>
    return kwait(status);
    80203f52:	fe843503          	ld	a0,-24(s0)
    80203f56:	00000097          	auipc	ra,0x0
    80203f5a:	61c080e7          	jalr	1564(ra) # 80204572 <kwait>
    80203f5e:	87aa                	mv	a5,a0
}
    80203f60:	853e                	mv	a0,a5
    80203f62:	60e2                	ld	ra,24(sp)
    80203f64:	6442                	ld	s0,16(sp)
    80203f66:	6105                	addi	sp,sp,32
    80203f68:	8082                	ret

0000000080203f6a <kfork>:
int kfork(void) {
    80203f6a:	1101                	addi	sp,sp,-32
    80203f6c:	ec06                	sd	ra,24(sp)
    80203f6e:	e822                	sd	s0,16(sp)
    80203f70:	1000                	addi	s0,sp,32
    struct proc *parent = myproc();
    80203f72:	00000097          	auipc	ra,0x0
    80203f76:	928080e7          	jalr	-1752(ra) # 8020389a <myproc>
    80203f7a:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc();
    80203f7e:	00000097          	auipc	ra,0x0
    80203f82:	ca8080e7          	jalr	-856(ra) # 80203c26 <alloc_proc>
    80203f86:	fea43023          	sd	a0,-32(s0)
    if(child == 0)
    80203f8a:	fe043783          	ld	a5,-32(s0)
    80203f8e:	e399                	bnez	a5,80203f94 <kfork+0x2a>
        return -1;
    80203f90:	57fd                	li	a5,-1
    80203f92:	a059                	j	80204018 <kfork+0xae>

    if(uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0){
    80203f94:	fe843783          	ld	a5,-24(s0)
    80203f98:	7f98                	ld	a4,56(a5)
    80203f9a:	fe043783          	ld	a5,-32(s0)
    80203f9e:	7f94                	ld	a3,56(a5)
    80203fa0:	fe843783          	ld	a5,-24(s0)
    80203fa4:	7b9c                	ld	a5,48(a5)
    80203fa6:	863e                	mv	a2,a5
    80203fa8:	85b6                	mv	a1,a3
    80203faa:	853a                	mv	a0,a4
    80203fac:	ffffe097          	auipc	ra,0xffffe
    80203fb0:	30a080e7          	jalr	778(ra) # 802022b6 <uvmcopy>
    80203fb4:	87aa                	mv	a5,a0
    80203fb6:	0007da63          	bgez	a5,80203fca <kfork+0x60>
        free_proc(child);
    80203fba:	fe043503          	ld	a0,-32(s0)
    80203fbe:	00000097          	auipc	ra,0x0
    80203fc2:	e30080e7          	jalr	-464(ra) # 80203dee <free_proc>
        return -1;
    80203fc6:	57fd                	li	a5,-1
    80203fc8:	a881                	j	80204018 <kfork+0xae>
    }
    child->sz = parent->sz;
    80203fca:	fe843783          	ld	a5,-24(s0)
    80203fce:	7b98                	ld	a4,48(a5)
    80203fd0:	fe043783          	ld	a5,-32(s0)
    80203fd4:	fb98                	sd	a4,48(a5)

    *(child->trapframe) = *(parent->trapframe);
    80203fd6:	fe843783          	ld	a5,-24(s0)
    80203fda:	63b8                	ld	a4,64(a5)
    80203fdc:	fe043783          	ld	a5,-32(s0)
    80203fe0:	63bc                	ld	a5,64(a5)
    80203fe2:	86be                	mv	a3,a5
    80203fe4:	12000793          	li	a5,288
    80203fe8:	863e                	mv	a2,a5
    80203fea:	85ba                	mv	a1,a4
    80203fec:	8536                	mv	a0,a3
    80203fee:	ffffd097          	auipc	ra,0xffffd
    80203ff2:	68e080e7          	jalr	1678(ra) # 8020167c <memcpy>
    child->trapframe->a0 = 0; // 子进程fork返回值为0
    80203ff6:	fe043783          	ld	a5,-32(s0)
    80203ffa:	63bc                	ld	a5,64(a5)
    80203ffc:	0607b823          	sd	zero,112(a5)
    child->state = RUNNABLE;
    80204000:	fe043783          	ld	a5,-32(s0)
    80204004:	470d                	li	a4,3
    80204006:	c398                	sw	a4,0(a5)
    child->parent = parent;
    80204008:	fe043783          	ld	a5,-32(s0)
    8020400c:	fe843703          	ld	a4,-24(s0)
    80204010:	f398                	sd	a4,32(a5)
    return child->pid;
    80204012:	fe043783          	ld	a5,-32(s0)
    80204016:	4f9c                	lw	a5,24(a5)
}
    80204018:	853e                	mv	a0,a5
    8020401a:	60e2                	ld	ra,24(sp)
    8020401c:	6442                	ld	s0,16(sp)
    8020401e:	6105                	addi	sp,sp,32
    80204020:	8082                	ret

0000000080204022 <print_context>:
void print_context(struct context *ctx, char *name) {
    80204022:	1101                	addi	sp,sp,-32
    80204024:	ec06                	sd	ra,24(sp)
    80204026:	e822                	sd	s0,16(sp)
    80204028:	1000                	addi	s0,sp,32
    8020402a:	fea43423          	sd	a0,-24(s0)
    8020402e:	feb43023          	sd	a1,-32(s0)
    printf("%s: ra=%p, sp=%p", name, (void*)ctx->ra, (void*)ctx->sp);
    80204032:	fe843783          	ld	a5,-24(s0)
    80204036:	639c                	ld	a5,0(a5)
    80204038:	873e                	mv	a4,a5
    8020403a:	fe843783          	ld	a5,-24(s0)
    8020403e:	679c                	ld	a5,8(a5)
    80204040:	86be                	mv	a3,a5
    80204042:	863a                	mv	a2,a4
    80204044:	fe043583          	ld	a1,-32(s0)
    80204048:	00003517          	auipc	a0,0x3
    8020404c:	d7850513          	addi	a0,a0,-648 # 80206dc0 <small_numbers+0x1ba0>
    80204050:	ffffc097          	auipc	ra,0xffffc
    80204054:	548080e7          	jalr	1352(ra) # 80200598 <printf>
    printf(", s0=%p, s1=%p\n", (void*)ctx->s0, (void*)ctx->s1);
    80204058:	fe843783          	ld	a5,-24(s0)
    8020405c:	6b9c                	ld	a5,16(a5)
    8020405e:	873e                	mv	a4,a5
    80204060:	fe843783          	ld	a5,-24(s0)
    80204064:	6f9c                	ld	a5,24(a5)
    80204066:	863e                	mv	a2,a5
    80204068:	85ba                	mv	a1,a4
    8020406a:	00003517          	auipc	a0,0x3
    8020406e:	d6e50513          	addi	a0,a0,-658 # 80206dd8 <small_numbers+0x1bb8>
    80204072:	ffffc097          	auipc	ra,0xffffc
    80204076:	526080e7          	jalr	1318(ra) # 80200598 <printf>
    // 可以根据实际结构体定义添加更多字段
}
    8020407a:	0001                	nop
    8020407c:	60e2                	ld	ra,24(sp)
    8020407e:	6442                	ld	s0,16(sp)
    80204080:	6105                	addi	sp,sp,32
    80204082:	8082                	ret

0000000080204084 <scheduler_ret>:

// 添加一个辅助函数，作为CPU上下文的返回点
void scheduler_ret(void) {
    80204084:	1141                	addi	sp,sp,-16
    80204086:	e406                	sd	ra,8(sp)
    80204088:	e022                	sd	s0,0(sp)
    8020408a:	0800                	addi	s0,sp,16
    printf("返回到调度器\n");
    8020408c:	00003517          	auipc	a0,0x3
    80204090:	d5c50513          	addi	a0,a0,-676 # 80206de8 <small_numbers+0x1bc8>
    80204094:	ffffc097          	auipc	ra,0xffffc
    80204098:	504080e7          	jalr	1284(ra) # 80200598 <printf>
    schedule();  // 继续调度
    8020409c:	00000097          	auipc	ra,0x0
    802040a0:	012080e7          	jalr	18(ra) # 802040ae <schedule>
}
    802040a4:	0001                	nop
    802040a6:	60a2                	ld	ra,8(sp)
    802040a8:	6402                	ld	s0,0(sp)
    802040aa:	0141                	addi	sp,sp,16
    802040ac:	8082                	ret

00000000802040ae <schedule>:
void schedule(void){
    802040ae:	7179                	addi	sp,sp,-48
    802040b0:	f406                	sd	ra,40(sp)
    802040b2:	f022                	sd	s0,32(sp)
    802040b4:	1800                	addi	s0,sp,48
    struct proc *p;
    struct cpu *c = mycpu();
    802040b6:	00000097          	auipc	ra,0x0
    802040ba:	852080e7          	jalr	-1966(ra) # 80203908 <mycpu>
    802040be:	fca43c23          	sd	a0,-40(s0)
    
    if (c == 0) {
    802040c2:	fd843783          	ld	a5,-40(s0)
    802040c6:	eb89                	bnez	a5,802040d8 <schedule+0x2a>
        panic("schedule: mycpu() returned NULL");
    802040c8:	00003517          	auipc	a0,0x3
    802040cc:	d3850513          	addi	a0,a0,-712 # 80206e00 <small_numbers+0x1be0>
    802040d0:	ffffd097          	auipc	ra,0xffffd
    802040d4:	dd0080e7          	jalr	-560(ra) # 80200ea0 <panic>
    }
    
    // 添加防御性检查
    printf("Schedule: CPU=%p, current proc=%p\n", c, c->proc);
    802040d8:	fd843783          	ld	a5,-40(s0)
    802040dc:	639c                	ld	a5,0(a5)
    802040de:	863e                	mv	a2,a5
    802040e0:	fd843583          	ld	a1,-40(s0)
    802040e4:	00003517          	auipc	a0,0x3
    802040e8:	d3c50513          	addi	a0,a0,-708 # 80206e20 <small_numbers+0x1c00>
    802040ec:	ffffc097          	auipc	ra,0xffffc
    802040f0:	4ac080e7          	jalr	1196(ra) # 80200598 <printf>
        // 初始化CPU上下文返回地址 - 关键修复
    if (c->context.ra == 0) {
    802040f4:	fd843783          	ld	a5,-40(s0)
    802040f8:	679c                	ld	a5,8(a5)
    802040fa:	e3a1                	bnez	a5,8020413a <schedule+0x8c>
        c->context.ra = (uint64)scheduler_ret;  // 指向一个辅助函数
    802040fc:	00000717          	auipc	a4,0x0
    80204100:	f8870713          	addi	a4,a4,-120 # 80204084 <scheduler_ret>
    80204104:	fd843783          	ld	a5,-40(s0)
    80204108:	e798                	sd	a4,8(a5)
        c->context.sp = (uint64)c + PGSIZE;     // 为CPU上下文分配栈空间
    8020410a:	fd843703          	ld	a4,-40(s0)
    8020410e:	6785                	lui	a5,0x1
    80204110:	973e                	add	a4,a4,a5
    80204112:	fd843783          	ld	a5,-40(s0)
    80204116:	eb98                	sd	a4,16(a5)
        printf("初始化CPU上下文: ra=%p, sp=%p\n", (void*)c->context.ra, (void*)c->context.sp);
    80204118:	fd843783          	ld	a5,-40(s0)
    8020411c:	679c                	ld	a5,8(a5)
    8020411e:	873e                	mv	a4,a5
    80204120:	fd843783          	ld	a5,-40(s0)
    80204124:	6b9c                	ld	a5,16(a5)
    80204126:	863e                	mv	a2,a5
    80204128:	85ba                	mv	a1,a4
    8020412a:	00003517          	auipc	a0,0x3
    8020412e:	d1e50513          	addi	a0,a0,-738 # 80206e48 <small_numbers+0x1c28>
    80204132:	ffffc097          	auipc	ra,0xffffc
    80204136:	466080e7          	jalr	1126(ra) # 80200598 <printf>
    }
    c->proc = 0;
    8020413a:	fd843783          	ld	a5,-40(s0)
    8020413e:	0007b023          	sd	zero,0(a5) # 1000 <userret+0xf64>
    
    while(1){
        intr_on();
    80204142:	fffff097          	auipc	ra,0xfffff
    80204146:	6ec080e7          	jalr	1772(ra) # 8020382e <intr_on>
        
        // 查找可运行的进程
        for(p = proc_table; p < &proc_table[PROC]; p++){
    8020414a:	00006797          	auipc	a5,0x6
    8020414e:	18678793          	addi	a5,a5,390 # 8020a2d0 <proc_table>
    80204152:	fef43423          	sd	a5,-24(s0)
    80204156:	a0cd                	j	80204238 <schedule+0x18a>
            if(p->state == RUNNABLE){
    80204158:	fe843783          	ld	a5,-24(s0)
    8020415c:	439c                	lw	a5,0(a5)
    8020415e:	873e                	mv	a4,a5
    80204160:	478d                	li	a5,3
    80204162:	0cf71563          	bne	a4,a5,8020422c <schedule+0x17e>
                // 添加安全检查
                if (p->trapframe == 0) {
    80204166:	fe843783          	ld	a5,-24(s0)
    8020416a:	63bc                	ld	a5,64(a5)
    8020416c:	e395                	bnez	a5,80204190 <schedule+0xe2>
                    printf("ERROR: Found RUNNABLE process %d with NULL trapframe\n", p->pid);
    8020416e:	fe843783          	ld	a5,-24(s0)
    80204172:	4f9c                	lw	a5,24(a5)
    80204174:	85be                	mv	a1,a5
    80204176:	00003517          	auipc	a0,0x3
    8020417a:	cfa50513          	addi	a0,a0,-774 # 80206e70 <small_numbers+0x1c50>
    8020417e:	ffffc097          	auipc	ra,0xffffc
    80204182:	41a080e7          	jalr	1050(ra) # 80200598 <printf>
                    p->state = UNUSED;
    80204186:	fe843783          	ld	a5,-24(s0)
    8020418a:	0007a023          	sw	zero,0(a5)
                    continue;
    8020418e:	a879                	j	8020422c <schedule+0x17e>
                }
                
                printf("Scheduling process %d\n", p->pid);
    80204190:	fe843783          	ld	a5,-24(s0)
    80204194:	4f9c                	lw	a5,24(a5)
    80204196:	85be                	mv	a1,a5
    80204198:	00003517          	auipc	a0,0x3
    8020419c:	d1050513          	addi	a0,a0,-752 # 80206ea8 <small_numbers+0x1c88>
    802041a0:	ffffc097          	auipc	ra,0xffffc
    802041a4:	3f8080e7          	jalr	1016(ra) # 80200598 <printf>
                p->state = RUNNING;
    802041a8:	fe843783          	ld	a5,-24(s0)
    802041ac:	4711                	li	a4,4
    802041ae:	c398                	sw	a4,0(a5)
                c->proc = p;
    802041b0:	fd843783          	ld	a5,-40(s0)
    802041b4:	fe843703          	ld	a4,-24(s0)
    802041b8:	e398                	sd	a4,0(a5)
                current_proc = p;
    802041ba:	00006797          	auipc	a5,0x6
    802041be:	e7678793          	addi	a5,a5,-394 # 8020a030 <current_proc>
    802041c2:	fe843703          	ld	a4,-24(s0)
    802041c6:	e398                	sd	a4,0(a5)
                
				// 进程上下文切换前打印信息
				print_context(&c->context, "CPU上下文");
    802041c8:	fd843783          	ld	a5,-40(s0)
    802041cc:	07a1                	addi	a5,a5,8
    802041ce:	00003597          	auipc	a1,0x3
    802041d2:	cf258593          	addi	a1,a1,-782 # 80206ec0 <small_numbers+0x1ca0>
    802041d6:	853e                	mv	a0,a5
    802041d8:	00000097          	auipc	ra,0x0
    802041dc:	e4a080e7          	jalr	-438(ra) # 80204022 <print_context>
				print_context(&p->context, "进程上下文");
    802041e0:	fe843783          	ld	a5,-24(s0)
    802041e4:	04878793          	addi	a5,a5,72
    802041e8:	00003597          	auipc	a1,0x3
    802041ec:	ce858593          	addi	a1,a1,-792 # 80206ed0 <small_numbers+0x1cb0>
    802041f0:	853e                	mv	a0,a5
    802041f2:	00000097          	auipc	ra,0x0
    802041f6:	e30080e7          	jalr	-464(ra) # 80204022 <print_context>
				swtch(&c->context, &p->context);
    802041fa:	fd843783          	ld	a5,-40(s0)
    802041fe:	00878713          	addi	a4,a5,8
    80204202:	fe843783          	ld	a5,-24(s0)
    80204206:	04878793          	addi	a5,a5,72
    8020420a:	85be                	mv	a1,a5
    8020420c:	853a                	mv	a0,a4
    8020420e:	fffff097          	auipc	ra,0xfffff
    80204212:	582080e7          	jalr	1410(ra) # 80203790 <swtch>
                
                // 切换回来后
                current_proc = 0;
    80204216:	00006797          	auipc	a5,0x6
    8020421a:	e1a78793          	addi	a5,a5,-486 # 8020a030 <current_proc>
    8020421e:	0007b023          	sd	zero,0(a5)
                c->proc = 0;
    80204222:	fd843783          	ld	a5,-40(s0)
    80204226:	0007b023          	sd	zero,0(a5)
                break;
    8020422a:	a839                	j	80204248 <schedule+0x19a>
        for(p = proc_table; p < &proc_table[PROC]; p++){
    8020422c:	fe843783          	ld	a5,-24(s0)
    80204230:	0c878793          	addi	a5,a5,200
    80204234:	fef43423          	sd	a5,-24(s0)
    80204238:	fe843703          	ld	a4,-24(s0)
    8020423c:	00009797          	auipc	a5,0x9
    80204240:	29478793          	addi	a5,a5,660 # 8020d4d0 <cpu_instance.1>
    80204244:	f0f76ae3          	bltu	a4,a5,80204158 <schedule+0xaa>
            }
        }
        
        // 如果没有可运行的进程，就暂停一下
        if (p >= &proc_table[PROC]) {
    80204248:	fe843703          	ld	a4,-24(s0)
    8020424c:	00009797          	auipc	a5,0x9
    80204250:	28478793          	addi	a5,a5,644 # 8020d4d0 <cpu_instance.1>
    80204254:	eef767e3          	bltu	a4,a5,80204142 <schedule+0x94>
            printf("No RUNNABLE processes, waiting...\n");
    80204258:	00003517          	auipc	a0,0x3
    8020425c:	c8850513          	addi	a0,a0,-888 # 80206ee0 <small_numbers+0x1cc0>
    80204260:	ffffc097          	auipc	ra,0xffffc
    80204264:	338080e7          	jalr	824(ra) # 80200598 <printf>
            // 可以添加一个简单的延迟
            for (int i = 0; i < 1000000; i++) {
    80204268:	fe042223          	sw	zero,-28(s0)
    8020426c:	a039                	j	8020427a <schedule+0x1cc>
                asm volatile("nop");
    8020426e:	0001                	nop
            for (int i = 0; i < 1000000; i++) {
    80204270:	fe442783          	lw	a5,-28(s0)
    80204274:	2785                	addiw	a5,a5,1
    80204276:	fef42223          	sw	a5,-28(s0)
    8020427a:	fe442783          	lw	a5,-28(s0)
    8020427e:	0007871b          	sext.w	a4,a5
    80204282:	000f47b7          	lui	a5,0xf4
    80204286:	23f78793          	addi	a5,a5,575 # f423f <userret+0xf41a3>
    8020428a:	fee7d2e3          	bge	a5,a4,8020426e <schedule+0x1c0>
        intr_on();
    8020428e:	bd55                	j	80204142 <schedule+0x94>

0000000080204290 <sleep>:
            }
        }
    }
}
void sleep(void *chan, int (*cond)(void*), void *arg) {
    80204290:	7139                	addi	sp,sp,-64
    80204292:	fc06                	sd	ra,56(sp)
    80204294:	f822                	sd	s0,48(sp)
    80204296:	0080                	addi	s0,sp,64
    80204298:	fca43c23          	sd	a0,-40(s0)
    8020429c:	fcb43823          	sd	a1,-48(s0)
    802042a0:	fcc43423          	sd	a2,-56(s0)
    struct proc *p = myproc();
    802042a4:	fffff097          	auipc	ra,0xfffff
    802042a8:	5f6080e7          	jalr	1526(ra) # 8020389a <myproc>
    802042ac:	fea43423          	sd	a0,-24(s0)
    if(p == 0){
    802042b0:	fe843783          	ld	a5,-24(s0)
    802042b4:	eb89                	bnez	a5,802042c6 <sleep+0x36>
        panic("scheduler want to sleep! \n");
    802042b6:	00003517          	auipc	a0,0x3
    802042ba:	c5250513          	addi	a0,a0,-942 # 80206f08 <small_numbers+0x1ce8>
    802042be:	ffffd097          	auipc	ra,0xffffd
    802042c2:	be2080e7          	jalr	-1054(ra) # 80200ea0 <panic>
    }
    
    // 打印更多调试信息
    printf("Process %d going to sleep on channel %p\n", p->pid, chan);
    802042c6:	fe843783          	ld	a5,-24(s0)
    802042ca:	4f9c                	lw	a5,24(a5)
    802042cc:	fd843603          	ld	a2,-40(s0)
    802042d0:	85be                	mv	a1,a5
    802042d2:	00003517          	auipc	a0,0x3
    802042d6:	c5650513          	addi	a0,a0,-938 # 80206f28 <small_numbers+0x1d08>
    802042da:	ffffc097          	auipc	ra,0xffffc
    802042de:	2be080e7          	jalr	702(ra) # 80200598 <printf>
    
    intr_off();
    802042e2:	fffff097          	auipc	ra,0xfffff
    802042e6:	576080e7          	jalr	1398(ra) # 80203858 <intr_off>
    // 如果条件不满足，则睡眠
    if(cond == 0 || !cond(arg)) {
    802042ea:	fd043783          	ld	a5,-48(s0)
    802042ee:	cb81                	beqz	a5,802042fe <sleep+0x6e>
    802042f0:	fd043783          	ld	a5,-48(s0)
    802042f4:	fc843503          	ld	a0,-56(s0)
    802042f8:	9782                	jalr	a5
    802042fa:	87aa                	mv	a5,a0
    802042fc:	e39d                	bnez	a5,80204322 <sleep+0x92>
        p->chan = chan;
    802042fe:	fe843783          	ld	a5,-24(s0)
    80204302:	fd843703          	ld	a4,-40(s0)
    80204306:	e798                	sd	a4,8(a5)
        p->state = SLEEPING;
    80204308:	fe843783          	ld	a5,-24(s0)
    8020430c:	4709                	li	a4,2
    8020430e:	c398                	sw	a4,0(a5)
        schedule();
    80204310:	00000097          	auipc	ra,0x0
    80204314:	d9e080e7          	jalr	-610(ra) # 802040ae <schedule>
        p->chan = 0;
    80204318:	fe843783          	ld	a5,-24(s0)
    8020431c:	0007b423          	sd	zero,8(a5)
    80204320:	a031                	j	8020432c <sleep+0x9c>
    }else{
        intr_on();
    80204322:	fffff097          	auipc	ra,0xfffff
    80204326:	50c080e7          	jalr	1292(ra) # 8020382e <intr_on>
    }
}
    8020432a:	0001                	nop
    8020432c:	0001                	nop
    8020432e:	70e2                	ld	ra,56(sp)
    80204330:	7442                	ld	s0,48(sp)
    80204332:	6121                	addi	sp,sp,64
    80204334:	8082                	ret

0000000080204336 <wakeup>:

void wakeup(void *chan, int wake_all) {
    80204336:	7179                	addi	sp,sp,-48
    80204338:	f406                	sd	ra,40(sp)
    8020433a:	f022                	sd	s0,32(sp)
    8020433c:	1800                	addi	s0,sp,48
    8020433e:	fca43c23          	sd	a0,-40(s0)
    80204342:	87ae                	mv	a5,a1
    80204344:	fcf42a23          	sw	a5,-44(s0)
    // 打印更多调试信息
    printf("Waking up processes on channel %p\n", chan);
    80204348:	fd843583          	ld	a1,-40(s0)
    8020434c:	00003517          	auipc	a0,0x3
    80204350:	c0c50513          	addi	a0,a0,-1012 # 80206f58 <small_numbers+0x1d38>
    80204354:	ffffc097          	auipc	ra,0xffffc
    80204358:	244080e7          	jalr	580(ra) # 80200598 <printf>
    
    if (chan == 0) {
    8020435c:	fd843783          	ld	a5,-40(s0)
    80204360:	eb91                	bnez	a5,80204374 <wakeup+0x3e>
        printf("WARNING: wakeup called with NULL channel\n");
    80204362:	00003517          	auipc	a0,0x3
    80204366:	c1e50513          	addi	a0,a0,-994 # 80206f80 <small_numbers+0x1d60>
    8020436a:	ffffc097          	auipc	ra,0xffffc
    8020436e:	22e080e7          	jalr	558(ra) # 80200598 <printf>
        return;
    80204372:	a065                	j	8020441a <wakeup+0xe4>
    }
    
    intr_off();
    80204374:	fffff097          	auipc	ra,0xfffff
    80204378:	4e4080e7          	jalr	1252(ra) # 80203858 <intr_off>
    int woke_up = 0;
    8020437c:	fe042623          	sw	zero,-20(s0)
    for(struct proc *p = proc_table; p < &proc_table[PROC]; p++) {
    80204380:	00006797          	auipc	a5,0x6
    80204384:	f5078793          	addi	a5,a5,-176 # 8020a2d0 <proc_table>
    80204388:	fef43023          	sd	a5,-32(s0)
    8020438c:	a8b1                	j	802043e8 <wakeup+0xb2>
        // 移除 p != myproc() 条件，让当前进程也能被唤醒
        if (p->state == SLEEPING && p->chan == chan) {
    8020438e:	fe043783          	ld	a5,-32(s0)
    80204392:	439c                	lw	a5,0(a5)
    80204394:	873e                	mv	a4,a5
    80204396:	4789                	li	a5,2
    80204398:	04f71263          	bne	a4,a5,802043dc <wakeup+0xa6>
    8020439c:	fe043783          	ld	a5,-32(s0)
    802043a0:	679c                	ld	a5,8(a5)
    802043a2:	fd843703          	ld	a4,-40(s0)
    802043a6:	02f71b63          	bne	a4,a5,802043dc <wakeup+0xa6>
            printf("Waking up process %d\n", p->pid);
    802043aa:	fe043783          	ld	a5,-32(s0)
    802043ae:	4f9c                	lw	a5,24(a5)
    802043b0:	85be                	mv	a1,a5
    802043b2:	00003517          	auipc	a0,0x3
    802043b6:	bfe50513          	addi	a0,a0,-1026 # 80206fb0 <small_numbers+0x1d90>
    802043ba:	ffffc097          	auipc	ra,0xffffc
    802043be:	1de080e7          	jalr	478(ra) # 80200598 <printf>
            p->state = RUNNABLE;
    802043c2:	fe043783          	ld	a5,-32(s0)
    802043c6:	470d                	li	a4,3
    802043c8:	c398                	sw	a4,0(a5)
            woke_up++;
    802043ca:	fec42783          	lw	a5,-20(s0)
    802043ce:	2785                	addiw	a5,a5,1
    802043d0:	fef42623          	sw	a5,-20(s0)
            if(!wake_all) break;
    802043d4:	fd442783          	lw	a5,-44(s0)
    802043d8:	2781                	sext.w	a5,a5
    802043da:	c385                	beqz	a5,802043fa <wakeup+0xc4>
    for(struct proc *p = proc_table; p < &proc_table[PROC]; p++) {
    802043dc:	fe043783          	ld	a5,-32(s0)
    802043e0:	0c878793          	addi	a5,a5,200
    802043e4:	fef43023          	sd	a5,-32(s0)
    802043e8:	fe043703          	ld	a4,-32(s0)
    802043ec:	00009797          	auipc	a5,0x9
    802043f0:	0e478793          	addi	a5,a5,228 # 8020d4d0 <cpu_instance.1>
    802043f4:	f8f76de3          	bltu	a4,a5,8020438e <wakeup+0x58>
    802043f8:	a011                	j	802043fc <wakeup+0xc6>
            if(!wake_all) break;
    802043fa:	0001                	nop
        }
    }
    
    printf("Woke up %d processes\n", woke_up);
    802043fc:	fec42783          	lw	a5,-20(s0)
    80204400:	85be                	mv	a1,a5
    80204402:	00003517          	auipc	a0,0x3
    80204406:	bc650513          	addi	a0,a0,-1082 # 80206fc8 <small_numbers+0x1da8>
    8020440a:	ffffc097          	auipc	ra,0xffffc
    8020440e:	18e080e7          	jalr	398(ra) # 80200598 <printf>
    intr_on();
    80204412:	fffff097          	auipc	ra,0xfffff
    80204416:	41c080e7          	jalr	1052(ra) # 8020382e <intr_on>
}
    8020441a:	70a2                	ld	ra,40(sp)
    8020441c:	7402                	ld	s0,32(sp)
    8020441e:	6145                	addi	sp,sp,48
    80204420:	8082                	ret

0000000080204422 <kexit>:
void kexit() {
    80204422:	1101                	addi	sp,sp,-32
    80204424:	ec06                	sd	ra,24(sp)
    80204426:	e822                	sd	s0,16(sp)
    80204428:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    8020442a:	fffff097          	auipc	ra,0xfffff
    8020442e:	470080e7          	jalr	1136(ra) # 8020389a <myproc>
    80204432:	fea43423          	sd	a0,-24(s0)
    
    if (p == 0) {
    80204436:	fe843783          	ld	a5,-24(s0)
    8020443a:	eb89                	bnez	a5,8020444c <kexit+0x2a>
        panic("kexit: no current process");
    8020443c:	00003517          	auipc	a0,0x3
    80204440:	ba450513          	addi	a0,a0,-1116 # 80206fe0 <small_numbers+0x1dc0>
    80204444:	ffffd097          	auipc	ra,0xffffd
    80204448:	a5c080e7          	jalr	-1444(ra) # 80200ea0 <panic>
    }
    
    if (p->parent == 0) {
    8020444c:	fe843783          	ld	a5,-24(s0)
    80204450:	739c                	ld	a5,32(a5)
    80204452:	e3b9                	bnez	a5,80204498 <kexit+0x76>
        printf("WARNING: Process %d has no parent, self cleaning\n", p->pid);
    80204454:	fe843783          	ld	a5,-24(s0)
    80204458:	4f9c                	lw	a5,24(a5)
    8020445a:	85be                	mv	a1,a5
    8020445c:	00003517          	auipc	a0,0x3
    80204460:	ba450513          	addi	a0,a0,-1116 # 80207000 <small_numbers+0x1de0>
    80204464:	ffffc097          	auipc	ra,0xffffc
    80204468:	134080e7          	jalr	308(ra) # 80200598 <printf>
        p->state = UNUSED;  // 不设为ZOMBIE，直接清理
    8020446c:	fe843783          	ld	a5,-24(s0)
    80204470:	0007a023          	sw	zero,0(a5)
        free_proc(p);
    80204474:	fe843503          	ld	a0,-24(s0)
    80204478:	00000097          	auipc	ra,0x0
    8020447c:	976080e7          	jalr	-1674(ra) # 80203dee <free_proc>
        schedule();
    80204480:	00000097          	auipc	ra,0x0
    80204484:	c2e080e7          	jalr	-978(ra) # 802040ae <schedule>
        panic("kexit should not return");
    80204488:	00003517          	auipc	a0,0x3
    8020448c:	bb050513          	addi	a0,a0,-1104 # 80207038 <small_numbers+0x1e18>
    80204490:	ffffd097          	auipc	ra,0xffffd
    80204494:	a10080e7          	jalr	-1520(ra) # 80200ea0 <panic>
    }
    
    printf("Process %d exiting (parent: %d)\n", p->pid, p->parent->pid);
    80204498:	fe843783          	ld	a5,-24(s0)
    8020449c:	4f98                	lw	a4,24(a5)
    8020449e:	fe843783          	ld	a5,-24(s0)
    802044a2:	739c                	ld	a5,32(a5)
    802044a4:	4f9c                	lw	a5,24(a5)
    802044a6:	863e                	mv	a2,a5
    802044a8:	85ba                	mv	a1,a4
    802044aa:	00003517          	auipc	a0,0x3
    802044ae:	ba650513          	addi	a0,a0,-1114 # 80207050 <small_numbers+0x1e30>
    802044b2:	ffffc097          	auipc	ra,0xffffc
    802044b6:	0e6080e7          	jalr	230(ra) # 80200598 <printf>
    
    // 正确设置ZOMBIE状态
    p->state = ZOMBIE;
    802044ba:	fe843783          	ld	a5,-24(s0)
    802044be:	4715                	li	a4,5
    802044c0:	c398                	sw	a4,0(a5)
    
    // 明确打印父进程状态
    printf("Parent process %d state before wakeup: %d\n", 
           p->parent->pid, p->parent->state);
    802044c2:	fe843783          	ld	a5,-24(s0)
    802044c6:	739c                	ld	a5,32(a5)
    printf("Parent process %d state before wakeup: %d\n", 
    802044c8:	4f98                	lw	a4,24(a5)
           p->parent->pid, p->parent->state);
    802044ca:	fe843783          	ld	a5,-24(s0)
    802044ce:	739c                	ld	a5,32(a5)
    802044d0:	439c                	lw	a5,0(a5)
    printf("Parent process %d state before wakeup: %d\n", 
    802044d2:	863e                	mv	a2,a5
    802044d4:	85ba                	mv	a1,a4
    802044d6:	00003517          	auipc	a0,0x3
    802044da:	ba250513          	addi	a0,a0,-1118 # 80207078 <small_numbers+0x1e58>
    802044de:	ffffc097          	auipc	ra,0xffffc
    802044e2:	0ba080e7          	jalr	186(ra) # 80200598 <printf>
    
    // 使用父进程作为唤醒通道
    if (p->parent->state == SLEEPING && p->parent->chan == p->parent) {
    802044e6:	fe843783          	ld	a5,-24(s0)
    802044ea:	739c                	ld	a5,32(a5)
    802044ec:	439c                	lw	a5,0(a5)
    802044ee:	873e                	mv	a4,a5
    802044f0:	4789                	li	a5,2
    802044f2:	04f71263          	bne	a4,a5,80204536 <kexit+0x114>
    802044f6:	fe843783          	ld	a5,-24(s0)
    802044fa:	739c                	ld	a5,32(a5)
    802044fc:	6798                	ld	a4,8(a5)
    802044fe:	fe843783          	ld	a5,-24(s0)
    80204502:	739c                	ld	a5,32(a5)
    80204504:	02f71963          	bne	a4,a5,80204536 <kexit+0x114>
        printf("Waking up parent process %d\n", p->parent->pid);
    80204508:	fe843783          	ld	a5,-24(s0)
    8020450c:	739c                	ld	a5,32(a5)
    8020450e:	4f9c                	lw	a5,24(a5)
    80204510:	85be                	mv	a1,a5
    80204512:	00003517          	auipc	a0,0x3
    80204516:	b9650513          	addi	a0,a0,-1130 # 802070a8 <small_numbers+0x1e88>
    8020451a:	ffffc097          	auipc	ra,0xffffc
    8020451e:	07e080e7          	jalr	126(ra) # 80200598 <printf>
        wakeup(p->parent, 0);
    80204522:	fe843783          	ld	a5,-24(s0)
    80204526:	739c                	ld	a5,32(a5)
    80204528:	4581                	li	a1,0
    8020452a:	853e                	mv	a0,a5
    8020452c:	00000097          	auipc	ra,0x0
    80204530:	e0a080e7          	jalr	-502(ra) # 80204336 <wakeup>
    80204534:	a831                	j	80204550 <kexit+0x12e>
    } else {
        printf("Parent %d not sleeping or using different channel\n", p->parent->pid);
    80204536:	fe843783          	ld	a5,-24(s0)
    8020453a:	739c                	ld	a5,32(a5)
    8020453c:	4f9c                	lw	a5,24(a5)
    8020453e:	85be                	mv	a1,a5
    80204540:	00003517          	auipc	a0,0x3
    80204544:	b8850513          	addi	a0,a0,-1144 # 802070c8 <small_numbers+0x1ea8>
    80204548:	ffffc097          	auipc	ra,0xffffc
    8020454c:	050080e7          	jalr	80(ra) # 80200598 <printf>
    }
    
    schedule();
    80204550:	00000097          	auipc	ra,0x0
    80204554:	b5e080e7          	jalr	-1186(ra) # 802040ae <schedule>
    panic("kexit should not return");
    80204558:	00003517          	auipc	a0,0x3
    8020455c:	ae050513          	addi	a0,a0,-1312 # 80207038 <small_numbers+0x1e18>
    80204560:	ffffd097          	auipc	ra,0xffffd
    80204564:	940080e7          	jalr	-1728(ra) # 80200ea0 <panic>
}
    80204568:	0001                	nop
    8020456a:	60e2                	ld	ra,24(sp)
    8020456c:	6442                	ld	s0,16(sp)
    8020456e:	6105                	addi	sp,sp,32
    80204570:	8082                	ret

0000000080204572 <kwait>:
int kwait(int *status) {
    80204572:	7139                	addi	sp,sp,-64
    80204574:	fc06                	sd	ra,56(sp)
    80204576:	f822                	sd	s0,48(sp)
    80204578:	0080                	addi	s0,sp,64
    8020457a:	fca43423          	sd	a0,-56(s0)
    struct proc *p = myproc();
    8020457e:	fffff097          	auipc	ra,0xfffff
    80204582:	31c080e7          	jalr	796(ra) # 8020389a <myproc>
    80204586:	fea43023          	sd	a0,-32(s0)
    
    if (p == 0) {
    8020458a:	fe043783          	ld	a5,-32(s0)
    8020458e:	eb99                	bnez	a5,802045a4 <kwait+0x32>
        printf("Warning: kwait called with no current process\n");
    80204590:	00003517          	auipc	a0,0x3
    80204594:	b7050513          	addi	a0,a0,-1168 # 80207100 <small_numbers+0x1ee0>
    80204598:	ffffc097          	auipc	ra,0xffffc
    8020459c:	000080e7          	jalr	ra # 80200598 <printf>
        return -1;
    802045a0:	57fd                	li	a5,-1
    802045a2:	aa61                	j	8020473a <kwait+0x1c8>
    }
    
    printf("Process %d waiting for children\n", p->pid);
    802045a4:	fe043783          	ld	a5,-32(s0)
    802045a8:	4f9c                	lw	a5,24(a5)
    802045aa:	85be                	mv	a1,a5
    802045ac:	00003517          	auipc	a0,0x3
    802045b0:	b8450513          	addi	a0,a0,-1148 # 80207130 <small_numbers+0x1f10>
    802045b4:	ffffc097          	auipc	ra,0xffffc
    802045b8:	fe4080e7          	jalr	-28(ra) # 80200598 <printf>
    
    while (1) {
        int havekids = 0;
    802045bc:	fe042623          	sw	zero,-20(s0)
        intr_off();
    802045c0:	fffff097          	auipc	ra,0xfffff
    802045c4:	298080e7          	jalr	664(ra) # 80203858 <intr_off>
        
        // 检查ZOMBIE子进程
        for (int i = 0; i < PROC; i++) {
    802045c8:	fe042423          	sw	zero,-24(s0)
    802045cc:	a0e9                	j	80204696 <kwait+0x124>
            struct proc *child = &proc_table[i];
    802045ce:	fe842703          	lw	a4,-24(s0)
    802045d2:	0c800793          	li	a5,200
    802045d6:	02f70733          	mul	a4,a4,a5
    802045da:	00006797          	auipc	a5,0x6
    802045de:	cf678793          	addi	a5,a5,-778 # 8020a2d0 <proc_table>
    802045e2:	97ba                	add	a5,a5,a4
    802045e4:	fcf43c23          	sd	a5,-40(s0)
            if (child->state != UNUSED && child->parent == p) {
    802045e8:	fd843783          	ld	a5,-40(s0)
    802045ec:	439c                	lw	a5,0(a5)
    802045ee:	cfd9                	beqz	a5,8020468c <kwait+0x11a>
    802045f0:	fd843783          	ld	a5,-40(s0)
    802045f4:	739c                	ld	a5,32(a5)
    802045f6:	fe043703          	ld	a4,-32(s0)
    802045fa:	08f71963          	bne	a4,a5,8020468c <kwait+0x11a>
                havekids = 1;
    802045fe:	4785                	li	a5,1
    80204600:	fef42623          	sw	a5,-20(s0)
                printf("Process %d found child %d in state %d\n", 
    80204604:	fe043783          	ld	a5,-32(s0)
    80204608:	4f98                	lw	a4,24(a5)
    8020460a:	fd843783          	ld	a5,-40(s0)
    8020460e:	4f90                	lw	a2,24(a5)
                       p->pid, child->pid, child->state);
    80204610:	fd843783          	ld	a5,-40(s0)
    80204614:	439c                	lw	a5,0(a5)
                printf("Process %d found child %d in state %d\n", 
    80204616:	86be                	mv	a3,a5
    80204618:	85ba                	mv	a1,a4
    8020461a:	00003517          	auipc	a0,0x3
    8020461e:	b3e50513          	addi	a0,a0,-1218 # 80207158 <small_numbers+0x1f38>
    80204622:	ffffc097          	auipc	ra,0xffffc
    80204626:	f76080e7          	jalr	-138(ra) # 80200598 <printf>
                
                if (child->state == ZOMBIE) {
    8020462a:	fd843783          	ld	a5,-40(s0)
    8020462e:	439c                	lw	a5,0(a5)
    80204630:	873e                	mv	a4,a5
    80204632:	4795                	li	a5,5
    80204634:	04f71c63          	bne	a4,a5,8020468c <kwait+0x11a>
                    int pid = child->pid;
    80204638:	fd843783          	ld	a5,-40(s0)
    8020463c:	4f9c                	lw	a5,24(a5)
    8020463e:	fcf42a23          	sw	a5,-44(s0)
                    if (status)
    80204642:	fc843783          	ld	a5,-56(s0)
    80204646:	c799                	beqz	a5,80204654 <kwait+0xe2>
                        *status = child->exit_status;
    80204648:	fd843783          	ld	a5,-40(s0)
    8020464c:	4bd8                	lw	a4,20(a5)
    8020464e:	fc843783          	ld	a5,-56(s0)
    80204652:	c398                	sw	a4,0(a5)
                    printf("Process %d cleaning up ZOMBIE child %d\n", p->pid, pid);
    80204654:	fe043783          	ld	a5,-32(s0)
    80204658:	4f9c                	lw	a5,24(a5)
    8020465a:	fd442703          	lw	a4,-44(s0)
    8020465e:	863a                	mv	a2,a4
    80204660:	85be                	mv	a1,a5
    80204662:	00003517          	auipc	a0,0x3
    80204666:	b1e50513          	addi	a0,a0,-1250 # 80207180 <small_numbers+0x1f60>
    8020466a:	ffffc097          	auipc	ra,0xffffc
    8020466e:	f2e080e7          	jalr	-210(ra) # 80200598 <printf>
                    free_proc(child);
    80204672:	fd843503          	ld	a0,-40(s0)
    80204676:	fffff097          	auipc	ra,0xfffff
    8020467a:	778080e7          	jalr	1912(ra) # 80203dee <free_proc>
                    intr_on();
    8020467e:	fffff097          	auipc	ra,0xfffff
    80204682:	1b0080e7          	jalr	432(ra) # 8020382e <intr_on>
                    return pid;
    80204686:	fd442783          	lw	a5,-44(s0)
    8020468a:	a845                	j	8020473a <kwait+0x1c8>
        for (int i = 0; i < PROC; i++) {
    8020468c:	fe842783          	lw	a5,-24(s0)
    80204690:	2785                	addiw	a5,a5,1
    80204692:	fef42423          	sw	a5,-24(s0)
    80204696:	fe842783          	lw	a5,-24(s0)
    8020469a:	0007871b          	sext.w	a4,a5
    8020469e:	03f00793          	li	a5,63
    802046a2:	f2e7d6e3          	bge	a5,a4,802045ce <kwait+0x5c>
                }
            }
        }
        
        if (!havekids) {
    802046a6:	fec42783          	lw	a5,-20(s0)
    802046aa:	2781                	sext.w	a5,a5
    802046ac:	e39d                	bnez	a5,802046d2 <kwait+0x160>
            intr_on();
    802046ae:	fffff097          	auipc	ra,0xfffff
    802046b2:	180080e7          	jalr	384(ra) # 8020382e <intr_on>
            printf("Process %d has no children\n", p->pid);
    802046b6:	fe043783          	ld	a5,-32(s0)
    802046ba:	4f9c                	lw	a5,24(a5)
    802046bc:	85be                	mv	a1,a5
    802046be:	00003517          	auipc	a0,0x3
    802046c2:	aea50513          	addi	a0,a0,-1302 # 802071a8 <small_numbers+0x1f88>
    802046c6:	ffffc097          	auipc	ra,0xffffc
    802046ca:	ed2080e7          	jalr	-302(ra) # 80200598 <printf>
            return -1;
    802046ce:	57fd                	li	a5,-1
    802046d0:	a0ad                	j	8020473a <kwait+0x1c8>
        }
        
        // 定义一个明确的通道值 - 不使用进程指针
        static uint64 wait_channel = 0xBEEF;
        
        printf("Process %d sleeping on wait channel %p\n", p->pid, (void*)wait_channel);
    802046d2:	fe043783          	ld	a5,-32(s0)
    802046d6:	4f98                	lw	a4,24(a5)
    802046d8:	00004797          	auipc	a5,0x4
    802046dc:	93078793          	addi	a5,a5,-1744 # 80208008 <wait_channel.0>
    802046e0:	639c                	ld	a5,0(a5)
    802046e2:	863e                	mv	a2,a5
    802046e4:	85ba                	mv	a1,a4
    802046e6:	00003517          	auipc	a0,0x3
    802046ea:	ae250513          	addi	a0,a0,-1310 # 802071c8 <small_numbers+0x1fa8>
    802046ee:	ffffc097          	auipc	ra,0xffffc
    802046f2:	eaa080e7          	jalr	-342(ra) # 80200598 <printf>
        p->chan = (void*)wait_channel;
    802046f6:	00004797          	auipc	a5,0x4
    802046fa:	91278793          	addi	a5,a5,-1774 # 80208008 <wait_channel.0>
    802046fe:	639c                	ld	a5,0(a5)
    80204700:	873e                	mv	a4,a5
    80204702:	fe043783          	ld	a5,-32(s0)
    80204706:	e798                	sd	a4,8(a5)
        p->state = SLEEPING;
    80204708:	fe043783          	ld	a5,-32(s0)
    8020470c:	4709                	li	a4,2
    8020470e:	c398                	sw	a4,0(a5)
        intr_on();
    80204710:	fffff097          	auipc	ra,0xfffff
    80204714:	11e080e7          	jalr	286(ra) # 8020382e <intr_on>
        schedule();
    80204718:	00000097          	auipc	ra,0x0
    8020471c:	996080e7          	jalr	-1642(ra) # 802040ae <schedule>
        
        // 被唤醒后继续循环检查
        printf("Process %d woken up, rechecking children\n", p->pid);
    80204720:	fe043783          	ld	a5,-32(s0)
    80204724:	4f9c                	lw	a5,24(a5)
    80204726:	85be                	mv	a1,a5
    80204728:	00003517          	auipc	a0,0x3
    8020472c:	ac850513          	addi	a0,a0,-1336 # 802071f0 <small_numbers+0x1fd0>
    80204730:	ffffc097          	auipc	ra,0xffffc
    80204734:	e68080e7          	jalr	-408(ra) # 80200598 <printf>
    while (1) {
    80204738:	b551                	j	802045bc <kwait+0x4a>
    }
}
    8020473a:	853e                	mv	a0,a5
    8020473c:	70e2                	ld	ra,56(sp)
    8020473e:	7442                	ld	s0,48(sp)
    80204740:	6121                	addi	sp,sp,64
    80204742:	8082                	ret

0000000080204744 <simple_task>:
void simple_task(void) {
    80204744:	1101                	addi	sp,sp,-32
    80204746:	ec06                	sd	ra,24(sp)
    80204748:	e822                	sd	s0,16(sp)
    8020474a:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    8020474c:	fffff097          	auipc	ra,0xfffff
    80204750:	14e080e7          	jalr	334(ra) # 8020389a <myproc>
    80204754:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80204758:	fe843783          	ld	a5,-24(s0)
    8020475c:	eb89                	bnez	a5,8020476e <simple_task+0x2a>
        panic("simple_task: no current process");
    8020475e:	00003517          	auipc	a0,0x3
    80204762:	ac250513          	addi	a0,a0,-1342 # 80207220 <small_numbers+0x2000>
    80204766:	ffffc097          	auipc	ra,0xffffc
    8020476a:	73a080e7          	jalr	1850(ra) # 80200ea0 <panic>
    }
    
    printf("Simple task running in pid %d (parent pid: %d)\n", 
    8020476e:	fe843783          	ld	a5,-24(s0)
    80204772:	4f98                	lw	a4,24(a5)
           p->pid, p->parent ? p->parent->pid : -1);
    80204774:	fe843783          	ld	a5,-24(s0)
    80204778:	739c                	ld	a5,32(a5)
    printf("Simple task running in pid %d (parent pid: %d)\n", 
    8020477a:	c791                	beqz	a5,80204786 <simple_task+0x42>
           p->pid, p->parent ? p->parent->pid : -1);
    8020477c:	fe843783          	ld	a5,-24(s0)
    80204780:	739c                	ld	a5,32(a5)
    printf("Simple task running in pid %d (parent pid: %d)\n", 
    80204782:	4f9c                	lw	a5,24(a5)
    80204784:	a011                	j	80204788 <simple_task+0x44>
    80204786:	57fd                	li	a5,-1
    80204788:	863e                	mv	a2,a5
    8020478a:	85ba                	mv	a1,a4
    8020478c:	00003517          	auipc	a0,0x3
    80204790:	ab450513          	addi	a0,a0,-1356 # 80207240 <small_numbers+0x2020>
    80204794:	ffffc097          	auipc	ra,0xffffc
    80204798:	e04080e7          	jalr	-508(ra) # 80200598 <printf>
    
    // 在退出前确保父进程指针有效
    if (p->parent == 0) {
    8020479c:	fe843783          	ld	a5,-24(s0)
    802047a0:	739c                	ld	a5,32(a5)
    802047a2:	e3b9                	bnez	a5,802047e8 <simple_task+0xa4>
        printf("ERROR: parent is NULL for pid %d\n", p->pid);
    802047a4:	fe843783          	ld	a5,-24(s0)
    802047a8:	4f9c                	lw	a5,24(a5)
    802047aa:	85be                	mv	a1,a5
    802047ac:	00003517          	auipc	a0,0x3
    802047b0:	ac450513          	addi	a0,a0,-1340 # 80207270 <small_numbers+0x2050>
    802047b4:	ffffc097          	auipc	ra,0xffffc
    802047b8:	de4080e7          	jalr	-540(ra) # 80200598 <printf>
        // 直接自我清理
        p->state = UNUSED;
    802047bc:	fe843783          	ld	a5,-24(s0)
    802047c0:	0007a023          	sw	zero,0(a5)
        free_proc(p);
    802047c4:	fe843503          	ld	a0,-24(s0)
    802047c8:	fffff097          	auipc	ra,0xfffff
    802047cc:	626080e7          	jalr	1574(ra) # 80203dee <free_proc>
        schedule();
    802047d0:	00000097          	auipc	ra,0x0
    802047d4:	8de080e7          	jalr	-1826(ra) # 802040ae <schedule>
        panic("simple_task should not return after schedule");
    802047d8:	00003517          	auipc	a0,0x3
    802047dc:	ac050513          	addi	a0,a0,-1344 # 80207298 <small_numbers+0x2078>
    802047e0:	ffffc097          	auipc	ra,0xffffc
    802047e4:	6c0080e7          	jalr	1728(ra) # 80200ea0 <panic>
    }
    
    // 安全地退出
    printf("Process %d exiting normally\n", p->pid);
    802047e8:	fe843783          	ld	a5,-24(s0)
    802047ec:	4f9c                	lw	a5,24(a5)
    802047ee:	85be                	mv	a1,a5
    802047f0:	00003517          	auipc	a0,0x3
    802047f4:	ad850513          	addi	a0,a0,-1320 # 802072c8 <small_numbers+0x20a8>
    802047f8:	ffffc097          	auipc	ra,0xffffc
    802047fc:	da0080e7          	jalr	-608(ra) # 80200598 <printf>
    exit_proc(0);
    80204800:	4501                	li	a0,0
    80204802:	fffff097          	auipc	ra,0xfffff
    80204806:	6fe080e7          	jalr	1790(ra) # 80203f00 <exit_proc>
}
    8020480a:	0001                	nop
    8020480c:	60e2                	ld	ra,24(sp)
    8020480e:	6442                	ld	s0,16(sp)
    80204810:	6105                	addi	sp,sp,32
    80204812:	8082                	ret

0000000080204814 <wake_test_task>:

// 用于唤醒测试的简单任务
void wake_test_task(void) {
    80204814:	1101                	addi	sp,sp,-32
    80204816:	ec06                	sd	ra,24(sp)
    80204818:	e822                	sd	s0,16(sp)
    8020481a:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    8020481c:	fffff097          	auipc	ra,0xfffff
    80204820:	07e080e7          	jalr	126(ra) # 8020389a <myproc>
    80204824:	fea43423          	sd	a0,-24(s0)
    printf("唤醒测试任务运行在 pid=%d\n", p->pid);
    80204828:	fe843783          	ld	a5,-24(s0)
    8020482c:	4f9c                	lw	a5,24(a5)
    8020482e:	85be                	mv	a1,a5
    80204830:	00003517          	auipc	a0,0x3
    80204834:	ab850513          	addi	a0,a0,-1352 # 802072e8 <small_numbers+0x20c8>
    80204838:	ffffc097          	auipc	ra,0xffffc
    8020483c:	d60080e7          	jalr	-672(ra) # 80200598 <printf>
    exit_proc(0);
    80204840:	4501                	li	a0,0
    80204842:	fffff097          	auipc	ra,0xfffff
    80204846:	6be080e7          	jalr	1726(ra) # 80203f00 <exit_proc>
}
    8020484a:	0001                	nop
    8020484c:	60e2                	ld	ra,24(sp)
    8020484e:	6442                	ld	s0,16(sp)
    80204850:	6105                	addi	sp,sp,32
    80204852:	8082                	ret

0000000080204854 <test_proc_functions>:

void test_proc_functions(void) {
    80204854:	7139                	addi	sp,sp,-64
    80204856:	fc06                	sd	ra,56(sp)
    80204858:	f822                	sd	s0,48(sp)
    8020485a:	0080                	addi	s0,sp,64
    printf("\n=== 进程管理函数测试 ===\n");
    8020485c:	00003517          	auipc	a0,0x3
    80204860:	ab450513          	addi	a0,a0,-1356 # 80207310 <small_numbers+0x20f0>
    80204864:	ffffc097          	auipc	ra,0xffffc
    80204868:	d34080e7          	jalr	-716(ra) # 80200598 <printf>
    
    // 测试1: alloc_proc
    printf("\n[测试1] alloc_proc 测试\n");
    8020486c:	00003517          	auipc	a0,0x3
    80204870:	acc50513          	addi	a0,a0,-1332 # 80207338 <small_numbers+0x2118>
    80204874:	ffffc097          	auipc	ra,0xffffc
    80204878:	d24080e7          	jalr	-732(ra) # 80200598 <printf>
    struct proc *p = alloc_proc();
    8020487c:	fffff097          	auipc	ra,0xfffff
    80204880:	3aa080e7          	jalr	938(ra) # 80203c26 <alloc_proc>
    80204884:	fea43023          	sd	a0,-32(s0)
    if(p == 0) {
    80204888:	fe043783          	ld	a5,-32(s0)
    8020488c:	eb91                	bnez	a5,802048a0 <test_proc_functions+0x4c>
        printf("alloc_proc 测试失败: 无法分配进程\n");
    8020488e:	00003517          	auipc	a0,0x3
    80204892:	aca50513          	addi	a0,a0,-1334 # 80207358 <small_numbers+0x2138>
    80204896:	ffffc097          	auipc	ra,0xffffc
    8020489a:	d02080e7          	jalr	-766(ra) # 80200598 <printf>
    8020489e:	a099                	j	802048e4 <test_proc_functions+0x90>
    } else {
        printf("alloc_proc 测试通过: 成功分配进程 pid=%d\n", p->pid);
    802048a0:	fe043783          	ld	a5,-32(s0)
    802048a4:	4f9c                	lw	a5,24(a5)
    802048a6:	85be                	mv	a1,a5
    802048a8:	00003517          	auipc	a0,0x3
    802048ac:	ae050513          	addi	a0,a0,-1312 # 80207388 <small_numbers+0x2168>
    802048b0:	ffffc097          	auipc	ra,0xffffc
    802048b4:	ce8080e7          	jalr	-792(ra) # 80200598 <printf>
        
        // 测试2: free_proc
        printf("\n[测试2] free_proc 测试\n");
    802048b8:	00003517          	auipc	a0,0x3
    802048bc:	b0850513          	addi	a0,a0,-1272 # 802073c0 <small_numbers+0x21a0>
    802048c0:	ffffc097          	auipc	ra,0xffffc
    802048c4:	cd8080e7          	jalr	-808(ra) # 80200598 <printf>
        free_proc(p);
    802048c8:	fe043503          	ld	a0,-32(s0)
    802048cc:	fffff097          	auipc	ra,0xfffff
    802048d0:	522080e7          	jalr	1314(ra) # 80203dee <free_proc>
        printf("free_proc 测试通过: 进程被释放\n");
    802048d4:	00003517          	auipc	a0,0x3
    802048d8:	b0c50513          	addi	a0,a0,-1268 # 802073e0 <small_numbers+0x21c0>
    802048dc:	ffffc097          	auipc	ra,0xffffc
    802048e0:	cbc080e7          	jalr	-836(ra) # 80200598 <printf>
    }
    
    // 测试3: create_proc 和简单运行
    printf("\n[测试3] create_proc 测试\n");
    802048e4:	00003517          	auipc	a0,0x3
    802048e8:	b2c50513          	addi	a0,a0,-1236 # 80207410 <small_numbers+0x21f0>
    802048ec:	ffffc097          	auipc	ra,0xffffc
    802048f0:	cac080e7          	jalr	-852(ra) # 80200598 <printf>
    current_proc = 0; // 确保没有父进程
    802048f4:	00005797          	auipc	a5,0x5
    802048f8:	73c78793          	addi	a5,a5,1852 # 8020a030 <current_proc>
    802048fc:	0007b023          	sd	zero,0(a5)
    int pid = create_proc(simple_task);
    80204900:	00000517          	auipc	a0,0x0
    80204904:	e4450513          	addi	a0,a0,-444 # 80204744 <simple_task>
    80204908:	fffff097          	auipc	ra,0xfffff
    8020490c:	57c080e7          	jalr	1404(ra) # 80203e84 <create_proc>
    80204910:	87aa                	mv	a5,a0
    80204912:	fcf42e23          	sw	a5,-36(s0)
    if(pid <= 0) {
    80204916:	fdc42783          	lw	a5,-36(s0)
    8020491a:	2781                	sext.w	a5,a5
    8020491c:	00f04b63          	bgtz	a5,80204932 <test_proc_functions+0xde>
        printf("create_proc 测试失败: 无法创建进程\n");
    80204920:	00003517          	auipc	a0,0x3
    80204924:	b1050513          	addi	a0,a0,-1264 # 80207430 <small_numbers+0x2210>
    80204928:	ffffc097          	auipc	ra,0xffffc
    8020492c:	c70080e7          	jalr	-912(ra) # 80200598 <printf>
    80204930:	a821                	j	80204948 <test_proc_functions+0xf4>
    } else {
        printf("create_proc 测试通过: 成功创建进程 pid=%d\n", pid);
    80204932:	fdc42783          	lw	a5,-36(s0)
    80204936:	85be                	mv	a1,a5
    80204938:	00003517          	auipc	a0,0x3
    8020493c:	b2850513          	addi	a0,a0,-1240 # 80207460 <small_numbers+0x2240>
    80204940:	ffffc097          	auipc	ra,0xffffc
    80204944:	c58080e7          	jalr	-936(ra) # 80200598 <printf>
    }
    
    // 测试4: 测试睡眠和唤醒机制
printf("\n[测试4] sleep/wakeup 测试\n");
    80204948:	00003517          	auipc	a0,0x3
    8020494c:	b5050513          	addi	a0,a0,-1200 # 80207498 <small_numbers+0x2278>
    80204950:	ffffc097          	auipc	ra,0xffffc
    80204954:	c48080e7          	jalr	-952(ra) # 80200598 <printf>
struct proc *sleep_test = alloc_proc();
    80204958:	fffff097          	auipc	ra,0xfffff
    8020495c:	2ce080e7          	jalr	718(ra) # 80203c26 <alloc_proc>
    80204960:	fca43823          	sd	a0,-48(s0)
if(sleep_test) {
    80204964:	fd043783          	ld	a5,-48(s0)
    80204968:	1c078b63          	beqz	a5,80204b3e <test_proc_functions+0x2ea>
    current_proc = sleep_test;
    8020496c:	00005797          	auipc	a5,0x5
    80204970:	6c478793          	addi	a5,a5,1732 # 8020a030 <current_proc>
    80204974:	fd043703          	ld	a4,-48(s0)
    80204978:	e398                	sd	a4,0(a5)
    sleep_test->state = RUNNING;
    8020497a:	fd043783          	ld	a5,-48(s0)
    8020497e:	4711                	li	a4,4
    80204980:	c398                	sw	a4,0(a5)
    
    // 创建一个唤醒线程
    int wake_pid = create_proc(wake_test_task);
    80204982:	00000517          	auipc	a0,0x0
    80204986:	e9250513          	addi	a0,a0,-366 # 80204814 <wake_test_task>
    8020498a:	fffff097          	auipc	ra,0xfffff
    8020498e:	4fa080e7          	jalr	1274(ra) # 80203e84 <create_proc>
    80204992:	87aa                	mv	a5,a0
    80204994:	fcf42623          	sw	a5,-52(s0)
    if(wake_pid > 0) {
    80204998:	fcc42783          	lw	a5,-52(s0)
    8020499c:	2781                	sext.w	a5,a5
    8020499e:	18f05a63          	blez	a5,80204b32 <test_proc_functions+0x2de>
        printf("创建唤醒测试进程 pid=%d\n", wake_pid);
    802049a2:	fcc42783          	lw	a5,-52(s0)
    802049a6:	85be                	mv	a1,a5
    802049a8:	00003517          	auipc	a0,0x3
    802049ac:	b1050513          	addi	a0,a0,-1264 # 802074b8 <small_numbers+0x2298>
    802049b0:	ffffc097          	auipc	ra,0xffffc
    802049b4:	be8080e7          	jalr	-1048(ra) # 80200598 <printf>
        
        // 用于测试的特定通道
        void *test_channel = (void*)0xDEADBEEF;
    802049b8:	37ab77b7          	lui	a5,0x37ab7
    802049bc:	078a                	slli	a5,a5,0x2
    802049be:	eef78793          	addi	a5,a5,-273 # 37ab6eef <userret+0x37ab6e53>
    802049c2:	fcf43023          	sd	a5,-64(s0)
        printf("进程 %d 将在通道 %p 上睡眠\n", sleep_test->pid, test_channel);
    802049c6:	fd043783          	ld	a5,-48(s0)
    802049ca:	4f9c                	lw	a5,24(a5)
    802049cc:	fc043603          	ld	a2,-64(s0)
    802049d0:	85be                	mv	a1,a5
    802049d2:	00003517          	auipc	a0,0x3
    802049d6:	b0e50513          	addi	a0,a0,-1266 # 802074e0 <small_numbers+0x22c0>
    802049da:	ffffc097          	auipc	ra,0xffffc
    802049de:	bbe080e7          	jalr	-1090(ra) # 80200598 <printf>
        
        // 显式输出当前进程
        printf("当前进程: pid=%d\n", myproc() ? myproc()->pid : -1);
    802049e2:	fffff097          	auipc	ra,0xfffff
    802049e6:	eb8080e7          	jalr	-328(ra) # 8020389a <myproc>
    802049ea:	87aa                	mv	a5,a0
    802049ec:	cb81                	beqz	a5,802049fc <test_proc_functions+0x1a8>
    802049ee:	fffff097          	auipc	ra,0xfffff
    802049f2:	eac080e7          	jalr	-340(ra) # 8020389a <myproc>
    802049f6:	87aa                	mv	a5,a0
    802049f8:	4f9c                	lw	a5,24(a5)
    802049fa:	a011                	j	802049fe <test_proc_functions+0x1aa>
    802049fc:	57fd                	li	a5,-1
    802049fe:	85be                	mv	a1,a5
    80204a00:	00003517          	auipc	a0,0x3
    80204a04:	b0850513          	addi	a0,a0,-1272 # 80207508 <small_numbers+0x22e8>
    80204a08:	ffffc097          	auipc	ra,0xffffc
    80204a0c:	b90080e7          	jalr	-1136(ra) # 80200598 <printf>
        
        // 这里我们不能真正睡眠，因为会导致测试停止
        // 但我们可以模拟通道设置
        sleep_test->chan = test_channel;
    80204a10:	fd043783          	ld	a5,-48(s0)
    80204a14:	fc043703          	ld	a4,-64(s0)
    80204a18:	e798                	sd	a4,8(a5)
        sleep_test->state = SLEEPING;
    80204a1a:	fd043783          	ld	a5,-48(s0)
    80204a1e:	4709                	li	a4,2
    80204a20:	c398                	sw	a4,0(a5)
        
        // 输出设置后的状态
        printf("睡眠设置后进程 %d 状态: %d, 通道: %p\n", 
    80204a22:	fd043783          	ld	a5,-48(s0)
    80204a26:	4f98                	lw	a4,24(a5)
               sleep_test->pid, sleep_test->state, sleep_test->chan);
    80204a28:	fd043783          	ld	a5,-48(s0)
    80204a2c:	4390                	lw	a2,0(a5)
        printf("睡眠设置后进程 %d 状态: %d, 通道: %p\n", 
    80204a2e:	fd043783          	ld	a5,-48(s0)
    80204a32:	679c                	ld	a5,8(a5)
    80204a34:	86be                	mv	a3,a5
    80204a36:	85ba                	mv	a1,a4
    80204a38:	00003517          	auipc	a0,0x3
    80204a3c:	ae850513          	addi	a0,a0,-1304 # 80207520 <small_numbers+0x2300>
    80204a40:	ffffc097          	auipc	ra,0xffffc
    80204a44:	b58080e7          	jalr	-1192(ra) # 80200598 <printf>
        
        // 手动唤醒
        wakeup(test_channel, 0);
    80204a48:	4581                	li	a1,0
    80204a4a:	fc043503          	ld	a0,-64(s0)
    80204a4e:	00000097          	auipc	ra,0x0
    80204a52:	8e8080e7          	jalr	-1816(ra) # 80204336 <wakeup>
        
        // 检查状态
        if(sleep_test->state == RUNNABLE) {
    80204a56:	fd043783          	ld	a5,-48(s0)
    80204a5a:	439c                	lw	a5,0(a5)
    80204a5c:	873e                	mv	a4,a5
    80204a5e:	478d                	li	a5,3
    80204a60:	00f71b63          	bne	a4,a5,80204a76 <test_proc_functions+0x222>
            printf("sleep/wakeup 测试通过: 进程被成功唤醒\n");
    80204a64:	00003517          	auipc	a0,0x3
    80204a68:	af450513          	addi	a0,a0,-1292 # 80207558 <small_numbers+0x2338>
    80204a6c:	ffffc097          	auipc	ra,0xffffc
    80204a70:	b2c080e7          	jalr	-1236(ra) # 80200598 <printf>
    80204a74:	a87d                	j	80204b32 <test_proc_functions+0x2de>
        } else {
            printf("sleep/wakeup 测试失败: 进程未被唤醒，状态=%d\n", 
                   sleep_test->state);
    80204a76:	fd043783          	ld	a5,-48(s0)
    80204a7a:	439c                	lw	a5,0(a5)
            printf("sleep/wakeup 测试失败: 进程未被唤醒，状态=%d\n", 
    80204a7c:	85be                	mv	a1,a5
    80204a7e:	00003517          	auipc	a0,0x3
    80204a82:	b1250513          	addi	a0,a0,-1262 # 80207590 <small_numbers+0x2370>
    80204a86:	ffffc097          	auipc	ra,0xffffc
    80204a8a:	b12080e7          	jalr	-1262(ra) # 80200598 <printf>
            
            // 调试: 检查所有进程
            printf("所有进程状态:\n");
    80204a8e:	00003517          	auipc	a0,0x3
    80204a92:	b4250513          	addi	a0,a0,-1214 # 802075d0 <small_numbers+0x23b0>
    80204a96:	ffffc097          	auipc	ra,0xffffc
    80204a9a:	b02080e7          	jalr	-1278(ra) # 80200598 <printf>
            for(int i = 0; i < PROC; i++) {
    80204a9e:	fe042623          	sw	zero,-20(s0)
    80204aa2:	a041                	j	80204b22 <test_proc_functions+0x2ce>
                if(proc_table[i].state != UNUSED) {
    80204aa4:	00006717          	auipc	a4,0x6
    80204aa8:	82c70713          	addi	a4,a4,-2004 # 8020a2d0 <proc_table>
    80204aac:	fec42683          	lw	a3,-20(s0)
    80204ab0:	0c800793          	li	a5,200
    80204ab4:	02f687b3          	mul	a5,a3,a5
    80204ab8:	97ba                	add	a5,a5,a4
    80204aba:	439c                	lw	a5,0(a5)
    80204abc:	cfb1                	beqz	a5,80204b18 <test_proc_functions+0x2c4>
                    printf("- pid=%d, state=%d, chan=%p\n", 
    80204abe:	00006717          	auipc	a4,0x6
    80204ac2:	81270713          	addi	a4,a4,-2030 # 8020a2d0 <proc_table>
    80204ac6:	fec42683          	lw	a3,-20(s0)
    80204aca:	0c800793          	li	a5,200
    80204ace:	02f687b3          	mul	a5,a3,a5
    80204ad2:	97ba                	add	a5,a5,a4
    80204ad4:	4f8c                	lw	a1,24(a5)
                           proc_table[i].pid, proc_table[i].state, 
    80204ad6:	00005717          	auipc	a4,0x5
    80204ada:	7fa70713          	addi	a4,a4,2042 # 8020a2d0 <proc_table>
    80204ade:	fec42683          	lw	a3,-20(s0)
    80204ae2:	0c800793          	li	a5,200
    80204ae6:	02f687b3          	mul	a5,a3,a5
    80204aea:	97ba                	add	a5,a5,a4
    80204aec:	4390                	lw	a2,0(a5)
                    printf("- pid=%d, state=%d, chan=%p\n", 
    80204aee:	00005717          	auipc	a4,0x5
    80204af2:	7e270713          	addi	a4,a4,2018 # 8020a2d0 <proc_table>
    80204af6:	fec42683          	lw	a3,-20(s0)
    80204afa:	0c800793          	li	a5,200
    80204afe:	02f687b3          	mul	a5,a3,a5
    80204b02:	97ba                	add	a5,a5,a4
    80204b04:	679c                	ld	a5,8(a5)
    80204b06:	86be                	mv	a3,a5
    80204b08:	00003517          	auipc	a0,0x3
    80204b0c:	ae050513          	addi	a0,a0,-1312 # 802075e8 <small_numbers+0x23c8>
    80204b10:	ffffc097          	auipc	ra,0xffffc
    80204b14:	a88080e7          	jalr	-1400(ra) # 80200598 <printf>
            for(int i = 0; i < PROC; i++) {
    80204b18:	fec42783          	lw	a5,-20(s0)
    80204b1c:	2785                	addiw	a5,a5,1
    80204b1e:	fef42623          	sw	a5,-20(s0)
    80204b22:	fec42783          	lw	a5,-20(s0)
    80204b26:	0007871b          	sext.w	a4,a5
    80204b2a:	03f00793          	li	a5,63
    80204b2e:	f6e7dbe3          	bge	a5,a4,80204aa4 <test_proc_functions+0x250>
            }
        }
    }
        
        // 清理
        free_proc(sleep_test);
    80204b32:	fd043503          	ld	a0,-48(s0)
    80204b36:	fffff097          	auipc	ra,0xfffff
    80204b3a:	2b8080e7          	jalr	696(ra) # 80203dee <free_proc>
    }
    
    printf("\n=== 进程管理函数测试完成 ===\n");
    80204b3e:	00003517          	auipc	a0,0x3
    80204b42:	aca50513          	addi	a0,a0,-1334 # 80207608 <small_numbers+0x23e8>
    80204b46:	ffffc097          	auipc	ra,0xffffc
    80204b4a:	a52080e7          	jalr	-1454(ra) # 80200598 <printf>
}
    80204b4e:	0001                	nop
    80204b50:	70e2                	ld	ra,56(sp)
    80204b52:	7442                	ld	s0,48(sp)
    80204b54:	6121                	addi	sp,sp,64
    80204b56:	8082                	ret

0000000080204b58 <test_proc_manager>:

void test_proc_manager(void) {
    80204b58:	7139                	addi	sp,sp,-64
    80204b5a:	fc06                	sd	ra,56(sp)
    80204b5c:	f822                	sd	s0,48(sp)
    80204b5e:	0080                	addi	s0,sp,64
    printf("Starting simplified test\n");
    80204b60:	00003517          	auipc	a0,0x3
    80204b64:	ad850513          	addi	a0,a0,-1320 # 80207638 <small_numbers+0x2418>
    80204b68:	ffffc097          	auipc	ra,0xffffc
    80204b6c:	a30080e7          	jalr	-1488(ra) # 80200598 <printf>
    
    // 创建初始进程
    struct proc *init = alloc_proc();
    80204b70:	fffff097          	auipc	ra,0xfffff
    80204b74:	0b6080e7          	jalr	182(ra) # 80203c26 <alloc_proc>
    80204b78:	fca43c23          	sd	a0,-40(s0)
    current_proc = init;
    80204b7c:	00005797          	auipc	a5,0x5
    80204b80:	4b478793          	addi	a5,a5,1204 # 8020a030 <current_proc>
    80204b84:	fd843703          	ld	a4,-40(s0)
    80204b88:	e398                	sd	a4,0(a5)
    init->state = RUNNING;
    80204b8a:	fd843783          	ld	a5,-40(s0)
    80204b8e:	4711                	li	a4,4
    80204b90:	c398                	sw	a4,0(a5)
    
    // 创建子进程
    int pid = create_proc(simple_task);
    80204b92:	00000517          	auipc	a0,0x0
    80204b96:	bb250513          	addi	a0,a0,-1102 # 80204744 <simple_task>
    80204b9a:	fffff097          	auipc	ra,0xfffff
    80204b9e:	2ea080e7          	jalr	746(ra) # 80203e84 <create_proc>
    80204ba2:	87aa                	mv	a5,a0
    80204ba4:	fcf42a23          	sw	a5,-44(s0)
    printf("Created child process: pid=%d\n", pid);
    80204ba8:	fd442783          	lw	a5,-44(s0)
    80204bac:	85be                	mv	a1,a5
    80204bae:	00003517          	auipc	a0,0x3
    80204bb2:	aaa50513          	addi	a0,a0,-1366 # 80207658 <small_numbers+0x2438>
    80204bb6:	ffffc097          	auipc	ra,0xffffc
    80204bba:	9e2080e7          	jalr	-1566(ra) # 80200598 <printf>
    
    // 手动让子进程运行
    struct proc *child = 0;
    80204bbe:	fe043423          	sd	zero,-24(s0)
    for(int i = 0; i < PROC; i++) {
    80204bc2:	fe042223          	sw	zero,-28(s0)
    80204bc6:	a0a9                	j	80204c10 <test_proc_manager+0xb8>
        if(proc_table[i].pid == pid) {
    80204bc8:	00005717          	auipc	a4,0x5
    80204bcc:	70870713          	addi	a4,a4,1800 # 8020a2d0 <proc_table>
    80204bd0:	fe442683          	lw	a3,-28(s0)
    80204bd4:	0c800793          	li	a5,200
    80204bd8:	02f687b3          	mul	a5,a3,a5
    80204bdc:	97ba                	add	a5,a5,a4
    80204bde:	4f98                	lw	a4,24(a5)
    80204be0:	fd442783          	lw	a5,-44(s0)
    80204be4:	2781                	sext.w	a5,a5
    80204be6:	02e79063          	bne	a5,a4,80204c06 <test_proc_manager+0xae>
            child = &proc_table[i];
    80204bea:	fe442703          	lw	a4,-28(s0)
    80204bee:	0c800793          	li	a5,200
    80204bf2:	02f70733          	mul	a4,a4,a5
    80204bf6:	00005797          	auipc	a5,0x5
    80204bfa:	6da78793          	addi	a5,a5,1754 # 8020a2d0 <proc_table>
    80204bfe:	97ba                	add	a5,a5,a4
    80204c00:	fef43423          	sd	a5,-24(s0)
            break;
    80204c04:	a831                	j	80204c20 <test_proc_manager+0xc8>
    for(int i = 0; i < PROC; i++) {
    80204c06:	fe442783          	lw	a5,-28(s0)
    80204c0a:	2785                	addiw	a5,a5,1
    80204c0c:	fef42223          	sw	a5,-28(s0)
    80204c10:	fe442783          	lw	a5,-28(s0)
    80204c14:	0007871b          	sext.w	a4,a5
    80204c18:	03f00793          	li	a5,63
    80204c1c:	fae7d6e3          	bge	a5,a4,80204bc8 <test_proc_manager+0x70>
        }
    }
    
    if(child) {
    80204c20:	fe843783          	ld	a5,-24(s0)
    80204c24:	cfa5                	beqz	a5,80204c9c <test_proc_manager+0x144>
        printf("Found child process at %p\n", child);
    80204c26:	fe843583          	ld	a1,-24(s0)
    80204c2a:	00003517          	auipc	a0,0x3
    80204c2e:	a4e50513          	addi	a0,a0,-1458 # 80207678 <small_numbers+0x2458>
    80204c32:	ffffc097          	auipc	ra,0xffffc
    80204c36:	966080e7          	jalr	-1690(ra) # 80200598 <printf>
        printf("Child process state before: %d\n", child->state);
    80204c3a:	fe843783          	ld	a5,-24(s0)
    80204c3e:	439c                	lw	a5,0(a5)
    80204c40:	85be                	mv	a1,a5
    80204c42:	00003517          	auipc	a0,0x3
    80204c46:	a5650513          	addi	a0,a0,-1450 # 80207698 <small_numbers+0x2478>
    80204c4a:	ffffc097          	auipc	ra,0xffffc
    80204c4e:	94e080e7          	jalr	-1714(ra) # 80200598 <printf>
        
        // 直接执行子进程函数
        struct proc *saved = current_proc;
    80204c52:	00005797          	auipc	a5,0x5
    80204c56:	3de78793          	addi	a5,a5,990 # 8020a030 <current_proc>
    80204c5a:	639c                	ld	a5,0(a5)
    80204c5c:	fcf43423          	sd	a5,-56(s0)
        current_proc = child;
    80204c60:	00005797          	auipc	a5,0x5
    80204c64:	3d078793          	addi	a5,a5,976 # 8020a030 <current_proc>
    80204c68:	fe843703          	ld	a4,-24(s0)
    80204c6c:	e398                	sd	a4,0(a5)
        simple_task();  // 执行但不调度
    80204c6e:	00000097          	auipc	ra,0x0
    80204c72:	ad6080e7          	jalr	-1322(ra) # 80204744 <simple_task>
        current_proc = saved;
    80204c76:	00005797          	auipc	a5,0x5
    80204c7a:	3ba78793          	addi	a5,a5,954 # 8020a030 <current_proc>
    80204c7e:	fc843703          	ld	a4,-56(s0)
    80204c82:	e398                	sd	a4,0(a5)
        
        printf("Child process state after: %d\n", child->state);
    80204c84:	fe843783          	ld	a5,-24(s0)
    80204c88:	439c                	lw	a5,0(a5)
    80204c8a:	85be                	mv	a1,a5
    80204c8c:	00003517          	auipc	a0,0x3
    80204c90:	a2c50513          	addi	a0,a0,-1492 # 802076b8 <small_numbers+0x2498>
    80204c94:	ffffc097          	auipc	ra,0xffffc
    80204c98:	904080e7          	jalr	-1788(ra) # 80200598 <printf>
    }
    
    // 清理
    free_proc(init);
    80204c9c:	fd843503          	ld	a0,-40(s0)
    80204ca0:	fffff097          	auipc	ra,0xfffff
    80204ca4:	14e080e7          	jalr	334(ra) # 80203dee <free_proc>
    printf("Simplified test completed\n");
    80204ca8:	00003517          	auipc	a0,0x3
    80204cac:	a3050513          	addi	a0,a0,-1488 # 802076d8 <small_numbers+0x24b8>
    80204cb0:	ffffc097          	auipc	ra,0xffffc
    80204cb4:	8e8080e7          	jalr	-1816(ra) # 80200598 <printf>
}
    80204cb8:	0001                	nop
    80204cba:	70e2                	ld	ra,56(sp)
    80204cbc:	7442                	ld	s0,48(sp)
    80204cbe:	6121                	addi	sp,sp,64
    80204cc0:	8082                	ret
	...
