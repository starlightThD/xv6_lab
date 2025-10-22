
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
    80200018:	d3c58593          	addi	a1,a1,-708 # 8020bd50 <_bss_end>

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
    80200032:	1101                	addi	sp,sp,-32 # 80208fe0 <small_numbers+0x2b90>
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
    802000a4:	ab4080e7          	jalr	-1356(ra) # 80200b54 <printf>
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
    802000be:	9ce080e7          	jalr	-1586(ra) # 80202a88 <pmm_init>
	kvminit();
    802000c2:	00002097          	auipc	ra,0x2
    802000c6:	2d0080e7          	jalr	720(ra) # 80202392 <kvminit>
    kvminithart();
    802000ca:	00002097          	auipc	ra,0x2
    802000ce:	31a080e7          	jalr	794(ra) # 802023e4 <kvminithart>
	trap_init();
    802000d2:	00003097          	auipc	ra,0x3
    802000d6:	fc0080e7          	jalr	-64(ra) # 80203092 <trap_init>
	uart_init();
    802000da:	00000097          	auipc	ra,0x0
    802000de:	4e6080e7          	jalr	1254(ra) # 802005c0 <uart_init>
	intr_on();
    802000e2:	00000097          	auipc	ra,0x0
    802000e6:	f84080e7          	jalr	-124(ra) # 80200066 <intr_on>
    printf("===============================================\n");
    802000ea:	00006517          	auipc	a0,0x6
    802000ee:	fce50513          	addi	a0,a0,-50 # 802060b8 <etext+0xb8>
    802000f2:	00001097          	auipc	ra,0x1
    802000f6:	a62080e7          	jalr	-1438(ra) # 80200b54 <printf>
    printf("        RISC-V Operating System v1.0         \n");
    802000fa:	00006517          	auipc	a0,0x6
    802000fe:	ff650513          	addi	a0,a0,-10 # 802060f0 <etext+0xf0>
    80200102:	00001097          	auipc	ra,0x1
    80200106:	a52080e7          	jalr	-1454(ra) # 80200b54 <printf>
    printf("===============================================\n\n");
    8020010a:	00006517          	auipc	a0,0x6
    8020010e:	01650513          	addi	a0,a0,22 # 80206120 <etext+0x120>
    80200112:	00001097          	auipc	ra,0x1
    80200116:	a42080e7          	jalr	-1470(ra) # 80200b54 <printf>
	init_proc(); // 初始化进程管理子系统
    8020011a:	00004097          	auipc	ra,0x4
    8020011e:	024080e7          	jalr	36(ra) # 8020413e <init_proc>
	int main_pid = create_proc(kernel_main);
    80200122:	00000517          	auipc	a0,0x0
    80200126:	3d250513          	addi	a0,a0,978 # 802004f4 <kernel_main>
    8020012a:	00004097          	auipc	ra,0x4
    8020012e:	404080e7          	jalr	1028(ra) # 8020452e <create_proc>
    80200132:	87aa                	mv	a5,a0
    80200134:	fef42623          	sw	a5,-20(s0)
	if (main_pid < 0){
    80200138:	fec42783          	lw	a5,-20(s0)
    8020013c:	2781                	sext.w	a5,a5
    8020013e:	0007da63          	bgez	a5,80200152 <start+0xa0>
		panic("START: create main process failed!\n");
    80200142:	00006517          	auipc	a0,0x6
    80200146:	01650513          	addi	a0,a0,22 # 80206158 <etext+0x158>
    8020014a:	00001097          	auipc	ra,0x1
    8020014e:	312080e7          	jalr	786(ra) # 8020145c <panic>
	schedule();
    80200152:	00004097          	auipc	ra,0x4
    80200156:	56c080e7          	jalr	1388(ra) # 802046be <schedule>
    panic("START: main() exit unexpectedly!!!\n");
    8020015a:	00006517          	auipc	a0,0x6
    8020015e:	02650513          	addi	a0,a0,38 # 80206180 <etext+0x180>
    80200162:	00001097          	auipc	ra,0x1
    80200166:	2fa080e7          	jalr	762(ra) # 8020145c <panic>
}
    8020016a:	0001                	nop
    8020016c:	60e2                	ld	ra,24(sp)
    8020016e:	6442                	ld	s0,16(sp)
    80200170:	6105                	addi	sp,sp,32
    80200172:	8082                	ret

0000000080200174 <console>:
void console(void) {
    80200174:	7129                	addi	sp,sp,-320
    80200176:	fe06                	sd	ra,312(sp)
    80200178:	fa22                	sd	s0,304(sp)
    8020017a:	0280                	addi	s0,sp,320
    int exit_requested = 0;
    8020017c:	fe042623          	sw	zero,-20(s0)
    printf("可用命令:\n");
    80200180:	00006517          	auipc	a0,0x6
    80200184:	02850513          	addi	a0,a0,40 # 802061a8 <etext+0x1a8>
    80200188:	00001097          	auipc	ra,0x1
    8020018c:	9cc080e7          	jalr	-1588(ra) # 80200b54 <printf>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    80200190:	fe042423          	sw	zero,-24(s0)
    80200194:	a0b9                	j	802001e2 <console+0x6e>
        printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
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
    802001d4:	984080e7          	jalr	-1660(ra) # 80200b54 <printf>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    802001d8:	fe842783          	lw	a5,-24(s0)
    802001dc:	2785                	addiw	a5,a5,1
    802001de:	fef42423          	sw	a5,-24(s0)
    802001e2:	fe842783          	lw	a5,-24(s0)
    802001e6:	873e                	mv	a4,a5
    802001e8:	478d                	li	a5,3
    802001ea:	fae7f6e3          	bgeu	a5,a4,80200196 <console+0x22>
    printf("  help          - 显示此帮助\n");
    802001ee:	00006517          	auipc	a0,0x6
    802001f2:	fda50513          	addi	a0,a0,-38 # 802061c8 <etext+0x1c8>
    802001f6:	00001097          	auipc	ra,0x1
    802001fa:	95e080e7          	jalr	-1698(ra) # 80200b54 <printf>
    printf("  exit          - 退出控制台\n");
    802001fe:	00006517          	auipc	a0,0x6
    80200202:	ff250513          	addi	a0,a0,-14 # 802061f0 <etext+0x1f0>
    80200206:	00001097          	auipc	ra,0x1
    8020020a:	94e080e7          	jalr	-1714(ra) # 80200b54 <printf>
    printf("  ps            - 显示进程状态\n");
    8020020e:	00006517          	auipc	a0,0x6
    80200212:	00a50513          	addi	a0,a0,10 # 80206218 <etext+0x218>
    80200216:	00001097          	auipc	ra,0x1
    8020021a:	93e080e7          	jalr	-1730(ra) # 80200b54 <printf>
    while (!exit_requested) {
    8020021e:	ac4d                	j	802004d0 <console+0x35c>
        printf("Console >>> ");
    80200220:	00006517          	auipc	a0,0x6
    80200224:	02050513          	addi	a0,a0,32 # 80206240 <etext+0x240>
    80200228:	00001097          	auipc	ra,0x1
    8020022c:	92c080e7          	jalr	-1748(ra) # 80200b54 <printf>
        readline(input_buffer, sizeof(input_buffer));
    80200230:	ed040793          	addi	a5,s0,-304
    80200234:	10000593          	li	a1,256
    80200238:	853e                	mv	a0,a5
    8020023a:	00000097          	auipc	ra,0x0
    8020023e:	614080e7          	jalr	1556(ra) # 8020084e <readline>
        if (strcmp(input_buffer, "exit") == 0) {
    80200242:	ed040793          	addi	a5,s0,-304
    80200246:	00006597          	auipc	a1,0x6
    8020024a:	00a58593          	addi	a1,a1,10 # 80206250 <etext+0x250>
    8020024e:	853e                	mv	a0,a5
    80200250:	00005097          	auipc	ra,0x5
    80200254:	1cc080e7          	jalr	460(ra) # 8020541c <strcmp>
    80200258:	87aa                	mv	a5,a0
    8020025a:	e789                	bnez	a5,80200264 <console+0xf0>
            exit_requested = 1;
    8020025c:	4785                	li	a5,1
    8020025e:	fef42623          	sw	a5,-20(s0)
    80200262:	a4bd                	j	802004d0 <console+0x35c>
        } else if (strcmp(input_buffer, "help") == 0) {
    80200264:	ed040793          	addi	a5,s0,-304
    80200268:	00006597          	auipc	a1,0x6
    8020026c:	ff058593          	addi	a1,a1,-16 # 80206258 <etext+0x258>
    80200270:	853e                	mv	a0,a5
    80200272:	00005097          	auipc	ra,0x5
    80200276:	1aa080e7          	jalr	426(ra) # 8020541c <strcmp>
    8020027a:	87aa                	mv	a5,a0
    8020027c:	e3cd                	bnez	a5,8020031e <console+0x1aa>
            printf("可用命令:\n");
    8020027e:	00006517          	auipc	a0,0x6
    80200282:	f2a50513          	addi	a0,a0,-214 # 802061a8 <etext+0x1a8>
    80200286:	00001097          	auipc	ra,0x1
    8020028a:	8ce080e7          	jalr	-1842(ra) # 80200b54 <printf>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    8020028e:	fe042223          	sw	zero,-28(s0)
    80200292:	a0b9                	j	802002e0 <console+0x16c>
                printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
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
    802002d2:	886080e7          	jalr	-1914(ra) # 80200b54 <printf>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    802002d6:	fe442783          	lw	a5,-28(s0)
    802002da:	2785                	addiw	a5,a5,1
    802002dc:	fef42223          	sw	a5,-28(s0)
    802002e0:	fe442783          	lw	a5,-28(s0)
    802002e4:	873e                	mv	a4,a5
    802002e6:	478d                	li	a5,3
    802002e8:	fae7f6e3          	bgeu	a5,a4,80200294 <console+0x120>
            printf("  help          - 显示此帮助\n");
    802002ec:	00006517          	auipc	a0,0x6
    802002f0:	edc50513          	addi	a0,a0,-292 # 802061c8 <etext+0x1c8>
    802002f4:	00001097          	auipc	ra,0x1
    802002f8:	860080e7          	jalr	-1952(ra) # 80200b54 <printf>
            printf("  exit          - 退出控制台\n");
    802002fc:	00006517          	auipc	a0,0x6
    80200300:	ef450513          	addi	a0,a0,-268 # 802061f0 <etext+0x1f0>
    80200304:	00001097          	auipc	ra,0x1
    80200308:	850080e7          	jalr	-1968(ra) # 80200b54 <printf>
            printf("  ps            - 显示进程状态\n");
    8020030c:	00006517          	auipc	a0,0x6
    80200310:	f0c50513          	addi	a0,a0,-244 # 80206218 <etext+0x218>
    80200314:	00001097          	auipc	ra,0x1
    80200318:	840080e7          	jalr	-1984(ra) # 80200b54 <printf>
    8020031c:	aa55                	j	802004d0 <console+0x35c>
        } else if (strcmp(input_buffer, "ps") == 0) {
    8020031e:	ed040793          	addi	a5,s0,-304
    80200322:	00006597          	auipc	a1,0x6
    80200326:	f3e58593          	addi	a1,a1,-194 # 80206260 <etext+0x260>
    8020032a:	853e                	mv	a0,a5
    8020032c:	00005097          	auipc	ra,0x5
    80200330:	0f0080e7          	jalr	240(ra) # 8020541c <strcmp>
    80200334:	87aa                	mv	a5,a0
    80200336:	e791                	bnez	a5,80200342 <console+0x1ce>
            print_proc_table();
    80200338:	00005097          	auipc	ra,0x5
    8020033c:	8be080e7          	jalr	-1858(ra) # 80204bf6 <print_proc_table>
    80200340:	aa41                	j	802004d0 <console+0x35c>
            int found = 0;
    80200342:	fe042023          	sw	zero,-32(s0)
            for (int i = 0; i < COMMAND_COUNT; i++) {
    80200346:	fc042e23          	sw	zero,-36(s0)
    8020034a:	aa99                	j	802004a0 <console+0x32c>
                if (strcmp(input_buffer, command_table[i].name) == 0) {
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
    80200370:	0b0080e7          	jalr	176(ra) # 8020541c <strcmp>
    80200374:	87aa                	mv	a5,a0
    80200376:	12079063          	bnez	a5,80200496 <console+0x322>
                    int pid = create_proc(command_table[i].func);
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
    80200398:	19a080e7          	jalr	410(ra) # 8020452e <create_proc>
    8020039c:	87aa                	mv	a5,a0
    8020039e:	fcf42c23          	sw	a5,-40(s0)
                    if (pid < 0) {
    802003a2:	fd842783          	lw	a5,-40(s0)
    802003a6:	2781                	sext.w	a5,a5
    802003a8:	0207d863          	bgez	a5,802003d8 <console+0x264>
                        printf("创建%s进程失败\n", command_table[i].name);
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
    802003d2:	786080e7          	jalr	1926(ra) # 80200b54 <printf>
    802003d6:	a865                	j	8020048e <console+0x31a>
                        printf("创建%s进程成功，PID: %d\n", command_table[i].name, pid);
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
    80200404:	754080e7          	jalr	1876(ra) # 80200b54 <printf>
                        int waited_pid = wait_proc(&status);
    80200408:	ecc40793          	addi	a5,s0,-308
    8020040c:	853e                	mv	a0,a5
    8020040e:	00004097          	auipc	ra,0x4
    80200412:	1d4080e7          	jalr	468(ra) # 802045e2 <wait_proc>
    80200416:	87aa                	mv	a5,a0
    80200418:	fcf42a23          	sw	a5,-44(s0)
                        if (waited_pid == pid) {
    8020041c:	fd442783          	lw	a5,-44(s0)
    80200420:	873e                	mv	a4,a5
    80200422:	fd842783          	lw	a5,-40(s0)
    80200426:	2701                	sext.w	a4,a4
    80200428:	2781                	sext.w	a5,a5
    8020042a:	02f71d63          	bne	a4,a5,80200464 <console+0x2f0>
                            printf("%s进程(PID: %d)已退出，状态码: %d\n", command_table[i].name, pid, status);
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
    8020045e:	6fa080e7          	jalr	1786(ra) # 80200b54 <printf>
    80200462:	a035                	j	8020048e <console+0x31a>
                            printf("等待%s进程时发生错误\n", command_table[i].name);
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
    8020048a:	6ce080e7          	jalr	1742(ra) # 80200b54 <printf>
                    found = 1;
    8020048e:	4785                	li	a5,1
    80200490:	fef42023          	sw	a5,-32(s0)
                    break;
    80200494:	a821                	j	802004ac <console+0x338>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    80200496:	fdc42783          	lw	a5,-36(s0)
    8020049a:	2785                	addiw	a5,a5,1
    8020049c:	fcf42e23          	sw	a5,-36(s0)
    802004a0:	fdc42783          	lw	a5,-36(s0)
    802004a4:	873e                	mv	a4,a5
    802004a6:	478d                	li	a5,3
    802004a8:	eae7f2e3          	bgeu	a5,a4,8020034c <console+0x1d8>
            if (!found && input_buffer[0] != '\0') {
    802004ac:	fe042783          	lw	a5,-32(s0)
    802004b0:	2781                	sext.w	a5,a5
    802004b2:	ef99                	bnez	a5,802004d0 <console+0x35c>
    802004b4:	ed044783          	lbu	a5,-304(s0)
    802004b8:	cf81                	beqz	a5,802004d0 <console+0x35c>
                printf("无效命令: %s\n", input_buffer);
    802004ba:	ed040793          	addi	a5,s0,-304
    802004be:	85be                	mv	a1,a5
    802004c0:	00006517          	auipc	a0,0x6
    802004c4:	e3050513          	addi	a0,a0,-464 # 802062f0 <etext+0x2f0>
    802004c8:	00000097          	auipc	ra,0x0
    802004cc:	68c080e7          	jalr	1676(ra) # 80200b54 <printf>
    while (!exit_requested) {
    802004d0:	fec42783          	lw	a5,-20(s0)
    802004d4:	2781                	sext.w	a5,a5
    802004d6:	d40785e3          	beqz	a5,80200220 <console+0xac>
    printf("控制台进程退出\n");
    802004da:	00006517          	auipc	a0,0x6
    802004de:	e2e50513          	addi	a0,a0,-466 # 80206308 <etext+0x308>
    802004e2:	00000097          	auipc	ra,0x0
    802004e6:	672080e7          	jalr	1650(ra) # 80200b54 <printf>
    return;
    802004ea:	0001                	nop
}
    802004ec:	70f2                	ld	ra,312(sp)
    802004ee:	7452                	ld	s0,304(sp)
    802004f0:	6131                	addi	sp,sp,320
    802004f2:	8082                	ret

00000000802004f4 <kernel_main>:
void kernel_main(void){
    802004f4:	1101                	addi	sp,sp,-32
    802004f6:	ec06                	sd	ra,24(sp)
    802004f8:	e822                	sd	s0,16(sp)
    802004fa:	1000                	addi	s0,sp,32
	clear_screen();
    802004fc:	00001097          	auipc	ra,0x1
    80200500:	a50080e7          	jalr	-1456(ra) # 80200f4c <clear_screen>
	int console_pid = create_proc(console);
    80200504:	00000517          	auipc	a0,0x0
    80200508:	c7050513          	addi	a0,a0,-912 # 80200174 <console>
    8020050c:	00004097          	auipc	ra,0x4
    80200510:	022080e7          	jalr	34(ra) # 8020452e <create_proc>
    80200514:	87aa                	mv	a5,a0
    80200516:	fef42623          	sw	a5,-20(s0)
	if (console_pid < 0){
    8020051a:	fec42783          	lw	a5,-20(s0)
    8020051e:	2781                	sext.w	a5,a5
    80200520:	0007db63          	bgez	a5,80200536 <kernel_main+0x42>
		panic("KERNEL_MAIN: create console process failed!\n");
    80200524:	00006517          	auipc	a0,0x6
    80200528:	dfc50513          	addi	a0,a0,-516 # 80206320 <etext+0x320>
    8020052c:	00001097          	auipc	ra,0x1
    80200530:	f30080e7          	jalr	-208(ra) # 8020145c <panic>
    80200534:	a821                	j	8020054c <kernel_main+0x58>
		printf("KERNEL_MAIN: console process created with PID %d\n", console_pid);
    80200536:	fec42783          	lw	a5,-20(s0)
    8020053a:	85be                	mv	a1,a5
    8020053c:	00006517          	auipc	a0,0x6
    80200540:	e1450513          	addi	a0,a0,-492 # 80206350 <etext+0x350>
    80200544:	00000097          	auipc	ra,0x0
    80200548:	610080e7          	jalr	1552(ra) # 80200b54 <printf>
	int pid = wait_proc(&status);
    8020054c:	fe440793          	addi	a5,s0,-28
    80200550:	853e                	mv	a0,a5
    80200552:	00004097          	auipc	ra,0x4
    80200556:	090080e7          	jalr	144(ra) # 802045e2 <wait_proc>
    8020055a:	87aa                	mv	a5,a0
    8020055c:	fef42423          	sw	a5,-24(s0)
	if(pid == console_pid){
    80200560:	fe842783          	lw	a5,-24(s0)
    80200564:	873e                	mv	a4,a5
    80200566:	fec42783          	lw	a5,-20(s0)
    8020056a:	2701                	sext.w	a4,a4
    8020056c:	2781                	sext.w	a5,a5
    8020056e:	02f71663          	bne	a4,a5,8020059a <kernel_main+0xa6>
		printf("KERNEL_MAIN: console process exited with status %d\n", status);
    80200572:	fe442783          	lw	a5,-28(s0)
    80200576:	85be                	mv	a1,a5
    80200578:	00006517          	auipc	a0,0x6
    8020057c:	e1050513          	addi	a0,a0,-496 # 80206388 <etext+0x388>
    80200580:	00000097          	auipc	ra,0x0
    80200584:	5d4080e7          	jalr	1492(ra) # 80200b54 <printf>
		printf("KERNEL_MAIN: kernel will shutdown\n");
    80200588:	00006517          	auipc	a0,0x6
    8020058c:	e3850513          	addi	a0,a0,-456 # 802063c0 <etext+0x3c0>
    80200590:	00000097          	auipc	ra,0x0
    80200594:	5c4080e7          	jalr	1476(ra) # 80200b54 <printf>
	return;
    80200598:	a005                	j	802005b8 <kernel_main+0xc4>
		printf("KERNEL_MAIN: unexpected process %d exited with status %d\n", pid, status);
    8020059a:	fe442703          	lw	a4,-28(s0)
    8020059e:	fe842783          	lw	a5,-24(s0)
    802005a2:	863a                	mv	a2,a4
    802005a4:	85be                	mv	a1,a5
    802005a6:	00006517          	auipc	a0,0x6
    802005aa:	e4250513          	addi	a0,a0,-446 # 802063e8 <etext+0x3e8>
    802005ae:	00000097          	auipc	ra,0x0
    802005b2:	5a6080e7          	jalr	1446(ra) # 80200b54 <printf>
	return;
    802005b6:	0001                	nop
    802005b8:	60e2                	ld	ra,24(sp)
    802005ba:	6442                	ld	s0,16(sp)
    802005bc:	6105                	addi	sp,sp,32
    802005be:	8082                	ret

00000000802005c0 <uart_init>:
#include "defs.h"
struct uart_input_buf_t uart_input_buf;
// UART初始化函数
void uart_init(void) {
    802005c0:	1141                	addi	sp,sp,-16
    802005c2:	e406                	sd	ra,8(sp)
    802005c4:	e022                	sd	s0,0(sp)
    802005c6:	0800                	addi	s0,sp,16

    WriteReg(IER, 0x00);
    802005c8:	100007b7          	lui	a5,0x10000
    802005cc:	0785                	addi	a5,a5,1 # 10000001 <userret+0xfffff65>
    802005ce:	00078023          	sb	zero,0(a5)
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    802005d2:	100007b7          	lui	a5,0x10000
    802005d6:	0789                	addi	a5,a5,2 # 10000002 <userret+0xfffff66>
    802005d8:	471d                	li	a4,7
    802005da:	00e78023          	sb	a4,0(a5)
    WriteReg(IER, IER_RX_ENABLE);
    802005de:	100007b7          	lui	a5,0x10000
    802005e2:	0785                	addi	a5,a5,1 # 10000001 <userret+0xfffff65>
    802005e4:	4705                	li	a4,1
    802005e6:	00e78023          	sb	a4,0(a5)
    register_interrupt(UART0_IRQ, uart_intr);//注册键盘输入的中断处理函数
    802005ea:	00000597          	auipc	a1,0x0
    802005ee:	12858593          	addi	a1,a1,296 # 80200712 <uart_intr>
    802005f2:	4529                	li	a0,10
    802005f4:	00003097          	auipc	ra,0x3
    802005f8:	91a080e7          	jalr	-1766(ra) # 80202f0e <register_interrupt>
    enable_interrupts(UART0_IRQ);
    802005fc:	4529                	li	a0,10
    802005fe:	00003097          	auipc	ra,0x3
    80200602:	99a080e7          	jalr	-1638(ra) # 80202f98 <enable_interrupts>
    printf("UART initialized with input support\n");
    80200606:	00006517          	auipc	a0,0x6
    8020060a:	e2250513          	addi	a0,a0,-478 # 80206428 <etext+0x428>
    8020060e:	00000097          	auipc	ra,0x0
    80200612:	546080e7          	jalr	1350(ra) # 80200b54 <printf>
}
    80200616:	0001                	nop
    80200618:	60a2                	ld	ra,8(sp)
    8020061a:	6402                	ld	s0,0(sp)
    8020061c:	0141                	addi	sp,sp,16
    8020061e:	8082                	ret

0000000080200620 <uart_putc>:

// 发送单个字符
void uart_putc(char c) {
    80200620:	1101                	addi	sp,sp,-32
    80200622:	ec22                	sd	s0,24(sp)
    80200624:	1000                	addi	s0,sp,32
    80200626:	87aa                	mv	a5,a0
    80200628:	fef407a3          	sb	a5,-17(s0)
    // 等待发送缓冲区空闲
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    8020062c:	0001                	nop
    8020062e:	100007b7          	lui	a5,0x10000
    80200632:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    80200634:	0007c783          	lbu	a5,0(a5)
    80200638:	0ff7f793          	zext.b	a5,a5
    8020063c:	2781                	sext.w	a5,a5
    8020063e:	0207f793          	andi	a5,a5,32
    80200642:	2781                	sext.w	a5,a5
    80200644:	d7ed                	beqz	a5,8020062e <uart_putc+0xe>
    WriteReg(THR, c);
    80200646:	100007b7          	lui	a5,0x10000
    8020064a:	fef44703          	lbu	a4,-17(s0)
    8020064e:	00e78023          	sb	a4,0(a5) # 10000000 <userret+0xfffff64>
}
    80200652:	0001                	nop
    80200654:	6462                	ld	s0,24(sp)
    80200656:	6105                	addi	sp,sp,32
    80200658:	8082                	ret

000000008020065a <uart_puts>:

void uart_puts(char *s) {
    8020065a:	7179                	addi	sp,sp,-48
    8020065c:	f422                	sd	s0,40(sp)
    8020065e:	1800                	addi	s0,sp,48
    80200660:	fca43c23          	sd	a0,-40(s0)
    if (!s) return;
    80200664:	fd843783          	ld	a5,-40(s0)
    80200668:	c7b5                	beqz	a5,802006d4 <uart_puts+0x7a>
    
    while (*s) {
    8020066a:	a8b9                	j	802006c8 <uart_puts+0x6e>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    8020066c:	0001                	nop
    8020066e:	100007b7          	lui	a5,0x10000
    80200672:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    80200674:	0007c783          	lbu	a5,0(a5)
    80200678:	0ff7f793          	zext.b	a5,a5
    8020067c:	2781                	sext.w	a5,a5
    8020067e:	0207f793          	andi	a5,a5,32
    80200682:	2781                	sext.w	a5,a5
    80200684:	d7ed                	beqz	a5,8020066e <uart_puts+0x14>
        int sent_count = 0;
    80200686:	fe042623          	sw	zero,-20(s0)
        while (*s && sent_count < 4) { 
    8020068a:	a01d                	j	802006b0 <uart_puts+0x56>
            WriteReg(THR, *s);
    8020068c:	100007b7          	lui	a5,0x10000
    80200690:	fd843703          	ld	a4,-40(s0)
    80200694:	00074703          	lbu	a4,0(a4)
    80200698:	00e78023          	sb	a4,0(a5) # 10000000 <userret+0xfffff64>
            s++;
    8020069c:	fd843783          	ld	a5,-40(s0)
    802006a0:	0785                	addi	a5,a5,1
    802006a2:	fcf43c23          	sd	a5,-40(s0)
            sent_count++;
    802006a6:	fec42783          	lw	a5,-20(s0)
    802006aa:	2785                	addiw	a5,a5,1
    802006ac:	fef42623          	sw	a5,-20(s0)
        while (*s && sent_count < 4) { 
    802006b0:	fd843783          	ld	a5,-40(s0)
    802006b4:	0007c783          	lbu	a5,0(a5)
    802006b8:	cb81                	beqz	a5,802006c8 <uart_puts+0x6e>
    802006ba:	fec42783          	lw	a5,-20(s0)
    802006be:	0007871b          	sext.w	a4,a5
    802006c2:	478d                	li	a5,3
    802006c4:	fce7d4e3          	bge	a5,a4,8020068c <uart_puts+0x32>
    while (*s) {
    802006c8:	fd843783          	ld	a5,-40(s0)
    802006cc:	0007c783          	lbu	a5,0(a5)
    802006d0:	ffd1                	bnez	a5,8020066c <uart_puts+0x12>
    802006d2:	a011                	j	802006d6 <uart_puts+0x7c>
    if (!s) return;
    802006d4:	0001                	nop
        }
    }
}
    802006d6:	7422                	ld	s0,40(sp)
    802006d8:	6145                	addi	sp,sp,48
    802006da:	8082                	ret

00000000802006dc <uart_getc>:

int uart_getc(void) {
    802006dc:	1141                	addi	sp,sp,-16
    802006de:	e422                	sd	s0,8(sp)
    802006e0:	0800                	addi	s0,sp,16
    if ((ReadReg(LSR) & LSR_RX_READY) == 0)
    802006e2:	100007b7          	lui	a5,0x10000
    802006e6:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    802006e8:	0007c783          	lbu	a5,0(a5)
    802006ec:	0ff7f793          	zext.b	a5,a5
    802006f0:	2781                	sext.w	a5,a5
    802006f2:	8b85                	andi	a5,a5,1
    802006f4:	2781                	sext.w	a5,a5
    802006f6:	e399                	bnez	a5,802006fc <uart_getc+0x20>
        return -1; 
    802006f8:	57fd                	li	a5,-1
    802006fa:	a801                	j	8020070a <uart_getc+0x2e>
    return ReadReg(RHR); 
    802006fc:	100007b7          	lui	a5,0x10000
    80200700:	0007c783          	lbu	a5,0(a5) # 10000000 <userret+0xfffff64>
    80200704:	0ff7f793          	zext.b	a5,a5
    80200708:	2781                	sext.w	a5,a5
}
    8020070a:	853e                	mv	a0,a5
    8020070c:	6422                	ld	s0,8(sp)
    8020070e:	0141                	addi	sp,sp,16
    80200710:	8082                	ret

0000000080200712 <uart_intr>:

// UART中断处理函数
void uart_intr(void) {
    80200712:	1101                	addi	sp,sp,-32
    80200714:	ec06                	sd	ra,24(sp)
    80200716:	e822                	sd	s0,16(sp)
    80200718:	1000                	addi	s0,sp,32
    while (ReadReg(LSR) & LSR_RX_READY) {
    8020071a:	a869                	j	802007b4 <uart_intr+0xa2>
        char c = ReadReg(RHR);
    8020071c:	100007b7          	lui	a5,0x10000
    80200720:	0007c783          	lbu	a5,0(a5) # 10000000 <userret+0xfffff64>
    80200724:	fef407a3          	sb	a5,-17(s0)
        
        // 回显接收的字符
        uart_putc(c);
    80200728:	fef44783          	lbu	a5,-17(s0)
    8020072c:	853e                	mv	a0,a5
    8020072e:	00000097          	auipc	ra,0x0
    80200732:	ef2080e7          	jalr	-270(ra) # 80200620 <uart_putc>
        
        // 特殊字符处理
        if (c == '\r') {
    80200736:	fef44783          	lbu	a5,-17(s0)
    8020073a:	0ff7f713          	zext.b	a4,a5
    8020073e:	47b5                	li	a5,13
    80200740:	00f71a63          	bne	a4,a5,80200754 <uart_intr+0x42>
            uart_putc('\n'); // 将回车转换为换行符并回显
    80200744:	4529                	li	a0,10
    80200746:	00000097          	auipc	ra,0x0
    8020074a:	eda080e7          	jalr	-294(ra) # 80200620 <uart_putc>
            c = '\n';
    8020074e:	47a9                	li	a5,10
    80200750:	fef407a3          	sb	a5,-17(s0)
        }
        
        // 缓冲区满检查
        int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    80200754:	0000a797          	auipc	a5,0xa
    80200758:	94c78793          	addi	a5,a5,-1716 # 8020a0a0 <uart_input_buf>
    8020075c:	0847a783          	lw	a5,132(a5)
    80200760:	2785                	addiw	a5,a5,1
    80200762:	2781                	sext.w	a5,a5
    80200764:	2781                	sext.w	a5,a5
    80200766:	07f7f793          	andi	a5,a5,127
    8020076a:	fef42423          	sw	a5,-24(s0)
        if (next != uart_input_buf.r) {
    8020076e:	0000a797          	auipc	a5,0xa
    80200772:	93278793          	addi	a5,a5,-1742 # 8020a0a0 <uart_input_buf>
    80200776:	0807a703          	lw	a4,128(a5)
    8020077a:	fe842783          	lw	a5,-24(s0)
    8020077e:	02f70b63          	beq	a4,a5,802007b4 <uart_intr+0xa2>
            // 缓冲区未满，存储字符
            uart_input_buf.buf[uart_input_buf.w] = c;
    80200782:	0000a797          	auipc	a5,0xa
    80200786:	91e78793          	addi	a5,a5,-1762 # 8020a0a0 <uart_input_buf>
    8020078a:	0847a783          	lw	a5,132(a5)
    8020078e:	0000a717          	auipc	a4,0xa
    80200792:	91270713          	addi	a4,a4,-1774 # 8020a0a0 <uart_input_buf>
    80200796:	1782                	slli	a5,a5,0x20
    80200798:	9381                	srli	a5,a5,0x20
    8020079a:	97ba                	add	a5,a5,a4
    8020079c:	fef44703          	lbu	a4,-17(s0)
    802007a0:	00e78023          	sb	a4,0(a5)
            uart_input_buf.w = next;
    802007a4:	fe842703          	lw	a4,-24(s0)
    802007a8:	0000a797          	auipc	a5,0xa
    802007ac:	8f878793          	addi	a5,a5,-1800 # 8020a0a0 <uart_input_buf>
    802007b0:	08e7a223          	sw	a4,132(a5)
    while (ReadReg(LSR) & LSR_RX_READY) {
    802007b4:	100007b7          	lui	a5,0x10000
    802007b8:	0795                	addi	a5,a5,5 # 10000005 <userret+0xfffff69>
    802007ba:	0007c783          	lbu	a5,0(a5)
    802007be:	0ff7f793          	zext.b	a5,a5
    802007c2:	2781                	sext.w	a5,a5
    802007c4:	8b85                	andi	a5,a5,1
    802007c6:	2781                	sext.w	a5,a5
    802007c8:	fbb1                	bnez	a5,8020071c <uart_intr+0xa>
        }
    }
}
    802007ca:	0001                	nop
    802007cc:	0001                	nop
    802007ce:	60e2                	ld	ra,24(sp)
    802007d0:	6442                	ld	s0,16(sp)
    802007d2:	6105                	addi	sp,sp,32
    802007d4:	8082                	ret

00000000802007d6 <uart_getc_blocking>:
// 阻塞式读取一个字符
char uart_getc_blocking(void) {
    802007d6:	1101                	addi	sp,sp,-32
    802007d8:	ec22                	sd	s0,24(sp)
    802007da:	1000                	addi	s0,sp,32
    // 等待直到有字符可读
    while (uart_input_buf.r == uart_input_buf.w) {
    802007dc:	a011                	j	802007e0 <uart_getc_blocking+0xa>
        // 在实际系统中，这里可能需要让进程睡眠
        // 但目前我们使用简单的轮询
        asm volatile("nop");
    802007de:	0001                	nop
    while (uart_input_buf.r == uart_input_buf.w) {
    802007e0:	0000a797          	auipc	a5,0xa
    802007e4:	8c078793          	addi	a5,a5,-1856 # 8020a0a0 <uart_input_buf>
    802007e8:	0807a703          	lw	a4,128(a5)
    802007ec:	0000a797          	auipc	a5,0xa
    802007f0:	8b478793          	addi	a5,a5,-1868 # 8020a0a0 <uart_input_buf>
    802007f4:	0847a783          	lw	a5,132(a5)
    802007f8:	fef703e3          	beq	a4,a5,802007de <uart_getc_blocking+0x8>
    }
    
    // 读取字符
    char c = uart_input_buf.buf[uart_input_buf.r];
    802007fc:	0000a797          	auipc	a5,0xa
    80200800:	8a478793          	addi	a5,a5,-1884 # 8020a0a0 <uart_input_buf>
    80200804:	0807a783          	lw	a5,128(a5)
    80200808:	0000a717          	auipc	a4,0xa
    8020080c:	89870713          	addi	a4,a4,-1896 # 8020a0a0 <uart_input_buf>
    80200810:	1782                	slli	a5,a5,0x20
    80200812:	9381                	srli	a5,a5,0x20
    80200814:	97ba                	add	a5,a5,a4
    80200816:	0007c783          	lbu	a5,0(a5)
    8020081a:	fef407a3          	sb	a5,-17(s0)
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    8020081e:	0000a797          	auipc	a5,0xa
    80200822:	88278793          	addi	a5,a5,-1918 # 8020a0a0 <uart_input_buf>
    80200826:	0807a783          	lw	a5,128(a5)
    8020082a:	2785                	addiw	a5,a5,1
    8020082c:	2781                	sext.w	a5,a5
    8020082e:	07f7f793          	andi	a5,a5,127
    80200832:	0007871b          	sext.w	a4,a5
    80200836:	0000a797          	auipc	a5,0xa
    8020083a:	86a78793          	addi	a5,a5,-1942 # 8020a0a0 <uart_input_buf>
    8020083e:	08e7a023          	sw	a4,128(a5)
    return c;
    80200842:	fef44783          	lbu	a5,-17(s0)
}
    80200846:	853e                	mv	a0,a5
    80200848:	6462                	ld	s0,24(sp)
    8020084a:	6105                	addi	sp,sp,32
    8020084c:	8082                	ret

000000008020084e <readline>:
// 读取一行输入，最多读取max-1个字符，并在末尾添加\0
int readline(char *buf, int max) {
    8020084e:	7179                	addi	sp,sp,-48
    80200850:	f406                	sd	ra,40(sp)
    80200852:	f022                	sd	s0,32(sp)
    80200854:	1800                	addi	s0,sp,48
    80200856:	fca43c23          	sd	a0,-40(s0)
    8020085a:	87ae                	mv	a5,a1
    8020085c:	fcf42a23          	sw	a5,-44(s0)
    int i = 0;
    80200860:	fe042623          	sw	zero,-20(s0)
    char c;
    
    while (i < max - 1) {
    80200864:	a0b9                	j	802008b2 <readline+0x64>
        c = uart_getc_blocking();
    80200866:	00000097          	auipc	ra,0x0
    8020086a:	f70080e7          	jalr	-144(ra) # 802007d6 <uart_getc_blocking>
    8020086e:	87aa                	mv	a5,a0
    80200870:	fef405a3          	sb	a5,-21(s0)
        
        if (c == '\n') {
    80200874:	feb44783          	lbu	a5,-21(s0)
    80200878:	0ff7f713          	zext.b	a4,a5
    8020087c:	47a9                	li	a5,10
    8020087e:	00f71c63          	bne	a4,a5,80200896 <readline+0x48>
            buf[i] = '\0';
    80200882:	fec42783          	lw	a5,-20(s0)
    80200886:	fd843703          	ld	a4,-40(s0)
    8020088a:	97ba                	add	a5,a5,a4
    8020088c:	00078023          	sb	zero,0(a5)
            return i;
    80200890:	fec42783          	lw	a5,-20(s0)
    80200894:	a0a9                	j	802008de <readline+0x90>
        } else {
            buf[i++] = c;
    80200896:	fec42783          	lw	a5,-20(s0)
    8020089a:	0017871b          	addiw	a4,a5,1
    8020089e:	fee42623          	sw	a4,-20(s0)
    802008a2:	873e                	mv	a4,a5
    802008a4:	fd843783          	ld	a5,-40(s0)
    802008a8:	97ba                	add	a5,a5,a4
    802008aa:	feb44703          	lbu	a4,-21(s0)
    802008ae:	00e78023          	sb	a4,0(a5)
    while (i < max - 1) {
    802008b2:	fd442783          	lw	a5,-44(s0)
    802008b6:	37fd                	addiw	a5,a5,-1
    802008b8:	0007871b          	sext.w	a4,a5
    802008bc:	fec42783          	lw	a5,-20(s0)
    802008c0:	2781                	sext.w	a5,a5
    802008c2:	fae7c2e3          	blt	a5,a4,80200866 <readline+0x18>
        }
    }
    
    // 缓冲区满，添加\0并返回
    buf[max-1] = '\0';
    802008c6:	fd442783          	lw	a5,-44(s0)
    802008ca:	17fd                	addi	a5,a5,-1
    802008cc:	fd843703          	ld	a4,-40(s0)
    802008d0:	97ba                	add	a5,a5,a4
    802008d2:	00078023          	sb	zero,0(a5)
    return max-1;
    802008d6:	fd442783          	lw	a5,-44(s0)
    802008da:	37fd                	addiw	a5,a5,-1
    802008dc:	2781                	sext.w	a5,a5
    802008de:	853e                	mv	a0,a5
    802008e0:	70a2                	ld	ra,40(sp)
    802008e2:	7402                	ld	s0,32(sp)
    802008e4:	6145                	addi	sp,sp,48
    802008e6:	8082                	ret

00000000802008e8 <flush_printf_buffer>:

extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    802008e8:	1141                	addi	sp,sp,-16
    802008ea:	e406                	sd	ra,8(sp)
    802008ec:	e022                	sd	s0,0(sp)
    802008ee:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    802008f0:	0000a797          	auipc	a5,0xa
    802008f4:	8c078793          	addi	a5,a5,-1856 # 8020a1b0 <printf_buf_pos>
    802008f8:	439c                	lw	a5,0(a5)
    802008fa:	02f05c63          	blez	a5,80200932 <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    802008fe:	0000a797          	auipc	a5,0xa
    80200902:	8b278793          	addi	a5,a5,-1870 # 8020a1b0 <printf_buf_pos>
    80200906:	439c                	lw	a5,0(a5)
    80200908:	0000a717          	auipc	a4,0xa
    8020090c:	82870713          	addi	a4,a4,-2008 # 8020a130 <printf_buffer>
    80200910:	97ba                	add	a5,a5,a4
    80200912:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80200916:	0000a517          	auipc	a0,0xa
    8020091a:	81a50513          	addi	a0,a0,-2022 # 8020a130 <printf_buffer>
    8020091e:	00000097          	auipc	ra,0x0
    80200922:	d3c080e7          	jalr	-708(ra) # 8020065a <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200926:	0000a797          	auipc	a5,0xa
    8020092a:	88a78793          	addi	a5,a5,-1910 # 8020a1b0 <printf_buf_pos>
    8020092e:	0007a023          	sw	zero,0(a5)
	}
}
    80200932:	0001                	nop
    80200934:	60a2                	ld	ra,8(sp)
    80200936:	6402                	ld	s0,0(sp)
    80200938:	0141                	addi	sp,sp,16
    8020093a:	8082                	ret

000000008020093c <buffer_char>:
static void buffer_char(char c) {
    8020093c:	1101                	addi	sp,sp,-32
    8020093e:	ec06                	sd	ra,24(sp)
    80200940:	e822                	sd	s0,16(sp)
    80200942:	1000                	addi	s0,sp,32
    80200944:	87aa                	mv	a5,a0
    80200946:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    8020094a:	0000a797          	auipc	a5,0xa
    8020094e:	86678793          	addi	a5,a5,-1946 # 8020a1b0 <printf_buf_pos>
    80200952:	439c                	lw	a5,0(a5)
    80200954:	873e                	mv	a4,a5
    80200956:	07e00793          	li	a5,126
    8020095a:	02e7ca63          	blt	a5,a4,8020098e <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    8020095e:	0000a797          	auipc	a5,0xa
    80200962:	85278793          	addi	a5,a5,-1966 # 8020a1b0 <printf_buf_pos>
    80200966:	439c                	lw	a5,0(a5)
    80200968:	0017871b          	addiw	a4,a5,1
    8020096c:	0007069b          	sext.w	a3,a4
    80200970:	0000a717          	auipc	a4,0xa
    80200974:	84070713          	addi	a4,a4,-1984 # 8020a1b0 <printf_buf_pos>
    80200978:	c314                	sw	a3,0(a4)
    8020097a:	00009717          	auipc	a4,0x9
    8020097e:	7b670713          	addi	a4,a4,1974 # 8020a130 <printf_buffer>
    80200982:	97ba                	add	a5,a5,a4
    80200984:	fef44703          	lbu	a4,-17(s0)
    80200988:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    8020098c:	a825                	j	802009c4 <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    8020098e:	00000097          	auipc	ra,0x0
    80200992:	f5a080e7          	jalr	-166(ra) # 802008e8 <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    80200996:	0000a797          	auipc	a5,0xa
    8020099a:	81a78793          	addi	a5,a5,-2022 # 8020a1b0 <printf_buf_pos>
    8020099e:	439c                	lw	a5,0(a5)
    802009a0:	0017871b          	addiw	a4,a5,1
    802009a4:	0007069b          	sext.w	a3,a4
    802009a8:	0000a717          	auipc	a4,0xa
    802009ac:	80870713          	addi	a4,a4,-2040 # 8020a1b0 <printf_buf_pos>
    802009b0:	c314                	sw	a3,0(a4)
    802009b2:	00009717          	auipc	a4,0x9
    802009b6:	77e70713          	addi	a4,a4,1918 # 8020a130 <printf_buffer>
    802009ba:	97ba                	add	a5,a5,a4
    802009bc:	fef44703          	lbu	a4,-17(s0)
    802009c0:	00e78023          	sb	a4,0(a5)
}
    802009c4:	0001                	nop
    802009c6:	60e2                	ld	ra,24(sp)
    802009c8:	6442                	ld	s0,16(sp)
    802009ca:	6105                	addi	sp,sp,32
    802009cc:	8082                	ret

00000000802009ce <consputc>:
    "70", "71", "72", "73", "74", "75", "76", "77", "78", "79",
    "80", "81", "82", "83", "84", "85", "86", "87", "88", "89",
    "90", "91", "92", "93", "94", "95", "96", "97", "98", "99"
};

static void consputc(int c){
    802009ce:	1101                	addi	sp,sp,-32
    802009d0:	ec06                	sd	ra,24(sp)
    802009d2:	e822                	sd	s0,16(sp)
    802009d4:	1000                	addi	s0,sp,32
    802009d6:	87aa                	mv	a5,a0
    802009d8:	fef42623          	sw	a5,-20(s0)
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
    802009dc:	fec42783          	lw	a5,-20(s0)
    802009e0:	0ff7f793          	zext.b	a5,a5
    802009e4:	853e                	mv	a0,a5
    802009e6:	00000097          	auipc	ra,0x0
    802009ea:	c3a080e7          	jalr	-966(ra) # 80200620 <uart_putc>
}
    802009ee:	0001                	nop
    802009f0:	60e2                	ld	ra,24(sp)
    802009f2:	6442                	ld	s0,16(sp)
    802009f4:	6105                	addi	sp,sp,32
    802009f6:	8082                	ret

00000000802009f8 <consputs>:
static void consputs(const char *s){
    802009f8:	7179                	addi	sp,sp,-48
    802009fa:	f406                	sd	ra,40(sp)
    802009fc:	f022                	sd	s0,32(sp)
    802009fe:	1800                	addi	s0,sp,48
    80200a00:	fca43c23          	sd	a0,-40(s0)
	char *str = (char *)s;
    80200a04:	fd843783          	ld	a5,-40(s0)
    80200a08:	fef43423          	sd	a5,-24(s0)
	// 直接调用uart_puts输出字符串
	uart_puts(str);
    80200a0c:	fe843503          	ld	a0,-24(s0)
    80200a10:	00000097          	auipc	ra,0x0
    80200a14:	c4a080e7          	jalr	-950(ra) # 8020065a <uart_puts>
}
    80200a18:	0001                	nop
    80200a1a:	70a2                	ld	ra,40(sp)
    80200a1c:	7402                	ld	s0,32(sp)
    80200a1e:	6145                	addi	sp,sp,48
    80200a20:	8082                	ret

0000000080200a22 <printint>:
static void printint(long long xx,int base,int sign){
    80200a22:	715d                	addi	sp,sp,-80
    80200a24:	e486                	sd	ra,72(sp)
    80200a26:	e0a2                	sd	s0,64(sp)
    80200a28:	0880                	addi	s0,sp,80
    80200a2a:	faa43c23          	sd	a0,-72(s0)
    80200a2e:	87ae                	mv	a5,a1
    80200a30:	8732                	mv	a4,a2
    80200a32:	faf42a23          	sw	a5,-76(s0)
    80200a36:	87ba                	mv	a5,a4
    80200a38:	faf42823          	sw	a5,-80(s0)
	// 模仿xv6的printint
	static char digits[] = "0123456789abcdef";
	char buf[20]; // 增大缓冲区以处理64位整数
	int i;
	unsigned long long x;
	if (sign && (sign = xx < 0)) // 符号处理
    80200a3c:	fb042783          	lw	a5,-80(s0)
    80200a40:	2781                	sext.w	a5,a5
    80200a42:	c39d                	beqz	a5,80200a68 <printint+0x46>
    80200a44:	fb843783          	ld	a5,-72(s0)
    80200a48:	93fd                	srli	a5,a5,0x3f
    80200a4a:	0ff7f793          	zext.b	a5,a5
    80200a4e:	faf42823          	sw	a5,-80(s0)
    80200a52:	fb042783          	lw	a5,-80(s0)
    80200a56:	2781                	sext.w	a5,a5
    80200a58:	cb81                	beqz	a5,80200a68 <printint+0x46>
		x = -(unsigned long long)xx; // 强制转换以避免溢出
    80200a5a:	fb843783          	ld	a5,-72(s0)
    80200a5e:	40f007b3          	neg	a5,a5
    80200a62:	fef43023          	sd	a5,-32(s0)
    80200a66:	a029                	j	80200a70 <printint+0x4e>
	else
		x = xx;
    80200a68:	fb843783          	ld	a5,-72(s0)
    80200a6c:	fef43023          	sd	a5,-32(s0)

	if (base == 10 && x < 100) {
    80200a70:	fb442783          	lw	a5,-76(s0)
    80200a74:	0007871b          	sext.w	a4,a5
    80200a78:	47a9                	li	a5,10
    80200a7a:	02f71763          	bne	a4,a5,80200aa8 <printint+0x86>
    80200a7e:	fe043703          	ld	a4,-32(s0)
    80200a82:	06300793          	li	a5,99
    80200a86:	02e7e163          	bltu	a5,a4,80200aa8 <printint+0x86>
		// 使用查表法处理小数字
		consputs(small_numbers[x]);
    80200a8a:	fe043783          	ld	a5,-32(s0)
    80200a8e:	00279713          	slli	a4,a5,0x2
    80200a92:	00006797          	auipc	a5,0x6
    80200a96:	9be78793          	addi	a5,a5,-1602 # 80206450 <small_numbers>
    80200a9a:	97ba                	add	a5,a5,a4
    80200a9c:	853e                	mv	a0,a5
    80200a9e:	00000097          	auipc	ra,0x0
    80200aa2:	f5a080e7          	jalr	-166(ra) # 802009f8 <consputs>
    80200aa6:	a05d                	j	80200b4c <printint+0x12a>
		return;
	}
	i = 0;
    80200aa8:	fe042623          	sw	zero,-20(s0)
	do{
		buf[i] = digits[x % base];
    80200aac:	fb442783          	lw	a5,-76(s0)
    80200ab0:	fe043703          	ld	a4,-32(s0)
    80200ab4:	02f777b3          	remu	a5,a4,a5
    80200ab8:	00009717          	auipc	a4,0x9
    80200abc:	5a870713          	addi	a4,a4,1448 # 8020a060 <digits.0>
    80200ac0:	97ba                	add	a5,a5,a4
    80200ac2:	0007c703          	lbu	a4,0(a5)
    80200ac6:	fec42783          	lw	a5,-20(s0)
    80200aca:	17c1                	addi	a5,a5,-16
    80200acc:	97a2                	add	a5,a5,s0
    80200ace:	fce78c23          	sb	a4,-40(a5)
		i++;
    80200ad2:	fec42783          	lw	a5,-20(s0)
    80200ad6:	2785                	addiw	a5,a5,1
    80200ad8:	fef42623          	sw	a5,-20(s0)
	}while((x/=base) !=0);
    80200adc:	fb442783          	lw	a5,-76(s0)
    80200ae0:	fe043703          	ld	a4,-32(s0)
    80200ae4:	02f757b3          	divu	a5,a4,a5
    80200ae8:	fef43023          	sd	a5,-32(s0)
    80200aec:	fe043783          	ld	a5,-32(s0)
    80200af0:	ffd5                	bnez	a5,80200aac <printint+0x8a>
	if (sign){
    80200af2:	fb042783          	lw	a5,-80(s0)
    80200af6:	2781                	sext.w	a5,a5
    80200af8:	cf91                	beqz	a5,80200b14 <printint+0xf2>
		buf[i] = '-';
    80200afa:	fec42783          	lw	a5,-20(s0)
    80200afe:	17c1                	addi	a5,a5,-16
    80200b00:	97a2                	add	a5,a5,s0
    80200b02:	02d00713          	li	a4,45
    80200b06:	fce78c23          	sb	a4,-40(a5)
		i++;
    80200b0a:	fec42783          	lw	a5,-20(s0)
    80200b0e:	2785                	addiw	a5,a5,1
    80200b10:	fef42623          	sw	a5,-20(s0)
	}
	i--;
    80200b14:	fec42783          	lw	a5,-20(s0)
    80200b18:	37fd                	addiw	a5,a5,-1
    80200b1a:	fef42623          	sw	a5,-20(s0)
	while( i>=0){
    80200b1e:	a015                	j	80200b42 <printint+0x120>
		consputc(buf[i]);
    80200b20:	fec42783          	lw	a5,-20(s0)
    80200b24:	17c1                	addi	a5,a5,-16
    80200b26:	97a2                	add	a5,a5,s0
    80200b28:	fd87c783          	lbu	a5,-40(a5)
    80200b2c:	2781                	sext.w	a5,a5
    80200b2e:	853e                	mv	a0,a5
    80200b30:	00000097          	auipc	ra,0x0
    80200b34:	e9e080e7          	jalr	-354(ra) # 802009ce <consputc>
		i--;
    80200b38:	fec42783          	lw	a5,-20(s0)
    80200b3c:	37fd                	addiw	a5,a5,-1
    80200b3e:	fef42623          	sw	a5,-20(s0)
	while( i>=0){
    80200b42:	fec42783          	lw	a5,-20(s0)
    80200b46:	2781                	sext.w	a5,a5
    80200b48:	fc07dce3          	bgez	a5,80200b20 <printint+0xfe>
	}
}
    80200b4c:	60a6                	ld	ra,72(sp)
    80200b4e:	6406                	ld	s0,64(sp)
    80200b50:	6161                	addi	sp,sp,80
    80200b52:	8082                	ret

0000000080200b54 <printf>:
void printf(const char *fmt, ...) {
    80200b54:	7171                	addi	sp,sp,-176
    80200b56:	f486                	sd	ra,104(sp)
    80200b58:	f0a2                	sd	s0,96(sp)
    80200b5a:	1880                	addi	s0,sp,112
    80200b5c:	f8a43c23          	sd	a0,-104(s0)
    80200b60:	e40c                	sd	a1,8(s0)
    80200b62:	e810                	sd	a2,16(s0)
    80200b64:	ec14                	sd	a3,24(s0)
    80200b66:	f018                	sd	a4,32(s0)
    80200b68:	f41c                	sd	a5,40(s0)
    80200b6a:	03043823          	sd	a6,48(s0)
    80200b6e:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    80200b72:	04040793          	addi	a5,s0,64
    80200b76:	f8f43823          	sd	a5,-112(s0)
    80200b7a:	f9043783          	ld	a5,-112(s0)
    80200b7e:	fc878793          	addi	a5,a5,-56
    80200b82:	fcf43023          	sd	a5,-64(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200b86:	fe042623          	sw	zero,-20(s0)
    80200b8a:	a671                	j	80200f16 <printf+0x3c2>
        if(c != '%'){
    80200b8c:	fe842783          	lw	a5,-24(s0)
    80200b90:	0007871b          	sext.w	a4,a5
    80200b94:	02500793          	li	a5,37
    80200b98:	00f70c63          	beq	a4,a5,80200bb0 <printf+0x5c>
            buffer_char(c);
    80200b9c:	fe842783          	lw	a5,-24(s0)
    80200ba0:	0ff7f793          	zext.b	a5,a5
    80200ba4:	853e                	mv	a0,a5
    80200ba6:	00000097          	auipc	ra,0x0
    80200baa:	d96080e7          	jalr	-618(ra) # 8020093c <buffer_char>
            continue;
    80200bae:	aeb9                	j	80200f0c <printf+0x3b8>
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    80200bb0:	00000097          	auipc	ra,0x0
    80200bb4:	d38080e7          	jalr	-712(ra) # 802008e8 <flush_printf_buffer>
        c = fmt[++i] & 0xff;
    80200bb8:	fec42783          	lw	a5,-20(s0)
    80200bbc:	2785                	addiw	a5,a5,1
    80200bbe:	fef42623          	sw	a5,-20(s0)
    80200bc2:	fec42783          	lw	a5,-20(s0)
    80200bc6:	f9843703          	ld	a4,-104(s0)
    80200bca:	97ba                	add	a5,a5,a4
    80200bcc:	0007c783          	lbu	a5,0(a5)
    80200bd0:	fef42423          	sw	a5,-24(s0)
        if(c == 0)
    80200bd4:	fe842783          	lw	a5,-24(s0)
    80200bd8:	2781                	sext.w	a5,a5
    80200bda:	34078d63          	beqz	a5,80200f34 <printf+0x3e0>
            break;
            
        // 检查是否有长整型标记'l'
        int is_long = 0;
    80200bde:	fc042e23          	sw	zero,-36(s0)
        if(c == 'l') {
    80200be2:	fe842783          	lw	a5,-24(s0)
    80200be6:	0007871b          	sext.w	a4,a5
    80200bea:	06c00793          	li	a5,108
    80200bee:	02f71863          	bne	a4,a5,80200c1e <printf+0xca>
            is_long = 1;
    80200bf2:	4785                	li	a5,1
    80200bf4:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    80200bf8:	fec42783          	lw	a5,-20(s0)
    80200bfc:	2785                	addiw	a5,a5,1
    80200bfe:	fef42623          	sw	a5,-20(s0)
    80200c02:	fec42783          	lw	a5,-20(s0)
    80200c06:	f9843703          	ld	a4,-104(s0)
    80200c0a:	97ba                	add	a5,a5,a4
    80200c0c:	0007c783          	lbu	a5,0(a5)
    80200c10:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    80200c14:	fe842783          	lw	a5,-24(s0)
    80200c18:	2781                	sext.w	a5,a5
    80200c1a:	30078f63          	beqz	a5,80200f38 <printf+0x3e4>
                break;
        }
        
        switch(c){
    80200c1e:	fe842783          	lw	a5,-24(s0)
    80200c22:	0007871b          	sext.w	a4,a5
    80200c26:	02500793          	li	a5,37
    80200c2a:	2af70063          	beq	a4,a5,80200eca <printf+0x376>
    80200c2e:	fe842783          	lw	a5,-24(s0)
    80200c32:	0007871b          	sext.w	a4,a5
    80200c36:	02500793          	li	a5,37
    80200c3a:	28f74f63          	blt	a4,a5,80200ed8 <printf+0x384>
    80200c3e:	fe842783          	lw	a5,-24(s0)
    80200c42:	0007871b          	sext.w	a4,a5
    80200c46:	07800793          	li	a5,120
    80200c4a:	28e7c763          	blt	a5,a4,80200ed8 <printf+0x384>
    80200c4e:	fe842783          	lw	a5,-24(s0)
    80200c52:	0007871b          	sext.w	a4,a5
    80200c56:	06200793          	li	a5,98
    80200c5a:	26f74f63          	blt	a4,a5,80200ed8 <printf+0x384>
    80200c5e:	fe842783          	lw	a5,-24(s0)
    80200c62:	f9e7869b          	addiw	a3,a5,-98
    80200c66:	0006871b          	sext.w	a4,a3
    80200c6a:	47d9                	li	a5,22
    80200c6c:	26e7e663          	bltu	a5,a4,80200ed8 <printf+0x384>
    80200c70:	02069793          	slli	a5,a3,0x20
    80200c74:	9381                	srli	a5,a5,0x20
    80200c76:	00279713          	slli	a4,a5,0x2
    80200c7a:	00006797          	auipc	a5,0x6
    80200c7e:	98a78793          	addi	a5,a5,-1654 # 80206604 <small_numbers+0x1b4>
    80200c82:	97ba                	add	a5,a5,a4
    80200c84:	439c                	lw	a5,0(a5)
    80200c86:	0007871b          	sext.w	a4,a5
    80200c8a:	00006797          	auipc	a5,0x6
    80200c8e:	97a78793          	addi	a5,a5,-1670 # 80206604 <small_numbers+0x1b4>
    80200c92:	97ba                	add	a5,a5,a4
    80200c94:	8782                	jr	a5
        case 'd':
            if(is_long)
    80200c96:	fdc42783          	lw	a5,-36(s0)
    80200c9a:	2781                	sext.w	a5,a5
    80200c9c:	c385                	beqz	a5,80200cbc <printf+0x168>
                printint(va_arg(ap, long long), 10, 1);
    80200c9e:	fc043783          	ld	a5,-64(s0)
    80200ca2:	00878713          	addi	a4,a5,8
    80200ca6:	fce43023          	sd	a4,-64(s0)
    80200caa:	639c                	ld	a5,0(a5)
    80200cac:	4605                	li	a2,1
    80200cae:	45a9                	li	a1,10
    80200cb0:	853e                	mv	a0,a5
    80200cb2:	00000097          	auipc	ra,0x0
    80200cb6:	d70080e7          	jalr	-656(ra) # 80200a22 <printint>
            else
                printint(va_arg(ap, int), 10, 1);
            break;
    80200cba:	ac89                	j	80200f0c <printf+0x3b8>
                printint(va_arg(ap, int), 10, 1);
    80200cbc:	fc043783          	ld	a5,-64(s0)
    80200cc0:	00878713          	addi	a4,a5,8
    80200cc4:	fce43023          	sd	a4,-64(s0)
    80200cc8:	439c                	lw	a5,0(a5)
    80200cca:	4605                	li	a2,1
    80200ccc:	45a9                	li	a1,10
    80200cce:	853e                	mv	a0,a5
    80200cd0:	00000097          	auipc	ra,0x0
    80200cd4:	d52080e7          	jalr	-686(ra) # 80200a22 <printint>
            break;
    80200cd8:	ac15                	j	80200f0c <printf+0x3b8>
        case 'x':
            if(is_long)
    80200cda:	fdc42783          	lw	a5,-36(s0)
    80200cde:	2781                	sext.w	a5,a5
    80200ce0:	c385                	beqz	a5,80200d00 <printf+0x1ac>
                printint(va_arg(ap, long long), 16, 0);
    80200ce2:	fc043783          	ld	a5,-64(s0)
    80200ce6:	00878713          	addi	a4,a5,8
    80200cea:	fce43023          	sd	a4,-64(s0)
    80200cee:	639c                	ld	a5,0(a5)
    80200cf0:	4601                	li	a2,0
    80200cf2:	45c1                	li	a1,16
    80200cf4:	853e                	mv	a0,a5
    80200cf6:	00000097          	auipc	ra,0x0
    80200cfa:	d2c080e7          	jalr	-724(ra) # 80200a22 <printint>
            else
                printint(va_arg(ap, int), 16, 0);
            break;
    80200cfe:	a439                	j	80200f0c <printf+0x3b8>
                printint(va_arg(ap, int), 16, 0);
    80200d00:	fc043783          	ld	a5,-64(s0)
    80200d04:	00878713          	addi	a4,a5,8
    80200d08:	fce43023          	sd	a4,-64(s0)
    80200d0c:	439c                	lw	a5,0(a5)
    80200d0e:	4601                	li	a2,0
    80200d10:	45c1                	li	a1,16
    80200d12:	853e                	mv	a0,a5
    80200d14:	00000097          	auipc	ra,0x0
    80200d18:	d0e080e7          	jalr	-754(ra) # 80200a22 <printint>
            break;
    80200d1c:	aac5                	j	80200f0c <printf+0x3b8>
        case 'u':
            if(is_long)
    80200d1e:	fdc42783          	lw	a5,-36(s0)
    80200d22:	2781                	sext.w	a5,a5
    80200d24:	c385                	beqz	a5,80200d44 <printf+0x1f0>
                printint(va_arg(ap, unsigned long long), 10, 0);
    80200d26:	fc043783          	ld	a5,-64(s0)
    80200d2a:	00878713          	addi	a4,a5,8
    80200d2e:	fce43023          	sd	a4,-64(s0)
    80200d32:	639c                	ld	a5,0(a5)
    80200d34:	4601                	li	a2,0
    80200d36:	45a9                	li	a1,10
    80200d38:	853e                	mv	a0,a5
    80200d3a:	00000097          	auipc	ra,0x0
    80200d3e:	ce8080e7          	jalr	-792(ra) # 80200a22 <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0);
            break;
    80200d42:	a2e9                	j	80200f0c <printf+0x3b8>
                printint(va_arg(ap, unsigned int), 10, 0);
    80200d44:	fc043783          	ld	a5,-64(s0)
    80200d48:	00878713          	addi	a4,a5,8
    80200d4c:	fce43023          	sd	a4,-64(s0)
    80200d50:	439c                	lw	a5,0(a5)
    80200d52:	1782                	slli	a5,a5,0x20
    80200d54:	9381                	srli	a5,a5,0x20
    80200d56:	4601                	li	a2,0
    80200d58:	45a9                	li	a1,10
    80200d5a:	853e                	mv	a0,a5
    80200d5c:	00000097          	auipc	ra,0x0
    80200d60:	cc6080e7          	jalr	-826(ra) # 80200a22 <printint>
            break;
    80200d64:	a265                	j	80200f0c <printf+0x3b8>
        case 'c':
            consputc(va_arg(ap, int));
    80200d66:	fc043783          	ld	a5,-64(s0)
    80200d6a:	00878713          	addi	a4,a5,8
    80200d6e:	fce43023          	sd	a4,-64(s0)
    80200d72:	439c                	lw	a5,0(a5)
    80200d74:	853e                	mv	a0,a5
    80200d76:	00000097          	auipc	ra,0x0
    80200d7a:	c58080e7          	jalr	-936(ra) # 802009ce <consputc>
            break;
    80200d7e:	a279                	j	80200f0c <printf+0x3b8>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80200d80:	fc043783          	ld	a5,-64(s0)
    80200d84:	00878713          	addi	a4,a5,8
    80200d88:	fce43023          	sd	a4,-64(s0)
    80200d8c:	639c                	ld	a5,0(a5)
    80200d8e:	fef43023          	sd	a5,-32(s0)
    80200d92:	fe043783          	ld	a5,-32(s0)
    80200d96:	e799                	bnez	a5,80200da4 <printf+0x250>
                s = "(null)";
    80200d98:	00006797          	auipc	a5,0x6
    80200d9c:	84878793          	addi	a5,a5,-1976 # 802065e0 <small_numbers+0x190>
    80200da0:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    80200da4:	fe043503          	ld	a0,-32(s0)
    80200da8:	00000097          	auipc	ra,0x0
    80200dac:	c50080e7          	jalr	-944(ra) # 802009f8 <consputs>
            break;
    80200db0:	aab1                	j	80200f0c <printf+0x3b8>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    80200db2:	fc043783          	ld	a5,-64(s0)
    80200db6:	00878713          	addi	a4,a5,8
    80200dba:	fce43023          	sd	a4,-64(s0)
    80200dbe:	639c                	ld	a5,0(a5)
    80200dc0:	fcf43823          	sd	a5,-48(s0)
            consputs("0x");
    80200dc4:	00006517          	auipc	a0,0x6
    80200dc8:	82450513          	addi	a0,a0,-2012 # 802065e8 <small_numbers+0x198>
    80200dcc:	00000097          	auipc	ra,0x0
    80200dd0:	c2c080e7          	jalr	-980(ra) # 802009f8 <consputs>
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    80200dd4:	fc042c23          	sw	zero,-40(s0)
    80200dd8:	a0a1                	j	80200e20 <printf+0x2cc>
                int shift = (15 - i) * 4;
    80200dda:	47bd                	li	a5,15
    80200ddc:	fd842703          	lw	a4,-40(s0)
    80200de0:	9f99                	subw	a5,a5,a4
    80200de2:	2781                	sext.w	a5,a5
    80200de4:	0027979b          	slliw	a5,a5,0x2
    80200de8:	fcf42623          	sw	a5,-52(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80200dec:	fcc42783          	lw	a5,-52(s0)
    80200df0:	873e                	mv	a4,a5
    80200df2:	fd043783          	ld	a5,-48(s0)
    80200df6:	00e7d7b3          	srl	a5,a5,a4
    80200dfa:	8bbd                	andi	a5,a5,15
    80200dfc:	00005717          	auipc	a4,0x5
    80200e00:	7f470713          	addi	a4,a4,2036 # 802065f0 <small_numbers+0x1a0>
    80200e04:	97ba                	add	a5,a5,a4
    80200e06:	0007c703          	lbu	a4,0(a5)
    80200e0a:	fd842783          	lw	a5,-40(s0)
    80200e0e:	17c1                	addi	a5,a5,-16
    80200e10:	97a2                	add	a5,a5,s0
    80200e12:	fae78c23          	sb	a4,-72(a5)
            for (i = 0; i < 16; i++) {
    80200e16:	fd842783          	lw	a5,-40(s0)
    80200e1a:	2785                	addiw	a5,a5,1
    80200e1c:	fcf42c23          	sw	a5,-40(s0)
    80200e20:	fd842783          	lw	a5,-40(s0)
    80200e24:	0007871b          	sext.w	a4,a5
    80200e28:	47bd                	li	a5,15
    80200e2a:	fae7d8e3          	bge	a5,a4,80200dda <printf+0x286>
            }
            buf[16] = '\0';
    80200e2e:	fa040c23          	sb	zero,-72(s0)
            consputs(buf);
    80200e32:	fa840793          	addi	a5,s0,-88
    80200e36:	853e                	mv	a0,a5
    80200e38:	00000097          	auipc	ra,0x0
    80200e3c:	bc0080e7          	jalr	-1088(ra) # 802009f8 <consputs>
            break;
    80200e40:	a0f1                	j	80200f0c <printf+0x3b8>
        case 'b':
            if(is_long)
    80200e42:	fdc42783          	lw	a5,-36(s0)
    80200e46:	2781                	sext.w	a5,a5
    80200e48:	c385                	beqz	a5,80200e68 <printf+0x314>
                printint(va_arg(ap, long long), 2, 0);
    80200e4a:	fc043783          	ld	a5,-64(s0)
    80200e4e:	00878713          	addi	a4,a5,8
    80200e52:	fce43023          	sd	a4,-64(s0)
    80200e56:	639c                	ld	a5,0(a5)
    80200e58:	4601                	li	a2,0
    80200e5a:	4589                	li	a1,2
    80200e5c:	853e                	mv	a0,a5
    80200e5e:	00000097          	auipc	ra,0x0
    80200e62:	bc4080e7          	jalr	-1084(ra) # 80200a22 <printint>
            else
                printint(va_arg(ap, int), 2, 0);
            break;
    80200e66:	a05d                	j	80200f0c <printf+0x3b8>
                printint(va_arg(ap, int), 2, 0);
    80200e68:	fc043783          	ld	a5,-64(s0)
    80200e6c:	00878713          	addi	a4,a5,8
    80200e70:	fce43023          	sd	a4,-64(s0)
    80200e74:	439c                	lw	a5,0(a5)
    80200e76:	4601                	li	a2,0
    80200e78:	4589                	li	a1,2
    80200e7a:	853e                	mv	a0,a5
    80200e7c:	00000097          	auipc	ra,0x0
    80200e80:	ba6080e7          	jalr	-1114(ra) # 80200a22 <printint>
            break;
    80200e84:	a061                	j	80200f0c <printf+0x3b8>
        case 'o':
            if(is_long)
    80200e86:	fdc42783          	lw	a5,-36(s0)
    80200e8a:	2781                	sext.w	a5,a5
    80200e8c:	c385                	beqz	a5,80200eac <printf+0x358>
                printint(va_arg(ap, long long), 8, 0);
    80200e8e:	fc043783          	ld	a5,-64(s0)
    80200e92:	00878713          	addi	a4,a5,8
    80200e96:	fce43023          	sd	a4,-64(s0)
    80200e9a:	639c                	ld	a5,0(a5)
    80200e9c:	4601                	li	a2,0
    80200e9e:	45a1                	li	a1,8
    80200ea0:	853e                	mv	a0,a5
    80200ea2:	00000097          	auipc	ra,0x0
    80200ea6:	b80080e7          	jalr	-1152(ra) # 80200a22 <printint>
            else
                printint(va_arg(ap, int), 8, 0);
            break;
    80200eaa:	a08d                	j	80200f0c <printf+0x3b8>
                printint(va_arg(ap, int), 8, 0);
    80200eac:	fc043783          	ld	a5,-64(s0)
    80200eb0:	00878713          	addi	a4,a5,8
    80200eb4:	fce43023          	sd	a4,-64(s0)
    80200eb8:	439c                	lw	a5,0(a5)
    80200eba:	4601                	li	a2,0
    80200ebc:	45a1                	li	a1,8
    80200ebe:	853e                	mv	a0,a5
    80200ec0:	00000097          	auipc	ra,0x0
    80200ec4:	b62080e7          	jalr	-1182(ra) # 80200a22 <printint>
            break;
    80200ec8:	a091                	j	80200f0c <printf+0x3b8>
        case '%':
            buffer_char('%');
    80200eca:	02500513          	li	a0,37
    80200ece:	00000097          	auipc	ra,0x0
    80200ed2:	a6e080e7          	jalr	-1426(ra) # 8020093c <buffer_char>
            break;
    80200ed6:	a81d                	j	80200f0c <printf+0x3b8>
        default:
            buffer_char('%');
    80200ed8:	02500513          	li	a0,37
    80200edc:	00000097          	auipc	ra,0x0
    80200ee0:	a60080e7          	jalr	-1440(ra) # 8020093c <buffer_char>
            if(is_long) buffer_char('l');
    80200ee4:	fdc42783          	lw	a5,-36(s0)
    80200ee8:	2781                	sext.w	a5,a5
    80200eea:	c799                	beqz	a5,80200ef8 <printf+0x3a4>
    80200eec:	06c00513          	li	a0,108
    80200ef0:	00000097          	auipc	ra,0x0
    80200ef4:	a4c080e7          	jalr	-1460(ra) # 8020093c <buffer_char>
            buffer_char(c);
    80200ef8:	fe842783          	lw	a5,-24(s0)
    80200efc:	0ff7f793          	zext.b	a5,a5
    80200f00:	853e                	mv	a0,a5
    80200f02:	00000097          	auipc	ra,0x0
    80200f06:	a3a080e7          	jalr	-1478(ra) # 8020093c <buffer_char>
            break;
    80200f0a:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200f0c:	fec42783          	lw	a5,-20(s0)
    80200f10:	2785                	addiw	a5,a5,1
    80200f12:	fef42623          	sw	a5,-20(s0)
    80200f16:	fec42783          	lw	a5,-20(s0)
    80200f1a:	f9843703          	ld	a4,-104(s0)
    80200f1e:	97ba                	add	a5,a5,a4
    80200f20:	0007c783          	lbu	a5,0(a5)
    80200f24:	fef42423          	sw	a5,-24(s0)
    80200f28:	fe842783          	lw	a5,-24(s0)
    80200f2c:	2781                	sext.w	a5,a5
    80200f2e:	c4079fe3          	bnez	a5,80200b8c <printf+0x38>
    80200f32:	a021                	j	80200f3a <printf+0x3e6>
            break;
    80200f34:	0001                	nop
    80200f36:	a011                	j	80200f3a <printf+0x3e6>
                break;
    80200f38:	0001                	nop
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    80200f3a:	00000097          	auipc	ra,0x0
    80200f3e:	9ae080e7          	jalr	-1618(ra) # 802008e8 <flush_printf_buffer>
    va_end(ap);
}
    80200f42:	0001                	nop
    80200f44:	70a6                	ld	ra,104(sp)
    80200f46:	7406                	ld	s0,96(sp)
    80200f48:	614d                	addi	sp,sp,176
    80200f4a:	8082                	ret

0000000080200f4c <clear_screen>:
// 清屏功能
void clear_screen(void) {
    80200f4c:	1141                	addi	sp,sp,-16
    80200f4e:	e406                	sd	ra,8(sp)
    80200f50:	e022                	sd	s0,0(sp)
    80200f52:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    80200f54:	00005517          	auipc	a0,0x5
    80200f58:	70c50513          	addi	a0,a0,1804 # 80206660 <small_numbers+0x210>
    80200f5c:	fffff097          	auipc	ra,0xfffff
    80200f60:	6fe080e7          	jalr	1790(ra) # 8020065a <uart_puts>
	uart_puts(CURSOR_HOME);
    80200f64:	00005517          	auipc	a0,0x5
    80200f68:	70450513          	addi	a0,a0,1796 # 80206668 <small_numbers+0x218>
    80200f6c:	fffff097          	auipc	ra,0xfffff
    80200f70:	6ee080e7          	jalr	1774(ra) # 8020065a <uart_puts>
}
    80200f74:	0001                	nop
    80200f76:	60a2                	ld	ra,8(sp)
    80200f78:	6402                	ld	s0,0(sp)
    80200f7a:	0141                	addi	sp,sp,16
    80200f7c:	8082                	ret

0000000080200f7e <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    80200f7e:	1101                	addi	sp,sp,-32
    80200f80:	ec06                	sd	ra,24(sp)
    80200f82:	e822                	sd	s0,16(sp)
    80200f84:	1000                	addi	s0,sp,32
    80200f86:	87aa                	mv	a5,a0
    80200f88:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    80200f8c:	fec42783          	lw	a5,-20(s0)
    80200f90:	2781                	sext.w	a5,a5
    80200f92:	02f05d63          	blez	a5,80200fcc <cursor_up+0x4e>
    consputc('\033');
    80200f96:	456d                	li	a0,27
    80200f98:	00000097          	auipc	ra,0x0
    80200f9c:	a36080e7          	jalr	-1482(ra) # 802009ce <consputc>
    consputc('[');
    80200fa0:	05b00513          	li	a0,91
    80200fa4:	00000097          	auipc	ra,0x0
    80200fa8:	a2a080e7          	jalr	-1494(ra) # 802009ce <consputc>
    printint(lines, 10, 0);
    80200fac:	fec42783          	lw	a5,-20(s0)
    80200fb0:	4601                	li	a2,0
    80200fb2:	45a9                	li	a1,10
    80200fb4:	853e                	mv	a0,a5
    80200fb6:	00000097          	auipc	ra,0x0
    80200fba:	a6c080e7          	jalr	-1428(ra) # 80200a22 <printint>
    consputc('A');
    80200fbe:	04100513          	li	a0,65
    80200fc2:	00000097          	auipc	ra,0x0
    80200fc6:	a0c080e7          	jalr	-1524(ra) # 802009ce <consputc>
    80200fca:	a011                	j	80200fce <cursor_up+0x50>
    if (lines <= 0) return;
    80200fcc:	0001                	nop
}
    80200fce:	60e2                	ld	ra,24(sp)
    80200fd0:	6442                	ld	s0,16(sp)
    80200fd2:	6105                	addi	sp,sp,32
    80200fd4:	8082                	ret

0000000080200fd6 <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    80200fd6:	1101                	addi	sp,sp,-32
    80200fd8:	ec06                	sd	ra,24(sp)
    80200fda:	e822                	sd	s0,16(sp)
    80200fdc:	1000                	addi	s0,sp,32
    80200fde:	87aa                	mv	a5,a0
    80200fe0:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    80200fe4:	fec42783          	lw	a5,-20(s0)
    80200fe8:	2781                	sext.w	a5,a5
    80200fea:	02f05d63          	blez	a5,80201024 <cursor_down+0x4e>
    consputc('\033');
    80200fee:	456d                	li	a0,27
    80200ff0:	00000097          	auipc	ra,0x0
    80200ff4:	9de080e7          	jalr	-1570(ra) # 802009ce <consputc>
    consputc('[');
    80200ff8:	05b00513          	li	a0,91
    80200ffc:	00000097          	auipc	ra,0x0
    80201000:	9d2080e7          	jalr	-1582(ra) # 802009ce <consputc>
    printint(lines, 10, 0);
    80201004:	fec42783          	lw	a5,-20(s0)
    80201008:	4601                	li	a2,0
    8020100a:	45a9                	li	a1,10
    8020100c:	853e                	mv	a0,a5
    8020100e:	00000097          	auipc	ra,0x0
    80201012:	a14080e7          	jalr	-1516(ra) # 80200a22 <printint>
    consputc('B');
    80201016:	04200513          	li	a0,66
    8020101a:	00000097          	auipc	ra,0x0
    8020101e:	9b4080e7          	jalr	-1612(ra) # 802009ce <consputc>
    80201022:	a011                	j	80201026 <cursor_down+0x50>
    if (lines <= 0) return;
    80201024:	0001                	nop
}
    80201026:	60e2                	ld	ra,24(sp)
    80201028:	6442                	ld	s0,16(sp)
    8020102a:	6105                	addi	sp,sp,32
    8020102c:	8082                	ret

000000008020102e <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    8020102e:	1101                	addi	sp,sp,-32
    80201030:	ec06                	sd	ra,24(sp)
    80201032:	e822                	sd	s0,16(sp)
    80201034:	1000                	addi	s0,sp,32
    80201036:	87aa                	mv	a5,a0
    80201038:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    8020103c:	fec42783          	lw	a5,-20(s0)
    80201040:	2781                	sext.w	a5,a5
    80201042:	02f05d63          	blez	a5,8020107c <cursor_right+0x4e>
    consputc('\033');
    80201046:	456d                	li	a0,27
    80201048:	00000097          	auipc	ra,0x0
    8020104c:	986080e7          	jalr	-1658(ra) # 802009ce <consputc>
    consputc('[');
    80201050:	05b00513          	li	a0,91
    80201054:	00000097          	auipc	ra,0x0
    80201058:	97a080e7          	jalr	-1670(ra) # 802009ce <consputc>
    printint(cols, 10, 0);
    8020105c:	fec42783          	lw	a5,-20(s0)
    80201060:	4601                	li	a2,0
    80201062:	45a9                	li	a1,10
    80201064:	853e                	mv	a0,a5
    80201066:	00000097          	auipc	ra,0x0
    8020106a:	9bc080e7          	jalr	-1604(ra) # 80200a22 <printint>
    consputc('C');
    8020106e:	04300513          	li	a0,67
    80201072:	00000097          	auipc	ra,0x0
    80201076:	95c080e7          	jalr	-1700(ra) # 802009ce <consputc>
    8020107a:	a011                	j	8020107e <cursor_right+0x50>
    if (cols <= 0) return;
    8020107c:	0001                	nop
}
    8020107e:	60e2                	ld	ra,24(sp)
    80201080:	6442                	ld	s0,16(sp)
    80201082:	6105                	addi	sp,sp,32
    80201084:	8082                	ret

0000000080201086 <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    80201086:	1101                	addi	sp,sp,-32
    80201088:	ec06                	sd	ra,24(sp)
    8020108a:	e822                	sd	s0,16(sp)
    8020108c:	1000                	addi	s0,sp,32
    8020108e:	87aa                	mv	a5,a0
    80201090:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80201094:	fec42783          	lw	a5,-20(s0)
    80201098:	2781                	sext.w	a5,a5
    8020109a:	02f05d63          	blez	a5,802010d4 <cursor_left+0x4e>
    consputc('\033');
    8020109e:	456d                	li	a0,27
    802010a0:	00000097          	auipc	ra,0x0
    802010a4:	92e080e7          	jalr	-1746(ra) # 802009ce <consputc>
    consputc('[');
    802010a8:	05b00513          	li	a0,91
    802010ac:	00000097          	auipc	ra,0x0
    802010b0:	922080e7          	jalr	-1758(ra) # 802009ce <consputc>
    printint(cols, 10, 0);
    802010b4:	fec42783          	lw	a5,-20(s0)
    802010b8:	4601                	li	a2,0
    802010ba:	45a9                	li	a1,10
    802010bc:	853e                	mv	a0,a5
    802010be:	00000097          	auipc	ra,0x0
    802010c2:	964080e7          	jalr	-1692(ra) # 80200a22 <printint>
    consputc('D');
    802010c6:	04400513          	li	a0,68
    802010ca:	00000097          	auipc	ra,0x0
    802010ce:	904080e7          	jalr	-1788(ra) # 802009ce <consputc>
    802010d2:	a011                	j	802010d6 <cursor_left+0x50>
    if (cols <= 0) return;
    802010d4:	0001                	nop
}
    802010d6:	60e2                	ld	ra,24(sp)
    802010d8:	6442                	ld	s0,16(sp)
    802010da:	6105                	addi	sp,sp,32
    802010dc:	8082                	ret

00000000802010de <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    802010de:	1141                	addi	sp,sp,-16
    802010e0:	e406                	sd	ra,8(sp)
    802010e2:	e022                	sd	s0,0(sp)
    802010e4:	0800                	addi	s0,sp,16
    consputc('\033');
    802010e6:	456d                	li	a0,27
    802010e8:	00000097          	auipc	ra,0x0
    802010ec:	8e6080e7          	jalr	-1818(ra) # 802009ce <consputc>
    consputc('[');
    802010f0:	05b00513          	li	a0,91
    802010f4:	00000097          	auipc	ra,0x0
    802010f8:	8da080e7          	jalr	-1830(ra) # 802009ce <consputc>
    consputc('s');
    802010fc:	07300513          	li	a0,115
    80201100:	00000097          	auipc	ra,0x0
    80201104:	8ce080e7          	jalr	-1842(ra) # 802009ce <consputc>
}
    80201108:	0001                	nop
    8020110a:	60a2                	ld	ra,8(sp)
    8020110c:	6402                	ld	s0,0(sp)
    8020110e:	0141                	addi	sp,sp,16
    80201110:	8082                	ret

0000000080201112 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    80201112:	1141                	addi	sp,sp,-16
    80201114:	e406                	sd	ra,8(sp)
    80201116:	e022                	sd	s0,0(sp)
    80201118:	0800                	addi	s0,sp,16
    consputc('\033');
    8020111a:	456d                	li	a0,27
    8020111c:	00000097          	auipc	ra,0x0
    80201120:	8b2080e7          	jalr	-1870(ra) # 802009ce <consputc>
    consputc('[');
    80201124:	05b00513          	li	a0,91
    80201128:	00000097          	auipc	ra,0x0
    8020112c:	8a6080e7          	jalr	-1882(ra) # 802009ce <consputc>
    consputc('u');
    80201130:	07500513          	li	a0,117
    80201134:	00000097          	auipc	ra,0x0
    80201138:	89a080e7          	jalr	-1894(ra) # 802009ce <consputc>
}
    8020113c:	0001                	nop
    8020113e:	60a2                	ld	ra,8(sp)
    80201140:	6402                	ld	s0,0(sp)
    80201142:	0141                	addi	sp,sp,16
    80201144:	8082                	ret

0000000080201146 <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    80201146:	1101                	addi	sp,sp,-32
    80201148:	ec06                	sd	ra,24(sp)
    8020114a:	e822                	sd	s0,16(sp)
    8020114c:	1000                	addi	s0,sp,32
    8020114e:	87aa                	mv	a5,a0
    80201150:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    80201154:	fec42783          	lw	a5,-20(s0)
    80201158:	2781                	sext.w	a5,a5
    8020115a:	00f04563          	bgtz	a5,80201164 <cursor_to_column+0x1e>
    8020115e:	4785                	li	a5,1
    80201160:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    80201164:	456d                	li	a0,27
    80201166:	00000097          	auipc	ra,0x0
    8020116a:	868080e7          	jalr	-1944(ra) # 802009ce <consputc>
    consputc('[');
    8020116e:	05b00513          	li	a0,91
    80201172:	00000097          	auipc	ra,0x0
    80201176:	85c080e7          	jalr	-1956(ra) # 802009ce <consputc>
    printint(col, 10, 0);
    8020117a:	fec42783          	lw	a5,-20(s0)
    8020117e:	4601                	li	a2,0
    80201180:	45a9                	li	a1,10
    80201182:	853e                	mv	a0,a5
    80201184:	00000097          	auipc	ra,0x0
    80201188:	89e080e7          	jalr	-1890(ra) # 80200a22 <printint>
    consputc('G');
    8020118c:	04700513          	li	a0,71
    80201190:	00000097          	auipc	ra,0x0
    80201194:	83e080e7          	jalr	-1986(ra) # 802009ce <consputc>
}
    80201198:	0001                	nop
    8020119a:	60e2                	ld	ra,24(sp)
    8020119c:	6442                	ld	s0,16(sp)
    8020119e:	6105                	addi	sp,sp,32
    802011a0:	8082                	ret

00000000802011a2 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    802011a2:	1101                	addi	sp,sp,-32
    802011a4:	ec06                	sd	ra,24(sp)
    802011a6:	e822                	sd	s0,16(sp)
    802011a8:	1000                	addi	s0,sp,32
    802011aa:	87aa                	mv	a5,a0
    802011ac:	872e                	mv	a4,a1
    802011ae:	fef42623          	sw	a5,-20(s0)
    802011b2:	87ba                	mv	a5,a4
    802011b4:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    802011b8:	456d                	li	a0,27
    802011ba:	00000097          	auipc	ra,0x0
    802011be:	814080e7          	jalr	-2028(ra) # 802009ce <consputc>
    consputc('[');
    802011c2:	05b00513          	li	a0,91
    802011c6:	00000097          	auipc	ra,0x0
    802011ca:	808080e7          	jalr	-2040(ra) # 802009ce <consputc>
    printint(row, 10, 0);
    802011ce:	fec42783          	lw	a5,-20(s0)
    802011d2:	4601                	li	a2,0
    802011d4:	45a9                	li	a1,10
    802011d6:	853e                	mv	a0,a5
    802011d8:	00000097          	auipc	ra,0x0
    802011dc:	84a080e7          	jalr	-1974(ra) # 80200a22 <printint>
    consputc(';');
    802011e0:	03b00513          	li	a0,59
    802011e4:	fffff097          	auipc	ra,0xfffff
    802011e8:	7ea080e7          	jalr	2026(ra) # 802009ce <consputc>
    printint(col, 10, 0);
    802011ec:	fe842783          	lw	a5,-24(s0)
    802011f0:	4601                	li	a2,0
    802011f2:	45a9                	li	a1,10
    802011f4:	853e                	mv	a0,a5
    802011f6:	00000097          	auipc	ra,0x0
    802011fa:	82c080e7          	jalr	-2004(ra) # 80200a22 <printint>
    consputc('H');
    802011fe:	04800513          	li	a0,72
    80201202:	fffff097          	auipc	ra,0xfffff
    80201206:	7cc080e7          	jalr	1996(ra) # 802009ce <consputc>
}
    8020120a:	0001                	nop
    8020120c:	60e2                	ld	ra,24(sp)
    8020120e:	6442                	ld	s0,16(sp)
    80201210:	6105                	addi	sp,sp,32
    80201212:	8082                	ret

0000000080201214 <reset_color>:
// 颜色控制
void reset_color(void) {
    80201214:	1141                	addi	sp,sp,-16
    80201216:	e406                	sd	ra,8(sp)
    80201218:	e022                	sd	s0,0(sp)
    8020121a:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    8020121c:	00005517          	auipc	a0,0x5
    80201220:	45450513          	addi	a0,a0,1108 # 80206670 <small_numbers+0x220>
    80201224:	fffff097          	auipc	ra,0xfffff
    80201228:	436080e7          	jalr	1078(ra) # 8020065a <uart_puts>
}
    8020122c:	0001                	nop
    8020122e:	60a2                	ld	ra,8(sp)
    80201230:	6402                	ld	s0,0(sp)
    80201232:	0141                	addi	sp,sp,16
    80201234:	8082                	ret

0000000080201236 <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    80201236:	1101                	addi	sp,sp,-32
    80201238:	ec06                	sd	ra,24(sp)
    8020123a:	e822                	sd	s0,16(sp)
    8020123c:	1000                	addi	s0,sp,32
    8020123e:	87aa                	mv	a5,a0
    80201240:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    80201244:	fec42783          	lw	a5,-20(s0)
    80201248:	0007871b          	sext.w	a4,a5
    8020124c:	47f5                	li	a5,29
    8020124e:	04e7d563          	bge	a5,a4,80201298 <set_fg_color+0x62>
    80201252:	fec42783          	lw	a5,-20(s0)
    80201256:	0007871b          	sext.w	a4,a5
    8020125a:	02500793          	li	a5,37
    8020125e:	02e7cd63          	blt	a5,a4,80201298 <set_fg_color+0x62>
	consputc('\033');
    80201262:	456d                	li	a0,27
    80201264:	fffff097          	auipc	ra,0xfffff
    80201268:	76a080e7          	jalr	1898(ra) # 802009ce <consputc>
	consputc('[');
    8020126c:	05b00513          	li	a0,91
    80201270:	fffff097          	auipc	ra,0xfffff
    80201274:	75e080e7          	jalr	1886(ra) # 802009ce <consputc>
	printint(color, 10, 0);
    80201278:	fec42783          	lw	a5,-20(s0)
    8020127c:	4601                	li	a2,0
    8020127e:	45a9                	li	a1,10
    80201280:	853e                	mv	a0,a5
    80201282:	fffff097          	auipc	ra,0xfffff
    80201286:	7a0080e7          	jalr	1952(ra) # 80200a22 <printint>
	consputc('m');
    8020128a:	06d00513          	li	a0,109
    8020128e:	fffff097          	auipc	ra,0xfffff
    80201292:	740080e7          	jalr	1856(ra) # 802009ce <consputc>
    80201296:	a011                	j	8020129a <set_fg_color+0x64>
	if (color < 30 || color > 37) return; // 支持30-37
    80201298:	0001                	nop
}
    8020129a:	60e2                	ld	ra,24(sp)
    8020129c:	6442                	ld	s0,16(sp)
    8020129e:	6105                	addi	sp,sp,32
    802012a0:	8082                	ret

00000000802012a2 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    802012a2:	1101                	addi	sp,sp,-32
    802012a4:	ec06                	sd	ra,24(sp)
    802012a6:	e822                	sd	s0,16(sp)
    802012a8:	1000                	addi	s0,sp,32
    802012aa:	87aa                	mv	a5,a0
    802012ac:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    802012b0:	fec42783          	lw	a5,-20(s0)
    802012b4:	0007871b          	sext.w	a4,a5
    802012b8:	02700793          	li	a5,39
    802012bc:	04e7d563          	bge	a5,a4,80201306 <set_bg_color+0x64>
    802012c0:	fec42783          	lw	a5,-20(s0)
    802012c4:	0007871b          	sext.w	a4,a5
    802012c8:	02f00793          	li	a5,47
    802012cc:	02e7cd63          	blt	a5,a4,80201306 <set_bg_color+0x64>
	consputc('\033');
    802012d0:	456d                	li	a0,27
    802012d2:	fffff097          	auipc	ra,0xfffff
    802012d6:	6fc080e7          	jalr	1788(ra) # 802009ce <consputc>
	consputc('[');
    802012da:	05b00513          	li	a0,91
    802012de:	fffff097          	auipc	ra,0xfffff
    802012e2:	6f0080e7          	jalr	1776(ra) # 802009ce <consputc>
	printint(color, 10, 0);
    802012e6:	fec42783          	lw	a5,-20(s0)
    802012ea:	4601                	li	a2,0
    802012ec:	45a9                	li	a1,10
    802012ee:	853e                	mv	a0,a5
    802012f0:	fffff097          	auipc	ra,0xfffff
    802012f4:	732080e7          	jalr	1842(ra) # 80200a22 <printint>
	consputc('m');
    802012f8:	06d00513          	li	a0,109
    802012fc:	fffff097          	auipc	ra,0xfffff
    80201300:	6d2080e7          	jalr	1746(ra) # 802009ce <consputc>
    80201304:	a011                	j	80201308 <set_bg_color+0x66>
	if (color < 40 || color > 47) return; // 支持40-47
    80201306:	0001                	nop
}
    80201308:	60e2                	ld	ra,24(sp)
    8020130a:	6442                	ld	s0,16(sp)
    8020130c:	6105                	addi	sp,sp,32
    8020130e:	8082                	ret

0000000080201310 <color_red>:
// 简易文字颜色
void color_red(void) {
    80201310:	1141                	addi	sp,sp,-16
    80201312:	e406                	sd	ra,8(sp)
    80201314:	e022                	sd	s0,0(sp)
    80201316:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    80201318:	457d                	li	a0,31
    8020131a:	00000097          	auipc	ra,0x0
    8020131e:	f1c080e7          	jalr	-228(ra) # 80201236 <set_fg_color>
}
    80201322:	0001                	nop
    80201324:	60a2                	ld	ra,8(sp)
    80201326:	6402                	ld	s0,0(sp)
    80201328:	0141                	addi	sp,sp,16
    8020132a:	8082                	ret

000000008020132c <color_green>:
void color_green(void) {
    8020132c:	1141                	addi	sp,sp,-16
    8020132e:	e406                	sd	ra,8(sp)
    80201330:	e022                	sd	s0,0(sp)
    80201332:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    80201334:	02000513          	li	a0,32
    80201338:	00000097          	auipc	ra,0x0
    8020133c:	efe080e7          	jalr	-258(ra) # 80201236 <set_fg_color>
}
    80201340:	0001                	nop
    80201342:	60a2                	ld	ra,8(sp)
    80201344:	6402                	ld	s0,0(sp)
    80201346:	0141                	addi	sp,sp,16
    80201348:	8082                	ret

000000008020134a <color_yellow>:
void color_yellow(void) {
    8020134a:	1141                	addi	sp,sp,-16
    8020134c:	e406                	sd	ra,8(sp)
    8020134e:	e022                	sd	s0,0(sp)
    80201350:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    80201352:	02100513          	li	a0,33
    80201356:	00000097          	auipc	ra,0x0
    8020135a:	ee0080e7          	jalr	-288(ra) # 80201236 <set_fg_color>
}
    8020135e:	0001                	nop
    80201360:	60a2                	ld	ra,8(sp)
    80201362:	6402                	ld	s0,0(sp)
    80201364:	0141                	addi	sp,sp,16
    80201366:	8082                	ret

0000000080201368 <color_blue>:
void color_blue(void) {
    80201368:	1141                	addi	sp,sp,-16
    8020136a:	e406                	sd	ra,8(sp)
    8020136c:	e022                	sd	s0,0(sp)
    8020136e:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    80201370:	02200513          	li	a0,34
    80201374:	00000097          	auipc	ra,0x0
    80201378:	ec2080e7          	jalr	-318(ra) # 80201236 <set_fg_color>
}
    8020137c:	0001                	nop
    8020137e:	60a2                	ld	ra,8(sp)
    80201380:	6402                	ld	s0,0(sp)
    80201382:	0141                	addi	sp,sp,16
    80201384:	8082                	ret

0000000080201386 <color_purple>:
void color_purple(void) {
    80201386:	1141                	addi	sp,sp,-16
    80201388:	e406                	sd	ra,8(sp)
    8020138a:	e022                	sd	s0,0(sp)
    8020138c:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    8020138e:	02300513          	li	a0,35
    80201392:	00000097          	auipc	ra,0x0
    80201396:	ea4080e7          	jalr	-348(ra) # 80201236 <set_fg_color>
}
    8020139a:	0001                	nop
    8020139c:	60a2                	ld	ra,8(sp)
    8020139e:	6402                	ld	s0,0(sp)
    802013a0:	0141                	addi	sp,sp,16
    802013a2:	8082                	ret

00000000802013a4 <color_cyan>:
void color_cyan(void) {
    802013a4:	1141                	addi	sp,sp,-16
    802013a6:	e406                	sd	ra,8(sp)
    802013a8:	e022                	sd	s0,0(sp)
    802013aa:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    802013ac:	02400513          	li	a0,36
    802013b0:	00000097          	auipc	ra,0x0
    802013b4:	e86080e7          	jalr	-378(ra) # 80201236 <set_fg_color>
}
    802013b8:	0001                	nop
    802013ba:	60a2                	ld	ra,8(sp)
    802013bc:	6402                	ld	s0,0(sp)
    802013be:	0141                	addi	sp,sp,16
    802013c0:	8082                	ret

00000000802013c2 <color_reverse>:
void color_reverse(void){
    802013c2:	1141                	addi	sp,sp,-16
    802013c4:	e406                	sd	ra,8(sp)
    802013c6:	e022                	sd	s0,0(sp)
    802013c8:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    802013ca:	02500513          	li	a0,37
    802013ce:	00000097          	auipc	ra,0x0
    802013d2:	e68080e7          	jalr	-408(ra) # 80201236 <set_fg_color>
}
    802013d6:	0001                	nop
    802013d8:	60a2                	ld	ra,8(sp)
    802013da:	6402                	ld	s0,0(sp)
    802013dc:	0141                	addi	sp,sp,16
    802013de:	8082                	ret

00000000802013e0 <set_color>:
void set_color(int fg, int bg) {
    802013e0:	1101                	addi	sp,sp,-32
    802013e2:	ec06                	sd	ra,24(sp)
    802013e4:	e822                	sd	s0,16(sp)
    802013e6:	1000                	addi	s0,sp,32
    802013e8:	87aa                	mv	a5,a0
    802013ea:	872e                	mv	a4,a1
    802013ec:	fef42623          	sw	a5,-20(s0)
    802013f0:	87ba                	mv	a5,a4
    802013f2:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    802013f6:	fe842783          	lw	a5,-24(s0)
    802013fa:	853e                	mv	a0,a5
    802013fc:	00000097          	auipc	ra,0x0
    80201400:	ea6080e7          	jalr	-346(ra) # 802012a2 <set_bg_color>
	set_fg_color(fg);
    80201404:	fec42783          	lw	a5,-20(s0)
    80201408:	853e                	mv	a0,a5
    8020140a:	00000097          	auipc	ra,0x0
    8020140e:	e2c080e7          	jalr	-468(ra) # 80201236 <set_fg_color>
}
    80201412:	0001                	nop
    80201414:	60e2                	ld	ra,24(sp)
    80201416:	6442                	ld	s0,16(sp)
    80201418:	6105                	addi	sp,sp,32
    8020141a:	8082                	ret

000000008020141c <clear_line>:
void clear_line(){
    8020141c:	1141                	addi	sp,sp,-16
    8020141e:	e406                	sd	ra,8(sp)
    80201420:	e022                	sd	s0,0(sp)
    80201422:	0800                	addi	s0,sp,16
	consputc('\033');
    80201424:	456d                	li	a0,27
    80201426:	fffff097          	auipc	ra,0xfffff
    8020142a:	5a8080e7          	jalr	1448(ra) # 802009ce <consputc>
	consputc('[');
    8020142e:	05b00513          	li	a0,91
    80201432:	fffff097          	auipc	ra,0xfffff
    80201436:	59c080e7          	jalr	1436(ra) # 802009ce <consputc>
	consputc('2');
    8020143a:	03200513          	li	a0,50
    8020143e:	fffff097          	auipc	ra,0xfffff
    80201442:	590080e7          	jalr	1424(ra) # 802009ce <consputc>
	consputc('K');
    80201446:	04b00513          	li	a0,75
    8020144a:	fffff097          	auipc	ra,0xfffff
    8020144e:	584080e7          	jalr	1412(ra) # 802009ce <consputc>
}
    80201452:	0001                	nop
    80201454:	60a2                	ld	ra,8(sp)
    80201456:	6402                	ld	s0,0(sp)
    80201458:	0141                	addi	sp,sp,16
    8020145a:	8082                	ret

000000008020145c <panic>:

void panic(const char *msg) {
    8020145c:	1101                	addi	sp,sp,-32
    8020145e:	ec06                	sd	ra,24(sp)
    80201460:	e822                	sd	s0,16(sp)
    80201462:	1000                	addi	s0,sp,32
    80201464:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    80201468:	00000097          	auipc	ra,0x0
    8020146c:	ea8080e7          	jalr	-344(ra) # 80201310 <color_red>
	printf("panic: %s\n", msg);
    80201470:	fe843583          	ld	a1,-24(s0)
    80201474:	00005517          	auipc	a0,0x5
    80201478:	20450513          	addi	a0,a0,516 # 80206678 <small_numbers+0x228>
    8020147c:	fffff097          	auipc	ra,0xfffff
    80201480:	6d8080e7          	jalr	1752(ra) # 80200b54 <printf>
	reset_color();
    80201484:	00000097          	auipc	ra,0x0
    80201488:	d90080e7          	jalr	-624(ra) # 80201214 <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    8020148c:	0001                	nop
    8020148e:	bffd                	j	8020148c <panic+0x30>

0000000080201490 <warning>:
}
void warning(const char *fmt, ...) {
    80201490:	7159                	addi	sp,sp,-112
    80201492:	f406                	sd	ra,40(sp)
    80201494:	f022                	sd	s0,32(sp)
    80201496:	1800                	addi	s0,sp,48
    80201498:	fca43c23          	sd	a0,-40(s0)
    8020149c:	e40c                	sd	a1,8(s0)
    8020149e:	e810                	sd	a2,16(s0)
    802014a0:	ec14                	sd	a3,24(s0)
    802014a2:	f018                	sd	a4,32(s0)
    802014a4:	f41c                	sd	a5,40(s0)
    802014a6:	03043823          	sd	a6,48(s0)
    802014aa:	03143c23          	sd	a7,56(s0)
    va_list ap;
    color_purple(); // 设置紫色
    802014ae:	00000097          	auipc	ra,0x0
    802014b2:	ed8080e7          	jalr	-296(ra) # 80201386 <color_purple>
    printf("[WARNING] ");
    802014b6:	00005517          	auipc	a0,0x5
    802014ba:	1d250513          	addi	a0,a0,466 # 80206688 <small_numbers+0x238>
    802014be:	fffff097          	auipc	ra,0xfffff
    802014c2:	696080e7          	jalr	1686(ra) # 80200b54 <printf>
    va_start(ap, fmt);
    802014c6:	04040793          	addi	a5,s0,64
    802014ca:	fcf43823          	sd	a5,-48(s0)
    802014ce:	fd043783          	ld	a5,-48(s0)
    802014d2:	fc878793          	addi	a5,a5,-56
    802014d6:	fef43423          	sd	a5,-24(s0)
    printf(fmt, ap);
    802014da:	fe843783          	ld	a5,-24(s0)
    802014de:	85be                	mv	a1,a5
    802014e0:	fd843503          	ld	a0,-40(s0)
    802014e4:	fffff097          	auipc	ra,0xfffff
    802014e8:	670080e7          	jalr	1648(ra) # 80200b54 <printf>
    va_end(ap);
    reset_color(); // 恢复默认颜色
    802014ec:	00000097          	auipc	ra,0x0
    802014f0:	d28080e7          	jalr	-728(ra) # 80201214 <reset_color>
}
    802014f4:	0001                	nop
    802014f6:	70a2                	ld	ra,40(sp)
    802014f8:	7402                	ld	s0,32(sp)
    802014fa:	6165                	addi	sp,sp,112
    802014fc:	8082                	ret

00000000802014fe <test_printf_precision>:
void test_printf_precision(void) {
    802014fe:	1101                	addi	sp,sp,-32
    80201500:	ec06                	sd	ra,24(sp)
    80201502:	e822                	sd	s0,16(sp)
    80201504:	1000                	addi	s0,sp,32
	clear_screen();
    80201506:	00000097          	auipc	ra,0x0
    8020150a:	a46080e7          	jalr	-1466(ra) # 80200f4c <clear_screen>
    printf("=== 详细的Printf测试 ===\n");
    8020150e:	00005517          	auipc	a0,0x5
    80201512:	18a50513          	addi	a0,a0,394 # 80206698 <small_numbers+0x248>
    80201516:	fffff097          	auipc	ra,0xfffff
    8020151a:	63e080e7          	jalr	1598(ra) # 80200b54 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    8020151e:	00005517          	auipc	a0,0x5
    80201522:	19a50513          	addi	a0,a0,410 # 802066b8 <small_numbers+0x268>
    80201526:	fffff097          	auipc	ra,0xfffff
    8020152a:	62e080e7          	jalr	1582(ra) # 80200b54 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    8020152e:	0ff00593          	li	a1,255
    80201532:	00005517          	auipc	a0,0x5
    80201536:	19e50513          	addi	a0,a0,414 # 802066d0 <small_numbers+0x280>
    8020153a:	fffff097          	auipc	ra,0xfffff
    8020153e:	61a080e7          	jalr	1562(ra) # 80200b54 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    80201542:	6585                	lui	a1,0x1
    80201544:	00005517          	auipc	a0,0x5
    80201548:	1ac50513          	addi	a0,a0,428 # 802066f0 <small_numbers+0x2a0>
    8020154c:	fffff097          	auipc	ra,0xfffff
    80201550:	608080e7          	jalr	1544(ra) # 80200b54 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    80201554:	1234b7b7          	lui	a5,0x1234b
    80201558:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <userret+0x1234ab31>
    8020155c:	00005517          	auipc	a0,0x5
    80201560:	1b450513          	addi	a0,a0,436 # 80206710 <small_numbers+0x2c0>
    80201564:	fffff097          	auipc	ra,0xfffff
    80201568:	5f0080e7          	jalr	1520(ra) # 80200b54 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    8020156c:	00005517          	auipc	a0,0x5
    80201570:	1bc50513          	addi	a0,a0,444 # 80206728 <small_numbers+0x2d8>
    80201574:	fffff097          	auipc	ra,0xfffff
    80201578:	5e0080e7          	jalr	1504(ra) # 80200b54 <printf>
    printf("  正数: %d\n", 42);
    8020157c:	02a00593          	li	a1,42
    80201580:	00005517          	auipc	a0,0x5
    80201584:	1c050513          	addi	a0,a0,448 # 80206740 <small_numbers+0x2f0>
    80201588:	fffff097          	auipc	ra,0xfffff
    8020158c:	5cc080e7          	jalr	1484(ra) # 80200b54 <printf>
    printf("  负数: %d\n", -42);
    80201590:	fd600593          	li	a1,-42
    80201594:	00005517          	auipc	a0,0x5
    80201598:	1bc50513          	addi	a0,a0,444 # 80206750 <small_numbers+0x300>
    8020159c:	fffff097          	auipc	ra,0xfffff
    802015a0:	5b8080e7          	jalr	1464(ra) # 80200b54 <printf>
    printf("  零: %d\n", 0);
    802015a4:	4581                	li	a1,0
    802015a6:	00005517          	auipc	a0,0x5
    802015aa:	1ba50513          	addi	a0,a0,442 # 80206760 <small_numbers+0x310>
    802015ae:	fffff097          	auipc	ra,0xfffff
    802015b2:	5a6080e7          	jalr	1446(ra) # 80200b54 <printf>
    printf("  大数: %d\n", 123456789);
    802015b6:	075bd7b7          	lui	a5,0x75bd
    802015ba:	d1578593          	addi	a1,a5,-747 # 75bcd15 <userret+0x75bcc79>
    802015be:	00005517          	auipc	a0,0x5
    802015c2:	1b250513          	addi	a0,a0,434 # 80206770 <small_numbers+0x320>
    802015c6:	fffff097          	auipc	ra,0xfffff
    802015ca:	58e080e7          	jalr	1422(ra) # 80200b54 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    802015ce:	00005517          	auipc	a0,0x5
    802015d2:	1b250513          	addi	a0,a0,434 # 80206780 <small_numbers+0x330>
    802015d6:	fffff097          	auipc	ra,0xfffff
    802015da:	57e080e7          	jalr	1406(ra) # 80200b54 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    802015de:	55fd                	li	a1,-1
    802015e0:	00005517          	auipc	a0,0x5
    802015e4:	1b850513          	addi	a0,a0,440 # 80206798 <small_numbers+0x348>
    802015e8:	fffff097          	auipc	ra,0xfffff
    802015ec:	56c080e7          	jalr	1388(ra) # 80200b54 <printf>
    printf("  零：%u\n", 0U);
    802015f0:	4581                	li	a1,0
    802015f2:	00005517          	auipc	a0,0x5
    802015f6:	1be50513          	addi	a0,a0,446 # 802067b0 <small_numbers+0x360>
    802015fa:	fffff097          	auipc	ra,0xfffff
    802015fe:	55a080e7          	jalr	1370(ra) # 80200b54 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80201602:	678d                	lui	a5,0x3
    80201604:	03978593          	addi	a1,a5,57 # 3039 <userret+0x2f9d>
    80201608:	00005517          	auipc	a0,0x5
    8020160c:	1b850513          	addi	a0,a0,440 # 802067c0 <small_numbers+0x370>
    80201610:	fffff097          	auipc	ra,0xfffff
    80201614:	544080e7          	jalr	1348(ra) # 80200b54 <printf>

	// 测试边界
	printf("边界测试:\n");
    80201618:	00005517          	auipc	a0,0x5
    8020161c:	1c050513          	addi	a0,a0,448 # 802067d8 <small_numbers+0x388>
    80201620:	fffff097          	auipc	ra,0xfffff
    80201624:	534080e7          	jalr	1332(ra) # 80200b54 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    80201628:	800007b7          	lui	a5,0x80000
    8020162c:	fff7c593          	not	a1,a5
    80201630:	00005517          	auipc	a0,0x5
    80201634:	1b850513          	addi	a0,a0,440 # 802067e8 <small_numbers+0x398>
    80201638:	fffff097          	auipc	ra,0xfffff
    8020163c:	51c080e7          	jalr	1308(ra) # 80200b54 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    80201640:	800005b7          	lui	a1,0x80000
    80201644:	00005517          	auipc	a0,0x5
    80201648:	1b450513          	addi	a0,a0,436 # 802067f8 <small_numbers+0x3a8>
    8020164c:	fffff097          	auipc	ra,0xfffff
    80201650:	508080e7          	jalr	1288(ra) # 80200b54 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    80201654:	55fd                	li	a1,-1
    80201656:	00005517          	auipc	a0,0x5
    8020165a:	1b250513          	addi	a0,a0,434 # 80206808 <small_numbers+0x3b8>
    8020165e:	fffff097          	auipc	ra,0xfffff
    80201662:	4f6080e7          	jalr	1270(ra) # 80200b54 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    80201666:	55fd                	li	a1,-1
    80201668:	00005517          	auipc	a0,0x5
    8020166c:	1b050513          	addi	a0,a0,432 # 80206818 <small_numbers+0x3c8>
    80201670:	fffff097          	auipc	ra,0xfffff
    80201674:	4e4080e7          	jalr	1252(ra) # 80200b54 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    80201678:	00005517          	auipc	a0,0x5
    8020167c:	1b850513          	addi	a0,a0,440 # 80206830 <small_numbers+0x3e0>
    80201680:	fffff097          	auipc	ra,0xfffff
    80201684:	4d4080e7          	jalr	1236(ra) # 80200b54 <printf>
    printf("  空字符串: '%s'\n", "");
    80201688:	00005597          	auipc	a1,0x5
    8020168c:	1c058593          	addi	a1,a1,448 # 80206848 <small_numbers+0x3f8>
    80201690:	00005517          	auipc	a0,0x5
    80201694:	1c050513          	addi	a0,a0,448 # 80206850 <small_numbers+0x400>
    80201698:	fffff097          	auipc	ra,0xfffff
    8020169c:	4bc080e7          	jalr	1212(ra) # 80200b54 <printf>
    printf("  单字符: '%s'\n", "X");
    802016a0:	00005597          	auipc	a1,0x5
    802016a4:	1c858593          	addi	a1,a1,456 # 80206868 <small_numbers+0x418>
    802016a8:	00005517          	auipc	a0,0x5
    802016ac:	1c850513          	addi	a0,a0,456 # 80206870 <small_numbers+0x420>
    802016b0:	fffff097          	auipc	ra,0xfffff
    802016b4:	4a4080e7          	jalr	1188(ra) # 80200b54 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    802016b8:	00005597          	auipc	a1,0x5
    802016bc:	1d058593          	addi	a1,a1,464 # 80206888 <small_numbers+0x438>
    802016c0:	00005517          	auipc	a0,0x5
    802016c4:	1e850513          	addi	a0,a0,488 # 802068a8 <small_numbers+0x458>
    802016c8:	fffff097          	auipc	ra,0xfffff
    802016cc:	48c080e7          	jalr	1164(ra) # 80200b54 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    802016d0:	00005597          	auipc	a1,0x5
    802016d4:	1f058593          	addi	a1,a1,496 # 802068c0 <small_numbers+0x470>
    802016d8:	00005517          	auipc	a0,0x5
    802016dc:	33850513          	addi	a0,a0,824 # 80206a10 <small_numbers+0x5c0>
    802016e0:	fffff097          	auipc	ra,0xfffff
    802016e4:	474080e7          	jalr	1140(ra) # 80200b54 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    802016e8:	00005517          	auipc	a0,0x5
    802016ec:	34850513          	addi	a0,a0,840 # 80206a30 <small_numbers+0x5e0>
    802016f0:	fffff097          	auipc	ra,0xfffff
    802016f4:	464080e7          	jalr	1124(ra) # 80200b54 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    802016f8:	0ff00693          	li	a3,255
    802016fc:	f0100613          	li	a2,-255
    80201700:	0ff00593          	li	a1,255
    80201704:	00005517          	auipc	a0,0x5
    80201708:	34450513          	addi	a0,a0,836 # 80206a48 <small_numbers+0x5f8>
    8020170c:	fffff097          	auipc	ra,0xfffff
    80201710:	448080e7          	jalr	1096(ra) # 80200b54 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80201714:	00005517          	auipc	a0,0x5
    80201718:	35c50513          	addi	a0,a0,860 # 80206a70 <small_numbers+0x620>
    8020171c:	fffff097          	auipc	ra,0xfffff
    80201720:	438080e7          	jalr	1080(ra) # 80200b54 <printf>
	printf("  100%% 完成!\n");
    80201724:	00005517          	auipc	a0,0x5
    80201728:	36450513          	addi	a0,a0,868 # 80206a88 <small_numbers+0x638>
    8020172c:	fffff097          	auipc	ra,0xfffff
    80201730:	428080e7          	jalr	1064(ra) # 80200b54 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    80201734:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    80201738:	00005517          	auipc	a0,0x5
    8020173c:	36850513          	addi	a0,a0,872 # 80206aa0 <small_numbers+0x650>
    80201740:	fffff097          	auipc	ra,0xfffff
    80201744:	414080e7          	jalr	1044(ra) # 80200b54 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    80201748:	fe843583          	ld	a1,-24(s0)
    8020174c:	00005517          	auipc	a0,0x5
    80201750:	36c50513          	addi	a0,a0,876 # 80206ab8 <small_numbers+0x668>
    80201754:	fffff097          	auipc	ra,0xfffff
    80201758:	400080e7          	jalr	1024(ra) # 80200b54 <printf>
	
	// 测试指针格式
	int var = 42;
    8020175c:	02a00793          	li	a5,42
    80201760:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    80201764:	00005517          	auipc	a0,0x5
    80201768:	36c50513          	addi	a0,a0,876 # 80206ad0 <small_numbers+0x680>
    8020176c:	fffff097          	auipc	ra,0xfffff
    80201770:	3e8080e7          	jalr	1000(ra) # 80200b54 <printf>
	printf("  Address of var: %p\n", &var);
    80201774:	fe440793          	addi	a5,s0,-28
    80201778:	85be                	mv	a1,a5
    8020177a:	00005517          	auipc	a0,0x5
    8020177e:	36650513          	addi	a0,a0,870 # 80206ae0 <small_numbers+0x690>
    80201782:	fffff097          	auipc	ra,0xfffff
    80201786:	3d2080e7          	jalr	978(ra) # 80200b54 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    8020178a:	00005517          	auipc	a0,0x5
    8020178e:	36e50513          	addi	a0,a0,878 # 80206af8 <small_numbers+0x6a8>
    80201792:	fffff097          	auipc	ra,0xfffff
    80201796:	3c2080e7          	jalr	962(ra) # 80200b54 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    8020179a:	55fd                	li	a1,-1
    8020179c:	00005517          	auipc	a0,0x5
    802017a0:	37c50513          	addi	a0,a0,892 # 80206b18 <small_numbers+0x6c8>
    802017a4:	fffff097          	auipc	ra,0xfffff
    802017a8:	3b0080e7          	jalr	944(ra) # 80200b54 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    802017ac:	00005517          	auipc	a0,0x5
    802017b0:	38450513          	addi	a0,a0,900 # 80206b30 <small_numbers+0x6e0>
    802017b4:	fffff097          	auipc	ra,0xfffff
    802017b8:	3a0080e7          	jalr	928(ra) # 80200b54 <printf>
	printf("  Binary of 5: %b\n", 5);
    802017bc:	4595                	li	a1,5
    802017be:	00005517          	auipc	a0,0x5
    802017c2:	38a50513          	addi	a0,a0,906 # 80206b48 <small_numbers+0x6f8>
    802017c6:	fffff097          	auipc	ra,0xfffff
    802017ca:	38e080e7          	jalr	910(ra) # 80200b54 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    802017ce:	45a1                	li	a1,8
    802017d0:	00005517          	auipc	a0,0x5
    802017d4:	39050513          	addi	a0,a0,912 # 80206b60 <small_numbers+0x710>
    802017d8:	fffff097          	auipc	ra,0xfffff
    802017dc:	37c080e7          	jalr	892(ra) # 80200b54 <printf>
	printf("=== Printf测试结束 ===\n");
    802017e0:	00005517          	auipc	a0,0x5
    802017e4:	39850513          	addi	a0,a0,920 # 80206b78 <small_numbers+0x728>
    802017e8:	fffff097          	auipc	ra,0xfffff
    802017ec:	36c080e7          	jalr	876(ra) # 80200b54 <printf>
}
    802017f0:	0001                	nop
    802017f2:	60e2                	ld	ra,24(sp)
    802017f4:	6442                	ld	s0,16(sp)
    802017f6:	6105                	addi	sp,sp,32
    802017f8:	8082                	ret

00000000802017fa <test_curse_move>:
void test_curse_move(){
    802017fa:	1101                	addi	sp,sp,-32
    802017fc:	ec06                	sd	ra,24(sp)
    802017fe:	e822                	sd	s0,16(sp)
    80201800:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    80201802:	fffff097          	auipc	ra,0xfffff
    80201806:	74a080e7          	jalr	1866(ra) # 80200f4c <clear_screen>
	printf("=== 光标移动测试 ===\n");
    8020180a:	00005517          	auipc	a0,0x5
    8020180e:	38e50513          	addi	a0,a0,910 # 80206b98 <small_numbers+0x748>
    80201812:	fffff097          	auipc	ra,0xfffff
    80201816:	342080e7          	jalr	834(ra) # 80200b54 <printf>
	for (int i = 3; i <= 7; i++) {
    8020181a:	478d                	li	a5,3
    8020181c:	fef42623          	sw	a5,-20(s0)
    80201820:	a881                	j	80201870 <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    80201822:	4785                	li	a5,1
    80201824:	fef42423          	sw	a5,-24(s0)
    80201828:	a805                	j	80201858 <test_curse_move+0x5e>
			goto_rc(i, j);
    8020182a:	fe842703          	lw	a4,-24(s0)
    8020182e:	fec42783          	lw	a5,-20(s0)
    80201832:	85ba                	mv	a1,a4
    80201834:	853e                	mv	a0,a5
    80201836:	00000097          	auipc	ra,0x0
    8020183a:	96c080e7          	jalr	-1684(ra) # 802011a2 <goto_rc>
			printf("*");
    8020183e:	00005517          	auipc	a0,0x5
    80201842:	37a50513          	addi	a0,a0,890 # 80206bb8 <small_numbers+0x768>
    80201846:	fffff097          	auipc	ra,0xfffff
    8020184a:	30e080e7          	jalr	782(ra) # 80200b54 <printf>
		for (int j = 1; j <= 10; j++) {
    8020184e:	fe842783          	lw	a5,-24(s0)
    80201852:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdf42b1>
    80201854:	fef42423          	sw	a5,-24(s0)
    80201858:	fe842783          	lw	a5,-24(s0)
    8020185c:	0007871b          	sext.w	a4,a5
    80201860:	47a9                	li	a5,10
    80201862:	fce7d4e3          	bge	a5,a4,8020182a <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    80201866:	fec42783          	lw	a5,-20(s0)
    8020186a:	2785                	addiw	a5,a5,1
    8020186c:	fef42623          	sw	a5,-20(s0)
    80201870:	fec42783          	lw	a5,-20(s0)
    80201874:	0007871b          	sext.w	a4,a5
    80201878:	479d                	li	a5,7
    8020187a:	fae7d4e3          	bge	a5,a4,80201822 <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    8020187e:	4585                	li	a1,1
    80201880:	4525                	li	a0,9
    80201882:	00000097          	auipc	ra,0x0
    80201886:	920080e7          	jalr	-1760(ra) # 802011a2 <goto_rc>
	save_cursor();
    8020188a:	00000097          	auipc	ra,0x0
    8020188e:	854080e7          	jalr	-1964(ra) # 802010de <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201892:	4515                	li	a0,5
    80201894:	fffff097          	auipc	ra,0xfffff
    80201898:	6ea080e7          	jalr	1770(ra) # 80200f7e <cursor_up>
	cursor_right(2);
    8020189c:	4509                	li	a0,2
    8020189e:	fffff097          	auipc	ra,0xfffff
    802018a2:	790080e7          	jalr	1936(ra) # 8020102e <cursor_right>
	printf("+++++");
    802018a6:	00005517          	auipc	a0,0x5
    802018aa:	31a50513          	addi	a0,a0,794 # 80206bc0 <small_numbers+0x770>
    802018ae:	fffff097          	auipc	ra,0xfffff
    802018b2:	2a6080e7          	jalr	678(ra) # 80200b54 <printf>
	cursor_down(2);
    802018b6:	4509                	li	a0,2
    802018b8:	fffff097          	auipc	ra,0xfffff
    802018bc:	71e080e7          	jalr	1822(ra) # 80200fd6 <cursor_down>
	cursor_left(5);
    802018c0:	4515                	li	a0,5
    802018c2:	fffff097          	auipc	ra,0xfffff
    802018c6:	7c4080e7          	jalr	1988(ra) # 80201086 <cursor_left>
	printf("-----");
    802018ca:	00005517          	auipc	a0,0x5
    802018ce:	2fe50513          	addi	a0,a0,766 # 80206bc8 <small_numbers+0x778>
    802018d2:	fffff097          	auipc	ra,0xfffff
    802018d6:	282080e7          	jalr	642(ra) # 80200b54 <printf>
	restore_cursor();
    802018da:	00000097          	auipc	ra,0x0
    802018de:	838080e7          	jalr	-1992(ra) # 80201112 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    802018e2:	00005517          	auipc	a0,0x5
    802018e6:	2ee50513          	addi	a0,a0,750 # 80206bd0 <small_numbers+0x780>
    802018ea:	fffff097          	auipc	ra,0xfffff
    802018ee:	26a080e7          	jalr	618(ra) # 80200b54 <printf>
}
    802018f2:	0001                	nop
    802018f4:	60e2                	ld	ra,24(sp)
    802018f6:	6442                	ld	s0,16(sp)
    802018f8:	6105                	addi	sp,sp,32
    802018fa:	8082                	ret

00000000802018fc <test_basic_colors>:

void test_basic_colors(void) {
    802018fc:	1141                	addi	sp,sp,-16
    802018fe:	e406                	sd	ra,8(sp)
    80201900:	e022                	sd	s0,0(sp)
    80201902:	0800                	addi	s0,sp,16
    clear_screen();
    80201904:	fffff097          	auipc	ra,0xfffff
    80201908:	648080e7          	jalr	1608(ra) # 80200f4c <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    8020190c:	00005517          	auipc	a0,0x5
    80201910:	2ec50513          	addi	a0,a0,748 # 80206bf8 <small_numbers+0x7a8>
    80201914:	fffff097          	auipc	ra,0xfffff
    80201918:	240080e7          	jalr	576(ra) # 80200b54 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    8020191c:	00005517          	auipc	a0,0x5
    80201920:	2fc50513          	addi	a0,a0,764 # 80206c18 <small_numbers+0x7c8>
    80201924:	fffff097          	auipc	ra,0xfffff
    80201928:	230080e7          	jalr	560(ra) # 80200b54 <printf>
    color_red();    printf("红色文字 ");
    8020192c:	00000097          	auipc	ra,0x0
    80201930:	9e4080e7          	jalr	-1564(ra) # 80201310 <color_red>
    80201934:	00005517          	auipc	a0,0x5
    80201938:	2fc50513          	addi	a0,a0,764 # 80206c30 <small_numbers+0x7e0>
    8020193c:	fffff097          	auipc	ra,0xfffff
    80201940:	218080e7          	jalr	536(ra) # 80200b54 <printf>
    color_green();  printf("绿色文字 ");
    80201944:	00000097          	auipc	ra,0x0
    80201948:	9e8080e7          	jalr	-1560(ra) # 8020132c <color_green>
    8020194c:	00005517          	auipc	a0,0x5
    80201950:	2f450513          	addi	a0,a0,756 # 80206c40 <small_numbers+0x7f0>
    80201954:	fffff097          	auipc	ra,0xfffff
    80201958:	200080e7          	jalr	512(ra) # 80200b54 <printf>
    color_yellow(); printf("黄色文字 ");
    8020195c:	00000097          	auipc	ra,0x0
    80201960:	9ee080e7          	jalr	-1554(ra) # 8020134a <color_yellow>
    80201964:	00005517          	auipc	a0,0x5
    80201968:	2ec50513          	addi	a0,a0,748 # 80206c50 <small_numbers+0x800>
    8020196c:	fffff097          	auipc	ra,0xfffff
    80201970:	1e8080e7          	jalr	488(ra) # 80200b54 <printf>
    color_blue();   printf("蓝色文字 ");
    80201974:	00000097          	auipc	ra,0x0
    80201978:	9f4080e7          	jalr	-1548(ra) # 80201368 <color_blue>
    8020197c:	00005517          	auipc	a0,0x5
    80201980:	2e450513          	addi	a0,a0,740 # 80206c60 <small_numbers+0x810>
    80201984:	fffff097          	auipc	ra,0xfffff
    80201988:	1d0080e7          	jalr	464(ra) # 80200b54 <printf>
    color_purple(); printf("紫色文字 ");
    8020198c:	00000097          	auipc	ra,0x0
    80201990:	9fa080e7          	jalr	-1542(ra) # 80201386 <color_purple>
    80201994:	00005517          	auipc	a0,0x5
    80201998:	2dc50513          	addi	a0,a0,732 # 80206c70 <small_numbers+0x820>
    8020199c:	fffff097          	auipc	ra,0xfffff
    802019a0:	1b8080e7          	jalr	440(ra) # 80200b54 <printf>
    color_cyan();   printf("青色文字 ");
    802019a4:	00000097          	auipc	ra,0x0
    802019a8:	a00080e7          	jalr	-1536(ra) # 802013a4 <color_cyan>
    802019ac:	00005517          	auipc	a0,0x5
    802019b0:	2d450513          	addi	a0,a0,724 # 80206c80 <small_numbers+0x830>
    802019b4:	fffff097          	auipc	ra,0xfffff
    802019b8:	1a0080e7          	jalr	416(ra) # 80200b54 <printf>
    color_reverse();  printf("反色文字");
    802019bc:	00000097          	auipc	ra,0x0
    802019c0:	a06080e7          	jalr	-1530(ra) # 802013c2 <color_reverse>
    802019c4:	00005517          	auipc	a0,0x5
    802019c8:	2cc50513          	addi	a0,a0,716 # 80206c90 <small_numbers+0x840>
    802019cc:	fffff097          	auipc	ra,0xfffff
    802019d0:	188080e7          	jalr	392(ra) # 80200b54 <printf>
    reset_color();
    802019d4:	00000097          	auipc	ra,0x0
    802019d8:	840080e7          	jalr	-1984(ra) # 80201214 <reset_color>
    printf("\n\n");
    802019dc:	00005517          	auipc	a0,0x5
    802019e0:	2c450513          	addi	a0,a0,708 # 80206ca0 <small_numbers+0x850>
    802019e4:	fffff097          	auipc	ra,0xfffff
    802019e8:	170080e7          	jalr	368(ra) # 80200b54 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    802019ec:	00005517          	auipc	a0,0x5
    802019f0:	2bc50513          	addi	a0,a0,700 # 80206ca8 <small_numbers+0x858>
    802019f4:	fffff097          	auipc	ra,0xfffff
    802019f8:	160080e7          	jalr	352(ra) # 80200b54 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    802019fc:	02900513          	li	a0,41
    80201a00:	00000097          	auipc	ra,0x0
    80201a04:	8a2080e7          	jalr	-1886(ra) # 802012a2 <set_bg_color>
    80201a08:	00005517          	auipc	a0,0x5
    80201a0c:	2b850513          	addi	a0,a0,696 # 80206cc0 <small_numbers+0x870>
    80201a10:	fffff097          	auipc	ra,0xfffff
    80201a14:	144080e7          	jalr	324(ra) # 80200b54 <printf>
    80201a18:	fffff097          	auipc	ra,0xfffff
    80201a1c:	7fc080e7          	jalr	2044(ra) # 80201214 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80201a20:	02a00513          	li	a0,42
    80201a24:	00000097          	auipc	ra,0x0
    80201a28:	87e080e7          	jalr	-1922(ra) # 802012a2 <set_bg_color>
    80201a2c:	00005517          	auipc	a0,0x5
    80201a30:	2a450513          	addi	a0,a0,676 # 80206cd0 <small_numbers+0x880>
    80201a34:	fffff097          	auipc	ra,0xfffff
    80201a38:	120080e7          	jalr	288(ra) # 80200b54 <printf>
    80201a3c:	fffff097          	auipc	ra,0xfffff
    80201a40:	7d8080e7          	jalr	2008(ra) # 80201214 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80201a44:	02b00513          	li	a0,43
    80201a48:	00000097          	auipc	ra,0x0
    80201a4c:	85a080e7          	jalr	-1958(ra) # 802012a2 <set_bg_color>
    80201a50:	00005517          	auipc	a0,0x5
    80201a54:	29050513          	addi	a0,a0,656 # 80206ce0 <small_numbers+0x890>
    80201a58:	fffff097          	auipc	ra,0xfffff
    80201a5c:	0fc080e7          	jalr	252(ra) # 80200b54 <printf>
    80201a60:	fffff097          	auipc	ra,0xfffff
    80201a64:	7b4080e7          	jalr	1972(ra) # 80201214 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80201a68:	02c00513          	li	a0,44
    80201a6c:	00000097          	auipc	ra,0x0
    80201a70:	836080e7          	jalr	-1994(ra) # 802012a2 <set_bg_color>
    80201a74:	00005517          	auipc	a0,0x5
    80201a78:	27c50513          	addi	a0,a0,636 # 80206cf0 <small_numbers+0x8a0>
    80201a7c:	fffff097          	auipc	ra,0xfffff
    80201a80:	0d8080e7          	jalr	216(ra) # 80200b54 <printf>
    80201a84:	fffff097          	auipc	ra,0xfffff
    80201a88:	790080e7          	jalr	1936(ra) # 80201214 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201a8c:	02f00513          	li	a0,47
    80201a90:	00000097          	auipc	ra,0x0
    80201a94:	812080e7          	jalr	-2030(ra) # 802012a2 <set_bg_color>
    80201a98:	00005517          	auipc	a0,0x5
    80201a9c:	26850513          	addi	a0,a0,616 # 80206d00 <small_numbers+0x8b0>
    80201aa0:	fffff097          	auipc	ra,0xfffff
    80201aa4:	0b4080e7          	jalr	180(ra) # 80200b54 <printf>
    80201aa8:	fffff097          	auipc	ra,0xfffff
    80201aac:	76c080e7          	jalr	1900(ra) # 80201214 <reset_color>
    printf("\n\n");
    80201ab0:	00005517          	auipc	a0,0x5
    80201ab4:	1f050513          	addi	a0,a0,496 # 80206ca0 <small_numbers+0x850>
    80201ab8:	fffff097          	auipc	ra,0xfffff
    80201abc:	09c080e7          	jalr	156(ra) # 80200b54 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201ac0:	00005517          	auipc	a0,0x5
    80201ac4:	25050513          	addi	a0,a0,592 # 80206d10 <small_numbers+0x8c0>
    80201ac8:	fffff097          	auipc	ra,0xfffff
    80201acc:	08c080e7          	jalr	140(ra) # 80200b54 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201ad0:	02c00593          	li	a1,44
    80201ad4:	457d                	li	a0,31
    80201ad6:	00000097          	auipc	ra,0x0
    80201ada:	90a080e7          	jalr	-1782(ra) # 802013e0 <set_color>
    80201ade:	00005517          	auipc	a0,0x5
    80201ae2:	24a50513          	addi	a0,a0,586 # 80206d28 <small_numbers+0x8d8>
    80201ae6:	fffff097          	auipc	ra,0xfffff
    80201aea:	06e080e7          	jalr	110(ra) # 80200b54 <printf>
    80201aee:	fffff097          	auipc	ra,0xfffff
    80201af2:	726080e7          	jalr	1830(ra) # 80201214 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201af6:	02d00593          	li	a1,45
    80201afa:	02100513          	li	a0,33
    80201afe:	00000097          	auipc	ra,0x0
    80201b02:	8e2080e7          	jalr	-1822(ra) # 802013e0 <set_color>
    80201b06:	00005517          	auipc	a0,0x5
    80201b0a:	23250513          	addi	a0,a0,562 # 80206d38 <small_numbers+0x8e8>
    80201b0e:	fffff097          	auipc	ra,0xfffff
    80201b12:	046080e7          	jalr	70(ra) # 80200b54 <printf>
    80201b16:	fffff097          	auipc	ra,0xfffff
    80201b1a:	6fe080e7          	jalr	1790(ra) # 80201214 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201b1e:	02f00593          	li	a1,47
    80201b22:	02000513          	li	a0,32
    80201b26:	00000097          	auipc	ra,0x0
    80201b2a:	8ba080e7          	jalr	-1862(ra) # 802013e0 <set_color>
    80201b2e:	00005517          	auipc	a0,0x5
    80201b32:	21a50513          	addi	a0,a0,538 # 80206d48 <small_numbers+0x8f8>
    80201b36:	fffff097          	auipc	ra,0xfffff
    80201b3a:	01e080e7          	jalr	30(ra) # 80200b54 <printf>
    80201b3e:	fffff097          	auipc	ra,0xfffff
    80201b42:	6d6080e7          	jalr	1750(ra) # 80201214 <reset_color>
    printf("\n\n");
    80201b46:	00005517          	auipc	a0,0x5
    80201b4a:	15a50513          	addi	a0,a0,346 # 80206ca0 <small_numbers+0x850>
    80201b4e:	fffff097          	auipc	ra,0xfffff
    80201b52:	006080e7          	jalr	6(ra) # 80200b54 <printf>
	reset_color();
    80201b56:	fffff097          	auipc	ra,0xfffff
    80201b5a:	6be080e7          	jalr	1726(ra) # 80201214 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201b5e:	00005517          	auipc	a0,0x5
    80201b62:	1fa50513          	addi	a0,a0,506 # 80206d58 <small_numbers+0x908>
    80201b66:	fffff097          	auipc	ra,0xfffff
    80201b6a:	fee080e7          	jalr	-18(ra) # 80200b54 <printf>
	cursor_up(1); // 光标上移一行
    80201b6e:	4505                	li	a0,1
    80201b70:	fffff097          	auipc	ra,0xfffff
    80201b74:	40e080e7          	jalr	1038(ra) # 80200f7e <cursor_up>
	clear_line();
    80201b78:	00000097          	auipc	ra,0x0
    80201b7c:	8a4080e7          	jalr	-1884(ra) # 8020141c <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201b80:	00005517          	auipc	a0,0x5
    80201b84:	21050513          	addi	a0,a0,528 # 80206d90 <small_numbers+0x940>
    80201b88:	fffff097          	auipc	ra,0xfffff
    80201b8c:	fcc080e7          	jalr	-52(ra) # 80200b54 <printf>
    80201b90:	0001                	nop
    80201b92:	60a2                	ld	ra,8(sp)
    80201b94:	6402                	ld	s0,0(sp)
    80201b96:	0141                	addi	sp,sp,16
    80201b98:	8082                	ret

0000000080201b9a <memset>:
#include "defs.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201b9a:	7139                	addi	sp,sp,-64
    80201b9c:	fc22                	sd	s0,56(sp)
    80201b9e:	0080                	addi	s0,sp,64
    80201ba0:	fca43c23          	sd	a0,-40(s0)
    80201ba4:	87ae                	mv	a5,a1
    80201ba6:	fcc43423          	sd	a2,-56(s0)
    80201baa:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201bae:	fd843783          	ld	a5,-40(s0)
    80201bb2:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    80201bb6:	a829                	j	80201bd0 <memset+0x36>
        *p++ = (unsigned char)c;
    80201bb8:	fe843783          	ld	a5,-24(s0)
    80201bbc:	00178713          	addi	a4,a5,1
    80201bc0:	fee43423          	sd	a4,-24(s0)
    80201bc4:	fd442703          	lw	a4,-44(s0)
    80201bc8:	0ff77713          	zext.b	a4,a4
    80201bcc:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    80201bd0:	fc843783          	ld	a5,-56(s0)
    80201bd4:	fff78713          	addi	a4,a5,-1
    80201bd8:	fce43423          	sd	a4,-56(s0)
    80201bdc:	fff1                	bnez	a5,80201bb8 <memset+0x1e>
    return dst;
    80201bde:	fd843783          	ld	a5,-40(s0)
}
    80201be2:	853e                	mv	a0,a5
    80201be4:	7462                	ld	s0,56(sp)
    80201be6:	6121                	addi	sp,sp,64
    80201be8:	8082                	ret

0000000080201bea <memmove>:
void *memmove(void *dst, const void *src, unsigned long n) {
    80201bea:	7139                	addi	sp,sp,-64
    80201bec:	fc22                	sd	s0,56(sp)
    80201bee:	0080                	addi	s0,sp,64
    80201bf0:	fca43c23          	sd	a0,-40(s0)
    80201bf4:	fcb43823          	sd	a1,-48(s0)
    80201bf8:	fcc43423          	sd	a2,-56(s0)
	unsigned char *d = dst;
    80201bfc:	fd843783          	ld	a5,-40(s0)
    80201c00:	fef43423          	sd	a5,-24(s0)
	const unsigned char *s = src;
    80201c04:	fd043783          	ld	a5,-48(s0)
    80201c08:	fef43023          	sd	a5,-32(s0)
	if (d < s) {
    80201c0c:	fe843703          	ld	a4,-24(s0)
    80201c10:	fe043783          	ld	a5,-32(s0)
    80201c14:	02f77b63          	bgeu	a4,a5,80201c4a <memmove+0x60>
		while (n-- > 0)
    80201c18:	a00d                	j	80201c3a <memmove+0x50>
			*d++ = *s++;
    80201c1a:	fe043703          	ld	a4,-32(s0)
    80201c1e:	00170793          	addi	a5,a4,1
    80201c22:	fef43023          	sd	a5,-32(s0)
    80201c26:	fe843783          	ld	a5,-24(s0)
    80201c2a:	00178693          	addi	a3,a5,1
    80201c2e:	fed43423          	sd	a3,-24(s0)
    80201c32:	00074703          	lbu	a4,0(a4)
    80201c36:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201c3a:	fc843783          	ld	a5,-56(s0)
    80201c3e:	fff78713          	addi	a4,a5,-1
    80201c42:	fce43423          	sd	a4,-56(s0)
    80201c46:	fbf1                	bnez	a5,80201c1a <memmove+0x30>
    80201c48:	a889                	j	80201c9a <memmove+0xb0>
	} else {
		d += n;
    80201c4a:	fe843703          	ld	a4,-24(s0)
    80201c4e:	fc843783          	ld	a5,-56(s0)
    80201c52:	97ba                	add	a5,a5,a4
    80201c54:	fef43423          	sd	a5,-24(s0)
		s += n;
    80201c58:	fe043703          	ld	a4,-32(s0)
    80201c5c:	fc843783          	ld	a5,-56(s0)
    80201c60:	97ba                	add	a5,a5,a4
    80201c62:	fef43023          	sd	a5,-32(s0)
		while (n-- > 0)
    80201c66:	a01d                	j	80201c8c <memmove+0xa2>
			*(--d) = *(--s);
    80201c68:	fe043783          	ld	a5,-32(s0)
    80201c6c:	17fd                	addi	a5,a5,-1
    80201c6e:	fef43023          	sd	a5,-32(s0)
    80201c72:	fe843783          	ld	a5,-24(s0)
    80201c76:	17fd                	addi	a5,a5,-1
    80201c78:	fef43423          	sd	a5,-24(s0)
    80201c7c:	fe043783          	ld	a5,-32(s0)
    80201c80:	0007c703          	lbu	a4,0(a5)
    80201c84:	fe843783          	ld	a5,-24(s0)
    80201c88:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201c8c:	fc843783          	ld	a5,-56(s0)
    80201c90:	fff78713          	addi	a4,a5,-1
    80201c94:	fce43423          	sd	a4,-56(s0)
    80201c98:	fbe1                	bnez	a5,80201c68 <memmove+0x7e>
	}
	return dst;
    80201c9a:	fd843783          	ld	a5,-40(s0)
}
    80201c9e:	853e                	mv	a0,a5
    80201ca0:	7462                	ld	s0,56(sp)
    80201ca2:	6121                	addi	sp,sp,64
    80201ca4:	8082                	ret

0000000080201ca6 <memcpy>:
void *memcpy(void *dst, const void *src, size_t n) {
    80201ca6:	715d                	addi	sp,sp,-80
    80201ca8:	e4a2                	sd	s0,72(sp)
    80201caa:	0880                	addi	s0,sp,80
    80201cac:	fca43423          	sd	a0,-56(s0)
    80201cb0:	fcb43023          	sd	a1,-64(s0)
    80201cb4:	fac43c23          	sd	a2,-72(s0)
    char *d = dst;
    80201cb8:	fc843783          	ld	a5,-56(s0)
    80201cbc:	fef43023          	sd	a5,-32(s0)
    const char *s = src;
    80201cc0:	fc043783          	ld	a5,-64(s0)
    80201cc4:	fcf43c23          	sd	a5,-40(s0)
    for (size_t i = 0; i < n; i++) {
    80201cc8:	fe043423          	sd	zero,-24(s0)
    80201ccc:	a025                	j	80201cf4 <memcpy+0x4e>
        d[i] = s[i];
    80201cce:	fd843703          	ld	a4,-40(s0)
    80201cd2:	fe843783          	ld	a5,-24(s0)
    80201cd6:	973e                	add	a4,a4,a5
    80201cd8:	fe043683          	ld	a3,-32(s0)
    80201cdc:	fe843783          	ld	a5,-24(s0)
    80201ce0:	97b6                	add	a5,a5,a3
    80201ce2:	00074703          	lbu	a4,0(a4)
    80201ce6:	00e78023          	sb	a4,0(a5)
    for (size_t i = 0; i < n; i++) {
    80201cea:	fe843783          	ld	a5,-24(s0)
    80201cee:	0785                	addi	a5,a5,1
    80201cf0:	fef43423          	sd	a5,-24(s0)
    80201cf4:	fe843703          	ld	a4,-24(s0)
    80201cf8:	fb843783          	ld	a5,-72(s0)
    80201cfc:	fcf769e3          	bltu	a4,a5,80201cce <memcpy+0x28>
    }
    return dst;
    80201d00:	fc843783          	ld	a5,-56(s0)
    80201d04:	853e                	mv	a0,a5
    80201d06:	6426                	ld	s0,72(sp)
    80201d08:	6161                	addi	sp,sp,80
    80201d0a:	8082                	ret

0000000080201d0c <assert>:
    80201d0c:	1101                	addi	sp,sp,-32
    80201d0e:	ec06                	sd	ra,24(sp)
    80201d10:	e822                	sd	s0,16(sp)
    80201d12:	1000                	addi	s0,sp,32
    80201d14:	87aa                	mv	a5,a0
    80201d16:	fef42623          	sw	a5,-20(s0)
    80201d1a:	fec42783          	lw	a5,-20(s0)
    80201d1e:	2781                	sext.w	a5,a5
    80201d20:	e79d                	bnez	a5,80201d4e <assert+0x42>
    80201d22:	18700613          	li	a2,391
    80201d26:	00005597          	auipc	a1,0x5
    80201d2a:	08a58593          	addi	a1,a1,138 # 80206db0 <small_numbers+0x960>
    80201d2e:	00005517          	auipc	a0,0x5
    80201d32:	09250513          	addi	a0,a0,146 # 80206dc0 <small_numbers+0x970>
    80201d36:	fffff097          	auipc	ra,0xfffff
    80201d3a:	e1e080e7          	jalr	-482(ra) # 80200b54 <printf>
    80201d3e:	00005517          	auipc	a0,0x5
    80201d42:	0aa50513          	addi	a0,a0,170 # 80206de8 <small_numbers+0x998>
    80201d46:	fffff097          	auipc	ra,0xfffff
    80201d4a:	716080e7          	jalr	1814(ra) # 8020145c <panic>
    80201d4e:	0001                	nop
    80201d50:	60e2                	ld	ra,24(sp)
    80201d52:	6442                	ld	s0,16(sp)
    80201d54:	6105                	addi	sp,sp,32
    80201d56:	8082                	ret

0000000080201d58 <px>:
static inline uint64 px(int level, uint64 va) {
    80201d58:	1101                	addi	sp,sp,-32
    80201d5a:	ec22                	sd	s0,24(sp)
    80201d5c:	1000                	addi	s0,sp,32
    80201d5e:	87aa                	mv	a5,a0
    80201d60:	feb43023          	sd	a1,-32(s0)
    80201d64:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    80201d68:	fec42783          	lw	a5,-20(s0)
    80201d6c:	873e                	mv	a4,a5
    80201d6e:	87ba                	mv	a5,a4
    80201d70:	0037979b          	slliw	a5,a5,0x3
    80201d74:	9fb9                	addw	a5,a5,a4
    80201d76:	2781                	sext.w	a5,a5
    80201d78:	27b1                	addiw	a5,a5,12
    80201d7a:	2781                	sext.w	a5,a5
    80201d7c:	873e                	mv	a4,a5
    80201d7e:	fe043783          	ld	a5,-32(s0)
    80201d82:	00e7d7b3          	srl	a5,a5,a4
    80201d86:	1ff7f793          	andi	a5,a5,511
}
    80201d8a:	853e                	mv	a0,a5
    80201d8c:	6462                	ld	s0,24(sp)
    80201d8e:	6105                	addi	sp,sp,32
    80201d90:	8082                	ret

0000000080201d92 <create_pagetable>:
pagetable_t create_pagetable(void) {
    80201d92:	1101                	addi	sp,sp,-32
    80201d94:	ec06                	sd	ra,24(sp)
    80201d96:	e822                	sd	s0,16(sp)
    80201d98:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    80201d9a:	00001097          	auipc	ra,0x1
    80201d9e:	d16080e7          	jalr	-746(ra) # 80202ab0 <alloc_page>
    80201da2:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    80201da6:	fe843783          	ld	a5,-24(s0)
    80201daa:	e399                	bnez	a5,80201db0 <create_pagetable+0x1e>
        return 0;
    80201dac:	4781                	li	a5,0
    80201dae:	a819                	j	80201dc4 <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    80201db0:	6605                	lui	a2,0x1
    80201db2:	4581                	li	a1,0
    80201db4:	fe843503          	ld	a0,-24(s0)
    80201db8:	00000097          	auipc	ra,0x0
    80201dbc:	de2080e7          	jalr	-542(ra) # 80201b9a <memset>
    return pt;
    80201dc0:	fe843783          	ld	a5,-24(s0)
}
    80201dc4:	853e                	mv	a0,a5
    80201dc6:	60e2                	ld	ra,24(sp)
    80201dc8:	6442                	ld	s0,16(sp)
    80201dca:	6105                	addi	sp,sp,32
    80201dcc:	8082                	ret

0000000080201dce <walk_lookup>:
static pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    80201dce:	7179                	addi	sp,sp,-48
    80201dd0:	f406                	sd	ra,40(sp)
    80201dd2:	f022                	sd	s0,32(sp)
    80201dd4:	1800                	addi	s0,sp,48
    80201dd6:	fca43c23          	sd	a0,-40(s0)
    80201dda:	fcb43823          	sd	a1,-48(s0)
    if (va >= MAXVA)
    80201dde:	fd043703          	ld	a4,-48(s0)
    80201de2:	57fd                	li	a5,-1
    80201de4:	83e5                	srli	a5,a5,0x19
    80201de6:	00e7fa63          	bgeu	a5,a4,80201dfa <walk_lookup+0x2c>
        panic("walk_lookup: va out of range");
    80201dea:	00005517          	auipc	a0,0x5
    80201dee:	00650513          	addi	a0,a0,6 # 80206df0 <small_numbers+0x9a0>
    80201df2:	fffff097          	auipc	ra,0xfffff
    80201df6:	66a080e7          	jalr	1642(ra) # 8020145c <panic>
    for (int level = 2; level > 0; level--) {
    80201dfa:	4789                	li	a5,2
    80201dfc:	fef42623          	sw	a5,-20(s0)
    80201e00:	a0a9                	j	80201e4a <walk_lookup+0x7c>
        pte_t *pte = &pt[px(level, va)];
    80201e02:	fec42783          	lw	a5,-20(s0)
    80201e06:	fd043583          	ld	a1,-48(s0)
    80201e0a:	853e                	mv	a0,a5
    80201e0c:	00000097          	auipc	ra,0x0
    80201e10:	f4c080e7          	jalr	-180(ra) # 80201d58 <px>
    80201e14:	87aa                	mv	a5,a0
    80201e16:	078e                	slli	a5,a5,0x3
    80201e18:	fd843703          	ld	a4,-40(s0)
    80201e1c:	97ba                	add	a5,a5,a4
    80201e1e:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80201e22:	fe043783          	ld	a5,-32(s0)
    80201e26:	639c                	ld	a5,0(a5)
    80201e28:	8b85                	andi	a5,a5,1
    80201e2a:	cb89                	beqz	a5,80201e3c <walk_lookup+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    80201e2c:	fe043783          	ld	a5,-32(s0)
    80201e30:	639c                	ld	a5,0(a5)
    80201e32:	83a9                	srli	a5,a5,0xa
    80201e34:	07b2                	slli	a5,a5,0xc
    80201e36:	fcf43c23          	sd	a5,-40(s0)
    80201e3a:	a019                	j	80201e40 <walk_lookup+0x72>
            return 0;
    80201e3c:	4781                	li	a5,0
    80201e3e:	a03d                	j	80201e6c <walk_lookup+0x9e>
    for (int level = 2; level > 0; level--) {
    80201e40:	fec42783          	lw	a5,-20(s0)
    80201e44:	37fd                	addiw	a5,a5,-1
    80201e46:	fef42623          	sw	a5,-20(s0)
    80201e4a:	fec42783          	lw	a5,-20(s0)
    80201e4e:	2781                	sext.w	a5,a5
    80201e50:	faf049e3          	bgtz	a5,80201e02 <walk_lookup+0x34>
    return &pt[px(0, va)];
    80201e54:	fd043583          	ld	a1,-48(s0)
    80201e58:	4501                	li	a0,0
    80201e5a:	00000097          	auipc	ra,0x0
    80201e5e:	efe080e7          	jalr	-258(ra) # 80201d58 <px>
    80201e62:	87aa                	mv	a5,a0
    80201e64:	078e                	slli	a5,a5,0x3
    80201e66:	fd843703          	ld	a4,-40(s0)
    80201e6a:	97ba                	add	a5,a5,a4
}
    80201e6c:	853e                	mv	a0,a5
    80201e6e:	70a2                	ld	ra,40(sp)
    80201e70:	7402                	ld	s0,32(sp)
    80201e72:	6145                	addi	sp,sp,48
    80201e74:	8082                	ret

0000000080201e76 <walk_create>:
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    80201e76:	7139                	addi	sp,sp,-64
    80201e78:	fc06                	sd	ra,56(sp)
    80201e7a:	f822                	sd	s0,48(sp)
    80201e7c:	0080                	addi	s0,sp,64
    80201e7e:	fca43423          	sd	a0,-56(s0)
    80201e82:	fcb43023          	sd	a1,-64(s0)
    if (va >= MAXVA)
    80201e86:	fc043703          	ld	a4,-64(s0)
    80201e8a:	57fd                	li	a5,-1
    80201e8c:	83e5                	srli	a5,a5,0x19
    80201e8e:	00e7fa63          	bgeu	a5,a4,80201ea2 <walk_create+0x2c>
        panic("walk_create: va out of range");
    80201e92:	00005517          	auipc	a0,0x5
    80201e96:	f7e50513          	addi	a0,a0,-130 # 80206e10 <small_numbers+0x9c0>
    80201e9a:	fffff097          	auipc	ra,0xfffff
    80201e9e:	5c2080e7          	jalr	1474(ra) # 8020145c <panic>
    for (int level = 2; level > 0; level--) {
    80201ea2:	4789                	li	a5,2
    80201ea4:	fef42623          	sw	a5,-20(s0)
    80201ea8:	a059                	j	80201f2e <walk_create+0xb8>
        pte_t *pte = &pt[px(level, va)];
    80201eaa:	fec42783          	lw	a5,-20(s0)
    80201eae:	fc043583          	ld	a1,-64(s0)
    80201eb2:	853e                	mv	a0,a5
    80201eb4:	00000097          	auipc	ra,0x0
    80201eb8:	ea4080e7          	jalr	-348(ra) # 80201d58 <px>
    80201ebc:	87aa                	mv	a5,a0
    80201ebe:	078e                	slli	a5,a5,0x3
    80201ec0:	fc843703          	ld	a4,-56(s0)
    80201ec4:	97ba                	add	a5,a5,a4
    80201ec6:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80201eca:	fe043783          	ld	a5,-32(s0)
    80201ece:	639c                	ld	a5,0(a5)
    80201ed0:	8b85                	andi	a5,a5,1
    80201ed2:	cb89                	beqz	a5,80201ee4 <walk_create+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    80201ed4:	fe043783          	ld	a5,-32(s0)
    80201ed8:	639c                	ld	a5,0(a5)
    80201eda:	83a9                	srli	a5,a5,0xa
    80201edc:	07b2                	slli	a5,a5,0xc
    80201ede:	fcf43423          	sd	a5,-56(s0)
    80201ee2:	a089                	j	80201f24 <walk_create+0xae>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    80201ee4:	00001097          	auipc	ra,0x1
    80201ee8:	bcc080e7          	jalr	-1076(ra) # 80202ab0 <alloc_page>
    80201eec:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    80201ef0:	fd843783          	ld	a5,-40(s0)
    80201ef4:	e399                	bnez	a5,80201efa <walk_create+0x84>
                return 0;
    80201ef6:	4781                	li	a5,0
    80201ef8:	a8a1                	j	80201f50 <walk_create+0xda>
            memset(new_pt, 0, PGSIZE);
    80201efa:	6605                	lui	a2,0x1
    80201efc:	4581                	li	a1,0
    80201efe:	fd843503          	ld	a0,-40(s0)
    80201f02:	00000097          	auipc	ra,0x0
    80201f06:	c98080e7          	jalr	-872(ra) # 80201b9a <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    80201f0a:	fd843783          	ld	a5,-40(s0)
    80201f0e:	83b1                	srli	a5,a5,0xc
    80201f10:	07aa                	slli	a5,a5,0xa
    80201f12:	0017e713          	ori	a4,a5,1
    80201f16:	fe043783          	ld	a5,-32(s0)
    80201f1a:	e398                	sd	a4,0(a5)
            pt = new_pt;
    80201f1c:	fd843783          	ld	a5,-40(s0)
    80201f20:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    80201f24:	fec42783          	lw	a5,-20(s0)
    80201f28:	37fd                	addiw	a5,a5,-1
    80201f2a:	fef42623          	sw	a5,-20(s0)
    80201f2e:	fec42783          	lw	a5,-20(s0)
    80201f32:	2781                	sext.w	a5,a5
    80201f34:	f6f04be3          	bgtz	a5,80201eaa <walk_create+0x34>
    return &pt[px(0, va)];
    80201f38:	fc043583          	ld	a1,-64(s0)
    80201f3c:	4501                	li	a0,0
    80201f3e:	00000097          	auipc	ra,0x0
    80201f42:	e1a080e7          	jalr	-486(ra) # 80201d58 <px>
    80201f46:	87aa                	mv	a5,a0
    80201f48:	078e                	slli	a5,a5,0x3
    80201f4a:	fc843703          	ld	a4,-56(s0)
    80201f4e:	97ba                	add	a5,a5,a4
}
    80201f50:	853e                	mv	a0,a5
    80201f52:	70e2                	ld	ra,56(sp)
    80201f54:	7442                	ld	s0,48(sp)
    80201f56:	6121                	addi	sp,sp,64
    80201f58:	8082                	ret

0000000080201f5a <map_page>:
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    80201f5a:	7139                	addi	sp,sp,-64
    80201f5c:	fc06                	sd	ra,56(sp)
    80201f5e:	f822                	sd	s0,48(sp)
    80201f60:	0080                	addi	s0,sp,64
    80201f62:	fca43c23          	sd	a0,-40(s0)
    80201f66:	fcb43823          	sd	a1,-48(s0)
    80201f6a:	fcc43423          	sd	a2,-56(s0)
    80201f6e:	87b6                	mv	a5,a3
    80201f70:	fcf42223          	sw	a5,-60(s0)
    if ((va % PGSIZE) != 0)
    80201f74:	fd043703          	ld	a4,-48(s0)
    80201f78:	6785                	lui	a5,0x1
    80201f7a:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80201f7c:	8ff9                	and	a5,a5,a4
    80201f7e:	cb89                	beqz	a5,80201f90 <map_page+0x36>
        panic("map_page: va not aligned");
    80201f80:	00005517          	auipc	a0,0x5
    80201f84:	eb050513          	addi	a0,a0,-336 # 80206e30 <small_numbers+0x9e0>
    80201f88:	fffff097          	auipc	ra,0xfffff
    80201f8c:	4d4080e7          	jalr	1236(ra) # 8020145c <panic>
    pte_t *pte = walk_create(pt, va);
    80201f90:	fd043583          	ld	a1,-48(s0)
    80201f94:	fd843503          	ld	a0,-40(s0)
    80201f98:	00000097          	auipc	ra,0x0
    80201f9c:	ede080e7          	jalr	-290(ra) # 80201e76 <walk_create>
    80201fa0:	fea43423          	sd	a0,-24(s0)
    if (!pte)
    80201fa4:	fe843783          	ld	a5,-24(s0)
    80201fa8:	e399                	bnez	a5,80201fae <map_page+0x54>
        return -1;
    80201faa:	57fd                	li	a5,-1
    80201fac:	a069                	j	80202036 <map_page+0xdc>
	if (*pte & PTE_V) {
    80201fae:	fe843783          	ld	a5,-24(s0)
    80201fb2:	639c                	ld	a5,0(a5)
    80201fb4:	8b85                	andi	a5,a5,1
    80201fb6:	c3b5                	beqz	a5,8020201a <map_page+0xc0>
		if (PTE2PA(*pte) == pa) {
    80201fb8:	fe843783          	ld	a5,-24(s0)
    80201fbc:	639c                	ld	a5,0(a5)
    80201fbe:	83a9                	srli	a5,a5,0xa
    80201fc0:	07b2                	slli	a5,a5,0xc
    80201fc2:	fc843703          	ld	a4,-56(s0)
    80201fc6:	04f71263          	bne	a4,a5,8020200a <map_page+0xb0>
			int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
    80201fca:	fe843783          	ld	a5,-24(s0)
    80201fce:	639c                	ld	a5,0(a5)
    80201fd0:	2781                	sext.w	a5,a5
    80201fd2:	3ff7f793          	andi	a5,a5,1023
    80201fd6:	0007871b          	sext.w	a4,a5
    80201fda:	fc442783          	lw	a5,-60(s0)
    80201fde:	8fd9                	or	a5,a5,a4
    80201fe0:	2781                	sext.w	a5,a5
    80201fe2:	2781                	sext.w	a5,a5
    80201fe4:	3ff7f793          	andi	a5,a5,1023
    80201fe8:	fef42223          	sw	a5,-28(s0)
			*pte = PA2PTE(pa) | new_perm | PTE_V;
    80201fec:	fc843783          	ld	a5,-56(s0)
    80201ff0:	83b1                	srli	a5,a5,0xc
    80201ff2:	00a79713          	slli	a4,a5,0xa
    80201ff6:	fe442783          	lw	a5,-28(s0)
    80201ffa:	8fd9                	or	a5,a5,a4
    80201ffc:	0017e713          	ori	a4,a5,1
    80202000:	fe843783          	ld	a5,-24(s0)
    80202004:	e398                	sd	a4,0(a5)
			return 0;
    80202006:	4781                	li	a5,0
    80202008:	a03d                	j	80202036 <map_page+0xdc>
			panic("map_page: remap to different physical address");
    8020200a:	00005517          	auipc	a0,0x5
    8020200e:	e4650513          	addi	a0,a0,-442 # 80206e50 <small_numbers+0xa00>
    80202012:	fffff097          	auipc	ra,0xfffff
    80202016:	44a080e7          	jalr	1098(ra) # 8020145c <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8020201a:	fc843783          	ld	a5,-56(s0)
    8020201e:	83b1                	srli	a5,a5,0xc
    80202020:	00a79713          	slli	a4,a5,0xa
    80202024:	fc442783          	lw	a5,-60(s0)
    80202028:	8fd9                	or	a5,a5,a4
    8020202a:	0017e713          	ori	a4,a5,1
    8020202e:	fe843783          	ld	a5,-24(s0)
    80202032:	e398                	sd	a4,0(a5)
    return 0;
    80202034:	4781                	li	a5,0
}
    80202036:	853e                	mv	a0,a5
    80202038:	70e2                	ld	ra,56(sp)
    8020203a:	7442                	ld	s0,48(sp)
    8020203c:	6121                	addi	sp,sp,64
    8020203e:	8082                	ret

0000000080202040 <free_pagetable>:
void free_pagetable(pagetable_t pt) {
    80202040:	7139                	addi	sp,sp,-64
    80202042:	fc06                	sd	ra,56(sp)
    80202044:	f822                	sd	s0,48(sp)
    80202046:	0080                	addi	s0,sp,64
    80202048:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    8020204c:	fe042623          	sw	zero,-20(s0)
    80202050:	a8a5                	j	802020c8 <free_pagetable+0x88>
        pte_t pte = pt[i];
    80202052:	fec42783          	lw	a5,-20(s0)
    80202056:	078e                	slli	a5,a5,0x3
    80202058:	fc843703          	ld	a4,-56(s0)
    8020205c:	97ba                	add	a5,a5,a4
    8020205e:	639c                	ld	a5,0(a5)
    80202060:	fef43023          	sd	a5,-32(s0)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80202064:	fe043783          	ld	a5,-32(s0)
    80202068:	8b85                	andi	a5,a5,1
    8020206a:	cb95                	beqz	a5,8020209e <free_pagetable+0x5e>
    8020206c:	fe043783          	ld	a5,-32(s0)
    80202070:	8bb9                	andi	a5,a5,14
    80202072:	e795                	bnez	a5,8020209e <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    80202074:	fe043783          	ld	a5,-32(s0)
    80202078:	83a9                	srli	a5,a5,0xa
    8020207a:	07b2                	slli	a5,a5,0xc
    8020207c:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    80202080:	fd843503          	ld	a0,-40(s0)
    80202084:	00000097          	auipc	ra,0x0
    80202088:	fbc080e7          	jalr	-68(ra) # 80202040 <free_pagetable>
            pt[i] = 0;
    8020208c:	fec42783          	lw	a5,-20(s0)
    80202090:	078e                	slli	a5,a5,0x3
    80202092:	fc843703          	ld	a4,-56(s0)
    80202096:	97ba                	add	a5,a5,a4
    80202098:	0007b023          	sd	zero,0(a5)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    8020209c:	a00d                	j	802020be <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    8020209e:	fe043783          	ld	a5,-32(s0)
    802020a2:	8b85                	andi	a5,a5,1
    802020a4:	cf89                	beqz	a5,802020be <free_pagetable+0x7e>
    802020a6:	fe043783          	ld	a5,-32(s0)
    802020aa:	8bb9                	andi	a5,a5,14
    802020ac:	cb89                	beqz	a5,802020be <free_pagetable+0x7e>
            pt[i] = 0;
    802020ae:	fec42783          	lw	a5,-20(s0)
    802020b2:	078e                	slli	a5,a5,0x3
    802020b4:	fc843703          	ld	a4,-56(s0)
    802020b8:	97ba                	add	a5,a5,a4
    802020ba:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    802020be:	fec42783          	lw	a5,-20(s0)
    802020c2:	2785                	addiw	a5,a5,1
    802020c4:	fef42623          	sw	a5,-20(s0)
    802020c8:	fec42783          	lw	a5,-20(s0)
    802020cc:	0007871b          	sext.w	a4,a5
    802020d0:	1ff00793          	li	a5,511
    802020d4:	f6e7dfe3          	bge	a5,a4,80202052 <free_pagetable+0x12>
    free_page(pt);
    802020d8:	fc843503          	ld	a0,-56(s0)
    802020dc:	00001097          	auipc	ra,0x1
    802020e0:	a40080e7          	jalr	-1472(ra) # 80202b1c <free_page>
}
    802020e4:	0001                	nop
    802020e6:	70e2                	ld	ra,56(sp)
    802020e8:	7442                	ld	s0,48(sp)
    802020ea:	6121                	addi	sp,sp,64
    802020ec:	8082                	ret

00000000802020ee <kvmmake>:
static pagetable_t kvmmake(void) {
    802020ee:	711d                	addi	sp,sp,-96
    802020f0:	ec86                	sd	ra,88(sp)
    802020f2:	e8a2                	sd	s0,80(sp)
    802020f4:	1080                	addi	s0,sp,96
    pagetable_t kpgtbl = create_pagetable();
    802020f6:	00000097          	auipc	ra,0x0
    802020fa:	c9c080e7          	jalr	-868(ra) # 80201d92 <create_pagetable>
    802020fe:	faa43c23          	sd	a0,-72(s0)
    if (!kpgtbl)
    80202102:	fb843783          	ld	a5,-72(s0)
    80202106:	eb89                	bnez	a5,80202118 <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    80202108:	00005517          	auipc	a0,0x5
    8020210c:	d7850513          	addi	a0,a0,-648 # 80206e80 <small_numbers+0xa30>
    80202110:	fffff097          	auipc	ra,0xfffff
    80202114:	34c080e7          	jalr	844(ra) # 8020145c <panic>
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    80202118:	4785                	li	a5,1
    8020211a:	07fe                	slli	a5,a5,0x1f
    8020211c:	fef43423          	sd	a5,-24(s0)
    80202120:	a825                	j	80202158 <kvmmake+0x6a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_X) != 0)
    80202122:	46a9                	li	a3,10
    80202124:	fe843603          	ld	a2,-24(s0)
    80202128:	fe843583          	ld	a1,-24(s0)
    8020212c:	fb843503          	ld	a0,-72(s0)
    80202130:	00000097          	auipc	ra,0x0
    80202134:	e2a080e7          	jalr	-470(ra) # 80201f5a <map_page>
    80202138:	87aa                	mv	a5,a0
    8020213a:	cb89                	beqz	a5,8020214c <kvmmake+0x5e>
            panic("kvmmake: code map failed");
    8020213c:	00005517          	auipc	a0,0x5
    80202140:	d5c50513          	addi	a0,a0,-676 # 80206e98 <small_numbers+0xa48>
    80202144:	fffff097          	auipc	ra,0xfffff
    80202148:	318080e7          	jalr	792(ra) # 8020145c <panic>
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    8020214c:	fe843703          	ld	a4,-24(s0)
    80202150:	6785                	lui	a5,0x1
    80202152:	97ba                	add	a5,a5,a4
    80202154:	fef43423          	sd	a5,-24(s0)
    80202158:	00004797          	auipc	a5,0x4
    8020215c:	ea878793          	addi	a5,a5,-344 # 80206000 <etext>
    80202160:	fe843703          	ld	a4,-24(s0)
    80202164:	faf76fe3          	bltu	a4,a5,80202122 <kvmmake+0x34>
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    80202168:	00004797          	auipc	a5,0x4
    8020216c:	e9878793          	addi	a5,a5,-360 # 80206000 <etext>
    80202170:	fef43023          	sd	a5,-32(s0)
    80202174:	a825                	j	802021ac <kvmmake+0xbe>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202176:	4699                	li	a3,6
    80202178:	fe043603          	ld	a2,-32(s0)
    8020217c:	fe043583          	ld	a1,-32(s0)
    80202180:	fb843503          	ld	a0,-72(s0)
    80202184:	00000097          	auipc	ra,0x0
    80202188:	dd6080e7          	jalr	-554(ra) # 80201f5a <map_page>
    8020218c:	87aa                	mv	a5,a0
    8020218e:	cb89                	beqz	a5,802021a0 <kvmmake+0xb2>
            panic("kvmmake: data map failed");
    80202190:	00005517          	auipc	a0,0x5
    80202194:	d2850513          	addi	a0,a0,-728 # 80206eb8 <small_numbers+0xa68>
    80202198:	fffff097          	auipc	ra,0xfffff
    8020219c:	2c4080e7          	jalr	708(ra) # 8020145c <panic>
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    802021a0:	fe043703          	ld	a4,-32(s0)
    802021a4:	6785                	lui	a5,0x1
    802021a6:	97ba                	add	a5,a5,a4
    802021a8:	fef43023          	sd	a5,-32(s0)
    802021ac:	0000a797          	auipc	a5,0xa
    802021b0:	ba478793          	addi	a5,a5,-1116 # 8020bd50 <_bss_end>
    802021b4:	fe043703          	ld	a4,-32(s0)
    802021b8:	faf76fe3          	bltu	a4,a5,80202176 <kvmmake+0x88>
	uint64 aligned_end = ((uint64)end + PGSIZE - 1) & ~(PGSIZE - 1); // 向上对齐到页边界
    802021bc:	0000a717          	auipc	a4,0xa
    802021c0:	b9470713          	addi	a4,a4,-1132 # 8020bd50 <_bss_end>
    802021c4:	6785                	lui	a5,0x1
    802021c6:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    802021c8:	973e                	add	a4,a4,a5
    802021ca:	77fd                	lui	a5,0xfffff
    802021cc:	8ff9                	and	a5,a5,a4
    802021ce:	faf43823          	sd	a5,-80(s0)
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    802021d2:	fb043783          	ld	a5,-80(s0)
    802021d6:	fcf43c23          	sd	a5,-40(s0)
    802021da:	a825                	j	80202212 <kvmmake+0x124>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802021dc:	4699                	li	a3,6
    802021de:	fd843603          	ld	a2,-40(s0)
    802021e2:	fd843583          	ld	a1,-40(s0)
    802021e6:	fb843503          	ld	a0,-72(s0)
    802021ea:	00000097          	auipc	ra,0x0
    802021ee:	d70080e7          	jalr	-656(ra) # 80201f5a <map_page>
    802021f2:	87aa                	mv	a5,a0
    802021f4:	cb89                	beqz	a5,80202206 <kvmmake+0x118>
			panic("kvmmake: heap map failed");
    802021f6:	00005517          	auipc	a0,0x5
    802021fa:	ce250513          	addi	a0,a0,-798 # 80206ed8 <small_numbers+0xa88>
    802021fe:	fffff097          	auipc	ra,0xfffff
    80202202:	25e080e7          	jalr	606(ra) # 8020145c <panic>
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    80202206:	fd843703          	ld	a4,-40(s0)
    8020220a:	6785                	lui	a5,0x1
    8020220c:	97ba                	add	a5,a5,a4
    8020220e:	fcf43c23          	sd	a5,-40(s0)
    80202212:	fd843703          	ld	a4,-40(s0)
    80202216:	47c5                	li	a5,17
    80202218:	07ee                	slli	a5,a5,0x1b
    8020221a:	fcf761e3          	bltu	a4,a5,802021dc <kvmmake+0xee>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    8020221e:	4699                	li	a3,6
    80202220:	10000637          	lui	a2,0x10000
    80202224:	100005b7          	lui	a1,0x10000
    80202228:	fb843503          	ld	a0,-72(s0)
    8020222c:	00000097          	auipc	ra,0x0
    80202230:	d2e080e7          	jalr	-722(ra) # 80201f5a <map_page>
    80202234:	87aa                	mv	a5,a0
    80202236:	cb89                	beqz	a5,80202248 <kvmmake+0x15a>
        panic("kvmmake: uart map failed");
    80202238:	00005517          	auipc	a0,0x5
    8020223c:	cc050513          	addi	a0,a0,-832 # 80206ef8 <small_numbers+0xaa8>
    80202240:	fffff097          	auipc	ra,0xfffff
    80202244:	21c080e7          	jalr	540(ra) # 8020145c <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80202248:	0c0007b7          	lui	a5,0xc000
    8020224c:	fcf43823          	sd	a5,-48(s0)
    80202250:	a825                	j	80202288 <kvmmake+0x19a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202252:	4699                	li	a3,6
    80202254:	fd043603          	ld	a2,-48(s0)
    80202258:	fd043583          	ld	a1,-48(s0)
    8020225c:	fb843503          	ld	a0,-72(s0)
    80202260:	00000097          	auipc	ra,0x0
    80202264:	cfa080e7          	jalr	-774(ra) # 80201f5a <map_page>
    80202268:	87aa                	mv	a5,a0
    8020226a:	cb89                	beqz	a5,8020227c <kvmmake+0x18e>
            panic("kvmmake: plic map failed");
    8020226c:	00005517          	auipc	a0,0x5
    80202270:	cac50513          	addi	a0,a0,-852 # 80206f18 <small_numbers+0xac8>
    80202274:	fffff097          	auipc	ra,0xfffff
    80202278:	1e8080e7          	jalr	488(ra) # 8020145c <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    8020227c:	fd043703          	ld	a4,-48(s0)
    80202280:	6785                	lui	a5,0x1
    80202282:	97ba                	add	a5,a5,a4
    80202284:	fcf43823          	sd	a5,-48(s0)
    80202288:	fd043703          	ld	a4,-48(s0)
    8020228c:	0c4007b7          	lui	a5,0xc400
    80202290:	fcf761e3          	bltu	a4,a5,80202252 <kvmmake+0x164>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80202294:	020007b7          	lui	a5,0x2000
    80202298:	fcf43423          	sd	a5,-56(s0)
    8020229c:	a825                	j	802022d4 <kvmmake+0x1e6>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    8020229e:	4699                	li	a3,6
    802022a0:	fc843603          	ld	a2,-56(s0)
    802022a4:	fc843583          	ld	a1,-56(s0)
    802022a8:	fb843503          	ld	a0,-72(s0)
    802022ac:	00000097          	auipc	ra,0x0
    802022b0:	cae080e7          	jalr	-850(ra) # 80201f5a <map_page>
    802022b4:	87aa                	mv	a5,a0
    802022b6:	cb89                	beqz	a5,802022c8 <kvmmake+0x1da>
            panic("kvmmake: clint map failed");
    802022b8:	00005517          	auipc	a0,0x5
    802022bc:	c8050513          	addi	a0,a0,-896 # 80206f38 <small_numbers+0xae8>
    802022c0:	fffff097          	auipc	ra,0xfffff
    802022c4:	19c080e7          	jalr	412(ra) # 8020145c <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    802022c8:	fc843703          	ld	a4,-56(s0)
    802022cc:	6785                	lui	a5,0x1
    802022ce:	97ba                	add	a5,a5,a4
    802022d0:	fcf43423          	sd	a5,-56(s0)
    802022d4:	fc843703          	ld	a4,-56(s0)
    802022d8:	020107b7          	lui	a5,0x2010
    802022dc:	fcf761e3          	bltu	a4,a5,8020229e <kvmmake+0x1b0>
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    802022e0:	4699                	li	a3,6
    802022e2:	10001637          	lui	a2,0x10001
    802022e6:	100015b7          	lui	a1,0x10001
    802022ea:	fb843503          	ld	a0,-72(s0)
    802022ee:	00000097          	auipc	ra,0x0
    802022f2:	c6c080e7          	jalr	-916(ra) # 80201f5a <map_page>
    802022f6:	87aa                	mv	a5,a0
    802022f8:	cb89                	beqz	a5,8020230a <kvmmake+0x21c>
        panic("kvmmake: virtio map failed");
    802022fa:	00005517          	auipc	a0,0x5
    802022fe:	c5e50513          	addi	a0,a0,-930 # 80206f58 <small_numbers+0xb08>
    80202302:	fffff097          	auipc	ra,0xfffff
    80202306:	15a080e7          	jalr	346(ra) # 8020145c <panic>
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    8020230a:	fc043023          	sd	zero,-64(s0)
    8020230e:	a825                	j	80202346 <kvmmake+0x258>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202310:	4699                	li	a3,6
    80202312:	fc043603          	ld	a2,-64(s0)
    80202316:	fc043583          	ld	a1,-64(s0)
    8020231a:	fb843503          	ld	a0,-72(s0)
    8020231e:	00000097          	auipc	ra,0x0
    80202322:	c3c080e7          	jalr	-964(ra) # 80201f5a <map_page>
    80202326:	87aa                	mv	a5,a0
    80202328:	cb89                	beqz	a5,8020233a <kvmmake+0x24c>
			panic("kvmmake: low memory map failed");
    8020232a:	00005517          	auipc	a0,0x5
    8020232e:	c4e50513          	addi	a0,a0,-946 # 80206f78 <small_numbers+0xb28>
    80202332:	fffff097          	auipc	ra,0xfffff
    80202336:	12a080e7          	jalr	298(ra) # 8020145c <panic>
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    8020233a:	fc043703          	ld	a4,-64(s0)
    8020233e:	6785                	lui	a5,0x1
    80202340:	97ba                	add	a5,a5,a4
    80202342:	fcf43023          	sd	a5,-64(s0)
    80202346:	fc043703          	ld	a4,-64(s0)
    8020234a:	001007b7          	lui	a5,0x100
    8020234e:	fcf761e3          	bltu	a4,a5,80202310 <kvmmake+0x222>
	uint64 sbi_special = 0xfd02000;  // 页对齐
    80202352:	0fd027b7          	lui	a5,0xfd02
    80202356:	faf43423          	sd	a5,-88(s0)
	if (map_page(kpgtbl, sbi_special, sbi_special, PTE_R | PTE_W) != 0)
    8020235a:	4699                	li	a3,6
    8020235c:	fa843603          	ld	a2,-88(s0)
    80202360:	fa843583          	ld	a1,-88(s0)
    80202364:	fb843503          	ld	a0,-72(s0)
    80202368:	00000097          	auipc	ra,0x0
    8020236c:	bf2080e7          	jalr	-1038(ra) # 80201f5a <map_page>
    80202370:	87aa                	mv	a5,a0
    80202372:	cb89                	beqz	a5,80202384 <kvmmake+0x296>
		panic("kvmmake: sbi special area map failed");
    80202374:	00005517          	auipc	a0,0x5
    80202378:	c2450513          	addi	a0,a0,-988 # 80206f98 <small_numbers+0xb48>
    8020237c:	fffff097          	auipc	ra,0xfffff
    80202380:	0e0080e7          	jalr	224(ra) # 8020145c <panic>
    return kpgtbl;
    80202384:	fb843783          	ld	a5,-72(s0)
}
    80202388:	853e                	mv	a0,a5
    8020238a:	60e6                	ld	ra,88(sp)
    8020238c:	6446                	ld	s0,80(sp)
    8020238e:	6125                	addi	sp,sp,96
    80202390:	8082                	ret

0000000080202392 <kvminit>:
void kvminit(void) {
    80202392:	1141                	addi	sp,sp,-16
    80202394:	e406                	sd	ra,8(sp)
    80202396:	e022                	sd	s0,0(sp)
    80202398:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    8020239a:	00000097          	auipc	ra,0x0
    8020239e:	d54080e7          	jalr	-684(ra) # 802020ee <kvmmake>
    802023a2:	872a                	mv	a4,a0
    802023a4:	00008797          	auipc	a5,0x8
    802023a8:	cdc78793          	addi	a5,a5,-804 # 8020a080 <kernel_pagetable>
    802023ac:	e398                	sd	a4,0(a5)
}
    802023ae:	0001                	nop
    802023b0:	60a2                	ld	ra,8(sp)
    802023b2:	6402                	ld	s0,0(sp)
    802023b4:	0141                	addi	sp,sp,16
    802023b6:	8082                	ret

00000000802023b8 <w_satp>:
static inline void w_satp(uint64 x) {
    802023b8:	1101                	addi	sp,sp,-32
    802023ba:	ec22                	sd	s0,24(sp)
    802023bc:	1000                	addi	s0,sp,32
    802023be:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    802023c2:	fe843783          	ld	a5,-24(s0)
    802023c6:	18079073          	csrw	satp,a5
}
    802023ca:	0001                	nop
    802023cc:	6462                	ld	s0,24(sp)
    802023ce:	6105                	addi	sp,sp,32
    802023d0:	8082                	ret

00000000802023d2 <sfence_vma>:
inline void sfence_vma(void) {
    802023d2:	1141                	addi	sp,sp,-16
    802023d4:	e422                	sd	s0,8(sp)
    802023d6:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    802023d8:	12000073          	sfence.vma
}
    802023dc:	0001                	nop
    802023de:	6422                	ld	s0,8(sp)
    802023e0:	0141                	addi	sp,sp,16
    802023e2:	8082                	ret

00000000802023e4 <kvminithart>:
void kvminithart(void) {
    802023e4:	1141                	addi	sp,sp,-16
    802023e6:	e406                	sd	ra,8(sp)
    802023e8:	e022                	sd	s0,0(sp)
    802023ea:	0800                	addi	s0,sp,16
    sfence_vma();
    802023ec:	00000097          	auipc	ra,0x0
    802023f0:	fe6080e7          	jalr	-26(ra) # 802023d2 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    802023f4:	00008797          	auipc	a5,0x8
    802023f8:	c8c78793          	addi	a5,a5,-884 # 8020a080 <kernel_pagetable>
    802023fc:	639c                	ld	a5,0(a5)
    802023fe:	00c7d713          	srli	a4,a5,0xc
    80202402:	57fd                	li	a5,-1
    80202404:	17fe                	slli	a5,a5,0x3f
    80202406:	8fd9                	or	a5,a5,a4
    80202408:	853e                	mv	a0,a5
    8020240a:	00000097          	auipc	ra,0x0
    8020240e:	fae080e7          	jalr	-82(ra) # 802023b8 <w_satp>
    sfence_vma();
    80202412:	00000097          	auipc	ra,0x0
    80202416:	fc0080e7          	jalr	-64(ra) # 802023d2 <sfence_vma>
	printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
    8020241a:	00008797          	auipc	a5,0x8
    8020241e:	c6678793          	addi	a5,a5,-922 # 8020a080 <kernel_pagetable>
    80202422:	639c                	ld	a5,0(a5)
    80202424:	00c7d713          	srli	a4,a5,0xc
    80202428:	57fd                	li	a5,-1
    8020242a:	17fe                	slli	a5,a5,0x3f
    8020242c:	8fd9                	or	a5,a5,a4
    8020242e:	85be                	mv	a1,a5
    80202430:	00005517          	auipc	a0,0x5
    80202434:	b9050513          	addi	a0,a0,-1136 # 80206fc0 <small_numbers+0xb70>
    80202438:	ffffe097          	auipc	ra,0xffffe
    8020243c:	71c080e7          	jalr	1820(ra) # 80200b54 <printf>
}
    80202440:	0001                	nop
    80202442:	60a2                	ld	ra,8(sp)
    80202444:	6402                	ld	s0,0(sp)
    80202446:	0141                	addi	sp,sp,16
    80202448:	8082                	ret

000000008020244a <get_current_pagetable>:
pagetable_t get_current_pagetable(void) {
    8020244a:	1141                	addi	sp,sp,-16
    8020244c:	e422                	sd	s0,8(sp)
    8020244e:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    80202450:	00008797          	auipc	a5,0x8
    80202454:	c3078793          	addi	a5,a5,-976 # 8020a080 <kernel_pagetable>
    80202458:	639c                	ld	a5,0(a5)
}
    8020245a:	853e                	mv	a0,a5
    8020245c:	6422                	ld	s0,8(sp)
    8020245e:	0141                	addi	sp,sp,16
    80202460:	8082                	ret

0000000080202462 <handle_page_fault>:
int handle_page_fault(uint64 va, int type) {
    80202462:	7139                	addi	sp,sp,-64
    80202464:	fc06                	sd	ra,56(sp)
    80202466:	f822                	sd	s0,48(sp)
    80202468:	0080                	addi	s0,sp,64
    8020246a:	fca43423          	sd	a0,-56(s0)
    8020246e:	87ae                	mv	a5,a1
    80202470:	fcf42223          	sw	a5,-60(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    80202474:	fc442783          	lw	a5,-60(s0)
    80202478:	863e                	mv	a2,a5
    8020247a:	fc843583          	ld	a1,-56(s0)
    8020247e:	00005517          	auipc	a0,0x5
    80202482:	b7250513          	addi	a0,a0,-1166 # 80206ff0 <small_numbers+0xba0>
    80202486:	ffffe097          	auipc	ra,0xffffe
    8020248a:	6ce080e7          	jalr	1742(ra) # 80200b54 <printf>
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    8020248e:	fc843703          	ld	a4,-56(s0)
    80202492:	77fd                	lui	a5,0xfffff
    80202494:	8ff9                	and	a5,a5,a4
    80202496:	fef43023          	sd	a5,-32(s0)
    if (page_va >= MAXVA) {
    8020249a:	fe043703          	ld	a4,-32(s0)
    8020249e:	57fd                	li	a5,-1
    802024a0:	83e5                	srli	a5,a5,0x19
    802024a2:	00e7fc63          	bgeu	a5,a4,802024ba <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    802024a6:	00005517          	auipc	a0,0x5
    802024aa:	b7a50513          	addi	a0,a0,-1158 # 80207020 <small_numbers+0xbd0>
    802024ae:	ffffe097          	auipc	ra,0xffffe
    802024b2:	6a6080e7          	jalr	1702(ra) # 80200b54 <printf>
        return 0; // 地址超出最大虚拟地址空间
    802024b6:	4781                	li	a5,0
    802024b8:	a275                	j	80202664 <handle_page_fault+0x202>
    pte_t *pte = walk_lookup(kernel_pagetable, page_va);
    802024ba:	00008797          	auipc	a5,0x8
    802024be:	bc678793          	addi	a5,a5,-1082 # 8020a080 <kernel_pagetable>
    802024c2:	639c                	ld	a5,0(a5)
    802024c4:	fe043583          	ld	a1,-32(s0)
    802024c8:	853e                	mv	a0,a5
    802024ca:	00000097          	auipc	ra,0x0
    802024ce:	904080e7          	jalr	-1788(ra) # 80201dce <walk_lookup>
    802024d2:	fca43c23          	sd	a0,-40(s0)
    if (pte && (*pte & PTE_V)) {
    802024d6:	fd843783          	ld	a5,-40(s0)
    802024da:	c3dd                	beqz	a5,80202580 <handle_page_fault+0x11e>
    802024dc:	fd843783          	ld	a5,-40(s0)
    802024e0:	639c                	ld	a5,0(a5)
    802024e2:	8b85                	andi	a5,a5,1
    802024e4:	cfd1                	beqz	a5,80202580 <handle_page_fault+0x11e>
        int need_perm = 0;
    802024e6:	fe042623          	sw	zero,-20(s0)
        if (type == 1) need_perm = PTE_X;
    802024ea:	fc442783          	lw	a5,-60(s0)
    802024ee:	0007871b          	sext.w	a4,a5
    802024f2:	4785                	li	a5,1
    802024f4:	00f71663          	bne	a4,a5,80202500 <handle_page_fault+0x9e>
    802024f8:	47a1                	li	a5,8
    802024fa:	fef42623          	sw	a5,-20(s0)
    802024fe:	a035                	j	8020252a <handle_page_fault+0xc8>
        else if (type == 2) need_perm = PTE_R;
    80202500:	fc442783          	lw	a5,-60(s0)
    80202504:	0007871b          	sext.w	a4,a5
    80202508:	4789                	li	a5,2
    8020250a:	00f71663          	bne	a4,a5,80202516 <handle_page_fault+0xb4>
    8020250e:	4789                	li	a5,2
    80202510:	fef42623          	sw	a5,-20(s0)
    80202514:	a819                	j	8020252a <handle_page_fault+0xc8>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    80202516:	fc442783          	lw	a5,-60(s0)
    8020251a:	0007871b          	sext.w	a4,a5
    8020251e:	478d                	li	a5,3
    80202520:	00f71563          	bne	a4,a5,8020252a <handle_page_fault+0xc8>
    80202524:	4799                	li	a5,6
    80202526:	fef42623          	sw	a5,-20(s0)
        if ((*pte & need_perm) != need_perm) {
    8020252a:	fd843783          	ld	a5,-40(s0)
    8020252e:	6398                	ld	a4,0(a5)
    80202530:	fec42783          	lw	a5,-20(s0)
    80202534:	8f7d                	and	a4,a4,a5
    80202536:	fec42783          	lw	a5,-20(s0)
    8020253a:	02f70963          	beq	a4,a5,8020256c <handle_page_fault+0x10a>
            *pte |= need_perm;
    8020253e:	fd843783          	ld	a5,-40(s0)
    80202542:	6398                	ld	a4,0(a5)
    80202544:	fec42783          	lw	a5,-20(s0)
    80202548:	8f5d                	or	a4,a4,a5
    8020254a:	fd843783          	ld	a5,-40(s0)
    8020254e:	e398                	sd	a4,0(a5)
            sfence_vma();
    80202550:	00000097          	auipc	ra,0x0
    80202554:	e82080e7          	jalr	-382(ra) # 802023d2 <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    80202558:	00005517          	auipc	a0,0x5
    8020255c:	af050513          	addi	a0,a0,-1296 # 80207048 <small_numbers+0xbf8>
    80202560:	ffffe097          	auipc	ra,0xffffe
    80202564:	5f4080e7          	jalr	1524(ra) # 80200b54 <printf>
            return 1;
    80202568:	4785                	li	a5,1
    8020256a:	a8ed                	j	80202664 <handle_page_fault+0x202>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    8020256c:	00005517          	auipc	a0,0x5
    80202570:	b0450513          	addi	a0,a0,-1276 # 80207070 <small_numbers+0xc20>
    80202574:	ffffe097          	auipc	ra,0xffffe
    80202578:	5e0080e7          	jalr	1504(ra) # 80200b54 <printf>
        return 1;
    8020257c:	4785                	li	a5,1
    8020257e:	a0dd                	j	80202664 <handle_page_fault+0x202>
    void* page = alloc_page();
    80202580:	00000097          	auipc	ra,0x0
    80202584:	530080e7          	jalr	1328(ra) # 80202ab0 <alloc_page>
    80202588:	fca43823          	sd	a0,-48(s0)
    if (page == 0) {
    8020258c:	fd043783          	ld	a5,-48(s0)
    80202590:	eb99                	bnez	a5,802025a6 <handle_page_fault+0x144>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    80202592:	00005517          	auipc	a0,0x5
    80202596:	b0e50513          	addi	a0,a0,-1266 # 802070a0 <small_numbers+0xc50>
    8020259a:	ffffe097          	auipc	ra,0xffffe
    8020259e:	5ba080e7          	jalr	1466(ra) # 80200b54 <printf>
        return 0; // 内存不足
    802025a2:	4781                	li	a5,0
    802025a4:	a0c1                	j	80202664 <handle_page_fault+0x202>
    memset(page, 0, PGSIZE);
    802025a6:	6605                	lui	a2,0x1
    802025a8:	4581                	li	a1,0
    802025aa:	fd043503          	ld	a0,-48(s0)
    802025ae:	fffff097          	auipc	ra,0xfffff
    802025b2:	5ec080e7          	jalr	1516(ra) # 80201b9a <memset>
    int perm = 0;
    802025b6:	fe042423          	sw	zero,-24(s0)
    if (type == 1) {  // 指令页
    802025ba:	fc442783          	lw	a5,-60(s0)
    802025be:	0007871b          	sext.w	a4,a5
    802025c2:	4785                	li	a5,1
    802025c4:	00f71663          	bne	a4,a5,802025d0 <handle_page_fault+0x16e>
        perm = PTE_X | PTE_R;  // 可执行页通常也需要可读
    802025c8:	47a9                	li	a5,10
    802025ca:	fef42423          	sw	a5,-24(s0)
    802025ce:	a035                	j	802025fa <handle_page_fault+0x198>
    } else if (type == 2) {  // 读数据页
    802025d0:	fc442783          	lw	a5,-60(s0)
    802025d4:	0007871b          	sext.w	a4,a5
    802025d8:	4789                	li	a5,2
    802025da:	00f71663          	bne	a4,a5,802025e6 <handle_page_fault+0x184>
        perm = PTE_R;
    802025de:	4789                	li	a5,2
    802025e0:	fef42423          	sw	a5,-24(s0)
    802025e4:	a819                	j	802025fa <handle_page_fault+0x198>
    } else if (type == 3) {  // 写数据页
    802025e6:	fc442783          	lw	a5,-60(s0)
    802025ea:	0007871b          	sext.w	a4,a5
    802025ee:	478d                	li	a5,3
    802025f0:	00f71563          	bne	a4,a5,802025fa <handle_page_fault+0x198>
        perm = PTE_R | PTE_W;
    802025f4:	4799                	li	a5,6
    802025f6:	fef42423          	sw	a5,-24(s0)
    if (map_page(kernel_pagetable, page_va, (uint64)page, perm) != 0) {
    802025fa:	00008797          	auipc	a5,0x8
    802025fe:	a8678793          	addi	a5,a5,-1402 # 8020a080 <kernel_pagetable>
    80202602:	639c                	ld	a5,0(a5)
    80202604:	fd043703          	ld	a4,-48(s0)
    80202608:	fe842683          	lw	a3,-24(s0)
    8020260c:	863a                	mv	a2,a4
    8020260e:	fe043583          	ld	a1,-32(s0)
    80202612:	853e                	mv	a0,a5
    80202614:	00000097          	auipc	ra,0x0
    80202618:	946080e7          	jalr	-1722(ra) # 80201f5a <map_page>
    8020261c:	87aa                	mv	a5,a0
    8020261e:	c38d                	beqz	a5,80202640 <handle_page_fault+0x1de>
        free_page(page);
    80202620:	fd043503          	ld	a0,-48(s0)
    80202624:	00000097          	auipc	ra,0x0
    80202628:	4f8080e7          	jalr	1272(ra) # 80202b1c <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    8020262c:	00005517          	auipc	a0,0x5
    80202630:	aa450513          	addi	a0,a0,-1372 # 802070d0 <small_numbers+0xc80>
    80202634:	ffffe097          	auipc	ra,0xffffe
    80202638:	520080e7          	jalr	1312(ra) # 80200b54 <printf>
        return 0; // 映射失败
    8020263c:	4781                	li	a5,0
    8020263e:	a01d                	j	80202664 <handle_page_fault+0x202>
    sfence_vma();
    80202640:	00000097          	auipc	ra,0x0
    80202644:	d92080e7          	jalr	-622(ra) # 802023d2 <sfence_vma>
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    80202648:	fd043783          	ld	a5,-48(s0)
    8020264c:	863e                	mv	a2,a5
    8020264e:	fe043583          	ld	a1,-32(s0)
    80202652:	00005517          	auipc	a0,0x5
    80202656:	aa650513          	addi	a0,a0,-1370 # 802070f8 <small_numbers+0xca8>
    8020265a:	ffffe097          	auipc	ra,0xffffe
    8020265e:	4fa080e7          	jalr	1274(ra) # 80200b54 <printf>
    return 1; // 处理成功
    80202662:	4785                	li	a5,1
}
    80202664:	853e                	mv	a0,a5
    80202666:	70e2                	ld	ra,56(sp)
    80202668:	7442                	ld	s0,48(sp)
    8020266a:	6121                	addi	sp,sp,64
    8020266c:	8082                	ret

000000008020266e <test_pagetable>:
void test_pagetable(void) {
    8020266e:	7179                	addi	sp,sp,-48
    80202670:	f406                	sd	ra,40(sp)
    80202672:	f022                	sd	s0,32(sp)
    80202674:	1800                	addi	s0,sp,48
    printf("[PT TEST] 创建页表...\n");
    80202676:	00005517          	auipc	a0,0x5
    8020267a:	ac250513          	addi	a0,a0,-1342 # 80207138 <small_numbers+0xce8>
    8020267e:	ffffe097          	auipc	ra,0xffffe
    80202682:	4d6080e7          	jalr	1238(ra) # 80200b54 <printf>
    pagetable_t pt = create_pagetable();
    80202686:	fffff097          	auipc	ra,0xfffff
    8020268a:	70c080e7          	jalr	1804(ra) # 80201d92 <create_pagetable>
    8020268e:	fea43423          	sd	a0,-24(s0)
    assert(pt != 0);
    80202692:	fe843783          	ld	a5,-24(s0)
    80202696:	00f037b3          	snez	a5,a5
    8020269a:	0ff7f793          	zext.b	a5,a5
    8020269e:	2781                	sext.w	a5,a5
    802026a0:	853e                	mv	a0,a5
    802026a2:	fffff097          	auipc	ra,0xfffff
    802026a6:	66a080e7          	jalr	1642(ra) # 80201d0c <assert>
    printf("[PT TEST] 页表创建通过\n");
    802026aa:	00005517          	auipc	a0,0x5
    802026ae:	aae50513          	addi	a0,a0,-1362 # 80207158 <small_numbers+0xd08>
    802026b2:	ffffe097          	auipc	ra,0xffffe
    802026b6:	4a2080e7          	jalr	1186(ra) # 80200b54 <printf>
    uint64 va = 0x1000000;
    802026ba:	010007b7          	lui	a5,0x1000
    802026be:	fef43023          	sd	a5,-32(s0)
    uint64 pa = (uint64)alloc_page();
    802026c2:	00000097          	auipc	ra,0x0
    802026c6:	3ee080e7          	jalr	1006(ra) # 80202ab0 <alloc_page>
    802026ca:	87aa                	mv	a5,a0
    802026cc:	fcf43c23          	sd	a5,-40(s0)
    assert(pa != 0);
    802026d0:	fd843783          	ld	a5,-40(s0)
    802026d4:	00f037b3          	snez	a5,a5
    802026d8:	0ff7f793          	zext.b	a5,a5
    802026dc:	2781                	sext.w	a5,a5
    802026de:	853e                	mv	a0,a5
    802026e0:	fffff097          	auipc	ra,0xfffff
    802026e4:	62c080e7          	jalr	1580(ra) # 80201d0c <assert>
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0);
    802026e8:	4699                	li	a3,6
    802026ea:	fd843603          	ld	a2,-40(s0)
    802026ee:	fe043583          	ld	a1,-32(s0)
    802026f2:	fe843503          	ld	a0,-24(s0)
    802026f6:	00000097          	auipc	ra,0x0
    802026fa:	864080e7          	jalr	-1948(ra) # 80201f5a <map_page>
    802026fe:	87aa                	mv	a5,a0
    80202700:	0017b793          	seqz	a5,a5
    80202704:	0ff7f793          	zext.b	a5,a5
    80202708:	2781                	sext.w	a5,a5
    8020270a:	853e                	mv	a0,a5
    8020270c:	fffff097          	auipc	ra,0xfffff
    80202710:	600080e7          	jalr	1536(ra) # 80201d0c <assert>
    printf("[PT TEST] 映射测试通过\n");
    80202714:	00005517          	auipc	a0,0x5
    80202718:	a6450513          	addi	a0,a0,-1436 # 80207178 <small_numbers+0xd28>
    8020271c:	ffffe097          	auipc	ra,0xffffe
    80202720:	438080e7          	jalr	1080(ra) # 80200b54 <printf>
    pte_t *pte = walk_lookup(pt, va);
    80202724:	fe043583          	ld	a1,-32(s0)
    80202728:	fe843503          	ld	a0,-24(s0)
    8020272c:	fffff097          	auipc	ra,0xfffff
    80202730:	6a2080e7          	jalr	1698(ra) # 80201dce <walk_lookup>
    80202734:	fca43823          	sd	a0,-48(s0)
    assert(pte != 0 && (*pte & PTE_V));
    80202738:	fd043783          	ld	a5,-48(s0)
    8020273c:	cb81                	beqz	a5,8020274c <test_pagetable+0xde>
    8020273e:	fd043783          	ld	a5,-48(s0)
    80202742:	639c                	ld	a5,0(a5)
    80202744:	8b85                	andi	a5,a5,1
    80202746:	c399                	beqz	a5,8020274c <test_pagetable+0xde>
    80202748:	4785                	li	a5,1
    8020274a:	a011                	j	8020274e <test_pagetable+0xe0>
    8020274c:	4781                	li	a5,0
    8020274e:	853e                	mv	a0,a5
    80202750:	fffff097          	auipc	ra,0xfffff
    80202754:	5bc080e7          	jalr	1468(ra) # 80201d0c <assert>
    assert(PTE2PA(*pte) == pa);
    80202758:	fd043783          	ld	a5,-48(s0)
    8020275c:	639c                	ld	a5,0(a5)
    8020275e:	83a9                	srli	a5,a5,0xa
    80202760:	07b2                	slli	a5,a5,0xc
    80202762:	fd843703          	ld	a4,-40(s0)
    80202766:	40f707b3          	sub	a5,a4,a5
    8020276a:	0017b793          	seqz	a5,a5
    8020276e:	0ff7f793          	zext.b	a5,a5
    80202772:	2781                	sext.w	a5,a5
    80202774:	853e                	mv	a0,a5
    80202776:	fffff097          	auipc	ra,0xfffff
    8020277a:	596080e7          	jalr	1430(ra) # 80201d0c <assert>
    printf("[PT TEST] 地址转换测试通过\n");
    8020277e:	00005517          	auipc	a0,0x5
    80202782:	a1a50513          	addi	a0,a0,-1510 # 80207198 <small_numbers+0xd48>
    80202786:	ffffe097          	auipc	ra,0xffffe
    8020278a:	3ce080e7          	jalr	974(ra) # 80200b54 <printf>
    assert(*pte & PTE_R);
    8020278e:	fd043783          	ld	a5,-48(s0)
    80202792:	639c                	ld	a5,0(a5)
    80202794:	2781                	sext.w	a5,a5
    80202796:	8b89                	andi	a5,a5,2
    80202798:	2781                	sext.w	a5,a5
    8020279a:	853e                	mv	a0,a5
    8020279c:	fffff097          	auipc	ra,0xfffff
    802027a0:	570080e7          	jalr	1392(ra) # 80201d0c <assert>
    assert(*pte & PTE_W);
    802027a4:	fd043783          	ld	a5,-48(s0)
    802027a8:	639c                	ld	a5,0(a5)
    802027aa:	2781                	sext.w	a5,a5
    802027ac:	8b91                	andi	a5,a5,4
    802027ae:	2781                	sext.w	a5,a5
    802027b0:	853e                	mv	a0,a5
    802027b2:	fffff097          	auipc	ra,0xfffff
    802027b6:	55a080e7          	jalr	1370(ra) # 80201d0c <assert>
    assert(!(*pte & PTE_X));
    802027ba:	fd043783          	ld	a5,-48(s0)
    802027be:	639c                	ld	a5,0(a5)
    802027c0:	8ba1                	andi	a5,a5,8
    802027c2:	0017b793          	seqz	a5,a5
    802027c6:	0ff7f793          	zext.b	a5,a5
    802027ca:	2781                	sext.w	a5,a5
    802027cc:	853e                	mv	a0,a5
    802027ce:	fffff097          	auipc	ra,0xfffff
    802027d2:	53e080e7          	jalr	1342(ra) # 80201d0c <assert>
    printf("[PT TEST] 权限测试通过\n");
    802027d6:	00005517          	auipc	a0,0x5
    802027da:	9ea50513          	addi	a0,a0,-1558 # 802071c0 <small_numbers+0xd70>
    802027de:	ffffe097          	auipc	ra,0xffffe
    802027e2:	376080e7          	jalr	886(ra) # 80200b54 <printf>
    free_page((void*)pa);
    802027e6:	fd843783          	ld	a5,-40(s0)
    802027ea:	853e                	mv	a0,a5
    802027ec:	00000097          	auipc	ra,0x0
    802027f0:	330080e7          	jalr	816(ra) # 80202b1c <free_page>
    free_pagetable(pt);
    802027f4:	fe843503          	ld	a0,-24(s0)
    802027f8:	00000097          	auipc	ra,0x0
    802027fc:	848080e7          	jalr	-1976(ra) # 80202040 <free_pagetable>
    printf("[PT TEST] 所有页表测试通过\n");
    80202800:	00005517          	auipc	a0,0x5
    80202804:	9e050513          	addi	a0,a0,-1568 # 802071e0 <small_numbers+0xd90>
    80202808:	ffffe097          	auipc	ra,0xffffe
    8020280c:	34c080e7          	jalr	844(ra) # 80200b54 <printf>
}
    80202810:	0001                	nop
    80202812:	70a2                	ld	ra,40(sp)
    80202814:	7402                	ld	s0,32(sp)
    80202816:	6145                	addi	sp,sp,48
    80202818:	8082                	ret

000000008020281a <check_mapping>:
void check_mapping(uint64 va) {
    8020281a:	7179                	addi	sp,sp,-48
    8020281c:	f406                	sd	ra,40(sp)
    8020281e:	f022                	sd	s0,32(sp)
    80202820:	1800                	addi	s0,sp,48
    80202822:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    80202826:	00008797          	auipc	a5,0x8
    8020282a:	85a78793          	addi	a5,a5,-1958 # 8020a080 <kernel_pagetable>
    8020282e:	639c                	ld	a5,0(a5)
    80202830:	fd843583          	ld	a1,-40(s0)
    80202834:	853e                	mv	a0,a5
    80202836:	fffff097          	auipc	ra,0xfffff
    8020283a:	598080e7          	jalr	1432(ra) # 80201dce <walk_lookup>
    8020283e:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    80202842:	fe843783          	ld	a5,-24(s0)
    80202846:	c78d                	beqz	a5,80202870 <check_mapping+0x56>
    80202848:	fe843783          	ld	a5,-24(s0)
    8020284c:	639c                	ld	a5,0(a5)
    8020284e:	8b85                	andi	a5,a5,1
    80202850:	c385                	beqz	a5,80202870 <check_mapping+0x56>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80202852:	fe843783          	ld	a5,-24(s0)
    80202856:	639c                	ld	a5,0(a5)
    80202858:	863e                	mv	a2,a5
    8020285a:	fd843583          	ld	a1,-40(s0)
    8020285e:	00005517          	auipc	a0,0x5
    80202862:	9aa50513          	addi	a0,a0,-1622 # 80207208 <small_numbers+0xdb8>
    80202866:	ffffe097          	auipc	ra,0xffffe
    8020286a:	2ee080e7          	jalr	750(ra) # 80200b54 <printf>
    8020286e:	a821                	j	80202886 <check_mapping+0x6c>
        printf("Address 0x%lx is NOT mapped\n", va);
    80202870:	fd843583          	ld	a1,-40(s0)
    80202874:	00005517          	auipc	a0,0x5
    80202878:	9bc50513          	addi	a0,a0,-1604 # 80207230 <small_numbers+0xde0>
    8020287c:	ffffe097          	auipc	ra,0xffffe
    80202880:	2d8080e7          	jalr	728(ra) # 80200b54 <printf>
}
    80202884:	0001                	nop
    80202886:	0001                	nop
    80202888:	70a2                	ld	ra,40(sp)
    8020288a:	7402                	ld	s0,32(sp)
    8020288c:	6145                	addi	sp,sp,48
    8020288e:	8082                	ret

0000000080202890 <check_is_mapped>:
int check_is_mapped(uint64 va) {
    80202890:	7179                	addi	sp,sp,-48
    80202892:	f406                	sd	ra,40(sp)
    80202894:	f022                	sd	s0,32(sp)
    80202896:	1800                	addi	s0,sp,48
    80202898:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    8020289c:	00000097          	auipc	ra,0x0
    802028a0:	bae080e7          	jalr	-1106(ra) # 8020244a <get_current_pagetable>
    802028a4:	87aa                	mv	a5,a0
    802028a6:	fd843583          	ld	a1,-40(s0)
    802028aa:	853e                	mv	a0,a5
    802028ac:	fffff097          	auipc	ra,0xfffff
    802028b0:	522080e7          	jalr	1314(ra) # 80201dce <walk_lookup>
    802028b4:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    802028b8:	fe843783          	ld	a5,-24(s0)
    802028bc:	c795                	beqz	a5,802028e8 <check_is_mapped+0x58>
    802028be:	fe843783          	ld	a5,-24(s0)
    802028c2:	639c                	ld	a5,0(a5)
    802028c4:	8b85                	andi	a5,a5,1
    802028c6:	c38d                	beqz	a5,802028e8 <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    802028c8:	fe843783          	ld	a5,-24(s0)
    802028cc:	639c                	ld	a5,0(a5)
    802028ce:	863e                	mv	a2,a5
    802028d0:	fd843583          	ld	a1,-40(s0)
    802028d4:	00005517          	auipc	a0,0x5
    802028d8:	93450513          	addi	a0,a0,-1740 # 80207208 <small_numbers+0xdb8>
    802028dc:	ffffe097          	auipc	ra,0xffffe
    802028e0:	278080e7          	jalr	632(ra) # 80200b54 <printf>
        return 1;
    802028e4:	4785                	li	a5,1
    802028e6:	a821                	j	802028fe <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    802028e8:	fd843583          	ld	a1,-40(s0)
    802028ec:	00005517          	auipc	a0,0x5
    802028f0:	94450513          	addi	a0,a0,-1724 # 80207230 <small_numbers+0xde0>
    802028f4:	ffffe097          	auipc	ra,0xffffe
    802028f8:	260080e7          	jalr	608(ra) # 80200b54 <printf>
        return 0;
    802028fc:	4781                	li	a5,0
}
    802028fe:	853e                	mv	a0,a5
    80202900:	70a2                	ld	ra,40(sp)
    80202902:	7402                	ld	s0,32(sp)
    80202904:	6145                	addi	sp,sp,48
    80202906:	8082                	ret

0000000080202908 <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80202908:	711d                	addi	sp,sp,-96
    8020290a:	ec86                	sd	ra,88(sp)
    8020290c:	e8a2                	sd	s0,80(sp)
    8020290e:	1080                	addi	s0,sp,96
    80202910:	faa43c23          	sd	a0,-72(s0)
    80202914:	fab43823          	sd	a1,-80(s0)
    80202918:	fac43423          	sd	a2,-88(s0)
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    8020291c:	fe043423          	sd	zero,-24(s0)
    80202920:	a075                	j	802029cc <uvmcopy+0xc4>
        pte_t *pte = walk_lookup(old, i);
    80202922:	fe843583          	ld	a1,-24(s0)
    80202926:	fb843503          	ld	a0,-72(s0)
    8020292a:	fffff097          	auipc	ra,0xfffff
    8020292e:	4a4080e7          	jalr	1188(ra) # 80201dce <walk_lookup>
    80202932:	fea43023          	sd	a0,-32(s0)
        if (pte == 0 || (*pte & PTE_V) == 0)
    80202936:	fe043783          	ld	a5,-32(s0)
    8020293a:	c3d1                	beqz	a5,802029be <uvmcopy+0xb6>
    8020293c:	fe043783          	ld	a5,-32(s0)
    80202940:	639c                	ld	a5,0(a5)
    80202942:	8b85                	andi	a5,a5,1
    80202944:	cfad                	beqz	a5,802029be <uvmcopy+0xb6>
        uint64 pa = PTE2PA(*pte);
    80202946:	fe043783          	ld	a5,-32(s0)
    8020294a:	639c                	ld	a5,0(a5)
    8020294c:	83a9                	srli	a5,a5,0xa
    8020294e:	07b2                	slli	a5,a5,0xc
    80202950:	fcf43c23          	sd	a5,-40(s0)
        int flags = PTE_FLAGS(*pte);
    80202954:	fe043783          	ld	a5,-32(s0)
    80202958:	639c                	ld	a5,0(a5)
    8020295a:	2781                	sext.w	a5,a5
    8020295c:	3ff7f793          	andi	a5,a5,1023
    80202960:	fcf42a23          	sw	a5,-44(s0)
        void *mem = alloc_page();
    80202964:	00000097          	auipc	ra,0x0
    80202968:	14c080e7          	jalr	332(ra) # 80202ab0 <alloc_page>
    8020296c:	fca43423          	sd	a0,-56(s0)
        if (mem == 0)
    80202970:	fc843783          	ld	a5,-56(s0)
    80202974:	e399                	bnez	a5,8020297a <uvmcopy+0x72>
            return -1; // 分配失败
    80202976:	57fd                	li	a5,-1
    80202978:	a08d                	j	802029da <uvmcopy+0xd2>
        memmove(mem, (void*)pa, PGSIZE);
    8020297a:	fd843783          	ld	a5,-40(s0)
    8020297e:	6605                	lui	a2,0x1
    80202980:	85be                	mv	a1,a5
    80202982:	fc843503          	ld	a0,-56(s0)
    80202986:	fffff097          	auipc	ra,0xfffff
    8020298a:	264080e7          	jalr	612(ra) # 80201bea <memmove>
        if (map_page(new, i, (uint64)mem, flags) != 0) {
    8020298e:	fc843783          	ld	a5,-56(s0)
    80202992:	fd442703          	lw	a4,-44(s0)
    80202996:	86ba                	mv	a3,a4
    80202998:	863e                	mv	a2,a5
    8020299a:	fe843583          	ld	a1,-24(s0)
    8020299e:	fb043503          	ld	a0,-80(s0)
    802029a2:	fffff097          	auipc	ra,0xfffff
    802029a6:	5b8080e7          	jalr	1464(ra) # 80201f5a <map_page>
    802029aa:	87aa                	mv	a5,a0
    802029ac:	cb91                	beqz	a5,802029c0 <uvmcopy+0xb8>
            free_page(mem);
    802029ae:	fc843503          	ld	a0,-56(s0)
    802029b2:	00000097          	auipc	ra,0x0
    802029b6:	16a080e7          	jalr	362(ra) # 80202b1c <free_page>
            return -1;
    802029ba:	57fd                	li	a5,-1
    802029bc:	a839                	j	802029da <uvmcopy+0xd2>
            continue; // 跳过未分配的页
    802029be:	0001                	nop
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    802029c0:	fe843703          	ld	a4,-24(s0)
    802029c4:	6785                	lui	a5,0x1
    802029c6:	97ba                	add	a5,a5,a4
    802029c8:	fef43423          	sd	a5,-24(s0)
    802029cc:	fe843703          	ld	a4,-24(s0)
    802029d0:	fa843783          	ld	a5,-88(s0)
    802029d4:	f4f767e3          	bltu	a4,a5,80202922 <uvmcopy+0x1a>
    return 0;
    802029d8:	4781                	li	a5,0
    802029da:	853e                	mv	a0,a5
    802029dc:	60e6                	ld	ra,88(sp)
    802029de:	6446                	ld	s0,80(sp)
    802029e0:	6125                	addi	sp,sp,96
    802029e2:	8082                	ret

00000000802029e4 <assert>:
    802029e4:	1101                	addi	sp,sp,-32
    802029e6:	ec06                	sd	ra,24(sp)
    802029e8:	e822                	sd	s0,16(sp)
    802029ea:	1000                	addi	s0,sp,32
    802029ec:	87aa                	mv	a5,a0
    802029ee:	fef42623          	sw	a5,-20(s0)
    802029f2:	fec42783          	lw	a5,-20(s0)
    802029f6:	2781                	sext.w	a5,a5
    802029f8:	e79d                	bnez	a5,80202a26 <assert+0x42>
    802029fa:	18700613          	li	a2,391
    802029fe:	00005597          	auipc	a1,0x5
    80202a02:	85258593          	addi	a1,a1,-1966 # 80207250 <small_numbers+0xe00>
    80202a06:	00005517          	auipc	a0,0x5
    80202a0a:	85a50513          	addi	a0,a0,-1958 # 80207260 <small_numbers+0xe10>
    80202a0e:	ffffe097          	auipc	ra,0xffffe
    80202a12:	146080e7          	jalr	326(ra) # 80200b54 <printf>
    80202a16:	00005517          	auipc	a0,0x5
    80202a1a:	87250513          	addi	a0,a0,-1934 # 80207288 <small_numbers+0xe38>
    80202a1e:	fffff097          	auipc	ra,0xfffff
    80202a22:	a3e080e7          	jalr	-1474(ra) # 8020145c <panic>
    80202a26:	0001                	nop
    80202a28:	60e2                	ld	ra,24(sp)
    80202a2a:	6442                	ld	s0,16(sp)
    80202a2c:	6105                	addi	sp,sp,32
    80202a2e:	8082                	ret

0000000080202a30 <freerange>:
static void freerange(void *pa_start, void *pa_end) {
    80202a30:	7179                	addi	sp,sp,-48
    80202a32:	f406                	sd	ra,40(sp)
    80202a34:	f022                	sd	s0,32(sp)
    80202a36:	1800                	addi	s0,sp,48
    80202a38:	fca43c23          	sd	a0,-40(s0)
    80202a3c:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    80202a40:	fd843703          	ld	a4,-40(s0)
    80202a44:	6785                	lui	a5,0x1
    80202a46:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80202a48:	973e                	add	a4,a4,a5
    80202a4a:	77fd                	lui	a5,0xfffff
    80202a4c:	8ff9                	and	a5,a5,a4
    80202a4e:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80202a52:	a829                	j	80202a6c <freerange+0x3c>
    free_page(p);
    80202a54:	fe843503          	ld	a0,-24(s0)
    80202a58:	00000097          	auipc	ra,0x0
    80202a5c:	0c4080e7          	jalr	196(ra) # 80202b1c <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80202a60:	fe843703          	ld	a4,-24(s0)
    80202a64:	6785                	lui	a5,0x1
    80202a66:	97ba                	add	a5,a5,a4
    80202a68:	fef43423          	sd	a5,-24(s0)
    80202a6c:	fe843703          	ld	a4,-24(s0)
    80202a70:	6785                	lui	a5,0x1
    80202a72:	97ba                	add	a5,a5,a4
    80202a74:	fd043703          	ld	a4,-48(s0)
    80202a78:	fcf77ee3          	bgeu	a4,a5,80202a54 <freerange+0x24>
}
    80202a7c:	0001                	nop
    80202a7e:	0001                	nop
    80202a80:	70a2                	ld	ra,40(sp)
    80202a82:	7402                	ld	s0,32(sp)
    80202a84:	6145                	addi	sp,sp,48
    80202a86:	8082                	ret

0000000080202a88 <pmm_init>:
void pmm_init(void) {
    80202a88:	1141                	addi	sp,sp,-16
    80202a8a:	e406                	sd	ra,8(sp)
    80202a8c:	e022                	sd	s0,0(sp)
    80202a8e:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    80202a90:	47c5                	li	a5,17
    80202a92:	01b79593          	slli	a1,a5,0x1b
    80202a96:	00009517          	auipc	a0,0x9
    80202a9a:	2ba50513          	addi	a0,a0,698 # 8020bd50 <_bss_end>
    80202a9e:	00000097          	auipc	ra,0x0
    80202aa2:	f92080e7          	jalr	-110(ra) # 80202a30 <freerange>
}
    80202aa6:	0001                	nop
    80202aa8:	60a2                	ld	ra,8(sp)
    80202aaa:	6402                	ld	s0,0(sp)
    80202aac:	0141                	addi	sp,sp,16
    80202aae:	8082                	ret

0000000080202ab0 <alloc_page>:
void* alloc_page(void) {
    80202ab0:	1101                	addi	sp,sp,-32
    80202ab2:	ec06                	sd	ra,24(sp)
    80202ab4:	e822                	sd	s0,16(sp)
    80202ab6:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80202ab8:	00007797          	auipc	a5,0x7
    80202abc:	70078793          	addi	a5,a5,1792 # 8020a1b8 <freelist>
    80202ac0:	639c                	ld	a5,0(a5)
    80202ac2:	fef43423          	sd	a5,-24(s0)
  if(r)
    80202ac6:	fe843783          	ld	a5,-24(s0)
    80202aca:	cb89                	beqz	a5,80202adc <alloc_page+0x2c>
    freelist = r->next;
    80202acc:	fe843783          	ld	a5,-24(s0)
    80202ad0:	6398                	ld	a4,0(a5)
    80202ad2:	00007797          	auipc	a5,0x7
    80202ad6:	6e678793          	addi	a5,a5,1766 # 8020a1b8 <freelist>
    80202ada:	e398                	sd	a4,0(a5)
  if(r)
    80202adc:	fe843783          	ld	a5,-24(s0)
    80202ae0:	cf99                	beqz	a5,80202afe <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    80202ae2:	fe843783          	ld	a5,-24(s0)
    80202ae6:	00878713          	addi	a4,a5,8
    80202aea:	6785                	lui	a5,0x1
    80202aec:	ff878613          	addi	a2,a5,-8 # ff8 <userret+0xf5c>
    80202af0:	4595                	li	a1,5
    80202af2:	853a                	mv	a0,a4
    80202af4:	fffff097          	auipc	ra,0xfffff
    80202af8:	0a6080e7          	jalr	166(ra) # 80201b9a <memset>
    80202afc:	a809                	j	80202b0e <alloc_page+0x5e>
    panic("alloc_page: out of memory");
    80202afe:	00004517          	auipc	a0,0x4
    80202b02:	79250513          	addi	a0,a0,1938 # 80207290 <small_numbers+0xe40>
    80202b06:	fffff097          	auipc	ra,0xfffff
    80202b0a:	956080e7          	jalr	-1706(ra) # 8020145c <panic>
  return (void*)r;
    80202b0e:	fe843783          	ld	a5,-24(s0)
}
    80202b12:	853e                	mv	a0,a5
    80202b14:	60e2                	ld	ra,24(sp)
    80202b16:	6442                	ld	s0,16(sp)
    80202b18:	6105                	addi	sp,sp,32
    80202b1a:	8082                	ret

0000000080202b1c <free_page>:
void free_page(void* page) {
    80202b1c:	7179                	addi	sp,sp,-48
    80202b1e:	f406                	sd	ra,40(sp)
    80202b20:	f022                	sd	s0,32(sp)
    80202b22:	1800                	addi	s0,sp,48
    80202b24:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    80202b28:	fd843783          	ld	a5,-40(s0)
    80202b2c:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    80202b30:	fd843703          	ld	a4,-40(s0)
    80202b34:	6785                	lui	a5,0x1
    80202b36:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80202b38:	8ff9                	and	a5,a5,a4
    80202b3a:	ef99                	bnez	a5,80202b58 <free_page+0x3c>
    80202b3c:	fd843703          	ld	a4,-40(s0)
    80202b40:	00009797          	auipc	a5,0x9
    80202b44:	21078793          	addi	a5,a5,528 # 8020bd50 <_bss_end>
    80202b48:	00f76863          	bltu	a4,a5,80202b58 <free_page+0x3c>
    80202b4c:	fd843703          	ld	a4,-40(s0)
    80202b50:	47c5                	li	a5,17
    80202b52:	07ee                	slli	a5,a5,0x1b
    80202b54:	00f76a63          	bltu	a4,a5,80202b68 <free_page+0x4c>
    panic("free_page: invalid page address");
    80202b58:	00004517          	auipc	a0,0x4
    80202b5c:	75850513          	addi	a0,a0,1880 # 802072b0 <small_numbers+0xe60>
    80202b60:	fffff097          	auipc	ra,0xfffff
    80202b64:	8fc080e7          	jalr	-1796(ra) # 8020145c <panic>
  r->next = freelist;
    80202b68:	00007797          	auipc	a5,0x7
    80202b6c:	65078793          	addi	a5,a5,1616 # 8020a1b8 <freelist>
    80202b70:	6398                	ld	a4,0(a5)
    80202b72:	fe843783          	ld	a5,-24(s0)
    80202b76:	e398                	sd	a4,0(a5)
  freelist = r;
    80202b78:	00007797          	auipc	a5,0x7
    80202b7c:	64078793          	addi	a5,a5,1600 # 8020a1b8 <freelist>
    80202b80:	fe843703          	ld	a4,-24(s0)
    80202b84:	e398                	sd	a4,0(a5)
}
    80202b86:	0001                	nop
    80202b88:	70a2                	ld	ra,40(sp)
    80202b8a:	7402                	ld	s0,32(sp)
    80202b8c:	6145                	addi	sp,sp,48
    80202b8e:	8082                	ret

0000000080202b90 <test_physical_memory>:
void test_physical_memory(void) {
    80202b90:	7179                	addi	sp,sp,-48
    80202b92:	f406                	sd	ra,40(sp)
    80202b94:	f022                	sd	s0,32(sp)
    80202b96:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    80202b98:	00004517          	auipc	a0,0x4
    80202b9c:	73850513          	addi	a0,a0,1848 # 802072d0 <small_numbers+0xe80>
    80202ba0:	ffffe097          	auipc	ra,0xffffe
    80202ba4:	fb4080e7          	jalr	-76(ra) # 80200b54 <printf>
    void *page1 = alloc_page();
    80202ba8:	00000097          	auipc	ra,0x0
    80202bac:	f08080e7          	jalr	-248(ra) # 80202ab0 <alloc_page>
    80202bb0:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    80202bb4:	00000097          	auipc	ra,0x0
    80202bb8:	efc080e7          	jalr	-260(ra) # 80202ab0 <alloc_page>
    80202bbc:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    80202bc0:	fe843783          	ld	a5,-24(s0)
    80202bc4:	00f037b3          	snez	a5,a5
    80202bc8:	0ff7f793          	zext.b	a5,a5
    80202bcc:	2781                	sext.w	a5,a5
    80202bce:	853e                	mv	a0,a5
    80202bd0:	00000097          	auipc	ra,0x0
    80202bd4:	e14080e7          	jalr	-492(ra) # 802029e4 <assert>
    assert(page2 != 0);
    80202bd8:	fe043783          	ld	a5,-32(s0)
    80202bdc:	00f037b3          	snez	a5,a5
    80202be0:	0ff7f793          	zext.b	a5,a5
    80202be4:	2781                	sext.w	a5,a5
    80202be6:	853e                	mv	a0,a5
    80202be8:	00000097          	auipc	ra,0x0
    80202bec:	dfc080e7          	jalr	-516(ra) # 802029e4 <assert>
    assert(page1 != page2);
    80202bf0:	fe843703          	ld	a4,-24(s0)
    80202bf4:	fe043783          	ld	a5,-32(s0)
    80202bf8:	40f707b3          	sub	a5,a4,a5
    80202bfc:	00f037b3          	snez	a5,a5
    80202c00:	0ff7f793          	zext.b	a5,a5
    80202c04:	2781                	sext.w	a5,a5
    80202c06:	853e                	mv	a0,a5
    80202c08:	00000097          	auipc	ra,0x0
    80202c0c:	ddc080e7          	jalr	-548(ra) # 802029e4 <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    80202c10:	fe843703          	ld	a4,-24(s0)
    80202c14:	6785                	lui	a5,0x1
    80202c16:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80202c18:	8ff9                	and	a5,a5,a4
    80202c1a:	0017b793          	seqz	a5,a5
    80202c1e:	0ff7f793          	zext.b	a5,a5
    80202c22:	2781                	sext.w	a5,a5
    80202c24:	853e                	mv	a0,a5
    80202c26:	00000097          	auipc	ra,0x0
    80202c2a:	dbe080e7          	jalr	-578(ra) # 802029e4 <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    80202c2e:	fe043703          	ld	a4,-32(s0)
    80202c32:	6785                	lui	a5,0x1
    80202c34:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80202c36:	8ff9                	and	a5,a5,a4
    80202c38:	0017b793          	seqz	a5,a5
    80202c3c:	0ff7f793          	zext.b	a5,a5
    80202c40:	2781                	sext.w	a5,a5
    80202c42:	853e                	mv	a0,a5
    80202c44:	00000097          	auipc	ra,0x0
    80202c48:	da0080e7          	jalr	-608(ra) # 802029e4 <assert>
    printf("[PM TEST] 分配测试通过\n");
    80202c4c:	00004517          	auipc	a0,0x4
    80202c50:	6a450513          	addi	a0,a0,1700 # 802072f0 <small_numbers+0xea0>
    80202c54:	ffffe097          	auipc	ra,0xffffe
    80202c58:	f00080e7          	jalr	-256(ra) # 80200b54 <printf>
    printf("[PM TEST] 数据写入测试...\n");
    80202c5c:	00004517          	auipc	a0,0x4
    80202c60:	6b450513          	addi	a0,a0,1716 # 80207310 <small_numbers+0xec0>
    80202c64:	ffffe097          	auipc	ra,0xffffe
    80202c68:	ef0080e7          	jalr	-272(ra) # 80200b54 <printf>
    *(int*)page1 = 0x12345678;
    80202c6c:	fe843783          	ld	a5,-24(s0)
    80202c70:	12345737          	lui	a4,0x12345
    80202c74:	67870713          	addi	a4,a4,1656 # 12345678 <userret+0x123455dc>
    80202c78:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    80202c7a:	fe843783          	ld	a5,-24(s0)
    80202c7e:	439c                	lw	a5,0(a5)
    80202c80:	873e                	mv	a4,a5
    80202c82:	123457b7          	lui	a5,0x12345
    80202c86:	67878793          	addi	a5,a5,1656 # 12345678 <userret+0x123455dc>
    80202c8a:	40f707b3          	sub	a5,a4,a5
    80202c8e:	0017b793          	seqz	a5,a5
    80202c92:	0ff7f793          	zext.b	a5,a5
    80202c96:	2781                	sext.w	a5,a5
    80202c98:	853e                	mv	a0,a5
    80202c9a:	00000097          	auipc	ra,0x0
    80202c9e:	d4a080e7          	jalr	-694(ra) # 802029e4 <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    80202ca2:	00004517          	auipc	a0,0x4
    80202ca6:	69650513          	addi	a0,a0,1686 # 80207338 <small_numbers+0xee8>
    80202caa:	ffffe097          	auipc	ra,0xffffe
    80202cae:	eaa080e7          	jalr	-342(ra) # 80200b54 <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    80202cb2:	00004517          	auipc	a0,0x4
    80202cb6:	6ae50513          	addi	a0,a0,1710 # 80207360 <small_numbers+0xf10>
    80202cba:	ffffe097          	auipc	ra,0xffffe
    80202cbe:	e9a080e7          	jalr	-358(ra) # 80200b54 <printf>
    free_page(page1);
    80202cc2:	fe843503          	ld	a0,-24(s0)
    80202cc6:	00000097          	auipc	ra,0x0
    80202cca:	e56080e7          	jalr	-426(ra) # 80202b1c <free_page>
    void *page3 = alloc_page();
    80202cce:	00000097          	auipc	ra,0x0
    80202cd2:	de2080e7          	jalr	-542(ra) # 80202ab0 <alloc_page>
    80202cd6:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    80202cda:	fd843783          	ld	a5,-40(s0)
    80202cde:	00f037b3          	snez	a5,a5
    80202ce2:	0ff7f793          	zext.b	a5,a5
    80202ce6:	2781                	sext.w	a5,a5
    80202ce8:	853e                	mv	a0,a5
    80202cea:	00000097          	auipc	ra,0x0
    80202cee:	cfa080e7          	jalr	-774(ra) # 802029e4 <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    80202cf2:	00004517          	auipc	a0,0x4
    80202cf6:	69e50513          	addi	a0,a0,1694 # 80207390 <small_numbers+0xf40>
    80202cfa:	ffffe097          	auipc	ra,0xffffe
    80202cfe:	e5a080e7          	jalr	-422(ra) # 80200b54 <printf>
    free_page(page2);
    80202d02:	fe043503          	ld	a0,-32(s0)
    80202d06:	00000097          	auipc	ra,0x0
    80202d0a:	e16080e7          	jalr	-490(ra) # 80202b1c <free_page>
    free_page(page3);
    80202d0e:	fd843503          	ld	a0,-40(s0)
    80202d12:	00000097          	auipc	ra,0x0
    80202d16:	e0a080e7          	jalr	-502(ra) # 80202b1c <free_page>
    printf("[PM TEST] 所有物理内存管理测试通过\n");
    80202d1a:	00004517          	auipc	a0,0x4
    80202d1e:	6a650513          	addi	a0,a0,1702 # 802073c0 <small_numbers+0xf70>
    80202d22:	ffffe097          	auipc	ra,0xffffe
    80202d26:	e32080e7          	jalr	-462(ra) # 80200b54 <printf>
    80202d2a:	0001                	nop
    80202d2c:	70a2                	ld	ra,40(sp)
    80202d2e:	7402                	ld	s0,32(sp)
    80202d30:	6145                	addi	sp,sp,48
    80202d32:	8082                	ret

0000000080202d34 <sbi_set_time>:
#include "defs.h"

void sbi_set_time(uint64 time) {
    80202d34:	1101                	addi	sp,sp,-32
    80202d36:	ec22                	sd	s0,24(sp)
    80202d38:	1000                	addi	s0,sp,32
    80202d3a:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    80202d3e:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    80202d42:	4881                	li	a7,0
    asm volatile ("ecall"
    80202d44:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    80202d48:	0001                	nop
    80202d4a:	6462                	ld	s0,24(sp)
    80202d4c:	6105                	addi	sp,sp,32
    80202d4e:	8082                	ret

0000000080202d50 <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    80202d50:	1101                	addi	sp,sp,-32
    80202d52:	ec22                	sd	s0,24(sp)
    80202d54:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    80202d56:	c01027f3          	rdtime	a5
    80202d5a:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    80202d5e:	fe843783          	ld	a5,-24(s0)
    80202d62:	853e                	mv	a0,a5
    80202d64:	6462                	ld	s0,24(sp)
    80202d66:	6105                	addi	sp,sp,32
    80202d68:	8082                	ret

0000000080202d6a <timeintr>:
#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    80202d6a:	1141                	addi	sp,sp,-16
    80202d6c:	e422                	sd	s0,8(sp)
    80202d6e:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    80202d70:	00007797          	auipc	a5,0x7
    80202d74:	31878793          	addi	a5,a5,792 # 8020a088 <interrupt_test_flag>
    80202d78:	639c                	ld	a5,0(a5)
    80202d7a:	cb99                	beqz	a5,80202d90 <timeintr+0x26>
        (*interrupt_test_flag)++;
    80202d7c:	00007797          	auipc	a5,0x7
    80202d80:	30c78793          	addi	a5,a5,780 # 8020a088 <interrupt_test_flag>
    80202d84:	639c                	ld	a5,0(a5)
    80202d86:	4398                	lw	a4,0(a5)
    80202d88:	2701                	sext.w	a4,a4
    80202d8a:	2705                	addiw	a4,a4,1
    80202d8c:	2701                	sext.w	a4,a4
    80202d8e:	c398                	sw	a4,0(a5)
    80202d90:	0001                	nop
    80202d92:	6422                	ld	s0,8(sp)
    80202d94:	0141                	addi	sp,sp,16
    80202d96:	8082                	ret

0000000080202d98 <r_sie>:
        printf("✓ 存储页故障异常处理成功\n\n");
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    }
    
    // 3. 测试加载页故障
    80202d98:	1101                	addi	sp,sp,-32
    80202d9a:	ec22                	sd	s0,24(sp)
    80202d9c:	1000                	addi	s0,sp,32
    printf("3. 测试加载页故障异常...\n");
    invalid_ptr = 0;
    80202d9e:	104027f3          	csrr	a5,sie
    80202da2:	fef43423          	sd	a5,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80202da6:	fe843783          	ld	a5,-24(s0)
        if (check_is_mapped(addr) == 0) {
    80202daa:	853e                	mv	a0,a5
    80202dac:	6462                	ld	s0,24(sp)
    80202dae:	6105                	addi	sp,sp,32
    80202db0:	8082                	ret

0000000080202db2 <w_sie>:
            invalid_ptr = (uint64*)addr;
            printf("找到未映射地址: 0x%lx\n", addr);
    80202db2:	1101                	addi	sp,sp,-32
    80202db4:	ec22                	sd	s0,24(sp)
    80202db6:	1000                	addi	s0,sp,32
    80202db8:	fea43423          	sd	a0,-24(s0)
            break;
    80202dbc:	fe843783          	ld	a5,-24(s0)
    80202dc0:	10479073          	csrw	sie,a5
        }
    80202dc4:	0001                	nop
    80202dc6:	6462                	ld	s0,24(sp)
    80202dc8:	6105                	addi	sp,sp,32
    80202dca:	8082                	ret

0000000080202dcc <r_sstatus>:
    }
    
    80202dcc:	1101                	addi	sp,sp,-32
    80202dce:	ec22                	sd	s0,24(sp)
    80202dd0:	1000                	addi	s0,sp,32
    if (invalid_ptr != 0) {
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80202dd2:	100027f3          	csrr	a5,sstatus
    80202dd6:	fef43423          	sd	a5,-24(s0)
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    80202dda:	fe843783          	ld	a5,-24(s0)
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    80202dde:	853e                	mv	a0,a5
    80202de0:	6462                	ld	s0,24(sp)
    80202de2:	6105                	addi	sp,sp,32
    80202de4:	8082                	ret

0000000080202de6 <w_sstatus>:
        printf("✓ 加载页故障异常处理成功\n\n");
    80202de6:	1101                	addi	sp,sp,-32
    80202de8:	ec22                	sd	s0,24(sp)
    80202dea:	1000                	addi	s0,sp,32
    80202dec:	fea43423          	sd	a0,-24(s0)
    } else {
    80202df0:	fe843783          	ld	a5,-24(s0)
    80202df4:	10079073          	csrw	sstatus,a5
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80202df8:	0001                	nop
    80202dfa:	6462                	ld	s0,24(sp)
    80202dfc:	6105                	addi	sp,sp,32
    80202dfe:	8082                	ret

0000000080202e00 <w_sepc>:
    }
    
    80202e00:	1101                	addi	sp,sp,-32
    80202e02:	ec22                	sd	s0,24(sp)
    80202e04:	1000                	addi	s0,sp,32
    80202e06:	fea43423          	sd	a0,-24(s0)
    // 4. 测试存储地址未对齐异常
    80202e0a:	fe843783          	ld	a5,-24(s0)
    80202e0e:	14179073          	csrw	sepc,a5
    printf("4. 测试存储地址未对齐异常...\n");
    80202e12:	0001                	nop
    80202e14:	6462                	ld	s0,24(sp)
    80202e16:	6105                	addi	sp,sp,32
    80202e18:	8082                	ret

0000000080202e1a <intr_off>:
    uint64 aligned_addr = (uint64)alloc_page();
    if (aligned_addr != 0) {
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
        
        // 使用内联汇编进行未对齐访问，因为编译器可能会自动对齐
    80202e1a:	1141                	addi	sp,sp,-16
    80202e1c:	e406                	sd	ra,8(sp)
    80202e1e:	e022                	sd	s0,0(sp)
    80202e20:	0800                	addi	s0,sp,16
        asm volatile (
    80202e22:	00000097          	auipc	ra,0x0
    80202e26:	faa080e7          	jalr	-86(ra) # 80202dcc <r_sstatus>
    80202e2a:	87aa                	mv	a5,a0
    80202e2c:	9bf5                	andi	a5,a5,-3
    80202e2e:	853e                	mv	a0,a5
    80202e30:	00000097          	auipc	ra,0x0
    80202e34:	fb6080e7          	jalr	-74(ra) # 80202de6 <w_sstatus>
            "sd %0, 0(%1)"
    80202e38:	0001                	nop
    80202e3a:	60a2                	ld	ra,8(sp)
    80202e3c:	6402                	ld	s0,0(sp)
    80202e3e:	0141                	addi	sp,sp,16
    80202e40:	8082                	ret

0000000080202e42 <w_stvec>:
            : 
            : "r" (0xdeadbeef), "r" (misaligned_addr)
    80202e42:	1101                	addi	sp,sp,-32
    80202e44:	ec22                	sd	s0,24(sp)
    80202e46:	1000                	addi	s0,sp,32
    80202e48:	fea43423          	sd	a0,-24(s0)
            : "memory"
    80202e4c:	fe843783          	ld	a5,-24(s0)
    80202e50:	10579073          	csrw	stvec,a5
        );
    80202e54:	0001                	nop
    80202e56:	6462                	ld	s0,24(sp)
    80202e58:	6105                	addi	sp,sp,32
    80202e5a:	8082                	ret

0000000080202e5c <r_scause>:
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    }
    
    // 5. 测试加载地址未对齐异常
    printf("5. 测试加载地址未对齐异常...\n");
    if (aligned_addr != 0) {
    80202e5c:	1101                	addi	sp,sp,-32
    80202e5e:	ec22                	sd	s0,24(sp)
    80202e60:	1000                	addi	s0,sp,32
        uint64 misaligned_addr = aligned_addr + 1;
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80202e62:	142027f3          	csrr	a5,scause
    80202e66:	fef43423          	sd	a5,-24(s0)
        
    80202e6a:	fe843783          	ld	a5,-24(s0)
        uint64 value = 0;
    80202e6e:	853e                	mv	a0,a5
    80202e70:	6462                	ld	s0,24(sp)
    80202e72:	6105                	addi	sp,sp,32
    80202e74:	8082                	ret

0000000080202e76 <r_sepc>:
        asm volatile (
            "ld %0, 0(%1)"
    80202e76:	1101                	addi	sp,sp,-32
    80202e78:	ec22                	sd	s0,24(sp)
    80202e7a:	1000                	addi	s0,sp,32
            : "=r" (value)
            : "r" (misaligned_addr)
    80202e7c:	141027f3          	csrr	a5,sepc
    80202e80:	fef43423          	sd	a5,-24(s0)
            : "memory"
    80202e84:	fe843783          	ld	a5,-24(s0)
        );
    80202e88:	853e                	mv	a0,a5
    80202e8a:	6462                	ld	s0,24(sp)
    80202e8c:	6105                	addi	sp,sp,32
    80202e8e:	8082                	ret

0000000080202e90 <r_stval>:
        printf("读取的值: 0x%lx\n", value);
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80202e90:	1101                	addi	sp,sp,-32
    80202e92:	ec22                	sd	s0,24(sp)
    80202e94:	1000                	addi	s0,sp,32
    } else {
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80202e96:	143027f3          	csrr	a5,stval
    80202e9a:	fef43423          	sd	a5,-24(s0)
    }
    80202e9e:	fe843783          	ld	a5,-24(s0)

    80202ea2:	853e                	mv	a0,a5
    80202ea4:	6462                	ld	s0,24(sp)
    80202ea6:	6105                	addi	sp,sp,32
    80202ea8:	8082                	ret

0000000080202eaa <save_exception_info>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    80202eaa:	7139                	addi	sp,sp,-64
    80202eac:	fc22                	sd	s0,56(sp)
    80202eae:	0080                	addi	s0,sp,64
    80202eb0:	fea43423          	sd	a0,-24(s0)
    80202eb4:	feb43023          	sd	a1,-32(s0)
    80202eb8:	fcc43c23          	sd	a2,-40(s0)
    80202ebc:	fcd43823          	sd	a3,-48(s0)
    80202ec0:	fce43423          	sd	a4,-56(s0)
    tf->epc = sepc;
    80202ec4:	fe843783          	ld	a5,-24(s0)
    80202ec8:	fe043703          	ld	a4,-32(s0)
    80202ecc:	ef98                	sd	a4,24(a5)
}
    80202ece:	0001                	nop
    80202ed0:	7462                	ld	s0,56(sp)
    80202ed2:	6121                	addi	sp,sp,64
    80202ed4:	8082                	ret

0000000080202ed6 <get_sepc>:
static inline uint64 get_sepc(struct trapframe *tf) {
    80202ed6:	1101                	addi	sp,sp,-32
    80202ed8:	ec22                	sd	s0,24(sp)
    80202eda:	1000                	addi	s0,sp,32
    80202edc:	fea43423          	sd	a0,-24(s0)
    return tf->epc;
    80202ee0:	fe843783          	ld	a5,-24(s0)
    80202ee4:	6f9c                	ld	a5,24(a5)
}
    80202ee6:	853e                	mv	a0,a5
    80202ee8:	6462                	ld	s0,24(sp)
    80202eea:	6105                	addi	sp,sp,32
    80202eec:	8082                	ret

0000000080202eee <set_sepc>:
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    80202eee:	1101                	addi	sp,sp,-32
    80202ef0:	ec22                	sd	s0,24(sp)
    80202ef2:	1000                	addi	s0,sp,32
    80202ef4:	fea43423          	sd	a0,-24(s0)
    80202ef8:	feb43023          	sd	a1,-32(s0)
    tf->epc = sepc;
    80202efc:	fe843783          	ld	a5,-24(s0)
    80202f00:	fe043703          	ld	a4,-32(s0)
    80202f04:	ef98                	sd	a4,24(a5)
}
    80202f06:	0001                	nop
    80202f08:	6462                	ld	s0,24(sp)
    80202f0a:	6105                	addi	sp,sp,32
    80202f0c:	8082                	ret

0000000080202f0e <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    80202f0e:	1101                	addi	sp,sp,-32
    80202f10:	ec22                	sd	s0,24(sp)
    80202f12:	1000                	addi	s0,sp,32
    80202f14:	87aa                	mv	a5,a0
    80202f16:	feb43023          	sd	a1,-32(s0)
    80202f1a:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    80202f1e:	fec42783          	lw	a5,-20(s0)
    80202f22:	2781                	sext.w	a5,a5
    80202f24:	0207c563          	bltz	a5,80202f4e <register_interrupt+0x40>
    80202f28:	fec42783          	lw	a5,-20(s0)
    80202f2c:	0007871b          	sext.w	a4,a5
    80202f30:	03f00793          	li	a5,63
    80202f34:	00e7cd63          	blt	a5,a4,80202f4e <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    80202f38:	00007717          	auipc	a4,0x7
    80202f3c:	28870713          	addi	a4,a4,648 # 8020a1c0 <interrupt_vector>
    80202f40:	fec42783          	lw	a5,-20(s0)
    80202f44:	078e                	slli	a5,a5,0x3
    80202f46:	97ba                	add	a5,a5,a4
    80202f48:	fe043703          	ld	a4,-32(s0)
    80202f4c:	e398                	sd	a4,0(a5)
}
    80202f4e:	0001                	nop
    80202f50:	6462                	ld	s0,24(sp)
    80202f52:	6105                	addi	sp,sp,32
    80202f54:	8082                	ret

0000000080202f56 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    80202f56:	1101                	addi	sp,sp,-32
    80202f58:	ec22                	sd	s0,24(sp)
    80202f5a:	1000                	addi	s0,sp,32
    80202f5c:	87aa                	mv	a5,a0
    80202f5e:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    80202f62:	fec42783          	lw	a5,-20(s0)
    80202f66:	2781                	sext.w	a5,a5
    80202f68:	0207c463          	bltz	a5,80202f90 <unregister_interrupt+0x3a>
    80202f6c:	fec42783          	lw	a5,-20(s0)
    80202f70:	0007871b          	sext.w	a4,a5
    80202f74:	03f00793          	li	a5,63
    80202f78:	00e7cc63          	blt	a5,a4,80202f90 <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    80202f7c:	00007717          	auipc	a4,0x7
    80202f80:	24470713          	addi	a4,a4,580 # 8020a1c0 <interrupt_vector>
    80202f84:	fec42783          	lw	a5,-20(s0)
    80202f88:	078e                	slli	a5,a5,0x3
    80202f8a:	97ba                	add	a5,a5,a4
    80202f8c:	0007b023          	sd	zero,0(a5)
}
    80202f90:	0001                	nop
    80202f92:	6462                	ld	s0,24(sp)
    80202f94:	6105                	addi	sp,sp,32
    80202f96:	8082                	ret

0000000080202f98 <enable_interrupts>:
void enable_interrupts(int irq) {
    80202f98:	1101                	addi	sp,sp,-32
    80202f9a:	ec06                	sd	ra,24(sp)
    80202f9c:	e822                	sd	s0,16(sp)
    80202f9e:	1000                	addi	s0,sp,32
    80202fa0:	87aa                	mv	a5,a0
    80202fa2:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    80202fa6:	fec42783          	lw	a5,-20(s0)
    80202faa:	853e                	mv	a0,a5
    80202fac:	00001097          	auipc	ra,0x1
    80202fb0:	c8e080e7          	jalr	-882(ra) # 80203c3a <plic_enable>
}
    80202fb4:	0001                	nop
    80202fb6:	60e2                	ld	ra,24(sp)
    80202fb8:	6442                	ld	s0,16(sp)
    80202fba:	6105                	addi	sp,sp,32
    80202fbc:	8082                	ret

0000000080202fbe <disable_interrupts>:
void disable_interrupts(int irq) {
    80202fbe:	1101                	addi	sp,sp,-32
    80202fc0:	ec06                	sd	ra,24(sp)
    80202fc2:	e822                	sd	s0,16(sp)
    80202fc4:	1000                	addi	s0,sp,32
    80202fc6:	87aa                	mv	a5,a0
    80202fc8:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    80202fcc:	fec42783          	lw	a5,-20(s0)
    80202fd0:	853e                	mv	a0,a5
    80202fd2:	00001097          	auipc	ra,0x1
    80202fd6:	cc0080e7          	jalr	-832(ra) # 80203c92 <plic_disable>
}
    80202fda:	0001                	nop
    80202fdc:	60e2                	ld	ra,24(sp)
    80202fde:	6442                	ld	s0,16(sp)
    80202fe0:	6105                	addi	sp,sp,32
    80202fe2:	8082                	ret

0000000080202fe4 <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    80202fe4:	1101                	addi	sp,sp,-32
    80202fe6:	ec06                	sd	ra,24(sp)
    80202fe8:	e822                	sd	s0,16(sp)
    80202fea:	1000                	addi	s0,sp,32
    80202fec:	87aa                	mv	a5,a0
    80202fee:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    80202ff2:	fec42783          	lw	a5,-20(s0)
    80202ff6:	2781                	sext.w	a5,a5
    80202ff8:	0207ce63          	bltz	a5,80203034 <interrupt_dispatch+0x50>
    80202ffc:	fec42783          	lw	a5,-20(s0)
    80203000:	0007871b          	sext.w	a4,a5
    80203004:	03f00793          	li	a5,63
    80203008:	02e7c663          	blt	a5,a4,80203034 <interrupt_dispatch+0x50>
    8020300c:	00007717          	auipc	a4,0x7
    80203010:	1b470713          	addi	a4,a4,436 # 8020a1c0 <interrupt_vector>
    80203014:	fec42783          	lw	a5,-20(s0)
    80203018:	078e                	slli	a5,a5,0x3
    8020301a:	97ba                	add	a5,a5,a4
    8020301c:	639c                	ld	a5,0(a5)
    8020301e:	cb99                	beqz	a5,80203034 <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    80203020:	00007717          	auipc	a4,0x7
    80203024:	1a070713          	addi	a4,a4,416 # 8020a1c0 <interrupt_vector>
    80203028:	fec42783          	lw	a5,-20(s0)
    8020302c:	078e                	slli	a5,a5,0x3
    8020302e:	97ba                	add	a5,a5,a4
    80203030:	639c                	ld	a5,0(a5)
    80203032:	9782                	jalr	a5
}
    80203034:	0001                	nop
    80203036:	60e2                	ld	ra,24(sp)
    80203038:	6442                	ld	s0,16(sp)
    8020303a:	6105                	addi	sp,sp,32
    8020303c:	8082                	ret

000000008020303e <handle_external_interrupt>:
void handle_external_interrupt(void) {
    8020303e:	1101                	addi	sp,sp,-32
    80203040:	ec06                	sd	ra,24(sp)
    80203042:	e822                	sd	s0,16(sp)
    80203044:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    80203046:	00001097          	auipc	ra,0x1
    8020304a:	caa080e7          	jalr	-854(ra) # 80203cf0 <plic_claim>
    8020304e:	87aa                	mv	a5,a0
    80203050:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    80203054:	fec42783          	lw	a5,-20(s0)
    80203058:	2781                	sext.w	a5,a5
    8020305a:	eb91                	bnez	a5,8020306e <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    8020305c:	00004517          	auipc	a0,0x4
    80203060:	39450513          	addi	a0,a0,916 # 802073f0 <small_numbers+0xfa0>
    80203064:	ffffe097          	auipc	ra,0xffffe
    80203068:	af0080e7          	jalr	-1296(ra) # 80200b54 <printf>
        return;
    8020306c:	a839                	j	8020308a <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    8020306e:	fec42783          	lw	a5,-20(s0)
    80203072:	853e                	mv	a0,a5
    80203074:	00000097          	auipc	ra,0x0
    80203078:	f70080e7          	jalr	-144(ra) # 80202fe4 <interrupt_dispatch>
    plic_complete(irq);
    8020307c:	fec42783          	lw	a5,-20(s0)
    80203080:	853e                	mv	a0,a5
    80203082:	00001097          	auipc	ra,0x1
    80203086:	c96080e7          	jalr	-874(ra) # 80203d18 <plic_complete>
}
    8020308a:	60e2                	ld	ra,24(sp)
    8020308c:	6442                	ld	s0,16(sp)
    8020308e:	6105                	addi	sp,sp,32
    80203090:	8082                	ret

0000000080203092 <trap_init>:
void trap_init(void) {
    80203092:	1101                	addi	sp,sp,-32
    80203094:	ec06                	sd	ra,24(sp)
    80203096:	e822                	sd	s0,16(sp)
    80203098:	1000                	addi	s0,sp,32
	intr_off();
    8020309a:	00000097          	auipc	ra,0x0
    8020309e:	d80080e7          	jalr	-640(ra) # 80202e1a <intr_off>
	printf("trap_init...\n");
    802030a2:	00004517          	auipc	a0,0x4
    802030a6:	36e50513          	addi	a0,a0,878 # 80207410 <small_numbers+0xfc0>
    802030aa:	ffffe097          	auipc	ra,0xffffe
    802030ae:	aaa080e7          	jalr	-1366(ra) # 80200b54 <printf>
	w_stvec((uint64)kernelvec);
    802030b2:	00001797          	auipc	a5,0x1
    802030b6:	c9e78793          	addi	a5,a5,-866 # 80203d50 <kernelvec>
    802030ba:	853e                	mv	a0,a5
    802030bc:	00000097          	auipc	ra,0x0
    802030c0:	d86080e7          	jalr	-634(ra) # 80202e42 <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    802030c4:	fe042623          	sw	zero,-20(s0)
    802030c8:	a005                	j	802030e8 <trap_init+0x56>
		interrupt_vector[i] = 0;
    802030ca:	00007717          	auipc	a4,0x7
    802030ce:	0f670713          	addi	a4,a4,246 # 8020a1c0 <interrupt_vector>
    802030d2:	fec42783          	lw	a5,-20(s0)
    802030d6:	078e                	slli	a5,a5,0x3
    802030d8:	97ba                	add	a5,a5,a4
    802030da:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    802030de:	fec42783          	lw	a5,-20(s0)
    802030e2:	2785                	addiw	a5,a5,1
    802030e4:	fef42623          	sw	a5,-20(s0)
    802030e8:	fec42783          	lw	a5,-20(s0)
    802030ec:	0007871b          	sext.w	a4,a5
    802030f0:	03f00793          	li	a5,63
    802030f4:	fce7dbe3          	bge	a5,a4,802030ca <trap_init+0x38>
	plic_init();
    802030f8:	00001097          	auipc	ra,0x1
    802030fc:	aa4080e7          	jalr	-1372(ra) # 80203b9c <plic_init>
    uint64 sie = r_sie();
    80203100:	00000097          	auipc	ra,0x0
    80203104:	c98080e7          	jalr	-872(ra) # 80202d98 <r_sie>
    80203108:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    8020310c:	fe043783          	ld	a5,-32(s0)
    80203110:	2207e793          	ori	a5,a5,544
    80203114:	853e                	mv	a0,a5
    80203116:	00000097          	auipc	ra,0x0
    8020311a:	c9c080e7          	jalr	-868(ra) # 80202db2 <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    8020311e:	00000097          	auipc	ra,0x0
    80203122:	c32080e7          	jalr	-974(ra) # 80202d50 <sbi_get_time>
    80203126:	872a                	mv	a4,a0
    80203128:	000f47b7          	lui	a5,0xf4
    8020312c:	24078793          	addi	a5,a5,576 # f4240 <userret+0xf41a4>
    80203130:	97ba                	add	a5,a5,a4
    80203132:	853e                	mv	a0,a5
    80203134:	00000097          	auipc	ra,0x0
    80203138:	c00080e7          	jalr	-1024(ra) # 80202d34 <sbi_set_time>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    8020313c:	00000597          	auipc	a1,0x0
    80203140:	57258593          	addi	a1,a1,1394 # 802036ae <handle_store_page_fault>
    80203144:	00004517          	auipc	a0,0x4
    80203148:	2dc50513          	addi	a0,a0,732 # 80207420 <small_numbers+0xfd0>
    8020314c:	ffffe097          	auipc	ra,0xffffe
    80203150:	a08080e7          	jalr	-1528(ra) # 80200b54 <printf>
	printf("trap_init complete.\n");
    80203154:	00004517          	auipc	a0,0x4
    80203158:	30450513          	addi	a0,a0,772 # 80207458 <small_numbers+0x1008>
    8020315c:	ffffe097          	auipc	ra,0xffffe
    80203160:	9f8080e7          	jalr	-1544(ra) # 80200b54 <printf>
}
    80203164:	0001                	nop
    80203166:	60e2                	ld	ra,24(sp)
    80203168:	6442                	ld	s0,16(sp)
    8020316a:	6105                	addi	sp,sp,32
    8020316c:	8082                	ret

000000008020316e <kerneltrap>:
void kerneltrap(void) {
    8020316e:	7149                	addi	sp,sp,-368
    80203170:	f686                	sd	ra,360(sp)
    80203172:	f2a2                	sd	s0,352(sp)
    80203174:	1a80                	addi	s0,sp,368
    uint64 sstatus = r_sstatus();
    80203176:	00000097          	auipc	ra,0x0
    8020317a:	c56080e7          	jalr	-938(ra) # 80202dcc <r_sstatus>
    8020317e:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    80203182:	00000097          	auipc	ra,0x0
    80203186:	cda080e7          	jalr	-806(ra) # 80202e5c <r_scause>
    8020318a:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    8020318e:	00000097          	auipc	ra,0x0
    80203192:	ce8080e7          	jalr	-792(ra) # 80202e76 <r_sepc>
    80203196:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    8020319a:	00000097          	auipc	ra,0x0
    8020319e:	cf6080e7          	jalr	-778(ra) # 80202e90 <r_stval>
    802031a2:	fca43823          	sd	a0,-48(s0)
    if(scause & 0x8000000000000000) {
    802031a6:	fd843783          	ld	a5,-40(s0)
    802031aa:	0607d663          	bgez	a5,80203216 <kerneltrap+0xa8>
        if((scause & 0xff) == 5) {
    802031ae:	fd843783          	ld	a5,-40(s0)
    802031b2:	0ff7f713          	zext.b	a4,a5
    802031b6:	4795                	li	a5,5
    802031b8:	02f71663          	bne	a4,a5,802031e4 <kerneltrap+0x76>
            timeintr();
    802031bc:	00000097          	auipc	ra,0x0
    802031c0:	bae080e7          	jalr	-1106(ra) # 80202d6a <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802031c4:	00000097          	auipc	ra,0x0
    802031c8:	b8c080e7          	jalr	-1140(ra) # 80202d50 <sbi_get_time>
    802031cc:	872a                	mv	a4,a0
    802031ce:	000f47b7          	lui	a5,0xf4
    802031d2:	24078793          	addi	a5,a5,576 # f4240 <userret+0xf41a4>
    802031d6:	97ba                	add	a5,a5,a4
    802031d8:	853e                	mv	a0,a5
    802031da:	00000097          	auipc	ra,0x0
    802031de:	b5a080e7          	jalr	-1190(ra) # 80202d34 <sbi_set_time>
    802031e2:	a855                	j	80203296 <kerneltrap+0x128>
        } else if((scause & 0xff) == 9) {
    802031e4:	fd843783          	ld	a5,-40(s0)
    802031e8:	0ff7f713          	zext.b	a4,a5
    802031ec:	47a5                	li	a5,9
    802031ee:	00f71763          	bne	a4,a5,802031fc <kerneltrap+0x8e>
            handle_external_interrupt();
    802031f2:	00000097          	auipc	ra,0x0
    802031f6:	e4c080e7          	jalr	-436(ra) # 8020303e <handle_external_interrupt>
    802031fa:	a871                	j	80203296 <kerneltrap+0x128>
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    802031fc:	fe843603          	ld	a2,-24(s0)
    80203200:	fd843583          	ld	a1,-40(s0)
    80203204:	00004517          	auipc	a0,0x4
    80203208:	26c50513          	addi	a0,a0,620 # 80207470 <small_numbers+0x1020>
    8020320c:	ffffe097          	auipc	ra,0xffffe
    80203210:	948080e7          	jalr	-1720(ra) # 80200b54 <printf>
    80203214:	a049                	j	80203296 <kerneltrap+0x128>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    80203216:	fd043683          	ld	a3,-48(s0)
    8020321a:	fe843603          	ld	a2,-24(s0)
    8020321e:	fd843583          	ld	a1,-40(s0)
    80203222:	00004517          	auipc	a0,0x4
    80203226:	28650513          	addi	a0,a0,646 # 802074a8 <small_numbers+0x1058>
    8020322a:	ffffe097          	auipc	ra,0xffffe
    8020322e:	92a080e7          	jalr	-1750(ra) # 80200b54 <printf>
        save_exception_info(&tf, sepc, sstatus, scause, stval);
    80203232:	eb040793          	addi	a5,s0,-336
    80203236:	fd043703          	ld	a4,-48(s0)
    8020323a:	fd843683          	ld	a3,-40(s0)
    8020323e:	fe043603          	ld	a2,-32(s0)
    80203242:	fe843583          	ld	a1,-24(s0)
    80203246:	853e                	mv	a0,a5
    80203248:	00000097          	auipc	ra,0x0
    8020324c:	c62080e7          	jalr	-926(ra) # 80202eaa <save_exception_info>
        info.sepc = sepc;
    80203250:	fe843783          	ld	a5,-24(s0)
    80203254:	e8f43823          	sd	a5,-368(s0)
        info.sstatus = sstatus;
    80203258:	fe043783          	ld	a5,-32(s0)
    8020325c:	e8f43c23          	sd	a5,-360(s0)
        info.scause = scause;
    80203260:	fd843783          	ld	a5,-40(s0)
    80203264:	eaf43023          	sd	a5,-352(s0)
        info.stval = stval;
    80203268:	fd043783          	ld	a5,-48(s0)
    8020326c:	eaf43423          	sd	a5,-344(s0)
        handle_exception(&tf, &info);
    80203270:	e9040713          	addi	a4,s0,-368
    80203274:	eb040793          	addi	a5,s0,-336
    80203278:	85ba                	mv	a1,a4
    8020327a:	853e                	mv	a0,a5
    8020327c:	00000097          	auipc	ra,0x0
    80203280:	03c080e7          	jalr	60(ra) # 802032b8 <handle_exception>
        sepc = get_sepc(&tf);
    80203284:	eb040793          	addi	a5,s0,-336
    80203288:	853e                	mv	a0,a5
    8020328a:	00000097          	auipc	ra,0x0
    8020328e:	c4c080e7          	jalr	-948(ra) # 80202ed6 <get_sepc>
    80203292:	fea43423          	sd	a0,-24(s0)
    w_sepc(sepc);
    80203296:	fe843503          	ld	a0,-24(s0)
    8020329a:	00000097          	auipc	ra,0x0
    8020329e:	b66080e7          	jalr	-1178(ra) # 80202e00 <w_sepc>
    w_sstatus(sstatus);
    802032a2:	fe043503          	ld	a0,-32(s0)
    802032a6:	00000097          	auipc	ra,0x0
    802032aa:	b40080e7          	jalr	-1216(ra) # 80202de6 <w_sstatus>
}
    802032ae:	0001                	nop
    802032b0:	70b6                	ld	ra,360(sp)
    802032b2:	7416                	ld	s0,352(sp)
    802032b4:	6175                	addi	sp,sp,368
    802032b6:	8082                	ret

00000000802032b8 <handle_exception>:
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    802032b8:	7179                	addi	sp,sp,-48
    802032ba:	f406                	sd	ra,40(sp)
    802032bc:	f022                	sd	s0,32(sp)
    802032be:	1800                	addi	s0,sp,48
    802032c0:	fca43c23          	sd	a0,-40(s0)
    802032c4:	fcb43823          	sd	a1,-48(s0)
    uint64 cause = info->scause;  // 使用info中的字段
    802032c8:	fd043783          	ld	a5,-48(s0)
    802032cc:	6b9c                	ld	a5,16(a5)
    802032ce:	fef43423          	sd	a5,-24(s0)
    switch (cause) {
    802032d2:	fe843703          	ld	a4,-24(s0)
    802032d6:	47bd                	li	a5,15
    802032d8:	26e7ef63          	bltu	a5,a4,80203556 <handle_exception+0x29e>
    802032dc:	fe843783          	ld	a5,-24(s0)
    802032e0:	00279713          	slli	a4,a5,0x2
    802032e4:	00004797          	auipc	a5,0x4
    802032e8:	38078793          	addi	a5,a5,896 # 80207664 <small_numbers+0x1214>
    802032ec:	97ba                	add	a5,a5,a4
    802032ee:	439c                	lw	a5,0(a5)
    802032f0:	0007871b          	sext.w	a4,a5
    802032f4:	00004797          	auipc	a5,0x4
    802032f8:	37078793          	addi	a5,a5,880 # 80207664 <small_numbers+0x1214>
    802032fc:	97ba                	add	a5,a5,a4
    802032fe:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80203300:	fd043783          	ld	a5,-48(s0)
    80203304:	6f9c                	ld	a5,24(a5)
    80203306:	85be                	mv	a1,a5
    80203308:	00004517          	auipc	a0,0x4
    8020330c:	1d050513          	addi	a0,a0,464 # 802074d8 <small_numbers+0x1088>
    80203310:	ffffe097          	auipc	ra,0xffffe
    80203314:	844080e7          	jalr	-1980(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203318:	fd043783          	ld	a5,-48(s0)
    8020331c:	639c                	ld	a5,0(a5)
    8020331e:	0791                	addi	a5,a5,4
    80203320:	85be                	mv	a1,a5
    80203322:	fd843503          	ld	a0,-40(s0)
    80203326:	00000097          	auipc	ra,0x0
    8020332a:	bc8080e7          	jalr	-1080(ra) # 80202eee <set_sepc>
            break;
    8020332e:	a495                	j	80203592 <handle_exception+0x2da>
            printf("Instruction access fault: 0x%lx\n", info->stval);
    80203330:	fd043783          	ld	a5,-48(s0)
    80203334:	6f9c                	ld	a5,24(a5)
    80203336:	85be                	mv	a1,a5
    80203338:	00004517          	auipc	a0,0x4
    8020333c:	1c850513          	addi	a0,a0,456 # 80207500 <small_numbers+0x10b0>
    80203340:	ffffe097          	auipc	ra,0xffffe
    80203344:	814080e7          	jalr	-2028(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203348:	fd043783          	ld	a5,-48(s0)
    8020334c:	639c                	ld	a5,0(a5)
    8020334e:	0791                	addi	a5,a5,4
    80203350:	85be                	mv	a1,a5
    80203352:	fd843503          	ld	a0,-40(s0)
    80203356:	00000097          	auipc	ra,0x0
    8020335a:	b98080e7          	jalr	-1128(ra) # 80202eee <set_sepc>
            break;
    8020335e:	ac15                	j	80203592 <handle_exception+0x2da>
            printf("Illegal instruction at 0x%lx: 0x%lx\n", info->sepc, info->stval);
    80203360:	fd043783          	ld	a5,-48(s0)
    80203364:	6398                	ld	a4,0(a5)
    80203366:	fd043783          	ld	a5,-48(s0)
    8020336a:	6f9c                	ld	a5,24(a5)
    8020336c:	863e                	mv	a2,a5
    8020336e:	85ba                	mv	a1,a4
    80203370:	00004517          	auipc	a0,0x4
    80203374:	1b850513          	addi	a0,a0,440 # 80207528 <small_numbers+0x10d8>
    80203378:	ffffd097          	auipc	ra,0xffffd
    8020337c:	7dc080e7          	jalr	2012(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203380:	fd043783          	ld	a5,-48(s0)
    80203384:	639c                	ld	a5,0(a5)
    80203386:	0791                	addi	a5,a5,4
    80203388:	85be                	mv	a1,a5
    8020338a:	fd843503          	ld	a0,-40(s0)
    8020338e:	00000097          	auipc	ra,0x0
    80203392:	b60080e7          	jalr	-1184(ra) # 80202eee <set_sepc>
            break;
    80203396:	aaf5                	j	80203592 <handle_exception+0x2da>
            printf("Breakpoint at 0x%lx\n", info->sepc);
    80203398:	fd043783          	ld	a5,-48(s0)
    8020339c:	639c                	ld	a5,0(a5)
    8020339e:	85be                	mv	a1,a5
    802033a0:	00004517          	auipc	a0,0x4
    802033a4:	1b050513          	addi	a0,a0,432 # 80207550 <small_numbers+0x1100>
    802033a8:	ffffd097          	auipc	ra,0xffffd
    802033ac:	7ac080e7          	jalr	1964(ra) # 80200b54 <printf>
            set_sepc(tf, info->sepc + 4);
    802033b0:	fd043783          	ld	a5,-48(s0)
    802033b4:	639c                	ld	a5,0(a5)
    802033b6:	0791                	addi	a5,a5,4
    802033b8:	85be                	mv	a1,a5
    802033ba:	fd843503          	ld	a0,-40(s0)
    802033be:	00000097          	auipc	ra,0x0
    802033c2:	b30080e7          	jalr	-1232(ra) # 80202eee <set_sepc>
            break;
    802033c6:	a2f1                	j	80203592 <handle_exception+0x2da>
            printf("Load address misaligned: 0x%lx\n", info->stval);
    802033c8:	fd043783          	ld	a5,-48(s0)
    802033cc:	6f9c                	ld	a5,24(a5)
    802033ce:	85be                	mv	a1,a5
    802033d0:	00004517          	auipc	a0,0x4
    802033d4:	19850513          	addi	a0,a0,408 # 80207568 <small_numbers+0x1118>
    802033d8:	ffffd097          	auipc	ra,0xffffd
    802033dc:	77c080e7          	jalr	1916(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4); 
    802033e0:	fd043783          	ld	a5,-48(s0)
    802033e4:	639c                	ld	a5,0(a5)
    802033e6:	0791                	addi	a5,a5,4
    802033e8:	85be                	mv	a1,a5
    802033ea:	fd843503          	ld	a0,-40(s0)
    802033ee:	00000097          	auipc	ra,0x0
    802033f2:	b00080e7          	jalr	-1280(ra) # 80202eee <set_sepc>
            break;
    802033f6:	aa71                	j	80203592 <handle_exception+0x2da>
			printf("Load access fault: 0x%lx\n", info->stval);
    802033f8:	fd043783          	ld	a5,-48(s0)
    802033fc:	6f9c                	ld	a5,24(a5)
    802033fe:	85be                	mv	a1,a5
    80203400:	00004517          	auipc	a0,0x4
    80203404:	18850513          	addi	a0,a0,392 # 80207588 <small_numbers+0x1138>
    80203408:	ffffd097          	auipc	ra,0xffffd
    8020340c:	74c080e7          	jalr	1868(ra) # 80200b54 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
    80203410:	fd043783          	ld	a5,-48(s0)
    80203414:	6f9c                	ld	a5,24(a5)
    80203416:	853e                	mv	a0,a5
    80203418:	fffff097          	auipc	ra,0xfffff
    8020341c:	478080e7          	jalr	1144(ra) # 80202890 <check_is_mapped>
    80203420:	87aa                	mv	a5,a0
    80203422:	cf89                	beqz	a5,8020343c <handle_exception+0x184>
    80203424:	fd043783          	ld	a5,-48(s0)
    80203428:	6f9c                	ld	a5,24(a5)
    8020342a:	4589                	li	a1,2
    8020342c:	853e                	mv	a0,a5
    8020342e:	fffff097          	auipc	ra,0xfffff
    80203432:	034080e7          	jalr	52(ra) # 80202462 <handle_page_fault>
    80203436:	87aa                	mv	a5,a0
    80203438:	14079a63          	bnez	a5,8020358c <handle_exception+0x2d4>
			set_sepc(tf, info->sepc + 4);
    8020343c:	fd043783          	ld	a5,-48(s0)
    80203440:	639c                	ld	a5,0(a5)
    80203442:	0791                	addi	a5,a5,4
    80203444:	85be                	mv	a1,a5
    80203446:	fd843503          	ld	a0,-40(s0)
    8020344a:	00000097          	auipc	ra,0x0
    8020344e:	aa4080e7          	jalr	-1372(ra) # 80202eee <set_sepc>
			break;
    80203452:	a281                	j	80203592 <handle_exception+0x2da>
            printf("Store address misaligned: 0x%lx\n", info->stval);
    80203454:	fd043783          	ld	a5,-48(s0)
    80203458:	6f9c                	ld	a5,24(a5)
    8020345a:	85be                	mv	a1,a5
    8020345c:	00004517          	auipc	a0,0x4
    80203460:	14c50513          	addi	a0,a0,332 # 802075a8 <small_numbers+0x1158>
    80203464:	ffffd097          	auipc	ra,0xffffd
    80203468:	6f0080e7          	jalr	1776(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4); 
    8020346c:	fd043783          	ld	a5,-48(s0)
    80203470:	639c                	ld	a5,0(a5)
    80203472:	0791                	addi	a5,a5,4
    80203474:	85be                	mv	a1,a5
    80203476:	fd843503          	ld	a0,-40(s0)
    8020347a:	00000097          	auipc	ra,0x0
    8020347e:	a74080e7          	jalr	-1420(ra) # 80202eee <set_sepc>
            break;
    80203482:	aa01                	j	80203592 <handle_exception+0x2da>
			printf("Store access fault: 0x%lx\n", info->stval);
    80203484:	fd043783          	ld	a5,-48(s0)
    80203488:	6f9c                	ld	a5,24(a5)
    8020348a:	85be                	mv	a1,a5
    8020348c:	00004517          	auipc	a0,0x4
    80203490:	14450513          	addi	a0,a0,324 # 802075d0 <small_numbers+0x1180>
    80203494:	ffffd097          	auipc	ra,0xffffd
    80203498:	6c0080e7          	jalr	1728(ra) # 80200b54 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
    8020349c:	fd043783          	ld	a5,-48(s0)
    802034a0:	6f9c                	ld	a5,24(a5)
    802034a2:	853e                	mv	a0,a5
    802034a4:	fffff097          	auipc	ra,0xfffff
    802034a8:	3ec080e7          	jalr	1004(ra) # 80202890 <check_is_mapped>
    802034ac:	87aa                	mv	a5,a0
    802034ae:	cf81                	beqz	a5,802034c6 <handle_exception+0x20e>
    802034b0:	fd043783          	ld	a5,-48(s0)
    802034b4:	6f9c                	ld	a5,24(a5)
    802034b6:	458d                	li	a1,3
    802034b8:	853e                	mv	a0,a5
    802034ba:	fffff097          	auipc	ra,0xfffff
    802034be:	fa8080e7          	jalr	-88(ra) # 80202462 <handle_page_fault>
    802034c2:	87aa                	mv	a5,a0
    802034c4:	e7f1                	bnez	a5,80203590 <handle_exception+0x2d8>
			set_sepc(tf, info->sepc + 4);
    802034c6:	fd043783          	ld	a5,-48(s0)
    802034ca:	639c                	ld	a5,0(a5)
    802034cc:	0791                	addi	a5,a5,4
    802034ce:	85be                	mv	a1,a5
    802034d0:	fd843503          	ld	a0,-40(s0)
    802034d4:	00000097          	auipc	ra,0x0
    802034d8:	a1a080e7          	jalr	-1510(ra) # 80202eee <set_sepc>
			break;
    802034dc:	a85d                	j	80203592 <handle_exception+0x2da>
            handle_syscall(tf,info);
    802034de:	fd043583          	ld	a1,-48(s0)
    802034e2:	fd843503          	ld	a0,-40(s0)
    802034e6:	00000097          	auipc	ra,0x0
    802034ea:	0b4080e7          	jalr	180(ra) # 8020359a <handle_syscall>
            break;
    802034ee:	a055                	j	80203592 <handle_exception+0x2da>
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    802034f0:	fd043783          	ld	a5,-48(s0)
    802034f4:	639c                	ld	a5,0(a5)
    802034f6:	85be                	mv	a1,a5
    802034f8:	00004517          	auipc	a0,0x4
    802034fc:	0f850513          	addi	a0,a0,248 # 802075f0 <small_numbers+0x11a0>
    80203500:	ffffd097          	auipc	ra,0xffffd
    80203504:	654080e7          	jalr	1620(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203508:	fd043783          	ld	a5,-48(s0)
    8020350c:	639c                	ld	a5,0(a5)
    8020350e:	0791                	addi	a5,a5,4
    80203510:	85be                	mv	a1,a5
    80203512:	fd843503          	ld	a0,-40(s0)
    80203516:	00000097          	auipc	ra,0x0
    8020351a:	9d8080e7          	jalr	-1576(ra) # 80202eee <set_sepc>
            break;
    8020351e:	a895                	j	80203592 <handle_exception+0x2da>
            handle_instruction_page_fault(tf,info);
    80203520:	fd043583          	ld	a1,-48(s0)
    80203524:	fd843503          	ld	a0,-40(s0)
    80203528:	00000097          	auipc	ra,0x0
    8020352c:	0c2080e7          	jalr	194(ra) # 802035ea <handle_instruction_page_fault>
            break;
    80203530:	a08d                	j	80203592 <handle_exception+0x2da>
            handle_load_page_fault(tf,info);
    80203532:	fd043583          	ld	a1,-48(s0)
    80203536:	fd843503          	ld	a0,-40(s0)
    8020353a:	00000097          	auipc	ra,0x0
    8020353e:	112080e7          	jalr	274(ra) # 8020364c <handle_load_page_fault>
            break;
    80203542:	a881                	j	80203592 <handle_exception+0x2da>
            handle_store_page_fault(tf,info);
    80203544:	fd043583          	ld	a1,-48(s0)
    80203548:	fd843503          	ld	a0,-40(s0)
    8020354c:	00000097          	auipc	ra,0x0
    80203550:	162080e7          	jalr	354(ra) # 802036ae <handle_store_page_fault>
            break;
    80203554:	a83d                	j	80203592 <handle_exception+0x2da>
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    80203556:	fd043783          	ld	a5,-48(s0)
    8020355a:	6398                	ld	a4,0(a5)
    8020355c:	fd043783          	ld	a5,-48(s0)
    80203560:	6f9c                	ld	a5,24(a5)
    80203562:	86be                	mv	a3,a5
    80203564:	863a                	mv	a2,a4
    80203566:	fe843583          	ld	a1,-24(s0)
    8020356a:	00004517          	auipc	a0,0x4
    8020356e:	0ae50513          	addi	a0,a0,174 # 80207618 <small_numbers+0x11c8>
    80203572:	ffffd097          	auipc	ra,0xffffd
    80203576:	5e2080e7          	jalr	1506(ra) # 80200b54 <printf>
            panic("Unknown exception");
    8020357a:	00004517          	auipc	a0,0x4
    8020357e:	0d650513          	addi	a0,a0,214 # 80207650 <small_numbers+0x1200>
    80203582:	ffffe097          	auipc	ra,0xffffe
    80203586:	eda080e7          	jalr	-294(ra) # 8020145c <panic>
            break;
    8020358a:	a021                	j	80203592 <handle_exception+0x2da>
				return; // 成功处理
    8020358c:	0001                	nop
    8020358e:	a011                	j	80203592 <handle_exception+0x2da>
				return; // 成功处理
    80203590:	0001                	nop
}
    80203592:	70a2                	ld	ra,40(sp)
    80203594:	7402                	ld	s0,32(sp)
    80203596:	6145                	addi	sp,sp,48
    80203598:	8082                	ret

000000008020359a <handle_syscall>:
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    8020359a:	1101                	addi	sp,sp,-32
    8020359c:	ec06                	sd	ra,24(sp)
    8020359e:	e822                	sd	s0,16(sp)
    802035a0:	1000                	addi	s0,sp,32
    802035a2:	fea43423          	sd	a0,-24(s0)
    802035a6:	feb43023          	sd	a1,-32(s0)
    printf("System call from sepc=0x%lx, syscall number=%ld\n", info->sepc, tf->a7);
    802035aa:	fe043783          	ld	a5,-32(s0)
    802035ae:	6398                	ld	a4,0(a5)
    802035b0:	fe843783          	ld	a5,-24(s0)
    802035b4:	77dc                	ld	a5,168(a5)
    802035b6:	863e                	mv	a2,a5
    802035b8:	85ba                	mv	a1,a4
    802035ba:	00004517          	auipc	a0,0x4
    802035be:	0ee50513          	addi	a0,a0,238 # 802076a8 <small_numbers+0x1258>
    802035c2:	ffffd097          	auipc	ra,0xffffd
    802035c6:	592080e7          	jalr	1426(ra) # 80200b54 <printf>
    set_sepc(tf, info->sepc + 4);
    802035ca:	fe043783          	ld	a5,-32(s0)
    802035ce:	639c                	ld	a5,0(a5)
    802035d0:	0791                	addi	a5,a5,4
    802035d2:	85be                	mv	a1,a5
    802035d4:	fe843503          	ld	a0,-24(s0)
    802035d8:	00000097          	auipc	ra,0x0
    802035dc:	916080e7          	jalr	-1770(ra) # 80202eee <set_sepc>
}
    802035e0:	0001                	nop
    802035e2:	60e2                	ld	ra,24(sp)
    802035e4:	6442                	ld	s0,16(sp)
    802035e6:	6105                	addi	sp,sp,32
    802035e8:	8082                	ret

00000000802035ea <handle_instruction_page_fault>:
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    802035ea:	1101                	addi	sp,sp,-32
    802035ec:	ec06                	sd	ra,24(sp)
    802035ee:	e822                	sd	s0,16(sp)
    802035f0:	1000                	addi	s0,sp,32
    802035f2:	fea43423          	sd	a0,-24(s0)
    802035f6:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802035fa:	fe043783          	ld	a5,-32(s0)
    802035fe:	6f98                	ld	a4,24(a5)
    80203600:	fe043783          	ld	a5,-32(s0)
    80203604:	639c                	ld	a5,0(a5)
    80203606:	863e                	mv	a2,a5
    80203608:	85ba                	mv	a1,a4
    8020360a:	00004517          	auipc	a0,0x4
    8020360e:	0d650513          	addi	a0,a0,214 # 802076e0 <small_numbers+0x1290>
    80203612:	ffffd097          	auipc	ra,0xffffd
    80203616:	542080e7          	jalr	1346(ra) # 80200b54 <printf>
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    8020361a:	fe043783          	ld	a5,-32(s0)
    8020361e:	6f9c                	ld	a5,24(a5)
    80203620:	4585                	li	a1,1
    80203622:	853e                	mv	a0,a5
    80203624:	fffff097          	auipc	ra,0xfffff
    80203628:	e3e080e7          	jalr	-450(ra) # 80202462 <handle_page_fault>
    8020362c:	87aa                	mv	a5,a0
    8020362e:	eb91                	bnez	a5,80203642 <handle_instruction_page_fault+0x58>
    panic("Unhandled instruction page fault");
    80203630:	00004517          	auipc	a0,0x4
    80203634:	0e050513          	addi	a0,a0,224 # 80207710 <small_numbers+0x12c0>
    80203638:	ffffe097          	auipc	ra,0xffffe
    8020363c:	e24080e7          	jalr	-476(ra) # 8020145c <panic>
    80203640:	a011                	j	80203644 <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80203642:	0001                	nop
}
    80203644:	60e2                	ld	ra,24(sp)
    80203646:	6442                	ld	s0,16(sp)
    80203648:	6105                	addi	sp,sp,32
    8020364a:	8082                	ret

000000008020364c <handle_load_page_fault>:
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    8020364c:	1101                	addi	sp,sp,-32
    8020364e:	ec06                	sd	ra,24(sp)
    80203650:	e822                	sd	s0,16(sp)
    80203652:	1000                	addi	s0,sp,32
    80203654:	fea43423          	sd	a0,-24(s0)
    80203658:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    8020365c:	fe043783          	ld	a5,-32(s0)
    80203660:	6f98                	ld	a4,24(a5)
    80203662:	fe043783          	ld	a5,-32(s0)
    80203666:	639c                	ld	a5,0(a5)
    80203668:	863e                	mv	a2,a5
    8020366a:	85ba                	mv	a1,a4
    8020366c:	00004517          	auipc	a0,0x4
    80203670:	0cc50513          	addi	a0,a0,204 # 80207738 <small_numbers+0x12e8>
    80203674:	ffffd097          	auipc	ra,0xffffd
    80203678:	4e0080e7          	jalr	1248(ra) # 80200b54 <printf>
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    8020367c:	fe043783          	ld	a5,-32(s0)
    80203680:	6f9c                	ld	a5,24(a5)
    80203682:	4589                	li	a1,2
    80203684:	853e                	mv	a0,a5
    80203686:	fffff097          	auipc	ra,0xfffff
    8020368a:	ddc080e7          	jalr	-548(ra) # 80202462 <handle_page_fault>
    8020368e:	87aa                	mv	a5,a0
    80203690:	eb91                	bnez	a5,802036a4 <handle_load_page_fault+0x58>
    panic("Unhandled load page fault");
    80203692:	00004517          	auipc	a0,0x4
    80203696:	0d650513          	addi	a0,a0,214 # 80207768 <small_numbers+0x1318>
    8020369a:	ffffe097          	auipc	ra,0xffffe
    8020369e:	dc2080e7          	jalr	-574(ra) # 8020145c <panic>
    802036a2:	a011                	j	802036a6 <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802036a4:	0001                	nop
}
    802036a6:	60e2                	ld	ra,24(sp)
    802036a8:	6442                	ld	s0,16(sp)
    802036aa:	6105                	addi	sp,sp,32
    802036ac:	8082                	ret

00000000802036ae <handle_store_page_fault>:
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    802036ae:	1101                	addi	sp,sp,-32
    802036b0:	ec06                	sd	ra,24(sp)
    802036b2:	e822                	sd	s0,16(sp)
    802036b4:	1000                	addi	s0,sp,32
    802036b6:	fea43423          	sd	a0,-24(s0)
    802036ba:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802036be:	fe043783          	ld	a5,-32(s0)
    802036c2:	6f98                	ld	a4,24(a5)
    802036c4:	fe043783          	ld	a5,-32(s0)
    802036c8:	639c                	ld	a5,0(a5)
    802036ca:	863e                	mv	a2,a5
    802036cc:	85ba                	mv	a1,a4
    802036ce:	00004517          	auipc	a0,0x4
    802036d2:	0ba50513          	addi	a0,a0,186 # 80207788 <small_numbers+0x1338>
    802036d6:	ffffd097          	auipc	ra,0xffffd
    802036da:	47e080e7          	jalr	1150(ra) # 80200b54 <printf>
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    802036de:	fe043783          	ld	a5,-32(s0)
    802036e2:	6f9c                	ld	a5,24(a5)
    802036e4:	458d                	li	a1,3
    802036e6:	853e                	mv	a0,a5
    802036e8:	fffff097          	auipc	ra,0xfffff
    802036ec:	d7a080e7          	jalr	-646(ra) # 80202462 <handle_page_fault>
    802036f0:	87aa                	mv	a5,a0
    802036f2:	eb91                	bnez	a5,80203706 <handle_store_page_fault+0x58>
    panic("Unhandled store page fault");
    802036f4:	00004517          	auipc	a0,0x4
    802036f8:	0c450513          	addi	a0,a0,196 # 802077b8 <small_numbers+0x1368>
    802036fc:	ffffe097          	auipc	ra,0xffffe
    80203700:	d60080e7          	jalr	-672(ra) # 8020145c <panic>
    80203704:	a011                	j	80203708 <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80203706:	0001                	nop
}
    80203708:	60e2                	ld	ra,24(sp)
    8020370a:	6442                	ld	s0,16(sp)
    8020370c:	6105                	addi	sp,sp,32
    8020370e:	8082                	ret

0000000080203710 <get_time>:
uint64 get_time(void) {
    80203710:	1141                	addi	sp,sp,-16
    80203712:	e406                	sd	ra,8(sp)
    80203714:	e022                	sd	s0,0(sp)
    80203716:	0800                	addi	s0,sp,16
    return sbi_get_time();
    80203718:	fffff097          	auipc	ra,0xfffff
    8020371c:	638080e7          	jalr	1592(ra) # 80202d50 <sbi_get_time>
    80203720:	87aa                	mv	a5,a0
}
    80203722:	853e                	mv	a0,a5
    80203724:	60a2                	ld	ra,8(sp)
    80203726:	6402                	ld	s0,0(sp)
    80203728:	0141                	addi	sp,sp,16
    8020372a:	8082                	ret

000000008020372c <test_timer_interrupt>:
void test_timer_interrupt(void) {
    8020372c:	7179                	addi	sp,sp,-48
    8020372e:	f406                	sd	ra,40(sp)
    80203730:	f022                	sd	s0,32(sp)
    80203732:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    80203734:	00004517          	auipc	a0,0x4
    80203738:	0a450513          	addi	a0,a0,164 # 802077d8 <small_numbers+0x1388>
    8020373c:	ffffd097          	auipc	ra,0xffffd
    80203740:	418080e7          	jalr	1048(ra) # 80200b54 <printf>
    uint64 start_time = get_time();
    80203744:	00000097          	auipc	ra,0x0
    80203748:	fcc080e7          	jalr	-52(ra) # 80203710 <get_time>
    8020374c:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    80203750:	fc042a23          	sw	zero,-44(s0)
	int last_count = interrupt_count;
    80203754:	fd442783          	lw	a5,-44(s0)
    80203758:	fef42623          	sw	a5,-20(s0)
    interrupt_test_flag = &interrupt_count;
    8020375c:	00007797          	auipc	a5,0x7
    80203760:	92c78793          	addi	a5,a5,-1748 # 8020a088 <interrupt_test_flag>
    80203764:	fd440713          	addi	a4,s0,-44
    80203768:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    8020376a:	a899                	j	802037c0 <test_timer_interrupt+0x94>
        if(last_count != interrupt_count) {
    8020376c:	fd442703          	lw	a4,-44(s0)
    80203770:	fec42783          	lw	a5,-20(s0)
    80203774:	2781                	sext.w	a5,a5
    80203776:	02e78163          	beq	a5,a4,80203798 <test_timer_interrupt+0x6c>
			last_count = interrupt_count;
    8020377a:	fd442783          	lw	a5,-44(s0)
    8020377e:	fef42623          	sw	a5,-20(s0)
			printf("Received interrupt %d\n", interrupt_count);
    80203782:	fd442783          	lw	a5,-44(s0)
    80203786:	85be                	mv	a1,a5
    80203788:	00004517          	auipc	a0,0x4
    8020378c:	07050513          	addi	a0,a0,112 # 802077f8 <small_numbers+0x13a8>
    80203790:	ffffd097          	auipc	ra,0xffffd
    80203794:	3c4080e7          	jalr	964(ra) # 80200b54 <printf>
        for (volatile int i = 0; i < 1000000; i++);
    80203798:	fc042823          	sw	zero,-48(s0)
    8020379c:	a801                	j	802037ac <test_timer_interrupt+0x80>
    8020379e:	fd042783          	lw	a5,-48(s0)
    802037a2:	2781                	sext.w	a5,a5
    802037a4:	2785                	addiw	a5,a5,1
    802037a6:	2781                	sext.w	a5,a5
    802037a8:	fcf42823          	sw	a5,-48(s0)
    802037ac:	fd042783          	lw	a5,-48(s0)
    802037b0:	2781                	sext.w	a5,a5
    802037b2:	873e                	mv	a4,a5
    802037b4:	000f47b7          	lui	a5,0xf4
    802037b8:	23f78793          	addi	a5,a5,575 # f423f <userret+0xf41a3>
    802037bc:	fee7d1e3          	bge	a5,a4,8020379e <test_timer_interrupt+0x72>
    while (interrupt_count < 5) {
    802037c0:	fd442783          	lw	a5,-44(s0)
    802037c4:	873e                	mv	a4,a5
    802037c6:	4791                	li	a5,4
    802037c8:	fae7d2e3          	bge	a5,a4,8020376c <test_timer_interrupt+0x40>
    interrupt_test_flag = 0;
    802037cc:	00007797          	auipc	a5,0x7
    802037d0:	8bc78793          	addi	a5,a5,-1860 # 8020a088 <interrupt_test_flag>
    802037d4:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    802037d8:	00000097          	auipc	ra,0x0
    802037dc:	f38080e7          	jalr	-200(ra) # 80203710 <get_time>
    802037e0:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    802037e4:	fd442683          	lw	a3,-44(s0)
    802037e8:	fd843703          	ld	a4,-40(s0)
    802037ec:	fe043783          	ld	a5,-32(s0)
    802037f0:	40f707b3          	sub	a5,a4,a5
    802037f4:	863e                	mv	a2,a5
    802037f6:	85b6                	mv	a1,a3
    802037f8:	00004517          	auipc	a0,0x4
    802037fc:	01850513          	addi	a0,a0,24 # 80207810 <small_numbers+0x13c0>
    80203800:	ffffd097          	auipc	ra,0xffffd
    80203804:	354080e7          	jalr	852(ra) # 80200b54 <printf>
}
    80203808:	0001                	nop
    8020380a:	70a2                	ld	ra,40(sp)
    8020380c:	7402                	ld	s0,32(sp)
    8020380e:	6145                	addi	sp,sp,48
    80203810:	8082                	ret

0000000080203812 <test_exception>:
void test_exception(void) {
    80203812:	715d                	addi	sp,sp,-80
    80203814:	e486                	sd	ra,72(sp)
    80203816:	e0a2                	sd	s0,64(sp)
    80203818:	0880                	addi	s0,sp,80
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    8020381a:	00004517          	auipc	a0,0x4
    8020381e:	02e50513          	addi	a0,a0,46 # 80207848 <small_numbers+0x13f8>
    80203822:	ffffd097          	auipc	ra,0xffffd
    80203826:	332080e7          	jalr	818(ra) # 80200b54 <printf>
    printf("1. 测试非法指令异常...\n");
    8020382a:	00004517          	auipc	a0,0x4
    8020382e:	04e50513          	addi	a0,a0,78 # 80207878 <small_numbers+0x1428>
    80203832:	ffffd097          	auipc	ra,0xffffd
    80203836:	322080e7          	jalr	802(ra) # 80200b54 <printf>
    8020383a:	ffffffff          	.word	0xffffffff
    printf("✓ 非法指令异常处理成功\n\n");
    8020383e:	00004517          	auipc	a0,0x4
    80203842:	05a50513          	addi	a0,a0,90 # 80207898 <small_numbers+0x1448>
    80203846:	ffffd097          	auipc	ra,0xffffd
    8020384a:	30e080e7          	jalr	782(ra) # 80200b54 <printf>
    printf("2. 测试存储页故障异常...\n");
    8020384e:	00004517          	auipc	a0,0x4
    80203852:	07250513          	addi	a0,a0,114 # 802078c0 <small_numbers+0x1470>
    80203856:	ffffd097          	auipc	ra,0xffffd
    8020385a:	2fe080e7          	jalr	766(ra) # 80200b54 <printf>
    volatile uint64 *invalid_ptr = 0;
    8020385e:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80203862:	47a5                	li	a5,9
    80203864:	07f2                	slli	a5,a5,0x1c
    80203866:	fef43023          	sd	a5,-32(s0)
    8020386a:	a835                	j	802038a6 <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    8020386c:	fe043503          	ld	a0,-32(s0)
    80203870:	fffff097          	auipc	ra,0xfffff
    80203874:	020080e7          	jalr	32(ra) # 80202890 <check_is_mapped>
    80203878:	87aa                	mv	a5,a0
    8020387a:	e385                	bnez	a5,8020389a <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    8020387c:	fe043783          	ld	a5,-32(s0)
    80203880:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80203884:	fe043583          	ld	a1,-32(s0)
    80203888:	00004517          	auipc	a0,0x4
    8020388c:	06050513          	addi	a0,a0,96 # 802078e8 <small_numbers+0x1498>
    80203890:	ffffd097          	auipc	ra,0xffffd
    80203894:	2c4080e7          	jalr	708(ra) # 80200b54 <printf>
            break;
    80203898:	a829                	j	802038b2 <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    8020389a:	fe043703          	ld	a4,-32(s0)
    8020389e:	6785                	lui	a5,0x1
    802038a0:	97ba                	add	a5,a5,a4
    802038a2:	fef43023          	sd	a5,-32(s0)
    802038a6:	fe043703          	ld	a4,-32(s0)
    802038aa:	47cd                	li	a5,19
    802038ac:	07ee                	slli	a5,a5,0x1b
    802038ae:	faf76fe3          	bltu	a4,a5,8020386c <test_exception+0x5a>
    if (invalid_ptr != 0) {
    802038b2:	fe843783          	ld	a5,-24(s0)
    802038b6:	cb95                	beqz	a5,802038ea <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    802038b8:	fe843783          	ld	a5,-24(s0)
    802038bc:	85be                	mv	a1,a5
    802038be:	00004517          	auipc	a0,0x4
    802038c2:	04a50513          	addi	a0,a0,74 # 80207908 <small_numbers+0x14b8>
    802038c6:	ffffd097          	auipc	ra,0xffffd
    802038ca:	28e080e7          	jalr	654(ra) # 80200b54 <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    802038ce:	fe843783          	ld	a5,-24(s0)
    802038d2:	02a00713          	li	a4,42
    802038d6:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    802038d8:	00004517          	auipc	a0,0x4
    802038dc:	06050513          	addi	a0,a0,96 # 80207938 <small_numbers+0x14e8>
    802038e0:	ffffd097          	auipc	ra,0xffffd
    802038e4:	274080e7          	jalr	628(ra) # 80200b54 <printf>
    802038e8:	a809                	j	802038fa <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    802038ea:	00004517          	auipc	a0,0x4
    802038ee:	07650513          	addi	a0,a0,118 # 80207960 <small_numbers+0x1510>
    802038f2:	ffffd097          	auipc	ra,0xffffd
    802038f6:	262080e7          	jalr	610(ra) # 80200b54 <printf>
    printf("3. 测试加载页故障异常...\n");
    802038fa:	00004517          	auipc	a0,0x4
    802038fe:	09e50513          	addi	a0,a0,158 # 80207998 <small_numbers+0x1548>
    80203902:	ffffd097          	auipc	ra,0xffffd
    80203906:	252080e7          	jalr	594(ra) # 80200b54 <printf>
    invalid_ptr = 0;
    8020390a:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    8020390e:	4795                	li	a5,5
    80203910:	07f6                	slli	a5,a5,0x1d
    80203912:	fcf43c23          	sd	a5,-40(s0)
    80203916:	a835                	j	80203952 <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    80203918:	fd843503          	ld	a0,-40(s0)
    8020391c:	fffff097          	auipc	ra,0xfffff
    80203920:	f74080e7          	jalr	-140(ra) # 80202890 <check_is_mapped>
    80203924:	87aa                	mv	a5,a0
    80203926:	e385                	bnez	a5,80203946 <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    80203928:	fd843783          	ld	a5,-40(s0)
    8020392c:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80203930:	fd843583          	ld	a1,-40(s0)
    80203934:	00004517          	auipc	a0,0x4
    80203938:	fb450513          	addi	a0,a0,-76 # 802078e8 <small_numbers+0x1498>
    8020393c:	ffffd097          	auipc	ra,0xffffd
    80203940:	218080e7          	jalr	536(ra) # 80200b54 <printf>
            break;
    80203944:	a829                	j	8020395e <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80203946:	fd843703          	ld	a4,-40(s0)
    8020394a:	6785                	lui	a5,0x1
    8020394c:	97ba                	add	a5,a5,a4
    8020394e:	fcf43c23          	sd	a5,-40(s0)
    80203952:	fd843703          	ld	a4,-40(s0)
    80203956:	47d5                	li	a5,21
    80203958:	07ee                	slli	a5,a5,0x1b
    8020395a:	faf76fe3          	bltu	a4,a5,80203918 <test_exception+0x106>
    if (invalid_ptr != 0) {
    8020395e:	fe843783          	ld	a5,-24(s0)
    80203962:	c7a9                	beqz	a5,802039ac <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80203964:	fe843783          	ld	a5,-24(s0)
    80203968:	85be                	mv	a1,a5
    8020396a:	00004517          	auipc	a0,0x4
    8020396e:	05650513          	addi	a0,a0,86 # 802079c0 <small_numbers+0x1570>
    80203972:	ffffd097          	auipc	ra,0xffffd
    80203976:	1e2080e7          	jalr	482(ra) # 80200b54 <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    8020397a:	fe843783          	ld	a5,-24(s0)
    8020397e:	639c                	ld	a5,0(a5)
    80203980:	faf43823          	sd	a5,-80(s0)
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    80203984:	fb043783          	ld	a5,-80(s0)
    80203988:	85be                	mv	a1,a5
    8020398a:	00004517          	auipc	a0,0x4
    8020398e:	06650513          	addi	a0,a0,102 # 802079f0 <small_numbers+0x15a0>
    80203992:	ffffd097          	auipc	ra,0xffffd
    80203996:	1c2080e7          	jalr	450(ra) # 80200b54 <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    8020399a:	00004517          	auipc	a0,0x4
    8020399e:	06e50513          	addi	a0,a0,110 # 80207a08 <small_numbers+0x15b8>
    802039a2:	ffffd097          	auipc	ra,0xffffd
    802039a6:	1b2080e7          	jalr	434(ra) # 80200b54 <printf>
    802039aa:	a809                	j	802039bc <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    802039ac:	00004517          	auipc	a0,0x4
    802039b0:	fb450513          	addi	a0,a0,-76 # 80207960 <small_numbers+0x1510>
    802039b4:	ffffd097          	auipc	ra,0xffffd
    802039b8:	1a0080e7          	jalr	416(ra) # 80200b54 <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    802039bc:	00004517          	auipc	a0,0x4
    802039c0:	07450513          	addi	a0,a0,116 # 80207a30 <small_numbers+0x15e0>
    802039c4:	ffffd097          	auipc	ra,0xffffd
    802039c8:	190080e7          	jalr	400(ra) # 80200b54 <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    802039cc:	fffff097          	auipc	ra,0xfffff
    802039d0:	0e4080e7          	jalr	228(ra) # 80202ab0 <alloc_page>
    802039d4:	87aa                	mv	a5,a0
    802039d6:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    802039da:	fd043783          	ld	a5,-48(s0)
    802039de:	c3a1                	beqz	a5,80203a1e <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    802039e0:	fd043783          	ld	a5,-48(s0)
    802039e4:	0785                	addi	a5,a5,1 # 1001 <userret+0xf65>
    802039e6:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    802039ea:	fc843583          	ld	a1,-56(s0)
    802039ee:	00004517          	auipc	a0,0x4
    802039f2:	07250513          	addi	a0,a0,114 # 80207a60 <small_numbers+0x1610>
    802039f6:	ffffd097          	auipc	ra,0xffffd
    802039fa:	15e080e7          	jalr	350(ra) # 80200b54 <printf>
        asm volatile (
    802039fe:	deadc7b7          	lui	a5,0xdeadc
    80203a02:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8d019f>
    80203a06:	fc843703          	ld	a4,-56(s0)
    80203a0a:	e31c                	sd	a5,0(a4)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    80203a0c:	00004517          	auipc	a0,0x4
    80203a10:	07450513          	addi	a0,a0,116 # 80207a80 <small_numbers+0x1630>
    80203a14:	ffffd097          	auipc	ra,0xffffd
    80203a18:	140080e7          	jalr	320(ra) # 80200b54 <printf>
    80203a1c:	a809                	j	80203a2e <test_exception+0x21c>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80203a1e:	00004517          	auipc	a0,0x4
    80203a22:	09250513          	addi	a0,a0,146 # 80207ab0 <small_numbers+0x1660>
    80203a26:	ffffd097          	auipc	ra,0xffffd
    80203a2a:	12e080e7          	jalr	302(ra) # 80200b54 <printf>
    printf("5. 测试加载地址未对齐异常...\n");
    80203a2e:	00004517          	auipc	a0,0x4
    80203a32:	0c250513          	addi	a0,a0,194 # 80207af0 <small_numbers+0x16a0>
    80203a36:	ffffd097          	auipc	ra,0xffffd
    80203a3a:	11e080e7          	jalr	286(ra) # 80200b54 <printf>
    if (aligned_addr != 0) {
    80203a3e:	fd043783          	ld	a5,-48(s0)
    80203a42:	cbb1                	beqz	a5,80203a96 <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    80203a44:	fd043783          	ld	a5,-48(s0)
    80203a48:	0785                	addi	a5,a5,1
    80203a4a:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80203a4e:	fc043583          	ld	a1,-64(s0)
    80203a52:	00004517          	auipc	a0,0x4
    80203a56:	00e50513          	addi	a0,a0,14 # 80207a60 <small_numbers+0x1610>
    80203a5a:	ffffd097          	auipc	ra,0xffffd
    80203a5e:	0fa080e7          	jalr	250(ra) # 80200b54 <printf>
        uint64 value = 0;
    80203a62:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    80203a66:	fc043783          	ld	a5,-64(s0)
    80203a6a:	639c                	ld	a5,0(a5)
    80203a6c:	faf43c23          	sd	a5,-72(s0)
        printf("读取的值: 0x%lx\n", value);
    80203a70:	fb843583          	ld	a1,-72(s0)
    80203a74:	00004517          	auipc	a0,0x4
    80203a78:	0ac50513          	addi	a0,a0,172 # 80207b20 <small_numbers+0x16d0>
    80203a7c:	ffffd097          	auipc	ra,0xffffd
    80203a80:	0d8080e7          	jalr	216(ra) # 80200b54 <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80203a84:	00004517          	auipc	a0,0x4
    80203a88:	0b450513          	addi	a0,a0,180 # 80207b38 <small_numbers+0x16e8>
    80203a8c:	ffffd097          	auipc	ra,0xffffd
    80203a90:	0c8080e7          	jalr	200(ra) # 80200b54 <printf>
    80203a94:	a809                	j	80203aa6 <test_exception+0x294>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80203a96:	00004517          	auipc	a0,0x4
    80203a9a:	01a50513          	addi	a0,a0,26 # 80207ab0 <small_numbers+0x1660>
    80203a9e:	ffffd097          	auipc	ra,0xffffd
    80203aa2:	0b6080e7          	jalr	182(ra) # 80200b54 <printf>
	// 6. 测试断点异常
	printf("6. 测试断点异常...\n");
    80203aa6:	00004517          	auipc	a0,0x4
    80203aaa:	0c250513          	addi	a0,a0,194 # 80207b68 <small_numbers+0x1718>
    80203aae:	ffffd097          	auipc	ra,0xffffd
    80203ab2:	0a6080e7          	jalr	166(ra) # 80200b54 <printf>
	asm volatile (
    80203ab6:	0001                	nop
    80203ab8:	9002                	ebreak
    80203aba:	0001                	nop
		"nop\n\t"      // 确保ebreak前有有效指令
		"ebreak\n\t"   // 断点指令
		"nop\n\t"      // 确保ebreak后有有效指令
	);
	printf("✓ 断点异常处理成功\n\n");
    80203abc:	00004517          	auipc	a0,0x4
    80203ac0:	0cc50513          	addi	a0,a0,204 # 80207b88 <small_numbers+0x1738>
    80203ac4:	ffffd097          	auipc	ra,0xffffd
    80203ac8:	090080e7          	jalr	144(ra) # 80200b54 <printf>
    // 7. 测试环境调用异常
    printf("7. 测试环境调用异常...\n");
    80203acc:	00004517          	auipc	a0,0x4
    80203ad0:	0dc50513          	addi	a0,a0,220 # 80207ba8 <small_numbers+0x1758>
    80203ad4:	ffffd097          	auipc	ra,0xffffd
    80203ad8:	080080e7          	jalr	128(ra) # 80200b54 <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    80203adc:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    80203ae0:	00004517          	auipc	a0,0x4
    80203ae4:	0e850513          	addi	a0,a0,232 # 80207bc8 <small_numbers+0x1778>
    80203ae8:	ffffd097          	auipc	ra,0xffffd
    80203aec:	06c080e7          	jalr	108(ra) # 80200b54 <printf>
    
    printf("===== 异常处理测试完成 =====\n\n");
    80203af0:	00004517          	auipc	a0,0x4
    80203af4:	10050513          	addi	a0,a0,256 # 80207bf0 <small_numbers+0x17a0>
    80203af8:	ffffd097          	auipc	ra,0xffffd
    80203afc:	05c080e7          	jalr	92(ra) # 80200b54 <printf>
}
    80203b00:	0001                	nop
    80203b02:	60a6                	ld	ra,72(sp)
    80203b04:	6406                	ld	s0,64(sp)
    80203b06:	6161                	addi	sp,sp,80
    80203b08:	8082                	ret

0000000080203b0a <write32>:
    80203b0a:	7179                	addi	sp,sp,-48
    80203b0c:	f406                	sd	ra,40(sp)
    80203b0e:	f022                	sd	s0,32(sp)
    80203b10:	1800                	addi	s0,sp,48
    80203b12:	fca43c23          	sd	a0,-40(s0)
    80203b16:	87ae                	mv	a5,a1
    80203b18:	fcf42a23          	sw	a5,-44(s0)
    80203b1c:	fd843783          	ld	a5,-40(s0)
    80203b20:	8b8d                	andi	a5,a5,3
    80203b22:	eb99                	bnez	a5,80203b38 <write32+0x2e>
    80203b24:	fd843783          	ld	a5,-40(s0)
    80203b28:	fef43423          	sd	a5,-24(s0)
    80203b2c:	fe843783          	ld	a5,-24(s0)
    80203b30:	fd442703          	lw	a4,-44(s0)
    80203b34:	c398                	sw	a4,0(a5)
    80203b36:	a819                	j	80203b4c <write32+0x42>
    80203b38:	fd843583          	ld	a1,-40(s0)
    80203b3c:	00004517          	auipc	a0,0x4
    80203b40:	0dc50513          	addi	a0,a0,220 # 80207c18 <small_numbers+0x17c8>
    80203b44:	ffffd097          	auipc	ra,0xffffd
    80203b48:	010080e7          	jalr	16(ra) # 80200b54 <printf>
    80203b4c:	0001                	nop
    80203b4e:	70a2                	ld	ra,40(sp)
    80203b50:	7402                	ld	s0,32(sp)
    80203b52:	6145                	addi	sp,sp,48
    80203b54:	8082                	ret

0000000080203b56 <read32>:
    80203b56:	7179                	addi	sp,sp,-48
    80203b58:	f406                	sd	ra,40(sp)
    80203b5a:	f022                	sd	s0,32(sp)
    80203b5c:	1800                	addi	s0,sp,48
    80203b5e:	fca43c23          	sd	a0,-40(s0)
    80203b62:	fd843783          	ld	a5,-40(s0)
    80203b66:	8b8d                	andi	a5,a5,3
    80203b68:	eb91                	bnez	a5,80203b7c <read32+0x26>
    80203b6a:	fd843783          	ld	a5,-40(s0)
    80203b6e:	fef43423          	sd	a5,-24(s0)
    80203b72:	fe843783          	ld	a5,-24(s0)
    80203b76:	439c                	lw	a5,0(a5)
    80203b78:	2781                	sext.w	a5,a5
    80203b7a:	a821                	j	80203b92 <read32+0x3c>
    80203b7c:	fd843583          	ld	a1,-40(s0)
    80203b80:	00004517          	auipc	a0,0x4
    80203b84:	0c850513          	addi	a0,a0,200 # 80207c48 <small_numbers+0x17f8>
    80203b88:	ffffd097          	auipc	ra,0xffffd
    80203b8c:	fcc080e7          	jalr	-52(ra) # 80200b54 <printf>
    80203b90:	4781                	li	a5,0
    80203b92:	853e                	mv	a0,a5
    80203b94:	70a2                	ld	ra,40(sp)
    80203b96:	7402                	ld	s0,32(sp)
    80203b98:	6145                	addi	sp,sp,48
    80203b9a:	8082                	ret

0000000080203b9c <plic_init>:
void plic_init(void) {
    80203b9c:	1101                	addi	sp,sp,-32
    80203b9e:	ec06                	sd	ra,24(sp)
    80203ba0:	e822                	sd	s0,16(sp)
    80203ba2:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80203ba4:	4785                	li	a5,1
    80203ba6:	fef42623          	sw	a5,-20(s0)
    80203baa:	a805                	j	80203bda <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    80203bac:	fec42783          	lw	a5,-20(s0)
    80203bb0:	0027979b          	slliw	a5,a5,0x2
    80203bb4:	2781                	sext.w	a5,a5
    80203bb6:	873e                	mv	a4,a5
    80203bb8:	0c0007b7          	lui	a5,0xc000
    80203bbc:	97ba                	add	a5,a5,a4
    80203bbe:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80203bc2:	4581                	li	a1,0
    80203bc4:	fe043503          	ld	a0,-32(s0)
    80203bc8:	00000097          	auipc	ra,0x0
    80203bcc:	f42080e7          	jalr	-190(ra) # 80203b0a <write32>
    for (int i = 1; i <= 32; i++) {
    80203bd0:	fec42783          	lw	a5,-20(s0)
    80203bd4:	2785                	addiw	a5,a5,1 # c000001 <userret+0xbffff65>
    80203bd6:	fef42623          	sw	a5,-20(s0)
    80203bda:	fec42783          	lw	a5,-20(s0)
    80203bde:	0007871b          	sext.w	a4,a5
    80203be2:	02000793          	li	a5,32
    80203be6:	fce7d3e3          	bge	a5,a4,80203bac <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    80203bea:	4585                	li	a1,1
    80203bec:	0c0007b7          	lui	a5,0xc000
    80203bf0:	02878513          	addi	a0,a5,40 # c000028 <userret+0xbffff8c>
    80203bf4:	00000097          	auipc	ra,0x0
    80203bf8:	f16080e7          	jalr	-234(ra) # 80203b0a <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    80203bfc:	4585                	li	a1,1
    80203bfe:	0c0007b7          	lui	a5,0xc000
    80203c02:	00478513          	addi	a0,a5,4 # c000004 <userret+0xbffff68>
    80203c06:	00000097          	auipc	ra,0x0
    80203c0a:	f04080e7          	jalr	-252(ra) # 80203b0a <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    80203c0e:	40200593          	li	a1,1026
    80203c12:	0c0027b7          	lui	a5,0xc002
    80203c16:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203c1a:	00000097          	auipc	ra,0x0
    80203c1e:	ef0080e7          	jalr	-272(ra) # 80203b0a <write32>
    write32(PLIC_THRESHOLD, 0);
    80203c22:	4581                	li	a1,0
    80203c24:	0c201537          	lui	a0,0xc201
    80203c28:	00000097          	auipc	ra,0x0
    80203c2c:	ee2080e7          	jalr	-286(ra) # 80203b0a <write32>
}
    80203c30:	0001                	nop
    80203c32:	60e2                	ld	ra,24(sp)
    80203c34:	6442                	ld	s0,16(sp)
    80203c36:	6105                	addi	sp,sp,32
    80203c38:	8082                	ret

0000000080203c3a <plic_enable>:
void plic_enable(int irq) {
    80203c3a:	7179                	addi	sp,sp,-48
    80203c3c:	f406                	sd	ra,40(sp)
    80203c3e:	f022                	sd	s0,32(sp)
    80203c40:	1800                	addi	s0,sp,48
    80203c42:	87aa                	mv	a5,a0
    80203c44:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80203c48:	0c0027b7          	lui	a5,0xc002
    80203c4c:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203c50:	00000097          	auipc	ra,0x0
    80203c54:	f06080e7          	jalr	-250(ra) # 80203b56 <read32>
    80203c58:	87aa                	mv	a5,a0
    80203c5a:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    80203c5e:	fdc42783          	lw	a5,-36(s0)
    80203c62:	873e                	mv	a4,a5
    80203c64:	4785                	li	a5,1
    80203c66:	00e797bb          	sllw	a5,a5,a4
    80203c6a:	2781                	sext.w	a5,a5
    80203c6c:	2781                	sext.w	a5,a5
    80203c6e:	fec42703          	lw	a4,-20(s0)
    80203c72:	8fd9                	or	a5,a5,a4
    80203c74:	2781                	sext.w	a5,a5
    80203c76:	85be                	mv	a1,a5
    80203c78:	0c0027b7          	lui	a5,0xc002
    80203c7c:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203c80:	00000097          	auipc	ra,0x0
    80203c84:	e8a080e7          	jalr	-374(ra) # 80203b0a <write32>
}
    80203c88:	0001                	nop
    80203c8a:	70a2                	ld	ra,40(sp)
    80203c8c:	7402                	ld	s0,32(sp)
    80203c8e:	6145                	addi	sp,sp,48
    80203c90:	8082                	ret

0000000080203c92 <plic_disable>:
void plic_disable(int irq) {
    80203c92:	7179                	addi	sp,sp,-48
    80203c94:	f406                	sd	ra,40(sp)
    80203c96:	f022                	sd	s0,32(sp)
    80203c98:	1800                	addi	s0,sp,48
    80203c9a:	87aa                	mv	a5,a0
    80203c9c:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80203ca0:	0c0027b7          	lui	a5,0xc002
    80203ca4:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203ca8:	00000097          	auipc	ra,0x0
    80203cac:	eae080e7          	jalr	-338(ra) # 80203b56 <read32>
    80203cb0:	87aa                	mv	a5,a0
    80203cb2:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    80203cb6:	fdc42783          	lw	a5,-36(s0)
    80203cba:	873e                	mv	a4,a5
    80203cbc:	4785                	li	a5,1
    80203cbe:	00e797bb          	sllw	a5,a5,a4
    80203cc2:	2781                	sext.w	a5,a5
    80203cc4:	fff7c793          	not	a5,a5
    80203cc8:	2781                	sext.w	a5,a5
    80203cca:	2781                	sext.w	a5,a5
    80203ccc:	fec42703          	lw	a4,-20(s0)
    80203cd0:	8ff9                	and	a5,a5,a4
    80203cd2:	2781                	sext.w	a5,a5
    80203cd4:	85be                	mv	a1,a5
    80203cd6:	0c0027b7          	lui	a5,0xc002
    80203cda:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203cde:	00000097          	auipc	ra,0x0
    80203ce2:	e2c080e7          	jalr	-468(ra) # 80203b0a <write32>
}
    80203ce6:	0001                	nop
    80203ce8:	70a2                	ld	ra,40(sp)
    80203cea:	7402                	ld	s0,32(sp)
    80203cec:	6145                	addi	sp,sp,48
    80203cee:	8082                	ret

0000000080203cf0 <plic_claim>:
int plic_claim(void) {
    80203cf0:	1141                	addi	sp,sp,-16
    80203cf2:	e406                	sd	ra,8(sp)
    80203cf4:	e022                	sd	s0,0(sp)
    80203cf6:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    80203cf8:	0c2017b7          	lui	a5,0xc201
    80203cfc:	00478513          	addi	a0,a5,4 # c201004 <userret+0xc200f68>
    80203d00:	00000097          	auipc	ra,0x0
    80203d04:	e56080e7          	jalr	-426(ra) # 80203b56 <read32>
    80203d08:	87aa                	mv	a5,a0
    80203d0a:	2781                	sext.w	a5,a5
    80203d0c:	2781                	sext.w	a5,a5
}
    80203d0e:	853e                	mv	a0,a5
    80203d10:	60a2                	ld	ra,8(sp)
    80203d12:	6402                	ld	s0,0(sp)
    80203d14:	0141                	addi	sp,sp,16
    80203d16:	8082                	ret

0000000080203d18 <plic_complete>:
void plic_complete(int irq) {
    80203d18:	1101                	addi	sp,sp,-32
    80203d1a:	ec06                	sd	ra,24(sp)
    80203d1c:	e822                	sd	s0,16(sp)
    80203d1e:	1000                	addi	s0,sp,32
    80203d20:	87aa                	mv	a5,a0
    80203d22:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    80203d26:	fec42783          	lw	a5,-20(s0)
    80203d2a:	85be                	mv	a1,a5
    80203d2c:	0c2017b7          	lui	a5,0xc201
    80203d30:	00478513          	addi	a0,a5,4 # c201004 <userret+0xc200f68>
    80203d34:	00000097          	auipc	ra,0x0
    80203d38:	dd6080e7          	jalr	-554(ra) # 80203b0a <write32>
    80203d3c:	0001                	nop
    80203d3e:	60e2                	ld	ra,24(sp)
    80203d40:	6442                	ld	s0,16(sp)
    80203d42:	6105                	addi	sp,sp,32
    80203d44:	8082                	ret
	...

0000000080203d50 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80203d50:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80203d52:	e006                	sd	ra,0(sp)
        sd gp, 16(sp)
    80203d54:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80203d56:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80203d58:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80203d5a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80203d5c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    80203d5e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80203d60:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80203d62:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80203d64:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80203d66:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80203d68:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80203d6a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80203d6c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80203d6e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80203d70:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80203d72:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80203d74:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80203d76:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80203d78:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    80203d7a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    80203d7c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    80203d7e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80203d80:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80203d82:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80203d84:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80203d86:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80203d88:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80203d8a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80203d8c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80203d8e:	fffff097          	auipc	ra,0xfffff
    80203d92:	3e0080e7          	jalr	992(ra) # 8020316e <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80203d96:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80203d98:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80203d9a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80203d9c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80203d9e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80203da0:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80203da2:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80203da4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80203da6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80203da8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80203daa:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80203dac:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80203dae:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80203db0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80203db2:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80203db4:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80203db6:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80203db8:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    80203dba:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    80203dbc:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    80203dbe:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80203dc0:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80203dc2:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80203dc4:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80203dc6:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80203dc8:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80203dca:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80203dcc:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80203dce:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80203dd0:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80203dd2:	10200073          	sret
    80203dd6:	0001                	nop
    80203dd8:	00000013          	nop
    80203ddc:	00000013          	nop

0000000080203de0 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80203de0:	00153023          	sd	ra,0(a0) # c201000 <userret+0xc200f64>
        sd sp, 8(a0)
    80203de4:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80203de8:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80203dea:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80203dec:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80203df0:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80203df4:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80203df8:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80203dfc:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80203e00:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80203e04:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80203e08:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80203e0c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80203e10:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80203e14:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80203e18:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80203e1c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80203e1e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80203e20:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80203e24:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80203e28:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80203e2c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80203e30:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80203e34:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80203e38:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80203e3c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80203e40:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80203e44:	0685bd83          	ld	s11,104(a1)
        
        ret
    80203e48:	8082                	ret

0000000080203e4a <r_sstatus>:
    struct proc *p = myproc();
    struct cpu *c = mycpu();
    
    // 获取当前返回地址，确保唤醒后能回到正确位置
    register uint64 ra asm("ra");
    
    80203e4a:	1101                	addi	sp,sp,-32
    80203e4c:	ec22                	sd	s0,24(sp)
    80203e4e:	1000                	addi	s0,sp,32
    // 关键修复：显式保存返回地址到进程上下文中
    p->context.ra = ra;
    80203e50:	100027f3          	csrr	a5,sstatus
    80203e54:	fef43423          	sd	a5,-24(s0)
    p->chan = chan;
    80203e58:	fe843783          	ld	a5,-24(s0)
    p->state = SLEEPING;
    80203e5c:	853e                	mv	a0,a5
    80203e5e:	6462                	ld	s0,24(sp)
    80203e60:	6105                	addi	sp,sp,32
    80203e62:	8082                	ret

0000000080203e64 <w_sstatus>:
    
    80203e64:	1101                	addi	sp,sp,-32
    80203e66:	ec22                	sd	s0,24(sp)
    80203e68:	1000                	addi	s0,sp,32
    80203e6a:	fea43423          	sd	a0,-24(s0)
    // 直接进行上下文切换
    80203e6e:	fe843783          	ld	a5,-24(s0)
    80203e72:	10079073          	csrw	sstatus,a5
    swtch(&p->context, &c->context);
    80203e76:	0001                	nop
    80203e78:	6462                	ld	s0,24(sp)
    80203e7a:	6105                	addi	sp,sp,32
    80203e7c:	8082                	ret

0000000080203e7e <intr_on>:
    
    p->chan = 0;  // 显式清除通道标记
}
void wakeup(void *chan)
{
    struct proc *p;
    80203e7e:	1141                	addi	sp,sp,-16
    80203e80:	e406                	sd	ra,8(sp)
    80203e82:	e022                	sd	s0,0(sp)
    80203e84:	0800                	addi	s0,sp,16
    
    80203e86:	00000097          	auipc	ra,0x0
    80203e8a:	fc4080e7          	jalr	-60(ra) # 80203e4a <r_sstatus>
    80203e8e:	87aa                	mv	a5,a0
    80203e90:	0027e793          	ori	a5,a5,2
    80203e94:	853e                	mv	a0,a5
    80203e96:	00000097          	auipc	ra,0x0
    80203e9a:	fce080e7          	jalr	-50(ra) # 80203e64 <w_sstatus>
    // 查找在该通道上睡眠的进程
    80203e9e:	0001                	nop
    80203ea0:	60a2                	ld	ra,8(sp)
    80203ea2:	6402                	ld	s0,0(sp)
    80203ea4:	0141                	addi	sp,sp,16
    80203ea6:	8082                	ret

0000000080203ea8 <intr_off>:
    for(p = proc_table; p < &proc_table[PROC]; p++) {
        if(p->state == SLEEPING && p->chan == chan) {
    80203ea8:	1141                	addi	sp,sp,-16
    80203eaa:	e406                	sd	ra,8(sp)
    80203eac:	e022                	sd	s0,0(sp)
    80203eae:	0800                	addi	s0,sp,16
            p->state = RUNNABLE;
    80203eb0:	00000097          	auipc	ra,0x0
    80203eb4:	f9a080e7          	jalr	-102(ra) # 80203e4a <r_sstatus>
    80203eb8:	87aa                	mv	a5,a0
    80203eba:	9bf5                	andi	a5,a5,-3
    80203ebc:	853e                	mv	a0,a5
    80203ebe:	00000097          	auipc	ra,0x0
    80203ec2:	fa6080e7          	jalr	-90(ra) # 80203e64 <w_sstatus>
        }
    80203ec6:	0001                	nop
    80203ec8:	60a2                	ld	ra,8(sp)
    80203eca:	6402                	ld	s0,0(sp)
    80203ecc:	0141                	addi	sp,sp,16
    80203ece:	8082                	ret

0000000080203ed0 <w_stvec>:
    }
}
    80203ed0:	1101                	addi	sp,sp,-32
    80203ed2:	ec22                	sd	s0,24(sp)
    80203ed4:	1000                	addi	s0,sp,32
    80203ed6:	fea43423          	sd	a0,-24(s0)
void kexit() {
    80203eda:	fe843783          	ld	a5,-24(s0)
    80203ede:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80203ee2:	0001                	nop
    80203ee4:	6462                	ld	s0,24(sp)
    80203ee6:	6105                	addi	sp,sp,32
    80203ee8:	8082                	ret

0000000080203eea <assert>:
        intr_off();
        
        // 优先检查是否有僵尸子进程
        int found_zombie = 0;
        int zombie_pid = 0;
        int zombie_status = 0;
    80203eea:	1101                	addi	sp,sp,-32
    80203eec:	ec06                	sd	ra,24(sp)
    80203eee:	e822                	sd	s0,16(sp)
    80203ef0:	1000                	addi	s0,sp,32
    80203ef2:	87aa                	mv	a5,a0
    80203ef4:	fef42623          	sw	a5,-20(s0)
        struct proc *zombie_child = 0;
    80203ef8:	fec42783          	lw	a5,-20(s0)
    80203efc:	2781                	sext.w	a5,a5
    80203efe:	e79d                	bnez	a5,80203f2c <assert+0x42>
        
    80203f00:	18800613          	li	a2,392
    80203f04:	00004597          	auipc	a1,0x4
    80203f08:	d7458593          	addi	a1,a1,-652 # 80207c78 <small_numbers+0x1828>
    80203f0c:	00004517          	auipc	a0,0x4
    80203f10:	d7c50513          	addi	a0,a0,-644 # 80207c88 <small_numbers+0x1838>
    80203f14:	ffffd097          	auipc	ra,0xffffd
    80203f18:	c40080e7          	jalr	-960(ra) # 80200b54 <printf>
        // 先查找ZOMBIE状态的子进程
    80203f1c:	00004517          	auipc	a0,0x4
    80203f20:	d9450513          	addi	a0,a0,-620 # 80207cb0 <small_numbers+0x1860>
    80203f24:	ffffd097          	auipc	ra,0xffffd
    80203f28:	538080e7          	jalr	1336(ra) # 8020145c <panic>
        for (int i = 0; i < PROC; i++) {
            struct proc *child = &proc_table[i];
    80203f2c:	0001                	nop
    80203f2e:	60e2                	ld	ra,24(sp)
    80203f30:	6442                	ld	s0,16(sp)
    80203f32:	6105                	addi	sp,sp,32
    80203f34:	8082                	ret

0000000080203f36 <shutdown>:
void shutdown() {
    80203f36:	1141                	addi	sp,sp,-16
    80203f38:	e406                	sd	ra,8(sp)
    80203f3a:	e022                	sd	s0,0(sp)
    80203f3c:	0800                	addi	s0,sp,16
    printf("关机\n");
    80203f3e:	00004517          	auipc	a0,0x4
    80203f42:	d7a50513          	addi	a0,a0,-646 # 80207cb8 <small_numbers+0x1868>
    80203f46:	ffffd097          	auipc	ra,0xffffd
    80203f4a:	c0e080e7          	jalr	-1010(ra) # 80200b54 <printf>
    asm volatile (
    80203f4e:	48a1                	li	a7,8
    80203f50:	00000073          	ecall
    while (1) { }
    80203f54:	0001                	nop
    80203f56:	bffd                	j	80203f54 <shutdown+0x1e>

0000000080203f58 <myproc>:
struct proc* myproc(void) {
    80203f58:	1141                	addi	sp,sp,-16
    80203f5a:	e422                	sd	s0,8(sp)
    80203f5c:	0800                	addi	s0,sp,16
    return current_proc;
    80203f5e:	00006797          	auipc	a5,0x6
    80203f62:	13278793          	addi	a5,a5,306 # 8020a090 <current_proc>
    80203f66:	639c                	ld	a5,0(a5)
}
    80203f68:	853e                	mv	a0,a5
    80203f6a:	6422                	ld	s0,8(sp)
    80203f6c:	0141                	addi	sp,sp,16
    80203f6e:	8082                	ret

0000000080203f70 <mycpu>:
struct cpu* mycpu(void) {
    80203f70:	1141                	addi	sp,sp,-16
    80203f72:	e406                	sd	ra,8(sp)
    80203f74:	e022                	sd	s0,0(sp)
    80203f76:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80203f78:	00006797          	auipc	a5,0x6
    80203f7c:	12078793          	addi	a5,a5,288 # 8020a098 <current_cpu>
    80203f80:	639c                	ld	a5,0(a5)
    80203f82:	ebb9                	bnez	a5,80203fd8 <mycpu+0x68>
        warning("current_cpu is NULL, initializing...\n");
    80203f84:	00004517          	auipc	a0,0x4
    80203f88:	d3c50513          	addi	a0,a0,-708 # 80207cc0 <small_numbers+0x1870>
    80203f8c:	ffffd097          	auipc	ra,0xffffd
    80203f90:	504080e7          	jalr	1284(ra) # 80201490 <warning>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    80203f94:	07800613          	li	a2,120
    80203f98:	4581                	li	a1,0
    80203f9a:	00008517          	auipc	a0,0x8
    80203f9e:	d2e50513          	addi	a0,a0,-722 # 8020bcc8 <cpu_instance.1>
    80203fa2:	ffffe097          	auipc	ra,0xffffe
    80203fa6:	bf8080e7          	jalr	-1032(ra) # 80201b9a <memset>
		current_cpu = &cpu_instance;
    80203faa:	00006797          	auipc	a5,0x6
    80203fae:	0ee78793          	addi	a5,a5,238 # 8020a098 <current_cpu>
    80203fb2:	00008717          	auipc	a4,0x8
    80203fb6:	d1670713          	addi	a4,a4,-746 # 8020bcc8 <cpu_instance.1>
    80203fba:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    80203fbc:	00006797          	auipc	a5,0x6
    80203fc0:	0dc78793          	addi	a5,a5,220 # 8020a098 <current_cpu>
    80203fc4:	639c                	ld	a5,0(a5)
    80203fc6:	85be                	mv	a1,a5
    80203fc8:	00004517          	auipc	a0,0x4
    80203fcc:	d2050513          	addi	a0,a0,-736 # 80207ce8 <small_numbers+0x1898>
    80203fd0:	ffffd097          	auipc	ra,0xffffd
    80203fd4:	b84080e7          	jalr	-1148(ra) # 80200b54 <printf>
    return current_cpu;
    80203fd8:	00006797          	auipc	a5,0x6
    80203fdc:	0c078793          	addi	a5,a5,192 # 8020a098 <current_cpu>
    80203fe0:	639c                	ld	a5,0(a5)
}
    80203fe2:	853e                	mv	a0,a5
    80203fe4:	60a2                	ld	ra,8(sp)
    80203fe6:	6402                	ld	s0,0(sp)
    80203fe8:	0141                	addi	sp,sp,16
    80203fea:	8082                	ret

0000000080203fec <return_to_user>:
void return_to_user(void) {
    80203fec:	7179                	addi	sp,sp,-48
    80203fee:	f406                	sd	ra,40(sp)
    80203ff0:	f022                	sd	s0,32(sp)
    80203ff2:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80203ff4:	00000097          	auipc	ra,0x0
    80203ff8:	f64080e7          	jalr	-156(ra) # 80203f58 <myproc>
    80203ffc:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80204000:	fe843783          	ld	a5,-24(s0)
    80204004:	eb89                	bnez	a5,80204016 <return_to_user+0x2a>
        panic("return_to_user: no current process");
    80204006:	00004517          	auipc	a0,0x4
    8020400a:	cfa50513          	addi	a0,a0,-774 # 80207d00 <small_numbers+0x18b0>
    8020400e:	ffffd097          	auipc	ra,0xffffd
    80204012:	44e080e7          	jalr	1102(ra) # 8020145c <panic>
    if (p->chan != 0) {
    80204016:	fe843783          	ld	a5,-24(s0)
    8020401a:	73dc                	ld	a5,160(a5)
    8020401c:	c791                	beqz	a5,80204028 <return_to_user+0x3c>
        p->chan = 0;  // 清除通道标记
    8020401e:	fe843783          	ld	a5,-24(s0)
    80204022:	0a07b023          	sd	zero,160(a5)
        return;  // 直接返回，不做任何状态更改
    80204026:	a861                	j	802040be <return_to_user+0xd2>
    w_stvec(TRAMPOLINE);
    80204028:	080007b7          	lui	a5,0x8000
    8020402c:	17fd                	addi	a5,a5,-1 # 7ffffff <userret+0x7ffff63>
    8020402e:	00c79513          	slli	a0,a5,0xc
    80204032:	00000097          	auipc	ra,0x0
    80204036:	e9e080e7          	jalr	-354(ra) # 80203ed0 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8020403a:	00000737          	lui	a4,0x0
    8020403e:	09c70713          	addi	a4,a4,156 # 9c <userret>
    80204042:	000007b7          	lui	a5,0x0
    80204046:	00078793          	mv	a5,a5
    8020404a:	8f1d                	sub	a4,a4,a5
    8020404c:	080007b7          	lui	a5,0x8000
    80204050:	17fd                	addi	a5,a5,-1 # 7ffffff <userret+0x7ffff63>
    80204052:	07b2                	slli	a5,a5,0xc
    80204054:	97ba                	add	a5,a5,a4
    80204056:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    8020405a:	fe843783          	ld	a5,-24(s0)
    8020405e:	7fdc                	ld	a5,184(a5)
    80204060:	00c7d713          	srli	a4,a5,0xc
    80204064:	57fd                	li	a5,-1
    80204066:	17fe                	slli	a5,a5,0x3f
    80204068:	8fd9                	or	a5,a5,a4
    8020406a:	fcf43c23          	sd	a5,-40(s0)
    if (trampoline_userret < TRAMPOLINE || trampoline_userret >= TRAMPOLINE + PGSIZE) {
    8020406e:	fe043703          	ld	a4,-32(s0)
    80204072:	fefff7b7          	lui	a5,0xfefff
    80204076:	07b6                	slli	a5,a5,0xd
    80204078:	83e5                	srli	a5,a5,0x19
    8020407a:	00e7f863          	bgeu	a5,a4,8020408a <return_to_user+0x9e>
    8020407e:	fe043703          	ld	a4,-32(s0)
    80204082:	57fd                	li	a5,-1
    80204084:	83e5                	srli	a5,a5,0x19
    80204086:	00e7fa63          	bgeu	a5,a4,8020409a <return_to_user+0xae>
        panic("return_to_user: 跳转地址超出trampoline页范围");
    8020408a:	00004517          	auipc	a0,0x4
    8020408e:	c9e50513          	addi	a0,a0,-866 # 80207d28 <small_numbers+0x18d8>
    80204092:	ffffd097          	auipc	ra,0xffffd
    80204096:	3ca080e7          	jalr	970(ra) # 8020145c <panic>
    ((void (*)(uint64, uint64))trampoline_userret)(TRAPFRAME, satp);
    8020409a:	fe043783          	ld	a5,-32(s0)
    8020409e:	fd843583          	ld	a1,-40(s0)
    802040a2:	04000737          	lui	a4,0x4000
    802040a6:	177d                	addi	a4,a4,-1 # 3ffffff <userret+0x3ffff63>
    802040a8:	00d71513          	slli	a0,a4,0xd
    802040ac:	9782                	jalr	a5
    panic("return_to_user: 不应该返回到这里");
    802040ae:	00004517          	auipc	a0,0x4
    802040b2:	cb250513          	addi	a0,a0,-846 # 80207d60 <small_numbers+0x1910>
    802040b6:	ffffd097          	auipc	ra,0xffffd
    802040ba:	3a6080e7          	jalr	934(ra) # 8020145c <panic>
}
    802040be:	70a2                	ld	ra,40(sp)
    802040c0:	7402                	ld	s0,32(sp)
    802040c2:	6145                	addi	sp,sp,48
    802040c4:	8082                	ret

00000000802040c6 <forkret>:
void forkret(void){
    802040c6:	7179                	addi	sp,sp,-48
    802040c8:	f406                	sd	ra,40(sp)
    802040ca:	f022                	sd	s0,32(sp)
    802040cc:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    802040ce:	00000097          	auipc	ra,0x0
    802040d2:	e8a080e7          	jalr	-374(ra) # 80203f58 <myproc>
    802040d6:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    802040da:	fe843783          	ld	a5,-24(s0)
    802040de:	eb89                	bnez	a5,802040f0 <forkret+0x2a>
        panic("forkret: no current process");
    802040e0:	00004517          	auipc	a0,0x4
    802040e4:	cb050513          	addi	a0,a0,-848 # 80207d90 <small_numbers+0x1940>
    802040e8:	ffffd097          	auipc	ra,0xffffd
    802040ec:	374080e7          	jalr	884(ra) # 8020145c <panic>
    if (p->chan != 0) {
    802040f0:	fe843783          	ld	a5,-24(s0)
    802040f4:	73dc                	ld	a5,160(a5)
    802040f6:	c791                	beqz	a5,80204102 <forkret+0x3c>
        p->chan = 0;  // 清除通道标记
    802040f8:	fe843783          	ld	a5,-24(s0)
    802040fc:	0a07b023          	sd	zero,160(a5) # fffffffffefff0a0 <_bss_end+0xffffffff7edf3350>
        return;  // 直接返回，继续执行原来的函数
    80204100:	a81d                	j	80204136 <forkret+0x70>
    uint64 entry = p->trapframe->epc;
    80204102:	fe843783          	ld	a5,-24(s0)
    80204106:	63fc                	ld	a5,192(a5)
    80204108:	6f9c                	ld	a5,24(a5)
    8020410a:	fef43023          	sd	a5,-32(s0)
    if (entry != 0) {
    8020410e:	fe043783          	ld	a5,-32(s0)
    80204112:	cf91                	beqz	a5,8020412e <forkret+0x68>
        void (*fn)(void) = (void(*)(void))entry;
    80204114:	fe043783          	ld	a5,-32(s0)
    80204118:	fcf43c23          	sd	a5,-40(s0)
        fn();  // 调用入口函数
    8020411c:	fd843783          	ld	a5,-40(s0)
    80204120:	9782                	jalr	a5
        exit_proc(0);  // 如果入口函数返回，则退出进程
    80204122:	4501                	li	a0,0
    80204124:	00000097          	auipc	ra,0x0
    80204128:	486080e7          	jalr	1158(ra) # 802045aa <exit_proc>
    8020412c:	a029                	j	80204136 <forkret+0x70>
        return_to_user();
    8020412e:	00000097          	auipc	ra,0x0
    80204132:	ebe080e7          	jalr	-322(ra) # 80203fec <return_to_user>
}
    80204136:	70a2                	ld	ra,40(sp)
    80204138:	7402                	ld	s0,32(sp)
    8020413a:	6145                	addi	sp,sp,48
    8020413c:	8082                	ret

000000008020413e <init_proc>:
void init_proc(void){
    8020413e:	7139                	addi	sp,sp,-64
    80204140:	fc06                	sd	ra,56(sp)
    80204142:	f822                	sd	s0,48(sp)
    80204144:	0080                	addi	s0,sp,64
    int corrupted = 0;
    80204146:	fe042623          	sw	zero,-20(s0)
    for(int i=0; i<PROC; i++){
    8020414a:	fe042423          	sw	zero,-24(s0)
    8020414e:	a861                	j	802041e6 <init_proc+0xa8>
        struct proc *p = &proc_table[i];
    80204150:	fe842703          	lw	a4,-24(s0)
    80204154:	0c800793          	li	a5,200
    80204158:	02f70733          	mul	a4,a4,a5
    8020415c:	00006797          	auipc	a5,0x6
    80204160:	26478793          	addi	a5,a5,612 # 8020a3c0 <proc_table>
    80204164:	97ba                	add	a5,a5,a4
    80204166:	fcf43423          	sd	a5,-56(s0)
        if (p->state != UNUSED && 
    8020416a:	fc843783          	ld	a5,-56(s0)
    8020416e:	439c                	lw	a5,0(a5)
    80204170:	c7b5                	beqz	a5,802041dc <init_proc+0x9e>
            (p->pid < 0 || p->pid > 1000 || 
    80204172:	fc843783          	ld	a5,-56(s0)
    80204176:	43dc                	lw	a5,4(a5)
        if (p->state != UNUSED && 
    80204178:	0407cd63          	bltz	a5,802041d2 <init_proc+0x94>
            (p->pid < 0 || p->pid > 1000 || 
    8020417c:	fc843783          	ld	a5,-56(s0)
    80204180:	43dc                	lw	a5,4(a5)
    80204182:	873e                	mv	a4,a5
    80204184:	3e800793          	li	a5,1000
    80204188:	04e7c563          	blt	a5,a4,802041d2 <init_proc+0x94>
             (p->state != USED && p->state != SLEEPING && 
    8020418c:	fc843783          	ld	a5,-56(s0)
    80204190:	439c                	lw	a5,0(a5)
            (p->pid < 0 || p->pid > 1000 || 
    80204192:	873e                	mv	a4,a5
    80204194:	4785                	li	a5,1
    80204196:	04f70363          	beq	a4,a5,802041dc <init_proc+0x9e>
             (p->state != USED && p->state != SLEEPING && 
    8020419a:	fc843783          	ld	a5,-56(s0)
    8020419e:	439c                	lw	a5,0(a5)
    802041a0:	873e                	mv	a4,a5
    802041a2:	4789                	li	a5,2
    802041a4:	02f70c63          	beq	a4,a5,802041dc <init_proc+0x9e>
              p->state != RUNNABLE && p->state != RUNNING && 
    802041a8:	fc843783          	ld	a5,-56(s0)
    802041ac:	439c                	lw	a5,0(a5)
             (p->state != USED && p->state != SLEEPING && 
    802041ae:	873e                	mv	a4,a5
    802041b0:	478d                	li	a5,3
    802041b2:	02f70563          	beq	a4,a5,802041dc <init_proc+0x9e>
              p->state != RUNNABLE && p->state != RUNNING && 
    802041b6:	fc843783          	ld	a5,-56(s0)
    802041ba:	439c                	lw	a5,0(a5)
    802041bc:	873e                	mv	a4,a5
    802041be:	4791                	li	a5,4
    802041c0:	00f70e63          	beq	a4,a5,802041dc <init_proc+0x9e>
              p->state != ZOMBIE))) {
    802041c4:	fc843783          	ld	a5,-56(s0)
    802041c8:	439c                	lw	a5,0(a5)
              p->state != RUNNABLE && p->state != RUNNING && 
    802041ca:	873e                	mv	a4,a5
    802041cc:	4795                	li	a5,5
    802041ce:	00f70763          	beq	a4,a5,802041dc <init_proc+0x9e>
            corrupted++;
    802041d2:	fec42783          	lw	a5,-20(s0)
    802041d6:	2785                	addiw	a5,a5,1
    802041d8:	fef42623          	sw	a5,-20(s0)
    for(int i=0; i<PROC; i++){
    802041dc:	fe842783          	lw	a5,-24(s0)
    802041e0:	2785                	addiw	a5,a5,1
    802041e2:	fef42423          	sw	a5,-24(s0)
    802041e6:	fe842783          	lw	a5,-24(s0)
    802041ea:	0007871b          	sext.w	a4,a5
    802041ee:	47fd                	li	a5,31
    802041f0:	f6e7d0e3          	bge	a5,a4,80204150 <init_proc+0x12>
    for(int i=0; i<PROC; i++){
    802041f4:	fe042223          	sw	zero,-28(s0)
    802041f8:	a079                	j	80204286 <init_proc+0x148>
        struct proc *p = &proc_table[i];
    802041fa:	fe442703          	lw	a4,-28(s0)
    802041fe:	0c800793          	li	a5,200
    80204202:	02f70733          	mul	a4,a4,a5
    80204206:	00006797          	auipc	a5,0x6
    8020420a:	1ba78793          	addi	a5,a5,442 # 8020a3c0 <proc_table>
    8020420e:	97ba                	add	a5,a5,a4
    80204210:	fcf43823          	sd	a5,-48(s0)
        memset(p, 0, sizeof(struct proc));
    80204214:	0c800613          	li	a2,200
    80204218:	4581                	li	a1,0
    8020421a:	fd043503          	ld	a0,-48(s0)
    8020421e:	ffffe097          	auipc	ra,0xffffe
    80204222:	97c080e7          	jalr	-1668(ra) # 80201b9a <memset>
        p->state = UNUSED;
    80204226:	fd043783          	ld	a5,-48(s0)
    8020422a:	0007a023          	sw	zero,0(a5)
        p->pid = 0;
    8020422e:	fd043783          	ld	a5,-48(s0)
    80204232:	0007a223          	sw	zero,4(a5)
        p->kstack = 0;
    80204236:	fd043783          	ld	a5,-48(s0)
    8020423a:	0007b423          	sd	zero,8(a5)
        p->pagetable = 0;
    8020423e:	fd043783          	ld	a5,-48(s0)
    80204242:	0a07bc23          	sd	zero,184(a5)
        p->trapframe = 0;
    80204246:	fd043783          	ld	a5,-48(s0)
    8020424a:	0c07b023          	sd	zero,192(a5)
        p->parent = 0;
    8020424e:	fd043783          	ld	a5,-48(s0)
    80204252:	0807bc23          	sd	zero,152(a5)
        p->chan = 0;
    80204256:	fd043783          	ld	a5,-48(s0)
    8020425a:	0a07b023          	sd	zero,160(a5)
        p->exit_status = 0;
    8020425e:	fd043783          	ld	a5,-48(s0)
    80204262:	0807a223          	sw	zero,132(a5)
        memset(&p->context, 0, sizeof(struct context));
    80204266:	fd043783          	ld	a5,-48(s0)
    8020426a:	07c1                	addi	a5,a5,16
    8020426c:	07000613          	li	a2,112
    80204270:	4581                	li	a1,0
    80204272:	853e                	mv	a0,a5
    80204274:	ffffe097          	auipc	ra,0xffffe
    80204278:	926080e7          	jalr	-1754(ra) # 80201b9a <memset>
    for(int i=0; i<PROC; i++){
    8020427c:	fe442783          	lw	a5,-28(s0)
    80204280:	2785                	addiw	a5,a5,1
    80204282:	fef42223          	sw	a5,-28(s0)
    80204286:	fe442783          	lw	a5,-28(s0)
    8020428a:	0007871b          	sext.w	a4,a5
    8020428e:	47fd                	li	a5,31
    80204290:	f6e7d5e3          	bge	a5,a4,802041fa <init_proc+0xbc>
    corrupted = 0;
    80204294:	fe042623          	sw	zero,-20(s0)
    for(int i=0; i<PROC; i++){
    80204298:	fe042023          	sw	zero,-32(s0)
    8020429c:	a081                	j	802042dc <init_proc+0x19e>
        struct proc *p = &proc_table[i];
    8020429e:	fe042703          	lw	a4,-32(s0)
    802042a2:	0c800793          	li	a5,200
    802042a6:	02f70733          	mul	a4,a4,a5
    802042aa:	00006797          	auipc	a5,0x6
    802042ae:	11678793          	addi	a5,a5,278 # 8020a3c0 <proc_table>
    802042b2:	97ba                	add	a5,a5,a4
    802042b4:	fcf43c23          	sd	a5,-40(s0)
        if (p->state != UNUSED || p->pid != 0) {
    802042b8:	fd843783          	ld	a5,-40(s0)
    802042bc:	439c                	lw	a5,0(a5)
    802042be:	e789                	bnez	a5,802042c8 <init_proc+0x18a>
    802042c0:	fd843783          	ld	a5,-40(s0)
    802042c4:	43dc                	lw	a5,4(a5)
    802042c6:	c791                	beqz	a5,802042d2 <init_proc+0x194>
            corrupted++;
    802042c8:	fec42783          	lw	a5,-20(s0)
    802042cc:	2785                	addiw	a5,a5,1
    802042ce:	fef42623          	sw	a5,-20(s0)
    for(int i=0; i<PROC; i++){
    802042d2:	fe042783          	lw	a5,-32(s0)
    802042d6:	2785                	addiw	a5,a5,1
    802042d8:	fef42023          	sw	a5,-32(s0)
    802042dc:	fe042783          	lw	a5,-32(s0)
    802042e0:	0007871b          	sext.w	a4,a5
    802042e4:	47fd                	li	a5,31
    802042e6:	fae7dce3          	bge	a5,a4,8020429e <init_proc+0x160>
    if (corrupted > 0) {
    802042ea:	fec42783          	lw	a5,-20(s0)
    802042ee:	2781                	sext.w	a5,a5
    802042f0:	00f05a63          	blez	a5,80204304 <init_proc+0x1c6>
        panic("进程表初始化失败: 仍有损坏的表项");
    802042f4:	00004517          	auipc	a0,0x4
    802042f8:	abc50513          	addi	a0,a0,-1348 # 80207db0 <small_numbers+0x1960>
    802042fc:	ffffd097          	auipc	ra,0xffffd
    80204300:	160080e7          	jalr	352(ra) # 8020145c <panic>
}
    80204304:	0001                	nop
    80204306:	70e2                	ld	ra,56(sp)
    80204308:	7442                	ld	s0,48(sp)
    8020430a:	6121                	addi	sp,sp,64
    8020430c:	8082                	ret

000000008020430e <alloc_proc>:
struct proc* alloc_proc(void) {
    8020430e:	7179                	addi	sp,sp,-48
    80204310:	f406                	sd	ra,40(sp)
    80204312:	f022                	sd	s0,32(sp)
    80204314:	1800                	addi	s0,sp,48
    for(int i = 0;i<PROC;i++) {
    80204316:	fe042623          	sw	zero,-20(s0)
    8020431a:	a2b9                	j	80204468 <alloc_proc+0x15a>
		p = &proc_table[i];
    8020431c:	fec42703          	lw	a4,-20(s0)
    80204320:	0c800793          	li	a5,200
    80204324:	02f70733          	mul	a4,a4,a5
    80204328:	00006797          	auipc	a5,0x6
    8020432c:	09878793          	addi	a5,a5,152 # 8020a3c0 <proc_table>
    80204330:	97ba                	add	a5,a5,a4
    80204332:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    80204336:	fe043783          	ld	a5,-32(s0)
    8020433a:	439c                	lw	a5,0(a5)
    8020433c:	12079163          	bnez	a5,8020445e <alloc_proc+0x150>
            p->pid = i;
    80204340:	fe043783          	ld	a5,-32(s0)
    80204344:	fec42703          	lw	a4,-20(s0)
    80204348:	c3d8                	sw	a4,4(a5)
            p->state = USED;
    8020434a:	fe043783          	ld	a5,-32(s0)
    8020434e:	4705                	li	a4,1
    80204350:	c398                	sw	a4,0(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    80204352:	ffffe097          	auipc	ra,0xffffe
    80204356:	75e080e7          	jalr	1886(ra) # 80202ab0 <alloc_page>
    8020435a:	872a                	mv	a4,a0
    8020435c:	fe043783          	ld	a5,-32(s0)
    80204360:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    80204362:	fe043783          	ld	a5,-32(s0)
    80204366:	63fc                	ld	a5,192(a5)
    80204368:	eb99                	bnez	a5,8020437e <alloc_proc+0x70>
                p->state = UNUSED;
    8020436a:	fe043783          	ld	a5,-32(s0)
    8020436e:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80204372:	fe043783          	ld	a5,-32(s0)
    80204376:	0007a223          	sw	zero,4(a5)
                return 0;
    8020437a:	4781                	li	a5,0
    8020437c:	a8f5                	j	80204478 <alloc_proc+0x16a>
            p->pagetable = create_pagetable();
    8020437e:	ffffe097          	auipc	ra,0xffffe
    80204382:	a14080e7          	jalr	-1516(ra) # 80201d92 <create_pagetable>
    80204386:	872a                	mv	a4,a0
    80204388:	fe043783          	ld	a5,-32(s0)
    8020438c:	ffd8                	sd	a4,184(a5)
            if(p->pagetable == 0){
    8020438e:	fe043783          	ld	a5,-32(s0)
    80204392:	7fdc                	ld	a5,184(a5)
    80204394:	e79d                	bnez	a5,802043c2 <alloc_proc+0xb4>
                free_page(p->trapframe);
    80204396:	fe043783          	ld	a5,-32(s0)
    8020439a:	63fc                	ld	a5,192(a5)
    8020439c:	853e                	mv	a0,a5
    8020439e:	ffffe097          	auipc	ra,0xffffe
    802043a2:	77e080e7          	jalr	1918(ra) # 80202b1c <free_page>
                p->trapframe = 0;
    802043a6:	fe043783          	ld	a5,-32(s0)
    802043aa:	0c07b023          	sd	zero,192(a5)
                p->state = UNUSED;
    802043ae:	fe043783          	ld	a5,-32(s0)
    802043b2:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    802043b6:	fe043783          	ld	a5,-32(s0)
    802043ba:	0007a223          	sw	zero,4(a5)
                return 0;
    802043be:	4781                	li	a5,0
    802043c0:	a865                	j	80204478 <alloc_proc+0x16a>
            void *kstack_mem = alloc_page();
    802043c2:	ffffe097          	auipc	ra,0xffffe
    802043c6:	6ee080e7          	jalr	1774(ra) # 80202ab0 <alloc_page>
    802043ca:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    802043ce:	fd843783          	ld	a5,-40(s0)
    802043d2:	e3b9                	bnez	a5,80204418 <alloc_proc+0x10a>
                free_page(p->trapframe);
    802043d4:	fe043783          	ld	a5,-32(s0)
    802043d8:	63fc                	ld	a5,192(a5)
    802043da:	853e                	mv	a0,a5
    802043dc:	ffffe097          	auipc	ra,0xffffe
    802043e0:	740080e7          	jalr	1856(ra) # 80202b1c <free_page>
                free_pagetable(p->pagetable);
    802043e4:	fe043783          	ld	a5,-32(s0)
    802043e8:	7fdc                	ld	a5,184(a5)
    802043ea:	853e                	mv	a0,a5
    802043ec:	ffffe097          	auipc	ra,0xffffe
    802043f0:	c54080e7          	jalr	-940(ra) # 80202040 <free_pagetable>
                p->trapframe = 0;
    802043f4:	fe043783          	ld	a5,-32(s0)
    802043f8:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    802043fc:	fe043783          	ld	a5,-32(s0)
    80204400:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    80204404:	fe043783          	ld	a5,-32(s0)
    80204408:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    8020440c:	fe043783          	ld	a5,-32(s0)
    80204410:	0007a223          	sw	zero,4(a5)
                return 0;
    80204414:	4781                	li	a5,0
    80204416:	a08d                	j	80204478 <alloc_proc+0x16a>
            p->kstack = (uint64)kstack_mem;
    80204418:	fd843703          	ld	a4,-40(s0)
    8020441c:	fe043783          	ld	a5,-32(s0)
    80204420:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    80204422:	fe043783          	ld	a5,-32(s0)
    80204426:	07c1                	addi	a5,a5,16
    80204428:	07000613          	li	a2,112
    8020442c:	4581                	li	a1,0
    8020442e:	853e                	mv	a0,a5
    80204430:	ffffd097          	auipc	ra,0xffffd
    80204434:	76a080e7          	jalr	1898(ra) # 80201b9a <memset>
            p->context.ra = (uint64)forkret;
    80204438:	00000717          	auipc	a4,0x0
    8020443c:	c8e70713          	addi	a4,a4,-882 # 802040c6 <forkret>
    80204440:	fe043783          	ld	a5,-32(s0)
    80204444:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    80204446:	fe043783          	ld	a5,-32(s0)
    8020444a:	6798                	ld	a4,8(a5)
    8020444c:	6785                	lui	a5,0x1
    8020444e:	17c1                	addi	a5,a5,-16 # ff0 <userret+0xf54>
    80204450:	973e                	add	a4,a4,a5
    80204452:	fe043783          	ld	a5,-32(s0)
    80204456:	ef98                	sd	a4,24(a5)
            return p;
    80204458:	fe043783          	ld	a5,-32(s0)
    8020445c:	a831                	j	80204478 <alloc_proc+0x16a>
    for(int i = 0;i<PROC;i++) {
    8020445e:	fec42783          	lw	a5,-20(s0)
    80204462:	2785                	addiw	a5,a5,1
    80204464:	fef42623          	sw	a5,-20(s0)
    80204468:	fec42783          	lw	a5,-20(s0)
    8020446c:	0007871b          	sext.w	a4,a5
    80204470:	47fd                	li	a5,31
    80204472:	eae7d5e3          	bge	a5,a4,8020431c <alloc_proc+0xe>
    return 0;
    80204476:	4781                	li	a5,0
}
    80204478:	853e                	mv	a0,a5
    8020447a:	70a2                	ld	ra,40(sp)
    8020447c:	7402                	ld	s0,32(sp)
    8020447e:	6145                	addi	sp,sp,48
    80204480:	8082                	ret

0000000080204482 <free_proc>:
void free_proc(struct proc *p){
    80204482:	1101                	addi	sp,sp,-32
    80204484:	ec06                	sd	ra,24(sp)
    80204486:	e822                	sd	s0,16(sp)
    80204488:	1000                	addi	s0,sp,32
    8020448a:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    8020448e:	fe843783          	ld	a5,-24(s0)
    80204492:	63fc                	ld	a5,192(a5)
    80204494:	cb89                	beqz	a5,802044a6 <free_proc+0x24>
        free_page(p->trapframe);
    80204496:	fe843783          	ld	a5,-24(s0)
    8020449a:	63fc                	ld	a5,192(a5)
    8020449c:	853e                	mv	a0,a5
    8020449e:	ffffe097          	auipc	ra,0xffffe
    802044a2:	67e080e7          	jalr	1662(ra) # 80202b1c <free_page>
    p->trapframe = 0;
    802044a6:	fe843783          	ld	a5,-24(s0)
    802044aa:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable)
    802044ae:	fe843783          	ld	a5,-24(s0)
    802044b2:	7fdc                	ld	a5,184(a5)
    802044b4:	cb89                	beqz	a5,802044c6 <free_proc+0x44>
        free_pagetable(p->pagetable);
    802044b6:	fe843783          	ld	a5,-24(s0)
    802044ba:	7fdc                	ld	a5,184(a5)
    802044bc:	853e                	mv	a0,a5
    802044be:	ffffe097          	auipc	ra,0xffffe
    802044c2:	b82080e7          	jalr	-1150(ra) # 80202040 <free_pagetable>
    p->pagetable = 0;
    802044c6:	fe843783          	ld	a5,-24(s0)
    802044ca:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    802044ce:	fe843783          	ld	a5,-24(s0)
    802044d2:	679c                	ld	a5,8(a5)
    802044d4:	cb89                	beqz	a5,802044e6 <free_proc+0x64>
        free_page((void*)p->kstack);
    802044d6:	fe843783          	ld	a5,-24(s0)
    802044da:	679c                	ld	a5,8(a5)
    802044dc:	853e                	mv	a0,a5
    802044de:	ffffe097          	auipc	ra,0xffffe
    802044e2:	63e080e7          	jalr	1598(ra) # 80202b1c <free_page>
    p->kstack = 0;
    802044e6:	fe843783          	ld	a5,-24(s0)
    802044ea:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    802044ee:	fe843783          	ld	a5,-24(s0)
    802044f2:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    802044f6:	fe843783          	ld	a5,-24(s0)
    802044fa:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    802044fe:	fe843783          	ld	a5,-24(s0)
    80204502:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    80204506:	fe843783          	ld	a5,-24(s0)
    8020450a:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    8020450e:	fe843783          	ld	a5,-24(s0)
    80204512:	07c1                	addi	a5,a5,16
    80204514:	07000613          	li	a2,112
    80204518:	4581                	li	a1,0
    8020451a:	853e                	mv	a0,a5
    8020451c:	ffffd097          	auipc	ra,0xffffd
    80204520:	67e080e7          	jalr	1662(ra) # 80201b9a <memset>
}
    80204524:	0001                	nop
    80204526:	60e2                	ld	ra,24(sp)
    80204528:	6442                	ld	s0,16(sp)
    8020452a:	6105                	addi	sp,sp,32
    8020452c:	8082                	ret

000000008020452e <create_proc>:
int create_proc(void (*entry)(void)) {
    8020452e:	7179                	addi	sp,sp,-48
    80204530:	f406                	sd	ra,40(sp)
    80204532:	f022                	sd	s0,32(sp)
    80204534:	1800                	addi	s0,sp,48
    80204536:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc();
    8020453a:	00000097          	auipc	ra,0x0
    8020453e:	dd4080e7          	jalr	-556(ra) # 8020430e <alloc_proc>
    80204542:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    80204546:	fe843783          	ld	a5,-24(s0)
    8020454a:	e399                	bnez	a5,80204550 <create_proc+0x22>
    8020454c:	57fd                	li	a5,-1
    8020454e:	a889                	j	802045a0 <create_proc+0x72>
    p->trapframe->epc = (uint64)entry;
    80204550:	fe843783          	ld	a5,-24(s0)
    80204554:	63fc                	ld	a5,192(a5)
    80204556:	fd843703          	ld	a4,-40(s0)
    8020455a:	ef98                	sd	a4,24(a5)
    p->state = RUNNABLE;
    8020455c:	fe843783          	ld	a5,-24(s0)
    80204560:	470d                	li	a4,3
    80204562:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    80204564:	00000097          	auipc	ra,0x0
    80204568:	9f4080e7          	jalr	-1548(ra) # 80203f58 <myproc>
    8020456c:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    80204570:	fe043783          	ld	a5,-32(s0)
    80204574:	c799                	beqz	a5,80204582 <create_proc+0x54>
        p->parent = parent;
    80204576:	fe843783          	ld	a5,-24(s0)
    8020457a:	fe043703          	ld	a4,-32(s0)
    8020457e:	efd8                	sd	a4,152(a5)
    80204580:	a829                	j	8020459a <create_proc+0x6c>
		warning("Set parent to NULL\n");
    80204582:	00004517          	auipc	a0,0x4
    80204586:	85e50513          	addi	a0,a0,-1954 # 80207de0 <small_numbers+0x1990>
    8020458a:	ffffd097          	auipc	ra,0xffffd
    8020458e:	f06080e7          	jalr	-250(ra) # 80201490 <warning>
        p->parent = NULL;
    80204592:	fe843783          	ld	a5,-24(s0)
    80204596:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    8020459a:	fe843783          	ld	a5,-24(s0)
    8020459e:	43dc                	lw	a5,4(a5)
}
    802045a0:	853e                	mv	a0,a5
    802045a2:	70a2                	ld	ra,40(sp)
    802045a4:	7402                	ld	s0,32(sp)
    802045a6:	6145                	addi	sp,sp,48
    802045a8:	8082                	ret

00000000802045aa <exit_proc>:
void exit_proc(int status) {
    802045aa:	7179                	addi	sp,sp,-48
    802045ac:	f406                	sd	ra,40(sp)
    802045ae:	f022                	sd	s0,32(sp)
    802045b0:	1800                	addi	s0,sp,48
    802045b2:	87aa                	mv	a5,a0
    802045b4:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    802045b8:	00000097          	auipc	ra,0x0
    802045bc:	9a0080e7          	jalr	-1632(ra) # 80203f58 <myproc>
    802045c0:	fea43423          	sd	a0,-24(s0)
    p->exit_status = status;
    802045c4:	fe843783          	ld	a5,-24(s0)
    802045c8:	fdc42703          	lw	a4,-36(s0)
    802045cc:	08e7a223          	sw	a4,132(a5)
    kexit();
    802045d0:	00000097          	auipc	ra,0x0
    802045d4:	378080e7          	jalr	888(ra) # 80204948 <kexit>
}
    802045d8:	0001                	nop
    802045da:	70a2                	ld	ra,40(sp)
    802045dc:	7402                	ld	s0,32(sp)
    802045de:	6145                	addi	sp,sp,48
    802045e0:	8082                	ret

00000000802045e2 <wait_proc>:
int wait_proc(int *status) {
    802045e2:	1101                	addi	sp,sp,-32
    802045e4:	ec06                	sd	ra,24(sp)
    802045e6:	e822                	sd	s0,16(sp)
    802045e8:	1000                	addi	s0,sp,32
    802045ea:	fea43423          	sd	a0,-24(s0)
    return kwait(status);
    802045ee:	fe843503          	ld	a0,-24(s0)
    802045f2:	00000097          	auipc	ra,0x0
    802045f6:	416080e7          	jalr	1046(ra) # 80204a08 <kwait>
    802045fa:	87aa                	mv	a5,a0
}
    802045fc:	853e                	mv	a0,a5
    802045fe:	60e2                	ld	ra,24(sp)
    80204600:	6442                	ld	s0,16(sp)
    80204602:	6105                	addi	sp,sp,32
    80204604:	8082                	ret

0000000080204606 <kfork>:
int kfork(void) {
    80204606:	1101                	addi	sp,sp,-32
    80204608:	ec06                	sd	ra,24(sp)
    8020460a:	e822                	sd	s0,16(sp)
    8020460c:	1000                	addi	s0,sp,32
    struct proc *parent = myproc();
    8020460e:	00000097          	auipc	ra,0x0
    80204612:	94a080e7          	jalr	-1718(ra) # 80203f58 <myproc>
    80204616:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc();
    8020461a:	00000097          	auipc	ra,0x0
    8020461e:	cf4080e7          	jalr	-780(ra) # 8020430e <alloc_proc>
    80204622:	fea43023          	sd	a0,-32(s0)
    if(child == 0)
    80204626:	fe043783          	ld	a5,-32(s0)
    8020462a:	e399                	bnez	a5,80204630 <kfork+0x2a>
        return -1;
    8020462c:	57fd                	li	a5,-1
    8020462e:	a059                	j	802046b4 <kfork+0xae>
    if(uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0){
    80204630:	fe843783          	ld	a5,-24(s0)
    80204634:	7fd8                	ld	a4,184(a5)
    80204636:	fe043783          	ld	a5,-32(s0)
    8020463a:	7fd4                	ld	a3,184(a5)
    8020463c:	fe843783          	ld	a5,-24(s0)
    80204640:	7bdc                	ld	a5,176(a5)
    80204642:	863e                	mv	a2,a5
    80204644:	85b6                	mv	a1,a3
    80204646:	853a                	mv	a0,a4
    80204648:	ffffe097          	auipc	ra,0xffffe
    8020464c:	2c0080e7          	jalr	704(ra) # 80202908 <uvmcopy>
    80204650:	87aa                	mv	a5,a0
    80204652:	0007da63          	bgez	a5,80204666 <kfork+0x60>
        free_proc(child);
    80204656:	fe043503          	ld	a0,-32(s0)
    8020465a:	00000097          	auipc	ra,0x0
    8020465e:	e28080e7          	jalr	-472(ra) # 80204482 <free_proc>
        return -1;
    80204662:	57fd                	li	a5,-1
    80204664:	a881                	j	802046b4 <kfork+0xae>
    child->sz = parent->sz;
    80204666:	fe843783          	ld	a5,-24(s0)
    8020466a:	7bd8                	ld	a4,176(a5)
    8020466c:	fe043783          	ld	a5,-32(s0)
    80204670:	fbd8                	sd	a4,176(a5)
    *(child->trapframe) = *(parent->trapframe);
    80204672:	fe843783          	ld	a5,-24(s0)
    80204676:	63f8                	ld	a4,192(a5)
    80204678:	fe043783          	ld	a5,-32(s0)
    8020467c:	63fc                	ld	a5,192(a5)
    8020467e:	86be                	mv	a3,a5
    80204680:	12000793          	li	a5,288
    80204684:	863e                	mv	a2,a5
    80204686:	85ba                	mv	a1,a4
    80204688:	8536                	mv	a0,a3
    8020468a:	ffffd097          	auipc	ra,0xffffd
    8020468e:	61c080e7          	jalr	1564(ra) # 80201ca6 <memcpy>
    child->trapframe->a0 = 0; // 子进程fork返回值为0
    80204692:	fe043783          	ld	a5,-32(s0)
    80204696:	63fc                	ld	a5,192(a5)
    80204698:	0607b823          	sd	zero,112(a5)
    child->state = RUNNABLE;
    8020469c:	fe043783          	ld	a5,-32(s0)
    802046a0:	470d                	li	a4,3
    802046a2:	c398                	sw	a4,0(a5)
    child->parent = parent;
    802046a4:	fe043783          	ld	a5,-32(s0)
    802046a8:	fe843703          	ld	a4,-24(s0)
    802046ac:	efd8                	sd	a4,152(a5)
    return child->pid;
    802046ae:	fe043783          	ld	a5,-32(s0)
    802046b2:	43dc                	lw	a5,4(a5)
}
    802046b4:	853e                	mv	a0,a5
    802046b6:	60e2                	ld	ra,24(sp)
    802046b8:	6442                	ld	s0,16(sp)
    802046ba:	6105                	addi	sp,sp,32
    802046bc:	8082                	ret

00000000802046be <schedule>:
void schedule(void) {
    802046be:	1101                	addi	sp,sp,-32
    802046c0:	ec06                	sd	ra,24(sp)
    802046c2:	e822                	sd	s0,16(sp)
    802046c4:	1000                	addi	s0,sp,32
  struct cpu *c = mycpu();
    802046c6:	00000097          	auipc	ra,0x0
    802046ca:	8aa080e7          	jalr	-1878(ra) # 80203f70 <mycpu>
    802046ce:	fea43023          	sd	a0,-32(s0)
  if (!initialized) {
    802046d2:	00007797          	auipc	a5,0x7
    802046d6:	66e78793          	addi	a5,a5,1646 # 8020bd40 <initialized.0>
    802046da:	439c                	lw	a5,0(a5)
    802046dc:	ef85                	bnez	a5,80204714 <schedule+0x56>
    if(c == 0) {
    802046de:	fe043783          	ld	a5,-32(s0)
    802046e2:	eb89                	bnez	a5,802046f4 <schedule+0x36>
      panic("schedule: no current cpu");
    802046e4:	00003517          	auipc	a0,0x3
    802046e8:	71450513          	addi	a0,a0,1812 # 80207df8 <small_numbers+0x19a8>
    802046ec:	ffffd097          	auipc	ra,0xffffd
    802046f0:	d70080e7          	jalr	-656(ra) # 8020145c <panic>
    c->proc = 0;
    802046f4:	fe043783          	ld	a5,-32(s0)
    802046f8:	0007b023          	sd	zero,0(a5)
    current_proc = 0;
    802046fc:	00006797          	auipc	a5,0x6
    80204700:	99478793          	addi	a5,a5,-1644 # 8020a090 <current_proc>
    80204704:	0007b023          	sd	zero,0(a5)
    initialized = 1;
    80204708:	00007797          	auipc	a5,0x7
    8020470c:	63878793          	addi	a5,a5,1592 # 8020bd40 <initialized.0>
    80204710:	4705                	li	a4,1
    80204712:	c398                	sw	a4,0(a5)
    intr_on();
    80204714:	fffff097          	auipc	ra,0xfffff
    80204718:	76a080e7          	jalr	1898(ra) # 80203e7e <intr_on>
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    8020471c:	00006797          	auipc	a5,0x6
    80204720:	ca478793          	addi	a5,a5,-860 # 8020a3c0 <proc_table>
    80204724:	fef43423          	sd	a5,-24(s0)
    80204728:	a89d                	j	8020479e <schedule+0xe0>
      if(p->state == RUNNABLE) {
    8020472a:	fe843783          	ld	a5,-24(s0)
    8020472e:	439c                	lw	a5,0(a5)
    80204730:	873e                	mv	a4,a5
    80204732:	478d                	li	a5,3
    80204734:	04f71f63          	bne	a4,a5,80204792 <schedule+0xd4>
        p->state = RUNNING;
    80204738:	fe843783          	ld	a5,-24(s0)
    8020473c:	4711                	li	a4,4
    8020473e:	c398                	sw	a4,0(a5)
        c->proc = p;
    80204740:	fe043783          	ld	a5,-32(s0)
    80204744:	fe843703          	ld	a4,-24(s0)
    80204748:	e398                	sd	a4,0(a5)
        current_proc = p;
    8020474a:	00006797          	auipc	a5,0x6
    8020474e:	94678793          	addi	a5,a5,-1722 # 8020a090 <current_proc>
    80204752:	fe843703          	ld	a4,-24(s0)
    80204756:	e398                	sd	a4,0(a5)
		swtch(&c->context, &p->context);
    80204758:	fe043783          	ld	a5,-32(s0)
    8020475c:	00878713          	addi	a4,a5,8
    80204760:	fe843783          	ld	a5,-24(s0)
    80204764:	07c1                	addi	a5,a5,16
    80204766:	85be                	mv	a1,a5
    80204768:	853a                	mv	a0,a4
    8020476a:	fffff097          	auipc	ra,0xfffff
    8020476e:	676080e7          	jalr	1654(ra) # 80203de0 <swtch>
		c = mycpu();
    80204772:	fffff097          	auipc	ra,0xfffff
    80204776:	7fe080e7          	jalr	2046(ra) # 80203f70 <mycpu>
    8020477a:	fea43023          	sd	a0,-32(s0)
        c->proc = 0;
    8020477e:	fe043783          	ld	a5,-32(s0)
    80204782:	0007b023          	sd	zero,0(a5)
        current_proc = 0;
    80204786:	00006797          	auipc	a5,0x6
    8020478a:	90a78793          	addi	a5,a5,-1782 # 8020a090 <current_proc>
    8020478e:	0007b023          	sd	zero,0(a5)
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    80204792:	fe843783          	ld	a5,-24(s0)
    80204796:	0c878793          	addi	a5,a5,200
    8020479a:	fef43423          	sd	a5,-24(s0)
    8020479e:	fe843703          	ld	a4,-24(s0)
    802047a2:	00007797          	auipc	a5,0x7
    802047a6:	51e78793          	addi	a5,a5,1310 # 8020bcc0 <proc_buffer>
    802047aa:	f8f760e3          	bltu	a4,a5,8020472a <schedule+0x6c>
    intr_on();
    802047ae:	b79d                	j	80204714 <schedule+0x56>

00000000802047b0 <yield>:
void yield(void) {
    802047b0:	1101                	addi	sp,sp,-32
    802047b2:	ec06                	sd	ra,24(sp)
    802047b4:	e822                	sd	s0,16(sp)
    802047b6:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    802047b8:	fffff097          	auipc	ra,0xfffff
    802047bc:	7a0080e7          	jalr	1952(ra) # 80203f58 <myproc>
    802047c0:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    802047c4:	fe843783          	ld	a5,-24(s0)
    802047c8:	c7cd                	beqz	a5,80204872 <yield+0xc2>
    if (p->state != RUNNING) {
    802047ca:	fe843783          	ld	a5,-24(s0)
    802047ce:	439c                	lw	a5,0(a5)
    802047d0:	873e                	mv	a4,a5
    802047d2:	4791                	li	a5,4
    802047d4:	00f70f63          	beq	a4,a5,802047f2 <yield+0x42>
        warning("yield when status is not RUNNING (%d)\n", p->state);
    802047d8:	fe843783          	ld	a5,-24(s0)
    802047dc:	439c                	lw	a5,0(a5)
    802047de:	85be                	mv	a1,a5
    802047e0:	00003517          	auipc	a0,0x3
    802047e4:	63850513          	addi	a0,a0,1592 # 80207e18 <small_numbers+0x19c8>
    802047e8:	ffffd097          	auipc	ra,0xffffd
    802047ec:	ca8080e7          	jalr	-856(ra) # 80201490 <warning>
        return;
    802047f0:	a051                	j	80204874 <yield+0xc4>
    intr_off();
    802047f2:	fffff097          	auipc	ra,0xfffff
    802047f6:	6b6080e7          	jalr	1718(ra) # 80203ea8 <intr_off>
    struct cpu *c = mycpu();
    802047fa:	fffff097          	auipc	ra,0xfffff
    802047fe:	776080e7          	jalr	1910(ra) # 80203f70 <mycpu>
    80204802:	fea43023          	sd	a0,-32(s0)
    p->state = RUNNABLE;
    80204806:	fe843783          	ld	a5,-24(s0)
    8020480a:	470d                	li	a4,3
    8020480c:	c398                	sw	a4,0(a5)
    p->context.ra = ra;
    8020480e:	8706                	mv	a4,ra
    80204810:	fe843783          	ld	a5,-24(s0)
    80204814:	eb98                	sd	a4,16(a5)
    if (c->context.ra == 0) {
    80204816:	fe043783          	ld	a5,-32(s0)
    8020481a:	679c                	ld	a5,8(a5)
    8020481c:	ef99                	bnez	a5,8020483a <yield+0x8a>
        c->context.ra = (uint64)schedule;
    8020481e:	00000717          	auipc	a4,0x0
    80204822:	ea070713          	addi	a4,a4,-352 # 802046be <schedule>
    80204826:	fe043783          	ld	a5,-32(s0)
    8020482a:	e798                	sd	a4,8(a5)
        c->context.sp = (uint64)c + PGSIZE;
    8020482c:	fe043703          	ld	a4,-32(s0)
    80204830:	6785                	lui	a5,0x1
    80204832:	973e                	add	a4,a4,a5
    80204834:	fe043783          	ld	a5,-32(s0)
    80204838:	eb98                	sd	a4,16(a5)
    current_proc = 0;
    8020483a:	00006797          	auipc	a5,0x6
    8020483e:	85678793          	addi	a5,a5,-1962 # 8020a090 <current_proc>
    80204842:	0007b023          	sd	zero,0(a5)
    c->proc = 0;
    80204846:	fe043783          	ld	a5,-32(s0)
    8020484a:	0007b023          	sd	zero,0(a5)
    swtch(&p->context, &c->context);
    8020484e:	fe843783          	ld	a5,-24(s0)
    80204852:	01078713          	addi	a4,a5,16
    80204856:	fe043783          	ld	a5,-32(s0)
    8020485a:	07a1                	addi	a5,a5,8
    8020485c:	85be                	mv	a1,a5
    8020485e:	853a                	mv	a0,a4
    80204860:	fffff097          	auipc	ra,0xfffff
    80204864:	580080e7          	jalr	1408(ra) # 80203de0 <swtch>
    intr_on();
    80204868:	fffff097          	auipc	ra,0xfffff
    8020486c:	616080e7          	jalr	1558(ra) # 80203e7e <intr_on>
    80204870:	a011                	j	80204874 <yield+0xc4>
        return;
    80204872:	0001                	nop
}
    80204874:	60e2                	ld	ra,24(sp)
    80204876:	6442                	ld	s0,16(sp)
    80204878:	6105                	addi	sp,sp,32
    8020487a:	8082                	ret

000000008020487c <sleep>:
void sleep(void *chan){
    8020487c:	7179                	addi	sp,sp,-48
    8020487e:	f406                	sd	ra,40(sp)
    80204880:	f022                	sd	s0,32(sp)
    80204882:	1800                	addi	s0,sp,48
    80204884:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = myproc();
    80204888:	fffff097          	auipc	ra,0xfffff
    8020488c:	6d0080e7          	jalr	1744(ra) # 80203f58 <myproc>
    80204890:	fea43423          	sd	a0,-24(s0)
    struct cpu *c = mycpu();
    80204894:	fffff097          	auipc	ra,0xfffff
    80204898:	6dc080e7          	jalr	1756(ra) # 80203f70 <mycpu>
    8020489c:	fea43023          	sd	a0,-32(s0)
    p->context.ra = ra;
    802048a0:	8706                	mv	a4,ra
    802048a2:	fe843783          	ld	a5,-24(s0)
    802048a6:	eb98                	sd	a4,16(a5)
    p->chan = chan;
    802048a8:	fe843783          	ld	a5,-24(s0)
    802048ac:	fd843703          	ld	a4,-40(s0)
    802048b0:	f3d8                	sd	a4,160(a5)
    p->state = SLEEPING;
    802048b2:	fe843783          	ld	a5,-24(s0)
    802048b6:	4709                	li	a4,2
    802048b8:	c398                	sw	a4,0(a5)
    swtch(&p->context, &c->context);
    802048ba:	fe843783          	ld	a5,-24(s0)
    802048be:	01078713          	addi	a4,a5,16
    802048c2:	fe043783          	ld	a5,-32(s0)
    802048c6:	07a1                	addi	a5,a5,8
    802048c8:	85be                	mv	a1,a5
    802048ca:	853a                	mv	a0,a4
    802048cc:	fffff097          	auipc	ra,0xfffff
    802048d0:	514080e7          	jalr	1300(ra) # 80203de0 <swtch>
    p->chan = 0;  // 显式清除通道标记
    802048d4:	fe843783          	ld	a5,-24(s0)
    802048d8:	0a07b023          	sd	zero,160(a5)
}
    802048dc:	0001                	nop
    802048de:	70a2                	ld	ra,40(sp)
    802048e0:	7402                	ld	s0,32(sp)
    802048e2:	6145                	addi	sp,sp,48
    802048e4:	8082                	ret

00000000802048e6 <wakeup>:
{
    802048e6:	7179                	addi	sp,sp,-48
    802048e8:	f422                	sd	s0,40(sp)
    802048ea:	1800                	addi	s0,sp,48
    802048ec:	fca43c23          	sd	a0,-40(s0)
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    802048f0:	00006797          	auipc	a5,0x6
    802048f4:	ad078793          	addi	a5,a5,-1328 # 8020a3c0 <proc_table>
    802048f8:	fef43423          	sd	a5,-24(s0)
    802048fc:	a80d                	j	8020492e <wakeup+0x48>
        if(p->state == SLEEPING && p->chan == chan) {
    802048fe:	fe843783          	ld	a5,-24(s0)
    80204902:	439c                	lw	a5,0(a5)
    80204904:	873e                	mv	a4,a5
    80204906:	4789                	li	a5,2
    80204908:	00f71d63          	bne	a4,a5,80204922 <wakeup+0x3c>
    8020490c:	fe843783          	ld	a5,-24(s0)
    80204910:	73dc                	ld	a5,160(a5)
    80204912:	fd843703          	ld	a4,-40(s0)
    80204916:	00f71663          	bne	a4,a5,80204922 <wakeup+0x3c>
            p->state = RUNNABLE;
    8020491a:	fe843783          	ld	a5,-24(s0)
    8020491e:	470d                	li	a4,3
    80204920:	c398                	sw	a4,0(a5)
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    80204922:	fe843783          	ld	a5,-24(s0)
    80204926:	0c878793          	addi	a5,a5,200
    8020492a:	fef43423          	sd	a5,-24(s0)
    8020492e:	fe843703          	ld	a4,-24(s0)
    80204932:	00007797          	auipc	a5,0x7
    80204936:	38e78793          	addi	a5,a5,910 # 8020bcc0 <proc_buffer>
    8020493a:	fcf762e3          	bltu	a4,a5,802048fe <wakeup+0x18>
}
    8020493e:	0001                	nop
    80204940:	0001                	nop
    80204942:	7422                	ld	s0,40(sp)
    80204944:	6145                	addi	sp,sp,48
    80204946:	8082                	ret

0000000080204948 <kexit>:
void kexit() {
    80204948:	1101                	addi	sp,sp,-32
    8020494a:	ec06                	sd	ra,24(sp)
    8020494c:	e822                	sd	s0,16(sp)
    8020494e:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80204950:	fffff097          	auipc	ra,0xfffff
    80204954:	608080e7          	jalr	1544(ra) # 80203f58 <myproc>
    80204958:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    8020495c:	fe843783          	ld	a5,-24(s0)
    80204960:	eb89                	bnez	a5,80204972 <kexit+0x2a>
        panic("kexit: no current process");
    80204962:	00003517          	auipc	a0,0x3
    80204966:	4de50513          	addi	a0,a0,1246 # 80207e40 <small_numbers+0x19f0>
    8020496a:	ffffd097          	auipc	ra,0xffffd
    8020496e:	af2080e7          	jalr	-1294(ra) # 8020145c <panic>
    if (!p->parent){
    80204972:	fe843783          	ld	a5,-24(s0)
    80204976:	6fdc                	ld	a5,152(a5)
    80204978:	e789                	bnez	a5,80204982 <kexit+0x3a>
		shutdown();
    8020497a:	fffff097          	auipc	ra,0xfffff
    8020497e:	5bc080e7          	jalr	1468(ra) # 80203f36 <shutdown>
    p->state = ZOMBIE;
    80204982:	fe843783          	ld	a5,-24(s0)
    80204986:	4715                	li	a4,5
    80204988:	c398                	sw	a4,0(a5)
    void *chan = (void*)p->parent;
    8020498a:	fe843783          	ld	a5,-24(s0)
    8020498e:	6fdc                	ld	a5,152(a5)
    80204990:	fef43023          	sd	a5,-32(s0)
    if (p->parent->state == SLEEPING && p->parent->chan == chan) {
    80204994:	fe843783          	ld	a5,-24(s0)
    80204998:	6fdc                	ld	a5,152(a5)
    8020499a:	439c                	lw	a5,0(a5)
    8020499c:	873e                	mv	a4,a5
    8020499e:	4789                	li	a5,2
    802049a0:	02f71063          	bne	a4,a5,802049c0 <kexit+0x78>
    802049a4:	fe843783          	ld	a5,-24(s0)
    802049a8:	6fdc                	ld	a5,152(a5)
    802049aa:	73dc                	ld	a5,160(a5)
    802049ac:	fe043703          	ld	a4,-32(s0)
    802049b0:	00f71863          	bne	a4,a5,802049c0 <kexit+0x78>
        wakeup(chan);
    802049b4:	fe043503          	ld	a0,-32(s0)
    802049b8:	00000097          	auipc	ra,0x0
    802049bc:	f2e080e7          	jalr	-210(ra) # 802048e6 <wakeup>
    current_proc = 0;
    802049c0:	00005797          	auipc	a5,0x5
    802049c4:	6d078793          	addi	a5,a5,1744 # 8020a090 <current_proc>
    802049c8:	0007b023          	sd	zero,0(a5)
    if (mycpu())
    802049cc:	fffff097          	auipc	ra,0xfffff
    802049d0:	5a4080e7          	jalr	1444(ra) # 80203f70 <mycpu>
    802049d4:	87aa                	mv	a5,a0
    802049d6:	cb81                	beqz	a5,802049e6 <kexit+0x9e>
        mycpu()->proc = 0;
    802049d8:	fffff097          	auipc	ra,0xfffff
    802049dc:	598080e7          	jalr	1432(ra) # 80203f70 <mycpu>
    802049e0:	87aa                	mv	a5,a0
    802049e2:	0007b023          	sd	zero,0(a5)
    schedule();
    802049e6:	00000097          	auipc	ra,0x0
    802049ea:	cd8080e7          	jalr	-808(ra) # 802046be <schedule>
    panic("kexit should not return after schedule");
    802049ee:	00003517          	auipc	a0,0x3
    802049f2:	47250513          	addi	a0,a0,1138 # 80207e60 <small_numbers+0x1a10>
    802049f6:	ffffd097          	auipc	ra,0xffffd
    802049fa:	a66080e7          	jalr	-1434(ra) # 8020145c <panic>
}
    802049fe:	0001                	nop
    80204a00:	60e2                	ld	ra,24(sp)
    80204a02:	6442                	ld	s0,16(sp)
    80204a04:	6105                	addi	sp,sp,32
    80204a06:	8082                	ret

0000000080204a08 <kwait>:
int kwait(int *status) {
    80204a08:	7159                	addi	sp,sp,-112
    80204a0a:	f486                	sd	ra,104(sp)
    80204a0c:	f0a2                	sd	s0,96(sp)
    80204a0e:	1880                	addi	s0,sp,112
    80204a10:	f8a43c23          	sd	a0,-104(s0)
    struct proc *p = myproc();
    80204a14:	fffff097          	auipc	ra,0xfffff
    80204a18:	544080e7          	jalr	1348(ra) # 80203f58 <myproc>
    80204a1c:	fca43023          	sd	a0,-64(s0)
    if (p == 0) {
    80204a20:	fc043783          	ld	a5,-64(s0)
    80204a24:	eb99                	bnez	a5,80204a3a <kwait+0x32>
        printf("Warning: kwait called with no current process\n");
    80204a26:	00003517          	auipc	a0,0x3
    80204a2a:	46250513          	addi	a0,a0,1122 # 80207e88 <small_numbers+0x1a38>
    80204a2e:	ffffc097          	auipc	ra,0xffffc
    80204a32:	126080e7          	jalr	294(ra) # 80200b54 <printf>
        return -1;
    80204a36:	57fd                	li	a5,-1
    80204a38:	aa55                	j	80204bec <kwait+0x1e4>
        intr_off();
    80204a3a:	fffff097          	auipc	ra,0xfffff
    80204a3e:	46e080e7          	jalr	1134(ra) # 80203ea8 <intr_off>
        int found_zombie = 0;
    80204a42:	fe042623          	sw	zero,-20(s0)
        int zombie_pid = 0;
    80204a46:	fe042423          	sw	zero,-24(s0)
        int zombie_status = 0;
    80204a4a:	fe042223          	sw	zero,-28(s0)
        struct proc *zombie_child = 0;
    80204a4e:	fc043c23          	sd	zero,-40(s0)
        for (int i = 0; i < PROC; i++) {
    80204a52:	fc042a23          	sw	zero,-44(s0)
    80204a56:	a0a5                	j	80204abe <kwait+0xb6>
            struct proc *child = &proc_table[i];
    80204a58:	fd442703          	lw	a4,-44(s0)
    80204a5c:	0c800793          	li	a5,200
    80204a60:	02f70733          	mul	a4,a4,a5
    80204a64:	00006797          	auipc	a5,0x6
    80204a68:	95c78793          	addi	a5,a5,-1700 # 8020a3c0 <proc_table>
    80204a6c:	97ba                	add	a5,a5,a4
    80204a6e:	faf43c23          	sd	a5,-72(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    80204a72:	fb843783          	ld	a5,-72(s0)
    80204a76:	439c                	lw	a5,0(a5)
    80204a78:	873e                	mv	a4,a5
    80204a7a:	4795                	li	a5,5
    80204a7c:	02f71c63          	bne	a4,a5,80204ab4 <kwait+0xac>
    80204a80:	fb843783          	ld	a5,-72(s0)
    80204a84:	6fdc                	ld	a5,152(a5)
    80204a86:	fc043703          	ld	a4,-64(s0)
    80204a8a:	02f71563          	bne	a4,a5,80204ab4 <kwait+0xac>
                found_zombie = 1;
    80204a8e:	4785                	li	a5,1
    80204a90:	fef42623          	sw	a5,-20(s0)
                zombie_pid = child->pid;
    80204a94:	fb843783          	ld	a5,-72(s0)
    80204a98:	43dc                	lw	a5,4(a5)
    80204a9a:	fef42423          	sw	a5,-24(s0)
                zombie_status = child->exit_status;
    80204a9e:	fb843783          	ld	a5,-72(s0)
    80204aa2:	0847a783          	lw	a5,132(a5)
    80204aa6:	fef42223          	sw	a5,-28(s0)
                zombie_child = child;
    80204aaa:	fb843783          	ld	a5,-72(s0)
    80204aae:	fcf43c23          	sd	a5,-40(s0)
                break;
    80204ab2:	a829                	j	80204acc <kwait+0xc4>
        for (int i = 0; i < PROC; i++) {
    80204ab4:	fd442783          	lw	a5,-44(s0)
    80204ab8:	2785                	addiw	a5,a5,1
    80204aba:	fcf42a23          	sw	a5,-44(s0)
    80204abe:	fd442783          	lw	a5,-44(s0)
    80204ac2:	0007871b          	sext.w	a4,a5
    80204ac6:	47fd                	li	a5,31
    80204ac8:	f8e7d8e3          	bge	a5,a4,80204a58 <kwait+0x50>
            }
        }
        
        if (found_zombie) {
    80204acc:	fec42783          	lw	a5,-20(s0)
    80204ad0:	2781                	sext.w	a5,a5
    80204ad2:	cb85                	beqz	a5,80204b02 <kwait+0xfa>
            if (status)
    80204ad4:	f9843783          	ld	a5,-104(s0)
    80204ad8:	c791                	beqz	a5,80204ae4 <kwait+0xdc>
                *status = zombie_status;
    80204ada:	f9843783          	ld	a5,-104(s0)
    80204ade:	fe442703          	lw	a4,-28(s0)
    80204ae2:	c398                	sw	a4,0(a5)

            free_proc(zombie_child);
    80204ae4:	fd843503          	ld	a0,-40(s0)
    80204ae8:	00000097          	auipc	ra,0x0
    80204aec:	99a080e7          	jalr	-1638(ra) # 80204482 <free_proc>
			zombie_child = NULL;
    80204af0:	fc043c23          	sd	zero,-40(s0)
            intr_on();
    80204af4:	fffff097          	auipc	ra,0xfffff
    80204af8:	38a080e7          	jalr	906(ra) # 80203e7e <intr_on>
            return zombie_pid;
    80204afc:	fe842783          	lw	a5,-24(s0)
    80204b00:	a0f5                	j	80204bec <kwait+0x1e4>
        }
        
        // 检查是否有任何子进程
        int havekids = 0;
    80204b02:	fc042823          	sw	zero,-48(s0)
        for (int i = 0; i < PROC; i++) {
    80204b06:	fc042623          	sw	zero,-52(s0)
    80204b0a:	a089                	j	80204b4c <kwait+0x144>
            struct proc *child = &proc_table[i];
    80204b0c:	fcc42703          	lw	a4,-52(s0)
    80204b10:	0c800793          	li	a5,200
    80204b14:	02f70733          	mul	a4,a4,a5
    80204b18:	00006797          	auipc	a5,0x6
    80204b1c:	8a878793          	addi	a5,a5,-1880 # 8020a3c0 <proc_table>
    80204b20:	97ba                	add	a5,a5,a4
    80204b22:	faf43023          	sd	a5,-96(s0)
            if (child->state != UNUSED && child->parent == p) {
    80204b26:	fa043783          	ld	a5,-96(s0)
    80204b2a:	439c                	lw	a5,0(a5)
    80204b2c:	cb99                	beqz	a5,80204b42 <kwait+0x13a>
    80204b2e:	fa043783          	ld	a5,-96(s0)
    80204b32:	6fdc                	ld	a5,152(a5)
    80204b34:	fc043703          	ld	a4,-64(s0)
    80204b38:	00f71563          	bne	a4,a5,80204b42 <kwait+0x13a>
                havekids = 1;
    80204b3c:	4785                	li	a5,1
    80204b3e:	fcf42823          	sw	a5,-48(s0)
        for (int i = 0; i < PROC; i++) {
    80204b42:	fcc42783          	lw	a5,-52(s0)
    80204b46:	2785                	addiw	a5,a5,1
    80204b48:	fcf42623          	sw	a5,-52(s0)
    80204b4c:	fcc42783          	lw	a5,-52(s0)
    80204b50:	0007871b          	sext.w	a4,a5
    80204b54:	47fd                	li	a5,31
    80204b56:	fae7dbe3          	bge	a5,a4,80204b0c <kwait+0x104>
            }
        }
        
        if (!havekids) {
    80204b5a:	fd042783          	lw	a5,-48(s0)
    80204b5e:	2781                	sext.w	a5,a5
    80204b60:	e799                	bnez	a5,80204b6e <kwait+0x166>
            intr_on();
    80204b62:	fffff097          	auipc	ra,0xfffff
    80204b66:	31c080e7          	jalr	796(ra) # 80203e7e <intr_on>
            return -1;
    80204b6a:	57fd                	li	a5,-1
    80204b6c:	a041                	j	80204bec <kwait+0x1e4>
        }
        void *wait_chan = (void*)p;
    80204b6e:	fc043783          	ld	a5,-64(s0)
    80204b72:	faf43823          	sd	a5,-80(s0)
		register uint64 ra asm("ra");
		p->context.ra = ra;
    80204b76:	8706                	mv	a4,ra
    80204b78:	fc043783          	ld	a5,-64(s0)
    80204b7c:	eb98                	sd	a4,16(a5)
        p->chan = wait_chan;
    80204b7e:	fc043783          	ld	a5,-64(s0)
    80204b82:	fb043703          	ld	a4,-80(s0)
    80204b86:	f3d8                	sd	a4,160(a5)
        p->state = SLEEPING;
    80204b88:	fc043783          	ld	a5,-64(s0)
    80204b8c:	4709                	li	a4,2
    80204b8e:	c398                	sw	a4,0(a5)
        
		struct cpu *c = mycpu();
    80204b90:	fffff097          	auipc	ra,0xfffff
    80204b94:	3e0080e7          	jalr	992(ra) # 80203f70 <mycpu>
    80204b98:	faa43423          	sd	a0,-88(s0)
		current_proc = 0;
    80204b9c:	00005797          	auipc	a5,0x5
    80204ba0:	4f478793          	addi	a5,a5,1268 # 8020a090 <current_proc>
    80204ba4:	0007b023          	sd	zero,0(a5)
		c->proc = 0;
    80204ba8:	fa843783          	ld	a5,-88(s0)
    80204bac:	0007b023          	sd	zero,0(a5)
        // 在睡眠前确保中断是开启的
        intr_on();
    80204bb0:	fffff097          	auipc	ra,0xfffff
    80204bb4:	2ce080e7          	jalr	718(ra) # 80203e7e <intr_on>
        swtch(&p->context,&c->context);
    80204bb8:	fc043783          	ld	a5,-64(s0)
    80204bbc:	01078713          	addi	a4,a5,16
    80204bc0:	fa843783          	ld	a5,-88(s0)
    80204bc4:	07a1                	addi	a5,a5,8
    80204bc6:	85be                	mv	a1,a5
    80204bc8:	853a                	mv	a0,a4
    80204bca:	fffff097          	auipc	ra,0xfffff
    80204bce:	216080e7          	jalr	534(ra) # 80203de0 <swtch>
        intr_off();
    80204bd2:	fffff097          	auipc	ra,0xfffff
    80204bd6:	2d6080e7          	jalr	726(ra) # 80203ea8 <intr_off>
        p->state = RUNNING;
    80204bda:	fc043783          	ld	a5,-64(s0)
    80204bde:	4711                	li	a4,4
    80204be0:	c398                	sw	a4,0(a5)
        intr_on();
    80204be2:	fffff097          	auipc	ra,0xfffff
    80204be6:	29c080e7          	jalr	668(ra) # 80203e7e <intr_on>
    while (1) {
    80204bea:	bd81                	j	80204a3a <kwait+0x32>
    }
}
    80204bec:	853e                	mv	a0,a5
    80204bee:	70a6                	ld	ra,104(sp)
    80204bf0:	7406                	ld	s0,96(sp)
    80204bf2:	6165                	addi	sp,sp,112
    80204bf4:	8082                	ret

0000000080204bf6 <print_proc_table>:

void print_proc_table(void) {
    80204bf6:	1101                	addi	sp,sp,-32
    80204bf8:	ec06                	sd	ra,24(sp)
    80204bfa:	e822                	sd	s0,16(sp)
    80204bfc:	1000                	addi	s0,sp,32
    struct proc *p;
    int count = 0;
    80204bfe:	fe042223          	sw	zero,-28(s0)
    
    printf("PID  status     parent  func_address    stack_address\n");
    80204c02:	00003517          	auipc	a0,0x3
    80204c06:	2b650513          	addi	a0,a0,694 # 80207eb8 <small_numbers+0x1a68>
    80204c0a:	ffffc097          	auipc	ra,0xffffc
    80204c0e:	f4a080e7          	jalr	-182(ra) # 80200b54 <printf>
    printf("--------------------------------------------\n");
    80204c12:	00003517          	auipc	a0,0x3
    80204c16:	2de50513          	addi	a0,a0,734 # 80207ef0 <small_numbers+0x1aa0>
    80204c1a:	ffffc097          	auipc	ra,0xffffc
    80204c1e:	f3a080e7          	jalr	-198(ra) # 80200b54 <printf>
    
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    80204c22:	00005797          	auipc	a5,0x5
    80204c26:	79e78793          	addi	a5,a5,1950 # 8020a3c0 <proc_table>
    80204c2a:	fef43423          	sd	a5,-24(s0)
    80204c2e:	a2bd                	j	80204d9c <print_proc_table+0x1a6>
        if(p->state != UNUSED) {
    80204c30:	fe843783          	ld	a5,-24(s0)
    80204c34:	439c                	lw	a5,0(a5)
    80204c36:	14078d63          	beqz	a5,80204d90 <print_proc_table+0x19a>
            count++;
    80204c3a:	fe442783          	lw	a5,-28(s0)
    80204c3e:	2785                	addiw	a5,a5,1
    80204c40:	fef42223          	sw	a5,-28(s0)
            printf("%d ", p->pid);
    80204c44:	fe843783          	ld	a5,-24(s0)
    80204c48:	43dc                	lw	a5,4(a5)
    80204c4a:	85be                	mv	a1,a5
    80204c4c:	00003517          	auipc	a0,0x3
    80204c50:	2d450513          	addi	a0,a0,724 # 80207f20 <small_numbers+0x1ad0>
    80204c54:	ffffc097          	auipc	ra,0xffffc
    80204c58:	f00080e7          	jalr	-256(ra) # 80200b54 <printf>
            
            switch(p->state) {
    80204c5c:	fe843783          	ld	a5,-24(s0)
    80204c60:	439c                	lw	a5,0(a5)
    80204c62:	86be                	mv	a3,a5
    80204c64:	4715                	li	a4,5
    80204c66:	08d76863          	bltu	a4,a3,80204cf6 <print_proc_table+0x100>
    80204c6a:	00279713          	slli	a4,a5,0x2
    80204c6e:	00003797          	auipc	a5,0x3
    80204c72:	36278793          	addi	a5,a5,866 # 80207fd0 <small_numbers+0x1b80>
    80204c76:	97ba                	add	a5,a5,a4
    80204c78:	439c                	lw	a5,0(a5)
    80204c7a:	0007871b          	sext.w	a4,a5
    80204c7e:	00003797          	auipc	a5,0x3
    80204c82:	35278793          	addi	a5,a5,850 # 80207fd0 <small_numbers+0x1b80>
    80204c86:	97ba                	add	a5,a5,a4
    80204c88:	8782                	jr	a5
                case UNUSED:   printf("UNUSED    "); break;
    80204c8a:	00003517          	auipc	a0,0x3
    80204c8e:	29e50513          	addi	a0,a0,670 # 80207f28 <small_numbers+0x1ad8>
    80204c92:	ffffc097          	auipc	ra,0xffffc
    80204c96:	ec2080e7          	jalr	-318(ra) # 80200b54 <printf>
    80204c9a:	a89d                	j	80204d10 <print_proc_table+0x11a>
                case USED:     printf("USED      "); break;
    80204c9c:	00003517          	auipc	a0,0x3
    80204ca0:	29c50513          	addi	a0,a0,668 # 80207f38 <small_numbers+0x1ae8>
    80204ca4:	ffffc097          	auipc	ra,0xffffc
    80204ca8:	eb0080e7          	jalr	-336(ra) # 80200b54 <printf>
    80204cac:	a095                	j	80204d10 <print_proc_table+0x11a>
                case SLEEPING: printf("SLEEP     "); break;
    80204cae:	00003517          	auipc	a0,0x3
    80204cb2:	29a50513          	addi	a0,a0,666 # 80207f48 <small_numbers+0x1af8>
    80204cb6:	ffffc097          	auipc	ra,0xffffc
    80204cba:	e9e080e7          	jalr	-354(ra) # 80200b54 <printf>
    80204cbe:	a889                	j	80204d10 <print_proc_table+0x11a>
                case RUNNABLE: printf("RUNNABLE  "); break;
    80204cc0:	00003517          	auipc	a0,0x3
    80204cc4:	29850513          	addi	a0,a0,664 # 80207f58 <small_numbers+0x1b08>
    80204cc8:	ffffc097          	auipc	ra,0xffffc
    80204ccc:	e8c080e7          	jalr	-372(ra) # 80200b54 <printf>
    80204cd0:	a081                	j	80204d10 <print_proc_table+0x11a>
                case RUNNING:  printf("RUNNING   "); break;
    80204cd2:	00003517          	auipc	a0,0x3
    80204cd6:	29650513          	addi	a0,a0,662 # 80207f68 <small_numbers+0x1b18>
    80204cda:	ffffc097          	auipc	ra,0xffffc
    80204cde:	e7a080e7          	jalr	-390(ra) # 80200b54 <printf>
    80204ce2:	a03d                	j	80204d10 <print_proc_table+0x11a>
                case ZOMBIE:   printf("ZOMBIE    "); break;
    80204ce4:	00003517          	auipc	a0,0x3
    80204ce8:	29450513          	addi	a0,a0,660 # 80207f78 <small_numbers+0x1b28>
    80204cec:	ffffc097          	auipc	ra,0xffffc
    80204cf0:	e68080e7          	jalr	-408(ra) # 80200b54 <printf>
    80204cf4:	a831                	j	80204d10 <print_proc_table+0x11a>
                default:       printf("UNKNOWN(%d) ", p->state); break;
    80204cf6:	fe843783          	ld	a5,-24(s0)
    80204cfa:	439c                	lw	a5,0(a5)
    80204cfc:	85be                	mv	a1,a5
    80204cfe:	00003517          	auipc	a0,0x3
    80204d02:	28a50513          	addi	a0,a0,650 # 80207f88 <small_numbers+0x1b38>
    80204d06:	ffffc097          	auipc	ra,0xffffc
    80204d0a:	e4e080e7          	jalr	-434(ra) # 80200b54 <printf>
    80204d0e:	0001                	nop
            }
            
            if(p->parent)
    80204d10:	fe843783          	ld	a5,-24(s0)
    80204d14:	6fdc                	ld	a5,152(a5)
    80204d16:	cf99                	beqz	a5,80204d34 <print_proc_table+0x13e>
                printf("%d ", p->parent->pid);
    80204d18:	fe843783          	ld	a5,-24(s0)
    80204d1c:	6fdc                	ld	a5,152(a5)
    80204d1e:	43dc                	lw	a5,4(a5)
    80204d20:	85be                	mv	a1,a5
    80204d22:	00003517          	auipc	a0,0x3
    80204d26:	1fe50513          	addi	a0,a0,510 # 80207f20 <small_numbers+0x1ad0>
    80204d2a:	ffffc097          	auipc	ra,0xffffc
    80204d2e:	e2a080e7          	jalr	-470(ra) # 80200b54 <printf>
    80204d32:	a809                	j	80204d44 <print_proc_table+0x14e>
            else
                printf("none    ");
    80204d34:	00003517          	auipc	a0,0x3
    80204d38:	26450513          	addi	a0,a0,612 # 80207f98 <small_numbers+0x1b48>
    80204d3c:	ffffc097          	auipc	ra,0xffffc
    80204d40:	e18080e7          	jalr	-488(ra) # 80200b54 <printf>
                
            if(p->trapframe)
    80204d44:	fe843783          	ld	a5,-24(s0)
    80204d48:	63fc                	ld	a5,192(a5)
    80204d4a:	cf99                	beqz	a5,80204d68 <print_proc_table+0x172>
                printf("%p ", (void*)p->trapframe->epc);
    80204d4c:	fe843783          	ld	a5,-24(s0)
    80204d50:	63fc                	ld	a5,192(a5)
    80204d52:	6f9c                	ld	a5,24(a5)
    80204d54:	85be                	mv	a1,a5
    80204d56:	00003517          	auipc	a0,0x3
    80204d5a:	25250513          	addi	a0,a0,594 # 80207fa8 <small_numbers+0x1b58>
    80204d5e:	ffffc097          	auipc	ra,0xffffc
    80204d62:	df6080e7          	jalr	-522(ra) # 80200b54 <printf>
    80204d66:	a809                	j	80204d78 <print_proc_table+0x182>
            else
                printf("none    ");
    80204d68:	00003517          	auipc	a0,0x3
    80204d6c:	23050513          	addi	a0,a0,560 # 80207f98 <small_numbers+0x1b48>
    80204d70:	ffffc097          	auipc	ra,0xffffc
    80204d74:	de4080e7          	jalr	-540(ra) # 80200b54 <printf>
                
            printf("%p\n", (void*)p->kstack);
    80204d78:	fe843783          	ld	a5,-24(s0)
    80204d7c:	679c                	ld	a5,8(a5)
    80204d7e:	85be                	mv	a1,a5
    80204d80:	00003517          	auipc	a0,0x3
    80204d84:	23050513          	addi	a0,a0,560 # 80207fb0 <small_numbers+0x1b60>
    80204d88:	ffffc097          	auipc	ra,0xffffc
    80204d8c:	dcc080e7          	jalr	-564(ra) # 80200b54 <printf>
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    80204d90:	fe843783          	ld	a5,-24(s0)
    80204d94:	0c878793          	addi	a5,a5,200
    80204d98:	fef43423          	sd	a5,-24(s0)
    80204d9c:	fe843703          	ld	a4,-24(s0)
    80204da0:	00007797          	auipc	a5,0x7
    80204da4:	f2078793          	addi	a5,a5,-224 # 8020bcc0 <proc_buffer>
    80204da8:	e8f764e3          	bltu	a4,a5,80204c30 <print_proc_table+0x3a>
        }
    }
    
    printf("--------------------------------------------\n");
    80204dac:	00003517          	auipc	a0,0x3
    80204db0:	14450513          	addi	a0,a0,324 # 80207ef0 <small_numbers+0x1aa0>
    80204db4:	ffffc097          	auipc	ra,0xffffc
    80204db8:	da0080e7          	jalr	-608(ra) # 80200b54 <printf>
    printf("%d active processes\n", count);
    80204dbc:	fe442783          	lw	a5,-28(s0)
    80204dc0:	85be                	mv	a1,a5
    80204dc2:	00003517          	auipc	a0,0x3
    80204dc6:	1f650513          	addi	a0,a0,502 # 80207fb8 <small_numbers+0x1b68>
    80204dca:	ffffc097          	auipc	ra,0xffffc
    80204dce:	d8a080e7          	jalr	-630(ra) # 80200b54 <printf>

}
    80204dd2:	0001                	nop
    80204dd4:	60e2                	ld	ra,24(sp)
    80204dd6:	6442                	ld	s0,16(sp)
    80204dd8:	6105                	addi	sp,sp,32
    80204dda:	8082                	ret

0000000080204ddc <simple_task>:

// 简单测试任务，用于测试进程创建
void simple_task(void) {
    80204ddc:	1141                	addi	sp,sp,-16
    80204dde:	e406                	sd	ra,8(sp)
    80204de0:	e022                	sd	s0,0(sp)
    80204de2:	0800                	addi	s0,sp,16
    // 简单任务，只打印并退出
    printf("Simple task running in PID %d\n", myproc()->pid);
    80204de4:	fffff097          	auipc	ra,0xfffff
    80204de8:	174080e7          	jalr	372(ra) # 80203f58 <myproc>
    80204dec:	87aa                	mv	a5,a0
    80204dee:	43dc                	lw	a5,4(a5)
    80204df0:	85be                	mv	a1,a5
    80204df2:	00003517          	auipc	a0,0x3
    80204df6:	1f650513          	addi	a0,a0,502 # 80207fe8 <small_numbers+0x1b98>
    80204dfa:	ffffc097          	auipc	ra,0xffffc
    80204dfe:	d5a080e7          	jalr	-678(ra) # 80200b54 <printf>
}
    80204e02:	0001                	nop
    80204e04:	60a2                	ld	ra,8(sp)
    80204e06:	6402                	ld	s0,0(sp)
    80204e08:	0141                	addi	sp,sp,16
    80204e0a:	8082                	ret

0000000080204e0c <test_process_creation>:
void test_process_creation(void) {
    80204e0c:	7139                	addi	sp,sp,-64
    80204e0e:	fc06                	sd	ra,56(sp)
    80204e10:	f822                	sd	s0,48(sp)
    80204e12:	0080                	addi	s0,sp,64
    printf("\n==================================================\n");
    80204e14:	00003517          	auipc	a0,0x3
    80204e18:	1f450513          	addi	a0,a0,500 # 80208008 <small_numbers+0x1bb8>
    80204e1c:	ffffc097          	auipc	ra,0xffffc
    80204e20:	d38080e7          	jalr	-712(ra) # 80200b54 <printf>
    printf("===== 测试开始: 进程创建与管理测试 =====\n");
    80204e24:	00003517          	auipc	a0,0x3
    80204e28:	21c50513          	addi	a0,a0,540 # 80208040 <small_numbers+0x1bf0>
    80204e2c:	ffffc097          	auipc	ra,0xffffc
    80204e30:	d28080e7          	jalr	-728(ra) # 80200b54 <printf>
    printf("==================================================\n");
    80204e34:	00003517          	auipc	a0,0x3
    80204e38:	24450513          	addi	a0,a0,580 # 80208078 <small_numbers+0x1c28>
    80204e3c:	ffffc097          	auipc	ra,0xffffc
    80204e40:	d18080e7          	jalr	-744(ra) # 80200b54 <printf>

    // 测试基本的进程创建
    int pid = create_proc(simple_task);
    80204e44:	00000517          	auipc	a0,0x0
    80204e48:	f9850513          	addi	a0,a0,-104 # 80204ddc <simple_task>
    80204e4c:	fffff097          	auipc	ra,0xfffff
    80204e50:	6e2080e7          	jalr	1762(ra) # 8020452e <create_proc>
    80204e54:	87aa                	mv	a5,a0
    80204e56:	fcf42e23          	sw	a5,-36(s0)
    assert(pid > 0);
    80204e5a:	fdc42783          	lw	a5,-36(s0)
    80204e5e:	2781                	sext.w	a5,a5
    80204e60:	00f027b3          	sgtz	a5,a5
    80204e64:	0ff7f793          	zext.b	a5,a5
    80204e68:	2781                	sext.w	a5,a5
    80204e6a:	853e                	mv	a0,a5
    80204e6c:	fffff097          	auipc	ra,0xfffff
    80204e70:	07e080e7          	jalr	126(ra) # 80203eea <assert>
    printf("【测试结果】: 基本进程创建成功，PID: %d，正常退出\n", pid);
    80204e74:	fdc42783          	lw	a5,-36(s0)
    80204e78:	85be                	mv	a1,a5
    80204e7a:	00003517          	auipc	a0,0x3
    80204e7e:	23650513          	addi	a0,a0,566 # 802080b0 <small_numbers+0x1c60>
    80204e82:	ffffc097          	auipc	ra,0xffffc
    80204e86:	cd2080e7          	jalr	-814(ra) # 80200b54 <printf>

    int count = 1;
    80204e8a:	4785                	li	a5,1
    80204e8c:	fef42623          	sw	a5,-20(s0)
    printf("\n----- 测试进程表容量限制 -----\n");
    80204e90:	00003517          	auipc	a0,0x3
    80204e94:	26850513          	addi	a0,a0,616 # 802080f8 <small_numbers+0x1ca8>
    80204e98:	ffffc097          	auipc	ra,0xffffc
    80204e9c:	cbc080e7          	jalr	-836(ra) # 80200b54 <printf>
    for (int i = 0; i < PROC + 5; i++) {
    80204ea0:	fe042423          	sw	zero,-24(s0)
    80204ea4:	a81d                	j	80204eda <test_process_creation+0xce>
        int pid = create_proc(simple_task);
    80204ea6:	00000517          	auipc	a0,0x0
    80204eaa:	f3650513          	addi	a0,a0,-202 # 80204ddc <simple_task>
    80204eae:	fffff097          	auipc	ra,0xfffff
    80204eb2:	680080e7          	jalr	1664(ra) # 8020452e <create_proc>
    80204eb6:	87aa                	mv	a5,a0
    80204eb8:	fcf42c23          	sw	a5,-40(s0)
        if (pid > 0) {
    80204ebc:	fd842783          	lw	a5,-40(s0)
    80204ec0:	2781                	sext.w	a5,a5
    80204ec2:	02f05563          	blez	a5,80204eec <test_process_creation+0xe0>
            count++; 
    80204ec6:	fec42783          	lw	a5,-20(s0)
    80204eca:	2785                	addiw	a5,a5,1
    80204ecc:	fef42623          	sw	a5,-20(s0)
    for (int i = 0; i < PROC + 5; i++) {
    80204ed0:	fe842783          	lw	a5,-24(s0)
    80204ed4:	2785                	addiw	a5,a5,1
    80204ed6:	fef42423          	sw	a5,-24(s0)
    80204eda:	fe842783          	lw	a5,-24(s0)
    80204ede:	0007871b          	sext.w	a4,a5
    80204ee2:	02400793          	li	a5,36
    80204ee6:	fce7d0e3          	bge	a5,a4,80204ea6 <test_process_creation+0x9a>
    80204eea:	a011                	j	80204eee <test_process_creation+0xe2>
        } else {
            break;
    80204eec:	0001                	nop
        }
    }
    printf("【测试结果】: 成功创建 %d 个进程 (最大限制: %d)\n", count, PROC);
    80204eee:	fec42783          	lw	a5,-20(s0)
    80204ef2:	02000613          	li	a2,32
    80204ef6:	85be                	mv	a1,a5
    80204ef8:	00003517          	auipc	a0,0x3
    80204efc:	23050513          	addi	a0,a0,560 # 80208128 <small_numbers+0x1cd8>
    80204f00:	ffffc097          	auipc	ra,0xffffc
    80204f04:	c54080e7          	jalr	-940(ra) # 80200b54 <printf>
    if (count >= PROC) {
    80204f08:	fec42783          	lw	a5,-20(s0)
    80204f0c:	0007871b          	sext.w	a4,a5
    80204f10:	47fd                	li	a5,31
    80204f12:	00e7db63          	bge	a5,a4,80204f28 <test_process_creation+0x11c>
        printf("【结果分析】: 系统正确处理了进程表容量限制\n");
    80204f16:	00003517          	auipc	a0,0x3
    80204f1a:	25a50513          	addi	a0,a0,602 # 80208170 <small_numbers+0x1d20>
    80204f1e:	ffffc097          	auipc	ra,0xffffc
    80204f22:	c36080e7          	jalr	-970(ra) # 80200b54 <printf>
    80204f26:	a809                	j	80204f38 <test_process_creation+0x12c>
    } else {
        printf("【结果分析】: 未达到进程表容量，可能存在问题\n");
    80204f28:	00003517          	auipc	a0,0x3
    80204f2c:	28850513          	addi	a0,a0,648 # 802081b0 <small_numbers+0x1d60>
    80204f30:	ffffc097          	auipc	ra,0xffffc
    80204f34:	c24080e7          	jalr	-988(ra) # 80200b54 <printf>
    }

    // 清理测试进程
    printf("\n----- 测试进程等待与清理 -----\n");
    80204f38:	00003517          	auipc	a0,0x3
    80204f3c:	2c050513          	addi	a0,a0,704 # 802081f8 <small_numbers+0x1da8>
    80204f40:	ffffc097          	auipc	ra,0xffffc
    80204f44:	c14080e7          	jalr	-1004(ra) # 80200b54 <printf>
    int success_count = 0;
    80204f48:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < count; i++) {
    80204f4c:	fe042023          	sw	zero,-32(s0)
    80204f50:	a0a1                	j	80204f98 <test_process_creation+0x18c>
        int waited_pid = wait_proc(NULL);
    80204f52:	4501                	li	a0,0
    80204f54:	fffff097          	auipc	ra,0xfffff
    80204f58:	68e080e7          	jalr	1678(ra) # 802045e2 <wait_proc>
    80204f5c:	87aa                	mv	a5,a0
    80204f5e:	fcf42623          	sw	a5,-52(s0)
        if (waited_pid > 0) {
    80204f62:	fcc42783          	lw	a5,-52(s0)
    80204f66:	2781                	sext.w	a5,a5
    80204f68:	00f05863          	blez	a5,80204f78 <test_process_creation+0x16c>
            success_count++;
    80204f6c:	fe442783          	lw	a5,-28(s0)
    80204f70:	2785                	addiw	a5,a5,1
    80204f72:	fef42223          	sw	a5,-28(s0)
    80204f76:	a821                	j	80204f8e <test_process_creation+0x182>
        } else {
            printf("【错误】: 等待进程失败，错误码: %d\n", waited_pid);
    80204f78:	fcc42783          	lw	a5,-52(s0)
    80204f7c:	85be                	mv	a1,a5
    80204f7e:	00003517          	auipc	a0,0x3
    80204f82:	2aa50513          	addi	a0,a0,682 # 80208228 <small_numbers+0x1dd8>
    80204f86:	ffffc097          	auipc	ra,0xffffc
    80204f8a:	bce080e7          	jalr	-1074(ra) # 80200b54 <printf>
    for (int i = 0; i < count; i++) {
    80204f8e:	fe042783          	lw	a5,-32(s0)
    80204f92:	2785                	addiw	a5,a5,1
    80204f94:	fef42023          	sw	a5,-32(s0)
    80204f98:	fe042783          	lw	a5,-32(s0)
    80204f9c:	873e                	mv	a4,a5
    80204f9e:	fec42783          	lw	a5,-20(s0)
    80204fa2:	2701                	sext.w	a4,a4
    80204fa4:	2781                	sext.w	a5,a5
    80204fa6:	faf746e3          	blt	a4,a5,80204f52 <test_process_creation+0x146>
        }
    }
    printf("【测试结果】: 回收 %d/%d 个进程\n", success_count, count);
    80204faa:	fec42703          	lw	a4,-20(s0)
    80204fae:	fe442783          	lw	a5,-28(s0)
    80204fb2:	863a                	mv	a2,a4
    80204fb4:	85be                	mv	a1,a5
    80204fb6:	00003517          	auipc	a0,0x3
    80204fba:	2aa50513          	addi	a0,a0,682 # 80208260 <small_numbers+0x1e10>
    80204fbe:	ffffc097          	auipc	ra,0xffffc
    80204fc2:	b96080e7          	jalr	-1130(ra) # 80200b54 <printf>
    if (success_count == count) {
    80204fc6:	fe442783          	lw	a5,-28(s0)
    80204fca:	873e                	mv	a4,a5
    80204fcc:	fec42783          	lw	a5,-20(s0)
    80204fd0:	2701                	sext.w	a4,a4
    80204fd2:	2781                	sext.w	a5,a5
    80204fd4:	00f71b63          	bne	a4,a5,80204fea <test_process_creation+0x1de>
        printf("【结果分析】: 所有进程成功回收，等待机制正常工作\n");
    80204fd8:	00003517          	auipc	a0,0x3
    80204fdc:	2b850513          	addi	a0,a0,696 # 80208290 <small_numbers+0x1e40>
    80204fe0:	ffffc097          	auipc	ra,0xffffc
    80204fe4:	b74080e7          	jalr	-1164(ra) # 80200b54 <printf>
    80204fe8:	a809                	j	80204ffa <test_process_creation+0x1ee>
    } else {
        printf("【结果分析】: 部分进程未正常回收，等待机制可能存在问题\n");
    80204fea:	00003517          	auipc	a0,0x3
    80204fee:	2f650513          	addi	a0,a0,758 # 802082e0 <small_numbers+0x1e90>
    80204ff2:	ffffc097          	auipc	ra,0xffffc
    80204ff6:	b62080e7          	jalr	-1182(ra) # 80200b54 <printf>
    }
    // 增强测试：清理后尝试重新创建进程
    printf("\n----- 清理后尝试重新创建进程 -----\n");
    80204ffa:	00003517          	auipc	a0,0x3
    80204ffe:	33e50513          	addi	a0,a0,830 # 80208338 <small_numbers+0x1ee8>
    80205002:	ffffc097          	auipc	ra,0xffffc
    80205006:	b52080e7          	jalr	-1198(ra) # 80200b54 <printf>
    int new_pid = create_proc(simple_task);
    8020500a:	00000517          	auipc	a0,0x0
    8020500e:	dd250513          	addi	a0,a0,-558 # 80204ddc <simple_task>
    80205012:	fffff097          	auipc	ra,0xfffff
    80205016:	51c080e7          	jalr	1308(ra) # 8020452e <create_proc>
    8020501a:	87aa                	mv	a5,a0
    8020501c:	fcf42a23          	sw	a5,-44(s0)
    if (new_pid > 0) {
    80205020:	fd442783          	lw	a5,-44(s0)
    80205024:	2781                	sext.w	a5,a5
    80205026:	06f05663          	blez	a5,80205092 <test_process_creation+0x286>
        printf("【增强测试结果】: 清理后成功重新创建进程，PID: %d\n", new_pid);
    8020502a:	fd442783          	lw	a5,-44(s0)
    8020502e:	85be                	mv	a1,a5
    80205030:	00003517          	auipc	a0,0x3
    80205034:	33850513          	addi	a0,a0,824 # 80208368 <small_numbers+0x1f18>
    80205038:	ffffc097          	auipc	ra,0xffffc
    8020503c:	b1c080e7          	jalr	-1252(ra) # 80200b54 <printf>
		
        // 等待新进程退出
        int waited_new = wait_proc(NULL);
    80205040:	4501                	li	a0,0
    80205042:	fffff097          	auipc	ra,0xfffff
    80205046:	5a0080e7          	jalr	1440(ra) # 802045e2 <wait_proc>
    8020504a:	87aa                	mv	a5,a0
    8020504c:	fcf42823          	sw	a5,-48(s0)
        if (waited_new == new_pid) {
    80205050:	fd042783          	lw	a5,-48(s0)
    80205054:	873e                	mv	a4,a5
    80205056:	fd442783          	lw	a5,-44(s0)
    8020505a:	2701                	sext.w	a4,a4
    8020505c:	2781                	sext.w	a5,a5
    8020505e:	00f71e63          	bne	a4,a5,8020507a <test_process_creation+0x26e>
            printf("【增强测试结果】: 新进程已成功回收，PID: %d\n", waited_new);
    80205062:	fd042783          	lw	a5,-48(s0)
    80205066:	85be                	mv	a1,a5
    80205068:	00003517          	auipc	a0,0x3
    8020506c:	34850513          	addi	a0,a0,840 # 802083b0 <small_numbers+0x1f60>
    80205070:	ffffc097          	auipc	ra,0xffffc
    80205074:	ae4080e7          	jalr	-1308(ra) # 80200b54 <printf>
    80205078:	a02d                	j	802050a2 <test_process_creation+0x296>
        } else {
            printf("【增强测试错误】: 新进程未正常回收，返回值: %d\n", waited_new);
    8020507a:	fd042783          	lw	a5,-48(s0)
    8020507e:	85be                	mv	a1,a5
    80205080:	00003517          	auipc	a0,0x3
    80205084:	37050513          	addi	a0,a0,880 # 802083f0 <small_numbers+0x1fa0>
    80205088:	ffffc097          	auipc	ra,0xffffc
    8020508c:	acc080e7          	jalr	-1332(ra) # 80200b54 <printf>
    80205090:	a809                	j	802050a2 <test_process_creation+0x296>
        }
    } else {
        printf("【增强测试错误】: 清理后无法重新创建进程，可能进程槽未归还\n");
    80205092:	00003517          	auipc	a0,0x3
    80205096:	3a650513          	addi	a0,a0,934 # 80208438 <small_numbers+0x1fe8>
    8020509a:	ffffc097          	auipc	ra,0xffffc
    8020509e:	aba080e7          	jalr	-1350(ra) # 80200b54 <printf>
    }

    printf("\n==================================================\n");
    802050a2:	00003517          	auipc	a0,0x3
    802050a6:	f6650513          	addi	a0,a0,-154 # 80208008 <small_numbers+0x1bb8>
    802050aa:	ffffc097          	auipc	ra,0xffffc
    802050ae:	aaa080e7          	jalr	-1366(ra) # 80200b54 <printf>
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    802050b2:	00003517          	auipc	a0,0x3
    802050b6:	3de50513          	addi	a0,a0,990 # 80208490 <small_numbers+0x2040>
    802050ba:	ffffc097          	auipc	ra,0xffffc
    802050be:	a9a080e7          	jalr	-1382(ra) # 80200b54 <printf>
    printf("==================================================\n\n");
    802050c2:	00003517          	auipc	a0,0x3
    802050c6:	40650513          	addi	a0,a0,1030 # 802084c8 <small_numbers+0x2078>
    802050ca:	ffffc097          	auipc	ra,0xffffc
    802050ce:	a8a080e7          	jalr	-1398(ra) # 80200b54 <printf>
}
    802050d2:	0001                	nop
    802050d4:	70e2                	ld	ra,56(sp)
    802050d6:	7442                	ld	s0,48(sp)
    802050d8:	6121                	addi	sp,sp,64
    802050da:	8082                	ret

00000000802050dc <cpu_intensive_task>:

void cpu_intensive_task(void) {
    802050dc:	1101                	addi	sp,sp,-32
    802050de:	ec06                	sd	ra,24(sp)
    802050e0:	e822                	sd	s0,16(sp)
    802050e2:	1000                	addi	s0,sp,32
    uint64 sum = 0;
    802050e4:	fe043423          	sd	zero,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    802050e8:	fe043023          	sd	zero,-32(s0)
    802050ec:	a829                	j	80205106 <cpu_intensive_task+0x2a>
        sum += i;
    802050ee:	fe843703          	ld	a4,-24(s0)
    802050f2:	fe043783          	ld	a5,-32(s0)
    802050f6:	97ba                	add	a5,a5,a4
    802050f8:	fef43423          	sd	a5,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    802050fc:	fe043783          	ld	a5,-32(s0)
    80205100:	0785                	addi	a5,a5,1
    80205102:	fef43023          	sd	a5,-32(s0)
    80205106:	fe043703          	ld	a4,-32(s0)
    8020510a:	009897b7          	lui	a5,0x989
    8020510e:	67f78793          	addi	a5,a5,1663 # 98967f <userret+0x9895e3>
    80205112:	fce7fee3          	bgeu	a5,a4,802050ee <cpu_intensive_task+0x12>
    }
    printf("CPU intensive task done in PID %d, sum=%lu\n", myproc()->pid, sum);
    80205116:	fffff097          	auipc	ra,0xfffff
    8020511a:	e42080e7          	jalr	-446(ra) # 80203f58 <myproc>
    8020511e:	87aa                	mv	a5,a0
    80205120:	43dc                	lw	a5,4(a5)
    80205122:	fe843603          	ld	a2,-24(s0)
    80205126:	85be                	mv	a1,a5
    80205128:	00003517          	auipc	a0,0x3
    8020512c:	3d850513          	addi	a0,a0,984 # 80208500 <small_numbers+0x20b0>
    80205130:	ffffc097          	auipc	ra,0xffffc
    80205134:	a24080e7          	jalr	-1500(ra) # 80200b54 <printf>
    exit_proc(0);
    80205138:	4501                	li	a0,0
    8020513a:	fffff097          	auipc	ra,0xfffff
    8020513e:	470080e7          	jalr	1136(ra) # 802045aa <exit_proc>
}
    80205142:	0001                	nop
    80205144:	60e2                	ld	ra,24(sp)
    80205146:	6442                	ld	s0,16(sp)
    80205148:	6105                	addi	sp,sp,32
    8020514a:	8082                	ret

000000008020514c <test_scheduler>:

void test_scheduler(void) {
    8020514c:	7179                	addi	sp,sp,-48
    8020514e:	f406                	sd	ra,40(sp)
    80205150:	f022                	sd	s0,32(sp)
    80205152:	1800                	addi	s0,sp,48
    printf("\n==================================================\n");
    80205154:	00003517          	auipc	a0,0x3
    80205158:	eb450513          	addi	a0,a0,-332 # 80208008 <small_numbers+0x1bb8>
    8020515c:	ffffc097          	auipc	ra,0xffffc
    80205160:	9f8080e7          	jalr	-1544(ra) # 80200b54 <printf>
    printf("===== 测试开始: 调度器测试 =====\n");
    80205164:	00003517          	auipc	a0,0x3
    80205168:	3cc50513          	addi	a0,a0,972 # 80208530 <small_numbers+0x20e0>
    8020516c:	ffffc097          	auipc	ra,0xffffc
    80205170:	9e8080e7          	jalr	-1560(ra) # 80200b54 <printf>
    printf("==================================================\n");
    80205174:	00003517          	auipc	a0,0x3
    80205178:	f0450513          	addi	a0,a0,-252 # 80208078 <small_numbers+0x1c28>
    8020517c:	ffffc097          	auipc	ra,0xffffc
    80205180:	9d8080e7          	jalr	-1576(ra) # 80200b54 <printf>

    // 创建多个计算密集型进程
    for (int i = 0; i < 3; i++) {
    80205184:	fe042623          	sw	zero,-20(s0)
    80205188:	a831                	j	802051a4 <test_scheduler+0x58>
        create_proc(cpu_intensive_task);
    8020518a:	00000517          	auipc	a0,0x0
    8020518e:	f5250513          	addi	a0,a0,-174 # 802050dc <cpu_intensive_task>
    80205192:	fffff097          	auipc	ra,0xfffff
    80205196:	39c080e7          	jalr	924(ra) # 8020452e <create_proc>
    for (int i = 0; i < 3; i++) {
    8020519a:	fec42783          	lw	a5,-20(s0)
    8020519e:	2785                	addiw	a5,a5,1
    802051a0:	fef42623          	sw	a5,-20(s0)
    802051a4:	fec42783          	lw	a5,-20(s0)
    802051a8:	0007871b          	sext.w	a4,a5
    802051ac:	4789                	li	a5,2
    802051ae:	fce7dee3          	bge	a5,a4,8020518a <test_scheduler+0x3e>
    }

    // 观察调度行为
    uint64 start_time = get_time();
    802051b2:	ffffe097          	auipc	ra,0xffffe
    802051b6:	55e080e7          	jalr	1374(ra) # 80203710 <get_time>
    802051ba:	fea43023          	sd	a0,-32(s0)
	for (int i = 0; i < 3; i++) {
    802051be:	fe042423          	sw	zero,-24(s0)
    802051c2:	a819                	j	802051d8 <test_scheduler+0x8c>
    	wait_proc(NULL); // 等待所有子进程结束
    802051c4:	4501                	li	a0,0
    802051c6:	fffff097          	auipc	ra,0xfffff
    802051ca:	41c080e7          	jalr	1052(ra) # 802045e2 <wait_proc>
	for (int i = 0; i < 3; i++) {
    802051ce:	fe842783          	lw	a5,-24(s0)
    802051d2:	2785                	addiw	a5,a5,1
    802051d4:	fef42423          	sw	a5,-24(s0)
    802051d8:	fe842783          	lw	a5,-24(s0)
    802051dc:	0007871b          	sext.w	a4,a5
    802051e0:	4789                	li	a5,2
    802051e2:	fee7d1e3          	bge	a5,a4,802051c4 <test_scheduler+0x78>
	}
    uint64 end_time = get_time();
    802051e6:	ffffe097          	auipc	ra,0xffffe
    802051ea:	52a080e7          	jalr	1322(ra) # 80203710 <get_time>
    802051ee:	fca43c23          	sd	a0,-40(s0)

    printf("Scheduler test completed in %lu cycles\n", end_time - start_time);
    802051f2:	fd843703          	ld	a4,-40(s0)
    802051f6:	fe043783          	ld	a5,-32(s0)
    802051fa:	40f707b3          	sub	a5,a4,a5
    802051fe:	85be                	mv	a1,a5
    80205200:	00003517          	auipc	a0,0x3
    80205204:	36050513          	addi	a0,a0,864 # 80208560 <small_numbers+0x2110>
    80205208:	ffffc097          	auipc	ra,0xffffc
    8020520c:	94c080e7          	jalr	-1716(ra) # 80200b54 <printf>
	printf("\n==================================================\n");
    80205210:	00003517          	auipc	a0,0x3
    80205214:	df850513          	addi	a0,a0,-520 # 80208008 <small_numbers+0x1bb8>
    80205218:	ffffc097          	auipc	ra,0xffffc
    8020521c:	93c080e7          	jalr	-1732(ra) # 80200b54 <printf>
    printf("===== 测试结束 =====\n");
    80205220:	00003517          	auipc	a0,0x3
    80205224:	36850513          	addi	a0,a0,872 # 80208588 <small_numbers+0x2138>
    80205228:	ffffc097          	auipc	ra,0xffffc
    8020522c:	92c080e7          	jalr	-1748(ra) # 80200b54 <printf>
    printf("==================================================\n");
    80205230:	00003517          	auipc	a0,0x3
    80205234:	e4850513          	addi	a0,a0,-440 # 80208078 <small_numbers+0x1c28>
    80205238:	ffffc097          	auipc	ra,0xffffc
    8020523c:	91c080e7          	jalr	-1764(ra) # 80200b54 <printf>
}
    80205240:	0001                	nop
    80205242:	70a2                	ld	ra,40(sp)
    80205244:	7402                	ld	s0,32(sp)
    80205246:	6145                	addi	sp,sp,48
    80205248:	8082                	ret

000000008020524a <shared_buffer_init>:
static int proc_buffer = 0;
static int proc_produced = 0;

void shared_buffer_init() {
    8020524a:	1141                	addi	sp,sp,-16
    8020524c:	e422                	sd	s0,8(sp)
    8020524e:	0800                	addi	s0,sp,16
    proc_buffer = 0;
    80205250:	00007797          	auipc	a5,0x7
    80205254:	a7078793          	addi	a5,a5,-1424 # 8020bcc0 <proc_buffer>
    80205258:	0007a023          	sw	zero,0(a5)
    proc_produced = 0;
    8020525c:	00007797          	auipc	a5,0x7
    80205260:	a6878793          	addi	a5,a5,-1432 # 8020bcc4 <proc_produced>
    80205264:	0007a023          	sw	zero,0(a5)
}
    80205268:	0001                	nop
    8020526a:	6422                	ld	s0,8(sp)
    8020526c:	0141                	addi	sp,sp,16
    8020526e:	8082                	ret

0000000080205270 <producer_task>:

void producer_task(void) {
    80205270:	1141                	addi	sp,sp,-16
    80205272:	e406                	sd	ra,8(sp)
    80205274:	e022                	sd	s0,0(sp)
    80205276:	0800                	addi	s0,sp,16
    proc_buffer = 42;
    80205278:	00007797          	auipc	a5,0x7
    8020527c:	a4878793          	addi	a5,a5,-1464 # 8020bcc0 <proc_buffer>
    80205280:	02a00713          	li	a4,42
    80205284:	c398                	sw	a4,0(a5)
    proc_produced = 1;
    80205286:	00007797          	auipc	a5,0x7
    8020528a:	a3e78793          	addi	a5,a5,-1474 # 8020bcc4 <proc_produced>
    8020528e:	4705                	li	a4,1
    80205290:	c398                	sw	a4,0(a5)
    wakeup(&proc_produced); // 唤醒消费者
    80205292:	00007517          	auipc	a0,0x7
    80205296:	a3250513          	addi	a0,a0,-1486 # 8020bcc4 <proc_produced>
    8020529a:	fffff097          	auipc	ra,0xfffff
    8020529e:	64c080e7          	jalr	1612(ra) # 802048e6 <wakeup>
    printf("Producer: produced value %d\n", proc_buffer);
    802052a2:	00007797          	auipc	a5,0x7
    802052a6:	a1e78793          	addi	a5,a5,-1506 # 8020bcc0 <proc_buffer>
    802052aa:	439c                	lw	a5,0(a5)
    802052ac:	85be                	mv	a1,a5
    802052ae:	00003517          	auipc	a0,0x3
    802052b2:	2fa50513          	addi	a0,a0,762 # 802085a8 <small_numbers+0x2158>
    802052b6:	ffffc097          	auipc	ra,0xffffc
    802052ba:	89e080e7          	jalr	-1890(ra) # 80200b54 <printf>
    exit_proc(0);
    802052be:	4501                	li	a0,0
    802052c0:	fffff097          	auipc	ra,0xfffff
    802052c4:	2ea080e7          	jalr	746(ra) # 802045aa <exit_proc>
}
    802052c8:	0001                	nop
    802052ca:	60a2                	ld	ra,8(sp)
    802052cc:	6402                	ld	s0,0(sp)
    802052ce:	0141                	addi	sp,sp,16
    802052d0:	8082                	ret

00000000802052d2 <consumer_task>:

void consumer_task(void) {
    802052d2:	1141                	addi	sp,sp,-16
    802052d4:	e406                	sd	ra,8(sp)
    802052d6:	e022                	sd	s0,0(sp)
    802052d8:	0800                	addi	s0,sp,16
    while (!proc_produced) {
    802052da:	a809                	j	802052ec <consumer_task+0x1a>
        sleep(&proc_produced); // 等待生产者
    802052dc:	00007517          	auipc	a0,0x7
    802052e0:	9e850513          	addi	a0,a0,-1560 # 8020bcc4 <proc_produced>
    802052e4:	fffff097          	auipc	ra,0xfffff
    802052e8:	598080e7          	jalr	1432(ra) # 8020487c <sleep>
    while (!proc_produced) {
    802052ec:	00007797          	auipc	a5,0x7
    802052f0:	9d878793          	addi	a5,a5,-1576 # 8020bcc4 <proc_produced>
    802052f4:	439c                	lw	a5,0(a5)
    802052f6:	d3fd                	beqz	a5,802052dc <consumer_task+0xa>
    }
    printf("Consumer: consumed value %d\n", proc_buffer);
    802052f8:	00007797          	auipc	a5,0x7
    802052fc:	9c878793          	addi	a5,a5,-1592 # 8020bcc0 <proc_buffer>
    80205300:	439c                	lw	a5,0(a5)
    80205302:	85be                	mv	a1,a5
    80205304:	00003517          	auipc	a0,0x3
    80205308:	2c450513          	addi	a0,a0,708 # 802085c8 <small_numbers+0x2178>
    8020530c:	ffffc097          	auipc	ra,0xffffc
    80205310:	848080e7          	jalr	-1976(ra) # 80200b54 <printf>
    exit_proc(0);
    80205314:	4501                	li	a0,0
    80205316:	fffff097          	auipc	ra,0xfffff
    8020531a:	294080e7          	jalr	660(ra) # 802045aa <exit_proc>
}
    8020531e:	0001                	nop
    80205320:	60a2                	ld	ra,8(sp)
    80205322:	6402                	ld	s0,0(sp)
    80205324:	0141                	addi	sp,sp,16
    80205326:	8082                	ret

0000000080205328 <test_synchronization>:
void test_synchronization(void) {
    80205328:	1141                	addi	sp,sp,-16
    8020532a:	e406                	sd	ra,8(sp)
    8020532c:	e022                	sd	s0,0(sp)
    8020532e:	0800                	addi	s0,sp,16
    printf("\n==================================================\n");
    80205330:	00003517          	auipc	a0,0x3
    80205334:	cd850513          	addi	a0,a0,-808 # 80208008 <small_numbers+0x1bb8>
    80205338:	ffffc097          	auipc	ra,0xffffc
    8020533c:	81c080e7          	jalr	-2020(ra) # 80200b54 <printf>
    printf("===== 测试开始: 同步机制测试 =====\n");
    80205340:	00003517          	auipc	a0,0x3
    80205344:	2a850513          	addi	a0,a0,680 # 802085e8 <small_numbers+0x2198>
    80205348:	ffffc097          	auipc	ra,0xffffc
    8020534c:	80c080e7          	jalr	-2036(ra) # 80200b54 <printf>
    printf("==================================================\n");
    80205350:	00003517          	auipc	a0,0x3
    80205354:	d2850513          	addi	a0,a0,-728 # 80208078 <small_numbers+0x1c28>
    80205358:	ffffb097          	auipc	ra,0xffffb
    8020535c:	7fc080e7          	jalr	2044(ra) # 80200b54 <printf>

    // 初始化共享缓冲区
    shared_buffer_init();
    80205360:	00000097          	auipc	ra,0x0
    80205364:	eea080e7          	jalr	-278(ra) # 8020524a <shared_buffer_init>

    // 创建生产者和消费者进程
    create_proc(producer_task);
    80205368:	00000517          	auipc	a0,0x0
    8020536c:	f0850513          	addi	a0,a0,-248 # 80205270 <producer_task>
    80205370:	fffff097          	auipc	ra,0xfffff
    80205374:	1be080e7          	jalr	446(ra) # 8020452e <create_proc>
    create_proc(consumer_task);
    80205378:	00000517          	auipc	a0,0x0
    8020537c:	f5a50513          	addi	a0,a0,-166 # 802052d2 <consumer_task>
    80205380:	fffff097          	auipc	ra,0xfffff
    80205384:	1ae080e7          	jalr	430(ra) # 8020452e <create_proc>

    // 等待两个进程完成
    wait_proc(NULL);
    80205388:	4501                	li	a0,0
    8020538a:	fffff097          	auipc	ra,0xfffff
    8020538e:	258080e7          	jalr	600(ra) # 802045e2 <wait_proc>
    wait_proc(NULL);
    80205392:	4501                	li	a0,0
    80205394:	fffff097          	auipc	ra,0xfffff
    80205398:	24e080e7          	jalr	590(ra) # 802045e2 <wait_proc>

    printf("Synchronization test completed\n");
    8020539c:	00003517          	auipc	a0,0x3
    802053a0:	27c50513          	addi	a0,a0,636 # 80208618 <small_numbers+0x21c8>
    802053a4:	ffffb097          	auipc	ra,0xffffb
    802053a8:	7b0080e7          	jalr	1968(ra) # 80200b54 <printf>
    printf("==================================================\n");
    802053ac:	00003517          	auipc	a0,0x3
    802053b0:	ccc50513          	addi	a0,a0,-820 # 80208078 <small_numbers+0x1c28>
    802053b4:	ffffb097          	auipc	ra,0xffffb
    802053b8:	7a0080e7          	jalr	1952(ra) # 80200b54 <printf>
    printf("===== 测试结束 =====\n");
    802053bc:	00003517          	auipc	a0,0x3
    802053c0:	1cc50513          	addi	a0,a0,460 # 80208588 <small_numbers+0x2138>
    802053c4:	ffffb097          	auipc	ra,0xffffb
    802053c8:	790080e7          	jalr	1936(ra) # 80200b54 <printf>
    printf("==================================================\n");
    802053cc:	00003517          	auipc	a0,0x3
    802053d0:	cac50513          	addi	a0,a0,-852 # 80208078 <small_numbers+0x1c28>
    802053d4:	ffffb097          	auipc	ra,0xffffb
    802053d8:	780080e7          	jalr	1920(ra) # 80200b54 <printf>
    802053dc:	0001                	nop
    802053de:	60a2                	ld	ra,8(sp)
    802053e0:	6402                	ld	s0,0(sp)
    802053e2:	0141                	addi	sp,sp,16
    802053e4:	8082                	ret

00000000802053e6 <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    802053e6:	7179                	addi	sp,sp,-48
    802053e8:	f422                	sd	s0,40(sp)
    802053ea:	1800                	addi	s0,sp,48
    802053ec:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    802053f0:	fe042623          	sw	zero,-20(s0)
    802053f4:	a031                	j	80205400 <strlen+0x1a>
    802053f6:	fec42783          	lw	a5,-20(s0)
    802053fa:	2785                	addiw	a5,a5,1
    802053fc:	fef42623          	sw	a5,-20(s0)
    80205400:	fec42783          	lw	a5,-20(s0)
    80205404:	fd843703          	ld	a4,-40(s0)
    80205408:	97ba                	add	a5,a5,a4
    8020540a:	0007c783          	lbu	a5,0(a5)
    8020540e:	f7e5                	bnez	a5,802053f6 <strlen+0x10>
        ;
    return n;
    80205410:	fec42783          	lw	a5,-20(s0)
}
    80205414:	853e                	mv	a0,a5
    80205416:	7422                	ld	s0,40(sp)
    80205418:	6145                	addi	sp,sp,48
    8020541a:	8082                	ret

000000008020541c <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    8020541c:	1101                	addi	sp,sp,-32
    8020541e:	ec22                	sd	s0,24(sp)
    80205420:	1000                	addi	s0,sp,32
    80205422:	fea43423          	sd	a0,-24(s0)
    80205426:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    8020542a:	a819                	j	80205440 <strcmp+0x24>
        p++, q++;
    8020542c:	fe843783          	ld	a5,-24(s0)
    80205430:	0785                	addi	a5,a5,1
    80205432:	fef43423          	sd	a5,-24(s0)
    80205436:	fe043783          	ld	a5,-32(s0)
    8020543a:	0785                	addi	a5,a5,1
    8020543c:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    80205440:	fe843783          	ld	a5,-24(s0)
    80205444:	0007c783          	lbu	a5,0(a5)
    80205448:	cb99                	beqz	a5,8020545e <strcmp+0x42>
    8020544a:	fe843783          	ld	a5,-24(s0)
    8020544e:	0007c703          	lbu	a4,0(a5)
    80205452:	fe043783          	ld	a5,-32(s0)
    80205456:	0007c783          	lbu	a5,0(a5)
    8020545a:	fcf709e3          	beq	a4,a5,8020542c <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    8020545e:	fe843783          	ld	a5,-24(s0)
    80205462:	0007c783          	lbu	a5,0(a5)
    80205466:	0007871b          	sext.w	a4,a5
    8020546a:	fe043783          	ld	a5,-32(s0)
    8020546e:	0007c783          	lbu	a5,0(a5)
    80205472:	2781                	sext.w	a5,a5
    80205474:	40f707bb          	subw	a5,a4,a5
    80205478:	2781                	sext.w	a5,a5
}
    8020547a:	853e                	mv	a0,a5
    8020547c:	6462                	ld	s0,24(sp)
    8020547e:	6105                	addi	sp,sp,32
    80205480:	8082                	ret

0000000080205482 <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    80205482:	7179                	addi	sp,sp,-48
    80205484:	f422                	sd	s0,40(sp)
    80205486:	1800                	addi	s0,sp,48
    80205488:	fca43c23          	sd	a0,-40(s0)
    8020548c:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    80205490:	fd843783          	ld	a5,-40(s0)
    80205494:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    80205498:	0001                	nop
    8020549a:	fd043703          	ld	a4,-48(s0)
    8020549e:	00170793          	addi	a5,a4,1
    802054a2:	fcf43823          	sd	a5,-48(s0)
    802054a6:	fd843783          	ld	a5,-40(s0)
    802054aa:	00178693          	addi	a3,a5,1
    802054ae:	fcd43c23          	sd	a3,-40(s0)
    802054b2:	00074703          	lbu	a4,0(a4)
    802054b6:	00e78023          	sb	a4,0(a5)
    802054ba:	0007c783          	lbu	a5,0(a5)
    802054be:	fff1                	bnez	a5,8020549a <strcpy+0x18>
        ;
    return os;
    802054c0:	fe843783          	ld	a5,-24(s0)
}
    802054c4:	853e                	mv	a0,a5
    802054c6:	7422                	ld	s0,40(sp)
    802054c8:	6145                	addi	sp,sp,48
    802054ca:	8082                	ret

00000000802054cc <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    802054cc:	7139                	addi	sp,sp,-64
    802054ce:	fc22                	sd	s0,56(sp)
    802054d0:	0080                	addi	s0,sp,64
    802054d2:	fca43c23          	sd	a0,-40(s0)
    802054d6:	fcb43823          	sd	a1,-48(s0)
    802054da:	87b2                	mv	a5,a2
    802054dc:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    802054e0:	fd843783          	ld	a5,-40(s0)
    802054e4:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    802054e8:	fcc42783          	lw	a5,-52(s0)
    802054ec:	2781                	sext.w	a5,a5
    802054ee:	00f04563          	bgtz	a5,802054f8 <safestrcpy+0x2c>
        return os;
    802054f2:	fe843783          	ld	a5,-24(s0)
    802054f6:	a0a9                	j	80205540 <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    802054f8:	0001                	nop
    802054fa:	fcc42783          	lw	a5,-52(s0)
    802054fe:	37fd                	addiw	a5,a5,-1
    80205500:	fcf42623          	sw	a5,-52(s0)
    80205504:	fcc42783          	lw	a5,-52(s0)
    80205508:	2781                	sext.w	a5,a5
    8020550a:	02f05563          	blez	a5,80205534 <safestrcpy+0x68>
    8020550e:	fd043703          	ld	a4,-48(s0)
    80205512:	00170793          	addi	a5,a4,1
    80205516:	fcf43823          	sd	a5,-48(s0)
    8020551a:	fd843783          	ld	a5,-40(s0)
    8020551e:	00178693          	addi	a3,a5,1
    80205522:	fcd43c23          	sd	a3,-40(s0)
    80205526:	00074703          	lbu	a4,0(a4)
    8020552a:	00e78023          	sb	a4,0(a5)
    8020552e:	0007c783          	lbu	a5,0(a5)
    80205532:	f7e1                	bnez	a5,802054fa <safestrcpy+0x2e>
        ;
    *s = 0;
    80205534:	fd843783          	ld	a5,-40(s0)
    80205538:	00078023          	sb	zero,0(a5)
    return os;
    8020553c:	fe843783          	ld	a5,-24(s0)
    80205540:	853e                	mv	a0,a5
    80205542:	7462                	ld	s0,56(sp)
    80205544:	6121                	addi	sp,sp,64
    80205546:	8082                	ret
	...
