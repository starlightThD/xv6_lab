
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80200000:	0000b117          	auipc	sp,0xb
    80200004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80200008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8020000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8020000c:	0000c517          	auipc	a0,0xc
    80200010:	09450513          	addi	a0,a0,148 # 8020c0a0 <kernel_pagetable>
        la a1,_bss_end
    80200014:	0000d597          	auipc	a1,0xd
    80200018:	8fc58593          	addi	a1,a1,-1796 # 8020c910 <_bss_end>

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
    80200032:	1101                	addi	sp,sp,-32 # 8020afe0 <user_test_bin_len+0xfe0>
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
    80200098:	00007517          	auipc	a0,0x7
    8020009c:	f6850513          	addi	a0,a0,-152 # 80207000 <etext>
    802000a0:	00001097          	auipc	ra,0x1
    802000a4:	be2080e7          	jalr	-1054(ra) # 80200c82 <printf>
}
    802000a8:	0001                	nop
    802000aa:	60a2                	ld	ra,8(sp)
    802000ac:	6402                	ld	s0,0(sp)
    802000ae:	0141                	addi	sp,sp,16
    802000b0:	8082                	ret

00000000802000b2 <start>:
void start(){
    802000b2:	1101                	addi	sp,sp,-32
    802000b4:	ec06                	sd	ra,24(sp)
    802000b6:	e822                	sd	s0,16(sp)
    802000b8:	1000                	addi	s0,sp,32
	pmm_init();
    802000ba:	00003097          	auipc	ra,0x3
    802000be:	11e080e7          	jalr	286(ra) # 802031d8 <pmm_init>
	kvminit();
    802000c2:	00002097          	auipc	ra,0x2
    802000c6:	6f2080e7          	jalr	1778(ra) # 802027b4 <kvminit>
	trap_init();
    802000ca:	00003097          	auipc	ra,0x3
    802000ce:	732080e7          	jalr	1842(ra) # 802037fc <trap_init>
	uart_init();
    802000d2:	00000097          	auipc	ra,0x0
    802000d6:	4c0080e7          	jalr	1216(ra) # 80200592 <uart_init>
	intr_on();
    802000da:	00000097          	auipc	ra,0x0
    802000de:	f8c080e7          	jalr	-116(ra) # 80200066 <intr_on>
    printf("===============================================\n");
    802000e2:	00007517          	auipc	a0,0x7
    802000e6:	ffe50513          	addi	a0,a0,-2 # 802070e0 <etext+0xe0>
    802000ea:	00001097          	auipc	ra,0x1
    802000ee:	b98080e7          	jalr	-1128(ra) # 80200c82 <printf>
    printf("        RISC-V Operating System v1.0         \n");
    802000f2:	00007517          	auipc	a0,0x7
    802000f6:	02650513          	addi	a0,a0,38 # 80207118 <etext+0x118>
    802000fa:	00001097          	auipc	ra,0x1
    802000fe:	b88080e7          	jalr	-1144(ra) # 80200c82 <printf>
    printf("===============================================\n\n");
    80200102:	00007517          	auipc	a0,0x7
    80200106:	04650513          	addi	a0,a0,70 # 80207148 <etext+0x148>
    8020010a:	00001097          	auipc	ra,0x1
    8020010e:	b78080e7          	jalr	-1160(ra) # 80200c82 <printf>
	init_proc(); // 初始化进程管理子系统
    80200112:	00005097          	auipc	ra,0x5
    80200116:	c3a080e7          	jalr	-966(ra) # 80204d4c <init_proc>
	int main_pid = create_kernel_proc(kernel_main);
    8020011a:	00000517          	auipc	a0,0x0
    8020011e:	3d250513          	addi	a0,a0,978 # 802004ec <kernel_main>
    80200122:	00005097          	auipc	ra,0x5
    80200126:	060080e7          	jalr	96(ra) # 80205182 <create_kernel_proc>
    8020012a:	87aa                	mv	a5,a0
    8020012c:	fef42623          	sw	a5,-20(s0)
	if (main_pid < 0){
    80200130:	fec42783          	lw	a5,-20(s0)
    80200134:	2781                	sext.w	a5,a5
    80200136:	0007da63          	bgez	a5,8020014a <start+0x98>
		panic("START: create main process failed!\n");
    8020013a:	00007517          	auipc	a0,0x7
    8020013e:	04650513          	addi	a0,a0,70 # 80207180 <etext+0x180>
    80200142:	00001097          	auipc	ra,0x1
    80200146:	58c080e7          	jalr	1420(ra) # 802016ce <panic>
	schedule();
    8020014a:	00005097          	auipc	ra,0x5
    8020014e:	3b0080e7          	jalr	944(ra) # 802054fa <schedule>
    panic("START: main() exit unexpectedly!!!\n");
    80200152:	00007517          	auipc	a0,0x7
    80200156:	05650513          	addi	a0,a0,86 # 802071a8 <etext+0x1a8>
    8020015a:	00001097          	auipc	ra,0x1
    8020015e:	574080e7          	jalr	1396(ra) # 802016ce <panic>
}
    80200162:	0001                	nop
    80200164:	60e2                	ld	ra,24(sp)
    80200166:	6442                	ld	s0,16(sp)
    80200168:	6105                	addi	sp,sp,32
    8020016a:	8082                	ret

000000008020016c <console>:
void console(void) {
    8020016c:	7129                	addi	sp,sp,-320
    8020016e:	fe06                	sd	ra,312(sp)
    80200170:	fa22                	sd	s0,304(sp)
    80200172:	0280                	addi	s0,sp,320
    int exit_requested = 0;
    80200174:	fe042623          	sw	zero,-20(s0)
    printf("可用命令:\n");
    80200178:	00007517          	auipc	a0,0x7
    8020017c:	05850513          	addi	a0,a0,88 # 802071d0 <etext+0x1d0>
    80200180:	00001097          	auipc	ra,0x1
    80200184:	b02080e7          	jalr	-1278(ra) # 80200c82 <printf>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    80200188:	fe042423          	sw	zero,-24(s0)
    8020018c:	a0b9                	j	802001da <console+0x6e>
        printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
    8020018e:	0000c697          	auipc	a3,0xc
    80200192:	e7268693          	addi	a3,a3,-398 # 8020c000 <command_table>
    80200196:	fe842703          	lw	a4,-24(s0)
    8020019a:	87ba                	mv	a5,a4
    8020019c:	0786                	slli	a5,a5,0x1
    8020019e:	97ba                	add	a5,a5,a4
    802001a0:	078e                	slli	a5,a5,0x3
    802001a2:	97b6                	add	a5,a5,a3
    802001a4:	638c                	ld	a1,0(a5)
    802001a6:	0000c697          	auipc	a3,0xc
    802001aa:	e5a68693          	addi	a3,a3,-422 # 8020c000 <command_table>
    802001ae:	fe842703          	lw	a4,-24(s0)
    802001b2:	87ba                	mv	a5,a4
    802001b4:	0786                	slli	a5,a5,0x1
    802001b6:	97ba                	add	a5,a5,a4
    802001b8:	078e                	slli	a5,a5,0x3
    802001ba:	97b6                	add	a5,a5,a3
    802001bc:	6b9c                	ld	a5,16(a5)
    802001be:	863e                	mv	a2,a5
    802001c0:	00007517          	auipc	a0,0x7
    802001c4:	02050513          	addi	a0,a0,32 # 802071e0 <etext+0x1e0>
    802001c8:	00001097          	auipc	ra,0x1
    802001cc:	aba080e7          	jalr	-1350(ra) # 80200c82 <printf>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    802001d0:	fe842783          	lw	a5,-24(s0)
    802001d4:	2785                	addiw	a5,a5,1
    802001d6:	fef42423          	sw	a5,-24(s0)
    802001da:	fe842783          	lw	a5,-24(s0)
    802001de:	873e                	mv	a4,a5
    802001e0:	4791                	li	a5,4
    802001e2:	fae7f6e3          	bgeu	a5,a4,8020018e <console+0x22>
    printf("  help          - 显示此帮助\n");
    802001e6:	00007517          	auipc	a0,0x7
    802001ea:	00a50513          	addi	a0,a0,10 # 802071f0 <etext+0x1f0>
    802001ee:	00001097          	auipc	ra,0x1
    802001f2:	a94080e7          	jalr	-1388(ra) # 80200c82 <printf>
    printf("  exit          - 退出控制台\n");
    802001f6:	00007517          	auipc	a0,0x7
    802001fa:	02250513          	addi	a0,a0,34 # 80207218 <etext+0x218>
    802001fe:	00001097          	auipc	ra,0x1
    80200202:	a84080e7          	jalr	-1404(ra) # 80200c82 <printf>
    printf("  ps            - 显示进程状态\n");
    80200206:	00007517          	auipc	a0,0x7
    8020020a:	03a50513          	addi	a0,a0,58 # 80207240 <etext+0x240>
    8020020e:	00001097          	auipc	ra,0x1
    80200212:	a74080e7          	jalr	-1420(ra) # 80200c82 <printf>
    while (!exit_requested) {
    80200216:	ac4d                	j	802004c8 <console+0x35c>
        printf("Console >>> ");
    80200218:	00007517          	auipc	a0,0x7
    8020021c:	05050513          	addi	a0,a0,80 # 80207268 <etext+0x268>
    80200220:	00001097          	auipc	ra,0x1
    80200224:	a62080e7          	jalr	-1438(ra) # 80200c82 <printf>
        readline(input_buffer, sizeof(input_buffer));
    80200228:	ed040793          	addi	a5,s0,-304
    8020022c:	10000593          	li	a1,256
    80200230:	853e                	mv	a0,a5
    80200232:	00000097          	auipc	ra,0x0
    80200236:	742080e7          	jalr	1858(ra) # 80200974 <readline>
        if (strcmp(input_buffer, "exit") == 0) {
    8020023a:	ed040793          	addi	a5,s0,-304
    8020023e:	00007597          	auipc	a1,0x7
    80200242:	03a58593          	addi	a1,a1,58 # 80207278 <etext+0x278>
    80200246:	853e                	mv	a0,a5
    80200248:	00006097          	auipc	ra,0x6
    8020024c:	0b4080e7          	jalr	180(ra) # 802062fc <strcmp>
    80200250:	87aa                	mv	a5,a0
    80200252:	e789                	bnez	a5,8020025c <console+0xf0>
            exit_requested = 1;
    80200254:	4785                	li	a5,1
    80200256:	fef42623          	sw	a5,-20(s0)
    8020025a:	a4bd                	j	802004c8 <console+0x35c>
        } else if (strcmp(input_buffer, "help") == 0) {
    8020025c:	ed040793          	addi	a5,s0,-304
    80200260:	00007597          	auipc	a1,0x7
    80200264:	02058593          	addi	a1,a1,32 # 80207280 <etext+0x280>
    80200268:	853e                	mv	a0,a5
    8020026a:	00006097          	auipc	ra,0x6
    8020026e:	092080e7          	jalr	146(ra) # 802062fc <strcmp>
    80200272:	87aa                	mv	a5,a0
    80200274:	e3cd                	bnez	a5,80200316 <console+0x1aa>
            printf("可用命令:\n");
    80200276:	00007517          	auipc	a0,0x7
    8020027a:	f5a50513          	addi	a0,a0,-166 # 802071d0 <etext+0x1d0>
    8020027e:	00001097          	auipc	ra,0x1
    80200282:	a04080e7          	jalr	-1532(ra) # 80200c82 <printf>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    80200286:	fe042223          	sw	zero,-28(s0)
    8020028a:	a0b9                	j	802002d8 <console+0x16c>
                printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
    8020028c:	0000c697          	auipc	a3,0xc
    80200290:	d7468693          	addi	a3,a3,-652 # 8020c000 <command_table>
    80200294:	fe442703          	lw	a4,-28(s0)
    80200298:	87ba                	mv	a5,a4
    8020029a:	0786                	slli	a5,a5,0x1
    8020029c:	97ba                	add	a5,a5,a4
    8020029e:	078e                	slli	a5,a5,0x3
    802002a0:	97b6                	add	a5,a5,a3
    802002a2:	638c                	ld	a1,0(a5)
    802002a4:	0000c697          	auipc	a3,0xc
    802002a8:	d5c68693          	addi	a3,a3,-676 # 8020c000 <command_table>
    802002ac:	fe442703          	lw	a4,-28(s0)
    802002b0:	87ba                	mv	a5,a4
    802002b2:	0786                	slli	a5,a5,0x1
    802002b4:	97ba                	add	a5,a5,a4
    802002b6:	078e                	slli	a5,a5,0x3
    802002b8:	97b6                	add	a5,a5,a3
    802002ba:	6b9c                	ld	a5,16(a5)
    802002bc:	863e                	mv	a2,a5
    802002be:	00007517          	auipc	a0,0x7
    802002c2:	f2250513          	addi	a0,a0,-222 # 802071e0 <etext+0x1e0>
    802002c6:	00001097          	auipc	ra,0x1
    802002ca:	9bc080e7          	jalr	-1604(ra) # 80200c82 <printf>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    802002ce:	fe442783          	lw	a5,-28(s0)
    802002d2:	2785                	addiw	a5,a5,1
    802002d4:	fef42223          	sw	a5,-28(s0)
    802002d8:	fe442783          	lw	a5,-28(s0)
    802002dc:	873e                	mv	a4,a5
    802002de:	4791                	li	a5,4
    802002e0:	fae7f6e3          	bgeu	a5,a4,8020028c <console+0x120>
            printf("  help          - 显示此帮助\n");
    802002e4:	00007517          	auipc	a0,0x7
    802002e8:	f0c50513          	addi	a0,a0,-244 # 802071f0 <etext+0x1f0>
    802002ec:	00001097          	auipc	ra,0x1
    802002f0:	996080e7          	jalr	-1642(ra) # 80200c82 <printf>
            printf("  exit          - 退出控制台\n");
    802002f4:	00007517          	auipc	a0,0x7
    802002f8:	f2450513          	addi	a0,a0,-220 # 80207218 <etext+0x218>
    802002fc:	00001097          	auipc	ra,0x1
    80200300:	986080e7          	jalr	-1658(ra) # 80200c82 <printf>
            printf("  ps            - 显示进程状态\n");
    80200304:	00007517          	auipc	a0,0x7
    80200308:	f3c50513          	addi	a0,a0,-196 # 80207240 <etext+0x240>
    8020030c:	00001097          	auipc	ra,0x1
    80200310:	976080e7          	jalr	-1674(ra) # 80200c82 <printf>
    80200314:	aa55                	j	802004c8 <console+0x35c>
        } else if (strcmp(input_buffer, "ps") == 0) {
    80200316:	ed040793          	addi	a5,s0,-304
    8020031a:	00007597          	auipc	a1,0x7
    8020031e:	f6e58593          	addi	a1,a1,-146 # 80207288 <etext+0x288>
    80200322:	853e                	mv	a0,a5
    80200324:	00006097          	auipc	ra,0x6
    80200328:	fd8080e7          	jalr	-40(ra) # 802062fc <strcmp>
    8020032c:	87aa                	mv	a5,a0
    8020032e:	e791                	bnez	a5,8020033a <console+0x1ce>
            print_proc_table();
    80200330:	00005097          	auipc	ra,0x5
    80200334:	716080e7          	jalr	1814(ra) # 80205a46 <print_proc_table>
    80200338:	aa41                	j	802004c8 <console+0x35c>
            int found = 0;
    8020033a:	fe042023          	sw	zero,-32(s0)
            for (int i = 0; i < COMMAND_COUNT; i++) {
    8020033e:	fc042e23          	sw	zero,-36(s0)
    80200342:	aa99                	j	80200498 <console+0x32c>
                if (strcmp(input_buffer, command_table[i].name) == 0) {
    80200344:	0000c697          	auipc	a3,0xc
    80200348:	cbc68693          	addi	a3,a3,-836 # 8020c000 <command_table>
    8020034c:	fdc42703          	lw	a4,-36(s0)
    80200350:	87ba                	mv	a5,a4
    80200352:	0786                	slli	a5,a5,0x1
    80200354:	97ba                	add	a5,a5,a4
    80200356:	078e                	slli	a5,a5,0x3
    80200358:	97b6                	add	a5,a5,a3
    8020035a:	6398                	ld	a4,0(a5)
    8020035c:	ed040793          	addi	a5,s0,-304
    80200360:	85ba                	mv	a1,a4
    80200362:	853e                	mv	a0,a5
    80200364:	00006097          	auipc	ra,0x6
    80200368:	f98080e7          	jalr	-104(ra) # 802062fc <strcmp>
    8020036c:	87aa                	mv	a5,a0
    8020036e:	12079063          	bnez	a5,8020048e <console+0x322>
                    int pid = create_kernel_proc(command_table[i].func);
    80200372:	0000c697          	auipc	a3,0xc
    80200376:	c8e68693          	addi	a3,a3,-882 # 8020c000 <command_table>
    8020037a:	fdc42703          	lw	a4,-36(s0)
    8020037e:	87ba                	mv	a5,a4
    80200380:	0786                	slli	a5,a5,0x1
    80200382:	97ba                	add	a5,a5,a4
    80200384:	078e                	slli	a5,a5,0x3
    80200386:	97b6                	add	a5,a5,a3
    80200388:	679c                	ld	a5,8(a5)
    8020038a:	853e                	mv	a0,a5
    8020038c:	00005097          	auipc	ra,0x5
    80200390:	df6080e7          	jalr	-522(ra) # 80205182 <create_kernel_proc>
    80200394:	87aa                	mv	a5,a0
    80200396:	fcf42c23          	sw	a5,-40(s0)
                    if (pid < 0) {
    8020039a:	fd842783          	lw	a5,-40(s0)
    8020039e:	2781                	sext.w	a5,a5
    802003a0:	0207d863          	bgez	a5,802003d0 <console+0x264>
                        printf("创建%s进程失败\n", command_table[i].name);
    802003a4:	0000c697          	auipc	a3,0xc
    802003a8:	c5c68693          	addi	a3,a3,-932 # 8020c000 <command_table>
    802003ac:	fdc42703          	lw	a4,-36(s0)
    802003b0:	87ba                	mv	a5,a4
    802003b2:	0786                	slli	a5,a5,0x1
    802003b4:	97ba                	add	a5,a5,a4
    802003b6:	078e                	slli	a5,a5,0x3
    802003b8:	97b6                	add	a5,a5,a3
    802003ba:	639c                	ld	a5,0(a5)
    802003bc:	85be                	mv	a1,a5
    802003be:	00007517          	auipc	a0,0x7
    802003c2:	ed250513          	addi	a0,a0,-302 # 80207290 <etext+0x290>
    802003c6:	00001097          	auipc	ra,0x1
    802003ca:	8bc080e7          	jalr	-1860(ra) # 80200c82 <printf>
    802003ce:	a865                	j	80200486 <console+0x31a>
                        printf("创建%s进程成功，PID: %d\n", command_table[i].name, pid);
    802003d0:	0000c697          	auipc	a3,0xc
    802003d4:	c3068693          	addi	a3,a3,-976 # 8020c000 <command_table>
    802003d8:	fdc42703          	lw	a4,-36(s0)
    802003dc:	87ba                	mv	a5,a4
    802003de:	0786                	slli	a5,a5,0x1
    802003e0:	97ba                	add	a5,a5,a4
    802003e2:	078e                	slli	a5,a5,0x3
    802003e4:	97b6                	add	a5,a5,a3
    802003e6:	639c                	ld	a5,0(a5)
    802003e8:	fd842703          	lw	a4,-40(s0)
    802003ec:	863a                	mv	a2,a4
    802003ee:	85be                	mv	a1,a5
    802003f0:	00007517          	auipc	a0,0x7
    802003f4:	eb850513          	addi	a0,a0,-328 # 802072a8 <etext+0x2a8>
    802003f8:	00001097          	auipc	ra,0x1
    802003fc:	88a080e7          	jalr	-1910(ra) # 80200c82 <printf>
                        int waited_pid = wait_proc(&status);
    80200400:	ecc40793          	addi	a5,s0,-308
    80200404:	853e                	mv	a0,a5
    80200406:	00005097          	auipc	ra,0x5
    8020040a:	00e080e7          	jalr	14(ra) # 80205414 <wait_proc>
    8020040e:	87aa                	mv	a5,a0
    80200410:	fcf42a23          	sw	a5,-44(s0)
                        if (waited_pid == pid) {
    80200414:	fd442783          	lw	a5,-44(s0)
    80200418:	873e                	mv	a4,a5
    8020041a:	fd842783          	lw	a5,-40(s0)
    8020041e:	2701                	sext.w	a4,a4
    80200420:	2781                	sext.w	a5,a5
    80200422:	02f71d63          	bne	a4,a5,8020045c <console+0x2f0>
                            printf("%s进程(PID: %d)已退出，状态码: %d\n", command_table[i].name, pid, status);
    80200426:	0000c697          	auipc	a3,0xc
    8020042a:	bda68693          	addi	a3,a3,-1062 # 8020c000 <command_table>
    8020042e:	fdc42703          	lw	a4,-36(s0)
    80200432:	87ba                	mv	a5,a4
    80200434:	0786                	slli	a5,a5,0x1
    80200436:	97ba                	add	a5,a5,a4
    80200438:	078e                	slli	a5,a5,0x3
    8020043a:	97b6                	add	a5,a5,a3
    8020043c:	639c                	ld	a5,0(a5)
    8020043e:	ecc42683          	lw	a3,-308(s0)
    80200442:	fd842703          	lw	a4,-40(s0)
    80200446:	863a                	mv	a2,a4
    80200448:	85be                	mv	a1,a5
    8020044a:	00007517          	auipc	a0,0x7
    8020044e:	e7e50513          	addi	a0,a0,-386 # 802072c8 <etext+0x2c8>
    80200452:	00001097          	auipc	ra,0x1
    80200456:	830080e7          	jalr	-2000(ra) # 80200c82 <printf>
    8020045a:	a035                	j	80200486 <console+0x31a>
                            printf("等待%s进程时发生错误\n", command_table[i].name);
    8020045c:	0000c697          	auipc	a3,0xc
    80200460:	ba468693          	addi	a3,a3,-1116 # 8020c000 <command_table>
    80200464:	fdc42703          	lw	a4,-36(s0)
    80200468:	87ba                	mv	a5,a4
    8020046a:	0786                	slli	a5,a5,0x1
    8020046c:	97ba                	add	a5,a5,a4
    8020046e:	078e                	slli	a5,a5,0x3
    80200470:	97b6                	add	a5,a5,a3
    80200472:	639c                	ld	a5,0(a5)
    80200474:	85be                	mv	a1,a5
    80200476:	00007517          	auipc	a0,0x7
    8020047a:	e8250513          	addi	a0,a0,-382 # 802072f8 <etext+0x2f8>
    8020047e:	00001097          	auipc	ra,0x1
    80200482:	804080e7          	jalr	-2044(ra) # 80200c82 <printf>
                    found = 1;
    80200486:	4785                	li	a5,1
    80200488:	fef42023          	sw	a5,-32(s0)
                    break;
    8020048c:	a821                	j	802004a4 <console+0x338>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    8020048e:	fdc42783          	lw	a5,-36(s0)
    80200492:	2785                	addiw	a5,a5,1
    80200494:	fcf42e23          	sw	a5,-36(s0)
    80200498:	fdc42783          	lw	a5,-36(s0)
    8020049c:	873e                	mv	a4,a5
    8020049e:	4791                	li	a5,4
    802004a0:	eae7f2e3          	bgeu	a5,a4,80200344 <console+0x1d8>
            if (!found && input_buffer[0] != '\0') {
    802004a4:	fe042783          	lw	a5,-32(s0)
    802004a8:	2781                	sext.w	a5,a5
    802004aa:	ef99                	bnez	a5,802004c8 <console+0x35c>
    802004ac:	ed044783          	lbu	a5,-304(s0)
    802004b0:	cf81                	beqz	a5,802004c8 <console+0x35c>
                printf("无效命令: %s\n", input_buffer);
    802004b2:	ed040793          	addi	a5,s0,-304
    802004b6:	85be                	mv	a1,a5
    802004b8:	00007517          	auipc	a0,0x7
    802004bc:	e6050513          	addi	a0,a0,-416 # 80207318 <etext+0x318>
    802004c0:	00000097          	auipc	ra,0x0
    802004c4:	7c2080e7          	jalr	1986(ra) # 80200c82 <printf>
    while (!exit_requested) {
    802004c8:	fec42783          	lw	a5,-20(s0)
    802004cc:	2781                	sext.w	a5,a5
    802004ce:	d40785e3          	beqz	a5,80200218 <console+0xac>
    printf("控制台进程退出\n");
    802004d2:	00007517          	auipc	a0,0x7
    802004d6:	e5e50513          	addi	a0,a0,-418 # 80207330 <etext+0x330>
    802004da:	00000097          	auipc	ra,0x0
    802004de:	7a8080e7          	jalr	1960(ra) # 80200c82 <printf>
    return;
    802004e2:	0001                	nop
}
    802004e4:	70f2                	ld	ra,312(sp)
    802004e6:	7452                	ld	s0,304(sp)
    802004e8:	6131                	addi	sp,sp,320
    802004ea:	8082                	ret

00000000802004ec <kernel_main>:
void kernel_main(void){
    802004ec:	1101                	addi	sp,sp,-32
    802004ee:	ec06                	sd	ra,24(sp)
    802004f0:	e822                	sd	s0,16(sp)
    802004f2:	1000                	addi	s0,sp,32
	clear_screen();
    802004f4:	00001097          	auipc	ra,0x1
    802004f8:	ca6080e7          	jalr	-858(ra) # 8020119a <clear_screen>
	int console_pid = create_kernel_proc(console);
    802004fc:	00000517          	auipc	a0,0x0
    80200500:	c7050513          	addi	a0,a0,-912 # 8020016c <console>
    80200504:	00005097          	auipc	ra,0x5
    80200508:	c7e080e7          	jalr	-898(ra) # 80205182 <create_kernel_proc>
    8020050c:	87aa                	mv	a5,a0
    8020050e:	fef42623          	sw	a5,-20(s0)
	if (console_pid < 0){
    80200512:	fec42783          	lw	a5,-20(s0)
    80200516:	2781                	sext.w	a5,a5
    80200518:	0007db63          	bgez	a5,8020052e <kernel_main+0x42>
		panic("KERNEL_MAIN: create console process failed!\n");
    8020051c:	00007517          	auipc	a0,0x7
    80200520:	e2c50513          	addi	a0,a0,-468 # 80207348 <etext+0x348>
    80200524:	00001097          	auipc	ra,0x1
    80200528:	1aa080e7          	jalr	426(ra) # 802016ce <panic>
    8020052c:	a821                	j	80200544 <kernel_main+0x58>
		printf("KERNEL_MAIN: console process created with PID %d\n", console_pid);
    8020052e:	fec42783          	lw	a5,-20(s0)
    80200532:	85be                	mv	a1,a5
    80200534:	00007517          	auipc	a0,0x7
    80200538:	e4450513          	addi	a0,a0,-444 # 80207378 <etext+0x378>
    8020053c:	00000097          	auipc	ra,0x0
    80200540:	746080e7          	jalr	1862(ra) # 80200c82 <printf>
	int pid = wait_proc(&status);
    80200544:	fe440793          	addi	a5,s0,-28
    80200548:	853e                	mv	a0,a5
    8020054a:	00005097          	auipc	ra,0x5
    8020054e:	eca080e7          	jalr	-310(ra) # 80205414 <wait_proc>
    80200552:	87aa                	mv	a5,a0
    80200554:	fef42423          	sw	a5,-24(s0)
	if(pid != console_pid){
    80200558:	fe842783          	lw	a5,-24(s0)
    8020055c:	873e                	mv	a4,a5
    8020055e:	fec42783          	lw	a5,-20(s0)
    80200562:	2701                	sext.w	a4,a4
    80200564:	2781                	sext.w	a5,a5
    80200566:	02f70163          	beq	a4,a5,80200588 <kernel_main+0x9c>
		printf("KERNEL_MAIN: unexpected process %d exited with status %d\n", pid, status);
    8020056a:	fe442703          	lw	a4,-28(s0)
    8020056e:	fe842783          	lw	a5,-24(s0)
    80200572:	863a                	mv	a2,a4
    80200574:	85be                	mv	a1,a5
    80200576:	00007517          	auipc	a0,0x7
    8020057a:	e3a50513          	addi	a0,a0,-454 # 802073b0 <etext+0x3b0>
    8020057e:	00000097          	auipc	ra,0x0
    80200582:	704080e7          	jalr	1796(ra) # 80200c82 <printf>
	return;
    80200586:	0001                	nop
    80200588:	0001                	nop
    8020058a:	60e2                	ld	ra,24(sp)
    8020058c:	6442                	ld	s0,16(sp)
    8020058e:	6105                	addi	sp,sp,32
    80200590:	8082                	ret

0000000080200592 <uart_init>:
#include "defs.h"
#define LINE_BUF_SIZE 128
struct uart_input_buf_t uart_input_buf;
// UART初始化函数
void uart_init(void) {
    80200592:	1141                	addi	sp,sp,-16
    80200594:	e406                	sd	ra,8(sp)
    80200596:	e022                	sd	s0,0(sp)
    80200598:	0800                	addi	s0,sp,16

    WriteReg(IER, 0x00);
    8020059a:	100007b7          	lui	a5,0x10000
    8020059e:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    802005a0:	00078023          	sb	zero,0(a5)
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    802005a4:	100007b7          	lui	a5,0x10000
    802005a8:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x701ffffe>
    802005aa:	471d                	li	a4,7
    802005ac:	00e78023          	sb	a4,0(a5)
    WriteReg(IER, IER_RX_ENABLE);
    802005b0:	100007b7          	lui	a5,0x10000
    802005b4:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    802005b6:	4705                	li	a4,1
    802005b8:	00e78023          	sb	a4,0(a5)
    register_interrupt(UART0_IRQ, uart_intr);//注册键盘输入的中断处理函数
    802005bc:	00000597          	auipc	a1,0x0
    802005c0:	12858593          	addi	a1,a1,296 # 802006e4 <uart_intr>
    802005c4:	4529                	li	a0,10
    802005c6:	00003097          	auipc	ra,0x3
    802005ca:	0b2080e7          	jalr	178(ra) # 80203678 <register_interrupt>
    enable_interrupts(UART0_IRQ);
    802005ce:	4529                	li	a0,10
    802005d0:	00003097          	auipc	ra,0x3
    802005d4:	132080e7          	jalr	306(ra) # 80203702 <enable_interrupts>
    printf("UART initialized with input support\n");
    802005d8:	00007517          	auipc	a0,0x7
    802005dc:	e1850513          	addi	a0,a0,-488 # 802073f0 <etext+0x3f0>
    802005e0:	00000097          	auipc	ra,0x0
    802005e4:	6a2080e7          	jalr	1698(ra) # 80200c82 <printf>
}
    802005e8:	0001                	nop
    802005ea:	60a2                	ld	ra,8(sp)
    802005ec:	6402                	ld	s0,0(sp)
    802005ee:	0141                	addi	sp,sp,16
    802005f0:	8082                	ret

00000000802005f2 <uart_putc>:

// 发送单个字符
void uart_putc(char c) {
    802005f2:	1101                	addi	sp,sp,-32
    802005f4:	ec22                	sd	s0,24(sp)
    802005f6:	1000                	addi	s0,sp,32
    802005f8:	87aa                	mv	a5,a0
    802005fa:	fef407a3          	sb	a5,-17(s0)
    // 等待发送缓冲区空闲
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    802005fe:	0001                	nop
    80200600:	100007b7          	lui	a5,0x10000
    80200604:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200606:	0007c783          	lbu	a5,0(a5)
    8020060a:	0ff7f793          	zext.b	a5,a5
    8020060e:	2781                	sext.w	a5,a5
    80200610:	0207f793          	andi	a5,a5,32
    80200614:	2781                	sext.w	a5,a5
    80200616:	d7ed                	beqz	a5,80200600 <uart_putc+0xe>
    WriteReg(THR, c);
    80200618:	100007b7          	lui	a5,0x10000
    8020061c:	fef44703          	lbu	a4,-17(s0)
    80200620:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
}
    80200624:	0001                	nop
    80200626:	6462                	ld	s0,24(sp)
    80200628:	6105                	addi	sp,sp,32
    8020062a:	8082                	ret

000000008020062c <uart_puts>:

void uart_puts(char *s) {
    8020062c:	7179                	addi	sp,sp,-48
    8020062e:	f422                	sd	s0,40(sp)
    80200630:	1800                	addi	s0,sp,48
    80200632:	fca43c23          	sd	a0,-40(s0)
    if (!s) return;
    80200636:	fd843783          	ld	a5,-40(s0)
    8020063a:	c7b5                	beqz	a5,802006a6 <uart_puts+0x7a>
    
    while (*s) {
    8020063c:	a8b9                	j	8020069a <uart_puts+0x6e>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    8020063e:	0001                	nop
    80200640:	100007b7          	lui	a5,0x10000
    80200644:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200646:	0007c783          	lbu	a5,0(a5)
    8020064a:	0ff7f793          	zext.b	a5,a5
    8020064e:	2781                	sext.w	a5,a5
    80200650:	0207f793          	andi	a5,a5,32
    80200654:	2781                	sext.w	a5,a5
    80200656:	d7ed                	beqz	a5,80200640 <uart_puts+0x14>
        int sent_count = 0;
    80200658:	fe042623          	sw	zero,-20(s0)
        while (*s && sent_count < 4) { 
    8020065c:	a01d                	j	80200682 <uart_puts+0x56>
            WriteReg(THR, *s);
    8020065e:	100007b7          	lui	a5,0x10000
    80200662:	fd843703          	ld	a4,-40(s0)
    80200666:	00074703          	lbu	a4,0(a4)
    8020066a:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
            s++;
    8020066e:	fd843783          	ld	a5,-40(s0)
    80200672:	0785                	addi	a5,a5,1
    80200674:	fcf43c23          	sd	a5,-40(s0)
            sent_count++;
    80200678:	fec42783          	lw	a5,-20(s0)
    8020067c:	2785                	addiw	a5,a5,1
    8020067e:	fef42623          	sw	a5,-20(s0)
        while (*s && sent_count < 4) { 
    80200682:	fd843783          	ld	a5,-40(s0)
    80200686:	0007c783          	lbu	a5,0(a5)
    8020068a:	cb81                	beqz	a5,8020069a <uart_puts+0x6e>
    8020068c:	fec42783          	lw	a5,-20(s0)
    80200690:	0007871b          	sext.w	a4,a5
    80200694:	478d                	li	a5,3
    80200696:	fce7d4e3          	bge	a5,a4,8020065e <uart_puts+0x32>
    while (*s) {
    8020069a:	fd843783          	ld	a5,-40(s0)
    8020069e:	0007c783          	lbu	a5,0(a5)
    802006a2:	ffd1                	bnez	a5,8020063e <uart_puts+0x12>
    802006a4:	a011                	j	802006a8 <uart_puts+0x7c>
    if (!s) return;
    802006a6:	0001                	nop
        }
    }
}
    802006a8:	7422                	ld	s0,40(sp)
    802006aa:	6145                	addi	sp,sp,48
    802006ac:	8082                	ret

00000000802006ae <uart_getc>:

int uart_getc(void) {
    802006ae:	1141                	addi	sp,sp,-16
    802006b0:	e422                	sd	s0,8(sp)
    802006b2:	0800                	addi	s0,sp,16
    if ((ReadReg(LSR) & LSR_RX_READY) == 0)
    802006b4:	100007b7          	lui	a5,0x10000
    802006b8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    802006ba:	0007c783          	lbu	a5,0(a5)
    802006be:	0ff7f793          	zext.b	a5,a5
    802006c2:	2781                	sext.w	a5,a5
    802006c4:	8b85                	andi	a5,a5,1
    802006c6:	2781                	sext.w	a5,a5
    802006c8:	e399                	bnez	a5,802006ce <uart_getc+0x20>
        return -1; 
    802006ca:	57fd                	li	a5,-1
    802006cc:	a801                	j	802006dc <uart_getc+0x2e>
    return ReadReg(RHR); 
    802006ce:	100007b7          	lui	a5,0x10000
    802006d2:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    802006d6:	0ff7f793          	zext.b	a5,a5
    802006da:	2781                	sext.w	a5,a5
}
    802006dc:	853e                	mv	a0,a5
    802006de:	6422                	ld	s0,8(sp)
    802006e0:	0141                	addi	sp,sp,16
    802006e2:	8082                	ret

00000000802006e4 <uart_intr>:

void uart_intr(void) {
    802006e4:	1101                	addi	sp,sp,-32
    802006e6:	ec06                	sd	ra,24(sp)
    802006e8:	e822                	sd	s0,16(sp)
    802006ea:	1000                	addi	s0,sp,32
    static char linebuf[LINE_BUF_SIZE];
    static int line_len = 0;

    while (ReadReg(LSR) & LSR_RX_READY) {
    802006ec:	a2f5                	j	802008d8 <uart_intr+0x1f4>
        char c = ReadReg(RHR);
    802006ee:	100007b7          	lui	a5,0x10000
    802006f2:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    802006f6:	fef405a3          	sb	a5,-21(s0)

        if (c == '\r' || c == '\n') {
    802006fa:	feb44783          	lbu	a5,-21(s0)
    802006fe:	0ff7f713          	zext.b	a4,a5
    80200702:	47b5                	li	a5,13
    80200704:	00f70963          	beq	a4,a5,80200716 <uart_intr+0x32>
    80200708:	feb44783          	lbu	a5,-21(s0)
    8020070c:	0ff7f713          	zext.b	a4,a5
    80200710:	47a9                	li	a5,10
    80200712:	10f71763          	bne	a4,a5,80200820 <uart_intr+0x13c>
            uart_putc('\n');
    80200716:	4529                	li	a0,10
    80200718:	00000097          	auipc	ra,0x0
    8020071c:	eda080e7          	jalr	-294(ra) # 802005f2 <uart_putc>
            // 将编辑好的整行写入全局缓冲区
            for (int i = 0; i < line_len; i++) {
    80200720:	fe042623          	sw	zero,-20(s0)
    80200724:	a8b5                	j	802007a0 <uart_intr+0xbc>
                int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    80200726:	0000c797          	auipc	a5,0xc
    8020072a:	9aa78793          	addi	a5,a5,-1622 # 8020c0d0 <uart_input_buf>
    8020072e:	0847a783          	lw	a5,132(a5)
    80200732:	2785                	addiw	a5,a5,1
    80200734:	2781                	sext.w	a5,a5
    80200736:	2781                	sext.w	a5,a5
    80200738:	07f7f793          	andi	a5,a5,127
    8020073c:	fef42023          	sw	a5,-32(s0)
                if (next != uart_input_buf.r) {
    80200740:	0000c797          	auipc	a5,0xc
    80200744:	99078793          	addi	a5,a5,-1648 # 8020c0d0 <uart_input_buf>
    80200748:	0807a703          	lw	a4,128(a5)
    8020074c:	fe042783          	lw	a5,-32(s0)
    80200750:	04f70363          	beq	a4,a5,80200796 <uart_intr+0xb2>
                    uart_input_buf.buf[uart_input_buf.w] = linebuf[i];
    80200754:	0000c797          	auipc	a5,0xc
    80200758:	97c78793          	addi	a5,a5,-1668 # 8020c0d0 <uart_input_buf>
    8020075c:	0847a603          	lw	a2,132(a5)
    80200760:	0000c717          	auipc	a4,0xc
    80200764:	a0070713          	addi	a4,a4,-1536 # 8020c160 <linebuf.1>
    80200768:	fec42783          	lw	a5,-20(s0)
    8020076c:	97ba                	add	a5,a5,a4
    8020076e:	0007c703          	lbu	a4,0(a5)
    80200772:	0000c697          	auipc	a3,0xc
    80200776:	95e68693          	addi	a3,a3,-1698 # 8020c0d0 <uart_input_buf>
    8020077a:	02061793          	slli	a5,a2,0x20
    8020077e:	9381                	srli	a5,a5,0x20
    80200780:	97b6                	add	a5,a5,a3
    80200782:	00e78023          	sb	a4,0(a5)
                    uart_input_buf.w = next;
    80200786:	fe042703          	lw	a4,-32(s0)
    8020078a:	0000c797          	auipc	a5,0xc
    8020078e:	94678793          	addi	a5,a5,-1722 # 8020c0d0 <uart_input_buf>
    80200792:	08e7a223          	sw	a4,132(a5)
            for (int i = 0; i < line_len; i++) {
    80200796:	fec42783          	lw	a5,-20(s0)
    8020079a:	2785                	addiw	a5,a5,1
    8020079c:	fef42623          	sw	a5,-20(s0)
    802007a0:	0000c797          	auipc	a5,0xc
    802007a4:	a4078793          	addi	a5,a5,-1472 # 8020c1e0 <line_len.0>
    802007a8:	4398                	lw	a4,0(a5)
    802007aa:	fec42783          	lw	a5,-20(s0)
    802007ae:	2781                	sext.w	a5,a5
    802007b0:	f6e7cbe3          	blt	a5,a4,80200726 <uart_intr+0x42>
                }
            }
            // 写入换行符
            int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    802007b4:	0000c797          	auipc	a5,0xc
    802007b8:	91c78793          	addi	a5,a5,-1764 # 8020c0d0 <uart_input_buf>
    802007bc:	0847a783          	lw	a5,132(a5)
    802007c0:	2785                	addiw	a5,a5,1
    802007c2:	2781                	sext.w	a5,a5
    802007c4:	2781                	sext.w	a5,a5
    802007c6:	07f7f793          	andi	a5,a5,127
    802007ca:	fef42223          	sw	a5,-28(s0)
            if (next != uart_input_buf.r) {
    802007ce:	0000c797          	auipc	a5,0xc
    802007d2:	90278793          	addi	a5,a5,-1790 # 8020c0d0 <uart_input_buf>
    802007d6:	0807a703          	lw	a4,128(a5)
    802007da:	fe442783          	lw	a5,-28(s0)
    802007de:	02f70a63          	beq	a4,a5,80200812 <uart_intr+0x12e>
                uart_input_buf.buf[uart_input_buf.w] = '\n';
    802007e2:	0000c797          	auipc	a5,0xc
    802007e6:	8ee78793          	addi	a5,a5,-1810 # 8020c0d0 <uart_input_buf>
    802007ea:	0847a783          	lw	a5,132(a5)
    802007ee:	0000c717          	auipc	a4,0xc
    802007f2:	8e270713          	addi	a4,a4,-1822 # 8020c0d0 <uart_input_buf>
    802007f6:	1782                	slli	a5,a5,0x20
    802007f8:	9381                	srli	a5,a5,0x20
    802007fa:	97ba                	add	a5,a5,a4
    802007fc:	4729                	li	a4,10
    802007fe:	00e78023          	sb	a4,0(a5)
                uart_input_buf.w = next;
    80200802:	fe442703          	lw	a4,-28(s0)
    80200806:	0000c797          	auipc	a5,0xc
    8020080a:	8ca78793          	addi	a5,a5,-1846 # 8020c0d0 <uart_input_buf>
    8020080e:	08e7a223          	sw	a4,132(a5)
            }
            line_len = 0;
    80200812:	0000c797          	auipc	a5,0xc
    80200816:	9ce78793          	addi	a5,a5,-1586 # 8020c1e0 <line_len.0>
    8020081a:	0007a023          	sw	zero,0(a5)
        if (c == '\r' || c == '\n') {
    8020081e:	a86d                	j	802008d8 <uart_intr+0x1f4>
        } else if (c == 0x7f || c == 0x08) { // 退格
    80200820:	feb44783          	lbu	a5,-21(s0)
    80200824:	0ff7f713          	zext.b	a4,a5
    80200828:	07f00793          	li	a5,127
    8020082c:	00f70963          	beq	a4,a5,8020083e <uart_intr+0x15a>
    80200830:	feb44783          	lbu	a5,-21(s0)
    80200834:	0ff7f713          	zext.b	a4,a5
    80200838:	47a1                	li	a5,8
    8020083a:	04f71763          	bne	a4,a5,80200888 <uart_intr+0x1a4>
            if (line_len > 0) {
    8020083e:	0000c797          	auipc	a5,0xc
    80200842:	9a278793          	addi	a5,a5,-1630 # 8020c1e0 <line_len.0>
    80200846:	439c                	lw	a5,0(a5)
    80200848:	08f05863          	blez	a5,802008d8 <uart_intr+0x1f4>
                uart_putc('\b');
    8020084c:	4521                	li	a0,8
    8020084e:	00000097          	auipc	ra,0x0
    80200852:	da4080e7          	jalr	-604(ra) # 802005f2 <uart_putc>
                uart_putc(' ');
    80200856:	02000513          	li	a0,32
    8020085a:	00000097          	auipc	ra,0x0
    8020085e:	d98080e7          	jalr	-616(ra) # 802005f2 <uart_putc>
                uart_putc('\b');
    80200862:	4521                	li	a0,8
    80200864:	00000097          	auipc	ra,0x0
    80200868:	d8e080e7          	jalr	-626(ra) # 802005f2 <uart_putc>
                line_len--;
    8020086c:	0000c797          	auipc	a5,0xc
    80200870:	97478793          	addi	a5,a5,-1676 # 8020c1e0 <line_len.0>
    80200874:	439c                	lw	a5,0(a5)
    80200876:	37fd                	addiw	a5,a5,-1
    80200878:	0007871b          	sext.w	a4,a5
    8020087c:	0000c797          	auipc	a5,0xc
    80200880:	96478793          	addi	a5,a5,-1692 # 8020c1e0 <line_len.0>
    80200884:	c398                	sw	a4,0(a5)
            if (line_len > 0) {
    80200886:	a889                	j	802008d8 <uart_intr+0x1f4>
            }
        } else if (line_len < LINE_BUF_SIZE - 1) {
    80200888:	0000c797          	auipc	a5,0xc
    8020088c:	95878793          	addi	a5,a5,-1704 # 8020c1e0 <line_len.0>
    80200890:	439c                	lw	a5,0(a5)
    80200892:	873e                	mv	a4,a5
    80200894:	07e00793          	li	a5,126
    80200898:	04e7c063          	blt	a5,a4,802008d8 <uart_intr+0x1f4>
            uart_putc(c);
    8020089c:	feb44783          	lbu	a5,-21(s0)
    802008a0:	853e                	mv	a0,a5
    802008a2:	00000097          	auipc	ra,0x0
    802008a6:	d50080e7          	jalr	-688(ra) # 802005f2 <uart_putc>
            linebuf[line_len++] = c;
    802008aa:	0000c797          	auipc	a5,0xc
    802008ae:	93678793          	addi	a5,a5,-1738 # 8020c1e0 <line_len.0>
    802008b2:	439c                	lw	a5,0(a5)
    802008b4:	0017871b          	addiw	a4,a5,1
    802008b8:	0007069b          	sext.w	a3,a4
    802008bc:	0000c717          	auipc	a4,0xc
    802008c0:	92470713          	addi	a4,a4,-1756 # 8020c1e0 <line_len.0>
    802008c4:	c314                	sw	a3,0(a4)
    802008c6:	0000c717          	auipc	a4,0xc
    802008ca:	89a70713          	addi	a4,a4,-1894 # 8020c160 <linebuf.1>
    802008ce:	97ba                	add	a5,a5,a4
    802008d0:	feb44703          	lbu	a4,-21(s0)
    802008d4:	00e78023          	sb	a4,0(a5)
    while (ReadReg(LSR) & LSR_RX_READY) {
    802008d8:	100007b7          	lui	a5,0x10000
    802008dc:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    802008de:	0007c783          	lbu	a5,0(a5)
    802008e2:	0ff7f793          	zext.b	a5,a5
    802008e6:	2781                	sext.w	a5,a5
    802008e8:	8b85                	andi	a5,a5,1
    802008ea:	2781                	sext.w	a5,a5
    802008ec:	e00791e3          	bnez	a5,802006ee <uart_intr+0xa>
        }
    }
}
    802008f0:	0001                	nop
    802008f2:	0001                	nop
    802008f4:	60e2                	ld	ra,24(sp)
    802008f6:	6442                	ld	s0,16(sp)
    802008f8:	6105                	addi	sp,sp,32
    802008fa:	8082                	ret

00000000802008fc <uart_getc_blocking>:
// 阻塞式读取一个字符
char uart_getc_blocking(void) {
    802008fc:	1101                	addi	sp,sp,-32
    802008fe:	ec22                	sd	s0,24(sp)
    80200900:	1000                	addi	s0,sp,32
    // 等待直到有字符可读
    while (uart_input_buf.r == uart_input_buf.w) {
    80200902:	a011                	j	80200906 <uart_getc_blocking+0xa>
        // 在实际系统中，这里可能需要让进程睡眠
        // 但目前我们使用简单的轮询
        asm volatile("nop");
    80200904:	0001                	nop
    while (uart_input_buf.r == uart_input_buf.w) {
    80200906:	0000b797          	auipc	a5,0xb
    8020090a:	7ca78793          	addi	a5,a5,1994 # 8020c0d0 <uart_input_buf>
    8020090e:	0807a703          	lw	a4,128(a5)
    80200912:	0000b797          	auipc	a5,0xb
    80200916:	7be78793          	addi	a5,a5,1982 # 8020c0d0 <uart_input_buf>
    8020091a:	0847a783          	lw	a5,132(a5)
    8020091e:	fef703e3          	beq	a4,a5,80200904 <uart_getc_blocking+0x8>
    }
    
    // 读取字符
    char c = uart_input_buf.buf[uart_input_buf.r];
    80200922:	0000b797          	auipc	a5,0xb
    80200926:	7ae78793          	addi	a5,a5,1966 # 8020c0d0 <uart_input_buf>
    8020092a:	0807a783          	lw	a5,128(a5)
    8020092e:	0000b717          	auipc	a4,0xb
    80200932:	7a270713          	addi	a4,a4,1954 # 8020c0d0 <uart_input_buf>
    80200936:	1782                	slli	a5,a5,0x20
    80200938:	9381                	srli	a5,a5,0x20
    8020093a:	97ba                	add	a5,a5,a4
    8020093c:	0007c783          	lbu	a5,0(a5)
    80200940:	fef407a3          	sb	a5,-17(s0)
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    80200944:	0000b797          	auipc	a5,0xb
    80200948:	78c78793          	addi	a5,a5,1932 # 8020c0d0 <uart_input_buf>
    8020094c:	0807a783          	lw	a5,128(a5)
    80200950:	2785                	addiw	a5,a5,1
    80200952:	2781                	sext.w	a5,a5
    80200954:	07f7f793          	andi	a5,a5,127
    80200958:	0007871b          	sext.w	a4,a5
    8020095c:	0000b797          	auipc	a5,0xb
    80200960:	77478793          	addi	a5,a5,1908 # 8020c0d0 <uart_input_buf>
    80200964:	08e7a023          	sw	a4,128(a5)
    return c;
    80200968:	fef44783          	lbu	a5,-17(s0)
}
    8020096c:	853e                	mv	a0,a5
    8020096e:	6462                	ld	s0,24(sp)
    80200970:	6105                	addi	sp,sp,32
    80200972:	8082                	ret

0000000080200974 <readline>:
// 读取一行输入，最多读取max-1个字符，并在末尾添加\0
int readline(char *buf, int max) {
    80200974:	7179                	addi	sp,sp,-48
    80200976:	f406                	sd	ra,40(sp)
    80200978:	f022                	sd	s0,32(sp)
    8020097a:	1800                	addi	s0,sp,48
    8020097c:	fca43c23          	sd	a0,-40(s0)
    80200980:	87ae                	mv	a5,a1
    80200982:	fcf42a23          	sw	a5,-44(s0)
    int i = 0;
    80200986:	fe042623          	sw	zero,-20(s0)
    char c;
    
    while (i < max - 1) {
    8020098a:	a0b9                	j	802009d8 <readline+0x64>
        c = uart_getc_blocking();
    8020098c:	00000097          	auipc	ra,0x0
    80200990:	f70080e7          	jalr	-144(ra) # 802008fc <uart_getc_blocking>
    80200994:	87aa                	mv	a5,a0
    80200996:	fef405a3          	sb	a5,-21(s0)
        
        if (c == '\n') {
    8020099a:	feb44783          	lbu	a5,-21(s0)
    8020099e:	0ff7f713          	zext.b	a4,a5
    802009a2:	47a9                	li	a5,10
    802009a4:	00f71c63          	bne	a4,a5,802009bc <readline+0x48>
            buf[i] = '\0';
    802009a8:	fec42783          	lw	a5,-20(s0)
    802009ac:	fd843703          	ld	a4,-40(s0)
    802009b0:	97ba                	add	a5,a5,a4
    802009b2:	00078023          	sb	zero,0(a5)
            return i;
    802009b6:	fec42783          	lw	a5,-20(s0)
    802009ba:	a0a9                	j	80200a04 <readline+0x90>
        } else {
            buf[i++] = c;
    802009bc:	fec42783          	lw	a5,-20(s0)
    802009c0:	0017871b          	addiw	a4,a5,1
    802009c4:	fee42623          	sw	a4,-20(s0)
    802009c8:	873e                	mv	a4,a5
    802009ca:	fd843783          	ld	a5,-40(s0)
    802009ce:	97ba                	add	a5,a5,a4
    802009d0:	feb44703          	lbu	a4,-21(s0)
    802009d4:	00e78023          	sb	a4,0(a5)
    while (i < max - 1) {
    802009d8:	fd442783          	lw	a5,-44(s0)
    802009dc:	37fd                	addiw	a5,a5,-1
    802009de:	0007871b          	sext.w	a4,a5
    802009e2:	fec42783          	lw	a5,-20(s0)
    802009e6:	2781                	sext.w	a5,a5
    802009e8:	fae7c2e3          	blt	a5,a4,8020098c <readline+0x18>
        }
    }
    
    // 缓冲区满，添加\0并返回
    buf[max-1] = '\0';
    802009ec:	fd442783          	lw	a5,-44(s0)
    802009f0:	17fd                	addi	a5,a5,-1
    802009f2:	fd843703          	ld	a4,-40(s0)
    802009f6:	97ba                	add	a5,a5,a4
    802009f8:	00078023          	sb	zero,0(a5)
    return max-1;
    802009fc:	fd442783          	lw	a5,-44(s0)
    80200a00:	37fd                	addiw	a5,a5,-1
    80200a02:	2781                	sext.w	a5,a5
    80200a04:	853e                	mv	a0,a5
    80200a06:	70a2                	ld	ra,40(sp)
    80200a08:	7402                	ld	s0,32(sp)
    80200a0a:	6145                	addi	sp,sp,48
    80200a0c:	8082                	ret

0000000080200a0e <flush_printf_buffer>:

extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    80200a0e:	1141                	addi	sp,sp,-16
    80200a10:	e406                	sd	ra,8(sp)
    80200a12:	e022                	sd	s0,0(sp)
    80200a14:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    80200a16:	0000c797          	auipc	a5,0xc
    80200a1a:	85278793          	addi	a5,a5,-1966 # 8020c268 <printf_buf_pos>
    80200a1e:	439c                	lw	a5,0(a5)
    80200a20:	02f05c63          	blez	a5,80200a58 <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200a24:	0000c797          	auipc	a5,0xc
    80200a28:	84478793          	addi	a5,a5,-1980 # 8020c268 <printf_buf_pos>
    80200a2c:	439c                	lw	a5,0(a5)
    80200a2e:	0000b717          	auipc	a4,0xb
    80200a32:	7ba70713          	addi	a4,a4,1978 # 8020c1e8 <printf_buffer>
    80200a36:	97ba                	add	a5,a5,a4
    80200a38:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80200a3c:	0000b517          	auipc	a0,0xb
    80200a40:	7ac50513          	addi	a0,a0,1964 # 8020c1e8 <printf_buffer>
    80200a44:	00000097          	auipc	ra,0x0
    80200a48:	be8080e7          	jalr	-1048(ra) # 8020062c <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200a4c:	0000c797          	auipc	a5,0xc
    80200a50:	81c78793          	addi	a5,a5,-2020 # 8020c268 <printf_buf_pos>
    80200a54:	0007a023          	sw	zero,0(a5)
	}
}
    80200a58:	0001                	nop
    80200a5a:	60a2                	ld	ra,8(sp)
    80200a5c:	6402                	ld	s0,0(sp)
    80200a5e:	0141                	addi	sp,sp,16
    80200a60:	8082                	ret

0000000080200a62 <buffer_char>:
static void buffer_char(char c) {
    80200a62:	1101                	addi	sp,sp,-32
    80200a64:	ec06                	sd	ra,24(sp)
    80200a66:	e822                	sd	s0,16(sp)
    80200a68:	1000                	addi	s0,sp,32
    80200a6a:	87aa                	mv	a5,a0
    80200a6c:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    80200a70:	0000b797          	auipc	a5,0xb
    80200a74:	7f878793          	addi	a5,a5,2040 # 8020c268 <printf_buf_pos>
    80200a78:	439c                	lw	a5,0(a5)
    80200a7a:	873e                	mv	a4,a5
    80200a7c:	07e00793          	li	a5,126
    80200a80:	02e7ca63          	blt	a5,a4,80200ab4 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200a84:	0000b797          	auipc	a5,0xb
    80200a88:	7e478793          	addi	a5,a5,2020 # 8020c268 <printf_buf_pos>
    80200a8c:	439c                	lw	a5,0(a5)
    80200a8e:	0017871b          	addiw	a4,a5,1
    80200a92:	0007069b          	sext.w	a3,a4
    80200a96:	0000b717          	auipc	a4,0xb
    80200a9a:	7d270713          	addi	a4,a4,2002 # 8020c268 <printf_buf_pos>
    80200a9e:	c314                	sw	a3,0(a4)
    80200aa0:	0000b717          	auipc	a4,0xb
    80200aa4:	74870713          	addi	a4,a4,1864 # 8020c1e8 <printf_buffer>
    80200aa8:	97ba                	add	a5,a5,a4
    80200aaa:	fef44703          	lbu	a4,-17(s0)
    80200aae:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    80200ab2:	a825                	j	80200aea <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    80200ab4:	00000097          	auipc	ra,0x0
    80200ab8:	f5a080e7          	jalr	-166(ra) # 80200a0e <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    80200abc:	0000b797          	auipc	a5,0xb
    80200ac0:	7ac78793          	addi	a5,a5,1964 # 8020c268 <printf_buf_pos>
    80200ac4:	439c                	lw	a5,0(a5)
    80200ac6:	0017871b          	addiw	a4,a5,1
    80200aca:	0007069b          	sext.w	a3,a4
    80200ace:	0000b717          	auipc	a4,0xb
    80200ad2:	79a70713          	addi	a4,a4,1946 # 8020c268 <printf_buf_pos>
    80200ad6:	c314                	sw	a3,0(a4)
    80200ad8:	0000b717          	auipc	a4,0xb
    80200adc:	71070713          	addi	a4,a4,1808 # 8020c1e8 <printf_buffer>
    80200ae0:	97ba                	add	a5,a5,a4
    80200ae2:	fef44703          	lbu	a4,-17(s0)
    80200ae6:	00e78023          	sb	a4,0(a5)
}
    80200aea:	0001                	nop
    80200aec:	60e2                	ld	ra,24(sp)
    80200aee:	6442                	ld	s0,16(sp)
    80200af0:	6105                	addi	sp,sp,32
    80200af2:	8082                	ret

0000000080200af4 <consputc>:

static void consputc(int c){
    80200af4:	1101                	addi	sp,sp,-32
    80200af6:	ec06                	sd	ra,24(sp)
    80200af8:	e822                	sd	s0,16(sp)
    80200afa:	1000                	addi	s0,sp,32
    80200afc:	87aa                	mv	a5,a0
    80200afe:	fef42623          	sw	a5,-20(s0)
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
    80200b02:	fec42783          	lw	a5,-20(s0)
    80200b06:	0ff7f793          	zext.b	a5,a5
    80200b0a:	853e                	mv	a0,a5
    80200b0c:	00000097          	auipc	ra,0x0
    80200b10:	ae6080e7          	jalr	-1306(ra) # 802005f2 <uart_putc>
}
    80200b14:	0001                	nop
    80200b16:	60e2                	ld	ra,24(sp)
    80200b18:	6442                	ld	s0,16(sp)
    80200b1a:	6105                	addi	sp,sp,32
    80200b1c:	8082                	ret

0000000080200b1e <consputs>:
static void consputs(const char *s){
    80200b1e:	7179                	addi	sp,sp,-48
    80200b20:	f406                	sd	ra,40(sp)
    80200b22:	f022                	sd	s0,32(sp)
    80200b24:	1800                	addi	s0,sp,48
    80200b26:	fca43c23          	sd	a0,-40(s0)
	char *str = (char *)s;
    80200b2a:	fd843783          	ld	a5,-40(s0)
    80200b2e:	fef43423          	sd	a5,-24(s0)
	// 直接调用uart_puts输出字符串
	uart_puts(str);
    80200b32:	fe843503          	ld	a0,-24(s0)
    80200b36:	00000097          	auipc	ra,0x0
    80200b3a:	af6080e7          	jalr	-1290(ra) # 8020062c <uart_puts>
}
    80200b3e:	0001                	nop
    80200b40:	70a2                	ld	ra,40(sp)
    80200b42:	7402                	ld	s0,32(sp)
    80200b44:	6145                	addi	sp,sp,48
    80200b46:	8082                	ret

0000000080200b48 <printint>:
static void printint(long long xx, int base, int sign, int width, int padzero){
    80200b48:	7159                	addi	sp,sp,-112
    80200b4a:	f486                	sd	ra,104(sp)
    80200b4c:	f0a2                	sd	s0,96(sp)
    80200b4e:	1880                	addi	s0,sp,112
    80200b50:	faa43423          	sd	a0,-88(s0)
    80200b54:	87ae                	mv	a5,a1
    80200b56:	faf42223          	sw	a5,-92(s0)
    80200b5a:	87b2                	mv	a5,a2
    80200b5c:	faf42023          	sw	a5,-96(s0)
    80200b60:	87b6                	mv	a5,a3
    80200b62:	f8f42e23          	sw	a5,-100(s0)
    80200b66:	87ba                	mv	a5,a4
    80200b68:	f8f42c23          	sw	a5,-104(s0)
    static char digits[] = "0123456789abcdef";
    char buf[32];
    int i = 0;
    80200b6c:	fe042623          	sw	zero,-20(s0)
    unsigned long long x;

    if (sign && (sign = xx < 0))
    80200b70:	fa042783          	lw	a5,-96(s0)
    80200b74:	2781                	sext.w	a5,a5
    80200b76:	c39d                	beqz	a5,80200b9c <printint+0x54>
    80200b78:	fa843783          	ld	a5,-88(s0)
    80200b7c:	93fd                	srli	a5,a5,0x3f
    80200b7e:	0ff7f793          	zext.b	a5,a5
    80200b82:	faf42023          	sw	a5,-96(s0)
    80200b86:	fa042783          	lw	a5,-96(s0)
    80200b8a:	2781                	sext.w	a5,a5
    80200b8c:	cb81                	beqz	a5,80200b9c <printint+0x54>
        x = -(unsigned long long)xx;
    80200b8e:	fa843783          	ld	a5,-88(s0)
    80200b92:	40f007b3          	neg	a5,a5
    80200b96:	fef43023          	sd	a5,-32(s0)
    80200b9a:	a029                	j	80200ba4 <printint+0x5c>
    else
        x = xx;
    80200b9c:	fa843783          	ld	a5,-88(s0)
    80200ba0:	fef43023          	sd	a5,-32(s0)

    do {
        buf[i++] = digits[x % base];
    80200ba4:	fa442783          	lw	a5,-92(s0)
    80200ba8:	fe043703          	ld	a4,-32(s0)
    80200bac:	02f77733          	remu	a4,a4,a5
    80200bb0:	fec42783          	lw	a5,-20(s0)
    80200bb4:	0017869b          	addiw	a3,a5,1
    80200bb8:	fed42623          	sw	a3,-20(s0)
    80200bbc:	0000b697          	auipc	a3,0xb
    80200bc0:	4bc68693          	addi	a3,a3,1212 # 8020c078 <digits.0>
    80200bc4:	9736                	add	a4,a4,a3
    80200bc6:	00074703          	lbu	a4,0(a4)
    80200bca:	17c1                	addi	a5,a5,-16
    80200bcc:	97a2                	add	a5,a5,s0
    80200bce:	fce78423          	sb	a4,-56(a5)
    } while ((x /= base) != 0);
    80200bd2:	fa442783          	lw	a5,-92(s0)
    80200bd6:	fe043703          	ld	a4,-32(s0)
    80200bda:	02f757b3          	divu	a5,a4,a5
    80200bde:	fef43023          	sd	a5,-32(s0)
    80200be2:	fe043783          	ld	a5,-32(s0)
    80200be6:	ffdd                	bnez	a5,80200ba4 <printint+0x5c>

    if (sign)
    80200be8:	fa042783          	lw	a5,-96(s0)
    80200bec:	2781                	sext.w	a5,a5
    80200bee:	cf89                	beqz	a5,80200c08 <printint+0xc0>
        buf[i++] = '-';
    80200bf0:	fec42783          	lw	a5,-20(s0)
    80200bf4:	0017871b          	addiw	a4,a5,1
    80200bf8:	fee42623          	sw	a4,-20(s0)
    80200bfc:	17c1                	addi	a5,a5,-16
    80200bfe:	97a2                	add	a5,a5,s0
    80200c00:	02d00713          	li	a4,45
    80200c04:	fce78423          	sb	a4,-56(a5)

    // 计算需要补的填充字符数
    int pad = width - i;
    80200c08:	f9c42783          	lw	a5,-100(s0)
    80200c0c:	873e                	mv	a4,a5
    80200c0e:	fec42783          	lw	a5,-20(s0)
    80200c12:	40f707bb          	subw	a5,a4,a5
    80200c16:	fcf42e23          	sw	a5,-36(s0)
    while (pad-- > 0) {
    80200c1a:	a839                	j	80200c38 <printint+0xf0>
        consputc(padzero ? '0' : ' ');
    80200c1c:	f9842783          	lw	a5,-104(s0)
    80200c20:	2781                	sext.w	a5,a5
    80200c22:	c781                	beqz	a5,80200c2a <printint+0xe2>
    80200c24:	03000793          	li	a5,48
    80200c28:	a019                	j	80200c2e <printint+0xe6>
    80200c2a:	02000793          	li	a5,32
    80200c2e:	853e                	mv	a0,a5
    80200c30:	00000097          	auipc	ra,0x0
    80200c34:	ec4080e7          	jalr	-316(ra) # 80200af4 <consputc>
    while (pad-- > 0) {
    80200c38:	fdc42783          	lw	a5,-36(s0)
    80200c3c:	fff7871b          	addiw	a4,a5,-1
    80200c40:	fce42e23          	sw	a4,-36(s0)
    80200c44:	fcf04ce3          	bgtz	a5,80200c1c <printint+0xd4>
    }

    while (--i >= 0)
    80200c48:	a829                	j	80200c62 <printint+0x11a>
        consputc(buf[i]);
    80200c4a:	fec42783          	lw	a5,-20(s0)
    80200c4e:	17c1                	addi	a5,a5,-16
    80200c50:	97a2                	add	a5,a5,s0
    80200c52:	fc87c783          	lbu	a5,-56(a5)
    80200c56:	2781                	sext.w	a5,a5
    80200c58:	853e                	mv	a0,a5
    80200c5a:	00000097          	auipc	ra,0x0
    80200c5e:	e9a080e7          	jalr	-358(ra) # 80200af4 <consputc>
    while (--i >= 0)
    80200c62:	fec42783          	lw	a5,-20(s0)
    80200c66:	37fd                	addiw	a5,a5,-1
    80200c68:	fef42623          	sw	a5,-20(s0)
    80200c6c:	fec42783          	lw	a5,-20(s0)
    80200c70:	2781                	sext.w	a5,a5
    80200c72:	fc07dce3          	bgez	a5,80200c4a <printint+0x102>
}
    80200c76:	0001                	nop
    80200c78:	0001                	nop
    80200c7a:	70a6                	ld	ra,104(sp)
    80200c7c:	7406                	ld	s0,96(sp)
    80200c7e:	6165                	addi	sp,sp,112
    80200c80:	8082                	ret

0000000080200c82 <printf>:
void printf(const char *fmt, ...) {
    80200c82:	7171                	addi	sp,sp,-176
    80200c84:	f486                	sd	ra,104(sp)
    80200c86:	f0a2                	sd	s0,96(sp)
    80200c88:	1880                	addi	s0,sp,112
    80200c8a:	f8a43c23          	sd	a0,-104(s0)
    80200c8e:	e40c                	sd	a1,8(s0)
    80200c90:	e810                	sd	a2,16(s0)
    80200c92:	ec14                	sd	a3,24(s0)
    80200c94:	f018                	sd	a4,32(s0)
    80200c96:	f41c                	sd	a5,40(s0)
    80200c98:	03043823          	sd	a6,48(s0)
    80200c9c:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    80200ca0:	04040793          	addi	a5,s0,64
    80200ca4:	f8f43823          	sd	a5,-112(s0)
    80200ca8:	f9043783          	ld	a5,-112(s0)
    80200cac:	fc878793          	addi	a5,a5,-56
    80200cb0:	faf43c23          	sd	a5,-72(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200cb4:	fe042623          	sw	zero,-20(s0)
    80200cb8:	a945                	j	80201168 <printf+0x4e6>
        if(c != '%'){
    80200cba:	fe842783          	lw	a5,-24(s0)
    80200cbe:	0007871b          	sext.w	a4,a5
    80200cc2:	02500793          	li	a5,37
    80200cc6:	00f70c63          	beq	a4,a5,80200cde <printf+0x5c>
            buffer_char(c);
    80200cca:	fe842783          	lw	a5,-24(s0)
    80200cce:	0ff7f793          	zext.b	a5,a5
    80200cd2:	853e                	mv	a0,a5
    80200cd4:	00000097          	auipc	ra,0x0
    80200cd8:	d8e080e7          	jalr	-626(ra) # 80200a62 <buffer_char>
            continue;
    80200cdc:	a149                	j	8020115e <printf+0x4dc>
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    80200cde:	00000097          	auipc	ra,0x0
    80200ce2:	d30080e7          	jalr	-720(ra) # 80200a0e <flush_printf_buffer>
		// 解析填充标志和宽度
        int padzero = 0, width = 0;
    80200ce6:	fc042e23          	sw	zero,-36(s0)
    80200cea:	fc042c23          	sw	zero,-40(s0)
        c = fmt[++i] & 0xff;
    80200cee:	fec42783          	lw	a5,-20(s0)
    80200cf2:	2785                	addiw	a5,a5,1
    80200cf4:	fef42623          	sw	a5,-20(s0)
    80200cf8:	fec42783          	lw	a5,-20(s0)
    80200cfc:	f9843703          	ld	a4,-104(s0)
    80200d00:	97ba                	add	a5,a5,a4
    80200d02:	0007c783          	lbu	a5,0(a5)
    80200d06:	fef42423          	sw	a5,-24(s0)
        if (c == '0') {
    80200d0a:	fe842783          	lw	a5,-24(s0)
    80200d0e:	0007871b          	sext.w	a4,a5
    80200d12:	03000793          	li	a5,48
    80200d16:	06f71563          	bne	a4,a5,80200d80 <printf+0xfe>
            padzero = 1;
    80200d1a:	4785                	li	a5,1
    80200d1c:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    80200d20:	fec42783          	lw	a5,-20(s0)
    80200d24:	2785                	addiw	a5,a5,1
    80200d26:	fef42623          	sw	a5,-20(s0)
    80200d2a:	fec42783          	lw	a5,-20(s0)
    80200d2e:	f9843703          	ld	a4,-104(s0)
    80200d32:	97ba                	add	a5,a5,a4
    80200d34:	0007c783          	lbu	a5,0(a5)
    80200d38:	fef42423          	sw	a5,-24(s0)
        }
        while (c >= '0' && c <= '9') {
    80200d3c:	a091                	j	80200d80 <printf+0xfe>
            width = width * 10 + (c - '0');
    80200d3e:	fd842783          	lw	a5,-40(s0)
    80200d42:	873e                	mv	a4,a5
    80200d44:	87ba                	mv	a5,a4
    80200d46:	0027979b          	slliw	a5,a5,0x2
    80200d4a:	9fb9                	addw	a5,a5,a4
    80200d4c:	0017979b          	slliw	a5,a5,0x1
    80200d50:	0007871b          	sext.w	a4,a5
    80200d54:	fe842783          	lw	a5,-24(s0)
    80200d58:	fd07879b          	addiw	a5,a5,-48
    80200d5c:	2781                	sext.w	a5,a5
    80200d5e:	9fb9                	addw	a5,a5,a4
    80200d60:	fcf42c23          	sw	a5,-40(s0)
            c = fmt[++i] & 0xff;
    80200d64:	fec42783          	lw	a5,-20(s0)
    80200d68:	2785                	addiw	a5,a5,1
    80200d6a:	fef42623          	sw	a5,-20(s0)
    80200d6e:	fec42783          	lw	a5,-20(s0)
    80200d72:	f9843703          	ld	a4,-104(s0)
    80200d76:	97ba                	add	a5,a5,a4
    80200d78:	0007c783          	lbu	a5,0(a5)
    80200d7c:	fef42423          	sw	a5,-24(s0)
        while (c >= '0' && c <= '9') {
    80200d80:	fe842783          	lw	a5,-24(s0)
    80200d84:	0007871b          	sext.w	a4,a5
    80200d88:	02f00793          	li	a5,47
    80200d8c:	00e7da63          	bge	a5,a4,80200da0 <printf+0x11e>
    80200d90:	fe842783          	lw	a5,-24(s0)
    80200d94:	0007871b          	sext.w	a4,a5
    80200d98:	03900793          	li	a5,57
    80200d9c:	fae7d1e3          	bge	a5,a4,80200d3e <printf+0xbc>
        }
        // 检查是否有长整型标记'l'
        int is_long = 0;
    80200da0:	fc042a23          	sw	zero,-44(s0)
        if(c == 'l') {
    80200da4:	fe842783          	lw	a5,-24(s0)
    80200da8:	0007871b          	sext.w	a4,a5
    80200dac:	06c00793          	li	a5,108
    80200db0:	02f71863          	bne	a4,a5,80200de0 <printf+0x15e>
            is_long = 1;
    80200db4:	4785                	li	a5,1
    80200db6:	fcf42a23          	sw	a5,-44(s0)
            c = fmt[++i] & 0xff;
    80200dba:	fec42783          	lw	a5,-20(s0)
    80200dbe:	2785                	addiw	a5,a5,1
    80200dc0:	fef42623          	sw	a5,-20(s0)
    80200dc4:	fec42783          	lw	a5,-20(s0)
    80200dc8:	f9843703          	ld	a4,-104(s0)
    80200dcc:	97ba                	add	a5,a5,a4
    80200dce:	0007c783          	lbu	a5,0(a5)
    80200dd2:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    80200dd6:	fe842783          	lw	a5,-24(s0)
    80200dda:	2781                	sext.w	a5,a5
    80200ddc:	3a078563          	beqz	a5,80201186 <printf+0x504>
                break;
        }
        
        switch(c){
    80200de0:	fe842783          	lw	a5,-24(s0)
    80200de4:	0007871b          	sext.w	a4,a5
    80200de8:	02500793          	li	a5,37
    80200dec:	2ef70d63          	beq	a4,a5,802010e6 <printf+0x464>
    80200df0:	fe842783          	lw	a5,-24(s0)
    80200df4:	0007871b          	sext.w	a4,a5
    80200df8:	02500793          	li	a5,37
    80200dfc:	2ef74c63          	blt	a4,a5,802010f4 <printf+0x472>
    80200e00:	fe842783          	lw	a5,-24(s0)
    80200e04:	0007871b          	sext.w	a4,a5
    80200e08:	07800793          	li	a5,120
    80200e0c:	2ee7c463          	blt	a5,a4,802010f4 <printf+0x472>
    80200e10:	fe842783          	lw	a5,-24(s0)
    80200e14:	0007871b          	sext.w	a4,a5
    80200e18:	06200793          	li	a5,98
    80200e1c:	2cf74c63          	blt	a4,a5,802010f4 <printf+0x472>
    80200e20:	fe842783          	lw	a5,-24(s0)
    80200e24:	f9e7869b          	addiw	a3,a5,-98
    80200e28:	0006871b          	sext.w	a4,a3
    80200e2c:	47d9                	li	a5,22
    80200e2e:	2ce7e363          	bltu	a5,a4,802010f4 <printf+0x472>
    80200e32:	02069793          	slli	a5,a3,0x20
    80200e36:	9381                	srli	a5,a5,0x20
    80200e38:	00279713          	slli	a4,a5,0x2
    80200e3c:	00006797          	auipc	a5,0x6
    80200e40:	60078793          	addi	a5,a5,1536 # 8020743c <etext+0x43c>
    80200e44:	97ba                	add	a5,a5,a4
    80200e46:	439c                	lw	a5,0(a5)
    80200e48:	0007871b          	sext.w	a4,a5
    80200e4c:	00006797          	auipc	a5,0x6
    80200e50:	5f078793          	addi	a5,a5,1520 # 8020743c <etext+0x43c>
    80200e54:	97ba                	add	a5,a5,a4
    80200e56:	8782                	jr	a5
        case 'd':
            if(is_long)
    80200e58:	fd442783          	lw	a5,-44(s0)
    80200e5c:	2781                	sext.w	a5,a5
    80200e5e:	c785                	beqz	a5,80200e86 <printf+0x204>
                printint(va_arg(ap, long long), 10, 1, width, padzero);
    80200e60:	fb843783          	ld	a5,-72(s0)
    80200e64:	00878713          	addi	a4,a5,8
    80200e68:	fae43c23          	sd	a4,-72(s0)
    80200e6c:	639c                	ld	a5,0(a5)
    80200e6e:	fdc42703          	lw	a4,-36(s0)
    80200e72:	fd842683          	lw	a3,-40(s0)
    80200e76:	4605                	li	a2,1
    80200e78:	45a9                	li	a1,10
    80200e7a:	853e                	mv	a0,a5
    80200e7c:	00000097          	auipc	ra,0x0
    80200e80:	ccc080e7          	jalr	-820(ra) # 80200b48 <printint>
            else
                printint(va_arg(ap, int), 10, 1, width, padzero);
            break;
    80200e84:	ace9                	j	8020115e <printf+0x4dc>
                printint(va_arg(ap, int), 10, 1, width, padzero);
    80200e86:	fb843783          	ld	a5,-72(s0)
    80200e8a:	00878713          	addi	a4,a5,8
    80200e8e:	fae43c23          	sd	a4,-72(s0)
    80200e92:	439c                	lw	a5,0(a5)
    80200e94:	853e                	mv	a0,a5
    80200e96:	fdc42703          	lw	a4,-36(s0)
    80200e9a:	fd842783          	lw	a5,-40(s0)
    80200e9e:	86be                	mv	a3,a5
    80200ea0:	4605                	li	a2,1
    80200ea2:	45a9                	li	a1,10
    80200ea4:	00000097          	auipc	ra,0x0
    80200ea8:	ca4080e7          	jalr	-860(ra) # 80200b48 <printint>
            break;
    80200eac:	ac4d                	j	8020115e <printf+0x4dc>
        case 'x':
            if(is_long)
    80200eae:	fd442783          	lw	a5,-44(s0)
    80200eb2:	2781                	sext.w	a5,a5
    80200eb4:	c785                	beqz	a5,80200edc <printf+0x25a>
                printint(va_arg(ap, long long), 16, 0, width, padzero);
    80200eb6:	fb843783          	ld	a5,-72(s0)
    80200eba:	00878713          	addi	a4,a5,8
    80200ebe:	fae43c23          	sd	a4,-72(s0)
    80200ec2:	639c                	ld	a5,0(a5)
    80200ec4:	fdc42703          	lw	a4,-36(s0)
    80200ec8:	fd842683          	lw	a3,-40(s0)
    80200ecc:	4601                	li	a2,0
    80200ece:	45c1                	li	a1,16
    80200ed0:	853e                	mv	a0,a5
    80200ed2:	00000097          	auipc	ra,0x0
    80200ed6:	c76080e7          	jalr	-906(ra) # 80200b48 <printint>
            else
                printint(va_arg(ap, int), 16, 0, width, padzero);
            break;
    80200eda:	a451                	j	8020115e <printf+0x4dc>
                printint(va_arg(ap, int), 16, 0, width, padzero);
    80200edc:	fb843783          	ld	a5,-72(s0)
    80200ee0:	00878713          	addi	a4,a5,8
    80200ee4:	fae43c23          	sd	a4,-72(s0)
    80200ee8:	439c                	lw	a5,0(a5)
    80200eea:	853e                	mv	a0,a5
    80200eec:	fdc42703          	lw	a4,-36(s0)
    80200ef0:	fd842783          	lw	a5,-40(s0)
    80200ef4:	86be                	mv	a3,a5
    80200ef6:	4601                	li	a2,0
    80200ef8:	45c1                	li	a1,16
    80200efa:	00000097          	auipc	ra,0x0
    80200efe:	c4e080e7          	jalr	-946(ra) # 80200b48 <printint>
            break;
    80200f02:	acb1                	j	8020115e <printf+0x4dc>
        case 'u':
            if(is_long)
    80200f04:	fd442783          	lw	a5,-44(s0)
    80200f08:	2781                	sext.w	a5,a5
    80200f0a:	c78d                	beqz	a5,80200f34 <printf+0x2b2>
                printint(va_arg(ap, unsigned long long), 10, 0, width, padzero);
    80200f0c:	fb843783          	ld	a5,-72(s0)
    80200f10:	00878713          	addi	a4,a5,8
    80200f14:	fae43c23          	sd	a4,-72(s0)
    80200f18:	639c                	ld	a5,0(a5)
    80200f1a:	853e                	mv	a0,a5
    80200f1c:	fdc42703          	lw	a4,-36(s0)
    80200f20:	fd842783          	lw	a5,-40(s0)
    80200f24:	86be                	mv	a3,a5
    80200f26:	4601                	li	a2,0
    80200f28:	45a9                	li	a1,10
    80200f2a:	00000097          	auipc	ra,0x0
    80200f2e:	c1e080e7          	jalr	-994(ra) # 80200b48 <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
            break;
    80200f32:	a435                	j	8020115e <printf+0x4dc>
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
    80200f34:	fb843783          	ld	a5,-72(s0)
    80200f38:	00878713          	addi	a4,a5,8
    80200f3c:	fae43c23          	sd	a4,-72(s0)
    80200f40:	439c                	lw	a5,0(a5)
    80200f42:	1782                	slli	a5,a5,0x20
    80200f44:	9381                	srli	a5,a5,0x20
    80200f46:	fdc42703          	lw	a4,-36(s0)
    80200f4a:	fd842683          	lw	a3,-40(s0)
    80200f4e:	4601                	li	a2,0
    80200f50:	45a9                	li	a1,10
    80200f52:	853e                	mv	a0,a5
    80200f54:	00000097          	auipc	ra,0x0
    80200f58:	bf4080e7          	jalr	-1036(ra) # 80200b48 <printint>
            break;
    80200f5c:	a409                	j	8020115e <printf+0x4dc>
        case 'c':
            consputc(va_arg(ap, int));
    80200f5e:	fb843783          	ld	a5,-72(s0)
    80200f62:	00878713          	addi	a4,a5,8
    80200f66:	fae43c23          	sd	a4,-72(s0)
    80200f6a:	439c                	lw	a5,0(a5)
    80200f6c:	853e                	mv	a0,a5
    80200f6e:	00000097          	auipc	ra,0x0
    80200f72:	b86080e7          	jalr	-1146(ra) # 80200af4 <consputc>
            break;
    80200f76:	a2e5                	j	8020115e <printf+0x4dc>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80200f78:	fb843783          	ld	a5,-72(s0)
    80200f7c:	00878713          	addi	a4,a5,8
    80200f80:	fae43c23          	sd	a4,-72(s0)
    80200f84:	639c                	ld	a5,0(a5)
    80200f86:	fef43023          	sd	a5,-32(s0)
    80200f8a:	fe043783          	ld	a5,-32(s0)
    80200f8e:	e799                	bnez	a5,80200f9c <printf+0x31a>
                s = "(null)";
    80200f90:	00006797          	auipc	a5,0x6
    80200f94:	48878793          	addi	a5,a5,1160 # 80207418 <etext+0x418>
    80200f98:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    80200f9c:	fe043503          	ld	a0,-32(s0)
    80200fa0:	00000097          	auipc	ra,0x0
    80200fa4:	b7e080e7          	jalr	-1154(ra) # 80200b1e <consputs>
            break;
    80200fa8:	aa5d                	j	8020115e <printf+0x4dc>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    80200faa:	fb843783          	ld	a5,-72(s0)
    80200fae:	00878713          	addi	a4,a5,8
    80200fb2:	fae43c23          	sd	a4,-72(s0)
    80200fb6:	639c                	ld	a5,0(a5)
    80200fb8:	fcf43423          	sd	a5,-56(s0)
            consputs("0x");
    80200fbc:	00006517          	auipc	a0,0x6
    80200fc0:	46450513          	addi	a0,a0,1124 # 80207420 <etext+0x420>
    80200fc4:	00000097          	auipc	ra,0x0
    80200fc8:	b5a080e7          	jalr	-1190(ra) # 80200b1e <consputs>
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    80200fcc:	fc042823          	sw	zero,-48(s0)
    80200fd0:	a0a1                	j	80201018 <printf+0x396>
                int shift = (15 - i) * 4;
    80200fd2:	47bd                	li	a5,15
    80200fd4:	fd042703          	lw	a4,-48(s0)
    80200fd8:	9f99                	subw	a5,a5,a4
    80200fda:	2781                	sext.w	a5,a5
    80200fdc:	0027979b          	slliw	a5,a5,0x2
    80200fe0:	fcf42223          	sw	a5,-60(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80200fe4:	fc442783          	lw	a5,-60(s0)
    80200fe8:	873e                	mv	a4,a5
    80200fea:	fc843783          	ld	a5,-56(s0)
    80200fee:	00e7d7b3          	srl	a5,a5,a4
    80200ff2:	8bbd                	andi	a5,a5,15
    80200ff4:	00006717          	auipc	a4,0x6
    80200ff8:	43470713          	addi	a4,a4,1076 # 80207428 <etext+0x428>
    80200ffc:	97ba                	add	a5,a5,a4
    80200ffe:	0007c703          	lbu	a4,0(a5)
    80201002:	fd042783          	lw	a5,-48(s0)
    80201006:	17c1                	addi	a5,a5,-16
    80201008:	97a2                	add	a5,a5,s0
    8020100a:	fae78823          	sb	a4,-80(a5)
            for (i = 0; i < 16; i++) {
    8020100e:	fd042783          	lw	a5,-48(s0)
    80201012:	2785                	addiw	a5,a5,1
    80201014:	fcf42823          	sw	a5,-48(s0)
    80201018:	fd042783          	lw	a5,-48(s0)
    8020101c:	0007871b          	sext.w	a4,a5
    80201020:	47bd                	li	a5,15
    80201022:	fae7d8e3          	bge	a5,a4,80200fd2 <printf+0x350>
            }
            buf[16] = '\0';
    80201026:	fa040823          	sb	zero,-80(s0)
            consputs(buf);
    8020102a:	fa040793          	addi	a5,s0,-96
    8020102e:	853e                	mv	a0,a5
    80201030:	00000097          	auipc	ra,0x0
    80201034:	aee080e7          	jalr	-1298(ra) # 80200b1e <consputs>
            break;
    80201038:	a21d                	j	8020115e <printf+0x4dc>
        case 'b':
            if(is_long)
    8020103a:	fd442783          	lw	a5,-44(s0)
    8020103e:	2781                	sext.w	a5,a5
    80201040:	c785                	beqz	a5,80201068 <printf+0x3e6>
                printint(va_arg(ap, long long), 2, 0, width, padzero);
    80201042:	fb843783          	ld	a5,-72(s0)
    80201046:	00878713          	addi	a4,a5,8
    8020104a:	fae43c23          	sd	a4,-72(s0)
    8020104e:	639c                	ld	a5,0(a5)
    80201050:	fdc42703          	lw	a4,-36(s0)
    80201054:	fd842683          	lw	a3,-40(s0)
    80201058:	4601                	li	a2,0
    8020105a:	4589                	li	a1,2
    8020105c:	853e                	mv	a0,a5
    8020105e:	00000097          	auipc	ra,0x0
    80201062:	aea080e7          	jalr	-1302(ra) # 80200b48 <printint>
            else
                printint(va_arg(ap, int), 2, 0, width, padzero);
            break;
    80201066:	a8e5                	j	8020115e <printf+0x4dc>
                printint(va_arg(ap, int), 2, 0, width, padzero);
    80201068:	fb843783          	ld	a5,-72(s0)
    8020106c:	00878713          	addi	a4,a5,8
    80201070:	fae43c23          	sd	a4,-72(s0)
    80201074:	439c                	lw	a5,0(a5)
    80201076:	853e                	mv	a0,a5
    80201078:	fdc42703          	lw	a4,-36(s0)
    8020107c:	fd842783          	lw	a5,-40(s0)
    80201080:	86be                	mv	a3,a5
    80201082:	4601                	li	a2,0
    80201084:	4589                	li	a1,2
    80201086:	00000097          	auipc	ra,0x0
    8020108a:	ac2080e7          	jalr	-1342(ra) # 80200b48 <printint>
            break;
    8020108e:	a8c1                	j	8020115e <printf+0x4dc>
        case 'o':
            if(is_long)
    80201090:	fd442783          	lw	a5,-44(s0)
    80201094:	2781                	sext.w	a5,a5
    80201096:	c785                	beqz	a5,802010be <printf+0x43c>
                printint(va_arg(ap, long long), 8, 0, width, padzero);
    80201098:	fb843783          	ld	a5,-72(s0)
    8020109c:	00878713          	addi	a4,a5,8
    802010a0:	fae43c23          	sd	a4,-72(s0)
    802010a4:	639c                	ld	a5,0(a5)
    802010a6:	fdc42703          	lw	a4,-36(s0)
    802010aa:	fd842683          	lw	a3,-40(s0)
    802010ae:	4601                	li	a2,0
    802010b0:	45a1                	li	a1,8
    802010b2:	853e                	mv	a0,a5
    802010b4:	00000097          	auipc	ra,0x0
    802010b8:	a94080e7          	jalr	-1388(ra) # 80200b48 <printint>
            else
                printint(va_arg(ap, int), 8, 0, width, padzero);
            break;
    802010bc:	a04d                	j	8020115e <printf+0x4dc>
                printint(va_arg(ap, int), 8, 0, width, padzero);
    802010be:	fb843783          	ld	a5,-72(s0)
    802010c2:	00878713          	addi	a4,a5,8
    802010c6:	fae43c23          	sd	a4,-72(s0)
    802010ca:	439c                	lw	a5,0(a5)
    802010cc:	853e                	mv	a0,a5
    802010ce:	fdc42703          	lw	a4,-36(s0)
    802010d2:	fd842783          	lw	a5,-40(s0)
    802010d6:	86be                	mv	a3,a5
    802010d8:	4601                	li	a2,0
    802010da:	45a1                	li	a1,8
    802010dc:	00000097          	auipc	ra,0x0
    802010e0:	a6c080e7          	jalr	-1428(ra) # 80200b48 <printint>
            break;
    802010e4:	a8ad                	j	8020115e <printf+0x4dc>
        case '%':
            buffer_char('%');
    802010e6:	02500513          	li	a0,37
    802010ea:	00000097          	auipc	ra,0x0
    802010ee:	978080e7          	jalr	-1672(ra) # 80200a62 <buffer_char>
            break;
    802010f2:	a0b5                	j	8020115e <printf+0x4dc>
        default:
            buffer_char('%');
    802010f4:	02500513          	li	a0,37
    802010f8:	00000097          	auipc	ra,0x0
    802010fc:	96a080e7          	jalr	-1686(ra) # 80200a62 <buffer_char>
            if(padzero) buffer_char('0');
    80201100:	fdc42783          	lw	a5,-36(s0)
    80201104:	2781                	sext.w	a5,a5
    80201106:	c799                	beqz	a5,80201114 <printf+0x492>
    80201108:	03000513          	li	a0,48
    8020110c:	00000097          	auipc	ra,0x0
    80201110:	956080e7          	jalr	-1706(ra) # 80200a62 <buffer_char>
            if(width) {
    80201114:	fd842783          	lw	a5,-40(s0)
    80201118:	2781                	sext.w	a5,a5
    8020111a:	cf91                	beqz	a5,80201136 <printf+0x4b4>
                // 只支持一位宽度，简单处理
                buffer_char('0' + width);
    8020111c:	fd842783          	lw	a5,-40(s0)
    80201120:	0ff7f793          	zext.b	a5,a5
    80201124:	0307879b          	addiw	a5,a5,48
    80201128:	0ff7f793          	zext.b	a5,a5
    8020112c:	853e                	mv	a0,a5
    8020112e:	00000097          	auipc	ra,0x0
    80201132:	934080e7          	jalr	-1740(ra) # 80200a62 <buffer_char>
            }
            if(is_long) buffer_char('l');
    80201136:	fd442783          	lw	a5,-44(s0)
    8020113a:	2781                	sext.w	a5,a5
    8020113c:	c799                	beqz	a5,8020114a <printf+0x4c8>
    8020113e:	06c00513          	li	a0,108
    80201142:	00000097          	auipc	ra,0x0
    80201146:	920080e7          	jalr	-1760(ra) # 80200a62 <buffer_char>
            buffer_char(c);
    8020114a:	fe842783          	lw	a5,-24(s0)
    8020114e:	0ff7f793          	zext.b	a5,a5
    80201152:	853e                	mv	a0,a5
    80201154:	00000097          	auipc	ra,0x0
    80201158:	90e080e7          	jalr	-1778(ra) # 80200a62 <buffer_char>
            break;
    8020115c:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8020115e:	fec42783          	lw	a5,-20(s0)
    80201162:	2785                	addiw	a5,a5,1
    80201164:	fef42623          	sw	a5,-20(s0)
    80201168:	fec42783          	lw	a5,-20(s0)
    8020116c:	f9843703          	ld	a4,-104(s0)
    80201170:	97ba                	add	a5,a5,a4
    80201172:	0007c783          	lbu	a5,0(a5)
    80201176:	fef42423          	sw	a5,-24(s0)
    8020117a:	fe842783          	lw	a5,-24(s0)
    8020117e:	2781                	sext.w	a5,a5
    80201180:	b2079de3          	bnez	a5,80200cba <printf+0x38>
    80201184:	a011                	j	80201188 <printf+0x506>
                break;
    80201186:	0001                	nop
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    80201188:	00000097          	auipc	ra,0x0
    8020118c:	886080e7          	jalr	-1914(ra) # 80200a0e <flush_printf_buffer>
    va_end(ap);
}
    80201190:	0001                	nop
    80201192:	70a6                	ld	ra,104(sp)
    80201194:	7406                	ld	s0,96(sp)
    80201196:	614d                	addi	sp,sp,176
    80201198:	8082                	ret

000000008020119a <clear_screen>:
// 清屏功能
void clear_screen(void) {
    8020119a:	1141                	addi	sp,sp,-16
    8020119c:	e406                	sd	ra,8(sp)
    8020119e:	e022                	sd	s0,0(sp)
    802011a0:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    802011a2:	00006517          	auipc	a0,0x6
    802011a6:	2f650513          	addi	a0,a0,758 # 80207498 <etext+0x498>
    802011aa:	fffff097          	auipc	ra,0xfffff
    802011ae:	482080e7          	jalr	1154(ra) # 8020062c <uart_puts>
	uart_puts(CURSOR_HOME);
    802011b2:	00006517          	auipc	a0,0x6
    802011b6:	2ee50513          	addi	a0,a0,750 # 802074a0 <etext+0x4a0>
    802011ba:	fffff097          	auipc	ra,0xfffff
    802011be:	472080e7          	jalr	1138(ra) # 8020062c <uart_puts>
}
    802011c2:	0001                	nop
    802011c4:	60a2                	ld	ra,8(sp)
    802011c6:	6402                	ld	s0,0(sp)
    802011c8:	0141                	addi	sp,sp,16
    802011ca:	8082                	ret

00000000802011cc <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    802011cc:	1101                	addi	sp,sp,-32
    802011ce:	ec06                	sd	ra,24(sp)
    802011d0:	e822                	sd	s0,16(sp)
    802011d2:	1000                	addi	s0,sp,32
    802011d4:	87aa                	mv	a5,a0
    802011d6:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    802011da:	fec42783          	lw	a5,-20(s0)
    802011de:	2781                	sext.w	a5,a5
    802011e0:	02f05f63          	blez	a5,8020121e <cursor_up+0x52>
    consputc('\033');
    802011e4:	456d                	li	a0,27
    802011e6:	00000097          	auipc	ra,0x0
    802011ea:	90e080e7          	jalr	-1778(ra) # 80200af4 <consputc>
    consputc('[');
    802011ee:	05b00513          	li	a0,91
    802011f2:	00000097          	auipc	ra,0x0
    802011f6:	902080e7          	jalr	-1790(ra) # 80200af4 <consputc>
    printint(lines, 10, 0, 0,0);
    802011fa:	fec42783          	lw	a5,-20(s0)
    802011fe:	4701                	li	a4,0
    80201200:	4681                	li	a3,0
    80201202:	4601                	li	a2,0
    80201204:	45a9                	li	a1,10
    80201206:	853e                	mv	a0,a5
    80201208:	00000097          	auipc	ra,0x0
    8020120c:	940080e7          	jalr	-1728(ra) # 80200b48 <printint>
    consputc('A');
    80201210:	04100513          	li	a0,65
    80201214:	00000097          	auipc	ra,0x0
    80201218:	8e0080e7          	jalr	-1824(ra) # 80200af4 <consputc>
    8020121c:	a011                	j	80201220 <cursor_up+0x54>
    if (lines <= 0) return;
    8020121e:	0001                	nop
}
    80201220:	60e2                	ld	ra,24(sp)
    80201222:	6442                	ld	s0,16(sp)
    80201224:	6105                	addi	sp,sp,32
    80201226:	8082                	ret

0000000080201228 <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    80201228:	1101                	addi	sp,sp,-32
    8020122a:	ec06                	sd	ra,24(sp)
    8020122c:	e822                	sd	s0,16(sp)
    8020122e:	1000                	addi	s0,sp,32
    80201230:	87aa                	mv	a5,a0
    80201232:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    80201236:	fec42783          	lw	a5,-20(s0)
    8020123a:	2781                	sext.w	a5,a5
    8020123c:	02f05f63          	blez	a5,8020127a <cursor_down+0x52>
    consputc('\033');
    80201240:	456d                	li	a0,27
    80201242:	00000097          	auipc	ra,0x0
    80201246:	8b2080e7          	jalr	-1870(ra) # 80200af4 <consputc>
    consputc('[');
    8020124a:	05b00513          	li	a0,91
    8020124e:	00000097          	auipc	ra,0x0
    80201252:	8a6080e7          	jalr	-1882(ra) # 80200af4 <consputc>
    printint(lines, 10, 0, 0,0);
    80201256:	fec42783          	lw	a5,-20(s0)
    8020125a:	4701                	li	a4,0
    8020125c:	4681                	li	a3,0
    8020125e:	4601                	li	a2,0
    80201260:	45a9                	li	a1,10
    80201262:	853e                	mv	a0,a5
    80201264:	00000097          	auipc	ra,0x0
    80201268:	8e4080e7          	jalr	-1820(ra) # 80200b48 <printint>
    consputc('B');
    8020126c:	04200513          	li	a0,66
    80201270:	00000097          	auipc	ra,0x0
    80201274:	884080e7          	jalr	-1916(ra) # 80200af4 <consputc>
    80201278:	a011                	j	8020127c <cursor_down+0x54>
    if (lines <= 0) return;
    8020127a:	0001                	nop
}
    8020127c:	60e2                	ld	ra,24(sp)
    8020127e:	6442                	ld	s0,16(sp)
    80201280:	6105                	addi	sp,sp,32
    80201282:	8082                	ret

0000000080201284 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    80201284:	1101                	addi	sp,sp,-32
    80201286:	ec06                	sd	ra,24(sp)
    80201288:	e822                	sd	s0,16(sp)
    8020128a:	1000                	addi	s0,sp,32
    8020128c:	87aa                	mv	a5,a0
    8020128e:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80201292:	fec42783          	lw	a5,-20(s0)
    80201296:	2781                	sext.w	a5,a5
    80201298:	02f05f63          	blez	a5,802012d6 <cursor_right+0x52>
    consputc('\033');
    8020129c:	456d                	li	a0,27
    8020129e:	00000097          	auipc	ra,0x0
    802012a2:	856080e7          	jalr	-1962(ra) # 80200af4 <consputc>
    consputc('[');
    802012a6:	05b00513          	li	a0,91
    802012aa:	00000097          	auipc	ra,0x0
    802012ae:	84a080e7          	jalr	-1974(ra) # 80200af4 <consputc>
    printint(cols, 10, 0,0,0);
    802012b2:	fec42783          	lw	a5,-20(s0)
    802012b6:	4701                	li	a4,0
    802012b8:	4681                	li	a3,0
    802012ba:	4601                	li	a2,0
    802012bc:	45a9                	li	a1,10
    802012be:	853e                	mv	a0,a5
    802012c0:	00000097          	auipc	ra,0x0
    802012c4:	888080e7          	jalr	-1912(ra) # 80200b48 <printint>
    consputc('C');
    802012c8:	04300513          	li	a0,67
    802012cc:	00000097          	auipc	ra,0x0
    802012d0:	828080e7          	jalr	-2008(ra) # 80200af4 <consputc>
    802012d4:	a011                	j	802012d8 <cursor_right+0x54>
    if (cols <= 0) return;
    802012d6:	0001                	nop
}
    802012d8:	60e2                	ld	ra,24(sp)
    802012da:	6442                	ld	s0,16(sp)
    802012dc:	6105                	addi	sp,sp,32
    802012de:	8082                	ret

00000000802012e0 <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    802012e0:	1101                	addi	sp,sp,-32
    802012e2:	ec06                	sd	ra,24(sp)
    802012e4:	e822                	sd	s0,16(sp)
    802012e6:	1000                	addi	s0,sp,32
    802012e8:	87aa                	mv	a5,a0
    802012ea:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    802012ee:	fec42783          	lw	a5,-20(s0)
    802012f2:	2781                	sext.w	a5,a5
    802012f4:	02f05f63          	blez	a5,80201332 <cursor_left+0x52>
    consputc('\033');
    802012f8:	456d                	li	a0,27
    802012fa:	fffff097          	auipc	ra,0xfffff
    802012fe:	7fa080e7          	jalr	2042(ra) # 80200af4 <consputc>
    consputc('[');
    80201302:	05b00513          	li	a0,91
    80201306:	fffff097          	auipc	ra,0xfffff
    8020130a:	7ee080e7          	jalr	2030(ra) # 80200af4 <consputc>
    printint(cols, 10, 0,0,0);
    8020130e:	fec42783          	lw	a5,-20(s0)
    80201312:	4701                	li	a4,0
    80201314:	4681                	li	a3,0
    80201316:	4601                	li	a2,0
    80201318:	45a9                	li	a1,10
    8020131a:	853e                	mv	a0,a5
    8020131c:	00000097          	auipc	ra,0x0
    80201320:	82c080e7          	jalr	-2004(ra) # 80200b48 <printint>
    consputc('D');
    80201324:	04400513          	li	a0,68
    80201328:	fffff097          	auipc	ra,0xfffff
    8020132c:	7cc080e7          	jalr	1996(ra) # 80200af4 <consputc>
    80201330:	a011                	j	80201334 <cursor_left+0x54>
    if (cols <= 0) return;
    80201332:	0001                	nop
}
    80201334:	60e2                	ld	ra,24(sp)
    80201336:	6442                	ld	s0,16(sp)
    80201338:	6105                	addi	sp,sp,32
    8020133a:	8082                	ret

000000008020133c <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    8020133c:	1141                	addi	sp,sp,-16
    8020133e:	e406                	sd	ra,8(sp)
    80201340:	e022                	sd	s0,0(sp)
    80201342:	0800                	addi	s0,sp,16
    consputc('\033');
    80201344:	456d                	li	a0,27
    80201346:	fffff097          	auipc	ra,0xfffff
    8020134a:	7ae080e7          	jalr	1966(ra) # 80200af4 <consputc>
    consputc('[');
    8020134e:	05b00513          	li	a0,91
    80201352:	fffff097          	auipc	ra,0xfffff
    80201356:	7a2080e7          	jalr	1954(ra) # 80200af4 <consputc>
    consputc('s');
    8020135a:	07300513          	li	a0,115
    8020135e:	fffff097          	auipc	ra,0xfffff
    80201362:	796080e7          	jalr	1942(ra) # 80200af4 <consputc>
}
    80201366:	0001                	nop
    80201368:	60a2                	ld	ra,8(sp)
    8020136a:	6402                	ld	s0,0(sp)
    8020136c:	0141                	addi	sp,sp,16
    8020136e:	8082                	ret

0000000080201370 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    80201370:	1141                	addi	sp,sp,-16
    80201372:	e406                	sd	ra,8(sp)
    80201374:	e022                	sd	s0,0(sp)
    80201376:	0800                	addi	s0,sp,16
    consputc('\033');
    80201378:	456d                	li	a0,27
    8020137a:	fffff097          	auipc	ra,0xfffff
    8020137e:	77a080e7          	jalr	1914(ra) # 80200af4 <consputc>
    consputc('[');
    80201382:	05b00513          	li	a0,91
    80201386:	fffff097          	auipc	ra,0xfffff
    8020138a:	76e080e7          	jalr	1902(ra) # 80200af4 <consputc>
    consputc('u');
    8020138e:	07500513          	li	a0,117
    80201392:	fffff097          	auipc	ra,0xfffff
    80201396:	762080e7          	jalr	1890(ra) # 80200af4 <consputc>
}
    8020139a:	0001                	nop
    8020139c:	60a2                	ld	ra,8(sp)
    8020139e:	6402                	ld	s0,0(sp)
    802013a0:	0141                	addi	sp,sp,16
    802013a2:	8082                	ret

00000000802013a4 <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    802013a4:	1101                	addi	sp,sp,-32
    802013a6:	ec06                	sd	ra,24(sp)
    802013a8:	e822                	sd	s0,16(sp)
    802013aa:	1000                	addi	s0,sp,32
    802013ac:	87aa                	mv	a5,a0
    802013ae:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    802013b2:	fec42783          	lw	a5,-20(s0)
    802013b6:	2781                	sext.w	a5,a5
    802013b8:	00f04563          	bgtz	a5,802013c2 <cursor_to_column+0x1e>
    802013bc:	4785                	li	a5,1
    802013be:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    802013c2:	456d                	li	a0,27
    802013c4:	fffff097          	auipc	ra,0xfffff
    802013c8:	730080e7          	jalr	1840(ra) # 80200af4 <consputc>
    consputc('[');
    802013cc:	05b00513          	li	a0,91
    802013d0:	fffff097          	auipc	ra,0xfffff
    802013d4:	724080e7          	jalr	1828(ra) # 80200af4 <consputc>
    printint(col, 10, 0,0,0);
    802013d8:	fec42783          	lw	a5,-20(s0)
    802013dc:	4701                	li	a4,0
    802013de:	4681                	li	a3,0
    802013e0:	4601                	li	a2,0
    802013e2:	45a9                	li	a1,10
    802013e4:	853e                	mv	a0,a5
    802013e6:	fffff097          	auipc	ra,0xfffff
    802013ea:	762080e7          	jalr	1890(ra) # 80200b48 <printint>
    consputc('G');
    802013ee:	04700513          	li	a0,71
    802013f2:	fffff097          	auipc	ra,0xfffff
    802013f6:	702080e7          	jalr	1794(ra) # 80200af4 <consputc>
}
    802013fa:	0001                	nop
    802013fc:	60e2                	ld	ra,24(sp)
    802013fe:	6442                	ld	s0,16(sp)
    80201400:	6105                	addi	sp,sp,32
    80201402:	8082                	ret

0000000080201404 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80201404:	1101                	addi	sp,sp,-32
    80201406:	ec06                	sd	ra,24(sp)
    80201408:	e822                	sd	s0,16(sp)
    8020140a:	1000                	addi	s0,sp,32
    8020140c:	87aa                	mv	a5,a0
    8020140e:	872e                	mv	a4,a1
    80201410:	fef42623          	sw	a5,-20(s0)
    80201414:	87ba                	mv	a5,a4
    80201416:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    8020141a:	456d                	li	a0,27
    8020141c:	fffff097          	auipc	ra,0xfffff
    80201420:	6d8080e7          	jalr	1752(ra) # 80200af4 <consputc>
    consputc('[');
    80201424:	05b00513          	li	a0,91
    80201428:	fffff097          	auipc	ra,0xfffff
    8020142c:	6cc080e7          	jalr	1740(ra) # 80200af4 <consputc>
    printint(row, 10, 0,0,0);
    80201430:	fec42783          	lw	a5,-20(s0)
    80201434:	4701                	li	a4,0
    80201436:	4681                	li	a3,0
    80201438:	4601                	li	a2,0
    8020143a:	45a9                	li	a1,10
    8020143c:	853e                	mv	a0,a5
    8020143e:	fffff097          	auipc	ra,0xfffff
    80201442:	70a080e7          	jalr	1802(ra) # 80200b48 <printint>
    consputc(';');
    80201446:	03b00513          	li	a0,59
    8020144a:	fffff097          	auipc	ra,0xfffff
    8020144e:	6aa080e7          	jalr	1706(ra) # 80200af4 <consputc>
    printint(col, 10, 0,0,0);
    80201452:	fe842783          	lw	a5,-24(s0)
    80201456:	4701                	li	a4,0
    80201458:	4681                	li	a3,0
    8020145a:	4601                	li	a2,0
    8020145c:	45a9                	li	a1,10
    8020145e:	853e                	mv	a0,a5
    80201460:	fffff097          	auipc	ra,0xfffff
    80201464:	6e8080e7          	jalr	1768(ra) # 80200b48 <printint>
    consputc('H');
    80201468:	04800513          	li	a0,72
    8020146c:	fffff097          	auipc	ra,0xfffff
    80201470:	688080e7          	jalr	1672(ra) # 80200af4 <consputc>
}
    80201474:	0001                	nop
    80201476:	60e2                	ld	ra,24(sp)
    80201478:	6442                	ld	s0,16(sp)
    8020147a:	6105                	addi	sp,sp,32
    8020147c:	8082                	ret

000000008020147e <reset_color>:
// 颜色控制
void reset_color(void) {
    8020147e:	1141                	addi	sp,sp,-16
    80201480:	e406                	sd	ra,8(sp)
    80201482:	e022                	sd	s0,0(sp)
    80201484:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    80201486:	00006517          	auipc	a0,0x6
    8020148a:	02250513          	addi	a0,a0,34 # 802074a8 <etext+0x4a8>
    8020148e:	fffff097          	auipc	ra,0xfffff
    80201492:	19e080e7          	jalr	414(ra) # 8020062c <uart_puts>
}
    80201496:	0001                	nop
    80201498:	60a2                	ld	ra,8(sp)
    8020149a:	6402                	ld	s0,0(sp)
    8020149c:	0141                	addi	sp,sp,16
    8020149e:	8082                	ret

00000000802014a0 <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    802014a0:	1101                	addi	sp,sp,-32
    802014a2:	ec06                	sd	ra,24(sp)
    802014a4:	e822                	sd	s0,16(sp)
    802014a6:	1000                	addi	s0,sp,32
    802014a8:	87aa                	mv	a5,a0
    802014aa:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    802014ae:	fec42783          	lw	a5,-20(s0)
    802014b2:	0007871b          	sext.w	a4,a5
    802014b6:	47f5                	li	a5,29
    802014b8:	04e7d763          	bge	a5,a4,80201506 <set_fg_color+0x66>
    802014bc:	fec42783          	lw	a5,-20(s0)
    802014c0:	0007871b          	sext.w	a4,a5
    802014c4:	02500793          	li	a5,37
    802014c8:	02e7cf63          	blt	a5,a4,80201506 <set_fg_color+0x66>
	consputc('\033');
    802014cc:	456d                	li	a0,27
    802014ce:	fffff097          	auipc	ra,0xfffff
    802014d2:	626080e7          	jalr	1574(ra) # 80200af4 <consputc>
	consputc('[');
    802014d6:	05b00513          	li	a0,91
    802014da:	fffff097          	auipc	ra,0xfffff
    802014de:	61a080e7          	jalr	1562(ra) # 80200af4 <consputc>
	printint(color, 10, 0,0,0);
    802014e2:	fec42783          	lw	a5,-20(s0)
    802014e6:	4701                	li	a4,0
    802014e8:	4681                	li	a3,0
    802014ea:	4601                	li	a2,0
    802014ec:	45a9                	li	a1,10
    802014ee:	853e                	mv	a0,a5
    802014f0:	fffff097          	auipc	ra,0xfffff
    802014f4:	658080e7          	jalr	1624(ra) # 80200b48 <printint>
	consputc('m');
    802014f8:	06d00513          	li	a0,109
    802014fc:	fffff097          	auipc	ra,0xfffff
    80201500:	5f8080e7          	jalr	1528(ra) # 80200af4 <consputc>
    80201504:	a011                	j	80201508 <set_fg_color+0x68>
	if (color < 30 || color > 37) return; // 支持30-37
    80201506:	0001                	nop
}
    80201508:	60e2                	ld	ra,24(sp)
    8020150a:	6442                	ld	s0,16(sp)
    8020150c:	6105                	addi	sp,sp,32
    8020150e:	8082                	ret

0000000080201510 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    80201510:	1101                	addi	sp,sp,-32
    80201512:	ec06                	sd	ra,24(sp)
    80201514:	e822                	sd	s0,16(sp)
    80201516:	1000                	addi	s0,sp,32
    80201518:	87aa                	mv	a5,a0
    8020151a:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    8020151e:	fec42783          	lw	a5,-20(s0)
    80201522:	0007871b          	sext.w	a4,a5
    80201526:	02700793          	li	a5,39
    8020152a:	04e7d763          	bge	a5,a4,80201578 <set_bg_color+0x68>
    8020152e:	fec42783          	lw	a5,-20(s0)
    80201532:	0007871b          	sext.w	a4,a5
    80201536:	02f00793          	li	a5,47
    8020153a:	02e7cf63          	blt	a5,a4,80201578 <set_bg_color+0x68>
	consputc('\033');
    8020153e:	456d                	li	a0,27
    80201540:	fffff097          	auipc	ra,0xfffff
    80201544:	5b4080e7          	jalr	1460(ra) # 80200af4 <consputc>
	consputc('[');
    80201548:	05b00513          	li	a0,91
    8020154c:	fffff097          	auipc	ra,0xfffff
    80201550:	5a8080e7          	jalr	1448(ra) # 80200af4 <consputc>
	printint(color, 10, 0,0,0);
    80201554:	fec42783          	lw	a5,-20(s0)
    80201558:	4701                	li	a4,0
    8020155a:	4681                	li	a3,0
    8020155c:	4601                	li	a2,0
    8020155e:	45a9                	li	a1,10
    80201560:	853e                	mv	a0,a5
    80201562:	fffff097          	auipc	ra,0xfffff
    80201566:	5e6080e7          	jalr	1510(ra) # 80200b48 <printint>
	consputc('m');
    8020156a:	06d00513          	li	a0,109
    8020156e:	fffff097          	auipc	ra,0xfffff
    80201572:	586080e7          	jalr	1414(ra) # 80200af4 <consputc>
    80201576:	a011                	j	8020157a <set_bg_color+0x6a>
	if (color < 40 || color > 47) return; // 支持40-47
    80201578:	0001                	nop
}
    8020157a:	60e2                	ld	ra,24(sp)
    8020157c:	6442                	ld	s0,16(sp)
    8020157e:	6105                	addi	sp,sp,32
    80201580:	8082                	ret

0000000080201582 <color_red>:
// 简易文字颜色
void color_red(void) {
    80201582:	1141                	addi	sp,sp,-16
    80201584:	e406                	sd	ra,8(sp)
    80201586:	e022                	sd	s0,0(sp)
    80201588:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    8020158a:	457d                	li	a0,31
    8020158c:	00000097          	auipc	ra,0x0
    80201590:	f14080e7          	jalr	-236(ra) # 802014a0 <set_fg_color>
}
    80201594:	0001                	nop
    80201596:	60a2                	ld	ra,8(sp)
    80201598:	6402                	ld	s0,0(sp)
    8020159a:	0141                	addi	sp,sp,16
    8020159c:	8082                	ret

000000008020159e <color_green>:
void color_green(void) {
    8020159e:	1141                	addi	sp,sp,-16
    802015a0:	e406                	sd	ra,8(sp)
    802015a2:	e022                	sd	s0,0(sp)
    802015a4:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    802015a6:	02000513          	li	a0,32
    802015aa:	00000097          	auipc	ra,0x0
    802015ae:	ef6080e7          	jalr	-266(ra) # 802014a0 <set_fg_color>
}
    802015b2:	0001                	nop
    802015b4:	60a2                	ld	ra,8(sp)
    802015b6:	6402                	ld	s0,0(sp)
    802015b8:	0141                	addi	sp,sp,16
    802015ba:	8082                	ret

00000000802015bc <color_yellow>:
void color_yellow(void) {
    802015bc:	1141                	addi	sp,sp,-16
    802015be:	e406                	sd	ra,8(sp)
    802015c0:	e022                	sd	s0,0(sp)
    802015c2:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    802015c4:	02100513          	li	a0,33
    802015c8:	00000097          	auipc	ra,0x0
    802015cc:	ed8080e7          	jalr	-296(ra) # 802014a0 <set_fg_color>
}
    802015d0:	0001                	nop
    802015d2:	60a2                	ld	ra,8(sp)
    802015d4:	6402                	ld	s0,0(sp)
    802015d6:	0141                	addi	sp,sp,16
    802015d8:	8082                	ret

00000000802015da <color_blue>:
void color_blue(void) {
    802015da:	1141                	addi	sp,sp,-16
    802015dc:	e406                	sd	ra,8(sp)
    802015de:	e022                	sd	s0,0(sp)
    802015e0:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    802015e2:	02200513          	li	a0,34
    802015e6:	00000097          	auipc	ra,0x0
    802015ea:	eba080e7          	jalr	-326(ra) # 802014a0 <set_fg_color>
}
    802015ee:	0001                	nop
    802015f0:	60a2                	ld	ra,8(sp)
    802015f2:	6402                	ld	s0,0(sp)
    802015f4:	0141                	addi	sp,sp,16
    802015f6:	8082                	ret

00000000802015f8 <color_purple>:
void color_purple(void) {
    802015f8:	1141                	addi	sp,sp,-16
    802015fa:	e406                	sd	ra,8(sp)
    802015fc:	e022                	sd	s0,0(sp)
    802015fe:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80201600:	02300513          	li	a0,35
    80201604:	00000097          	auipc	ra,0x0
    80201608:	e9c080e7          	jalr	-356(ra) # 802014a0 <set_fg_color>
}
    8020160c:	0001                	nop
    8020160e:	60a2                	ld	ra,8(sp)
    80201610:	6402                	ld	s0,0(sp)
    80201612:	0141                	addi	sp,sp,16
    80201614:	8082                	ret

0000000080201616 <color_cyan>:
void color_cyan(void) {
    80201616:	1141                	addi	sp,sp,-16
    80201618:	e406                	sd	ra,8(sp)
    8020161a:	e022                	sd	s0,0(sp)
    8020161c:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    8020161e:	02400513          	li	a0,36
    80201622:	00000097          	auipc	ra,0x0
    80201626:	e7e080e7          	jalr	-386(ra) # 802014a0 <set_fg_color>
}
    8020162a:	0001                	nop
    8020162c:	60a2                	ld	ra,8(sp)
    8020162e:	6402                	ld	s0,0(sp)
    80201630:	0141                	addi	sp,sp,16
    80201632:	8082                	ret

0000000080201634 <color_reverse>:
void color_reverse(void){
    80201634:	1141                	addi	sp,sp,-16
    80201636:	e406                	sd	ra,8(sp)
    80201638:	e022                	sd	s0,0(sp)
    8020163a:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    8020163c:	02500513          	li	a0,37
    80201640:	00000097          	auipc	ra,0x0
    80201644:	e60080e7          	jalr	-416(ra) # 802014a0 <set_fg_color>
}
    80201648:	0001                	nop
    8020164a:	60a2                	ld	ra,8(sp)
    8020164c:	6402                	ld	s0,0(sp)
    8020164e:	0141                	addi	sp,sp,16
    80201650:	8082                	ret

0000000080201652 <set_color>:
void set_color(int fg, int bg) {
    80201652:	1101                	addi	sp,sp,-32
    80201654:	ec06                	sd	ra,24(sp)
    80201656:	e822                	sd	s0,16(sp)
    80201658:	1000                	addi	s0,sp,32
    8020165a:	87aa                	mv	a5,a0
    8020165c:	872e                	mv	a4,a1
    8020165e:	fef42623          	sw	a5,-20(s0)
    80201662:	87ba                	mv	a5,a4
    80201664:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    80201668:	fe842783          	lw	a5,-24(s0)
    8020166c:	853e                	mv	a0,a5
    8020166e:	00000097          	auipc	ra,0x0
    80201672:	ea2080e7          	jalr	-350(ra) # 80201510 <set_bg_color>
	set_fg_color(fg);
    80201676:	fec42783          	lw	a5,-20(s0)
    8020167a:	853e                	mv	a0,a5
    8020167c:	00000097          	auipc	ra,0x0
    80201680:	e24080e7          	jalr	-476(ra) # 802014a0 <set_fg_color>
}
    80201684:	0001                	nop
    80201686:	60e2                	ld	ra,24(sp)
    80201688:	6442                	ld	s0,16(sp)
    8020168a:	6105                	addi	sp,sp,32
    8020168c:	8082                	ret

000000008020168e <clear_line>:
void clear_line(){
    8020168e:	1141                	addi	sp,sp,-16
    80201690:	e406                	sd	ra,8(sp)
    80201692:	e022                	sd	s0,0(sp)
    80201694:	0800                	addi	s0,sp,16
	consputc('\033');
    80201696:	456d                	li	a0,27
    80201698:	fffff097          	auipc	ra,0xfffff
    8020169c:	45c080e7          	jalr	1116(ra) # 80200af4 <consputc>
	consputc('[');
    802016a0:	05b00513          	li	a0,91
    802016a4:	fffff097          	auipc	ra,0xfffff
    802016a8:	450080e7          	jalr	1104(ra) # 80200af4 <consputc>
	consputc('2');
    802016ac:	03200513          	li	a0,50
    802016b0:	fffff097          	auipc	ra,0xfffff
    802016b4:	444080e7          	jalr	1092(ra) # 80200af4 <consputc>
	consputc('K');
    802016b8:	04b00513          	li	a0,75
    802016bc:	fffff097          	auipc	ra,0xfffff
    802016c0:	438080e7          	jalr	1080(ra) # 80200af4 <consputc>
}
    802016c4:	0001                	nop
    802016c6:	60a2                	ld	ra,8(sp)
    802016c8:	6402                	ld	s0,0(sp)
    802016ca:	0141                	addi	sp,sp,16
    802016cc:	8082                	ret

00000000802016ce <panic>:

void panic(const char *msg) {
    802016ce:	1101                	addi	sp,sp,-32
    802016d0:	ec06                	sd	ra,24(sp)
    802016d2:	e822                	sd	s0,16(sp)
    802016d4:	1000                	addi	s0,sp,32
    802016d6:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    802016da:	00000097          	auipc	ra,0x0
    802016de:	ea8080e7          	jalr	-344(ra) # 80201582 <color_red>
	printf("panic: %s\n", msg);
    802016e2:	fe843583          	ld	a1,-24(s0)
    802016e6:	00006517          	auipc	a0,0x6
    802016ea:	dca50513          	addi	a0,a0,-566 # 802074b0 <etext+0x4b0>
    802016ee:	fffff097          	auipc	ra,0xfffff
    802016f2:	594080e7          	jalr	1428(ra) # 80200c82 <printf>
	reset_color();
    802016f6:	00000097          	auipc	ra,0x0
    802016fa:	d88080e7          	jalr	-632(ra) # 8020147e <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    802016fe:	0001                	nop
    80201700:	bffd                	j	802016fe <panic+0x30>

0000000080201702 <warning>:
}
void warning(const char *fmt, ...) {
    80201702:	7159                	addi	sp,sp,-112
    80201704:	f406                	sd	ra,40(sp)
    80201706:	f022                	sd	s0,32(sp)
    80201708:	1800                	addi	s0,sp,48
    8020170a:	fca43c23          	sd	a0,-40(s0)
    8020170e:	e40c                	sd	a1,8(s0)
    80201710:	e810                	sd	a2,16(s0)
    80201712:	ec14                	sd	a3,24(s0)
    80201714:	f018                	sd	a4,32(s0)
    80201716:	f41c                	sd	a5,40(s0)
    80201718:	03043823          	sd	a6,48(s0)
    8020171c:	03143c23          	sd	a7,56(s0)
    va_list ap;
    color_purple(); // 设置紫色
    80201720:	00000097          	auipc	ra,0x0
    80201724:	ed8080e7          	jalr	-296(ra) # 802015f8 <color_purple>
    printf("[WARNING] ");
    80201728:	00006517          	auipc	a0,0x6
    8020172c:	d9850513          	addi	a0,a0,-616 # 802074c0 <etext+0x4c0>
    80201730:	fffff097          	auipc	ra,0xfffff
    80201734:	552080e7          	jalr	1362(ra) # 80200c82 <printf>
    va_start(ap, fmt);
    80201738:	04040793          	addi	a5,s0,64
    8020173c:	fcf43823          	sd	a5,-48(s0)
    80201740:	fd043783          	ld	a5,-48(s0)
    80201744:	fc878793          	addi	a5,a5,-56
    80201748:	fef43423          	sd	a5,-24(s0)
    printf(fmt, ap);
    8020174c:	fe843783          	ld	a5,-24(s0)
    80201750:	85be                	mv	a1,a5
    80201752:	fd843503          	ld	a0,-40(s0)
    80201756:	fffff097          	auipc	ra,0xfffff
    8020175a:	52c080e7          	jalr	1324(ra) # 80200c82 <printf>
    va_end(ap);
    reset_color(); // 恢复默认颜色
    8020175e:	00000097          	auipc	ra,0x0
    80201762:	d20080e7          	jalr	-736(ra) # 8020147e <reset_color>
}
    80201766:	0001                	nop
    80201768:	70a2                	ld	ra,40(sp)
    8020176a:	7402                	ld	s0,32(sp)
    8020176c:	6165                	addi	sp,sp,112
    8020176e:	8082                	ret

0000000080201770 <test_printf_precision>:
void test_printf_precision(void) {
    80201770:	1101                	addi	sp,sp,-32
    80201772:	ec06                	sd	ra,24(sp)
    80201774:	e822                	sd	s0,16(sp)
    80201776:	1000                	addi	s0,sp,32
	clear_screen();
    80201778:	00000097          	auipc	ra,0x0
    8020177c:	a22080e7          	jalr	-1502(ra) # 8020119a <clear_screen>
    printf("=== 详细的Printf测试 ===\n");
    80201780:	00006517          	auipc	a0,0x6
    80201784:	d5050513          	addi	a0,a0,-688 # 802074d0 <etext+0x4d0>
    80201788:	fffff097          	auipc	ra,0xfffff
    8020178c:	4fa080e7          	jalr	1274(ra) # 80200c82 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    80201790:	00006517          	auipc	a0,0x6
    80201794:	d6050513          	addi	a0,a0,-672 # 802074f0 <etext+0x4f0>
    80201798:	fffff097          	auipc	ra,0xfffff
    8020179c:	4ea080e7          	jalr	1258(ra) # 80200c82 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    802017a0:	0ff00593          	li	a1,255
    802017a4:	00006517          	auipc	a0,0x6
    802017a8:	d6450513          	addi	a0,a0,-668 # 80207508 <etext+0x508>
    802017ac:	fffff097          	auipc	ra,0xfffff
    802017b0:	4d6080e7          	jalr	1238(ra) # 80200c82 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    802017b4:	6585                	lui	a1,0x1
    802017b6:	00006517          	auipc	a0,0x6
    802017ba:	d7250513          	addi	a0,a0,-654 # 80207528 <etext+0x528>
    802017be:	fffff097          	auipc	ra,0xfffff
    802017c2:	4c4080e7          	jalr	1220(ra) # 80200c82 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    802017c6:	1234b7b7          	lui	a5,0x1234b
    802017ca:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    802017ce:	00006517          	auipc	a0,0x6
    802017d2:	d7a50513          	addi	a0,a0,-646 # 80207548 <etext+0x548>
    802017d6:	fffff097          	auipc	ra,0xfffff
    802017da:	4ac080e7          	jalr	1196(ra) # 80200c82 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    802017de:	00006517          	auipc	a0,0x6
    802017e2:	d8250513          	addi	a0,a0,-638 # 80207560 <etext+0x560>
    802017e6:	fffff097          	auipc	ra,0xfffff
    802017ea:	49c080e7          	jalr	1180(ra) # 80200c82 <printf>
    printf("  正数: %d\n", 42);
    802017ee:	02a00593          	li	a1,42
    802017f2:	00006517          	auipc	a0,0x6
    802017f6:	d8650513          	addi	a0,a0,-634 # 80207578 <etext+0x578>
    802017fa:	fffff097          	auipc	ra,0xfffff
    802017fe:	488080e7          	jalr	1160(ra) # 80200c82 <printf>
    printf("  负数: %d\n", -42);
    80201802:	fd600593          	li	a1,-42
    80201806:	00006517          	auipc	a0,0x6
    8020180a:	d8250513          	addi	a0,a0,-638 # 80207588 <etext+0x588>
    8020180e:	fffff097          	auipc	ra,0xfffff
    80201812:	474080e7          	jalr	1140(ra) # 80200c82 <printf>
    printf("  零: %d\n", 0);
    80201816:	4581                	li	a1,0
    80201818:	00006517          	auipc	a0,0x6
    8020181c:	d8050513          	addi	a0,a0,-640 # 80207598 <etext+0x598>
    80201820:	fffff097          	auipc	ra,0xfffff
    80201824:	462080e7          	jalr	1122(ra) # 80200c82 <printf>
    printf("  大数: %d\n", 123456789);
    80201828:	075bd7b7          	lui	a5,0x75bd
    8020182c:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    80201830:	00006517          	auipc	a0,0x6
    80201834:	d7850513          	addi	a0,a0,-648 # 802075a8 <etext+0x5a8>
    80201838:	fffff097          	auipc	ra,0xfffff
    8020183c:	44a080e7          	jalr	1098(ra) # 80200c82 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80201840:	00006517          	auipc	a0,0x6
    80201844:	d7850513          	addi	a0,a0,-648 # 802075b8 <etext+0x5b8>
    80201848:	fffff097          	auipc	ra,0xfffff
    8020184c:	43a080e7          	jalr	1082(ra) # 80200c82 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80201850:	55fd                	li	a1,-1
    80201852:	00006517          	auipc	a0,0x6
    80201856:	d7e50513          	addi	a0,a0,-642 # 802075d0 <etext+0x5d0>
    8020185a:	fffff097          	auipc	ra,0xfffff
    8020185e:	428080e7          	jalr	1064(ra) # 80200c82 <printf>
    printf("  零：%u\n", 0U);
    80201862:	4581                	li	a1,0
    80201864:	00006517          	auipc	a0,0x6
    80201868:	d8450513          	addi	a0,a0,-636 # 802075e8 <etext+0x5e8>
    8020186c:	fffff097          	auipc	ra,0xfffff
    80201870:	416080e7          	jalr	1046(ra) # 80200c82 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80201874:	678d                	lui	a5,0x3
    80201876:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    8020187a:	00006517          	auipc	a0,0x6
    8020187e:	d7e50513          	addi	a0,a0,-642 # 802075f8 <etext+0x5f8>
    80201882:	fffff097          	auipc	ra,0xfffff
    80201886:	400080e7          	jalr	1024(ra) # 80200c82 <printf>

	// 测试边界
	printf("边界测试:\n");
    8020188a:	00006517          	auipc	a0,0x6
    8020188e:	d8650513          	addi	a0,a0,-634 # 80207610 <etext+0x610>
    80201892:	fffff097          	auipc	ra,0xfffff
    80201896:	3f0080e7          	jalr	1008(ra) # 80200c82 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    8020189a:	800007b7          	lui	a5,0x80000
    8020189e:	fff7c593          	not	a1,a5
    802018a2:	00006517          	auipc	a0,0x6
    802018a6:	d7e50513          	addi	a0,a0,-642 # 80207620 <etext+0x620>
    802018aa:	fffff097          	auipc	ra,0xfffff
    802018ae:	3d8080e7          	jalr	984(ra) # 80200c82 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    802018b2:	800005b7          	lui	a1,0x80000
    802018b6:	00006517          	auipc	a0,0x6
    802018ba:	d7a50513          	addi	a0,a0,-646 # 80207630 <etext+0x630>
    802018be:	fffff097          	auipc	ra,0xfffff
    802018c2:	3c4080e7          	jalr	964(ra) # 80200c82 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    802018c6:	55fd                	li	a1,-1
    802018c8:	00006517          	auipc	a0,0x6
    802018cc:	d7850513          	addi	a0,a0,-648 # 80207640 <etext+0x640>
    802018d0:	fffff097          	auipc	ra,0xfffff
    802018d4:	3b2080e7          	jalr	946(ra) # 80200c82 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    802018d8:	55fd                	li	a1,-1
    802018da:	00006517          	auipc	a0,0x6
    802018de:	d7650513          	addi	a0,a0,-650 # 80207650 <etext+0x650>
    802018e2:	fffff097          	auipc	ra,0xfffff
    802018e6:	3a0080e7          	jalr	928(ra) # 80200c82 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    802018ea:	00006517          	auipc	a0,0x6
    802018ee:	d7e50513          	addi	a0,a0,-642 # 80207668 <etext+0x668>
    802018f2:	fffff097          	auipc	ra,0xfffff
    802018f6:	390080e7          	jalr	912(ra) # 80200c82 <printf>
    printf("  空字符串: '%s'\n", "");
    802018fa:	00006597          	auipc	a1,0x6
    802018fe:	d8658593          	addi	a1,a1,-634 # 80207680 <etext+0x680>
    80201902:	00006517          	auipc	a0,0x6
    80201906:	d8650513          	addi	a0,a0,-634 # 80207688 <etext+0x688>
    8020190a:	fffff097          	auipc	ra,0xfffff
    8020190e:	378080e7          	jalr	888(ra) # 80200c82 <printf>
    printf("  单字符: '%s'\n", "X");
    80201912:	00006597          	auipc	a1,0x6
    80201916:	d8e58593          	addi	a1,a1,-626 # 802076a0 <etext+0x6a0>
    8020191a:	00006517          	auipc	a0,0x6
    8020191e:	d8e50513          	addi	a0,a0,-626 # 802076a8 <etext+0x6a8>
    80201922:	fffff097          	auipc	ra,0xfffff
    80201926:	360080e7          	jalr	864(ra) # 80200c82 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    8020192a:	00006597          	auipc	a1,0x6
    8020192e:	d9658593          	addi	a1,a1,-618 # 802076c0 <etext+0x6c0>
    80201932:	00006517          	auipc	a0,0x6
    80201936:	dae50513          	addi	a0,a0,-594 # 802076e0 <etext+0x6e0>
    8020193a:	fffff097          	auipc	ra,0xfffff
    8020193e:	348080e7          	jalr	840(ra) # 80200c82 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80201942:	00006597          	auipc	a1,0x6
    80201946:	db658593          	addi	a1,a1,-586 # 802076f8 <etext+0x6f8>
    8020194a:	00006517          	auipc	a0,0x6
    8020194e:	efe50513          	addi	a0,a0,-258 # 80207848 <etext+0x848>
    80201952:	fffff097          	auipc	ra,0xfffff
    80201956:	330080e7          	jalr	816(ra) # 80200c82 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    8020195a:	00006517          	auipc	a0,0x6
    8020195e:	f0e50513          	addi	a0,a0,-242 # 80207868 <etext+0x868>
    80201962:	fffff097          	auipc	ra,0xfffff
    80201966:	320080e7          	jalr	800(ra) # 80200c82 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    8020196a:	0ff00693          	li	a3,255
    8020196e:	f0100613          	li	a2,-255
    80201972:	0ff00593          	li	a1,255
    80201976:	00006517          	auipc	a0,0x6
    8020197a:	f0a50513          	addi	a0,a0,-246 # 80207880 <etext+0x880>
    8020197e:	fffff097          	auipc	ra,0xfffff
    80201982:	304080e7          	jalr	772(ra) # 80200c82 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80201986:	00006517          	auipc	a0,0x6
    8020198a:	f2250513          	addi	a0,a0,-222 # 802078a8 <etext+0x8a8>
    8020198e:	fffff097          	auipc	ra,0xfffff
    80201992:	2f4080e7          	jalr	756(ra) # 80200c82 <printf>
	printf("  100%% 完成!\n");
    80201996:	00006517          	auipc	a0,0x6
    8020199a:	f2a50513          	addi	a0,a0,-214 # 802078c0 <etext+0x8c0>
    8020199e:	fffff097          	auipc	ra,0xfffff
    802019a2:	2e4080e7          	jalr	740(ra) # 80200c82 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    802019a6:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    802019aa:	00006517          	auipc	a0,0x6
    802019ae:	f2e50513          	addi	a0,a0,-210 # 802078d8 <etext+0x8d8>
    802019b2:	fffff097          	auipc	ra,0xfffff
    802019b6:	2d0080e7          	jalr	720(ra) # 80200c82 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    802019ba:	fe843583          	ld	a1,-24(s0)
    802019be:	00006517          	auipc	a0,0x6
    802019c2:	f3250513          	addi	a0,a0,-206 # 802078f0 <etext+0x8f0>
    802019c6:	fffff097          	auipc	ra,0xfffff
    802019ca:	2bc080e7          	jalr	700(ra) # 80200c82 <printf>
	
	// 测试指针格式
	int var = 42;
    802019ce:	02a00793          	li	a5,42
    802019d2:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    802019d6:	00006517          	auipc	a0,0x6
    802019da:	f3250513          	addi	a0,a0,-206 # 80207908 <etext+0x908>
    802019de:	fffff097          	auipc	ra,0xfffff
    802019e2:	2a4080e7          	jalr	676(ra) # 80200c82 <printf>
	printf("  Address of var: %p\n", &var);
    802019e6:	fe440793          	addi	a5,s0,-28
    802019ea:	85be                	mv	a1,a5
    802019ec:	00006517          	auipc	a0,0x6
    802019f0:	f2c50513          	addi	a0,a0,-212 # 80207918 <etext+0x918>
    802019f4:	fffff097          	auipc	ra,0xfffff
    802019f8:	28e080e7          	jalr	654(ra) # 80200c82 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    802019fc:	00006517          	auipc	a0,0x6
    80201a00:	f3450513          	addi	a0,a0,-204 # 80207930 <etext+0x930>
    80201a04:	fffff097          	auipc	ra,0xfffff
    80201a08:	27e080e7          	jalr	638(ra) # 80200c82 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201a0c:	55fd                	li	a1,-1
    80201a0e:	00006517          	auipc	a0,0x6
    80201a12:	f4250513          	addi	a0,a0,-190 # 80207950 <etext+0x950>
    80201a16:	fffff097          	auipc	ra,0xfffff
    80201a1a:	26c080e7          	jalr	620(ra) # 80200c82 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201a1e:	00006517          	auipc	a0,0x6
    80201a22:	f4a50513          	addi	a0,a0,-182 # 80207968 <etext+0x968>
    80201a26:	fffff097          	auipc	ra,0xfffff
    80201a2a:	25c080e7          	jalr	604(ra) # 80200c82 <printf>
	printf("  Binary of 5: %b\n", 5);
    80201a2e:	4595                	li	a1,5
    80201a30:	00006517          	auipc	a0,0x6
    80201a34:	f5050513          	addi	a0,a0,-176 # 80207980 <etext+0x980>
    80201a38:	fffff097          	auipc	ra,0xfffff
    80201a3c:	24a080e7          	jalr	586(ra) # 80200c82 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201a40:	45a1                	li	a1,8
    80201a42:	00006517          	auipc	a0,0x6
    80201a46:	f5650513          	addi	a0,a0,-170 # 80207998 <etext+0x998>
    80201a4a:	fffff097          	auipc	ra,0xfffff
    80201a4e:	238080e7          	jalr	568(ra) # 80200c82 <printf>
	printf("=== Printf测试结束 ===\n");
    80201a52:	00006517          	auipc	a0,0x6
    80201a56:	f5e50513          	addi	a0,a0,-162 # 802079b0 <etext+0x9b0>
    80201a5a:	fffff097          	auipc	ra,0xfffff
    80201a5e:	228080e7          	jalr	552(ra) # 80200c82 <printf>
}
    80201a62:	0001                	nop
    80201a64:	60e2                	ld	ra,24(sp)
    80201a66:	6442                	ld	s0,16(sp)
    80201a68:	6105                	addi	sp,sp,32
    80201a6a:	8082                	ret

0000000080201a6c <test_curse_move>:
void test_curse_move(){
    80201a6c:	1101                	addi	sp,sp,-32
    80201a6e:	ec06                	sd	ra,24(sp)
    80201a70:	e822                	sd	s0,16(sp)
    80201a72:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    80201a74:	fffff097          	auipc	ra,0xfffff
    80201a78:	726080e7          	jalr	1830(ra) # 8020119a <clear_screen>
	printf("=== 光标移动测试 ===\n");
    80201a7c:	00006517          	auipc	a0,0x6
    80201a80:	f5450513          	addi	a0,a0,-172 # 802079d0 <etext+0x9d0>
    80201a84:	fffff097          	auipc	ra,0xfffff
    80201a88:	1fe080e7          	jalr	510(ra) # 80200c82 <printf>
	for (int i = 3; i <= 7; i++) {
    80201a8c:	478d                	li	a5,3
    80201a8e:	fef42623          	sw	a5,-20(s0)
    80201a92:	a881                	j	80201ae2 <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    80201a94:	4785                	li	a5,1
    80201a96:	fef42423          	sw	a5,-24(s0)
    80201a9a:	a805                	j	80201aca <test_curse_move+0x5e>
			goto_rc(i, j);
    80201a9c:	fe842703          	lw	a4,-24(s0)
    80201aa0:	fec42783          	lw	a5,-20(s0)
    80201aa4:	85ba                	mv	a1,a4
    80201aa6:	853e                	mv	a0,a5
    80201aa8:	00000097          	auipc	ra,0x0
    80201aac:	95c080e7          	jalr	-1700(ra) # 80201404 <goto_rc>
			printf("*");
    80201ab0:	00006517          	auipc	a0,0x6
    80201ab4:	f4050513          	addi	a0,a0,-192 # 802079f0 <etext+0x9f0>
    80201ab8:	fffff097          	auipc	ra,0xfffff
    80201abc:	1ca080e7          	jalr	458(ra) # 80200c82 <printf>
		for (int j = 1; j <= 10; j++) {
    80201ac0:	fe842783          	lw	a5,-24(s0)
    80201ac4:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdf36f1>
    80201ac6:	fef42423          	sw	a5,-24(s0)
    80201aca:	fe842783          	lw	a5,-24(s0)
    80201ace:	0007871b          	sext.w	a4,a5
    80201ad2:	47a9                	li	a5,10
    80201ad4:	fce7d4e3          	bge	a5,a4,80201a9c <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    80201ad8:	fec42783          	lw	a5,-20(s0)
    80201adc:	2785                	addiw	a5,a5,1
    80201ade:	fef42623          	sw	a5,-20(s0)
    80201ae2:	fec42783          	lw	a5,-20(s0)
    80201ae6:	0007871b          	sext.w	a4,a5
    80201aea:	479d                	li	a5,7
    80201aec:	fae7d4e3          	bge	a5,a4,80201a94 <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201af0:	4585                	li	a1,1
    80201af2:	4525                	li	a0,9
    80201af4:	00000097          	auipc	ra,0x0
    80201af8:	910080e7          	jalr	-1776(ra) # 80201404 <goto_rc>
	save_cursor();
    80201afc:	00000097          	auipc	ra,0x0
    80201b00:	840080e7          	jalr	-1984(ra) # 8020133c <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201b04:	4515                	li	a0,5
    80201b06:	fffff097          	auipc	ra,0xfffff
    80201b0a:	6c6080e7          	jalr	1734(ra) # 802011cc <cursor_up>
	cursor_right(2);
    80201b0e:	4509                	li	a0,2
    80201b10:	fffff097          	auipc	ra,0xfffff
    80201b14:	774080e7          	jalr	1908(ra) # 80201284 <cursor_right>
	printf("+++++");
    80201b18:	00006517          	auipc	a0,0x6
    80201b1c:	ee050513          	addi	a0,a0,-288 # 802079f8 <etext+0x9f8>
    80201b20:	fffff097          	auipc	ra,0xfffff
    80201b24:	162080e7          	jalr	354(ra) # 80200c82 <printf>
	cursor_down(2);
    80201b28:	4509                	li	a0,2
    80201b2a:	fffff097          	auipc	ra,0xfffff
    80201b2e:	6fe080e7          	jalr	1790(ra) # 80201228 <cursor_down>
	cursor_left(5);
    80201b32:	4515                	li	a0,5
    80201b34:	fffff097          	auipc	ra,0xfffff
    80201b38:	7ac080e7          	jalr	1964(ra) # 802012e0 <cursor_left>
	printf("-----");
    80201b3c:	00006517          	auipc	a0,0x6
    80201b40:	ec450513          	addi	a0,a0,-316 # 80207a00 <etext+0xa00>
    80201b44:	fffff097          	auipc	ra,0xfffff
    80201b48:	13e080e7          	jalr	318(ra) # 80200c82 <printf>
	restore_cursor();
    80201b4c:	00000097          	auipc	ra,0x0
    80201b50:	824080e7          	jalr	-2012(ra) # 80201370 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80201b54:	00006517          	auipc	a0,0x6
    80201b58:	eb450513          	addi	a0,a0,-332 # 80207a08 <etext+0xa08>
    80201b5c:	fffff097          	auipc	ra,0xfffff
    80201b60:	126080e7          	jalr	294(ra) # 80200c82 <printf>
}
    80201b64:	0001                	nop
    80201b66:	60e2                	ld	ra,24(sp)
    80201b68:	6442                	ld	s0,16(sp)
    80201b6a:	6105                	addi	sp,sp,32
    80201b6c:	8082                	ret

0000000080201b6e <test_basic_colors>:

void test_basic_colors(void) {
    80201b6e:	1141                	addi	sp,sp,-16
    80201b70:	e406                	sd	ra,8(sp)
    80201b72:	e022                	sd	s0,0(sp)
    80201b74:	0800                	addi	s0,sp,16
    clear_screen();
    80201b76:	fffff097          	auipc	ra,0xfffff
    80201b7a:	624080e7          	jalr	1572(ra) # 8020119a <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    80201b7e:	00006517          	auipc	a0,0x6
    80201b82:	eb250513          	addi	a0,a0,-334 # 80207a30 <etext+0xa30>
    80201b86:	fffff097          	auipc	ra,0xfffff
    80201b8a:	0fc080e7          	jalr	252(ra) # 80200c82 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80201b8e:	00006517          	auipc	a0,0x6
    80201b92:	ec250513          	addi	a0,a0,-318 # 80207a50 <etext+0xa50>
    80201b96:	fffff097          	auipc	ra,0xfffff
    80201b9a:	0ec080e7          	jalr	236(ra) # 80200c82 <printf>
    color_red();    printf("红色文字 ");
    80201b9e:	00000097          	auipc	ra,0x0
    80201ba2:	9e4080e7          	jalr	-1564(ra) # 80201582 <color_red>
    80201ba6:	00006517          	auipc	a0,0x6
    80201baa:	ec250513          	addi	a0,a0,-318 # 80207a68 <etext+0xa68>
    80201bae:	fffff097          	auipc	ra,0xfffff
    80201bb2:	0d4080e7          	jalr	212(ra) # 80200c82 <printf>
    color_green();  printf("绿色文字 ");
    80201bb6:	00000097          	auipc	ra,0x0
    80201bba:	9e8080e7          	jalr	-1560(ra) # 8020159e <color_green>
    80201bbe:	00006517          	auipc	a0,0x6
    80201bc2:	eba50513          	addi	a0,a0,-326 # 80207a78 <etext+0xa78>
    80201bc6:	fffff097          	auipc	ra,0xfffff
    80201bca:	0bc080e7          	jalr	188(ra) # 80200c82 <printf>
    color_yellow(); printf("黄色文字 ");
    80201bce:	00000097          	auipc	ra,0x0
    80201bd2:	9ee080e7          	jalr	-1554(ra) # 802015bc <color_yellow>
    80201bd6:	00006517          	auipc	a0,0x6
    80201bda:	eb250513          	addi	a0,a0,-334 # 80207a88 <etext+0xa88>
    80201bde:	fffff097          	auipc	ra,0xfffff
    80201be2:	0a4080e7          	jalr	164(ra) # 80200c82 <printf>
    color_blue();   printf("蓝色文字 ");
    80201be6:	00000097          	auipc	ra,0x0
    80201bea:	9f4080e7          	jalr	-1548(ra) # 802015da <color_blue>
    80201bee:	00006517          	auipc	a0,0x6
    80201bf2:	eaa50513          	addi	a0,a0,-342 # 80207a98 <etext+0xa98>
    80201bf6:	fffff097          	auipc	ra,0xfffff
    80201bfa:	08c080e7          	jalr	140(ra) # 80200c82 <printf>
    color_purple(); printf("紫色文字 ");
    80201bfe:	00000097          	auipc	ra,0x0
    80201c02:	9fa080e7          	jalr	-1542(ra) # 802015f8 <color_purple>
    80201c06:	00006517          	auipc	a0,0x6
    80201c0a:	ea250513          	addi	a0,a0,-350 # 80207aa8 <etext+0xaa8>
    80201c0e:	fffff097          	auipc	ra,0xfffff
    80201c12:	074080e7          	jalr	116(ra) # 80200c82 <printf>
    color_cyan();   printf("青色文字 ");
    80201c16:	00000097          	auipc	ra,0x0
    80201c1a:	a00080e7          	jalr	-1536(ra) # 80201616 <color_cyan>
    80201c1e:	00006517          	auipc	a0,0x6
    80201c22:	e9a50513          	addi	a0,a0,-358 # 80207ab8 <etext+0xab8>
    80201c26:	fffff097          	auipc	ra,0xfffff
    80201c2a:	05c080e7          	jalr	92(ra) # 80200c82 <printf>
    color_reverse();  printf("反色文字");
    80201c2e:	00000097          	auipc	ra,0x0
    80201c32:	a06080e7          	jalr	-1530(ra) # 80201634 <color_reverse>
    80201c36:	00006517          	auipc	a0,0x6
    80201c3a:	e9250513          	addi	a0,a0,-366 # 80207ac8 <etext+0xac8>
    80201c3e:	fffff097          	auipc	ra,0xfffff
    80201c42:	044080e7          	jalr	68(ra) # 80200c82 <printf>
    reset_color();
    80201c46:	00000097          	auipc	ra,0x0
    80201c4a:	838080e7          	jalr	-1992(ra) # 8020147e <reset_color>
    printf("\n\n");
    80201c4e:	00006517          	auipc	a0,0x6
    80201c52:	e8a50513          	addi	a0,a0,-374 # 80207ad8 <etext+0xad8>
    80201c56:	fffff097          	auipc	ra,0xfffff
    80201c5a:	02c080e7          	jalr	44(ra) # 80200c82 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80201c5e:	00006517          	auipc	a0,0x6
    80201c62:	e8250513          	addi	a0,a0,-382 # 80207ae0 <etext+0xae0>
    80201c66:	fffff097          	auipc	ra,0xfffff
    80201c6a:	01c080e7          	jalr	28(ra) # 80200c82 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80201c6e:	02900513          	li	a0,41
    80201c72:	00000097          	auipc	ra,0x0
    80201c76:	89e080e7          	jalr	-1890(ra) # 80201510 <set_bg_color>
    80201c7a:	00006517          	auipc	a0,0x6
    80201c7e:	e7e50513          	addi	a0,a0,-386 # 80207af8 <etext+0xaf8>
    80201c82:	fffff097          	auipc	ra,0xfffff
    80201c86:	000080e7          	jalr	ra # 80200c82 <printf>
    80201c8a:	fffff097          	auipc	ra,0xfffff
    80201c8e:	7f4080e7          	jalr	2036(ra) # 8020147e <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80201c92:	02a00513          	li	a0,42
    80201c96:	00000097          	auipc	ra,0x0
    80201c9a:	87a080e7          	jalr	-1926(ra) # 80201510 <set_bg_color>
    80201c9e:	00006517          	auipc	a0,0x6
    80201ca2:	e6a50513          	addi	a0,a0,-406 # 80207b08 <etext+0xb08>
    80201ca6:	fffff097          	auipc	ra,0xfffff
    80201caa:	fdc080e7          	jalr	-36(ra) # 80200c82 <printf>
    80201cae:	fffff097          	auipc	ra,0xfffff
    80201cb2:	7d0080e7          	jalr	2000(ra) # 8020147e <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80201cb6:	02b00513          	li	a0,43
    80201cba:	00000097          	auipc	ra,0x0
    80201cbe:	856080e7          	jalr	-1962(ra) # 80201510 <set_bg_color>
    80201cc2:	00006517          	auipc	a0,0x6
    80201cc6:	e5650513          	addi	a0,a0,-426 # 80207b18 <etext+0xb18>
    80201cca:	fffff097          	auipc	ra,0xfffff
    80201cce:	fb8080e7          	jalr	-72(ra) # 80200c82 <printf>
    80201cd2:	fffff097          	auipc	ra,0xfffff
    80201cd6:	7ac080e7          	jalr	1964(ra) # 8020147e <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80201cda:	02c00513          	li	a0,44
    80201cde:	00000097          	auipc	ra,0x0
    80201ce2:	832080e7          	jalr	-1998(ra) # 80201510 <set_bg_color>
    80201ce6:	00006517          	auipc	a0,0x6
    80201cea:	e4250513          	addi	a0,a0,-446 # 80207b28 <etext+0xb28>
    80201cee:	fffff097          	auipc	ra,0xfffff
    80201cf2:	f94080e7          	jalr	-108(ra) # 80200c82 <printf>
    80201cf6:	fffff097          	auipc	ra,0xfffff
    80201cfa:	788080e7          	jalr	1928(ra) # 8020147e <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201cfe:	02f00513          	li	a0,47
    80201d02:	00000097          	auipc	ra,0x0
    80201d06:	80e080e7          	jalr	-2034(ra) # 80201510 <set_bg_color>
    80201d0a:	00006517          	auipc	a0,0x6
    80201d0e:	e2e50513          	addi	a0,a0,-466 # 80207b38 <etext+0xb38>
    80201d12:	fffff097          	auipc	ra,0xfffff
    80201d16:	f70080e7          	jalr	-144(ra) # 80200c82 <printf>
    80201d1a:	fffff097          	auipc	ra,0xfffff
    80201d1e:	764080e7          	jalr	1892(ra) # 8020147e <reset_color>
    printf("\n\n");
    80201d22:	00006517          	auipc	a0,0x6
    80201d26:	db650513          	addi	a0,a0,-586 # 80207ad8 <etext+0xad8>
    80201d2a:	fffff097          	auipc	ra,0xfffff
    80201d2e:	f58080e7          	jalr	-168(ra) # 80200c82 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201d32:	00006517          	auipc	a0,0x6
    80201d36:	e1650513          	addi	a0,a0,-490 # 80207b48 <etext+0xb48>
    80201d3a:	fffff097          	auipc	ra,0xfffff
    80201d3e:	f48080e7          	jalr	-184(ra) # 80200c82 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201d42:	02c00593          	li	a1,44
    80201d46:	457d                	li	a0,31
    80201d48:	00000097          	auipc	ra,0x0
    80201d4c:	90a080e7          	jalr	-1782(ra) # 80201652 <set_color>
    80201d50:	00006517          	auipc	a0,0x6
    80201d54:	e1050513          	addi	a0,a0,-496 # 80207b60 <etext+0xb60>
    80201d58:	fffff097          	auipc	ra,0xfffff
    80201d5c:	f2a080e7          	jalr	-214(ra) # 80200c82 <printf>
    80201d60:	fffff097          	auipc	ra,0xfffff
    80201d64:	71e080e7          	jalr	1822(ra) # 8020147e <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201d68:	02d00593          	li	a1,45
    80201d6c:	02100513          	li	a0,33
    80201d70:	00000097          	auipc	ra,0x0
    80201d74:	8e2080e7          	jalr	-1822(ra) # 80201652 <set_color>
    80201d78:	00006517          	auipc	a0,0x6
    80201d7c:	df850513          	addi	a0,a0,-520 # 80207b70 <etext+0xb70>
    80201d80:	fffff097          	auipc	ra,0xfffff
    80201d84:	f02080e7          	jalr	-254(ra) # 80200c82 <printf>
    80201d88:	fffff097          	auipc	ra,0xfffff
    80201d8c:	6f6080e7          	jalr	1782(ra) # 8020147e <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201d90:	02f00593          	li	a1,47
    80201d94:	02000513          	li	a0,32
    80201d98:	00000097          	auipc	ra,0x0
    80201d9c:	8ba080e7          	jalr	-1862(ra) # 80201652 <set_color>
    80201da0:	00006517          	auipc	a0,0x6
    80201da4:	de050513          	addi	a0,a0,-544 # 80207b80 <etext+0xb80>
    80201da8:	fffff097          	auipc	ra,0xfffff
    80201dac:	eda080e7          	jalr	-294(ra) # 80200c82 <printf>
    80201db0:	fffff097          	auipc	ra,0xfffff
    80201db4:	6ce080e7          	jalr	1742(ra) # 8020147e <reset_color>
    printf("\n\n");
    80201db8:	00006517          	auipc	a0,0x6
    80201dbc:	d2050513          	addi	a0,a0,-736 # 80207ad8 <etext+0xad8>
    80201dc0:	fffff097          	auipc	ra,0xfffff
    80201dc4:	ec2080e7          	jalr	-318(ra) # 80200c82 <printf>
	reset_color();
    80201dc8:	fffff097          	auipc	ra,0xfffff
    80201dcc:	6b6080e7          	jalr	1718(ra) # 8020147e <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201dd0:	00006517          	auipc	a0,0x6
    80201dd4:	dc050513          	addi	a0,a0,-576 # 80207b90 <etext+0xb90>
    80201dd8:	fffff097          	auipc	ra,0xfffff
    80201ddc:	eaa080e7          	jalr	-342(ra) # 80200c82 <printf>
	cursor_up(1); // 光标上移一行
    80201de0:	4505                	li	a0,1
    80201de2:	fffff097          	auipc	ra,0xfffff
    80201de6:	3ea080e7          	jalr	1002(ra) # 802011cc <cursor_up>
	clear_line();
    80201dea:	00000097          	auipc	ra,0x0
    80201dee:	8a4080e7          	jalr	-1884(ra) # 8020168e <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201df2:	00006517          	auipc	a0,0x6
    80201df6:	dd650513          	addi	a0,a0,-554 # 80207bc8 <etext+0xbc8>
    80201dfa:	fffff097          	auipc	ra,0xfffff
    80201dfe:	e88080e7          	jalr	-376(ra) # 80200c82 <printf>
    80201e02:	0001                	nop
    80201e04:	60a2                	ld	ra,8(sp)
    80201e06:	6402                	ld	s0,0(sp)
    80201e08:	0141                	addi	sp,sp,16
    80201e0a:	8082                	ret

0000000080201e0c <memset>:
#include "defs.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201e0c:	7139                	addi	sp,sp,-64
    80201e0e:	fc22                	sd	s0,56(sp)
    80201e10:	0080                	addi	s0,sp,64
    80201e12:	fca43c23          	sd	a0,-40(s0)
    80201e16:	87ae                	mv	a5,a1
    80201e18:	fcc43423          	sd	a2,-56(s0)
    80201e1c:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201e20:	fd843783          	ld	a5,-40(s0)
    80201e24:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    80201e28:	a829                	j	80201e42 <memset+0x36>
        *p++ = (unsigned char)c;
    80201e2a:	fe843783          	ld	a5,-24(s0)
    80201e2e:	00178713          	addi	a4,a5,1
    80201e32:	fee43423          	sd	a4,-24(s0)
    80201e36:	fd442703          	lw	a4,-44(s0)
    80201e3a:	0ff77713          	zext.b	a4,a4
    80201e3e:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    80201e42:	fc843783          	ld	a5,-56(s0)
    80201e46:	fff78713          	addi	a4,a5,-1
    80201e4a:	fce43423          	sd	a4,-56(s0)
    80201e4e:	fff1                	bnez	a5,80201e2a <memset+0x1e>
    return dst;
    80201e50:	fd843783          	ld	a5,-40(s0)
}
    80201e54:	853e                	mv	a0,a5
    80201e56:	7462                	ld	s0,56(sp)
    80201e58:	6121                	addi	sp,sp,64
    80201e5a:	8082                	ret

0000000080201e5c <memmove>:
void *memmove(void *dst, const void *src, unsigned long n) {
    80201e5c:	7139                	addi	sp,sp,-64
    80201e5e:	fc22                	sd	s0,56(sp)
    80201e60:	0080                	addi	s0,sp,64
    80201e62:	fca43c23          	sd	a0,-40(s0)
    80201e66:	fcb43823          	sd	a1,-48(s0)
    80201e6a:	fcc43423          	sd	a2,-56(s0)
	unsigned char *d = dst;
    80201e6e:	fd843783          	ld	a5,-40(s0)
    80201e72:	fef43423          	sd	a5,-24(s0)
	const unsigned char *s = src;
    80201e76:	fd043783          	ld	a5,-48(s0)
    80201e7a:	fef43023          	sd	a5,-32(s0)
	if (d < s) {
    80201e7e:	fe843703          	ld	a4,-24(s0)
    80201e82:	fe043783          	ld	a5,-32(s0)
    80201e86:	02f77b63          	bgeu	a4,a5,80201ebc <memmove+0x60>
		while (n-- > 0)
    80201e8a:	a00d                	j	80201eac <memmove+0x50>
			*d++ = *s++;
    80201e8c:	fe043703          	ld	a4,-32(s0)
    80201e90:	00170793          	addi	a5,a4,1
    80201e94:	fef43023          	sd	a5,-32(s0)
    80201e98:	fe843783          	ld	a5,-24(s0)
    80201e9c:	00178693          	addi	a3,a5,1
    80201ea0:	fed43423          	sd	a3,-24(s0)
    80201ea4:	00074703          	lbu	a4,0(a4)
    80201ea8:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201eac:	fc843783          	ld	a5,-56(s0)
    80201eb0:	fff78713          	addi	a4,a5,-1
    80201eb4:	fce43423          	sd	a4,-56(s0)
    80201eb8:	fbf1                	bnez	a5,80201e8c <memmove+0x30>
    80201eba:	a889                	j	80201f0c <memmove+0xb0>
	} else {
		d += n;
    80201ebc:	fe843703          	ld	a4,-24(s0)
    80201ec0:	fc843783          	ld	a5,-56(s0)
    80201ec4:	97ba                	add	a5,a5,a4
    80201ec6:	fef43423          	sd	a5,-24(s0)
		s += n;
    80201eca:	fe043703          	ld	a4,-32(s0)
    80201ece:	fc843783          	ld	a5,-56(s0)
    80201ed2:	97ba                	add	a5,a5,a4
    80201ed4:	fef43023          	sd	a5,-32(s0)
		while (n-- > 0)
    80201ed8:	a01d                	j	80201efe <memmove+0xa2>
			*(--d) = *(--s);
    80201eda:	fe043783          	ld	a5,-32(s0)
    80201ede:	17fd                	addi	a5,a5,-1
    80201ee0:	fef43023          	sd	a5,-32(s0)
    80201ee4:	fe843783          	ld	a5,-24(s0)
    80201ee8:	17fd                	addi	a5,a5,-1
    80201eea:	fef43423          	sd	a5,-24(s0)
    80201eee:	fe043783          	ld	a5,-32(s0)
    80201ef2:	0007c703          	lbu	a4,0(a5)
    80201ef6:	fe843783          	ld	a5,-24(s0)
    80201efa:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201efe:	fc843783          	ld	a5,-56(s0)
    80201f02:	fff78713          	addi	a4,a5,-1
    80201f06:	fce43423          	sd	a4,-56(s0)
    80201f0a:	fbe1                	bnez	a5,80201eda <memmove+0x7e>
	}
	return dst;
    80201f0c:	fd843783          	ld	a5,-40(s0)
}
    80201f10:	853e                	mv	a0,a5
    80201f12:	7462                	ld	s0,56(sp)
    80201f14:	6121                	addi	sp,sp,64
    80201f16:	8082                	ret

0000000080201f18 <memcpy>:
void *memcpy(void *dst, const void *src, size_t n) {
    80201f18:	715d                	addi	sp,sp,-80
    80201f1a:	e4a2                	sd	s0,72(sp)
    80201f1c:	0880                	addi	s0,sp,80
    80201f1e:	fca43423          	sd	a0,-56(s0)
    80201f22:	fcb43023          	sd	a1,-64(s0)
    80201f26:	fac43c23          	sd	a2,-72(s0)
    char *d = dst;
    80201f2a:	fc843783          	ld	a5,-56(s0)
    80201f2e:	fef43023          	sd	a5,-32(s0)
    const char *s = src;
    80201f32:	fc043783          	ld	a5,-64(s0)
    80201f36:	fcf43c23          	sd	a5,-40(s0)
    for (size_t i = 0; i < n; i++) {
    80201f3a:	fe043423          	sd	zero,-24(s0)
    80201f3e:	a025                	j	80201f66 <memcpy+0x4e>
        d[i] = s[i];
    80201f40:	fd843703          	ld	a4,-40(s0)
    80201f44:	fe843783          	ld	a5,-24(s0)
    80201f48:	973e                	add	a4,a4,a5
    80201f4a:	fe043683          	ld	a3,-32(s0)
    80201f4e:	fe843783          	ld	a5,-24(s0)
    80201f52:	97b6                	add	a5,a5,a3
    80201f54:	00074703          	lbu	a4,0(a4)
    80201f58:	00e78023          	sb	a4,0(a5)
    for (size_t i = 0; i < n; i++) {
    80201f5c:	fe843783          	ld	a5,-24(s0)
    80201f60:	0785                	addi	a5,a5,1
    80201f62:	fef43423          	sd	a5,-24(s0)
    80201f66:	fe843703          	ld	a4,-24(s0)
    80201f6a:	fb843783          	ld	a5,-72(s0)
    80201f6e:	fcf769e3          	bltu	a4,a5,80201f40 <memcpy+0x28>
    }
    return dst;
    80201f72:	fc843783          	ld	a5,-56(s0)
    80201f76:	853e                	mv	a0,a5
    80201f78:	6426                	ld	s0,72(sp)
    80201f7a:	6161                	addi	sp,sp,80
    80201f7c:	8082                	ret

0000000080201f7e <assert>:
    80201f7e:	1101                	addi	sp,sp,-32
    80201f80:	ec06                	sd	ra,24(sp)
    80201f82:	e822                	sd	s0,16(sp)
    80201f84:	1000                	addi	s0,sp,32
    80201f86:	87aa                	mv	a5,a0
    80201f88:	fef42623          	sw	a5,-20(s0)
    80201f8c:	fec42783          	lw	a5,-20(s0)
    80201f90:	2781                	sext.w	a5,a5
    80201f92:	e79d                	bnez	a5,80201fc0 <assert+0x42>
    80201f94:	18f00613          	li	a2,399
    80201f98:	00006597          	auipc	a1,0x6
    80201f9c:	c5058593          	addi	a1,a1,-944 # 80207be8 <etext+0xbe8>
    80201fa0:	00006517          	auipc	a0,0x6
    80201fa4:	c5850513          	addi	a0,a0,-936 # 80207bf8 <etext+0xbf8>
    80201fa8:	fffff097          	auipc	ra,0xfffff
    80201fac:	cda080e7          	jalr	-806(ra) # 80200c82 <printf>
    80201fb0:	00006517          	auipc	a0,0x6
    80201fb4:	c7050513          	addi	a0,a0,-912 # 80207c20 <etext+0xc20>
    80201fb8:	fffff097          	auipc	ra,0xfffff
    80201fbc:	716080e7          	jalr	1814(ra) # 802016ce <panic>
    80201fc0:	0001                	nop
    80201fc2:	60e2                	ld	ra,24(sp)
    80201fc4:	6442                	ld	s0,16(sp)
    80201fc6:	6105                	addi	sp,sp,32
    80201fc8:	8082                	ret

0000000080201fca <sv39_sign_extend>:
    80201fca:	1101                	addi	sp,sp,-32
    80201fcc:	ec22                	sd	s0,24(sp)
    80201fce:	1000                	addi	s0,sp,32
    80201fd0:	fea43423          	sd	a0,-24(s0)
    80201fd4:	fe843703          	ld	a4,-24(s0)
    80201fd8:	4785                	li	a5,1
    80201fda:	179a                	slli	a5,a5,0x26
    80201fdc:	8ff9                	and	a5,a5,a4
    80201fde:	c799                	beqz	a5,80201fec <sv39_sign_extend+0x22>
    80201fe0:	fe843703          	ld	a4,-24(s0)
    80201fe4:	57fd                	li	a5,-1
    80201fe6:	179e                	slli	a5,a5,0x27
    80201fe8:	8fd9                	or	a5,a5,a4
    80201fea:	a031                	j	80201ff6 <sv39_sign_extend+0x2c>
    80201fec:	fe843703          	ld	a4,-24(s0)
    80201ff0:	57fd                	li	a5,-1
    80201ff2:	83e5                	srli	a5,a5,0x19
    80201ff4:	8ff9                	and	a5,a5,a4
    80201ff6:	853e                	mv	a0,a5
    80201ff8:	6462                	ld	s0,24(sp)
    80201ffa:	6105                	addi	sp,sp,32
    80201ffc:	8082                	ret

0000000080201ffe <sv39_check_valid>:
    80201ffe:	1101                	addi	sp,sp,-32
    80202000:	ec22                	sd	s0,24(sp)
    80202002:	1000                	addi	s0,sp,32
    80202004:	fea43423          	sd	a0,-24(s0)
    80202008:	fe843703          	ld	a4,-24(s0)
    8020200c:	57fd                	li	a5,-1
    8020200e:	83e5                	srli	a5,a5,0x19
    80202010:	00e7f863          	bgeu	a5,a4,80202020 <sv39_check_valid+0x22>
    80202014:	fe843703          	ld	a4,-24(s0)
    80202018:	57fd                	li	a5,-1
    8020201a:	179e                	slli	a5,a5,0x27
    8020201c:	00f76463          	bltu	a4,a5,80202024 <sv39_check_valid+0x26>
    80202020:	4785                	li	a5,1
    80202022:	a011                	j	80202026 <sv39_check_valid+0x28>
    80202024:	4781                	li	a5,0
    80202026:	853e                	mv	a0,a5
    80202028:	6462                	ld	s0,24(sp)
    8020202a:	6105                	addi	sp,sp,32
    8020202c:	8082                	ret

000000008020202e <px>:
static inline uint64 px(int level, uint64 va) {
    8020202e:	1101                	addi	sp,sp,-32
    80202030:	ec22                	sd	s0,24(sp)
    80202032:	1000                	addi	s0,sp,32
    80202034:	87aa                	mv	a5,a0
    80202036:	feb43023          	sd	a1,-32(s0)
    8020203a:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    8020203e:	fec42783          	lw	a5,-20(s0)
    80202042:	873e                	mv	a4,a5
    80202044:	87ba                	mv	a5,a4
    80202046:	0037979b          	slliw	a5,a5,0x3
    8020204a:	9fb9                	addw	a5,a5,a4
    8020204c:	2781                	sext.w	a5,a5
    8020204e:	27b1                	addiw	a5,a5,12
    80202050:	2781                	sext.w	a5,a5
    80202052:	873e                	mv	a4,a5
    80202054:	fe043783          	ld	a5,-32(s0)
    80202058:	00e7d7b3          	srl	a5,a5,a4
    8020205c:	1ff7f793          	andi	a5,a5,511
}
    80202060:	853e                	mv	a0,a5
    80202062:	6462                	ld	s0,24(sp)
    80202064:	6105                	addi	sp,sp,32
    80202066:	8082                	ret

0000000080202068 <create_pagetable>:
pagetable_t create_pagetable(void) {
    80202068:	1101                	addi	sp,sp,-32
    8020206a:	ec06                	sd	ra,24(sp)
    8020206c:	e822                	sd	s0,16(sp)
    8020206e:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    80202070:	00001097          	auipc	ra,0x1
    80202074:	190080e7          	jalr	400(ra) # 80203200 <alloc_page>
    80202078:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    8020207c:	fe843783          	ld	a5,-24(s0)
    80202080:	e399                	bnez	a5,80202086 <create_pagetable+0x1e>
        return 0;
    80202082:	4781                	li	a5,0
    80202084:	a819                	j	8020209a <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    80202086:	6605                	lui	a2,0x1
    80202088:	4581                	li	a1,0
    8020208a:	fe843503          	ld	a0,-24(s0)
    8020208e:	00000097          	auipc	ra,0x0
    80202092:	d7e080e7          	jalr	-642(ra) # 80201e0c <memset>
    return pt;
    80202096:	fe843783          	ld	a5,-24(s0)
}
    8020209a:	853e                	mv	a0,a5
    8020209c:	60e2                	ld	ra,24(sp)
    8020209e:	6442                	ld	s0,16(sp)
    802020a0:	6105                	addi	sp,sp,32
    802020a2:	8082                	ret

00000000802020a4 <walk_lookup>:
pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    802020a4:	7139                	addi	sp,sp,-64
    802020a6:	fc06                	sd	ra,56(sp)
    802020a8:	f822                	sd	s0,48(sp)
    802020aa:	0080                	addi	s0,sp,64
    802020ac:	fca43423          	sd	a0,-56(s0)
    802020b0:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    802020b4:	fc043503          	ld	a0,-64(s0)
    802020b8:	00000097          	auipc	ra,0x0
    802020bc:	f12080e7          	jalr	-238(ra) # 80201fca <sv39_sign_extend>
    802020c0:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    802020c4:	fc043503          	ld	a0,-64(s0)
    802020c8:	00000097          	auipc	ra,0x0
    802020cc:	f36080e7          	jalr	-202(ra) # 80201ffe <sv39_check_valid>
    802020d0:	87aa                	mv	a5,a0
    802020d2:	eb89                	bnez	a5,802020e4 <walk_lookup+0x40>
		panic("va out of sv39 range");
    802020d4:	00006517          	auipc	a0,0x6
    802020d8:	b5450513          	addi	a0,a0,-1196 # 80207c28 <etext+0xc28>
    802020dc:	fffff097          	auipc	ra,0xfffff
    802020e0:	5f2080e7          	jalr	1522(ra) # 802016ce <panic>
    for (int level = 2; level > 0; level--) {
    802020e4:	4789                	li	a5,2
    802020e6:	fef42623          	sw	a5,-20(s0)
    802020ea:	a0e9                	j	802021b4 <walk_lookup+0x110>
        pte_t *pte = &pt[px(level, va)];
    802020ec:	fec42783          	lw	a5,-20(s0)
    802020f0:	fc043583          	ld	a1,-64(s0)
    802020f4:	853e                	mv	a0,a5
    802020f6:	00000097          	auipc	ra,0x0
    802020fa:	f38080e7          	jalr	-200(ra) # 8020202e <px>
    802020fe:	87aa                	mv	a5,a0
    80202100:	078e                	slli	a5,a5,0x3
    80202102:	fc843703          	ld	a4,-56(s0)
    80202106:	97ba                	add	a5,a5,a4
    80202108:	fef43023          	sd	a5,-32(s0)
        if (!pte) {
    8020210c:	fe043783          	ld	a5,-32(s0)
    80202110:	ef91                	bnez	a5,8020212c <walk_lookup+0x88>
            printf("[WALK_LOOKUP] pte is NULL at level %d\n", level);
    80202112:	fec42783          	lw	a5,-20(s0)
    80202116:	85be                	mv	a1,a5
    80202118:	00006517          	auipc	a0,0x6
    8020211c:	b2850513          	addi	a0,a0,-1240 # 80207c40 <etext+0xc40>
    80202120:	fffff097          	auipc	ra,0xfffff
    80202124:	b62080e7          	jalr	-1182(ra) # 80200c82 <printf>
            return 0;
    80202128:	4781                	li	a5,0
    8020212a:	a075                	j	802021d6 <walk_lookup+0x132>
        if (*pte & PTE_V) {
    8020212c:	fe043783          	ld	a5,-32(s0)
    80202130:	639c                	ld	a5,0(a5)
    80202132:	8b85                	andi	a5,a5,1
    80202134:	cfa1                	beqz	a5,8020218c <walk_lookup+0xe8>
            uint64 pa = PTE2PA(*pte);
    80202136:	fe043783          	ld	a5,-32(s0)
    8020213a:	639c                	ld	a5,0(a5)
    8020213c:	83a9                	srli	a5,a5,0xa
    8020213e:	07b2                	slli	a5,a5,0xc
    80202140:	fcf43c23          	sd	a5,-40(s0)
            if (pa < KERNBASE || pa >= PHYSTOP) {
    80202144:	fd843703          	ld	a4,-40(s0)
    80202148:	800007b7          	lui	a5,0x80000
    8020214c:	fff7c793          	not	a5,a5
    80202150:	00e7f863          	bgeu	a5,a4,80202160 <walk_lookup+0xbc>
    80202154:	fd843703          	ld	a4,-40(s0)
    80202158:	47c5                	li	a5,17
    8020215a:	07ee                	slli	a5,a5,0x1b
    8020215c:	02f76363          	bltu	a4,a5,80202182 <walk_lookup+0xde>
                printf("[WALK_LOOKUP] 非法页表物理地址: 0x%lx (level %d, va=0x%lx)\n", pa, level, va);
    80202160:	fec42783          	lw	a5,-20(s0)
    80202164:	fc043683          	ld	a3,-64(s0)
    80202168:	863e                	mv	a2,a5
    8020216a:	fd843583          	ld	a1,-40(s0)
    8020216e:	00006517          	auipc	a0,0x6
    80202172:	afa50513          	addi	a0,a0,-1286 # 80207c68 <etext+0xc68>
    80202176:	fffff097          	auipc	ra,0xfffff
    8020217a:	b0c080e7          	jalr	-1268(ra) # 80200c82 <printf>
                return 0;
    8020217e:	4781                	li	a5,0
    80202180:	a899                	j	802021d6 <walk_lookup+0x132>
            pt = (pagetable_t)pa;
    80202182:	fd843783          	ld	a5,-40(s0)
    80202186:	fcf43423          	sd	a5,-56(s0)
    8020218a:	a005                	j	802021aa <walk_lookup+0x106>
            printf("[WALK_LOOKUP] 页表项无效: level=%d va=0x%lx\n", level, va);
    8020218c:	fec42783          	lw	a5,-20(s0)
    80202190:	fc043603          	ld	a2,-64(s0)
    80202194:	85be                	mv	a1,a5
    80202196:	00006517          	auipc	a0,0x6
    8020219a:	b1a50513          	addi	a0,a0,-1254 # 80207cb0 <etext+0xcb0>
    8020219e:	fffff097          	auipc	ra,0xfffff
    802021a2:	ae4080e7          	jalr	-1308(ra) # 80200c82 <printf>
            return 0;
    802021a6:	4781                	li	a5,0
    802021a8:	a03d                	j	802021d6 <walk_lookup+0x132>
    for (int level = 2; level > 0; level--) {
    802021aa:	fec42783          	lw	a5,-20(s0)
    802021ae:	37fd                	addiw	a5,a5,-1 # 7fffffff <_entry-0x200001>
    802021b0:	fef42623          	sw	a5,-20(s0)
    802021b4:	fec42783          	lw	a5,-20(s0)
    802021b8:	2781                	sext.w	a5,a5
    802021ba:	f2f049e3          	bgtz	a5,802020ec <walk_lookup+0x48>
    return &pt[px(0, va)];
    802021be:	fc043583          	ld	a1,-64(s0)
    802021c2:	4501                	li	a0,0
    802021c4:	00000097          	auipc	ra,0x0
    802021c8:	e6a080e7          	jalr	-406(ra) # 8020202e <px>
    802021cc:	87aa                	mv	a5,a0
    802021ce:	078e                	slli	a5,a5,0x3
    802021d0:	fc843703          	ld	a4,-56(s0)
    802021d4:	97ba                	add	a5,a5,a4
}
    802021d6:	853e                	mv	a0,a5
    802021d8:	70e2                	ld	ra,56(sp)
    802021da:	7442                	ld	s0,48(sp)
    802021dc:	6121                	addi	sp,sp,64
    802021de:	8082                	ret

00000000802021e0 <walk_create>:
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    802021e0:	7139                	addi	sp,sp,-64
    802021e2:	fc06                	sd	ra,56(sp)
    802021e4:	f822                	sd	s0,48(sp)
    802021e6:	0080                	addi	s0,sp,64
    802021e8:	fca43423          	sd	a0,-56(s0)
    802021ec:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    802021f0:	fc043503          	ld	a0,-64(s0)
    802021f4:	00000097          	auipc	ra,0x0
    802021f8:	dd6080e7          	jalr	-554(ra) # 80201fca <sv39_sign_extend>
    802021fc:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    80202200:	fc043503          	ld	a0,-64(s0)
    80202204:	00000097          	auipc	ra,0x0
    80202208:	dfa080e7          	jalr	-518(ra) # 80201ffe <sv39_check_valid>
    8020220c:	87aa                	mv	a5,a0
    8020220e:	eb89                	bnez	a5,80202220 <walk_create+0x40>
		panic("va out of sv39 range");
    80202210:	00006517          	auipc	a0,0x6
    80202214:	a1850513          	addi	a0,a0,-1512 # 80207c28 <etext+0xc28>
    80202218:	fffff097          	auipc	ra,0xfffff
    8020221c:	4b6080e7          	jalr	1206(ra) # 802016ce <panic>
    for (int level = 2; level > 0; level--) {
    80202220:	4789                	li	a5,2
    80202222:	fef42623          	sw	a5,-20(s0)
    80202226:	a059                	j	802022ac <walk_create+0xcc>
        pte_t *pte = &pt[px(level, va)];
    80202228:	fec42783          	lw	a5,-20(s0)
    8020222c:	fc043583          	ld	a1,-64(s0)
    80202230:	853e                	mv	a0,a5
    80202232:	00000097          	auipc	ra,0x0
    80202236:	dfc080e7          	jalr	-516(ra) # 8020202e <px>
    8020223a:	87aa                	mv	a5,a0
    8020223c:	078e                	slli	a5,a5,0x3
    8020223e:	fc843703          	ld	a4,-56(s0)
    80202242:	97ba                	add	a5,a5,a4
    80202244:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80202248:	fe043783          	ld	a5,-32(s0)
    8020224c:	639c                	ld	a5,0(a5)
    8020224e:	8b85                	andi	a5,a5,1
    80202250:	cb89                	beqz	a5,80202262 <walk_create+0x82>
            pt = (pagetable_t)PTE2PA(*pte);
    80202252:	fe043783          	ld	a5,-32(s0)
    80202256:	639c                	ld	a5,0(a5)
    80202258:	83a9                	srli	a5,a5,0xa
    8020225a:	07b2                	slli	a5,a5,0xc
    8020225c:	fcf43423          	sd	a5,-56(s0)
    80202260:	a089                	j	802022a2 <walk_create+0xc2>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    80202262:	00001097          	auipc	ra,0x1
    80202266:	f9e080e7          	jalr	-98(ra) # 80203200 <alloc_page>
    8020226a:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    8020226e:	fd843783          	ld	a5,-40(s0)
    80202272:	e399                	bnez	a5,80202278 <walk_create+0x98>
                return 0;
    80202274:	4781                	li	a5,0
    80202276:	a8a1                	j	802022ce <walk_create+0xee>
            memset(new_pt, 0, PGSIZE);
    80202278:	6605                	lui	a2,0x1
    8020227a:	4581                	li	a1,0
    8020227c:	fd843503          	ld	a0,-40(s0)
    80202280:	00000097          	auipc	ra,0x0
    80202284:	b8c080e7          	jalr	-1140(ra) # 80201e0c <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    80202288:	fd843783          	ld	a5,-40(s0)
    8020228c:	83b1                	srli	a5,a5,0xc
    8020228e:	07aa                	slli	a5,a5,0xa
    80202290:	0017e713          	ori	a4,a5,1
    80202294:	fe043783          	ld	a5,-32(s0)
    80202298:	e398                	sd	a4,0(a5)
            pt = new_pt;
    8020229a:	fd843783          	ld	a5,-40(s0)
    8020229e:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    802022a2:	fec42783          	lw	a5,-20(s0)
    802022a6:	37fd                	addiw	a5,a5,-1
    802022a8:	fef42623          	sw	a5,-20(s0)
    802022ac:	fec42783          	lw	a5,-20(s0)
    802022b0:	2781                	sext.w	a5,a5
    802022b2:	f6f04be3          	bgtz	a5,80202228 <walk_create+0x48>
    return &pt[px(0, va)];
    802022b6:	fc043583          	ld	a1,-64(s0)
    802022ba:	4501                	li	a0,0
    802022bc:	00000097          	auipc	ra,0x0
    802022c0:	d72080e7          	jalr	-654(ra) # 8020202e <px>
    802022c4:	87aa                	mv	a5,a0
    802022c6:	078e                	slli	a5,a5,0x3
    802022c8:	fc843703          	ld	a4,-56(s0)
    802022cc:	97ba                	add	a5,a5,a4
}
    802022ce:	853e                	mv	a0,a5
    802022d0:	70e2                	ld	ra,56(sp)
    802022d2:	7442                	ld	s0,48(sp)
    802022d4:	6121                	addi	sp,sp,64
    802022d6:	8082                	ret

00000000802022d8 <map_page>:
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    802022d8:	715d                	addi	sp,sp,-80
    802022da:	e486                	sd	ra,72(sp)
    802022dc:	e0a2                	sd	s0,64(sp)
    802022de:	0880                	addi	s0,sp,80
    802022e0:	fca43423          	sd	a0,-56(s0)
    802022e4:	fcb43023          	sd	a1,-64(s0)
    802022e8:	fac43c23          	sd	a2,-72(s0)
    802022ec:	87b6                	mv	a5,a3
    802022ee:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = myproc();
    802022f2:	00003097          	auipc	ra,0x3
    802022f6:	85e080e7          	jalr	-1954(ra) # 80204b50 <myproc>
    802022fa:	fea43023          	sd	a0,-32(s0)
    if (p && p->is_user && va >= 0x80000000) {
    802022fe:	fe043783          	ld	a5,-32(s0)
    80202302:	cb9d                	beqz	a5,80202338 <map_page+0x60>
    80202304:	fe043783          	ld	a5,-32(s0)
    80202308:	0a87a783          	lw	a5,168(a5)
    8020230c:	c795                	beqz	a5,80202338 <map_page+0x60>
    8020230e:	fc043703          	ld	a4,-64(s0)
    80202312:	800007b7          	lui	a5,0x80000
    80202316:	fff7c793          	not	a5,a5
    8020231a:	00e7ff63          	bgeu	a5,a4,80202338 <map_page+0x60>
        warning("map_page: 用户进程禁止映射内核空间");
    8020231e:	00006517          	auipc	a0,0x6
    80202322:	9ca50513          	addi	a0,a0,-1590 # 80207ce8 <etext+0xce8>
    80202326:	fffff097          	auipc	ra,0xfffff
    8020232a:	3dc080e7          	jalr	988(ra) # 80201702 <warning>
        exit_proc(-1);
    8020232e:	557d                	li	a0,-1
    80202330:	00003097          	auipc	ra,0x3
    80202334:	0ac080e7          	jalr	172(ra) # 802053dc <exit_proc>
    if ((va % PGSIZE) != 0)
    80202338:	fc043703          	ld	a4,-64(s0)
    8020233c:	6785                	lui	a5,0x1
    8020233e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80202340:	8ff9                	and	a5,a5,a4
    80202342:	cb89                	beqz	a5,80202354 <map_page+0x7c>
        panic("map_page: va not aligned");
    80202344:	00006517          	auipc	a0,0x6
    80202348:	9d450513          	addi	a0,a0,-1580 # 80207d18 <etext+0xd18>
    8020234c:	fffff097          	auipc	ra,0xfffff
    80202350:	382080e7          	jalr	898(ra) # 802016ce <panic>
    pte_t *pte = walk_create(pt, va);
    80202354:	fc043583          	ld	a1,-64(s0)
    80202358:	fc843503          	ld	a0,-56(s0)
    8020235c:	00000097          	auipc	ra,0x0
    80202360:	e84080e7          	jalr	-380(ra) # 802021e0 <walk_create>
    80202364:	fca43c23          	sd	a0,-40(s0)
    if (!pte)
    80202368:	fd843783          	ld	a5,-40(s0)
    8020236c:	e399                	bnez	a5,80202372 <map_page+0x9a>
        return -1;
    8020236e:	57fd                	li	a5,-1
    80202370:	a87d                	j	8020242e <map_page+0x156>
    if (va >= 0x80000000)
    80202372:	fc043703          	ld	a4,-64(s0)
    80202376:	800007b7          	lui	a5,0x80000
    8020237a:	fff7c793          	not	a5,a5
    8020237e:	00e7f763          	bgeu	a5,a4,8020238c <map_page+0xb4>
        perm &= ~PTE_U;
    80202382:	fb442783          	lw	a5,-76(s0)
    80202386:	9bbd                	andi	a5,a5,-17
    80202388:	faf42a23          	sw	a5,-76(s0)
    if (*pte & PTE_V) {
    8020238c:	fd843783          	ld	a5,-40(s0)
    80202390:	639c                	ld	a5,0(a5)
    80202392:	8b85                	andi	a5,a5,1
    80202394:	cfbd                	beqz	a5,80202412 <map_page+0x13a>
        if (PTE2PA(*pte) == pa) {
    80202396:	fd843783          	ld	a5,-40(s0)
    8020239a:	639c                	ld	a5,0(a5)
    8020239c:	83a9                	srli	a5,a5,0xa
    8020239e:	07b2                	slli	a5,a5,0xc
    802023a0:	fb843703          	ld	a4,-72(s0)
    802023a4:	04f71f63          	bne	a4,a5,80202402 <map_page+0x12a>
            int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
    802023a8:	fd843783          	ld	a5,-40(s0)
    802023ac:	639c                	ld	a5,0(a5)
    802023ae:	2781                	sext.w	a5,a5
    802023b0:	3ff7f793          	andi	a5,a5,1023
    802023b4:	0007871b          	sext.w	a4,a5
    802023b8:	fb442783          	lw	a5,-76(s0)
    802023bc:	8fd9                	or	a5,a5,a4
    802023be:	2781                	sext.w	a5,a5
    802023c0:	2781                	sext.w	a5,a5
    802023c2:	3ff7f793          	andi	a5,a5,1023
    802023c6:	fef42623          	sw	a5,-20(s0)
            if (va >= 0x80000000)
    802023ca:	fc043703          	ld	a4,-64(s0)
    802023ce:	800007b7          	lui	a5,0x80000
    802023d2:	fff7c793          	not	a5,a5
    802023d6:	00e7f763          	bgeu	a5,a4,802023e4 <map_page+0x10c>
                new_perm &= ~PTE_U;
    802023da:	fec42783          	lw	a5,-20(s0)
    802023de:	9bbd                	andi	a5,a5,-17
    802023e0:	fef42623          	sw	a5,-20(s0)
            *pte = PA2PTE(pa) | new_perm | PTE_V;
    802023e4:	fb843783          	ld	a5,-72(s0)
    802023e8:	83b1                	srli	a5,a5,0xc
    802023ea:	00a79713          	slli	a4,a5,0xa
    802023ee:	fec42783          	lw	a5,-20(s0)
    802023f2:	8fd9                	or	a5,a5,a4
    802023f4:	0017e713          	ori	a4,a5,1
    802023f8:	fd843783          	ld	a5,-40(s0)
    802023fc:	e398                	sd	a4,0(a5)
            return 0;
    802023fe:	4781                	li	a5,0
    80202400:	a03d                	j	8020242e <map_page+0x156>
            panic("map_page: remap to different physical address");
    80202402:	00006517          	auipc	a0,0x6
    80202406:	93650513          	addi	a0,a0,-1738 # 80207d38 <etext+0xd38>
    8020240a:	fffff097          	auipc	ra,0xfffff
    8020240e:	2c4080e7          	jalr	708(ra) # 802016ce <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80202412:	fb843783          	ld	a5,-72(s0)
    80202416:	83b1                	srli	a5,a5,0xc
    80202418:	00a79713          	slli	a4,a5,0xa
    8020241c:	fb442783          	lw	a5,-76(s0)
    80202420:	8fd9                	or	a5,a5,a4
    80202422:	0017e713          	ori	a4,a5,1
    80202426:	fd843783          	ld	a5,-40(s0)
    8020242a:	e398                	sd	a4,0(a5)
    return 0;
    8020242c:	4781                	li	a5,0
}
    8020242e:	853e                	mv	a0,a5
    80202430:	60a6                	ld	ra,72(sp)
    80202432:	6406                	ld	s0,64(sp)
    80202434:	6161                	addi	sp,sp,80
    80202436:	8082                	ret

0000000080202438 <free_pagetable>:
void free_pagetable(pagetable_t pt) {
    80202438:	7139                	addi	sp,sp,-64
    8020243a:	fc06                	sd	ra,56(sp)
    8020243c:	f822                	sd	s0,48(sp)
    8020243e:	0080                	addi	s0,sp,64
    80202440:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    80202444:	fe042623          	sw	zero,-20(s0)
    80202448:	a8a5                	j	802024c0 <free_pagetable+0x88>
        pte_t pte = pt[i];
    8020244a:	fec42783          	lw	a5,-20(s0)
    8020244e:	078e                	slli	a5,a5,0x3
    80202450:	fc843703          	ld	a4,-56(s0)
    80202454:	97ba                	add	a5,a5,a4
    80202456:	639c                	ld	a5,0(a5)
    80202458:	fef43023          	sd	a5,-32(s0)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    8020245c:	fe043783          	ld	a5,-32(s0)
    80202460:	8b85                	andi	a5,a5,1
    80202462:	cb95                	beqz	a5,80202496 <free_pagetable+0x5e>
    80202464:	fe043783          	ld	a5,-32(s0)
    80202468:	8bb9                	andi	a5,a5,14
    8020246a:	e795                	bnez	a5,80202496 <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    8020246c:	fe043783          	ld	a5,-32(s0)
    80202470:	83a9                	srli	a5,a5,0xa
    80202472:	07b2                	slli	a5,a5,0xc
    80202474:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    80202478:	fd843503          	ld	a0,-40(s0)
    8020247c:	00000097          	auipc	ra,0x0
    80202480:	fbc080e7          	jalr	-68(ra) # 80202438 <free_pagetable>
            pt[i] = 0;
    80202484:	fec42783          	lw	a5,-20(s0)
    80202488:	078e                	slli	a5,a5,0x3
    8020248a:	fc843703          	ld	a4,-56(s0)
    8020248e:	97ba                	add	a5,a5,a4
    80202490:	0007b023          	sd	zero,0(a5) # ffffffff80000000 <_bss_end+0xfffffffeffdf36f0>
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80202494:	a00d                	j	802024b6 <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    80202496:	fe043783          	ld	a5,-32(s0)
    8020249a:	8b85                	andi	a5,a5,1
    8020249c:	cf89                	beqz	a5,802024b6 <free_pagetable+0x7e>
    8020249e:	fe043783          	ld	a5,-32(s0)
    802024a2:	8bb9                	andi	a5,a5,14
    802024a4:	cb89                	beqz	a5,802024b6 <free_pagetable+0x7e>
            pt[i] = 0;
    802024a6:	fec42783          	lw	a5,-20(s0)
    802024aa:	078e                	slli	a5,a5,0x3
    802024ac:	fc843703          	ld	a4,-56(s0)
    802024b0:	97ba                	add	a5,a5,a4
    802024b2:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    802024b6:	fec42783          	lw	a5,-20(s0)
    802024ba:	2785                	addiw	a5,a5,1
    802024bc:	fef42623          	sw	a5,-20(s0)
    802024c0:	fec42783          	lw	a5,-20(s0)
    802024c4:	0007871b          	sext.w	a4,a5
    802024c8:	1ff00793          	li	a5,511
    802024cc:	f6e7dfe3          	bge	a5,a4,8020244a <free_pagetable+0x12>
    free_page(pt);
    802024d0:	fc843503          	ld	a0,-56(s0)
    802024d4:	00001097          	auipc	ra,0x1
    802024d8:	d98080e7          	jalr	-616(ra) # 8020326c <free_page>
}
    802024dc:	0001                	nop
    802024de:	70e2                	ld	ra,56(sp)
    802024e0:	7442                	ld	s0,48(sp)
    802024e2:	6121                	addi	sp,sp,64
    802024e4:	8082                	ret

00000000802024e6 <kvmmake>:
static pagetable_t kvmmake(void) {
    802024e6:	715d                	addi	sp,sp,-80
    802024e8:	e486                	sd	ra,72(sp)
    802024ea:	e0a2                	sd	s0,64(sp)
    802024ec:	0880                	addi	s0,sp,80
    pagetable_t kpgtbl = create_pagetable();
    802024ee:	00000097          	auipc	ra,0x0
    802024f2:	b7a080e7          	jalr	-1158(ra) # 80202068 <create_pagetable>
    802024f6:	fca43423          	sd	a0,-56(s0)
    if (!kpgtbl){
    802024fa:	fc843783          	ld	a5,-56(s0)
    802024fe:	eb89                	bnez	a5,80202510 <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    80202500:	00006517          	auipc	a0,0x6
    80202504:	86850513          	addi	a0,a0,-1944 # 80207d68 <etext+0xd68>
    80202508:	fffff097          	auipc	ra,0xfffff
    8020250c:	1c6080e7          	jalr	454(ra) # 802016ce <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    80202510:	4785                	li	a5,1
    80202512:	07fe                	slli	a5,a5,0x1f
    80202514:	fef43423          	sd	a5,-24(s0)
    80202518:	a8a1                	j	80202570 <kvmmake+0x8a>
        int perm = PTE_R | PTE_W;
    8020251a:	4799                	li	a5,6
    8020251c:	fef42223          	sw	a5,-28(s0)
        if (pa < (uint64)etext)
    80202520:	00005797          	auipc	a5,0x5
    80202524:	ae078793          	addi	a5,a5,-1312 # 80207000 <etext>
    80202528:	fe843703          	ld	a4,-24(s0)
    8020252c:	00f77563          	bgeu	a4,a5,80202536 <kvmmake+0x50>
            perm = PTE_R | PTE_X;
    80202530:	47a9                	li	a5,10
    80202532:	fef42223          	sw	a5,-28(s0)
        if (map_page(kpgtbl, pa, pa, perm) != 0)
    80202536:	fe442783          	lw	a5,-28(s0)
    8020253a:	86be                	mv	a3,a5
    8020253c:	fe843603          	ld	a2,-24(s0)
    80202540:	fe843583          	ld	a1,-24(s0)
    80202544:	fc843503          	ld	a0,-56(s0)
    80202548:	00000097          	auipc	ra,0x0
    8020254c:	d90080e7          	jalr	-624(ra) # 802022d8 <map_page>
    80202550:	87aa                	mv	a5,a0
    80202552:	cb89                	beqz	a5,80202564 <kvmmake+0x7e>
            panic("kvmmake: heap map failed");
    80202554:	00006517          	auipc	a0,0x6
    80202558:	82c50513          	addi	a0,a0,-2004 # 80207d80 <etext+0xd80>
    8020255c:	fffff097          	auipc	ra,0xfffff
    80202560:	172080e7          	jalr	370(ra) # 802016ce <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    80202564:	fe843703          	ld	a4,-24(s0)
    80202568:	6785                	lui	a5,0x1
    8020256a:	97ba                	add	a5,a5,a4
    8020256c:	fef43423          	sd	a5,-24(s0)
    80202570:	fe843703          	ld	a4,-24(s0)
    80202574:	47c5                	li	a5,17
    80202576:	07ee                	slli	a5,a5,0x1b
    80202578:	faf761e3          	bltu	a4,a5,8020251a <kvmmake+0x34>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    8020257c:	4699                	li	a3,6
    8020257e:	10000637          	lui	a2,0x10000
    80202582:	100005b7          	lui	a1,0x10000
    80202586:	fc843503          	ld	a0,-56(s0)
    8020258a:	00000097          	auipc	ra,0x0
    8020258e:	d4e080e7          	jalr	-690(ra) # 802022d8 <map_page>
    80202592:	87aa                	mv	a5,a0
    80202594:	cb89                	beqz	a5,802025a6 <kvmmake+0xc0>
        panic("kvmmake: uart map failed");
    80202596:	00006517          	auipc	a0,0x6
    8020259a:	80a50513          	addi	a0,a0,-2038 # 80207da0 <etext+0xda0>
    8020259e:	fffff097          	auipc	ra,0xfffff
    802025a2:	130080e7          	jalr	304(ra) # 802016ce <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    802025a6:	0c0007b7          	lui	a5,0xc000
    802025aa:	fcf43c23          	sd	a5,-40(s0)
    802025ae:	a825                	j	802025e6 <kvmmake+0x100>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802025b0:	4699                	li	a3,6
    802025b2:	fd843603          	ld	a2,-40(s0)
    802025b6:	fd843583          	ld	a1,-40(s0)
    802025ba:	fc843503          	ld	a0,-56(s0)
    802025be:	00000097          	auipc	ra,0x0
    802025c2:	d1a080e7          	jalr	-742(ra) # 802022d8 <map_page>
    802025c6:	87aa                	mv	a5,a0
    802025c8:	cb89                	beqz	a5,802025da <kvmmake+0xf4>
            panic("kvmmake: plic map failed");
    802025ca:	00005517          	auipc	a0,0x5
    802025ce:	7f650513          	addi	a0,a0,2038 # 80207dc0 <etext+0xdc0>
    802025d2:	fffff097          	auipc	ra,0xfffff
    802025d6:	0fc080e7          	jalr	252(ra) # 802016ce <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    802025da:	fd843703          	ld	a4,-40(s0)
    802025de:	6785                	lui	a5,0x1
    802025e0:	97ba                	add	a5,a5,a4
    802025e2:	fcf43c23          	sd	a5,-40(s0)
    802025e6:	fd843703          	ld	a4,-40(s0)
    802025ea:	0c4007b7          	lui	a5,0xc400
    802025ee:	fcf761e3          	bltu	a4,a5,802025b0 <kvmmake+0xca>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    802025f2:	020007b7          	lui	a5,0x2000
    802025f6:	fcf43823          	sd	a5,-48(s0)
    802025fa:	a825                	j	80202632 <kvmmake+0x14c>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802025fc:	4699                	li	a3,6
    802025fe:	fd043603          	ld	a2,-48(s0)
    80202602:	fd043583          	ld	a1,-48(s0)
    80202606:	fc843503          	ld	a0,-56(s0)
    8020260a:	00000097          	auipc	ra,0x0
    8020260e:	cce080e7          	jalr	-818(ra) # 802022d8 <map_page>
    80202612:	87aa                	mv	a5,a0
    80202614:	cb89                	beqz	a5,80202626 <kvmmake+0x140>
            panic("kvmmake: clint map failed");
    80202616:	00005517          	auipc	a0,0x5
    8020261a:	7ca50513          	addi	a0,a0,1994 # 80207de0 <etext+0xde0>
    8020261e:	fffff097          	auipc	ra,0xfffff
    80202622:	0b0080e7          	jalr	176(ra) # 802016ce <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80202626:	fd043703          	ld	a4,-48(s0)
    8020262a:	6785                	lui	a5,0x1
    8020262c:	97ba                	add	a5,a5,a4
    8020262e:	fcf43823          	sd	a5,-48(s0)
    80202632:	fd043703          	ld	a4,-48(s0)
    80202636:	020107b7          	lui	a5,0x2010
    8020263a:	fcf761e3          	bltu	a4,a5,802025fc <kvmmake+0x116>
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    8020263e:	4699                	li	a3,6
    80202640:	10001637          	lui	a2,0x10001
    80202644:	100015b7          	lui	a1,0x10001
    80202648:	fc843503          	ld	a0,-56(s0)
    8020264c:	00000097          	auipc	ra,0x0
    80202650:	c8c080e7          	jalr	-884(ra) # 802022d8 <map_page>
    80202654:	87aa                	mv	a5,a0
    80202656:	cb89                	beqz	a5,80202668 <kvmmake+0x182>
        panic("kvmmake: virtio map failed");
    80202658:	00005517          	auipc	a0,0x5
    8020265c:	7a850513          	addi	a0,a0,1960 # 80207e00 <etext+0xe00>
    80202660:	fffff097          	auipc	ra,0xfffff
    80202664:	06e080e7          	jalr	110(ra) # 802016ce <panic>
	void *tramp_phys = alloc_page();
    80202668:	00001097          	auipc	ra,0x1
    8020266c:	b98080e7          	jalr	-1128(ra) # 80203200 <alloc_page>
    80202670:	fca43023          	sd	a0,-64(s0)
	if (!tramp_phys)
    80202674:	fc043783          	ld	a5,-64(s0)
    80202678:	eb89                	bnez	a5,8020268a <kvmmake+0x1a4>
		panic("kvmmake: alloc trampoline page failed");
    8020267a:	00005517          	auipc	a0,0x5
    8020267e:	7a650513          	addi	a0,a0,1958 # 80207e20 <etext+0xe20>
    80202682:	fffff097          	auipc	ra,0xfffff
    80202686:	04c080e7          	jalr	76(ra) # 802016ce <panic>
	memcpy(tramp_phys, trampoline, PGSIZE);
    8020268a:	6605                	lui	a2,0x1
    8020268c:	00002597          	auipc	a1,0x2
    80202690:	22458593          	addi	a1,a1,548 # 802048b0 <trampoline>
    80202694:	fc043503          	ld	a0,-64(s0)
    80202698:	00000097          	auipc	ra,0x0
    8020269c:	880080e7          	jalr	-1920(ra) # 80201f18 <memcpy>
	void *trapframe_phys = alloc_page();
    802026a0:	00001097          	auipc	ra,0x1
    802026a4:	b60080e7          	jalr	-1184(ra) # 80203200 <alloc_page>
    802026a8:	faa43c23          	sd	a0,-72(s0)
	if (!trapframe_phys)
    802026ac:	fb843783          	ld	a5,-72(s0)
    802026b0:	eb89                	bnez	a5,802026c2 <kvmmake+0x1dc>
		panic("kvmmake: alloc trapframe page failed");
    802026b2:	00005517          	auipc	a0,0x5
    802026b6:	79650513          	addi	a0,a0,1942 # 80207e48 <etext+0xe48>
    802026ba:	fffff097          	auipc	ra,0xfffff
    802026be:	014080e7          	jalr	20(ra) # 802016ce <panic>
	memset(trapframe_phys, 0, PGSIZE);
    802026c2:	6605                	lui	a2,0x1
    802026c4:	4581                	li	a1,0
    802026c6:	fb843503          	ld	a0,-72(s0)
    802026ca:	fffff097          	auipc	ra,0xfffff
    802026ce:	742080e7          	jalr	1858(ra) # 80201e0c <memset>
	if (map_page(kpgtbl, TRAMPOLINE, (uint64)tramp_phys, PTE_R | PTE_X) != 0){
    802026d2:	fc043783          	ld	a5,-64(s0)
    802026d6:	46a9                	li	a3,10
    802026d8:	863e                	mv	a2,a5
    802026da:	75fd                	lui	a1,0xfffff
    802026dc:	fc843503          	ld	a0,-56(s0)
    802026e0:	00000097          	auipc	ra,0x0
    802026e4:	bf8080e7          	jalr	-1032(ra) # 802022d8 <map_page>
    802026e8:	87aa                	mv	a5,a0
    802026ea:	cb89                	beqz	a5,802026fc <kvmmake+0x216>
		panic("kvmmake: trampoline map failed");
    802026ec:	00005517          	auipc	a0,0x5
    802026f0:	78450513          	addi	a0,a0,1924 # 80207e70 <etext+0xe70>
    802026f4:	fffff097          	auipc	ra,0xfffff
    802026f8:	fda080e7          	jalr	-38(ra) # 802016ce <panic>
	if (map_page(kpgtbl, TRAPFRAME, (uint64)trapframe_phys, PTE_R | PTE_W) != 0){
    802026fc:	fb843783          	ld	a5,-72(s0)
    80202700:	4699                	li	a3,6
    80202702:	863e                	mv	a2,a5
    80202704:	75f9                	lui	a1,0xffffe
    80202706:	fc843503          	ld	a0,-56(s0)
    8020270a:	00000097          	auipc	ra,0x0
    8020270e:	bce080e7          	jalr	-1074(ra) # 802022d8 <map_page>
    80202712:	87aa                	mv	a5,a0
    80202714:	cb89                	beqz	a5,80202726 <kvmmake+0x240>
		panic("kvmmake: trapframe map failed");
    80202716:	00005517          	auipc	a0,0x5
    8020271a:	77a50513          	addi	a0,a0,1914 # 80207e90 <etext+0xe90>
    8020271e:	fffff097          	auipc	ra,0xfffff
    80202722:	fb0080e7          	jalr	-80(ra) # 802016ce <panic>
	trampoline_phys_addr = (uint64)tramp_phys;
    80202726:	fc043703          	ld	a4,-64(s0)
    8020272a:	0000a797          	auipc	a5,0xa
    8020272e:	97e78793          	addi	a5,a5,-1666 # 8020c0a8 <trampoline_phys_addr>
    80202732:	e398                	sd	a4,0(a5)
	trapframe_phys_addr = (uint64)trapframe_phys;
    80202734:	fb843703          	ld	a4,-72(s0)
    80202738:	0000a797          	auipc	a5,0xa
    8020273c:	97878793          	addi	a5,a5,-1672 # 8020c0b0 <trapframe_phys_addr>
    80202740:	e398                	sd	a4,0(a5)
	printf("trampoline_phy_addr = %lx\n",trampoline_phys_addr);
    80202742:	0000a797          	auipc	a5,0xa
    80202746:	96678793          	addi	a5,a5,-1690 # 8020c0a8 <trampoline_phys_addr>
    8020274a:	639c                	ld	a5,0(a5)
    8020274c:	85be                	mv	a1,a5
    8020274e:	00005517          	auipc	a0,0x5
    80202752:	76250513          	addi	a0,a0,1890 # 80207eb0 <etext+0xeb0>
    80202756:	ffffe097          	auipc	ra,0xffffe
    8020275a:	52c080e7          	jalr	1324(ra) # 80200c82 <printf>
	printf("trapframe_phys_addr = %lx\n",trapframe_phys_addr);
    8020275e:	0000a797          	auipc	a5,0xa
    80202762:	95278793          	addi	a5,a5,-1710 # 8020c0b0 <trapframe_phys_addr>
    80202766:	639c                	ld	a5,0(a5)
    80202768:	85be                	mv	a1,a5
    8020276a:	00005517          	auipc	a0,0x5
    8020276e:	76650513          	addi	a0,a0,1894 # 80207ed0 <etext+0xed0>
    80202772:	ffffe097          	auipc	ra,0xffffe
    80202776:	510080e7          	jalr	1296(ra) # 80200c82 <printf>
    return kpgtbl;
    8020277a:	fc843783          	ld	a5,-56(s0)
}
    8020277e:	853e                	mv	a0,a5
    80202780:	60a6                	ld	ra,72(sp)
    80202782:	6406                	ld	s0,64(sp)
    80202784:	6161                	addi	sp,sp,80
    80202786:	8082                	ret

0000000080202788 <w_satp>:
static inline void w_satp(uint64 x) {
    80202788:	1101                	addi	sp,sp,-32
    8020278a:	ec22                	sd	s0,24(sp)
    8020278c:	1000                	addi	s0,sp,32
    8020278e:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    80202792:	fe843783          	ld	a5,-24(s0)
    80202796:	18079073          	csrw	satp,a5
}
    8020279a:	0001                	nop
    8020279c:	6462                	ld	s0,24(sp)
    8020279e:	6105                	addi	sp,sp,32
    802027a0:	8082                	ret

00000000802027a2 <sfence_vma>:
inline void sfence_vma(void) {
    802027a2:	1141                	addi	sp,sp,-16
    802027a4:	e422                	sd	s0,8(sp)
    802027a6:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    802027a8:	12000073          	sfence.vma
}
    802027ac:	0001                	nop
    802027ae:	6422                	ld	s0,8(sp)
    802027b0:	0141                	addi	sp,sp,16
    802027b2:	8082                	ret

00000000802027b4 <kvminit>:
void kvminit(void) {
    802027b4:	1141                	addi	sp,sp,-16
    802027b6:	e406                	sd	ra,8(sp)
    802027b8:	e022                	sd	s0,0(sp)
    802027ba:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    802027bc:	00000097          	auipc	ra,0x0
    802027c0:	d2a080e7          	jalr	-726(ra) # 802024e6 <kvmmake>
    802027c4:	872a                	mv	a4,a0
    802027c6:	0000a797          	auipc	a5,0xa
    802027ca:	8da78793          	addi	a5,a5,-1830 # 8020c0a0 <kernel_pagetable>
    802027ce:	e398                	sd	a4,0(a5)
    sfence_vma();
    802027d0:	00000097          	auipc	ra,0x0
    802027d4:	fd2080e7          	jalr	-46(ra) # 802027a2 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    802027d8:	0000a797          	auipc	a5,0xa
    802027dc:	8c878793          	addi	a5,a5,-1848 # 8020c0a0 <kernel_pagetable>
    802027e0:	639c                	ld	a5,0(a5)
    802027e2:	00c7d713          	srli	a4,a5,0xc
    802027e6:	57fd                	li	a5,-1
    802027e8:	17fe                	slli	a5,a5,0x3f
    802027ea:	8fd9                	or	a5,a5,a4
    802027ec:	853e                	mv	a0,a5
    802027ee:	00000097          	auipc	ra,0x0
    802027f2:	f9a080e7          	jalr	-102(ra) # 80202788 <w_satp>
    sfence_vma();
    802027f6:	00000097          	auipc	ra,0x0
    802027fa:	fac080e7          	jalr	-84(ra) # 802027a2 <sfence_vma>
    printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
    802027fe:	0000a797          	auipc	a5,0xa
    80202802:	8a278793          	addi	a5,a5,-1886 # 8020c0a0 <kernel_pagetable>
    80202806:	639c                	ld	a5,0(a5)
    80202808:	00c7d713          	srli	a4,a5,0xc
    8020280c:	57fd                	li	a5,-1
    8020280e:	17fe                	slli	a5,a5,0x3f
    80202810:	8fd9                	or	a5,a5,a4
    80202812:	85be                	mv	a1,a5
    80202814:	00005517          	auipc	a0,0x5
    80202818:	6dc50513          	addi	a0,a0,1756 # 80207ef0 <etext+0xef0>
    8020281c:	ffffe097          	auipc	ra,0xffffe
    80202820:	466080e7          	jalr	1126(ra) # 80200c82 <printf>
}
    80202824:	0001                	nop
    80202826:	60a2                	ld	ra,8(sp)
    80202828:	6402                	ld	s0,0(sp)
    8020282a:	0141                	addi	sp,sp,16
    8020282c:	8082                	ret

000000008020282e <get_current_pagetable>:
pagetable_t get_current_pagetable(void) {
    8020282e:	1141                	addi	sp,sp,-16
    80202830:	e422                	sd	s0,8(sp)
    80202832:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    80202834:	0000a797          	auipc	a5,0xa
    80202838:	86c78793          	addi	a5,a5,-1940 # 8020c0a0 <kernel_pagetable>
    8020283c:	639c                	ld	a5,0(a5)
}
    8020283e:	853e                	mv	a0,a5
    80202840:	6422                	ld	s0,8(sp)
    80202842:	0141                	addi	sp,sp,16
    80202844:	8082                	ret

0000000080202846 <print_pagetable>:
void print_pagetable(pagetable_t pagetable, int level, uint64 va_base) {
    80202846:	715d                	addi	sp,sp,-80
    80202848:	e486                	sd	ra,72(sp)
    8020284a:	e0a2                	sd	s0,64(sp)
    8020284c:	0880                	addi	s0,sp,80
    8020284e:	fca43423          	sd	a0,-56(s0)
    80202852:	87ae                	mv	a5,a1
    80202854:	fac43c23          	sd	a2,-72(s0)
    80202858:	fcf42223          	sw	a5,-60(s0)
    for (int i = 0; i < 512; i++) {
    8020285c:	fe042623          	sw	zero,-20(s0)
    80202860:	a0c5                	j	80202940 <print_pagetable+0xfa>
        pte_t pte = pagetable[i];
    80202862:	fec42783          	lw	a5,-20(s0)
    80202866:	078e                	slli	a5,a5,0x3
    80202868:	fc843703          	ld	a4,-56(s0)
    8020286c:	97ba                	add	a5,a5,a4
    8020286e:	639c                	ld	a5,0(a5)
    80202870:	fef43023          	sd	a5,-32(s0)
        if (pte & PTE_V) {
    80202874:	fe043783          	ld	a5,-32(s0)
    80202878:	8b85                	andi	a5,a5,1
    8020287a:	cfd5                	beqz	a5,80202936 <print_pagetable+0xf0>
            uint64 pa = PTE2PA(pte);
    8020287c:	fe043783          	ld	a5,-32(s0)
    80202880:	83a9                	srli	a5,a5,0xa
    80202882:	07b2                	slli	a5,a5,0xc
    80202884:	fcf43c23          	sd	a5,-40(s0)
            uint64 va = va_base + (i << (12 + 9 * (2 - level)));
    80202888:	4789                	li	a5,2
    8020288a:	fc442703          	lw	a4,-60(s0)
    8020288e:	9f99                	subw	a5,a5,a4
    80202890:	2781                	sext.w	a5,a5
    80202892:	873e                	mv	a4,a5
    80202894:	87ba                	mv	a5,a4
    80202896:	0037979b          	slliw	a5,a5,0x3
    8020289a:	9fb9                	addw	a5,a5,a4
    8020289c:	2781                	sext.w	a5,a5
    8020289e:	27b1                	addiw	a5,a5,12
    802028a0:	2781                	sext.w	a5,a5
    802028a2:	fec42703          	lw	a4,-20(s0)
    802028a6:	00f717bb          	sllw	a5,a4,a5
    802028aa:	2781                	sext.w	a5,a5
    802028ac:	873e                	mv	a4,a5
    802028ae:	fb843783          	ld	a5,-72(s0)
    802028b2:	97ba                	add	a5,a5,a4
    802028b4:	fcf43823          	sd	a5,-48(s0)
            for (int l = 0; l < level; l++) printf("  "); // 缩进
    802028b8:	fe042423          	sw	zero,-24(s0)
    802028bc:	a831                	j	802028d8 <print_pagetable+0x92>
    802028be:	00005517          	auipc	a0,0x5
    802028c2:	66250513          	addi	a0,a0,1634 # 80207f20 <etext+0xf20>
    802028c6:	ffffe097          	auipc	ra,0xffffe
    802028ca:	3bc080e7          	jalr	956(ra) # 80200c82 <printf>
    802028ce:	fe842783          	lw	a5,-24(s0)
    802028d2:	2785                	addiw	a5,a5,1
    802028d4:	fef42423          	sw	a5,-24(s0)
    802028d8:	fe842783          	lw	a5,-24(s0)
    802028dc:	873e                	mv	a4,a5
    802028de:	fc442783          	lw	a5,-60(s0)
    802028e2:	2701                	sext.w	a4,a4
    802028e4:	2781                	sext.w	a5,a5
    802028e6:	fcf74ce3          	blt	a4,a5,802028be <print_pagetable+0x78>
            printf("L%d[%3d] VA:0x%lx -> PA:0x%lx flags:0x%lx\n", level, i, va, pa, pte & 0x3FF);
    802028ea:	fe043783          	ld	a5,-32(s0)
    802028ee:	3ff7f793          	andi	a5,a5,1023
    802028f2:	fec42603          	lw	a2,-20(s0)
    802028f6:	fc442583          	lw	a1,-60(s0)
    802028fa:	fd843703          	ld	a4,-40(s0)
    802028fe:	fd043683          	ld	a3,-48(s0)
    80202902:	00005517          	auipc	a0,0x5
    80202906:	62650513          	addi	a0,a0,1574 # 80207f28 <etext+0xf28>
    8020290a:	ffffe097          	auipc	ra,0xffffe
    8020290e:	378080e7          	jalr	888(ra) # 80200c82 <printf>
            if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // 不是叶子
    80202912:	fe043783          	ld	a5,-32(s0)
    80202916:	8bb9                	andi	a5,a5,14
    80202918:	ef99                	bnez	a5,80202936 <print_pagetable+0xf0>
                print_pagetable((pagetable_t)pa, level + 1, va);
    8020291a:	fd843783          	ld	a5,-40(s0)
    8020291e:	fc442703          	lw	a4,-60(s0)
    80202922:	2705                	addiw	a4,a4,1
    80202924:	2701                	sext.w	a4,a4
    80202926:	fd043603          	ld	a2,-48(s0)
    8020292a:	85ba                	mv	a1,a4
    8020292c:	853e                	mv	a0,a5
    8020292e:	00000097          	auipc	ra,0x0
    80202932:	f18080e7          	jalr	-232(ra) # 80202846 <print_pagetable>
    for (int i = 0; i < 512; i++) {
    80202936:	fec42783          	lw	a5,-20(s0)
    8020293a:	2785                	addiw	a5,a5,1
    8020293c:	fef42623          	sw	a5,-20(s0)
    80202940:	fec42783          	lw	a5,-20(s0)
    80202944:	0007871b          	sext.w	a4,a5
    80202948:	1ff00793          	li	a5,511
    8020294c:	f0e7dbe3          	bge	a5,a4,80202862 <print_pagetable+0x1c>
}
    80202950:	0001                	nop
    80202952:	0001                	nop
    80202954:	60a6                	ld	ra,72(sp)
    80202956:	6406                	ld	s0,64(sp)
    80202958:	6161                	addi	sp,sp,80
    8020295a:	8082                	ret

000000008020295c <handle_page_fault>:
int handle_page_fault(uint64 va, int type) {
    8020295c:	715d                	addi	sp,sp,-80
    8020295e:	e486                	sd	ra,72(sp)
    80202960:	e0a2                	sd	s0,64(sp)
    80202962:	0880                	addi	s0,sp,80
    80202964:	faa43c23          	sd	a0,-72(s0)
    80202968:	87ae                	mv	a5,a1
    8020296a:	faf42a23          	sw	a5,-76(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    8020296e:	fb442783          	lw	a5,-76(s0)
    80202972:	863e                	mv	a2,a5
    80202974:	fb843583          	ld	a1,-72(s0)
    80202978:	00005517          	auipc	a0,0x5
    8020297c:	5e050513          	addi	a0,a0,1504 # 80207f58 <etext+0xf58>
    80202980:	ffffe097          	auipc	ra,0xffffe
    80202984:	302080e7          	jalr	770(ra) # 80200c82 <printf>
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    80202988:	fb843703          	ld	a4,-72(s0)
    8020298c:	77fd                	lui	a5,0xfffff
    8020298e:	8ff9                	and	a5,a5,a4
    80202990:	fcf43c23          	sd	a5,-40(s0)
    if (page_va >= MAXVA) {
    80202994:	fd843703          	ld	a4,-40(s0)
    80202998:	57fd                	li	a5,-1
    8020299a:	83e5                	srli	a5,a5,0x19
    8020299c:	00e7fc63          	bgeu	a5,a4,802029b4 <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    802029a0:	00005517          	auipc	a0,0x5
    802029a4:	5e850513          	addi	a0,a0,1512 # 80207f88 <etext+0xf88>
    802029a8:	ffffe097          	auipc	ra,0xffffe
    802029ac:	2da080e7          	jalr	730(ra) # 80200c82 <printf>
        return 0;
    802029b0:	4781                	li	a5,0
    802029b2:	aae9                	j	80202b8c <handle_page_fault+0x230>
    struct proc *p = myproc();
    802029b4:	00002097          	auipc	ra,0x2
    802029b8:	19c080e7          	jalr	412(ra) # 80204b50 <myproc>
    802029bc:	fca43823          	sd	a0,-48(s0)
    pagetable_t pt = kernel_pagetable;
    802029c0:	00009797          	auipc	a5,0x9
    802029c4:	6e078793          	addi	a5,a5,1760 # 8020c0a0 <kernel_pagetable>
    802029c8:	639c                	ld	a5,0(a5)
    802029ca:	fef43423          	sd	a5,-24(s0)
    if (p && p->pagetable && p->is_user) {
    802029ce:	fd043783          	ld	a5,-48(s0)
    802029d2:	cf99                	beqz	a5,802029f0 <handle_page_fault+0x94>
    802029d4:	fd043783          	ld	a5,-48(s0)
    802029d8:	7fdc                	ld	a5,184(a5)
    802029da:	cb99                	beqz	a5,802029f0 <handle_page_fault+0x94>
    802029dc:	fd043783          	ld	a5,-48(s0)
    802029e0:	0a87a783          	lw	a5,168(a5)
    802029e4:	c791                	beqz	a5,802029f0 <handle_page_fault+0x94>
        pt = p->pagetable;
    802029e6:	fd043783          	ld	a5,-48(s0)
    802029ea:	7fdc                	ld	a5,184(a5)
    802029ec:	fef43423          	sd	a5,-24(s0)
    pte_t *pte = walk_lookup(pt, page_va);
    802029f0:	fd843583          	ld	a1,-40(s0)
    802029f4:	fe843503          	ld	a0,-24(s0)
    802029f8:	fffff097          	auipc	ra,0xfffff
    802029fc:	6ac080e7          	jalr	1708(ra) # 802020a4 <walk_lookup>
    80202a00:	fca43423          	sd	a0,-56(s0)
    if (pte && (*pte & PTE_V)) {
    80202a04:	fc843783          	ld	a5,-56(s0)
    80202a08:	c3dd                	beqz	a5,80202aae <handle_page_fault+0x152>
    80202a0a:	fc843783          	ld	a5,-56(s0)
    80202a0e:	639c                	ld	a5,0(a5)
    80202a10:	8b85                	andi	a5,a5,1
    80202a12:	cfd1                	beqz	a5,80202aae <handle_page_fault+0x152>
        int need_perm = 0;
    80202a14:	fe042223          	sw	zero,-28(s0)
        if (type == 1) need_perm = PTE_X;
    80202a18:	fb442783          	lw	a5,-76(s0)
    80202a1c:	0007871b          	sext.w	a4,a5
    80202a20:	4785                	li	a5,1
    80202a22:	00f71663          	bne	a4,a5,80202a2e <handle_page_fault+0xd2>
    80202a26:	47a1                	li	a5,8
    80202a28:	fef42223          	sw	a5,-28(s0)
    80202a2c:	a035                	j	80202a58 <handle_page_fault+0xfc>
        else if (type == 2) need_perm = PTE_R;
    80202a2e:	fb442783          	lw	a5,-76(s0)
    80202a32:	0007871b          	sext.w	a4,a5
    80202a36:	4789                	li	a5,2
    80202a38:	00f71663          	bne	a4,a5,80202a44 <handle_page_fault+0xe8>
    80202a3c:	4789                	li	a5,2
    80202a3e:	fef42223          	sw	a5,-28(s0)
    80202a42:	a819                	j	80202a58 <handle_page_fault+0xfc>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    80202a44:	fb442783          	lw	a5,-76(s0)
    80202a48:	0007871b          	sext.w	a4,a5
    80202a4c:	478d                	li	a5,3
    80202a4e:	00f71563          	bne	a4,a5,80202a58 <handle_page_fault+0xfc>
    80202a52:	4799                	li	a5,6
    80202a54:	fef42223          	sw	a5,-28(s0)
        if ((*pte & need_perm) != need_perm) {
    80202a58:	fc843783          	ld	a5,-56(s0)
    80202a5c:	6398                	ld	a4,0(a5)
    80202a5e:	fe442783          	lw	a5,-28(s0)
    80202a62:	8f7d                	and	a4,a4,a5
    80202a64:	fe442783          	lw	a5,-28(s0)
    80202a68:	02f70963          	beq	a4,a5,80202a9a <handle_page_fault+0x13e>
            *pte |= need_perm;
    80202a6c:	fc843783          	ld	a5,-56(s0)
    80202a70:	6398                	ld	a4,0(a5)
    80202a72:	fe442783          	lw	a5,-28(s0)
    80202a76:	8f5d                	or	a4,a4,a5
    80202a78:	fc843783          	ld	a5,-56(s0)
    80202a7c:	e398                	sd	a4,0(a5)
            sfence_vma();
    80202a7e:	00000097          	auipc	ra,0x0
    80202a82:	d24080e7          	jalr	-732(ra) # 802027a2 <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    80202a86:	00005517          	auipc	a0,0x5
    80202a8a:	52a50513          	addi	a0,a0,1322 # 80207fb0 <etext+0xfb0>
    80202a8e:	ffffe097          	auipc	ra,0xffffe
    80202a92:	1f4080e7          	jalr	500(ra) # 80200c82 <printf>
            return 1;
    80202a96:	4785                	li	a5,1
    80202a98:	a8d5                	j	80202b8c <handle_page_fault+0x230>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80202a9a:	00005517          	auipc	a0,0x5
    80202a9e:	53e50513          	addi	a0,a0,1342 # 80207fd8 <etext+0xfd8>
    80202aa2:	ffffe097          	auipc	ra,0xffffe
    80202aa6:	1e0080e7          	jalr	480(ra) # 80200c82 <printf>
        return 1;
    80202aaa:	4785                	li	a5,1
    80202aac:	a0c5                	j	80202b8c <handle_page_fault+0x230>
    void* page = alloc_page();
    80202aae:	00000097          	auipc	ra,0x0
    80202ab2:	752080e7          	jalr	1874(ra) # 80203200 <alloc_page>
    80202ab6:	fca43023          	sd	a0,-64(s0)
    if (page == 0) {
    80202aba:	fc043783          	ld	a5,-64(s0)
    80202abe:	eb99                	bnez	a5,80202ad4 <handle_page_fault+0x178>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    80202ac0:	00005517          	auipc	a0,0x5
    80202ac4:	54850513          	addi	a0,a0,1352 # 80208008 <etext+0x1008>
    80202ac8:	ffffe097          	auipc	ra,0xffffe
    80202acc:	1ba080e7          	jalr	442(ra) # 80200c82 <printf>
        return 0;
    80202ad0:	4781                	li	a5,0
    80202ad2:	a86d                	j	80202b8c <handle_page_fault+0x230>
    memset(page, 0, PGSIZE);
    80202ad4:	6605                	lui	a2,0x1
    80202ad6:	4581                	li	a1,0
    80202ad8:	fc043503          	ld	a0,-64(s0)
    80202adc:	fffff097          	auipc	ra,0xfffff
    80202ae0:	330080e7          	jalr	816(ra) # 80201e0c <memset>
    int perm = 0;
    80202ae4:	fe042023          	sw	zero,-32(s0)
    if (type == 1) perm = PTE_X | PTE_R | PTE_U;
    80202ae8:	fb442783          	lw	a5,-76(s0)
    80202aec:	0007871b          	sext.w	a4,a5
    80202af0:	4785                	li	a5,1
    80202af2:	00f71663          	bne	a4,a5,80202afe <handle_page_fault+0x1a2>
    80202af6:	47e9                	li	a5,26
    80202af8:	fef42023          	sw	a5,-32(s0)
    80202afc:	a035                	j	80202b28 <handle_page_fault+0x1cc>
    else if (type == 2) perm = PTE_R | PTE_U;
    80202afe:	fb442783          	lw	a5,-76(s0)
    80202b02:	0007871b          	sext.w	a4,a5
    80202b06:	4789                	li	a5,2
    80202b08:	00f71663          	bne	a4,a5,80202b14 <handle_page_fault+0x1b8>
    80202b0c:	47c9                	li	a5,18
    80202b0e:	fef42023          	sw	a5,-32(s0)
    80202b12:	a819                	j	80202b28 <handle_page_fault+0x1cc>
    else if (type == 3) perm = PTE_R | PTE_W | PTE_U;
    80202b14:	fb442783          	lw	a5,-76(s0)
    80202b18:	0007871b          	sext.w	a4,a5
    80202b1c:	478d                	li	a5,3
    80202b1e:	00f71563          	bne	a4,a5,80202b28 <handle_page_fault+0x1cc>
    80202b22:	47d9                	li	a5,22
    80202b24:	fef42023          	sw	a5,-32(s0)
    if (map_page(pt, page_va, (uint64)page, perm) != 0) {
    80202b28:	fc043783          	ld	a5,-64(s0)
    80202b2c:	fe042703          	lw	a4,-32(s0)
    80202b30:	86ba                	mv	a3,a4
    80202b32:	863e                	mv	a2,a5
    80202b34:	fd843583          	ld	a1,-40(s0)
    80202b38:	fe843503          	ld	a0,-24(s0)
    80202b3c:	fffff097          	auipc	ra,0xfffff
    80202b40:	79c080e7          	jalr	1948(ra) # 802022d8 <map_page>
    80202b44:	87aa                	mv	a5,a0
    80202b46:	c38d                	beqz	a5,80202b68 <handle_page_fault+0x20c>
        free_page(page);
    80202b48:	fc043503          	ld	a0,-64(s0)
    80202b4c:	00000097          	auipc	ra,0x0
    80202b50:	720080e7          	jalr	1824(ra) # 8020326c <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    80202b54:	00005517          	auipc	a0,0x5
    80202b58:	4e450513          	addi	a0,a0,1252 # 80208038 <etext+0x1038>
    80202b5c:	ffffe097          	auipc	ra,0xffffe
    80202b60:	126080e7          	jalr	294(ra) # 80200c82 <printf>
        return 0;
    80202b64:	4781                	li	a5,0
    80202b66:	a01d                	j	80202b8c <handle_page_fault+0x230>
    sfence_vma();
    80202b68:	00000097          	auipc	ra,0x0
    80202b6c:	c3a080e7          	jalr	-966(ra) # 802027a2 <sfence_vma>
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    80202b70:	fc043783          	ld	a5,-64(s0)
    80202b74:	863e                	mv	a2,a5
    80202b76:	fd843583          	ld	a1,-40(s0)
    80202b7a:	00005517          	auipc	a0,0x5
    80202b7e:	4e650513          	addi	a0,a0,1254 # 80208060 <etext+0x1060>
    80202b82:	ffffe097          	auipc	ra,0xffffe
    80202b86:	100080e7          	jalr	256(ra) # 80200c82 <printf>
    return 1;
    80202b8a:	4785                	li	a5,1
}
    80202b8c:	853e                	mv	a0,a5
    80202b8e:	60a6                	ld	ra,72(sp)
    80202b90:	6406                	ld	s0,64(sp)
    80202b92:	6161                	addi	sp,sp,80
    80202b94:	8082                	ret

0000000080202b96 <test_pagetable>:
void test_pagetable(void) {
    80202b96:	7155                	addi	sp,sp,-208
    80202b98:	e586                	sd	ra,200(sp)
    80202b9a:	e1a2                	sd	s0,192(sp)
    80202b9c:	fd26                	sd	s1,184(sp)
    80202b9e:	f94a                	sd	s2,176(sp)
    80202ba0:	f54e                	sd	s3,168(sp)
    80202ba2:	f152                	sd	s4,160(sp)
    80202ba4:	ed56                	sd	s5,152(sp)
    80202ba6:	e95a                	sd	s6,144(sp)
    80202ba8:	e55e                	sd	s7,136(sp)
    80202baa:	e162                	sd	s8,128(sp)
    80202bac:	fce6                	sd	s9,120(sp)
    80202bae:	0980                	addi	s0,sp,208
    80202bb0:	878a                	mv	a5,sp
    80202bb2:	84be                	mv	s1,a5
    printf("[PT TEST] 创建页表...\n");
    80202bb4:	00005517          	auipc	a0,0x5
    80202bb8:	4ec50513          	addi	a0,a0,1260 # 802080a0 <etext+0x10a0>
    80202bbc:	ffffe097          	auipc	ra,0xffffe
    80202bc0:	0c6080e7          	jalr	198(ra) # 80200c82 <printf>
    pagetable_t pt = create_pagetable();
    80202bc4:	fffff097          	auipc	ra,0xfffff
    80202bc8:	4a4080e7          	jalr	1188(ra) # 80202068 <create_pagetable>
    80202bcc:	f8a43423          	sd	a0,-120(s0)
    assert(pt != 0);
    80202bd0:	f8843783          	ld	a5,-120(s0)
    80202bd4:	00f037b3          	snez	a5,a5
    80202bd8:	0ff7f793          	zext.b	a5,a5
    80202bdc:	2781                	sext.w	a5,a5
    80202bde:	853e                	mv	a0,a5
    80202be0:	fffff097          	auipc	ra,0xfffff
    80202be4:	39e080e7          	jalr	926(ra) # 80201f7e <assert>
    printf("[PT TEST] 页表创建通过\n");
    80202be8:	00005517          	auipc	a0,0x5
    80202bec:	4d850513          	addi	a0,a0,1240 # 802080c0 <etext+0x10c0>
    80202bf0:	ffffe097          	auipc	ra,0xffffe
    80202bf4:	092080e7          	jalr	146(ra) # 80200c82 <printf>
    uint64 va[] = {
    80202bf8:	00005797          	auipc	a5,0x5
    80202bfc:	68878793          	addi	a5,a5,1672 # 80208280 <etext+0x1280>
    80202c00:	638c                	ld	a1,0(a5)
    80202c02:	6790                	ld	a2,8(a5)
    80202c04:	6b94                	ld	a3,16(a5)
    80202c06:	6f98                	ld	a4,24(a5)
    80202c08:	739c                	ld	a5,32(a5)
    80202c0a:	f2b43c23          	sd	a1,-200(s0)
    80202c0e:	f4c43023          	sd	a2,-192(s0)
    80202c12:	f4d43423          	sd	a3,-184(s0)
    80202c16:	f4e43823          	sd	a4,-176(s0)
    80202c1a:	f4f43c23          	sd	a5,-168(s0)
    int n = sizeof(va) / sizeof(va[0]);
    80202c1e:	4795                	li	a5,5
    80202c20:	f8f42223          	sw	a5,-124(s0)
    uint64 pa[n];
    80202c24:	f8442783          	lw	a5,-124(s0)
    80202c28:	873e                	mv	a4,a5
    80202c2a:	177d                	addi	a4,a4,-1
    80202c2c:	f6e43c23          	sd	a4,-136(s0)
    80202c30:	873e                	mv	a4,a5
    80202c32:	8c3a                	mv	s8,a4
    80202c34:	4c81                	li	s9,0
    80202c36:	03ac5713          	srli	a4,s8,0x3a
    80202c3a:	006c9a93          	slli	s5,s9,0x6
    80202c3e:	01576ab3          	or	s5,a4,s5
    80202c42:	006c1a13          	slli	s4,s8,0x6
    80202c46:	873e                	mv	a4,a5
    80202c48:	8b3a                	mv	s6,a4
    80202c4a:	4b81                	li	s7,0
    80202c4c:	03ab5713          	srli	a4,s6,0x3a
    80202c50:	006b9993          	slli	s3,s7,0x6
    80202c54:	013769b3          	or	s3,a4,s3
    80202c58:	006b1913          	slli	s2,s6,0x6
    80202c5c:	078e                	slli	a5,a5,0x3
    80202c5e:	07bd                	addi	a5,a5,15
    80202c60:	8391                	srli	a5,a5,0x4
    80202c62:	0792                	slli	a5,a5,0x4
    80202c64:	40f10133          	sub	sp,sp,a5
    80202c68:	878a                	mv	a5,sp
    80202c6a:	079d                	addi	a5,a5,7
    80202c6c:	838d                	srli	a5,a5,0x3
    80202c6e:	078e                	slli	a5,a5,0x3
    80202c70:	f6f43823          	sd	a5,-144(s0)
    for (int i = 0; i < n; i++) {
    80202c74:	f8042e23          	sw	zero,-100(s0)
    80202c78:	a201                	j	80202d78 <test_pagetable+0x1e2>
        pa[i] = (uint64)alloc_page();
    80202c7a:	00000097          	auipc	ra,0x0
    80202c7e:	586080e7          	jalr	1414(ra) # 80203200 <alloc_page>
    80202c82:	87aa                	mv	a5,a0
    80202c84:	86be                	mv	a3,a5
    80202c86:	f7043703          	ld	a4,-144(s0)
    80202c8a:	f9c42783          	lw	a5,-100(s0)
    80202c8e:	078e                	slli	a5,a5,0x3
    80202c90:	97ba                	add	a5,a5,a4
    80202c92:	e394                	sd	a3,0(a5)
        assert(pa[i]);
    80202c94:	f7043703          	ld	a4,-144(s0)
    80202c98:	f9c42783          	lw	a5,-100(s0)
    80202c9c:	078e                	slli	a5,a5,0x3
    80202c9e:	97ba                	add	a5,a5,a4
    80202ca0:	639c                	ld	a5,0(a5)
    80202ca2:	2781                	sext.w	a5,a5
    80202ca4:	853e                	mv	a0,a5
    80202ca6:	fffff097          	auipc	ra,0xfffff
    80202caa:	2d8080e7          	jalr	728(ra) # 80201f7e <assert>
        printf("[PT TEST] 分配物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202cae:	f7043703          	ld	a4,-144(s0)
    80202cb2:	f9c42783          	lw	a5,-100(s0)
    80202cb6:	078e                	slli	a5,a5,0x3
    80202cb8:	97ba                	add	a5,a5,a4
    80202cba:	6398                	ld	a4,0(a5)
    80202cbc:	f9c42783          	lw	a5,-100(s0)
    80202cc0:	863a                	mv	a2,a4
    80202cc2:	85be                	mv	a1,a5
    80202cc4:	00005517          	auipc	a0,0x5
    80202cc8:	41c50513          	addi	a0,a0,1052 # 802080e0 <etext+0x10e0>
    80202ccc:	ffffe097          	auipc	ra,0xffffe
    80202cd0:	fb6080e7          	jalr	-74(ra) # 80200c82 <printf>
        int ret = map_page(pt, va[i], pa[i], PTE_R | PTE_W);
    80202cd4:	f9c42783          	lw	a5,-100(s0)
    80202cd8:	078e                	slli	a5,a5,0x3
    80202cda:	fa078793          	addi	a5,a5,-96
    80202cde:	97a2                	add	a5,a5,s0
    80202ce0:	f987b583          	ld	a1,-104(a5)
    80202ce4:	f7043703          	ld	a4,-144(s0)
    80202ce8:	f9c42783          	lw	a5,-100(s0)
    80202cec:	078e                	slli	a5,a5,0x3
    80202cee:	97ba                	add	a5,a5,a4
    80202cf0:	639c                	ld	a5,0(a5)
    80202cf2:	4699                	li	a3,6
    80202cf4:	863e                	mv	a2,a5
    80202cf6:	f8843503          	ld	a0,-120(s0)
    80202cfa:	fffff097          	auipc	ra,0xfffff
    80202cfe:	5de080e7          	jalr	1502(ra) # 802022d8 <map_page>
    80202d02:	87aa                	mv	a5,a0
    80202d04:	f6f42223          	sw	a5,-156(s0)
        printf("[PT TEST] 映射 va=0x%lx -> pa=0x%lx %s\n", va[i], pa[i], ret == 0 ? "成功" : "失败");
    80202d08:	f9c42783          	lw	a5,-100(s0)
    80202d0c:	078e                	slli	a5,a5,0x3
    80202d0e:	fa078793          	addi	a5,a5,-96
    80202d12:	97a2                	add	a5,a5,s0
    80202d14:	f987b583          	ld	a1,-104(a5)
    80202d18:	f7043703          	ld	a4,-144(s0)
    80202d1c:	f9c42783          	lw	a5,-100(s0)
    80202d20:	078e                	slli	a5,a5,0x3
    80202d22:	97ba                	add	a5,a5,a4
    80202d24:	6398                	ld	a4,0(a5)
    80202d26:	f6442783          	lw	a5,-156(s0)
    80202d2a:	2781                	sext.w	a5,a5
    80202d2c:	e791                	bnez	a5,80202d38 <test_pagetable+0x1a2>
    80202d2e:	00005797          	auipc	a5,0x5
    80202d32:	3da78793          	addi	a5,a5,986 # 80208108 <etext+0x1108>
    80202d36:	a029                	j	80202d40 <test_pagetable+0x1aa>
    80202d38:	00005797          	auipc	a5,0x5
    80202d3c:	3d878793          	addi	a5,a5,984 # 80208110 <etext+0x1110>
    80202d40:	86be                	mv	a3,a5
    80202d42:	863a                	mv	a2,a4
    80202d44:	00005517          	auipc	a0,0x5
    80202d48:	3d450513          	addi	a0,a0,980 # 80208118 <etext+0x1118>
    80202d4c:	ffffe097          	auipc	ra,0xffffe
    80202d50:	f36080e7          	jalr	-202(ra) # 80200c82 <printf>
        assert(ret == 0);
    80202d54:	f6442783          	lw	a5,-156(s0)
    80202d58:	2781                	sext.w	a5,a5
    80202d5a:	0017b793          	seqz	a5,a5
    80202d5e:	0ff7f793          	zext.b	a5,a5
    80202d62:	2781                	sext.w	a5,a5
    80202d64:	853e                	mv	a0,a5
    80202d66:	fffff097          	auipc	ra,0xfffff
    80202d6a:	218080e7          	jalr	536(ra) # 80201f7e <assert>
    for (int i = 0; i < n; i++) {
    80202d6e:	f9c42783          	lw	a5,-100(s0)
    80202d72:	2785                	addiw	a5,a5,1
    80202d74:	f8f42e23          	sw	a5,-100(s0)
    80202d78:	f9c42783          	lw	a5,-100(s0)
    80202d7c:	873e                	mv	a4,a5
    80202d7e:	f8442783          	lw	a5,-124(s0)
    80202d82:	2701                	sext.w	a4,a4
    80202d84:	2781                	sext.w	a5,a5
    80202d86:	eef74ae3          	blt	a4,a5,80202c7a <test_pagetable+0xe4>
    printf("[PT TEST] 多级映射测试通过\n");
    80202d8a:	00005517          	auipc	a0,0x5
    80202d8e:	3be50513          	addi	a0,a0,958 # 80208148 <etext+0x1148>
    80202d92:	ffffe097          	auipc	ra,0xffffe
    80202d96:	ef0080e7          	jalr	-272(ra) # 80200c82 <printf>
    for (int i = 0; i < n; i++) {
    80202d9a:	f8042c23          	sw	zero,-104(s0)
    80202d9e:	a861                	j	80202e36 <test_pagetable+0x2a0>
        pte_t *pte = walk_lookup(pt, va[i]);
    80202da0:	f9842783          	lw	a5,-104(s0)
    80202da4:	078e                	slli	a5,a5,0x3
    80202da6:	fa078793          	addi	a5,a5,-96
    80202daa:	97a2                	add	a5,a5,s0
    80202dac:	f987b783          	ld	a5,-104(a5)
    80202db0:	85be                	mv	a1,a5
    80202db2:	f8843503          	ld	a0,-120(s0)
    80202db6:	fffff097          	auipc	ra,0xfffff
    80202dba:	2ee080e7          	jalr	750(ra) # 802020a4 <walk_lookup>
    80202dbe:	f6a43423          	sd	a0,-152(s0)
        if (pte && (*pte & PTE_V)) {
    80202dc2:	f6843783          	ld	a5,-152(s0)
    80202dc6:	c3b1                	beqz	a5,80202e0a <test_pagetable+0x274>
    80202dc8:	f6843783          	ld	a5,-152(s0)
    80202dcc:	639c                	ld	a5,0(a5)
    80202dce:	8b85                	andi	a5,a5,1
    80202dd0:	cf8d                	beqz	a5,80202e0a <test_pagetable+0x274>
            printf("[PT TEST] 检查映射: va=0x%lx -> pa=0x%lx, pte=0x%lx\n", va[i], PTE2PA(*pte), *pte);
    80202dd2:	f9842783          	lw	a5,-104(s0)
    80202dd6:	078e                	slli	a5,a5,0x3
    80202dd8:	fa078793          	addi	a5,a5,-96
    80202ddc:	97a2                	add	a5,a5,s0
    80202dde:	f987b703          	ld	a4,-104(a5)
    80202de2:	f6843783          	ld	a5,-152(s0)
    80202de6:	639c                	ld	a5,0(a5)
    80202de8:	83a9                	srli	a5,a5,0xa
    80202dea:	00c79613          	slli	a2,a5,0xc
    80202dee:	f6843783          	ld	a5,-152(s0)
    80202df2:	639c                	ld	a5,0(a5)
    80202df4:	86be                	mv	a3,a5
    80202df6:	85ba                	mv	a1,a4
    80202df8:	00005517          	auipc	a0,0x5
    80202dfc:	37850513          	addi	a0,a0,888 # 80208170 <etext+0x1170>
    80202e00:	ffffe097          	auipc	ra,0xffffe
    80202e04:	e82080e7          	jalr	-382(ra) # 80200c82 <printf>
    80202e08:	a015                	j	80202e2c <test_pagetable+0x296>
            printf("[PT TEST] 检查映射: va=0x%lx 未映射\n", va[i]);
    80202e0a:	f9842783          	lw	a5,-104(s0)
    80202e0e:	078e                	slli	a5,a5,0x3
    80202e10:	fa078793          	addi	a5,a5,-96
    80202e14:	97a2                	add	a5,a5,s0
    80202e16:	f987b783          	ld	a5,-104(a5)
    80202e1a:	85be                	mv	a1,a5
    80202e1c:	00005517          	auipc	a0,0x5
    80202e20:	39450513          	addi	a0,a0,916 # 802081b0 <etext+0x11b0>
    80202e24:	ffffe097          	auipc	ra,0xffffe
    80202e28:	e5e080e7          	jalr	-418(ra) # 80200c82 <printf>
    for (int i = 0; i < n; i++) {
    80202e2c:	f9842783          	lw	a5,-104(s0)
    80202e30:	2785                	addiw	a5,a5,1
    80202e32:	f8f42c23          	sw	a5,-104(s0)
    80202e36:	f9842783          	lw	a5,-104(s0)
    80202e3a:	873e                	mv	a4,a5
    80202e3c:	f8442783          	lw	a5,-124(s0)
    80202e40:	2701                	sext.w	a4,a4
    80202e42:	2781                	sext.w	a5,a5
    80202e44:	f4f74ee3          	blt	a4,a5,80202da0 <test_pagetable+0x20a>
    printf("[PT TEST] 打印页表结构（递归）\n");
    80202e48:	00005517          	auipc	a0,0x5
    80202e4c:	39850513          	addi	a0,a0,920 # 802081e0 <etext+0x11e0>
    80202e50:	ffffe097          	auipc	ra,0xffffe
    80202e54:	e32080e7          	jalr	-462(ra) # 80200c82 <printf>
    print_pagetable(pt, 0, 0);
    80202e58:	4601                	li	a2,0
    80202e5a:	4581                	li	a1,0
    80202e5c:	f8843503          	ld	a0,-120(s0)
    80202e60:	00000097          	auipc	ra,0x0
    80202e64:	9e6080e7          	jalr	-1562(ra) # 80202846 <print_pagetable>
    for (int i = 0; i < n; i++) {
    80202e68:	f8042a23          	sw	zero,-108(s0)
    80202e6c:	a0a9                	j	80202eb6 <test_pagetable+0x320>
        free_page((void*)pa[i]);
    80202e6e:	f7043703          	ld	a4,-144(s0)
    80202e72:	f9442783          	lw	a5,-108(s0)
    80202e76:	078e                	slli	a5,a5,0x3
    80202e78:	97ba                	add	a5,a5,a4
    80202e7a:	639c                	ld	a5,0(a5)
    80202e7c:	853e                	mv	a0,a5
    80202e7e:	00000097          	auipc	ra,0x0
    80202e82:	3ee080e7          	jalr	1006(ra) # 8020326c <free_page>
        printf("[PT TEST] 释放物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202e86:	f7043703          	ld	a4,-144(s0)
    80202e8a:	f9442783          	lw	a5,-108(s0)
    80202e8e:	078e                	slli	a5,a5,0x3
    80202e90:	97ba                	add	a5,a5,a4
    80202e92:	6398                	ld	a4,0(a5)
    80202e94:	f9442783          	lw	a5,-108(s0)
    80202e98:	863a                	mv	a2,a4
    80202e9a:	85be                	mv	a1,a5
    80202e9c:	00005517          	auipc	a0,0x5
    80202ea0:	37450513          	addi	a0,a0,884 # 80208210 <etext+0x1210>
    80202ea4:	ffffe097          	auipc	ra,0xffffe
    80202ea8:	dde080e7          	jalr	-546(ra) # 80200c82 <printf>
    for (int i = 0; i < n; i++) {
    80202eac:	f9442783          	lw	a5,-108(s0)
    80202eb0:	2785                	addiw	a5,a5,1
    80202eb2:	f8f42a23          	sw	a5,-108(s0)
    80202eb6:	f9442783          	lw	a5,-108(s0)
    80202eba:	873e                	mv	a4,a5
    80202ebc:	f8442783          	lw	a5,-124(s0)
    80202ec0:	2701                	sext.w	a4,a4
    80202ec2:	2781                	sext.w	a5,a5
    80202ec4:	faf745e3          	blt	a4,a5,80202e6e <test_pagetable+0x2d8>
    free_pagetable(pt);
    80202ec8:	f8843503          	ld	a0,-120(s0)
    80202ecc:	fffff097          	auipc	ra,0xfffff
    80202ed0:	56c080e7          	jalr	1388(ra) # 80202438 <free_pagetable>
    printf("[PT TEST] 释放页表完成\n");
    80202ed4:	00005517          	auipc	a0,0x5
    80202ed8:	36450513          	addi	a0,a0,868 # 80208238 <etext+0x1238>
    80202edc:	ffffe097          	auipc	ra,0xffffe
    80202ee0:	da6080e7          	jalr	-602(ra) # 80200c82 <printf>
    printf("[PT TEST] 所有页表测试通过\n");
    80202ee4:	00005517          	auipc	a0,0x5
    80202ee8:	37450513          	addi	a0,a0,884 # 80208258 <etext+0x1258>
    80202eec:	ffffe097          	auipc	ra,0xffffe
    80202ef0:	d96080e7          	jalr	-618(ra) # 80200c82 <printf>
    80202ef4:	8126                	mv	sp,s1
}
    80202ef6:	0001                	nop
    80202ef8:	f3040113          	addi	sp,s0,-208
    80202efc:	60ae                	ld	ra,200(sp)
    80202efe:	640e                	ld	s0,192(sp)
    80202f00:	74ea                	ld	s1,184(sp)
    80202f02:	794a                	ld	s2,176(sp)
    80202f04:	79aa                	ld	s3,168(sp)
    80202f06:	7a0a                	ld	s4,160(sp)
    80202f08:	6aea                	ld	s5,152(sp)
    80202f0a:	6b4a                	ld	s6,144(sp)
    80202f0c:	6baa                	ld	s7,136(sp)
    80202f0e:	6c0a                	ld	s8,128(sp)
    80202f10:	7ce6                	ld	s9,120(sp)
    80202f12:	6169                	addi	sp,sp,208
    80202f14:	8082                	ret

0000000080202f16 <check_mapping>:
void check_mapping(uint64 va) {
    80202f16:	7179                	addi	sp,sp,-48
    80202f18:	f406                	sd	ra,40(sp)
    80202f1a:	f022                	sd	s0,32(sp)
    80202f1c:	1800                	addi	s0,sp,48
    80202f1e:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    80202f22:	00009797          	auipc	a5,0x9
    80202f26:	17e78793          	addi	a5,a5,382 # 8020c0a0 <kernel_pagetable>
    80202f2a:	639c                	ld	a5,0(a5)
    80202f2c:	fd843583          	ld	a1,-40(s0)
    80202f30:	853e                	mv	a0,a5
    80202f32:	fffff097          	auipc	ra,0xfffff
    80202f36:	172080e7          	jalr	370(ra) # 802020a4 <walk_lookup>
    80202f3a:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    80202f3e:	fe843783          	ld	a5,-24(s0)
    80202f42:	cbb9                	beqz	a5,80202f98 <check_mapping+0x82>
    80202f44:	fe843783          	ld	a5,-24(s0)
    80202f48:	639c                	ld	a5,0(a5)
    80202f4a:	8b85                	andi	a5,a5,1
    80202f4c:	c7b1                	beqz	a5,80202f98 <check_mapping+0x82>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80202f4e:	fe843783          	ld	a5,-24(s0)
    80202f52:	639c                	ld	a5,0(a5)
    80202f54:	863e                	mv	a2,a5
    80202f56:	fd843583          	ld	a1,-40(s0)
    80202f5a:	00005517          	auipc	a0,0x5
    80202f5e:	34e50513          	addi	a0,a0,846 # 802082a8 <etext+0x12a8>
    80202f62:	ffffe097          	auipc	ra,0xffffe
    80202f66:	d20080e7          	jalr	-736(ra) # 80200c82 <printf>
		volatile unsigned char *p = (unsigned char*)va;
    80202f6a:	fd843783          	ld	a5,-40(s0)
    80202f6e:	fef43023          	sd	a5,-32(s0)
        printf("Try to read [0x%lx]: 0x%02x\n", va, *p);
    80202f72:	fe043783          	ld	a5,-32(s0)
    80202f76:	0007c783          	lbu	a5,0(a5)
    80202f7a:	0ff7f793          	zext.b	a5,a5
    80202f7e:	2781                	sext.w	a5,a5
    80202f80:	863e                	mv	a2,a5
    80202f82:	fd843583          	ld	a1,-40(s0)
    80202f86:	00005517          	auipc	a0,0x5
    80202f8a:	34a50513          	addi	a0,a0,842 # 802082d0 <etext+0x12d0>
    80202f8e:	ffffe097          	auipc	ra,0xffffe
    80202f92:	cf4080e7          	jalr	-780(ra) # 80200c82 <printf>
    if(pte && (*pte & PTE_V)) {
    80202f96:	a821                	j	80202fae <check_mapping+0x98>
        printf("Address 0x%lx is NOT mapped\n", va);
    80202f98:	fd843583          	ld	a1,-40(s0)
    80202f9c:	00005517          	auipc	a0,0x5
    80202fa0:	35450513          	addi	a0,a0,852 # 802082f0 <etext+0x12f0>
    80202fa4:	ffffe097          	auipc	ra,0xffffe
    80202fa8:	cde080e7          	jalr	-802(ra) # 80200c82 <printf>
}
    80202fac:	0001                	nop
    80202fae:	0001                	nop
    80202fb0:	70a2                	ld	ra,40(sp)
    80202fb2:	7402                	ld	s0,32(sp)
    80202fb4:	6145                	addi	sp,sp,48
    80202fb6:	8082                	ret

0000000080202fb8 <check_is_mapped>:
int check_is_mapped(uint64 va) {
    80202fb8:	7179                	addi	sp,sp,-48
    80202fba:	f406                	sd	ra,40(sp)
    80202fbc:	f022                	sd	s0,32(sp)
    80202fbe:	1800                	addi	s0,sp,48
    80202fc0:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    80202fc4:	00000097          	auipc	ra,0x0
    80202fc8:	86a080e7          	jalr	-1942(ra) # 8020282e <get_current_pagetable>
    80202fcc:	87aa                	mv	a5,a0
    80202fce:	fd843583          	ld	a1,-40(s0)
    80202fd2:	853e                	mv	a0,a5
    80202fd4:	fffff097          	auipc	ra,0xfffff
    80202fd8:	0d0080e7          	jalr	208(ra) # 802020a4 <walk_lookup>
    80202fdc:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    80202fe0:	fe843783          	ld	a5,-24(s0)
    80202fe4:	c795                	beqz	a5,80203010 <check_is_mapped+0x58>
    80202fe6:	fe843783          	ld	a5,-24(s0)
    80202fea:	639c                	ld	a5,0(a5)
    80202fec:	8b85                	andi	a5,a5,1
    80202fee:	c38d                	beqz	a5,80203010 <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80202ff0:	fe843783          	ld	a5,-24(s0)
    80202ff4:	639c                	ld	a5,0(a5)
    80202ff6:	863e                	mv	a2,a5
    80202ff8:	fd843583          	ld	a1,-40(s0)
    80202ffc:	00005517          	auipc	a0,0x5
    80203000:	2ac50513          	addi	a0,a0,684 # 802082a8 <etext+0x12a8>
    80203004:	ffffe097          	auipc	ra,0xffffe
    80203008:	c7e080e7          	jalr	-898(ra) # 80200c82 <printf>
        return 1;
    8020300c:	4785                	li	a5,1
    8020300e:	a821                	j	80203026 <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    80203010:	fd843583          	ld	a1,-40(s0)
    80203014:	00005517          	auipc	a0,0x5
    80203018:	2dc50513          	addi	a0,a0,732 # 802082f0 <etext+0x12f0>
    8020301c:	ffffe097          	auipc	ra,0xffffe
    80203020:	c66080e7          	jalr	-922(ra) # 80200c82 <printf>
        return 0;
    80203024:	4781                	li	a5,0
}
    80203026:	853e                	mv	a0,a5
    80203028:	70a2                	ld	ra,40(sp)
    8020302a:	7402                	ld	s0,32(sp)
    8020302c:	6145                	addi	sp,sp,48
    8020302e:	8082                	ret

0000000080203030 <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80203030:	711d                	addi	sp,sp,-96
    80203032:	ec86                	sd	ra,88(sp)
    80203034:	e8a2                	sd	s0,80(sp)
    80203036:	1080                	addi	s0,sp,96
    80203038:	faa43c23          	sd	a0,-72(s0)
    8020303c:	fab43823          	sd	a1,-80(s0)
    80203040:	fac43423          	sd	a2,-88(s0)
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    80203044:	fe043423          	sd	zero,-24(s0)
    80203048:	a8d1                	j	8020311c <uvmcopy+0xec>
        pte_t *pte = walk_lookup(old, i);
    8020304a:	fe843583          	ld	a1,-24(s0)
    8020304e:	fb843503          	ld	a0,-72(s0)
    80203052:	fffff097          	auipc	ra,0xfffff
    80203056:	052080e7          	jalr	82(ra) # 802020a4 <walk_lookup>
    8020305a:	fca43c23          	sd	a0,-40(s0)
        if (pte == 0 || (*pte & PTE_V) == 0)
    8020305e:	fd843783          	ld	a5,-40(s0)
    80203062:	c7d5                	beqz	a5,8020310e <uvmcopy+0xde>
    80203064:	fd843783          	ld	a5,-40(s0)
    80203068:	639c                	ld	a5,0(a5)
    8020306a:	8b85                	andi	a5,a5,1
    8020306c:	c3cd                	beqz	a5,8020310e <uvmcopy+0xde>
        uint64 pa = PTE2PA(*pte);
    8020306e:	fd843783          	ld	a5,-40(s0)
    80203072:	639c                	ld	a5,0(a5)
    80203074:	83a9                	srli	a5,a5,0xa
    80203076:	07b2                	slli	a5,a5,0xc
    80203078:	fcf43823          	sd	a5,-48(s0)
        int flags = PTE_FLAGS(*pte);
    8020307c:	fd843783          	ld	a5,-40(s0)
    80203080:	639c                	ld	a5,0(a5)
    80203082:	2781                	sext.w	a5,a5
    80203084:	3ff7f793          	andi	a5,a5,1023
    80203088:	fef42223          	sw	a5,-28(s0)
		if (i < 0x80000000)
    8020308c:	fe843703          	ld	a4,-24(s0)
    80203090:	800007b7          	lui	a5,0x80000
    80203094:	fff7c793          	not	a5,a5
    80203098:	00e7e963          	bltu	a5,a4,802030aa <uvmcopy+0x7a>
			flags |= PTE_U;
    8020309c:	fe442783          	lw	a5,-28(s0)
    802030a0:	0107e793          	ori	a5,a5,16
    802030a4:	fef42223          	sw	a5,-28(s0)
    802030a8:	a031                	j	802030b4 <uvmcopy+0x84>
			flags &= ~PTE_U;
    802030aa:	fe442783          	lw	a5,-28(s0)
    802030ae:	9bbd                	andi	a5,a5,-17
    802030b0:	fef42223          	sw	a5,-28(s0)
        void *mem = alloc_page();
    802030b4:	00000097          	auipc	ra,0x0
    802030b8:	14c080e7          	jalr	332(ra) # 80203200 <alloc_page>
    802030bc:	fca43423          	sd	a0,-56(s0)
        if (mem == 0)
    802030c0:	fc843783          	ld	a5,-56(s0)
    802030c4:	e399                	bnez	a5,802030ca <uvmcopy+0x9a>
            return -1; // 分配失败
    802030c6:	57fd                	li	a5,-1
    802030c8:	a08d                	j	8020312a <uvmcopy+0xfa>
        memmove(mem, (void*)pa, PGSIZE);
    802030ca:	fd043783          	ld	a5,-48(s0)
    802030ce:	6605                	lui	a2,0x1
    802030d0:	85be                	mv	a1,a5
    802030d2:	fc843503          	ld	a0,-56(s0)
    802030d6:	fffff097          	auipc	ra,0xfffff
    802030da:	d86080e7          	jalr	-634(ra) # 80201e5c <memmove>
        if (map_page(new, i, (uint64)mem, flags) != 0) {
    802030de:	fc843783          	ld	a5,-56(s0)
    802030e2:	fe442703          	lw	a4,-28(s0)
    802030e6:	86ba                	mv	a3,a4
    802030e8:	863e                	mv	a2,a5
    802030ea:	fe843583          	ld	a1,-24(s0)
    802030ee:	fb043503          	ld	a0,-80(s0)
    802030f2:	fffff097          	auipc	ra,0xfffff
    802030f6:	1e6080e7          	jalr	486(ra) # 802022d8 <map_page>
    802030fa:	87aa                	mv	a5,a0
    802030fc:	cb91                	beqz	a5,80203110 <uvmcopy+0xe0>
            free_page(mem);
    802030fe:	fc843503          	ld	a0,-56(s0)
    80203102:	00000097          	auipc	ra,0x0
    80203106:	16a080e7          	jalr	362(ra) # 8020326c <free_page>
            return -1;
    8020310a:	57fd                	li	a5,-1
    8020310c:	a839                	j	8020312a <uvmcopy+0xfa>
            continue; // 跳过未分配的页
    8020310e:	0001                	nop
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    80203110:	fe843703          	ld	a4,-24(s0)
    80203114:	6785                	lui	a5,0x1
    80203116:	97ba                	add	a5,a5,a4
    80203118:	fef43423          	sd	a5,-24(s0)
    8020311c:	fe843703          	ld	a4,-24(s0)
    80203120:	fa843783          	ld	a5,-88(s0)
    80203124:	f2f763e3          	bltu	a4,a5,8020304a <uvmcopy+0x1a>
    return 0;
    80203128:	4781                	li	a5,0
    8020312a:	853e                	mv	a0,a5
    8020312c:	60e6                	ld	ra,88(sp)
    8020312e:	6446                	ld	s0,80(sp)
    80203130:	6125                	addi	sp,sp,96
    80203132:	8082                	ret

0000000080203134 <assert>:
    80203134:	1101                	addi	sp,sp,-32
    80203136:	ec06                	sd	ra,24(sp)
    80203138:	e822                	sd	s0,16(sp)
    8020313a:	1000                	addi	s0,sp,32
    8020313c:	87aa                	mv	a5,a0
    8020313e:	fef42623          	sw	a5,-20(s0)
    80203142:	fec42783          	lw	a5,-20(s0)
    80203146:	2781                	sext.w	a5,a5
    80203148:	e79d                	bnez	a5,80203176 <assert+0x42>
    8020314a:	18f00613          	li	a2,399
    8020314e:	00005597          	auipc	a1,0x5
    80203152:	1c258593          	addi	a1,a1,450 # 80208310 <etext+0x1310>
    80203156:	00005517          	auipc	a0,0x5
    8020315a:	1ca50513          	addi	a0,a0,458 # 80208320 <etext+0x1320>
    8020315e:	ffffe097          	auipc	ra,0xffffe
    80203162:	b24080e7          	jalr	-1244(ra) # 80200c82 <printf>
    80203166:	00005517          	auipc	a0,0x5
    8020316a:	1e250513          	addi	a0,a0,482 # 80208348 <etext+0x1348>
    8020316e:	ffffe097          	auipc	ra,0xffffe
    80203172:	560080e7          	jalr	1376(ra) # 802016ce <panic>
    80203176:	0001                	nop
    80203178:	60e2                	ld	ra,24(sp)
    8020317a:	6442                	ld	s0,16(sp)
    8020317c:	6105                	addi	sp,sp,32
    8020317e:	8082                	ret

0000000080203180 <freerange>:
static void freerange(void *pa_start, void *pa_end) {
    80203180:	7179                	addi	sp,sp,-48
    80203182:	f406                	sd	ra,40(sp)
    80203184:	f022                	sd	s0,32(sp)
    80203186:	1800                	addi	s0,sp,48
    80203188:	fca43c23          	sd	a0,-40(s0)
    8020318c:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    80203190:	fd843703          	ld	a4,-40(s0)
    80203194:	6785                	lui	a5,0x1
    80203196:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203198:	973e                	add	a4,a4,a5
    8020319a:	77fd                	lui	a5,0xfffff
    8020319c:	8ff9                	and	a5,a5,a4
    8020319e:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802031a2:	a829                	j	802031bc <freerange+0x3c>
    free_page(p);
    802031a4:	fe843503          	ld	a0,-24(s0)
    802031a8:	00000097          	auipc	ra,0x0
    802031ac:	0c4080e7          	jalr	196(ra) # 8020326c <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802031b0:	fe843703          	ld	a4,-24(s0)
    802031b4:	6785                	lui	a5,0x1
    802031b6:	97ba                	add	a5,a5,a4
    802031b8:	fef43423          	sd	a5,-24(s0)
    802031bc:	fe843703          	ld	a4,-24(s0)
    802031c0:	6785                	lui	a5,0x1
    802031c2:	97ba                	add	a5,a5,a4
    802031c4:	fd043703          	ld	a4,-48(s0)
    802031c8:	fcf77ee3          	bgeu	a4,a5,802031a4 <freerange+0x24>
}
    802031cc:	0001                	nop
    802031ce:	0001                	nop
    802031d0:	70a2                	ld	ra,40(sp)
    802031d2:	7402                	ld	s0,32(sp)
    802031d4:	6145                	addi	sp,sp,48
    802031d6:	8082                	ret

00000000802031d8 <pmm_init>:
void pmm_init(void) {
    802031d8:	1141                	addi	sp,sp,-16
    802031da:	e406                	sd	ra,8(sp)
    802031dc:	e022                	sd	s0,0(sp)
    802031de:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    802031e0:	47c5                	li	a5,17
    802031e2:	01b79593          	slli	a1,a5,0x1b
    802031e6:	00009517          	auipc	a0,0x9
    802031ea:	72a50513          	addi	a0,a0,1834 # 8020c910 <_bss_end>
    802031ee:	00000097          	auipc	ra,0x0
    802031f2:	f92080e7          	jalr	-110(ra) # 80203180 <freerange>
}
    802031f6:	0001                	nop
    802031f8:	60a2                	ld	ra,8(sp)
    802031fa:	6402                	ld	s0,0(sp)
    802031fc:	0141                	addi	sp,sp,16
    802031fe:	8082                	ret

0000000080203200 <alloc_page>:
void* alloc_page(void) {
    80203200:	1101                	addi	sp,sp,-32
    80203202:	ec06                	sd	ra,24(sp)
    80203204:	e822                	sd	s0,16(sp)
    80203206:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80203208:	00009797          	auipc	a5,0x9
    8020320c:	06878793          	addi	a5,a5,104 # 8020c270 <freelist>
    80203210:	639c                	ld	a5,0(a5)
    80203212:	fef43423          	sd	a5,-24(s0)
  if(r)
    80203216:	fe843783          	ld	a5,-24(s0)
    8020321a:	cb89                	beqz	a5,8020322c <alloc_page+0x2c>
    freelist = r->next;
    8020321c:	fe843783          	ld	a5,-24(s0)
    80203220:	6398                	ld	a4,0(a5)
    80203222:	00009797          	auipc	a5,0x9
    80203226:	04e78793          	addi	a5,a5,78 # 8020c270 <freelist>
    8020322a:	e398                	sd	a4,0(a5)
  if(r)
    8020322c:	fe843783          	ld	a5,-24(s0)
    80203230:	cf99                	beqz	a5,8020324e <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    80203232:	fe843783          	ld	a5,-24(s0)
    80203236:	00878713          	addi	a4,a5,8
    8020323a:	6785                	lui	a5,0x1
    8020323c:	ff878613          	addi	a2,a5,-8 # ff8 <_entry-0x801ff008>
    80203240:	4595                	li	a1,5
    80203242:	853a                	mv	a0,a4
    80203244:	fffff097          	auipc	ra,0xfffff
    80203248:	bc8080e7          	jalr	-1080(ra) # 80201e0c <memset>
    8020324c:	a809                	j	8020325e <alloc_page+0x5e>
    panic("alloc_page: out of memory");
    8020324e:	00005517          	auipc	a0,0x5
    80203252:	10250513          	addi	a0,a0,258 # 80208350 <etext+0x1350>
    80203256:	ffffe097          	auipc	ra,0xffffe
    8020325a:	478080e7          	jalr	1144(ra) # 802016ce <panic>
  return (void*)r;
    8020325e:	fe843783          	ld	a5,-24(s0)
}
    80203262:	853e                	mv	a0,a5
    80203264:	60e2                	ld	ra,24(sp)
    80203266:	6442                	ld	s0,16(sp)
    80203268:	6105                	addi	sp,sp,32
    8020326a:	8082                	ret

000000008020326c <free_page>:
void free_page(void* page) {
    8020326c:	7179                	addi	sp,sp,-48
    8020326e:	f406                	sd	ra,40(sp)
    80203270:	f022                	sd	s0,32(sp)
    80203272:	1800                	addi	s0,sp,48
    80203274:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    80203278:	fd843783          	ld	a5,-40(s0)
    8020327c:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    80203280:	fd843703          	ld	a4,-40(s0)
    80203284:	6785                	lui	a5,0x1
    80203286:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203288:	8ff9                	and	a5,a5,a4
    8020328a:	ef99                	bnez	a5,802032a8 <free_page+0x3c>
    8020328c:	fd843703          	ld	a4,-40(s0)
    80203290:	00009797          	auipc	a5,0x9
    80203294:	68078793          	addi	a5,a5,1664 # 8020c910 <_bss_end>
    80203298:	00f76863          	bltu	a4,a5,802032a8 <free_page+0x3c>
    8020329c:	fd843703          	ld	a4,-40(s0)
    802032a0:	47c5                	li	a5,17
    802032a2:	07ee                	slli	a5,a5,0x1b
    802032a4:	00f76a63          	bltu	a4,a5,802032b8 <free_page+0x4c>
    panic("free_page: invalid page address");
    802032a8:	00005517          	auipc	a0,0x5
    802032ac:	0c850513          	addi	a0,a0,200 # 80208370 <etext+0x1370>
    802032b0:	ffffe097          	auipc	ra,0xffffe
    802032b4:	41e080e7          	jalr	1054(ra) # 802016ce <panic>
  r->next = freelist;
    802032b8:	00009797          	auipc	a5,0x9
    802032bc:	fb878793          	addi	a5,a5,-72 # 8020c270 <freelist>
    802032c0:	6398                	ld	a4,0(a5)
    802032c2:	fe843783          	ld	a5,-24(s0)
    802032c6:	e398                	sd	a4,0(a5)
  freelist = r;
    802032c8:	00009797          	auipc	a5,0x9
    802032cc:	fa878793          	addi	a5,a5,-88 # 8020c270 <freelist>
    802032d0:	fe843703          	ld	a4,-24(s0)
    802032d4:	e398                	sd	a4,0(a5)
}
    802032d6:	0001                	nop
    802032d8:	70a2                	ld	ra,40(sp)
    802032da:	7402                	ld	s0,32(sp)
    802032dc:	6145                	addi	sp,sp,48
    802032de:	8082                	ret

00000000802032e0 <test_physical_memory>:
void test_physical_memory(void) {
    802032e0:	7179                	addi	sp,sp,-48
    802032e2:	f406                	sd	ra,40(sp)
    802032e4:	f022                	sd	s0,32(sp)
    802032e6:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    802032e8:	00005517          	auipc	a0,0x5
    802032ec:	0a850513          	addi	a0,a0,168 # 80208390 <etext+0x1390>
    802032f0:	ffffe097          	auipc	ra,0xffffe
    802032f4:	992080e7          	jalr	-1646(ra) # 80200c82 <printf>
    void *page1 = alloc_page();
    802032f8:	00000097          	auipc	ra,0x0
    802032fc:	f08080e7          	jalr	-248(ra) # 80203200 <alloc_page>
    80203300:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    80203304:	00000097          	auipc	ra,0x0
    80203308:	efc080e7          	jalr	-260(ra) # 80203200 <alloc_page>
    8020330c:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    80203310:	fe843783          	ld	a5,-24(s0)
    80203314:	00f037b3          	snez	a5,a5
    80203318:	0ff7f793          	zext.b	a5,a5
    8020331c:	2781                	sext.w	a5,a5
    8020331e:	853e                	mv	a0,a5
    80203320:	00000097          	auipc	ra,0x0
    80203324:	e14080e7          	jalr	-492(ra) # 80203134 <assert>
    assert(page2 != 0);
    80203328:	fe043783          	ld	a5,-32(s0)
    8020332c:	00f037b3          	snez	a5,a5
    80203330:	0ff7f793          	zext.b	a5,a5
    80203334:	2781                	sext.w	a5,a5
    80203336:	853e                	mv	a0,a5
    80203338:	00000097          	auipc	ra,0x0
    8020333c:	dfc080e7          	jalr	-516(ra) # 80203134 <assert>
    assert(page1 != page2);
    80203340:	fe843703          	ld	a4,-24(s0)
    80203344:	fe043783          	ld	a5,-32(s0)
    80203348:	40f707b3          	sub	a5,a4,a5
    8020334c:	00f037b3          	snez	a5,a5
    80203350:	0ff7f793          	zext.b	a5,a5
    80203354:	2781                	sext.w	a5,a5
    80203356:	853e                	mv	a0,a5
    80203358:	00000097          	auipc	ra,0x0
    8020335c:	ddc080e7          	jalr	-548(ra) # 80203134 <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    80203360:	fe843703          	ld	a4,-24(s0)
    80203364:	6785                	lui	a5,0x1
    80203366:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203368:	8ff9                	and	a5,a5,a4
    8020336a:	0017b793          	seqz	a5,a5
    8020336e:	0ff7f793          	zext.b	a5,a5
    80203372:	2781                	sext.w	a5,a5
    80203374:	853e                	mv	a0,a5
    80203376:	00000097          	auipc	ra,0x0
    8020337a:	dbe080e7          	jalr	-578(ra) # 80203134 <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    8020337e:	fe043703          	ld	a4,-32(s0)
    80203382:	6785                	lui	a5,0x1
    80203384:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203386:	8ff9                	and	a5,a5,a4
    80203388:	0017b793          	seqz	a5,a5
    8020338c:	0ff7f793          	zext.b	a5,a5
    80203390:	2781                	sext.w	a5,a5
    80203392:	853e                	mv	a0,a5
    80203394:	00000097          	auipc	ra,0x0
    80203398:	da0080e7          	jalr	-608(ra) # 80203134 <assert>
    printf("[PM TEST] 分配测试通过\n");
    8020339c:	00005517          	auipc	a0,0x5
    802033a0:	01450513          	addi	a0,a0,20 # 802083b0 <etext+0x13b0>
    802033a4:	ffffe097          	auipc	ra,0xffffe
    802033a8:	8de080e7          	jalr	-1826(ra) # 80200c82 <printf>
    printf("[PM TEST] 数据写入测试...\n");
    802033ac:	00005517          	auipc	a0,0x5
    802033b0:	02450513          	addi	a0,a0,36 # 802083d0 <etext+0x13d0>
    802033b4:	ffffe097          	auipc	ra,0xffffe
    802033b8:	8ce080e7          	jalr	-1842(ra) # 80200c82 <printf>
    *(int*)page1 = 0x12345678;
    802033bc:	fe843783          	ld	a5,-24(s0)
    802033c0:	12345737          	lui	a4,0x12345
    802033c4:	67870713          	addi	a4,a4,1656 # 12345678 <_entry-0x6deba988>
    802033c8:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    802033ca:	fe843783          	ld	a5,-24(s0)
    802033ce:	439c                	lw	a5,0(a5)
    802033d0:	873e                	mv	a4,a5
    802033d2:	123457b7          	lui	a5,0x12345
    802033d6:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6deba988>
    802033da:	40f707b3          	sub	a5,a4,a5
    802033de:	0017b793          	seqz	a5,a5
    802033e2:	0ff7f793          	zext.b	a5,a5
    802033e6:	2781                	sext.w	a5,a5
    802033e8:	853e                	mv	a0,a5
    802033ea:	00000097          	auipc	ra,0x0
    802033ee:	d4a080e7          	jalr	-694(ra) # 80203134 <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    802033f2:	00005517          	auipc	a0,0x5
    802033f6:	00650513          	addi	a0,a0,6 # 802083f8 <etext+0x13f8>
    802033fa:	ffffe097          	auipc	ra,0xffffe
    802033fe:	888080e7          	jalr	-1912(ra) # 80200c82 <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    80203402:	00005517          	auipc	a0,0x5
    80203406:	01e50513          	addi	a0,a0,30 # 80208420 <etext+0x1420>
    8020340a:	ffffe097          	auipc	ra,0xffffe
    8020340e:	878080e7          	jalr	-1928(ra) # 80200c82 <printf>
    free_page(page1);
    80203412:	fe843503          	ld	a0,-24(s0)
    80203416:	00000097          	auipc	ra,0x0
    8020341a:	e56080e7          	jalr	-426(ra) # 8020326c <free_page>
    void *page3 = alloc_page();
    8020341e:	00000097          	auipc	ra,0x0
    80203422:	de2080e7          	jalr	-542(ra) # 80203200 <alloc_page>
    80203426:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    8020342a:	fd843783          	ld	a5,-40(s0)
    8020342e:	00f037b3          	snez	a5,a5
    80203432:	0ff7f793          	zext.b	a5,a5
    80203436:	2781                	sext.w	a5,a5
    80203438:	853e                	mv	a0,a5
    8020343a:	00000097          	auipc	ra,0x0
    8020343e:	cfa080e7          	jalr	-774(ra) # 80203134 <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    80203442:	00005517          	auipc	a0,0x5
    80203446:	00e50513          	addi	a0,a0,14 # 80208450 <etext+0x1450>
    8020344a:	ffffe097          	auipc	ra,0xffffe
    8020344e:	838080e7          	jalr	-1992(ra) # 80200c82 <printf>
    free_page(page2);
    80203452:	fe043503          	ld	a0,-32(s0)
    80203456:	00000097          	auipc	ra,0x0
    8020345a:	e16080e7          	jalr	-490(ra) # 8020326c <free_page>
    free_page(page3);
    8020345e:	fd843503          	ld	a0,-40(s0)
    80203462:	00000097          	auipc	ra,0x0
    80203466:	e0a080e7          	jalr	-502(ra) # 8020326c <free_page>
    printf("[PM TEST] 所有物理内存管理测试通过\n");
    8020346a:	00005517          	auipc	a0,0x5
    8020346e:	01650513          	addi	a0,a0,22 # 80208480 <etext+0x1480>
    80203472:	ffffe097          	auipc	ra,0xffffe
    80203476:	810080e7          	jalr	-2032(ra) # 80200c82 <printf>
    8020347a:	0001                	nop
    8020347c:	70a2                	ld	ra,40(sp)
    8020347e:	7402                	ld	s0,32(sp)
    80203480:	6145                	addi	sp,sp,48
    80203482:	8082                	ret

0000000080203484 <sbi_set_time>:
#include "defs.h"

void sbi_set_time(uint64 time) {
    80203484:	1101                	addi	sp,sp,-32
    80203486:	ec22                	sd	s0,24(sp)
    80203488:	1000                	addi	s0,sp,32
    8020348a:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    8020348e:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    80203492:	4881                	li	a7,0
    asm volatile ("ecall"
    80203494:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    80203498:	0001                	nop
    8020349a:	6462                	ld	s0,24(sp)
    8020349c:	6105                	addi	sp,sp,32
    8020349e:	8082                	ret

00000000802034a0 <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    802034a0:	1101                	addi	sp,sp,-32
    802034a2:	ec22                	sd	s0,24(sp)
    802034a4:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    802034a6:	c01027f3          	rdtime	a5
    802034aa:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    802034ae:	fe843783          	ld	a5,-24(s0)
    802034b2:	853e                	mv	a0,a5
    802034b4:	6462                	ld	s0,24(sp)
    802034b6:	6105                	addi	sp,sp,32
    802034b8:	8082                	ret

00000000802034ba <timeintr>:
#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    802034ba:	1141                	addi	sp,sp,-16
    802034bc:	e422                	sd	s0,8(sp)
    802034be:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    802034c0:	00009797          	auipc	a5,0x9
    802034c4:	bf878793          	addi	a5,a5,-1032 # 8020c0b8 <interrupt_test_flag>
    802034c8:	639c                	ld	a5,0(a5)
    802034ca:	cb99                	beqz	a5,802034e0 <timeintr+0x26>
        (*interrupt_test_flag)++;
    802034cc:	00009797          	auipc	a5,0x9
    802034d0:	bec78793          	addi	a5,a5,-1044 # 8020c0b8 <interrupt_test_flag>
    802034d4:	639c                	ld	a5,0(a5)
    802034d6:	4398                	lw	a4,0(a5)
    802034d8:	2701                	sext.w	a4,a4
    802034da:	2705                	addiw	a4,a4,1
    802034dc:	2701                	sext.w	a4,a4
    802034de:	c398                	sw	a4,0(a5)
    802034e0:	0001                	nop
    802034e2:	6422                	ld	s0,8(sp)
    802034e4:	0141                	addi	sp,sp,16
    802034e6:	8082                	ret

00000000802034e8 <r_sie>:

    // 测试结束，清除标志
    interrupt_test_flag = 0;

    uint64 end_time = get_time();
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    802034e8:	1101                	addi	sp,sp,-32
    802034ea:	ec22                	sd	s0,24(sp)
    802034ec:	1000                	addi	s0,sp,32
           interrupt_count, end_time - start_time);
}
    802034ee:	104027f3          	csrr	a5,sie
    802034f2:	fef43423          	sd	a5,-24(s0)

    802034f6:	fe843783          	ld	a5,-24(s0)
// 修改测试异常处理函数
    802034fa:	853e                	mv	a0,a5
    802034fc:	6462                	ld	s0,24(sp)
    802034fe:	6105                	addi	sp,sp,32
    80203500:	8082                	ret

0000000080203502 <w_sie>:
void test_exception(void) {
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    80203502:	1101                	addi	sp,sp,-32
    80203504:	ec22                	sd	s0,24(sp)
    80203506:	1000                	addi	s0,sp,32
    80203508:	fea43423          	sd	a0,-24(s0)
    
    8020350c:	fe843783          	ld	a5,-24(s0)
    80203510:	10479073          	csrw	sie,a5
    // 1. 测试非法指令异常
    80203514:	0001                	nop
    80203516:	6462                	ld	s0,24(sp)
    80203518:	6105                	addi	sp,sp,32
    8020351a:	8082                	ret

000000008020351c <r_sstatus>:
    printf("1. 测试非法指令异常...\n");
    asm volatile (".word 0xffffffff");  // 非法RISC-V指令
    8020351c:	1101                	addi	sp,sp,-32
    8020351e:	ec22                	sd	s0,24(sp)
    80203520:	1000                	addi	s0,sp,32
    printf("✓ 非法指令异常处理成功\n\n");
    
    80203522:	100027f3          	csrr	a5,sstatus
    80203526:	fef43423          	sd	a5,-24(s0)
    // 2. 测试存储页故障
    8020352a:	fe843783          	ld	a5,-24(s0)
    printf("2. 测试存储页故障异常...\n");
    8020352e:	853e                	mv	a0,a5
    80203530:	6462                	ld	s0,24(sp)
    80203532:	6105                	addi	sp,sp,32
    80203534:	8082                	ret

0000000080203536 <w_sstatus>:
    volatile uint64 *invalid_ptr = 0;
    80203536:	1101                	addi	sp,sp,-32
    80203538:	ec22                	sd	s0,24(sp)
    8020353a:	1000                	addi	s0,sp,32
    8020353c:	fea43423          	sd	a0,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80203540:	fe843783          	ld	a5,-24(s0)
    80203544:	10079073          	csrw	sstatus,a5
        if (check_is_mapped(addr) == 0) {
    80203548:	0001                	nop
    8020354a:	6462                	ld	s0,24(sp)
    8020354c:	6105                	addi	sp,sp,32
    8020354e:	8082                	ret

0000000080203550 <w_sscratch>:
            invalid_ptr = (uint64*)addr;
    80203550:	1101                	addi	sp,sp,-32
    80203552:	ec22                	sd	s0,24(sp)
    80203554:	1000                	addi	s0,sp,32
    80203556:	fea43423          	sd	a0,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    8020355a:	fe843783          	ld	a5,-24(s0)
    8020355e:	14079073          	csrw	sscratch,a5
            break;
    80203562:	0001                	nop
    80203564:	6462                	ld	s0,24(sp)
    80203566:	6105                	addi	sp,sp,32
    80203568:	8082                	ret

000000008020356a <w_sepc>:
        }
    }
    8020356a:	1101                	addi	sp,sp,-32
    8020356c:	ec22                	sd	s0,24(sp)
    8020356e:	1000                	addi	s0,sp,32
    80203570:	fea43423          	sd	a0,-24(s0)
    
    80203574:	fe843783          	ld	a5,-24(s0)
    80203578:	14179073          	csrw	sepc,a5
    if (invalid_ptr != 0) {
    8020357c:	0001                	nop
    8020357e:	6462                	ld	s0,24(sp)
    80203580:	6105                	addi	sp,sp,32
    80203582:	8082                	ret

0000000080203584 <intr_off>:
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
        *invalid_ptr = 42;  // 触发存储页故障
        printf("✓ 存储页故障异常处理成功\n\n");
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    }
    80203584:	1141                	addi	sp,sp,-16
    80203586:	e406                	sd	ra,8(sp)
    80203588:	e022                	sd	s0,0(sp)
    8020358a:	0800                	addi	s0,sp,16
    
    8020358c:	00000097          	auipc	ra,0x0
    80203590:	f90080e7          	jalr	-112(ra) # 8020351c <r_sstatus>
    80203594:	87aa                	mv	a5,a0
    80203596:	9bf5                	andi	a5,a5,-3
    80203598:	853e                	mv	a0,a5
    8020359a:	00000097          	auipc	ra,0x0
    8020359e:	f9c080e7          	jalr	-100(ra) # 80203536 <w_sstatus>
    // 3. 测试加载页故障
    802035a2:	0001                	nop
    802035a4:	60a2                	ld	ra,8(sp)
    802035a6:	6402                	ld	s0,0(sp)
    802035a8:	0141                	addi	sp,sp,16
    802035aa:	8082                	ret

00000000802035ac <w_stvec>:
    printf("3. 测试加载页故障异常...\n");
    invalid_ptr = 0;
    802035ac:	1101                	addi	sp,sp,-32
    802035ae:	ec22                	sd	s0,24(sp)
    802035b0:	1000                	addi	s0,sp,32
    802035b2:	fea43423          	sd	a0,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802035b6:	fe843783          	ld	a5,-24(s0)
    802035ba:	10579073          	csrw	stvec,a5
        if (check_is_mapped(addr) == 0) {
    802035be:	0001                	nop
    802035c0:	6462                	ld	s0,24(sp)
    802035c2:	6105                	addi	sp,sp,32
    802035c4:	8082                	ret

00000000802035c6 <r_scause>:
            break;
        }
    }
    
    if (invalid_ptr != 0) {
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    802035c6:	1101                	addi	sp,sp,-32
    802035c8:	ec22                	sd	s0,24(sp)
    802035ca:	1000                	addi	s0,sp,32
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    802035cc:	142027f3          	csrr	a5,scause
    802035d0:	fef43423          	sd	a5,-24(s0)
        printf("✓ 加载页故障异常处理成功\n\n");
    802035d4:	fe843783          	ld	a5,-24(s0)
    } else {
    802035d8:	853e                	mv	a0,a5
    802035da:	6462                	ld	s0,24(sp)
    802035dc:	6105                	addi	sp,sp,32
    802035de:	8082                	ret

00000000802035e0 <r_sepc>:
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    }
    802035e0:	1101                	addi	sp,sp,-32
    802035e2:	ec22                	sd	s0,24(sp)
    802035e4:	1000                	addi	s0,sp,32
    
    // 4. 测试存储地址未对齐异常
    802035e6:	141027f3          	csrr	a5,sepc
    802035ea:	fef43423          	sd	a5,-24(s0)
    printf("4. 测试存储地址未对齐异常...\n");
    802035ee:	fe843783          	ld	a5,-24(s0)
    uint64 aligned_addr = (uint64)alloc_page();
    802035f2:	853e                	mv	a0,a5
    802035f4:	6462                	ld	s0,24(sp)
    802035f6:	6105                	addi	sp,sp,32
    802035f8:	8082                	ret

00000000802035fa <r_stval>:
    if (aligned_addr != 0) {
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    802035fa:	1101                	addi	sp,sp,-32
    802035fc:	ec22                	sd	s0,24(sp)
    802035fe:	1000                	addi	s0,sp,32
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
        
    80203600:	143027f3          	csrr	a5,stval
    80203604:	fef43423          	sd	a5,-24(s0)
        // 使用内联汇编进行未对齐访问，因为编译器可能会自动对齐
    80203608:	fe843783          	ld	a5,-24(s0)
        asm volatile (
    8020360c:	853e                	mv	a0,a5
    8020360e:	6462                	ld	s0,24(sp)
    80203610:	6105                	addi	sp,sp,32
    80203612:	8082                	ret

0000000080203614 <save_exception_info>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    80203614:	7139                	addi	sp,sp,-64
    80203616:	fc22                	sd	s0,56(sp)
    80203618:	0080                	addi	s0,sp,64
    8020361a:	fea43423          	sd	a0,-24(s0)
    8020361e:	feb43023          	sd	a1,-32(s0)
    80203622:	fcc43c23          	sd	a2,-40(s0)
    80203626:	fcd43823          	sd	a3,-48(s0)
    8020362a:	fce43423          	sd	a4,-56(s0)
    tf->epc = sepc;
    8020362e:	fe843783          	ld	a5,-24(s0)
    80203632:	fe043703          	ld	a4,-32(s0)
    80203636:	f398                	sd	a4,32(a5)
}
    80203638:	0001                	nop
    8020363a:	7462                	ld	s0,56(sp)
    8020363c:	6121                	addi	sp,sp,64
    8020363e:	8082                	ret

0000000080203640 <get_sepc>:
static inline uint64 get_sepc(struct trapframe *tf) {
    80203640:	1101                	addi	sp,sp,-32
    80203642:	ec22                	sd	s0,24(sp)
    80203644:	1000                	addi	s0,sp,32
    80203646:	fea43423          	sd	a0,-24(s0)
    return tf->epc;
    8020364a:	fe843783          	ld	a5,-24(s0)
    8020364e:	739c                	ld	a5,32(a5)
}
    80203650:	853e                	mv	a0,a5
    80203652:	6462                	ld	s0,24(sp)
    80203654:	6105                	addi	sp,sp,32
    80203656:	8082                	ret

0000000080203658 <set_sepc>:
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    80203658:	1101                	addi	sp,sp,-32
    8020365a:	ec22                	sd	s0,24(sp)
    8020365c:	1000                	addi	s0,sp,32
    8020365e:	fea43423          	sd	a0,-24(s0)
    80203662:	feb43023          	sd	a1,-32(s0)
    tf->epc = sepc;
    80203666:	fe843783          	ld	a5,-24(s0)
    8020366a:	fe043703          	ld	a4,-32(s0)
    8020366e:	f398                	sd	a4,32(a5)
}
    80203670:	0001                	nop
    80203672:	6462                	ld	s0,24(sp)
    80203674:	6105                	addi	sp,sp,32
    80203676:	8082                	ret

0000000080203678 <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    80203678:	1101                	addi	sp,sp,-32
    8020367a:	ec22                	sd	s0,24(sp)
    8020367c:	1000                	addi	s0,sp,32
    8020367e:	87aa                	mv	a5,a0
    80203680:	feb43023          	sd	a1,-32(s0)
    80203684:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    80203688:	fec42783          	lw	a5,-20(s0)
    8020368c:	2781                	sext.w	a5,a5
    8020368e:	0207c563          	bltz	a5,802036b8 <register_interrupt+0x40>
    80203692:	fec42783          	lw	a5,-20(s0)
    80203696:	0007871b          	sext.w	a4,a5
    8020369a:	03f00793          	li	a5,63
    8020369e:	00e7cd63          	blt	a5,a4,802036b8 <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    802036a2:	00009717          	auipc	a4,0x9
    802036a6:	bd670713          	addi	a4,a4,-1066 # 8020c278 <interrupt_vector>
    802036aa:	fec42783          	lw	a5,-20(s0)
    802036ae:	078e                	slli	a5,a5,0x3
    802036b0:	97ba                	add	a5,a5,a4
    802036b2:	fe043703          	ld	a4,-32(s0)
    802036b6:	e398                	sd	a4,0(a5)
}
    802036b8:	0001                	nop
    802036ba:	6462                	ld	s0,24(sp)
    802036bc:	6105                	addi	sp,sp,32
    802036be:	8082                	ret

00000000802036c0 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    802036c0:	1101                	addi	sp,sp,-32
    802036c2:	ec22                	sd	s0,24(sp)
    802036c4:	1000                	addi	s0,sp,32
    802036c6:	87aa                	mv	a5,a0
    802036c8:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    802036cc:	fec42783          	lw	a5,-20(s0)
    802036d0:	2781                	sext.w	a5,a5
    802036d2:	0207c463          	bltz	a5,802036fa <unregister_interrupt+0x3a>
    802036d6:	fec42783          	lw	a5,-20(s0)
    802036da:	0007871b          	sext.w	a4,a5
    802036de:	03f00793          	li	a5,63
    802036e2:	00e7cc63          	blt	a5,a4,802036fa <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    802036e6:	00009717          	auipc	a4,0x9
    802036ea:	b9270713          	addi	a4,a4,-1134 # 8020c278 <interrupt_vector>
    802036ee:	fec42783          	lw	a5,-20(s0)
    802036f2:	078e                	slli	a5,a5,0x3
    802036f4:	97ba                	add	a5,a5,a4
    802036f6:	0007b023          	sd	zero,0(a5)
}
    802036fa:	0001                	nop
    802036fc:	6462                	ld	s0,24(sp)
    802036fe:	6105                	addi	sp,sp,32
    80203700:	8082                	ret

0000000080203702 <enable_interrupts>:
void enable_interrupts(int irq) {
    80203702:	1101                	addi	sp,sp,-32
    80203704:	ec06                	sd	ra,24(sp)
    80203706:	e822                	sd	s0,16(sp)
    80203708:	1000                	addi	s0,sp,32
    8020370a:	87aa                	mv	a5,a0
    8020370c:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    80203710:	fec42783          	lw	a5,-20(s0)
    80203714:	853e                	mv	a0,a5
    80203716:	00001097          	auipc	ra,0x1
    8020371a:	ffc080e7          	jalr	-4(ra) # 80204712 <plic_enable>
}
    8020371e:	0001                	nop
    80203720:	60e2                	ld	ra,24(sp)
    80203722:	6442                	ld	s0,16(sp)
    80203724:	6105                	addi	sp,sp,32
    80203726:	8082                	ret

0000000080203728 <disable_interrupts>:
void disable_interrupts(int irq) {
    80203728:	1101                	addi	sp,sp,-32
    8020372a:	ec06                	sd	ra,24(sp)
    8020372c:	e822                	sd	s0,16(sp)
    8020372e:	1000                	addi	s0,sp,32
    80203730:	87aa                	mv	a5,a0
    80203732:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    80203736:	fec42783          	lw	a5,-20(s0)
    8020373a:	853e                	mv	a0,a5
    8020373c:	00001097          	auipc	ra,0x1
    80203740:	02e080e7          	jalr	46(ra) # 8020476a <plic_disable>
}
    80203744:	0001                	nop
    80203746:	60e2                	ld	ra,24(sp)
    80203748:	6442                	ld	s0,16(sp)
    8020374a:	6105                	addi	sp,sp,32
    8020374c:	8082                	ret

000000008020374e <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    8020374e:	1101                	addi	sp,sp,-32
    80203750:	ec06                	sd	ra,24(sp)
    80203752:	e822                	sd	s0,16(sp)
    80203754:	1000                	addi	s0,sp,32
    80203756:	87aa                	mv	a5,a0
    80203758:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    8020375c:	fec42783          	lw	a5,-20(s0)
    80203760:	2781                	sext.w	a5,a5
    80203762:	0207ce63          	bltz	a5,8020379e <interrupt_dispatch+0x50>
    80203766:	fec42783          	lw	a5,-20(s0)
    8020376a:	0007871b          	sext.w	a4,a5
    8020376e:	03f00793          	li	a5,63
    80203772:	02e7c663          	blt	a5,a4,8020379e <interrupt_dispatch+0x50>
    80203776:	00009717          	auipc	a4,0x9
    8020377a:	b0270713          	addi	a4,a4,-1278 # 8020c278 <interrupt_vector>
    8020377e:	fec42783          	lw	a5,-20(s0)
    80203782:	078e                	slli	a5,a5,0x3
    80203784:	97ba                	add	a5,a5,a4
    80203786:	639c                	ld	a5,0(a5)
    80203788:	cb99                	beqz	a5,8020379e <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    8020378a:	00009717          	auipc	a4,0x9
    8020378e:	aee70713          	addi	a4,a4,-1298 # 8020c278 <interrupt_vector>
    80203792:	fec42783          	lw	a5,-20(s0)
    80203796:	078e                	slli	a5,a5,0x3
    80203798:	97ba                	add	a5,a5,a4
    8020379a:	639c                	ld	a5,0(a5)
    8020379c:	9782                	jalr	a5
}
    8020379e:	0001                	nop
    802037a0:	60e2                	ld	ra,24(sp)
    802037a2:	6442                	ld	s0,16(sp)
    802037a4:	6105                	addi	sp,sp,32
    802037a6:	8082                	ret

00000000802037a8 <handle_external_interrupt>:
void handle_external_interrupt(void) {
    802037a8:	1101                	addi	sp,sp,-32
    802037aa:	ec06                	sd	ra,24(sp)
    802037ac:	e822                	sd	s0,16(sp)
    802037ae:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    802037b0:	00001097          	auipc	ra,0x1
    802037b4:	018080e7          	jalr	24(ra) # 802047c8 <plic_claim>
    802037b8:	87aa                	mv	a5,a0
    802037ba:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    802037be:	fec42783          	lw	a5,-20(s0)
    802037c2:	2781                	sext.w	a5,a5
    802037c4:	eb91                	bnez	a5,802037d8 <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    802037c6:	00005517          	auipc	a0,0x5
    802037ca:	cea50513          	addi	a0,a0,-790 # 802084b0 <etext+0x14b0>
    802037ce:	ffffd097          	auipc	ra,0xffffd
    802037d2:	4b4080e7          	jalr	1204(ra) # 80200c82 <printf>
        return;
    802037d6:	a839                	j	802037f4 <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    802037d8:	fec42783          	lw	a5,-20(s0)
    802037dc:	853e                	mv	a0,a5
    802037de:	00000097          	auipc	ra,0x0
    802037e2:	f70080e7          	jalr	-144(ra) # 8020374e <interrupt_dispatch>
    plic_complete(irq);
    802037e6:	fec42783          	lw	a5,-20(s0)
    802037ea:	853e                	mv	a0,a5
    802037ec:	00001097          	auipc	ra,0x1
    802037f0:	004080e7          	jalr	4(ra) # 802047f0 <plic_complete>
}
    802037f4:	60e2                	ld	ra,24(sp)
    802037f6:	6442                	ld	s0,16(sp)
    802037f8:	6105                	addi	sp,sp,32
    802037fa:	8082                	ret

00000000802037fc <trap_init>:
void trap_init(void) {
    802037fc:	1101                	addi	sp,sp,-32
    802037fe:	ec06                	sd	ra,24(sp)
    80203800:	e822                	sd	s0,16(sp)
    80203802:	1000                	addi	s0,sp,32
	intr_off();
    80203804:	00000097          	auipc	ra,0x0
    80203808:	d80080e7          	jalr	-640(ra) # 80203584 <intr_off>
	printf("trap_init...\n");
    8020380c:	00005517          	auipc	a0,0x5
    80203810:	cc450513          	addi	a0,a0,-828 # 802084d0 <etext+0x14d0>
    80203814:	ffffd097          	auipc	ra,0xffffd
    80203818:	46e080e7          	jalr	1134(ra) # 80200c82 <printf>
	w_stvec((uint64)kernelvec);
    8020381c:	00001797          	auipc	a5,0x1
    80203820:	00478793          	addi	a5,a5,4 # 80204820 <kernelvec>
    80203824:	853e                	mv	a0,a5
    80203826:	00000097          	auipc	ra,0x0
    8020382a:	d86080e7          	jalr	-634(ra) # 802035ac <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    8020382e:	fe042623          	sw	zero,-20(s0)
    80203832:	a005                	j	80203852 <trap_init+0x56>
		interrupt_vector[i] = 0;
    80203834:	00009717          	auipc	a4,0x9
    80203838:	a4470713          	addi	a4,a4,-1468 # 8020c278 <interrupt_vector>
    8020383c:	fec42783          	lw	a5,-20(s0)
    80203840:	078e                	slli	a5,a5,0x3
    80203842:	97ba                	add	a5,a5,a4
    80203844:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    80203848:	fec42783          	lw	a5,-20(s0)
    8020384c:	2785                	addiw	a5,a5,1
    8020384e:	fef42623          	sw	a5,-20(s0)
    80203852:	fec42783          	lw	a5,-20(s0)
    80203856:	0007871b          	sext.w	a4,a5
    8020385a:	03f00793          	li	a5,63
    8020385e:	fce7dbe3          	bge	a5,a4,80203834 <trap_init+0x38>
	plic_init();
    80203862:	00001097          	auipc	ra,0x1
    80203866:	e12080e7          	jalr	-494(ra) # 80204674 <plic_init>
    uint64 sie = r_sie();
    8020386a:	00000097          	auipc	ra,0x0
    8020386e:	c7e080e7          	jalr	-898(ra) # 802034e8 <r_sie>
    80203872:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    80203876:	fe043783          	ld	a5,-32(s0)
    8020387a:	2207e793          	ori	a5,a5,544
    8020387e:	853e                	mv	a0,a5
    80203880:	00000097          	auipc	ra,0x0
    80203884:	c82080e7          	jalr	-894(ra) # 80203502 <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80203888:	00000097          	auipc	ra,0x0
    8020388c:	c18080e7          	jalr	-1000(ra) # 802034a0 <sbi_get_time>
    80203890:	872a                	mv	a4,a0
    80203892:	000f47b7          	lui	a5,0xf4
    80203896:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    8020389a:	97ba                	add	a5,a5,a4
    8020389c:	853e                	mv	a0,a5
    8020389e:	00000097          	auipc	ra,0x0
    802038a2:	be6080e7          	jalr	-1050(ra) # 80203484 <sbi_set_time>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    802038a6:	00000597          	auipc	a1,0x0
    802038aa:	71c58593          	addi	a1,a1,1820 # 80203fc2 <handle_store_page_fault>
    802038ae:	00005517          	auipc	a0,0x5
    802038b2:	c3250513          	addi	a0,a0,-974 # 802084e0 <etext+0x14e0>
    802038b6:	ffffd097          	auipc	ra,0xffffd
    802038ba:	3cc080e7          	jalr	972(ra) # 80200c82 <printf>
	printf("trap_init complete.\n");
    802038be:	00005517          	auipc	a0,0x5
    802038c2:	c5a50513          	addi	a0,a0,-934 # 80208518 <etext+0x1518>
    802038c6:	ffffd097          	auipc	ra,0xffffd
    802038ca:	3bc080e7          	jalr	956(ra) # 80200c82 <printf>
}
    802038ce:	0001                	nop
    802038d0:	60e2                	ld	ra,24(sp)
    802038d2:	6442                	ld	s0,16(sp)
    802038d4:	6105                	addi	sp,sp,32
    802038d6:	8082                	ret

00000000802038d8 <kerneltrap>:
void kerneltrap(void) {
    802038d8:	7149                	addi	sp,sp,-368
    802038da:	f686                	sd	ra,360(sp)
    802038dc:	f2a2                	sd	s0,352(sp)
    802038de:	1a80                	addi	s0,sp,368
    uint64 sstatus = r_sstatus();
    802038e0:	00000097          	auipc	ra,0x0
    802038e4:	c3c080e7          	jalr	-964(ra) # 8020351c <r_sstatus>
    802038e8:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    802038ec:	00000097          	auipc	ra,0x0
    802038f0:	cda080e7          	jalr	-806(ra) # 802035c6 <r_scause>
    802038f4:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    802038f8:	00000097          	auipc	ra,0x0
    802038fc:	ce8080e7          	jalr	-792(ra) # 802035e0 <r_sepc>
    80203900:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    80203904:	00000097          	auipc	ra,0x0
    80203908:	cf6080e7          	jalr	-778(ra) # 802035fa <r_stval>
    8020390c:	fca43823          	sd	a0,-48(s0)
    if(scause & 0x8000000000000000) {
    80203910:	fd843783          	ld	a5,-40(s0)
    80203914:	0607d663          	bgez	a5,80203980 <kerneltrap+0xa8>
        if((scause & 0xff) == 5) {
    80203918:	fd843783          	ld	a5,-40(s0)
    8020391c:	0ff7f713          	zext.b	a4,a5
    80203920:	4795                	li	a5,5
    80203922:	02f71663          	bne	a4,a5,8020394e <kerneltrap+0x76>
            timeintr();
    80203926:	00000097          	auipc	ra,0x0
    8020392a:	b94080e7          	jalr	-1132(ra) # 802034ba <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    8020392e:	00000097          	auipc	ra,0x0
    80203932:	b72080e7          	jalr	-1166(ra) # 802034a0 <sbi_get_time>
    80203936:	872a                	mv	a4,a0
    80203938:	000f47b7          	lui	a5,0xf4
    8020393c:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    80203940:	97ba                	add	a5,a5,a4
    80203942:	853e                	mv	a0,a5
    80203944:	00000097          	auipc	ra,0x0
    80203948:	b40080e7          	jalr	-1216(ra) # 80203484 <sbi_set_time>
    8020394c:	a855                	j	80203a00 <kerneltrap+0x128>
        } else if((scause & 0xff) == 9) {
    8020394e:	fd843783          	ld	a5,-40(s0)
    80203952:	0ff7f713          	zext.b	a4,a5
    80203956:	47a5                	li	a5,9
    80203958:	00f71763          	bne	a4,a5,80203966 <kerneltrap+0x8e>
            handle_external_interrupt();
    8020395c:	00000097          	auipc	ra,0x0
    80203960:	e4c080e7          	jalr	-436(ra) # 802037a8 <handle_external_interrupt>
    80203964:	a871                	j	80203a00 <kerneltrap+0x128>
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    80203966:	fe843603          	ld	a2,-24(s0)
    8020396a:	fd843583          	ld	a1,-40(s0)
    8020396e:	00005517          	auipc	a0,0x5
    80203972:	bc250513          	addi	a0,a0,-1086 # 80208530 <etext+0x1530>
    80203976:	ffffd097          	auipc	ra,0xffffd
    8020397a:	30c080e7          	jalr	780(ra) # 80200c82 <printf>
    8020397e:	a049                	j	80203a00 <kerneltrap+0x128>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    80203980:	fd043683          	ld	a3,-48(s0)
    80203984:	fe843603          	ld	a2,-24(s0)
    80203988:	fd843583          	ld	a1,-40(s0)
    8020398c:	00005517          	auipc	a0,0x5
    80203990:	bdc50513          	addi	a0,a0,-1060 # 80208568 <etext+0x1568>
    80203994:	ffffd097          	auipc	ra,0xffffd
    80203998:	2ee080e7          	jalr	750(ra) # 80200c82 <printf>
        save_exception_info(&tf, sepc, sstatus, scause, stval);
    8020399c:	eb840793          	addi	a5,s0,-328
    802039a0:	fd043703          	ld	a4,-48(s0)
    802039a4:	fd843683          	ld	a3,-40(s0)
    802039a8:	fe043603          	ld	a2,-32(s0)
    802039ac:	fe843583          	ld	a1,-24(s0)
    802039b0:	853e                	mv	a0,a5
    802039b2:	00000097          	auipc	ra,0x0
    802039b6:	c62080e7          	jalr	-926(ra) # 80203614 <save_exception_info>
        info.sepc = sepc;
    802039ba:	fe843783          	ld	a5,-24(s0)
    802039be:	e8f43c23          	sd	a5,-360(s0)
        info.sstatus = sstatus;
    802039c2:	fe043783          	ld	a5,-32(s0)
    802039c6:	eaf43023          	sd	a5,-352(s0)
        info.scause = scause;
    802039ca:	fd843783          	ld	a5,-40(s0)
    802039ce:	eaf43423          	sd	a5,-344(s0)
        info.stval = stval;
    802039d2:	fd043783          	ld	a5,-48(s0)
    802039d6:	eaf43823          	sd	a5,-336(s0)
        handle_exception(&tf, &info);
    802039da:	e9840713          	addi	a4,s0,-360
    802039de:	eb840793          	addi	a5,s0,-328
    802039e2:	85ba                	mv	a1,a4
    802039e4:	853e                	mv	a0,a5
    802039e6:	00000097          	auipc	ra,0x0
    802039ea:	03c080e7          	jalr	60(ra) # 80203a22 <handle_exception>
        sepc = get_sepc(&tf);
    802039ee:	eb840793          	addi	a5,s0,-328
    802039f2:	853e                	mv	a0,a5
    802039f4:	00000097          	auipc	ra,0x0
    802039f8:	c4c080e7          	jalr	-948(ra) # 80203640 <get_sepc>
    802039fc:	fea43423          	sd	a0,-24(s0)
    w_sepc(sepc);
    80203a00:	fe843503          	ld	a0,-24(s0)
    80203a04:	00000097          	auipc	ra,0x0
    80203a08:	b66080e7          	jalr	-1178(ra) # 8020356a <w_sepc>
    w_sstatus(sstatus);
    80203a0c:	fe043503          	ld	a0,-32(s0)
    80203a10:	00000097          	auipc	ra,0x0
    80203a14:	b26080e7          	jalr	-1242(ra) # 80203536 <w_sstatus>
}
    80203a18:	0001                	nop
    80203a1a:	70b6                	ld	ra,360(sp)
    80203a1c:	7416                	ld	s0,352(sp)
    80203a1e:	6175                	addi	sp,sp,368
    80203a20:	8082                	ret

0000000080203a22 <handle_exception>:
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    80203a22:	7179                	addi	sp,sp,-48
    80203a24:	f406                	sd	ra,40(sp)
    80203a26:	f022                	sd	s0,32(sp)
    80203a28:	1800                	addi	s0,sp,48
    80203a2a:	fca43c23          	sd	a0,-40(s0)
    80203a2e:	fcb43823          	sd	a1,-48(s0)
    uint64 cause = info->scause;  // 使用info中的字段
    80203a32:	fd043783          	ld	a5,-48(s0)
    80203a36:	6b9c                	ld	a5,16(a5)
    80203a38:	fef43423          	sd	a5,-24(s0)
    switch (cause) {
    80203a3c:	fe843703          	ld	a4,-24(s0)
    80203a40:	47bd                	li	a5,15
    80203a42:	26e7ef63          	bltu	a5,a4,80203cc0 <handle_exception+0x29e>
    80203a46:	fe843783          	ld	a5,-24(s0)
    80203a4a:	00279713          	slli	a4,a5,0x2
    80203a4e:	00005797          	auipc	a5,0x5
    80203a52:	cd678793          	addi	a5,a5,-810 # 80208724 <etext+0x1724>
    80203a56:	97ba                	add	a5,a5,a4
    80203a58:	439c                	lw	a5,0(a5)
    80203a5a:	0007871b          	sext.w	a4,a5
    80203a5e:	00005797          	auipc	a5,0x5
    80203a62:	cc678793          	addi	a5,a5,-826 # 80208724 <etext+0x1724>
    80203a66:	97ba                	add	a5,a5,a4
    80203a68:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80203a6a:	fd043783          	ld	a5,-48(s0)
    80203a6e:	6f9c                	ld	a5,24(a5)
    80203a70:	85be                	mv	a1,a5
    80203a72:	00005517          	auipc	a0,0x5
    80203a76:	b2650513          	addi	a0,a0,-1242 # 80208598 <etext+0x1598>
    80203a7a:	ffffd097          	auipc	ra,0xffffd
    80203a7e:	208080e7          	jalr	520(ra) # 80200c82 <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203a82:	fd043783          	ld	a5,-48(s0)
    80203a86:	639c                	ld	a5,0(a5)
    80203a88:	0791                	addi	a5,a5,4
    80203a8a:	85be                	mv	a1,a5
    80203a8c:	fd843503          	ld	a0,-40(s0)
    80203a90:	00000097          	auipc	ra,0x0
    80203a94:	bc8080e7          	jalr	-1080(ra) # 80203658 <set_sepc>
            break;
    80203a98:	a495                	j	80203cfc <handle_exception+0x2da>
            printf("Instruction access fault: 0x%lx\n", info->stval);
    80203a9a:	fd043783          	ld	a5,-48(s0)
    80203a9e:	6f9c                	ld	a5,24(a5)
    80203aa0:	85be                	mv	a1,a5
    80203aa2:	00005517          	auipc	a0,0x5
    80203aa6:	b1e50513          	addi	a0,a0,-1250 # 802085c0 <etext+0x15c0>
    80203aaa:	ffffd097          	auipc	ra,0xffffd
    80203aae:	1d8080e7          	jalr	472(ra) # 80200c82 <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203ab2:	fd043783          	ld	a5,-48(s0)
    80203ab6:	639c                	ld	a5,0(a5)
    80203ab8:	0791                	addi	a5,a5,4
    80203aba:	85be                	mv	a1,a5
    80203abc:	fd843503          	ld	a0,-40(s0)
    80203ac0:	00000097          	auipc	ra,0x0
    80203ac4:	b98080e7          	jalr	-1128(ra) # 80203658 <set_sepc>
            break;
    80203ac8:	ac15                	j	80203cfc <handle_exception+0x2da>
            printf("Illegal instruction at 0x%lx: 0x%lx\n", info->sepc, info->stval);
    80203aca:	fd043783          	ld	a5,-48(s0)
    80203ace:	6398                	ld	a4,0(a5)
    80203ad0:	fd043783          	ld	a5,-48(s0)
    80203ad4:	6f9c                	ld	a5,24(a5)
    80203ad6:	863e                	mv	a2,a5
    80203ad8:	85ba                	mv	a1,a4
    80203ada:	00005517          	auipc	a0,0x5
    80203ade:	b0e50513          	addi	a0,a0,-1266 # 802085e8 <etext+0x15e8>
    80203ae2:	ffffd097          	auipc	ra,0xffffd
    80203ae6:	1a0080e7          	jalr	416(ra) # 80200c82 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203aea:	fd043783          	ld	a5,-48(s0)
    80203aee:	639c                	ld	a5,0(a5)
    80203af0:	0791                	addi	a5,a5,4
    80203af2:	85be                	mv	a1,a5
    80203af4:	fd843503          	ld	a0,-40(s0)
    80203af8:	00000097          	auipc	ra,0x0
    80203afc:	b60080e7          	jalr	-1184(ra) # 80203658 <set_sepc>
            break;
    80203b00:	aaf5                	j	80203cfc <handle_exception+0x2da>
            printf("Breakpoint at 0x%lx\n", info->sepc);
    80203b02:	fd043783          	ld	a5,-48(s0)
    80203b06:	639c                	ld	a5,0(a5)
    80203b08:	85be                	mv	a1,a5
    80203b0a:	00005517          	auipc	a0,0x5
    80203b0e:	b0650513          	addi	a0,a0,-1274 # 80208610 <etext+0x1610>
    80203b12:	ffffd097          	auipc	ra,0xffffd
    80203b16:	170080e7          	jalr	368(ra) # 80200c82 <printf>
            set_sepc(tf, info->sepc + 4);
    80203b1a:	fd043783          	ld	a5,-48(s0)
    80203b1e:	639c                	ld	a5,0(a5)
    80203b20:	0791                	addi	a5,a5,4
    80203b22:	85be                	mv	a1,a5
    80203b24:	fd843503          	ld	a0,-40(s0)
    80203b28:	00000097          	auipc	ra,0x0
    80203b2c:	b30080e7          	jalr	-1232(ra) # 80203658 <set_sepc>
            break;
    80203b30:	a2f1                	j	80203cfc <handle_exception+0x2da>
            printf("Load address misaligned: 0x%lx\n", info->stval);
    80203b32:	fd043783          	ld	a5,-48(s0)
    80203b36:	6f9c                	ld	a5,24(a5)
    80203b38:	85be                	mv	a1,a5
    80203b3a:	00005517          	auipc	a0,0x5
    80203b3e:	aee50513          	addi	a0,a0,-1298 # 80208628 <etext+0x1628>
    80203b42:	ffffd097          	auipc	ra,0xffffd
    80203b46:	140080e7          	jalr	320(ra) # 80200c82 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203b4a:	fd043783          	ld	a5,-48(s0)
    80203b4e:	639c                	ld	a5,0(a5)
    80203b50:	0791                	addi	a5,a5,4
    80203b52:	85be                	mv	a1,a5
    80203b54:	fd843503          	ld	a0,-40(s0)
    80203b58:	00000097          	auipc	ra,0x0
    80203b5c:	b00080e7          	jalr	-1280(ra) # 80203658 <set_sepc>
            break;
    80203b60:	aa71                	j	80203cfc <handle_exception+0x2da>
			printf("Load access fault: 0x%lx\n", info->stval);
    80203b62:	fd043783          	ld	a5,-48(s0)
    80203b66:	6f9c                	ld	a5,24(a5)
    80203b68:	85be                	mv	a1,a5
    80203b6a:	00005517          	auipc	a0,0x5
    80203b6e:	ade50513          	addi	a0,a0,-1314 # 80208648 <etext+0x1648>
    80203b72:	ffffd097          	auipc	ra,0xffffd
    80203b76:	110080e7          	jalr	272(ra) # 80200c82 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
    80203b7a:	fd043783          	ld	a5,-48(s0)
    80203b7e:	6f9c                	ld	a5,24(a5)
    80203b80:	853e                	mv	a0,a5
    80203b82:	fffff097          	auipc	ra,0xfffff
    80203b86:	436080e7          	jalr	1078(ra) # 80202fb8 <check_is_mapped>
    80203b8a:	87aa                	mv	a5,a0
    80203b8c:	cf89                	beqz	a5,80203ba6 <handle_exception+0x184>
    80203b8e:	fd043783          	ld	a5,-48(s0)
    80203b92:	6f9c                	ld	a5,24(a5)
    80203b94:	4589                	li	a1,2
    80203b96:	853e                	mv	a0,a5
    80203b98:	fffff097          	auipc	ra,0xfffff
    80203b9c:	dc4080e7          	jalr	-572(ra) # 8020295c <handle_page_fault>
    80203ba0:	87aa                	mv	a5,a0
    80203ba2:	14079a63          	bnez	a5,80203cf6 <handle_exception+0x2d4>
			set_sepc(tf, info->sepc + 4);
    80203ba6:	fd043783          	ld	a5,-48(s0)
    80203baa:	639c                	ld	a5,0(a5)
    80203bac:	0791                	addi	a5,a5,4
    80203bae:	85be                	mv	a1,a5
    80203bb0:	fd843503          	ld	a0,-40(s0)
    80203bb4:	00000097          	auipc	ra,0x0
    80203bb8:	aa4080e7          	jalr	-1372(ra) # 80203658 <set_sepc>
			break;
    80203bbc:	a281                	j	80203cfc <handle_exception+0x2da>
            printf("Store address misaligned: 0x%lx\n", info->stval);
    80203bbe:	fd043783          	ld	a5,-48(s0)
    80203bc2:	6f9c                	ld	a5,24(a5)
    80203bc4:	85be                	mv	a1,a5
    80203bc6:	00005517          	auipc	a0,0x5
    80203bca:	aa250513          	addi	a0,a0,-1374 # 80208668 <etext+0x1668>
    80203bce:	ffffd097          	auipc	ra,0xffffd
    80203bd2:	0b4080e7          	jalr	180(ra) # 80200c82 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203bd6:	fd043783          	ld	a5,-48(s0)
    80203bda:	639c                	ld	a5,0(a5)
    80203bdc:	0791                	addi	a5,a5,4
    80203bde:	85be                	mv	a1,a5
    80203be0:	fd843503          	ld	a0,-40(s0)
    80203be4:	00000097          	auipc	ra,0x0
    80203be8:	a74080e7          	jalr	-1420(ra) # 80203658 <set_sepc>
            break;
    80203bec:	aa01                	j	80203cfc <handle_exception+0x2da>
			printf("Store access fault: 0x%lx\n", info->stval);
    80203bee:	fd043783          	ld	a5,-48(s0)
    80203bf2:	6f9c                	ld	a5,24(a5)
    80203bf4:	85be                	mv	a1,a5
    80203bf6:	00005517          	auipc	a0,0x5
    80203bfa:	a9a50513          	addi	a0,a0,-1382 # 80208690 <etext+0x1690>
    80203bfe:	ffffd097          	auipc	ra,0xffffd
    80203c02:	084080e7          	jalr	132(ra) # 80200c82 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
    80203c06:	fd043783          	ld	a5,-48(s0)
    80203c0a:	6f9c                	ld	a5,24(a5)
    80203c0c:	853e                	mv	a0,a5
    80203c0e:	fffff097          	auipc	ra,0xfffff
    80203c12:	3aa080e7          	jalr	938(ra) # 80202fb8 <check_is_mapped>
    80203c16:	87aa                	mv	a5,a0
    80203c18:	cf81                	beqz	a5,80203c30 <handle_exception+0x20e>
    80203c1a:	fd043783          	ld	a5,-48(s0)
    80203c1e:	6f9c                	ld	a5,24(a5)
    80203c20:	458d                	li	a1,3
    80203c22:	853e                	mv	a0,a5
    80203c24:	fffff097          	auipc	ra,0xfffff
    80203c28:	d38080e7          	jalr	-712(ra) # 8020295c <handle_page_fault>
    80203c2c:	87aa                	mv	a5,a0
    80203c2e:	e7f1                	bnez	a5,80203cfa <handle_exception+0x2d8>
			set_sepc(tf, info->sepc + 4);
    80203c30:	fd043783          	ld	a5,-48(s0)
    80203c34:	639c                	ld	a5,0(a5)
    80203c36:	0791                	addi	a5,a5,4
    80203c38:	85be                	mv	a1,a5
    80203c3a:	fd843503          	ld	a0,-40(s0)
    80203c3e:	00000097          	auipc	ra,0x0
    80203c42:	a1a080e7          	jalr	-1510(ra) # 80203658 <set_sepc>
			break;
    80203c46:	a85d                	j	80203cfc <handle_exception+0x2da>
            handle_syscall(tf,info);
    80203c48:	fd043583          	ld	a1,-48(s0)
    80203c4c:	fd843503          	ld	a0,-40(s0)
    80203c50:	00000097          	auipc	ra,0x0
    80203c54:	1cc080e7          	jalr	460(ra) # 80203e1c <handle_syscall>
            break;
    80203c58:	a055                	j	80203cfc <handle_exception+0x2da>
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    80203c5a:	fd043783          	ld	a5,-48(s0)
    80203c5e:	639c                	ld	a5,0(a5)
    80203c60:	85be                	mv	a1,a5
    80203c62:	00005517          	auipc	a0,0x5
    80203c66:	a4e50513          	addi	a0,a0,-1458 # 802086b0 <etext+0x16b0>
    80203c6a:	ffffd097          	auipc	ra,0xffffd
    80203c6e:	018080e7          	jalr	24(ra) # 80200c82 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203c72:	fd043783          	ld	a5,-48(s0)
    80203c76:	639c                	ld	a5,0(a5)
    80203c78:	0791                	addi	a5,a5,4
    80203c7a:	85be                	mv	a1,a5
    80203c7c:	fd843503          	ld	a0,-40(s0)
    80203c80:	00000097          	auipc	ra,0x0
    80203c84:	9d8080e7          	jalr	-1576(ra) # 80203658 <set_sepc>
            break;
    80203c88:	a895                	j	80203cfc <handle_exception+0x2da>
            handle_instruction_page_fault(tf,info);
    80203c8a:	fd043583          	ld	a1,-48(s0)
    80203c8e:	fd843503          	ld	a0,-40(s0)
    80203c92:	00000097          	auipc	ra,0x0
    80203c96:	26c080e7          	jalr	620(ra) # 80203efe <handle_instruction_page_fault>
            break;
    80203c9a:	a08d                	j	80203cfc <handle_exception+0x2da>
            handle_load_page_fault(tf,info);
    80203c9c:	fd043583          	ld	a1,-48(s0)
    80203ca0:	fd843503          	ld	a0,-40(s0)
    80203ca4:	00000097          	auipc	ra,0x0
    80203ca8:	2bc080e7          	jalr	700(ra) # 80203f60 <handle_load_page_fault>
            break;
    80203cac:	a881                	j	80203cfc <handle_exception+0x2da>
            handle_store_page_fault(tf,info);
    80203cae:	fd043583          	ld	a1,-48(s0)
    80203cb2:	fd843503          	ld	a0,-40(s0)
    80203cb6:	00000097          	auipc	ra,0x0
    80203cba:	30c080e7          	jalr	780(ra) # 80203fc2 <handle_store_page_fault>
            break;
    80203cbe:	a83d                	j	80203cfc <handle_exception+0x2da>
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    80203cc0:	fd043783          	ld	a5,-48(s0)
    80203cc4:	6398                	ld	a4,0(a5)
    80203cc6:	fd043783          	ld	a5,-48(s0)
    80203cca:	6f9c                	ld	a5,24(a5)
    80203ccc:	86be                	mv	a3,a5
    80203cce:	863a                	mv	a2,a4
    80203cd0:	fe843583          	ld	a1,-24(s0)
    80203cd4:	00005517          	auipc	a0,0x5
    80203cd8:	a0450513          	addi	a0,a0,-1532 # 802086d8 <etext+0x16d8>
    80203cdc:	ffffd097          	auipc	ra,0xffffd
    80203ce0:	fa6080e7          	jalr	-90(ra) # 80200c82 <printf>
            panic("Unknown exception");
    80203ce4:	00005517          	auipc	a0,0x5
    80203ce8:	a2c50513          	addi	a0,a0,-1492 # 80208710 <etext+0x1710>
    80203cec:	ffffe097          	auipc	ra,0xffffe
    80203cf0:	9e2080e7          	jalr	-1566(ra) # 802016ce <panic>
            break;
    80203cf4:	a021                	j	80203cfc <handle_exception+0x2da>
				return; // 成功处理
    80203cf6:	0001                	nop
    80203cf8:	a011                	j	80203cfc <handle_exception+0x2da>
				return; // 成功处理
    80203cfa:	0001                	nop
}
    80203cfc:	70a2                	ld	ra,40(sp)
    80203cfe:	7402                	ld	s0,32(sp)
    80203d00:	6145                	addi	sp,sp,48
    80203d02:	8082                	ret

0000000080203d04 <user_va2pa>:
void* user_va2pa(pagetable_t pagetable, uint64 va) {
    80203d04:	7179                	addi	sp,sp,-48
    80203d06:	f406                	sd	ra,40(sp)
    80203d08:	f022                	sd	s0,32(sp)
    80203d0a:	1800                	addi	s0,sp,48
    80203d0c:	fca43c23          	sd	a0,-40(s0)
    80203d10:	fcb43823          	sd	a1,-48(s0)
    pte_t *pte = walk_lookup(pagetable, va);
    80203d14:	fd043583          	ld	a1,-48(s0)
    80203d18:	fd843503          	ld	a0,-40(s0)
    80203d1c:	ffffe097          	auipc	ra,0xffffe
    80203d20:	388080e7          	jalr	904(ra) # 802020a4 <walk_lookup>
    80203d24:	fea43423          	sd	a0,-24(s0)
    if (!pte) return 0;
    80203d28:	fe843783          	ld	a5,-24(s0)
    80203d2c:	e399                	bnez	a5,80203d32 <user_va2pa+0x2e>
    80203d2e:	4781                	li	a5,0
    80203d30:	a83d                	j	80203d6e <user_va2pa+0x6a>
    if (!(*pte & PTE_V)) return 0;
    80203d32:	fe843783          	ld	a5,-24(s0)
    80203d36:	639c                	ld	a5,0(a5)
    80203d38:	8b85                	andi	a5,a5,1
    80203d3a:	e399                	bnez	a5,80203d40 <user_va2pa+0x3c>
    80203d3c:	4781                	li	a5,0
    80203d3e:	a805                	j	80203d6e <user_va2pa+0x6a>
    if (!(*pte & PTE_U)) return 0; // 必须是用户可访问
    80203d40:	fe843783          	ld	a5,-24(s0)
    80203d44:	639c                	ld	a5,0(a5)
    80203d46:	8bc1                	andi	a5,a5,16
    80203d48:	e399                	bnez	a5,80203d4e <user_va2pa+0x4a>
    80203d4a:	4781                	li	a5,0
    80203d4c:	a00d                	j	80203d6e <user_va2pa+0x6a>
    uint64 pa = (PTE2PA(*pte)) | (va & 0xFFF); // 物理页基址 + 页内偏移
    80203d4e:	fe843783          	ld	a5,-24(s0)
    80203d52:	639c                	ld	a5,0(a5)
    80203d54:	83a9                	srli	a5,a5,0xa
    80203d56:	00c79713          	slli	a4,a5,0xc
    80203d5a:	fd043683          	ld	a3,-48(s0)
    80203d5e:	6785                	lui	a5,0x1
    80203d60:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203d62:	8ff5                	and	a5,a5,a3
    80203d64:	8fd9                	or	a5,a5,a4
    80203d66:	fef43023          	sd	a5,-32(s0)
    return (void*)pa;
    80203d6a:	fe043783          	ld	a5,-32(s0)
}
    80203d6e:	853e                	mv	a0,a5
    80203d70:	70a2                	ld	ra,40(sp)
    80203d72:	7402                	ld	s0,32(sp)
    80203d74:	6145                	addi	sp,sp,48
    80203d76:	8082                	ret

0000000080203d78 <copyin>:
int copyin(char *dst, uint64 srcva, int maxlen) {
    80203d78:	715d                	addi	sp,sp,-80
    80203d7a:	e486                	sd	ra,72(sp)
    80203d7c:	e0a2                	sd	s0,64(sp)
    80203d7e:	0880                	addi	s0,sp,80
    80203d80:	fca43423          	sd	a0,-56(s0)
    80203d84:	fcb43023          	sd	a1,-64(s0)
    80203d88:	87b2                	mv	a5,a2
    80203d8a:	faf42e23          	sw	a5,-68(s0)
    struct proc *p = myproc();
    80203d8e:	00001097          	auipc	ra,0x1
    80203d92:	dc2080e7          	jalr	-574(ra) # 80204b50 <myproc>
    80203d96:	fea43023          	sd	a0,-32(s0)
    for (int i = 0; i < maxlen; i++) {
    80203d9a:	fe042623          	sw	zero,-20(s0)
    80203d9e:	a085                	j	80203dfe <copyin+0x86>
        char *pa = user_va2pa(p->pagetable, srcva + i); // 你需要实现 user_va2pa
    80203da0:	fe043783          	ld	a5,-32(s0)
    80203da4:	7fd4                	ld	a3,184(a5)
    80203da6:	fec42703          	lw	a4,-20(s0)
    80203daa:	fc043783          	ld	a5,-64(s0)
    80203dae:	97ba                	add	a5,a5,a4
    80203db0:	85be                	mv	a1,a5
    80203db2:	8536                	mv	a0,a3
    80203db4:	00000097          	auipc	ra,0x0
    80203db8:	f50080e7          	jalr	-176(ra) # 80203d04 <user_va2pa>
    80203dbc:	fca43c23          	sd	a0,-40(s0)
        if (!pa) return -1;
    80203dc0:	fd843783          	ld	a5,-40(s0)
    80203dc4:	e399                	bnez	a5,80203dca <copyin+0x52>
    80203dc6:	57fd                	li	a5,-1
    80203dc8:	a0a9                	j	80203e12 <copyin+0x9a>
        dst[i] = *pa;
    80203dca:	fec42783          	lw	a5,-20(s0)
    80203dce:	fc843703          	ld	a4,-56(s0)
    80203dd2:	97ba                	add	a5,a5,a4
    80203dd4:	fd843703          	ld	a4,-40(s0)
    80203dd8:	00074703          	lbu	a4,0(a4)
    80203ddc:	00e78023          	sb	a4,0(a5)
        if (dst[i] == 0) return 0;
    80203de0:	fec42783          	lw	a5,-20(s0)
    80203de4:	fc843703          	ld	a4,-56(s0)
    80203de8:	97ba                	add	a5,a5,a4
    80203dea:	0007c783          	lbu	a5,0(a5)
    80203dee:	e399                	bnez	a5,80203df4 <copyin+0x7c>
    80203df0:	4781                	li	a5,0
    80203df2:	a005                	j	80203e12 <copyin+0x9a>
    for (int i = 0; i < maxlen; i++) {
    80203df4:	fec42783          	lw	a5,-20(s0)
    80203df8:	2785                	addiw	a5,a5,1
    80203dfa:	fef42623          	sw	a5,-20(s0)
    80203dfe:	fec42783          	lw	a5,-20(s0)
    80203e02:	873e                	mv	a4,a5
    80203e04:	fbc42783          	lw	a5,-68(s0)
    80203e08:	2701                	sext.w	a4,a4
    80203e0a:	2781                	sext.w	a5,a5
    80203e0c:	f8f74ae3          	blt	a4,a5,80203da0 <copyin+0x28>
    return 0;
    80203e10:	4781                	li	a5,0
}
    80203e12:	853e                	mv	a0,a5
    80203e14:	60a6                	ld	ra,72(sp)
    80203e16:	6406                	ld	s0,64(sp)
    80203e18:	6161                	addi	sp,sp,80
    80203e1a:	8082                	ret

0000000080203e1c <handle_syscall>:
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    80203e1c:	7135                	addi	sp,sp,-160
    80203e1e:	ed06                	sd	ra,152(sp)
    80203e20:	e922                	sd	s0,144(sp)
    80203e22:	1100                	addi	s0,sp,160
    80203e24:	f6a43423          	sd	a0,-152(s0)
    80203e28:	f6b43023          	sd	a1,-160(s0)
    switch (tf->a7) {
    80203e2c:	f6843783          	ld	a5,-152(s0)
    80203e30:	7bdc                	ld	a5,176(a5)
    80203e32:	05d00713          	li	a4,93
    80203e36:	06e78563          	beq	a5,a4,80203ea0 <handle_syscall+0x84>
    80203e3a:	05d00713          	li	a4,93
    80203e3e:	08f76363          	bltu	a4,a5,80203ec4 <handle_syscall+0xa8>
    80203e42:	4705                	li	a4,1
    80203e44:	00e78663          	beq	a5,a4,80203e50 <handle_syscall+0x34>
    80203e48:	4709                	li	a4,2
    80203e4a:	02e78063          	beq	a5,a4,80203e6a <handle_syscall+0x4e>
    80203e4e:	a89d                	j	80203ec4 <handle_syscall+0xa8>
            printf("[user syscall] print int: %ld\n", tf->a0);
    80203e50:	f6843783          	ld	a5,-152(s0)
    80203e54:	7fbc                	ld	a5,120(a5)
    80203e56:	85be                	mv	a1,a5
    80203e58:	00005517          	auipc	a0,0x5
    80203e5c:	91050513          	addi	a0,a0,-1776 # 80208768 <etext+0x1768>
    80203e60:	ffffd097          	auipc	ra,0xffffd
    80203e64:	e22080e7          	jalr	-478(ra) # 80200c82 <printf>
            break;
    80203e68:	a89d                	j	80203ede <handle_syscall+0xc2>
                copyin(buf, tf->a0, sizeof(buf)-1); // 你需要实现copyin
    80203e6a:	f6843783          	ld	a5,-152(s0)
    80203e6e:	7fb8                	ld	a4,120(a5)
    80203e70:	f7040793          	addi	a5,s0,-144
    80203e74:	07f00613          	li	a2,127
    80203e78:	85ba                	mv	a1,a4
    80203e7a:	853e                	mv	a0,a5
    80203e7c:	00000097          	auipc	ra,0x0
    80203e80:	efc080e7          	jalr	-260(ra) # 80203d78 <copyin>
                buf[sizeof(buf)-1] = 0;
    80203e84:	fe0407a3          	sb	zero,-17(s0)
                printf("[user syscall] print str: %s\n", buf);
    80203e88:	f7040793          	addi	a5,s0,-144
    80203e8c:	85be                	mv	a1,a5
    80203e8e:	00005517          	auipc	a0,0x5
    80203e92:	8fa50513          	addi	a0,a0,-1798 # 80208788 <etext+0x1788>
    80203e96:	ffffd097          	auipc	ra,0xffffd
    80203e9a:	dec080e7          	jalr	-532(ra) # 80200c82 <printf>
            break;
    80203e9e:	a081                	j	80203ede <handle_syscall+0xc2>
    		printf("[user syscall] exit(%ld)\n", tf->a0);
    80203ea0:	f6843783          	ld	a5,-152(s0)
    80203ea4:	7fbc                	ld	a5,120(a5)
    80203ea6:	85be                	mv	a1,a5
    80203ea8:	00005517          	auipc	a0,0x5
    80203eac:	90050513          	addi	a0,a0,-1792 # 802087a8 <etext+0x17a8>
    80203eb0:	ffffd097          	auipc	ra,0xffffd
    80203eb4:	dd2080e7          	jalr	-558(ra) # 80200c82 <printf>
			exit_proc(0);
    80203eb8:	4501                	li	a0,0
    80203eba:	00001097          	auipc	ra,0x1
    80203ebe:	522080e7          	jalr	1314(ra) # 802053dc <exit_proc>
			break;
    80203ec2:	a831                	j	80203ede <handle_syscall+0xc2>
            printf("[user syscall] unknown syscall: %ld\n", tf->a7);
    80203ec4:	f6843783          	ld	a5,-152(s0)
    80203ec8:	7bdc                	ld	a5,176(a5)
    80203eca:	85be                	mv	a1,a5
    80203ecc:	00005517          	auipc	a0,0x5
    80203ed0:	8fc50513          	addi	a0,a0,-1796 # 802087c8 <etext+0x17c8>
    80203ed4:	ffffd097          	auipc	ra,0xffffd
    80203ed8:	dae080e7          	jalr	-594(ra) # 80200c82 <printf>
            break;
    80203edc:	0001                	nop
    set_sepc(tf, info->sepc + 4); // 返回到下一条指令
    80203ede:	f6043783          	ld	a5,-160(s0)
    80203ee2:	639c                	ld	a5,0(a5)
    80203ee4:	0791                	addi	a5,a5,4
    80203ee6:	85be                	mv	a1,a5
    80203ee8:	f6843503          	ld	a0,-152(s0)
    80203eec:	fffff097          	auipc	ra,0xfffff
    80203ef0:	76c080e7          	jalr	1900(ra) # 80203658 <set_sepc>
}
    80203ef4:	0001                	nop
    80203ef6:	60ea                	ld	ra,152(sp)
    80203ef8:	644a                	ld	s0,144(sp)
    80203efa:	610d                	addi	sp,sp,160
    80203efc:	8082                	ret

0000000080203efe <handle_instruction_page_fault>:
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    80203efe:	1101                	addi	sp,sp,-32
    80203f00:	ec06                	sd	ra,24(sp)
    80203f02:	e822                	sd	s0,16(sp)
    80203f04:	1000                	addi	s0,sp,32
    80203f06:	fea43423          	sd	a0,-24(s0)
    80203f0a:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80203f0e:	fe043783          	ld	a5,-32(s0)
    80203f12:	6f98                	ld	a4,24(a5)
    80203f14:	fe043783          	ld	a5,-32(s0)
    80203f18:	639c                	ld	a5,0(a5)
    80203f1a:	863e                	mv	a2,a5
    80203f1c:	85ba                	mv	a1,a4
    80203f1e:	00005517          	auipc	a0,0x5
    80203f22:	8d250513          	addi	a0,a0,-1838 # 802087f0 <etext+0x17f0>
    80203f26:	ffffd097          	auipc	ra,0xffffd
    80203f2a:	d5c080e7          	jalr	-676(ra) # 80200c82 <printf>
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    80203f2e:	fe043783          	ld	a5,-32(s0)
    80203f32:	6f9c                	ld	a5,24(a5)
    80203f34:	4585                	li	a1,1
    80203f36:	853e                	mv	a0,a5
    80203f38:	fffff097          	auipc	ra,0xfffff
    80203f3c:	a24080e7          	jalr	-1500(ra) # 8020295c <handle_page_fault>
    80203f40:	87aa                	mv	a5,a0
    80203f42:	eb91                	bnez	a5,80203f56 <handle_instruction_page_fault+0x58>
    panic("Unhandled instruction page fault");
    80203f44:	00005517          	auipc	a0,0x5
    80203f48:	8dc50513          	addi	a0,a0,-1828 # 80208820 <etext+0x1820>
    80203f4c:	ffffd097          	auipc	ra,0xffffd
    80203f50:	782080e7          	jalr	1922(ra) # 802016ce <panic>
    80203f54:	a011                	j	80203f58 <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80203f56:	0001                	nop
}
    80203f58:	60e2                	ld	ra,24(sp)
    80203f5a:	6442                	ld	s0,16(sp)
    80203f5c:	6105                	addi	sp,sp,32
    80203f5e:	8082                	ret

0000000080203f60 <handle_load_page_fault>:
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    80203f60:	1101                	addi	sp,sp,-32
    80203f62:	ec06                	sd	ra,24(sp)
    80203f64:	e822                	sd	s0,16(sp)
    80203f66:	1000                	addi	s0,sp,32
    80203f68:	fea43423          	sd	a0,-24(s0)
    80203f6c:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80203f70:	fe043783          	ld	a5,-32(s0)
    80203f74:	6f98                	ld	a4,24(a5)
    80203f76:	fe043783          	ld	a5,-32(s0)
    80203f7a:	639c                	ld	a5,0(a5)
    80203f7c:	863e                	mv	a2,a5
    80203f7e:	85ba                	mv	a1,a4
    80203f80:	00005517          	auipc	a0,0x5
    80203f84:	8c850513          	addi	a0,a0,-1848 # 80208848 <etext+0x1848>
    80203f88:	ffffd097          	auipc	ra,0xffffd
    80203f8c:	cfa080e7          	jalr	-774(ra) # 80200c82 <printf>
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    80203f90:	fe043783          	ld	a5,-32(s0)
    80203f94:	6f9c                	ld	a5,24(a5)
    80203f96:	4589                	li	a1,2
    80203f98:	853e                	mv	a0,a5
    80203f9a:	fffff097          	auipc	ra,0xfffff
    80203f9e:	9c2080e7          	jalr	-1598(ra) # 8020295c <handle_page_fault>
    80203fa2:	87aa                	mv	a5,a0
    80203fa4:	eb91                	bnez	a5,80203fb8 <handle_load_page_fault+0x58>
    panic("Unhandled load page fault");
    80203fa6:	00005517          	auipc	a0,0x5
    80203faa:	8d250513          	addi	a0,a0,-1838 # 80208878 <etext+0x1878>
    80203fae:	ffffd097          	auipc	ra,0xffffd
    80203fb2:	720080e7          	jalr	1824(ra) # 802016ce <panic>
    80203fb6:	a011                	j	80203fba <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80203fb8:	0001                	nop
}
    80203fba:	60e2                	ld	ra,24(sp)
    80203fbc:	6442                	ld	s0,16(sp)
    80203fbe:	6105                	addi	sp,sp,32
    80203fc0:	8082                	ret

0000000080203fc2 <handle_store_page_fault>:
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    80203fc2:	1101                	addi	sp,sp,-32
    80203fc4:	ec06                	sd	ra,24(sp)
    80203fc6:	e822                	sd	s0,16(sp)
    80203fc8:	1000                	addi	s0,sp,32
    80203fca:	fea43423          	sd	a0,-24(s0)
    80203fce:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80203fd2:	fe043783          	ld	a5,-32(s0)
    80203fd6:	6f98                	ld	a4,24(a5)
    80203fd8:	fe043783          	ld	a5,-32(s0)
    80203fdc:	639c                	ld	a5,0(a5)
    80203fde:	863e                	mv	a2,a5
    80203fe0:	85ba                	mv	a1,a4
    80203fe2:	00005517          	auipc	a0,0x5
    80203fe6:	8b650513          	addi	a0,a0,-1866 # 80208898 <etext+0x1898>
    80203fea:	ffffd097          	auipc	ra,0xffffd
    80203fee:	c98080e7          	jalr	-872(ra) # 80200c82 <printf>
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    80203ff2:	fe043783          	ld	a5,-32(s0)
    80203ff6:	6f9c                	ld	a5,24(a5)
    80203ff8:	458d                	li	a1,3
    80203ffa:	853e                	mv	a0,a5
    80203ffc:	fffff097          	auipc	ra,0xfffff
    80204000:	960080e7          	jalr	-1696(ra) # 8020295c <handle_page_fault>
    80204004:	87aa                	mv	a5,a0
    80204006:	eb91                	bnez	a5,8020401a <handle_store_page_fault+0x58>
    panic("Unhandled store page fault");
    80204008:	00005517          	auipc	a0,0x5
    8020400c:	8c050513          	addi	a0,a0,-1856 # 802088c8 <etext+0x18c8>
    80204010:	ffffd097          	auipc	ra,0xffffd
    80204014:	6be080e7          	jalr	1726(ra) # 802016ce <panic>
    80204018:	a011                	j	8020401c <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    8020401a:	0001                	nop
}
    8020401c:	60e2                	ld	ra,24(sp)
    8020401e:	6442                	ld	s0,16(sp)
    80204020:	6105                	addi	sp,sp,32
    80204022:	8082                	ret

0000000080204024 <get_time>:
uint64 get_time(void) {
    80204024:	1141                	addi	sp,sp,-16
    80204026:	e406                	sd	ra,8(sp)
    80204028:	e022                	sd	s0,0(sp)
    8020402a:	0800                	addi	s0,sp,16
    return sbi_get_time();
    8020402c:	fffff097          	auipc	ra,0xfffff
    80204030:	474080e7          	jalr	1140(ra) # 802034a0 <sbi_get_time>
    80204034:	87aa                	mv	a5,a0
}
    80204036:	853e                	mv	a0,a5
    80204038:	60a2                	ld	ra,8(sp)
    8020403a:	6402                	ld	s0,0(sp)
    8020403c:	0141                	addi	sp,sp,16
    8020403e:	8082                	ret

0000000080204040 <test_timer_interrupt>:
void test_timer_interrupt(void) {
    80204040:	7179                	addi	sp,sp,-48
    80204042:	f406                	sd	ra,40(sp)
    80204044:	f022                	sd	s0,32(sp)
    80204046:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    80204048:	00005517          	auipc	a0,0x5
    8020404c:	8a050513          	addi	a0,a0,-1888 # 802088e8 <etext+0x18e8>
    80204050:	ffffd097          	auipc	ra,0xffffd
    80204054:	c32080e7          	jalr	-974(ra) # 80200c82 <printf>
    uint64 start_time = get_time();
    80204058:	00000097          	auipc	ra,0x0
    8020405c:	fcc080e7          	jalr	-52(ra) # 80204024 <get_time>
    80204060:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    80204064:	fc042a23          	sw	zero,-44(s0)
	int last_count = interrupt_count;
    80204068:	fd442783          	lw	a5,-44(s0)
    8020406c:	fef42623          	sw	a5,-20(s0)
    interrupt_test_flag = &interrupt_count;
    80204070:	00008797          	auipc	a5,0x8
    80204074:	04878793          	addi	a5,a5,72 # 8020c0b8 <interrupt_test_flag>
    80204078:	fd440713          	addi	a4,s0,-44
    8020407c:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    8020407e:	a899                	j	802040d4 <test_timer_interrupt+0x94>
        if(last_count != interrupt_count) {
    80204080:	fd442703          	lw	a4,-44(s0)
    80204084:	fec42783          	lw	a5,-20(s0)
    80204088:	2781                	sext.w	a5,a5
    8020408a:	02e78163          	beq	a5,a4,802040ac <test_timer_interrupt+0x6c>
			last_count = interrupt_count;
    8020408e:	fd442783          	lw	a5,-44(s0)
    80204092:	fef42623          	sw	a5,-20(s0)
			printf("Received interrupt %d\n", interrupt_count);
    80204096:	fd442783          	lw	a5,-44(s0)
    8020409a:	85be                	mv	a1,a5
    8020409c:	00005517          	auipc	a0,0x5
    802040a0:	86c50513          	addi	a0,a0,-1940 # 80208908 <etext+0x1908>
    802040a4:	ffffd097          	auipc	ra,0xffffd
    802040a8:	bde080e7          	jalr	-1058(ra) # 80200c82 <printf>
        for (volatile int i = 0; i < 1000000; i++);
    802040ac:	fc042823          	sw	zero,-48(s0)
    802040b0:	a801                	j	802040c0 <test_timer_interrupt+0x80>
    802040b2:	fd042783          	lw	a5,-48(s0)
    802040b6:	2781                	sext.w	a5,a5
    802040b8:	2785                	addiw	a5,a5,1
    802040ba:	2781                	sext.w	a5,a5
    802040bc:	fcf42823          	sw	a5,-48(s0)
    802040c0:	fd042783          	lw	a5,-48(s0)
    802040c4:	2781                	sext.w	a5,a5
    802040c6:	873e                	mv	a4,a5
    802040c8:	000f47b7          	lui	a5,0xf4
    802040cc:	23f78793          	addi	a5,a5,575 # f423f <_entry-0x8010bdc1>
    802040d0:	fee7d1e3          	bge	a5,a4,802040b2 <test_timer_interrupt+0x72>
    while (interrupt_count < 5) {
    802040d4:	fd442783          	lw	a5,-44(s0)
    802040d8:	873e                	mv	a4,a5
    802040da:	4791                	li	a5,4
    802040dc:	fae7d2e3          	bge	a5,a4,80204080 <test_timer_interrupt+0x40>
    interrupt_test_flag = 0;
    802040e0:	00008797          	auipc	a5,0x8
    802040e4:	fd878793          	addi	a5,a5,-40 # 8020c0b8 <interrupt_test_flag>
    802040e8:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    802040ec:	00000097          	auipc	ra,0x0
    802040f0:	f38080e7          	jalr	-200(ra) # 80204024 <get_time>
    802040f4:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    802040f8:	fd442683          	lw	a3,-44(s0)
    802040fc:	fd843703          	ld	a4,-40(s0)
    80204100:	fe043783          	ld	a5,-32(s0)
    80204104:	40f707b3          	sub	a5,a4,a5
    80204108:	863e                	mv	a2,a5
    8020410a:	85b6                	mv	a1,a3
    8020410c:	00005517          	auipc	a0,0x5
    80204110:	81450513          	addi	a0,a0,-2028 # 80208920 <etext+0x1920>
    80204114:	ffffd097          	auipc	ra,0xffffd
    80204118:	b6e080e7          	jalr	-1170(ra) # 80200c82 <printf>
}
    8020411c:	0001                	nop
    8020411e:	70a2                	ld	ra,40(sp)
    80204120:	7402                	ld	s0,32(sp)
    80204122:	6145                	addi	sp,sp,48
    80204124:	8082                	ret

0000000080204126 <test_exception>:
void test_exception(void) {
    80204126:	715d                	addi	sp,sp,-80
    80204128:	e486                	sd	ra,72(sp)
    8020412a:	e0a2                	sd	s0,64(sp)
    8020412c:	0880                	addi	s0,sp,80
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    8020412e:	00005517          	auipc	a0,0x5
    80204132:	82a50513          	addi	a0,a0,-2006 # 80208958 <etext+0x1958>
    80204136:	ffffd097          	auipc	ra,0xffffd
    8020413a:	b4c080e7          	jalr	-1204(ra) # 80200c82 <printf>
    printf("1. 测试非法指令异常...\n");
    8020413e:	00005517          	auipc	a0,0x5
    80204142:	84a50513          	addi	a0,a0,-1974 # 80208988 <etext+0x1988>
    80204146:	ffffd097          	auipc	ra,0xffffd
    8020414a:	b3c080e7          	jalr	-1220(ra) # 80200c82 <printf>
    8020414e:	ffffffff          	.word	0xffffffff
    printf("✓ 非法指令异常处理成功\n\n");
    80204152:	00005517          	auipc	a0,0x5
    80204156:	85650513          	addi	a0,a0,-1962 # 802089a8 <etext+0x19a8>
    8020415a:	ffffd097          	auipc	ra,0xffffd
    8020415e:	b28080e7          	jalr	-1240(ra) # 80200c82 <printf>
    printf("2. 测试存储页故障异常...\n");
    80204162:	00005517          	auipc	a0,0x5
    80204166:	86e50513          	addi	a0,a0,-1938 # 802089d0 <etext+0x19d0>
    8020416a:	ffffd097          	auipc	ra,0xffffd
    8020416e:	b18080e7          	jalr	-1256(ra) # 80200c82 <printf>
    volatile uint64 *invalid_ptr = 0;
    80204172:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80204176:	47a5                	li	a5,9
    80204178:	07f2                	slli	a5,a5,0x1c
    8020417a:	fef43023          	sd	a5,-32(s0)
    8020417e:	a835                	j	802041ba <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    80204180:	fe043503          	ld	a0,-32(s0)
    80204184:	fffff097          	auipc	ra,0xfffff
    80204188:	e34080e7          	jalr	-460(ra) # 80202fb8 <check_is_mapped>
    8020418c:	87aa                	mv	a5,a0
    8020418e:	e385                	bnez	a5,802041ae <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    80204190:	fe043783          	ld	a5,-32(s0)
    80204194:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80204198:	fe043583          	ld	a1,-32(s0)
    8020419c:	00005517          	auipc	a0,0x5
    802041a0:	85c50513          	addi	a0,a0,-1956 # 802089f8 <etext+0x19f8>
    802041a4:	ffffd097          	auipc	ra,0xffffd
    802041a8:	ade080e7          	jalr	-1314(ra) # 80200c82 <printf>
            break;
    802041ac:	a829                	j	802041c6 <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    802041ae:	fe043703          	ld	a4,-32(s0)
    802041b2:	6785                	lui	a5,0x1
    802041b4:	97ba                	add	a5,a5,a4
    802041b6:	fef43023          	sd	a5,-32(s0)
    802041ba:	fe043703          	ld	a4,-32(s0)
    802041be:	47cd                	li	a5,19
    802041c0:	07ee                	slli	a5,a5,0x1b
    802041c2:	faf76fe3          	bltu	a4,a5,80204180 <test_exception+0x5a>
    if (invalid_ptr != 0) {
    802041c6:	fe843783          	ld	a5,-24(s0)
    802041ca:	cb95                	beqz	a5,802041fe <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    802041cc:	fe843783          	ld	a5,-24(s0)
    802041d0:	85be                	mv	a1,a5
    802041d2:	00005517          	auipc	a0,0x5
    802041d6:	84650513          	addi	a0,a0,-1978 # 80208a18 <etext+0x1a18>
    802041da:	ffffd097          	auipc	ra,0xffffd
    802041de:	aa8080e7          	jalr	-1368(ra) # 80200c82 <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    802041e2:	fe843783          	ld	a5,-24(s0)
    802041e6:	02a00713          	li	a4,42
    802041ea:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    802041ec:	00005517          	auipc	a0,0x5
    802041f0:	85c50513          	addi	a0,a0,-1956 # 80208a48 <etext+0x1a48>
    802041f4:	ffffd097          	auipc	ra,0xffffd
    802041f8:	a8e080e7          	jalr	-1394(ra) # 80200c82 <printf>
    802041fc:	a809                	j	8020420e <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    802041fe:	00005517          	auipc	a0,0x5
    80204202:	87250513          	addi	a0,a0,-1934 # 80208a70 <etext+0x1a70>
    80204206:	ffffd097          	auipc	ra,0xffffd
    8020420a:	a7c080e7          	jalr	-1412(ra) # 80200c82 <printf>
    printf("3. 测试加载页故障异常...\n");
    8020420e:	00005517          	auipc	a0,0x5
    80204212:	89a50513          	addi	a0,a0,-1894 # 80208aa8 <etext+0x1aa8>
    80204216:	ffffd097          	auipc	ra,0xffffd
    8020421a:	a6c080e7          	jalr	-1428(ra) # 80200c82 <printf>
    invalid_ptr = 0;
    8020421e:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80204222:	4795                	li	a5,5
    80204224:	07f6                	slli	a5,a5,0x1d
    80204226:	fcf43c23          	sd	a5,-40(s0)
    8020422a:	a835                	j	80204266 <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    8020422c:	fd843503          	ld	a0,-40(s0)
    80204230:	fffff097          	auipc	ra,0xfffff
    80204234:	d88080e7          	jalr	-632(ra) # 80202fb8 <check_is_mapped>
    80204238:	87aa                	mv	a5,a0
    8020423a:	e385                	bnez	a5,8020425a <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    8020423c:	fd843783          	ld	a5,-40(s0)
    80204240:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80204244:	fd843583          	ld	a1,-40(s0)
    80204248:	00004517          	auipc	a0,0x4
    8020424c:	7b050513          	addi	a0,a0,1968 # 802089f8 <etext+0x19f8>
    80204250:	ffffd097          	auipc	ra,0xffffd
    80204254:	a32080e7          	jalr	-1486(ra) # 80200c82 <printf>
            break;
    80204258:	a829                	j	80204272 <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    8020425a:	fd843703          	ld	a4,-40(s0)
    8020425e:	6785                	lui	a5,0x1
    80204260:	97ba                	add	a5,a5,a4
    80204262:	fcf43c23          	sd	a5,-40(s0)
    80204266:	fd843703          	ld	a4,-40(s0)
    8020426a:	47d5                	li	a5,21
    8020426c:	07ee                	slli	a5,a5,0x1b
    8020426e:	faf76fe3          	bltu	a4,a5,8020422c <test_exception+0x106>
    if (invalid_ptr != 0) {
    80204272:	fe843783          	ld	a5,-24(s0)
    80204276:	c7a9                	beqz	a5,802042c0 <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80204278:	fe843783          	ld	a5,-24(s0)
    8020427c:	85be                	mv	a1,a5
    8020427e:	00005517          	auipc	a0,0x5
    80204282:	85250513          	addi	a0,a0,-1966 # 80208ad0 <etext+0x1ad0>
    80204286:	ffffd097          	auipc	ra,0xffffd
    8020428a:	9fc080e7          	jalr	-1540(ra) # 80200c82 <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    8020428e:	fe843783          	ld	a5,-24(s0)
    80204292:	639c                	ld	a5,0(a5)
    80204294:	faf43823          	sd	a5,-80(s0)
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    80204298:	fb043783          	ld	a5,-80(s0)
    8020429c:	85be                	mv	a1,a5
    8020429e:	00005517          	auipc	a0,0x5
    802042a2:	86250513          	addi	a0,a0,-1950 # 80208b00 <etext+0x1b00>
    802042a6:	ffffd097          	auipc	ra,0xffffd
    802042aa:	9dc080e7          	jalr	-1572(ra) # 80200c82 <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    802042ae:	00005517          	auipc	a0,0x5
    802042b2:	86a50513          	addi	a0,a0,-1942 # 80208b18 <etext+0x1b18>
    802042b6:	ffffd097          	auipc	ra,0xffffd
    802042ba:	9cc080e7          	jalr	-1588(ra) # 80200c82 <printf>
    802042be:	a809                	j	802042d0 <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    802042c0:	00004517          	auipc	a0,0x4
    802042c4:	7b050513          	addi	a0,a0,1968 # 80208a70 <etext+0x1a70>
    802042c8:	ffffd097          	auipc	ra,0xffffd
    802042cc:	9ba080e7          	jalr	-1606(ra) # 80200c82 <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    802042d0:	00005517          	auipc	a0,0x5
    802042d4:	87050513          	addi	a0,a0,-1936 # 80208b40 <etext+0x1b40>
    802042d8:	ffffd097          	auipc	ra,0xffffd
    802042dc:	9aa080e7          	jalr	-1622(ra) # 80200c82 <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    802042e0:	fffff097          	auipc	ra,0xfffff
    802042e4:	f20080e7          	jalr	-224(ra) # 80203200 <alloc_page>
    802042e8:	87aa                	mv	a5,a0
    802042ea:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    802042ee:	fd043783          	ld	a5,-48(s0)
    802042f2:	c3a1                	beqz	a5,80204332 <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    802042f4:	fd043783          	ld	a5,-48(s0)
    802042f8:	0785                	addi	a5,a5,1 # 1001 <_entry-0x801fefff>
    802042fa:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    802042fe:	fc843583          	ld	a1,-56(s0)
    80204302:	00005517          	auipc	a0,0x5
    80204306:	86e50513          	addi	a0,a0,-1938 # 80208b70 <etext+0x1b70>
    8020430a:	ffffd097          	auipc	ra,0xffffd
    8020430e:	978080e7          	jalr	-1672(ra) # 80200c82 <printf>
        asm volatile (
    80204312:	deadc7b7          	lui	a5,0xdeadc
    80204316:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8cf5df>
    8020431a:	fc843703          	ld	a4,-56(s0)
    8020431e:	e31c                	sd	a5,0(a4)
            "sd %0, 0(%1)"
            : 
            : "r" (0xdeadbeef), "r" (misaligned_addr)
            : "memory"
        );
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    80204320:	00005517          	auipc	a0,0x5
    80204324:	87050513          	addi	a0,a0,-1936 # 80208b90 <etext+0x1b90>
    80204328:	ffffd097          	auipc	ra,0xffffd
    8020432c:	95a080e7          	jalr	-1702(ra) # 80200c82 <printf>
    80204330:	a809                	j	80204342 <test_exception+0x21c>
    } else {
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80204332:	00005517          	auipc	a0,0x5
    80204336:	88e50513          	addi	a0,a0,-1906 # 80208bc0 <etext+0x1bc0>
    8020433a:	ffffd097          	auipc	ra,0xffffd
    8020433e:	948080e7          	jalr	-1720(ra) # 80200c82 <printf>
    }
    
    // 5. 测试加载地址未对齐异常
    printf("5. 测试加载地址未对齐异常...\n");
    80204342:	00005517          	auipc	a0,0x5
    80204346:	8be50513          	addi	a0,a0,-1858 # 80208c00 <etext+0x1c00>
    8020434a:	ffffd097          	auipc	ra,0xffffd
    8020434e:	938080e7          	jalr	-1736(ra) # 80200c82 <printf>
    if (aligned_addr != 0) {
    80204352:	fd043783          	ld	a5,-48(s0)
    80204356:	cbb1                	beqz	a5,802043aa <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    80204358:	fd043783          	ld	a5,-48(s0)
    8020435c:	0785                	addi	a5,a5,1
    8020435e:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80204362:	fc043583          	ld	a1,-64(s0)
    80204366:	00005517          	auipc	a0,0x5
    8020436a:	80a50513          	addi	a0,a0,-2038 # 80208b70 <etext+0x1b70>
    8020436e:	ffffd097          	auipc	ra,0xffffd
    80204372:	914080e7          	jalr	-1772(ra) # 80200c82 <printf>
        
        uint64 value = 0;
    80204376:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    8020437a:	fc043783          	ld	a5,-64(s0)
    8020437e:	639c                	ld	a5,0(a5)
    80204380:	faf43c23          	sd	a5,-72(s0)
            "ld %0, 0(%1)"
            : "=r" (value)
            : "r" (misaligned_addr)
            : "memory"
        );
        printf("读取的值: 0x%lx\n", value);
    80204384:	fb843583          	ld	a1,-72(s0)
    80204388:	00005517          	auipc	a0,0x5
    8020438c:	8a850513          	addi	a0,a0,-1880 # 80208c30 <etext+0x1c30>
    80204390:	ffffd097          	auipc	ra,0xffffd
    80204394:	8f2080e7          	jalr	-1806(ra) # 80200c82 <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80204398:	00005517          	auipc	a0,0x5
    8020439c:	8b050513          	addi	a0,a0,-1872 # 80208c48 <etext+0x1c48>
    802043a0:	ffffd097          	auipc	ra,0xffffd
    802043a4:	8e2080e7          	jalr	-1822(ra) # 80200c82 <printf>
    802043a8:	a809                	j	802043ba <test_exception+0x294>
    } else {
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    802043aa:	00005517          	auipc	a0,0x5
    802043ae:	81650513          	addi	a0,a0,-2026 # 80208bc0 <etext+0x1bc0>
    802043b2:	ffffd097          	auipc	ra,0xffffd
    802043b6:	8d0080e7          	jalr	-1840(ra) # 80200c82 <printf>
    }

	// 6. 测试断点异常
	printf("6. 测试断点异常...\n");
    802043ba:	00005517          	auipc	a0,0x5
    802043be:	8be50513          	addi	a0,a0,-1858 # 80208c78 <etext+0x1c78>
    802043c2:	ffffd097          	auipc	ra,0xffffd
    802043c6:	8c0080e7          	jalr	-1856(ra) # 80200c82 <printf>
	asm volatile (
    802043ca:	0001                	nop
    802043cc:	9002                	ebreak
    802043ce:	0001                	nop
		"nop\n\t"      // 确保ebreak前有有效指令
		"ebreak\n\t"   // 断点指令
		"nop\n\t"      // 确保ebreak后有有效指令
	);
	printf("✓ 断点异常处理成功\n\n");
    802043d0:	00005517          	auipc	a0,0x5
    802043d4:	8c850513          	addi	a0,a0,-1848 # 80208c98 <etext+0x1c98>
    802043d8:	ffffd097          	auipc	ra,0xffffd
    802043dc:	8aa080e7          	jalr	-1878(ra) # 80200c82 <printf>
    // 7. 测试环境调用异常
    printf("7. 测试环境调用异常...\n");
    802043e0:	00005517          	auipc	a0,0x5
    802043e4:	8d850513          	addi	a0,a0,-1832 # 80208cb8 <etext+0x1cb8>
    802043e8:	ffffd097          	auipc	ra,0xffffd
    802043ec:	89a080e7          	jalr	-1894(ra) # 80200c82 <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    802043f0:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    802043f4:	00005517          	auipc	a0,0x5
    802043f8:	8e450513          	addi	a0,a0,-1820 # 80208cd8 <etext+0x1cd8>
    802043fc:	ffffd097          	auipc	ra,0xffffd
    80204400:	886080e7          	jalr	-1914(ra) # 80200c82 <printf>
    
    printf("===== 异常处理测试完成 =====\n\n");
    80204404:	00005517          	auipc	a0,0x5
    80204408:	8fc50513          	addi	a0,a0,-1796 # 80208d00 <etext+0x1d00>
    8020440c:	ffffd097          	auipc	ra,0xffffd
    80204410:	876080e7          	jalr	-1930(ra) # 80200c82 <printf>
}
    80204414:	0001                	nop
    80204416:	60a6                	ld	ra,72(sp)
    80204418:	6406                	ld	s0,64(sp)
    8020441a:	6161                	addi	sp,sp,80
    8020441c:	8082                	ret

000000008020441e <usertrap>:


void usertrap(void) {
    8020441e:	7159                	addi	sp,sp,-112
    80204420:	f486                	sd	ra,104(sp)
    80204422:	f0a2                	sd	s0,96(sp)
    80204424:	1880                	addi	s0,sp,112
    struct proc *p = myproc();
    80204426:	00000097          	auipc	ra,0x0
    8020442a:	72a080e7          	jalr	1834(ra) # 80204b50 <myproc>
    8020442e:	fea43423          	sd	a0,-24(s0)
    struct trapframe *tf = p->trapframe;
    80204432:	fe843783          	ld	a5,-24(s0)
    80204436:	63fc                	ld	a5,192(a5)
    80204438:	fef43023          	sd	a5,-32(s0)

    uint64 scause = r_scause();
    8020443c:	fffff097          	auipc	ra,0xfffff
    80204440:	18a080e7          	jalr	394(ra) # 802035c6 <r_scause>
    80204444:	fca43c23          	sd	a0,-40(s0)
    uint64 stval  = r_stval();
    80204448:	fffff097          	auipc	ra,0xfffff
    8020444c:	1b2080e7          	jalr	434(ra) # 802035fa <r_stval>
    80204450:	fca43823          	sd	a0,-48(s0)
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    80204454:	fe043783          	ld	a5,-32(s0)
    80204458:	739c                	ld	a5,32(a5)
    8020445a:	fcf43423          	sd	a5,-56(s0)
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存
    8020445e:	fe043783          	ld	a5,-32(s0)
    80204462:	6f9c                	ld	a5,24(a5)
    80204464:	fcf43023          	sd	a5,-64(s0)

    uint64 code = scause & 0xff;
    80204468:	fd843783          	ld	a5,-40(s0)
    8020446c:	0ff7f793          	zext.b	a5,a5
    80204470:	faf43c23          	sd	a5,-72(s0)
    uint64 is_intr = (scause >> 63);
    80204474:	fd843783          	ld	a5,-40(s0)
    80204478:	93fd                	srli	a5,a5,0x3f
    8020447a:	faf43823          	sd	a5,-80(s0)

    if (!is_intr && code == 8) { // 用户态 ecall
    8020447e:	fb043783          	ld	a5,-80(s0)
    80204482:	e3a1                	bnez	a5,802044c2 <usertrap+0xa4>
    80204484:	fb843703          	ld	a4,-72(s0)
    80204488:	47a1                	li	a5,8
    8020448a:	02f71c63          	bne	a4,a5,802044c2 <usertrap+0xa4>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    8020448e:	fc843783          	ld	a5,-56(s0)
    80204492:	f8f43823          	sd	a5,-112(s0)
    80204496:	fc043783          	ld	a5,-64(s0)
    8020449a:	f8f43c23          	sd	a5,-104(s0)
    8020449e:	fd843783          	ld	a5,-40(s0)
    802044a2:	faf43023          	sd	a5,-96(s0)
    802044a6:	fd043783          	ld	a5,-48(s0)
    802044aa:	faf43423          	sd	a5,-88(s0)
        handle_syscall(tf, &info);
    802044ae:	f9040793          	addi	a5,s0,-112
    802044b2:	85be                	mv	a1,a5
    802044b4:	fe043503          	ld	a0,-32(s0)
    802044b8:	00000097          	auipc	ra,0x0
    802044bc:	964080e7          	jalr	-1692(ra) # 80203e1c <handle_syscall>
    if (!is_intr && code == 8) { // 用户态 ecall
    802044c0:	a869                	j	8020455a <usertrap+0x13c>
        // handle_syscall 应该已 set_sepc(tf, sepc+4)
    } else if (is_intr) {
    802044c2:	fb043783          	ld	a5,-80(s0)
    802044c6:	c3ad                	beqz	a5,80204528 <usertrap+0x10a>
        if (code == 5) {
    802044c8:	fb843703          	ld	a4,-72(s0)
    802044cc:	4795                	li	a5,5
    802044ce:	02f71663          	bne	a4,a5,802044fa <usertrap+0xdc>
            timeintr();
    802044d2:	fffff097          	auipc	ra,0xfffff
    802044d6:	fe8080e7          	jalr	-24(ra) # 802034ba <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802044da:	fffff097          	auipc	ra,0xfffff
    802044de:	fc6080e7          	jalr	-58(ra) # 802034a0 <sbi_get_time>
    802044e2:	872a                	mv	a4,a0
    802044e4:	000f47b7          	lui	a5,0xf4
    802044e8:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802044ec:	97ba                	add	a5,a5,a4
    802044ee:	853e                	mv	a0,a5
    802044f0:	fffff097          	auipc	ra,0xfffff
    802044f4:	f94080e7          	jalr	-108(ra) # 80203484 <sbi_set_time>
    802044f8:	a08d                	j	8020455a <usertrap+0x13c>
        } else if (code == 9) {
    802044fa:	fb843703          	ld	a4,-72(s0)
    802044fe:	47a5                	li	a5,9
    80204500:	00f71763          	bne	a4,a5,8020450e <usertrap+0xf0>
            handle_external_interrupt();
    80204504:	fffff097          	auipc	ra,0xfffff
    80204508:	2a4080e7          	jalr	676(ra) # 802037a8 <handle_external_interrupt>
    8020450c:	a0b9                	j	8020455a <usertrap+0x13c>
        } else {
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    8020450e:	fc843603          	ld	a2,-56(s0)
    80204512:	fd843583          	ld	a1,-40(s0)
    80204516:	00005517          	auipc	a0,0x5
    8020451a:	81250513          	addi	a0,a0,-2030 # 80208d28 <etext+0x1d28>
    8020451e:	ffffc097          	auipc	ra,0xffffc
    80204522:	764080e7          	jalr	1892(ra) # 80200c82 <printf>
    80204526:	a815                	j	8020455a <usertrap+0x13c>
        }
    } else {
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80204528:	fc843783          	ld	a5,-56(s0)
    8020452c:	f8f43823          	sd	a5,-112(s0)
    80204530:	fc043783          	ld	a5,-64(s0)
    80204534:	f8f43c23          	sd	a5,-104(s0)
    80204538:	fd843783          	ld	a5,-40(s0)
    8020453c:	faf43023          	sd	a5,-96(s0)
    80204540:	fd043783          	ld	a5,-48(s0)
    80204544:	faf43423          	sd	a5,-88(s0)
        handle_exception(tf, &info);
    80204548:	f9040793          	addi	a5,s0,-112
    8020454c:	85be                	mv	a1,a5
    8020454e:	fe043503          	ld	a0,-32(s0)
    80204552:	fffff097          	auipc	ra,0xfffff
    80204556:	4d0080e7          	jalr	1232(ra) # 80203a22 <handle_exception>
    }

    usertrapret();
    8020455a:	00000097          	auipc	ra,0x0
    8020455e:	012080e7          	jalr	18(ra) # 8020456c <usertrapret>
}
    80204562:	0001                	nop
    80204564:	70a6                	ld	ra,104(sp)
    80204566:	7406                	ld	s0,96(sp)
    80204568:	6165                	addi	sp,sp,112
    8020456a:	8082                	ret

000000008020456c <usertrapret>:

void usertrapret(void) {
    8020456c:	7179                	addi	sp,sp,-48
    8020456e:	f406                	sd	ra,40(sp)
    80204570:	f022                	sd	s0,32(sp)
    80204572:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80204574:	00000097          	auipc	ra,0x0
    80204578:	5dc080e7          	jalr	1500(ra) # 80204b50 <myproc>
    8020457c:	fea43423          	sd	a0,-24(s0)
	
    // stvec 指向 trampoline.uservec
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    80204580:	00000717          	auipc	a4,0x0
    80204584:	33070713          	addi	a4,a4,816 # 802048b0 <trampoline>
    80204588:	77fd                	lui	a5,0xfffff
    8020458a:	973e                	add	a4,a4,a5
    8020458c:	00000797          	auipc	a5,0x0
    80204590:	32478793          	addi	a5,a5,804 # 802048b0 <trampoline>
    80204594:	40f707b3          	sub	a5,a4,a5
    80204598:	fef43023          	sd	a5,-32(s0)
    w_stvec(uservec_va);
    8020459c:	fe043503          	ld	a0,-32(s0)
    802045a0:	fffff097          	auipc	ra,0xfffff
    802045a4:	00c080e7          	jalr	12(ra) # 802035ac <w_stvec>

    w_sscratch((uint64)TRAPFRAME);
    802045a8:	7579                	lui	a0,0xffffe
    802045aa:	fffff097          	auipc	ra,0xfffff
    802045ae:	fa6080e7          	jalr	-90(ra) # 80203550 <w_sscratch>

    // 用户页表 satp
    uint64 user_satp = MAKE_SATP(p->pagetable);
    802045b2:	fe843783          	ld	a5,-24(s0)
    802045b6:	7fdc                	ld	a5,184(a5)
    802045b8:	00c7d713          	srli	a4,a5,0xc
    802045bc:	57fd                	li	a5,-1
    802045be:	17fe                	slli	a5,a5,0x3f
    802045c0:	8fd9                	or	a5,a5,a4
    802045c2:	fcf43c23          	sd	a5,-40(s0)

    // a0 = trapframe 的高地址映射
    register uint64 a0 asm("a0") = TRAPFRAME;
    802045c6:	7579                	lui	a0,0xffffe
    register uint64 a1 asm("a1") = user_satp;
    802045c8:	fd843583          	ld	a1,-40(s0)
    register void (*userret_fn)(uint64, uint64) asm("t0") = (void*)userret;
    802045cc:	00000797          	auipc	a5,0x0
    802045d0:	37a78793          	addi	a5,a5,890 # 80204946 <userret>
    802045d4:	82be                	mv	t0,a5
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(userret_fn) : "memory");
    802045d6:	8282                	jr	t0
}
    802045d8:	0001                	nop
    802045da:	70a2                	ld	ra,40(sp)
    802045dc:	7402                	ld	s0,32(sp)
    802045de:	6145                	addi	sp,sp,48
    802045e0:	8082                	ret

00000000802045e2 <write32>:
    802045e2:	7179                	addi	sp,sp,-48
    802045e4:	f406                	sd	ra,40(sp)
    802045e6:	f022                	sd	s0,32(sp)
    802045e8:	1800                	addi	s0,sp,48
    802045ea:	fca43c23          	sd	a0,-40(s0)
    802045ee:	87ae                	mv	a5,a1
    802045f0:	fcf42a23          	sw	a5,-44(s0)
    802045f4:	fd843783          	ld	a5,-40(s0)
    802045f8:	8b8d                	andi	a5,a5,3
    802045fa:	eb99                	bnez	a5,80204610 <write32+0x2e>
    802045fc:	fd843783          	ld	a5,-40(s0)
    80204600:	fef43423          	sd	a5,-24(s0)
    80204604:	fe843783          	ld	a5,-24(s0)
    80204608:	fd442703          	lw	a4,-44(s0)
    8020460c:	c398                	sw	a4,0(a5)
    8020460e:	a819                	j	80204624 <write32+0x42>
    80204610:	fd843583          	ld	a1,-40(s0)
    80204614:	00004517          	auipc	a0,0x4
    80204618:	74c50513          	addi	a0,a0,1868 # 80208d60 <etext+0x1d60>
    8020461c:	ffffc097          	auipc	ra,0xffffc
    80204620:	666080e7          	jalr	1638(ra) # 80200c82 <printf>
    80204624:	0001                	nop
    80204626:	70a2                	ld	ra,40(sp)
    80204628:	7402                	ld	s0,32(sp)
    8020462a:	6145                	addi	sp,sp,48
    8020462c:	8082                	ret

000000008020462e <read32>:
    8020462e:	7179                	addi	sp,sp,-48
    80204630:	f406                	sd	ra,40(sp)
    80204632:	f022                	sd	s0,32(sp)
    80204634:	1800                	addi	s0,sp,48
    80204636:	fca43c23          	sd	a0,-40(s0)
    8020463a:	fd843783          	ld	a5,-40(s0)
    8020463e:	8b8d                	andi	a5,a5,3
    80204640:	eb91                	bnez	a5,80204654 <read32+0x26>
    80204642:	fd843783          	ld	a5,-40(s0)
    80204646:	fef43423          	sd	a5,-24(s0)
    8020464a:	fe843783          	ld	a5,-24(s0)
    8020464e:	439c                	lw	a5,0(a5)
    80204650:	2781                	sext.w	a5,a5
    80204652:	a821                	j	8020466a <read32+0x3c>
    80204654:	fd843583          	ld	a1,-40(s0)
    80204658:	00004517          	auipc	a0,0x4
    8020465c:	73850513          	addi	a0,a0,1848 # 80208d90 <etext+0x1d90>
    80204660:	ffffc097          	auipc	ra,0xffffc
    80204664:	622080e7          	jalr	1570(ra) # 80200c82 <printf>
    80204668:	4781                	li	a5,0
    8020466a:	853e                	mv	a0,a5
    8020466c:	70a2                	ld	ra,40(sp)
    8020466e:	7402                	ld	s0,32(sp)
    80204670:	6145                	addi	sp,sp,48
    80204672:	8082                	ret

0000000080204674 <plic_init>:
void plic_init(void) {
    80204674:	1101                	addi	sp,sp,-32
    80204676:	ec06                	sd	ra,24(sp)
    80204678:	e822                	sd	s0,16(sp)
    8020467a:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    8020467c:	4785                	li	a5,1
    8020467e:	fef42623          	sw	a5,-20(s0)
    80204682:	a805                	j	802046b2 <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    80204684:	fec42783          	lw	a5,-20(s0)
    80204688:	0027979b          	slliw	a5,a5,0x2
    8020468c:	2781                	sext.w	a5,a5
    8020468e:	873e                	mv	a4,a5
    80204690:	0c0007b7          	lui	a5,0xc000
    80204694:	97ba                	add	a5,a5,a4
    80204696:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    8020469a:	4581                	li	a1,0
    8020469c:	fe043503          	ld	a0,-32(s0)
    802046a0:	00000097          	auipc	ra,0x0
    802046a4:	f42080e7          	jalr	-190(ra) # 802045e2 <write32>
    for (int i = 1; i <= 32; i++) {
    802046a8:	fec42783          	lw	a5,-20(s0)
    802046ac:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    802046ae:	fef42623          	sw	a5,-20(s0)
    802046b2:	fec42783          	lw	a5,-20(s0)
    802046b6:	0007871b          	sext.w	a4,a5
    802046ba:	02000793          	li	a5,32
    802046be:	fce7d3e3          	bge	a5,a4,80204684 <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    802046c2:	4585                	li	a1,1
    802046c4:	0c0007b7          	lui	a5,0xc000
    802046c8:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    802046cc:	00000097          	auipc	ra,0x0
    802046d0:	f16080e7          	jalr	-234(ra) # 802045e2 <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    802046d4:	4585                	li	a1,1
    802046d6:	0c0007b7          	lui	a5,0xc000
    802046da:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    802046de:	00000097          	auipc	ra,0x0
    802046e2:	f04080e7          	jalr	-252(ra) # 802045e2 <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    802046e6:	40200593          	li	a1,1026
    802046ea:	0c0027b7          	lui	a5,0xc002
    802046ee:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802046f2:	00000097          	auipc	ra,0x0
    802046f6:	ef0080e7          	jalr	-272(ra) # 802045e2 <write32>
    write32(PLIC_THRESHOLD, 0);
    802046fa:	4581                	li	a1,0
    802046fc:	0c201537          	lui	a0,0xc201
    80204700:	00000097          	auipc	ra,0x0
    80204704:	ee2080e7          	jalr	-286(ra) # 802045e2 <write32>
}
    80204708:	0001                	nop
    8020470a:	60e2                	ld	ra,24(sp)
    8020470c:	6442                	ld	s0,16(sp)
    8020470e:	6105                	addi	sp,sp,32
    80204710:	8082                	ret

0000000080204712 <plic_enable>:
void plic_enable(int irq) {
    80204712:	7179                	addi	sp,sp,-48
    80204714:	f406                	sd	ra,40(sp)
    80204716:	f022                	sd	s0,32(sp)
    80204718:	1800                	addi	s0,sp,48
    8020471a:	87aa                	mv	a5,a0
    8020471c:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204720:	0c0027b7          	lui	a5,0xc002
    80204724:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204728:	00000097          	auipc	ra,0x0
    8020472c:	f06080e7          	jalr	-250(ra) # 8020462e <read32>
    80204730:	87aa                	mv	a5,a0
    80204732:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    80204736:	fdc42783          	lw	a5,-36(s0)
    8020473a:	873e                	mv	a4,a5
    8020473c:	4785                	li	a5,1
    8020473e:	00e797bb          	sllw	a5,a5,a4
    80204742:	2781                	sext.w	a5,a5
    80204744:	2781                	sext.w	a5,a5
    80204746:	fec42703          	lw	a4,-20(s0)
    8020474a:	8fd9                	or	a5,a5,a4
    8020474c:	2781                	sext.w	a5,a5
    8020474e:	85be                	mv	a1,a5
    80204750:	0c0027b7          	lui	a5,0xc002
    80204754:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204758:	00000097          	auipc	ra,0x0
    8020475c:	e8a080e7          	jalr	-374(ra) # 802045e2 <write32>
}
    80204760:	0001                	nop
    80204762:	70a2                	ld	ra,40(sp)
    80204764:	7402                	ld	s0,32(sp)
    80204766:	6145                	addi	sp,sp,48
    80204768:	8082                	ret

000000008020476a <plic_disable>:
void plic_disable(int irq) {
    8020476a:	7179                	addi	sp,sp,-48
    8020476c:	f406                	sd	ra,40(sp)
    8020476e:	f022                	sd	s0,32(sp)
    80204770:	1800                	addi	s0,sp,48
    80204772:	87aa                	mv	a5,a0
    80204774:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204778:	0c0027b7          	lui	a5,0xc002
    8020477c:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204780:	00000097          	auipc	ra,0x0
    80204784:	eae080e7          	jalr	-338(ra) # 8020462e <read32>
    80204788:	87aa                	mv	a5,a0
    8020478a:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    8020478e:	fdc42783          	lw	a5,-36(s0)
    80204792:	873e                	mv	a4,a5
    80204794:	4785                	li	a5,1
    80204796:	00e797bb          	sllw	a5,a5,a4
    8020479a:	2781                	sext.w	a5,a5
    8020479c:	fff7c793          	not	a5,a5
    802047a0:	2781                	sext.w	a5,a5
    802047a2:	2781                	sext.w	a5,a5
    802047a4:	fec42703          	lw	a4,-20(s0)
    802047a8:	8ff9                	and	a5,a5,a4
    802047aa:	2781                	sext.w	a5,a5
    802047ac:	85be                	mv	a1,a5
    802047ae:	0c0027b7          	lui	a5,0xc002
    802047b2:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802047b6:	00000097          	auipc	ra,0x0
    802047ba:	e2c080e7          	jalr	-468(ra) # 802045e2 <write32>
}
    802047be:	0001                	nop
    802047c0:	70a2                	ld	ra,40(sp)
    802047c2:	7402                	ld	s0,32(sp)
    802047c4:	6145                	addi	sp,sp,48
    802047c6:	8082                	ret

00000000802047c8 <plic_claim>:
int plic_claim(void) {
    802047c8:	1141                	addi	sp,sp,-16
    802047ca:	e406                	sd	ra,8(sp)
    802047cc:	e022                	sd	s0,0(sp)
    802047ce:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    802047d0:	0c2017b7          	lui	a5,0xc201
    802047d4:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    802047d8:	00000097          	auipc	ra,0x0
    802047dc:	e56080e7          	jalr	-426(ra) # 8020462e <read32>
    802047e0:	87aa                	mv	a5,a0
    802047e2:	2781                	sext.w	a5,a5
    802047e4:	2781                	sext.w	a5,a5
}
    802047e6:	853e                	mv	a0,a5
    802047e8:	60a2                	ld	ra,8(sp)
    802047ea:	6402                	ld	s0,0(sp)
    802047ec:	0141                	addi	sp,sp,16
    802047ee:	8082                	ret

00000000802047f0 <plic_complete>:
void plic_complete(int irq) {
    802047f0:	1101                	addi	sp,sp,-32
    802047f2:	ec06                	sd	ra,24(sp)
    802047f4:	e822                	sd	s0,16(sp)
    802047f6:	1000                	addi	s0,sp,32
    802047f8:	87aa                	mv	a5,a0
    802047fa:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    802047fe:	fec42783          	lw	a5,-20(s0)
    80204802:	85be                	mv	a1,a5
    80204804:	0c2017b7          	lui	a5,0xc201
    80204808:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    8020480c:	00000097          	auipc	ra,0x0
    80204810:	dd6080e7          	jalr	-554(ra) # 802045e2 <write32>
    80204814:	0001                	nop
    80204816:	60e2                	ld	ra,24(sp)
    80204818:	6442                	ld	s0,16(sp)
    8020481a:	6105                	addi	sp,sp,32
    8020481c:	8082                	ret
	...

0000000080204820 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80204820:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80204822:	e006                	sd	ra,0(sp)
        sd gp, 16(sp)
    80204824:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80204826:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80204828:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8020482a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8020482c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    8020482e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80204830:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80204832:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80204834:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80204836:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80204838:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    8020483a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    8020483c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8020483e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80204840:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80204842:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80204844:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80204846:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80204848:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    8020484a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    8020484c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    8020484e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80204850:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80204852:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80204854:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80204856:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80204858:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    8020485a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    8020485c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    8020485e:	fffff097          	auipc	ra,0xfffff
    80204862:	07a080e7          	jalr	122(ra) # 802038d8 <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80204866:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80204868:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8020486a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8020486c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    8020486e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80204870:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80204872:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80204874:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80204876:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80204878:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8020487a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8020487c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8020487e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80204880:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80204882:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80204884:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80204886:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80204888:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    8020488a:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    8020488c:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    8020488e:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80204890:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80204892:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80204894:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80204896:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80204898:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    8020489a:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    8020489c:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8020489e:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    802048a0:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    802048a2:	10200073          	sret
    802048a6:	0001                	nop
    802048a8:	00000013          	nop
    802048ac:	00000013          	nop

00000000802048b0 <trampoline>:
trampoline:
.align 4

uservec:
    # 1. 取 trapframe 指针
    csrrw a0, sscratch, a0      # a0 = TRAPFRAME (用户页表下可访问), sscratch = user a0
    802048b0:	14051573          	csrrw	a0,sscratch,a0

    # 2. 在切换页表前，先读出关键字段到 t3–t6
    ld   t3, 0(a0)              # t3 = kernel_satp
    802048b4:	00053e03          	ld	t3,0(a0) # c201000 <_entry-0x73fff000>
    ld   t4, 8(a0)              # t4 = kernel_sp
    802048b8:	00853e83          	ld	t4,8(a0)
    ld   t5, 264(a0)            # t5 = usertrap
    802048bc:	10853f03          	ld	t5,264(a0)
	ld   t6, 272(a0)			# t6 = kernel_vec
    802048c0:	11053f83          	ld	t6,272(a0)

    # 3. 保存用户寄存器到 trapframe（仍在用户页表下）
    sd   ra, 48(a0)
    802048c4:	02153823          	sd	ra,48(a0)
    sd   sp, 56(a0)
    802048c8:	02253c23          	sd	sp,56(a0)
    sd   gp, 64(a0)
    802048cc:	04353023          	sd	gp,64(a0)
    sd   tp, 72(a0)
    802048d0:	04453423          	sd	tp,72(a0)
    sd   t0, 80(a0)
    802048d4:	04553823          	sd	t0,80(a0)
    sd   t1, 88(a0)
    802048d8:	04653c23          	sd	t1,88(a0)
    sd   t2, 96(a0)
    802048dc:	06753023          	sd	t2,96(a0)
    sd   s0, 104(a0)
    802048e0:	f520                	sd	s0,104(a0)
    sd   s1, 112(a0)
    802048e2:	f924                	sd	s1,112(a0)

    # 保存用户 a0：先取回 sscratch 里的原值
    csrr t2, sscratch
    802048e4:	140023f3          	csrr	t2,sscratch
    sd   t2, 120(a0)
    802048e8:	06753c23          	sd	t2,120(a0)

    sd   a1, 128(a0)
    802048ec:	e14c                	sd	a1,128(a0)
    sd   a2, 136(a0)
    802048ee:	e550                	sd	a2,136(a0)
    sd   a3, 144(a0)
    802048f0:	e954                	sd	a3,144(a0)
    sd   a4, 152(a0)
    802048f2:	ed58                	sd	a4,152(a0)
    sd   a5, 160(a0)
    802048f4:	f15c                	sd	a5,160(a0)
    sd   a6, 168(a0)
    802048f6:	0b053423          	sd	a6,168(a0)
    sd   a7, 176(a0)
    802048fa:	0b153823          	sd	a7,176(a0)
    sd   s2, 184(a0)
    802048fe:	0b253c23          	sd	s2,184(a0)
    sd   s3, 192(a0)
    80204902:	0d353023          	sd	s3,192(a0)
    sd   s4, 200(a0)
    80204906:	0d453423          	sd	s4,200(a0)
    sd   s5, 208(a0)
    8020490a:	0d553823          	sd	s5,208(a0)
    sd   s6, 216(a0)
    8020490e:	0d653c23          	sd	s6,216(a0)
    sd   s7, 224(a0)
    80204912:	0f753023          	sd	s7,224(a0)
    sd   s8, 232(a0)
    80204916:	0f853423          	sd	s8,232(a0)
    sd   s9, 240(a0)
    8020491a:	0f953823          	sd	s9,240(a0)
    sd   s10, 248(a0)
    8020491e:	0fa53c23          	sd	s10,248(a0)
    sd   s11, 256(a0)
    80204922:	11b53023          	sd	s11,256(a0)

    # 保存控制寄存器
    csrr t0, sstatus
    80204926:	100022f3          	csrr	t0,sstatus
    sd   t0, 24(a0)
    8020492a:	00553c23          	sd	t0,24(a0)
    csrr t1, sepc
    8020492e:	14102373          	csrr	t1,sepc
    sd   t1, 32(a0)
    80204932:	02653023          	sd	t1,32(a0)

    # 4. 切换到内核页表
    csrw satp, t3
    80204936:	180e1073          	csrw	satp,t3
    sfence.vma x0, x0
    8020493a:	12000073          	sfence.vma

    # 5. 切换到内核栈
    mv   sp, t4
    8020493e:	8176                	mv	sp,t4

    # 6. 设置 stvec 并跳转到 C 层 usertrap
    csrw stvec, t6
    80204940:	105f9073          	csrw	stvec,t6
    jr   t5
    80204944:	8f02                	jr	t5

0000000080204946 <userret>:
userret:
        mv t0, a0
    80204946:	82aa                	mv	t0,a0
        mv a0, a1
    80204948:	852e                	mv	a0,a1
        csrw satp, a0
    8020494a:	18051073          	csrw	satp,a0
        sfence.vma zero, zero
    8020494e:	12000073          	sfence.vma
        mv a0, t0
    80204952:	8516                	mv	a0,t0
        ld ra, 48(a0)
    80204954:	03053083          	ld	ra,48(a0)
        ld sp, 56(a0)
    80204958:	03853103          	ld	sp,56(a0)
        ld gp, 64(a0)
    8020495c:	04053183          	ld	gp,64(a0)
        ld tp, 72(a0)
    80204960:	04853203          	ld	tp,72(a0)
        ld t0, 80(a0)
    80204964:	05053283          	ld	t0,80(a0)
        ld t1, 88(a0)
    80204968:	05853303          	ld	t1,88(a0)
        ld t2, 96(a0)
    8020496c:	06053383          	ld	t2,96(a0)
        ld s0, 104(a0)
    80204970:	7520                	ld	s0,104(a0)
        ld s1, 112(a0)
    80204972:	7924                	ld	s1,112(a0)
        ld a1, 128(a0)
    80204974:	614c                	ld	a1,128(a0)
        ld a2, 136(a0)
    80204976:	6550                	ld	a2,136(a0)
        ld a3, 144(a0)
    80204978:	6954                	ld	a3,144(a0)
        ld a4, 152(a0)
    8020497a:	6d58                	ld	a4,152(a0)
        ld a5, 160(a0)
    8020497c:	715c                	ld	a5,160(a0)
        ld a6, 168(a0)
    8020497e:	0a853803          	ld	a6,168(a0)
        ld a7, 176(a0)
    80204982:	0b053883          	ld	a7,176(a0)
        ld s2, 184(a0)
    80204986:	0b853903          	ld	s2,184(a0)
        ld s3, 192(a0)
    8020498a:	0c053983          	ld	s3,192(a0)
        ld s4, 200(a0)
    8020498e:	0c853a03          	ld	s4,200(a0)
        ld s5, 208(a0)
    80204992:	0d053a83          	ld	s5,208(a0)
        ld s6, 216(a0)
    80204996:	0d853b03          	ld	s6,216(a0)
        ld s7, 224(a0)
    8020499a:	0e053b83          	ld	s7,224(a0)
        ld s8, 232(a0)
    8020499e:	0e853c03          	ld	s8,232(a0)
        ld s9, 240(a0)
    802049a2:	0f053c83          	ld	s9,240(a0)
        ld s10, 248(a0)
    802049a6:	0f853d03          	ld	s10,248(a0)
        ld s11, 256(a0)
    802049aa:	10053d83          	ld	s11,256(a0)

        ld t1, 32(a0)      # 恢复 sepc
    802049ae:	02053303          	ld	t1,32(a0)
        csrw sepc, t1
    802049b2:	14131073          	csrw	sepc,t1
        ld t2, 24(a0)      # 恢复 sstatus
    802049b6:	01853383          	ld	t2,24(a0)
        csrw sstatus, t2
    802049ba:	10039073          	csrw	sstatus,t2
		csrw sscratch, a0
    802049be:	14051073          	csrw	sscratch,a0
		ld a0, 120(a0)
    802049c2:	7d28                	ld	a0,120(a0)
    802049c4:	10200073          	sret
    802049c8:	00000013          	nop
    802049cc:	00000013          	nop

00000000802049d0 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    802049d0:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    802049d4:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    802049d8:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    802049da:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    802049dc:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    802049e0:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    802049e4:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    802049e8:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    802049ec:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    802049f0:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    802049f4:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    802049f8:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    802049fc:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80204a00:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80204a04:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80204a08:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80204a0c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80204a0e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80204a10:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80204a14:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80204a18:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80204a1c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80204a20:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80204a24:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80204a28:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80204a2c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80204a30:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80204a34:	0685bd83          	ld	s11,104(a1)
        
        ret
    80204a38:	8082                	ret

0000000080204a3a <r_sstatus>:
    p->state = RUNNABLE;
    
    // 获取当前返回地址
    register uint64 ra asm("ra");

    p->context.ra = ra;
    80204a3a:	1101                	addi	sp,sp,-32
    80204a3c:	ec22                	sd	s0,24(sp)
    80204a3e:	1000                	addi	s0,sp,32
    // 确保CPU上下文有有效的返回地址
    if (c->context.ra == 0) {
    80204a40:	100027f3          	csrr	a5,sstatus
    80204a44:	fef43423          	sd	a5,-24(s0)
        c->context.ra = (uint64)schedule;
    80204a48:	fe843783          	ld	a5,-24(s0)
        c->context.sp = (uint64)c + PGSIZE;
    80204a4c:	853e                	mv	a0,a5
    80204a4e:	6462                	ld	s0,24(sp)
    80204a50:	6105                	addi	sp,sp,32
    80204a52:	8082                	ret

0000000080204a54 <w_sstatus>:
    }
    80204a54:	1101                	addi	sp,sp,-32
    80204a56:	ec22                	sd	s0,24(sp)
    80204a58:	1000                	addi	s0,sp,32
    80204a5a:	fea43423          	sd	a0,-24(s0)
    
    80204a5e:	fe843783          	ld	a5,-24(s0)
    80204a62:	10079073          	csrw	sstatus,a5
    current_proc = 0;
    80204a66:	0001                	nop
    80204a68:	6462                	ld	s0,24(sp)
    80204a6a:	6105                	addi	sp,sp,32
    80204a6c:	8082                	ret

0000000080204a6e <intr_on>:
    swtch(&p->context, &c->context);

    intr_on();
}
void sleep(void *chan){
    struct proc *p = myproc();
    80204a6e:	1141                	addi	sp,sp,-16
    80204a70:	e406                	sd	ra,8(sp)
    80204a72:	e022                	sd	s0,0(sp)
    80204a74:	0800                	addi	s0,sp,16
    struct cpu *c = mycpu();
    80204a76:	00000097          	auipc	ra,0x0
    80204a7a:	fc4080e7          	jalr	-60(ra) # 80204a3a <r_sstatus>
    80204a7e:	87aa                	mv	a5,a0
    80204a80:	0027e793          	ori	a5,a5,2
    80204a84:	853e                	mv	a0,a5
    80204a86:	00000097          	auipc	ra,0x0
    80204a8a:	fce080e7          	jalr	-50(ra) # 80204a54 <w_sstatus>
    
    80204a8e:	0001                	nop
    80204a90:	60a2                	ld	ra,8(sp)
    80204a92:	6402                	ld	s0,0(sp)
    80204a94:	0141                	addi	sp,sp,16
    80204a96:	8082                	ret

0000000080204a98 <intr_off>:
    // 获取当前返回地址，确保唤醒后能回到正确位置
    register uint64 ra asm("ra");
    80204a98:	1141                	addi	sp,sp,-16
    80204a9a:	e406                	sd	ra,8(sp)
    80204a9c:	e022                	sd	s0,0(sp)
    80204a9e:	0800                	addi	s0,sp,16
    
    80204aa0:	00000097          	auipc	ra,0x0
    80204aa4:	f9a080e7          	jalr	-102(ra) # 80204a3a <r_sstatus>
    80204aa8:	87aa                	mv	a5,a0
    80204aaa:	9bf5                	andi	a5,a5,-3
    80204aac:	853e                	mv	a0,a5
    80204aae:	00000097          	auipc	ra,0x0
    80204ab2:	fa6080e7          	jalr	-90(ra) # 80204a54 <w_sstatus>
    // 关键修复：显式保存返回地址到进程上下文中
    80204ab6:	0001                	nop
    80204ab8:	60a2                	ld	ra,8(sp)
    80204aba:	6402                	ld	s0,0(sp)
    80204abc:	0141                	addi	sp,sp,16
    80204abe:	8082                	ret

0000000080204ac0 <w_stvec>:
    p->context.ra = ra;
    p->chan = chan;
    80204ac0:	1101                	addi	sp,sp,-32
    80204ac2:	ec22                	sd	s0,24(sp)
    80204ac4:	1000                	addi	s0,sp,32
    80204ac6:	fea43423          	sd	a0,-24(s0)
    p->state = SLEEPING;
    80204aca:	fe843783          	ld	a5,-24(s0)
    80204ace:	10579073          	csrw	stvec,a5
    
    80204ad2:	0001                	nop
    80204ad4:	6462                	ld	s0,24(sp)
    80204ad6:	6105                	addi	sp,sp,32
    80204ad8:	8082                	ret

0000000080204ada <assert>:
        
    schedule();
    
    panic("kexit should not return after schedule");
}
int kwait(int *status) {
    80204ada:	1101                	addi	sp,sp,-32
    80204adc:	ec06                	sd	ra,24(sp)
    80204ade:	e822                	sd	s0,16(sp)
    80204ae0:	1000                	addi	s0,sp,32
    80204ae2:	87aa                	mv	a5,a0
    80204ae4:	fef42623          	sw	a5,-20(s0)
    struct proc *p = myproc();
    80204ae8:	fec42783          	lw	a5,-20(s0)
    80204aec:	2781                	sext.w	a5,a5
    80204aee:	e79d                	bnez	a5,80204b1c <assert+0x42>
    
    80204af0:	18f00613          	li	a2,399
    80204af4:	00004597          	auipc	a1,0x4
    80204af8:	2cc58593          	addi	a1,a1,716 # 80208dc0 <etext+0x1dc0>
    80204afc:	00004517          	auipc	a0,0x4
    80204b00:	2d450513          	addi	a0,a0,724 # 80208dd0 <etext+0x1dd0>
    80204b04:	ffffc097          	auipc	ra,0xffffc
    80204b08:	17e080e7          	jalr	382(ra) # 80200c82 <printf>
    if (p == 0) {
    80204b0c:	00004517          	auipc	a0,0x4
    80204b10:	2ec50513          	addi	a0,a0,748 # 80208df8 <etext+0x1df8>
    80204b14:	ffffd097          	auipc	ra,0xffffd
    80204b18:	bba080e7          	jalr	-1094(ra) # 802016ce <panic>
        printf("Warning: kwait called with no current process\n");
        return -1;
    80204b1c:	0001                	nop
    80204b1e:	60e2                	ld	ra,24(sp)
    80204b20:	6442                	ld	s0,16(sp)
    80204b22:	6105                	addi	sp,sp,32
    80204b24:	8082                	ret

0000000080204b26 <shutdown>:
void shutdown() {
    80204b26:	1141                	addi	sp,sp,-16
    80204b28:	e406                	sd	ra,8(sp)
    80204b2a:	e022                	sd	s0,0(sp)
    80204b2c:	0800                	addi	s0,sp,16
	free_proc_table();
    80204b2e:	00000097          	auipc	ra,0x0
    80204b32:	3a2080e7          	jalr	930(ra) # 80204ed0 <free_proc_table>
    printf("关机\n");
    80204b36:	00004517          	auipc	a0,0x4
    80204b3a:	2ca50513          	addi	a0,a0,714 # 80208e00 <etext+0x1e00>
    80204b3e:	ffffc097          	auipc	ra,0xffffc
    80204b42:	144080e7          	jalr	324(ra) # 80200c82 <printf>
    asm volatile (
    80204b46:	48a1                	li	a7,8
    80204b48:	00000073          	ecall
    while (1) { }
    80204b4c:	0001                	nop
    80204b4e:	bffd                	j	80204b4c <shutdown+0x26>

0000000080204b50 <myproc>:
struct proc* myproc(void) {
    80204b50:	1141                	addi	sp,sp,-16
    80204b52:	e422                	sd	s0,8(sp)
    80204b54:	0800                	addi	s0,sp,16
    return current_proc;
    80204b56:	00007797          	auipc	a5,0x7
    80204b5a:	56a78793          	addi	a5,a5,1386 # 8020c0c0 <current_proc>
    80204b5e:	639c                	ld	a5,0(a5)
}
    80204b60:	853e                	mv	a0,a5
    80204b62:	6422                	ld	s0,8(sp)
    80204b64:	0141                	addi	sp,sp,16
    80204b66:	8082                	ret

0000000080204b68 <mycpu>:
struct cpu* mycpu(void) {
    80204b68:	1141                	addi	sp,sp,-16
    80204b6a:	e406                	sd	ra,8(sp)
    80204b6c:	e022                	sd	s0,0(sp)
    80204b6e:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80204b70:	00007797          	auipc	a5,0x7
    80204b74:	55878793          	addi	a5,a5,1368 # 8020c0c8 <current_cpu>
    80204b78:	639c                	ld	a5,0(a5)
    80204b7a:	ebb9                	bnez	a5,80204bd0 <mycpu+0x68>
        warning("current_cpu is NULL, initializing...\n");
    80204b7c:	00004517          	auipc	a0,0x4
    80204b80:	28c50513          	addi	a0,a0,652 # 80208e08 <etext+0x1e08>
    80204b84:	ffffd097          	auipc	ra,0xffffd
    80204b88:	b7e080e7          	jalr	-1154(ra) # 80201702 <warning>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    80204b8c:	07800613          	li	a2,120
    80204b90:	4581                	li	a1,0
    80204b92:	00008517          	auipc	a0,0x8
    80204b96:	cf650513          	addi	a0,a0,-778 # 8020c888 <cpu_instance.1>
    80204b9a:	ffffd097          	auipc	ra,0xffffd
    80204b9e:	272080e7          	jalr	626(ra) # 80201e0c <memset>
		current_cpu = &cpu_instance;
    80204ba2:	00007797          	auipc	a5,0x7
    80204ba6:	52678793          	addi	a5,a5,1318 # 8020c0c8 <current_cpu>
    80204baa:	00008717          	auipc	a4,0x8
    80204bae:	cde70713          	addi	a4,a4,-802 # 8020c888 <cpu_instance.1>
    80204bb2:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    80204bb4:	00007797          	auipc	a5,0x7
    80204bb8:	51478793          	addi	a5,a5,1300 # 8020c0c8 <current_cpu>
    80204bbc:	639c                	ld	a5,0(a5)
    80204bbe:	85be                	mv	a1,a5
    80204bc0:	00004517          	auipc	a0,0x4
    80204bc4:	27050513          	addi	a0,a0,624 # 80208e30 <etext+0x1e30>
    80204bc8:	ffffc097          	auipc	ra,0xffffc
    80204bcc:	0ba080e7          	jalr	186(ra) # 80200c82 <printf>
    return current_cpu;
    80204bd0:	00007797          	auipc	a5,0x7
    80204bd4:	4f878793          	addi	a5,a5,1272 # 8020c0c8 <current_cpu>
    80204bd8:	639c                	ld	a5,0(a5)
}
    80204bda:	853e                	mv	a0,a5
    80204bdc:	60a2                	ld	ra,8(sp)
    80204bde:	6402                	ld	s0,0(sp)
    80204be0:	0141                	addi	sp,sp,16
    80204be2:	8082                	ret

0000000080204be4 <return_to_user>:
void return_to_user(void) {
    80204be4:	7179                	addi	sp,sp,-48
    80204be6:	f406                	sd	ra,40(sp)
    80204be8:	f022                	sd	s0,32(sp)
    80204bea:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80204bec:	00000097          	auipc	ra,0x0
    80204bf0:	f64080e7          	jalr	-156(ra) # 80204b50 <myproc>
    80204bf4:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80204bf8:	fe843783          	ld	a5,-24(s0)
    80204bfc:	eb89                	bnez	a5,80204c0e <return_to_user+0x2a>
        panic("return_to_user: no current process");
    80204bfe:	00004517          	auipc	a0,0x4
    80204c02:	24a50513          	addi	a0,a0,586 # 80208e48 <etext+0x1e48>
    80204c06:	ffffd097          	auipc	ra,0xffffd
    80204c0a:	ac8080e7          	jalr	-1336(ra) # 802016ce <panic>
    if (p->chan != 0) {
    80204c0e:	fe843783          	ld	a5,-24(s0)
    80204c12:	73dc                	ld	a5,160(a5)
    80204c14:	c791                	beqz	a5,80204c20 <return_to_user+0x3c>
        p->chan = 0;
    80204c16:	fe843783          	ld	a5,-24(s0)
    80204c1a:	0a07b023          	sd	zero,160(a5)
        return;
    80204c1e:	a869                	j	80204cb8 <return_to_user+0xd4>
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    80204c20:	00000717          	auipc	a4,0x0
    80204c24:	c9070713          	addi	a4,a4,-880 # 802048b0 <trampoline>
    80204c28:	00000797          	auipc	a5,0x0
    80204c2c:	c8878793          	addi	a5,a5,-888 # 802048b0 <trampoline>
    80204c30:	40f707b3          	sub	a5,a4,a5
    80204c34:	873e                	mv	a4,a5
    80204c36:	77fd                	lui	a5,0xfffff
    80204c38:	97ba                	add	a5,a5,a4
    80204c3a:	853e                	mv	a0,a5
    80204c3c:	00000097          	auipc	ra,0x0
    80204c40:	e84080e7          	jalr	-380(ra) # 80204ac0 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80204c44:	00000717          	auipc	a4,0x0
    80204c48:	d0270713          	addi	a4,a4,-766 # 80204946 <userret>
    80204c4c:	00000797          	auipc	a5,0x0
    80204c50:	c6478793          	addi	a5,a5,-924 # 802048b0 <trampoline>
    80204c54:	40f707b3          	sub	a5,a4,a5
    80204c58:	873e                	mv	a4,a5
    80204c5a:	77fd                	lui	a5,0xfffff
    80204c5c:	97ba                	add	a5,a5,a4
    80204c5e:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    80204c62:	fe843783          	ld	a5,-24(s0)
    80204c66:	7fdc                	ld	a5,184(a5)
    80204c68:	00c7d713          	srli	a4,a5,0xc
    80204c6c:	57fd                	li	a5,-1
    80204c6e:	17fe                	slli	a5,a5,0x3f
    80204c70:	8fd9                	or	a5,a5,a4
    80204c72:	fcf43c23          	sd	a5,-40(s0)
	if ((trampoline_userret & ~(PGSIZE - 1)) != TRAMPOLINE) {
    80204c76:	fe043703          	ld	a4,-32(s0)
    80204c7a:	77fd                	lui	a5,0xfffff
    80204c7c:	8f7d                	and	a4,a4,a5
    80204c7e:	77fd                	lui	a5,0xfffff
    80204c80:	00f70a63          	beq	a4,a5,80204c94 <return_to_user+0xb0>
		panic("return_to_user: 跳转地址超出trampoline页范围");
    80204c84:	00004517          	auipc	a0,0x4
    80204c88:	1ec50513          	addi	a0,a0,492 # 80208e70 <etext+0x1e70>
    80204c8c:	ffffd097          	auipc	ra,0xffffd
    80204c90:	a42080e7          	jalr	-1470(ra) # 802016ce <panic>
    void (*userret_fn)(uint64, uint64) = (void (*)(uint64, uint64))trampoline_userret;
    80204c94:	fe043783          	ld	a5,-32(s0)
    80204c98:	fcf43823          	sd	a5,-48(s0)
    userret_fn(TRAPFRAME, satp);
    80204c9c:	fd043783          	ld	a5,-48(s0)
    80204ca0:	fd843583          	ld	a1,-40(s0)
    80204ca4:	7579                	lui	a0,0xffffe
    80204ca6:	9782                	jalr	a5
    panic("return_to_user: 不应该返回到这里");
    80204ca8:	00004517          	auipc	a0,0x4
    80204cac:	20050513          	addi	a0,a0,512 # 80208ea8 <etext+0x1ea8>
    80204cb0:	ffffd097          	auipc	ra,0xffffd
    80204cb4:	a1e080e7          	jalr	-1506(ra) # 802016ce <panic>
}
    80204cb8:	70a2                	ld	ra,40(sp)
    80204cba:	7402                	ld	s0,32(sp)
    80204cbc:	6145                	addi	sp,sp,48
    80204cbe:	8082                	ret

0000000080204cc0 <forkret>:
void forkret(void){
    80204cc0:	7179                	addi	sp,sp,-48
    80204cc2:	f406                	sd	ra,40(sp)
    80204cc4:	f022                	sd	s0,32(sp)
    80204cc6:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80204cc8:	00000097          	auipc	ra,0x0
    80204ccc:	e88080e7          	jalr	-376(ra) # 80204b50 <myproc>
    80204cd0:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80204cd4:	fe843783          	ld	a5,-24(s0)
    80204cd8:	eb89                	bnez	a5,80204cea <forkret+0x2a>
        panic("forkret: no current process");
    80204cda:	00004517          	auipc	a0,0x4
    80204cde:	1fe50513          	addi	a0,a0,510 # 80208ed8 <etext+0x1ed8>
    80204ce2:	ffffd097          	auipc	ra,0xffffd
    80204ce6:	9ec080e7          	jalr	-1556(ra) # 802016ce <panic>
    if (p->chan != 0) {
    80204cea:	fe843783          	ld	a5,-24(s0)
    80204cee:	73dc                	ld	a5,160(a5)
    80204cf0:	c791                	beqz	a5,80204cfc <forkret+0x3c>
        p->chan = 0;  // 清除通道标记
    80204cf2:	fe843783          	ld	a5,-24(s0)
    80204cf6:	0a07b023          	sd	zero,160(a5) # fffffffffffff0a0 <_bss_end+0xffffffff7fdf2790>
        return;  // 直接返回，继续执行原来的函数
    80204cfa:	a0a9                	j	80204d44 <forkret+0x84>
    uint64 entry = p->trapframe->epc;
    80204cfc:	fe843783          	ld	a5,-24(s0)
    80204d00:	63fc                	ld	a5,192(a5)
    80204d02:	739c                	ld	a5,32(a5)
    80204d04:	fef43023          	sd	a5,-32(s0)
	if (p->is_user){
    80204d08:	fe843783          	ld	a5,-24(s0)
    80204d0c:	0a87a783          	lw	a5,168(a5)
    80204d10:	c791                	beqz	a5,80204d1c <forkret+0x5c>
		return_to_user();
    80204d12:	00000097          	auipc	ra,0x0
    80204d16:	ed2080e7          	jalr	-302(ra) # 80204be4 <return_to_user>
    80204d1a:	a02d                	j	80204d44 <forkret+0x84>
	}else if (entry != 0) {
    80204d1c:	fe043783          	ld	a5,-32(s0)
    80204d20:	cf91                	beqz	a5,80204d3c <forkret+0x7c>
        void (*fn)(void) = (void(*)(void))entry;
    80204d22:	fe043783          	ld	a5,-32(s0)
    80204d26:	fcf43c23          	sd	a5,-40(s0)
        fn();  // 调用入口函数
    80204d2a:	fd843783          	ld	a5,-40(s0)
    80204d2e:	9782                	jalr	a5
        exit_proc(0);  // 如果入口函数返回，则退出进程
    80204d30:	4501                	li	a0,0
    80204d32:	00000097          	auipc	ra,0x0
    80204d36:	6aa080e7          	jalr	1706(ra) # 802053dc <exit_proc>
    80204d3a:	a029                	j	80204d44 <forkret+0x84>
        return_to_user();
    80204d3c:	00000097          	auipc	ra,0x0
    80204d40:	ea8080e7          	jalr	-344(ra) # 80204be4 <return_to_user>
}
    80204d44:	70a2                	ld	ra,40(sp)
    80204d46:	7402                	ld	s0,32(sp)
    80204d48:	6145                	addi	sp,sp,48
    80204d4a:	8082                	ret

0000000080204d4c <init_proc>:
void init_proc(void){
    80204d4c:	1101                	addi	sp,sp,-32
    80204d4e:	ec06                	sd	ra,24(sp)
    80204d50:	e822                	sd	s0,16(sp)
    80204d52:	1000                	addi	s0,sp,32
    for (int i = 0; i < PROC; i++) {
    80204d54:	fe042623          	sw	zero,-20(s0)
    80204d58:	aa81                	j	80204ea8 <init_proc+0x15c>
        void *page = alloc_page();
    80204d5a:	ffffe097          	auipc	ra,0xffffe
    80204d5e:	4a6080e7          	jalr	1190(ra) # 80203200 <alloc_page>
    80204d62:	fea43023          	sd	a0,-32(s0)
        if (!page) panic("init_proc: alloc_page failed for proc_table");
    80204d66:	fe043783          	ld	a5,-32(s0)
    80204d6a:	eb89                	bnez	a5,80204d7c <init_proc+0x30>
    80204d6c:	00004517          	auipc	a0,0x4
    80204d70:	18c50513          	addi	a0,a0,396 # 80208ef8 <etext+0x1ef8>
    80204d74:	ffffd097          	auipc	ra,0xffffd
    80204d78:	95a080e7          	jalr	-1702(ra) # 802016ce <panic>
        proc_table_mem[i] = page;
    80204d7c:	00008717          	auipc	a4,0x8
    80204d80:	90470713          	addi	a4,a4,-1788 # 8020c680 <proc_table_mem>
    80204d84:	fec42783          	lw	a5,-20(s0)
    80204d88:	078e                	slli	a5,a5,0x3
    80204d8a:	97ba                	add	a5,a5,a4
    80204d8c:	fe043703          	ld	a4,-32(s0)
    80204d90:	e398                	sd	a4,0(a5)
        proc_table[i] = (struct proc *)page;
    80204d92:	00007717          	auipc	a4,0x7
    80204d96:	6e670713          	addi	a4,a4,1766 # 8020c478 <proc_table>
    80204d9a:	fec42783          	lw	a5,-20(s0)
    80204d9e:	078e                	slli	a5,a5,0x3
    80204da0:	97ba                	add	a5,a5,a4
    80204da2:	fe043703          	ld	a4,-32(s0)
    80204da6:	e398                	sd	a4,0(a5)
        memset(proc_table[i], 0, sizeof(struct proc));
    80204da8:	00007717          	auipc	a4,0x7
    80204dac:	6d070713          	addi	a4,a4,1744 # 8020c478 <proc_table>
    80204db0:	fec42783          	lw	a5,-20(s0)
    80204db4:	078e                	slli	a5,a5,0x3
    80204db6:	97ba                	add	a5,a5,a4
    80204db8:	639c                	ld	a5,0(a5)
    80204dba:	0c800613          	li	a2,200
    80204dbe:	4581                	li	a1,0
    80204dc0:	853e                	mv	a0,a5
    80204dc2:	ffffd097          	auipc	ra,0xffffd
    80204dc6:	04a080e7          	jalr	74(ra) # 80201e0c <memset>
        proc_table[i]->state = UNUSED;
    80204dca:	00007717          	auipc	a4,0x7
    80204dce:	6ae70713          	addi	a4,a4,1710 # 8020c478 <proc_table>
    80204dd2:	fec42783          	lw	a5,-20(s0)
    80204dd6:	078e                	slli	a5,a5,0x3
    80204dd8:	97ba                	add	a5,a5,a4
    80204dda:	639c                	ld	a5,0(a5)
    80204ddc:	0007a023          	sw	zero,0(a5)
        proc_table[i]->pid = 0;
    80204de0:	00007717          	auipc	a4,0x7
    80204de4:	69870713          	addi	a4,a4,1688 # 8020c478 <proc_table>
    80204de8:	fec42783          	lw	a5,-20(s0)
    80204dec:	078e                	slli	a5,a5,0x3
    80204dee:	97ba                	add	a5,a5,a4
    80204df0:	639c                	ld	a5,0(a5)
    80204df2:	0007a223          	sw	zero,4(a5)
        proc_table[i]->kstack = 0;
    80204df6:	00007717          	auipc	a4,0x7
    80204dfa:	68270713          	addi	a4,a4,1666 # 8020c478 <proc_table>
    80204dfe:	fec42783          	lw	a5,-20(s0)
    80204e02:	078e                	slli	a5,a5,0x3
    80204e04:	97ba                	add	a5,a5,a4
    80204e06:	639c                	ld	a5,0(a5)
    80204e08:	0007b423          	sd	zero,8(a5)
        proc_table[i]->pagetable = 0;
    80204e0c:	00007717          	auipc	a4,0x7
    80204e10:	66c70713          	addi	a4,a4,1644 # 8020c478 <proc_table>
    80204e14:	fec42783          	lw	a5,-20(s0)
    80204e18:	078e                	slli	a5,a5,0x3
    80204e1a:	97ba                	add	a5,a5,a4
    80204e1c:	639c                	ld	a5,0(a5)
    80204e1e:	0a07bc23          	sd	zero,184(a5)
        proc_table[i]->trapframe = 0;
    80204e22:	00007717          	auipc	a4,0x7
    80204e26:	65670713          	addi	a4,a4,1622 # 8020c478 <proc_table>
    80204e2a:	fec42783          	lw	a5,-20(s0)
    80204e2e:	078e                	slli	a5,a5,0x3
    80204e30:	97ba                	add	a5,a5,a4
    80204e32:	639c                	ld	a5,0(a5)
    80204e34:	0c07b023          	sd	zero,192(a5)
        proc_table[i]->parent = 0;
    80204e38:	00007717          	auipc	a4,0x7
    80204e3c:	64070713          	addi	a4,a4,1600 # 8020c478 <proc_table>
    80204e40:	fec42783          	lw	a5,-20(s0)
    80204e44:	078e                	slli	a5,a5,0x3
    80204e46:	97ba                	add	a5,a5,a4
    80204e48:	639c                	ld	a5,0(a5)
    80204e4a:	0807bc23          	sd	zero,152(a5)
        proc_table[i]->chan = 0;
    80204e4e:	00007717          	auipc	a4,0x7
    80204e52:	62a70713          	addi	a4,a4,1578 # 8020c478 <proc_table>
    80204e56:	fec42783          	lw	a5,-20(s0)
    80204e5a:	078e                	slli	a5,a5,0x3
    80204e5c:	97ba                	add	a5,a5,a4
    80204e5e:	639c                	ld	a5,0(a5)
    80204e60:	0a07b023          	sd	zero,160(a5)
        proc_table[i]->exit_status = 0;
    80204e64:	00007717          	auipc	a4,0x7
    80204e68:	61470713          	addi	a4,a4,1556 # 8020c478 <proc_table>
    80204e6c:	fec42783          	lw	a5,-20(s0)
    80204e70:	078e                	slli	a5,a5,0x3
    80204e72:	97ba                	add	a5,a5,a4
    80204e74:	639c                	ld	a5,0(a5)
    80204e76:	0807a223          	sw	zero,132(a5)
        memset(&proc_table[i]->context, 0, sizeof(struct context));
    80204e7a:	00007717          	auipc	a4,0x7
    80204e7e:	5fe70713          	addi	a4,a4,1534 # 8020c478 <proc_table>
    80204e82:	fec42783          	lw	a5,-20(s0)
    80204e86:	078e                	slli	a5,a5,0x3
    80204e88:	97ba                	add	a5,a5,a4
    80204e8a:	639c                	ld	a5,0(a5)
    80204e8c:	07c1                	addi	a5,a5,16
    80204e8e:	07000613          	li	a2,112
    80204e92:	4581                	li	a1,0
    80204e94:	853e                	mv	a0,a5
    80204e96:	ffffd097          	auipc	ra,0xffffd
    80204e9a:	f76080e7          	jalr	-138(ra) # 80201e0c <memset>
    for (int i = 0; i < PROC; i++) {
    80204e9e:	fec42783          	lw	a5,-20(s0)
    80204ea2:	2785                	addiw	a5,a5,1
    80204ea4:	fef42623          	sw	a5,-20(s0)
    80204ea8:	fec42783          	lw	a5,-20(s0)
    80204eac:	0007871b          	sext.w	a4,a5
    80204eb0:	03f00793          	li	a5,63
    80204eb4:	eae7d3e3          	bge	a5,a4,80204d5a <init_proc+0xe>
    proc_table_pages = PROC; // 每个进程一页
    80204eb8:	00007797          	auipc	a5,0x7
    80204ebc:	7c078793          	addi	a5,a5,1984 # 8020c678 <proc_table_pages>
    80204ec0:	04000713          	li	a4,64
    80204ec4:	c398                	sw	a4,0(a5)
}
    80204ec6:	0001                	nop
    80204ec8:	60e2                	ld	ra,24(sp)
    80204eca:	6442                	ld	s0,16(sp)
    80204ecc:	6105                	addi	sp,sp,32
    80204ece:	8082                	ret

0000000080204ed0 <free_proc_table>:
void free_proc_table(void) {
    80204ed0:	1101                	addi	sp,sp,-32
    80204ed2:	ec06                	sd	ra,24(sp)
    80204ed4:	e822                	sd	s0,16(sp)
    80204ed6:	1000                	addi	s0,sp,32
    for (int i = 0; i < proc_table_pages; i++) {
    80204ed8:	fe042623          	sw	zero,-20(s0)
    80204edc:	a025                	j	80204f04 <free_proc_table+0x34>
        free_page(proc_table_mem[i]);
    80204ede:	00007717          	auipc	a4,0x7
    80204ee2:	7a270713          	addi	a4,a4,1954 # 8020c680 <proc_table_mem>
    80204ee6:	fec42783          	lw	a5,-20(s0)
    80204eea:	078e                	slli	a5,a5,0x3
    80204eec:	97ba                	add	a5,a5,a4
    80204eee:	639c                	ld	a5,0(a5)
    80204ef0:	853e                	mv	a0,a5
    80204ef2:	ffffe097          	auipc	ra,0xffffe
    80204ef6:	37a080e7          	jalr	890(ra) # 8020326c <free_page>
    for (int i = 0; i < proc_table_pages; i++) {
    80204efa:	fec42783          	lw	a5,-20(s0)
    80204efe:	2785                	addiw	a5,a5,1
    80204f00:	fef42623          	sw	a5,-20(s0)
    80204f04:	00007797          	auipc	a5,0x7
    80204f08:	77478793          	addi	a5,a5,1908 # 8020c678 <proc_table_pages>
    80204f0c:	4398                	lw	a4,0(a5)
    80204f0e:	fec42783          	lw	a5,-20(s0)
    80204f12:	2781                	sext.w	a5,a5
    80204f14:	fce7c5e3          	blt	a5,a4,80204ede <free_proc_table+0xe>
}
    80204f18:	0001                	nop
    80204f1a:	0001                	nop
    80204f1c:	60e2                	ld	ra,24(sp)
    80204f1e:	6442                	ld	s0,16(sp)
    80204f20:	6105                	addi	sp,sp,32
    80204f22:	8082                	ret

0000000080204f24 <alloc_proc>:
struct proc* alloc_proc(int is_user) {
    80204f24:	7139                	addi	sp,sp,-64
    80204f26:	fc06                	sd	ra,56(sp)
    80204f28:	f822                	sd	s0,48(sp)
    80204f2a:	0080                	addi	s0,sp,64
    80204f2c:	87aa                	mv	a5,a0
    80204f2e:	fcf42623          	sw	a5,-52(s0)
    for(int i = 0;i<PROC;i++) {
    80204f32:	fe042623          	sw	zero,-20(s0)
    80204f36:	aa85                	j	802050a6 <alloc_proc+0x182>
		struct proc *p = proc_table[i];
    80204f38:	00007717          	auipc	a4,0x7
    80204f3c:	54070713          	addi	a4,a4,1344 # 8020c478 <proc_table>
    80204f40:	fec42783          	lw	a5,-20(s0)
    80204f44:	078e                	slli	a5,a5,0x3
    80204f46:	97ba                	add	a5,a5,a4
    80204f48:	639c                	ld	a5,0(a5)
    80204f4a:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    80204f4e:	fe043783          	ld	a5,-32(s0)
    80204f52:	439c                	lw	a5,0(a5)
    80204f54:	14079463          	bnez	a5,8020509c <alloc_proc+0x178>
            p->pid = i;
    80204f58:	fe043783          	ld	a5,-32(s0)
    80204f5c:	fec42703          	lw	a4,-20(s0)
    80204f60:	c3d8                	sw	a4,4(a5)
            p->state = USED;
    80204f62:	fe043783          	ld	a5,-32(s0)
    80204f66:	4705                	li	a4,1
    80204f68:	c398                	sw	a4,0(a5)
			p->is_user = is_user;
    80204f6a:	fe043783          	ld	a5,-32(s0)
    80204f6e:	fcc42703          	lw	a4,-52(s0)
    80204f72:	0ae7a423          	sw	a4,168(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    80204f76:	ffffe097          	auipc	ra,0xffffe
    80204f7a:	28a080e7          	jalr	650(ra) # 80203200 <alloc_page>
    80204f7e:	872a                	mv	a4,a0
    80204f80:	fe043783          	ld	a5,-32(s0)
    80204f84:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    80204f86:	fe043783          	ld	a5,-32(s0)
    80204f8a:	63fc                	ld	a5,192(a5)
    80204f8c:	eb99                	bnez	a5,80204fa2 <alloc_proc+0x7e>
                p->state = UNUSED;
    80204f8e:	fe043783          	ld	a5,-32(s0)
    80204f92:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80204f96:	fe043783          	ld	a5,-32(s0)
    80204f9a:	0007a223          	sw	zero,4(a5)
                return 0;
    80204f9e:	4781                	li	a5,0
    80204fa0:	aa21                	j	802050b8 <alloc_proc+0x194>
			if(p->is_user){
    80204fa2:	fe043783          	ld	a5,-32(s0)
    80204fa6:	0a87a783          	lw	a5,168(a5)
    80204faa:	c3b9                	beqz	a5,80204ff0 <alloc_proc+0xcc>
				p->pagetable = create_pagetable();
    80204fac:	ffffd097          	auipc	ra,0xffffd
    80204fb0:	0bc080e7          	jalr	188(ra) # 80202068 <create_pagetable>
    80204fb4:	872a                	mv	a4,a0
    80204fb6:	fe043783          	ld	a5,-32(s0)
    80204fba:	ffd8                	sd	a4,184(a5)
				if(p->pagetable == 0){
    80204fbc:	fe043783          	ld	a5,-32(s0)
    80204fc0:	7fdc                	ld	a5,184(a5)
    80204fc2:	ef9d                	bnez	a5,80205000 <alloc_proc+0xdc>
					free_page(p->trapframe);
    80204fc4:	fe043783          	ld	a5,-32(s0)
    80204fc8:	63fc                	ld	a5,192(a5)
    80204fca:	853e                	mv	a0,a5
    80204fcc:	ffffe097          	auipc	ra,0xffffe
    80204fd0:	2a0080e7          	jalr	672(ra) # 8020326c <free_page>
					p->trapframe = 0;
    80204fd4:	fe043783          	ld	a5,-32(s0)
    80204fd8:	0c07b023          	sd	zero,192(a5)
					p->state = UNUSED;
    80204fdc:	fe043783          	ld	a5,-32(s0)
    80204fe0:	0007a023          	sw	zero,0(a5)
					p->pid = 0;
    80204fe4:	fe043783          	ld	a5,-32(s0)
    80204fe8:	0007a223          	sw	zero,4(a5)
					return 0;
    80204fec:	4781                	li	a5,0
    80204fee:	a0e9                	j	802050b8 <alloc_proc+0x194>
				p->pagetable = kernel_pagetable;
    80204ff0:	00007797          	auipc	a5,0x7
    80204ff4:	0b078793          	addi	a5,a5,176 # 8020c0a0 <kernel_pagetable>
    80204ff8:	6398                	ld	a4,0(a5)
    80204ffa:	fe043783          	ld	a5,-32(s0)
    80204ffe:	ffd8                	sd	a4,184(a5)
            void *kstack_mem = alloc_page();
    80205000:	ffffe097          	auipc	ra,0xffffe
    80205004:	200080e7          	jalr	512(ra) # 80203200 <alloc_page>
    80205008:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    8020500c:	fd843783          	ld	a5,-40(s0)
    80205010:	e3b9                	bnez	a5,80205056 <alloc_proc+0x132>
                free_page(p->trapframe);
    80205012:	fe043783          	ld	a5,-32(s0)
    80205016:	63fc                	ld	a5,192(a5)
    80205018:	853e                	mv	a0,a5
    8020501a:	ffffe097          	auipc	ra,0xffffe
    8020501e:	252080e7          	jalr	594(ra) # 8020326c <free_page>
                free_pagetable(p->pagetable);
    80205022:	fe043783          	ld	a5,-32(s0)
    80205026:	7fdc                	ld	a5,184(a5)
    80205028:	853e                	mv	a0,a5
    8020502a:	ffffd097          	auipc	ra,0xffffd
    8020502e:	40e080e7          	jalr	1038(ra) # 80202438 <free_pagetable>
                p->trapframe = 0;
    80205032:	fe043783          	ld	a5,-32(s0)
    80205036:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    8020503a:	fe043783          	ld	a5,-32(s0)
    8020503e:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    80205042:	fe043783          	ld	a5,-32(s0)
    80205046:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    8020504a:	fe043783          	ld	a5,-32(s0)
    8020504e:	0007a223          	sw	zero,4(a5)
                return 0;
    80205052:	4781                	li	a5,0
    80205054:	a095                	j	802050b8 <alloc_proc+0x194>
            p->kstack = (uint64)kstack_mem;
    80205056:	fd843703          	ld	a4,-40(s0)
    8020505a:	fe043783          	ld	a5,-32(s0)
    8020505e:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    80205060:	fe043783          	ld	a5,-32(s0)
    80205064:	07c1                	addi	a5,a5,16
    80205066:	07000613          	li	a2,112
    8020506a:	4581                	li	a1,0
    8020506c:	853e                	mv	a0,a5
    8020506e:	ffffd097          	auipc	ra,0xffffd
    80205072:	d9e080e7          	jalr	-610(ra) # 80201e0c <memset>
            p->context.ra = (uint64)forkret;
    80205076:	00000717          	auipc	a4,0x0
    8020507a:	c4a70713          	addi	a4,a4,-950 # 80204cc0 <forkret>
    8020507e:	fe043783          	ld	a5,-32(s0)
    80205082:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    80205084:	fe043783          	ld	a5,-32(s0)
    80205088:	6798                	ld	a4,8(a5)
    8020508a:	6785                	lui	a5,0x1
    8020508c:	17c1                	addi	a5,a5,-16 # ff0 <_entry-0x801ff010>
    8020508e:	973e                	add	a4,a4,a5
    80205090:	fe043783          	ld	a5,-32(s0)
    80205094:	ef98                	sd	a4,24(a5)
            return p;
    80205096:	fe043783          	ld	a5,-32(s0)
    8020509a:	a839                	j	802050b8 <alloc_proc+0x194>
    for(int i = 0;i<PROC;i++) {
    8020509c:	fec42783          	lw	a5,-20(s0)
    802050a0:	2785                	addiw	a5,a5,1
    802050a2:	fef42623          	sw	a5,-20(s0)
    802050a6:	fec42783          	lw	a5,-20(s0)
    802050aa:	0007871b          	sext.w	a4,a5
    802050ae:	03f00793          	li	a5,63
    802050b2:	e8e7d3e3          	bge	a5,a4,80204f38 <alloc_proc+0x14>
    return 0;
    802050b6:	4781                	li	a5,0
}
    802050b8:	853e                	mv	a0,a5
    802050ba:	70e2                	ld	ra,56(sp)
    802050bc:	7442                	ld	s0,48(sp)
    802050be:	6121                	addi	sp,sp,64
    802050c0:	8082                	ret

00000000802050c2 <free_proc>:
void free_proc(struct proc *p){
    802050c2:	1101                	addi	sp,sp,-32
    802050c4:	ec06                	sd	ra,24(sp)
    802050c6:	e822                	sd	s0,16(sp)
    802050c8:	1000                	addi	s0,sp,32
    802050ca:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    802050ce:	fe843783          	ld	a5,-24(s0)
    802050d2:	63fc                	ld	a5,192(a5)
    802050d4:	cb89                	beqz	a5,802050e6 <free_proc+0x24>
        free_page(p->trapframe);
    802050d6:	fe843783          	ld	a5,-24(s0)
    802050da:	63fc                	ld	a5,192(a5)
    802050dc:	853e                	mv	a0,a5
    802050de:	ffffe097          	auipc	ra,0xffffe
    802050e2:	18e080e7          	jalr	398(ra) # 8020326c <free_page>
    p->trapframe = 0;
    802050e6:	fe843783          	ld	a5,-24(s0)
    802050ea:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable && p->pagetable != kernel_pagetable)
    802050ee:	fe843783          	ld	a5,-24(s0)
    802050f2:	7fdc                	ld	a5,184(a5)
    802050f4:	c39d                	beqz	a5,8020511a <free_proc+0x58>
    802050f6:	fe843783          	ld	a5,-24(s0)
    802050fa:	7fd8                	ld	a4,184(a5)
    802050fc:	00007797          	auipc	a5,0x7
    80205100:	fa478793          	addi	a5,a5,-92 # 8020c0a0 <kernel_pagetable>
    80205104:	639c                	ld	a5,0(a5)
    80205106:	00f70a63          	beq	a4,a5,8020511a <free_proc+0x58>
        free_pagetable(p->pagetable);
    8020510a:	fe843783          	ld	a5,-24(s0)
    8020510e:	7fdc                	ld	a5,184(a5)
    80205110:	853e                	mv	a0,a5
    80205112:	ffffd097          	auipc	ra,0xffffd
    80205116:	326080e7          	jalr	806(ra) # 80202438 <free_pagetable>
    p->pagetable = 0;
    8020511a:	fe843783          	ld	a5,-24(s0)
    8020511e:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    80205122:	fe843783          	ld	a5,-24(s0)
    80205126:	679c                	ld	a5,8(a5)
    80205128:	cb89                	beqz	a5,8020513a <free_proc+0x78>
        free_page((void*)p->kstack);
    8020512a:	fe843783          	ld	a5,-24(s0)
    8020512e:	679c                	ld	a5,8(a5)
    80205130:	853e                	mv	a0,a5
    80205132:	ffffe097          	auipc	ra,0xffffe
    80205136:	13a080e7          	jalr	314(ra) # 8020326c <free_page>
    p->kstack = 0;
    8020513a:	fe843783          	ld	a5,-24(s0)
    8020513e:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    80205142:	fe843783          	ld	a5,-24(s0)
    80205146:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    8020514a:	fe843783          	ld	a5,-24(s0)
    8020514e:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    80205152:	fe843783          	ld	a5,-24(s0)
    80205156:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    8020515a:	fe843783          	ld	a5,-24(s0)
    8020515e:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    80205162:	fe843783          	ld	a5,-24(s0)
    80205166:	07c1                	addi	a5,a5,16
    80205168:	07000613          	li	a2,112
    8020516c:	4581                	li	a1,0
    8020516e:	853e                	mv	a0,a5
    80205170:	ffffd097          	auipc	ra,0xffffd
    80205174:	c9c080e7          	jalr	-868(ra) # 80201e0c <memset>
}
    80205178:	0001                	nop
    8020517a:	60e2                	ld	ra,24(sp)
    8020517c:	6442                	ld	s0,16(sp)
    8020517e:	6105                	addi	sp,sp,32
    80205180:	8082                	ret

0000000080205182 <create_kernel_proc>:
int create_kernel_proc(void (*entry)(void)) {
    80205182:	7179                	addi	sp,sp,-48
    80205184:	f406                	sd	ra,40(sp)
    80205186:	f022                	sd	s0,32(sp)
    80205188:	1800                	addi	s0,sp,48
    8020518a:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc(0);
    8020518e:	4501                	li	a0,0
    80205190:	00000097          	auipc	ra,0x0
    80205194:	d94080e7          	jalr	-620(ra) # 80204f24 <alloc_proc>
    80205198:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    8020519c:	fe843783          	ld	a5,-24(s0)
    802051a0:	e399                	bnez	a5,802051a6 <create_kernel_proc+0x24>
    802051a2:	57fd                	li	a5,-1
    802051a4:	a089                	j	802051e6 <create_kernel_proc+0x64>
    p->trapframe->epc = (uint64)entry;
    802051a6:	fe843783          	ld	a5,-24(s0)
    802051aa:	63fc                	ld	a5,192(a5)
    802051ac:	fd843703          	ld	a4,-40(s0)
    802051b0:	f398                	sd	a4,32(a5)
    p->state = RUNNABLE;
    802051b2:	fe843783          	ld	a5,-24(s0)
    802051b6:	470d                	li	a4,3
    802051b8:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    802051ba:	00000097          	auipc	ra,0x0
    802051be:	996080e7          	jalr	-1642(ra) # 80204b50 <myproc>
    802051c2:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    802051c6:	fe043783          	ld	a5,-32(s0)
    802051ca:	c799                	beqz	a5,802051d8 <create_kernel_proc+0x56>
        p->parent = parent;
    802051cc:	fe843783          	ld	a5,-24(s0)
    802051d0:	fe043703          	ld	a4,-32(s0)
    802051d4:	efd8                	sd	a4,152(a5)
    802051d6:	a029                	j	802051e0 <create_kernel_proc+0x5e>
        p->parent = NULL;
    802051d8:	fe843783          	ld	a5,-24(s0)
    802051dc:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    802051e0:	fe843783          	ld	a5,-24(s0)
    802051e4:	43dc                	lw	a5,4(a5)
}
    802051e6:	853e                	mv	a0,a5
    802051e8:	70a2                	ld	ra,40(sp)
    802051ea:	7402                	ld	s0,32(sp)
    802051ec:	6145                	addi	sp,sp,48
    802051ee:	8082                	ret

00000000802051f0 <create_user_proc>:
int create_user_proc(const void *user_bin, int bin_size) {
    802051f0:	715d                	addi	sp,sp,-80
    802051f2:	e486                	sd	ra,72(sp)
    802051f4:	e0a2                	sd	s0,64(sp)
    802051f6:	0880                	addi	s0,sp,80
    802051f8:	faa43c23          	sd	a0,-72(s0)
    802051fc:	87ae                	mv	a5,a1
    802051fe:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = alloc_proc(1); // 1 表示用户进程
    80205202:	4505                	li	a0,1
    80205204:	00000097          	auipc	ra,0x0
    80205208:	d20080e7          	jalr	-736(ra) # 80204f24 <alloc_proc>
    8020520c:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    80205210:	fe843783          	ld	a5,-24(s0)
    80205214:	e399                	bnez	a5,8020521a <create_user_proc+0x2a>
    80205216:	57fd                	li	a5,-1
    80205218:	aa6d                	j	802053d2 <create_user_proc+0x1e2>
    uint64 user_entry = 0x10000;
    8020521a:	67c1                	lui	a5,0x10
    8020521c:	fef43023          	sd	a5,-32(s0)
    uint64 user_stack = 0x20000;
    80205220:	000207b7          	lui	a5,0x20
    80205224:	fcf43c23          	sd	a5,-40(s0)
    void *page = alloc_page();
    80205228:	ffffe097          	auipc	ra,0xffffe
    8020522c:	fd8080e7          	jalr	-40(ra) # 80203200 <alloc_page>
    80205230:	fca43823          	sd	a0,-48(s0)
    if (!page) { free_proc(p); return -1; }
    80205234:	fd043783          	ld	a5,-48(s0)
    80205238:	eb89                	bnez	a5,8020524a <create_user_proc+0x5a>
    8020523a:	fe843503          	ld	a0,-24(s0)
    8020523e:	00000097          	auipc	ra,0x0
    80205242:	e84080e7          	jalr	-380(ra) # 802050c2 <free_proc>
    80205246:	57fd                	li	a5,-1
    80205248:	a269                	j	802053d2 <create_user_proc+0x1e2>
    map_page(p->pagetable, user_entry, (uint64)page, PTE_R | PTE_W | PTE_X | PTE_U);
    8020524a:	fe843783          	ld	a5,-24(s0)
    8020524e:	7fdc                	ld	a5,184(a5)
    80205250:	fd043703          	ld	a4,-48(s0)
    80205254:	46f9                	li	a3,30
    80205256:	863a                	mv	a2,a4
    80205258:	fe043583          	ld	a1,-32(s0)
    8020525c:	853e                	mv	a0,a5
    8020525e:	ffffd097          	auipc	ra,0xffffd
    80205262:	07a080e7          	jalr	122(ra) # 802022d8 <map_page>
    memcpy((void*)page, user_bin, bin_size);
    80205266:	fb442783          	lw	a5,-76(s0)
    8020526a:	863e                	mv	a2,a5
    8020526c:	fb843583          	ld	a1,-72(s0)
    80205270:	fd043503          	ld	a0,-48(s0)
    80205274:	ffffd097          	auipc	ra,0xffffd
    80205278:	ca4080e7          	jalr	-860(ra) # 80201f18 <memcpy>
    void *stack_page = alloc_page();
    8020527c:	ffffe097          	auipc	ra,0xffffe
    80205280:	f84080e7          	jalr	-124(ra) # 80203200 <alloc_page>
    80205284:	fca43423          	sd	a0,-56(s0)
    if (!stack_page) { free_proc(p); return -1; }
    80205288:	fc843783          	ld	a5,-56(s0)
    8020528c:	eb89                	bnez	a5,8020529e <create_user_proc+0xae>
    8020528e:	fe843503          	ld	a0,-24(s0)
    80205292:	00000097          	auipc	ra,0x0
    80205296:	e30080e7          	jalr	-464(ra) # 802050c2 <free_proc>
    8020529a:	57fd                	li	a5,-1
    8020529c:	aa1d                	j	802053d2 <create_user_proc+0x1e2>
    map_page(p->pagetable, user_stack - PGSIZE, (uint64)stack_page, PTE_R | PTE_W | PTE_U);
    8020529e:	fe843783          	ld	a5,-24(s0)
    802052a2:	7fc8                	ld	a0,184(a5)
    802052a4:	fd843703          	ld	a4,-40(s0)
    802052a8:	77fd                	lui	a5,0xfffff
    802052aa:	97ba                	add	a5,a5,a4
    802052ac:	fc843703          	ld	a4,-56(s0)
    802052b0:	46d9                	li	a3,22
    802052b2:	863a                	mv	a2,a4
    802052b4:	85be                	mv	a1,a5
    802052b6:	ffffd097          	auipc	ra,0xffffd
    802052ba:	022080e7          	jalr	34(ra) # 802022d8 <map_page>
    if (map_page(p->pagetable, TRAPFRAME, (uint64)p->trapframe, PTE_R | PTE_W) != 0) {
    802052be:	fe843783          	ld	a5,-24(s0)
    802052c2:	7fd8                	ld	a4,184(a5)
    802052c4:	fe843783          	ld	a5,-24(s0)
    802052c8:	63fc                	ld	a5,192(a5)
    802052ca:	4699                	li	a3,6
    802052cc:	863e                	mv	a2,a5
    802052ce:	75f9                	lui	a1,0xffffe
    802052d0:	853a                	mv	a0,a4
    802052d2:	ffffd097          	auipc	ra,0xffffd
    802052d6:	006080e7          	jalr	6(ra) # 802022d8 <map_page>
    802052da:	87aa                	mv	a5,a0
    802052dc:	cb89                	beqz	a5,802052ee <create_user_proc+0xfe>
        free_proc(p);
    802052de:	fe843503          	ld	a0,-24(s0)
    802052e2:	00000097          	auipc	ra,0x0
    802052e6:	de0080e7          	jalr	-544(ra) # 802050c2 <free_proc>
        return -1;
    802052ea:	57fd                	li	a5,-1
    802052ec:	a0dd                	j	802053d2 <create_user_proc+0x1e2>
	memset(p->trapframe, 0, sizeof(*p->trapframe));
    802052ee:	fe843783          	ld	a5,-24(s0)
    802052f2:	63fc                	ld	a5,192(a5)
    802052f4:	11800613          	li	a2,280
    802052f8:	4581                	li	a1,0
    802052fa:	853e                	mv	a0,a5
    802052fc:	ffffd097          	auipc	ra,0xffffd
    80205300:	b10080e7          	jalr	-1264(ra) # 80201e0c <memset>
	p->trapframe->epc = user_entry; // 应为 0x10000
    80205304:	fe843783          	ld	a5,-24(s0)
    80205308:	63fc                	ld	a5,192(a5)
    8020530a:	fe043703          	ld	a4,-32(s0)
    8020530e:	f398                	sd	a4,32(a5)
	p->trapframe->sp = user_stack;  // 应为 0x20000
    80205310:	fe843783          	ld	a5,-24(s0)
    80205314:	63fc                	ld	a5,192(a5)
    80205316:	fd843703          	ld	a4,-40(s0)
    8020531a:	ff98                	sd	a4,56(a5)
	p->trapframe->sstatus = (1UL << 5); // 0x20
    8020531c:	fe843783          	ld	a5,-24(s0)
    80205320:	63fc                	ld	a5,192(a5)
    80205322:	02000713          	li	a4,32
    80205326:	ef98                	sd	a4,24(a5)
	p->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable);
    80205328:	00007797          	auipc	a5,0x7
    8020532c:	d7878793          	addi	a5,a5,-648 # 8020c0a0 <kernel_pagetable>
    80205330:	639c                	ld	a5,0(a5)
    80205332:	00c7d693          	srli	a3,a5,0xc
    80205336:	fe843783          	ld	a5,-24(s0)
    8020533a:	63fc                	ld	a5,192(a5)
    8020533c:	577d                	li	a4,-1
    8020533e:	177e                	slli	a4,a4,0x3f
    80205340:	8f55                	or	a4,a4,a3
    80205342:	e398                	sd	a4,0(a5)
	p->trapframe->kernel_sp = p->kstack + PGSIZE;   // 内核栈顶
    80205344:	fe843783          	ld	a5,-24(s0)
    80205348:	6794                	ld	a3,8(a5)
    8020534a:	fe843783          	ld	a5,-24(s0)
    8020534e:	63fc                	ld	a5,192(a5)
    80205350:	6705                	lui	a4,0x1
    80205352:	9736                	add	a4,a4,a3
    80205354:	e798                	sd	a4,8(a5)
	p->trapframe->usertrap  = (uint64)usertrap;     // C 层 trap 处理函数
    80205356:	fe843783          	ld	a5,-24(s0)
    8020535a:	63fc                	ld	a5,192(a5)
    8020535c:	fffff717          	auipc	a4,0xfffff
    80205360:	0c270713          	addi	a4,a4,194 # 8020441e <usertrap>
    80205364:	10e7b423          	sd	a4,264(a5)
	p->trapframe->kernel_vec = (uint64)kernelvec;
    80205368:	fe843783          	ld	a5,-24(s0)
    8020536c:	63fc                	ld	a5,192(a5)
    8020536e:	fffff717          	auipc	a4,0xfffff
    80205372:	4b270713          	addi	a4,a4,1202 # 80204820 <kernelvec>
    80205376:	10e7b823          	sd	a4,272(a5)
    p->state = RUNNABLE;
    8020537a:	fe843783          	ld	a5,-24(s0)
    8020537e:	470d                	li	a4,3
    80205380:	c398                	sw	a4,0(a5)
	if (map_page(p->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_X | PTE_R) != 0) {
    80205382:	fe843783          	ld	a5,-24(s0)
    80205386:	7fd8                	ld	a4,184(a5)
    80205388:	00007797          	auipc	a5,0x7
    8020538c:	d2078793          	addi	a5,a5,-736 # 8020c0a8 <trampoline_phys_addr>
    80205390:	639c                	ld	a5,0(a5)
    80205392:	46a9                	li	a3,10
    80205394:	863e                	mv	a2,a5
    80205396:	75fd                	lui	a1,0xfffff
    80205398:	853a                	mv	a0,a4
    8020539a:	ffffd097          	auipc	ra,0xffffd
    8020539e:	f3e080e7          	jalr	-194(ra) # 802022d8 <map_page>
    802053a2:	87aa                	mv	a5,a0
    802053a4:	cb89                	beqz	a5,802053b6 <create_user_proc+0x1c6>
		free_proc(p);
    802053a6:	fe843503          	ld	a0,-24(s0)
    802053aa:	00000097          	auipc	ra,0x0
    802053ae:	d18080e7          	jalr	-744(ra) # 802050c2 <free_proc>
		return -1;
    802053b2:	57fd                	li	a5,-1
    802053b4:	a839                	j	802053d2 <create_user_proc+0x1e2>
    struct proc *parent = myproc();
    802053b6:	fffff097          	auipc	ra,0xfffff
    802053ba:	79a080e7          	jalr	1946(ra) # 80204b50 <myproc>
    802053be:	fca43023          	sd	a0,-64(s0)
    p->parent = parent ? parent : NULL;
    802053c2:	fe843783          	ld	a5,-24(s0)
    802053c6:	fc043703          	ld	a4,-64(s0)
    802053ca:	efd8                	sd	a4,152(a5)
    return p->pid;
    802053cc:	fe843783          	ld	a5,-24(s0)
    802053d0:	43dc                	lw	a5,4(a5)
}
    802053d2:	853e                	mv	a0,a5
    802053d4:	60a6                	ld	ra,72(sp)
    802053d6:	6406                	ld	s0,64(sp)
    802053d8:	6161                	addi	sp,sp,80
    802053da:	8082                	ret

00000000802053dc <exit_proc>:
void exit_proc(int status) {
    802053dc:	7179                	addi	sp,sp,-48
    802053de:	f406                	sd	ra,40(sp)
    802053e0:	f022                	sd	s0,32(sp)
    802053e2:	1800                	addi	s0,sp,48
    802053e4:	87aa                	mv	a5,a0
    802053e6:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    802053ea:	fffff097          	auipc	ra,0xfffff
    802053ee:	766080e7          	jalr	1894(ra) # 80204b50 <myproc>
    802053f2:	fea43423          	sd	a0,-24(s0)
    p->exit_status = status;
    802053f6:	fe843783          	ld	a5,-24(s0)
    802053fa:	fdc42703          	lw	a4,-36(s0)
    802053fe:	08e7a223          	sw	a4,132(a5)
    kexit();
    80205402:	00000097          	auipc	ra,0x0
    80205406:	39a080e7          	jalr	922(ra) # 8020579c <kexit>
}
    8020540a:	0001                	nop
    8020540c:	70a2                	ld	ra,40(sp)
    8020540e:	7402                	ld	s0,32(sp)
    80205410:	6145                	addi	sp,sp,48
    80205412:	8082                	ret

0000000080205414 <wait_proc>:
int wait_proc(int *status) {
    80205414:	1101                	addi	sp,sp,-32
    80205416:	ec06                	sd	ra,24(sp)
    80205418:	e822                	sd	s0,16(sp)
    8020541a:	1000                	addi	s0,sp,32
    8020541c:	fea43423          	sd	a0,-24(s0)
    return kwait(status);
    80205420:	fe843503          	ld	a0,-24(s0)
    80205424:	00000097          	auipc	ra,0x0
    80205428:	438080e7          	jalr	1080(ra) # 8020585c <kwait>
    8020542c:	87aa                	mv	a5,a0
}
    8020542e:	853e                	mv	a0,a5
    80205430:	60e2                	ld	ra,24(sp)
    80205432:	6442                	ld	s0,16(sp)
    80205434:	6105                	addi	sp,sp,32
    80205436:	8082                	ret

0000000080205438 <kfork>:
int kfork(void) {
    80205438:	1101                	addi	sp,sp,-32
    8020543a:	ec06                	sd	ra,24(sp)
    8020543c:	e822                	sd	s0,16(sp)
    8020543e:	1000                	addi	s0,sp,32
    struct proc *parent = myproc();
    80205440:	fffff097          	auipc	ra,0xfffff
    80205444:	710080e7          	jalr	1808(ra) # 80204b50 <myproc>
    80205448:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc(parent->is_user);
    8020544c:	fe843783          	ld	a5,-24(s0)
    80205450:	0a87a783          	lw	a5,168(a5)
    80205454:	853e                	mv	a0,a5
    80205456:	00000097          	auipc	ra,0x0
    8020545a:	ace080e7          	jalr	-1330(ra) # 80204f24 <alloc_proc>
    8020545e:	fea43023          	sd	a0,-32(s0)
    if(child == 0)
    80205462:	fe043783          	ld	a5,-32(s0)
    80205466:	e399                	bnez	a5,8020546c <kfork+0x34>
        return -1;
    80205468:	57fd                	li	a5,-1
    8020546a:	a059                	j	802054f0 <kfork+0xb8>
    if(uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0){
    8020546c:	fe843783          	ld	a5,-24(s0)
    80205470:	7fd8                	ld	a4,184(a5)
    80205472:	fe043783          	ld	a5,-32(s0)
    80205476:	7fd4                	ld	a3,184(a5)
    80205478:	fe843783          	ld	a5,-24(s0)
    8020547c:	7bdc                	ld	a5,176(a5)
    8020547e:	863e                	mv	a2,a5
    80205480:	85b6                	mv	a1,a3
    80205482:	853a                	mv	a0,a4
    80205484:	ffffe097          	auipc	ra,0xffffe
    80205488:	bac080e7          	jalr	-1108(ra) # 80203030 <uvmcopy>
    8020548c:	87aa                	mv	a5,a0
    8020548e:	0007da63          	bgez	a5,802054a2 <kfork+0x6a>
        free_proc(child);
    80205492:	fe043503          	ld	a0,-32(s0)
    80205496:	00000097          	auipc	ra,0x0
    8020549a:	c2c080e7          	jalr	-980(ra) # 802050c2 <free_proc>
        return -1;
    8020549e:	57fd                	li	a5,-1
    802054a0:	a881                	j	802054f0 <kfork+0xb8>
    child->sz = parent->sz;
    802054a2:	fe843783          	ld	a5,-24(s0)
    802054a6:	7bd8                	ld	a4,176(a5)
    802054a8:	fe043783          	ld	a5,-32(s0)
    802054ac:	fbd8                	sd	a4,176(a5)
    *(child->trapframe) = *(parent->trapframe);
    802054ae:	fe843783          	ld	a5,-24(s0)
    802054b2:	63f8                	ld	a4,192(a5)
    802054b4:	fe043783          	ld	a5,-32(s0)
    802054b8:	63fc                	ld	a5,192(a5)
    802054ba:	86be                	mv	a3,a5
    802054bc:	11800793          	li	a5,280
    802054c0:	863e                	mv	a2,a5
    802054c2:	85ba                	mv	a1,a4
    802054c4:	8536                	mv	a0,a3
    802054c6:	ffffd097          	auipc	ra,0xffffd
    802054ca:	a52080e7          	jalr	-1454(ra) # 80201f18 <memcpy>
    child->trapframe->a0 = 0; // 子进程fork返回值为0
    802054ce:	fe043783          	ld	a5,-32(s0)
    802054d2:	63fc                	ld	a5,192(a5)
    802054d4:	0607bc23          	sd	zero,120(a5)
    child->state = RUNNABLE;
    802054d8:	fe043783          	ld	a5,-32(s0)
    802054dc:	470d                	li	a4,3
    802054de:	c398                	sw	a4,0(a5)
    child->parent = parent;
    802054e0:	fe043783          	ld	a5,-32(s0)
    802054e4:	fe843703          	ld	a4,-24(s0)
    802054e8:	efd8                	sd	a4,152(a5)
    return child->pid;
    802054ea:	fe043783          	ld	a5,-32(s0)
    802054ee:	43dc                	lw	a5,4(a5)
}
    802054f0:	853e                	mv	a0,a5
    802054f2:	60e2                	ld	ra,24(sp)
    802054f4:	6442                	ld	s0,16(sp)
    802054f6:	6105                	addi	sp,sp,32
    802054f8:	8082                	ret

00000000802054fa <schedule>:
void schedule(void) {
    802054fa:	7179                	addi	sp,sp,-48
    802054fc:	f406                	sd	ra,40(sp)
    802054fe:	f022                	sd	s0,32(sp)
    80205500:	1800                	addi	s0,sp,48
  struct cpu *c = mycpu();
    80205502:	fffff097          	auipc	ra,0xfffff
    80205506:	666080e7          	jalr	1638(ra) # 80204b68 <mycpu>
    8020550a:	fea43423          	sd	a0,-24(s0)
  if (!initialized) {
    8020550e:	00007797          	auipc	a5,0x7
    80205512:	3f278793          	addi	a5,a5,1010 # 8020c900 <initialized.0>
    80205516:	439c                	lw	a5,0(a5)
    80205518:	ef85                	bnez	a5,80205550 <schedule+0x56>
    if(c == 0) {
    8020551a:	fe843783          	ld	a5,-24(s0)
    8020551e:	eb89                	bnez	a5,80205530 <schedule+0x36>
      panic("schedule: no current cpu");
    80205520:	00004517          	auipc	a0,0x4
    80205524:	a0850513          	addi	a0,a0,-1528 # 80208f28 <etext+0x1f28>
    80205528:	ffffc097          	auipc	ra,0xffffc
    8020552c:	1a6080e7          	jalr	422(ra) # 802016ce <panic>
    c->proc = 0;
    80205530:	fe843783          	ld	a5,-24(s0)
    80205534:	0007b023          	sd	zero,0(a5)
    current_proc = 0;
    80205538:	00007797          	auipc	a5,0x7
    8020553c:	b8878793          	addi	a5,a5,-1144 # 8020c0c0 <current_proc>
    80205540:	0007b023          	sd	zero,0(a5)
    initialized = 1;
    80205544:	00007797          	auipc	a5,0x7
    80205548:	3bc78793          	addi	a5,a5,956 # 8020c900 <initialized.0>
    8020554c:	4705                	li	a4,1
    8020554e:	c398                	sw	a4,0(a5)
    intr_on();
    80205550:	fffff097          	auipc	ra,0xfffff
    80205554:	51e080e7          	jalr	1310(ra) # 80204a6e <intr_on>
    for(int i = 0; i < PROC; i++) {
    80205558:	fe042223          	sw	zero,-28(s0)
    8020555c:	a069                	j	802055e6 <schedule+0xec>
        struct proc *p = proc_table[i];
    8020555e:	00007717          	auipc	a4,0x7
    80205562:	f1a70713          	addi	a4,a4,-230 # 8020c478 <proc_table>
    80205566:	fe442783          	lw	a5,-28(s0)
    8020556a:	078e                	slli	a5,a5,0x3
    8020556c:	97ba                	add	a5,a5,a4
    8020556e:	639c                	ld	a5,0(a5)
    80205570:	fcf43c23          	sd	a5,-40(s0)
      	if(p->state == RUNNABLE) {
    80205574:	fd843783          	ld	a5,-40(s0)
    80205578:	439c                	lw	a5,0(a5)
    8020557a:	873e                	mv	a4,a5
    8020557c:	478d                	li	a5,3
    8020557e:	04f71f63          	bne	a4,a5,802055dc <schedule+0xe2>
			p->state = RUNNING;
    80205582:	fd843783          	ld	a5,-40(s0)
    80205586:	4711                	li	a4,4
    80205588:	c398                	sw	a4,0(a5)
			c->proc = p;
    8020558a:	fe843783          	ld	a5,-24(s0)
    8020558e:	fd843703          	ld	a4,-40(s0)
    80205592:	e398                	sd	a4,0(a5)
			current_proc = p;
    80205594:	00007797          	auipc	a5,0x7
    80205598:	b2c78793          	addi	a5,a5,-1236 # 8020c0c0 <current_proc>
    8020559c:	fd843703          	ld	a4,-40(s0)
    802055a0:	e398                	sd	a4,0(a5)
			swtch(&c->context, &p->context);
    802055a2:	fe843783          	ld	a5,-24(s0)
    802055a6:	00878713          	addi	a4,a5,8
    802055aa:	fd843783          	ld	a5,-40(s0)
    802055ae:	07c1                	addi	a5,a5,16
    802055b0:	85be                	mv	a1,a5
    802055b2:	853a                	mv	a0,a4
    802055b4:	fffff097          	auipc	ra,0xfffff
    802055b8:	41c080e7          	jalr	1052(ra) # 802049d0 <swtch>
			c = mycpu();
    802055bc:	fffff097          	auipc	ra,0xfffff
    802055c0:	5ac080e7          	jalr	1452(ra) # 80204b68 <mycpu>
    802055c4:	fea43423          	sd	a0,-24(s0)
			c->proc = 0;
    802055c8:	fe843783          	ld	a5,-24(s0)
    802055cc:	0007b023          	sd	zero,0(a5)
			current_proc = 0;
    802055d0:	00007797          	auipc	a5,0x7
    802055d4:	af078793          	addi	a5,a5,-1296 # 8020c0c0 <current_proc>
    802055d8:	0007b023          	sd	zero,0(a5)
    for(int i = 0; i < PROC; i++) {
    802055dc:	fe442783          	lw	a5,-28(s0)
    802055e0:	2785                	addiw	a5,a5,1
    802055e2:	fef42223          	sw	a5,-28(s0)
    802055e6:	fe442783          	lw	a5,-28(s0)
    802055ea:	0007871b          	sext.w	a4,a5
    802055ee:	03f00793          	li	a5,63
    802055f2:	f6e7d6e3          	bge	a5,a4,8020555e <schedule+0x64>
    intr_on();
    802055f6:	bfa9                	j	80205550 <schedule+0x56>

00000000802055f8 <yield>:
void yield(void) {
    802055f8:	1101                	addi	sp,sp,-32
    802055fa:	ec06                	sd	ra,24(sp)
    802055fc:	e822                	sd	s0,16(sp)
    802055fe:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80205600:	fffff097          	auipc	ra,0xfffff
    80205604:	550080e7          	jalr	1360(ra) # 80204b50 <myproc>
    80205608:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    8020560c:	fe843783          	ld	a5,-24(s0)
    80205610:	c7cd                	beqz	a5,802056ba <yield+0xc2>
    if (p->state != RUNNING) {
    80205612:	fe843783          	ld	a5,-24(s0)
    80205616:	439c                	lw	a5,0(a5)
    80205618:	873e                	mv	a4,a5
    8020561a:	4791                	li	a5,4
    8020561c:	00f70f63          	beq	a4,a5,8020563a <yield+0x42>
        warning("yield when status is not RUNNING (%d)\n", p->state);
    80205620:	fe843783          	ld	a5,-24(s0)
    80205624:	439c                	lw	a5,0(a5)
    80205626:	85be                	mv	a1,a5
    80205628:	00004517          	auipc	a0,0x4
    8020562c:	92050513          	addi	a0,a0,-1760 # 80208f48 <etext+0x1f48>
    80205630:	ffffc097          	auipc	ra,0xffffc
    80205634:	0d2080e7          	jalr	210(ra) # 80201702 <warning>
        return;
    80205638:	a051                	j	802056bc <yield+0xc4>
    intr_off();
    8020563a:	fffff097          	auipc	ra,0xfffff
    8020563e:	45e080e7          	jalr	1118(ra) # 80204a98 <intr_off>
    struct cpu *c = mycpu();
    80205642:	fffff097          	auipc	ra,0xfffff
    80205646:	526080e7          	jalr	1318(ra) # 80204b68 <mycpu>
    8020564a:	fea43023          	sd	a0,-32(s0)
    p->state = RUNNABLE;
    8020564e:	fe843783          	ld	a5,-24(s0)
    80205652:	470d                	li	a4,3
    80205654:	c398                	sw	a4,0(a5)
    p->context.ra = ra;
    80205656:	8706                	mv	a4,ra
    80205658:	fe843783          	ld	a5,-24(s0)
    8020565c:	eb98                	sd	a4,16(a5)
    if (c->context.ra == 0) {
    8020565e:	fe043783          	ld	a5,-32(s0)
    80205662:	679c                	ld	a5,8(a5)
    80205664:	ef99                	bnez	a5,80205682 <yield+0x8a>
        c->context.ra = (uint64)schedule;
    80205666:	00000717          	auipc	a4,0x0
    8020566a:	e9470713          	addi	a4,a4,-364 # 802054fa <schedule>
    8020566e:	fe043783          	ld	a5,-32(s0)
    80205672:	e798                	sd	a4,8(a5)
        c->context.sp = (uint64)c + PGSIZE;
    80205674:	fe043703          	ld	a4,-32(s0)
    80205678:	6785                	lui	a5,0x1
    8020567a:	973e                	add	a4,a4,a5
    8020567c:	fe043783          	ld	a5,-32(s0)
    80205680:	eb98                	sd	a4,16(a5)
    current_proc = 0;
    80205682:	00007797          	auipc	a5,0x7
    80205686:	a3e78793          	addi	a5,a5,-1474 # 8020c0c0 <current_proc>
    8020568a:	0007b023          	sd	zero,0(a5)
    c->proc = 0;
    8020568e:	fe043783          	ld	a5,-32(s0)
    80205692:	0007b023          	sd	zero,0(a5)
    swtch(&p->context, &c->context);
    80205696:	fe843783          	ld	a5,-24(s0)
    8020569a:	01078713          	addi	a4,a5,16
    8020569e:	fe043783          	ld	a5,-32(s0)
    802056a2:	07a1                	addi	a5,a5,8
    802056a4:	85be                	mv	a1,a5
    802056a6:	853a                	mv	a0,a4
    802056a8:	fffff097          	auipc	ra,0xfffff
    802056ac:	328080e7          	jalr	808(ra) # 802049d0 <swtch>
    intr_on();
    802056b0:	fffff097          	auipc	ra,0xfffff
    802056b4:	3be080e7          	jalr	958(ra) # 80204a6e <intr_on>
    802056b8:	a011                	j	802056bc <yield+0xc4>
        return;
    802056ba:	0001                	nop
}
    802056bc:	60e2                	ld	ra,24(sp)
    802056be:	6442                	ld	s0,16(sp)
    802056c0:	6105                	addi	sp,sp,32
    802056c2:	8082                	ret

00000000802056c4 <sleep>:
void sleep(void *chan){
    802056c4:	7179                	addi	sp,sp,-48
    802056c6:	f406                	sd	ra,40(sp)
    802056c8:	f022                	sd	s0,32(sp)
    802056ca:	1800                	addi	s0,sp,48
    802056cc:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = myproc();
    802056d0:	fffff097          	auipc	ra,0xfffff
    802056d4:	480080e7          	jalr	1152(ra) # 80204b50 <myproc>
    802056d8:	fea43423          	sd	a0,-24(s0)
    struct cpu *c = mycpu();
    802056dc:	fffff097          	auipc	ra,0xfffff
    802056e0:	48c080e7          	jalr	1164(ra) # 80204b68 <mycpu>
    802056e4:	fea43023          	sd	a0,-32(s0)
    p->context.ra = ra;
    802056e8:	8706                	mv	a4,ra
    802056ea:	fe843783          	ld	a5,-24(s0)
    802056ee:	eb98                	sd	a4,16(a5)
    p->chan = chan;
    802056f0:	fe843783          	ld	a5,-24(s0)
    802056f4:	fd843703          	ld	a4,-40(s0)
    802056f8:	f3d8                	sd	a4,160(a5)
    p->state = SLEEPING;
    802056fa:	fe843783          	ld	a5,-24(s0)
    802056fe:	4709                	li	a4,2
    80205700:	c398                	sw	a4,0(a5)
    swtch(&p->context, &c->context);
    80205702:	fe843783          	ld	a5,-24(s0)
    80205706:	01078713          	addi	a4,a5,16
    8020570a:	fe043783          	ld	a5,-32(s0)
    8020570e:	07a1                	addi	a5,a5,8
    80205710:	85be                	mv	a1,a5
    80205712:	853a                	mv	a0,a4
    80205714:	fffff097          	auipc	ra,0xfffff
    80205718:	2bc080e7          	jalr	700(ra) # 802049d0 <swtch>
    p->chan = 0;  // 显式清除通道标记
    8020571c:	fe843783          	ld	a5,-24(s0)
    80205720:	0a07b023          	sd	zero,160(a5)
}
    80205724:	0001                	nop
    80205726:	70a2                	ld	ra,40(sp)
    80205728:	7402                	ld	s0,32(sp)
    8020572a:	6145                	addi	sp,sp,48
    8020572c:	8082                	ret

000000008020572e <wakeup>:
void wakeup(void *chan) {
    8020572e:	7179                	addi	sp,sp,-48
    80205730:	f422                	sd	s0,40(sp)
    80205732:	1800                	addi	s0,sp,48
    80205734:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < PROC; i++) {
    80205738:	fe042623          	sw	zero,-20(s0)
    8020573c:	a099                	j	80205782 <wakeup+0x54>
        struct proc *p = proc_table[i];
    8020573e:	00007717          	auipc	a4,0x7
    80205742:	d3a70713          	addi	a4,a4,-710 # 8020c478 <proc_table>
    80205746:	fec42783          	lw	a5,-20(s0)
    8020574a:	078e                	slli	a5,a5,0x3
    8020574c:	97ba                	add	a5,a5,a4
    8020574e:	639c                	ld	a5,0(a5)
    80205750:	fef43023          	sd	a5,-32(s0)
        if(p->state == SLEEPING && p->chan == chan) {
    80205754:	fe043783          	ld	a5,-32(s0)
    80205758:	439c                	lw	a5,0(a5)
    8020575a:	873e                	mv	a4,a5
    8020575c:	4789                	li	a5,2
    8020575e:	00f71d63          	bne	a4,a5,80205778 <wakeup+0x4a>
    80205762:	fe043783          	ld	a5,-32(s0)
    80205766:	73dc                	ld	a5,160(a5)
    80205768:	fd843703          	ld	a4,-40(s0)
    8020576c:	00f71663          	bne	a4,a5,80205778 <wakeup+0x4a>
            p->state = RUNNABLE;
    80205770:	fe043783          	ld	a5,-32(s0)
    80205774:	470d                	li	a4,3
    80205776:	c398                	sw	a4,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205778:	fec42783          	lw	a5,-20(s0)
    8020577c:	2785                	addiw	a5,a5,1
    8020577e:	fef42623          	sw	a5,-20(s0)
    80205782:	fec42783          	lw	a5,-20(s0)
    80205786:	0007871b          	sext.w	a4,a5
    8020578a:	03f00793          	li	a5,63
    8020578e:	fae7d8e3          	bge	a5,a4,8020573e <wakeup+0x10>
}
    80205792:	0001                	nop
    80205794:	0001                	nop
    80205796:	7422                	ld	s0,40(sp)
    80205798:	6145                	addi	sp,sp,48
    8020579a:	8082                	ret

000000008020579c <kexit>:
void kexit() {
    8020579c:	1101                	addi	sp,sp,-32
    8020579e:	ec06                	sd	ra,24(sp)
    802057a0:	e822                	sd	s0,16(sp)
    802057a2:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    802057a4:	fffff097          	auipc	ra,0xfffff
    802057a8:	3ac080e7          	jalr	940(ra) # 80204b50 <myproc>
    802057ac:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    802057b0:	fe843783          	ld	a5,-24(s0)
    802057b4:	eb89                	bnez	a5,802057c6 <kexit+0x2a>
        panic("kexit: no current process");
    802057b6:	00003517          	auipc	a0,0x3
    802057ba:	7ba50513          	addi	a0,a0,1978 # 80208f70 <etext+0x1f70>
    802057be:	ffffc097          	auipc	ra,0xffffc
    802057c2:	f10080e7          	jalr	-240(ra) # 802016ce <panic>
    if (!p->parent){
    802057c6:	fe843783          	ld	a5,-24(s0)
    802057ca:	6fdc                	ld	a5,152(a5)
    802057cc:	e789                	bnez	a5,802057d6 <kexit+0x3a>
		shutdown();
    802057ce:	fffff097          	auipc	ra,0xfffff
    802057d2:	358080e7          	jalr	856(ra) # 80204b26 <shutdown>
    p->state = ZOMBIE;
    802057d6:	fe843783          	ld	a5,-24(s0)
    802057da:	4715                	li	a4,5
    802057dc:	c398                	sw	a4,0(a5)
    void *chan = (void*)p->parent;
    802057de:	fe843783          	ld	a5,-24(s0)
    802057e2:	6fdc                	ld	a5,152(a5)
    802057e4:	fef43023          	sd	a5,-32(s0)
    if (p->parent->state == SLEEPING && p->parent->chan == chan) {
    802057e8:	fe843783          	ld	a5,-24(s0)
    802057ec:	6fdc                	ld	a5,152(a5)
    802057ee:	439c                	lw	a5,0(a5)
    802057f0:	873e                	mv	a4,a5
    802057f2:	4789                	li	a5,2
    802057f4:	02f71063          	bne	a4,a5,80205814 <kexit+0x78>
    802057f8:	fe843783          	ld	a5,-24(s0)
    802057fc:	6fdc                	ld	a5,152(a5)
    802057fe:	73dc                	ld	a5,160(a5)
    80205800:	fe043703          	ld	a4,-32(s0)
    80205804:	00f71863          	bne	a4,a5,80205814 <kexit+0x78>
        wakeup(chan);
    80205808:	fe043503          	ld	a0,-32(s0)
    8020580c:	00000097          	auipc	ra,0x0
    80205810:	f22080e7          	jalr	-222(ra) # 8020572e <wakeup>
    current_proc = 0;
    80205814:	00007797          	auipc	a5,0x7
    80205818:	8ac78793          	addi	a5,a5,-1876 # 8020c0c0 <current_proc>
    8020581c:	0007b023          	sd	zero,0(a5)
    if (mycpu())
    80205820:	fffff097          	auipc	ra,0xfffff
    80205824:	348080e7          	jalr	840(ra) # 80204b68 <mycpu>
    80205828:	87aa                	mv	a5,a0
    8020582a:	cb81                	beqz	a5,8020583a <kexit+0x9e>
        mycpu()->proc = 0;
    8020582c:	fffff097          	auipc	ra,0xfffff
    80205830:	33c080e7          	jalr	828(ra) # 80204b68 <mycpu>
    80205834:	87aa                	mv	a5,a0
    80205836:	0007b023          	sd	zero,0(a5)
    schedule();
    8020583a:	00000097          	auipc	ra,0x0
    8020583e:	cc0080e7          	jalr	-832(ra) # 802054fa <schedule>
    panic("kexit should not return after schedule");
    80205842:	00003517          	auipc	a0,0x3
    80205846:	74e50513          	addi	a0,a0,1870 # 80208f90 <etext+0x1f90>
    8020584a:	ffffc097          	auipc	ra,0xffffc
    8020584e:	e84080e7          	jalr	-380(ra) # 802016ce <panic>
}
    80205852:	0001                	nop
    80205854:	60e2                	ld	ra,24(sp)
    80205856:	6442                	ld	s0,16(sp)
    80205858:	6105                	addi	sp,sp,32
    8020585a:	8082                	ret

000000008020585c <kwait>:
int kwait(int *status) {
    8020585c:	7159                	addi	sp,sp,-112
    8020585e:	f486                	sd	ra,104(sp)
    80205860:	f0a2                	sd	s0,96(sp)
    80205862:	1880                	addi	s0,sp,112
    80205864:	f8a43c23          	sd	a0,-104(s0)
    struct proc *p = myproc();
    80205868:	fffff097          	auipc	ra,0xfffff
    8020586c:	2e8080e7          	jalr	744(ra) # 80204b50 <myproc>
    80205870:	fca43023          	sd	a0,-64(s0)
    if (p == 0) {
    80205874:	fc043783          	ld	a5,-64(s0)
    80205878:	eb99                	bnez	a5,8020588e <kwait+0x32>
        printf("Warning: kwait called with no current process\n");
    8020587a:	00003517          	auipc	a0,0x3
    8020587e:	73e50513          	addi	a0,a0,1854 # 80208fb8 <etext+0x1fb8>
    80205882:	ffffb097          	auipc	ra,0xffffb
    80205886:	400080e7          	jalr	1024(ra) # 80200c82 <printf>
        return -1;
    8020588a:	57fd                	li	a5,-1
    8020588c:	aa45                	j	80205a3c <kwait+0x1e0>
    }
    
    while (1) {
        // 关中断确保原子操作
        intr_off();
    8020588e:	fffff097          	auipc	ra,0xfffff
    80205892:	20a080e7          	jalr	522(ra) # 80204a98 <intr_off>
        
        // 优先检查是否有僵尸子进程
        int found_zombie = 0;
    80205896:	fe042623          	sw	zero,-20(s0)
        int zombie_pid = 0;
    8020589a:	fe042423          	sw	zero,-24(s0)
        int zombie_status = 0;
    8020589e:	fe042223          	sw	zero,-28(s0)
        struct proc *zombie_child = 0;
    802058a2:	fc043c23          	sd	zero,-40(s0)
        
        // 先查找ZOMBIE状态的子进程
        for (int i = 0; i < PROC; i++) {
    802058a6:	fc042a23          	sw	zero,-44(s0)
    802058aa:	a095                	j	8020590e <kwait+0xb2>
            struct proc *child = proc_table[i];
    802058ac:	00007717          	auipc	a4,0x7
    802058b0:	bcc70713          	addi	a4,a4,-1076 # 8020c478 <proc_table>
    802058b4:	fd442783          	lw	a5,-44(s0)
    802058b8:	078e                	slli	a5,a5,0x3
    802058ba:	97ba                	add	a5,a5,a4
    802058bc:	639c                	ld	a5,0(a5)
    802058be:	faf43c23          	sd	a5,-72(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    802058c2:	fb843783          	ld	a5,-72(s0)
    802058c6:	439c                	lw	a5,0(a5)
    802058c8:	873e                	mv	a4,a5
    802058ca:	4795                	li	a5,5
    802058cc:	02f71c63          	bne	a4,a5,80205904 <kwait+0xa8>
    802058d0:	fb843783          	ld	a5,-72(s0)
    802058d4:	6fdc                	ld	a5,152(a5)
    802058d6:	fc043703          	ld	a4,-64(s0)
    802058da:	02f71563          	bne	a4,a5,80205904 <kwait+0xa8>
                found_zombie = 1;
    802058de:	4785                	li	a5,1
    802058e0:	fef42623          	sw	a5,-20(s0)
                zombie_pid = child->pid;
    802058e4:	fb843783          	ld	a5,-72(s0)
    802058e8:	43dc                	lw	a5,4(a5)
    802058ea:	fef42423          	sw	a5,-24(s0)
                zombie_status = child->exit_status;
    802058ee:	fb843783          	ld	a5,-72(s0)
    802058f2:	0847a783          	lw	a5,132(a5)
    802058f6:	fef42223          	sw	a5,-28(s0)
                zombie_child = child;
    802058fa:	fb843783          	ld	a5,-72(s0)
    802058fe:	fcf43c23          	sd	a5,-40(s0)
                break;
    80205902:	a831                	j	8020591e <kwait+0xc2>
        for (int i = 0; i < PROC; i++) {
    80205904:	fd442783          	lw	a5,-44(s0)
    80205908:	2785                	addiw	a5,a5,1
    8020590a:	fcf42a23          	sw	a5,-44(s0)
    8020590e:	fd442783          	lw	a5,-44(s0)
    80205912:	0007871b          	sext.w	a4,a5
    80205916:	03f00793          	li	a5,63
    8020591a:	f8e7d9e3          	bge	a5,a4,802058ac <kwait+0x50>
            }
        }
        
        if (found_zombie) {
    8020591e:	fec42783          	lw	a5,-20(s0)
    80205922:	2781                	sext.w	a5,a5
    80205924:	cb85                	beqz	a5,80205954 <kwait+0xf8>
            if (status)
    80205926:	f9843783          	ld	a5,-104(s0)
    8020592a:	c791                	beqz	a5,80205936 <kwait+0xda>
                *status = zombie_status;
    8020592c:	f9843783          	ld	a5,-104(s0)
    80205930:	fe442703          	lw	a4,-28(s0)
    80205934:	c398                	sw	a4,0(a5)

            free_proc(zombie_child);
    80205936:	fd843503          	ld	a0,-40(s0)
    8020593a:	fffff097          	auipc	ra,0xfffff
    8020593e:	788080e7          	jalr	1928(ra) # 802050c2 <free_proc>
			zombie_child = NULL;
    80205942:	fc043c23          	sd	zero,-40(s0)
            intr_on();
    80205946:	fffff097          	auipc	ra,0xfffff
    8020594a:	128080e7          	jalr	296(ra) # 80204a6e <intr_on>
            return zombie_pid;
    8020594e:	fe842783          	lw	a5,-24(s0)
    80205952:	a0ed                	j	80205a3c <kwait+0x1e0>
        }
        
        // 检查是否有任何子进程
        int havekids = 0;
    80205954:	fc042823          	sw	zero,-48(s0)
        for (int i = 0; i < PROC; i++) {
    80205958:	fc042623          	sw	zero,-52(s0)
    8020595c:	a83d                	j	8020599a <kwait+0x13e>
            struct proc *child = proc_table[i];
    8020595e:	00007717          	auipc	a4,0x7
    80205962:	b1a70713          	addi	a4,a4,-1254 # 8020c478 <proc_table>
    80205966:	fcc42783          	lw	a5,-52(s0)
    8020596a:	078e                	slli	a5,a5,0x3
    8020596c:	97ba                	add	a5,a5,a4
    8020596e:	639c                	ld	a5,0(a5)
    80205970:	faf43023          	sd	a5,-96(s0)
            if (child->state != UNUSED && child->parent == p) {
    80205974:	fa043783          	ld	a5,-96(s0)
    80205978:	439c                	lw	a5,0(a5)
    8020597a:	cb99                	beqz	a5,80205990 <kwait+0x134>
    8020597c:	fa043783          	ld	a5,-96(s0)
    80205980:	6fdc                	ld	a5,152(a5)
    80205982:	fc043703          	ld	a4,-64(s0)
    80205986:	00f71563          	bne	a4,a5,80205990 <kwait+0x134>
                havekids = 1;
    8020598a:	4785                	li	a5,1
    8020598c:	fcf42823          	sw	a5,-48(s0)
        for (int i = 0; i < PROC; i++) {
    80205990:	fcc42783          	lw	a5,-52(s0)
    80205994:	2785                	addiw	a5,a5,1
    80205996:	fcf42623          	sw	a5,-52(s0)
    8020599a:	fcc42783          	lw	a5,-52(s0)
    8020599e:	0007871b          	sext.w	a4,a5
    802059a2:	03f00793          	li	a5,63
    802059a6:	fae7dce3          	bge	a5,a4,8020595e <kwait+0x102>
            }
        }
        
        if (!havekids) {
    802059aa:	fd042783          	lw	a5,-48(s0)
    802059ae:	2781                	sext.w	a5,a5
    802059b0:	e799                	bnez	a5,802059be <kwait+0x162>
            intr_on();
    802059b2:	fffff097          	auipc	ra,0xfffff
    802059b6:	0bc080e7          	jalr	188(ra) # 80204a6e <intr_on>
            return -1;
    802059ba:	57fd                	li	a5,-1
    802059bc:	a041                	j	80205a3c <kwait+0x1e0>
        }
        void *wait_chan = (void*)p;
    802059be:	fc043783          	ld	a5,-64(s0)
    802059c2:	faf43823          	sd	a5,-80(s0)
		register uint64 ra asm("ra");
		p->context.ra = ra;
    802059c6:	8706                	mv	a4,ra
    802059c8:	fc043783          	ld	a5,-64(s0)
    802059cc:	eb98                	sd	a4,16(a5)
        p->chan = wait_chan;
    802059ce:	fc043783          	ld	a5,-64(s0)
    802059d2:	fb043703          	ld	a4,-80(s0)
    802059d6:	f3d8                	sd	a4,160(a5)
        p->state = SLEEPING;
    802059d8:	fc043783          	ld	a5,-64(s0)
    802059dc:	4709                	li	a4,2
    802059de:	c398                	sw	a4,0(a5)
        
		struct cpu *c = mycpu();
    802059e0:	fffff097          	auipc	ra,0xfffff
    802059e4:	188080e7          	jalr	392(ra) # 80204b68 <mycpu>
    802059e8:	faa43423          	sd	a0,-88(s0)
		current_proc = 0;
    802059ec:	00006797          	auipc	a5,0x6
    802059f0:	6d478793          	addi	a5,a5,1748 # 8020c0c0 <current_proc>
    802059f4:	0007b023          	sd	zero,0(a5)
		c->proc = 0;
    802059f8:	fa843783          	ld	a5,-88(s0)
    802059fc:	0007b023          	sd	zero,0(a5)
        // 在睡眠前确保中断是开启的
        intr_on();
    80205a00:	fffff097          	auipc	ra,0xfffff
    80205a04:	06e080e7          	jalr	110(ra) # 80204a6e <intr_on>
        swtch(&p->context,&c->context);
    80205a08:	fc043783          	ld	a5,-64(s0)
    80205a0c:	01078713          	addi	a4,a5,16
    80205a10:	fa843783          	ld	a5,-88(s0)
    80205a14:	07a1                	addi	a5,a5,8
    80205a16:	85be                	mv	a1,a5
    80205a18:	853a                	mv	a0,a4
    80205a1a:	fffff097          	auipc	ra,0xfffff
    80205a1e:	fb6080e7          	jalr	-74(ra) # 802049d0 <swtch>
        intr_off();
    80205a22:	fffff097          	auipc	ra,0xfffff
    80205a26:	076080e7          	jalr	118(ra) # 80204a98 <intr_off>
        p->state = RUNNING;
    80205a2a:	fc043783          	ld	a5,-64(s0)
    80205a2e:	4711                	li	a4,4
    80205a30:	c398                	sw	a4,0(a5)
        intr_on();
    80205a32:	fffff097          	auipc	ra,0xfffff
    80205a36:	03c080e7          	jalr	60(ra) # 80204a6e <intr_on>
    while (1) {
    80205a3a:	bd91                	j	8020588e <kwait+0x32>
    }
}
    80205a3c:	853e                	mv	a0,a5
    80205a3e:	70a6                	ld	ra,104(sp)
    80205a40:	7406                	ld	s0,96(sp)
    80205a42:	6165                	addi	sp,sp,112
    80205a44:	8082                	ret

0000000080205a46 <print_proc_table>:

void print_proc_table(void) {
    80205a46:	715d                	addi	sp,sp,-80
    80205a48:	e486                	sd	ra,72(sp)
    80205a4a:	e0a2                	sd	s0,64(sp)
    80205a4c:	0880                	addi	s0,sp,80
    int count = 0;
    80205a4e:	fe042623          	sw	zero,-20(s0)
    printf("PID  TYPE STATUS     PPID   FUNC_ADDR      STACK_ADDR    \n");
    80205a52:	00003517          	auipc	a0,0x3
    80205a56:	59650513          	addi	a0,a0,1430 # 80208fe8 <etext+0x1fe8>
    80205a5a:	ffffb097          	auipc	ra,0xffffb
    80205a5e:	228080e7          	jalr	552(ra) # 80200c82 <printf>
    printf("----------------------------------------------------------\n");
    80205a62:	00003517          	auipc	a0,0x3
    80205a66:	5c650513          	addi	a0,a0,1478 # 80209028 <etext+0x2028>
    80205a6a:	ffffb097          	auipc	ra,0xffffb
    80205a6e:	218080e7          	jalr	536(ra) # 80200c82 <printf>
    for(int i = 0; i < PROC; i++) {
    80205a72:	fe042423          	sw	zero,-24(s0)
    80205a76:	a2a9                	j	80205bc0 <print_proc_table+0x17a>
        struct proc *p = proc_table[i];
    80205a78:	00007717          	auipc	a4,0x7
    80205a7c:	a0070713          	addi	a4,a4,-1536 # 8020c478 <proc_table>
    80205a80:	fe842783          	lw	a5,-24(s0)
    80205a84:	078e                	slli	a5,a5,0x3
    80205a86:	97ba                	add	a5,a5,a4
    80205a88:	639c                	ld	a5,0(a5)
    80205a8a:	fcf43c23          	sd	a5,-40(s0)
        if(p->state != UNUSED) {
    80205a8e:	fd843783          	ld	a5,-40(s0)
    80205a92:	439c                	lw	a5,0(a5)
    80205a94:	12078163          	beqz	a5,80205bb6 <print_proc_table+0x170>
            count++;
    80205a98:	fec42783          	lw	a5,-20(s0)
    80205a9c:	2785                	addiw	a5,a5,1
    80205a9e:	fef42623          	sw	a5,-20(s0)
            const char *type = (p->is_user ? "USR" : "SYS");
    80205aa2:	fd843783          	ld	a5,-40(s0)
    80205aa6:	0a87a783          	lw	a5,168(a5)
    80205aaa:	c791                	beqz	a5,80205ab6 <print_proc_table+0x70>
    80205aac:	00003797          	auipc	a5,0x3
    80205ab0:	5bc78793          	addi	a5,a5,1468 # 80209068 <etext+0x2068>
    80205ab4:	a029                	j	80205abe <print_proc_table+0x78>
    80205ab6:	00003797          	auipc	a5,0x3
    80205aba:	5ba78793          	addi	a5,a5,1466 # 80209070 <etext+0x2070>
    80205abe:	fcf43823          	sd	a5,-48(s0)
            const char *status;
            switch(p->state) {
    80205ac2:	fd843783          	ld	a5,-40(s0)
    80205ac6:	439c                	lw	a5,0(a5)
    80205ac8:	86be                	mv	a3,a5
    80205aca:	4715                	li	a4,5
    80205acc:	06d76c63          	bltu	a4,a3,80205b44 <print_proc_table+0xfe>
    80205ad0:	00279713          	slli	a4,a5,0x2
    80205ad4:	00003797          	auipc	a5,0x3
    80205ad8:	62478793          	addi	a5,a5,1572 # 802090f8 <etext+0x20f8>
    80205adc:	97ba                	add	a5,a5,a4
    80205ade:	439c                	lw	a5,0(a5)
    80205ae0:	0007871b          	sext.w	a4,a5
    80205ae4:	00003797          	auipc	a5,0x3
    80205ae8:	61478793          	addi	a5,a5,1556 # 802090f8 <etext+0x20f8>
    80205aec:	97ba                	add	a5,a5,a4
    80205aee:	8782                	jr	a5
                case UNUSED:   status = "UNUSED"; break;
    80205af0:	00003797          	auipc	a5,0x3
    80205af4:	58878793          	addi	a5,a5,1416 # 80209078 <etext+0x2078>
    80205af8:	fef43023          	sd	a5,-32(s0)
    80205afc:	a899                	j	80205b52 <print_proc_table+0x10c>
                case USED:     status = "USED"; break;
    80205afe:	00003797          	auipc	a5,0x3
    80205b02:	58278793          	addi	a5,a5,1410 # 80209080 <etext+0x2080>
    80205b06:	fef43023          	sd	a5,-32(s0)
    80205b0a:	a0a1                	j	80205b52 <print_proc_table+0x10c>
                case SLEEPING: status = "SLEEP"; break;
    80205b0c:	00003797          	auipc	a5,0x3
    80205b10:	57c78793          	addi	a5,a5,1404 # 80209088 <etext+0x2088>
    80205b14:	fef43023          	sd	a5,-32(s0)
    80205b18:	a82d                	j	80205b52 <print_proc_table+0x10c>
                case RUNNABLE: status = "RUNNABLE"; break;
    80205b1a:	00003797          	auipc	a5,0x3
    80205b1e:	57678793          	addi	a5,a5,1398 # 80209090 <etext+0x2090>
    80205b22:	fef43023          	sd	a5,-32(s0)
    80205b26:	a035                	j	80205b52 <print_proc_table+0x10c>
                case RUNNING:  status = "RUNNING"; break;
    80205b28:	00003797          	auipc	a5,0x3
    80205b2c:	57878793          	addi	a5,a5,1400 # 802090a0 <etext+0x20a0>
    80205b30:	fef43023          	sd	a5,-32(s0)
    80205b34:	a839                	j	80205b52 <print_proc_table+0x10c>
                case ZOMBIE:   status = "ZOMBIE"; break;
    80205b36:	00003797          	auipc	a5,0x3
    80205b3a:	57278793          	addi	a5,a5,1394 # 802090a8 <etext+0x20a8>
    80205b3e:	fef43023          	sd	a5,-32(s0)
    80205b42:	a801                	j	80205b52 <print_proc_table+0x10c>
                default:       status = "UNKNOWN"; break;
    80205b44:	00003797          	auipc	a5,0x3
    80205b48:	56c78793          	addi	a5,a5,1388 # 802090b0 <etext+0x20b0>
    80205b4c:	fef43023          	sd	a5,-32(s0)
    80205b50:	0001                	nop
            }
            int ppid = p->parent ? p->parent->pid : -1;
    80205b52:	fd843783          	ld	a5,-40(s0)
    80205b56:	6fdc                	ld	a5,152(a5)
    80205b58:	c791                	beqz	a5,80205b64 <print_proc_table+0x11e>
    80205b5a:	fd843783          	ld	a5,-40(s0)
    80205b5e:	6fdc                	ld	a5,152(a5)
    80205b60:	43dc                	lw	a5,4(a5)
    80205b62:	a011                	j	80205b66 <print_proc_table+0x120>
    80205b64:	57fd                	li	a5,-1
    80205b66:	fcf42623          	sw	a5,-52(s0)
            unsigned long func_addr = p->trapframe ? p->trapframe->epc : 0;
    80205b6a:	fd843783          	ld	a5,-40(s0)
    80205b6e:	63fc                	ld	a5,192(a5)
    80205b70:	c791                	beqz	a5,80205b7c <print_proc_table+0x136>
    80205b72:	fd843783          	ld	a5,-40(s0)
    80205b76:	63fc                	ld	a5,192(a5)
    80205b78:	739c                	ld	a5,32(a5)
    80205b7a:	a011                	j	80205b7e <print_proc_table+0x138>
    80205b7c:	4781                	li	a5,0
    80205b7e:	fcf43023          	sd	a5,-64(s0)
            unsigned long stack_addr = p->kstack;
    80205b82:	fd843783          	ld	a5,-40(s0)
    80205b86:	679c                	ld	a5,8(a5)
    80205b88:	faf43c23          	sd	a5,-72(s0)
            printf("%2d  %3s %8s %4d 0x%012lx 0x%012lx\n",
    80205b8c:	fd843783          	ld	a5,-40(s0)
    80205b90:	43cc                	lw	a1,4(a5)
    80205b92:	fcc42703          	lw	a4,-52(s0)
    80205b96:	fb843803          	ld	a6,-72(s0)
    80205b9a:	fc043783          	ld	a5,-64(s0)
    80205b9e:	fe043683          	ld	a3,-32(s0)
    80205ba2:	fd043603          	ld	a2,-48(s0)
    80205ba6:	00003517          	auipc	a0,0x3
    80205baa:	51250513          	addi	a0,a0,1298 # 802090b8 <etext+0x20b8>
    80205bae:	ffffb097          	auipc	ra,0xffffb
    80205bb2:	0d4080e7          	jalr	212(ra) # 80200c82 <printf>
    for(int i = 0; i < PROC; i++) {
    80205bb6:	fe842783          	lw	a5,-24(s0)
    80205bba:	2785                	addiw	a5,a5,1
    80205bbc:	fef42423          	sw	a5,-24(s0)
    80205bc0:	fe842783          	lw	a5,-24(s0)
    80205bc4:	0007871b          	sext.w	a4,a5
    80205bc8:	03f00793          	li	a5,63
    80205bcc:	eae7d6e3          	bge	a5,a4,80205a78 <print_proc_table+0x32>
                p->pid, type, status, ppid, func_addr, stack_addr);
        }
    }
    printf("----------------------------------------------------------\n");
    80205bd0:	00003517          	auipc	a0,0x3
    80205bd4:	45850513          	addi	a0,a0,1112 # 80209028 <etext+0x2028>
    80205bd8:	ffffb097          	auipc	ra,0xffffb
    80205bdc:	0aa080e7          	jalr	170(ra) # 80200c82 <printf>
    printf("%d active processes\n", count);
    80205be0:	fec42783          	lw	a5,-20(s0)
    80205be4:	85be                	mv	a1,a5
    80205be6:	00003517          	auipc	a0,0x3
    80205bea:	4fa50513          	addi	a0,a0,1274 # 802090e0 <etext+0x20e0>
    80205bee:	ffffb097          	auipc	ra,0xffffb
    80205bf2:	094080e7          	jalr	148(ra) # 80200c82 <printf>
}
    80205bf6:	0001                	nop
    80205bf8:	60a6                	ld	ra,72(sp)
    80205bfa:	6406                	ld	s0,64(sp)
    80205bfc:	6161                	addi	sp,sp,80
    80205bfe:	8082                	ret

0000000080205c00 <simple_task>:
// 简单测试任务，用于测试进程创建
void simple_task(void) {
    80205c00:	1141                	addi	sp,sp,-16
    80205c02:	e406                	sd	ra,8(sp)
    80205c04:	e022                	sd	s0,0(sp)
    80205c06:	0800                	addi	s0,sp,16
    // 简单任务，只打印并退出
    printf("Simple task running in PID %d\n", myproc()->pid);
    80205c08:	fffff097          	auipc	ra,0xfffff
    80205c0c:	f48080e7          	jalr	-184(ra) # 80204b50 <myproc>
    80205c10:	87aa                	mv	a5,a0
    80205c12:	43dc                	lw	a5,4(a5)
    80205c14:	85be                	mv	a1,a5
    80205c16:	00003517          	auipc	a0,0x3
    80205c1a:	4fa50513          	addi	a0,a0,1274 # 80209110 <etext+0x2110>
    80205c1e:	ffffb097          	auipc	ra,0xffffb
    80205c22:	064080e7          	jalr	100(ra) # 80200c82 <printf>
}
    80205c26:	0001                	nop
    80205c28:	60a2                	ld	ra,8(sp)
    80205c2a:	6402                	ld	s0,0(sp)
    80205c2c:	0141                	addi	sp,sp,16
    80205c2e:	8082                	ret

0000000080205c30 <test_process_creation>:
void test_process_creation(void) {
    80205c30:	7139                	addi	sp,sp,-64
    80205c32:	fc06                	sd	ra,56(sp)
    80205c34:	f822                	sd	s0,48(sp)
    80205c36:	0080                	addi	s0,sp,64
    printf("===== 测试开始: 进程创建与管理测试 =====\n");
    80205c38:	00003517          	auipc	a0,0x3
    80205c3c:	4f850513          	addi	a0,a0,1272 # 80209130 <etext+0x2130>
    80205c40:	ffffb097          	auipc	ra,0xffffb
    80205c44:	042080e7          	jalr	66(ra) # 80200c82 <printf>

    // 测试基本的进程创建
    int pid = create_kernel_proc(simple_task);
    80205c48:	00000517          	auipc	a0,0x0
    80205c4c:	fb850513          	addi	a0,a0,-72 # 80205c00 <simple_task>
    80205c50:	fffff097          	auipc	ra,0xfffff
    80205c54:	532080e7          	jalr	1330(ra) # 80205182 <create_kernel_proc>
    80205c58:	87aa                	mv	a5,a0
    80205c5a:	fcf42823          	sw	a5,-48(s0)
    assert(pid > 0);
    80205c5e:	fd042783          	lw	a5,-48(s0)
    80205c62:	2781                	sext.w	a5,a5
    80205c64:	00f027b3          	sgtz	a5,a5
    80205c68:	0ff7f793          	zext.b	a5,a5
    80205c6c:	2781                	sext.w	a5,a5
    80205c6e:	853e                	mv	a0,a5
    80205c70:	fffff097          	auipc	ra,0xfffff
    80205c74:	e6a080e7          	jalr	-406(ra) # 80204ada <assert>
    printf("【测试结果】: 基本进程创建成功，PID: %d，正常退出\n", pid);
    80205c78:	fd042783          	lw	a5,-48(s0)
    80205c7c:	85be                	mv	a1,a5
    80205c7e:	00003517          	auipc	a0,0x3
    80205c82:	4ea50513          	addi	a0,a0,1258 # 80209168 <etext+0x2168>
    80205c86:	ffffb097          	auipc	ra,0xffffb
    80205c8a:	ffc080e7          	jalr	-4(ra) # 80200c82 <printf>

    int count = 1;
    80205c8e:	4785                	li	a5,1
    80205c90:	fef42623          	sw	a5,-20(s0)
    printf("\n----- 测试进程表容量限制 -----\n");
    80205c94:	00003517          	auipc	a0,0x3
    80205c98:	51c50513          	addi	a0,a0,1308 # 802091b0 <etext+0x21b0>
    80205c9c:	ffffb097          	auipc	ra,0xffffb
    80205ca0:	fe6080e7          	jalr	-26(ra) # 80200c82 <printf>
    for (int i = 0; i < PROC+5; i++) {// 验证超量创建进程的处理
    80205ca4:	fe042423          	sw	zero,-24(s0)
    80205ca8:	a0a9                	j	80205cf2 <test_process_creation+0xc2>
        int pid = create_kernel_proc(simple_task);
    80205caa:	00000517          	auipc	a0,0x0
    80205cae:	f5650513          	addi	a0,a0,-170 # 80205c00 <simple_task>
    80205cb2:	fffff097          	auipc	ra,0xfffff
    80205cb6:	4d0080e7          	jalr	1232(ra) # 80205182 <create_kernel_proc>
    80205cba:	87aa                	mv	a5,a0
    80205cbc:	fcf42623          	sw	a5,-52(s0)
        if (pid > 0) {
    80205cc0:	fcc42783          	lw	a5,-52(s0)
    80205cc4:	2781                	sext.w	a5,a5
    80205cc6:	00f05863          	blez	a5,80205cd6 <test_process_creation+0xa6>
            count++; 
    80205cca:	fec42783          	lw	a5,-20(s0)
    80205cce:	2785                	addiw	a5,a5,1
    80205cd0:	fef42623          	sw	a5,-20(s0)
    80205cd4:	a811                	j	80205ce8 <test_process_creation+0xb8>
        } else {
			warning("process table was full\n");
    80205cd6:	00003517          	auipc	a0,0x3
    80205cda:	50a50513          	addi	a0,a0,1290 # 802091e0 <etext+0x21e0>
    80205cde:	ffffc097          	auipc	ra,0xffffc
    80205ce2:	a24080e7          	jalr	-1500(ra) # 80201702 <warning>
            break;
    80205ce6:	a831                	j	80205d02 <test_process_creation+0xd2>
    for (int i = 0; i < PROC+5; i++) {// 验证超量创建进程的处理
    80205ce8:	fe842783          	lw	a5,-24(s0)
    80205cec:	2785                	addiw	a5,a5,1
    80205cee:	fef42423          	sw	a5,-24(s0)
    80205cf2:	fe842783          	lw	a5,-24(s0)
    80205cf6:	0007871b          	sext.w	a4,a5
    80205cfa:	04400793          	li	a5,68
    80205cfe:	fae7d6e3          	bge	a5,a4,80205caa <test_process_creation+0x7a>
        }
    }
    printf("【测试结果】: 成功创建 %d 个进程 (最大限制: %d)\n", count, PROC);
    80205d02:	fec42783          	lw	a5,-20(s0)
    80205d06:	04000613          	li	a2,64
    80205d0a:	85be                	mv	a1,a5
    80205d0c:	00003517          	auipc	a0,0x3
    80205d10:	4ec50513          	addi	a0,a0,1260 # 802091f8 <etext+0x21f8>
    80205d14:	ffffb097          	auipc	ra,0xffffb
    80205d18:	f6e080e7          	jalr	-146(ra) # 80200c82 <printf>
	print_proc_table();
    80205d1c:	00000097          	auipc	ra,0x0
    80205d20:	d2a080e7          	jalr	-726(ra) # 80205a46 <print_proc_table>
    // 清理测试进程
    printf("\n----- 测试进程等待与清理 -----\n");
    80205d24:	00003517          	auipc	a0,0x3
    80205d28:	51c50513          	addi	a0,a0,1308 # 80209240 <etext+0x2240>
    80205d2c:	ffffb097          	auipc	ra,0xffffb
    80205d30:	f56080e7          	jalr	-170(ra) # 80200c82 <printf>
    int success_count = 0;
    80205d34:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < count; i++) {
    80205d38:	fe042023          	sw	zero,-32(s0)
    80205d3c:	a0a1                	j	80205d84 <test_process_creation+0x154>
        int waited_pid = wait_proc(NULL);
    80205d3e:	4501                	li	a0,0
    80205d40:	fffff097          	auipc	ra,0xfffff
    80205d44:	6d4080e7          	jalr	1748(ra) # 80205414 <wait_proc>
    80205d48:	87aa                	mv	a5,a0
    80205d4a:	fcf42023          	sw	a5,-64(s0)
        if (waited_pid > 0) {
    80205d4e:	fc042783          	lw	a5,-64(s0)
    80205d52:	2781                	sext.w	a5,a5
    80205d54:	00f05863          	blez	a5,80205d64 <test_process_creation+0x134>
            success_count++;
    80205d58:	fe442783          	lw	a5,-28(s0)
    80205d5c:	2785                	addiw	a5,a5,1
    80205d5e:	fef42223          	sw	a5,-28(s0)
    80205d62:	a821                	j	80205d7a <test_process_creation+0x14a>
        } else {
            printf("【错误】: 等待进程失败，错误码: %d\n", waited_pid);
    80205d64:	fc042783          	lw	a5,-64(s0)
    80205d68:	85be                	mv	a1,a5
    80205d6a:	00003517          	auipc	a0,0x3
    80205d6e:	50650513          	addi	a0,a0,1286 # 80209270 <etext+0x2270>
    80205d72:	ffffb097          	auipc	ra,0xffffb
    80205d76:	f10080e7          	jalr	-240(ra) # 80200c82 <printf>
    for (int i = 0; i < count; i++) {
    80205d7a:	fe042783          	lw	a5,-32(s0)
    80205d7e:	2785                	addiw	a5,a5,1
    80205d80:	fef42023          	sw	a5,-32(s0)
    80205d84:	fe042783          	lw	a5,-32(s0)
    80205d88:	873e                	mv	a4,a5
    80205d8a:	fec42783          	lw	a5,-20(s0)
    80205d8e:	2701                	sext.w	a4,a4
    80205d90:	2781                	sext.w	a5,a5
    80205d92:	faf746e3          	blt	a4,a5,80205d3e <test_process_creation+0x10e>
        }
    }
    printf("【测试结果】: 回收 %d/%d 个进程\n", success_count, count);
    80205d96:	fec42703          	lw	a4,-20(s0)
    80205d9a:	fe442783          	lw	a5,-28(s0)
    80205d9e:	863a                	mv	a2,a4
    80205da0:	85be                	mv	a1,a5
    80205da2:	00003517          	auipc	a0,0x3
    80205da6:	50650513          	addi	a0,a0,1286 # 802092a8 <etext+0x22a8>
    80205daa:	ffffb097          	auipc	ra,0xffffb
    80205dae:	ed8080e7          	jalr	-296(ra) # 80200c82 <printf>
	print_proc_table();
    80205db2:	00000097          	auipc	ra,0x0
    80205db6:	c94080e7          	jalr	-876(ra) # 80205a46 <print_proc_table>
    // 增强测试：清理后尝试重新创建进程
	printf("\n----- 清理后尝试重新填满进程表 -----\n");
    80205dba:	00003517          	auipc	a0,0x3
    80205dbe:	51e50513          	addi	a0,a0,1310 # 802092d8 <etext+0x22d8>
    80205dc2:	ffffb097          	auipc	ra,0xffffb
    80205dc6:	ec0080e7          	jalr	-320(ra) # 80200c82 <printf>
	int refill_count = 0;
    80205dca:	fc042e23          	sw	zero,-36(s0)
	for (int i = 0; i < PROC; i++) {
    80205dce:	fc042c23          	sw	zero,-40(s0)
    80205dd2:	a0a9                	j	80205e1c <test_process_creation+0x1ec>
		int pid = create_kernel_proc(simple_task);
    80205dd4:	00000517          	auipc	a0,0x0
    80205dd8:	e2c50513          	addi	a0,a0,-468 # 80205c00 <simple_task>
    80205ddc:	fffff097          	auipc	ra,0xfffff
    80205de0:	3a6080e7          	jalr	934(ra) # 80205182 <create_kernel_proc>
    80205de4:	87aa                	mv	a5,a0
    80205de6:	fcf42423          	sw	a5,-56(s0)
		if (pid > 0) {
    80205dea:	fc842783          	lw	a5,-56(s0)
    80205dee:	2781                	sext.w	a5,a5
    80205df0:	00f05863          	blez	a5,80205e00 <test_process_creation+0x1d0>
			refill_count++;
    80205df4:	fdc42783          	lw	a5,-36(s0)
    80205df8:	2785                	addiw	a5,a5,1
    80205dfa:	fcf42e23          	sw	a5,-36(s0)
    80205dfe:	a811                	j	80205e12 <test_process_creation+0x1e2>
		} else {
			warning("process table was full\n");
    80205e00:	00003517          	auipc	a0,0x3
    80205e04:	3e050513          	addi	a0,a0,992 # 802091e0 <etext+0x21e0>
    80205e08:	ffffc097          	auipc	ra,0xffffc
    80205e0c:	8fa080e7          	jalr	-1798(ra) # 80201702 <warning>
			break;
    80205e10:	a831                	j	80205e2c <test_process_creation+0x1fc>
	for (int i = 0; i < PROC; i++) {
    80205e12:	fd842783          	lw	a5,-40(s0)
    80205e16:	2785                	addiw	a5,a5,1
    80205e18:	fcf42c23          	sw	a5,-40(s0)
    80205e1c:	fd842783          	lw	a5,-40(s0)
    80205e20:	0007871b          	sext.w	a4,a5
    80205e24:	03f00793          	li	a5,63
    80205e28:	fae7d6e3          	bge	a5,a4,80205dd4 <test_process_creation+0x1a4>
		}
	}
	printf("【测试结果】: 清理后成功重新创建 %d 个进程\n", refill_count);
    80205e2c:	fdc42783          	lw	a5,-36(s0)
    80205e30:	85be                	mv	a1,a5
    80205e32:	00003517          	auipc	a0,0x3
    80205e36:	4de50513          	addi	a0,a0,1246 # 80209310 <etext+0x2310>
    80205e3a:	ffffb097          	auipc	ra,0xffffb
    80205e3e:	e48080e7          	jalr	-440(ra) # 80200c82 <printf>
	print_proc_table();
    80205e42:	00000097          	auipc	ra,0x0
    80205e46:	c04080e7          	jalr	-1020(ra) # 80205a46 <print_proc_table>
	printf("\n----- 测试进程等待与清理 -----\n");
    80205e4a:	00003517          	auipc	a0,0x3
    80205e4e:	3f650513          	addi	a0,a0,1014 # 80209240 <etext+0x2240>
    80205e52:	ffffb097          	auipc	ra,0xffffb
    80205e56:	e30080e7          	jalr	-464(ra) # 80200c82 <printf>
    success_count = 0;
    80205e5a:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < count; i++) {
    80205e5e:	fc042a23          	sw	zero,-44(s0)
    80205e62:	a0a1                	j	80205eaa <test_process_creation+0x27a>
        int waited_pid = wait_proc(NULL);
    80205e64:	4501                	li	a0,0
    80205e66:	fffff097          	auipc	ra,0xfffff
    80205e6a:	5ae080e7          	jalr	1454(ra) # 80205414 <wait_proc>
    80205e6e:	87aa                	mv	a5,a0
    80205e70:	fcf42223          	sw	a5,-60(s0)
        if (waited_pid > 0) {
    80205e74:	fc442783          	lw	a5,-60(s0)
    80205e78:	2781                	sext.w	a5,a5
    80205e7a:	00f05863          	blez	a5,80205e8a <test_process_creation+0x25a>
            success_count++;
    80205e7e:	fe442783          	lw	a5,-28(s0)
    80205e82:	2785                	addiw	a5,a5,1
    80205e84:	fef42223          	sw	a5,-28(s0)
    80205e88:	a821                	j	80205ea0 <test_process_creation+0x270>
        } else {
            printf("【错误】: 等待进程失败，错误码: %d\n", waited_pid);
    80205e8a:	fc442783          	lw	a5,-60(s0)
    80205e8e:	85be                	mv	a1,a5
    80205e90:	00003517          	auipc	a0,0x3
    80205e94:	3e050513          	addi	a0,a0,992 # 80209270 <etext+0x2270>
    80205e98:	ffffb097          	auipc	ra,0xffffb
    80205e9c:	dea080e7          	jalr	-534(ra) # 80200c82 <printf>
    for (int i = 0; i < count; i++) {
    80205ea0:	fd442783          	lw	a5,-44(s0)
    80205ea4:	2785                	addiw	a5,a5,1
    80205ea6:	fcf42a23          	sw	a5,-44(s0)
    80205eaa:	fd442783          	lw	a5,-44(s0)
    80205eae:	873e                	mv	a4,a5
    80205eb0:	fec42783          	lw	a5,-20(s0)
    80205eb4:	2701                	sext.w	a4,a4
    80205eb6:	2781                	sext.w	a5,a5
    80205eb8:	faf746e3          	blt	a4,a5,80205e64 <test_process_creation+0x234>
        }
    }
    printf("【测试结果】: 回收 %d/%d 个进程\n", success_count, count);
    80205ebc:	fec42703          	lw	a4,-20(s0)
    80205ec0:	fe442783          	lw	a5,-28(s0)
    80205ec4:	863a                	mv	a2,a4
    80205ec6:	85be                	mv	a1,a5
    80205ec8:	00003517          	auipc	a0,0x3
    80205ecc:	3e050513          	addi	a0,a0,992 # 802092a8 <etext+0x22a8>
    80205ed0:	ffffb097          	auipc	ra,0xffffb
    80205ed4:	db2080e7          	jalr	-590(ra) # 80200c82 <printf>
	print_proc_table();
    80205ed8:	00000097          	auipc	ra,0x0
    80205edc:	b6e080e7          	jalr	-1170(ra) # 80205a46 <print_proc_table>
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    80205ee0:	00003517          	auipc	a0,0x3
    80205ee4:	47050513          	addi	a0,a0,1136 # 80209350 <etext+0x2350>
    80205ee8:	ffffb097          	auipc	ra,0xffffb
    80205eec:	d9a080e7          	jalr	-614(ra) # 80200c82 <printf>
}
    80205ef0:	0001                	nop
    80205ef2:	70e2                	ld	ra,56(sp)
    80205ef4:	7442                	ld	s0,48(sp)
    80205ef6:	6121                	addi	sp,sp,64
    80205ef8:	8082                	ret

0000000080205efa <cpu_intensive_task>:

void cpu_intensive_task(void) {
    80205efa:	1101                	addi	sp,sp,-32
    80205efc:	ec06                	sd	ra,24(sp)
    80205efe:	e822                	sd	s0,16(sp)
    80205f00:	1000                	addi	s0,sp,32
    uint64 sum = 0;
    80205f02:	fe043423          	sd	zero,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    80205f06:	fe043023          	sd	zero,-32(s0)
    80205f0a:	a829                	j	80205f24 <cpu_intensive_task+0x2a>
        sum += i;
    80205f0c:	fe843703          	ld	a4,-24(s0)
    80205f10:	fe043783          	ld	a5,-32(s0)
    80205f14:	97ba                	add	a5,a5,a4
    80205f16:	fef43423          	sd	a5,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    80205f1a:	fe043783          	ld	a5,-32(s0)
    80205f1e:	0785                	addi	a5,a5,1
    80205f20:	fef43023          	sd	a5,-32(s0)
    80205f24:	fe043703          	ld	a4,-32(s0)
    80205f28:	009897b7          	lui	a5,0x989
    80205f2c:	67f78793          	addi	a5,a5,1663 # 98967f <_entry-0x7f876981>
    80205f30:	fce7fee3          	bgeu	a5,a4,80205f0c <cpu_intensive_task+0x12>
    }
    printf("CPU intensive task done in PID %d, sum=%lu\n", myproc()->pid, sum);
    80205f34:	fffff097          	auipc	ra,0xfffff
    80205f38:	c1c080e7          	jalr	-996(ra) # 80204b50 <myproc>
    80205f3c:	87aa                	mv	a5,a0
    80205f3e:	43dc                	lw	a5,4(a5)
    80205f40:	fe843603          	ld	a2,-24(s0)
    80205f44:	85be                	mv	a1,a5
    80205f46:	00003517          	auipc	a0,0x3
    80205f4a:	44250513          	addi	a0,a0,1090 # 80209388 <etext+0x2388>
    80205f4e:	ffffb097          	auipc	ra,0xffffb
    80205f52:	d34080e7          	jalr	-716(ra) # 80200c82 <printf>
    exit_proc(0);
    80205f56:	4501                	li	a0,0
    80205f58:	fffff097          	auipc	ra,0xfffff
    80205f5c:	484080e7          	jalr	1156(ra) # 802053dc <exit_proc>
}
    80205f60:	0001                	nop
    80205f62:	60e2                	ld	ra,24(sp)
    80205f64:	6442                	ld	s0,16(sp)
    80205f66:	6105                	addi	sp,sp,32
    80205f68:	8082                	ret

0000000080205f6a <test_scheduler>:

void test_scheduler(void) {
    80205f6a:	7179                	addi	sp,sp,-48
    80205f6c:	f406                	sd	ra,40(sp)
    80205f6e:	f022                	sd	s0,32(sp)
    80205f70:	1800                	addi	s0,sp,48
    printf("===== 测试开始: 调度器测试 =====\n");
    80205f72:	00003517          	auipc	a0,0x3
    80205f76:	44650513          	addi	a0,a0,1094 # 802093b8 <etext+0x23b8>
    80205f7a:	ffffb097          	auipc	ra,0xffffb
    80205f7e:	d08080e7          	jalr	-760(ra) # 80200c82 <printf>

    // 创建多个计算密集型进程
    for (int i = 0; i < 3; i++) {
    80205f82:	fe042623          	sw	zero,-20(s0)
    80205f86:	a831                	j	80205fa2 <test_scheduler+0x38>
        create_kernel_proc(cpu_intensive_task);
    80205f88:	00000517          	auipc	a0,0x0
    80205f8c:	f7250513          	addi	a0,a0,-142 # 80205efa <cpu_intensive_task>
    80205f90:	fffff097          	auipc	ra,0xfffff
    80205f94:	1f2080e7          	jalr	498(ra) # 80205182 <create_kernel_proc>
    for (int i = 0; i < 3; i++) {
    80205f98:	fec42783          	lw	a5,-20(s0)
    80205f9c:	2785                	addiw	a5,a5,1
    80205f9e:	fef42623          	sw	a5,-20(s0)
    80205fa2:	fec42783          	lw	a5,-20(s0)
    80205fa6:	0007871b          	sext.w	a4,a5
    80205faa:	4789                	li	a5,2
    80205fac:	fce7dee3          	bge	a5,a4,80205f88 <test_scheduler+0x1e>
    }

    // 观察调度行为
    uint64 start_time = get_time();
    80205fb0:	ffffe097          	auipc	ra,0xffffe
    80205fb4:	074080e7          	jalr	116(ra) # 80204024 <get_time>
    80205fb8:	fea43023          	sd	a0,-32(s0)
	for (int i = 0; i < 3; i++) {
    80205fbc:	fe042423          	sw	zero,-24(s0)
    80205fc0:	a819                	j	80205fd6 <test_scheduler+0x6c>
    	wait_proc(NULL); // 等待所有子进程结束
    80205fc2:	4501                	li	a0,0
    80205fc4:	fffff097          	auipc	ra,0xfffff
    80205fc8:	450080e7          	jalr	1104(ra) # 80205414 <wait_proc>
	for (int i = 0; i < 3; i++) {
    80205fcc:	fe842783          	lw	a5,-24(s0)
    80205fd0:	2785                	addiw	a5,a5,1
    80205fd2:	fef42423          	sw	a5,-24(s0)
    80205fd6:	fe842783          	lw	a5,-24(s0)
    80205fda:	0007871b          	sext.w	a4,a5
    80205fde:	4789                	li	a5,2
    80205fe0:	fee7d1e3          	bge	a5,a4,80205fc2 <test_scheduler+0x58>
	}
    uint64 end_time = get_time();
    80205fe4:	ffffe097          	auipc	ra,0xffffe
    80205fe8:	040080e7          	jalr	64(ra) # 80204024 <get_time>
    80205fec:	fca43c23          	sd	a0,-40(s0)

    printf("Scheduler test completed in %lu cycles\n", end_time - start_time);
    80205ff0:	fd843703          	ld	a4,-40(s0)
    80205ff4:	fe043783          	ld	a5,-32(s0)
    80205ff8:	40f707b3          	sub	a5,a4,a5
    80205ffc:	85be                	mv	a1,a5
    80205ffe:	00003517          	auipc	a0,0x3
    80206002:	3ea50513          	addi	a0,a0,1002 # 802093e8 <etext+0x23e8>
    80206006:	ffffb097          	auipc	ra,0xffffb
    8020600a:	c7c080e7          	jalr	-900(ra) # 80200c82 <printf>
    printf("===== 测试结束 =====\n");
    8020600e:	00003517          	auipc	a0,0x3
    80206012:	40250513          	addi	a0,a0,1026 # 80209410 <etext+0x2410>
    80206016:	ffffb097          	auipc	ra,0xffffb
    8020601a:	c6c080e7          	jalr	-916(ra) # 80200c82 <printf>
}
    8020601e:	0001                	nop
    80206020:	70a2                	ld	ra,40(sp)
    80206022:	7402                	ld	s0,32(sp)
    80206024:	6145                	addi	sp,sp,48
    80206026:	8082                	ret

0000000080206028 <shared_buffer_init>:
static int proc_buffer = 0;
static int proc_produced = 0;

void shared_buffer_init() {
    80206028:	1141                	addi	sp,sp,-16
    8020602a:	e422                	sd	s0,8(sp)
    8020602c:	0800                	addi	s0,sp,16
    proc_buffer = 0;
    8020602e:	00007797          	auipc	a5,0x7
    80206032:	85278793          	addi	a5,a5,-1966 # 8020c880 <proc_buffer>
    80206036:	0007a023          	sw	zero,0(a5)
    proc_produced = 0;
    8020603a:	00007797          	auipc	a5,0x7
    8020603e:	84a78793          	addi	a5,a5,-1974 # 8020c884 <proc_produced>
    80206042:	0007a023          	sw	zero,0(a5)
}
    80206046:	0001                	nop
    80206048:	6422                	ld	s0,8(sp)
    8020604a:	0141                	addi	sp,sp,16
    8020604c:	8082                	ret

000000008020604e <producer_task>:

void producer_task(void) {
    8020604e:	1141                	addi	sp,sp,-16
    80206050:	e406                	sd	ra,8(sp)
    80206052:	e022                	sd	s0,0(sp)
    80206054:	0800                	addi	s0,sp,16
    proc_buffer = 42;
    80206056:	00007797          	auipc	a5,0x7
    8020605a:	82a78793          	addi	a5,a5,-2006 # 8020c880 <proc_buffer>
    8020605e:	02a00713          	li	a4,42
    80206062:	c398                	sw	a4,0(a5)
    proc_produced = 1;
    80206064:	00007797          	auipc	a5,0x7
    80206068:	82078793          	addi	a5,a5,-2016 # 8020c884 <proc_produced>
    8020606c:	4705                	li	a4,1
    8020606e:	c398                	sw	a4,0(a5)
    wakeup(&proc_produced); // 唤醒消费者
    80206070:	00007517          	auipc	a0,0x7
    80206074:	81450513          	addi	a0,a0,-2028 # 8020c884 <proc_produced>
    80206078:	fffff097          	auipc	ra,0xfffff
    8020607c:	6b6080e7          	jalr	1718(ra) # 8020572e <wakeup>
    printf("Producer: produced value %d\n", proc_buffer);
    80206080:	00007797          	auipc	a5,0x7
    80206084:	80078793          	addi	a5,a5,-2048 # 8020c880 <proc_buffer>
    80206088:	439c                	lw	a5,0(a5)
    8020608a:	85be                	mv	a1,a5
    8020608c:	00003517          	auipc	a0,0x3
    80206090:	3a450513          	addi	a0,a0,932 # 80209430 <etext+0x2430>
    80206094:	ffffb097          	auipc	ra,0xffffb
    80206098:	bee080e7          	jalr	-1042(ra) # 80200c82 <printf>
    exit_proc(0);
    8020609c:	4501                	li	a0,0
    8020609e:	fffff097          	auipc	ra,0xfffff
    802060a2:	33e080e7          	jalr	830(ra) # 802053dc <exit_proc>
}
    802060a6:	0001                	nop
    802060a8:	60a2                	ld	ra,8(sp)
    802060aa:	6402                	ld	s0,0(sp)
    802060ac:	0141                	addi	sp,sp,16
    802060ae:	8082                	ret

00000000802060b0 <consumer_task>:

void consumer_task(void) {
    802060b0:	1141                	addi	sp,sp,-16
    802060b2:	e406                	sd	ra,8(sp)
    802060b4:	e022                	sd	s0,0(sp)
    802060b6:	0800                	addi	s0,sp,16
    while (!proc_produced) {
    802060b8:	a809                	j	802060ca <consumer_task+0x1a>
        sleep(&proc_produced); // 等待生产者
    802060ba:	00006517          	auipc	a0,0x6
    802060be:	7ca50513          	addi	a0,a0,1994 # 8020c884 <proc_produced>
    802060c2:	fffff097          	auipc	ra,0xfffff
    802060c6:	602080e7          	jalr	1538(ra) # 802056c4 <sleep>
    while (!proc_produced) {
    802060ca:	00006797          	auipc	a5,0x6
    802060ce:	7ba78793          	addi	a5,a5,1978 # 8020c884 <proc_produced>
    802060d2:	439c                	lw	a5,0(a5)
    802060d4:	d3fd                	beqz	a5,802060ba <consumer_task+0xa>
    }
    printf("Consumer: consumed value %d\n", proc_buffer);
    802060d6:	00006797          	auipc	a5,0x6
    802060da:	7aa78793          	addi	a5,a5,1962 # 8020c880 <proc_buffer>
    802060de:	439c                	lw	a5,0(a5)
    802060e0:	85be                	mv	a1,a5
    802060e2:	00003517          	auipc	a0,0x3
    802060e6:	36e50513          	addi	a0,a0,878 # 80209450 <etext+0x2450>
    802060ea:	ffffb097          	auipc	ra,0xffffb
    802060ee:	b98080e7          	jalr	-1128(ra) # 80200c82 <printf>
    exit_proc(0);
    802060f2:	4501                	li	a0,0
    802060f4:	fffff097          	auipc	ra,0xfffff
    802060f8:	2e8080e7          	jalr	744(ra) # 802053dc <exit_proc>
}
    802060fc:	0001                	nop
    802060fe:	60a2                	ld	ra,8(sp)
    80206100:	6402                	ld	s0,0(sp)
    80206102:	0141                	addi	sp,sp,16
    80206104:	8082                	ret

0000000080206106 <test_synchronization>:
void test_synchronization(void) {
    80206106:	1141                	addi	sp,sp,-16
    80206108:	e406                	sd	ra,8(sp)
    8020610a:	e022                	sd	s0,0(sp)
    8020610c:	0800                	addi	s0,sp,16
    printf("===== 测试开始: 同步机制测试 =====\n");
    8020610e:	00003517          	auipc	a0,0x3
    80206112:	36250513          	addi	a0,a0,866 # 80209470 <etext+0x2470>
    80206116:	ffffb097          	auipc	ra,0xffffb
    8020611a:	b6c080e7          	jalr	-1172(ra) # 80200c82 <printf>

    // 初始化共享缓冲区
    shared_buffer_init();
    8020611e:	00000097          	auipc	ra,0x0
    80206122:	f0a080e7          	jalr	-246(ra) # 80206028 <shared_buffer_init>

    // 创建生产者和消费者进程
    create_kernel_proc(producer_task);
    80206126:	00000517          	auipc	a0,0x0
    8020612a:	f2850513          	addi	a0,a0,-216 # 8020604e <producer_task>
    8020612e:	fffff097          	auipc	ra,0xfffff
    80206132:	054080e7          	jalr	84(ra) # 80205182 <create_kernel_proc>
    create_kernel_proc(consumer_task);
    80206136:	00000517          	auipc	a0,0x0
    8020613a:	f7a50513          	addi	a0,a0,-134 # 802060b0 <consumer_task>
    8020613e:	fffff097          	auipc	ra,0xfffff
    80206142:	044080e7          	jalr	68(ra) # 80205182 <create_kernel_proc>

    // 等待两个进程完成
    wait_proc(NULL);
    80206146:	4501                	li	a0,0
    80206148:	fffff097          	auipc	ra,0xfffff
    8020614c:	2cc080e7          	jalr	716(ra) # 80205414 <wait_proc>
    wait_proc(NULL);
    80206150:	4501                	li	a0,0
    80206152:	fffff097          	auipc	ra,0xfffff
    80206156:	2c2080e7          	jalr	706(ra) # 80205414 <wait_proc>

    printf("===== 测试结束 =====\n");
    8020615a:	00003517          	auipc	a0,0x3
    8020615e:	2b650513          	addi	a0,a0,694 # 80209410 <etext+0x2410>
    80206162:	ffffb097          	auipc	ra,0xffffb
    80206166:	b20080e7          	jalr	-1248(ra) # 80200c82 <printf>
}
    8020616a:	0001                	nop
    8020616c:	60a2                	ld	ra,8(sp)
    8020616e:	6402                	ld	s0,0(sp)
    80206170:	0141                	addi	sp,sp,16
    80206172:	8082                	ret

0000000080206174 <sys_access_task>:

void sys_access_task(void) {
    80206174:	1101                	addi	sp,sp,-32
    80206176:	ec06                	sd	ra,24(sp)
    80206178:	e822                	sd	s0,16(sp)
    8020617a:	1000                	addi	s0,sp,32
    volatile int *ptr = (int*)0x80200000; // 内核空间地址
    8020617c:	40100793          	li	a5,1025
    80206180:	07d6                	slli	a5,a5,0x15
    80206182:	fef43423          	sd	a5,-24(s0)
    printf("SYS: try read kernel addr 0x80200000\n");
    80206186:	00003517          	auipc	a0,0x3
    8020618a:	31a50513          	addi	a0,a0,794 # 802094a0 <etext+0x24a0>
    8020618e:	ffffb097          	auipc	ra,0xffffb
    80206192:	af4080e7          	jalr	-1292(ra) # 80200c82 <printf>
    int val = *ptr;
    80206196:	fe843783          	ld	a5,-24(s0)
    8020619a:	439c                	lw	a5,0(a5)
    8020619c:	fef42223          	sw	a5,-28(s0)
    printf("SYS: read success, value=%d\n", val);
    802061a0:	fe442783          	lw	a5,-28(s0)
    802061a4:	85be                	mv	a1,a5
    802061a6:	00003517          	auipc	a0,0x3
    802061aa:	32250513          	addi	a0,a0,802 # 802094c8 <etext+0x24c8>
    802061ae:	ffffb097          	auipc	ra,0xffffb
    802061b2:	ad4080e7          	jalr	-1324(ra) # 80200c82 <printf>
    exit_proc(0);
    802061b6:	4501                	li	a0,0
    802061b8:	fffff097          	auipc	ra,0xfffff
    802061bc:	224080e7          	jalr	548(ra) # 802053dc <exit_proc>
}
    802061c0:	0001                	nop
    802061c2:	60e2                	ld	ra,24(sp)
    802061c4:	6442                	ld	s0,16(sp)
    802061c6:	6105                	addi	sp,sp,32
    802061c8:	8082                	ret

00000000802061ca <test_sys_usr>:

void test_sys_usr(void) {
    802061ca:	1101                	addi	sp,sp,-32
    802061cc:	ec06                	sd	ra,24(sp)
    802061ce:	e822                	sd	s0,16(sp)
    802061d0:	1000                	addi	s0,sp,32
    printf("===== 测试: 用户/系统进程访问内核空间 =====\n");
    802061d2:	00003517          	auipc	a0,0x3
    802061d6:	31650513          	addi	a0,a0,790 # 802094e8 <etext+0x24e8>
    802061da:	ffffb097          	auipc	ra,0xffffb
    802061de:	aa8080e7          	jalr	-1368(ra) # 80200c82 <printf>
    int sys_pid = create_kernel_proc(sys_access_task); // 系统进程
    802061e2:	00000517          	auipc	a0,0x0
    802061e6:	f9250513          	addi	a0,a0,-110 # 80206174 <sys_access_task>
    802061ea:	fffff097          	auipc	ra,0xfffff
    802061ee:	f98080e7          	jalr	-104(ra) # 80205182 <create_kernel_proc>
    802061f2:	87aa                	mv	a5,a0
    802061f4:	fef42623          	sw	a5,-20(s0)
	printf("创建系统进程：%d成功\n",sys_pid);
    802061f8:	fec42783          	lw	a5,-20(s0)
    802061fc:	85be                	mv	a1,a5
    802061fe:	00003517          	auipc	a0,0x3
    80206202:	32a50513          	addi	a0,a0,810 # 80209528 <etext+0x2528>
    80206206:	ffffb097          	auipc	ra,0xffffb
    8020620a:	a7c080e7          	jalr	-1412(ra) # 80200c82 <printf>
	int status =0;
    8020620e:	fe042023          	sw	zero,-32(s0)
	int ret_val = wait_proc(&status); // 等待系统进程
    80206212:	fe040793          	addi	a5,s0,-32
    80206216:	853e                	mv	a0,a5
    80206218:	fffff097          	auipc	ra,0xfffff
    8020621c:	1fc080e7          	jalr	508(ra) # 80205414 <wait_proc>
    80206220:	87aa                	mv	a5,a0
    80206222:	fef42423          	sw	a5,-24(s0)
	printf("系统进程%d退出，退出码为%d\n",ret_val,status);
    80206226:	fe042703          	lw	a4,-32(s0)
    8020622a:	fe842783          	lw	a5,-24(s0)
    8020622e:	863a                	mv	a2,a4
    80206230:	85be                	mv	a1,a5
    80206232:	00003517          	auipc	a0,0x3
    80206236:	31650513          	addi	a0,a0,790 # 80209548 <etext+0x2548>
    8020623a:	ffffb097          	auipc	ra,0xffffb
    8020623e:	a48080e7          	jalr	-1464(ra) # 80200c82 <printf>
    // 创建真正的用户进程，运行 user_test_bin
    int usr_pid = create_user_proc(user_test_bin, user_test_bin_len);
    80206242:	00004797          	auipc	a5,0x4
    80206246:	dbe78793          	addi	a5,a5,-578 # 8020a000 <user_test_bin_len>
    8020624a:	439c                	lw	a5,0(a5)
    8020624c:	2781                	sext.w	a5,a5
    8020624e:	85be                	mv	a1,a5
    80206250:	00006517          	auipc	a0,0x6
    80206254:	e4050513          	addi	a0,a0,-448 # 8020c090 <user_test_bin>
    80206258:	fffff097          	auipc	ra,0xfffff
    8020625c:	f98080e7          	jalr	-104(ra) # 802051f0 <create_user_proc>
    80206260:	87aa                	mv	a5,a0
    80206262:	fef42223          	sw	a5,-28(s0)
    printf("创建用户进程：%d成功\n", usr_pid);
    80206266:	fe442783          	lw	a5,-28(s0)
    8020626a:	85be                	mv	a1,a5
    8020626c:	00003517          	auipc	a0,0x3
    80206270:	30450513          	addi	a0,a0,772 # 80209570 <etext+0x2570>
    80206274:	ffffb097          	auipc	ra,0xffffb
    80206278:	a0e080e7          	jalr	-1522(ra) # 80200c82 <printf>
    ret_val = wait_proc(&status); // 等待用户进程
    8020627c:	fe040793          	addi	a5,s0,-32
    80206280:	853e                	mv	a0,a5
    80206282:	fffff097          	auipc	ra,0xfffff
    80206286:	192080e7          	jalr	402(ra) # 80205414 <wait_proc>
    8020628a:	87aa                	mv	a5,a0
    8020628c:	fef42423          	sw	a5,-24(s0)
    printf("用户进程%d退出，退出码为%d\n", ret_val,status);
    80206290:	fe042703          	lw	a4,-32(s0)
    80206294:	fe842783          	lw	a5,-24(s0)
    80206298:	863a                	mv	a2,a4
    8020629a:	85be                	mv	a1,a5
    8020629c:	00003517          	auipc	a0,0x3
    802062a0:	2f450513          	addi	a0,a0,756 # 80209590 <etext+0x2590>
    802062a4:	ffffb097          	auipc	ra,0xffffb
    802062a8:	9de080e7          	jalr	-1570(ra) # 80200c82 <printf>
    printf("===== 测试结束 =====\n");
    802062ac:	00003517          	auipc	a0,0x3
    802062b0:	16450513          	addi	a0,a0,356 # 80209410 <etext+0x2410>
    802062b4:	ffffb097          	auipc	ra,0xffffb
    802062b8:	9ce080e7          	jalr	-1586(ra) # 80200c82 <printf>
    802062bc:	0001                	nop
    802062be:	60e2                	ld	ra,24(sp)
    802062c0:	6442                	ld	s0,16(sp)
    802062c2:	6105                	addi	sp,sp,32
    802062c4:	8082                	ret

00000000802062c6 <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    802062c6:	7179                	addi	sp,sp,-48
    802062c8:	f422                	sd	s0,40(sp)
    802062ca:	1800                	addi	s0,sp,48
    802062cc:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    802062d0:	fe042623          	sw	zero,-20(s0)
    802062d4:	a031                	j	802062e0 <strlen+0x1a>
    802062d6:	fec42783          	lw	a5,-20(s0)
    802062da:	2785                	addiw	a5,a5,1
    802062dc:	fef42623          	sw	a5,-20(s0)
    802062e0:	fec42783          	lw	a5,-20(s0)
    802062e4:	fd843703          	ld	a4,-40(s0)
    802062e8:	97ba                	add	a5,a5,a4
    802062ea:	0007c783          	lbu	a5,0(a5)
    802062ee:	f7e5                	bnez	a5,802062d6 <strlen+0x10>
        ;
    return n;
    802062f0:	fec42783          	lw	a5,-20(s0)
}
    802062f4:	853e                	mv	a0,a5
    802062f6:	7422                	ld	s0,40(sp)
    802062f8:	6145                	addi	sp,sp,48
    802062fa:	8082                	ret

00000000802062fc <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    802062fc:	1101                	addi	sp,sp,-32
    802062fe:	ec22                	sd	s0,24(sp)
    80206300:	1000                	addi	s0,sp,32
    80206302:	fea43423          	sd	a0,-24(s0)
    80206306:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    8020630a:	a819                	j	80206320 <strcmp+0x24>
        p++, q++;
    8020630c:	fe843783          	ld	a5,-24(s0)
    80206310:	0785                	addi	a5,a5,1
    80206312:	fef43423          	sd	a5,-24(s0)
    80206316:	fe043783          	ld	a5,-32(s0)
    8020631a:	0785                	addi	a5,a5,1
    8020631c:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    80206320:	fe843783          	ld	a5,-24(s0)
    80206324:	0007c783          	lbu	a5,0(a5)
    80206328:	cb99                	beqz	a5,8020633e <strcmp+0x42>
    8020632a:	fe843783          	ld	a5,-24(s0)
    8020632e:	0007c703          	lbu	a4,0(a5)
    80206332:	fe043783          	ld	a5,-32(s0)
    80206336:	0007c783          	lbu	a5,0(a5)
    8020633a:	fcf709e3          	beq	a4,a5,8020630c <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    8020633e:	fe843783          	ld	a5,-24(s0)
    80206342:	0007c783          	lbu	a5,0(a5)
    80206346:	0007871b          	sext.w	a4,a5
    8020634a:	fe043783          	ld	a5,-32(s0)
    8020634e:	0007c783          	lbu	a5,0(a5)
    80206352:	2781                	sext.w	a5,a5
    80206354:	40f707bb          	subw	a5,a4,a5
    80206358:	2781                	sext.w	a5,a5
}
    8020635a:	853e                	mv	a0,a5
    8020635c:	6462                	ld	s0,24(sp)
    8020635e:	6105                	addi	sp,sp,32
    80206360:	8082                	ret

0000000080206362 <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    80206362:	7179                	addi	sp,sp,-48
    80206364:	f422                	sd	s0,40(sp)
    80206366:	1800                	addi	s0,sp,48
    80206368:	fca43c23          	sd	a0,-40(s0)
    8020636c:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    80206370:	fd843783          	ld	a5,-40(s0)
    80206374:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    80206378:	0001                	nop
    8020637a:	fd043703          	ld	a4,-48(s0)
    8020637e:	00170793          	addi	a5,a4,1
    80206382:	fcf43823          	sd	a5,-48(s0)
    80206386:	fd843783          	ld	a5,-40(s0)
    8020638a:	00178693          	addi	a3,a5,1
    8020638e:	fcd43c23          	sd	a3,-40(s0)
    80206392:	00074703          	lbu	a4,0(a4)
    80206396:	00e78023          	sb	a4,0(a5)
    8020639a:	0007c783          	lbu	a5,0(a5)
    8020639e:	fff1                	bnez	a5,8020637a <strcpy+0x18>
        ;
    return os;
    802063a0:	fe843783          	ld	a5,-24(s0)
}
    802063a4:	853e                	mv	a0,a5
    802063a6:	7422                	ld	s0,40(sp)
    802063a8:	6145                	addi	sp,sp,48
    802063aa:	8082                	ret

00000000802063ac <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    802063ac:	7139                	addi	sp,sp,-64
    802063ae:	fc22                	sd	s0,56(sp)
    802063b0:	0080                	addi	s0,sp,64
    802063b2:	fca43c23          	sd	a0,-40(s0)
    802063b6:	fcb43823          	sd	a1,-48(s0)
    802063ba:	87b2                	mv	a5,a2
    802063bc:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    802063c0:	fd843783          	ld	a5,-40(s0)
    802063c4:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    802063c8:	fcc42783          	lw	a5,-52(s0)
    802063cc:	2781                	sext.w	a5,a5
    802063ce:	00f04563          	bgtz	a5,802063d8 <safestrcpy+0x2c>
        return os;
    802063d2:	fe843783          	ld	a5,-24(s0)
    802063d6:	a0a9                	j	80206420 <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    802063d8:	0001                	nop
    802063da:	fcc42783          	lw	a5,-52(s0)
    802063de:	37fd                	addiw	a5,a5,-1
    802063e0:	fcf42623          	sw	a5,-52(s0)
    802063e4:	fcc42783          	lw	a5,-52(s0)
    802063e8:	2781                	sext.w	a5,a5
    802063ea:	02f05563          	blez	a5,80206414 <safestrcpy+0x68>
    802063ee:	fd043703          	ld	a4,-48(s0)
    802063f2:	00170793          	addi	a5,a4,1
    802063f6:	fcf43823          	sd	a5,-48(s0)
    802063fa:	fd843783          	ld	a5,-40(s0)
    802063fe:	00178693          	addi	a3,a5,1
    80206402:	fcd43c23          	sd	a3,-40(s0)
    80206406:	00074703          	lbu	a4,0(a4)
    8020640a:	00e78023          	sb	a4,0(a5)
    8020640e:	0007c783          	lbu	a5,0(a5)
    80206412:	f7e1                	bnez	a5,802063da <safestrcpy+0x2e>
        ;
    *s = 0;
    80206414:	fd843783          	ld	a5,-40(s0)
    80206418:	00078023          	sb	zero,0(a5)
    return os;
    8020641c:	fe843783          	ld	a5,-24(s0)
    80206420:	853e                	mv	a0,a5
    80206422:	7462                	ld	s0,56(sp)
    80206424:	6121                	addi	sp,sp,64
    80206426:	8082                	ret
	...
