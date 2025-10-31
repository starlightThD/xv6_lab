
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
    80200010:	07450513          	addi	a0,a0,116 # 8020a080 <kernel_pagetable>
        la a1,_bss_end
    80200014:	0000c597          	auipc	a1,0xc
    80200018:	43c58593          	addi	a1,a1,1084 # 8020c450 <_bss_end>

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
    8020002c:	08a080e7          	jalr	138(ra) # 802000b2 <start>

0000000080200030 <spin>:
spin:
        j spin # 无限循环，防止程序退出
    80200030:	a001                	j	80200030 <spin>

0000000080200032 <r_sstatus>:
    80200032:	1101                	addi	sp,sp,-32 # 80208fe0 <small_numbers+0x2bf0>
    80200034:	ec22                	sd	s0,24(sp)
    80200036:	1000                	addi	s0,sp,32
    80200038:	100027f3          	csrr	a5,sstatus
    8020003c:	fef43423          	sd	a5,-24(s0)
    80200040:	fe843783          	ld	a5,-24(s0)
    80200044:	853e                	mv	a0,a5
    80200046:	6462                	ld	s0,24(sp)
    80200048:	6105                	addi	sp,sp,32
    8020004a:	8082                	ret

000000008020004c <w_sstatus>:
    8020004c:	1101                	addi	sp,sp,-32
    8020004e:	ec22                	sd	s0,24(sp)
    80200050:	1000                	addi	s0,sp,32
    80200052:	fea43423          	sd	a0,-24(s0)
    80200056:	fe843783          	ld	a5,-24(s0)
    8020005a:	10079073          	csrw	sstatus,a5
    8020005e:	0001                	nop
    80200060:	6462                	ld	s0,24(sp)
    80200062:	6105                	addi	sp,sp,32
    80200064:	8082                	ret

0000000080200066 <intr_on>:
    80200066:	1141                	addi	sp,sp,-16
    80200068:	e406                	sd	ra,8(sp)
    8020006a:	e022                	sd	s0,0(sp)
    8020006c:	0800                	addi	s0,sp,16
    8020006e:	00000097          	auipc	ra,0x0
    80200072:	fc4080e7          	jalr	-60(ra) # 80200032 <r_sstatus>
    80200076:	87aa                	mv	a5,a0
    80200078:	0027e793          	ori	a5,a5,2
    8020007c:	853e                	mv	a0,a5
    8020007e:	00000097          	auipc	ra,0x0
    80200082:	fce080e7          	jalr	-50(ra) # 8020004c <w_sstatus>
    80200086:	0001                	nop
    80200088:	60a2                	ld	ra,8(sp)
    8020008a:	6402                	ld	s0,0(sp)
    8020008c:	0141                	addi	sp,sp,16
    8020008e:	8082                	ret

0000000080200090 <hello_world>:
void hello_world() {
    80200090:	1141                	addi	sp,sp,-16
    80200092:	e406                	sd	ra,8(sp)
    80200094:	e022                	sd	s0,0(sp)
    80200096:	0800                	addi	s0,sp,16
    printf("\nHello, World! This is a test process.\n\n");
    80200098:	00006517          	auipc	a0,0x6
    8020009c:	f6850513          	addi	a0,a0,-152 # 80206000 <etext>
    802000a0:	00001097          	auipc	ra,0x1
    802000a4:	a8e080e7          	jalr	-1394(ra) # 80200b2e <printf>
}
    802000a8:	0001                	nop
    802000aa:	60a2                	ld	ra,8(sp)
    802000ac:	6402                	ld	s0,0(sp)
    802000ae:	0141                	addi	sp,sp,16
    802000b0:	8082                	ret

00000000802000b2 <start>:
// start函数：内核的C语言入口
    802000b2:	1101                	addi	sp,sp,-32
    802000b4:	ec06                	sd	ra,24(sp)
    802000b6:	e822                	sd	s0,16(sp)
    802000b8:	1000                	addi	s0,sp,32
	// 内存页分配器
    802000ba:	00003097          	auipc	ra,0x3
    802000be:	9a8080e7          	jalr	-1624(ra) # 80202a62 <pmm_init>
	// 虚拟内存
    802000c2:	00002097          	auipc	ra,0x2
    802000c6:	2aa080e7          	jalr	682(ra) # 8020236c <kvminit>
	kvminit();
    802000ca:	00002097          	auipc	ra,0x2
    802000ce:	2f4080e7          	jalr	756(ra) # 802023be <kvminithart>
	// 中断和异常处理
    802000d2:	00003097          	auipc	ra,0x3
    802000d6:	f9a080e7          	jalr	-102(ra) # 8020306c <trap_init>
	trap_init();
    802000da:	00000097          	auipc	ra,0x0
    802000de:	4c0080e7          	jalr	1216(ra) # 8020059a <uart_init>
	uart_init();
    802000e2:	00000097          	auipc	ra,0x0
    802000e6:	f84080e7          	jalr	-124(ra) # 80200066 <intr_on>
    // 输出操作系统启动横幅
    802000ea:	00006517          	auipc	a0,0x6
    802000ee:	fce50513          	addi	a0,a0,-50 # 802060b8 <etext+0xb8>
    802000f2:	00001097          	auipc	ra,0x1
    802000f6:	a3c080e7          	jalr	-1476(ra) # 80200b2e <printf>
    printf("===============================================\n");
    802000fa:	00006517          	auipc	a0,0x6
    802000fe:	ff650513          	addi	a0,a0,-10 # 802060f0 <etext+0xf0>
    80200102:	00001097          	auipc	ra,0x1
    80200106:	a2c080e7          	jalr	-1492(ra) # 80200b2e <printf>
    printf("        RISC-V Operating System v1.0         \n");
    8020010a:	00006517          	auipc	a0,0x6
    8020010e:	01650513          	addi	a0,a0,22 # 80206120 <etext+0x120>
    80200112:	00001097          	auipc	ra,0x1
    80200116:	a1c080e7          	jalr	-1508(ra) # 80200b2e <printf>

    8020011a:	00004097          	auipc	ra,0x4
    8020011e:	ffc080e7          	jalr	-4(ra) # 80204116 <init_proc>
	init_proc(); // 初始化进程管理子系统
    80200122:	00000517          	auipc	a0,0x0
    80200126:	3d250513          	addi	a0,a0,978 # 802004f4 <kernel_main>
    8020012a:	00004097          	auipc	ra,0x4
    8020012e:	3e2080e7          	jalr	994(ra) # 8020450c <create_proc>
    80200132:	87aa                	mv	a5,a0
    80200134:	fef42623          	sw	a5,-20(s0)
	int main_pid = create_proc(kernel_main,0);
    80200138:	fec42783          	lw	a5,-20(s0)
    8020013c:	2781                	sext.w	a5,a5
    8020013e:	0007da63          	bgez	a5,80200152 <start+0xa0>
	if (main_pid < 0){
    80200142:	00006517          	auipc	a0,0x6
    80200146:	01650513          	addi	a0,a0,22 # 80206158 <etext+0x158>
    8020014a:	00001097          	auipc	ra,0x1
    8020014e:	2ec080e7          	jalr	748(ra) # 80201436 <panic>
	
    80200152:	00004097          	auipc	ra,0x4
    80200156:	54a080e7          	jalr	1354(ra) # 8020469c <schedule>
    // 防止返回保险
    8020015a:	00006517          	auipc	a0,0x6
    8020015e:	02650513          	addi	a0,a0,38 # 80206180 <etext+0x180>
    80200162:	00001097          	auipc	ra,0x1
    80200166:	2d4080e7          	jalr	724(ra) # 80201436 <panic>
    panic("START: main() exit unexpectedly!!!\n");
    8020016a:	0001                	nop
    8020016c:	60e2                	ld	ra,24(sp)
    8020016e:	6442                	ld	s0,16(sp)
    80200170:	6105                	addi	sp,sp,32
    80200172:	8082                	ret

0000000080200174 <console>:

    80200174:	7129                	addi	sp,sp,-320
    80200176:	fe06                	sd	ra,312(sp)
    80200178:	fa22                	sd	s0,304(sp)
    8020017a:	0280                	addi	s0,sp,320
    char input_buffer[256];
    8020017c:	fe042623          	sw	zero,-20(s0)

    80200180:	00006517          	auipc	a0,0x6
    80200184:	02850513          	addi	a0,a0,40 # 802061a8 <etext+0x1a8>
    80200188:	00001097          	auipc	ra,0x1
    8020018c:	9a6080e7          	jalr	-1626(ra) # 80200b2e <printf>
    printf("可用命令:\n");
    80200190:	fe042423          	sw	zero,-24(s0)
    80200194:	a0b9                	j	802001e2 <console+0x6e>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    80200196:	0000a697          	auipc	a3,0xa
    8020019a:	e6a68693          	addi	a3,a3,-406 # 8020a000 <command_table>
    8020019e:	fe842703          	lw	a4,-24(s0)
    802001a2:	87ba                	mv	a5,a4
    802001a4:	0786                	slli	a5,a5,0x1
    802001a6:	97ba                	add	a5,a5,a4
    802001a8:	078e                	slli	a5,a5,0x3
    802001aa:	97b6                	add	a5,a5,a3
    802001ac:	638c                	ld	a1,0(a5)
    802001ae:	0000a697          	auipc	a3,0xa
    802001b2:	e5268693          	addi	a3,a3,-430 # 8020a000 <command_table>
    802001b6:	fe842703          	lw	a4,-24(s0)
    802001ba:	87ba                	mv	a5,a4
    802001bc:	0786                	slli	a5,a5,0x1
    802001be:	97ba                	add	a5,a5,a4
    802001c0:	078e                	slli	a5,a5,0x3
    802001c2:	97b6                	add	a5,a5,a3
    802001c4:	6b9c                	ld	a5,16(a5)
    802001c6:	863e                	mv	a2,a5
    802001c8:	00006517          	auipc	a0,0x6
    802001cc:	ff050513          	addi	a0,a0,-16 # 802061b8 <etext+0x1b8>
    802001d0:	00001097          	auipc	ra,0x1
    802001d4:	95e080e7          	jalr	-1698(ra) # 80200b2e <printf>
    printf("可用命令:\n");
    802001d8:	fe842783          	lw	a5,-24(s0)
    802001dc:	2785                	addiw	a5,a5,1
    802001de:	fef42423          	sw	a5,-24(s0)
    802001e2:	fe842783          	lw	a5,-24(s0)
    802001e6:	873e                	mv	a4,a5
    802001e8:	478d                	li	a5,3
    802001ea:	fae7f6e3          	bgeu	a5,a4,80200196 <console+0x22>
    }
    802001ee:	00006517          	auipc	a0,0x6
    802001f2:	fda50513          	addi	a0,a0,-38 # 802061c8 <etext+0x1c8>
    802001f6:	00001097          	auipc	ra,0x1
    802001fa:	938080e7          	jalr	-1736(ra) # 80200b2e <printf>
    printf("  help          - 显示此帮助\n");
    802001fe:	00006517          	auipc	a0,0x6
    80200202:	ff250513          	addi	a0,a0,-14 # 802061f0 <etext+0x1f0>
    80200206:	00001097          	auipc	ra,0x1
    8020020a:	928080e7          	jalr	-1752(ra) # 80200b2e <printf>
    printf("  exit          - 退出控制台\n");
    8020020e:	00006517          	auipc	a0,0x6
    80200212:	00a50513          	addi	a0,a0,10 # 80206218 <etext+0x218>
    80200216:	00001097          	auipc	ra,0x1
    8020021a:	918080e7          	jalr	-1768(ra) # 80200b2e <printf>

    8020021e:	ac4d                	j	802004d0 <console+0x35c>
    while (!exit_requested) {
    80200220:	00006517          	auipc	a0,0x6
    80200224:	02050513          	addi	a0,a0,32 # 80206240 <etext+0x240>
    80200228:	00001097          	auipc	ra,0x1
    8020022c:	906080e7          	jalr	-1786(ra) # 80200b2e <printf>
        printf("Console >>> ");
    80200230:	ed040793          	addi	a5,s0,-304
    80200234:	10000593          	li	a1,256
    80200238:	853e                	mv	a0,a5
    8020023a:	00000097          	auipc	ra,0x0
    8020023e:	5ee080e7          	jalr	1518(ra) # 80200828 <readline>

    80200242:	ed040793          	addi	a5,s0,-304
    80200246:	00006597          	auipc	a1,0x6
    8020024a:	00a58593          	addi	a1,a1,10 # 80206250 <etext+0x250>
    8020024e:	853e                	mv	a0,a5
    80200250:	00005097          	auipc	ra,0x5
    80200254:	134080e7          	jalr	308(ra) # 80205384 <strcmp>
    80200258:	87aa                	mv	a5,a0
    8020025a:	e789                	bnez	a5,80200264 <console+0xf0>
        if (strcmp(input_buffer, "exit") == 0) {
    8020025c:	4785                	li	a5,1
    8020025e:	fef42623          	sw	a5,-20(s0)
    80200262:	a4bd                	j	802004d0 <console+0x35c>
            exit_requested = 1;
    80200264:	ed040793          	addi	a5,s0,-304
    80200268:	00006597          	auipc	a1,0x6
    8020026c:	ff058593          	addi	a1,a1,-16 # 80206258 <etext+0x258>
    80200270:	853e                	mv	a0,a5
    80200272:	00005097          	auipc	ra,0x5
    80200276:	112080e7          	jalr	274(ra) # 80205384 <strcmp>
    8020027a:	87aa                	mv	a5,a0
    8020027c:	e3cd                	bnez	a5,8020031e <console+0x1aa>
        } else if (strcmp(input_buffer, "help") == 0) {
    8020027e:	00006517          	auipc	a0,0x6
    80200282:	f2a50513          	addi	a0,a0,-214 # 802061a8 <etext+0x1a8>
    80200286:	00001097          	auipc	ra,0x1
    8020028a:	8a8080e7          	jalr	-1880(ra) # 80200b2e <printf>
            printf("可用命令:\n");
    8020028e:	fe042223          	sw	zero,-28(s0)
    80200292:	a0b9                	j	802002e0 <console+0x16c>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    80200294:	0000a697          	auipc	a3,0xa
    80200298:	d6c68693          	addi	a3,a3,-660 # 8020a000 <command_table>
    8020029c:	fe442703          	lw	a4,-28(s0)
    802002a0:	87ba                	mv	a5,a4
    802002a2:	0786                	slli	a5,a5,0x1
    802002a4:	97ba                	add	a5,a5,a4
    802002a6:	078e                	slli	a5,a5,0x3
    802002a8:	97b6                	add	a5,a5,a3
    802002aa:	638c                	ld	a1,0(a5)
    802002ac:	0000a697          	auipc	a3,0xa
    802002b0:	d5468693          	addi	a3,a3,-684 # 8020a000 <command_table>
    802002b4:	fe442703          	lw	a4,-28(s0)
    802002b8:	87ba                	mv	a5,a4
    802002ba:	0786                	slli	a5,a5,0x1
    802002bc:	97ba                	add	a5,a5,a4
    802002be:	078e                	slli	a5,a5,0x3
    802002c0:	97b6                	add	a5,a5,a3
    802002c2:	6b9c                	ld	a5,16(a5)
    802002c4:	863e                	mv	a2,a5
    802002c6:	00006517          	auipc	a0,0x6
    802002ca:	ef250513          	addi	a0,a0,-270 # 802061b8 <etext+0x1b8>
    802002ce:	00001097          	auipc	ra,0x1
    802002d2:	860080e7          	jalr	-1952(ra) # 80200b2e <printf>
            printf("可用命令:\n");
    802002d6:	fe442783          	lw	a5,-28(s0)
    802002da:	2785                	addiw	a5,a5,1
    802002dc:	fef42223          	sw	a5,-28(s0)
    802002e0:	fe442783          	lw	a5,-28(s0)
    802002e4:	873e                	mv	a4,a5
    802002e6:	478d                	li	a5,3
    802002e8:	fae7f6e3          	bgeu	a5,a4,80200294 <console+0x120>
            }
    802002ec:	00006517          	auipc	a0,0x6
    802002f0:	edc50513          	addi	a0,a0,-292 # 802061c8 <etext+0x1c8>
    802002f4:	00001097          	auipc	ra,0x1
    802002f8:	83a080e7          	jalr	-1990(ra) # 80200b2e <printf>
            printf("  help          - 显示此帮助\n");
    802002fc:	00006517          	auipc	a0,0x6
    80200300:	ef450513          	addi	a0,a0,-268 # 802061f0 <etext+0x1f0>
    80200304:	00001097          	auipc	ra,0x1
    80200308:	82a080e7          	jalr	-2006(ra) # 80200b2e <printf>
            printf("  exit          - 退出控制台\n");
    8020030c:	00006517          	auipc	a0,0x6
    80200310:	f0c50513          	addi	a0,a0,-244 # 80206218 <etext+0x218>
    80200314:	00001097          	auipc	ra,0x1
    80200318:	81a080e7          	jalr	-2022(ra) # 80200b2e <printf>
    8020031c:	aa55                	j	802004d0 <console+0x35c>
            printf("  ps            - 显示进程状态\n");
    8020031e:	ed040793          	addi	a5,s0,-304
    80200322:	00006597          	auipc	a1,0x6
    80200326:	f3e58593          	addi	a1,a1,-194 # 80206260 <etext+0x260>
    8020032a:	853e                	mv	a0,a5
    8020032c:	00005097          	auipc	ra,0x5
    80200330:	058080e7          	jalr	88(ra) # 80205384 <strcmp>
    80200334:	87aa                	mv	a5,a0
    80200336:	e791                	bnez	a5,80200342 <console+0x1ce>
        } else if (strcmp(input_buffer, "ps") == 0) {
    80200338:	00005097          	auipc	ra,0x5
    8020033c:	8b0080e7          	jalr	-1872(ra) # 80204be8 <print_proc_table>
    80200340:	aa41                	j	802004d0 <console+0x35c>
        } else {
    80200342:	fe042023          	sw	zero,-32(s0)
            int found = 0;
    80200346:	fc042e23          	sw	zero,-36(s0)
    8020034a:	aa99                	j	802004a0 <console+0x32c>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    8020034c:	0000a697          	auipc	a3,0xa
    80200350:	cb468693          	addi	a3,a3,-844 # 8020a000 <command_table>
    80200354:	fdc42703          	lw	a4,-36(s0)
    80200358:	87ba                	mv	a5,a4
    8020035a:	0786                	slli	a5,a5,0x1
    8020035c:	97ba                	add	a5,a5,a4
    8020035e:	078e                	slli	a5,a5,0x3
    80200360:	97b6                	add	a5,a5,a3
    80200362:	6398                	ld	a4,0(a5)
    80200364:	ed040793          	addi	a5,s0,-304
    80200368:	85ba                	mv	a1,a4
    8020036a:	853e                	mv	a0,a5
    8020036c:	00005097          	auipc	ra,0x5
    80200370:	018080e7          	jalr	24(ra) # 80205384 <strcmp>
    80200374:	87aa                	mv	a5,a0
    80200376:	12079063          	bnez	a5,80200496 <console+0x322>
                if (strcmp(input_buffer, command_table[i].name) == 0) {
    8020037a:	0000a697          	auipc	a3,0xa
    8020037e:	c8668693          	addi	a3,a3,-890 # 8020a000 <command_table>
    80200382:	fdc42703          	lw	a4,-36(s0)
    80200386:	87ba                	mv	a5,a4
    80200388:	0786                	slli	a5,a5,0x1
    8020038a:	97ba                	add	a5,a5,a4
    8020038c:	078e                	slli	a5,a5,0x3
    8020038e:	97b6                	add	a5,a5,a3
    80200390:	679c                	ld	a5,8(a5)
    80200392:	853e                	mv	a0,a5
    80200394:	00004097          	auipc	ra,0x4
    80200398:	178080e7          	jalr	376(ra) # 8020450c <create_proc>
    8020039c:	87aa                	mv	a5,a0
    8020039e:	fcf42c23          	sw	a5,-40(s0)
                    int pid = create_proc(command_table[i].func,0);
    802003a2:	fd842783          	lw	a5,-40(s0)
    802003a6:	2781                	sext.w	a5,a5
    802003a8:	0207d863          	bgez	a5,802003d8 <console+0x264>
                    if (pid < 0) {
    802003ac:	0000a697          	auipc	a3,0xa
    802003b0:	c5468693          	addi	a3,a3,-940 # 8020a000 <command_table>
    802003b4:	fdc42703          	lw	a4,-36(s0)
    802003b8:	87ba                	mv	a5,a4
    802003ba:	0786                	slli	a5,a5,0x1
    802003bc:	97ba                	add	a5,a5,a4
    802003be:	078e                	slli	a5,a5,0x3
    802003c0:	97b6                	add	a5,a5,a3
    802003c2:	639c                	ld	a5,0(a5)
    802003c4:	85be                	mv	a1,a5
    802003c6:	00006517          	auipc	a0,0x6
    802003ca:	ea250513          	addi	a0,a0,-350 # 80206268 <etext+0x268>
    802003ce:	00000097          	auipc	ra,0x0
    802003d2:	760080e7          	jalr	1888(ra) # 80200b2e <printf>
    802003d6:	a865                	j	8020048e <console+0x31a>
                    } else {
    802003d8:	0000a697          	auipc	a3,0xa
    802003dc:	c2868693          	addi	a3,a3,-984 # 8020a000 <command_table>
    802003e0:	fdc42703          	lw	a4,-36(s0)
    802003e4:	87ba                	mv	a5,a4
    802003e6:	0786                	slli	a5,a5,0x1
    802003e8:	97ba                	add	a5,a5,a4
    802003ea:	078e                	slli	a5,a5,0x3
    802003ec:	97b6                	add	a5,a5,a3
    802003ee:	639c                	ld	a5,0(a5)
    802003f0:	fd842703          	lw	a4,-40(s0)
    802003f4:	863a                	mv	a2,a4
    802003f6:	85be                	mv	a1,a5
    802003f8:	00006517          	auipc	a0,0x6
    802003fc:	e8850513          	addi	a0,a0,-376 # 80206280 <etext+0x280>
    80200400:	00000097          	auipc	ra,0x0
    80200404:	72e080e7          	jalr	1838(ra) # 80200b2e <printf>
                        int status;
    80200408:	ecc40793          	addi	a5,s0,-308
    8020040c:	853e                	mv	a0,a5
    8020040e:	00004097          	auipc	ra,0x4
    80200412:	1b2080e7          	jalr	434(ra) # 802045c0 <wait_proc>
    80200416:	87aa                	mv	a5,a0
    80200418:	fcf42a23          	sw	a5,-44(s0)
                        int waited_pid = wait_proc(&status);
    8020041c:	fd442783          	lw	a5,-44(s0)
    80200420:	873e                	mv	a4,a5
    80200422:	fd842783          	lw	a5,-40(s0)
    80200426:	2701                	sext.w	a4,a4
    80200428:	2781                	sext.w	a5,a5
    8020042a:	02f71d63          	bne	a4,a5,80200464 <console+0x2f0>
                        if (waited_pid == pid) {
    8020042e:	0000a697          	auipc	a3,0xa
    80200432:	bd268693          	addi	a3,a3,-1070 # 8020a000 <command_table>
    80200436:	fdc42703          	lw	a4,-36(s0)
    8020043a:	87ba                	mv	a5,a4
    8020043c:	0786                	slli	a5,a5,0x1
    8020043e:	97ba                	add	a5,a5,a4
    80200440:	078e                	slli	a5,a5,0x3
    80200442:	97b6                	add	a5,a5,a3
    80200444:	639c                	ld	a5,0(a5)
    80200446:	ecc42683          	lw	a3,-308(s0)
    8020044a:	fd842703          	lw	a4,-40(s0)
    8020044e:	863a                	mv	a2,a4
    80200450:	85be                	mv	a1,a5
    80200452:	00006517          	auipc	a0,0x6
    80200456:	e4e50513          	addi	a0,a0,-434 # 802062a0 <etext+0x2a0>
    8020045a:	00000097          	auipc	ra,0x0
    8020045e:	6d4080e7          	jalr	1748(ra) # 80200b2e <printf>
    80200462:	a035                	j	8020048e <console+0x31a>
                        } else {
    80200464:	0000a697          	auipc	a3,0xa
    80200468:	b9c68693          	addi	a3,a3,-1124 # 8020a000 <command_table>
    8020046c:	fdc42703          	lw	a4,-36(s0)
    80200470:	87ba                	mv	a5,a4
    80200472:	0786                	slli	a5,a5,0x1
    80200474:	97ba                	add	a5,a5,a4
    80200476:	078e                	slli	a5,a5,0x3
    80200478:	97b6                	add	a5,a5,a3
    8020047a:	639c                	ld	a5,0(a5)
    8020047c:	85be                	mv	a1,a5
    8020047e:	00006517          	auipc	a0,0x6
    80200482:	e5250513          	addi	a0,a0,-430 # 802062d0 <etext+0x2d0>
    80200486:	00000097          	auipc	ra,0x0
    8020048a:	6a8080e7          	jalr	1704(ra) # 80200b2e <printf>
                    }
    8020048e:	4785                	li	a5,1
    80200490:	fef42023          	sw	a5,-32(s0)
                    found = 1;
    80200494:	a821                	j	802004ac <console+0x338>
            int found = 0;
    80200496:	fdc42783          	lw	a5,-36(s0)
    8020049a:	2785                	addiw	a5,a5,1
    8020049c:	fcf42e23          	sw	a5,-36(s0)
    802004a0:	fdc42783          	lw	a5,-36(s0)
    802004a4:	873e                	mv	a4,a5
    802004a6:	478d                	li	a5,3
    802004a8:	eae7f2e3          	bgeu	a5,a4,8020034c <console+0x1d8>
            }
    802004ac:	fe042783          	lw	a5,-32(s0)
    802004b0:	2781                	sext.w	a5,a5
    802004b2:	ef99                	bnez	a5,802004d0 <console+0x35c>
    802004b4:	ed044783          	lbu	a5,-304(s0)
    802004b8:	cf81                	beqz	a5,802004d0 <console+0x35c>
            if (!found && input_buffer[0] != '\0') {
    802004ba:	ed040793          	addi	a5,s0,-304
    802004be:	85be                	mv	a1,a5
    802004c0:	00006517          	auipc	a0,0x6
    802004c4:	e3050513          	addi	a0,a0,-464 # 802062f0 <etext+0x2f0>
    802004c8:	00000097          	auipc	ra,0x0
    802004cc:	666080e7          	jalr	1638(ra) # 80200b2e <printf>

    802004d0:	fec42783          	lw	a5,-20(s0)
    802004d4:	2781                	sext.w	a5,a5
    802004d6:	d40785e3          	beqz	a5,80200220 <console+0xac>
    }
    802004da:	00006517          	auipc	a0,0x6
    802004de:	e2e50513          	addi	a0,a0,-466 # 80206308 <etext+0x308>
    802004e2:	00000097          	auipc	ra,0x0
    802004e6:	64c080e7          	jalr	1612(ra) # 80200b2e <printf>
    printf("控制台进程退出\n");
    802004ea:	0001                	nop
    return;
    802004ec:	70f2                	ld	ra,312(sp)
    802004ee:	7452                	ld	s0,304(sp)
    802004f0:	6131                	addi	sp,sp,320
    802004f2:	8082                	ret

00000000802004f4 <kernel_main>:
}
    802004f4:	1101                	addi	sp,sp,-32
    802004f6:	ec06                	sd	ra,24(sp)
    802004f8:	e822                	sd	s0,16(sp)
    802004fa:	1000                	addi	s0,sp,32
	// 内核主函数
    802004fc:	00001097          	auipc	ra,0x1
    80200500:	a2a080e7          	jalr	-1494(ra) # 80200f26 <clear_screen>
	clear_screen();
    80200504:	00000517          	auipc	a0,0x0
    80200508:	c7050513          	addi	a0,a0,-912 # 80200174 <console>
    8020050c:	00004097          	auipc	ra,0x4
    80200510:	000080e7          	jalr	ra # 8020450c <create_proc>
    80200514:	87aa                	mv	a5,a0
    80200516:	fef42623          	sw	a5,-20(s0)
	int console_pid = create_proc(console,0);
    8020051a:	fec42783          	lw	a5,-20(s0)
    8020051e:	2781                	sext.w	a5,a5
    80200520:	0007db63          	bgez	a5,80200536 <kernel_main+0x42>
	if (console_pid < 0){
    80200524:	00006517          	auipc	a0,0x6
    80200528:	dfc50513          	addi	a0,a0,-516 # 80206320 <etext+0x320>
    8020052c:	00001097          	auipc	ra,0x1
    80200530:	f0a080e7          	jalr	-246(ra) # 80201436 <panic>
    80200534:	a821                	j	8020054c <kernel_main+0x58>
	}else{
    80200536:	fec42783          	lw	a5,-20(s0)
    8020053a:	85be                	mv	a1,a5
    8020053c:	00006517          	auipc	a0,0x6
    80200540:	e1450513          	addi	a0,a0,-492 # 80206350 <etext+0x350>
    80200544:	00000097          	auipc	ra,0x0
    80200548:	5ea080e7          	jalr	1514(ra) # 80200b2e <printf>
	int status;
    8020054c:	fe440793          	addi	a5,s0,-28
    80200550:	853e                	mv	a0,a5
    80200552:	00004097          	auipc	ra,0x4
    80200556:	06e080e7          	jalr	110(ra) # 802045c0 <wait_proc>
    8020055a:	87aa                	mv	a5,a0
    8020055c:	fef42423          	sw	a5,-24(s0)
	int pid = wait_proc(&status);
    80200560:	fe842783          	lw	a5,-24(s0)
    80200564:	873e                	mv	a4,a5
    80200566:	fec42783          	lw	a5,-20(s0)
    8020056a:	2701                	sext.w	a4,a4
    8020056c:	2781                	sext.w	a5,a5
    8020056e:	02f70163          	beq	a4,a5,80200590 <kernel_main+0x9c>
	if(pid != console_pid){
    80200572:	fe442703          	lw	a4,-28(s0)
    80200576:	fe842783          	lw	a5,-24(s0)
    8020057a:	863a                	mv	a2,a4
    8020057c:	85be                	mv	a1,a5
    8020057e:	00006517          	auipc	a0,0x6
    80200582:	e0a50513          	addi	a0,a0,-502 # 80206388 <etext+0x388>
    80200586:	00000097          	auipc	ra,0x0
    8020058a:	5a8080e7          	jalr	1448(ra) # 80200b2e <printf>
	}
    8020058e:	0001                	nop
    80200590:	0001                	nop
	return;
    80200592:	60e2                	ld	ra,24(sp)
    80200594:	6442                	ld	s0,16(sp)
    80200596:	6105                	addi	sp,sp,32
    80200598:	8082                	ret

000000008020059a <uart_init>:
#include "defs.h"
#define LINE_BUF_SIZE 128
struct uart_input_buf_t uart_input_buf;
// UART初始化函数
    8020059a:	1141                	addi	sp,sp,-16
    8020059c:	e406                	sd	ra,8(sp)
    8020059e:	e022                	sd	s0,0(sp)
    802005a0:	0800                	addi	s0,sp,16
void uart_init(void) {

    802005a2:	100007b7          	lui	a5,0x10000
    802005a6:	0785                	addi	a5,a5,1 # 10000001 <userret+0xfffff65>
    802005a8:	00078023          	sb	zero,0(a5)
    WriteReg(IER, 0x00);
    802005ac:	100007b7          	lui	a5,0x10000
    802005b0:	0789                	addi	a5,a5,2 # 10000002 <userret+0xfffff66>
    802005b2:	471d                	li	a4,7
    802005b4:	00e78023          	sb	a4,0(a5)
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    802005b8:	100007b7          	lui	a5,0x10000
    802005bc:	0785                	addi	a5,a5,1 # 10000001 <userret+0xfffff65>
    802005be:	4705                	li	a4,1
    802005c0:	00e78023          	sb	a4,0(a5)
    WriteReg(IER, IER_RX_ENABLE);
    802005c4:	00000597          	auipc	a1,0x0
    802005c8:	12858593          	addi	a1,a1,296 # 802006ec <uart_intr>
    802005cc:	4529                	li	a0,10
    802005ce:	00003097          	auipc	ra,0x3
    802005d2:	91a080e7          	jalr	-1766(ra) # 80202ee8 <register_interrupt>
    register_interrupt(UART0_IRQ, uart_intr);//注册键盘输入的中断处理函数
    802005d6:	4529                	li	a0,10
    802005d8:	00003097          	auipc	ra,0x3
    802005dc:	99a080e7          	jalr	-1638(ra) # 80202f72 <enable_interrupts>
    enable_interrupts(UART0_IRQ);
    802005e0:	00006517          	auipc	a0,0x6
    802005e4:	de850513          	addi	a0,a0,-536 # 802063c8 <etext+0x3c8>
    802005e8:	00000097          	auipc	ra,0x0
    802005ec:	546080e7          	jalr	1350(ra) # 80200b2e <printf>
    printf("UART initialized with input support\n");
    802005f0:	0001                	nop
    802005f2:	60a2                	ld	ra,8(sp)
    802005f4:	6402                	ld	s0,0(sp)
    802005f6:	0141                	addi	sp,sp,16
    802005f8:	8082                	ret

00000000802005fa <uart_putc>:
}

// 发送单个字符
    802005fa:	1101                	addi	sp,sp,-32
    802005fc:	ec22                	sd	s0,24(sp)
    802005fe:	1000                	addi	s0,sp,32
    80200600:	87aa                	mv	a5,a0
    80200602:	fef407a3          	sb	a5,-17(s0)
void uart_putc(char c) {
    // 等待发送缓冲区空闲
    80200606:	0001                	nop
    80200608:	100007b7          	lui	a5,0x10000
    8020060c:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    8020060e:	0007c783          	lbu	a5,0(a5)
    80200612:	0ff7f793          	zext.b	a5,a5
    80200616:	2781                	sext.w	a5,a5
    80200618:	0207f793          	andi	a5,a5,32
    8020061c:	2781                	sext.w	a5,a5
    8020061e:	d7ed                	beqz	a5,80200608 <uart_putc+0xe>
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80200620:	100007b7          	lui	a5,0x10000
    80200624:	fef44703          	lbu	a4,-17(s0)
    80200628:	00e78023          	sb	a4,0(a5) # 10000000 <userret+0xfffff64>
    WriteReg(THR, c);
    8020062c:	0001                	nop
    8020062e:	6462                	ld	s0,24(sp)
    80200630:	6105                	addi	sp,sp,32
    80200632:	8082                	ret

0000000080200634 <uart_puts>:
}

    80200634:	7179                	addi	sp,sp,-48
    80200636:	f422                	sd	s0,40(sp)
    80200638:	1800                	addi	s0,sp,48
    8020063a:	fca43c23          	sd	a0,-40(s0)
void uart_puts(char *s) {
    8020063e:	fd843783          	ld	a5,-40(s0)
    80200642:	c7b5                	beqz	a5,802006ae <uart_puts+0x7a>
    if (!s) return;
    
    80200644:	a8b9                	j	802006a2 <uart_puts+0x6e>
    while (*s) {
    80200646:	0001                	nop
    80200648:	100007b7          	lui	a5,0x10000
    8020064c:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    8020064e:	0007c783          	lbu	a5,0(a5)
    80200652:	0ff7f793          	zext.b	a5,a5
    80200656:	2781                	sext.w	a5,a5
    80200658:	0207f793          	andi	a5,a5,32
    8020065c:	2781                	sext.w	a5,a5
    8020065e:	d7ed                	beqz	a5,80200648 <uart_puts+0x14>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80200660:	fe042623          	sw	zero,-20(s0)
        int sent_count = 0;
    80200664:	a01d                	j	8020068a <uart_puts+0x56>
        while (*s && sent_count < 4) { 
    80200666:	100007b7          	lui	a5,0x10000
    8020066a:	fd843703          	ld	a4,-40(s0)
    8020066e:	00074703          	lbu	a4,0(a4)
    80200672:	00e78023          	sb	a4,0(a5) # 10000000 <userret+0xfffff64>
            WriteReg(THR, *s);
    80200676:	fd843783          	ld	a5,-40(s0)
    8020067a:	0785                	addi	a5,a5,1
    8020067c:	fcf43c23          	sd	a5,-40(s0)
            s++;
    80200680:	fec42783          	lw	a5,-20(s0)
    80200684:	2785                	addiw	a5,a5,1
    80200686:	fef42623          	sw	a5,-20(s0)
        int sent_count = 0;
    8020068a:	fd843783          	ld	a5,-40(s0)
    8020068e:	0007c783          	lbu	a5,0(a5)
    80200692:	cb81                	beqz	a5,802006a2 <uart_puts+0x6e>
    80200694:	fec42783          	lw	a5,-20(s0)
    80200698:	0007871b          	sext.w	a4,a5
    8020069c:	478d                	li	a5,3
    8020069e:	fce7d4e3          	bge	a5,a4,80200666 <uart_puts+0x32>
    
    802006a2:	fd843783          	ld	a5,-40(s0)
    802006a6:	0007c783          	lbu	a5,0(a5)
    802006aa:	ffd1                	bnez	a5,80200646 <uart_puts+0x12>
    802006ac:	a011                	j	802006b0 <uart_puts+0x7c>
void uart_puts(char *s) {
    802006ae:	0001                	nop
            sent_count++;
        }
    }
    802006b0:	7422                	ld	s0,40(sp)
    802006b2:	6145                	addi	sp,sp,48
    802006b4:	8082                	ret

00000000802006b6 <uart_getc>:
}

    802006b6:	1141                	addi	sp,sp,-16
    802006b8:	e422                	sd	s0,8(sp)
    802006ba:	0800                	addi	s0,sp,16
int uart_getc(void) {
    802006bc:	100007b7          	lui	a5,0x10000
    802006c0:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    802006c2:	0007c783          	lbu	a5,0(a5)
    802006c6:	0ff7f793          	zext.b	a5,a5
    802006ca:	2781                	sext.w	a5,a5
    802006cc:	8b85                	andi	a5,a5,1
    802006ce:	2781                	sext.w	a5,a5
    802006d0:	e399                	bnez	a5,802006d6 <uart_getc+0x20>
    if ((ReadReg(LSR) & LSR_RX_READY) == 0)
    802006d2:	57fd                	li	a5,-1
    802006d4:	a801                	j	802006e4 <uart_getc+0x2e>
        return -1; 
    802006d6:	100007b7          	lui	a5,0x10000
    802006da:	0007c783          	lbu	a5,0(a5) # 10000000 <userret+0xfffff64>
    802006de:	0ff7f793          	zext.b	a5,a5
    802006e2:	2781                	sext.w	a5,a5
    return ReadReg(RHR); 
    802006e4:	853e                	mv	a0,a5
    802006e6:	6422                	ld	s0,8(sp)
    802006e8:	0141                	addi	sp,sp,16
    802006ea:	8082                	ret

00000000802006ec <uart_intr>:
}

void uart_intr(void) {
    802006ec:	1101                	addi	sp,sp,-32
    802006ee:	ec06                	sd	ra,24(sp)
    802006f0:	e822                	sd	s0,16(sp)
    802006f2:	1000                	addi	s0,sp,32
    static char linebuf[LINE_BUF_SIZE];
    802006f4:	a869                	j	8020078e <uart_intr+0xa2>
    static int line_len = 0;
    802006f6:	100007b7          	lui	a5,0x10000
    802006fa:	0007c783          	lbu	a5,0(a5) # 10000000 <userret+0xfffff64>
    802006fe:	fef407a3          	sb	a5,-17(s0)

    while (ReadReg(LSR) & LSR_RX_READY) {
        char c = ReadReg(RHR);
    80200702:	fef44783          	lbu	a5,-17(s0)
    80200706:	853e                	mv	a0,a5
    80200708:	00000097          	auipc	ra,0x0
    8020070c:	ef2080e7          	jalr	-270(ra) # 802005fa <uart_putc>

        if (c == '\r' || c == '\n') {
            uart_putc('\n');
    80200710:	fef44783          	lbu	a5,-17(s0)
    80200714:	0ff7f713          	zext.b	a4,a5
    80200718:	47b5                	li	a5,13
    8020071a:	00f71a63          	bne	a4,a5,8020072e <uart_intr+0x42>
            // 将编辑好的整行写入全局缓冲区
    8020071e:	4529                	li	a0,10
    80200720:	00000097          	auipc	ra,0x0
    80200724:	eda080e7          	jalr	-294(ra) # 802005fa <uart_putc>
            for (int i = 0; i < line_len; i++) {
    80200728:	47a9                	li	a5,10
    8020072a:	fef407a3          	sb	a5,-17(s0)
                int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
                if (next != uart_input_buf.r) {
                    uart_input_buf.buf[uart_input_buf.w] = linebuf[i];
                    uart_input_buf.w = next;
    8020072e:	0000a797          	auipc	a5,0xa
    80200732:	97278793          	addi	a5,a5,-1678 # 8020a0a0 <uart_input_buf>
    80200736:	0847a783          	lw	a5,132(a5)
    8020073a:	2785                	addiw	a5,a5,1
    8020073c:	2781                	sext.w	a5,a5
    8020073e:	2781                	sext.w	a5,a5
    80200740:	07f7f793          	andi	a5,a5,127
    80200744:	fef42423          	sw	a5,-24(s0)
                }
    80200748:	0000a797          	auipc	a5,0xa
    8020074c:	95878793          	addi	a5,a5,-1704 # 8020a0a0 <uart_input_buf>
    80200750:	0807a703          	lw	a4,128(a5)
    80200754:	fe842783          	lw	a5,-24(s0)
    80200758:	02f70b63          	beq	a4,a5,8020078e <uart_intr+0xa2>
            }
            // 写入换行符
    8020075c:	0000a797          	auipc	a5,0xa
    80200760:	94478793          	addi	a5,a5,-1724 # 8020a0a0 <uart_input_buf>
    80200764:	0847a783          	lw	a5,132(a5)
    80200768:	0000a717          	auipc	a4,0xa
    8020076c:	93870713          	addi	a4,a4,-1736 # 8020a0a0 <uart_input_buf>
    80200770:	1782                	slli	a5,a5,0x20
    80200772:	9381                	srli	a5,a5,0x20
    80200774:	97ba                	add	a5,a5,a4
    80200776:	fef44703          	lbu	a4,-17(s0)
    8020077a:	00e78023          	sb	a4,0(a5)
            int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    8020077e:	fe842703          	lw	a4,-24(s0)
    80200782:	0000a797          	auipc	a5,0xa
    80200786:	91e78793          	addi	a5,a5,-1762 # 8020a0a0 <uart_input_buf>
    8020078a:	08e7a223          	sw	a4,132(a5)
    static char linebuf[LINE_BUF_SIZE];
    8020078e:	100007b7          	lui	a5,0x10000
    80200792:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    80200794:	0007c783          	lbu	a5,0(a5)
    80200798:	0ff7f793          	zext.b	a5,a5
    8020079c:	2781                	sext.w	a5,a5
    8020079e:	8b85                	andi	a5,a5,1
    802007a0:	2781                	sext.w	a5,a5
    802007a2:	fbb1                	bnez	a5,802006f6 <uart_intr+0xa>
            if (next != uart_input_buf.r) {
                uart_input_buf.buf[uart_input_buf.w] = '\n';
                uart_input_buf.w = next;
    802007a4:	0001                	nop
    802007a6:	0001                	nop
    802007a8:	60e2                	ld	ra,24(sp)
    802007aa:	6442                	ld	s0,16(sp)
    802007ac:	6105                	addi	sp,sp,32
    802007ae:	8082                	ret

00000000802007b0 <uart_getc_blocking>:
            }
            line_len = 0;
    802007b0:	1101                	addi	sp,sp,-32
    802007b2:	ec22                	sd	s0,24(sp)
    802007b4:	1000                	addi	s0,sp,32
        } else if (c == 0x7f || c == 0x08) { // 退格
            if (line_len > 0) {
    802007b6:	a011                	j	802007ba <uart_getc_blocking+0xa>
                uart_putc('\b');
                uart_putc(' ');
                uart_putc('\b');
    802007b8:	0001                	nop
            if (line_len > 0) {
    802007ba:	0000a797          	auipc	a5,0xa
    802007be:	8e678793          	addi	a5,a5,-1818 # 8020a0a0 <uart_input_buf>
    802007c2:	0807a703          	lw	a4,128(a5)
    802007c6:	0000a797          	auipc	a5,0xa
    802007ca:	8da78793          	addi	a5,a5,-1830 # 8020a0a0 <uart_input_buf>
    802007ce:	0847a783          	lw	a5,132(a5)
    802007d2:	fef703e3          	beq	a4,a5,802007b8 <uart_getc_blocking+0x8>
                line_len--;
            }
        } else if (line_len < LINE_BUF_SIZE - 1) {
            uart_putc(c);
    802007d6:	0000a797          	auipc	a5,0xa
    802007da:	8ca78793          	addi	a5,a5,-1846 # 8020a0a0 <uart_input_buf>
    802007de:	0807a783          	lw	a5,128(a5)
    802007e2:	0000a717          	auipc	a4,0xa
    802007e6:	8be70713          	addi	a4,a4,-1858 # 8020a0a0 <uart_input_buf>
    802007ea:	1782                	slli	a5,a5,0x20
    802007ec:	9381                	srli	a5,a5,0x20
    802007ee:	97ba                	add	a5,a5,a4
    802007f0:	0007c783          	lbu	a5,0(a5)
    802007f4:	fef407a3          	sb	a5,-17(s0)
            linebuf[line_len++] = c;
    802007f8:	0000a797          	auipc	a5,0xa
    802007fc:	8a878793          	addi	a5,a5,-1880 # 8020a0a0 <uart_input_buf>
    80200800:	0807a783          	lw	a5,128(a5)
    80200804:	2785                	addiw	a5,a5,1
    80200806:	2781                	sext.w	a5,a5
    80200808:	07f7f793          	andi	a5,a5,127
    8020080c:	0007871b          	sext.w	a4,a5
    80200810:	0000a797          	auipc	a5,0xa
    80200814:	89078793          	addi	a5,a5,-1904 # 8020a0a0 <uart_input_buf>
    80200818:	08e7a023          	sw	a4,128(a5)
        }
    8020081c:	fef44783          	lbu	a5,-17(s0)
    }
    80200820:	853e                	mv	a0,a5
    80200822:	6462                	ld	s0,24(sp)
    80200824:	6105                	addi	sp,sp,32
    80200826:	8082                	ret

0000000080200828 <readline>:
}
// 阻塞式读取一个字符
    80200828:	7179                	addi	sp,sp,-48
    8020082a:	f406                	sd	ra,40(sp)
    8020082c:	f022                	sd	s0,32(sp)
    8020082e:	1800                	addi	s0,sp,48
    80200830:	fca43c23          	sd	a0,-40(s0)
    80200834:	87ae                	mv	a5,a1
    80200836:	fcf42a23          	sw	a5,-44(s0)
char uart_getc_blocking(void) {
    8020083a:	fe042623          	sw	zero,-20(s0)
    // 等待直到有字符可读
    while (uart_input_buf.r == uart_input_buf.w) {
        // 在实际系统中，这里可能需要让进程睡眠
    8020083e:	a0b9                	j	8020088c <readline+0x64>
        // 但目前我们使用简单的轮询
    80200840:	00000097          	auipc	ra,0x0
    80200844:	f70080e7          	jalr	-144(ra) # 802007b0 <uart_getc_blocking>
    80200848:	87aa                	mv	a5,a0
    8020084a:	fef405a3          	sb	a5,-21(s0)
        asm volatile("nop");
    }
    8020084e:	feb44783          	lbu	a5,-21(s0)
    80200852:	0ff7f713          	zext.b	a4,a5
    80200856:	47a9                	li	a5,10
    80200858:	00f71c63          	bne	a4,a5,80200870 <readline+0x48>
    
    8020085c:	fec42783          	lw	a5,-20(s0)
    80200860:	fd843703          	ld	a4,-40(s0)
    80200864:	97ba                	add	a5,a5,a4
    80200866:	00078023          	sb	zero,0(a5)
    // 读取字符
    8020086a:	fec42783          	lw	a5,-20(s0)
    8020086e:	a0a9                	j	802008b8 <readline+0x90>
    char c = uart_input_buf.buf[uart_input_buf.r];
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    80200870:	fec42783          	lw	a5,-20(s0)
    80200874:	0017871b          	addiw	a4,a5,1
    80200878:	fee42623          	sw	a4,-20(s0)
    8020087c:	873e                	mv	a4,a5
    8020087e:	fd843783          	ld	a5,-40(s0)
    80200882:	97ba                	add	a5,a5,a4
    80200884:	feb44703          	lbu	a4,-21(s0)
    80200888:	00e78023          	sb	a4,0(a5)
        // 在实际系统中，这里可能需要让进程睡眠
    8020088c:	fd442783          	lw	a5,-44(s0)
    80200890:	37fd                	addiw	a5,a5,-1
    80200892:	0007871b          	sext.w	a4,a5
    80200896:	fec42783          	lw	a5,-20(s0)
    8020089a:	2781                	sext.w	a5,a5
    8020089c:	fae7c2e3          	blt	a5,a4,80200840 <readline+0x18>
    return c;
}
// 读取一行输入，最多读取max-1个字符，并在末尾添加\0
int readline(char *buf, int max) {
    int i = 0;
    802008a0:	fd442783          	lw	a5,-44(s0)
    802008a4:	17fd                	addi	a5,a5,-1
    802008a6:	fd843703          	ld	a4,-40(s0)
    802008aa:	97ba                	add	a5,a5,a4
    802008ac:	00078023          	sb	zero,0(a5)
    char c;
    802008b0:	fd442783          	lw	a5,-44(s0)
    802008b4:	37fd                	addiw	a5,a5,-1
    802008b6:	2781                	sext.w	a5,a5
    
    802008b8:	853e                	mv	a0,a5
    802008ba:	70a2                	ld	ra,40(sp)
    802008bc:	7402                	ld	s0,32(sp)
    802008be:	6145                	addi	sp,sp,48
    802008c0:	8082                	ret

00000000802008c2 <flush_printf_buffer>:

extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    802008c2:	1141                	addi	sp,sp,-16
    802008c4:	e406                	sd	ra,8(sp)
    802008c6:	e022                	sd	s0,0(sp)
    802008c8:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    802008ca:	0000a797          	auipc	a5,0xa
    802008ce:	8e678793          	addi	a5,a5,-1818 # 8020a1b0 <printf_buf_pos>
    802008d2:	439c                	lw	a5,0(a5)
    802008d4:	02f05c63          	blez	a5,8020090c <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    802008d8:	0000a797          	auipc	a5,0xa
    802008dc:	8d878793          	addi	a5,a5,-1832 # 8020a1b0 <printf_buf_pos>
    802008e0:	439c                	lw	a5,0(a5)
    802008e2:	0000a717          	auipc	a4,0xa
    802008e6:	84e70713          	addi	a4,a4,-1970 # 8020a130 <printf_buffer>
    802008ea:	97ba                	add	a5,a5,a4
    802008ec:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    802008f0:	0000a517          	auipc	a0,0xa
    802008f4:	84050513          	addi	a0,a0,-1984 # 8020a130 <printf_buffer>
    802008f8:	00000097          	auipc	ra,0x0
    802008fc:	d3c080e7          	jalr	-708(ra) # 80200634 <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200900:	0000a797          	auipc	a5,0xa
    80200904:	8b078793          	addi	a5,a5,-1872 # 8020a1b0 <printf_buf_pos>
    80200908:	0007a023          	sw	zero,0(a5)
	}
}
    8020090c:	0001                	nop
    8020090e:	60a2                	ld	ra,8(sp)
    80200910:	6402                	ld	s0,0(sp)
    80200912:	0141                	addi	sp,sp,16
    80200914:	8082                	ret

0000000080200916 <buffer_char>:
static void buffer_char(char c) {
    80200916:	1101                	addi	sp,sp,-32
    80200918:	ec06                	sd	ra,24(sp)
    8020091a:	e822                	sd	s0,16(sp)
    8020091c:	1000                	addi	s0,sp,32
    8020091e:	87aa                	mv	a5,a0
    80200920:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    80200924:	0000a797          	auipc	a5,0xa
    80200928:	88c78793          	addi	a5,a5,-1908 # 8020a1b0 <printf_buf_pos>
    8020092c:	439c                	lw	a5,0(a5)
    8020092e:	873e                	mv	a4,a5
    80200930:	07e00793          	li	a5,126
    80200934:	02e7ca63          	blt	a5,a4,80200968 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200938:	0000a797          	auipc	a5,0xa
    8020093c:	87878793          	addi	a5,a5,-1928 # 8020a1b0 <printf_buf_pos>
    80200940:	439c                	lw	a5,0(a5)
    80200942:	0017871b          	addiw	a4,a5,1
    80200946:	0007069b          	sext.w	a3,a4
    8020094a:	0000a717          	auipc	a4,0xa
    8020094e:	86670713          	addi	a4,a4,-1946 # 8020a1b0 <printf_buf_pos>
    80200952:	c314                	sw	a3,0(a4)
    80200954:	00009717          	auipc	a4,0x9
    80200958:	7dc70713          	addi	a4,a4,2012 # 8020a130 <printf_buffer>
    8020095c:	97ba                	add	a5,a5,a4
    8020095e:	fef44703          	lbu	a4,-17(s0)
    80200962:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    80200966:	a825                	j	8020099e <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    80200968:	00000097          	auipc	ra,0x0
    8020096c:	f5a080e7          	jalr	-166(ra) # 802008c2 <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    80200970:	0000a797          	auipc	a5,0xa
    80200974:	84078793          	addi	a5,a5,-1984 # 8020a1b0 <printf_buf_pos>
    80200978:	439c                	lw	a5,0(a5)
    8020097a:	0017871b          	addiw	a4,a5,1
    8020097e:	0007069b          	sext.w	a3,a4
    80200982:	0000a717          	auipc	a4,0xa
    80200986:	82e70713          	addi	a4,a4,-2002 # 8020a1b0 <printf_buf_pos>
    8020098a:	c314                	sw	a3,0(a4)
    8020098c:	00009717          	auipc	a4,0x9
    80200990:	7a470713          	addi	a4,a4,1956 # 8020a130 <printf_buffer>
    80200994:	97ba                	add	a5,a5,a4
    80200996:	fef44703          	lbu	a4,-17(s0)
    8020099a:	00e78023          	sb	a4,0(a5)
}
    8020099e:	0001                	nop
    802009a0:	60e2                	ld	ra,24(sp)
    802009a2:	6442                	ld	s0,16(sp)
    802009a4:	6105                	addi	sp,sp,32
    802009a6:	8082                	ret

00000000802009a8 <consputc>:
static void printint(long long xx, int base, int sign, int width, int padzero){
    static char digits[] = "0123456789abcdef";
    char buf[32];
    int i = 0;
    unsigned long long x;

    802009a8:	1101                	addi	sp,sp,-32
    802009aa:	ec06                	sd	ra,24(sp)
    802009ac:	e822                	sd	s0,16(sp)
    802009ae:	1000                	addi	s0,sp,32
    802009b0:	87aa                	mv	a5,a0
    802009b2:	fef42623          	sw	a5,-20(s0)
    if (sign && (sign = xx < 0))
        x = -(unsigned long long)xx;
    802009b6:	fec42783          	lw	a5,-20(s0)
    802009ba:	0ff7f793          	zext.b	a5,a5
    802009be:	853e                	mv	a0,a5
    802009c0:	00000097          	auipc	ra,0x0
    802009c4:	c3a080e7          	jalr	-966(ra) # 802005fa <uart_putc>
    else
    802009c8:	0001                	nop
    802009ca:	60e2                	ld	ra,24(sp)
    802009cc:	6442                	ld	s0,16(sp)
    802009ce:	6105                	addi	sp,sp,32
    802009d0:	8082                	ret

00000000802009d2 <consputs>:
        x = xx;
    802009d2:	7179                	addi	sp,sp,-48
    802009d4:	f406                	sd	ra,40(sp)
    802009d6:	f022                	sd	s0,32(sp)
    802009d8:	1800                	addi	s0,sp,48
    802009da:	fca43c23          	sd	a0,-40(s0)

    802009de:	fd843783          	ld	a5,-40(s0)
    802009e2:	fef43423          	sd	a5,-24(s0)
    do {
        buf[i++] = digits[x % base];
    802009e6:	fe843503          	ld	a0,-24(s0)
    802009ea:	00000097          	auipc	ra,0x0
    802009ee:	c4a080e7          	jalr	-950(ra) # 80200634 <uart_puts>
    } while ((x /= base) != 0);
    802009f2:	0001                	nop
    802009f4:	70a2                	ld	ra,40(sp)
    802009f6:	7402                	ld	s0,32(sp)
    802009f8:	6145                	addi	sp,sp,48
    802009fa:	8082                	ret

00000000802009fc <printint>:

    802009fc:	715d                	addi	sp,sp,-80
    802009fe:	e486                	sd	ra,72(sp)
    80200a00:	e0a2                	sd	s0,64(sp)
    80200a02:	0880                	addi	s0,sp,80
    80200a04:	faa43c23          	sd	a0,-72(s0)
    80200a08:	87ae                	mv	a5,a1
    80200a0a:	8732                	mv	a4,a2
    80200a0c:	faf42a23          	sw	a5,-76(s0)
    80200a10:	87ba                	mv	a5,a4
    80200a12:	faf42823          	sw	a5,-80(s0)
    if (sign)
        buf[i++] = '-';

    // 计算需要补的填充字符数
    int pad = width - i;
    while (pad-- > 0) {
    80200a16:	fb042783          	lw	a5,-80(s0)
    80200a1a:	2781                	sext.w	a5,a5
    80200a1c:	c39d                	beqz	a5,80200a42 <printint+0x46>
    80200a1e:	fb843783          	ld	a5,-72(s0)
    80200a22:	93fd                	srli	a5,a5,0x3f
    80200a24:	0ff7f793          	zext.b	a5,a5
    80200a28:	faf42823          	sw	a5,-80(s0)
    80200a2c:	fb042783          	lw	a5,-80(s0)
    80200a30:	2781                	sext.w	a5,a5
    80200a32:	cb81                	beqz	a5,80200a42 <printint+0x46>
        consputc(padzero ? '0' : ' ');
    80200a34:	fb843783          	ld	a5,-72(s0)
    80200a38:	40f007b3          	neg	a5,a5
    80200a3c:	fef43023          	sd	a5,-32(s0)
    80200a40:	a029                	j	80200a4a <printint+0x4e>
    }

    80200a42:	fb843783          	ld	a5,-72(s0)
    80200a46:	fef43023          	sd	a5,-32(s0)
    while (--i >= 0)
        consputc(buf[i]);
    80200a4a:	fb442783          	lw	a5,-76(s0)
    80200a4e:	0007871b          	sext.w	a4,a5
    80200a52:	47a9                	li	a5,10
    80200a54:	02f71763          	bne	a4,a5,80200a82 <printint+0x86>
    80200a58:	fe043703          	ld	a4,-32(s0)
    80200a5c:	06300793          	li	a5,99
    80200a60:	02e7e163          	bltu	a5,a4,80200a82 <printint+0x86>
}
void printf(const char *fmt, ...) {
    80200a64:	fe043783          	ld	a5,-32(s0)
    80200a68:	00279713          	slli	a4,a5,0x2
    80200a6c:	00006797          	auipc	a5,0x6
    80200a70:	98478793          	addi	a5,a5,-1660 # 802063f0 <small_numbers>
    80200a74:	97ba                	add	a5,a5,a4
    80200a76:	853e                	mv	a0,a5
    80200a78:	00000097          	auipc	ra,0x0
    80200a7c:	f5a080e7          	jalr	-166(ra) # 802009d2 <consputs>
    80200a80:	a05d                	j	80200b26 <printint+0x12a>
    va_list ap;
    int i, c;
    char *s;
    80200a82:	fe042623          	sw	zero,-20(s0)

    va_start(ap, fmt);
    80200a86:	fb442783          	lw	a5,-76(s0)
    80200a8a:	fe043703          	ld	a4,-32(s0)
    80200a8e:	02f777b3          	remu	a5,a4,a5
    80200a92:	00009717          	auipc	a4,0x9
    80200a96:	5ce70713          	addi	a4,a4,1486 # 8020a060 <digits.0>
    80200a9a:	97ba                	add	a5,a5,a4
    80200a9c:	0007c703          	lbu	a4,0(a5)
    80200aa0:	fec42783          	lw	a5,-20(s0)
    80200aa4:	17c1                	addi	a5,a5,-16
    80200aa6:	97a2                	add	a5,a5,s0
    80200aa8:	fce78c23          	sb	a4,-40(a5)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200aac:	fec42783          	lw	a5,-20(s0)
    80200ab0:	2785                	addiw	a5,a5,1
    80200ab2:	fef42623          	sw	a5,-20(s0)
        if(c != '%'){
    80200ab6:	fb442783          	lw	a5,-76(s0)
    80200aba:	fe043703          	ld	a4,-32(s0)
    80200abe:	02f757b3          	divu	a5,a4,a5
    80200ac2:	fef43023          	sd	a5,-32(s0)
    80200ac6:	fe043783          	ld	a5,-32(s0)
    80200aca:	ffd5                	bnez	a5,80200a86 <printint+0x8a>
            buffer_char(c);
    80200acc:	fb042783          	lw	a5,-80(s0)
    80200ad0:	2781                	sext.w	a5,a5
    80200ad2:	cf91                	beqz	a5,80200aee <printint+0xf2>
            continue;
    80200ad4:	fec42783          	lw	a5,-20(s0)
    80200ad8:	17c1                	addi	a5,a5,-16
    80200ada:	97a2                	add	a5,a5,s0
    80200adc:	02d00713          	li	a4,45
    80200ae0:	fce78c23          	sb	a4,-40(a5)
        }
    80200ae4:	fec42783          	lw	a5,-20(s0)
    80200ae8:	2785                	addiw	a5,a5,1
    80200aea:	fef42623          	sw	a5,-20(s0)
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
		// 解析填充标志和宽度
    80200aee:	fec42783          	lw	a5,-20(s0)
    80200af2:	37fd                	addiw	a5,a5,-1
    80200af4:	fef42623          	sw	a5,-20(s0)
        int padzero = 0, width = 0;
    80200af8:	a015                	j	80200b1c <printint+0x120>
        c = fmt[++i] & 0xff;
    80200afa:	fec42783          	lw	a5,-20(s0)
    80200afe:	17c1                	addi	a5,a5,-16
    80200b00:	97a2                	add	a5,a5,s0
    80200b02:	fd87c783          	lbu	a5,-40(a5)
    80200b06:	2781                	sext.w	a5,a5
    80200b08:	853e                	mv	a0,a5
    80200b0a:	00000097          	auipc	ra,0x0
    80200b0e:	e9e080e7          	jalr	-354(ra) # 802009a8 <consputc>
        if (c == '0') {
    80200b12:	fec42783          	lw	a5,-20(s0)
    80200b16:	37fd                	addiw	a5,a5,-1
    80200b18:	fef42623          	sw	a5,-20(s0)
        int padzero = 0, width = 0;
    80200b1c:	fec42783          	lw	a5,-20(s0)
    80200b20:	2781                	sext.w	a5,a5
    80200b22:	fc07dce3          	bgez	a5,80200afa <printint+0xfe>
            padzero = 1;
            c = fmt[++i] & 0xff;
    80200b26:	60a6                	ld	ra,72(sp)
    80200b28:	6406                	ld	s0,64(sp)
    80200b2a:	6161                	addi	sp,sp,80
    80200b2c:	8082                	ret

0000000080200b2e <printf>:
        }
    80200b2e:	7171                	addi	sp,sp,-176
    80200b30:	f486                	sd	ra,104(sp)
    80200b32:	f0a2                	sd	s0,96(sp)
    80200b34:	1880                	addi	s0,sp,112
    80200b36:	f8a43c23          	sd	a0,-104(s0)
    80200b3a:	e40c                	sd	a1,8(s0)
    80200b3c:	e810                	sd	a2,16(s0)
    80200b3e:	ec14                	sd	a3,24(s0)
    80200b40:	f018                	sd	a4,32(s0)
    80200b42:	f41c                	sd	a5,40(s0)
    80200b44:	03043823          	sd	a6,48(s0)
    80200b48:	03143c23          	sd	a7,56(s0)
        while (c >= '0' && c <= '9') {
            width = width * 10 + (c - '0');
            c = fmt[++i] & 0xff;
        }
        // 检查是否有长整型标记'l'
    80200b4c:	04040793          	addi	a5,s0,64
    80200b50:	f8f43823          	sd	a5,-112(s0)
    80200b54:	f9043783          	ld	a5,-112(s0)
    80200b58:	fc878793          	addi	a5,a5,-56
    80200b5c:	fcf43023          	sd	a5,-64(s0)
        int is_long = 0;
    80200b60:	fe042623          	sw	zero,-20(s0)
    80200b64:	a671                	j	80200ef0 <printf+0x3c2>
        if(c == 'l') {
    80200b66:	fe842783          	lw	a5,-24(s0)
    80200b6a:	0007871b          	sext.w	a4,a5
    80200b6e:	02500793          	li	a5,37
    80200b72:	00f70c63          	beq	a4,a5,80200b8a <printf+0x5c>
            is_long = 1;
    80200b76:	fe842783          	lw	a5,-24(s0)
    80200b7a:	0ff7f793          	zext.b	a5,a5
    80200b7e:	853e                	mv	a0,a5
    80200b80:	00000097          	auipc	ra,0x0
    80200b84:	d96080e7          	jalr	-618(ra) # 80200916 <buffer_char>
            c = fmt[++i] & 0xff;
    80200b88:	aeb9                	j	80200ee6 <printf+0x3b8>
            if(c == 0)
                break;
    80200b8a:	00000097          	auipc	ra,0x0
    80200b8e:	d38080e7          	jalr	-712(ra) # 802008c2 <flush_printf_buffer>
        }
    80200b92:	fec42783          	lw	a5,-20(s0)
    80200b96:	2785                	addiw	a5,a5,1
    80200b98:	fef42623          	sw	a5,-20(s0)
    80200b9c:	fec42783          	lw	a5,-20(s0)
    80200ba0:	f9843703          	ld	a4,-104(s0)
    80200ba4:	97ba                	add	a5,a5,a4
    80200ba6:	0007c783          	lbu	a5,0(a5)
    80200baa:	fef42423          	sw	a5,-24(s0)
        
    80200bae:	fe842783          	lw	a5,-24(s0)
    80200bb2:	2781                	sext.w	a5,a5
    80200bb4:	34078d63          	beqz	a5,80200f0e <printf+0x3e0>
        switch(c){
        case 'd':
            if(is_long)
                printint(va_arg(ap, long long), 10, 1, width, padzero);
    80200bb8:	fc042e23          	sw	zero,-36(s0)
            else
    80200bbc:	fe842783          	lw	a5,-24(s0)
    80200bc0:	0007871b          	sext.w	a4,a5
    80200bc4:	06c00793          	li	a5,108
    80200bc8:	02f71863          	bne	a4,a5,80200bf8 <printf+0xca>
                printint(va_arg(ap, int), 10, 1, width, padzero);
    80200bcc:	4785                	li	a5,1
    80200bce:	fcf42e23          	sw	a5,-36(s0)
            break;
    80200bd2:	fec42783          	lw	a5,-20(s0)
    80200bd6:	2785                	addiw	a5,a5,1
    80200bd8:	fef42623          	sw	a5,-20(s0)
    80200bdc:	fec42783          	lw	a5,-20(s0)
    80200be0:	f9843703          	ld	a4,-104(s0)
    80200be4:	97ba                	add	a5,a5,a4
    80200be6:	0007c783          	lbu	a5,0(a5)
    80200bea:	fef42423          	sw	a5,-24(s0)
        case 'x':
    80200bee:	fe842783          	lw	a5,-24(s0)
    80200bf2:	2781                	sext.w	a5,a5
    80200bf4:	30078f63          	beqz	a5,80200f12 <printf+0x3e4>
            if(is_long)
                printint(va_arg(ap, long long), 16, 0, width, padzero);
            else
                printint(va_arg(ap, int), 16, 0, width, padzero);
    80200bf8:	fe842783          	lw	a5,-24(s0)
    80200bfc:	0007871b          	sext.w	a4,a5
    80200c00:	02500793          	li	a5,37
    80200c04:	2af70063          	beq	a4,a5,80200ea4 <printf+0x376>
    80200c08:	fe842783          	lw	a5,-24(s0)
    80200c0c:	0007871b          	sext.w	a4,a5
    80200c10:	02500793          	li	a5,37
    80200c14:	28f74f63          	blt	a4,a5,80200eb2 <printf+0x384>
    80200c18:	fe842783          	lw	a5,-24(s0)
    80200c1c:	0007871b          	sext.w	a4,a5
    80200c20:	07800793          	li	a5,120
    80200c24:	28e7c763          	blt	a5,a4,80200eb2 <printf+0x384>
    80200c28:	fe842783          	lw	a5,-24(s0)
    80200c2c:	0007871b          	sext.w	a4,a5
    80200c30:	06200793          	li	a5,98
    80200c34:	26f74f63          	blt	a4,a5,80200eb2 <printf+0x384>
    80200c38:	fe842783          	lw	a5,-24(s0)
    80200c3c:	f9e7869b          	addiw	a3,a5,-98
    80200c40:	0006871b          	sext.w	a4,a3
    80200c44:	47d9                	li	a5,22
    80200c46:	26e7e663          	bltu	a5,a4,80200eb2 <printf+0x384>
    80200c4a:	02069793          	slli	a5,a3,0x20
    80200c4e:	9381                	srli	a5,a5,0x20
    80200c50:	00279713          	slli	a4,a5,0x2
    80200c54:	00006797          	auipc	a5,0x6
    80200c58:	95078793          	addi	a5,a5,-1712 # 802065a4 <small_numbers+0x1b4>
    80200c5c:	97ba                	add	a5,a5,a4
    80200c5e:	439c                	lw	a5,0(a5)
    80200c60:	0007871b          	sext.w	a4,a5
    80200c64:	00006797          	auipc	a5,0x6
    80200c68:	94078793          	addi	a5,a5,-1728 # 802065a4 <small_numbers+0x1b4>
    80200c6c:	97ba                	add	a5,a5,a4
    80200c6e:	8782                	jr	a5
            break;
        case 'u':
    80200c70:	fdc42783          	lw	a5,-36(s0)
    80200c74:	2781                	sext.w	a5,a5
    80200c76:	c385                	beqz	a5,80200c96 <printf+0x168>
            if(is_long)
    80200c78:	fc043783          	ld	a5,-64(s0)
    80200c7c:	00878713          	addi	a4,a5,8
    80200c80:	fce43023          	sd	a4,-64(s0)
    80200c84:	639c                	ld	a5,0(a5)
    80200c86:	4605                	li	a2,1
    80200c88:	45a9                	li	a1,10
    80200c8a:	853e                	mv	a0,a5
    80200c8c:	00000097          	auipc	ra,0x0
    80200c90:	d70080e7          	jalr	-656(ra) # 802009fc <printint>
                printint(va_arg(ap, unsigned long long), 10, 0, width, padzero);
            else
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
    80200c94:	ac89                	j	80200ee6 <printf+0x3b8>
            else
    80200c96:	fc043783          	ld	a5,-64(s0)
    80200c9a:	00878713          	addi	a4,a5,8
    80200c9e:	fce43023          	sd	a4,-64(s0)
    80200ca2:	439c                	lw	a5,0(a5)
    80200ca4:	4605                	li	a2,1
    80200ca6:	45a9                	li	a1,10
    80200ca8:	853e                	mv	a0,a5
    80200caa:	00000097          	auipc	ra,0x0
    80200cae:	d52080e7          	jalr	-686(ra) # 802009fc <printint>
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
    80200cb2:	ac15                	j	80200ee6 <printf+0x3b8>
            break;
        case 'c':
    80200cb4:	fdc42783          	lw	a5,-36(s0)
    80200cb8:	2781                	sext.w	a5,a5
    80200cba:	c385                	beqz	a5,80200cda <printf+0x1ac>
            consputc(va_arg(ap, int));
    80200cbc:	fc043783          	ld	a5,-64(s0)
    80200cc0:	00878713          	addi	a4,a5,8
    80200cc4:	fce43023          	sd	a4,-64(s0)
    80200cc8:	639c                	ld	a5,0(a5)
    80200cca:	4601                	li	a2,0
    80200ccc:	45c1                	li	a1,16
    80200cce:	853e                	mv	a0,a5
    80200cd0:	00000097          	auipc	ra,0x0
    80200cd4:	d2c080e7          	jalr	-724(ra) # 802009fc <printint>
            break;
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80200cd8:	a439                	j	80200ee6 <printf+0x3b8>
        case 's':
    80200cda:	fc043783          	ld	a5,-64(s0)
    80200cde:	00878713          	addi	a4,a5,8
    80200ce2:	fce43023          	sd	a4,-64(s0)
    80200ce6:	439c                	lw	a5,0(a5)
    80200ce8:	4601                	li	a2,0
    80200cea:	45c1                	li	a1,16
    80200cec:	853e                	mv	a0,a5
    80200cee:	00000097          	auipc	ra,0x0
    80200cf2:	d0e080e7          	jalr	-754(ra) # 802009fc <printint>
            if((s = va_arg(ap, char*)) == 0)
    80200cf6:	aac5                	j	80200ee6 <printf+0x3b8>
                s = "(null)";
            consputs(s);
    80200cf8:	fdc42783          	lw	a5,-36(s0)
    80200cfc:	2781                	sext.w	a5,a5
    80200cfe:	c385                	beqz	a5,80200d1e <printf+0x1f0>
            break;
    80200d00:	fc043783          	ld	a5,-64(s0)
    80200d04:	00878713          	addi	a4,a5,8
    80200d08:	fce43023          	sd	a4,-64(s0)
    80200d0c:	639c                	ld	a5,0(a5)
    80200d0e:	4601                	li	a2,0
    80200d10:	45a9                	li	a1,10
    80200d12:	853e                	mv	a0,a5
    80200d14:	00000097          	auipc	ra,0x0
    80200d18:	ce8080e7          	jalr	-792(ra) # 802009fc <printint>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
            consputs("0x");
    80200d1c:	a2e9                	j	80200ee6 <printf+0x3b8>
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    80200d1e:	fc043783          	ld	a5,-64(s0)
    80200d22:	00878713          	addi	a4,a5,8
    80200d26:	fce43023          	sd	a4,-64(s0)
    80200d2a:	439c                	lw	a5,0(a5)
    80200d2c:	1782                	slli	a5,a5,0x20
    80200d2e:	9381                	srli	a5,a5,0x20
    80200d30:	4601                	li	a2,0
    80200d32:	45a9                	li	a1,10
    80200d34:	853e                	mv	a0,a5
    80200d36:	00000097          	auipc	ra,0x0
    80200d3a:	cc6080e7          	jalr	-826(ra) # 802009fc <printint>
            consputs("0x");
    80200d3e:	a265                	j	80200ee6 <printf+0x3b8>
            // 输出16位宽，不足补0
            char buf[17];
    80200d40:	fc043783          	ld	a5,-64(s0)
    80200d44:	00878713          	addi	a4,a5,8
    80200d48:	fce43023          	sd	a4,-64(s0)
    80200d4c:	439c                	lw	a5,0(a5)
    80200d4e:	853e                	mv	a0,a5
    80200d50:	00000097          	auipc	ra,0x0
    80200d54:	c58080e7          	jalr	-936(ra) # 802009a8 <consputc>
            int i;
    80200d58:	a279                	j	80200ee6 <printf+0x3b8>
            for (i = 0; i < 16; i++) {
                int shift = (15 - i) * 4;
    80200d5a:	fc043783          	ld	a5,-64(s0)
    80200d5e:	00878713          	addi	a4,a5,8
    80200d62:	fce43023          	sd	a4,-64(s0)
    80200d66:	639c                	ld	a5,0(a5)
    80200d68:	fef43023          	sd	a5,-32(s0)
    80200d6c:	fe043783          	ld	a5,-32(s0)
    80200d70:	e799                	bnez	a5,80200d7e <printf+0x250>
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80200d72:	00006797          	auipc	a5,0x6
    80200d76:	80e78793          	addi	a5,a5,-2034 # 80206580 <small_numbers+0x190>
    80200d7a:	fef43023          	sd	a5,-32(s0)
            }
    80200d7e:	fe043503          	ld	a0,-32(s0)
    80200d82:	00000097          	auipc	ra,0x0
    80200d86:	c50080e7          	jalr	-944(ra) # 802009d2 <consputs>
            buf[16] = '\0';
    80200d8a:	aab1                	j	80200ee6 <printf+0x3b8>
            consputs(buf);
            break;
    80200d8c:	fc043783          	ld	a5,-64(s0)
    80200d90:	00878713          	addi	a4,a5,8
    80200d94:	fce43023          	sd	a4,-64(s0)
    80200d98:	639c                	ld	a5,0(a5)
    80200d9a:	fcf43823          	sd	a5,-48(s0)
        case 'b':
    80200d9e:	00005517          	auipc	a0,0x5
    80200da2:	7ea50513          	addi	a0,a0,2026 # 80206588 <small_numbers+0x198>
    80200da6:	00000097          	auipc	ra,0x0
    80200daa:	c2c080e7          	jalr	-980(ra) # 802009d2 <consputs>
            if(is_long)
                printint(va_arg(ap, long long), 2, 0, width, padzero);
            else
                printint(va_arg(ap, int), 2, 0, width, padzero);
    80200dae:	fc042c23          	sw	zero,-40(s0)
    80200db2:	a0a1                	j	80200dfa <printf+0x2cc>
            break;
    80200db4:	47bd                	li	a5,15
    80200db6:	fd842703          	lw	a4,-40(s0)
    80200dba:	9f99                	subw	a5,a5,a4
    80200dbc:	2781                	sext.w	a5,a5
    80200dbe:	0027979b          	slliw	a5,a5,0x2
    80200dc2:	fcf42623          	sw	a5,-52(s0)
        case 'o':
    80200dc6:	fcc42783          	lw	a5,-52(s0)
    80200dca:	873e                	mv	a4,a5
    80200dcc:	fd043783          	ld	a5,-48(s0)
    80200dd0:	00e7d7b3          	srl	a5,a5,a4
    80200dd4:	8bbd                	andi	a5,a5,15
    80200dd6:	00005717          	auipc	a4,0x5
    80200dda:	7ba70713          	addi	a4,a4,1978 # 80206590 <small_numbers+0x1a0>
    80200dde:	97ba                	add	a5,a5,a4
    80200de0:	0007c703          	lbu	a4,0(a5)
    80200de4:	fd842783          	lw	a5,-40(s0)
    80200de8:	17c1                	addi	a5,a5,-16
    80200dea:	97a2                	add	a5,a5,s0
    80200dec:	fae78c23          	sb	a4,-72(a5)
                printint(va_arg(ap, int), 2, 0, width, padzero);
    80200df0:	fd842783          	lw	a5,-40(s0)
    80200df4:	2785                	addiw	a5,a5,1
    80200df6:	fcf42c23          	sw	a5,-40(s0)
    80200dfa:	fd842783          	lw	a5,-40(s0)
    80200dfe:	0007871b          	sext.w	a4,a5
    80200e02:	47bd                	li	a5,15
    80200e04:	fae7d8e3          	bge	a5,a4,80200db4 <printf+0x286>
            if(is_long)
                printint(va_arg(ap, long long), 8, 0, width, padzero);
    80200e08:	fa040c23          	sb	zero,-72(s0)
            else
    80200e0c:	fa840793          	addi	a5,s0,-88
    80200e10:	853e                	mv	a0,a5
    80200e12:	00000097          	auipc	ra,0x0
    80200e16:	bc0080e7          	jalr	-1088(ra) # 802009d2 <consputs>
                printint(va_arg(ap, int), 8, 0, width, padzero);
    80200e1a:	a0f1                	j	80200ee6 <printf+0x3b8>
            break;
        case '%':
    80200e1c:	fdc42783          	lw	a5,-36(s0)
    80200e20:	2781                	sext.w	a5,a5
    80200e22:	c385                	beqz	a5,80200e42 <printf+0x314>
            buffer_char('%');
    80200e24:	fc043783          	ld	a5,-64(s0)
    80200e28:	00878713          	addi	a4,a5,8
    80200e2c:	fce43023          	sd	a4,-64(s0)
    80200e30:	639c                	ld	a5,0(a5)
    80200e32:	4601                	li	a2,0
    80200e34:	4589                	li	a1,2
    80200e36:	853e                	mv	a0,a5
    80200e38:	00000097          	auipc	ra,0x0
    80200e3c:	bc4080e7          	jalr	-1084(ra) # 802009fc <printint>
            break;
        default:
            buffer_char('%');
    80200e40:	a05d                	j	80200ee6 <printf+0x3b8>
        default:
    80200e42:	fc043783          	ld	a5,-64(s0)
    80200e46:	00878713          	addi	a4,a5,8
    80200e4a:	fce43023          	sd	a4,-64(s0)
    80200e4e:	439c                	lw	a5,0(a5)
    80200e50:	4601                	li	a2,0
    80200e52:	4589                	li	a1,2
    80200e54:	853e                	mv	a0,a5
    80200e56:	00000097          	auipc	ra,0x0
    80200e5a:	ba6080e7          	jalr	-1114(ra) # 802009fc <printint>
            buffer_char('%');
    80200e5e:	a061                	j	80200ee6 <printf+0x3b8>
            if(padzero) buffer_char('0');
            if(width) {
    80200e60:	fdc42783          	lw	a5,-36(s0)
    80200e64:	2781                	sext.w	a5,a5
    80200e66:	c385                	beqz	a5,80200e86 <printf+0x358>
                // 只支持一位宽度，简单处理
    80200e68:	fc043783          	ld	a5,-64(s0)
    80200e6c:	00878713          	addi	a4,a5,8
    80200e70:	fce43023          	sd	a4,-64(s0)
    80200e74:	639c                	ld	a5,0(a5)
    80200e76:	4601                	li	a2,0
    80200e78:	45a1                	li	a1,8
    80200e7a:	853e                	mv	a0,a5
    80200e7c:	00000097          	auipc	ra,0x0
    80200e80:	b80080e7          	jalr	-1152(ra) # 802009fc <printint>
                buffer_char('0' + width);
            }
            if(is_long) buffer_char('l');
    80200e84:	a08d                	j	80200ee6 <printf+0x3b8>
            }
    80200e86:	fc043783          	ld	a5,-64(s0)
    80200e8a:	00878713          	addi	a4,a5,8
    80200e8e:	fce43023          	sd	a4,-64(s0)
    80200e92:	439c                	lw	a5,0(a5)
    80200e94:	4601                	li	a2,0
    80200e96:	45a1                	li	a1,8
    80200e98:	853e                	mv	a0,a5
    80200e9a:	00000097          	auipc	ra,0x0
    80200e9e:	b62080e7          	jalr	-1182(ra) # 802009fc <printint>
            if(is_long) buffer_char('l');
    80200ea2:	a091                	j	80200ee6 <printf+0x3b8>
            buffer_char(c);
            break;
    80200ea4:	02500513          	li	a0,37
    80200ea8:	00000097          	auipc	ra,0x0
    80200eac:	a6e080e7          	jalr	-1426(ra) # 80200916 <buffer_char>
        }
    80200eb0:	a81d                	j	80200ee6 <printf+0x3b8>
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    80200eb2:	02500513          	li	a0,37
    80200eb6:	00000097          	auipc	ra,0x0
    80200eba:	a60080e7          	jalr	-1440(ra) # 80200916 <buffer_char>
    va_end(ap);
    80200ebe:	fdc42783          	lw	a5,-36(s0)
    80200ec2:	2781                	sext.w	a5,a5
    80200ec4:	c799                	beqz	a5,80200ed2 <printf+0x3a4>
    80200ec6:	06c00513          	li	a0,108
    80200eca:	00000097          	auipc	ra,0x0
    80200ece:	a4c080e7          	jalr	-1460(ra) # 80200916 <buffer_char>
}
    80200ed2:	fe842783          	lw	a5,-24(s0)
    80200ed6:	0ff7f793          	zext.b	a5,a5
    80200eda:	853e                	mv	a0,a5
    80200edc:	00000097          	auipc	ra,0x0
    80200ee0:	a3a080e7          	jalr	-1478(ra) # 80200916 <buffer_char>
// 清屏功能
    80200ee4:	0001                	nop
        int is_long = 0;
    80200ee6:	fec42783          	lw	a5,-20(s0)
    80200eea:	2785                	addiw	a5,a5,1
    80200eec:	fef42623          	sw	a5,-20(s0)
    80200ef0:	fec42783          	lw	a5,-20(s0)
    80200ef4:	f9843703          	ld	a4,-104(s0)
    80200ef8:	97ba                	add	a5,a5,a4
    80200efa:	0007c783          	lbu	a5,0(a5)
    80200efe:	fef42423          	sw	a5,-24(s0)
    80200f02:	fe842783          	lw	a5,-24(s0)
    80200f06:	2781                	sext.w	a5,a5
    80200f08:	c4079fe3          	bnez	a5,80200b66 <printf+0x38>
    80200f0c:	a021                	j	80200f14 <printf+0x3e6>
        switch(c){
    80200f0e:	0001                	nop
    80200f10:	a011                	j	80200f14 <printf+0x3e6>
            if(is_long)
    80200f12:	0001                	nop
void clear_screen(void) {
    uart_puts(CLEAR_SCREEN);
	uart_puts(CURSOR_HOME);
    80200f14:	00000097          	auipc	ra,0x0
    80200f18:	9ae080e7          	jalr	-1618(ra) # 802008c2 <flush_printf_buffer>
}

    80200f1c:	0001                	nop
    80200f1e:	70a6                	ld	ra,104(sp)
    80200f20:	7406                	ld	s0,96(sp)
    80200f22:	614d                	addi	sp,sp,176
    80200f24:	8082                	ret

0000000080200f26 <clear_screen>:
// 光标上移
void cursor_up(int lines) {
    80200f26:	1141                	addi	sp,sp,-16
    80200f28:	e406                	sd	ra,8(sp)
    80200f2a:	e022                	sd	s0,0(sp)
    80200f2c:	0800                	addi	s0,sp,16
    if (lines <= 0) return;
    80200f2e:	00005517          	auipc	a0,0x5
    80200f32:	6d250513          	addi	a0,a0,1746 # 80206600 <small_numbers+0x210>
    80200f36:	fffff097          	auipc	ra,0xfffff
    80200f3a:	6fe080e7          	jalr	1790(ra) # 80200634 <uart_puts>
    consputc('\033');
    80200f3e:	00005517          	auipc	a0,0x5
    80200f42:	6ca50513          	addi	a0,a0,1738 # 80206608 <small_numbers+0x218>
    80200f46:	fffff097          	auipc	ra,0xfffff
    80200f4a:	6ee080e7          	jalr	1774(ra) # 80200634 <uart_puts>
    consputc('[');
    80200f4e:	0001                	nop
    80200f50:	60a2                	ld	ra,8(sp)
    80200f52:	6402                	ld	s0,0(sp)
    80200f54:	0141                	addi	sp,sp,16
    80200f56:	8082                	ret

0000000080200f58 <cursor_up>:
    printint(lines, 10, 0, 0,0);
    consputc('A');
}
    80200f58:	1101                	addi	sp,sp,-32
    80200f5a:	ec06                	sd	ra,24(sp)
    80200f5c:	e822                	sd	s0,16(sp)
    80200f5e:	1000                	addi	s0,sp,32
    80200f60:	87aa                	mv	a5,a0
    80200f62:	fef42623          	sw	a5,-20(s0)

    80200f66:	fec42783          	lw	a5,-20(s0)
    80200f6a:	2781                	sext.w	a5,a5
    80200f6c:	02f05d63          	blez	a5,80200fa6 <cursor_up+0x4e>
// 光标下移
    80200f70:	456d                	li	a0,27
    80200f72:	00000097          	auipc	ra,0x0
    80200f76:	a36080e7          	jalr	-1482(ra) # 802009a8 <consputc>
void cursor_down(int lines) {
    80200f7a:	05b00513          	li	a0,91
    80200f7e:	00000097          	auipc	ra,0x0
    80200f82:	a2a080e7          	jalr	-1494(ra) # 802009a8 <consputc>
    if (lines <= 0) return;
    80200f86:	fec42783          	lw	a5,-20(s0)
    80200f8a:	4601                	li	a2,0
    80200f8c:	45a9                	li	a1,10
    80200f8e:	853e                	mv	a0,a5
    80200f90:	00000097          	auipc	ra,0x0
    80200f94:	a6c080e7          	jalr	-1428(ra) # 802009fc <printint>
    consputc('\033');
    80200f98:	04100513          	li	a0,65
    80200f9c:	00000097          	auipc	ra,0x0
    80200fa0:	a0c080e7          	jalr	-1524(ra) # 802009a8 <consputc>
    80200fa4:	a011                	j	80200fa8 <cursor_up+0x50>

    80200fa6:	0001                	nop
    consputc('[');
    80200fa8:	60e2                	ld	ra,24(sp)
    80200faa:	6442                	ld	s0,16(sp)
    80200fac:	6105                	addi	sp,sp,32
    80200fae:	8082                	ret

0000000080200fb0 <cursor_down>:
    printint(lines, 10, 0, 0,0);
    consputc('B');
}
    80200fb0:	1101                	addi	sp,sp,-32
    80200fb2:	ec06                	sd	ra,24(sp)
    80200fb4:	e822                	sd	s0,16(sp)
    80200fb6:	1000                	addi	s0,sp,32
    80200fb8:	87aa                	mv	a5,a0
    80200fba:	fef42623          	sw	a5,-20(s0)

    80200fbe:	fec42783          	lw	a5,-20(s0)
    80200fc2:	2781                	sext.w	a5,a5
    80200fc4:	02f05d63          	blez	a5,80200ffe <cursor_down+0x4e>
// 光标右移
    80200fc8:	456d                	li	a0,27
    80200fca:	00000097          	auipc	ra,0x0
    80200fce:	9de080e7          	jalr	-1570(ra) # 802009a8 <consputc>
void cursor_right(int cols) {
    80200fd2:	05b00513          	li	a0,91
    80200fd6:	00000097          	auipc	ra,0x0
    80200fda:	9d2080e7          	jalr	-1582(ra) # 802009a8 <consputc>
    if (cols <= 0) return;
    80200fde:	fec42783          	lw	a5,-20(s0)
    80200fe2:	4601                	li	a2,0
    80200fe4:	45a9                	li	a1,10
    80200fe6:	853e                	mv	a0,a5
    80200fe8:	00000097          	auipc	ra,0x0
    80200fec:	a14080e7          	jalr	-1516(ra) # 802009fc <printint>
    consputc('\033');
    80200ff0:	04200513          	li	a0,66
    80200ff4:	00000097          	auipc	ra,0x0
    80200ff8:	9b4080e7          	jalr	-1612(ra) # 802009a8 <consputc>
    80200ffc:	a011                	j	80201000 <cursor_down+0x50>

    80200ffe:	0001                	nop
    consputc('[');
    80201000:	60e2                	ld	ra,24(sp)
    80201002:	6442                	ld	s0,16(sp)
    80201004:	6105                	addi	sp,sp,32
    80201006:	8082                	ret

0000000080201008 <cursor_right>:
    printint(cols, 10, 0,0,0);
    consputc('C');
}
    80201008:	1101                	addi	sp,sp,-32
    8020100a:	ec06                	sd	ra,24(sp)
    8020100c:	e822                	sd	s0,16(sp)
    8020100e:	1000                	addi	s0,sp,32
    80201010:	87aa                	mv	a5,a0
    80201012:	fef42623          	sw	a5,-20(s0)

    80201016:	fec42783          	lw	a5,-20(s0)
    8020101a:	2781                	sext.w	a5,a5
    8020101c:	02f05d63          	blez	a5,80201056 <cursor_right+0x4e>
// 光标左移
    80201020:	456d                	li	a0,27
    80201022:	00000097          	auipc	ra,0x0
    80201026:	986080e7          	jalr	-1658(ra) # 802009a8 <consputc>
void cursor_left(int cols) {
    8020102a:	05b00513          	li	a0,91
    8020102e:	00000097          	auipc	ra,0x0
    80201032:	97a080e7          	jalr	-1670(ra) # 802009a8 <consputc>
    if (cols <= 0) return;
    80201036:	fec42783          	lw	a5,-20(s0)
    8020103a:	4601                	li	a2,0
    8020103c:	45a9                	li	a1,10
    8020103e:	853e                	mv	a0,a5
    80201040:	00000097          	auipc	ra,0x0
    80201044:	9bc080e7          	jalr	-1604(ra) # 802009fc <printint>
    consputc('\033');
    80201048:	04300513          	li	a0,67
    8020104c:	00000097          	auipc	ra,0x0
    80201050:	95c080e7          	jalr	-1700(ra) # 802009a8 <consputc>
    80201054:	a011                	j	80201058 <cursor_right+0x50>

    80201056:	0001                	nop
    consputc('[');
    80201058:	60e2                	ld	ra,24(sp)
    8020105a:	6442                	ld	s0,16(sp)
    8020105c:	6105                	addi	sp,sp,32
    8020105e:	8082                	ret

0000000080201060 <cursor_left>:
    printint(cols, 10, 0,0,0);
    consputc('D');
}
    80201060:	1101                	addi	sp,sp,-32
    80201062:	ec06                	sd	ra,24(sp)
    80201064:	e822                	sd	s0,16(sp)
    80201066:	1000                	addi	s0,sp,32
    80201068:	87aa                	mv	a5,a0
    8020106a:	fef42623          	sw	a5,-20(s0)
// 保存光标位置
    8020106e:	fec42783          	lw	a5,-20(s0)
    80201072:	2781                	sext.w	a5,a5
    80201074:	02f05d63          	blez	a5,802010ae <cursor_left+0x4e>
void save_cursor(void) {
    80201078:	456d                	li	a0,27
    8020107a:	00000097          	auipc	ra,0x0
    8020107e:	92e080e7          	jalr	-1746(ra) # 802009a8 <consputc>
    consputc('\033');
    80201082:	05b00513          	li	a0,91
    80201086:	00000097          	auipc	ra,0x0
    8020108a:	922080e7          	jalr	-1758(ra) # 802009a8 <consputc>
    consputc('[');
    8020108e:	fec42783          	lw	a5,-20(s0)
    80201092:	4601                	li	a2,0
    80201094:	45a9                	li	a1,10
    80201096:	853e                	mv	a0,a5
    80201098:	00000097          	auipc	ra,0x0
    8020109c:	964080e7          	jalr	-1692(ra) # 802009fc <printint>
    consputc('s');
    802010a0:	04400513          	li	a0,68
    802010a4:	00000097          	auipc	ra,0x0
    802010a8:	904080e7          	jalr	-1788(ra) # 802009a8 <consputc>
    802010ac:	a011                	j	802010b0 <cursor_left+0x50>
// 保存光标位置
    802010ae:	0001                	nop
}
    802010b0:	60e2                	ld	ra,24(sp)
    802010b2:	6442                	ld	s0,16(sp)
    802010b4:	6105                	addi	sp,sp,32
    802010b6:	8082                	ret

00000000802010b8 <save_cursor>:

// 恢复光标位置
    802010b8:	1141                	addi	sp,sp,-16
    802010ba:	e406                	sd	ra,8(sp)
    802010bc:	e022                	sd	s0,0(sp)
    802010be:	0800                	addi	s0,sp,16
void restore_cursor(void) {
    802010c0:	456d                	li	a0,27
    802010c2:	00000097          	auipc	ra,0x0
    802010c6:	8e6080e7          	jalr	-1818(ra) # 802009a8 <consputc>
    consputc('\033');
    802010ca:	05b00513          	li	a0,91
    802010ce:	00000097          	auipc	ra,0x0
    802010d2:	8da080e7          	jalr	-1830(ra) # 802009a8 <consputc>
    consputc('[');
    802010d6:	07300513          	li	a0,115
    802010da:	00000097          	auipc	ra,0x0
    802010de:	8ce080e7          	jalr	-1842(ra) # 802009a8 <consputc>
    consputc('u');
    802010e2:	0001                	nop
    802010e4:	60a2                	ld	ra,8(sp)
    802010e6:	6402                	ld	s0,0(sp)
    802010e8:	0141                	addi	sp,sp,16
    802010ea:	8082                	ret

00000000802010ec <restore_cursor>:
}

// 移动到行首
    802010ec:	1141                	addi	sp,sp,-16
    802010ee:	e406                	sd	ra,8(sp)
    802010f0:	e022                	sd	s0,0(sp)
    802010f2:	0800                	addi	s0,sp,16
void cursor_to_column(int col) {
    802010f4:	456d                	li	a0,27
    802010f6:	00000097          	auipc	ra,0x0
    802010fa:	8b2080e7          	jalr	-1870(ra) # 802009a8 <consputc>
    if (col <= 0) col = 1;
    802010fe:	05b00513          	li	a0,91
    80201102:	00000097          	auipc	ra,0x0
    80201106:	8a6080e7          	jalr	-1882(ra) # 802009a8 <consputc>
    consputc('\033');
    8020110a:	07500513          	li	a0,117
    8020110e:	00000097          	auipc	ra,0x0
    80201112:	89a080e7          	jalr	-1894(ra) # 802009a8 <consputc>
    consputc('[');
    80201116:	0001                	nop
    80201118:	60a2                	ld	ra,8(sp)
    8020111a:	6402                	ld	s0,0(sp)
    8020111c:	0141                	addi	sp,sp,16
    8020111e:	8082                	ret

0000000080201120 <cursor_to_column>:
    printint(col, 10, 0,0,0);
    consputc('G');
}
    80201120:	1101                	addi	sp,sp,-32
    80201122:	ec06                	sd	ra,24(sp)
    80201124:	e822                	sd	s0,16(sp)
    80201126:	1000                	addi	s0,sp,32
    80201128:	87aa                	mv	a5,a0
    8020112a:	fef42623          	sw	a5,-20(s0)
// 光标定位到指定行列
    8020112e:	fec42783          	lw	a5,-20(s0)
    80201132:	2781                	sext.w	a5,a5
    80201134:	00f04563          	bgtz	a5,8020113e <cursor_to_column+0x1e>
    80201138:	4785                	li	a5,1
    8020113a:	fef42623          	sw	a5,-20(s0)
void goto_rc(int row, int col) {
    8020113e:	456d                	li	a0,27
    80201140:	00000097          	auipc	ra,0x0
    80201144:	868080e7          	jalr	-1944(ra) # 802009a8 <consputc>
    consputc('\033');
    80201148:	05b00513          	li	a0,91
    8020114c:	00000097          	auipc	ra,0x0
    80201150:	85c080e7          	jalr	-1956(ra) # 802009a8 <consputc>
    consputc('[');
    80201154:	fec42783          	lw	a5,-20(s0)
    80201158:	4601                	li	a2,0
    8020115a:	45a9                	li	a1,10
    8020115c:	853e                	mv	a0,a5
    8020115e:	00000097          	auipc	ra,0x0
    80201162:	89e080e7          	jalr	-1890(ra) # 802009fc <printint>
    printint(row, 10, 0,0,0);
    80201166:	04700513          	li	a0,71
    8020116a:	00000097          	auipc	ra,0x0
    8020116e:	83e080e7          	jalr	-1986(ra) # 802009a8 <consputc>
    consputc(';');
    80201172:	0001                	nop
    80201174:	60e2                	ld	ra,24(sp)
    80201176:	6442                	ld	s0,16(sp)
    80201178:	6105                	addi	sp,sp,32
    8020117a:	8082                	ret

000000008020117c <goto_rc>:
    printint(col, 10, 0,0,0);
    consputc('H');
    8020117c:	1101                	addi	sp,sp,-32
    8020117e:	ec06                	sd	ra,24(sp)
    80201180:	e822                	sd	s0,16(sp)
    80201182:	1000                	addi	s0,sp,32
    80201184:	87aa                	mv	a5,a0
    80201186:	872e                	mv	a4,a1
    80201188:	fef42623          	sw	a5,-20(s0)
    8020118c:	87ba                	mv	a5,a4
    8020118e:	fef42423          	sw	a5,-24(s0)
}
    80201192:	456d                	li	a0,27
    80201194:	00000097          	auipc	ra,0x0
    80201198:	814080e7          	jalr	-2028(ra) # 802009a8 <consputc>
// 颜色控制
    8020119c:	05b00513          	li	a0,91
    802011a0:	00000097          	auipc	ra,0x0
    802011a4:	808080e7          	jalr	-2040(ra) # 802009a8 <consputc>
void reset_color(void) {
    802011a8:	fec42783          	lw	a5,-20(s0)
    802011ac:	4601                	li	a2,0
    802011ae:	45a9                	li	a1,10
    802011b0:	853e                	mv	a0,a5
    802011b2:	00000097          	auipc	ra,0x0
    802011b6:	84a080e7          	jalr	-1974(ra) # 802009fc <printint>
	uart_puts(ESC "[0m");
    802011ba:	03b00513          	li	a0,59
    802011be:	fffff097          	auipc	ra,0xfffff
    802011c2:	7ea080e7          	jalr	2026(ra) # 802009a8 <consputc>
}
    802011c6:	fe842783          	lw	a5,-24(s0)
    802011ca:	4601                	li	a2,0
    802011cc:	45a9                	li	a1,10
    802011ce:	853e                	mv	a0,a5
    802011d0:	00000097          	auipc	ra,0x0
    802011d4:	82c080e7          	jalr	-2004(ra) # 802009fc <printint>
// 设置前景色
    802011d8:	04800513          	li	a0,72
    802011dc:	fffff097          	auipc	ra,0xfffff
    802011e0:	7cc080e7          	jalr	1996(ra) # 802009a8 <consputc>
void set_fg_color(int color) {
    802011e4:	0001                	nop
    802011e6:	60e2                	ld	ra,24(sp)
    802011e8:	6442                	ld	s0,16(sp)
    802011ea:	6105                	addi	sp,sp,32
    802011ec:	8082                	ret

00000000802011ee <reset_color>:
	if (color < 30 || color > 37) return; // 支持30-37
	consputc('\033');
    802011ee:	1141                	addi	sp,sp,-16
    802011f0:	e406                	sd	ra,8(sp)
    802011f2:	e022                	sd	s0,0(sp)
    802011f4:	0800                	addi	s0,sp,16
	consputc('[');
    802011f6:	00005517          	auipc	a0,0x5
    802011fa:	41a50513          	addi	a0,a0,1050 # 80206610 <small_numbers+0x220>
    802011fe:	fffff097          	auipc	ra,0xfffff
    80201202:	436080e7          	jalr	1078(ra) # 80200634 <uart_puts>
	printint(color, 10, 0,0,0);
    80201206:	0001                	nop
    80201208:	60a2                	ld	ra,8(sp)
    8020120a:	6402                	ld	s0,0(sp)
    8020120c:	0141                	addi	sp,sp,16
    8020120e:	8082                	ret

0000000080201210 <set_fg_color>:
	consputc('m');
}
    80201210:	1101                	addi	sp,sp,-32
    80201212:	ec06                	sd	ra,24(sp)
    80201214:	e822                	sd	s0,16(sp)
    80201216:	1000                	addi	s0,sp,32
    80201218:	87aa                	mv	a5,a0
    8020121a:	fef42623          	sw	a5,-20(s0)
// 设置背景色
    8020121e:	fec42783          	lw	a5,-20(s0)
    80201222:	0007871b          	sext.w	a4,a5
    80201226:	47f5                	li	a5,29
    80201228:	04e7d563          	bge	a5,a4,80201272 <set_fg_color+0x62>
    8020122c:	fec42783          	lw	a5,-20(s0)
    80201230:	0007871b          	sext.w	a4,a5
    80201234:	02500793          	li	a5,37
    80201238:	02e7cd63          	blt	a5,a4,80201272 <set_fg_color+0x62>
void set_bg_color(int color) {
    8020123c:	456d                	li	a0,27
    8020123e:	fffff097          	auipc	ra,0xfffff
    80201242:	76a080e7          	jalr	1898(ra) # 802009a8 <consputc>
	if (color < 40 || color > 47) return; // 支持40-47
    80201246:	05b00513          	li	a0,91
    8020124a:	fffff097          	auipc	ra,0xfffff
    8020124e:	75e080e7          	jalr	1886(ra) # 802009a8 <consputc>
	consputc('\033');
    80201252:	fec42783          	lw	a5,-20(s0)
    80201256:	4601                	li	a2,0
    80201258:	45a9                	li	a1,10
    8020125a:	853e                	mv	a0,a5
    8020125c:	fffff097          	auipc	ra,0xfffff
    80201260:	7a0080e7          	jalr	1952(ra) # 802009fc <printint>
	consputc('[');
    80201264:	06d00513          	li	a0,109
    80201268:	fffff097          	auipc	ra,0xfffff
    8020126c:	740080e7          	jalr	1856(ra) # 802009a8 <consputc>
    80201270:	a011                	j	80201274 <set_fg_color+0x64>
// 设置背景色
    80201272:	0001                	nop
	printint(color, 10, 0,0,0);
    80201274:	60e2                	ld	ra,24(sp)
    80201276:	6442                	ld	s0,16(sp)
    80201278:	6105                	addi	sp,sp,32
    8020127a:	8082                	ret

000000008020127c <set_bg_color>:
	consputc('m');
}
    8020127c:	1101                	addi	sp,sp,-32
    8020127e:	ec06                	sd	ra,24(sp)
    80201280:	e822                	sd	s0,16(sp)
    80201282:	1000                	addi	s0,sp,32
    80201284:	87aa                	mv	a5,a0
    80201286:	fef42623          	sw	a5,-20(s0)
// 简易文字颜色
    8020128a:	fec42783          	lw	a5,-20(s0)
    8020128e:	0007871b          	sext.w	a4,a5
    80201292:	02700793          	li	a5,39
    80201296:	04e7d563          	bge	a5,a4,802012e0 <set_bg_color+0x64>
    8020129a:	fec42783          	lw	a5,-20(s0)
    8020129e:	0007871b          	sext.w	a4,a5
    802012a2:	02f00793          	li	a5,47
    802012a6:	02e7cd63          	blt	a5,a4,802012e0 <set_bg_color+0x64>
void color_red(void) {
    802012aa:	456d                	li	a0,27
    802012ac:	fffff097          	auipc	ra,0xfffff
    802012b0:	6fc080e7          	jalr	1788(ra) # 802009a8 <consputc>
	set_fg_color(31); // 红色
    802012b4:	05b00513          	li	a0,91
    802012b8:	fffff097          	auipc	ra,0xfffff
    802012bc:	6f0080e7          	jalr	1776(ra) # 802009a8 <consputc>
}
    802012c0:	fec42783          	lw	a5,-20(s0)
    802012c4:	4601                	li	a2,0
    802012c6:	45a9                	li	a1,10
    802012c8:	853e                	mv	a0,a5
    802012ca:	fffff097          	auipc	ra,0xfffff
    802012ce:	732080e7          	jalr	1842(ra) # 802009fc <printint>
void color_green(void) {
    802012d2:	06d00513          	li	a0,109
    802012d6:	fffff097          	auipc	ra,0xfffff
    802012da:	6d2080e7          	jalr	1746(ra) # 802009a8 <consputc>
    802012de:	a011                	j	802012e2 <set_bg_color+0x66>
// 简易文字颜色
    802012e0:	0001                	nop
	set_fg_color(32); // 绿色
    802012e2:	60e2                	ld	ra,24(sp)
    802012e4:	6442                	ld	s0,16(sp)
    802012e6:	6105                	addi	sp,sp,32
    802012e8:	8082                	ret

00000000802012ea <color_red>:
}
void color_yellow(void) {
    802012ea:	1141                	addi	sp,sp,-16
    802012ec:	e406                	sd	ra,8(sp)
    802012ee:	e022                	sd	s0,0(sp)
    802012f0:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    802012f2:	457d                	li	a0,31
    802012f4:	00000097          	auipc	ra,0x0
    802012f8:	f1c080e7          	jalr	-228(ra) # 80201210 <set_fg_color>
}
    802012fc:	0001                	nop
    802012fe:	60a2                	ld	ra,8(sp)
    80201300:	6402                	ld	s0,0(sp)
    80201302:	0141                	addi	sp,sp,16
    80201304:	8082                	ret

0000000080201306 <color_green>:
void color_blue(void) {
    80201306:	1141                	addi	sp,sp,-16
    80201308:	e406                	sd	ra,8(sp)
    8020130a:	e022                	sd	s0,0(sp)
    8020130c:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    8020130e:	02000513          	li	a0,32
    80201312:	00000097          	auipc	ra,0x0
    80201316:	efe080e7          	jalr	-258(ra) # 80201210 <set_fg_color>
}
    8020131a:	0001                	nop
    8020131c:	60a2                	ld	ra,8(sp)
    8020131e:	6402                	ld	s0,0(sp)
    80201320:	0141                	addi	sp,sp,16
    80201322:	8082                	ret

0000000080201324 <color_yellow>:
void color_purple(void) {
    80201324:	1141                	addi	sp,sp,-16
    80201326:	e406                	sd	ra,8(sp)
    80201328:	e022                	sd	s0,0(sp)
    8020132a:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    8020132c:	02100513          	li	a0,33
    80201330:	00000097          	auipc	ra,0x0
    80201334:	ee0080e7          	jalr	-288(ra) # 80201210 <set_fg_color>
}
    80201338:	0001                	nop
    8020133a:	60a2                	ld	ra,8(sp)
    8020133c:	6402                	ld	s0,0(sp)
    8020133e:	0141                	addi	sp,sp,16
    80201340:	8082                	ret

0000000080201342 <color_blue>:
void color_cyan(void) {
    80201342:	1141                	addi	sp,sp,-16
    80201344:	e406                	sd	ra,8(sp)
    80201346:	e022                	sd	s0,0(sp)
    80201348:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    8020134a:	02200513          	li	a0,34
    8020134e:	00000097          	auipc	ra,0x0
    80201352:	ec2080e7          	jalr	-318(ra) # 80201210 <set_fg_color>
}
    80201356:	0001                	nop
    80201358:	60a2                	ld	ra,8(sp)
    8020135a:	6402                	ld	s0,0(sp)
    8020135c:	0141                	addi	sp,sp,16
    8020135e:	8082                	ret

0000000080201360 <color_purple>:
void color_reverse(void){
    80201360:	1141                	addi	sp,sp,-16
    80201362:	e406                	sd	ra,8(sp)
    80201364:	e022                	sd	s0,0(sp)
    80201366:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    80201368:	02300513          	li	a0,35
    8020136c:	00000097          	auipc	ra,0x0
    80201370:	ea4080e7          	jalr	-348(ra) # 80201210 <set_fg_color>
}
    80201374:	0001                	nop
    80201376:	60a2                	ld	ra,8(sp)
    80201378:	6402                	ld	s0,0(sp)
    8020137a:	0141                	addi	sp,sp,16
    8020137c:	8082                	ret

000000008020137e <color_cyan>:
void set_color(int fg, int bg) {
    8020137e:	1141                	addi	sp,sp,-16
    80201380:	e406                	sd	ra,8(sp)
    80201382:	e022                	sd	s0,0(sp)
    80201384:	0800                	addi	s0,sp,16
	set_bg_color(bg);
    80201386:	02400513          	li	a0,36
    8020138a:	00000097          	auipc	ra,0x0
    8020138e:	e86080e7          	jalr	-378(ra) # 80201210 <set_fg_color>
	set_fg_color(fg);
    80201392:	0001                	nop
    80201394:	60a2                	ld	ra,8(sp)
    80201396:	6402                	ld	s0,0(sp)
    80201398:	0141                	addi	sp,sp,16
    8020139a:	8082                	ret

000000008020139c <color_reverse>:
}
    8020139c:	1141                	addi	sp,sp,-16
    8020139e:	e406                	sd	ra,8(sp)
    802013a0:	e022                	sd	s0,0(sp)
    802013a2:	0800                	addi	s0,sp,16
void clear_line(){
    802013a4:	02500513          	li	a0,37
    802013a8:	00000097          	auipc	ra,0x0
    802013ac:	e68080e7          	jalr	-408(ra) # 80201210 <set_fg_color>
	consputc('\033');
    802013b0:	0001                	nop
    802013b2:	60a2                	ld	ra,8(sp)
    802013b4:	6402                	ld	s0,0(sp)
    802013b6:	0141                	addi	sp,sp,16
    802013b8:	8082                	ret

00000000802013ba <set_color>:
	consputc('[');
    802013ba:	1101                	addi	sp,sp,-32
    802013bc:	ec06                	sd	ra,24(sp)
    802013be:	e822                	sd	s0,16(sp)
    802013c0:	1000                	addi	s0,sp,32
    802013c2:	87aa                	mv	a5,a0
    802013c4:	872e                	mv	a4,a1
    802013c6:	fef42623          	sw	a5,-20(s0)
    802013ca:	87ba                	mv	a5,a4
    802013cc:	fef42423          	sw	a5,-24(s0)
	consputc('2');
    802013d0:	fe842783          	lw	a5,-24(s0)
    802013d4:	853e                	mv	a0,a5
    802013d6:	00000097          	auipc	ra,0x0
    802013da:	ea6080e7          	jalr	-346(ra) # 8020127c <set_bg_color>
	consputc('K');
    802013de:	fec42783          	lw	a5,-20(s0)
    802013e2:	853e                	mv	a0,a5
    802013e4:	00000097          	auipc	ra,0x0
    802013e8:	e2c080e7          	jalr	-468(ra) # 80201210 <set_fg_color>
}
    802013ec:	0001                	nop
    802013ee:	60e2                	ld	ra,24(sp)
    802013f0:	6442                	ld	s0,16(sp)
    802013f2:	6105                	addi	sp,sp,32
    802013f4:	8082                	ret

00000000802013f6 <clear_line>:

    802013f6:	1141                	addi	sp,sp,-16
    802013f8:	e406                	sd	ra,8(sp)
    802013fa:	e022                	sd	s0,0(sp)
    802013fc:	0800                	addi	s0,sp,16
void panic(const char *msg) {
    802013fe:	456d                	li	a0,27
    80201400:	fffff097          	auipc	ra,0xfffff
    80201404:	5a8080e7          	jalr	1448(ra) # 802009a8 <consputc>
	color_red(); // 可选：红色显示
    80201408:	05b00513          	li	a0,91
    8020140c:	fffff097          	auipc	ra,0xfffff
    80201410:	59c080e7          	jalr	1436(ra) # 802009a8 <consputc>
	printf("panic: %s\n", msg);
    80201414:	03200513          	li	a0,50
    80201418:	fffff097          	auipc	ra,0xfffff
    8020141c:	590080e7          	jalr	1424(ra) # 802009a8 <consputc>
	reset_color();
    80201420:	04b00513          	li	a0,75
    80201424:	fffff097          	auipc	ra,0xfffff
    80201428:	584080e7          	jalr	1412(ra) # 802009a8 <consputc>
	while (1) { /* 死循环，防止继续执行 */ }
    8020142c:	0001                	nop
    8020142e:	60a2                	ld	ra,8(sp)
    80201430:	6402                	ld	s0,0(sp)
    80201432:	0141                	addi	sp,sp,16
    80201434:	8082                	ret

0000000080201436 <panic>:
}
void warning(const char *fmt, ...) {
    80201436:	1101                	addi	sp,sp,-32
    80201438:	ec06                	sd	ra,24(sp)
    8020143a:	e822                	sd	s0,16(sp)
    8020143c:	1000                	addi	s0,sp,32
    8020143e:	fea43423          	sd	a0,-24(s0)
    va_list ap;
    80201442:	00000097          	auipc	ra,0x0
    80201446:	ea8080e7          	jalr	-344(ra) # 802012ea <color_red>
    color_purple(); // 设置紫色
    8020144a:	fe843583          	ld	a1,-24(s0)
    8020144e:	00005517          	auipc	a0,0x5
    80201452:	1ca50513          	addi	a0,a0,458 # 80206618 <small_numbers+0x228>
    80201456:	fffff097          	auipc	ra,0xfffff
    8020145a:	6d8080e7          	jalr	1752(ra) # 80200b2e <printf>
    printf("[WARNING] ");
    8020145e:	00000097          	auipc	ra,0x0
    80201462:	d90080e7          	jalr	-624(ra) # 802011ee <reset_color>
    va_start(ap, fmt);
    80201466:	0001                	nop
    80201468:	bffd                	j	80201466 <panic+0x30>

000000008020146a <warning>:
    printf(fmt, ap);
    va_end(ap);
    8020146a:	7159                	addi	sp,sp,-112
    8020146c:	f406                	sd	ra,40(sp)
    8020146e:	f022                	sd	s0,32(sp)
    80201470:	1800                	addi	s0,sp,48
    80201472:	fca43c23          	sd	a0,-40(s0)
    80201476:	e40c                	sd	a1,8(s0)
    80201478:	e810                	sd	a2,16(s0)
    8020147a:	ec14                	sd	a3,24(s0)
    8020147c:	f018                	sd	a4,32(s0)
    8020147e:	f41c                	sd	a5,40(s0)
    80201480:	03043823          	sd	a6,48(s0)
    80201484:	03143c23          	sd	a7,56(s0)
    reset_color(); // 恢复默认颜色
}
    80201488:	00000097          	auipc	ra,0x0
    8020148c:	ed8080e7          	jalr	-296(ra) # 80201360 <color_purple>
void test_printf_precision(void) {
    80201490:	00005517          	auipc	a0,0x5
    80201494:	19850513          	addi	a0,a0,408 # 80206628 <small_numbers+0x238>
    80201498:	fffff097          	auipc	ra,0xfffff
    8020149c:	696080e7          	jalr	1686(ra) # 80200b2e <printf>
	clear_screen();
    802014a0:	04040793          	addi	a5,s0,64
    802014a4:	fcf43823          	sd	a5,-48(s0)
    802014a8:	fd043783          	ld	a5,-48(s0)
    802014ac:	fc878793          	addi	a5,a5,-56
    802014b0:	fef43423          	sd	a5,-24(s0)
    printf("=== 详细的Printf测试 ===\n");
    802014b4:	fe843783          	ld	a5,-24(s0)
    802014b8:	85be                	mv	a1,a5
    802014ba:	fd843503          	ld	a0,-40(s0)
    802014be:	fffff097          	auipc	ra,0xfffff
    802014c2:	670080e7          	jalr	1648(ra) # 80200b2e <printf>
    
    // 测试十六进制格式
    802014c6:	00000097          	auipc	ra,0x0
    802014ca:	d28080e7          	jalr	-728(ra) # 802011ee <reset_color>
    printf("十六进制测试:\n");
    802014ce:	0001                	nop
    802014d0:	70a2                	ld	ra,40(sp)
    802014d2:	7402                	ld	s0,32(sp)
    802014d4:	6165                	addi	sp,sp,112
    802014d6:	8082                	ret

00000000802014d8 <test_printf_precision>:
    printf("  255 = 0x%x (expected: ff)\n", 255);
    802014d8:	1101                	addi	sp,sp,-32
    802014da:	ec06                	sd	ra,24(sp)
    802014dc:	e822                	sd	s0,16(sp)
    802014de:	1000                	addi	s0,sp,32
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    802014e0:	00000097          	auipc	ra,0x0
    802014e4:	a46080e7          	jalr	-1466(ra) # 80200f26 <clear_screen>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    802014e8:	00005517          	auipc	a0,0x5
    802014ec:	15050513          	addi	a0,a0,336 # 80206638 <small_numbers+0x248>
    802014f0:	fffff097          	auipc	ra,0xfffff
    802014f4:	63e080e7          	jalr	1598(ra) # 80200b2e <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    802014f8:	00005517          	auipc	a0,0x5
    802014fc:	16050513          	addi	a0,a0,352 # 80206658 <small_numbers+0x268>
    80201500:	fffff097          	auipc	ra,0xfffff
    80201504:	62e080e7          	jalr	1582(ra) # 80200b2e <printf>
    printf("  正数: %d\n", 42);
    80201508:	0ff00593          	li	a1,255
    8020150c:	00005517          	auipc	a0,0x5
    80201510:	16450513          	addi	a0,a0,356 # 80206670 <small_numbers+0x280>
    80201514:	fffff097          	auipc	ra,0xfffff
    80201518:	61a080e7          	jalr	1562(ra) # 80200b2e <printf>
    printf("  负数: %d\n", -42);
    8020151c:	6585                	lui	a1,0x1
    8020151e:	00005517          	auipc	a0,0x5
    80201522:	17250513          	addi	a0,a0,370 # 80206690 <small_numbers+0x2a0>
    80201526:	fffff097          	auipc	ra,0xfffff
    8020152a:	608080e7          	jalr	1544(ra) # 80200b2e <printf>
    printf("  零: %d\n", 0);
    8020152e:	1234b7b7          	lui	a5,0x1234b
    80201532:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <userret+0x1234ab31>
    80201536:	00005517          	auipc	a0,0x5
    8020153a:	17a50513          	addi	a0,a0,378 # 802066b0 <small_numbers+0x2c0>
    8020153e:	fffff097          	auipc	ra,0xfffff
    80201542:	5f0080e7          	jalr	1520(ra) # 80200b2e <printf>
    printf("  大数: %d\n", 123456789);
    
    // 测试无符号格式
    80201546:	00005517          	auipc	a0,0x5
    8020154a:	18250513          	addi	a0,a0,386 # 802066c8 <small_numbers+0x2d8>
    8020154e:	fffff097          	auipc	ra,0xfffff
    80201552:	5e0080e7          	jalr	1504(ra) # 80200b2e <printf>
    printf("无符号测试:\n");
    80201556:	02a00593          	li	a1,42
    8020155a:	00005517          	auipc	a0,0x5
    8020155e:	18650513          	addi	a0,a0,390 # 802066e0 <small_numbers+0x2f0>
    80201562:	fffff097          	auipc	ra,0xfffff
    80201566:	5cc080e7          	jalr	1484(ra) # 80200b2e <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    8020156a:	fd600593          	li	a1,-42
    8020156e:	00005517          	auipc	a0,0x5
    80201572:	18250513          	addi	a0,a0,386 # 802066f0 <small_numbers+0x300>
    80201576:	fffff097          	auipc	ra,0xfffff
    8020157a:	5b8080e7          	jalr	1464(ra) # 80200b2e <printf>
    printf("  零：%u\n", 0U);
    8020157e:	4581                	li	a1,0
    80201580:	00005517          	auipc	a0,0x5
    80201584:	18050513          	addi	a0,a0,384 # 80206700 <small_numbers+0x310>
    80201588:	fffff097          	auipc	ra,0xfffff
    8020158c:	5a6080e7          	jalr	1446(ra) # 80200b2e <printf>
	printf("  小无符号数：%u\n", 12345U);
    80201590:	075bd7b7          	lui	a5,0x75bd
    80201594:	d1578593          	addi	a1,a5,-747 # 75bcd15 <userret+0x75bcc79>
    80201598:	00005517          	auipc	a0,0x5
    8020159c:	17850513          	addi	a0,a0,376 # 80206710 <small_numbers+0x320>
    802015a0:	fffff097          	auipc	ra,0xfffff
    802015a4:	58e080e7          	jalr	1422(ra) # 80200b2e <printf>

	// 测试边界
	printf("边界测试:\n");
    802015a8:	00005517          	auipc	a0,0x5
    802015ac:	17850513          	addi	a0,a0,376 # 80206720 <small_numbers+0x330>
    802015b0:	fffff097          	auipc	ra,0xfffff
    802015b4:	57e080e7          	jalr	1406(ra) # 80200b2e <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    802015b8:	55fd                	li	a1,-1
    802015ba:	00005517          	auipc	a0,0x5
    802015be:	17e50513          	addi	a0,a0,382 # 80206738 <small_numbers+0x348>
    802015c2:	fffff097          	auipc	ra,0xfffff
    802015c6:	56c080e7          	jalr	1388(ra) # 80200b2e <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    802015ca:	4581                	li	a1,0
    802015cc:	00005517          	auipc	a0,0x5
    802015d0:	18450513          	addi	a0,a0,388 # 80206750 <small_numbers+0x360>
    802015d4:	fffff097          	auipc	ra,0xfffff
    802015d8:	55a080e7          	jalr	1370(ra) # 80200b2e <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    802015dc:	678d                	lui	a5,0x3
    802015de:	03978593          	addi	a1,a5,57 # 3039 <userret+0x2f9d>
    802015e2:	00005517          	auipc	a0,0x5
    802015e6:	17e50513          	addi	a0,a0,382 # 80206760 <small_numbers+0x370>
    802015ea:	fffff097          	auipc	ra,0xfffff
    802015ee:	544080e7          	jalr	1348(ra) # 80200b2e <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    
    // 测试字符串边界情况
    802015f2:	00005517          	auipc	a0,0x5
    802015f6:	18650513          	addi	a0,a0,390 # 80206778 <small_numbers+0x388>
    802015fa:	fffff097          	auipc	ra,0xfffff
    802015fe:	534080e7          	jalr	1332(ra) # 80200b2e <printf>
    printf("字符串测试:\n");
    80201602:	800007b7          	lui	a5,0x80000
    80201606:	fff7c593          	not	a1,a5
    8020160a:	00005517          	auipc	a0,0x5
    8020160e:	17e50513          	addi	a0,a0,382 # 80206788 <small_numbers+0x398>
    80201612:	fffff097          	auipc	ra,0xfffff
    80201616:	51c080e7          	jalr	1308(ra) # 80200b2e <printf>
    printf("  空字符串: '%s'\n", "");
    8020161a:	800005b7          	lui	a1,0x80000
    8020161e:	00005517          	auipc	a0,0x5
    80201622:	17a50513          	addi	a0,a0,378 # 80206798 <small_numbers+0x3a8>
    80201626:	fffff097          	auipc	ra,0xfffff
    8020162a:	508080e7          	jalr	1288(ra) # 80200b2e <printf>
    printf("  单字符: '%s'\n", "X");
    8020162e:	55fd                	li	a1,-1
    80201630:	00005517          	auipc	a0,0x5
    80201634:	17850513          	addi	a0,a0,376 # 802067a8 <small_numbers+0x3b8>
    80201638:	fffff097          	auipc	ra,0xfffff
    8020163c:	4f6080e7          	jalr	1270(ra) # 80200b2e <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    80201640:	55fd                	li	a1,-1
    80201642:	00005517          	auipc	a0,0x5
    80201646:	17650513          	addi	a0,a0,374 # 802067b8 <small_numbers+0x3c8>
    8020164a:	fffff097          	auipc	ra,0xfffff
    8020164e:	4e4080e7          	jalr	1252(ra) # 80200b2e <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
	
	// 测试混合格式
    80201652:	00005517          	auipc	a0,0x5
    80201656:	17e50513          	addi	a0,a0,382 # 802067d0 <small_numbers+0x3e0>
    8020165a:	fffff097          	auipc	ra,0xfffff
    8020165e:	4d4080e7          	jalr	1236(ra) # 80200b2e <printf>
	printf("混合格式测试:\n");
    80201662:	00005597          	auipc	a1,0x5
    80201666:	18658593          	addi	a1,a1,390 # 802067e8 <small_numbers+0x3f8>
    8020166a:	00005517          	auipc	a0,0x5
    8020166e:	18650513          	addi	a0,a0,390 # 802067f0 <small_numbers+0x400>
    80201672:	fffff097          	auipc	ra,0xfffff
    80201676:	4bc080e7          	jalr	1212(ra) # 80200b2e <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    8020167a:	00005597          	auipc	a1,0x5
    8020167e:	18e58593          	addi	a1,a1,398 # 80206808 <small_numbers+0x418>
    80201682:	00005517          	auipc	a0,0x5
    80201686:	18e50513          	addi	a0,a0,398 # 80206810 <small_numbers+0x420>
    8020168a:	fffff097          	auipc	ra,0xfffff
    8020168e:	4a4080e7          	jalr	1188(ra) # 80200b2e <printf>
	
    80201692:	00005597          	auipc	a1,0x5
    80201696:	19658593          	addi	a1,a1,406 # 80206828 <small_numbers+0x438>
    8020169a:	00005517          	auipc	a0,0x5
    8020169e:	1ae50513          	addi	a0,a0,430 # 80206848 <small_numbers+0x458>
    802016a2:	fffff097          	auipc	ra,0xfffff
    802016a6:	48c080e7          	jalr	1164(ra) # 80200b2e <printf>
	// 测试百分号输出
    802016aa:	00005597          	auipc	a1,0x5
    802016ae:	1b658593          	addi	a1,a1,438 # 80206860 <small_numbers+0x470>
    802016b2:	00005517          	auipc	a0,0x5
    802016b6:	2fe50513          	addi	a0,a0,766 # 802069b0 <small_numbers+0x5c0>
    802016ba:	fffff097          	auipc	ra,0xfffff
    802016be:	474080e7          	jalr	1140(ra) # 80200b2e <printf>
	printf("百分号输出测试:\n");
	printf("  100%% 完成!\n");
	
    802016c2:	00005517          	auipc	a0,0x5
    802016c6:	30e50513          	addi	a0,a0,782 # 802069d0 <small_numbers+0x5e0>
    802016ca:	fffff097          	auipc	ra,0xfffff
    802016ce:	464080e7          	jalr	1124(ra) # 80200b2e <printf>
	// 测试NULL字符串
    802016d2:	0ff00693          	li	a3,255
    802016d6:	f0100613          	li	a2,-255
    802016da:	0ff00593          	li	a1,255
    802016de:	00005517          	auipc	a0,0x5
    802016e2:	30a50513          	addi	a0,a0,778 # 802069e8 <small_numbers+0x5f8>
    802016e6:	fffff097          	auipc	ra,0xfffff
    802016ea:	448080e7          	jalr	1096(ra) # 80200b2e <printf>
	char *null_str = 0;
	printf("NULL字符串测试:\n");
	printf("  NULL as string: '%s'\n", null_str);
    802016ee:	00005517          	auipc	a0,0x5
    802016f2:	32250513          	addi	a0,a0,802 # 80206a10 <small_numbers+0x620>
    802016f6:	fffff097          	auipc	ra,0xfffff
    802016fa:	438080e7          	jalr	1080(ra) # 80200b2e <printf>
	
    802016fe:	00005517          	auipc	a0,0x5
    80201702:	32a50513          	addi	a0,a0,810 # 80206a28 <small_numbers+0x638>
    80201706:	fffff097          	auipc	ra,0xfffff
    8020170a:	428080e7          	jalr	1064(ra) # 80200b2e <printf>
	// 测试指针格式
	int var = 42;
	printf("指针测试:\n");
    8020170e:	fe043423          	sd	zero,-24(s0)
	printf("  Address of var: %p\n", &var);
    80201712:	00005517          	auipc	a0,0x5
    80201716:	32e50513          	addi	a0,a0,814 # 80206a40 <small_numbers+0x650>
    8020171a:	fffff097          	auipc	ra,0xfffff
    8020171e:	414080e7          	jalr	1044(ra) # 80200b2e <printf>
	
    80201722:	fe843583          	ld	a1,-24(s0)
    80201726:	00005517          	auipc	a0,0x5
    8020172a:	33250513          	addi	a0,a0,818 # 80206a58 <small_numbers+0x668>
    8020172e:	fffff097          	auipc	ra,0xfffff
    80201732:	400080e7          	jalr	1024(ra) # 80200b2e <printf>
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201736:	02a00793          	li	a5,42
    8020173a:	fef42223          	sw	a5,-28(s0)
	
    8020173e:	00005517          	auipc	a0,0x5
    80201742:	33250513          	addi	a0,a0,818 # 80206a70 <small_numbers+0x680>
    80201746:	fffff097          	auipc	ra,0xfffff
    8020174a:	3e8080e7          	jalr	1000(ra) # 80200b2e <printf>
	// 测试不同进制的数字
    8020174e:	fe440793          	addi	a5,s0,-28
    80201752:	85be                	mv	a1,a5
    80201754:	00005517          	auipc	a0,0x5
    80201758:	32c50513          	addi	a0,a0,812 # 80206a80 <small_numbers+0x690>
    8020175c:	fffff097          	auipc	ra,0xfffff
    80201760:	3d2080e7          	jalr	978(ra) # 80200b2e <printf>
	printf("不同进制测试:\n");
	printf("  Binary of 5: %b\n", 5);
	printf("  Octal of 8 : %o\n", 8); 
    80201764:	00005517          	auipc	a0,0x5
    80201768:	33450513          	addi	a0,a0,820 # 80206a98 <small_numbers+0x6a8>
    8020176c:	fffff097          	auipc	ra,0xfffff
    80201770:	3c2080e7          	jalr	962(ra) # 80200b2e <printf>
	printf("=== Printf测试结束 ===\n");
    80201774:	55fd                	li	a1,-1
    80201776:	00005517          	auipc	a0,0x5
    8020177a:	34250513          	addi	a0,a0,834 # 80206ab8 <small_numbers+0x6c8>
    8020177e:	fffff097          	auipc	ra,0xfffff
    80201782:	3b0080e7          	jalr	944(ra) # 80200b2e <printf>
}
void test_curse_move(){
	clear_screen(); // 清屏
    80201786:	00005517          	auipc	a0,0x5
    8020178a:	34a50513          	addi	a0,a0,842 # 80206ad0 <small_numbers+0x6e0>
    8020178e:	fffff097          	auipc	ra,0xfffff
    80201792:	3a0080e7          	jalr	928(ra) # 80200b2e <printf>
	printf("=== 光标移动测试 ===\n");
    80201796:	4595                	li	a1,5
    80201798:	00005517          	auipc	a0,0x5
    8020179c:	35050513          	addi	a0,a0,848 # 80206ae8 <small_numbers+0x6f8>
    802017a0:	fffff097          	auipc	ra,0xfffff
    802017a4:	38e080e7          	jalr	910(ra) # 80200b2e <printf>
	for (int i = 3; i <= 7; i++) {
    802017a8:	45a1                	li	a1,8
    802017aa:	00005517          	auipc	a0,0x5
    802017ae:	35650513          	addi	a0,a0,854 # 80206b00 <small_numbers+0x710>
    802017b2:	fffff097          	auipc	ra,0xfffff
    802017b6:	37c080e7          	jalr	892(ra) # 80200b2e <printf>
		for (int j = 1; j <= 10; j++) {
    802017ba:	00005517          	auipc	a0,0x5
    802017be:	35e50513          	addi	a0,a0,862 # 80206b18 <small_numbers+0x728>
    802017c2:	fffff097          	auipc	ra,0xfffff
    802017c6:	36c080e7          	jalr	876(ra) # 80200b2e <printf>
			goto_rc(i, j);
    802017ca:	0001                	nop
    802017cc:	60e2                	ld	ra,24(sp)
    802017ce:	6442                	ld	s0,16(sp)
    802017d0:	6105                	addi	sp,sp,32
    802017d2:	8082                	ret

00000000802017d4 <test_curse_move>:
			printf("*");
    802017d4:	1101                	addi	sp,sp,-32
    802017d6:	ec06                	sd	ra,24(sp)
    802017d8:	e822                	sd	s0,16(sp)
    802017da:	1000                	addi	s0,sp,32
		}
    802017dc:	fffff097          	auipc	ra,0xfffff
    802017e0:	74a080e7          	jalr	1866(ra) # 80200f26 <clear_screen>
	}
    802017e4:	00005517          	auipc	a0,0x5
    802017e8:	35450513          	addi	a0,a0,852 # 80206b38 <small_numbers+0x748>
    802017ec:	fffff097          	auipc	ra,0xfffff
    802017f0:	342080e7          	jalr	834(ra) # 80200b2e <printf>
	goto_rc(9, 1);
    802017f4:	478d                	li	a5,3
    802017f6:	fef42623          	sw	a5,-20(s0)
    802017fa:	a881                	j	8020184a <test_curse_move+0x76>
	save_cursor();
    802017fc:	4785                	li	a5,1
    802017fe:	fef42423          	sw	a5,-24(s0)
    80201802:	a805                	j	80201832 <test_curse_move+0x5e>
	// 光标移动测试
    80201804:	fe842703          	lw	a4,-24(s0)
    80201808:	fec42783          	lw	a5,-20(s0)
    8020180c:	85ba                	mv	a1,a4
    8020180e:	853e                	mv	a0,a5
    80201810:	00000097          	auipc	ra,0x0
    80201814:	96c080e7          	jalr	-1684(ra) # 8020117c <goto_rc>
	cursor_up(5);
    80201818:	00005517          	auipc	a0,0x5
    8020181c:	34050513          	addi	a0,a0,832 # 80206b58 <small_numbers+0x768>
    80201820:	fffff097          	auipc	ra,0xfffff
    80201824:	30e080e7          	jalr	782(ra) # 80200b2e <printf>
	save_cursor();
    80201828:	fe842783          	lw	a5,-24(s0)
    8020182c:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdf3bb1>
    8020182e:	fef42423          	sw	a5,-24(s0)
    80201832:	fe842783          	lw	a5,-24(s0)
    80201836:	0007871b          	sext.w	a4,a5
    8020183a:	47a9                	li	a5,10
    8020183c:	fce7d4e3          	bge	a5,a4,80201804 <test_curse_move+0x30>
	goto_rc(9, 1);
    80201840:	fec42783          	lw	a5,-20(s0)
    80201844:	2785                	addiw	a5,a5,1
    80201846:	fef42623          	sw	a5,-20(s0)
    8020184a:	fec42783          	lw	a5,-20(s0)
    8020184e:	0007871b          	sext.w	a4,a5
    80201852:	479d                	li	a5,7
    80201854:	fae7d4e3          	bge	a5,a4,802017fc <test_curse_move+0x28>
	cursor_right(2);
	printf("+++++");
	cursor_down(2);
    80201858:	4585                	li	a1,1
    8020185a:	4525                	li	a0,9
    8020185c:	00000097          	auipc	ra,0x0
    80201860:	920080e7          	jalr	-1760(ra) # 8020117c <goto_rc>
	cursor_left(5);
    80201864:	00000097          	auipc	ra,0x0
    80201868:	854080e7          	jalr	-1964(ra) # 802010b8 <save_cursor>
	printf("-----");
	restore_cursor();
    8020186c:	4515                	li	a0,5
    8020186e:	fffff097          	auipc	ra,0xfffff
    80201872:	6ea080e7          	jalr	1770(ra) # 80200f58 <cursor_up>
	printf("=== 光标移动测试结束 ===\n");
    80201876:	4509                	li	a0,2
    80201878:	fffff097          	auipc	ra,0xfffff
    8020187c:	790080e7          	jalr	1936(ra) # 80201008 <cursor_right>
}
    80201880:	00005517          	auipc	a0,0x5
    80201884:	2e050513          	addi	a0,a0,736 # 80206b60 <small_numbers+0x770>
    80201888:	fffff097          	auipc	ra,0xfffff
    8020188c:	2a6080e7          	jalr	678(ra) # 80200b2e <printf>

    80201890:	4509                	li	a0,2
    80201892:	fffff097          	auipc	ra,0xfffff
    80201896:	71e080e7          	jalr	1822(ra) # 80200fb0 <cursor_down>
void test_basic_colors(void) {
    8020189a:	4515                	li	a0,5
    8020189c:	fffff097          	auipc	ra,0xfffff
    802018a0:	7c4080e7          	jalr	1988(ra) # 80201060 <cursor_left>
    clear_screen();
    802018a4:	00005517          	auipc	a0,0x5
    802018a8:	2c450513          	addi	a0,a0,708 # 80206b68 <small_numbers+0x778>
    802018ac:	fffff097          	auipc	ra,0xfffff
    802018b0:	282080e7          	jalr	642(ra) # 80200b2e <printf>
    printf("=== 基本颜色测试 ===\n\n");
    802018b4:	00000097          	auipc	ra,0x0
    802018b8:	838080e7          	jalr	-1992(ra) # 802010ec <restore_cursor>
    
    802018bc:	00005517          	auipc	a0,0x5
    802018c0:	2b450513          	addi	a0,a0,692 # 80206b70 <small_numbers+0x780>
    802018c4:	fffff097          	auipc	ra,0xfffff
    802018c8:	26a080e7          	jalr	618(ra) # 80200b2e <printf>
    // 测试基本前景色
    802018cc:	0001                	nop
    802018ce:	60e2                	ld	ra,24(sp)
    802018d0:	6442                	ld	s0,16(sp)
    802018d2:	6105                	addi	sp,sp,32
    802018d4:	8082                	ret

00000000802018d6 <test_basic_colors>:
    printf("前景色测试:\n");
    color_red();    printf("红色文字 ");
    802018d6:	1141                	addi	sp,sp,-16
    802018d8:	e406                	sd	ra,8(sp)
    802018da:	e022                	sd	s0,0(sp)
    802018dc:	0800                	addi	s0,sp,16
    color_green();  printf("绿色文字 ");
    802018de:	fffff097          	auipc	ra,0xfffff
    802018e2:	648080e7          	jalr	1608(ra) # 80200f26 <clear_screen>
    color_yellow(); printf("黄色文字 ");
    802018e6:	00005517          	auipc	a0,0x5
    802018ea:	2b250513          	addi	a0,a0,690 # 80206b98 <small_numbers+0x7a8>
    802018ee:	fffff097          	auipc	ra,0xfffff
    802018f2:	240080e7          	jalr	576(ra) # 80200b2e <printf>
    color_blue();   printf("蓝色文字 ");
    color_purple(); printf("紫色文字 ");
    color_cyan();   printf("青色文字 ");
    802018f6:	00005517          	auipc	a0,0x5
    802018fa:	2c250513          	addi	a0,a0,706 # 80206bb8 <small_numbers+0x7c8>
    802018fe:	fffff097          	auipc	ra,0xfffff
    80201902:	230080e7          	jalr	560(ra) # 80200b2e <printf>
    color_reverse();  printf("反色文字");
    80201906:	00000097          	auipc	ra,0x0
    8020190a:	9e4080e7          	jalr	-1564(ra) # 802012ea <color_red>
    8020190e:	00005517          	auipc	a0,0x5
    80201912:	2c250513          	addi	a0,a0,706 # 80206bd0 <small_numbers+0x7e0>
    80201916:	fffff097          	auipc	ra,0xfffff
    8020191a:	218080e7          	jalr	536(ra) # 80200b2e <printf>
    reset_color();
    8020191e:	00000097          	auipc	ra,0x0
    80201922:	9e8080e7          	jalr	-1560(ra) # 80201306 <color_green>
    80201926:	00005517          	auipc	a0,0x5
    8020192a:	2ba50513          	addi	a0,a0,698 # 80206be0 <small_numbers+0x7f0>
    8020192e:	fffff097          	auipc	ra,0xfffff
    80201932:	200080e7          	jalr	512(ra) # 80200b2e <printf>
    printf("\n\n");
    80201936:	00000097          	auipc	ra,0x0
    8020193a:	9ee080e7          	jalr	-1554(ra) # 80201324 <color_yellow>
    8020193e:	00005517          	auipc	a0,0x5
    80201942:	2b250513          	addi	a0,a0,690 # 80206bf0 <small_numbers+0x800>
    80201946:	fffff097          	auipc	ra,0xfffff
    8020194a:	1e8080e7          	jalr	488(ra) # 80200b2e <printf>
    
    8020194e:	00000097          	auipc	ra,0x0
    80201952:	9f4080e7          	jalr	-1548(ra) # 80201342 <color_blue>
    80201956:	00005517          	auipc	a0,0x5
    8020195a:	2aa50513          	addi	a0,a0,682 # 80206c00 <small_numbers+0x810>
    8020195e:	fffff097          	auipc	ra,0xfffff
    80201962:	1d0080e7          	jalr	464(ra) # 80200b2e <printf>
    // 测试背景色
    80201966:	00000097          	auipc	ra,0x0
    8020196a:	9fa080e7          	jalr	-1542(ra) # 80201360 <color_purple>
    8020196e:	00005517          	auipc	a0,0x5
    80201972:	2a250513          	addi	a0,a0,674 # 80206c10 <small_numbers+0x820>
    80201976:	fffff097          	auipc	ra,0xfffff
    8020197a:	1b8080e7          	jalr	440(ra) # 80200b2e <printf>
    printf("背景色测试:\n");
    8020197e:	00000097          	auipc	ra,0x0
    80201982:	a00080e7          	jalr	-1536(ra) # 8020137e <color_cyan>
    80201986:	00005517          	auipc	a0,0x5
    8020198a:	29a50513          	addi	a0,a0,666 # 80206c20 <small_numbers+0x830>
    8020198e:	fffff097          	auipc	ra,0xfffff
    80201992:	1a0080e7          	jalr	416(ra) # 80200b2e <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80201996:	00000097          	auipc	ra,0x0
    8020199a:	a06080e7          	jalr	-1530(ra) # 8020139c <color_reverse>
    8020199e:	00005517          	auipc	a0,0x5
    802019a2:	29250513          	addi	a0,a0,658 # 80206c30 <small_numbers+0x840>
    802019a6:	fffff097          	auipc	ra,0xfffff
    802019aa:	188080e7          	jalr	392(ra) # 80200b2e <printf>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    802019ae:	00000097          	auipc	ra,0x0
    802019b2:	840080e7          	jalr	-1984(ra) # 802011ee <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    802019b6:	00005517          	auipc	a0,0x5
    802019ba:	28a50513          	addi	a0,a0,650 # 80206c40 <small_numbers+0x850>
    802019be:	fffff097          	auipc	ra,0xfffff
    802019c2:	170080e7          	jalr	368(ra) # 80200b2e <printf>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    printf("\n\n");
    802019c6:	00005517          	auipc	a0,0x5
    802019ca:	28250513          	addi	a0,a0,642 # 80206c48 <small_numbers+0x858>
    802019ce:	fffff097          	auipc	ra,0xfffff
    802019d2:	160080e7          	jalr	352(ra) # 80200b2e <printf>
    
    802019d6:	02900513          	li	a0,41
    802019da:	00000097          	auipc	ra,0x0
    802019de:	8a2080e7          	jalr	-1886(ra) # 8020127c <set_bg_color>
    802019e2:	00005517          	auipc	a0,0x5
    802019e6:	27e50513          	addi	a0,a0,638 # 80206c60 <small_numbers+0x870>
    802019ea:	fffff097          	auipc	ra,0xfffff
    802019ee:	144080e7          	jalr	324(ra) # 80200b2e <printf>
    802019f2:	fffff097          	auipc	ra,0xfffff
    802019f6:	7fc080e7          	jalr	2044(ra) # 802011ee <reset_color>
    // 测试组合效果
    802019fa:	02a00513          	li	a0,42
    802019fe:	00000097          	auipc	ra,0x0
    80201a02:	87e080e7          	jalr	-1922(ra) # 8020127c <set_bg_color>
    80201a06:	00005517          	auipc	a0,0x5
    80201a0a:	26a50513          	addi	a0,a0,618 # 80206c70 <small_numbers+0x880>
    80201a0e:	fffff097          	auipc	ra,0xfffff
    80201a12:	120080e7          	jalr	288(ra) # 80200b2e <printf>
    80201a16:	fffff097          	auipc	ra,0xfffff
    80201a1a:	7d8080e7          	jalr	2008(ra) # 802011ee <reset_color>
    printf("组合效果测试:\n");
    80201a1e:	02b00513          	li	a0,43
    80201a22:	00000097          	auipc	ra,0x0
    80201a26:	85a080e7          	jalr	-1958(ra) # 8020127c <set_bg_color>
    80201a2a:	00005517          	auipc	a0,0x5
    80201a2e:	25650513          	addi	a0,a0,598 # 80206c80 <small_numbers+0x890>
    80201a32:	fffff097          	auipc	ra,0xfffff
    80201a36:	0fc080e7          	jalr	252(ra) # 80200b2e <printf>
    80201a3a:	fffff097          	auipc	ra,0xfffff
    80201a3e:	7b4080e7          	jalr	1972(ra) # 802011ee <reset_color>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201a42:	02c00513          	li	a0,44
    80201a46:	00000097          	auipc	ra,0x0
    80201a4a:	836080e7          	jalr	-1994(ra) # 8020127c <set_bg_color>
    80201a4e:	00005517          	auipc	a0,0x5
    80201a52:	24250513          	addi	a0,a0,578 # 80206c90 <small_numbers+0x8a0>
    80201a56:	fffff097          	auipc	ra,0xfffff
    80201a5a:	0d8080e7          	jalr	216(ra) # 80200b2e <printf>
    80201a5e:	fffff097          	auipc	ra,0xfffff
    80201a62:	790080e7          	jalr	1936(ra) # 802011ee <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201a66:	02f00513          	li	a0,47
    80201a6a:	00000097          	auipc	ra,0x0
    80201a6e:	812080e7          	jalr	-2030(ra) # 8020127c <set_bg_color>
    80201a72:	00005517          	auipc	a0,0x5
    80201a76:	22e50513          	addi	a0,a0,558 # 80206ca0 <small_numbers+0x8b0>
    80201a7a:	fffff097          	auipc	ra,0xfffff
    80201a7e:	0b4080e7          	jalr	180(ra) # 80200b2e <printf>
    80201a82:	fffff097          	auipc	ra,0xfffff
    80201a86:	76c080e7          	jalr	1900(ra) # 802011ee <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201a8a:	00005517          	auipc	a0,0x5
    80201a8e:	1b650513          	addi	a0,a0,438 # 80206c40 <small_numbers+0x850>
    80201a92:	fffff097          	auipc	ra,0xfffff
    80201a96:	09c080e7          	jalr	156(ra) # 80200b2e <printf>
    printf("\n\n");
	reset_color();
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201a9a:	00005517          	auipc	a0,0x5
    80201a9e:	21650513          	addi	a0,a0,534 # 80206cb0 <small_numbers+0x8c0>
    80201aa2:	fffff097          	auipc	ra,0xfffff
    80201aa6:	08c080e7          	jalr	140(ra) # 80200b2e <printf>
	cursor_up(1); // 光标上移一行
    80201aaa:	02c00593          	li	a1,44
    80201aae:	457d                	li	a0,31
    80201ab0:	00000097          	auipc	ra,0x0
    80201ab4:	90a080e7          	jalr	-1782(ra) # 802013ba <set_color>
    80201ab8:	00005517          	auipc	a0,0x5
    80201abc:	21050513          	addi	a0,a0,528 # 80206cc8 <small_numbers+0x8d8>
    80201ac0:	fffff097          	auipc	ra,0xfffff
    80201ac4:	06e080e7          	jalr	110(ra) # 80200b2e <printf>
    80201ac8:	fffff097          	auipc	ra,0xfffff
    80201acc:	726080e7          	jalr	1830(ra) # 802011ee <reset_color>
	clear_line();
    80201ad0:	02d00593          	li	a1,45
    80201ad4:	02100513          	li	a0,33
    80201ad8:	00000097          	auipc	ra,0x0
    80201adc:	8e2080e7          	jalr	-1822(ra) # 802013ba <set_color>
    80201ae0:	00005517          	auipc	a0,0x5
    80201ae4:	1f850513          	addi	a0,a0,504 # 80206cd8 <small_numbers+0x8e8>
    80201ae8:	fffff097          	auipc	ra,0xfffff
    80201aec:	046080e7          	jalr	70(ra) # 80200b2e <printf>
    80201af0:	fffff097          	auipc	ra,0xfffff
    80201af4:	6fe080e7          	jalr	1790(ra) # 802011ee <reset_color>

    80201af8:	02f00593          	li	a1,47
    80201afc:	02000513          	li	a0,32
    80201b00:	00000097          	auipc	ra,0x0
    80201b04:	8ba080e7          	jalr	-1862(ra) # 802013ba <set_color>
    80201b08:	00005517          	auipc	a0,0x5
    80201b0c:	1e050513          	addi	a0,a0,480 # 80206ce8 <small_numbers+0x8f8>
    80201b10:	fffff097          	auipc	ra,0xfffff
    80201b14:	01e080e7          	jalr	30(ra) # 80200b2e <printf>
    80201b18:	fffff097          	auipc	ra,0xfffff
    80201b1c:	6d6080e7          	jalr	1750(ra) # 802011ee <reset_color>
	printf("=== 颜色测试结束 ===\n");
    80201b20:	00005517          	auipc	a0,0x5
    80201b24:	12050513          	addi	a0,a0,288 # 80206c40 <small_numbers+0x850>
    80201b28:	fffff097          	auipc	ra,0xfffff
    80201b2c:	006080e7          	jalr	6(ra) # 80200b2e <printf>
    80201b30:	fffff097          	auipc	ra,0xfffff
    80201b34:	6be080e7          	jalr	1726(ra) # 802011ee <reset_color>
    80201b38:	00005517          	auipc	a0,0x5
    80201b3c:	1c050513          	addi	a0,a0,448 # 80206cf8 <small_numbers+0x908>
    80201b40:	fffff097          	auipc	ra,0xfffff
    80201b44:	fee080e7          	jalr	-18(ra) # 80200b2e <printf>
    80201b48:	4505                	li	a0,1
    80201b4a:	fffff097          	auipc	ra,0xfffff
    80201b4e:	40e080e7          	jalr	1038(ra) # 80200f58 <cursor_up>
    80201b52:	00000097          	auipc	ra,0x0
    80201b56:	8a4080e7          	jalr	-1884(ra) # 802013f6 <clear_line>
    80201b5a:	00005517          	auipc	a0,0x5
    80201b5e:	1d650513          	addi	a0,a0,470 # 80206d30 <small_numbers+0x940>
    80201b62:	fffff097          	auipc	ra,0xfffff
    80201b66:	fcc080e7          	jalr	-52(ra) # 80200b2e <printf>
    80201b6a:	0001                	nop
    80201b6c:	60a2                	ld	ra,8(sp)
    80201b6e:	6402                	ld	s0,0(sp)
    80201b70:	0141                	addi	sp,sp,16
    80201b72:	8082                	ret

0000000080201b74 <memset>:
#include "defs.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201b74:	7139                	addi	sp,sp,-64
    80201b76:	fc22                	sd	s0,56(sp)
    80201b78:	0080                	addi	s0,sp,64
    80201b7a:	fca43c23          	sd	a0,-40(s0)
    80201b7e:	87ae                	mv	a5,a1
    80201b80:	fcc43423          	sd	a2,-56(s0)
    80201b84:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201b88:	fd843783          	ld	a5,-40(s0)
    80201b8c:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    80201b90:	a829                	j	80201baa <memset+0x36>
        *p++ = (unsigned char)c;
    80201b92:	fe843783          	ld	a5,-24(s0)
    80201b96:	00178713          	addi	a4,a5,1
    80201b9a:	fee43423          	sd	a4,-24(s0)
    80201b9e:	fd442703          	lw	a4,-44(s0)
    80201ba2:	0ff77713          	zext.b	a4,a4
    80201ba6:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    80201baa:	fc843783          	ld	a5,-56(s0)
    80201bae:	fff78713          	addi	a4,a5,-1
    80201bb2:	fce43423          	sd	a4,-56(s0)
    80201bb6:	fff1                	bnez	a5,80201b92 <memset+0x1e>
    return dst;
    80201bb8:	fd843783          	ld	a5,-40(s0)
}
    80201bbc:	853e                	mv	a0,a5
    80201bbe:	7462                	ld	s0,56(sp)
    80201bc0:	6121                	addi	sp,sp,64
    80201bc2:	8082                	ret

0000000080201bc4 <memmove>:
void *memmove(void *dst, const void *src, unsigned long n) {
    80201bc4:	7139                	addi	sp,sp,-64
    80201bc6:	fc22                	sd	s0,56(sp)
    80201bc8:	0080                	addi	s0,sp,64
    80201bca:	fca43c23          	sd	a0,-40(s0)
    80201bce:	fcb43823          	sd	a1,-48(s0)
    80201bd2:	fcc43423          	sd	a2,-56(s0)
	unsigned char *d = dst;
    80201bd6:	fd843783          	ld	a5,-40(s0)
    80201bda:	fef43423          	sd	a5,-24(s0)
	const unsigned char *s = src;
    80201bde:	fd043783          	ld	a5,-48(s0)
    80201be2:	fef43023          	sd	a5,-32(s0)
	if (d < s) {
    80201be6:	fe843703          	ld	a4,-24(s0)
    80201bea:	fe043783          	ld	a5,-32(s0)
    80201bee:	02f77b63          	bgeu	a4,a5,80201c24 <memmove+0x60>
		while (n-- > 0)
    80201bf2:	a00d                	j	80201c14 <memmove+0x50>
			*d++ = *s++;
    80201bf4:	fe043703          	ld	a4,-32(s0)
    80201bf8:	00170793          	addi	a5,a4,1
    80201bfc:	fef43023          	sd	a5,-32(s0)
    80201c00:	fe843783          	ld	a5,-24(s0)
    80201c04:	00178693          	addi	a3,a5,1
    80201c08:	fed43423          	sd	a3,-24(s0)
    80201c0c:	00074703          	lbu	a4,0(a4)
    80201c10:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201c14:	fc843783          	ld	a5,-56(s0)
    80201c18:	fff78713          	addi	a4,a5,-1
    80201c1c:	fce43423          	sd	a4,-56(s0)
    80201c20:	fbf1                	bnez	a5,80201bf4 <memmove+0x30>
    80201c22:	a889                	j	80201c74 <memmove+0xb0>
	} else {
		d += n;
    80201c24:	fe843703          	ld	a4,-24(s0)
    80201c28:	fc843783          	ld	a5,-56(s0)
    80201c2c:	97ba                	add	a5,a5,a4
    80201c2e:	fef43423          	sd	a5,-24(s0)
		s += n;
    80201c32:	fe043703          	ld	a4,-32(s0)
    80201c36:	fc843783          	ld	a5,-56(s0)
    80201c3a:	97ba                	add	a5,a5,a4
    80201c3c:	fef43023          	sd	a5,-32(s0)
		while (n-- > 0)
    80201c40:	a01d                	j	80201c66 <memmove+0xa2>
			*(--d) = *(--s);
    80201c42:	fe043783          	ld	a5,-32(s0)
    80201c46:	17fd                	addi	a5,a5,-1
    80201c48:	fef43023          	sd	a5,-32(s0)
    80201c4c:	fe843783          	ld	a5,-24(s0)
    80201c50:	17fd                	addi	a5,a5,-1
    80201c52:	fef43423          	sd	a5,-24(s0)
    80201c56:	fe043783          	ld	a5,-32(s0)
    80201c5a:	0007c703          	lbu	a4,0(a5)
    80201c5e:	fe843783          	ld	a5,-24(s0)
    80201c62:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201c66:	fc843783          	ld	a5,-56(s0)
    80201c6a:	fff78713          	addi	a4,a5,-1
    80201c6e:	fce43423          	sd	a4,-56(s0)
    80201c72:	fbe1                	bnez	a5,80201c42 <memmove+0x7e>
	}
	return dst;
    80201c74:	fd843783          	ld	a5,-40(s0)
}
    80201c78:	853e                	mv	a0,a5
    80201c7a:	7462                	ld	s0,56(sp)
    80201c7c:	6121                	addi	sp,sp,64
    80201c7e:	8082                	ret

0000000080201c80 <memcpy>:
void *memcpy(void *dst, const void *src, size_t n) {
    80201c80:	715d                	addi	sp,sp,-80
    80201c82:	e4a2                	sd	s0,72(sp)
    80201c84:	0880                	addi	s0,sp,80
    80201c86:	fca43423          	sd	a0,-56(s0)
    80201c8a:	fcb43023          	sd	a1,-64(s0)
    80201c8e:	fac43c23          	sd	a2,-72(s0)
    char *d = dst;
    80201c92:	fc843783          	ld	a5,-56(s0)
    80201c96:	fef43023          	sd	a5,-32(s0)
    const char *s = src;
    80201c9a:	fc043783          	ld	a5,-64(s0)
    80201c9e:	fcf43c23          	sd	a5,-40(s0)
    for (size_t i = 0; i < n; i++) {
    80201ca2:	fe043423          	sd	zero,-24(s0)
    80201ca6:	a025                	j	80201cce <memcpy+0x4e>
        d[i] = s[i];
    80201ca8:	fd843703          	ld	a4,-40(s0)
    80201cac:	fe843783          	ld	a5,-24(s0)
    80201cb0:	973e                	add	a4,a4,a5
    80201cb2:	fe043683          	ld	a3,-32(s0)
    80201cb6:	fe843783          	ld	a5,-24(s0)
    80201cba:	97b6                	add	a5,a5,a3
    80201cbc:	00074703          	lbu	a4,0(a4)
    80201cc0:	00e78023          	sb	a4,0(a5)
    for (size_t i = 0; i < n; i++) {
    80201cc4:	fe843783          	ld	a5,-24(s0)
    80201cc8:	0785                	addi	a5,a5,1
    80201cca:	fef43423          	sd	a5,-24(s0)
    80201cce:	fe843703          	ld	a4,-24(s0)
    80201cd2:	fb843783          	ld	a5,-72(s0)
    80201cd6:	fcf769e3          	bltu	a4,a5,80201ca8 <memcpy+0x28>
    }
    return dst;
    80201cda:	fc843783          	ld	a5,-56(s0)
    80201cde:	853e                	mv	a0,a5
    80201ce0:	6426                	ld	s0,72(sp)
    80201ce2:	6161                	addi	sp,sp,80
    80201ce4:	8082                	ret

0000000080201ce6 <assert>:
    80201ce6:	1101                	addi	sp,sp,-32
    80201ce8:	ec06                	sd	ra,24(sp)
    80201cea:	e822                	sd	s0,16(sp)
    80201cec:	1000                	addi	s0,sp,32
    80201cee:	87aa                	mv	a5,a0
    80201cf0:	fef42623          	sw	a5,-20(s0)
    80201cf4:	fec42783          	lw	a5,-20(s0)
    80201cf8:	2781                	sext.w	a5,a5
    80201cfa:	e79d                	bnez	a5,80201d28 <assert+0x42>
    80201cfc:	18800613          	li	a2,392
    80201d00:	00005597          	auipc	a1,0x5
    80201d04:	05058593          	addi	a1,a1,80 # 80206d50 <small_numbers+0x960>
    80201d08:	00005517          	auipc	a0,0x5
    80201d0c:	05850513          	addi	a0,a0,88 # 80206d60 <small_numbers+0x970>
    80201d10:	fffff097          	auipc	ra,0xfffff
    80201d14:	e1e080e7          	jalr	-482(ra) # 80200b2e <printf>
    80201d18:	00005517          	auipc	a0,0x5
    80201d1c:	07050513          	addi	a0,a0,112 # 80206d88 <small_numbers+0x998>
    80201d20:	fffff097          	auipc	ra,0xfffff
    80201d24:	716080e7          	jalr	1814(ra) # 80201436 <panic>
    80201d28:	0001                	nop
    80201d2a:	60e2                	ld	ra,24(sp)
    80201d2c:	6442                	ld	s0,16(sp)
    80201d2e:	6105                	addi	sp,sp,32
    80201d30:	8082                	ret

0000000080201d32 <px>:
static inline uint64 px(int level, uint64 va) {
    80201d32:	1101                	addi	sp,sp,-32
    80201d34:	ec22                	sd	s0,24(sp)
    80201d36:	1000                	addi	s0,sp,32
    80201d38:	87aa                	mv	a5,a0
    80201d3a:	feb43023          	sd	a1,-32(s0)
    80201d3e:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    80201d42:	fec42783          	lw	a5,-20(s0)
    80201d46:	873e                	mv	a4,a5
    80201d48:	87ba                	mv	a5,a4
    80201d4a:	0037979b          	slliw	a5,a5,0x3
    80201d4e:	9fb9                	addw	a5,a5,a4
    80201d50:	2781                	sext.w	a5,a5
    80201d52:	27b1                	addiw	a5,a5,12
    80201d54:	2781                	sext.w	a5,a5
    80201d56:	873e                	mv	a4,a5
    80201d58:	fe043783          	ld	a5,-32(s0)
    80201d5c:	00e7d7b3          	srl	a5,a5,a4
    80201d60:	1ff7f793          	andi	a5,a5,511
}
    80201d64:	853e                	mv	a0,a5
    80201d66:	6462                	ld	s0,24(sp)
    80201d68:	6105                	addi	sp,sp,32
    80201d6a:	8082                	ret

0000000080201d6c <create_pagetable>:
pagetable_t create_pagetable(void) {
    80201d6c:	1101                	addi	sp,sp,-32
    80201d6e:	ec06                	sd	ra,24(sp)
    80201d70:	e822                	sd	s0,16(sp)
    80201d72:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    80201d74:	00001097          	auipc	ra,0x1
    80201d78:	d16080e7          	jalr	-746(ra) # 80202a8a <alloc_page>
    80201d7c:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    80201d80:	fe843783          	ld	a5,-24(s0)
    80201d84:	e399                	bnez	a5,80201d8a <create_pagetable+0x1e>
        return 0;
    80201d86:	4781                	li	a5,0
    80201d88:	a819                	j	80201d9e <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    80201d8a:	6605                	lui	a2,0x1
    80201d8c:	4581                	li	a1,0
    80201d8e:	fe843503          	ld	a0,-24(s0)
    80201d92:	00000097          	auipc	ra,0x0
    80201d96:	de2080e7          	jalr	-542(ra) # 80201b74 <memset>
    return pt;
    80201d9a:	fe843783          	ld	a5,-24(s0)
}
    80201d9e:	853e                	mv	a0,a5
    80201da0:	60e2                	ld	ra,24(sp)
    80201da2:	6442                	ld	s0,16(sp)
    80201da4:	6105                	addi	sp,sp,32
    80201da6:	8082                	ret

0000000080201da8 <walk_lookup>:
static pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    80201da8:	7179                	addi	sp,sp,-48
    80201daa:	f406                	sd	ra,40(sp)
    80201dac:	f022                	sd	s0,32(sp)
    80201dae:	1800                	addi	s0,sp,48
    80201db0:	fca43c23          	sd	a0,-40(s0)
    80201db4:	fcb43823          	sd	a1,-48(s0)
    if (va >= MAXVA)
    80201db8:	fd043703          	ld	a4,-48(s0)
    80201dbc:	57fd                	li	a5,-1
    80201dbe:	83e5                	srli	a5,a5,0x19
    80201dc0:	00e7fa63          	bgeu	a5,a4,80201dd4 <walk_lookup+0x2c>
        panic("walk_lookup: va out of range");
    80201dc4:	00005517          	auipc	a0,0x5
    80201dc8:	fcc50513          	addi	a0,a0,-52 # 80206d90 <small_numbers+0x9a0>
    80201dcc:	fffff097          	auipc	ra,0xfffff
    80201dd0:	66a080e7          	jalr	1642(ra) # 80201436 <panic>
    for (int level = 2; level > 0; level--) {
    80201dd4:	4789                	li	a5,2
    80201dd6:	fef42623          	sw	a5,-20(s0)
    80201dda:	a0a9                	j	80201e24 <walk_lookup+0x7c>
        pte_t *pte = &pt[px(level, va)];
    80201ddc:	fec42783          	lw	a5,-20(s0)
    80201de0:	fd043583          	ld	a1,-48(s0)
    80201de4:	853e                	mv	a0,a5
    80201de6:	00000097          	auipc	ra,0x0
    80201dea:	f4c080e7          	jalr	-180(ra) # 80201d32 <px>
    80201dee:	87aa                	mv	a5,a0
    80201df0:	078e                	slli	a5,a5,0x3
    80201df2:	fd843703          	ld	a4,-40(s0)
    80201df6:	97ba                	add	a5,a5,a4
    80201df8:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80201dfc:	fe043783          	ld	a5,-32(s0)
    80201e00:	639c                	ld	a5,0(a5)
    80201e02:	8b85                	andi	a5,a5,1
    80201e04:	cb89                	beqz	a5,80201e16 <walk_lookup+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    80201e06:	fe043783          	ld	a5,-32(s0)
    80201e0a:	639c                	ld	a5,0(a5)
    80201e0c:	83a9                	srli	a5,a5,0xa
    80201e0e:	07b2                	slli	a5,a5,0xc
    80201e10:	fcf43c23          	sd	a5,-40(s0)
    80201e14:	a019                	j	80201e1a <walk_lookup+0x72>
            return 0;
    80201e16:	4781                	li	a5,0
    80201e18:	a03d                	j	80201e46 <walk_lookup+0x9e>
    for (int level = 2; level > 0; level--) {
    80201e1a:	fec42783          	lw	a5,-20(s0)
    80201e1e:	37fd                	addiw	a5,a5,-1
    80201e20:	fef42623          	sw	a5,-20(s0)
    80201e24:	fec42783          	lw	a5,-20(s0)
    80201e28:	2781                	sext.w	a5,a5
    80201e2a:	faf049e3          	bgtz	a5,80201ddc <walk_lookup+0x34>
    return &pt[px(0, va)];
    80201e2e:	fd043583          	ld	a1,-48(s0)
    80201e32:	4501                	li	a0,0
    80201e34:	00000097          	auipc	ra,0x0
    80201e38:	efe080e7          	jalr	-258(ra) # 80201d32 <px>
    80201e3c:	87aa                	mv	a5,a0
    80201e3e:	078e                	slli	a5,a5,0x3
    80201e40:	fd843703          	ld	a4,-40(s0)
    80201e44:	97ba                	add	a5,a5,a4
}
    80201e46:	853e                	mv	a0,a5
    80201e48:	70a2                	ld	ra,40(sp)
    80201e4a:	7402                	ld	s0,32(sp)
    80201e4c:	6145                	addi	sp,sp,48
    80201e4e:	8082                	ret

0000000080201e50 <walk_create>:
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    80201e50:	7139                	addi	sp,sp,-64
    80201e52:	fc06                	sd	ra,56(sp)
    80201e54:	f822                	sd	s0,48(sp)
    80201e56:	0080                	addi	s0,sp,64
    80201e58:	fca43423          	sd	a0,-56(s0)
    80201e5c:	fcb43023          	sd	a1,-64(s0)
    if (va >= MAXVA)
    80201e60:	fc043703          	ld	a4,-64(s0)
    80201e64:	57fd                	li	a5,-1
    80201e66:	83e5                	srli	a5,a5,0x19
    80201e68:	00e7fa63          	bgeu	a5,a4,80201e7c <walk_create+0x2c>
        panic("walk_create: va out of range");
    80201e6c:	00005517          	auipc	a0,0x5
    80201e70:	f4450513          	addi	a0,a0,-188 # 80206db0 <small_numbers+0x9c0>
    80201e74:	fffff097          	auipc	ra,0xfffff
    80201e78:	5c2080e7          	jalr	1474(ra) # 80201436 <panic>
    for (int level = 2; level > 0; level--) {
    80201e7c:	4789                	li	a5,2
    80201e7e:	fef42623          	sw	a5,-20(s0)
    80201e82:	a059                	j	80201f08 <walk_create+0xb8>
        pte_t *pte = &pt[px(level, va)];
    80201e84:	fec42783          	lw	a5,-20(s0)
    80201e88:	fc043583          	ld	a1,-64(s0)
    80201e8c:	853e                	mv	a0,a5
    80201e8e:	00000097          	auipc	ra,0x0
    80201e92:	ea4080e7          	jalr	-348(ra) # 80201d32 <px>
    80201e96:	87aa                	mv	a5,a0
    80201e98:	078e                	slli	a5,a5,0x3
    80201e9a:	fc843703          	ld	a4,-56(s0)
    80201e9e:	97ba                	add	a5,a5,a4
    80201ea0:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80201ea4:	fe043783          	ld	a5,-32(s0)
    80201ea8:	639c                	ld	a5,0(a5)
    80201eaa:	8b85                	andi	a5,a5,1
    80201eac:	cb89                	beqz	a5,80201ebe <walk_create+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    80201eae:	fe043783          	ld	a5,-32(s0)
    80201eb2:	639c                	ld	a5,0(a5)
    80201eb4:	83a9                	srli	a5,a5,0xa
    80201eb6:	07b2                	slli	a5,a5,0xc
    80201eb8:	fcf43423          	sd	a5,-56(s0)
    80201ebc:	a089                	j	80201efe <walk_create+0xae>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    80201ebe:	00001097          	auipc	ra,0x1
    80201ec2:	bcc080e7          	jalr	-1076(ra) # 80202a8a <alloc_page>
    80201ec6:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    80201eca:	fd843783          	ld	a5,-40(s0)
    80201ece:	e399                	bnez	a5,80201ed4 <walk_create+0x84>
                return 0;
    80201ed0:	4781                	li	a5,0
    80201ed2:	a8a1                	j	80201f2a <walk_create+0xda>
            memset(new_pt, 0, PGSIZE);
    80201ed4:	6605                	lui	a2,0x1
    80201ed6:	4581                	li	a1,0
    80201ed8:	fd843503          	ld	a0,-40(s0)
    80201edc:	00000097          	auipc	ra,0x0
    80201ee0:	c98080e7          	jalr	-872(ra) # 80201b74 <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    80201ee4:	fd843783          	ld	a5,-40(s0)
    80201ee8:	83b1                	srli	a5,a5,0xc
    80201eea:	07aa                	slli	a5,a5,0xa
    80201eec:	0017e713          	ori	a4,a5,1
    80201ef0:	fe043783          	ld	a5,-32(s0)
    80201ef4:	e398                	sd	a4,0(a5)
            pt = new_pt;
    80201ef6:	fd843783          	ld	a5,-40(s0)
    80201efa:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    80201efe:	fec42783          	lw	a5,-20(s0)
    80201f02:	37fd                	addiw	a5,a5,-1
    80201f04:	fef42623          	sw	a5,-20(s0)
    80201f08:	fec42783          	lw	a5,-20(s0)
    80201f0c:	2781                	sext.w	a5,a5
    80201f0e:	f6f04be3          	bgtz	a5,80201e84 <walk_create+0x34>
    return &pt[px(0, va)];
    80201f12:	fc043583          	ld	a1,-64(s0)
    80201f16:	4501                	li	a0,0
    80201f18:	00000097          	auipc	ra,0x0
    80201f1c:	e1a080e7          	jalr	-486(ra) # 80201d32 <px>
    80201f20:	87aa                	mv	a5,a0
    80201f22:	078e                	slli	a5,a5,0x3
    80201f24:	fc843703          	ld	a4,-56(s0)
    80201f28:	97ba                	add	a5,a5,a4
}
    80201f2a:	853e                	mv	a0,a5
    80201f2c:	70e2                	ld	ra,56(sp)
    80201f2e:	7442                	ld	s0,48(sp)
    80201f30:	6121                	addi	sp,sp,64
    80201f32:	8082                	ret

0000000080201f34 <map_page>:
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    80201f34:	7139                	addi	sp,sp,-64
    80201f36:	fc06                	sd	ra,56(sp)
    80201f38:	f822                	sd	s0,48(sp)
    80201f3a:	0080                	addi	s0,sp,64
    80201f3c:	fca43c23          	sd	a0,-40(s0)
    80201f40:	fcb43823          	sd	a1,-48(s0)
    80201f44:	fcc43423          	sd	a2,-56(s0)
    80201f48:	87b6                	mv	a5,a3
    80201f4a:	fcf42223          	sw	a5,-60(s0)
    if ((va % PGSIZE) != 0)
    80201f4e:	fd043703          	ld	a4,-48(s0)
    80201f52:	6785                	lui	a5,0x1
    80201f54:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80201f56:	8ff9                	and	a5,a5,a4
    80201f58:	cb89                	beqz	a5,80201f6a <map_page+0x36>
        panic("map_page: va not aligned");
    80201f5a:	00005517          	auipc	a0,0x5
    80201f5e:	e7650513          	addi	a0,a0,-394 # 80206dd0 <small_numbers+0x9e0>
    80201f62:	fffff097          	auipc	ra,0xfffff
    80201f66:	4d4080e7          	jalr	1236(ra) # 80201436 <panic>
    pte_t *pte = walk_create(pt, va);
    80201f6a:	fd043583          	ld	a1,-48(s0)
    80201f6e:	fd843503          	ld	a0,-40(s0)
    80201f72:	00000097          	auipc	ra,0x0
    80201f76:	ede080e7          	jalr	-290(ra) # 80201e50 <walk_create>
    80201f7a:	fea43423          	sd	a0,-24(s0)
    if (!pte)
    80201f7e:	fe843783          	ld	a5,-24(s0)
    80201f82:	e399                	bnez	a5,80201f88 <map_page+0x54>
        return -1;
    80201f84:	57fd                	li	a5,-1
    80201f86:	a069                	j	80202010 <map_page+0xdc>
	if (*pte & PTE_V) {
    80201f88:	fe843783          	ld	a5,-24(s0)
    80201f8c:	639c                	ld	a5,0(a5)
    80201f8e:	8b85                	andi	a5,a5,1
    80201f90:	c3b5                	beqz	a5,80201ff4 <map_page+0xc0>
		if (PTE2PA(*pte) == pa) {
    80201f92:	fe843783          	ld	a5,-24(s0)
    80201f96:	639c                	ld	a5,0(a5)
    80201f98:	83a9                	srli	a5,a5,0xa
    80201f9a:	07b2                	slli	a5,a5,0xc
    80201f9c:	fc843703          	ld	a4,-56(s0)
    80201fa0:	04f71263          	bne	a4,a5,80201fe4 <map_page+0xb0>
			int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
    80201fa4:	fe843783          	ld	a5,-24(s0)
    80201fa8:	639c                	ld	a5,0(a5)
    80201faa:	2781                	sext.w	a5,a5
    80201fac:	3ff7f793          	andi	a5,a5,1023
    80201fb0:	0007871b          	sext.w	a4,a5
    80201fb4:	fc442783          	lw	a5,-60(s0)
    80201fb8:	8fd9                	or	a5,a5,a4
    80201fba:	2781                	sext.w	a5,a5
    80201fbc:	2781                	sext.w	a5,a5
    80201fbe:	3ff7f793          	andi	a5,a5,1023
    80201fc2:	fef42223          	sw	a5,-28(s0)
			*pte = PA2PTE(pa) | new_perm | PTE_V;
    80201fc6:	fc843783          	ld	a5,-56(s0)
    80201fca:	83b1                	srli	a5,a5,0xc
    80201fcc:	00a79713          	slli	a4,a5,0xa
    80201fd0:	fe442783          	lw	a5,-28(s0)
    80201fd4:	8fd9                	or	a5,a5,a4
    80201fd6:	0017e713          	ori	a4,a5,1
    80201fda:	fe843783          	ld	a5,-24(s0)
    80201fde:	e398                	sd	a4,0(a5)
			return 0;
    80201fe0:	4781                	li	a5,0
    80201fe2:	a03d                	j	80202010 <map_page+0xdc>
			panic("map_page: remap to different physical address");
    80201fe4:	00005517          	auipc	a0,0x5
    80201fe8:	e0c50513          	addi	a0,a0,-500 # 80206df0 <small_numbers+0xa00>
    80201fec:	fffff097          	auipc	ra,0xfffff
    80201ff0:	44a080e7          	jalr	1098(ra) # 80201436 <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80201ff4:	fc843783          	ld	a5,-56(s0)
    80201ff8:	83b1                	srli	a5,a5,0xc
    80201ffa:	00a79713          	slli	a4,a5,0xa
    80201ffe:	fc442783          	lw	a5,-60(s0)
    80202002:	8fd9                	or	a5,a5,a4
    80202004:	0017e713          	ori	a4,a5,1
    80202008:	fe843783          	ld	a5,-24(s0)
    8020200c:	e398                	sd	a4,0(a5)
    return 0;
    8020200e:	4781                	li	a5,0
}
    80202010:	853e                	mv	a0,a5
    80202012:	70e2                	ld	ra,56(sp)
    80202014:	7442                	ld	s0,48(sp)
    80202016:	6121                	addi	sp,sp,64
    80202018:	8082                	ret

000000008020201a <free_pagetable>:
void free_pagetable(pagetable_t pt) {
    8020201a:	7139                	addi	sp,sp,-64
    8020201c:	fc06                	sd	ra,56(sp)
    8020201e:	f822                	sd	s0,48(sp)
    80202020:	0080                	addi	s0,sp,64
    80202022:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    80202026:	fe042623          	sw	zero,-20(s0)
    8020202a:	a8a5                	j	802020a2 <free_pagetable+0x88>
        pte_t pte = pt[i];
    8020202c:	fec42783          	lw	a5,-20(s0)
    80202030:	078e                	slli	a5,a5,0x3
    80202032:	fc843703          	ld	a4,-56(s0)
    80202036:	97ba                	add	a5,a5,a4
    80202038:	639c                	ld	a5,0(a5)
    8020203a:	fef43023          	sd	a5,-32(s0)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    8020203e:	fe043783          	ld	a5,-32(s0)
    80202042:	8b85                	andi	a5,a5,1
    80202044:	cb95                	beqz	a5,80202078 <free_pagetable+0x5e>
    80202046:	fe043783          	ld	a5,-32(s0)
    8020204a:	8bb9                	andi	a5,a5,14
    8020204c:	e795                	bnez	a5,80202078 <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    8020204e:	fe043783          	ld	a5,-32(s0)
    80202052:	83a9                	srli	a5,a5,0xa
    80202054:	07b2                	slli	a5,a5,0xc
    80202056:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    8020205a:	fd843503          	ld	a0,-40(s0)
    8020205e:	00000097          	auipc	ra,0x0
    80202062:	fbc080e7          	jalr	-68(ra) # 8020201a <free_pagetable>
            pt[i] = 0;
    80202066:	fec42783          	lw	a5,-20(s0)
    8020206a:	078e                	slli	a5,a5,0x3
    8020206c:	fc843703          	ld	a4,-56(s0)
    80202070:	97ba                	add	a5,a5,a4
    80202072:	0007b023          	sd	zero,0(a5)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80202076:	a00d                	j	80202098 <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    80202078:	fe043783          	ld	a5,-32(s0)
    8020207c:	8b85                	andi	a5,a5,1
    8020207e:	cf89                	beqz	a5,80202098 <free_pagetable+0x7e>
    80202080:	fe043783          	ld	a5,-32(s0)
    80202084:	8bb9                	andi	a5,a5,14
    80202086:	cb89                	beqz	a5,80202098 <free_pagetable+0x7e>
            pt[i] = 0;
    80202088:	fec42783          	lw	a5,-20(s0)
    8020208c:	078e                	slli	a5,a5,0x3
    8020208e:	fc843703          	ld	a4,-56(s0)
    80202092:	97ba                	add	a5,a5,a4
    80202094:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    80202098:	fec42783          	lw	a5,-20(s0)
    8020209c:	2785                	addiw	a5,a5,1
    8020209e:	fef42623          	sw	a5,-20(s0)
    802020a2:	fec42783          	lw	a5,-20(s0)
    802020a6:	0007871b          	sext.w	a4,a5
    802020aa:	1ff00793          	li	a5,511
    802020ae:	f6e7dfe3          	bge	a5,a4,8020202c <free_pagetable+0x12>
    free_page(pt);
    802020b2:	fc843503          	ld	a0,-56(s0)
    802020b6:	00001097          	auipc	ra,0x1
    802020ba:	a40080e7          	jalr	-1472(ra) # 80202af6 <free_page>
}
    802020be:	0001                	nop
    802020c0:	70e2                	ld	ra,56(sp)
    802020c2:	7442                	ld	s0,48(sp)
    802020c4:	6121                	addi	sp,sp,64
    802020c6:	8082                	ret

00000000802020c8 <kvmmake>:
static pagetable_t kvmmake(void) {
    802020c8:	711d                	addi	sp,sp,-96
    802020ca:	ec86                	sd	ra,88(sp)
    802020cc:	e8a2                	sd	s0,80(sp)
    802020ce:	1080                	addi	s0,sp,96
    pagetable_t kpgtbl = create_pagetable();
    802020d0:	00000097          	auipc	ra,0x0
    802020d4:	c9c080e7          	jalr	-868(ra) # 80201d6c <create_pagetable>
    802020d8:	faa43c23          	sd	a0,-72(s0)
    if (!kpgtbl)
    802020dc:	fb843783          	ld	a5,-72(s0)
    802020e0:	eb89                	bnez	a5,802020f2 <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    802020e2:	00005517          	auipc	a0,0x5
    802020e6:	d3e50513          	addi	a0,a0,-706 # 80206e20 <small_numbers+0xa30>
    802020ea:	fffff097          	auipc	ra,0xfffff
    802020ee:	34c080e7          	jalr	844(ra) # 80201436 <panic>
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    802020f2:	4785                	li	a5,1
    802020f4:	07fe                	slli	a5,a5,0x1f
    802020f6:	fef43423          	sd	a5,-24(s0)
    802020fa:	a825                	j	80202132 <kvmmake+0x6a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_X) != 0)
    802020fc:	46a9                	li	a3,10
    802020fe:	fe843603          	ld	a2,-24(s0)
    80202102:	fe843583          	ld	a1,-24(s0)
    80202106:	fb843503          	ld	a0,-72(s0)
    8020210a:	00000097          	auipc	ra,0x0
    8020210e:	e2a080e7          	jalr	-470(ra) # 80201f34 <map_page>
    80202112:	87aa                	mv	a5,a0
    80202114:	cb89                	beqz	a5,80202126 <kvmmake+0x5e>
            panic("kvmmake: code map failed");
    80202116:	00005517          	auipc	a0,0x5
    8020211a:	d2250513          	addi	a0,a0,-734 # 80206e38 <small_numbers+0xa48>
    8020211e:	fffff097          	auipc	ra,0xfffff
    80202122:	318080e7          	jalr	792(ra) # 80201436 <panic>
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    80202126:	fe843703          	ld	a4,-24(s0)
    8020212a:	6785                	lui	a5,0x1
    8020212c:	97ba                	add	a5,a5,a4
    8020212e:	fef43423          	sd	a5,-24(s0)
    80202132:	00004797          	auipc	a5,0x4
    80202136:	ece78793          	addi	a5,a5,-306 # 80206000 <etext>
    8020213a:	fe843703          	ld	a4,-24(s0)
    8020213e:	faf76fe3          	bltu	a4,a5,802020fc <kvmmake+0x34>
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    80202142:	00004797          	auipc	a5,0x4
    80202146:	ebe78793          	addi	a5,a5,-322 # 80206000 <etext>
    8020214a:	fef43023          	sd	a5,-32(s0)
    8020214e:	a825                	j	80202186 <kvmmake+0xbe>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202150:	4699                	li	a3,6
    80202152:	fe043603          	ld	a2,-32(s0)
    80202156:	fe043583          	ld	a1,-32(s0)
    8020215a:	fb843503          	ld	a0,-72(s0)
    8020215e:	00000097          	auipc	ra,0x0
    80202162:	dd6080e7          	jalr	-554(ra) # 80201f34 <map_page>
    80202166:	87aa                	mv	a5,a0
    80202168:	cb89                	beqz	a5,8020217a <kvmmake+0xb2>
            panic("kvmmake: data map failed");
    8020216a:	00005517          	auipc	a0,0x5
    8020216e:	cee50513          	addi	a0,a0,-786 # 80206e58 <small_numbers+0xa68>
    80202172:	fffff097          	auipc	ra,0xfffff
    80202176:	2c4080e7          	jalr	708(ra) # 80201436 <panic>
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    8020217a:	fe043703          	ld	a4,-32(s0)
    8020217e:	6785                	lui	a5,0x1
    80202180:	97ba                	add	a5,a5,a4
    80202182:	fef43023          	sd	a5,-32(s0)
    80202186:	0000a797          	auipc	a5,0xa
    8020218a:	2ca78793          	addi	a5,a5,714 # 8020c450 <_bss_end>
    8020218e:	fe043703          	ld	a4,-32(s0)
    80202192:	faf76fe3          	bltu	a4,a5,80202150 <kvmmake+0x88>
	uint64 aligned_end = ((uint64)end + PGSIZE - 1) & ~(PGSIZE - 1); // 向上对齐到页边界
    80202196:	0000a717          	auipc	a4,0xa
    8020219a:	2ba70713          	addi	a4,a4,698 # 8020c450 <_bss_end>
    8020219e:	6785                	lui	a5,0x1
    802021a0:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    802021a2:	973e                	add	a4,a4,a5
    802021a4:	77fd                	lui	a5,0xfffff
    802021a6:	8ff9                	and	a5,a5,a4
    802021a8:	faf43823          	sd	a5,-80(s0)
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    802021ac:	fb043783          	ld	a5,-80(s0)
    802021b0:	fcf43c23          	sd	a5,-40(s0)
    802021b4:	a825                	j	802021ec <kvmmake+0x124>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802021b6:	4699                	li	a3,6
    802021b8:	fd843603          	ld	a2,-40(s0)
    802021bc:	fd843583          	ld	a1,-40(s0)
    802021c0:	fb843503          	ld	a0,-72(s0)
    802021c4:	00000097          	auipc	ra,0x0
    802021c8:	d70080e7          	jalr	-656(ra) # 80201f34 <map_page>
    802021cc:	87aa                	mv	a5,a0
    802021ce:	cb89                	beqz	a5,802021e0 <kvmmake+0x118>
			panic("kvmmake: heap map failed");
    802021d0:	00005517          	auipc	a0,0x5
    802021d4:	ca850513          	addi	a0,a0,-856 # 80206e78 <small_numbers+0xa88>
    802021d8:	fffff097          	auipc	ra,0xfffff
    802021dc:	25e080e7          	jalr	606(ra) # 80201436 <panic>
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    802021e0:	fd843703          	ld	a4,-40(s0)
    802021e4:	6785                	lui	a5,0x1
    802021e6:	97ba                	add	a5,a5,a4
    802021e8:	fcf43c23          	sd	a5,-40(s0)
    802021ec:	fd843703          	ld	a4,-40(s0)
    802021f0:	47c5                	li	a5,17
    802021f2:	07ee                	slli	a5,a5,0x1b
    802021f4:	fcf761e3          	bltu	a4,a5,802021b6 <kvmmake+0xee>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    802021f8:	4699                	li	a3,6
    802021fa:	10000637          	lui	a2,0x10000
    802021fe:	100005b7          	lui	a1,0x10000
    80202202:	fb843503          	ld	a0,-72(s0)
    80202206:	00000097          	auipc	ra,0x0
    8020220a:	d2e080e7          	jalr	-722(ra) # 80201f34 <map_page>
    8020220e:	87aa                	mv	a5,a0
    80202210:	cb89                	beqz	a5,80202222 <kvmmake+0x15a>
        panic("kvmmake: uart map failed");
    80202212:	00005517          	auipc	a0,0x5
    80202216:	c8650513          	addi	a0,a0,-890 # 80206e98 <small_numbers+0xaa8>
    8020221a:	fffff097          	auipc	ra,0xfffff
    8020221e:	21c080e7          	jalr	540(ra) # 80201436 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80202222:	0c0007b7          	lui	a5,0xc000
    80202226:	fcf43823          	sd	a5,-48(s0)
    8020222a:	a825                	j	80202262 <kvmmake+0x19a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    8020222c:	4699                	li	a3,6
    8020222e:	fd043603          	ld	a2,-48(s0)
    80202232:	fd043583          	ld	a1,-48(s0)
    80202236:	fb843503          	ld	a0,-72(s0)
    8020223a:	00000097          	auipc	ra,0x0
    8020223e:	cfa080e7          	jalr	-774(ra) # 80201f34 <map_page>
    80202242:	87aa                	mv	a5,a0
    80202244:	cb89                	beqz	a5,80202256 <kvmmake+0x18e>
            panic("kvmmake: plic map failed");
    80202246:	00005517          	auipc	a0,0x5
    8020224a:	c7250513          	addi	a0,a0,-910 # 80206eb8 <small_numbers+0xac8>
    8020224e:	fffff097          	auipc	ra,0xfffff
    80202252:	1e8080e7          	jalr	488(ra) # 80201436 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80202256:	fd043703          	ld	a4,-48(s0)
    8020225a:	6785                	lui	a5,0x1
    8020225c:	97ba                	add	a5,a5,a4
    8020225e:	fcf43823          	sd	a5,-48(s0)
    80202262:	fd043703          	ld	a4,-48(s0)
    80202266:	0c4007b7          	lui	a5,0xc400
    8020226a:	fcf761e3          	bltu	a4,a5,8020222c <kvmmake+0x164>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    8020226e:	020007b7          	lui	a5,0x2000
    80202272:	fcf43423          	sd	a5,-56(s0)
    80202276:	a825                	j	802022ae <kvmmake+0x1e6>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202278:	4699                	li	a3,6
    8020227a:	fc843603          	ld	a2,-56(s0)
    8020227e:	fc843583          	ld	a1,-56(s0)
    80202282:	fb843503          	ld	a0,-72(s0)
    80202286:	00000097          	auipc	ra,0x0
    8020228a:	cae080e7          	jalr	-850(ra) # 80201f34 <map_page>
    8020228e:	87aa                	mv	a5,a0
    80202290:	cb89                	beqz	a5,802022a2 <kvmmake+0x1da>
            panic("kvmmake: clint map failed");
    80202292:	00005517          	auipc	a0,0x5
    80202296:	c4650513          	addi	a0,a0,-954 # 80206ed8 <small_numbers+0xae8>
    8020229a:	fffff097          	auipc	ra,0xfffff
    8020229e:	19c080e7          	jalr	412(ra) # 80201436 <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    802022a2:	fc843703          	ld	a4,-56(s0)
    802022a6:	6785                	lui	a5,0x1
    802022a8:	97ba                	add	a5,a5,a4
    802022aa:	fcf43423          	sd	a5,-56(s0)
    802022ae:	fc843703          	ld	a4,-56(s0)
    802022b2:	020107b7          	lui	a5,0x2010
    802022b6:	fcf761e3          	bltu	a4,a5,80202278 <kvmmake+0x1b0>
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    802022ba:	4699                	li	a3,6
    802022bc:	10001637          	lui	a2,0x10001
    802022c0:	100015b7          	lui	a1,0x10001
    802022c4:	fb843503          	ld	a0,-72(s0)
    802022c8:	00000097          	auipc	ra,0x0
    802022cc:	c6c080e7          	jalr	-916(ra) # 80201f34 <map_page>
    802022d0:	87aa                	mv	a5,a0
    802022d2:	cb89                	beqz	a5,802022e4 <kvmmake+0x21c>
        panic("kvmmake: virtio map failed");
    802022d4:	00005517          	auipc	a0,0x5
    802022d8:	c2450513          	addi	a0,a0,-988 # 80206ef8 <small_numbers+0xb08>
    802022dc:	fffff097          	auipc	ra,0xfffff
    802022e0:	15a080e7          	jalr	346(ra) # 80201436 <panic>
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    802022e4:	fc043023          	sd	zero,-64(s0)
    802022e8:	a825                	j	80202320 <kvmmake+0x258>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802022ea:	4699                	li	a3,6
    802022ec:	fc043603          	ld	a2,-64(s0)
    802022f0:	fc043583          	ld	a1,-64(s0)
    802022f4:	fb843503          	ld	a0,-72(s0)
    802022f8:	00000097          	auipc	ra,0x0
    802022fc:	c3c080e7          	jalr	-964(ra) # 80201f34 <map_page>
    80202300:	87aa                	mv	a5,a0
    80202302:	cb89                	beqz	a5,80202314 <kvmmake+0x24c>
			panic("kvmmake: low memory map failed");
    80202304:	00005517          	auipc	a0,0x5
    80202308:	c1450513          	addi	a0,a0,-1004 # 80206f18 <small_numbers+0xb28>
    8020230c:	fffff097          	auipc	ra,0xfffff
    80202310:	12a080e7          	jalr	298(ra) # 80201436 <panic>
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    80202314:	fc043703          	ld	a4,-64(s0)
    80202318:	6785                	lui	a5,0x1
    8020231a:	97ba                	add	a5,a5,a4
    8020231c:	fcf43023          	sd	a5,-64(s0)
    80202320:	fc043703          	ld	a4,-64(s0)
    80202324:	001007b7          	lui	a5,0x100
    80202328:	fcf761e3          	bltu	a4,a5,802022ea <kvmmake+0x222>
	uint64 sbi_special = 0xfd02000;  // 页对齐
    8020232c:	0fd027b7          	lui	a5,0xfd02
    80202330:	faf43423          	sd	a5,-88(s0)
	if (map_page(kpgtbl, sbi_special, sbi_special, PTE_R | PTE_W) != 0)
    80202334:	4699                	li	a3,6
    80202336:	fa843603          	ld	a2,-88(s0)
    8020233a:	fa843583          	ld	a1,-88(s0)
    8020233e:	fb843503          	ld	a0,-72(s0)
    80202342:	00000097          	auipc	ra,0x0
    80202346:	bf2080e7          	jalr	-1038(ra) # 80201f34 <map_page>
    8020234a:	87aa                	mv	a5,a0
    8020234c:	cb89                	beqz	a5,8020235e <kvmmake+0x296>
		panic("kvmmake: sbi special area map failed");
    8020234e:	00005517          	auipc	a0,0x5
    80202352:	bea50513          	addi	a0,a0,-1046 # 80206f38 <small_numbers+0xb48>
    80202356:	fffff097          	auipc	ra,0xfffff
    8020235a:	0e0080e7          	jalr	224(ra) # 80201436 <panic>
    return kpgtbl;
    8020235e:	fb843783          	ld	a5,-72(s0)
}
    80202362:	853e                	mv	a0,a5
    80202364:	60e6                	ld	ra,88(sp)
    80202366:	6446                	ld	s0,80(sp)
    80202368:	6125                	addi	sp,sp,96
    8020236a:	8082                	ret

000000008020236c <kvminit>:
void kvminit(void) {
    8020236c:	1141                	addi	sp,sp,-16
    8020236e:	e406                	sd	ra,8(sp)
    80202370:	e022                	sd	s0,0(sp)
    80202372:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    80202374:	00000097          	auipc	ra,0x0
    80202378:	d54080e7          	jalr	-684(ra) # 802020c8 <kvmmake>
    8020237c:	872a                	mv	a4,a0
    8020237e:	00008797          	auipc	a5,0x8
    80202382:	d0278793          	addi	a5,a5,-766 # 8020a080 <kernel_pagetable>
    80202386:	e398                	sd	a4,0(a5)
}
    80202388:	0001                	nop
    8020238a:	60a2                	ld	ra,8(sp)
    8020238c:	6402                	ld	s0,0(sp)
    8020238e:	0141                	addi	sp,sp,16
    80202390:	8082                	ret

0000000080202392 <w_satp>:
static inline void w_satp(uint64 x) {
    80202392:	1101                	addi	sp,sp,-32
    80202394:	ec22                	sd	s0,24(sp)
    80202396:	1000                	addi	s0,sp,32
    80202398:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    8020239c:	fe843783          	ld	a5,-24(s0)
    802023a0:	18079073          	csrw	satp,a5
}
    802023a4:	0001                	nop
    802023a6:	6462                	ld	s0,24(sp)
    802023a8:	6105                	addi	sp,sp,32
    802023aa:	8082                	ret

00000000802023ac <sfence_vma>:
inline void sfence_vma(void) {
    802023ac:	1141                	addi	sp,sp,-16
    802023ae:	e422                	sd	s0,8(sp)
    802023b0:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    802023b2:	12000073          	sfence.vma
}
    802023b6:	0001                	nop
    802023b8:	6422                	ld	s0,8(sp)
    802023ba:	0141                	addi	sp,sp,16
    802023bc:	8082                	ret

00000000802023be <kvminithart>:
void kvminithart(void) {
    802023be:	1141                	addi	sp,sp,-16
    802023c0:	e406                	sd	ra,8(sp)
    802023c2:	e022                	sd	s0,0(sp)
    802023c4:	0800                	addi	s0,sp,16
    sfence_vma();
    802023c6:	00000097          	auipc	ra,0x0
    802023ca:	fe6080e7          	jalr	-26(ra) # 802023ac <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    802023ce:	00008797          	auipc	a5,0x8
    802023d2:	cb278793          	addi	a5,a5,-846 # 8020a080 <kernel_pagetable>
    802023d6:	639c                	ld	a5,0(a5)
    802023d8:	00c7d713          	srli	a4,a5,0xc
    802023dc:	57fd                	li	a5,-1
    802023de:	17fe                	slli	a5,a5,0x3f
    802023e0:	8fd9                	or	a5,a5,a4
    802023e2:	853e                	mv	a0,a5
    802023e4:	00000097          	auipc	ra,0x0
    802023e8:	fae080e7          	jalr	-82(ra) # 80202392 <w_satp>
    sfence_vma();
    802023ec:	00000097          	auipc	ra,0x0
    802023f0:	fc0080e7          	jalr	-64(ra) # 802023ac <sfence_vma>
	printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
    802023f4:	00008797          	auipc	a5,0x8
    802023f8:	c8c78793          	addi	a5,a5,-884 # 8020a080 <kernel_pagetable>
    802023fc:	639c                	ld	a5,0(a5)
    802023fe:	00c7d713          	srli	a4,a5,0xc
    80202402:	57fd                	li	a5,-1
    80202404:	17fe                	slli	a5,a5,0x3f
    80202406:	8fd9                	or	a5,a5,a4
    80202408:	85be                	mv	a1,a5
    8020240a:	00005517          	auipc	a0,0x5
    8020240e:	b5650513          	addi	a0,a0,-1194 # 80206f60 <small_numbers+0xb70>
    80202412:	ffffe097          	auipc	ra,0xffffe
    80202416:	71c080e7          	jalr	1820(ra) # 80200b2e <printf>
}
    8020241a:	0001                	nop
    8020241c:	60a2                	ld	ra,8(sp)
    8020241e:	6402                	ld	s0,0(sp)
    80202420:	0141                	addi	sp,sp,16
    80202422:	8082                	ret

0000000080202424 <get_current_pagetable>:
pagetable_t get_current_pagetable(void) {
    80202424:	1141                	addi	sp,sp,-16
    80202426:	e422                	sd	s0,8(sp)
    80202428:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    8020242a:	00008797          	auipc	a5,0x8
    8020242e:	c5678793          	addi	a5,a5,-938 # 8020a080 <kernel_pagetable>
    80202432:	639c                	ld	a5,0(a5)
}
    80202434:	853e                	mv	a0,a5
    80202436:	6422                	ld	s0,8(sp)
    80202438:	0141                	addi	sp,sp,16
    8020243a:	8082                	ret

000000008020243c <handle_page_fault>:
int handle_page_fault(uint64 va, int type) {
    8020243c:	7139                	addi	sp,sp,-64
    8020243e:	fc06                	sd	ra,56(sp)
    80202440:	f822                	sd	s0,48(sp)
    80202442:	0080                	addi	s0,sp,64
    80202444:	fca43423          	sd	a0,-56(s0)
    80202448:	87ae                	mv	a5,a1
    8020244a:	fcf42223          	sw	a5,-60(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    8020244e:	fc442783          	lw	a5,-60(s0)
    80202452:	863e                	mv	a2,a5
    80202454:	fc843583          	ld	a1,-56(s0)
    80202458:	00005517          	auipc	a0,0x5
    8020245c:	b3850513          	addi	a0,a0,-1224 # 80206f90 <small_numbers+0xba0>
    80202460:	ffffe097          	auipc	ra,0xffffe
    80202464:	6ce080e7          	jalr	1742(ra) # 80200b2e <printf>
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    80202468:	fc843703          	ld	a4,-56(s0)
    8020246c:	77fd                	lui	a5,0xfffff
    8020246e:	8ff9                	and	a5,a5,a4
    80202470:	fef43023          	sd	a5,-32(s0)
    if (page_va >= MAXVA) {
    80202474:	fe043703          	ld	a4,-32(s0)
    80202478:	57fd                	li	a5,-1
    8020247a:	83e5                	srli	a5,a5,0x19
    8020247c:	00e7fc63          	bgeu	a5,a4,80202494 <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    80202480:	00005517          	auipc	a0,0x5
    80202484:	b4050513          	addi	a0,a0,-1216 # 80206fc0 <small_numbers+0xbd0>
    80202488:	ffffe097          	auipc	ra,0xffffe
    8020248c:	6a6080e7          	jalr	1702(ra) # 80200b2e <printf>
        return 0; // 地址超出最大虚拟地址空间
    80202490:	4781                	li	a5,0
    80202492:	a275                	j	8020263e <handle_page_fault+0x202>
    pte_t *pte = walk_lookup(kernel_pagetable, page_va);
    80202494:	00008797          	auipc	a5,0x8
    80202498:	bec78793          	addi	a5,a5,-1044 # 8020a080 <kernel_pagetable>
    8020249c:	639c                	ld	a5,0(a5)
    8020249e:	fe043583          	ld	a1,-32(s0)
    802024a2:	853e                	mv	a0,a5
    802024a4:	00000097          	auipc	ra,0x0
    802024a8:	904080e7          	jalr	-1788(ra) # 80201da8 <walk_lookup>
    802024ac:	fca43c23          	sd	a0,-40(s0)
    if (pte && (*pte & PTE_V)) {
    802024b0:	fd843783          	ld	a5,-40(s0)
    802024b4:	c3dd                	beqz	a5,8020255a <handle_page_fault+0x11e>
    802024b6:	fd843783          	ld	a5,-40(s0)
    802024ba:	639c                	ld	a5,0(a5)
    802024bc:	8b85                	andi	a5,a5,1
    802024be:	cfd1                	beqz	a5,8020255a <handle_page_fault+0x11e>
        int need_perm = 0;
    802024c0:	fe042623          	sw	zero,-20(s0)
        if (type == 1) need_perm = PTE_X;
    802024c4:	fc442783          	lw	a5,-60(s0)
    802024c8:	0007871b          	sext.w	a4,a5
    802024cc:	4785                	li	a5,1
    802024ce:	00f71663          	bne	a4,a5,802024da <handle_page_fault+0x9e>
    802024d2:	47a1                	li	a5,8
    802024d4:	fef42623          	sw	a5,-20(s0)
    802024d8:	a035                	j	80202504 <handle_page_fault+0xc8>
        else if (type == 2) need_perm = PTE_R;
    802024da:	fc442783          	lw	a5,-60(s0)
    802024de:	0007871b          	sext.w	a4,a5
    802024e2:	4789                	li	a5,2
    802024e4:	00f71663          	bne	a4,a5,802024f0 <handle_page_fault+0xb4>
    802024e8:	4789                	li	a5,2
    802024ea:	fef42623          	sw	a5,-20(s0)
    802024ee:	a819                	j	80202504 <handle_page_fault+0xc8>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    802024f0:	fc442783          	lw	a5,-60(s0)
    802024f4:	0007871b          	sext.w	a4,a5
    802024f8:	478d                	li	a5,3
    802024fa:	00f71563          	bne	a4,a5,80202504 <handle_page_fault+0xc8>
    802024fe:	4799                	li	a5,6
    80202500:	fef42623          	sw	a5,-20(s0)
        if ((*pte & need_perm) != need_perm) {
    80202504:	fd843783          	ld	a5,-40(s0)
    80202508:	6398                	ld	a4,0(a5)
    8020250a:	fec42783          	lw	a5,-20(s0)
    8020250e:	8f7d                	and	a4,a4,a5
    80202510:	fec42783          	lw	a5,-20(s0)
    80202514:	02f70963          	beq	a4,a5,80202546 <handle_page_fault+0x10a>
            *pte |= need_perm;
    80202518:	fd843783          	ld	a5,-40(s0)
    8020251c:	6398                	ld	a4,0(a5)
    8020251e:	fec42783          	lw	a5,-20(s0)
    80202522:	8f5d                	or	a4,a4,a5
    80202524:	fd843783          	ld	a5,-40(s0)
    80202528:	e398                	sd	a4,0(a5)
            sfence_vma();
    8020252a:	00000097          	auipc	ra,0x0
    8020252e:	e82080e7          	jalr	-382(ra) # 802023ac <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    80202532:	00005517          	auipc	a0,0x5
    80202536:	ab650513          	addi	a0,a0,-1354 # 80206fe8 <small_numbers+0xbf8>
    8020253a:	ffffe097          	auipc	ra,0xffffe
    8020253e:	5f4080e7          	jalr	1524(ra) # 80200b2e <printf>
            return 1;
    80202542:	4785                	li	a5,1
    80202544:	a8ed                	j	8020263e <handle_page_fault+0x202>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80202546:	00005517          	auipc	a0,0x5
    8020254a:	aca50513          	addi	a0,a0,-1334 # 80207010 <small_numbers+0xc20>
    8020254e:	ffffe097          	auipc	ra,0xffffe
    80202552:	5e0080e7          	jalr	1504(ra) # 80200b2e <printf>
        return 1;
    80202556:	4785                	li	a5,1
    80202558:	a0dd                	j	8020263e <handle_page_fault+0x202>
    void* page = alloc_page();
    8020255a:	00000097          	auipc	ra,0x0
    8020255e:	530080e7          	jalr	1328(ra) # 80202a8a <alloc_page>
    80202562:	fca43823          	sd	a0,-48(s0)
    if (page == 0) {
    80202566:	fd043783          	ld	a5,-48(s0)
    8020256a:	eb99                	bnez	a5,80202580 <handle_page_fault+0x144>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    8020256c:	00005517          	auipc	a0,0x5
    80202570:	ad450513          	addi	a0,a0,-1324 # 80207040 <small_numbers+0xc50>
    80202574:	ffffe097          	auipc	ra,0xffffe
    80202578:	5ba080e7          	jalr	1466(ra) # 80200b2e <printf>
        return 0; // 内存不足
    8020257c:	4781                	li	a5,0
    8020257e:	a0c1                	j	8020263e <handle_page_fault+0x202>
    memset(page, 0, PGSIZE);
    80202580:	6605                	lui	a2,0x1
    80202582:	4581                	li	a1,0
    80202584:	fd043503          	ld	a0,-48(s0)
    80202588:	fffff097          	auipc	ra,0xfffff
    8020258c:	5ec080e7          	jalr	1516(ra) # 80201b74 <memset>
    int perm = 0;
    80202590:	fe042423          	sw	zero,-24(s0)
    if (type == 1) {  // 指令页
    80202594:	fc442783          	lw	a5,-60(s0)
    80202598:	0007871b          	sext.w	a4,a5
    8020259c:	4785                	li	a5,1
    8020259e:	00f71663          	bne	a4,a5,802025aa <handle_page_fault+0x16e>
        perm = PTE_X | PTE_R;  // 可执行页通常也需要可读
    802025a2:	47a9                	li	a5,10
    802025a4:	fef42423          	sw	a5,-24(s0)
    802025a8:	a035                	j	802025d4 <handle_page_fault+0x198>
    } else if (type == 2) {  // 读数据页
    802025aa:	fc442783          	lw	a5,-60(s0)
    802025ae:	0007871b          	sext.w	a4,a5
    802025b2:	4789                	li	a5,2
    802025b4:	00f71663          	bne	a4,a5,802025c0 <handle_page_fault+0x184>
        perm = PTE_R;
    802025b8:	4789                	li	a5,2
    802025ba:	fef42423          	sw	a5,-24(s0)
    802025be:	a819                	j	802025d4 <handle_page_fault+0x198>
    } else if (type == 3) {  // 写数据页
    802025c0:	fc442783          	lw	a5,-60(s0)
    802025c4:	0007871b          	sext.w	a4,a5
    802025c8:	478d                	li	a5,3
    802025ca:	00f71563          	bne	a4,a5,802025d4 <handle_page_fault+0x198>
        perm = PTE_R | PTE_W;
    802025ce:	4799                	li	a5,6
    802025d0:	fef42423          	sw	a5,-24(s0)
    if (map_page(kernel_pagetable, page_va, (uint64)page, perm) != 0) {
    802025d4:	00008797          	auipc	a5,0x8
    802025d8:	aac78793          	addi	a5,a5,-1364 # 8020a080 <kernel_pagetable>
    802025dc:	639c                	ld	a5,0(a5)
    802025de:	fd043703          	ld	a4,-48(s0)
    802025e2:	fe842683          	lw	a3,-24(s0)
    802025e6:	863a                	mv	a2,a4
    802025e8:	fe043583          	ld	a1,-32(s0)
    802025ec:	853e                	mv	a0,a5
    802025ee:	00000097          	auipc	ra,0x0
    802025f2:	946080e7          	jalr	-1722(ra) # 80201f34 <map_page>
    802025f6:	87aa                	mv	a5,a0
    802025f8:	c38d                	beqz	a5,8020261a <handle_page_fault+0x1de>
        free_page(page);
    802025fa:	fd043503          	ld	a0,-48(s0)
    802025fe:	00000097          	auipc	ra,0x0
    80202602:	4f8080e7          	jalr	1272(ra) # 80202af6 <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    80202606:	00005517          	auipc	a0,0x5
    8020260a:	a6a50513          	addi	a0,a0,-1430 # 80207070 <small_numbers+0xc80>
    8020260e:	ffffe097          	auipc	ra,0xffffe
    80202612:	520080e7          	jalr	1312(ra) # 80200b2e <printf>
        return 0; // 映射失败
    80202616:	4781                	li	a5,0
    80202618:	a01d                	j	8020263e <handle_page_fault+0x202>
    sfence_vma();
    8020261a:	00000097          	auipc	ra,0x0
    8020261e:	d92080e7          	jalr	-622(ra) # 802023ac <sfence_vma>
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    80202622:	fd043783          	ld	a5,-48(s0)
    80202626:	863e                	mv	a2,a5
    80202628:	fe043583          	ld	a1,-32(s0)
    8020262c:	00005517          	auipc	a0,0x5
    80202630:	a6c50513          	addi	a0,a0,-1428 # 80207098 <small_numbers+0xca8>
    80202634:	ffffe097          	auipc	ra,0xffffe
    80202638:	4fa080e7          	jalr	1274(ra) # 80200b2e <printf>
    return 1; // 处理成功
    8020263c:	4785                	li	a5,1
}
    8020263e:	853e                	mv	a0,a5
    80202640:	70e2                	ld	ra,56(sp)
    80202642:	7442                	ld	s0,48(sp)
    80202644:	6121                	addi	sp,sp,64
    80202646:	8082                	ret

0000000080202648 <test_pagetable>:
void test_pagetable(void) {
    80202648:	7179                	addi	sp,sp,-48
    8020264a:	f406                	sd	ra,40(sp)
    8020264c:	f022                	sd	s0,32(sp)
    8020264e:	1800                	addi	s0,sp,48
    printf("[PT TEST] 创建页表...\n");
    80202650:	00005517          	auipc	a0,0x5
    80202654:	a8850513          	addi	a0,a0,-1400 # 802070d8 <small_numbers+0xce8>
    80202658:	ffffe097          	auipc	ra,0xffffe
    8020265c:	4d6080e7          	jalr	1238(ra) # 80200b2e <printf>
    pagetable_t pt = create_pagetable();
    80202660:	fffff097          	auipc	ra,0xfffff
    80202664:	70c080e7          	jalr	1804(ra) # 80201d6c <create_pagetable>
    80202668:	fea43423          	sd	a0,-24(s0)
    assert(pt != 0);
    8020266c:	fe843783          	ld	a5,-24(s0)
    80202670:	00f037b3          	snez	a5,a5
    80202674:	0ff7f793          	zext.b	a5,a5
    80202678:	2781                	sext.w	a5,a5
    8020267a:	853e                	mv	a0,a5
    8020267c:	fffff097          	auipc	ra,0xfffff
    80202680:	66a080e7          	jalr	1642(ra) # 80201ce6 <assert>
    printf("[PT TEST] 页表创建通过\n");
    80202684:	00005517          	auipc	a0,0x5
    80202688:	a7450513          	addi	a0,a0,-1420 # 802070f8 <small_numbers+0xd08>
    8020268c:	ffffe097          	auipc	ra,0xffffe
    80202690:	4a2080e7          	jalr	1186(ra) # 80200b2e <printf>
    uint64 va = 0x1000000;
    80202694:	010007b7          	lui	a5,0x1000
    80202698:	fef43023          	sd	a5,-32(s0)
    uint64 pa = (uint64)alloc_page();
    8020269c:	00000097          	auipc	ra,0x0
    802026a0:	3ee080e7          	jalr	1006(ra) # 80202a8a <alloc_page>
    802026a4:	87aa                	mv	a5,a0
    802026a6:	fcf43c23          	sd	a5,-40(s0)
    assert(pa != 0);
    802026aa:	fd843783          	ld	a5,-40(s0)
    802026ae:	00f037b3          	snez	a5,a5
    802026b2:	0ff7f793          	zext.b	a5,a5
    802026b6:	2781                	sext.w	a5,a5
    802026b8:	853e                	mv	a0,a5
    802026ba:	fffff097          	auipc	ra,0xfffff
    802026be:	62c080e7          	jalr	1580(ra) # 80201ce6 <assert>
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0);
    802026c2:	4699                	li	a3,6
    802026c4:	fd843603          	ld	a2,-40(s0)
    802026c8:	fe043583          	ld	a1,-32(s0)
    802026cc:	fe843503          	ld	a0,-24(s0)
    802026d0:	00000097          	auipc	ra,0x0
    802026d4:	864080e7          	jalr	-1948(ra) # 80201f34 <map_page>
    802026d8:	87aa                	mv	a5,a0
    802026da:	0017b793          	seqz	a5,a5
    802026de:	0ff7f793          	zext.b	a5,a5
    802026e2:	2781                	sext.w	a5,a5
    802026e4:	853e                	mv	a0,a5
    802026e6:	fffff097          	auipc	ra,0xfffff
    802026ea:	600080e7          	jalr	1536(ra) # 80201ce6 <assert>
    printf("[PT TEST] 映射测试通过\n");
    802026ee:	00005517          	auipc	a0,0x5
    802026f2:	a2a50513          	addi	a0,a0,-1494 # 80207118 <small_numbers+0xd28>
    802026f6:	ffffe097          	auipc	ra,0xffffe
    802026fa:	438080e7          	jalr	1080(ra) # 80200b2e <printf>
    pte_t *pte = walk_lookup(pt, va);
    802026fe:	fe043583          	ld	a1,-32(s0)
    80202702:	fe843503          	ld	a0,-24(s0)
    80202706:	fffff097          	auipc	ra,0xfffff
    8020270a:	6a2080e7          	jalr	1698(ra) # 80201da8 <walk_lookup>
    8020270e:	fca43823          	sd	a0,-48(s0)
    assert(pte != 0 && (*pte & PTE_V));
    80202712:	fd043783          	ld	a5,-48(s0)
    80202716:	cb81                	beqz	a5,80202726 <test_pagetable+0xde>
    80202718:	fd043783          	ld	a5,-48(s0)
    8020271c:	639c                	ld	a5,0(a5)
    8020271e:	8b85                	andi	a5,a5,1
    80202720:	c399                	beqz	a5,80202726 <test_pagetable+0xde>
    80202722:	4785                	li	a5,1
    80202724:	a011                	j	80202728 <test_pagetable+0xe0>
    80202726:	4781                	li	a5,0
    80202728:	853e                	mv	a0,a5
    8020272a:	fffff097          	auipc	ra,0xfffff
    8020272e:	5bc080e7          	jalr	1468(ra) # 80201ce6 <assert>
    assert(PTE2PA(*pte) == pa);
    80202732:	fd043783          	ld	a5,-48(s0)
    80202736:	639c                	ld	a5,0(a5)
    80202738:	83a9                	srli	a5,a5,0xa
    8020273a:	07b2                	slli	a5,a5,0xc
    8020273c:	fd843703          	ld	a4,-40(s0)
    80202740:	40f707b3          	sub	a5,a4,a5
    80202744:	0017b793          	seqz	a5,a5
    80202748:	0ff7f793          	zext.b	a5,a5
    8020274c:	2781                	sext.w	a5,a5
    8020274e:	853e                	mv	a0,a5
    80202750:	fffff097          	auipc	ra,0xfffff
    80202754:	596080e7          	jalr	1430(ra) # 80201ce6 <assert>
    printf("[PT TEST] 地址转换测试通过\n");
    80202758:	00005517          	auipc	a0,0x5
    8020275c:	9e050513          	addi	a0,a0,-1568 # 80207138 <small_numbers+0xd48>
    80202760:	ffffe097          	auipc	ra,0xffffe
    80202764:	3ce080e7          	jalr	974(ra) # 80200b2e <printf>
    assert(*pte & PTE_R);
    80202768:	fd043783          	ld	a5,-48(s0)
    8020276c:	639c                	ld	a5,0(a5)
    8020276e:	2781                	sext.w	a5,a5
    80202770:	8b89                	andi	a5,a5,2
    80202772:	2781                	sext.w	a5,a5
    80202774:	853e                	mv	a0,a5
    80202776:	fffff097          	auipc	ra,0xfffff
    8020277a:	570080e7          	jalr	1392(ra) # 80201ce6 <assert>
    assert(*pte & PTE_W);
    8020277e:	fd043783          	ld	a5,-48(s0)
    80202782:	639c                	ld	a5,0(a5)
    80202784:	2781                	sext.w	a5,a5
    80202786:	8b91                	andi	a5,a5,4
    80202788:	2781                	sext.w	a5,a5
    8020278a:	853e                	mv	a0,a5
    8020278c:	fffff097          	auipc	ra,0xfffff
    80202790:	55a080e7          	jalr	1370(ra) # 80201ce6 <assert>
    assert(!(*pte & PTE_X));
    80202794:	fd043783          	ld	a5,-48(s0)
    80202798:	639c                	ld	a5,0(a5)
    8020279a:	8ba1                	andi	a5,a5,8
    8020279c:	0017b793          	seqz	a5,a5
    802027a0:	0ff7f793          	zext.b	a5,a5
    802027a4:	2781                	sext.w	a5,a5
    802027a6:	853e                	mv	a0,a5
    802027a8:	fffff097          	auipc	ra,0xfffff
    802027ac:	53e080e7          	jalr	1342(ra) # 80201ce6 <assert>
    printf("[PT TEST] 权限测试通过\n");
    802027b0:	00005517          	auipc	a0,0x5
    802027b4:	9b050513          	addi	a0,a0,-1616 # 80207160 <small_numbers+0xd70>
    802027b8:	ffffe097          	auipc	ra,0xffffe
    802027bc:	376080e7          	jalr	886(ra) # 80200b2e <printf>
    free_page((void*)pa);
    802027c0:	fd843783          	ld	a5,-40(s0)
    802027c4:	853e                	mv	a0,a5
    802027c6:	00000097          	auipc	ra,0x0
    802027ca:	330080e7          	jalr	816(ra) # 80202af6 <free_page>
    free_pagetable(pt);
    802027ce:	fe843503          	ld	a0,-24(s0)
    802027d2:	00000097          	auipc	ra,0x0
    802027d6:	848080e7          	jalr	-1976(ra) # 8020201a <free_pagetable>
    printf("[PT TEST] 所有页表测试通过\n");
    802027da:	00005517          	auipc	a0,0x5
    802027de:	9a650513          	addi	a0,a0,-1626 # 80207180 <small_numbers+0xd90>
    802027e2:	ffffe097          	auipc	ra,0xffffe
    802027e6:	34c080e7          	jalr	844(ra) # 80200b2e <printf>
}
    802027ea:	0001                	nop
    802027ec:	70a2                	ld	ra,40(sp)
    802027ee:	7402                	ld	s0,32(sp)
    802027f0:	6145                	addi	sp,sp,48
    802027f2:	8082                	ret

00000000802027f4 <check_mapping>:
void check_mapping(uint64 va) {
    802027f4:	7179                	addi	sp,sp,-48
    802027f6:	f406                	sd	ra,40(sp)
    802027f8:	f022                	sd	s0,32(sp)
    802027fa:	1800                	addi	s0,sp,48
    802027fc:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    80202800:	00008797          	auipc	a5,0x8
    80202804:	88078793          	addi	a5,a5,-1920 # 8020a080 <kernel_pagetable>
    80202808:	639c                	ld	a5,0(a5)
    8020280a:	fd843583          	ld	a1,-40(s0)
    8020280e:	853e                	mv	a0,a5
    80202810:	fffff097          	auipc	ra,0xfffff
    80202814:	598080e7          	jalr	1432(ra) # 80201da8 <walk_lookup>
    80202818:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    8020281c:	fe843783          	ld	a5,-24(s0)
    80202820:	c78d                	beqz	a5,8020284a <check_mapping+0x56>
    80202822:	fe843783          	ld	a5,-24(s0)
    80202826:	639c                	ld	a5,0(a5)
    80202828:	8b85                	andi	a5,a5,1
    8020282a:	c385                	beqz	a5,8020284a <check_mapping+0x56>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    8020282c:	fe843783          	ld	a5,-24(s0)
    80202830:	639c                	ld	a5,0(a5)
    80202832:	863e                	mv	a2,a5
    80202834:	fd843583          	ld	a1,-40(s0)
    80202838:	00005517          	auipc	a0,0x5
    8020283c:	97050513          	addi	a0,a0,-1680 # 802071a8 <small_numbers+0xdb8>
    80202840:	ffffe097          	auipc	ra,0xffffe
    80202844:	2ee080e7          	jalr	750(ra) # 80200b2e <printf>
    80202848:	a821                	j	80202860 <check_mapping+0x6c>
        printf("Address 0x%lx is NOT mapped\n", va);
    8020284a:	fd843583          	ld	a1,-40(s0)
    8020284e:	00005517          	auipc	a0,0x5
    80202852:	98250513          	addi	a0,a0,-1662 # 802071d0 <small_numbers+0xde0>
    80202856:	ffffe097          	auipc	ra,0xffffe
    8020285a:	2d8080e7          	jalr	728(ra) # 80200b2e <printf>
}
    8020285e:	0001                	nop
    80202860:	0001                	nop
    80202862:	70a2                	ld	ra,40(sp)
    80202864:	7402                	ld	s0,32(sp)
    80202866:	6145                	addi	sp,sp,48
    80202868:	8082                	ret

000000008020286a <check_is_mapped>:
int check_is_mapped(uint64 va) {
    8020286a:	7179                	addi	sp,sp,-48
    8020286c:	f406                	sd	ra,40(sp)
    8020286e:	f022                	sd	s0,32(sp)
    80202870:	1800                	addi	s0,sp,48
    80202872:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    80202876:	00000097          	auipc	ra,0x0
    8020287a:	bae080e7          	jalr	-1106(ra) # 80202424 <get_current_pagetable>
    8020287e:	87aa                	mv	a5,a0
    80202880:	fd843583          	ld	a1,-40(s0)
    80202884:	853e                	mv	a0,a5
    80202886:	fffff097          	auipc	ra,0xfffff
    8020288a:	522080e7          	jalr	1314(ra) # 80201da8 <walk_lookup>
    8020288e:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    80202892:	fe843783          	ld	a5,-24(s0)
    80202896:	c795                	beqz	a5,802028c2 <check_is_mapped+0x58>
    80202898:	fe843783          	ld	a5,-24(s0)
    8020289c:	639c                	ld	a5,0(a5)
    8020289e:	8b85                	andi	a5,a5,1
    802028a0:	c38d                	beqz	a5,802028c2 <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    802028a2:	fe843783          	ld	a5,-24(s0)
    802028a6:	639c                	ld	a5,0(a5)
    802028a8:	863e                	mv	a2,a5
    802028aa:	fd843583          	ld	a1,-40(s0)
    802028ae:	00005517          	auipc	a0,0x5
    802028b2:	8fa50513          	addi	a0,a0,-1798 # 802071a8 <small_numbers+0xdb8>
    802028b6:	ffffe097          	auipc	ra,0xffffe
    802028ba:	278080e7          	jalr	632(ra) # 80200b2e <printf>
        return 1;
    802028be:	4785                	li	a5,1
    802028c0:	a821                	j	802028d8 <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    802028c2:	fd843583          	ld	a1,-40(s0)
    802028c6:	00005517          	auipc	a0,0x5
    802028ca:	90a50513          	addi	a0,a0,-1782 # 802071d0 <small_numbers+0xde0>
    802028ce:	ffffe097          	auipc	ra,0xffffe
    802028d2:	260080e7          	jalr	608(ra) # 80200b2e <printf>
        return 0;
    802028d6:	4781                	li	a5,0
}
    802028d8:	853e                	mv	a0,a5
    802028da:	70a2                	ld	ra,40(sp)
    802028dc:	7402                	ld	s0,32(sp)
    802028de:	6145                	addi	sp,sp,48
    802028e0:	8082                	ret

00000000802028e2 <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    802028e2:	711d                	addi	sp,sp,-96
    802028e4:	ec86                	sd	ra,88(sp)
    802028e6:	e8a2                	sd	s0,80(sp)
    802028e8:	1080                	addi	s0,sp,96
    802028ea:	faa43c23          	sd	a0,-72(s0)
    802028ee:	fab43823          	sd	a1,-80(s0)
    802028f2:	fac43423          	sd	a2,-88(s0)
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    802028f6:	fe043423          	sd	zero,-24(s0)
    802028fa:	a075                	j	802029a6 <uvmcopy+0xc4>
        pte_t *pte = walk_lookup(old, i);
    802028fc:	fe843583          	ld	a1,-24(s0)
    80202900:	fb843503          	ld	a0,-72(s0)
    80202904:	fffff097          	auipc	ra,0xfffff
    80202908:	4a4080e7          	jalr	1188(ra) # 80201da8 <walk_lookup>
    8020290c:	fea43023          	sd	a0,-32(s0)
        if (pte == 0 || (*pte & PTE_V) == 0)
    80202910:	fe043783          	ld	a5,-32(s0)
    80202914:	c3d1                	beqz	a5,80202998 <uvmcopy+0xb6>
    80202916:	fe043783          	ld	a5,-32(s0)
    8020291a:	639c                	ld	a5,0(a5)
    8020291c:	8b85                	andi	a5,a5,1
    8020291e:	cfad                	beqz	a5,80202998 <uvmcopy+0xb6>
        uint64 pa = PTE2PA(*pte);
    80202920:	fe043783          	ld	a5,-32(s0)
    80202924:	639c                	ld	a5,0(a5)
    80202926:	83a9                	srli	a5,a5,0xa
    80202928:	07b2                	slli	a5,a5,0xc
    8020292a:	fcf43c23          	sd	a5,-40(s0)
        int flags = PTE_FLAGS(*pte);
    8020292e:	fe043783          	ld	a5,-32(s0)
    80202932:	639c                	ld	a5,0(a5)
    80202934:	2781                	sext.w	a5,a5
    80202936:	3ff7f793          	andi	a5,a5,1023
    8020293a:	fcf42a23          	sw	a5,-44(s0)
        void *mem = alloc_page();
    8020293e:	00000097          	auipc	ra,0x0
    80202942:	14c080e7          	jalr	332(ra) # 80202a8a <alloc_page>
    80202946:	fca43423          	sd	a0,-56(s0)
        if (mem == 0)
    8020294a:	fc843783          	ld	a5,-56(s0)
    8020294e:	e399                	bnez	a5,80202954 <uvmcopy+0x72>
            return -1; // 分配失败
    80202950:	57fd                	li	a5,-1
    80202952:	a08d                	j	802029b4 <uvmcopy+0xd2>
        memmove(mem, (void*)pa, PGSIZE);
    80202954:	fd843783          	ld	a5,-40(s0)
    80202958:	6605                	lui	a2,0x1
    8020295a:	85be                	mv	a1,a5
    8020295c:	fc843503          	ld	a0,-56(s0)
    80202960:	fffff097          	auipc	ra,0xfffff
    80202964:	264080e7          	jalr	612(ra) # 80201bc4 <memmove>
        if (map_page(new, i, (uint64)mem, flags) != 0) {
    80202968:	fc843783          	ld	a5,-56(s0)
    8020296c:	fd442703          	lw	a4,-44(s0)
    80202970:	86ba                	mv	a3,a4
    80202972:	863e                	mv	a2,a5
    80202974:	fe843583          	ld	a1,-24(s0)
    80202978:	fb043503          	ld	a0,-80(s0)
    8020297c:	fffff097          	auipc	ra,0xfffff
    80202980:	5b8080e7          	jalr	1464(ra) # 80201f34 <map_page>
    80202984:	87aa                	mv	a5,a0
    80202986:	cb91                	beqz	a5,8020299a <uvmcopy+0xb8>
            free_page(mem);
    80202988:	fc843503          	ld	a0,-56(s0)
    8020298c:	00000097          	auipc	ra,0x0
    80202990:	16a080e7          	jalr	362(ra) # 80202af6 <free_page>
            return -1;
    80202994:	57fd                	li	a5,-1
    80202996:	a839                	j	802029b4 <uvmcopy+0xd2>
            continue; // 跳过未分配的页
    80202998:	0001                	nop
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    8020299a:	fe843703          	ld	a4,-24(s0)
    8020299e:	6785                	lui	a5,0x1
    802029a0:	97ba                	add	a5,a5,a4
    802029a2:	fef43423          	sd	a5,-24(s0)
    802029a6:	fe843703          	ld	a4,-24(s0)
    802029aa:	fa843783          	ld	a5,-88(s0)
    802029ae:	f4f767e3          	bltu	a4,a5,802028fc <uvmcopy+0x1a>
    return 0;
    802029b2:	4781                	li	a5,0
    802029b4:	853e                	mv	a0,a5
    802029b6:	60e6                	ld	ra,88(sp)
    802029b8:	6446                	ld	s0,80(sp)
    802029ba:	6125                	addi	sp,sp,96
    802029bc:	8082                	ret

00000000802029be <assert>:
    802029be:	1101                	addi	sp,sp,-32
    802029c0:	ec06                	sd	ra,24(sp)
    802029c2:	e822                	sd	s0,16(sp)
    802029c4:	1000                	addi	s0,sp,32
    802029c6:	87aa                	mv	a5,a0
    802029c8:	fef42623          	sw	a5,-20(s0)
    802029cc:	fec42783          	lw	a5,-20(s0)
    802029d0:	2781                	sext.w	a5,a5
    802029d2:	e79d                	bnez	a5,80202a00 <assert+0x42>
    802029d4:	18800613          	li	a2,392
    802029d8:	00005597          	auipc	a1,0x5
    802029dc:	81858593          	addi	a1,a1,-2024 # 802071f0 <small_numbers+0xe00>
    802029e0:	00005517          	auipc	a0,0x5
    802029e4:	82050513          	addi	a0,a0,-2016 # 80207200 <small_numbers+0xe10>
    802029e8:	ffffe097          	auipc	ra,0xffffe
    802029ec:	146080e7          	jalr	326(ra) # 80200b2e <printf>
    802029f0:	00005517          	auipc	a0,0x5
    802029f4:	83850513          	addi	a0,a0,-1992 # 80207228 <small_numbers+0xe38>
    802029f8:	fffff097          	auipc	ra,0xfffff
    802029fc:	a3e080e7          	jalr	-1474(ra) # 80201436 <panic>
    80202a00:	0001                	nop
    80202a02:	60e2                	ld	ra,24(sp)
    80202a04:	6442                	ld	s0,16(sp)
    80202a06:	6105                	addi	sp,sp,32
    80202a08:	8082                	ret

0000000080202a0a <freerange>:
static void freerange(void *pa_start, void *pa_end) {
    80202a0a:	7179                	addi	sp,sp,-48
    80202a0c:	f406                	sd	ra,40(sp)
    80202a0e:	f022                	sd	s0,32(sp)
    80202a10:	1800                	addi	s0,sp,48
    80202a12:	fca43c23          	sd	a0,-40(s0)
    80202a16:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    80202a1a:	fd843703          	ld	a4,-40(s0)
    80202a1e:	6785                	lui	a5,0x1
    80202a20:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80202a22:	973e                	add	a4,a4,a5
    80202a24:	77fd                	lui	a5,0xfffff
    80202a26:	8ff9                	and	a5,a5,a4
    80202a28:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80202a2c:	a829                	j	80202a46 <freerange+0x3c>
    free_page(p);
    80202a2e:	fe843503          	ld	a0,-24(s0)
    80202a32:	00000097          	auipc	ra,0x0
    80202a36:	0c4080e7          	jalr	196(ra) # 80202af6 <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80202a3a:	fe843703          	ld	a4,-24(s0)
    80202a3e:	6785                	lui	a5,0x1
    80202a40:	97ba                	add	a5,a5,a4
    80202a42:	fef43423          	sd	a5,-24(s0)
    80202a46:	fe843703          	ld	a4,-24(s0)
    80202a4a:	6785                	lui	a5,0x1
    80202a4c:	97ba                	add	a5,a5,a4
    80202a4e:	fd043703          	ld	a4,-48(s0)
    80202a52:	fcf77ee3          	bgeu	a4,a5,80202a2e <freerange+0x24>
}
    80202a56:	0001                	nop
    80202a58:	0001                	nop
    80202a5a:	70a2                	ld	ra,40(sp)
    80202a5c:	7402                	ld	s0,32(sp)
    80202a5e:	6145                	addi	sp,sp,48
    80202a60:	8082                	ret

0000000080202a62 <pmm_init>:
void pmm_init(void) {
    80202a62:	1141                	addi	sp,sp,-16
    80202a64:	e406                	sd	ra,8(sp)
    80202a66:	e022                	sd	s0,0(sp)
    80202a68:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    80202a6a:	47c5                	li	a5,17
    80202a6c:	01b79593          	slli	a1,a5,0x1b
    80202a70:	0000a517          	auipc	a0,0xa
    80202a74:	9e050513          	addi	a0,a0,-1568 # 8020c450 <_bss_end>
    80202a78:	00000097          	auipc	ra,0x0
    80202a7c:	f92080e7          	jalr	-110(ra) # 80202a0a <freerange>
}
    80202a80:	0001                	nop
    80202a82:	60a2                	ld	ra,8(sp)
    80202a84:	6402                	ld	s0,0(sp)
    80202a86:	0141                	addi	sp,sp,16
    80202a88:	8082                	ret

0000000080202a8a <alloc_page>:
void* alloc_page(void) {
    80202a8a:	1101                	addi	sp,sp,-32
    80202a8c:	ec06                	sd	ra,24(sp)
    80202a8e:	e822                	sd	s0,16(sp)
    80202a90:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80202a92:	00007797          	auipc	a5,0x7
    80202a96:	72678793          	addi	a5,a5,1830 # 8020a1b8 <freelist>
    80202a9a:	639c                	ld	a5,0(a5)
    80202a9c:	fef43423          	sd	a5,-24(s0)
  if(r)
    80202aa0:	fe843783          	ld	a5,-24(s0)
    80202aa4:	cb89                	beqz	a5,80202ab6 <alloc_page+0x2c>
    freelist = r->next;
    80202aa6:	fe843783          	ld	a5,-24(s0)
    80202aaa:	6398                	ld	a4,0(a5)
    80202aac:	00007797          	auipc	a5,0x7
    80202ab0:	70c78793          	addi	a5,a5,1804 # 8020a1b8 <freelist>
    80202ab4:	e398                	sd	a4,0(a5)
  if(r)
    80202ab6:	fe843783          	ld	a5,-24(s0)
    80202aba:	cf99                	beqz	a5,80202ad8 <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    80202abc:	fe843783          	ld	a5,-24(s0)
    80202ac0:	00878713          	addi	a4,a5,8
    80202ac4:	6785                	lui	a5,0x1
    80202ac6:	ff878613          	addi	a2,a5,-8 # ff8 <userret+0xf5c>
    80202aca:	4595                	li	a1,5
    80202acc:	853a                	mv	a0,a4
    80202ace:	fffff097          	auipc	ra,0xfffff
    80202ad2:	0a6080e7          	jalr	166(ra) # 80201b74 <memset>
    80202ad6:	a809                	j	80202ae8 <alloc_page+0x5e>
    panic("alloc_page: out of memory");
    80202ad8:	00004517          	auipc	a0,0x4
    80202adc:	75850513          	addi	a0,a0,1880 # 80207230 <small_numbers+0xe40>
    80202ae0:	fffff097          	auipc	ra,0xfffff
    80202ae4:	956080e7          	jalr	-1706(ra) # 80201436 <panic>
  return (void*)r;
    80202ae8:	fe843783          	ld	a5,-24(s0)
}
    80202aec:	853e                	mv	a0,a5
    80202aee:	60e2                	ld	ra,24(sp)
    80202af0:	6442                	ld	s0,16(sp)
    80202af2:	6105                	addi	sp,sp,32
    80202af4:	8082                	ret

0000000080202af6 <free_page>:
void free_page(void* page) {
    80202af6:	7179                	addi	sp,sp,-48
    80202af8:	f406                	sd	ra,40(sp)
    80202afa:	f022                	sd	s0,32(sp)
    80202afc:	1800                	addi	s0,sp,48
    80202afe:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    80202b02:	fd843783          	ld	a5,-40(s0)
    80202b06:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    80202b0a:	fd843703          	ld	a4,-40(s0)
    80202b0e:	6785                	lui	a5,0x1
    80202b10:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80202b12:	8ff9                	and	a5,a5,a4
    80202b14:	ef99                	bnez	a5,80202b32 <free_page+0x3c>
    80202b16:	fd843703          	ld	a4,-40(s0)
    80202b1a:	0000a797          	auipc	a5,0xa
    80202b1e:	93678793          	addi	a5,a5,-1738 # 8020c450 <_bss_end>
    80202b22:	00f76863          	bltu	a4,a5,80202b32 <free_page+0x3c>
    80202b26:	fd843703          	ld	a4,-40(s0)
    80202b2a:	47c5                	li	a5,17
    80202b2c:	07ee                	slli	a5,a5,0x1b
    80202b2e:	00f76a63          	bltu	a4,a5,80202b42 <free_page+0x4c>
    panic("free_page: invalid page address");
    80202b32:	00004517          	auipc	a0,0x4
    80202b36:	71e50513          	addi	a0,a0,1822 # 80207250 <small_numbers+0xe60>
    80202b3a:	fffff097          	auipc	ra,0xfffff
    80202b3e:	8fc080e7          	jalr	-1796(ra) # 80201436 <panic>
  r->next = freelist;
    80202b42:	00007797          	auipc	a5,0x7
    80202b46:	67678793          	addi	a5,a5,1654 # 8020a1b8 <freelist>
    80202b4a:	6398                	ld	a4,0(a5)
    80202b4c:	fe843783          	ld	a5,-24(s0)
    80202b50:	e398                	sd	a4,0(a5)
  freelist = r;
    80202b52:	00007797          	auipc	a5,0x7
    80202b56:	66678793          	addi	a5,a5,1638 # 8020a1b8 <freelist>
    80202b5a:	fe843703          	ld	a4,-24(s0)
    80202b5e:	e398                	sd	a4,0(a5)
}
    80202b60:	0001                	nop
    80202b62:	70a2                	ld	ra,40(sp)
    80202b64:	7402                	ld	s0,32(sp)
    80202b66:	6145                	addi	sp,sp,48
    80202b68:	8082                	ret

0000000080202b6a <test_physical_memory>:
void test_physical_memory(void) {
    80202b6a:	7179                	addi	sp,sp,-48
    80202b6c:	f406                	sd	ra,40(sp)
    80202b6e:	f022                	sd	s0,32(sp)
    80202b70:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    80202b72:	00004517          	auipc	a0,0x4
    80202b76:	6fe50513          	addi	a0,a0,1790 # 80207270 <small_numbers+0xe80>
    80202b7a:	ffffe097          	auipc	ra,0xffffe
    80202b7e:	fb4080e7          	jalr	-76(ra) # 80200b2e <printf>
    void *page1 = alloc_page();
    80202b82:	00000097          	auipc	ra,0x0
    80202b86:	f08080e7          	jalr	-248(ra) # 80202a8a <alloc_page>
    80202b8a:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    80202b8e:	00000097          	auipc	ra,0x0
    80202b92:	efc080e7          	jalr	-260(ra) # 80202a8a <alloc_page>
    80202b96:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    80202b9a:	fe843783          	ld	a5,-24(s0)
    80202b9e:	00f037b3          	snez	a5,a5
    80202ba2:	0ff7f793          	zext.b	a5,a5
    80202ba6:	2781                	sext.w	a5,a5
    80202ba8:	853e                	mv	a0,a5
    80202baa:	00000097          	auipc	ra,0x0
    80202bae:	e14080e7          	jalr	-492(ra) # 802029be <assert>
    assert(page2 != 0);
    80202bb2:	fe043783          	ld	a5,-32(s0)
    80202bb6:	00f037b3          	snez	a5,a5
    80202bba:	0ff7f793          	zext.b	a5,a5
    80202bbe:	2781                	sext.w	a5,a5
    80202bc0:	853e                	mv	a0,a5
    80202bc2:	00000097          	auipc	ra,0x0
    80202bc6:	dfc080e7          	jalr	-516(ra) # 802029be <assert>
    assert(page1 != page2);
    80202bca:	fe843703          	ld	a4,-24(s0)
    80202bce:	fe043783          	ld	a5,-32(s0)
    80202bd2:	40f707b3          	sub	a5,a4,a5
    80202bd6:	00f037b3          	snez	a5,a5
    80202bda:	0ff7f793          	zext.b	a5,a5
    80202bde:	2781                	sext.w	a5,a5
    80202be0:	853e                	mv	a0,a5
    80202be2:	00000097          	auipc	ra,0x0
    80202be6:	ddc080e7          	jalr	-548(ra) # 802029be <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    80202bea:	fe843703          	ld	a4,-24(s0)
    80202bee:	6785                	lui	a5,0x1
    80202bf0:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80202bf2:	8ff9                	and	a5,a5,a4
    80202bf4:	0017b793          	seqz	a5,a5
    80202bf8:	0ff7f793          	zext.b	a5,a5
    80202bfc:	2781                	sext.w	a5,a5
    80202bfe:	853e                	mv	a0,a5
    80202c00:	00000097          	auipc	ra,0x0
    80202c04:	dbe080e7          	jalr	-578(ra) # 802029be <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    80202c08:	fe043703          	ld	a4,-32(s0)
    80202c0c:	6785                	lui	a5,0x1
    80202c0e:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80202c10:	8ff9                	and	a5,a5,a4
    80202c12:	0017b793          	seqz	a5,a5
    80202c16:	0ff7f793          	zext.b	a5,a5
    80202c1a:	2781                	sext.w	a5,a5
    80202c1c:	853e                	mv	a0,a5
    80202c1e:	00000097          	auipc	ra,0x0
    80202c22:	da0080e7          	jalr	-608(ra) # 802029be <assert>
    printf("[PM TEST] 分配测试通过\n");
    80202c26:	00004517          	auipc	a0,0x4
    80202c2a:	66a50513          	addi	a0,a0,1642 # 80207290 <small_numbers+0xea0>
    80202c2e:	ffffe097          	auipc	ra,0xffffe
    80202c32:	f00080e7          	jalr	-256(ra) # 80200b2e <printf>
    printf("[PM TEST] 数据写入测试...\n");
    80202c36:	00004517          	auipc	a0,0x4
    80202c3a:	67a50513          	addi	a0,a0,1658 # 802072b0 <small_numbers+0xec0>
    80202c3e:	ffffe097          	auipc	ra,0xffffe
    80202c42:	ef0080e7          	jalr	-272(ra) # 80200b2e <printf>
    *(int*)page1 = 0x12345678;
    80202c46:	fe843783          	ld	a5,-24(s0)
    80202c4a:	12345737          	lui	a4,0x12345
    80202c4e:	67870713          	addi	a4,a4,1656 # 12345678 <userret+0x123455dc>
    80202c52:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    80202c54:	fe843783          	ld	a5,-24(s0)
    80202c58:	439c                	lw	a5,0(a5)
    80202c5a:	873e                	mv	a4,a5
    80202c5c:	123457b7          	lui	a5,0x12345
    80202c60:	67878793          	addi	a5,a5,1656 # 12345678 <userret+0x123455dc>
    80202c64:	40f707b3          	sub	a5,a4,a5
    80202c68:	0017b793          	seqz	a5,a5
    80202c6c:	0ff7f793          	zext.b	a5,a5
    80202c70:	2781                	sext.w	a5,a5
    80202c72:	853e                	mv	a0,a5
    80202c74:	00000097          	auipc	ra,0x0
    80202c78:	d4a080e7          	jalr	-694(ra) # 802029be <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    80202c7c:	00004517          	auipc	a0,0x4
    80202c80:	65c50513          	addi	a0,a0,1628 # 802072d8 <small_numbers+0xee8>
    80202c84:	ffffe097          	auipc	ra,0xffffe
    80202c88:	eaa080e7          	jalr	-342(ra) # 80200b2e <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    80202c8c:	00004517          	auipc	a0,0x4
    80202c90:	67450513          	addi	a0,a0,1652 # 80207300 <small_numbers+0xf10>
    80202c94:	ffffe097          	auipc	ra,0xffffe
    80202c98:	e9a080e7          	jalr	-358(ra) # 80200b2e <printf>
    free_page(page1);
    80202c9c:	fe843503          	ld	a0,-24(s0)
    80202ca0:	00000097          	auipc	ra,0x0
    80202ca4:	e56080e7          	jalr	-426(ra) # 80202af6 <free_page>
    void *page3 = alloc_page();
    80202ca8:	00000097          	auipc	ra,0x0
    80202cac:	de2080e7          	jalr	-542(ra) # 80202a8a <alloc_page>
    80202cb0:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    80202cb4:	fd843783          	ld	a5,-40(s0)
    80202cb8:	00f037b3          	snez	a5,a5
    80202cbc:	0ff7f793          	zext.b	a5,a5
    80202cc0:	2781                	sext.w	a5,a5
    80202cc2:	853e                	mv	a0,a5
    80202cc4:	00000097          	auipc	ra,0x0
    80202cc8:	cfa080e7          	jalr	-774(ra) # 802029be <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    80202ccc:	00004517          	auipc	a0,0x4
    80202cd0:	66450513          	addi	a0,a0,1636 # 80207330 <small_numbers+0xf40>
    80202cd4:	ffffe097          	auipc	ra,0xffffe
    80202cd8:	e5a080e7          	jalr	-422(ra) # 80200b2e <printf>
    free_page(page2);
    80202cdc:	fe043503          	ld	a0,-32(s0)
    80202ce0:	00000097          	auipc	ra,0x0
    80202ce4:	e16080e7          	jalr	-490(ra) # 80202af6 <free_page>
    free_page(page3);
    80202ce8:	fd843503          	ld	a0,-40(s0)
    80202cec:	00000097          	auipc	ra,0x0
    80202cf0:	e0a080e7          	jalr	-502(ra) # 80202af6 <free_page>
    printf("[PM TEST] 所有物理内存管理测试通过\n");
    80202cf4:	00004517          	auipc	a0,0x4
    80202cf8:	66c50513          	addi	a0,a0,1644 # 80207360 <small_numbers+0xf70>
    80202cfc:	ffffe097          	auipc	ra,0xffffe
    80202d00:	e32080e7          	jalr	-462(ra) # 80200b2e <printf>
    80202d04:	0001                	nop
    80202d06:	70a2                	ld	ra,40(sp)
    80202d08:	7402                	ld	s0,32(sp)
    80202d0a:	6145                	addi	sp,sp,48
    80202d0c:	8082                	ret

0000000080202d0e <sbi_set_time>:
#include "defs.h"

void sbi_set_time(uint64 time) {
    80202d0e:	1101                	addi	sp,sp,-32
    80202d10:	ec22                	sd	s0,24(sp)
    80202d12:	1000                	addi	s0,sp,32
    80202d14:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    80202d18:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    80202d1c:	4881                	li	a7,0
    asm volatile ("ecall"
    80202d1e:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    80202d22:	0001                	nop
    80202d24:	6462                	ld	s0,24(sp)
    80202d26:	6105                	addi	sp,sp,32
    80202d28:	8082                	ret

0000000080202d2a <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    80202d2a:	1101                	addi	sp,sp,-32
    80202d2c:	ec22                	sd	s0,24(sp)
    80202d2e:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    80202d30:	c01027f3          	rdtime	a5
    80202d34:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    80202d38:	fe843783          	ld	a5,-24(s0)
    80202d3c:	853e                	mv	a0,a5
    80202d3e:	6462                	ld	s0,24(sp)
    80202d40:	6105                	addi	sp,sp,32
    80202d42:	8082                	ret

0000000080202d44 <timeintr>:
#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    80202d44:	1141                	addi	sp,sp,-16
    80202d46:	e422                	sd	s0,8(sp)
    80202d48:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    80202d4a:	00007797          	auipc	a5,0x7
    80202d4e:	33e78793          	addi	a5,a5,830 # 8020a088 <interrupt_test_flag>
    80202d52:	639c                	ld	a5,0(a5)
    80202d54:	cb99                	beqz	a5,80202d6a <timeintr+0x26>
        (*interrupt_test_flag)++;
    80202d56:	00007797          	auipc	a5,0x7
    80202d5a:	33278793          	addi	a5,a5,818 # 8020a088 <interrupt_test_flag>
    80202d5e:	639c                	ld	a5,0(a5)
    80202d60:	4398                	lw	a4,0(a5)
    80202d62:	2701                	sext.w	a4,a4
    80202d64:	2705                	addiw	a4,a4,1
    80202d66:	2701                	sext.w	a4,a4
    80202d68:	c398                	sw	a4,0(a5)
    80202d6a:	0001                	nop
    80202d6c:	6422                	ld	s0,8(sp)
    80202d6e:	0141                	addi	sp,sp,16
    80202d70:	8082                	ret

0000000080202d72 <r_sie>:
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    }
    
    // 3. 测试加载页故障
    printf("3. 测试加载页故障异常...\n");
    80202d72:	1101                	addi	sp,sp,-32
    80202d74:	ec22                	sd	s0,24(sp)
    80202d76:	1000                	addi	s0,sp,32
    invalid_ptr = 0;
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80202d78:	104027f3          	csrr	a5,sie
    80202d7c:	fef43423          	sd	a5,-24(s0)
        if (check_is_mapped(addr) == 0) {
    80202d80:	fe843783          	ld	a5,-24(s0)
            invalid_ptr = (uint64*)addr;
    80202d84:	853e                	mv	a0,a5
    80202d86:	6462                	ld	s0,24(sp)
    80202d88:	6105                	addi	sp,sp,32
    80202d8a:	8082                	ret

0000000080202d8c <w_sie>:
            printf("找到未映射地址: 0x%lx\n", addr);
            break;
    80202d8c:	1101                	addi	sp,sp,-32
    80202d8e:	ec22                	sd	s0,24(sp)
    80202d90:	1000                	addi	s0,sp,32
    80202d92:	fea43423          	sd	a0,-24(s0)
        }
    80202d96:	fe843783          	ld	a5,-24(s0)
    80202d9a:	10479073          	csrw	sie,a5
    }
    80202d9e:	0001                	nop
    80202da0:	6462                	ld	s0,24(sp)
    80202da2:	6105                	addi	sp,sp,32
    80202da4:	8082                	ret

0000000080202da6 <r_sstatus>:
    
    if (invalid_ptr != 0) {
    80202da6:	1101                	addi	sp,sp,-32
    80202da8:	ec22                	sd	s0,24(sp)
    80202daa:	1000                	addi	s0,sp,32
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    80202dac:	100027f3          	csrr	a5,sstatus
    80202db0:	fef43423          	sd	a5,-24(s0)
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    80202db4:	fe843783          	ld	a5,-24(s0)
        printf("✓ 加载页故障异常处理成功\n\n");
    80202db8:	853e                	mv	a0,a5
    80202dba:	6462                	ld	s0,24(sp)
    80202dbc:	6105                	addi	sp,sp,32
    80202dbe:	8082                	ret

0000000080202dc0 <w_sstatus>:
    } else {
    80202dc0:	1101                	addi	sp,sp,-32
    80202dc2:	ec22                	sd	s0,24(sp)
    80202dc4:	1000                	addi	s0,sp,32
    80202dc6:	fea43423          	sd	a0,-24(s0)
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80202dca:	fe843783          	ld	a5,-24(s0)
    80202dce:	10079073          	csrw	sstatus,a5
    }
    80202dd2:	0001                	nop
    80202dd4:	6462                	ld	s0,24(sp)
    80202dd6:	6105                	addi	sp,sp,32
    80202dd8:	8082                	ret

0000000080202dda <w_sepc>:
    
    // 4. 测试存储地址未对齐异常
    80202dda:	1101                	addi	sp,sp,-32
    80202ddc:	ec22                	sd	s0,24(sp)
    80202dde:	1000                	addi	s0,sp,32
    80202de0:	fea43423          	sd	a0,-24(s0)
    printf("4. 测试存储地址未对齐异常...\n");
    80202de4:	fe843783          	ld	a5,-24(s0)
    80202de8:	14179073          	csrw	sepc,a5
    uint64 aligned_addr = (uint64)alloc_page();
    80202dec:	0001                	nop
    80202dee:	6462                	ld	s0,24(sp)
    80202df0:	6105                	addi	sp,sp,32
    80202df2:	8082                	ret

0000000080202df4 <intr_off>:
    if (aligned_addr != 0) {
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
        
        // 使用内联汇编进行未对齐访问，因为编译器可能会自动对齐
        asm volatile (
    80202df4:	1141                	addi	sp,sp,-16
    80202df6:	e406                	sd	ra,8(sp)
    80202df8:	e022                	sd	s0,0(sp)
    80202dfa:	0800                	addi	s0,sp,16
            "sd %0, 0(%1)"
    80202dfc:	00000097          	auipc	ra,0x0
    80202e00:	faa080e7          	jalr	-86(ra) # 80202da6 <r_sstatus>
    80202e04:	87aa                	mv	a5,a0
    80202e06:	9bf5                	andi	a5,a5,-3
    80202e08:	853e                	mv	a0,a5
    80202e0a:	00000097          	auipc	ra,0x0
    80202e0e:	fb6080e7          	jalr	-74(ra) # 80202dc0 <w_sstatus>
            : 
    80202e12:	0001                	nop
    80202e14:	60a2                	ld	ra,8(sp)
    80202e16:	6402                	ld	s0,0(sp)
    80202e18:	0141                	addi	sp,sp,16
    80202e1a:	8082                	ret

0000000080202e1c <w_stvec>:
            : "r" (0xdeadbeef), "r" (misaligned_addr)
            : "memory"
    80202e1c:	1101                	addi	sp,sp,-32
    80202e1e:	ec22                	sd	s0,24(sp)
    80202e20:	1000                	addi	s0,sp,32
    80202e22:	fea43423          	sd	a0,-24(s0)
        );
    80202e26:	fe843783          	ld	a5,-24(s0)
    80202e2a:	10579073          	csrw	stvec,a5
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    80202e2e:	0001                	nop
    80202e30:	6462                	ld	s0,24(sp)
    80202e32:	6105                	addi	sp,sp,32
    80202e34:	8082                	ret

0000000080202e36 <r_scause>:
    }
    
    // 5. 测试加载地址未对齐异常
    printf("5. 测试加载地址未对齐异常...\n");
    if (aligned_addr != 0) {
        uint64 misaligned_addr = aligned_addr + 1;
    80202e36:	1101                	addi	sp,sp,-32
    80202e38:	ec22                	sd	s0,24(sp)
    80202e3a:	1000                	addi	s0,sp,32
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
        
    80202e3c:	142027f3          	csrr	a5,scause
    80202e40:	fef43423          	sd	a5,-24(s0)
        uint64 value = 0;
    80202e44:	fe843783          	ld	a5,-24(s0)
        asm volatile (
    80202e48:	853e                	mv	a0,a5
    80202e4a:	6462                	ld	s0,24(sp)
    80202e4c:	6105                	addi	sp,sp,32
    80202e4e:	8082                	ret

0000000080202e50 <r_sepc>:
            "ld %0, 0(%1)"
            : "=r" (value)
    80202e50:	1101                	addi	sp,sp,-32
    80202e52:	ec22                	sd	s0,24(sp)
    80202e54:	1000                	addi	s0,sp,32
            : "r" (misaligned_addr)
            : "memory"
    80202e56:	141027f3          	csrr	a5,sepc
    80202e5a:	fef43423          	sd	a5,-24(s0)
        );
    80202e5e:	fe843783          	ld	a5,-24(s0)
        printf("读取的值: 0x%lx\n", value);
    80202e62:	853e                	mv	a0,a5
    80202e64:	6462                	ld	s0,24(sp)
    80202e66:	6105                	addi	sp,sp,32
    80202e68:	8082                	ret

0000000080202e6a <r_stval>:
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    } else {
    80202e6a:	1101                	addi	sp,sp,-32
    80202e6c:	ec22                	sd	s0,24(sp)
    80202e6e:	1000                	addi	s0,sp,32
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    }
    80202e70:	143027f3          	csrr	a5,stval
    80202e74:	fef43423          	sd	a5,-24(s0)

    80202e78:	fe843783          	ld	a5,-24(s0)
	// 6. 测试断点异常
    80202e7c:	853e                	mv	a0,a5
    80202e7e:	6462                	ld	s0,24(sp)
    80202e80:	6105                	addi	sp,sp,32
    80202e82:	8082                	ret

0000000080202e84 <save_exception_info>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    80202e84:	7139                	addi	sp,sp,-64
    80202e86:	fc22                	sd	s0,56(sp)
    80202e88:	0080                	addi	s0,sp,64
    80202e8a:	fea43423          	sd	a0,-24(s0)
    80202e8e:	feb43023          	sd	a1,-32(s0)
    80202e92:	fcc43c23          	sd	a2,-40(s0)
    80202e96:	fcd43823          	sd	a3,-48(s0)
    80202e9a:	fce43423          	sd	a4,-56(s0)
    tf->epc = sepc;
    80202e9e:	fe843783          	ld	a5,-24(s0)
    80202ea2:	fe043703          	ld	a4,-32(s0)
    80202ea6:	ef98                	sd	a4,24(a5)
}
    80202ea8:	0001                	nop
    80202eaa:	7462                	ld	s0,56(sp)
    80202eac:	6121                	addi	sp,sp,64
    80202eae:	8082                	ret

0000000080202eb0 <get_sepc>:
static inline uint64 get_sepc(struct trapframe *tf) {
    80202eb0:	1101                	addi	sp,sp,-32
    80202eb2:	ec22                	sd	s0,24(sp)
    80202eb4:	1000                	addi	s0,sp,32
    80202eb6:	fea43423          	sd	a0,-24(s0)
    return tf->epc;
    80202eba:	fe843783          	ld	a5,-24(s0)
    80202ebe:	6f9c                	ld	a5,24(a5)
}
    80202ec0:	853e                	mv	a0,a5
    80202ec2:	6462                	ld	s0,24(sp)
    80202ec4:	6105                	addi	sp,sp,32
    80202ec6:	8082                	ret

0000000080202ec8 <set_sepc>:
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    80202ec8:	1101                	addi	sp,sp,-32
    80202eca:	ec22                	sd	s0,24(sp)
    80202ecc:	1000                	addi	s0,sp,32
    80202ece:	fea43423          	sd	a0,-24(s0)
    80202ed2:	feb43023          	sd	a1,-32(s0)
    tf->epc = sepc;
    80202ed6:	fe843783          	ld	a5,-24(s0)
    80202eda:	fe043703          	ld	a4,-32(s0)
    80202ede:	ef98                	sd	a4,24(a5)
}
    80202ee0:	0001                	nop
    80202ee2:	6462                	ld	s0,24(sp)
    80202ee4:	6105                	addi	sp,sp,32
    80202ee6:	8082                	ret

0000000080202ee8 <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    80202ee8:	1101                	addi	sp,sp,-32
    80202eea:	ec22                	sd	s0,24(sp)
    80202eec:	1000                	addi	s0,sp,32
    80202eee:	87aa                	mv	a5,a0
    80202ef0:	feb43023          	sd	a1,-32(s0)
    80202ef4:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    80202ef8:	fec42783          	lw	a5,-20(s0)
    80202efc:	2781                	sext.w	a5,a5
    80202efe:	0207c563          	bltz	a5,80202f28 <register_interrupt+0x40>
    80202f02:	fec42783          	lw	a5,-20(s0)
    80202f06:	0007871b          	sext.w	a4,a5
    80202f0a:	03f00793          	li	a5,63
    80202f0e:	00e7cd63          	blt	a5,a4,80202f28 <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    80202f12:	00007717          	auipc	a4,0x7
    80202f16:	2ae70713          	addi	a4,a4,686 # 8020a1c0 <interrupt_vector>
    80202f1a:	fec42783          	lw	a5,-20(s0)
    80202f1e:	078e                	slli	a5,a5,0x3
    80202f20:	97ba                	add	a5,a5,a4
    80202f22:	fe043703          	ld	a4,-32(s0)
    80202f26:	e398                	sd	a4,0(a5)
}
    80202f28:	0001                	nop
    80202f2a:	6462                	ld	s0,24(sp)
    80202f2c:	6105                	addi	sp,sp,32
    80202f2e:	8082                	ret

0000000080202f30 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    80202f30:	1101                	addi	sp,sp,-32
    80202f32:	ec22                	sd	s0,24(sp)
    80202f34:	1000                	addi	s0,sp,32
    80202f36:	87aa                	mv	a5,a0
    80202f38:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    80202f3c:	fec42783          	lw	a5,-20(s0)
    80202f40:	2781                	sext.w	a5,a5
    80202f42:	0207c463          	bltz	a5,80202f6a <unregister_interrupt+0x3a>
    80202f46:	fec42783          	lw	a5,-20(s0)
    80202f4a:	0007871b          	sext.w	a4,a5
    80202f4e:	03f00793          	li	a5,63
    80202f52:	00e7cc63          	blt	a5,a4,80202f6a <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    80202f56:	00007717          	auipc	a4,0x7
    80202f5a:	26a70713          	addi	a4,a4,618 # 8020a1c0 <interrupt_vector>
    80202f5e:	fec42783          	lw	a5,-20(s0)
    80202f62:	078e                	slli	a5,a5,0x3
    80202f64:	97ba                	add	a5,a5,a4
    80202f66:	0007b023          	sd	zero,0(a5)
}
    80202f6a:	0001                	nop
    80202f6c:	6462                	ld	s0,24(sp)
    80202f6e:	6105                	addi	sp,sp,32
    80202f70:	8082                	ret

0000000080202f72 <enable_interrupts>:
void enable_interrupts(int irq) {
    80202f72:	1101                	addi	sp,sp,-32
    80202f74:	ec06                	sd	ra,24(sp)
    80202f76:	e822                	sd	s0,16(sp)
    80202f78:	1000                	addi	s0,sp,32
    80202f7a:	87aa                	mv	a5,a0
    80202f7c:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    80202f80:	fec42783          	lw	a5,-20(s0)
    80202f84:	853e                	mv	a0,a5
    80202f86:	00001097          	auipc	ra,0x1
    80202f8a:	c8e080e7          	jalr	-882(ra) # 80203c14 <plic_enable>
}
    80202f8e:	0001                	nop
    80202f90:	60e2                	ld	ra,24(sp)
    80202f92:	6442                	ld	s0,16(sp)
    80202f94:	6105                	addi	sp,sp,32
    80202f96:	8082                	ret

0000000080202f98 <disable_interrupts>:
void disable_interrupts(int irq) {
    80202f98:	1101                	addi	sp,sp,-32
    80202f9a:	ec06                	sd	ra,24(sp)
    80202f9c:	e822                	sd	s0,16(sp)
    80202f9e:	1000                	addi	s0,sp,32
    80202fa0:	87aa                	mv	a5,a0
    80202fa2:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    80202fa6:	fec42783          	lw	a5,-20(s0)
    80202faa:	853e                	mv	a0,a5
    80202fac:	00001097          	auipc	ra,0x1
    80202fb0:	cc0080e7          	jalr	-832(ra) # 80203c6c <plic_disable>
}
    80202fb4:	0001                	nop
    80202fb6:	60e2                	ld	ra,24(sp)
    80202fb8:	6442                	ld	s0,16(sp)
    80202fba:	6105                	addi	sp,sp,32
    80202fbc:	8082                	ret

0000000080202fbe <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    80202fbe:	1101                	addi	sp,sp,-32
    80202fc0:	ec06                	sd	ra,24(sp)
    80202fc2:	e822                	sd	s0,16(sp)
    80202fc4:	1000                	addi	s0,sp,32
    80202fc6:	87aa                	mv	a5,a0
    80202fc8:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    80202fcc:	fec42783          	lw	a5,-20(s0)
    80202fd0:	2781                	sext.w	a5,a5
    80202fd2:	0207ce63          	bltz	a5,8020300e <interrupt_dispatch+0x50>
    80202fd6:	fec42783          	lw	a5,-20(s0)
    80202fda:	0007871b          	sext.w	a4,a5
    80202fde:	03f00793          	li	a5,63
    80202fe2:	02e7c663          	blt	a5,a4,8020300e <interrupt_dispatch+0x50>
    80202fe6:	00007717          	auipc	a4,0x7
    80202fea:	1da70713          	addi	a4,a4,474 # 8020a1c0 <interrupt_vector>
    80202fee:	fec42783          	lw	a5,-20(s0)
    80202ff2:	078e                	slli	a5,a5,0x3
    80202ff4:	97ba                	add	a5,a5,a4
    80202ff6:	639c                	ld	a5,0(a5)
    80202ff8:	cb99                	beqz	a5,8020300e <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    80202ffa:	00007717          	auipc	a4,0x7
    80202ffe:	1c670713          	addi	a4,a4,454 # 8020a1c0 <interrupt_vector>
    80203002:	fec42783          	lw	a5,-20(s0)
    80203006:	078e                	slli	a5,a5,0x3
    80203008:	97ba                	add	a5,a5,a4
    8020300a:	639c                	ld	a5,0(a5)
    8020300c:	9782                	jalr	a5
}
    8020300e:	0001                	nop
    80203010:	60e2                	ld	ra,24(sp)
    80203012:	6442                	ld	s0,16(sp)
    80203014:	6105                	addi	sp,sp,32
    80203016:	8082                	ret

0000000080203018 <handle_external_interrupt>:
void handle_external_interrupt(void) {
    80203018:	1101                	addi	sp,sp,-32
    8020301a:	ec06                	sd	ra,24(sp)
    8020301c:	e822                	sd	s0,16(sp)
    8020301e:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    80203020:	00001097          	auipc	ra,0x1
    80203024:	caa080e7          	jalr	-854(ra) # 80203cca <plic_claim>
    80203028:	87aa                	mv	a5,a0
    8020302a:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    8020302e:	fec42783          	lw	a5,-20(s0)
    80203032:	2781                	sext.w	a5,a5
    80203034:	eb91                	bnez	a5,80203048 <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    80203036:	00004517          	auipc	a0,0x4
    8020303a:	35a50513          	addi	a0,a0,858 # 80207390 <small_numbers+0xfa0>
    8020303e:	ffffe097          	auipc	ra,0xffffe
    80203042:	af0080e7          	jalr	-1296(ra) # 80200b2e <printf>
        return;
    80203046:	a839                	j	80203064 <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    80203048:	fec42783          	lw	a5,-20(s0)
    8020304c:	853e                	mv	a0,a5
    8020304e:	00000097          	auipc	ra,0x0
    80203052:	f70080e7          	jalr	-144(ra) # 80202fbe <interrupt_dispatch>
    plic_complete(irq);
    80203056:	fec42783          	lw	a5,-20(s0)
    8020305a:	853e                	mv	a0,a5
    8020305c:	00001097          	auipc	ra,0x1
    80203060:	c96080e7          	jalr	-874(ra) # 80203cf2 <plic_complete>
}
    80203064:	60e2                	ld	ra,24(sp)
    80203066:	6442                	ld	s0,16(sp)
    80203068:	6105                	addi	sp,sp,32
    8020306a:	8082                	ret

000000008020306c <trap_init>:
void trap_init(void) {
    8020306c:	1101                	addi	sp,sp,-32
    8020306e:	ec06                	sd	ra,24(sp)
    80203070:	e822                	sd	s0,16(sp)
    80203072:	1000                	addi	s0,sp,32
	intr_off();
    80203074:	00000097          	auipc	ra,0x0
    80203078:	d80080e7          	jalr	-640(ra) # 80202df4 <intr_off>
	printf("trap_init...\n");
    8020307c:	00004517          	auipc	a0,0x4
    80203080:	33450513          	addi	a0,a0,820 # 802073b0 <small_numbers+0xfc0>
    80203084:	ffffe097          	auipc	ra,0xffffe
    80203088:	aaa080e7          	jalr	-1366(ra) # 80200b2e <printf>
	w_stvec((uint64)kernelvec);
    8020308c:	00001797          	auipc	a5,0x1
    80203090:	c9478793          	addi	a5,a5,-876 # 80203d20 <kernelvec>
    80203094:	853e                	mv	a0,a5
    80203096:	00000097          	auipc	ra,0x0
    8020309a:	d86080e7          	jalr	-634(ra) # 80202e1c <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    8020309e:	fe042623          	sw	zero,-20(s0)
    802030a2:	a005                	j	802030c2 <trap_init+0x56>
		interrupt_vector[i] = 0;
    802030a4:	00007717          	auipc	a4,0x7
    802030a8:	11c70713          	addi	a4,a4,284 # 8020a1c0 <interrupt_vector>
    802030ac:	fec42783          	lw	a5,-20(s0)
    802030b0:	078e                	slli	a5,a5,0x3
    802030b2:	97ba                	add	a5,a5,a4
    802030b4:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    802030b8:	fec42783          	lw	a5,-20(s0)
    802030bc:	2785                	addiw	a5,a5,1
    802030be:	fef42623          	sw	a5,-20(s0)
    802030c2:	fec42783          	lw	a5,-20(s0)
    802030c6:	0007871b          	sext.w	a4,a5
    802030ca:	03f00793          	li	a5,63
    802030ce:	fce7dbe3          	bge	a5,a4,802030a4 <trap_init+0x38>
	plic_init();
    802030d2:	00001097          	auipc	ra,0x1
    802030d6:	aa4080e7          	jalr	-1372(ra) # 80203b76 <plic_init>
    uint64 sie = r_sie();
    802030da:	00000097          	auipc	ra,0x0
    802030de:	c98080e7          	jalr	-872(ra) # 80202d72 <r_sie>
    802030e2:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    802030e6:	fe043783          	ld	a5,-32(s0)
    802030ea:	2207e793          	ori	a5,a5,544
    802030ee:	853e                	mv	a0,a5
    802030f0:	00000097          	auipc	ra,0x0
    802030f4:	c9c080e7          	jalr	-868(ra) # 80202d8c <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802030f8:	00000097          	auipc	ra,0x0
    802030fc:	c32080e7          	jalr	-974(ra) # 80202d2a <sbi_get_time>
    80203100:	872a                	mv	a4,a0
    80203102:	000f47b7          	lui	a5,0xf4
    80203106:	24078793          	addi	a5,a5,576 # f4240 <userret+0xf41a4>
    8020310a:	97ba                	add	a5,a5,a4
    8020310c:	853e                	mv	a0,a5
    8020310e:	00000097          	auipc	ra,0x0
    80203112:	c00080e7          	jalr	-1024(ra) # 80202d0e <sbi_set_time>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    80203116:	00000597          	auipc	a1,0x0
    8020311a:	57258593          	addi	a1,a1,1394 # 80203688 <handle_store_page_fault>
    8020311e:	00004517          	auipc	a0,0x4
    80203122:	2a250513          	addi	a0,a0,674 # 802073c0 <small_numbers+0xfd0>
    80203126:	ffffe097          	auipc	ra,0xffffe
    8020312a:	a08080e7          	jalr	-1528(ra) # 80200b2e <printf>
	printf("trap_init complete.\n");
    8020312e:	00004517          	auipc	a0,0x4
    80203132:	2ca50513          	addi	a0,a0,714 # 802073f8 <small_numbers+0x1008>
    80203136:	ffffe097          	auipc	ra,0xffffe
    8020313a:	9f8080e7          	jalr	-1544(ra) # 80200b2e <printf>
}
    8020313e:	0001                	nop
    80203140:	60e2                	ld	ra,24(sp)
    80203142:	6442                	ld	s0,16(sp)
    80203144:	6105                	addi	sp,sp,32
    80203146:	8082                	ret

0000000080203148 <kerneltrap>:
void kerneltrap(void) {
    80203148:	7149                	addi	sp,sp,-368
    8020314a:	f686                	sd	ra,360(sp)
    8020314c:	f2a2                	sd	s0,352(sp)
    8020314e:	1a80                	addi	s0,sp,368
    uint64 sstatus = r_sstatus();
    80203150:	00000097          	auipc	ra,0x0
    80203154:	c56080e7          	jalr	-938(ra) # 80202da6 <r_sstatus>
    80203158:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    8020315c:	00000097          	auipc	ra,0x0
    80203160:	cda080e7          	jalr	-806(ra) # 80202e36 <r_scause>
    80203164:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    80203168:	00000097          	auipc	ra,0x0
    8020316c:	ce8080e7          	jalr	-792(ra) # 80202e50 <r_sepc>
    80203170:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    80203174:	00000097          	auipc	ra,0x0
    80203178:	cf6080e7          	jalr	-778(ra) # 80202e6a <r_stval>
    8020317c:	fca43823          	sd	a0,-48(s0)
    if(scause & 0x8000000000000000) {
    80203180:	fd843783          	ld	a5,-40(s0)
    80203184:	0607d663          	bgez	a5,802031f0 <kerneltrap+0xa8>
        if((scause & 0xff) == 5) {
    80203188:	fd843783          	ld	a5,-40(s0)
    8020318c:	0ff7f713          	zext.b	a4,a5
    80203190:	4795                	li	a5,5
    80203192:	02f71663          	bne	a4,a5,802031be <kerneltrap+0x76>
            timeintr();
    80203196:	00000097          	auipc	ra,0x0
    8020319a:	bae080e7          	jalr	-1106(ra) # 80202d44 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    8020319e:	00000097          	auipc	ra,0x0
    802031a2:	b8c080e7          	jalr	-1140(ra) # 80202d2a <sbi_get_time>
    802031a6:	872a                	mv	a4,a0
    802031a8:	000f47b7          	lui	a5,0xf4
    802031ac:	24078793          	addi	a5,a5,576 # f4240 <userret+0xf41a4>
    802031b0:	97ba                	add	a5,a5,a4
    802031b2:	853e                	mv	a0,a5
    802031b4:	00000097          	auipc	ra,0x0
    802031b8:	b5a080e7          	jalr	-1190(ra) # 80202d0e <sbi_set_time>
    802031bc:	a855                	j	80203270 <kerneltrap+0x128>
        } else if((scause & 0xff) == 9) {
    802031be:	fd843783          	ld	a5,-40(s0)
    802031c2:	0ff7f713          	zext.b	a4,a5
    802031c6:	47a5                	li	a5,9
    802031c8:	00f71763          	bne	a4,a5,802031d6 <kerneltrap+0x8e>
            handle_external_interrupt();
    802031cc:	00000097          	auipc	ra,0x0
    802031d0:	e4c080e7          	jalr	-436(ra) # 80203018 <handle_external_interrupt>
    802031d4:	a871                	j	80203270 <kerneltrap+0x128>
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    802031d6:	fe843603          	ld	a2,-24(s0)
    802031da:	fd843583          	ld	a1,-40(s0)
    802031de:	00004517          	auipc	a0,0x4
    802031e2:	23250513          	addi	a0,a0,562 # 80207410 <small_numbers+0x1020>
    802031e6:	ffffe097          	auipc	ra,0xffffe
    802031ea:	948080e7          	jalr	-1720(ra) # 80200b2e <printf>
    802031ee:	a049                	j	80203270 <kerneltrap+0x128>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    802031f0:	fd043683          	ld	a3,-48(s0)
    802031f4:	fe843603          	ld	a2,-24(s0)
    802031f8:	fd843583          	ld	a1,-40(s0)
    802031fc:	00004517          	auipc	a0,0x4
    80203200:	24c50513          	addi	a0,a0,588 # 80207448 <small_numbers+0x1058>
    80203204:	ffffe097          	auipc	ra,0xffffe
    80203208:	92a080e7          	jalr	-1750(ra) # 80200b2e <printf>
        save_exception_info(&tf, sepc, sstatus, scause, stval);
    8020320c:	eb040793          	addi	a5,s0,-336
    80203210:	fd043703          	ld	a4,-48(s0)
    80203214:	fd843683          	ld	a3,-40(s0)
    80203218:	fe043603          	ld	a2,-32(s0)
    8020321c:	fe843583          	ld	a1,-24(s0)
    80203220:	853e                	mv	a0,a5
    80203222:	00000097          	auipc	ra,0x0
    80203226:	c62080e7          	jalr	-926(ra) # 80202e84 <save_exception_info>
        info.sepc = sepc;
    8020322a:	fe843783          	ld	a5,-24(s0)
    8020322e:	e8f43823          	sd	a5,-368(s0)
        info.sstatus = sstatus;
    80203232:	fe043783          	ld	a5,-32(s0)
    80203236:	e8f43c23          	sd	a5,-360(s0)
        info.scause = scause;
    8020323a:	fd843783          	ld	a5,-40(s0)
    8020323e:	eaf43023          	sd	a5,-352(s0)
        info.stval = stval;
    80203242:	fd043783          	ld	a5,-48(s0)
    80203246:	eaf43423          	sd	a5,-344(s0)
        handle_exception(&tf, &info);
    8020324a:	e9040713          	addi	a4,s0,-368
    8020324e:	eb040793          	addi	a5,s0,-336
    80203252:	85ba                	mv	a1,a4
    80203254:	853e                	mv	a0,a5
    80203256:	00000097          	auipc	ra,0x0
    8020325a:	03c080e7          	jalr	60(ra) # 80203292 <handle_exception>
        sepc = get_sepc(&tf);
    8020325e:	eb040793          	addi	a5,s0,-336
    80203262:	853e                	mv	a0,a5
    80203264:	00000097          	auipc	ra,0x0
    80203268:	c4c080e7          	jalr	-948(ra) # 80202eb0 <get_sepc>
    8020326c:	fea43423          	sd	a0,-24(s0)
    w_sepc(sepc);
    80203270:	fe843503          	ld	a0,-24(s0)
    80203274:	00000097          	auipc	ra,0x0
    80203278:	b66080e7          	jalr	-1178(ra) # 80202dda <w_sepc>
    w_sstatus(sstatus);
    8020327c:	fe043503          	ld	a0,-32(s0)
    80203280:	00000097          	auipc	ra,0x0
    80203284:	b40080e7          	jalr	-1216(ra) # 80202dc0 <w_sstatus>
}
    80203288:	0001                	nop
    8020328a:	70b6                	ld	ra,360(sp)
    8020328c:	7416                	ld	s0,352(sp)
    8020328e:	6175                	addi	sp,sp,368
    80203290:	8082                	ret

0000000080203292 <handle_exception>:
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    80203292:	7179                	addi	sp,sp,-48
    80203294:	f406                	sd	ra,40(sp)
    80203296:	f022                	sd	s0,32(sp)
    80203298:	1800                	addi	s0,sp,48
    8020329a:	fca43c23          	sd	a0,-40(s0)
    8020329e:	fcb43823          	sd	a1,-48(s0)
    uint64 cause = info->scause;  // 使用info中的字段
    802032a2:	fd043783          	ld	a5,-48(s0)
    802032a6:	6b9c                	ld	a5,16(a5)
    802032a8:	fef43423          	sd	a5,-24(s0)
    switch (cause) {
    802032ac:	fe843703          	ld	a4,-24(s0)
    802032b0:	47bd                	li	a5,15
    802032b2:	26e7ef63          	bltu	a5,a4,80203530 <handle_exception+0x29e>
    802032b6:	fe843783          	ld	a5,-24(s0)
    802032ba:	00279713          	slli	a4,a5,0x2
    802032be:	00004797          	auipc	a5,0x4
    802032c2:	34678793          	addi	a5,a5,838 # 80207604 <small_numbers+0x1214>
    802032c6:	97ba                	add	a5,a5,a4
    802032c8:	439c                	lw	a5,0(a5)
    802032ca:	0007871b          	sext.w	a4,a5
    802032ce:	00004797          	auipc	a5,0x4
    802032d2:	33678793          	addi	a5,a5,822 # 80207604 <small_numbers+0x1214>
    802032d6:	97ba                	add	a5,a5,a4
    802032d8:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    802032da:	fd043783          	ld	a5,-48(s0)
    802032de:	6f9c                	ld	a5,24(a5)
    802032e0:	85be                	mv	a1,a5
    802032e2:	00004517          	auipc	a0,0x4
    802032e6:	19650513          	addi	a0,a0,406 # 80207478 <small_numbers+0x1088>
    802032ea:	ffffe097          	auipc	ra,0xffffe
    802032ee:	844080e7          	jalr	-1980(ra) # 80200b2e <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    802032f2:	fd043783          	ld	a5,-48(s0)
    802032f6:	639c                	ld	a5,0(a5)
    802032f8:	0791                	addi	a5,a5,4
    802032fa:	85be                	mv	a1,a5
    802032fc:	fd843503          	ld	a0,-40(s0)
    80203300:	00000097          	auipc	ra,0x0
    80203304:	bc8080e7          	jalr	-1080(ra) # 80202ec8 <set_sepc>
            break;
    80203308:	a495                	j	8020356c <handle_exception+0x2da>
            printf("Instruction access fault: 0x%lx\n", info->stval);
    8020330a:	fd043783          	ld	a5,-48(s0)
    8020330e:	6f9c                	ld	a5,24(a5)
    80203310:	85be                	mv	a1,a5
    80203312:	00004517          	auipc	a0,0x4
    80203316:	18e50513          	addi	a0,a0,398 # 802074a0 <small_numbers+0x10b0>
    8020331a:	ffffe097          	auipc	ra,0xffffe
    8020331e:	814080e7          	jalr	-2028(ra) # 80200b2e <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203322:	fd043783          	ld	a5,-48(s0)
    80203326:	639c                	ld	a5,0(a5)
    80203328:	0791                	addi	a5,a5,4
    8020332a:	85be                	mv	a1,a5
    8020332c:	fd843503          	ld	a0,-40(s0)
    80203330:	00000097          	auipc	ra,0x0
    80203334:	b98080e7          	jalr	-1128(ra) # 80202ec8 <set_sepc>
            break;
    80203338:	ac15                	j	8020356c <handle_exception+0x2da>
            printf("Illegal instruction at 0x%lx: 0x%lx\n", info->sepc, info->stval);
    8020333a:	fd043783          	ld	a5,-48(s0)
    8020333e:	6398                	ld	a4,0(a5)
    80203340:	fd043783          	ld	a5,-48(s0)
    80203344:	6f9c                	ld	a5,24(a5)
    80203346:	863e                	mv	a2,a5
    80203348:	85ba                	mv	a1,a4
    8020334a:	00004517          	auipc	a0,0x4
    8020334e:	17e50513          	addi	a0,a0,382 # 802074c8 <small_numbers+0x10d8>
    80203352:	ffffd097          	auipc	ra,0xffffd
    80203356:	7dc080e7          	jalr	2012(ra) # 80200b2e <printf>
			set_sepc(tf, info->sepc + 4); 
    8020335a:	fd043783          	ld	a5,-48(s0)
    8020335e:	639c                	ld	a5,0(a5)
    80203360:	0791                	addi	a5,a5,4
    80203362:	85be                	mv	a1,a5
    80203364:	fd843503          	ld	a0,-40(s0)
    80203368:	00000097          	auipc	ra,0x0
    8020336c:	b60080e7          	jalr	-1184(ra) # 80202ec8 <set_sepc>
            break;
    80203370:	aaf5                	j	8020356c <handle_exception+0x2da>
            printf("Breakpoint at 0x%lx\n", info->sepc);
    80203372:	fd043783          	ld	a5,-48(s0)
    80203376:	639c                	ld	a5,0(a5)
    80203378:	85be                	mv	a1,a5
    8020337a:	00004517          	auipc	a0,0x4
    8020337e:	17650513          	addi	a0,a0,374 # 802074f0 <small_numbers+0x1100>
    80203382:	ffffd097          	auipc	ra,0xffffd
    80203386:	7ac080e7          	jalr	1964(ra) # 80200b2e <printf>
            set_sepc(tf, info->sepc + 4);
    8020338a:	fd043783          	ld	a5,-48(s0)
    8020338e:	639c                	ld	a5,0(a5)
    80203390:	0791                	addi	a5,a5,4
    80203392:	85be                	mv	a1,a5
    80203394:	fd843503          	ld	a0,-40(s0)
    80203398:	00000097          	auipc	ra,0x0
    8020339c:	b30080e7          	jalr	-1232(ra) # 80202ec8 <set_sepc>
            break;
    802033a0:	a2f1                	j	8020356c <handle_exception+0x2da>
            printf("Load address misaligned: 0x%lx\n", info->stval);
    802033a2:	fd043783          	ld	a5,-48(s0)
    802033a6:	6f9c                	ld	a5,24(a5)
    802033a8:	85be                	mv	a1,a5
    802033aa:	00004517          	auipc	a0,0x4
    802033ae:	15e50513          	addi	a0,a0,350 # 80207508 <small_numbers+0x1118>
    802033b2:	ffffd097          	auipc	ra,0xffffd
    802033b6:	77c080e7          	jalr	1916(ra) # 80200b2e <printf>
			set_sepc(tf, info->sepc + 4); 
    802033ba:	fd043783          	ld	a5,-48(s0)
    802033be:	639c                	ld	a5,0(a5)
    802033c0:	0791                	addi	a5,a5,4
    802033c2:	85be                	mv	a1,a5
    802033c4:	fd843503          	ld	a0,-40(s0)
    802033c8:	00000097          	auipc	ra,0x0
    802033cc:	b00080e7          	jalr	-1280(ra) # 80202ec8 <set_sepc>
            break;
    802033d0:	aa71                	j	8020356c <handle_exception+0x2da>
			printf("Load access fault: 0x%lx\n", info->stval);
    802033d2:	fd043783          	ld	a5,-48(s0)
    802033d6:	6f9c                	ld	a5,24(a5)
    802033d8:	85be                	mv	a1,a5
    802033da:	00004517          	auipc	a0,0x4
    802033de:	14e50513          	addi	a0,a0,334 # 80207528 <small_numbers+0x1138>
    802033e2:	ffffd097          	auipc	ra,0xffffd
    802033e6:	74c080e7          	jalr	1868(ra) # 80200b2e <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
    802033ea:	fd043783          	ld	a5,-48(s0)
    802033ee:	6f9c                	ld	a5,24(a5)
    802033f0:	853e                	mv	a0,a5
    802033f2:	fffff097          	auipc	ra,0xfffff
    802033f6:	478080e7          	jalr	1144(ra) # 8020286a <check_is_mapped>
    802033fa:	87aa                	mv	a5,a0
    802033fc:	cf89                	beqz	a5,80203416 <handle_exception+0x184>
    802033fe:	fd043783          	ld	a5,-48(s0)
    80203402:	6f9c                	ld	a5,24(a5)
    80203404:	4589                	li	a1,2
    80203406:	853e                	mv	a0,a5
    80203408:	fffff097          	auipc	ra,0xfffff
    8020340c:	034080e7          	jalr	52(ra) # 8020243c <handle_page_fault>
    80203410:	87aa                	mv	a5,a0
    80203412:	14079a63          	bnez	a5,80203566 <handle_exception+0x2d4>
			set_sepc(tf, info->sepc + 4);
    80203416:	fd043783          	ld	a5,-48(s0)
    8020341a:	639c                	ld	a5,0(a5)
    8020341c:	0791                	addi	a5,a5,4
    8020341e:	85be                	mv	a1,a5
    80203420:	fd843503          	ld	a0,-40(s0)
    80203424:	00000097          	auipc	ra,0x0
    80203428:	aa4080e7          	jalr	-1372(ra) # 80202ec8 <set_sepc>
			break;
    8020342c:	a281                	j	8020356c <handle_exception+0x2da>
            printf("Store address misaligned: 0x%lx\n", info->stval);
    8020342e:	fd043783          	ld	a5,-48(s0)
    80203432:	6f9c                	ld	a5,24(a5)
    80203434:	85be                	mv	a1,a5
    80203436:	00004517          	auipc	a0,0x4
    8020343a:	11250513          	addi	a0,a0,274 # 80207548 <small_numbers+0x1158>
    8020343e:	ffffd097          	auipc	ra,0xffffd
    80203442:	6f0080e7          	jalr	1776(ra) # 80200b2e <printf>
			set_sepc(tf, info->sepc + 4); 
    80203446:	fd043783          	ld	a5,-48(s0)
    8020344a:	639c                	ld	a5,0(a5)
    8020344c:	0791                	addi	a5,a5,4
    8020344e:	85be                	mv	a1,a5
    80203450:	fd843503          	ld	a0,-40(s0)
    80203454:	00000097          	auipc	ra,0x0
    80203458:	a74080e7          	jalr	-1420(ra) # 80202ec8 <set_sepc>
            break;
    8020345c:	aa01                	j	8020356c <handle_exception+0x2da>
			printf("Store access fault: 0x%lx\n", info->stval);
    8020345e:	fd043783          	ld	a5,-48(s0)
    80203462:	6f9c                	ld	a5,24(a5)
    80203464:	85be                	mv	a1,a5
    80203466:	00004517          	auipc	a0,0x4
    8020346a:	10a50513          	addi	a0,a0,266 # 80207570 <small_numbers+0x1180>
    8020346e:	ffffd097          	auipc	ra,0xffffd
    80203472:	6c0080e7          	jalr	1728(ra) # 80200b2e <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
    80203476:	fd043783          	ld	a5,-48(s0)
    8020347a:	6f9c                	ld	a5,24(a5)
    8020347c:	853e                	mv	a0,a5
    8020347e:	fffff097          	auipc	ra,0xfffff
    80203482:	3ec080e7          	jalr	1004(ra) # 8020286a <check_is_mapped>
    80203486:	87aa                	mv	a5,a0
    80203488:	cf81                	beqz	a5,802034a0 <handle_exception+0x20e>
    8020348a:	fd043783          	ld	a5,-48(s0)
    8020348e:	6f9c                	ld	a5,24(a5)
    80203490:	458d                	li	a1,3
    80203492:	853e                	mv	a0,a5
    80203494:	fffff097          	auipc	ra,0xfffff
    80203498:	fa8080e7          	jalr	-88(ra) # 8020243c <handle_page_fault>
    8020349c:	87aa                	mv	a5,a0
    8020349e:	e7f1                	bnez	a5,8020356a <handle_exception+0x2d8>
			set_sepc(tf, info->sepc + 4);
    802034a0:	fd043783          	ld	a5,-48(s0)
    802034a4:	639c                	ld	a5,0(a5)
    802034a6:	0791                	addi	a5,a5,4
    802034a8:	85be                	mv	a1,a5
    802034aa:	fd843503          	ld	a0,-40(s0)
    802034ae:	00000097          	auipc	ra,0x0
    802034b2:	a1a080e7          	jalr	-1510(ra) # 80202ec8 <set_sepc>
			break;
    802034b6:	a85d                	j	8020356c <handle_exception+0x2da>
            handle_syscall(tf,info);
    802034b8:	fd043583          	ld	a1,-48(s0)
    802034bc:	fd843503          	ld	a0,-40(s0)
    802034c0:	00000097          	auipc	ra,0x0
    802034c4:	0b4080e7          	jalr	180(ra) # 80203574 <handle_syscall>
            break;
    802034c8:	a055                	j	8020356c <handle_exception+0x2da>
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    802034ca:	fd043783          	ld	a5,-48(s0)
    802034ce:	639c                	ld	a5,0(a5)
    802034d0:	85be                	mv	a1,a5
    802034d2:	00004517          	auipc	a0,0x4
    802034d6:	0be50513          	addi	a0,a0,190 # 80207590 <small_numbers+0x11a0>
    802034da:	ffffd097          	auipc	ra,0xffffd
    802034de:	654080e7          	jalr	1620(ra) # 80200b2e <printf>
			set_sepc(tf, info->sepc + 4); 
    802034e2:	fd043783          	ld	a5,-48(s0)
    802034e6:	639c                	ld	a5,0(a5)
    802034e8:	0791                	addi	a5,a5,4
    802034ea:	85be                	mv	a1,a5
    802034ec:	fd843503          	ld	a0,-40(s0)
    802034f0:	00000097          	auipc	ra,0x0
    802034f4:	9d8080e7          	jalr	-1576(ra) # 80202ec8 <set_sepc>
            break;
    802034f8:	a895                	j	8020356c <handle_exception+0x2da>
            handle_instruction_page_fault(tf,info);
    802034fa:	fd043583          	ld	a1,-48(s0)
    802034fe:	fd843503          	ld	a0,-40(s0)
    80203502:	00000097          	auipc	ra,0x0
    80203506:	0c2080e7          	jalr	194(ra) # 802035c4 <handle_instruction_page_fault>
            break;
    8020350a:	a08d                	j	8020356c <handle_exception+0x2da>
            handle_load_page_fault(tf,info);
    8020350c:	fd043583          	ld	a1,-48(s0)
    80203510:	fd843503          	ld	a0,-40(s0)
    80203514:	00000097          	auipc	ra,0x0
    80203518:	112080e7          	jalr	274(ra) # 80203626 <handle_load_page_fault>
            break;
    8020351c:	a881                	j	8020356c <handle_exception+0x2da>
            handle_store_page_fault(tf,info);
    8020351e:	fd043583          	ld	a1,-48(s0)
    80203522:	fd843503          	ld	a0,-40(s0)
    80203526:	00000097          	auipc	ra,0x0
    8020352a:	162080e7          	jalr	354(ra) # 80203688 <handle_store_page_fault>
            break;
    8020352e:	a83d                	j	8020356c <handle_exception+0x2da>
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    80203530:	fd043783          	ld	a5,-48(s0)
    80203534:	6398                	ld	a4,0(a5)
    80203536:	fd043783          	ld	a5,-48(s0)
    8020353a:	6f9c                	ld	a5,24(a5)
    8020353c:	86be                	mv	a3,a5
    8020353e:	863a                	mv	a2,a4
    80203540:	fe843583          	ld	a1,-24(s0)
    80203544:	00004517          	auipc	a0,0x4
    80203548:	07450513          	addi	a0,a0,116 # 802075b8 <small_numbers+0x11c8>
    8020354c:	ffffd097          	auipc	ra,0xffffd
    80203550:	5e2080e7          	jalr	1506(ra) # 80200b2e <printf>
            panic("Unknown exception");
    80203554:	00004517          	auipc	a0,0x4
    80203558:	09c50513          	addi	a0,a0,156 # 802075f0 <small_numbers+0x1200>
    8020355c:	ffffe097          	auipc	ra,0xffffe
    80203560:	eda080e7          	jalr	-294(ra) # 80201436 <panic>
            break;
    80203564:	a021                	j	8020356c <handle_exception+0x2da>
				return; // 成功处理
    80203566:	0001                	nop
    80203568:	a011                	j	8020356c <handle_exception+0x2da>
				return; // 成功处理
    8020356a:	0001                	nop
}
    8020356c:	70a2                	ld	ra,40(sp)
    8020356e:	7402                	ld	s0,32(sp)
    80203570:	6145                	addi	sp,sp,48
    80203572:	8082                	ret

0000000080203574 <handle_syscall>:
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    80203574:	1101                	addi	sp,sp,-32
    80203576:	ec06                	sd	ra,24(sp)
    80203578:	e822                	sd	s0,16(sp)
    8020357a:	1000                	addi	s0,sp,32
    8020357c:	fea43423          	sd	a0,-24(s0)
    80203580:	feb43023          	sd	a1,-32(s0)
    printf("System call from sepc=0x%lx, syscall number=%ld\n", info->sepc, tf->a7);
    80203584:	fe043783          	ld	a5,-32(s0)
    80203588:	6398                	ld	a4,0(a5)
    8020358a:	fe843783          	ld	a5,-24(s0)
    8020358e:	77dc                	ld	a5,168(a5)
    80203590:	863e                	mv	a2,a5
    80203592:	85ba                	mv	a1,a4
    80203594:	00004517          	auipc	a0,0x4
    80203598:	0b450513          	addi	a0,a0,180 # 80207648 <small_numbers+0x1258>
    8020359c:	ffffd097          	auipc	ra,0xffffd
    802035a0:	592080e7          	jalr	1426(ra) # 80200b2e <printf>
    set_sepc(tf, info->sepc + 4);
    802035a4:	fe043783          	ld	a5,-32(s0)
    802035a8:	639c                	ld	a5,0(a5)
    802035aa:	0791                	addi	a5,a5,4
    802035ac:	85be                	mv	a1,a5
    802035ae:	fe843503          	ld	a0,-24(s0)
    802035b2:	00000097          	auipc	ra,0x0
    802035b6:	916080e7          	jalr	-1770(ra) # 80202ec8 <set_sepc>
}
    802035ba:	0001                	nop
    802035bc:	60e2                	ld	ra,24(sp)
    802035be:	6442                	ld	s0,16(sp)
    802035c0:	6105                	addi	sp,sp,32
    802035c2:	8082                	ret

00000000802035c4 <handle_instruction_page_fault>:
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    802035c4:	1101                	addi	sp,sp,-32
    802035c6:	ec06                	sd	ra,24(sp)
    802035c8:	e822                	sd	s0,16(sp)
    802035ca:	1000                	addi	s0,sp,32
    802035cc:	fea43423          	sd	a0,-24(s0)
    802035d0:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802035d4:	fe043783          	ld	a5,-32(s0)
    802035d8:	6f98                	ld	a4,24(a5)
    802035da:	fe043783          	ld	a5,-32(s0)
    802035de:	639c                	ld	a5,0(a5)
    802035e0:	863e                	mv	a2,a5
    802035e2:	85ba                	mv	a1,a4
    802035e4:	00004517          	auipc	a0,0x4
    802035e8:	09c50513          	addi	a0,a0,156 # 80207680 <small_numbers+0x1290>
    802035ec:	ffffd097          	auipc	ra,0xffffd
    802035f0:	542080e7          	jalr	1346(ra) # 80200b2e <printf>
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    802035f4:	fe043783          	ld	a5,-32(s0)
    802035f8:	6f9c                	ld	a5,24(a5)
    802035fa:	4585                	li	a1,1
    802035fc:	853e                	mv	a0,a5
    802035fe:	fffff097          	auipc	ra,0xfffff
    80203602:	e3e080e7          	jalr	-450(ra) # 8020243c <handle_page_fault>
    80203606:	87aa                	mv	a5,a0
    80203608:	eb91                	bnez	a5,8020361c <handle_instruction_page_fault+0x58>
    panic("Unhandled instruction page fault");
    8020360a:	00004517          	auipc	a0,0x4
    8020360e:	0a650513          	addi	a0,a0,166 # 802076b0 <small_numbers+0x12c0>
    80203612:	ffffe097          	auipc	ra,0xffffe
    80203616:	e24080e7          	jalr	-476(ra) # 80201436 <panic>
    8020361a:	a011                	j	8020361e <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    8020361c:	0001                	nop
}
    8020361e:	60e2                	ld	ra,24(sp)
    80203620:	6442                	ld	s0,16(sp)
    80203622:	6105                	addi	sp,sp,32
    80203624:	8082                	ret

0000000080203626 <handle_load_page_fault>:
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    80203626:	1101                	addi	sp,sp,-32
    80203628:	ec06                	sd	ra,24(sp)
    8020362a:	e822                	sd	s0,16(sp)
    8020362c:	1000                	addi	s0,sp,32
    8020362e:	fea43423          	sd	a0,-24(s0)
    80203632:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80203636:	fe043783          	ld	a5,-32(s0)
    8020363a:	6f98                	ld	a4,24(a5)
    8020363c:	fe043783          	ld	a5,-32(s0)
    80203640:	639c                	ld	a5,0(a5)
    80203642:	863e                	mv	a2,a5
    80203644:	85ba                	mv	a1,a4
    80203646:	00004517          	auipc	a0,0x4
    8020364a:	09250513          	addi	a0,a0,146 # 802076d8 <small_numbers+0x12e8>
    8020364e:	ffffd097          	auipc	ra,0xffffd
    80203652:	4e0080e7          	jalr	1248(ra) # 80200b2e <printf>
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    80203656:	fe043783          	ld	a5,-32(s0)
    8020365a:	6f9c                	ld	a5,24(a5)
    8020365c:	4589                	li	a1,2
    8020365e:	853e                	mv	a0,a5
    80203660:	fffff097          	auipc	ra,0xfffff
    80203664:	ddc080e7          	jalr	-548(ra) # 8020243c <handle_page_fault>
    80203668:	87aa                	mv	a5,a0
    8020366a:	eb91                	bnez	a5,8020367e <handle_load_page_fault+0x58>
    panic("Unhandled load page fault");
    8020366c:	00004517          	auipc	a0,0x4
    80203670:	09c50513          	addi	a0,a0,156 # 80207708 <small_numbers+0x1318>
    80203674:	ffffe097          	auipc	ra,0xffffe
    80203678:	dc2080e7          	jalr	-574(ra) # 80201436 <panic>
    8020367c:	a011                	j	80203680 <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    8020367e:	0001                	nop
}
    80203680:	60e2                	ld	ra,24(sp)
    80203682:	6442                	ld	s0,16(sp)
    80203684:	6105                	addi	sp,sp,32
    80203686:	8082                	ret

0000000080203688 <handle_store_page_fault>:
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    80203688:	1101                	addi	sp,sp,-32
    8020368a:	ec06                	sd	ra,24(sp)
    8020368c:	e822                	sd	s0,16(sp)
    8020368e:	1000                	addi	s0,sp,32
    80203690:	fea43423          	sd	a0,-24(s0)
    80203694:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80203698:	fe043783          	ld	a5,-32(s0)
    8020369c:	6f98                	ld	a4,24(a5)
    8020369e:	fe043783          	ld	a5,-32(s0)
    802036a2:	639c                	ld	a5,0(a5)
    802036a4:	863e                	mv	a2,a5
    802036a6:	85ba                	mv	a1,a4
    802036a8:	00004517          	auipc	a0,0x4
    802036ac:	08050513          	addi	a0,a0,128 # 80207728 <small_numbers+0x1338>
    802036b0:	ffffd097          	auipc	ra,0xffffd
    802036b4:	47e080e7          	jalr	1150(ra) # 80200b2e <printf>
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    802036b8:	fe043783          	ld	a5,-32(s0)
    802036bc:	6f9c                	ld	a5,24(a5)
    802036be:	458d                	li	a1,3
    802036c0:	853e                	mv	a0,a5
    802036c2:	fffff097          	auipc	ra,0xfffff
    802036c6:	d7a080e7          	jalr	-646(ra) # 8020243c <handle_page_fault>
    802036ca:	87aa                	mv	a5,a0
    802036cc:	eb91                	bnez	a5,802036e0 <handle_store_page_fault+0x58>
    panic("Unhandled store page fault");
    802036ce:	00004517          	auipc	a0,0x4
    802036d2:	08a50513          	addi	a0,a0,138 # 80207758 <small_numbers+0x1368>
    802036d6:	ffffe097          	auipc	ra,0xffffe
    802036da:	d60080e7          	jalr	-672(ra) # 80201436 <panic>
    802036de:	a011                	j	802036e2 <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802036e0:	0001                	nop
}
    802036e2:	60e2                	ld	ra,24(sp)
    802036e4:	6442                	ld	s0,16(sp)
    802036e6:	6105                	addi	sp,sp,32
    802036e8:	8082                	ret

00000000802036ea <get_time>:
uint64 get_time(void) {
    802036ea:	1141                	addi	sp,sp,-16
    802036ec:	e406                	sd	ra,8(sp)
    802036ee:	e022                	sd	s0,0(sp)
    802036f0:	0800                	addi	s0,sp,16
    return sbi_get_time();
    802036f2:	fffff097          	auipc	ra,0xfffff
    802036f6:	638080e7          	jalr	1592(ra) # 80202d2a <sbi_get_time>
    802036fa:	87aa                	mv	a5,a0
}
    802036fc:	853e                	mv	a0,a5
    802036fe:	60a2                	ld	ra,8(sp)
    80203700:	6402                	ld	s0,0(sp)
    80203702:	0141                	addi	sp,sp,16
    80203704:	8082                	ret

0000000080203706 <test_timer_interrupt>:
void test_timer_interrupt(void) {
    80203706:	7179                	addi	sp,sp,-48
    80203708:	f406                	sd	ra,40(sp)
    8020370a:	f022                	sd	s0,32(sp)
    8020370c:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    8020370e:	00004517          	auipc	a0,0x4
    80203712:	06a50513          	addi	a0,a0,106 # 80207778 <small_numbers+0x1388>
    80203716:	ffffd097          	auipc	ra,0xffffd
    8020371a:	418080e7          	jalr	1048(ra) # 80200b2e <printf>
    uint64 start_time = get_time();
    8020371e:	00000097          	auipc	ra,0x0
    80203722:	fcc080e7          	jalr	-52(ra) # 802036ea <get_time>
    80203726:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    8020372a:	fc042a23          	sw	zero,-44(s0)
	int last_count = interrupt_count;
    8020372e:	fd442783          	lw	a5,-44(s0)
    80203732:	fef42623          	sw	a5,-20(s0)
    interrupt_test_flag = &interrupt_count;
    80203736:	00007797          	auipc	a5,0x7
    8020373a:	95278793          	addi	a5,a5,-1710 # 8020a088 <interrupt_test_flag>
    8020373e:	fd440713          	addi	a4,s0,-44
    80203742:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    80203744:	a899                	j	8020379a <test_timer_interrupt+0x94>
        if(last_count != interrupt_count) {
    80203746:	fd442703          	lw	a4,-44(s0)
    8020374a:	fec42783          	lw	a5,-20(s0)
    8020374e:	2781                	sext.w	a5,a5
    80203750:	02e78163          	beq	a5,a4,80203772 <test_timer_interrupt+0x6c>
			last_count = interrupt_count;
    80203754:	fd442783          	lw	a5,-44(s0)
    80203758:	fef42623          	sw	a5,-20(s0)
			printf("Received interrupt %d\n", interrupt_count);
    8020375c:	fd442783          	lw	a5,-44(s0)
    80203760:	85be                	mv	a1,a5
    80203762:	00004517          	auipc	a0,0x4
    80203766:	03650513          	addi	a0,a0,54 # 80207798 <small_numbers+0x13a8>
    8020376a:	ffffd097          	auipc	ra,0xffffd
    8020376e:	3c4080e7          	jalr	964(ra) # 80200b2e <printf>
        for (volatile int i = 0; i < 1000000; i++);
    80203772:	fc042823          	sw	zero,-48(s0)
    80203776:	a801                	j	80203786 <test_timer_interrupt+0x80>
    80203778:	fd042783          	lw	a5,-48(s0)
    8020377c:	2781                	sext.w	a5,a5
    8020377e:	2785                	addiw	a5,a5,1
    80203780:	2781                	sext.w	a5,a5
    80203782:	fcf42823          	sw	a5,-48(s0)
    80203786:	fd042783          	lw	a5,-48(s0)
    8020378a:	2781                	sext.w	a5,a5
    8020378c:	873e                	mv	a4,a5
    8020378e:	000f47b7          	lui	a5,0xf4
    80203792:	23f78793          	addi	a5,a5,575 # f423f <userret+0xf41a3>
    80203796:	fee7d1e3          	bge	a5,a4,80203778 <test_timer_interrupt+0x72>
    while (interrupt_count < 5) {
    8020379a:	fd442783          	lw	a5,-44(s0)
    8020379e:	873e                	mv	a4,a5
    802037a0:	4791                	li	a5,4
    802037a2:	fae7d2e3          	bge	a5,a4,80203746 <test_timer_interrupt+0x40>
    interrupt_test_flag = 0;
    802037a6:	00007797          	auipc	a5,0x7
    802037aa:	8e278793          	addi	a5,a5,-1822 # 8020a088 <interrupt_test_flag>
    802037ae:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    802037b2:	00000097          	auipc	ra,0x0
    802037b6:	f38080e7          	jalr	-200(ra) # 802036ea <get_time>
    802037ba:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    802037be:	fd442683          	lw	a3,-44(s0)
    802037c2:	fd843703          	ld	a4,-40(s0)
    802037c6:	fe043783          	ld	a5,-32(s0)
    802037ca:	40f707b3          	sub	a5,a4,a5
    802037ce:	863e                	mv	a2,a5
    802037d0:	85b6                	mv	a1,a3
    802037d2:	00004517          	auipc	a0,0x4
    802037d6:	fde50513          	addi	a0,a0,-34 # 802077b0 <small_numbers+0x13c0>
    802037da:	ffffd097          	auipc	ra,0xffffd
    802037de:	354080e7          	jalr	852(ra) # 80200b2e <printf>
}
    802037e2:	0001                	nop
    802037e4:	70a2                	ld	ra,40(sp)
    802037e6:	7402                	ld	s0,32(sp)
    802037e8:	6145                	addi	sp,sp,48
    802037ea:	8082                	ret

00000000802037ec <test_exception>:
void test_exception(void) {
    802037ec:	715d                	addi	sp,sp,-80
    802037ee:	e486                	sd	ra,72(sp)
    802037f0:	e0a2                	sd	s0,64(sp)
    802037f2:	0880                	addi	s0,sp,80
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    802037f4:	00004517          	auipc	a0,0x4
    802037f8:	ff450513          	addi	a0,a0,-12 # 802077e8 <small_numbers+0x13f8>
    802037fc:	ffffd097          	auipc	ra,0xffffd
    80203800:	332080e7          	jalr	818(ra) # 80200b2e <printf>
    printf("1. 测试非法指令异常...\n");
    80203804:	00004517          	auipc	a0,0x4
    80203808:	01450513          	addi	a0,a0,20 # 80207818 <small_numbers+0x1428>
    8020380c:	ffffd097          	auipc	ra,0xffffd
    80203810:	322080e7          	jalr	802(ra) # 80200b2e <printf>
    80203814:	ffffffff          	.word	0xffffffff
    printf("✓ 非法指令异常处理成功\n\n");
    80203818:	00004517          	auipc	a0,0x4
    8020381c:	02050513          	addi	a0,a0,32 # 80207838 <small_numbers+0x1448>
    80203820:	ffffd097          	auipc	ra,0xffffd
    80203824:	30e080e7          	jalr	782(ra) # 80200b2e <printf>
    printf("2. 测试存储页故障异常...\n");
    80203828:	00004517          	auipc	a0,0x4
    8020382c:	03850513          	addi	a0,a0,56 # 80207860 <small_numbers+0x1470>
    80203830:	ffffd097          	auipc	ra,0xffffd
    80203834:	2fe080e7          	jalr	766(ra) # 80200b2e <printf>
    volatile uint64 *invalid_ptr = 0;
    80203838:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    8020383c:	47a5                	li	a5,9
    8020383e:	07f2                	slli	a5,a5,0x1c
    80203840:	fef43023          	sd	a5,-32(s0)
    80203844:	a835                	j	80203880 <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    80203846:	fe043503          	ld	a0,-32(s0)
    8020384a:	fffff097          	auipc	ra,0xfffff
    8020384e:	020080e7          	jalr	32(ra) # 8020286a <check_is_mapped>
    80203852:	87aa                	mv	a5,a0
    80203854:	e385                	bnez	a5,80203874 <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    80203856:	fe043783          	ld	a5,-32(s0)
    8020385a:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    8020385e:	fe043583          	ld	a1,-32(s0)
    80203862:	00004517          	auipc	a0,0x4
    80203866:	02650513          	addi	a0,a0,38 # 80207888 <small_numbers+0x1498>
    8020386a:	ffffd097          	auipc	ra,0xffffd
    8020386e:	2c4080e7          	jalr	708(ra) # 80200b2e <printf>
            break;
    80203872:	a829                	j	8020388c <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80203874:	fe043703          	ld	a4,-32(s0)
    80203878:	6785                	lui	a5,0x1
    8020387a:	97ba                	add	a5,a5,a4
    8020387c:	fef43023          	sd	a5,-32(s0)
    80203880:	fe043703          	ld	a4,-32(s0)
    80203884:	47cd                	li	a5,19
    80203886:	07ee                	slli	a5,a5,0x1b
    80203888:	faf76fe3          	bltu	a4,a5,80203846 <test_exception+0x5a>
    if (invalid_ptr != 0) {
    8020388c:	fe843783          	ld	a5,-24(s0)
    80203890:	cb95                	beqz	a5,802038c4 <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80203892:	fe843783          	ld	a5,-24(s0)
    80203896:	85be                	mv	a1,a5
    80203898:	00004517          	auipc	a0,0x4
    8020389c:	01050513          	addi	a0,a0,16 # 802078a8 <small_numbers+0x14b8>
    802038a0:	ffffd097          	auipc	ra,0xffffd
    802038a4:	28e080e7          	jalr	654(ra) # 80200b2e <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    802038a8:	fe843783          	ld	a5,-24(s0)
    802038ac:	02a00713          	li	a4,42
    802038b0:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    802038b2:	00004517          	auipc	a0,0x4
    802038b6:	02650513          	addi	a0,a0,38 # 802078d8 <small_numbers+0x14e8>
    802038ba:	ffffd097          	auipc	ra,0xffffd
    802038be:	274080e7          	jalr	628(ra) # 80200b2e <printf>
    802038c2:	a809                	j	802038d4 <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    802038c4:	00004517          	auipc	a0,0x4
    802038c8:	03c50513          	addi	a0,a0,60 # 80207900 <small_numbers+0x1510>
    802038cc:	ffffd097          	auipc	ra,0xffffd
    802038d0:	262080e7          	jalr	610(ra) # 80200b2e <printf>
    printf("3. 测试加载页故障异常...\n");
    802038d4:	00004517          	auipc	a0,0x4
    802038d8:	06450513          	addi	a0,a0,100 # 80207938 <small_numbers+0x1548>
    802038dc:	ffffd097          	auipc	ra,0xffffd
    802038e0:	252080e7          	jalr	594(ra) # 80200b2e <printf>
    invalid_ptr = 0;
    802038e4:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802038e8:	4795                	li	a5,5
    802038ea:	07f6                	slli	a5,a5,0x1d
    802038ec:	fcf43c23          	sd	a5,-40(s0)
    802038f0:	a835                	j	8020392c <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    802038f2:	fd843503          	ld	a0,-40(s0)
    802038f6:	fffff097          	auipc	ra,0xfffff
    802038fa:	f74080e7          	jalr	-140(ra) # 8020286a <check_is_mapped>
    802038fe:	87aa                	mv	a5,a0
    80203900:	e385                	bnez	a5,80203920 <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    80203902:	fd843783          	ld	a5,-40(s0)
    80203906:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    8020390a:	fd843583          	ld	a1,-40(s0)
    8020390e:	00004517          	auipc	a0,0x4
    80203912:	f7a50513          	addi	a0,a0,-134 # 80207888 <small_numbers+0x1498>
    80203916:	ffffd097          	auipc	ra,0xffffd
    8020391a:	218080e7          	jalr	536(ra) # 80200b2e <printf>
            break;
    8020391e:	a829                	j	80203938 <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80203920:	fd843703          	ld	a4,-40(s0)
    80203924:	6785                	lui	a5,0x1
    80203926:	97ba                	add	a5,a5,a4
    80203928:	fcf43c23          	sd	a5,-40(s0)
    8020392c:	fd843703          	ld	a4,-40(s0)
    80203930:	47d5                	li	a5,21
    80203932:	07ee                	slli	a5,a5,0x1b
    80203934:	faf76fe3          	bltu	a4,a5,802038f2 <test_exception+0x106>
    if (invalid_ptr != 0) {
    80203938:	fe843783          	ld	a5,-24(s0)
    8020393c:	c7a9                	beqz	a5,80203986 <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    8020393e:	fe843783          	ld	a5,-24(s0)
    80203942:	85be                	mv	a1,a5
    80203944:	00004517          	auipc	a0,0x4
    80203948:	01c50513          	addi	a0,a0,28 # 80207960 <small_numbers+0x1570>
    8020394c:	ffffd097          	auipc	ra,0xffffd
    80203950:	1e2080e7          	jalr	482(ra) # 80200b2e <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    80203954:	fe843783          	ld	a5,-24(s0)
    80203958:	639c                	ld	a5,0(a5)
    8020395a:	faf43823          	sd	a5,-80(s0)
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    8020395e:	fb043783          	ld	a5,-80(s0)
    80203962:	85be                	mv	a1,a5
    80203964:	00004517          	auipc	a0,0x4
    80203968:	02c50513          	addi	a0,a0,44 # 80207990 <small_numbers+0x15a0>
    8020396c:	ffffd097          	auipc	ra,0xffffd
    80203970:	1c2080e7          	jalr	450(ra) # 80200b2e <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    80203974:	00004517          	auipc	a0,0x4
    80203978:	03450513          	addi	a0,a0,52 # 802079a8 <small_numbers+0x15b8>
    8020397c:	ffffd097          	auipc	ra,0xffffd
    80203980:	1b2080e7          	jalr	434(ra) # 80200b2e <printf>
    80203984:	a809                	j	80203996 <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80203986:	00004517          	auipc	a0,0x4
    8020398a:	f7a50513          	addi	a0,a0,-134 # 80207900 <small_numbers+0x1510>
    8020398e:	ffffd097          	auipc	ra,0xffffd
    80203992:	1a0080e7          	jalr	416(ra) # 80200b2e <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    80203996:	00004517          	auipc	a0,0x4
    8020399a:	03a50513          	addi	a0,a0,58 # 802079d0 <small_numbers+0x15e0>
    8020399e:	ffffd097          	auipc	ra,0xffffd
    802039a2:	190080e7          	jalr	400(ra) # 80200b2e <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    802039a6:	fffff097          	auipc	ra,0xfffff
    802039aa:	0e4080e7          	jalr	228(ra) # 80202a8a <alloc_page>
    802039ae:	87aa                	mv	a5,a0
    802039b0:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    802039b4:	fd043783          	ld	a5,-48(s0)
    802039b8:	c3a1                	beqz	a5,802039f8 <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    802039ba:	fd043783          	ld	a5,-48(s0)
    802039be:	0785                	addi	a5,a5,1 # 1001 <userret+0xf65>
    802039c0:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    802039c4:	fc843583          	ld	a1,-56(s0)
    802039c8:	00004517          	auipc	a0,0x4
    802039cc:	03850513          	addi	a0,a0,56 # 80207a00 <small_numbers+0x1610>
    802039d0:	ffffd097          	auipc	ra,0xffffd
    802039d4:	15e080e7          	jalr	350(ra) # 80200b2e <printf>
        asm volatile (
    802039d8:	deadc7b7          	lui	a5,0xdeadc
    802039dc:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8cfa9f>
    802039e0:	fc843703          	ld	a4,-56(s0)
    802039e4:	e31c                	sd	a5,0(a4)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    802039e6:	00004517          	auipc	a0,0x4
    802039ea:	03a50513          	addi	a0,a0,58 # 80207a20 <small_numbers+0x1630>
    802039ee:	ffffd097          	auipc	ra,0xffffd
    802039f2:	140080e7          	jalr	320(ra) # 80200b2e <printf>
    802039f6:	a809                	j	80203a08 <test_exception+0x21c>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    802039f8:	00004517          	auipc	a0,0x4
    802039fc:	05850513          	addi	a0,a0,88 # 80207a50 <small_numbers+0x1660>
    80203a00:	ffffd097          	auipc	ra,0xffffd
    80203a04:	12e080e7          	jalr	302(ra) # 80200b2e <printf>
    printf("5. 测试加载地址未对齐异常...\n");
    80203a08:	00004517          	auipc	a0,0x4
    80203a0c:	08850513          	addi	a0,a0,136 # 80207a90 <small_numbers+0x16a0>
    80203a10:	ffffd097          	auipc	ra,0xffffd
    80203a14:	11e080e7          	jalr	286(ra) # 80200b2e <printf>
    if (aligned_addr != 0) {
    80203a18:	fd043783          	ld	a5,-48(s0)
    80203a1c:	cbb1                	beqz	a5,80203a70 <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    80203a1e:	fd043783          	ld	a5,-48(s0)
    80203a22:	0785                	addi	a5,a5,1
    80203a24:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80203a28:	fc043583          	ld	a1,-64(s0)
    80203a2c:	00004517          	auipc	a0,0x4
    80203a30:	fd450513          	addi	a0,a0,-44 # 80207a00 <small_numbers+0x1610>
    80203a34:	ffffd097          	auipc	ra,0xffffd
    80203a38:	0fa080e7          	jalr	250(ra) # 80200b2e <printf>
        uint64 value = 0;
    80203a3c:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    80203a40:	fc043783          	ld	a5,-64(s0)
    80203a44:	639c                	ld	a5,0(a5)
    80203a46:	faf43c23          	sd	a5,-72(s0)
        printf("读取的值: 0x%lx\n", value);
    80203a4a:	fb843583          	ld	a1,-72(s0)
    80203a4e:	00004517          	auipc	a0,0x4
    80203a52:	07250513          	addi	a0,a0,114 # 80207ac0 <small_numbers+0x16d0>
    80203a56:	ffffd097          	auipc	ra,0xffffd
    80203a5a:	0d8080e7          	jalr	216(ra) # 80200b2e <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80203a5e:	00004517          	auipc	a0,0x4
    80203a62:	07a50513          	addi	a0,a0,122 # 80207ad8 <small_numbers+0x16e8>
    80203a66:	ffffd097          	auipc	ra,0xffffd
    80203a6a:	0c8080e7          	jalr	200(ra) # 80200b2e <printf>
    80203a6e:	a809                	j	80203a80 <test_exception+0x294>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80203a70:	00004517          	auipc	a0,0x4
    80203a74:	fe050513          	addi	a0,a0,-32 # 80207a50 <small_numbers+0x1660>
    80203a78:	ffffd097          	auipc	ra,0xffffd
    80203a7c:	0b6080e7          	jalr	182(ra) # 80200b2e <printf>
	printf("6. 测试断点异常...\n");
    80203a80:	00004517          	auipc	a0,0x4
    80203a84:	08850513          	addi	a0,a0,136 # 80207b08 <small_numbers+0x1718>
    80203a88:	ffffd097          	auipc	ra,0xffffd
    80203a8c:	0a6080e7          	jalr	166(ra) # 80200b2e <printf>
	asm volatile (
    80203a90:	0001                	nop
    80203a92:	9002                	ebreak
    80203a94:	0001                	nop
		"nop\n\t"      // 确保ebreak前有有效指令
		"ebreak\n\t"   // 断点指令
		"nop\n\t"      // 确保ebreak后有有效指令
	);
	printf("✓ 断点异常处理成功\n\n");
    80203a96:	00004517          	auipc	a0,0x4
    80203a9a:	09250513          	addi	a0,a0,146 # 80207b28 <small_numbers+0x1738>
    80203a9e:	ffffd097          	auipc	ra,0xffffd
    80203aa2:	090080e7          	jalr	144(ra) # 80200b2e <printf>
    // 7. 测试环境调用异常
    printf("7. 测试环境调用异常...\n");
    80203aa6:	00004517          	auipc	a0,0x4
    80203aaa:	0a250513          	addi	a0,a0,162 # 80207b48 <small_numbers+0x1758>
    80203aae:	ffffd097          	auipc	ra,0xffffd
    80203ab2:	080080e7          	jalr	128(ra) # 80200b2e <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    80203ab6:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    80203aba:	00004517          	auipc	a0,0x4
    80203abe:	0ae50513          	addi	a0,a0,174 # 80207b68 <small_numbers+0x1778>
    80203ac2:	ffffd097          	auipc	ra,0xffffd
    80203ac6:	06c080e7          	jalr	108(ra) # 80200b2e <printf>
    
    printf("===== 异常处理测试完成 =====\n\n");
    80203aca:	00004517          	auipc	a0,0x4
    80203ace:	0c650513          	addi	a0,a0,198 # 80207b90 <small_numbers+0x17a0>
    80203ad2:	ffffd097          	auipc	ra,0xffffd
    80203ad6:	05c080e7          	jalr	92(ra) # 80200b2e <printf>
}
    80203ada:	0001                	nop
    80203adc:	60a6                	ld	ra,72(sp)
    80203ade:	6406                	ld	s0,64(sp)
    80203ae0:	6161                	addi	sp,sp,80
    80203ae2:	8082                	ret

0000000080203ae4 <write32>:
    80203ae4:	7179                	addi	sp,sp,-48
    80203ae6:	f406                	sd	ra,40(sp)
    80203ae8:	f022                	sd	s0,32(sp)
    80203aea:	1800                	addi	s0,sp,48
    80203aec:	fca43c23          	sd	a0,-40(s0)
    80203af0:	87ae                	mv	a5,a1
    80203af2:	fcf42a23          	sw	a5,-44(s0)
    80203af6:	fd843783          	ld	a5,-40(s0)
    80203afa:	8b8d                	andi	a5,a5,3
    80203afc:	eb99                	bnez	a5,80203b12 <write32+0x2e>
    80203afe:	fd843783          	ld	a5,-40(s0)
    80203b02:	fef43423          	sd	a5,-24(s0)
    80203b06:	fe843783          	ld	a5,-24(s0)
    80203b0a:	fd442703          	lw	a4,-44(s0)
    80203b0e:	c398                	sw	a4,0(a5)
    80203b10:	a819                	j	80203b26 <write32+0x42>
    80203b12:	fd843583          	ld	a1,-40(s0)
    80203b16:	00004517          	auipc	a0,0x4
    80203b1a:	0a250513          	addi	a0,a0,162 # 80207bb8 <small_numbers+0x17c8>
    80203b1e:	ffffd097          	auipc	ra,0xffffd
    80203b22:	010080e7          	jalr	16(ra) # 80200b2e <printf>
    80203b26:	0001                	nop
    80203b28:	70a2                	ld	ra,40(sp)
    80203b2a:	7402                	ld	s0,32(sp)
    80203b2c:	6145                	addi	sp,sp,48
    80203b2e:	8082                	ret

0000000080203b30 <read32>:
    80203b30:	7179                	addi	sp,sp,-48
    80203b32:	f406                	sd	ra,40(sp)
    80203b34:	f022                	sd	s0,32(sp)
    80203b36:	1800                	addi	s0,sp,48
    80203b38:	fca43c23          	sd	a0,-40(s0)
    80203b3c:	fd843783          	ld	a5,-40(s0)
    80203b40:	8b8d                	andi	a5,a5,3
    80203b42:	eb91                	bnez	a5,80203b56 <read32+0x26>
    80203b44:	fd843783          	ld	a5,-40(s0)
    80203b48:	fef43423          	sd	a5,-24(s0)
    80203b4c:	fe843783          	ld	a5,-24(s0)
    80203b50:	439c                	lw	a5,0(a5)
    80203b52:	2781                	sext.w	a5,a5
    80203b54:	a821                	j	80203b6c <read32+0x3c>
    80203b56:	fd843583          	ld	a1,-40(s0)
    80203b5a:	00004517          	auipc	a0,0x4
    80203b5e:	08e50513          	addi	a0,a0,142 # 80207be8 <small_numbers+0x17f8>
    80203b62:	ffffd097          	auipc	ra,0xffffd
    80203b66:	fcc080e7          	jalr	-52(ra) # 80200b2e <printf>
    80203b6a:	4781                	li	a5,0
    80203b6c:	853e                	mv	a0,a5
    80203b6e:	70a2                	ld	ra,40(sp)
    80203b70:	7402                	ld	s0,32(sp)
    80203b72:	6145                	addi	sp,sp,48
    80203b74:	8082                	ret

0000000080203b76 <plic_init>:
void plic_init(void) {
    80203b76:	1101                	addi	sp,sp,-32
    80203b78:	ec06                	sd	ra,24(sp)
    80203b7a:	e822                	sd	s0,16(sp)
    80203b7c:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80203b7e:	4785                	li	a5,1
    80203b80:	fef42623          	sw	a5,-20(s0)
    80203b84:	a805                	j	80203bb4 <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    80203b86:	fec42783          	lw	a5,-20(s0)
    80203b8a:	0027979b          	slliw	a5,a5,0x2
    80203b8e:	2781                	sext.w	a5,a5
    80203b90:	873e                	mv	a4,a5
    80203b92:	0c0007b7          	lui	a5,0xc000
    80203b96:	97ba                	add	a5,a5,a4
    80203b98:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80203b9c:	4581                	li	a1,0
    80203b9e:	fe043503          	ld	a0,-32(s0)
    80203ba2:	00000097          	auipc	ra,0x0
    80203ba6:	f42080e7          	jalr	-190(ra) # 80203ae4 <write32>
    for (int i = 1; i <= 32; i++) {
    80203baa:	fec42783          	lw	a5,-20(s0)
    80203bae:	2785                	addiw	a5,a5,1 # c000001 <userret+0xbffff65>
    80203bb0:	fef42623          	sw	a5,-20(s0)
    80203bb4:	fec42783          	lw	a5,-20(s0)
    80203bb8:	0007871b          	sext.w	a4,a5
    80203bbc:	02000793          	li	a5,32
    80203bc0:	fce7d3e3          	bge	a5,a4,80203b86 <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    80203bc4:	4585                	li	a1,1
    80203bc6:	0c0007b7          	lui	a5,0xc000
    80203bca:	02878513          	addi	a0,a5,40 # c000028 <userret+0xbffff8c>
    80203bce:	00000097          	auipc	ra,0x0
    80203bd2:	f16080e7          	jalr	-234(ra) # 80203ae4 <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    80203bd6:	4585                	li	a1,1
    80203bd8:	0c0007b7          	lui	a5,0xc000
    80203bdc:	00478513          	addi	a0,a5,4 # c000004 <userret+0xbffff68>
    80203be0:	00000097          	auipc	ra,0x0
    80203be4:	f04080e7          	jalr	-252(ra) # 80203ae4 <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    80203be8:	40200593          	li	a1,1026
    80203bec:	0c0027b7          	lui	a5,0xc002
    80203bf0:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203bf4:	00000097          	auipc	ra,0x0
    80203bf8:	ef0080e7          	jalr	-272(ra) # 80203ae4 <write32>
    write32(PLIC_THRESHOLD, 0);
    80203bfc:	4581                	li	a1,0
    80203bfe:	0c201537          	lui	a0,0xc201
    80203c02:	00000097          	auipc	ra,0x0
    80203c06:	ee2080e7          	jalr	-286(ra) # 80203ae4 <write32>
}
    80203c0a:	0001                	nop
    80203c0c:	60e2                	ld	ra,24(sp)
    80203c0e:	6442                	ld	s0,16(sp)
    80203c10:	6105                	addi	sp,sp,32
    80203c12:	8082                	ret

0000000080203c14 <plic_enable>:
void plic_enable(int irq) {
    80203c14:	7179                	addi	sp,sp,-48
    80203c16:	f406                	sd	ra,40(sp)
    80203c18:	f022                	sd	s0,32(sp)
    80203c1a:	1800                	addi	s0,sp,48
    80203c1c:	87aa                	mv	a5,a0
    80203c1e:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80203c22:	0c0027b7          	lui	a5,0xc002
    80203c26:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203c2a:	00000097          	auipc	ra,0x0
    80203c2e:	f06080e7          	jalr	-250(ra) # 80203b30 <read32>
    80203c32:	87aa                	mv	a5,a0
    80203c34:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    80203c38:	fdc42783          	lw	a5,-36(s0)
    80203c3c:	873e                	mv	a4,a5
    80203c3e:	4785                	li	a5,1
    80203c40:	00e797bb          	sllw	a5,a5,a4
    80203c44:	2781                	sext.w	a5,a5
    80203c46:	2781                	sext.w	a5,a5
    80203c48:	fec42703          	lw	a4,-20(s0)
    80203c4c:	8fd9                	or	a5,a5,a4
    80203c4e:	2781                	sext.w	a5,a5
    80203c50:	85be                	mv	a1,a5
    80203c52:	0c0027b7          	lui	a5,0xc002
    80203c56:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203c5a:	00000097          	auipc	ra,0x0
    80203c5e:	e8a080e7          	jalr	-374(ra) # 80203ae4 <write32>
}
    80203c62:	0001                	nop
    80203c64:	70a2                	ld	ra,40(sp)
    80203c66:	7402                	ld	s0,32(sp)
    80203c68:	6145                	addi	sp,sp,48
    80203c6a:	8082                	ret

0000000080203c6c <plic_disable>:
void plic_disable(int irq) {
    80203c6c:	7179                	addi	sp,sp,-48
    80203c6e:	f406                	sd	ra,40(sp)
    80203c70:	f022                	sd	s0,32(sp)
    80203c72:	1800                	addi	s0,sp,48
    80203c74:	87aa                	mv	a5,a0
    80203c76:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80203c7a:	0c0027b7          	lui	a5,0xc002
    80203c7e:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203c82:	00000097          	auipc	ra,0x0
    80203c86:	eae080e7          	jalr	-338(ra) # 80203b30 <read32>
    80203c8a:	87aa                	mv	a5,a0
    80203c8c:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    80203c90:	fdc42783          	lw	a5,-36(s0)
    80203c94:	873e                	mv	a4,a5
    80203c96:	4785                	li	a5,1
    80203c98:	00e797bb          	sllw	a5,a5,a4
    80203c9c:	2781                	sext.w	a5,a5
    80203c9e:	fff7c793          	not	a5,a5
    80203ca2:	2781                	sext.w	a5,a5
    80203ca4:	2781                	sext.w	a5,a5
    80203ca6:	fec42703          	lw	a4,-20(s0)
    80203caa:	8ff9                	and	a5,a5,a4
    80203cac:	2781                	sext.w	a5,a5
    80203cae:	85be                	mv	a1,a5
    80203cb0:	0c0027b7          	lui	a5,0xc002
    80203cb4:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203cb8:	00000097          	auipc	ra,0x0
    80203cbc:	e2c080e7          	jalr	-468(ra) # 80203ae4 <write32>
}
    80203cc0:	0001                	nop
    80203cc2:	70a2                	ld	ra,40(sp)
    80203cc4:	7402                	ld	s0,32(sp)
    80203cc6:	6145                	addi	sp,sp,48
    80203cc8:	8082                	ret

0000000080203cca <plic_claim>:
int plic_claim(void) {
    80203cca:	1141                	addi	sp,sp,-16
    80203ccc:	e406                	sd	ra,8(sp)
    80203cce:	e022                	sd	s0,0(sp)
    80203cd0:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    80203cd2:	0c2017b7          	lui	a5,0xc201
    80203cd6:	00478513          	addi	a0,a5,4 # c201004 <userret+0xc200f68>
    80203cda:	00000097          	auipc	ra,0x0
    80203cde:	e56080e7          	jalr	-426(ra) # 80203b30 <read32>
    80203ce2:	87aa                	mv	a5,a0
    80203ce4:	2781                	sext.w	a5,a5
    80203ce6:	2781                	sext.w	a5,a5
}
    80203ce8:	853e                	mv	a0,a5
    80203cea:	60a2                	ld	ra,8(sp)
    80203cec:	6402                	ld	s0,0(sp)
    80203cee:	0141                	addi	sp,sp,16
    80203cf0:	8082                	ret

0000000080203cf2 <plic_complete>:
void plic_complete(int irq) {
    80203cf2:	1101                	addi	sp,sp,-32
    80203cf4:	ec06                	sd	ra,24(sp)
    80203cf6:	e822                	sd	s0,16(sp)
    80203cf8:	1000                	addi	s0,sp,32
    80203cfa:	87aa                	mv	a5,a0
    80203cfc:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    80203d00:	fec42783          	lw	a5,-20(s0)
    80203d04:	85be                	mv	a1,a5
    80203d06:	0c2017b7          	lui	a5,0xc201
    80203d0a:	00478513          	addi	a0,a5,4 # c201004 <userret+0xc200f68>
    80203d0e:	00000097          	auipc	ra,0x0
    80203d12:	dd6080e7          	jalr	-554(ra) # 80203ae4 <write32>
    80203d16:	0001                	nop
    80203d18:	60e2                	ld	ra,24(sp)
    80203d1a:	6442                	ld	s0,16(sp)
    80203d1c:	6105                	addi	sp,sp,32
    80203d1e:	8082                	ret

0000000080203d20 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80203d20:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80203d22:	e006                	sd	ra,0(sp)
        sd gp, 16(sp)
    80203d24:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80203d26:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80203d28:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80203d2a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80203d2c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    80203d2e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80203d30:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80203d32:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80203d34:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80203d36:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80203d38:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80203d3a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80203d3c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80203d3e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80203d40:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80203d42:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80203d44:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80203d46:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80203d48:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    80203d4a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    80203d4c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    80203d4e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80203d50:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80203d52:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80203d54:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80203d56:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80203d58:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80203d5a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80203d5c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80203d5e:	fffff097          	auipc	ra,0xfffff
    80203d62:	3ea080e7          	jalr	1002(ra) # 80203148 <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80203d66:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80203d68:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80203d6a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80203d6c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80203d6e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80203d70:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80203d72:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80203d74:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80203d76:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80203d78:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80203d7a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80203d7c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80203d7e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80203d80:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80203d82:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80203d84:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80203d86:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80203d88:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    80203d8a:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    80203d8c:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    80203d8e:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80203d90:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80203d92:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80203d94:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80203d96:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80203d98:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80203d9a:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80203d9c:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80203d9e:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80203da0:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80203da2:	10200073          	sret
    80203da6:	0001                	nop
    80203da8:	00000013          	nop
    80203dac:	00000013          	nop

0000000080203db0 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80203db0:	00153023          	sd	ra,0(a0) # c201000 <userret+0xc200f64>
        sd sp, 8(a0)
    80203db4:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80203db8:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80203dba:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80203dbc:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80203dc0:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80203dc4:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80203dc8:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80203dcc:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80203dd0:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80203dd4:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80203dd8:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80203ddc:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80203de0:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80203de4:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80203de8:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80203dec:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80203dee:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80203df0:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80203df4:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80203df8:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80203dfc:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80203e00:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80203e04:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80203e08:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80203e0c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80203e10:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80203e14:	0685bd83          	ld	s11,104(a1)
        
        ret
    80203e18:	8082                	ret

0000000080203e1a <r_sstatus>:
        }
    }
}
void kexit() {
    struct proc *p = myproc();
    
    80203e1a:	1101                	addi	sp,sp,-32
    80203e1c:	ec22                	sd	s0,24(sp)
    80203e1e:	1000                	addi	s0,sp,32
    if (p == 0) {
        panic("kexit: no current process");
    80203e20:	100027f3          	csrr	a5,sstatus
    80203e24:	fef43423          	sd	a5,-24(s0)
    }
    80203e28:	fe843783          	ld	a5,-24(s0)
    
    80203e2c:	853e                	mv	a0,a5
    80203e2e:	6462                	ld	s0,24(sp)
    80203e30:	6105                	addi	sp,sp,32
    80203e32:	8082                	ret

0000000080203e34 <w_sstatus>:
    // 不parent为NULL的初始进程退出，目前表示为关机
    80203e34:	1101                	addi	sp,sp,-32
    80203e36:	ec22                	sd	s0,24(sp)
    80203e38:	1000                	addi	s0,sp,32
    80203e3a:	fea43423          	sd	a0,-24(s0)
    if (!p->parent){
    80203e3e:	fe843783          	ld	a5,-24(s0)
    80203e42:	10079073          	csrw	sstatus,a5
		shutdown();
    80203e46:	0001                	nop
    80203e48:	6462                	ld	s0,24(sp)
    80203e4a:	6105                	addi	sp,sp,32
    80203e4c:	8082                	ret

0000000080203e4e <intr_on>:
	}
    
    // 正确设置ZOMBIE状态
    p->state = ZOMBIE;
    
    // 使用父进程自身地址作为通道标识
    80203e4e:	1141                	addi	sp,sp,-16
    80203e50:	e406                	sd	ra,8(sp)
    80203e52:	e022                	sd	s0,0(sp)
    80203e54:	0800                	addi	s0,sp,16
    void *chan = (void*)p->parent;
    80203e56:	00000097          	auipc	ra,0x0
    80203e5a:	fc4080e7          	jalr	-60(ra) # 80203e1a <r_sstatus>
    80203e5e:	87aa                	mv	a5,a0
    80203e60:	0027e793          	ori	a5,a5,2
    80203e64:	853e                	mv	a0,a5
    80203e66:	00000097          	auipc	ra,0x0
    80203e6a:	fce080e7          	jalr	-50(ra) # 80203e34 <w_sstatus>
    // 检查父进程是否在使用相同的通道等待
    80203e6e:	0001                	nop
    80203e70:	60a2                	ld	ra,8(sp)
    80203e72:	6402                	ld	s0,0(sp)
    80203e74:	0141                	addi	sp,sp,16
    80203e76:	8082                	ret

0000000080203e78 <intr_off>:
    if (p->parent->state == SLEEPING && p->parent->chan == chan) {
        wakeup(chan);
    80203e78:	1141                	addi	sp,sp,-16
    80203e7a:	e406                	sd	ra,8(sp)
    80203e7c:	e022                	sd	s0,0(sp)
    80203e7e:	0800                	addi	s0,sp,16
    }
    80203e80:	00000097          	auipc	ra,0x0
    80203e84:	f9a080e7          	jalr	-102(ra) # 80203e1a <r_sstatus>
    80203e88:	87aa                	mv	a5,a0
    80203e8a:	9bf5                	andi	a5,a5,-3
    80203e8c:	853e                	mv	a0,a5
    80203e8e:	00000097          	auipc	ra,0x0
    80203e92:	fa6080e7          	jalr	-90(ra) # 80203e34 <w_sstatus>
    
    80203e96:	0001                	nop
    80203e98:	60a2                	ld	ra,8(sp)
    80203e9a:	6402                	ld	s0,0(sp)
    80203e9c:	0141                	addi	sp,sp,16
    80203e9e:	8082                	ret

0000000080203ea0 <w_stvec>:
    // 在调度前清除当前进程指针，防止该进程再次被调度
    current_proc = 0;
    80203ea0:	1101                	addi	sp,sp,-32
    80203ea2:	ec22                	sd	s0,24(sp)
    80203ea4:	1000                	addi	s0,sp,32
    80203ea6:	fea43423          	sd	a0,-24(s0)
    if (mycpu())
    80203eaa:	fe843783          	ld	a5,-24(s0)
    80203eae:	10579073          	csrw	stvec,a5
        mycpu()->proc = 0;
    80203eb2:	0001                	nop
    80203eb4:	6462                	ld	s0,24(sp)
    80203eb6:	6105                	addi	sp,sp,32
    80203eb8:	8082                	ret

0000000080203eba <assert>:
            free_proc(zombie_child);
			zombie_child = NULL;
            intr_on();
            return zombie_pid;
        }
        
    80203eba:	1101                	addi	sp,sp,-32
    80203ebc:	ec06                	sd	ra,24(sp)
    80203ebe:	e822                	sd	s0,16(sp)
    80203ec0:	1000                	addi	s0,sp,32
    80203ec2:	87aa                	mv	a5,a0
    80203ec4:	fef42623          	sw	a5,-20(s0)
        // 检查是否有任何子进程
    80203ec8:	fec42783          	lw	a5,-20(s0)
    80203ecc:	2781                	sext.w	a5,a5
    80203ece:	e79d                	bnez	a5,80203efc <assert+0x42>
        int havekids = 0;
    80203ed0:	18900613          	li	a2,393
    80203ed4:	00004597          	auipc	a1,0x4
    80203ed8:	d4458593          	addi	a1,a1,-700 # 80207c18 <small_numbers+0x1828>
    80203edc:	00004517          	auipc	a0,0x4
    80203ee0:	d4c50513          	addi	a0,a0,-692 # 80207c28 <small_numbers+0x1838>
    80203ee4:	ffffd097          	auipc	ra,0xffffd
    80203ee8:	c4a080e7          	jalr	-950(ra) # 80200b2e <printf>
        for (int i = 0; i < PROC; i++) {
    80203eec:	00004517          	auipc	a0,0x4
    80203ef0:	d6450513          	addi	a0,a0,-668 # 80207c50 <small_numbers+0x1860>
    80203ef4:	ffffd097          	auipc	ra,0xffffd
    80203ef8:	542080e7          	jalr	1346(ra) # 80201436 <panic>
            struct proc *child = proc_table[i];
            if (child->state != UNUSED && child->parent == p) {
    80203efc:	0001                	nop
    80203efe:	60e2                	ld	ra,24(sp)
    80203f00:	6442                	ld	s0,16(sp)
    80203f02:	6105                	addi	sp,sp,32
    80203f04:	8082                	ret

0000000080203f06 <shutdown>:
void shutdown() {
    80203f06:	1141                	addi	sp,sp,-16
    80203f08:	e406                	sd	ra,8(sp)
    80203f0a:	e022                	sd	s0,0(sp)
    80203f0c:	0800                	addi	s0,sp,16
	free_proc_table();
    80203f0e:	00000097          	auipc	ra,0x0
    80203f12:	38c080e7          	jalr	908(ra) # 8020429a <free_proc_table>
    printf("关机\n");
    80203f16:	00004517          	auipc	a0,0x4
    80203f1a:	d4250513          	addi	a0,a0,-702 # 80207c58 <small_numbers+0x1868>
    80203f1e:	ffffd097          	auipc	ra,0xffffd
    80203f22:	c10080e7          	jalr	-1008(ra) # 80200b2e <printf>
    asm volatile (
    80203f26:	48a1                	li	a7,8
    80203f28:	00000073          	ecall
    while (1) { }
    80203f2c:	0001                	nop
    80203f2e:	bffd                	j	80203f2c <shutdown+0x26>

0000000080203f30 <myproc>:
struct proc* myproc(void) {
    80203f30:	1141                	addi	sp,sp,-16
    80203f32:	e422                	sd	s0,8(sp)
    80203f34:	0800                	addi	s0,sp,16
    return current_proc;
    80203f36:	00006797          	auipc	a5,0x6
    80203f3a:	15a78793          	addi	a5,a5,346 # 8020a090 <current_proc>
    80203f3e:	639c                	ld	a5,0(a5)
}
    80203f40:	853e                	mv	a0,a5
    80203f42:	6422                	ld	s0,8(sp)
    80203f44:	0141                	addi	sp,sp,16
    80203f46:	8082                	ret

0000000080203f48 <mycpu>:
struct cpu* mycpu(void) {
    80203f48:	1141                	addi	sp,sp,-16
    80203f4a:	e406                	sd	ra,8(sp)
    80203f4c:	e022                	sd	s0,0(sp)
    80203f4e:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80203f50:	00006797          	auipc	a5,0x6
    80203f54:	14878793          	addi	a5,a5,328 # 8020a098 <current_cpu>
    80203f58:	639c                	ld	a5,0(a5)
    80203f5a:	ebb9                	bnez	a5,80203fb0 <mycpu+0x68>
        warning("current_cpu is NULL, initializing...\n");
    80203f5c:	00004517          	auipc	a0,0x4
    80203f60:	d0450513          	addi	a0,a0,-764 # 80207c60 <small_numbers+0x1870>
    80203f64:	ffffd097          	auipc	ra,0xffffd
    80203f68:	506080e7          	jalr	1286(ra) # 8020146a <warning>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    80203f6c:	07800613          	li	a2,120
    80203f70:	4581                	li	a1,0
    80203f72:	00008517          	auipc	a0,0x8
    80203f76:	45e50513          	addi	a0,a0,1118 # 8020c3d0 <cpu_instance.1>
    80203f7a:	ffffe097          	auipc	ra,0xffffe
    80203f7e:	bfa080e7          	jalr	-1030(ra) # 80201b74 <memset>
		current_cpu = &cpu_instance;
    80203f82:	00006797          	auipc	a5,0x6
    80203f86:	11678793          	addi	a5,a5,278 # 8020a098 <current_cpu>
    80203f8a:	00008717          	auipc	a4,0x8
    80203f8e:	44670713          	addi	a4,a4,1094 # 8020c3d0 <cpu_instance.1>
    80203f92:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    80203f94:	00006797          	auipc	a5,0x6
    80203f98:	10478793          	addi	a5,a5,260 # 8020a098 <current_cpu>
    80203f9c:	639c                	ld	a5,0(a5)
    80203f9e:	85be                	mv	a1,a5
    80203fa0:	00004517          	auipc	a0,0x4
    80203fa4:	ce850513          	addi	a0,a0,-792 # 80207c88 <small_numbers+0x1898>
    80203fa8:	ffffd097          	auipc	ra,0xffffd
    80203fac:	b86080e7          	jalr	-1146(ra) # 80200b2e <printf>
    return current_cpu;
    80203fb0:	00006797          	auipc	a5,0x6
    80203fb4:	0e878793          	addi	a5,a5,232 # 8020a098 <current_cpu>
    80203fb8:	639c                	ld	a5,0(a5)
}
    80203fba:	853e                	mv	a0,a5
    80203fbc:	60a2                	ld	ra,8(sp)
    80203fbe:	6402                	ld	s0,0(sp)
    80203fc0:	0141                	addi	sp,sp,16
    80203fc2:	8082                	ret

0000000080203fc4 <return_to_user>:
void return_to_user(void) {
    80203fc4:	7179                	addi	sp,sp,-48
    80203fc6:	f406                	sd	ra,40(sp)
    80203fc8:	f022                	sd	s0,32(sp)
    80203fca:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80203fcc:	00000097          	auipc	ra,0x0
    80203fd0:	f64080e7          	jalr	-156(ra) # 80203f30 <myproc>
    80203fd4:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80203fd8:	fe843783          	ld	a5,-24(s0)
    80203fdc:	eb89                	bnez	a5,80203fee <return_to_user+0x2a>
        panic("return_to_user: no current process");
    80203fde:	00004517          	auipc	a0,0x4
    80203fe2:	cc250513          	addi	a0,a0,-830 # 80207ca0 <small_numbers+0x18b0>
    80203fe6:	ffffd097          	auipc	ra,0xffffd
    80203fea:	450080e7          	jalr	1104(ra) # 80201436 <panic>
    if (p->chan != 0) {
    80203fee:	fe843783          	ld	a5,-24(s0)
    80203ff2:	73dc                	ld	a5,160(a5)
    80203ff4:	c791                	beqz	a5,80204000 <return_to_user+0x3c>
        p->chan = 0;  // 清除通道标记
    80203ff6:	fe843783          	ld	a5,-24(s0)
    80203ffa:	0a07b023          	sd	zero,160(a5)
        return;  // 直接返回，不做任何状态更改
    80203ffe:	a861                	j	80204096 <return_to_user+0xd2>
    w_stvec(TRAMPOLINE);
    80204000:	080007b7          	lui	a5,0x8000
    80204004:	17fd                	addi	a5,a5,-1 # 7ffffff <userret+0x7ffff63>
    80204006:	00c79513          	slli	a0,a5,0xc
    8020400a:	00000097          	auipc	ra,0x0
    8020400e:	e96080e7          	jalr	-362(ra) # 80203ea0 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80204012:	00000737          	lui	a4,0x0
    80204016:	09c70713          	addi	a4,a4,156 # 9c <userret>
    8020401a:	000007b7          	lui	a5,0x0
    8020401e:	00078793          	mv	a5,a5
    80204022:	8f1d                	sub	a4,a4,a5
    80204024:	080007b7          	lui	a5,0x8000
    80204028:	17fd                	addi	a5,a5,-1 # 7ffffff <userret+0x7ffff63>
    8020402a:	07b2                	slli	a5,a5,0xc
    8020402c:	97ba                	add	a5,a5,a4
    8020402e:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    80204032:	fe843783          	ld	a5,-24(s0)
    80204036:	7fdc                	ld	a5,184(a5)
    80204038:	00c7d713          	srli	a4,a5,0xc
    8020403c:	57fd                	li	a5,-1
    8020403e:	17fe                	slli	a5,a5,0x3f
    80204040:	8fd9                	or	a5,a5,a4
    80204042:	fcf43c23          	sd	a5,-40(s0)
    if (trampoline_userret < TRAMPOLINE || trampoline_userret >= TRAMPOLINE + PGSIZE) {
    80204046:	fe043703          	ld	a4,-32(s0)
    8020404a:	fefff7b7          	lui	a5,0xfefff
    8020404e:	07b6                	slli	a5,a5,0xd
    80204050:	83e5                	srli	a5,a5,0x19
    80204052:	00e7f863          	bgeu	a5,a4,80204062 <return_to_user+0x9e>
    80204056:	fe043703          	ld	a4,-32(s0)
    8020405a:	57fd                	li	a5,-1
    8020405c:	83e5                	srli	a5,a5,0x19
    8020405e:	00e7fa63          	bgeu	a5,a4,80204072 <return_to_user+0xae>
        panic("return_to_user: 跳转地址超出trampoline页范围");
    80204062:	00004517          	auipc	a0,0x4
    80204066:	c6650513          	addi	a0,a0,-922 # 80207cc8 <small_numbers+0x18d8>
    8020406a:	ffffd097          	auipc	ra,0xffffd
    8020406e:	3cc080e7          	jalr	972(ra) # 80201436 <panic>
    ((void (*)(uint64, uint64))trampoline_userret)(TRAPFRAME, satp);
    80204072:	fe043783          	ld	a5,-32(s0)
    80204076:	fd843583          	ld	a1,-40(s0)
    8020407a:	04000737          	lui	a4,0x4000
    8020407e:	177d                	addi	a4,a4,-1 # 3ffffff <userret+0x3ffff63>
    80204080:	00d71513          	slli	a0,a4,0xd
    80204084:	9782                	jalr	a5
    panic("return_to_user: 不应该返回到这里");
    80204086:	00004517          	auipc	a0,0x4
    8020408a:	c7a50513          	addi	a0,a0,-902 # 80207d00 <small_numbers+0x1910>
    8020408e:	ffffd097          	auipc	ra,0xffffd
    80204092:	3a8080e7          	jalr	936(ra) # 80201436 <panic>
}
    80204096:	70a2                	ld	ra,40(sp)
    80204098:	7402                	ld	s0,32(sp)
    8020409a:	6145                	addi	sp,sp,48
    8020409c:	8082                	ret

000000008020409e <forkret>:
void forkret(void){
    8020409e:	7179                	addi	sp,sp,-48
    802040a0:	f406                	sd	ra,40(sp)
    802040a2:	f022                	sd	s0,32(sp)
    802040a4:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    802040a6:	00000097          	auipc	ra,0x0
    802040aa:	e8a080e7          	jalr	-374(ra) # 80203f30 <myproc>
    802040ae:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    802040b2:	fe843783          	ld	a5,-24(s0)
    802040b6:	eb89                	bnez	a5,802040c8 <forkret+0x2a>
        panic("forkret: no current process");
    802040b8:	00004517          	auipc	a0,0x4
    802040bc:	c7850513          	addi	a0,a0,-904 # 80207d30 <small_numbers+0x1940>
    802040c0:	ffffd097          	auipc	ra,0xffffd
    802040c4:	376080e7          	jalr	886(ra) # 80201436 <panic>
    if (p->chan != 0) {
    802040c8:	fe843783          	ld	a5,-24(s0)
    802040cc:	73dc                	ld	a5,160(a5)
    802040ce:	c791                	beqz	a5,802040da <forkret+0x3c>
        p->chan = 0;  // 清除通道标记
    802040d0:	fe843783          	ld	a5,-24(s0)
    802040d4:	0a07b023          	sd	zero,160(a5) # fffffffffefff0a0 <_bss_end+0xffffffff7edf2c50>
        return;  // 直接返回，继续执行原来的函数
    802040d8:	a81d                	j	8020410e <forkret+0x70>
    uint64 entry = p->trapframe->epc;
    802040da:	fe843783          	ld	a5,-24(s0)
    802040de:	63fc                	ld	a5,192(a5)
    802040e0:	6f9c                	ld	a5,24(a5)
    802040e2:	fef43023          	sd	a5,-32(s0)
    if (entry != 0) {
    802040e6:	fe043783          	ld	a5,-32(s0)
    802040ea:	cf91                	beqz	a5,80204106 <forkret+0x68>
        void (*fn)(void) = (void(*)(void))entry;
    802040ec:	fe043783          	ld	a5,-32(s0)
    802040f0:	fcf43c23          	sd	a5,-40(s0)
        fn();  // 调用入口函数
    802040f4:	fd843783          	ld	a5,-40(s0)
    802040f8:	9782                	jalr	a5
        exit_proc(0);  // 如果入口函数返回，则退出进程
    802040fa:	4501                	li	a0,0
    802040fc:	00000097          	auipc	ra,0x0
    80204100:	48c080e7          	jalr	1164(ra) # 80204588 <exit_proc>
    80204104:	a029                	j	8020410e <forkret+0x70>
        return_to_user();
    80204106:	00000097          	auipc	ra,0x0
    8020410a:	ebe080e7          	jalr	-322(ra) # 80203fc4 <return_to_user>
}
    8020410e:	70a2                	ld	ra,40(sp)
    80204110:	7402                	ld	s0,32(sp)
    80204112:	6145                	addi	sp,sp,48
    80204114:	8082                	ret

0000000080204116 <init_proc>:
void init_proc(void){
    80204116:	1101                	addi	sp,sp,-32
    80204118:	ec06                	sd	ra,24(sp)
    8020411a:	e822                	sd	s0,16(sp)
    8020411c:	1000                	addi	s0,sp,32
    for (int i = 0; i < PROC; i++) {
    8020411e:	fe042623          	sw	zero,-20(s0)
    80204122:	aa81                	j	80204272 <init_proc+0x15c>
        void *page = alloc_page();
    80204124:	fffff097          	auipc	ra,0xfffff
    80204128:	966080e7          	jalr	-1690(ra) # 80202a8a <alloc_page>
    8020412c:	fea43023          	sd	a0,-32(s0)
        if (!page) panic("init_proc: alloc_page failed for proc_table");
    80204130:	fe043783          	ld	a5,-32(s0)
    80204134:	eb89                	bnez	a5,80204146 <init_proc+0x30>
    80204136:	00004517          	auipc	a0,0x4
    8020413a:	c1a50513          	addi	a0,a0,-998 # 80207d50 <small_numbers+0x1960>
    8020413e:	ffffd097          	auipc	ra,0xffffd
    80204142:	2f8080e7          	jalr	760(ra) # 80201436 <panic>
        proc_table_mem[i] = page;
    80204146:	00007717          	auipc	a4,0x7
    8020414a:	28270713          	addi	a4,a4,642 # 8020b3c8 <proc_table_mem>
    8020414e:	fec42783          	lw	a5,-20(s0)
    80204152:	078e                	slli	a5,a5,0x3
    80204154:	97ba                	add	a5,a5,a4
    80204156:	fe043703          	ld	a4,-32(s0)
    8020415a:	e398                	sd	a4,0(a5)
        proc_table[i] = (struct proc *)page;
    8020415c:	00006717          	auipc	a4,0x6
    80204160:	26470713          	addi	a4,a4,612 # 8020a3c0 <proc_table>
    80204164:	fec42783          	lw	a5,-20(s0)
    80204168:	078e                	slli	a5,a5,0x3
    8020416a:	97ba                	add	a5,a5,a4
    8020416c:	fe043703          	ld	a4,-32(s0)
    80204170:	e398                	sd	a4,0(a5)
        memset(proc_table[i], 0, sizeof(struct proc));
    80204172:	00006717          	auipc	a4,0x6
    80204176:	24e70713          	addi	a4,a4,590 # 8020a3c0 <proc_table>
    8020417a:	fec42783          	lw	a5,-20(s0)
    8020417e:	078e                	slli	a5,a5,0x3
    80204180:	97ba                	add	a5,a5,a4
    80204182:	639c                	ld	a5,0(a5)
    80204184:	0c800613          	li	a2,200
    80204188:	4581                	li	a1,0
    8020418a:	853e                	mv	a0,a5
    8020418c:	ffffe097          	auipc	ra,0xffffe
    80204190:	9e8080e7          	jalr	-1560(ra) # 80201b74 <memset>
        proc_table[i]->state = UNUSED;
    80204194:	00006717          	auipc	a4,0x6
    80204198:	22c70713          	addi	a4,a4,556 # 8020a3c0 <proc_table>
    8020419c:	fec42783          	lw	a5,-20(s0)
    802041a0:	078e                	slli	a5,a5,0x3
    802041a2:	97ba                	add	a5,a5,a4
    802041a4:	639c                	ld	a5,0(a5)
    802041a6:	0007a023          	sw	zero,0(a5)
        proc_table[i]->pid = 0;
    802041aa:	00006717          	auipc	a4,0x6
    802041ae:	21670713          	addi	a4,a4,534 # 8020a3c0 <proc_table>
    802041b2:	fec42783          	lw	a5,-20(s0)
    802041b6:	078e                	slli	a5,a5,0x3
    802041b8:	97ba                	add	a5,a5,a4
    802041ba:	639c                	ld	a5,0(a5)
    802041bc:	0007a223          	sw	zero,4(a5)
        proc_table[i]->kstack = 0;
    802041c0:	00006717          	auipc	a4,0x6
    802041c4:	20070713          	addi	a4,a4,512 # 8020a3c0 <proc_table>
    802041c8:	fec42783          	lw	a5,-20(s0)
    802041cc:	078e                	slli	a5,a5,0x3
    802041ce:	97ba                	add	a5,a5,a4
    802041d0:	639c                	ld	a5,0(a5)
    802041d2:	0007b423          	sd	zero,8(a5)
        proc_table[i]->pagetable = 0;
    802041d6:	00006717          	auipc	a4,0x6
    802041da:	1ea70713          	addi	a4,a4,490 # 8020a3c0 <proc_table>
    802041de:	fec42783          	lw	a5,-20(s0)
    802041e2:	078e                	slli	a5,a5,0x3
    802041e4:	97ba                	add	a5,a5,a4
    802041e6:	639c                	ld	a5,0(a5)
    802041e8:	0a07bc23          	sd	zero,184(a5)
        proc_table[i]->trapframe = 0;
    802041ec:	00006717          	auipc	a4,0x6
    802041f0:	1d470713          	addi	a4,a4,468 # 8020a3c0 <proc_table>
    802041f4:	fec42783          	lw	a5,-20(s0)
    802041f8:	078e                	slli	a5,a5,0x3
    802041fa:	97ba                	add	a5,a5,a4
    802041fc:	639c                	ld	a5,0(a5)
    802041fe:	0c07b023          	sd	zero,192(a5)
        proc_table[i]->parent = 0;
    80204202:	00006717          	auipc	a4,0x6
    80204206:	1be70713          	addi	a4,a4,446 # 8020a3c0 <proc_table>
    8020420a:	fec42783          	lw	a5,-20(s0)
    8020420e:	078e                	slli	a5,a5,0x3
    80204210:	97ba                	add	a5,a5,a4
    80204212:	639c                	ld	a5,0(a5)
    80204214:	0807bc23          	sd	zero,152(a5)
        proc_table[i]->chan = 0;
    80204218:	00006717          	auipc	a4,0x6
    8020421c:	1a870713          	addi	a4,a4,424 # 8020a3c0 <proc_table>
    80204220:	fec42783          	lw	a5,-20(s0)
    80204224:	078e                	slli	a5,a5,0x3
    80204226:	97ba                	add	a5,a5,a4
    80204228:	639c                	ld	a5,0(a5)
    8020422a:	0a07b023          	sd	zero,160(a5)
        proc_table[i]->exit_status = 0;
    8020422e:	00006717          	auipc	a4,0x6
    80204232:	19270713          	addi	a4,a4,402 # 8020a3c0 <proc_table>
    80204236:	fec42783          	lw	a5,-20(s0)
    8020423a:	078e                	slli	a5,a5,0x3
    8020423c:	97ba                	add	a5,a5,a4
    8020423e:	639c                	ld	a5,0(a5)
    80204240:	0807a223          	sw	zero,132(a5)
        memset(&proc_table[i]->context, 0, sizeof(struct context));
    80204244:	00006717          	auipc	a4,0x6
    80204248:	17c70713          	addi	a4,a4,380 # 8020a3c0 <proc_table>
    8020424c:	fec42783          	lw	a5,-20(s0)
    80204250:	078e                	slli	a5,a5,0x3
    80204252:	97ba                	add	a5,a5,a4
    80204254:	639c                	ld	a5,0(a5)
    80204256:	07c1                	addi	a5,a5,16
    80204258:	07000613          	li	a2,112
    8020425c:	4581                	li	a1,0
    8020425e:	853e                	mv	a0,a5
    80204260:	ffffe097          	auipc	ra,0xffffe
    80204264:	914080e7          	jalr	-1772(ra) # 80201b74 <memset>
    for (int i = 0; i < PROC; i++) {
    80204268:	fec42783          	lw	a5,-20(s0)
    8020426c:	2785                	addiw	a5,a5,1
    8020426e:	fef42623          	sw	a5,-20(s0)
    80204272:	fec42783          	lw	a5,-20(s0)
    80204276:	0007871b          	sext.w	a4,a5
    8020427a:	1ff00793          	li	a5,511
    8020427e:	eae7d3e3          	bge	a5,a4,80204124 <init_proc+0xe>
    proc_table_pages = PROC; // 每个进程一页
    80204282:	00007797          	auipc	a5,0x7
    80204286:	13e78793          	addi	a5,a5,318 # 8020b3c0 <proc_table_pages>
    8020428a:	20000713          	li	a4,512
    8020428e:	c398                	sw	a4,0(a5)
}
    80204290:	0001                	nop
    80204292:	60e2                	ld	ra,24(sp)
    80204294:	6442                	ld	s0,16(sp)
    80204296:	6105                	addi	sp,sp,32
    80204298:	8082                	ret

000000008020429a <free_proc_table>:
void free_proc_table(void) {
    8020429a:	1101                	addi	sp,sp,-32
    8020429c:	ec06                	sd	ra,24(sp)
    8020429e:	e822                	sd	s0,16(sp)
    802042a0:	1000                	addi	s0,sp,32
    for (int i = 0; i < proc_table_pages; i++) {
    802042a2:	fe042623          	sw	zero,-20(s0)
    802042a6:	a025                	j	802042ce <free_proc_table+0x34>
        free_page(proc_table_mem[i]);
    802042a8:	00007717          	auipc	a4,0x7
    802042ac:	12070713          	addi	a4,a4,288 # 8020b3c8 <proc_table_mem>
    802042b0:	fec42783          	lw	a5,-20(s0)
    802042b4:	078e                	slli	a5,a5,0x3
    802042b6:	97ba                	add	a5,a5,a4
    802042b8:	639c                	ld	a5,0(a5)
    802042ba:	853e                	mv	a0,a5
    802042bc:	fffff097          	auipc	ra,0xfffff
    802042c0:	83a080e7          	jalr	-1990(ra) # 80202af6 <free_page>
    for (int i = 0; i < proc_table_pages; i++) {
    802042c4:	fec42783          	lw	a5,-20(s0)
    802042c8:	2785                	addiw	a5,a5,1
    802042ca:	fef42623          	sw	a5,-20(s0)
    802042ce:	00007797          	auipc	a5,0x7
    802042d2:	0f278793          	addi	a5,a5,242 # 8020b3c0 <proc_table_pages>
    802042d6:	4398                	lw	a4,0(a5)
    802042d8:	fec42783          	lw	a5,-20(s0)
    802042dc:	2781                	sext.w	a5,a5
    802042de:	fce7c5e3          	blt	a5,a4,802042a8 <free_proc_table+0xe>
}
    802042e2:	0001                	nop
    802042e4:	0001                	nop
    802042e6:	60e2                	ld	ra,24(sp)
    802042e8:	6442                	ld	s0,16(sp)
    802042ea:	6105                	addi	sp,sp,32
    802042ec:	8082                	ret

00000000802042ee <alloc_proc>:
struct proc* alloc_proc(void) {
    802042ee:	7179                	addi	sp,sp,-48
    802042f0:	f406                	sd	ra,40(sp)
    802042f2:	f022                	sd	s0,32(sp)
    802042f4:	1800                	addi	s0,sp,48
    for(int i = 0;i<PROC;i++) {
    802042f6:	fe042623          	sw	zero,-20(s0)
    802042fa:	a2a9                	j	80204444 <alloc_proc+0x156>
		struct proc *p = proc_table[i];
    802042fc:	00006717          	auipc	a4,0x6
    80204300:	0c470713          	addi	a4,a4,196 # 8020a3c0 <proc_table>
    80204304:	fec42783          	lw	a5,-20(s0)
    80204308:	078e                	slli	a5,a5,0x3
    8020430a:	97ba                	add	a5,a5,a4
    8020430c:	639c                	ld	a5,0(a5)
    8020430e:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    80204312:	fe043783          	ld	a5,-32(s0)
    80204316:	439c                	lw	a5,0(a5)
    80204318:	12079163          	bnez	a5,8020443a <alloc_proc+0x14c>
            p->pid = i;
    8020431c:	fe043783          	ld	a5,-32(s0)
    80204320:	fec42703          	lw	a4,-20(s0)
    80204324:	c3d8                	sw	a4,4(a5)
            p->state = USED;
    80204326:	fe043783          	ld	a5,-32(s0)
    8020432a:	4705                	li	a4,1
    8020432c:	c398                	sw	a4,0(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    8020432e:	ffffe097          	auipc	ra,0xffffe
    80204332:	75c080e7          	jalr	1884(ra) # 80202a8a <alloc_page>
    80204336:	872a                	mv	a4,a0
    80204338:	fe043783          	ld	a5,-32(s0)
    8020433c:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    8020433e:	fe043783          	ld	a5,-32(s0)
    80204342:	63fc                	ld	a5,192(a5)
    80204344:	eb99                	bnez	a5,8020435a <alloc_proc+0x6c>
                p->state = UNUSED;
    80204346:	fe043783          	ld	a5,-32(s0)
    8020434a:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    8020434e:	fe043783          	ld	a5,-32(s0)
    80204352:	0007a223          	sw	zero,4(a5)
                return 0;
    80204356:	4781                	li	a5,0
    80204358:	a8fd                	j	80204456 <alloc_proc+0x168>
            p->pagetable = create_pagetable();
    8020435a:	ffffe097          	auipc	ra,0xffffe
    8020435e:	a12080e7          	jalr	-1518(ra) # 80201d6c <create_pagetable>
    80204362:	872a                	mv	a4,a0
    80204364:	fe043783          	ld	a5,-32(s0)
    80204368:	ffd8                	sd	a4,184(a5)
            if(p->pagetable == 0){
    8020436a:	fe043783          	ld	a5,-32(s0)
    8020436e:	7fdc                	ld	a5,184(a5)
    80204370:	e79d                	bnez	a5,8020439e <alloc_proc+0xb0>
                free_page(p->trapframe);
    80204372:	fe043783          	ld	a5,-32(s0)
    80204376:	63fc                	ld	a5,192(a5)
    80204378:	853e                	mv	a0,a5
    8020437a:	ffffe097          	auipc	ra,0xffffe
    8020437e:	77c080e7          	jalr	1916(ra) # 80202af6 <free_page>
                p->trapframe = 0;
    80204382:	fe043783          	ld	a5,-32(s0)
    80204386:	0c07b023          	sd	zero,192(a5)
                p->state = UNUSED;
    8020438a:	fe043783          	ld	a5,-32(s0)
    8020438e:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80204392:	fe043783          	ld	a5,-32(s0)
    80204396:	0007a223          	sw	zero,4(a5)
                return 0;
    8020439a:	4781                	li	a5,0
    8020439c:	a86d                	j	80204456 <alloc_proc+0x168>
            void *kstack_mem = alloc_page();
    8020439e:	ffffe097          	auipc	ra,0xffffe
    802043a2:	6ec080e7          	jalr	1772(ra) # 80202a8a <alloc_page>
    802043a6:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    802043aa:	fd843783          	ld	a5,-40(s0)
    802043ae:	e3b9                	bnez	a5,802043f4 <alloc_proc+0x106>
                free_page(p->trapframe);
    802043b0:	fe043783          	ld	a5,-32(s0)
    802043b4:	63fc                	ld	a5,192(a5)
    802043b6:	853e                	mv	a0,a5
    802043b8:	ffffe097          	auipc	ra,0xffffe
    802043bc:	73e080e7          	jalr	1854(ra) # 80202af6 <free_page>
                free_pagetable(p->pagetable);
    802043c0:	fe043783          	ld	a5,-32(s0)
    802043c4:	7fdc                	ld	a5,184(a5)
    802043c6:	853e                	mv	a0,a5
    802043c8:	ffffe097          	auipc	ra,0xffffe
    802043cc:	c52080e7          	jalr	-942(ra) # 8020201a <free_pagetable>
                p->trapframe = 0;
    802043d0:	fe043783          	ld	a5,-32(s0)
    802043d4:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    802043d8:	fe043783          	ld	a5,-32(s0)
    802043dc:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    802043e0:	fe043783          	ld	a5,-32(s0)
    802043e4:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    802043e8:	fe043783          	ld	a5,-32(s0)
    802043ec:	0007a223          	sw	zero,4(a5)
                return 0;
    802043f0:	4781                	li	a5,0
    802043f2:	a095                	j	80204456 <alloc_proc+0x168>
            p->kstack = (uint64)kstack_mem;
    802043f4:	fd843703          	ld	a4,-40(s0)
    802043f8:	fe043783          	ld	a5,-32(s0)
    802043fc:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    802043fe:	fe043783          	ld	a5,-32(s0)
    80204402:	07c1                	addi	a5,a5,16
    80204404:	07000613          	li	a2,112
    80204408:	4581                	li	a1,0
    8020440a:	853e                	mv	a0,a5
    8020440c:	ffffd097          	auipc	ra,0xffffd
    80204410:	768080e7          	jalr	1896(ra) # 80201b74 <memset>
            p->context.ra = (uint64)forkret;
    80204414:	00000717          	auipc	a4,0x0
    80204418:	c8a70713          	addi	a4,a4,-886 # 8020409e <forkret>
    8020441c:	fe043783          	ld	a5,-32(s0)
    80204420:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    80204422:	fe043783          	ld	a5,-32(s0)
    80204426:	6798                	ld	a4,8(a5)
    80204428:	6785                	lui	a5,0x1
    8020442a:	17c1                	addi	a5,a5,-16 # ff0 <userret+0xf54>
    8020442c:	973e                	add	a4,a4,a5
    8020442e:	fe043783          	ld	a5,-32(s0)
    80204432:	ef98                	sd	a4,24(a5)
            return p;
    80204434:	fe043783          	ld	a5,-32(s0)
    80204438:	a839                	j	80204456 <alloc_proc+0x168>
    for(int i = 0;i<PROC;i++) {
    8020443a:	fec42783          	lw	a5,-20(s0)
    8020443e:	2785                	addiw	a5,a5,1
    80204440:	fef42623          	sw	a5,-20(s0)
    80204444:	fec42783          	lw	a5,-20(s0)
    80204448:	0007871b          	sext.w	a4,a5
    8020444c:	1ff00793          	li	a5,511
    80204450:	eae7d6e3          	bge	a5,a4,802042fc <alloc_proc+0xe>
    return 0;
    80204454:	4781                	li	a5,0
}
    80204456:	853e                	mv	a0,a5
    80204458:	70a2                	ld	ra,40(sp)
    8020445a:	7402                	ld	s0,32(sp)
    8020445c:	6145                	addi	sp,sp,48
    8020445e:	8082                	ret

0000000080204460 <free_proc>:
void free_proc(struct proc *p){
    80204460:	1101                	addi	sp,sp,-32
    80204462:	ec06                	sd	ra,24(sp)
    80204464:	e822                	sd	s0,16(sp)
    80204466:	1000                	addi	s0,sp,32
    80204468:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    8020446c:	fe843783          	ld	a5,-24(s0)
    80204470:	63fc                	ld	a5,192(a5)
    80204472:	cb89                	beqz	a5,80204484 <free_proc+0x24>
        free_page(p->trapframe);
    80204474:	fe843783          	ld	a5,-24(s0)
    80204478:	63fc                	ld	a5,192(a5)
    8020447a:	853e                	mv	a0,a5
    8020447c:	ffffe097          	auipc	ra,0xffffe
    80204480:	67a080e7          	jalr	1658(ra) # 80202af6 <free_page>
    p->trapframe = 0;
    80204484:	fe843783          	ld	a5,-24(s0)
    80204488:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable)
    8020448c:	fe843783          	ld	a5,-24(s0)
    80204490:	7fdc                	ld	a5,184(a5)
    80204492:	cb89                	beqz	a5,802044a4 <free_proc+0x44>
        free_pagetable(p->pagetable);
    80204494:	fe843783          	ld	a5,-24(s0)
    80204498:	7fdc                	ld	a5,184(a5)
    8020449a:	853e                	mv	a0,a5
    8020449c:	ffffe097          	auipc	ra,0xffffe
    802044a0:	b7e080e7          	jalr	-1154(ra) # 8020201a <free_pagetable>
    p->pagetable = 0;
    802044a4:	fe843783          	ld	a5,-24(s0)
    802044a8:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    802044ac:	fe843783          	ld	a5,-24(s0)
    802044b0:	679c                	ld	a5,8(a5)
    802044b2:	cb89                	beqz	a5,802044c4 <free_proc+0x64>
        free_page((void*)p->kstack);
    802044b4:	fe843783          	ld	a5,-24(s0)
    802044b8:	679c                	ld	a5,8(a5)
    802044ba:	853e                	mv	a0,a5
    802044bc:	ffffe097          	auipc	ra,0xffffe
    802044c0:	63a080e7          	jalr	1594(ra) # 80202af6 <free_page>
    p->kstack = 0;
    802044c4:	fe843783          	ld	a5,-24(s0)
    802044c8:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    802044cc:	fe843783          	ld	a5,-24(s0)
    802044d0:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    802044d4:	fe843783          	ld	a5,-24(s0)
    802044d8:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    802044dc:	fe843783          	ld	a5,-24(s0)
    802044e0:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    802044e4:	fe843783          	ld	a5,-24(s0)
    802044e8:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    802044ec:	fe843783          	ld	a5,-24(s0)
    802044f0:	07c1                	addi	a5,a5,16
    802044f2:	07000613          	li	a2,112
    802044f6:	4581                	li	a1,0
    802044f8:	853e                	mv	a0,a5
    802044fa:	ffffd097          	auipc	ra,0xffffd
    802044fe:	67a080e7          	jalr	1658(ra) # 80201b74 <memset>
}
    80204502:	0001                	nop
    80204504:	60e2                	ld	ra,24(sp)
    80204506:	6442                	ld	s0,16(sp)
    80204508:	6105                	addi	sp,sp,32
    8020450a:	8082                	ret

000000008020450c <create_proc>:
int create_proc(void (*entry)(void), int is_user) {
    8020450c:	7179                	addi	sp,sp,-48
    8020450e:	f406                	sd	ra,40(sp)
    80204510:	f022                	sd	s0,32(sp)
    80204512:	1800                	addi	s0,sp,48
    80204514:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc();
    80204518:	00000097          	auipc	ra,0x0
    8020451c:	dd6080e7          	jalr	-554(ra) # 802042ee <alloc_proc>
    80204520:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    80204524:	fe843783          	ld	a5,-24(s0)
    80204528:	e399                	bnez	a5,8020452e <create_proc+0x22>
    8020452a:	57fd                	li	a5,-1
    8020452c:	a889                	j	8020457e <create_proc+0x72>
    p->trapframe->epc = (uint64)entry;
    8020452e:	fe843783          	ld	a5,-24(s0)
    80204532:	63fc                	ld	a5,192(a5)
    80204534:	fd843703          	ld	a4,-40(s0)
    80204538:	ef98                	sd	a4,24(a5)
    p->state = RUNNABLE;
    8020453a:	fe843783          	ld	a5,-24(s0)
    8020453e:	470d                	li	a4,3
    80204540:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    80204542:	00000097          	auipc	ra,0x0
    80204546:	9ee080e7          	jalr	-1554(ra) # 80203f30 <myproc>
    8020454a:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    8020454e:	fe043783          	ld	a5,-32(s0)
    80204552:	c799                	beqz	a5,80204560 <create_proc+0x54>
        p->parent = parent;
    80204554:	fe843783          	ld	a5,-24(s0)
    80204558:	fe043703          	ld	a4,-32(s0)
    8020455c:	efd8                	sd	a4,152(a5)
    8020455e:	a829                	j	80204578 <create_proc+0x6c>
        p->parent = NULL;
    80204560:	00004517          	auipc	a0,0x4
    80204564:	82050513          	addi	a0,a0,-2016 # 80207d80 <small_numbers+0x1990>
    80204568:	ffffd097          	auipc	ra,0xffffd
    8020456c:	f02080e7          	jalr	-254(ra) # 8020146a <warning>
    }
    80204570:	fe843783          	ld	a5,-24(s0)
    80204574:	0807bc23          	sd	zero,152(a5)
void exit_proc(int status) {
    80204578:	fe843783          	ld	a5,-24(s0)
    8020457c:	43dc                	lw	a5,4(a5)
    struct proc *p = myproc();
    8020457e:	853e                	mv	a0,a5
    80204580:	70a2                	ld	ra,40(sp)
    80204582:	7402                	ld	s0,32(sp)
    80204584:	6145                	addi	sp,sp,48
    80204586:	8082                	ret

0000000080204588 <exit_proc>:
    p->exit_status = status;
    80204588:	7179                	addi	sp,sp,-48
    8020458a:	f406                	sd	ra,40(sp)
    8020458c:	f022                	sd	s0,32(sp)
    8020458e:	1800                	addi	s0,sp,48
    80204590:	87aa                	mv	a5,a0
    80204592:	fcf42e23          	sw	a5,-36(s0)
    kexit();
    80204596:	00000097          	auipc	ra,0x0
    8020459a:	99a080e7          	jalr	-1638(ra) # 80203f30 <myproc>
    8020459e:	fea43423          	sd	a0,-24(s0)
}
    802045a2:	fe843783          	ld	a5,-24(s0)
    802045a6:	fdc42703          	lw	a4,-36(s0)
    802045aa:	08e7a223          	sw	a4,132(a5)

    802045ae:	00000097          	auipc	ra,0x0
    802045b2:	390080e7          	jalr	912(ra) # 8020493e <kexit>
int wait_proc(int *status) {
    802045b6:	0001                	nop
    802045b8:	70a2                	ld	ra,40(sp)
    802045ba:	7402                	ld	s0,32(sp)
    802045bc:	6145                	addi	sp,sp,48
    802045be:	8082                	ret

00000000802045c0 <wait_proc>:
}
    802045c0:	1101                	addi	sp,sp,-32
    802045c2:	ec06                	sd	ra,24(sp)
    802045c4:	e822                	sd	s0,16(sp)
    802045c6:	1000                	addi	s0,sp,32
    802045c8:	fea43423          	sd	a0,-24(s0)
int kfork(void) {
    802045cc:	fe843503          	ld	a0,-24(s0)
    802045d0:	00000097          	auipc	ra,0x0
    802045d4:	42e080e7          	jalr	1070(ra) # 802049fe <kwait>
    802045d8:	87aa                	mv	a5,a0
    struct proc *parent = myproc();
    802045da:	853e                	mv	a0,a5
    802045dc:	60e2                	ld	ra,24(sp)
    802045de:	6442                	ld	s0,16(sp)
    802045e0:	6105                	addi	sp,sp,32
    802045e2:	8082                	ret

00000000802045e4 <kfork>:
    struct proc *child = alloc_proc();
    802045e4:	1101                	addi	sp,sp,-32
    802045e6:	ec06                	sd	ra,24(sp)
    802045e8:	e822                	sd	s0,16(sp)
    802045ea:	1000                	addi	s0,sp,32
    if(child == 0)
    802045ec:	00000097          	auipc	ra,0x0
    802045f0:	944080e7          	jalr	-1724(ra) # 80203f30 <myproc>
    802045f4:	fea43423          	sd	a0,-24(s0)
        return -1;
    802045f8:	00000097          	auipc	ra,0x0
    802045fc:	cf6080e7          	jalr	-778(ra) # 802042ee <alloc_proc>
    80204600:	fea43023          	sd	a0,-32(s0)

    80204604:	fe043783          	ld	a5,-32(s0)
    80204608:	e399                	bnez	a5,8020460e <kfork+0x2a>
    if(uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0){
    8020460a:	57fd                	li	a5,-1
    8020460c:	a059                	j	80204692 <kfork+0xae>
        return -1;
    8020460e:	fe843783          	ld	a5,-24(s0)
    80204612:	7fd8                	ld	a4,184(a5)
    80204614:	fe043783          	ld	a5,-32(s0)
    80204618:	7fd4                	ld	a3,184(a5)
    8020461a:	fe843783          	ld	a5,-24(s0)
    8020461e:	7bdc                	ld	a5,176(a5)
    80204620:	863e                	mv	a2,a5
    80204622:	85b6                	mv	a1,a3
    80204624:	853a                	mv	a0,a4
    80204626:	ffffe097          	auipc	ra,0xffffe
    8020462a:	2bc080e7          	jalr	700(ra) # 802028e2 <uvmcopy>
    8020462e:	87aa                	mv	a5,a0
    80204630:	0007da63          	bgez	a5,80204644 <kfork+0x60>
    }
    80204634:	fe043503          	ld	a0,-32(s0)
    80204638:	00000097          	auipc	ra,0x0
    8020463c:	e28080e7          	jalr	-472(ra) # 80204460 <free_proc>
    child->sz = parent->sz;
    80204640:	57fd                	li	a5,-1
    80204642:	a881                	j	80204692 <kfork+0xae>
    *(child->trapframe) = *(parent->trapframe);
    80204644:	fe843783          	ld	a5,-24(s0)
    80204648:	7bd8                	ld	a4,176(a5)
    8020464a:	fe043783          	ld	a5,-32(s0)
    8020464e:	fbd8                	sd	a4,176(a5)
    child->state = RUNNABLE;
    80204650:	fe843783          	ld	a5,-24(s0)
    80204654:	63f8                	ld	a4,192(a5)
    80204656:	fe043783          	ld	a5,-32(s0)
    8020465a:	63fc                	ld	a5,192(a5)
    8020465c:	86be                	mv	a3,a5
    8020465e:	12000793          	li	a5,288
    80204662:	863e                	mv	a2,a5
    80204664:	85ba                	mv	a1,a4
    80204666:	8536                	mv	a0,a3
    80204668:	ffffd097          	auipc	ra,0xffffd
    8020466c:	618080e7          	jalr	1560(ra) # 80201c80 <memcpy>
    child->parent = parent;
    80204670:	fe043783          	ld	a5,-32(s0)
    80204674:	63fc                	ld	a5,192(a5)
    80204676:	0607b823          	sd	zero,112(a5)
    return child->pid;
    8020467a:	fe043783          	ld	a5,-32(s0)
    8020467e:	470d                	li	a4,3
    80204680:	c398                	sw	a4,0(a5)
}
    80204682:	fe043783          	ld	a5,-32(s0)
    80204686:	fe843703          	ld	a4,-24(s0)
    8020468a:	efd8                	sd	a4,152(a5)

    8020468c:	fe043783          	ld	a5,-32(s0)
    80204690:	43dc                	lw	a5,4(a5)
// 调度器 - 简化版
    80204692:	853e                	mv	a0,a5
    80204694:	60e2                	ld	ra,24(sp)
    80204696:	6442                	ld	s0,16(sp)
    80204698:	6105                	addi	sp,sp,32
    8020469a:	8082                	ret

000000008020469c <schedule>:
  struct cpu *c = mycpu();
    8020469c:	7179                	addi	sp,sp,-48
    8020469e:	f406                	sd	ra,40(sp)
    802046a0:	f022                	sd	s0,32(sp)
    802046a2:	1800                	addi	s0,sp,48
  if (!initialized) {
    802046a4:	00000097          	auipc	ra,0x0
    802046a8:	8a4080e7          	jalr	-1884(ra) # 80203f48 <mycpu>
    802046ac:	fea43423          	sd	a0,-24(s0)
    if(c == 0) {
    802046b0:	00008797          	auipc	a5,0x8
    802046b4:	d9878793          	addi	a5,a5,-616 # 8020c448 <initialized.0>
    802046b8:	439c                	lw	a5,0(a5)
    802046ba:	ef85                	bnez	a5,802046f2 <schedule+0x56>
    }
    802046bc:	fe843783          	ld	a5,-24(s0)
    802046c0:	eb89                	bnez	a5,802046d2 <schedule+0x36>
    c->proc = 0;
    802046c2:	00003517          	auipc	a0,0x3
    802046c6:	6d650513          	addi	a0,a0,1750 # 80207d98 <small_numbers+0x19a8>
    802046ca:	ffffd097          	auipc	ra,0xffffd
    802046ce:	d6c080e7          	jalr	-660(ra) # 80201436 <panic>
    initialized = 1;
    802046d2:	fe843783          	ld	a5,-24(s0)
    802046d6:	0007b023          	sd	zero,0(a5)
  }
    802046da:	00006797          	auipc	a5,0x6
    802046de:	9b678793          	addi	a5,a5,-1610 # 8020a090 <current_proc>
    802046e2:	0007b023          	sd	zero,0(a5)
  
    802046e6:	00008797          	auipc	a5,0x8
    802046ea:	d6278793          	addi	a5,a5,-670 # 8020c448 <initialized.0>
    802046ee:	4705                	li	a4,1
    802046f0:	c398                	sw	a4,0(a5)
        struct proc *p = proc_table[i];
    802046f2:	fffff097          	auipc	ra,0xfffff
    802046f6:	75c080e7          	jalr	1884(ra) # 80203e4e <intr_on>
      	if(p->state == RUNNABLE) {
    802046fa:	fe042223          	sw	zero,-28(s0)
    802046fe:	a069                	j	80204788 <schedule+0xec>
			p->state = RUNNING;
    80204700:	00006717          	auipc	a4,0x6
    80204704:	cc070713          	addi	a4,a4,-832 # 8020a3c0 <proc_table>
    80204708:	fe442783          	lw	a5,-28(s0)
    8020470c:	078e                	slli	a5,a5,0x3
    8020470e:	97ba                	add	a5,a5,a4
    80204710:	639c                	ld	a5,0(a5)
    80204712:	fcf43c23          	sd	a5,-40(s0)
			c->proc = p;
    80204716:	fd843783          	ld	a5,-40(s0)
    8020471a:	439c                	lw	a5,0(a5)
    8020471c:	873e                	mv	a4,a5
    8020471e:	478d                	li	a5,3
    80204720:	04f71f63          	bne	a4,a5,8020477e <schedule+0xe2>
			current_proc = p;
    80204724:	fd843783          	ld	a5,-40(s0)
    80204728:	4711                	li	a4,4
    8020472a:	c398                	sw	a4,0(a5)
			swtch(&c->context, &p->context);
    8020472c:	fe843783          	ld	a5,-24(s0)
    80204730:	fd843703          	ld	a4,-40(s0)
    80204734:	e398                	sd	a4,0(a5)
			c = mycpu();
    80204736:	00006797          	auipc	a5,0x6
    8020473a:	95a78793          	addi	a5,a5,-1702 # 8020a090 <current_proc>
    8020473e:	fd843703          	ld	a4,-40(s0)
    80204742:	e398                	sd	a4,0(a5)
			c->proc = 0;
    80204744:	fe843783          	ld	a5,-24(s0)
    80204748:	00878713          	addi	a4,a5,8
    8020474c:	fd843783          	ld	a5,-40(s0)
    80204750:	07c1                	addi	a5,a5,16
    80204752:	85be                	mv	a1,a5
    80204754:	853a                	mv	a0,a4
    80204756:	fffff097          	auipc	ra,0xfffff
    8020475a:	65a080e7          	jalr	1626(ra) # 80203db0 <swtch>
			current_proc = 0;
    8020475e:	fffff097          	auipc	ra,0xfffff
    80204762:	7ea080e7          	jalr	2026(ra) # 80203f48 <mycpu>
    80204766:	fea43423          	sd	a0,-24(s0)
      }
    8020476a:	fe843783          	ld	a5,-24(s0)
    8020476e:	0007b023          	sd	zero,0(a5)
    }
    80204772:	00006797          	auipc	a5,0x6
    80204776:	91e78793          	addi	a5,a5,-1762 # 8020a090 <current_proc>
    8020477a:	0007b023          	sd	zero,0(a5)
      	if(p->state == RUNNABLE) {
    8020477e:	fe442783          	lw	a5,-28(s0)
    80204782:	2785                	addiw	a5,a5,1
    80204784:	fef42223          	sw	a5,-28(s0)
    80204788:	fe442783          	lw	a5,-28(s0)
    8020478c:	0007871b          	sext.w	a4,a5
    80204790:	1ff00793          	li	a5,511
    80204794:	f6e7d6e3          	bge	a5,a4,80204700 <schedule+0x64>
        struct proc *p = proc_table[i];
    80204798:	bfa9                	j	802046f2 <schedule+0x56>

000000008020479a <yield>:
    if (p == 0) {
    8020479a:	1101                	addi	sp,sp,-32
    8020479c:	ec06                	sd	ra,24(sp)
    8020479e:	e822                	sd	s0,16(sp)
    802047a0:	1000                	addi	s0,sp,32
        return;
    802047a2:	fffff097          	auipc	ra,0xfffff
    802047a6:	78e080e7          	jalr	1934(ra) # 80203f30 <myproc>
    802047aa:	fea43423          	sd	a0,-24(s0)
    }
    802047ae:	fe843783          	ld	a5,-24(s0)
    802047b2:	c7cd                	beqz	a5,8020485c <yield+0xc2>
        return;
    802047b4:	fe843783          	ld	a5,-24(s0)
    802047b8:	439c                	lw	a5,0(a5)
    802047ba:	873e                	mv	a4,a5
    802047bc:	4791                	li	a5,4
    802047be:	00f70f63          	beq	a4,a5,802047dc <yield+0x42>
    }
    802047c2:	fe843783          	ld	a5,-24(s0)
    802047c6:	439c                	lw	a5,0(a5)
    802047c8:	85be                	mv	a1,a5
    802047ca:	00003517          	auipc	a0,0x3
    802047ce:	5ee50513          	addi	a0,a0,1518 # 80207db8 <small_numbers+0x19c8>
    802047d2:	ffffd097          	auipc	ra,0xffffd
    802047d6:	c98080e7          	jalr	-872(ra) # 8020146a <warning>
    
    802047da:	a051                	j	8020485e <yield+0xc4>
    // 获取当前CPU
    802047dc:	fffff097          	auipc	ra,0xfffff
    802047e0:	69c080e7          	jalr	1692(ra) # 80203e78 <intr_off>
    // 设置进程状态为RUNNABLE
    802047e4:	fffff097          	auipc	ra,0xfffff
    802047e8:	764080e7          	jalr	1892(ra) # 80203f48 <mycpu>
    802047ec:	fea43023          	sd	a0,-32(s0)
    // 获取当前返回地址
    802047f0:	fe843783          	ld	a5,-24(s0)
    802047f4:	470d                	li	a4,3
    802047f6:	c398                	sw	a4,0(a5)
    if (c->context.ra == 0) {
    802047f8:	8706                	mv	a4,ra
    802047fa:	fe843783          	ld	a5,-24(s0)
    802047fe:	eb98                	sd	a4,16(a5)
        c->context.sp = (uint64)c + PGSIZE;
    80204800:	fe043783          	ld	a5,-32(s0)
    80204804:	679c                	ld	a5,8(a5)
    80204806:	ef99                	bnez	a5,80204824 <yield+0x8a>
    }
    80204808:	00000717          	auipc	a4,0x0
    8020480c:	e9470713          	addi	a4,a4,-364 # 8020469c <schedule>
    80204810:	fe043783          	ld	a5,-32(s0)
    80204814:	e798                	sd	a4,8(a5)
    
    80204816:	fe043703          	ld	a4,-32(s0)
    8020481a:	6785                	lui	a5,0x1
    8020481c:	973e                	add	a4,a4,a5
    8020481e:	fe043783          	ld	a5,-32(s0)
    80204822:	eb98                	sd	a4,16(a5)
    
    80204824:	00006797          	auipc	a5,0x6
    80204828:	86c78793          	addi	a5,a5,-1940 # 8020a090 <current_proc>
    8020482c:	0007b023          	sd	zero,0(a5)
    // 直接进行上下文切换
    80204830:	fe043783          	ld	a5,-32(s0)
    80204834:	0007b023          	sd	zero,0(a5)
    intr_on();
    80204838:	fe843783          	ld	a5,-24(s0)
    8020483c:	01078713          	addi	a4,a5,16
    80204840:	fe043783          	ld	a5,-32(s0)
    80204844:	07a1                	addi	a5,a5,8
    80204846:	85be                	mv	a1,a5
    80204848:	853a                	mv	a0,a4
    8020484a:	fffff097          	auipc	ra,0xfffff
    8020484e:	566080e7          	jalr	1382(ra) # 80203db0 <swtch>
void sleep(void *chan){
    80204852:	fffff097          	auipc	ra,0xfffff
    80204856:	5fc080e7          	jalr	1532(ra) # 80203e4e <intr_on>
    8020485a:	a011                	j	8020485e <yield+0xc4>
    
    8020485c:	0001                	nop
    struct proc *p = myproc();
    8020485e:	60e2                	ld	ra,24(sp)
    80204860:	6442                	ld	s0,16(sp)
    80204862:	6105                	addi	sp,sp,32
    80204864:	8082                	ret

0000000080204866 <sleep>:
    struct cpu *c = mycpu();
    80204866:	7179                	addi	sp,sp,-48
    80204868:	f406                	sd	ra,40(sp)
    8020486a:	f022                	sd	s0,32(sp)
    8020486c:	1800                	addi	s0,sp,48
    8020486e:	fca43c23          	sd	a0,-40(s0)
    
    80204872:	fffff097          	auipc	ra,0xfffff
    80204876:	6be080e7          	jalr	1726(ra) # 80203f30 <myproc>
    8020487a:	fea43423          	sd	a0,-24(s0)
    // 获取当前返回地址，确保唤醒后能回到正确位置
    8020487e:	fffff097          	auipc	ra,0xfffff
    80204882:	6ca080e7          	jalr	1738(ra) # 80203f48 <mycpu>
    80204886:	fea43023          	sd	a0,-32(s0)
    p->state = SLEEPING;
    8020488a:	8706                	mv	a4,ra
    8020488c:	fe843783          	ld	a5,-24(s0)
    80204890:	eb98                	sd	a4,16(a5)
    
    80204892:	fe843783          	ld	a5,-24(s0)
    80204896:	fd843703          	ld	a4,-40(s0)
    8020489a:	f3d8                	sd	a4,160(a5)
    // 直接进行上下文切换
    8020489c:	fe843783          	ld	a5,-24(s0)
    802048a0:	4709                	li	a4,2
    802048a2:	c398                	sw	a4,0(a5)
    p->chan = 0;  // 显式清除通道标记
    802048a4:	fe843783          	ld	a5,-24(s0)
    802048a8:	01078713          	addi	a4,a5,16
    802048ac:	fe043783          	ld	a5,-32(s0)
    802048b0:	07a1                	addi	a5,a5,8
    802048b2:	85be                	mv	a1,a5
    802048b4:	853a                	mv	a0,a4
    802048b6:	fffff097          	auipc	ra,0xfffff
    802048ba:	4fa080e7          	jalr	1274(ra) # 80203db0 <swtch>
void wakeup(void *chan) {
    802048be:	fe843783          	ld	a5,-24(s0)
    802048c2:	0a07b023          	sd	zero,160(a5)
    for(int i = 0; i < PROC; i++) {
    802048c6:	0001                	nop
    802048c8:	70a2                	ld	ra,40(sp)
    802048ca:	7402                	ld	s0,32(sp)
    802048cc:	6145                	addi	sp,sp,48
    802048ce:	8082                	ret

00000000802048d0 <wakeup>:
        struct proc *p = proc_table[i];
    802048d0:	7179                	addi	sp,sp,-48
    802048d2:	f422                	sd	s0,40(sp)
    802048d4:	1800                	addi	s0,sp,48
    802048d6:	fca43c23          	sd	a0,-40(s0)
        if(p->state == SLEEPING && p->chan == chan) {
    802048da:	fe042623          	sw	zero,-20(s0)
    802048de:	a099                	j	80204924 <wakeup+0x54>
            p->state = RUNNABLE;
    802048e0:	00006717          	auipc	a4,0x6
    802048e4:	ae070713          	addi	a4,a4,-1312 # 8020a3c0 <proc_table>
    802048e8:	fec42783          	lw	a5,-20(s0)
    802048ec:	078e                	slli	a5,a5,0x3
    802048ee:	97ba                	add	a5,a5,a4
    802048f0:	639c                	ld	a5,0(a5)
    802048f2:	fef43023          	sd	a5,-32(s0)
        }
    802048f6:	fe043783          	ld	a5,-32(s0)
    802048fa:	439c                	lw	a5,0(a5)
    802048fc:	873e                	mv	a4,a5
    802048fe:	4789                	li	a5,2
    80204900:	00f71d63          	bne	a4,a5,8020491a <wakeup+0x4a>
    80204904:	fe043783          	ld	a5,-32(s0)
    80204908:	73dc                	ld	a5,160(a5)
    8020490a:	fd843703          	ld	a4,-40(s0)
    8020490e:	00f71663          	bne	a4,a5,8020491a <wakeup+0x4a>
    }
    80204912:	fe043783          	ld	a5,-32(s0)
    80204916:	470d                	li	a4,3
    80204918:	c398                	sw	a4,0(a5)
        if(p->state == SLEEPING && p->chan == chan) {
    8020491a:	fec42783          	lw	a5,-20(s0)
    8020491e:	2785                	addiw	a5,a5,1
    80204920:	fef42623          	sw	a5,-20(s0)
    80204924:	fec42783          	lw	a5,-20(s0)
    80204928:	0007871b          	sext.w	a4,a5
    8020492c:	1ff00793          	li	a5,511
    80204930:	fae7d8e3          	bge	a5,a4,802048e0 <wakeup+0x10>
    struct proc *p = myproc();
    80204934:	0001                	nop
    80204936:	0001                	nop
    80204938:	7422                	ld	s0,40(sp)
    8020493a:	6145                	addi	sp,sp,48
    8020493c:	8082                	ret

000000008020493e <kexit>:
    
    8020493e:	1101                	addi	sp,sp,-32
    80204940:	ec06                	sd	ra,24(sp)
    80204942:	e822                	sd	s0,16(sp)
    80204944:	1000                	addi	s0,sp,32
    if (p == 0) {
    80204946:	fffff097          	auipc	ra,0xfffff
    8020494a:	5ea080e7          	jalr	1514(ra) # 80203f30 <myproc>
    8020494e:	fea43423          	sd	a0,-24(s0)
    }
    80204952:	fe843783          	ld	a5,-24(s0)
    80204956:	eb89                	bnez	a5,80204968 <kexit+0x2a>
    
    80204958:	00003517          	auipc	a0,0x3
    8020495c:	48850513          	addi	a0,a0,1160 # 80207de0 <small_numbers+0x19f0>
    80204960:	ffffd097          	auipc	ra,0xffffd
    80204964:	ad6080e7          	jalr	-1322(ra) # 80201436 <panic>
	}
    80204968:	fe843783          	ld	a5,-24(s0)
    8020496c:	6fdc                	ld	a5,152(a5)
    8020496e:	e789                	bnez	a5,80204978 <kexit+0x3a>
    
    80204970:	fffff097          	auipc	ra,0xfffff
    80204974:	596080e7          	jalr	1430(ra) # 80203f06 <shutdown>
    // 使用父进程自身地址作为通道标识
    80204978:	fe843783          	ld	a5,-24(s0)
    8020497c:	4715                	li	a4,5
    8020497e:	c398                	sw	a4,0(a5)
    if (p->parent->state == SLEEPING && p->parent->chan == chan) {
    80204980:	fe843783          	ld	a5,-24(s0)
    80204984:	6fdc                	ld	a5,152(a5)
    80204986:	fef43023          	sd	a5,-32(s0)
    }
    8020498a:	fe843783          	ld	a5,-24(s0)
    8020498e:	6fdc                	ld	a5,152(a5)
    80204990:	439c                	lw	a5,0(a5)
    80204992:	873e                	mv	a4,a5
    80204994:	4789                	li	a5,2
    80204996:	02f71063          	bne	a4,a5,802049b6 <kexit+0x78>
    8020499a:	fe843783          	ld	a5,-24(s0)
    8020499e:	6fdc                	ld	a5,152(a5)
    802049a0:	73dc                	ld	a5,160(a5)
    802049a2:	fe043703          	ld	a4,-32(s0)
    802049a6:	00f71863          	bne	a4,a5,802049b6 <kexit+0x78>
    
    802049aa:	fe043503          	ld	a0,-32(s0)
    802049ae:	00000097          	auipc	ra,0x0
    802049b2:	f22080e7          	jalr	-222(ra) # 802048d0 <wakeup>
        mycpu()->proc = 0;
    802049b6:	00005797          	auipc	a5,0x5
    802049ba:	6da78793          	addi	a5,a5,1754 # 8020a090 <current_proc>
    802049be:	0007b023          	sd	zero,0(a5)
        
    802049c2:	fffff097          	auipc	ra,0xfffff
    802049c6:	586080e7          	jalr	1414(ra) # 80203f48 <mycpu>
    802049ca:	87aa                	mv	a5,a0
    802049cc:	cb81                	beqz	a5,802049dc <kexit+0x9e>
    schedule();
    802049ce:	fffff097          	auipc	ra,0xfffff
    802049d2:	57a080e7          	jalr	1402(ra) # 80203f48 <mycpu>
    802049d6:	87aa                	mv	a5,a0
    802049d8:	0007b023          	sd	zero,0(a5)
    panic("kexit should not return after schedule");
    802049dc:	00000097          	auipc	ra,0x0
    802049e0:	cc0080e7          	jalr	-832(ra) # 8020469c <schedule>
int kwait(int *status) {
    802049e4:	00003517          	auipc	a0,0x3
    802049e8:	41c50513          	addi	a0,a0,1052 # 80207e00 <small_numbers+0x1a10>
    802049ec:	ffffd097          	auipc	ra,0xffffd
    802049f0:	a4a080e7          	jalr	-1462(ra) # 80201436 <panic>
    struct proc *p = myproc();
    802049f4:	0001                	nop
    802049f6:	60e2                	ld	ra,24(sp)
    802049f8:	6442                	ld	s0,16(sp)
    802049fa:	6105                	addi	sp,sp,32
    802049fc:	8082                	ret

00000000802049fe <kwait>:
    
    802049fe:	7159                	addi	sp,sp,-112
    80204a00:	f486                	sd	ra,104(sp)
    80204a02:	f0a2                	sd	s0,96(sp)
    80204a04:	1880                	addi	s0,sp,112
    80204a06:	f8a43c23          	sd	a0,-104(s0)
    if (p == 0) {
    80204a0a:	fffff097          	auipc	ra,0xfffff
    80204a0e:	526080e7          	jalr	1318(ra) # 80203f30 <myproc>
    80204a12:	fca43023          	sd	a0,-64(s0)
        return -1;
    80204a16:	fc043783          	ld	a5,-64(s0)
    80204a1a:	eb99                	bnez	a5,80204a30 <kwait+0x32>
    }
    80204a1c:	00003517          	auipc	a0,0x3
    80204a20:	40c50513          	addi	a0,a0,1036 # 80207e28 <small_numbers+0x1a38>
    80204a24:	ffffc097          	auipc	ra,0xffffc
    80204a28:	10a080e7          	jalr	266(ra) # 80200b2e <printf>
    
    80204a2c:	57fd                	li	a5,-1
    80204a2e:	aa45                	j	80204bde <kwait+0x1e0>
        // 优先检查是否有僵尸子进程
    80204a30:	fffff097          	auipc	ra,0xfffff
    80204a34:	448080e7          	jalr	1096(ra) # 80203e78 <intr_off>
        int zombie_status = 0;
    80204a38:	fe042623          	sw	zero,-20(s0)
        struct proc *zombie_child = 0;
    80204a3c:	fe042423          	sw	zero,-24(s0)
        
    80204a40:	fe042223          	sw	zero,-28(s0)
        // 先查找ZOMBIE状态的子进程
    80204a44:	fc043c23          	sd	zero,-40(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    80204a48:	fc042a23          	sw	zero,-44(s0)
    80204a4c:	a095                	j	80204ab0 <kwait+0xb2>
                found_zombie = 1;
    80204a4e:	00006717          	auipc	a4,0x6
    80204a52:	97270713          	addi	a4,a4,-1678 # 8020a3c0 <proc_table>
    80204a56:	fd442783          	lw	a5,-44(s0)
    80204a5a:	078e                	slli	a5,a5,0x3
    80204a5c:	97ba                	add	a5,a5,a4
    80204a5e:	639c                	ld	a5,0(a5)
    80204a60:	faf43c23          	sd	a5,-72(s0)
                zombie_pid = child->pid;
    80204a64:	fb843783          	ld	a5,-72(s0)
    80204a68:	439c                	lw	a5,0(a5)
    80204a6a:	873e                	mv	a4,a5
    80204a6c:	4795                	li	a5,5
    80204a6e:	02f71c63          	bne	a4,a5,80204aa6 <kwait+0xa8>
    80204a72:	fb843783          	ld	a5,-72(s0)
    80204a76:	6fdc                	ld	a5,152(a5)
    80204a78:	fc043703          	ld	a4,-64(s0)
    80204a7c:	02f71563          	bne	a4,a5,80204aa6 <kwait+0xa8>
                zombie_status = child->exit_status;
    80204a80:	4785                	li	a5,1
    80204a82:	fef42623          	sw	a5,-20(s0)
                zombie_child = child;
    80204a86:	fb843783          	ld	a5,-72(s0)
    80204a8a:	43dc                	lw	a5,4(a5)
    80204a8c:	fef42423          	sw	a5,-24(s0)
                break;
    80204a90:	fb843783          	ld	a5,-72(s0)
    80204a94:	0847a783          	lw	a5,132(a5)
    80204a98:	fef42223          	sw	a5,-28(s0)
            }
    80204a9c:	fb843783          	ld	a5,-72(s0)
    80204aa0:	fcf43c23          	sd	a5,-40(s0)
        }
    80204aa4:	a831                	j	80204ac0 <kwait+0xc2>
            if (child->state == ZOMBIE && child->parent == p) {
    80204aa6:	fd442783          	lw	a5,-44(s0)
    80204aaa:	2785                	addiw	a5,a5,1
    80204aac:	fcf42a23          	sw	a5,-44(s0)
    80204ab0:	fd442783          	lw	a5,-44(s0)
    80204ab4:	0007871b          	sext.w	a4,a5
    80204ab8:	1ff00793          	li	a5,511
    80204abc:	f8e7d9e3          	bge	a5,a4,80204a4e <kwait+0x50>
                *status = zombie_status;
    80204ac0:	fec42783          	lw	a5,-20(s0)
    80204ac4:	2781                	sext.w	a5,a5
    80204ac6:	cb85                	beqz	a5,80204af6 <kwait+0xf8>

    80204ac8:	f9843783          	ld	a5,-104(s0)
    80204acc:	c791                	beqz	a5,80204ad8 <kwait+0xda>
            free_proc(zombie_child);
    80204ace:	f9843783          	ld	a5,-104(s0)
    80204ad2:	fe442703          	lw	a4,-28(s0)
    80204ad6:	c398                	sw	a4,0(a5)
            intr_on();
    80204ad8:	fd843503          	ld	a0,-40(s0)
    80204adc:	00000097          	auipc	ra,0x0
    80204ae0:	984080e7          	jalr	-1660(ra) # 80204460 <free_proc>
            return zombie_pid;
    80204ae4:	fc043c23          	sd	zero,-40(s0)
        }
    80204ae8:	fffff097          	auipc	ra,0xfffff
    80204aec:	366080e7          	jalr	870(ra) # 80203e4e <intr_on>
        
    80204af0:	fe842783          	lw	a5,-24(s0)
    80204af4:	a0ed                	j	80204bde <kwait+0x1e0>
            struct proc *child = proc_table[i];
    80204af6:	fc042823          	sw	zero,-48(s0)
            if (child->state != UNUSED && child->parent == p) {
    80204afa:	fc042623          	sw	zero,-52(s0)
    80204afe:	a83d                	j	80204b3c <kwait+0x13e>
                havekids = 1;
    80204b00:	00006717          	auipc	a4,0x6
    80204b04:	8c070713          	addi	a4,a4,-1856 # 8020a3c0 <proc_table>
    80204b08:	fcc42783          	lw	a5,-52(s0)
    80204b0c:	078e                	slli	a5,a5,0x3
    80204b0e:	97ba                	add	a5,a5,a4
    80204b10:	639c                	ld	a5,0(a5)
    80204b12:	faf43023          	sd	a5,-96(s0)
            }
    80204b16:	fa043783          	ld	a5,-96(s0)
    80204b1a:	439c                	lw	a5,0(a5)
    80204b1c:	cb99                	beqz	a5,80204b32 <kwait+0x134>
    80204b1e:	fa043783          	ld	a5,-96(s0)
    80204b22:	6fdc                	ld	a5,152(a5)
    80204b24:	fc043703          	ld	a4,-64(s0)
    80204b28:	00f71563          	bne	a4,a5,80204b32 <kwait+0x134>
        }
    80204b2c:	4785                	li	a5,1
    80204b2e:	fcf42823          	sw	a5,-48(s0)
            if (child->state != UNUSED && child->parent == p) {
    80204b32:	fcc42783          	lw	a5,-52(s0)
    80204b36:	2785                	addiw	a5,a5,1
    80204b38:	fcf42623          	sw	a5,-52(s0)
    80204b3c:	fcc42783          	lw	a5,-52(s0)
    80204b40:	0007871b          	sext.w	a4,a5
    80204b44:	1ff00793          	li	a5,511
    80204b48:	fae7dce3          	bge	a5,a4,80204b00 <kwait+0x102>
        
        if (!havekids) {
            intr_on();
            return -1;
    80204b4c:	fd042783          	lw	a5,-48(s0)
    80204b50:	2781                	sext.w	a5,a5
    80204b52:	e799                	bnez	a5,80204b60 <kwait+0x162>
        }
    80204b54:	fffff097          	auipc	ra,0xfffff
    80204b58:	2fa080e7          	jalr	762(ra) # 80203e4e <intr_on>
        void *wait_chan = (void*)p;
    80204b5c:	57fd                	li	a5,-1
    80204b5e:	a041                	j	80204bde <kwait+0x1e0>
		register uint64 ra asm("ra");
		p->context.ra = ra;
    80204b60:	fc043783          	ld	a5,-64(s0)
    80204b64:	faf43823          	sd	a5,-80(s0)
        p->chan = wait_chan;
        p->state = SLEEPING;
    80204b68:	8706                	mv	a4,ra
    80204b6a:	fc043783          	ld	a5,-64(s0)
    80204b6e:	eb98                	sd	a4,16(a5)
        
    80204b70:	fc043783          	ld	a5,-64(s0)
    80204b74:	fb043703          	ld	a4,-80(s0)
    80204b78:	f3d8                	sd	a4,160(a5)
		struct cpu *c = mycpu();
    80204b7a:	fc043783          	ld	a5,-64(s0)
    80204b7e:	4709                	li	a4,2
    80204b80:	c398                	sw	a4,0(a5)
		current_proc = 0;
		c->proc = 0;
    80204b82:	fffff097          	auipc	ra,0xfffff
    80204b86:	3c6080e7          	jalr	966(ra) # 80203f48 <mycpu>
    80204b8a:	faa43423          	sd	a0,-88(s0)
        // 在睡眠前确保中断是开启的
    80204b8e:	00005797          	auipc	a5,0x5
    80204b92:	50278793          	addi	a5,a5,1282 # 8020a090 <current_proc>
    80204b96:	0007b023          	sd	zero,0(a5)
        intr_on();
    80204b9a:	fa843783          	ld	a5,-88(s0)
    80204b9e:	0007b023          	sd	zero,0(a5)
        swtch(&p->context,&c->context);
        intr_off();
    80204ba2:	fffff097          	auipc	ra,0xfffff
    80204ba6:	2ac080e7          	jalr	684(ra) # 80203e4e <intr_on>
        p->state = RUNNING;
    80204baa:	fc043783          	ld	a5,-64(s0)
    80204bae:	01078713          	addi	a4,a5,16
    80204bb2:	fa843783          	ld	a5,-88(s0)
    80204bb6:	07a1                	addi	a5,a5,8
    80204bb8:	85be                	mv	a1,a5
    80204bba:	853a                	mv	a0,a4
    80204bbc:	fffff097          	auipc	ra,0xfffff
    80204bc0:	1f4080e7          	jalr	500(ra) # 80203db0 <swtch>
        intr_on();
    80204bc4:	fffff097          	auipc	ra,0xfffff
    80204bc8:	2b4080e7          	jalr	692(ra) # 80203e78 <intr_off>
    }
    80204bcc:	fc043783          	ld	a5,-64(s0)
    80204bd0:	4711                	li	a4,4
    80204bd2:	c398                	sw	a4,0(a5)
}
    80204bd4:	fffff097          	auipc	ra,0xfffff
    80204bd8:	27a080e7          	jalr	634(ra) # 80203e4e <intr_on>
        intr_off();
    80204bdc:	bd91                	j	80204a30 <kwait+0x32>

void print_proc_table(void) {
    80204bde:	853e                	mv	a0,a5
    80204be0:	70a6                	ld	ra,104(sp)
    80204be2:	7406                	ld	s0,96(sp)
    80204be4:	6165                	addi	sp,sp,112
    80204be6:	8082                	ret

0000000080204be8 <print_proc_table>:
    int count = 0;
    printf("PID  TYPE STATUS     PPID   FUNC_ADDR      STACK_ADDR    \n");
    80204be8:	1101                	addi	sp,sp,-32
    80204bea:	ec06                	sd	ra,24(sp)
    80204bec:	e822                	sd	s0,16(sp)
    80204bee:	1000                	addi	s0,sp,32
    printf("----------------------------------------------------------\n");
    80204bf0:	fe042623          	sw	zero,-20(s0)
    for(int i = 0; i < PROC; i++) {
        struct proc *p = proc_table[i];
    80204bf4:	00003517          	auipc	a0,0x3
    80204bf8:	26450513          	addi	a0,a0,612 # 80207e58 <small_numbers+0x1a68>
    80204bfc:	ffffc097          	auipc	ra,0xffffc
    80204c00:	f32080e7          	jalr	-206(ra) # 80200b2e <printf>
        if(p->state != UNUSED) {
    80204c04:	00003517          	auipc	a0,0x3
    80204c08:	28c50513          	addi	a0,a0,652 # 80207e90 <small_numbers+0x1aa0>
    80204c0c:	ffffc097          	auipc	ra,0xffffc
    80204c10:	f22080e7          	jalr	-222(ra) # 80200b2e <printf>
            count++;
            const char *type = (p->is_user ? "USR" : "SYS");
    80204c14:	fe042423          	sw	zero,-24(s0)
    80204c18:	a249                	j	80204d9a <print_proc_table+0x1b2>
            const char *status;
    80204c1a:	00005717          	auipc	a4,0x5
    80204c1e:	7a670713          	addi	a4,a4,1958 # 8020a3c0 <proc_table>
    80204c22:	fe842783          	lw	a5,-24(s0)
    80204c26:	078e                	slli	a5,a5,0x3
    80204c28:	97ba                	add	a5,a5,a4
    80204c2a:	639c                	ld	a5,0(a5)
    80204c2c:	fef43023          	sd	a5,-32(s0)
            switch(p->state) {
    80204c30:	fe043783          	ld	a5,-32(s0)
    80204c34:	439c                	lw	a5,0(a5)
    80204c36:	14078d63          	beqz	a5,80204d90 <print_proc_table+0x1a8>
                case UNUSED:   status = "UNUSED"; break;
    80204c3a:	fec42783          	lw	a5,-20(s0)
    80204c3e:	2785                	addiw	a5,a5,1
    80204c40:	fef42623          	sw	a5,-20(s0)
                case USED:     status = "USED"; break;
    80204c44:	fe043783          	ld	a5,-32(s0)
    80204c48:	43dc                	lw	a5,4(a5)
    80204c4a:	85be                	mv	a1,a5
    80204c4c:	00003517          	auipc	a0,0x3
    80204c50:	27450513          	addi	a0,a0,628 # 80207ec0 <small_numbers+0x1ad0>
    80204c54:	ffffc097          	auipc	ra,0xffffc
    80204c58:	eda080e7          	jalr	-294(ra) # 80200b2e <printf>
                case SLEEPING: status = "SLEEP"; break;
                case RUNNABLE: status = "RUNNABLE"; break;
    80204c5c:	fe043783          	ld	a5,-32(s0)
    80204c60:	439c                	lw	a5,0(a5)
    80204c62:	86be                	mv	a3,a5
    80204c64:	4715                	li	a4,5
    80204c66:	08d76863          	bltu	a4,a3,80204cf6 <print_proc_table+0x10e>
    80204c6a:	00279713          	slli	a4,a5,0x2
    80204c6e:	00003797          	auipc	a5,0x3
    80204c72:	30278793          	addi	a5,a5,770 # 80207f70 <small_numbers+0x1b80>
    80204c76:	97ba                	add	a5,a5,a4
    80204c78:	439c                	lw	a5,0(a5)
    80204c7a:	0007871b          	sext.w	a4,a5
    80204c7e:	00003797          	auipc	a5,0x3
    80204c82:	2f278793          	addi	a5,a5,754 # 80207f70 <small_numbers+0x1b80>
    80204c86:	97ba                	add	a5,a5,a4
    80204c88:	8782                	jr	a5
                case RUNNING:  status = "RUNNING"; break;
    80204c8a:	00003517          	auipc	a0,0x3
    80204c8e:	23e50513          	addi	a0,a0,574 # 80207ec8 <small_numbers+0x1ad8>
    80204c92:	ffffc097          	auipc	ra,0xffffc
    80204c96:	e9c080e7          	jalr	-356(ra) # 80200b2e <printf>
    80204c9a:	a89d                	j	80204d10 <print_proc_table+0x128>
                case ZOMBIE:   status = "ZOMBIE"; break;
    80204c9c:	00003517          	auipc	a0,0x3
    80204ca0:	23c50513          	addi	a0,a0,572 # 80207ed8 <small_numbers+0x1ae8>
    80204ca4:	ffffc097          	auipc	ra,0xffffc
    80204ca8:	e8a080e7          	jalr	-374(ra) # 80200b2e <printf>
    80204cac:	a095                	j	80204d10 <print_proc_table+0x128>
                default:       status = "UNKNOWN"; break;
    80204cae:	00003517          	auipc	a0,0x3
    80204cb2:	23a50513          	addi	a0,a0,570 # 80207ee8 <small_numbers+0x1af8>
    80204cb6:	ffffc097          	auipc	ra,0xffffc
    80204cba:	e78080e7          	jalr	-392(ra) # 80200b2e <printf>
    80204cbe:	a889                	j	80204d10 <print_proc_table+0x128>
            }
    80204cc0:	00003517          	auipc	a0,0x3
    80204cc4:	23850513          	addi	a0,a0,568 # 80207ef8 <small_numbers+0x1b08>
    80204cc8:	ffffc097          	auipc	ra,0xffffc
    80204ccc:	e66080e7          	jalr	-410(ra) # 80200b2e <printf>
    80204cd0:	a081                	j	80204d10 <print_proc_table+0x128>
            int ppid = p->parent ? p->parent->pid : -1;
    80204cd2:	00003517          	auipc	a0,0x3
    80204cd6:	23650513          	addi	a0,a0,566 # 80207f08 <small_numbers+0x1b18>
    80204cda:	ffffc097          	auipc	ra,0xffffc
    80204cde:	e54080e7          	jalr	-428(ra) # 80200b2e <printf>
    80204ce2:	a03d                	j	80204d10 <print_proc_table+0x128>
            unsigned long func_addr = p->trapframe ? p->trapframe->epc : 0;
    80204ce4:	00003517          	auipc	a0,0x3
    80204ce8:	23450513          	addi	a0,a0,564 # 80207f18 <small_numbers+0x1b28>
    80204cec:	ffffc097          	auipc	ra,0xffffc
    80204cf0:	e42080e7          	jalr	-446(ra) # 80200b2e <printf>
    80204cf4:	a831                	j	80204d10 <print_proc_table+0x128>
            unsigned long stack_addr = p->kstack;
    80204cf6:	fe043783          	ld	a5,-32(s0)
    80204cfa:	439c                	lw	a5,0(a5)
    80204cfc:	85be                	mv	a1,a5
    80204cfe:	00003517          	auipc	a0,0x3
    80204d02:	22a50513          	addi	a0,a0,554 # 80207f28 <small_numbers+0x1b38>
    80204d06:	ffffc097          	auipc	ra,0xffffc
    80204d0a:	e28080e7          	jalr	-472(ra) # 80200b2e <printf>
    80204d0e:	0001                	nop
            printf("%2d  %3s %8s %4d 0x%012lx 0x%012lx\n",
                p->pid, type, status, ppid, func_addr, stack_addr);
        }
    80204d10:	fe043783          	ld	a5,-32(s0)
    80204d14:	6fdc                	ld	a5,152(a5)
    80204d16:	cf99                	beqz	a5,80204d34 <print_proc_table+0x14c>
    }
    80204d18:	fe043783          	ld	a5,-32(s0)
    80204d1c:	6fdc                	ld	a5,152(a5)
    80204d1e:	43dc                	lw	a5,4(a5)
    80204d20:	85be                	mv	a1,a5
    80204d22:	00003517          	auipc	a0,0x3
    80204d26:	19e50513          	addi	a0,a0,414 # 80207ec0 <small_numbers+0x1ad0>
    80204d2a:	ffffc097          	auipc	ra,0xffffc
    80204d2e:	e04080e7          	jalr	-508(ra) # 80200b2e <printf>
    80204d32:	a809                	j	80204d44 <print_proc_table+0x15c>
    printf("----------------------------------------------------------\n");
    printf("%d active processes\n", count);
    80204d34:	00003517          	auipc	a0,0x3
    80204d38:	20450513          	addi	a0,a0,516 # 80207f38 <small_numbers+0x1b48>
    80204d3c:	ffffc097          	auipc	ra,0xffffc
    80204d40:	df2080e7          	jalr	-526(ra) # 80200b2e <printf>
}
// 简单测试任务，用于测试进程创建
    80204d44:	fe043783          	ld	a5,-32(s0)
    80204d48:	63fc                	ld	a5,192(a5)
    80204d4a:	cf99                	beqz	a5,80204d68 <print_proc_table+0x180>
void simple_task(void) {
    80204d4c:	fe043783          	ld	a5,-32(s0)
    80204d50:	63fc                	ld	a5,192(a5)
    80204d52:	6f9c                	ld	a5,24(a5)
    80204d54:	85be                	mv	a1,a5
    80204d56:	00003517          	auipc	a0,0x3
    80204d5a:	1f250513          	addi	a0,a0,498 # 80207f48 <small_numbers+0x1b58>
    80204d5e:	ffffc097          	auipc	ra,0xffffc
    80204d62:	dd0080e7          	jalr	-560(ra) # 80200b2e <printf>
    80204d66:	a809                	j	80204d78 <print_proc_table+0x190>
    // 简单任务，只打印并退出
    printf("Simple task running in PID %d\n", myproc()->pid);
    80204d68:	00003517          	auipc	a0,0x3
    80204d6c:	1d050513          	addi	a0,a0,464 # 80207f38 <small_numbers+0x1b48>
    80204d70:	ffffc097          	auipc	ra,0xffffc
    80204d74:	dbe080e7          	jalr	-578(ra) # 80200b2e <printf>
}
void test_process_creation(void) {
    80204d78:	fe043783          	ld	a5,-32(s0)
    80204d7c:	679c                	ld	a5,8(a5)
    80204d7e:	85be                	mv	a1,a5
    80204d80:	00003517          	auipc	a0,0x3
    80204d84:	1d050513          	addi	a0,a0,464 # 80207f50 <small_numbers+0x1b60>
    80204d88:	ffffc097          	auipc	ra,0xffffc
    80204d8c:	da6080e7          	jalr	-602(ra) # 80200b2e <printf>
            const char *type = (p->is_user ? "USR" : "SYS");
    80204d90:	fe842783          	lw	a5,-24(s0)
    80204d94:	2785                	addiw	a5,a5,1
    80204d96:	fef42423          	sw	a5,-24(s0)
    80204d9a:	fe842783          	lw	a5,-24(s0)
    80204d9e:	0007871b          	sext.w	a4,a5
    80204da2:	1ff00793          	li	a5,511
    80204da6:	e6e7dae3          	bge	a5,a4,80204c1a <print_proc_table+0x32>
    printf("===== 测试开始: 进程创建与管理测试 =====\n");

    // 测试基本的进程创建
    int pid = create_proc(simple_task,1);
    80204daa:	00003517          	auipc	a0,0x3
    80204dae:	0e650513          	addi	a0,a0,230 # 80207e90 <small_numbers+0x1aa0>
    80204db2:	ffffc097          	auipc	ra,0xffffc
    80204db6:	d7c080e7          	jalr	-644(ra) # 80200b2e <printf>
    assert(pid > 0);
    80204dba:	fec42783          	lw	a5,-20(s0)
    80204dbe:	85be                	mv	a1,a5
    80204dc0:	00003517          	auipc	a0,0x3
    80204dc4:	19850513          	addi	a0,a0,408 # 80207f58 <small_numbers+0x1b68>
    80204dc8:	ffffc097          	auipc	ra,0xffffc
    80204dcc:	d66080e7          	jalr	-666(ra) # 80200b2e <printf>
    printf("【测试结果】: 基本进程创建成功，PID: %d，正常退出\n", pid);

    80204dd0:	0001                	nop
    80204dd2:	60e2                	ld	ra,24(sp)
    80204dd4:	6442                	ld	s0,16(sp)
    80204dd6:	6105                	addi	sp,sp,32
    80204dd8:	8082                	ret

0000000080204dda <simple_task>:
    int count = 1;
    printf("\n----- 测试进程表容量限制 -----\n");
    for (int i = 0; i < PROC+5; i++) {// 验证超量创建进程的处理
    80204dda:	1141                	addi	sp,sp,-16
    80204ddc:	e406                	sd	ra,8(sp)
    80204dde:	e022                	sd	s0,0(sp)
    80204de0:	0800                	addi	s0,sp,16
        int pid = create_proc(simple_task,1);
        if (pid > 0) {
    80204de2:	fffff097          	auipc	ra,0xfffff
    80204de6:	14e080e7          	jalr	334(ra) # 80203f30 <myproc>
    80204dea:	87aa                	mv	a5,a0
    80204dec:	43dc                	lw	a5,4(a5)
    80204dee:	85be                	mv	a1,a5
    80204df0:	00003517          	auipc	a0,0x3
    80204df4:	19850513          	addi	a0,a0,408 # 80207f88 <small_numbers+0x1b98>
    80204df8:	ffffc097          	auipc	ra,0xffffc
    80204dfc:	d36080e7          	jalr	-714(ra) # 80200b2e <printf>
            count++; 
    80204e00:	0001                	nop
    80204e02:	60a2                	ld	ra,8(sp)
    80204e04:	6402                	ld	s0,0(sp)
    80204e06:	0141                	addi	sp,sp,16
    80204e08:	8082                	ret

0000000080204e0a <test_process_creation>:
        } else {
    80204e0a:	7139                	addi	sp,sp,-64
    80204e0c:	fc06                	sd	ra,56(sp)
    80204e0e:	f822                	sd	s0,48(sp)
    80204e10:	0080                	addi	s0,sp,64
			warning("process table was full\n");
    80204e12:	00003517          	auipc	a0,0x3
    80204e16:	19650513          	addi	a0,a0,406 # 80207fa8 <small_numbers+0x1bb8>
    80204e1a:	ffffc097          	auipc	ra,0xffffc
    80204e1e:	d14080e7          	jalr	-748(ra) # 80200b2e <printf>
            break;
        }
    }
    80204e22:	00000517          	auipc	a0,0x0
    80204e26:	fb850513          	addi	a0,a0,-72 # 80204dda <simple_task>
    80204e2a:	fffff097          	auipc	ra,0xfffff
    80204e2e:	6e2080e7          	jalr	1762(ra) # 8020450c <create_proc>
    80204e32:	87aa                	mv	a5,a0
    80204e34:	fcf42823          	sw	a5,-48(s0)
    printf("【测试结果】: 成功创建 %d 个进程 (最大限制: %d)\n", count, PROC);
    80204e38:	fd042783          	lw	a5,-48(s0)
    80204e3c:	2781                	sext.w	a5,a5
    80204e3e:	00f027b3          	sgtz	a5,a5
    80204e42:	0ff7f793          	zext.b	a5,a5
    80204e46:	2781                	sext.w	a5,a5
    80204e48:	853e                	mv	a0,a5
    80204e4a:	fffff097          	auipc	ra,0xfffff
    80204e4e:	070080e7          	jalr	112(ra) # 80203eba <assert>
	print_proc_table();
    80204e52:	fd042783          	lw	a5,-48(s0)
    80204e56:	85be                	mv	a1,a5
    80204e58:	00003517          	auipc	a0,0x3
    80204e5c:	18850513          	addi	a0,a0,392 # 80207fe0 <small_numbers+0x1bf0>
    80204e60:	ffffc097          	auipc	ra,0xffffc
    80204e64:	cce080e7          	jalr	-818(ra) # 80200b2e <printf>
    // 清理测试进程
    printf("\n----- 测试进程等待与清理 -----\n");
    80204e68:	4785                	li	a5,1
    80204e6a:	fef42623          	sw	a5,-20(s0)
    int success_count = 0;
    80204e6e:	00003517          	auipc	a0,0x3
    80204e72:	1ba50513          	addi	a0,a0,442 # 80208028 <small_numbers+0x1c38>
    80204e76:	ffffc097          	auipc	ra,0xffffc
    80204e7a:	cb8080e7          	jalr	-840(ra) # 80200b2e <printf>
    for (int i = 0; i < count; i++) {
    80204e7e:	fe042423          	sw	zero,-24(s0)
    80204e82:	a0a9                	j	80204ecc <test_process_creation+0xc2>
        int waited_pid = wait_proc(NULL);
    80204e84:	00000517          	auipc	a0,0x0
    80204e88:	f5650513          	addi	a0,a0,-170 # 80204dda <simple_task>
    80204e8c:	fffff097          	auipc	ra,0xfffff
    80204e90:	680080e7          	jalr	1664(ra) # 8020450c <create_proc>
    80204e94:	87aa                	mv	a5,a0
    80204e96:	fcf42623          	sw	a5,-52(s0)
        if (waited_pid > 0) {
    80204e9a:	fcc42783          	lw	a5,-52(s0)
    80204e9e:	2781                	sext.w	a5,a5
    80204ea0:	00f05863          	blez	a5,80204eb0 <test_process_creation+0xa6>
            success_count++;
    80204ea4:	fec42783          	lw	a5,-20(s0)
    80204ea8:	2785                	addiw	a5,a5,1
    80204eaa:	fef42623          	sw	a5,-20(s0)
    80204eae:	a811                	j	80204ec2 <test_process_creation+0xb8>
        } else {
            printf("【错误】: 等待进程失败，错误码: %d\n", waited_pid);
    80204eb0:	00003517          	auipc	a0,0x3
    80204eb4:	1a850513          	addi	a0,a0,424 # 80208058 <small_numbers+0x1c68>
    80204eb8:	ffffc097          	auipc	ra,0xffffc
    80204ebc:	5b2080e7          	jalr	1458(ra) # 8020146a <warning>
        }
    80204ec0:	a831                	j	80204edc <test_process_creation+0xd2>
    for (int i = 0; i < count; i++) {
    80204ec2:	fe842783          	lw	a5,-24(s0)
    80204ec6:	2785                	addiw	a5,a5,1
    80204ec8:	fef42423          	sw	a5,-24(s0)
    80204ecc:	fe842783          	lw	a5,-24(s0)
    80204ed0:	0007871b          	sext.w	a4,a5
    80204ed4:	20400793          	li	a5,516
    80204ed8:	fae7d6e3          	bge	a5,a4,80204e84 <test_process_creation+0x7a>
    }
    printf("【测试结果】: 回收 %d/%d 个进程\n", success_count, count);
	print_proc_table();
    80204edc:	fec42783          	lw	a5,-20(s0)
    80204ee0:	20000613          	li	a2,512
    80204ee4:	85be                	mv	a1,a5
    80204ee6:	00003517          	auipc	a0,0x3
    80204eea:	18a50513          	addi	a0,a0,394 # 80208070 <small_numbers+0x1c80>
    80204eee:	ffffc097          	auipc	ra,0xffffc
    80204ef2:	c40080e7          	jalr	-960(ra) # 80200b2e <printf>
    // 增强测试：清理后尝试重新创建进程
    80204ef6:	00000097          	auipc	ra,0x0
    80204efa:	cf2080e7          	jalr	-782(ra) # 80204be8 <print_proc_table>
	printf("\n----- 清理后尝试重新填满进程表 -----\n");
	int refill_count = 0;
    80204efe:	00003517          	auipc	a0,0x3
    80204f02:	1ba50513          	addi	a0,a0,442 # 802080b8 <small_numbers+0x1cc8>
    80204f06:	ffffc097          	auipc	ra,0xffffc
    80204f0a:	c28080e7          	jalr	-984(ra) # 80200b2e <printf>
	for (int i = 0; i < PROC; i++) {
    80204f0e:	fe042223          	sw	zero,-28(s0)
		int pid = create_proc(simple_task,1);
    80204f12:	fe042023          	sw	zero,-32(s0)
    80204f16:	a0a1                	j	80204f5e <test_process_creation+0x154>
		if (pid > 0) {
    80204f18:	4501                	li	a0,0
    80204f1a:	fffff097          	auipc	ra,0xfffff
    80204f1e:	6a6080e7          	jalr	1702(ra) # 802045c0 <wait_proc>
    80204f22:	87aa                	mv	a5,a0
    80204f24:	fcf42023          	sw	a5,-64(s0)
			refill_count++;
    80204f28:	fc042783          	lw	a5,-64(s0)
    80204f2c:	2781                	sext.w	a5,a5
    80204f2e:	00f05863          	blez	a5,80204f3e <test_process_creation+0x134>
		} else {
    80204f32:	fe442783          	lw	a5,-28(s0)
    80204f36:	2785                	addiw	a5,a5,1
    80204f38:	fef42223          	sw	a5,-28(s0)
    80204f3c:	a821                	j	80204f54 <test_process_creation+0x14a>
			warning("process table was full\n");
			break;
    80204f3e:	fc042783          	lw	a5,-64(s0)
    80204f42:	85be                	mv	a1,a5
    80204f44:	00003517          	auipc	a0,0x3
    80204f48:	1a450513          	addi	a0,a0,420 # 802080e8 <small_numbers+0x1cf8>
    80204f4c:	ffffc097          	auipc	ra,0xffffc
    80204f50:	be2080e7          	jalr	-1054(ra) # 80200b2e <printf>
		int pid = create_proc(simple_task,1);
    80204f54:	fe042783          	lw	a5,-32(s0)
    80204f58:	2785                	addiw	a5,a5,1
    80204f5a:	fef42023          	sw	a5,-32(s0)
    80204f5e:	fe042783          	lw	a5,-32(s0)
    80204f62:	873e                	mv	a4,a5
    80204f64:	fec42783          	lw	a5,-20(s0)
    80204f68:	2701                	sext.w	a4,a4
    80204f6a:	2781                	sext.w	a5,a5
    80204f6c:	faf746e3          	blt	a4,a5,80204f18 <test_process_creation+0x10e>
		}
	}
	printf("【测试结果】: 清理后成功重新创建 %d 个进程\n", refill_count);
    80204f70:	fec42703          	lw	a4,-20(s0)
    80204f74:	fe442783          	lw	a5,-28(s0)
    80204f78:	863a                	mv	a2,a4
    80204f7a:	85be                	mv	a1,a5
    80204f7c:	00003517          	auipc	a0,0x3
    80204f80:	1a450513          	addi	a0,a0,420 # 80208120 <small_numbers+0x1d30>
    80204f84:	ffffc097          	auipc	ra,0xffffc
    80204f88:	baa080e7          	jalr	-1110(ra) # 80200b2e <printf>
	print_proc_table();
    80204f8c:	00000097          	auipc	ra,0x0
    80204f90:	c5c080e7          	jalr	-932(ra) # 80204be8 <print_proc_table>
	printf("\n----- 测试进程等待与清理 -----\n");
    success_count = 0;
    80204f94:	00003517          	auipc	a0,0x3
    80204f98:	1bc50513          	addi	a0,a0,444 # 80208150 <small_numbers+0x1d60>
    80204f9c:	ffffc097          	auipc	ra,0xffffc
    80204fa0:	b92080e7          	jalr	-1134(ra) # 80200b2e <printf>
    for (int i = 0; i < count; i++) {
    80204fa4:	fc042e23          	sw	zero,-36(s0)
        int waited_pid = wait_proc(NULL);
    80204fa8:	fc042c23          	sw	zero,-40(s0)
    80204fac:	a0a9                	j	80204ff6 <test_process_creation+0x1ec>
        if (waited_pid > 0) {
    80204fae:	00000517          	auipc	a0,0x0
    80204fb2:	e2c50513          	addi	a0,a0,-468 # 80204dda <simple_task>
    80204fb6:	fffff097          	auipc	ra,0xfffff
    80204fba:	556080e7          	jalr	1366(ra) # 8020450c <create_proc>
    80204fbe:	87aa                	mv	a5,a0
    80204fc0:	fcf42423          	sw	a5,-56(s0)
            success_count++;
    80204fc4:	fc842783          	lw	a5,-56(s0)
    80204fc8:	2781                	sext.w	a5,a5
    80204fca:	00f05863          	blez	a5,80204fda <test_process_creation+0x1d0>
        } else {
    80204fce:	fdc42783          	lw	a5,-36(s0)
    80204fd2:	2785                	addiw	a5,a5,1
    80204fd4:	fcf42e23          	sw	a5,-36(s0)
    80204fd8:	a811                	j	80204fec <test_process_creation+0x1e2>
            printf("【错误】: 等待进程失败，错误码: %d\n", waited_pid);
        }
    80204fda:	00003517          	auipc	a0,0x3
    80204fde:	1ae50513          	addi	a0,a0,430 # 80208188 <small_numbers+0x1d98>
    80204fe2:	ffffc097          	auipc	ra,0xffffc
    80204fe6:	b4c080e7          	jalr	-1204(ra) # 80200b2e <printf>
    }
    80204fea:	a831                	j	80205006 <test_process_creation+0x1fc>
        int waited_pid = wait_proc(NULL);
    80204fec:	fd842783          	lw	a5,-40(s0)
    80204ff0:	2785                	addiw	a5,a5,1
    80204ff2:	fcf42c23          	sw	a5,-40(s0)
    80204ff6:	fd842783          	lw	a5,-40(s0)
    80204ffa:	0007871b          	sext.w	a4,a5
    80204ffe:	1ff00793          	li	a5,511
    80205002:	fae7d6e3          	bge	a5,a4,80204fae <test_process_creation+0x1a4>
    printf("【测试结果】: 回收 %d/%d 个进程\n", success_count, count);
	print_proc_table();
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    80205006:	fdc42783          	lw	a5,-36(s0)
    8020500a:	85be                	mv	a1,a5
    8020500c:	00003517          	auipc	a0,0x3
    80205010:	1ac50513          	addi	a0,a0,428 # 802081b8 <small_numbers+0x1dc8>
    80205014:	ffffc097          	auipc	ra,0xffffc
    80205018:	b1a080e7          	jalr	-1254(ra) # 80200b2e <printf>
}
    8020501c:	00000097          	auipc	ra,0x0
    80205020:	bcc080e7          	jalr	-1076(ra) # 80204be8 <print_proc_table>

    80205024:	00003517          	auipc	a0,0x3
    80205028:	09450513          	addi	a0,a0,148 # 802080b8 <small_numbers+0x1cc8>
    8020502c:	ffffc097          	auipc	ra,0xffffc
    80205030:	b02080e7          	jalr	-1278(ra) # 80200b2e <printf>
void cpu_intensive_task(void) {
    80205034:	fe042223          	sw	zero,-28(s0)
    uint64 sum = 0;
    80205038:	fc042a23          	sw	zero,-44(s0)
    8020503c:	a0a1                	j	80205084 <test_process_creation+0x27a>
    for (uint64 i = 0; i < 10000000; i++) {
    8020503e:	4501                	li	a0,0
    80205040:	fffff097          	auipc	ra,0xfffff
    80205044:	580080e7          	jalr	1408(ra) # 802045c0 <wait_proc>
    80205048:	87aa                	mv	a5,a0
    8020504a:	fcf42223          	sw	a5,-60(s0)
        sum += i;
    8020504e:	fc442783          	lw	a5,-60(s0)
    80205052:	2781                	sext.w	a5,a5
    80205054:	00f05863          	blez	a5,80205064 <test_process_creation+0x25a>
    }
    80205058:	fe442783          	lw	a5,-28(s0)
    8020505c:	2785                	addiw	a5,a5,1
    8020505e:	fef42223          	sw	a5,-28(s0)
    80205062:	a821                	j	8020507a <test_process_creation+0x270>
    printf("CPU intensive task done in PID %d, sum=%lu\n", myproc()->pid, sum);
    exit_proc(0);
    80205064:	fc442783          	lw	a5,-60(s0)
    80205068:	85be                	mv	a1,a5
    8020506a:	00003517          	auipc	a0,0x3
    8020506e:	07e50513          	addi	a0,a0,126 # 802080e8 <small_numbers+0x1cf8>
    80205072:	ffffc097          	auipc	ra,0xffffc
    80205076:	abc080e7          	jalr	-1348(ra) # 80200b2e <printf>
    uint64 sum = 0;
    8020507a:	fd442783          	lw	a5,-44(s0)
    8020507e:	2785                	addiw	a5,a5,1
    80205080:	fcf42a23          	sw	a5,-44(s0)
    80205084:	fd442783          	lw	a5,-44(s0)
    80205088:	873e                	mv	a4,a5
    8020508a:	fec42783          	lw	a5,-20(s0)
    8020508e:	2701                	sext.w	a4,a4
    80205090:	2781                	sext.w	a5,a5
    80205092:	faf746e3          	blt	a4,a5,8020503e <test_process_creation+0x234>
}

void test_scheduler(void) {
    80205096:	fec42703          	lw	a4,-20(s0)
    8020509a:	fe442783          	lw	a5,-28(s0)
    8020509e:	863a                	mv	a2,a4
    802050a0:	85be                	mv	a1,a5
    802050a2:	00003517          	auipc	a0,0x3
    802050a6:	07e50513          	addi	a0,a0,126 # 80208120 <small_numbers+0x1d30>
    802050aa:	ffffc097          	auipc	ra,0xffffc
    802050ae:	a84080e7          	jalr	-1404(ra) # 80200b2e <printf>
    printf("===== 测试开始: 调度器测试 =====\n");
    802050b2:	00000097          	auipc	ra,0x0
    802050b6:	b36080e7          	jalr	-1226(ra) # 80204be8 <print_proc_table>

    802050ba:	00003517          	auipc	a0,0x3
    802050be:	13e50513          	addi	a0,a0,318 # 802081f8 <small_numbers+0x1e08>
    802050c2:	ffffc097          	auipc	ra,0xffffc
    802050c6:	a6c080e7          	jalr	-1428(ra) # 80200b2e <printf>
    // 创建多个计算密集型进程
    802050ca:	0001                	nop
    802050cc:	70e2                	ld	ra,56(sp)
    802050ce:	7442                	ld	s0,48(sp)
    802050d0:	6121                	addi	sp,sp,64
    802050d2:	8082                	ret

00000000802050d4 <cpu_intensive_task>:
    for (int i = 0; i < 3; i++) {
        create_proc(cpu_intensive_task,1);
    802050d4:	1101                	addi	sp,sp,-32
    802050d6:	ec06                	sd	ra,24(sp)
    802050d8:	e822                	sd	s0,16(sp)
    802050da:	1000                	addi	s0,sp,32
    }
    802050dc:	fe043423          	sd	zero,-24(s0)

    802050e0:	fe043023          	sd	zero,-32(s0)
    802050e4:	a829                	j	802050fe <cpu_intensive_task+0x2a>
    // 观察调度行为
    802050e6:	fe843703          	ld	a4,-24(s0)
    802050ea:	fe043783          	ld	a5,-32(s0)
    802050ee:	97ba                	add	a5,a5,a4
    802050f0:	fef43423          	sd	a5,-24(s0)

    802050f4:	fe043783          	ld	a5,-32(s0)
    802050f8:	0785                	addi	a5,a5,1
    802050fa:	fef43023          	sd	a5,-32(s0)
    802050fe:	fe043703          	ld	a4,-32(s0)
    80205102:	009897b7          	lui	a5,0x989
    80205106:	67f78793          	addi	a5,a5,1663 # 98967f <userret+0x9895e3>
    8020510a:	fce7fee3          	bgeu	a5,a4,802050e6 <cpu_intensive_task+0x12>
    uint64 start_time = get_time();
	for (int i = 0; i < 3; i++) {
    8020510e:	fffff097          	auipc	ra,0xfffff
    80205112:	e22080e7          	jalr	-478(ra) # 80203f30 <myproc>
    80205116:	87aa                	mv	a5,a0
    80205118:	43dc                	lw	a5,4(a5)
    8020511a:	fe843603          	ld	a2,-24(s0)
    8020511e:	85be                	mv	a1,a5
    80205120:	00003517          	auipc	a0,0x3
    80205124:	11050513          	addi	a0,a0,272 # 80208230 <small_numbers+0x1e40>
    80205128:	ffffc097          	auipc	ra,0xffffc
    8020512c:	a06080e7          	jalr	-1530(ra) # 80200b2e <printf>
    	wait_proc(NULL); // 等待所有子进程结束
    80205130:	4501                	li	a0,0
    80205132:	fffff097          	auipc	ra,0xfffff
    80205136:	456080e7          	jalr	1110(ra) # 80204588 <exit_proc>
	}
    8020513a:	0001                	nop
    8020513c:	60e2                	ld	ra,24(sp)
    8020513e:	6442                	ld	s0,16(sp)
    80205140:	6105                	addi	sp,sp,32
    80205142:	8082                	ret

0000000080205144 <test_scheduler>:
    uint64 end_time = get_time();

    80205144:	7179                	addi	sp,sp,-48
    80205146:	f406                	sd	ra,40(sp)
    80205148:	f022                	sd	s0,32(sp)
    8020514a:	1800                	addi	s0,sp,48
    printf("Scheduler test completed in %lu cycles\n", end_time - start_time);
    8020514c:	00003517          	auipc	a0,0x3
    80205150:	11450513          	addi	a0,a0,276 # 80208260 <small_numbers+0x1e70>
    80205154:	ffffc097          	auipc	ra,0xffffc
    80205158:	9da080e7          	jalr	-1574(ra) # 80200b2e <printf>
    printf("===== 测试结束 =====\n");
}
static int proc_buffer = 0;
    8020515c:	fe042623          	sw	zero,-20(s0)
    80205160:	a831                	j	8020517c <test_scheduler+0x38>
static int proc_produced = 0;
    80205162:	00000517          	auipc	a0,0x0
    80205166:	f7250513          	addi	a0,a0,-142 # 802050d4 <cpu_intensive_task>
    8020516a:	fffff097          	auipc	ra,0xfffff
    8020516e:	3a2080e7          	jalr	930(ra) # 8020450c <create_proc>
static int proc_buffer = 0;
    80205172:	fec42783          	lw	a5,-20(s0)
    80205176:	2785                	addiw	a5,a5,1
    80205178:	fef42623          	sw	a5,-20(s0)
    8020517c:	fec42783          	lw	a5,-20(s0)
    80205180:	0007871b          	sext.w	a4,a5
    80205184:	4789                	li	a5,2
    80205186:	fce7dee3          	bge	a5,a4,80205162 <test_scheduler+0x1e>

void shared_buffer_init() {
    proc_buffer = 0;
    proc_produced = 0;
    8020518a:	ffffe097          	auipc	ra,0xffffe
    8020518e:	560080e7          	jalr	1376(ra) # 802036ea <get_time>
    80205192:	fea43023          	sd	a0,-32(s0)
}
    80205196:	fe042423          	sw	zero,-24(s0)
    8020519a:	a819                	j	802051b0 <test_scheduler+0x6c>

    8020519c:	4501                	li	a0,0
    8020519e:	fffff097          	auipc	ra,0xfffff
    802051a2:	422080e7          	jalr	1058(ra) # 802045c0 <wait_proc>
}
    802051a6:	fe842783          	lw	a5,-24(s0)
    802051aa:	2785                	addiw	a5,a5,1
    802051ac:	fef42423          	sw	a5,-24(s0)
    802051b0:	fe842783          	lw	a5,-24(s0)
    802051b4:	0007871b          	sext.w	a4,a5
    802051b8:	4789                	li	a5,2
    802051ba:	fee7d1e3          	bge	a5,a4,8020519c <test_scheduler+0x58>
void producer_task(void) {
    proc_buffer = 42;
    802051be:	ffffe097          	auipc	ra,0xffffe
    802051c2:	52c080e7          	jalr	1324(ra) # 802036ea <get_time>
    802051c6:	fca43c23          	sd	a0,-40(s0)
    proc_produced = 1;
    wakeup(&proc_produced); // 唤醒消费者
    802051ca:	fd843703          	ld	a4,-40(s0)
    802051ce:	fe043783          	ld	a5,-32(s0)
    802051d2:	40f707b3          	sub	a5,a4,a5
    802051d6:	85be                	mv	a1,a5
    802051d8:	00003517          	auipc	a0,0x3
    802051dc:	0b850513          	addi	a0,a0,184 # 80208290 <small_numbers+0x1ea0>
    802051e0:	ffffc097          	auipc	ra,0xffffc
    802051e4:	94e080e7          	jalr	-1714(ra) # 80200b2e <printf>
    printf("Producer: produced value %d\n", proc_buffer);
    802051e8:	00003517          	auipc	a0,0x3
    802051ec:	0d050513          	addi	a0,a0,208 # 802082b8 <small_numbers+0x1ec8>
    802051f0:	ffffc097          	auipc	ra,0xffffc
    802051f4:	93e080e7          	jalr	-1730(ra) # 80200b2e <printf>
    exit_proc(0);
    802051f8:	0001                	nop
    802051fa:	70a2                	ld	ra,40(sp)
    802051fc:	7402                	ld	s0,32(sp)
    802051fe:	6145                	addi	sp,sp,48
    80205200:	8082                	ret

0000000080205202 <shared_buffer_init>:
}

void consumer_task(void) {
    while (!proc_produced) {
    80205202:	1141                	addi	sp,sp,-16
    80205204:	e422                	sd	s0,8(sp)
    80205206:	0800                	addi	s0,sp,16
        sleep(&proc_produced); // 等待生产者
    80205208:	00007797          	auipc	a5,0x7
    8020520c:	1c078793          	addi	a5,a5,448 # 8020c3c8 <proc_buffer>
    80205210:	0007a023          	sw	zero,0(a5)
    }
    80205214:	00007797          	auipc	a5,0x7
    80205218:	1b878793          	addi	a5,a5,440 # 8020c3cc <proc_produced>
    8020521c:	0007a023          	sw	zero,0(a5)
    printf("Consumer: consumed value %d\n", proc_buffer);
    80205220:	0001                	nop
    80205222:	6422                	ld	s0,8(sp)
    80205224:	0141                	addi	sp,sp,16
    80205226:	8082                	ret

0000000080205228 <producer_task>:
    exit_proc(0);
}
    80205228:	1141                	addi	sp,sp,-16
    8020522a:	e406                	sd	ra,8(sp)
    8020522c:	e022                	sd	s0,0(sp)
    8020522e:	0800                	addi	s0,sp,16
void test_synchronization(void) {
    80205230:	00007797          	auipc	a5,0x7
    80205234:	19878793          	addi	a5,a5,408 # 8020c3c8 <proc_buffer>
    80205238:	02a00713          	li	a4,42
    8020523c:	c398                	sw	a4,0(a5)
    printf("===== 测试开始: 同步机制测试 =====\n");
    8020523e:	00007797          	auipc	a5,0x7
    80205242:	18e78793          	addi	a5,a5,398 # 8020c3cc <proc_produced>
    80205246:	4705                	li	a4,1
    80205248:	c398                	sw	a4,0(a5)

    8020524a:	00007517          	auipc	a0,0x7
    8020524e:	18250513          	addi	a0,a0,386 # 8020c3cc <proc_produced>
    80205252:	fffff097          	auipc	ra,0xfffff
    80205256:	67e080e7          	jalr	1662(ra) # 802048d0 <wakeup>
    // 初始化共享缓冲区
    8020525a:	00007797          	auipc	a5,0x7
    8020525e:	16e78793          	addi	a5,a5,366 # 8020c3c8 <proc_buffer>
    80205262:	439c                	lw	a5,0(a5)
    80205264:	85be                	mv	a1,a5
    80205266:	00003517          	auipc	a0,0x3
    8020526a:	07250513          	addi	a0,a0,114 # 802082d8 <small_numbers+0x1ee8>
    8020526e:	ffffc097          	auipc	ra,0xffffc
    80205272:	8c0080e7          	jalr	-1856(ra) # 80200b2e <printf>
    shared_buffer_init();
    80205276:	4501                	li	a0,0
    80205278:	fffff097          	auipc	ra,0xfffff
    8020527c:	310080e7          	jalr	784(ra) # 80204588 <exit_proc>

    80205280:	0001                	nop
    80205282:	60a2                	ld	ra,8(sp)
    80205284:	6402                	ld	s0,0(sp)
    80205286:	0141                	addi	sp,sp,16
    80205288:	8082                	ret

000000008020528a <consumer_task>:
    // 创建生产者和消费者进程
    create_proc(producer_task,1);
    8020528a:	1141                	addi	sp,sp,-16
    8020528c:	e406                	sd	ra,8(sp)
    8020528e:	e022                	sd	s0,0(sp)
    80205290:	0800                	addi	s0,sp,16
    create_proc(consumer_task,1);
    80205292:	a809                	j	802052a4 <consumer_task+0x1a>

    80205294:	00007517          	auipc	a0,0x7
    80205298:	13850513          	addi	a0,a0,312 # 8020c3cc <proc_produced>
    8020529c:	fffff097          	auipc	ra,0xfffff
    802052a0:	5ca080e7          	jalr	1482(ra) # 80204866 <sleep>
    create_proc(consumer_task,1);
    802052a4:	00007797          	auipc	a5,0x7
    802052a8:	12878793          	addi	a5,a5,296 # 8020c3cc <proc_produced>
    802052ac:	439c                	lw	a5,0(a5)
    802052ae:	d3fd                	beqz	a5,80205294 <consumer_task+0xa>
    // 等待两个进程完成
    wait_proc(NULL);
    802052b0:	00007797          	auipc	a5,0x7
    802052b4:	11878793          	addi	a5,a5,280 # 8020c3c8 <proc_buffer>
    802052b8:	439c                	lw	a5,0(a5)
    802052ba:	85be                	mv	a1,a5
    802052bc:	00003517          	auipc	a0,0x3
    802052c0:	03c50513          	addi	a0,a0,60 # 802082f8 <small_numbers+0x1f08>
    802052c4:	ffffc097          	auipc	ra,0xffffc
    802052c8:	86a080e7          	jalr	-1942(ra) # 80200b2e <printf>
    wait_proc(NULL);
    802052cc:	4501                	li	a0,0
    802052ce:	fffff097          	auipc	ra,0xfffff
    802052d2:	2ba080e7          	jalr	698(ra) # 80204588 <exit_proc>

    802052d6:	0001                	nop
    802052d8:	60a2                	ld	ra,8(sp)
    802052da:	6402                	ld	s0,0(sp)
    802052dc:	0141                	addi	sp,sp,16
    802052de:	8082                	ret

00000000802052e0 <test_synchronization>:
    printf("===== 测试结束 =====\n");
    802052e0:	1141                	addi	sp,sp,-16
    802052e2:	e406                	sd	ra,8(sp)
    802052e4:	e022                	sd	s0,0(sp)
    802052e6:	0800                	addi	s0,sp,16
}
    802052e8:	00003517          	auipc	a0,0x3
    802052ec:	03050513          	addi	a0,a0,48 # 80208318 <small_numbers+0x1f28>
    802052f0:	ffffc097          	auipc	ra,0xffffc
    802052f4:	83e080e7          	jalr	-1986(ra) # 80200b2e <printf>

void sys_access_task(void) {
    volatile int *ptr = (int*)0x80000000; // 典型内核空间地址
    802052f8:	00000097          	auipc	ra,0x0
    802052fc:	f0a080e7          	jalr	-246(ra) # 80205202 <shared_buffer_init>
    printf("SYS: try write kernel addr 0x80000000\n");
    *ptr = 1234;
    printf("SYS: write success, value=%d\n", *ptr);
    80205300:	00000517          	auipc	a0,0x0
    80205304:	f2850513          	addi	a0,a0,-216 # 80205228 <producer_task>
    80205308:	fffff097          	auipc	ra,0xfffff
    8020530c:	204080e7          	jalr	516(ra) # 8020450c <create_proc>
    exit_proc(0);
    80205310:	00000517          	auipc	a0,0x0
    80205314:	f7a50513          	addi	a0,a0,-134 # 8020528a <consumer_task>
    80205318:	fffff097          	auipc	ra,0xfffff
    8020531c:	1f4080e7          	jalr	500(ra) # 8020450c <create_proc>
}

void usr_access_task(void) {
    80205320:	4501                	li	a0,0
    80205322:	fffff097          	auipc	ra,0xfffff
    80205326:	29e080e7          	jalr	670(ra) # 802045c0 <wait_proc>
    volatile int *ptr = (int*)0x80000000; // 典型内核空间地址
    8020532a:	4501                	li	a0,0
    8020532c:	fffff097          	auipc	ra,0xfffff
    80205330:	294080e7          	jalr	660(ra) # 802045c0 <wait_proc>
    printf("USR: try write kernel addr 0x80000000\n");
    *ptr = 1234; // 这里理想情况下应触发异常
    80205334:	00003517          	auipc	a0,0x3
    80205338:	f8450513          	addi	a0,a0,-124 # 802082b8 <small_numbers+0x1ec8>
    8020533c:	ffffb097          	auipc	ra,0xffffb
    80205340:	7f2080e7          	jalr	2034(ra) # 80200b2e <printf>
    printf("USR: write success, value=%d\n", *ptr);
    80205344:	0001                	nop
    80205346:	60a2                	ld	ra,8(sp)
    80205348:	6402                	ld	s0,0(sp)
    8020534a:	0141                	addi	sp,sp,16
    8020534c:	8082                	ret

000000008020534e <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    8020534e:	7179                	addi	sp,sp,-48
    80205350:	f422                	sd	s0,40(sp)
    80205352:	1800                	addi	s0,sp,48
    80205354:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    80205358:	fe042623          	sw	zero,-20(s0)
    8020535c:	a031                	j	80205368 <strlen+0x1a>
    8020535e:	fec42783          	lw	a5,-20(s0)
    80205362:	2785                	addiw	a5,a5,1
    80205364:	fef42623          	sw	a5,-20(s0)
    80205368:	fec42783          	lw	a5,-20(s0)
    8020536c:	fd843703          	ld	a4,-40(s0)
    80205370:	97ba                	add	a5,a5,a4
    80205372:	0007c783          	lbu	a5,0(a5)
    80205376:	f7e5                	bnez	a5,8020535e <strlen+0x10>
        ;
    return n;
    80205378:	fec42783          	lw	a5,-20(s0)
}
    8020537c:	853e                	mv	a0,a5
    8020537e:	7422                	ld	s0,40(sp)
    80205380:	6145                	addi	sp,sp,48
    80205382:	8082                	ret

0000000080205384 <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    80205384:	1101                	addi	sp,sp,-32
    80205386:	ec22                	sd	s0,24(sp)
    80205388:	1000                	addi	s0,sp,32
    8020538a:	fea43423          	sd	a0,-24(s0)
    8020538e:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    80205392:	a819                	j	802053a8 <strcmp+0x24>
        p++, q++;
    80205394:	fe843783          	ld	a5,-24(s0)
    80205398:	0785                	addi	a5,a5,1
    8020539a:	fef43423          	sd	a5,-24(s0)
    8020539e:	fe043783          	ld	a5,-32(s0)
    802053a2:	0785                	addi	a5,a5,1
    802053a4:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    802053a8:	fe843783          	ld	a5,-24(s0)
    802053ac:	0007c783          	lbu	a5,0(a5)
    802053b0:	cb99                	beqz	a5,802053c6 <strcmp+0x42>
    802053b2:	fe843783          	ld	a5,-24(s0)
    802053b6:	0007c703          	lbu	a4,0(a5)
    802053ba:	fe043783          	ld	a5,-32(s0)
    802053be:	0007c783          	lbu	a5,0(a5)
    802053c2:	fcf709e3          	beq	a4,a5,80205394 <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    802053c6:	fe843783          	ld	a5,-24(s0)
    802053ca:	0007c783          	lbu	a5,0(a5)
    802053ce:	0007871b          	sext.w	a4,a5
    802053d2:	fe043783          	ld	a5,-32(s0)
    802053d6:	0007c783          	lbu	a5,0(a5)
    802053da:	2781                	sext.w	a5,a5
    802053dc:	40f707bb          	subw	a5,a4,a5
    802053e0:	2781                	sext.w	a5,a5
}
    802053e2:	853e                	mv	a0,a5
    802053e4:	6462                	ld	s0,24(sp)
    802053e6:	6105                	addi	sp,sp,32
    802053e8:	8082                	ret

00000000802053ea <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    802053ea:	7179                	addi	sp,sp,-48
    802053ec:	f422                	sd	s0,40(sp)
    802053ee:	1800                	addi	s0,sp,48
    802053f0:	fca43c23          	sd	a0,-40(s0)
    802053f4:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    802053f8:	fd843783          	ld	a5,-40(s0)
    802053fc:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    80205400:	0001                	nop
    80205402:	fd043703          	ld	a4,-48(s0)
    80205406:	00170793          	addi	a5,a4,1
    8020540a:	fcf43823          	sd	a5,-48(s0)
    8020540e:	fd843783          	ld	a5,-40(s0)
    80205412:	00178693          	addi	a3,a5,1
    80205416:	fcd43c23          	sd	a3,-40(s0)
    8020541a:	00074703          	lbu	a4,0(a4)
    8020541e:	00e78023          	sb	a4,0(a5)
    80205422:	0007c783          	lbu	a5,0(a5)
    80205426:	fff1                	bnez	a5,80205402 <strcpy+0x18>
        ;
    return os;
    80205428:	fe843783          	ld	a5,-24(s0)
}
    8020542c:	853e                	mv	a0,a5
    8020542e:	7422                	ld	s0,40(sp)
    80205430:	6145                	addi	sp,sp,48
    80205432:	8082                	ret

0000000080205434 <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    80205434:	7139                	addi	sp,sp,-64
    80205436:	fc22                	sd	s0,56(sp)
    80205438:	0080                	addi	s0,sp,64
    8020543a:	fca43c23          	sd	a0,-40(s0)
    8020543e:	fcb43823          	sd	a1,-48(s0)
    80205442:	87b2                	mv	a5,a2
    80205444:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    80205448:	fd843783          	ld	a5,-40(s0)
    8020544c:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    80205450:	fcc42783          	lw	a5,-52(s0)
    80205454:	2781                	sext.w	a5,a5
    80205456:	00f04563          	bgtz	a5,80205460 <safestrcpy+0x2c>
        return os;
    8020545a:	fe843783          	ld	a5,-24(s0)
    8020545e:	a0a9                	j	802054a8 <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    80205460:	0001                	nop
    80205462:	fcc42783          	lw	a5,-52(s0)
    80205466:	37fd                	addiw	a5,a5,-1
    80205468:	fcf42623          	sw	a5,-52(s0)
    8020546c:	fcc42783          	lw	a5,-52(s0)
    80205470:	2781                	sext.w	a5,a5
    80205472:	02f05563          	blez	a5,8020549c <safestrcpy+0x68>
    80205476:	fd043703          	ld	a4,-48(s0)
    8020547a:	00170793          	addi	a5,a4,1
    8020547e:	fcf43823          	sd	a5,-48(s0)
    80205482:	fd843783          	ld	a5,-40(s0)
    80205486:	00178693          	addi	a3,a5,1
    8020548a:	fcd43c23          	sd	a3,-40(s0)
    8020548e:	00074703          	lbu	a4,0(a4)
    80205492:	00e78023          	sb	a4,0(a5)
    80205496:	0007c783          	lbu	a5,0(a5)
    8020549a:	f7e1                	bnez	a5,80205462 <safestrcpy+0x2e>
        ;
    *s = 0;
    8020549c:	fd843783          	ld	a5,-40(s0)
    802054a0:	00078023          	sb	zero,0(a5)
    return os;
    802054a4:	fe843783          	ld	a5,-24(s0)
    802054a8:	853e                	mv	a0,a5
    802054aa:	7462                	ld	s0,56(sp)
    802054ac:	6121                	addi	sp,sp,64
    802054ae:	8082                	ret
	...
