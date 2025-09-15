
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
    80000018:	02c58593          	addi	a1,a1,44 # 80004040 <_bss_end>

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
    8000002c:	664080e7          	jalr	1636(ra) # 8000068c <start>

0000000080000030 <spin>:
spin:
        j spin # 无限循环，防止程序退出
    80000030:	a001                	j	80000030 <spin>

0000000080000032 <test_printf_precision>:
    // 双重保险
    uart_puts("NEVER REACH HERE!\n");
    while(1); 
}

void test_printf_precision(void) {
    80000032:	1101                	addi	sp,sp,-32 # 80002fe0 <initialized_global+0xfe0>
    80000034:	ec06                	sd	ra,24(sp)
    80000036:	e822                	sd	s0,16(sp)
    80000038:	1000                	addi	s0,sp,32
	clear_screen();
    8000003a:	00001097          	auipc	ra,0x1
    8000003e:	9f0080e7          	jalr	-1552(ra) # 80000a2a <clear_screen>
    printf("=== 详细的Printf测试 ===\n");
    80000042:	00001517          	auipc	a0,0x1
    80000046:	fbe50513          	addi	a0,a0,-66 # 80001000 <clear_line+0x1ae>
    8000004a:	00001097          	auipc	ra,0x1
    8000004e:	86a080e7          	jalr	-1942(ra) # 800008b4 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    80000052:	00001517          	auipc	a0,0x1
    80000056:	fce50513          	addi	a0,a0,-50 # 80001020 <clear_line+0x1ce>
    8000005a:	00001097          	auipc	ra,0x1
    8000005e:	85a080e7          	jalr	-1958(ra) # 800008b4 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    80000062:	0ff00593          	li	a1,255
    80000066:	00001517          	auipc	a0,0x1
    8000006a:	fd250513          	addi	a0,a0,-46 # 80001038 <clear_line+0x1e6>
    8000006e:	00001097          	auipc	ra,0x1
    80000072:	846080e7          	jalr	-1978(ra) # 800008b4 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    80000076:	6585                	lui	a1,0x1
    80000078:	00001517          	auipc	a0,0x1
    8000007c:	fe050513          	addi	a0,a0,-32 # 80001058 <clear_line+0x206>
    80000080:	00001097          	auipc	ra,0x1
    80000084:	834080e7          	jalr	-1996(ra) # 800008b4 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    80000088:	1234b5b7          	lui	a1,0x1234b
    8000008c:	bcd58593          	addi	a1,a1,-1075 # 1234abcd <_entry-0x6dcb5433>
    80000090:	00001517          	auipc	a0,0x1
    80000094:	fe850513          	addi	a0,a0,-24 # 80001078 <clear_line+0x226>
    80000098:	00001097          	auipc	ra,0x1
    8000009c:	81c080e7          	jalr	-2020(ra) # 800008b4 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    800000a0:	00001517          	auipc	a0,0x1
    800000a4:	ff050513          	addi	a0,a0,-16 # 80001090 <clear_line+0x23e>
    800000a8:	00001097          	auipc	ra,0x1
    800000ac:	80c080e7          	jalr	-2036(ra) # 800008b4 <printf>
    printf("  正数: %d\n", 42);
    800000b0:	02a00593          	li	a1,42
    800000b4:	00001517          	auipc	a0,0x1
    800000b8:	ff450513          	addi	a0,a0,-12 # 800010a8 <clear_line+0x256>
    800000bc:	00000097          	auipc	ra,0x0
    800000c0:	7f8080e7          	jalr	2040(ra) # 800008b4 <printf>
    printf("  负数: %d\n", -42);
    800000c4:	fd600593          	li	a1,-42
    800000c8:	00001517          	auipc	a0,0x1
    800000cc:	ff050513          	addi	a0,a0,-16 # 800010b8 <clear_line+0x266>
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	7e4080e7          	jalr	2020(ra) # 800008b4 <printf>
    printf("  零: %d\n", 0);
    800000d8:	4581                	li	a1,0
    800000da:	00001517          	auipc	a0,0x1
    800000de:	fee50513          	addi	a0,a0,-18 # 800010c8 <clear_line+0x276>
    800000e2:	00000097          	auipc	ra,0x0
    800000e6:	7d2080e7          	jalr	2002(ra) # 800008b4 <printf>
    printf("  大数: %d\n", 123456789);
    800000ea:	075bd5b7          	lui	a1,0x75bd
    800000ee:	d1558593          	addi	a1,a1,-747 # 75bcd15 <_entry-0x78a432eb>
    800000f2:	00001517          	auipc	a0,0x1
    800000f6:	fe650513          	addi	a0,a0,-26 # 800010d8 <clear_line+0x286>
    800000fa:	00000097          	auipc	ra,0x0
    800000fe:	7ba080e7          	jalr	1978(ra) # 800008b4 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80000102:	00001517          	auipc	a0,0x1
    80000106:	fe650513          	addi	a0,a0,-26 # 800010e8 <clear_line+0x296>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	7aa080e7          	jalr	1962(ra) # 800008b4 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80000112:	55fd                	li	a1,-1
    80000114:	00001517          	auipc	a0,0x1
    80000118:	fec50513          	addi	a0,a0,-20 # 80001100 <clear_line+0x2ae>
    8000011c:	00000097          	auipc	ra,0x0
    80000120:	798080e7          	jalr	1944(ra) # 800008b4 <printf>
    printf("  零：%u\n", 0U);
    80000124:	4581                	li	a1,0
    80000126:	00001517          	auipc	a0,0x1
    8000012a:	ff250513          	addi	a0,a0,-14 # 80001118 <clear_line+0x2c6>
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	786080e7          	jalr	1926(ra) # 800008b4 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80000136:	658d                	lui	a1,0x3
    80000138:	03958593          	addi	a1,a1,57 # 3039 <_entry-0x7fffcfc7>
    8000013c:	00001517          	auipc	a0,0x1
    80000140:	fec50513          	addi	a0,a0,-20 # 80001128 <clear_line+0x2d6>
    80000144:	00000097          	auipc	ra,0x0
    80000148:	770080e7          	jalr	1904(ra) # 800008b4 <printf>

	// 测试边界
	printf("边界测试:\n");
    8000014c:	00001517          	auipc	a0,0x1
    80000150:	ff450513          	addi	a0,a0,-12 # 80001140 <clear_line+0x2ee>
    80000154:	00000097          	auipc	ra,0x0
    80000158:	760080e7          	jalr	1888(ra) # 800008b4 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    8000015c:	800005b7          	lui	a1,0x80000
    80000160:	fff5c593          	not	a1,a1
    80000164:	00001517          	auipc	a0,0x1
    80000168:	fec50513          	addi	a0,a0,-20 # 80001150 <clear_line+0x2fe>
    8000016c:	00000097          	auipc	ra,0x0
    80000170:	748080e7          	jalr	1864(ra) # 800008b4 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    80000174:	800005b7          	lui	a1,0x80000
    80000178:	00001517          	auipc	a0,0x1
    8000017c:	fe850513          	addi	a0,a0,-24 # 80001160 <clear_line+0x30e>
    80000180:	00000097          	auipc	ra,0x0
    80000184:	734080e7          	jalr	1844(ra) # 800008b4 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    80000188:	55fd                	li	a1,-1
    8000018a:	00001517          	auipc	a0,0x1
    8000018e:	fe650513          	addi	a0,a0,-26 # 80001170 <clear_line+0x31e>
    80000192:	00000097          	auipc	ra,0x0
    80000196:	722080e7          	jalr	1826(ra) # 800008b4 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    8000019a:	55fd                	li	a1,-1
    8000019c:	00001517          	auipc	a0,0x1
    800001a0:	fe450513          	addi	a0,a0,-28 # 80001180 <clear_line+0x32e>
    800001a4:	00000097          	auipc	ra,0x0
    800001a8:	710080e7          	jalr	1808(ra) # 800008b4 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    800001ac:	00001517          	auipc	a0,0x1
    800001b0:	fec50513          	addi	a0,a0,-20 # 80001198 <clear_line+0x346>
    800001b4:	00000097          	auipc	ra,0x0
    800001b8:	700080e7          	jalr	1792(ra) # 800008b4 <printf>
    printf("  空字符串: '%s'\n", "");
    800001bc:	00001597          	auipc	a1,0x1
    800001c0:	24c58593          	addi	a1,a1,588 # 80001408 <clear_line+0x5b6>
    800001c4:	00001517          	auipc	a0,0x1
    800001c8:	fec50513          	addi	a0,a0,-20 # 800011b0 <clear_line+0x35e>
    800001cc:	00000097          	auipc	ra,0x0
    800001d0:	6e8080e7          	jalr	1768(ra) # 800008b4 <printf>
    printf("  单字符: '%s'\n", "X");
    800001d4:	00001597          	auipc	a1,0x1
    800001d8:	ff458593          	addi	a1,a1,-12 # 800011c8 <clear_line+0x376>
    800001dc:	00001517          	auipc	a0,0x1
    800001e0:	ff450513          	addi	a0,a0,-12 # 800011d0 <clear_line+0x37e>
    800001e4:	00000097          	auipc	ra,0x0
    800001e8:	6d0080e7          	jalr	1744(ra) # 800008b4 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    800001ec:	00001597          	auipc	a1,0x1
    800001f0:	ffc58593          	addi	a1,a1,-4 # 800011e8 <clear_line+0x396>
    800001f4:	00001517          	auipc	a0,0x1
    800001f8:	01450513          	addi	a0,a0,20 # 80001208 <clear_line+0x3b6>
    800001fc:	00000097          	auipc	ra,0x0
    80000200:	6b8080e7          	jalr	1720(ra) # 800008b4 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80000204:	00001597          	auipc	a1,0x1
    80000208:	01c58593          	addi	a1,a1,28 # 80001220 <clear_line+0x3ce>
    8000020c:	00001517          	auipc	a0,0x1
    80000210:	16450513          	addi	a0,a0,356 # 80001370 <clear_line+0x51e>
    80000214:	00000097          	auipc	ra,0x0
    80000218:	6a0080e7          	jalr	1696(ra) # 800008b4 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    8000021c:	00001517          	auipc	a0,0x1
    80000220:	17450513          	addi	a0,a0,372 # 80001390 <clear_line+0x53e>
    80000224:	00000097          	auipc	ra,0x0
    80000228:	690080e7          	jalr	1680(ra) # 800008b4 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u, Str: '%s'\n", 255, -255, 255U, "Test");
    8000022c:	00001717          	auipc	a4,0x1
    80000230:	17c70713          	addi	a4,a4,380 # 800013a8 <clear_line+0x556>
    80000234:	0ff00693          	li	a3,255
    80000238:	f0100613          	li	a2,-255
    8000023c:	0ff00593          	li	a1,255
    80000240:	00001517          	auipc	a0,0x1
    80000244:	17050513          	addi	a0,a0,368 # 800013b0 <clear_line+0x55e>
    80000248:	00000097          	auipc	ra,0x0
    8000024c:	66c080e7          	jalr	1644(ra) # 800008b4 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80000250:	00001517          	auipc	a0,0x1
    80000254:	19050513          	addi	a0,a0,400 # 800013e0 <clear_line+0x58e>
    80000258:	00000097          	auipc	ra,0x0
    8000025c:	65c080e7          	jalr	1628(ra) # 800008b4 <printf>
	printf("  100%% 完成!\n");
    80000260:	00001517          	auipc	a0,0x1
    80000264:	19850513          	addi	a0,a0,408 # 800013f8 <clear_line+0x5a6>
    80000268:	00000097          	auipc	ra,0x0
    8000026c:	64c080e7          	jalr	1612(ra) # 800008b4 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
	printf("NULL字符串测试:\n");
    80000270:	00001517          	auipc	a0,0x1
    80000274:	1a050513          	addi	a0,a0,416 # 80001410 <clear_line+0x5be>
    80000278:	00000097          	auipc	ra,0x0
    8000027c:	63c080e7          	jalr	1596(ra) # 800008b4 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    80000280:	4581                	li	a1,0
    80000282:	00001517          	auipc	a0,0x1
    80000286:	1a650513          	addi	a0,a0,422 # 80001428 <clear_line+0x5d6>
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	62a080e7          	jalr	1578(ra) # 800008b4 <printf>
	
	// 测试指针格式
	int var = 42;
    80000292:	02a00793          	li	a5,42
    80000296:	fef42623          	sw	a5,-20(s0)
	printf("指针测试:\n");
    8000029a:	00001517          	auipc	a0,0x1
    8000029e:	1a650513          	addi	a0,a0,422 # 80001440 <clear_line+0x5ee>
    800002a2:	00000097          	auipc	ra,0x0
    800002a6:	612080e7          	jalr	1554(ra) # 800008b4 <printf>
	printf("  Address of var: %p\n", &var);
    800002aa:	fec40593          	addi	a1,s0,-20
    800002ae:	00001517          	auipc	a0,0x1
    800002b2:	1a250513          	addi	a0,a0,418 # 80001450 <clear_line+0x5fe>
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	5fe080e7          	jalr	1534(ra) # 800008b4 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    800002be:	00001517          	auipc	a0,0x1
    800002c2:	1aa50513          	addi	a0,a0,426 # 80001468 <clear_line+0x616>
    800002c6:	00000097          	auipc	ra,0x0
    800002ca:	5ee080e7          	jalr	1518(ra) # 800008b4 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    800002ce:	55fd                	li	a1,-1
    800002d0:	00001517          	auipc	a0,0x1
    800002d4:	1b850513          	addi	a0,a0,440 # 80001488 <clear_line+0x636>
    800002d8:	00000097          	auipc	ra,0x0
    800002dc:	5dc080e7          	jalr	1500(ra) # 800008b4 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    800002e0:	00001517          	auipc	a0,0x1
    800002e4:	1c050513          	addi	a0,a0,448 # 800014a0 <clear_line+0x64e>
    800002e8:	00000097          	auipc	ra,0x0
    800002ec:	5cc080e7          	jalr	1484(ra) # 800008b4 <printf>
	printf("  Binary of 5 (not supported, expect garbage): %b\n", 5); // %b未实现，预期输出垃圾
    800002f0:	4595                	li	a1,5
    800002f2:	00001517          	auipc	a0,0x1
    800002f6:	1c650513          	addi	a0,a0,454 # 800014b8 <clear_line+0x666>
    800002fa:	00000097          	auipc	ra,0x0
    800002fe:	5ba080e7          	jalr	1466(ra) # 800008b4 <printf>
	printf("  Octal of 8 (not supported, expect garbage): %o\n", 8);   // %o未实现，预期输出垃圾
    80000302:	45a1                	li	a1,8
    80000304:	00001517          	auipc	a0,0x1
    80000308:	1ec50513          	addi	a0,a0,492 # 800014f0 <clear_line+0x69e>
    8000030c:	00000097          	auipc	ra,0x0
    80000310:	5a8080e7          	jalr	1448(ra) # 800008b4 <printf>
	printf("=== Printf测试结束 ===\n");
    80000314:	00001517          	auipc	a0,0x1
    80000318:	21450513          	addi	a0,a0,532 # 80001528 <clear_line+0x6d6>
    8000031c:	00000097          	auipc	ra,0x0
    80000320:	598080e7          	jalr	1432(ra) # 800008b4 <printf>
}
    80000324:	60e2                	ld	ra,24(sp)
    80000326:	6442                	ld	s0,16(sp)
    80000328:	6105                	addi	sp,sp,32
    8000032a:	8082                	ret

000000008000032c <test_curse_move>:
void test_curse_move(){
    8000032c:	7139                	addi	sp,sp,-64
    8000032e:	fc06                	sd	ra,56(sp)
    80000330:	f822                	sd	s0,48(sp)
    80000332:	f426                	sd	s1,40(sp)
    80000334:	f04a                	sd	s2,32(sp)
    80000336:	ec4e                	sd	s3,24(sp)
    80000338:	e852                	sd	s4,16(sp)
    8000033a:	e456                	sd	s5,8(sp)
    8000033c:	e05a                	sd	s6,0(sp)
    8000033e:	0080                	addi	s0,sp,64
	clear_screen(); // 清屏
    80000340:	00000097          	auipc	ra,0x0
    80000344:	6ea080e7          	jalr	1770(ra) # 80000a2a <clear_screen>
	printf("=== 光标移动测试 ===\n");
    80000348:	00001517          	auipc	a0,0x1
    8000034c:	20050513          	addi	a0,a0,512 # 80001548 <clear_line+0x6f6>
    80000350:	00000097          	auipc	ra,0x0
    80000354:	564080e7          	jalr	1380(ra) # 800008b4 <printf>
	for (int i = 3; i <= 7; i++) {
    80000358:	490d                	li	s2,3
		for (int j = 1; j <= 10; j++) {
    8000035a:	4b05                	li	s6,1
			goto_rc(i, j);
			printf("*");
    8000035c:	00001a17          	auipc	s4,0x1
    80000360:	20ca0a13          	addi	s4,s4,524 # 80001568 <clear_line+0x716>
		for (int j = 1; j <= 10; j++) {
    80000364:	49ad                	li	s3,11
	for (int i = 3; i <= 7; i++) {
    80000366:	4aa1                	li	s5,8
		for (int j = 1; j <= 10; j++) {
    80000368:	84da                	mv	s1,s6
			goto_rc(i, j);
    8000036a:	85a6                	mv	a1,s1
    8000036c:	854a                	mv	a0,s2
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	8d0080e7          	jalr	-1840(ra) # 80000c3e <goto_rc>
			printf("*");
    80000376:	8552                	mv	a0,s4
    80000378:	00000097          	auipc	ra,0x0
    8000037c:	53c080e7          	jalr	1340(ra) # 800008b4 <printf>
		for (int j = 1; j <= 10; j++) {
    80000380:	2485                	addiw	s1,s1,1
    80000382:	ff3494e3          	bne	s1,s3,8000036a <test_curse_move+0x3e>
	for (int i = 3; i <= 7; i++) {
    80000386:	2905                	addiw	s2,s2,1
    80000388:	ff5910e3          	bne	s2,s5,80000368 <test_curse_move+0x3c>
		}
	}
	goto_rc(9, 1);
    8000038c:	4585                	li	a1,1
    8000038e:	4525                	li	a0,9
    80000390:	00001097          	auipc	ra,0x1
    80000394:	8ae080e7          	jalr	-1874(ra) # 80000c3e <goto_rc>
	save_cursor();
    80000398:	00000097          	auipc	ra,0x0
    8000039c:	7f2080e7          	jalr	2034(ra) # 80000b8a <save_cursor>
	// 光标移动测试
	cursor_up(5);
    800003a0:	4515                	li	a0,5
    800003a2:	00000097          	auipc	ra,0x0
    800003a6:	6b8080e7          	jalr	1720(ra) # 80000a5a <cursor_up>
	cursor_right(2);
    800003aa:	4509                	li	a0,2
    800003ac:	00000097          	auipc	ra,0x0
    800003b0:	746080e7          	jalr	1862(ra) # 80000af2 <cursor_right>
	printf("+++++");
    800003b4:	00001517          	auipc	a0,0x1
    800003b8:	1bc50513          	addi	a0,a0,444 # 80001570 <clear_line+0x71e>
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	4f8080e7          	jalr	1272(ra) # 800008b4 <printf>
	cursor_down(2);
    800003c4:	4509                	li	a0,2
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	6e0080e7          	jalr	1760(ra) # 80000aa6 <cursor_down>
	cursor_left(5);
    800003ce:	4515                	li	a0,5
    800003d0:	00000097          	auipc	ra,0x0
    800003d4:	76e080e7          	jalr	1902(ra) # 80000b3e <cursor_left>
	printf("-----");
    800003d8:	00001517          	auipc	a0,0x1
    800003dc:	1a050513          	addi	a0,a0,416 # 80001578 <clear_line+0x726>
    800003e0:	00000097          	auipc	ra,0x0
    800003e4:	4d4080e7          	jalr	1236(ra) # 800008b4 <printf>
	restore_cursor();
    800003e8:	00000097          	auipc	ra,0x0
    800003ec:	7d4080e7          	jalr	2004(ra) # 80000bbc <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    800003f0:	00001517          	auipc	a0,0x1
    800003f4:	19050513          	addi	a0,a0,400 # 80001580 <clear_line+0x72e>
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	4bc080e7          	jalr	1212(ra) # 800008b4 <printf>
}
    80000400:	70e2                	ld	ra,56(sp)
    80000402:	7442                	ld	s0,48(sp)
    80000404:	74a2                	ld	s1,40(sp)
    80000406:	7902                	ld	s2,32(sp)
    80000408:	69e2                	ld	s3,24(sp)
    8000040a:	6a42                	ld	s4,16(sp)
    8000040c:	6aa2                	ld	s5,8(sp)
    8000040e:	6b02                	ld	s6,0(sp)
    80000410:	6121                	addi	sp,sp,64
    80000412:	8082                	ret

0000000080000414 <test_basic_colors>:
void test_basic_colors(void) {
    80000414:	1141                	addi	sp,sp,-16
    80000416:	e406                	sd	ra,8(sp)
    80000418:	e022                	sd	s0,0(sp)
    8000041a:	0800                	addi	s0,sp,16
    clear_screen();
    8000041c:	00000097          	auipc	ra,0x0
    80000420:	60e080e7          	jalr	1550(ra) # 80000a2a <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    80000424:	00001517          	auipc	a0,0x1
    80000428:	18450513          	addi	a0,a0,388 # 800015a8 <clear_line+0x756>
    8000042c:	00000097          	auipc	ra,0x0
    80000430:	488080e7          	jalr	1160(ra) # 800008b4 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80000434:	00001517          	auipc	a0,0x1
    80000438:	19450513          	addi	a0,a0,404 # 800015c8 <clear_line+0x776>
    8000043c:	00000097          	auipc	ra,0x0
    80000440:	478080e7          	jalr	1144(ra) # 800008b4 <printf>
    color_red();    printf("红色文字 ");
    80000444:	00001097          	auipc	ra,0x1
    80000448:	924080e7          	jalr	-1756(ra) # 80000d68 <color_red>
    8000044c:	00001517          	auipc	a0,0x1
    80000450:	19450513          	addi	a0,a0,404 # 800015e0 <clear_line+0x78e>
    80000454:	00000097          	auipc	ra,0x0
    80000458:	460080e7          	jalr	1120(ra) # 800008b4 <printf>
    color_green();  printf("绿色文字 ");
    8000045c:	00001097          	auipc	ra,0x1
    80000460:	926080e7          	jalr	-1754(ra) # 80000d82 <color_green>
    80000464:	00001517          	auipc	a0,0x1
    80000468:	18c50513          	addi	a0,a0,396 # 800015f0 <clear_line+0x79e>
    8000046c:	00000097          	auipc	ra,0x0
    80000470:	448080e7          	jalr	1096(ra) # 800008b4 <printf>
    color_yellow(); printf("黄色文字 ");
    80000474:	00001097          	auipc	ra,0x1
    80000478:	92a080e7          	jalr	-1750(ra) # 80000d9e <color_yellow>
    8000047c:	00001517          	auipc	a0,0x1
    80000480:	18450513          	addi	a0,a0,388 # 80001600 <clear_line+0x7ae>
    80000484:	00000097          	auipc	ra,0x0
    80000488:	430080e7          	jalr	1072(ra) # 800008b4 <printf>
    color_blue();   printf("蓝色文字 ");
    8000048c:	00001097          	auipc	ra,0x1
    80000490:	92e080e7          	jalr	-1746(ra) # 80000dba <color_blue>
    80000494:	00001517          	auipc	a0,0x1
    80000498:	17c50513          	addi	a0,a0,380 # 80001610 <clear_line+0x7be>
    8000049c:	00000097          	auipc	ra,0x0
    800004a0:	418080e7          	jalr	1048(ra) # 800008b4 <printf>
    color_purple(); printf("紫色文字 ");
    800004a4:	00001097          	auipc	ra,0x1
    800004a8:	932080e7          	jalr	-1742(ra) # 80000dd6 <color_purple>
    800004ac:	00001517          	auipc	a0,0x1
    800004b0:	17450513          	addi	a0,a0,372 # 80001620 <clear_line+0x7ce>
    800004b4:	00000097          	auipc	ra,0x0
    800004b8:	400080e7          	jalr	1024(ra) # 800008b4 <printf>
    color_cyan();   printf("青色文字 ");
    800004bc:	00001097          	auipc	ra,0x1
    800004c0:	936080e7          	jalr	-1738(ra) # 80000df2 <color_cyan>
    800004c4:	00001517          	auipc	a0,0x1
    800004c8:	16c50513          	addi	a0,a0,364 # 80001630 <clear_line+0x7de>
    800004cc:	00000097          	auipc	ra,0x0
    800004d0:	3e8080e7          	jalr	1000(ra) # 800008b4 <printf>
    color_white();  printf("白色文字");
    800004d4:	00001097          	auipc	ra,0x1
    800004d8:	93a080e7          	jalr	-1734(ra) # 80000e0e <color_white>
    800004dc:	00001517          	auipc	a0,0x1
    800004e0:	16450513          	addi	a0,a0,356 # 80001640 <clear_line+0x7ee>
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	3d0080e7          	jalr	976(ra) # 800008b4 <printf>
    reset_color();
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	7b8080e7          	jalr	1976(ra) # 80000ca4 <reset_color>
    printf("\n\n");
    800004f4:	00001517          	auipc	a0,0x1
    800004f8:	15c50513          	addi	a0,a0,348 # 80001650 <clear_line+0x7fe>
    800004fc:	00000097          	auipc	ra,0x0
    80000500:	3b8080e7          	jalr	952(ra) # 800008b4 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80000504:	00001517          	auipc	a0,0x1
    80000508:	15450513          	addi	a0,a0,340 # 80001658 <clear_line+0x806>
    8000050c:	00000097          	auipc	ra,0x0
    80000510:	3a8080e7          	jalr	936(ra) # 800008b4 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80000514:	02900513          	li	a0,41
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	7fe080e7          	jalr	2046(ra) # 80000d16 <set_bg_color>
    80000520:	00001517          	auipc	a0,0x1
    80000524:	15050513          	addi	a0,a0,336 # 80001670 <clear_line+0x81e>
    80000528:	00000097          	auipc	ra,0x0
    8000052c:	38c080e7          	jalr	908(ra) # 800008b4 <printf>
    80000530:	00000097          	auipc	ra,0x0
    80000534:	774080e7          	jalr	1908(ra) # 80000ca4 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80000538:	02a00513          	li	a0,42
    8000053c:	00000097          	auipc	ra,0x0
    80000540:	7da080e7          	jalr	2010(ra) # 80000d16 <set_bg_color>
    80000544:	00001517          	auipc	a0,0x1
    80000548:	13c50513          	addi	a0,a0,316 # 80001680 <clear_line+0x82e>
    8000054c:	00000097          	auipc	ra,0x0
    80000550:	368080e7          	jalr	872(ra) # 800008b4 <printf>
    80000554:	00000097          	auipc	ra,0x0
    80000558:	750080e7          	jalr	1872(ra) # 80000ca4 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    8000055c:	02b00513          	li	a0,43
    80000560:	00000097          	auipc	ra,0x0
    80000564:	7b6080e7          	jalr	1974(ra) # 80000d16 <set_bg_color>
    80000568:	00001517          	auipc	a0,0x1
    8000056c:	12850513          	addi	a0,a0,296 # 80001690 <clear_line+0x83e>
    80000570:	00000097          	auipc	ra,0x0
    80000574:	344080e7          	jalr	836(ra) # 800008b4 <printf>
    80000578:	00000097          	auipc	ra,0x0
    8000057c:	72c080e7          	jalr	1836(ra) # 80000ca4 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80000580:	02c00513          	li	a0,44
    80000584:	00000097          	auipc	ra,0x0
    80000588:	792080e7          	jalr	1938(ra) # 80000d16 <set_bg_color>
    8000058c:	00001517          	auipc	a0,0x1
    80000590:	11450513          	addi	a0,a0,276 # 800016a0 <clear_line+0x84e>
    80000594:	00000097          	auipc	ra,0x0
    80000598:	320080e7          	jalr	800(ra) # 800008b4 <printf>
    8000059c:	00000097          	auipc	ra,0x0
    800005a0:	708080e7          	jalr	1800(ra) # 80000ca4 <reset_color>
    printf("\n\n");
    800005a4:	00001517          	auipc	a0,0x1
    800005a8:	0ac50513          	addi	a0,a0,172 # 80001650 <clear_line+0x7fe>
    800005ac:	00000097          	auipc	ra,0x0
    800005b0:	308080e7          	jalr	776(ra) # 800008b4 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    800005b4:	00001517          	auipc	a0,0x1
    800005b8:	0fc50513          	addi	a0,a0,252 # 800016b0 <clear_line+0x85e>
    800005bc:	00000097          	auipc	ra,0x0
    800005c0:	2f8080e7          	jalr	760(ra) # 800008b4 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    800005c4:	02c00593          	li	a1,44
    800005c8:	457d                	li	a0,31
    800005ca:	00001097          	auipc	ra,0x1
    800005ce:	860080e7          	jalr	-1952(ra) # 80000e2a <set_color>
    800005d2:	00001517          	auipc	a0,0x1
    800005d6:	0f650513          	addi	a0,a0,246 # 800016c8 <clear_line+0x876>
    800005da:	00000097          	auipc	ra,0x0
    800005de:	2da080e7          	jalr	730(ra) # 800008b4 <printf>
    800005e2:	00000097          	auipc	ra,0x0
    800005e6:	6c2080e7          	jalr	1730(ra) # 80000ca4 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    800005ea:	02d00593          	li	a1,45
    800005ee:	02100513          	li	a0,33
    800005f2:	00001097          	auipc	ra,0x1
    800005f6:	838080e7          	jalr	-1992(ra) # 80000e2a <set_color>
    800005fa:	00001517          	auipc	a0,0x1
    800005fe:	0de50513          	addi	a0,a0,222 # 800016d8 <clear_line+0x886>
    80000602:	00000097          	auipc	ra,0x0
    80000606:	2b2080e7          	jalr	690(ra) # 800008b4 <printf>
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	69a080e7          	jalr	1690(ra) # 80000ca4 <reset_color>
    set_color(32, 47); printf(" 绿字白底 "); reset_color();
    80000612:	02f00593          	li	a1,47
    80000616:	02000513          	li	a0,32
    8000061a:	00001097          	auipc	ra,0x1
    8000061e:	810080e7          	jalr	-2032(ra) # 80000e2a <set_color>
    80000622:	00001517          	auipc	a0,0x1
    80000626:	0c650513          	addi	a0,a0,198 # 800016e8 <clear_line+0x896>
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	28a080e7          	jalr	650(ra) # 800008b4 <printf>
    80000632:	00000097          	auipc	ra,0x0
    80000636:	672080e7          	jalr	1650(ra) # 80000ca4 <reset_color>
    printf("\n\n");
    8000063a:	00001517          	auipc	a0,0x1
    8000063e:	01650513          	addi	a0,a0,22 # 80001650 <clear_line+0x7fe>
    80000642:	00000097          	auipc	ra,0x0
    80000646:	272080e7          	jalr	626(ra) # 800008b4 <printf>
	reset_color();
    8000064a:	00000097          	auipc	ra,0x0
    8000064e:	65a080e7          	jalr	1626(ra) # 80000ca4 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80000652:	00001517          	auipc	a0,0x1
    80000656:	0a650513          	addi	a0,a0,166 # 800016f8 <clear_line+0x8a6>
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	25a080e7          	jalr	602(ra) # 800008b4 <printf>
	cursor_up(1); // 光标上移一行
    80000662:	4505                	li	a0,1
    80000664:	00000097          	auipc	ra,0x0
    80000668:	3f6080e7          	jalr	1014(ra) # 80000a5a <cursor_up>
	clear_line();
    8000066c:	00000097          	auipc	ra,0x0
    80000670:	7e6080e7          	jalr	2022(ra) # 80000e52 <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80000674:	00001517          	auipc	a0,0x1
    80000678:	0bc50513          	addi	a0,a0,188 # 80001730 <clear_line+0x8de>
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	238080e7          	jalr	568(ra) # 800008b4 <printf>
    80000684:	60a2                	ld	ra,8(sp)
    80000686:	6402                	ld	s0,0(sp)
    80000688:	0141                	addi	sp,sp,16
    8000068a:	8082                	ret

000000008000068c <start>:
void start(){
    8000068c:	1141                	addi	sp,sp,-16
    8000068e:	e406                	sd	ra,8(sp)
    80000690:	e022                	sd	s0,0(sp)
    80000692:	0800                	addi	s0,sp,16
    uart_puts("===============================================\n");
    80000694:	00001517          	auipc	a0,0x1
    80000698:	0bc50513          	addi	a0,a0,188 # 80001750 <clear_line+0x8fe>
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	116080e7          	jalr	278(ra) # 800007b2 <uart_puts>
    uart_puts("        RISC-V Operating System v1.0         \n");
    800006a4:	00001517          	auipc	a0,0x1
    800006a8:	0e450513          	addi	a0,a0,228 # 80001788 <clear_line+0x936>
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	106080e7          	jalr	262(ra) # 800007b2 <uart_puts>
    uart_puts("===============================================\n\n");
    800006b4:	00001517          	auipc	a0,0x1
    800006b8:	10450513          	addi	a0,a0,260 # 800017b8 <clear_line+0x966>
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	0f6080e7          	jalr	246(ra) # 800007b2 <uart_puts>
    uart_puts("Hello, RISC-V Kernel!\n");
    800006c4:	00001517          	auipc	a0,0x1
    800006c8:	12c50513          	addi	a0,a0,300 # 800017f0 <clear_line+0x99e>
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	0e6080e7          	jalr	230(ra) # 800007b2 <uart_puts>
    uart_puts("Kernel startup complete!\n");
    800006d4:	00001517          	auipc	a0,0x1
    800006d8:	13450513          	addi	a0,a0,308 # 80001808 <clear_line+0x9b6>
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	0d6080e7          	jalr	214(ra) # 800007b2 <uart_puts>
    uart_puts("Testing BSS zero initialization:\n");
    800006e4:	00001517          	auipc	a0,0x1
    800006e8:	14450513          	addi	a0,a0,324 # 80001828 <clear_line+0x9d6>
    800006ec:	00000097          	auipc	ra,0x0
    800006f0:	0c6080e7          	jalr	198(ra) # 800007b2 <uart_puts>
    if (global_test1 == 0 && global_test2 == 0) {
    800006f4:	00004797          	auipc	a5,0x4
    800006f8:	9107a783          	lw	a5,-1776(a5) # 80004004 <global_test1>
    800006fc:	00004717          	auipc	a4,0x4
    80000700:	90472703          	lw	a4,-1788(a4) # 80004000 <global_test2>
    80000704:	8fd9                	or	a5,a5,a4
    80000706:	c3b5                	beqz	a5,8000076a <start+0xde>
        uart_puts("  [ERROR] BSS variables not zeroed!\n");
    80000708:	00001517          	auipc	a0,0x1
    8000070c:	17050513          	addi	a0,a0,368 # 80001878 <clear_line+0xa26>
    80000710:	00000097          	auipc	ra,0x0
    80000714:	0a2080e7          	jalr	162(ra) # 800007b2 <uart_puts>
    if (initialized_global == 123) {
    80000718:	00002717          	auipc	a4,0x2
    8000071c:	8e872703          	lw	a4,-1816(a4) # 80002000 <initialized_global>
    80000720:	07b00793          	li	a5,123
    80000724:	04f70c63          	beq	a4,a5,8000077c <start+0xf0>
        uart_puts("  [ERROR] Initialized variables corrupted!\n");
    80000728:	00001517          	auipc	a0,0x1
    8000072c:	1a050513          	addi	a0,a0,416 # 800018c8 <clear_line+0xa76>
    80000730:	00000097          	auipc	ra,0x0
    80000734:	082080e7          	jalr	130(ra) # 800007b2 <uart_puts>
    uart_puts("\nSystem ready. Entering main loop...\n");
    80000738:	00001517          	auipc	a0,0x1
    8000073c:	1c050513          	addi	a0,a0,448 # 800018f8 <clear_line+0xaa6>
    80000740:	00000097          	auipc	ra,0x0
    80000744:	072080e7          	jalr	114(ra) # 800007b2 <uart_puts>
	clear_screen();
    80000748:	00000097          	auipc	ra,0x0
    8000074c:	2e2080e7          	jalr	738(ra) # 80000a2a <clear_screen>
	test_printf_precision();
    80000750:	00000097          	auipc	ra,0x0
    80000754:	8e2080e7          	jalr	-1822(ra) # 80000032 <test_printf_precision>
	test_curse_move();
    80000758:	00000097          	auipc	ra,0x0
    8000075c:	bd4080e7          	jalr	-1068(ra) # 8000032c <test_curse_move>
	test_basic_colors();
    80000760:	00000097          	auipc	ra,0x0
    80000764:	cb4080e7          	jalr	-844(ra) # 80000414 <test_basic_colors>
    while(1) {
    80000768:	a001                	j	80000768 <start+0xdc>
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    8000076a:	00001517          	auipc	a0,0x1
    8000076e:	0e650513          	addi	a0,a0,230 # 80001850 <clear_line+0x9fe>
    80000772:	00000097          	auipc	ra,0x0
    80000776:	040080e7          	jalr	64(ra) # 800007b2 <uart_puts>
    8000077a:	bf79                	j	80000718 <start+0x8c>
        uart_puts("  [OK] Initialized variables working\n");
    8000077c:	00001517          	auipc	a0,0x1
    80000780:	12450513          	addi	a0,a0,292 # 800018a0 <clear_line+0xa4e>
    80000784:	00000097          	auipc	ra,0x0
    80000788:	02e080e7          	jalr	46(ra) # 800007b2 <uart_puts>
    8000078c:	b775                	j	80000738 <start+0xac>

000000008000078e <uart_putc>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))


void uart_putc(char c)
{
    8000078e:	1141                	addi	sp,sp,-16
    80000790:	e422                	sd	s0,8(sp)
    80000792:	0800                	addi	s0,sp,16
  // 等待发送缓冲区空闲
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000794:	10000737          	lui	a4,0x10000
    80000798:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000079a:	00074783          	lbu	a5,0(a4)
    8000079e:	0207f793          	andi	a5,a5,32
    800007a2:	dfe5                	beqz	a5,8000079a <uart_putc+0xc>
    ;
  // 写入字符到发送寄存器
  WriteReg(THR, c);
    800007a4:	100007b7          	lui	a5,0x10000
    800007a8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    800007ac:	6422                	ld	s0,8(sp)
    800007ae:	0141                	addi	sp,sp,16
    800007b0:	8082                	ret

00000000800007b2 <uart_puts>:

// 成功后实现字符串输出
void uart_puts(char *s)
{
    800007b2:	1141                	addi	sp,sp,-16
    800007b4:	e422                	sd	s0,8(sp)
    800007b6:	0800                	addi	s0,sp,16
    if (!s) return;
    800007b8:	cd15                	beqz	a0,800007f4 <uart_puts+0x42>
    
    while (*s) {
    800007ba:	00054783          	lbu	a5,0(a0)
    800007be:	cb9d                	beqz	a5,800007f4 <uart_puts+0x42>
        // 批量检查：一次等待，发送多个字符
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007c0:	10000737          	lui	a4,0x10000
    800007c4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
            ;
            
        // 连续发送字符，直到缓冲区可能满或字符串结束
        int sent_count = 0;
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
            WriteReg(THR, *s);
    800007c6:	10000637          	lui	a2,0x10000
    800007ca:	a011                	j	800007ce <uart_puts+0x1c>
    while (*s) {
    800007cc:	c785                	beqz	a5,800007f4 <uart_puts+0x42>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007ce:	00074783          	lbu	a5,0(a4)
    800007d2:	0207f793          	andi	a5,a5,32
    800007d6:	dfe5                	beqz	a5,800007ce <uart_puts+0x1c>
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    800007d8:	00054783          	lbu	a5,0(a0)
    800007dc:	cf81                	beqz	a5,800007f4 <uart_puts+0x42>
    800007de:	00450693          	addi	a3,a0,4
            WriteReg(THR, *s);
    800007e2:	00f60023          	sb	a5,0(a2) # 10000000 <_entry-0x70000000>
            s++;
    800007e6:	0505                	addi	a0,a0,1
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    800007e8:	00054783          	lbu	a5,0(a0)
    800007ec:	c781                	beqz	a5,800007f4 <uart_puts+0x42>
    800007ee:	fea69ae3          	bne	a3,a0,800007e2 <uart_puts+0x30>
    800007f2:	bfe9                	j	800007cc <uart_puts+0x1a>
            sent_count++;
        }
    }
    800007f4:	6422                	ld	s0,8(sp)
    800007f6:	0141                	addi	sp,sp,16
    800007f8:	8082                	ret

00000000800007fa <printint>:
static void consputs(const char *s){
	char *str = (char *)s;
	// 直接调用uart_puts输出字符串
	uart_puts(str);
}
static void printint(long long xx,int base,int sign){
    800007fa:	7139                	addi	sp,sp,-64
    800007fc:	fc06                	sd	ra,56(sp)
    800007fe:	f822                	sd	s0,48(sp)
    80000800:	0080                	addi	s0,sp,64
	// 模仿xv6的printint
	static char digits[] = "0123456789abcdef";
	char buf[20]; // 增大缓冲区以处理64位整数
	int i;
	unsigned long long x;
	if (sign && (sign = xx < 0)) // 符号处理
    80000802:	c219                	beqz	a2,80000808 <printint+0xe>
    80000804:	08054563          	bltz	a0,8000088e <printint+0x94>
		x = -(unsigned long long)xx; // 强制转换以避免溢出
	else
		x = xx;
    80000808:	4881                	li	a7,0

	if (base == 10 && x < 100) {
    8000080a:	47a9                	li	a5,10
    8000080c:	08f58563          	beq	a1,a5,80000896 <printint+0x9c>
		x = xx;
    80000810:	fc840693          	addi	a3,s0,-56
    80000814:	4781                	li	a5,0
		consputs(small_numbers[x]);
		return;
	}
	i = 0;
	do{
		buf[i] = digits[x % base];
    80000816:	00001617          	auipc	a2,0x1
    8000081a:	18260613          	addi	a2,a2,386 # 80001998 <small_numbers>
    8000081e:	02b57733          	remu	a4,a0,a1
    80000822:	9732                	add	a4,a4,a2
    80000824:	19074703          	lbu	a4,400(a4)
    80000828:	00e68023          	sb	a4,0(a3)
		i++;
    8000082c:	883e                	mv	a6,a5
    8000082e:	2785                	addiw	a5,a5,1
	}while((x/=base) !=0);
    80000830:	872a                	mv	a4,a0
    80000832:	02b55533          	divu	a0,a0,a1
    80000836:	0685                	addi	a3,a3,1
    80000838:	feb773e3          	bgeu	a4,a1,8000081e <printint+0x24>
	if (sign){
    8000083c:	00088a63          	beqz	a7,80000850 <printint+0x56>
		buf[i] = '-';
    80000840:	1781                	addi	a5,a5,-32
    80000842:	97a2                	add	a5,a5,s0
    80000844:	02d00713          	li	a4,45
    80000848:	fee78423          	sb	a4,-24(a5)
		i++;
    8000084c:	0028079b          	addiw	a5,a6,2
	}
	i--;
	while( i>=0){
    80000850:	02f05b63          	blez	a5,80000886 <printint+0x8c>
    80000854:	f426                	sd	s1,40(sp)
    80000856:	f04a                	sd	s2,32(sp)
    80000858:	fc840713          	addi	a4,s0,-56
    8000085c:	00f704b3          	add	s1,a4,a5
    80000860:	fff70913          	addi	s2,a4,-1
    80000864:	993e                	add	s2,s2,a5
    80000866:	37fd                	addiw	a5,a5,-1
    80000868:	1782                	slli	a5,a5,0x20
    8000086a:	9381                	srli	a5,a5,0x20
    8000086c:	40f90933          	sub	s2,s2,a5
	uart_putc(c);
    80000870:	fff4c503          	lbu	a0,-1(s1)
    80000874:	00000097          	auipc	ra,0x0
    80000878:	f1a080e7          	jalr	-230(ra) # 8000078e <uart_putc>
	while( i>=0){
    8000087c:	14fd                	addi	s1,s1,-1
    8000087e:	ff2499e3          	bne	s1,s2,80000870 <printint+0x76>
    80000882:	74a2                	ld	s1,40(sp)
    80000884:	7902                	ld	s2,32(sp)
		consputc(buf[i]);
		i--;
	}
}
    80000886:	70e2                	ld	ra,56(sp)
    80000888:	7442                	ld	s0,48(sp)
    8000088a:	6121                	addi	sp,sp,64
    8000088c:	8082                	ret
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    8000088e:	40a00533          	neg	a0,a0
	if (sign && (sign = xx < 0)) // 符号处理
    80000892:	4885                	li	a7,1
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    80000894:	bf9d                	j	8000080a <printint+0x10>
	if (base == 10 && x < 100) {
    80000896:	06300793          	li	a5,99
    8000089a:	f6a7ebe3          	bltu	a5,a0,80000810 <printint+0x16>
		consputs(small_numbers[x]);
    8000089e:	050a                	slli	a0,a0,0x2
	uart_puts(str);
    800008a0:	00001797          	auipc	a5,0x1
    800008a4:	0f878793          	addi	a5,a5,248 # 80001998 <small_numbers>
    800008a8:	953e                	add	a0,a0,a5
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	f08080e7          	jalr	-248(ra) # 800007b2 <uart_puts>
		return;
    800008b2:	bfd1                	j	80000886 <printint+0x8c>

00000000800008b4 <printf>:
void printf(const char *fmt, ...) {
    800008b4:	7175                	addi	sp,sp,-144
    800008b6:	e486                	sd	ra,72(sp)
    800008b8:	e0a2                	sd	s0,64(sp)
    800008ba:	f44e                	sd	s3,40(sp)
    800008bc:	0880                	addi	s0,sp,80
    800008be:	89aa                	mv	s3,a0
    800008c0:	e40c                	sd	a1,8(s0)
    800008c2:	e810                	sd	a2,16(s0)
    800008c4:	ec14                	sd	a3,24(s0)
    800008c6:	f018                	sd	a4,32(s0)
    800008c8:	f41c                	sd	a5,40(s0)
    800008ca:	03043823          	sd	a6,48(s0)
    800008ce:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    800008d2:	00840793          	addi	a5,s0,8
    800008d6:	faf43c23          	sd	a5,-72(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800008da:	00054503          	lbu	a0,0(a0)
    800008de:	12050b63          	beqz	a0,80000a14 <printf+0x160>
    800008e2:	fc26                	sd	s1,56(sp)
    800008e4:	f84a                	sd	s2,48(sp)
    800008e6:	f052                	sd	s4,32(sp)
    800008e8:	ec56                	sd	s5,24(sp)
    800008ea:	e85a                	sd	s6,16(sp)
    800008ec:	0005079b          	sext.w	a5,a0
    800008f0:	4481                	li	s1,0
        if(c != '%'){
    800008f2:	02500a13          	li	s4,37
            continue;
        }
        c = fmt[++i] & 0xff;
        if(c == 0)
            break;
        switch(c){
    800008f6:	4ad5                	li	s5,21
    800008f8:	00001b17          	auipc	s6,0x1
    800008fc:	048b0b13          	addi	s6,s6,72 # 80001940 <clear_line+0xaee>
    80000900:	a829                	j	8000091a <printf+0x66>
	uart_putc(c);
    80000902:	00000097          	auipc	ra,0x0
    80000906:	e8c080e7          	jalr	-372(ra) # 8000078e <uart_putc>
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000090a:	2485                	addiw	s1,s1,1
    8000090c:	009987b3          	add	a5,s3,s1
    80000910:	0007c503          	lbu	a0,0(a5)
    80000914:	0005079b          	sext.w	a5,a0
    80000918:	c96d                	beqz	a0,80000a0a <printf+0x156>
        if(c != '%'){
    8000091a:	ff4794e3          	bne	a5,s4,80000902 <printf+0x4e>
        c = fmt[++i] & 0xff;
    8000091e:	2485                	addiw	s1,s1,1
    80000920:	009987b3          	add	a5,s3,s1
    80000924:	0007c903          	lbu	s2,0(a5)
        if(c == 0)
    80000928:	0e090b63          	beqz	s2,80000a1e <printf+0x16a>
        switch(c){
    8000092c:	0b490e63          	beq	s2,s4,800009e8 <printf+0x134>
    80000930:	f9d9079b          	addiw	a5,s2,-99
    80000934:	0ff7f793          	zext.b	a5,a5
    80000938:	0afaee63          	bltu	s5,a5,800009f4 <printf+0x140>
    8000093c:	f9d9079b          	addiw	a5,s2,-99
    80000940:	0ff7f713          	zext.b	a4,a5
    80000944:	0aeae863          	bltu	s5,a4,800009f4 <printf+0x140>
    80000948:	00271793          	slli	a5,a4,0x2
    8000094c:	97da                	add	a5,a5,s6
    8000094e:	439c                	lw	a5,0(a5)
    80000950:	97da                	add	a5,a5,s6
    80000952:	8782                	jr	a5
        case 'd':
            printint(va_arg(ap, int), 10, 1);
    80000954:	fb843783          	ld	a5,-72(s0)
    80000958:	00878713          	addi	a4,a5,8
    8000095c:	fae43c23          	sd	a4,-72(s0)
    80000960:	4605                	li	a2,1
    80000962:	45a9                	li	a1,10
    80000964:	4388                	lw	a0,0(a5)
    80000966:	00000097          	auipc	ra,0x0
    8000096a:	e94080e7          	jalr	-364(ra) # 800007fa <printint>
            break;
    8000096e:	bf71                	j	8000090a <printf+0x56>
        case 'x':
            printint(va_arg(ap, int), 16, 0);
    80000970:	fb843783          	ld	a5,-72(s0)
    80000974:	00878713          	addi	a4,a5,8
    80000978:	fae43c23          	sd	a4,-72(s0)
    8000097c:	4601                	li	a2,0
    8000097e:	45c1                	li	a1,16
    80000980:	4388                	lw	a0,0(a5)
    80000982:	00000097          	auipc	ra,0x0
    80000986:	e78080e7          	jalr	-392(ra) # 800007fa <printint>
            break;
    8000098a:	b741                	j	8000090a <printf+0x56>
        case 'u':
            printint(va_arg(ap, unsigned int), 10, 0);
    8000098c:	fb843783          	ld	a5,-72(s0)
    80000990:	00878713          	addi	a4,a5,8
    80000994:	fae43c23          	sd	a4,-72(s0)
    80000998:	4601                	li	a2,0
    8000099a:	45a9                	li	a1,10
    8000099c:	0007e503          	lwu	a0,0(a5)
    800009a0:	00000097          	auipc	ra,0x0
    800009a4:	e5a080e7          	jalr	-422(ra) # 800007fa <printint>
            break;
    800009a8:	b78d                	j	8000090a <printf+0x56>
        case 'c':
            consputc(va_arg(ap, int));
    800009aa:	fb843783          	ld	a5,-72(s0)
    800009ae:	00878713          	addi	a4,a5,8
    800009b2:	fae43c23          	sd	a4,-72(s0)
	uart_putc(c);
    800009b6:	0007c503          	lbu	a0,0(a5)
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	dd4080e7          	jalr	-556(ra) # 8000078e <uart_putc>
}
    800009c2:	b7a1                	j	8000090a <printf+0x56>
            break;
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    800009c4:	fb843783          	ld	a5,-72(s0)
    800009c8:	00878713          	addi	a4,a5,8
    800009cc:	fae43c23          	sd	a4,-72(s0)
    800009d0:	6388                	ld	a0,0(a5)
    800009d2:	c511                	beqz	a0,800009de <printf+0x12a>
	uart_puts(str);
    800009d4:	00000097          	auipc	ra,0x0
    800009d8:	dde080e7          	jalr	-546(ra) # 800007b2 <uart_puts>
}
    800009dc:	b73d                	j	8000090a <printf+0x56>
                s = "(null)";
    800009de:	00001517          	auipc	a0,0x1
    800009e2:	f4250513          	addi	a0,a0,-190 # 80001920 <clear_line+0xace>
    800009e6:	b7fd                	j	800009d4 <printf+0x120>
	uart_putc(c);
    800009e8:	8552                	mv	a0,s4
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	da4080e7          	jalr	-604(ra) # 8000078e <uart_putc>
}
    800009f2:	bf21                	j	8000090a <printf+0x56>
	uart_putc(c);
    800009f4:	8552                	mv	a0,s4
    800009f6:	00000097          	auipc	ra,0x0
    800009fa:	d98080e7          	jalr	-616(ra) # 8000078e <uart_putc>
    800009fe:	854a                	mv	a0,s2
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	d8e080e7          	jalr	-626(ra) # 8000078e <uart_putc>
}
    80000a08:	b709                	j	8000090a <printf+0x56>
    80000a0a:	74e2                	ld	s1,56(sp)
    80000a0c:	7942                	ld	s2,48(sp)
    80000a0e:	7a02                	ld	s4,32(sp)
    80000a10:	6ae2                	ld	s5,24(sp)
    80000a12:	6b42                	ld	s6,16(sp)
            consputc(c);
            break;
        }
    }
    va_end(ap);
}
    80000a14:	60a6                	ld	ra,72(sp)
    80000a16:	6406                	ld	s0,64(sp)
    80000a18:	79a2                	ld	s3,40(sp)
    80000a1a:	6149                	addi	sp,sp,144
    80000a1c:	8082                	ret
    80000a1e:	74e2                	ld	s1,56(sp)
    80000a20:	7942                	ld	s2,48(sp)
    80000a22:	7a02                	ld	s4,32(sp)
    80000a24:	6ae2                	ld	s5,24(sp)
    80000a26:	6b42                	ld	s6,16(sp)
    80000a28:	b7f5                	j	80000a14 <printf+0x160>

0000000080000a2a <clear_screen>:
// 清屏功能
void clear_screen(void) {
    80000a2a:	1141                	addi	sp,sp,-16
    80000a2c:	e406                	sd	ra,8(sp)
    80000a2e:	e022                	sd	s0,0(sp)
    80000a30:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    80000a32:	00001517          	auipc	a0,0x1
    80000a36:	ef650513          	addi	a0,a0,-266 # 80001928 <clear_line+0xad6>
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	d78080e7          	jalr	-648(ra) # 800007b2 <uart_puts>
	uart_puts(CURSOR_HOME);
    80000a42:	00001517          	auipc	a0,0x1
    80000a46:	eee50513          	addi	a0,a0,-274 # 80001930 <clear_line+0xade>
    80000a4a:	00000097          	auipc	ra,0x0
    80000a4e:	d68080e7          	jalr	-664(ra) # 800007b2 <uart_puts>
}
    80000a52:	60a2                	ld	ra,8(sp)
    80000a54:	6402                	ld	s0,0(sp)
    80000a56:	0141                	addi	sp,sp,16
    80000a58:	8082                	ret

0000000080000a5a <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    if (lines <= 0) return;
    80000a5a:	04a05563          	blez	a0,80000aa4 <cursor_up+0x4a>
void cursor_up(int lines) {
    80000a5e:	1101                	addi	sp,sp,-32
    80000a60:	ec06                	sd	ra,24(sp)
    80000a62:	e822                	sd	s0,16(sp)
    80000a64:	e426                	sd	s1,8(sp)
    80000a66:	1000                	addi	s0,sp,32
    80000a68:	84aa                	mv	s1,a0
	uart_putc(c);
    80000a6a:	456d                	li	a0,27
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	d22080e7          	jalr	-734(ra) # 8000078e <uart_putc>
    80000a74:	05b00513          	li	a0,91
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	d16080e7          	jalr	-746(ra) # 8000078e <uart_putc>
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    80000a80:	4601                	li	a2,0
    80000a82:	45a9                	li	a1,10
    80000a84:	8526                	mv	a0,s1
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	d74080e7          	jalr	-652(ra) # 800007fa <printint>
	uart_putc(c);
    80000a8e:	04100513          	li	a0,65
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	cfc080e7          	jalr	-772(ra) # 8000078e <uart_putc>
    consputc('A');
}
    80000a9a:	60e2                	ld	ra,24(sp)
    80000a9c:	6442                	ld	s0,16(sp)
    80000a9e:	64a2                	ld	s1,8(sp)
    80000aa0:	6105                	addi	sp,sp,32
    80000aa2:	8082                	ret
    80000aa4:	8082                	ret

0000000080000aa6 <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    if (lines <= 0) return;
    80000aa6:	04a05563          	blez	a0,80000af0 <cursor_down+0x4a>
void cursor_down(int lines) {
    80000aaa:	1101                	addi	sp,sp,-32
    80000aac:	ec06                	sd	ra,24(sp)
    80000aae:	e822                	sd	s0,16(sp)
    80000ab0:	e426                	sd	s1,8(sp)
    80000ab2:	1000                	addi	s0,sp,32
    80000ab4:	84aa                	mv	s1,a0
	uart_putc(c);
    80000ab6:	456d                	li	a0,27
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	cd6080e7          	jalr	-810(ra) # 8000078e <uart_putc>
    80000ac0:	05b00513          	li	a0,91
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	cca080e7          	jalr	-822(ra) # 8000078e <uart_putc>
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    80000acc:	4601                	li	a2,0
    80000ace:	45a9                	li	a1,10
    80000ad0:	8526                	mv	a0,s1
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	d28080e7          	jalr	-728(ra) # 800007fa <printint>
	uart_putc(c);
    80000ada:	04200513          	li	a0,66
    80000ade:	00000097          	auipc	ra,0x0
    80000ae2:	cb0080e7          	jalr	-848(ra) # 8000078e <uart_putc>
    consputc('B');
}
    80000ae6:	60e2                	ld	ra,24(sp)
    80000ae8:	6442                	ld	s0,16(sp)
    80000aea:	64a2                	ld	s1,8(sp)
    80000aec:	6105                	addi	sp,sp,32
    80000aee:	8082                	ret
    80000af0:	8082                	ret

0000000080000af2 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    if (cols <= 0) return;
    80000af2:	04a05563          	blez	a0,80000b3c <cursor_right+0x4a>
void cursor_right(int cols) {
    80000af6:	1101                	addi	sp,sp,-32
    80000af8:	ec06                	sd	ra,24(sp)
    80000afa:	e822                	sd	s0,16(sp)
    80000afc:	e426                	sd	s1,8(sp)
    80000afe:	1000                	addi	s0,sp,32
    80000b00:	84aa                	mv	s1,a0
	uart_putc(c);
    80000b02:	456d                	li	a0,27
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	c8a080e7          	jalr	-886(ra) # 8000078e <uart_putc>
    80000b0c:	05b00513          	li	a0,91
    80000b10:	00000097          	auipc	ra,0x0
    80000b14:	c7e080e7          	jalr	-898(ra) # 8000078e <uart_putc>
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    80000b18:	4601                	li	a2,0
    80000b1a:	45a9                	li	a1,10
    80000b1c:	8526                	mv	a0,s1
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	cdc080e7          	jalr	-804(ra) # 800007fa <printint>
	uart_putc(c);
    80000b26:	04300513          	li	a0,67
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	c64080e7          	jalr	-924(ra) # 8000078e <uart_putc>
    consputc('C');
}
    80000b32:	60e2                	ld	ra,24(sp)
    80000b34:	6442                	ld	s0,16(sp)
    80000b36:	64a2                	ld	s1,8(sp)
    80000b38:	6105                	addi	sp,sp,32
    80000b3a:	8082                	ret
    80000b3c:	8082                	ret

0000000080000b3e <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    if (cols <= 0) return;
    80000b3e:	04a05563          	blez	a0,80000b88 <cursor_left+0x4a>
void cursor_left(int cols) {
    80000b42:	1101                	addi	sp,sp,-32
    80000b44:	ec06                	sd	ra,24(sp)
    80000b46:	e822                	sd	s0,16(sp)
    80000b48:	e426                	sd	s1,8(sp)
    80000b4a:	1000                	addi	s0,sp,32
    80000b4c:	84aa                	mv	s1,a0
	uart_putc(c);
    80000b4e:	456d                	li	a0,27
    80000b50:	00000097          	auipc	ra,0x0
    80000b54:	c3e080e7          	jalr	-962(ra) # 8000078e <uart_putc>
    80000b58:	05b00513          	li	a0,91
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	c32080e7          	jalr	-974(ra) # 8000078e <uart_putc>
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    80000b64:	4601                	li	a2,0
    80000b66:	45a9                	li	a1,10
    80000b68:	8526                	mv	a0,s1
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	c90080e7          	jalr	-880(ra) # 800007fa <printint>
	uart_putc(c);
    80000b72:	04400513          	li	a0,68
    80000b76:	00000097          	auipc	ra,0x0
    80000b7a:	c18080e7          	jalr	-1000(ra) # 8000078e <uart_putc>
    consputc('D');
}
    80000b7e:	60e2                	ld	ra,24(sp)
    80000b80:	6442                	ld	s0,16(sp)
    80000b82:	64a2                	ld	s1,8(sp)
    80000b84:	6105                	addi	sp,sp,32
    80000b86:	8082                	ret
    80000b88:	8082                	ret

0000000080000b8a <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    80000b8a:	1141                	addi	sp,sp,-16
    80000b8c:	e406                	sd	ra,8(sp)
    80000b8e:	e022                	sd	s0,0(sp)
    80000b90:	0800                	addi	s0,sp,16
	uart_putc(c);
    80000b92:	456d                	li	a0,27
    80000b94:	00000097          	auipc	ra,0x0
    80000b98:	bfa080e7          	jalr	-1030(ra) # 8000078e <uart_putc>
    80000b9c:	05b00513          	li	a0,91
    80000ba0:	00000097          	auipc	ra,0x0
    80000ba4:	bee080e7          	jalr	-1042(ra) # 8000078e <uart_putc>
    80000ba8:	07300513          	li	a0,115
    80000bac:	00000097          	auipc	ra,0x0
    80000bb0:	be2080e7          	jalr	-1054(ra) # 8000078e <uart_putc>
    consputc('\033');
    consputc('[');
    consputc('s');
}
    80000bb4:	60a2                	ld	ra,8(sp)
    80000bb6:	6402                	ld	s0,0(sp)
    80000bb8:	0141                	addi	sp,sp,16
    80000bba:	8082                	ret

0000000080000bbc <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    80000bbc:	1141                	addi	sp,sp,-16
    80000bbe:	e406                	sd	ra,8(sp)
    80000bc0:	e022                	sd	s0,0(sp)
    80000bc2:	0800                	addi	s0,sp,16
	uart_putc(c);
    80000bc4:	456d                	li	a0,27
    80000bc6:	00000097          	auipc	ra,0x0
    80000bca:	bc8080e7          	jalr	-1080(ra) # 8000078e <uart_putc>
    80000bce:	05b00513          	li	a0,91
    80000bd2:	00000097          	auipc	ra,0x0
    80000bd6:	bbc080e7          	jalr	-1092(ra) # 8000078e <uart_putc>
    80000bda:	07500513          	li	a0,117
    80000bde:	00000097          	auipc	ra,0x0
    80000be2:	bb0080e7          	jalr	-1104(ra) # 8000078e <uart_putc>
    consputc('\033');
    consputc('[');
    consputc('u');
}
    80000be6:	60a2                	ld	ra,8(sp)
    80000be8:	6402                	ld	s0,0(sp)
    80000bea:	0141                	addi	sp,sp,16
    80000bec:	8082                	ret

0000000080000bee <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    80000bee:	1101                	addi	sp,sp,-32
    80000bf0:	ec06                	sd	ra,24(sp)
    80000bf2:	e822                	sd	s0,16(sp)
    80000bf4:	e426                	sd	s1,8(sp)
    80000bf6:	1000                	addi	s0,sp,32
    80000bf8:	84aa                	mv	s1,a0
	uart_putc(c);
    80000bfa:	456d                	li	a0,27
    80000bfc:	00000097          	auipc	ra,0x0
    80000c00:	b92080e7          	jalr	-1134(ra) # 8000078e <uart_putc>
    80000c04:	05b00513          	li	a0,91
    80000c08:	00000097          	auipc	ra,0x0
    80000c0c:	b86080e7          	jalr	-1146(ra) # 8000078e <uart_putc>
    if (col <= 0) col = 1;
    80000c10:	8526                	mv	a0,s1
    80000c12:	02905463          	blez	s1,80000c3a <cursor_to_column+0x4c>
    consputc('\033');
    consputc('[');
    printint(col, 10, 0);
    80000c16:	4601                	li	a2,0
    80000c18:	45a9                	li	a1,10
    80000c1a:	2501                	sext.w	a0,a0
    80000c1c:	00000097          	auipc	ra,0x0
    80000c20:	bde080e7          	jalr	-1058(ra) # 800007fa <printint>
	uart_putc(c);
    80000c24:	04700513          	li	a0,71
    80000c28:	00000097          	auipc	ra,0x0
    80000c2c:	b66080e7          	jalr	-1178(ra) # 8000078e <uart_putc>
    consputc('G');
}
    80000c30:	60e2                	ld	ra,24(sp)
    80000c32:	6442                	ld	s0,16(sp)
    80000c34:	64a2                	ld	s1,8(sp)
    80000c36:	6105                	addi	sp,sp,32
    80000c38:	8082                	ret
    if (col <= 0) col = 1;
    80000c3a:	4505                	li	a0,1
    80000c3c:	bfe9                	j	80000c16 <cursor_to_column+0x28>

0000000080000c3e <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80000c3e:	1101                	addi	sp,sp,-32
    80000c40:	ec06                	sd	ra,24(sp)
    80000c42:	e822                	sd	s0,16(sp)
    80000c44:	e426                	sd	s1,8(sp)
    80000c46:	e04a                	sd	s2,0(sp)
    80000c48:	1000                	addi	s0,sp,32
    80000c4a:	892a                	mv	s2,a0
    80000c4c:	84ae                	mv	s1,a1
	uart_putc(c);
    80000c4e:	456d                	li	a0,27
    80000c50:	00000097          	auipc	ra,0x0
    80000c54:	b3e080e7          	jalr	-1218(ra) # 8000078e <uart_putc>
    80000c58:	05b00513          	li	a0,91
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	b32080e7          	jalr	-1230(ra) # 8000078e <uart_putc>
    consputc('\033');
    consputc('[');
    printint(row, 10, 0);
    80000c64:	4601                	li	a2,0
    80000c66:	45a9                	li	a1,10
    80000c68:	854a                	mv	a0,s2
    80000c6a:	00000097          	auipc	ra,0x0
    80000c6e:	b90080e7          	jalr	-1136(ra) # 800007fa <printint>
	uart_putc(c);
    80000c72:	03b00513          	li	a0,59
    80000c76:	00000097          	auipc	ra,0x0
    80000c7a:	b18080e7          	jalr	-1256(ra) # 8000078e <uart_putc>
    consputc(';');
    printint(col, 10, 0);
    80000c7e:	4601                	li	a2,0
    80000c80:	45a9                	li	a1,10
    80000c82:	8526                	mv	a0,s1
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	b76080e7          	jalr	-1162(ra) # 800007fa <printint>
	uart_putc(c);
    80000c8c:	04800513          	li	a0,72
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	afe080e7          	jalr	-1282(ra) # 8000078e <uart_putc>
    consputc('H');
}
    80000c98:	60e2                	ld	ra,24(sp)
    80000c9a:	6442                	ld	s0,16(sp)
    80000c9c:	64a2                	ld	s1,8(sp)
    80000c9e:	6902                	ld	s2,0(sp)
    80000ca0:	6105                	addi	sp,sp,32
    80000ca2:	8082                	ret

0000000080000ca4 <reset_color>:
// 颜色控制
void reset_color(void) {
    80000ca4:	1141                	addi	sp,sp,-16
    80000ca6:	e406                	sd	ra,8(sp)
    80000ca8:	e022                	sd	s0,0(sp)
    80000caa:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    80000cac:	00001517          	auipc	a0,0x1
    80000cb0:	c8c50513          	addi	a0,a0,-884 # 80001938 <clear_line+0xae6>
    80000cb4:	00000097          	auipc	ra,0x0
    80000cb8:	afe080e7          	jalr	-1282(ra) # 800007b2 <uart_puts>
}
    80000cbc:	60a2                	ld	ra,8(sp)
    80000cbe:	6402                	ld	s0,0(sp)
    80000cc0:	0141                	addi	sp,sp,16
    80000cc2:	8082                	ret

0000000080000cc4 <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
	if (color < 30 || color > 37) return; // 支持30-37
    80000cc4:	fe25071b          	addiw	a4,a0,-30
    80000cc8:	479d                	li	a5,7
    80000cca:	00e7f363          	bgeu	a5,a4,80000cd0 <set_fg_color+0xc>
    80000cce:	8082                	ret
void set_fg_color(int color) {
    80000cd0:	1101                	addi	sp,sp,-32
    80000cd2:	ec06                	sd	ra,24(sp)
    80000cd4:	e822                	sd	s0,16(sp)
    80000cd6:	e426                	sd	s1,8(sp)
    80000cd8:	1000                	addi	s0,sp,32
    80000cda:	84aa                	mv	s1,a0
	uart_putc(c);
    80000cdc:	456d                	li	a0,27
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	ab0080e7          	jalr	-1360(ra) # 8000078e <uart_putc>
    80000ce6:	05b00513          	li	a0,91
    80000cea:	00000097          	auipc	ra,0x0
    80000cee:	aa4080e7          	jalr	-1372(ra) # 8000078e <uart_putc>
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
    80000cf2:	4601                	li	a2,0
    80000cf4:	45a9                	li	a1,10
    80000cf6:	8526                	mv	a0,s1
    80000cf8:	00000097          	auipc	ra,0x0
    80000cfc:	b02080e7          	jalr	-1278(ra) # 800007fa <printint>
	uart_putc(c);
    80000d00:	06d00513          	li	a0,109
    80000d04:	00000097          	auipc	ra,0x0
    80000d08:	a8a080e7          	jalr	-1398(ra) # 8000078e <uart_putc>
	consputc('m');
}
    80000d0c:	60e2                	ld	ra,24(sp)
    80000d0e:	6442                	ld	s0,16(sp)
    80000d10:	64a2                	ld	s1,8(sp)
    80000d12:	6105                	addi	sp,sp,32
    80000d14:	8082                	ret

0000000080000d16 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
	if (color < 40 || color > 47) return; // 支持40-47
    80000d16:	fd85071b          	addiw	a4,a0,-40
    80000d1a:	479d                	li	a5,7
    80000d1c:	00e7f363          	bgeu	a5,a4,80000d22 <set_bg_color+0xc>
    80000d20:	8082                	ret
void set_bg_color(int color) {
    80000d22:	1101                	addi	sp,sp,-32
    80000d24:	ec06                	sd	ra,24(sp)
    80000d26:	e822                	sd	s0,16(sp)
    80000d28:	e426                	sd	s1,8(sp)
    80000d2a:	1000                	addi	s0,sp,32
    80000d2c:	84aa                	mv	s1,a0
	uart_putc(c);
    80000d2e:	456d                	li	a0,27
    80000d30:	00000097          	auipc	ra,0x0
    80000d34:	a5e080e7          	jalr	-1442(ra) # 8000078e <uart_putc>
    80000d38:	05b00513          	li	a0,91
    80000d3c:	00000097          	auipc	ra,0x0
    80000d40:	a52080e7          	jalr	-1454(ra) # 8000078e <uart_putc>
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
    80000d44:	4601                	li	a2,0
    80000d46:	45a9                	li	a1,10
    80000d48:	8526                	mv	a0,s1
    80000d4a:	00000097          	auipc	ra,0x0
    80000d4e:	ab0080e7          	jalr	-1360(ra) # 800007fa <printint>
	uart_putc(c);
    80000d52:	06d00513          	li	a0,109
    80000d56:	00000097          	auipc	ra,0x0
    80000d5a:	a38080e7          	jalr	-1480(ra) # 8000078e <uart_putc>
	consputc('m');
}
    80000d5e:	60e2                	ld	ra,24(sp)
    80000d60:	6442                	ld	s0,16(sp)
    80000d62:	64a2                	ld	s1,8(sp)
    80000d64:	6105                	addi	sp,sp,32
    80000d66:	8082                	ret

0000000080000d68 <color_red>:
// 简易文字颜色
void color_red(void) {
    80000d68:	1141                	addi	sp,sp,-16
    80000d6a:	e406                	sd	ra,8(sp)
    80000d6c:	e022                	sd	s0,0(sp)
    80000d6e:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    80000d70:	457d                	li	a0,31
    80000d72:	00000097          	auipc	ra,0x0
    80000d76:	f52080e7          	jalr	-174(ra) # 80000cc4 <set_fg_color>
}
    80000d7a:	60a2                	ld	ra,8(sp)
    80000d7c:	6402                	ld	s0,0(sp)
    80000d7e:	0141                	addi	sp,sp,16
    80000d80:	8082                	ret

0000000080000d82 <color_green>:
void color_green(void) {
    80000d82:	1141                	addi	sp,sp,-16
    80000d84:	e406                	sd	ra,8(sp)
    80000d86:	e022                	sd	s0,0(sp)
    80000d88:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    80000d8a:	02000513          	li	a0,32
    80000d8e:	00000097          	auipc	ra,0x0
    80000d92:	f36080e7          	jalr	-202(ra) # 80000cc4 <set_fg_color>
}
    80000d96:	60a2                	ld	ra,8(sp)
    80000d98:	6402                	ld	s0,0(sp)
    80000d9a:	0141                	addi	sp,sp,16
    80000d9c:	8082                	ret

0000000080000d9e <color_yellow>:
void color_yellow(void) {
    80000d9e:	1141                	addi	sp,sp,-16
    80000da0:	e406                	sd	ra,8(sp)
    80000da2:	e022                	sd	s0,0(sp)
    80000da4:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    80000da6:	02100513          	li	a0,33
    80000daa:	00000097          	auipc	ra,0x0
    80000dae:	f1a080e7          	jalr	-230(ra) # 80000cc4 <set_fg_color>
}
    80000db2:	60a2                	ld	ra,8(sp)
    80000db4:	6402                	ld	s0,0(sp)
    80000db6:	0141                	addi	sp,sp,16
    80000db8:	8082                	ret

0000000080000dba <color_blue>:
void color_blue(void) {
    80000dba:	1141                	addi	sp,sp,-16
    80000dbc:	e406                	sd	ra,8(sp)
    80000dbe:	e022                	sd	s0,0(sp)
    80000dc0:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    80000dc2:	02200513          	li	a0,34
    80000dc6:	00000097          	auipc	ra,0x0
    80000dca:	efe080e7          	jalr	-258(ra) # 80000cc4 <set_fg_color>
}
    80000dce:	60a2                	ld	ra,8(sp)
    80000dd0:	6402                	ld	s0,0(sp)
    80000dd2:	0141                	addi	sp,sp,16
    80000dd4:	8082                	ret

0000000080000dd6 <color_purple>:
void color_purple(void) {
    80000dd6:	1141                	addi	sp,sp,-16
    80000dd8:	e406                	sd	ra,8(sp)
    80000dda:	e022                	sd	s0,0(sp)
    80000ddc:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80000dde:	02300513          	li	a0,35
    80000de2:	00000097          	auipc	ra,0x0
    80000de6:	ee2080e7          	jalr	-286(ra) # 80000cc4 <set_fg_color>
}
    80000dea:	60a2                	ld	ra,8(sp)
    80000dec:	6402                	ld	s0,0(sp)
    80000dee:	0141                	addi	sp,sp,16
    80000df0:	8082                	ret

0000000080000df2 <color_cyan>:
void color_cyan(void) {
    80000df2:	1141                	addi	sp,sp,-16
    80000df4:	e406                	sd	ra,8(sp)
    80000df6:	e022                	sd	s0,0(sp)
    80000df8:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    80000dfa:	02400513          	li	a0,36
    80000dfe:	00000097          	auipc	ra,0x0
    80000e02:	ec6080e7          	jalr	-314(ra) # 80000cc4 <set_fg_color>
}
    80000e06:	60a2                	ld	ra,8(sp)
    80000e08:	6402                	ld	s0,0(sp)
    80000e0a:	0141                	addi	sp,sp,16
    80000e0c:	8082                	ret

0000000080000e0e <color_white>:
void color_white(void){
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e406                	sd	ra,8(sp)
    80000e12:	e022                	sd	s0,0(sp)
    80000e14:	0800                	addi	s0,sp,16
	set_fg_color(37); // 白色
    80000e16:	02500513          	li	a0,37
    80000e1a:	00000097          	auipc	ra,0x0
    80000e1e:	eaa080e7          	jalr	-342(ra) # 80000cc4 <set_fg_color>
}
    80000e22:	60a2                	ld	ra,8(sp)
    80000e24:	6402                	ld	s0,0(sp)
    80000e26:	0141                	addi	sp,sp,16
    80000e28:	8082                	ret

0000000080000e2a <set_color>:
void set_color(int fg, int bg) {
    80000e2a:	1101                	addi	sp,sp,-32
    80000e2c:	ec06                	sd	ra,24(sp)
    80000e2e:	e822                	sd	s0,16(sp)
    80000e30:	e426                	sd	s1,8(sp)
    80000e32:	1000                	addi	s0,sp,32
    80000e34:	84ae                	mv	s1,a1
	set_fg_color(fg);
    80000e36:	00000097          	auipc	ra,0x0
    80000e3a:	e8e080e7          	jalr	-370(ra) # 80000cc4 <set_fg_color>
	set_bg_color(bg);
    80000e3e:	8526                	mv	a0,s1
    80000e40:	00000097          	auipc	ra,0x0
    80000e44:	ed6080e7          	jalr	-298(ra) # 80000d16 <set_bg_color>
}
    80000e48:	60e2                	ld	ra,24(sp)
    80000e4a:	6442                	ld	s0,16(sp)
    80000e4c:	64a2                	ld	s1,8(sp)
    80000e4e:	6105                	addi	sp,sp,32
    80000e50:	8082                	ret

0000000080000e52 <clear_line>:
void clear_line(){
    80000e52:	1141                	addi	sp,sp,-16
    80000e54:	e406                	sd	ra,8(sp)
    80000e56:	e022                	sd	s0,0(sp)
    80000e58:	0800                	addi	s0,sp,16
	uart_putc(c);
    80000e5a:	456d                	li	a0,27
    80000e5c:	00000097          	auipc	ra,0x0
    80000e60:	932080e7          	jalr	-1742(ra) # 8000078e <uart_putc>
    80000e64:	05b00513          	li	a0,91
    80000e68:	00000097          	auipc	ra,0x0
    80000e6c:	926080e7          	jalr	-1754(ra) # 8000078e <uart_putc>
    80000e70:	03200513          	li	a0,50
    80000e74:	00000097          	auipc	ra,0x0
    80000e78:	91a080e7          	jalr	-1766(ra) # 8000078e <uart_putc>
    80000e7c:	04b00513          	li	a0,75
    80000e80:	00000097          	auipc	ra,0x0
    80000e84:	90e080e7          	jalr	-1778(ra) # 8000078e <uart_putc>
	consputc('\033');
	consputc('[');
	consputc('2');
	consputc('K');
    80000e88:	60a2                	ld	ra,8(sp)
    80000e8a:	6402                	ld	s0,0(sp)
    80000e8c:	0141                	addi	sp,sp,16
    80000e8e:	8082                	ret
	...
