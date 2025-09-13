
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
        li t0, 0x10000000 # UART基地址
    80000000:	100002b7          	lui	t0,0x10000
        li t1,'S'
    80000004:	05300313          	li	t1,83
        sb t1, 0(t0) # 输出字符'S'到UART
    80000008:	00628023          	sb	t1,0(t0) # 10000000 <_entry-0x70000000>
		li t1, '\n'
    8000000c:	4329                	li	t1,10
		sb t1, 0(t0)
    8000000e:	00628023          	sb	t1,0(t0)

		la sp, stack0
    80000012:	00003117          	auipc	sp,0x3
    80000016:	fee10113          	addi	sp,sp,-18 # 80003000 <stack0>
        li a0,4096*4 # 表示4096个字节单位
    8000001a:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8000001c:	912a                	add	sp,sp,a0


        li t1,'P'
    8000001e:	05000313          	li	t1,80
        sb t1,0(t0) # 输出字符'P'到UART
    80000022:	00628023          	sb	t1,0(t0)
		li t1, '\n'
    80000026:	4329                	li	t1,10
        sb t1, 0(t0)
    80000028:	00628023          	sb	t1,0(t0)

        la a0,_bss_start
    8000002c:	00007517          	auipc	a0,0x7
    80000030:	fd450513          	addi	a0,a0,-44 # 80007000 <global_test2>
        la a1,_bss_end
    80000034:	00007597          	auipc	a1,0x7
    80000038:	00c58593          	addi	a1,a1,12 # 80007040 <_bss_end>

000000008000003c <clear_bss>:
clear_bss:
        bgeu a0,a1,bss_done
    8000003c:	00b57663          	bgeu	a0,a1,80000048 <bss_done>
        sw zero,0(a0)
    80000040:	00052023          	sw	zero,0(a0)
        addi a0,a0,4
    80000044:	0511                	addi	a0,a0,4
        j clear_bss
    80000046:	bfdd                	j	8000003c <clear_bss>

0000000080000048 <bss_done>:
bss_done:
        call start # 跳转到start函数
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	03a080e7          	jalr	58(ra) # 80000082 <start>

0000000080000050 <spin>:
spin:
        j spin # 无限循环，防止程序退出
    80000050:	a001                	j	80000050 <spin>

0000000080000052 <clear_screen>:
int global_test2;
int buffer[10];
int initialized_global = 123;

// 清屏函数：发送ANSI转义序列
void clear_screen() {
    80000052:	1141                	addi	sp,sp,-16
    80000054:	e406                	sd	ra,8(sp)
    80000056:	e022                	sd	s0,0(sp)
    80000058:	0800                	addi	s0,sp,16
    // ANSI 转义序列：清屏并将光标移到左上角
    uart_puts("\033[2J");      // 清屏
    8000005a:	00001517          	auipc	a0,0x1
    8000005e:	fa650513          	addi	a0,a0,-90 # 80001000 <uart_puts+0xe60>
    80000062:	00000097          	auipc	ra,0x0
    80000066:	13e080e7          	jalr	318(ra) # 800001a0 <uart_puts>
    uart_puts("\033[H");       // 光标移到左上角 (1,1)
    8000006a:	00001517          	auipc	a0,0x1
    8000006e:	fa650513          	addi	a0,a0,-90 # 80001010 <uart_puts+0xe70>
    80000072:	00000097          	auipc	ra,0x0
    80000076:	12e080e7          	jalr	302(ra) # 800001a0 <uart_puts>
}
    8000007a:	60a2                	ld	ra,8(sp)
    8000007c:	6402                	ld	s0,0(sp)
    8000007e:	0141                	addi	sp,sp,16
    80000080:	8082                	ret

0000000080000082 <start>:

// start函数：内核的C语言入口
void start(){
    80000082:	1141                	addi	sp,sp,-16
    80000084:	e406                	sd	ra,8(sp)
    80000086:	e022                	sd	s0,0(sp)
    80000088:	0800                	addi	s0,sp,16
    //// 进入操作系统后立即清屏
    clear_screen();
    8000008a:	00000097          	auipc	ra,0x0
    8000008e:	fc8080e7          	jalr	-56(ra) # 80000052 <clear_screen>
    // 输出操作系统启动横幅
    uart_puts("===============================================\n");
    80000092:	00001517          	auipc	a0,0x1
    80000096:	f8650513          	addi	a0,a0,-122 # 80001018 <uart_puts+0xe78>
    8000009a:	00000097          	auipc	ra,0x0
    8000009e:	106080e7          	jalr	262(ra) # 800001a0 <uart_puts>
    uart_puts("        RISC-V Operating System v1.0         \n");
    800000a2:	00001517          	auipc	a0,0x1
    800000a6:	fae50513          	addi	a0,a0,-82 # 80001050 <uart_puts+0xeb0>
    800000aa:	00000097          	auipc	ra,0x0
    800000ae:	0f6080e7          	jalr	246(ra) # 800001a0 <uart_puts>
    uart_puts("===============================================\n\n");
    800000b2:	00001517          	auipc	a0,0x1
    800000b6:	fce50513          	addi	a0,a0,-50 # 80001080 <uart_puts+0xee0>
    800000ba:	00000097          	auipc	ra,0x0
    800000be:	0e6080e7          	jalr	230(ra) # 800001a0 <uart_puts>
    
    // 测试UART输出
    uart_puts("Hello, RISC-V Kernel!\n");
    800000c2:	00001517          	auipc	a0,0x1
    800000c6:	ff650513          	addi	a0,a0,-10 # 800010b8 <uart_puts+0xf18>
    800000ca:	00000097          	auipc	ra,0x0
    800000ce:	0d6080e7          	jalr	214(ra) # 800001a0 <uart_puts>
    uart_puts("Kernel startup complete!\n");
    800000d2:	00001517          	auipc	a0,0x1
    800000d6:	ffe50513          	addi	a0,a0,-2 # 800010d0 <uart_puts+0xf30>
    800000da:	00000097          	auipc	ra,0x0
    800000de:	0c6080e7          	jalr	198(ra) # 800001a0 <uart_puts>
    
    // 验证BSS段是否被正确清零
    uart_puts("Testing BSS zero initialization:\n");
    800000e2:	00001517          	auipc	a0,0x1
    800000e6:	00e50513          	addi	a0,a0,14 # 800010f0 <uart_puts+0xf50>
    800000ea:	00000097          	auipc	ra,0x0
    800000ee:	0b6080e7          	jalr	182(ra) # 800001a0 <uart_puts>
    if (global_test1 == 0 && global_test2 == 0) {
    800000f2:	00007797          	auipc	a5,0x7
    800000f6:	f127a783          	lw	a5,-238(a5) # 80007004 <global_test1>
    800000fa:	00007717          	auipc	a4,0x7
    800000fe:	f0672703          	lw	a4,-250(a4) # 80007000 <global_test2>
    80000102:	8fd9                	or	a5,a5,a4
    80000104:	cbb1                	beqz	a5,80000158 <start+0xd6>
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    } else {
        uart_puts("  [ERROR] BSS variables not zeroed!\n");
    80000106:	00001517          	auipc	a0,0x1
    8000010a:	03a50513          	addi	a0,a0,58 # 80001140 <uart_puts+0xfa0>
    8000010e:	00000097          	auipc	ra,0x0
    80000112:	092080e7          	jalr	146(ra) # 800001a0 <uart_puts>
    }
    
    // 验证初始化变量
    if (initialized_global == 123) {
    80000116:	00002717          	auipc	a4,0x2
    8000011a:	eea72703          	lw	a4,-278(a4) # 80002000 <initialized_global>
    8000011e:	07b00793          	li	a5,123
    80000122:	04f70463          	beq	a4,a5,8000016a <start+0xe8>
        uart_puts("  [OK] Initialized variables working\n");
    } else {
        uart_puts("  [ERROR] Initialized variables corrupted!\n");
    80000126:	00001517          	auipc	a0,0x1
    8000012a:	06a50513          	addi	a0,a0,106 # 80001190 <uart_puts+0xff0>
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	072080e7          	jalr	114(ra) # 800001a0 <uart_puts>
    }
    
    uart_puts("\nSystem ready. Entering main loop...\n");
    80000136:	00001517          	auipc	a0,0x1
    8000013a:	08a50513          	addi	a0,a0,138 # 800011c0 <uart_puts+0x1020>
    8000013e:	00000097          	auipc	ra,0x0
    80000142:	062080e7          	jalr	98(ra) # 800001a0 <uart_puts>
    uart_puts("Press Ctrl+A then X to exit QEMU\n\n");
    80000146:	00001517          	auipc	a0,0x1
    8000014a:	0a250513          	addi	a0,a0,162 # 800011e8 <uart_puts+0x1048>
    8000014e:	00000097          	auipc	ra,0x0
    80000152:	052080e7          	jalr	82(ra) # 800001a0 <uart_puts>
    
    // 主循环
    while(1) {
    80000156:	a001                	j	80000156 <start+0xd4>
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    80000158:	00001517          	auipc	a0,0x1
    8000015c:	fc050513          	addi	a0,a0,-64 # 80001118 <uart_puts+0xf78>
    80000160:	00000097          	auipc	ra,0x0
    80000164:	040080e7          	jalr	64(ra) # 800001a0 <uart_puts>
    80000168:	b77d                	j	80000116 <start+0x94>
        uart_puts("  [OK] Initialized variables working\n");
    8000016a:	00001517          	auipc	a0,0x1
    8000016e:	ffe50513          	addi	a0,a0,-2 # 80001168 <uart_puts+0xfc8>
    80000172:	00000097          	auipc	ra,0x0
    80000176:	02e080e7          	jalr	46(ra) # 800001a0 <uart_puts>
    8000017a:	bf75                	j	80000136 <start+0xb4>

000000008000017c <uart_putc>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

// 先实现最基本的字符输出
void uart_putc(char c)
{
    8000017c:	1141                	addi	sp,sp,-16
    8000017e:	e422                	sd	s0,8(sp)
    80000180:	0800                	addi	s0,sp,16
  // 等待发送缓冲区空闲
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000182:	10000737          	lui	a4,0x10000
    80000186:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000188:	00074783          	lbu	a5,0(a4)
    8000018c:	0207f793          	andi	a5,a5,32
    80000190:	dfe5                	beqz	a5,80000188 <uart_putc+0xc>
    ;
  // 写入字符到发送寄存器
  WriteReg(THR, c);
    80000192:	100007b7          	lui	a5,0x10000
    80000196:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    8000019a:	6422                	ld	s0,8(sp)
    8000019c:	0141                	addi	sp,sp,16
    8000019e:	8082                	ret

00000000800001a0 <uart_puts>:

// 成功后实现字符串输出
void uart_puts(char *s)
{
    800001a0:	1101                	addi	sp,sp,-32
    800001a2:	ec06                	sd	ra,24(sp)
    800001a4:	e822                	sd	s0,16(sp)
    800001a6:	e426                	sd	s1,8(sp)
    800001a8:	1000                	addi	s0,sp,32
    800001aa:	84aa                	mv	s1,a0
  while(*s) {
    800001ac:	00054503          	lbu	a0,0(a0)
    800001b0:	c909                	beqz	a0,800001c2 <uart_puts+0x22>
    uart_putc(*s);
    800001b2:	00000097          	auipc	ra,0x0
    800001b6:	fca080e7          	jalr	-54(ra) # 8000017c <uart_putc>
    s++;
    800001ba:	0485                	addi	s1,s1,1
  while(*s) {
    800001bc:	0004c503          	lbu	a0,0(s1)
    800001c0:	f96d                	bnez	a0,800001b2 <uart_puts+0x12>
  }
    800001c2:	60e2                	ld	ra,24(sp)
    800001c4:	6442                	ld	s0,16(sp)
    800001c6:	64a2                	ld	s1,8(sp)
    800001c8:	6105                	addi	sp,sp,32
    800001ca:	8082                	ret
	...
