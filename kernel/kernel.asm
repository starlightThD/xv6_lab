
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
    802000be:	960080e7          	jalr	-1696(ra) # 80202a1a <pmm_init>
	kvminit();
    802000c2:	00002097          	auipc	ra,0x2
    802000c6:	262080e7          	jalr	610(ra) # 80202324 <kvminit>
    kvminithart();
    802000ca:	00002097          	auipc	ra,0x2
    802000ce:	2ac080e7          	jalr	684(ra) # 80202376 <kvminithart>
	trap_init();
    802000d2:	00003097          	auipc	ra,0x3
    802000d6:	f52080e7          	jalr	-174(ra) # 80203024 <trap_init>
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
    8020011e:	fb4080e7          	jalr	-76(ra) # 802040ce <init_proc>
	int main_pid = create_proc(kernel_main);
    80200122:	00000517          	auipc	a0,0x0
    80200126:	3d250513          	addi	a0,a0,978 # 802004f4 <kernel_main>
    8020012a:	00004097          	auipc	ra,0x4
    8020012e:	394080e7          	jalr	916(ra) # 802044be <create_proc>
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
    80200156:	4fc080e7          	jalr	1276(ra) # 8020464e <schedule>
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
    80200254:	15c080e7          	jalr	348(ra) # 802053ac <strcmp>
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
    80200276:	13a080e7          	jalr	314(ra) # 802053ac <strcmp>
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
    80200330:	080080e7          	jalr	128(ra) # 802053ac <strcmp>
    80200334:	87aa                	mv	a5,a0
    80200336:	e791                	bnez	a5,80200342 <console+0x1ce>
            print_proc_table();
    80200338:	00005097          	auipc	ra,0x5
    8020033c:	84e080e7          	jalr	-1970(ra) # 80204b86 <print_proc_table>
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
    80200370:	040080e7          	jalr	64(ra) # 802053ac <strcmp>
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
    80200398:	12a080e7          	jalr	298(ra) # 802044be <create_proc>
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
    80200412:	164080e7          	jalr	356(ra) # 80204572 <wait_proc>
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
    80200510:	fb2080e7          	jalr	-78(ra) # 802044be <create_proc>
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
    80200556:	020080e7          	jalr	32(ra) # 80204572 <wait_proc>
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
    802005f8:	8ac080e7          	jalr	-1876(ra) # 80202ea0 <register_interrupt>
    enable_interrupts(UART0_IRQ);
    802005fc:	4529                	li	a0,10
    802005fe:	00003097          	auipc	ra,0x3
    80200602:	92c080e7          	jalr	-1748(ra) # 80202f2a <enable_interrupts>
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

0000000080201490 <test_printf_precision>:
}
void test_printf_precision(void) {
    80201490:	1101                	addi	sp,sp,-32
    80201492:	ec06                	sd	ra,24(sp)
    80201494:	e822                	sd	s0,16(sp)
    80201496:	1000                	addi	s0,sp,32
	clear_screen();
    80201498:	00000097          	auipc	ra,0x0
    8020149c:	ab4080e7          	jalr	-1356(ra) # 80200f4c <clear_screen>
    printf("=== 详细的Printf测试 ===\n");
    802014a0:	00005517          	auipc	a0,0x5
    802014a4:	1e850513          	addi	a0,a0,488 # 80206688 <small_numbers+0x238>
    802014a8:	fffff097          	auipc	ra,0xfffff
    802014ac:	6ac080e7          	jalr	1708(ra) # 80200b54 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    802014b0:	00005517          	auipc	a0,0x5
    802014b4:	1f850513          	addi	a0,a0,504 # 802066a8 <small_numbers+0x258>
    802014b8:	fffff097          	auipc	ra,0xfffff
    802014bc:	69c080e7          	jalr	1692(ra) # 80200b54 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    802014c0:	0ff00593          	li	a1,255
    802014c4:	00005517          	auipc	a0,0x5
    802014c8:	1fc50513          	addi	a0,a0,508 # 802066c0 <small_numbers+0x270>
    802014cc:	fffff097          	auipc	ra,0xfffff
    802014d0:	688080e7          	jalr	1672(ra) # 80200b54 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    802014d4:	6585                	lui	a1,0x1
    802014d6:	00005517          	auipc	a0,0x5
    802014da:	20a50513          	addi	a0,a0,522 # 802066e0 <small_numbers+0x290>
    802014de:	fffff097          	auipc	ra,0xfffff
    802014e2:	676080e7          	jalr	1654(ra) # 80200b54 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    802014e6:	1234b7b7          	lui	a5,0x1234b
    802014ea:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <userret+0x1234ab31>
    802014ee:	00005517          	auipc	a0,0x5
    802014f2:	21250513          	addi	a0,a0,530 # 80206700 <small_numbers+0x2b0>
    802014f6:	fffff097          	auipc	ra,0xfffff
    802014fa:	65e080e7          	jalr	1630(ra) # 80200b54 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    802014fe:	00005517          	auipc	a0,0x5
    80201502:	21a50513          	addi	a0,a0,538 # 80206718 <small_numbers+0x2c8>
    80201506:	fffff097          	auipc	ra,0xfffff
    8020150a:	64e080e7          	jalr	1614(ra) # 80200b54 <printf>
    printf("  正数: %d\n", 42);
    8020150e:	02a00593          	li	a1,42
    80201512:	00005517          	auipc	a0,0x5
    80201516:	21e50513          	addi	a0,a0,542 # 80206730 <small_numbers+0x2e0>
    8020151a:	fffff097          	auipc	ra,0xfffff
    8020151e:	63a080e7          	jalr	1594(ra) # 80200b54 <printf>
    printf("  负数: %d\n", -42);
    80201522:	fd600593          	li	a1,-42
    80201526:	00005517          	auipc	a0,0x5
    8020152a:	21a50513          	addi	a0,a0,538 # 80206740 <small_numbers+0x2f0>
    8020152e:	fffff097          	auipc	ra,0xfffff
    80201532:	626080e7          	jalr	1574(ra) # 80200b54 <printf>
    printf("  零: %d\n", 0);
    80201536:	4581                	li	a1,0
    80201538:	00005517          	auipc	a0,0x5
    8020153c:	21850513          	addi	a0,a0,536 # 80206750 <small_numbers+0x300>
    80201540:	fffff097          	auipc	ra,0xfffff
    80201544:	614080e7          	jalr	1556(ra) # 80200b54 <printf>
    printf("  大数: %d\n", 123456789);
    80201548:	075bd7b7          	lui	a5,0x75bd
    8020154c:	d1578593          	addi	a1,a5,-747 # 75bcd15 <userret+0x75bcc79>
    80201550:	00005517          	auipc	a0,0x5
    80201554:	21050513          	addi	a0,a0,528 # 80206760 <small_numbers+0x310>
    80201558:	fffff097          	auipc	ra,0xfffff
    8020155c:	5fc080e7          	jalr	1532(ra) # 80200b54 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80201560:	00005517          	auipc	a0,0x5
    80201564:	21050513          	addi	a0,a0,528 # 80206770 <small_numbers+0x320>
    80201568:	fffff097          	auipc	ra,0xfffff
    8020156c:	5ec080e7          	jalr	1516(ra) # 80200b54 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80201570:	55fd                	li	a1,-1
    80201572:	00005517          	auipc	a0,0x5
    80201576:	21650513          	addi	a0,a0,534 # 80206788 <small_numbers+0x338>
    8020157a:	fffff097          	auipc	ra,0xfffff
    8020157e:	5da080e7          	jalr	1498(ra) # 80200b54 <printf>
    printf("  零：%u\n", 0U);
    80201582:	4581                	li	a1,0
    80201584:	00005517          	auipc	a0,0x5
    80201588:	21c50513          	addi	a0,a0,540 # 802067a0 <small_numbers+0x350>
    8020158c:	fffff097          	auipc	ra,0xfffff
    80201590:	5c8080e7          	jalr	1480(ra) # 80200b54 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80201594:	678d                	lui	a5,0x3
    80201596:	03978593          	addi	a1,a5,57 # 3039 <userret+0x2f9d>
    8020159a:	00005517          	auipc	a0,0x5
    8020159e:	21650513          	addi	a0,a0,534 # 802067b0 <small_numbers+0x360>
    802015a2:	fffff097          	auipc	ra,0xfffff
    802015a6:	5b2080e7          	jalr	1458(ra) # 80200b54 <printf>

	// 测试边界
	printf("边界测试:\n");
    802015aa:	00005517          	auipc	a0,0x5
    802015ae:	21e50513          	addi	a0,a0,542 # 802067c8 <small_numbers+0x378>
    802015b2:	fffff097          	auipc	ra,0xfffff
    802015b6:	5a2080e7          	jalr	1442(ra) # 80200b54 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    802015ba:	800007b7          	lui	a5,0x80000
    802015be:	fff7c593          	not	a1,a5
    802015c2:	00005517          	auipc	a0,0x5
    802015c6:	21650513          	addi	a0,a0,534 # 802067d8 <small_numbers+0x388>
    802015ca:	fffff097          	auipc	ra,0xfffff
    802015ce:	58a080e7          	jalr	1418(ra) # 80200b54 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    802015d2:	800005b7          	lui	a1,0x80000
    802015d6:	00005517          	auipc	a0,0x5
    802015da:	21250513          	addi	a0,a0,530 # 802067e8 <small_numbers+0x398>
    802015de:	fffff097          	auipc	ra,0xfffff
    802015e2:	576080e7          	jalr	1398(ra) # 80200b54 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    802015e6:	55fd                	li	a1,-1
    802015e8:	00005517          	auipc	a0,0x5
    802015ec:	21050513          	addi	a0,a0,528 # 802067f8 <small_numbers+0x3a8>
    802015f0:	fffff097          	auipc	ra,0xfffff
    802015f4:	564080e7          	jalr	1380(ra) # 80200b54 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    802015f8:	55fd                	li	a1,-1
    802015fa:	00005517          	auipc	a0,0x5
    802015fe:	20e50513          	addi	a0,a0,526 # 80206808 <small_numbers+0x3b8>
    80201602:	fffff097          	auipc	ra,0xfffff
    80201606:	552080e7          	jalr	1362(ra) # 80200b54 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    8020160a:	00005517          	auipc	a0,0x5
    8020160e:	21650513          	addi	a0,a0,534 # 80206820 <small_numbers+0x3d0>
    80201612:	fffff097          	auipc	ra,0xfffff
    80201616:	542080e7          	jalr	1346(ra) # 80200b54 <printf>
    printf("  空字符串: '%s'\n", "");
    8020161a:	00005597          	auipc	a1,0x5
    8020161e:	21e58593          	addi	a1,a1,542 # 80206838 <small_numbers+0x3e8>
    80201622:	00005517          	auipc	a0,0x5
    80201626:	21e50513          	addi	a0,a0,542 # 80206840 <small_numbers+0x3f0>
    8020162a:	fffff097          	auipc	ra,0xfffff
    8020162e:	52a080e7          	jalr	1322(ra) # 80200b54 <printf>
    printf("  单字符: '%s'\n", "X");
    80201632:	00005597          	auipc	a1,0x5
    80201636:	22658593          	addi	a1,a1,550 # 80206858 <small_numbers+0x408>
    8020163a:	00005517          	auipc	a0,0x5
    8020163e:	22650513          	addi	a0,a0,550 # 80206860 <small_numbers+0x410>
    80201642:	fffff097          	auipc	ra,0xfffff
    80201646:	512080e7          	jalr	1298(ra) # 80200b54 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    8020164a:	00005597          	auipc	a1,0x5
    8020164e:	22e58593          	addi	a1,a1,558 # 80206878 <small_numbers+0x428>
    80201652:	00005517          	auipc	a0,0x5
    80201656:	24650513          	addi	a0,a0,582 # 80206898 <small_numbers+0x448>
    8020165a:	fffff097          	auipc	ra,0xfffff
    8020165e:	4fa080e7          	jalr	1274(ra) # 80200b54 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80201662:	00005597          	auipc	a1,0x5
    80201666:	24e58593          	addi	a1,a1,590 # 802068b0 <small_numbers+0x460>
    8020166a:	00005517          	auipc	a0,0x5
    8020166e:	39650513          	addi	a0,a0,918 # 80206a00 <small_numbers+0x5b0>
    80201672:	fffff097          	auipc	ra,0xfffff
    80201676:	4e2080e7          	jalr	1250(ra) # 80200b54 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    8020167a:	00005517          	auipc	a0,0x5
    8020167e:	3a650513          	addi	a0,a0,934 # 80206a20 <small_numbers+0x5d0>
    80201682:	fffff097          	auipc	ra,0xfffff
    80201686:	4d2080e7          	jalr	1234(ra) # 80200b54 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    8020168a:	0ff00693          	li	a3,255
    8020168e:	f0100613          	li	a2,-255
    80201692:	0ff00593          	li	a1,255
    80201696:	00005517          	auipc	a0,0x5
    8020169a:	3a250513          	addi	a0,a0,930 # 80206a38 <small_numbers+0x5e8>
    8020169e:	fffff097          	auipc	ra,0xfffff
    802016a2:	4b6080e7          	jalr	1206(ra) # 80200b54 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    802016a6:	00005517          	auipc	a0,0x5
    802016aa:	3ba50513          	addi	a0,a0,954 # 80206a60 <small_numbers+0x610>
    802016ae:	fffff097          	auipc	ra,0xfffff
    802016b2:	4a6080e7          	jalr	1190(ra) # 80200b54 <printf>
	printf("  100%% 完成!\n");
    802016b6:	00005517          	auipc	a0,0x5
    802016ba:	3c250513          	addi	a0,a0,962 # 80206a78 <small_numbers+0x628>
    802016be:	fffff097          	auipc	ra,0xfffff
    802016c2:	496080e7          	jalr	1174(ra) # 80200b54 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    802016c6:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    802016ca:	00005517          	auipc	a0,0x5
    802016ce:	3c650513          	addi	a0,a0,966 # 80206a90 <small_numbers+0x640>
    802016d2:	fffff097          	auipc	ra,0xfffff
    802016d6:	482080e7          	jalr	1154(ra) # 80200b54 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    802016da:	fe843583          	ld	a1,-24(s0)
    802016de:	00005517          	auipc	a0,0x5
    802016e2:	3ca50513          	addi	a0,a0,970 # 80206aa8 <small_numbers+0x658>
    802016e6:	fffff097          	auipc	ra,0xfffff
    802016ea:	46e080e7          	jalr	1134(ra) # 80200b54 <printf>
	
	// 测试指针格式
	int var = 42;
    802016ee:	02a00793          	li	a5,42
    802016f2:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    802016f6:	00005517          	auipc	a0,0x5
    802016fa:	3ca50513          	addi	a0,a0,970 # 80206ac0 <small_numbers+0x670>
    802016fe:	fffff097          	auipc	ra,0xfffff
    80201702:	456080e7          	jalr	1110(ra) # 80200b54 <printf>
	printf("  Address of var: %p\n", &var);
    80201706:	fe440793          	addi	a5,s0,-28
    8020170a:	85be                	mv	a1,a5
    8020170c:	00005517          	auipc	a0,0x5
    80201710:	3c450513          	addi	a0,a0,964 # 80206ad0 <small_numbers+0x680>
    80201714:	fffff097          	auipc	ra,0xfffff
    80201718:	440080e7          	jalr	1088(ra) # 80200b54 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    8020171c:	00005517          	auipc	a0,0x5
    80201720:	3cc50513          	addi	a0,a0,972 # 80206ae8 <small_numbers+0x698>
    80201724:	fffff097          	auipc	ra,0xfffff
    80201728:	430080e7          	jalr	1072(ra) # 80200b54 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    8020172c:	55fd                	li	a1,-1
    8020172e:	00005517          	auipc	a0,0x5
    80201732:	3da50513          	addi	a0,a0,986 # 80206b08 <small_numbers+0x6b8>
    80201736:	fffff097          	auipc	ra,0xfffff
    8020173a:	41e080e7          	jalr	1054(ra) # 80200b54 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    8020173e:	00005517          	auipc	a0,0x5
    80201742:	3e250513          	addi	a0,a0,994 # 80206b20 <small_numbers+0x6d0>
    80201746:	fffff097          	auipc	ra,0xfffff
    8020174a:	40e080e7          	jalr	1038(ra) # 80200b54 <printf>
	printf("  Binary of 5: %b\n", 5);
    8020174e:	4595                	li	a1,5
    80201750:	00005517          	auipc	a0,0x5
    80201754:	3e850513          	addi	a0,a0,1000 # 80206b38 <small_numbers+0x6e8>
    80201758:	fffff097          	auipc	ra,0xfffff
    8020175c:	3fc080e7          	jalr	1020(ra) # 80200b54 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201760:	45a1                	li	a1,8
    80201762:	00005517          	auipc	a0,0x5
    80201766:	3ee50513          	addi	a0,a0,1006 # 80206b50 <small_numbers+0x700>
    8020176a:	fffff097          	auipc	ra,0xfffff
    8020176e:	3ea080e7          	jalr	1002(ra) # 80200b54 <printf>
	printf("=== Printf测试结束 ===\n");
    80201772:	00005517          	auipc	a0,0x5
    80201776:	3f650513          	addi	a0,a0,1014 # 80206b68 <small_numbers+0x718>
    8020177a:	fffff097          	auipc	ra,0xfffff
    8020177e:	3da080e7          	jalr	986(ra) # 80200b54 <printf>
}
    80201782:	0001                	nop
    80201784:	60e2                	ld	ra,24(sp)
    80201786:	6442                	ld	s0,16(sp)
    80201788:	6105                	addi	sp,sp,32
    8020178a:	8082                	ret

000000008020178c <test_curse_move>:
void test_curse_move(){
    8020178c:	1101                	addi	sp,sp,-32
    8020178e:	ec06                	sd	ra,24(sp)
    80201790:	e822                	sd	s0,16(sp)
    80201792:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    80201794:	fffff097          	auipc	ra,0xfffff
    80201798:	7b8080e7          	jalr	1976(ra) # 80200f4c <clear_screen>
	printf("=== 光标移动测试 ===\n");
    8020179c:	00005517          	auipc	a0,0x5
    802017a0:	3ec50513          	addi	a0,a0,1004 # 80206b88 <small_numbers+0x738>
    802017a4:	fffff097          	auipc	ra,0xfffff
    802017a8:	3b0080e7          	jalr	944(ra) # 80200b54 <printf>
	for (int i = 3; i <= 7; i++) {
    802017ac:	478d                	li	a5,3
    802017ae:	fef42623          	sw	a5,-20(s0)
    802017b2:	a881                	j	80201802 <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    802017b4:	4785                	li	a5,1
    802017b6:	fef42423          	sw	a5,-24(s0)
    802017ba:	a805                	j	802017ea <test_curse_move+0x5e>
			goto_rc(i, j);
    802017bc:	fe842703          	lw	a4,-24(s0)
    802017c0:	fec42783          	lw	a5,-20(s0)
    802017c4:	85ba                	mv	a1,a4
    802017c6:	853e                	mv	a0,a5
    802017c8:	00000097          	auipc	ra,0x0
    802017cc:	9da080e7          	jalr	-1574(ra) # 802011a2 <goto_rc>
			printf("*");
    802017d0:	00005517          	auipc	a0,0x5
    802017d4:	3d850513          	addi	a0,a0,984 # 80206ba8 <small_numbers+0x758>
    802017d8:	fffff097          	auipc	ra,0xfffff
    802017dc:	37c080e7          	jalr	892(ra) # 80200b54 <printf>
		for (int j = 1; j <= 10; j++) {
    802017e0:	fe842783          	lw	a5,-24(s0)
    802017e4:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdf42b1>
    802017e6:	fef42423          	sw	a5,-24(s0)
    802017ea:	fe842783          	lw	a5,-24(s0)
    802017ee:	0007871b          	sext.w	a4,a5
    802017f2:	47a9                	li	a5,10
    802017f4:	fce7d4e3          	bge	a5,a4,802017bc <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    802017f8:	fec42783          	lw	a5,-20(s0)
    802017fc:	2785                	addiw	a5,a5,1
    802017fe:	fef42623          	sw	a5,-20(s0)
    80201802:	fec42783          	lw	a5,-20(s0)
    80201806:	0007871b          	sext.w	a4,a5
    8020180a:	479d                	li	a5,7
    8020180c:	fae7d4e3          	bge	a5,a4,802017b4 <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201810:	4585                	li	a1,1
    80201812:	4525                	li	a0,9
    80201814:	00000097          	auipc	ra,0x0
    80201818:	98e080e7          	jalr	-1650(ra) # 802011a2 <goto_rc>
	save_cursor();
    8020181c:	00000097          	auipc	ra,0x0
    80201820:	8c2080e7          	jalr	-1854(ra) # 802010de <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201824:	4515                	li	a0,5
    80201826:	fffff097          	auipc	ra,0xfffff
    8020182a:	758080e7          	jalr	1880(ra) # 80200f7e <cursor_up>
	cursor_right(2);
    8020182e:	4509                	li	a0,2
    80201830:	fffff097          	auipc	ra,0xfffff
    80201834:	7fe080e7          	jalr	2046(ra) # 8020102e <cursor_right>
	printf("+++++");
    80201838:	00005517          	auipc	a0,0x5
    8020183c:	37850513          	addi	a0,a0,888 # 80206bb0 <small_numbers+0x760>
    80201840:	fffff097          	auipc	ra,0xfffff
    80201844:	314080e7          	jalr	788(ra) # 80200b54 <printf>
	cursor_down(2);
    80201848:	4509                	li	a0,2
    8020184a:	fffff097          	auipc	ra,0xfffff
    8020184e:	78c080e7          	jalr	1932(ra) # 80200fd6 <cursor_down>
	cursor_left(5);
    80201852:	4515                	li	a0,5
    80201854:	00000097          	auipc	ra,0x0
    80201858:	832080e7          	jalr	-1998(ra) # 80201086 <cursor_left>
	printf("-----");
    8020185c:	00005517          	auipc	a0,0x5
    80201860:	35c50513          	addi	a0,a0,860 # 80206bb8 <small_numbers+0x768>
    80201864:	fffff097          	auipc	ra,0xfffff
    80201868:	2f0080e7          	jalr	752(ra) # 80200b54 <printf>
	restore_cursor();
    8020186c:	00000097          	auipc	ra,0x0
    80201870:	8a6080e7          	jalr	-1882(ra) # 80201112 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80201874:	00005517          	auipc	a0,0x5
    80201878:	34c50513          	addi	a0,a0,844 # 80206bc0 <small_numbers+0x770>
    8020187c:	fffff097          	auipc	ra,0xfffff
    80201880:	2d8080e7          	jalr	728(ra) # 80200b54 <printf>
}
    80201884:	0001                	nop
    80201886:	60e2                	ld	ra,24(sp)
    80201888:	6442                	ld	s0,16(sp)
    8020188a:	6105                	addi	sp,sp,32
    8020188c:	8082                	ret

000000008020188e <test_basic_colors>:

void test_basic_colors(void) {
    8020188e:	1141                	addi	sp,sp,-16
    80201890:	e406                	sd	ra,8(sp)
    80201892:	e022                	sd	s0,0(sp)
    80201894:	0800                	addi	s0,sp,16
    clear_screen();
    80201896:	fffff097          	auipc	ra,0xfffff
    8020189a:	6b6080e7          	jalr	1718(ra) # 80200f4c <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    8020189e:	00005517          	auipc	a0,0x5
    802018a2:	34a50513          	addi	a0,a0,842 # 80206be8 <small_numbers+0x798>
    802018a6:	fffff097          	auipc	ra,0xfffff
    802018aa:	2ae080e7          	jalr	686(ra) # 80200b54 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    802018ae:	00005517          	auipc	a0,0x5
    802018b2:	35a50513          	addi	a0,a0,858 # 80206c08 <small_numbers+0x7b8>
    802018b6:	fffff097          	auipc	ra,0xfffff
    802018ba:	29e080e7          	jalr	670(ra) # 80200b54 <printf>
    color_red();    printf("红色文字 ");
    802018be:	00000097          	auipc	ra,0x0
    802018c2:	a52080e7          	jalr	-1454(ra) # 80201310 <color_red>
    802018c6:	00005517          	auipc	a0,0x5
    802018ca:	35a50513          	addi	a0,a0,858 # 80206c20 <small_numbers+0x7d0>
    802018ce:	fffff097          	auipc	ra,0xfffff
    802018d2:	286080e7          	jalr	646(ra) # 80200b54 <printf>
    color_green();  printf("绿色文字 ");
    802018d6:	00000097          	auipc	ra,0x0
    802018da:	a56080e7          	jalr	-1450(ra) # 8020132c <color_green>
    802018de:	00005517          	auipc	a0,0x5
    802018e2:	35250513          	addi	a0,a0,850 # 80206c30 <small_numbers+0x7e0>
    802018e6:	fffff097          	auipc	ra,0xfffff
    802018ea:	26e080e7          	jalr	622(ra) # 80200b54 <printf>
    color_yellow(); printf("黄色文字 ");
    802018ee:	00000097          	auipc	ra,0x0
    802018f2:	a5c080e7          	jalr	-1444(ra) # 8020134a <color_yellow>
    802018f6:	00005517          	auipc	a0,0x5
    802018fa:	34a50513          	addi	a0,a0,842 # 80206c40 <small_numbers+0x7f0>
    802018fe:	fffff097          	auipc	ra,0xfffff
    80201902:	256080e7          	jalr	598(ra) # 80200b54 <printf>
    color_blue();   printf("蓝色文字 ");
    80201906:	00000097          	auipc	ra,0x0
    8020190a:	a62080e7          	jalr	-1438(ra) # 80201368 <color_blue>
    8020190e:	00005517          	auipc	a0,0x5
    80201912:	34250513          	addi	a0,a0,834 # 80206c50 <small_numbers+0x800>
    80201916:	fffff097          	auipc	ra,0xfffff
    8020191a:	23e080e7          	jalr	574(ra) # 80200b54 <printf>
    color_purple(); printf("紫色文字 ");
    8020191e:	00000097          	auipc	ra,0x0
    80201922:	a68080e7          	jalr	-1432(ra) # 80201386 <color_purple>
    80201926:	00005517          	auipc	a0,0x5
    8020192a:	33a50513          	addi	a0,a0,826 # 80206c60 <small_numbers+0x810>
    8020192e:	fffff097          	auipc	ra,0xfffff
    80201932:	226080e7          	jalr	550(ra) # 80200b54 <printf>
    color_cyan();   printf("青色文字 ");
    80201936:	00000097          	auipc	ra,0x0
    8020193a:	a6e080e7          	jalr	-1426(ra) # 802013a4 <color_cyan>
    8020193e:	00005517          	auipc	a0,0x5
    80201942:	33250513          	addi	a0,a0,818 # 80206c70 <small_numbers+0x820>
    80201946:	fffff097          	auipc	ra,0xfffff
    8020194a:	20e080e7          	jalr	526(ra) # 80200b54 <printf>
    color_reverse();  printf("反色文字");
    8020194e:	00000097          	auipc	ra,0x0
    80201952:	a74080e7          	jalr	-1420(ra) # 802013c2 <color_reverse>
    80201956:	00005517          	auipc	a0,0x5
    8020195a:	32a50513          	addi	a0,a0,810 # 80206c80 <small_numbers+0x830>
    8020195e:	fffff097          	auipc	ra,0xfffff
    80201962:	1f6080e7          	jalr	502(ra) # 80200b54 <printf>
    reset_color();
    80201966:	00000097          	auipc	ra,0x0
    8020196a:	8ae080e7          	jalr	-1874(ra) # 80201214 <reset_color>
    printf("\n\n");
    8020196e:	00005517          	auipc	a0,0x5
    80201972:	32250513          	addi	a0,a0,802 # 80206c90 <small_numbers+0x840>
    80201976:	fffff097          	auipc	ra,0xfffff
    8020197a:	1de080e7          	jalr	478(ra) # 80200b54 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    8020197e:	00005517          	auipc	a0,0x5
    80201982:	31a50513          	addi	a0,a0,794 # 80206c98 <small_numbers+0x848>
    80201986:	fffff097          	auipc	ra,0xfffff
    8020198a:	1ce080e7          	jalr	462(ra) # 80200b54 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    8020198e:	02900513          	li	a0,41
    80201992:	00000097          	auipc	ra,0x0
    80201996:	910080e7          	jalr	-1776(ra) # 802012a2 <set_bg_color>
    8020199a:	00005517          	auipc	a0,0x5
    8020199e:	31650513          	addi	a0,a0,790 # 80206cb0 <small_numbers+0x860>
    802019a2:	fffff097          	auipc	ra,0xfffff
    802019a6:	1b2080e7          	jalr	434(ra) # 80200b54 <printf>
    802019aa:	00000097          	auipc	ra,0x0
    802019ae:	86a080e7          	jalr	-1942(ra) # 80201214 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    802019b2:	02a00513          	li	a0,42
    802019b6:	00000097          	auipc	ra,0x0
    802019ba:	8ec080e7          	jalr	-1812(ra) # 802012a2 <set_bg_color>
    802019be:	00005517          	auipc	a0,0x5
    802019c2:	30250513          	addi	a0,a0,770 # 80206cc0 <small_numbers+0x870>
    802019c6:	fffff097          	auipc	ra,0xfffff
    802019ca:	18e080e7          	jalr	398(ra) # 80200b54 <printf>
    802019ce:	00000097          	auipc	ra,0x0
    802019d2:	846080e7          	jalr	-1978(ra) # 80201214 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    802019d6:	02b00513          	li	a0,43
    802019da:	00000097          	auipc	ra,0x0
    802019de:	8c8080e7          	jalr	-1848(ra) # 802012a2 <set_bg_color>
    802019e2:	00005517          	auipc	a0,0x5
    802019e6:	2ee50513          	addi	a0,a0,750 # 80206cd0 <small_numbers+0x880>
    802019ea:	fffff097          	auipc	ra,0xfffff
    802019ee:	16a080e7          	jalr	362(ra) # 80200b54 <printf>
    802019f2:	00000097          	auipc	ra,0x0
    802019f6:	822080e7          	jalr	-2014(ra) # 80201214 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    802019fa:	02c00513          	li	a0,44
    802019fe:	00000097          	auipc	ra,0x0
    80201a02:	8a4080e7          	jalr	-1884(ra) # 802012a2 <set_bg_color>
    80201a06:	00005517          	auipc	a0,0x5
    80201a0a:	2da50513          	addi	a0,a0,730 # 80206ce0 <small_numbers+0x890>
    80201a0e:	fffff097          	auipc	ra,0xfffff
    80201a12:	146080e7          	jalr	326(ra) # 80200b54 <printf>
    80201a16:	fffff097          	auipc	ra,0xfffff
    80201a1a:	7fe080e7          	jalr	2046(ra) # 80201214 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201a1e:	02f00513          	li	a0,47
    80201a22:	00000097          	auipc	ra,0x0
    80201a26:	880080e7          	jalr	-1920(ra) # 802012a2 <set_bg_color>
    80201a2a:	00005517          	auipc	a0,0x5
    80201a2e:	2c650513          	addi	a0,a0,710 # 80206cf0 <small_numbers+0x8a0>
    80201a32:	fffff097          	auipc	ra,0xfffff
    80201a36:	122080e7          	jalr	290(ra) # 80200b54 <printf>
    80201a3a:	fffff097          	auipc	ra,0xfffff
    80201a3e:	7da080e7          	jalr	2010(ra) # 80201214 <reset_color>
    printf("\n\n");
    80201a42:	00005517          	auipc	a0,0x5
    80201a46:	24e50513          	addi	a0,a0,590 # 80206c90 <small_numbers+0x840>
    80201a4a:	fffff097          	auipc	ra,0xfffff
    80201a4e:	10a080e7          	jalr	266(ra) # 80200b54 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201a52:	00005517          	auipc	a0,0x5
    80201a56:	2ae50513          	addi	a0,a0,686 # 80206d00 <small_numbers+0x8b0>
    80201a5a:	fffff097          	auipc	ra,0xfffff
    80201a5e:	0fa080e7          	jalr	250(ra) # 80200b54 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201a62:	02c00593          	li	a1,44
    80201a66:	457d                	li	a0,31
    80201a68:	00000097          	auipc	ra,0x0
    80201a6c:	978080e7          	jalr	-1672(ra) # 802013e0 <set_color>
    80201a70:	00005517          	auipc	a0,0x5
    80201a74:	2a850513          	addi	a0,a0,680 # 80206d18 <small_numbers+0x8c8>
    80201a78:	fffff097          	auipc	ra,0xfffff
    80201a7c:	0dc080e7          	jalr	220(ra) # 80200b54 <printf>
    80201a80:	fffff097          	auipc	ra,0xfffff
    80201a84:	794080e7          	jalr	1940(ra) # 80201214 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201a88:	02d00593          	li	a1,45
    80201a8c:	02100513          	li	a0,33
    80201a90:	00000097          	auipc	ra,0x0
    80201a94:	950080e7          	jalr	-1712(ra) # 802013e0 <set_color>
    80201a98:	00005517          	auipc	a0,0x5
    80201a9c:	29050513          	addi	a0,a0,656 # 80206d28 <small_numbers+0x8d8>
    80201aa0:	fffff097          	auipc	ra,0xfffff
    80201aa4:	0b4080e7          	jalr	180(ra) # 80200b54 <printf>
    80201aa8:	fffff097          	auipc	ra,0xfffff
    80201aac:	76c080e7          	jalr	1900(ra) # 80201214 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201ab0:	02f00593          	li	a1,47
    80201ab4:	02000513          	li	a0,32
    80201ab8:	00000097          	auipc	ra,0x0
    80201abc:	928080e7          	jalr	-1752(ra) # 802013e0 <set_color>
    80201ac0:	00005517          	auipc	a0,0x5
    80201ac4:	27850513          	addi	a0,a0,632 # 80206d38 <small_numbers+0x8e8>
    80201ac8:	fffff097          	auipc	ra,0xfffff
    80201acc:	08c080e7          	jalr	140(ra) # 80200b54 <printf>
    80201ad0:	fffff097          	auipc	ra,0xfffff
    80201ad4:	744080e7          	jalr	1860(ra) # 80201214 <reset_color>
    printf("\n\n");
    80201ad8:	00005517          	auipc	a0,0x5
    80201adc:	1b850513          	addi	a0,a0,440 # 80206c90 <small_numbers+0x840>
    80201ae0:	fffff097          	auipc	ra,0xfffff
    80201ae4:	074080e7          	jalr	116(ra) # 80200b54 <printf>
	reset_color();
    80201ae8:	fffff097          	auipc	ra,0xfffff
    80201aec:	72c080e7          	jalr	1836(ra) # 80201214 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201af0:	00005517          	auipc	a0,0x5
    80201af4:	25850513          	addi	a0,a0,600 # 80206d48 <small_numbers+0x8f8>
    80201af8:	fffff097          	auipc	ra,0xfffff
    80201afc:	05c080e7          	jalr	92(ra) # 80200b54 <printf>
	cursor_up(1); // 光标上移一行
    80201b00:	4505                	li	a0,1
    80201b02:	fffff097          	auipc	ra,0xfffff
    80201b06:	47c080e7          	jalr	1148(ra) # 80200f7e <cursor_up>
	clear_line();
    80201b0a:	00000097          	auipc	ra,0x0
    80201b0e:	912080e7          	jalr	-1774(ra) # 8020141c <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201b12:	00005517          	auipc	a0,0x5
    80201b16:	26e50513          	addi	a0,a0,622 # 80206d80 <small_numbers+0x930>
    80201b1a:	fffff097          	auipc	ra,0xfffff
    80201b1e:	03a080e7          	jalr	58(ra) # 80200b54 <printf>
    80201b22:	0001                	nop
    80201b24:	60a2                	ld	ra,8(sp)
    80201b26:	6402                	ld	s0,0(sp)
    80201b28:	0141                	addi	sp,sp,16
    80201b2a:	8082                	ret

0000000080201b2c <memset>:
#include "defs.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201b2c:	7139                	addi	sp,sp,-64
    80201b2e:	fc22                	sd	s0,56(sp)
    80201b30:	0080                	addi	s0,sp,64
    80201b32:	fca43c23          	sd	a0,-40(s0)
    80201b36:	87ae                	mv	a5,a1
    80201b38:	fcc43423          	sd	a2,-56(s0)
    80201b3c:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201b40:	fd843783          	ld	a5,-40(s0)
    80201b44:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    80201b48:	a829                	j	80201b62 <memset+0x36>
        *p++ = (unsigned char)c;
    80201b4a:	fe843783          	ld	a5,-24(s0)
    80201b4e:	00178713          	addi	a4,a5,1
    80201b52:	fee43423          	sd	a4,-24(s0)
    80201b56:	fd442703          	lw	a4,-44(s0)
    80201b5a:	0ff77713          	zext.b	a4,a4
    80201b5e:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    80201b62:	fc843783          	ld	a5,-56(s0)
    80201b66:	fff78713          	addi	a4,a5,-1
    80201b6a:	fce43423          	sd	a4,-56(s0)
    80201b6e:	fff1                	bnez	a5,80201b4a <memset+0x1e>
    return dst;
    80201b70:	fd843783          	ld	a5,-40(s0)
}
    80201b74:	853e                	mv	a0,a5
    80201b76:	7462                	ld	s0,56(sp)
    80201b78:	6121                	addi	sp,sp,64
    80201b7a:	8082                	ret

0000000080201b7c <memmove>:
void *memmove(void *dst, const void *src, unsigned long n) {
    80201b7c:	7139                	addi	sp,sp,-64
    80201b7e:	fc22                	sd	s0,56(sp)
    80201b80:	0080                	addi	s0,sp,64
    80201b82:	fca43c23          	sd	a0,-40(s0)
    80201b86:	fcb43823          	sd	a1,-48(s0)
    80201b8a:	fcc43423          	sd	a2,-56(s0)
	unsigned char *d = dst;
    80201b8e:	fd843783          	ld	a5,-40(s0)
    80201b92:	fef43423          	sd	a5,-24(s0)
	const unsigned char *s = src;
    80201b96:	fd043783          	ld	a5,-48(s0)
    80201b9a:	fef43023          	sd	a5,-32(s0)
	if (d < s) {
    80201b9e:	fe843703          	ld	a4,-24(s0)
    80201ba2:	fe043783          	ld	a5,-32(s0)
    80201ba6:	02f77b63          	bgeu	a4,a5,80201bdc <memmove+0x60>
		while (n-- > 0)
    80201baa:	a00d                	j	80201bcc <memmove+0x50>
			*d++ = *s++;
    80201bac:	fe043703          	ld	a4,-32(s0)
    80201bb0:	00170793          	addi	a5,a4,1
    80201bb4:	fef43023          	sd	a5,-32(s0)
    80201bb8:	fe843783          	ld	a5,-24(s0)
    80201bbc:	00178693          	addi	a3,a5,1
    80201bc0:	fed43423          	sd	a3,-24(s0)
    80201bc4:	00074703          	lbu	a4,0(a4)
    80201bc8:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201bcc:	fc843783          	ld	a5,-56(s0)
    80201bd0:	fff78713          	addi	a4,a5,-1
    80201bd4:	fce43423          	sd	a4,-56(s0)
    80201bd8:	fbf1                	bnez	a5,80201bac <memmove+0x30>
    80201bda:	a889                	j	80201c2c <memmove+0xb0>
	} else {
		d += n;
    80201bdc:	fe843703          	ld	a4,-24(s0)
    80201be0:	fc843783          	ld	a5,-56(s0)
    80201be4:	97ba                	add	a5,a5,a4
    80201be6:	fef43423          	sd	a5,-24(s0)
		s += n;
    80201bea:	fe043703          	ld	a4,-32(s0)
    80201bee:	fc843783          	ld	a5,-56(s0)
    80201bf2:	97ba                	add	a5,a5,a4
    80201bf4:	fef43023          	sd	a5,-32(s0)
		while (n-- > 0)
    80201bf8:	a01d                	j	80201c1e <memmove+0xa2>
			*(--d) = *(--s);
    80201bfa:	fe043783          	ld	a5,-32(s0)
    80201bfe:	17fd                	addi	a5,a5,-1
    80201c00:	fef43023          	sd	a5,-32(s0)
    80201c04:	fe843783          	ld	a5,-24(s0)
    80201c08:	17fd                	addi	a5,a5,-1
    80201c0a:	fef43423          	sd	a5,-24(s0)
    80201c0e:	fe043783          	ld	a5,-32(s0)
    80201c12:	0007c703          	lbu	a4,0(a5)
    80201c16:	fe843783          	ld	a5,-24(s0)
    80201c1a:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201c1e:	fc843783          	ld	a5,-56(s0)
    80201c22:	fff78713          	addi	a4,a5,-1
    80201c26:	fce43423          	sd	a4,-56(s0)
    80201c2a:	fbe1                	bnez	a5,80201bfa <memmove+0x7e>
	}
	return dst;
    80201c2c:	fd843783          	ld	a5,-40(s0)
}
    80201c30:	853e                	mv	a0,a5
    80201c32:	7462                	ld	s0,56(sp)
    80201c34:	6121                	addi	sp,sp,64
    80201c36:	8082                	ret

0000000080201c38 <memcpy>:
void *memcpy(void *dst, const void *src, size_t n) {
    80201c38:	715d                	addi	sp,sp,-80
    80201c3a:	e4a2                	sd	s0,72(sp)
    80201c3c:	0880                	addi	s0,sp,80
    80201c3e:	fca43423          	sd	a0,-56(s0)
    80201c42:	fcb43023          	sd	a1,-64(s0)
    80201c46:	fac43c23          	sd	a2,-72(s0)
    char *d = dst;
    80201c4a:	fc843783          	ld	a5,-56(s0)
    80201c4e:	fef43023          	sd	a5,-32(s0)
    const char *s = src;
    80201c52:	fc043783          	ld	a5,-64(s0)
    80201c56:	fcf43c23          	sd	a5,-40(s0)
    for (size_t i = 0; i < n; i++) {
    80201c5a:	fe043423          	sd	zero,-24(s0)
    80201c5e:	a025                	j	80201c86 <memcpy+0x4e>
        d[i] = s[i];
    80201c60:	fd843703          	ld	a4,-40(s0)
    80201c64:	fe843783          	ld	a5,-24(s0)
    80201c68:	973e                	add	a4,a4,a5
    80201c6a:	fe043683          	ld	a3,-32(s0)
    80201c6e:	fe843783          	ld	a5,-24(s0)
    80201c72:	97b6                	add	a5,a5,a3
    80201c74:	00074703          	lbu	a4,0(a4)
    80201c78:	00e78023          	sb	a4,0(a5)
    for (size_t i = 0; i < n; i++) {
    80201c7c:	fe843783          	ld	a5,-24(s0)
    80201c80:	0785                	addi	a5,a5,1
    80201c82:	fef43423          	sd	a5,-24(s0)
    80201c86:	fe843703          	ld	a4,-24(s0)
    80201c8a:	fb843783          	ld	a5,-72(s0)
    80201c8e:	fcf769e3          	bltu	a4,a5,80201c60 <memcpy+0x28>
    }
    return dst;
    80201c92:	fc843783          	ld	a5,-56(s0)
    80201c96:	853e                	mv	a0,a5
    80201c98:	6426                	ld	s0,72(sp)
    80201c9a:	6161                	addi	sp,sp,80
    80201c9c:	8082                	ret

0000000080201c9e <assert>:
    80201c9e:	1101                	addi	sp,sp,-32
    80201ca0:	ec06                	sd	ra,24(sp)
    80201ca2:	e822                	sd	s0,16(sp)
    80201ca4:	1000                	addi	s0,sp,32
    80201ca6:	87aa                	mv	a5,a0
    80201ca8:	fef42623          	sw	a5,-20(s0)
    80201cac:	fec42783          	lw	a5,-20(s0)
    80201cb0:	2781                	sext.w	a5,a5
    80201cb2:	e79d                	bnez	a5,80201ce0 <assert+0x42>
    80201cb4:	1a600613          	li	a2,422
    80201cb8:	00005597          	auipc	a1,0x5
    80201cbc:	0e858593          	addi	a1,a1,232 # 80206da0 <small_numbers+0x950>
    80201cc0:	00005517          	auipc	a0,0x5
    80201cc4:	0f050513          	addi	a0,a0,240 # 80206db0 <small_numbers+0x960>
    80201cc8:	fffff097          	auipc	ra,0xfffff
    80201ccc:	e8c080e7          	jalr	-372(ra) # 80200b54 <printf>
    80201cd0:	00005517          	auipc	a0,0x5
    80201cd4:	10850513          	addi	a0,a0,264 # 80206dd8 <small_numbers+0x988>
    80201cd8:	fffff097          	auipc	ra,0xfffff
    80201cdc:	784080e7          	jalr	1924(ra) # 8020145c <panic>
    80201ce0:	0001                	nop
    80201ce2:	60e2                	ld	ra,24(sp)
    80201ce4:	6442                	ld	s0,16(sp)
    80201ce6:	6105                	addi	sp,sp,32
    80201ce8:	8082                	ret

0000000080201cea <px>:
static inline uint64 px(int level, uint64 va) {
    80201cea:	1101                	addi	sp,sp,-32
    80201cec:	ec22                	sd	s0,24(sp)
    80201cee:	1000                	addi	s0,sp,32
    80201cf0:	87aa                	mv	a5,a0
    80201cf2:	feb43023          	sd	a1,-32(s0)
    80201cf6:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    80201cfa:	fec42783          	lw	a5,-20(s0)
    80201cfe:	873e                	mv	a4,a5
    80201d00:	87ba                	mv	a5,a4
    80201d02:	0037979b          	slliw	a5,a5,0x3
    80201d06:	9fb9                	addw	a5,a5,a4
    80201d08:	2781                	sext.w	a5,a5
    80201d0a:	27b1                	addiw	a5,a5,12
    80201d0c:	2781                	sext.w	a5,a5
    80201d0e:	873e                	mv	a4,a5
    80201d10:	fe043783          	ld	a5,-32(s0)
    80201d14:	00e7d7b3          	srl	a5,a5,a4
    80201d18:	1ff7f793          	andi	a5,a5,511
}
    80201d1c:	853e                	mv	a0,a5
    80201d1e:	6462                	ld	s0,24(sp)
    80201d20:	6105                	addi	sp,sp,32
    80201d22:	8082                	ret

0000000080201d24 <create_pagetable>:
pagetable_t create_pagetable(void) {
    80201d24:	1101                	addi	sp,sp,-32
    80201d26:	ec06                	sd	ra,24(sp)
    80201d28:	e822                	sd	s0,16(sp)
    80201d2a:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    80201d2c:	00001097          	auipc	ra,0x1
    80201d30:	d16080e7          	jalr	-746(ra) # 80202a42 <alloc_page>
    80201d34:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    80201d38:	fe843783          	ld	a5,-24(s0)
    80201d3c:	e399                	bnez	a5,80201d42 <create_pagetable+0x1e>
        return 0;
    80201d3e:	4781                	li	a5,0
    80201d40:	a819                	j	80201d56 <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    80201d42:	6605                	lui	a2,0x1
    80201d44:	4581                	li	a1,0
    80201d46:	fe843503          	ld	a0,-24(s0)
    80201d4a:	00000097          	auipc	ra,0x0
    80201d4e:	de2080e7          	jalr	-542(ra) # 80201b2c <memset>
    return pt;
    80201d52:	fe843783          	ld	a5,-24(s0)
}
    80201d56:	853e                	mv	a0,a5
    80201d58:	60e2                	ld	ra,24(sp)
    80201d5a:	6442                	ld	s0,16(sp)
    80201d5c:	6105                	addi	sp,sp,32
    80201d5e:	8082                	ret

0000000080201d60 <walk_lookup>:
static pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    80201d60:	7179                	addi	sp,sp,-48
    80201d62:	f406                	sd	ra,40(sp)
    80201d64:	f022                	sd	s0,32(sp)
    80201d66:	1800                	addi	s0,sp,48
    80201d68:	fca43c23          	sd	a0,-40(s0)
    80201d6c:	fcb43823          	sd	a1,-48(s0)
    if (va >= MAXVA)
    80201d70:	fd043703          	ld	a4,-48(s0)
    80201d74:	57fd                	li	a5,-1
    80201d76:	83e5                	srli	a5,a5,0x19
    80201d78:	00e7fa63          	bgeu	a5,a4,80201d8c <walk_lookup+0x2c>
        panic("walk_lookup: va out of range");
    80201d7c:	00005517          	auipc	a0,0x5
    80201d80:	06450513          	addi	a0,a0,100 # 80206de0 <small_numbers+0x990>
    80201d84:	fffff097          	auipc	ra,0xfffff
    80201d88:	6d8080e7          	jalr	1752(ra) # 8020145c <panic>
    for (int level = 2; level > 0; level--) {
    80201d8c:	4789                	li	a5,2
    80201d8e:	fef42623          	sw	a5,-20(s0)
    80201d92:	a0a9                	j	80201ddc <walk_lookup+0x7c>
        pte_t *pte = &pt[px(level, va)];
    80201d94:	fec42783          	lw	a5,-20(s0)
    80201d98:	fd043583          	ld	a1,-48(s0)
    80201d9c:	853e                	mv	a0,a5
    80201d9e:	00000097          	auipc	ra,0x0
    80201da2:	f4c080e7          	jalr	-180(ra) # 80201cea <px>
    80201da6:	87aa                	mv	a5,a0
    80201da8:	078e                	slli	a5,a5,0x3
    80201daa:	fd843703          	ld	a4,-40(s0)
    80201dae:	97ba                	add	a5,a5,a4
    80201db0:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80201db4:	fe043783          	ld	a5,-32(s0)
    80201db8:	639c                	ld	a5,0(a5)
    80201dba:	8b85                	andi	a5,a5,1
    80201dbc:	cb89                	beqz	a5,80201dce <walk_lookup+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    80201dbe:	fe043783          	ld	a5,-32(s0)
    80201dc2:	639c                	ld	a5,0(a5)
    80201dc4:	83a9                	srli	a5,a5,0xa
    80201dc6:	07b2                	slli	a5,a5,0xc
    80201dc8:	fcf43c23          	sd	a5,-40(s0)
    80201dcc:	a019                	j	80201dd2 <walk_lookup+0x72>
            return 0;
    80201dce:	4781                	li	a5,0
    80201dd0:	a03d                	j	80201dfe <walk_lookup+0x9e>
    for (int level = 2; level > 0; level--) {
    80201dd2:	fec42783          	lw	a5,-20(s0)
    80201dd6:	37fd                	addiw	a5,a5,-1
    80201dd8:	fef42623          	sw	a5,-20(s0)
    80201ddc:	fec42783          	lw	a5,-20(s0)
    80201de0:	2781                	sext.w	a5,a5
    80201de2:	faf049e3          	bgtz	a5,80201d94 <walk_lookup+0x34>
    return &pt[px(0, va)];
    80201de6:	fd043583          	ld	a1,-48(s0)
    80201dea:	4501                	li	a0,0
    80201dec:	00000097          	auipc	ra,0x0
    80201df0:	efe080e7          	jalr	-258(ra) # 80201cea <px>
    80201df4:	87aa                	mv	a5,a0
    80201df6:	078e                	slli	a5,a5,0x3
    80201df8:	fd843703          	ld	a4,-40(s0)
    80201dfc:	97ba                	add	a5,a5,a4
}
    80201dfe:	853e                	mv	a0,a5
    80201e00:	70a2                	ld	ra,40(sp)
    80201e02:	7402                	ld	s0,32(sp)
    80201e04:	6145                	addi	sp,sp,48
    80201e06:	8082                	ret

0000000080201e08 <walk_create>:
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    80201e08:	7139                	addi	sp,sp,-64
    80201e0a:	fc06                	sd	ra,56(sp)
    80201e0c:	f822                	sd	s0,48(sp)
    80201e0e:	0080                	addi	s0,sp,64
    80201e10:	fca43423          	sd	a0,-56(s0)
    80201e14:	fcb43023          	sd	a1,-64(s0)
    if (va >= MAXVA)
    80201e18:	fc043703          	ld	a4,-64(s0)
    80201e1c:	57fd                	li	a5,-1
    80201e1e:	83e5                	srli	a5,a5,0x19
    80201e20:	00e7fa63          	bgeu	a5,a4,80201e34 <walk_create+0x2c>
        panic("walk_create: va out of range");
    80201e24:	00005517          	auipc	a0,0x5
    80201e28:	fdc50513          	addi	a0,a0,-36 # 80206e00 <small_numbers+0x9b0>
    80201e2c:	fffff097          	auipc	ra,0xfffff
    80201e30:	630080e7          	jalr	1584(ra) # 8020145c <panic>
    for (int level = 2; level > 0; level--) {
    80201e34:	4789                	li	a5,2
    80201e36:	fef42623          	sw	a5,-20(s0)
    80201e3a:	a059                	j	80201ec0 <walk_create+0xb8>
        pte_t *pte = &pt[px(level, va)];
    80201e3c:	fec42783          	lw	a5,-20(s0)
    80201e40:	fc043583          	ld	a1,-64(s0)
    80201e44:	853e                	mv	a0,a5
    80201e46:	00000097          	auipc	ra,0x0
    80201e4a:	ea4080e7          	jalr	-348(ra) # 80201cea <px>
    80201e4e:	87aa                	mv	a5,a0
    80201e50:	078e                	slli	a5,a5,0x3
    80201e52:	fc843703          	ld	a4,-56(s0)
    80201e56:	97ba                	add	a5,a5,a4
    80201e58:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    80201e5c:	fe043783          	ld	a5,-32(s0)
    80201e60:	639c                	ld	a5,0(a5)
    80201e62:	8b85                	andi	a5,a5,1
    80201e64:	cb89                	beqz	a5,80201e76 <walk_create+0x6e>
            pt = (pagetable_t)PTE2PA(*pte);
    80201e66:	fe043783          	ld	a5,-32(s0)
    80201e6a:	639c                	ld	a5,0(a5)
    80201e6c:	83a9                	srli	a5,a5,0xa
    80201e6e:	07b2                	slli	a5,a5,0xc
    80201e70:	fcf43423          	sd	a5,-56(s0)
    80201e74:	a089                	j	80201eb6 <walk_create+0xae>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    80201e76:	00001097          	auipc	ra,0x1
    80201e7a:	bcc080e7          	jalr	-1076(ra) # 80202a42 <alloc_page>
    80201e7e:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    80201e82:	fd843783          	ld	a5,-40(s0)
    80201e86:	e399                	bnez	a5,80201e8c <walk_create+0x84>
                return 0;
    80201e88:	4781                	li	a5,0
    80201e8a:	a8a1                	j	80201ee2 <walk_create+0xda>
            memset(new_pt, 0, PGSIZE);
    80201e8c:	6605                	lui	a2,0x1
    80201e8e:	4581                	li	a1,0
    80201e90:	fd843503          	ld	a0,-40(s0)
    80201e94:	00000097          	auipc	ra,0x0
    80201e98:	c98080e7          	jalr	-872(ra) # 80201b2c <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    80201e9c:	fd843783          	ld	a5,-40(s0)
    80201ea0:	83b1                	srli	a5,a5,0xc
    80201ea2:	07aa                	slli	a5,a5,0xa
    80201ea4:	0017e713          	ori	a4,a5,1
    80201ea8:	fe043783          	ld	a5,-32(s0)
    80201eac:	e398                	sd	a4,0(a5)
            pt = new_pt;
    80201eae:	fd843783          	ld	a5,-40(s0)
    80201eb2:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    80201eb6:	fec42783          	lw	a5,-20(s0)
    80201eba:	37fd                	addiw	a5,a5,-1
    80201ebc:	fef42623          	sw	a5,-20(s0)
    80201ec0:	fec42783          	lw	a5,-20(s0)
    80201ec4:	2781                	sext.w	a5,a5
    80201ec6:	f6f04be3          	bgtz	a5,80201e3c <walk_create+0x34>
    return &pt[px(0, va)];
    80201eca:	fc043583          	ld	a1,-64(s0)
    80201ece:	4501                	li	a0,0
    80201ed0:	00000097          	auipc	ra,0x0
    80201ed4:	e1a080e7          	jalr	-486(ra) # 80201cea <px>
    80201ed8:	87aa                	mv	a5,a0
    80201eda:	078e                	slli	a5,a5,0x3
    80201edc:	fc843703          	ld	a4,-56(s0)
    80201ee0:	97ba                	add	a5,a5,a4
}
    80201ee2:	853e                	mv	a0,a5
    80201ee4:	70e2                	ld	ra,56(sp)
    80201ee6:	7442                	ld	s0,48(sp)
    80201ee8:	6121                	addi	sp,sp,64
    80201eea:	8082                	ret

0000000080201eec <map_page>:
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    80201eec:	7139                	addi	sp,sp,-64
    80201eee:	fc06                	sd	ra,56(sp)
    80201ef0:	f822                	sd	s0,48(sp)
    80201ef2:	0080                	addi	s0,sp,64
    80201ef4:	fca43c23          	sd	a0,-40(s0)
    80201ef8:	fcb43823          	sd	a1,-48(s0)
    80201efc:	fcc43423          	sd	a2,-56(s0)
    80201f00:	87b6                	mv	a5,a3
    80201f02:	fcf42223          	sw	a5,-60(s0)
    if ((va % PGSIZE) != 0)
    80201f06:	fd043703          	ld	a4,-48(s0)
    80201f0a:	6785                	lui	a5,0x1
    80201f0c:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80201f0e:	8ff9                	and	a5,a5,a4
    80201f10:	cb89                	beqz	a5,80201f22 <map_page+0x36>
        panic("map_page: va not aligned");
    80201f12:	00005517          	auipc	a0,0x5
    80201f16:	f0e50513          	addi	a0,a0,-242 # 80206e20 <small_numbers+0x9d0>
    80201f1a:	fffff097          	auipc	ra,0xfffff
    80201f1e:	542080e7          	jalr	1346(ra) # 8020145c <panic>
    pte_t *pte = walk_create(pt, va);
    80201f22:	fd043583          	ld	a1,-48(s0)
    80201f26:	fd843503          	ld	a0,-40(s0)
    80201f2a:	00000097          	auipc	ra,0x0
    80201f2e:	ede080e7          	jalr	-290(ra) # 80201e08 <walk_create>
    80201f32:	fea43423          	sd	a0,-24(s0)
    if (!pte)
    80201f36:	fe843783          	ld	a5,-24(s0)
    80201f3a:	e399                	bnez	a5,80201f40 <map_page+0x54>
        return -1;
    80201f3c:	57fd                	li	a5,-1
    80201f3e:	a069                	j	80201fc8 <map_page+0xdc>
	if (*pte & PTE_V) {
    80201f40:	fe843783          	ld	a5,-24(s0)
    80201f44:	639c                	ld	a5,0(a5)
    80201f46:	8b85                	andi	a5,a5,1
    80201f48:	c3b5                	beqz	a5,80201fac <map_page+0xc0>
		if (PTE2PA(*pte) == pa) {
    80201f4a:	fe843783          	ld	a5,-24(s0)
    80201f4e:	639c                	ld	a5,0(a5)
    80201f50:	83a9                	srli	a5,a5,0xa
    80201f52:	07b2                	slli	a5,a5,0xc
    80201f54:	fc843703          	ld	a4,-56(s0)
    80201f58:	04f71263          	bne	a4,a5,80201f9c <map_page+0xb0>
			int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
    80201f5c:	fe843783          	ld	a5,-24(s0)
    80201f60:	639c                	ld	a5,0(a5)
    80201f62:	2781                	sext.w	a5,a5
    80201f64:	3ff7f793          	andi	a5,a5,1023
    80201f68:	0007871b          	sext.w	a4,a5
    80201f6c:	fc442783          	lw	a5,-60(s0)
    80201f70:	8fd9                	or	a5,a5,a4
    80201f72:	2781                	sext.w	a5,a5
    80201f74:	2781                	sext.w	a5,a5
    80201f76:	3ff7f793          	andi	a5,a5,1023
    80201f7a:	fef42223          	sw	a5,-28(s0)
			*pte = PA2PTE(pa) | new_perm | PTE_V;
    80201f7e:	fc843783          	ld	a5,-56(s0)
    80201f82:	83b1                	srli	a5,a5,0xc
    80201f84:	00a79713          	slli	a4,a5,0xa
    80201f88:	fe442783          	lw	a5,-28(s0)
    80201f8c:	8fd9                	or	a5,a5,a4
    80201f8e:	0017e713          	ori	a4,a5,1
    80201f92:	fe843783          	ld	a5,-24(s0)
    80201f96:	e398                	sd	a4,0(a5)
			return 0;
    80201f98:	4781                	li	a5,0
    80201f9a:	a03d                	j	80201fc8 <map_page+0xdc>
			panic("map_page: remap to different physical address");
    80201f9c:	00005517          	auipc	a0,0x5
    80201fa0:	ea450513          	addi	a0,a0,-348 # 80206e40 <small_numbers+0x9f0>
    80201fa4:	fffff097          	auipc	ra,0xfffff
    80201fa8:	4b8080e7          	jalr	1208(ra) # 8020145c <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80201fac:	fc843783          	ld	a5,-56(s0)
    80201fb0:	83b1                	srli	a5,a5,0xc
    80201fb2:	00a79713          	slli	a4,a5,0xa
    80201fb6:	fc442783          	lw	a5,-60(s0)
    80201fba:	8fd9                	or	a5,a5,a4
    80201fbc:	0017e713          	ori	a4,a5,1
    80201fc0:	fe843783          	ld	a5,-24(s0)
    80201fc4:	e398                	sd	a4,0(a5)
    return 0;
    80201fc6:	4781                	li	a5,0
}
    80201fc8:	853e                	mv	a0,a5
    80201fca:	70e2                	ld	ra,56(sp)
    80201fcc:	7442                	ld	s0,48(sp)
    80201fce:	6121                	addi	sp,sp,64
    80201fd0:	8082                	ret

0000000080201fd2 <free_pagetable>:
void free_pagetable(pagetable_t pt) {
    80201fd2:	7139                	addi	sp,sp,-64
    80201fd4:	fc06                	sd	ra,56(sp)
    80201fd6:	f822                	sd	s0,48(sp)
    80201fd8:	0080                	addi	s0,sp,64
    80201fda:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    80201fde:	fe042623          	sw	zero,-20(s0)
    80201fe2:	a8a5                	j	8020205a <free_pagetable+0x88>
        pte_t pte = pt[i];
    80201fe4:	fec42783          	lw	a5,-20(s0)
    80201fe8:	078e                	slli	a5,a5,0x3
    80201fea:	fc843703          	ld	a4,-56(s0)
    80201fee:	97ba                	add	a5,a5,a4
    80201ff0:	639c                	ld	a5,0(a5)
    80201ff2:	fef43023          	sd	a5,-32(s0)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80201ff6:	fe043783          	ld	a5,-32(s0)
    80201ffa:	8b85                	andi	a5,a5,1
    80201ffc:	cb95                	beqz	a5,80202030 <free_pagetable+0x5e>
    80201ffe:	fe043783          	ld	a5,-32(s0)
    80202002:	8bb9                	andi	a5,a5,14
    80202004:	e795                	bnez	a5,80202030 <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    80202006:	fe043783          	ld	a5,-32(s0)
    8020200a:	83a9                	srli	a5,a5,0xa
    8020200c:	07b2                	slli	a5,a5,0xc
    8020200e:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    80202012:	fd843503          	ld	a0,-40(s0)
    80202016:	00000097          	auipc	ra,0x0
    8020201a:	fbc080e7          	jalr	-68(ra) # 80201fd2 <free_pagetable>
            pt[i] = 0;
    8020201e:	fec42783          	lw	a5,-20(s0)
    80202022:	078e                	slli	a5,a5,0x3
    80202024:	fc843703          	ld	a4,-56(s0)
    80202028:	97ba                	add	a5,a5,a4
    8020202a:	0007b023          	sd	zero,0(a5)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    8020202e:	a00d                	j	80202050 <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    80202030:	fe043783          	ld	a5,-32(s0)
    80202034:	8b85                	andi	a5,a5,1
    80202036:	cf89                	beqz	a5,80202050 <free_pagetable+0x7e>
    80202038:	fe043783          	ld	a5,-32(s0)
    8020203c:	8bb9                	andi	a5,a5,14
    8020203e:	cb89                	beqz	a5,80202050 <free_pagetable+0x7e>
            pt[i] = 0;
    80202040:	fec42783          	lw	a5,-20(s0)
    80202044:	078e                	slli	a5,a5,0x3
    80202046:	fc843703          	ld	a4,-56(s0)
    8020204a:	97ba                	add	a5,a5,a4
    8020204c:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    80202050:	fec42783          	lw	a5,-20(s0)
    80202054:	2785                	addiw	a5,a5,1
    80202056:	fef42623          	sw	a5,-20(s0)
    8020205a:	fec42783          	lw	a5,-20(s0)
    8020205e:	0007871b          	sext.w	a4,a5
    80202062:	1ff00793          	li	a5,511
    80202066:	f6e7dfe3          	bge	a5,a4,80201fe4 <free_pagetable+0x12>
    free_page(pt);
    8020206a:	fc843503          	ld	a0,-56(s0)
    8020206e:	00001097          	auipc	ra,0x1
    80202072:	a40080e7          	jalr	-1472(ra) # 80202aae <free_page>
}
    80202076:	0001                	nop
    80202078:	70e2                	ld	ra,56(sp)
    8020207a:	7442                	ld	s0,48(sp)
    8020207c:	6121                	addi	sp,sp,64
    8020207e:	8082                	ret

0000000080202080 <kvmmake>:
static pagetable_t kvmmake(void) {
    80202080:	711d                	addi	sp,sp,-96
    80202082:	ec86                	sd	ra,88(sp)
    80202084:	e8a2                	sd	s0,80(sp)
    80202086:	1080                	addi	s0,sp,96
    pagetable_t kpgtbl = create_pagetable();
    80202088:	00000097          	auipc	ra,0x0
    8020208c:	c9c080e7          	jalr	-868(ra) # 80201d24 <create_pagetable>
    80202090:	faa43c23          	sd	a0,-72(s0)
    if (!kpgtbl)
    80202094:	fb843783          	ld	a5,-72(s0)
    80202098:	eb89                	bnez	a5,802020aa <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    8020209a:	00005517          	auipc	a0,0x5
    8020209e:	dd650513          	addi	a0,a0,-554 # 80206e70 <small_numbers+0xa20>
    802020a2:	fffff097          	auipc	ra,0xfffff
    802020a6:	3ba080e7          	jalr	954(ra) # 8020145c <panic>
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    802020aa:	4785                	li	a5,1
    802020ac:	07fe                	slli	a5,a5,0x1f
    802020ae:	fef43423          	sd	a5,-24(s0)
    802020b2:	a825                	j	802020ea <kvmmake+0x6a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_X) != 0)
    802020b4:	46a9                	li	a3,10
    802020b6:	fe843603          	ld	a2,-24(s0)
    802020ba:	fe843583          	ld	a1,-24(s0)
    802020be:	fb843503          	ld	a0,-72(s0)
    802020c2:	00000097          	auipc	ra,0x0
    802020c6:	e2a080e7          	jalr	-470(ra) # 80201eec <map_page>
    802020ca:	87aa                	mv	a5,a0
    802020cc:	cb89                	beqz	a5,802020de <kvmmake+0x5e>
            panic("kvmmake: code map failed");
    802020ce:	00005517          	auipc	a0,0x5
    802020d2:	dba50513          	addi	a0,a0,-582 # 80206e88 <small_numbers+0xa38>
    802020d6:	fffff097          	auipc	ra,0xfffff
    802020da:	386080e7          	jalr	902(ra) # 8020145c <panic>
    for (uint64 pa = KERNBASE; pa < (uint64)etext; pa += PGSIZE) {
    802020de:	fe843703          	ld	a4,-24(s0)
    802020e2:	6785                	lui	a5,0x1
    802020e4:	97ba                	add	a5,a5,a4
    802020e6:	fef43423          	sd	a5,-24(s0)
    802020ea:	00004797          	auipc	a5,0x4
    802020ee:	f1678793          	addi	a5,a5,-234 # 80206000 <etext>
    802020f2:	fe843703          	ld	a4,-24(s0)
    802020f6:	faf76fe3          	bltu	a4,a5,802020b4 <kvmmake+0x34>
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    802020fa:	00004797          	auipc	a5,0x4
    802020fe:	f0678793          	addi	a5,a5,-250 # 80206000 <etext>
    80202102:	fef43023          	sd	a5,-32(s0)
    80202106:	a825                	j	8020213e <kvmmake+0xbe>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202108:	4699                	li	a3,6
    8020210a:	fe043603          	ld	a2,-32(s0)
    8020210e:	fe043583          	ld	a1,-32(s0)
    80202112:	fb843503          	ld	a0,-72(s0)
    80202116:	00000097          	auipc	ra,0x0
    8020211a:	dd6080e7          	jalr	-554(ra) # 80201eec <map_page>
    8020211e:	87aa                	mv	a5,a0
    80202120:	cb89                	beqz	a5,80202132 <kvmmake+0xb2>
            panic("kvmmake: data map failed");
    80202122:	00005517          	auipc	a0,0x5
    80202126:	d8650513          	addi	a0,a0,-634 # 80206ea8 <small_numbers+0xa58>
    8020212a:	fffff097          	auipc	ra,0xfffff
    8020212e:	332080e7          	jalr	818(ra) # 8020145c <panic>
    for (uint64 pa = (uint64)etext; pa < (uint64)end; pa += PGSIZE) {
    80202132:	fe043703          	ld	a4,-32(s0)
    80202136:	6785                	lui	a5,0x1
    80202138:	97ba                	add	a5,a5,a4
    8020213a:	fef43023          	sd	a5,-32(s0)
    8020213e:	0000a797          	auipc	a5,0xa
    80202142:	c1278793          	addi	a5,a5,-1006 # 8020bd50 <_bss_end>
    80202146:	fe043703          	ld	a4,-32(s0)
    8020214a:	faf76fe3          	bltu	a4,a5,80202108 <kvmmake+0x88>
	uint64 aligned_end = ((uint64)end + PGSIZE - 1) & ~(PGSIZE - 1); // 向上对齐到页边界
    8020214e:	0000a717          	auipc	a4,0xa
    80202152:	c0270713          	addi	a4,a4,-1022 # 8020bd50 <_bss_end>
    80202156:	6785                	lui	a5,0x1
    80202158:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    8020215a:	973e                	add	a4,a4,a5
    8020215c:	77fd                	lui	a5,0xfffff
    8020215e:	8ff9                	and	a5,a5,a4
    80202160:	faf43823          	sd	a5,-80(s0)
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    80202164:	fb043783          	ld	a5,-80(s0)
    80202168:	fcf43c23          	sd	a5,-40(s0)
    8020216c:	a825                	j	802021a4 <kvmmake+0x124>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    8020216e:	4699                	li	a3,6
    80202170:	fd843603          	ld	a2,-40(s0)
    80202174:	fd843583          	ld	a1,-40(s0)
    80202178:	fb843503          	ld	a0,-72(s0)
    8020217c:	00000097          	auipc	ra,0x0
    80202180:	d70080e7          	jalr	-656(ra) # 80201eec <map_page>
    80202184:	87aa                	mv	a5,a0
    80202186:	cb89                	beqz	a5,80202198 <kvmmake+0x118>
			panic("kvmmake: heap map failed");
    80202188:	00005517          	auipc	a0,0x5
    8020218c:	d4050513          	addi	a0,a0,-704 # 80206ec8 <small_numbers+0xa78>
    80202190:	fffff097          	auipc	ra,0xfffff
    80202194:	2cc080e7          	jalr	716(ra) # 8020145c <panic>
	for (uint64 pa = aligned_end; pa < PHYSTOP; pa += PGSIZE) {
    80202198:	fd843703          	ld	a4,-40(s0)
    8020219c:	6785                	lui	a5,0x1
    8020219e:	97ba                	add	a5,a5,a4
    802021a0:	fcf43c23          	sd	a5,-40(s0)
    802021a4:	fd843703          	ld	a4,-40(s0)
    802021a8:	47c5                	li	a5,17
    802021aa:	07ee                	slli	a5,a5,0x1b
    802021ac:	fcf761e3          	bltu	a4,a5,8020216e <kvmmake+0xee>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    802021b0:	4699                	li	a3,6
    802021b2:	10000637          	lui	a2,0x10000
    802021b6:	100005b7          	lui	a1,0x10000
    802021ba:	fb843503          	ld	a0,-72(s0)
    802021be:	00000097          	auipc	ra,0x0
    802021c2:	d2e080e7          	jalr	-722(ra) # 80201eec <map_page>
    802021c6:	87aa                	mv	a5,a0
    802021c8:	cb89                	beqz	a5,802021da <kvmmake+0x15a>
        panic("kvmmake: uart map failed");
    802021ca:	00005517          	auipc	a0,0x5
    802021ce:	d1e50513          	addi	a0,a0,-738 # 80206ee8 <small_numbers+0xa98>
    802021d2:	fffff097          	auipc	ra,0xfffff
    802021d6:	28a080e7          	jalr	650(ra) # 8020145c <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    802021da:	0c0007b7          	lui	a5,0xc000
    802021de:	fcf43823          	sd	a5,-48(s0)
    802021e2:	a825                	j	8020221a <kvmmake+0x19a>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802021e4:	4699                	li	a3,6
    802021e6:	fd043603          	ld	a2,-48(s0)
    802021ea:	fd043583          	ld	a1,-48(s0)
    802021ee:	fb843503          	ld	a0,-72(s0)
    802021f2:	00000097          	auipc	ra,0x0
    802021f6:	cfa080e7          	jalr	-774(ra) # 80201eec <map_page>
    802021fa:	87aa                	mv	a5,a0
    802021fc:	cb89                	beqz	a5,8020220e <kvmmake+0x18e>
            panic("kvmmake: plic map failed");
    802021fe:	00005517          	auipc	a0,0x5
    80202202:	d0a50513          	addi	a0,a0,-758 # 80206f08 <small_numbers+0xab8>
    80202206:	fffff097          	auipc	ra,0xfffff
    8020220a:	256080e7          	jalr	598(ra) # 8020145c <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    8020220e:	fd043703          	ld	a4,-48(s0)
    80202212:	6785                	lui	a5,0x1
    80202214:	97ba                	add	a5,a5,a4
    80202216:	fcf43823          	sd	a5,-48(s0)
    8020221a:	fd043703          	ld	a4,-48(s0)
    8020221e:	0c4007b7          	lui	a5,0xc400
    80202222:	fcf761e3          	bltu	a4,a5,802021e4 <kvmmake+0x164>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80202226:	020007b7          	lui	a5,0x2000
    8020222a:	fcf43423          	sd	a5,-56(s0)
    8020222e:	a825                	j	80202266 <kvmmake+0x1e6>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202230:	4699                	li	a3,6
    80202232:	fc843603          	ld	a2,-56(s0)
    80202236:	fc843583          	ld	a1,-56(s0)
    8020223a:	fb843503          	ld	a0,-72(s0)
    8020223e:	00000097          	auipc	ra,0x0
    80202242:	cae080e7          	jalr	-850(ra) # 80201eec <map_page>
    80202246:	87aa                	mv	a5,a0
    80202248:	cb89                	beqz	a5,8020225a <kvmmake+0x1da>
            panic("kvmmake: clint map failed");
    8020224a:	00005517          	auipc	a0,0x5
    8020224e:	cde50513          	addi	a0,a0,-802 # 80206f28 <small_numbers+0xad8>
    80202252:	fffff097          	auipc	ra,0xfffff
    80202256:	20a080e7          	jalr	522(ra) # 8020145c <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    8020225a:	fc843703          	ld	a4,-56(s0)
    8020225e:	6785                	lui	a5,0x1
    80202260:	97ba                	add	a5,a5,a4
    80202262:	fcf43423          	sd	a5,-56(s0)
    80202266:	fc843703          	ld	a4,-56(s0)
    8020226a:	020107b7          	lui	a5,0x2010
    8020226e:	fcf761e3          	bltu	a4,a5,80202230 <kvmmake+0x1b0>
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    80202272:	4699                	li	a3,6
    80202274:	10001637          	lui	a2,0x10001
    80202278:	100015b7          	lui	a1,0x10001
    8020227c:	fb843503          	ld	a0,-72(s0)
    80202280:	00000097          	auipc	ra,0x0
    80202284:	c6c080e7          	jalr	-916(ra) # 80201eec <map_page>
    80202288:	87aa                	mv	a5,a0
    8020228a:	cb89                	beqz	a5,8020229c <kvmmake+0x21c>
        panic("kvmmake: virtio map failed");
    8020228c:	00005517          	auipc	a0,0x5
    80202290:	cbc50513          	addi	a0,a0,-836 # 80206f48 <small_numbers+0xaf8>
    80202294:	fffff097          	auipc	ra,0xfffff
    80202298:	1c8080e7          	jalr	456(ra) # 8020145c <panic>
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    8020229c:	fc043023          	sd	zero,-64(s0)
    802022a0:	a825                	j	802022d8 <kvmmake+0x258>
		if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802022a2:	4699                	li	a3,6
    802022a4:	fc043603          	ld	a2,-64(s0)
    802022a8:	fc043583          	ld	a1,-64(s0)
    802022ac:	fb843503          	ld	a0,-72(s0)
    802022b0:	00000097          	auipc	ra,0x0
    802022b4:	c3c080e7          	jalr	-964(ra) # 80201eec <map_page>
    802022b8:	87aa                	mv	a5,a0
    802022ba:	cb89                	beqz	a5,802022cc <kvmmake+0x24c>
			panic("kvmmake: low memory map failed");
    802022bc:	00005517          	auipc	a0,0x5
    802022c0:	cac50513          	addi	a0,a0,-852 # 80206f68 <small_numbers+0xb18>
    802022c4:	fffff097          	auipc	ra,0xfffff
    802022c8:	198080e7          	jalr	408(ra) # 8020145c <panic>
	for (uint64 pa = 0; pa < 0x100000; pa += PGSIZE) {
    802022cc:	fc043703          	ld	a4,-64(s0)
    802022d0:	6785                	lui	a5,0x1
    802022d2:	97ba                	add	a5,a5,a4
    802022d4:	fcf43023          	sd	a5,-64(s0)
    802022d8:	fc043703          	ld	a4,-64(s0)
    802022dc:	001007b7          	lui	a5,0x100
    802022e0:	fcf761e3          	bltu	a4,a5,802022a2 <kvmmake+0x222>
	uint64 sbi_special = 0xfd02000;  // 页对齐
    802022e4:	0fd027b7          	lui	a5,0xfd02
    802022e8:	faf43423          	sd	a5,-88(s0)
	if (map_page(kpgtbl, sbi_special, sbi_special, PTE_R | PTE_W) != 0)
    802022ec:	4699                	li	a3,6
    802022ee:	fa843603          	ld	a2,-88(s0)
    802022f2:	fa843583          	ld	a1,-88(s0)
    802022f6:	fb843503          	ld	a0,-72(s0)
    802022fa:	00000097          	auipc	ra,0x0
    802022fe:	bf2080e7          	jalr	-1038(ra) # 80201eec <map_page>
    80202302:	87aa                	mv	a5,a0
    80202304:	cb89                	beqz	a5,80202316 <kvmmake+0x296>
		panic("kvmmake: sbi special area map failed");
    80202306:	00005517          	auipc	a0,0x5
    8020230a:	c8250513          	addi	a0,a0,-894 # 80206f88 <small_numbers+0xb38>
    8020230e:	fffff097          	auipc	ra,0xfffff
    80202312:	14e080e7          	jalr	334(ra) # 8020145c <panic>
    return kpgtbl;
    80202316:	fb843783          	ld	a5,-72(s0)
}
    8020231a:	853e                	mv	a0,a5
    8020231c:	60e6                	ld	ra,88(sp)
    8020231e:	6446                	ld	s0,80(sp)
    80202320:	6125                	addi	sp,sp,96
    80202322:	8082                	ret

0000000080202324 <kvminit>:
void kvminit(void) {
    80202324:	1141                	addi	sp,sp,-16
    80202326:	e406                	sd	ra,8(sp)
    80202328:	e022                	sd	s0,0(sp)
    8020232a:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    8020232c:	00000097          	auipc	ra,0x0
    80202330:	d54080e7          	jalr	-684(ra) # 80202080 <kvmmake>
    80202334:	872a                	mv	a4,a0
    80202336:	00008797          	auipc	a5,0x8
    8020233a:	d4a78793          	addi	a5,a5,-694 # 8020a080 <kernel_pagetable>
    8020233e:	e398                	sd	a4,0(a5)
}
    80202340:	0001                	nop
    80202342:	60a2                	ld	ra,8(sp)
    80202344:	6402                	ld	s0,0(sp)
    80202346:	0141                	addi	sp,sp,16
    80202348:	8082                	ret

000000008020234a <w_satp>:
static inline void w_satp(uint64 x) {
    8020234a:	1101                	addi	sp,sp,-32
    8020234c:	ec22                	sd	s0,24(sp)
    8020234e:	1000                	addi	s0,sp,32
    80202350:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    80202354:	fe843783          	ld	a5,-24(s0)
    80202358:	18079073          	csrw	satp,a5
}
    8020235c:	0001                	nop
    8020235e:	6462                	ld	s0,24(sp)
    80202360:	6105                	addi	sp,sp,32
    80202362:	8082                	ret

0000000080202364 <sfence_vma>:
inline void sfence_vma(void) {
    80202364:	1141                	addi	sp,sp,-16
    80202366:	e422                	sd	s0,8(sp)
    80202368:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    8020236a:	12000073          	sfence.vma
}
    8020236e:	0001                	nop
    80202370:	6422                	ld	s0,8(sp)
    80202372:	0141                	addi	sp,sp,16
    80202374:	8082                	ret

0000000080202376 <kvminithart>:
void kvminithart(void) {
    80202376:	1141                	addi	sp,sp,-16
    80202378:	e406                	sd	ra,8(sp)
    8020237a:	e022                	sd	s0,0(sp)
    8020237c:	0800                	addi	s0,sp,16
    sfence_vma();
    8020237e:	00000097          	auipc	ra,0x0
    80202382:	fe6080e7          	jalr	-26(ra) # 80202364 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    80202386:	00008797          	auipc	a5,0x8
    8020238a:	cfa78793          	addi	a5,a5,-774 # 8020a080 <kernel_pagetable>
    8020238e:	639c                	ld	a5,0(a5)
    80202390:	00c7d713          	srli	a4,a5,0xc
    80202394:	57fd                	li	a5,-1
    80202396:	17fe                	slli	a5,a5,0x3f
    80202398:	8fd9                	or	a5,a5,a4
    8020239a:	853e                	mv	a0,a5
    8020239c:	00000097          	auipc	ra,0x0
    802023a0:	fae080e7          	jalr	-82(ra) # 8020234a <w_satp>
    sfence_vma();
    802023a4:	00000097          	auipc	ra,0x0
    802023a8:	fc0080e7          	jalr	-64(ra) # 80202364 <sfence_vma>
	printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
    802023ac:	00008797          	auipc	a5,0x8
    802023b0:	cd478793          	addi	a5,a5,-812 # 8020a080 <kernel_pagetable>
    802023b4:	639c                	ld	a5,0(a5)
    802023b6:	00c7d713          	srli	a4,a5,0xc
    802023ba:	57fd                	li	a5,-1
    802023bc:	17fe                	slli	a5,a5,0x3f
    802023be:	8fd9                	or	a5,a5,a4
    802023c0:	85be                	mv	a1,a5
    802023c2:	00005517          	auipc	a0,0x5
    802023c6:	bee50513          	addi	a0,a0,-1042 # 80206fb0 <small_numbers+0xb60>
    802023ca:	ffffe097          	auipc	ra,0xffffe
    802023ce:	78a080e7          	jalr	1930(ra) # 80200b54 <printf>
}
    802023d2:	0001                	nop
    802023d4:	60a2                	ld	ra,8(sp)
    802023d6:	6402                	ld	s0,0(sp)
    802023d8:	0141                	addi	sp,sp,16
    802023da:	8082                	ret

00000000802023dc <get_current_pagetable>:
pagetable_t get_current_pagetable(void) {
    802023dc:	1141                	addi	sp,sp,-16
    802023de:	e422                	sd	s0,8(sp)
    802023e0:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    802023e2:	00008797          	auipc	a5,0x8
    802023e6:	c9e78793          	addi	a5,a5,-866 # 8020a080 <kernel_pagetable>
    802023ea:	639c                	ld	a5,0(a5)
}
    802023ec:	853e                	mv	a0,a5
    802023ee:	6422                	ld	s0,8(sp)
    802023f0:	0141                	addi	sp,sp,16
    802023f2:	8082                	ret

00000000802023f4 <handle_page_fault>:
int handle_page_fault(uint64 va, int type) {
    802023f4:	7139                	addi	sp,sp,-64
    802023f6:	fc06                	sd	ra,56(sp)
    802023f8:	f822                	sd	s0,48(sp)
    802023fa:	0080                	addi	s0,sp,64
    802023fc:	fca43423          	sd	a0,-56(s0)
    80202400:	87ae                	mv	a5,a1
    80202402:	fcf42223          	sw	a5,-60(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    80202406:	fc442783          	lw	a5,-60(s0)
    8020240a:	863e                	mv	a2,a5
    8020240c:	fc843583          	ld	a1,-56(s0)
    80202410:	00005517          	auipc	a0,0x5
    80202414:	bd050513          	addi	a0,a0,-1072 # 80206fe0 <small_numbers+0xb90>
    80202418:	ffffe097          	auipc	ra,0xffffe
    8020241c:	73c080e7          	jalr	1852(ra) # 80200b54 <printf>
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    80202420:	fc843703          	ld	a4,-56(s0)
    80202424:	77fd                	lui	a5,0xfffff
    80202426:	8ff9                	and	a5,a5,a4
    80202428:	fef43023          	sd	a5,-32(s0)
    if (page_va >= MAXVA) {
    8020242c:	fe043703          	ld	a4,-32(s0)
    80202430:	57fd                	li	a5,-1
    80202432:	83e5                	srli	a5,a5,0x19
    80202434:	00e7fc63          	bgeu	a5,a4,8020244c <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    80202438:	00005517          	auipc	a0,0x5
    8020243c:	bd850513          	addi	a0,a0,-1064 # 80207010 <small_numbers+0xbc0>
    80202440:	ffffe097          	auipc	ra,0xffffe
    80202444:	714080e7          	jalr	1812(ra) # 80200b54 <printf>
        return 0; // 地址超出最大虚拟地址空间
    80202448:	4781                	li	a5,0
    8020244a:	a275                	j	802025f6 <handle_page_fault+0x202>
    pte_t *pte = walk_lookup(kernel_pagetable, page_va);
    8020244c:	00008797          	auipc	a5,0x8
    80202450:	c3478793          	addi	a5,a5,-972 # 8020a080 <kernel_pagetable>
    80202454:	639c                	ld	a5,0(a5)
    80202456:	fe043583          	ld	a1,-32(s0)
    8020245a:	853e                	mv	a0,a5
    8020245c:	00000097          	auipc	ra,0x0
    80202460:	904080e7          	jalr	-1788(ra) # 80201d60 <walk_lookup>
    80202464:	fca43c23          	sd	a0,-40(s0)
    if (pte && (*pte & PTE_V)) {
    80202468:	fd843783          	ld	a5,-40(s0)
    8020246c:	c3dd                	beqz	a5,80202512 <handle_page_fault+0x11e>
    8020246e:	fd843783          	ld	a5,-40(s0)
    80202472:	639c                	ld	a5,0(a5)
    80202474:	8b85                	andi	a5,a5,1
    80202476:	cfd1                	beqz	a5,80202512 <handle_page_fault+0x11e>
        int need_perm = 0;
    80202478:	fe042623          	sw	zero,-20(s0)
        if (type == 1) need_perm = PTE_X;
    8020247c:	fc442783          	lw	a5,-60(s0)
    80202480:	0007871b          	sext.w	a4,a5
    80202484:	4785                	li	a5,1
    80202486:	00f71663          	bne	a4,a5,80202492 <handle_page_fault+0x9e>
    8020248a:	47a1                	li	a5,8
    8020248c:	fef42623          	sw	a5,-20(s0)
    80202490:	a035                	j	802024bc <handle_page_fault+0xc8>
        else if (type == 2) need_perm = PTE_R;
    80202492:	fc442783          	lw	a5,-60(s0)
    80202496:	0007871b          	sext.w	a4,a5
    8020249a:	4789                	li	a5,2
    8020249c:	00f71663          	bne	a4,a5,802024a8 <handle_page_fault+0xb4>
    802024a0:	4789                	li	a5,2
    802024a2:	fef42623          	sw	a5,-20(s0)
    802024a6:	a819                	j	802024bc <handle_page_fault+0xc8>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    802024a8:	fc442783          	lw	a5,-60(s0)
    802024ac:	0007871b          	sext.w	a4,a5
    802024b0:	478d                	li	a5,3
    802024b2:	00f71563          	bne	a4,a5,802024bc <handle_page_fault+0xc8>
    802024b6:	4799                	li	a5,6
    802024b8:	fef42623          	sw	a5,-20(s0)
        if ((*pte & need_perm) != need_perm) {
    802024bc:	fd843783          	ld	a5,-40(s0)
    802024c0:	6398                	ld	a4,0(a5)
    802024c2:	fec42783          	lw	a5,-20(s0)
    802024c6:	8f7d                	and	a4,a4,a5
    802024c8:	fec42783          	lw	a5,-20(s0)
    802024cc:	02f70963          	beq	a4,a5,802024fe <handle_page_fault+0x10a>
            *pte |= need_perm;
    802024d0:	fd843783          	ld	a5,-40(s0)
    802024d4:	6398                	ld	a4,0(a5)
    802024d6:	fec42783          	lw	a5,-20(s0)
    802024da:	8f5d                	or	a4,a4,a5
    802024dc:	fd843783          	ld	a5,-40(s0)
    802024e0:	e398                	sd	a4,0(a5)
            sfence_vma();
    802024e2:	00000097          	auipc	ra,0x0
    802024e6:	e82080e7          	jalr	-382(ra) # 80202364 <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    802024ea:	00005517          	auipc	a0,0x5
    802024ee:	b4e50513          	addi	a0,a0,-1202 # 80207038 <small_numbers+0xbe8>
    802024f2:	ffffe097          	auipc	ra,0xffffe
    802024f6:	662080e7          	jalr	1634(ra) # 80200b54 <printf>
            return 1;
    802024fa:	4785                	li	a5,1
    802024fc:	a8ed                	j	802025f6 <handle_page_fault+0x202>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    802024fe:	00005517          	auipc	a0,0x5
    80202502:	b6250513          	addi	a0,a0,-1182 # 80207060 <small_numbers+0xc10>
    80202506:	ffffe097          	auipc	ra,0xffffe
    8020250a:	64e080e7          	jalr	1614(ra) # 80200b54 <printf>
        return 1;
    8020250e:	4785                	li	a5,1
    80202510:	a0dd                	j	802025f6 <handle_page_fault+0x202>
    void* page = alloc_page();
    80202512:	00000097          	auipc	ra,0x0
    80202516:	530080e7          	jalr	1328(ra) # 80202a42 <alloc_page>
    8020251a:	fca43823          	sd	a0,-48(s0)
    if (page == 0) {
    8020251e:	fd043783          	ld	a5,-48(s0)
    80202522:	eb99                	bnez	a5,80202538 <handle_page_fault+0x144>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    80202524:	00005517          	auipc	a0,0x5
    80202528:	b6c50513          	addi	a0,a0,-1172 # 80207090 <small_numbers+0xc40>
    8020252c:	ffffe097          	auipc	ra,0xffffe
    80202530:	628080e7          	jalr	1576(ra) # 80200b54 <printf>
        return 0; // 内存不足
    80202534:	4781                	li	a5,0
    80202536:	a0c1                	j	802025f6 <handle_page_fault+0x202>
    memset(page, 0, PGSIZE);
    80202538:	6605                	lui	a2,0x1
    8020253a:	4581                	li	a1,0
    8020253c:	fd043503          	ld	a0,-48(s0)
    80202540:	fffff097          	auipc	ra,0xfffff
    80202544:	5ec080e7          	jalr	1516(ra) # 80201b2c <memset>
    int perm = 0;
    80202548:	fe042423          	sw	zero,-24(s0)
    if (type == 1) {  // 指令页
    8020254c:	fc442783          	lw	a5,-60(s0)
    80202550:	0007871b          	sext.w	a4,a5
    80202554:	4785                	li	a5,1
    80202556:	00f71663          	bne	a4,a5,80202562 <handle_page_fault+0x16e>
        perm = PTE_X | PTE_R;  // 可执行页通常也需要可读
    8020255a:	47a9                	li	a5,10
    8020255c:	fef42423          	sw	a5,-24(s0)
    80202560:	a035                	j	8020258c <handle_page_fault+0x198>
    } else if (type == 2) {  // 读数据页
    80202562:	fc442783          	lw	a5,-60(s0)
    80202566:	0007871b          	sext.w	a4,a5
    8020256a:	4789                	li	a5,2
    8020256c:	00f71663          	bne	a4,a5,80202578 <handle_page_fault+0x184>
        perm = PTE_R;
    80202570:	4789                	li	a5,2
    80202572:	fef42423          	sw	a5,-24(s0)
    80202576:	a819                	j	8020258c <handle_page_fault+0x198>
    } else if (type == 3) {  // 写数据页
    80202578:	fc442783          	lw	a5,-60(s0)
    8020257c:	0007871b          	sext.w	a4,a5
    80202580:	478d                	li	a5,3
    80202582:	00f71563          	bne	a4,a5,8020258c <handle_page_fault+0x198>
        perm = PTE_R | PTE_W;
    80202586:	4799                	li	a5,6
    80202588:	fef42423          	sw	a5,-24(s0)
    if (map_page(kernel_pagetable, page_va, (uint64)page, perm) != 0) {
    8020258c:	00008797          	auipc	a5,0x8
    80202590:	af478793          	addi	a5,a5,-1292 # 8020a080 <kernel_pagetable>
    80202594:	639c                	ld	a5,0(a5)
    80202596:	fd043703          	ld	a4,-48(s0)
    8020259a:	fe842683          	lw	a3,-24(s0)
    8020259e:	863a                	mv	a2,a4
    802025a0:	fe043583          	ld	a1,-32(s0)
    802025a4:	853e                	mv	a0,a5
    802025a6:	00000097          	auipc	ra,0x0
    802025aa:	946080e7          	jalr	-1722(ra) # 80201eec <map_page>
    802025ae:	87aa                	mv	a5,a0
    802025b0:	c38d                	beqz	a5,802025d2 <handle_page_fault+0x1de>
        free_page(page);
    802025b2:	fd043503          	ld	a0,-48(s0)
    802025b6:	00000097          	auipc	ra,0x0
    802025ba:	4f8080e7          	jalr	1272(ra) # 80202aae <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    802025be:	00005517          	auipc	a0,0x5
    802025c2:	b0250513          	addi	a0,a0,-1278 # 802070c0 <small_numbers+0xc70>
    802025c6:	ffffe097          	auipc	ra,0xffffe
    802025ca:	58e080e7          	jalr	1422(ra) # 80200b54 <printf>
        return 0; // 映射失败
    802025ce:	4781                	li	a5,0
    802025d0:	a01d                	j	802025f6 <handle_page_fault+0x202>
    sfence_vma();
    802025d2:	00000097          	auipc	ra,0x0
    802025d6:	d92080e7          	jalr	-622(ra) # 80202364 <sfence_vma>
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    802025da:	fd043783          	ld	a5,-48(s0)
    802025de:	863e                	mv	a2,a5
    802025e0:	fe043583          	ld	a1,-32(s0)
    802025e4:	00005517          	auipc	a0,0x5
    802025e8:	b0450513          	addi	a0,a0,-1276 # 802070e8 <small_numbers+0xc98>
    802025ec:	ffffe097          	auipc	ra,0xffffe
    802025f0:	568080e7          	jalr	1384(ra) # 80200b54 <printf>
    return 1; // 处理成功
    802025f4:	4785                	li	a5,1
}
    802025f6:	853e                	mv	a0,a5
    802025f8:	70e2                	ld	ra,56(sp)
    802025fa:	7442                	ld	s0,48(sp)
    802025fc:	6121                	addi	sp,sp,64
    802025fe:	8082                	ret

0000000080202600 <test_pagetable>:
void test_pagetable(void) {
    80202600:	7179                	addi	sp,sp,-48
    80202602:	f406                	sd	ra,40(sp)
    80202604:	f022                	sd	s0,32(sp)
    80202606:	1800                	addi	s0,sp,48
    printf("[PT TEST] 创建页表...\n");
    80202608:	00005517          	auipc	a0,0x5
    8020260c:	b2050513          	addi	a0,a0,-1248 # 80207128 <small_numbers+0xcd8>
    80202610:	ffffe097          	auipc	ra,0xffffe
    80202614:	544080e7          	jalr	1348(ra) # 80200b54 <printf>
    pagetable_t pt = create_pagetable();
    80202618:	fffff097          	auipc	ra,0xfffff
    8020261c:	70c080e7          	jalr	1804(ra) # 80201d24 <create_pagetable>
    80202620:	fea43423          	sd	a0,-24(s0)
    assert(pt != 0);
    80202624:	fe843783          	ld	a5,-24(s0)
    80202628:	00f037b3          	snez	a5,a5
    8020262c:	0ff7f793          	zext.b	a5,a5
    80202630:	2781                	sext.w	a5,a5
    80202632:	853e                	mv	a0,a5
    80202634:	fffff097          	auipc	ra,0xfffff
    80202638:	66a080e7          	jalr	1642(ra) # 80201c9e <assert>
    printf("[PT TEST] 页表创建通过\n");
    8020263c:	00005517          	auipc	a0,0x5
    80202640:	b0c50513          	addi	a0,a0,-1268 # 80207148 <small_numbers+0xcf8>
    80202644:	ffffe097          	auipc	ra,0xffffe
    80202648:	510080e7          	jalr	1296(ra) # 80200b54 <printf>
    uint64 va = 0x1000000;
    8020264c:	010007b7          	lui	a5,0x1000
    80202650:	fef43023          	sd	a5,-32(s0)
    uint64 pa = (uint64)alloc_page();
    80202654:	00000097          	auipc	ra,0x0
    80202658:	3ee080e7          	jalr	1006(ra) # 80202a42 <alloc_page>
    8020265c:	87aa                	mv	a5,a0
    8020265e:	fcf43c23          	sd	a5,-40(s0)
    assert(pa != 0);
    80202662:	fd843783          	ld	a5,-40(s0)
    80202666:	00f037b3          	snez	a5,a5
    8020266a:	0ff7f793          	zext.b	a5,a5
    8020266e:	2781                	sext.w	a5,a5
    80202670:	853e                	mv	a0,a5
    80202672:	fffff097          	auipc	ra,0xfffff
    80202676:	62c080e7          	jalr	1580(ra) # 80201c9e <assert>
    assert(map_page(pt, va, pa, PTE_R | PTE_W) == 0);
    8020267a:	4699                	li	a3,6
    8020267c:	fd843603          	ld	a2,-40(s0)
    80202680:	fe043583          	ld	a1,-32(s0)
    80202684:	fe843503          	ld	a0,-24(s0)
    80202688:	00000097          	auipc	ra,0x0
    8020268c:	864080e7          	jalr	-1948(ra) # 80201eec <map_page>
    80202690:	87aa                	mv	a5,a0
    80202692:	0017b793          	seqz	a5,a5
    80202696:	0ff7f793          	zext.b	a5,a5
    8020269a:	2781                	sext.w	a5,a5
    8020269c:	853e                	mv	a0,a5
    8020269e:	fffff097          	auipc	ra,0xfffff
    802026a2:	600080e7          	jalr	1536(ra) # 80201c9e <assert>
    printf("[PT TEST] 映射测试通过\n");
    802026a6:	00005517          	auipc	a0,0x5
    802026aa:	ac250513          	addi	a0,a0,-1342 # 80207168 <small_numbers+0xd18>
    802026ae:	ffffe097          	auipc	ra,0xffffe
    802026b2:	4a6080e7          	jalr	1190(ra) # 80200b54 <printf>
    pte_t *pte = walk_lookup(pt, va);
    802026b6:	fe043583          	ld	a1,-32(s0)
    802026ba:	fe843503          	ld	a0,-24(s0)
    802026be:	fffff097          	auipc	ra,0xfffff
    802026c2:	6a2080e7          	jalr	1698(ra) # 80201d60 <walk_lookup>
    802026c6:	fca43823          	sd	a0,-48(s0)
    assert(pte != 0 && (*pte & PTE_V));
    802026ca:	fd043783          	ld	a5,-48(s0)
    802026ce:	cb81                	beqz	a5,802026de <test_pagetable+0xde>
    802026d0:	fd043783          	ld	a5,-48(s0)
    802026d4:	639c                	ld	a5,0(a5)
    802026d6:	8b85                	andi	a5,a5,1
    802026d8:	c399                	beqz	a5,802026de <test_pagetable+0xde>
    802026da:	4785                	li	a5,1
    802026dc:	a011                	j	802026e0 <test_pagetable+0xe0>
    802026de:	4781                	li	a5,0
    802026e0:	853e                	mv	a0,a5
    802026e2:	fffff097          	auipc	ra,0xfffff
    802026e6:	5bc080e7          	jalr	1468(ra) # 80201c9e <assert>
    assert(PTE2PA(*pte) == pa);
    802026ea:	fd043783          	ld	a5,-48(s0)
    802026ee:	639c                	ld	a5,0(a5)
    802026f0:	83a9                	srli	a5,a5,0xa
    802026f2:	07b2                	slli	a5,a5,0xc
    802026f4:	fd843703          	ld	a4,-40(s0)
    802026f8:	40f707b3          	sub	a5,a4,a5
    802026fc:	0017b793          	seqz	a5,a5
    80202700:	0ff7f793          	zext.b	a5,a5
    80202704:	2781                	sext.w	a5,a5
    80202706:	853e                	mv	a0,a5
    80202708:	fffff097          	auipc	ra,0xfffff
    8020270c:	596080e7          	jalr	1430(ra) # 80201c9e <assert>
    printf("[PT TEST] 地址转换测试通过\n");
    80202710:	00005517          	auipc	a0,0x5
    80202714:	a7850513          	addi	a0,a0,-1416 # 80207188 <small_numbers+0xd38>
    80202718:	ffffe097          	auipc	ra,0xffffe
    8020271c:	43c080e7          	jalr	1084(ra) # 80200b54 <printf>
    assert(*pte & PTE_R);
    80202720:	fd043783          	ld	a5,-48(s0)
    80202724:	639c                	ld	a5,0(a5)
    80202726:	2781                	sext.w	a5,a5
    80202728:	8b89                	andi	a5,a5,2
    8020272a:	2781                	sext.w	a5,a5
    8020272c:	853e                	mv	a0,a5
    8020272e:	fffff097          	auipc	ra,0xfffff
    80202732:	570080e7          	jalr	1392(ra) # 80201c9e <assert>
    assert(*pte & PTE_W);
    80202736:	fd043783          	ld	a5,-48(s0)
    8020273a:	639c                	ld	a5,0(a5)
    8020273c:	2781                	sext.w	a5,a5
    8020273e:	8b91                	andi	a5,a5,4
    80202740:	2781                	sext.w	a5,a5
    80202742:	853e                	mv	a0,a5
    80202744:	fffff097          	auipc	ra,0xfffff
    80202748:	55a080e7          	jalr	1370(ra) # 80201c9e <assert>
    assert(!(*pte & PTE_X));
    8020274c:	fd043783          	ld	a5,-48(s0)
    80202750:	639c                	ld	a5,0(a5)
    80202752:	8ba1                	andi	a5,a5,8
    80202754:	0017b793          	seqz	a5,a5
    80202758:	0ff7f793          	zext.b	a5,a5
    8020275c:	2781                	sext.w	a5,a5
    8020275e:	853e                	mv	a0,a5
    80202760:	fffff097          	auipc	ra,0xfffff
    80202764:	53e080e7          	jalr	1342(ra) # 80201c9e <assert>
    printf("[PT TEST] 权限测试通过\n");
    80202768:	00005517          	auipc	a0,0x5
    8020276c:	a4850513          	addi	a0,a0,-1464 # 802071b0 <small_numbers+0xd60>
    80202770:	ffffe097          	auipc	ra,0xffffe
    80202774:	3e4080e7          	jalr	996(ra) # 80200b54 <printf>
    free_page((void*)pa);
    80202778:	fd843783          	ld	a5,-40(s0)
    8020277c:	853e                	mv	a0,a5
    8020277e:	00000097          	auipc	ra,0x0
    80202782:	330080e7          	jalr	816(ra) # 80202aae <free_page>
    free_pagetable(pt);
    80202786:	fe843503          	ld	a0,-24(s0)
    8020278a:	00000097          	auipc	ra,0x0
    8020278e:	848080e7          	jalr	-1976(ra) # 80201fd2 <free_pagetable>
    printf("[PT TEST] 所有页表测试通过\n");
    80202792:	00005517          	auipc	a0,0x5
    80202796:	a3e50513          	addi	a0,a0,-1474 # 802071d0 <small_numbers+0xd80>
    8020279a:	ffffe097          	auipc	ra,0xffffe
    8020279e:	3ba080e7          	jalr	954(ra) # 80200b54 <printf>
}
    802027a2:	0001                	nop
    802027a4:	70a2                	ld	ra,40(sp)
    802027a6:	7402                	ld	s0,32(sp)
    802027a8:	6145                	addi	sp,sp,48
    802027aa:	8082                	ret

00000000802027ac <check_mapping>:
void check_mapping(uint64 va) {
    802027ac:	7179                	addi	sp,sp,-48
    802027ae:	f406                	sd	ra,40(sp)
    802027b0:	f022                	sd	s0,32(sp)
    802027b2:	1800                	addi	s0,sp,48
    802027b4:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    802027b8:	00008797          	auipc	a5,0x8
    802027bc:	8c878793          	addi	a5,a5,-1848 # 8020a080 <kernel_pagetable>
    802027c0:	639c                	ld	a5,0(a5)
    802027c2:	fd843583          	ld	a1,-40(s0)
    802027c6:	853e                	mv	a0,a5
    802027c8:	fffff097          	auipc	ra,0xfffff
    802027cc:	598080e7          	jalr	1432(ra) # 80201d60 <walk_lookup>
    802027d0:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    802027d4:	fe843783          	ld	a5,-24(s0)
    802027d8:	c78d                	beqz	a5,80202802 <check_mapping+0x56>
    802027da:	fe843783          	ld	a5,-24(s0)
    802027de:	639c                	ld	a5,0(a5)
    802027e0:	8b85                	andi	a5,a5,1
    802027e2:	c385                	beqz	a5,80202802 <check_mapping+0x56>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    802027e4:	fe843783          	ld	a5,-24(s0)
    802027e8:	639c                	ld	a5,0(a5)
    802027ea:	863e                	mv	a2,a5
    802027ec:	fd843583          	ld	a1,-40(s0)
    802027f0:	00005517          	auipc	a0,0x5
    802027f4:	a0850513          	addi	a0,a0,-1528 # 802071f8 <small_numbers+0xda8>
    802027f8:	ffffe097          	auipc	ra,0xffffe
    802027fc:	35c080e7          	jalr	860(ra) # 80200b54 <printf>
    80202800:	a821                	j	80202818 <check_mapping+0x6c>
        printf("Address 0x%lx is NOT mapped\n", va);
    80202802:	fd843583          	ld	a1,-40(s0)
    80202806:	00005517          	auipc	a0,0x5
    8020280a:	a1a50513          	addi	a0,a0,-1510 # 80207220 <small_numbers+0xdd0>
    8020280e:	ffffe097          	auipc	ra,0xffffe
    80202812:	346080e7          	jalr	838(ra) # 80200b54 <printf>
}
    80202816:	0001                	nop
    80202818:	0001                	nop
    8020281a:	70a2                	ld	ra,40(sp)
    8020281c:	7402                	ld	s0,32(sp)
    8020281e:	6145                	addi	sp,sp,48
    80202820:	8082                	ret

0000000080202822 <check_is_mapped>:
int check_is_mapped(uint64 va) {
    80202822:	7179                	addi	sp,sp,-48
    80202824:	f406                	sd	ra,40(sp)
    80202826:	f022                	sd	s0,32(sp)
    80202828:	1800                	addi	s0,sp,48
    8020282a:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    8020282e:	00000097          	auipc	ra,0x0
    80202832:	bae080e7          	jalr	-1106(ra) # 802023dc <get_current_pagetable>
    80202836:	87aa                	mv	a5,a0
    80202838:	fd843583          	ld	a1,-40(s0)
    8020283c:	853e                	mv	a0,a5
    8020283e:	fffff097          	auipc	ra,0xfffff
    80202842:	522080e7          	jalr	1314(ra) # 80201d60 <walk_lookup>
    80202846:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    8020284a:	fe843783          	ld	a5,-24(s0)
    8020284e:	c795                	beqz	a5,8020287a <check_is_mapped+0x58>
    80202850:	fe843783          	ld	a5,-24(s0)
    80202854:	639c                	ld	a5,0(a5)
    80202856:	8b85                	andi	a5,a5,1
    80202858:	c38d                	beqz	a5,8020287a <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    8020285a:	fe843783          	ld	a5,-24(s0)
    8020285e:	639c                	ld	a5,0(a5)
    80202860:	863e                	mv	a2,a5
    80202862:	fd843583          	ld	a1,-40(s0)
    80202866:	00005517          	auipc	a0,0x5
    8020286a:	99250513          	addi	a0,a0,-1646 # 802071f8 <small_numbers+0xda8>
    8020286e:	ffffe097          	auipc	ra,0xffffe
    80202872:	2e6080e7          	jalr	742(ra) # 80200b54 <printf>
        return 1;
    80202876:	4785                	li	a5,1
    80202878:	a821                	j	80202890 <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    8020287a:	fd843583          	ld	a1,-40(s0)
    8020287e:	00005517          	auipc	a0,0x5
    80202882:	9a250513          	addi	a0,a0,-1630 # 80207220 <small_numbers+0xdd0>
    80202886:	ffffe097          	auipc	ra,0xffffe
    8020288a:	2ce080e7          	jalr	718(ra) # 80200b54 <printf>
        return 0;
    8020288e:	4781                	li	a5,0
}
    80202890:	853e                	mv	a0,a5
    80202892:	70a2                	ld	ra,40(sp)
    80202894:	7402                	ld	s0,32(sp)
    80202896:	6145                	addi	sp,sp,48
    80202898:	8082                	ret

000000008020289a <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    8020289a:	711d                	addi	sp,sp,-96
    8020289c:	ec86                	sd	ra,88(sp)
    8020289e:	e8a2                	sd	s0,80(sp)
    802028a0:	1080                	addi	s0,sp,96
    802028a2:	faa43c23          	sd	a0,-72(s0)
    802028a6:	fab43823          	sd	a1,-80(s0)
    802028aa:	fac43423          	sd	a2,-88(s0)
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    802028ae:	fe043423          	sd	zero,-24(s0)
    802028b2:	a075                	j	8020295e <uvmcopy+0xc4>
        pte_t *pte = walk_lookup(old, i);
    802028b4:	fe843583          	ld	a1,-24(s0)
    802028b8:	fb843503          	ld	a0,-72(s0)
    802028bc:	fffff097          	auipc	ra,0xfffff
    802028c0:	4a4080e7          	jalr	1188(ra) # 80201d60 <walk_lookup>
    802028c4:	fea43023          	sd	a0,-32(s0)
        if (pte == 0 || (*pte & PTE_V) == 0)
    802028c8:	fe043783          	ld	a5,-32(s0)
    802028cc:	c3d1                	beqz	a5,80202950 <uvmcopy+0xb6>
    802028ce:	fe043783          	ld	a5,-32(s0)
    802028d2:	639c                	ld	a5,0(a5)
    802028d4:	8b85                	andi	a5,a5,1
    802028d6:	cfad                	beqz	a5,80202950 <uvmcopy+0xb6>
        uint64 pa = PTE2PA(*pte);
    802028d8:	fe043783          	ld	a5,-32(s0)
    802028dc:	639c                	ld	a5,0(a5)
    802028de:	83a9                	srli	a5,a5,0xa
    802028e0:	07b2                	slli	a5,a5,0xc
    802028e2:	fcf43c23          	sd	a5,-40(s0)
        int flags = PTE_FLAGS(*pte);
    802028e6:	fe043783          	ld	a5,-32(s0)
    802028ea:	639c                	ld	a5,0(a5)
    802028ec:	2781                	sext.w	a5,a5
    802028ee:	3ff7f793          	andi	a5,a5,1023
    802028f2:	fcf42a23          	sw	a5,-44(s0)
        void *mem = alloc_page();
    802028f6:	00000097          	auipc	ra,0x0
    802028fa:	14c080e7          	jalr	332(ra) # 80202a42 <alloc_page>
    802028fe:	fca43423          	sd	a0,-56(s0)
        if (mem == 0)
    80202902:	fc843783          	ld	a5,-56(s0)
    80202906:	e399                	bnez	a5,8020290c <uvmcopy+0x72>
            return -1; // 分配失败
    80202908:	57fd                	li	a5,-1
    8020290a:	a08d                	j	8020296c <uvmcopy+0xd2>
        memmove(mem, (void*)pa, PGSIZE);
    8020290c:	fd843783          	ld	a5,-40(s0)
    80202910:	6605                	lui	a2,0x1
    80202912:	85be                	mv	a1,a5
    80202914:	fc843503          	ld	a0,-56(s0)
    80202918:	fffff097          	auipc	ra,0xfffff
    8020291c:	264080e7          	jalr	612(ra) # 80201b7c <memmove>
        if (map_page(new, i, (uint64)mem, flags) != 0) {
    80202920:	fc843783          	ld	a5,-56(s0)
    80202924:	fd442703          	lw	a4,-44(s0)
    80202928:	86ba                	mv	a3,a4
    8020292a:	863e                	mv	a2,a5
    8020292c:	fe843583          	ld	a1,-24(s0)
    80202930:	fb043503          	ld	a0,-80(s0)
    80202934:	fffff097          	auipc	ra,0xfffff
    80202938:	5b8080e7          	jalr	1464(ra) # 80201eec <map_page>
    8020293c:	87aa                	mv	a5,a0
    8020293e:	cb91                	beqz	a5,80202952 <uvmcopy+0xb8>
            free_page(mem);
    80202940:	fc843503          	ld	a0,-56(s0)
    80202944:	00000097          	auipc	ra,0x0
    80202948:	16a080e7          	jalr	362(ra) # 80202aae <free_page>
            return -1;
    8020294c:	57fd                	li	a5,-1
    8020294e:	a839                	j	8020296c <uvmcopy+0xd2>
            continue; // 跳过未分配的页
    80202950:	0001                	nop
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    80202952:	fe843703          	ld	a4,-24(s0)
    80202956:	6785                	lui	a5,0x1
    80202958:	97ba                	add	a5,a5,a4
    8020295a:	fef43423          	sd	a5,-24(s0)
    8020295e:	fe843703          	ld	a4,-24(s0)
    80202962:	fa843783          	ld	a5,-88(s0)
    80202966:	f4f767e3          	bltu	a4,a5,802028b4 <uvmcopy+0x1a>
    return 0;
    8020296a:	4781                	li	a5,0
    8020296c:	853e                	mv	a0,a5
    8020296e:	60e6                	ld	ra,88(sp)
    80202970:	6446                	ld	s0,80(sp)
    80202972:	6125                	addi	sp,sp,96
    80202974:	8082                	ret

0000000080202976 <assert>:
    80202976:	1101                	addi	sp,sp,-32
    80202978:	ec06                	sd	ra,24(sp)
    8020297a:	e822                	sd	s0,16(sp)
    8020297c:	1000                	addi	s0,sp,32
    8020297e:	87aa                	mv	a5,a0
    80202980:	fef42623          	sw	a5,-20(s0)
    80202984:	fec42783          	lw	a5,-20(s0)
    80202988:	2781                	sext.w	a5,a5
    8020298a:	e79d                	bnez	a5,802029b8 <assert+0x42>
    8020298c:	1a600613          	li	a2,422
    80202990:	00005597          	auipc	a1,0x5
    80202994:	8b058593          	addi	a1,a1,-1872 # 80207240 <small_numbers+0xdf0>
    80202998:	00005517          	auipc	a0,0x5
    8020299c:	8b850513          	addi	a0,a0,-1864 # 80207250 <small_numbers+0xe00>
    802029a0:	ffffe097          	auipc	ra,0xffffe
    802029a4:	1b4080e7          	jalr	436(ra) # 80200b54 <printf>
    802029a8:	00005517          	auipc	a0,0x5
    802029ac:	8d050513          	addi	a0,a0,-1840 # 80207278 <small_numbers+0xe28>
    802029b0:	fffff097          	auipc	ra,0xfffff
    802029b4:	aac080e7          	jalr	-1364(ra) # 8020145c <panic>
    802029b8:	0001                	nop
    802029ba:	60e2                	ld	ra,24(sp)
    802029bc:	6442                	ld	s0,16(sp)
    802029be:	6105                	addi	sp,sp,32
    802029c0:	8082                	ret

00000000802029c2 <freerange>:
static void freerange(void *pa_start, void *pa_end) {
    802029c2:	7179                	addi	sp,sp,-48
    802029c4:	f406                	sd	ra,40(sp)
    802029c6:	f022                	sd	s0,32(sp)
    802029c8:	1800                	addi	s0,sp,48
    802029ca:	fca43c23          	sd	a0,-40(s0)
    802029ce:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    802029d2:	fd843703          	ld	a4,-40(s0)
    802029d6:	6785                	lui	a5,0x1
    802029d8:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    802029da:	973e                	add	a4,a4,a5
    802029dc:	77fd                	lui	a5,0xfffff
    802029de:	8ff9                	and	a5,a5,a4
    802029e0:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802029e4:	a829                	j	802029fe <freerange+0x3c>
    free_page(p);
    802029e6:	fe843503          	ld	a0,-24(s0)
    802029ea:	00000097          	auipc	ra,0x0
    802029ee:	0c4080e7          	jalr	196(ra) # 80202aae <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802029f2:	fe843703          	ld	a4,-24(s0)
    802029f6:	6785                	lui	a5,0x1
    802029f8:	97ba                	add	a5,a5,a4
    802029fa:	fef43423          	sd	a5,-24(s0)
    802029fe:	fe843703          	ld	a4,-24(s0)
    80202a02:	6785                	lui	a5,0x1
    80202a04:	97ba                	add	a5,a5,a4
    80202a06:	fd043703          	ld	a4,-48(s0)
    80202a0a:	fcf77ee3          	bgeu	a4,a5,802029e6 <freerange+0x24>
}
    80202a0e:	0001                	nop
    80202a10:	0001                	nop
    80202a12:	70a2                	ld	ra,40(sp)
    80202a14:	7402                	ld	s0,32(sp)
    80202a16:	6145                	addi	sp,sp,48
    80202a18:	8082                	ret

0000000080202a1a <pmm_init>:
void pmm_init(void) {
    80202a1a:	1141                	addi	sp,sp,-16
    80202a1c:	e406                	sd	ra,8(sp)
    80202a1e:	e022                	sd	s0,0(sp)
    80202a20:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    80202a22:	47c5                	li	a5,17
    80202a24:	01b79593          	slli	a1,a5,0x1b
    80202a28:	00009517          	auipc	a0,0x9
    80202a2c:	32850513          	addi	a0,a0,808 # 8020bd50 <_bss_end>
    80202a30:	00000097          	auipc	ra,0x0
    80202a34:	f92080e7          	jalr	-110(ra) # 802029c2 <freerange>
}
    80202a38:	0001                	nop
    80202a3a:	60a2                	ld	ra,8(sp)
    80202a3c:	6402                	ld	s0,0(sp)
    80202a3e:	0141                	addi	sp,sp,16
    80202a40:	8082                	ret

0000000080202a42 <alloc_page>:
void* alloc_page(void) {
    80202a42:	1101                	addi	sp,sp,-32
    80202a44:	ec06                	sd	ra,24(sp)
    80202a46:	e822                	sd	s0,16(sp)
    80202a48:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    80202a4a:	00007797          	auipc	a5,0x7
    80202a4e:	76e78793          	addi	a5,a5,1902 # 8020a1b8 <freelist>
    80202a52:	639c                	ld	a5,0(a5)
    80202a54:	fef43423          	sd	a5,-24(s0)
  if(r)
    80202a58:	fe843783          	ld	a5,-24(s0)
    80202a5c:	cb89                	beqz	a5,80202a6e <alloc_page+0x2c>
    freelist = r->next;
    80202a5e:	fe843783          	ld	a5,-24(s0)
    80202a62:	6398                	ld	a4,0(a5)
    80202a64:	00007797          	auipc	a5,0x7
    80202a68:	75478793          	addi	a5,a5,1876 # 8020a1b8 <freelist>
    80202a6c:	e398                	sd	a4,0(a5)
  if(r)
    80202a6e:	fe843783          	ld	a5,-24(s0)
    80202a72:	cf99                	beqz	a5,80202a90 <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    80202a74:	fe843783          	ld	a5,-24(s0)
    80202a78:	00878713          	addi	a4,a5,8
    80202a7c:	6785                	lui	a5,0x1
    80202a7e:	ff878613          	addi	a2,a5,-8 # ff8 <userret+0xf5c>
    80202a82:	4595                	li	a1,5
    80202a84:	853a                	mv	a0,a4
    80202a86:	fffff097          	auipc	ra,0xfffff
    80202a8a:	0a6080e7          	jalr	166(ra) # 80201b2c <memset>
    80202a8e:	a809                	j	80202aa0 <alloc_page+0x5e>
    panic("alloc_page: out of memory");
    80202a90:	00004517          	auipc	a0,0x4
    80202a94:	7f050513          	addi	a0,a0,2032 # 80207280 <small_numbers+0xe30>
    80202a98:	fffff097          	auipc	ra,0xfffff
    80202a9c:	9c4080e7          	jalr	-1596(ra) # 8020145c <panic>
  return (void*)r;
    80202aa0:	fe843783          	ld	a5,-24(s0)
}
    80202aa4:	853e                	mv	a0,a5
    80202aa6:	60e2                	ld	ra,24(sp)
    80202aa8:	6442                	ld	s0,16(sp)
    80202aaa:	6105                	addi	sp,sp,32
    80202aac:	8082                	ret

0000000080202aae <free_page>:
void free_page(void* page) {
    80202aae:	7179                	addi	sp,sp,-48
    80202ab0:	f406                	sd	ra,40(sp)
    80202ab2:	f022                	sd	s0,32(sp)
    80202ab4:	1800                	addi	s0,sp,48
    80202ab6:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    80202aba:	fd843783          	ld	a5,-40(s0)
    80202abe:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    80202ac2:	fd843703          	ld	a4,-40(s0)
    80202ac6:	6785                	lui	a5,0x1
    80202ac8:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80202aca:	8ff9                	and	a5,a5,a4
    80202acc:	ef99                	bnez	a5,80202aea <free_page+0x3c>
    80202ace:	fd843703          	ld	a4,-40(s0)
    80202ad2:	00009797          	auipc	a5,0x9
    80202ad6:	27e78793          	addi	a5,a5,638 # 8020bd50 <_bss_end>
    80202ada:	00f76863          	bltu	a4,a5,80202aea <free_page+0x3c>
    80202ade:	fd843703          	ld	a4,-40(s0)
    80202ae2:	47c5                	li	a5,17
    80202ae4:	07ee                	slli	a5,a5,0x1b
    80202ae6:	00f76a63          	bltu	a4,a5,80202afa <free_page+0x4c>
    panic("free_page: invalid page address");
    80202aea:	00004517          	auipc	a0,0x4
    80202aee:	7b650513          	addi	a0,a0,1974 # 802072a0 <small_numbers+0xe50>
    80202af2:	fffff097          	auipc	ra,0xfffff
    80202af6:	96a080e7          	jalr	-1686(ra) # 8020145c <panic>
  r->next = freelist;
    80202afa:	00007797          	auipc	a5,0x7
    80202afe:	6be78793          	addi	a5,a5,1726 # 8020a1b8 <freelist>
    80202b02:	6398                	ld	a4,0(a5)
    80202b04:	fe843783          	ld	a5,-24(s0)
    80202b08:	e398                	sd	a4,0(a5)
  freelist = r;
    80202b0a:	00007797          	auipc	a5,0x7
    80202b0e:	6ae78793          	addi	a5,a5,1710 # 8020a1b8 <freelist>
    80202b12:	fe843703          	ld	a4,-24(s0)
    80202b16:	e398                	sd	a4,0(a5)
}
    80202b18:	0001                	nop
    80202b1a:	70a2                	ld	ra,40(sp)
    80202b1c:	7402                	ld	s0,32(sp)
    80202b1e:	6145                	addi	sp,sp,48
    80202b20:	8082                	ret

0000000080202b22 <test_physical_memory>:
void test_physical_memory(void) {
    80202b22:	7179                	addi	sp,sp,-48
    80202b24:	f406                	sd	ra,40(sp)
    80202b26:	f022                	sd	s0,32(sp)
    80202b28:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    80202b2a:	00004517          	auipc	a0,0x4
    80202b2e:	79650513          	addi	a0,a0,1942 # 802072c0 <small_numbers+0xe70>
    80202b32:	ffffe097          	auipc	ra,0xffffe
    80202b36:	022080e7          	jalr	34(ra) # 80200b54 <printf>
    void *page1 = alloc_page();
    80202b3a:	00000097          	auipc	ra,0x0
    80202b3e:	f08080e7          	jalr	-248(ra) # 80202a42 <alloc_page>
    80202b42:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    80202b46:	00000097          	auipc	ra,0x0
    80202b4a:	efc080e7          	jalr	-260(ra) # 80202a42 <alloc_page>
    80202b4e:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    80202b52:	fe843783          	ld	a5,-24(s0)
    80202b56:	00f037b3          	snez	a5,a5
    80202b5a:	0ff7f793          	zext.b	a5,a5
    80202b5e:	2781                	sext.w	a5,a5
    80202b60:	853e                	mv	a0,a5
    80202b62:	00000097          	auipc	ra,0x0
    80202b66:	e14080e7          	jalr	-492(ra) # 80202976 <assert>
    assert(page2 != 0);
    80202b6a:	fe043783          	ld	a5,-32(s0)
    80202b6e:	00f037b3          	snez	a5,a5
    80202b72:	0ff7f793          	zext.b	a5,a5
    80202b76:	2781                	sext.w	a5,a5
    80202b78:	853e                	mv	a0,a5
    80202b7a:	00000097          	auipc	ra,0x0
    80202b7e:	dfc080e7          	jalr	-516(ra) # 80202976 <assert>
    assert(page1 != page2);
    80202b82:	fe843703          	ld	a4,-24(s0)
    80202b86:	fe043783          	ld	a5,-32(s0)
    80202b8a:	40f707b3          	sub	a5,a4,a5
    80202b8e:	00f037b3          	snez	a5,a5
    80202b92:	0ff7f793          	zext.b	a5,a5
    80202b96:	2781                	sext.w	a5,a5
    80202b98:	853e                	mv	a0,a5
    80202b9a:	00000097          	auipc	ra,0x0
    80202b9e:	ddc080e7          	jalr	-548(ra) # 80202976 <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    80202ba2:	fe843703          	ld	a4,-24(s0)
    80202ba6:	6785                	lui	a5,0x1
    80202ba8:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80202baa:	8ff9                	and	a5,a5,a4
    80202bac:	0017b793          	seqz	a5,a5
    80202bb0:	0ff7f793          	zext.b	a5,a5
    80202bb4:	2781                	sext.w	a5,a5
    80202bb6:	853e                	mv	a0,a5
    80202bb8:	00000097          	auipc	ra,0x0
    80202bbc:	dbe080e7          	jalr	-578(ra) # 80202976 <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    80202bc0:	fe043703          	ld	a4,-32(s0)
    80202bc4:	6785                	lui	a5,0x1
    80202bc6:	17fd                	addi	a5,a5,-1 # fff <userret+0xf63>
    80202bc8:	8ff9                	and	a5,a5,a4
    80202bca:	0017b793          	seqz	a5,a5
    80202bce:	0ff7f793          	zext.b	a5,a5
    80202bd2:	2781                	sext.w	a5,a5
    80202bd4:	853e                	mv	a0,a5
    80202bd6:	00000097          	auipc	ra,0x0
    80202bda:	da0080e7          	jalr	-608(ra) # 80202976 <assert>
    printf("[PM TEST] 分配测试通过\n");
    80202bde:	00004517          	auipc	a0,0x4
    80202be2:	70250513          	addi	a0,a0,1794 # 802072e0 <small_numbers+0xe90>
    80202be6:	ffffe097          	auipc	ra,0xffffe
    80202bea:	f6e080e7          	jalr	-146(ra) # 80200b54 <printf>
    printf("[PM TEST] 数据写入测试...\n");
    80202bee:	00004517          	auipc	a0,0x4
    80202bf2:	71250513          	addi	a0,a0,1810 # 80207300 <small_numbers+0xeb0>
    80202bf6:	ffffe097          	auipc	ra,0xffffe
    80202bfa:	f5e080e7          	jalr	-162(ra) # 80200b54 <printf>
    *(int*)page1 = 0x12345678;
    80202bfe:	fe843783          	ld	a5,-24(s0)
    80202c02:	12345737          	lui	a4,0x12345
    80202c06:	67870713          	addi	a4,a4,1656 # 12345678 <userret+0x123455dc>
    80202c0a:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    80202c0c:	fe843783          	ld	a5,-24(s0)
    80202c10:	439c                	lw	a5,0(a5)
    80202c12:	873e                	mv	a4,a5
    80202c14:	123457b7          	lui	a5,0x12345
    80202c18:	67878793          	addi	a5,a5,1656 # 12345678 <userret+0x123455dc>
    80202c1c:	40f707b3          	sub	a5,a4,a5
    80202c20:	0017b793          	seqz	a5,a5
    80202c24:	0ff7f793          	zext.b	a5,a5
    80202c28:	2781                	sext.w	a5,a5
    80202c2a:	853e                	mv	a0,a5
    80202c2c:	00000097          	auipc	ra,0x0
    80202c30:	d4a080e7          	jalr	-694(ra) # 80202976 <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    80202c34:	00004517          	auipc	a0,0x4
    80202c38:	6f450513          	addi	a0,a0,1780 # 80207328 <small_numbers+0xed8>
    80202c3c:	ffffe097          	auipc	ra,0xffffe
    80202c40:	f18080e7          	jalr	-232(ra) # 80200b54 <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    80202c44:	00004517          	auipc	a0,0x4
    80202c48:	70c50513          	addi	a0,a0,1804 # 80207350 <small_numbers+0xf00>
    80202c4c:	ffffe097          	auipc	ra,0xffffe
    80202c50:	f08080e7          	jalr	-248(ra) # 80200b54 <printf>
    free_page(page1);
    80202c54:	fe843503          	ld	a0,-24(s0)
    80202c58:	00000097          	auipc	ra,0x0
    80202c5c:	e56080e7          	jalr	-426(ra) # 80202aae <free_page>
    void *page3 = alloc_page();
    80202c60:	00000097          	auipc	ra,0x0
    80202c64:	de2080e7          	jalr	-542(ra) # 80202a42 <alloc_page>
    80202c68:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    80202c6c:	fd843783          	ld	a5,-40(s0)
    80202c70:	00f037b3          	snez	a5,a5
    80202c74:	0ff7f793          	zext.b	a5,a5
    80202c78:	2781                	sext.w	a5,a5
    80202c7a:	853e                	mv	a0,a5
    80202c7c:	00000097          	auipc	ra,0x0
    80202c80:	cfa080e7          	jalr	-774(ra) # 80202976 <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    80202c84:	00004517          	auipc	a0,0x4
    80202c88:	6fc50513          	addi	a0,a0,1788 # 80207380 <small_numbers+0xf30>
    80202c8c:	ffffe097          	auipc	ra,0xffffe
    80202c90:	ec8080e7          	jalr	-312(ra) # 80200b54 <printf>
    free_page(page2);
    80202c94:	fe043503          	ld	a0,-32(s0)
    80202c98:	00000097          	auipc	ra,0x0
    80202c9c:	e16080e7          	jalr	-490(ra) # 80202aae <free_page>
    free_page(page3);
    80202ca0:	fd843503          	ld	a0,-40(s0)
    80202ca4:	00000097          	auipc	ra,0x0
    80202ca8:	e0a080e7          	jalr	-502(ra) # 80202aae <free_page>
    printf("[PM TEST] 所有物理内存管理测试通过\n");
    80202cac:	00004517          	auipc	a0,0x4
    80202cb0:	70450513          	addi	a0,a0,1796 # 802073b0 <small_numbers+0xf60>
    80202cb4:	ffffe097          	auipc	ra,0xffffe
    80202cb8:	ea0080e7          	jalr	-352(ra) # 80200b54 <printf>
    80202cbc:	0001                	nop
    80202cbe:	70a2                	ld	ra,40(sp)
    80202cc0:	7402                	ld	s0,32(sp)
    80202cc2:	6145                	addi	sp,sp,48
    80202cc4:	8082                	ret

0000000080202cc6 <sbi_set_time>:
#include "defs.h"

void sbi_set_time(uint64 time) {
    80202cc6:	1101                	addi	sp,sp,-32
    80202cc8:	ec22                	sd	s0,24(sp)
    80202cca:	1000                	addi	s0,sp,32
    80202ccc:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    80202cd0:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    80202cd4:	4881                	li	a7,0
    asm volatile ("ecall"
    80202cd6:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    80202cda:	0001                	nop
    80202cdc:	6462                	ld	s0,24(sp)
    80202cde:	6105                	addi	sp,sp,32
    80202ce0:	8082                	ret

0000000080202ce2 <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    80202ce2:	1101                	addi	sp,sp,-32
    80202ce4:	ec22                	sd	s0,24(sp)
    80202ce6:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    80202ce8:	c01027f3          	rdtime	a5
    80202cec:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    80202cf0:	fe843783          	ld	a5,-24(s0)
    80202cf4:	853e                	mv	a0,a5
    80202cf6:	6462                	ld	s0,24(sp)
    80202cf8:	6105                	addi	sp,sp,32
    80202cfa:	8082                	ret

0000000080202cfc <timeintr>:
#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    80202cfc:	1141                	addi	sp,sp,-16
    80202cfe:	e422                	sd	s0,8(sp)
    80202d00:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    80202d02:	00007797          	auipc	a5,0x7
    80202d06:	38678793          	addi	a5,a5,902 # 8020a088 <interrupt_test_flag>
    80202d0a:	639c                	ld	a5,0(a5)
    80202d0c:	cb99                	beqz	a5,80202d22 <timeintr+0x26>
        (*interrupt_test_flag)++;
    80202d0e:	00007797          	auipc	a5,0x7
    80202d12:	37a78793          	addi	a5,a5,890 # 8020a088 <interrupt_test_flag>
    80202d16:	639c                	ld	a5,0(a5)
    80202d18:	4398                	lw	a4,0(a5)
    80202d1a:	2701                	sext.w	a4,a4
    80202d1c:	2705                	addiw	a4,a4,1
    80202d1e:	2701                	sext.w	a4,a4
    80202d20:	c398                	sw	a4,0(a5)
    80202d22:	0001                	nop
    80202d24:	6422                	ld	s0,8(sp)
    80202d26:	0141                	addi	sp,sp,16
    80202d28:	8082                	ret

0000000080202d2a <r_sie>:
        printf("✓ 加载页故障异常处理成功\n\n");
    } else {
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    }
    
    // 4. 测试存储地址未对齐异常
    80202d2a:	1101                	addi	sp,sp,-32
    80202d2c:	ec22                	sd	s0,24(sp)
    80202d2e:	1000                	addi	s0,sp,32
    printf("4. 测试存储地址未对齐异常...\n");
    uint64 aligned_addr = (uint64)alloc_page();
    80202d30:	104027f3          	csrr	a5,sie
    80202d34:	fef43423          	sd	a5,-24(s0)
    if (aligned_addr != 0) {
    80202d38:	fe843783          	ld	a5,-24(s0)
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    80202d3c:	853e                	mv	a0,a5
    80202d3e:	6462                	ld	s0,24(sp)
    80202d40:	6105                	addi	sp,sp,32
    80202d42:	8082                	ret

0000000080202d44 <w_sie>:
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
        
    80202d44:	1101                	addi	sp,sp,-32
    80202d46:	ec22                	sd	s0,24(sp)
    80202d48:	1000                	addi	s0,sp,32
    80202d4a:	fea43423          	sd	a0,-24(s0)
        // 使用内联汇编进行未对齐访问，因为编译器可能会自动对齐
    80202d4e:	fe843783          	ld	a5,-24(s0)
    80202d52:	10479073          	csrw	sie,a5
        asm volatile (
    80202d56:	0001                	nop
    80202d58:	6462                	ld	s0,24(sp)
    80202d5a:	6105                	addi	sp,sp,32
    80202d5c:	8082                	ret

0000000080202d5e <r_sstatus>:
            "sd %0, 0(%1)"
            : 
    80202d5e:	1101                	addi	sp,sp,-32
    80202d60:	ec22                	sd	s0,24(sp)
    80202d62:	1000                	addi	s0,sp,32
            : "r" (0xdeadbeef), "r" (misaligned_addr)
            : "memory"
    80202d64:	100027f3          	csrr	a5,sstatus
    80202d68:	fef43423          	sd	a5,-24(s0)
        );
    80202d6c:	fe843783          	ld	a5,-24(s0)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    80202d70:	853e                	mv	a0,a5
    80202d72:	6462                	ld	s0,24(sp)
    80202d74:	6105                	addi	sp,sp,32
    80202d76:	8082                	ret

0000000080202d78 <w_sstatus>:
    } else {
    80202d78:	1101                	addi	sp,sp,-32
    80202d7a:	ec22                	sd	s0,24(sp)
    80202d7c:	1000                	addi	s0,sp,32
    80202d7e:	fea43423          	sd	a0,-24(s0)
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80202d82:	fe843783          	ld	a5,-24(s0)
    80202d86:	10079073          	csrw	sstatus,a5
    }
    80202d8a:	0001                	nop
    80202d8c:	6462                	ld	s0,24(sp)
    80202d8e:	6105                	addi	sp,sp,32
    80202d90:	8082                	ret

0000000080202d92 <w_sepc>:
    
    // 5. 测试加载地址未对齐异常
    printf("5. 测试加载地址未对齐异常...\n");
    80202d92:	1101                	addi	sp,sp,-32
    80202d94:	ec22                	sd	s0,24(sp)
    80202d96:	1000                	addi	s0,sp,32
    80202d98:	fea43423          	sd	a0,-24(s0)
    if (aligned_addr != 0) {
    80202d9c:	fe843783          	ld	a5,-24(s0)
    80202da0:	14179073          	csrw	sepc,a5
        uint64 misaligned_addr = aligned_addr + 1;
    80202da4:	0001                	nop
    80202da6:	6462                	ld	s0,24(sp)
    80202da8:	6105                	addi	sp,sp,32
    80202daa:	8082                	ret

0000000080202dac <intr_off>:
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
        
        uint64 value = 0;
        asm volatile (
            "ld %0, 0(%1)"
            : "=r" (value)
    80202dac:	1141                	addi	sp,sp,-16
    80202dae:	e406                	sd	ra,8(sp)
    80202db0:	e022                	sd	s0,0(sp)
    80202db2:	0800                	addi	s0,sp,16
            : "r" (misaligned_addr)
    80202db4:	00000097          	auipc	ra,0x0
    80202db8:	faa080e7          	jalr	-86(ra) # 80202d5e <r_sstatus>
    80202dbc:	87aa                	mv	a5,a0
    80202dbe:	9bf5                	andi	a5,a5,-3
    80202dc0:	853e                	mv	a0,a5
    80202dc2:	00000097          	auipc	ra,0x0
    80202dc6:	fb6080e7          	jalr	-74(ra) # 80202d78 <w_sstatus>
            : "memory"
    80202dca:	0001                	nop
    80202dcc:	60a2                	ld	ra,8(sp)
    80202dce:	6402                	ld	s0,0(sp)
    80202dd0:	0141                	addi	sp,sp,16
    80202dd2:	8082                	ret

0000000080202dd4 <w_stvec>:
        );
        printf("读取的值: 0x%lx\n", value);
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80202dd4:	1101                	addi	sp,sp,-32
    80202dd6:	ec22                	sd	s0,24(sp)
    80202dd8:	1000                	addi	s0,sp,32
    80202dda:	fea43423          	sd	a0,-24(s0)
    } else {
    80202dde:	fe843783          	ld	a5,-24(s0)
    80202de2:	10579073          	csrw	stvec,a5
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80202de6:	0001                	nop
    80202de8:	6462                	ld	s0,24(sp)
    80202dea:	6105                	addi	sp,sp,32
    80202dec:	8082                	ret

0000000080202dee <r_scause>:
	// 6. 测试断点异常
	printf("6. 测试断点异常...\n");
	asm volatile (
		"nop\n\t"      // 确保ebreak前有有效指令
		"ebreak\n\t"   // 断点指令
		"nop\n\t"      // 确保ebreak后有有效指令
    80202dee:	1101                	addi	sp,sp,-32
    80202df0:	ec22                	sd	s0,24(sp)
    80202df2:	1000                	addi	s0,sp,32
	);
	printf("✓ 断点异常处理成功\n\n");
    80202df4:	142027f3          	csrr	a5,scause
    80202df8:	fef43423          	sd	a5,-24(s0)
    // 7. 测试环境调用异常
    80202dfc:	fe843783          	ld	a5,-24(s0)
    printf("7. 测试环境调用异常...\n");
    80202e00:	853e                	mv	a0,a5
    80202e02:	6462                	ld	s0,24(sp)
    80202e04:	6105                	addi	sp,sp,32
    80202e06:	8082                	ret

0000000080202e08 <r_sepc>:
    asm volatile ("ecall");  // 从S模式生成环境调用
    printf("✓ 环境调用异常处理成功\n\n");
    80202e08:	1101                	addi	sp,sp,-32
    80202e0a:	ec22                	sd	s0,24(sp)
    80202e0c:	1000                	addi	s0,sp,32
    
    printf("===== 异常处理测试完成 =====\n\n");
    80202e0e:	141027f3          	csrr	a5,sepc
    80202e12:	fef43423          	sd	a5,-24(s0)
}
    80202e16:	fe843783          	ld	a5,-24(s0)
    80202e1a:	853e                	mv	a0,a5
    80202e1c:	6462                	ld	s0,24(sp)
    80202e1e:	6105                	addi	sp,sp,32
    80202e20:	8082                	ret

0000000080202e22 <r_stval>:
    80202e22:	1101                	addi	sp,sp,-32
    80202e24:	ec22                	sd	s0,24(sp)
    80202e26:	1000                	addi	s0,sp,32
    80202e28:	143027f3          	csrr	a5,stval
    80202e2c:	fef43423          	sd	a5,-24(s0)
    80202e30:	fe843783          	ld	a5,-24(s0)
    80202e34:	853e                	mv	a0,a5
    80202e36:	6462                	ld	s0,24(sp)
    80202e38:	6105                	addi	sp,sp,32
    80202e3a:	8082                	ret

0000000080202e3c <save_exception_info>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    80202e3c:	7139                	addi	sp,sp,-64
    80202e3e:	fc22                	sd	s0,56(sp)
    80202e40:	0080                	addi	s0,sp,64
    80202e42:	fea43423          	sd	a0,-24(s0)
    80202e46:	feb43023          	sd	a1,-32(s0)
    80202e4a:	fcc43c23          	sd	a2,-40(s0)
    80202e4e:	fcd43823          	sd	a3,-48(s0)
    80202e52:	fce43423          	sd	a4,-56(s0)
    tf->epc = sepc;
    80202e56:	fe843783          	ld	a5,-24(s0)
    80202e5a:	fe043703          	ld	a4,-32(s0)
    80202e5e:	ef98                	sd	a4,24(a5)
}
    80202e60:	0001                	nop
    80202e62:	7462                	ld	s0,56(sp)
    80202e64:	6121                	addi	sp,sp,64
    80202e66:	8082                	ret

0000000080202e68 <get_sepc>:
static inline uint64 get_sepc(struct trapframe *tf) {
    80202e68:	1101                	addi	sp,sp,-32
    80202e6a:	ec22                	sd	s0,24(sp)
    80202e6c:	1000                	addi	s0,sp,32
    80202e6e:	fea43423          	sd	a0,-24(s0)
    return tf->epc;
    80202e72:	fe843783          	ld	a5,-24(s0)
    80202e76:	6f9c                	ld	a5,24(a5)
}
    80202e78:	853e                	mv	a0,a5
    80202e7a:	6462                	ld	s0,24(sp)
    80202e7c:	6105                	addi	sp,sp,32
    80202e7e:	8082                	ret

0000000080202e80 <set_sepc>:
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    80202e80:	1101                	addi	sp,sp,-32
    80202e82:	ec22                	sd	s0,24(sp)
    80202e84:	1000                	addi	s0,sp,32
    80202e86:	fea43423          	sd	a0,-24(s0)
    80202e8a:	feb43023          	sd	a1,-32(s0)
    tf->epc = sepc;
    80202e8e:	fe843783          	ld	a5,-24(s0)
    80202e92:	fe043703          	ld	a4,-32(s0)
    80202e96:	ef98                	sd	a4,24(a5)
}
    80202e98:	0001                	nop
    80202e9a:	6462                	ld	s0,24(sp)
    80202e9c:	6105                	addi	sp,sp,32
    80202e9e:	8082                	ret

0000000080202ea0 <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    80202ea0:	1101                	addi	sp,sp,-32
    80202ea2:	ec22                	sd	s0,24(sp)
    80202ea4:	1000                	addi	s0,sp,32
    80202ea6:	87aa                	mv	a5,a0
    80202ea8:	feb43023          	sd	a1,-32(s0)
    80202eac:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    80202eb0:	fec42783          	lw	a5,-20(s0)
    80202eb4:	2781                	sext.w	a5,a5
    80202eb6:	0207c563          	bltz	a5,80202ee0 <register_interrupt+0x40>
    80202eba:	fec42783          	lw	a5,-20(s0)
    80202ebe:	0007871b          	sext.w	a4,a5
    80202ec2:	03f00793          	li	a5,63
    80202ec6:	00e7cd63          	blt	a5,a4,80202ee0 <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    80202eca:	00007717          	auipc	a4,0x7
    80202ece:	2f670713          	addi	a4,a4,758 # 8020a1c0 <interrupt_vector>
    80202ed2:	fec42783          	lw	a5,-20(s0)
    80202ed6:	078e                	slli	a5,a5,0x3
    80202ed8:	97ba                	add	a5,a5,a4
    80202eda:	fe043703          	ld	a4,-32(s0)
    80202ede:	e398                	sd	a4,0(a5)
}
    80202ee0:	0001                	nop
    80202ee2:	6462                	ld	s0,24(sp)
    80202ee4:	6105                	addi	sp,sp,32
    80202ee6:	8082                	ret

0000000080202ee8 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    80202ee8:	1101                	addi	sp,sp,-32
    80202eea:	ec22                	sd	s0,24(sp)
    80202eec:	1000                	addi	s0,sp,32
    80202eee:	87aa                	mv	a5,a0
    80202ef0:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    80202ef4:	fec42783          	lw	a5,-20(s0)
    80202ef8:	2781                	sext.w	a5,a5
    80202efa:	0207c463          	bltz	a5,80202f22 <unregister_interrupt+0x3a>
    80202efe:	fec42783          	lw	a5,-20(s0)
    80202f02:	0007871b          	sext.w	a4,a5
    80202f06:	03f00793          	li	a5,63
    80202f0a:	00e7cc63          	blt	a5,a4,80202f22 <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    80202f0e:	00007717          	auipc	a4,0x7
    80202f12:	2b270713          	addi	a4,a4,690 # 8020a1c0 <interrupt_vector>
    80202f16:	fec42783          	lw	a5,-20(s0)
    80202f1a:	078e                	slli	a5,a5,0x3
    80202f1c:	97ba                	add	a5,a5,a4
    80202f1e:	0007b023          	sd	zero,0(a5)
}
    80202f22:	0001                	nop
    80202f24:	6462                	ld	s0,24(sp)
    80202f26:	6105                	addi	sp,sp,32
    80202f28:	8082                	ret

0000000080202f2a <enable_interrupts>:
void enable_interrupts(int irq) {
    80202f2a:	1101                	addi	sp,sp,-32
    80202f2c:	ec06                	sd	ra,24(sp)
    80202f2e:	e822                	sd	s0,16(sp)
    80202f30:	1000                	addi	s0,sp,32
    80202f32:	87aa                	mv	a5,a0
    80202f34:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    80202f38:	fec42783          	lw	a5,-20(s0)
    80202f3c:	853e                	mv	a0,a5
    80202f3e:	00001097          	auipc	ra,0x1
    80202f42:	c8e080e7          	jalr	-882(ra) # 80203bcc <plic_enable>
}
    80202f46:	0001                	nop
    80202f48:	60e2                	ld	ra,24(sp)
    80202f4a:	6442                	ld	s0,16(sp)
    80202f4c:	6105                	addi	sp,sp,32
    80202f4e:	8082                	ret

0000000080202f50 <disable_interrupts>:
void disable_interrupts(int irq) {
    80202f50:	1101                	addi	sp,sp,-32
    80202f52:	ec06                	sd	ra,24(sp)
    80202f54:	e822                	sd	s0,16(sp)
    80202f56:	1000                	addi	s0,sp,32
    80202f58:	87aa                	mv	a5,a0
    80202f5a:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    80202f5e:	fec42783          	lw	a5,-20(s0)
    80202f62:	853e                	mv	a0,a5
    80202f64:	00001097          	auipc	ra,0x1
    80202f68:	cc0080e7          	jalr	-832(ra) # 80203c24 <plic_disable>
}
    80202f6c:	0001                	nop
    80202f6e:	60e2                	ld	ra,24(sp)
    80202f70:	6442                	ld	s0,16(sp)
    80202f72:	6105                	addi	sp,sp,32
    80202f74:	8082                	ret

0000000080202f76 <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    80202f76:	1101                	addi	sp,sp,-32
    80202f78:	ec06                	sd	ra,24(sp)
    80202f7a:	e822                	sd	s0,16(sp)
    80202f7c:	1000                	addi	s0,sp,32
    80202f7e:	87aa                	mv	a5,a0
    80202f80:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    80202f84:	fec42783          	lw	a5,-20(s0)
    80202f88:	2781                	sext.w	a5,a5
    80202f8a:	0207ce63          	bltz	a5,80202fc6 <interrupt_dispatch+0x50>
    80202f8e:	fec42783          	lw	a5,-20(s0)
    80202f92:	0007871b          	sext.w	a4,a5
    80202f96:	03f00793          	li	a5,63
    80202f9a:	02e7c663          	blt	a5,a4,80202fc6 <interrupt_dispatch+0x50>
    80202f9e:	00007717          	auipc	a4,0x7
    80202fa2:	22270713          	addi	a4,a4,546 # 8020a1c0 <interrupt_vector>
    80202fa6:	fec42783          	lw	a5,-20(s0)
    80202faa:	078e                	slli	a5,a5,0x3
    80202fac:	97ba                	add	a5,a5,a4
    80202fae:	639c                	ld	a5,0(a5)
    80202fb0:	cb99                	beqz	a5,80202fc6 <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    80202fb2:	00007717          	auipc	a4,0x7
    80202fb6:	20e70713          	addi	a4,a4,526 # 8020a1c0 <interrupt_vector>
    80202fba:	fec42783          	lw	a5,-20(s0)
    80202fbe:	078e                	slli	a5,a5,0x3
    80202fc0:	97ba                	add	a5,a5,a4
    80202fc2:	639c                	ld	a5,0(a5)
    80202fc4:	9782                	jalr	a5
}
    80202fc6:	0001                	nop
    80202fc8:	60e2                	ld	ra,24(sp)
    80202fca:	6442                	ld	s0,16(sp)
    80202fcc:	6105                	addi	sp,sp,32
    80202fce:	8082                	ret

0000000080202fd0 <handle_external_interrupt>:
void handle_external_interrupt(void) {
    80202fd0:	1101                	addi	sp,sp,-32
    80202fd2:	ec06                	sd	ra,24(sp)
    80202fd4:	e822                	sd	s0,16(sp)
    80202fd6:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    80202fd8:	00001097          	auipc	ra,0x1
    80202fdc:	caa080e7          	jalr	-854(ra) # 80203c82 <plic_claim>
    80202fe0:	87aa                	mv	a5,a0
    80202fe2:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    80202fe6:	fec42783          	lw	a5,-20(s0)
    80202fea:	2781                	sext.w	a5,a5
    80202fec:	eb91                	bnez	a5,80203000 <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    80202fee:	00004517          	auipc	a0,0x4
    80202ff2:	3f250513          	addi	a0,a0,1010 # 802073e0 <small_numbers+0xf90>
    80202ff6:	ffffe097          	auipc	ra,0xffffe
    80202ffa:	b5e080e7          	jalr	-1186(ra) # 80200b54 <printf>
        return;
    80202ffe:	a839                	j	8020301c <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    80203000:	fec42783          	lw	a5,-20(s0)
    80203004:	853e                	mv	a0,a5
    80203006:	00000097          	auipc	ra,0x0
    8020300a:	f70080e7          	jalr	-144(ra) # 80202f76 <interrupt_dispatch>
    plic_complete(irq);
    8020300e:	fec42783          	lw	a5,-20(s0)
    80203012:	853e                	mv	a0,a5
    80203014:	00001097          	auipc	ra,0x1
    80203018:	c96080e7          	jalr	-874(ra) # 80203caa <plic_complete>
}
    8020301c:	60e2                	ld	ra,24(sp)
    8020301e:	6442                	ld	s0,16(sp)
    80203020:	6105                	addi	sp,sp,32
    80203022:	8082                	ret

0000000080203024 <trap_init>:
void trap_init(void) {
    80203024:	1101                	addi	sp,sp,-32
    80203026:	ec06                	sd	ra,24(sp)
    80203028:	e822                	sd	s0,16(sp)
    8020302a:	1000                	addi	s0,sp,32
	intr_off();
    8020302c:	00000097          	auipc	ra,0x0
    80203030:	d80080e7          	jalr	-640(ra) # 80202dac <intr_off>
	printf("trap_init...\n");
    80203034:	00004517          	auipc	a0,0x4
    80203038:	3cc50513          	addi	a0,a0,972 # 80207400 <small_numbers+0xfb0>
    8020303c:	ffffe097          	auipc	ra,0xffffe
    80203040:	b18080e7          	jalr	-1256(ra) # 80200b54 <printf>
	w_stvec((uint64)kernelvec);
    80203044:	00001797          	auipc	a5,0x1
    80203048:	c9c78793          	addi	a5,a5,-868 # 80203ce0 <kernelvec>
    8020304c:	853e                	mv	a0,a5
    8020304e:	00000097          	auipc	ra,0x0
    80203052:	d86080e7          	jalr	-634(ra) # 80202dd4 <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    80203056:	fe042623          	sw	zero,-20(s0)
    8020305a:	a005                	j	8020307a <trap_init+0x56>
		interrupt_vector[i] = 0;
    8020305c:	00007717          	auipc	a4,0x7
    80203060:	16470713          	addi	a4,a4,356 # 8020a1c0 <interrupt_vector>
    80203064:	fec42783          	lw	a5,-20(s0)
    80203068:	078e                	slli	a5,a5,0x3
    8020306a:	97ba                	add	a5,a5,a4
    8020306c:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    80203070:	fec42783          	lw	a5,-20(s0)
    80203074:	2785                	addiw	a5,a5,1
    80203076:	fef42623          	sw	a5,-20(s0)
    8020307a:	fec42783          	lw	a5,-20(s0)
    8020307e:	0007871b          	sext.w	a4,a5
    80203082:	03f00793          	li	a5,63
    80203086:	fce7dbe3          	bge	a5,a4,8020305c <trap_init+0x38>
	plic_init();
    8020308a:	00001097          	auipc	ra,0x1
    8020308e:	aa4080e7          	jalr	-1372(ra) # 80203b2e <plic_init>
    uint64 sie = r_sie();
    80203092:	00000097          	auipc	ra,0x0
    80203096:	c98080e7          	jalr	-872(ra) # 80202d2a <r_sie>
    8020309a:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    8020309e:	fe043783          	ld	a5,-32(s0)
    802030a2:	2207e793          	ori	a5,a5,544
    802030a6:	853e                	mv	a0,a5
    802030a8:	00000097          	auipc	ra,0x0
    802030ac:	c9c080e7          	jalr	-868(ra) # 80202d44 <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802030b0:	00000097          	auipc	ra,0x0
    802030b4:	c32080e7          	jalr	-974(ra) # 80202ce2 <sbi_get_time>
    802030b8:	872a                	mv	a4,a0
    802030ba:	000f47b7          	lui	a5,0xf4
    802030be:	24078793          	addi	a5,a5,576 # f4240 <userret+0xf41a4>
    802030c2:	97ba                	add	a5,a5,a4
    802030c4:	853e                	mv	a0,a5
    802030c6:	00000097          	auipc	ra,0x0
    802030ca:	c00080e7          	jalr	-1024(ra) # 80202cc6 <sbi_set_time>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    802030ce:	00000597          	auipc	a1,0x0
    802030d2:	57258593          	addi	a1,a1,1394 # 80203640 <handle_store_page_fault>
    802030d6:	00004517          	auipc	a0,0x4
    802030da:	33a50513          	addi	a0,a0,826 # 80207410 <small_numbers+0xfc0>
    802030de:	ffffe097          	auipc	ra,0xffffe
    802030e2:	a76080e7          	jalr	-1418(ra) # 80200b54 <printf>
	printf("trap_init complete.\n");
    802030e6:	00004517          	auipc	a0,0x4
    802030ea:	36250513          	addi	a0,a0,866 # 80207448 <small_numbers+0xff8>
    802030ee:	ffffe097          	auipc	ra,0xffffe
    802030f2:	a66080e7          	jalr	-1434(ra) # 80200b54 <printf>
}
    802030f6:	0001                	nop
    802030f8:	60e2                	ld	ra,24(sp)
    802030fa:	6442                	ld	s0,16(sp)
    802030fc:	6105                	addi	sp,sp,32
    802030fe:	8082                	ret

0000000080203100 <kerneltrap>:
void kerneltrap(void) {
    80203100:	7149                	addi	sp,sp,-368
    80203102:	f686                	sd	ra,360(sp)
    80203104:	f2a2                	sd	s0,352(sp)
    80203106:	1a80                	addi	s0,sp,368
    uint64 sstatus = r_sstatus();
    80203108:	00000097          	auipc	ra,0x0
    8020310c:	c56080e7          	jalr	-938(ra) # 80202d5e <r_sstatus>
    80203110:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    80203114:	00000097          	auipc	ra,0x0
    80203118:	cda080e7          	jalr	-806(ra) # 80202dee <r_scause>
    8020311c:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    80203120:	00000097          	auipc	ra,0x0
    80203124:	ce8080e7          	jalr	-792(ra) # 80202e08 <r_sepc>
    80203128:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    8020312c:	00000097          	auipc	ra,0x0
    80203130:	cf6080e7          	jalr	-778(ra) # 80202e22 <r_stval>
    80203134:	fca43823          	sd	a0,-48(s0)
    if(scause & 0x8000000000000000) {
    80203138:	fd843783          	ld	a5,-40(s0)
    8020313c:	0607d663          	bgez	a5,802031a8 <kerneltrap+0xa8>
        if((scause & 0xff) == 5) {
    80203140:	fd843783          	ld	a5,-40(s0)
    80203144:	0ff7f713          	zext.b	a4,a5
    80203148:	4795                	li	a5,5
    8020314a:	02f71663          	bne	a4,a5,80203176 <kerneltrap+0x76>
            timeintr();
    8020314e:	00000097          	auipc	ra,0x0
    80203152:	bae080e7          	jalr	-1106(ra) # 80202cfc <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80203156:	00000097          	auipc	ra,0x0
    8020315a:	b8c080e7          	jalr	-1140(ra) # 80202ce2 <sbi_get_time>
    8020315e:	872a                	mv	a4,a0
    80203160:	000f47b7          	lui	a5,0xf4
    80203164:	24078793          	addi	a5,a5,576 # f4240 <userret+0xf41a4>
    80203168:	97ba                	add	a5,a5,a4
    8020316a:	853e                	mv	a0,a5
    8020316c:	00000097          	auipc	ra,0x0
    80203170:	b5a080e7          	jalr	-1190(ra) # 80202cc6 <sbi_set_time>
    80203174:	a855                	j	80203228 <kerneltrap+0x128>
        } else if((scause & 0xff) == 9) {
    80203176:	fd843783          	ld	a5,-40(s0)
    8020317a:	0ff7f713          	zext.b	a4,a5
    8020317e:	47a5                	li	a5,9
    80203180:	00f71763          	bne	a4,a5,8020318e <kerneltrap+0x8e>
            handle_external_interrupt();
    80203184:	00000097          	auipc	ra,0x0
    80203188:	e4c080e7          	jalr	-436(ra) # 80202fd0 <handle_external_interrupt>
    8020318c:	a871                	j	80203228 <kerneltrap+0x128>
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    8020318e:	fe843603          	ld	a2,-24(s0)
    80203192:	fd843583          	ld	a1,-40(s0)
    80203196:	00004517          	auipc	a0,0x4
    8020319a:	2ca50513          	addi	a0,a0,714 # 80207460 <small_numbers+0x1010>
    8020319e:	ffffe097          	auipc	ra,0xffffe
    802031a2:	9b6080e7          	jalr	-1610(ra) # 80200b54 <printf>
    802031a6:	a049                	j	80203228 <kerneltrap+0x128>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    802031a8:	fd043683          	ld	a3,-48(s0)
    802031ac:	fe843603          	ld	a2,-24(s0)
    802031b0:	fd843583          	ld	a1,-40(s0)
    802031b4:	00004517          	auipc	a0,0x4
    802031b8:	2e450513          	addi	a0,a0,740 # 80207498 <small_numbers+0x1048>
    802031bc:	ffffe097          	auipc	ra,0xffffe
    802031c0:	998080e7          	jalr	-1640(ra) # 80200b54 <printf>
        save_exception_info(&tf, sepc, sstatus, scause, stval);
    802031c4:	eb040793          	addi	a5,s0,-336
    802031c8:	fd043703          	ld	a4,-48(s0)
    802031cc:	fd843683          	ld	a3,-40(s0)
    802031d0:	fe043603          	ld	a2,-32(s0)
    802031d4:	fe843583          	ld	a1,-24(s0)
    802031d8:	853e                	mv	a0,a5
    802031da:	00000097          	auipc	ra,0x0
    802031de:	c62080e7          	jalr	-926(ra) # 80202e3c <save_exception_info>
        info.sepc = sepc;
    802031e2:	fe843783          	ld	a5,-24(s0)
    802031e6:	e8f43823          	sd	a5,-368(s0)
        info.sstatus = sstatus;
    802031ea:	fe043783          	ld	a5,-32(s0)
    802031ee:	e8f43c23          	sd	a5,-360(s0)
        info.scause = scause;
    802031f2:	fd843783          	ld	a5,-40(s0)
    802031f6:	eaf43023          	sd	a5,-352(s0)
        info.stval = stval;
    802031fa:	fd043783          	ld	a5,-48(s0)
    802031fe:	eaf43423          	sd	a5,-344(s0)
        handle_exception(&tf, &info);
    80203202:	e9040713          	addi	a4,s0,-368
    80203206:	eb040793          	addi	a5,s0,-336
    8020320a:	85ba                	mv	a1,a4
    8020320c:	853e                	mv	a0,a5
    8020320e:	00000097          	auipc	ra,0x0
    80203212:	03c080e7          	jalr	60(ra) # 8020324a <handle_exception>
        sepc = get_sepc(&tf);
    80203216:	eb040793          	addi	a5,s0,-336
    8020321a:	853e                	mv	a0,a5
    8020321c:	00000097          	auipc	ra,0x0
    80203220:	c4c080e7          	jalr	-948(ra) # 80202e68 <get_sepc>
    80203224:	fea43423          	sd	a0,-24(s0)
    w_sepc(sepc);
    80203228:	fe843503          	ld	a0,-24(s0)
    8020322c:	00000097          	auipc	ra,0x0
    80203230:	b66080e7          	jalr	-1178(ra) # 80202d92 <w_sepc>
    w_sstatus(sstatus);
    80203234:	fe043503          	ld	a0,-32(s0)
    80203238:	00000097          	auipc	ra,0x0
    8020323c:	b40080e7          	jalr	-1216(ra) # 80202d78 <w_sstatus>
}
    80203240:	0001                	nop
    80203242:	70b6                	ld	ra,360(sp)
    80203244:	7416                	ld	s0,352(sp)
    80203246:	6175                	addi	sp,sp,368
    80203248:	8082                	ret

000000008020324a <handle_exception>:
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    8020324a:	7179                	addi	sp,sp,-48
    8020324c:	f406                	sd	ra,40(sp)
    8020324e:	f022                	sd	s0,32(sp)
    80203250:	1800                	addi	s0,sp,48
    80203252:	fca43c23          	sd	a0,-40(s0)
    80203256:	fcb43823          	sd	a1,-48(s0)
    uint64 cause = info->scause;  // 使用info中的字段
    8020325a:	fd043783          	ld	a5,-48(s0)
    8020325e:	6b9c                	ld	a5,16(a5)
    80203260:	fef43423          	sd	a5,-24(s0)
    switch (cause) {
    80203264:	fe843703          	ld	a4,-24(s0)
    80203268:	47bd                	li	a5,15
    8020326a:	26e7ef63          	bltu	a5,a4,802034e8 <handle_exception+0x29e>
    8020326e:	fe843783          	ld	a5,-24(s0)
    80203272:	00279713          	slli	a4,a5,0x2
    80203276:	00004797          	auipc	a5,0x4
    8020327a:	3de78793          	addi	a5,a5,990 # 80207654 <small_numbers+0x1204>
    8020327e:	97ba                	add	a5,a5,a4
    80203280:	439c                	lw	a5,0(a5)
    80203282:	0007871b          	sext.w	a4,a5
    80203286:	00004797          	auipc	a5,0x4
    8020328a:	3ce78793          	addi	a5,a5,974 # 80207654 <small_numbers+0x1204>
    8020328e:	97ba                	add	a5,a5,a4
    80203290:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80203292:	fd043783          	ld	a5,-48(s0)
    80203296:	6f9c                	ld	a5,24(a5)
    80203298:	85be                	mv	a1,a5
    8020329a:	00004517          	auipc	a0,0x4
    8020329e:	22e50513          	addi	a0,a0,558 # 802074c8 <small_numbers+0x1078>
    802032a2:	ffffe097          	auipc	ra,0xffffe
    802032a6:	8b2080e7          	jalr	-1870(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    802032aa:	fd043783          	ld	a5,-48(s0)
    802032ae:	639c                	ld	a5,0(a5)
    802032b0:	0791                	addi	a5,a5,4
    802032b2:	85be                	mv	a1,a5
    802032b4:	fd843503          	ld	a0,-40(s0)
    802032b8:	00000097          	auipc	ra,0x0
    802032bc:	bc8080e7          	jalr	-1080(ra) # 80202e80 <set_sepc>
            break;
    802032c0:	a495                	j	80203524 <handle_exception+0x2da>
            printf("Instruction access fault: 0x%lx\n", info->stval);
    802032c2:	fd043783          	ld	a5,-48(s0)
    802032c6:	6f9c                	ld	a5,24(a5)
    802032c8:	85be                	mv	a1,a5
    802032ca:	00004517          	auipc	a0,0x4
    802032ce:	22650513          	addi	a0,a0,550 # 802074f0 <small_numbers+0x10a0>
    802032d2:	ffffe097          	auipc	ra,0xffffe
    802032d6:	882080e7          	jalr	-1918(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    802032da:	fd043783          	ld	a5,-48(s0)
    802032de:	639c                	ld	a5,0(a5)
    802032e0:	0791                	addi	a5,a5,4
    802032e2:	85be                	mv	a1,a5
    802032e4:	fd843503          	ld	a0,-40(s0)
    802032e8:	00000097          	auipc	ra,0x0
    802032ec:	b98080e7          	jalr	-1128(ra) # 80202e80 <set_sepc>
            break;
    802032f0:	ac15                	j	80203524 <handle_exception+0x2da>
            printf("Illegal instruction at 0x%lx: 0x%lx\n", info->sepc, info->stval);
    802032f2:	fd043783          	ld	a5,-48(s0)
    802032f6:	6398                	ld	a4,0(a5)
    802032f8:	fd043783          	ld	a5,-48(s0)
    802032fc:	6f9c                	ld	a5,24(a5)
    802032fe:	863e                	mv	a2,a5
    80203300:	85ba                	mv	a1,a4
    80203302:	00004517          	auipc	a0,0x4
    80203306:	21650513          	addi	a0,a0,534 # 80207518 <small_numbers+0x10c8>
    8020330a:	ffffe097          	auipc	ra,0xffffe
    8020330e:	84a080e7          	jalr	-1974(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203312:	fd043783          	ld	a5,-48(s0)
    80203316:	639c                	ld	a5,0(a5)
    80203318:	0791                	addi	a5,a5,4
    8020331a:	85be                	mv	a1,a5
    8020331c:	fd843503          	ld	a0,-40(s0)
    80203320:	00000097          	auipc	ra,0x0
    80203324:	b60080e7          	jalr	-1184(ra) # 80202e80 <set_sepc>
            break;
    80203328:	aaf5                	j	80203524 <handle_exception+0x2da>
            printf("Breakpoint at 0x%lx\n", info->sepc);
    8020332a:	fd043783          	ld	a5,-48(s0)
    8020332e:	639c                	ld	a5,0(a5)
    80203330:	85be                	mv	a1,a5
    80203332:	00004517          	auipc	a0,0x4
    80203336:	20e50513          	addi	a0,a0,526 # 80207540 <small_numbers+0x10f0>
    8020333a:	ffffe097          	auipc	ra,0xffffe
    8020333e:	81a080e7          	jalr	-2022(ra) # 80200b54 <printf>
            set_sepc(tf, info->sepc + 4);
    80203342:	fd043783          	ld	a5,-48(s0)
    80203346:	639c                	ld	a5,0(a5)
    80203348:	0791                	addi	a5,a5,4
    8020334a:	85be                	mv	a1,a5
    8020334c:	fd843503          	ld	a0,-40(s0)
    80203350:	00000097          	auipc	ra,0x0
    80203354:	b30080e7          	jalr	-1232(ra) # 80202e80 <set_sepc>
            break;
    80203358:	a2f1                	j	80203524 <handle_exception+0x2da>
            printf("Load address misaligned: 0x%lx\n", info->stval);
    8020335a:	fd043783          	ld	a5,-48(s0)
    8020335e:	6f9c                	ld	a5,24(a5)
    80203360:	85be                	mv	a1,a5
    80203362:	00004517          	auipc	a0,0x4
    80203366:	1f650513          	addi	a0,a0,502 # 80207558 <small_numbers+0x1108>
    8020336a:	ffffd097          	auipc	ra,0xffffd
    8020336e:	7ea080e7          	jalr	2026(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203372:	fd043783          	ld	a5,-48(s0)
    80203376:	639c                	ld	a5,0(a5)
    80203378:	0791                	addi	a5,a5,4
    8020337a:	85be                	mv	a1,a5
    8020337c:	fd843503          	ld	a0,-40(s0)
    80203380:	00000097          	auipc	ra,0x0
    80203384:	b00080e7          	jalr	-1280(ra) # 80202e80 <set_sepc>
            break;
    80203388:	aa71                	j	80203524 <handle_exception+0x2da>
			printf("Load access fault: 0x%lx\n", info->stval);
    8020338a:	fd043783          	ld	a5,-48(s0)
    8020338e:	6f9c                	ld	a5,24(a5)
    80203390:	85be                	mv	a1,a5
    80203392:	00004517          	auipc	a0,0x4
    80203396:	1e650513          	addi	a0,a0,486 # 80207578 <small_numbers+0x1128>
    8020339a:	ffffd097          	auipc	ra,0xffffd
    8020339e:	7ba080e7          	jalr	1978(ra) # 80200b54 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
    802033a2:	fd043783          	ld	a5,-48(s0)
    802033a6:	6f9c                	ld	a5,24(a5)
    802033a8:	853e                	mv	a0,a5
    802033aa:	fffff097          	auipc	ra,0xfffff
    802033ae:	478080e7          	jalr	1144(ra) # 80202822 <check_is_mapped>
    802033b2:	87aa                	mv	a5,a0
    802033b4:	cf89                	beqz	a5,802033ce <handle_exception+0x184>
    802033b6:	fd043783          	ld	a5,-48(s0)
    802033ba:	6f9c                	ld	a5,24(a5)
    802033bc:	4589                	li	a1,2
    802033be:	853e                	mv	a0,a5
    802033c0:	fffff097          	auipc	ra,0xfffff
    802033c4:	034080e7          	jalr	52(ra) # 802023f4 <handle_page_fault>
    802033c8:	87aa                	mv	a5,a0
    802033ca:	14079a63          	bnez	a5,8020351e <handle_exception+0x2d4>
			set_sepc(tf, info->sepc + 4);
    802033ce:	fd043783          	ld	a5,-48(s0)
    802033d2:	639c                	ld	a5,0(a5)
    802033d4:	0791                	addi	a5,a5,4
    802033d6:	85be                	mv	a1,a5
    802033d8:	fd843503          	ld	a0,-40(s0)
    802033dc:	00000097          	auipc	ra,0x0
    802033e0:	aa4080e7          	jalr	-1372(ra) # 80202e80 <set_sepc>
			break;
    802033e4:	a281                	j	80203524 <handle_exception+0x2da>
            printf("Store address misaligned: 0x%lx\n", info->stval);
    802033e6:	fd043783          	ld	a5,-48(s0)
    802033ea:	6f9c                	ld	a5,24(a5)
    802033ec:	85be                	mv	a1,a5
    802033ee:	00004517          	auipc	a0,0x4
    802033f2:	1aa50513          	addi	a0,a0,426 # 80207598 <small_numbers+0x1148>
    802033f6:	ffffd097          	auipc	ra,0xffffd
    802033fa:	75e080e7          	jalr	1886(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4); 
    802033fe:	fd043783          	ld	a5,-48(s0)
    80203402:	639c                	ld	a5,0(a5)
    80203404:	0791                	addi	a5,a5,4
    80203406:	85be                	mv	a1,a5
    80203408:	fd843503          	ld	a0,-40(s0)
    8020340c:	00000097          	auipc	ra,0x0
    80203410:	a74080e7          	jalr	-1420(ra) # 80202e80 <set_sepc>
            break;
    80203414:	aa01                	j	80203524 <handle_exception+0x2da>
			printf("Store access fault: 0x%lx\n", info->stval);
    80203416:	fd043783          	ld	a5,-48(s0)
    8020341a:	6f9c                	ld	a5,24(a5)
    8020341c:	85be                	mv	a1,a5
    8020341e:	00004517          	auipc	a0,0x4
    80203422:	1a250513          	addi	a0,a0,418 # 802075c0 <small_numbers+0x1170>
    80203426:	ffffd097          	auipc	ra,0xffffd
    8020342a:	72e080e7          	jalr	1838(ra) # 80200b54 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
    8020342e:	fd043783          	ld	a5,-48(s0)
    80203432:	6f9c                	ld	a5,24(a5)
    80203434:	853e                	mv	a0,a5
    80203436:	fffff097          	auipc	ra,0xfffff
    8020343a:	3ec080e7          	jalr	1004(ra) # 80202822 <check_is_mapped>
    8020343e:	87aa                	mv	a5,a0
    80203440:	cf81                	beqz	a5,80203458 <handle_exception+0x20e>
    80203442:	fd043783          	ld	a5,-48(s0)
    80203446:	6f9c                	ld	a5,24(a5)
    80203448:	458d                	li	a1,3
    8020344a:	853e                	mv	a0,a5
    8020344c:	fffff097          	auipc	ra,0xfffff
    80203450:	fa8080e7          	jalr	-88(ra) # 802023f4 <handle_page_fault>
    80203454:	87aa                	mv	a5,a0
    80203456:	e7f1                	bnez	a5,80203522 <handle_exception+0x2d8>
			set_sepc(tf, info->sepc + 4);
    80203458:	fd043783          	ld	a5,-48(s0)
    8020345c:	639c                	ld	a5,0(a5)
    8020345e:	0791                	addi	a5,a5,4
    80203460:	85be                	mv	a1,a5
    80203462:	fd843503          	ld	a0,-40(s0)
    80203466:	00000097          	auipc	ra,0x0
    8020346a:	a1a080e7          	jalr	-1510(ra) # 80202e80 <set_sepc>
			break;
    8020346e:	a85d                	j	80203524 <handle_exception+0x2da>
            handle_syscall(tf,info);
    80203470:	fd043583          	ld	a1,-48(s0)
    80203474:	fd843503          	ld	a0,-40(s0)
    80203478:	00000097          	auipc	ra,0x0
    8020347c:	0b4080e7          	jalr	180(ra) # 8020352c <handle_syscall>
            break;
    80203480:	a055                	j	80203524 <handle_exception+0x2da>
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    80203482:	fd043783          	ld	a5,-48(s0)
    80203486:	639c                	ld	a5,0(a5)
    80203488:	85be                	mv	a1,a5
    8020348a:	00004517          	auipc	a0,0x4
    8020348e:	15650513          	addi	a0,a0,342 # 802075e0 <small_numbers+0x1190>
    80203492:	ffffd097          	auipc	ra,0xffffd
    80203496:	6c2080e7          	jalr	1730(ra) # 80200b54 <printf>
			set_sepc(tf, info->sepc + 4); 
    8020349a:	fd043783          	ld	a5,-48(s0)
    8020349e:	639c                	ld	a5,0(a5)
    802034a0:	0791                	addi	a5,a5,4
    802034a2:	85be                	mv	a1,a5
    802034a4:	fd843503          	ld	a0,-40(s0)
    802034a8:	00000097          	auipc	ra,0x0
    802034ac:	9d8080e7          	jalr	-1576(ra) # 80202e80 <set_sepc>
            break;
    802034b0:	a895                	j	80203524 <handle_exception+0x2da>
            handle_instruction_page_fault(tf,info);
    802034b2:	fd043583          	ld	a1,-48(s0)
    802034b6:	fd843503          	ld	a0,-40(s0)
    802034ba:	00000097          	auipc	ra,0x0
    802034be:	0c2080e7          	jalr	194(ra) # 8020357c <handle_instruction_page_fault>
            break;
    802034c2:	a08d                	j	80203524 <handle_exception+0x2da>
            handle_load_page_fault(tf,info);
    802034c4:	fd043583          	ld	a1,-48(s0)
    802034c8:	fd843503          	ld	a0,-40(s0)
    802034cc:	00000097          	auipc	ra,0x0
    802034d0:	112080e7          	jalr	274(ra) # 802035de <handle_load_page_fault>
            break;
    802034d4:	a881                	j	80203524 <handle_exception+0x2da>
            handle_store_page_fault(tf,info);
    802034d6:	fd043583          	ld	a1,-48(s0)
    802034da:	fd843503          	ld	a0,-40(s0)
    802034de:	00000097          	auipc	ra,0x0
    802034e2:	162080e7          	jalr	354(ra) # 80203640 <handle_store_page_fault>
            break;
    802034e6:	a83d                	j	80203524 <handle_exception+0x2da>
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    802034e8:	fd043783          	ld	a5,-48(s0)
    802034ec:	6398                	ld	a4,0(a5)
    802034ee:	fd043783          	ld	a5,-48(s0)
    802034f2:	6f9c                	ld	a5,24(a5)
    802034f4:	86be                	mv	a3,a5
    802034f6:	863a                	mv	a2,a4
    802034f8:	fe843583          	ld	a1,-24(s0)
    802034fc:	00004517          	auipc	a0,0x4
    80203500:	10c50513          	addi	a0,a0,268 # 80207608 <small_numbers+0x11b8>
    80203504:	ffffd097          	auipc	ra,0xffffd
    80203508:	650080e7          	jalr	1616(ra) # 80200b54 <printf>
            panic("Unknown exception");
    8020350c:	00004517          	auipc	a0,0x4
    80203510:	13450513          	addi	a0,a0,308 # 80207640 <small_numbers+0x11f0>
    80203514:	ffffe097          	auipc	ra,0xffffe
    80203518:	f48080e7          	jalr	-184(ra) # 8020145c <panic>
            break;
    8020351c:	a021                	j	80203524 <handle_exception+0x2da>
				return; // 成功处理
    8020351e:	0001                	nop
    80203520:	a011                	j	80203524 <handle_exception+0x2da>
				return; // 成功处理
    80203522:	0001                	nop
}
    80203524:	70a2                	ld	ra,40(sp)
    80203526:	7402                	ld	s0,32(sp)
    80203528:	6145                	addi	sp,sp,48
    8020352a:	8082                	ret

000000008020352c <handle_syscall>:
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    8020352c:	1101                	addi	sp,sp,-32
    8020352e:	ec06                	sd	ra,24(sp)
    80203530:	e822                	sd	s0,16(sp)
    80203532:	1000                	addi	s0,sp,32
    80203534:	fea43423          	sd	a0,-24(s0)
    80203538:	feb43023          	sd	a1,-32(s0)
    printf("System call from sepc=0x%lx, syscall number=%ld\n", info->sepc, tf->a7);
    8020353c:	fe043783          	ld	a5,-32(s0)
    80203540:	6398                	ld	a4,0(a5)
    80203542:	fe843783          	ld	a5,-24(s0)
    80203546:	77dc                	ld	a5,168(a5)
    80203548:	863e                	mv	a2,a5
    8020354a:	85ba                	mv	a1,a4
    8020354c:	00004517          	auipc	a0,0x4
    80203550:	14c50513          	addi	a0,a0,332 # 80207698 <small_numbers+0x1248>
    80203554:	ffffd097          	auipc	ra,0xffffd
    80203558:	600080e7          	jalr	1536(ra) # 80200b54 <printf>
    set_sepc(tf, info->sepc + 4);
    8020355c:	fe043783          	ld	a5,-32(s0)
    80203560:	639c                	ld	a5,0(a5)
    80203562:	0791                	addi	a5,a5,4
    80203564:	85be                	mv	a1,a5
    80203566:	fe843503          	ld	a0,-24(s0)
    8020356a:	00000097          	auipc	ra,0x0
    8020356e:	916080e7          	jalr	-1770(ra) # 80202e80 <set_sepc>
}
    80203572:	0001                	nop
    80203574:	60e2                	ld	ra,24(sp)
    80203576:	6442                	ld	s0,16(sp)
    80203578:	6105                	addi	sp,sp,32
    8020357a:	8082                	ret

000000008020357c <handle_instruction_page_fault>:
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    8020357c:	1101                	addi	sp,sp,-32
    8020357e:	ec06                	sd	ra,24(sp)
    80203580:	e822                	sd	s0,16(sp)
    80203582:	1000                	addi	s0,sp,32
    80203584:	fea43423          	sd	a0,-24(s0)
    80203588:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    8020358c:	fe043783          	ld	a5,-32(s0)
    80203590:	6f98                	ld	a4,24(a5)
    80203592:	fe043783          	ld	a5,-32(s0)
    80203596:	639c                	ld	a5,0(a5)
    80203598:	863e                	mv	a2,a5
    8020359a:	85ba                	mv	a1,a4
    8020359c:	00004517          	auipc	a0,0x4
    802035a0:	13450513          	addi	a0,a0,308 # 802076d0 <small_numbers+0x1280>
    802035a4:	ffffd097          	auipc	ra,0xffffd
    802035a8:	5b0080e7          	jalr	1456(ra) # 80200b54 <printf>
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    802035ac:	fe043783          	ld	a5,-32(s0)
    802035b0:	6f9c                	ld	a5,24(a5)
    802035b2:	4585                	li	a1,1
    802035b4:	853e                	mv	a0,a5
    802035b6:	fffff097          	auipc	ra,0xfffff
    802035ba:	e3e080e7          	jalr	-450(ra) # 802023f4 <handle_page_fault>
    802035be:	87aa                	mv	a5,a0
    802035c0:	eb91                	bnez	a5,802035d4 <handle_instruction_page_fault+0x58>
    panic("Unhandled instruction page fault");
    802035c2:	00004517          	auipc	a0,0x4
    802035c6:	13e50513          	addi	a0,a0,318 # 80207700 <small_numbers+0x12b0>
    802035ca:	ffffe097          	auipc	ra,0xffffe
    802035ce:	e92080e7          	jalr	-366(ra) # 8020145c <panic>
    802035d2:	a011                	j	802035d6 <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802035d4:	0001                	nop
}
    802035d6:	60e2                	ld	ra,24(sp)
    802035d8:	6442                	ld	s0,16(sp)
    802035da:	6105                	addi	sp,sp,32
    802035dc:	8082                	ret

00000000802035de <handle_load_page_fault>:
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    802035de:	1101                	addi	sp,sp,-32
    802035e0:	ec06                	sd	ra,24(sp)
    802035e2:	e822                	sd	s0,16(sp)
    802035e4:	1000                	addi	s0,sp,32
    802035e6:	fea43423          	sd	a0,-24(s0)
    802035ea:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802035ee:	fe043783          	ld	a5,-32(s0)
    802035f2:	6f98                	ld	a4,24(a5)
    802035f4:	fe043783          	ld	a5,-32(s0)
    802035f8:	639c                	ld	a5,0(a5)
    802035fa:	863e                	mv	a2,a5
    802035fc:	85ba                	mv	a1,a4
    802035fe:	00004517          	auipc	a0,0x4
    80203602:	12a50513          	addi	a0,a0,298 # 80207728 <small_numbers+0x12d8>
    80203606:	ffffd097          	auipc	ra,0xffffd
    8020360a:	54e080e7          	jalr	1358(ra) # 80200b54 <printf>
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    8020360e:	fe043783          	ld	a5,-32(s0)
    80203612:	6f9c                	ld	a5,24(a5)
    80203614:	4589                	li	a1,2
    80203616:	853e                	mv	a0,a5
    80203618:	fffff097          	auipc	ra,0xfffff
    8020361c:	ddc080e7          	jalr	-548(ra) # 802023f4 <handle_page_fault>
    80203620:	87aa                	mv	a5,a0
    80203622:	eb91                	bnez	a5,80203636 <handle_load_page_fault+0x58>
    panic("Unhandled load page fault");
    80203624:	00004517          	auipc	a0,0x4
    80203628:	13450513          	addi	a0,a0,308 # 80207758 <small_numbers+0x1308>
    8020362c:	ffffe097          	auipc	ra,0xffffe
    80203630:	e30080e7          	jalr	-464(ra) # 8020145c <panic>
    80203634:	a011                	j	80203638 <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80203636:	0001                	nop
}
    80203638:	60e2                	ld	ra,24(sp)
    8020363a:	6442                	ld	s0,16(sp)
    8020363c:	6105                	addi	sp,sp,32
    8020363e:	8082                	ret

0000000080203640 <handle_store_page_fault>:
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    80203640:	1101                	addi	sp,sp,-32
    80203642:	ec06                	sd	ra,24(sp)
    80203644:	e822                	sd	s0,16(sp)
    80203646:	1000                	addi	s0,sp,32
    80203648:	fea43423          	sd	a0,-24(s0)
    8020364c:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80203650:	fe043783          	ld	a5,-32(s0)
    80203654:	6f98                	ld	a4,24(a5)
    80203656:	fe043783          	ld	a5,-32(s0)
    8020365a:	639c                	ld	a5,0(a5)
    8020365c:	863e                	mv	a2,a5
    8020365e:	85ba                	mv	a1,a4
    80203660:	00004517          	auipc	a0,0x4
    80203664:	11850513          	addi	a0,a0,280 # 80207778 <small_numbers+0x1328>
    80203668:	ffffd097          	auipc	ra,0xffffd
    8020366c:	4ec080e7          	jalr	1260(ra) # 80200b54 <printf>
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    80203670:	fe043783          	ld	a5,-32(s0)
    80203674:	6f9c                	ld	a5,24(a5)
    80203676:	458d                	li	a1,3
    80203678:	853e                	mv	a0,a5
    8020367a:	fffff097          	auipc	ra,0xfffff
    8020367e:	d7a080e7          	jalr	-646(ra) # 802023f4 <handle_page_fault>
    80203682:	87aa                	mv	a5,a0
    80203684:	eb91                	bnez	a5,80203698 <handle_store_page_fault+0x58>
    panic("Unhandled store page fault");
    80203686:	00004517          	auipc	a0,0x4
    8020368a:	12250513          	addi	a0,a0,290 # 802077a8 <small_numbers+0x1358>
    8020368e:	ffffe097          	auipc	ra,0xffffe
    80203692:	dce080e7          	jalr	-562(ra) # 8020145c <panic>
    80203696:	a011                	j	8020369a <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80203698:	0001                	nop
}
    8020369a:	60e2                	ld	ra,24(sp)
    8020369c:	6442                	ld	s0,16(sp)
    8020369e:	6105                	addi	sp,sp,32
    802036a0:	8082                	ret

00000000802036a2 <get_time>:
uint64 get_time(void) {
    802036a2:	1141                	addi	sp,sp,-16
    802036a4:	e406                	sd	ra,8(sp)
    802036a6:	e022                	sd	s0,0(sp)
    802036a8:	0800                	addi	s0,sp,16
    return sbi_get_time();
    802036aa:	fffff097          	auipc	ra,0xfffff
    802036ae:	638080e7          	jalr	1592(ra) # 80202ce2 <sbi_get_time>
    802036b2:	87aa                	mv	a5,a0
}
    802036b4:	853e                	mv	a0,a5
    802036b6:	60a2                	ld	ra,8(sp)
    802036b8:	6402                	ld	s0,0(sp)
    802036ba:	0141                	addi	sp,sp,16
    802036bc:	8082                	ret

00000000802036be <test_timer_interrupt>:
void test_timer_interrupt(void) {
    802036be:	7179                	addi	sp,sp,-48
    802036c0:	f406                	sd	ra,40(sp)
    802036c2:	f022                	sd	s0,32(sp)
    802036c4:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    802036c6:	00004517          	auipc	a0,0x4
    802036ca:	10250513          	addi	a0,a0,258 # 802077c8 <small_numbers+0x1378>
    802036ce:	ffffd097          	auipc	ra,0xffffd
    802036d2:	486080e7          	jalr	1158(ra) # 80200b54 <printf>
    uint64 start_time = get_time();
    802036d6:	00000097          	auipc	ra,0x0
    802036da:	fcc080e7          	jalr	-52(ra) # 802036a2 <get_time>
    802036de:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    802036e2:	fc042a23          	sw	zero,-44(s0)
	int last_count = interrupt_count;
    802036e6:	fd442783          	lw	a5,-44(s0)
    802036ea:	fef42623          	sw	a5,-20(s0)
    interrupt_test_flag = &interrupt_count;
    802036ee:	00007797          	auipc	a5,0x7
    802036f2:	99a78793          	addi	a5,a5,-1638 # 8020a088 <interrupt_test_flag>
    802036f6:	fd440713          	addi	a4,s0,-44
    802036fa:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    802036fc:	a899                	j	80203752 <test_timer_interrupt+0x94>
        if(last_count != interrupt_count) {
    802036fe:	fd442703          	lw	a4,-44(s0)
    80203702:	fec42783          	lw	a5,-20(s0)
    80203706:	2781                	sext.w	a5,a5
    80203708:	02e78163          	beq	a5,a4,8020372a <test_timer_interrupt+0x6c>
			last_count = interrupt_count;
    8020370c:	fd442783          	lw	a5,-44(s0)
    80203710:	fef42623          	sw	a5,-20(s0)
			printf("Received interrupt %d\n", interrupt_count);
    80203714:	fd442783          	lw	a5,-44(s0)
    80203718:	85be                	mv	a1,a5
    8020371a:	00004517          	auipc	a0,0x4
    8020371e:	0ce50513          	addi	a0,a0,206 # 802077e8 <small_numbers+0x1398>
    80203722:	ffffd097          	auipc	ra,0xffffd
    80203726:	432080e7          	jalr	1074(ra) # 80200b54 <printf>
        for (volatile int i = 0; i < 1000000; i++);
    8020372a:	fc042823          	sw	zero,-48(s0)
    8020372e:	a801                	j	8020373e <test_timer_interrupt+0x80>
    80203730:	fd042783          	lw	a5,-48(s0)
    80203734:	2781                	sext.w	a5,a5
    80203736:	2785                	addiw	a5,a5,1
    80203738:	2781                	sext.w	a5,a5
    8020373a:	fcf42823          	sw	a5,-48(s0)
    8020373e:	fd042783          	lw	a5,-48(s0)
    80203742:	2781                	sext.w	a5,a5
    80203744:	873e                	mv	a4,a5
    80203746:	000f47b7          	lui	a5,0xf4
    8020374a:	23f78793          	addi	a5,a5,575 # f423f <userret+0xf41a3>
    8020374e:	fee7d1e3          	bge	a5,a4,80203730 <test_timer_interrupt+0x72>
    while (interrupt_count < 5) {
    80203752:	fd442783          	lw	a5,-44(s0)
    80203756:	873e                	mv	a4,a5
    80203758:	4791                	li	a5,4
    8020375a:	fae7d2e3          	bge	a5,a4,802036fe <test_timer_interrupt+0x40>
    interrupt_test_flag = 0;
    8020375e:	00007797          	auipc	a5,0x7
    80203762:	92a78793          	addi	a5,a5,-1750 # 8020a088 <interrupt_test_flag>
    80203766:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    8020376a:	00000097          	auipc	ra,0x0
    8020376e:	f38080e7          	jalr	-200(ra) # 802036a2 <get_time>
    80203772:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    80203776:	fd442683          	lw	a3,-44(s0)
    8020377a:	fd843703          	ld	a4,-40(s0)
    8020377e:	fe043783          	ld	a5,-32(s0)
    80203782:	40f707b3          	sub	a5,a4,a5
    80203786:	863e                	mv	a2,a5
    80203788:	85b6                	mv	a1,a3
    8020378a:	00004517          	auipc	a0,0x4
    8020378e:	07650513          	addi	a0,a0,118 # 80207800 <small_numbers+0x13b0>
    80203792:	ffffd097          	auipc	ra,0xffffd
    80203796:	3c2080e7          	jalr	962(ra) # 80200b54 <printf>
}
    8020379a:	0001                	nop
    8020379c:	70a2                	ld	ra,40(sp)
    8020379e:	7402                	ld	s0,32(sp)
    802037a0:	6145                	addi	sp,sp,48
    802037a2:	8082                	ret

00000000802037a4 <test_exception>:
void test_exception(void) {
    802037a4:	715d                	addi	sp,sp,-80
    802037a6:	e486                	sd	ra,72(sp)
    802037a8:	e0a2                	sd	s0,64(sp)
    802037aa:	0880                	addi	s0,sp,80
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    802037ac:	00004517          	auipc	a0,0x4
    802037b0:	08c50513          	addi	a0,a0,140 # 80207838 <small_numbers+0x13e8>
    802037b4:	ffffd097          	auipc	ra,0xffffd
    802037b8:	3a0080e7          	jalr	928(ra) # 80200b54 <printf>
    printf("1. 测试非法指令异常...\n");
    802037bc:	00004517          	auipc	a0,0x4
    802037c0:	0ac50513          	addi	a0,a0,172 # 80207868 <small_numbers+0x1418>
    802037c4:	ffffd097          	auipc	ra,0xffffd
    802037c8:	390080e7          	jalr	912(ra) # 80200b54 <printf>
    802037cc:	ffffffff          	.word	0xffffffff
    printf("✓ 非法指令异常处理成功\n\n");
    802037d0:	00004517          	auipc	a0,0x4
    802037d4:	0b850513          	addi	a0,a0,184 # 80207888 <small_numbers+0x1438>
    802037d8:	ffffd097          	auipc	ra,0xffffd
    802037dc:	37c080e7          	jalr	892(ra) # 80200b54 <printf>
    printf("2. 测试存储页故障异常...\n");
    802037e0:	00004517          	auipc	a0,0x4
    802037e4:	0d050513          	addi	a0,a0,208 # 802078b0 <small_numbers+0x1460>
    802037e8:	ffffd097          	auipc	ra,0xffffd
    802037ec:	36c080e7          	jalr	876(ra) # 80200b54 <printf>
    volatile uint64 *invalid_ptr = 0;
    802037f0:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    802037f4:	47a5                	li	a5,9
    802037f6:	07f2                	slli	a5,a5,0x1c
    802037f8:	fef43023          	sd	a5,-32(s0)
    802037fc:	a835                	j	80203838 <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    802037fe:	fe043503          	ld	a0,-32(s0)
    80203802:	fffff097          	auipc	ra,0xfffff
    80203806:	020080e7          	jalr	32(ra) # 80202822 <check_is_mapped>
    8020380a:	87aa                	mv	a5,a0
    8020380c:	e385                	bnez	a5,8020382c <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    8020380e:	fe043783          	ld	a5,-32(s0)
    80203812:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80203816:	fe043583          	ld	a1,-32(s0)
    8020381a:	00004517          	auipc	a0,0x4
    8020381e:	0be50513          	addi	a0,a0,190 # 802078d8 <small_numbers+0x1488>
    80203822:	ffffd097          	auipc	ra,0xffffd
    80203826:	332080e7          	jalr	818(ra) # 80200b54 <printf>
            break;
    8020382a:	a829                	j	80203844 <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    8020382c:	fe043703          	ld	a4,-32(s0)
    80203830:	6785                	lui	a5,0x1
    80203832:	97ba                	add	a5,a5,a4
    80203834:	fef43023          	sd	a5,-32(s0)
    80203838:	fe043703          	ld	a4,-32(s0)
    8020383c:	47cd                	li	a5,19
    8020383e:	07ee                	slli	a5,a5,0x1b
    80203840:	faf76fe3          	bltu	a4,a5,802037fe <test_exception+0x5a>
    if (invalid_ptr != 0) {
    80203844:	fe843783          	ld	a5,-24(s0)
    80203848:	cb95                	beqz	a5,8020387c <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    8020384a:	fe843783          	ld	a5,-24(s0)
    8020384e:	85be                	mv	a1,a5
    80203850:	00004517          	auipc	a0,0x4
    80203854:	0a850513          	addi	a0,a0,168 # 802078f8 <small_numbers+0x14a8>
    80203858:	ffffd097          	auipc	ra,0xffffd
    8020385c:	2fc080e7          	jalr	764(ra) # 80200b54 <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    80203860:	fe843783          	ld	a5,-24(s0)
    80203864:	02a00713          	li	a4,42
    80203868:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    8020386a:	00004517          	auipc	a0,0x4
    8020386e:	0be50513          	addi	a0,a0,190 # 80207928 <small_numbers+0x14d8>
    80203872:	ffffd097          	auipc	ra,0xffffd
    80203876:	2e2080e7          	jalr	738(ra) # 80200b54 <printf>
    8020387a:	a809                	j	8020388c <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    8020387c:	00004517          	auipc	a0,0x4
    80203880:	0d450513          	addi	a0,a0,212 # 80207950 <small_numbers+0x1500>
    80203884:	ffffd097          	auipc	ra,0xffffd
    80203888:	2d0080e7          	jalr	720(ra) # 80200b54 <printf>
    printf("3. 测试加载页故障异常...\n");
    8020388c:	00004517          	auipc	a0,0x4
    80203890:	0fc50513          	addi	a0,a0,252 # 80207988 <small_numbers+0x1538>
    80203894:	ffffd097          	auipc	ra,0xffffd
    80203898:	2c0080e7          	jalr	704(ra) # 80200b54 <printf>
    invalid_ptr = 0;
    8020389c:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802038a0:	4795                	li	a5,5
    802038a2:	07f6                	slli	a5,a5,0x1d
    802038a4:	fcf43c23          	sd	a5,-40(s0)
    802038a8:	a835                	j	802038e4 <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    802038aa:	fd843503          	ld	a0,-40(s0)
    802038ae:	fffff097          	auipc	ra,0xfffff
    802038b2:	f74080e7          	jalr	-140(ra) # 80202822 <check_is_mapped>
    802038b6:	87aa                	mv	a5,a0
    802038b8:	e385                	bnez	a5,802038d8 <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    802038ba:	fd843783          	ld	a5,-40(s0)
    802038be:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    802038c2:	fd843583          	ld	a1,-40(s0)
    802038c6:	00004517          	auipc	a0,0x4
    802038ca:	01250513          	addi	a0,a0,18 # 802078d8 <small_numbers+0x1488>
    802038ce:	ffffd097          	auipc	ra,0xffffd
    802038d2:	286080e7          	jalr	646(ra) # 80200b54 <printf>
            break;
    802038d6:	a829                	j	802038f0 <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802038d8:	fd843703          	ld	a4,-40(s0)
    802038dc:	6785                	lui	a5,0x1
    802038de:	97ba                	add	a5,a5,a4
    802038e0:	fcf43c23          	sd	a5,-40(s0)
    802038e4:	fd843703          	ld	a4,-40(s0)
    802038e8:	47d5                	li	a5,21
    802038ea:	07ee                	slli	a5,a5,0x1b
    802038ec:	faf76fe3          	bltu	a4,a5,802038aa <test_exception+0x106>
    if (invalid_ptr != 0) {
    802038f0:	fe843783          	ld	a5,-24(s0)
    802038f4:	c7a9                	beqz	a5,8020393e <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    802038f6:	fe843783          	ld	a5,-24(s0)
    802038fa:	85be                	mv	a1,a5
    802038fc:	00004517          	auipc	a0,0x4
    80203900:	0b450513          	addi	a0,a0,180 # 802079b0 <small_numbers+0x1560>
    80203904:	ffffd097          	auipc	ra,0xffffd
    80203908:	250080e7          	jalr	592(ra) # 80200b54 <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    8020390c:	fe843783          	ld	a5,-24(s0)
    80203910:	639c                	ld	a5,0(a5)
    80203912:	faf43823          	sd	a5,-80(s0)
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    80203916:	fb043783          	ld	a5,-80(s0)
    8020391a:	85be                	mv	a1,a5
    8020391c:	00004517          	auipc	a0,0x4
    80203920:	0c450513          	addi	a0,a0,196 # 802079e0 <small_numbers+0x1590>
    80203924:	ffffd097          	auipc	ra,0xffffd
    80203928:	230080e7          	jalr	560(ra) # 80200b54 <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    8020392c:	00004517          	auipc	a0,0x4
    80203930:	0cc50513          	addi	a0,a0,204 # 802079f8 <small_numbers+0x15a8>
    80203934:	ffffd097          	auipc	ra,0xffffd
    80203938:	220080e7          	jalr	544(ra) # 80200b54 <printf>
    8020393c:	a809                	j	8020394e <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    8020393e:	00004517          	auipc	a0,0x4
    80203942:	01250513          	addi	a0,a0,18 # 80207950 <small_numbers+0x1500>
    80203946:	ffffd097          	auipc	ra,0xffffd
    8020394a:	20e080e7          	jalr	526(ra) # 80200b54 <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    8020394e:	00004517          	auipc	a0,0x4
    80203952:	0d250513          	addi	a0,a0,210 # 80207a20 <small_numbers+0x15d0>
    80203956:	ffffd097          	auipc	ra,0xffffd
    8020395a:	1fe080e7          	jalr	510(ra) # 80200b54 <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    8020395e:	fffff097          	auipc	ra,0xfffff
    80203962:	0e4080e7          	jalr	228(ra) # 80202a42 <alloc_page>
    80203966:	87aa                	mv	a5,a0
    80203968:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    8020396c:	fd043783          	ld	a5,-48(s0)
    80203970:	c3a1                	beqz	a5,802039b0 <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    80203972:	fd043783          	ld	a5,-48(s0)
    80203976:	0785                	addi	a5,a5,1 # 1001 <userret+0xf65>
    80203978:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    8020397c:	fc843583          	ld	a1,-56(s0)
    80203980:	00004517          	auipc	a0,0x4
    80203984:	0d050513          	addi	a0,a0,208 # 80207a50 <small_numbers+0x1600>
    80203988:	ffffd097          	auipc	ra,0xffffd
    8020398c:	1cc080e7          	jalr	460(ra) # 80200b54 <printf>
        asm volatile (
    80203990:	deadc7b7          	lui	a5,0xdeadc
    80203994:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8d019f>
    80203998:	fc843703          	ld	a4,-56(s0)
    8020399c:	e31c                	sd	a5,0(a4)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    8020399e:	00004517          	auipc	a0,0x4
    802039a2:	0d250513          	addi	a0,a0,210 # 80207a70 <small_numbers+0x1620>
    802039a6:	ffffd097          	auipc	ra,0xffffd
    802039aa:	1ae080e7          	jalr	430(ra) # 80200b54 <printf>
    802039ae:	a809                	j	802039c0 <test_exception+0x21c>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    802039b0:	00004517          	auipc	a0,0x4
    802039b4:	0f050513          	addi	a0,a0,240 # 80207aa0 <small_numbers+0x1650>
    802039b8:	ffffd097          	auipc	ra,0xffffd
    802039bc:	19c080e7          	jalr	412(ra) # 80200b54 <printf>
    printf("5. 测试加载地址未对齐异常...\n");
    802039c0:	00004517          	auipc	a0,0x4
    802039c4:	12050513          	addi	a0,a0,288 # 80207ae0 <small_numbers+0x1690>
    802039c8:	ffffd097          	auipc	ra,0xffffd
    802039cc:	18c080e7          	jalr	396(ra) # 80200b54 <printf>
    if (aligned_addr != 0) {
    802039d0:	fd043783          	ld	a5,-48(s0)
    802039d4:	cbb1                	beqz	a5,80203a28 <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    802039d6:	fd043783          	ld	a5,-48(s0)
    802039da:	0785                	addi	a5,a5,1
    802039dc:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    802039e0:	fc043583          	ld	a1,-64(s0)
    802039e4:	00004517          	auipc	a0,0x4
    802039e8:	06c50513          	addi	a0,a0,108 # 80207a50 <small_numbers+0x1600>
    802039ec:	ffffd097          	auipc	ra,0xffffd
    802039f0:	168080e7          	jalr	360(ra) # 80200b54 <printf>
        uint64 value = 0;
    802039f4:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    802039f8:	fc043783          	ld	a5,-64(s0)
    802039fc:	639c                	ld	a5,0(a5)
    802039fe:	faf43c23          	sd	a5,-72(s0)
        printf("读取的值: 0x%lx\n", value);
    80203a02:	fb843583          	ld	a1,-72(s0)
    80203a06:	00004517          	auipc	a0,0x4
    80203a0a:	10a50513          	addi	a0,a0,266 # 80207b10 <small_numbers+0x16c0>
    80203a0e:	ffffd097          	auipc	ra,0xffffd
    80203a12:	146080e7          	jalr	326(ra) # 80200b54 <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80203a16:	00004517          	auipc	a0,0x4
    80203a1a:	11250513          	addi	a0,a0,274 # 80207b28 <small_numbers+0x16d8>
    80203a1e:	ffffd097          	auipc	ra,0xffffd
    80203a22:	136080e7          	jalr	310(ra) # 80200b54 <printf>
    80203a26:	a809                	j	80203a38 <test_exception+0x294>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80203a28:	00004517          	auipc	a0,0x4
    80203a2c:	07850513          	addi	a0,a0,120 # 80207aa0 <small_numbers+0x1650>
    80203a30:	ffffd097          	auipc	ra,0xffffd
    80203a34:	124080e7          	jalr	292(ra) # 80200b54 <printf>
	printf("6. 测试断点异常...\n");
    80203a38:	00004517          	auipc	a0,0x4
    80203a3c:	12050513          	addi	a0,a0,288 # 80207b58 <small_numbers+0x1708>
    80203a40:	ffffd097          	auipc	ra,0xffffd
    80203a44:	114080e7          	jalr	276(ra) # 80200b54 <printf>
	asm volatile (
    80203a48:	0001                	nop
    80203a4a:	9002                	ebreak
    80203a4c:	0001                	nop
	printf("✓ 断点异常处理成功\n\n");
    80203a4e:	00004517          	auipc	a0,0x4
    80203a52:	12a50513          	addi	a0,a0,298 # 80207b78 <small_numbers+0x1728>
    80203a56:	ffffd097          	auipc	ra,0xffffd
    80203a5a:	0fe080e7          	jalr	254(ra) # 80200b54 <printf>
    printf("7. 测试环境调用异常...\n");
    80203a5e:	00004517          	auipc	a0,0x4
    80203a62:	13a50513          	addi	a0,a0,314 # 80207b98 <small_numbers+0x1748>
    80203a66:	ffffd097          	auipc	ra,0xffffd
    80203a6a:	0ee080e7          	jalr	238(ra) # 80200b54 <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    80203a6e:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    80203a72:	00004517          	auipc	a0,0x4
    80203a76:	14650513          	addi	a0,a0,326 # 80207bb8 <small_numbers+0x1768>
    80203a7a:	ffffd097          	auipc	ra,0xffffd
    80203a7e:	0da080e7          	jalr	218(ra) # 80200b54 <printf>
    printf("===== 异常处理测试完成 =====\n\n");
    80203a82:	00004517          	auipc	a0,0x4
    80203a86:	15e50513          	addi	a0,a0,350 # 80207be0 <small_numbers+0x1790>
    80203a8a:	ffffd097          	auipc	ra,0xffffd
    80203a8e:	0ca080e7          	jalr	202(ra) # 80200b54 <printf>
}
    80203a92:	0001                	nop
    80203a94:	60a6                	ld	ra,72(sp)
    80203a96:	6406                	ld	s0,64(sp)
    80203a98:	6161                	addi	sp,sp,80
    80203a9a:	8082                	ret

0000000080203a9c <write32>:
    80203a9c:	7179                	addi	sp,sp,-48
    80203a9e:	f406                	sd	ra,40(sp)
    80203aa0:	f022                	sd	s0,32(sp)
    80203aa2:	1800                	addi	s0,sp,48
    80203aa4:	fca43c23          	sd	a0,-40(s0)
    80203aa8:	87ae                	mv	a5,a1
    80203aaa:	fcf42a23          	sw	a5,-44(s0)
    80203aae:	fd843783          	ld	a5,-40(s0)
    80203ab2:	8b8d                	andi	a5,a5,3
    80203ab4:	eb99                	bnez	a5,80203aca <write32+0x2e>
    80203ab6:	fd843783          	ld	a5,-40(s0)
    80203aba:	fef43423          	sd	a5,-24(s0)
    80203abe:	fe843783          	ld	a5,-24(s0)
    80203ac2:	fd442703          	lw	a4,-44(s0)
    80203ac6:	c398                	sw	a4,0(a5)
    80203ac8:	a819                	j	80203ade <write32+0x42>
    80203aca:	fd843583          	ld	a1,-40(s0)
    80203ace:	00004517          	auipc	a0,0x4
    80203ad2:	13a50513          	addi	a0,a0,314 # 80207c08 <small_numbers+0x17b8>
    80203ad6:	ffffd097          	auipc	ra,0xffffd
    80203ada:	07e080e7          	jalr	126(ra) # 80200b54 <printf>
    80203ade:	0001                	nop
    80203ae0:	70a2                	ld	ra,40(sp)
    80203ae2:	7402                	ld	s0,32(sp)
    80203ae4:	6145                	addi	sp,sp,48
    80203ae6:	8082                	ret

0000000080203ae8 <read32>:
    80203ae8:	7179                	addi	sp,sp,-48
    80203aea:	f406                	sd	ra,40(sp)
    80203aec:	f022                	sd	s0,32(sp)
    80203aee:	1800                	addi	s0,sp,48
    80203af0:	fca43c23          	sd	a0,-40(s0)
    80203af4:	fd843783          	ld	a5,-40(s0)
    80203af8:	8b8d                	andi	a5,a5,3
    80203afa:	eb91                	bnez	a5,80203b0e <read32+0x26>
    80203afc:	fd843783          	ld	a5,-40(s0)
    80203b00:	fef43423          	sd	a5,-24(s0)
    80203b04:	fe843783          	ld	a5,-24(s0)
    80203b08:	439c                	lw	a5,0(a5)
    80203b0a:	2781                	sext.w	a5,a5
    80203b0c:	a821                	j	80203b24 <read32+0x3c>
    80203b0e:	fd843583          	ld	a1,-40(s0)
    80203b12:	00004517          	auipc	a0,0x4
    80203b16:	12650513          	addi	a0,a0,294 # 80207c38 <small_numbers+0x17e8>
    80203b1a:	ffffd097          	auipc	ra,0xffffd
    80203b1e:	03a080e7          	jalr	58(ra) # 80200b54 <printf>
    80203b22:	4781                	li	a5,0
    80203b24:	853e                	mv	a0,a5
    80203b26:	70a2                	ld	ra,40(sp)
    80203b28:	7402                	ld	s0,32(sp)
    80203b2a:	6145                	addi	sp,sp,48
    80203b2c:	8082                	ret

0000000080203b2e <plic_init>:
void plic_init(void) {
    80203b2e:	1101                	addi	sp,sp,-32
    80203b30:	ec06                	sd	ra,24(sp)
    80203b32:	e822                	sd	s0,16(sp)
    80203b34:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80203b36:	4785                	li	a5,1
    80203b38:	fef42623          	sw	a5,-20(s0)
    80203b3c:	a805                	j	80203b6c <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    80203b3e:	fec42783          	lw	a5,-20(s0)
    80203b42:	0027979b          	slliw	a5,a5,0x2
    80203b46:	2781                	sext.w	a5,a5
    80203b48:	873e                	mv	a4,a5
    80203b4a:	0c0007b7          	lui	a5,0xc000
    80203b4e:	97ba                	add	a5,a5,a4
    80203b50:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80203b54:	4581                	li	a1,0
    80203b56:	fe043503          	ld	a0,-32(s0)
    80203b5a:	00000097          	auipc	ra,0x0
    80203b5e:	f42080e7          	jalr	-190(ra) # 80203a9c <write32>
    for (int i = 1; i <= 32; i++) {
    80203b62:	fec42783          	lw	a5,-20(s0)
    80203b66:	2785                	addiw	a5,a5,1 # c000001 <userret+0xbffff65>
    80203b68:	fef42623          	sw	a5,-20(s0)
    80203b6c:	fec42783          	lw	a5,-20(s0)
    80203b70:	0007871b          	sext.w	a4,a5
    80203b74:	02000793          	li	a5,32
    80203b78:	fce7d3e3          	bge	a5,a4,80203b3e <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    80203b7c:	4585                	li	a1,1
    80203b7e:	0c0007b7          	lui	a5,0xc000
    80203b82:	02878513          	addi	a0,a5,40 # c000028 <userret+0xbffff8c>
    80203b86:	00000097          	auipc	ra,0x0
    80203b8a:	f16080e7          	jalr	-234(ra) # 80203a9c <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    80203b8e:	4585                	li	a1,1
    80203b90:	0c0007b7          	lui	a5,0xc000
    80203b94:	00478513          	addi	a0,a5,4 # c000004 <userret+0xbffff68>
    80203b98:	00000097          	auipc	ra,0x0
    80203b9c:	f04080e7          	jalr	-252(ra) # 80203a9c <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    80203ba0:	40200593          	li	a1,1026
    80203ba4:	0c0027b7          	lui	a5,0xc002
    80203ba8:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203bac:	00000097          	auipc	ra,0x0
    80203bb0:	ef0080e7          	jalr	-272(ra) # 80203a9c <write32>
    write32(PLIC_THRESHOLD, 0);
    80203bb4:	4581                	li	a1,0
    80203bb6:	0c201537          	lui	a0,0xc201
    80203bba:	00000097          	auipc	ra,0x0
    80203bbe:	ee2080e7          	jalr	-286(ra) # 80203a9c <write32>
}
    80203bc2:	0001                	nop
    80203bc4:	60e2                	ld	ra,24(sp)
    80203bc6:	6442                	ld	s0,16(sp)
    80203bc8:	6105                	addi	sp,sp,32
    80203bca:	8082                	ret

0000000080203bcc <plic_enable>:
void plic_enable(int irq) {
    80203bcc:	7179                	addi	sp,sp,-48
    80203bce:	f406                	sd	ra,40(sp)
    80203bd0:	f022                	sd	s0,32(sp)
    80203bd2:	1800                	addi	s0,sp,48
    80203bd4:	87aa                	mv	a5,a0
    80203bd6:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80203bda:	0c0027b7          	lui	a5,0xc002
    80203bde:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203be2:	00000097          	auipc	ra,0x0
    80203be6:	f06080e7          	jalr	-250(ra) # 80203ae8 <read32>
    80203bea:	87aa                	mv	a5,a0
    80203bec:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    80203bf0:	fdc42783          	lw	a5,-36(s0)
    80203bf4:	873e                	mv	a4,a5
    80203bf6:	4785                	li	a5,1
    80203bf8:	00e797bb          	sllw	a5,a5,a4
    80203bfc:	2781                	sext.w	a5,a5
    80203bfe:	2781                	sext.w	a5,a5
    80203c00:	fec42703          	lw	a4,-20(s0)
    80203c04:	8fd9                	or	a5,a5,a4
    80203c06:	2781                	sext.w	a5,a5
    80203c08:	85be                	mv	a1,a5
    80203c0a:	0c0027b7          	lui	a5,0xc002
    80203c0e:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203c12:	00000097          	auipc	ra,0x0
    80203c16:	e8a080e7          	jalr	-374(ra) # 80203a9c <write32>
}
    80203c1a:	0001                	nop
    80203c1c:	70a2                	ld	ra,40(sp)
    80203c1e:	7402                	ld	s0,32(sp)
    80203c20:	6145                	addi	sp,sp,48
    80203c22:	8082                	ret

0000000080203c24 <plic_disable>:
void plic_disable(int irq) {
    80203c24:	7179                	addi	sp,sp,-48
    80203c26:	f406                	sd	ra,40(sp)
    80203c28:	f022                	sd	s0,32(sp)
    80203c2a:	1800                	addi	s0,sp,48
    80203c2c:	87aa                	mv	a5,a0
    80203c2e:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80203c32:	0c0027b7          	lui	a5,0xc002
    80203c36:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203c3a:	00000097          	auipc	ra,0x0
    80203c3e:	eae080e7          	jalr	-338(ra) # 80203ae8 <read32>
    80203c42:	87aa                	mv	a5,a0
    80203c44:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    80203c48:	fdc42783          	lw	a5,-36(s0)
    80203c4c:	873e                	mv	a4,a5
    80203c4e:	4785                	li	a5,1
    80203c50:	00e797bb          	sllw	a5,a5,a4
    80203c54:	2781                	sext.w	a5,a5
    80203c56:	fff7c793          	not	a5,a5
    80203c5a:	2781                	sext.w	a5,a5
    80203c5c:	2781                	sext.w	a5,a5
    80203c5e:	fec42703          	lw	a4,-20(s0)
    80203c62:	8ff9                	and	a5,a5,a4
    80203c64:	2781                	sext.w	a5,a5
    80203c66:	85be                	mv	a1,a5
    80203c68:	0c0027b7          	lui	a5,0xc002
    80203c6c:	08078513          	addi	a0,a5,128 # c002080 <userret+0xc001fe4>
    80203c70:	00000097          	auipc	ra,0x0
    80203c74:	e2c080e7          	jalr	-468(ra) # 80203a9c <write32>
}
    80203c78:	0001                	nop
    80203c7a:	70a2                	ld	ra,40(sp)
    80203c7c:	7402                	ld	s0,32(sp)
    80203c7e:	6145                	addi	sp,sp,48
    80203c80:	8082                	ret

0000000080203c82 <plic_claim>:
int plic_claim(void) {
    80203c82:	1141                	addi	sp,sp,-16
    80203c84:	e406                	sd	ra,8(sp)
    80203c86:	e022                	sd	s0,0(sp)
    80203c88:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    80203c8a:	0c2017b7          	lui	a5,0xc201
    80203c8e:	00478513          	addi	a0,a5,4 # c201004 <userret+0xc200f68>
    80203c92:	00000097          	auipc	ra,0x0
    80203c96:	e56080e7          	jalr	-426(ra) # 80203ae8 <read32>
    80203c9a:	87aa                	mv	a5,a0
    80203c9c:	2781                	sext.w	a5,a5
    80203c9e:	2781                	sext.w	a5,a5
}
    80203ca0:	853e                	mv	a0,a5
    80203ca2:	60a2                	ld	ra,8(sp)
    80203ca4:	6402                	ld	s0,0(sp)
    80203ca6:	0141                	addi	sp,sp,16
    80203ca8:	8082                	ret

0000000080203caa <plic_complete>:
void plic_complete(int irq) {
    80203caa:	1101                	addi	sp,sp,-32
    80203cac:	ec06                	sd	ra,24(sp)
    80203cae:	e822                	sd	s0,16(sp)
    80203cb0:	1000                	addi	s0,sp,32
    80203cb2:	87aa                	mv	a5,a0
    80203cb4:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    80203cb8:	fec42783          	lw	a5,-20(s0)
    80203cbc:	85be                	mv	a1,a5
    80203cbe:	0c2017b7          	lui	a5,0xc201
    80203cc2:	00478513          	addi	a0,a5,4 # c201004 <userret+0xc200f68>
    80203cc6:	00000097          	auipc	ra,0x0
    80203cca:	dd6080e7          	jalr	-554(ra) # 80203a9c <write32>
    80203cce:	0001                	nop
    80203cd0:	60e2                	ld	ra,24(sp)
    80203cd2:	6442                	ld	s0,16(sp)
    80203cd4:	6105                	addi	sp,sp,32
    80203cd6:	8082                	ret
	...

0000000080203ce0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80203ce0:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80203ce2:	e006                	sd	ra,0(sp)
        # 注意：不保存sp，因为我们已经修改了它
        sd gp, 16(sp)
    80203ce4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80203ce6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80203ce8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80203cea:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80203cec:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    80203cee:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80203cf0:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80203cf2:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80203cf4:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80203cf6:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80203cf8:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80203cfa:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80203cfc:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80203cfe:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80203d00:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80203d02:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80203d04:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80203d06:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80203d08:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    80203d0a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    80203d0c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    80203d0e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80203d10:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80203d12:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80203d14:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80203d16:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80203d18:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80203d1a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80203d1c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80203d1e:	fffff097          	auipc	ra,0xfffff
    80203d22:	3e2080e7          	jalr	994(ra) # 80203100 <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80203d26:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80203d28:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80203d2a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80203d2c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80203d2e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80203d30:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80203d32:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80203d34:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80203d36:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80203d38:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80203d3a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80203d3c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80203d3e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80203d40:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80203d42:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80203d44:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80203d46:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80203d48:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    80203d4a:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    80203d4c:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    80203d4e:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80203d50:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80203d52:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80203d54:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80203d56:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80203d58:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80203d5a:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80203d5c:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80203d5e:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80203d60:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80203d62:	10200073          	sret
    80203d66:	0001                	nop
    80203d68:	00000013          	nop
    80203d6c:	00000013          	nop

0000000080203d70 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80203d70:	00153023          	sd	ra,0(a0) # c201000 <userret+0xc200f64>
        sd sp, 8(a0)
    80203d74:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80203d78:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80203d7a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80203d7c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80203d80:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80203d84:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80203d88:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80203d8c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80203d90:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80203d94:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80203d98:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80203d9c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80203da0:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80203da4:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80203da8:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80203dac:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80203dae:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80203db0:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80203db4:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80203db8:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80203dbc:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80203dc0:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80203dc4:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80203dc8:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80203dcc:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80203dd0:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80203dd4:	0685bd83          	ld	s11,104(a1)
        
        ret
    80203dd8:	8082                	ret

0000000080203dda <r_sstatus>:
    for(p = proc_table; p < &proc_table[PROC]; p++) {
        if(p->state == SLEEPING && p->chan == chan) {
            p->state = RUNNABLE;
        }
    }
}
    80203dda:	1101                	addi	sp,sp,-32
    80203ddc:	ec22                	sd	s0,24(sp)
    80203dde:	1000                	addi	s0,sp,32
void kexit() {
    struct proc *p = myproc();
    80203de0:	100027f3          	csrr	a5,sstatus
    80203de4:	fef43423          	sd	a5,-24(s0)
    
    80203de8:	fe843783          	ld	a5,-24(s0)
    if (p == 0) {
    80203dec:	853e                	mv	a0,a5
    80203dee:	6462                	ld	s0,24(sp)
    80203df0:	6105                	addi	sp,sp,32
    80203df2:	8082                	ret

0000000080203df4 <w_sstatus>:
        panic("kexit: no current process");
    80203df4:	1101                	addi	sp,sp,-32
    80203df6:	ec22                	sd	s0,24(sp)
    80203df8:	1000                	addi	s0,sp,32
    80203dfa:	fea43423          	sd	a0,-24(s0)
    }
    80203dfe:	fe843783          	ld	a5,-24(s0)
    80203e02:	10079073          	csrw	sstatus,a5
    
    80203e06:	0001                	nop
    80203e08:	6462                	ld	s0,24(sp)
    80203e0a:	6105                	addi	sp,sp,32
    80203e0c:	8082                	ret

0000000080203e0e <intr_on>:
    if (!p->parent){
		shutdown();
	}
    
    // 正确设置ZOMBIE状态
    p->state = ZOMBIE;
    80203e0e:	1141                	addi	sp,sp,-16
    80203e10:	e406                	sd	ra,8(sp)
    80203e12:	e022                	sd	s0,0(sp)
    80203e14:	0800                	addi	s0,sp,16
    
    80203e16:	00000097          	auipc	ra,0x0
    80203e1a:	fc4080e7          	jalr	-60(ra) # 80203dda <r_sstatus>
    80203e1e:	87aa                	mv	a5,a0
    80203e20:	0027e793          	ori	a5,a5,2
    80203e24:	853e                	mv	a0,a5
    80203e26:	00000097          	auipc	ra,0x0
    80203e2a:	fce080e7          	jalr	-50(ra) # 80203df4 <w_sstatus>
    // 使用父进程自身地址作为通道标识
    80203e2e:	0001                	nop
    80203e30:	60a2                	ld	ra,8(sp)
    80203e32:	6402                	ld	s0,0(sp)
    80203e34:	0141                	addi	sp,sp,16
    80203e36:	8082                	ret

0000000080203e38 <intr_off>:
    void *chan = (void*)p->parent;
    // 检查父进程是否在使用相同的通道等待
    80203e38:	1141                	addi	sp,sp,-16
    80203e3a:	e406                	sd	ra,8(sp)
    80203e3c:	e022                	sd	s0,0(sp)
    80203e3e:	0800                	addi	s0,sp,16
    if (p->parent->state == SLEEPING && p->parent->chan == chan) {
    80203e40:	00000097          	auipc	ra,0x0
    80203e44:	f9a080e7          	jalr	-102(ra) # 80203dda <r_sstatus>
    80203e48:	87aa                	mv	a5,a0
    80203e4a:	9bf5                	andi	a5,a5,-3
    80203e4c:	853e                	mv	a0,a5
    80203e4e:	00000097          	auipc	ra,0x0
    80203e52:	fa6080e7          	jalr	-90(ra) # 80203df4 <w_sstatus>
        wakeup(chan);
    80203e56:	0001                	nop
    80203e58:	60a2                	ld	ra,8(sp)
    80203e5a:	6402                	ld	s0,0(sp)
    80203e5c:	0141                	addi	sp,sp,16
    80203e5e:	8082                	ret

0000000080203e60 <w_stvec>:
    }
    
    // 在调度前清除当前进程指针，防止该进程再次被调度
    80203e60:	1101                	addi	sp,sp,-32
    80203e62:	ec22                	sd	s0,24(sp)
    80203e64:	1000                	addi	s0,sp,32
    80203e66:	fea43423          	sd	a0,-24(s0)
    current_proc = 0;
    80203e6a:	fe843783          	ld	a5,-24(s0)
    80203e6e:	10579073          	csrw	stvec,a5
    if (mycpu())
    80203e72:	0001                	nop
    80203e74:	6462                	ld	s0,24(sp)
    80203e76:	6105                	addi	sp,sp,32
    80203e78:	8082                	ret

0000000080203e7a <assert>:
        // 检查是否有任何子进程
        int havekids = 0;
        for (int i = 0; i < PROC; i++) {
            struct proc *child = &proc_table[i];
            if (child->state != UNUSED && child->parent == p) {
                havekids = 1;
    80203e7a:	1101                	addi	sp,sp,-32
    80203e7c:	ec06                	sd	ra,24(sp)
    80203e7e:	e822                	sd	s0,16(sp)
    80203e80:	1000                	addi	s0,sp,32
    80203e82:	87aa                	mv	a5,a0
    80203e84:	fef42623          	sw	a5,-20(s0)
            }
    80203e88:	fec42783          	lw	a5,-20(s0)
    80203e8c:	2781                	sext.w	a5,a5
    80203e8e:	e79d                	bnez	a5,80203ebc <assert+0x42>
        }
    80203e90:	1a600613          	li	a2,422
    80203e94:	00004597          	auipc	a1,0x4
    80203e98:	dd458593          	addi	a1,a1,-556 # 80207c68 <small_numbers+0x1818>
    80203e9c:	00004517          	auipc	a0,0x4
    80203ea0:	ddc50513          	addi	a0,a0,-548 # 80207c78 <small_numbers+0x1828>
    80203ea4:	ffffd097          	auipc	ra,0xffffd
    80203ea8:	cb0080e7          	jalr	-848(ra) # 80200b54 <printf>
        
    80203eac:	00004517          	auipc	a0,0x4
    80203eb0:	df450513          	addi	a0,a0,-524 # 80207ca0 <small_numbers+0x1850>
    80203eb4:	ffffd097          	auipc	ra,0xffffd
    80203eb8:	5a8080e7          	jalr	1448(ra) # 8020145c <panic>
        if (!havekids) {
            intr_on();
    80203ebc:	0001                	nop
    80203ebe:	60e2                	ld	ra,24(sp)
    80203ec0:	6442                	ld	s0,16(sp)
    80203ec2:	6105                	addi	sp,sp,32
    80203ec4:	8082                	ret

0000000080203ec6 <shutdown>:
void shutdown() {
    80203ec6:	1141                	addi	sp,sp,-16
    80203ec8:	e406                	sd	ra,8(sp)
    80203eca:	e022                	sd	s0,0(sp)
    80203ecc:	0800                	addi	s0,sp,16
    printf("关机\n");
    80203ece:	00004517          	auipc	a0,0x4
    80203ed2:	dda50513          	addi	a0,a0,-550 # 80207ca8 <small_numbers+0x1858>
    80203ed6:	ffffd097          	auipc	ra,0xffffd
    80203eda:	c7e080e7          	jalr	-898(ra) # 80200b54 <printf>
    asm volatile (
    80203ede:	48a1                	li	a7,8
    80203ee0:	00000073          	ecall
    while (1) { }
    80203ee4:	0001                	nop
    80203ee6:	bffd                	j	80203ee4 <shutdown+0x1e>

0000000080203ee8 <myproc>:
struct proc* myproc(void) {
    80203ee8:	1141                	addi	sp,sp,-16
    80203eea:	e422                	sd	s0,8(sp)
    80203eec:	0800                	addi	s0,sp,16
    return current_proc;
    80203eee:	00006797          	auipc	a5,0x6
    80203ef2:	1a278793          	addi	a5,a5,418 # 8020a090 <current_proc>
    80203ef6:	639c                	ld	a5,0(a5)
}
    80203ef8:	853e                	mv	a0,a5
    80203efa:	6422                	ld	s0,8(sp)
    80203efc:	0141                	addi	sp,sp,16
    80203efe:	8082                	ret

0000000080203f00 <mycpu>:
struct cpu* mycpu(void) {
    80203f00:	1141                	addi	sp,sp,-16
    80203f02:	e406                	sd	ra,8(sp)
    80203f04:	e022                	sd	s0,0(sp)
    80203f06:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80203f08:	00006797          	auipc	a5,0x6
    80203f0c:	19078793          	addi	a5,a5,400 # 8020a098 <current_cpu>
    80203f10:	639c                	ld	a5,0(a5)
    80203f12:	ebb9                	bnez	a5,80203f68 <mycpu+0x68>
        printf("WARNING: current_cpu is NULL, initializing...\n");
    80203f14:	00004517          	auipc	a0,0x4
    80203f18:	d9c50513          	addi	a0,a0,-612 # 80207cb0 <small_numbers+0x1860>
    80203f1c:	ffffd097          	auipc	ra,0xffffd
    80203f20:	c38080e7          	jalr	-968(ra) # 80200b54 <printf>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    80203f24:	07800613          	li	a2,120
    80203f28:	4581                	li	a1,0
    80203f2a:	00008517          	auipc	a0,0x8
    80203f2e:	d9e50513          	addi	a0,a0,-610 # 8020bcc8 <cpu_instance.1>
    80203f32:	ffffe097          	auipc	ra,0xffffe
    80203f36:	bfa080e7          	jalr	-1030(ra) # 80201b2c <memset>
		current_cpu = &cpu_instance;
    80203f3a:	00006797          	auipc	a5,0x6
    80203f3e:	15e78793          	addi	a5,a5,350 # 8020a098 <current_cpu>
    80203f42:	00008717          	auipc	a4,0x8
    80203f46:	d8670713          	addi	a4,a4,-634 # 8020bcc8 <cpu_instance.1>
    80203f4a:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    80203f4c:	00006797          	auipc	a5,0x6
    80203f50:	14c78793          	addi	a5,a5,332 # 8020a098 <current_cpu>
    80203f54:	639c                	ld	a5,0(a5)
    80203f56:	85be                	mv	a1,a5
    80203f58:	00004517          	auipc	a0,0x4
    80203f5c:	d8850513          	addi	a0,a0,-632 # 80207ce0 <small_numbers+0x1890>
    80203f60:	ffffd097          	auipc	ra,0xffffd
    80203f64:	bf4080e7          	jalr	-1036(ra) # 80200b54 <printf>
    return current_cpu;
    80203f68:	00006797          	auipc	a5,0x6
    80203f6c:	13078793          	addi	a5,a5,304 # 8020a098 <current_cpu>
    80203f70:	639c                	ld	a5,0(a5)
}
    80203f72:	853e                	mv	a0,a5
    80203f74:	60a2                	ld	ra,8(sp)
    80203f76:	6402                	ld	s0,0(sp)
    80203f78:	0141                	addi	sp,sp,16
    80203f7a:	8082                	ret

0000000080203f7c <return_to_user>:
void return_to_user(void) {
    80203f7c:	7179                	addi	sp,sp,-48
    80203f7e:	f406                	sd	ra,40(sp)
    80203f80:	f022                	sd	s0,32(sp)
    80203f82:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80203f84:	00000097          	auipc	ra,0x0
    80203f88:	f64080e7          	jalr	-156(ra) # 80203ee8 <myproc>
    80203f8c:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80203f90:	fe843783          	ld	a5,-24(s0)
    80203f94:	eb89                	bnez	a5,80203fa6 <return_to_user+0x2a>
        panic("return_to_user: no current process");
    80203f96:	00004517          	auipc	a0,0x4
    80203f9a:	d6250513          	addi	a0,a0,-670 # 80207cf8 <small_numbers+0x18a8>
    80203f9e:	ffffd097          	auipc	ra,0xffffd
    80203fa2:	4be080e7          	jalr	1214(ra) # 8020145c <panic>
    if (p->chan != 0) {
    80203fa6:	fe843783          	ld	a5,-24(s0)
    80203faa:	73dc                	ld	a5,160(a5)
    80203fac:	c791                	beqz	a5,80203fb8 <return_to_user+0x3c>
        p->chan = 0;  // 清除通道标记
    80203fae:	fe843783          	ld	a5,-24(s0)
    80203fb2:	0a07b023          	sd	zero,160(a5)
        return;  // 直接返回，不做任何状态更改
    80203fb6:	a861                	j	8020404e <return_to_user+0xd2>
    w_stvec(TRAMPOLINE);
    80203fb8:	080007b7          	lui	a5,0x8000
    80203fbc:	17fd                	addi	a5,a5,-1 # 7ffffff <userret+0x7ffff63>
    80203fbe:	00c79513          	slli	a0,a5,0xc
    80203fc2:	00000097          	auipc	ra,0x0
    80203fc6:	e9e080e7          	jalr	-354(ra) # 80203e60 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80203fca:	00000737          	lui	a4,0x0
    80203fce:	09c70713          	addi	a4,a4,156 # 9c <userret>
    80203fd2:	000007b7          	lui	a5,0x0
    80203fd6:	00078793          	mv	a5,a5
    80203fda:	8f1d                	sub	a4,a4,a5
    80203fdc:	080007b7          	lui	a5,0x8000
    80203fe0:	17fd                	addi	a5,a5,-1 # 7ffffff <userret+0x7ffff63>
    80203fe2:	07b2                	slli	a5,a5,0xc
    80203fe4:	97ba                	add	a5,a5,a4
    80203fe6:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    80203fea:	fe843783          	ld	a5,-24(s0)
    80203fee:	7fdc                	ld	a5,184(a5)
    80203ff0:	00c7d713          	srli	a4,a5,0xc
    80203ff4:	57fd                	li	a5,-1
    80203ff6:	17fe                	slli	a5,a5,0x3f
    80203ff8:	8fd9                	or	a5,a5,a4
    80203ffa:	fcf43c23          	sd	a5,-40(s0)
    if (trampoline_userret < TRAMPOLINE || trampoline_userret >= TRAMPOLINE + PGSIZE) {
    80203ffe:	fe043703          	ld	a4,-32(s0)
    80204002:	fefff7b7          	lui	a5,0xfefff
    80204006:	07b6                	slli	a5,a5,0xd
    80204008:	83e5                	srli	a5,a5,0x19
    8020400a:	00e7f863          	bgeu	a5,a4,8020401a <return_to_user+0x9e>
    8020400e:	fe043703          	ld	a4,-32(s0)
    80204012:	57fd                	li	a5,-1
    80204014:	83e5                	srli	a5,a5,0x19
    80204016:	00e7fa63          	bgeu	a5,a4,8020402a <return_to_user+0xae>
        panic("return_to_user: 跳转地址超出trampoline页范围");
    8020401a:	00004517          	auipc	a0,0x4
    8020401e:	d0650513          	addi	a0,a0,-762 # 80207d20 <small_numbers+0x18d0>
    80204022:	ffffd097          	auipc	ra,0xffffd
    80204026:	43a080e7          	jalr	1082(ra) # 8020145c <panic>
    ((void (*)(uint64, uint64))trampoline_userret)(TRAPFRAME, satp);
    8020402a:	fe043783          	ld	a5,-32(s0)
    8020402e:	fd843583          	ld	a1,-40(s0)
    80204032:	04000737          	lui	a4,0x4000
    80204036:	177d                	addi	a4,a4,-1 # 3ffffff <userret+0x3ffff63>
    80204038:	00d71513          	slli	a0,a4,0xd
    8020403c:	9782                	jalr	a5
    panic("return_to_user: 不应该返回到这里");
    8020403e:	00004517          	auipc	a0,0x4
    80204042:	d1a50513          	addi	a0,a0,-742 # 80207d58 <small_numbers+0x1908>
    80204046:	ffffd097          	auipc	ra,0xffffd
    8020404a:	416080e7          	jalr	1046(ra) # 8020145c <panic>
}
    8020404e:	70a2                	ld	ra,40(sp)
    80204050:	7402                	ld	s0,32(sp)
    80204052:	6145                	addi	sp,sp,48
    80204054:	8082                	ret

0000000080204056 <forkret>:
void forkret(void){
    80204056:	7179                	addi	sp,sp,-48
    80204058:	f406                	sd	ra,40(sp)
    8020405a:	f022                	sd	s0,32(sp)
    8020405c:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    8020405e:	00000097          	auipc	ra,0x0
    80204062:	e8a080e7          	jalr	-374(ra) # 80203ee8 <myproc>
    80204066:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    8020406a:	fe843783          	ld	a5,-24(s0)
    8020406e:	eb89                	bnez	a5,80204080 <forkret+0x2a>
        panic("forkret: no current process");
    80204070:	00004517          	auipc	a0,0x4
    80204074:	d1850513          	addi	a0,a0,-744 # 80207d88 <small_numbers+0x1938>
    80204078:	ffffd097          	auipc	ra,0xffffd
    8020407c:	3e4080e7          	jalr	996(ra) # 8020145c <panic>
    if (p->chan != 0) {
    80204080:	fe843783          	ld	a5,-24(s0)
    80204084:	73dc                	ld	a5,160(a5)
    80204086:	c791                	beqz	a5,80204092 <forkret+0x3c>
        p->chan = 0;  // 清除通道标记
    80204088:	fe843783          	ld	a5,-24(s0)
    8020408c:	0a07b023          	sd	zero,160(a5) # fffffffffefff0a0 <_bss_end+0xffffffff7edf3350>
        return;  // 直接返回，继续执行原来的函数
    80204090:	a81d                	j	802040c6 <forkret+0x70>
    uint64 entry = p->trapframe->epc;
    80204092:	fe843783          	ld	a5,-24(s0)
    80204096:	63fc                	ld	a5,192(a5)
    80204098:	6f9c                	ld	a5,24(a5)
    8020409a:	fef43023          	sd	a5,-32(s0)
    if (entry != 0) {
    8020409e:	fe043783          	ld	a5,-32(s0)
    802040a2:	cf91                	beqz	a5,802040be <forkret+0x68>
        void (*fn)(void) = (void(*)(void))entry;
    802040a4:	fe043783          	ld	a5,-32(s0)
    802040a8:	fcf43c23          	sd	a5,-40(s0)
        fn();  // 调用入口函数
    802040ac:	fd843783          	ld	a5,-40(s0)
    802040b0:	9782                	jalr	a5
        exit_proc(0);  // 如果入口函数返回，则退出进程
    802040b2:	4501                	li	a0,0
    802040b4:	00000097          	auipc	ra,0x0
    802040b8:	486080e7          	jalr	1158(ra) # 8020453a <exit_proc>
    802040bc:	a029                	j	802040c6 <forkret+0x70>
        return_to_user();
    802040be:	00000097          	auipc	ra,0x0
    802040c2:	ebe080e7          	jalr	-322(ra) # 80203f7c <return_to_user>
}
    802040c6:	70a2                	ld	ra,40(sp)
    802040c8:	7402                	ld	s0,32(sp)
    802040ca:	6145                	addi	sp,sp,48
    802040cc:	8082                	ret

00000000802040ce <init_proc>:
void init_proc(void){
    802040ce:	7139                	addi	sp,sp,-64
    802040d0:	fc06                	sd	ra,56(sp)
    802040d2:	f822                	sd	s0,48(sp)
    802040d4:	0080                	addi	s0,sp,64
    int corrupted = 0;
    802040d6:	fe042623          	sw	zero,-20(s0)
    for(int i=0; i<PROC; i++){
    802040da:	fe042423          	sw	zero,-24(s0)
    802040de:	a861                	j	80204176 <init_proc+0xa8>
        struct proc *p = &proc_table[i];
    802040e0:	fe842703          	lw	a4,-24(s0)
    802040e4:	0c800793          	li	a5,200
    802040e8:	02f70733          	mul	a4,a4,a5
    802040ec:	00006797          	auipc	a5,0x6
    802040f0:	2d478793          	addi	a5,a5,724 # 8020a3c0 <proc_table>
    802040f4:	97ba                	add	a5,a5,a4
    802040f6:	fcf43423          	sd	a5,-56(s0)
        if (p->state != UNUSED && 
    802040fa:	fc843783          	ld	a5,-56(s0)
    802040fe:	439c                	lw	a5,0(a5)
    80204100:	c7b5                	beqz	a5,8020416c <init_proc+0x9e>
            (p->pid < 0 || p->pid > 1000 || 
    80204102:	fc843783          	ld	a5,-56(s0)
    80204106:	43dc                	lw	a5,4(a5)
        if (p->state != UNUSED && 
    80204108:	0407cd63          	bltz	a5,80204162 <init_proc+0x94>
            (p->pid < 0 || p->pid > 1000 || 
    8020410c:	fc843783          	ld	a5,-56(s0)
    80204110:	43dc                	lw	a5,4(a5)
    80204112:	873e                	mv	a4,a5
    80204114:	3e800793          	li	a5,1000
    80204118:	04e7c563          	blt	a5,a4,80204162 <init_proc+0x94>
             (p->state != USED && p->state != SLEEPING && 
    8020411c:	fc843783          	ld	a5,-56(s0)
    80204120:	439c                	lw	a5,0(a5)
            (p->pid < 0 || p->pid > 1000 || 
    80204122:	873e                	mv	a4,a5
    80204124:	4785                	li	a5,1
    80204126:	04f70363          	beq	a4,a5,8020416c <init_proc+0x9e>
             (p->state != USED && p->state != SLEEPING && 
    8020412a:	fc843783          	ld	a5,-56(s0)
    8020412e:	439c                	lw	a5,0(a5)
    80204130:	873e                	mv	a4,a5
    80204132:	4789                	li	a5,2
    80204134:	02f70c63          	beq	a4,a5,8020416c <init_proc+0x9e>
              p->state != RUNNABLE && p->state != RUNNING && 
    80204138:	fc843783          	ld	a5,-56(s0)
    8020413c:	439c                	lw	a5,0(a5)
             (p->state != USED && p->state != SLEEPING && 
    8020413e:	873e                	mv	a4,a5
    80204140:	478d                	li	a5,3
    80204142:	02f70563          	beq	a4,a5,8020416c <init_proc+0x9e>
              p->state != RUNNABLE && p->state != RUNNING && 
    80204146:	fc843783          	ld	a5,-56(s0)
    8020414a:	439c                	lw	a5,0(a5)
    8020414c:	873e                	mv	a4,a5
    8020414e:	4791                	li	a5,4
    80204150:	00f70e63          	beq	a4,a5,8020416c <init_proc+0x9e>
              p->state != ZOMBIE))) {
    80204154:	fc843783          	ld	a5,-56(s0)
    80204158:	439c                	lw	a5,0(a5)
              p->state != RUNNABLE && p->state != RUNNING && 
    8020415a:	873e                	mv	a4,a5
    8020415c:	4795                	li	a5,5
    8020415e:	00f70763          	beq	a4,a5,8020416c <init_proc+0x9e>
            corrupted++;
    80204162:	fec42783          	lw	a5,-20(s0)
    80204166:	2785                	addiw	a5,a5,1
    80204168:	fef42623          	sw	a5,-20(s0)
    for(int i=0; i<PROC; i++){
    8020416c:	fe842783          	lw	a5,-24(s0)
    80204170:	2785                	addiw	a5,a5,1
    80204172:	fef42423          	sw	a5,-24(s0)
    80204176:	fe842783          	lw	a5,-24(s0)
    8020417a:	0007871b          	sext.w	a4,a5
    8020417e:	47fd                	li	a5,31
    80204180:	f6e7d0e3          	bge	a5,a4,802040e0 <init_proc+0x12>
    for(int i=0; i<PROC; i++){
    80204184:	fe042223          	sw	zero,-28(s0)
    80204188:	a079                	j	80204216 <init_proc+0x148>
        struct proc *p = &proc_table[i];
    8020418a:	fe442703          	lw	a4,-28(s0)
    8020418e:	0c800793          	li	a5,200
    80204192:	02f70733          	mul	a4,a4,a5
    80204196:	00006797          	auipc	a5,0x6
    8020419a:	22a78793          	addi	a5,a5,554 # 8020a3c0 <proc_table>
    8020419e:	97ba                	add	a5,a5,a4
    802041a0:	fcf43823          	sd	a5,-48(s0)
        memset(p, 0, sizeof(struct proc));
    802041a4:	0c800613          	li	a2,200
    802041a8:	4581                	li	a1,0
    802041aa:	fd043503          	ld	a0,-48(s0)
    802041ae:	ffffe097          	auipc	ra,0xffffe
    802041b2:	97e080e7          	jalr	-1666(ra) # 80201b2c <memset>
        p->state = UNUSED;
    802041b6:	fd043783          	ld	a5,-48(s0)
    802041ba:	0007a023          	sw	zero,0(a5)
        p->pid = 0;
    802041be:	fd043783          	ld	a5,-48(s0)
    802041c2:	0007a223          	sw	zero,4(a5)
        p->kstack = 0;
    802041c6:	fd043783          	ld	a5,-48(s0)
    802041ca:	0007b423          	sd	zero,8(a5)
        p->pagetable = 0;
    802041ce:	fd043783          	ld	a5,-48(s0)
    802041d2:	0a07bc23          	sd	zero,184(a5)
        p->trapframe = 0;
    802041d6:	fd043783          	ld	a5,-48(s0)
    802041da:	0c07b023          	sd	zero,192(a5)
        p->parent = 0;
    802041de:	fd043783          	ld	a5,-48(s0)
    802041e2:	0807bc23          	sd	zero,152(a5)
        p->chan = 0;
    802041e6:	fd043783          	ld	a5,-48(s0)
    802041ea:	0a07b023          	sd	zero,160(a5)
        p->exit_status = 0;
    802041ee:	fd043783          	ld	a5,-48(s0)
    802041f2:	0807a223          	sw	zero,132(a5)
        memset(&p->context, 0, sizeof(struct context));
    802041f6:	fd043783          	ld	a5,-48(s0)
    802041fa:	07c1                	addi	a5,a5,16
    802041fc:	07000613          	li	a2,112
    80204200:	4581                	li	a1,0
    80204202:	853e                	mv	a0,a5
    80204204:	ffffe097          	auipc	ra,0xffffe
    80204208:	928080e7          	jalr	-1752(ra) # 80201b2c <memset>
    for(int i=0; i<PROC; i++){
    8020420c:	fe442783          	lw	a5,-28(s0)
    80204210:	2785                	addiw	a5,a5,1
    80204212:	fef42223          	sw	a5,-28(s0)
    80204216:	fe442783          	lw	a5,-28(s0)
    8020421a:	0007871b          	sext.w	a4,a5
    8020421e:	47fd                	li	a5,31
    80204220:	f6e7d5e3          	bge	a5,a4,8020418a <init_proc+0xbc>
    corrupted = 0;
    80204224:	fe042623          	sw	zero,-20(s0)
    for(int i=0; i<PROC; i++){
    80204228:	fe042023          	sw	zero,-32(s0)
    8020422c:	a081                	j	8020426c <init_proc+0x19e>
        struct proc *p = &proc_table[i];
    8020422e:	fe042703          	lw	a4,-32(s0)
    80204232:	0c800793          	li	a5,200
    80204236:	02f70733          	mul	a4,a4,a5
    8020423a:	00006797          	auipc	a5,0x6
    8020423e:	18678793          	addi	a5,a5,390 # 8020a3c0 <proc_table>
    80204242:	97ba                	add	a5,a5,a4
    80204244:	fcf43c23          	sd	a5,-40(s0)
        if (p->state != UNUSED || p->pid != 0) {
    80204248:	fd843783          	ld	a5,-40(s0)
    8020424c:	439c                	lw	a5,0(a5)
    8020424e:	e789                	bnez	a5,80204258 <init_proc+0x18a>
    80204250:	fd843783          	ld	a5,-40(s0)
    80204254:	43dc                	lw	a5,4(a5)
    80204256:	c791                	beqz	a5,80204262 <init_proc+0x194>
            corrupted++;
    80204258:	fec42783          	lw	a5,-20(s0)
    8020425c:	2785                	addiw	a5,a5,1
    8020425e:	fef42623          	sw	a5,-20(s0)
    for(int i=0; i<PROC; i++){
    80204262:	fe042783          	lw	a5,-32(s0)
    80204266:	2785                	addiw	a5,a5,1
    80204268:	fef42023          	sw	a5,-32(s0)
    8020426c:	fe042783          	lw	a5,-32(s0)
    80204270:	0007871b          	sext.w	a4,a5
    80204274:	47fd                	li	a5,31
    80204276:	fae7dce3          	bge	a5,a4,8020422e <init_proc+0x160>
    if (corrupted > 0) {
    8020427a:	fec42783          	lw	a5,-20(s0)
    8020427e:	2781                	sext.w	a5,a5
    80204280:	00f05a63          	blez	a5,80204294 <init_proc+0x1c6>
        panic("进程表初始化失败: 仍有损坏的表项");
    80204284:	00004517          	auipc	a0,0x4
    80204288:	b2450513          	addi	a0,a0,-1244 # 80207da8 <small_numbers+0x1958>
    8020428c:	ffffd097          	auipc	ra,0xffffd
    80204290:	1d0080e7          	jalr	464(ra) # 8020145c <panic>
}
    80204294:	0001                	nop
    80204296:	70e2                	ld	ra,56(sp)
    80204298:	7442                	ld	s0,48(sp)
    8020429a:	6121                	addi	sp,sp,64
    8020429c:	8082                	ret

000000008020429e <alloc_proc>:
struct proc* alloc_proc(void) {
    8020429e:	7179                	addi	sp,sp,-48
    802042a0:	f406                	sd	ra,40(sp)
    802042a2:	f022                	sd	s0,32(sp)
    802042a4:	1800                	addi	s0,sp,48
    for(int i = 0;i<PROC;i++) {
    802042a6:	fe042623          	sw	zero,-20(s0)
    802042aa:	a2b9                	j	802043f8 <alloc_proc+0x15a>
		p = &proc_table[i];
    802042ac:	fec42703          	lw	a4,-20(s0)
    802042b0:	0c800793          	li	a5,200
    802042b4:	02f70733          	mul	a4,a4,a5
    802042b8:	00006797          	auipc	a5,0x6
    802042bc:	10878793          	addi	a5,a5,264 # 8020a3c0 <proc_table>
    802042c0:	97ba                	add	a5,a5,a4
    802042c2:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    802042c6:	fe043783          	ld	a5,-32(s0)
    802042ca:	439c                	lw	a5,0(a5)
    802042cc:	12079163          	bnez	a5,802043ee <alloc_proc+0x150>
            p->pid = i;
    802042d0:	fe043783          	ld	a5,-32(s0)
    802042d4:	fec42703          	lw	a4,-20(s0)
    802042d8:	c3d8                	sw	a4,4(a5)
            p->state = USED;
    802042da:	fe043783          	ld	a5,-32(s0)
    802042de:	4705                	li	a4,1
    802042e0:	c398                	sw	a4,0(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    802042e2:	ffffe097          	auipc	ra,0xffffe
    802042e6:	760080e7          	jalr	1888(ra) # 80202a42 <alloc_page>
    802042ea:	872a                	mv	a4,a0
    802042ec:	fe043783          	ld	a5,-32(s0)
    802042f0:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    802042f2:	fe043783          	ld	a5,-32(s0)
    802042f6:	63fc                	ld	a5,192(a5)
    802042f8:	eb99                	bnez	a5,8020430e <alloc_proc+0x70>
                p->state = UNUSED;
    802042fa:	fe043783          	ld	a5,-32(s0)
    802042fe:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80204302:	fe043783          	ld	a5,-32(s0)
    80204306:	0007a223          	sw	zero,4(a5)
                return 0;
    8020430a:	4781                	li	a5,0
    8020430c:	a8f5                	j	80204408 <alloc_proc+0x16a>
            p->pagetable = create_pagetable();
    8020430e:	ffffe097          	auipc	ra,0xffffe
    80204312:	a16080e7          	jalr	-1514(ra) # 80201d24 <create_pagetable>
    80204316:	872a                	mv	a4,a0
    80204318:	fe043783          	ld	a5,-32(s0)
    8020431c:	ffd8                	sd	a4,184(a5)
            if(p->pagetable == 0){
    8020431e:	fe043783          	ld	a5,-32(s0)
    80204322:	7fdc                	ld	a5,184(a5)
    80204324:	e79d                	bnez	a5,80204352 <alloc_proc+0xb4>
                free_page(p->trapframe);
    80204326:	fe043783          	ld	a5,-32(s0)
    8020432a:	63fc                	ld	a5,192(a5)
    8020432c:	853e                	mv	a0,a5
    8020432e:	ffffe097          	auipc	ra,0xffffe
    80204332:	780080e7          	jalr	1920(ra) # 80202aae <free_page>
                p->trapframe = 0;
    80204336:	fe043783          	ld	a5,-32(s0)
    8020433a:	0c07b023          	sd	zero,192(a5)
                p->state = UNUSED;
    8020433e:	fe043783          	ld	a5,-32(s0)
    80204342:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80204346:	fe043783          	ld	a5,-32(s0)
    8020434a:	0007a223          	sw	zero,4(a5)
                return 0;
    8020434e:	4781                	li	a5,0
    80204350:	a865                	j	80204408 <alloc_proc+0x16a>
            void *kstack_mem = alloc_page();
    80204352:	ffffe097          	auipc	ra,0xffffe
    80204356:	6f0080e7          	jalr	1776(ra) # 80202a42 <alloc_page>
    8020435a:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    8020435e:	fd843783          	ld	a5,-40(s0)
    80204362:	e3b9                	bnez	a5,802043a8 <alloc_proc+0x10a>
                free_page(p->trapframe);
    80204364:	fe043783          	ld	a5,-32(s0)
    80204368:	63fc                	ld	a5,192(a5)
    8020436a:	853e                	mv	a0,a5
    8020436c:	ffffe097          	auipc	ra,0xffffe
    80204370:	742080e7          	jalr	1858(ra) # 80202aae <free_page>
                free_pagetable(p->pagetable);
    80204374:	fe043783          	ld	a5,-32(s0)
    80204378:	7fdc                	ld	a5,184(a5)
    8020437a:	853e                	mv	a0,a5
    8020437c:	ffffe097          	auipc	ra,0xffffe
    80204380:	c56080e7          	jalr	-938(ra) # 80201fd2 <free_pagetable>
                p->trapframe = 0;
    80204384:	fe043783          	ld	a5,-32(s0)
    80204388:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    8020438c:	fe043783          	ld	a5,-32(s0)
    80204390:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    80204394:	fe043783          	ld	a5,-32(s0)
    80204398:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    8020439c:	fe043783          	ld	a5,-32(s0)
    802043a0:	0007a223          	sw	zero,4(a5)
                return 0;
    802043a4:	4781                	li	a5,0
    802043a6:	a08d                	j	80204408 <alloc_proc+0x16a>
            p->kstack = (uint64)kstack_mem;
    802043a8:	fd843703          	ld	a4,-40(s0)
    802043ac:	fe043783          	ld	a5,-32(s0)
    802043b0:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    802043b2:	fe043783          	ld	a5,-32(s0)
    802043b6:	07c1                	addi	a5,a5,16
    802043b8:	07000613          	li	a2,112
    802043bc:	4581                	li	a1,0
    802043be:	853e                	mv	a0,a5
    802043c0:	ffffd097          	auipc	ra,0xffffd
    802043c4:	76c080e7          	jalr	1900(ra) # 80201b2c <memset>
            p->context.ra = (uint64)forkret;
    802043c8:	00000717          	auipc	a4,0x0
    802043cc:	c8e70713          	addi	a4,a4,-882 # 80204056 <forkret>
    802043d0:	fe043783          	ld	a5,-32(s0)
    802043d4:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    802043d6:	fe043783          	ld	a5,-32(s0)
    802043da:	6798                	ld	a4,8(a5)
    802043dc:	6785                	lui	a5,0x1
    802043de:	17c1                	addi	a5,a5,-16 # ff0 <userret+0xf54>
    802043e0:	973e                	add	a4,a4,a5
    802043e2:	fe043783          	ld	a5,-32(s0)
    802043e6:	ef98                	sd	a4,24(a5)
            return p;
    802043e8:	fe043783          	ld	a5,-32(s0)
    802043ec:	a831                	j	80204408 <alloc_proc+0x16a>
    for(int i = 0;i<PROC;i++) {
    802043ee:	fec42783          	lw	a5,-20(s0)
    802043f2:	2785                	addiw	a5,a5,1
    802043f4:	fef42623          	sw	a5,-20(s0)
    802043f8:	fec42783          	lw	a5,-20(s0)
    802043fc:	0007871b          	sext.w	a4,a5
    80204400:	47fd                	li	a5,31
    80204402:	eae7d5e3          	bge	a5,a4,802042ac <alloc_proc+0xe>
    return 0;
    80204406:	4781                	li	a5,0
}
    80204408:	853e                	mv	a0,a5
    8020440a:	70a2                	ld	ra,40(sp)
    8020440c:	7402                	ld	s0,32(sp)
    8020440e:	6145                	addi	sp,sp,48
    80204410:	8082                	ret

0000000080204412 <free_proc>:
void free_proc(struct proc *p){
    80204412:	1101                	addi	sp,sp,-32
    80204414:	ec06                	sd	ra,24(sp)
    80204416:	e822                	sd	s0,16(sp)
    80204418:	1000                	addi	s0,sp,32
    8020441a:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    8020441e:	fe843783          	ld	a5,-24(s0)
    80204422:	63fc                	ld	a5,192(a5)
    80204424:	cb89                	beqz	a5,80204436 <free_proc+0x24>
        free_page(p->trapframe);
    80204426:	fe843783          	ld	a5,-24(s0)
    8020442a:	63fc                	ld	a5,192(a5)
    8020442c:	853e                	mv	a0,a5
    8020442e:	ffffe097          	auipc	ra,0xffffe
    80204432:	680080e7          	jalr	1664(ra) # 80202aae <free_page>
    p->trapframe = 0;
    80204436:	fe843783          	ld	a5,-24(s0)
    8020443a:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable)
    8020443e:	fe843783          	ld	a5,-24(s0)
    80204442:	7fdc                	ld	a5,184(a5)
    80204444:	cb89                	beqz	a5,80204456 <free_proc+0x44>
        free_pagetable(p->pagetable);
    80204446:	fe843783          	ld	a5,-24(s0)
    8020444a:	7fdc                	ld	a5,184(a5)
    8020444c:	853e                	mv	a0,a5
    8020444e:	ffffe097          	auipc	ra,0xffffe
    80204452:	b84080e7          	jalr	-1148(ra) # 80201fd2 <free_pagetable>
    p->pagetable = 0;
    80204456:	fe843783          	ld	a5,-24(s0)
    8020445a:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    8020445e:	fe843783          	ld	a5,-24(s0)
    80204462:	679c                	ld	a5,8(a5)
    80204464:	cb89                	beqz	a5,80204476 <free_proc+0x64>
        free_page((void*)p->kstack);
    80204466:	fe843783          	ld	a5,-24(s0)
    8020446a:	679c                	ld	a5,8(a5)
    8020446c:	853e                	mv	a0,a5
    8020446e:	ffffe097          	auipc	ra,0xffffe
    80204472:	640080e7          	jalr	1600(ra) # 80202aae <free_page>
    p->kstack = 0;
    80204476:	fe843783          	ld	a5,-24(s0)
    8020447a:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    8020447e:	fe843783          	ld	a5,-24(s0)
    80204482:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    80204486:	fe843783          	ld	a5,-24(s0)
    8020448a:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    8020448e:	fe843783          	ld	a5,-24(s0)
    80204492:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    80204496:	fe843783          	ld	a5,-24(s0)
    8020449a:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    8020449e:	fe843783          	ld	a5,-24(s0)
    802044a2:	07c1                	addi	a5,a5,16
    802044a4:	07000613          	li	a2,112
    802044a8:	4581                	li	a1,0
    802044aa:	853e                	mv	a0,a5
    802044ac:	ffffd097          	auipc	ra,0xffffd
    802044b0:	680080e7          	jalr	1664(ra) # 80201b2c <memset>
}
    802044b4:	0001                	nop
    802044b6:	60e2                	ld	ra,24(sp)
    802044b8:	6442                	ld	s0,16(sp)
    802044ba:	6105                	addi	sp,sp,32
    802044bc:	8082                	ret

00000000802044be <create_proc>:
int create_proc(void (*entry)(void)) {
    802044be:	7179                	addi	sp,sp,-48
    802044c0:	f406                	sd	ra,40(sp)
    802044c2:	f022                	sd	s0,32(sp)
    802044c4:	1800                	addi	s0,sp,48
    802044c6:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc();
    802044ca:	00000097          	auipc	ra,0x0
    802044ce:	dd4080e7          	jalr	-556(ra) # 8020429e <alloc_proc>
    802044d2:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    802044d6:	fe843783          	ld	a5,-24(s0)
    802044da:	e399                	bnez	a5,802044e0 <create_proc+0x22>
    802044dc:	57fd                	li	a5,-1
    802044de:	a889                	j	80204530 <create_proc+0x72>
    p->trapframe->epc = (uint64)entry;
    802044e0:	fe843783          	ld	a5,-24(s0)
    802044e4:	63fc                	ld	a5,192(a5)
    802044e6:	fd843703          	ld	a4,-40(s0)
    802044ea:	ef98                	sd	a4,24(a5)
    p->state = RUNNABLE;
    802044ec:	fe843783          	ld	a5,-24(s0)
    802044f0:	470d                	li	a4,3
    802044f2:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    802044f4:	00000097          	auipc	ra,0x0
    802044f8:	9f4080e7          	jalr	-1548(ra) # 80203ee8 <myproc>
    802044fc:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    80204500:	fe043783          	ld	a5,-32(s0)
    80204504:	c799                	beqz	a5,80204512 <create_proc+0x54>
        p->parent = parent;
    80204506:	fe843783          	ld	a5,-24(s0)
    8020450a:	fe043703          	ld	a4,-32(s0)
    8020450e:	efd8                	sd	a4,152(a5)
    80204510:	a829                	j	8020452a <create_proc+0x6c>
		printf("Warning: Set parent to NULL\n");
    80204512:	00004517          	auipc	a0,0x4
    80204516:	8c650513          	addi	a0,a0,-1850 # 80207dd8 <small_numbers+0x1988>
    8020451a:	ffffc097          	auipc	ra,0xffffc
    8020451e:	63a080e7          	jalr	1594(ra) # 80200b54 <printf>
        p->parent = NULL;
    80204522:	fe843783          	ld	a5,-24(s0)
    80204526:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    8020452a:	fe843783          	ld	a5,-24(s0)
    8020452e:	43dc                	lw	a5,4(a5)
}
    80204530:	853e                	mv	a0,a5
    80204532:	70a2                	ld	ra,40(sp)
    80204534:	7402                	ld	s0,32(sp)
    80204536:	6145                	addi	sp,sp,48
    80204538:	8082                	ret

000000008020453a <exit_proc>:
void exit_proc(int status) {
    8020453a:	7179                	addi	sp,sp,-48
    8020453c:	f406                	sd	ra,40(sp)
    8020453e:	f022                	sd	s0,32(sp)
    80204540:	1800                	addi	s0,sp,48
    80204542:	87aa                	mv	a5,a0
    80204544:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    80204548:	00000097          	auipc	ra,0x0
    8020454c:	9a0080e7          	jalr	-1632(ra) # 80203ee8 <myproc>
    80204550:	fea43423          	sd	a0,-24(s0)
    p->exit_status = status;
    80204554:	fe843783          	ld	a5,-24(s0)
    80204558:	fdc42703          	lw	a4,-36(s0)
    8020455c:	08e7a223          	sw	a4,132(a5)
    kexit();
    80204560:	00000097          	auipc	ra,0x0
    80204564:	378080e7          	jalr	888(ra) # 802048d8 <kexit>
}
    80204568:	0001                	nop
    8020456a:	70a2                	ld	ra,40(sp)
    8020456c:	7402                	ld	s0,32(sp)
    8020456e:	6145                	addi	sp,sp,48
    80204570:	8082                	ret

0000000080204572 <wait_proc>:
int wait_proc(int *status) {
    80204572:	1101                	addi	sp,sp,-32
    80204574:	ec06                	sd	ra,24(sp)
    80204576:	e822                	sd	s0,16(sp)
    80204578:	1000                	addi	s0,sp,32
    8020457a:	fea43423          	sd	a0,-24(s0)
    return kwait(status);
    8020457e:	fe843503          	ld	a0,-24(s0)
    80204582:	00000097          	auipc	ra,0x0
    80204586:	416080e7          	jalr	1046(ra) # 80204998 <kwait>
    8020458a:	87aa                	mv	a5,a0
}
    8020458c:	853e                	mv	a0,a5
    8020458e:	60e2                	ld	ra,24(sp)
    80204590:	6442                	ld	s0,16(sp)
    80204592:	6105                	addi	sp,sp,32
    80204594:	8082                	ret

0000000080204596 <kfork>:
int kfork(void) {
    80204596:	1101                	addi	sp,sp,-32
    80204598:	ec06                	sd	ra,24(sp)
    8020459a:	e822                	sd	s0,16(sp)
    8020459c:	1000                	addi	s0,sp,32
    struct proc *parent = myproc();
    8020459e:	00000097          	auipc	ra,0x0
    802045a2:	94a080e7          	jalr	-1718(ra) # 80203ee8 <myproc>
    802045a6:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc();
    802045aa:	00000097          	auipc	ra,0x0
    802045ae:	cf4080e7          	jalr	-780(ra) # 8020429e <alloc_proc>
    802045b2:	fea43023          	sd	a0,-32(s0)
    if(child == 0)
    802045b6:	fe043783          	ld	a5,-32(s0)
    802045ba:	e399                	bnez	a5,802045c0 <kfork+0x2a>
        return -1;
    802045bc:	57fd                	li	a5,-1
    802045be:	a059                	j	80204644 <kfork+0xae>
    if(uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0){
    802045c0:	fe843783          	ld	a5,-24(s0)
    802045c4:	7fd8                	ld	a4,184(a5)
    802045c6:	fe043783          	ld	a5,-32(s0)
    802045ca:	7fd4                	ld	a3,184(a5)
    802045cc:	fe843783          	ld	a5,-24(s0)
    802045d0:	7bdc                	ld	a5,176(a5)
    802045d2:	863e                	mv	a2,a5
    802045d4:	85b6                	mv	a1,a3
    802045d6:	853a                	mv	a0,a4
    802045d8:	ffffe097          	auipc	ra,0xffffe
    802045dc:	2c2080e7          	jalr	706(ra) # 8020289a <uvmcopy>
    802045e0:	87aa                	mv	a5,a0
    802045e2:	0007da63          	bgez	a5,802045f6 <kfork+0x60>
        free_proc(child);
    802045e6:	fe043503          	ld	a0,-32(s0)
    802045ea:	00000097          	auipc	ra,0x0
    802045ee:	e28080e7          	jalr	-472(ra) # 80204412 <free_proc>
        return -1;
    802045f2:	57fd                	li	a5,-1
    802045f4:	a881                	j	80204644 <kfork+0xae>
    child->sz = parent->sz;
    802045f6:	fe843783          	ld	a5,-24(s0)
    802045fa:	7bd8                	ld	a4,176(a5)
    802045fc:	fe043783          	ld	a5,-32(s0)
    80204600:	fbd8                	sd	a4,176(a5)
    *(child->trapframe) = *(parent->trapframe);
    80204602:	fe843783          	ld	a5,-24(s0)
    80204606:	63f8                	ld	a4,192(a5)
    80204608:	fe043783          	ld	a5,-32(s0)
    8020460c:	63fc                	ld	a5,192(a5)
    8020460e:	86be                	mv	a3,a5
    80204610:	12000793          	li	a5,288
    80204614:	863e                	mv	a2,a5
    80204616:	85ba                	mv	a1,a4
    80204618:	8536                	mv	a0,a3
    8020461a:	ffffd097          	auipc	ra,0xffffd
    8020461e:	61e080e7          	jalr	1566(ra) # 80201c38 <memcpy>
    child->trapframe->a0 = 0; // 子进程fork返回值为0
    80204622:	fe043783          	ld	a5,-32(s0)
    80204626:	63fc                	ld	a5,192(a5)
    80204628:	0607b823          	sd	zero,112(a5)
    child->state = RUNNABLE;
    8020462c:	fe043783          	ld	a5,-32(s0)
    80204630:	470d                	li	a4,3
    80204632:	c398                	sw	a4,0(a5)
    child->parent = parent;
    80204634:	fe043783          	ld	a5,-32(s0)
    80204638:	fe843703          	ld	a4,-24(s0)
    8020463c:	efd8                	sd	a4,152(a5)
    return child->pid;
    8020463e:	fe043783          	ld	a5,-32(s0)
    80204642:	43dc                	lw	a5,4(a5)
}
    80204644:	853e                	mv	a0,a5
    80204646:	60e2                	ld	ra,24(sp)
    80204648:	6442                	ld	s0,16(sp)
    8020464a:	6105                	addi	sp,sp,32
    8020464c:	8082                	ret

000000008020464e <schedule>:
void schedule(void) {
    8020464e:	1101                	addi	sp,sp,-32
    80204650:	ec06                	sd	ra,24(sp)
    80204652:	e822                	sd	s0,16(sp)
    80204654:	1000                	addi	s0,sp,32
  struct cpu *c = mycpu();
    80204656:	00000097          	auipc	ra,0x0
    8020465a:	8aa080e7          	jalr	-1878(ra) # 80203f00 <mycpu>
    8020465e:	fea43023          	sd	a0,-32(s0)
  if (!initialized) {
    80204662:	00007797          	auipc	a5,0x7
    80204666:	6de78793          	addi	a5,a5,1758 # 8020bd40 <initialized.0>
    8020466a:	439c                	lw	a5,0(a5)
    8020466c:	ef85                	bnez	a5,802046a4 <schedule+0x56>
    if(c == 0) {
    8020466e:	fe043783          	ld	a5,-32(s0)
    80204672:	eb89                	bnez	a5,80204684 <schedule+0x36>
      panic("schedule: no current cpu");
    80204674:	00003517          	auipc	a0,0x3
    80204678:	78450513          	addi	a0,a0,1924 # 80207df8 <small_numbers+0x19a8>
    8020467c:	ffffd097          	auipc	ra,0xffffd
    80204680:	de0080e7          	jalr	-544(ra) # 8020145c <panic>
    c->proc = 0;
    80204684:	fe043783          	ld	a5,-32(s0)
    80204688:	0007b023          	sd	zero,0(a5)
    current_proc = 0;
    8020468c:	00006797          	auipc	a5,0x6
    80204690:	a0478793          	addi	a5,a5,-1532 # 8020a090 <current_proc>
    80204694:	0007b023          	sd	zero,0(a5)
    initialized = 1;
    80204698:	00007797          	auipc	a5,0x7
    8020469c:	6a878793          	addi	a5,a5,1704 # 8020bd40 <initialized.0>
    802046a0:	4705                	li	a4,1
    802046a2:	c398                	sw	a4,0(a5)
    intr_on();
    802046a4:	fffff097          	auipc	ra,0xfffff
    802046a8:	76a080e7          	jalr	1898(ra) # 80203e0e <intr_on>
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    802046ac:	00006797          	auipc	a5,0x6
    802046b0:	d1478793          	addi	a5,a5,-748 # 8020a3c0 <proc_table>
    802046b4:	fef43423          	sd	a5,-24(s0)
    802046b8:	a89d                	j	8020472e <schedule+0xe0>
      if(p->state == RUNNABLE) {
    802046ba:	fe843783          	ld	a5,-24(s0)
    802046be:	439c                	lw	a5,0(a5)
    802046c0:	873e                	mv	a4,a5
    802046c2:	478d                	li	a5,3
    802046c4:	04f71f63          	bne	a4,a5,80204722 <schedule+0xd4>
        p->state = RUNNING;
    802046c8:	fe843783          	ld	a5,-24(s0)
    802046cc:	4711                	li	a4,4
    802046ce:	c398                	sw	a4,0(a5)
        c->proc = p;
    802046d0:	fe043783          	ld	a5,-32(s0)
    802046d4:	fe843703          	ld	a4,-24(s0)
    802046d8:	e398                	sd	a4,0(a5)
        current_proc = p;
    802046da:	00006797          	auipc	a5,0x6
    802046de:	9b678793          	addi	a5,a5,-1610 # 8020a090 <current_proc>
    802046e2:	fe843703          	ld	a4,-24(s0)
    802046e6:	e398                	sd	a4,0(a5)
		swtch(&c->context, &p->context);
    802046e8:	fe043783          	ld	a5,-32(s0)
    802046ec:	00878713          	addi	a4,a5,8
    802046f0:	fe843783          	ld	a5,-24(s0)
    802046f4:	07c1                	addi	a5,a5,16
    802046f6:	85be                	mv	a1,a5
    802046f8:	853a                	mv	a0,a4
    802046fa:	fffff097          	auipc	ra,0xfffff
    802046fe:	676080e7          	jalr	1654(ra) # 80203d70 <swtch>
		c = mycpu();
    80204702:	fffff097          	auipc	ra,0xfffff
    80204706:	7fe080e7          	jalr	2046(ra) # 80203f00 <mycpu>
    8020470a:	fea43023          	sd	a0,-32(s0)
        c->proc = 0;
    8020470e:	fe043783          	ld	a5,-32(s0)
    80204712:	0007b023          	sd	zero,0(a5)
        current_proc = 0;
    80204716:	00006797          	auipc	a5,0x6
    8020471a:	97a78793          	addi	a5,a5,-1670 # 8020a090 <current_proc>
    8020471e:	0007b023          	sd	zero,0(a5)
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    80204722:	fe843783          	ld	a5,-24(s0)
    80204726:	0c878793          	addi	a5,a5,200
    8020472a:	fef43423          	sd	a5,-24(s0)
    8020472e:	fe843703          	ld	a4,-24(s0)
    80204732:	00007797          	auipc	a5,0x7
    80204736:	58e78793          	addi	a5,a5,1422 # 8020bcc0 <proc_buffer>
    8020473a:	f8f760e3          	bltu	a4,a5,802046ba <schedule+0x6c>
    intr_on();
    8020473e:	b79d                	j	802046a4 <schedule+0x56>

0000000080204740 <yield>:
void yield(void) {
    80204740:	1101                	addi	sp,sp,-32
    80204742:	ec06                	sd	ra,24(sp)
    80204744:	e822                	sd	s0,16(sp)
    80204746:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80204748:	fffff097          	auipc	ra,0xfffff
    8020474c:	7a0080e7          	jalr	1952(ra) # 80203ee8 <myproc>
    80204750:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80204754:	fe843783          	ld	a5,-24(s0)
    80204758:	c7cd                	beqz	a5,80204802 <yield+0xc2>
    if (p->state != RUNNING) {
    8020475a:	fe843783          	ld	a5,-24(s0)
    8020475e:	439c                	lw	a5,0(a5)
    80204760:	873e                	mv	a4,a5
    80204762:	4791                	li	a5,4
    80204764:	00f70f63          	beq	a4,a5,80204782 <yield+0x42>
        printf("Warining: yield when status is not RUNNING (%d)\n", p->state);
    80204768:	fe843783          	ld	a5,-24(s0)
    8020476c:	439c                	lw	a5,0(a5)
    8020476e:	85be                	mv	a1,a5
    80204770:	00003517          	auipc	a0,0x3
    80204774:	6a850513          	addi	a0,a0,1704 # 80207e18 <small_numbers+0x19c8>
    80204778:	ffffc097          	auipc	ra,0xffffc
    8020477c:	3dc080e7          	jalr	988(ra) # 80200b54 <printf>
        return;
    80204780:	a051                	j	80204804 <yield+0xc4>
    intr_off();
    80204782:	fffff097          	auipc	ra,0xfffff
    80204786:	6b6080e7          	jalr	1718(ra) # 80203e38 <intr_off>
    struct cpu *c = mycpu();
    8020478a:	fffff097          	auipc	ra,0xfffff
    8020478e:	776080e7          	jalr	1910(ra) # 80203f00 <mycpu>
    80204792:	fea43023          	sd	a0,-32(s0)
    p->state = RUNNABLE;
    80204796:	fe843783          	ld	a5,-24(s0)
    8020479a:	470d                	li	a4,3
    8020479c:	c398                	sw	a4,0(a5)
    p->context.ra = ra;
    8020479e:	8706                	mv	a4,ra
    802047a0:	fe843783          	ld	a5,-24(s0)
    802047a4:	eb98                	sd	a4,16(a5)
    if (c->context.ra == 0) {
    802047a6:	fe043783          	ld	a5,-32(s0)
    802047aa:	679c                	ld	a5,8(a5)
    802047ac:	ef99                	bnez	a5,802047ca <yield+0x8a>
        c->context.ra = (uint64)schedule;
    802047ae:	00000717          	auipc	a4,0x0
    802047b2:	ea070713          	addi	a4,a4,-352 # 8020464e <schedule>
    802047b6:	fe043783          	ld	a5,-32(s0)
    802047ba:	e798                	sd	a4,8(a5)
        c->context.sp = (uint64)c + PGSIZE;
    802047bc:	fe043703          	ld	a4,-32(s0)
    802047c0:	6785                	lui	a5,0x1
    802047c2:	973e                	add	a4,a4,a5
    802047c4:	fe043783          	ld	a5,-32(s0)
    802047c8:	eb98                	sd	a4,16(a5)
    current_proc = 0;
    802047ca:	00006797          	auipc	a5,0x6
    802047ce:	8c678793          	addi	a5,a5,-1850 # 8020a090 <current_proc>
    802047d2:	0007b023          	sd	zero,0(a5)
    c->proc = 0;
    802047d6:	fe043783          	ld	a5,-32(s0)
    802047da:	0007b023          	sd	zero,0(a5)
    swtch(&p->context, &c->context);
    802047de:	fe843783          	ld	a5,-24(s0)
    802047e2:	01078713          	addi	a4,a5,16
    802047e6:	fe043783          	ld	a5,-32(s0)
    802047ea:	07a1                	addi	a5,a5,8
    802047ec:	85be                	mv	a1,a5
    802047ee:	853a                	mv	a0,a4
    802047f0:	fffff097          	auipc	ra,0xfffff
    802047f4:	580080e7          	jalr	1408(ra) # 80203d70 <swtch>
    intr_on();
    802047f8:	fffff097          	auipc	ra,0xfffff
    802047fc:	616080e7          	jalr	1558(ra) # 80203e0e <intr_on>
    80204800:	a011                	j	80204804 <yield+0xc4>
        return;
    80204802:	0001                	nop
}
    80204804:	60e2                	ld	ra,24(sp)
    80204806:	6442                	ld	s0,16(sp)
    80204808:	6105                	addi	sp,sp,32
    8020480a:	8082                	ret

000000008020480c <sleep>:
void sleep(void *chan){
    8020480c:	7179                	addi	sp,sp,-48
    8020480e:	f406                	sd	ra,40(sp)
    80204810:	f022                	sd	s0,32(sp)
    80204812:	1800                	addi	s0,sp,48
    80204814:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = myproc();
    80204818:	fffff097          	auipc	ra,0xfffff
    8020481c:	6d0080e7          	jalr	1744(ra) # 80203ee8 <myproc>
    80204820:	fea43423          	sd	a0,-24(s0)
    struct cpu *c = mycpu();
    80204824:	fffff097          	auipc	ra,0xfffff
    80204828:	6dc080e7          	jalr	1756(ra) # 80203f00 <mycpu>
    8020482c:	fea43023          	sd	a0,-32(s0)
    p->context.ra = ra;
    80204830:	8706                	mv	a4,ra
    80204832:	fe843783          	ld	a5,-24(s0)
    80204836:	eb98                	sd	a4,16(a5)
    p->chan = chan;
    80204838:	fe843783          	ld	a5,-24(s0)
    8020483c:	fd843703          	ld	a4,-40(s0)
    80204840:	f3d8                	sd	a4,160(a5)
    p->state = SLEEPING;
    80204842:	fe843783          	ld	a5,-24(s0)
    80204846:	4709                	li	a4,2
    80204848:	c398                	sw	a4,0(a5)
    swtch(&p->context, &c->context);
    8020484a:	fe843783          	ld	a5,-24(s0)
    8020484e:	01078713          	addi	a4,a5,16
    80204852:	fe043783          	ld	a5,-32(s0)
    80204856:	07a1                	addi	a5,a5,8
    80204858:	85be                	mv	a1,a5
    8020485a:	853a                	mv	a0,a4
    8020485c:	fffff097          	auipc	ra,0xfffff
    80204860:	514080e7          	jalr	1300(ra) # 80203d70 <swtch>
    p->chan = 0;  // 显式清除通道标记
    80204864:	fe843783          	ld	a5,-24(s0)
    80204868:	0a07b023          	sd	zero,160(a5)
}
    8020486c:	0001                	nop
    8020486e:	70a2                	ld	ra,40(sp)
    80204870:	7402                	ld	s0,32(sp)
    80204872:	6145                	addi	sp,sp,48
    80204874:	8082                	ret

0000000080204876 <wakeup>:
{
    80204876:	7179                	addi	sp,sp,-48
    80204878:	f422                	sd	s0,40(sp)
    8020487a:	1800                	addi	s0,sp,48
    8020487c:	fca43c23          	sd	a0,-40(s0)
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    80204880:	00006797          	auipc	a5,0x6
    80204884:	b4078793          	addi	a5,a5,-1216 # 8020a3c0 <proc_table>
    80204888:	fef43423          	sd	a5,-24(s0)
    8020488c:	a80d                	j	802048be <wakeup+0x48>
        if(p->state == SLEEPING && p->chan == chan) {
    8020488e:	fe843783          	ld	a5,-24(s0)
    80204892:	439c                	lw	a5,0(a5)
    80204894:	873e                	mv	a4,a5
    80204896:	4789                	li	a5,2
    80204898:	00f71d63          	bne	a4,a5,802048b2 <wakeup+0x3c>
    8020489c:	fe843783          	ld	a5,-24(s0)
    802048a0:	73dc                	ld	a5,160(a5)
    802048a2:	fd843703          	ld	a4,-40(s0)
    802048a6:	00f71663          	bne	a4,a5,802048b2 <wakeup+0x3c>
            p->state = RUNNABLE;
    802048aa:	fe843783          	ld	a5,-24(s0)
    802048ae:	470d                	li	a4,3
    802048b0:	c398                	sw	a4,0(a5)
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    802048b2:	fe843783          	ld	a5,-24(s0)
    802048b6:	0c878793          	addi	a5,a5,200
    802048ba:	fef43423          	sd	a5,-24(s0)
    802048be:	fe843703          	ld	a4,-24(s0)
    802048c2:	00007797          	auipc	a5,0x7
    802048c6:	3fe78793          	addi	a5,a5,1022 # 8020bcc0 <proc_buffer>
    802048ca:	fcf762e3          	bltu	a4,a5,8020488e <wakeup+0x18>
}
    802048ce:	0001                	nop
    802048d0:	0001                	nop
    802048d2:	7422                	ld	s0,40(sp)
    802048d4:	6145                	addi	sp,sp,48
    802048d6:	8082                	ret

00000000802048d8 <kexit>:
void kexit() {
    802048d8:	1101                	addi	sp,sp,-32
    802048da:	ec06                	sd	ra,24(sp)
    802048dc:	e822                	sd	s0,16(sp)
    802048de:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    802048e0:	fffff097          	auipc	ra,0xfffff
    802048e4:	608080e7          	jalr	1544(ra) # 80203ee8 <myproc>
    802048e8:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    802048ec:	fe843783          	ld	a5,-24(s0)
    802048f0:	eb89                	bnez	a5,80204902 <kexit+0x2a>
        panic("kexit: no current process");
    802048f2:	00003517          	auipc	a0,0x3
    802048f6:	55e50513          	addi	a0,a0,1374 # 80207e50 <small_numbers+0x1a00>
    802048fa:	ffffd097          	auipc	ra,0xffffd
    802048fe:	b62080e7          	jalr	-1182(ra) # 8020145c <panic>
    if (!p->parent){
    80204902:	fe843783          	ld	a5,-24(s0)
    80204906:	6fdc                	ld	a5,152(a5)
    80204908:	e789                	bnez	a5,80204912 <kexit+0x3a>
		shutdown();
    8020490a:	fffff097          	auipc	ra,0xfffff
    8020490e:	5bc080e7          	jalr	1468(ra) # 80203ec6 <shutdown>
    p->state = ZOMBIE;
    80204912:	fe843783          	ld	a5,-24(s0)
    80204916:	4715                	li	a4,5
    80204918:	c398                	sw	a4,0(a5)
    void *chan = (void*)p->parent;
    8020491a:	fe843783          	ld	a5,-24(s0)
    8020491e:	6fdc                	ld	a5,152(a5)
    80204920:	fef43023          	sd	a5,-32(s0)
    if (p->parent->state == SLEEPING && p->parent->chan == chan) {
    80204924:	fe843783          	ld	a5,-24(s0)
    80204928:	6fdc                	ld	a5,152(a5)
    8020492a:	439c                	lw	a5,0(a5)
    8020492c:	873e                	mv	a4,a5
    8020492e:	4789                	li	a5,2
    80204930:	02f71063          	bne	a4,a5,80204950 <kexit+0x78>
    80204934:	fe843783          	ld	a5,-24(s0)
    80204938:	6fdc                	ld	a5,152(a5)
    8020493a:	73dc                	ld	a5,160(a5)
    8020493c:	fe043703          	ld	a4,-32(s0)
    80204940:	00f71863          	bne	a4,a5,80204950 <kexit+0x78>
        wakeup(chan);
    80204944:	fe043503          	ld	a0,-32(s0)
    80204948:	00000097          	auipc	ra,0x0
    8020494c:	f2e080e7          	jalr	-210(ra) # 80204876 <wakeup>
    current_proc = 0;
    80204950:	00005797          	auipc	a5,0x5
    80204954:	74078793          	addi	a5,a5,1856 # 8020a090 <current_proc>
    80204958:	0007b023          	sd	zero,0(a5)
    if (mycpu())
    8020495c:	fffff097          	auipc	ra,0xfffff
    80204960:	5a4080e7          	jalr	1444(ra) # 80203f00 <mycpu>
    80204964:	87aa                	mv	a5,a0
    80204966:	cb81                	beqz	a5,80204976 <kexit+0x9e>
        mycpu()->proc = 0;
    80204968:	fffff097          	auipc	ra,0xfffff
    8020496c:	598080e7          	jalr	1432(ra) # 80203f00 <mycpu>
    80204970:	87aa                	mv	a5,a0
    80204972:	0007b023          	sd	zero,0(a5)
    schedule();
    80204976:	00000097          	auipc	ra,0x0
    8020497a:	cd8080e7          	jalr	-808(ra) # 8020464e <schedule>
    panic("kexit should not return after schedule");
    8020497e:	00003517          	auipc	a0,0x3
    80204982:	4f250513          	addi	a0,a0,1266 # 80207e70 <small_numbers+0x1a20>
    80204986:	ffffd097          	auipc	ra,0xffffd
    8020498a:	ad6080e7          	jalr	-1322(ra) # 8020145c <panic>
}
    8020498e:	0001                	nop
    80204990:	60e2                	ld	ra,24(sp)
    80204992:	6442                	ld	s0,16(sp)
    80204994:	6105                	addi	sp,sp,32
    80204996:	8082                	ret

0000000080204998 <kwait>:
int kwait(int *status) {
    80204998:	7159                	addi	sp,sp,-112
    8020499a:	f486                	sd	ra,104(sp)
    8020499c:	f0a2                	sd	s0,96(sp)
    8020499e:	1880                	addi	s0,sp,112
    802049a0:	f8a43c23          	sd	a0,-104(s0)
    struct proc *p = myproc();
    802049a4:	fffff097          	auipc	ra,0xfffff
    802049a8:	544080e7          	jalr	1348(ra) # 80203ee8 <myproc>
    802049ac:	fca43023          	sd	a0,-64(s0)
    if (p == 0) {
    802049b0:	fc043783          	ld	a5,-64(s0)
    802049b4:	eb99                	bnez	a5,802049ca <kwait+0x32>
        printf("Warning: kwait called with no current process\n");
    802049b6:	00003517          	auipc	a0,0x3
    802049ba:	4e250513          	addi	a0,a0,1250 # 80207e98 <small_numbers+0x1a48>
    802049be:	ffffc097          	auipc	ra,0xffffc
    802049c2:	196080e7          	jalr	406(ra) # 80200b54 <printf>
        return -1;
    802049c6:	57fd                	li	a5,-1
    802049c8:	aa55                	j	80204b7c <kwait+0x1e4>
        intr_off();
    802049ca:	fffff097          	auipc	ra,0xfffff
    802049ce:	46e080e7          	jalr	1134(ra) # 80203e38 <intr_off>
        int found_zombie = 0;
    802049d2:	fe042623          	sw	zero,-20(s0)
        int zombie_pid = 0;
    802049d6:	fe042423          	sw	zero,-24(s0)
        int zombie_status = 0;
    802049da:	fe042223          	sw	zero,-28(s0)
        struct proc *zombie_child = 0;
    802049de:	fc043c23          	sd	zero,-40(s0)
        for (int i = 0; i < PROC; i++) {
    802049e2:	fc042a23          	sw	zero,-44(s0)
    802049e6:	a0a5                	j	80204a4e <kwait+0xb6>
            struct proc *child = &proc_table[i];
    802049e8:	fd442703          	lw	a4,-44(s0)
    802049ec:	0c800793          	li	a5,200
    802049f0:	02f70733          	mul	a4,a4,a5
    802049f4:	00006797          	auipc	a5,0x6
    802049f8:	9cc78793          	addi	a5,a5,-1588 # 8020a3c0 <proc_table>
    802049fc:	97ba                	add	a5,a5,a4
    802049fe:	faf43c23          	sd	a5,-72(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    80204a02:	fb843783          	ld	a5,-72(s0)
    80204a06:	439c                	lw	a5,0(a5)
    80204a08:	873e                	mv	a4,a5
    80204a0a:	4795                	li	a5,5
    80204a0c:	02f71c63          	bne	a4,a5,80204a44 <kwait+0xac>
    80204a10:	fb843783          	ld	a5,-72(s0)
    80204a14:	6fdc                	ld	a5,152(a5)
    80204a16:	fc043703          	ld	a4,-64(s0)
    80204a1a:	02f71563          	bne	a4,a5,80204a44 <kwait+0xac>
                found_zombie = 1;
    80204a1e:	4785                	li	a5,1
    80204a20:	fef42623          	sw	a5,-20(s0)
                zombie_pid = child->pid;
    80204a24:	fb843783          	ld	a5,-72(s0)
    80204a28:	43dc                	lw	a5,4(a5)
    80204a2a:	fef42423          	sw	a5,-24(s0)
                zombie_status = child->exit_status;
    80204a2e:	fb843783          	ld	a5,-72(s0)
    80204a32:	0847a783          	lw	a5,132(a5)
    80204a36:	fef42223          	sw	a5,-28(s0)
                zombie_child = child;
    80204a3a:	fb843783          	ld	a5,-72(s0)
    80204a3e:	fcf43c23          	sd	a5,-40(s0)
                break;
    80204a42:	a829                	j	80204a5c <kwait+0xc4>
        for (int i = 0; i < PROC; i++) {
    80204a44:	fd442783          	lw	a5,-44(s0)
    80204a48:	2785                	addiw	a5,a5,1
    80204a4a:	fcf42a23          	sw	a5,-44(s0)
    80204a4e:	fd442783          	lw	a5,-44(s0)
    80204a52:	0007871b          	sext.w	a4,a5
    80204a56:	47fd                	li	a5,31
    80204a58:	f8e7d8e3          	bge	a5,a4,802049e8 <kwait+0x50>
        if (found_zombie) {
    80204a5c:	fec42783          	lw	a5,-20(s0)
    80204a60:	2781                	sext.w	a5,a5
    80204a62:	cb85                	beqz	a5,80204a92 <kwait+0xfa>
            if (status)
    80204a64:	f9843783          	ld	a5,-104(s0)
    80204a68:	c791                	beqz	a5,80204a74 <kwait+0xdc>
                *status = zombie_status;
    80204a6a:	f9843783          	ld	a5,-104(s0)
    80204a6e:	fe442703          	lw	a4,-28(s0)
    80204a72:	c398                	sw	a4,0(a5)
            free_proc(zombie_child);
    80204a74:	fd843503          	ld	a0,-40(s0)
    80204a78:	00000097          	auipc	ra,0x0
    80204a7c:	99a080e7          	jalr	-1638(ra) # 80204412 <free_proc>
			zombie_child = NULL;
    80204a80:	fc043c23          	sd	zero,-40(s0)
            intr_on();
    80204a84:	fffff097          	auipc	ra,0xfffff
    80204a88:	38a080e7          	jalr	906(ra) # 80203e0e <intr_on>
            return zombie_pid;
    80204a8c:	fe842783          	lw	a5,-24(s0)
    80204a90:	a0f5                	j	80204b7c <kwait+0x1e4>
        int havekids = 0;
    80204a92:	fc042823          	sw	zero,-48(s0)
        for (int i = 0; i < PROC; i++) {
    80204a96:	fc042623          	sw	zero,-52(s0)
    80204a9a:	a089                	j	80204adc <kwait+0x144>
            struct proc *child = &proc_table[i];
    80204a9c:	fcc42703          	lw	a4,-52(s0)
    80204aa0:	0c800793          	li	a5,200
    80204aa4:	02f70733          	mul	a4,a4,a5
    80204aa8:	00006797          	auipc	a5,0x6
    80204aac:	91878793          	addi	a5,a5,-1768 # 8020a3c0 <proc_table>
    80204ab0:	97ba                	add	a5,a5,a4
    80204ab2:	faf43023          	sd	a5,-96(s0)
            if (child->state != UNUSED && child->parent == p) {
    80204ab6:	fa043783          	ld	a5,-96(s0)
    80204aba:	439c                	lw	a5,0(a5)
    80204abc:	cb99                	beqz	a5,80204ad2 <kwait+0x13a>
    80204abe:	fa043783          	ld	a5,-96(s0)
    80204ac2:	6fdc                	ld	a5,152(a5)
    80204ac4:	fc043703          	ld	a4,-64(s0)
    80204ac8:	00f71563          	bne	a4,a5,80204ad2 <kwait+0x13a>
                havekids = 1;
    80204acc:	4785                	li	a5,1
    80204ace:	fcf42823          	sw	a5,-48(s0)
        for (int i = 0; i < PROC; i++) {
    80204ad2:	fcc42783          	lw	a5,-52(s0)
    80204ad6:	2785                	addiw	a5,a5,1
    80204ad8:	fcf42623          	sw	a5,-52(s0)
    80204adc:	fcc42783          	lw	a5,-52(s0)
    80204ae0:	0007871b          	sext.w	a4,a5
    80204ae4:	47fd                	li	a5,31
    80204ae6:	fae7dbe3          	bge	a5,a4,80204a9c <kwait+0x104>
        if (!havekids) {
    80204aea:	fd042783          	lw	a5,-48(s0)
    80204aee:	2781                	sext.w	a5,a5
    80204af0:	e799                	bnez	a5,80204afe <kwait+0x166>
            intr_on();
    80204af2:	fffff097          	auipc	ra,0xfffff
    80204af6:	31c080e7          	jalr	796(ra) # 80203e0e <intr_on>
            return -1;
    80204afa:	57fd                	li	a5,-1
    80204afc:	a041                	j	80204b7c <kwait+0x1e4>
        }
        void *wait_chan = (void*)p;
    80204afe:	fc043783          	ld	a5,-64(s0)
    80204b02:	faf43823          	sd	a5,-80(s0)
		register uint64 ra asm("ra");
		p->context.ra = ra;
    80204b06:	8706                	mv	a4,ra
    80204b08:	fc043783          	ld	a5,-64(s0)
    80204b0c:	eb98                	sd	a4,16(a5)
        p->chan = wait_chan;
    80204b0e:	fc043783          	ld	a5,-64(s0)
    80204b12:	fb043703          	ld	a4,-80(s0)
    80204b16:	f3d8                	sd	a4,160(a5)
        p->state = SLEEPING;
    80204b18:	fc043783          	ld	a5,-64(s0)
    80204b1c:	4709                	li	a4,2
    80204b1e:	c398                	sw	a4,0(a5)
        
		struct cpu *c = mycpu();
    80204b20:	fffff097          	auipc	ra,0xfffff
    80204b24:	3e0080e7          	jalr	992(ra) # 80203f00 <mycpu>
    80204b28:	faa43423          	sd	a0,-88(s0)
		current_proc = 0;
    80204b2c:	00005797          	auipc	a5,0x5
    80204b30:	56478793          	addi	a5,a5,1380 # 8020a090 <current_proc>
    80204b34:	0007b023          	sd	zero,0(a5)
		c->proc = 0;
    80204b38:	fa843783          	ld	a5,-88(s0)
    80204b3c:	0007b023          	sd	zero,0(a5)
        // 在睡眠前确保中断是开启的
        intr_on();
    80204b40:	fffff097          	auipc	ra,0xfffff
    80204b44:	2ce080e7          	jalr	718(ra) # 80203e0e <intr_on>
        swtch(&p->context,&c->context);
    80204b48:	fc043783          	ld	a5,-64(s0)
    80204b4c:	01078713          	addi	a4,a5,16
    80204b50:	fa843783          	ld	a5,-88(s0)
    80204b54:	07a1                	addi	a5,a5,8
    80204b56:	85be                	mv	a1,a5
    80204b58:	853a                	mv	a0,a4
    80204b5a:	fffff097          	auipc	ra,0xfffff
    80204b5e:	216080e7          	jalr	534(ra) # 80203d70 <swtch>
        intr_off();
    80204b62:	fffff097          	auipc	ra,0xfffff
    80204b66:	2d6080e7          	jalr	726(ra) # 80203e38 <intr_off>
        p->state = RUNNING;
    80204b6a:	fc043783          	ld	a5,-64(s0)
    80204b6e:	4711                	li	a4,4
    80204b70:	c398                	sw	a4,0(a5)
        intr_on();
    80204b72:	fffff097          	auipc	ra,0xfffff
    80204b76:	29c080e7          	jalr	668(ra) # 80203e0e <intr_on>
    while (1) {
    80204b7a:	bd81                	j	802049ca <kwait+0x32>
    }
}
    80204b7c:	853e                	mv	a0,a5
    80204b7e:	70a6                	ld	ra,104(sp)
    80204b80:	7406                	ld	s0,96(sp)
    80204b82:	6165                	addi	sp,sp,112
    80204b84:	8082                	ret

0000000080204b86 <print_proc_table>:

void print_proc_table(void) {
    80204b86:	1101                	addi	sp,sp,-32
    80204b88:	ec06                	sd	ra,24(sp)
    80204b8a:	e822                	sd	s0,16(sp)
    80204b8c:	1000                	addi	s0,sp,32
    struct proc *p;
    int count = 0;
    80204b8e:	fe042223          	sw	zero,-28(s0)
    
    printf("PID  status     parent  func_address    stack_address\n");
    80204b92:	00003517          	auipc	a0,0x3
    80204b96:	33650513          	addi	a0,a0,822 # 80207ec8 <small_numbers+0x1a78>
    80204b9a:	ffffc097          	auipc	ra,0xffffc
    80204b9e:	fba080e7          	jalr	-70(ra) # 80200b54 <printf>
    printf("--------------------------------------------\n");
    80204ba2:	00003517          	auipc	a0,0x3
    80204ba6:	35e50513          	addi	a0,a0,862 # 80207f00 <small_numbers+0x1ab0>
    80204baa:	ffffc097          	auipc	ra,0xffffc
    80204bae:	faa080e7          	jalr	-86(ra) # 80200b54 <printf>
    
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    80204bb2:	00006797          	auipc	a5,0x6
    80204bb6:	80e78793          	addi	a5,a5,-2034 # 8020a3c0 <proc_table>
    80204bba:	fef43423          	sd	a5,-24(s0)
    80204bbe:	a2bd                	j	80204d2c <print_proc_table+0x1a6>
        if(p->state != UNUSED) {
    80204bc0:	fe843783          	ld	a5,-24(s0)
    80204bc4:	439c                	lw	a5,0(a5)
    80204bc6:	14078d63          	beqz	a5,80204d20 <print_proc_table+0x19a>
            count++;
    80204bca:	fe442783          	lw	a5,-28(s0)
    80204bce:	2785                	addiw	a5,a5,1
    80204bd0:	fef42223          	sw	a5,-28(s0)
            printf("%d ", p->pid);
    80204bd4:	fe843783          	ld	a5,-24(s0)
    80204bd8:	43dc                	lw	a5,4(a5)
    80204bda:	85be                	mv	a1,a5
    80204bdc:	00003517          	auipc	a0,0x3
    80204be0:	35450513          	addi	a0,a0,852 # 80207f30 <small_numbers+0x1ae0>
    80204be4:	ffffc097          	auipc	ra,0xffffc
    80204be8:	f70080e7          	jalr	-144(ra) # 80200b54 <printf>
            
            switch(p->state) {
    80204bec:	fe843783          	ld	a5,-24(s0)
    80204bf0:	439c                	lw	a5,0(a5)
    80204bf2:	86be                	mv	a3,a5
    80204bf4:	4715                	li	a4,5
    80204bf6:	08d76863          	bltu	a4,a3,80204c86 <print_proc_table+0x100>
    80204bfa:	00279713          	slli	a4,a5,0x2
    80204bfe:	00003797          	auipc	a5,0x3
    80204c02:	3e278793          	addi	a5,a5,994 # 80207fe0 <small_numbers+0x1b90>
    80204c06:	97ba                	add	a5,a5,a4
    80204c08:	439c                	lw	a5,0(a5)
    80204c0a:	0007871b          	sext.w	a4,a5
    80204c0e:	00003797          	auipc	a5,0x3
    80204c12:	3d278793          	addi	a5,a5,978 # 80207fe0 <small_numbers+0x1b90>
    80204c16:	97ba                	add	a5,a5,a4
    80204c18:	8782                	jr	a5
                case UNUSED:   printf("UNUSED    "); break;
    80204c1a:	00003517          	auipc	a0,0x3
    80204c1e:	31e50513          	addi	a0,a0,798 # 80207f38 <small_numbers+0x1ae8>
    80204c22:	ffffc097          	auipc	ra,0xffffc
    80204c26:	f32080e7          	jalr	-206(ra) # 80200b54 <printf>
    80204c2a:	a89d                	j	80204ca0 <print_proc_table+0x11a>
                case USED:     printf("USED      "); break;
    80204c2c:	00003517          	auipc	a0,0x3
    80204c30:	31c50513          	addi	a0,a0,796 # 80207f48 <small_numbers+0x1af8>
    80204c34:	ffffc097          	auipc	ra,0xffffc
    80204c38:	f20080e7          	jalr	-224(ra) # 80200b54 <printf>
    80204c3c:	a095                	j	80204ca0 <print_proc_table+0x11a>
                case SLEEPING: printf("SLEEP     "); break;
    80204c3e:	00003517          	auipc	a0,0x3
    80204c42:	31a50513          	addi	a0,a0,794 # 80207f58 <small_numbers+0x1b08>
    80204c46:	ffffc097          	auipc	ra,0xffffc
    80204c4a:	f0e080e7          	jalr	-242(ra) # 80200b54 <printf>
    80204c4e:	a889                	j	80204ca0 <print_proc_table+0x11a>
                case RUNNABLE: printf("RUNNABLE  "); break;
    80204c50:	00003517          	auipc	a0,0x3
    80204c54:	31850513          	addi	a0,a0,792 # 80207f68 <small_numbers+0x1b18>
    80204c58:	ffffc097          	auipc	ra,0xffffc
    80204c5c:	efc080e7          	jalr	-260(ra) # 80200b54 <printf>
    80204c60:	a081                	j	80204ca0 <print_proc_table+0x11a>
                case RUNNING:  printf("RUNNING   "); break;
    80204c62:	00003517          	auipc	a0,0x3
    80204c66:	31650513          	addi	a0,a0,790 # 80207f78 <small_numbers+0x1b28>
    80204c6a:	ffffc097          	auipc	ra,0xffffc
    80204c6e:	eea080e7          	jalr	-278(ra) # 80200b54 <printf>
    80204c72:	a03d                	j	80204ca0 <print_proc_table+0x11a>
                case ZOMBIE:   printf("ZOMBIE    "); break;
    80204c74:	00003517          	auipc	a0,0x3
    80204c78:	31450513          	addi	a0,a0,788 # 80207f88 <small_numbers+0x1b38>
    80204c7c:	ffffc097          	auipc	ra,0xffffc
    80204c80:	ed8080e7          	jalr	-296(ra) # 80200b54 <printf>
    80204c84:	a831                	j	80204ca0 <print_proc_table+0x11a>
                default:       printf("UNKNOWN(%d) ", p->state); break;
    80204c86:	fe843783          	ld	a5,-24(s0)
    80204c8a:	439c                	lw	a5,0(a5)
    80204c8c:	85be                	mv	a1,a5
    80204c8e:	00003517          	auipc	a0,0x3
    80204c92:	30a50513          	addi	a0,a0,778 # 80207f98 <small_numbers+0x1b48>
    80204c96:	ffffc097          	auipc	ra,0xffffc
    80204c9a:	ebe080e7          	jalr	-322(ra) # 80200b54 <printf>
    80204c9e:	0001                	nop
            }
            
            if(p->parent)
    80204ca0:	fe843783          	ld	a5,-24(s0)
    80204ca4:	6fdc                	ld	a5,152(a5)
    80204ca6:	cf99                	beqz	a5,80204cc4 <print_proc_table+0x13e>
                printf("%d ", p->parent->pid);
    80204ca8:	fe843783          	ld	a5,-24(s0)
    80204cac:	6fdc                	ld	a5,152(a5)
    80204cae:	43dc                	lw	a5,4(a5)
    80204cb0:	85be                	mv	a1,a5
    80204cb2:	00003517          	auipc	a0,0x3
    80204cb6:	27e50513          	addi	a0,a0,638 # 80207f30 <small_numbers+0x1ae0>
    80204cba:	ffffc097          	auipc	ra,0xffffc
    80204cbe:	e9a080e7          	jalr	-358(ra) # 80200b54 <printf>
    80204cc2:	a809                	j	80204cd4 <print_proc_table+0x14e>
            else
                printf("none    ");
    80204cc4:	00003517          	auipc	a0,0x3
    80204cc8:	2e450513          	addi	a0,a0,740 # 80207fa8 <small_numbers+0x1b58>
    80204ccc:	ffffc097          	auipc	ra,0xffffc
    80204cd0:	e88080e7          	jalr	-376(ra) # 80200b54 <printf>
                
            if(p->trapframe)
    80204cd4:	fe843783          	ld	a5,-24(s0)
    80204cd8:	63fc                	ld	a5,192(a5)
    80204cda:	cf99                	beqz	a5,80204cf8 <print_proc_table+0x172>
                printf("%p ", (void*)p->trapframe->epc);
    80204cdc:	fe843783          	ld	a5,-24(s0)
    80204ce0:	63fc                	ld	a5,192(a5)
    80204ce2:	6f9c                	ld	a5,24(a5)
    80204ce4:	85be                	mv	a1,a5
    80204ce6:	00003517          	auipc	a0,0x3
    80204cea:	2d250513          	addi	a0,a0,722 # 80207fb8 <small_numbers+0x1b68>
    80204cee:	ffffc097          	auipc	ra,0xffffc
    80204cf2:	e66080e7          	jalr	-410(ra) # 80200b54 <printf>
    80204cf6:	a809                	j	80204d08 <print_proc_table+0x182>
            else
                printf("none    ");
    80204cf8:	00003517          	auipc	a0,0x3
    80204cfc:	2b050513          	addi	a0,a0,688 # 80207fa8 <small_numbers+0x1b58>
    80204d00:	ffffc097          	auipc	ra,0xffffc
    80204d04:	e54080e7          	jalr	-428(ra) # 80200b54 <printf>
                
            printf("%p\n", (void*)p->kstack);
    80204d08:	fe843783          	ld	a5,-24(s0)
    80204d0c:	679c                	ld	a5,8(a5)
    80204d0e:	85be                	mv	a1,a5
    80204d10:	00003517          	auipc	a0,0x3
    80204d14:	2b050513          	addi	a0,a0,688 # 80207fc0 <small_numbers+0x1b70>
    80204d18:	ffffc097          	auipc	ra,0xffffc
    80204d1c:	e3c080e7          	jalr	-452(ra) # 80200b54 <printf>
    for(p = proc_table; p < &proc_table[PROC]; p++) {
    80204d20:	fe843783          	ld	a5,-24(s0)
    80204d24:	0c878793          	addi	a5,a5,200
    80204d28:	fef43423          	sd	a5,-24(s0)
    80204d2c:	fe843703          	ld	a4,-24(s0)
    80204d30:	00007797          	auipc	a5,0x7
    80204d34:	f9078793          	addi	a5,a5,-112 # 8020bcc0 <proc_buffer>
    80204d38:	e8f764e3          	bltu	a4,a5,80204bc0 <print_proc_table+0x3a>
        }
    }
    
    printf("--------------------------------------------\n");
    80204d3c:	00003517          	auipc	a0,0x3
    80204d40:	1c450513          	addi	a0,a0,452 # 80207f00 <small_numbers+0x1ab0>
    80204d44:	ffffc097          	auipc	ra,0xffffc
    80204d48:	e10080e7          	jalr	-496(ra) # 80200b54 <printf>
    printf("%d active processes\n", count);
    80204d4c:	fe442783          	lw	a5,-28(s0)
    80204d50:	85be                	mv	a1,a5
    80204d52:	00003517          	auipc	a0,0x3
    80204d56:	27650513          	addi	a0,a0,630 # 80207fc8 <small_numbers+0x1b78>
    80204d5a:	ffffc097          	auipc	ra,0xffffc
    80204d5e:	dfa080e7          	jalr	-518(ra) # 80200b54 <printf>

}
    80204d62:	0001                	nop
    80204d64:	60e2                	ld	ra,24(sp)
    80204d66:	6442                	ld	s0,16(sp)
    80204d68:	6105                	addi	sp,sp,32
    80204d6a:	8082                	ret

0000000080204d6c <simple_task>:

// 简单测试任务，用于测试进程创建
void simple_task(void) {
    80204d6c:	1141                	addi	sp,sp,-16
    80204d6e:	e406                	sd	ra,8(sp)
    80204d70:	e022                	sd	s0,0(sp)
    80204d72:	0800                	addi	s0,sp,16
    // 简单任务，只打印并退出
    printf("Simple task running in PID %d\n", myproc()->pid);
    80204d74:	fffff097          	auipc	ra,0xfffff
    80204d78:	174080e7          	jalr	372(ra) # 80203ee8 <myproc>
    80204d7c:	87aa                	mv	a5,a0
    80204d7e:	43dc                	lw	a5,4(a5)
    80204d80:	85be                	mv	a1,a5
    80204d82:	00003517          	auipc	a0,0x3
    80204d86:	27650513          	addi	a0,a0,630 # 80207ff8 <small_numbers+0x1ba8>
    80204d8a:	ffffc097          	auipc	ra,0xffffc
    80204d8e:	dca080e7          	jalr	-566(ra) # 80200b54 <printf>
}
    80204d92:	0001                	nop
    80204d94:	60a2                	ld	ra,8(sp)
    80204d96:	6402                	ld	s0,0(sp)
    80204d98:	0141                	addi	sp,sp,16
    80204d9a:	8082                	ret

0000000080204d9c <test_process_creation>:
void test_process_creation(void) {
    80204d9c:	7139                	addi	sp,sp,-64
    80204d9e:	fc06                	sd	ra,56(sp)
    80204da0:	f822                	sd	s0,48(sp)
    80204da2:	0080                	addi	s0,sp,64
    printf("\n==================================================\n");
    80204da4:	00003517          	auipc	a0,0x3
    80204da8:	27450513          	addi	a0,a0,628 # 80208018 <small_numbers+0x1bc8>
    80204dac:	ffffc097          	auipc	ra,0xffffc
    80204db0:	da8080e7          	jalr	-600(ra) # 80200b54 <printf>
    printf("===== 测试开始: 进程创建与管理测试 =====\n");
    80204db4:	00003517          	auipc	a0,0x3
    80204db8:	29c50513          	addi	a0,a0,668 # 80208050 <small_numbers+0x1c00>
    80204dbc:	ffffc097          	auipc	ra,0xffffc
    80204dc0:	d98080e7          	jalr	-616(ra) # 80200b54 <printf>
    printf("==================================================\n");
    80204dc4:	00003517          	auipc	a0,0x3
    80204dc8:	2c450513          	addi	a0,a0,708 # 80208088 <small_numbers+0x1c38>
    80204dcc:	ffffc097          	auipc	ra,0xffffc
    80204dd0:	d88080e7          	jalr	-632(ra) # 80200b54 <printf>

    // 测试基本的进程创建
    int pid = create_proc(simple_task);
    80204dd4:	00000517          	auipc	a0,0x0
    80204dd8:	f9850513          	addi	a0,a0,-104 # 80204d6c <simple_task>
    80204ddc:	fffff097          	auipc	ra,0xfffff
    80204de0:	6e2080e7          	jalr	1762(ra) # 802044be <create_proc>
    80204de4:	87aa                	mv	a5,a0
    80204de6:	fcf42e23          	sw	a5,-36(s0)
    assert(pid > 0);
    80204dea:	fdc42783          	lw	a5,-36(s0)
    80204dee:	2781                	sext.w	a5,a5
    80204df0:	00f027b3          	sgtz	a5,a5
    80204df4:	0ff7f793          	zext.b	a5,a5
    80204df8:	2781                	sext.w	a5,a5
    80204dfa:	853e                	mv	a0,a5
    80204dfc:	fffff097          	auipc	ra,0xfffff
    80204e00:	07e080e7          	jalr	126(ra) # 80203e7a <assert>
    printf("【测试结果】: 基本进程创建成功，PID: %d，正常退出\n", pid);
    80204e04:	fdc42783          	lw	a5,-36(s0)
    80204e08:	85be                	mv	a1,a5
    80204e0a:	00003517          	auipc	a0,0x3
    80204e0e:	2b650513          	addi	a0,a0,694 # 802080c0 <small_numbers+0x1c70>
    80204e12:	ffffc097          	auipc	ra,0xffffc
    80204e16:	d42080e7          	jalr	-702(ra) # 80200b54 <printf>

    int count = 1;
    80204e1a:	4785                	li	a5,1
    80204e1c:	fef42623          	sw	a5,-20(s0)
    printf("\n----- 测试进程表容量限制 -----\n");
    80204e20:	00003517          	auipc	a0,0x3
    80204e24:	2e850513          	addi	a0,a0,744 # 80208108 <small_numbers+0x1cb8>
    80204e28:	ffffc097          	auipc	ra,0xffffc
    80204e2c:	d2c080e7          	jalr	-724(ra) # 80200b54 <printf>
    for (int i = 0; i < PROC + 5; i++) {
    80204e30:	fe042423          	sw	zero,-24(s0)
    80204e34:	a81d                	j	80204e6a <test_process_creation+0xce>
        int pid = create_proc(simple_task);
    80204e36:	00000517          	auipc	a0,0x0
    80204e3a:	f3650513          	addi	a0,a0,-202 # 80204d6c <simple_task>
    80204e3e:	fffff097          	auipc	ra,0xfffff
    80204e42:	680080e7          	jalr	1664(ra) # 802044be <create_proc>
    80204e46:	87aa                	mv	a5,a0
    80204e48:	fcf42c23          	sw	a5,-40(s0)
        if (pid > 0) {
    80204e4c:	fd842783          	lw	a5,-40(s0)
    80204e50:	2781                	sext.w	a5,a5
    80204e52:	02f05563          	blez	a5,80204e7c <test_process_creation+0xe0>
            count++; 
    80204e56:	fec42783          	lw	a5,-20(s0)
    80204e5a:	2785                	addiw	a5,a5,1
    80204e5c:	fef42623          	sw	a5,-20(s0)
    for (int i = 0; i < PROC + 5; i++) {
    80204e60:	fe842783          	lw	a5,-24(s0)
    80204e64:	2785                	addiw	a5,a5,1
    80204e66:	fef42423          	sw	a5,-24(s0)
    80204e6a:	fe842783          	lw	a5,-24(s0)
    80204e6e:	0007871b          	sext.w	a4,a5
    80204e72:	02400793          	li	a5,36
    80204e76:	fce7d0e3          	bge	a5,a4,80204e36 <test_process_creation+0x9a>
    80204e7a:	a011                	j	80204e7e <test_process_creation+0xe2>
        } else {
            break;
    80204e7c:	0001                	nop
        }
    }
    printf("【测试结果】: 成功创建 %d 个进程 (最大限制: %d)\n", count, PROC);
    80204e7e:	fec42783          	lw	a5,-20(s0)
    80204e82:	02000613          	li	a2,32
    80204e86:	85be                	mv	a1,a5
    80204e88:	00003517          	auipc	a0,0x3
    80204e8c:	2b050513          	addi	a0,a0,688 # 80208138 <small_numbers+0x1ce8>
    80204e90:	ffffc097          	auipc	ra,0xffffc
    80204e94:	cc4080e7          	jalr	-828(ra) # 80200b54 <printf>
    if (count >= PROC) {
    80204e98:	fec42783          	lw	a5,-20(s0)
    80204e9c:	0007871b          	sext.w	a4,a5
    80204ea0:	47fd                	li	a5,31
    80204ea2:	00e7db63          	bge	a5,a4,80204eb8 <test_process_creation+0x11c>
        printf("【结果分析】: 系统正确处理了进程表容量限制\n");
    80204ea6:	00003517          	auipc	a0,0x3
    80204eaa:	2da50513          	addi	a0,a0,730 # 80208180 <small_numbers+0x1d30>
    80204eae:	ffffc097          	auipc	ra,0xffffc
    80204eb2:	ca6080e7          	jalr	-858(ra) # 80200b54 <printf>
    80204eb6:	a809                	j	80204ec8 <test_process_creation+0x12c>
    } else {
        printf("【结果分析】: 未达到进程表容量，可能存在问题\n");
    80204eb8:	00003517          	auipc	a0,0x3
    80204ebc:	30850513          	addi	a0,a0,776 # 802081c0 <small_numbers+0x1d70>
    80204ec0:	ffffc097          	auipc	ra,0xffffc
    80204ec4:	c94080e7          	jalr	-876(ra) # 80200b54 <printf>
    }

    // 清理测试进程
    printf("\n----- 测试进程等待与清理 -----\n");
    80204ec8:	00003517          	auipc	a0,0x3
    80204ecc:	34050513          	addi	a0,a0,832 # 80208208 <small_numbers+0x1db8>
    80204ed0:	ffffc097          	auipc	ra,0xffffc
    80204ed4:	c84080e7          	jalr	-892(ra) # 80200b54 <printf>
    int success_count = 0;
    80204ed8:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < count; i++) {
    80204edc:	fe042023          	sw	zero,-32(s0)
    80204ee0:	a0a1                	j	80204f28 <test_process_creation+0x18c>
        int waited_pid = wait_proc(NULL);
    80204ee2:	4501                	li	a0,0
    80204ee4:	fffff097          	auipc	ra,0xfffff
    80204ee8:	68e080e7          	jalr	1678(ra) # 80204572 <wait_proc>
    80204eec:	87aa                	mv	a5,a0
    80204eee:	fcf42623          	sw	a5,-52(s0)
        if (waited_pid > 0) {
    80204ef2:	fcc42783          	lw	a5,-52(s0)
    80204ef6:	2781                	sext.w	a5,a5
    80204ef8:	00f05863          	blez	a5,80204f08 <test_process_creation+0x16c>
            success_count++;
    80204efc:	fe442783          	lw	a5,-28(s0)
    80204f00:	2785                	addiw	a5,a5,1
    80204f02:	fef42223          	sw	a5,-28(s0)
    80204f06:	a821                	j	80204f1e <test_process_creation+0x182>
        } else {
            printf("【错误】: 等待进程失败，错误码: %d\n", waited_pid);
    80204f08:	fcc42783          	lw	a5,-52(s0)
    80204f0c:	85be                	mv	a1,a5
    80204f0e:	00003517          	auipc	a0,0x3
    80204f12:	32a50513          	addi	a0,a0,810 # 80208238 <small_numbers+0x1de8>
    80204f16:	ffffc097          	auipc	ra,0xffffc
    80204f1a:	c3e080e7          	jalr	-962(ra) # 80200b54 <printf>
    for (int i = 0; i < count; i++) {
    80204f1e:	fe042783          	lw	a5,-32(s0)
    80204f22:	2785                	addiw	a5,a5,1
    80204f24:	fef42023          	sw	a5,-32(s0)
    80204f28:	fe042783          	lw	a5,-32(s0)
    80204f2c:	873e                	mv	a4,a5
    80204f2e:	fec42783          	lw	a5,-20(s0)
    80204f32:	2701                	sext.w	a4,a4
    80204f34:	2781                	sext.w	a5,a5
    80204f36:	faf746e3          	blt	a4,a5,80204ee2 <test_process_creation+0x146>
        }
    }
    printf("【测试结果】: 回收 %d/%d 个进程\n", success_count, count);
    80204f3a:	fec42703          	lw	a4,-20(s0)
    80204f3e:	fe442783          	lw	a5,-28(s0)
    80204f42:	863a                	mv	a2,a4
    80204f44:	85be                	mv	a1,a5
    80204f46:	00003517          	auipc	a0,0x3
    80204f4a:	32a50513          	addi	a0,a0,810 # 80208270 <small_numbers+0x1e20>
    80204f4e:	ffffc097          	auipc	ra,0xffffc
    80204f52:	c06080e7          	jalr	-1018(ra) # 80200b54 <printf>
    if (success_count == count) {
    80204f56:	fe442783          	lw	a5,-28(s0)
    80204f5a:	873e                	mv	a4,a5
    80204f5c:	fec42783          	lw	a5,-20(s0)
    80204f60:	2701                	sext.w	a4,a4
    80204f62:	2781                	sext.w	a5,a5
    80204f64:	00f71b63          	bne	a4,a5,80204f7a <test_process_creation+0x1de>
        printf("【结果分析】: 所有进程成功回收，等待机制正常工作\n");
    80204f68:	00003517          	auipc	a0,0x3
    80204f6c:	33850513          	addi	a0,a0,824 # 802082a0 <small_numbers+0x1e50>
    80204f70:	ffffc097          	auipc	ra,0xffffc
    80204f74:	be4080e7          	jalr	-1052(ra) # 80200b54 <printf>
    80204f78:	a809                	j	80204f8a <test_process_creation+0x1ee>
    } else {
        printf("【结果分析】: 部分进程未正常回收，等待机制可能存在问题\n");
    80204f7a:	00003517          	auipc	a0,0x3
    80204f7e:	37650513          	addi	a0,a0,886 # 802082f0 <small_numbers+0x1ea0>
    80204f82:	ffffc097          	auipc	ra,0xffffc
    80204f86:	bd2080e7          	jalr	-1070(ra) # 80200b54 <printf>
    }
    // 增强测试：清理后尝试重新创建进程
    printf("\n----- 清理后尝试重新创建进程 -----\n");
    80204f8a:	00003517          	auipc	a0,0x3
    80204f8e:	3be50513          	addi	a0,a0,958 # 80208348 <small_numbers+0x1ef8>
    80204f92:	ffffc097          	auipc	ra,0xffffc
    80204f96:	bc2080e7          	jalr	-1086(ra) # 80200b54 <printf>
    int new_pid = create_proc(simple_task);
    80204f9a:	00000517          	auipc	a0,0x0
    80204f9e:	dd250513          	addi	a0,a0,-558 # 80204d6c <simple_task>
    80204fa2:	fffff097          	auipc	ra,0xfffff
    80204fa6:	51c080e7          	jalr	1308(ra) # 802044be <create_proc>
    80204faa:	87aa                	mv	a5,a0
    80204fac:	fcf42a23          	sw	a5,-44(s0)
    if (new_pid > 0) {
    80204fb0:	fd442783          	lw	a5,-44(s0)
    80204fb4:	2781                	sext.w	a5,a5
    80204fb6:	06f05663          	blez	a5,80205022 <test_process_creation+0x286>
        printf("【增强测试结果】: 清理后成功重新创建进程，PID: %d\n", new_pid);
    80204fba:	fd442783          	lw	a5,-44(s0)
    80204fbe:	85be                	mv	a1,a5
    80204fc0:	00003517          	auipc	a0,0x3
    80204fc4:	3b850513          	addi	a0,a0,952 # 80208378 <small_numbers+0x1f28>
    80204fc8:	ffffc097          	auipc	ra,0xffffc
    80204fcc:	b8c080e7          	jalr	-1140(ra) # 80200b54 <printf>
		
        // 等待新进程退出
        int waited_new = wait_proc(NULL);
    80204fd0:	4501                	li	a0,0
    80204fd2:	fffff097          	auipc	ra,0xfffff
    80204fd6:	5a0080e7          	jalr	1440(ra) # 80204572 <wait_proc>
    80204fda:	87aa                	mv	a5,a0
    80204fdc:	fcf42823          	sw	a5,-48(s0)
        if (waited_new == new_pid) {
    80204fe0:	fd042783          	lw	a5,-48(s0)
    80204fe4:	873e                	mv	a4,a5
    80204fe6:	fd442783          	lw	a5,-44(s0)
    80204fea:	2701                	sext.w	a4,a4
    80204fec:	2781                	sext.w	a5,a5
    80204fee:	00f71e63          	bne	a4,a5,8020500a <test_process_creation+0x26e>
            printf("【增强测试结果】: 新进程已成功回收，PID: %d\n", waited_new);
    80204ff2:	fd042783          	lw	a5,-48(s0)
    80204ff6:	85be                	mv	a1,a5
    80204ff8:	00003517          	auipc	a0,0x3
    80204ffc:	3c850513          	addi	a0,a0,968 # 802083c0 <small_numbers+0x1f70>
    80205000:	ffffc097          	auipc	ra,0xffffc
    80205004:	b54080e7          	jalr	-1196(ra) # 80200b54 <printf>
    80205008:	a02d                	j	80205032 <test_process_creation+0x296>
        } else {
            printf("【增强测试错误】: 新进程未正常回收，返回值: %d\n", waited_new);
    8020500a:	fd042783          	lw	a5,-48(s0)
    8020500e:	85be                	mv	a1,a5
    80205010:	00003517          	auipc	a0,0x3
    80205014:	3f050513          	addi	a0,a0,1008 # 80208400 <small_numbers+0x1fb0>
    80205018:	ffffc097          	auipc	ra,0xffffc
    8020501c:	b3c080e7          	jalr	-1220(ra) # 80200b54 <printf>
    80205020:	a809                	j	80205032 <test_process_creation+0x296>
        }
    } else {
        printf("【增强测试错误】: 清理后无法重新创建进程，可能进程槽未归还\n");
    80205022:	00003517          	auipc	a0,0x3
    80205026:	42650513          	addi	a0,a0,1062 # 80208448 <small_numbers+0x1ff8>
    8020502a:	ffffc097          	auipc	ra,0xffffc
    8020502e:	b2a080e7          	jalr	-1238(ra) # 80200b54 <printf>
    }

    printf("\n==================================================\n");
    80205032:	00003517          	auipc	a0,0x3
    80205036:	fe650513          	addi	a0,a0,-26 # 80208018 <small_numbers+0x1bc8>
    8020503a:	ffffc097          	auipc	ra,0xffffc
    8020503e:	b1a080e7          	jalr	-1254(ra) # 80200b54 <printf>
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    80205042:	00003517          	auipc	a0,0x3
    80205046:	45e50513          	addi	a0,a0,1118 # 802084a0 <small_numbers+0x2050>
    8020504a:	ffffc097          	auipc	ra,0xffffc
    8020504e:	b0a080e7          	jalr	-1270(ra) # 80200b54 <printf>
    printf("==================================================\n\n");
    80205052:	00003517          	auipc	a0,0x3
    80205056:	48650513          	addi	a0,a0,1158 # 802084d8 <small_numbers+0x2088>
    8020505a:	ffffc097          	auipc	ra,0xffffc
    8020505e:	afa080e7          	jalr	-1286(ra) # 80200b54 <printf>
}
    80205062:	0001                	nop
    80205064:	70e2                	ld	ra,56(sp)
    80205066:	7442                	ld	s0,48(sp)
    80205068:	6121                	addi	sp,sp,64
    8020506a:	8082                	ret

000000008020506c <cpu_intensive_task>:

void cpu_intensive_task(void) {
    8020506c:	1101                	addi	sp,sp,-32
    8020506e:	ec06                	sd	ra,24(sp)
    80205070:	e822                	sd	s0,16(sp)
    80205072:	1000                	addi	s0,sp,32
    uint64 sum = 0;
    80205074:	fe043423          	sd	zero,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    80205078:	fe043023          	sd	zero,-32(s0)
    8020507c:	a829                	j	80205096 <cpu_intensive_task+0x2a>
        sum += i;
    8020507e:	fe843703          	ld	a4,-24(s0)
    80205082:	fe043783          	ld	a5,-32(s0)
    80205086:	97ba                	add	a5,a5,a4
    80205088:	fef43423          	sd	a5,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    8020508c:	fe043783          	ld	a5,-32(s0)
    80205090:	0785                	addi	a5,a5,1
    80205092:	fef43023          	sd	a5,-32(s0)
    80205096:	fe043703          	ld	a4,-32(s0)
    8020509a:	009897b7          	lui	a5,0x989
    8020509e:	67f78793          	addi	a5,a5,1663 # 98967f <userret+0x9895e3>
    802050a2:	fce7fee3          	bgeu	a5,a4,8020507e <cpu_intensive_task+0x12>
    }
    printf("CPU intensive task done in PID %d, sum=%lu\n", myproc()->pid, sum);
    802050a6:	fffff097          	auipc	ra,0xfffff
    802050aa:	e42080e7          	jalr	-446(ra) # 80203ee8 <myproc>
    802050ae:	87aa                	mv	a5,a0
    802050b0:	43dc                	lw	a5,4(a5)
    802050b2:	fe843603          	ld	a2,-24(s0)
    802050b6:	85be                	mv	a1,a5
    802050b8:	00003517          	auipc	a0,0x3
    802050bc:	45850513          	addi	a0,a0,1112 # 80208510 <small_numbers+0x20c0>
    802050c0:	ffffc097          	auipc	ra,0xffffc
    802050c4:	a94080e7          	jalr	-1388(ra) # 80200b54 <printf>
    exit_proc(0);
    802050c8:	4501                	li	a0,0
    802050ca:	fffff097          	auipc	ra,0xfffff
    802050ce:	470080e7          	jalr	1136(ra) # 8020453a <exit_proc>
}
    802050d2:	0001                	nop
    802050d4:	60e2                	ld	ra,24(sp)
    802050d6:	6442                	ld	s0,16(sp)
    802050d8:	6105                	addi	sp,sp,32
    802050da:	8082                	ret

00000000802050dc <test_scheduler>:

void test_scheduler(void) {
    802050dc:	7179                	addi	sp,sp,-48
    802050de:	f406                	sd	ra,40(sp)
    802050e0:	f022                	sd	s0,32(sp)
    802050e2:	1800                	addi	s0,sp,48
    printf("\n==================================================\n");
    802050e4:	00003517          	auipc	a0,0x3
    802050e8:	f3450513          	addi	a0,a0,-204 # 80208018 <small_numbers+0x1bc8>
    802050ec:	ffffc097          	auipc	ra,0xffffc
    802050f0:	a68080e7          	jalr	-1432(ra) # 80200b54 <printf>
    printf("===== 测试开始: 调度器测试 =====\n");
    802050f4:	00003517          	auipc	a0,0x3
    802050f8:	44c50513          	addi	a0,a0,1100 # 80208540 <small_numbers+0x20f0>
    802050fc:	ffffc097          	auipc	ra,0xffffc
    80205100:	a58080e7          	jalr	-1448(ra) # 80200b54 <printf>
    printf("==================================================\n");
    80205104:	00003517          	auipc	a0,0x3
    80205108:	f8450513          	addi	a0,a0,-124 # 80208088 <small_numbers+0x1c38>
    8020510c:	ffffc097          	auipc	ra,0xffffc
    80205110:	a48080e7          	jalr	-1464(ra) # 80200b54 <printf>

    // 创建多个计算密集型进程
    for (int i = 0; i < 3; i++) {
    80205114:	fe042623          	sw	zero,-20(s0)
    80205118:	a831                	j	80205134 <test_scheduler+0x58>
        create_proc(cpu_intensive_task);
    8020511a:	00000517          	auipc	a0,0x0
    8020511e:	f5250513          	addi	a0,a0,-174 # 8020506c <cpu_intensive_task>
    80205122:	fffff097          	auipc	ra,0xfffff
    80205126:	39c080e7          	jalr	924(ra) # 802044be <create_proc>
    for (int i = 0; i < 3; i++) {
    8020512a:	fec42783          	lw	a5,-20(s0)
    8020512e:	2785                	addiw	a5,a5,1
    80205130:	fef42623          	sw	a5,-20(s0)
    80205134:	fec42783          	lw	a5,-20(s0)
    80205138:	0007871b          	sext.w	a4,a5
    8020513c:	4789                	li	a5,2
    8020513e:	fce7dee3          	bge	a5,a4,8020511a <test_scheduler+0x3e>
    }

    // 观察调度行为
    uint64 start_time = get_time();
    80205142:	ffffe097          	auipc	ra,0xffffe
    80205146:	560080e7          	jalr	1376(ra) # 802036a2 <get_time>
    8020514a:	fea43023          	sd	a0,-32(s0)
	for (int i = 0; i < 3; i++) {
    8020514e:	fe042423          	sw	zero,-24(s0)
    80205152:	a819                	j	80205168 <test_scheduler+0x8c>
    	wait_proc(NULL); // 等待所有子进程结束
    80205154:	4501                	li	a0,0
    80205156:	fffff097          	auipc	ra,0xfffff
    8020515a:	41c080e7          	jalr	1052(ra) # 80204572 <wait_proc>
	for (int i = 0; i < 3; i++) {
    8020515e:	fe842783          	lw	a5,-24(s0)
    80205162:	2785                	addiw	a5,a5,1
    80205164:	fef42423          	sw	a5,-24(s0)
    80205168:	fe842783          	lw	a5,-24(s0)
    8020516c:	0007871b          	sext.w	a4,a5
    80205170:	4789                	li	a5,2
    80205172:	fee7d1e3          	bge	a5,a4,80205154 <test_scheduler+0x78>
	}
    uint64 end_time = get_time();
    80205176:	ffffe097          	auipc	ra,0xffffe
    8020517a:	52c080e7          	jalr	1324(ra) # 802036a2 <get_time>
    8020517e:	fca43c23          	sd	a0,-40(s0)

    printf("Scheduler test completed in %lu cycles\n", end_time - start_time);
    80205182:	fd843703          	ld	a4,-40(s0)
    80205186:	fe043783          	ld	a5,-32(s0)
    8020518a:	40f707b3          	sub	a5,a4,a5
    8020518e:	85be                	mv	a1,a5
    80205190:	00003517          	auipc	a0,0x3
    80205194:	3e050513          	addi	a0,a0,992 # 80208570 <small_numbers+0x2120>
    80205198:	ffffc097          	auipc	ra,0xffffc
    8020519c:	9bc080e7          	jalr	-1604(ra) # 80200b54 <printf>
	printf("\n==================================================\n");
    802051a0:	00003517          	auipc	a0,0x3
    802051a4:	e7850513          	addi	a0,a0,-392 # 80208018 <small_numbers+0x1bc8>
    802051a8:	ffffc097          	auipc	ra,0xffffc
    802051ac:	9ac080e7          	jalr	-1620(ra) # 80200b54 <printf>
    printf("===== 测试结束 =====\n");
    802051b0:	00003517          	auipc	a0,0x3
    802051b4:	3e850513          	addi	a0,a0,1000 # 80208598 <small_numbers+0x2148>
    802051b8:	ffffc097          	auipc	ra,0xffffc
    802051bc:	99c080e7          	jalr	-1636(ra) # 80200b54 <printf>
    printf("==================================================\n");
    802051c0:	00003517          	auipc	a0,0x3
    802051c4:	ec850513          	addi	a0,a0,-312 # 80208088 <small_numbers+0x1c38>
    802051c8:	ffffc097          	auipc	ra,0xffffc
    802051cc:	98c080e7          	jalr	-1652(ra) # 80200b54 <printf>
}
    802051d0:	0001                	nop
    802051d2:	70a2                	ld	ra,40(sp)
    802051d4:	7402                	ld	s0,32(sp)
    802051d6:	6145                	addi	sp,sp,48
    802051d8:	8082                	ret

00000000802051da <shared_buffer_init>:
static int proc_buffer = 0;
static int proc_produced = 0;

void shared_buffer_init() {
    802051da:	1141                	addi	sp,sp,-16
    802051dc:	e422                	sd	s0,8(sp)
    802051de:	0800                	addi	s0,sp,16
    proc_buffer = 0;
    802051e0:	00007797          	auipc	a5,0x7
    802051e4:	ae078793          	addi	a5,a5,-1312 # 8020bcc0 <proc_buffer>
    802051e8:	0007a023          	sw	zero,0(a5)
    proc_produced = 0;
    802051ec:	00007797          	auipc	a5,0x7
    802051f0:	ad878793          	addi	a5,a5,-1320 # 8020bcc4 <proc_produced>
    802051f4:	0007a023          	sw	zero,0(a5)
}
    802051f8:	0001                	nop
    802051fa:	6422                	ld	s0,8(sp)
    802051fc:	0141                	addi	sp,sp,16
    802051fe:	8082                	ret

0000000080205200 <producer_task>:

void producer_task(void) {
    80205200:	1141                	addi	sp,sp,-16
    80205202:	e406                	sd	ra,8(sp)
    80205204:	e022                	sd	s0,0(sp)
    80205206:	0800                	addi	s0,sp,16
    proc_buffer = 42;
    80205208:	00007797          	auipc	a5,0x7
    8020520c:	ab878793          	addi	a5,a5,-1352 # 8020bcc0 <proc_buffer>
    80205210:	02a00713          	li	a4,42
    80205214:	c398                	sw	a4,0(a5)
    proc_produced = 1;
    80205216:	00007797          	auipc	a5,0x7
    8020521a:	aae78793          	addi	a5,a5,-1362 # 8020bcc4 <proc_produced>
    8020521e:	4705                	li	a4,1
    80205220:	c398                	sw	a4,0(a5)
    wakeup(&proc_produced); // 唤醒消费者
    80205222:	00007517          	auipc	a0,0x7
    80205226:	aa250513          	addi	a0,a0,-1374 # 8020bcc4 <proc_produced>
    8020522a:	fffff097          	auipc	ra,0xfffff
    8020522e:	64c080e7          	jalr	1612(ra) # 80204876 <wakeup>
    printf("Producer: produced value %d\n", proc_buffer);
    80205232:	00007797          	auipc	a5,0x7
    80205236:	a8e78793          	addi	a5,a5,-1394 # 8020bcc0 <proc_buffer>
    8020523a:	439c                	lw	a5,0(a5)
    8020523c:	85be                	mv	a1,a5
    8020523e:	00003517          	auipc	a0,0x3
    80205242:	37a50513          	addi	a0,a0,890 # 802085b8 <small_numbers+0x2168>
    80205246:	ffffc097          	auipc	ra,0xffffc
    8020524a:	90e080e7          	jalr	-1778(ra) # 80200b54 <printf>
    exit_proc(0);
    8020524e:	4501                	li	a0,0
    80205250:	fffff097          	auipc	ra,0xfffff
    80205254:	2ea080e7          	jalr	746(ra) # 8020453a <exit_proc>
}
    80205258:	0001                	nop
    8020525a:	60a2                	ld	ra,8(sp)
    8020525c:	6402                	ld	s0,0(sp)
    8020525e:	0141                	addi	sp,sp,16
    80205260:	8082                	ret

0000000080205262 <consumer_task>:

void consumer_task(void) {
    80205262:	1141                	addi	sp,sp,-16
    80205264:	e406                	sd	ra,8(sp)
    80205266:	e022                	sd	s0,0(sp)
    80205268:	0800                	addi	s0,sp,16
    while (!proc_produced) {
    8020526a:	a809                	j	8020527c <consumer_task+0x1a>
        sleep(&proc_produced); // 等待生产者
    8020526c:	00007517          	auipc	a0,0x7
    80205270:	a5850513          	addi	a0,a0,-1448 # 8020bcc4 <proc_produced>
    80205274:	fffff097          	auipc	ra,0xfffff
    80205278:	598080e7          	jalr	1432(ra) # 8020480c <sleep>
    while (!proc_produced) {
    8020527c:	00007797          	auipc	a5,0x7
    80205280:	a4878793          	addi	a5,a5,-1464 # 8020bcc4 <proc_produced>
    80205284:	439c                	lw	a5,0(a5)
    80205286:	d3fd                	beqz	a5,8020526c <consumer_task+0xa>
    }
    printf("Consumer: consumed value %d\n", proc_buffer);
    80205288:	00007797          	auipc	a5,0x7
    8020528c:	a3878793          	addi	a5,a5,-1480 # 8020bcc0 <proc_buffer>
    80205290:	439c                	lw	a5,0(a5)
    80205292:	85be                	mv	a1,a5
    80205294:	00003517          	auipc	a0,0x3
    80205298:	34450513          	addi	a0,a0,836 # 802085d8 <small_numbers+0x2188>
    8020529c:	ffffc097          	auipc	ra,0xffffc
    802052a0:	8b8080e7          	jalr	-1864(ra) # 80200b54 <printf>
    exit_proc(0);
    802052a4:	4501                	li	a0,0
    802052a6:	fffff097          	auipc	ra,0xfffff
    802052aa:	294080e7          	jalr	660(ra) # 8020453a <exit_proc>
}
    802052ae:	0001                	nop
    802052b0:	60a2                	ld	ra,8(sp)
    802052b2:	6402                	ld	s0,0(sp)
    802052b4:	0141                	addi	sp,sp,16
    802052b6:	8082                	ret

00000000802052b8 <test_synchronization>:
void test_synchronization(void) {
    802052b8:	1141                	addi	sp,sp,-16
    802052ba:	e406                	sd	ra,8(sp)
    802052bc:	e022                	sd	s0,0(sp)
    802052be:	0800                	addi	s0,sp,16
    printf("\n==================================================\n");
    802052c0:	00003517          	auipc	a0,0x3
    802052c4:	d5850513          	addi	a0,a0,-680 # 80208018 <small_numbers+0x1bc8>
    802052c8:	ffffc097          	auipc	ra,0xffffc
    802052cc:	88c080e7          	jalr	-1908(ra) # 80200b54 <printf>
    printf("===== 测试开始: 同步机制测试 =====\n");
    802052d0:	00003517          	auipc	a0,0x3
    802052d4:	32850513          	addi	a0,a0,808 # 802085f8 <small_numbers+0x21a8>
    802052d8:	ffffc097          	auipc	ra,0xffffc
    802052dc:	87c080e7          	jalr	-1924(ra) # 80200b54 <printf>
    printf("==================================================\n");
    802052e0:	00003517          	auipc	a0,0x3
    802052e4:	da850513          	addi	a0,a0,-600 # 80208088 <small_numbers+0x1c38>
    802052e8:	ffffc097          	auipc	ra,0xffffc
    802052ec:	86c080e7          	jalr	-1940(ra) # 80200b54 <printf>

    // 初始化共享缓冲区
    shared_buffer_init();
    802052f0:	00000097          	auipc	ra,0x0
    802052f4:	eea080e7          	jalr	-278(ra) # 802051da <shared_buffer_init>

    // 创建生产者和消费者进程
    create_proc(producer_task);
    802052f8:	00000517          	auipc	a0,0x0
    802052fc:	f0850513          	addi	a0,a0,-248 # 80205200 <producer_task>
    80205300:	fffff097          	auipc	ra,0xfffff
    80205304:	1be080e7          	jalr	446(ra) # 802044be <create_proc>
    create_proc(consumer_task);
    80205308:	00000517          	auipc	a0,0x0
    8020530c:	f5a50513          	addi	a0,a0,-166 # 80205262 <consumer_task>
    80205310:	fffff097          	auipc	ra,0xfffff
    80205314:	1ae080e7          	jalr	430(ra) # 802044be <create_proc>

    // 等待两个进程完成
    wait_proc(NULL);
    80205318:	4501                	li	a0,0
    8020531a:	fffff097          	auipc	ra,0xfffff
    8020531e:	258080e7          	jalr	600(ra) # 80204572 <wait_proc>
    wait_proc(NULL);
    80205322:	4501                	li	a0,0
    80205324:	fffff097          	auipc	ra,0xfffff
    80205328:	24e080e7          	jalr	590(ra) # 80204572 <wait_proc>

    printf("Synchronization test completed\n");
    8020532c:	00003517          	auipc	a0,0x3
    80205330:	2fc50513          	addi	a0,a0,764 # 80208628 <small_numbers+0x21d8>
    80205334:	ffffc097          	auipc	ra,0xffffc
    80205338:	820080e7          	jalr	-2016(ra) # 80200b54 <printf>
    printf("==================================================\n");
    8020533c:	00003517          	auipc	a0,0x3
    80205340:	d4c50513          	addi	a0,a0,-692 # 80208088 <small_numbers+0x1c38>
    80205344:	ffffc097          	auipc	ra,0xffffc
    80205348:	810080e7          	jalr	-2032(ra) # 80200b54 <printf>
    printf("===== 测试结束 =====\n");
    8020534c:	00003517          	auipc	a0,0x3
    80205350:	24c50513          	addi	a0,a0,588 # 80208598 <small_numbers+0x2148>
    80205354:	ffffc097          	auipc	ra,0xffffc
    80205358:	800080e7          	jalr	-2048(ra) # 80200b54 <printf>
    printf("==================================================\n");
    8020535c:	00003517          	auipc	a0,0x3
    80205360:	d2c50513          	addi	a0,a0,-724 # 80208088 <small_numbers+0x1c38>
    80205364:	ffffb097          	auipc	ra,0xffffb
    80205368:	7f0080e7          	jalr	2032(ra) # 80200b54 <printf>
    8020536c:	0001                	nop
    8020536e:	60a2                	ld	ra,8(sp)
    80205370:	6402                	ld	s0,0(sp)
    80205372:	0141                	addi	sp,sp,16
    80205374:	8082                	ret

0000000080205376 <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    80205376:	7179                	addi	sp,sp,-48
    80205378:	f422                	sd	s0,40(sp)
    8020537a:	1800                	addi	s0,sp,48
    8020537c:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    80205380:	fe042623          	sw	zero,-20(s0)
    80205384:	a031                	j	80205390 <strlen+0x1a>
    80205386:	fec42783          	lw	a5,-20(s0)
    8020538a:	2785                	addiw	a5,a5,1
    8020538c:	fef42623          	sw	a5,-20(s0)
    80205390:	fec42783          	lw	a5,-20(s0)
    80205394:	fd843703          	ld	a4,-40(s0)
    80205398:	97ba                	add	a5,a5,a4
    8020539a:	0007c783          	lbu	a5,0(a5)
    8020539e:	f7e5                	bnez	a5,80205386 <strlen+0x10>
        ;
    return n;
    802053a0:	fec42783          	lw	a5,-20(s0)
}
    802053a4:	853e                	mv	a0,a5
    802053a6:	7422                	ld	s0,40(sp)
    802053a8:	6145                	addi	sp,sp,48
    802053aa:	8082                	ret

00000000802053ac <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    802053ac:	1101                	addi	sp,sp,-32
    802053ae:	ec22                	sd	s0,24(sp)
    802053b0:	1000                	addi	s0,sp,32
    802053b2:	fea43423          	sd	a0,-24(s0)
    802053b6:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    802053ba:	a819                	j	802053d0 <strcmp+0x24>
        p++, q++;
    802053bc:	fe843783          	ld	a5,-24(s0)
    802053c0:	0785                	addi	a5,a5,1
    802053c2:	fef43423          	sd	a5,-24(s0)
    802053c6:	fe043783          	ld	a5,-32(s0)
    802053ca:	0785                	addi	a5,a5,1
    802053cc:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    802053d0:	fe843783          	ld	a5,-24(s0)
    802053d4:	0007c783          	lbu	a5,0(a5)
    802053d8:	cb99                	beqz	a5,802053ee <strcmp+0x42>
    802053da:	fe843783          	ld	a5,-24(s0)
    802053de:	0007c703          	lbu	a4,0(a5)
    802053e2:	fe043783          	ld	a5,-32(s0)
    802053e6:	0007c783          	lbu	a5,0(a5)
    802053ea:	fcf709e3          	beq	a4,a5,802053bc <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    802053ee:	fe843783          	ld	a5,-24(s0)
    802053f2:	0007c783          	lbu	a5,0(a5)
    802053f6:	0007871b          	sext.w	a4,a5
    802053fa:	fe043783          	ld	a5,-32(s0)
    802053fe:	0007c783          	lbu	a5,0(a5)
    80205402:	2781                	sext.w	a5,a5
    80205404:	40f707bb          	subw	a5,a4,a5
    80205408:	2781                	sext.w	a5,a5
}
    8020540a:	853e                	mv	a0,a5
    8020540c:	6462                	ld	s0,24(sp)
    8020540e:	6105                	addi	sp,sp,32
    80205410:	8082                	ret

0000000080205412 <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    80205412:	7179                	addi	sp,sp,-48
    80205414:	f422                	sd	s0,40(sp)
    80205416:	1800                	addi	s0,sp,48
    80205418:	fca43c23          	sd	a0,-40(s0)
    8020541c:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    80205420:	fd843783          	ld	a5,-40(s0)
    80205424:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    80205428:	0001                	nop
    8020542a:	fd043703          	ld	a4,-48(s0)
    8020542e:	00170793          	addi	a5,a4,1
    80205432:	fcf43823          	sd	a5,-48(s0)
    80205436:	fd843783          	ld	a5,-40(s0)
    8020543a:	00178693          	addi	a3,a5,1
    8020543e:	fcd43c23          	sd	a3,-40(s0)
    80205442:	00074703          	lbu	a4,0(a4)
    80205446:	00e78023          	sb	a4,0(a5)
    8020544a:	0007c783          	lbu	a5,0(a5)
    8020544e:	fff1                	bnez	a5,8020542a <strcpy+0x18>
        ;
    return os;
    80205450:	fe843783          	ld	a5,-24(s0)
}
    80205454:	853e                	mv	a0,a5
    80205456:	7422                	ld	s0,40(sp)
    80205458:	6145                	addi	sp,sp,48
    8020545a:	8082                	ret

000000008020545c <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    8020545c:	7139                	addi	sp,sp,-64
    8020545e:	fc22                	sd	s0,56(sp)
    80205460:	0080                	addi	s0,sp,64
    80205462:	fca43c23          	sd	a0,-40(s0)
    80205466:	fcb43823          	sd	a1,-48(s0)
    8020546a:	87b2                	mv	a5,a2
    8020546c:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    80205470:	fd843783          	ld	a5,-40(s0)
    80205474:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    80205478:	fcc42783          	lw	a5,-52(s0)
    8020547c:	2781                	sext.w	a5,a5
    8020547e:	00f04563          	bgtz	a5,80205488 <safestrcpy+0x2c>
        return os;
    80205482:	fe843783          	ld	a5,-24(s0)
    80205486:	a0a9                	j	802054d0 <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    80205488:	0001                	nop
    8020548a:	fcc42783          	lw	a5,-52(s0)
    8020548e:	37fd                	addiw	a5,a5,-1
    80205490:	fcf42623          	sw	a5,-52(s0)
    80205494:	fcc42783          	lw	a5,-52(s0)
    80205498:	2781                	sext.w	a5,a5
    8020549a:	02f05563          	blez	a5,802054c4 <safestrcpy+0x68>
    8020549e:	fd043703          	ld	a4,-48(s0)
    802054a2:	00170793          	addi	a5,a4,1
    802054a6:	fcf43823          	sd	a5,-48(s0)
    802054aa:	fd843783          	ld	a5,-40(s0)
    802054ae:	00178693          	addi	a3,a5,1
    802054b2:	fcd43c23          	sd	a3,-40(s0)
    802054b6:	00074703          	lbu	a4,0(a4)
    802054ba:	00e78023          	sb	a4,0(a5)
    802054be:	0007c783          	lbu	a5,0(a5)
    802054c2:	f7e1                	bnez	a5,8020548a <safestrcpy+0x2e>
        ;
    *s = 0;
    802054c4:	fd843783          	ld	a5,-40(s0)
    802054c8:	00078023          	sb	zero,0(a5)
    return os;
    802054cc:	fe843783          	ld	a5,-24(s0)
    802054d0:	853e                	mv	a0,a5
    802054d2:	7462                	ld	s0,56(sp)
    802054d4:	6121                	addi	sp,sp,64
    802054d6:	8082                	ret
	...
