
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80000000:	00003117          	auipc	sp,0x3
    80000004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80000008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8000000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8000000c:	00004517          	auipc	a0,0x4
    80000010:	ff450513          	addi	a0,a0,-12 # 80004000 <global_test2>
        la a1,_bss_end
    80000014:	00004597          	auipc	a1,0x4
    80000018:	0ac58593          	addi	a1,a1,172 # 800040c0 <_bss_end>

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
    80000032:	1141                	addi	sp,sp,-16 # 80002ff0 <initialized_global+0xff0>
    80000034:	e406                	sd	ra,8(sp)
    80000036:	e022                	sd	s0,0(sp)
    80000038:	0800                	addi	s0,sp,16
    // 进入操作系统后立即清屏
    clear_screen();
    8000003a:	00000097          	auipc	ra,0x0
    8000003e:	4ce080e7          	jalr	1230(ra) # 80000508 <clear_screen>
    // 输出操作系统启动横幅
    uart_puts("===============================================\n");
    80000042:	00001517          	auipc	a0,0x1
    80000046:	fbe50513          	addi	a0,a0,-66 # 80001000 <test_basic_colors+0x2b6>
    8000004a:	00000097          	auipc	ra,0x0
    8000004e:	0f6080e7          	jalr	246(ra) # 80000140 <uart_puts>
    uart_puts("        RISC-V Operating System v1.0         \n");
    80000052:	00001517          	auipc	a0,0x1
    80000056:	fe650513          	addi	a0,a0,-26 # 80001038 <test_basic_colors+0x2ee>
    8000005a:	00000097          	auipc	ra,0x0
    8000005e:	0e6080e7          	jalr	230(ra) # 80000140 <uart_puts>
    uart_puts("===============================================\n\n");
    80000062:	00001517          	auipc	a0,0x1
    80000066:	00650513          	addi	a0,a0,6 # 80001068 <test_basic_colors+0x31e>
    8000006a:	00000097          	auipc	ra,0x0
    8000006e:	0d6080e7          	jalr	214(ra) # 80000140 <uart_puts>
    
    // 验证BSS段是否被正确清零
    uart_puts("Testing BSS zero initialization:\n");
    80000072:	00001517          	auipc	a0,0x1
    80000076:	02e50513          	addi	a0,a0,46 # 800010a0 <test_basic_colors+0x356>
    8000007a:	00000097          	auipc	ra,0x0
    8000007e:	0c6080e7          	jalr	198(ra) # 80000140 <uart_puts>
    if (global_test1 == 0 && global_test2 == 0) {
    80000082:	00004797          	auipc	a5,0x4
    80000086:	f827a783          	lw	a5,-126(a5) # 80004004 <global_test1>
    8000008a:	00004717          	auipc	a4,0x4
    8000008e:	f7672703          	lw	a4,-138(a4) # 80004000 <global_test2>
    80000092:	8fd9                	or	a5,a5,a4
    80000094:	c3b5                	beqz	a5,800000f8 <start+0xc6>
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    } else {
        uart_puts("  [ERROR] BSS variables not zeroed!\n");
    80000096:	00001517          	auipc	a0,0x1
    8000009a:	05a50513          	addi	a0,a0,90 # 800010f0 <test_basic_colors+0x3a6>
    8000009e:	00000097          	auipc	ra,0x0
    800000a2:	0a2080e7          	jalr	162(ra) # 80000140 <uart_puts>
    }
    
    // 验证初始化变量
    if (initialized_global == 123) {
    800000a6:	00002717          	auipc	a4,0x2
    800000aa:	f5a72703          	lw	a4,-166(a4) # 80002000 <initialized_global>
    800000ae:	07b00793          	li	a5,123
    800000b2:	04f70c63          	beq	a4,a5,8000010a <start+0xd8>
        uart_puts("  [OK] Initialized variables working\n");
    } else {
        uart_puts("  [ERROR] Initialized variables corrupted!\n");
    800000b6:	00001517          	auipc	a0,0x1
    800000ba:	08a50513          	addi	a0,a0,138 # 80001140 <test_basic_colors+0x3f6>
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	082080e7          	jalr	130(ra) # 80000140 <uart_puts>
    }
    
    uart_puts("\nSystem ready. Entering main loop...\n");
    800000c6:	00001517          	auipc	a0,0x1
    800000ca:	0aa50513          	addi	a0,a0,170 # 80001170 <test_basic_colors+0x426>
    800000ce:	00000097          	auipc	ra,0x0
    800000d2:	072080e7          	jalr	114(ra) # 80000140 <uart_puts>

	// 测试printf模块
	clear_screen();
    800000d6:	00000097          	auipc	ra,0x0
    800000da:	432080e7          	jalr	1074(ra) # 80000508 <clear_screen>
	test_printf_precision();
    800000de:	00001097          	auipc	ra,0x1
    800000e2:	892080e7          	jalr	-1902(ra) # 80000970 <test_printf_precision>
	test_curse_move();
    800000e6:	00001097          	auipc	ra,0x1
    800000ea:	b7c080e7          	jalr	-1156(ra) # 80000c62 <test_curse_move>
	test_basic_colors();
    800000ee:	00001097          	auipc	ra,0x1
    800000f2:	c5c080e7          	jalr	-932(ra) # 80000d4a <test_basic_colors>
    
    // 主循环
    while(1) {
    800000f6:	a001                	j	800000f6 <start+0xc4>
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    800000f8:	00001517          	auipc	a0,0x1
    800000fc:	fd050513          	addi	a0,a0,-48 # 800010c8 <test_basic_colors+0x37e>
    80000100:	00000097          	auipc	ra,0x0
    80000104:	040080e7          	jalr	64(ra) # 80000140 <uart_puts>
    80000108:	bf79                	j	800000a6 <start+0x74>
        uart_puts("  [OK] Initialized variables working\n");
    8000010a:	00001517          	auipc	a0,0x1
    8000010e:	00e50513          	addi	a0,a0,14 # 80001118 <test_basic_colors+0x3ce>
    80000112:	00000097          	auipc	ra,0x0
    80000116:	02e080e7          	jalr	46(ra) # 80000140 <uart_puts>
    8000011a:	b775                	j	800000c6 <start+0x94>

000000008000011c <uart_putc>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))


void uart_putc(char c)
{
    8000011c:	1141                	addi	sp,sp,-16
    8000011e:	e422                	sd	s0,8(sp)
    80000120:	0800                	addi	s0,sp,16
  // 等待发送缓冲区空闲
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000122:	10000737          	lui	a4,0x10000
    80000126:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000128:	00074783          	lbu	a5,0(a4)
    8000012c:	0207f793          	andi	a5,a5,32
    80000130:	dfe5                	beqz	a5,80000128 <uart_putc+0xc>
    ;
  // 写入字符到发送寄存器
  WriteReg(THR, c);
    80000132:	100007b7          	lui	a5,0x10000
    80000136:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    8000013a:	6422                	ld	s0,8(sp)
    8000013c:	0141                	addi	sp,sp,16
    8000013e:	8082                	ret

0000000080000140 <uart_puts>:

// 成功后实现字符串输出
void uart_puts(char *s)
{
    80000140:	1141                	addi	sp,sp,-16
    80000142:	e422                	sd	s0,8(sp)
    80000144:	0800                	addi	s0,sp,16
    if (!s) return;
    80000146:	cd15                	beqz	a0,80000182 <uart_puts+0x42>
    
    while (*s) {
    80000148:	00054783          	lbu	a5,0(a0)
    8000014c:	cb9d                	beqz	a5,80000182 <uart_puts+0x42>
        // 批量检查：一次等待，发送多个字符
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000014e:	10000737          	lui	a4,0x10000
    80000152:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
            ;
            
        // 连续发送字符，直到缓冲区可能满或字符串结束
        int sent_count = 0;
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
            WriteReg(THR, *s);
    80000154:	10000637          	lui	a2,0x10000
    80000158:	a011                	j	8000015c <uart_puts+0x1c>
    while (*s) {
    8000015a:	c785                	beqz	a5,80000182 <uart_puts+0x42>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000015c:	00074783          	lbu	a5,0(a4)
    80000160:	0207f793          	andi	a5,a5,32
    80000164:	dfe5                	beqz	a5,8000015c <uart_puts+0x1c>
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    80000166:	00054783          	lbu	a5,0(a0)
    8000016a:	cf81                	beqz	a5,80000182 <uart_puts+0x42>
    8000016c:	00450693          	addi	a3,a0,4
            WriteReg(THR, *s);
    80000170:	00f60023          	sb	a5,0(a2) # 10000000 <_entry-0x70000000>
            s++;
    80000174:	0505                	addi	a0,a0,1
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    80000176:	00054783          	lbu	a5,0(a0)
    8000017a:	c781                	beqz	a5,80000182 <uart_puts+0x42>
    8000017c:	fea69ae3          	bne	a3,a0,80000170 <uart_puts+0x30>
    80000180:	bfe9                	j	8000015a <uart_puts+0x1a>
            sent_count++;
        }
    }
    80000182:	6422                	ld	s0,8(sp)
    80000184:	0141                	addi	sp,sp,16
    80000186:	8082                	ret

0000000080000188 <printint>:
static void consputs(const char *s){
	char *str = (char *)s;
	// 直接调用uart_puts输出字符串
	uart_puts(str);
}
static void printint(long long xx,int base,int sign){
    80000188:	7139                	addi	sp,sp,-64
    8000018a:	fc06                	sd	ra,56(sp)
    8000018c:	f822                	sd	s0,48(sp)
    8000018e:	0080                	addi	s0,sp,64
	// 模仿xv6的printint
	static char digits[] = "0123456789abcdef";
	char buf[20]; // 增大缓冲区以处理64位整数
	int i;
	unsigned long long x;
	if (sign && (sign = xx < 0)) // 符号处理
    80000190:	c219                	beqz	a2,80000196 <printint+0xe>
    80000192:	08054563          	bltz	a0,8000021c <printint+0x94>
		x = -(unsigned long long)xx; // 强制转换以避免溢出
	else
		x = xx;
    80000196:	4881                	li	a7,0

	if (base == 10 && x < 100) {
    80000198:	47a9                	li	a5,10
    8000019a:	08f58563          	beq	a1,a5,80000224 <printint+0x9c>
		x = xx;
    8000019e:	fc840693          	addi	a3,s0,-56
    800001a2:	4781                	li	a5,0
		consputs(small_numbers[x]);
		return;
	}
	i = 0;
	do{
		buf[i] = digits[x % base];
    800001a4:	00001617          	auipc	a2,0x1
    800001a8:	7a460613          	addi	a2,a2,1956 # 80001948 <small_numbers>
    800001ac:	02b57733          	remu	a4,a0,a1
    800001b0:	9732                	add	a4,a4,a2
    800001b2:	19074703          	lbu	a4,400(a4)
    800001b6:	00e68023          	sb	a4,0(a3)
		i++;
    800001ba:	883e                	mv	a6,a5
    800001bc:	2785                	addiw	a5,a5,1
	}while((x/=base) !=0);
    800001be:	872a                	mv	a4,a0
    800001c0:	02b55533          	divu	a0,a0,a1
    800001c4:	0685                	addi	a3,a3,1
    800001c6:	feb773e3          	bgeu	a4,a1,800001ac <printint+0x24>
	if (sign){
    800001ca:	00088a63          	beqz	a7,800001de <printint+0x56>
		buf[i] = '-';
    800001ce:	1781                	addi	a5,a5,-32
    800001d0:	97a2                	add	a5,a5,s0
    800001d2:	02d00713          	li	a4,45
    800001d6:	fee78423          	sb	a4,-24(a5)
		i++;
    800001da:	0028079b          	addiw	a5,a6,2
	}
	i--;
	while( i>=0){
    800001de:	02f05b63          	blez	a5,80000214 <printint+0x8c>
    800001e2:	f426                	sd	s1,40(sp)
    800001e4:	f04a                	sd	s2,32(sp)
    800001e6:	fc840713          	addi	a4,s0,-56
    800001ea:	00f704b3          	add	s1,a4,a5
    800001ee:	fff70913          	addi	s2,a4,-1
    800001f2:	993e                	add	s2,s2,a5
    800001f4:	37fd                	addiw	a5,a5,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	40f90933          	sub	s2,s2,a5
	uart_putc(c);
    800001fe:	fff4c503          	lbu	a0,-1(s1)
    80000202:	00000097          	auipc	ra,0x0
    80000206:	f1a080e7          	jalr	-230(ra) # 8000011c <uart_putc>
	while( i>=0){
    8000020a:	14fd                	addi	s1,s1,-1
    8000020c:	ff2499e3          	bne	s1,s2,800001fe <printint+0x76>
    80000210:	74a2                	ld	s1,40(sp)
    80000212:	7902                	ld	s2,32(sp)
		consputc(buf[i]);
		i--;
	}
}
    80000214:	70e2                	ld	ra,56(sp)
    80000216:	7442                	ld	s0,48(sp)
    80000218:	6121                	addi	sp,sp,64
    8000021a:	8082                	ret
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    8000021c:	40a00533          	neg	a0,a0
	if (sign && (sign = xx < 0)) // 符号处理
    80000220:	4885                	li	a7,1
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    80000222:	bf9d                	j	80000198 <printint+0x10>
	if (base == 10 && x < 100) {
    80000224:	06300793          	li	a5,99
    80000228:	f6a7ebe3          	bltu	a5,a0,8000019e <printint+0x16>
		consputs(small_numbers[x]);
    8000022c:	050a                	slli	a0,a0,0x2
	uart_puts(str);
    8000022e:	00001797          	auipc	a5,0x1
    80000232:	71a78793          	addi	a5,a5,1818 # 80001948 <small_numbers>
    80000236:	953e                	add	a0,a0,a5
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	f08080e7          	jalr	-248(ra) # 80000140 <uart_puts>
		return;
    80000240:	bfd1                	j	80000214 <printint+0x8c>

0000000080000242 <flush_printf_buffer>:
	if (printf_buf_pos > 0) {
    80000242:	00004797          	auipc	a5,0x4
    80000246:	dc67a783          	lw	a5,-570(a5) # 80004008 <printf_buf_pos>
    8000024a:	00f04363          	bgtz	a5,80000250 <flush_printf_buffer+0xe>
    8000024e:	8082                	ret
static void flush_printf_buffer(void) {
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e406                	sd	ra,8(sp)
    80000254:	e022                	sd	s0,0(sp)
    80000256:	0800                	addi	s0,sp,16
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80000258:	00004517          	auipc	a0,0x4
    8000025c:	de050513          	addi	a0,a0,-544 # 80004038 <printf_buffer>
    80000260:	97aa                	add	a5,a5,a0
    80000262:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80000266:	00000097          	auipc	ra,0x0
    8000026a:	eda080e7          	jalr	-294(ra) # 80000140 <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    8000026e:	00004797          	auipc	a5,0x4
    80000272:	d807ad23          	sw	zero,-614(a5) # 80004008 <printf_buf_pos>
}
    80000276:	60a2                	ld	ra,8(sp)
    80000278:	6402                	ld	s0,0(sp)
    8000027a:	0141                	addi	sp,sp,16
    8000027c:	8082                	ret

000000008000027e <buffer_char>:
static void buffer_char(char c) {
    8000027e:	1101                	addi	sp,sp,-32
    80000280:	ec06                	sd	ra,24(sp)
    80000282:	e822                	sd	s0,16(sp)
    80000284:	e426                	sd	s1,8(sp)
    80000286:	1000                	addi	s0,sp,32
    80000288:	84aa                	mv	s1,a0
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    8000028a:	00004797          	auipc	a5,0x4
    8000028e:	d7e7a783          	lw	a5,-642(a5) # 80004008 <printf_buf_pos>
    80000292:	07e00713          	li	a4,126
    80000296:	02f74463          	blt	a4,a5,800002be <buffer_char+0x40>
		printf_buffer[printf_buf_pos++] = c;
    8000029a:	0017871b          	addiw	a4,a5,1
    8000029e:	00004697          	auipc	a3,0x4
    800002a2:	d6e6a523          	sw	a4,-662(a3) # 80004008 <printf_buf_pos>
    800002a6:	00004717          	auipc	a4,0x4
    800002aa:	d9270713          	addi	a4,a4,-622 # 80004038 <printf_buffer>
    800002ae:	97ba                	add	a5,a5,a4
    800002b0:	00a78023          	sb	a0,0(a5)
}
    800002b4:	60e2                	ld	ra,24(sp)
    800002b6:	6442                	ld	s0,16(sp)
    800002b8:	64a2                	ld	s1,8(sp)
    800002ba:	6105                	addi	sp,sp,32
    800002bc:	8082                	ret
		flush_printf_buffer(); // Buffer full, flush it
    800002be:	00000097          	auipc	ra,0x0
    800002c2:	f84080e7          	jalr	-124(ra) # 80000242 <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    800002c6:	00004797          	auipc	a5,0x4
    800002ca:	d4278793          	addi	a5,a5,-702 # 80004008 <printf_buf_pos>
    800002ce:	4398                	lw	a4,0(a5)
    800002d0:	0017069b          	addiw	a3,a4,1
    800002d4:	c394                	sw	a3,0(a5)
    800002d6:	00004797          	auipc	a5,0x4
    800002da:	d6278793          	addi	a5,a5,-670 # 80004038 <printf_buffer>
    800002de:	97ba                	add	a5,a5,a4
    800002e0:	00978023          	sb	s1,0(a5)
}
    800002e4:	bfc1                	j	800002b4 <buffer_char+0x36>

00000000800002e6 <printf>:
void printf(const char *fmt, ...) {
    800002e6:	7135                	addi	sp,sp,-160
    800002e8:	ec86                	sd	ra,88(sp)
    800002ea:	e8a2                	sd	s0,80(sp)
    800002ec:	e0ca                	sd	s2,64(sp)
    800002ee:	1080                	addi	s0,sp,96
    800002f0:	892a                	mv	s2,a0
    800002f2:	e40c                	sd	a1,8(s0)
    800002f4:	e810                	sd	a2,16(s0)
    800002f6:	ec14                	sd	a3,24(s0)
    800002f8:	f018                	sd	a4,32(s0)
    800002fa:	f41c                	sd	a5,40(s0)
    800002fc:	03043823          	sd	a6,48(s0)
    80000300:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    80000304:	00840793          	addi	a5,s0,8
    80000308:	faf43c23          	sd	a5,-72(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000030c:	00054503          	lbu	a0,0(a0)
    80000310:	1c050d63          	beqz	a0,800004ea <printf+0x204>
    80000314:	e4a6                	sd	s1,72(sp)
    80000316:	fc4e                	sd	s3,56(sp)
    80000318:	f852                	sd	s4,48(sp)
    8000031a:	f456                	sd	s5,40(sp)
    8000031c:	f05a                	sd	s6,32(sp)
    8000031e:	0005079b          	sext.w	a5,a0
    80000322:	4481                	li	s1,0
        if(c != '%'){
    80000324:	02500993          	li	s3,37
        }
		flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
        c = fmt[++i] & 0xff;
        if(c == 0)
            break;
        switch(c){
    80000328:	4a59                	li	s4,22
    8000032a:	00001a97          	auipc	s5,0x1
    8000032e:	5bea8a93          	addi	s5,s5,1470 # 800018e8 <test_basic_colors+0xb9e>
    80000332:	a831                	j	8000034e <printf+0x68>
            buffer_char(c);
    80000334:	00000097          	auipc	ra,0x0
    80000338:	f4a080e7          	jalr	-182(ra) # 8000027e <buffer_char>
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000033c:	2485                	addiw	s1,s1,1
    8000033e:	009907b3          	add	a5,s2,s1
    80000342:	0007c503          	lbu	a0,0(a5)
    80000346:	0005079b          	sext.w	a5,a0
    8000034a:	18050b63          	beqz	a0,800004e0 <printf+0x1fa>
        if(c != '%'){
    8000034e:	ff3793e3          	bne	a5,s3,80000334 <printf+0x4e>
		flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    80000352:	00000097          	auipc	ra,0x0
    80000356:	ef0080e7          	jalr	-272(ra) # 80000242 <flush_printf_buffer>
        c = fmt[++i] & 0xff;
    8000035a:	2485                	addiw	s1,s1,1
    8000035c:	009907b3          	add	a5,s2,s1
    80000360:	0007cb03          	lbu	s6,0(a5)
        if(c == 0)
    80000364:	180b0c63          	beqz	s6,800004fc <printf+0x216>
        switch(c){
    80000368:	153b0963          	beq	s6,s3,800004ba <printf+0x1d4>
    8000036c:	f9eb079b          	addiw	a5,s6,-98
    80000370:	0ff7f793          	zext.b	a5,a5
    80000374:	14fa6a63          	bltu	s4,a5,800004c8 <printf+0x1e2>
    80000378:	f9eb079b          	addiw	a5,s6,-98
    8000037c:	0ff7f713          	zext.b	a4,a5
    80000380:	14ea6463          	bltu	s4,a4,800004c8 <printf+0x1e2>
    80000384:	00271793          	slli	a5,a4,0x2
    80000388:	97d6                	add	a5,a5,s5
    8000038a:	439c                	lw	a5,0(a5)
    8000038c:	97d6                	add	a5,a5,s5
    8000038e:	8782                	jr	a5
        case 'd':
            printint(va_arg(ap, int), 10, 1);
    80000390:	fb843783          	ld	a5,-72(s0)
    80000394:	00878713          	addi	a4,a5,8
    80000398:	fae43c23          	sd	a4,-72(s0)
    8000039c:	4605                	li	a2,1
    8000039e:	45a9                	li	a1,10
    800003a0:	4388                	lw	a0,0(a5)
    800003a2:	00000097          	auipc	ra,0x0
    800003a6:	de6080e7          	jalr	-538(ra) # 80000188 <printint>
            break;
    800003aa:	bf49                	j	8000033c <printf+0x56>
        case 'x':
            printint(va_arg(ap, int), 16, 0);
    800003ac:	fb843783          	ld	a5,-72(s0)
    800003b0:	00878713          	addi	a4,a5,8
    800003b4:	fae43c23          	sd	a4,-72(s0)
    800003b8:	4601                	li	a2,0
    800003ba:	45c1                	li	a1,16
    800003bc:	4388                	lw	a0,0(a5)
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	dca080e7          	jalr	-566(ra) # 80000188 <printint>
            break;
    800003c6:	bf9d                	j	8000033c <printf+0x56>
        case 'u':
            printint(va_arg(ap, unsigned int), 10, 0);
    800003c8:	fb843783          	ld	a5,-72(s0)
    800003cc:	00878713          	addi	a4,a5,8
    800003d0:	fae43c23          	sd	a4,-72(s0)
    800003d4:	4601                	li	a2,0
    800003d6:	45a9                	li	a1,10
    800003d8:	0007e503          	lwu	a0,0(a5)
    800003dc:	00000097          	auipc	ra,0x0
    800003e0:	dac080e7          	jalr	-596(ra) # 80000188 <printint>
            break;
    800003e4:	bfa1                	j	8000033c <printf+0x56>
        case 'c':
            consputc(va_arg(ap, int));
    800003e6:	fb843783          	ld	a5,-72(s0)
    800003ea:	00878713          	addi	a4,a5,8
    800003ee:	fae43c23          	sd	a4,-72(s0)
	uart_putc(c);
    800003f2:	0007c503          	lbu	a0,0(a5)
    800003f6:	00000097          	auipc	ra,0x0
    800003fa:	d26080e7          	jalr	-730(ra) # 8000011c <uart_putc>
}
    800003fe:	bf3d                	j	8000033c <printf+0x56>
            break;
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80000400:	fb843783          	ld	a5,-72(s0)
    80000404:	00878713          	addi	a4,a5,8
    80000408:	fae43c23          	sd	a4,-72(s0)
    8000040c:	6388                	ld	a0,0(a5)
    8000040e:	c511                	beqz	a0,8000041a <printf+0x134>
	uart_puts(str);
    80000410:	00000097          	auipc	ra,0x0
    80000414:	d30080e7          	jalr	-720(ra) # 80000140 <uart_puts>
}
    80000418:	b715                	j	8000033c <printf+0x56>
                s = "(null)";
    8000041a:	00001517          	auipc	a0,0x1
    8000041e:	d7e50513          	addi	a0,a0,-642 # 80001198 <test_basic_colors+0x44e>
    80000422:	b7fd                	j	80000410 <printf+0x12a>
            consputs(s);
            break;
		case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    80000424:	fb843783          	ld	a5,-72(s0)
    80000428:	00878713          	addi	a4,a5,8
    8000042c:	fae43c23          	sd	a4,-72(s0)
    80000430:	0007bb03          	ld	s6,0(a5)
	uart_puts(str);
    80000434:	00001517          	auipc	a0,0x1
    80000438:	d6c50513          	addi	a0,a0,-660 # 800011a0 <test_basic_colors+0x456>
    8000043c:	00000097          	auipc	ra,0x0
    80000440:	d04080e7          	jalr	-764(ra) # 80000140 <uart_puts>
            consputs("0x");
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    80000444:	fa040713          	addi	a4,s0,-96
    80000448:	fb040593          	addi	a1,s0,-80
	uart_puts(str);
    8000044c:	03c00693          	li	a3,60
                int shift = (15 - i) * 4;
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80000450:	00001617          	auipc	a2,0x1
    80000454:	d5860613          	addi	a2,a2,-680 # 800011a8 <test_basic_colors+0x45e>
    80000458:	00db57b3          	srl	a5,s6,a3
    8000045c:	8bbd                	andi	a5,a5,15
    8000045e:	97b2                	add	a5,a5,a2
    80000460:	0007c783          	lbu	a5,0(a5)
    80000464:	00f70023          	sb	a5,0(a4)
            for (i = 0; i < 16; i++) {
    80000468:	36f1                	addiw	a3,a3,-4
    8000046a:	0705                	addi	a4,a4,1
    8000046c:	feb716e3          	bne	a4,a1,80000458 <printf+0x172>
            }
            buf[16] = '\0';
    80000470:	fa040823          	sb	zero,-80(s0)
	uart_puts(str);
    80000474:	fa040513          	addi	a0,s0,-96
    80000478:	00000097          	auipc	ra,0x0
    8000047c:	cc8080e7          	jalr	-824(ra) # 80000140 <uart_puts>
}
    80000480:	bd75                	j	8000033c <printf+0x56>
            consputs(buf);
            break;
		case 'b':
            printint(va_arg(ap, int), 2, 0);
    80000482:	fb843783          	ld	a5,-72(s0)
    80000486:	00878713          	addi	a4,a5,8
    8000048a:	fae43c23          	sd	a4,-72(s0)
    8000048e:	4601                	li	a2,0
    80000490:	4589                	li	a1,2
    80000492:	4388                	lw	a0,0(a5)
    80000494:	00000097          	auipc	ra,0x0
    80000498:	cf4080e7          	jalr	-780(ra) # 80000188 <printint>
            break;
    8000049c:	b545                	j	8000033c <printf+0x56>
        case 'o':
            printint(va_arg(ap, int), 8, 0);
    8000049e:	fb843783          	ld	a5,-72(s0)
    800004a2:	00878713          	addi	a4,a5,8
    800004a6:	fae43c23          	sd	a4,-72(s0)
    800004aa:	4601                	li	a2,0
    800004ac:	45a1                	li	a1,8
    800004ae:	4388                	lw	a0,0(a5)
    800004b0:	00000097          	auipc	ra,0x0
    800004b4:	cd8080e7          	jalr	-808(ra) # 80000188 <printint>
            break;
    800004b8:	b551                	j	8000033c <printf+0x56>
        case '%':
            buffer_char('%');
    800004ba:	02500513          	li	a0,37
    800004be:	00000097          	auipc	ra,0x0
    800004c2:	dc0080e7          	jalr	-576(ra) # 8000027e <buffer_char>
            break;
    800004c6:	bd9d                	j	8000033c <printf+0x56>
        default:
			buffer_char('%');
    800004c8:	02500513          	li	a0,37
    800004cc:	00000097          	auipc	ra,0x0
    800004d0:	db2080e7          	jalr	-590(ra) # 8000027e <buffer_char>
			buffer_char(c);
    800004d4:	855a                	mv	a0,s6
    800004d6:	00000097          	auipc	ra,0x0
    800004da:	da8080e7          	jalr	-600(ra) # 8000027e <buffer_char>
            break;
    800004de:	bdb9                	j	8000033c <printf+0x56>
    800004e0:	64a6                	ld	s1,72(sp)
    800004e2:	79e2                	ld	s3,56(sp)
    800004e4:	7a42                	ld	s4,48(sp)
    800004e6:	7aa2                	ld	s5,40(sp)
    800004e8:	7b02                	ld	s6,32(sp)
        }
    }
	flush_printf_buffer(); // 最后刷新缓冲区
    800004ea:	00000097          	auipc	ra,0x0
    800004ee:	d58080e7          	jalr	-680(ra) # 80000242 <flush_printf_buffer>
    va_end(ap);
}
    800004f2:	60e6                	ld	ra,88(sp)
    800004f4:	6446                	ld	s0,80(sp)
    800004f6:	6906                	ld	s2,64(sp)
    800004f8:	610d                	addi	sp,sp,160
    800004fa:	8082                	ret
    800004fc:	64a6                	ld	s1,72(sp)
    800004fe:	79e2                	ld	s3,56(sp)
    80000500:	7a42                	ld	s4,48(sp)
    80000502:	7aa2                	ld	s5,40(sp)
    80000504:	7b02                	ld	s6,32(sp)
    80000506:	b7d5                	j	800004ea <printf+0x204>

0000000080000508 <clear_screen>:
// 清屏功能
void clear_screen(void) {
    80000508:	1141                	addi	sp,sp,-16
    8000050a:	e406                	sd	ra,8(sp)
    8000050c:	e022                	sd	s0,0(sp)
    8000050e:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    80000510:	00001517          	auipc	a0,0x1
    80000514:	cb050513          	addi	a0,a0,-848 # 800011c0 <test_basic_colors+0x476>
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	c28080e7          	jalr	-984(ra) # 80000140 <uart_puts>
	uart_puts(CURSOR_HOME);
    80000520:	00001517          	auipc	a0,0x1
    80000524:	ca850513          	addi	a0,a0,-856 # 800011c8 <test_basic_colors+0x47e>
    80000528:	00000097          	auipc	ra,0x0
    8000052c:	c18080e7          	jalr	-1000(ra) # 80000140 <uart_puts>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret

0000000080000538 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    if (lines <= 0) return;
    80000538:	04a05563          	blez	a0,80000582 <cursor_up+0x4a>
void cursor_up(int lines) {
    8000053c:	1101                	addi	sp,sp,-32
    8000053e:	ec06                	sd	ra,24(sp)
    80000540:	e822                	sd	s0,16(sp)
    80000542:	e426                	sd	s1,8(sp)
    80000544:	1000                	addi	s0,sp,32
    80000546:	84aa                	mv	s1,a0
	uart_putc(c);
    80000548:	456d                	li	a0,27
    8000054a:	00000097          	auipc	ra,0x0
    8000054e:	bd2080e7          	jalr	-1070(ra) # 8000011c <uart_putc>
    80000552:	05b00513          	li	a0,91
    80000556:	00000097          	auipc	ra,0x0
    8000055a:	bc6080e7          	jalr	-1082(ra) # 8000011c <uart_putc>
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    8000055e:	4601                	li	a2,0
    80000560:	45a9                	li	a1,10
    80000562:	8526                	mv	a0,s1
    80000564:	00000097          	auipc	ra,0x0
    80000568:	c24080e7          	jalr	-988(ra) # 80000188 <printint>
	uart_putc(c);
    8000056c:	04100513          	li	a0,65
    80000570:	00000097          	auipc	ra,0x0
    80000574:	bac080e7          	jalr	-1108(ra) # 8000011c <uart_putc>
    consputc('A');
}
    80000578:	60e2                	ld	ra,24(sp)
    8000057a:	6442                	ld	s0,16(sp)
    8000057c:	64a2                	ld	s1,8(sp)
    8000057e:	6105                	addi	sp,sp,32
    80000580:	8082                	ret
    80000582:	8082                	ret

0000000080000584 <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    if (lines <= 0) return;
    80000584:	04a05563          	blez	a0,800005ce <cursor_down+0x4a>
void cursor_down(int lines) {
    80000588:	1101                	addi	sp,sp,-32
    8000058a:	ec06                	sd	ra,24(sp)
    8000058c:	e822                	sd	s0,16(sp)
    8000058e:	e426                	sd	s1,8(sp)
    80000590:	1000                	addi	s0,sp,32
    80000592:	84aa                	mv	s1,a0
	uart_putc(c);
    80000594:	456d                	li	a0,27
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	b86080e7          	jalr	-1146(ra) # 8000011c <uart_putc>
    8000059e:	05b00513          	li	a0,91
    800005a2:	00000097          	auipc	ra,0x0
    800005a6:	b7a080e7          	jalr	-1158(ra) # 8000011c <uart_putc>
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    800005aa:	4601                	li	a2,0
    800005ac:	45a9                	li	a1,10
    800005ae:	8526                	mv	a0,s1
    800005b0:	00000097          	auipc	ra,0x0
    800005b4:	bd8080e7          	jalr	-1064(ra) # 80000188 <printint>
	uart_putc(c);
    800005b8:	04200513          	li	a0,66
    800005bc:	00000097          	auipc	ra,0x0
    800005c0:	b60080e7          	jalr	-1184(ra) # 8000011c <uart_putc>
    consputc('B');
}
    800005c4:	60e2                	ld	ra,24(sp)
    800005c6:	6442                	ld	s0,16(sp)
    800005c8:	64a2                	ld	s1,8(sp)
    800005ca:	6105                	addi	sp,sp,32
    800005cc:	8082                	ret
    800005ce:	8082                	ret

00000000800005d0 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    if (cols <= 0) return;
    800005d0:	04a05563          	blez	a0,8000061a <cursor_right+0x4a>
void cursor_right(int cols) {
    800005d4:	1101                	addi	sp,sp,-32
    800005d6:	ec06                	sd	ra,24(sp)
    800005d8:	e822                	sd	s0,16(sp)
    800005da:	e426                	sd	s1,8(sp)
    800005dc:	1000                	addi	s0,sp,32
    800005de:	84aa                	mv	s1,a0
	uart_putc(c);
    800005e0:	456d                	li	a0,27
    800005e2:	00000097          	auipc	ra,0x0
    800005e6:	b3a080e7          	jalr	-1222(ra) # 8000011c <uart_putc>
    800005ea:	05b00513          	li	a0,91
    800005ee:	00000097          	auipc	ra,0x0
    800005f2:	b2e080e7          	jalr	-1234(ra) # 8000011c <uart_putc>
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    800005f6:	4601                	li	a2,0
    800005f8:	45a9                	li	a1,10
    800005fa:	8526                	mv	a0,s1
    800005fc:	00000097          	auipc	ra,0x0
    80000600:	b8c080e7          	jalr	-1140(ra) # 80000188 <printint>
	uart_putc(c);
    80000604:	04300513          	li	a0,67
    80000608:	00000097          	auipc	ra,0x0
    8000060c:	b14080e7          	jalr	-1260(ra) # 8000011c <uart_putc>
    consputc('C');
}
    80000610:	60e2                	ld	ra,24(sp)
    80000612:	6442                	ld	s0,16(sp)
    80000614:	64a2                	ld	s1,8(sp)
    80000616:	6105                	addi	sp,sp,32
    80000618:	8082                	ret
    8000061a:	8082                	ret

000000008000061c <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    if (cols <= 0) return;
    8000061c:	04a05563          	blez	a0,80000666 <cursor_left+0x4a>
void cursor_left(int cols) {
    80000620:	1101                	addi	sp,sp,-32
    80000622:	ec06                	sd	ra,24(sp)
    80000624:	e822                	sd	s0,16(sp)
    80000626:	e426                	sd	s1,8(sp)
    80000628:	1000                	addi	s0,sp,32
    8000062a:	84aa                	mv	s1,a0
	uart_putc(c);
    8000062c:	456d                	li	a0,27
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	aee080e7          	jalr	-1298(ra) # 8000011c <uart_putc>
    80000636:	05b00513          	li	a0,91
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	ae2080e7          	jalr	-1310(ra) # 8000011c <uart_putc>
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    80000642:	4601                	li	a2,0
    80000644:	45a9                	li	a1,10
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	b40080e7          	jalr	-1216(ra) # 80000188 <printint>
	uart_putc(c);
    80000650:	04400513          	li	a0,68
    80000654:	00000097          	auipc	ra,0x0
    80000658:	ac8080e7          	jalr	-1336(ra) # 8000011c <uart_putc>
    consputc('D');
}
    8000065c:	60e2                	ld	ra,24(sp)
    8000065e:	6442                	ld	s0,16(sp)
    80000660:	64a2                	ld	s1,8(sp)
    80000662:	6105                	addi	sp,sp,32
    80000664:	8082                	ret
    80000666:	8082                	ret

0000000080000668 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    80000668:	1141                	addi	sp,sp,-16
    8000066a:	e406                	sd	ra,8(sp)
    8000066c:	e022                	sd	s0,0(sp)
    8000066e:	0800                	addi	s0,sp,16
	uart_putc(c);
    80000670:	456d                	li	a0,27
    80000672:	00000097          	auipc	ra,0x0
    80000676:	aaa080e7          	jalr	-1366(ra) # 8000011c <uart_putc>
    8000067a:	05b00513          	li	a0,91
    8000067e:	00000097          	auipc	ra,0x0
    80000682:	a9e080e7          	jalr	-1378(ra) # 8000011c <uart_putc>
    80000686:	07300513          	li	a0,115
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	a92080e7          	jalr	-1390(ra) # 8000011c <uart_putc>
    consputc('\033');
    consputc('[');
    consputc('s');
}
    80000692:	60a2                	ld	ra,8(sp)
    80000694:	6402                	ld	s0,0(sp)
    80000696:	0141                	addi	sp,sp,16
    80000698:	8082                	ret

000000008000069a <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    8000069a:	1141                	addi	sp,sp,-16
    8000069c:	e406                	sd	ra,8(sp)
    8000069e:	e022                	sd	s0,0(sp)
    800006a0:	0800                	addi	s0,sp,16
	uart_putc(c);
    800006a2:	456d                	li	a0,27
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	a78080e7          	jalr	-1416(ra) # 8000011c <uart_putc>
    800006ac:	05b00513          	li	a0,91
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	a6c080e7          	jalr	-1428(ra) # 8000011c <uart_putc>
    800006b8:	07500513          	li	a0,117
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	a60080e7          	jalr	-1440(ra) # 8000011c <uart_putc>
    consputc('\033');
    consputc('[');
    consputc('u');
}
    800006c4:	60a2                	ld	ra,8(sp)
    800006c6:	6402                	ld	s0,0(sp)
    800006c8:	0141                	addi	sp,sp,16
    800006ca:	8082                	ret

00000000800006cc <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    800006cc:	1101                	addi	sp,sp,-32
    800006ce:	ec06                	sd	ra,24(sp)
    800006d0:	e822                	sd	s0,16(sp)
    800006d2:	e426                	sd	s1,8(sp)
    800006d4:	1000                	addi	s0,sp,32
    800006d6:	84aa                	mv	s1,a0
	uart_putc(c);
    800006d8:	456d                	li	a0,27
    800006da:	00000097          	auipc	ra,0x0
    800006de:	a42080e7          	jalr	-1470(ra) # 8000011c <uart_putc>
    800006e2:	05b00513          	li	a0,91
    800006e6:	00000097          	auipc	ra,0x0
    800006ea:	a36080e7          	jalr	-1482(ra) # 8000011c <uart_putc>
    if (col <= 0) col = 1;
    800006ee:	8526                	mv	a0,s1
    800006f0:	02905463          	blez	s1,80000718 <cursor_to_column+0x4c>
    consputc('\033');
    consputc('[');
    printint(col, 10, 0);
    800006f4:	4601                	li	a2,0
    800006f6:	45a9                	li	a1,10
    800006f8:	2501                	sext.w	a0,a0
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	a8e080e7          	jalr	-1394(ra) # 80000188 <printint>
	uart_putc(c);
    80000702:	04700513          	li	a0,71
    80000706:	00000097          	auipc	ra,0x0
    8000070a:	a16080e7          	jalr	-1514(ra) # 8000011c <uart_putc>
    consputc('G');
}
    8000070e:	60e2                	ld	ra,24(sp)
    80000710:	6442                	ld	s0,16(sp)
    80000712:	64a2                	ld	s1,8(sp)
    80000714:	6105                	addi	sp,sp,32
    80000716:	8082                	ret
    if (col <= 0) col = 1;
    80000718:	4505                	li	a0,1
    8000071a:	bfe9                	j	800006f4 <cursor_to_column+0x28>

000000008000071c <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    8000071c:	1101                	addi	sp,sp,-32
    8000071e:	ec06                	sd	ra,24(sp)
    80000720:	e822                	sd	s0,16(sp)
    80000722:	e426                	sd	s1,8(sp)
    80000724:	e04a                	sd	s2,0(sp)
    80000726:	1000                	addi	s0,sp,32
    80000728:	892a                	mv	s2,a0
    8000072a:	84ae                	mv	s1,a1
	uart_putc(c);
    8000072c:	456d                	li	a0,27
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	9ee080e7          	jalr	-1554(ra) # 8000011c <uart_putc>
    80000736:	05b00513          	li	a0,91
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	9e2080e7          	jalr	-1566(ra) # 8000011c <uart_putc>
    consputc('\033');
    consputc('[');
    printint(row, 10, 0);
    80000742:	4601                	li	a2,0
    80000744:	45a9                	li	a1,10
    80000746:	854a                	mv	a0,s2
    80000748:	00000097          	auipc	ra,0x0
    8000074c:	a40080e7          	jalr	-1472(ra) # 80000188 <printint>
	uart_putc(c);
    80000750:	03b00513          	li	a0,59
    80000754:	00000097          	auipc	ra,0x0
    80000758:	9c8080e7          	jalr	-1592(ra) # 8000011c <uart_putc>
    consputc(';');
    printint(col, 10, 0);
    8000075c:	4601                	li	a2,0
    8000075e:	45a9                	li	a1,10
    80000760:	8526                	mv	a0,s1
    80000762:	00000097          	auipc	ra,0x0
    80000766:	a26080e7          	jalr	-1498(ra) # 80000188 <printint>
	uart_putc(c);
    8000076a:	04800513          	li	a0,72
    8000076e:	00000097          	auipc	ra,0x0
    80000772:	9ae080e7          	jalr	-1618(ra) # 8000011c <uart_putc>
    consputc('H');
}
    80000776:	60e2                	ld	ra,24(sp)
    80000778:	6442                	ld	s0,16(sp)
    8000077a:	64a2                	ld	s1,8(sp)
    8000077c:	6902                	ld	s2,0(sp)
    8000077e:	6105                	addi	sp,sp,32
    80000780:	8082                	ret

0000000080000782 <reset_color>:
// 颜色控制
void reset_color(void) {
    80000782:	1141                	addi	sp,sp,-16
    80000784:	e406                	sd	ra,8(sp)
    80000786:	e022                	sd	s0,0(sp)
    80000788:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    8000078a:	00001517          	auipc	a0,0x1
    8000078e:	a4650513          	addi	a0,a0,-1466 # 800011d0 <test_basic_colors+0x486>
    80000792:	00000097          	auipc	ra,0x0
    80000796:	9ae080e7          	jalr	-1618(ra) # 80000140 <uart_puts>
}
    8000079a:	60a2                	ld	ra,8(sp)
    8000079c:	6402                	ld	s0,0(sp)
    8000079e:	0141                	addi	sp,sp,16
    800007a0:	8082                	ret

00000000800007a2 <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
	if (color < 30 || color > 37) return; // 支持30-37
    800007a2:	fe25071b          	addiw	a4,a0,-30
    800007a6:	479d                	li	a5,7
    800007a8:	00e7f363          	bgeu	a5,a4,800007ae <set_fg_color+0xc>
    800007ac:	8082                	ret
void set_fg_color(int color) {
    800007ae:	1101                	addi	sp,sp,-32
    800007b0:	ec06                	sd	ra,24(sp)
    800007b2:	e822                	sd	s0,16(sp)
    800007b4:	e426                	sd	s1,8(sp)
    800007b6:	1000                	addi	s0,sp,32
    800007b8:	84aa                	mv	s1,a0
	uart_putc(c);
    800007ba:	456d                	li	a0,27
    800007bc:	00000097          	auipc	ra,0x0
    800007c0:	960080e7          	jalr	-1696(ra) # 8000011c <uart_putc>
    800007c4:	05b00513          	li	a0,91
    800007c8:	00000097          	auipc	ra,0x0
    800007cc:	954080e7          	jalr	-1708(ra) # 8000011c <uart_putc>
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
    800007d0:	4601                	li	a2,0
    800007d2:	45a9                	li	a1,10
    800007d4:	8526                	mv	a0,s1
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	9b2080e7          	jalr	-1614(ra) # 80000188 <printint>
	uart_putc(c);
    800007de:	06d00513          	li	a0,109
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	93a080e7          	jalr	-1734(ra) # 8000011c <uart_putc>
	consputc('m');
}
    800007ea:	60e2                	ld	ra,24(sp)
    800007ec:	6442                	ld	s0,16(sp)
    800007ee:	64a2                	ld	s1,8(sp)
    800007f0:	6105                	addi	sp,sp,32
    800007f2:	8082                	ret

00000000800007f4 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
	if (color < 40 || color > 47) return; // 支持40-47
    800007f4:	fd85071b          	addiw	a4,a0,-40
    800007f8:	479d                	li	a5,7
    800007fa:	00e7f363          	bgeu	a5,a4,80000800 <set_bg_color+0xc>
    800007fe:	8082                	ret
void set_bg_color(int color) {
    80000800:	1101                	addi	sp,sp,-32
    80000802:	ec06                	sd	ra,24(sp)
    80000804:	e822                	sd	s0,16(sp)
    80000806:	e426                	sd	s1,8(sp)
    80000808:	1000                	addi	s0,sp,32
    8000080a:	84aa                	mv	s1,a0
	uart_putc(c);
    8000080c:	456d                	li	a0,27
    8000080e:	00000097          	auipc	ra,0x0
    80000812:	90e080e7          	jalr	-1778(ra) # 8000011c <uart_putc>
    80000816:	05b00513          	li	a0,91
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	902080e7          	jalr	-1790(ra) # 8000011c <uart_putc>
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
    80000822:	4601                	li	a2,0
    80000824:	45a9                	li	a1,10
    80000826:	8526                	mv	a0,s1
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	960080e7          	jalr	-1696(ra) # 80000188 <printint>
	uart_putc(c);
    80000830:	06d00513          	li	a0,109
    80000834:	00000097          	auipc	ra,0x0
    80000838:	8e8080e7          	jalr	-1816(ra) # 8000011c <uart_putc>
	consputc('m');
}
    8000083c:	60e2                	ld	ra,24(sp)
    8000083e:	6442                	ld	s0,16(sp)
    80000840:	64a2                	ld	s1,8(sp)
    80000842:	6105                	addi	sp,sp,32
    80000844:	8082                	ret

0000000080000846 <color_red>:
// 简易文字颜色
void color_red(void) {
    80000846:	1141                	addi	sp,sp,-16
    80000848:	e406                	sd	ra,8(sp)
    8000084a:	e022                	sd	s0,0(sp)
    8000084c:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    8000084e:	457d                	li	a0,31
    80000850:	00000097          	auipc	ra,0x0
    80000854:	f52080e7          	jalr	-174(ra) # 800007a2 <set_fg_color>
}
    80000858:	60a2                	ld	ra,8(sp)
    8000085a:	6402                	ld	s0,0(sp)
    8000085c:	0141                	addi	sp,sp,16
    8000085e:	8082                	ret

0000000080000860 <color_green>:
void color_green(void) {
    80000860:	1141                	addi	sp,sp,-16
    80000862:	e406                	sd	ra,8(sp)
    80000864:	e022                	sd	s0,0(sp)
    80000866:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    80000868:	02000513          	li	a0,32
    8000086c:	00000097          	auipc	ra,0x0
    80000870:	f36080e7          	jalr	-202(ra) # 800007a2 <set_fg_color>
}
    80000874:	60a2                	ld	ra,8(sp)
    80000876:	6402                	ld	s0,0(sp)
    80000878:	0141                	addi	sp,sp,16
    8000087a:	8082                	ret

000000008000087c <color_yellow>:
void color_yellow(void) {
    8000087c:	1141                	addi	sp,sp,-16
    8000087e:	e406                	sd	ra,8(sp)
    80000880:	e022                	sd	s0,0(sp)
    80000882:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    80000884:	02100513          	li	a0,33
    80000888:	00000097          	auipc	ra,0x0
    8000088c:	f1a080e7          	jalr	-230(ra) # 800007a2 <set_fg_color>
}
    80000890:	60a2                	ld	ra,8(sp)
    80000892:	6402                	ld	s0,0(sp)
    80000894:	0141                	addi	sp,sp,16
    80000896:	8082                	ret

0000000080000898 <color_blue>:
void color_blue(void) {
    80000898:	1141                	addi	sp,sp,-16
    8000089a:	e406                	sd	ra,8(sp)
    8000089c:	e022                	sd	s0,0(sp)
    8000089e:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    800008a0:	02200513          	li	a0,34
    800008a4:	00000097          	auipc	ra,0x0
    800008a8:	efe080e7          	jalr	-258(ra) # 800007a2 <set_fg_color>
}
    800008ac:	60a2                	ld	ra,8(sp)
    800008ae:	6402                	ld	s0,0(sp)
    800008b0:	0141                	addi	sp,sp,16
    800008b2:	8082                	ret

00000000800008b4 <color_purple>:
void color_purple(void) {
    800008b4:	1141                	addi	sp,sp,-16
    800008b6:	e406                	sd	ra,8(sp)
    800008b8:	e022                	sd	s0,0(sp)
    800008ba:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    800008bc:	02300513          	li	a0,35
    800008c0:	00000097          	auipc	ra,0x0
    800008c4:	ee2080e7          	jalr	-286(ra) # 800007a2 <set_fg_color>
}
    800008c8:	60a2                	ld	ra,8(sp)
    800008ca:	6402                	ld	s0,0(sp)
    800008cc:	0141                	addi	sp,sp,16
    800008ce:	8082                	ret

00000000800008d0 <color_cyan>:
void color_cyan(void) {
    800008d0:	1141                	addi	sp,sp,-16
    800008d2:	e406                	sd	ra,8(sp)
    800008d4:	e022                	sd	s0,0(sp)
    800008d6:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    800008d8:	02400513          	li	a0,36
    800008dc:	00000097          	auipc	ra,0x0
    800008e0:	ec6080e7          	jalr	-314(ra) # 800007a2 <set_fg_color>
}
    800008e4:	60a2                	ld	ra,8(sp)
    800008e6:	6402                	ld	s0,0(sp)
    800008e8:	0141                	addi	sp,sp,16
    800008ea:	8082                	ret

00000000800008ec <color_reverse>:
void color_reverse(void){
    800008ec:	1141                	addi	sp,sp,-16
    800008ee:	e406                	sd	ra,8(sp)
    800008f0:	e022                	sd	s0,0(sp)
    800008f2:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    800008f4:	02500513          	li	a0,37
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	eaa080e7          	jalr	-342(ra) # 800007a2 <set_fg_color>
}
    80000900:	60a2                	ld	ra,8(sp)
    80000902:	6402                	ld	s0,0(sp)
    80000904:	0141                	addi	sp,sp,16
    80000906:	8082                	ret

0000000080000908 <set_color>:
void set_color(int fg, int bg) {
    80000908:	1101                	addi	sp,sp,-32
    8000090a:	ec06                	sd	ra,24(sp)
    8000090c:	e822                	sd	s0,16(sp)
    8000090e:	e426                	sd	s1,8(sp)
    80000910:	1000                	addi	s0,sp,32
    80000912:	84aa                	mv	s1,a0
	set_bg_color(bg);
    80000914:	852e                	mv	a0,a1
    80000916:	00000097          	auipc	ra,0x0
    8000091a:	ede080e7          	jalr	-290(ra) # 800007f4 <set_bg_color>
	set_fg_color(fg);
    8000091e:	8526                	mv	a0,s1
    80000920:	00000097          	auipc	ra,0x0
    80000924:	e82080e7          	jalr	-382(ra) # 800007a2 <set_fg_color>
}
    80000928:	60e2                	ld	ra,24(sp)
    8000092a:	6442                	ld	s0,16(sp)
    8000092c:	64a2                	ld	s1,8(sp)
    8000092e:	6105                	addi	sp,sp,32
    80000930:	8082                	ret

0000000080000932 <clear_line>:
void clear_line(){
    80000932:	1141                	addi	sp,sp,-16
    80000934:	e406                	sd	ra,8(sp)
    80000936:	e022                	sd	s0,0(sp)
    80000938:	0800                	addi	s0,sp,16
	uart_putc(c);
    8000093a:	456d                	li	a0,27
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	7e0080e7          	jalr	2016(ra) # 8000011c <uart_putc>
    80000944:	05b00513          	li	a0,91
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	7d4080e7          	jalr	2004(ra) # 8000011c <uart_putc>
    80000950:	03200513          	li	a0,50
    80000954:	fffff097          	auipc	ra,0xfffff
    80000958:	7c8080e7          	jalr	1992(ra) # 8000011c <uart_putc>
    8000095c:	04b00513          	li	a0,75
    80000960:	fffff097          	auipc	ra,0xfffff
    80000964:	7bc080e7          	jalr	1980(ra) # 8000011c <uart_putc>
	consputc('\033');
	consputc('[');
	consputc('2');
	consputc('K');
}
    80000968:	60a2                	ld	ra,8(sp)
    8000096a:	6402                	ld	s0,0(sp)
    8000096c:	0141                	addi	sp,sp,16
    8000096e:	8082                	ret

0000000080000970 <test_printf_precision>:

void test_printf_precision(void) {
    80000970:	1101                	addi	sp,sp,-32
    80000972:	ec06                	sd	ra,24(sp)
    80000974:	e822                	sd	s0,16(sp)
    80000976:	1000                	addi	s0,sp,32
	clear_screen();
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	b90080e7          	jalr	-1136(ra) # 80000508 <clear_screen>
    printf("=== 详细的Printf测试 ===\n");
    80000980:	00001517          	auipc	a0,0x1
    80000984:	85850513          	addi	a0,a0,-1960 # 800011d8 <test_basic_colors+0x48e>
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	95e080e7          	jalr	-1698(ra) # 800002e6 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    80000990:	00001517          	auipc	a0,0x1
    80000994:	86850513          	addi	a0,a0,-1944 # 800011f8 <test_basic_colors+0x4ae>
    80000998:	00000097          	auipc	ra,0x0
    8000099c:	94e080e7          	jalr	-1714(ra) # 800002e6 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    800009a0:	0ff00593          	li	a1,255
    800009a4:	00001517          	auipc	a0,0x1
    800009a8:	86c50513          	addi	a0,a0,-1940 # 80001210 <test_basic_colors+0x4c6>
    800009ac:	00000097          	auipc	ra,0x0
    800009b0:	93a080e7          	jalr	-1734(ra) # 800002e6 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    800009b4:	6585                	lui	a1,0x1
    800009b6:	00001517          	auipc	a0,0x1
    800009ba:	87a50513          	addi	a0,a0,-1926 # 80001230 <test_basic_colors+0x4e6>
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	928080e7          	jalr	-1752(ra) # 800002e6 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    800009c6:	1234b5b7          	lui	a1,0x1234b
    800009ca:	bcd58593          	addi	a1,a1,-1075 # 1234abcd <_entry-0x6dcb5433>
    800009ce:	00001517          	auipc	a0,0x1
    800009d2:	88250513          	addi	a0,a0,-1918 # 80001250 <test_basic_colors+0x506>
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	910080e7          	jalr	-1776(ra) # 800002e6 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    800009de:	00001517          	auipc	a0,0x1
    800009e2:	88a50513          	addi	a0,a0,-1910 # 80001268 <test_basic_colors+0x51e>
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	900080e7          	jalr	-1792(ra) # 800002e6 <printf>
    printf("  正数: %d\n", 42);
    800009ee:	02a00593          	li	a1,42
    800009f2:	00001517          	auipc	a0,0x1
    800009f6:	88e50513          	addi	a0,a0,-1906 # 80001280 <test_basic_colors+0x536>
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	8ec080e7          	jalr	-1812(ra) # 800002e6 <printf>
    printf("  负数: %d\n", -42);
    80000a02:	fd600593          	li	a1,-42
    80000a06:	00001517          	auipc	a0,0x1
    80000a0a:	88a50513          	addi	a0,a0,-1910 # 80001290 <test_basic_colors+0x546>
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	8d8080e7          	jalr	-1832(ra) # 800002e6 <printf>
    printf("  零: %d\n", 0);
    80000a16:	4581                	li	a1,0
    80000a18:	00001517          	auipc	a0,0x1
    80000a1c:	88850513          	addi	a0,a0,-1912 # 800012a0 <test_basic_colors+0x556>
    80000a20:	00000097          	auipc	ra,0x0
    80000a24:	8c6080e7          	jalr	-1850(ra) # 800002e6 <printf>
    printf("  大数: %d\n", 123456789);
    80000a28:	075bd5b7          	lui	a1,0x75bd
    80000a2c:	d1558593          	addi	a1,a1,-747 # 75bcd15 <_entry-0x78a432eb>
    80000a30:	00001517          	auipc	a0,0x1
    80000a34:	88050513          	addi	a0,a0,-1920 # 800012b0 <test_basic_colors+0x566>
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	8ae080e7          	jalr	-1874(ra) # 800002e6 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80000a40:	00001517          	auipc	a0,0x1
    80000a44:	88050513          	addi	a0,a0,-1920 # 800012c0 <test_basic_colors+0x576>
    80000a48:	00000097          	auipc	ra,0x0
    80000a4c:	89e080e7          	jalr	-1890(ra) # 800002e6 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80000a50:	55fd                	li	a1,-1
    80000a52:	00001517          	auipc	a0,0x1
    80000a56:	88650513          	addi	a0,a0,-1914 # 800012d8 <test_basic_colors+0x58e>
    80000a5a:	00000097          	auipc	ra,0x0
    80000a5e:	88c080e7          	jalr	-1908(ra) # 800002e6 <printf>
    printf("  零：%u\n", 0U);
    80000a62:	4581                	li	a1,0
    80000a64:	00001517          	auipc	a0,0x1
    80000a68:	88c50513          	addi	a0,a0,-1908 # 800012f0 <test_basic_colors+0x5a6>
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	87a080e7          	jalr	-1926(ra) # 800002e6 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80000a74:	658d                	lui	a1,0x3
    80000a76:	03958593          	addi	a1,a1,57 # 3039 <_entry-0x7fffcfc7>
    80000a7a:	00001517          	auipc	a0,0x1
    80000a7e:	88650513          	addi	a0,a0,-1914 # 80001300 <test_basic_colors+0x5b6>
    80000a82:	00000097          	auipc	ra,0x0
    80000a86:	864080e7          	jalr	-1948(ra) # 800002e6 <printf>

	// 测试边界
	printf("边界测试:\n");
    80000a8a:	00001517          	auipc	a0,0x1
    80000a8e:	88e50513          	addi	a0,a0,-1906 # 80001318 <test_basic_colors+0x5ce>
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	854080e7          	jalr	-1964(ra) # 800002e6 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    80000a9a:	800005b7          	lui	a1,0x80000
    80000a9e:	fff5c593          	not	a1,a1
    80000aa2:	00001517          	auipc	a0,0x1
    80000aa6:	88650513          	addi	a0,a0,-1914 # 80001328 <test_basic_colors+0x5de>
    80000aaa:	00000097          	auipc	ra,0x0
    80000aae:	83c080e7          	jalr	-1988(ra) # 800002e6 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    80000ab2:	800005b7          	lui	a1,0x80000
    80000ab6:	00001517          	auipc	a0,0x1
    80000aba:	88250513          	addi	a0,a0,-1918 # 80001338 <test_basic_colors+0x5ee>
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	828080e7          	jalr	-2008(ra) # 800002e6 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    80000ac6:	55fd                	li	a1,-1
    80000ac8:	00001517          	auipc	a0,0x1
    80000acc:	88050513          	addi	a0,a0,-1920 # 80001348 <test_basic_colors+0x5fe>
    80000ad0:	00000097          	auipc	ra,0x0
    80000ad4:	816080e7          	jalr	-2026(ra) # 800002e6 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    80000ad8:	55fd                	li	a1,-1
    80000ada:	00001517          	auipc	a0,0x1
    80000ade:	87e50513          	addi	a0,a0,-1922 # 80001358 <test_basic_colors+0x60e>
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	804080e7          	jalr	-2044(ra) # 800002e6 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    80000aea:	00001517          	auipc	a0,0x1
    80000aee:	88650513          	addi	a0,a0,-1914 # 80001370 <test_basic_colors+0x626>
    80000af2:	fffff097          	auipc	ra,0xfffff
    80000af6:	7f4080e7          	jalr	2036(ra) # 800002e6 <printf>
    printf("  空字符串: '%s'\n", "");
    80000afa:	00001597          	auipc	a1,0x1
    80000afe:	ad658593          	addi	a1,a1,-1322 # 800015d0 <test_basic_colors+0x886>
    80000b02:	00001517          	auipc	a0,0x1
    80000b06:	88650513          	addi	a0,a0,-1914 # 80001388 <test_basic_colors+0x63e>
    80000b0a:	fffff097          	auipc	ra,0xfffff
    80000b0e:	7dc080e7          	jalr	2012(ra) # 800002e6 <printf>
    printf("  单字符: '%s'\n", "X");
    80000b12:	00001597          	auipc	a1,0x1
    80000b16:	88e58593          	addi	a1,a1,-1906 # 800013a0 <test_basic_colors+0x656>
    80000b1a:	00001517          	auipc	a0,0x1
    80000b1e:	88e50513          	addi	a0,a0,-1906 # 800013a8 <test_basic_colors+0x65e>
    80000b22:	fffff097          	auipc	ra,0xfffff
    80000b26:	7c4080e7          	jalr	1988(ra) # 800002e6 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    80000b2a:	00001597          	auipc	a1,0x1
    80000b2e:	89658593          	addi	a1,a1,-1898 # 800013c0 <test_basic_colors+0x676>
    80000b32:	00001517          	auipc	a0,0x1
    80000b36:	8ae50513          	addi	a0,a0,-1874 # 800013e0 <test_basic_colors+0x696>
    80000b3a:	fffff097          	auipc	ra,0xfffff
    80000b3e:	7ac080e7          	jalr	1964(ra) # 800002e6 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80000b42:	00001597          	auipc	a1,0x1
    80000b46:	8b658593          	addi	a1,a1,-1866 # 800013f8 <test_basic_colors+0x6ae>
    80000b4a:	00001517          	auipc	a0,0x1
    80000b4e:	9fe50513          	addi	a0,a0,-1538 # 80001548 <test_basic_colors+0x7fe>
    80000b52:	fffff097          	auipc	ra,0xfffff
    80000b56:	794080e7          	jalr	1940(ra) # 800002e6 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    80000b5a:	00001517          	auipc	a0,0x1
    80000b5e:	a0e50513          	addi	a0,a0,-1522 # 80001568 <test_basic_colors+0x81e>
    80000b62:	fffff097          	auipc	ra,0xfffff
    80000b66:	784080e7          	jalr	1924(ra) # 800002e6 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    80000b6a:	0ff00693          	li	a3,255
    80000b6e:	f0100613          	li	a2,-255
    80000b72:	0ff00593          	li	a1,255
    80000b76:	00001517          	auipc	a0,0x1
    80000b7a:	a0a50513          	addi	a0,a0,-1526 # 80001580 <test_basic_colors+0x836>
    80000b7e:	fffff097          	auipc	ra,0xfffff
    80000b82:	768080e7          	jalr	1896(ra) # 800002e6 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80000b86:	00001517          	auipc	a0,0x1
    80000b8a:	a2250513          	addi	a0,a0,-1502 # 800015a8 <test_basic_colors+0x85e>
    80000b8e:	fffff097          	auipc	ra,0xfffff
    80000b92:	758080e7          	jalr	1880(ra) # 800002e6 <printf>
	printf("  100%% 完成!\n");
    80000b96:	00001517          	auipc	a0,0x1
    80000b9a:	a2a50513          	addi	a0,a0,-1494 # 800015c0 <test_basic_colors+0x876>
    80000b9e:	fffff097          	auipc	ra,0xfffff
    80000ba2:	748080e7          	jalr	1864(ra) # 800002e6 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
	printf("NULL字符串测试:\n");
    80000ba6:	00001517          	auipc	a0,0x1
    80000baa:	a3250513          	addi	a0,a0,-1486 # 800015d8 <test_basic_colors+0x88e>
    80000bae:	fffff097          	auipc	ra,0xfffff
    80000bb2:	738080e7          	jalr	1848(ra) # 800002e6 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    80000bb6:	4581                	li	a1,0
    80000bb8:	00001517          	auipc	a0,0x1
    80000bbc:	a3850513          	addi	a0,a0,-1480 # 800015f0 <test_basic_colors+0x8a6>
    80000bc0:	fffff097          	auipc	ra,0xfffff
    80000bc4:	726080e7          	jalr	1830(ra) # 800002e6 <printf>
	
	// 测试指针格式
	int var = 42;
    80000bc8:	02a00793          	li	a5,42
    80000bcc:	fef42623          	sw	a5,-20(s0)
	printf("指针测试:\n");
    80000bd0:	00001517          	auipc	a0,0x1
    80000bd4:	a3850513          	addi	a0,a0,-1480 # 80001608 <test_basic_colors+0x8be>
    80000bd8:	fffff097          	auipc	ra,0xfffff
    80000bdc:	70e080e7          	jalr	1806(ra) # 800002e6 <printf>
	printf("  Address of var: %p\n", &var);
    80000be0:	fec40593          	addi	a1,s0,-20
    80000be4:	00001517          	auipc	a0,0x1
    80000be8:	a3450513          	addi	a0,a0,-1484 # 80001618 <test_basic_colors+0x8ce>
    80000bec:	fffff097          	auipc	ra,0xfffff
    80000bf0:	6fa080e7          	jalr	1786(ra) # 800002e6 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80000bf4:	00001517          	auipc	a0,0x1
    80000bf8:	a3c50513          	addi	a0,a0,-1476 # 80001630 <test_basic_colors+0x8e6>
    80000bfc:	fffff097          	auipc	ra,0xfffff
    80000c00:	6ea080e7          	jalr	1770(ra) # 800002e6 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80000c04:	55fd                	li	a1,-1
    80000c06:	00001517          	auipc	a0,0x1
    80000c0a:	a4a50513          	addi	a0,a0,-1462 # 80001650 <test_basic_colors+0x906>
    80000c0e:	fffff097          	auipc	ra,0xfffff
    80000c12:	6d8080e7          	jalr	1752(ra) # 800002e6 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80000c16:	00001517          	auipc	a0,0x1
    80000c1a:	a5250513          	addi	a0,a0,-1454 # 80001668 <test_basic_colors+0x91e>
    80000c1e:	fffff097          	auipc	ra,0xfffff
    80000c22:	6c8080e7          	jalr	1736(ra) # 800002e6 <printf>
	printf("  Binary of 5: %b\n", 5);
    80000c26:	4595                	li	a1,5
    80000c28:	00001517          	auipc	a0,0x1
    80000c2c:	a5850513          	addi	a0,a0,-1448 # 80001680 <test_basic_colors+0x936>
    80000c30:	fffff097          	auipc	ra,0xfffff
    80000c34:	6b6080e7          	jalr	1718(ra) # 800002e6 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80000c38:	45a1                	li	a1,8
    80000c3a:	00001517          	auipc	a0,0x1
    80000c3e:	a5e50513          	addi	a0,a0,-1442 # 80001698 <test_basic_colors+0x94e>
    80000c42:	fffff097          	auipc	ra,0xfffff
    80000c46:	6a4080e7          	jalr	1700(ra) # 800002e6 <printf>
	printf("=== Printf测试结束 ===\n");
    80000c4a:	00001517          	auipc	a0,0x1
    80000c4e:	a6650513          	addi	a0,a0,-1434 # 800016b0 <test_basic_colors+0x966>
    80000c52:	fffff097          	auipc	ra,0xfffff
    80000c56:	694080e7          	jalr	1684(ra) # 800002e6 <printf>
}
    80000c5a:	60e2                	ld	ra,24(sp)
    80000c5c:	6442                	ld	s0,16(sp)
    80000c5e:	6105                	addi	sp,sp,32
    80000c60:	8082                	ret

0000000080000c62 <test_curse_move>:
void test_curse_move(){
    80000c62:	7139                	addi	sp,sp,-64
    80000c64:	fc06                	sd	ra,56(sp)
    80000c66:	f822                	sd	s0,48(sp)
    80000c68:	f426                	sd	s1,40(sp)
    80000c6a:	f04a                	sd	s2,32(sp)
    80000c6c:	ec4e                	sd	s3,24(sp)
    80000c6e:	e852                	sd	s4,16(sp)
    80000c70:	e456                	sd	s5,8(sp)
    80000c72:	e05a                	sd	s6,0(sp)
    80000c74:	0080                	addi	s0,sp,64
	clear_screen(); // 清屏
    80000c76:	00000097          	auipc	ra,0x0
    80000c7a:	892080e7          	jalr	-1902(ra) # 80000508 <clear_screen>
	printf("=== 光标移动测试 ===\n");
    80000c7e:	00001517          	auipc	a0,0x1
    80000c82:	a5250513          	addi	a0,a0,-1454 # 800016d0 <test_basic_colors+0x986>
    80000c86:	fffff097          	auipc	ra,0xfffff
    80000c8a:	660080e7          	jalr	1632(ra) # 800002e6 <printf>
	for (int i = 3; i <= 7; i++) {
    80000c8e:	490d                	li	s2,3
		for (int j = 1; j <= 10; j++) {
    80000c90:	4b05                	li	s6,1
			goto_rc(i, j);
			printf("*");
    80000c92:	00001a17          	auipc	s4,0x1
    80000c96:	a5ea0a13          	addi	s4,s4,-1442 # 800016f0 <test_basic_colors+0x9a6>
		for (int j = 1; j <= 10; j++) {
    80000c9a:	49ad                	li	s3,11
	for (int i = 3; i <= 7; i++) {
    80000c9c:	4aa1                	li	s5,8
		for (int j = 1; j <= 10; j++) {
    80000c9e:	84da                	mv	s1,s6
			goto_rc(i, j);
    80000ca0:	85a6                	mv	a1,s1
    80000ca2:	854a                	mv	a0,s2
    80000ca4:	00000097          	auipc	ra,0x0
    80000ca8:	a78080e7          	jalr	-1416(ra) # 8000071c <goto_rc>
			printf("*");
    80000cac:	8552                	mv	a0,s4
    80000cae:	fffff097          	auipc	ra,0xfffff
    80000cb2:	638080e7          	jalr	1592(ra) # 800002e6 <printf>
		for (int j = 1; j <= 10; j++) {
    80000cb6:	2485                	addiw	s1,s1,1
    80000cb8:	ff3494e3          	bne	s1,s3,80000ca0 <test_curse_move+0x3e>
	for (int i = 3; i <= 7; i++) {
    80000cbc:	2905                	addiw	s2,s2,1
    80000cbe:	ff5910e3          	bne	s2,s5,80000c9e <test_curse_move+0x3c>
		}
	}
	goto_rc(9, 1);
    80000cc2:	4585                	li	a1,1
    80000cc4:	4525                	li	a0,9
    80000cc6:	00000097          	auipc	ra,0x0
    80000cca:	a56080e7          	jalr	-1450(ra) # 8000071c <goto_rc>
	save_cursor();
    80000cce:	00000097          	auipc	ra,0x0
    80000cd2:	99a080e7          	jalr	-1638(ra) # 80000668 <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80000cd6:	4515                	li	a0,5
    80000cd8:	00000097          	auipc	ra,0x0
    80000cdc:	860080e7          	jalr	-1952(ra) # 80000538 <cursor_up>
	cursor_right(2);
    80000ce0:	4509                	li	a0,2
    80000ce2:	00000097          	auipc	ra,0x0
    80000ce6:	8ee080e7          	jalr	-1810(ra) # 800005d0 <cursor_right>
	printf("+++++");
    80000cea:	00001517          	auipc	a0,0x1
    80000cee:	a0e50513          	addi	a0,a0,-1522 # 800016f8 <test_basic_colors+0x9ae>
    80000cf2:	fffff097          	auipc	ra,0xfffff
    80000cf6:	5f4080e7          	jalr	1524(ra) # 800002e6 <printf>
	cursor_down(2);
    80000cfa:	4509                	li	a0,2
    80000cfc:	00000097          	auipc	ra,0x0
    80000d00:	888080e7          	jalr	-1912(ra) # 80000584 <cursor_down>
	cursor_left(5);
    80000d04:	4515                	li	a0,5
    80000d06:	00000097          	auipc	ra,0x0
    80000d0a:	916080e7          	jalr	-1770(ra) # 8000061c <cursor_left>
	printf("-----");
    80000d0e:	00001517          	auipc	a0,0x1
    80000d12:	9f250513          	addi	a0,a0,-1550 # 80001700 <test_basic_colors+0x9b6>
    80000d16:	fffff097          	auipc	ra,0xfffff
    80000d1a:	5d0080e7          	jalr	1488(ra) # 800002e6 <printf>
	restore_cursor();
    80000d1e:	00000097          	auipc	ra,0x0
    80000d22:	97c080e7          	jalr	-1668(ra) # 8000069a <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80000d26:	00001517          	auipc	a0,0x1
    80000d2a:	9e250513          	addi	a0,a0,-1566 # 80001708 <test_basic_colors+0x9be>
    80000d2e:	fffff097          	auipc	ra,0xfffff
    80000d32:	5b8080e7          	jalr	1464(ra) # 800002e6 <printf>
}
    80000d36:	70e2                	ld	ra,56(sp)
    80000d38:	7442                	ld	s0,48(sp)
    80000d3a:	74a2                	ld	s1,40(sp)
    80000d3c:	7902                	ld	s2,32(sp)
    80000d3e:	69e2                	ld	s3,24(sp)
    80000d40:	6a42                	ld	s4,16(sp)
    80000d42:	6aa2                	ld	s5,8(sp)
    80000d44:	6b02                	ld	s6,0(sp)
    80000d46:	6121                	addi	sp,sp,64
    80000d48:	8082                	ret

0000000080000d4a <test_basic_colors>:

void test_basic_colors(void) {
    80000d4a:	1141                	addi	sp,sp,-16
    80000d4c:	e406                	sd	ra,8(sp)
    80000d4e:	e022                	sd	s0,0(sp)
    80000d50:	0800                	addi	s0,sp,16
    clear_screen();
    80000d52:	fffff097          	auipc	ra,0xfffff
    80000d56:	7b6080e7          	jalr	1974(ra) # 80000508 <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    80000d5a:	00001517          	auipc	a0,0x1
    80000d5e:	9d650513          	addi	a0,a0,-1578 # 80001730 <test_basic_colors+0x9e6>
    80000d62:	fffff097          	auipc	ra,0xfffff
    80000d66:	584080e7          	jalr	1412(ra) # 800002e6 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80000d6a:	00001517          	auipc	a0,0x1
    80000d6e:	9e650513          	addi	a0,a0,-1562 # 80001750 <test_basic_colors+0xa06>
    80000d72:	fffff097          	auipc	ra,0xfffff
    80000d76:	574080e7          	jalr	1396(ra) # 800002e6 <printf>
    color_red();    printf("红色文字 ");
    80000d7a:	00000097          	auipc	ra,0x0
    80000d7e:	acc080e7          	jalr	-1332(ra) # 80000846 <color_red>
    80000d82:	00001517          	auipc	a0,0x1
    80000d86:	9e650513          	addi	a0,a0,-1562 # 80001768 <test_basic_colors+0xa1e>
    80000d8a:	fffff097          	auipc	ra,0xfffff
    80000d8e:	55c080e7          	jalr	1372(ra) # 800002e6 <printf>
    color_green();  printf("绿色文字 ");
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	ace080e7          	jalr	-1330(ra) # 80000860 <color_green>
    80000d9a:	00001517          	auipc	a0,0x1
    80000d9e:	9de50513          	addi	a0,a0,-1570 # 80001778 <test_basic_colors+0xa2e>
    80000da2:	fffff097          	auipc	ra,0xfffff
    80000da6:	544080e7          	jalr	1348(ra) # 800002e6 <printf>
    color_yellow(); printf("黄色文字 ");
    80000daa:	00000097          	auipc	ra,0x0
    80000dae:	ad2080e7          	jalr	-1326(ra) # 8000087c <color_yellow>
    80000db2:	00001517          	auipc	a0,0x1
    80000db6:	9d650513          	addi	a0,a0,-1578 # 80001788 <test_basic_colors+0xa3e>
    80000dba:	fffff097          	auipc	ra,0xfffff
    80000dbe:	52c080e7          	jalr	1324(ra) # 800002e6 <printf>
    color_blue();   printf("蓝色文字 ");
    80000dc2:	00000097          	auipc	ra,0x0
    80000dc6:	ad6080e7          	jalr	-1322(ra) # 80000898 <color_blue>
    80000dca:	00001517          	auipc	a0,0x1
    80000dce:	9ce50513          	addi	a0,a0,-1586 # 80001798 <test_basic_colors+0xa4e>
    80000dd2:	fffff097          	auipc	ra,0xfffff
    80000dd6:	514080e7          	jalr	1300(ra) # 800002e6 <printf>
    color_purple(); printf("紫色文字 ");
    80000dda:	00000097          	auipc	ra,0x0
    80000dde:	ada080e7          	jalr	-1318(ra) # 800008b4 <color_purple>
    80000de2:	00001517          	auipc	a0,0x1
    80000de6:	9c650513          	addi	a0,a0,-1594 # 800017a8 <test_basic_colors+0xa5e>
    80000dea:	fffff097          	auipc	ra,0xfffff
    80000dee:	4fc080e7          	jalr	1276(ra) # 800002e6 <printf>
    color_cyan();   printf("青色文字 ");
    80000df2:	00000097          	auipc	ra,0x0
    80000df6:	ade080e7          	jalr	-1314(ra) # 800008d0 <color_cyan>
    80000dfa:	00001517          	auipc	a0,0x1
    80000dfe:	9be50513          	addi	a0,a0,-1602 # 800017b8 <test_basic_colors+0xa6e>
    80000e02:	fffff097          	auipc	ra,0xfffff
    80000e06:	4e4080e7          	jalr	1252(ra) # 800002e6 <printf>
    color_reverse();  printf("反色文字");
    80000e0a:	00000097          	auipc	ra,0x0
    80000e0e:	ae2080e7          	jalr	-1310(ra) # 800008ec <color_reverse>
    80000e12:	00001517          	auipc	a0,0x1
    80000e16:	9b650513          	addi	a0,a0,-1610 # 800017c8 <test_basic_colors+0xa7e>
    80000e1a:	fffff097          	auipc	ra,0xfffff
    80000e1e:	4cc080e7          	jalr	1228(ra) # 800002e6 <printf>
    reset_color();
    80000e22:	00000097          	auipc	ra,0x0
    80000e26:	960080e7          	jalr	-1696(ra) # 80000782 <reset_color>
    printf("\n\n");
    80000e2a:	00001517          	auipc	a0,0x1
    80000e2e:	9ae50513          	addi	a0,a0,-1618 # 800017d8 <test_basic_colors+0xa8e>
    80000e32:	fffff097          	auipc	ra,0xfffff
    80000e36:	4b4080e7          	jalr	1204(ra) # 800002e6 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80000e3a:	00001517          	auipc	a0,0x1
    80000e3e:	9a650513          	addi	a0,a0,-1626 # 800017e0 <test_basic_colors+0xa96>
    80000e42:	fffff097          	auipc	ra,0xfffff
    80000e46:	4a4080e7          	jalr	1188(ra) # 800002e6 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80000e4a:	02900513          	li	a0,41
    80000e4e:	00000097          	auipc	ra,0x0
    80000e52:	9a6080e7          	jalr	-1626(ra) # 800007f4 <set_bg_color>
    80000e56:	00001517          	auipc	a0,0x1
    80000e5a:	9a250513          	addi	a0,a0,-1630 # 800017f8 <test_basic_colors+0xaae>
    80000e5e:	fffff097          	auipc	ra,0xfffff
    80000e62:	488080e7          	jalr	1160(ra) # 800002e6 <printf>
    80000e66:	00000097          	auipc	ra,0x0
    80000e6a:	91c080e7          	jalr	-1764(ra) # 80000782 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80000e6e:	02a00513          	li	a0,42
    80000e72:	00000097          	auipc	ra,0x0
    80000e76:	982080e7          	jalr	-1662(ra) # 800007f4 <set_bg_color>
    80000e7a:	00001517          	auipc	a0,0x1
    80000e7e:	98e50513          	addi	a0,a0,-1650 # 80001808 <test_basic_colors+0xabe>
    80000e82:	fffff097          	auipc	ra,0xfffff
    80000e86:	464080e7          	jalr	1124(ra) # 800002e6 <printf>
    80000e8a:	00000097          	auipc	ra,0x0
    80000e8e:	8f8080e7          	jalr	-1800(ra) # 80000782 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80000e92:	02b00513          	li	a0,43
    80000e96:	00000097          	auipc	ra,0x0
    80000e9a:	95e080e7          	jalr	-1698(ra) # 800007f4 <set_bg_color>
    80000e9e:	00001517          	auipc	a0,0x1
    80000ea2:	97a50513          	addi	a0,a0,-1670 # 80001818 <test_basic_colors+0xace>
    80000ea6:	fffff097          	auipc	ra,0xfffff
    80000eaa:	440080e7          	jalr	1088(ra) # 800002e6 <printf>
    80000eae:	00000097          	auipc	ra,0x0
    80000eb2:	8d4080e7          	jalr	-1836(ra) # 80000782 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80000eb6:	02c00513          	li	a0,44
    80000eba:	00000097          	auipc	ra,0x0
    80000ebe:	93a080e7          	jalr	-1734(ra) # 800007f4 <set_bg_color>
    80000ec2:	00001517          	auipc	a0,0x1
    80000ec6:	96650513          	addi	a0,a0,-1690 # 80001828 <test_basic_colors+0xade>
    80000eca:	fffff097          	auipc	ra,0xfffff
    80000ece:	41c080e7          	jalr	1052(ra) # 800002e6 <printf>
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	8b0080e7          	jalr	-1872(ra) # 80000782 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80000eda:	02f00513          	li	a0,47
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	916080e7          	jalr	-1770(ra) # 800007f4 <set_bg_color>
    80000ee6:	00001517          	auipc	a0,0x1
    80000eea:	95250513          	addi	a0,a0,-1710 # 80001838 <test_basic_colors+0xaee>
    80000eee:	fffff097          	auipc	ra,0xfffff
    80000ef2:	3f8080e7          	jalr	1016(ra) # 800002e6 <printf>
    80000ef6:	00000097          	auipc	ra,0x0
    80000efa:	88c080e7          	jalr	-1908(ra) # 80000782 <reset_color>
    printf("\n\n");
    80000efe:	00001517          	auipc	a0,0x1
    80000f02:	8da50513          	addi	a0,a0,-1830 # 800017d8 <test_basic_colors+0xa8e>
    80000f06:	fffff097          	auipc	ra,0xfffff
    80000f0a:	3e0080e7          	jalr	992(ra) # 800002e6 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80000f0e:	00001517          	auipc	a0,0x1
    80000f12:	93a50513          	addi	a0,a0,-1734 # 80001848 <test_basic_colors+0xafe>
    80000f16:	fffff097          	auipc	ra,0xfffff
    80000f1a:	3d0080e7          	jalr	976(ra) # 800002e6 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80000f1e:	02c00593          	li	a1,44
    80000f22:	457d                	li	a0,31
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	9e4080e7          	jalr	-1564(ra) # 80000908 <set_color>
    80000f2c:	00001517          	auipc	a0,0x1
    80000f30:	93450513          	addi	a0,a0,-1740 # 80001860 <test_basic_colors+0xb16>
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	3b2080e7          	jalr	946(ra) # 800002e6 <printf>
    80000f3c:	00000097          	auipc	ra,0x0
    80000f40:	846080e7          	jalr	-1978(ra) # 80000782 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80000f44:	02d00593          	li	a1,45
    80000f48:	02100513          	li	a0,33
    80000f4c:	00000097          	auipc	ra,0x0
    80000f50:	9bc080e7          	jalr	-1604(ra) # 80000908 <set_color>
    80000f54:	00001517          	auipc	a0,0x1
    80000f58:	91c50513          	addi	a0,a0,-1764 # 80001870 <test_basic_colors+0xb26>
    80000f5c:	fffff097          	auipc	ra,0xfffff
    80000f60:	38a080e7          	jalr	906(ra) # 800002e6 <printf>
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	81e080e7          	jalr	-2018(ra) # 80000782 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80000f6c:	02f00593          	li	a1,47
    80000f70:	02000513          	li	a0,32
    80000f74:	00000097          	auipc	ra,0x0
    80000f78:	994080e7          	jalr	-1644(ra) # 80000908 <set_color>
    80000f7c:	00001517          	auipc	a0,0x1
    80000f80:	90450513          	addi	a0,a0,-1788 # 80001880 <test_basic_colors+0xb36>
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	362080e7          	jalr	866(ra) # 800002e6 <printf>
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	7f6080e7          	jalr	2038(ra) # 80000782 <reset_color>
    printf("\n\n");
    80000f94:	00001517          	auipc	a0,0x1
    80000f98:	84450513          	addi	a0,a0,-1980 # 800017d8 <test_basic_colors+0xa8e>
    80000f9c:	fffff097          	auipc	ra,0xfffff
    80000fa0:	34a080e7          	jalr	842(ra) # 800002e6 <printf>
	reset_color();
    80000fa4:	fffff097          	auipc	ra,0xfffff
    80000fa8:	7de080e7          	jalr	2014(ra) # 80000782 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80000fac:	00001517          	auipc	a0,0x1
    80000fb0:	8e450513          	addi	a0,a0,-1820 # 80001890 <test_basic_colors+0xb46>
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	332080e7          	jalr	818(ra) # 800002e6 <printf>
	cursor_up(1); // 光标上移一行
    80000fbc:	4505                	li	a0,1
    80000fbe:	fffff097          	auipc	ra,0xfffff
    80000fc2:	57a080e7          	jalr	1402(ra) # 80000538 <cursor_up>
	clear_line();
    80000fc6:	00000097          	auipc	ra,0x0
    80000fca:	96c080e7          	jalr	-1684(ra) # 80000932 <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80000fce:	00001517          	auipc	a0,0x1
    80000fd2:	8fa50513          	addi	a0,a0,-1798 # 800018c8 <test_basic_colors+0xb7e>
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	310080e7          	jalr	784(ra) # 800002e6 <printf>
    80000fde:	60a2                	ld	ra,8(sp)
    80000fe0:	6402                	ld	s0,0(sp)
    80000fe2:	0141                	addi	sp,sp,16
    80000fe4:	8082                	ret
	...
