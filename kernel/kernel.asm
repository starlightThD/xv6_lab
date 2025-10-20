
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
    8000003e:	5d0080e7          	jalr	1488(ra) # 8000160a <pmm_init>
	// 虚拟内存
	printf("[VP TEST] 尝试启用分页模式\n");
    80000042:	00002517          	auipc	a0,0x2
    80000046:	fbe50513          	addi	a0,a0,-66 # 80002000 <test_physical_memory+0x9ae>
    8000004a:	00000097          	auipc	ra,0x0
    8000004e:	2e4080e7          	jalr	740(ra) # 8000032e <printf>
	kvminit();
    80000052:	00001097          	auipc	ra,0x1
    80000056:	1b2080e7          	jalr	434(ra) # 80001204 <kvminit>
    kvminithart();
    8000005a:	00001097          	auipc	ra,0x1
    8000005e:	254080e7          	jalr	596(ra) # 800012ae <kvminithart>

    // 进入操作系统后立即清屏
    clear_screen();
    80000062:	00000097          	auipc	ra,0x0
    80000066:	4ee080e7          	jalr	1262(ra) # 80000550 <clear_screen>
    // 输出操作系统启动横幅
    uart_puts("===============================================\n");
    8000006a:	00002517          	auipc	a0,0x2
    8000006e:	fbe50513          	addi	a0,a0,-66 # 80002028 <test_physical_memory+0x9d6>
    80000072:	00000097          	auipc	ra,0x0
    80000076:	116080e7          	jalr	278(ra) # 80000188 <uart_puts>
    uart_puts("        RISC-V Operating System v1.0         \n");
    8000007a:	00002517          	auipc	a0,0x2
    8000007e:	fe650513          	addi	a0,a0,-26 # 80002060 <test_physical_memory+0xa0e>
    80000082:	00000097          	auipc	ra,0x0
    80000086:	106080e7          	jalr	262(ra) # 80000188 <uart_puts>
    uart_puts("===============================================\n\n");
    8000008a:	00002517          	auipc	a0,0x2
    8000008e:	00650513          	addi	a0,a0,6 # 80002090 <test_physical_memory+0xa3e>
    80000092:	00000097          	auipc	ra,0x0
    80000096:	0f6080e7          	jalr	246(ra) # 80000188 <uart_puts>
    printf("[VP TEST] 当前已启用分页模式\n");
    8000009a:	00002517          	auipc	a0,0x2
    8000009e:	02e50513          	addi	a0,a0,46 # 800020c8 <test_physical_memory+0xa76>
    800000a2:	00000097          	auipc	ra,0x0
    800000a6:	28c080e7          	jalr	652(ra) # 8000032e <printf>
    // 验证BSS段是否被正确清零
    uart_puts("Testing BSS zero initialization:\n");
    800000aa:	00002517          	auipc	a0,0x2
    800000ae:	04650513          	addi	a0,a0,70 # 800020f0 <test_physical_memory+0xa9e>
    800000b2:	00000097          	auipc	ra,0x0
    800000b6:	0d6080e7          	jalr	214(ra) # 80000188 <uart_puts>
    if (global_test1 == 0 && global_test2 == 0) {
    800000ba:	00005797          	auipc	a5,0x5
    800000be:	f4a7a783          	lw	a5,-182(a5) # 80005004 <global_test1>
    800000c2:	00005717          	auipc	a4,0x5
    800000c6:	f3e72703          	lw	a4,-194(a4) # 80005000 <global_test2>
    800000ca:	8fd9                	or	a5,a5,a4
    800000cc:	cbb5                	beqz	a5,80000140 <start+0x10e>
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    } else {
        uart_puts("  [ERROR] BSS variables not zeroed!\n");
    800000ce:	00002517          	auipc	a0,0x2
    800000d2:	07250513          	addi	a0,a0,114 # 80002140 <test_physical_memory+0xaee>
    800000d6:	00000097          	auipc	ra,0x0
    800000da:	0b2080e7          	jalr	178(ra) # 80000188 <uart_puts>
    }
    
    // 验证初始化变量
    if (initialized_global == 123) {
    800000de:	00003717          	auipc	a4,0x3
    800000e2:	f2272703          	lw	a4,-222(a4) # 80003000 <initialized_global>
    800000e6:	07b00793          	li	a5,123
    800000ea:	06f70463          	beq	a4,a5,80000152 <start+0x120>
        uart_puts("  [OK] Initialized variables working\n");
    } else {
        uart_puts("  [ERROR] Initialized variables corrupted!\n");
    800000ee:	00002517          	auipc	a0,0x2
    800000f2:	0a250513          	addi	a0,a0,162 # 80002190 <test_physical_memory+0xb3e>
    800000f6:	00000097          	auipc	ra,0x0
    800000fa:	092080e7          	jalr	146(ra) # 80000188 <uart_puts>
    }
    test_physical_memory();
    800000fe:	00001097          	auipc	ra,0x1
    80000102:	554080e7          	jalr	1364(ra) # 80001652 <test_physical_memory>
	test_pagetable();
    80000106:	00001097          	auipc	ra,0x1
    8000010a:	1d0080e7          	jalr	464(ra) # 800012d6 <test_pagetable>
    uart_puts("\nSystem ready. Entering main loop...\n");
    8000010e:	00002517          	auipc	a0,0x2
    80000112:	0b250513          	addi	a0,a0,178 # 800021c0 <test_physical_memory+0xb6e>
    80000116:	00000097          	auipc	ra,0x0
    8000011a:	072080e7          	jalr	114(ra) # 80000188 <uart_puts>
    test_printf_precision();
    8000011e:	00001097          	auipc	ra,0x1
    80000122:	8ca080e7          	jalr	-1846(ra) # 800009e8 <test_printf_precision>
	test_curse_move();
    80000126:	00001097          	auipc	ra,0x1
    8000012a:	bb4080e7          	jalr	-1100(ra) # 80000cda <test_curse_move>
	test_basic_colors();
    8000012e:	00001097          	auipc	ra,0x1
    80000132:	c94080e7          	jalr	-876(ra) # 80000dc2 <test_basic_colors>
	clear_screen();
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	41a080e7          	jalr	1050(ra) # 80000550 <clear_screen>
    // 主循环
    while(1) {
    8000013e:	a001                	j	8000013e <start+0x10c>
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    80000140:	00002517          	auipc	a0,0x2
    80000144:	fd850513          	addi	a0,a0,-40 # 80002118 <test_physical_memory+0xac6>
    80000148:	00000097          	auipc	ra,0x0
    8000014c:	040080e7          	jalr	64(ra) # 80000188 <uart_puts>
    80000150:	b779                	j	800000de <start+0xac>
        uart_puts("  [OK] Initialized variables working\n");
    80000152:	00002517          	auipc	a0,0x2
    80000156:	01650513          	addi	a0,a0,22 # 80002168 <test_physical_memory+0xb16>
    8000015a:	00000097          	auipc	ra,0x0
    8000015e:	02e080e7          	jalr	46(ra) # 80000188 <uart_puts>
    80000162:	bf71                	j	800000fe <start+0xcc>

0000000080000164 <uart_putc>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))


void uart_putc(char c)
{
    80000164:	1141                	addi	sp,sp,-16
    80000166:	e422                	sd	s0,8(sp)
    80000168:	0800                	addi	s0,sp,16
  // 等待发送缓冲区空闲
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000016a:	10000737          	lui	a4,0x10000
    8000016e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000170:	00074783          	lbu	a5,0(a4)
    80000174:	0207f793          	andi	a5,a5,32
    80000178:	dfe5                	beqz	a5,80000170 <uart_putc+0xc>
    ;
  // 写入字符到发送寄存器
  WriteReg(THR, c);
    8000017a:	100007b7          	lui	a5,0x10000
    8000017e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    80000182:	6422                	ld	s0,8(sp)
    80000184:	0141                	addi	sp,sp,16
    80000186:	8082                	ret

0000000080000188 <uart_puts>:

// 成功后实现字符串输出
void uart_puts(char *s)
{
    80000188:	1141                	addi	sp,sp,-16
    8000018a:	e422                	sd	s0,8(sp)
    8000018c:	0800                	addi	s0,sp,16
    if (!s) return;
    8000018e:	cd15                	beqz	a0,800001ca <uart_puts+0x42>
    
    while (*s) {
    80000190:	00054783          	lbu	a5,0(a0)
    80000194:	cb9d                	beqz	a5,800001ca <uart_puts+0x42>
        // 批量检查：一次等待，发送多个字符
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000196:	10000737          	lui	a4,0x10000
    8000019a:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
            ;
            
        // 连续发送字符，直到缓冲区可能满或字符串结束
        int sent_count = 0;
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
            WriteReg(THR, *s);
    8000019c:	10000637          	lui	a2,0x10000
    800001a0:	a011                	j	800001a4 <uart_puts+0x1c>
    while (*s) {
    800001a2:	c785                	beqz	a5,800001ca <uart_puts+0x42>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800001a4:	00074783          	lbu	a5,0(a4)
    800001a8:	0207f793          	andi	a5,a5,32
    800001ac:	dfe5                	beqz	a5,800001a4 <uart_puts+0x1c>
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    800001ae:	00054783          	lbu	a5,0(a0)
    800001b2:	cf81                	beqz	a5,800001ca <uart_puts+0x42>
    800001b4:	00450693          	addi	a3,a0,4
            WriteReg(THR, *s);
    800001b8:	00f60023          	sb	a5,0(a2) # 10000000 <_entry-0x70000000>
            s++;
    800001bc:	0505                	addi	a0,a0,1
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    800001be:	00054783          	lbu	a5,0(a0)
    800001c2:	c781                	beqz	a5,800001ca <uart_puts+0x42>
    800001c4:	fea69ae3          	bne	a3,a0,800001b8 <uart_puts+0x30>
    800001c8:	bfe9                	j	800001a2 <uart_puts+0x1a>
            sent_count++;
        }
    }
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret

00000000800001d0 <printint>:
static void consputs(const char *s){
	char *str = (char *)s;
	// 直接调用uart_puts输出字符串
	uart_puts(str);
}
static void printint(long long xx,int base,int sign){
    800001d0:	7139                	addi	sp,sp,-64
    800001d2:	fc06                	sd	ra,56(sp)
    800001d4:	f822                	sd	s0,48(sp)
    800001d6:	0080                	addi	s0,sp,64
	// 模仿xv6的printint
	static char digits[] = "0123456789abcdef";
	char buf[20]; // 增大缓冲区以处理64位整数
	int i;
	unsigned long long x;
	if (sign && (sign = xx < 0)) // 符号处理
    800001d8:	c219                	beqz	a2,800001de <printint+0xe>
    800001da:	08054563          	bltz	a0,80000264 <printint+0x94>
		x = -(unsigned long long)xx; // 强制转换以避免溢出
	else
		x = xx;
    800001de:	4881                	li	a7,0

	if (base == 10 && x < 100) {
    800001e0:	47a9                	li	a5,10
    800001e2:	08f58563          	beq	a1,a5,8000026c <printint+0x9c>
		x = xx;
    800001e6:	fc840693          	addi	a3,s0,-56
    800001ea:	4781                	li	a5,0
		consputs(small_numbers[x]);
		return;
	}
	i = 0;
	do{
		buf[i] = digits[x % base];
    800001ec:	00003617          	auipc	a2,0x3
    800001f0:	adc60613          	addi	a2,a2,-1316 # 80002cc8 <small_numbers>
    800001f4:	02b57733          	remu	a4,a0,a1
    800001f8:	9732                	add	a4,a4,a2
    800001fa:	19074703          	lbu	a4,400(a4)
    800001fe:	00e68023          	sb	a4,0(a3)
		i++;
    80000202:	883e                	mv	a6,a5
    80000204:	2785                	addiw	a5,a5,1
	}while((x/=base) !=0);
    80000206:	872a                	mv	a4,a0
    80000208:	02b55533          	divu	a0,a0,a1
    8000020c:	0685                	addi	a3,a3,1
    8000020e:	feb773e3          	bgeu	a4,a1,800001f4 <printint+0x24>
	if (sign){
    80000212:	00088a63          	beqz	a7,80000226 <printint+0x56>
		buf[i] = '-';
    80000216:	1781                	addi	a5,a5,-32
    80000218:	97a2                	add	a5,a5,s0
    8000021a:	02d00713          	li	a4,45
    8000021e:	fee78423          	sb	a4,-24(a5)
		i++;
    80000222:	0028079b          	addiw	a5,a6,2
	}
	i--;
	while( i>=0){
    80000226:	02f05b63          	blez	a5,8000025c <printint+0x8c>
    8000022a:	f426                	sd	s1,40(sp)
    8000022c:	f04a                	sd	s2,32(sp)
    8000022e:	fc840713          	addi	a4,s0,-56
    80000232:	00f704b3          	add	s1,a4,a5
    80000236:	fff70913          	addi	s2,a4,-1
    8000023a:	993e                	add	s2,s2,a5
    8000023c:	37fd                	addiw	a5,a5,-1
    8000023e:	1782                	slli	a5,a5,0x20
    80000240:	9381                	srli	a5,a5,0x20
    80000242:	40f90933          	sub	s2,s2,a5
	uart_putc(c);
    80000246:	fff4c503          	lbu	a0,-1(s1)
    8000024a:	00000097          	auipc	ra,0x0
    8000024e:	f1a080e7          	jalr	-230(ra) # 80000164 <uart_putc>
	while( i>=0){
    80000252:	14fd                	addi	s1,s1,-1
    80000254:	ff2499e3          	bne	s1,s2,80000246 <printint+0x76>
    80000258:	74a2                	ld	s1,40(sp)
    8000025a:	7902                	ld	s2,32(sp)
		consputc(buf[i]);
		i--;
	}
}
    8000025c:	70e2                	ld	ra,56(sp)
    8000025e:	7442                	ld	s0,48(sp)
    80000260:	6121                	addi	sp,sp,64
    80000262:	8082                	ret
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    80000264:	40a00533          	neg	a0,a0
	if (sign && (sign = xx < 0)) // 符号处理
    80000268:	4885                	li	a7,1
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    8000026a:	bf9d                	j	800001e0 <printint+0x10>
	if (base == 10 && x < 100) {
    8000026c:	06300793          	li	a5,99
    80000270:	f6a7ebe3          	bltu	a5,a0,800001e6 <printint+0x16>
		consputs(small_numbers[x]);
    80000274:	050a                	slli	a0,a0,0x2
	uart_puts(str);
    80000276:	00003797          	auipc	a5,0x3
    8000027a:	a5278793          	addi	a5,a5,-1454 # 80002cc8 <small_numbers>
    8000027e:	953e                	add	a0,a0,a5
    80000280:	00000097          	auipc	ra,0x0
    80000284:	f08080e7          	jalr	-248(ra) # 80000188 <uart_puts>
		return;
    80000288:	bfd1                	j	8000025c <printint+0x8c>

000000008000028a <flush_printf_buffer>:
	if (printf_buf_pos > 0) {
    8000028a:	00005797          	auipc	a5,0x5
    8000028e:	d7e7a783          	lw	a5,-642(a5) # 80005008 <printf_buf_pos>
    80000292:	00f04363          	bgtz	a5,80000298 <flush_printf_buffer+0xe>
    80000296:	8082                	ret
static void flush_printf_buffer(void) {
    80000298:	1141                	addi	sp,sp,-16
    8000029a:	e406                	sd	ra,8(sp)
    8000029c:	e022                	sd	s0,0(sp)
    8000029e:	0800                	addi	s0,sp,16
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    800002a0:	00005517          	auipc	a0,0x5
    800002a4:	da850513          	addi	a0,a0,-600 # 80005048 <printf_buffer>
    800002a8:	97aa                	add	a5,a5,a0
    800002aa:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	eda080e7          	jalr	-294(ra) # 80000188 <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    800002b6:	00005797          	auipc	a5,0x5
    800002ba:	d407a923          	sw	zero,-686(a5) # 80005008 <printf_buf_pos>
}
    800002be:	60a2                	ld	ra,8(sp)
    800002c0:	6402                	ld	s0,0(sp)
    800002c2:	0141                	addi	sp,sp,16
    800002c4:	8082                	ret

00000000800002c6 <buffer_char>:
static void buffer_char(char c) {
    800002c6:	1101                	addi	sp,sp,-32
    800002c8:	ec06                	sd	ra,24(sp)
    800002ca:	e822                	sd	s0,16(sp)
    800002cc:	e426                	sd	s1,8(sp)
    800002ce:	1000                	addi	s0,sp,32
    800002d0:	84aa                	mv	s1,a0
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    800002d2:	00005797          	auipc	a5,0x5
    800002d6:	d367a783          	lw	a5,-714(a5) # 80005008 <printf_buf_pos>
    800002da:	07e00713          	li	a4,126
    800002de:	02f74463          	blt	a4,a5,80000306 <buffer_char+0x40>
		printf_buffer[printf_buf_pos++] = c;
    800002e2:	0017871b          	addiw	a4,a5,1
    800002e6:	00005697          	auipc	a3,0x5
    800002ea:	d2e6a123          	sw	a4,-734(a3) # 80005008 <printf_buf_pos>
    800002ee:	00005717          	auipc	a4,0x5
    800002f2:	d5a70713          	addi	a4,a4,-678 # 80005048 <printf_buffer>
    800002f6:	97ba                	add	a5,a5,a4
    800002f8:	00a78023          	sb	a0,0(a5)
}
    800002fc:	60e2                	ld	ra,24(sp)
    800002fe:	6442                	ld	s0,16(sp)
    80000300:	64a2                	ld	s1,8(sp)
    80000302:	6105                	addi	sp,sp,32
    80000304:	8082                	ret
		flush_printf_buffer(); // Buffer full, flush it
    80000306:	00000097          	auipc	ra,0x0
    8000030a:	f84080e7          	jalr	-124(ra) # 8000028a <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    8000030e:	00005797          	auipc	a5,0x5
    80000312:	cfa78793          	addi	a5,a5,-774 # 80005008 <printf_buf_pos>
    80000316:	4398                	lw	a4,0(a5)
    80000318:	0017069b          	addiw	a3,a4,1
    8000031c:	c394                	sw	a3,0(a5)
    8000031e:	00005797          	auipc	a5,0x5
    80000322:	d2a78793          	addi	a5,a5,-726 # 80005048 <printf_buffer>
    80000326:	97ba                	add	a5,a5,a4
    80000328:	00978023          	sb	s1,0(a5)
}
    8000032c:	bfc1                	j	800002fc <buffer_char+0x36>

000000008000032e <printf>:
void printf(const char *fmt, ...) {
    8000032e:	7135                	addi	sp,sp,-160
    80000330:	ec86                	sd	ra,88(sp)
    80000332:	e8a2                	sd	s0,80(sp)
    80000334:	e0ca                	sd	s2,64(sp)
    80000336:	1080                	addi	s0,sp,96
    80000338:	892a                	mv	s2,a0
    8000033a:	e40c                	sd	a1,8(s0)
    8000033c:	e810                	sd	a2,16(s0)
    8000033e:	ec14                	sd	a3,24(s0)
    80000340:	f018                	sd	a4,32(s0)
    80000342:	f41c                	sd	a5,40(s0)
    80000344:	03043823          	sd	a6,48(s0)
    80000348:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    8000034c:	00840793          	addi	a5,s0,8
    80000350:	faf43c23          	sd	a5,-72(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000354:	00054503          	lbu	a0,0(a0)
    80000358:	1c050d63          	beqz	a0,80000532 <printf+0x204>
    8000035c:	e4a6                	sd	s1,72(sp)
    8000035e:	fc4e                	sd	s3,56(sp)
    80000360:	f852                	sd	s4,48(sp)
    80000362:	f456                	sd	s5,40(sp)
    80000364:	f05a                	sd	s6,32(sp)
    80000366:	0005079b          	sext.w	a5,a0
    8000036a:	4481                	li	s1,0
        if(c != '%'){
    8000036c:	02500993          	li	s3,37
        }
		flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
        c = fmt[++i] & 0xff;
        if(c == 0)
            break;
        switch(c){
    80000370:	4a59                	li	s4,22
    80000372:	00003a97          	auipc	s5,0x3
    80000376:	8f6a8a93          	addi	s5,s5,-1802 # 80002c68 <test_physical_memory+0x1616>
    8000037a:	a831                	j	80000396 <printf+0x68>
            buffer_char(c);
    8000037c:	00000097          	auipc	ra,0x0
    80000380:	f4a080e7          	jalr	-182(ra) # 800002c6 <buffer_char>
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000384:	2485                	addiw	s1,s1,1
    80000386:	009907b3          	add	a5,s2,s1
    8000038a:	0007c503          	lbu	a0,0(a5)
    8000038e:	0005079b          	sext.w	a5,a0
    80000392:	18050b63          	beqz	a0,80000528 <printf+0x1fa>
        if(c != '%'){
    80000396:	ff3793e3          	bne	a5,s3,8000037c <printf+0x4e>
		flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    8000039a:	00000097          	auipc	ra,0x0
    8000039e:	ef0080e7          	jalr	-272(ra) # 8000028a <flush_printf_buffer>
        c = fmt[++i] & 0xff;
    800003a2:	2485                	addiw	s1,s1,1
    800003a4:	009907b3          	add	a5,s2,s1
    800003a8:	0007cb03          	lbu	s6,0(a5)
        if(c == 0)
    800003ac:	180b0c63          	beqz	s6,80000544 <printf+0x216>
        switch(c){
    800003b0:	153b0963          	beq	s6,s3,80000502 <printf+0x1d4>
    800003b4:	f9eb079b          	addiw	a5,s6,-98
    800003b8:	0ff7f793          	zext.b	a5,a5
    800003bc:	14fa6a63          	bltu	s4,a5,80000510 <printf+0x1e2>
    800003c0:	f9eb079b          	addiw	a5,s6,-98
    800003c4:	0ff7f713          	zext.b	a4,a5
    800003c8:	14ea6463          	bltu	s4,a4,80000510 <printf+0x1e2>
    800003cc:	00271793          	slli	a5,a4,0x2
    800003d0:	97d6                	add	a5,a5,s5
    800003d2:	439c                	lw	a5,0(a5)
    800003d4:	97d6                	add	a5,a5,s5
    800003d6:	8782                	jr	a5
        case 'd':
            printint(va_arg(ap, int), 10, 1);
    800003d8:	fb843783          	ld	a5,-72(s0)
    800003dc:	00878713          	addi	a4,a5,8
    800003e0:	fae43c23          	sd	a4,-72(s0)
    800003e4:	4605                	li	a2,1
    800003e6:	45a9                	li	a1,10
    800003e8:	4388                	lw	a0,0(a5)
    800003ea:	00000097          	auipc	ra,0x0
    800003ee:	de6080e7          	jalr	-538(ra) # 800001d0 <printint>
            break;
    800003f2:	bf49                	j	80000384 <printf+0x56>
        case 'x':
            printint(va_arg(ap, int), 16, 0);
    800003f4:	fb843783          	ld	a5,-72(s0)
    800003f8:	00878713          	addi	a4,a5,8
    800003fc:	fae43c23          	sd	a4,-72(s0)
    80000400:	4601                	li	a2,0
    80000402:	45c1                	li	a1,16
    80000404:	4388                	lw	a0,0(a5)
    80000406:	00000097          	auipc	ra,0x0
    8000040a:	dca080e7          	jalr	-566(ra) # 800001d0 <printint>
            break;
    8000040e:	bf9d                	j	80000384 <printf+0x56>
        case 'u':
            printint(va_arg(ap, unsigned int), 10, 0);
    80000410:	fb843783          	ld	a5,-72(s0)
    80000414:	00878713          	addi	a4,a5,8
    80000418:	fae43c23          	sd	a4,-72(s0)
    8000041c:	4601                	li	a2,0
    8000041e:	45a9                	li	a1,10
    80000420:	0007e503          	lwu	a0,0(a5)
    80000424:	00000097          	auipc	ra,0x0
    80000428:	dac080e7          	jalr	-596(ra) # 800001d0 <printint>
            break;
    8000042c:	bfa1                	j	80000384 <printf+0x56>
        case 'c':
            consputc(va_arg(ap, int));
    8000042e:	fb843783          	ld	a5,-72(s0)
    80000432:	00878713          	addi	a4,a5,8
    80000436:	fae43c23          	sd	a4,-72(s0)
	uart_putc(c);
    8000043a:	0007c503          	lbu	a0,0(a5)
    8000043e:	00000097          	auipc	ra,0x0
    80000442:	d26080e7          	jalr	-730(ra) # 80000164 <uart_putc>
}
    80000446:	bf3d                	j	80000384 <printf+0x56>
            break;
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80000448:	fb843783          	ld	a5,-72(s0)
    8000044c:	00878713          	addi	a4,a5,8
    80000450:	fae43c23          	sd	a4,-72(s0)
    80000454:	6388                	ld	a0,0(a5)
    80000456:	c511                	beqz	a0,80000462 <printf+0x134>
	uart_puts(str);
    80000458:	00000097          	auipc	ra,0x0
    8000045c:	d30080e7          	jalr	-720(ra) # 80000188 <uart_puts>
}
    80000460:	b715                	j	80000384 <printf+0x56>
                s = "(null)";
    80000462:	00002517          	auipc	a0,0x2
    80000466:	d8650513          	addi	a0,a0,-634 # 800021e8 <test_physical_memory+0xb96>
    8000046a:	b7fd                	j	80000458 <printf+0x12a>
            consputs(s);
            break;
		case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    8000046c:	fb843783          	ld	a5,-72(s0)
    80000470:	00878713          	addi	a4,a5,8
    80000474:	fae43c23          	sd	a4,-72(s0)
    80000478:	0007bb03          	ld	s6,0(a5)
	uart_puts(str);
    8000047c:	00002517          	auipc	a0,0x2
    80000480:	d7450513          	addi	a0,a0,-652 # 800021f0 <test_physical_memory+0xb9e>
    80000484:	00000097          	auipc	ra,0x0
    80000488:	d04080e7          	jalr	-764(ra) # 80000188 <uart_puts>
            consputs("0x");
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    8000048c:	fa040713          	addi	a4,s0,-96
    80000490:	fb040593          	addi	a1,s0,-80
	uart_puts(str);
    80000494:	03c00693          	li	a3,60
                int shift = (15 - i) * 4;
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80000498:	00002617          	auipc	a2,0x2
    8000049c:	d6060613          	addi	a2,a2,-672 # 800021f8 <test_physical_memory+0xba6>
    800004a0:	00db57b3          	srl	a5,s6,a3
    800004a4:	8bbd                	andi	a5,a5,15
    800004a6:	97b2                	add	a5,a5,a2
    800004a8:	0007c783          	lbu	a5,0(a5)
    800004ac:	00f70023          	sb	a5,0(a4)
            for (i = 0; i < 16; i++) {
    800004b0:	36f1                	addiw	a3,a3,-4
    800004b2:	0705                	addi	a4,a4,1
    800004b4:	feb716e3          	bne	a4,a1,800004a0 <printf+0x172>
            }
            buf[16] = '\0';
    800004b8:	fa040823          	sb	zero,-80(s0)
	uart_puts(str);
    800004bc:	fa040513          	addi	a0,s0,-96
    800004c0:	00000097          	auipc	ra,0x0
    800004c4:	cc8080e7          	jalr	-824(ra) # 80000188 <uart_puts>
}
    800004c8:	bd75                	j	80000384 <printf+0x56>
            consputs(buf);
            break;
		case 'b':
            printint(va_arg(ap, int), 2, 0);
    800004ca:	fb843783          	ld	a5,-72(s0)
    800004ce:	00878713          	addi	a4,a5,8
    800004d2:	fae43c23          	sd	a4,-72(s0)
    800004d6:	4601                	li	a2,0
    800004d8:	4589                	li	a1,2
    800004da:	4388                	lw	a0,0(a5)
    800004dc:	00000097          	auipc	ra,0x0
    800004e0:	cf4080e7          	jalr	-780(ra) # 800001d0 <printint>
            break;
    800004e4:	b545                	j	80000384 <printf+0x56>
        case 'o':
            printint(va_arg(ap, int), 8, 0);
    800004e6:	fb843783          	ld	a5,-72(s0)
    800004ea:	00878713          	addi	a4,a5,8
    800004ee:	fae43c23          	sd	a4,-72(s0)
    800004f2:	4601                	li	a2,0
    800004f4:	45a1                	li	a1,8
    800004f6:	4388                	lw	a0,0(a5)
    800004f8:	00000097          	auipc	ra,0x0
    800004fc:	cd8080e7          	jalr	-808(ra) # 800001d0 <printint>
            break;
    80000500:	b551                	j	80000384 <printf+0x56>
        case '%':
            buffer_char('%');
    80000502:	02500513          	li	a0,37
    80000506:	00000097          	auipc	ra,0x0
    8000050a:	dc0080e7          	jalr	-576(ra) # 800002c6 <buffer_char>
            break;
    8000050e:	bd9d                	j	80000384 <printf+0x56>
        default:
			buffer_char('%');
    80000510:	02500513          	li	a0,37
    80000514:	00000097          	auipc	ra,0x0
    80000518:	db2080e7          	jalr	-590(ra) # 800002c6 <buffer_char>
			buffer_char(c);
    8000051c:	855a                	mv	a0,s6
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	da8080e7          	jalr	-600(ra) # 800002c6 <buffer_char>
            break;
    80000526:	bdb9                	j	80000384 <printf+0x56>
    80000528:	64a6                	ld	s1,72(sp)
    8000052a:	79e2                	ld	s3,56(sp)
    8000052c:	7a42                	ld	s4,48(sp)
    8000052e:	7aa2                	ld	s5,40(sp)
    80000530:	7b02                	ld	s6,32(sp)
        }
    }
	flush_printf_buffer(); // 最后刷新缓冲区
    80000532:	00000097          	auipc	ra,0x0
    80000536:	d58080e7          	jalr	-680(ra) # 8000028a <flush_printf_buffer>
    va_end(ap);
}
    8000053a:	60e6                	ld	ra,88(sp)
    8000053c:	6446                	ld	s0,80(sp)
    8000053e:	6906                	ld	s2,64(sp)
    80000540:	610d                	addi	sp,sp,160
    80000542:	8082                	ret
    80000544:	64a6                	ld	s1,72(sp)
    80000546:	79e2                	ld	s3,56(sp)
    80000548:	7a42                	ld	s4,48(sp)
    8000054a:	7aa2                	ld	s5,40(sp)
    8000054c:	7b02                	ld	s6,32(sp)
    8000054e:	b7d5                	j	80000532 <printf+0x204>

0000000080000550 <clear_screen>:
// 清屏功能
void clear_screen(void) {
    80000550:	1141                	addi	sp,sp,-16
    80000552:	e406                	sd	ra,8(sp)
    80000554:	e022                	sd	s0,0(sp)
    80000556:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    80000558:	00002517          	auipc	a0,0x2
    8000055c:	cb850513          	addi	a0,a0,-840 # 80002210 <test_physical_memory+0xbbe>
    80000560:	00000097          	auipc	ra,0x0
    80000564:	c28080e7          	jalr	-984(ra) # 80000188 <uart_puts>
	uart_puts(CURSOR_HOME);
    80000568:	00002517          	auipc	a0,0x2
    8000056c:	cb050513          	addi	a0,a0,-848 # 80002218 <test_physical_memory+0xbc6>
    80000570:	00000097          	auipc	ra,0x0
    80000574:	c18080e7          	jalr	-1000(ra) # 80000188 <uart_puts>
}
    80000578:	60a2                	ld	ra,8(sp)
    8000057a:	6402                	ld	s0,0(sp)
    8000057c:	0141                	addi	sp,sp,16
    8000057e:	8082                	ret

0000000080000580 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    if (lines <= 0) return;
    80000580:	04a05563          	blez	a0,800005ca <cursor_up+0x4a>
void cursor_up(int lines) {
    80000584:	1101                	addi	sp,sp,-32
    80000586:	ec06                	sd	ra,24(sp)
    80000588:	e822                	sd	s0,16(sp)
    8000058a:	e426                	sd	s1,8(sp)
    8000058c:	1000                	addi	s0,sp,32
    8000058e:	84aa                	mv	s1,a0
	uart_putc(c);
    80000590:	456d                	li	a0,27
    80000592:	00000097          	auipc	ra,0x0
    80000596:	bd2080e7          	jalr	-1070(ra) # 80000164 <uart_putc>
    8000059a:	05b00513          	li	a0,91
    8000059e:	00000097          	auipc	ra,0x0
    800005a2:	bc6080e7          	jalr	-1082(ra) # 80000164 <uart_putc>
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    800005a6:	4601                	li	a2,0
    800005a8:	45a9                	li	a1,10
    800005aa:	8526                	mv	a0,s1
    800005ac:	00000097          	auipc	ra,0x0
    800005b0:	c24080e7          	jalr	-988(ra) # 800001d0 <printint>
	uart_putc(c);
    800005b4:	04100513          	li	a0,65
    800005b8:	00000097          	auipc	ra,0x0
    800005bc:	bac080e7          	jalr	-1108(ra) # 80000164 <uart_putc>
    consputc('A');
}
    800005c0:	60e2                	ld	ra,24(sp)
    800005c2:	6442                	ld	s0,16(sp)
    800005c4:	64a2                	ld	s1,8(sp)
    800005c6:	6105                	addi	sp,sp,32
    800005c8:	8082                	ret
    800005ca:	8082                	ret

00000000800005cc <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    if (lines <= 0) return;
    800005cc:	04a05563          	blez	a0,80000616 <cursor_down+0x4a>
void cursor_down(int lines) {
    800005d0:	1101                	addi	sp,sp,-32
    800005d2:	ec06                	sd	ra,24(sp)
    800005d4:	e822                	sd	s0,16(sp)
    800005d6:	e426                	sd	s1,8(sp)
    800005d8:	1000                	addi	s0,sp,32
    800005da:	84aa                	mv	s1,a0
	uart_putc(c);
    800005dc:	456d                	li	a0,27
    800005de:	00000097          	auipc	ra,0x0
    800005e2:	b86080e7          	jalr	-1146(ra) # 80000164 <uart_putc>
    800005e6:	05b00513          	li	a0,91
    800005ea:	00000097          	auipc	ra,0x0
    800005ee:	b7a080e7          	jalr	-1158(ra) # 80000164 <uart_putc>
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    800005f2:	4601                	li	a2,0
    800005f4:	45a9                	li	a1,10
    800005f6:	8526                	mv	a0,s1
    800005f8:	00000097          	auipc	ra,0x0
    800005fc:	bd8080e7          	jalr	-1064(ra) # 800001d0 <printint>
	uart_putc(c);
    80000600:	04200513          	li	a0,66
    80000604:	00000097          	auipc	ra,0x0
    80000608:	b60080e7          	jalr	-1184(ra) # 80000164 <uart_putc>
    consputc('B');
}
    8000060c:	60e2                	ld	ra,24(sp)
    8000060e:	6442                	ld	s0,16(sp)
    80000610:	64a2                	ld	s1,8(sp)
    80000612:	6105                	addi	sp,sp,32
    80000614:	8082                	ret
    80000616:	8082                	ret

0000000080000618 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    if (cols <= 0) return;
    80000618:	04a05563          	blez	a0,80000662 <cursor_right+0x4a>
void cursor_right(int cols) {
    8000061c:	1101                	addi	sp,sp,-32
    8000061e:	ec06                	sd	ra,24(sp)
    80000620:	e822                	sd	s0,16(sp)
    80000622:	e426                	sd	s1,8(sp)
    80000624:	1000                	addi	s0,sp,32
    80000626:	84aa                	mv	s1,a0
	uart_putc(c);
    80000628:	456d                	li	a0,27
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	b3a080e7          	jalr	-1222(ra) # 80000164 <uart_putc>
    80000632:	05b00513          	li	a0,91
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	b2e080e7          	jalr	-1234(ra) # 80000164 <uart_putc>
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    8000063e:	4601                	li	a2,0
    80000640:	45a9                	li	a1,10
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	b8c080e7          	jalr	-1140(ra) # 800001d0 <printint>
	uart_putc(c);
    8000064c:	04300513          	li	a0,67
    80000650:	00000097          	auipc	ra,0x0
    80000654:	b14080e7          	jalr	-1260(ra) # 80000164 <uart_putc>
    consputc('C');
}
    80000658:	60e2                	ld	ra,24(sp)
    8000065a:	6442                	ld	s0,16(sp)
    8000065c:	64a2                	ld	s1,8(sp)
    8000065e:	6105                	addi	sp,sp,32
    80000660:	8082                	ret
    80000662:	8082                	ret

0000000080000664 <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    if (cols <= 0) return;
    80000664:	04a05563          	blez	a0,800006ae <cursor_left+0x4a>
void cursor_left(int cols) {
    80000668:	1101                	addi	sp,sp,-32
    8000066a:	ec06                	sd	ra,24(sp)
    8000066c:	e822                	sd	s0,16(sp)
    8000066e:	e426                	sd	s1,8(sp)
    80000670:	1000                	addi	s0,sp,32
    80000672:	84aa                	mv	s1,a0
	uart_putc(c);
    80000674:	456d                	li	a0,27
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	aee080e7          	jalr	-1298(ra) # 80000164 <uart_putc>
    8000067e:	05b00513          	li	a0,91
    80000682:	00000097          	auipc	ra,0x0
    80000686:	ae2080e7          	jalr	-1310(ra) # 80000164 <uart_putc>
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    8000068a:	4601                	li	a2,0
    8000068c:	45a9                	li	a1,10
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	b40080e7          	jalr	-1216(ra) # 800001d0 <printint>
	uart_putc(c);
    80000698:	04400513          	li	a0,68
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	ac8080e7          	jalr	-1336(ra) # 80000164 <uart_putc>
    consputc('D');
}
    800006a4:	60e2                	ld	ra,24(sp)
    800006a6:	6442                	ld	s0,16(sp)
    800006a8:	64a2                	ld	s1,8(sp)
    800006aa:	6105                	addi	sp,sp,32
    800006ac:	8082                	ret
    800006ae:	8082                	ret

00000000800006b0 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    800006b0:	1141                	addi	sp,sp,-16
    800006b2:	e406                	sd	ra,8(sp)
    800006b4:	e022                	sd	s0,0(sp)
    800006b6:	0800                	addi	s0,sp,16
	uart_putc(c);
    800006b8:	456d                	li	a0,27
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	aaa080e7          	jalr	-1366(ra) # 80000164 <uart_putc>
    800006c2:	05b00513          	li	a0,91
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	a9e080e7          	jalr	-1378(ra) # 80000164 <uart_putc>
    800006ce:	07300513          	li	a0,115
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	a92080e7          	jalr	-1390(ra) # 80000164 <uart_putc>
    consputc('\033');
    consputc('[');
    consputc('s');
}
    800006da:	60a2                	ld	ra,8(sp)
    800006dc:	6402                	ld	s0,0(sp)
    800006de:	0141                	addi	sp,sp,16
    800006e0:	8082                	ret

00000000800006e2 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    800006e2:	1141                	addi	sp,sp,-16
    800006e4:	e406                	sd	ra,8(sp)
    800006e6:	e022                	sd	s0,0(sp)
    800006e8:	0800                	addi	s0,sp,16
	uart_putc(c);
    800006ea:	456d                	li	a0,27
    800006ec:	00000097          	auipc	ra,0x0
    800006f0:	a78080e7          	jalr	-1416(ra) # 80000164 <uart_putc>
    800006f4:	05b00513          	li	a0,91
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	a6c080e7          	jalr	-1428(ra) # 80000164 <uart_putc>
    80000700:	07500513          	li	a0,117
    80000704:	00000097          	auipc	ra,0x0
    80000708:	a60080e7          	jalr	-1440(ra) # 80000164 <uart_putc>
    consputc('\033');
    consputc('[');
    consputc('u');
}
    8000070c:	60a2                	ld	ra,8(sp)
    8000070e:	6402                	ld	s0,0(sp)
    80000710:	0141                	addi	sp,sp,16
    80000712:	8082                	ret

0000000080000714 <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    80000714:	1101                	addi	sp,sp,-32
    80000716:	ec06                	sd	ra,24(sp)
    80000718:	e822                	sd	s0,16(sp)
    8000071a:	e426                	sd	s1,8(sp)
    8000071c:	1000                	addi	s0,sp,32
    8000071e:	84aa                	mv	s1,a0
	uart_putc(c);
    80000720:	456d                	li	a0,27
    80000722:	00000097          	auipc	ra,0x0
    80000726:	a42080e7          	jalr	-1470(ra) # 80000164 <uart_putc>
    8000072a:	05b00513          	li	a0,91
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	a36080e7          	jalr	-1482(ra) # 80000164 <uart_putc>
    if (col <= 0) col = 1;
    80000736:	8526                	mv	a0,s1
    80000738:	02905463          	blez	s1,80000760 <cursor_to_column+0x4c>
    consputc('\033');
    consputc('[');
    printint(col, 10, 0);
    8000073c:	4601                	li	a2,0
    8000073e:	45a9                	li	a1,10
    80000740:	2501                	sext.w	a0,a0
    80000742:	00000097          	auipc	ra,0x0
    80000746:	a8e080e7          	jalr	-1394(ra) # 800001d0 <printint>
	uart_putc(c);
    8000074a:	04700513          	li	a0,71
    8000074e:	00000097          	auipc	ra,0x0
    80000752:	a16080e7          	jalr	-1514(ra) # 80000164 <uart_putc>
    consputc('G');
}
    80000756:	60e2                	ld	ra,24(sp)
    80000758:	6442                	ld	s0,16(sp)
    8000075a:	64a2                	ld	s1,8(sp)
    8000075c:	6105                	addi	sp,sp,32
    8000075e:	8082                	ret
    if (col <= 0) col = 1;
    80000760:	4505                	li	a0,1
    80000762:	bfe9                	j	8000073c <cursor_to_column+0x28>

0000000080000764 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80000764:	1101                	addi	sp,sp,-32
    80000766:	ec06                	sd	ra,24(sp)
    80000768:	e822                	sd	s0,16(sp)
    8000076a:	e426                	sd	s1,8(sp)
    8000076c:	e04a                	sd	s2,0(sp)
    8000076e:	1000                	addi	s0,sp,32
    80000770:	892a                	mv	s2,a0
    80000772:	84ae                	mv	s1,a1
	uart_putc(c);
    80000774:	456d                	li	a0,27
    80000776:	00000097          	auipc	ra,0x0
    8000077a:	9ee080e7          	jalr	-1554(ra) # 80000164 <uart_putc>
    8000077e:	05b00513          	li	a0,91
    80000782:	00000097          	auipc	ra,0x0
    80000786:	9e2080e7          	jalr	-1566(ra) # 80000164 <uart_putc>
    consputc('\033');
    consputc('[');
    printint(row, 10, 0);
    8000078a:	4601                	li	a2,0
    8000078c:	45a9                	li	a1,10
    8000078e:	854a                	mv	a0,s2
    80000790:	00000097          	auipc	ra,0x0
    80000794:	a40080e7          	jalr	-1472(ra) # 800001d0 <printint>
	uart_putc(c);
    80000798:	03b00513          	li	a0,59
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	9c8080e7          	jalr	-1592(ra) # 80000164 <uart_putc>
    consputc(';');
    printint(col, 10, 0);
    800007a4:	4601                	li	a2,0
    800007a6:	45a9                	li	a1,10
    800007a8:	8526                	mv	a0,s1
    800007aa:	00000097          	auipc	ra,0x0
    800007ae:	a26080e7          	jalr	-1498(ra) # 800001d0 <printint>
	uart_putc(c);
    800007b2:	04800513          	li	a0,72
    800007b6:	00000097          	auipc	ra,0x0
    800007ba:	9ae080e7          	jalr	-1618(ra) # 80000164 <uart_putc>
    consputc('H');
}
    800007be:	60e2                	ld	ra,24(sp)
    800007c0:	6442                	ld	s0,16(sp)
    800007c2:	64a2                	ld	s1,8(sp)
    800007c4:	6902                	ld	s2,0(sp)
    800007c6:	6105                	addi	sp,sp,32
    800007c8:	8082                	ret

00000000800007ca <reset_color>:
// 颜色控制
void reset_color(void) {
    800007ca:	1141                	addi	sp,sp,-16
    800007cc:	e406                	sd	ra,8(sp)
    800007ce:	e022                	sd	s0,0(sp)
    800007d0:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    800007d2:	00002517          	auipc	a0,0x2
    800007d6:	a4e50513          	addi	a0,a0,-1458 # 80002220 <test_physical_memory+0xbce>
    800007da:	00000097          	auipc	ra,0x0
    800007de:	9ae080e7          	jalr	-1618(ra) # 80000188 <uart_puts>
}
    800007e2:	60a2                	ld	ra,8(sp)
    800007e4:	6402                	ld	s0,0(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
	if (color < 30 || color > 37) return; // 支持30-37
    800007ea:	fe25071b          	addiw	a4,a0,-30
    800007ee:	479d                	li	a5,7
    800007f0:	00e7f363          	bgeu	a5,a4,800007f6 <set_fg_color+0xc>
    800007f4:	8082                	ret
void set_fg_color(int color) {
    800007f6:	1101                	addi	sp,sp,-32
    800007f8:	ec06                	sd	ra,24(sp)
    800007fa:	e822                	sd	s0,16(sp)
    800007fc:	e426                	sd	s1,8(sp)
    800007fe:	1000                	addi	s0,sp,32
    80000800:	84aa                	mv	s1,a0
	uart_putc(c);
    80000802:	456d                	li	a0,27
    80000804:	00000097          	auipc	ra,0x0
    80000808:	960080e7          	jalr	-1696(ra) # 80000164 <uart_putc>
    8000080c:	05b00513          	li	a0,91
    80000810:	00000097          	auipc	ra,0x0
    80000814:	954080e7          	jalr	-1708(ra) # 80000164 <uart_putc>
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
    80000818:	4601                	li	a2,0
    8000081a:	45a9                	li	a1,10
    8000081c:	8526                	mv	a0,s1
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	9b2080e7          	jalr	-1614(ra) # 800001d0 <printint>
	uart_putc(c);
    80000826:	06d00513          	li	a0,109
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	93a080e7          	jalr	-1734(ra) # 80000164 <uart_putc>
	consputc('m');
}
    80000832:	60e2                	ld	ra,24(sp)
    80000834:	6442                	ld	s0,16(sp)
    80000836:	64a2                	ld	s1,8(sp)
    80000838:	6105                	addi	sp,sp,32
    8000083a:	8082                	ret

000000008000083c <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
	if (color < 40 || color > 47) return; // 支持40-47
    8000083c:	fd85071b          	addiw	a4,a0,-40
    80000840:	479d                	li	a5,7
    80000842:	00e7f363          	bgeu	a5,a4,80000848 <set_bg_color+0xc>
    80000846:	8082                	ret
void set_bg_color(int color) {
    80000848:	1101                	addi	sp,sp,-32
    8000084a:	ec06                	sd	ra,24(sp)
    8000084c:	e822                	sd	s0,16(sp)
    8000084e:	e426                	sd	s1,8(sp)
    80000850:	1000                	addi	s0,sp,32
    80000852:	84aa                	mv	s1,a0
	uart_putc(c);
    80000854:	456d                	li	a0,27
    80000856:	00000097          	auipc	ra,0x0
    8000085a:	90e080e7          	jalr	-1778(ra) # 80000164 <uart_putc>
    8000085e:	05b00513          	li	a0,91
    80000862:	00000097          	auipc	ra,0x0
    80000866:	902080e7          	jalr	-1790(ra) # 80000164 <uart_putc>
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
    8000086a:	4601                	li	a2,0
    8000086c:	45a9                	li	a1,10
    8000086e:	8526                	mv	a0,s1
    80000870:	00000097          	auipc	ra,0x0
    80000874:	960080e7          	jalr	-1696(ra) # 800001d0 <printint>
	uart_putc(c);
    80000878:	06d00513          	li	a0,109
    8000087c:	00000097          	auipc	ra,0x0
    80000880:	8e8080e7          	jalr	-1816(ra) # 80000164 <uart_putc>
	consputc('m');
}
    80000884:	60e2                	ld	ra,24(sp)
    80000886:	6442                	ld	s0,16(sp)
    80000888:	64a2                	ld	s1,8(sp)
    8000088a:	6105                	addi	sp,sp,32
    8000088c:	8082                	ret

000000008000088e <color_red>:
// 简易文字颜色
void color_red(void) {
    8000088e:	1141                	addi	sp,sp,-16
    80000890:	e406                	sd	ra,8(sp)
    80000892:	e022                	sd	s0,0(sp)
    80000894:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    80000896:	457d                	li	a0,31
    80000898:	00000097          	auipc	ra,0x0
    8000089c:	f52080e7          	jalr	-174(ra) # 800007ea <set_fg_color>
}
    800008a0:	60a2                	ld	ra,8(sp)
    800008a2:	6402                	ld	s0,0(sp)
    800008a4:	0141                	addi	sp,sp,16
    800008a6:	8082                	ret

00000000800008a8 <color_green>:
void color_green(void) {
    800008a8:	1141                	addi	sp,sp,-16
    800008aa:	e406                	sd	ra,8(sp)
    800008ac:	e022                	sd	s0,0(sp)
    800008ae:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    800008b0:	02000513          	li	a0,32
    800008b4:	00000097          	auipc	ra,0x0
    800008b8:	f36080e7          	jalr	-202(ra) # 800007ea <set_fg_color>
}
    800008bc:	60a2                	ld	ra,8(sp)
    800008be:	6402                	ld	s0,0(sp)
    800008c0:	0141                	addi	sp,sp,16
    800008c2:	8082                	ret

00000000800008c4 <color_yellow>:
void color_yellow(void) {
    800008c4:	1141                	addi	sp,sp,-16
    800008c6:	e406                	sd	ra,8(sp)
    800008c8:	e022                	sd	s0,0(sp)
    800008ca:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    800008cc:	02100513          	li	a0,33
    800008d0:	00000097          	auipc	ra,0x0
    800008d4:	f1a080e7          	jalr	-230(ra) # 800007ea <set_fg_color>
}
    800008d8:	60a2                	ld	ra,8(sp)
    800008da:	6402                	ld	s0,0(sp)
    800008dc:	0141                	addi	sp,sp,16
    800008de:	8082                	ret

00000000800008e0 <color_blue>:
void color_blue(void) {
    800008e0:	1141                	addi	sp,sp,-16
    800008e2:	e406                	sd	ra,8(sp)
    800008e4:	e022                	sd	s0,0(sp)
    800008e6:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    800008e8:	02200513          	li	a0,34
    800008ec:	00000097          	auipc	ra,0x0
    800008f0:	efe080e7          	jalr	-258(ra) # 800007ea <set_fg_color>
}
    800008f4:	60a2                	ld	ra,8(sp)
    800008f6:	6402                	ld	s0,0(sp)
    800008f8:	0141                	addi	sp,sp,16
    800008fa:	8082                	ret

00000000800008fc <color_purple>:
void color_purple(void) {
    800008fc:	1141                	addi	sp,sp,-16
    800008fe:	e406                	sd	ra,8(sp)
    80000900:	e022                	sd	s0,0(sp)
    80000902:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80000904:	02300513          	li	a0,35
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	ee2080e7          	jalr	-286(ra) # 800007ea <set_fg_color>
}
    80000910:	60a2                	ld	ra,8(sp)
    80000912:	6402                	ld	s0,0(sp)
    80000914:	0141                	addi	sp,sp,16
    80000916:	8082                	ret

0000000080000918 <color_cyan>:
void color_cyan(void) {
    80000918:	1141                	addi	sp,sp,-16
    8000091a:	e406                	sd	ra,8(sp)
    8000091c:	e022                	sd	s0,0(sp)
    8000091e:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    80000920:	02400513          	li	a0,36
    80000924:	00000097          	auipc	ra,0x0
    80000928:	ec6080e7          	jalr	-314(ra) # 800007ea <set_fg_color>
}
    8000092c:	60a2                	ld	ra,8(sp)
    8000092e:	6402                	ld	s0,0(sp)
    80000930:	0141                	addi	sp,sp,16
    80000932:	8082                	ret

0000000080000934 <color_reverse>:
void color_reverse(void){
    80000934:	1141                	addi	sp,sp,-16
    80000936:	e406                	sd	ra,8(sp)
    80000938:	e022                	sd	s0,0(sp)
    8000093a:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    8000093c:	02500513          	li	a0,37
    80000940:	00000097          	auipc	ra,0x0
    80000944:	eaa080e7          	jalr	-342(ra) # 800007ea <set_fg_color>
}
    80000948:	60a2                	ld	ra,8(sp)
    8000094a:	6402                	ld	s0,0(sp)
    8000094c:	0141                	addi	sp,sp,16
    8000094e:	8082                	ret

0000000080000950 <set_color>:
void set_color(int fg, int bg) {
    80000950:	1101                	addi	sp,sp,-32
    80000952:	ec06                	sd	ra,24(sp)
    80000954:	e822                	sd	s0,16(sp)
    80000956:	e426                	sd	s1,8(sp)
    80000958:	1000                	addi	s0,sp,32
    8000095a:	84aa                	mv	s1,a0
	set_bg_color(bg);
    8000095c:	852e                	mv	a0,a1
    8000095e:	00000097          	auipc	ra,0x0
    80000962:	ede080e7          	jalr	-290(ra) # 8000083c <set_bg_color>
	set_fg_color(fg);
    80000966:	8526                	mv	a0,s1
    80000968:	00000097          	auipc	ra,0x0
    8000096c:	e82080e7          	jalr	-382(ra) # 800007ea <set_fg_color>
}
    80000970:	60e2                	ld	ra,24(sp)
    80000972:	6442                	ld	s0,16(sp)
    80000974:	64a2                	ld	s1,8(sp)
    80000976:	6105                	addi	sp,sp,32
    80000978:	8082                	ret

000000008000097a <clear_line>:
void clear_line(){
    8000097a:	1141                	addi	sp,sp,-16
    8000097c:	e406                	sd	ra,8(sp)
    8000097e:	e022                	sd	s0,0(sp)
    80000980:	0800                	addi	s0,sp,16
	uart_putc(c);
    80000982:	456d                	li	a0,27
    80000984:	fffff097          	auipc	ra,0xfffff
    80000988:	7e0080e7          	jalr	2016(ra) # 80000164 <uart_putc>
    8000098c:	05b00513          	li	a0,91
    80000990:	fffff097          	auipc	ra,0xfffff
    80000994:	7d4080e7          	jalr	2004(ra) # 80000164 <uart_putc>
    80000998:	03200513          	li	a0,50
    8000099c:	fffff097          	auipc	ra,0xfffff
    800009a0:	7c8080e7          	jalr	1992(ra) # 80000164 <uart_putc>
    800009a4:	04b00513          	li	a0,75
    800009a8:	fffff097          	auipc	ra,0xfffff
    800009ac:	7bc080e7          	jalr	1980(ra) # 80000164 <uart_putc>
	consputc('\033');
	consputc('[');
	consputc('2');
	consputc('K');
}
    800009b0:	60a2                	ld	ra,8(sp)
    800009b2:	6402                	ld	s0,0(sp)
    800009b4:	0141                	addi	sp,sp,16
    800009b6:	8082                	ret

00000000800009b8 <panic>:

void panic(const char *msg) {
    800009b8:	1101                	addi	sp,sp,-32
    800009ba:	ec06                	sd	ra,24(sp)
    800009bc:	e822                	sd	s0,16(sp)
    800009be:	e426                	sd	s1,8(sp)
    800009c0:	1000                	addi	s0,sp,32
    800009c2:	84aa                	mv	s1,a0
	color_red(); // 可选：红色显示
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	eca080e7          	jalr	-310(ra) # 8000088e <color_red>
	printf("panic: %s\n", msg);
    800009cc:	85a6                	mv	a1,s1
    800009ce:	00002517          	auipc	a0,0x2
    800009d2:	85a50513          	addi	a0,a0,-1958 # 80002228 <test_physical_memory+0xbd6>
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	958080e7          	jalr	-1704(ra) # 8000032e <printf>
	reset_color();
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	dec080e7          	jalr	-532(ra) # 800007ca <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    800009e6:	a001                	j	800009e6 <panic+0x2e>

00000000800009e8 <test_printf_precision>:
}
void test_printf_precision(void) {
    800009e8:	1101                	addi	sp,sp,-32
    800009ea:	ec06                	sd	ra,24(sp)
    800009ec:	e822                	sd	s0,16(sp)
    800009ee:	1000                	addi	s0,sp,32
	clear_screen();
    800009f0:	00000097          	auipc	ra,0x0
    800009f4:	b60080e7          	jalr	-1184(ra) # 80000550 <clear_screen>
    printf("=== 详细的Printf测试 ===\n");
    800009f8:	00002517          	auipc	a0,0x2
    800009fc:	84050513          	addi	a0,a0,-1984 # 80002238 <test_physical_memory+0xbe6>
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	92e080e7          	jalr	-1746(ra) # 8000032e <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    80000a08:	00002517          	auipc	a0,0x2
    80000a0c:	85050513          	addi	a0,a0,-1968 # 80002258 <test_physical_memory+0xc06>
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	91e080e7          	jalr	-1762(ra) # 8000032e <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    80000a18:	0ff00593          	li	a1,255
    80000a1c:	00002517          	auipc	a0,0x2
    80000a20:	85450513          	addi	a0,a0,-1964 # 80002270 <test_physical_memory+0xc1e>
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	90a080e7          	jalr	-1782(ra) # 8000032e <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    80000a2c:	6585                	lui	a1,0x1
    80000a2e:	00002517          	auipc	a0,0x2
    80000a32:	86250513          	addi	a0,a0,-1950 # 80002290 <test_physical_memory+0xc3e>
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	8f8080e7          	jalr	-1800(ra) # 8000032e <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    80000a3e:	1234b5b7          	lui	a1,0x1234b
    80000a42:	bcd58593          	addi	a1,a1,-1075 # 1234abcd <_entry-0x6dcb5433>
    80000a46:	00002517          	auipc	a0,0x2
    80000a4a:	86a50513          	addi	a0,a0,-1942 # 800022b0 <test_physical_memory+0xc5e>
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	8e0080e7          	jalr	-1824(ra) # 8000032e <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    80000a56:	00002517          	auipc	a0,0x2
    80000a5a:	87250513          	addi	a0,a0,-1934 # 800022c8 <test_physical_memory+0xc76>
    80000a5e:	00000097          	auipc	ra,0x0
    80000a62:	8d0080e7          	jalr	-1840(ra) # 8000032e <printf>
    printf("  正数: %d\n", 42);
    80000a66:	02a00593          	li	a1,42
    80000a6a:	00002517          	auipc	a0,0x2
    80000a6e:	87650513          	addi	a0,a0,-1930 # 800022e0 <test_physical_memory+0xc8e>
    80000a72:	00000097          	auipc	ra,0x0
    80000a76:	8bc080e7          	jalr	-1860(ra) # 8000032e <printf>
    printf("  负数: %d\n", -42);
    80000a7a:	fd600593          	li	a1,-42
    80000a7e:	00002517          	auipc	a0,0x2
    80000a82:	87250513          	addi	a0,a0,-1934 # 800022f0 <test_physical_memory+0xc9e>
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	8a8080e7          	jalr	-1880(ra) # 8000032e <printf>
    printf("  零: %d\n", 0);
    80000a8e:	4581                	li	a1,0
    80000a90:	00002517          	auipc	a0,0x2
    80000a94:	87050513          	addi	a0,a0,-1936 # 80002300 <test_physical_memory+0xcae>
    80000a98:	00000097          	auipc	ra,0x0
    80000a9c:	896080e7          	jalr	-1898(ra) # 8000032e <printf>
    printf("  大数: %d\n", 123456789);
    80000aa0:	075bd5b7          	lui	a1,0x75bd
    80000aa4:	d1558593          	addi	a1,a1,-747 # 75bcd15 <_entry-0x78a432eb>
    80000aa8:	00002517          	auipc	a0,0x2
    80000aac:	86850513          	addi	a0,a0,-1944 # 80002310 <test_physical_memory+0xcbe>
    80000ab0:	00000097          	auipc	ra,0x0
    80000ab4:	87e080e7          	jalr	-1922(ra) # 8000032e <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80000ab8:	00002517          	auipc	a0,0x2
    80000abc:	86850513          	addi	a0,a0,-1944 # 80002320 <test_physical_memory+0xcce>
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	86e080e7          	jalr	-1938(ra) # 8000032e <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80000ac8:	55fd                	li	a1,-1
    80000aca:	00002517          	auipc	a0,0x2
    80000ace:	86e50513          	addi	a0,a0,-1938 # 80002338 <test_physical_memory+0xce6>
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	85c080e7          	jalr	-1956(ra) # 8000032e <printf>
    printf("  零：%u\n", 0U);
    80000ada:	4581                	li	a1,0
    80000adc:	00002517          	auipc	a0,0x2
    80000ae0:	87450513          	addi	a0,a0,-1932 # 80002350 <test_physical_memory+0xcfe>
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	84a080e7          	jalr	-1974(ra) # 8000032e <printf>
	printf("  小无符号数：%u\n", 12345U);
    80000aec:	658d                	lui	a1,0x3
    80000aee:	03958593          	addi	a1,a1,57 # 3039 <_entry-0x7fffcfc7>
    80000af2:	00002517          	auipc	a0,0x2
    80000af6:	86e50513          	addi	a0,a0,-1938 # 80002360 <test_physical_memory+0xd0e>
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	834080e7          	jalr	-1996(ra) # 8000032e <printf>

	// 测试边界
	printf("边界测试:\n");
    80000b02:	00002517          	auipc	a0,0x2
    80000b06:	87650513          	addi	a0,a0,-1930 # 80002378 <test_physical_memory+0xd26>
    80000b0a:	00000097          	auipc	ra,0x0
    80000b0e:	824080e7          	jalr	-2012(ra) # 8000032e <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    80000b12:	800005b7          	lui	a1,0x80000
    80000b16:	fff5c593          	not	a1,a1
    80000b1a:	00002517          	auipc	a0,0x2
    80000b1e:	86e50513          	addi	a0,a0,-1938 # 80002388 <test_physical_memory+0xd36>
    80000b22:	00000097          	auipc	ra,0x0
    80000b26:	80c080e7          	jalr	-2036(ra) # 8000032e <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    80000b2a:	800005b7          	lui	a1,0x80000
    80000b2e:	00002517          	auipc	a0,0x2
    80000b32:	86a50513          	addi	a0,a0,-1942 # 80002398 <test_physical_memory+0xd46>
    80000b36:	fffff097          	auipc	ra,0xfffff
    80000b3a:	7f8080e7          	jalr	2040(ra) # 8000032e <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    80000b3e:	55fd                	li	a1,-1
    80000b40:	00002517          	auipc	a0,0x2
    80000b44:	86850513          	addi	a0,a0,-1944 # 800023a8 <test_physical_memory+0xd56>
    80000b48:	fffff097          	auipc	ra,0xfffff
    80000b4c:	7e6080e7          	jalr	2022(ra) # 8000032e <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    80000b50:	55fd                	li	a1,-1
    80000b52:	00002517          	auipc	a0,0x2
    80000b56:	86650513          	addi	a0,a0,-1946 # 800023b8 <test_physical_memory+0xd66>
    80000b5a:	fffff097          	auipc	ra,0xfffff
    80000b5e:	7d4080e7          	jalr	2004(ra) # 8000032e <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    80000b62:	00002517          	auipc	a0,0x2
    80000b66:	86e50513          	addi	a0,a0,-1938 # 800023d0 <test_physical_memory+0xd7e>
    80000b6a:	fffff097          	auipc	ra,0xfffff
    80000b6e:	7c4080e7          	jalr	1988(ra) # 8000032e <printf>
    printf("  空字符串: '%s'\n", "");
    80000b72:	00002597          	auipc	a1,0x2
    80000b76:	abe58593          	addi	a1,a1,-1346 # 80002630 <test_physical_memory+0xfde>
    80000b7a:	00002517          	auipc	a0,0x2
    80000b7e:	86e50513          	addi	a0,a0,-1938 # 800023e8 <test_physical_memory+0xd96>
    80000b82:	fffff097          	auipc	ra,0xfffff
    80000b86:	7ac080e7          	jalr	1964(ra) # 8000032e <printf>
    printf("  单字符: '%s'\n", "X");
    80000b8a:	00002597          	auipc	a1,0x2
    80000b8e:	87658593          	addi	a1,a1,-1930 # 80002400 <test_physical_memory+0xdae>
    80000b92:	00002517          	auipc	a0,0x2
    80000b96:	87650513          	addi	a0,a0,-1930 # 80002408 <test_physical_memory+0xdb6>
    80000b9a:	fffff097          	auipc	ra,0xfffff
    80000b9e:	794080e7          	jalr	1940(ra) # 8000032e <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    80000ba2:	00002597          	auipc	a1,0x2
    80000ba6:	87e58593          	addi	a1,a1,-1922 # 80002420 <test_physical_memory+0xdce>
    80000baa:	00002517          	auipc	a0,0x2
    80000bae:	89650513          	addi	a0,a0,-1898 # 80002440 <test_physical_memory+0xdee>
    80000bb2:	fffff097          	auipc	ra,0xfffff
    80000bb6:	77c080e7          	jalr	1916(ra) # 8000032e <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80000bba:	00002597          	auipc	a1,0x2
    80000bbe:	89e58593          	addi	a1,a1,-1890 # 80002458 <test_physical_memory+0xe06>
    80000bc2:	00002517          	auipc	a0,0x2
    80000bc6:	9e650513          	addi	a0,a0,-1562 # 800025a8 <test_physical_memory+0xf56>
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	764080e7          	jalr	1892(ra) # 8000032e <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    80000bd2:	00002517          	auipc	a0,0x2
    80000bd6:	9f650513          	addi	a0,a0,-1546 # 800025c8 <test_physical_memory+0xf76>
    80000bda:	fffff097          	auipc	ra,0xfffff
    80000bde:	754080e7          	jalr	1876(ra) # 8000032e <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    80000be2:	0ff00693          	li	a3,255
    80000be6:	f0100613          	li	a2,-255
    80000bea:	0ff00593          	li	a1,255
    80000bee:	00002517          	auipc	a0,0x2
    80000bf2:	9f250513          	addi	a0,a0,-1550 # 800025e0 <test_physical_memory+0xf8e>
    80000bf6:	fffff097          	auipc	ra,0xfffff
    80000bfa:	738080e7          	jalr	1848(ra) # 8000032e <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80000bfe:	00002517          	auipc	a0,0x2
    80000c02:	a0a50513          	addi	a0,a0,-1526 # 80002608 <test_physical_memory+0xfb6>
    80000c06:	fffff097          	auipc	ra,0xfffff
    80000c0a:	728080e7          	jalr	1832(ra) # 8000032e <printf>
	printf("  100%% 完成!\n");
    80000c0e:	00002517          	auipc	a0,0x2
    80000c12:	a1250513          	addi	a0,a0,-1518 # 80002620 <test_physical_memory+0xfce>
    80000c16:	fffff097          	auipc	ra,0xfffff
    80000c1a:	718080e7          	jalr	1816(ra) # 8000032e <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
	printf("NULL字符串测试:\n");
    80000c1e:	00002517          	auipc	a0,0x2
    80000c22:	a1a50513          	addi	a0,a0,-1510 # 80002638 <test_physical_memory+0xfe6>
    80000c26:	fffff097          	auipc	ra,0xfffff
    80000c2a:	708080e7          	jalr	1800(ra) # 8000032e <printf>
	printf("  NULL as string: '%s'\n", null_str);
    80000c2e:	4581                	li	a1,0
    80000c30:	00002517          	auipc	a0,0x2
    80000c34:	a2050513          	addi	a0,a0,-1504 # 80002650 <test_physical_memory+0xffe>
    80000c38:	fffff097          	auipc	ra,0xfffff
    80000c3c:	6f6080e7          	jalr	1782(ra) # 8000032e <printf>
	
	// 测试指针格式
	int var = 42;
    80000c40:	02a00793          	li	a5,42
    80000c44:	fef42623          	sw	a5,-20(s0)
	printf("指针测试:\n");
    80000c48:	00002517          	auipc	a0,0x2
    80000c4c:	a2050513          	addi	a0,a0,-1504 # 80002668 <test_physical_memory+0x1016>
    80000c50:	fffff097          	auipc	ra,0xfffff
    80000c54:	6de080e7          	jalr	1758(ra) # 8000032e <printf>
	printf("  Address of var: %p\n", &var);
    80000c58:	fec40593          	addi	a1,s0,-20
    80000c5c:	00002517          	auipc	a0,0x2
    80000c60:	a1c50513          	addi	a0,a0,-1508 # 80002678 <test_physical_memory+0x1026>
    80000c64:	fffff097          	auipc	ra,0xfffff
    80000c68:	6ca080e7          	jalr	1738(ra) # 8000032e <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80000c6c:	00002517          	auipc	a0,0x2
    80000c70:	a2450513          	addi	a0,a0,-1500 # 80002690 <test_physical_memory+0x103e>
    80000c74:	fffff097          	auipc	ra,0xfffff
    80000c78:	6ba080e7          	jalr	1722(ra) # 8000032e <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80000c7c:	55fd                	li	a1,-1
    80000c7e:	00002517          	auipc	a0,0x2
    80000c82:	a3250513          	addi	a0,a0,-1486 # 800026b0 <test_physical_memory+0x105e>
    80000c86:	fffff097          	auipc	ra,0xfffff
    80000c8a:	6a8080e7          	jalr	1704(ra) # 8000032e <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80000c8e:	00002517          	auipc	a0,0x2
    80000c92:	a3a50513          	addi	a0,a0,-1478 # 800026c8 <test_physical_memory+0x1076>
    80000c96:	fffff097          	auipc	ra,0xfffff
    80000c9a:	698080e7          	jalr	1688(ra) # 8000032e <printf>
	printf("  Binary of 5: %b\n", 5);
    80000c9e:	4595                	li	a1,5
    80000ca0:	00002517          	auipc	a0,0x2
    80000ca4:	a4050513          	addi	a0,a0,-1472 # 800026e0 <test_physical_memory+0x108e>
    80000ca8:	fffff097          	auipc	ra,0xfffff
    80000cac:	686080e7          	jalr	1670(ra) # 8000032e <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80000cb0:	45a1                	li	a1,8
    80000cb2:	00002517          	auipc	a0,0x2
    80000cb6:	a4650513          	addi	a0,a0,-1466 # 800026f8 <test_physical_memory+0x10a6>
    80000cba:	fffff097          	auipc	ra,0xfffff
    80000cbe:	674080e7          	jalr	1652(ra) # 8000032e <printf>
	printf("=== Printf测试结束 ===\n");
    80000cc2:	00002517          	auipc	a0,0x2
    80000cc6:	a4e50513          	addi	a0,a0,-1458 # 80002710 <test_physical_memory+0x10be>
    80000cca:	fffff097          	auipc	ra,0xfffff
    80000cce:	664080e7          	jalr	1636(ra) # 8000032e <printf>
}
    80000cd2:	60e2                	ld	ra,24(sp)
    80000cd4:	6442                	ld	s0,16(sp)
    80000cd6:	6105                	addi	sp,sp,32
    80000cd8:	8082                	ret

0000000080000cda <test_curse_move>:
void test_curse_move(){
    80000cda:	7139                	addi	sp,sp,-64
    80000cdc:	fc06                	sd	ra,56(sp)
    80000cde:	f822                	sd	s0,48(sp)
    80000ce0:	f426                	sd	s1,40(sp)
    80000ce2:	f04a                	sd	s2,32(sp)
    80000ce4:	ec4e                	sd	s3,24(sp)
    80000ce6:	e852                	sd	s4,16(sp)
    80000ce8:	e456                	sd	s5,8(sp)
    80000cea:	e05a                	sd	s6,0(sp)
    80000cec:	0080                	addi	s0,sp,64
	clear_screen(); // 清屏
    80000cee:	00000097          	auipc	ra,0x0
    80000cf2:	862080e7          	jalr	-1950(ra) # 80000550 <clear_screen>
	printf("=== 光标移动测试 ===\n");
    80000cf6:	00002517          	auipc	a0,0x2
    80000cfa:	a3a50513          	addi	a0,a0,-1478 # 80002730 <test_physical_memory+0x10de>
    80000cfe:	fffff097          	auipc	ra,0xfffff
    80000d02:	630080e7          	jalr	1584(ra) # 8000032e <printf>
	for (int i = 3; i <= 7; i++) {
    80000d06:	490d                	li	s2,3
		for (int j = 1; j <= 10; j++) {
    80000d08:	4b05                	li	s6,1
			goto_rc(i, j);
			printf("*");
    80000d0a:	00002a17          	auipc	s4,0x2
    80000d0e:	a46a0a13          	addi	s4,s4,-1466 # 80002750 <test_physical_memory+0x10fe>
		for (int j = 1; j <= 10; j++) {
    80000d12:	49ad                	li	s3,11
	for (int i = 3; i <= 7; i++) {
    80000d14:	4aa1                	li	s5,8
		for (int j = 1; j <= 10; j++) {
    80000d16:	84da                	mv	s1,s6
			goto_rc(i, j);
    80000d18:	85a6                	mv	a1,s1
    80000d1a:	854a                	mv	a0,s2
    80000d1c:	00000097          	auipc	ra,0x0
    80000d20:	a48080e7          	jalr	-1464(ra) # 80000764 <goto_rc>
			printf("*");
    80000d24:	8552                	mv	a0,s4
    80000d26:	fffff097          	auipc	ra,0xfffff
    80000d2a:	608080e7          	jalr	1544(ra) # 8000032e <printf>
		for (int j = 1; j <= 10; j++) {
    80000d2e:	2485                	addiw	s1,s1,1
    80000d30:	ff3494e3          	bne	s1,s3,80000d18 <test_curse_move+0x3e>
	for (int i = 3; i <= 7; i++) {
    80000d34:	2905                	addiw	s2,s2,1
    80000d36:	ff5910e3          	bne	s2,s5,80000d16 <test_curse_move+0x3c>
		}
	}
	goto_rc(9, 1);
    80000d3a:	4585                	li	a1,1
    80000d3c:	4525                	li	a0,9
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	a26080e7          	jalr	-1498(ra) # 80000764 <goto_rc>
	save_cursor();
    80000d46:	00000097          	auipc	ra,0x0
    80000d4a:	96a080e7          	jalr	-1686(ra) # 800006b0 <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80000d4e:	4515                	li	a0,5
    80000d50:	00000097          	auipc	ra,0x0
    80000d54:	830080e7          	jalr	-2000(ra) # 80000580 <cursor_up>
	cursor_right(2);
    80000d58:	4509                	li	a0,2
    80000d5a:	00000097          	auipc	ra,0x0
    80000d5e:	8be080e7          	jalr	-1858(ra) # 80000618 <cursor_right>
	printf("+++++");
    80000d62:	00002517          	auipc	a0,0x2
    80000d66:	9f650513          	addi	a0,a0,-1546 # 80002758 <test_physical_memory+0x1106>
    80000d6a:	fffff097          	auipc	ra,0xfffff
    80000d6e:	5c4080e7          	jalr	1476(ra) # 8000032e <printf>
	cursor_down(2);
    80000d72:	4509                	li	a0,2
    80000d74:	00000097          	auipc	ra,0x0
    80000d78:	858080e7          	jalr	-1960(ra) # 800005cc <cursor_down>
	cursor_left(5);
    80000d7c:	4515                	li	a0,5
    80000d7e:	00000097          	auipc	ra,0x0
    80000d82:	8e6080e7          	jalr	-1818(ra) # 80000664 <cursor_left>
	printf("-----");
    80000d86:	00002517          	auipc	a0,0x2
    80000d8a:	9da50513          	addi	a0,a0,-1574 # 80002760 <test_physical_memory+0x110e>
    80000d8e:	fffff097          	auipc	ra,0xfffff
    80000d92:	5a0080e7          	jalr	1440(ra) # 8000032e <printf>
	restore_cursor();
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	94c080e7          	jalr	-1716(ra) # 800006e2 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80000d9e:	00002517          	auipc	a0,0x2
    80000da2:	9ca50513          	addi	a0,a0,-1590 # 80002768 <test_physical_memory+0x1116>
    80000da6:	fffff097          	auipc	ra,0xfffff
    80000daa:	588080e7          	jalr	1416(ra) # 8000032e <printf>
}
    80000dae:	70e2                	ld	ra,56(sp)
    80000db0:	7442                	ld	s0,48(sp)
    80000db2:	74a2                	ld	s1,40(sp)
    80000db4:	7902                	ld	s2,32(sp)
    80000db6:	69e2                	ld	s3,24(sp)
    80000db8:	6a42                	ld	s4,16(sp)
    80000dba:	6aa2                	ld	s5,8(sp)
    80000dbc:	6b02                	ld	s6,0(sp)
    80000dbe:	6121                	addi	sp,sp,64
    80000dc0:	8082                	ret

0000000080000dc2 <test_basic_colors>:

void test_basic_colors(void) {
    80000dc2:	1141                	addi	sp,sp,-16
    80000dc4:	e406                	sd	ra,8(sp)
    80000dc6:	e022                	sd	s0,0(sp)
    80000dc8:	0800                	addi	s0,sp,16
    clear_screen();
    80000dca:	fffff097          	auipc	ra,0xfffff
    80000dce:	786080e7          	jalr	1926(ra) # 80000550 <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    80000dd2:	00002517          	auipc	a0,0x2
    80000dd6:	9be50513          	addi	a0,a0,-1602 # 80002790 <test_physical_memory+0x113e>
    80000dda:	fffff097          	auipc	ra,0xfffff
    80000dde:	554080e7          	jalr	1364(ra) # 8000032e <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80000de2:	00002517          	auipc	a0,0x2
    80000de6:	9ce50513          	addi	a0,a0,-1586 # 800027b0 <test_physical_memory+0x115e>
    80000dea:	fffff097          	auipc	ra,0xfffff
    80000dee:	544080e7          	jalr	1348(ra) # 8000032e <printf>
    color_red();    printf("红色文字 ");
    80000df2:	00000097          	auipc	ra,0x0
    80000df6:	a9c080e7          	jalr	-1380(ra) # 8000088e <color_red>
    80000dfa:	00002517          	auipc	a0,0x2
    80000dfe:	9ce50513          	addi	a0,a0,-1586 # 800027c8 <test_physical_memory+0x1176>
    80000e02:	fffff097          	auipc	ra,0xfffff
    80000e06:	52c080e7          	jalr	1324(ra) # 8000032e <printf>
    color_green();  printf("绿色文字 ");
    80000e0a:	00000097          	auipc	ra,0x0
    80000e0e:	a9e080e7          	jalr	-1378(ra) # 800008a8 <color_green>
    80000e12:	00002517          	auipc	a0,0x2
    80000e16:	9c650513          	addi	a0,a0,-1594 # 800027d8 <test_physical_memory+0x1186>
    80000e1a:	fffff097          	auipc	ra,0xfffff
    80000e1e:	514080e7          	jalr	1300(ra) # 8000032e <printf>
    color_yellow(); printf("黄色文字 ");
    80000e22:	00000097          	auipc	ra,0x0
    80000e26:	aa2080e7          	jalr	-1374(ra) # 800008c4 <color_yellow>
    80000e2a:	00002517          	auipc	a0,0x2
    80000e2e:	9be50513          	addi	a0,a0,-1602 # 800027e8 <test_physical_memory+0x1196>
    80000e32:	fffff097          	auipc	ra,0xfffff
    80000e36:	4fc080e7          	jalr	1276(ra) # 8000032e <printf>
    color_blue();   printf("蓝色文字 ");
    80000e3a:	00000097          	auipc	ra,0x0
    80000e3e:	aa6080e7          	jalr	-1370(ra) # 800008e0 <color_blue>
    80000e42:	00002517          	auipc	a0,0x2
    80000e46:	9b650513          	addi	a0,a0,-1610 # 800027f8 <test_physical_memory+0x11a6>
    80000e4a:	fffff097          	auipc	ra,0xfffff
    80000e4e:	4e4080e7          	jalr	1252(ra) # 8000032e <printf>
    color_purple(); printf("紫色文字 ");
    80000e52:	00000097          	auipc	ra,0x0
    80000e56:	aaa080e7          	jalr	-1366(ra) # 800008fc <color_purple>
    80000e5a:	00002517          	auipc	a0,0x2
    80000e5e:	9ae50513          	addi	a0,a0,-1618 # 80002808 <test_physical_memory+0x11b6>
    80000e62:	fffff097          	auipc	ra,0xfffff
    80000e66:	4cc080e7          	jalr	1228(ra) # 8000032e <printf>
    color_cyan();   printf("青色文字 ");
    80000e6a:	00000097          	auipc	ra,0x0
    80000e6e:	aae080e7          	jalr	-1362(ra) # 80000918 <color_cyan>
    80000e72:	00002517          	auipc	a0,0x2
    80000e76:	9a650513          	addi	a0,a0,-1626 # 80002818 <test_physical_memory+0x11c6>
    80000e7a:	fffff097          	auipc	ra,0xfffff
    80000e7e:	4b4080e7          	jalr	1204(ra) # 8000032e <printf>
    color_reverse();  printf("反色文字");
    80000e82:	00000097          	auipc	ra,0x0
    80000e86:	ab2080e7          	jalr	-1358(ra) # 80000934 <color_reverse>
    80000e8a:	00002517          	auipc	a0,0x2
    80000e8e:	99e50513          	addi	a0,a0,-1634 # 80002828 <test_physical_memory+0x11d6>
    80000e92:	fffff097          	auipc	ra,0xfffff
    80000e96:	49c080e7          	jalr	1180(ra) # 8000032e <printf>
    reset_color();
    80000e9a:	00000097          	auipc	ra,0x0
    80000e9e:	930080e7          	jalr	-1744(ra) # 800007ca <reset_color>
    printf("\n\n");
    80000ea2:	00002517          	auipc	a0,0x2
    80000ea6:	99650513          	addi	a0,a0,-1642 # 80002838 <test_physical_memory+0x11e6>
    80000eaa:	fffff097          	auipc	ra,0xfffff
    80000eae:	484080e7          	jalr	1156(ra) # 8000032e <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80000eb2:	00002517          	auipc	a0,0x2
    80000eb6:	98e50513          	addi	a0,a0,-1650 # 80002840 <test_physical_memory+0x11ee>
    80000eba:	fffff097          	auipc	ra,0xfffff
    80000ebe:	474080e7          	jalr	1140(ra) # 8000032e <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80000ec2:	02900513          	li	a0,41
    80000ec6:	00000097          	auipc	ra,0x0
    80000eca:	976080e7          	jalr	-1674(ra) # 8000083c <set_bg_color>
    80000ece:	00002517          	auipc	a0,0x2
    80000ed2:	98a50513          	addi	a0,a0,-1654 # 80002858 <test_physical_memory+0x1206>
    80000ed6:	fffff097          	auipc	ra,0xfffff
    80000eda:	458080e7          	jalr	1112(ra) # 8000032e <printf>
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	8ec080e7          	jalr	-1812(ra) # 800007ca <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80000ee6:	02a00513          	li	a0,42
    80000eea:	00000097          	auipc	ra,0x0
    80000eee:	952080e7          	jalr	-1710(ra) # 8000083c <set_bg_color>
    80000ef2:	00002517          	auipc	a0,0x2
    80000ef6:	97650513          	addi	a0,a0,-1674 # 80002868 <test_physical_memory+0x1216>
    80000efa:	fffff097          	auipc	ra,0xfffff
    80000efe:	434080e7          	jalr	1076(ra) # 8000032e <printf>
    80000f02:	00000097          	auipc	ra,0x0
    80000f06:	8c8080e7          	jalr	-1848(ra) # 800007ca <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80000f0a:	02b00513          	li	a0,43
    80000f0e:	00000097          	auipc	ra,0x0
    80000f12:	92e080e7          	jalr	-1746(ra) # 8000083c <set_bg_color>
    80000f16:	00002517          	auipc	a0,0x2
    80000f1a:	96250513          	addi	a0,a0,-1694 # 80002878 <test_physical_memory+0x1226>
    80000f1e:	fffff097          	auipc	ra,0xfffff
    80000f22:	410080e7          	jalr	1040(ra) # 8000032e <printf>
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	8a4080e7          	jalr	-1884(ra) # 800007ca <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80000f2e:	02c00513          	li	a0,44
    80000f32:	00000097          	auipc	ra,0x0
    80000f36:	90a080e7          	jalr	-1782(ra) # 8000083c <set_bg_color>
    80000f3a:	00002517          	auipc	a0,0x2
    80000f3e:	94e50513          	addi	a0,a0,-1714 # 80002888 <test_physical_memory+0x1236>
    80000f42:	fffff097          	auipc	ra,0xfffff
    80000f46:	3ec080e7          	jalr	1004(ra) # 8000032e <printf>
    80000f4a:	00000097          	auipc	ra,0x0
    80000f4e:	880080e7          	jalr	-1920(ra) # 800007ca <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80000f52:	02f00513          	li	a0,47
    80000f56:	00000097          	auipc	ra,0x0
    80000f5a:	8e6080e7          	jalr	-1818(ra) # 8000083c <set_bg_color>
    80000f5e:	00002517          	auipc	a0,0x2
    80000f62:	93a50513          	addi	a0,a0,-1734 # 80002898 <test_physical_memory+0x1246>
    80000f66:	fffff097          	auipc	ra,0xfffff
    80000f6a:	3c8080e7          	jalr	968(ra) # 8000032e <printf>
    80000f6e:	00000097          	auipc	ra,0x0
    80000f72:	85c080e7          	jalr	-1956(ra) # 800007ca <reset_color>
    printf("\n\n");
    80000f76:	00002517          	auipc	a0,0x2
    80000f7a:	8c250513          	addi	a0,a0,-1854 # 80002838 <test_physical_memory+0x11e6>
    80000f7e:	fffff097          	auipc	ra,0xfffff
    80000f82:	3b0080e7          	jalr	944(ra) # 8000032e <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80000f86:	00002517          	auipc	a0,0x2
    80000f8a:	92250513          	addi	a0,a0,-1758 # 800028a8 <test_physical_memory+0x1256>
    80000f8e:	fffff097          	auipc	ra,0xfffff
    80000f92:	3a0080e7          	jalr	928(ra) # 8000032e <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80000f96:	02c00593          	li	a1,44
    80000f9a:	457d                	li	a0,31
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	9b4080e7          	jalr	-1612(ra) # 80000950 <set_color>
    80000fa4:	00002517          	auipc	a0,0x2
    80000fa8:	91c50513          	addi	a0,a0,-1764 # 800028c0 <test_physical_memory+0x126e>
    80000fac:	fffff097          	auipc	ra,0xfffff
    80000fb0:	382080e7          	jalr	898(ra) # 8000032e <printf>
    80000fb4:	00000097          	auipc	ra,0x0
    80000fb8:	816080e7          	jalr	-2026(ra) # 800007ca <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80000fbc:	02d00593          	li	a1,45
    80000fc0:	02100513          	li	a0,33
    80000fc4:	00000097          	auipc	ra,0x0
    80000fc8:	98c080e7          	jalr	-1652(ra) # 80000950 <set_color>
    80000fcc:	00002517          	auipc	a0,0x2
    80000fd0:	90450513          	addi	a0,a0,-1788 # 800028d0 <test_physical_memory+0x127e>
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	35a080e7          	jalr	858(ra) # 8000032e <printf>
    80000fdc:	fffff097          	auipc	ra,0xfffff
    80000fe0:	7ee080e7          	jalr	2030(ra) # 800007ca <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80000fe4:	02f00593          	li	a1,47
    80000fe8:	02000513          	li	a0,32
    80000fec:	00000097          	auipc	ra,0x0
    80000ff0:	964080e7          	jalr	-1692(ra) # 80000950 <set_color>
    80000ff4:	00002517          	auipc	a0,0x2
    80000ff8:	8ec50513          	addi	a0,a0,-1812 # 800028e0 <test_physical_memory+0x128e>
    80000ffc:	fffff097          	auipc	ra,0xfffff
    80001000:	332080e7          	jalr	818(ra) # 8000032e <printf>
    80001004:	fffff097          	auipc	ra,0xfffff
    80001008:	7c6080e7          	jalr	1990(ra) # 800007ca <reset_color>
    printf("\n\n");
    8000100c:	00002517          	auipc	a0,0x2
    80001010:	82c50513          	addi	a0,a0,-2004 # 80002838 <test_physical_memory+0x11e6>
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	31a080e7          	jalr	794(ra) # 8000032e <printf>
	reset_color();
    8000101c:	fffff097          	auipc	ra,0xfffff
    80001020:	7ae080e7          	jalr	1966(ra) # 800007ca <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80001024:	00002517          	auipc	a0,0x2
    80001028:	8cc50513          	addi	a0,a0,-1844 # 800028f0 <test_physical_memory+0x129e>
    8000102c:	fffff097          	auipc	ra,0xfffff
    80001030:	302080e7          	jalr	770(ra) # 8000032e <printf>
	cursor_up(1); // 光标上移一行
    80001034:	4505                	li	a0,1
    80001036:	fffff097          	auipc	ra,0xfffff
    8000103a:	54a080e7          	jalr	1354(ra) # 80000580 <cursor_up>
	clear_line();
    8000103e:	00000097          	auipc	ra,0x0
    80001042:	93c080e7          	jalr	-1732(ra) # 8000097a <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80001046:	00002517          	auipc	a0,0x2
    8000104a:	8e250513          	addi	a0,a0,-1822 # 80002928 <test_physical_memory+0x12d6>
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	2e0080e7          	jalr	736(ra) # 8000032e <printf>
    80001056:	60a2                	ld	ra,8(sp)
    80001058:	6402                	ld	s0,0(sp)
    8000105a:	0141                	addi	sp,sp,16
    8000105c:	8082                	ret

000000008000105e <memset>:
#include "mem.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    8000105e:	1141                	addi	sp,sp,-16
    80001060:	e422                	sd	s0,8(sp)
    80001062:	0800                	addi	s0,sp,16
    unsigned char *p = dst;
    while (n-- > 0)
    80001064:	ca01                	beqz	a2,80001074 <memset+0x16>
    80001066:	962a                	add	a2,a2,a0
    unsigned char *p = dst;
    80001068:	87aa                	mv	a5,a0
        *p++ = (unsigned char)c;
    8000106a:	0785                	addi	a5,a5,1
    8000106c:	feb78fa3          	sb	a1,-1(a5)
    while (n-- > 0)
    80001070:	fef61de3          	bne	a2,a5,8000106a <memset+0xc>
    return dst;
    80001074:	6422                	ld	s0,8(sp)
    80001076:	0141                	addi	sp,sp,16
    80001078:	8082                	ret

000000008000107a <create_pagetable>:
static inline uint64 px(int level, uint64 va) {
    return VPN_MASK(va, level);
}

// 创建空页表
pagetable_t create_pagetable(void) {
    8000107a:	1101                	addi	sp,sp,-32
    8000107c:	ec06                	sd	ra,24(sp)
    8000107e:	e822                	sd	s0,16(sp)
    80001080:	e426                	sd	s1,8(sp)
    80001082:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    80001084:	00000097          	auipc	ra,0x0
    80001088:	4ea080e7          	jalr	1258(ra) # 8000156e <alloc_page>
    8000108c:	84aa                	mv	s1,a0
    if (!pt)
    8000108e:	c519                	beqz	a0,8000109c <create_pagetable+0x22>
        return 0;
    memset(pt, 0, PGSIZE);
    80001090:	6605                	lui	a2,0x1
    80001092:	4581                	li	a1,0
    80001094:	00000097          	auipc	ra,0x0
    80001098:	fca080e7          	jalr	-54(ra) # 8000105e <memset>
    return pt;
}
    8000109c:	8526                	mv	a0,s1
    8000109e:	60e2                	ld	ra,24(sp)
    800010a0:	6442                	ld	s0,16(sp)
    800010a2:	64a2                	ld	s1,8(sp)
    800010a4:	6105                	addi	sp,sp,32
    800010a6:	8082                	ret

00000000800010a8 <map_page>:
    }
    return &pt[px(0, va)];
}

// 建立映射
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    800010a8:	715d                	addi	sp,sp,-80
    800010aa:	e486                	sd	ra,72(sp)
    800010ac:	e0a2                	sd	s0,64(sp)
    800010ae:	fc26                	sd	s1,56(sp)
    800010b0:	f84a                	sd	s2,48(sp)
    800010b2:	f44e                	sd	s3,40(sp)
    800010b4:	f052                	sd	s4,32(sp)
    800010b6:	ec56                	sd	s5,24(sp)
    800010b8:	e85a                	sd	s6,16(sp)
    800010ba:	e45e                	sd	s7,8(sp)
    800010bc:	0880                	addi	s0,sp,80
    800010be:	84aa                	mv	s1,a0
    800010c0:	8aae                	mv	s5,a1
    800010c2:	89b2                	mv	s3,a2
    800010c4:	8a36                	mv	s4,a3
    if ((va % PGSIZE) != 0)
    800010c6:	03459793          	slli	a5,a1,0x34
    800010ca:	e7b5                	bnez	a5,80001136 <map_page+0x8e>
    if (va >= MAXVA)
    800010cc:	57fd                	li	a5,-1
    800010ce:	83e5                	srli	a5,a5,0x19
    800010d0:	0757ec63          	bltu	a5,s5,80001148 <map_page+0xa0>
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    800010d4:	4b79                	li	s6,30
    for (int level = 2; level > 0; level--) {
    800010d6:	4bb1                	li	s7,12
    return VPN_MASK(va, level);
    800010d8:	016ad933          	srl	s2,s5,s6
    800010dc:	1ff97913          	andi	s2,s2,511
        pte_t *pte = &pt[px(level, va)];
    800010e0:	090e                	slli	s2,s2,0x3
    800010e2:	9926                	add	s2,s2,s1
        if (*pte & PTE_V) {
    800010e4:	00093483          	ld	s1,0(s2)
    800010e8:	0014f793          	andi	a5,s1,1
    800010ec:	c7bd                	beqz	a5,8000115a <map_page+0xb2>
            pt = (pagetable_t)PTE2PA(*pte);
    800010ee:	80a9                	srli	s1,s1,0xa
    800010f0:	04b2                	slli	s1,s1,0xc
    for (int level = 2; level > 0; level--) {
    800010f2:	3b5d                	addiw	s6,s6,-9
    800010f4:	ff7b12e3          	bne	s6,s7,800010d8 <map_page+0x30>
    return VPN_MASK(va, level);
    800010f8:	00cad593          	srli	a1,s5,0xc
    800010fc:	1ff5f593          	andi	a1,a1,511
    return &pt[px(0, va)];
    80001100:	058e                	slli	a1,a1,0x3
    80001102:	94ae                	add	s1,s1,a1
        panic("map_page: va not aligned");
    pte_t *pte = walk_create(pt, va);
    if (!pte)
    80001104:	c8d1                	beqz	s1,80001198 <map_page+0xf0>
        return -1;
    if (*pte & PTE_V)
    80001106:	609c                	ld	a5,0(s1)
    80001108:	8b85                	andi	a5,a5,1
    8000110a:	efa5                	bnez	a5,80001182 <map_page+0xda>
        panic("map_page: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000110c:	00c9d993          	srli	s3,s3,0xc
    80001110:	09aa                	slli	s3,s3,0xa
    80001112:	0149e9b3          	or	s3,s3,s4
    80001116:	0019e993          	ori	s3,s3,1
    8000111a:	0134b023          	sd	s3,0(s1)
    return 0;
    8000111e:	4501                	li	a0,0
}
    80001120:	60a6                	ld	ra,72(sp)
    80001122:	6406                	ld	s0,64(sp)
    80001124:	74e2                	ld	s1,56(sp)
    80001126:	7942                	ld	s2,48(sp)
    80001128:	79a2                	ld	s3,40(sp)
    8000112a:	7a02                	ld	s4,32(sp)
    8000112c:	6ae2                	ld	s5,24(sp)
    8000112e:	6b42                	ld	s6,16(sp)
    80001130:	6ba2                	ld	s7,8(sp)
    80001132:	6161                	addi	sp,sp,80
    80001134:	8082                	ret
        panic("map_page: va not aligned");
    80001136:	00002517          	auipc	a0,0x2
    8000113a:	81250513          	addi	a0,a0,-2030 # 80002948 <test_physical_memory+0x12f6>
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	87a080e7          	jalr	-1926(ra) # 800009b8 <panic>
    80001146:	b759                	j	800010cc <map_page+0x24>
        panic("walk_create: va out of range");
    80001148:	00002517          	auipc	a0,0x2
    8000114c:	82050513          	addi	a0,a0,-2016 # 80002968 <test_physical_memory+0x1316>
    80001150:	00000097          	auipc	ra,0x0
    80001154:	868080e7          	jalr	-1944(ra) # 800009b8 <panic>
    80001158:	bfb5                	j	800010d4 <map_page+0x2c>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	414080e7          	jalr	1044(ra) # 8000156e <alloc_page>
    80001162:	84aa                	mv	s1,a0
            if (!new_pt)
    80001164:	c905                	beqz	a0,80001194 <map_page+0xec>
            memset(new_pt, 0, PGSIZE);
    80001166:	6605                	lui	a2,0x1
    80001168:	4581                	li	a1,0
    8000116a:	00000097          	auipc	ra,0x0
    8000116e:	ef4080e7          	jalr	-268(ra) # 8000105e <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    80001172:	00c4d793          	srli	a5,s1,0xc
    80001176:	07aa                	slli	a5,a5,0xa
    80001178:	0017e793          	ori	a5,a5,1
    8000117c:	00f93023          	sd	a5,0(s2)
            pt = new_pt;
    80001180:	bf8d                	j	800010f2 <map_page+0x4a>
        panic("map_page: remap");
    80001182:	00002517          	auipc	a0,0x2
    80001186:	80650513          	addi	a0,a0,-2042 # 80002988 <test_physical_memory+0x1336>
    8000118a:	00000097          	auipc	ra,0x0
    8000118e:	82e080e7          	jalr	-2002(ra) # 800009b8 <panic>
    80001192:	bfad                	j	8000110c <map_page+0x64>
        return -1;
    80001194:	557d                	li	a0,-1
    80001196:	b769                	j	80001120 <map_page+0x78>
    80001198:	557d                	li	a0,-1
    8000119a:	b759                	j	80001120 <map_page+0x78>

000000008000119c <free_pagetable>:
// 递归释放页表
void free_pagetable(pagetable_t pt) {
    8000119c:	7179                	addi	sp,sp,-48
    8000119e:	f406                	sd	ra,40(sp)
    800011a0:	f022                	sd	s0,32(sp)
    800011a2:	ec26                	sd	s1,24(sp)
    800011a4:	e84a                	sd	s2,16(sp)
    800011a6:	e44e                	sd	s3,8(sp)
    800011a8:	e052                	sd	s4,0(sp)
    800011aa:	1800                	addi	s0,sp,48
    800011ac:	8a2a                	mv	s4,a0
    for (int i = 0; i < 512; i++) {
    800011ae:	84aa                	mv	s1,a0
    800011b0:	6905                	lui	s2,0x1
    800011b2:	992a                	add	s2,s2,a0
        pte_t pte = pt[i];
        // 只释放中间页表
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    800011b4:	4985                	li	s3,1
    800011b6:	a829                	j	800011d0 <free_pagetable+0x34>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    800011b8:	83a9                	srli	a5,a5,0xa
            free_pagetable(child);
    800011ba:	00c79513          	slli	a0,a5,0xc
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	fde080e7          	jalr	-34(ra) # 8000119c <free_pagetable>
            pt[i] = 0;
    800011c6:	0004b023          	sd	zero,0(s1)
    for (int i = 0; i < 512; i++) {
    800011ca:	04a1                	addi	s1,s1,8
    800011cc:	01248f63          	beq	s1,s2,800011ea <free_pagetable+0x4e>
        pte_t pte = pt[i];
    800011d0:	609c                	ld	a5,0(s1)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    800011d2:	00f7f713          	andi	a4,a5,15
    800011d6:	ff3701e3          	beq	a4,s3,800011b8 <free_pagetable+0x1c>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    800011da:	0017f713          	andi	a4,a5,1
    800011de:	d775                	beqz	a4,800011ca <free_pagetable+0x2e>
    800011e0:	8bb9                	andi	a5,a5,14
    800011e2:	d7e5                	beqz	a5,800011ca <free_pagetable+0x2e>
            pt[i] = 0;
    800011e4:	0004b023          	sd	zero,0(s1)
    800011e8:	b7cd                	j	800011ca <free_pagetable+0x2e>
        }
    }
    free_page(pt);
    800011ea:	8552                	mv	a0,s4
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	3d0080e7          	jalr	976(ra) # 800015bc <free_page>
}
    800011f4:	70a2                	ld	ra,40(sp)
    800011f6:	7402                	ld	s0,32(sp)
    800011f8:	64e2                	ld	s1,24(sp)
    800011fa:	6942                	ld	s2,16(sp)
    800011fc:	69a2                	ld	s3,8(sp)
    800011fe:	6a02                	ld	s4,0(sp)
    80001200:	6145                	addi	sp,sp,48
    80001202:	8082                	ret

0000000080001204 <kvminit>:

    return kpgtbl;
}

// 初始化内核页表
void kvminit(void) {
    80001204:	7139                	addi	sp,sp,-64
    80001206:	fc06                	sd	ra,56(sp)
    80001208:	f822                	sd	s0,48(sp)
    8000120a:	f426                	sd	s1,40(sp)
    8000120c:	f04a                	sd	s2,32(sp)
    8000120e:	ec4e                	sd	s3,24(sp)
    80001210:	e852                	sd	s4,16(sp)
    80001212:	e456                	sd	s5,8(sp)
    80001214:	0080                	addi	s0,sp,64
    pagetable_t kpgtbl = create_pagetable();
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	e64080e7          	jalr	-412(ra) # 8000107a <create_pagetable>
    8000121e:	892a                	mv	s2,a0
    if (!kpgtbl)
    80001220:	c919                	beqz	a0,80001236 <kvminit+0x32>
void kvminit(void) {
    80001222:	4485                	li	s1,1
    80001224:	04fe                	slli	s1,s1,0x1f
            panic("kvmmake: map_page failed");
    80001226:	00001a97          	auipc	s5,0x1
    8000122a:	78aa8a93          	addi	s5,s5,1930 # 800029b0 <test_physical_memory+0x135e>
    for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    8000122e:	6a05                	lui	s4,0x1
    80001230:	49c5                	li	s3,17
    80001232:	09ee                	slli	s3,s3,0x1b
    80001234:	a829                	j	8000124e <kvminit+0x4a>
        panic("kvmmake: alloc failed");
    80001236:	00001517          	auipc	a0,0x1
    8000123a:	76250513          	addi	a0,a0,1890 # 80002998 <test_physical_memory+0x1346>
    8000123e:	fffff097          	auipc	ra,0xfffff
    80001242:	77a080e7          	jalr	1914(ra) # 800009b8 <panic>
    80001246:	bff1                	j	80001222 <kvminit+0x1e>
    for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    80001248:	94d2                	add	s1,s1,s4
    8000124a:	03348163          	beq	s1,s3,8000126c <kvminit+0x68>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W | PTE_X) != 0)
    8000124e:	46b9                	li	a3,14
    80001250:	8626                	mv	a2,s1
    80001252:	85a6                	mv	a1,s1
    80001254:	854a                	mv	a0,s2
    80001256:	00000097          	auipc	ra,0x0
    8000125a:	e52080e7          	jalr	-430(ra) # 800010a8 <map_page>
    8000125e:	d56d                	beqz	a0,80001248 <kvminit+0x44>
            panic("kvmmake: map_page failed");
    80001260:	8556                	mv	a0,s5
    80001262:	fffff097          	auipc	ra,0xfffff
    80001266:	756080e7          	jalr	1878(ra) # 800009b8 <panic>
    8000126a:	bff9                	j	80001248 <kvminit+0x44>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    8000126c:	4699                	li	a3,6
    8000126e:	10000637          	lui	a2,0x10000
    80001272:	100005b7          	lui	a1,0x10000
    80001276:	854a                	mv	a0,s2
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	e30080e7          	jalr	-464(ra) # 800010a8 <map_page>
    80001280:	ed11                	bnez	a0,8000129c <kvminit+0x98>
    kernel_pagetable = kvmmake();
    80001282:	00004797          	auipc	a5,0x4
    80001286:	d927b723          	sd	s2,-626(a5) # 80005010 <kernel_pagetable>
}
    8000128a:	70e2                	ld	ra,56(sp)
    8000128c:	7442                	ld	s0,48(sp)
    8000128e:	74a2                	ld	s1,40(sp)
    80001290:	7902                	ld	s2,32(sp)
    80001292:	69e2                	ld	s3,24(sp)
    80001294:	6a42                	ld	s4,16(sp)
    80001296:	6aa2                	ld	s5,8(sp)
    80001298:	6121                	addi	sp,sp,64
    8000129a:	8082                	ret
        panic("kvmmake: uart map_page failed");
    8000129c:	00001517          	auipc	a0,0x1
    800012a0:	73450513          	addi	a0,a0,1844 # 800029d0 <test_physical_memory+0x137e>
    800012a4:	fffff097          	auipc	ra,0xfffff
    800012a8:	714080e7          	jalr	1812(ra) # 800009b8 <panic>
    800012ac:	bfd9                	j	80001282 <kvminit+0x7e>

00000000800012ae <kvminithart>:

static inline void sfence_vma(void) {
    asm volatile("sfence.vma zero, zero");
}

void kvminithart(void) {
    800012ae:	1141                	addi	sp,sp,-16
    800012b0:	e422                	sd	s0,8(sp)
    800012b2:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    800012b4:	12000073          	sfence.vma
    sfence_vma();
    w_satp(MAKE_SATP(kernel_pagetable));
    800012b8:	00004797          	auipc	a5,0x4
    800012bc:	d587b783          	ld	a5,-680(a5) # 80005010 <kernel_pagetable>
    800012c0:	83b1                	srli	a5,a5,0xc
    800012c2:	577d                	li	a4,-1
    800012c4:	177e                	slli	a4,a4,0x3f
    800012c6:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r"(x));
    800012c8:	18079073          	csrw	satp,a5
    asm volatile("sfence.vma zero, zero");
    800012cc:	12000073          	sfence.vma
    sfence_vma();
}
    800012d0:	6422                	ld	s0,8(sp)
    800012d2:	0141                	addi	sp,sp,16
    800012d4:	8082                	ret

00000000800012d6 <test_pagetable>:

void test_pagetable(void) {
    800012d6:	7179                	addi	sp,sp,-48
    800012d8:	f406                	sd	ra,40(sp)
    800012da:	f022                	sd	s0,32(sp)
    800012dc:	ec26                	sd	s1,24(sp)
    800012de:	e84a                	sd	s2,16(sp)
    800012e0:	e44e                	sd	s3,8(sp)
    800012e2:	e052                	sd	s4,0(sp)
    800012e4:	1800                	addi	s0,sp,48
    printf("[PT TEST] 创建页表...\n");
    800012e6:	00001517          	auipc	a0,0x1
    800012ea:	70a50513          	addi	a0,a0,1802 # 800029f0 <test_physical_memory+0x139e>
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	040080e7          	jalr	64(ra) # 8000032e <printf>
    pagetable_t pt = create_pagetable();
    800012f6:	00000097          	auipc	ra,0x0
    800012fa:	d84080e7          	jalr	-636(ra) # 8000107a <create_pagetable>
    800012fe:	892a                	mv	s2,a0
#include "printf.h"

static inline void assert(int expr) {
    if (!expr) {
    80001300:	c17d                	beqz	a0,800013e6 <test_pagetable+0x110>
    assert(pt != 0);
    printf("[PT TEST] 页表创建通过\n");
    80001302:	00001517          	auipc	a0,0x1
    80001306:	74e50513          	addi	a0,a0,1870 # 80002a50 <test_physical_memory+0x13fe>
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	024080e7          	jalr	36(ra) # 8000032e <printf>

    // 测试基本映射
    uint64 va = 0x1000000;
    uint64 pa = (uint64)alloc_page();
    80001312:	00000097          	auipc	ra,0x0
    80001316:	25c080e7          	jalr	604(ra) # 8000156e <alloc_page>
    8000131a:	89aa                	mv	s3,a0
    8000131c:	8a2a                	mv	s4,a0
    8000131e:	c975                	beqz	a0,80001412 <test_pagetable+0x13c>
    assert(pa != 0);
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0);
    80001320:	4699                	li	a3,6
    80001322:	864e                	mv	a2,s3
    80001324:	010005b7          	lui	a1,0x1000
    80001328:	854a                	mv	a0,s2
    8000132a:	00000097          	auipc	ra,0x0
    8000132e:	d7e080e7          	jalr	-642(ra) # 800010a8 <map_page>
    80001332:	10051663          	bnez	a0,8000143e <test_pagetable+0x168>
    printf("[PT TEST] 映射测试通过\n");
    80001336:	00001517          	auipc	a0,0x1
    8000133a:	73a50513          	addi	a0,a0,1850 # 80002a70 <test_physical_memory+0x141e>
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	ff0080e7          	jalr	-16(ra) # 8000032e <printf>
        if (*pte & PTE_V) {
    80001346:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    8000134a:	0017f713          	andi	a4,a5,1
    8000134e:	10070e63          	beqz	a4,8000146a <test_pagetable+0x194>
            pt = (pagetable_t)PTE2PA(*pte);
    80001352:	83a9                	srli	a5,a5,0xa
    80001354:	07b2                	slli	a5,a5,0xc
        if (*pte & PTE_V) {
    80001356:	63a4                	ld	s1,64(a5)
    80001358:	0014f793          	andi	a5,s1,1
    8000135c:	12078e63          	beqz	a5,80001498 <test_pagetable+0x1c2>
            pt = (pagetable_t)PTE2PA(*pte);
    80001360:	80a9                	srli	s1,s1,0xa
    80001362:	04b2                	slli	s1,s1,0xc

    // 测试地址转换
    pte_t *pte = walk_lookup(pt, va);
    assert(pte != 0 && (*pte & PTE_V));
    80001364:	10048463          	beqz	s1,8000146c <test_pagetable+0x196>
    80001368:	609c                	ld	a5,0(s1)
    8000136a:	8b85                	andi	a5,a5,1
    8000136c:	10078063          	beqz	a5,8000146c <test_pagetable+0x196>
    assert(PTE2PA(*pte) == pa);
    80001370:	609c                	ld	a5,0(s1)
    80001372:	83a9                	srli	a5,a5,0xa
    80001374:	07b2                	slli	a5,a5,0xc
    80001376:	13479363          	bne	a5,s4,8000149c <test_pagetable+0x1c6>
    printf("[PT TEST] 地址转换测试通过\n");
    8000137a:	00001517          	auipc	a0,0x1
    8000137e:	71650513          	addi	a0,a0,1814 # 80002a90 <test_physical_memory+0x143e>
    80001382:	fffff097          	auipc	ra,0xfffff
    80001386:	fac080e7          	jalr	-84(ra) # 8000032e <printf>

    // 测试权限位
    assert(*pte & PTE_R);
    8000138a:	609c                	ld	a5,0(s1)
    8000138c:	8b89                	andi	a5,a5,2
    8000138e:	12078d63          	beqz	a5,800014c8 <test_pagetable+0x1f2>
    assert(*pte & PTE_W);
    80001392:	609c                	ld	a5,0(s1)
    80001394:	8b91                	andi	a5,a5,4
    80001396:	14078f63          	beqz	a5,800014f4 <test_pagetable+0x21e>
    assert(!(*pte & PTE_X));
    8000139a:	609c                	ld	a5,0(s1)
    8000139c:	8ba1                	andi	a5,a5,8
    8000139e:	18079163          	bnez	a5,80001520 <test_pagetable+0x24a>
    printf("[PT TEST] 权限测试通过\n");
    800013a2:	00001517          	auipc	a0,0x1
    800013a6:	71650513          	addi	a0,a0,1814 # 80002ab8 <test_physical_memory+0x1466>
    800013aa:	fffff097          	auipc	ra,0xfffff
    800013ae:	f84080e7          	jalr	-124(ra) # 8000032e <printf>

    // 清理
    free_page((void*)pa);
    800013b2:	854e                	mv	a0,s3
    800013b4:	00000097          	auipc	ra,0x0
    800013b8:	208080e7          	jalr	520(ra) # 800015bc <free_page>
    free_pagetable(pt);
    800013bc:	854a                	mv	a0,s2
    800013be:	00000097          	auipc	ra,0x0
    800013c2:	dde080e7          	jalr	-546(ra) # 8000119c <free_pagetable>

    printf("[PT TEST] 所有页表测试通过\n");
    800013c6:	00001517          	auipc	a0,0x1
    800013ca:	71250513          	addi	a0,a0,1810 # 80002ad8 <test_physical_memory+0x1486>
    800013ce:	fffff097          	auipc	ra,0xfffff
    800013d2:	f60080e7          	jalr	-160(ra) # 8000032e <printf>
    800013d6:	70a2                	ld	ra,40(sp)
    800013d8:	7402                	ld	s0,32(sp)
    800013da:	64e2                	ld	s1,24(sp)
    800013dc:	6942                	ld	s2,16(sp)
    800013de:	69a2                	ld	s3,8(sp)
    800013e0:	6a02                	ld	s4,0(sp)
    800013e2:	6145                	addi	sp,sp,48
    800013e4:	8082                	ret
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    800013e6:	4615                	li	a2,5
    800013e8:	00001597          	auipc	a1,0x1
    800013ec:	62858593          	addi	a1,a1,1576 # 80002a10 <test_physical_memory+0x13be>
    800013f0:	00001517          	auipc	a0,0x1
    800013f4:	63050513          	addi	a0,a0,1584 # 80002a20 <test_physical_memory+0x13ce>
    800013f8:	fffff097          	auipc	ra,0xfffff
    800013fc:	f36080e7          	jalr	-202(ra) # 8000032e <printf>
        panic("assert");
    80001400:	00001517          	auipc	a0,0x1
    80001404:	64850513          	addi	a0,a0,1608 # 80002a48 <test_physical_memory+0x13f6>
    80001408:	fffff097          	auipc	ra,0xfffff
    8000140c:	5b0080e7          	jalr	1456(ra) # 800009b8 <panic>
    80001410:	bdcd                	j	80001302 <test_pagetable+0x2c>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80001412:	4615                	li	a2,5
    80001414:	00001597          	auipc	a1,0x1
    80001418:	5fc58593          	addi	a1,a1,1532 # 80002a10 <test_physical_memory+0x13be>
    8000141c:	00001517          	auipc	a0,0x1
    80001420:	60450513          	addi	a0,a0,1540 # 80002a20 <test_physical_memory+0x13ce>
    80001424:	fffff097          	auipc	ra,0xfffff
    80001428:	f0a080e7          	jalr	-246(ra) # 8000032e <printf>
        panic("assert");
    8000142c:	00001517          	auipc	a0,0x1
    80001430:	61c50513          	addi	a0,a0,1564 # 80002a48 <test_physical_memory+0x13f6>
    80001434:	fffff097          	auipc	ra,0xfffff
    80001438:	584080e7          	jalr	1412(ra) # 800009b8 <panic>
    8000143c:	b5d5                	j	80001320 <test_pagetable+0x4a>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    8000143e:	4615                	li	a2,5
    80001440:	00001597          	auipc	a1,0x1
    80001444:	5d058593          	addi	a1,a1,1488 # 80002a10 <test_physical_memory+0x13be>
    80001448:	00001517          	auipc	a0,0x1
    8000144c:	5d850513          	addi	a0,a0,1496 # 80002a20 <test_physical_memory+0x13ce>
    80001450:	fffff097          	auipc	ra,0xfffff
    80001454:	ede080e7          	jalr	-290(ra) # 8000032e <printf>
        panic("assert");
    80001458:	00001517          	auipc	a0,0x1
    8000145c:	5f050513          	addi	a0,a0,1520 # 80002a48 <test_physical_memory+0x13f6>
    80001460:	fffff097          	auipc	ra,0xfffff
    80001464:	558080e7          	jalr	1368(ra) # 800009b8 <panic>
    80001468:	b5f9                	j	80001336 <test_pagetable+0x60>
        if (*pte & PTE_V) {
    8000146a:	4481                	li	s1,0
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    8000146c:	4615                	li	a2,5
    8000146e:	00001597          	auipc	a1,0x1
    80001472:	5a258593          	addi	a1,a1,1442 # 80002a10 <test_physical_memory+0x13be>
    80001476:	00001517          	auipc	a0,0x1
    8000147a:	5aa50513          	addi	a0,a0,1450 # 80002a20 <test_physical_memory+0x13ce>
    8000147e:	fffff097          	auipc	ra,0xfffff
    80001482:	eb0080e7          	jalr	-336(ra) # 8000032e <printf>
        panic("assert");
    80001486:	00001517          	auipc	a0,0x1
    8000148a:	5c250513          	addi	a0,a0,1474 # 80002a48 <test_physical_memory+0x13f6>
    8000148e:	fffff097          	auipc	ra,0xfffff
    80001492:	52a080e7          	jalr	1322(ra) # 800009b8 <panic>
    80001496:	bde9                	j	80001370 <test_pagetable+0x9a>
    80001498:	4481                	li	s1,0
    8000149a:	bfc9                	j	8000146c <test_pagetable+0x196>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    8000149c:	4615                	li	a2,5
    8000149e:	00001597          	auipc	a1,0x1
    800014a2:	57258593          	addi	a1,a1,1394 # 80002a10 <test_physical_memory+0x13be>
    800014a6:	00001517          	auipc	a0,0x1
    800014aa:	57a50513          	addi	a0,a0,1402 # 80002a20 <test_physical_memory+0x13ce>
    800014ae:	fffff097          	auipc	ra,0xfffff
    800014b2:	e80080e7          	jalr	-384(ra) # 8000032e <printf>
        panic("assert");
    800014b6:	00001517          	auipc	a0,0x1
    800014ba:	59250513          	addi	a0,a0,1426 # 80002a48 <test_physical_memory+0x13f6>
    800014be:	fffff097          	auipc	ra,0xfffff
    800014c2:	4fa080e7          	jalr	1274(ra) # 800009b8 <panic>
    800014c6:	bd55                	j	8000137a <test_pagetable+0xa4>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    800014c8:	4615                	li	a2,5
    800014ca:	00001597          	auipc	a1,0x1
    800014ce:	54658593          	addi	a1,a1,1350 # 80002a10 <test_physical_memory+0x13be>
    800014d2:	00001517          	auipc	a0,0x1
    800014d6:	54e50513          	addi	a0,a0,1358 # 80002a20 <test_physical_memory+0x13ce>
    800014da:	fffff097          	auipc	ra,0xfffff
    800014de:	e54080e7          	jalr	-428(ra) # 8000032e <printf>
        panic("assert");
    800014e2:	00001517          	auipc	a0,0x1
    800014e6:	56650513          	addi	a0,a0,1382 # 80002a48 <test_physical_memory+0x13f6>
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	4ce080e7          	jalr	1230(ra) # 800009b8 <panic>
    800014f2:	b545                	j	80001392 <test_pagetable+0xbc>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    800014f4:	4615                	li	a2,5
    800014f6:	00001597          	auipc	a1,0x1
    800014fa:	51a58593          	addi	a1,a1,1306 # 80002a10 <test_physical_memory+0x13be>
    800014fe:	00001517          	auipc	a0,0x1
    80001502:	52250513          	addi	a0,a0,1314 # 80002a20 <test_physical_memory+0x13ce>
    80001506:	fffff097          	auipc	ra,0xfffff
    8000150a:	e28080e7          	jalr	-472(ra) # 8000032e <printf>
        panic("assert");
    8000150e:	00001517          	auipc	a0,0x1
    80001512:	53a50513          	addi	a0,a0,1338 # 80002a48 <test_physical_memory+0x13f6>
    80001516:	fffff097          	auipc	ra,0xfffff
    8000151a:	4a2080e7          	jalr	1186(ra) # 800009b8 <panic>
    8000151e:	bdb5                	j	8000139a <test_pagetable+0xc4>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80001520:	4615                	li	a2,5
    80001522:	00001597          	auipc	a1,0x1
    80001526:	4ee58593          	addi	a1,a1,1262 # 80002a10 <test_physical_memory+0x13be>
    8000152a:	00001517          	auipc	a0,0x1
    8000152e:	4f650513          	addi	a0,a0,1270 # 80002a20 <test_physical_memory+0x13ce>
    80001532:	fffff097          	auipc	ra,0xfffff
    80001536:	dfc080e7          	jalr	-516(ra) # 8000032e <printf>
        panic("assert");
    8000153a:	00001517          	auipc	a0,0x1
    8000153e:	50e50513          	addi	a0,a0,1294 # 80002a48 <test_physical_memory+0x13f6>
    80001542:	fffff097          	auipc	ra,0xfffff
    80001546:	476080e7          	jalr	1142(ra) # 800009b8 <panic>
    8000154a:	bda1                	j	800013a2 <test_pagetable+0xcc>

000000008000154c <get_free_page_count>:

static struct run *freelist = 0;
//static int free_page_num = 0;

// 统计空闲页数量
int  get_free_page_count() {
    8000154c:	1141                	addi	sp,sp,-16
    8000154e:	e422                	sd	s0,8(sp)
    80001550:	0800                	addi	s0,sp,16
	struct run *r = freelist;
    80001552:	00004797          	auipc	a5,0x4
    80001556:	ac67b783          	ld	a5,-1338(a5) # 80005018 <freelist>
	int count = 0;
	while (r) {
    8000155a:	cb81                	beqz	a5,8000156a <get_free_page_count+0x1e>
	int count = 0;
    8000155c:	4501                	li	a0,0
		count++;
    8000155e:	2505                	addiw	a0,a0,1
		r = r->next;
    80001560:	639c                	ld	a5,0(a5)
	while (r) {
    80001562:	fff5                	bnez	a5,8000155e <get_free_page_count+0x12>
	}
	return count;
}
    80001564:	6422                	ld	s0,8(sp)
    80001566:	0141                	addi	sp,sp,16
    80001568:	8082                	ret
	int count = 0;
    8000156a:	4501                	li	a0,0
    8000156c:	bfe5                	j	80001564 <get_free_page_count+0x18>

000000008000156e <alloc_page>:

void pmm_init(void) {
  freerange(end, (void*)PHYSTOP);
}

void* alloc_page(void) {
    8000156e:	1101                	addi	sp,sp,-32
    80001570:	ec06                	sd	ra,24(sp)
    80001572:	e822                	sd	s0,16(sp)
    80001574:	e426                	sd	s1,8(sp)
    80001576:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80001578:	00004497          	auipc	s1,0x4
    8000157c:	aa04b483          	ld	s1,-1376(s1) # 80005018 <freelist>
  if(r)
    80001580:	c48d                	beqz	s1,800015aa <alloc_page+0x3c>
    freelist = r->next;
    80001582:	609c                	ld	a5,0(s1)
    80001584:	00004717          	auipc	a4,0x4
    80001588:	a8f73a23          	sd	a5,-1388(a4) # 80005018 <freelist>
  if(r)
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    8000158c:	6605                	lui	a2,0x1
    8000158e:	1661                	addi	a2,a2,-8 # ff8 <_entry-0x7ffff008>
    80001590:	4595                	li	a1,5
    80001592:	00848513          	addi	a0,s1,8
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	ac8080e7          	jalr	-1336(ra) # 8000105e <memset>
  else
    panic("alloc_page: out of memory");
  return (void*)r;
}
    8000159e:	8526                	mv	a0,s1
    800015a0:	60e2                	ld	ra,24(sp)
    800015a2:	6442                	ld	s0,16(sp)
    800015a4:	64a2                	ld	s1,8(sp)
    800015a6:	6105                	addi	sp,sp,32
    800015a8:	8082                	ret
    panic("alloc_page: out of memory");
    800015aa:	00001517          	auipc	a0,0x1
    800015ae:	55650513          	addi	a0,a0,1366 # 80002b00 <test_physical_memory+0x14ae>
    800015b2:	fffff097          	auipc	ra,0xfffff
    800015b6:	406080e7          	jalr	1030(ra) # 800009b8 <panic>
    800015ba:	b7d5                	j	8000159e <alloc_page+0x30>

00000000800015bc <free_page>:

void free_page(void* page) {
    800015bc:	1101                	addi	sp,sp,-32
    800015be:	ec06                	sd	ra,24(sp)
    800015c0:	e822                	sd	s0,16(sp)
    800015c2:	e426                	sd	s1,8(sp)
    800015c4:	1000                	addi	s0,sp,32
    800015c6:	84aa                	mv	s1,a0
  struct run *r = (struct run*)page;
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    800015c8:	03451793          	slli	a5,a0,0x34
    800015cc:	eb99                	bnez	a5,800015e2 <free_page+0x26>
    800015ce:	00004797          	auipc	a5,0x4
    800015d2:	b0278793          	addi	a5,a5,-1278 # 800050d0 <_bss_end>
    800015d6:	00f56663          	bltu	a0,a5,800015e2 <free_page+0x26>
    800015da:	47c5                	li	a5,17
    800015dc:	07ee                	slli	a5,a5,0x1b
    800015de:	00f56a63          	bltu	a0,a5,800015f2 <free_page+0x36>
    panic("free_page: invalid page address");
    800015e2:	00001517          	auipc	a0,0x1
    800015e6:	53e50513          	addi	a0,a0,1342 # 80002b20 <test_physical_memory+0x14ce>
    800015ea:	fffff097          	auipc	ra,0xfffff
    800015ee:	3ce080e7          	jalr	974(ra) # 800009b8 <panic>
//  while(current) {
//    if(current == r)
//      panic("free_page: double free");
//    current = current->next;
//  }
  r->next = freelist;
    800015f2:	00004797          	auipc	a5,0x4
    800015f6:	a2678793          	addi	a5,a5,-1498 # 80005018 <freelist>
    800015fa:	6398                	ld	a4,0(a5)
    800015fc:	e098                	sd	a4,0(s1)
  freelist = r;
    800015fe:	e384                	sd	s1,0(a5)
}
    80001600:	60e2                	ld	ra,24(sp)
    80001602:	6442                	ld	s0,16(sp)
    80001604:	64a2                	ld	s1,8(sp)
    80001606:	6105                	addi	sp,sp,32
    80001608:	8082                	ret

000000008000160a <pmm_init>:
void pmm_init(void) {
    8000160a:	7179                	addi	sp,sp,-48
    8000160c:	f406                	sd	ra,40(sp)
    8000160e:	f022                	sd	s0,32(sp)
    80001610:	ec26                	sd	s1,24(sp)
    80001612:	1800                	addi	s0,sp,48
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    80001614:	00005497          	auipc	s1,0x5
    80001618:	abb48493          	addi	s1,s1,-1349 # 800060cf <_bss_end+0xfff>
    8000161c:	77fd                	lui	a5,0xfffff
    8000161e:	8cfd                	and	s1,s1,a5
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80001620:	6705                	lui	a4,0x1
    80001622:	9726                	add	a4,a4,s1
    80001624:	47c5                	li	a5,17
    80001626:	07ee                	slli	a5,a5,0x1b
    80001628:	02e7e063          	bltu	a5,a4,80001648 <pmm_init+0x3e>
    8000162c:	e84a                	sd	s2,16(sp)
    8000162e:	e44e                	sd	s3,8(sp)
    80001630:	6985                	lui	s3,0x1
    80001632:	893e                	mv	s2,a5
    free_page(p);
    80001634:	8526                	mv	a0,s1
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	f86080e7          	jalr	-122(ra) # 800015bc <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000163e:	94ce                	add	s1,s1,s3
    80001640:	ff249ae3          	bne	s1,s2,80001634 <pmm_init+0x2a>
    80001644:	6942                	ld	s2,16(sp)
    80001646:	69a2                	ld	s3,8(sp)
}
    80001648:	70a2                	ld	ra,40(sp)
    8000164a:	7402                	ld	s0,32(sp)
    8000164c:	64e2                	ld	s1,24(sp)
    8000164e:	6145                	addi	sp,sp,48
    80001650:	8082                	ret

0000000080001652 <test_physical_memory>:

void test_physical_memory(void) {
    80001652:	1101                	addi	sp,sp,-32
    80001654:	ec06                	sd	ra,24(sp)
    80001656:	e822                	sd	s0,16(sp)
    80001658:	e426                	sd	s1,8(sp)
    8000165a:	e04a                	sd	s2,0(sp)
    8000165c:	1000                	addi	s0,sp,32
	printf("%d \n",get_free_page_count());
    8000165e:	00000097          	auipc	ra,0x0
    80001662:	eee080e7          	jalr	-274(ra) # 8000154c <get_free_page_count>
    80001666:	85aa                	mv	a1,a0
    80001668:	00001517          	auipc	a0,0x1
    8000166c:	4d850513          	addi	a0,a0,1240 # 80002b40 <test_physical_memory+0x14ee>
    80001670:	fffff097          	auipc	ra,0xfffff
    80001674:	cbe080e7          	jalr	-834(ra) # 8000032e <printf>
    printf("[PM TEST] 分配两个页...\n");
    80001678:	00001517          	auipc	a0,0x1
    8000167c:	4d050513          	addi	a0,a0,1232 # 80002b48 <test_physical_memory+0x14f6>
    80001680:	fffff097          	auipc	ra,0xfffff
    80001684:	cae080e7          	jalr	-850(ra) # 8000032e <printf>
    void *page1 = alloc_page();
    80001688:	00000097          	auipc	ra,0x0
    8000168c:	ee6080e7          	jalr	-282(ra) # 8000156e <alloc_page>
    80001690:	84aa                	mv	s1,a0
    void *page2 = alloc_page();
    80001692:	00000097          	auipc	ra,0x0
    80001696:	edc080e7          	jalr	-292(ra) # 8000156e <alloc_page>
    8000169a:	892a                	mv	s2,a0
    if (!expr) {
    8000169c:	12048363          	beqz	s1,800017c2 <test_physical_memory+0x170>
    800016a0:	14050863          	beqz	a0,800017f0 <test_physical_memory+0x19e>
    800016a4:	17248c63          	beq	s1,s2,8000181c <test_physical_memory+0x1ca>
    assert(page1 != 0);
    assert(page2 != 0);
    assert(page1 != page2);
    assert(((uint64)page1 & 0xFFF) == 0);
    800016a8:	03449793          	slli	a5,s1,0x34
    800016ac:	18079e63          	bnez	a5,80001848 <test_physical_memory+0x1f6>
    assert(((uint64)page2 & 0xFFF) == 0);
    800016b0:	03491793          	slli	a5,s2,0x34
    800016b4:	1c079063          	bnez	a5,80001874 <test_physical_memory+0x222>
	printf("%d \n",get_free_page_count());
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	e94080e7          	jalr	-364(ra) # 8000154c <get_free_page_count>
    800016c0:	85aa                	mv	a1,a0
    800016c2:	00001517          	auipc	a0,0x1
    800016c6:	47e50513          	addi	a0,a0,1150 # 80002b40 <test_physical_memory+0x14ee>
    800016ca:	fffff097          	auipc	ra,0xfffff
    800016ce:	c64080e7          	jalr	-924(ra) # 8000032e <printf>
    printf("[PM TEST] 分配测试通过\n");
    800016d2:	00001517          	auipc	a0,0x1
    800016d6:	49650513          	addi	a0,a0,1174 # 80002b68 <test_physical_memory+0x1516>
    800016da:	fffff097          	auipc	ra,0xfffff
    800016de:	c54080e7          	jalr	-940(ra) # 8000032e <printf>

    printf("[PM TEST] 数据写入测试...\n");
    800016e2:	00001517          	auipc	a0,0x1
    800016e6:	4a650513          	addi	a0,a0,1190 # 80002b88 <test_physical_memory+0x1536>
    800016ea:	fffff097          	auipc	ra,0xfffff
    800016ee:	c44080e7          	jalr	-956(ra) # 8000032e <printf>
    *(int*)page1 = 0x12345678;
    800016f2:	123457b7          	lui	a5,0x12345
    800016f6:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6dcba988>
    800016fa:	c09c                	sw	a5,0(s1)
    assert(*(int*)page1 == 0x12345678);
    printf("[PM TEST] 数据写入测试通过\n");
    800016fc:	00001517          	auipc	a0,0x1
    80001700:	4b450513          	addi	a0,a0,1204 # 80002bb0 <test_physical_memory+0x155e>
    80001704:	fffff097          	auipc	ra,0xfffff
    80001708:	c2a080e7          	jalr	-982(ra) # 8000032e <printf>

    printf("[PM TEST] 释放与重新分配测试...\n");
    8000170c:	00001517          	auipc	a0,0x1
    80001710:	4cc50513          	addi	a0,a0,1228 # 80002bd8 <test_physical_memory+0x1586>
    80001714:	fffff097          	auipc	ra,0xfffff
    80001718:	c1a080e7          	jalr	-998(ra) # 8000032e <printf>
    free_page(page1);
    8000171c:	8526                	mv	a0,s1
    8000171e:	00000097          	auipc	ra,0x0
    80001722:	e9e080e7          	jalr	-354(ra) # 800015bc <free_page>
	printf("%d \n",get_free_page_count());
    80001726:	00000097          	auipc	ra,0x0
    8000172a:	e26080e7          	jalr	-474(ra) # 8000154c <get_free_page_count>
    8000172e:	85aa                	mv	a1,a0
    80001730:	00001517          	auipc	a0,0x1
    80001734:	41050513          	addi	a0,a0,1040 # 80002b40 <test_physical_memory+0x14ee>
    80001738:	fffff097          	auipc	ra,0xfffff
    8000173c:	bf6080e7          	jalr	-1034(ra) # 8000032e <printf>
    void *page3 = alloc_page();
    80001740:	00000097          	auipc	ra,0x0
    80001744:	e2e080e7          	jalr	-466(ra) # 8000156e <alloc_page>
    80001748:	84aa                	mv	s1,a0
	printf("%d \n",get_free_page_count());
    8000174a:	00000097          	auipc	ra,0x0
    8000174e:	e02080e7          	jalr	-510(ra) # 8000154c <get_free_page_count>
    80001752:	85aa                	mv	a1,a0
    80001754:	00001517          	auipc	a0,0x1
    80001758:	3ec50513          	addi	a0,a0,1004 # 80002b40 <test_physical_memory+0x14ee>
    8000175c:	fffff097          	auipc	ra,0xfffff
    80001760:	bd2080e7          	jalr	-1070(ra) # 8000032e <printf>
    80001764:	12048e63          	beqz	s1,800018a0 <test_physical_memory+0x24e>
    assert(page3 != 0);
    printf("[PM TEST] 释放与重新分配测试通过\n");
    80001768:	00001517          	auipc	a0,0x1
    8000176c:	4a050513          	addi	a0,a0,1184 # 80002c08 <test_physical_memory+0x15b6>
    80001770:	fffff097          	auipc	ra,0xfffff
    80001774:	bbe080e7          	jalr	-1090(ra) # 8000032e <printf>

    free_page(page2);
    80001778:	854a                	mv	a0,s2
    8000177a:	00000097          	auipc	ra,0x0
    8000177e:	e42080e7          	jalr	-446(ra) # 800015bc <free_page>
    free_page(page3);
    80001782:	8526                	mv	a0,s1
    80001784:	00000097          	auipc	ra,0x0
    80001788:	e38080e7          	jalr	-456(ra) # 800015bc <free_page>
	printf("%d \n",get_free_page_count());
    8000178c:	00000097          	auipc	ra,0x0
    80001790:	dc0080e7          	jalr	-576(ra) # 8000154c <get_free_page_count>
    80001794:	85aa                	mv	a1,a0
    80001796:	00001517          	auipc	a0,0x1
    8000179a:	3aa50513          	addi	a0,a0,938 # 80002b40 <test_physical_memory+0x14ee>
    8000179e:	fffff097          	auipc	ra,0xfffff
    800017a2:	b90080e7          	jalr	-1136(ra) # 8000032e <printf>
	//	for(int j=0;j<i;j++){
	//		assert(page[i]!=page[j]);
	//	}
	//}

    printf("[PM TEST] 所有物理内存管理测试通过\n");
    800017a6:	00001517          	auipc	a0,0x1
    800017aa:	49250513          	addi	a0,a0,1170 # 80002c38 <test_physical_memory+0x15e6>
    800017ae:	fffff097          	auipc	ra,0xfffff
    800017b2:	b80080e7          	jalr	-1152(ra) # 8000032e <printf>
    800017b6:	60e2                	ld	ra,24(sp)
    800017b8:	6442                	ld	s0,16(sp)
    800017ba:	64a2                	ld	s1,8(sp)
    800017bc:	6902                	ld	s2,0(sp)
    800017be:	6105                	addi	sp,sp,32
    800017c0:	8082                	ret
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    800017c2:	4615                	li	a2,5
    800017c4:	00001597          	auipc	a1,0x1
    800017c8:	24c58593          	addi	a1,a1,588 # 80002a10 <test_physical_memory+0x13be>
    800017cc:	00001517          	auipc	a0,0x1
    800017d0:	25450513          	addi	a0,a0,596 # 80002a20 <test_physical_memory+0x13ce>
    800017d4:	fffff097          	auipc	ra,0xfffff
    800017d8:	b5a080e7          	jalr	-1190(ra) # 8000032e <printf>
        panic("assert");
    800017dc:	00001517          	auipc	a0,0x1
    800017e0:	26c50513          	addi	a0,a0,620 # 80002a48 <test_physical_memory+0x13f6>
    800017e4:	fffff097          	auipc	ra,0xfffff
    800017e8:	1d4080e7          	jalr	468(ra) # 800009b8 <panic>
    if (!expr) {
    800017ec:	ec0912e3          	bnez	s2,800016b0 <test_physical_memory+0x5e>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    800017f0:	4615                	li	a2,5
    800017f2:	00001597          	auipc	a1,0x1
    800017f6:	21e58593          	addi	a1,a1,542 # 80002a10 <test_physical_memory+0x13be>
    800017fa:	00001517          	auipc	a0,0x1
    800017fe:	22650513          	addi	a0,a0,550 # 80002a20 <test_physical_memory+0x13ce>
    80001802:	fffff097          	auipc	ra,0xfffff
    80001806:	b2c080e7          	jalr	-1236(ra) # 8000032e <printf>
        panic("assert");
    8000180a:	00001517          	auipc	a0,0x1
    8000180e:	23e50513          	addi	a0,a0,574 # 80002a48 <test_physical_memory+0x13f6>
    80001812:	fffff097          	auipc	ra,0xfffff
    80001816:	1a6080e7          	jalr	422(ra) # 800009b8 <panic>
    8000181a:	b569                	j	800016a4 <test_physical_memory+0x52>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    8000181c:	4615                	li	a2,5
    8000181e:	00001597          	auipc	a1,0x1
    80001822:	1f258593          	addi	a1,a1,498 # 80002a10 <test_physical_memory+0x13be>
    80001826:	00001517          	auipc	a0,0x1
    8000182a:	1fa50513          	addi	a0,a0,506 # 80002a20 <test_physical_memory+0x13ce>
    8000182e:	fffff097          	auipc	ra,0xfffff
    80001832:	b00080e7          	jalr	-1280(ra) # 8000032e <printf>
        panic("assert");
    80001836:	00001517          	auipc	a0,0x1
    8000183a:	21250513          	addi	a0,a0,530 # 80002a48 <test_physical_memory+0x13f6>
    8000183e:	fffff097          	auipc	ra,0xfffff
    80001842:	17a080e7          	jalr	378(ra) # 800009b8 <panic>
    80001846:	b58d                	j	800016a8 <test_physical_memory+0x56>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80001848:	4615                	li	a2,5
    8000184a:	00001597          	auipc	a1,0x1
    8000184e:	1c658593          	addi	a1,a1,454 # 80002a10 <test_physical_memory+0x13be>
    80001852:	00001517          	auipc	a0,0x1
    80001856:	1ce50513          	addi	a0,a0,462 # 80002a20 <test_physical_memory+0x13ce>
    8000185a:	fffff097          	auipc	ra,0xfffff
    8000185e:	ad4080e7          	jalr	-1324(ra) # 8000032e <printf>
        panic("assert");
    80001862:	00001517          	auipc	a0,0x1
    80001866:	1e650513          	addi	a0,a0,486 # 80002a48 <test_physical_memory+0x13f6>
    8000186a:	fffff097          	auipc	ra,0xfffff
    8000186e:	14e080e7          	jalr	334(ra) # 800009b8 <panic>
    80001872:	bd3d                	j	800016b0 <test_physical_memory+0x5e>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    80001874:	4615                	li	a2,5
    80001876:	00001597          	auipc	a1,0x1
    8000187a:	19a58593          	addi	a1,a1,410 # 80002a10 <test_physical_memory+0x13be>
    8000187e:	00001517          	auipc	a0,0x1
    80001882:	1a250513          	addi	a0,a0,418 # 80002a20 <test_physical_memory+0x13ce>
    80001886:	fffff097          	auipc	ra,0xfffff
    8000188a:	aa8080e7          	jalr	-1368(ra) # 8000032e <printf>
        panic("assert");
    8000188e:	00001517          	auipc	a0,0x1
    80001892:	1ba50513          	addi	a0,a0,442 # 80002a48 <test_physical_memory+0x13f6>
    80001896:	fffff097          	auipc	ra,0xfffff
    8000189a:	122080e7          	jalr	290(ra) # 800009b8 <panic>
    8000189e:	bd29                	j	800016b8 <test_physical_memory+0x66>
        printf("assert failed: file %s, line %d\n", __FILE__, __LINE__);
    800018a0:	4615                	li	a2,5
    800018a2:	00001597          	auipc	a1,0x1
    800018a6:	16e58593          	addi	a1,a1,366 # 80002a10 <test_physical_memory+0x13be>
    800018aa:	00001517          	auipc	a0,0x1
    800018ae:	17650513          	addi	a0,a0,374 # 80002a20 <test_physical_memory+0x13ce>
    800018b2:	fffff097          	auipc	ra,0xfffff
    800018b6:	a7c080e7          	jalr	-1412(ra) # 8000032e <printf>
        panic("assert");
    800018ba:	00001517          	auipc	a0,0x1
    800018be:	18e50513          	addi	a0,a0,398 # 80002a48 <test_physical_memory+0x13f6>
    800018c2:	fffff097          	auipc	ra,0xfffff
    800018c6:	0f6080e7          	jalr	246(ra) # 800009b8 <panic>
    800018ca:	bd79                	j	80001768 <test_physical_memory+0x116>
	...
