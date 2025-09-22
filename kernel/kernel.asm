
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80000000:	00004117          	auipc	sp,0x4
    80000004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80000008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8000000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8000000c:	00005517          	auipc	a0,0x5
    80000010:	ff450513          	addi	a0,a0,-12 # 80005000 <global_test2>
        la a1,_bss_end
    80000014:	00005597          	auipc	a1,0x5
    80000018:	0bc58593          	addi	a1,a1,188 # 800050d0 <_bss_end>

000000008000001c <clear_bss>:
clear_bss:
        bgeu a0,a1,bss_done
    8000001c:	00b57663          	bgeu	a0,a1,80000028 <bss_done>
        sw zero,0(a0)
    80000020:	00052023          	sw	zero,0(a0)
        addi a0,a0,4
    80000024:	0511                	addi	a0,a0,4
        j clear_bss
    80000026:	bfdd                	j	8000001c <clear_bss>

0000000080000028 <bss_done>:
bss_done:
        call start # 跳转到start函数
    80000028:	00000097          	auipc	ra,0x0
    8000002c:	00a080e7          	jalr	10(ra) # 80000032 <start>

0000000080000030 <spin>:
spin:
        j spin # 无限循环，防止程序退出
    80000030:	a001                	j	80000030 <spin>

0000000080000032 <start>:
int global_test1;
int global_test2;
int buffer[10];
int initialized_global = 123;
// start函数：内核的C语言入口
void start(){
    80000032:	1141                	addi	sp,sp,-16 # 80003ff0 <initialized_global+0xff0>
    80000034:	e406                	sd	ra,8(sp)
    80000036:	e022                	sd	s0,0(sp)
    80000038:	0800                	addi	s0,sp,16
	// 初始化内核的重要组件
	// 内存页分配器
	pmm_init();
    8000003a:	00001097          	auipc	ra,0x1
    8000003e:	f18080e7          	jalr	-232(ra) # 80000f52 <pmm_init>
	// 虚拟内存
	printf("[VP TEST] 尝试启用分页模式\n");
    80000042:	00002517          	auipc	a0,0x2
    80000046:	fbe50513          	addi	a0,a0,-66 # 80002000 <test_physical_memory+0x1066>
    8000004a:	00000097          	auipc	ra,0x0
    8000004e:	2c4080e7          	jalr	708(ra) # 8000030e <printf>
	kvminit();
    80000052:	00001097          	auipc	ra,0x1
    80000056:	b1c080e7          	jalr	-1252(ra) # 80000b6e <kvminit>
    kvminithart();
    8000005a:	00001097          	auipc	ra,0x1
    8000005e:	bbe080e7          	jalr	-1090(ra) # 80000c18 <kvminithart>

    // 进入操作系统后立即清屏
    clear_screen();
    80000062:	00000097          	auipc	ra,0x0
    80000066:	4ce080e7          	jalr	1230(ra) # 80000530 <clear_screen>
    // 输出操作系统启动横幅
    uart_puts("===============================================\n");
    8000006a:	00002517          	auipc	a0,0x2
    8000006e:	fbe50513          	addi	a0,a0,-66 # 80002028 <test_physical_memory+0x108e>
    80000072:	00000097          	auipc	ra,0x0
    80000076:	0f6080e7          	jalr	246(ra) # 80000168 <uart_puts>
    uart_puts("        RISC-V Operating System v1.0         \n");
    8000007a:	00002517          	auipc	a0,0x2
    8000007e:	fe650513          	addi	a0,a0,-26 # 80002060 <test_physical_memory+0x10c6>
    80000082:	00000097          	auipc	ra,0x0
    80000086:	0e6080e7          	jalr	230(ra) # 80000168 <uart_puts>
    uart_puts("===============================================\n\n");
    8000008a:	00002517          	auipc	a0,0x2
    8000008e:	00650513          	addi	a0,a0,6 # 80002090 <test_physical_memory+0x10f6>
    80000092:	00000097          	auipc	ra,0x0
    80000096:	0d6080e7          	jalr	214(ra) # 80000168 <uart_puts>
    printf("[VP TEST] 当前已启用分页模式\n");
    8000009a:	00002517          	auipc	a0,0x2
    8000009e:	02e50513          	addi	a0,a0,46 # 800020c8 <test_physical_memory+0x112e>
    800000a2:	00000097          	auipc	ra,0x0
    800000a6:	26c080e7          	jalr	620(ra) # 8000030e <printf>
    // 验证BSS段是否被正确清零
    uart_puts("Testing BSS zero initialization:\n");
    800000aa:	00002517          	auipc	a0,0x2
    800000ae:	04650513          	addi	a0,a0,70 # 800020f0 <test_physical_memory+0x1156>
    800000b2:	00000097          	auipc	ra,0x0
    800000b6:	0b6080e7          	jalr	182(ra) # 80000168 <uart_puts>
    if (global_test1 == 0 && global_test2 == 0) {
    800000ba:	00005797          	auipc	a5,0x5
    800000be:	f4a7a783          	lw	a5,-182(a5) # 80005004 <global_test1>
    800000c2:	00005717          	auipc	a4,0x5
    800000c6:	f3e72703          	lw	a4,-194(a4) # 80005000 <global_test2>
    800000ca:	8fd9                	or	a5,a5,a4
    800000cc:	cbb1                	beqz	a5,80000120 <start+0xee>
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    } else {
        uart_puts("  [ERROR] BSS variables not zeroed!\n");
    800000ce:	00002517          	auipc	a0,0x2
    800000d2:	07250513          	addi	a0,a0,114 # 80002140 <test_physical_memory+0x11a6>
    800000d6:	00000097          	auipc	ra,0x0
    800000da:	092080e7          	jalr	146(ra) # 80000168 <uart_puts>
    }
    
    // 验证初始化变量
    if (initialized_global == 123) {
    800000de:	00003717          	auipc	a4,0x3
    800000e2:	f2272703          	lw	a4,-222(a4) # 80003000 <initialized_global>
    800000e6:	07b00793          	li	a5,123
    800000ea:	04f70463          	beq	a4,a5,80000132 <start+0x100>
        uart_puts("  [OK] Initialized variables working\n");
    } else {
        uart_puts("  [ERROR] Initialized variables corrupted!\n");
    800000ee:	00002517          	auipc	a0,0x2
    800000f2:	0a250513          	addi	a0,a0,162 # 80002190 <test_physical_memory+0x11f6>
    800000f6:	00000097          	auipc	ra,0x0
    800000fa:	072080e7          	jalr	114(ra) # 80000168 <uart_puts>
    }
    test_physical_memory();
    800000fe:	00001097          	auipc	ra,0x1
    80000102:	e9c080e7          	jalr	-356(ra) # 80000f9a <test_physical_memory>
	test_pagetable();
    80000106:	00001097          	auipc	ra,0x1
    8000010a:	b3a080e7          	jalr	-1222(ra) # 80000c40 <test_pagetable>
    uart_puts("\nSystem ready. Entering main loop...\n");
    8000010e:	00002517          	auipc	a0,0x2
    80000112:	0b250513          	addi	a0,a0,178 # 800021c0 <test_physical_memory+0x1226>
    80000116:	00000097          	auipc	ra,0x0
    8000011a:	052080e7          	jalr	82(ra) # 80000168 <uart_puts>
    
    // 主循环
    while(1) {
    8000011e:	a001                	j	8000011e <start+0xec>
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    80000120:	00002517          	auipc	a0,0x2
    80000124:	ff850513          	addi	a0,a0,-8 # 80002118 <test_physical_memory+0x117e>
    80000128:	00000097          	auipc	ra,0x0
    8000012c:	040080e7          	jalr	64(ra) # 80000168 <uart_puts>
    80000130:	b77d                	j	800000de <start+0xac>
        uart_puts("  [OK] Initialized variables working\n");
    80000132:	00002517          	auipc	a0,0x2
    80000136:	03650513          	addi	a0,a0,54 # 80002168 <test_physical_memory+0x11ce>
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	02e080e7          	jalr	46(ra) # 80000168 <uart_puts>
    80000142:	bf75                	j	800000fe <start+0xcc>

0000000080000144 <uart_putc>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))


void uart_putc(char c)
{
    80000144:	1141                	addi	sp,sp,-16
    80000146:	e422                	sd	s0,8(sp)
    80000148:	0800                	addi	s0,sp,16
  // 等待发送缓冲区空闲
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000014a:	10000737          	lui	a4,0x10000
    8000014e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000150:	00074783          	lbu	a5,0(a4)
    80000154:	0207f793          	andi	a5,a5,32
    80000158:	dfe5                	beqz	a5,80000150 <uart_putc+0xc>
    ;
  // 写入字符到发送寄存器
  WriteReg(THR, c);
    8000015a:	100007b7          	lui	a5,0x10000
    8000015e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    80000162:	6422                	ld	s0,8(sp)
    80000164:	0141                	addi	sp,sp,16
    80000166:	8082                	ret

0000000080000168 <uart_puts>:

// 成功后实现字符串输出
void uart_puts(char *s)
{
    80000168:	1141                	addi	sp,sp,-16
    8000016a:	e422                	sd	s0,8(sp)
    8000016c:	0800                	addi	s0,sp,16
    if (!s) return;
    8000016e:	cd15                	beqz	a0,800001aa <uart_puts+0x42>
    
    while (*s) {
    80000170:	00054783          	lbu	a5,0(a0)
    80000174:	cb9d                	beqz	a5,800001aa <uart_puts+0x42>
        // 批量检查：一次等待，发送多个字符
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000176:	10000737          	lui	a4,0x10000
    8000017a:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
            ;
            
        // 连续发送字符，直到缓冲区可能满或字符串结束
        int sent_count = 0;
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
            WriteReg(THR, *s);
    8000017c:	10000637          	lui	a2,0x10000
    80000180:	a011                	j	80000184 <uart_puts+0x1c>
    while (*s) {
    80000182:	c785                	beqz	a5,800001aa <uart_puts+0x42>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000184:	00074783          	lbu	a5,0(a4)
    80000188:	0207f793          	andi	a5,a5,32
    8000018c:	dfe5                	beqz	a5,80000184 <uart_puts+0x1c>
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    8000018e:	00054783          	lbu	a5,0(a0)
    80000192:	cf81                	beqz	a5,800001aa <uart_puts+0x42>
    80000194:	00450693          	addi	a3,a0,4
            WriteReg(THR, *s);
    80000198:	00f60023          	sb	a5,0(a2) # 10000000 <_entry-0x70000000>
            s++;
    8000019c:	0505                	addi	a0,a0,1
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    8000019e:	00054783          	lbu	a5,0(a0)
    800001a2:	c781                	beqz	a5,800001aa <uart_puts+0x42>
    800001a4:	fea69ae3          	bne	a3,a0,80000198 <uart_puts+0x30>
    800001a8:	bfe9                	j	80000182 <uart_puts+0x1a>
            sent_count++;
        }
    }
    800001aa:	6422                	ld	s0,8(sp)
    800001ac:	0141                	addi	sp,sp,16
    800001ae:	8082                	ret

00000000800001b0 <printint>:
static void consputs(const char *s){
	char *str = (char *)s;
	// 直接调用uart_puts输出字符串
	uart_puts(str);
}
static void printint(long long xx,int base,int sign){
    800001b0:	7139                	addi	sp,sp,-64
    800001b2:	fc06                	sd	ra,56(sp)
    800001b4:	f822                	sd	s0,48(sp)
    800001b6:	0080                	addi	s0,sp,64
	// 模仿xv6的printint
	static char digits[] = "0123456789abcdef";
	char buf[20]; // 增大缓冲区以处理64位整数
	int i;
	unsigned long long x;
	if (sign && (sign = xx < 0)) // 符号处理
    800001b8:	c219                	beqz	a2,800001be <printint+0xe>
    800001ba:	08054563          	bltz	a0,80000244 <printint+0x94>
		x = -(unsigned long long)xx; // 强制转换以避免溢出
	else
		x = xx;
    800001be:	4881                	li	a7,0

	if (base == 10 && x < 100) {
    800001c0:	47a9                	li	a5,10
    800001c2:	08f58563          	beq	a1,a5,8000024c <printint+0x9c>
		x = xx;
    800001c6:	fc840693          	addi	a3,s0,-56
    800001ca:	4781                	li	a5,0
		consputs(small_numbers[x]);
		return;
	}
	i = 0;
	do{
		buf[i] = digits[x % base];
    800001cc:	00002617          	auipc	a2,0x2
    800001d0:	3e460613          	addi	a2,a2,996 # 800025b0 <small_numbers>
    800001d4:	02b57733          	remu	a4,a0,a1
    800001d8:	9732                	add	a4,a4,a2
    800001da:	19074703          	lbu	a4,400(a4)
    800001de:	00e68023          	sb	a4,0(a3)
		i++;
    800001e2:	883e                	mv	a6,a5
    800001e4:	2785                	addiw	a5,a5,1
	}while((x/=base) !=0);
    800001e6:	872a                	mv	a4,a0
    800001e8:	02b55533          	divu	a0,a0,a1
    800001ec:	0685                	addi	a3,a3,1
    800001ee:	feb773e3          	bgeu	a4,a1,800001d4 <printint+0x24>
	if (sign){
    800001f2:	00088a63          	beqz	a7,80000206 <printint+0x56>
		buf[i] = '-';
    800001f6:	1781                	addi	a5,a5,-32
    800001f8:	97a2                	add	a5,a5,s0
    800001fa:	02d00713          	li	a4,45
    800001fe:	fee78423          	sb	a4,-24(a5)
		i++;
    80000202:	0028079b          	addiw	a5,a6,2
	}
	i--;
	while( i>=0){
    80000206:	02f05b63          	blez	a5,8000023c <printint+0x8c>
    8000020a:	f426                	sd	s1,40(sp)
    8000020c:	f04a                	sd	s2,32(sp)
    8000020e:	fc840713          	addi	a4,s0,-56
    80000212:	00f704b3          	add	s1,a4,a5
    80000216:	fff70913          	addi	s2,a4,-1
    8000021a:	993e                	add	s2,s2,a5
    8000021c:	37fd                	addiw	a5,a5,-1
    8000021e:	1782                	slli	a5,a5,0x20
    80000220:	9381                	srli	a5,a5,0x20
    80000222:	40f90933          	sub	s2,s2,a5
	uart_putc(c);
    80000226:	fff4c503          	lbu	a0,-1(s1)
    8000022a:	00000097          	auipc	ra,0x0
    8000022e:	f1a080e7          	jalr	-230(ra) # 80000144 <uart_putc>
	while( i>=0){
    80000232:	14fd                	addi	s1,s1,-1
    80000234:	ff2499e3          	bne	s1,s2,80000226 <printint+0x76>
    80000238:	74a2                	ld	s1,40(sp)
    8000023a:	7902                	ld	s2,32(sp)
		consputc(buf[i]);
		i--;
	}
}
    8000023c:	70e2                	ld	ra,56(sp)
    8000023e:	7442                	ld	s0,48(sp)
    80000240:	6121                	addi	sp,sp,64
    80000242:	8082                	ret
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    80000244:	40a00533          	neg	a0,a0
	if (sign && (sign = xx < 0)) // 符号处理
    80000248:	4885                	li	a7,1
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    8000024a:	bf9d                	j	800001c0 <printint+0x10>
	if (base == 10 && x < 100) {
    8000024c:	06300793          	li	a5,99
    80000250:	f6a7ebe3          	bltu	a5,a0,800001c6 <printint+0x16>
		consputs(small_numbers[x]);
    80000254:	050a                	slli	a0,a0,0x2
	uart_puts(str);
    80000256:	00002797          	auipc	a5,0x2
    8000025a:	35a78793          	addi	a5,a5,858 # 800025b0 <small_numbers>
    8000025e:	953e                	add	a0,a0,a5
    80000260:	00000097          	auipc	ra,0x0
    80000264:	f08080e7          	jalr	-248(ra) # 80000168 <uart_puts>
		return;
    80000268:	bfd1                	j	8000023c <printint+0x8c>

000000008000026a <flush_printf_buffer>:
	if (printf_buf_pos > 0) {
    8000026a:	00005797          	auipc	a5,0x5
    8000026e:	d9e7a783          	lw	a5,-610(a5) # 80005008 <printf_buf_pos>
    80000272:	00f04363          	bgtz	a5,80000278 <flush_printf_buffer+0xe>
    80000276:	8082                	ret
static void flush_printf_buffer(void) {
    80000278:	1141                	addi	sp,sp,-16
    8000027a:	e406                	sd	ra,8(sp)
    8000027c:	e022                	sd	s0,0(sp)
    8000027e:	0800                	addi	s0,sp,16
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80000280:	00005517          	auipc	a0,0x5
    80000284:	dc850513          	addi	a0,a0,-568 # 80005048 <printf_buffer>
    80000288:	97aa                	add	a5,a5,a0
    8000028a:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    8000028e:	00000097          	auipc	ra,0x0
    80000292:	eda080e7          	jalr	-294(ra) # 80000168 <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80000296:	00005797          	auipc	a5,0x5
    8000029a:	d607a923          	sw	zero,-654(a5) # 80005008 <printf_buf_pos>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret

00000000800002a6 <buffer_char>:
static void buffer_char(char c) {
    800002a6:	1101                	addi	sp,sp,-32
    800002a8:	ec06                	sd	ra,24(sp)
    800002aa:	e822                	sd	s0,16(sp)
    800002ac:	e426                	sd	s1,8(sp)
    800002ae:	1000                	addi	s0,sp,32
    800002b0:	84aa                	mv	s1,a0
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    800002b2:	00005797          	auipc	a5,0x5
    800002b6:	d567a783          	lw	a5,-682(a5) # 80005008 <printf_buf_pos>
    800002ba:	07e00713          	li	a4,126
    800002be:	02f74463          	blt	a4,a5,800002e6 <buffer_char+0x40>
		printf_buffer[printf_buf_pos++] = c;
    800002c2:	0017871b          	addiw	a4,a5,1
    800002c6:	00005697          	auipc	a3,0x5
    800002ca:	d4e6a123          	sw	a4,-702(a3) # 80005008 <printf_buf_pos>
    800002ce:	00005717          	auipc	a4,0x5
    800002d2:	d7a70713          	addi	a4,a4,-646 # 80005048 <printf_buffer>
    800002d6:	97ba                	add	a5,a5,a4
    800002d8:	00a78023          	sb	a0,0(a5)
}
    800002dc:	60e2                	ld	ra,24(sp)
    800002de:	6442                	ld	s0,16(sp)
    800002e0:	64a2                	ld	s1,8(sp)
    800002e2:	6105                	addi	sp,sp,32
    800002e4:	8082                	ret
		flush_printf_buffer(); // Buffer full, flush it
    800002e6:	00000097          	auipc	ra,0x0
    800002ea:	f84080e7          	jalr	-124(ra) # 8000026a <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    800002ee:	00005797          	auipc	a5,0x5
    800002f2:	d1a78793          	addi	a5,a5,-742 # 80005008 <printf_buf_pos>
    800002f6:	4398                	lw	a4,0(a5)
    800002f8:	0017069b          	addiw	a3,a4,1
    800002fc:	c394                	sw	a3,0(a5)
    800002fe:	00005797          	auipc	a5,0x5
    80000302:	d4a78793          	addi	a5,a5,-694 # 80005048 <printf_buffer>
    80000306:	97ba                	add	a5,a5,a4
    80000308:	00978023          	sb	s1,0(a5)
}
    8000030c:	bfc1                	j	800002dc <buffer_char+0x36>

000000008000030e <printf>:
void printf(const char *fmt, ...) {
    8000030e:	7135                	addi	sp,sp,-160
    80000310:	ec86                	sd	ra,88(sp)
    80000312:	e8a2                	sd	s0,80(sp)
    80000314:	e0ca                	sd	s2,64(sp)
    80000316:	1080                	addi	s0,sp,96
    80000318:	892a                	mv	s2,a0
    8000031a:	e40c                	sd	a1,8(s0)
    8000031c:	e810                	sd	a2,16(s0)
    8000031e:	ec14                	sd	a3,24(s0)
    80000320:	f018                	sd	a4,32(s0)
    80000322:	f41c                	sd	a5,40(s0)
    80000324:	03043823          	sd	a6,48(s0)
    80000328:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    8000032c:	00840793          	addi	a5,s0,8
    80000330:	faf43c23          	sd	a5,-72(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000334:	00054503          	lbu	a0,0(a0)
    80000338:	1c050d63          	beqz	a0,80000512 <printf+0x204>
    8000033c:	e4a6                	sd	s1,72(sp)
    8000033e:	fc4e                	sd	s3,56(sp)
    80000340:	f852                	sd	s4,48(sp)
    80000342:	f456                	sd	s5,40(sp)
    80000344:	f05a                	sd	s6,32(sp)
    80000346:	0005079b          	sext.w	a5,a0
    8000034a:	4481                	li	s1,0
        if(c != '%'){
    8000034c:	02500993          	li	s3,37
        }
		flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
        c = fmt[++i] & 0xff;
        if(c == 0)
            break;
        switch(c){
    80000350:	4a59                	li	s4,22
    80000352:	00002a97          	auipc	s5,0x2
    80000356:	1fea8a93          	addi	s5,s5,510 # 80002550 <test_physical_memory+0x15b6>
    8000035a:	a831                	j	80000376 <printf+0x68>
            buffer_char(c);
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	f4a080e7          	jalr	-182(ra) # 800002a6 <buffer_char>
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000364:	2485                	addiw	s1,s1,1
    80000366:	009907b3          	add	a5,s2,s1
    8000036a:	0007c503          	lbu	a0,0(a5)
    8000036e:	0005079b          	sext.w	a5,a0
    80000372:	18050b63          	beqz	a0,80000508 <printf+0x1fa>
        if(c != '%'){
    80000376:	ff3793e3          	bne	a5,s3,8000035c <printf+0x4e>
		flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    8000037a:	00000097          	auipc	ra,0x0
    8000037e:	ef0080e7          	jalr	-272(ra) # 8000026a <flush_printf_buffer>
        c = fmt[++i] & 0xff;
    80000382:	2485                	addiw	s1,s1,1
    80000384:	009907b3          	add	a5,s2,s1
    80000388:	0007cb03          	lbu	s6,0(a5)
        if(c == 0)
    8000038c:	180b0c63          	beqz	s6,80000524 <printf+0x216>
        switch(c){
    80000390:	153b0963          	beq	s6,s3,800004e2 <printf+0x1d4>
    80000394:	f9eb079b          	addiw	a5,s6,-98
    80000398:	0ff7f793          	zext.b	a5,a5
    8000039c:	14fa6a63          	bltu	s4,a5,800004f0 <printf+0x1e2>
    800003a0:	f9eb079b          	addiw	a5,s6,-98
    800003a4:	0ff7f713          	zext.b	a4,a5
    800003a8:	14ea6463          	bltu	s4,a4,800004f0 <printf+0x1e2>
    800003ac:	00271793          	slli	a5,a4,0x2
    800003b0:	97d6                	add	a5,a5,s5
    800003b2:	439c                	lw	a5,0(a5)
    800003b4:	97d6                	add	a5,a5,s5
    800003b6:	8782                	jr	a5
        case 'd':
            printint(va_arg(ap, int), 10, 1);
    800003b8:	fb843783          	ld	a5,-72(s0)
    800003bc:	00878713          	addi	a4,a5,8
    800003c0:	fae43c23          	sd	a4,-72(s0)
    800003c4:	4605                	li	a2,1
    800003c6:	45a9                	li	a1,10
    800003c8:	4388                	lw	a0,0(a5)
    800003ca:	00000097          	auipc	ra,0x0
    800003ce:	de6080e7          	jalr	-538(ra) # 800001b0 <printint>
            break;
    800003d2:	bf49                	j	80000364 <printf+0x56>
        case 'x':
            printint(va_arg(ap, int), 16, 0);
    800003d4:	fb843783          	ld	a5,-72(s0)
    800003d8:	00878713          	addi	a4,a5,8
    800003dc:	fae43c23          	sd	a4,-72(s0)
    800003e0:	4601                	li	a2,0
    800003e2:	45c1                	li	a1,16
    800003e4:	4388                	lw	a0,0(a5)
    800003e6:	00000097          	auipc	ra,0x0
    800003ea:	dca080e7          	jalr	-566(ra) # 800001b0 <printint>
            break;
    800003ee:	bf9d                	j	80000364 <printf+0x56>
        case 'u':
            printint(va_arg(ap, unsigned int), 10, 0);
    800003f0:	fb843783          	ld	a5,-72(s0)
    800003f4:	00878713          	addi	a4,a5,8
    800003f8:	fae43c23          	sd	a4,-72(s0)
    800003fc:	4601                	li	a2,0
    800003fe:	45a9                	li	a1,10
    80000400:	0007e503          	lwu	a0,0(a5)
    80000404:	00000097          	auipc	ra,0x0
    80000408:	dac080e7          	jalr	-596(ra) # 800001b0 <printint>
            break;
    8000040c:	bfa1                	j	80000364 <printf+0x56>
        case 'c':
            consputc(va_arg(ap, int));
    8000040e:	fb843783          	ld	a5,-72(s0)
    80000412:	00878713          	addi	a4,a5,8
    80000416:	fae43c23          	sd	a4,-72(s0)
	uart_putc(c);
    8000041a:	0007c503          	lbu	a0,0(a5)
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	d26080e7          	jalr	-730(ra) # 80000144 <uart_putc>
}
    80000426:	bf3d                	j	80000364 <printf+0x56>
            break;
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80000428:	fb843783          	ld	a5,-72(s0)
    8000042c:	00878713          	addi	a4,a5,8
    80000430:	fae43c23          	sd	a4,-72(s0)
    80000434:	6388                	ld	a0,0(a5)
    80000436:	c511                	beqz	a0,80000442 <printf+0x134>
	uart_puts(str);
    80000438:	00000097          	auipc	ra,0x0
    8000043c:	d30080e7          	jalr	-720(ra) # 80000168 <uart_puts>
}
    80000440:	b715                	j	80000364 <printf+0x56>
                s = "(null)";
    80000442:	00002517          	auipc	a0,0x2
    80000446:	da650513          	addi	a0,a0,-602 # 800021e8 <test_physical_memory+0x124e>
    8000044a:	b7fd                	j	80000438 <printf+0x12a>
            consputs(s);
            break;
		case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    8000044c:	fb843783          	ld	a5,-72(s0)
    80000450:	00878713          	addi	a4,a5,8
    80000454:	fae43c23          	sd	a4,-72(s0)
    80000458:	0007bb03          	ld	s6,0(a5)
	uart_puts(str);
    8000045c:	00002517          	auipc	a0,0x2
    80000460:	d9450513          	addi	a0,a0,-620 # 800021f0 <test_physical_memory+0x1256>
    80000464:	00000097          	auipc	ra,0x0
    80000468:	d04080e7          	jalr	-764(ra) # 80000168 <uart_puts>
            consputs("0x");
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    8000046c:	fa040713          	addi	a4,s0,-96
    80000470:	fb040593          	addi	a1,s0,-80
	uart_puts(str);
    80000474:	03c00693          	li	a3,60
                int shift = (15 - i) * 4;
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80000478:	00002617          	auipc	a2,0x2
    8000047c:	d8060613          	addi	a2,a2,-640 # 800021f8 <test_physical_memory+0x125e>
    80000480:	00db57b3          	srl	a5,s6,a3
    80000484:	8bbd                	andi	a5,a5,15
    80000486:	97b2                	add	a5,a5,a2
    80000488:	0007c783          	lbu	a5,0(a5)
    8000048c:	00f70023          	sb	a5,0(a4)
            for (i = 0; i < 16; i++) {
    80000490:	36f1                	addiw	a3,a3,-4
    80000492:	0705                	addi	a4,a4,1
    80000494:	feb716e3          	bne	a4,a1,80000480 <printf+0x172>
            }
            buf[16] = '\0';
    80000498:	fa040823          	sb	zero,-80(s0)
	uart_puts(str);
    8000049c:	fa040513          	addi	a0,s0,-96
    800004a0:	00000097          	auipc	ra,0x0
    800004a4:	cc8080e7          	jalr	-824(ra) # 80000168 <uart_puts>
}
    800004a8:	bd75                	j	80000364 <printf+0x56>
            consputs(buf);
            break;
		case 'b':
            printint(va_arg(ap, int), 2, 0);
    800004aa:	fb843783          	ld	a5,-72(s0)
    800004ae:	00878713          	addi	a4,a5,8
    800004b2:	fae43c23          	sd	a4,-72(s0)
    800004b6:	4601                	li	a2,0
    800004b8:	4589                	li	a1,2
    800004ba:	4388                	lw	a0,0(a5)
    800004bc:	00000097          	auipc	ra,0x0
    800004c0:	cf4080e7          	jalr	-780(ra) # 800001b0 <printint>
            break;
    800004c4:	b545                	j	80000364 <printf+0x56>
        case 'o':
            printint(va_arg(ap, int), 8, 0);
    800004c6:	fb843783          	ld	a5,-72(s0)
    800004ca:	00878713          	addi	a4,a5,8
    800004ce:	fae43c23          	sd	a4,-72(s0)
    800004d2:	4601                	li	a2,0
    800004d4:	45a1                	li	a1,8
    800004d6:	4388                	lw	a0,0(a5)
    800004d8:	00000097          	auipc	ra,0x0
    800004dc:	cd8080e7          	jalr	-808(ra) # 800001b0 <printint>
            break;
    800004e0:	b551                	j	80000364 <printf+0x56>
        case '%':
            buffer_char('%');
    800004e2:	02500513          	li	a0,37
    800004e6:	00000097          	auipc	ra,0x0
    800004ea:	dc0080e7          	jalr	-576(ra) # 800002a6 <buffer_char>
            break;
    800004ee:	bd9d                	j	80000364 <printf+0x56>
        default:
			buffer_char('%');
    800004f0:	02500513          	li	a0,37
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	db2080e7          	jalr	-590(ra) # 800002a6 <buffer_char>
			buffer_char(c);
    800004fc:	855a                	mv	a0,s6
    800004fe:	00000097          	auipc	ra,0x0
    80000502:	da8080e7          	jalr	-600(ra) # 800002a6 <buffer_char>
            break;
    80000506:	bdb9                	j	80000364 <printf+0x56>
    80000508:	64a6                	ld	s1,72(sp)
    8000050a:	79e2                	ld	s3,56(sp)
    8000050c:	7a42                	ld	s4,48(sp)
    8000050e:	7aa2                	ld	s5,40(sp)
    80000510:	7b02                	ld	s6,32(sp)
        }
    }
	flush_printf_buffer(); // 最后刷新缓冲区
    80000512:	00000097          	auipc	ra,0x0
    80000516:	d58080e7          	jalr	-680(ra) # 8000026a <flush_printf_buffer>
    va_end(ap);
}
    8000051a:	60e6                	ld	ra,88(sp)
    8000051c:	6446                	ld	s0,80(sp)
    8000051e:	6906                	ld	s2,64(sp)
    80000520:	610d                	addi	sp,sp,160
    80000522:	8082                	ret
    80000524:	64a6                	ld	s1,72(sp)
    80000526:	79e2                	ld	s3,56(sp)
    80000528:	7a42                	ld	s4,48(sp)
    8000052a:	7aa2                	ld	s5,40(sp)
    8000052c:	7b02                	ld	s6,32(sp)
    8000052e:	b7d5                	j	80000512 <printf+0x204>

0000000080000530 <clear_screen>:
// 清屏功能
void clear_screen(void) {
    80000530:	1141                	addi	sp,sp,-16
    80000532:	e406                	sd	ra,8(sp)
    80000534:	e022                	sd	s0,0(sp)
    80000536:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    80000538:	00002517          	auipc	a0,0x2
    8000053c:	cd850513          	addi	a0,a0,-808 # 80002210 <test_physical_memory+0x1276>
    80000540:	00000097          	auipc	ra,0x0
    80000544:	c28080e7          	jalr	-984(ra) # 80000168 <uart_puts>
	uart_puts(CURSOR_HOME);
    80000548:	00002517          	auipc	a0,0x2
    8000054c:	cd050513          	addi	a0,a0,-816 # 80002218 <test_physical_memory+0x127e>
    80000550:	00000097          	auipc	ra,0x0
    80000554:	c18080e7          	jalr	-1000(ra) # 80000168 <uart_puts>
}
    80000558:	60a2                	ld	ra,8(sp)
    8000055a:	6402                	ld	s0,0(sp)
    8000055c:	0141                	addi	sp,sp,16
    8000055e:	8082                	ret

0000000080000560 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    if (lines <= 0) return;
    80000560:	04a05563          	blez	a0,800005aa <cursor_up+0x4a>
void cursor_up(int lines) {
    80000564:	1101                	addi	sp,sp,-32
    80000566:	ec06                	sd	ra,24(sp)
    80000568:	e822                	sd	s0,16(sp)
    8000056a:	e426                	sd	s1,8(sp)
    8000056c:	1000                	addi	s0,sp,32
    8000056e:	84aa                	mv	s1,a0
	uart_putc(c);
    80000570:	456d                	li	a0,27
    80000572:	00000097          	auipc	ra,0x0
    80000576:	bd2080e7          	jalr	-1070(ra) # 80000144 <uart_putc>
    8000057a:	05b00513          	li	a0,91
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	bc6080e7          	jalr	-1082(ra) # 80000144 <uart_putc>
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    80000586:	4601                	li	a2,0
    80000588:	45a9                	li	a1,10
    8000058a:	8526                	mv	a0,s1
    8000058c:	00000097          	auipc	ra,0x0
    80000590:	c24080e7          	jalr	-988(ra) # 800001b0 <printint>
	uart_putc(c);
    80000594:	04100513          	li	a0,65
    80000598:	00000097          	auipc	ra,0x0
    8000059c:	bac080e7          	jalr	-1108(ra) # 80000144 <uart_putc>
    consputc('A');
}
    800005a0:	60e2                	ld	ra,24(sp)
    800005a2:	6442                	ld	s0,16(sp)
    800005a4:	64a2                	ld	s1,8(sp)
    800005a6:	6105                	addi	sp,sp,32
    800005a8:	8082                	ret
    800005aa:	8082                	ret

00000000800005ac <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    if (lines <= 0) return;
    800005ac:	04a05563          	blez	a0,800005f6 <cursor_down+0x4a>
void cursor_down(int lines) {
    800005b0:	1101                	addi	sp,sp,-32
    800005b2:	ec06                	sd	ra,24(sp)
    800005b4:	e822                	sd	s0,16(sp)
    800005b6:	e426                	sd	s1,8(sp)
    800005b8:	1000                	addi	s0,sp,32
    800005ba:	84aa                	mv	s1,a0
	uart_putc(c);
    800005bc:	456d                	li	a0,27
    800005be:	00000097          	auipc	ra,0x0
    800005c2:	b86080e7          	jalr	-1146(ra) # 80000144 <uart_putc>
    800005c6:	05b00513          	li	a0,91
    800005ca:	00000097          	auipc	ra,0x0
    800005ce:	b7a080e7          	jalr	-1158(ra) # 80000144 <uart_putc>
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    800005d2:	4601                	li	a2,0
    800005d4:	45a9                	li	a1,10
    800005d6:	8526                	mv	a0,s1
    800005d8:	00000097          	auipc	ra,0x0
    800005dc:	bd8080e7          	jalr	-1064(ra) # 800001b0 <printint>
	uart_putc(c);
    800005e0:	04200513          	li	a0,66
    800005e4:	00000097          	auipc	ra,0x0
    800005e8:	b60080e7          	jalr	-1184(ra) # 80000144 <uart_putc>
    consputc('B');
}
    800005ec:	60e2                	ld	ra,24(sp)
    800005ee:	6442                	ld	s0,16(sp)
    800005f0:	64a2                	ld	s1,8(sp)
    800005f2:	6105                	addi	sp,sp,32
    800005f4:	8082                	ret
    800005f6:	8082                	ret

00000000800005f8 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    if (cols <= 0) return;
    800005f8:	04a05563          	blez	a0,80000642 <cursor_right+0x4a>
void cursor_right(int cols) {
    800005fc:	1101                	addi	sp,sp,-32
    800005fe:	ec06                	sd	ra,24(sp)
    80000600:	e822                	sd	s0,16(sp)
    80000602:	e426                	sd	s1,8(sp)
    80000604:	1000                	addi	s0,sp,32
    80000606:	84aa                	mv	s1,a0
	uart_putc(c);
    80000608:	456d                	li	a0,27
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	b3a080e7          	jalr	-1222(ra) # 80000144 <uart_putc>
    80000612:	05b00513          	li	a0,91
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	b2e080e7          	jalr	-1234(ra) # 80000144 <uart_putc>
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    8000061e:	4601                	li	a2,0
    80000620:	45a9                	li	a1,10
    80000622:	8526                	mv	a0,s1
    80000624:	00000097          	auipc	ra,0x0
    80000628:	b8c080e7          	jalr	-1140(ra) # 800001b0 <printint>
	uart_putc(c);
    8000062c:	04300513          	li	a0,67
    80000630:	00000097          	auipc	ra,0x0
    80000634:	b14080e7          	jalr	-1260(ra) # 80000144 <uart_putc>
    consputc('C');
}
    80000638:	60e2                	ld	ra,24(sp)
    8000063a:	6442                	ld	s0,16(sp)
    8000063c:	64a2                	ld	s1,8(sp)
    8000063e:	6105                	addi	sp,sp,32
    80000640:	8082                	ret
    80000642:	8082                	ret

0000000080000644 <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    if (cols <= 0) return;
    80000644:	04a05563          	blez	a0,8000068e <cursor_left+0x4a>
void cursor_left(int cols) {
    80000648:	1101                	addi	sp,sp,-32
    8000064a:	ec06                	sd	ra,24(sp)
    8000064c:	e822                	sd	s0,16(sp)
    8000064e:	e426                	sd	s1,8(sp)
    80000650:	1000                	addi	s0,sp,32
    80000652:	84aa                	mv	s1,a0
	uart_putc(c);
    80000654:	456d                	li	a0,27
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	aee080e7          	jalr	-1298(ra) # 80000144 <uart_putc>
    8000065e:	05b00513          	li	a0,91
    80000662:	00000097          	auipc	ra,0x0
    80000666:	ae2080e7          	jalr	-1310(ra) # 80000144 <uart_putc>
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    8000066a:	4601                	li	a2,0
    8000066c:	45a9                	li	a1,10
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	b40080e7          	jalr	-1216(ra) # 800001b0 <printint>
	uart_putc(c);
    80000678:	04400513          	li	a0,68
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	ac8080e7          	jalr	-1336(ra) # 80000144 <uart_putc>
    consputc('D');
}
    80000684:	60e2                	ld	ra,24(sp)
    80000686:	6442                	ld	s0,16(sp)
    80000688:	64a2                	ld	s1,8(sp)
    8000068a:	6105                	addi	sp,sp,32
    8000068c:	8082                	ret
    8000068e:	8082                	ret

0000000080000690 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    80000690:	1141                	addi	sp,sp,-16
    80000692:	e406                	sd	ra,8(sp)
    80000694:	e022                	sd	s0,0(sp)
    80000696:	0800                	addi	s0,sp,16
	uart_putc(c);
    80000698:	456d                	li	a0,27
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	aaa080e7          	jalr	-1366(ra) # 80000144 <uart_putc>
    800006a2:	05b00513          	li	a0,91
    800006a6:	00000097          	auipc	ra,0x0
    800006aa:	a9e080e7          	jalr	-1378(ra) # 80000144 <uart_putc>
    800006ae:	07300513          	li	a0,115
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	a92080e7          	jalr	-1390(ra) # 80000144 <uart_putc>
    consputc('\033');
    consputc('[');
    consputc('s');
}
    800006ba:	60a2                	ld	ra,8(sp)
    800006bc:	6402                	ld	s0,0(sp)
    800006be:	0141                	addi	sp,sp,16
    800006c0:	8082                	ret

00000000800006c2 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    800006c2:	1141                	addi	sp,sp,-16
    800006c4:	e406                	sd	ra,8(sp)
    800006c6:	e022                	sd	s0,0(sp)
    800006c8:	0800                	addi	s0,sp,16
	uart_putc(c);
    800006ca:	456d                	li	a0,27
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	a78080e7          	jalr	-1416(ra) # 80000144 <uart_putc>
    800006d4:	05b00513          	li	a0,91
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	a6c080e7          	jalr	-1428(ra) # 80000144 <uart_putc>
    800006e0:	07500513          	li	a0,117
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	a60080e7          	jalr	-1440(ra) # 80000144 <uart_putc>
    consputc('\033');
    consputc('[');
    consputc('u');
}
    800006ec:	60a2                	ld	ra,8(sp)
    800006ee:	6402                	ld	s0,0(sp)
    800006f0:	0141                	addi	sp,sp,16
    800006f2:	8082                	ret

00000000800006f4 <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    800006f4:	1101                	addi	sp,sp,-32
    800006f6:	ec06                	sd	ra,24(sp)
    800006f8:	e822                	sd	s0,16(sp)
    800006fa:	e426                	sd	s1,8(sp)
    800006fc:	1000                	addi	s0,sp,32
    800006fe:	84aa                	mv	s1,a0
	uart_putc(c);
    80000700:	456d                	li	a0,27
    80000702:	00000097          	auipc	ra,0x0
    80000706:	a42080e7          	jalr	-1470(ra) # 80000144 <uart_putc>
    8000070a:	05b00513          	li	a0,91
    8000070e:	00000097          	auipc	ra,0x0
    80000712:	a36080e7          	jalr	-1482(ra) # 80000144 <uart_putc>
    if (col <= 0) col = 1;
    80000716:	8526                	mv	a0,s1
    80000718:	02905463          	blez	s1,80000740 <cursor_to_column+0x4c>
    consputc('\033');
    consputc('[');
    printint(col, 10, 0);
    8000071c:	4601                	li	a2,0
    8000071e:	45a9                	li	a1,10
    80000720:	2501                	sext.w	a0,a0
    80000722:	00000097          	auipc	ra,0x0
    80000726:	a8e080e7          	jalr	-1394(ra) # 800001b0 <printint>
	uart_putc(c);
    8000072a:	04700513          	li	a0,71
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	a16080e7          	jalr	-1514(ra) # 80000144 <uart_putc>
    consputc('G');
}
    80000736:	60e2                	ld	ra,24(sp)
    80000738:	6442                	ld	s0,16(sp)
    8000073a:	64a2                	ld	s1,8(sp)
    8000073c:	6105                	addi	sp,sp,32
    8000073e:	8082                	ret
    if (col <= 0) col = 1;
    80000740:	4505                	li	a0,1
    80000742:	bfe9                	j	8000071c <cursor_to_column+0x28>

0000000080000744 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80000744:	1101                	addi	sp,sp,-32
    80000746:	ec06                	sd	ra,24(sp)
    80000748:	e822                	sd	s0,16(sp)
    8000074a:	e426                	sd	s1,8(sp)
    8000074c:	e04a                	sd	s2,0(sp)
    8000074e:	1000                	addi	s0,sp,32
    80000750:	892a                	mv	s2,a0
    80000752:	84ae                	mv	s1,a1
	uart_putc(c);
    80000754:	456d                	li	a0,27
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	9ee080e7          	jalr	-1554(ra) # 80000144 <uart_putc>
    8000075e:	05b00513          	li	a0,91
    80000762:	00000097          	auipc	ra,0x0
    80000766:	9e2080e7          	jalr	-1566(ra) # 80000144 <uart_putc>
    consputc('\033');
    consputc('[');
    printint(row, 10, 0);
    8000076a:	4601                	li	a2,0
    8000076c:	45a9                	li	a1,10
    8000076e:	854a                	mv	a0,s2
    80000770:	00000097          	auipc	ra,0x0
    80000774:	a40080e7          	jalr	-1472(ra) # 800001b0 <printint>
	uart_putc(c);
    80000778:	03b00513          	li	a0,59
    8000077c:	00000097          	auipc	ra,0x0
    80000780:	9c8080e7          	jalr	-1592(ra) # 80000144 <uart_putc>
    consputc(';');
    printint(col, 10, 0);
    80000784:	4601                	li	a2,0
    80000786:	45a9                	li	a1,10
    80000788:	8526                	mv	a0,s1
    8000078a:	00000097          	auipc	ra,0x0
    8000078e:	a26080e7          	jalr	-1498(ra) # 800001b0 <printint>
	uart_putc(c);
    80000792:	04800513          	li	a0,72
    80000796:	00000097          	auipc	ra,0x0
    8000079a:	9ae080e7          	jalr	-1618(ra) # 80000144 <uart_putc>
    consputc('H');
}
    8000079e:	60e2                	ld	ra,24(sp)
    800007a0:	6442                	ld	s0,16(sp)
    800007a2:	64a2                	ld	s1,8(sp)
    800007a4:	6902                	ld	s2,0(sp)
    800007a6:	6105                	addi	sp,sp,32
    800007a8:	8082                	ret

00000000800007aa <reset_color>:
// 颜色控制
void reset_color(void) {
    800007aa:	1141                	addi	sp,sp,-16
    800007ac:	e406                	sd	ra,8(sp)
    800007ae:	e022                	sd	s0,0(sp)
    800007b0:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    800007b2:	00002517          	auipc	a0,0x2
    800007b6:	a6e50513          	addi	a0,a0,-1426 # 80002220 <test_physical_memory+0x1286>
    800007ba:	00000097          	auipc	ra,0x0
    800007be:	9ae080e7          	jalr	-1618(ra) # 80000168 <uart_puts>
}
    800007c2:	60a2                	ld	ra,8(sp)
    800007c4:	6402                	ld	s0,0(sp)
    800007c6:	0141                	addi	sp,sp,16
    800007c8:	8082                	ret

00000000800007ca <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
	if (color < 30 || color > 37) return; // 支持30-37
    800007ca:	fe25071b          	addiw	a4,a0,-30
    800007ce:	479d                	li	a5,7
    800007d0:	00e7f363          	bgeu	a5,a4,800007d6 <set_fg_color+0xc>
    800007d4:	8082                	ret
void set_fg_color(int color) {
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
    800007e0:	84aa                	mv	s1,a0
	uart_putc(c);
    800007e2:	456d                	li	a0,27
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	960080e7          	jalr	-1696(ra) # 80000144 <uart_putc>
    800007ec:	05b00513          	li	a0,91
    800007f0:	00000097          	auipc	ra,0x0
    800007f4:	954080e7          	jalr	-1708(ra) # 80000144 <uart_putc>
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
    800007f8:	4601                	li	a2,0
    800007fa:	45a9                	li	a1,10
    800007fc:	8526                	mv	a0,s1
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	9b2080e7          	jalr	-1614(ra) # 800001b0 <printint>
	uart_putc(c);
    80000806:	06d00513          	li	a0,109
    8000080a:	00000097          	auipc	ra,0x0
    8000080e:	93a080e7          	jalr	-1734(ra) # 80000144 <uart_putc>
	consputc('m');
}
    80000812:	60e2                	ld	ra,24(sp)
    80000814:	6442                	ld	s0,16(sp)
    80000816:	64a2                	ld	s1,8(sp)
    80000818:	6105                	addi	sp,sp,32
    8000081a:	8082                	ret

000000008000081c <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
	if (color < 40 || color > 47) return; // 支持40-47
    8000081c:	fd85071b          	addiw	a4,a0,-40
    80000820:	479d                	li	a5,7
    80000822:	00e7f363          	bgeu	a5,a4,80000828 <set_bg_color+0xc>
    80000826:	8082                	ret
void set_bg_color(int color) {
    80000828:	1101                	addi	sp,sp,-32
    8000082a:	ec06                	sd	ra,24(sp)
    8000082c:	e822                	sd	s0,16(sp)
    8000082e:	e426                	sd	s1,8(sp)
    80000830:	1000                	addi	s0,sp,32
    80000832:	84aa                	mv	s1,a0
	uart_putc(c);
    80000834:	456d                	li	a0,27
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	90e080e7          	jalr	-1778(ra) # 80000144 <uart_putc>
    8000083e:	05b00513          	li	a0,91
    80000842:	00000097          	auipc	ra,0x0
    80000846:	902080e7          	jalr	-1790(ra) # 80000144 <uart_putc>
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
    8000084a:	4601                	li	a2,0
    8000084c:	45a9                	li	a1,10
    8000084e:	8526                	mv	a0,s1
    80000850:	00000097          	auipc	ra,0x0
    80000854:	960080e7          	jalr	-1696(ra) # 800001b0 <printint>
	uart_putc(c);
    80000858:	06d00513          	li	a0,109
    8000085c:	00000097          	auipc	ra,0x0
    80000860:	8e8080e7          	jalr	-1816(ra) # 80000144 <uart_putc>
	consputc('m');
}
    80000864:	60e2                	ld	ra,24(sp)
    80000866:	6442                	ld	s0,16(sp)
    80000868:	64a2                	ld	s1,8(sp)
    8000086a:	6105                	addi	sp,sp,32
    8000086c:	8082                	ret

000000008000086e <color_red>:
// 简易文字颜色
void color_red(void) {
    8000086e:	1141                	addi	sp,sp,-16
    80000870:	e406                	sd	ra,8(sp)
    80000872:	e022                	sd	s0,0(sp)
    80000874:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    80000876:	457d                	li	a0,31
    80000878:	00000097          	auipc	ra,0x0
    8000087c:	f52080e7          	jalr	-174(ra) # 800007ca <set_fg_color>
}
    80000880:	60a2                	ld	ra,8(sp)
    80000882:	6402                	ld	s0,0(sp)
    80000884:	0141                	addi	sp,sp,16
    80000886:	8082                	ret

0000000080000888 <color_green>:
void color_green(void) {
    80000888:	1141                	addi	sp,sp,-16
    8000088a:	e406                	sd	ra,8(sp)
    8000088c:	e022                	sd	s0,0(sp)
    8000088e:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    80000890:	02000513          	li	a0,32
    80000894:	00000097          	auipc	ra,0x0
    80000898:	f36080e7          	jalr	-202(ra) # 800007ca <set_fg_color>
}
    8000089c:	60a2                	ld	ra,8(sp)
    8000089e:	6402                	ld	s0,0(sp)
    800008a0:	0141                	addi	sp,sp,16
    800008a2:	8082                	ret

00000000800008a4 <color_yellow>:
void color_yellow(void) {
    800008a4:	1141                	addi	sp,sp,-16
    800008a6:	e406                	sd	ra,8(sp)
    800008a8:	e022                	sd	s0,0(sp)
    800008aa:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    800008ac:	02100513          	li	a0,33
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	f1a080e7          	jalr	-230(ra) # 800007ca <set_fg_color>
}
    800008b8:	60a2                	ld	ra,8(sp)
    800008ba:	6402                	ld	s0,0(sp)
    800008bc:	0141                	addi	sp,sp,16
    800008be:	8082                	ret

00000000800008c0 <color_blue>:
void color_blue(void) {
    800008c0:	1141                	addi	sp,sp,-16
    800008c2:	e406                	sd	ra,8(sp)
    800008c4:	e022                	sd	s0,0(sp)
    800008c6:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    800008c8:	02200513          	li	a0,34
    800008cc:	00000097          	auipc	ra,0x0
    800008d0:	efe080e7          	jalr	-258(ra) # 800007ca <set_fg_color>
}
    800008d4:	60a2                	ld	ra,8(sp)
    800008d6:	6402                	ld	s0,0(sp)
    800008d8:	0141                	addi	sp,sp,16
    800008da:	8082                	ret

00000000800008dc <color_purple>:
void color_purple(void) {
    800008dc:	1141                	addi	sp,sp,-16
    800008de:	e406                	sd	ra,8(sp)
    800008e0:	e022                	sd	s0,0(sp)
    800008e2:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    800008e4:	02300513          	li	a0,35
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	ee2080e7          	jalr	-286(ra) # 800007ca <set_fg_color>
}
    800008f0:	60a2                	ld	ra,8(sp)
    800008f2:	6402                	ld	s0,0(sp)
    800008f4:	0141                	addi	sp,sp,16
    800008f6:	8082                	ret

00000000800008f8 <color_cyan>:
void color_cyan(void) {
    800008f8:	1141                	addi	sp,sp,-16
    800008fa:	e406                	sd	ra,8(sp)
    800008fc:	e022                	sd	s0,0(sp)
    800008fe:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    80000900:	02400513          	li	a0,36
    80000904:	00000097          	auipc	ra,0x0
    80000908:	ec6080e7          	jalr	-314(ra) # 800007ca <set_fg_color>
}
    8000090c:	60a2                	ld	ra,8(sp)
    8000090e:	6402                	ld	s0,0(sp)
    80000910:	0141                	addi	sp,sp,16
    80000912:	8082                	ret

0000000080000914 <color_reverse>:
void color_reverse(void){
    80000914:	1141                	addi	sp,sp,-16
    80000916:	e406                	sd	ra,8(sp)
    80000918:	e022                	sd	s0,0(sp)
    8000091a:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    8000091c:	02500513          	li	a0,37
    80000920:	00000097          	auipc	ra,0x0
    80000924:	eaa080e7          	jalr	-342(ra) # 800007ca <set_fg_color>
}
    80000928:	60a2                	ld	ra,8(sp)
    8000092a:	6402                	ld	s0,0(sp)
    8000092c:	0141                	addi	sp,sp,16
    8000092e:	8082                	ret

0000000080000930 <set_color>:
void set_color(int fg, int bg) {
    80000930:	1101                	addi	sp,sp,-32
    80000932:	ec06                	sd	ra,24(sp)
    80000934:	e822                	sd	s0,16(sp)
    80000936:	e426                	sd	s1,8(sp)
    80000938:	1000                	addi	s0,sp,32
    8000093a:	84aa                	mv	s1,a0
	set_bg_color(bg);
    8000093c:	852e                	mv	a0,a1
    8000093e:	00000097          	auipc	ra,0x0
    80000942:	ede080e7          	jalr	-290(ra) # 8000081c <set_bg_color>
	set_fg_color(fg);
    80000946:	8526                	mv	a0,s1
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	e82080e7          	jalr	-382(ra) # 800007ca <set_fg_color>
}
    80000950:	60e2                	ld	ra,24(sp)
    80000952:	6442                	ld	s0,16(sp)
    80000954:	64a2                	ld	s1,8(sp)
    80000956:	6105                	addi	sp,sp,32
    80000958:	8082                	ret

000000008000095a <clear_line>:
void clear_line(){
    8000095a:	1141                	addi	sp,sp,-16
    8000095c:	e406                	sd	ra,8(sp)
    8000095e:	e022                	sd	s0,0(sp)
    80000960:	0800                	addi	s0,sp,16
	uart_putc(c);
    80000962:	456d                	li	a0,27
    80000964:	fffff097          	auipc	ra,0xfffff
    80000968:	7e0080e7          	jalr	2016(ra) # 80000144 <uart_putc>
    8000096c:	05b00513          	li	a0,91
    80000970:	fffff097          	auipc	ra,0xfffff
    80000974:	7d4080e7          	jalr	2004(ra) # 80000144 <uart_putc>
    80000978:	03200513          	li	a0,50
    8000097c:	fffff097          	auipc	ra,0xfffff
    80000980:	7c8080e7          	jalr	1992(ra) # 80000144 <uart_putc>
    80000984:	04b00513          	li	a0,75
    80000988:	fffff097          	auipc	ra,0xfffff
    8000098c:	7bc080e7          	jalr	1980(ra) # 80000144 <uart_putc>
	consputc('\033');
	consputc('[');
	consputc('2');
	consputc('K');
}
    80000990:	60a2                	ld	ra,8(sp)
    80000992:	6402                	ld	s0,0(sp)
    80000994:	0141                	addi	sp,sp,16
    80000996:	8082                	ret

0000000080000998 <panic>:

void panic(const char *msg) {
    80000998:	1101                	addi	sp,sp,-32
    8000099a:	ec06                	sd	ra,24(sp)
    8000099c:	e822                	sd	s0,16(sp)
    8000099e:	e426                	sd	s1,8(sp)
    800009a0:	1000                	addi	s0,sp,32
    800009a2:	84aa                	mv	s1,a0
	color_red(); // 可选：红色显示
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	eca080e7          	jalr	-310(ra) # 8000086e <color_red>
	printf("panic: %s\n", msg);
    800009ac:	85a6                	mv	a1,s1
    800009ae:	00002517          	auipc	a0,0x2
    800009b2:	87a50513          	addi	a0,a0,-1926 # 80002228 <test_physical_memory+0x128e>
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	958080e7          	jalr	-1704(ra) # 8000030e <printf>
	reset_color();
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	dec080e7          	jalr	-532(ra) # 800007aa <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    800009c6:	a001                	j	800009c6 <panic+0x2e>

00000000800009c8 <memset>:
#include "mem.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    800009c8:	1141                	addi	sp,sp,-16
    800009ca:	e422                	sd	s0,8(sp)
    800009cc:	0800                	addi	s0,sp,16
    unsigned char *p = dst;
    while (n-- > 0)
    800009ce:	ca01                	beqz	a2,800009de <memset+0x16>
    800009d0:	962a                	add	a2,a2,a0
    unsigned char *p = dst;
    800009d2:	87aa                	mv	a5,a0
        *p++ = (unsigned char)c;
    800009d4:	0785                	addi	a5,a5,1
    800009d6:	feb78fa3          	sb	a1,-1(a5)
    while (n-- > 0)
    800009da:	fef61de3          	bne	a2,a5,800009d4 <memset+0xc>
    return dst;
    800009de:	6422                	ld	s0,8(sp)
    800009e0:	0141                	addi	sp,sp,16
    800009e2:	8082                	ret

00000000800009e4 <create_pagetable>:
static inline uint64 px(int level, uint64 va) {
    return VPN_MASK(va, level);
}

// 创建空页表
pagetable_t create_pagetable(void) {
    800009e4:	1101                	addi	sp,sp,-32
    800009e6:	ec06                	sd	ra,24(sp)
    800009e8:	e822                	sd	s0,16(sp)
    800009ea:	e426                	sd	s1,8(sp)
    800009ec:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    800009ee:	00000097          	auipc	ra,0x0
    800009f2:	4c8080e7          	jalr	1224(ra) # 80000eb6 <alloc_page>
    800009f6:	84aa                	mv	s1,a0
    if (!pt)
    800009f8:	c519                	beqz	a0,80000a06 <create_pagetable+0x22>
        return 0;
    memset(pt, 0, PGSIZE);
    800009fa:	6605                	lui	a2,0x1
    800009fc:	4581                	li	a1,0
    800009fe:	00000097          	auipc	ra,0x0
    80000a02:	fca080e7          	jalr	-54(ra) # 800009c8 <memset>
    return pt;
}
    80000a06:	8526                	mv	a0,s1
    80000a08:	60e2                	ld	ra,24(sp)
    80000a0a:	6442                	ld	s0,16(sp)
    80000a0c:	64a2                	ld	s1,8(sp)
    80000a0e:	6105                	addi	sp,sp,32
    80000a10:	8082                	ret

0000000080000a12 <map_page>:
    }
    return &pt[px(0, va)];
}

// 建立映射
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    80000a12:	715d                	addi	sp,sp,-80
    80000a14:	e486                	sd	ra,72(sp)
    80000a16:	e0a2                	sd	s0,64(sp)
    80000a18:	fc26                	sd	s1,56(sp)
    80000a1a:	f84a                	sd	s2,48(sp)
    80000a1c:	f44e                	sd	s3,40(sp)
    80000a1e:	f052                	sd	s4,32(sp)
    80000a20:	ec56                	sd	s5,24(sp)
    80000a22:	e85a                	sd	s6,16(sp)
    80000a24:	e45e                	sd	s7,8(sp)
    80000a26:	0880                	addi	s0,sp,80
    80000a28:	84aa                	mv	s1,a0
    80000a2a:	8aae                	mv	s5,a1
    80000a2c:	89b2                	mv	s3,a2
    80000a2e:	8a36                	mv	s4,a3
    if ((va % PGSIZE) != 0)
    80000a30:	03459793          	slli	a5,a1,0x34
    80000a34:	e7b5                	bnez	a5,80000aa0 <map_page+0x8e>
    if (va >= MAXVA)
    80000a36:	57fd                	li	a5,-1
    80000a38:	83e5                	srli	a5,a5,0x19
    80000a3a:	0757ec63          	bltu	a5,s5,80000ab2 <map_page+0xa0>
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    80000a3e:	4b79                	li	s6,30
    for (int level = 2; level > 0; level--) {
    80000a40:	4bb1                	li	s7,12
    return VPN_MASK(va, level);
    80000a42:	016ad933          	srl	s2,s5,s6
    80000a46:	1ff97913          	andi	s2,s2,511
        pte_t *pte = &pt[px(level, va)];
    80000a4a:	090e                	slli	s2,s2,0x3
    80000a4c:	9926                	add	s2,s2,s1
        if (*pte & PTE_V) {
    80000a4e:	00093483          	ld	s1,0(s2)
    80000a52:	0014f793          	andi	a5,s1,1
    80000a56:	c7bd                	beqz	a5,80000ac4 <map_page+0xb2>
            pt = (pagetable_t)PTE2PA(*pte);
    80000a58:	80a9                	srli	s1,s1,0xa
    80000a5a:	04b2                	slli	s1,s1,0xc
    for (int level = 2; level > 0; level--) {
    80000a5c:	3b5d                	addiw	s6,s6,-9
    80000a5e:	ff7b12e3          	bne	s6,s7,80000a42 <map_page+0x30>
    return VPN_MASK(va, level);
    80000a62:	00cad593          	srli	a1,s5,0xc
    80000a66:	1ff5f593          	andi	a1,a1,511
    return &pt[px(0, va)];
    80000a6a:	058e                	slli	a1,a1,0x3
    80000a6c:	94ae                	add	s1,s1,a1
        panic("map_page: va not aligned");
    pte_t *pte = walk_create(pt, va);
    if (!pte)
    80000a6e:	c8d1                	beqz	s1,80000b02 <map_page+0xf0>
        return -1;
    if (*pte & PTE_V)
    80000a70:	609c                	ld	a5,0(s1)
    80000a72:	8b85                	andi	a5,a5,1
    80000a74:	efa5                	bnez	a5,80000aec <map_page+0xda>
        panic("map_page: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000a76:	00c9d993          	srli	s3,s3,0xc
    80000a7a:	09aa                	slli	s3,s3,0xa
    80000a7c:	0149e9b3          	or	s3,s3,s4
    80000a80:	0019e993          	ori	s3,s3,1
    80000a84:	0134b023          	sd	s3,0(s1)
    return 0;
    80000a88:	4501                	li	a0,0
}
    80000a8a:	60a6                	ld	ra,72(sp)
    80000a8c:	6406                	ld	s0,64(sp)
    80000a8e:	74e2                	ld	s1,56(sp)
    80000a90:	7942                	ld	s2,48(sp)
    80000a92:	79a2                	ld	s3,40(sp)
    80000a94:	7a02                	ld	s4,32(sp)
    80000a96:	6ae2                	ld	s5,24(sp)
    80000a98:	6b42                	ld	s6,16(sp)
    80000a9a:	6ba2                	ld	s7,8(sp)
    80000a9c:	6161                	addi	sp,sp,80
    80000a9e:	8082                	ret
        panic("map_page: va not aligned");
    80000aa0:	00001517          	auipc	a0,0x1
    80000aa4:	79850513          	addi	a0,a0,1944 # 80002238 <test_physical_memory+0x129e>
    80000aa8:	00000097          	auipc	ra,0x0
    80000aac:	ef0080e7          	jalr	-272(ra) # 80000998 <panic>
    80000ab0:	b759                	j	80000a36 <map_page+0x24>
        panic("walk_create: va out of range");
    80000ab2:	00001517          	auipc	a0,0x1
    80000ab6:	7a650513          	addi	a0,a0,1958 # 80002258 <test_physical_memory+0x12be>
    80000aba:	00000097          	auipc	ra,0x0
    80000abe:	ede080e7          	jalr	-290(ra) # 80000998 <panic>
    80000ac2:	bfb5                	j	80000a3e <map_page+0x2c>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	3f2080e7          	jalr	1010(ra) # 80000eb6 <alloc_page>
    80000acc:	84aa                	mv	s1,a0
            if (!new_pt)
    80000ace:	c905                	beqz	a0,80000afe <map_page+0xec>
            memset(new_pt, 0, PGSIZE);
    80000ad0:	6605                	lui	a2,0x1
    80000ad2:	4581                	li	a1,0
    80000ad4:	00000097          	auipc	ra,0x0
    80000ad8:	ef4080e7          	jalr	-268(ra) # 800009c8 <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    80000adc:	00c4d793          	srli	a5,s1,0xc
    80000ae0:	07aa                	slli	a5,a5,0xa
    80000ae2:	0017e793          	ori	a5,a5,1
    80000ae6:	00f93023          	sd	a5,0(s2)
            pt = new_pt;
    80000aea:	bf8d                	j	80000a5c <map_page+0x4a>
        panic("map_page: remap");
    80000aec:	00001517          	auipc	a0,0x1
    80000af0:	78c50513          	addi	a0,a0,1932 # 80002278 <test_physical_memory+0x12de>
    80000af4:	00000097          	auipc	ra,0x0
    80000af8:	ea4080e7          	jalr	-348(ra) # 80000998 <panic>
    80000afc:	bfad                	j	80000a76 <map_page+0x64>
        return -1;
    80000afe:	557d                	li	a0,-1
    80000b00:	b769                	j	80000a8a <map_page+0x78>
    80000b02:	557d                	li	a0,-1
    80000b04:	b759                	j	80000a8a <map_page+0x78>

0000000080000b06 <free_pagetable>:
// 递归释放页表
void free_pagetable(pagetable_t pt) {
    80000b06:	7179                	addi	sp,sp,-48
    80000b08:	f406                	sd	ra,40(sp)
    80000b0a:	f022                	sd	s0,32(sp)
    80000b0c:	ec26                	sd	s1,24(sp)
    80000b0e:	e84a                	sd	s2,16(sp)
    80000b10:	e44e                	sd	s3,8(sp)
    80000b12:	e052                	sd	s4,0(sp)
    80000b14:	1800                	addi	s0,sp,48
    80000b16:	8a2a                	mv	s4,a0
    for (int i = 0; i < 512; i++) {
    80000b18:	84aa                	mv	s1,a0
    80000b1a:	6905                	lui	s2,0x1
    80000b1c:	992a                	add	s2,s2,a0
        pte_t pte = pt[i];
        // 只释放中间页表
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80000b1e:	4985                	li	s3,1
    80000b20:	a829                	j	80000b3a <free_pagetable+0x34>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    80000b22:	83a9                	srli	a5,a5,0xa
            free_pagetable(child);
    80000b24:	00c79513          	slli	a0,a5,0xc
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	fde080e7          	jalr	-34(ra) # 80000b06 <free_pagetable>
            pt[i] = 0;
    80000b30:	0004b023          	sd	zero,0(s1)
    for (int i = 0; i < 512; i++) {
    80000b34:	04a1                	addi	s1,s1,8
    80000b36:	01248f63          	beq	s1,s2,80000b54 <free_pagetable+0x4e>
        pte_t pte = pt[i];
    80000b3a:	609c                	ld	a5,0(s1)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80000b3c:	00f7f713          	andi	a4,a5,15
    80000b40:	ff3701e3          	beq	a4,s3,80000b22 <free_pagetable+0x1c>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    80000b44:	0017f713          	andi	a4,a5,1
    80000b48:	d775                	beqz	a4,80000b34 <free_pagetable+0x2e>
    80000b4a:	8bb9                	andi	a5,a5,14
    80000b4c:	d7e5                	beqz	a5,80000b34 <free_pagetable+0x2e>
            pt[i] = 0;
    80000b4e:	0004b023          	sd	zero,0(s1)
    80000b52:	b7cd                	j	80000b34 <free_pagetable+0x2e>
        }
    }
    free_page(pt);
    80000b54:	8552                	mv	a0,s4
    80000b56:	00000097          	auipc	ra,0x0
    80000b5a:	3ae080e7          	jalr	942(ra) # 80000f04 <free_page>
}
    80000b5e:	70a2                	ld	ra,40(sp)
    80000b60:	7402                	ld	s0,32(sp)
    80000b62:	64e2                	ld	s1,24(sp)
    80000b64:	6942                	ld	s2,16(sp)
    80000b66:	69a2                	ld	s3,8(sp)
    80000b68:	6a02                	ld	s4,0(sp)
    80000b6a:	6145                	addi	sp,sp,48
    80000b6c:	8082                	ret

0000000080000b6e <kvminit>:

    return kpgtbl;
}

// 初始化内核页表
void kvminit(void) {
    80000b6e:	7139                	addi	sp,sp,-64
    80000b70:	fc06                	sd	ra,56(sp)
    80000b72:	f822                	sd	s0,48(sp)
    80000b74:	f426                	sd	s1,40(sp)
    80000b76:	f04a                	sd	s2,32(sp)
    80000b78:	ec4e                	sd	s3,24(sp)
    80000b7a:	e852                	sd	s4,16(sp)
    80000b7c:	e456                	sd	s5,8(sp)
    80000b7e:	0080                	addi	s0,sp,64
    pagetable_t kpgtbl = create_pagetable();
    80000b80:	00000097          	auipc	ra,0x0
    80000b84:	e64080e7          	jalr	-412(ra) # 800009e4 <create_pagetable>
    80000b88:	892a                	mv	s2,a0
    if (!kpgtbl)
    80000b8a:	c919                	beqz	a0,80000ba0 <kvminit+0x32>
void kvminit(void) {
    80000b8c:	4485                	li	s1,1
    80000b8e:	04fe                	slli	s1,s1,0x1f
            panic("kvmmake: map_page failed");
    80000b90:	00001a97          	auipc	s5,0x1
    80000b94:	710a8a93          	addi	s5,s5,1808 # 800022a0 <test_physical_memory+0x1306>
    for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    80000b98:	6a05                	lui	s4,0x1
    80000b9a:	49c5                	li	s3,17
    80000b9c:	09ee                	slli	s3,s3,0x1b
    80000b9e:	a829                	j	80000bb8 <kvminit+0x4a>
        panic("kvmmake: alloc failed");
    80000ba0:	00001517          	auipc	a0,0x1
    80000ba4:	6e850513          	addi	a0,a0,1768 # 80002288 <test_physical_memory+0x12ee>
    80000ba8:	00000097          	auipc	ra,0x0
    80000bac:	df0080e7          	jalr	-528(ra) # 80000998 <panic>
    80000bb0:	bff1                	j	80000b8c <kvminit+0x1e>
    for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    80000bb2:	94d2                	add	s1,s1,s4
    80000bb4:	03348163          	beq	s1,s3,80000bd6 <kvminit+0x68>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W | PTE_X) != 0)
    80000bb8:	46b9                	li	a3,14
    80000bba:	8626                	mv	a2,s1
    80000bbc:	85a6                	mv	a1,s1
    80000bbe:	854a                	mv	a0,s2
    80000bc0:	00000097          	auipc	ra,0x0
    80000bc4:	e52080e7          	jalr	-430(ra) # 80000a12 <map_page>
    80000bc8:	d56d                	beqz	a0,80000bb2 <kvminit+0x44>
            panic("kvmmake: map_page failed");
    80000bca:	8556                	mv	a0,s5
    80000bcc:	00000097          	auipc	ra,0x0
    80000bd0:	dcc080e7          	jalr	-564(ra) # 80000998 <panic>
    80000bd4:	bff9                	j	80000bb2 <kvminit+0x44>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    80000bd6:	4699                	li	a3,6
    80000bd8:	10000637          	lui	a2,0x10000
    80000bdc:	100005b7          	lui	a1,0x10000
    80000be0:	854a                	mv	a0,s2
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	e30080e7          	jalr	-464(ra) # 80000a12 <map_page>
    80000bea:	ed11                	bnez	a0,80000c06 <kvminit+0x98>
    kernel_pagetable = kvmmake();
    80000bec:	00004797          	auipc	a5,0x4
    80000bf0:	4327b223          	sd	s2,1060(a5) # 80005010 <kernel_pagetable>
}
    80000bf4:	70e2                	ld	ra,56(sp)
    80000bf6:	7442                	ld	s0,48(sp)
    80000bf8:	74a2                	ld	s1,40(sp)
    80000bfa:	7902                	ld	s2,32(sp)
    80000bfc:	69e2                	ld	s3,24(sp)
    80000bfe:	6a42                	ld	s4,16(sp)
    80000c00:	6aa2                	ld	s5,8(sp)
    80000c02:	6121                	addi	sp,sp,64
    80000c04:	8082                	ret
        panic("kvmmake: uart map_page failed");
    80000c06:	00001517          	auipc	a0,0x1
    80000c0a:	6ba50513          	addi	a0,a0,1722 # 800022c0 <test_physical_memory+0x1326>
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	d8a080e7          	jalr	-630(ra) # 80000998 <panic>
    80000c16:	bfd9                	j	80000bec <kvminit+0x7e>

0000000080000c18 <kvminithart>:

static inline void sfence_vma(void) {
    asm volatile("sfence.vma zero, zero");
}

void kvminithart(void) {
    80000c18:	1141                	addi	sp,sp,-16
    80000c1a:	e422                	sd	s0,8(sp)
    80000c1c:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    80000c1e:	12000073          	sfence.vma
    sfence_vma();
    w_satp(MAKE_SATP(kernel_pagetable));
    80000c22:	00004797          	auipc	a5,0x4
    80000c26:	3ee7b783          	ld	a5,1006(a5) # 80005010 <kernel_pagetable>
    80000c2a:	83b1                	srli	a5,a5,0xc
    80000c2c:	577d                	li	a4,-1
    80000c2e:	177e                	slli	a4,a4,0x3f
    80000c30:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r"(x));
    80000c32:	18079073          	csrw	satp,a5
    asm volatile("sfence.vma zero, zero");
    80000c36:	12000073          	sfence.vma
    sfence_vma();
}
    80000c3a:	6422                	ld	s0,8(sp)
    80000c3c:	0141                	addi	sp,sp,16
    80000c3e:	8082                	ret

0000000080000c40 <test_pagetable>:

void test_pagetable(void) {
    80000c40:	7179                	addi	sp,sp,-48
    80000c42:	f406                	sd	ra,40(sp)
    80000c44:	f022                	sd	s0,32(sp)
    80000c46:	ec26                	sd	s1,24(sp)
    80000c48:	e84a                	sd	s2,16(sp)
    80000c4a:	e44e                	sd	s3,8(sp)
    80000c4c:	e052                	sd	s4,0(sp)
    80000c4e:	1800                	addi	s0,sp,48
    printf("[PT TEST] 创建页表...\n");
    80000c50:	00001517          	auipc	a0,0x1
    80000c54:	69050513          	addi	a0,a0,1680 # 800022e0 <test_physical_memory+0x1346>
    80000c58:	fffff097          	auipc	ra,0xfffff
    80000c5c:	6b6080e7          	jalr	1718(ra) # 8000030e <printf>
    pagetable_t pt = create_pagetable();
    80000c60:	00000097          	auipc	ra,0x0
    80000c64:	d84080e7          	jalr	-636(ra) # 800009e4 <create_pagetable>
    80000c68:	892a                	mv	s2,a0
#include "printf.h"

static inline void assert(int expr) {
    if (!expr) {
    80000c6a:	c17d                	beqz	a0,80000d50 <test_pagetable+0x110>
    assert(pt != 0);
    printf("[PT TEST] 页表创建通过\n");
    80000c6c:	00001517          	auipc	a0,0x1
    80000c70:	6d450513          	addi	a0,a0,1748 # 80002340 <test_physical_memory+0x13a6>
    80000c74:	fffff097          	auipc	ra,0xfffff
    80000c78:	69a080e7          	jalr	1690(ra) # 8000030e <printf>

    // 测试基本映射
    uint64 va = 0x1000000;
    uint64 pa = (uint64)alloc_page();
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	23a080e7          	jalr	570(ra) # 80000eb6 <alloc_page>
    80000c84:	89aa                	mv	s3,a0
    80000c86:	8a2a                	mv	s4,a0
    80000c88:	c975                	beqz	a0,80000d7c <test_pagetable+0x13c>
    assert(pa != 0);
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0);
    80000c8a:	4699                	li	a3,6
    80000c8c:	864e                	mv	a2,s3
    80000c8e:	010005b7          	lui	a1,0x1000
    80000c92:	854a                	mv	a0,s2
    80000c94:	00000097          	auipc	ra,0x0
    80000c98:	d7e080e7          	jalr	-642(ra) # 80000a12 <map_page>
    80000c9c:	10051663          	bnez	a0,80000da8 <test_pagetable+0x168>
    printf("[PT TEST] 映射测试通过\n");
    80000ca0:	00001517          	auipc	a0,0x1
    80000ca4:	6c050513          	addi	a0,a0,1728 # 80002360 <test_physical_memory+0x13c6>
    80000ca8:	fffff097          	auipc	ra,0xfffff
    80000cac:	666080e7          	jalr	1638(ra) # 8000030e <printf>
        if (*pte & PTE_V) {
    80000cb0:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    80000cb4:	0017f713          	andi	a4,a5,1
    80000cb8:	10070e63          	beqz	a4,80000dd4 <test_pagetable+0x194>
            pt = (pagetable_t)PTE2PA(*pte);
    80000cbc:	83a9                	srli	a5,a5,0xa
    80000cbe:	07b2                	slli	a5,a5,0xc
        if (*pte & PTE_V) {
    80000cc0:	63a4                	ld	s1,64(a5)
    80000cc2:	0014f793          	andi	a5,s1,1
    80000cc6:	12078e63          	beqz	a5,80000e02 <test_pagetable+0x1c2>
            pt = (pagetable_t)PTE2PA(*pte);
    80000cca:	80a9                	srli	s1,s1,0xa
    80000ccc:	04b2                	slli	s1,s1,0xc

    // 测试地址转换
    pte_t *pte = walk_lookup(pt, va);
    assert(pte != 0 && (*pte & PTE_V));
    80000cce:	10048463          	beqz	s1,80000dd6 <test_pagetable+0x196>
    80000cd2:	609c                	ld	a5,0(s1)
    80000cd4:	8b85                	andi	a5,a5,1
    80000cd6:	10078063          	beqz	a5,80000dd6 <test_pagetable+0x196>
    assert(PTE2PA(*pte) == pa);
    80000cda:	609c                	ld	a5,0(s1)
    80000cdc:	83a9                	srli	a5,a5,0xa
    80000cde:	07b2                	slli	a5,a5,0xc
    80000ce0:	13479363          	bne	a5,s4,80000e06 <test_pagetable+0x1c6>
    printf("[PT TEST] 地址转换测试通过\n");
    80000ce4:	00001517          	auipc	a0,0x1
    80000ce8:	69c50513          	addi	a0,a0,1692 # 80002380 <test_physical_memory+0x13e6>
    80000cec:	fffff097          	auipc	ra,0xfffff
    80000cf0:	622080e7          	jalr	1570(ra) # 8000030e <printf>

    // 测试权限位
    assert(*pte & PTE_R);
    80000cf4:	609c                	ld	a5,0(s1)
    80000cf6:	8b89                	andi	a5,a5,2
    80000cf8:	12078d63          	beqz	a5,80000e32 <test_pagetable+0x1f2>
    assert(*pte & PTE_W);
    80000cfc:	609c                	ld	a5,0(s1)
    80000cfe:	8b91                	andi	a5,a5,4
    80000d00:	14078f63          	beqz	a5,80000e5e <test_pagetable+0x21e>
    assert(!(*pte & PTE_X));
    80000d04:	609c                	ld	a5,0(s1)
    80000d06:	8ba1                	andi	a5,a5,8
    80000d08:	18079163          	bnez	a5,80000e8a <test_pagetable+0x24a>
    printf("[PT TEST] 权限测试通过\n");
    80000d0c:	00001517          	auipc	a0,0x1
    80000d10:	69c50513          	addi	a0,a0,1692 # 800023a8 <test_physical_memory+0x140e>
    80000d14:	fffff097          	auipc	ra,0xfffff
    80000d18:	5fa080e7          	jalr	1530(ra) # 8000030e <printf>

    // 清理
    free_page((void*)pa);
    80000d1c:	854e                	mv	a0,s3
    80000d1e:	00000097          	auipc	ra,0x0
    80000d22:	1e6080e7          	jalr	486(ra) # 80000f04 <free_page>
    free_pagetable(pt);
    80000d26:	854a                	mv	a0,s2
    80000d28:	00000097          	auipc	ra,0x0
    80000d2c:	dde080e7          	jalr	-546(ra) # 80000b06 <free_pagetable>

    printf("[PT TEST] 所有页表测试通过\n");
    80000d30:	00001517          	auipc	a0,0x1
    80000d34:	69850513          	addi	a0,a0,1688 # 800023c8 <test_physical_memory+0x142e>
    80000d38:	fffff097          	auipc	ra,0xfffff
    80000d3c:	5d6080e7          	jalr	1494(ra) # 8000030e <printf>
    80000d40:	70a2                	ld	ra,40(sp)
    80000d42:	7402                	ld	s0,32(sp)
    80000d44:	64e2                	ld	s1,24(sp)
    80000d46:	6942                	ld	s2,16(sp)
    80000d48:	69a2                	ld	s3,8(sp)
    80000d4a:	6a02                	ld	s4,0(sp)
    80000d4c:	6145                	addi	sp,sp,48
    80000d4e:	8082                	ret
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80000d50:	4615                	li	a2,5
    80000d52:	00001597          	auipc	a1,0x1
    80000d56:	5ae58593          	addi	a1,a1,1454 # 80002300 <test_physical_memory+0x1366>
    80000d5a:	00001517          	auipc	a0,0x1
    80000d5e:	5b650513          	addi	a0,a0,1462 # 80002310 <test_physical_memory+0x1376>
    80000d62:	fffff097          	auipc	ra,0xfffff
    80000d66:	5ac080e7          	jalr	1452(ra) # 8000030e <printf>
        panic("assert");
    80000d6a:	00001517          	auipc	a0,0x1
    80000d6e:	5ce50513          	addi	a0,a0,1486 # 80002338 <test_physical_memory+0x139e>
    80000d72:	00000097          	auipc	ra,0x0
    80000d76:	c26080e7          	jalr	-986(ra) # 80000998 <panic>
    80000d7a:	bdcd                	j	80000c6c <test_pagetable+0x2c>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80000d7c:	4615                	li	a2,5
    80000d7e:	00001597          	auipc	a1,0x1
    80000d82:	58258593          	addi	a1,a1,1410 # 80002300 <test_physical_memory+0x1366>
    80000d86:	00001517          	auipc	a0,0x1
    80000d8a:	58a50513          	addi	a0,a0,1418 # 80002310 <test_physical_memory+0x1376>
    80000d8e:	fffff097          	auipc	ra,0xfffff
    80000d92:	580080e7          	jalr	1408(ra) # 8000030e <printf>
        panic("assert");
    80000d96:	00001517          	auipc	a0,0x1
    80000d9a:	5a250513          	addi	a0,a0,1442 # 80002338 <test_physical_memory+0x139e>
    80000d9e:	00000097          	auipc	ra,0x0
    80000da2:	bfa080e7          	jalr	-1030(ra) # 80000998 <panic>
    80000da6:	b5d5                	j	80000c8a <test_pagetable+0x4a>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80000da8:	4615                	li	a2,5
    80000daa:	00001597          	auipc	a1,0x1
    80000dae:	55658593          	addi	a1,a1,1366 # 80002300 <test_physical_memory+0x1366>
    80000db2:	00001517          	auipc	a0,0x1
    80000db6:	55e50513          	addi	a0,a0,1374 # 80002310 <test_physical_memory+0x1376>
    80000dba:	fffff097          	auipc	ra,0xfffff
    80000dbe:	554080e7          	jalr	1364(ra) # 8000030e <printf>
        panic("assert");
    80000dc2:	00001517          	auipc	a0,0x1
    80000dc6:	57650513          	addi	a0,a0,1398 # 80002338 <test_physical_memory+0x139e>
    80000dca:	00000097          	auipc	ra,0x0
    80000dce:	bce080e7          	jalr	-1074(ra) # 80000998 <panic>
    80000dd2:	b5f9                	j	80000ca0 <test_pagetable+0x60>
        if (*pte & PTE_V) {
    80000dd4:	4481                	li	s1,0
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80000dd6:	4615                	li	a2,5
    80000dd8:	00001597          	auipc	a1,0x1
    80000ddc:	52858593          	addi	a1,a1,1320 # 80002300 <test_physical_memory+0x1366>
    80000de0:	00001517          	auipc	a0,0x1
    80000de4:	53050513          	addi	a0,a0,1328 # 80002310 <test_physical_memory+0x1376>
    80000de8:	fffff097          	auipc	ra,0xfffff
    80000dec:	526080e7          	jalr	1318(ra) # 8000030e <printf>
        panic("assert");
    80000df0:	00001517          	auipc	a0,0x1
    80000df4:	54850513          	addi	a0,a0,1352 # 80002338 <test_physical_memory+0x139e>
    80000df8:	00000097          	auipc	ra,0x0
    80000dfc:	ba0080e7          	jalr	-1120(ra) # 80000998 <panic>
    80000e00:	bde9                	j	80000cda <test_pagetable+0x9a>
    80000e02:	4481                	li	s1,0
    80000e04:	bfc9                	j	80000dd6 <test_pagetable+0x196>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80000e06:	4615                	li	a2,5
    80000e08:	00001597          	auipc	a1,0x1
    80000e0c:	4f858593          	addi	a1,a1,1272 # 80002300 <test_physical_memory+0x1366>
    80000e10:	00001517          	auipc	a0,0x1
    80000e14:	50050513          	addi	a0,a0,1280 # 80002310 <test_physical_memory+0x1376>
    80000e18:	fffff097          	auipc	ra,0xfffff
    80000e1c:	4f6080e7          	jalr	1270(ra) # 8000030e <printf>
        panic("assert");
    80000e20:	00001517          	auipc	a0,0x1
    80000e24:	51850513          	addi	a0,a0,1304 # 80002338 <test_physical_memory+0x139e>
    80000e28:	00000097          	auipc	ra,0x0
    80000e2c:	b70080e7          	jalr	-1168(ra) # 80000998 <panic>
    80000e30:	bd55                	j	80000ce4 <test_pagetable+0xa4>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80000e32:	4615                	li	a2,5
    80000e34:	00001597          	auipc	a1,0x1
    80000e38:	4cc58593          	addi	a1,a1,1228 # 80002300 <test_physical_memory+0x1366>
    80000e3c:	00001517          	auipc	a0,0x1
    80000e40:	4d450513          	addi	a0,a0,1236 # 80002310 <test_physical_memory+0x1376>
    80000e44:	fffff097          	auipc	ra,0xfffff
    80000e48:	4ca080e7          	jalr	1226(ra) # 8000030e <printf>
        panic("assert");
    80000e4c:	00001517          	auipc	a0,0x1
    80000e50:	4ec50513          	addi	a0,a0,1260 # 80002338 <test_physical_memory+0x139e>
    80000e54:	00000097          	auipc	ra,0x0
    80000e58:	b44080e7          	jalr	-1212(ra) # 80000998 <panic>
    80000e5c:	b545                	j	80000cfc <test_pagetable+0xbc>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80000e5e:	4615                	li	a2,5
    80000e60:	00001597          	auipc	a1,0x1
    80000e64:	4a058593          	addi	a1,a1,1184 # 80002300 <test_physical_memory+0x1366>
    80000e68:	00001517          	auipc	a0,0x1
    80000e6c:	4a850513          	addi	a0,a0,1192 # 80002310 <test_physical_memory+0x1376>
    80000e70:	fffff097          	auipc	ra,0xfffff
    80000e74:	49e080e7          	jalr	1182(ra) # 8000030e <printf>
        panic("assert");
    80000e78:	00001517          	auipc	a0,0x1
    80000e7c:	4c050513          	addi	a0,a0,1216 # 80002338 <test_physical_memory+0x139e>
    80000e80:	00000097          	auipc	ra,0x0
    80000e84:	b18080e7          	jalr	-1256(ra) # 80000998 <panic>
    80000e88:	bdb5                	j	80000d04 <test_pagetable+0xc4>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80000e8a:	4615                	li	a2,5
    80000e8c:	00001597          	auipc	a1,0x1
    80000e90:	47458593          	addi	a1,a1,1140 # 80002300 <test_physical_memory+0x1366>
    80000e94:	00001517          	auipc	a0,0x1
    80000e98:	47c50513          	addi	a0,a0,1148 # 80002310 <test_physical_memory+0x1376>
    80000e9c:	fffff097          	auipc	ra,0xfffff
    80000ea0:	472080e7          	jalr	1138(ra) # 8000030e <printf>
        panic("assert");
    80000ea4:	00001517          	auipc	a0,0x1
    80000ea8:	49450513          	addi	a0,a0,1172 # 80002338 <test_physical_memory+0x139e>
    80000eac:	00000097          	auipc	ra,0x0
    80000eb0:	aec080e7          	jalr	-1300(ra) # 80000998 <panic>
    80000eb4:	bda1                	j	80000d0c <test_pagetable+0xcc>

0000000080000eb6 <alloc_page>:

void pmm_init(void) {
  freerange(end, (void*)PHYSTOP);
}

void* alloc_page(void) {
    80000eb6:	1101                	addi	sp,sp,-32
    80000eb8:	ec06                	sd	ra,24(sp)
    80000eba:	e822                	sd	s0,16(sp)
    80000ebc:	e426                	sd	s1,8(sp)
    80000ebe:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80000ec0:	00004497          	auipc	s1,0x4
    80000ec4:	1584b483          	ld	s1,344(s1) # 80005018 <freelist>
  if(r)
    80000ec8:	c48d                	beqz	s1,80000ef2 <alloc_page+0x3c>
    freelist = r->next;
    80000eca:	609c                	ld	a5,0(s1)
    80000ecc:	00004717          	auipc	a4,0x4
    80000ed0:	14f73623          	sd	a5,332(a4) # 80005018 <freelist>
  if(r)
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    80000ed4:	6605                	lui	a2,0x1
    80000ed6:	1661                	addi	a2,a2,-8 # ff8 <_entry-0x7ffff008>
    80000ed8:	4595                	li	a1,5
    80000eda:	00848513          	addi	a0,s1,8
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	aea080e7          	jalr	-1302(ra) # 800009c8 <memset>
  else
    panic("alloc_page: out of memory");
  return (void*)r;
}
    80000ee6:	8526                	mv	a0,s1
    80000ee8:	60e2                	ld	ra,24(sp)
    80000eea:	6442                	ld	s0,16(sp)
    80000eec:	64a2                	ld	s1,8(sp)
    80000eee:	6105                	addi	sp,sp,32
    80000ef0:	8082                	ret
    panic("alloc_page: out of memory");
    80000ef2:	00001517          	auipc	a0,0x1
    80000ef6:	4fe50513          	addi	a0,a0,1278 # 800023f0 <test_physical_memory+0x1456>
    80000efa:	00000097          	auipc	ra,0x0
    80000efe:	a9e080e7          	jalr	-1378(ra) # 80000998 <panic>
    80000f02:	b7d5                	j	80000ee6 <alloc_page+0x30>

0000000080000f04 <free_page>:

void free_page(void* page) {
    80000f04:	1101                	addi	sp,sp,-32
    80000f06:	ec06                	sd	ra,24(sp)
    80000f08:	e822                	sd	s0,16(sp)
    80000f0a:	e426                	sd	s1,8(sp)
    80000f0c:	1000                	addi	s0,sp,32
    80000f0e:	84aa                	mv	s1,a0
  struct run *r = (struct run*)page;
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    80000f10:	03451793          	slli	a5,a0,0x34
    80000f14:	eb99                	bnez	a5,80000f2a <free_page+0x26>
    80000f16:	00004797          	auipc	a5,0x4
    80000f1a:	1ba78793          	addi	a5,a5,442 # 800050d0 <_bss_end>
    80000f1e:	00f56663          	bltu	a0,a5,80000f2a <free_page+0x26>
    80000f22:	47c5                	li	a5,17
    80000f24:	07ee                	slli	a5,a5,0x1b
    80000f26:	00f56a63          	bltu	a0,a5,80000f3a <free_page+0x36>
    panic("free_page: invalid page address");
    80000f2a:	00001517          	auipc	a0,0x1
    80000f2e:	4e650513          	addi	a0,a0,1254 # 80002410 <test_physical_memory+0x1476>
    80000f32:	00000097          	auipc	ra,0x0
    80000f36:	a66080e7          	jalr	-1434(ra) # 80000998 <panic>
  r->next = freelist;
    80000f3a:	00004797          	auipc	a5,0x4
    80000f3e:	0de78793          	addi	a5,a5,222 # 80005018 <freelist>
    80000f42:	6398                	ld	a4,0(a5)
    80000f44:	e098                	sd	a4,0(s1)
  freelist = r;
    80000f46:	e384                	sd	s1,0(a5)
}
    80000f48:	60e2                	ld	ra,24(sp)
    80000f4a:	6442                	ld	s0,16(sp)
    80000f4c:	64a2                	ld	s1,8(sp)
    80000f4e:	6105                	addi	sp,sp,32
    80000f50:	8082                	ret

0000000080000f52 <pmm_init>:
void pmm_init(void) {
    80000f52:	7179                	addi	sp,sp,-48
    80000f54:	f406                	sd	ra,40(sp)
    80000f56:	f022                	sd	s0,32(sp)
    80000f58:	ec26                	sd	s1,24(sp)
    80000f5a:	1800                	addi	s0,sp,48
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    80000f5c:	00005497          	auipc	s1,0x5
    80000f60:	17348493          	addi	s1,s1,371 # 800060cf <_bss_end+0xfff>
    80000f64:	77fd                	lui	a5,0xfffff
    80000f66:	8cfd                	and	s1,s1,a5
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000f68:	6705                	lui	a4,0x1
    80000f6a:	9726                	add	a4,a4,s1
    80000f6c:	47c5                	li	a5,17
    80000f6e:	07ee                	slli	a5,a5,0x1b
    80000f70:	02e7e063          	bltu	a5,a4,80000f90 <pmm_init+0x3e>
    80000f74:	e84a                	sd	s2,16(sp)
    80000f76:	e44e                	sd	s3,8(sp)
    80000f78:	6985                	lui	s3,0x1
    80000f7a:	893e                	mv	s2,a5
    free_page(p);
    80000f7c:	8526                	mv	a0,s1
    80000f7e:	00000097          	auipc	ra,0x0
    80000f82:	f86080e7          	jalr	-122(ra) # 80000f04 <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000f86:	94ce                	add	s1,s1,s3
    80000f88:	ff249ae3          	bne	s1,s2,80000f7c <pmm_init+0x2a>
    80000f8c:	6942                	ld	s2,16(sp)
    80000f8e:	69a2                	ld	s3,8(sp)
}
    80000f90:	70a2                	ld	ra,40(sp)
    80000f92:	7402                	ld	s0,32(sp)
    80000f94:	64e2                	ld	s1,24(sp)
    80000f96:	6145                	addi	sp,sp,48
    80000f98:	8082                	ret

0000000080000f9a <test_physical_memory>:

void test_physical_memory(void) {
    80000f9a:	1101                	addi	sp,sp,-32
    80000f9c:	ec06                	sd	ra,24(sp)
    80000f9e:	e822                	sd	s0,16(sp)
    80000fa0:	e426                	sd	s1,8(sp)
    80000fa2:	e04a                	sd	s2,0(sp)
    80000fa4:	1000                	addi	s0,sp,32
    printf("[PM TEST] 分配两个页...\n");
    80000fa6:	00001517          	auipc	a0,0x1
    80000faa:	48a50513          	addi	a0,a0,1162 # 80002430 <test_physical_memory+0x1496>
    80000fae:	fffff097          	auipc	ra,0xfffff
    80000fb2:	360080e7          	jalr	864(ra) # 8000030e <printf>
    void *page1 = alloc_page();
    80000fb6:	00000097          	auipc	ra,0x0
    80000fba:	f00080e7          	jalr	-256(ra) # 80000eb6 <alloc_page>
    80000fbe:	84aa                	mv	s1,a0
    void *page2 = alloc_page();
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	ef6080e7          	jalr	-266(ra) # 80000eb6 <alloc_page>
    80000fc8:	892a                	mv	s2,a0
    if (!expr) {
    80000fca:	cccd                	beqz	s1,80001084 <test_physical_memory+0xea>
    80000fcc:	c17d                	beqz	a0,800010b2 <test_physical_memory+0x118>
    80000fce:	11248863          	beq	s1,s2,800010de <test_physical_memory+0x144>
    assert(page1 != 0);
    assert(page2 != 0);
    assert(page1 != page2);
    assert(((uint64)page1 & 0xFFF) == 0);
    80000fd2:	03449793          	slli	a5,s1,0x34
    80000fd6:	12079a63          	bnez	a5,8000110a <test_physical_memory+0x170>
    assert(((uint64)page2 & 0xFFF) == 0);
    80000fda:	03491793          	slli	a5,s2,0x34
    80000fde:	14079c63          	bnez	a5,80001136 <test_physical_memory+0x19c>
    printf("[PM TEST] 分配测试通过\n");
    80000fe2:	00001517          	auipc	a0,0x1
    80000fe6:	46e50513          	addi	a0,a0,1134 # 80002450 <test_physical_memory+0x14b6>
    80000fea:	fffff097          	auipc	ra,0xfffff
    80000fee:	324080e7          	jalr	804(ra) # 8000030e <printf>

    printf("[PM TEST] 数据写入测试...\n");
    80000ff2:	00001517          	auipc	a0,0x1
    80000ff6:	47e50513          	addi	a0,a0,1150 # 80002470 <test_physical_memory+0x14d6>
    80000ffa:	fffff097          	auipc	ra,0xfffff
    80000ffe:	314080e7          	jalr	788(ra) # 8000030e <printf>
    *(int*)page1 = 0x12345678;
    80001002:	123457b7          	lui	a5,0x12345
    80001006:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6dcba988>
    8000100a:	c09c                	sw	a5,0(s1)
    assert(*(int*)page1 == 0x12345678);
    printf("[PM TEST] 数据写入测试通过\n");
    8000100c:	00001517          	auipc	a0,0x1
    80001010:	48c50513          	addi	a0,a0,1164 # 80002498 <test_physical_memory+0x14fe>
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	2fa080e7          	jalr	762(ra) # 8000030e <printf>

    printf("[PM TEST] 释放与重新分配测试...\n");
    8000101c:	00001517          	auipc	a0,0x1
    80001020:	4a450513          	addi	a0,a0,1188 # 800024c0 <test_physical_memory+0x1526>
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	2ea080e7          	jalr	746(ra) # 8000030e <printf>
    free_page(page1);
    8000102c:	8526                	mv	a0,s1
    8000102e:	00000097          	auipc	ra,0x0
    80001032:	ed6080e7          	jalr	-298(ra) # 80000f04 <free_page>
    void *page3 = alloc_page();
    80001036:	00000097          	auipc	ra,0x0
    8000103a:	e80080e7          	jalr	-384(ra) # 80000eb6 <alloc_page>
    8000103e:	84aa                	mv	s1,a0
    80001040:	12050163          	beqz	a0,80001162 <test_physical_memory+0x1c8>
    assert(page3 != 0);
    printf("[PM TEST] 释放与重新分配测试通过\n");
    80001044:	00001517          	auipc	a0,0x1
    80001048:	4ac50513          	addi	a0,a0,1196 # 800024f0 <test_physical_memory+0x1556>
    8000104c:	fffff097          	auipc	ra,0xfffff
    80001050:	2c2080e7          	jalr	706(ra) # 8000030e <printf>

    free_page(page2);
    80001054:	854a                	mv	a0,s2
    80001056:	00000097          	auipc	ra,0x0
    8000105a:	eae080e7          	jalr	-338(ra) # 80000f04 <free_page>
    free_page(page3);
    8000105e:	8526                	mv	a0,s1
    80001060:	00000097          	auipc	ra,0x0
    80001064:	ea4080e7          	jalr	-348(ra) # 80000f04 <free_page>

    printf("[PM TEST] 所有物理内存管理测试通过\n");
    80001068:	00001517          	auipc	a0,0x1
    8000106c:	4b850513          	addi	a0,a0,1208 # 80002520 <test_physical_memory+0x1586>
    80001070:	fffff097          	auipc	ra,0xfffff
    80001074:	29e080e7          	jalr	670(ra) # 8000030e <printf>
    80001078:	60e2                	ld	ra,24(sp)
    8000107a:	6442                	ld	s0,16(sp)
    8000107c:	64a2                	ld	s1,8(sp)
    8000107e:	6902                	ld	s2,0(sp)
    80001080:	6105                	addi	sp,sp,32
    80001082:	8082                	ret
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80001084:	4615                	li	a2,5
    80001086:	00001597          	auipc	a1,0x1
    8000108a:	27a58593          	addi	a1,a1,634 # 80002300 <test_physical_memory+0x1366>
    8000108e:	00001517          	auipc	a0,0x1
    80001092:	28250513          	addi	a0,a0,642 # 80002310 <test_physical_memory+0x1376>
    80001096:	fffff097          	auipc	ra,0xfffff
    8000109a:	278080e7          	jalr	632(ra) # 8000030e <printf>
        panic("assert");
    8000109e:	00001517          	auipc	a0,0x1
    800010a2:	29a50513          	addi	a0,a0,666 # 80002338 <test_physical_memory+0x139e>
    800010a6:	00000097          	auipc	ra,0x0
    800010aa:	8f2080e7          	jalr	-1806(ra) # 80000998 <panic>
    if (!expr) {
    800010ae:	f20916e3          	bnez	s2,80000fda <test_physical_memory+0x40>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    800010b2:	4615                	li	a2,5
    800010b4:	00001597          	auipc	a1,0x1
    800010b8:	24c58593          	addi	a1,a1,588 # 80002300 <test_physical_memory+0x1366>
    800010bc:	00001517          	auipc	a0,0x1
    800010c0:	25450513          	addi	a0,a0,596 # 80002310 <test_physical_memory+0x1376>
    800010c4:	fffff097          	auipc	ra,0xfffff
    800010c8:	24a080e7          	jalr	586(ra) # 8000030e <printf>
        panic("assert");
    800010cc:	00001517          	auipc	a0,0x1
    800010d0:	26c50513          	addi	a0,a0,620 # 80002338 <test_physical_memory+0x139e>
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	8c4080e7          	jalr	-1852(ra) # 80000998 <panic>
    800010dc:	bdcd                	j	80000fce <test_physical_memory+0x34>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    800010de:	4615                	li	a2,5
    800010e0:	00001597          	auipc	a1,0x1
    800010e4:	22058593          	addi	a1,a1,544 # 80002300 <test_physical_memory+0x1366>
    800010e8:	00001517          	auipc	a0,0x1
    800010ec:	22850513          	addi	a0,a0,552 # 80002310 <test_physical_memory+0x1376>
    800010f0:	fffff097          	auipc	ra,0xfffff
    800010f4:	21e080e7          	jalr	542(ra) # 8000030e <printf>
        panic("assert");
    800010f8:	00001517          	auipc	a0,0x1
    800010fc:	24050513          	addi	a0,a0,576 # 80002338 <test_physical_memory+0x139e>
    80001100:	00000097          	auipc	ra,0x0
    80001104:	898080e7          	jalr	-1896(ra) # 80000998 <panic>
    80001108:	b5e9                	j	80000fd2 <test_physical_memory+0x38>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    8000110a:	4615                	li	a2,5
    8000110c:	00001597          	auipc	a1,0x1
    80001110:	1f458593          	addi	a1,a1,500 # 80002300 <test_physical_memory+0x1366>
    80001114:	00001517          	auipc	a0,0x1
    80001118:	1fc50513          	addi	a0,a0,508 # 80002310 <test_physical_memory+0x1376>
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	1f2080e7          	jalr	498(ra) # 8000030e <printf>
        panic("assert");
    80001124:	00001517          	auipc	a0,0x1
    80001128:	21450513          	addi	a0,a0,532 # 80002338 <test_physical_memory+0x139e>
    8000112c:	00000097          	auipc	ra,0x0
    80001130:	86c080e7          	jalr	-1940(ra) # 80000998 <panic>
    80001134:	b55d                	j	80000fda <test_physical_memory+0x40>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80001136:	4615                	li	a2,5
    80001138:	00001597          	auipc	a1,0x1
    8000113c:	1c858593          	addi	a1,a1,456 # 80002300 <test_physical_memory+0x1366>
    80001140:	00001517          	auipc	a0,0x1
    80001144:	1d050513          	addi	a0,a0,464 # 80002310 <test_physical_memory+0x1376>
    80001148:	fffff097          	auipc	ra,0xfffff
    8000114c:	1c6080e7          	jalr	454(ra) # 8000030e <printf>
        panic("assert");
    80001150:	00001517          	auipc	a0,0x1
    80001154:	1e850513          	addi	a0,a0,488 # 80002338 <test_physical_memory+0x139e>
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	840080e7          	jalr	-1984(ra) # 80000998 <panic>
    80001160:	b549                	j	80000fe2 <test_physical_memory+0x48>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80001162:	4615                	li	a2,5
    80001164:	00001597          	auipc	a1,0x1
    80001168:	19c58593          	addi	a1,a1,412 # 80002300 <test_physical_memory+0x1366>
    8000116c:	00001517          	auipc	a0,0x1
    80001170:	1a450513          	addi	a0,a0,420 # 80002310 <test_physical_memory+0x1376>
    80001174:	fffff097          	auipc	ra,0xfffff
    80001178:	19a080e7          	jalr	410(ra) # 8000030e <printf>
        panic("assert");
    8000117c:	00001517          	auipc	a0,0x1
    80001180:	1bc50513          	addi	a0,a0,444 # 80002338 <test_physical_memory+0x139e>
    80001184:	00000097          	auipc	ra,0x0
    80001188:	814080e7          	jalr	-2028(ra) # 80000998 <panic>
    8000118c:	bd65                	j	80001044 <test_physical_memory+0xaa>
	...
