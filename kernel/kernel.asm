
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
void clear_screen(void);
// start函数：内核的C语言入口
void start(){
	// 初始化内核的重要组件
	// 内存页分配器
	pmm_init();
    80200032:	1101                	addi	sp,sp,-32 # 80204fe0 <small_numbers+0x1ec0>
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

    8020004c:	1101                	addi	sp,sp,-32
    8020004e:	ec22                	sd	s0,24(sp)
    80200050:	1000                	addi	s0,sp,32
    80200052:	fea43423          	sd	a0,-24(s0)
    // 进入操作系统后立即清屏
    80200056:	fe843783          	ld	a5,-24(s0)
    8020005a:	10079073          	csrw	sstatus,a5
    clear_screen();
    8020005e:	0001                	nop
    80200060:	6462                	ld	s0,24(sp)
    80200062:	6105                	addi	sp,sp,32
    80200064:	8082                	ret

0000000080200066 <intr_on>:
    uart_puts("===============================================\n");
    uart_puts("        RISC-V Operating System v1.0         \n");
    uart_puts("===============================================\n\n");
    //printf("[VP TEST] 当前已启用分页模式\n");

	trap_init();
    80200066:	1141                	addi	sp,sp,-16
    80200068:	e406                	sd	ra,8(sp)
    8020006a:	e022                	sd	s0,0(sp)
    8020006c:	0800                	addi	s0,sp,16
    uart_puts("\nSystem ready. Entering main loop...\n");
    8020006e:	00000097          	auipc	ra,0x0
    80200072:	fc4080e7          	jalr	-60(ra) # 80200032 <r_sstatus>
    80200076:	87aa                	mv	a5,a0
    80200078:	0027e793          	ori	a5,a5,2
    8020007c:	853e                	mv	a0,a5
    8020007e:	00000097          	auipc	ra,0x0
    80200082:	fce080e7          	jalr	-50(ra) # 8020004c <w_sstatus>
	// 允许中断
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
    8020009c:	d50080e7          	jalr	-688(ra) # 80201de8 <pmm_init>
	printf("[VP TEST] 尝试启用分页模式\n");
    802000a0:	00003517          	auipc	a0,0x3
    802000a4:	f6050513          	addi	a0,a0,-160 # 80203000 <etext>
    802000a8:	00000097          	auipc	ra,0x0
    802000ac:	3b4080e7          	jalr	948(ra) # 8020045c <printf>
	kvminit();
    802000b0:	00002097          	auipc	ra,0x2
    802000b4:	a58080e7          	jalr	-1448(ra) # 80201b08 <kvminit>
    kvminithart();
    802000b8:	00002097          	auipc	ra,0x2
    802000bc:	aa2080e7          	jalr	-1374(ra) # 80201b5a <kvminithart>
    clear_screen();
    802000c0:	00000097          	auipc	ra,0x0
    802000c4:	794080e7          	jalr	1940(ra) # 80200854 <clear_screen>
    uart_puts("===============================================\n");
    802000c8:	00003517          	auipc	a0,0x3
    802000cc:	f6050513          	addi	a0,a0,-160 # 80203028 <etext+0x28>
    802000d0:	00000097          	auipc	ra,0x0
    802000d4:	09e080e7          	jalr	158(ra) # 8020016e <uart_puts>
    uart_puts("        RISC-V Operating System v1.0         \n");
    802000d8:	00003517          	auipc	a0,0x3
    802000dc:	f8850513          	addi	a0,a0,-120 # 80203060 <etext+0x60>
    802000e0:	00000097          	auipc	ra,0x0
    802000e4:	08e080e7          	jalr	142(ra) # 8020016e <uart_puts>
    uart_puts("===============================================\n\n");
    802000e8:	00003517          	auipc	a0,0x3
    802000ec:	fa850513          	addi	a0,a0,-88 # 80203090 <etext+0x90>
    802000f0:	00000097          	auipc	ra,0x0
    802000f4:	07e080e7          	jalr	126(ra) # 8020016e <uart_puts>
	trap_init();
    802000f8:	00002097          	auipc	ra,0x2
    802000fc:	228080e7          	jalr	552(ra) # 80202320 <trap_init>
    uart_puts("\nSystem ready. Entering main loop...\n");
    80200100:	00003517          	auipc	a0,0x3
    80200104:	fc850513          	addi	a0,a0,-56 # 802030c8 <etext+0xc8>
    80200108:	00000097          	auipc	ra,0x0
    8020010c:	066080e7          	jalr	102(ra) # 8020016e <uart_puts>
    intr_on();
    80200110:	00000097          	auipc	ra,0x0
    80200114:	f56080e7          	jalr	-170(ra) # 80200066 <intr_on>
	test_timer_interrupt();
    80200118:	00002097          	auipc	ra,0x2
    8020011c:	354080e7          	jalr	852(ra) # 8020246c <test_timer_interrupt>
	printf("[KERNEL] Timer interrupt test finished!\n");
    80200120:	00003517          	auipc	a0,0x3
    80200124:	fd050513          	addi	a0,a0,-48 # 802030f0 <etext+0xf0>
    80200128:	00000097          	auipc	ra,0x0
    8020012c:	334080e7          	jalr	820(ra) # 8020045c <printf>
    // 主循环
	while(1){
    80200130:	0001                	nop
    80200132:	bffd                	j	80200130 <start+0xa0>

0000000080200134 <uart_putc>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))


void uart_putc(char c)
{
    80200134:	1101                	addi	sp,sp,-32
    80200136:	ec22                	sd	s0,24(sp)
    80200138:	1000                	addi	s0,sp,32
    8020013a:	87aa                	mv	a5,a0
    8020013c:	fef407a3          	sb	a5,-17(s0)
  // 等待发送缓冲区空闲
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80200140:	0001                	nop
    80200142:	100007b7          	lui	a5,0x10000
    80200146:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200148:	0007c783          	lbu	a5,0(a5)
    8020014c:	0ff7f793          	zext.b	a5,a5
    80200150:	2781                	sext.w	a5,a5
    80200152:	0207f793          	andi	a5,a5,32
    80200156:	2781                	sext.w	a5,a5
    80200158:	d7ed                	beqz	a5,80200142 <uart_putc+0xe>
    ;
  // 写入字符到发送寄存器
  WriteReg(THR, c);
    8020015a:	100007b7          	lui	a5,0x10000
    8020015e:	fef44703          	lbu	a4,-17(s0)
    80200162:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
}
    80200166:	0001                	nop
    80200168:	6462                	ld	s0,24(sp)
    8020016a:	6105                	addi	sp,sp,32
    8020016c:	8082                	ret

000000008020016e <uart_puts>:

// 成功后实现字符串输出
void uart_puts(char *s)
{
    8020016e:	7179                	addi	sp,sp,-48
    80200170:	f422                	sd	s0,40(sp)
    80200172:	1800                	addi	s0,sp,48
    80200174:	fca43c23          	sd	a0,-40(s0)
    if (!s) return;
    80200178:	fd843783          	ld	a5,-40(s0)
    8020017c:	c7b5                	beqz	a5,802001e8 <uart_puts+0x7a>
    
    while (*s) {
    8020017e:	a8b9                	j	802001dc <uart_puts+0x6e>
        // 批量检查：一次等待，发送多个字符
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80200180:	0001                	nop
    80200182:	100007b7          	lui	a5,0x10000
    80200186:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200188:	0007c783          	lbu	a5,0(a5)
    8020018c:	0ff7f793          	zext.b	a5,a5
    80200190:	2781                	sext.w	a5,a5
    80200192:	0207f793          	andi	a5,a5,32
    80200196:	2781                	sext.w	a5,a5
    80200198:	d7ed                	beqz	a5,80200182 <uart_puts+0x14>
            ;
            
        // 连续发送字符，直到缓冲区可能满或字符串结束
        int sent_count = 0;
    8020019a:	fe042623          	sw	zero,-20(s0)
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    8020019e:	a01d                	j	802001c4 <uart_puts+0x56>
            WriteReg(THR, *s);
    802001a0:	100007b7          	lui	a5,0x10000
    802001a4:	fd843703          	ld	a4,-40(s0)
    802001a8:	00074703          	lbu	a4,0(a4)
    802001ac:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
            s++;
    802001b0:	fd843783          	ld	a5,-40(s0)
    802001b4:	0785                	addi	a5,a5,1
    802001b6:	fcf43c23          	sd	a5,-40(s0)
            sent_count++;
    802001ba:	fec42783          	lw	a5,-20(s0)
    802001be:	2785                	addiw	a5,a5,1
    802001c0:	fef42623          	sw	a5,-20(s0)
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    802001c4:	fd843783          	ld	a5,-40(s0)
    802001c8:	0007c783          	lbu	a5,0(a5)
    802001cc:	cb81                	beqz	a5,802001dc <uart_puts+0x6e>
    802001ce:	fec42783          	lw	a5,-20(s0)
    802001d2:	0007871b          	sext.w	a4,a5
    802001d6:	478d                	li	a5,3
    802001d8:	fce7d4e3          	bge	a5,a4,802001a0 <uart_puts+0x32>
    while (*s) {
    802001dc:	fd843783          	ld	a5,-40(s0)
    802001e0:	0007c783          	lbu	a5,0(a5)
    802001e4:	ffd1                	bnez	a5,80200180 <uart_puts+0x12>
    802001e6:	a011                	j	802001ea <uart_puts+0x7c>
    if (!s) return;
    802001e8:	0001                	nop
        }
    }
    802001ea:	7422                	ld	s0,40(sp)
    802001ec:	6145                	addi	sp,sp,48
    802001ee:	8082                	ret

00000000802001f0 <flush_printf_buffer>:
#define PRINTF_BUFFER_SIZE 128
extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    802001f0:	1141                	addi	sp,sp,-16
    802001f2:	e406                	sd	ra,8(sp)
    802001f4:	e022                	sd	s0,0(sp)
    802001f6:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    802001f8:	00006797          	auipc	a5,0x6
    802001fc:	eb878793          	addi	a5,a5,-328 # 802060b0 <printf_buf_pos>
    80200200:	439c                	lw	a5,0(a5)
    80200202:	02f05c63          	blez	a5,8020023a <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200206:	00006797          	auipc	a5,0x6
    8020020a:	eaa78793          	addi	a5,a5,-342 # 802060b0 <printf_buf_pos>
    8020020e:	439c                	lw	a5,0(a5)
    80200210:	00006717          	auipc	a4,0x6
    80200214:	e2070713          	addi	a4,a4,-480 # 80206030 <printf_buffer>
    80200218:	97ba                	add	a5,a5,a4
    8020021a:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    8020021e:	00006517          	auipc	a0,0x6
    80200222:	e1250513          	addi	a0,a0,-494 # 80206030 <printf_buffer>
    80200226:	00000097          	auipc	ra,0x0
    8020022a:	f48080e7          	jalr	-184(ra) # 8020016e <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    8020022e:	00006797          	auipc	a5,0x6
    80200232:	e8278793          	addi	a5,a5,-382 # 802060b0 <printf_buf_pos>
    80200236:	0007a023          	sw	zero,0(a5)
	}
}
    8020023a:	0001                	nop
    8020023c:	60a2                	ld	ra,8(sp)
    8020023e:	6402                	ld	s0,0(sp)
    80200240:	0141                	addi	sp,sp,16
    80200242:	8082                	ret

0000000080200244 <buffer_char>:
static void buffer_char(char c) {
    80200244:	1101                	addi	sp,sp,-32
    80200246:	ec06                	sd	ra,24(sp)
    80200248:	e822                	sd	s0,16(sp)
    8020024a:	1000                	addi	s0,sp,32
    8020024c:	87aa                	mv	a5,a0
    8020024e:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    80200252:	00006797          	auipc	a5,0x6
    80200256:	e5e78793          	addi	a5,a5,-418 # 802060b0 <printf_buf_pos>
    8020025a:	439c                	lw	a5,0(a5)
    8020025c:	873e                	mv	a4,a5
    8020025e:	07e00793          	li	a5,126
    80200262:	02e7ca63          	blt	a5,a4,80200296 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200266:	00006797          	auipc	a5,0x6
    8020026a:	e4a78793          	addi	a5,a5,-438 # 802060b0 <printf_buf_pos>
    8020026e:	439c                	lw	a5,0(a5)
    80200270:	0017871b          	addiw	a4,a5,1
    80200274:	0007069b          	sext.w	a3,a4
    80200278:	00006717          	auipc	a4,0x6
    8020027c:	e3870713          	addi	a4,a4,-456 # 802060b0 <printf_buf_pos>
    80200280:	c314                	sw	a3,0(a4)
    80200282:	00006717          	auipc	a4,0x6
    80200286:	dae70713          	addi	a4,a4,-594 # 80206030 <printf_buffer>
    8020028a:	97ba                	add	a5,a5,a4
    8020028c:	fef44703          	lbu	a4,-17(s0)
    80200290:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    80200294:	a825                	j	802002cc <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    80200296:	00000097          	auipc	ra,0x0
    8020029a:	f5a080e7          	jalr	-166(ra) # 802001f0 <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    8020029e:	00006797          	auipc	a5,0x6
    802002a2:	e1278793          	addi	a5,a5,-494 # 802060b0 <printf_buf_pos>
    802002a6:	439c                	lw	a5,0(a5)
    802002a8:	0017871b          	addiw	a4,a5,1
    802002ac:	0007069b          	sext.w	a3,a4
    802002b0:	00006717          	auipc	a4,0x6
    802002b4:	e0070713          	addi	a4,a4,-512 # 802060b0 <printf_buf_pos>
    802002b8:	c314                	sw	a3,0(a4)
    802002ba:	00006717          	auipc	a4,0x6
    802002be:	d7670713          	addi	a4,a4,-650 # 80206030 <printf_buffer>
    802002c2:	97ba                	add	a5,a5,a4
    802002c4:	fef44703          	lbu	a4,-17(s0)
    802002c8:	00e78023          	sb	a4,0(a5)
}
    802002cc:	0001                	nop
    802002ce:	60e2                	ld	ra,24(sp)
    802002d0:	6442                	ld	s0,16(sp)
    802002d2:	6105                	addi	sp,sp,32
    802002d4:	8082                	ret

00000000802002d6 <consputc>:
    "70", "71", "72", "73", "74", "75", "76", "77", "78", "79",
    "80", "81", "82", "83", "84", "85", "86", "87", "88", "89",
    "90", "91", "92", "93", "94", "95", "96", "97", "98", "99"
};

static void consputc(int c){
    802002d6:	1101                	addi	sp,sp,-32
    802002d8:	ec06                	sd	ra,24(sp)
    802002da:	e822                	sd	s0,16(sp)
    802002dc:	1000                	addi	s0,sp,32
    802002de:	87aa                	mv	a5,a0
    802002e0:	fef42623          	sw	a5,-20(s0)
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
    802002e4:	fec42783          	lw	a5,-20(s0)
    802002e8:	0ff7f793          	zext.b	a5,a5
    802002ec:	853e                	mv	a0,a5
    802002ee:	00000097          	auipc	ra,0x0
    802002f2:	e46080e7          	jalr	-442(ra) # 80200134 <uart_putc>
}
    802002f6:	0001                	nop
    802002f8:	60e2                	ld	ra,24(sp)
    802002fa:	6442                	ld	s0,16(sp)
    802002fc:	6105                	addi	sp,sp,32
    802002fe:	8082                	ret

0000000080200300 <consputs>:
static void consputs(const char *s){
    80200300:	7179                	addi	sp,sp,-48
    80200302:	f406                	sd	ra,40(sp)
    80200304:	f022                	sd	s0,32(sp)
    80200306:	1800                	addi	s0,sp,48
    80200308:	fca43c23          	sd	a0,-40(s0)
	char *str = (char *)s;
    8020030c:	fd843783          	ld	a5,-40(s0)
    80200310:	fef43423          	sd	a5,-24(s0)
	// 直接调用uart_puts输出字符串
	uart_puts(str);
    80200314:	fe843503          	ld	a0,-24(s0)
    80200318:	00000097          	auipc	ra,0x0
    8020031c:	e56080e7          	jalr	-426(ra) # 8020016e <uart_puts>
}
    80200320:	0001                	nop
    80200322:	70a2                	ld	ra,40(sp)
    80200324:	7402                	ld	s0,32(sp)
    80200326:	6145                	addi	sp,sp,48
    80200328:	8082                	ret

000000008020032a <printint>:
static void printint(long long xx,int base,int sign){
    8020032a:	715d                	addi	sp,sp,-80
    8020032c:	e486                	sd	ra,72(sp)
    8020032e:	e0a2                	sd	s0,64(sp)
    80200330:	0880                	addi	s0,sp,80
    80200332:	faa43c23          	sd	a0,-72(s0)
    80200336:	87ae                	mv	a5,a1
    80200338:	8732                	mv	a4,a2
    8020033a:	faf42a23          	sw	a5,-76(s0)
    8020033e:	87ba                	mv	a5,a4
    80200340:	faf42823          	sw	a5,-80(s0)
	// 模仿xv6的printint
	static char digits[] = "0123456789abcdef";
	char buf[20]; // 增大缓冲区以处理64位整数
	int i;
	unsigned long long x;
	if (sign && (sign = xx < 0)) // 符号处理
    80200344:	fb042783          	lw	a5,-80(s0)
    80200348:	2781                	sext.w	a5,a5
    8020034a:	c39d                	beqz	a5,80200370 <printint+0x46>
    8020034c:	fb843783          	ld	a5,-72(s0)
    80200350:	93fd                	srli	a5,a5,0x3f
    80200352:	0ff7f793          	zext.b	a5,a5
    80200356:	faf42823          	sw	a5,-80(s0)
    8020035a:	fb042783          	lw	a5,-80(s0)
    8020035e:	2781                	sext.w	a5,a5
    80200360:	cb81                	beqz	a5,80200370 <printint+0x46>
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    80200362:	fb843783          	ld	a5,-72(s0)
    80200366:	40f007b3          	neg	a5,a5
    8020036a:	fef43023          	sd	a5,-32(s0)
    8020036e:	a029                	j	80200378 <printint+0x4e>
	else
		x = xx;
    80200370:	fb843783          	ld	a5,-72(s0)
    80200374:	fef43023          	sd	a5,-32(s0)

	if (base == 10 && x < 100) {
    80200378:	fb442783          	lw	a5,-76(s0)
    8020037c:	0007871b          	sext.w	a4,a5
    80200380:	47a9                	li	a5,10
    80200382:	02f71763          	bne	a4,a5,802003b0 <printint+0x86>
    80200386:	fe043703          	ld	a4,-32(s0)
    8020038a:	06300793          	li	a5,99
    8020038e:	02e7e163          	bltu	a5,a4,802003b0 <printint+0x86>
		// 使用查表法处理小数字
		consputs(small_numbers[x]);
    80200392:	fe043783          	ld	a5,-32(s0)
    80200396:	00279713          	slli	a4,a5,0x2
    8020039a:	00003797          	auipc	a5,0x3
    8020039e:	d8678793          	addi	a5,a5,-634 # 80203120 <small_numbers>
    802003a2:	97ba                	add	a5,a5,a4
    802003a4:	853e                	mv	a0,a5
    802003a6:	00000097          	auipc	ra,0x0
    802003aa:	f5a080e7          	jalr	-166(ra) # 80200300 <consputs>
    802003ae:	a05d                	j	80200454 <printint+0x12a>
		return;
	}
	i = 0;
    802003b0:	fe042623          	sw	zero,-20(s0)
	do{
		buf[i] = digits[x % base];
    802003b4:	fb442783          	lw	a5,-76(s0)
    802003b8:	fe043703          	ld	a4,-32(s0)
    802003bc:	02f777b3          	remu	a5,a4,a5
    802003c0:	00006717          	auipc	a4,0x6
    802003c4:	c4070713          	addi	a4,a4,-960 # 80206000 <digits.0>
    802003c8:	97ba                	add	a5,a5,a4
    802003ca:	0007c703          	lbu	a4,0(a5)
    802003ce:	fec42783          	lw	a5,-20(s0)
    802003d2:	17c1                	addi	a5,a5,-16
    802003d4:	97a2                	add	a5,a5,s0
    802003d6:	fce78c23          	sb	a4,-40(a5)
		i++;
    802003da:	fec42783          	lw	a5,-20(s0)
    802003de:	2785                	addiw	a5,a5,1
    802003e0:	fef42623          	sw	a5,-20(s0)
	}while((x/=base) !=0);
    802003e4:	fb442783          	lw	a5,-76(s0)
    802003e8:	fe043703          	ld	a4,-32(s0)
    802003ec:	02f757b3          	divu	a5,a4,a5
    802003f0:	fef43023          	sd	a5,-32(s0)
    802003f4:	fe043783          	ld	a5,-32(s0)
    802003f8:	ffd5                	bnez	a5,802003b4 <printint+0x8a>
	if (sign){
    802003fa:	fb042783          	lw	a5,-80(s0)
    802003fe:	2781                	sext.w	a5,a5
    80200400:	cf91                	beqz	a5,8020041c <printint+0xf2>
		buf[i] = '-';
    80200402:	fec42783          	lw	a5,-20(s0)
    80200406:	17c1                	addi	a5,a5,-16
    80200408:	97a2                	add	a5,a5,s0
    8020040a:	02d00713          	li	a4,45
    8020040e:	fce78c23          	sb	a4,-40(a5)
		i++;
    80200412:	fec42783          	lw	a5,-20(s0)
    80200416:	2785                	addiw	a5,a5,1
    80200418:	fef42623          	sw	a5,-20(s0)
	}
	i--;
    8020041c:	fec42783          	lw	a5,-20(s0)
    80200420:	37fd                	addiw	a5,a5,-1
    80200422:	fef42623          	sw	a5,-20(s0)
	while( i>=0){
    80200426:	a015                	j	8020044a <printint+0x120>
		consputc(buf[i]);
    80200428:	fec42783          	lw	a5,-20(s0)
    8020042c:	17c1                	addi	a5,a5,-16
    8020042e:	97a2                	add	a5,a5,s0
    80200430:	fd87c783          	lbu	a5,-40(a5)
    80200434:	2781                	sext.w	a5,a5
    80200436:	853e                	mv	a0,a5
    80200438:	00000097          	auipc	ra,0x0
    8020043c:	e9e080e7          	jalr	-354(ra) # 802002d6 <consputc>
		i--;
    80200440:	fec42783          	lw	a5,-20(s0)
    80200444:	37fd                	addiw	a5,a5,-1
    80200446:	fef42623          	sw	a5,-20(s0)
	while( i>=0){
    8020044a:	fec42783          	lw	a5,-20(s0)
    8020044e:	2781                	sext.w	a5,a5
    80200450:	fc07dce3          	bgez	a5,80200428 <printint+0xfe>
	}
}
    80200454:	60a6                	ld	ra,72(sp)
    80200456:	6406                	ld	s0,64(sp)
    80200458:	6161                	addi	sp,sp,80
    8020045a:	8082                	ret

000000008020045c <printf>:
void printf(const char *fmt, ...) {
    8020045c:	7171                	addi	sp,sp,-176
    8020045e:	f486                	sd	ra,104(sp)
    80200460:	f0a2                	sd	s0,96(sp)
    80200462:	1880                	addi	s0,sp,112
    80200464:	f8a43c23          	sd	a0,-104(s0)
    80200468:	e40c                	sd	a1,8(s0)
    8020046a:	e810                	sd	a2,16(s0)
    8020046c:	ec14                	sd	a3,24(s0)
    8020046e:	f018                	sd	a4,32(s0)
    80200470:	f41c                	sd	a5,40(s0)
    80200472:	03043823          	sd	a6,48(s0)
    80200476:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    8020047a:	04040793          	addi	a5,s0,64
    8020047e:	f8f43823          	sd	a5,-112(s0)
    80200482:	f9043783          	ld	a5,-112(s0)
    80200486:	fc878793          	addi	a5,a5,-56
    8020048a:	fcf43023          	sd	a5,-64(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8020048e:	fe042623          	sw	zero,-20(s0)
    80200492:	a671                	j	8020081e <printf+0x3c2>
        if(c != '%'){
    80200494:	fe842783          	lw	a5,-24(s0)
    80200498:	0007871b          	sext.w	a4,a5
    8020049c:	02500793          	li	a5,37
    802004a0:	00f70c63          	beq	a4,a5,802004b8 <printf+0x5c>
            buffer_char(c);
    802004a4:	fe842783          	lw	a5,-24(s0)
    802004a8:	0ff7f793          	zext.b	a5,a5
    802004ac:	853e                	mv	a0,a5
    802004ae:	00000097          	auipc	ra,0x0
    802004b2:	d96080e7          	jalr	-618(ra) # 80200244 <buffer_char>
            continue;
    802004b6:	aeb9                	j	80200814 <printf+0x3b8>
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    802004b8:	00000097          	auipc	ra,0x0
    802004bc:	d38080e7          	jalr	-712(ra) # 802001f0 <flush_printf_buffer>
        c = fmt[++i] & 0xff;
    802004c0:	fec42783          	lw	a5,-20(s0)
    802004c4:	2785                	addiw	a5,a5,1
    802004c6:	fef42623          	sw	a5,-20(s0)
    802004ca:	fec42783          	lw	a5,-20(s0)
    802004ce:	f9843703          	ld	a4,-104(s0)
    802004d2:	97ba                	add	a5,a5,a4
    802004d4:	0007c783          	lbu	a5,0(a5)
    802004d8:	fef42423          	sw	a5,-24(s0)
        if(c == 0)
    802004dc:	fe842783          	lw	a5,-24(s0)
    802004e0:	2781                	sext.w	a5,a5
    802004e2:	34078d63          	beqz	a5,8020083c <printf+0x3e0>
            break;
            
        // 检查是否有长整型标记'l'
        int is_long = 0;
    802004e6:	fc042e23          	sw	zero,-36(s0)
        if(c == 'l') {
    802004ea:	fe842783          	lw	a5,-24(s0)
    802004ee:	0007871b          	sext.w	a4,a5
    802004f2:	06c00793          	li	a5,108
    802004f6:	02f71863          	bne	a4,a5,80200526 <printf+0xca>
            is_long = 1;
    802004fa:	4785                	li	a5,1
    802004fc:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    80200500:	fec42783          	lw	a5,-20(s0)
    80200504:	2785                	addiw	a5,a5,1
    80200506:	fef42623          	sw	a5,-20(s0)
    8020050a:	fec42783          	lw	a5,-20(s0)
    8020050e:	f9843703          	ld	a4,-104(s0)
    80200512:	97ba                	add	a5,a5,a4
    80200514:	0007c783          	lbu	a5,0(a5)
    80200518:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    8020051c:	fe842783          	lw	a5,-24(s0)
    80200520:	2781                	sext.w	a5,a5
    80200522:	30078f63          	beqz	a5,80200840 <printf+0x3e4>
                break;
        }
        
        switch(c){
    80200526:	fe842783          	lw	a5,-24(s0)
    8020052a:	0007871b          	sext.w	a4,a5
    8020052e:	02500793          	li	a5,37
    80200532:	2af70063          	beq	a4,a5,802007d2 <printf+0x376>
    80200536:	fe842783          	lw	a5,-24(s0)
    8020053a:	0007871b          	sext.w	a4,a5
    8020053e:	02500793          	li	a5,37
    80200542:	28f74f63          	blt	a4,a5,802007e0 <printf+0x384>
    80200546:	fe842783          	lw	a5,-24(s0)
    8020054a:	0007871b          	sext.w	a4,a5
    8020054e:	07800793          	li	a5,120
    80200552:	28e7c763          	blt	a5,a4,802007e0 <printf+0x384>
    80200556:	fe842783          	lw	a5,-24(s0)
    8020055a:	0007871b          	sext.w	a4,a5
    8020055e:	06200793          	li	a5,98
    80200562:	26f74f63          	blt	a4,a5,802007e0 <printf+0x384>
    80200566:	fe842783          	lw	a5,-24(s0)
    8020056a:	f9e7869b          	addiw	a3,a5,-98
    8020056e:	0006871b          	sext.w	a4,a3
    80200572:	47d9                	li	a5,22
    80200574:	26e7e663          	bltu	a5,a4,802007e0 <printf+0x384>
    80200578:	02069793          	slli	a5,a3,0x20
    8020057c:	9381                	srli	a5,a5,0x20
    8020057e:	00279713          	slli	a4,a5,0x2
    80200582:	00003797          	auipc	a5,0x3
    80200586:	d5278793          	addi	a5,a5,-686 # 802032d4 <small_numbers+0x1b4>
    8020058a:	97ba                	add	a5,a5,a4
    8020058c:	439c                	lw	a5,0(a5)
    8020058e:	0007871b          	sext.w	a4,a5
    80200592:	00003797          	auipc	a5,0x3
    80200596:	d4278793          	addi	a5,a5,-702 # 802032d4 <small_numbers+0x1b4>
    8020059a:	97ba                	add	a5,a5,a4
    8020059c:	8782                	jr	a5
        case 'd':
            if(is_long)
    8020059e:	fdc42783          	lw	a5,-36(s0)
    802005a2:	2781                	sext.w	a5,a5
    802005a4:	c385                	beqz	a5,802005c4 <printf+0x168>
                printint(va_arg(ap, long long), 10, 1);
    802005a6:	fc043783          	ld	a5,-64(s0)
    802005aa:	00878713          	addi	a4,a5,8
    802005ae:	fce43023          	sd	a4,-64(s0)
    802005b2:	639c                	ld	a5,0(a5)
    802005b4:	4605                	li	a2,1
    802005b6:	45a9                	li	a1,10
    802005b8:	853e                	mv	a0,a5
    802005ba:	00000097          	auipc	ra,0x0
    802005be:	d70080e7          	jalr	-656(ra) # 8020032a <printint>
            else
                printint(va_arg(ap, int), 10, 1);
            break;
    802005c2:	ac89                	j	80200814 <printf+0x3b8>
                printint(va_arg(ap, int), 10, 1);
    802005c4:	fc043783          	ld	a5,-64(s0)
    802005c8:	00878713          	addi	a4,a5,8
    802005cc:	fce43023          	sd	a4,-64(s0)
    802005d0:	439c                	lw	a5,0(a5)
    802005d2:	4605                	li	a2,1
    802005d4:	45a9                	li	a1,10
    802005d6:	853e                	mv	a0,a5
    802005d8:	00000097          	auipc	ra,0x0
    802005dc:	d52080e7          	jalr	-686(ra) # 8020032a <printint>
            break;
    802005e0:	ac15                	j	80200814 <printf+0x3b8>
        case 'x':
            if(is_long)
    802005e2:	fdc42783          	lw	a5,-36(s0)
    802005e6:	2781                	sext.w	a5,a5
    802005e8:	c385                	beqz	a5,80200608 <printf+0x1ac>
                printint(va_arg(ap, long long), 16, 0);
    802005ea:	fc043783          	ld	a5,-64(s0)
    802005ee:	00878713          	addi	a4,a5,8
    802005f2:	fce43023          	sd	a4,-64(s0)
    802005f6:	639c                	ld	a5,0(a5)
    802005f8:	4601                	li	a2,0
    802005fa:	45c1                	li	a1,16
    802005fc:	853e                	mv	a0,a5
    802005fe:	00000097          	auipc	ra,0x0
    80200602:	d2c080e7          	jalr	-724(ra) # 8020032a <printint>
            else
                printint(va_arg(ap, int), 16, 0);
            break;
    80200606:	a439                	j	80200814 <printf+0x3b8>
                printint(va_arg(ap, int), 16, 0);
    80200608:	fc043783          	ld	a5,-64(s0)
    8020060c:	00878713          	addi	a4,a5,8
    80200610:	fce43023          	sd	a4,-64(s0)
    80200614:	439c                	lw	a5,0(a5)
    80200616:	4601                	li	a2,0
    80200618:	45c1                	li	a1,16
    8020061a:	853e                	mv	a0,a5
    8020061c:	00000097          	auipc	ra,0x0
    80200620:	d0e080e7          	jalr	-754(ra) # 8020032a <printint>
            break;
    80200624:	aac5                	j	80200814 <printf+0x3b8>
        case 'u':
            if(is_long)
    80200626:	fdc42783          	lw	a5,-36(s0)
    8020062a:	2781                	sext.w	a5,a5
    8020062c:	c385                	beqz	a5,8020064c <printf+0x1f0>
                printint(va_arg(ap, unsigned long long), 10, 0);
    8020062e:	fc043783          	ld	a5,-64(s0)
    80200632:	00878713          	addi	a4,a5,8
    80200636:	fce43023          	sd	a4,-64(s0)
    8020063a:	639c                	ld	a5,0(a5)
    8020063c:	4601                	li	a2,0
    8020063e:	45a9                	li	a1,10
    80200640:	853e                	mv	a0,a5
    80200642:	00000097          	auipc	ra,0x0
    80200646:	ce8080e7          	jalr	-792(ra) # 8020032a <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0);
            break;
    8020064a:	a2e9                	j	80200814 <printf+0x3b8>
                printint(va_arg(ap, unsigned int), 10, 0);
    8020064c:	fc043783          	ld	a5,-64(s0)
    80200650:	00878713          	addi	a4,a5,8
    80200654:	fce43023          	sd	a4,-64(s0)
    80200658:	439c                	lw	a5,0(a5)
    8020065a:	1782                	slli	a5,a5,0x20
    8020065c:	9381                	srli	a5,a5,0x20
    8020065e:	4601                	li	a2,0
    80200660:	45a9                	li	a1,10
    80200662:	853e                	mv	a0,a5
    80200664:	00000097          	auipc	ra,0x0
    80200668:	cc6080e7          	jalr	-826(ra) # 8020032a <printint>
            break;
    8020066c:	a265                	j	80200814 <printf+0x3b8>
        case 'c':
            consputc(va_arg(ap, int));
    8020066e:	fc043783          	ld	a5,-64(s0)
    80200672:	00878713          	addi	a4,a5,8
    80200676:	fce43023          	sd	a4,-64(s0)
    8020067a:	439c                	lw	a5,0(a5)
    8020067c:	853e                	mv	a0,a5
    8020067e:	00000097          	auipc	ra,0x0
    80200682:	c58080e7          	jalr	-936(ra) # 802002d6 <consputc>
            break;
    80200686:	a279                	j	80200814 <printf+0x3b8>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80200688:	fc043783          	ld	a5,-64(s0)
    8020068c:	00878713          	addi	a4,a5,8
    80200690:	fce43023          	sd	a4,-64(s0)
    80200694:	639c                	ld	a5,0(a5)
    80200696:	fef43023          	sd	a5,-32(s0)
    8020069a:	fe043783          	ld	a5,-32(s0)
    8020069e:	e799                	bnez	a5,802006ac <printf+0x250>
                s = "(null)";
    802006a0:	00003797          	auipc	a5,0x3
    802006a4:	c1078793          	addi	a5,a5,-1008 # 802032b0 <small_numbers+0x190>
    802006a8:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    802006ac:	fe043503          	ld	a0,-32(s0)
    802006b0:	00000097          	auipc	ra,0x0
    802006b4:	c50080e7          	jalr	-944(ra) # 80200300 <consputs>
            break;
    802006b8:	aab1                	j	80200814 <printf+0x3b8>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    802006ba:	fc043783          	ld	a5,-64(s0)
    802006be:	00878713          	addi	a4,a5,8
    802006c2:	fce43023          	sd	a4,-64(s0)
    802006c6:	639c                	ld	a5,0(a5)
    802006c8:	fcf43823          	sd	a5,-48(s0)
            consputs("0x");
    802006cc:	00003517          	auipc	a0,0x3
    802006d0:	bec50513          	addi	a0,a0,-1044 # 802032b8 <small_numbers+0x198>
    802006d4:	00000097          	auipc	ra,0x0
    802006d8:	c2c080e7          	jalr	-980(ra) # 80200300 <consputs>
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    802006dc:	fc042c23          	sw	zero,-40(s0)
    802006e0:	a0a1                	j	80200728 <printf+0x2cc>
                int shift = (15 - i) * 4;
    802006e2:	47bd                	li	a5,15
    802006e4:	fd842703          	lw	a4,-40(s0)
    802006e8:	9f99                	subw	a5,a5,a4
    802006ea:	2781                	sext.w	a5,a5
    802006ec:	0027979b          	slliw	a5,a5,0x2
    802006f0:	fcf42623          	sw	a5,-52(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    802006f4:	fcc42783          	lw	a5,-52(s0)
    802006f8:	873e                	mv	a4,a5
    802006fa:	fd043783          	ld	a5,-48(s0)
    802006fe:	00e7d7b3          	srl	a5,a5,a4
    80200702:	8bbd                	andi	a5,a5,15
    80200704:	00003717          	auipc	a4,0x3
    80200708:	bbc70713          	addi	a4,a4,-1092 # 802032c0 <small_numbers+0x1a0>
    8020070c:	97ba                	add	a5,a5,a4
    8020070e:	0007c703          	lbu	a4,0(a5)
    80200712:	fd842783          	lw	a5,-40(s0)
    80200716:	17c1                	addi	a5,a5,-16
    80200718:	97a2                	add	a5,a5,s0
    8020071a:	fae78c23          	sb	a4,-72(a5)
            for (i = 0; i < 16; i++) {
    8020071e:	fd842783          	lw	a5,-40(s0)
    80200722:	2785                	addiw	a5,a5,1
    80200724:	fcf42c23          	sw	a5,-40(s0)
    80200728:	fd842783          	lw	a5,-40(s0)
    8020072c:	0007871b          	sext.w	a4,a5
    80200730:	47bd                	li	a5,15
    80200732:	fae7d8e3          	bge	a5,a4,802006e2 <printf+0x286>
            }
            buf[16] = '\0';
    80200736:	fa040c23          	sb	zero,-72(s0)
            consputs(buf);
    8020073a:	fa840793          	addi	a5,s0,-88
    8020073e:	853e                	mv	a0,a5
    80200740:	00000097          	auipc	ra,0x0
    80200744:	bc0080e7          	jalr	-1088(ra) # 80200300 <consputs>
            break;
    80200748:	a0f1                	j	80200814 <printf+0x3b8>
        case 'b':
            if(is_long)
    8020074a:	fdc42783          	lw	a5,-36(s0)
    8020074e:	2781                	sext.w	a5,a5
    80200750:	c385                	beqz	a5,80200770 <printf+0x314>
                printint(va_arg(ap, long long), 2, 0);
    80200752:	fc043783          	ld	a5,-64(s0)
    80200756:	00878713          	addi	a4,a5,8
    8020075a:	fce43023          	sd	a4,-64(s0)
    8020075e:	639c                	ld	a5,0(a5)
    80200760:	4601                	li	a2,0
    80200762:	4589                	li	a1,2
    80200764:	853e                	mv	a0,a5
    80200766:	00000097          	auipc	ra,0x0
    8020076a:	bc4080e7          	jalr	-1084(ra) # 8020032a <printint>
            else
                printint(va_arg(ap, int), 2, 0);
            break;
    8020076e:	a05d                	j	80200814 <printf+0x3b8>
                printint(va_arg(ap, int), 2, 0);
    80200770:	fc043783          	ld	a5,-64(s0)
    80200774:	00878713          	addi	a4,a5,8
    80200778:	fce43023          	sd	a4,-64(s0)
    8020077c:	439c                	lw	a5,0(a5)
    8020077e:	4601                	li	a2,0
    80200780:	4589                	li	a1,2
    80200782:	853e                	mv	a0,a5
    80200784:	00000097          	auipc	ra,0x0
    80200788:	ba6080e7          	jalr	-1114(ra) # 8020032a <printint>
            break;
    8020078c:	a061                	j	80200814 <printf+0x3b8>
        case 'o':
            if(is_long)
    8020078e:	fdc42783          	lw	a5,-36(s0)
    80200792:	2781                	sext.w	a5,a5
    80200794:	c385                	beqz	a5,802007b4 <printf+0x358>
                printint(va_arg(ap, long long), 8, 0);
    80200796:	fc043783          	ld	a5,-64(s0)
    8020079a:	00878713          	addi	a4,a5,8
    8020079e:	fce43023          	sd	a4,-64(s0)
    802007a2:	639c                	ld	a5,0(a5)
    802007a4:	4601                	li	a2,0
    802007a6:	45a1                	li	a1,8
    802007a8:	853e                	mv	a0,a5
    802007aa:	00000097          	auipc	ra,0x0
    802007ae:	b80080e7          	jalr	-1152(ra) # 8020032a <printint>
            else
                printint(va_arg(ap, int), 8, 0);
            break;
    802007b2:	a08d                	j	80200814 <printf+0x3b8>
                printint(va_arg(ap, int), 8, 0);
    802007b4:	fc043783          	ld	a5,-64(s0)
    802007b8:	00878713          	addi	a4,a5,8
    802007bc:	fce43023          	sd	a4,-64(s0)
    802007c0:	439c                	lw	a5,0(a5)
    802007c2:	4601                	li	a2,0
    802007c4:	45a1                	li	a1,8
    802007c6:	853e                	mv	a0,a5
    802007c8:	00000097          	auipc	ra,0x0
    802007cc:	b62080e7          	jalr	-1182(ra) # 8020032a <printint>
            break;
    802007d0:	a091                	j	80200814 <printf+0x3b8>
        case '%':
            buffer_char('%');
    802007d2:	02500513          	li	a0,37
    802007d6:	00000097          	auipc	ra,0x0
    802007da:	a6e080e7          	jalr	-1426(ra) # 80200244 <buffer_char>
            break;
    802007de:	a81d                	j	80200814 <printf+0x3b8>
        default:
            buffer_char('%');
    802007e0:	02500513          	li	a0,37
    802007e4:	00000097          	auipc	ra,0x0
    802007e8:	a60080e7          	jalr	-1440(ra) # 80200244 <buffer_char>
            if(is_long) buffer_char('l');
    802007ec:	fdc42783          	lw	a5,-36(s0)
    802007f0:	2781                	sext.w	a5,a5
    802007f2:	c799                	beqz	a5,80200800 <printf+0x3a4>
    802007f4:	06c00513          	li	a0,108
    802007f8:	00000097          	auipc	ra,0x0
    802007fc:	a4c080e7          	jalr	-1460(ra) # 80200244 <buffer_char>
            buffer_char(c);
    80200800:	fe842783          	lw	a5,-24(s0)
    80200804:	0ff7f793          	zext.b	a5,a5
    80200808:	853e                	mv	a0,a5
    8020080a:	00000097          	auipc	ra,0x0
    8020080e:	a3a080e7          	jalr	-1478(ra) # 80200244 <buffer_char>
            break;
    80200812:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200814:	fec42783          	lw	a5,-20(s0)
    80200818:	2785                	addiw	a5,a5,1
    8020081a:	fef42623          	sw	a5,-20(s0)
    8020081e:	fec42783          	lw	a5,-20(s0)
    80200822:	f9843703          	ld	a4,-104(s0)
    80200826:	97ba                	add	a5,a5,a4
    80200828:	0007c783          	lbu	a5,0(a5)
    8020082c:	fef42423          	sw	a5,-24(s0)
    80200830:	fe842783          	lw	a5,-24(s0)
    80200834:	2781                	sext.w	a5,a5
    80200836:	c4079fe3          	bnez	a5,80200494 <printf+0x38>
    8020083a:	a021                	j	80200842 <printf+0x3e6>
            break;
    8020083c:	0001                	nop
    8020083e:	a011                	j	80200842 <printf+0x3e6>
                break;
    80200840:	0001                	nop
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    80200842:	00000097          	auipc	ra,0x0
    80200846:	9ae080e7          	jalr	-1618(ra) # 802001f0 <flush_printf_buffer>
    va_end(ap);
}
    8020084a:	0001                	nop
    8020084c:	70a6                	ld	ra,104(sp)
    8020084e:	7406                	ld	s0,96(sp)
    80200850:	614d                	addi	sp,sp,176
    80200852:	8082                	ret

0000000080200854 <clear_screen>:
// 清屏功能
void clear_screen(void) {
    80200854:	1141                	addi	sp,sp,-16
    80200856:	e406                	sd	ra,8(sp)
    80200858:	e022                	sd	s0,0(sp)
    8020085a:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    8020085c:	00003517          	auipc	a0,0x3
    80200860:	ad450513          	addi	a0,a0,-1324 # 80203330 <small_numbers+0x210>
    80200864:	00000097          	auipc	ra,0x0
    80200868:	90a080e7          	jalr	-1782(ra) # 8020016e <uart_puts>
	uart_puts(CURSOR_HOME);
    8020086c:	00003517          	auipc	a0,0x3
    80200870:	acc50513          	addi	a0,a0,-1332 # 80203338 <small_numbers+0x218>
    80200874:	00000097          	auipc	ra,0x0
    80200878:	8fa080e7          	jalr	-1798(ra) # 8020016e <uart_puts>
}
    8020087c:	0001                	nop
    8020087e:	60a2                	ld	ra,8(sp)
    80200880:	6402                	ld	s0,0(sp)
    80200882:	0141                	addi	sp,sp,16
    80200884:	8082                	ret

0000000080200886 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    80200886:	1101                	addi	sp,sp,-32
    80200888:	ec06                	sd	ra,24(sp)
    8020088a:	e822                	sd	s0,16(sp)
    8020088c:	1000                	addi	s0,sp,32
    8020088e:	87aa                	mv	a5,a0
    80200890:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    80200894:	fec42783          	lw	a5,-20(s0)
    80200898:	2781                	sext.w	a5,a5
    8020089a:	02f05d63          	blez	a5,802008d4 <cursor_up+0x4e>
    consputc('\033');
    8020089e:	456d                	li	a0,27
    802008a0:	00000097          	auipc	ra,0x0
    802008a4:	a36080e7          	jalr	-1482(ra) # 802002d6 <consputc>
    consputc('[');
    802008a8:	05b00513          	li	a0,91
    802008ac:	00000097          	auipc	ra,0x0
    802008b0:	a2a080e7          	jalr	-1494(ra) # 802002d6 <consputc>
    printint(lines, 10, 0);
    802008b4:	fec42783          	lw	a5,-20(s0)
    802008b8:	4601                	li	a2,0
    802008ba:	45a9                	li	a1,10
    802008bc:	853e                	mv	a0,a5
    802008be:	00000097          	auipc	ra,0x0
    802008c2:	a6c080e7          	jalr	-1428(ra) # 8020032a <printint>
    consputc('A');
    802008c6:	04100513          	li	a0,65
    802008ca:	00000097          	auipc	ra,0x0
    802008ce:	a0c080e7          	jalr	-1524(ra) # 802002d6 <consputc>
    802008d2:	a011                	j	802008d6 <cursor_up+0x50>
    if (lines <= 0) return;
    802008d4:	0001                	nop
}
    802008d6:	60e2                	ld	ra,24(sp)
    802008d8:	6442                	ld	s0,16(sp)
    802008da:	6105                	addi	sp,sp,32
    802008dc:	8082                	ret

00000000802008de <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    802008de:	1101                	addi	sp,sp,-32
    802008e0:	ec06                	sd	ra,24(sp)
    802008e2:	e822                	sd	s0,16(sp)
    802008e4:	1000                	addi	s0,sp,32
    802008e6:	87aa                	mv	a5,a0
    802008e8:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    802008ec:	fec42783          	lw	a5,-20(s0)
    802008f0:	2781                	sext.w	a5,a5
    802008f2:	02f05d63          	blez	a5,8020092c <cursor_down+0x4e>
    consputc('\033');
    802008f6:	456d                	li	a0,27
    802008f8:	00000097          	auipc	ra,0x0
    802008fc:	9de080e7          	jalr	-1570(ra) # 802002d6 <consputc>
    consputc('[');
    80200900:	05b00513          	li	a0,91
    80200904:	00000097          	auipc	ra,0x0
    80200908:	9d2080e7          	jalr	-1582(ra) # 802002d6 <consputc>
    printint(lines, 10, 0);
    8020090c:	fec42783          	lw	a5,-20(s0)
    80200910:	4601                	li	a2,0
    80200912:	45a9                	li	a1,10
    80200914:	853e                	mv	a0,a5
    80200916:	00000097          	auipc	ra,0x0
    8020091a:	a14080e7          	jalr	-1516(ra) # 8020032a <printint>
    consputc('B');
    8020091e:	04200513          	li	a0,66
    80200922:	00000097          	auipc	ra,0x0
    80200926:	9b4080e7          	jalr	-1612(ra) # 802002d6 <consputc>
    8020092a:	a011                	j	8020092e <cursor_down+0x50>
    if (lines <= 0) return;
    8020092c:	0001                	nop
}
    8020092e:	60e2                	ld	ra,24(sp)
    80200930:	6442                	ld	s0,16(sp)
    80200932:	6105                	addi	sp,sp,32
    80200934:	8082                	ret

0000000080200936 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    80200936:	1101                	addi	sp,sp,-32
    80200938:	ec06                	sd	ra,24(sp)
    8020093a:	e822                	sd	s0,16(sp)
    8020093c:	1000                	addi	s0,sp,32
    8020093e:	87aa                	mv	a5,a0
    80200940:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80200944:	fec42783          	lw	a5,-20(s0)
    80200948:	2781                	sext.w	a5,a5
    8020094a:	02f05d63          	blez	a5,80200984 <cursor_right+0x4e>
    consputc('\033');
    8020094e:	456d                	li	a0,27
    80200950:	00000097          	auipc	ra,0x0
    80200954:	986080e7          	jalr	-1658(ra) # 802002d6 <consputc>
    consputc('[');
    80200958:	05b00513          	li	a0,91
    8020095c:	00000097          	auipc	ra,0x0
    80200960:	97a080e7          	jalr	-1670(ra) # 802002d6 <consputc>
    printint(cols, 10, 0);
    80200964:	fec42783          	lw	a5,-20(s0)
    80200968:	4601                	li	a2,0
    8020096a:	45a9                	li	a1,10
    8020096c:	853e                	mv	a0,a5
    8020096e:	00000097          	auipc	ra,0x0
    80200972:	9bc080e7          	jalr	-1604(ra) # 8020032a <printint>
    consputc('C');
    80200976:	04300513          	li	a0,67
    8020097a:	00000097          	auipc	ra,0x0
    8020097e:	95c080e7          	jalr	-1700(ra) # 802002d6 <consputc>
    80200982:	a011                	j	80200986 <cursor_right+0x50>
    if (cols <= 0) return;
    80200984:	0001                	nop
}
    80200986:	60e2                	ld	ra,24(sp)
    80200988:	6442                	ld	s0,16(sp)
    8020098a:	6105                	addi	sp,sp,32
    8020098c:	8082                	ret

000000008020098e <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    8020098e:	1101                	addi	sp,sp,-32
    80200990:	ec06                	sd	ra,24(sp)
    80200992:	e822                	sd	s0,16(sp)
    80200994:	1000                	addi	s0,sp,32
    80200996:	87aa                	mv	a5,a0
    80200998:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    8020099c:	fec42783          	lw	a5,-20(s0)
    802009a0:	2781                	sext.w	a5,a5
    802009a2:	02f05d63          	blez	a5,802009dc <cursor_left+0x4e>
    consputc('\033');
    802009a6:	456d                	li	a0,27
    802009a8:	00000097          	auipc	ra,0x0
    802009ac:	92e080e7          	jalr	-1746(ra) # 802002d6 <consputc>
    consputc('[');
    802009b0:	05b00513          	li	a0,91
    802009b4:	00000097          	auipc	ra,0x0
    802009b8:	922080e7          	jalr	-1758(ra) # 802002d6 <consputc>
    printint(cols, 10, 0);
    802009bc:	fec42783          	lw	a5,-20(s0)
    802009c0:	4601                	li	a2,0
    802009c2:	45a9                	li	a1,10
    802009c4:	853e                	mv	a0,a5
    802009c6:	00000097          	auipc	ra,0x0
    802009ca:	964080e7          	jalr	-1692(ra) # 8020032a <printint>
    consputc('D');
    802009ce:	04400513          	li	a0,68
    802009d2:	00000097          	auipc	ra,0x0
    802009d6:	904080e7          	jalr	-1788(ra) # 802002d6 <consputc>
    802009da:	a011                	j	802009de <cursor_left+0x50>
    if (cols <= 0) return;
    802009dc:	0001                	nop
}
    802009de:	60e2                	ld	ra,24(sp)
    802009e0:	6442                	ld	s0,16(sp)
    802009e2:	6105                	addi	sp,sp,32
    802009e4:	8082                	ret

00000000802009e6 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    802009e6:	1141                	addi	sp,sp,-16
    802009e8:	e406                	sd	ra,8(sp)
    802009ea:	e022                	sd	s0,0(sp)
    802009ec:	0800                	addi	s0,sp,16
    consputc('\033');
    802009ee:	456d                	li	a0,27
    802009f0:	00000097          	auipc	ra,0x0
    802009f4:	8e6080e7          	jalr	-1818(ra) # 802002d6 <consputc>
    consputc('[');
    802009f8:	05b00513          	li	a0,91
    802009fc:	00000097          	auipc	ra,0x0
    80200a00:	8da080e7          	jalr	-1830(ra) # 802002d6 <consputc>
    consputc('s');
    80200a04:	07300513          	li	a0,115
    80200a08:	00000097          	auipc	ra,0x0
    80200a0c:	8ce080e7          	jalr	-1842(ra) # 802002d6 <consputc>
}
    80200a10:	0001                	nop
    80200a12:	60a2                	ld	ra,8(sp)
    80200a14:	6402                	ld	s0,0(sp)
    80200a16:	0141                	addi	sp,sp,16
    80200a18:	8082                	ret

0000000080200a1a <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    80200a1a:	1141                	addi	sp,sp,-16
    80200a1c:	e406                	sd	ra,8(sp)
    80200a1e:	e022                	sd	s0,0(sp)
    80200a20:	0800                	addi	s0,sp,16
    consputc('\033');
    80200a22:	456d                	li	a0,27
    80200a24:	00000097          	auipc	ra,0x0
    80200a28:	8b2080e7          	jalr	-1870(ra) # 802002d6 <consputc>
    consputc('[');
    80200a2c:	05b00513          	li	a0,91
    80200a30:	00000097          	auipc	ra,0x0
    80200a34:	8a6080e7          	jalr	-1882(ra) # 802002d6 <consputc>
    consputc('u');
    80200a38:	07500513          	li	a0,117
    80200a3c:	00000097          	auipc	ra,0x0
    80200a40:	89a080e7          	jalr	-1894(ra) # 802002d6 <consputc>
}
    80200a44:	0001                	nop
    80200a46:	60a2                	ld	ra,8(sp)
    80200a48:	6402                	ld	s0,0(sp)
    80200a4a:	0141                	addi	sp,sp,16
    80200a4c:	8082                	ret

0000000080200a4e <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    80200a4e:	1101                	addi	sp,sp,-32
    80200a50:	ec06                	sd	ra,24(sp)
    80200a52:	e822                	sd	s0,16(sp)
    80200a54:	1000                	addi	s0,sp,32
    80200a56:	87aa                	mv	a5,a0
    80200a58:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    80200a5c:	fec42783          	lw	a5,-20(s0)
    80200a60:	2781                	sext.w	a5,a5
    80200a62:	00f04563          	bgtz	a5,80200a6c <cursor_to_column+0x1e>
    80200a66:	4785                	li	a5,1
    80200a68:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    80200a6c:	456d                	li	a0,27
    80200a6e:	00000097          	auipc	ra,0x0
    80200a72:	868080e7          	jalr	-1944(ra) # 802002d6 <consputc>
    consputc('[');
    80200a76:	05b00513          	li	a0,91
    80200a7a:	00000097          	auipc	ra,0x0
    80200a7e:	85c080e7          	jalr	-1956(ra) # 802002d6 <consputc>
    printint(col, 10, 0);
    80200a82:	fec42783          	lw	a5,-20(s0)
    80200a86:	4601                	li	a2,0
    80200a88:	45a9                	li	a1,10
    80200a8a:	853e                	mv	a0,a5
    80200a8c:	00000097          	auipc	ra,0x0
    80200a90:	89e080e7          	jalr	-1890(ra) # 8020032a <printint>
    consputc('G');
    80200a94:	04700513          	li	a0,71
    80200a98:	00000097          	auipc	ra,0x0
    80200a9c:	83e080e7          	jalr	-1986(ra) # 802002d6 <consputc>
}
    80200aa0:	0001                	nop
    80200aa2:	60e2                	ld	ra,24(sp)
    80200aa4:	6442                	ld	s0,16(sp)
    80200aa6:	6105                	addi	sp,sp,32
    80200aa8:	8082                	ret

0000000080200aaa <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80200aaa:	1101                	addi	sp,sp,-32
    80200aac:	ec06                	sd	ra,24(sp)
    80200aae:	e822                	sd	s0,16(sp)
    80200ab0:	1000                	addi	s0,sp,32
    80200ab2:	87aa                	mv	a5,a0
    80200ab4:	872e                	mv	a4,a1
    80200ab6:	fef42623          	sw	a5,-20(s0)
    80200aba:	87ba                	mv	a5,a4
    80200abc:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    80200ac0:	456d                	li	a0,27
    80200ac2:	00000097          	auipc	ra,0x0
    80200ac6:	814080e7          	jalr	-2028(ra) # 802002d6 <consputc>
    consputc('[');
    80200aca:	05b00513          	li	a0,91
    80200ace:	00000097          	auipc	ra,0x0
    80200ad2:	808080e7          	jalr	-2040(ra) # 802002d6 <consputc>
    printint(row, 10, 0);
    80200ad6:	fec42783          	lw	a5,-20(s0)
    80200ada:	4601                	li	a2,0
    80200adc:	45a9                	li	a1,10
    80200ade:	853e                	mv	a0,a5
    80200ae0:	00000097          	auipc	ra,0x0
    80200ae4:	84a080e7          	jalr	-1974(ra) # 8020032a <printint>
    consputc(';');
    80200ae8:	03b00513          	li	a0,59
    80200aec:	fffff097          	auipc	ra,0xfffff
    80200af0:	7ea080e7          	jalr	2026(ra) # 802002d6 <consputc>
    printint(col, 10, 0);
    80200af4:	fe842783          	lw	a5,-24(s0)
    80200af8:	4601                	li	a2,0
    80200afa:	45a9                	li	a1,10
    80200afc:	853e                	mv	a0,a5
    80200afe:	00000097          	auipc	ra,0x0
    80200b02:	82c080e7          	jalr	-2004(ra) # 8020032a <printint>
    consputc('H');
    80200b06:	04800513          	li	a0,72
    80200b0a:	fffff097          	auipc	ra,0xfffff
    80200b0e:	7cc080e7          	jalr	1996(ra) # 802002d6 <consputc>
}
    80200b12:	0001                	nop
    80200b14:	60e2                	ld	ra,24(sp)
    80200b16:	6442                	ld	s0,16(sp)
    80200b18:	6105                	addi	sp,sp,32
    80200b1a:	8082                	ret

0000000080200b1c <reset_color>:
// 颜色控制
void reset_color(void) {
    80200b1c:	1141                	addi	sp,sp,-16
    80200b1e:	e406                	sd	ra,8(sp)
    80200b20:	e022                	sd	s0,0(sp)
    80200b22:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    80200b24:	00003517          	auipc	a0,0x3
    80200b28:	81c50513          	addi	a0,a0,-2020 # 80203340 <small_numbers+0x220>
    80200b2c:	fffff097          	auipc	ra,0xfffff
    80200b30:	642080e7          	jalr	1602(ra) # 8020016e <uart_puts>
}
    80200b34:	0001                	nop
    80200b36:	60a2                	ld	ra,8(sp)
    80200b38:	6402                	ld	s0,0(sp)
    80200b3a:	0141                	addi	sp,sp,16
    80200b3c:	8082                	ret

0000000080200b3e <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    80200b3e:	1101                	addi	sp,sp,-32
    80200b40:	ec06                	sd	ra,24(sp)
    80200b42:	e822                	sd	s0,16(sp)
    80200b44:	1000                	addi	s0,sp,32
    80200b46:	87aa                	mv	a5,a0
    80200b48:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    80200b4c:	fec42783          	lw	a5,-20(s0)
    80200b50:	0007871b          	sext.w	a4,a5
    80200b54:	47f5                	li	a5,29
    80200b56:	04e7d563          	bge	a5,a4,80200ba0 <set_fg_color+0x62>
    80200b5a:	fec42783          	lw	a5,-20(s0)
    80200b5e:	0007871b          	sext.w	a4,a5
    80200b62:	02500793          	li	a5,37
    80200b66:	02e7cd63          	blt	a5,a4,80200ba0 <set_fg_color+0x62>
	consputc('\033');
    80200b6a:	456d                	li	a0,27
    80200b6c:	fffff097          	auipc	ra,0xfffff
    80200b70:	76a080e7          	jalr	1898(ra) # 802002d6 <consputc>
	consputc('[');
    80200b74:	05b00513          	li	a0,91
    80200b78:	fffff097          	auipc	ra,0xfffff
    80200b7c:	75e080e7          	jalr	1886(ra) # 802002d6 <consputc>
	printint(color, 10, 0);
    80200b80:	fec42783          	lw	a5,-20(s0)
    80200b84:	4601                	li	a2,0
    80200b86:	45a9                	li	a1,10
    80200b88:	853e                	mv	a0,a5
    80200b8a:	fffff097          	auipc	ra,0xfffff
    80200b8e:	7a0080e7          	jalr	1952(ra) # 8020032a <printint>
	consputc('m');
    80200b92:	06d00513          	li	a0,109
    80200b96:	fffff097          	auipc	ra,0xfffff
    80200b9a:	740080e7          	jalr	1856(ra) # 802002d6 <consputc>
    80200b9e:	a011                	j	80200ba2 <set_fg_color+0x64>
	if (color < 30 || color > 37) return; // 支持30-37
    80200ba0:	0001                	nop
}
    80200ba2:	60e2                	ld	ra,24(sp)
    80200ba4:	6442                	ld	s0,16(sp)
    80200ba6:	6105                	addi	sp,sp,32
    80200ba8:	8082                	ret

0000000080200baa <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    80200baa:	1101                	addi	sp,sp,-32
    80200bac:	ec06                	sd	ra,24(sp)
    80200bae:	e822                	sd	s0,16(sp)
    80200bb0:	1000                	addi	s0,sp,32
    80200bb2:	87aa                	mv	a5,a0
    80200bb4:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    80200bb8:	fec42783          	lw	a5,-20(s0)
    80200bbc:	0007871b          	sext.w	a4,a5
    80200bc0:	02700793          	li	a5,39
    80200bc4:	04e7d563          	bge	a5,a4,80200c0e <set_bg_color+0x64>
    80200bc8:	fec42783          	lw	a5,-20(s0)
    80200bcc:	0007871b          	sext.w	a4,a5
    80200bd0:	02f00793          	li	a5,47
    80200bd4:	02e7cd63          	blt	a5,a4,80200c0e <set_bg_color+0x64>
	consputc('\033');
    80200bd8:	456d                	li	a0,27
    80200bda:	fffff097          	auipc	ra,0xfffff
    80200bde:	6fc080e7          	jalr	1788(ra) # 802002d6 <consputc>
	consputc('[');
    80200be2:	05b00513          	li	a0,91
    80200be6:	fffff097          	auipc	ra,0xfffff
    80200bea:	6f0080e7          	jalr	1776(ra) # 802002d6 <consputc>
	printint(color, 10, 0);
    80200bee:	fec42783          	lw	a5,-20(s0)
    80200bf2:	4601                	li	a2,0
    80200bf4:	45a9                	li	a1,10
    80200bf6:	853e                	mv	a0,a5
    80200bf8:	fffff097          	auipc	ra,0xfffff
    80200bfc:	732080e7          	jalr	1842(ra) # 8020032a <printint>
	consputc('m');
    80200c00:	06d00513          	li	a0,109
    80200c04:	fffff097          	auipc	ra,0xfffff
    80200c08:	6d2080e7          	jalr	1746(ra) # 802002d6 <consputc>
    80200c0c:	a011                	j	80200c10 <set_bg_color+0x66>
	if (color < 40 || color > 47) return; // 支持40-47
    80200c0e:	0001                	nop
}
    80200c10:	60e2                	ld	ra,24(sp)
    80200c12:	6442                	ld	s0,16(sp)
    80200c14:	6105                	addi	sp,sp,32
    80200c16:	8082                	ret

0000000080200c18 <color_red>:
// 简易文字颜色
void color_red(void) {
    80200c18:	1141                	addi	sp,sp,-16
    80200c1a:	e406                	sd	ra,8(sp)
    80200c1c:	e022                	sd	s0,0(sp)
    80200c1e:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    80200c20:	457d                	li	a0,31
    80200c22:	00000097          	auipc	ra,0x0
    80200c26:	f1c080e7          	jalr	-228(ra) # 80200b3e <set_fg_color>
}
    80200c2a:	0001                	nop
    80200c2c:	60a2                	ld	ra,8(sp)
    80200c2e:	6402                	ld	s0,0(sp)
    80200c30:	0141                	addi	sp,sp,16
    80200c32:	8082                	ret

0000000080200c34 <color_green>:
void color_green(void) {
    80200c34:	1141                	addi	sp,sp,-16
    80200c36:	e406                	sd	ra,8(sp)
    80200c38:	e022                	sd	s0,0(sp)
    80200c3a:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    80200c3c:	02000513          	li	a0,32
    80200c40:	00000097          	auipc	ra,0x0
    80200c44:	efe080e7          	jalr	-258(ra) # 80200b3e <set_fg_color>
}
    80200c48:	0001                	nop
    80200c4a:	60a2                	ld	ra,8(sp)
    80200c4c:	6402                	ld	s0,0(sp)
    80200c4e:	0141                	addi	sp,sp,16
    80200c50:	8082                	ret

0000000080200c52 <color_yellow>:
void color_yellow(void) {
    80200c52:	1141                	addi	sp,sp,-16
    80200c54:	e406                	sd	ra,8(sp)
    80200c56:	e022                	sd	s0,0(sp)
    80200c58:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    80200c5a:	02100513          	li	a0,33
    80200c5e:	00000097          	auipc	ra,0x0
    80200c62:	ee0080e7          	jalr	-288(ra) # 80200b3e <set_fg_color>
}
    80200c66:	0001                	nop
    80200c68:	60a2                	ld	ra,8(sp)
    80200c6a:	6402                	ld	s0,0(sp)
    80200c6c:	0141                	addi	sp,sp,16
    80200c6e:	8082                	ret

0000000080200c70 <color_blue>:
void color_blue(void) {
    80200c70:	1141                	addi	sp,sp,-16
    80200c72:	e406                	sd	ra,8(sp)
    80200c74:	e022                	sd	s0,0(sp)
    80200c76:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    80200c78:	02200513          	li	a0,34
    80200c7c:	00000097          	auipc	ra,0x0
    80200c80:	ec2080e7          	jalr	-318(ra) # 80200b3e <set_fg_color>
}
    80200c84:	0001                	nop
    80200c86:	60a2                	ld	ra,8(sp)
    80200c88:	6402                	ld	s0,0(sp)
    80200c8a:	0141                	addi	sp,sp,16
    80200c8c:	8082                	ret

0000000080200c8e <color_purple>:
void color_purple(void) {
    80200c8e:	1141                	addi	sp,sp,-16
    80200c90:	e406                	sd	ra,8(sp)
    80200c92:	e022                	sd	s0,0(sp)
    80200c94:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80200c96:	02300513          	li	a0,35
    80200c9a:	00000097          	auipc	ra,0x0
    80200c9e:	ea4080e7          	jalr	-348(ra) # 80200b3e <set_fg_color>
}
    80200ca2:	0001                	nop
    80200ca4:	60a2                	ld	ra,8(sp)
    80200ca6:	6402                	ld	s0,0(sp)
    80200ca8:	0141                	addi	sp,sp,16
    80200caa:	8082                	ret

0000000080200cac <color_cyan>:
void color_cyan(void) {
    80200cac:	1141                	addi	sp,sp,-16
    80200cae:	e406                	sd	ra,8(sp)
    80200cb0:	e022                	sd	s0,0(sp)
    80200cb2:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    80200cb4:	02400513          	li	a0,36
    80200cb8:	00000097          	auipc	ra,0x0
    80200cbc:	e86080e7          	jalr	-378(ra) # 80200b3e <set_fg_color>
}
    80200cc0:	0001                	nop
    80200cc2:	60a2                	ld	ra,8(sp)
    80200cc4:	6402                	ld	s0,0(sp)
    80200cc6:	0141                	addi	sp,sp,16
    80200cc8:	8082                	ret

0000000080200cca <color_reverse>:
void color_reverse(void){
    80200cca:	1141                	addi	sp,sp,-16
    80200ccc:	e406                	sd	ra,8(sp)
    80200cce:	e022                	sd	s0,0(sp)
    80200cd0:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    80200cd2:	02500513          	li	a0,37
    80200cd6:	00000097          	auipc	ra,0x0
    80200cda:	e68080e7          	jalr	-408(ra) # 80200b3e <set_fg_color>
}
    80200cde:	0001                	nop
    80200ce0:	60a2                	ld	ra,8(sp)
    80200ce2:	6402                	ld	s0,0(sp)
    80200ce4:	0141                	addi	sp,sp,16
    80200ce6:	8082                	ret

0000000080200ce8 <set_color>:
void set_color(int fg, int bg) {
    80200ce8:	1101                	addi	sp,sp,-32
    80200cea:	ec06                	sd	ra,24(sp)
    80200cec:	e822                	sd	s0,16(sp)
    80200cee:	1000                	addi	s0,sp,32
    80200cf0:	87aa                	mv	a5,a0
    80200cf2:	872e                	mv	a4,a1
    80200cf4:	fef42623          	sw	a5,-20(s0)
    80200cf8:	87ba                	mv	a5,a4
    80200cfa:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    80200cfe:	fe842783          	lw	a5,-24(s0)
    80200d02:	853e                	mv	a0,a5
    80200d04:	00000097          	auipc	ra,0x0
    80200d08:	ea6080e7          	jalr	-346(ra) # 80200baa <set_bg_color>
	set_fg_color(fg);
    80200d0c:	fec42783          	lw	a5,-20(s0)
    80200d10:	853e                	mv	a0,a5
    80200d12:	00000097          	auipc	ra,0x0
    80200d16:	e2c080e7          	jalr	-468(ra) # 80200b3e <set_fg_color>
}
    80200d1a:	0001                	nop
    80200d1c:	60e2                	ld	ra,24(sp)
    80200d1e:	6442                	ld	s0,16(sp)
    80200d20:	6105                	addi	sp,sp,32
    80200d22:	8082                	ret

0000000080200d24 <clear_line>:
void clear_line(){
    80200d24:	1141                	addi	sp,sp,-16
    80200d26:	e406                	sd	ra,8(sp)
    80200d28:	e022                	sd	s0,0(sp)
    80200d2a:	0800                	addi	s0,sp,16
	consputc('\033');
    80200d2c:	456d                	li	a0,27
    80200d2e:	fffff097          	auipc	ra,0xfffff
    80200d32:	5a8080e7          	jalr	1448(ra) # 802002d6 <consputc>
	consputc('[');
    80200d36:	05b00513          	li	a0,91
    80200d3a:	fffff097          	auipc	ra,0xfffff
    80200d3e:	59c080e7          	jalr	1436(ra) # 802002d6 <consputc>
	consputc('2');
    80200d42:	03200513          	li	a0,50
    80200d46:	fffff097          	auipc	ra,0xfffff
    80200d4a:	590080e7          	jalr	1424(ra) # 802002d6 <consputc>
	consputc('K');
    80200d4e:	04b00513          	li	a0,75
    80200d52:	fffff097          	auipc	ra,0xfffff
    80200d56:	584080e7          	jalr	1412(ra) # 802002d6 <consputc>
}
    80200d5a:	0001                	nop
    80200d5c:	60a2                	ld	ra,8(sp)
    80200d5e:	6402                	ld	s0,0(sp)
    80200d60:	0141                	addi	sp,sp,16
    80200d62:	8082                	ret

0000000080200d64 <panic>:

void panic(const char *msg) {
    80200d64:	1101                	addi	sp,sp,-32
    80200d66:	ec06                	sd	ra,24(sp)
    80200d68:	e822                	sd	s0,16(sp)
    80200d6a:	1000                	addi	s0,sp,32
    80200d6c:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    80200d70:	00000097          	auipc	ra,0x0
    80200d74:	ea8080e7          	jalr	-344(ra) # 80200c18 <color_red>
	printf("panic: %s\n", msg);
    80200d78:	fe843583          	ld	a1,-24(s0)
    80200d7c:	00002517          	auipc	a0,0x2
    80200d80:	5cc50513          	addi	a0,a0,1484 # 80203348 <small_numbers+0x228>
    80200d84:	fffff097          	auipc	ra,0xfffff
    80200d88:	6d8080e7          	jalr	1752(ra) # 8020045c <printf>
	reset_color();
    80200d8c:	00000097          	auipc	ra,0x0
    80200d90:	d90080e7          	jalr	-624(ra) # 80200b1c <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    80200d94:	0001                	nop
    80200d96:	bffd                	j	80200d94 <panic+0x30>

0000000080200d98 <test_printf_precision>:
}
void test_printf_precision(void) {
    80200d98:	1101                	addi	sp,sp,-32
    80200d9a:	ec06                	sd	ra,24(sp)
    80200d9c:	e822                	sd	s0,16(sp)
    80200d9e:	1000                	addi	s0,sp,32
	clear_screen();
    80200da0:	00000097          	auipc	ra,0x0
    80200da4:	ab4080e7          	jalr	-1356(ra) # 80200854 <clear_screen>
    printf("=== 详细的Printf测试 ===\n");
    80200da8:	00002517          	auipc	a0,0x2
    80200dac:	5b050513          	addi	a0,a0,1456 # 80203358 <small_numbers+0x238>
    80200db0:	fffff097          	auipc	ra,0xfffff
    80200db4:	6ac080e7          	jalr	1708(ra) # 8020045c <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    80200db8:	00002517          	auipc	a0,0x2
    80200dbc:	5c050513          	addi	a0,a0,1472 # 80203378 <small_numbers+0x258>
    80200dc0:	fffff097          	auipc	ra,0xfffff
    80200dc4:	69c080e7          	jalr	1692(ra) # 8020045c <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    80200dc8:	0ff00593          	li	a1,255
    80200dcc:	00002517          	auipc	a0,0x2
    80200dd0:	5c450513          	addi	a0,a0,1476 # 80203390 <small_numbers+0x270>
    80200dd4:	fffff097          	auipc	ra,0xfffff
    80200dd8:	688080e7          	jalr	1672(ra) # 8020045c <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    80200ddc:	6585                	lui	a1,0x1
    80200dde:	00002517          	auipc	a0,0x2
    80200de2:	5d250513          	addi	a0,a0,1490 # 802033b0 <small_numbers+0x290>
    80200de6:	fffff097          	auipc	ra,0xfffff
    80200dea:	676080e7          	jalr	1654(ra) # 8020045c <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    80200dee:	1234b7b7          	lui	a5,0x1234b
    80200df2:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    80200df6:	00002517          	auipc	a0,0x2
    80200dfa:	5da50513          	addi	a0,a0,1498 # 802033d0 <small_numbers+0x2b0>
    80200dfe:	fffff097          	auipc	ra,0xfffff
    80200e02:	65e080e7          	jalr	1630(ra) # 8020045c <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    80200e06:	00002517          	auipc	a0,0x2
    80200e0a:	5e250513          	addi	a0,a0,1506 # 802033e8 <small_numbers+0x2c8>
    80200e0e:	fffff097          	auipc	ra,0xfffff
    80200e12:	64e080e7          	jalr	1614(ra) # 8020045c <printf>
    printf("  正数: %d\n", 42);
    80200e16:	02a00593          	li	a1,42
    80200e1a:	00002517          	auipc	a0,0x2
    80200e1e:	5e650513          	addi	a0,a0,1510 # 80203400 <small_numbers+0x2e0>
    80200e22:	fffff097          	auipc	ra,0xfffff
    80200e26:	63a080e7          	jalr	1594(ra) # 8020045c <printf>
    printf("  负数: %d\n", -42);
    80200e2a:	fd600593          	li	a1,-42
    80200e2e:	00002517          	auipc	a0,0x2
    80200e32:	5e250513          	addi	a0,a0,1506 # 80203410 <small_numbers+0x2f0>
    80200e36:	fffff097          	auipc	ra,0xfffff
    80200e3a:	626080e7          	jalr	1574(ra) # 8020045c <printf>
    printf("  零: %d\n", 0);
    80200e3e:	4581                	li	a1,0
    80200e40:	00002517          	auipc	a0,0x2
    80200e44:	5e050513          	addi	a0,a0,1504 # 80203420 <small_numbers+0x300>
    80200e48:	fffff097          	auipc	ra,0xfffff
    80200e4c:	614080e7          	jalr	1556(ra) # 8020045c <printf>
    printf("  大数: %d\n", 123456789);
    80200e50:	075bd7b7          	lui	a5,0x75bd
    80200e54:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    80200e58:	00002517          	auipc	a0,0x2
    80200e5c:	5d850513          	addi	a0,a0,1496 # 80203430 <small_numbers+0x310>
    80200e60:	fffff097          	auipc	ra,0xfffff
    80200e64:	5fc080e7          	jalr	1532(ra) # 8020045c <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80200e68:	00002517          	auipc	a0,0x2
    80200e6c:	5d850513          	addi	a0,a0,1496 # 80203440 <small_numbers+0x320>
    80200e70:	fffff097          	auipc	ra,0xfffff
    80200e74:	5ec080e7          	jalr	1516(ra) # 8020045c <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80200e78:	55fd                	li	a1,-1
    80200e7a:	00002517          	auipc	a0,0x2
    80200e7e:	5de50513          	addi	a0,a0,1502 # 80203458 <small_numbers+0x338>
    80200e82:	fffff097          	auipc	ra,0xfffff
    80200e86:	5da080e7          	jalr	1498(ra) # 8020045c <printf>
    printf("  零：%u\n", 0U);
    80200e8a:	4581                	li	a1,0
    80200e8c:	00002517          	auipc	a0,0x2
    80200e90:	5e450513          	addi	a0,a0,1508 # 80203470 <small_numbers+0x350>
    80200e94:	fffff097          	auipc	ra,0xfffff
    80200e98:	5c8080e7          	jalr	1480(ra) # 8020045c <printf>
	printf("  小无符号数：%u\n", 12345U);
    80200e9c:	678d                	lui	a5,0x3
    80200e9e:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    80200ea2:	00002517          	auipc	a0,0x2
    80200ea6:	5de50513          	addi	a0,a0,1502 # 80203480 <small_numbers+0x360>
    80200eaa:	fffff097          	auipc	ra,0xfffff
    80200eae:	5b2080e7          	jalr	1458(ra) # 8020045c <printf>

	// 测试边界
	printf("边界测试:\n");
    80200eb2:	00002517          	auipc	a0,0x2
    80200eb6:	5e650513          	addi	a0,a0,1510 # 80203498 <small_numbers+0x378>
    80200eba:	fffff097          	auipc	ra,0xfffff
    80200ebe:	5a2080e7          	jalr	1442(ra) # 8020045c <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    80200ec2:	800007b7          	lui	a5,0x80000
    80200ec6:	fff7c593          	not	a1,a5
    80200eca:	00002517          	auipc	a0,0x2
    80200ece:	5de50513          	addi	a0,a0,1502 # 802034a8 <small_numbers+0x388>
    80200ed2:	fffff097          	auipc	ra,0xfffff
    80200ed6:	58a080e7          	jalr	1418(ra) # 8020045c <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    80200eda:	800005b7          	lui	a1,0x80000
    80200ede:	00002517          	auipc	a0,0x2
    80200ee2:	5da50513          	addi	a0,a0,1498 # 802034b8 <small_numbers+0x398>
    80200ee6:	fffff097          	auipc	ra,0xfffff
    80200eea:	576080e7          	jalr	1398(ra) # 8020045c <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    80200eee:	55fd                	li	a1,-1
    80200ef0:	00002517          	auipc	a0,0x2
    80200ef4:	5d850513          	addi	a0,a0,1496 # 802034c8 <small_numbers+0x3a8>
    80200ef8:	fffff097          	auipc	ra,0xfffff
    80200efc:	564080e7          	jalr	1380(ra) # 8020045c <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    80200f00:	55fd                	li	a1,-1
    80200f02:	00002517          	auipc	a0,0x2
    80200f06:	5d650513          	addi	a0,a0,1494 # 802034d8 <small_numbers+0x3b8>
    80200f0a:	fffff097          	auipc	ra,0xfffff
    80200f0e:	552080e7          	jalr	1362(ra) # 8020045c <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    80200f12:	00002517          	auipc	a0,0x2
    80200f16:	5de50513          	addi	a0,a0,1502 # 802034f0 <small_numbers+0x3d0>
    80200f1a:	fffff097          	auipc	ra,0xfffff
    80200f1e:	542080e7          	jalr	1346(ra) # 8020045c <printf>
    printf("  空字符串: '%s'\n", "");
    80200f22:	00002597          	auipc	a1,0x2
    80200f26:	5e658593          	addi	a1,a1,1510 # 80203508 <small_numbers+0x3e8>
    80200f2a:	00002517          	auipc	a0,0x2
    80200f2e:	5e650513          	addi	a0,a0,1510 # 80203510 <small_numbers+0x3f0>
    80200f32:	fffff097          	auipc	ra,0xfffff
    80200f36:	52a080e7          	jalr	1322(ra) # 8020045c <printf>
    printf("  单字符: '%s'\n", "X");
    80200f3a:	00002597          	auipc	a1,0x2
    80200f3e:	5ee58593          	addi	a1,a1,1518 # 80203528 <small_numbers+0x408>
    80200f42:	00002517          	auipc	a0,0x2
    80200f46:	5ee50513          	addi	a0,a0,1518 # 80203530 <small_numbers+0x410>
    80200f4a:	fffff097          	auipc	ra,0xfffff
    80200f4e:	512080e7          	jalr	1298(ra) # 8020045c <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    80200f52:	00002597          	auipc	a1,0x2
    80200f56:	5f658593          	addi	a1,a1,1526 # 80203548 <small_numbers+0x428>
    80200f5a:	00002517          	auipc	a0,0x2
    80200f5e:	60e50513          	addi	a0,a0,1550 # 80203568 <small_numbers+0x448>
    80200f62:	fffff097          	auipc	ra,0xfffff
    80200f66:	4fa080e7          	jalr	1274(ra) # 8020045c <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80200f6a:	00002597          	auipc	a1,0x2
    80200f6e:	61658593          	addi	a1,a1,1558 # 80203580 <small_numbers+0x460>
    80200f72:	00002517          	auipc	a0,0x2
    80200f76:	75e50513          	addi	a0,a0,1886 # 802036d0 <small_numbers+0x5b0>
    80200f7a:	fffff097          	auipc	ra,0xfffff
    80200f7e:	4e2080e7          	jalr	1250(ra) # 8020045c <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    80200f82:	00002517          	auipc	a0,0x2
    80200f86:	76e50513          	addi	a0,a0,1902 # 802036f0 <small_numbers+0x5d0>
    80200f8a:	fffff097          	auipc	ra,0xfffff
    80200f8e:	4d2080e7          	jalr	1234(ra) # 8020045c <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    80200f92:	0ff00693          	li	a3,255
    80200f96:	f0100613          	li	a2,-255
    80200f9a:	0ff00593          	li	a1,255
    80200f9e:	00002517          	auipc	a0,0x2
    80200fa2:	76a50513          	addi	a0,a0,1898 # 80203708 <small_numbers+0x5e8>
    80200fa6:	fffff097          	auipc	ra,0xfffff
    80200faa:	4b6080e7          	jalr	1206(ra) # 8020045c <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80200fae:	00002517          	auipc	a0,0x2
    80200fb2:	78250513          	addi	a0,a0,1922 # 80203730 <small_numbers+0x610>
    80200fb6:	fffff097          	auipc	ra,0xfffff
    80200fba:	4a6080e7          	jalr	1190(ra) # 8020045c <printf>
	printf("  100%% 完成!\n");
    80200fbe:	00002517          	auipc	a0,0x2
    80200fc2:	78a50513          	addi	a0,a0,1930 # 80203748 <small_numbers+0x628>
    80200fc6:	fffff097          	auipc	ra,0xfffff
    80200fca:	496080e7          	jalr	1174(ra) # 8020045c <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    80200fce:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    80200fd2:	00002517          	auipc	a0,0x2
    80200fd6:	78e50513          	addi	a0,a0,1934 # 80203760 <small_numbers+0x640>
    80200fda:	fffff097          	auipc	ra,0xfffff
    80200fde:	482080e7          	jalr	1154(ra) # 8020045c <printf>
	printf("  NULL as string: '%s'\n", null_str);
    80200fe2:	fe843583          	ld	a1,-24(s0)
    80200fe6:	00002517          	auipc	a0,0x2
    80200fea:	79250513          	addi	a0,a0,1938 # 80203778 <small_numbers+0x658>
    80200fee:	fffff097          	auipc	ra,0xfffff
    80200ff2:	46e080e7          	jalr	1134(ra) # 8020045c <printf>
	
	// 测试指针格式
	int var = 42;
    80200ff6:	02a00793          	li	a5,42
    80200ffa:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    80200ffe:	00002517          	auipc	a0,0x2
    80201002:	79250513          	addi	a0,a0,1938 # 80203790 <small_numbers+0x670>
    80201006:	fffff097          	auipc	ra,0xfffff
    8020100a:	456080e7          	jalr	1110(ra) # 8020045c <printf>
	printf("  Address of var: %p\n", &var);
    8020100e:	fe440793          	addi	a5,s0,-28
    80201012:	85be                	mv	a1,a5
    80201014:	00002517          	auipc	a0,0x2
    80201018:	78c50513          	addi	a0,a0,1932 # 802037a0 <small_numbers+0x680>
    8020101c:	fffff097          	auipc	ra,0xfffff
    80201020:	440080e7          	jalr	1088(ra) # 8020045c <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80201024:	00002517          	auipc	a0,0x2
    80201028:	79450513          	addi	a0,a0,1940 # 802037b8 <small_numbers+0x698>
    8020102c:	fffff097          	auipc	ra,0xfffff
    80201030:	430080e7          	jalr	1072(ra) # 8020045c <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201034:	55fd                	li	a1,-1
    80201036:	00002517          	auipc	a0,0x2
    8020103a:	7a250513          	addi	a0,a0,1954 # 802037d8 <small_numbers+0x6b8>
    8020103e:	fffff097          	auipc	ra,0xfffff
    80201042:	41e080e7          	jalr	1054(ra) # 8020045c <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201046:	00002517          	auipc	a0,0x2
    8020104a:	7aa50513          	addi	a0,a0,1962 # 802037f0 <small_numbers+0x6d0>
    8020104e:	fffff097          	auipc	ra,0xfffff
    80201052:	40e080e7          	jalr	1038(ra) # 8020045c <printf>
	printf("  Binary of 5: %b\n", 5);
    80201056:	4595                	li	a1,5
    80201058:	00002517          	auipc	a0,0x2
    8020105c:	7b050513          	addi	a0,a0,1968 # 80203808 <small_numbers+0x6e8>
    80201060:	fffff097          	auipc	ra,0xfffff
    80201064:	3fc080e7          	jalr	1020(ra) # 8020045c <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201068:	45a1                	li	a1,8
    8020106a:	00002517          	auipc	a0,0x2
    8020106e:	7b650513          	addi	a0,a0,1974 # 80203820 <small_numbers+0x700>
    80201072:	fffff097          	auipc	ra,0xfffff
    80201076:	3ea080e7          	jalr	1002(ra) # 8020045c <printf>
	printf("=== Printf测试结束 ===\n");
    8020107a:	00002517          	auipc	a0,0x2
    8020107e:	7be50513          	addi	a0,a0,1982 # 80203838 <small_numbers+0x718>
    80201082:	fffff097          	auipc	ra,0xfffff
    80201086:	3da080e7          	jalr	986(ra) # 8020045c <printf>
}
    8020108a:	0001                	nop
    8020108c:	60e2                	ld	ra,24(sp)
    8020108e:	6442                	ld	s0,16(sp)
    80201090:	6105                	addi	sp,sp,32
    80201092:	8082                	ret

0000000080201094 <test_curse_move>:
void test_curse_move(){
    80201094:	1101                	addi	sp,sp,-32
    80201096:	ec06                	sd	ra,24(sp)
    80201098:	e822                	sd	s0,16(sp)
    8020109a:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    8020109c:	fffff097          	auipc	ra,0xfffff
    802010a0:	7b8080e7          	jalr	1976(ra) # 80200854 <clear_screen>
	printf("=== 光标移动测试 ===\n");
    802010a4:	00002517          	auipc	a0,0x2
    802010a8:	7b450513          	addi	a0,a0,1972 # 80203858 <small_numbers+0x738>
    802010ac:	fffff097          	auipc	ra,0xfffff
    802010b0:	3b0080e7          	jalr	944(ra) # 8020045c <printf>
	for (int i = 3; i <= 7; i++) {
    802010b4:	478d                	li	a5,3
    802010b6:	fef42623          	sw	a5,-20(s0)
    802010ba:	a881                	j	8020110a <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    802010bc:	4785                	li	a5,1
    802010be:	fef42423          	sw	a5,-24(s0)
    802010c2:	a805                	j	802010f2 <test_curse_move+0x5e>
			goto_rc(i, j);
    802010c4:	fe842703          	lw	a4,-24(s0)
    802010c8:	fec42783          	lw	a5,-20(s0)
    802010cc:	85ba                	mv	a1,a4
    802010ce:	853e                	mv	a0,a5
    802010d0:	00000097          	auipc	ra,0x0
    802010d4:	9da080e7          	jalr	-1574(ra) # 80200aaa <goto_rc>
			printf("*");
    802010d8:	00002517          	auipc	a0,0x2
    802010dc:	7a050513          	addi	a0,a0,1952 # 80203878 <small_numbers+0x758>
    802010e0:	fffff097          	auipc	ra,0xfffff
    802010e4:	37c080e7          	jalr	892(ra) # 8020045c <printf>
		for (int j = 1; j <= 10; j++) {
    802010e8:	fe842783          	lw	a5,-24(s0)
    802010ec:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdf9d41>
    802010ee:	fef42423          	sw	a5,-24(s0)
    802010f2:	fe842783          	lw	a5,-24(s0)
    802010f6:	0007871b          	sext.w	a4,a5
    802010fa:	47a9                	li	a5,10
    802010fc:	fce7d4e3          	bge	a5,a4,802010c4 <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    80201100:	fec42783          	lw	a5,-20(s0)
    80201104:	2785                	addiw	a5,a5,1
    80201106:	fef42623          	sw	a5,-20(s0)
    8020110a:	fec42783          	lw	a5,-20(s0)
    8020110e:	0007871b          	sext.w	a4,a5
    80201112:	479d                	li	a5,7
    80201114:	fae7d4e3          	bge	a5,a4,802010bc <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201118:	4585                	li	a1,1
    8020111a:	4525                	li	a0,9
    8020111c:	00000097          	auipc	ra,0x0
    80201120:	98e080e7          	jalr	-1650(ra) # 80200aaa <goto_rc>
	save_cursor();
    80201124:	00000097          	auipc	ra,0x0
    80201128:	8c2080e7          	jalr	-1854(ra) # 802009e6 <save_cursor>
	// 光标移动测试
	cursor_up(5);
    8020112c:	4515                	li	a0,5
    8020112e:	fffff097          	auipc	ra,0xfffff
    80201132:	758080e7          	jalr	1880(ra) # 80200886 <cursor_up>
	cursor_right(2);
    80201136:	4509                	li	a0,2
    80201138:	fffff097          	auipc	ra,0xfffff
    8020113c:	7fe080e7          	jalr	2046(ra) # 80200936 <cursor_right>
	printf("+++++");
    80201140:	00002517          	auipc	a0,0x2
    80201144:	74050513          	addi	a0,a0,1856 # 80203880 <small_numbers+0x760>
    80201148:	fffff097          	auipc	ra,0xfffff
    8020114c:	314080e7          	jalr	788(ra) # 8020045c <printf>
	cursor_down(2);
    80201150:	4509                	li	a0,2
    80201152:	fffff097          	auipc	ra,0xfffff
    80201156:	78c080e7          	jalr	1932(ra) # 802008de <cursor_down>
	cursor_left(5);
    8020115a:	4515                	li	a0,5
    8020115c:	00000097          	auipc	ra,0x0
    80201160:	832080e7          	jalr	-1998(ra) # 8020098e <cursor_left>
	printf("-----");
    80201164:	00002517          	auipc	a0,0x2
    80201168:	72450513          	addi	a0,a0,1828 # 80203888 <small_numbers+0x768>
    8020116c:	fffff097          	auipc	ra,0xfffff
    80201170:	2f0080e7          	jalr	752(ra) # 8020045c <printf>
	restore_cursor();
    80201174:	00000097          	auipc	ra,0x0
    80201178:	8a6080e7          	jalr	-1882(ra) # 80200a1a <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    8020117c:	00002517          	auipc	a0,0x2
    80201180:	71450513          	addi	a0,a0,1812 # 80203890 <small_numbers+0x770>
    80201184:	fffff097          	auipc	ra,0xfffff
    80201188:	2d8080e7          	jalr	728(ra) # 8020045c <printf>
}
    8020118c:	0001                	nop
    8020118e:	60e2                	ld	ra,24(sp)
    80201190:	6442                	ld	s0,16(sp)
    80201192:	6105                	addi	sp,sp,32
    80201194:	8082                	ret

0000000080201196 <test_basic_colors>:

void test_basic_colors(void) {
    80201196:	1141                	addi	sp,sp,-16
    80201198:	e406                	sd	ra,8(sp)
    8020119a:	e022                	sd	s0,0(sp)
    8020119c:	0800                	addi	s0,sp,16
    clear_screen();
    8020119e:	fffff097          	auipc	ra,0xfffff
    802011a2:	6b6080e7          	jalr	1718(ra) # 80200854 <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    802011a6:	00002517          	auipc	a0,0x2
    802011aa:	71250513          	addi	a0,a0,1810 # 802038b8 <small_numbers+0x798>
    802011ae:	fffff097          	auipc	ra,0xfffff
    802011b2:	2ae080e7          	jalr	686(ra) # 8020045c <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    802011b6:	00002517          	auipc	a0,0x2
    802011ba:	72250513          	addi	a0,a0,1826 # 802038d8 <small_numbers+0x7b8>
    802011be:	fffff097          	auipc	ra,0xfffff
    802011c2:	29e080e7          	jalr	670(ra) # 8020045c <printf>
    color_red();    printf("红色文字 ");
    802011c6:	00000097          	auipc	ra,0x0
    802011ca:	a52080e7          	jalr	-1454(ra) # 80200c18 <color_red>
    802011ce:	00002517          	auipc	a0,0x2
    802011d2:	72250513          	addi	a0,a0,1826 # 802038f0 <small_numbers+0x7d0>
    802011d6:	fffff097          	auipc	ra,0xfffff
    802011da:	286080e7          	jalr	646(ra) # 8020045c <printf>
    color_green();  printf("绿色文字 ");
    802011de:	00000097          	auipc	ra,0x0
    802011e2:	a56080e7          	jalr	-1450(ra) # 80200c34 <color_green>
    802011e6:	00002517          	auipc	a0,0x2
    802011ea:	71a50513          	addi	a0,a0,1818 # 80203900 <small_numbers+0x7e0>
    802011ee:	fffff097          	auipc	ra,0xfffff
    802011f2:	26e080e7          	jalr	622(ra) # 8020045c <printf>
    color_yellow(); printf("黄色文字 ");
    802011f6:	00000097          	auipc	ra,0x0
    802011fa:	a5c080e7          	jalr	-1444(ra) # 80200c52 <color_yellow>
    802011fe:	00002517          	auipc	a0,0x2
    80201202:	71250513          	addi	a0,a0,1810 # 80203910 <small_numbers+0x7f0>
    80201206:	fffff097          	auipc	ra,0xfffff
    8020120a:	256080e7          	jalr	598(ra) # 8020045c <printf>
    color_blue();   printf("蓝色文字 ");
    8020120e:	00000097          	auipc	ra,0x0
    80201212:	a62080e7          	jalr	-1438(ra) # 80200c70 <color_blue>
    80201216:	00002517          	auipc	a0,0x2
    8020121a:	70a50513          	addi	a0,a0,1802 # 80203920 <small_numbers+0x800>
    8020121e:	fffff097          	auipc	ra,0xfffff
    80201222:	23e080e7          	jalr	574(ra) # 8020045c <printf>
    color_purple(); printf("紫色文字 ");
    80201226:	00000097          	auipc	ra,0x0
    8020122a:	a68080e7          	jalr	-1432(ra) # 80200c8e <color_purple>
    8020122e:	00002517          	auipc	a0,0x2
    80201232:	70250513          	addi	a0,a0,1794 # 80203930 <small_numbers+0x810>
    80201236:	fffff097          	auipc	ra,0xfffff
    8020123a:	226080e7          	jalr	550(ra) # 8020045c <printf>
    color_cyan();   printf("青色文字 ");
    8020123e:	00000097          	auipc	ra,0x0
    80201242:	a6e080e7          	jalr	-1426(ra) # 80200cac <color_cyan>
    80201246:	00002517          	auipc	a0,0x2
    8020124a:	6fa50513          	addi	a0,a0,1786 # 80203940 <small_numbers+0x820>
    8020124e:	fffff097          	auipc	ra,0xfffff
    80201252:	20e080e7          	jalr	526(ra) # 8020045c <printf>
    color_reverse();  printf("反色文字");
    80201256:	00000097          	auipc	ra,0x0
    8020125a:	a74080e7          	jalr	-1420(ra) # 80200cca <color_reverse>
    8020125e:	00002517          	auipc	a0,0x2
    80201262:	6f250513          	addi	a0,a0,1778 # 80203950 <small_numbers+0x830>
    80201266:	fffff097          	auipc	ra,0xfffff
    8020126a:	1f6080e7          	jalr	502(ra) # 8020045c <printf>
    reset_color();
    8020126e:	00000097          	auipc	ra,0x0
    80201272:	8ae080e7          	jalr	-1874(ra) # 80200b1c <reset_color>
    printf("\n\n");
    80201276:	00002517          	auipc	a0,0x2
    8020127a:	6ea50513          	addi	a0,a0,1770 # 80203960 <small_numbers+0x840>
    8020127e:	fffff097          	auipc	ra,0xfffff
    80201282:	1de080e7          	jalr	478(ra) # 8020045c <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80201286:	00002517          	auipc	a0,0x2
    8020128a:	6e250513          	addi	a0,a0,1762 # 80203968 <small_numbers+0x848>
    8020128e:	fffff097          	auipc	ra,0xfffff
    80201292:	1ce080e7          	jalr	462(ra) # 8020045c <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80201296:	02900513          	li	a0,41
    8020129a:	00000097          	auipc	ra,0x0
    8020129e:	910080e7          	jalr	-1776(ra) # 80200baa <set_bg_color>
    802012a2:	00002517          	auipc	a0,0x2
    802012a6:	6de50513          	addi	a0,a0,1758 # 80203980 <small_numbers+0x860>
    802012aa:	fffff097          	auipc	ra,0xfffff
    802012ae:	1b2080e7          	jalr	434(ra) # 8020045c <printf>
    802012b2:	00000097          	auipc	ra,0x0
    802012b6:	86a080e7          	jalr	-1942(ra) # 80200b1c <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    802012ba:	02a00513          	li	a0,42
    802012be:	00000097          	auipc	ra,0x0
    802012c2:	8ec080e7          	jalr	-1812(ra) # 80200baa <set_bg_color>
    802012c6:	00002517          	auipc	a0,0x2
    802012ca:	6ca50513          	addi	a0,a0,1738 # 80203990 <small_numbers+0x870>
    802012ce:	fffff097          	auipc	ra,0xfffff
    802012d2:	18e080e7          	jalr	398(ra) # 8020045c <printf>
    802012d6:	00000097          	auipc	ra,0x0
    802012da:	846080e7          	jalr	-1978(ra) # 80200b1c <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    802012de:	02b00513          	li	a0,43
    802012e2:	00000097          	auipc	ra,0x0
    802012e6:	8c8080e7          	jalr	-1848(ra) # 80200baa <set_bg_color>
    802012ea:	00002517          	auipc	a0,0x2
    802012ee:	6b650513          	addi	a0,a0,1718 # 802039a0 <small_numbers+0x880>
    802012f2:	fffff097          	auipc	ra,0xfffff
    802012f6:	16a080e7          	jalr	362(ra) # 8020045c <printf>
    802012fa:	00000097          	auipc	ra,0x0
    802012fe:	822080e7          	jalr	-2014(ra) # 80200b1c <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80201302:	02c00513          	li	a0,44
    80201306:	00000097          	auipc	ra,0x0
    8020130a:	8a4080e7          	jalr	-1884(ra) # 80200baa <set_bg_color>
    8020130e:	00002517          	auipc	a0,0x2
    80201312:	6a250513          	addi	a0,a0,1698 # 802039b0 <small_numbers+0x890>
    80201316:	fffff097          	auipc	ra,0xfffff
    8020131a:	146080e7          	jalr	326(ra) # 8020045c <printf>
    8020131e:	fffff097          	auipc	ra,0xfffff
    80201322:	7fe080e7          	jalr	2046(ra) # 80200b1c <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201326:	02f00513          	li	a0,47
    8020132a:	00000097          	auipc	ra,0x0
    8020132e:	880080e7          	jalr	-1920(ra) # 80200baa <set_bg_color>
    80201332:	00002517          	auipc	a0,0x2
    80201336:	68e50513          	addi	a0,a0,1678 # 802039c0 <small_numbers+0x8a0>
    8020133a:	fffff097          	auipc	ra,0xfffff
    8020133e:	122080e7          	jalr	290(ra) # 8020045c <printf>
    80201342:	fffff097          	auipc	ra,0xfffff
    80201346:	7da080e7          	jalr	2010(ra) # 80200b1c <reset_color>
    printf("\n\n");
    8020134a:	00002517          	auipc	a0,0x2
    8020134e:	61650513          	addi	a0,a0,1558 # 80203960 <small_numbers+0x840>
    80201352:	fffff097          	auipc	ra,0xfffff
    80201356:	10a080e7          	jalr	266(ra) # 8020045c <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    8020135a:	00002517          	auipc	a0,0x2
    8020135e:	67650513          	addi	a0,a0,1654 # 802039d0 <small_numbers+0x8b0>
    80201362:	fffff097          	auipc	ra,0xfffff
    80201366:	0fa080e7          	jalr	250(ra) # 8020045c <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    8020136a:	02c00593          	li	a1,44
    8020136e:	457d                	li	a0,31
    80201370:	00000097          	auipc	ra,0x0
    80201374:	978080e7          	jalr	-1672(ra) # 80200ce8 <set_color>
    80201378:	00002517          	auipc	a0,0x2
    8020137c:	67050513          	addi	a0,a0,1648 # 802039e8 <small_numbers+0x8c8>
    80201380:	fffff097          	auipc	ra,0xfffff
    80201384:	0dc080e7          	jalr	220(ra) # 8020045c <printf>
    80201388:	fffff097          	auipc	ra,0xfffff
    8020138c:	794080e7          	jalr	1940(ra) # 80200b1c <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201390:	02d00593          	li	a1,45
    80201394:	02100513          	li	a0,33
    80201398:	00000097          	auipc	ra,0x0
    8020139c:	950080e7          	jalr	-1712(ra) # 80200ce8 <set_color>
    802013a0:	00002517          	auipc	a0,0x2
    802013a4:	65850513          	addi	a0,a0,1624 # 802039f8 <small_numbers+0x8d8>
    802013a8:	fffff097          	auipc	ra,0xfffff
    802013ac:	0b4080e7          	jalr	180(ra) # 8020045c <printf>
    802013b0:	fffff097          	auipc	ra,0xfffff
    802013b4:	76c080e7          	jalr	1900(ra) # 80200b1c <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    802013b8:	02f00593          	li	a1,47
    802013bc:	02000513          	li	a0,32
    802013c0:	00000097          	auipc	ra,0x0
    802013c4:	928080e7          	jalr	-1752(ra) # 80200ce8 <set_color>
    802013c8:	00002517          	auipc	a0,0x2
    802013cc:	64050513          	addi	a0,a0,1600 # 80203a08 <small_numbers+0x8e8>
    802013d0:	fffff097          	auipc	ra,0xfffff
    802013d4:	08c080e7          	jalr	140(ra) # 8020045c <printf>
    802013d8:	fffff097          	auipc	ra,0xfffff
    802013dc:	744080e7          	jalr	1860(ra) # 80200b1c <reset_color>
    printf("\n\n");
    802013e0:	00002517          	auipc	a0,0x2
    802013e4:	58050513          	addi	a0,a0,1408 # 80203960 <small_numbers+0x840>
    802013e8:	fffff097          	auipc	ra,0xfffff
    802013ec:	074080e7          	jalr	116(ra) # 8020045c <printf>
	reset_color();
    802013f0:	fffff097          	auipc	ra,0xfffff
    802013f4:	72c080e7          	jalr	1836(ra) # 80200b1c <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    802013f8:	00002517          	auipc	a0,0x2
    802013fc:	62050513          	addi	a0,a0,1568 # 80203a18 <small_numbers+0x8f8>
    80201400:	fffff097          	auipc	ra,0xfffff
    80201404:	05c080e7          	jalr	92(ra) # 8020045c <printf>
	cursor_up(1); // 光标上移一行
    80201408:	4505                	li	a0,1
    8020140a:	fffff097          	auipc	ra,0xfffff
    8020140e:	47c080e7          	jalr	1148(ra) # 80200886 <cursor_up>
	clear_line();
    80201412:	00000097          	auipc	ra,0x0
    80201416:	912080e7          	jalr	-1774(ra) # 80200d24 <clear_line>

	printf("=== 颜色测试结束 ===\n");
    8020141a:	00002517          	auipc	a0,0x2
    8020141e:	63650513          	addi	a0,a0,1590 # 80203a50 <small_numbers+0x930>
    80201422:	fffff097          	auipc	ra,0xfffff
    80201426:	03a080e7          	jalr	58(ra) # 8020045c <printf>
    8020142a:	0001                	nop
    8020142c:	60a2                	ld	ra,8(sp)
    8020142e:	6402                	ld	s0,0(sp)
    80201430:	0141                	addi	sp,sp,16
    80201432:	8082                	ret

0000000080201434 <memset>:
#include "mem.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201434:	7139                	addi	sp,sp,-64
    80201436:	fc22                	sd	s0,56(sp)
    80201438:	0080                	addi	s0,sp,64
    8020143a:	fca43c23          	sd	a0,-40(s0)
    8020143e:	87ae                	mv	a5,a1
    80201440:	fcc43423          	sd	a2,-56(s0)
    80201444:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201448:	fd843783          	ld	a5,-40(s0)
    8020144c:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    80201450:	a829                	j	8020146a <memset+0x36>
        *p++ = (unsigned char)c;
    80201452:	fe843783          	ld	a5,-24(s0)
    80201456:	00178713          	addi	a4,a5,1
    8020145a:	fee43423          	sd	a4,-24(s0)
    8020145e:	fd442703          	lw	a4,-44(s0)
    80201462:	0ff77713          	zext.b	a4,a4
    80201466:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    8020146a:	fc843783          	ld	a5,-56(s0)
    8020146e:	fff78713          	addi	a4,a5,-1
    80201472:	fce43423          	sd	a4,-56(s0)
    80201476:	fff1                	bnez	a5,80201452 <memset+0x1e>
    return dst;
    80201478:	fd843783          	ld	a5,-40(s0)
    8020147c:	853e                	mv	a0,a5
    8020147e:	7462                	ld	s0,56(sp)
    80201480:	6121                	addi	sp,sp,64
    80201482:	8082                	ret

0000000080201484 <assert>:
#include "vm.h"
#include "memlayout.h"
#include "pm.h"
    80201484:	1101                	addi	sp,sp,-32
    80201486:	ec06                	sd	ra,24(sp)
    80201488:	e822                	sd	s0,16(sp)
    8020148a:	1000                	addi	s0,sp,32
    8020148c:	87aa                	mv	a5,a0
    8020148e:	fef42623          	sw	a5,-20(s0)
#include "printf.h"
    80201492:	fec42783          	lw	a5,-20(s0)
    80201496:	2781                	sext.w	a5,a5
    80201498:	e795                	bnez	a5,802014c4 <assert+0x40>
#include "mem.h"
    8020149a:	4615                	li	a2,5
    8020149c:	00002597          	auipc	a1,0x2
    802014a0:	5d458593          	addi	a1,a1,1492 # 80203a70 <small_numbers+0x950>
    802014a4:	00002517          	auipc	a0,0x2
    802014a8:	5dc50513          	addi	a0,a0,1500 # 80203a80 <small_numbers+0x960>
    802014ac:	fffff097          	auipc	ra,0xfffff
    802014b0:	fb0080e7          	jalr	-80(ra) # 8020045c <printf>
#include "assert.h"
    802014b4:	00002517          	auipc	a0,0x2
    802014b8:	5f450513          	addi	a0,a0,1524 # 80203aa8 <small_numbers+0x988>
    802014bc:	00000097          	auipc	ra,0x0
    802014c0:	8a8080e7          	jalr	-1880(ra) # 80200d64 <panic>

#define PTE_V   0x001
    802014c4:	0001                	nop
    802014c6:	60e2                	ld	ra,24(sp)
    802014c8:	6442                	ld	s0,16(sp)
    802014ca:	6105                	addi	sp,sp,32
    802014cc:	8082                	ret

00000000802014ce <px>:


// 内核页表全局变量
pagetable_t kernel_pagetable = 0;

static inline uint64 px(int level, uint64 va) {
    802014ce:	1101                	addi	sp,sp,-32
    802014d0:	ec22                	sd	s0,24(sp)
    802014d2:	1000                	addi	s0,sp,32
    802014d4:	87aa                	mv	a5,a0
    802014d6:	feb43023          	sd	a1,-32(s0)
    802014da:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    802014de:	fec42783          	lw	a5,-20(s0)
    802014e2:	873e                	mv	a4,a5
    802014e4:	87ba                	mv	a5,a4
    802014e6:	0037979b          	slliw	a5,a5,0x3
    802014ea:	9fb9                	addw	a5,a5,a4
    802014ec:	2781                	sext.w	a5,a5
    802014ee:	27b1                	addiw	a5,a5,12
    802014f0:	2781                	sext.w	a5,a5
    802014f2:	873e                	mv	a4,a5
    802014f4:	fe043783          	ld	a5,-32(s0)
    802014f8:	00e7d7b3          	srl	a5,a5,a4
    802014fc:	1ff7f793          	andi	a5,a5,511
}
    80201500:	853e                	mv	a0,a5
    80201502:	6462                	ld	s0,24(sp)
    80201504:	6105                	addi	sp,sp,32
    80201506:	8082                	ret

0000000080201508 <create_pagetable>:

// 创建空页表
pagetable_t create_pagetable(void) {
    80201508:	1101                	addi	sp,sp,-32
    8020150a:	ec06                	sd	ra,24(sp)
    8020150c:	e822                	sd	s0,16(sp)
    8020150e:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    80201510:	00001097          	auipc	ra,0x1
    80201514:	900080e7          	jalr	-1792(ra) # 80201e10 <alloc_page>
    80201518:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    8020151c:	fe843783          	ld	a5,-24(s0)
    80201520:	e399                	bnez	a5,80201526 <create_pagetable+0x1e>
        return 0;
    80201522:	4781                	li	a5,0
    80201524:	a819                	j	8020153a <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    80201526:	6605                	lui	a2,0x1
    80201528:	4581                	li	a1,0
    8020152a:	fe843503          	ld	a0,-24(s0)
    8020152e:	00000097          	auipc	ra,0x0
    80201532:	f06080e7          	jalr	-250(ra) # 80201434 <memset>
    return pt;
    80201536:	fe843783          	ld	a5,-24(s0)
}
    8020153a:	853e                	mv	a0,a5
    8020153c:	60e2                	ld	ra,24(sp)
    8020153e:	6442                	ld	s0,16(sp)
    80201540:	6105                	addi	sp,sp,32
    80201542:	8082                	ret

0000000080201544 <walk_lookup>:
// 辅助函数：仅查找
static pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    80201544:	7179                	addi	sp,sp,-48
    80201546:	f406                	sd	ra,40(sp)
    80201548:	f022                	sd	s0,32(sp)
    8020154a:	1800                	addi	s0,sp,48
    8020154c:	fca43c23          	sd	a0,-40(s0)
    80201550:	fcb43823          	sd	a1,-48(s0)
    if (va >= MAXVA)
    80201554:	fd043703          	ld	a4,-48(s0)
    80201558:	57fd                	li	a5,-1
    8020155a:	83e5                	srli	a5,a5,0x19
    8020155c:	00e7fa63          	bgeu	a5,a4,80201570 <walk_lookup+0x2c>
        panic("walk_lookup: va out of range");
    80201560:	00002517          	auipc	a0,0x2
    80201564:	55050513          	addi	a0,a0,1360 # 80203ab0 <small_numbers+0x990>
    80201568:	fffff097          	auipc	ra,0xfffff
    8020156c:	7fc080e7          	jalr	2044(ra) # 80200d64 <panic>
    for (int level = 2; level > 0; level--) {
    80201570:	4789                	li	a5,2
    80201572:	fef42623          	sw	a5,-20(s0)
    80201576:	a0a9                	j	802015c0 <walk_lookup+0x7c>
        pte_t *pte = &pt[px(level, va)];
    80201578:	fec42783          	lw	a5,-20(s0)
    8020157c:	fd043583          	ld	a1,-48(s0)
    80201580:	853e                	mv	a0,a5
    80201582:	00000097          	auipc	ra,0x0
    80201586:	f4c080e7          	jalr	-180(ra) # 802014ce <px>
    8020158a:	87aa                	mv	a5,a0
    8020158c:	078e                	slli	a5,a5,0x3
    8020158e:	fd843703          	ld	a4,-40(s0)
    80201592:	97ba                	add	a5,a5,a4
    80201594:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80201598:	fe043783          	ld	a5,-32(s0)
    8020159c:	639c                	ld	a5,0(a5)
    8020159e:	8b85                	andi	a5,a5,1
    802015a0:	cb89                	beqz	a5,802015b2 <walk_lookup+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    802015a2:	fe043783          	ld	a5,-32(s0)
    802015a6:	639c                	ld	a5,0(a5)
    802015a8:	83a9                	srli	a5,a5,0xa
    802015aa:	07b2                	slli	a5,a5,0xc
    802015ac:	fcf43c23          	sd	a5,-40(s0)
    802015b0:	a019                	j	802015b6 <walk_lookup+0x72>
        } else {
            return 0;
    802015b2:	4781                	li	a5,0
    802015b4:	a03d                	j	802015e2 <walk_lookup+0x9e>
    for (int level = 2; level > 0; level--) {
    802015b6:	fec42783          	lw	a5,-20(s0)
    802015ba:	37fd                	addiw	a5,a5,-1
    802015bc:	fef42623          	sw	a5,-20(s0)
    802015c0:	fec42783          	lw	a5,-20(s0)
    802015c4:	2781                	sext.w	a5,a5
    802015c6:	faf049e3          	bgtz	a5,80201578 <walk_lookup+0x34>
        }
    }
    return &pt[px(0, va)];
    802015ca:	fd043583          	ld	a1,-48(s0)
    802015ce:	4501                	li	a0,0
    802015d0:	00000097          	auipc	ra,0x0
    802015d4:	efe080e7          	jalr	-258(ra) # 802014ce <px>
    802015d8:	87aa                	mv	a5,a0
    802015da:	078e                	slli	a5,a5,0x3
    802015dc:	fd843703          	ld	a4,-40(s0)
    802015e0:	97ba                	add	a5,a5,a4
}
    802015e2:	853e                	mv	a0,a5
    802015e4:	70a2                	ld	ra,40(sp)
    802015e6:	7402                	ld	s0,32(sp)
    802015e8:	6145                	addi	sp,sp,48
    802015ea:	8082                	ret

00000000802015ec <walk_create>:

// 辅助函数：查找或分配
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    802015ec:	7139                	addi	sp,sp,-64
    802015ee:	fc06                	sd	ra,56(sp)
    802015f0:	f822                	sd	s0,48(sp)
    802015f2:	0080                	addi	s0,sp,64
    802015f4:	fca43423          	sd	a0,-56(s0)
    802015f8:	fcb43023          	sd	a1,-64(s0)
    if (va >= MAXVA)
    802015fc:	fc043703          	ld	a4,-64(s0)
    80201600:	57fd                	li	a5,-1
    80201602:	83e5                	srli	a5,a5,0x19
    80201604:	00e7fa63          	bgeu	a5,a4,80201618 <walk_create+0x2c>
        panic("walk_create: va out of range");
    80201608:	00002517          	auipc	a0,0x2
    8020160c:	4c850513          	addi	a0,a0,1224 # 80203ad0 <small_numbers+0x9b0>
    80201610:	fffff097          	auipc	ra,0xfffff
    80201614:	754080e7          	jalr	1876(ra) # 80200d64 <panic>
    for (int level = 2; level > 0; level--) {
    80201618:	4789                	li	a5,2
    8020161a:	fef42623          	sw	a5,-20(s0)
    8020161e:	a059                	j	802016a4 <walk_create+0xb8>
        pte_t *pte = &pt[px(level, va)];
    80201620:	fec42783          	lw	a5,-20(s0)
    80201624:	fc043583          	ld	a1,-64(s0)
    80201628:	853e                	mv	a0,a5
    8020162a:	00000097          	auipc	ra,0x0
    8020162e:	ea4080e7          	jalr	-348(ra) # 802014ce <px>
    80201632:	87aa                	mv	a5,a0
    80201634:	078e                	slli	a5,a5,0x3
    80201636:	fc843703          	ld	a4,-56(s0)
    8020163a:	97ba                	add	a5,a5,a4
    8020163c:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80201640:	fe043783          	ld	a5,-32(s0)
    80201644:	639c                	ld	a5,0(a5)
    80201646:	8b85                	andi	a5,a5,1
    80201648:	cb89                	beqz	a5,8020165a <walk_create+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    8020164a:	fe043783          	ld	a5,-32(s0)
    8020164e:	639c                	ld	a5,0(a5)
    80201650:	83a9                	srli	a5,a5,0xa
    80201652:	07b2                	slli	a5,a5,0xc
    80201654:	fcf43423          	sd	a5,-56(s0)
    80201658:	a089                	j	8020169a <walk_create+0xae>
        } else {
            pagetable_t new_pt = (pagetable_t)alloc_page();
    8020165a:	00000097          	auipc	ra,0x0
    8020165e:	7b6080e7          	jalr	1974(ra) # 80201e10 <alloc_page>
    80201662:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    80201666:	fd843783          	ld	a5,-40(s0)
    8020166a:	e399                	bnez	a5,80201670 <walk_create+0x84>
                return 0;
    8020166c:	4781                	li	a5,0
    8020166e:	a8a1                	j	802016c6 <walk_create+0xda>
            memset(new_pt, 0, PGSIZE);
    80201670:	6605                	lui	a2,0x1
    80201672:	4581                	li	a1,0
    80201674:	fd843503          	ld	a0,-40(s0)
    80201678:	00000097          	auipc	ra,0x0
    8020167c:	dbc080e7          	jalr	-580(ra) # 80201434 <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    80201680:	fd843783          	ld	a5,-40(s0)
    80201684:	83b1                	srli	a5,a5,0xc
    80201686:	07aa                	slli	a5,a5,0xa
    80201688:	0017e713          	ori	a4,a5,1
    8020168c:	fe043783          	ld	a5,-32(s0)
    80201690:	e398                	sd	a4,0(a5)
            pt = new_pt;
    80201692:	fd843783          	ld	a5,-40(s0)
    80201696:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    8020169a:	fec42783          	lw	a5,-20(s0)
    8020169e:	37fd                	addiw	a5,a5,-1
    802016a0:	fef42623          	sw	a5,-20(s0)
    802016a4:	fec42783          	lw	a5,-20(s0)
    802016a8:	2781                	sext.w	a5,a5
    802016aa:	f6f04be3          	bgtz	a5,80201620 <walk_create+0x34>
        }
    }
    return &pt[px(0, va)];
    802016ae:	fc043583          	ld	a1,-64(s0)
    802016b2:	4501                	li	a0,0
    802016b4:	00000097          	auipc	ra,0x0
    802016b8:	e1a080e7          	jalr	-486(ra) # 802014ce <px>
    802016bc:	87aa                	mv	a5,a0
    802016be:	078e                	slli	a5,a5,0x3
    802016c0:	fc843703          	ld	a4,-56(s0)
    802016c4:	97ba                	add	a5,a5,a4
}
    802016c6:	853e                	mv	a0,a5
    802016c8:	70e2                	ld	ra,56(sp)
    802016ca:	7442                	ld	s0,48(sp)
    802016cc:	6121                	addi	sp,sp,64
    802016ce:	8082                	ret

00000000802016d0 <map_page>:

// 建立映射，允许重映射到相同物理地址
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    802016d0:	7139                	addi	sp,sp,-64
    802016d2:	fc06                	sd	ra,56(sp)
    802016d4:	f822                	sd	s0,48(sp)
    802016d6:	0080                	addi	s0,sp,64
    802016d8:	fca43c23          	sd	a0,-40(s0)
    802016dc:	fcb43823          	sd	a1,-48(s0)
    802016e0:	fcc43423          	sd	a2,-56(s0)
    802016e4:	87b6                	mv	a5,a3
    802016e6:	fcf42223          	sw	a5,-60(s0)
    if ((va % PGSIZE) != 0)
    802016ea:	fd043703          	ld	a4,-48(s0)
    802016ee:	6785                	lui	a5,0x1
    802016f0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802016f2:	8ff9                	and	a5,a5,a4
    802016f4:	cb89                	beqz	a5,80201706 <map_page+0x36>
        panic("map_page: va not aligned");
    802016f6:	00002517          	auipc	a0,0x2
    802016fa:	3fa50513          	addi	a0,a0,1018 # 80203af0 <small_numbers+0x9d0>
    802016fe:	fffff097          	auipc	ra,0xfffff
    80201702:	666080e7          	jalr	1638(ra) # 80200d64 <panic>
    pte_t *pte = walk_create(pt, va);
    80201706:	fd043583          	ld	a1,-48(s0)
    8020170a:	fd843503          	ld	a0,-40(s0)
    8020170e:	00000097          	auipc	ra,0x0
    80201712:	ede080e7          	jalr	-290(ra) # 802015ec <walk_create>
    80201716:	fea43423          	sd	a0,-24(s0)
    if (!pte)
    8020171a:	fe843783          	ld	a5,-24(s0)
    8020171e:	e399                	bnez	a5,80201724 <map_page+0x54>
        return -1;
    80201720:	57fd                	li	a5,-1
    80201722:	a069                	j	802017ac <map_page+0xdc>
    
    // 检查是否已经映射
	if (*pte & PTE_V) {
    80201724:	fe843783          	ld	a5,-24(s0)
    80201728:	639c                	ld	a5,0(a5)
    8020172a:	8b85                	andi	a5,a5,1
    8020172c:	c3b5                	beqz	a5,80201790 <map_page+0xc0>
		if (PTE2PA(*pte) == pa) {
    8020172e:	fe843783          	ld	a5,-24(s0)
    80201732:	639c                	ld	a5,0(a5)
    80201734:	83a9                	srli	a5,a5,0xa
    80201736:	07b2                	slli	a5,a5,0xc
    80201738:	fc843703          	ld	a4,-56(s0)
    8020173c:	04f71263          	bne	a4,a5,80201780 <map_page+0xb0>
			// 只允许提升权限，不允许降低权限
			int new_perm = ((*pte & PTE_FLAGS) | perm) & PTE_FLAGS;
    80201740:	fe843783          	ld	a5,-24(s0)
    80201744:	639c                	ld	a5,0(a5)
    80201746:	2781                	sext.w	a5,a5
    80201748:	3ff7f793          	andi	a5,a5,1023
    8020174c:	0007871b          	sext.w	a4,a5
    80201750:	fc442783          	lw	a5,-60(s0)
    80201754:	8fd9                	or	a5,a5,a4
    80201756:	2781                	sext.w	a5,a5
    80201758:	2781                	sext.w	a5,a5
    8020175a:	3ff7f793          	andi	a5,a5,1023
    8020175e:	fef42223          	sw	a5,-28(s0)
			*pte = PA2PTE(pa) | new_perm | PTE_V;
    80201762:	fc843783          	ld	a5,-56(s0)
    80201766:	83b1                	srli	a5,a5,0xc
    80201768:	00a79713          	slli	a4,a5,0xa
    8020176c:	fe442783          	lw	a5,-28(s0)
    80201770:	8fd9                	or	a5,a5,a4
    80201772:	0017e713          	ori	a4,a5,1
    80201776:	fe843783          	ld	a5,-24(s0)
    8020177a:	e398                	sd	a4,0(a5)
			return 0;
    8020177c:	4781                	li	a5,0
    8020177e:	a03d                	j	802017ac <map_page+0xdc>
		} else {
			panic("map_page: remap to different physical address");
    80201780:	00002517          	auipc	a0,0x2
    80201784:	39050513          	addi	a0,a0,912 # 80203b10 <small_numbers+0x9f0>
    80201788:	fffff097          	auipc	ra,0xfffff
    8020178c:	5dc080e7          	jalr	1500(ra) # 80200d64 <panic>
		}
	}
    
    *pte = PA2PTE(pa) | perm | PTE_V;
    80201790:	fc843783          	ld	a5,-56(s0)
    80201794:	83b1                	srli	a5,a5,0xc
    80201796:	00a79713          	slli	a4,a5,0xa
    8020179a:	fc442783          	lw	a5,-60(s0)
    8020179e:	8fd9                	or	a5,a5,a4
    802017a0:	0017e713          	ori	a4,a5,1
    802017a4:	fe843783          	ld	a5,-24(s0)
    802017a8:	e398                	sd	a4,0(a5)
    return 0;
    802017aa:	4781                	li	a5,0
}
    802017ac:	853e                	mv	a0,a5
    802017ae:	70e2                	ld	ra,56(sp)
    802017b0:	7442                	ld	s0,48(sp)
    802017b2:	6121                	addi	sp,sp,64
    802017b4:	8082                	ret

00000000802017b6 <free_pagetable>:
// 递归释放页表
void free_pagetable(pagetable_t pt) {
    802017b6:	7139                	addi	sp,sp,-64
    802017b8:	fc06                	sd	ra,56(sp)
    802017ba:	f822                	sd	s0,48(sp)
    802017bc:	0080                	addi	s0,sp,64
    802017be:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    802017c2:	fe042623          	sw	zero,-20(s0)
    802017c6:	a8a5                	j	8020183e <free_pagetable+0x88>
        pte_t pte = pt[i];
    802017c8:	fec42783          	lw	a5,-20(s0)
    802017cc:	078e                	slli	a5,a5,0x3
    802017ce:	fc843703          	ld	a4,-56(s0)
    802017d2:	97ba                	add	a5,a5,a4
    802017d4:	639c                	ld	a5,0(a5)
    802017d6:	fef43023          	sd	a5,-32(s0)
        // 只释放中间页表
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    802017da:	fe043783          	ld	a5,-32(s0)
    802017de:	8b85                	andi	a5,a5,1
    802017e0:	cb95                	beqz	a5,80201814 <free_pagetable+0x5e>
    802017e2:	fe043783          	ld	a5,-32(s0)
    802017e6:	8bb9                	andi	a5,a5,14
    802017e8:	e795                	bnez	a5,80201814 <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    802017ea:	fe043783          	ld	a5,-32(s0)
    802017ee:	83a9                	srli	a5,a5,0xa
    802017f0:	07b2                	slli	a5,a5,0xc
    802017f2:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    802017f6:	fd843503          	ld	a0,-40(s0)
    802017fa:	00000097          	auipc	ra,0x0
    802017fe:	fbc080e7          	jalr	-68(ra) # 802017b6 <free_pagetable>
            pt[i] = 0;
    80201802:	fec42783          	lw	a5,-20(s0)
    80201806:	078e                	slli	a5,a5,0x3
    80201808:	fc843703          	ld	a4,-56(s0)
    8020180c:	97ba                	add	a5,a5,a4
    8020180e:	0007b023          	sd	zero,0(a5)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80201812:	a00d                	j	80201834 <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    80201814:	fe043783          	ld	a5,-32(s0)
    80201818:	8b85                	andi	a5,a5,1
    8020181a:	cf89                	beqz	a5,80201834 <free_pagetable+0x7e>
    8020181c:	fe043783          	ld	a5,-32(s0)
    80201820:	8bb9                	andi	a5,a5,14
    80201822:	cb89                	beqz	a5,80201834 <free_pagetable+0x7e>
            pt[i] = 0;
    80201824:	fec42783          	lw	a5,-20(s0)
    80201828:	078e                	slli	a5,a5,0x3
    8020182a:	fc843703          	ld	a4,-56(s0)
    8020182e:	97ba                	add	a5,a5,a4
    80201830:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    80201834:	fec42783          	lw	a5,-20(s0)
    80201838:	2785                	addiw	a5,a5,1
    8020183a:	fef42623          	sw	a5,-20(s0)
    8020183e:	fec42783          	lw	a5,-20(s0)
    80201842:	0007871b          	sext.w	a4,a5
    80201846:	1ff00793          	li	a5,511
    8020184a:	f6e7dfe3          	bge	a5,a4,802017c8 <free_pagetable+0x12>
        }
    }
    free_page(pt);
    8020184e:	fc843503          	ld	a0,-56(s0)
    80201852:	00000097          	auipc	ra,0x0
    80201856:	62a080e7          	jalr	1578(ra) # 80201e7c <free_page>
}
    8020185a:	0001                	nop
    8020185c:	70e2                	ld	ra,56(sp)
    8020185e:	7442                	ld	s0,48(sp)
    80201860:	6121                	addi	sp,sp,64
    80201862:	8082                	ret

0000000080201864 <kvmmake>:

// 内核页表构建（仅映射内核代码和数据，实际可根据需要扩展）
static pagetable_t kvmmake(void) {
    80201864:	711d                	addi	sp,sp,-96
    80201866:	ec86                	sd	ra,88(sp)
    80201868:	e8a2                	sd	s0,80(sp)
    8020186a:	1080                	addi	s0,sp,96
    pagetable_t kpgtbl = create_pagetable();
    8020186c:	00000097          	auipc	ra,0x0
    80201870:	c9c080e7          	jalr	-868(ra) # 80201508 <create_pagetable>
    80201874:	faa43c23          	sd	a0,-72(s0)
    if (!kpgtbl)
    80201878:	fb843783          	ld	a5,-72(s0)
    8020187c:	eb89                	bnez	a5,8020188e <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    8020187e:	00002517          	auipc	a0,0x2
    80201882:	2c250513          	addi	a0,a0,706 # 80203b40 <small_numbers+0xa20>
    80201886:	fffff097          	auipc	ra,0xfffff
    8020188a:	4de080e7          	jalr	1246(ra) # 80200d64 <panic>
    // 1. 映射内核代码和数据区域（只读+执行 / 读写）
    extern char etext[];  // 在kernel.ld中定义，内核代码段结束位置
    extern char end[];    // 在kernel.ld中定义，内核数据段结束位置
    
    // 内核代码段 - 只读可执行
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    8020188e:	4785                	li	a5,1
    80201890:	07fe                	slli	a5,a5,0x1f
    80201892:	fef43423          	sd	a5,-24(s0)
    80201896:	a825                	j	802018ce <kvmmake+0x6a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_X) != 0)
    80201898:	46a9                	li	a3,10
    8020189a:	fe843603          	ld	a2,-24(s0)
    8020189e:	fe843583          	ld	a1,-24(s0)
    802018a2:	fb843503          	ld	a0,-72(s0)
    802018a6:	00000097          	auipc	ra,0x0
    802018aa:	e2a080e7          	jalr	-470(ra) # 802016d0 <map_page>
    802018ae:	87aa                	mv	a5,a0
    802018b0:	cb89                	beqz	a5,802018c2 <kvmmake+0x5e>
            panic("kvmmake: code map failed");
    802018b2:	00002517          	auipc	a0,0x2
    802018b6:	2a650513          	addi	a0,a0,678 # 80203b58 <small_numbers+0xa38>
    802018ba:	fffff097          	auipc	ra,0xfffff
    802018be:	4aa080e7          	jalr	1194(ra) # 80200d64 <panic>
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    802018c2:	fe843703          	ld	a4,-24(s0)
    802018c6:	6785                	lui	a5,0x1
    802018c8:	97ba                	add	a5,a5,a4
    802018ca:	fef43423          	sd	a5,-24(s0)
    802018ce:	00001797          	auipc	a5,0x1
    802018d2:	73278793          	addi	a5,a5,1842 # 80203000 <etext>
    802018d6:	fe843703          	ld	a4,-24(s0)
    802018da:	faf76fe3          	bltu	a4,a5,80201898 <kvmmake+0x34>
    }
    
    // 内核数据段 - 可读写
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    802018de:	00001797          	auipc	a5,0x1
    802018e2:	72278793          	addi	a5,a5,1826 # 80203000 <etext>
    802018e6:	fef43023          	sd	a5,-32(s0)
    802018ea:	a825                	j	80201922 <kvmmake+0xbe>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802018ec:	4699                	li	a3,6
    802018ee:	fe043603          	ld	a2,-32(s0)
    802018f2:	fe043583          	ld	a1,-32(s0)
    802018f6:	fb843503          	ld	a0,-72(s0)
    802018fa:	00000097          	auipc	ra,0x0
    802018fe:	dd6080e7          	jalr	-554(ra) # 802016d0 <map_page>
    80201902:	87aa                	mv	a5,a0
    80201904:	cb89                	beqz	a5,80201916 <kvmmake+0xb2>
            panic("kvmmake: data map failed");
    80201906:	00002517          	auipc	a0,0x2
    8020190a:	27250513          	addi	a0,a0,626 # 80203b78 <small_numbers+0xa58>
    8020190e:	fffff097          	auipc	ra,0xfffff
    80201912:	456080e7          	jalr	1110(ra) # 80200d64 <panic>
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    80201916:	fe043703          	ld	a4,-32(s0)
    8020191a:	6785                	lui	a5,0x1
    8020191c:	97ba                	add	a5,a5,a4
    8020191e:	fef43023          	sd	a5,-32(s0)
    80201922:	00005797          	auipc	a5,0x5
    80201926:	99e78793          	addi	a5,a5,-1634 # 802062c0 <_bss_end>
    8020192a:	fe043703          	ld	a4,-32(s0)
    8020192e:	faf76fe3          	bltu	a4,a5,802018ec <kvmmake+0x88>
    }
    
	// 2. 映射内核堆区域 - 可读写
	uint64 aligned_end = ((uint64)end + PGSIZE - 1) & ~(PGSIZE - 1); // 向上对齐到页边界
    80201932:	00005717          	auipc	a4,0x5
    80201936:	98e70713          	addi	a4,a4,-1650 # 802062c0 <_bss_end>
    8020193a:	6785                	lui	a5,0x1
    8020193c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    8020193e:	973e                	add	a4,a4,a5
    80201940:	77fd                	lui	a5,0xfffff
    80201942:	8ff9                	and	a5,a5,a4
    80201944:	faf43823          	sd	a5,-80(s0)
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    80201948:	fb043783          	ld	a5,-80(s0)
    8020194c:	fcf43c23          	sd	a5,-40(s0)
    80201950:	a825                	j	80201988 <kvmmake+0x124>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201952:	4699                	li	a3,6
    80201954:	fd843603          	ld	a2,-40(s0)
    80201958:	fd843583          	ld	a1,-40(s0)
    8020195c:	fb843503          	ld	a0,-72(s0)
    80201960:	00000097          	auipc	ra,0x0
    80201964:	d70080e7          	jalr	-656(ra) # 802016d0 <map_page>
    80201968:	87aa                	mv	a5,a0
    8020196a:	cb89                	beqz	a5,8020197c <kvmmake+0x118>
			panic("kvmmake: heap map failed");
    8020196c:	00002517          	auipc	a0,0x2
    80201970:	22c50513          	addi	a0,a0,556 # 80203b98 <small_numbers+0xa78>
    80201974:	fffff097          	auipc	ra,0xfffff
    80201978:	3f0080e7          	jalr	1008(ra) # 80200d64 <panic>
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    8020197c:	fd843703          	ld	a4,-40(s0)
    80201980:	6785                	lui	a5,0x1
    80201982:	97ba                	add	a5,a5,a4
    80201984:	fcf43c23          	sd	a5,-40(s0)
    80201988:	fd843703          	ld	a4,-40(s0)
    8020198c:	47c5                	li	a5,17
    8020198e:	07ee                	slli	a5,a5,0x1b
    80201990:	fcf761e3          	bltu	a4,a5,80201952 <kvmmake+0xee>
	}
    
    // 3. 映射设备区域 - 只读写，不可执行
    // UART 串口设备
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    80201994:	4699                	li	a3,6
    80201996:	10000637          	lui	a2,0x10000
    8020199a:	100005b7          	lui	a1,0x10000
    8020199e:	fb843503          	ld	a0,-72(s0)
    802019a2:	00000097          	auipc	ra,0x0
    802019a6:	d2e080e7          	jalr	-722(ra) # 802016d0 <map_page>
    802019aa:	87aa                	mv	a5,a0
    802019ac:	cb89                	beqz	a5,802019be <kvmmake+0x15a>
        panic("kvmmake: uart map failed");
    802019ae:	00002517          	auipc	a0,0x2
    802019b2:	20a50513          	addi	a0,a0,522 # 80203bb8 <small_numbers+0xa98>
    802019b6:	fffff097          	auipc	ra,0xfffff
    802019ba:	3ae080e7          	jalr	942(ra) # 80200d64 <panic>
    
    // PLIC 中断控制器
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    802019be:	0c0007b7          	lui	a5,0xc000
    802019c2:	fcf43823          	sd	a5,-48(s0)
    802019c6:	a825                	j	802019fe <kvmmake+0x19a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802019c8:	4699                	li	a3,6
    802019ca:	fd043603          	ld	a2,-48(s0)
    802019ce:	fd043583          	ld	a1,-48(s0)
    802019d2:	fb843503          	ld	a0,-72(s0)
    802019d6:	00000097          	auipc	ra,0x0
    802019da:	cfa080e7          	jalr	-774(ra) # 802016d0 <map_page>
    802019de:	87aa                	mv	a5,a0
    802019e0:	cb89                	beqz	a5,802019f2 <kvmmake+0x18e>
            panic("kvmmake: plic map failed");
    802019e2:	00002517          	auipc	a0,0x2
    802019e6:	1f650513          	addi	a0,a0,502 # 80203bd8 <small_numbers+0xab8>
    802019ea:	fffff097          	auipc	ra,0xfffff
    802019ee:	37a080e7          	jalr	890(ra) # 80200d64 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    802019f2:	fd043703          	ld	a4,-48(s0)
    802019f6:	6785                	lui	a5,0x1
    802019f8:	97ba                	add	a5,a5,a4
    802019fa:	fcf43823          	sd	a5,-48(s0)
    802019fe:	fd043703          	ld	a4,-48(s0)
    80201a02:	0c4007b7          	lui	a5,0xc400
    80201a06:	fcf761e3          	bltu	a4,a5,802019c8 <kvmmake+0x164>
    }
    
    // CLINT 本地中断控制器 - 完善映射
    // 确保整个 CLINT 区域被映射，特别是 mtimecmp 和 mtime 寄存器
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80201a0a:	020007b7          	lui	a5,0x2000
    80201a0e:	fcf43423          	sd	a5,-56(s0)
    80201a12:	a825                	j	80201a4a <kvmmake+0x1e6>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201a14:	4699                	li	a3,6
    80201a16:	fc843603          	ld	a2,-56(s0)
    80201a1a:	fc843583          	ld	a1,-56(s0)
    80201a1e:	fb843503          	ld	a0,-72(s0)
    80201a22:	00000097          	auipc	ra,0x0
    80201a26:	cae080e7          	jalr	-850(ra) # 802016d0 <map_page>
    80201a2a:	87aa                	mv	a5,a0
    80201a2c:	cb89                	beqz	a5,80201a3e <kvmmake+0x1da>
            panic("kvmmake: clint map failed");
    80201a2e:	00002517          	auipc	a0,0x2
    80201a32:	1ca50513          	addi	a0,a0,458 # 80203bf8 <small_numbers+0xad8>
    80201a36:	fffff097          	auipc	ra,0xfffff
    80201a3a:	32e080e7          	jalr	814(ra) # 80200d64 <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80201a3e:	fc843703          	ld	a4,-56(s0)
    80201a42:	6785                	lui	a5,0x1
    80201a44:	97ba                	add	a5,a5,a4
    80201a46:	fcf43423          	sd	a5,-56(s0)
    80201a4a:	fc843703          	ld	a4,-56(s0)
    80201a4e:	020107b7          	lui	a5,0x2010
    80201a52:	fcf761e3          	bltu	a4,a5,80201a14 <kvmmake+0x1b0>
	}
    
    // VIRTIO 设备
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    80201a56:	4699                	li	a3,6
    80201a58:	10001637          	lui	a2,0x10001
    80201a5c:	100015b7          	lui	a1,0x10001
    80201a60:	fb843503          	ld	a0,-72(s0)
    80201a64:	00000097          	auipc	ra,0x0
    80201a68:	c6c080e7          	jalr	-916(ra) # 802016d0 <map_page>
    80201a6c:	87aa                	mv	a5,a0
    80201a6e:	cb89                	beqz	a5,80201a80 <kvmmake+0x21c>
        panic("kvmmake: virtio map failed");
    80201a70:	00002517          	auipc	a0,0x2
    80201a74:	1a850513          	addi	a0,a0,424 # 80203c18 <small_numbers+0xaf8>
    80201a78:	fffff097          	auipc	ra,0xfffff
    80201a7c:	2ec080e7          	jalr	748(ra) # 80200d64 <panic>
    
    // 4. 扩大SBI调用区域映射
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    80201a80:	fc043023          	sd	zero,-64(s0)
    80201a84:	a825                	j	80201abc <kvmmake+0x258>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80201a86:	4699                	li	a3,6
    80201a88:	fc043603          	ld	a2,-64(s0)
    80201a8c:	fc043583          	ld	a1,-64(s0)
    80201a90:	fb843503          	ld	a0,-72(s0)
    80201a94:	00000097          	auipc	ra,0x0
    80201a98:	c3c080e7          	jalr	-964(ra) # 802016d0 <map_page>
    80201a9c:	87aa                	mv	a5,a0
    80201a9e:	cb89                	beqz	a5,80201ab0 <kvmmake+0x24c>
			panic("kvmmake: low memory map failed");
    80201aa0:	00002517          	auipc	a0,0x2
    80201aa4:	19850513          	addi	a0,a0,408 # 80203c38 <small_numbers+0xb18>
    80201aa8:	fffff097          	auipc	ra,0xfffff
    80201aac:	2bc080e7          	jalr	700(ra) # 80200d64 <panic>
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    80201ab0:	fc043703          	ld	a4,-64(s0)
    80201ab4:	6785                	lui	a5,0x1
    80201ab6:	97ba                	add	a5,a5,a4
    80201ab8:	fcf43023          	sd	a5,-64(s0)
    80201abc:	fc043703          	ld	a4,-64(s0)
    80201ac0:	001007b7          	lui	a5,0x100
    80201ac4:	fcf761e3          	bltu	a4,a5,80201a86 <kvmmake+0x222>
	}

	// 特别映射包含0xfd02080的页
	uint64 sbi_special = 0xfd02000;  // 页对齐
    80201ac8:	0fd027b7          	lui	a5,0xfd02
    80201acc:	faf43423          	sd	a5,-88(s0)
	if (map_page(kpgtbl, sbi_special, sbi_special, PTE_R | PTE_W) != 0)
    80201ad0:	4699                	li	a3,6
    80201ad2:	fa843603          	ld	a2,-88(s0)
    80201ad6:	fa843583          	ld	a1,-88(s0)
    80201ada:	fb843503          	ld	a0,-72(s0)
    80201ade:	00000097          	auipc	ra,0x0
    80201ae2:	bf2080e7          	jalr	-1038(ra) # 802016d0 <map_page>
    80201ae6:	87aa                	mv	a5,a0
    80201ae8:	cb89                	beqz	a5,80201afa <kvmmake+0x296>
		panic("kvmmake: sbi special area map failed");
    80201aea:	00002517          	auipc	a0,0x2
    80201aee:	16e50513          	addi	a0,a0,366 # 80203c58 <small_numbers+0xb38>
    80201af2:	fffff097          	auipc	ra,0xfffff
    80201af6:	272080e7          	jalr	626(ra) # 80200d64 <panic>
    
    return kpgtbl;
    80201afa:	fb843783          	ld	a5,-72(s0)
}
    80201afe:	853e                	mv	a0,a5
    80201b00:	60e6                	ld	ra,88(sp)
    80201b02:	6446                	ld	s0,80(sp)
    80201b04:	6125                	addi	sp,sp,96
    80201b06:	8082                	ret

0000000080201b08 <kvminit>:
// 初始化内核页表
void kvminit(void) {
    80201b08:	1141                	addi	sp,sp,-16
    80201b0a:	e406                	sd	ra,8(sp)
    80201b0c:	e022                	sd	s0,0(sp)
    80201b0e:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    80201b10:	00000097          	auipc	ra,0x0
    80201b14:	d54080e7          	jalr	-684(ra) # 80201864 <kvmmake>
    80201b18:	872a                	mv	a4,a0
    80201b1a:	00004797          	auipc	a5,0x4
    80201b1e:	50678793          	addi	a5,a5,1286 # 80206020 <kernel_pagetable>
    80201b22:	e398                	sd	a4,0(a5)
}
    80201b24:	0001                	nop
    80201b26:	60a2                	ld	ra,8(sp)
    80201b28:	6402                	ld	s0,0(sp)
    80201b2a:	0141                	addi	sp,sp,16
    80201b2c:	8082                	ret

0000000080201b2e <w_satp>:

// 启用分页（单核只需设置一次 satp 并刷新 TLB）
static inline void w_satp(uint64 x) {
    80201b2e:	1101                	addi	sp,sp,-32
    80201b30:	ec22                	sd	s0,24(sp)
    80201b32:	1000                	addi	s0,sp,32
    80201b34:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    80201b38:	fe843783          	ld	a5,-24(s0)
    80201b3c:	18079073          	csrw	satp,a5
}
    80201b40:	0001                	nop
    80201b42:	6462                	ld	s0,24(sp)
    80201b44:	6105                	addi	sp,sp,32
    80201b46:	8082                	ret

0000000080201b48 <sfence_vma>:

static inline void sfence_vma(void) {
    80201b48:	1141                	addi	sp,sp,-16
    80201b4a:	e422                	sd	s0,8(sp)
    80201b4c:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    80201b4e:	12000073          	sfence.vma
}
    80201b52:	0001                	nop
    80201b54:	6422                	ld	s0,8(sp)
    80201b56:	0141                	addi	sp,sp,16
    80201b58:	8082                	ret

0000000080201b5a <kvminithart>:

void kvminithart(void) {
    80201b5a:	1141                	addi	sp,sp,-16
    80201b5c:	e406                	sd	ra,8(sp)
    80201b5e:	e022                	sd	s0,0(sp)
    80201b60:	0800                	addi	s0,sp,16
    sfence_vma();
    80201b62:	00000097          	auipc	ra,0x0
    80201b66:	fe6080e7          	jalr	-26(ra) # 80201b48 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    80201b6a:	00004797          	auipc	a5,0x4
    80201b6e:	4b678793          	addi	a5,a5,1206 # 80206020 <kernel_pagetable>
    80201b72:	639c                	ld	a5,0(a5)
    80201b74:	00c7d713          	srli	a4,a5,0xc
    80201b78:	57fd                	li	a5,-1
    80201b7a:	17fe                	slli	a5,a5,0x3f
    80201b7c:	8fd9                	or	a5,a5,a4
    80201b7e:	853e                	mv	a0,a5
    80201b80:	00000097          	auipc	ra,0x0
    80201b84:	fae080e7          	jalr	-82(ra) # 80201b2e <w_satp>
    sfence_vma();
    80201b88:	00000097          	auipc	ra,0x0
    80201b8c:	fc0080e7          	jalr	-64(ra) # 80201b48 <sfence_vma>
}
    80201b90:	0001                	nop
    80201b92:	60a2                	ld	ra,8(sp)
    80201b94:	6402                	ld	s0,0(sp)
    80201b96:	0141                	addi	sp,sp,16
    80201b98:	8082                	ret

0000000080201b9a <test_pagetable>:

void test_pagetable(void) {
    80201b9a:	7179                	addi	sp,sp,-48
    80201b9c:	f406                	sd	ra,40(sp)
    80201b9e:	f022                	sd	s0,32(sp)
    80201ba0:	1800                	addi	s0,sp,48
    printf("[PT TEST] 创建页表...\n");
    80201ba2:	00002517          	auipc	a0,0x2
    80201ba6:	0de50513          	addi	a0,a0,222 # 80203c80 <small_numbers+0xb60>
    80201baa:	fffff097          	auipc	ra,0xfffff
    80201bae:	8b2080e7          	jalr	-1870(ra) # 8020045c <printf>
    pagetable_t pt = create_pagetable();
    80201bb2:	00000097          	auipc	ra,0x0
    80201bb6:	956080e7          	jalr	-1706(ra) # 80201508 <create_pagetable>
    80201bba:	fea43423          	sd	a0,-24(s0)
    assert(pt != 0);
    80201bbe:	fe843783          	ld	a5,-24(s0)
    80201bc2:	00f037b3          	snez	a5,a5
    80201bc6:	0ff7f793          	zext.b	a5,a5
    80201bca:	2781                	sext.w	a5,a5
    80201bcc:	853e                	mv	a0,a5
    80201bce:	00000097          	auipc	ra,0x0
    80201bd2:	8b6080e7          	jalr	-1866(ra) # 80201484 <assert>
    printf("[PT TEST] 页表创建通过\n");
    80201bd6:	00002517          	auipc	a0,0x2
    80201bda:	0ca50513          	addi	a0,a0,202 # 80203ca0 <small_numbers+0xb80>
    80201bde:	fffff097          	auipc	ra,0xfffff
    80201be2:	87e080e7          	jalr	-1922(ra) # 8020045c <printf>

    // 测试基本映射
    uint64 va = 0x1000000;
    80201be6:	010007b7          	lui	a5,0x1000
    80201bea:	fef43023          	sd	a5,-32(s0)
    uint64 pa = (uint64)alloc_page();
    80201bee:	00000097          	auipc	ra,0x0
    80201bf2:	222080e7          	jalr	546(ra) # 80201e10 <alloc_page>
    80201bf6:	87aa                	mv	a5,a0
    80201bf8:	fcf43c23          	sd	a5,-40(s0)
    assert(pa != 0);
    80201bfc:	fd843783          	ld	a5,-40(s0)
    80201c00:	00f037b3          	snez	a5,a5
    80201c04:	0ff7f793          	zext.b	a5,a5
    80201c08:	2781                	sext.w	a5,a5
    80201c0a:	853e                	mv	a0,a5
    80201c0c:	00000097          	auipc	ra,0x0
    80201c10:	878080e7          	jalr	-1928(ra) # 80201484 <assert>
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0);
    80201c14:	4699                	li	a3,6
    80201c16:	fd843603          	ld	a2,-40(s0)
    80201c1a:	fe043583          	ld	a1,-32(s0)
    80201c1e:	fe843503          	ld	a0,-24(s0)
    80201c22:	00000097          	auipc	ra,0x0
    80201c26:	aae080e7          	jalr	-1362(ra) # 802016d0 <map_page>
    80201c2a:	87aa                	mv	a5,a0
    80201c2c:	0017b793          	seqz	a5,a5
    80201c30:	0ff7f793          	zext.b	a5,a5
    80201c34:	2781                	sext.w	a5,a5
    80201c36:	853e                	mv	a0,a5
    80201c38:	00000097          	auipc	ra,0x0
    80201c3c:	84c080e7          	jalr	-1972(ra) # 80201484 <assert>
    printf("[PT TEST] 映射测试通过\n");
    80201c40:	00002517          	auipc	a0,0x2
    80201c44:	08050513          	addi	a0,a0,128 # 80203cc0 <small_numbers+0xba0>
    80201c48:	fffff097          	auipc	ra,0xfffff
    80201c4c:	814080e7          	jalr	-2028(ra) # 8020045c <printf>

    // 测试地址转换
    pte_t *pte = walk_lookup(pt, va);
    80201c50:	fe043583          	ld	a1,-32(s0)
    80201c54:	fe843503          	ld	a0,-24(s0)
    80201c58:	00000097          	auipc	ra,0x0
    80201c5c:	8ec080e7          	jalr	-1812(ra) # 80201544 <walk_lookup>
    80201c60:	fca43823          	sd	a0,-48(s0)
    assert(pte != 0 && (*pte & PTE_V));
    80201c64:	fd043783          	ld	a5,-48(s0)
    80201c68:	cb81                	beqz	a5,80201c78 <test_pagetable+0xde>
    80201c6a:	fd043783          	ld	a5,-48(s0)
    80201c6e:	639c                	ld	a5,0(a5)
    80201c70:	8b85                	andi	a5,a5,1
    80201c72:	c399                	beqz	a5,80201c78 <test_pagetable+0xde>
    80201c74:	4785                	li	a5,1
    80201c76:	a011                	j	80201c7a <test_pagetable+0xe0>
    80201c78:	4781                	li	a5,0
    80201c7a:	853e                	mv	a0,a5
    80201c7c:	00000097          	auipc	ra,0x0
    80201c80:	808080e7          	jalr	-2040(ra) # 80201484 <assert>
    assert(PTE2PA(*pte) == pa);
    80201c84:	fd043783          	ld	a5,-48(s0)
    80201c88:	639c                	ld	a5,0(a5)
    80201c8a:	83a9                	srli	a5,a5,0xa
    80201c8c:	07b2                	slli	a5,a5,0xc
    80201c8e:	fd843703          	ld	a4,-40(s0)
    80201c92:	40f707b3          	sub	a5,a4,a5
    80201c96:	0017b793          	seqz	a5,a5
    80201c9a:	0ff7f793          	zext.b	a5,a5
    80201c9e:	2781                	sext.w	a5,a5
    80201ca0:	853e                	mv	a0,a5
    80201ca2:	fffff097          	auipc	ra,0xfffff
    80201ca6:	7e2080e7          	jalr	2018(ra) # 80201484 <assert>
    printf("[PT TEST] 地址转换测试通过\n");
    80201caa:	00002517          	auipc	a0,0x2
    80201cae:	03650513          	addi	a0,a0,54 # 80203ce0 <small_numbers+0xbc0>
    80201cb2:	ffffe097          	auipc	ra,0xffffe
    80201cb6:	7aa080e7          	jalr	1962(ra) # 8020045c <printf>

    // 测试权限位
    assert(*pte & PTE_R);
    80201cba:	fd043783          	ld	a5,-48(s0)
    80201cbe:	639c                	ld	a5,0(a5)
    80201cc0:	2781                	sext.w	a5,a5
    80201cc2:	8b89                	andi	a5,a5,2
    80201cc4:	2781                	sext.w	a5,a5
    80201cc6:	853e                	mv	a0,a5
    80201cc8:	fffff097          	auipc	ra,0xfffff
    80201ccc:	7bc080e7          	jalr	1980(ra) # 80201484 <assert>
    assert(*pte & PTE_W);
    80201cd0:	fd043783          	ld	a5,-48(s0)
    80201cd4:	639c                	ld	a5,0(a5)
    80201cd6:	2781                	sext.w	a5,a5
    80201cd8:	8b91                	andi	a5,a5,4
    80201cda:	2781                	sext.w	a5,a5
    80201cdc:	853e                	mv	a0,a5
    80201cde:	fffff097          	auipc	ra,0xfffff
    80201ce2:	7a6080e7          	jalr	1958(ra) # 80201484 <assert>
    assert(!(*pte & PTE_X));
    80201ce6:	fd043783          	ld	a5,-48(s0)
    80201cea:	639c                	ld	a5,0(a5)
    80201cec:	8ba1                	andi	a5,a5,8
    80201cee:	0017b793          	seqz	a5,a5
    80201cf2:	0ff7f793          	zext.b	a5,a5
    80201cf6:	2781                	sext.w	a5,a5
    80201cf8:	853e                	mv	a0,a5
    80201cfa:	fffff097          	auipc	ra,0xfffff
    80201cfe:	78a080e7          	jalr	1930(ra) # 80201484 <assert>
    printf("[PT TEST] 权限测试通过\n");
    80201d02:	00002517          	auipc	a0,0x2
    80201d06:	00650513          	addi	a0,a0,6 # 80203d08 <small_numbers+0xbe8>
    80201d0a:	ffffe097          	auipc	ra,0xffffe
    80201d0e:	752080e7          	jalr	1874(ra) # 8020045c <printf>

    // 清理
    free_page((void*)pa);
    80201d12:	fd843783          	ld	a5,-40(s0)
    80201d16:	853e                	mv	a0,a5
    80201d18:	00000097          	auipc	ra,0x0
    80201d1c:	164080e7          	jalr	356(ra) # 80201e7c <free_page>
    free_pagetable(pt);
    80201d20:	fe843503          	ld	a0,-24(s0)
    80201d24:	00000097          	auipc	ra,0x0
    80201d28:	a92080e7          	jalr	-1390(ra) # 802017b6 <free_pagetable>

    printf("[PT TEST] 所有页表测试通过\n");
    80201d2c:	00002517          	auipc	a0,0x2
    80201d30:	ffc50513          	addi	a0,a0,-4 # 80203d28 <small_numbers+0xc08>
    80201d34:	ffffe097          	auipc	ra,0xffffe
    80201d38:	728080e7          	jalr	1832(ra) # 8020045c <printf>
    80201d3c:	0001                	nop
    80201d3e:	70a2                	ld	ra,40(sp)
    80201d40:	7402                	ld	s0,32(sp)
    80201d42:	6145                	addi	sp,sp,48
    80201d44:	8082                	ret

0000000080201d46 <assert>:
#include "pm.h"
#include "memlayout.h"
#include "types.h"
    80201d46:	1101                	addi	sp,sp,-32
    80201d48:	ec06                	sd	ra,24(sp)
    80201d4a:	e822                	sd	s0,16(sp)
    80201d4c:	1000                	addi	s0,sp,32
    80201d4e:	87aa                	mv	a5,a0
    80201d50:	fef42623          	sw	a5,-20(s0)
#include "printf.h"
    80201d54:	fec42783          	lw	a5,-20(s0)
    80201d58:	2781                	sext.w	a5,a5
    80201d5a:	e795                	bnez	a5,80201d86 <assert+0x40>
#include "mem.h"
    80201d5c:	4615                	li	a2,5
    80201d5e:	00002597          	auipc	a1,0x2
    80201d62:	ff258593          	addi	a1,a1,-14 # 80203d50 <small_numbers+0xc30>
    80201d66:	00002517          	auipc	a0,0x2
    80201d6a:	ffa50513          	addi	a0,a0,-6 # 80203d60 <small_numbers+0xc40>
    80201d6e:	ffffe097          	auipc	ra,0xffffe
    80201d72:	6ee080e7          	jalr	1774(ra) # 8020045c <printf>
#include "assert.h"
    80201d76:	00002517          	auipc	a0,0x2
    80201d7a:	01250513          	addi	a0,a0,18 # 80203d88 <small_numbers+0xc68>
    80201d7e:	fffff097          	auipc	ra,0xfffff
    80201d82:	fe6080e7          	jalr	-26(ra) # 80200d64 <panic>

struct run {
    80201d86:	0001                	nop
    80201d88:	60e2                	ld	ra,24(sp)
    80201d8a:	6442                	ld	s0,16(sp)
    80201d8c:	6105                	addi	sp,sp,32
    80201d8e:	8082                	ret

0000000080201d90 <freerange>:

static struct run *freelist = 0;

extern char end[];

static void freerange(void *pa_start, void *pa_end) {
    80201d90:	7179                	addi	sp,sp,-48
    80201d92:	f406                	sd	ra,40(sp)
    80201d94:	f022                	sd	s0,32(sp)
    80201d96:	1800                	addi	s0,sp,48
    80201d98:	fca43c23          	sd	a0,-40(s0)
    80201d9c:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    80201da0:	fd843703          	ld	a4,-40(s0)
    80201da4:	6785                	lui	a5,0x1
    80201da6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80201da8:	973e                	add	a4,a4,a5
    80201daa:	77fd                	lui	a5,0xfffff
    80201dac:	8ff9                	and	a5,a5,a4
    80201dae:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80201db2:	a829                	j	80201dcc <freerange+0x3c>
    free_page(p);
    80201db4:	fe843503          	ld	a0,-24(s0)
    80201db8:	00000097          	auipc	ra,0x0
    80201dbc:	0c4080e7          	jalr	196(ra) # 80201e7c <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80201dc0:	fe843703          	ld	a4,-24(s0)
    80201dc4:	6785                	lui	a5,0x1
    80201dc6:	97ba                	add	a5,a5,a4
    80201dc8:	fef43423          	sd	a5,-24(s0)
    80201dcc:	fe843703          	ld	a4,-24(s0)
    80201dd0:	6785                	lui	a5,0x1
    80201dd2:	97ba                	add	a5,a5,a4
    80201dd4:	fd043703          	ld	a4,-48(s0)
    80201dd8:	fcf77ee3          	bgeu	a4,a5,80201db4 <freerange+0x24>
  }
}
    80201ddc:	0001                	nop
    80201dde:	0001                	nop
    80201de0:	70a2                	ld	ra,40(sp)
    80201de2:	7402                	ld	s0,32(sp)
    80201de4:	6145                	addi	sp,sp,48
    80201de6:	8082                	ret

0000000080201de8 <pmm_init>:

void pmm_init(void) {
    80201de8:	1141                	addi	sp,sp,-16
    80201dea:	e406                	sd	ra,8(sp)
    80201dec:	e022                	sd	s0,0(sp)
    80201dee:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    80201df0:	47c5                	li	a5,17
    80201df2:	01b79593          	slli	a1,a5,0x1b
    80201df6:	00004517          	auipc	a0,0x4
    80201dfa:	4ca50513          	addi	a0,a0,1226 # 802062c0 <_bss_end>
    80201dfe:	00000097          	auipc	ra,0x0
    80201e02:	f92080e7          	jalr	-110(ra) # 80201d90 <freerange>
}
    80201e06:	0001                	nop
    80201e08:	60a2                	ld	ra,8(sp)
    80201e0a:	6402                	ld	s0,0(sp)
    80201e0c:	0141                	addi	sp,sp,16
    80201e0e:	8082                	ret

0000000080201e10 <alloc_page>:

void* alloc_page(void) {
    80201e10:	1101                	addi	sp,sp,-32
    80201e12:	ec06                	sd	ra,24(sp)
    80201e14:	e822                	sd	s0,16(sp)
    80201e16:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80201e18:	00004797          	auipc	a5,0x4
    80201e1c:	2a078793          	addi	a5,a5,672 # 802060b8 <freelist>
    80201e20:	639c                	ld	a5,0(a5)
    80201e22:	fef43423          	sd	a5,-24(s0)
  if(r)
    80201e26:	fe843783          	ld	a5,-24(s0)
    80201e2a:	cb89                	beqz	a5,80201e3c <alloc_page+0x2c>
    freelist = r->next;
    80201e2c:	fe843783          	ld	a5,-24(s0)
    80201e30:	6398                	ld	a4,0(a5)
    80201e32:	00004797          	auipc	a5,0x4
    80201e36:	28678793          	addi	a5,a5,646 # 802060b8 <freelist>
    80201e3a:	e398                	sd	a4,0(a5)
  if(r)
    80201e3c:	fe843783          	ld	a5,-24(s0)
    80201e40:	cf99                	beqz	a5,80201e5e <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    80201e42:	fe843783          	ld	a5,-24(s0)
    80201e46:	00878713          	addi	a4,a5,8
    80201e4a:	6785                	lui	a5,0x1
    80201e4c:	ff878613          	addi	a2,a5,-8 # ff8 <_entry-0x801ff008>
    80201e50:	4595                	li	a1,5
    80201e52:	853a                	mv	a0,a4
    80201e54:	fffff097          	auipc	ra,0xfffff
    80201e58:	5e0080e7          	jalr	1504(ra) # 80201434 <memset>
    80201e5c:	a809                	j	80201e6e <alloc_page+0x5e>
  else
    panic("alloc_page: out of memory");
    80201e5e:	00002517          	auipc	a0,0x2
    80201e62:	f3250513          	addi	a0,a0,-206 # 80203d90 <small_numbers+0xc70>
    80201e66:	fffff097          	auipc	ra,0xfffff
    80201e6a:	efe080e7          	jalr	-258(ra) # 80200d64 <panic>
  return (void*)r;
    80201e6e:	fe843783          	ld	a5,-24(s0)
}
    80201e72:	853e                	mv	a0,a5
    80201e74:	60e2                	ld	ra,24(sp)
    80201e76:	6442                	ld	s0,16(sp)
    80201e78:	6105                	addi	sp,sp,32
    80201e7a:	8082                	ret

0000000080201e7c <free_page>:

void free_page(void* page) {
    80201e7c:	7179                	addi	sp,sp,-48
    80201e7e:	f406                	sd	ra,40(sp)
    80201e80:	f022                	sd	s0,32(sp)
    80201e82:	1800                	addi	s0,sp,48
    80201e84:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    80201e88:	fd843783          	ld	a5,-40(s0)
    80201e8c:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    80201e90:	fd843703          	ld	a4,-40(s0)
    80201e94:	6785                	lui	a5,0x1
    80201e96:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80201e98:	8ff9                	and	a5,a5,a4
    80201e9a:	ef99                	bnez	a5,80201eb8 <free_page+0x3c>
    80201e9c:	fd843703          	ld	a4,-40(s0)
    80201ea0:	00004797          	auipc	a5,0x4
    80201ea4:	42078793          	addi	a5,a5,1056 # 802062c0 <_bss_end>
    80201ea8:	00f76863          	bltu	a4,a5,80201eb8 <free_page+0x3c>
    80201eac:	fd843703          	ld	a4,-40(s0)
    80201eb0:	47c5                	li	a5,17
    80201eb2:	07ee                	slli	a5,a5,0x1b
    80201eb4:	00f76a63          	bltu	a4,a5,80201ec8 <free_page+0x4c>
    panic("free_page: invalid page address");
    80201eb8:	00002517          	auipc	a0,0x2
    80201ebc:	ef850513          	addi	a0,a0,-264 # 80203db0 <small_numbers+0xc90>
    80201ec0:	fffff097          	auipc	ra,0xfffff
    80201ec4:	ea4080e7          	jalr	-348(ra) # 80200d64 <panic>
  r->next = freelist;
    80201ec8:	00004797          	auipc	a5,0x4
    80201ecc:	1f078793          	addi	a5,a5,496 # 802060b8 <freelist>
    80201ed0:	6398                	ld	a4,0(a5)
    80201ed2:	fe843783          	ld	a5,-24(s0)
    80201ed6:	e398                	sd	a4,0(a5)
  freelist = r;
    80201ed8:	00004797          	auipc	a5,0x4
    80201edc:	1e078793          	addi	a5,a5,480 # 802060b8 <freelist>
    80201ee0:	fe843703          	ld	a4,-24(s0)
    80201ee4:	e398                	sd	a4,0(a5)
}
    80201ee6:	0001                	nop
    80201ee8:	70a2                	ld	ra,40(sp)
    80201eea:	7402                	ld	s0,32(sp)
    80201eec:	6145                	addi	sp,sp,48
    80201eee:	8082                	ret

0000000080201ef0 <test_physical_memory>:

void test_physical_memory(void) {
    80201ef0:	7179                	addi	sp,sp,-48
    80201ef2:	f406                	sd	ra,40(sp)
    80201ef4:	f022                	sd	s0,32(sp)
    80201ef6:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    80201ef8:	00002517          	auipc	a0,0x2
    80201efc:	ed850513          	addi	a0,a0,-296 # 80203dd0 <small_numbers+0xcb0>
    80201f00:	ffffe097          	auipc	ra,0xffffe
    80201f04:	55c080e7          	jalr	1372(ra) # 8020045c <printf>
    void *page1 = alloc_page();
    80201f08:	00000097          	auipc	ra,0x0
    80201f0c:	f08080e7          	jalr	-248(ra) # 80201e10 <alloc_page>
    80201f10:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    80201f14:	00000097          	auipc	ra,0x0
    80201f18:	efc080e7          	jalr	-260(ra) # 80201e10 <alloc_page>
    80201f1c:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    80201f20:	fe843783          	ld	a5,-24(s0)
    80201f24:	00f037b3          	snez	a5,a5
    80201f28:	0ff7f793          	zext.b	a5,a5
    80201f2c:	2781                	sext.w	a5,a5
    80201f2e:	853e                	mv	a0,a5
    80201f30:	00000097          	auipc	ra,0x0
    80201f34:	e16080e7          	jalr	-490(ra) # 80201d46 <assert>
    assert(page2 != 0);
    80201f38:	fe043783          	ld	a5,-32(s0)
    80201f3c:	00f037b3          	snez	a5,a5
    80201f40:	0ff7f793          	zext.b	a5,a5
    80201f44:	2781                	sext.w	a5,a5
    80201f46:	853e                	mv	a0,a5
    80201f48:	00000097          	auipc	ra,0x0
    80201f4c:	dfe080e7          	jalr	-514(ra) # 80201d46 <assert>
    assert(page1 != page2);
    80201f50:	fe843703          	ld	a4,-24(s0)
    80201f54:	fe043783          	ld	a5,-32(s0)
    80201f58:	40f707b3          	sub	a5,a4,a5
    80201f5c:	00f037b3          	snez	a5,a5
    80201f60:	0ff7f793          	zext.b	a5,a5
    80201f64:	2781                	sext.w	a5,a5
    80201f66:	853e                	mv	a0,a5
    80201f68:	00000097          	auipc	ra,0x0
    80201f6c:	dde080e7          	jalr	-546(ra) # 80201d46 <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    80201f70:	fe843703          	ld	a4,-24(s0)
    80201f74:	6785                	lui	a5,0x1
    80201f76:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80201f78:	8ff9                	and	a5,a5,a4
    80201f7a:	0017b793          	seqz	a5,a5
    80201f7e:	0ff7f793          	zext.b	a5,a5
    80201f82:	2781                	sext.w	a5,a5
    80201f84:	853e                	mv	a0,a5
    80201f86:	00000097          	auipc	ra,0x0
    80201f8a:	dc0080e7          	jalr	-576(ra) # 80201d46 <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    80201f8e:	fe043703          	ld	a4,-32(s0)
    80201f92:	6785                	lui	a5,0x1
    80201f94:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80201f96:	8ff9                	and	a5,a5,a4
    80201f98:	0017b793          	seqz	a5,a5
    80201f9c:	0ff7f793          	zext.b	a5,a5
    80201fa0:	2781                	sext.w	a5,a5
    80201fa2:	853e                	mv	a0,a5
    80201fa4:	00000097          	auipc	ra,0x0
    80201fa8:	da2080e7          	jalr	-606(ra) # 80201d46 <assert>
    printf("[PM TEST] 分配测试通过\n");
    80201fac:	00002517          	auipc	a0,0x2
    80201fb0:	e4450513          	addi	a0,a0,-444 # 80203df0 <small_numbers+0xcd0>
    80201fb4:	ffffe097          	auipc	ra,0xffffe
    80201fb8:	4a8080e7          	jalr	1192(ra) # 8020045c <printf>

    printf("[PM TEST] 数据写入测试...\n");
    80201fbc:	00002517          	auipc	a0,0x2
    80201fc0:	e5450513          	addi	a0,a0,-428 # 80203e10 <small_numbers+0xcf0>
    80201fc4:	ffffe097          	auipc	ra,0xffffe
    80201fc8:	498080e7          	jalr	1176(ra) # 8020045c <printf>
    *(int*)page1 = 0x12345678;
    80201fcc:	fe843783          	ld	a5,-24(s0)
    80201fd0:	12345737          	lui	a4,0x12345
    80201fd4:	67870713          	addi	a4,a4,1656 # 12345678 <_entry-0x6deba988>
    80201fd8:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    80201fda:	fe843783          	ld	a5,-24(s0)
    80201fde:	439c                	lw	a5,0(a5)
    80201fe0:	873e                	mv	a4,a5
    80201fe2:	123457b7          	lui	a5,0x12345
    80201fe6:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6deba988>
    80201fea:	40f707b3          	sub	a5,a4,a5
    80201fee:	0017b793          	seqz	a5,a5
    80201ff2:	0ff7f793          	zext.b	a5,a5
    80201ff6:	2781                	sext.w	a5,a5
    80201ff8:	853e                	mv	a0,a5
    80201ffa:	00000097          	auipc	ra,0x0
    80201ffe:	d4c080e7          	jalr	-692(ra) # 80201d46 <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    80202002:	00002517          	auipc	a0,0x2
    80202006:	e3650513          	addi	a0,a0,-458 # 80203e38 <small_numbers+0xd18>
    8020200a:	ffffe097          	auipc	ra,0xffffe
    8020200e:	452080e7          	jalr	1106(ra) # 8020045c <printf>

    printf("[PM TEST] 释放与重新分配测试...\n");
    80202012:	00002517          	auipc	a0,0x2
    80202016:	e4e50513          	addi	a0,a0,-434 # 80203e60 <small_numbers+0xd40>
    8020201a:	ffffe097          	auipc	ra,0xffffe
    8020201e:	442080e7          	jalr	1090(ra) # 8020045c <printf>
    free_page(page1);
    80202022:	fe843503          	ld	a0,-24(s0)
    80202026:	00000097          	auipc	ra,0x0
    8020202a:	e56080e7          	jalr	-426(ra) # 80201e7c <free_page>
    void *page3 = alloc_page();
    8020202e:	00000097          	auipc	ra,0x0
    80202032:	de2080e7          	jalr	-542(ra) # 80201e10 <alloc_page>
    80202036:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    8020203a:	fd843783          	ld	a5,-40(s0)
    8020203e:	00f037b3          	snez	a5,a5
    80202042:	0ff7f793          	zext.b	a5,a5
    80202046:	2781                	sext.w	a5,a5
    80202048:	853e                	mv	a0,a5
    8020204a:	00000097          	auipc	ra,0x0
    8020204e:	cfc080e7          	jalr	-772(ra) # 80201d46 <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    80202052:	00002517          	auipc	a0,0x2
    80202056:	e3e50513          	addi	a0,a0,-450 # 80203e90 <small_numbers+0xd70>
    8020205a:	ffffe097          	auipc	ra,0xffffe
    8020205e:	402080e7          	jalr	1026(ra) # 8020045c <printf>

    free_page(page2);
    80202062:	fe043503          	ld	a0,-32(s0)
    80202066:	00000097          	auipc	ra,0x0
    8020206a:	e16080e7          	jalr	-490(ra) # 80201e7c <free_page>
    free_page(page3);
    8020206e:	fd843503          	ld	a0,-40(s0)
    80202072:	00000097          	auipc	ra,0x0
    80202076:	e0a080e7          	jalr	-502(ra) # 80201e7c <free_page>

    printf("[PM TEST] 所有物理内存管理测试通过\n");
    8020207a:	00002517          	auipc	a0,0x2
    8020207e:	e4650513          	addi	a0,a0,-442 # 80203ec0 <small_numbers+0xda0>
    80202082:	ffffe097          	auipc	ra,0xffffe
    80202086:	3da080e7          	jalr	986(ra) # 8020045c <printf>
    8020208a:	0001                	nop
    8020208c:	70a2                	ld	ra,40(sp)
    8020208e:	7402                	ld	s0,32(sp)
    80202090:	6145                	addi	sp,sp,48
    80202092:	8082                	ret

0000000080202094 <sbi_set_time>:
#include "printf.h"

// SBI ecall 编号
#define SBI_SET_TIME 0x0

void sbi_set_time(uint64 time) {
    80202094:	1101                	addi	sp,sp,-32
    80202096:	ec22                	sd	s0,24(sp)
    80202098:	1000                	addi	s0,sp,32
    8020209a:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    8020209e:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    802020a2:	4881                	li	a7,0
    asm volatile ("ecall"
    802020a4:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    802020a8:	0001                	nop
    802020aa:	6462                	ld	s0,24(sp)
    802020ac:	6105                	addi	sp,sp,32
    802020ae:	8082                	ret

00000000802020b0 <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    802020b0:	1101                	addi	sp,sp,-32
    802020b2:	ec22                	sd	s0,24(sp)
    802020b4:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    802020b6:	c01027f3          	rdtime	a5
    802020ba:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    802020be:	fe843783          	ld	a5,-24(s0)
    802020c2:	853e                	mv	a0,a5
    802020c4:	6462                	ld	s0,24(sp)
    802020c6:	6105                	addi	sp,sp,32
    802020c8:	8082                	ret

00000000802020ca <timeintr>:
#include "trap.h"
#include "riscv.h"  // 确保包含了这个头文件

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    802020ca:	1141                	addi	sp,sp,-16
    802020cc:	e422                	sd	s0,8(sp)
    802020ce:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    802020d0:	00004797          	auipc	a5,0x4
    802020d4:	f5878793          	addi	a5,a5,-168 # 80206028 <interrupt_test_flag>
    802020d8:	639c                	ld	a5,0(a5)
    802020da:	cb99                	beqz	a5,802020f0 <timeintr+0x26>
        (*interrupt_test_flag)++;
    802020dc:	00004797          	auipc	a5,0x4
    802020e0:	f4c78793          	addi	a5,a5,-180 # 80206028 <interrupt_test_flag>
    802020e4:	639c                	ld	a5,0(a5)
    802020e6:	4398                	lw	a4,0(a5)
    802020e8:	2701                	sext.w	a4,a4
    802020ea:	2705                	addiw	a4,a4,1
    802020ec:	2701                	sext.w	a4,a4
    802020ee:	c398                	sw	a4,0(a5)
    802020f0:	0001                	nop
    802020f2:	6422                	ld	s0,8(sp)
    802020f4:	0141                	addi	sp,sp,16
    802020f6:	8082                	ret

00000000802020f8 <r_sie>:
#include "plic.h"
#include "memlayout.h"
#include "timer.h"
#include "riscv.h"
#include "printf.h"
#include "sbi.h"
    802020f8:	1101                	addi	sp,sp,-32
    802020fa:	ec22                	sd	s0,24(sp)
    802020fc:	1000                	addi	s0,sp,32

// 全局测试变量，用于中断测试
    802020fe:	104027f3          	csrr	a5,sie
    80202102:	fef43423          	sd	a5,-24(s0)
volatile int *interrupt_test_flag = 0;
    80202106:	fe843783          	ld	a5,-24(s0)
extern void kernelvec();
    8020210a:	853e                	mv	a0,a5
    8020210c:	6462                	ld	s0,24(sp)
    8020210e:	6105                	addi	sp,sp,32
    80202110:	8082                	ret

0000000080202112 <w_sie>:
interrupt_handler_t interrupt_vector[MAX_IRQ];
void register_interrupt(int irq, interrupt_handler_t h) {
    80202112:	1101                	addi	sp,sp,-32
    80202114:	ec22                	sd	s0,24(sp)
    80202116:	1000                	addi	s0,sp,32
    80202118:	fea43423          	sd	a0,-24(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    8020211c:	fe843783          	ld	a5,-24(s0)
    80202120:	10479073          	csrw	sie,a5
        interrupt_vector[irq] = h;
    80202124:	0001                	nop
    80202126:	6462                	ld	s0,24(sp)
    80202128:	6105                	addi	sp,sp,32
    8020212a:	8082                	ret

000000008020212c <r_sstatus>:
	}
}
    8020212c:	1101                	addi	sp,sp,-32
    8020212e:	ec22                	sd	s0,24(sp)
    80202130:	1000                	addi	s0,sp,32

void unregister_interrupt(int irq) {
    80202132:	100027f3          	csrr	a5,sstatus
    80202136:	fef43423          	sd	a5,-24(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    8020213a:	fe843783          	ld	a5,-24(s0)
        interrupt_vector[irq] = 0;
    8020213e:	853e                	mv	a0,a5
    80202140:	6462                	ld	s0,24(sp)
    80202142:	6105                	addi	sp,sp,32
    80202144:	8082                	ret

0000000080202146 <w_sstatus>:
}
    80202146:	1101                	addi	sp,sp,-32
    80202148:	ec22                	sd	s0,24(sp)
    8020214a:	1000                	addi	s0,sp,32
    8020214c:	fea43423          	sd	a0,-24(s0)
void enable_interrupts(int irq) {
    80202150:	fe843783          	ld	a5,-24(s0)
    80202154:	10079073          	csrw	sstatus,a5
    plic_enable(irq);
    80202158:	0001                	nop
    8020215a:	6462                	ld	s0,24(sp)
    8020215c:	6105                	addi	sp,sp,32
    8020215e:	8082                	ret

0000000080202160 <w_sepc>:
}

void disable_interrupts(int irq) {
    80202160:	1101                	addi	sp,sp,-32
    80202162:	ec22                	sd	s0,24(sp)
    80202164:	1000                	addi	s0,sp,32
    80202166:	fea43423          	sd	a0,-24(s0)
    plic_disable(irq);
    8020216a:	fe843783          	ld	a5,-24(s0)
    8020216e:	14179073          	csrw	sepc,a5
}
    80202172:	0001                	nop
    80202174:	6462                	ld	s0,24(sp)
    80202176:	6105                	addi	sp,sp,32
    80202178:	8082                	ret

000000008020217a <intr_off>:

void interrupt_dispatch(int irq) {
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
		interrupt_vector[irq]();
	}
}
    8020217a:	1141                	addi	sp,sp,-16
    8020217c:	e406                	sd	ra,8(sp)
    8020217e:	e022                	sd	s0,0(sp)
    80202180:	0800                	addi	s0,sp,16

    80202182:	00000097          	auipc	ra,0x0
    80202186:	faa080e7          	jalr	-86(ra) # 8020212c <r_sstatus>
    8020218a:	87aa                	mv	a5,a0
    8020218c:	9bf5                	andi	a5,a5,-3
    8020218e:	853e                	mv	a0,a5
    80202190:	00000097          	auipc	ra,0x0
    80202194:	fb6080e7          	jalr	-74(ra) # 80202146 <w_sstatus>
void trap_init(void) {
    80202198:	0001                	nop
    8020219a:	60a2                	ld	ra,8(sp)
    8020219c:	6402                	ld	s0,0(sp)
    8020219e:	0141                	addi	sp,sp,16
    802021a0:	8082                	ret

00000000802021a2 <w_stvec>:
	intr_off();
	printf("trap_init...\n");
	w_stvec((uint64)kernelvec);
    802021a2:	1101                	addi	sp,sp,-32
    802021a4:	ec22                	sd	s0,24(sp)
    802021a6:	1000                	addi	s0,sp,32
    802021a8:	fea43423          	sd	a0,-24(s0)
    uint64 sie = r_sie();
    802021ac:	fe843783          	ld	a5,-24(s0)
    802021b0:	10579073          	csrw	stvec,a5
    w_sie(sie | (1L << 5)); // 设置SIE.STIE位启用时钟中断
    802021b4:	0001                	nop
    802021b6:	6462                	ld	s0,24(sp)
    802021b8:	6105                	addi	sp,sp,32
    802021ba:	8082                	ret

00000000802021bc <r_scause>:
}
// 修改中断处理函数，支持测试标志
void kerneltrap(void) {
    // 保存当前中断状态
    uint64 sstatus = r_sstatus();
    uint64 scause = r_scause();
    802021bc:	1101                	addi	sp,sp,-32
    802021be:	ec22                	sd	s0,24(sp)
    802021c0:	1000                	addi	s0,sp,32
    uint64 sepc = r_sepc();
    
    802021c2:	142027f3          	csrr	a5,scause
    802021c6:	fef43423          	sd	a5,-24(s0)
    // 检查是否为时钟中断
    802021ca:	fe843783          	ld	a5,-24(s0)
    if((scause & 0x8000000000000000) && ((scause & 0xff) == 5)) {
    802021ce:	853e                	mv	a0,a5
    802021d0:	6462                	ld	s0,24(sp)
    802021d2:	6105                	addi	sp,sp,32
    802021d4:	8082                	ret

00000000802021d6 <r_sepc>:
        // 调用时钟中断处理函数
        timeintr();
    802021d6:	1101                	addi	sp,sp,-32
    802021d8:	ec22                	sd	s0,24(sp)
    802021da:	1000                	addi	s0,sp,32
        // 设置下一次时钟中断 - 使用较短间隔用于测试
        sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802021dc:	141027f3          	csrr	a5,sepc
    802021e0:	fef43423          	sd	a5,-24(s0)
    } else {
    802021e4:	fe843783          	ld	a5,-24(s0)
        printf("kerneltrap: unexpected scause=%lx sepc=%lx\n", scause, sepc);
    802021e8:	853e                	mv	a0,a5
    802021ea:	6462                	ld	s0,24(sp)
    802021ec:	6105                	addi	sp,sp,32
    802021ee:	8082                	ret

00000000802021f0 <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    802021f0:	1101                	addi	sp,sp,-32
    802021f2:	ec22                	sd	s0,24(sp)
    802021f4:	1000                	addi	s0,sp,32
    802021f6:	87aa                	mv	a5,a0
    802021f8:	feb43023          	sd	a1,-32(s0)
    802021fc:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    80202200:	fec42783          	lw	a5,-20(s0)
    80202204:	2781                	sext.w	a5,a5
    80202206:	0207c563          	bltz	a5,80202230 <register_interrupt+0x40>
    8020220a:	fec42783          	lw	a5,-20(s0)
    8020220e:	0007871b          	sext.w	a4,a5
    80202212:	03f00793          	li	a5,63
    80202216:	00e7cd63          	blt	a5,a4,80202230 <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    8020221a:	00004717          	auipc	a4,0x4
    8020221e:	ea670713          	addi	a4,a4,-346 # 802060c0 <interrupt_vector>
    80202222:	fec42783          	lw	a5,-20(s0)
    80202226:	078e                	slli	a5,a5,0x3
    80202228:	97ba                	add	a5,a5,a4
    8020222a:	fe043703          	ld	a4,-32(s0)
    8020222e:	e398                	sd	a4,0(a5)
}
    80202230:	0001                	nop
    80202232:	6462                	ld	s0,24(sp)
    80202234:	6105                	addi	sp,sp,32
    80202236:	8082                	ret

0000000080202238 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    80202238:	1101                	addi	sp,sp,-32
    8020223a:	ec22                	sd	s0,24(sp)
    8020223c:	1000                	addi	s0,sp,32
    8020223e:	87aa                	mv	a5,a0
    80202240:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    80202244:	fec42783          	lw	a5,-20(s0)
    80202248:	2781                	sext.w	a5,a5
    8020224a:	0207c463          	bltz	a5,80202272 <unregister_interrupt+0x3a>
    8020224e:	fec42783          	lw	a5,-20(s0)
    80202252:	0007871b          	sext.w	a4,a5
    80202256:	03f00793          	li	a5,63
    8020225a:	00e7cc63          	blt	a5,a4,80202272 <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    8020225e:	00004717          	auipc	a4,0x4
    80202262:	e6270713          	addi	a4,a4,-414 # 802060c0 <interrupt_vector>
    80202266:	fec42783          	lw	a5,-20(s0)
    8020226a:	078e                	slli	a5,a5,0x3
    8020226c:	97ba                	add	a5,a5,a4
    8020226e:	0007b023          	sd	zero,0(a5)
}
    80202272:	0001                	nop
    80202274:	6462                	ld	s0,24(sp)
    80202276:	6105                	addi	sp,sp,32
    80202278:	8082                	ret

000000008020227a <enable_interrupts>:
void enable_interrupts(int irq) {
    8020227a:	1101                	addi	sp,sp,-32
    8020227c:	ec06                	sd	ra,24(sp)
    8020227e:	e822                	sd	s0,16(sp)
    80202280:	1000                	addi	s0,sp,32
    80202282:	87aa                	mv	a5,a0
    80202284:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    80202288:	fec42783          	lw	a5,-20(s0)
    8020228c:	853e                	mv	a0,a5
    8020228e:	00000097          	auipc	ra,0x0
    80202292:	458080e7          	jalr	1112(ra) # 802026e6 <plic_enable>
}
    80202296:	0001                	nop
    80202298:	60e2                	ld	ra,24(sp)
    8020229a:	6442                	ld	s0,16(sp)
    8020229c:	6105                	addi	sp,sp,32
    8020229e:	8082                	ret

00000000802022a0 <disable_interrupts>:
void disable_interrupts(int irq) {
    802022a0:	1101                	addi	sp,sp,-32
    802022a2:	ec06                	sd	ra,24(sp)
    802022a4:	e822                	sd	s0,16(sp)
    802022a6:	1000                	addi	s0,sp,32
    802022a8:	87aa                	mv	a5,a0
    802022aa:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    802022ae:	fec42783          	lw	a5,-20(s0)
    802022b2:	853e                	mv	a0,a5
    802022b4:	00000097          	auipc	ra,0x0
    802022b8:	4aa080e7          	jalr	1194(ra) # 8020275e <plic_disable>
}
    802022bc:	0001                	nop
    802022be:	60e2                	ld	ra,24(sp)
    802022c0:	6442                	ld	s0,16(sp)
    802022c2:	6105                	addi	sp,sp,32
    802022c4:	8082                	ret

00000000802022c6 <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    802022c6:	1101                	addi	sp,sp,-32
    802022c8:	ec06                	sd	ra,24(sp)
    802022ca:	e822                	sd	s0,16(sp)
    802022cc:	1000                	addi	s0,sp,32
    802022ce:	87aa                	mv	a5,a0
    802022d0:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    802022d4:	fec42783          	lw	a5,-20(s0)
    802022d8:	2781                	sext.w	a5,a5
    802022da:	0207ce63          	bltz	a5,80202316 <interrupt_dispatch+0x50>
    802022de:	fec42783          	lw	a5,-20(s0)
    802022e2:	0007871b          	sext.w	a4,a5
    802022e6:	03f00793          	li	a5,63
    802022ea:	02e7c663          	blt	a5,a4,80202316 <interrupt_dispatch+0x50>
    802022ee:	00004717          	auipc	a4,0x4
    802022f2:	dd270713          	addi	a4,a4,-558 # 802060c0 <interrupt_vector>
    802022f6:	fec42783          	lw	a5,-20(s0)
    802022fa:	078e                	slli	a5,a5,0x3
    802022fc:	97ba                	add	a5,a5,a4
    802022fe:	639c                	ld	a5,0(a5)
    80202300:	cb99                	beqz	a5,80202316 <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    80202302:	00004717          	auipc	a4,0x4
    80202306:	dbe70713          	addi	a4,a4,-578 # 802060c0 <interrupt_vector>
    8020230a:	fec42783          	lw	a5,-20(s0)
    8020230e:	078e                	slli	a5,a5,0x3
    80202310:	97ba                	add	a5,a5,a4
    80202312:	639c                	ld	a5,0(a5)
    80202314:	9782                	jalr	a5
}
    80202316:	0001                	nop
    80202318:	60e2                	ld	ra,24(sp)
    8020231a:	6442                	ld	s0,16(sp)
    8020231c:	6105                	addi	sp,sp,32
    8020231e:	8082                	ret

0000000080202320 <trap_init>:
void trap_init(void) {
    80202320:	1101                	addi	sp,sp,-32
    80202322:	ec06                	sd	ra,24(sp)
    80202324:	e822                	sd	s0,16(sp)
    80202326:	1000                	addi	s0,sp,32
	intr_off();
    80202328:	00000097          	auipc	ra,0x0
    8020232c:	e52080e7          	jalr	-430(ra) # 8020217a <intr_off>
	printf("trap_init...\n");
    80202330:	00002517          	auipc	a0,0x2
    80202334:	bc050513          	addi	a0,a0,-1088 # 80203ef0 <small_numbers+0xdd0>
    80202338:	ffffe097          	auipc	ra,0xffffe
    8020233c:	124080e7          	jalr	292(ra) # 8020045c <printf>
	w_stvec((uint64)kernelvec);
    80202340:	00000797          	auipc	a5,0x0
    80202344:	54078793          	addi	a5,a5,1344 # 80202880 <kernelvec>
    80202348:	853e                	mv	a0,a5
    8020234a:	00000097          	auipc	ra,0x0
    8020234e:	e58080e7          	jalr	-424(ra) # 802021a2 <w_stvec>
    uint64 sie = r_sie();
    80202352:	00000097          	auipc	ra,0x0
    80202356:	da6080e7          	jalr	-602(ra) # 802020f8 <r_sie>
    8020235a:	fea43423          	sd	a0,-24(s0)
    w_sie(sie | (1L << 5)); // 设置SIE.STIE位启用时钟中断
    8020235e:	fe843783          	ld	a5,-24(s0)
    80202362:	0207e793          	ori	a5,a5,32
    80202366:	853e                	mv	a0,a5
    80202368:	00000097          	auipc	ra,0x0
    8020236c:	daa080e7          	jalr	-598(ra) # 80202112 <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80202370:	00000097          	auipc	ra,0x0
    80202374:	d40080e7          	jalr	-704(ra) # 802020b0 <sbi_get_time>
    80202378:	872a                	mv	a4,a0
    8020237a:	000f47b7          	lui	a5,0xf4
    8020237e:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    80202382:	97ba                	add	a5,a5,a4
    80202384:	853e                	mv	a0,a5
    80202386:	00000097          	auipc	ra,0x0
    8020238a:	d0e080e7          	jalr	-754(ra) # 80202094 <sbi_set_time>
	printf("trap_init complete.\n");
    8020238e:	00002517          	auipc	a0,0x2
    80202392:	b7250513          	addi	a0,a0,-1166 # 80203f00 <small_numbers+0xde0>
    80202396:	ffffe097          	auipc	ra,0xffffe
    8020239a:	0c6080e7          	jalr	198(ra) # 8020045c <printf>
}
    8020239e:	0001                	nop
    802023a0:	60e2                	ld	ra,24(sp)
    802023a2:	6442                	ld	s0,16(sp)
    802023a4:	6105                	addi	sp,sp,32
    802023a6:	8082                	ret

00000000802023a8 <kerneltrap>:
void kerneltrap(void) {
    802023a8:	7179                	addi	sp,sp,-48
    802023aa:	f406                	sd	ra,40(sp)
    802023ac:	f022                	sd	s0,32(sp)
    802023ae:	1800                	addi	s0,sp,48
    uint64 sstatus = r_sstatus();
    802023b0:	00000097          	auipc	ra,0x0
    802023b4:	d7c080e7          	jalr	-644(ra) # 8020212c <r_sstatus>
    802023b8:	fea43423          	sd	a0,-24(s0)
    uint64 scause = r_scause();
    802023bc:	00000097          	auipc	ra,0x0
    802023c0:	e00080e7          	jalr	-512(ra) # 802021bc <r_scause>
    802023c4:	fea43023          	sd	a0,-32(s0)
    uint64 sepc = r_sepc();
    802023c8:	00000097          	auipc	ra,0x0
    802023cc:	e0e080e7          	jalr	-498(ra) # 802021d6 <r_sepc>
    802023d0:	fca43c23          	sd	a0,-40(s0)
    if((scause & 0x8000000000000000) && ((scause & 0xff) == 5)) {
    802023d4:	fe043783          	ld	a5,-32(s0)
    802023d8:	0207dd63          	bgez	a5,80202412 <kerneltrap+0x6a>
    802023dc:	fe043783          	ld	a5,-32(s0)
    802023e0:	0ff7f713          	zext.b	a4,a5
    802023e4:	4795                	li	a5,5
    802023e6:	02f71663          	bne	a4,a5,80202412 <kerneltrap+0x6a>
        timeintr();
    802023ea:	00000097          	auipc	ra,0x0
    802023ee:	ce0080e7          	jalr	-800(ra) # 802020ca <timeintr>
        sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802023f2:	00000097          	auipc	ra,0x0
    802023f6:	cbe080e7          	jalr	-834(ra) # 802020b0 <sbi_get_time>
    802023fa:	872a                	mv	a4,a0
    802023fc:	000f47b7          	lui	a5,0xf4
    80202400:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    80202404:	97ba                	add	a5,a5,a4
    80202406:	853e                	mv	a0,a5
    80202408:	00000097          	auipc	ra,0x0
    8020240c:	c8c080e7          	jalr	-884(ra) # 80202094 <sbi_set_time>
    80202410:	a839                	j	8020242e <kerneltrap+0x86>
        printf("kerneltrap: unexpected scause=%lx sepc=%lx\n", scause, sepc);
    80202412:	fd843603          	ld	a2,-40(s0)
    80202416:	fe043583          	ld	a1,-32(s0)
    8020241a:	00002517          	auipc	a0,0x2
    8020241e:	afe50513          	addi	a0,a0,-1282 # 80203f18 <small_numbers+0xdf8>
    80202422:	ffffe097          	auipc	ra,0xffffe
    80202426:	03a080e7          	jalr	58(ra) # 8020045c <printf>
        while(1); // 出现问题时挂起系统
    8020242a:	0001                	nop
    8020242c:	bffd                	j	8020242a <kerneltrap+0x82>
    }
    
    // 恢复中断现场
    w_sepc(sepc);
    8020242e:	fd843503          	ld	a0,-40(s0)
    80202432:	00000097          	auipc	ra,0x0
    80202436:	d2e080e7          	jalr	-722(ra) # 80202160 <w_sepc>
    w_sstatus(sstatus);
    8020243a:	fe843503          	ld	a0,-24(s0)
    8020243e:	00000097          	auipc	ra,0x0
    80202442:	d08080e7          	jalr	-760(ra) # 80202146 <w_sstatus>
}
    80202446:	0001                	nop
    80202448:	70a2                	ld	ra,40(sp)
    8020244a:	7402                	ld	s0,32(sp)
    8020244c:	6145                	addi	sp,sp,48
    8020244e:	8082                	ret

0000000080202450 <get_time>:
// 获取当前时间的辅助函数
uint64 get_time(void) {
    80202450:	1141                	addi	sp,sp,-16
    80202452:	e406                	sd	ra,8(sp)
    80202454:	e022                	sd	s0,0(sp)
    80202456:	0800                	addi	s0,sp,16
    return sbi_get_time();
    80202458:	00000097          	auipc	ra,0x0
    8020245c:	c58080e7          	jalr	-936(ra) # 802020b0 <sbi_get_time>
    80202460:	87aa                	mv	a5,a0
}
    80202462:	853e                	mv	a0,a5
    80202464:	60a2                	ld	ra,8(sp)
    80202466:	6402                	ld	s0,0(sp)
    80202468:	0141                	addi	sp,sp,16
    8020246a:	8082                	ret

000000008020246c <test_timer_interrupt>:

// 时钟中断测试函数
void test_timer_interrupt(void) {
    8020246c:	7179                	addi	sp,sp,-48
    8020246e:	f406                	sd	ra,40(sp)
    80202470:	f022                	sd	s0,32(sp)
    80202472:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    80202474:	00002517          	auipc	a0,0x2
    80202478:	ad450513          	addi	a0,a0,-1324 # 80203f48 <small_numbers+0xe28>
    8020247c:	ffffe097          	auipc	ra,0xffffe
    80202480:	fe0080e7          	jalr	-32(ra) # 8020045c <printf>

    // 记录中断前的时间
    uint64 start_time = get_time();
    80202484:	00000097          	auipc	ra,0x0
    80202488:	fcc080e7          	jalr	-52(ra) # 80202450 <get_time>
    8020248c:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    80202490:	fc042a23          	sw	zero,-44(s0)
	int last_count = interrupt_count;
    80202494:	fd442783          	lw	a5,-44(s0)
    80202498:	fef42623          	sw	a5,-20(s0)
    // 设置测试标志
    interrupt_test_flag = &interrupt_count;
    8020249c:	00004797          	auipc	a5,0x4
    802024a0:	b8c78793          	addi	a5,a5,-1140 # 80206028 <interrupt_test_flag>
    802024a4:	fd440713          	addi	a4,s0,-44
    802024a8:	e398                	sd	a4,0(a5)

    // 等待几次中断
    while (interrupt_count < 5) {
    802024aa:	a899                	j	80202500 <test_timer_interrupt+0x94>
        if(last_count != interrupt_count) {
    802024ac:	fd442703          	lw	a4,-44(s0)
    802024b0:	fec42783          	lw	a5,-20(s0)
    802024b4:	2781                	sext.w	a5,a5
    802024b6:	02e78163          	beq	a5,a4,802024d8 <test_timer_interrupt+0x6c>
			last_count = interrupt_count;
    802024ba:	fd442783          	lw	a5,-44(s0)
    802024be:	fef42623          	sw	a5,-20(s0)
			printf("Received interrupt %d\n", interrupt_count);
    802024c2:	fd442783          	lw	a5,-44(s0)
    802024c6:	85be                	mv	a1,a5
    802024c8:	00002517          	auipc	a0,0x2
    802024cc:	aa050513          	addi	a0,a0,-1376 # 80203f68 <small_numbers+0xe48>
    802024d0:	ffffe097          	auipc	ra,0xffffe
    802024d4:	f8c080e7          	jalr	-116(ra) # 8020045c <printf>
		}
        // 简单延时
        for (volatile int i = 0; i < 1000000; i++);
    802024d8:	fc042823          	sw	zero,-48(s0)
    802024dc:	a801                	j	802024ec <test_timer_interrupt+0x80>
    802024de:	fd042783          	lw	a5,-48(s0)
    802024e2:	2781                	sext.w	a5,a5
    802024e4:	2785                	addiw	a5,a5,1
    802024e6:	2781                	sext.w	a5,a5
    802024e8:	fcf42823          	sw	a5,-48(s0)
    802024ec:	fd042783          	lw	a5,-48(s0)
    802024f0:	2781                	sext.w	a5,a5
    802024f2:	873e                	mv	a4,a5
    802024f4:	000f47b7          	lui	a5,0xf4
    802024f8:	23f78793          	addi	a5,a5,575 # f423f <_entry-0x8010bdc1>
    802024fc:	fee7d1e3          	bge	a5,a4,802024de <test_timer_interrupt+0x72>
    while (interrupt_count < 5) {
    80202500:	fd442783          	lw	a5,-44(s0)
    80202504:	873e                	mv	a4,a5
    80202506:	4791                	li	a5,4
    80202508:	fae7d2e3          	bge	a5,a4,802024ac <test_timer_interrupt+0x40>
    }

    // 测试结束，清除标志
    interrupt_test_flag = 0;
    8020250c:	00004797          	auipc	a5,0x4
    80202510:	b1c78793          	addi	a5,a5,-1252 # 80206028 <interrupt_test_flag>
    80202514:	0007b023          	sd	zero,0(a5)

    uint64 end_time = get_time();
    80202518:	00000097          	auipc	ra,0x0
    8020251c:	f38080e7          	jalr	-200(ra) # 80202450 <get_time>
    80202520:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    80202524:	fd442683          	lw	a3,-44(s0)
    80202528:	fd843703          	ld	a4,-40(s0)
    8020252c:	fe043783          	ld	a5,-32(s0)
    80202530:	40f707b3          	sub	a5,a4,a5
    80202534:	863e                	mv	a2,a5
    80202536:	85b6                	mv	a1,a3
    80202538:	00002517          	auipc	a0,0x2
    8020253c:	a4850513          	addi	a0,a0,-1464 # 80203f80 <small_numbers+0xe60>
    80202540:	ffffe097          	auipc	ra,0xffffe
    80202544:	f1c080e7          	jalr	-228(ra) # 8020045c <printf>
           interrupt_count, end_time - start_time);
    80202548:	0001                	nop
    8020254a:	70a2                	ld	ra,40(sp)
    8020254c:	7402                	ld	s0,32(sp)
    8020254e:	6145                	addi	sp,sp,48
    80202550:	8082                	ret

0000000080202552 <r_tp>:
void plicinit(void) {
    // 使用明确的内存访问模式
    for (int i = 1; i <= 32; i++) {
        uint64 addr = PLIC + i * 4;
        write32(addr, 0);
    }
    80202552:	1101                	addi	sp,sp,-32
    80202554:	ec22                	sd	s0,24(sp)
    80202556:	1000                	addi	s0,sp,32
    
    // 设置 UART 和 VIRTIO 优先级
    80202558:	8792                	mv	a5,tp
    8020255a:	fef43423          	sd	a5,-24(s0)
    write32(PLIC + UART0_IRQ * 4, 1);
    8020255e:	fe843783          	ld	a5,-24(s0)
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    80202562:	853e                	mv	a0,a5
    80202564:	6462                	ld	s0,24(sp)
    80202566:	6105                	addi	sp,sp,32
    80202568:	8082                	ret

000000008020256a <write32>:
    uint64 senable_addr = PLIC_SENABLE(hart);
    uint64 spriority_addr = PLIC_SPRIORITY(hart);
    
    write32(senable_addr, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    write32(spriority_addr, 0);
}
    8020256a:	7179                	addi	sp,sp,-48
    8020256c:	f406                	sd	ra,40(sp)
    8020256e:	f022                	sd	s0,32(sp)
    80202570:	1800                	addi	s0,sp,48
    80202572:	fca43c23          	sd	a0,-40(s0)
    80202576:	87ae                	mv	a5,a1
    80202578:	fcf42a23          	sw	a5,-44(s0)

void plic_enable(int irq) {
    8020257c:	fd843783          	ld	a5,-40(s0)
    80202580:	8b8d                	andi	a5,a5,3
    80202582:	eb99                	bnez	a5,80202598 <write32+0x2e>
    int hart = r_tp();
    uint64 addr = PLIC_SENABLE(hart);
    80202584:	fd843783          	ld	a5,-40(s0)
    80202588:	fef43423          	sd	a5,-24(s0)
    
    8020258c:	fe843783          	ld	a5,-24(s0)
    80202590:	fd442703          	lw	a4,-44(s0)
    80202594:	c398                	sw	a4,0(a5)
    uint32 old = read32(addr);
    write32(addr, old | (1 << irq));
}

void plic_disable(int irq) {
    80202596:	a819                	j	802025ac <write32+0x42>
    write32(addr, old | (1 << irq));
    80202598:	fd843583          	ld	a1,-40(s0)
    8020259c:	00002517          	auipc	a0,0x2
    802025a0:	a1c50513          	addi	a0,a0,-1508 # 80203fb8 <small_numbers+0xe98>
    802025a4:	ffffe097          	auipc	ra,0xffffe
    802025a8:	eb8080e7          	jalr	-328(ra) # 8020045c <printf>
void plic_disable(int irq) {
    802025ac:	0001                	nop
    802025ae:	70a2                	ld	ra,40(sp)
    802025b0:	7402                	ld	s0,32(sp)
    802025b2:	6145                	addi	sp,sp,48
    802025b4:	8082                	ret

00000000802025b6 <read32>:
    int hart = r_tp();
    uint64 addr = PLIC_SENABLE(hart);
    802025b6:	7179                	addi	sp,sp,-48
    802025b8:	f406                	sd	ra,40(sp)
    802025ba:	f022                	sd	s0,32(sp)
    802025bc:	1800                	addi	s0,sp,48
    802025be:	fca43c23          	sd	a0,-40(s0)
    
    uint32 old = read32(addr);
    802025c2:	fd843783          	ld	a5,-40(s0)
    802025c6:	8b8d                	andi	a5,a5,3
    802025c8:	eb91                	bnez	a5,802025dc <read32+0x26>
    write32(addr, old & ~(1 << irq));
}
    802025ca:	fd843783          	ld	a5,-40(s0)
    802025ce:	fef43423          	sd	a5,-24(s0)

    802025d2:	fe843783          	ld	a5,-24(s0)
    802025d6:	439c                	lw	a5,0(a5)
    802025d8:	2781                	sext.w	a5,a5
    802025da:	a821                	j	802025f2 <read32+0x3c>
int plic_claim(void) {
    int hart = r_tp();
    802025dc:	fd843583          	ld	a1,-40(s0)
    802025e0:	00002517          	auipc	a0,0x2
    802025e4:	a0850513          	addi	a0,a0,-1528 # 80203fe8 <small_numbers+0xec8>
    802025e8:	ffffe097          	auipc	ra,0xffffe
    802025ec:	e74080e7          	jalr	-396(ra) # 8020045c <printf>
    uint64 addr = PLIC_SCLAIM(hart);
    802025f0:	4781                	li	a5,0
    return read32(addr);
}
    802025f2:	853e                	mv	a0,a5
    802025f4:	70a2                	ld	ra,40(sp)
    802025f6:	7402                	ld	s0,32(sp)
    802025f8:	6145                	addi	sp,sp,48
    802025fa:	8082                	ret

00000000802025fc <plicinit>:
void plicinit(void) {
    802025fc:	1101                	addi	sp,sp,-32
    802025fe:	ec06                	sd	ra,24(sp)
    80202600:	e822                	sd	s0,16(sp)
    80202602:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80202604:	4785                	li	a5,1
    80202606:	fef42623          	sw	a5,-20(s0)
    8020260a:	a805                	j	8020263a <plicinit+0x3e>
        uint64 addr = PLIC + i * 4;
    8020260c:	fec42783          	lw	a5,-20(s0)
    80202610:	0027979b          	slliw	a5,a5,0x2
    80202614:	2781                	sext.w	a5,a5
    80202616:	873e                	mv	a4,a5
    80202618:	0c0007b7          	lui	a5,0xc000
    8020261c:	97ba                	add	a5,a5,a4
    8020261e:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80202622:	4581                	li	a1,0
    80202624:	fe043503          	ld	a0,-32(s0)
    80202628:	00000097          	auipc	ra,0x0
    8020262c:	f42080e7          	jalr	-190(ra) # 8020256a <write32>
    for (int i = 1; i <= 32; i++) {
    80202630:	fec42783          	lw	a5,-20(s0)
    80202634:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    80202636:	fef42623          	sw	a5,-20(s0)
    8020263a:	fec42783          	lw	a5,-20(s0)
    8020263e:	0007871b          	sext.w	a4,a5
    80202642:	02000793          	li	a5,32
    80202646:	fce7d3e3          	bge	a5,a4,8020260c <plicinit+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    8020264a:	4585                	li	a1,1
    8020264c:	0c0007b7          	lui	a5,0xc000
    80202650:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    80202654:	00000097          	auipc	ra,0x0
    80202658:	f16080e7          	jalr	-234(ra) # 8020256a <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    8020265c:	4585                	li	a1,1
    8020265e:	0c0007b7          	lui	a5,0xc000
    80202662:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    80202666:	00000097          	auipc	ra,0x0
    8020266a:	f04080e7          	jalr	-252(ra) # 8020256a <write32>
}
    8020266e:	0001                	nop
    80202670:	60e2                	ld	ra,24(sp)
    80202672:	6442                	ld	s0,16(sp)
    80202674:	6105                	addi	sp,sp,32
    80202676:	8082                	ret

0000000080202678 <plicinithart>:
void plicinithart(void) {
    80202678:	7179                	addi	sp,sp,-48
    8020267a:	f406                	sd	ra,40(sp)
    8020267c:	f022                	sd	s0,32(sp)
    8020267e:	1800                	addi	s0,sp,48
    int hart = r_tp();
    80202680:	00000097          	auipc	ra,0x0
    80202684:	ed2080e7          	jalr	-302(ra) # 80202552 <r_tp>
    80202688:	87aa                	mv	a5,a0
    8020268a:	fef42623          	sw	a5,-20(s0)
    uint64 senable_addr = PLIC_SENABLE(hart);
    8020268e:	fec42783          	lw	a5,-20(s0)
    80202692:	0087979b          	slliw	a5,a5,0x8
    80202696:	2781                	sext.w	a5,a5
    80202698:	873e                	mv	a4,a5
    8020269a:	0c0027b7          	lui	a5,0xc002
    8020269e:	08078793          	addi	a5,a5,128 # c002080 <_entry-0x741fdf80>
    802026a2:	97ba                	add	a5,a5,a4
    802026a4:	fef43023          	sd	a5,-32(s0)
    uint64 spriority_addr = PLIC_SPRIORITY(hart);
    802026a8:	fec42783          	lw	a5,-20(s0)
    802026ac:	00d7979b          	slliw	a5,a5,0xd
    802026b0:	2781                	sext.w	a5,a5
    802026b2:	873e                	mv	a4,a5
    802026b4:	0c2017b7          	lui	a5,0xc201
    802026b8:	97ba                	add	a5,a5,a4
    802026ba:	fcf43c23          	sd	a5,-40(s0)
    write32(senable_addr, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    802026be:	40200593          	li	a1,1026
    802026c2:	fe043503          	ld	a0,-32(s0)
    802026c6:	00000097          	auipc	ra,0x0
    802026ca:	ea4080e7          	jalr	-348(ra) # 8020256a <write32>
    write32(spriority_addr, 0);
    802026ce:	4581                	li	a1,0
    802026d0:	fd843503          	ld	a0,-40(s0)
    802026d4:	00000097          	auipc	ra,0x0
    802026d8:	e96080e7          	jalr	-362(ra) # 8020256a <write32>
}
    802026dc:	0001                	nop
    802026de:	70a2                	ld	ra,40(sp)
    802026e0:	7402                	ld	s0,32(sp)
    802026e2:	6145                	addi	sp,sp,48
    802026e4:	8082                	ret

00000000802026e6 <plic_enable>:
void plic_enable(int irq) {
    802026e6:	7139                	addi	sp,sp,-64
    802026e8:	fc06                	sd	ra,56(sp)
    802026ea:	f822                	sd	s0,48(sp)
    802026ec:	0080                	addi	s0,sp,64
    802026ee:	87aa                	mv	a5,a0
    802026f0:	fcf42623          	sw	a5,-52(s0)
    int hart = r_tp();
    802026f4:	00000097          	auipc	ra,0x0
    802026f8:	e5e080e7          	jalr	-418(ra) # 80202552 <r_tp>
    802026fc:	87aa                	mv	a5,a0
    802026fe:	fef42623          	sw	a5,-20(s0)
    uint64 addr = PLIC_SENABLE(hart);
    80202702:	fec42783          	lw	a5,-20(s0)
    80202706:	0087979b          	slliw	a5,a5,0x8
    8020270a:	2781                	sext.w	a5,a5
    8020270c:	873e                	mv	a4,a5
    8020270e:	0c0027b7          	lui	a5,0xc002
    80202712:	08078793          	addi	a5,a5,128 # c002080 <_entry-0x741fdf80>
    80202716:	97ba                	add	a5,a5,a4
    80202718:	fef43023          	sd	a5,-32(s0)
    uint32 old = read32(addr);
    8020271c:	fe043503          	ld	a0,-32(s0)
    80202720:	00000097          	auipc	ra,0x0
    80202724:	e96080e7          	jalr	-362(ra) # 802025b6 <read32>
    80202728:	87aa                	mv	a5,a0
    8020272a:	fcf42e23          	sw	a5,-36(s0)
    write32(addr, old | (1 << irq));
    8020272e:	fcc42783          	lw	a5,-52(s0)
    80202732:	873e                	mv	a4,a5
    80202734:	4785                	li	a5,1
    80202736:	00e797bb          	sllw	a5,a5,a4
    8020273a:	2781                	sext.w	a5,a5
    8020273c:	2781                	sext.w	a5,a5
    8020273e:	fdc42703          	lw	a4,-36(s0)
    80202742:	8fd9                	or	a5,a5,a4
    80202744:	2781                	sext.w	a5,a5
    80202746:	85be                	mv	a1,a5
    80202748:	fe043503          	ld	a0,-32(s0)
    8020274c:	00000097          	auipc	ra,0x0
    80202750:	e1e080e7          	jalr	-482(ra) # 8020256a <write32>
}
    80202754:	0001                	nop
    80202756:	70e2                	ld	ra,56(sp)
    80202758:	7442                	ld	s0,48(sp)
    8020275a:	6121                	addi	sp,sp,64
    8020275c:	8082                	ret

000000008020275e <plic_disable>:
void plic_disable(int irq) {
    8020275e:	7139                	addi	sp,sp,-64
    80202760:	fc06                	sd	ra,56(sp)
    80202762:	f822                	sd	s0,48(sp)
    80202764:	0080                	addi	s0,sp,64
    80202766:	87aa                	mv	a5,a0
    80202768:	fcf42623          	sw	a5,-52(s0)
    int hart = r_tp();
    8020276c:	00000097          	auipc	ra,0x0
    80202770:	de6080e7          	jalr	-538(ra) # 80202552 <r_tp>
    80202774:	87aa                	mv	a5,a0
    80202776:	fef42623          	sw	a5,-20(s0)
    uint64 addr = PLIC_SENABLE(hart);
    8020277a:	fec42783          	lw	a5,-20(s0)
    8020277e:	0087979b          	slliw	a5,a5,0x8
    80202782:	2781                	sext.w	a5,a5
    80202784:	873e                	mv	a4,a5
    80202786:	0c0027b7          	lui	a5,0xc002
    8020278a:	08078793          	addi	a5,a5,128 # c002080 <_entry-0x741fdf80>
    8020278e:	97ba                	add	a5,a5,a4
    80202790:	fef43023          	sd	a5,-32(s0)
    uint32 old = read32(addr);
    80202794:	fe043503          	ld	a0,-32(s0)
    80202798:	00000097          	auipc	ra,0x0
    8020279c:	e1e080e7          	jalr	-482(ra) # 802025b6 <read32>
    802027a0:	87aa                	mv	a5,a0
    802027a2:	fcf42e23          	sw	a5,-36(s0)
    write32(addr, old & ~(1 << irq));
    802027a6:	fcc42783          	lw	a5,-52(s0)
    802027aa:	873e                	mv	a4,a5
    802027ac:	4785                	li	a5,1
    802027ae:	00e797bb          	sllw	a5,a5,a4
    802027b2:	2781                	sext.w	a5,a5
    802027b4:	fff7c793          	not	a5,a5
    802027b8:	2781                	sext.w	a5,a5
    802027ba:	2781                	sext.w	a5,a5
    802027bc:	fdc42703          	lw	a4,-36(s0)
    802027c0:	8ff9                	and	a5,a5,a4
    802027c2:	2781                	sext.w	a5,a5
    802027c4:	85be                	mv	a1,a5
    802027c6:	fe043503          	ld	a0,-32(s0)
    802027ca:	00000097          	auipc	ra,0x0
    802027ce:	da0080e7          	jalr	-608(ra) # 8020256a <write32>
}
    802027d2:	0001                	nop
    802027d4:	70e2                	ld	ra,56(sp)
    802027d6:	7442                	ld	s0,48(sp)
    802027d8:	6121                	addi	sp,sp,64
    802027da:	8082                	ret

00000000802027dc <plic_claim>:
int plic_claim(void) {
    802027dc:	1101                	addi	sp,sp,-32
    802027de:	ec06                	sd	ra,24(sp)
    802027e0:	e822                	sd	s0,16(sp)
    802027e2:	1000                	addi	s0,sp,32
    int hart = r_tp();
    802027e4:	00000097          	auipc	ra,0x0
    802027e8:	d6e080e7          	jalr	-658(ra) # 80202552 <r_tp>
    802027ec:	87aa                	mv	a5,a0
    802027ee:	fef42623          	sw	a5,-20(s0)
    uint64 addr = PLIC_SCLAIM(hart);
    802027f2:	fec42783          	lw	a5,-20(s0)
    802027f6:	00d7979b          	slliw	a5,a5,0xd
    802027fa:	2781                	sext.w	a5,a5
    802027fc:	873e                	mv	a4,a5
    802027fe:	0c2017b7          	lui	a5,0xc201
    80202802:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73ffeffc>
    80202804:	97ba                	add	a5,a5,a4
    80202806:	fef43023          	sd	a5,-32(s0)
    return read32(addr);
    8020280a:	fe043503          	ld	a0,-32(s0)
    8020280e:	00000097          	auipc	ra,0x0
    80202812:	da8080e7          	jalr	-600(ra) # 802025b6 <read32>
    80202816:	87aa                	mv	a5,a0
    80202818:	2781                	sext.w	a5,a5
    8020281a:	2781                	sext.w	a5,a5
}
    8020281c:	853e                	mv	a0,a5
    8020281e:	60e2                	ld	ra,24(sp)
    80202820:	6442                	ld	s0,16(sp)
    80202822:	6105                	addi	sp,sp,32
    80202824:	8082                	ret

0000000080202826 <plic_complete>:

void plic_complete(int irq) {
    80202826:	7179                	addi	sp,sp,-48
    80202828:	f406                	sd	ra,40(sp)
    8020282a:	f022                	sd	s0,32(sp)
    8020282c:	1800                	addi	s0,sp,48
    8020282e:	87aa                	mv	a5,a0
    80202830:	fcf42e23          	sw	a5,-36(s0)
    int hart = r_tp();
    80202834:	00000097          	auipc	ra,0x0
    80202838:	d1e080e7          	jalr	-738(ra) # 80202552 <r_tp>
    8020283c:	87aa                	mv	a5,a0
    8020283e:	fef42623          	sw	a5,-20(s0)
    uint64 addr = PLIC_SCLAIM(hart);
    80202842:	fec42783          	lw	a5,-20(s0)
    80202846:	00d7979b          	slliw	a5,a5,0xd
    8020284a:	2781                	sext.w	a5,a5
    8020284c:	873e                	mv	a4,a5
    8020284e:	0c2017b7          	lui	a5,0xc201
    80202852:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73ffeffc>
    80202854:	97ba                	add	a5,a5,a4
    80202856:	fef43023          	sd	a5,-32(s0)
    write32(addr, irq);
    8020285a:	fdc42783          	lw	a5,-36(s0)
    8020285e:	85be                	mv	a1,a5
    80202860:	fe043503          	ld	a0,-32(s0)
    80202864:	00000097          	auipc	ra,0x0
    80202868:	d06080e7          	jalr	-762(ra) # 8020256a <write32>
    8020286c:	0001                	nop
    8020286e:	70a2                	ld	ra,40(sp)
    80202870:	7402                	ld	s0,32(sp)
    80202872:	6145                	addi	sp,sp,48
    80202874:	8082                	ret
	...

0000000080202880 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80202880:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80202882:	e006                	sd	ra,0(sp)
        # 注意：不保存sp，因为我们已经修改了它
        sd gp, 16(sp)
    80202884:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80202886:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80202888:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8020288a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8020288c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    8020288e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80202890:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80202892:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80202894:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80202896:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80202898:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    8020289a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    8020289c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8020289e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    802028a0:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    802028a2:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    802028a4:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    802028a6:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    802028a8:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    802028aa:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    802028ac:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    802028ae:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    802028b0:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    802028b2:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    802028b4:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    802028b6:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    802028b8:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    802028ba:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    802028bc:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    802028be:	00000097          	auipc	ra,0x0
    802028c2:	aea080e7          	jalr	-1302(ra) # 802023a8 <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    802028c6:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    802028c8:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    802028ca:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    802028cc:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    802028ce:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    802028d0:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    802028d2:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    802028d4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    802028d6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    802028d8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    802028da:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    802028dc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    802028de:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    802028e0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    802028e2:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    802028e4:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    802028e6:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    802028e8:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    802028ea:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    802028ec:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    802028ee:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    802028f0:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    802028f2:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    802028f4:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    802028f6:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    802028f8:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    802028fa:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    802028fc:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    802028fe:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80202900:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80202902:	10200073          	sret
    80202906:	0001                	nop
    80202908:	00000013          	nop
    8020290c:	00000013          	nop
	...
