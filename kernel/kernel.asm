
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
    8000002c:	680080e7          	jalr	1664(ra) # 800006a8 <start>

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
    8000003e:	b5c080e7          	jalr	-1188(ra) # 80000b96 <clear_screen>
    printf("=== 详细的Printf测试 ===\n");
    80000042:	00001517          	auipc	a0,0x1
    80000046:	fbe50513          	addi	a0,a0,-66 # 80001000 <clear_line+0x40>
    8000004a:	00001097          	auipc	ra,0x1
    8000004e:	92a080e7          	jalr	-1750(ra) # 80000974 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    80000052:	00001517          	auipc	a0,0x1
    80000056:	fce50513          	addi	a0,a0,-50 # 80001020 <clear_line+0x60>
    8000005a:	00001097          	auipc	ra,0x1
    8000005e:	91a080e7          	jalr	-1766(ra) # 80000974 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    80000062:	0ff00593          	li	a1,255
    80000066:	00001517          	auipc	a0,0x1
    8000006a:	fd250513          	addi	a0,a0,-46 # 80001038 <clear_line+0x78>
    8000006e:	00001097          	auipc	ra,0x1
    80000072:	906080e7          	jalr	-1786(ra) # 80000974 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    80000076:	6585                	lui	a1,0x1
    80000078:	00001517          	auipc	a0,0x1
    8000007c:	fe050513          	addi	a0,a0,-32 # 80001058 <clear_line+0x98>
    80000080:	00001097          	auipc	ra,0x1
    80000084:	8f4080e7          	jalr	-1804(ra) # 80000974 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    80000088:	1234b5b7          	lui	a1,0x1234b
    8000008c:	bcd58593          	addi	a1,a1,-1075 # 1234abcd <_entry-0x6dcb5433>
    80000090:	00001517          	auipc	a0,0x1
    80000094:	fe850513          	addi	a0,a0,-24 # 80001078 <clear_line+0xb8>
    80000098:	00001097          	auipc	ra,0x1
    8000009c:	8dc080e7          	jalr	-1828(ra) # 80000974 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    800000a0:	00001517          	auipc	a0,0x1
    800000a4:	ff050513          	addi	a0,a0,-16 # 80001090 <clear_line+0xd0>
    800000a8:	00001097          	auipc	ra,0x1
    800000ac:	8cc080e7          	jalr	-1844(ra) # 80000974 <printf>
    printf("  正数: %d\n", 42);
    800000b0:	02a00593          	li	a1,42
    800000b4:	00001517          	auipc	a0,0x1
    800000b8:	ff450513          	addi	a0,a0,-12 # 800010a8 <clear_line+0xe8>
    800000bc:	00001097          	auipc	ra,0x1
    800000c0:	8b8080e7          	jalr	-1864(ra) # 80000974 <printf>
    printf("  负数: %d\n", -42);
    800000c4:	fd600593          	li	a1,-42
    800000c8:	00001517          	auipc	a0,0x1
    800000cc:	ff050513          	addi	a0,a0,-16 # 800010b8 <clear_line+0xf8>
    800000d0:	00001097          	auipc	ra,0x1
    800000d4:	8a4080e7          	jalr	-1884(ra) # 80000974 <printf>
    printf("  零: %d\n", 0);
    800000d8:	4581                	li	a1,0
    800000da:	00001517          	auipc	a0,0x1
    800000de:	fee50513          	addi	a0,a0,-18 # 800010c8 <clear_line+0x108>
    800000e2:	00001097          	auipc	ra,0x1
    800000e6:	892080e7          	jalr	-1902(ra) # 80000974 <printf>
    printf("  大数: %d\n", 123456789);
    800000ea:	075bd5b7          	lui	a1,0x75bd
    800000ee:	d1558593          	addi	a1,a1,-747 # 75bcd15 <_entry-0x78a432eb>
    800000f2:	00001517          	auipc	a0,0x1
    800000f6:	fe650513          	addi	a0,a0,-26 # 800010d8 <clear_line+0x118>
    800000fa:	00001097          	auipc	ra,0x1
    800000fe:	87a080e7          	jalr	-1926(ra) # 80000974 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80000102:	00001517          	auipc	a0,0x1
    80000106:	fe650513          	addi	a0,a0,-26 # 800010e8 <clear_line+0x128>
    8000010a:	00001097          	auipc	ra,0x1
    8000010e:	86a080e7          	jalr	-1942(ra) # 80000974 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80000112:	55fd                	li	a1,-1
    80000114:	00001517          	auipc	a0,0x1
    80000118:	fec50513          	addi	a0,a0,-20 # 80001100 <clear_line+0x140>
    8000011c:	00001097          	auipc	ra,0x1
    80000120:	858080e7          	jalr	-1960(ra) # 80000974 <printf>
    printf("  零：%u\n", 0U);
    80000124:	4581                	li	a1,0
    80000126:	00001517          	auipc	a0,0x1
    8000012a:	ff250513          	addi	a0,a0,-14 # 80001118 <clear_line+0x158>
    8000012e:	00001097          	auipc	ra,0x1
    80000132:	846080e7          	jalr	-1978(ra) # 80000974 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80000136:	658d                	lui	a1,0x3
    80000138:	03958593          	addi	a1,a1,57 # 3039 <_entry-0x7fffcfc7>
    8000013c:	00001517          	auipc	a0,0x1
    80000140:	fec50513          	addi	a0,a0,-20 # 80001128 <clear_line+0x168>
    80000144:	00001097          	auipc	ra,0x1
    80000148:	830080e7          	jalr	-2000(ra) # 80000974 <printf>

	// 测试边界
	printf("边界测试:\n");
    8000014c:	00001517          	auipc	a0,0x1
    80000150:	ff450513          	addi	a0,a0,-12 # 80001140 <clear_line+0x180>
    80000154:	00001097          	auipc	ra,0x1
    80000158:	820080e7          	jalr	-2016(ra) # 80000974 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    8000015c:	800005b7          	lui	a1,0x80000
    80000160:	fff5c593          	not	a1,a1
    80000164:	00001517          	auipc	a0,0x1
    80000168:	fec50513          	addi	a0,a0,-20 # 80001150 <clear_line+0x190>
    8000016c:	00001097          	auipc	ra,0x1
    80000170:	808080e7          	jalr	-2040(ra) # 80000974 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    80000174:	800005b7          	lui	a1,0x80000
    80000178:	00001517          	auipc	a0,0x1
    8000017c:	fe850513          	addi	a0,a0,-24 # 80001160 <clear_line+0x1a0>
    80000180:	00000097          	auipc	ra,0x0
    80000184:	7f4080e7          	jalr	2036(ra) # 80000974 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    80000188:	55fd                	li	a1,-1
    8000018a:	00001517          	auipc	a0,0x1
    8000018e:	fe650513          	addi	a0,a0,-26 # 80001170 <clear_line+0x1b0>
    80000192:	00000097          	auipc	ra,0x0
    80000196:	7e2080e7          	jalr	2018(ra) # 80000974 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    8000019a:	55fd                	li	a1,-1
    8000019c:	00001517          	auipc	a0,0x1
    800001a0:	fe450513          	addi	a0,a0,-28 # 80001180 <clear_line+0x1c0>
    800001a4:	00000097          	auipc	ra,0x0
    800001a8:	7d0080e7          	jalr	2000(ra) # 80000974 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    800001ac:	00001517          	auipc	a0,0x1
    800001b0:	fec50513          	addi	a0,a0,-20 # 80001198 <clear_line+0x1d8>
    800001b4:	00000097          	auipc	ra,0x0
    800001b8:	7c0080e7          	jalr	1984(ra) # 80000974 <printf>
    printf("  空字符串: '%s'\n", "");
    800001bc:	00001597          	auipc	a1,0x1
    800001c0:	23c58593          	addi	a1,a1,572 # 800013f8 <clear_line+0x438>
    800001c4:	00001517          	auipc	a0,0x1
    800001c8:	fec50513          	addi	a0,a0,-20 # 800011b0 <clear_line+0x1f0>
    800001cc:	00000097          	auipc	ra,0x0
    800001d0:	7a8080e7          	jalr	1960(ra) # 80000974 <printf>
    printf("  单字符: '%s'\n", "X");
    800001d4:	00001597          	auipc	a1,0x1
    800001d8:	ff458593          	addi	a1,a1,-12 # 800011c8 <clear_line+0x208>
    800001dc:	00001517          	auipc	a0,0x1
    800001e0:	ff450513          	addi	a0,a0,-12 # 800011d0 <clear_line+0x210>
    800001e4:	00000097          	auipc	ra,0x0
    800001e8:	790080e7          	jalr	1936(ra) # 80000974 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    800001ec:	00001597          	auipc	a1,0x1
    800001f0:	ffc58593          	addi	a1,a1,-4 # 800011e8 <clear_line+0x228>
    800001f4:	00001517          	auipc	a0,0x1
    800001f8:	01450513          	addi	a0,a0,20 # 80001208 <clear_line+0x248>
    800001fc:	00000097          	auipc	ra,0x0
    80000200:	778080e7          	jalr	1912(ra) # 80000974 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80000204:	00001597          	auipc	a1,0x1
    80000208:	01c58593          	addi	a1,a1,28 # 80001220 <clear_line+0x260>
    8000020c:	00001517          	auipc	a0,0x1
    80000210:	16450513          	addi	a0,a0,356 # 80001370 <clear_line+0x3b0>
    80000214:	00000097          	auipc	ra,0x0
    80000218:	760080e7          	jalr	1888(ra) # 80000974 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    8000021c:	00001517          	auipc	a0,0x1
    80000220:	17450513          	addi	a0,a0,372 # 80001390 <clear_line+0x3d0>
    80000224:	00000097          	auipc	ra,0x0
    80000228:	750080e7          	jalr	1872(ra) # 80000974 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    8000022c:	0ff00693          	li	a3,255
    80000230:	f0100613          	li	a2,-255
    80000234:	0ff00593          	li	a1,255
    80000238:	00001517          	auipc	a0,0x1
    8000023c:	17050513          	addi	a0,a0,368 # 800013a8 <clear_line+0x3e8>
    80000240:	00000097          	auipc	ra,0x0
    80000244:	734080e7          	jalr	1844(ra) # 80000974 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80000248:	00001517          	auipc	a0,0x1
    8000024c:	18850513          	addi	a0,a0,392 # 800013d0 <clear_line+0x410>
    80000250:	00000097          	auipc	ra,0x0
    80000254:	724080e7          	jalr	1828(ra) # 80000974 <printf>
	printf("  100%% 完成!\n");
    80000258:	00001517          	auipc	a0,0x1
    8000025c:	19050513          	addi	a0,a0,400 # 800013e8 <clear_line+0x428>
    80000260:	00000097          	auipc	ra,0x0
    80000264:	714080e7          	jalr	1812(ra) # 80000974 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
	printf("NULL字符串测试:\n");
    80000268:	00001517          	auipc	a0,0x1
    8000026c:	19850513          	addi	a0,a0,408 # 80001400 <clear_line+0x440>
    80000270:	00000097          	auipc	ra,0x0
    80000274:	704080e7          	jalr	1796(ra) # 80000974 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    80000278:	4581                	li	a1,0
    8000027a:	00001517          	auipc	a0,0x1
    8000027e:	19e50513          	addi	a0,a0,414 # 80001418 <clear_line+0x458>
    80000282:	00000097          	auipc	ra,0x0
    80000286:	6f2080e7          	jalr	1778(ra) # 80000974 <printf>
	
	// 测试指针格式
	int var = 42;
    8000028a:	02a00793          	li	a5,42
    8000028e:	fef42623          	sw	a5,-20(s0)
	printf("指针测试:\n");
    80000292:	00001517          	auipc	a0,0x1
    80000296:	19e50513          	addi	a0,a0,414 # 80001430 <clear_line+0x470>
    8000029a:	00000097          	auipc	ra,0x0
    8000029e:	6da080e7          	jalr	1754(ra) # 80000974 <printf>
	printf("  Address of var: %p\n", &var);
    800002a2:	fec40593          	addi	a1,s0,-20
    800002a6:	00001517          	auipc	a0,0x1
    800002aa:	19a50513          	addi	a0,a0,410 # 80001440 <clear_line+0x480>
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	6c6080e7          	jalr	1734(ra) # 80000974 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    800002b6:	00001517          	auipc	a0,0x1
    800002ba:	1a250513          	addi	a0,a0,418 # 80001458 <clear_line+0x498>
    800002be:	00000097          	auipc	ra,0x0
    800002c2:	6b6080e7          	jalr	1718(ra) # 80000974 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    800002c6:	55fd                	li	a1,-1
    800002c8:	00001517          	auipc	a0,0x1
    800002cc:	1b050513          	addi	a0,a0,432 # 80001478 <clear_line+0x4b8>
    800002d0:	00000097          	auipc	ra,0x0
    800002d4:	6a4080e7          	jalr	1700(ra) # 80000974 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    800002d8:	00001517          	auipc	a0,0x1
    800002dc:	1b850513          	addi	a0,a0,440 # 80001490 <clear_line+0x4d0>
    800002e0:	00000097          	auipc	ra,0x0
    800002e4:	694080e7          	jalr	1684(ra) # 80000974 <printf>
	printf("  Binary of 5: %b\n", 5);
    800002e8:	4595                	li	a1,5
    800002ea:	00001517          	auipc	a0,0x1
    800002ee:	1be50513          	addi	a0,a0,446 # 800014a8 <clear_line+0x4e8>
    800002f2:	00000097          	auipc	ra,0x0
    800002f6:	682080e7          	jalr	1666(ra) # 80000974 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    800002fa:	45a1                	li	a1,8
    800002fc:	00001517          	auipc	a0,0x1
    80000300:	1c450513          	addi	a0,a0,452 # 800014c0 <clear_line+0x500>
    80000304:	00000097          	auipc	ra,0x0
    80000308:	670080e7          	jalr	1648(ra) # 80000974 <printf>
	printf("=== Printf测试结束 ===\n");
    8000030c:	00001517          	auipc	a0,0x1
    80000310:	1cc50513          	addi	a0,a0,460 # 800014d8 <clear_line+0x518>
    80000314:	00000097          	auipc	ra,0x0
    80000318:	660080e7          	jalr	1632(ra) # 80000974 <printf>
}
    8000031c:	60e2                	ld	ra,24(sp)
    8000031e:	6442                	ld	s0,16(sp)
    80000320:	6105                	addi	sp,sp,32
    80000322:	8082                	ret

0000000080000324 <test_curse_move>:
void test_curse_move(){
    80000324:	7139                	addi	sp,sp,-64
    80000326:	fc06                	sd	ra,56(sp)
    80000328:	f822                	sd	s0,48(sp)
    8000032a:	f426                	sd	s1,40(sp)
    8000032c:	f04a                	sd	s2,32(sp)
    8000032e:	ec4e                	sd	s3,24(sp)
    80000330:	e852                	sd	s4,16(sp)
    80000332:	e456                	sd	s5,8(sp)
    80000334:	e05a                	sd	s6,0(sp)
    80000336:	0080                	addi	s0,sp,64
	clear_screen(); // 清屏
    80000338:	00001097          	auipc	ra,0x1
    8000033c:	85e080e7          	jalr	-1954(ra) # 80000b96 <clear_screen>
	printf("=== 光标移动测试 ===\n");
    80000340:	00001517          	auipc	a0,0x1
    80000344:	1b850513          	addi	a0,a0,440 # 800014f8 <clear_line+0x538>
    80000348:	00000097          	auipc	ra,0x0
    8000034c:	62c080e7          	jalr	1580(ra) # 80000974 <printf>
	for (int i = 3; i <= 7; i++) {
    80000350:	490d                	li	s2,3
		for (int j = 1; j <= 10; j++) {
    80000352:	4b05                	li	s6,1
			goto_rc(i, j);
			printf("*");
    80000354:	00001a17          	auipc	s4,0x1
    80000358:	1c4a0a13          	addi	s4,s4,452 # 80001518 <clear_line+0x558>
		for (int j = 1; j <= 10; j++) {
    8000035c:	49ad                	li	s3,11
	for (int i = 3; i <= 7; i++) {
    8000035e:	4aa1                	li	s5,8
		for (int j = 1; j <= 10; j++) {
    80000360:	84da                	mv	s1,s6
			goto_rc(i, j);
    80000362:	85a6                	mv	a1,s1
    80000364:	854a                	mv	a0,s2
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	a44080e7          	jalr	-1468(ra) # 80000daa <goto_rc>
			printf("*");
    8000036e:	8552                	mv	a0,s4
    80000370:	00000097          	auipc	ra,0x0
    80000374:	604080e7          	jalr	1540(ra) # 80000974 <printf>
		for (int j = 1; j <= 10; j++) {
    80000378:	2485                	addiw	s1,s1,1
    8000037a:	ff3494e3          	bne	s1,s3,80000362 <test_curse_move+0x3e>
	for (int i = 3; i <= 7; i++) {
    8000037e:	2905                	addiw	s2,s2,1
    80000380:	ff5910e3          	bne	s2,s5,80000360 <test_curse_move+0x3c>
		}
	}
	goto_rc(9, 1);
    80000384:	4585                	li	a1,1
    80000386:	4525                	li	a0,9
    80000388:	00001097          	auipc	ra,0x1
    8000038c:	a22080e7          	jalr	-1502(ra) # 80000daa <goto_rc>
	save_cursor();
    80000390:	00001097          	auipc	ra,0x1
    80000394:	966080e7          	jalr	-1690(ra) # 80000cf6 <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80000398:	4515                	li	a0,5
    8000039a:	00001097          	auipc	ra,0x1
    8000039e:	82c080e7          	jalr	-2004(ra) # 80000bc6 <cursor_up>
	cursor_right(2);
    800003a2:	4509                	li	a0,2
    800003a4:	00001097          	auipc	ra,0x1
    800003a8:	8ba080e7          	jalr	-1862(ra) # 80000c5e <cursor_right>
	printf("+++++");
    800003ac:	00001517          	auipc	a0,0x1
    800003b0:	17450513          	addi	a0,a0,372 # 80001520 <clear_line+0x560>
    800003b4:	00000097          	auipc	ra,0x0
    800003b8:	5c0080e7          	jalr	1472(ra) # 80000974 <printf>
	cursor_down(2);
    800003bc:	4509                	li	a0,2
    800003be:	00001097          	auipc	ra,0x1
    800003c2:	854080e7          	jalr	-1964(ra) # 80000c12 <cursor_down>
	cursor_left(5);
    800003c6:	4515                	li	a0,5
    800003c8:	00001097          	auipc	ra,0x1
    800003cc:	8e2080e7          	jalr	-1822(ra) # 80000caa <cursor_left>
	printf("-----");
    800003d0:	00001517          	auipc	a0,0x1
    800003d4:	15850513          	addi	a0,a0,344 # 80001528 <clear_line+0x568>
    800003d8:	00000097          	auipc	ra,0x0
    800003dc:	59c080e7          	jalr	1436(ra) # 80000974 <printf>
	restore_cursor();
    800003e0:	00001097          	auipc	ra,0x1
    800003e4:	948080e7          	jalr	-1720(ra) # 80000d28 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    800003e8:	00001517          	auipc	a0,0x1
    800003ec:	14850513          	addi	a0,a0,328 # 80001530 <clear_line+0x570>
    800003f0:	00000097          	auipc	ra,0x0
    800003f4:	584080e7          	jalr	1412(ra) # 80000974 <printf>
}
    800003f8:	70e2                	ld	ra,56(sp)
    800003fa:	7442                	ld	s0,48(sp)
    800003fc:	74a2                	ld	s1,40(sp)
    800003fe:	7902                	ld	s2,32(sp)
    80000400:	69e2                	ld	s3,24(sp)
    80000402:	6a42                	ld	s4,16(sp)
    80000404:	6aa2                	ld	s5,8(sp)
    80000406:	6b02                	ld	s6,0(sp)
    80000408:	6121                	addi	sp,sp,64
    8000040a:	8082                	ret

000000008000040c <test_basic_colors>:
void test_basic_colors(void) {
    8000040c:	1141                	addi	sp,sp,-16
    8000040e:	e406                	sd	ra,8(sp)
    80000410:	e022                	sd	s0,0(sp)
    80000412:	0800                	addi	s0,sp,16
    clear_screen();
    80000414:	00000097          	auipc	ra,0x0
    80000418:	782080e7          	jalr	1922(ra) # 80000b96 <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    8000041c:	00001517          	auipc	a0,0x1
    80000420:	13c50513          	addi	a0,a0,316 # 80001558 <clear_line+0x598>
    80000424:	00000097          	auipc	ra,0x0
    80000428:	550080e7          	jalr	1360(ra) # 80000974 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    8000042c:	00001517          	auipc	a0,0x1
    80000430:	14c50513          	addi	a0,a0,332 # 80001578 <clear_line+0x5b8>
    80000434:	00000097          	auipc	ra,0x0
    80000438:	540080e7          	jalr	1344(ra) # 80000974 <printf>
    color_red();    printf("红色文字 ");
    8000043c:	00001097          	auipc	ra,0x1
    80000440:	a98080e7          	jalr	-1384(ra) # 80000ed4 <color_red>
    80000444:	00001517          	auipc	a0,0x1
    80000448:	14c50513          	addi	a0,a0,332 # 80001590 <clear_line+0x5d0>
    8000044c:	00000097          	auipc	ra,0x0
    80000450:	528080e7          	jalr	1320(ra) # 80000974 <printf>
    color_green();  printf("绿色文字 ");
    80000454:	00001097          	auipc	ra,0x1
    80000458:	a9a080e7          	jalr	-1382(ra) # 80000eee <color_green>
    8000045c:	00001517          	auipc	a0,0x1
    80000460:	14450513          	addi	a0,a0,324 # 800015a0 <clear_line+0x5e0>
    80000464:	00000097          	auipc	ra,0x0
    80000468:	510080e7          	jalr	1296(ra) # 80000974 <printf>
    color_yellow(); printf("黄色文字 ");
    8000046c:	00001097          	auipc	ra,0x1
    80000470:	a9e080e7          	jalr	-1378(ra) # 80000f0a <color_yellow>
    80000474:	00001517          	auipc	a0,0x1
    80000478:	13c50513          	addi	a0,a0,316 # 800015b0 <clear_line+0x5f0>
    8000047c:	00000097          	auipc	ra,0x0
    80000480:	4f8080e7          	jalr	1272(ra) # 80000974 <printf>
    color_blue();   printf("蓝色文字 ");
    80000484:	00001097          	auipc	ra,0x1
    80000488:	aa2080e7          	jalr	-1374(ra) # 80000f26 <color_blue>
    8000048c:	00001517          	auipc	a0,0x1
    80000490:	13450513          	addi	a0,a0,308 # 800015c0 <clear_line+0x600>
    80000494:	00000097          	auipc	ra,0x0
    80000498:	4e0080e7          	jalr	1248(ra) # 80000974 <printf>
    color_purple(); printf("紫色文字 ");
    8000049c:	00001097          	auipc	ra,0x1
    800004a0:	aa6080e7          	jalr	-1370(ra) # 80000f42 <color_purple>
    800004a4:	00001517          	auipc	a0,0x1
    800004a8:	12c50513          	addi	a0,a0,300 # 800015d0 <clear_line+0x610>
    800004ac:	00000097          	auipc	ra,0x0
    800004b0:	4c8080e7          	jalr	1224(ra) # 80000974 <printf>
    color_cyan();   printf("青色文字 ");
    800004b4:	00001097          	auipc	ra,0x1
    800004b8:	aaa080e7          	jalr	-1366(ra) # 80000f5e <color_cyan>
    800004bc:	00001517          	auipc	a0,0x1
    800004c0:	12450513          	addi	a0,a0,292 # 800015e0 <clear_line+0x620>
    800004c4:	00000097          	auipc	ra,0x0
    800004c8:	4b0080e7          	jalr	1200(ra) # 80000974 <printf>
    color_reverse();  printf("反色文字");
    800004cc:	00001097          	auipc	ra,0x1
    800004d0:	aae080e7          	jalr	-1362(ra) # 80000f7a <color_reverse>
    800004d4:	00001517          	auipc	a0,0x1
    800004d8:	11c50513          	addi	a0,a0,284 # 800015f0 <clear_line+0x630>
    800004dc:	00000097          	auipc	ra,0x0
    800004e0:	498080e7          	jalr	1176(ra) # 80000974 <printf>
    reset_color();
    800004e4:	00001097          	auipc	ra,0x1
    800004e8:	92c080e7          	jalr	-1748(ra) # 80000e10 <reset_color>
    printf("\n\n");
    800004ec:	00001517          	auipc	a0,0x1
    800004f0:	11450513          	addi	a0,a0,276 # 80001600 <clear_line+0x640>
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	480080e7          	jalr	1152(ra) # 80000974 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    800004fc:	00001517          	auipc	a0,0x1
    80000500:	10c50513          	addi	a0,a0,268 # 80001608 <clear_line+0x648>
    80000504:	00000097          	auipc	ra,0x0
    80000508:	470080e7          	jalr	1136(ra) # 80000974 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    8000050c:	02900513          	li	a0,41
    80000510:	00001097          	auipc	ra,0x1
    80000514:	972080e7          	jalr	-1678(ra) # 80000e82 <set_bg_color>
    80000518:	00001517          	auipc	a0,0x1
    8000051c:	10850513          	addi	a0,a0,264 # 80001620 <clear_line+0x660>
    80000520:	00000097          	auipc	ra,0x0
    80000524:	454080e7          	jalr	1108(ra) # 80000974 <printf>
    80000528:	00001097          	auipc	ra,0x1
    8000052c:	8e8080e7          	jalr	-1816(ra) # 80000e10 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80000530:	02a00513          	li	a0,42
    80000534:	00001097          	auipc	ra,0x1
    80000538:	94e080e7          	jalr	-1714(ra) # 80000e82 <set_bg_color>
    8000053c:	00001517          	auipc	a0,0x1
    80000540:	0f450513          	addi	a0,a0,244 # 80001630 <clear_line+0x670>
    80000544:	00000097          	auipc	ra,0x0
    80000548:	430080e7          	jalr	1072(ra) # 80000974 <printf>
    8000054c:	00001097          	auipc	ra,0x1
    80000550:	8c4080e7          	jalr	-1852(ra) # 80000e10 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80000554:	02b00513          	li	a0,43
    80000558:	00001097          	auipc	ra,0x1
    8000055c:	92a080e7          	jalr	-1750(ra) # 80000e82 <set_bg_color>
    80000560:	00001517          	auipc	a0,0x1
    80000564:	0e050513          	addi	a0,a0,224 # 80001640 <clear_line+0x680>
    80000568:	00000097          	auipc	ra,0x0
    8000056c:	40c080e7          	jalr	1036(ra) # 80000974 <printf>
    80000570:	00001097          	auipc	ra,0x1
    80000574:	8a0080e7          	jalr	-1888(ra) # 80000e10 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80000578:	02c00513          	li	a0,44
    8000057c:	00001097          	auipc	ra,0x1
    80000580:	906080e7          	jalr	-1786(ra) # 80000e82 <set_bg_color>
    80000584:	00001517          	auipc	a0,0x1
    80000588:	0cc50513          	addi	a0,a0,204 # 80001650 <clear_line+0x690>
    8000058c:	00000097          	auipc	ra,0x0
    80000590:	3e8080e7          	jalr	1000(ra) # 80000974 <printf>
    80000594:	00001097          	auipc	ra,0x1
    80000598:	87c080e7          	jalr	-1924(ra) # 80000e10 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    8000059c:	02f00513          	li	a0,47
    800005a0:	00001097          	auipc	ra,0x1
    800005a4:	8e2080e7          	jalr	-1822(ra) # 80000e82 <set_bg_color>
    800005a8:	00001517          	auipc	a0,0x1
    800005ac:	0b850513          	addi	a0,a0,184 # 80001660 <clear_line+0x6a0>
    800005b0:	00000097          	auipc	ra,0x0
    800005b4:	3c4080e7          	jalr	964(ra) # 80000974 <printf>
    800005b8:	00001097          	auipc	ra,0x1
    800005bc:	858080e7          	jalr	-1960(ra) # 80000e10 <reset_color>
    printf("\n\n");
    800005c0:	00001517          	auipc	a0,0x1
    800005c4:	04050513          	addi	a0,a0,64 # 80001600 <clear_line+0x640>
    800005c8:	00000097          	auipc	ra,0x0
    800005cc:	3ac080e7          	jalr	940(ra) # 80000974 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    800005d0:	00001517          	auipc	a0,0x1
    800005d4:	0a050513          	addi	a0,a0,160 # 80001670 <clear_line+0x6b0>
    800005d8:	00000097          	auipc	ra,0x0
    800005dc:	39c080e7          	jalr	924(ra) # 80000974 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    800005e0:	02c00593          	li	a1,44
    800005e4:	457d                	li	a0,31
    800005e6:	00001097          	auipc	ra,0x1
    800005ea:	9b0080e7          	jalr	-1616(ra) # 80000f96 <set_color>
    800005ee:	00001517          	auipc	a0,0x1
    800005f2:	09a50513          	addi	a0,a0,154 # 80001688 <clear_line+0x6c8>
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	37e080e7          	jalr	894(ra) # 80000974 <printf>
    800005fe:	00001097          	auipc	ra,0x1
    80000602:	812080e7          	jalr	-2030(ra) # 80000e10 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80000606:	02d00593          	li	a1,45
    8000060a:	02100513          	li	a0,33
    8000060e:	00001097          	auipc	ra,0x1
    80000612:	988080e7          	jalr	-1656(ra) # 80000f96 <set_color>
    80000616:	00001517          	auipc	a0,0x1
    8000061a:	08250513          	addi	a0,a0,130 # 80001698 <clear_line+0x6d8>
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	356080e7          	jalr	854(ra) # 80000974 <printf>
    80000626:	00000097          	auipc	ra,0x0
    8000062a:	7ea080e7          	jalr	2026(ra) # 80000e10 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    8000062e:	02f00593          	li	a1,47
    80000632:	02000513          	li	a0,32
    80000636:	00001097          	auipc	ra,0x1
    8000063a:	960080e7          	jalr	-1696(ra) # 80000f96 <set_color>
    8000063e:	00001517          	auipc	a0,0x1
    80000642:	06a50513          	addi	a0,a0,106 # 800016a8 <clear_line+0x6e8>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	32e080e7          	jalr	814(ra) # 80000974 <printf>
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	7c2080e7          	jalr	1986(ra) # 80000e10 <reset_color>
    printf("\n\n");
    80000656:	00001517          	auipc	a0,0x1
    8000065a:	faa50513          	addi	a0,a0,-86 # 80001600 <clear_line+0x640>
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	316080e7          	jalr	790(ra) # 80000974 <printf>
	reset_color();
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	7aa080e7          	jalr	1962(ra) # 80000e10 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    8000066e:	00001517          	auipc	a0,0x1
    80000672:	04a50513          	addi	a0,a0,74 # 800016b8 <clear_line+0x6f8>
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	2fe080e7          	jalr	766(ra) # 80000974 <printf>
	cursor_up(1); // 光标上移一行
    8000067e:	4505                	li	a0,1
    80000680:	00000097          	auipc	ra,0x0
    80000684:	546080e7          	jalr	1350(ra) # 80000bc6 <cursor_up>
	clear_line();
    80000688:	00001097          	auipc	ra,0x1
    8000068c:	938080e7          	jalr	-1736(ra) # 80000fc0 <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80000690:	00001517          	auipc	a0,0x1
    80000694:	06050513          	addi	a0,a0,96 # 800016f0 <clear_line+0x730>
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	2dc080e7          	jalr	732(ra) # 80000974 <printf>
    800006a0:	60a2                	ld	ra,8(sp)
    800006a2:	6402                	ld	s0,0(sp)
    800006a4:	0141                	addi	sp,sp,16
    800006a6:	8082                	ret

00000000800006a8 <start>:
void start(){
    800006a8:	1141                	addi	sp,sp,-16
    800006aa:	e406                	sd	ra,8(sp)
    800006ac:	e022                	sd	s0,0(sp)
    800006ae:	0800                	addi	s0,sp,16
    uart_puts("===============================================\n");
    800006b0:	00001517          	auipc	a0,0x1
    800006b4:	06050513          	addi	a0,a0,96 # 80001710 <clear_line+0x750>
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	116080e7          	jalr	278(ra) # 800007ce <uart_puts>
    uart_puts("        RISC-V Operating System v1.0         \n");
    800006c0:	00001517          	auipc	a0,0x1
    800006c4:	08850513          	addi	a0,a0,136 # 80001748 <clear_line+0x788>
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	106080e7          	jalr	262(ra) # 800007ce <uart_puts>
    uart_puts("===============================================\n\n");
    800006d0:	00001517          	auipc	a0,0x1
    800006d4:	0a850513          	addi	a0,a0,168 # 80001778 <clear_line+0x7b8>
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	0f6080e7          	jalr	246(ra) # 800007ce <uart_puts>
    uart_puts("Hello, RISC-V Kernel!\n");
    800006e0:	00001517          	auipc	a0,0x1
    800006e4:	0d050513          	addi	a0,a0,208 # 800017b0 <clear_line+0x7f0>
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	0e6080e7          	jalr	230(ra) # 800007ce <uart_puts>
    uart_puts("Kernel startup complete!\n");
    800006f0:	00001517          	auipc	a0,0x1
    800006f4:	0d850513          	addi	a0,a0,216 # 800017c8 <clear_line+0x808>
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	0d6080e7          	jalr	214(ra) # 800007ce <uart_puts>
    uart_puts("Testing BSS zero initialization:\n");
    80000700:	00001517          	auipc	a0,0x1
    80000704:	0e850513          	addi	a0,a0,232 # 800017e8 <clear_line+0x828>
    80000708:	00000097          	auipc	ra,0x0
    8000070c:	0c6080e7          	jalr	198(ra) # 800007ce <uart_puts>
    if (global_test1 == 0 && global_test2 == 0) {
    80000710:	00004797          	auipc	a5,0x4
    80000714:	8f47a783          	lw	a5,-1804(a5) # 80004004 <global_test1>
    80000718:	00004717          	auipc	a4,0x4
    8000071c:	8e872703          	lw	a4,-1816(a4) # 80004000 <global_test2>
    80000720:	8fd9                	or	a5,a5,a4
    80000722:	c3b5                	beqz	a5,80000786 <start+0xde>
        uart_puts("  [ERROR] BSS variables not zeroed!\n");
    80000724:	00001517          	auipc	a0,0x1
    80000728:	11450513          	addi	a0,a0,276 # 80001838 <clear_line+0x878>
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	0a2080e7          	jalr	162(ra) # 800007ce <uart_puts>
    if (initialized_global == 123) {
    80000734:	00002717          	auipc	a4,0x2
    80000738:	8cc72703          	lw	a4,-1844(a4) # 80002000 <initialized_global>
    8000073c:	07b00793          	li	a5,123
    80000740:	04f70c63          	beq	a4,a5,80000798 <start+0xf0>
        uart_puts("  [ERROR] Initialized variables corrupted!\n");
    80000744:	00001517          	auipc	a0,0x1
    80000748:	14450513          	addi	a0,a0,324 # 80001888 <clear_line+0x8c8>
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	082080e7          	jalr	130(ra) # 800007ce <uart_puts>
    uart_puts("\nSystem ready. Entering main loop...\n");
    80000754:	00001517          	auipc	a0,0x1
    80000758:	16450513          	addi	a0,a0,356 # 800018b8 <clear_line+0x8f8>
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	072080e7          	jalr	114(ra) # 800007ce <uart_puts>
	clear_screen();
    80000764:	00000097          	auipc	ra,0x0
    80000768:	432080e7          	jalr	1074(ra) # 80000b96 <clear_screen>
	test_printf_precision();
    8000076c:	00000097          	auipc	ra,0x0
    80000770:	8c6080e7          	jalr	-1850(ra) # 80000032 <test_printf_precision>
	test_curse_move();
    80000774:	00000097          	auipc	ra,0x0
    80000778:	bb0080e7          	jalr	-1104(ra) # 80000324 <test_curse_move>
	test_basic_colors();
    8000077c:	00000097          	auipc	ra,0x0
    80000780:	c90080e7          	jalr	-880(ra) # 8000040c <test_basic_colors>
    while(1) {
    80000784:	a001                	j	80000784 <start+0xdc>
        uart_puts("  [OK] BSS variables correctly zeroed\n");
    80000786:	00001517          	auipc	a0,0x1
    8000078a:	08a50513          	addi	a0,a0,138 # 80001810 <clear_line+0x850>
    8000078e:	00000097          	auipc	ra,0x0
    80000792:	040080e7          	jalr	64(ra) # 800007ce <uart_puts>
    80000796:	bf79                	j	80000734 <start+0x8c>
        uart_puts("  [OK] Initialized variables working\n");
    80000798:	00001517          	auipc	a0,0x1
    8000079c:	0c850513          	addi	a0,a0,200 # 80001860 <clear_line+0x8a0>
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	02e080e7          	jalr	46(ra) # 800007ce <uart_puts>
    800007a8:	b775                	j	80000754 <start+0xac>

00000000800007aa <uart_putc>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))


void uart_putc(char c)
{
    800007aa:	1141                	addi	sp,sp,-16
    800007ac:	e422                	sd	s0,8(sp)
    800007ae:	0800                	addi	s0,sp,16
  // 等待发送缓冲区空闲
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007b0:	10000737          	lui	a4,0x10000
    800007b4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800007b6:	00074783          	lbu	a5,0(a4)
    800007ba:	0207f793          	andi	a5,a5,32
    800007be:	dfe5                	beqz	a5,800007b6 <uart_putc+0xc>
    ;
  // 写入字符到发送寄存器
  WriteReg(THR, c);
    800007c0:	100007b7          	lui	a5,0x10000
    800007c4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    800007c8:	6422                	ld	s0,8(sp)
    800007ca:	0141                	addi	sp,sp,16
    800007cc:	8082                	ret

00000000800007ce <uart_puts>:

// 成功后实现字符串输出
void uart_puts(char *s)
{
    800007ce:	1141                	addi	sp,sp,-16
    800007d0:	e422                	sd	s0,8(sp)
    800007d2:	0800                	addi	s0,sp,16
    if (!s) return;
    800007d4:	cd15                	beqz	a0,80000810 <uart_puts+0x42>
    
    while (*s) {
    800007d6:	00054783          	lbu	a5,0(a0)
    800007da:	cb9d                	beqz	a5,80000810 <uart_puts+0x42>
        // 批量检查：一次等待，发送多个字符
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007dc:	10000737          	lui	a4,0x10000
    800007e0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
            ;
            
        // 连续发送字符，直到缓冲区可能满或字符串结束
        int sent_count = 0;
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
            WriteReg(THR, *s);
    800007e2:	10000637          	lui	a2,0x10000
    800007e6:	a011                	j	800007ea <uart_puts+0x1c>
    while (*s) {
    800007e8:	c785                	beqz	a5,80000810 <uart_puts+0x42>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007ea:	00074783          	lbu	a5,0(a4)
    800007ee:	0207f793          	andi	a5,a5,32
    800007f2:	dfe5                	beqz	a5,800007ea <uart_puts+0x1c>
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    800007f4:	00054783          	lbu	a5,0(a0)
    800007f8:	cf81                	beqz	a5,80000810 <uart_puts+0x42>
    800007fa:	00450693          	addi	a3,a0,4
            WriteReg(THR, *s);
    800007fe:	00f60023          	sb	a5,0(a2) # 10000000 <_entry-0x70000000>
            s++;
    80000802:	0505                	addi	a0,a0,1
        while (*s && sent_count < 4) {  // 假设FIFO深度至少为4
    80000804:	00054783          	lbu	a5,0(a0)
    80000808:	c781                	beqz	a5,80000810 <uart_puts+0x42>
    8000080a:	fea69ae3          	bne	a3,a0,800007fe <uart_puts+0x30>
    8000080e:	bfe9                	j	800007e8 <uart_puts+0x1a>
            sent_count++;
        }
    }
    80000810:	6422                	ld	s0,8(sp)
    80000812:	0141                	addi	sp,sp,16
    80000814:	8082                	ret

0000000080000816 <printint>:
static void consputs(const char *s){
	char *str = (char *)s;
	// 直接调用uart_puts输出字符串
	uart_puts(str);
}
static void printint(long long xx,int base,int sign){
    80000816:	7139                	addi	sp,sp,-64
    80000818:	fc06                	sd	ra,56(sp)
    8000081a:	f822                	sd	s0,48(sp)
    8000081c:	0080                	addi	s0,sp,64
	// 模仿xv6的printint
	static char digits[] = "0123456789abcdef";
	char buf[20]; // 增大缓冲区以处理64位整数
	int i;
	unsigned long long x;
	if (sign && (sign = xx < 0)) // 符号处理
    8000081e:	c219                	beqz	a2,80000824 <printint+0xe>
    80000820:	08054563          	bltz	a0,800008aa <printint+0x94>
		x = -(unsigned long long)xx; // 强制转换以避免溢出
	else
		x = xx;
    80000824:	4881                	li	a7,0

	if (base == 10 && x < 100) {
    80000826:	47a9                	li	a5,10
    80000828:	08f58563          	beq	a1,a5,800008b2 <printint+0x9c>
		x = xx;
    8000082c:	fc840693          	addi	a3,s0,-56
    80000830:	4781                	li	a5,0
		consputs(small_numbers[x]);
		return;
	}
	i = 0;
	do{
		buf[i] = digits[x % base];
    80000832:	00001617          	auipc	a2,0x1
    80000836:	14e60613          	addi	a2,a2,334 # 80001980 <small_numbers>
    8000083a:	02b57733          	remu	a4,a0,a1
    8000083e:	9732                	add	a4,a4,a2
    80000840:	19074703          	lbu	a4,400(a4)
    80000844:	00e68023          	sb	a4,0(a3)
		i++;
    80000848:	883e                	mv	a6,a5
    8000084a:	2785                	addiw	a5,a5,1
	}while((x/=base) !=0);
    8000084c:	872a                	mv	a4,a0
    8000084e:	02b55533          	divu	a0,a0,a1
    80000852:	0685                	addi	a3,a3,1
    80000854:	feb773e3          	bgeu	a4,a1,8000083a <printint+0x24>
	if (sign){
    80000858:	00088a63          	beqz	a7,8000086c <printint+0x56>
		buf[i] = '-';
    8000085c:	1781                	addi	a5,a5,-32
    8000085e:	97a2                	add	a5,a5,s0
    80000860:	02d00713          	li	a4,45
    80000864:	fee78423          	sb	a4,-24(a5)
		i++;
    80000868:	0028079b          	addiw	a5,a6,2
	}
	i--;
	while( i>=0){
    8000086c:	02f05b63          	blez	a5,800008a2 <printint+0x8c>
    80000870:	f426                	sd	s1,40(sp)
    80000872:	f04a                	sd	s2,32(sp)
    80000874:	fc840713          	addi	a4,s0,-56
    80000878:	00f704b3          	add	s1,a4,a5
    8000087c:	fff70913          	addi	s2,a4,-1
    80000880:	993e                	add	s2,s2,a5
    80000882:	37fd                	addiw	a5,a5,-1
    80000884:	1782                	slli	a5,a5,0x20
    80000886:	9381                	srli	a5,a5,0x20
    80000888:	40f90933          	sub	s2,s2,a5
	uart_putc(c);
    8000088c:	fff4c503          	lbu	a0,-1(s1)
    80000890:	00000097          	auipc	ra,0x0
    80000894:	f1a080e7          	jalr	-230(ra) # 800007aa <uart_putc>
	while( i>=0){
    80000898:	14fd                	addi	s1,s1,-1
    8000089a:	ff2499e3          	bne	s1,s2,8000088c <printint+0x76>
    8000089e:	74a2                	ld	s1,40(sp)
    800008a0:	7902                	ld	s2,32(sp)
		consputc(buf[i]);
		i--;
	}
}
    800008a2:	70e2                	ld	ra,56(sp)
    800008a4:	7442                	ld	s0,48(sp)
    800008a6:	6121                	addi	sp,sp,64
    800008a8:	8082                	ret
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    800008aa:	40a00533          	neg	a0,a0
	if (sign && (sign = xx < 0)) // 符号处理
    800008ae:	4885                	li	a7,1
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    800008b0:	bf9d                	j	80000826 <printint+0x10>
	if (base == 10 && x < 100) {
    800008b2:	06300793          	li	a5,99
    800008b6:	f6a7ebe3          	bltu	a5,a0,8000082c <printint+0x16>
		consputs(small_numbers[x]);
    800008ba:	050a                	slli	a0,a0,0x2
	uart_puts(str);
    800008bc:	00001797          	auipc	a5,0x1
    800008c0:	0c478793          	addi	a5,a5,196 # 80001980 <small_numbers>
    800008c4:	953e                	add	a0,a0,a5
    800008c6:	00000097          	auipc	ra,0x0
    800008ca:	f08080e7          	jalr	-248(ra) # 800007ce <uart_puts>
		return;
    800008ce:	bfd1                	j	800008a2 <printint+0x8c>

00000000800008d0 <flush_printf_buffer>:
	if (printf_buf_pos > 0) {
    800008d0:	00003797          	auipc	a5,0x3
    800008d4:	7387a783          	lw	a5,1848(a5) # 80004008 <printf_buf_pos>
    800008d8:	00f04363          	bgtz	a5,800008de <flush_printf_buffer+0xe>
    800008dc:	8082                	ret
static void flush_printf_buffer(void) {
    800008de:	1141                	addi	sp,sp,-16
    800008e0:	e406                	sd	ra,8(sp)
    800008e2:	e022                	sd	s0,0(sp)
    800008e4:	0800                	addi	s0,sp,16
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    800008e6:	00003517          	auipc	a0,0x3
    800008ea:	75250513          	addi	a0,a0,1874 # 80004038 <printf_buffer>
    800008ee:	97aa                	add	a5,a5,a0
    800008f0:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    800008f4:	00000097          	auipc	ra,0x0
    800008f8:	eda080e7          	jalr	-294(ra) # 800007ce <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    800008fc:	00003797          	auipc	a5,0x3
    80000900:	7007a623          	sw	zero,1804(a5) # 80004008 <printf_buf_pos>
}
    80000904:	60a2                	ld	ra,8(sp)
    80000906:	6402                	ld	s0,0(sp)
    80000908:	0141                	addi	sp,sp,16
    8000090a:	8082                	ret

000000008000090c <buffer_char>:
static void buffer_char(char c) {
    8000090c:	1101                	addi	sp,sp,-32
    8000090e:	ec06                	sd	ra,24(sp)
    80000910:	e822                	sd	s0,16(sp)
    80000912:	e426                	sd	s1,8(sp)
    80000914:	1000                	addi	s0,sp,32
    80000916:	84aa                	mv	s1,a0
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    80000918:	00003797          	auipc	a5,0x3
    8000091c:	6f07a783          	lw	a5,1776(a5) # 80004008 <printf_buf_pos>
    80000920:	07e00713          	li	a4,126
    80000924:	02f74463          	blt	a4,a5,8000094c <buffer_char+0x40>
		printf_buffer[printf_buf_pos++] = c;
    80000928:	0017871b          	addiw	a4,a5,1
    8000092c:	00003697          	auipc	a3,0x3
    80000930:	6ce6ae23          	sw	a4,1756(a3) # 80004008 <printf_buf_pos>
    80000934:	00003717          	auipc	a4,0x3
    80000938:	70470713          	addi	a4,a4,1796 # 80004038 <printf_buffer>
    8000093c:	97ba                	add	a5,a5,a4
    8000093e:	00a78023          	sb	a0,0(a5)
}
    80000942:	60e2                	ld	ra,24(sp)
    80000944:	6442                	ld	s0,16(sp)
    80000946:	64a2                	ld	s1,8(sp)
    80000948:	6105                	addi	sp,sp,32
    8000094a:	8082                	ret
		flush_printf_buffer(); // Buffer full, flush it
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	f84080e7          	jalr	-124(ra) # 800008d0 <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    80000954:	00003797          	auipc	a5,0x3
    80000958:	6b478793          	addi	a5,a5,1716 # 80004008 <printf_buf_pos>
    8000095c:	4398                	lw	a4,0(a5)
    8000095e:	0017069b          	addiw	a3,a4,1
    80000962:	c394                	sw	a3,0(a5)
    80000964:	00003797          	auipc	a5,0x3
    80000968:	6d478793          	addi	a5,a5,1748 # 80004038 <printf_buffer>
    8000096c:	97ba                	add	a5,a5,a4
    8000096e:	00978023          	sb	s1,0(a5)
}
    80000972:	bfc1                	j	80000942 <buffer_char+0x36>

0000000080000974 <printf>:
void printf(const char *fmt, ...) {
    80000974:	7135                	addi	sp,sp,-160
    80000976:	ec86                	sd	ra,88(sp)
    80000978:	e8a2                	sd	s0,80(sp)
    8000097a:	e0ca                	sd	s2,64(sp)
    8000097c:	1080                	addi	s0,sp,96
    8000097e:	892a                	mv	s2,a0
    80000980:	e40c                	sd	a1,8(s0)
    80000982:	e810                	sd	a2,16(s0)
    80000984:	ec14                	sd	a3,24(s0)
    80000986:	f018                	sd	a4,32(s0)
    80000988:	f41c                	sd	a5,40(s0)
    8000098a:	03043823          	sd	a6,48(s0)
    8000098e:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    80000992:	00840793          	addi	a5,s0,8
    80000996:	faf43c23          	sd	a5,-72(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000099a:	00054503          	lbu	a0,0(a0)
    8000099e:	1c050d63          	beqz	a0,80000b78 <printf+0x204>
    800009a2:	e4a6                	sd	s1,72(sp)
    800009a4:	fc4e                	sd	s3,56(sp)
    800009a6:	f852                	sd	s4,48(sp)
    800009a8:	f456                	sd	s5,40(sp)
    800009aa:	f05a                	sd	s6,32(sp)
    800009ac:	0005079b          	sext.w	a5,a0
    800009b0:	4481                	li	s1,0
        if(c != '%'){
    800009b2:	02500993          	li	s3,37
        }
		flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
        c = fmt[++i] & 0xff;
        if(c == 0)
            break;
        switch(c){
    800009b6:	4a59                	li	s4,22
    800009b8:	00001a97          	auipc	s5,0x1
    800009bc:	f68a8a93          	addi	s5,s5,-152 # 80001920 <clear_line+0x960>
    800009c0:	a831                	j	800009dc <printf+0x68>
            buffer_char(c);
    800009c2:	00000097          	auipc	ra,0x0
    800009c6:	f4a080e7          	jalr	-182(ra) # 8000090c <buffer_char>
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800009ca:	2485                	addiw	s1,s1,1
    800009cc:	009907b3          	add	a5,s2,s1
    800009d0:	0007c503          	lbu	a0,0(a5)
    800009d4:	0005079b          	sext.w	a5,a0
    800009d8:	18050b63          	beqz	a0,80000b6e <printf+0x1fa>
        if(c != '%'){
    800009dc:	ff3793e3          	bne	a5,s3,800009c2 <printf+0x4e>
		flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    800009e0:	00000097          	auipc	ra,0x0
    800009e4:	ef0080e7          	jalr	-272(ra) # 800008d0 <flush_printf_buffer>
        c = fmt[++i] & 0xff;
    800009e8:	2485                	addiw	s1,s1,1
    800009ea:	009907b3          	add	a5,s2,s1
    800009ee:	0007cb03          	lbu	s6,0(a5)
        if(c == 0)
    800009f2:	180b0c63          	beqz	s6,80000b8a <printf+0x216>
        switch(c){
    800009f6:	153b0963          	beq	s6,s3,80000b48 <printf+0x1d4>
    800009fa:	f9eb079b          	addiw	a5,s6,-98
    800009fe:	0ff7f793          	zext.b	a5,a5
    80000a02:	14fa6a63          	bltu	s4,a5,80000b56 <printf+0x1e2>
    80000a06:	f9eb079b          	addiw	a5,s6,-98
    80000a0a:	0ff7f713          	zext.b	a4,a5
    80000a0e:	14ea6463          	bltu	s4,a4,80000b56 <printf+0x1e2>
    80000a12:	00271793          	slli	a5,a4,0x2
    80000a16:	97d6                	add	a5,a5,s5
    80000a18:	439c                	lw	a5,0(a5)
    80000a1a:	97d6                	add	a5,a5,s5
    80000a1c:	8782                	jr	a5
        case 'd':
            printint(va_arg(ap, int), 10, 1);
    80000a1e:	fb843783          	ld	a5,-72(s0)
    80000a22:	00878713          	addi	a4,a5,8
    80000a26:	fae43c23          	sd	a4,-72(s0)
    80000a2a:	4605                	li	a2,1
    80000a2c:	45a9                	li	a1,10
    80000a2e:	4388                	lw	a0,0(a5)
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	de6080e7          	jalr	-538(ra) # 80000816 <printint>
            break;
    80000a38:	bf49                	j	800009ca <printf+0x56>
        case 'x':
            printint(va_arg(ap, int), 16, 0);
    80000a3a:	fb843783          	ld	a5,-72(s0)
    80000a3e:	00878713          	addi	a4,a5,8
    80000a42:	fae43c23          	sd	a4,-72(s0)
    80000a46:	4601                	li	a2,0
    80000a48:	45c1                	li	a1,16
    80000a4a:	4388                	lw	a0,0(a5)
    80000a4c:	00000097          	auipc	ra,0x0
    80000a50:	dca080e7          	jalr	-566(ra) # 80000816 <printint>
            break;
    80000a54:	bf9d                	j	800009ca <printf+0x56>
        case 'u':
            printint(va_arg(ap, unsigned int), 10, 0);
    80000a56:	fb843783          	ld	a5,-72(s0)
    80000a5a:	00878713          	addi	a4,a5,8
    80000a5e:	fae43c23          	sd	a4,-72(s0)
    80000a62:	4601                	li	a2,0
    80000a64:	45a9                	li	a1,10
    80000a66:	0007e503          	lwu	a0,0(a5)
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	dac080e7          	jalr	-596(ra) # 80000816 <printint>
            break;
    80000a72:	bfa1                	j	800009ca <printf+0x56>
        case 'c':
            consputc(va_arg(ap, int));
    80000a74:	fb843783          	ld	a5,-72(s0)
    80000a78:	00878713          	addi	a4,a5,8
    80000a7c:	fae43c23          	sd	a4,-72(s0)
	uart_putc(c);
    80000a80:	0007c503          	lbu	a0,0(a5)
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	d26080e7          	jalr	-730(ra) # 800007aa <uart_putc>
}
    80000a8c:	bf3d                	j	800009ca <printf+0x56>
            break;
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80000a8e:	fb843783          	ld	a5,-72(s0)
    80000a92:	00878713          	addi	a4,a5,8
    80000a96:	fae43c23          	sd	a4,-72(s0)
    80000a9a:	6388                	ld	a0,0(a5)
    80000a9c:	c511                	beqz	a0,80000aa8 <printf+0x134>
	uart_puts(str);
    80000a9e:	00000097          	auipc	ra,0x0
    80000aa2:	d30080e7          	jalr	-720(ra) # 800007ce <uart_puts>
}
    80000aa6:	b715                	j	800009ca <printf+0x56>
                s = "(null)";
    80000aa8:	00001517          	auipc	a0,0x1
    80000aac:	e3850513          	addi	a0,a0,-456 # 800018e0 <clear_line+0x920>
    80000ab0:	b7fd                	j	80000a9e <printf+0x12a>
            consputs(s);
            break;
		case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    80000ab2:	fb843783          	ld	a5,-72(s0)
    80000ab6:	00878713          	addi	a4,a5,8
    80000aba:	fae43c23          	sd	a4,-72(s0)
    80000abe:	0007bb03          	ld	s6,0(a5)
	uart_puts(str);
    80000ac2:	00001517          	auipc	a0,0x1
    80000ac6:	e2650513          	addi	a0,a0,-474 # 800018e8 <clear_line+0x928>
    80000aca:	00000097          	auipc	ra,0x0
    80000ace:	d04080e7          	jalr	-764(ra) # 800007ce <uart_puts>
            consputs("0x");
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    80000ad2:	fa040713          	addi	a4,s0,-96
    80000ad6:	fb040593          	addi	a1,s0,-80
	uart_puts(str);
    80000ada:	03c00693          	li	a3,60
                int shift = (15 - i) * 4;
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80000ade:	00001617          	auipc	a2,0x1
    80000ae2:	e1260613          	addi	a2,a2,-494 # 800018f0 <clear_line+0x930>
    80000ae6:	00db57b3          	srl	a5,s6,a3
    80000aea:	8bbd                	andi	a5,a5,15
    80000aec:	97b2                	add	a5,a5,a2
    80000aee:	0007c783          	lbu	a5,0(a5)
    80000af2:	00f70023          	sb	a5,0(a4)
            for (i = 0; i < 16; i++) {
    80000af6:	36f1                	addiw	a3,a3,-4
    80000af8:	0705                	addi	a4,a4,1
    80000afa:	feb716e3          	bne	a4,a1,80000ae6 <printf+0x172>
            }
            buf[16] = '\0';
    80000afe:	fa040823          	sb	zero,-80(s0)
	uart_puts(str);
    80000b02:	fa040513          	addi	a0,s0,-96
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	cc8080e7          	jalr	-824(ra) # 800007ce <uart_puts>
}
    80000b0e:	bd75                	j	800009ca <printf+0x56>
            consputs(buf);
            break;
		case 'b':
            printint(va_arg(ap, int), 2, 0);
    80000b10:	fb843783          	ld	a5,-72(s0)
    80000b14:	00878713          	addi	a4,a5,8
    80000b18:	fae43c23          	sd	a4,-72(s0)
    80000b1c:	4601                	li	a2,0
    80000b1e:	4589                	li	a1,2
    80000b20:	4388                	lw	a0,0(a5)
    80000b22:	00000097          	auipc	ra,0x0
    80000b26:	cf4080e7          	jalr	-780(ra) # 80000816 <printint>
            break;
    80000b2a:	b545                	j	800009ca <printf+0x56>
        case 'o':
            printint(va_arg(ap, int), 8, 0);
    80000b2c:	fb843783          	ld	a5,-72(s0)
    80000b30:	00878713          	addi	a4,a5,8
    80000b34:	fae43c23          	sd	a4,-72(s0)
    80000b38:	4601                	li	a2,0
    80000b3a:	45a1                	li	a1,8
    80000b3c:	4388                	lw	a0,0(a5)
    80000b3e:	00000097          	auipc	ra,0x0
    80000b42:	cd8080e7          	jalr	-808(ra) # 80000816 <printint>
            break;
    80000b46:	b551                	j	800009ca <printf+0x56>
        case '%':
            buffer_char('%');
    80000b48:	02500513          	li	a0,37
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	dc0080e7          	jalr	-576(ra) # 8000090c <buffer_char>
            break;
    80000b54:	bd9d                	j	800009ca <printf+0x56>
        default:
			buffer_char('%');
    80000b56:	02500513          	li	a0,37
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	db2080e7          	jalr	-590(ra) # 8000090c <buffer_char>
			buffer_char(c);
    80000b62:	855a                	mv	a0,s6
    80000b64:	00000097          	auipc	ra,0x0
    80000b68:	da8080e7          	jalr	-600(ra) # 8000090c <buffer_char>
            break;
    80000b6c:	bdb9                	j	800009ca <printf+0x56>
    80000b6e:	64a6                	ld	s1,72(sp)
    80000b70:	79e2                	ld	s3,56(sp)
    80000b72:	7a42                	ld	s4,48(sp)
    80000b74:	7aa2                	ld	s5,40(sp)
    80000b76:	7b02                	ld	s6,32(sp)
        }
    }
	flush_printf_buffer(); // 最后刷新缓冲区
    80000b78:	00000097          	auipc	ra,0x0
    80000b7c:	d58080e7          	jalr	-680(ra) # 800008d0 <flush_printf_buffer>
    va_end(ap);
}
    80000b80:	60e6                	ld	ra,88(sp)
    80000b82:	6446                	ld	s0,80(sp)
    80000b84:	6906                	ld	s2,64(sp)
    80000b86:	610d                	addi	sp,sp,160
    80000b88:	8082                	ret
    80000b8a:	64a6                	ld	s1,72(sp)
    80000b8c:	79e2                	ld	s3,56(sp)
    80000b8e:	7a42                	ld	s4,48(sp)
    80000b90:	7aa2                	ld	s5,40(sp)
    80000b92:	7b02                	ld	s6,32(sp)
    80000b94:	b7d5                	j	80000b78 <printf+0x204>

0000000080000b96 <clear_screen>:
// 清屏功能
void clear_screen(void) {
    80000b96:	1141                	addi	sp,sp,-16
    80000b98:	e406                	sd	ra,8(sp)
    80000b9a:	e022                	sd	s0,0(sp)
    80000b9c:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    80000b9e:	00001517          	auipc	a0,0x1
    80000ba2:	d6a50513          	addi	a0,a0,-662 # 80001908 <clear_line+0x948>
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	c28080e7          	jalr	-984(ra) # 800007ce <uart_puts>
	uart_puts(CURSOR_HOME);
    80000bae:	00001517          	auipc	a0,0x1
    80000bb2:	d6250513          	addi	a0,a0,-670 # 80001910 <clear_line+0x950>
    80000bb6:	00000097          	auipc	ra,0x0
    80000bba:	c18080e7          	jalr	-1000(ra) # 800007ce <uart_puts>
}
    80000bbe:	60a2                	ld	ra,8(sp)
    80000bc0:	6402                	ld	s0,0(sp)
    80000bc2:	0141                	addi	sp,sp,16
    80000bc4:	8082                	ret

0000000080000bc6 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    if (lines <= 0) return;
    80000bc6:	04a05563          	blez	a0,80000c10 <cursor_up+0x4a>
void cursor_up(int lines) {
    80000bca:	1101                	addi	sp,sp,-32
    80000bcc:	ec06                	sd	ra,24(sp)
    80000bce:	e822                	sd	s0,16(sp)
    80000bd0:	e426                	sd	s1,8(sp)
    80000bd2:	1000                	addi	s0,sp,32
    80000bd4:	84aa                	mv	s1,a0
	uart_putc(c);
    80000bd6:	456d                	li	a0,27
    80000bd8:	00000097          	auipc	ra,0x0
    80000bdc:	bd2080e7          	jalr	-1070(ra) # 800007aa <uart_putc>
    80000be0:	05b00513          	li	a0,91
    80000be4:	00000097          	auipc	ra,0x0
    80000be8:	bc6080e7          	jalr	-1082(ra) # 800007aa <uart_putc>
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    80000bec:	4601                	li	a2,0
    80000bee:	45a9                	li	a1,10
    80000bf0:	8526                	mv	a0,s1
    80000bf2:	00000097          	auipc	ra,0x0
    80000bf6:	c24080e7          	jalr	-988(ra) # 80000816 <printint>
	uart_putc(c);
    80000bfa:	04100513          	li	a0,65
    80000bfe:	00000097          	auipc	ra,0x0
    80000c02:	bac080e7          	jalr	-1108(ra) # 800007aa <uart_putc>
    consputc('A');
}
    80000c06:	60e2                	ld	ra,24(sp)
    80000c08:	6442                	ld	s0,16(sp)
    80000c0a:	64a2                	ld	s1,8(sp)
    80000c0c:	6105                	addi	sp,sp,32
    80000c0e:	8082                	ret
    80000c10:	8082                	ret

0000000080000c12 <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    if (lines <= 0) return;
    80000c12:	04a05563          	blez	a0,80000c5c <cursor_down+0x4a>
void cursor_down(int lines) {
    80000c16:	1101                	addi	sp,sp,-32
    80000c18:	ec06                	sd	ra,24(sp)
    80000c1a:	e822                	sd	s0,16(sp)
    80000c1c:	e426                	sd	s1,8(sp)
    80000c1e:	1000                	addi	s0,sp,32
    80000c20:	84aa                	mv	s1,a0
	uart_putc(c);
    80000c22:	456d                	li	a0,27
    80000c24:	00000097          	auipc	ra,0x0
    80000c28:	b86080e7          	jalr	-1146(ra) # 800007aa <uart_putc>
    80000c2c:	05b00513          	li	a0,91
    80000c30:	00000097          	auipc	ra,0x0
    80000c34:	b7a080e7          	jalr	-1158(ra) # 800007aa <uart_putc>
    consputc('\033');
    consputc('[');
    printint(lines, 10, 0);
    80000c38:	4601                	li	a2,0
    80000c3a:	45a9                	li	a1,10
    80000c3c:	8526                	mv	a0,s1
    80000c3e:	00000097          	auipc	ra,0x0
    80000c42:	bd8080e7          	jalr	-1064(ra) # 80000816 <printint>
	uart_putc(c);
    80000c46:	04200513          	li	a0,66
    80000c4a:	00000097          	auipc	ra,0x0
    80000c4e:	b60080e7          	jalr	-1184(ra) # 800007aa <uart_putc>
    consputc('B');
}
    80000c52:	60e2                	ld	ra,24(sp)
    80000c54:	6442                	ld	s0,16(sp)
    80000c56:	64a2                	ld	s1,8(sp)
    80000c58:	6105                	addi	sp,sp,32
    80000c5a:	8082                	ret
    80000c5c:	8082                	ret

0000000080000c5e <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    if (cols <= 0) return;
    80000c5e:	04a05563          	blez	a0,80000ca8 <cursor_right+0x4a>
void cursor_right(int cols) {
    80000c62:	1101                	addi	sp,sp,-32
    80000c64:	ec06                	sd	ra,24(sp)
    80000c66:	e822                	sd	s0,16(sp)
    80000c68:	e426                	sd	s1,8(sp)
    80000c6a:	1000                	addi	s0,sp,32
    80000c6c:	84aa                	mv	s1,a0
	uart_putc(c);
    80000c6e:	456d                	li	a0,27
    80000c70:	00000097          	auipc	ra,0x0
    80000c74:	b3a080e7          	jalr	-1222(ra) # 800007aa <uart_putc>
    80000c78:	05b00513          	li	a0,91
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	b2e080e7          	jalr	-1234(ra) # 800007aa <uart_putc>
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    80000c84:	4601                	li	a2,0
    80000c86:	45a9                	li	a1,10
    80000c88:	8526                	mv	a0,s1
    80000c8a:	00000097          	auipc	ra,0x0
    80000c8e:	b8c080e7          	jalr	-1140(ra) # 80000816 <printint>
	uart_putc(c);
    80000c92:	04300513          	li	a0,67
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	b14080e7          	jalr	-1260(ra) # 800007aa <uart_putc>
    consputc('C');
}
    80000c9e:	60e2                	ld	ra,24(sp)
    80000ca0:	6442                	ld	s0,16(sp)
    80000ca2:	64a2                	ld	s1,8(sp)
    80000ca4:	6105                	addi	sp,sp,32
    80000ca6:	8082                	ret
    80000ca8:	8082                	ret

0000000080000caa <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    if (cols <= 0) return;
    80000caa:	04a05563          	blez	a0,80000cf4 <cursor_left+0x4a>
void cursor_left(int cols) {
    80000cae:	1101                	addi	sp,sp,-32
    80000cb0:	ec06                	sd	ra,24(sp)
    80000cb2:	e822                	sd	s0,16(sp)
    80000cb4:	e426                	sd	s1,8(sp)
    80000cb6:	1000                	addi	s0,sp,32
    80000cb8:	84aa                	mv	s1,a0
	uart_putc(c);
    80000cba:	456d                	li	a0,27
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	aee080e7          	jalr	-1298(ra) # 800007aa <uart_putc>
    80000cc4:	05b00513          	li	a0,91
    80000cc8:	00000097          	auipc	ra,0x0
    80000ccc:	ae2080e7          	jalr	-1310(ra) # 800007aa <uart_putc>
    consputc('\033');
    consputc('[');
    printint(cols, 10, 0);
    80000cd0:	4601                	li	a2,0
    80000cd2:	45a9                	li	a1,10
    80000cd4:	8526                	mv	a0,s1
    80000cd6:	00000097          	auipc	ra,0x0
    80000cda:	b40080e7          	jalr	-1216(ra) # 80000816 <printint>
	uart_putc(c);
    80000cde:	04400513          	li	a0,68
    80000ce2:	00000097          	auipc	ra,0x0
    80000ce6:	ac8080e7          	jalr	-1336(ra) # 800007aa <uart_putc>
    consputc('D');
}
    80000cea:	60e2                	ld	ra,24(sp)
    80000cec:	6442                	ld	s0,16(sp)
    80000cee:	64a2                	ld	s1,8(sp)
    80000cf0:	6105                	addi	sp,sp,32
    80000cf2:	8082                	ret
    80000cf4:	8082                	ret

0000000080000cf6 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    80000cf6:	1141                	addi	sp,sp,-16
    80000cf8:	e406                	sd	ra,8(sp)
    80000cfa:	e022                	sd	s0,0(sp)
    80000cfc:	0800                	addi	s0,sp,16
	uart_putc(c);
    80000cfe:	456d                	li	a0,27
    80000d00:	00000097          	auipc	ra,0x0
    80000d04:	aaa080e7          	jalr	-1366(ra) # 800007aa <uart_putc>
    80000d08:	05b00513          	li	a0,91
    80000d0c:	00000097          	auipc	ra,0x0
    80000d10:	a9e080e7          	jalr	-1378(ra) # 800007aa <uart_putc>
    80000d14:	07300513          	li	a0,115
    80000d18:	00000097          	auipc	ra,0x0
    80000d1c:	a92080e7          	jalr	-1390(ra) # 800007aa <uart_putc>
    consputc('\033');
    consputc('[');
    consputc('s');
}
    80000d20:	60a2                	ld	ra,8(sp)
    80000d22:	6402                	ld	s0,0(sp)
    80000d24:	0141                	addi	sp,sp,16
    80000d26:	8082                	ret

0000000080000d28 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    80000d28:	1141                	addi	sp,sp,-16
    80000d2a:	e406                	sd	ra,8(sp)
    80000d2c:	e022                	sd	s0,0(sp)
    80000d2e:	0800                	addi	s0,sp,16
	uart_putc(c);
    80000d30:	456d                	li	a0,27
    80000d32:	00000097          	auipc	ra,0x0
    80000d36:	a78080e7          	jalr	-1416(ra) # 800007aa <uart_putc>
    80000d3a:	05b00513          	li	a0,91
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	a6c080e7          	jalr	-1428(ra) # 800007aa <uart_putc>
    80000d46:	07500513          	li	a0,117
    80000d4a:	00000097          	auipc	ra,0x0
    80000d4e:	a60080e7          	jalr	-1440(ra) # 800007aa <uart_putc>
    consputc('\033');
    consputc('[');
    consputc('u');
}
    80000d52:	60a2                	ld	ra,8(sp)
    80000d54:	6402                	ld	s0,0(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret

0000000080000d5a <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    80000d5a:	1101                	addi	sp,sp,-32
    80000d5c:	ec06                	sd	ra,24(sp)
    80000d5e:	e822                	sd	s0,16(sp)
    80000d60:	e426                	sd	s1,8(sp)
    80000d62:	1000                	addi	s0,sp,32
    80000d64:	84aa                	mv	s1,a0
	uart_putc(c);
    80000d66:	456d                	li	a0,27
    80000d68:	00000097          	auipc	ra,0x0
    80000d6c:	a42080e7          	jalr	-1470(ra) # 800007aa <uart_putc>
    80000d70:	05b00513          	li	a0,91
    80000d74:	00000097          	auipc	ra,0x0
    80000d78:	a36080e7          	jalr	-1482(ra) # 800007aa <uart_putc>
    if (col <= 0) col = 1;
    80000d7c:	8526                	mv	a0,s1
    80000d7e:	02905463          	blez	s1,80000da6 <cursor_to_column+0x4c>
    consputc('\033');
    consputc('[');
    printint(col, 10, 0);
    80000d82:	4601                	li	a2,0
    80000d84:	45a9                	li	a1,10
    80000d86:	2501                	sext.w	a0,a0
    80000d88:	00000097          	auipc	ra,0x0
    80000d8c:	a8e080e7          	jalr	-1394(ra) # 80000816 <printint>
	uart_putc(c);
    80000d90:	04700513          	li	a0,71
    80000d94:	00000097          	auipc	ra,0x0
    80000d98:	a16080e7          	jalr	-1514(ra) # 800007aa <uart_putc>
    consputc('G');
}
    80000d9c:	60e2                	ld	ra,24(sp)
    80000d9e:	6442                	ld	s0,16(sp)
    80000da0:	64a2                	ld	s1,8(sp)
    80000da2:	6105                	addi	sp,sp,32
    80000da4:	8082                	ret
    if (col <= 0) col = 1;
    80000da6:	4505                	li	a0,1
    80000da8:	bfe9                	j	80000d82 <cursor_to_column+0x28>

0000000080000daa <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80000daa:	1101                	addi	sp,sp,-32
    80000dac:	ec06                	sd	ra,24(sp)
    80000dae:	e822                	sd	s0,16(sp)
    80000db0:	e426                	sd	s1,8(sp)
    80000db2:	e04a                	sd	s2,0(sp)
    80000db4:	1000                	addi	s0,sp,32
    80000db6:	892a                	mv	s2,a0
    80000db8:	84ae                	mv	s1,a1
	uart_putc(c);
    80000dba:	456d                	li	a0,27
    80000dbc:	00000097          	auipc	ra,0x0
    80000dc0:	9ee080e7          	jalr	-1554(ra) # 800007aa <uart_putc>
    80000dc4:	05b00513          	li	a0,91
    80000dc8:	00000097          	auipc	ra,0x0
    80000dcc:	9e2080e7          	jalr	-1566(ra) # 800007aa <uart_putc>
    consputc('\033');
    consputc('[');
    printint(row, 10, 0);
    80000dd0:	4601                	li	a2,0
    80000dd2:	45a9                	li	a1,10
    80000dd4:	854a                	mv	a0,s2
    80000dd6:	00000097          	auipc	ra,0x0
    80000dda:	a40080e7          	jalr	-1472(ra) # 80000816 <printint>
	uart_putc(c);
    80000dde:	03b00513          	li	a0,59
    80000de2:	00000097          	auipc	ra,0x0
    80000de6:	9c8080e7          	jalr	-1592(ra) # 800007aa <uart_putc>
    consputc(';');
    printint(col, 10, 0);
    80000dea:	4601                	li	a2,0
    80000dec:	45a9                	li	a1,10
    80000dee:	8526                	mv	a0,s1
    80000df0:	00000097          	auipc	ra,0x0
    80000df4:	a26080e7          	jalr	-1498(ra) # 80000816 <printint>
	uart_putc(c);
    80000df8:	04800513          	li	a0,72
    80000dfc:	00000097          	auipc	ra,0x0
    80000e00:	9ae080e7          	jalr	-1618(ra) # 800007aa <uart_putc>
    consputc('H');
}
    80000e04:	60e2                	ld	ra,24(sp)
    80000e06:	6442                	ld	s0,16(sp)
    80000e08:	64a2                	ld	s1,8(sp)
    80000e0a:	6902                	ld	s2,0(sp)
    80000e0c:	6105                	addi	sp,sp,32
    80000e0e:	8082                	ret

0000000080000e10 <reset_color>:
// 颜色控制
void reset_color(void) {
    80000e10:	1141                	addi	sp,sp,-16
    80000e12:	e406                	sd	ra,8(sp)
    80000e14:	e022                	sd	s0,0(sp)
    80000e16:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    80000e18:	00001517          	auipc	a0,0x1
    80000e1c:	b0050513          	addi	a0,a0,-1280 # 80001918 <clear_line+0x958>
    80000e20:	00000097          	auipc	ra,0x0
    80000e24:	9ae080e7          	jalr	-1618(ra) # 800007ce <uart_puts>
}
    80000e28:	60a2                	ld	ra,8(sp)
    80000e2a:	6402                	ld	s0,0(sp)
    80000e2c:	0141                	addi	sp,sp,16
    80000e2e:	8082                	ret

0000000080000e30 <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
	if (color < 30 || color > 37) return; // 支持30-37
    80000e30:	fe25071b          	addiw	a4,a0,-30
    80000e34:	479d                	li	a5,7
    80000e36:	00e7f363          	bgeu	a5,a4,80000e3c <set_fg_color+0xc>
    80000e3a:	8082                	ret
void set_fg_color(int color) {
    80000e3c:	1101                	addi	sp,sp,-32
    80000e3e:	ec06                	sd	ra,24(sp)
    80000e40:	e822                	sd	s0,16(sp)
    80000e42:	e426                	sd	s1,8(sp)
    80000e44:	1000                	addi	s0,sp,32
    80000e46:	84aa                	mv	s1,a0
	uart_putc(c);
    80000e48:	456d                	li	a0,27
    80000e4a:	00000097          	auipc	ra,0x0
    80000e4e:	960080e7          	jalr	-1696(ra) # 800007aa <uart_putc>
    80000e52:	05b00513          	li	a0,91
    80000e56:	00000097          	auipc	ra,0x0
    80000e5a:	954080e7          	jalr	-1708(ra) # 800007aa <uart_putc>
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
    80000e5e:	4601                	li	a2,0
    80000e60:	45a9                	li	a1,10
    80000e62:	8526                	mv	a0,s1
    80000e64:	00000097          	auipc	ra,0x0
    80000e68:	9b2080e7          	jalr	-1614(ra) # 80000816 <printint>
	uart_putc(c);
    80000e6c:	06d00513          	li	a0,109
    80000e70:	00000097          	auipc	ra,0x0
    80000e74:	93a080e7          	jalr	-1734(ra) # 800007aa <uart_putc>
	consputc('m');
}
    80000e78:	60e2                	ld	ra,24(sp)
    80000e7a:	6442                	ld	s0,16(sp)
    80000e7c:	64a2                	ld	s1,8(sp)
    80000e7e:	6105                	addi	sp,sp,32
    80000e80:	8082                	ret

0000000080000e82 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
	if (color < 40 || color > 47) return; // 支持40-47
    80000e82:	fd85071b          	addiw	a4,a0,-40
    80000e86:	479d                	li	a5,7
    80000e88:	00e7f363          	bgeu	a5,a4,80000e8e <set_bg_color+0xc>
    80000e8c:	8082                	ret
void set_bg_color(int color) {
    80000e8e:	1101                	addi	sp,sp,-32
    80000e90:	ec06                	sd	ra,24(sp)
    80000e92:	e822                	sd	s0,16(sp)
    80000e94:	e426                	sd	s1,8(sp)
    80000e96:	1000                	addi	s0,sp,32
    80000e98:	84aa                	mv	s1,a0
	uart_putc(c);
    80000e9a:	456d                	li	a0,27
    80000e9c:	00000097          	auipc	ra,0x0
    80000ea0:	90e080e7          	jalr	-1778(ra) # 800007aa <uart_putc>
    80000ea4:	05b00513          	li	a0,91
    80000ea8:	00000097          	auipc	ra,0x0
    80000eac:	902080e7          	jalr	-1790(ra) # 800007aa <uart_putc>
	consputc('\033');
	consputc('[');
	printint(color, 10, 0);
    80000eb0:	4601                	li	a2,0
    80000eb2:	45a9                	li	a1,10
    80000eb4:	8526                	mv	a0,s1
    80000eb6:	00000097          	auipc	ra,0x0
    80000eba:	960080e7          	jalr	-1696(ra) # 80000816 <printint>
	uart_putc(c);
    80000ebe:	06d00513          	li	a0,109
    80000ec2:	00000097          	auipc	ra,0x0
    80000ec6:	8e8080e7          	jalr	-1816(ra) # 800007aa <uart_putc>
	consputc('m');
}
    80000eca:	60e2                	ld	ra,24(sp)
    80000ecc:	6442                	ld	s0,16(sp)
    80000ece:	64a2                	ld	s1,8(sp)
    80000ed0:	6105                	addi	sp,sp,32
    80000ed2:	8082                	ret

0000000080000ed4 <color_red>:
// 简易文字颜色
void color_red(void) {
    80000ed4:	1141                	addi	sp,sp,-16
    80000ed6:	e406                	sd	ra,8(sp)
    80000ed8:	e022                	sd	s0,0(sp)
    80000eda:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    80000edc:	457d                	li	a0,31
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	f52080e7          	jalr	-174(ra) # 80000e30 <set_fg_color>
}
    80000ee6:	60a2                	ld	ra,8(sp)
    80000ee8:	6402                	ld	s0,0(sp)
    80000eea:	0141                	addi	sp,sp,16
    80000eec:	8082                	ret

0000000080000eee <color_green>:
void color_green(void) {
    80000eee:	1141                	addi	sp,sp,-16
    80000ef0:	e406                	sd	ra,8(sp)
    80000ef2:	e022                	sd	s0,0(sp)
    80000ef4:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    80000ef6:	02000513          	li	a0,32
    80000efa:	00000097          	auipc	ra,0x0
    80000efe:	f36080e7          	jalr	-202(ra) # 80000e30 <set_fg_color>
}
    80000f02:	60a2                	ld	ra,8(sp)
    80000f04:	6402                	ld	s0,0(sp)
    80000f06:	0141                	addi	sp,sp,16
    80000f08:	8082                	ret

0000000080000f0a <color_yellow>:
void color_yellow(void) {
    80000f0a:	1141                	addi	sp,sp,-16
    80000f0c:	e406                	sd	ra,8(sp)
    80000f0e:	e022                	sd	s0,0(sp)
    80000f10:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    80000f12:	02100513          	li	a0,33
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	f1a080e7          	jalr	-230(ra) # 80000e30 <set_fg_color>
}
    80000f1e:	60a2                	ld	ra,8(sp)
    80000f20:	6402                	ld	s0,0(sp)
    80000f22:	0141                	addi	sp,sp,16
    80000f24:	8082                	ret

0000000080000f26 <color_blue>:
void color_blue(void) {
    80000f26:	1141                	addi	sp,sp,-16
    80000f28:	e406                	sd	ra,8(sp)
    80000f2a:	e022                	sd	s0,0(sp)
    80000f2c:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    80000f2e:	02200513          	li	a0,34
    80000f32:	00000097          	auipc	ra,0x0
    80000f36:	efe080e7          	jalr	-258(ra) # 80000e30 <set_fg_color>
}
    80000f3a:	60a2                	ld	ra,8(sp)
    80000f3c:	6402                	ld	s0,0(sp)
    80000f3e:	0141                	addi	sp,sp,16
    80000f40:	8082                	ret

0000000080000f42 <color_purple>:
void color_purple(void) {
    80000f42:	1141                	addi	sp,sp,-16
    80000f44:	e406                	sd	ra,8(sp)
    80000f46:	e022                	sd	s0,0(sp)
    80000f48:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80000f4a:	02300513          	li	a0,35
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	ee2080e7          	jalr	-286(ra) # 80000e30 <set_fg_color>
}
    80000f56:	60a2                	ld	ra,8(sp)
    80000f58:	6402                	ld	s0,0(sp)
    80000f5a:	0141                	addi	sp,sp,16
    80000f5c:	8082                	ret

0000000080000f5e <color_cyan>:
void color_cyan(void) {
    80000f5e:	1141                	addi	sp,sp,-16
    80000f60:	e406                	sd	ra,8(sp)
    80000f62:	e022                	sd	s0,0(sp)
    80000f64:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    80000f66:	02400513          	li	a0,36
    80000f6a:	00000097          	auipc	ra,0x0
    80000f6e:	ec6080e7          	jalr	-314(ra) # 80000e30 <set_fg_color>
}
    80000f72:	60a2                	ld	ra,8(sp)
    80000f74:	6402                	ld	s0,0(sp)
    80000f76:	0141                	addi	sp,sp,16
    80000f78:	8082                	ret

0000000080000f7a <color_reverse>:
void color_reverse(void){
    80000f7a:	1141                	addi	sp,sp,-16
    80000f7c:	e406                	sd	ra,8(sp)
    80000f7e:	e022                	sd	s0,0(sp)
    80000f80:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    80000f82:	02500513          	li	a0,37
    80000f86:	00000097          	auipc	ra,0x0
    80000f8a:	eaa080e7          	jalr	-342(ra) # 80000e30 <set_fg_color>
}
    80000f8e:	60a2                	ld	ra,8(sp)
    80000f90:	6402                	ld	s0,0(sp)
    80000f92:	0141                	addi	sp,sp,16
    80000f94:	8082                	ret

0000000080000f96 <set_color>:
void set_color(int fg, int bg) {
    80000f96:	1101                	addi	sp,sp,-32
    80000f98:	ec06                	sd	ra,24(sp)
    80000f9a:	e822                	sd	s0,16(sp)
    80000f9c:	e426                	sd	s1,8(sp)
    80000f9e:	1000                	addi	s0,sp,32
    80000fa0:	84aa                	mv	s1,a0
	set_bg_color(bg);
    80000fa2:	852e                	mv	a0,a1
    80000fa4:	00000097          	auipc	ra,0x0
    80000fa8:	ede080e7          	jalr	-290(ra) # 80000e82 <set_bg_color>
	set_fg_color(fg);
    80000fac:	8526                	mv	a0,s1
    80000fae:	00000097          	auipc	ra,0x0
    80000fb2:	e82080e7          	jalr	-382(ra) # 80000e30 <set_fg_color>
}
    80000fb6:	60e2                	ld	ra,24(sp)
    80000fb8:	6442                	ld	s0,16(sp)
    80000fba:	64a2                	ld	s1,8(sp)
    80000fbc:	6105                	addi	sp,sp,32
    80000fbe:	8082                	ret

0000000080000fc0 <clear_line>:
void clear_line(){
    80000fc0:	1141                	addi	sp,sp,-16
    80000fc2:	e406                	sd	ra,8(sp)
    80000fc4:	e022                	sd	s0,0(sp)
    80000fc6:	0800                	addi	s0,sp,16
	uart_putc(c);
    80000fc8:	456d                	li	a0,27
    80000fca:	fffff097          	auipc	ra,0xfffff
    80000fce:	7e0080e7          	jalr	2016(ra) # 800007aa <uart_putc>
    80000fd2:	05b00513          	li	a0,91
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	7d4080e7          	jalr	2004(ra) # 800007aa <uart_putc>
    80000fde:	03200513          	li	a0,50
    80000fe2:	fffff097          	auipc	ra,0xfffff
    80000fe6:	7c8080e7          	jalr	1992(ra) # 800007aa <uart_putc>
    80000fea:	04b00513          	li	a0,75
    80000fee:	fffff097          	auipc	ra,0xfffff
    80000ff2:	7bc080e7          	jalr	1980(ra) # 800007aa <uart_putc>
	consputc('\033');
	consputc('[');
	consputc('2');
	consputc('K');
    80000ff6:	60a2                	ld	ra,8(sp)
    80000ff8:	6402                	ld	s0,0(sp)
    80000ffa:	0141                	addi	sp,sp,16
    80000ffc:	8082                	ret
	...
