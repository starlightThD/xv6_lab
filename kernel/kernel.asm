
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80200000:	0000d117          	auipc	sp,0xd
    80200004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80200008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8020000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8020000c:	0000e517          	auipc	a0,0xe
    80200010:	08450513          	addi	a0,a0,132 # 8020e090 <kernel_pagetable>
        la a1,_bss_end
    80200014:	0000e597          	auipc	a1,0xe
    80200018:	6ec58593          	addi	a1,a1,1772 # 8020e700 <_bss_end>

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
    8020002c:	09c080e7          	jalr	156(ra) # 802000c4 <start>

0000000080200030 <spin>:
spin:
        j spin # 无限循环，防止程序退出
    80200030:	a001                	j	80200030 <spin>

0000000080200032 <r_sstatus>:
    80200032:	1101                	addi	sp,sp,-32 # 8020cfe0 <simple_user_task_bin+0x2218>
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
    create_user_proc(hello_world_bin,hello_world_bin_len);
    80200098:	02d00793          	li	a5,45
    8020009c:	2781                	sext.w	a5,a5
    8020009e:	85be                	mv	a1,a5
    802000a0:	00007517          	auipc	a0,0x7
    802000a4:	1e050513          	addi	a0,a0,480 # 80207280 <hello_world_bin>
    802000a8:	00005097          	auipc	ra,0x5
    802000ac:	068080e7          	jalr	104(ra) # 80205110 <create_user_proc>
	wait_proc(NULL);
    802000b0:	4501                	li	a0,0
    802000b2:	00005097          	auipc	ra,0x5
    802000b6:	7b8080e7          	jalr	1976(ra) # 8020586a <wait_proc>
}
    802000ba:	0001                	nop
    802000bc:	60a2                	ld	ra,8(sp)
    802000be:	6402                	ld	s0,0(sp)
    802000c0:	0141                	addi	sp,sp,16
    802000c2:	8082                	ret

00000000802000c4 <start>:
void start(){
    802000c4:	1101                	addi	sp,sp,-32
    802000c6:	ec06                	sd	ra,24(sp)
    802000c8:	e822                	sd	s0,16(sp)
    802000ca:	1000                	addi	s0,sp,32
	pmm_init();
    802000cc:	00003097          	auipc	ra,0x3
    802000d0:	132080e7          	jalr	306(ra) # 802031fe <pmm_init>
	kvminit();
    802000d4:	00002097          	auipc	ra,0x2
    802000d8:	706080e7          	jalr	1798(ra) # 802027da <kvminit>
	trap_init();
    802000dc:	00003097          	auipc	ra,0x3
    802000e0:	746080e7          	jalr	1862(ra) # 80203822 <trap_init>
	uart_init();
    802000e4:	00000097          	auipc	ra,0x0
    802000e8:	4c0080e7          	jalr	1216(ra) # 802005a4 <uart_init>
	intr_on();
    802000ec:	00000097          	auipc	ra,0x0
    802000f0:	f7a080e7          	jalr	-134(ra) # 80200066 <intr_on>
    printf("===============================================\n");
    802000f4:	00007517          	auipc	a0,0x7
    802000f8:	2dc50513          	addi	a0,a0,732 # 802073d0 <simple_user_task_bin+0x108>
    802000fc:	00001097          	auipc	ra,0x1
    80200100:	b98080e7          	jalr	-1128(ra) # 80200c94 <printf>
    printf("        RISC-V Operating System v1.0         \n");
    80200104:	00007517          	auipc	a0,0x7
    80200108:	30450513          	addi	a0,a0,772 # 80207408 <simple_user_task_bin+0x140>
    8020010c:	00001097          	auipc	ra,0x1
    80200110:	b88080e7          	jalr	-1144(ra) # 80200c94 <printf>
    printf("===============================================\n\n");
    80200114:	00007517          	auipc	a0,0x7
    80200118:	32450513          	addi	a0,a0,804 # 80207438 <simple_user_task_bin+0x170>
    8020011c:	00001097          	auipc	ra,0x1
    80200120:	b78080e7          	jalr	-1160(ra) # 80200c94 <printf>
	init_proc(); // 初始化进程管理子系统
    80200124:	00005097          	auipc	ra,0x5
    80200128:	b4c080e7          	jalr	-1204(ra) # 80204c70 <init_proc>
	int main_pid = create_kernel_proc(kernel_main);
    8020012c:	00000517          	auipc	a0,0x0
    80200130:	3d250513          	addi	a0,a0,978 # 802004fe <kernel_main>
    80200134:	00005097          	auipc	ra,0x5
    80200138:	f6e080e7          	jalr	-146(ra) # 802050a2 <create_kernel_proc>
    8020013c:	87aa                	mv	a5,a0
    8020013e:	fef42623          	sw	a5,-20(s0)
	if (main_pid < 0){
    80200142:	fec42783          	lw	a5,-20(s0)
    80200146:	2781                	sext.w	a5,a5
    80200148:	0007da63          	bgez	a5,8020015c <start+0x98>
		panic("START: create main process failed!\n");
    8020014c:	00007517          	auipc	a0,0x7
    80200150:	32450513          	addi	a0,a0,804 # 80207470 <simple_user_task_bin+0x1a8>
    80200154:	00001097          	auipc	ra,0x1
    80200158:	58c080e7          	jalr	1420(ra) # 802016e0 <panic>
	schedule();
    8020015c:	00005097          	auipc	ra,0x5
    80200160:	3a6080e7          	jalr	934(ra) # 80205502 <schedule>
    panic("START: main() exit unexpectedly!!!\n");
    80200164:	00007517          	auipc	a0,0x7
    80200168:	33450513          	addi	a0,a0,820 # 80207498 <simple_user_task_bin+0x1d0>
    8020016c:	00001097          	auipc	ra,0x1
    80200170:	574080e7          	jalr	1396(ra) # 802016e0 <panic>
}
    80200174:	0001                	nop
    80200176:	60e2                	ld	ra,24(sp)
    80200178:	6442                	ld	s0,16(sp)
    8020017a:	6105                	addi	sp,sp,32
    8020017c:	8082                	ret

000000008020017e <console>:
void console(void) {
    8020017e:	7129                	addi	sp,sp,-320
    80200180:	fe06                	sd	ra,312(sp)
    80200182:	fa22                	sd	s0,304(sp)
    80200184:	0280                	addi	s0,sp,320
    int exit_requested = 0;
    80200186:	fe042623          	sw	zero,-20(s0)
    printf("可用命令:\n");
    8020018a:	00007517          	auipc	a0,0x7
    8020018e:	33650513          	addi	a0,a0,822 # 802074c0 <simple_user_task_bin+0x1f8>
    80200192:	00001097          	auipc	ra,0x1
    80200196:	b02080e7          	jalr	-1278(ra) # 80200c94 <printf>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    8020019a:	fe042423          	sw	zero,-24(s0)
    8020019e:	a0b9                	j	802001ec <console+0x6e>
        printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
    802001a0:	0000e697          	auipc	a3,0xe
    802001a4:	e6068693          	addi	a3,a3,-416 # 8020e000 <command_table>
    802001a8:	fe842703          	lw	a4,-24(s0)
    802001ac:	87ba                	mv	a5,a4
    802001ae:	0786                	slli	a5,a5,0x1
    802001b0:	97ba                	add	a5,a5,a4
    802001b2:	078e                	slli	a5,a5,0x3
    802001b4:	97b6                	add	a5,a5,a3
    802001b6:	638c                	ld	a1,0(a5)
    802001b8:	0000e697          	auipc	a3,0xe
    802001bc:	e4868693          	addi	a3,a3,-440 # 8020e000 <command_table>
    802001c0:	fe842703          	lw	a4,-24(s0)
    802001c4:	87ba                	mv	a5,a4
    802001c6:	0786                	slli	a5,a5,0x1
    802001c8:	97ba                	add	a5,a5,a4
    802001ca:	078e                	slli	a5,a5,0x3
    802001cc:	97b6                	add	a5,a5,a3
    802001ce:	6b9c                	ld	a5,16(a5)
    802001d0:	863e                	mv	a2,a5
    802001d2:	00007517          	auipc	a0,0x7
    802001d6:	2fe50513          	addi	a0,a0,766 # 802074d0 <simple_user_task_bin+0x208>
    802001da:	00001097          	auipc	ra,0x1
    802001de:	aba080e7          	jalr	-1350(ra) # 80200c94 <printf>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    802001e2:	fe842783          	lw	a5,-24(s0)
    802001e6:	2785                	addiw	a5,a5,1
    802001e8:	fef42423          	sw	a5,-24(s0)
    802001ec:	fe842783          	lw	a5,-24(s0)
    802001f0:	873e                	mv	a4,a5
    802001f2:	4791                	li	a5,4
    802001f4:	fae7f6e3          	bgeu	a5,a4,802001a0 <console+0x22>
    printf("  help          - 显示此帮助\n");
    802001f8:	00007517          	auipc	a0,0x7
    802001fc:	2e850513          	addi	a0,a0,744 # 802074e0 <simple_user_task_bin+0x218>
    80200200:	00001097          	auipc	ra,0x1
    80200204:	a94080e7          	jalr	-1388(ra) # 80200c94 <printf>
    printf("  exit          - 退出控制台\n");
    80200208:	00007517          	auipc	a0,0x7
    8020020c:	30050513          	addi	a0,a0,768 # 80207508 <simple_user_task_bin+0x240>
    80200210:	00001097          	auipc	ra,0x1
    80200214:	a84080e7          	jalr	-1404(ra) # 80200c94 <printf>
    printf("  ps            - 显示进程状态\n");
    80200218:	00007517          	auipc	a0,0x7
    8020021c:	31850513          	addi	a0,a0,792 # 80207530 <simple_user_task_bin+0x268>
    80200220:	00001097          	auipc	ra,0x1
    80200224:	a74080e7          	jalr	-1420(ra) # 80200c94 <printf>
    while (!exit_requested) {
    80200228:	ac4d                	j	802004da <console+0x35c>
        printf("Console >>> ");
    8020022a:	00007517          	auipc	a0,0x7
    8020022e:	32e50513          	addi	a0,a0,814 # 80207558 <simple_user_task_bin+0x290>
    80200232:	00001097          	auipc	ra,0x1
    80200236:	a62080e7          	jalr	-1438(ra) # 80200c94 <printf>
        readline(input_buffer, sizeof(input_buffer));
    8020023a:	ed040793          	addi	a5,s0,-304
    8020023e:	10000593          	li	a1,256
    80200242:	853e                	mv	a0,a5
    80200244:	00000097          	auipc	ra,0x0
    80200248:	742080e7          	jalr	1858(ra) # 80200986 <readline>
        if (strcmp(input_buffer, "exit") == 0) {
    8020024c:	ed040793          	addi	a5,s0,-304
    80200250:	00007597          	auipc	a1,0x7
    80200254:	31858593          	addi	a1,a1,792 # 80207568 <simple_user_task_bin+0x2a0>
    80200258:	853e                	mv	a0,a5
    8020025a:	00006097          	auipc	ra,0x6
    8020025e:	98c080e7          	jalr	-1652(ra) # 80205be6 <strcmp>
    80200262:	87aa                	mv	a5,a0
    80200264:	e789                	bnez	a5,8020026e <console+0xf0>
            exit_requested = 1;
    80200266:	4785                	li	a5,1
    80200268:	fef42623          	sw	a5,-20(s0)
    8020026c:	a4bd                	j	802004da <console+0x35c>
        } else if (strcmp(input_buffer, "help") == 0) {
    8020026e:	ed040793          	addi	a5,s0,-304
    80200272:	00007597          	auipc	a1,0x7
    80200276:	2fe58593          	addi	a1,a1,766 # 80207570 <simple_user_task_bin+0x2a8>
    8020027a:	853e                	mv	a0,a5
    8020027c:	00006097          	auipc	ra,0x6
    80200280:	96a080e7          	jalr	-1686(ra) # 80205be6 <strcmp>
    80200284:	87aa                	mv	a5,a0
    80200286:	e3cd                	bnez	a5,80200328 <console+0x1aa>
            printf("可用命令:\n");
    80200288:	00007517          	auipc	a0,0x7
    8020028c:	23850513          	addi	a0,a0,568 # 802074c0 <simple_user_task_bin+0x1f8>
    80200290:	00001097          	auipc	ra,0x1
    80200294:	a04080e7          	jalr	-1532(ra) # 80200c94 <printf>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    80200298:	fe042223          	sw	zero,-28(s0)
    8020029c:	a0b9                	j	802002ea <console+0x16c>
                printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
    8020029e:	0000e697          	auipc	a3,0xe
    802002a2:	d6268693          	addi	a3,a3,-670 # 8020e000 <command_table>
    802002a6:	fe442703          	lw	a4,-28(s0)
    802002aa:	87ba                	mv	a5,a4
    802002ac:	0786                	slli	a5,a5,0x1
    802002ae:	97ba                	add	a5,a5,a4
    802002b0:	078e                	slli	a5,a5,0x3
    802002b2:	97b6                	add	a5,a5,a3
    802002b4:	638c                	ld	a1,0(a5)
    802002b6:	0000e697          	auipc	a3,0xe
    802002ba:	d4a68693          	addi	a3,a3,-694 # 8020e000 <command_table>
    802002be:	fe442703          	lw	a4,-28(s0)
    802002c2:	87ba                	mv	a5,a4
    802002c4:	0786                	slli	a5,a5,0x1
    802002c6:	97ba                	add	a5,a5,a4
    802002c8:	078e                	slli	a5,a5,0x3
    802002ca:	97b6                	add	a5,a5,a3
    802002cc:	6b9c                	ld	a5,16(a5)
    802002ce:	863e                	mv	a2,a5
    802002d0:	00007517          	auipc	a0,0x7
    802002d4:	20050513          	addi	a0,a0,512 # 802074d0 <simple_user_task_bin+0x208>
    802002d8:	00001097          	auipc	ra,0x1
    802002dc:	9bc080e7          	jalr	-1604(ra) # 80200c94 <printf>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    802002e0:	fe442783          	lw	a5,-28(s0)
    802002e4:	2785                	addiw	a5,a5,1
    802002e6:	fef42223          	sw	a5,-28(s0)
    802002ea:	fe442783          	lw	a5,-28(s0)
    802002ee:	873e                	mv	a4,a5
    802002f0:	4791                	li	a5,4
    802002f2:	fae7f6e3          	bgeu	a5,a4,8020029e <console+0x120>
            printf("  help          - 显示此帮助\n");
    802002f6:	00007517          	auipc	a0,0x7
    802002fa:	1ea50513          	addi	a0,a0,490 # 802074e0 <simple_user_task_bin+0x218>
    802002fe:	00001097          	auipc	ra,0x1
    80200302:	996080e7          	jalr	-1642(ra) # 80200c94 <printf>
            printf("  exit          - 退出控制台\n");
    80200306:	00007517          	auipc	a0,0x7
    8020030a:	20250513          	addi	a0,a0,514 # 80207508 <simple_user_task_bin+0x240>
    8020030e:	00001097          	auipc	ra,0x1
    80200312:	986080e7          	jalr	-1658(ra) # 80200c94 <printf>
            printf("  ps            - 显示进程状态\n");
    80200316:	00007517          	auipc	a0,0x7
    8020031a:	21a50513          	addi	a0,a0,538 # 80207530 <simple_user_task_bin+0x268>
    8020031e:	00001097          	auipc	ra,0x1
    80200322:	976080e7          	jalr	-1674(ra) # 80200c94 <printf>
    80200326:	aa55                	j	802004da <console+0x35c>
        } else if (strcmp(input_buffer, "ps") == 0) {
    80200328:	ed040793          	addi	a5,s0,-304
    8020032c:	00007597          	auipc	a1,0x7
    80200330:	24c58593          	addi	a1,a1,588 # 80207578 <simple_user_task_bin+0x2b0>
    80200334:	853e                	mv	a0,a5
    80200336:	00006097          	auipc	ra,0x6
    8020033a:	8b0080e7          	jalr	-1872(ra) # 80205be6 <strcmp>
    8020033e:	87aa                	mv	a5,a0
    80200340:	e791                	bnez	a5,8020034c <console+0x1ce>
            print_proc_table();
    80200342:	00005097          	auipc	ra,0x5
    80200346:	6b6080e7          	jalr	1718(ra) # 802059f8 <print_proc_table>
    8020034a:	aa41                	j	802004da <console+0x35c>
            int found = 0;
    8020034c:	fe042023          	sw	zero,-32(s0)
            for (int i = 0; i < COMMAND_COUNT; i++) {
    80200350:	fc042e23          	sw	zero,-36(s0)
    80200354:	aa99                	j	802004aa <console+0x32c>
                if (strcmp(input_buffer, command_table[i].name) == 0) {
    80200356:	0000e697          	auipc	a3,0xe
    8020035a:	caa68693          	addi	a3,a3,-854 # 8020e000 <command_table>
    8020035e:	fdc42703          	lw	a4,-36(s0)
    80200362:	87ba                	mv	a5,a4
    80200364:	0786                	slli	a5,a5,0x1
    80200366:	97ba                	add	a5,a5,a4
    80200368:	078e                	slli	a5,a5,0x3
    8020036a:	97b6                	add	a5,a5,a3
    8020036c:	6398                	ld	a4,0(a5)
    8020036e:	ed040793          	addi	a5,s0,-304
    80200372:	85ba                	mv	a1,a4
    80200374:	853e                	mv	a0,a5
    80200376:	00006097          	auipc	ra,0x6
    8020037a:	870080e7          	jalr	-1936(ra) # 80205be6 <strcmp>
    8020037e:	87aa                	mv	a5,a0
    80200380:	12079063          	bnez	a5,802004a0 <console+0x322>
                    int pid = create_kernel_proc(command_table[i].func);
    80200384:	0000e697          	auipc	a3,0xe
    80200388:	c7c68693          	addi	a3,a3,-900 # 8020e000 <command_table>
    8020038c:	fdc42703          	lw	a4,-36(s0)
    80200390:	87ba                	mv	a5,a4
    80200392:	0786                	slli	a5,a5,0x1
    80200394:	97ba                	add	a5,a5,a4
    80200396:	078e                	slli	a5,a5,0x3
    80200398:	97b6                	add	a5,a5,a3
    8020039a:	679c                	ld	a5,8(a5)
    8020039c:	853e                	mv	a0,a5
    8020039e:	00005097          	auipc	ra,0x5
    802003a2:	d04080e7          	jalr	-764(ra) # 802050a2 <create_kernel_proc>
    802003a6:	87aa                	mv	a5,a0
    802003a8:	fcf42c23          	sw	a5,-40(s0)
                    if (pid < 0) {
    802003ac:	fd842783          	lw	a5,-40(s0)
    802003b0:	2781                	sext.w	a5,a5
    802003b2:	0207d863          	bgez	a5,802003e2 <console+0x264>
                        printf("创建%s进程失败\n", command_table[i].name);
    802003b6:	0000e697          	auipc	a3,0xe
    802003ba:	c4a68693          	addi	a3,a3,-950 # 8020e000 <command_table>
    802003be:	fdc42703          	lw	a4,-36(s0)
    802003c2:	87ba                	mv	a5,a4
    802003c4:	0786                	slli	a5,a5,0x1
    802003c6:	97ba                	add	a5,a5,a4
    802003c8:	078e                	slli	a5,a5,0x3
    802003ca:	97b6                	add	a5,a5,a3
    802003cc:	639c                	ld	a5,0(a5)
    802003ce:	85be                	mv	a1,a5
    802003d0:	00007517          	auipc	a0,0x7
    802003d4:	1b050513          	addi	a0,a0,432 # 80207580 <simple_user_task_bin+0x2b8>
    802003d8:	00001097          	auipc	ra,0x1
    802003dc:	8bc080e7          	jalr	-1860(ra) # 80200c94 <printf>
    802003e0:	a865                	j	80200498 <console+0x31a>
                        printf("创建%s进程成功，PID: %d\n", command_table[i].name, pid);
    802003e2:	0000e697          	auipc	a3,0xe
    802003e6:	c1e68693          	addi	a3,a3,-994 # 8020e000 <command_table>
    802003ea:	fdc42703          	lw	a4,-36(s0)
    802003ee:	87ba                	mv	a5,a4
    802003f0:	0786                	slli	a5,a5,0x1
    802003f2:	97ba                	add	a5,a5,a4
    802003f4:	078e                	slli	a5,a5,0x3
    802003f6:	97b6                	add	a5,a5,a3
    802003f8:	639c                	ld	a5,0(a5)
    802003fa:	fd842703          	lw	a4,-40(s0)
    802003fe:	863a                	mv	a2,a4
    80200400:	85be                	mv	a1,a5
    80200402:	00007517          	auipc	a0,0x7
    80200406:	19650513          	addi	a0,a0,406 # 80207598 <simple_user_task_bin+0x2d0>
    8020040a:	00001097          	auipc	ra,0x1
    8020040e:	88a080e7          	jalr	-1910(ra) # 80200c94 <printf>
                        int waited_pid = wait_proc(&status);
    80200412:	ecc40793          	addi	a5,s0,-308
    80200416:	853e                	mv	a0,a5
    80200418:	00005097          	auipc	ra,0x5
    8020041c:	452080e7          	jalr	1106(ra) # 8020586a <wait_proc>
    80200420:	87aa                	mv	a5,a0
    80200422:	fcf42a23          	sw	a5,-44(s0)
                        if (waited_pid == pid) {
    80200426:	fd442783          	lw	a5,-44(s0)
    8020042a:	873e                	mv	a4,a5
    8020042c:	fd842783          	lw	a5,-40(s0)
    80200430:	2701                	sext.w	a4,a4
    80200432:	2781                	sext.w	a5,a5
    80200434:	02f71d63          	bne	a4,a5,8020046e <console+0x2f0>
                            printf("%s进程(PID: %d)已退出，状态码: %d\n", command_table[i].name, pid, status);
    80200438:	0000e697          	auipc	a3,0xe
    8020043c:	bc868693          	addi	a3,a3,-1080 # 8020e000 <command_table>
    80200440:	fdc42703          	lw	a4,-36(s0)
    80200444:	87ba                	mv	a5,a4
    80200446:	0786                	slli	a5,a5,0x1
    80200448:	97ba                	add	a5,a5,a4
    8020044a:	078e                	slli	a5,a5,0x3
    8020044c:	97b6                	add	a5,a5,a3
    8020044e:	639c                	ld	a5,0(a5)
    80200450:	ecc42683          	lw	a3,-308(s0)
    80200454:	fd842703          	lw	a4,-40(s0)
    80200458:	863a                	mv	a2,a4
    8020045a:	85be                	mv	a1,a5
    8020045c:	00007517          	auipc	a0,0x7
    80200460:	15c50513          	addi	a0,a0,348 # 802075b8 <simple_user_task_bin+0x2f0>
    80200464:	00001097          	auipc	ra,0x1
    80200468:	830080e7          	jalr	-2000(ra) # 80200c94 <printf>
    8020046c:	a035                	j	80200498 <console+0x31a>
                            printf("等待%s进程时发生错误\n", command_table[i].name);
    8020046e:	0000e697          	auipc	a3,0xe
    80200472:	b9268693          	addi	a3,a3,-1134 # 8020e000 <command_table>
    80200476:	fdc42703          	lw	a4,-36(s0)
    8020047a:	87ba                	mv	a5,a4
    8020047c:	0786                	slli	a5,a5,0x1
    8020047e:	97ba                	add	a5,a5,a4
    80200480:	078e                	slli	a5,a5,0x3
    80200482:	97b6                	add	a5,a5,a3
    80200484:	639c                	ld	a5,0(a5)
    80200486:	85be                	mv	a1,a5
    80200488:	00007517          	auipc	a0,0x7
    8020048c:	16050513          	addi	a0,a0,352 # 802075e8 <simple_user_task_bin+0x320>
    80200490:	00001097          	auipc	ra,0x1
    80200494:	804080e7          	jalr	-2044(ra) # 80200c94 <printf>
                    found = 1;
    80200498:	4785                	li	a5,1
    8020049a:	fef42023          	sw	a5,-32(s0)
                    break;
    8020049e:	a821                	j	802004b6 <console+0x338>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    802004a0:	fdc42783          	lw	a5,-36(s0)
    802004a4:	2785                	addiw	a5,a5,1
    802004a6:	fcf42e23          	sw	a5,-36(s0)
    802004aa:	fdc42783          	lw	a5,-36(s0)
    802004ae:	873e                	mv	a4,a5
    802004b0:	4791                	li	a5,4
    802004b2:	eae7f2e3          	bgeu	a5,a4,80200356 <console+0x1d8>
            if (!found && input_buffer[0] != '\0') {
    802004b6:	fe042783          	lw	a5,-32(s0)
    802004ba:	2781                	sext.w	a5,a5
    802004bc:	ef99                	bnez	a5,802004da <console+0x35c>
    802004be:	ed044783          	lbu	a5,-304(s0)
    802004c2:	cf81                	beqz	a5,802004da <console+0x35c>
                printf("无效命令: %s\n", input_buffer);
    802004c4:	ed040793          	addi	a5,s0,-304
    802004c8:	85be                	mv	a1,a5
    802004ca:	00007517          	auipc	a0,0x7
    802004ce:	13e50513          	addi	a0,a0,318 # 80207608 <simple_user_task_bin+0x340>
    802004d2:	00000097          	auipc	ra,0x0
    802004d6:	7c2080e7          	jalr	1986(ra) # 80200c94 <printf>
    while (!exit_requested) {
    802004da:	fec42783          	lw	a5,-20(s0)
    802004de:	2781                	sext.w	a5,a5
    802004e0:	d40785e3          	beqz	a5,8020022a <console+0xac>
    printf("控制台进程退出\n");
    802004e4:	00007517          	auipc	a0,0x7
    802004e8:	13c50513          	addi	a0,a0,316 # 80207620 <simple_user_task_bin+0x358>
    802004ec:	00000097          	auipc	ra,0x0
    802004f0:	7a8080e7          	jalr	1960(ra) # 80200c94 <printf>
    return;
    802004f4:	0001                	nop
}
    802004f6:	70f2                	ld	ra,312(sp)
    802004f8:	7452                	ld	s0,304(sp)
    802004fa:	6131                	addi	sp,sp,320
    802004fc:	8082                	ret

00000000802004fe <kernel_main>:
void kernel_main(void){
    802004fe:	1101                	addi	sp,sp,-32
    80200500:	ec06                	sd	ra,24(sp)
    80200502:	e822                	sd	s0,16(sp)
    80200504:	1000                	addi	s0,sp,32
	clear_screen();
    80200506:	00001097          	auipc	ra,0x1
    8020050a:	ca6080e7          	jalr	-858(ra) # 802011ac <clear_screen>
	int console_pid = create_kernel_proc(console);
    8020050e:	00000517          	auipc	a0,0x0
    80200512:	c7050513          	addi	a0,a0,-912 # 8020017e <console>
    80200516:	00005097          	auipc	ra,0x5
    8020051a:	b8c080e7          	jalr	-1140(ra) # 802050a2 <create_kernel_proc>
    8020051e:	87aa                	mv	a5,a0
    80200520:	fef42623          	sw	a5,-20(s0)
	if (console_pid < 0){
    80200524:	fec42783          	lw	a5,-20(s0)
    80200528:	2781                	sext.w	a5,a5
    8020052a:	0007db63          	bgez	a5,80200540 <kernel_main+0x42>
		panic("KERNEL_MAIN: create console process failed!\n");
    8020052e:	00007517          	auipc	a0,0x7
    80200532:	10a50513          	addi	a0,a0,266 # 80207638 <simple_user_task_bin+0x370>
    80200536:	00001097          	auipc	ra,0x1
    8020053a:	1aa080e7          	jalr	426(ra) # 802016e0 <panic>
    8020053e:	a821                	j	80200556 <kernel_main+0x58>
		printf("KERNEL_MAIN: console process created with PID %d\n", console_pid);
    80200540:	fec42783          	lw	a5,-20(s0)
    80200544:	85be                	mv	a1,a5
    80200546:	00007517          	auipc	a0,0x7
    8020054a:	12250513          	addi	a0,a0,290 # 80207668 <simple_user_task_bin+0x3a0>
    8020054e:	00000097          	auipc	ra,0x0
    80200552:	746080e7          	jalr	1862(ra) # 80200c94 <printf>
	int pid = wait_proc(&status);
    80200556:	fe440793          	addi	a5,s0,-28
    8020055a:	853e                	mv	a0,a5
    8020055c:	00005097          	auipc	ra,0x5
    80200560:	30e080e7          	jalr	782(ra) # 8020586a <wait_proc>
    80200564:	87aa                	mv	a5,a0
    80200566:	fef42423          	sw	a5,-24(s0)
	if(pid != console_pid){
    8020056a:	fe842783          	lw	a5,-24(s0)
    8020056e:	873e                	mv	a4,a5
    80200570:	fec42783          	lw	a5,-20(s0)
    80200574:	2701                	sext.w	a4,a4
    80200576:	2781                	sext.w	a5,a5
    80200578:	02f70163          	beq	a4,a5,8020059a <kernel_main+0x9c>
		printf("KERNEL_MAIN: unexpected process %d exited with status %d\n", pid, status);
    8020057c:	fe442703          	lw	a4,-28(s0)
    80200580:	fe842783          	lw	a5,-24(s0)
    80200584:	863a                	mv	a2,a4
    80200586:	85be                	mv	a1,a5
    80200588:	00007517          	auipc	a0,0x7
    8020058c:	11850513          	addi	a0,a0,280 # 802076a0 <simple_user_task_bin+0x3d8>
    80200590:	00000097          	auipc	ra,0x0
    80200594:	704080e7          	jalr	1796(ra) # 80200c94 <printf>
	return;
    80200598:	0001                	nop
    8020059a:	0001                	nop
    8020059c:	60e2                	ld	ra,24(sp)
    8020059e:	6442                	ld	s0,16(sp)
    802005a0:	6105                	addi	sp,sp,32
    802005a2:	8082                	ret

00000000802005a4 <uart_init>:
#include "defs.h"
#define LINE_BUF_SIZE 128
struct uart_input_buf_t uart_input_buf;
// UART初始化函数
void uart_init(void) {
    802005a4:	1141                	addi	sp,sp,-16
    802005a6:	e406                	sd	ra,8(sp)
    802005a8:	e022                	sd	s0,0(sp)
    802005aa:	0800                	addi	s0,sp,16

    WriteReg(IER, 0x00);
    802005ac:	100007b7          	lui	a5,0x10000
    802005b0:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    802005b2:	00078023          	sb	zero,0(a5)
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    802005b6:	100007b7          	lui	a5,0x10000
    802005ba:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x701ffffe>
    802005bc:	471d                	li	a4,7
    802005be:	00e78023          	sb	a4,0(a5)
    WriteReg(IER, IER_RX_ENABLE);
    802005c2:	100007b7          	lui	a5,0x10000
    802005c6:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    802005c8:	4705                	li	a4,1
    802005ca:	00e78023          	sb	a4,0(a5)
    register_interrupt(UART0_IRQ, uart_intr);//注册键盘输入的中断处理函数
    802005ce:	00000597          	auipc	a1,0x0
    802005d2:	12858593          	addi	a1,a1,296 # 802006f6 <uart_intr>
    802005d6:	4529                	li	a0,10
    802005d8:	00003097          	auipc	ra,0x3
    802005dc:	0c6080e7          	jalr	198(ra) # 8020369e <register_interrupt>
    enable_interrupts(UART0_IRQ);
    802005e0:	4529                	li	a0,10
    802005e2:	00003097          	auipc	ra,0x3
    802005e6:	146080e7          	jalr	326(ra) # 80203728 <enable_interrupts>
    printf("UART initialized with input support\n");
    802005ea:	00007517          	auipc	a0,0x7
    802005ee:	34650513          	addi	a0,a0,838 # 80207930 <simple_user_task_bin+0x58>
    802005f2:	00000097          	auipc	ra,0x0
    802005f6:	6a2080e7          	jalr	1698(ra) # 80200c94 <printf>
}
    802005fa:	0001                	nop
    802005fc:	60a2                	ld	ra,8(sp)
    802005fe:	6402                	ld	s0,0(sp)
    80200600:	0141                	addi	sp,sp,16
    80200602:	8082                	ret

0000000080200604 <uart_putc>:

// 发送单个字符
void uart_putc(char c) {
    80200604:	1101                	addi	sp,sp,-32
    80200606:	ec22                	sd	s0,24(sp)
    80200608:	1000                	addi	s0,sp,32
    8020060a:	87aa                	mv	a5,a0
    8020060c:	fef407a3          	sb	a5,-17(s0)
    // 等待发送缓冲区空闲
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80200610:	0001                	nop
    80200612:	100007b7          	lui	a5,0x10000
    80200616:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200618:	0007c783          	lbu	a5,0(a5)
    8020061c:	0ff7f793          	zext.b	a5,a5
    80200620:	2781                	sext.w	a5,a5
    80200622:	0207f793          	andi	a5,a5,32
    80200626:	2781                	sext.w	a5,a5
    80200628:	d7ed                	beqz	a5,80200612 <uart_putc+0xe>
    WriteReg(THR, c);
    8020062a:	100007b7          	lui	a5,0x10000
    8020062e:	fef44703          	lbu	a4,-17(s0)
    80200632:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
}
    80200636:	0001                	nop
    80200638:	6462                	ld	s0,24(sp)
    8020063a:	6105                	addi	sp,sp,32
    8020063c:	8082                	ret

000000008020063e <uart_puts>:

void uart_puts(char *s) {
    8020063e:	7179                	addi	sp,sp,-48
    80200640:	f422                	sd	s0,40(sp)
    80200642:	1800                	addi	s0,sp,48
    80200644:	fca43c23          	sd	a0,-40(s0)
    if (!s) return;
    80200648:	fd843783          	ld	a5,-40(s0)
    8020064c:	c7b5                	beqz	a5,802006b8 <uart_puts+0x7a>
    
    while (*s) {
    8020064e:	a8b9                	j	802006ac <uart_puts+0x6e>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    80200650:	0001                	nop
    80200652:	100007b7          	lui	a5,0x10000
    80200656:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200658:	0007c783          	lbu	a5,0(a5)
    8020065c:	0ff7f793          	zext.b	a5,a5
    80200660:	2781                	sext.w	a5,a5
    80200662:	0207f793          	andi	a5,a5,32
    80200666:	2781                	sext.w	a5,a5
    80200668:	d7ed                	beqz	a5,80200652 <uart_puts+0x14>
        int sent_count = 0;
    8020066a:	fe042623          	sw	zero,-20(s0)
        while (*s && sent_count < 4) { 
    8020066e:	a01d                	j	80200694 <uart_puts+0x56>
            WriteReg(THR, *s);
    80200670:	100007b7          	lui	a5,0x10000
    80200674:	fd843703          	ld	a4,-40(s0)
    80200678:	00074703          	lbu	a4,0(a4)
    8020067c:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
            s++;
    80200680:	fd843783          	ld	a5,-40(s0)
    80200684:	0785                	addi	a5,a5,1
    80200686:	fcf43c23          	sd	a5,-40(s0)
            sent_count++;
    8020068a:	fec42783          	lw	a5,-20(s0)
    8020068e:	2785                	addiw	a5,a5,1
    80200690:	fef42623          	sw	a5,-20(s0)
        while (*s && sent_count < 4) { 
    80200694:	fd843783          	ld	a5,-40(s0)
    80200698:	0007c783          	lbu	a5,0(a5)
    8020069c:	cb81                	beqz	a5,802006ac <uart_puts+0x6e>
    8020069e:	fec42783          	lw	a5,-20(s0)
    802006a2:	0007871b          	sext.w	a4,a5
    802006a6:	478d                	li	a5,3
    802006a8:	fce7d4e3          	bge	a5,a4,80200670 <uart_puts+0x32>
    while (*s) {
    802006ac:	fd843783          	ld	a5,-40(s0)
    802006b0:	0007c783          	lbu	a5,0(a5)
    802006b4:	ffd1                	bnez	a5,80200650 <uart_puts+0x12>
    802006b6:	a011                	j	802006ba <uart_puts+0x7c>
    if (!s) return;
    802006b8:	0001                	nop
        }
    }
}
    802006ba:	7422                	ld	s0,40(sp)
    802006bc:	6145                	addi	sp,sp,48
    802006be:	8082                	ret

00000000802006c0 <uart_getc>:

int uart_getc(void) {
    802006c0:	1141                	addi	sp,sp,-16
    802006c2:	e422                	sd	s0,8(sp)
    802006c4:	0800                	addi	s0,sp,16
    if ((ReadReg(LSR) & LSR_RX_READY) == 0)
    802006c6:	100007b7          	lui	a5,0x10000
    802006ca:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    802006cc:	0007c783          	lbu	a5,0(a5)
    802006d0:	0ff7f793          	zext.b	a5,a5
    802006d4:	2781                	sext.w	a5,a5
    802006d6:	8b85                	andi	a5,a5,1
    802006d8:	2781                	sext.w	a5,a5
    802006da:	e399                	bnez	a5,802006e0 <uart_getc+0x20>
        return -1; 
    802006dc:	57fd                	li	a5,-1
    802006de:	a801                	j	802006ee <uart_getc+0x2e>
    return ReadReg(RHR); 
    802006e0:	100007b7          	lui	a5,0x10000
    802006e4:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    802006e8:	0ff7f793          	zext.b	a5,a5
    802006ec:	2781                	sext.w	a5,a5
}
    802006ee:	853e                	mv	a0,a5
    802006f0:	6422                	ld	s0,8(sp)
    802006f2:	0141                	addi	sp,sp,16
    802006f4:	8082                	ret

00000000802006f6 <uart_intr>:

void uart_intr(void) {
    802006f6:	1101                	addi	sp,sp,-32
    802006f8:	ec06                	sd	ra,24(sp)
    802006fa:	e822                	sd	s0,16(sp)
    802006fc:	1000                	addi	s0,sp,32
    static char linebuf[LINE_BUF_SIZE];
    static int line_len = 0;

    while (ReadReg(LSR) & LSR_RX_READY) {
    802006fe:	a2f5                	j	802008ea <uart_intr+0x1f4>
        char c = ReadReg(RHR);
    80200700:	100007b7          	lui	a5,0x10000
    80200704:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    80200708:	fef405a3          	sb	a5,-21(s0)

        if (c == '\r' || c == '\n') {
    8020070c:	feb44783          	lbu	a5,-21(s0)
    80200710:	0ff7f713          	zext.b	a4,a5
    80200714:	47b5                	li	a5,13
    80200716:	00f70963          	beq	a4,a5,80200728 <uart_intr+0x32>
    8020071a:	feb44783          	lbu	a5,-21(s0)
    8020071e:	0ff7f713          	zext.b	a4,a5
    80200722:	47a9                	li	a5,10
    80200724:	10f71763          	bne	a4,a5,80200832 <uart_intr+0x13c>
            uart_putc('\n');
    80200728:	4529                	li	a0,10
    8020072a:	00000097          	auipc	ra,0x0
    8020072e:	eda080e7          	jalr	-294(ra) # 80200604 <uart_putc>
            // 将编辑好的整行写入全局缓冲区
            for (int i = 0; i < line_len; i++) {
    80200732:	fe042623          	sw	zero,-20(s0)
    80200736:	a8b5                	j	802007b2 <uart_intr+0xbc>
                int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    80200738:	0000e797          	auipc	a5,0xe
    8020073c:	98878793          	addi	a5,a5,-1656 # 8020e0c0 <uart_input_buf>
    80200740:	0847a783          	lw	a5,132(a5)
    80200744:	2785                	addiw	a5,a5,1
    80200746:	2781                	sext.w	a5,a5
    80200748:	2781                	sext.w	a5,a5
    8020074a:	07f7f793          	andi	a5,a5,127
    8020074e:	fef42023          	sw	a5,-32(s0)
                if (next != uart_input_buf.r) {
    80200752:	0000e797          	auipc	a5,0xe
    80200756:	96e78793          	addi	a5,a5,-1682 # 8020e0c0 <uart_input_buf>
    8020075a:	0807a703          	lw	a4,128(a5)
    8020075e:	fe042783          	lw	a5,-32(s0)
    80200762:	04f70363          	beq	a4,a5,802007a8 <uart_intr+0xb2>
                    uart_input_buf.buf[uart_input_buf.w] = linebuf[i];
    80200766:	0000e797          	auipc	a5,0xe
    8020076a:	95a78793          	addi	a5,a5,-1702 # 8020e0c0 <uart_input_buf>
    8020076e:	0847a603          	lw	a2,132(a5)
    80200772:	0000e717          	auipc	a4,0xe
    80200776:	9de70713          	addi	a4,a4,-1570 # 8020e150 <linebuf.1>
    8020077a:	fec42783          	lw	a5,-20(s0)
    8020077e:	97ba                	add	a5,a5,a4
    80200780:	0007c703          	lbu	a4,0(a5)
    80200784:	0000e697          	auipc	a3,0xe
    80200788:	93c68693          	addi	a3,a3,-1732 # 8020e0c0 <uart_input_buf>
    8020078c:	02061793          	slli	a5,a2,0x20
    80200790:	9381                	srli	a5,a5,0x20
    80200792:	97b6                	add	a5,a5,a3
    80200794:	00e78023          	sb	a4,0(a5)
                    uart_input_buf.w = next;
    80200798:	fe042703          	lw	a4,-32(s0)
    8020079c:	0000e797          	auipc	a5,0xe
    802007a0:	92478793          	addi	a5,a5,-1756 # 8020e0c0 <uart_input_buf>
    802007a4:	08e7a223          	sw	a4,132(a5)
            for (int i = 0; i < line_len; i++) {
    802007a8:	fec42783          	lw	a5,-20(s0)
    802007ac:	2785                	addiw	a5,a5,1
    802007ae:	fef42623          	sw	a5,-20(s0)
    802007b2:	0000e797          	auipc	a5,0xe
    802007b6:	a1e78793          	addi	a5,a5,-1506 # 8020e1d0 <line_len.0>
    802007ba:	4398                	lw	a4,0(a5)
    802007bc:	fec42783          	lw	a5,-20(s0)
    802007c0:	2781                	sext.w	a5,a5
    802007c2:	f6e7cbe3          	blt	a5,a4,80200738 <uart_intr+0x42>
                }
            }
            // 写入换行符
            int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    802007c6:	0000e797          	auipc	a5,0xe
    802007ca:	8fa78793          	addi	a5,a5,-1798 # 8020e0c0 <uart_input_buf>
    802007ce:	0847a783          	lw	a5,132(a5)
    802007d2:	2785                	addiw	a5,a5,1
    802007d4:	2781                	sext.w	a5,a5
    802007d6:	2781                	sext.w	a5,a5
    802007d8:	07f7f793          	andi	a5,a5,127
    802007dc:	fef42223          	sw	a5,-28(s0)
            if (next != uart_input_buf.r) {
    802007e0:	0000e797          	auipc	a5,0xe
    802007e4:	8e078793          	addi	a5,a5,-1824 # 8020e0c0 <uart_input_buf>
    802007e8:	0807a703          	lw	a4,128(a5)
    802007ec:	fe442783          	lw	a5,-28(s0)
    802007f0:	02f70a63          	beq	a4,a5,80200824 <uart_intr+0x12e>
                uart_input_buf.buf[uart_input_buf.w] = '\n';
    802007f4:	0000e797          	auipc	a5,0xe
    802007f8:	8cc78793          	addi	a5,a5,-1844 # 8020e0c0 <uart_input_buf>
    802007fc:	0847a783          	lw	a5,132(a5)
    80200800:	0000e717          	auipc	a4,0xe
    80200804:	8c070713          	addi	a4,a4,-1856 # 8020e0c0 <uart_input_buf>
    80200808:	1782                	slli	a5,a5,0x20
    8020080a:	9381                	srli	a5,a5,0x20
    8020080c:	97ba                	add	a5,a5,a4
    8020080e:	4729                	li	a4,10
    80200810:	00e78023          	sb	a4,0(a5)
                uart_input_buf.w = next;
    80200814:	fe442703          	lw	a4,-28(s0)
    80200818:	0000e797          	auipc	a5,0xe
    8020081c:	8a878793          	addi	a5,a5,-1880 # 8020e0c0 <uart_input_buf>
    80200820:	08e7a223          	sw	a4,132(a5)
            }
            line_len = 0;
    80200824:	0000e797          	auipc	a5,0xe
    80200828:	9ac78793          	addi	a5,a5,-1620 # 8020e1d0 <line_len.0>
    8020082c:	0007a023          	sw	zero,0(a5)
        if (c == '\r' || c == '\n') {
    80200830:	a86d                	j	802008ea <uart_intr+0x1f4>
        } else if (c == 0x7f || c == 0x08) { // 退格
    80200832:	feb44783          	lbu	a5,-21(s0)
    80200836:	0ff7f713          	zext.b	a4,a5
    8020083a:	07f00793          	li	a5,127
    8020083e:	00f70963          	beq	a4,a5,80200850 <uart_intr+0x15a>
    80200842:	feb44783          	lbu	a5,-21(s0)
    80200846:	0ff7f713          	zext.b	a4,a5
    8020084a:	47a1                	li	a5,8
    8020084c:	04f71763          	bne	a4,a5,8020089a <uart_intr+0x1a4>
            if (line_len > 0) {
    80200850:	0000e797          	auipc	a5,0xe
    80200854:	98078793          	addi	a5,a5,-1664 # 8020e1d0 <line_len.0>
    80200858:	439c                	lw	a5,0(a5)
    8020085a:	08f05863          	blez	a5,802008ea <uart_intr+0x1f4>
                uart_putc('\b');
    8020085e:	4521                	li	a0,8
    80200860:	00000097          	auipc	ra,0x0
    80200864:	da4080e7          	jalr	-604(ra) # 80200604 <uart_putc>
                uart_putc(' ');
    80200868:	02000513          	li	a0,32
    8020086c:	00000097          	auipc	ra,0x0
    80200870:	d98080e7          	jalr	-616(ra) # 80200604 <uart_putc>
                uart_putc('\b');
    80200874:	4521                	li	a0,8
    80200876:	00000097          	auipc	ra,0x0
    8020087a:	d8e080e7          	jalr	-626(ra) # 80200604 <uart_putc>
                line_len--;
    8020087e:	0000e797          	auipc	a5,0xe
    80200882:	95278793          	addi	a5,a5,-1710 # 8020e1d0 <line_len.0>
    80200886:	439c                	lw	a5,0(a5)
    80200888:	37fd                	addiw	a5,a5,-1
    8020088a:	0007871b          	sext.w	a4,a5
    8020088e:	0000e797          	auipc	a5,0xe
    80200892:	94278793          	addi	a5,a5,-1726 # 8020e1d0 <line_len.0>
    80200896:	c398                	sw	a4,0(a5)
            if (line_len > 0) {
    80200898:	a889                	j	802008ea <uart_intr+0x1f4>
            }
        } else if (line_len < LINE_BUF_SIZE - 1) {
    8020089a:	0000e797          	auipc	a5,0xe
    8020089e:	93678793          	addi	a5,a5,-1738 # 8020e1d0 <line_len.0>
    802008a2:	439c                	lw	a5,0(a5)
    802008a4:	873e                	mv	a4,a5
    802008a6:	07e00793          	li	a5,126
    802008aa:	04e7c063          	blt	a5,a4,802008ea <uart_intr+0x1f4>
            uart_putc(c);
    802008ae:	feb44783          	lbu	a5,-21(s0)
    802008b2:	853e                	mv	a0,a5
    802008b4:	00000097          	auipc	ra,0x0
    802008b8:	d50080e7          	jalr	-688(ra) # 80200604 <uart_putc>
            linebuf[line_len++] = c;
    802008bc:	0000e797          	auipc	a5,0xe
    802008c0:	91478793          	addi	a5,a5,-1772 # 8020e1d0 <line_len.0>
    802008c4:	439c                	lw	a5,0(a5)
    802008c6:	0017871b          	addiw	a4,a5,1
    802008ca:	0007069b          	sext.w	a3,a4
    802008ce:	0000e717          	auipc	a4,0xe
    802008d2:	90270713          	addi	a4,a4,-1790 # 8020e1d0 <line_len.0>
    802008d6:	c314                	sw	a3,0(a4)
    802008d8:	0000e717          	auipc	a4,0xe
    802008dc:	87870713          	addi	a4,a4,-1928 # 8020e150 <linebuf.1>
    802008e0:	97ba                	add	a5,a5,a4
    802008e2:	feb44703          	lbu	a4,-21(s0)
    802008e6:	00e78023          	sb	a4,0(a5)
    while (ReadReg(LSR) & LSR_RX_READY) {
    802008ea:	100007b7          	lui	a5,0x10000
    802008ee:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    802008f0:	0007c783          	lbu	a5,0(a5)
    802008f4:	0ff7f793          	zext.b	a5,a5
    802008f8:	2781                	sext.w	a5,a5
    802008fa:	8b85                	andi	a5,a5,1
    802008fc:	2781                	sext.w	a5,a5
    802008fe:	e00791e3          	bnez	a5,80200700 <uart_intr+0xa>
        }
    }
}
    80200902:	0001                	nop
    80200904:	0001                	nop
    80200906:	60e2                	ld	ra,24(sp)
    80200908:	6442                	ld	s0,16(sp)
    8020090a:	6105                	addi	sp,sp,32
    8020090c:	8082                	ret

000000008020090e <uart_getc_blocking>:
// 阻塞式读取一个字符
char uart_getc_blocking(void) {
    8020090e:	1101                	addi	sp,sp,-32
    80200910:	ec22                	sd	s0,24(sp)
    80200912:	1000                	addi	s0,sp,32
    // 等待直到有字符可读
    while (uart_input_buf.r == uart_input_buf.w) {
    80200914:	a011                	j	80200918 <uart_getc_blocking+0xa>
        // 在实际系统中，这里可能需要让进程睡眠
        // 但目前我们使用简单的轮询
        asm volatile("nop");
    80200916:	0001                	nop
    while (uart_input_buf.r == uart_input_buf.w) {
    80200918:	0000d797          	auipc	a5,0xd
    8020091c:	7a878793          	addi	a5,a5,1960 # 8020e0c0 <uart_input_buf>
    80200920:	0807a703          	lw	a4,128(a5)
    80200924:	0000d797          	auipc	a5,0xd
    80200928:	79c78793          	addi	a5,a5,1948 # 8020e0c0 <uart_input_buf>
    8020092c:	0847a783          	lw	a5,132(a5)
    80200930:	fef703e3          	beq	a4,a5,80200916 <uart_getc_blocking+0x8>
    }
    
    // 读取字符
    char c = uart_input_buf.buf[uart_input_buf.r];
    80200934:	0000d797          	auipc	a5,0xd
    80200938:	78c78793          	addi	a5,a5,1932 # 8020e0c0 <uart_input_buf>
    8020093c:	0807a783          	lw	a5,128(a5)
    80200940:	0000d717          	auipc	a4,0xd
    80200944:	78070713          	addi	a4,a4,1920 # 8020e0c0 <uart_input_buf>
    80200948:	1782                	slli	a5,a5,0x20
    8020094a:	9381                	srli	a5,a5,0x20
    8020094c:	97ba                	add	a5,a5,a4
    8020094e:	0007c783          	lbu	a5,0(a5)
    80200952:	fef407a3          	sb	a5,-17(s0)
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    80200956:	0000d797          	auipc	a5,0xd
    8020095a:	76a78793          	addi	a5,a5,1898 # 8020e0c0 <uart_input_buf>
    8020095e:	0807a783          	lw	a5,128(a5)
    80200962:	2785                	addiw	a5,a5,1
    80200964:	2781                	sext.w	a5,a5
    80200966:	07f7f793          	andi	a5,a5,127
    8020096a:	0007871b          	sext.w	a4,a5
    8020096e:	0000d797          	auipc	a5,0xd
    80200972:	75278793          	addi	a5,a5,1874 # 8020e0c0 <uart_input_buf>
    80200976:	08e7a023          	sw	a4,128(a5)
    return c;
    8020097a:	fef44783          	lbu	a5,-17(s0)
}
    8020097e:	853e                	mv	a0,a5
    80200980:	6462                	ld	s0,24(sp)
    80200982:	6105                	addi	sp,sp,32
    80200984:	8082                	ret

0000000080200986 <readline>:
// 读取一行输入，最多读取max-1个字符，并在末尾添加\0
int readline(char *buf, int max) {
    80200986:	7179                	addi	sp,sp,-48
    80200988:	f406                	sd	ra,40(sp)
    8020098a:	f022                	sd	s0,32(sp)
    8020098c:	1800                	addi	s0,sp,48
    8020098e:	fca43c23          	sd	a0,-40(s0)
    80200992:	87ae                	mv	a5,a1
    80200994:	fcf42a23          	sw	a5,-44(s0)
    int i = 0;
    80200998:	fe042623          	sw	zero,-20(s0)
    char c;
    
    while (i < max - 1) {
    8020099c:	a0b9                	j	802009ea <readline+0x64>
        c = uart_getc_blocking();
    8020099e:	00000097          	auipc	ra,0x0
    802009a2:	f70080e7          	jalr	-144(ra) # 8020090e <uart_getc_blocking>
    802009a6:	87aa                	mv	a5,a0
    802009a8:	fef405a3          	sb	a5,-21(s0)
        
        if (c == '\n') {
    802009ac:	feb44783          	lbu	a5,-21(s0)
    802009b0:	0ff7f713          	zext.b	a4,a5
    802009b4:	47a9                	li	a5,10
    802009b6:	00f71c63          	bne	a4,a5,802009ce <readline+0x48>
            buf[i] = '\0';
    802009ba:	fec42783          	lw	a5,-20(s0)
    802009be:	fd843703          	ld	a4,-40(s0)
    802009c2:	97ba                	add	a5,a5,a4
    802009c4:	00078023          	sb	zero,0(a5)
            return i;
    802009c8:	fec42783          	lw	a5,-20(s0)
    802009cc:	a0a9                	j	80200a16 <readline+0x90>
        } else {
            buf[i++] = c;
    802009ce:	fec42783          	lw	a5,-20(s0)
    802009d2:	0017871b          	addiw	a4,a5,1
    802009d6:	fee42623          	sw	a4,-20(s0)
    802009da:	873e                	mv	a4,a5
    802009dc:	fd843783          	ld	a5,-40(s0)
    802009e0:	97ba                	add	a5,a5,a4
    802009e2:	feb44703          	lbu	a4,-21(s0)
    802009e6:	00e78023          	sb	a4,0(a5)
    while (i < max - 1) {
    802009ea:	fd442783          	lw	a5,-44(s0)
    802009ee:	37fd                	addiw	a5,a5,-1
    802009f0:	0007871b          	sext.w	a4,a5
    802009f4:	fec42783          	lw	a5,-20(s0)
    802009f8:	2781                	sext.w	a5,a5
    802009fa:	fae7c2e3          	blt	a5,a4,8020099e <readline+0x18>
        }
    }
    
    // 缓冲区满，添加\0并返回
    buf[max-1] = '\0';
    802009fe:	fd442783          	lw	a5,-44(s0)
    80200a02:	17fd                	addi	a5,a5,-1
    80200a04:	fd843703          	ld	a4,-40(s0)
    80200a08:	97ba                	add	a5,a5,a4
    80200a0a:	00078023          	sb	zero,0(a5)
    return max-1;
    80200a0e:	fd442783          	lw	a5,-44(s0)
    80200a12:	37fd                	addiw	a5,a5,-1
    80200a14:	2781                	sext.w	a5,a5
    80200a16:	853e                	mv	a0,a5
    80200a18:	70a2                	ld	ra,40(sp)
    80200a1a:	7402                	ld	s0,32(sp)
    80200a1c:	6145                	addi	sp,sp,48
    80200a1e:	8082                	ret

0000000080200a20 <flush_printf_buffer>:

extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    80200a20:	1141                	addi	sp,sp,-16
    80200a22:	e406                	sd	ra,8(sp)
    80200a24:	e022                	sd	s0,0(sp)
    80200a26:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    80200a28:	0000e797          	auipc	a5,0xe
    80200a2c:	83078793          	addi	a5,a5,-2000 # 8020e258 <printf_buf_pos>
    80200a30:	439c                	lw	a5,0(a5)
    80200a32:	02f05c63          	blez	a5,80200a6a <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200a36:	0000e797          	auipc	a5,0xe
    80200a3a:	82278793          	addi	a5,a5,-2014 # 8020e258 <printf_buf_pos>
    80200a3e:	439c                	lw	a5,0(a5)
    80200a40:	0000d717          	auipc	a4,0xd
    80200a44:	79870713          	addi	a4,a4,1944 # 8020e1d8 <printf_buffer>
    80200a48:	97ba                	add	a5,a5,a4
    80200a4a:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80200a4e:	0000d517          	auipc	a0,0xd
    80200a52:	78a50513          	addi	a0,a0,1930 # 8020e1d8 <printf_buffer>
    80200a56:	00000097          	auipc	ra,0x0
    80200a5a:	be8080e7          	jalr	-1048(ra) # 8020063e <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200a5e:	0000d797          	auipc	a5,0xd
    80200a62:	7fa78793          	addi	a5,a5,2042 # 8020e258 <printf_buf_pos>
    80200a66:	0007a023          	sw	zero,0(a5)
	}
}
    80200a6a:	0001                	nop
    80200a6c:	60a2                	ld	ra,8(sp)
    80200a6e:	6402                	ld	s0,0(sp)
    80200a70:	0141                	addi	sp,sp,16
    80200a72:	8082                	ret

0000000080200a74 <buffer_char>:
static void buffer_char(char c) {
    80200a74:	1101                	addi	sp,sp,-32
    80200a76:	ec06                	sd	ra,24(sp)
    80200a78:	e822                	sd	s0,16(sp)
    80200a7a:	1000                	addi	s0,sp,32
    80200a7c:	87aa                	mv	a5,a0
    80200a7e:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    80200a82:	0000d797          	auipc	a5,0xd
    80200a86:	7d678793          	addi	a5,a5,2006 # 8020e258 <printf_buf_pos>
    80200a8a:	439c                	lw	a5,0(a5)
    80200a8c:	873e                	mv	a4,a5
    80200a8e:	07e00793          	li	a5,126
    80200a92:	02e7ca63          	blt	a5,a4,80200ac6 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200a96:	0000d797          	auipc	a5,0xd
    80200a9a:	7c278793          	addi	a5,a5,1986 # 8020e258 <printf_buf_pos>
    80200a9e:	439c                	lw	a5,0(a5)
    80200aa0:	0017871b          	addiw	a4,a5,1
    80200aa4:	0007069b          	sext.w	a3,a4
    80200aa8:	0000d717          	auipc	a4,0xd
    80200aac:	7b070713          	addi	a4,a4,1968 # 8020e258 <printf_buf_pos>
    80200ab0:	c314                	sw	a3,0(a4)
    80200ab2:	0000d717          	auipc	a4,0xd
    80200ab6:	72670713          	addi	a4,a4,1830 # 8020e1d8 <printf_buffer>
    80200aba:	97ba                	add	a5,a5,a4
    80200abc:	fef44703          	lbu	a4,-17(s0)
    80200ac0:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    80200ac4:	a825                	j	80200afc <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    80200ac6:	00000097          	auipc	ra,0x0
    80200aca:	f5a080e7          	jalr	-166(ra) # 80200a20 <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    80200ace:	0000d797          	auipc	a5,0xd
    80200ad2:	78a78793          	addi	a5,a5,1930 # 8020e258 <printf_buf_pos>
    80200ad6:	439c                	lw	a5,0(a5)
    80200ad8:	0017871b          	addiw	a4,a5,1
    80200adc:	0007069b          	sext.w	a3,a4
    80200ae0:	0000d717          	auipc	a4,0xd
    80200ae4:	77870713          	addi	a4,a4,1912 # 8020e258 <printf_buf_pos>
    80200ae8:	c314                	sw	a3,0(a4)
    80200aea:	0000d717          	auipc	a4,0xd
    80200aee:	6ee70713          	addi	a4,a4,1774 # 8020e1d8 <printf_buffer>
    80200af2:	97ba                	add	a5,a5,a4
    80200af4:	fef44703          	lbu	a4,-17(s0)
    80200af8:	00e78023          	sb	a4,0(a5)
}
    80200afc:	0001                	nop
    80200afe:	60e2                	ld	ra,24(sp)
    80200b00:	6442                	ld	s0,16(sp)
    80200b02:	6105                	addi	sp,sp,32
    80200b04:	8082                	ret

0000000080200b06 <consputc>:

static void consputc(int c){
    80200b06:	1101                	addi	sp,sp,-32
    80200b08:	ec06                	sd	ra,24(sp)
    80200b0a:	e822                	sd	s0,16(sp)
    80200b0c:	1000                	addi	s0,sp,32
    80200b0e:	87aa                	mv	a5,a0
    80200b10:	fef42623          	sw	a5,-20(s0)
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
    80200b14:	fec42783          	lw	a5,-20(s0)
    80200b18:	0ff7f793          	zext.b	a5,a5
    80200b1c:	853e                	mv	a0,a5
    80200b1e:	00000097          	auipc	ra,0x0
    80200b22:	ae6080e7          	jalr	-1306(ra) # 80200604 <uart_putc>
}
    80200b26:	0001                	nop
    80200b28:	60e2                	ld	ra,24(sp)
    80200b2a:	6442                	ld	s0,16(sp)
    80200b2c:	6105                	addi	sp,sp,32
    80200b2e:	8082                	ret

0000000080200b30 <consputs>:
static void consputs(const char *s){
    80200b30:	7179                	addi	sp,sp,-48
    80200b32:	f406                	sd	ra,40(sp)
    80200b34:	f022                	sd	s0,32(sp)
    80200b36:	1800                	addi	s0,sp,48
    80200b38:	fca43c23          	sd	a0,-40(s0)
	char *str = (char *)s;
    80200b3c:	fd843783          	ld	a5,-40(s0)
    80200b40:	fef43423          	sd	a5,-24(s0)
	// 直接调用uart_puts输出字符串
	uart_puts(str);
    80200b44:	fe843503          	ld	a0,-24(s0)
    80200b48:	00000097          	auipc	ra,0x0
    80200b4c:	af6080e7          	jalr	-1290(ra) # 8020063e <uart_puts>
}
    80200b50:	0001                	nop
    80200b52:	70a2                	ld	ra,40(sp)
    80200b54:	7402                	ld	s0,32(sp)
    80200b56:	6145                	addi	sp,sp,48
    80200b58:	8082                	ret

0000000080200b5a <printint>:
static void printint(long long xx, int base, int sign, int width, int padzero){
    80200b5a:	7159                	addi	sp,sp,-112
    80200b5c:	f486                	sd	ra,104(sp)
    80200b5e:	f0a2                	sd	s0,96(sp)
    80200b60:	1880                	addi	s0,sp,112
    80200b62:	faa43423          	sd	a0,-88(s0)
    80200b66:	87ae                	mv	a5,a1
    80200b68:	faf42223          	sw	a5,-92(s0)
    80200b6c:	87b2                	mv	a5,a2
    80200b6e:	faf42023          	sw	a5,-96(s0)
    80200b72:	87b6                	mv	a5,a3
    80200b74:	f8f42e23          	sw	a5,-100(s0)
    80200b78:	87ba                	mv	a5,a4
    80200b7a:	f8f42c23          	sw	a5,-104(s0)
    static char digits[] = "0123456789abcdef";
    char buf[32];
    int i = 0;
    80200b7e:	fe042623          	sw	zero,-20(s0)
    unsigned long long x;

    if (sign && (sign = xx < 0))
    80200b82:	fa042783          	lw	a5,-96(s0)
    80200b86:	2781                	sext.w	a5,a5
    80200b88:	c39d                	beqz	a5,80200bae <printint+0x54>
    80200b8a:	fa843783          	ld	a5,-88(s0)
    80200b8e:	93fd                	srli	a5,a5,0x3f
    80200b90:	0ff7f793          	zext.b	a5,a5
    80200b94:	faf42023          	sw	a5,-96(s0)
    80200b98:	fa042783          	lw	a5,-96(s0)
    80200b9c:	2781                	sext.w	a5,a5
    80200b9e:	cb81                	beqz	a5,80200bae <printint+0x54>
        x = -(unsigned long long)xx;
    80200ba0:	fa843783          	ld	a5,-88(s0)
    80200ba4:	40f007b3          	neg	a5,a5
    80200ba8:	fef43023          	sd	a5,-32(s0)
    80200bac:	a029                	j	80200bb6 <printint+0x5c>
    else
        x = xx;
    80200bae:	fa843783          	ld	a5,-88(s0)
    80200bb2:	fef43023          	sd	a5,-32(s0)

    do {
        buf[i++] = digits[x % base];
    80200bb6:	fa442783          	lw	a5,-92(s0)
    80200bba:	fe043703          	ld	a4,-32(s0)
    80200bbe:	02f77733          	remu	a4,a4,a5
    80200bc2:	fec42783          	lw	a5,-20(s0)
    80200bc6:	0017869b          	addiw	a3,a5,1
    80200bca:	fed42623          	sw	a3,-20(s0)
    80200bce:	0000d697          	auipc	a3,0xd
    80200bd2:	4aa68693          	addi	a3,a3,1194 # 8020e078 <digits.0>
    80200bd6:	9736                	add	a4,a4,a3
    80200bd8:	00074703          	lbu	a4,0(a4)
    80200bdc:	17c1                	addi	a5,a5,-16
    80200bde:	97a2                	add	a5,a5,s0
    80200be0:	fce78423          	sb	a4,-56(a5)
    } while ((x /= base) != 0);
    80200be4:	fa442783          	lw	a5,-92(s0)
    80200be8:	fe043703          	ld	a4,-32(s0)
    80200bec:	02f757b3          	divu	a5,a4,a5
    80200bf0:	fef43023          	sd	a5,-32(s0)
    80200bf4:	fe043783          	ld	a5,-32(s0)
    80200bf8:	ffdd                	bnez	a5,80200bb6 <printint+0x5c>

    if (sign)
    80200bfa:	fa042783          	lw	a5,-96(s0)
    80200bfe:	2781                	sext.w	a5,a5
    80200c00:	cf89                	beqz	a5,80200c1a <printint+0xc0>
        buf[i++] = '-';
    80200c02:	fec42783          	lw	a5,-20(s0)
    80200c06:	0017871b          	addiw	a4,a5,1
    80200c0a:	fee42623          	sw	a4,-20(s0)
    80200c0e:	17c1                	addi	a5,a5,-16
    80200c10:	97a2                	add	a5,a5,s0
    80200c12:	02d00713          	li	a4,45
    80200c16:	fce78423          	sb	a4,-56(a5)

    // 计算需要补的填充字符数
    int pad = width - i;
    80200c1a:	f9c42783          	lw	a5,-100(s0)
    80200c1e:	873e                	mv	a4,a5
    80200c20:	fec42783          	lw	a5,-20(s0)
    80200c24:	40f707bb          	subw	a5,a4,a5
    80200c28:	fcf42e23          	sw	a5,-36(s0)
    while (pad-- > 0) {
    80200c2c:	a839                	j	80200c4a <printint+0xf0>
        consputc(padzero ? '0' : ' ');
    80200c2e:	f9842783          	lw	a5,-104(s0)
    80200c32:	2781                	sext.w	a5,a5
    80200c34:	c781                	beqz	a5,80200c3c <printint+0xe2>
    80200c36:	03000793          	li	a5,48
    80200c3a:	a019                	j	80200c40 <printint+0xe6>
    80200c3c:	02000793          	li	a5,32
    80200c40:	853e                	mv	a0,a5
    80200c42:	00000097          	auipc	ra,0x0
    80200c46:	ec4080e7          	jalr	-316(ra) # 80200b06 <consputc>
    while (pad-- > 0) {
    80200c4a:	fdc42783          	lw	a5,-36(s0)
    80200c4e:	fff7871b          	addiw	a4,a5,-1
    80200c52:	fce42e23          	sw	a4,-36(s0)
    80200c56:	fcf04ce3          	bgtz	a5,80200c2e <printint+0xd4>
    }

    while (--i >= 0)
    80200c5a:	a829                	j	80200c74 <printint+0x11a>
        consputc(buf[i]);
    80200c5c:	fec42783          	lw	a5,-20(s0)
    80200c60:	17c1                	addi	a5,a5,-16
    80200c62:	97a2                	add	a5,a5,s0
    80200c64:	fc87c783          	lbu	a5,-56(a5)
    80200c68:	2781                	sext.w	a5,a5
    80200c6a:	853e                	mv	a0,a5
    80200c6c:	00000097          	auipc	ra,0x0
    80200c70:	e9a080e7          	jalr	-358(ra) # 80200b06 <consputc>
    while (--i >= 0)
    80200c74:	fec42783          	lw	a5,-20(s0)
    80200c78:	37fd                	addiw	a5,a5,-1
    80200c7a:	fef42623          	sw	a5,-20(s0)
    80200c7e:	fec42783          	lw	a5,-20(s0)
    80200c82:	2781                	sext.w	a5,a5
    80200c84:	fc07dce3          	bgez	a5,80200c5c <printint+0x102>
}
    80200c88:	0001                	nop
    80200c8a:	0001                	nop
    80200c8c:	70a6                	ld	ra,104(sp)
    80200c8e:	7406                	ld	s0,96(sp)
    80200c90:	6165                	addi	sp,sp,112
    80200c92:	8082                	ret

0000000080200c94 <printf>:
void printf(const char *fmt, ...) {
    80200c94:	7171                	addi	sp,sp,-176
    80200c96:	f486                	sd	ra,104(sp)
    80200c98:	f0a2                	sd	s0,96(sp)
    80200c9a:	1880                	addi	s0,sp,112
    80200c9c:	f8a43c23          	sd	a0,-104(s0)
    80200ca0:	e40c                	sd	a1,8(s0)
    80200ca2:	e810                	sd	a2,16(s0)
    80200ca4:	ec14                	sd	a3,24(s0)
    80200ca6:	f018                	sd	a4,32(s0)
    80200ca8:	f41c                	sd	a5,40(s0)
    80200caa:	03043823          	sd	a6,48(s0)
    80200cae:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    80200cb2:	04040793          	addi	a5,s0,64
    80200cb6:	f8f43823          	sd	a5,-112(s0)
    80200cba:	f9043783          	ld	a5,-112(s0)
    80200cbe:	fc878793          	addi	a5,a5,-56
    80200cc2:	faf43c23          	sd	a5,-72(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200cc6:	fe042623          	sw	zero,-20(s0)
    80200cca:	a945                	j	8020117a <printf+0x4e6>
        if(c != '%'){
    80200ccc:	fe842783          	lw	a5,-24(s0)
    80200cd0:	0007871b          	sext.w	a4,a5
    80200cd4:	02500793          	li	a5,37
    80200cd8:	00f70c63          	beq	a4,a5,80200cf0 <printf+0x5c>
            buffer_char(c);
    80200cdc:	fe842783          	lw	a5,-24(s0)
    80200ce0:	0ff7f793          	zext.b	a5,a5
    80200ce4:	853e                	mv	a0,a5
    80200ce6:	00000097          	auipc	ra,0x0
    80200cea:	d8e080e7          	jalr	-626(ra) # 80200a74 <buffer_char>
            continue;
    80200cee:	a149                	j	80201170 <printf+0x4dc>
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    80200cf0:	00000097          	auipc	ra,0x0
    80200cf4:	d30080e7          	jalr	-720(ra) # 80200a20 <flush_printf_buffer>
		// 解析填充标志和宽度
        int padzero = 0, width = 0;
    80200cf8:	fc042e23          	sw	zero,-36(s0)
    80200cfc:	fc042c23          	sw	zero,-40(s0)
        c = fmt[++i] & 0xff;
    80200d00:	fec42783          	lw	a5,-20(s0)
    80200d04:	2785                	addiw	a5,a5,1
    80200d06:	fef42623          	sw	a5,-20(s0)
    80200d0a:	fec42783          	lw	a5,-20(s0)
    80200d0e:	f9843703          	ld	a4,-104(s0)
    80200d12:	97ba                	add	a5,a5,a4
    80200d14:	0007c783          	lbu	a5,0(a5)
    80200d18:	fef42423          	sw	a5,-24(s0)
        if (c == '0') {
    80200d1c:	fe842783          	lw	a5,-24(s0)
    80200d20:	0007871b          	sext.w	a4,a5
    80200d24:	03000793          	li	a5,48
    80200d28:	06f71563          	bne	a4,a5,80200d92 <printf+0xfe>
            padzero = 1;
    80200d2c:	4785                	li	a5,1
    80200d2e:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    80200d32:	fec42783          	lw	a5,-20(s0)
    80200d36:	2785                	addiw	a5,a5,1
    80200d38:	fef42623          	sw	a5,-20(s0)
    80200d3c:	fec42783          	lw	a5,-20(s0)
    80200d40:	f9843703          	ld	a4,-104(s0)
    80200d44:	97ba                	add	a5,a5,a4
    80200d46:	0007c783          	lbu	a5,0(a5)
    80200d4a:	fef42423          	sw	a5,-24(s0)
        }
        while (c >= '0' && c <= '9') {
    80200d4e:	a091                	j	80200d92 <printf+0xfe>
            width = width * 10 + (c - '0');
    80200d50:	fd842783          	lw	a5,-40(s0)
    80200d54:	873e                	mv	a4,a5
    80200d56:	87ba                	mv	a5,a4
    80200d58:	0027979b          	slliw	a5,a5,0x2
    80200d5c:	9fb9                	addw	a5,a5,a4
    80200d5e:	0017979b          	slliw	a5,a5,0x1
    80200d62:	0007871b          	sext.w	a4,a5
    80200d66:	fe842783          	lw	a5,-24(s0)
    80200d6a:	fd07879b          	addiw	a5,a5,-48
    80200d6e:	2781                	sext.w	a5,a5
    80200d70:	9fb9                	addw	a5,a5,a4
    80200d72:	fcf42c23          	sw	a5,-40(s0)
            c = fmt[++i] & 0xff;
    80200d76:	fec42783          	lw	a5,-20(s0)
    80200d7a:	2785                	addiw	a5,a5,1
    80200d7c:	fef42623          	sw	a5,-20(s0)
    80200d80:	fec42783          	lw	a5,-20(s0)
    80200d84:	f9843703          	ld	a4,-104(s0)
    80200d88:	97ba                	add	a5,a5,a4
    80200d8a:	0007c783          	lbu	a5,0(a5)
    80200d8e:	fef42423          	sw	a5,-24(s0)
        while (c >= '0' && c <= '9') {
    80200d92:	fe842783          	lw	a5,-24(s0)
    80200d96:	0007871b          	sext.w	a4,a5
    80200d9a:	02f00793          	li	a5,47
    80200d9e:	00e7da63          	bge	a5,a4,80200db2 <printf+0x11e>
    80200da2:	fe842783          	lw	a5,-24(s0)
    80200da6:	0007871b          	sext.w	a4,a5
    80200daa:	03900793          	li	a5,57
    80200dae:	fae7d1e3          	bge	a5,a4,80200d50 <printf+0xbc>
        }
        // 检查是否有长整型标记'l'
        int is_long = 0;
    80200db2:	fc042a23          	sw	zero,-44(s0)
        if(c == 'l') {
    80200db6:	fe842783          	lw	a5,-24(s0)
    80200dba:	0007871b          	sext.w	a4,a5
    80200dbe:	06c00793          	li	a5,108
    80200dc2:	02f71863          	bne	a4,a5,80200df2 <printf+0x15e>
            is_long = 1;
    80200dc6:	4785                	li	a5,1
    80200dc8:	fcf42a23          	sw	a5,-44(s0)
            c = fmt[++i] & 0xff;
    80200dcc:	fec42783          	lw	a5,-20(s0)
    80200dd0:	2785                	addiw	a5,a5,1
    80200dd2:	fef42623          	sw	a5,-20(s0)
    80200dd6:	fec42783          	lw	a5,-20(s0)
    80200dda:	f9843703          	ld	a4,-104(s0)
    80200dde:	97ba                	add	a5,a5,a4
    80200de0:	0007c783          	lbu	a5,0(a5)
    80200de4:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    80200de8:	fe842783          	lw	a5,-24(s0)
    80200dec:	2781                	sext.w	a5,a5
    80200dee:	3a078563          	beqz	a5,80201198 <printf+0x504>
                break;
        }
        
        switch(c){
    80200df2:	fe842783          	lw	a5,-24(s0)
    80200df6:	0007871b          	sext.w	a4,a5
    80200dfa:	02500793          	li	a5,37
    80200dfe:	2ef70d63          	beq	a4,a5,802010f8 <printf+0x464>
    80200e02:	fe842783          	lw	a5,-24(s0)
    80200e06:	0007871b          	sext.w	a4,a5
    80200e0a:	02500793          	li	a5,37
    80200e0e:	2ef74c63          	blt	a4,a5,80201106 <printf+0x472>
    80200e12:	fe842783          	lw	a5,-24(s0)
    80200e16:	0007871b          	sext.w	a4,a5
    80200e1a:	07800793          	li	a5,120
    80200e1e:	2ee7c463          	blt	a5,a4,80201106 <printf+0x472>
    80200e22:	fe842783          	lw	a5,-24(s0)
    80200e26:	0007871b          	sext.w	a4,a5
    80200e2a:	06200793          	li	a5,98
    80200e2e:	2cf74c63          	blt	a4,a5,80201106 <printf+0x472>
    80200e32:	fe842783          	lw	a5,-24(s0)
    80200e36:	f9e7869b          	addiw	a3,a5,-98
    80200e3a:	0006871b          	sext.w	a4,a3
    80200e3e:	47d9                	li	a5,22
    80200e40:	2ce7e363          	bltu	a5,a4,80201106 <printf+0x472>
    80200e44:	02069793          	slli	a5,a3,0x20
    80200e48:	9381                	srli	a5,a5,0x20
    80200e4a:	00279713          	slli	a4,a5,0x2
    80200e4e:	00007797          	auipc	a5,0x7
    80200e52:	d7e78793          	addi	a5,a5,-642 # 80207bcc <simple_user_task_bin+0x7c>
    80200e56:	97ba                	add	a5,a5,a4
    80200e58:	439c                	lw	a5,0(a5)
    80200e5a:	0007871b          	sext.w	a4,a5
    80200e5e:	00007797          	auipc	a5,0x7
    80200e62:	d6e78793          	addi	a5,a5,-658 # 80207bcc <simple_user_task_bin+0x7c>
    80200e66:	97ba                	add	a5,a5,a4
    80200e68:	8782                	jr	a5
        case 'd':
            if(is_long)
    80200e6a:	fd442783          	lw	a5,-44(s0)
    80200e6e:	2781                	sext.w	a5,a5
    80200e70:	c785                	beqz	a5,80200e98 <printf+0x204>
                printint(va_arg(ap, long long), 10, 1, width, padzero);
    80200e72:	fb843783          	ld	a5,-72(s0)
    80200e76:	00878713          	addi	a4,a5,8
    80200e7a:	fae43c23          	sd	a4,-72(s0)
    80200e7e:	639c                	ld	a5,0(a5)
    80200e80:	fdc42703          	lw	a4,-36(s0)
    80200e84:	fd842683          	lw	a3,-40(s0)
    80200e88:	4605                	li	a2,1
    80200e8a:	45a9                	li	a1,10
    80200e8c:	853e                	mv	a0,a5
    80200e8e:	00000097          	auipc	ra,0x0
    80200e92:	ccc080e7          	jalr	-820(ra) # 80200b5a <printint>
            else
                printint(va_arg(ap, int), 10, 1, width, padzero);
            break;
    80200e96:	ace9                	j	80201170 <printf+0x4dc>
                printint(va_arg(ap, int), 10, 1, width, padzero);
    80200e98:	fb843783          	ld	a5,-72(s0)
    80200e9c:	00878713          	addi	a4,a5,8
    80200ea0:	fae43c23          	sd	a4,-72(s0)
    80200ea4:	439c                	lw	a5,0(a5)
    80200ea6:	853e                	mv	a0,a5
    80200ea8:	fdc42703          	lw	a4,-36(s0)
    80200eac:	fd842783          	lw	a5,-40(s0)
    80200eb0:	86be                	mv	a3,a5
    80200eb2:	4605                	li	a2,1
    80200eb4:	45a9                	li	a1,10
    80200eb6:	00000097          	auipc	ra,0x0
    80200eba:	ca4080e7          	jalr	-860(ra) # 80200b5a <printint>
            break;
    80200ebe:	ac4d                	j	80201170 <printf+0x4dc>
        case 'x':
            if(is_long)
    80200ec0:	fd442783          	lw	a5,-44(s0)
    80200ec4:	2781                	sext.w	a5,a5
    80200ec6:	c785                	beqz	a5,80200eee <printf+0x25a>
                printint(va_arg(ap, long long), 16, 0, width, padzero);
    80200ec8:	fb843783          	ld	a5,-72(s0)
    80200ecc:	00878713          	addi	a4,a5,8
    80200ed0:	fae43c23          	sd	a4,-72(s0)
    80200ed4:	639c                	ld	a5,0(a5)
    80200ed6:	fdc42703          	lw	a4,-36(s0)
    80200eda:	fd842683          	lw	a3,-40(s0)
    80200ede:	4601                	li	a2,0
    80200ee0:	45c1                	li	a1,16
    80200ee2:	853e                	mv	a0,a5
    80200ee4:	00000097          	auipc	ra,0x0
    80200ee8:	c76080e7          	jalr	-906(ra) # 80200b5a <printint>
            else
                printint(va_arg(ap, int), 16, 0, width, padzero);
            break;
    80200eec:	a451                	j	80201170 <printf+0x4dc>
                printint(va_arg(ap, int), 16, 0, width, padzero);
    80200eee:	fb843783          	ld	a5,-72(s0)
    80200ef2:	00878713          	addi	a4,a5,8
    80200ef6:	fae43c23          	sd	a4,-72(s0)
    80200efa:	439c                	lw	a5,0(a5)
    80200efc:	853e                	mv	a0,a5
    80200efe:	fdc42703          	lw	a4,-36(s0)
    80200f02:	fd842783          	lw	a5,-40(s0)
    80200f06:	86be                	mv	a3,a5
    80200f08:	4601                	li	a2,0
    80200f0a:	45c1                	li	a1,16
    80200f0c:	00000097          	auipc	ra,0x0
    80200f10:	c4e080e7          	jalr	-946(ra) # 80200b5a <printint>
            break;
    80200f14:	acb1                	j	80201170 <printf+0x4dc>
        case 'u':
            if(is_long)
    80200f16:	fd442783          	lw	a5,-44(s0)
    80200f1a:	2781                	sext.w	a5,a5
    80200f1c:	c78d                	beqz	a5,80200f46 <printf+0x2b2>
                printint(va_arg(ap, unsigned long long), 10, 0, width, padzero);
    80200f1e:	fb843783          	ld	a5,-72(s0)
    80200f22:	00878713          	addi	a4,a5,8
    80200f26:	fae43c23          	sd	a4,-72(s0)
    80200f2a:	639c                	ld	a5,0(a5)
    80200f2c:	853e                	mv	a0,a5
    80200f2e:	fdc42703          	lw	a4,-36(s0)
    80200f32:	fd842783          	lw	a5,-40(s0)
    80200f36:	86be                	mv	a3,a5
    80200f38:	4601                	li	a2,0
    80200f3a:	45a9                	li	a1,10
    80200f3c:	00000097          	auipc	ra,0x0
    80200f40:	c1e080e7          	jalr	-994(ra) # 80200b5a <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
            break;
    80200f44:	a435                	j	80201170 <printf+0x4dc>
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
    80200f46:	fb843783          	ld	a5,-72(s0)
    80200f4a:	00878713          	addi	a4,a5,8
    80200f4e:	fae43c23          	sd	a4,-72(s0)
    80200f52:	439c                	lw	a5,0(a5)
    80200f54:	1782                	slli	a5,a5,0x20
    80200f56:	9381                	srli	a5,a5,0x20
    80200f58:	fdc42703          	lw	a4,-36(s0)
    80200f5c:	fd842683          	lw	a3,-40(s0)
    80200f60:	4601                	li	a2,0
    80200f62:	45a9                	li	a1,10
    80200f64:	853e                	mv	a0,a5
    80200f66:	00000097          	auipc	ra,0x0
    80200f6a:	bf4080e7          	jalr	-1036(ra) # 80200b5a <printint>
            break;
    80200f6e:	a409                	j	80201170 <printf+0x4dc>
        case 'c':
            consputc(va_arg(ap, int));
    80200f70:	fb843783          	ld	a5,-72(s0)
    80200f74:	00878713          	addi	a4,a5,8
    80200f78:	fae43c23          	sd	a4,-72(s0)
    80200f7c:	439c                	lw	a5,0(a5)
    80200f7e:	853e                	mv	a0,a5
    80200f80:	00000097          	auipc	ra,0x0
    80200f84:	b86080e7          	jalr	-1146(ra) # 80200b06 <consputc>
            break;
    80200f88:	a2e5                	j	80201170 <printf+0x4dc>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80200f8a:	fb843783          	ld	a5,-72(s0)
    80200f8e:	00878713          	addi	a4,a5,8
    80200f92:	fae43c23          	sd	a4,-72(s0)
    80200f96:	639c                	ld	a5,0(a5)
    80200f98:	fef43023          	sd	a5,-32(s0)
    80200f9c:	fe043783          	ld	a5,-32(s0)
    80200fa0:	e799                	bnez	a5,80200fae <printf+0x31a>
                s = "(null)";
    80200fa2:	00007797          	auipc	a5,0x7
    80200fa6:	c0678793          	addi	a5,a5,-1018 # 80207ba8 <simple_user_task_bin+0x58>
    80200faa:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    80200fae:	fe043503          	ld	a0,-32(s0)
    80200fb2:	00000097          	auipc	ra,0x0
    80200fb6:	b7e080e7          	jalr	-1154(ra) # 80200b30 <consputs>
            break;
    80200fba:	aa5d                	j	80201170 <printf+0x4dc>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    80200fbc:	fb843783          	ld	a5,-72(s0)
    80200fc0:	00878713          	addi	a4,a5,8
    80200fc4:	fae43c23          	sd	a4,-72(s0)
    80200fc8:	639c                	ld	a5,0(a5)
    80200fca:	fcf43423          	sd	a5,-56(s0)
            consputs("0x");
    80200fce:	00007517          	auipc	a0,0x7
    80200fd2:	be250513          	addi	a0,a0,-1054 # 80207bb0 <simple_user_task_bin+0x60>
    80200fd6:	00000097          	auipc	ra,0x0
    80200fda:	b5a080e7          	jalr	-1190(ra) # 80200b30 <consputs>
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    80200fde:	fc042823          	sw	zero,-48(s0)
    80200fe2:	a0a1                	j	8020102a <printf+0x396>
                int shift = (15 - i) * 4;
    80200fe4:	47bd                	li	a5,15
    80200fe6:	fd042703          	lw	a4,-48(s0)
    80200fea:	9f99                	subw	a5,a5,a4
    80200fec:	2781                	sext.w	a5,a5
    80200fee:	0027979b          	slliw	a5,a5,0x2
    80200ff2:	fcf42223          	sw	a5,-60(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80200ff6:	fc442783          	lw	a5,-60(s0)
    80200ffa:	873e                	mv	a4,a5
    80200ffc:	fc843783          	ld	a5,-56(s0)
    80201000:	00e7d7b3          	srl	a5,a5,a4
    80201004:	8bbd                	andi	a5,a5,15
    80201006:	00007717          	auipc	a4,0x7
    8020100a:	bb270713          	addi	a4,a4,-1102 # 80207bb8 <simple_user_task_bin+0x68>
    8020100e:	97ba                	add	a5,a5,a4
    80201010:	0007c703          	lbu	a4,0(a5)
    80201014:	fd042783          	lw	a5,-48(s0)
    80201018:	17c1                	addi	a5,a5,-16
    8020101a:	97a2                	add	a5,a5,s0
    8020101c:	fae78823          	sb	a4,-80(a5)
            for (i = 0; i < 16; i++) {
    80201020:	fd042783          	lw	a5,-48(s0)
    80201024:	2785                	addiw	a5,a5,1
    80201026:	fcf42823          	sw	a5,-48(s0)
    8020102a:	fd042783          	lw	a5,-48(s0)
    8020102e:	0007871b          	sext.w	a4,a5
    80201032:	47bd                	li	a5,15
    80201034:	fae7d8e3          	bge	a5,a4,80200fe4 <printf+0x350>
            }
            buf[16] = '\0';
    80201038:	fa040823          	sb	zero,-80(s0)
            consputs(buf);
    8020103c:	fa040793          	addi	a5,s0,-96
    80201040:	853e                	mv	a0,a5
    80201042:	00000097          	auipc	ra,0x0
    80201046:	aee080e7          	jalr	-1298(ra) # 80200b30 <consputs>
            break;
    8020104a:	a21d                	j	80201170 <printf+0x4dc>
        case 'b':
            if(is_long)
    8020104c:	fd442783          	lw	a5,-44(s0)
    80201050:	2781                	sext.w	a5,a5
    80201052:	c785                	beqz	a5,8020107a <printf+0x3e6>
                printint(va_arg(ap, long long), 2, 0, width, padzero);
    80201054:	fb843783          	ld	a5,-72(s0)
    80201058:	00878713          	addi	a4,a5,8
    8020105c:	fae43c23          	sd	a4,-72(s0)
    80201060:	639c                	ld	a5,0(a5)
    80201062:	fdc42703          	lw	a4,-36(s0)
    80201066:	fd842683          	lw	a3,-40(s0)
    8020106a:	4601                	li	a2,0
    8020106c:	4589                	li	a1,2
    8020106e:	853e                	mv	a0,a5
    80201070:	00000097          	auipc	ra,0x0
    80201074:	aea080e7          	jalr	-1302(ra) # 80200b5a <printint>
            else
                printint(va_arg(ap, int), 2, 0, width, padzero);
            break;
    80201078:	a8e5                	j	80201170 <printf+0x4dc>
                printint(va_arg(ap, int), 2, 0, width, padzero);
    8020107a:	fb843783          	ld	a5,-72(s0)
    8020107e:	00878713          	addi	a4,a5,8
    80201082:	fae43c23          	sd	a4,-72(s0)
    80201086:	439c                	lw	a5,0(a5)
    80201088:	853e                	mv	a0,a5
    8020108a:	fdc42703          	lw	a4,-36(s0)
    8020108e:	fd842783          	lw	a5,-40(s0)
    80201092:	86be                	mv	a3,a5
    80201094:	4601                	li	a2,0
    80201096:	4589                	li	a1,2
    80201098:	00000097          	auipc	ra,0x0
    8020109c:	ac2080e7          	jalr	-1342(ra) # 80200b5a <printint>
            break;
    802010a0:	a8c1                	j	80201170 <printf+0x4dc>
        case 'o':
            if(is_long)
    802010a2:	fd442783          	lw	a5,-44(s0)
    802010a6:	2781                	sext.w	a5,a5
    802010a8:	c785                	beqz	a5,802010d0 <printf+0x43c>
                printint(va_arg(ap, long long), 8, 0, width, padzero);
    802010aa:	fb843783          	ld	a5,-72(s0)
    802010ae:	00878713          	addi	a4,a5,8
    802010b2:	fae43c23          	sd	a4,-72(s0)
    802010b6:	639c                	ld	a5,0(a5)
    802010b8:	fdc42703          	lw	a4,-36(s0)
    802010bc:	fd842683          	lw	a3,-40(s0)
    802010c0:	4601                	li	a2,0
    802010c2:	45a1                	li	a1,8
    802010c4:	853e                	mv	a0,a5
    802010c6:	00000097          	auipc	ra,0x0
    802010ca:	a94080e7          	jalr	-1388(ra) # 80200b5a <printint>
            else
                printint(va_arg(ap, int), 8, 0, width, padzero);
            break;
    802010ce:	a04d                	j	80201170 <printf+0x4dc>
                printint(va_arg(ap, int), 8, 0, width, padzero);
    802010d0:	fb843783          	ld	a5,-72(s0)
    802010d4:	00878713          	addi	a4,a5,8
    802010d8:	fae43c23          	sd	a4,-72(s0)
    802010dc:	439c                	lw	a5,0(a5)
    802010de:	853e                	mv	a0,a5
    802010e0:	fdc42703          	lw	a4,-36(s0)
    802010e4:	fd842783          	lw	a5,-40(s0)
    802010e8:	86be                	mv	a3,a5
    802010ea:	4601                	li	a2,0
    802010ec:	45a1                	li	a1,8
    802010ee:	00000097          	auipc	ra,0x0
    802010f2:	a6c080e7          	jalr	-1428(ra) # 80200b5a <printint>
            break;
    802010f6:	a8ad                	j	80201170 <printf+0x4dc>
        case '%':
            buffer_char('%');
    802010f8:	02500513          	li	a0,37
    802010fc:	00000097          	auipc	ra,0x0
    80201100:	978080e7          	jalr	-1672(ra) # 80200a74 <buffer_char>
            break;
    80201104:	a0b5                	j	80201170 <printf+0x4dc>
        default:
            buffer_char('%');
    80201106:	02500513          	li	a0,37
    8020110a:	00000097          	auipc	ra,0x0
    8020110e:	96a080e7          	jalr	-1686(ra) # 80200a74 <buffer_char>
            if(padzero) buffer_char('0');
    80201112:	fdc42783          	lw	a5,-36(s0)
    80201116:	2781                	sext.w	a5,a5
    80201118:	c799                	beqz	a5,80201126 <printf+0x492>
    8020111a:	03000513          	li	a0,48
    8020111e:	00000097          	auipc	ra,0x0
    80201122:	956080e7          	jalr	-1706(ra) # 80200a74 <buffer_char>
            if(width) {
    80201126:	fd842783          	lw	a5,-40(s0)
    8020112a:	2781                	sext.w	a5,a5
    8020112c:	cf91                	beqz	a5,80201148 <printf+0x4b4>
                // 只支持一位宽度，简单处理
                buffer_char('0' + width);
    8020112e:	fd842783          	lw	a5,-40(s0)
    80201132:	0ff7f793          	zext.b	a5,a5
    80201136:	0307879b          	addiw	a5,a5,48
    8020113a:	0ff7f793          	zext.b	a5,a5
    8020113e:	853e                	mv	a0,a5
    80201140:	00000097          	auipc	ra,0x0
    80201144:	934080e7          	jalr	-1740(ra) # 80200a74 <buffer_char>
            }
            if(is_long) buffer_char('l');
    80201148:	fd442783          	lw	a5,-44(s0)
    8020114c:	2781                	sext.w	a5,a5
    8020114e:	c799                	beqz	a5,8020115c <printf+0x4c8>
    80201150:	06c00513          	li	a0,108
    80201154:	00000097          	auipc	ra,0x0
    80201158:	920080e7          	jalr	-1760(ra) # 80200a74 <buffer_char>
            buffer_char(c);
    8020115c:	fe842783          	lw	a5,-24(s0)
    80201160:	0ff7f793          	zext.b	a5,a5
    80201164:	853e                	mv	a0,a5
    80201166:	00000097          	auipc	ra,0x0
    8020116a:	90e080e7          	jalr	-1778(ra) # 80200a74 <buffer_char>
            break;
    8020116e:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80201170:	fec42783          	lw	a5,-20(s0)
    80201174:	2785                	addiw	a5,a5,1
    80201176:	fef42623          	sw	a5,-20(s0)
    8020117a:	fec42783          	lw	a5,-20(s0)
    8020117e:	f9843703          	ld	a4,-104(s0)
    80201182:	97ba                	add	a5,a5,a4
    80201184:	0007c783          	lbu	a5,0(a5)
    80201188:	fef42423          	sw	a5,-24(s0)
    8020118c:	fe842783          	lw	a5,-24(s0)
    80201190:	2781                	sext.w	a5,a5
    80201192:	b2079de3          	bnez	a5,80200ccc <printf+0x38>
    80201196:	a011                	j	8020119a <printf+0x506>
                break;
    80201198:	0001                	nop
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    8020119a:	00000097          	auipc	ra,0x0
    8020119e:	886080e7          	jalr	-1914(ra) # 80200a20 <flush_printf_buffer>
    va_end(ap);
}
    802011a2:	0001                	nop
    802011a4:	70a6                	ld	ra,104(sp)
    802011a6:	7406                	ld	s0,96(sp)
    802011a8:	614d                	addi	sp,sp,176
    802011aa:	8082                	ret

00000000802011ac <clear_screen>:
// 清屏功能
void clear_screen(void) {
    802011ac:	1141                	addi	sp,sp,-16
    802011ae:	e406                	sd	ra,8(sp)
    802011b0:	e022                	sd	s0,0(sp)
    802011b2:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    802011b4:	00007517          	auipc	a0,0x7
    802011b8:	a7450513          	addi	a0,a0,-1420 # 80207c28 <simple_user_task_bin+0xd8>
    802011bc:	fffff097          	auipc	ra,0xfffff
    802011c0:	482080e7          	jalr	1154(ra) # 8020063e <uart_puts>
	uart_puts(CURSOR_HOME);
    802011c4:	00007517          	auipc	a0,0x7
    802011c8:	a6c50513          	addi	a0,a0,-1428 # 80207c30 <simple_user_task_bin+0xe0>
    802011cc:	fffff097          	auipc	ra,0xfffff
    802011d0:	472080e7          	jalr	1138(ra) # 8020063e <uart_puts>
}
    802011d4:	0001                	nop
    802011d6:	60a2                	ld	ra,8(sp)
    802011d8:	6402                	ld	s0,0(sp)
    802011da:	0141                	addi	sp,sp,16
    802011dc:	8082                	ret

00000000802011de <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    802011de:	1101                	addi	sp,sp,-32
    802011e0:	ec06                	sd	ra,24(sp)
    802011e2:	e822                	sd	s0,16(sp)
    802011e4:	1000                	addi	s0,sp,32
    802011e6:	87aa                	mv	a5,a0
    802011e8:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    802011ec:	fec42783          	lw	a5,-20(s0)
    802011f0:	2781                	sext.w	a5,a5
    802011f2:	02f05f63          	blez	a5,80201230 <cursor_up+0x52>
    consputc('\033');
    802011f6:	456d                	li	a0,27
    802011f8:	00000097          	auipc	ra,0x0
    802011fc:	90e080e7          	jalr	-1778(ra) # 80200b06 <consputc>
    consputc('[');
    80201200:	05b00513          	li	a0,91
    80201204:	00000097          	auipc	ra,0x0
    80201208:	902080e7          	jalr	-1790(ra) # 80200b06 <consputc>
    printint(lines, 10, 0, 0,0);
    8020120c:	fec42783          	lw	a5,-20(s0)
    80201210:	4701                	li	a4,0
    80201212:	4681                	li	a3,0
    80201214:	4601                	li	a2,0
    80201216:	45a9                	li	a1,10
    80201218:	853e                	mv	a0,a5
    8020121a:	00000097          	auipc	ra,0x0
    8020121e:	940080e7          	jalr	-1728(ra) # 80200b5a <printint>
    consputc('A');
    80201222:	04100513          	li	a0,65
    80201226:	00000097          	auipc	ra,0x0
    8020122a:	8e0080e7          	jalr	-1824(ra) # 80200b06 <consputc>
    8020122e:	a011                	j	80201232 <cursor_up+0x54>
    if (lines <= 0) return;
    80201230:	0001                	nop
}
    80201232:	60e2                	ld	ra,24(sp)
    80201234:	6442                	ld	s0,16(sp)
    80201236:	6105                	addi	sp,sp,32
    80201238:	8082                	ret

000000008020123a <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    8020123a:	1101                	addi	sp,sp,-32
    8020123c:	ec06                	sd	ra,24(sp)
    8020123e:	e822                	sd	s0,16(sp)
    80201240:	1000                	addi	s0,sp,32
    80201242:	87aa                	mv	a5,a0
    80201244:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    80201248:	fec42783          	lw	a5,-20(s0)
    8020124c:	2781                	sext.w	a5,a5
    8020124e:	02f05f63          	blez	a5,8020128c <cursor_down+0x52>
    consputc('\033');
    80201252:	456d                	li	a0,27
    80201254:	00000097          	auipc	ra,0x0
    80201258:	8b2080e7          	jalr	-1870(ra) # 80200b06 <consputc>
    consputc('[');
    8020125c:	05b00513          	li	a0,91
    80201260:	00000097          	auipc	ra,0x0
    80201264:	8a6080e7          	jalr	-1882(ra) # 80200b06 <consputc>
    printint(lines, 10, 0, 0,0);
    80201268:	fec42783          	lw	a5,-20(s0)
    8020126c:	4701                	li	a4,0
    8020126e:	4681                	li	a3,0
    80201270:	4601                	li	a2,0
    80201272:	45a9                	li	a1,10
    80201274:	853e                	mv	a0,a5
    80201276:	00000097          	auipc	ra,0x0
    8020127a:	8e4080e7          	jalr	-1820(ra) # 80200b5a <printint>
    consputc('B');
    8020127e:	04200513          	li	a0,66
    80201282:	00000097          	auipc	ra,0x0
    80201286:	884080e7          	jalr	-1916(ra) # 80200b06 <consputc>
    8020128a:	a011                	j	8020128e <cursor_down+0x54>
    if (lines <= 0) return;
    8020128c:	0001                	nop
}
    8020128e:	60e2                	ld	ra,24(sp)
    80201290:	6442                	ld	s0,16(sp)
    80201292:	6105                	addi	sp,sp,32
    80201294:	8082                	ret

0000000080201296 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    80201296:	1101                	addi	sp,sp,-32
    80201298:	ec06                	sd	ra,24(sp)
    8020129a:	e822                	sd	s0,16(sp)
    8020129c:	1000                	addi	s0,sp,32
    8020129e:	87aa                	mv	a5,a0
    802012a0:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    802012a4:	fec42783          	lw	a5,-20(s0)
    802012a8:	2781                	sext.w	a5,a5
    802012aa:	02f05f63          	blez	a5,802012e8 <cursor_right+0x52>
    consputc('\033');
    802012ae:	456d                	li	a0,27
    802012b0:	00000097          	auipc	ra,0x0
    802012b4:	856080e7          	jalr	-1962(ra) # 80200b06 <consputc>
    consputc('[');
    802012b8:	05b00513          	li	a0,91
    802012bc:	00000097          	auipc	ra,0x0
    802012c0:	84a080e7          	jalr	-1974(ra) # 80200b06 <consputc>
    printint(cols, 10, 0,0,0);
    802012c4:	fec42783          	lw	a5,-20(s0)
    802012c8:	4701                	li	a4,0
    802012ca:	4681                	li	a3,0
    802012cc:	4601                	li	a2,0
    802012ce:	45a9                	li	a1,10
    802012d0:	853e                	mv	a0,a5
    802012d2:	00000097          	auipc	ra,0x0
    802012d6:	888080e7          	jalr	-1912(ra) # 80200b5a <printint>
    consputc('C');
    802012da:	04300513          	li	a0,67
    802012de:	00000097          	auipc	ra,0x0
    802012e2:	828080e7          	jalr	-2008(ra) # 80200b06 <consputc>
    802012e6:	a011                	j	802012ea <cursor_right+0x54>
    if (cols <= 0) return;
    802012e8:	0001                	nop
}
    802012ea:	60e2                	ld	ra,24(sp)
    802012ec:	6442                	ld	s0,16(sp)
    802012ee:	6105                	addi	sp,sp,32
    802012f0:	8082                	ret

00000000802012f2 <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    802012f2:	1101                	addi	sp,sp,-32
    802012f4:	ec06                	sd	ra,24(sp)
    802012f6:	e822                	sd	s0,16(sp)
    802012f8:	1000                	addi	s0,sp,32
    802012fa:	87aa                	mv	a5,a0
    802012fc:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80201300:	fec42783          	lw	a5,-20(s0)
    80201304:	2781                	sext.w	a5,a5
    80201306:	02f05f63          	blez	a5,80201344 <cursor_left+0x52>
    consputc('\033');
    8020130a:	456d                	li	a0,27
    8020130c:	fffff097          	auipc	ra,0xfffff
    80201310:	7fa080e7          	jalr	2042(ra) # 80200b06 <consputc>
    consputc('[');
    80201314:	05b00513          	li	a0,91
    80201318:	fffff097          	auipc	ra,0xfffff
    8020131c:	7ee080e7          	jalr	2030(ra) # 80200b06 <consputc>
    printint(cols, 10, 0,0,0);
    80201320:	fec42783          	lw	a5,-20(s0)
    80201324:	4701                	li	a4,0
    80201326:	4681                	li	a3,0
    80201328:	4601                	li	a2,0
    8020132a:	45a9                	li	a1,10
    8020132c:	853e                	mv	a0,a5
    8020132e:	00000097          	auipc	ra,0x0
    80201332:	82c080e7          	jalr	-2004(ra) # 80200b5a <printint>
    consputc('D');
    80201336:	04400513          	li	a0,68
    8020133a:	fffff097          	auipc	ra,0xfffff
    8020133e:	7cc080e7          	jalr	1996(ra) # 80200b06 <consputc>
    80201342:	a011                	j	80201346 <cursor_left+0x54>
    if (cols <= 0) return;
    80201344:	0001                	nop
}
    80201346:	60e2                	ld	ra,24(sp)
    80201348:	6442                	ld	s0,16(sp)
    8020134a:	6105                	addi	sp,sp,32
    8020134c:	8082                	ret

000000008020134e <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    8020134e:	1141                	addi	sp,sp,-16
    80201350:	e406                	sd	ra,8(sp)
    80201352:	e022                	sd	s0,0(sp)
    80201354:	0800                	addi	s0,sp,16
    consputc('\033');
    80201356:	456d                	li	a0,27
    80201358:	fffff097          	auipc	ra,0xfffff
    8020135c:	7ae080e7          	jalr	1966(ra) # 80200b06 <consputc>
    consputc('[');
    80201360:	05b00513          	li	a0,91
    80201364:	fffff097          	auipc	ra,0xfffff
    80201368:	7a2080e7          	jalr	1954(ra) # 80200b06 <consputc>
    consputc('s');
    8020136c:	07300513          	li	a0,115
    80201370:	fffff097          	auipc	ra,0xfffff
    80201374:	796080e7          	jalr	1942(ra) # 80200b06 <consputc>
}
    80201378:	0001                	nop
    8020137a:	60a2                	ld	ra,8(sp)
    8020137c:	6402                	ld	s0,0(sp)
    8020137e:	0141                	addi	sp,sp,16
    80201380:	8082                	ret

0000000080201382 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    80201382:	1141                	addi	sp,sp,-16
    80201384:	e406                	sd	ra,8(sp)
    80201386:	e022                	sd	s0,0(sp)
    80201388:	0800                	addi	s0,sp,16
    consputc('\033');
    8020138a:	456d                	li	a0,27
    8020138c:	fffff097          	auipc	ra,0xfffff
    80201390:	77a080e7          	jalr	1914(ra) # 80200b06 <consputc>
    consputc('[');
    80201394:	05b00513          	li	a0,91
    80201398:	fffff097          	auipc	ra,0xfffff
    8020139c:	76e080e7          	jalr	1902(ra) # 80200b06 <consputc>
    consputc('u');
    802013a0:	07500513          	li	a0,117
    802013a4:	fffff097          	auipc	ra,0xfffff
    802013a8:	762080e7          	jalr	1890(ra) # 80200b06 <consputc>
}
    802013ac:	0001                	nop
    802013ae:	60a2                	ld	ra,8(sp)
    802013b0:	6402                	ld	s0,0(sp)
    802013b2:	0141                	addi	sp,sp,16
    802013b4:	8082                	ret

00000000802013b6 <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    802013b6:	1101                	addi	sp,sp,-32
    802013b8:	ec06                	sd	ra,24(sp)
    802013ba:	e822                	sd	s0,16(sp)
    802013bc:	1000                	addi	s0,sp,32
    802013be:	87aa                	mv	a5,a0
    802013c0:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    802013c4:	fec42783          	lw	a5,-20(s0)
    802013c8:	2781                	sext.w	a5,a5
    802013ca:	00f04563          	bgtz	a5,802013d4 <cursor_to_column+0x1e>
    802013ce:	4785                	li	a5,1
    802013d0:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    802013d4:	456d                	li	a0,27
    802013d6:	fffff097          	auipc	ra,0xfffff
    802013da:	730080e7          	jalr	1840(ra) # 80200b06 <consputc>
    consputc('[');
    802013de:	05b00513          	li	a0,91
    802013e2:	fffff097          	auipc	ra,0xfffff
    802013e6:	724080e7          	jalr	1828(ra) # 80200b06 <consputc>
    printint(col, 10, 0,0,0);
    802013ea:	fec42783          	lw	a5,-20(s0)
    802013ee:	4701                	li	a4,0
    802013f0:	4681                	li	a3,0
    802013f2:	4601                	li	a2,0
    802013f4:	45a9                	li	a1,10
    802013f6:	853e                	mv	a0,a5
    802013f8:	fffff097          	auipc	ra,0xfffff
    802013fc:	762080e7          	jalr	1890(ra) # 80200b5a <printint>
    consputc('G');
    80201400:	04700513          	li	a0,71
    80201404:	fffff097          	auipc	ra,0xfffff
    80201408:	702080e7          	jalr	1794(ra) # 80200b06 <consputc>
}
    8020140c:	0001                	nop
    8020140e:	60e2                	ld	ra,24(sp)
    80201410:	6442                	ld	s0,16(sp)
    80201412:	6105                	addi	sp,sp,32
    80201414:	8082                	ret

0000000080201416 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80201416:	1101                	addi	sp,sp,-32
    80201418:	ec06                	sd	ra,24(sp)
    8020141a:	e822                	sd	s0,16(sp)
    8020141c:	1000                	addi	s0,sp,32
    8020141e:	87aa                	mv	a5,a0
    80201420:	872e                	mv	a4,a1
    80201422:	fef42623          	sw	a5,-20(s0)
    80201426:	87ba                	mv	a5,a4
    80201428:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    8020142c:	456d                	li	a0,27
    8020142e:	fffff097          	auipc	ra,0xfffff
    80201432:	6d8080e7          	jalr	1752(ra) # 80200b06 <consputc>
    consputc('[');
    80201436:	05b00513          	li	a0,91
    8020143a:	fffff097          	auipc	ra,0xfffff
    8020143e:	6cc080e7          	jalr	1740(ra) # 80200b06 <consputc>
    printint(row, 10, 0,0,0);
    80201442:	fec42783          	lw	a5,-20(s0)
    80201446:	4701                	li	a4,0
    80201448:	4681                	li	a3,0
    8020144a:	4601                	li	a2,0
    8020144c:	45a9                	li	a1,10
    8020144e:	853e                	mv	a0,a5
    80201450:	fffff097          	auipc	ra,0xfffff
    80201454:	70a080e7          	jalr	1802(ra) # 80200b5a <printint>
    consputc(';');
    80201458:	03b00513          	li	a0,59
    8020145c:	fffff097          	auipc	ra,0xfffff
    80201460:	6aa080e7          	jalr	1706(ra) # 80200b06 <consputc>
    printint(col, 10, 0,0,0);
    80201464:	fe842783          	lw	a5,-24(s0)
    80201468:	4701                	li	a4,0
    8020146a:	4681                	li	a3,0
    8020146c:	4601                	li	a2,0
    8020146e:	45a9                	li	a1,10
    80201470:	853e                	mv	a0,a5
    80201472:	fffff097          	auipc	ra,0xfffff
    80201476:	6e8080e7          	jalr	1768(ra) # 80200b5a <printint>
    consputc('H');
    8020147a:	04800513          	li	a0,72
    8020147e:	fffff097          	auipc	ra,0xfffff
    80201482:	688080e7          	jalr	1672(ra) # 80200b06 <consputc>
}
    80201486:	0001                	nop
    80201488:	60e2                	ld	ra,24(sp)
    8020148a:	6442                	ld	s0,16(sp)
    8020148c:	6105                	addi	sp,sp,32
    8020148e:	8082                	ret

0000000080201490 <reset_color>:
// 颜色控制
void reset_color(void) {
    80201490:	1141                	addi	sp,sp,-16
    80201492:	e406                	sd	ra,8(sp)
    80201494:	e022                	sd	s0,0(sp)
    80201496:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    80201498:	00006517          	auipc	a0,0x6
    8020149c:	7a050513          	addi	a0,a0,1952 # 80207c38 <simple_user_task_bin+0xe8>
    802014a0:	fffff097          	auipc	ra,0xfffff
    802014a4:	19e080e7          	jalr	414(ra) # 8020063e <uart_puts>
}
    802014a8:	0001                	nop
    802014aa:	60a2                	ld	ra,8(sp)
    802014ac:	6402                	ld	s0,0(sp)
    802014ae:	0141                	addi	sp,sp,16
    802014b0:	8082                	ret

00000000802014b2 <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    802014b2:	1101                	addi	sp,sp,-32
    802014b4:	ec06                	sd	ra,24(sp)
    802014b6:	e822                	sd	s0,16(sp)
    802014b8:	1000                	addi	s0,sp,32
    802014ba:	87aa                	mv	a5,a0
    802014bc:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    802014c0:	fec42783          	lw	a5,-20(s0)
    802014c4:	0007871b          	sext.w	a4,a5
    802014c8:	47f5                	li	a5,29
    802014ca:	04e7d763          	bge	a5,a4,80201518 <set_fg_color+0x66>
    802014ce:	fec42783          	lw	a5,-20(s0)
    802014d2:	0007871b          	sext.w	a4,a5
    802014d6:	02500793          	li	a5,37
    802014da:	02e7cf63          	blt	a5,a4,80201518 <set_fg_color+0x66>
	consputc('\033');
    802014de:	456d                	li	a0,27
    802014e0:	fffff097          	auipc	ra,0xfffff
    802014e4:	626080e7          	jalr	1574(ra) # 80200b06 <consputc>
	consputc('[');
    802014e8:	05b00513          	li	a0,91
    802014ec:	fffff097          	auipc	ra,0xfffff
    802014f0:	61a080e7          	jalr	1562(ra) # 80200b06 <consputc>
	printint(color, 10, 0,0,0);
    802014f4:	fec42783          	lw	a5,-20(s0)
    802014f8:	4701                	li	a4,0
    802014fa:	4681                	li	a3,0
    802014fc:	4601                	li	a2,0
    802014fe:	45a9                	li	a1,10
    80201500:	853e                	mv	a0,a5
    80201502:	fffff097          	auipc	ra,0xfffff
    80201506:	658080e7          	jalr	1624(ra) # 80200b5a <printint>
	consputc('m');
    8020150a:	06d00513          	li	a0,109
    8020150e:	fffff097          	auipc	ra,0xfffff
    80201512:	5f8080e7          	jalr	1528(ra) # 80200b06 <consputc>
    80201516:	a011                	j	8020151a <set_fg_color+0x68>
	if (color < 30 || color > 37) return; // 支持30-37
    80201518:	0001                	nop
}
    8020151a:	60e2                	ld	ra,24(sp)
    8020151c:	6442                	ld	s0,16(sp)
    8020151e:	6105                	addi	sp,sp,32
    80201520:	8082                	ret

0000000080201522 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    80201522:	1101                	addi	sp,sp,-32
    80201524:	ec06                	sd	ra,24(sp)
    80201526:	e822                	sd	s0,16(sp)
    80201528:	1000                	addi	s0,sp,32
    8020152a:	87aa                	mv	a5,a0
    8020152c:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    80201530:	fec42783          	lw	a5,-20(s0)
    80201534:	0007871b          	sext.w	a4,a5
    80201538:	02700793          	li	a5,39
    8020153c:	04e7d763          	bge	a5,a4,8020158a <set_bg_color+0x68>
    80201540:	fec42783          	lw	a5,-20(s0)
    80201544:	0007871b          	sext.w	a4,a5
    80201548:	02f00793          	li	a5,47
    8020154c:	02e7cf63          	blt	a5,a4,8020158a <set_bg_color+0x68>
	consputc('\033');
    80201550:	456d                	li	a0,27
    80201552:	fffff097          	auipc	ra,0xfffff
    80201556:	5b4080e7          	jalr	1460(ra) # 80200b06 <consputc>
	consputc('[');
    8020155a:	05b00513          	li	a0,91
    8020155e:	fffff097          	auipc	ra,0xfffff
    80201562:	5a8080e7          	jalr	1448(ra) # 80200b06 <consputc>
	printint(color, 10, 0,0,0);
    80201566:	fec42783          	lw	a5,-20(s0)
    8020156a:	4701                	li	a4,0
    8020156c:	4681                	li	a3,0
    8020156e:	4601                	li	a2,0
    80201570:	45a9                	li	a1,10
    80201572:	853e                	mv	a0,a5
    80201574:	fffff097          	auipc	ra,0xfffff
    80201578:	5e6080e7          	jalr	1510(ra) # 80200b5a <printint>
	consputc('m');
    8020157c:	06d00513          	li	a0,109
    80201580:	fffff097          	auipc	ra,0xfffff
    80201584:	586080e7          	jalr	1414(ra) # 80200b06 <consputc>
    80201588:	a011                	j	8020158c <set_bg_color+0x6a>
	if (color < 40 || color > 47) return; // 支持40-47
    8020158a:	0001                	nop
}
    8020158c:	60e2                	ld	ra,24(sp)
    8020158e:	6442                	ld	s0,16(sp)
    80201590:	6105                	addi	sp,sp,32
    80201592:	8082                	ret

0000000080201594 <color_red>:
// 简易文字颜色
void color_red(void) {
    80201594:	1141                	addi	sp,sp,-16
    80201596:	e406                	sd	ra,8(sp)
    80201598:	e022                	sd	s0,0(sp)
    8020159a:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    8020159c:	457d                	li	a0,31
    8020159e:	00000097          	auipc	ra,0x0
    802015a2:	f14080e7          	jalr	-236(ra) # 802014b2 <set_fg_color>
}
    802015a6:	0001                	nop
    802015a8:	60a2                	ld	ra,8(sp)
    802015aa:	6402                	ld	s0,0(sp)
    802015ac:	0141                	addi	sp,sp,16
    802015ae:	8082                	ret

00000000802015b0 <color_green>:
void color_green(void) {
    802015b0:	1141                	addi	sp,sp,-16
    802015b2:	e406                	sd	ra,8(sp)
    802015b4:	e022                	sd	s0,0(sp)
    802015b6:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    802015b8:	02000513          	li	a0,32
    802015bc:	00000097          	auipc	ra,0x0
    802015c0:	ef6080e7          	jalr	-266(ra) # 802014b2 <set_fg_color>
}
    802015c4:	0001                	nop
    802015c6:	60a2                	ld	ra,8(sp)
    802015c8:	6402                	ld	s0,0(sp)
    802015ca:	0141                	addi	sp,sp,16
    802015cc:	8082                	ret

00000000802015ce <color_yellow>:
void color_yellow(void) {
    802015ce:	1141                	addi	sp,sp,-16
    802015d0:	e406                	sd	ra,8(sp)
    802015d2:	e022                	sd	s0,0(sp)
    802015d4:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    802015d6:	02100513          	li	a0,33
    802015da:	00000097          	auipc	ra,0x0
    802015de:	ed8080e7          	jalr	-296(ra) # 802014b2 <set_fg_color>
}
    802015e2:	0001                	nop
    802015e4:	60a2                	ld	ra,8(sp)
    802015e6:	6402                	ld	s0,0(sp)
    802015e8:	0141                	addi	sp,sp,16
    802015ea:	8082                	ret

00000000802015ec <color_blue>:
void color_blue(void) {
    802015ec:	1141                	addi	sp,sp,-16
    802015ee:	e406                	sd	ra,8(sp)
    802015f0:	e022                	sd	s0,0(sp)
    802015f2:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    802015f4:	02200513          	li	a0,34
    802015f8:	00000097          	auipc	ra,0x0
    802015fc:	eba080e7          	jalr	-326(ra) # 802014b2 <set_fg_color>
}
    80201600:	0001                	nop
    80201602:	60a2                	ld	ra,8(sp)
    80201604:	6402                	ld	s0,0(sp)
    80201606:	0141                	addi	sp,sp,16
    80201608:	8082                	ret

000000008020160a <color_purple>:
void color_purple(void) {
    8020160a:	1141                	addi	sp,sp,-16
    8020160c:	e406                	sd	ra,8(sp)
    8020160e:	e022                	sd	s0,0(sp)
    80201610:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80201612:	02300513          	li	a0,35
    80201616:	00000097          	auipc	ra,0x0
    8020161a:	e9c080e7          	jalr	-356(ra) # 802014b2 <set_fg_color>
}
    8020161e:	0001                	nop
    80201620:	60a2                	ld	ra,8(sp)
    80201622:	6402                	ld	s0,0(sp)
    80201624:	0141                	addi	sp,sp,16
    80201626:	8082                	ret

0000000080201628 <color_cyan>:
void color_cyan(void) {
    80201628:	1141                	addi	sp,sp,-16
    8020162a:	e406                	sd	ra,8(sp)
    8020162c:	e022                	sd	s0,0(sp)
    8020162e:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    80201630:	02400513          	li	a0,36
    80201634:	00000097          	auipc	ra,0x0
    80201638:	e7e080e7          	jalr	-386(ra) # 802014b2 <set_fg_color>
}
    8020163c:	0001                	nop
    8020163e:	60a2                	ld	ra,8(sp)
    80201640:	6402                	ld	s0,0(sp)
    80201642:	0141                	addi	sp,sp,16
    80201644:	8082                	ret

0000000080201646 <color_reverse>:
void color_reverse(void){
    80201646:	1141                	addi	sp,sp,-16
    80201648:	e406                	sd	ra,8(sp)
    8020164a:	e022                	sd	s0,0(sp)
    8020164c:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    8020164e:	02500513          	li	a0,37
    80201652:	00000097          	auipc	ra,0x0
    80201656:	e60080e7          	jalr	-416(ra) # 802014b2 <set_fg_color>
}
    8020165a:	0001                	nop
    8020165c:	60a2                	ld	ra,8(sp)
    8020165e:	6402                	ld	s0,0(sp)
    80201660:	0141                	addi	sp,sp,16
    80201662:	8082                	ret

0000000080201664 <set_color>:
void set_color(int fg, int bg) {
    80201664:	1101                	addi	sp,sp,-32
    80201666:	ec06                	sd	ra,24(sp)
    80201668:	e822                	sd	s0,16(sp)
    8020166a:	1000                	addi	s0,sp,32
    8020166c:	87aa                	mv	a5,a0
    8020166e:	872e                	mv	a4,a1
    80201670:	fef42623          	sw	a5,-20(s0)
    80201674:	87ba                	mv	a5,a4
    80201676:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    8020167a:	fe842783          	lw	a5,-24(s0)
    8020167e:	853e                	mv	a0,a5
    80201680:	00000097          	auipc	ra,0x0
    80201684:	ea2080e7          	jalr	-350(ra) # 80201522 <set_bg_color>
	set_fg_color(fg);
    80201688:	fec42783          	lw	a5,-20(s0)
    8020168c:	853e                	mv	a0,a5
    8020168e:	00000097          	auipc	ra,0x0
    80201692:	e24080e7          	jalr	-476(ra) # 802014b2 <set_fg_color>
}
    80201696:	0001                	nop
    80201698:	60e2                	ld	ra,24(sp)
    8020169a:	6442                	ld	s0,16(sp)
    8020169c:	6105                	addi	sp,sp,32
    8020169e:	8082                	ret

00000000802016a0 <clear_line>:
void clear_line(){
    802016a0:	1141                	addi	sp,sp,-16
    802016a2:	e406                	sd	ra,8(sp)
    802016a4:	e022                	sd	s0,0(sp)
    802016a6:	0800                	addi	s0,sp,16
	consputc('\033');
    802016a8:	456d                	li	a0,27
    802016aa:	fffff097          	auipc	ra,0xfffff
    802016ae:	45c080e7          	jalr	1116(ra) # 80200b06 <consputc>
	consputc('[');
    802016b2:	05b00513          	li	a0,91
    802016b6:	fffff097          	auipc	ra,0xfffff
    802016ba:	450080e7          	jalr	1104(ra) # 80200b06 <consputc>
	consputc('2');
    802016be:	03200513          	li	a0,50
    802016c2:	fffff097          	auipc	ra,0xfffff
    802016c6:	444080e7          	jalr	1092(ra) # 80200b06 <consputc>
	consputc('K');
    802016ca:	04b00513          	li	a0,75
    802016ce:	fffff097          	auipc	ra,0xfffff
    802016d2:	438080e7          	jalr	1080(ra) # 80200b06 <consputc>
}
    802016d6:	0001                	nop
    802016d8:	60a2                	ld	ra,8(sp)
    802016da:	6402                	ld	s0,0(sp)
    802016dc:	0141                	addi	sp,sp,16
    802016de:	8082                	ret

00000000802016e0 <panic>:

void panic(const char *msg) {
    802016e0:	1101                	addi	sp,sp,-32
    802016e2:	ec06                	sd	ra,24(sp)
    802016e4:	e822                	sd	s0,16(sp)
    802016e6:	1000                	addi	s0,sp,32
    802016e8:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    802016ec:	00000097          	auipc	ra,0x0
    802016f0:	ea8080e7          	jalr	-344(ra) # 80201594 <color_red>
	printf("panic: %s\n", msg);
    802016f4:	fe843583          	ld	a1,-24(s0)
    802016f8:	00006517          	auipc	a0,0x6
    802016fc:	54850513          	addi	a0,a0,1352 # 80207c40 <simple_user_task_bin+0xf0>
    80201700:	fffff097          	auipc	ra,0xfffff
    80201704:	594080e7          	jalr	1428(ra) # 80200c94 <printf>
	reset_color();
    80201708:	00000097          	auipc	ra,0x0
    8020170c:	d88080e7          	jalr	-632(ra) # 80201490 <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    80201710:	0001                	nop
    80201712:	bffd                	j	80201710 <panic+0x30>

0000000080201714 <warning>:
}
void warning(const char *fmt, ...) {
    80201714:	7159                	addi	sp,sp,-112
    80201716:	f406                	sd	ra,40(sp)
    80201718:	f022                	sd	s0,32(sp)
    8020171a:	1800                	addi	s0,sp,48
    8020171c:	fca43c23          	sd	a0,-40(s0)
    80201720:	e40c                	sd	a1,8(s0)
    80201722:	e810                	sd	a2,16(s0)
    80201724:	ec14                	sd	a3,24(s0)
    80201726:	f018                	sd	a4,32(s0)
    80201728:	f41c                	sd	a5,40(s0)
    8020172a:	03043823          	sd	a6,48(s0)
    8020172e:	03143c23          	sd	a7,56(s0)
    va_list ap;
    color_purple(); // 设置紫色
    80201732:	00000097          	auipc	ra,0x0
    80201736:	ed8080e7          	jalr	-296(ra) # 8020160a <color_purple>
    printf("[WARNING] ");
    8020173a:	00006517          	auipc	a0,0x6
    8020173e:	51650513          	addi	a0,a0,1302 # 80207c50 <simple_user_task_bin+0x100>
    80201742:	fffff097          	auipc	ra,0xfffff
    80201746:	552080e7          	jalr	1362(ra) # 80200c94 <printf>
    va_start(ap, fmt);
    8020174a:	04040793          	addi	a5,s0,64
    8020174e:	fcf43823          	sd	a5,-48(s0)
    80201752:	fd043783          	ld	a5,-48(s0)
    80201756:	fc878793          	addi	a5,a5,-56
    8020175a:	fef43423          	sd	a5,-24(s0)
    printf(fmt, ap);
    8020175e:	fe843783          	ld	a5,-24(s0)
    80201762:	85be                	mv	a1,a5
    80201764:	fd843503          	ld	a0,-40(s0)
    80201768:	fffff097          	auipc	ra,0xfffff
    8020176c:	52c080e7          	jalr	1324(ra) # 80200c94 <printf>
    va_end(ap);
    reset_color(); // 恢复默认颜色
    80201770:	00000097          	auipc	ra,0x0
    80201774:	d20080e7          	jalr	-736(ra) # 80201490 <reset_color>
}
    80201778:	0001                	nop
    8020177a:	70a2                	ld	ra,40(sp)
    8020177c:	7402                	ld	s0,32(sp)
    8020177e:	6165                	addi	sp,sp,112
    80201780:	8082                	ret

0000000080201782 <test_printf_precision>:
void test_printf_precision(void) {
    80201782:	1101                	addi	sp,sp,-32
    80201784:	ec06                	sd	ra,24(sp)
    80201786:	e822                	sd	s0,16(sp)
    80201788:	1000                	addi	s0,sp,32
	clear_screen();
    8020178a:	00000097          	auipc	ra,0x0
    8020178e:	a22080e7          	jalr	-1502(ra) # 802011ac <clear_screen>
    printf("=== 详细的printf测试 ===\n");
    80201792:	00006517          	auipc	a0,0x6
    80201796:	4ce50513          	addi	a0,a0,1230 # 80207c60 <simple_user_task_bin+0x110>
    8020179a:	fffff097          	auipc	ra,0xfffff
    8020179e:	4fa080e7          	jalr	1274(ra) # 80200c94 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    802017a2:	00006517          	auipc	a0,0x6
    802017a6:	4de50513          	addi	a0,a0,1246 # 80207c80 <simple_user_task_bin+0x130>
    802017aa:	fffff097          	auipc	ra,0xfffff
    802017ae:	4ea080e7          	jalr	1258(ra) # 80200c94 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    802017b2:	0ff00593          	li	a1,255
    802017b6:	00006517          	auipc	a0,0x6
    802017ba:	4e250513          	addi	a0,a0,1250 # 80207c98 <simple_user_task_bin+0x148>
    802017be:	fffff097          	auipc	ra,0xfffff
    802017c2:	4d6080e7          	jalr	1238(ra) # 80200c94 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    802017c6:	6585                	lui	a1,0x1
    802017c8:	00006517          	auipc	a0,0x6
    802017cc:	4f050513          	addi	a0,a0,1264 # 80207cb8 <simple_user_task_bin+0x168>
    802017d0:	fffff097          	auipc	ra,0xfffff
    802017d4:	4c4080e7          	jalr	1220(ra) # 80200c94 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    802017d8:	1234b7b7          	lui	a5,0x1234b
    802017dc:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    802017e0:	00006517          	auipc	a0,0x6
    802017e4:	4f850513          	addi	a0,a0,1272 # 80207cd8 <simple_user_task_bin+0x188>
    802017e8:	fffff097          	auipc	ra,0xfffff
    802017ec:	4ac080e7          	jalr	1196(ra) # 80200c94 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    802017f0:	00006517          	auipc	a0,0x6
    802017f4:	50050513          	addi	a0,a0,1280 # 80207cf0 <simple_user_task_bin+0x1a0>
    802017f8:	fffff097          	auipc	ra,0xfffff
    802017fc:	49c080e7          	jalr	1180(ra) # 80200c94 <printf>
    printf("  正数: %d\n", 42);
    80201800:	02a00593          	li	a1,42
    80201804:	00006517          	auipc	a0,0x6
    80201808:	50450513          	addi	a0,a0,1284 # 80207d08 <simple_user_task_bin+0x1b8>
    8020180c:	fffff097          	auipc	ra,0xfffff
    80201810:	488080e7          	jalr	1160(ra) # 80200c94 <printf>
    printf("  负数: %d\n", -42);
    80201814:	fd600593          	li	a1,-42
    80201818:	00006517          	auipc	a0,0x6
    8020181c:	50050513          	addi	a0,a0,1280 # 80207d18 <simple_user_task_bin+0x1c8>
    80201820:	fffff097          	auipc	ra,0xfffff
    80201824:	474080e7          	jalr	1140(ra) # 80200c94 <printf>
    printf("  零: %d\n", 0);
    80201828:	4581                	li	a1,0
    8020182a:	00006517          	auipc	a0,0x6
    8020182e:	4fe50513          	addi	a0,a0,1278 # 80207d28 <simple_user_task_bin+0x1d8>
    80201832:	fffff097          	auipc	ra,0xfffff
    80201836:	462080e7          	jalr	1122(ra) # 80200c94 <printf>
    printf("  大数: %d\n", 123456789);
    8020183a:	075bd7b7          	lui	a5,0x75bd
    8020183e:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    80201842:	00006517          	auipc	a0,0x6
    80201846:	4f650513          	addi	a0,a0,1270 # 80207d38 <simple_user_task_bin+0x1e8>
    8020184a:	fffff097          	auipc	ra,0xfffff
    8020184e:	44a080e7          	jalr	1098(ra) # 80200c94 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80201852:	00006517          	auipc	a0,0x6
    80201856:	4f650513          	addi	a0,a0,1270 # 80207d48 <simple_user_task_bin+0x1f8>
    8020185a:	fffff097          	auipc	ra,0xfffff
    8020185e:	43a080e7          	jalr	1082(ra) # 80200c94 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80201862:	55fd                	li	a1,-1
    80201864:	00006517          	auipc	a0,0x6
    80201868:	4fc50513          	addi	a0,a0,1276 # 80207d60 <simple_user_task_bin+0x210>
    8020186c:	fffff097          	auipc	ra,0xfffff
    80201870:	428080e7          	jalr	1064(ra) # 80200c94 <printf>
    printf("  零：%u\n", 0U);
    80201874:	4581                	li	a1,0
    80201876:	00006517          	auipc	a0,0x6
    8020187a:	50250513          	addi	a0,a0,1282 # 80207d78 <simple_user_task_bin+0x228>
    8020187e:	fffff097          	auipc	ra,0xfffff
    80201882:	416080e7          	jalr	1046(ra) # 80200c94 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80201886:	678d                	lui	a5,0x3
    80201888:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    8020188c:	00006517          	auipc	a0,0x6
    80201890:	4fc50513          	addi	a0,a0,1276 # 80207d88 <simple_user_task_bin+0x238>
    80201894:	fffff097          	auipc	ra,0xfffff
    80201898:	400080e7          	jalr	1024(ra) # 80200c94 <printf>

	// 测试边界
	printf("边界测试:\n");
    8020189c:	00006517          	auipc	a0,0x6
    802018a0:	50450513          	addi	a0,a0,1284 # 80207da0 <simple_user_task_bin+0x250>
    802018a4:	fffff097          	auipc	ra,0xfffff
    802018a8:	3f0080e7          	jalr	1008(ra) # 80200c94 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    802018ac:	800007b7          	lui	a5,0x80000
    802018b0:	fff7c593          	not	a1,a5
    802018b4:	00006517          	auipc	a0,0x6
    802018b8:	4fc50513          	addi	a0,a0,1276 # 80207db0 <simple_user_task_bin+0x260>
    802018bc:	fffff097          	auipc	ra,0xfffff
    802018c0:	3d8080e7          	jalr	984(ra) # 80200c94 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    802018c4:	800005b7          	lui	a1,0x80000
    802018c8:	00006517          	auipc	a0,0x6
    802018cc:	4f850513          	addi	a0,a0,1272 # 80207dc0 <simple_user_task_bin+0x270>
    802018d0:	fffff097          	auipc	ra,0xfffff
    802018d4:	3c4080e7          	jalr	964(ra) # 80200c94 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    802018d8:	55fd                	li	a1,-1
    802018da:	00006517          	auipc	a0,0x6
    802018de:	4f650513          	addi	a0,a0,1270 # 80207dd0 <simple_user_task_bin+0x280>
    802018e2:	fffff097          	auipc	ra,0xfffff
    802018e6:	3b2080e7          	jalr	946(ra) # 80200c94 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    802018ea:	55fd                	li	a1,-1
    802018ec:	00006517          	auipc	a0,0x6
    802018f0:	4f450513          	addi	a0,a0,1268 # 80207de0 <simple_user_task_bin+0x290>
    802018f4:	fffff097          	auipc	ra,0xfffff
    802018f8:	3a0080e7          	jalr	928(ra) # 80200c94 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    802018fc:	00006517          	auipc	a0,0x6
    80201900:	4fc50513          	addi	a0,a0,1276 # 80207df8 <simple_user_task_bin+0x2a8>
    80201904:	fffff097          	auipc	ra,0xfffff
    80201908:	390080e7          	jalr	912(ra) # 80200c94 <printf>
    printf("  空字符串: '%s'\n", "");
    8020190c:	00006597          	auipc	a1,0x6
    80201910:	50458593          	addi	a1,a1,1284 # 80207e10 <simple_user_task_bin+0x2c0>
    80201914:	00006517          	auipc	a0,0x6
    80201918:	50450513          	addi	a0,a0,1284 # 80207e18 <simple_user_task_bin+0x2c8>
    8020191c:	fffff097          	auipc	ra,0xfffff
    80201920:	378080e7          	jalr	888(ra) # 80200c94 <printf>
    printf("  单字符: '%s'\n", "X");
    80201924:	00006597          	auipc	a1,0x6
    80201928:	50c58593          	addi	a1,a1,1292 # 80207e30 <simple_user_task_bin+0x2e0>
    8020192c:	00006517          	auipc	a0,0x6
    80201930:	50c50513          	addi	a0,a0,1292 # 80207e38 <simple_user_task_bin+0x2e8>
    80201934:	fffff097          	auipc	ra,0xfffff
    80201938:	360080e7          	jalr	864(ra) # 80200c94 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    8020193c:	00006597          	auipc	a1,0x6
    80201940:	51458593          	addi	a1,a1,1300 # 80207e50 <simple_user_task_bin+0x300>
    80201944:	00006517          	auipc	a0,0x6
    80201948:	52c50513          	addi	a0,a0,1324 # 80207e70 <simple_user_task_bin+0x320>
    8020194c:	fffff097          	auipc	ra,0xfffff
    80201950:	348080e7          	jalr	840(ra) # 80200c94 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80201954:	00006597          	auipc	a1,0x6
    80201958:	53458593          	addi	a1,a1,1332 # 80207e88 <simple_user_task_bin+0x338>
    8020195c:	00006517          	auipc	a0,0x6
    80201960:	67c50513          	addi	a0,a0,1660 # 80207fd8 <simple_user_task_bin+0x488>
    80201964:	fffff097          	auipc	ra,0xfffff
    80201968:	330080e7          	jalr	816(ra) # 80200c94 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    8020196c:	00006517          	auipc	a0,0x6
    80201970:	68c50513          	addi	a0,a0,1676 # 80207ff8 <simple_user_task_bin+0x4a8>
    80201974:	fffff097          	auipc	ra,0xfffff
    80201978:	320080e7          	jalr	800(ra) # 80200c94 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    8020197c:	0ff00693          	li	a3,255
    80201980:	f0100613          	li	a2,-255
    80201984:	0ff00593          	li	a1,255
    80201988:	00006517          	auipc	a0,0x6
    8020198c:	68850513          	addi	a0,a0,1672 # 80208010 <simple_user_task_bin+0x4c0>
    80201990:	fffff097          	auipc	ra,0xfffff
    80201994:	304080e7          	jalr	772(ra) # 80200c94 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80201998:	00006517          	auipc	a0,0x6
    8020199c:	6a050513          	addi	a0,a0,1696 # 80208038 <simple_user_task_bin+0x4e8>
    802019a0:	fffff097          	auipc	ra,0xfffff
    802019a4:	2f4080e7          	jalr	756(ra) # 80200c94 <printf>
	printf("  100%% 完成!\n");
    802019a8:	00006517          	auipc	a0,0x6
    802019ac:	6a850513          	addi	a0,a0,1704 # 80208050 <simple_user_task_bin+0x500>
    802019b0:	fffff097          	auipc	ra,0xfffff
    802019b4:	2e4080e7          	jalr	740(ra) # 80200c94 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    802019b8:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    802019bc:	00006517          	auipc	a0,0x6
    802019c0:	6ac50513          	addi	a0,a0,1708 # 80208068 <simple_user_task_bin+0x518>
    802019c4:	fffff097          	auipc	ra,0xfffff
    802019c8:	2d0080e7          	jalr	720(ra) # 80200c94 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    802019cc:	fe843583          	ld	a1,-24(s0)
    802019d0:	00006517          	auipc	a0,0x6
    802019d4:	6b050513          	addi	a0,a0,1712 # 80208080 <simple_user_task_bin+0x530>
    802019d8:	fffff097          	auipc	ra,0xfffff
    802019dc:	2bc080e7          	jalr	700(ra) # 80200c94 <printf>
	
	// 测试指针格式
	int var = 42;
    802019e0:	02a00793          	li	a5,42
    802019e4:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    802019e8:	00006517          	auipc	a0,0x6
    802019ec:	6b050513          	addi	a0,a0,1712 # 80208098 <simple_user_task_bin+0x548>
    802019f0:	fffff097          	auipc	ra,0xfffff
    802019f4:	2a4080e7          	jalr	676(ra) # 80200c94 <printf>
	printf("  Address of var: %p\n", &var);
    802019f8:	fe440793          	addi	a5,s0,-28
    802019fc:	85be                	mv	a1,a5
    802019fe:	00006517          	auipc	a0,0x6
    80201a02:	6aa50513          	addi	a0,a0,1706 # 802080a8 <simple_user_task_bin+0x558>
    80201a06:	fffff097          	auipc	ra,0xfffff
    80201a0a:	28e080e7          	jalr	654(ra) # 80200c94 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80201a0e:	00006517          	auipc	a0,0x6
    80201a12:	6b250513          	addi	a0,a0,1714 # 802080c0 <simple_user_task_bin+0x570>
    80201a16:	fffff097          	auipc	ra,0xfffff
    80201a1a:	27e080e7          	jalr	638(ra) # 80200c94 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201a1e:	55fd                	li	a1,-1
    80201a20:	00006517          	auipc	a0,0x6
    80201a24:	6c050513          	addi	a0,a0,1728 # 802080e0 <simple_user_task_bin+0x590>
    80201a28:	fffff097          	auipc	ra,0xfffff
    80201a2c:	26c080e7          	jalr	620(ra) # 80200c94 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201a30:	00006517          	auipc	a0,0x6
    80201a34:	6c850513          	addi	a0,a0,1736 # 802080f8 <simple_user_task_bin+0x5a8>
    80201a38:	fffff097          	auipc	ra,0xfffff
    80201a3c:	25c080e7          	jalr	604(ra) # 80200c94 <printf>
	printf("  Binary of 5: %b\n", 5);
    80201a40:	4595                	li	a1,5
    80201a42:	00006517          	auipc	a0,0x6
    80201a46:	6ce50513          	addi	a0,a0,1742 # 80208110 <simple_user_task_bin+0x5c0>
    80201a4a:	fffff097          	auipc	ra,0xfffff
    80201a4e:	24a080e7          	jalr	586(ra) # 80200c94 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201a52:	45a1                	li	a1,8
    80201a54:	00006517          	auipc	a0,0x6
    80201a58:	6d450513          	addi	a0,a0,1748 # 80208128 <simple_user_task_bin+0x5d8>
    80201a5c:	fffff097          	auipc	ra,0xfffff
    80201a60:	238080e7          	jalr	568(ra) # 80200c94 <printf>
	printf("=== printf测试结束 ===\n");
    80201a64:	00006517          	auipc	a0,0x6
    80201a68:	6dc50513          	addi	a0,a0,1756 # 80208140 <simple_user_task_bin+0x5f0>
    80201a6c:	fffff097          	auipc	ra,0xfffff
    80201a70:	228080e7          	jalr	552(ra) # 80200c94 <printf>
}
    80201a74:	0001                	nop
    80201a76:	60e2                	ld	ra,24(sp)
    80201a78:	6442                	ld	s0,16(sp)
    80201a7a:	6105                	addi	sp,sp,32
    80201a7c:	8082                	ret

0000000080201a7e <test_curse_move>:
void test_curse_move(){
    80201a7e:	1101                	addi	sp,sp,-32
    80201a80:	ec06                	sd	ra,24(sp)
    80201a82:	e822                	sd	s0,16(sp)
    80201a84:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    80201a86:	fffff097          	auipc	ra,0xfffff
    80201a8a:	726080e7          	jalr	1830(ra) # 802011ac <clear_screen>
	printf("=== 光标移动测试 ===\n");
    80201a8e:	00006517          	auipc	a0,0x6
    80201a92:	6d250513          	addi	a0,a0,1746 # 80208160 <simple_user_task_bin+0x610>
    80201a96:	fffff097          	auipc	ra,0xfffff
    80201a9a:	1fe080e7          	jalr	510(ra) # 80200c94 <printf>
	for (int i = 3; i <= 7; i++) {
    80201a9e:	478d                	li	a5,3
    80201aa0:	fef42623          	sw	a5,-20(s0)
    80201aa4:	a881                	j	80201af4 <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    80201aa6:	4785                	li	a5,1
    80201aa8:	fef42423          	sw	a5,-24(s0)
    80201aac:	a805                	j	80201adc <test_curse_move+0x5e>
			goto_rc(i, j);
    80201aae:	fe842703          	lw	a4,-24(s0)
    80201ab2:	fec42783          	lw	a5,-20(s0)
    80201ab6:	85ba                	mv	a1,a4
    80201ab8:	853e                	mv	a0,a5
    80201aba:	00000097          	auipc	ra,0x0
    80201abe:	95c080e7          	jalr	-1700(ra) # 80201416 <goto_rc>
			printf("*");
    80201ac2:	00006517          	auipc	a0,0x6
    80201ac6:	6be50513          	addi	a0,a0,1726 # 80208180 <simple_user_task_bin+0x630>
    80201aca:	fffff097          	auipc	ra,0xfffff
    80201ace:	1ca080e7          	jalr	458(ra) # 80200c94 <printf>
		for (int j = 1; j <= 10; j++) {
    80201ad2:	fe842783          	lw	a5,-24(s0)
    80201ad6:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdf1901>
    80201ad8:	fef42423          	sw	a5,-24(s0)
    80201adc:	fe842783          	lw	a5,-24(s0)
    80201ae0:	0007871b          	sext.w	a4,a5
    80201ae4:	47a9                	li	a5,10
    80201ae6:	fce7d4e3          	bge	a5,a4,80201aae <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    80201aea:	fec42783          	lw	a5,-20(s0)
    80201aee:	2785                	addiw	a5,a5,1
    80201af0:	fef42623          	sw	a5,-20(s0)
    80201af4:	fec42783          	lw	a5,-20(s0)
    80201af8:	0007871b          	sext.w	a4,a5
    80201afc:	479d                	li	a5,7
    80201afe:	fae7d4e3          	bge	a5,a4,80201aa6 <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201b02:	4585                	li	a1,1
    80201b04:	4525                	li	a0,9
    80201b06:	00000097          	auipc	ra,0x0
    80201b0a:	910080e7          	jalr	-1776(ra) # 80201416 <goto_rc>
	save_cursor();
    80201b0e:	00000097          	auipc	ra,0x0
    80201b12:	840080e7          	jalr	-1984(ra) # 8020134e <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201b16:	4515                	li	a0,5
    80201b18:	fffff097          	auipc	ra,0xfffff
    80201b1c:	6c6080e7          	jalr	1734(ra) # 802011de <cursor_up>
	cursor_right(2);
    80201b20:	4509                	li	a0,2
    80201b22:	fffff097          	auipc	ra,0xfffff
    80201b26:	774080e7          	jalr	1908(ra) # 80201296 <cursor_right>
	printf("+++++");
    80201b2a:	00006517          	auipc	a0,0x6
    80201b2e:	65e50513          	addi	a0,a0,1630 # 80208188 <simple_user_task_bin+0x638>
    80201b32:	fffff097          	auipc	ra,0xfffff
    80201b36:	162080e7          	jalr	354(ra) # 80200c94 <printf>
	cursor_down(2);
    80201b3a:	4509                	li	a0,2
    80201b3c:	fffff097          	auipc	ra,0xfffff
    80201b40:	6fe080e7          	jalr	1790(ra) # 8020123a <cursor_down>
	cursor_left(5);
    80201b44:	4515                	li	a0,5
    80201b46:	fffff097          	auipc	ra,0xfffff
    80201b4a:	7ac080e7          	jalr	1964(ra) # 802012f2 <cursor_left>
	printf("-----");
    80201b4e:	00006517          	auipc	a0,0x6
    80201b52:	64250513          	addi	a0,a0,1602 # 80208190 <simple_user_task_bin+0x640>
    80201b56:	fffff097          	auipc	ra,0xfffff
    80201b5a:	13e080e7          	jalr	318(ra) # 80200c94 <printf>
	restore_cursor();
    80201b5e:	00000097          	auipc	ra,0x0
    80201b62:	824080e7          	jalr	-2012(ra) # 80201382 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80201b66:	00006517          	auipc	a0,0x6
    80201b6a:	63250513          	addi	a0,a0,1586 # 80208198 <simple_user_task_bin+0x648>
    80201b6e:	fffff097          	auipc	ra,0xfffff
    80201b72:	126080e7          	jalr	294(ra) # 80200c94 <printf>
}
    80201b76:	0001                	nop
    80201b78:	60e2                	ld	ra,24(sp)
    80201b7a:	6442                	ld	s0,16(sp)
    80201b7c:	6105                	addi	sp,sp,32
    80201b7e:	8082                	ret

0000000080201b80 <test_basic_colors>:

void test_basic_colors(void) {
    80201b80:	1141                	addi	sp,sp,-16
    80201b82:	e406                	sd	ra,8(sp)
    80201b84:	e022                	sd	s0,0(sp)
    80201b86:	0800                	addi	s0,sp,16
    clear_screen();
    80201b88:	fffff097          	auipc	ra,0xfffff
    80201b8c:	624080e7          	jalr	1572(ra) # 802011ac <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    80201b90:	00006517          	auipc	a0,0x6
    80201b94:	63050513          	addi	a0,a0,1584 # 802081c0 <simple_user_task_bin+0x670>
    80201b98:	fffff097          	auipc	ra,0xfffff
    80201b9c:	0fc080e7          	jalr	252(ra) # 80200c94 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80201ba0:	00006517          	auipc	a0,0x6
    80201ba4:	64050513          	addi	a0,a0,1600 # 802081e0 <simple_user_task_bin+0x690>
    80201ba8:	fffff097          	auipc	ra,0xfffff
    80201bac:	0ec080e7          	jalr	236(ra) # 80200c94 <printf>
    color_red();    printf("红色文字 ");
    80201bb0:	00000097          	auipc	ra,0x0
    80201bb4:	9e4080e7          	jalr	-1564(ra) # 80201594 <color_red>
    80201bb8:	00006517          	auipc	a0,0x6
    80201bbc:	64050513          	addi	a0,a0,1600 # 802081f8 <simple_user_task_bin+0x6a8>
    80201bc0:	fffff097          	auipc	ra,0xfffff
    80201bc4:	0d4080e7          	jalr	212(ra) # 80200c94 <printf>
    color_green();  printf("绿色文字 ");
    80201bc8:	00000097          	auipc	ra,0x0
    80201bcc:	9e8080e7          	jalr	-1560(ra) # 802015b0 <color_green>
    80201bd0:	00006517          	auipc	a0,0x6
    80201bd4:	63850513          	addi	a0,a0,1592 # 80208208 <simple_user_task_bin+0x6b8>
    80201bd8:	fffff097          	auipc	ra,0xfffff
    80201bdc:	0bc080e7          	jalr	188(ra) # 80200c94 <printf>
    color_yellow(); printf("黄色文字 ");
    80201be0:	00000097          	auipc	ra,0x0
    80201be4:	9ee080e7          	jalr	-1554(ra) # 802015ce <color_yellow>
    80201be8:	00006517          	auipc	a0,0x6
    80201bec:	63050513          	addi	a0,a0,1584 # 80208218 <simple_user_task_bin+0x6c8>
    80201bf0:	fffff097          	auipc	ra,0xfffff
    80201bf4:	0a4080e7          	jalr	164(ra) # 80200c94 <printf>
    color_blue();   printf("蓝色文字 ");
    80201bf8:	00000097          	auipc	ra,0x0
    80201bfc:	9f4080e7          	jalr	-1548(ra) # 802015ec <color_blue>
    80201c00:	00006517          	auipc	a0,0x6
    80201c04:	62850513          	addi	a0,a0,1576 # 80208228 <simple_user_task_bin+0x6d8>
    80201c08:	fffff097          	auipc	ra,0xfffff
    80201c0c:	08c080e7          	jalr	140(ra) # 80200c94 <printf>
    color_purple(); printf("紫色文字 ");
    80201c10:	00000097          	auipc	ra,0x0
    80201c14:	9fa080e7          	jalr	-1542(ra) # 8020160a <color_purple>
    80201c18:	00006517          	auipc	a0,0x6
    80201c1c:	62050513          	addi	a0,a0,1568 # 80208238 <simple_user_task_bin+0x6e8>
    80201c20:	fffff097          	auipc	ra,0xfffff
    80201c24:	074080e7          	jalr	116(ra) # 80200c94 <printf>
    color_cyan();   printf("青色文字 ");
    80201c28:	00000097          	auipc	ra,0x0
    80201c2c:	a00080e7          	jalr	-1536(ra) # 80201628 <color_cyan>
    80201c30:	00006517          	auipc	a0,0x6
    80201c34:	61850513          	addi	a0,a0,1560 # 80208248 <simple_user_task_bin+0x6f8>
    80201c38:	fffff097          	auipc	ra,0xfffff
    80201c3c:	05c080e7          	jalr	92(ra) # 80200c94 <printf>
    color_reverse();  printf("反色文字");
    80201c40:	00000097          	auipc	ra,0x0
    80201c44:	a06080e7          	jalr	-1530(ra) # 80201646 <color_reverse>
    80201c48:	00006517          	auipc	a0,0x6
    80201c4c:	61050513          	addi	a0,a0,1552 # 80208258 <simple_user_task_bin+0x708>
    80201c50:	fffff097          	auipc	ra,0xfffff
    80201c54:	044080e7          	jalr	68(ra) # 80200c94 <printf>
    reset_color();
    80201c58:	00000097          	auipc	ra,0x0
    80201c5c:	838080e7          	jalr	-1992(ra) # 80201490 <reset_color>
    printf("\n\n");
    80201c60:	00006517          	auipc	a0,0x6
    80201c64:	60850513          	addi	a0,a0,1544 # 80208268 <simple_user_task_bin+0x718>
    80201c68:	fffff097          	auipc	ra,0xfffff
    80201c6c:	02c080e7          	jalr	44(ra) # 80200c94 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80201c70:	00006517          	auipc	a0,0x6
    80201c74:	60050513          	addi	a0,a0,1536 # 80208270 <simple_user_task_bin+0x720>
    80201c78:	fffff097          	auipc	ra,0xfffff
    80201c7c:	01c080e7          	jalr	28(ra) # 80200c94 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80201c80:	02900513          	li	a0,41
    80201c84:	00000097          	auipc	ra,0x0
    80201c88:	89e080e7          	jalr	-1890(ra) # 80201522 <set_bg_color>
    80201c8c:	00006517          	auipc	a0,0x6
    80201c90:	5fc50513          	addi	a0,a0,1532 # 80208288 <simple_user_task_bin+0x738>
    80201c94:	fffff097          	auipc	ra,0xfffff
    80201c98:	000080e7          	jalr	ra # 80200c94 <printf>
    80201c9c:	fffff097          	auipc	ra,0xfffff
    80201ca0:	7f4080e7          	jalr	2036(ra) # 80201490 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80201ca4:	02a00513          	li	a0,42
    80201ca8:	00000097          	auipc	ra,0x0
    80201cac:	87a080e7          	jalr	-1926(ra) # 80201522 <set_bg_color>
    80201cb0:	00006517          	auipc	a0,0x6
    80201cb4:	5e850513          	addi	a0,a0,1512 # 80208298 <simple_user_task_bin+0x748>
    80201cb8:	fffff097          	auipc	ra,0xfffff
    80201cbc:	fdc080e7          	jalr	-36(ra) # 80200c94 <printf>
    80201cc0:	fffff097          	auipc	ra,0xfffff
    80201cc4:	7d0080e7          	jalr	2000(ra) # 80201490 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80201cc8:	02b00513          	li	a0,43
    80201ccc:	00000097          	auipc	ra,0x0
    80201cd0:	856080e7          	jalr	-1962(ra) # 80201522 <set_bg_color>
    80201cd4:	00006517          	auipc	a0,0x6
    80201cd8:	5d450513          	addi	a0,a0,1492 # 802082a8 <simple_user_task_bin+0x758>
    80201cdc:	fffff097          	auipc	ra,0xfffff
    80201ce0:	fb8080e7          	jalr	-72(ra) # 80200c94 <printf>
    80201ce4:	fffff097          	auipc	ra,0xfffff
    80201ce8:	7ac080e7          	jalr	1964(ra) # 80201490 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80201cec:	02c00513          	li	a0,44
    80201cf0:	00000097          	auipc	ra,0x0
    80201cf4:	832080e7          	jalr	-1998(ra) # 80201522 <set_bg_color>
    80201cf8:	00006517          	auipc	a0,0x6
    80201cfc:	5c050513          	addi	a0,a0,1472 # 802082b8 <simple_user_task_bin+0x768>
    80201d00:	fffff097          	auipc	ra,0xfffff
    80201d04:	f94080e7          	jalr	-108(ra) # 80200c94 <printf>
    80201d08:	fffff097          	auipc	ra,0xfffff
    80201d0c:	788080e7          	jalr	1928(ra) # 80201490 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201d10:	02f00513          	li	a0,47
    80201d14:	00000097          	auipc	ra,0x0
    80201d18:	80e080e7          	jalr	-2034(ra) # 80201522 <set_bg_color>
    80201d1c:	00006517          	auipc	a0,0x6
    80201d20:	5ac50513          	addi	a0,a0,1452 # 802082c8 <simple_user_task_bin+0x778>
    80201d24:	fffff097          	auipc	ra,0xfffff
    80201d28:	f70080e7          	jalr	-144(ra) # 80200c94 <printf>
    80201d2c:	fffff097          	auipc	ra,0xfffff
    80201d30:	764080e7          	jalr	1892(ra) # 80201490 <reset_color>
    printf("\n\n");
    80201d34:	00006517          	auipc	a0,0x6
    80201d38:	53450513          	addi	a0,a0,1332 # 80208268 <simple_user_task_bin+0x718>
    80201d3c:	fffff097          	auipc	ra,0xfffff
    80201d40:	f58080e7          	jalr	-168(ra) # 80200c94 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201d44:	00006517          	auipc	a0,0x6
    80201d48:	59450513          	addi	a0,a0,1428 # 802082d8 <simple_user_task_bin+0x788>
    80201d4c:	fffff097          	auipc	ra,0xfffff
    80201d50:	f48080e7          	jalr	-184(ra) # 80200c94 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201d54:	02c00593          	li	a1,44
    80201d58:	457d                	li	a0,31
    80201d5a:	00000097          	auipc	ra,0x0
    80201d5e:	90a080e7          	jalr	-1782(ra) # 80201664 <set_color>
    80201d62:	00006517          	auipc	a0,0x6
    80201d66:	58e50513          	addi	a0,a0,1422 # 802082f0 <simple_user_task_bin+0x7a0>
    80201d6a:	fffff097          	auipc	ra,0xfffff
    80201d6e:	f2a080e7          	jalr	-214(ra) # 80200c94 <printf>
    80201d72:	fffff097          	auipc	ra,0xfffff
    80201d76:	71e080e7          	jalr	1822(ra) # 80201490 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201d7a:	02d00593          	li	a1,45
    80201d7e:	02100513          	li	a0,33
    80201d82:	00000097          	auipc	ra,0x0
    80201d86:	8e2080e7          	jalr	-1822(ra) # 80201664 <set_color>
    80201d8a:	00006517          	auipc	a0,0x6
    80201d8e:	57650513          	addi	a0,a0,1398 # 80208300 <simple_user_task_bin+0x7b0>
    80201d92:	fffff097          	auipc	ra,0xfffff
    80201d96:	f02080e7          	jalr	-254(ra) # 80200c94 <printf>
    80201d9a:	fffff097          	auipc	ra,0xfffff
    80201d9e:	6f6080e7          	jalr	1782(ra) # 80201490 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201da2:	02f00593          	li	a1,47
    80201da6:	02000513          	li	a0,32
    80201daa:	00000097          	auipc	ra,0x0
    80201dae:	8ba080e7          	jalr	-1862(ra) # 80201664 <set_color>
    80201db2:	00006517          	auipc	a0,0x6
    80201db6:	55e50513          	addi	a0,a0,1374 # 80208310 <simple_user_task_bin+0x7c0>
    80201dba:	fffff097          	auipc	ra,0xfffff
    80201dbe:	eda080e7          	jalr	-294(ra) # 80200c94 <printf>
    80201dc2:	fffff097          	auipc	ra,0xfffff
    80201dc6:	6ce080e7          	jalr	1742(ra) # 80201490 <reset_color>
    printf("\n\n");
    80201dca:	00006517          	auipc	a0,0x6
    80201dce:	49e50513          	addi	a0,a0,1182 # 80208268 <simple_user_task_bin+0x718>
    80201dd2:	fffff097          	auipc	ra,0xfffff
    80201dd6:	ec2080e7          	jalr	-318(ra) # 80200c94 <printf>
	reset_color();
    80201dda:	fffff097          	auipc	ra,0xfffff
    80201dde:	6b6080e7          	jalr	1718(ra) # 80201490 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201de2:	00006517          	auipc	a0,0x6
    80201de6:	53e50513          	addi	a0,a0,1342 # 80208320 <simple_user_task_bin+0x7d0>
    80201dea:	fffff097          	auipc	ra,0xfffff
    80201dee:	eaa080e7          	jalr	-342(ra) # 80200c94 <printf>
	cursor_up(1); // 光标上移一行
    80201df2:	4505                	li	a0,1
    80201df4:	fffff097          	auipc	ra,0xfffff
    80201df8:	3ea080e7          	jalr	1002(ra) # 802011de <cursor_up>
	clear_line();
    80201dfc:	00000097          	auipc	ra,0x0
    80201e00:	8a4080e7          	jalr	-1884(ra) # 802016a0 <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201e04:	00006517          	auipc	a0,0x6
    80201e08:	55450513          	addi	a0,a0,1364 # 80208358 <simple_user_task_bin+0x808>
    80201e0c:	fffff097          	auipc	ra,0xfffff
    80201e10:	e88080e7          	jalr	-376(ra) # 80200c94 <printf>
    80201e14:	0001                	nop
    80201e16:	60a2                	ld	ra,8(sp)
    80201e18:	6402                	ld	s0,0(sp)
    80201e1a:	0141                	addi	sp,sp,16
    80201e1c:	8082                	ret

0000000080201e1e <memset>:
#include "defs.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201e1e:	7139                	addi	sp,sp,-64
    80201e20:	fc22                	sd	s0,56(sp)
    80201e22:	0080                	addi	s0,sp,64
    80201e24:	fca43c23          	sd	a0,-40(s0)
    80201e28:	87ae                	mv	a5,a1
    80201e2a:	fcc43423          	sd	a2,-56(s0)
    80201e2e:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201e32:	fd843783          	ld	a5,-40(s0)
    80201e36:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    80201e3a:	a829                	j	80201e54 <memset+0x36>
        *p++ = (unsigned char)c;
    80201e3c:	fe843783          	ld	a5,-24(s0)
    80201e40:	00178713          	addi	a4,a5,1
    80201e44:	fee43423          	sd	a4,-24(s0)
    80201e48:	fd442703          	lw	a4,-44(s0)
    80201e4c:	0ff77713          	zext.b	a4,a4
    80201e50:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    80201e54:	fc843783          	ld	a5,-56(s0)
    80201e58:	fff78713          	addi	a4,a5,-1
    80201e5c:	fce43423          	sd	a4,-56(s0)
    80201e60:	fff1                	bnez	a5,80201e3c <memset+0x1e>
    return dst;
    80201e62:	fd843783          	ld	a5,-40(s0)
}
    80201e66:	853e                	mv	a0,a5
    80201e68:	7462                	ld	s0,56(sp)
    80201e6a:	6121                	addi	sp,sp,64
    80201e6c:	8082                	ret

0000000080201e6e <memmove>:
void *memmove(void *dst, const void *src, unsigned long n) {
    80201e6e:	7139                	addi	sp,sp,-64
    80201e70:	fc22                	sd	s0,56(sp)
    80201e72:	0080                	addi	s0,sp,64
    80201e74:	fca43c23          	sd	a0,-40(s0)
    80201e78:	fcb43823          	sd	a1,-48(s0)
    80201e7c:	fcc43423          	sd	a2,-56(s0)
	unsigned char *d = dst;
    80201e80:	fd843783          	ld	a5,-40(s0)
    80201e84:	fef43423          	sd	a5,-24(s0)
	const unsigned char *s = src;
    80201e88:	fd043783          	ld	a5,-48(s0)
    80201e8c:	fef43023          	sd	a5,-32(s0)
	if (d < s) {
    80201e90:	fe843703          	ld	a4,-24(s0)
    80201e94:	fe043783          	ld	a5,-32(s0)
    80201e98:	02f77b63          	bgeu	a4,a5,80201ece <memmove+0x60>
		while (n-- > 0)
    80201e9c:	a00d                	j	80201ebe <memmove+0x50>
			*d++ = *s++;
    80201e9e:	fe043703          	ld	a4,-32(s0)
    80201ea2:	00170793          	addi	a5,a4,1
    80201ea6:	fef43023          	sd	a5,-32(s0)
    80201eaa:	fe843783          	ld	a5,-24(s0)
    80201eae:	00178693          	addi	a3,a5,1
    80201eb2:	fed43423          	sd	a3,-24(s0)
    80201eb6:	00074703          	lbu	a4,0(a4)
    80201eba:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201ebe:	fc843783          	ld	a5,-56(s0)
    80201ec2:	fff78713          	addi	a4,a5,-1
    80201ec6:	fce43423          	sd	a4,-56(s0)
    80201eca:	fbf1                	bnez	a5,80201e9e <memmove+0x30>
    80201ecc:	a889                	j	80201f1e <memmove+0xb0>
	} else {
		d += n;
    80201ece:	fe843703          	ld	a4,-24(s0)
    80201ed2:	fc843783          	ld	a5,-56(s0)
    80201ed6:	97ba                	add	a5,a5,a4
    80201ed8:	fef43423          	sd	a5,-24(s0)
		s += n;
    80201edc:	fe043703          	ld	a4,-32(s0)
    80201ee0:	fc843783          	ld	a5,-56(s0)
    80201ee4:	97ba                	add	a5,a5,a4
    80201ee6:	fef43023          	sd	a5,-32(s0)
		while (n-- > 0)
    80201eea:	a01d                	j	80201f10 <memmove+0xa2>
			*(--d) = *(--s);
    80201eec:	fe043783          	ld	a5,-32(s0)
    80201ef0:	17fd                	addi	a5,a5,-1
    80201ef2:	fef43023          	sd	a5,-32(s0)
    80201ef6:	fe843783          	ld	a5,-24(s0)
    80201efa:	17fd                	addi	a5,a5,-1
    80201efc:	fef43423          	sd	a5,-24(s0)
    80201f00:	fe043783          	ld	a5,-32(s0)
    80201f04:	0007c703          	lbu	a4,0(a5)
    80201f08:	fe843783          	ld	a5,-24(s0)
    80201f0c:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201f10:	fc843783          	ld	a5,-56(s0)
    80201f14:	fff78713          	addi	a4,a5,-1
    80201f18:	fce43423          	sd	a4,-56(s0)
    80201f1c:	fbe1                	bnez	a5,80201eec <memmove+0x7e>
	}
	return dst;
    80201f1e:	fd843783          	ld	a5,-40(s0)
}
    80201f22:	853e                	mv	a0,a5
    80201f24:	7462                	ld	s0,56(sp)
    80201f26:	6121                	addi	sp,sp,64
    80201f28:	8082                	ret

0000000080201f2a <memcpy>:
void *memcpy(void *dst, const void *src, size_t n) {
    80201f2a:	715d                	addi	sp,sp,-80
    80201f2c:	e4a2                	sd	s0,72(sp)
    80201f2e:	0880                	addi	s0,sp,80
    80201f30:	fca43423          	sd	a0,-56(s0)
    80201f34:	fcb43023          	sd	a1,-64(s0)
    80201f38:	fac43c23          	sd	a2,-72(s0)
    char *d = dst;
    80201f3c:	fc843783          	ld	a5,-56(s0)
    80201f40:	fef43023          	sd	a5,-32(s0)
    const char *s = src;
    80201f44:	fc043783          	ld	a5,-64(s0)
    80201f48:	fcf43c23          	sd	a5,-40(s0)
    for (size_t i = 0; i < n; i++) {
    80201f4c:	fe043423          	sd	zero,-24(s0)
    80201f50:	a025                	j	80201f78 <memcpy+0x4e>
        d[i] = s[i];
    80201f52:	fd843703          	ld	a4,-40(s0)
    80201f56:	fe843783          	ld	a5,-24(s0)
    80201f5a:	973e                	add	a4,a4,a5
    80201f5c:	fe043683          	ld	a3,-32(s0)
    80201f60:	fe843783          	ld	a5,-24(s0)
    80201f64:	97b6                	add	a5,a5,a3
    80201f66:	00074703          	lbu	a4,0(a4)
    80201f6a:	00e78023          	sb	a4,0(a5)
    for (size_t i = 0; i < n; i++) {
    80201f6e:	fe843783          	ld	a5,-24(s0)
    80201f72:	0785                	addi	a5,a5,1
    80201f74:	fef43423          	sd	a5,-24(s0)
    80201f78:	fe843703          	ld	a4,-24(s0)
    80201f7c:	fb843783          	ld	a5,-72(s0)
    80201f80:	fcf769e3          	bltu	a4,a5,80201f52 <memcpy+0x28>
    }
    return dst;
    80201f84:	fc843783          	ld	a5,-56(s0)
    80201f88:	853e                	mv	a0,a5
    80201f8a:	6426                	ld	s0,72(sp)
    80201f8c:	6161                	addi	sp,sp,80
    80201f8e:	8082                	ret

0000000080201f90 <assert>:
    80201f90:	1101                	addi	sp,sp,-32
    80201f92:	ec06                	sd	ra,24(sp)
    80201f94:	e822                	sd	s0,16(sp)
    80201f96:	1000                	addi	s0,sp,32
    80201f98:	87aa                	mv	a5,a0
    80201f9a:	fef42623          	sw	a5,-20(s0)
    80201f9e:	fec42783          	lw	a5,-20(s0)
    80201fa2:	2781                	sext.w	a5,a5
    80201fa4:	e79d                	bnez	a5,80201fd2 <assert+0x42>
    80201fa6:	19c00613          	li	a2,412
    80201faa:	00007597          	auipc	a1,0x7
    80201fae:	86e58593          	addi	a1,a1,-1938 # 80208818 <simple_user_task_bin+0x58>
    80201fb2:	00007517          	auipc	a0,0x7
    80201fb6:	87650513          	addi	a0,a0,-1930 # 80208828 <simple_user_task_bin+0x68>
    80201fba:	fffff097          	auipc	ra,0xfffff
    80201fbe:	cda080e7          	jalr	-806(ra) # 80200c94 <printf>
    80201fc2:	00007517          	auipc	a0,0x7
    80201fc6:	88e50513          	addi	a0,a0,-1906 # 80208850 <simple_user_task_bin+0x90>
    80201fca:	fffff097          	auipc	ra,0xfffff
    80201fce:	716080e7          	jalr	1814(ra) # 802016e0 <panic>
    80201fd2:	0001                	nop
    80201fd4:	60e2                	ld	ra,24(sp)
    80201fd6:	6442                	ld	s0,16(sp)
    80201fd8:	6105                	addi	sp,sp,32
    80201fda:	8082                	ret

0000000080201fdc <sv39_sign_extend>:
    80201fdc:	1101                	addi	sp,sp,-32
    80201fde:	ec22                	sd	s0,24(sp)
    80201fe0:	1000                	addi	s0,sp,32
    80201fe2:	fea43423          	sd	a0,-24(s0)
    80201fe6:	fe843703          	ld	a4,-24(s0)
    80201fea:	4785                	li	a5,1
    80201fec:	179a                	slli	a5,a5,0x26
    80201fee:	8ff9                	and	a5,a5,a4
    80201ff0:	c799                	beqz	a5,80201ffe <sv39_sign_extend+0x22>
    80201ff2:	fe843703          	ld	a4,-24(s0)
    80201ff6:	57fd                	li	a5,-1
    80201ff8:	179e                	slli	a5,a5,0x27
    80201ffa:	8fd9                	or	a5,a5,a4
    80201ffc:	a031                	j	80202008 <sv39_sign_extend+0x2c>
    80201ffe:	fe843703          	ld	a4,-24(s0)
    80202002:	57fd                	li	a5,-1
    80202004:	83e5                	srli	a5,a5,0x19
    80202006:	8ff9                	and	a5,a5,a4
    80202008:	853e                	mv	a0,a5
    8020200a:	6462                	ld	s0,24(sp)
    8020200c:	6105                	addi	sp,sp,32
    8020200e:	8082                	ret

0000000080202010 <sv39_check_valid>:
    80202010:	1101                	addi	sp,sp,-32
    80202012:	ec22                	sd	s0,24(sp)
    80202014:	1000                	addi	s0,sp,32
    80202016:	fea43423          	sd	a0,-24(s0)
    8020201a:	fe843703          	ld	a4,-24(s0)
    8020201e:	57fd                	li	a5,-1
    80202020:	83e5                	srli	a5,a5,0x19
    80202022:	00e7f863          	bgeu	a5,a4,80202032 <sv39_check_valid+0x22>
    80202026:	fe843703          	ld	a4,-24(s0)
    8020202a:	57fd                	li	a5,-1
    8020202c:	179e                	slli	a5,a5,0x27
    8020202e:	00f76463          	bltu	a4,a5,80202036 <sv39_check_valid+0x26>
    80202032:	4785                	li	a5,1
    80202034:	a011                	j	80202038 <sv39_check_valid+0x28>
    80202036:	4781                	li	a5,0
    80202038:	853e                	mv	a0,a5
    8020203a:	6462                	ld	s0,24(sp)
    8020203c:	6105                	addi	sp,sp,32
    8020203e:	8082                	ret

0000000080202040 <px>:
static inline uint64 px(int level, uint64 va) {
    80202040:	1101                	addi	sp,sp,-32
    80202042:	ec22                	sd	s0,24(sp)
    80202044:	1000                	addi	s0,sp,32
    80202046:	87aa                	mv	a5,a0
    80202048:	feb43023          	sd	a1,-32(s0)
    8020204c:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    80202050:	fec42783          	lw	a5,-20(s0)
    80202054:	873e                	mv	a4,a5
    80202056:	87ba                	mv	a5,a4
    80202058:	0037979b          	slliw	a5,a5,0x3
    8020205c:	9fb9                	addw	a5,a5,a4
    8020205e:	2781                	sext.w	a5,a5
    80202060:	27b1                	addiw	a5,a5,12
    80202062:	2781                	sext.w	a5,a5
    80202064:	873e                	mv	a4,a5
    80202066:	fe043783          	ld	a5,-32(s0)
    8020206a:	00e7d7b3          	srl	a5,a5,a4
    8020206e:	1ff7f793          	andi	a5,a5,511
}
    80202072:	853e                	mv	a0,a5
    80202074:	6462                	ld	s0,24(sp)
    80202076:	6105                	addi	sp,sp,32
    80202078:	8082                	ret

000000008020207a <create_pagetable>:
pagetable_t create_pagetable(void) {
    8020207a:	1101                	addi	sp,sp,-32
    8020207c:	ec06                	sd	ra,24(sp)
    8020207e:	e822                	sd	s0,16(sp)
    80202080:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    80202082:	00001097          	auipc	ra,0x1
    80202086:	1a4080e7          	jalr	420(ra) # 80203226 <alloc_page>
    8020208a:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    8020208e:	fe843783          	ld	a5,-24(s0)
    80202092:	e399                	bnez	a5,80202098 <create_pagetable+0x1e>
        return 0;
    80202094:	4781                	li	a5,0
    80202096:	a819                	j	802020ac <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    80202098:	6605                	lui	a2,0x1
    8020209a:	4581                	li	a1,0
    8020209c:	fe843503          	ld	a0,-24(s0)
    802020a0:	00000097          	auipc	ra,0x0
    802020a4:	d7e080e7          	jalr	-642(ra) # 80201e1e <memset>
    return pt;
    802020a8:	fe843783          	ld	a5,-24(s0)
}
    802020ac:	853e                	mv	a0,a5
    802020ae:	60e2                	ld	ra,24(sp)
    802020b0:	6442                	ld	s0,16(sp)
    802020b2:	6105                	addi	sp,sp,32
    802020b4:	8082                	ret

00000000802020b6 <walk_lookup>:
pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    802020b6:	7139                	addi	sp,sp,-64
    802020b8:	fc06                	sd	ra,56(sp)
    802020ba:	f822                	sd	s0,48(sp)
    802020bc:	0080                	addi	s0,sp,64
    802020be:	fca43423          	sd	a0,-56(s0)
    802020c2:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    802020c6:	fc043503          	ld	a0,-64(s0)
    802020ca:	00000097          	auipc	ra,0x0
    802020ce:	f12080e7          	jalr	-238(ra) # 80201fdc <sv39_sign_extend>
    802020d2:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    802020d6:	fc043503          	ld	a0,-64(s0)
    802020da:	00000097          	auipc	ra,0x0
    802020de:	f36080e7          	jalr	-202(ra) # 80202010 <sv39_check_valid>
    802020e2:	87aa                	mv	a5,a0
    802020e4:	eb89                	bnez	a5,802020f6 <walk_lookup+0x40>
		panic("va out of sv39 range");
    802020e6:	00006517          	auipc	a0,0x6
    802020ea:	77250513          	addi	a0,a0,1906 # 80208858 <simple_user_task_bin+0x98>
    802020ee:	fffff097          	auipc	ra,0xfffff
    802020f2:	5f2080e7          	jalr	1522(ra) # 802016e0 <panic>
    for (int level = 2; level > 0; level--) {
    802020f6:	4789                	li	a5,2
    802020f8:	fef42623          	sw	a5,-20(s0)
    802020fc:	a0e9                	j	802021c6 <walk_lookup+0x110>
        pte_t *pte = &pt[px(level, va)];
    802020fe:	fec42783          	lw	a5,-20(s0)
    80202102:	fc043583          	ld	a1,-64(s0)
    80202106:	853e                	mv	a0,a5
    80202108:	00000097          	auipc	ra,0x0
    8020210c:	f38080e7          	jalr	-200(ra) # 80202040 <px>
    80202110:	87aa                	mv	a5,a0
    80202112:	078e                	slli	a5,a5,0x3
    80202114:	fc843703          	ld	a4,-56(s0)
    80202118:	97ba                	add	a5,a5,a4
    8020211a:	fef43023          	sd	a5,-32(s0)
        if (!pte) {
    8020211e:	fe043783          	ld	a5,-32(s0)
    80202122:	ef91                	bnez	a5,8020213e <walk_lookup+0x88>
            printf("[WALK_LOOKUP] pte is NULL at level %d\n", level);
    80202124:	fec42783          	lw	a5,-20(s0)
    80202128:	85be                	mv	a1,a5
    8020212a:	00006517          	auipc	a0,0x6
    8020212e:	74650513          	addi	a0,a0,1862 # 80208870 <simple_user_task_bin+0xb0>
    80202132:	fffff097          	auipc	ra,0xfffff
    80202136:	b62080e7          	jalr	-1182(ra) # 80200c94 <printf>
            return 0;
    8020213a:	4781                	li	a5,0
    8020213c:	a075                	j	802021e8 <walk_lookup+0x132>
        if (*pte & PTE_V) {
    8020213e:	fe043783          	ld	a5,-32(s0)
    80202142:	639c                	ld	a5,0(a5)
    80202144:	8b85                	andi	a5,a5,1
    80202146:	cfa1                	beqz	a5,8020219e <walk_lookup+0xe8>
            uint64 pa = PTE2PA(*pte);
    80202148:	fe043783          	ld	a5,-32(s0)
    8020214c:	639c                	ld	a5,0(a5)
    8020214e:	83a9                	srli	a5,a5,0xa
    80202150:	07b2                	slli	a5,a5,0xc
    80202152:	fcf43c23          	sd	a5,-40(s0)
            if (pa < KERNBASE || pa >= PHYSTOP) {
    80202156:	fd843703          	ld	a4,-40(s0)
    8020215a:	800007b7          	lui	a5,0x80000
    8020215e:	fff7c793          	not	a5,a5
    80202162:	00e7f863          	bgeu	a5,a4,80202172 <walk_lookup+0xbc>
    80202166:	fd843703          	ld	a4,-40(s0)
    8020216a:	47c5                	li	a5,17
    8020216c:	07ee                	slli	a5,a5,0x1b
    8020216e:	02f76363          	bltu	a4,a5,80202194 <walk_lookup+0xde>
                printf("[WALK_LOOKUP] 非法页表物理地址: 0x%lx (level %d, va=0x%lx)\n", pa, level, va);
    80202172:	fec42783          	lw	a5,-20(s0)
    80202176:	fc043683          	ld	a3,-64(s0)
    8020217a:	863e                	mv	a2,a5
    8020217c:	fd843583          	ld	a1,-40(s0)
    80202180:	00006517          	auipc	a0,0x6
    80202184:	71850513          	addi	a0,a0,1816 # 80208898 <simple_user_task_bin+0xd8>
    80202188:	fffff097          	auipc	ra,0xfffff
    8020218c:	b0c080e7          	jalr	-1268(ra) # 80200c94 <printf>
                return 0;
    80202190:	4781                	li	a5,0
    80202192:	a899                	j	802021e8 <walk_lookup+0x132>
            pt = (pagetable_t)pa;
    80202194:	fd843783          	ld	a5,-40(s0)
    80202198:	fcf43423          	sd	a5,-56(s0)
    8020219c:	a005                	j	802021bc <walk_lookup+0x106>
            printf("[WALK_LOOKUP] 页表项无效: level=%d va=0x%lx\n", level, va);
    8020219e:	fec42783          	lw	a5,-20(s0)
    802021a2:	fc043603          	ld	a2,-64(s0)
    802021a6:	85be                	mv	a1,a5
    802021a8:	00006517          	auipc	a0,0x6
    802021ac:	73850513          	addi	a0,a0,1848 # 802088e0 <simple_user_task_bin+0x120>
    802021b0:	fffff097          	auipc	ra,0xfffff
    802021b4:	ae4080e7          	jalr	-1308(ra) # 80200c94 <printf>
            return 0;
    802021b8:	4781                	li	a5,0
    802021ba:	a03d                	j	802021e8 <walk_lookup+0x132>
    for (int level = 2; level > 0; level--) {
    802021bc:	fec42783          	lw	a5,-20(s0)
    802021c0:	37fd                	addiw	a5,a5,-1 # 7fffffff <_entry-0x200001>
    802021c2:	fef42623          	sw	a5,-20(s0)
    802021c6:	fec42783          	lw	a5,-20(s0)
    802021ca:	2781                	sext.w	a5,a5
    802021cc:	f2f049e3          	bgtz	a5,802020fe <walk_lookup+0x48>
    return &pt[px(0, va)];
    802021d0:	fc043583          	ld	a1,-64(s0)
    802021d4:	4501                	li	a0,0
    802021d6:	00000097          	auipc	ra,0x0
    802021da:	e6a080e7          	jalr	-406(ra) # 80202040 <px>
    802021de:	87aa                	mv	a5,a0
    802021e0:	078e                	slli	a5,a5,0x3
    802021e2:	fc843703          	ld	a4,-56(s0)
    802021e6:	97ba                	add	a5,a5,a4
}
    802021e8:	853e                	mv	a0,a5
    802021ea:	70e2                	ld	ra,56(sp)
    802021ec:	7442                	ld	s0,48(sp)
    802021ee:	6121                	addi	sp,sp,64
    802021f0:	8082                	ret

00000000802021f2 <walk_create>:
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    802021f2:	7139                	addi	sp,sp,-64
    802021f4:	fc06                	sd	ra,56(sp)
    802021f6:	f822                	sd	s0,48(sp)
    802021f8:	0080                	addi	s0,sp,64
    802021fa:	fca43423          	sd	a0,-56(s0)
    802021fe:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    80202202:	fc043503          	ld	a0,-64(s0)
    80202206:	00000097          	auipc	ra,0x0
    8020220a:	dd6080e7          	jalr	-554(ra) # 80201fdc <sv39_sign_extend>
    8020220e:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    80202212:	fc043503          	ld	a0,-64(s0)
    80202216:	00000097          	auipc	ra,0x0
    8020221a:	dfa080e7          	jalr	-518(ra) # 80202010 <sv39_check_valid>
    8020221e:	87aa                	mv	a5,a0
    80202220:	eb89                	bnez	a5,80202232 <walk_create+0x40>
		panic("va out of sv39 range");
    80202222:	00006517          	auipc	a0,0x6
    80202226:	63650513          	addi	a0,a0,1590 # 80208858 <simple_user_task_bin+0x98>
    8020222a:	fffff097          	auipc	ra,0xfffff
    8020222e:	4b6080e7          	jalr	1206(ra) # 802016e0 <panic>
    for (int level = 2; level > 0; level--) {
    80202232:	4789                	li	a5,2
    80202234:	fef42623          	sw	a5,-20(s0)
    80202238:	a059                	j	802022be <walk_create+0xcc>
        pte_t *pte = &pt[px(level, va)];
    8020223a:	fec42783          	lw	a5,-20(s0)
    8020223e:	fc043583          	ld	a1,-64(s0)
    80202242:	853e                	mv	a0,a5
    80202244:	00000097          	auipc	ra,0x0
    80202248:	dfc080e7          	jalr	-516(ra) # 80202040 <px>
    8020224c:	87aa                	mv	a5,a0
    8020224e:	078e                	slli	a5,a5,0x3
    80202250:	fc843703          	ld	a4,-56(s0)
    80202254:	97ba                	add	a5,a5,a4
    80202256:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    8020225a:	fe043783          	ld	a5,-32(s0)
    8020225e:	639c                	ld	a5,0(a5)
    80202260:	8b85                	andi	a5,a5,1
    80202262:	cb89                	beqz	a5,80202274 <walk_create+0x82>
            pt = (pagetable_t)PTE2PA(*pte);
    80202264:	fe043783          	ld	a5,-32(s0)
    80202268:	639c                	ld	a5,0(a5)
    8020226a:	83a9                	srli	a5,a5,0xa
    8020226c:	07b2                	slli	a5,a5,0xc
    8020226e:	fcf43423          	sd	a5,-56(s0)
    80202272:	a089                	j	802022b4 <walk_create+0xc2>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    80202274:	00001097          	auipc	ra,0x1
    80202278:	fb2080e7          	jalr	-78(ra) # 80203226 <alloc_page>
    8020227c:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    80202280:	fd843783          	ld	a5,-40(s0)
    80202284:	e399                	bnez	a5,8020228a <walk_create+0x98>
                return 0;
    80202286:	4781                	li	a5,0
    80202288:	a8a1                	j	802022e0 <walk_create+0xee>
            memset(new_pt, 0, PGSIZE);
    8020228a:	6605                	lui	a2,0x1
    8020228c:	4581                	li	a1,0
    8020228e:	fd843503          	ld	a0,-40(s0)
    80202292:	00000097          	auipc	ra,0x0
    80202296:	b8c080e7          	jalr	-1140(ra) # 80201e1e <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    8020229a:	fd843783          	ld	a5,-40(s0)
    8020229e:	83b1                	srli	a5,a5,0xc
    802022a0:	07aa                	slli	a5,a5,0xa
    802022a2:	0017e713          	ori	a4,a5,1
    802022a6:	fe043783          	ld	a5,-32(s0)
    802022aa:	e398                	sd	a4,0(a5)
            pt = new_pt;
    802022ac:	fd843783          	ld	a5,-40(s0)
    802022b0:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    802022b4:	fec42783          	lw	a5,-20(s0)
    802022b8:	37fd                	addiw	a5,a5,-1
    802022ba:	fef42623          	sw	a5,-20(s0)
    802022be:	fec42783          	lw	a5,-20(s0)
    802022c2:	2781                	sext.w	a5,a5
    802022c4:	f6f04be3          	bgtz	a5,8020223a <walk_create+0x48>
    return &pt[px(0, va)];
    802022c8:	fc043583          	ld	a1,-64(s0)
    802022cc:	4501                	li	a0,0
    802022ce:	00000097          	auipc	ra,0x0
    802022d2:	d72080e7          	jalr	-654(ra) # 80202040 <px>
    802022d6:	87aa                	mv	a5,a0
    802022d8:	078e                	slli	a5,a5,0x3
    802022da:	fc843703          	ld	a4,-56(s0)
    802022de:	97ba                	add	a5,a5,a4
}
    802022e0:	853e                	mv	a0,a5
    802022e2:	70e2                	ld	ra,56(sp)
    802022e4:	7442                	ld	s0,48(sp)
    802022e6:	6121                	addi	sp,sp,64
    802022e8:	8082                	ret

00000000802022ea <map_page>:
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    802022ea:	715d                	addi	sp,sp,-80
    802022ec:	e486                	sd	ra,72(sp)
    802022ee:	e0a2                	sd	s0,64(sp)
    802022f0:	0880                	addi	s0,sp,80
    802022f2:	fca43423          	sd	a0,-56(s0)
    802022f6:	fcb43023          	sd	a1,-64(s0)
    802022fa:	fac43c23          	sd	a2,-72(s0)
    802022fe:	87b6                	mv	a5,a3
    80202300:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = myproc();
    80202304:	00002097          	auipc	ra,0x2
    80202308:	67c080e7          	jalr	1660(ra) # 80204980 <myproc>
    8020230c:	fea43023          	sd	a0,-32(s0)
	if (p && p->is_user && va >= 0x80000000
    80202310:	fe043783          	ld	a5,-32(s0)
    80202314:	c7a9                	beqz	a5,8020235e <map_page+0x74>
    80202316:	fe043783          	ld	a5,-32(s0)
    8020231a:	0a87a783          	lw	a5,168(a5)
    8020231e:	c3a1                	beqz	a5,8020235e <map_page+0x74>
    80202320:	fc043703          	ld	a4,-64(s0)
    80202324:	800007b7          	lui	a5,0x80000
    80202328:	fff7c793          	not	a5,a5
    8020232c:	02e7f963          	bgeu	a5,a4,8020235e <map_page+0x74>
		&& va != TRAMPOLINE
    80202330:	fc043703          	ld	a4,-64(s0)
    80202334:	77fd                	lui	a5,0xfffff
    80202336:	02f70463          	beq	a4,a5,8020235e <map_page+0x74>
		&& va != TRAPFRAME) {
    8020233a:	fc043703          	ld	a4,-64(s0)
    8020233e:	77f9                	lui	a5,0xffffe
    80202340:	00f70f63          	beq	a4,a5,8020235e <map_page+0x74>
		warning("map_page: 用户进程禁止映射内核空间");
    80202344:	00006517          	auipc	a0,0x6
    80202348:	5d450513          	addi	a0,a0,1492 # 80208918 <simple_user_task_bin+0x158>
    8020234c:	fffff097          	auipc	ra,0xfffff
    80202350:	3c8080e7          	jalr	968(ra) # 80201714 <warning>
		exit_proc(-1);
    80202354:	557d                	li	a0,-1
    80202356:	00003097          	auipc	ra,0x3
    8020235a:	44a080e7          	jalr	1098(ra) # 802057a0 <exit_proc>
    if ((va % PGSIZE) != 0)
    8020235e:	fc043703          	ld	a4,-64(s0)
    80202362:	6785                	lui	a5,0x1
    80202364:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80202366:	8ff9                	and	a5,a5,a4
    80202368:	cb89                	beqz	a5,8020237a <map_page+0x90>
        panic("map_page: va not aligned");
    8020236a:	00006517          	auipc	a0,0x6
    8020236e:	5de50513          	addi	a0,a0,1502 # 80208948 <simple_user_task_bin+0x188>
    80202372:	fffff097          	auipc	ra,0xfffff
    80202376:	36e080e7          	jalr	878(ra) # 802016e0 <panic>
    pte_t *pte = walk_create(pt, va);
    8020237a:	fc043583          	ld	a1,-64(s0)
    8020237e:	fc843503          	ld	a0,-56(s0)
    80202382:	00000097          	auipc	ra,0x0
    80202386:	e70080e7          	jalr	-400(ra) # 802021f2 <walk_create>
    8020238a:	fca43c23          	sd	a0,-40(s0)
    if (!pte)
    8020238e:	fd843783          	ld	a5,-40(s0)
    80202392:	e399                	bnez	a5,80202398 <map_page+0xae>
        return -1;
    80202394:	57fd                	li	a5,-1
    80202396:	a87d                	j	80202454 <map_page+0x16a>
    if (va >= 0x80000000)
    80202398:	fc043703          	ld	a4,-64(s0)
    8020239c:	800007b7          	lui	a5,0x80000
    802023a0:	fff7c793          	not	a5,a5
    802023a4:	00e7f763          	bgeu	a5,a4,802023b2 <map_page+0xc8>
        perm &= ~PTE_U;
    802023a8:	fb442783          	lw	a5,-76(s0)
    802023ac:	9bbd                	andi	a5,a5,-17
    802023ae:	faf42a23          	sw	a5,-76(s0)
    if (*pte & PTE_V) {
    802023b2:	fd843783          	ld	a5,-40(s0)
    802023b6:	639c                	ld	a5,0(a5)
    802023b8:	8b85                	andi	a5,a5,1
    802023ba:	cfbd                	beqz	a5,80202438 <map_page+0x14e>
        if (PTE2PA(*pte) == pa) {
    802023bc:	fd843783          	ld	a5,-40(s0)
    802023c0:	639c                	ld	a5,0(a5)
    802023c2:	83a9                	srli	a5,a5,0xa
    802023c4:	07b2                	slli	a5,a5,0xc
    802023c6:	fb843703          	ld	a4,-72(s0)
    802023ca:	04f71f63          	bne	a4,a5,80202428 <map_page+0x13e>
            int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
    802023ce:	fd843783          	ld	a5,-40(s0)
    802023d2:	639c                	ld	a5,0(a5)
    802023d4:	2781                	sext.w	a5,a5
    802023d6:	3ff7f793          	andi	a5,a5,1023
    802023da:	0007871b          	sext.w	a4,a5
    802023de:	fb442783          	lw	a5,-76(s0)
    802023e2:	8fd9                	or	a5,a5,a4
    802023e4:	2781                	sext.w	a5,a5
    802023e6:	2781                	sext.w	a5,a5
    802023e8:	3ff7f793          	andi	a5,a5,1023
    802023ec:	fef42623          	sw	a5,-20(s0)
            if (va >= 0x80000000)
    802023f0:	fc043703          	ld	a4,-64(s0)
    802023f4:	800007b7          	lui	a5,0x80000
    802023f8:	fff7c793          	not	a5,a5
    802023fc:	00e7f763          	bgeu	a5,a4,8020240a <map_page+0x120>
                new_perm &= ~PTE_U;
    80202400:	fec42783          	lw	a5,-20(s0)
    80202404:	9bbd                	andi	a5,a5,-17
    80202406:	fef42623          	sw	a5,-20(s0)
            *pte = PA2PTE(pa) | new_perm | PTE_V;
    8020240a:	fb843783          	ld	a5,-72(s0)
    8020240e:	83b1                	srli	a5,a5,0xc
    80202410:	00a79713          	slli	a4,a5,0xa
    80202414:	fec42783          	lw	a5,-20(s0)
    80202418:	8fd9                	or	a5,a5,a4
    8020241a:	0017e713          	ori	a4,a5,1
    8020241e:	fd843783          	ld	a5,-40(s0)
    80202422:	e398                	sd	a4,0(a5)
            return 0;
    80202424:	4781                	li	a5,0
    80202426:	a03d                	j	80202454 <map_page+0x16a>
            panic("map_page: remap to different physical address");
    80202428:	00006517          	auipc	a0,0x6
    8020242c:	54050513          	addi	a0,a0,1344 # 80208968 <simple_user_task_bin+0x1a8>
    80202430:	fffff097          	auipc	ra,0xfffff
    80202434:	2b0080e7          	jalr	688(ra) # 802016e0 <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80202438:	fb843783          	ld	a5,-72(s0)
    8020243c:	83b1                	srli	a5,a5,0xc
    8020243e:	00a79713          	slli	a4,a5,0xa
    80202442:	fb442783          	lw	a5,-76(s0)
    80202446:	8fd9                	or	a5,a5,a4
    80202448:	0017e713          	ori	a4,a5,1
    8020244c:	fd843783          	ld	a5,-40(s0)
    80202450:	e398                	sd	a4,0(a5)
    return 0;
    80202452:	4781                	li	a5,0
}
    80202454:	853e                	mv	a0,a5
    80202456:	60a6                	ld	ra,72(sp)
    80202458:	6406                	ld	s0,64(sp)
    8020245a:	6161                	addi	sp,sp,80
    8020245c:	8082                	ret

000000008020245e <free_pagetable>:
void free_pagetable(pagetable_t pt) {
    8020245e:	7139                	addi	sp,sp,-64
    80202460:	fc06                	sd	ra,56(sp)
    80202462:	f822                	sd	s0,48(sp)
    80202464:	0080                	addi	s0,sp,64
    80202466:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    8020246a:	fe042623          	sw	zero,-20(s0)
    8020246e:	a8a5                	j	802024e6 <free_pagetable+0x88>
        pte_t pte = pt[i];
    80202470:	fec42783          	lw	a5,-20(s0)
    80202474:	078e                	slli	a5,a5,0x3
    80202476:	fc843703          	ld	a4,-56(s0)
    8020247a:	97ba                	add	a5,a5,a4
    8020247c:	639c                	ld	a5,0(a5)
    8020247e:	fef43023          	sd	a5,-32(s0)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80202482:	fe043783          	ld	a5,-32(s0)
    80202486:	8b85                	andi	a5,a5,1
    80202488:	cb95                	beqz	a5,802024bc <free_pagetable+0x5e>
    8020248a:	fe043783          	ld	a5,-32(s0)
    8020248e:	8bb9                	andi	a5,a5,14
    80202490:	e795                	bnez	a5,802024bc <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    80202492:	fe043783          	ld	a5,-32(s0)
    80202496:	83a9                	srli	a5,a5,0xa
    80202498:	07b2                	slli	a5,a5,0xc
    8020249a:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    8020249e:	fd843503          	ld	a0,-40(s0)
    802024a2:	00000097          	auipc	ra,0x0
    802024a6:	fbc080e7          	jalr	-68(ra) # 8020245e <free_pagetable>
            pt[i] = 0;
    802024aa:	fec42783          	lw	a5,-20(s0)
    802024ae:	078e                	slli	a5,a5,0x3
    802024b0:	fc843703          	ld	a4,-56(s0)
    802024b4:	97ba                	add	a5,a5,a4
    802024b6:	0007b023          	sd	zero,0(a5) # ffffffff80000000 <_bss_end+0xfffffffeffdf1900>
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    802024ba:	a00d                	j	802024dc <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    802024bc:	fe043783          	ld	a5,-32(s0)
    802024c0:	8b85                	andi	a5,a5,1
    802024c2:	cf89                	beqz	a5,802024dc <free_pagetable+0x7e>
    802024c4:	fe043783          	ld	a5,-32(s0)
    802024c8:	8bb9                	andi	a5,a5,14
    802024ca:	cb89                	beqz	a5,802024dc <free_pagetable+0x7e>
            pt[i] = 0;
    802024cc:	fec42783          	lw	a5,-20(s0)
    802024d0:	078e                	slli	a5,a5,0x3
    802024d2:	fc843703          	ld	a4,-56(s0)
    802024d6:	97ba                	add	a5,a5,a4
    802024d8:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    802024dc:	fec42783          	lw	a5,-20(s0)
    802024e0:	2785                	addiw	a5,a5,1
    802024e2:	fef42623          	sw	a5,-20(s0)
    802024e6:	fec42783          	lw	a5,-20(s0)
    802024ea:	0007871b          	sext.w	a4,a5
    802024ee:	1ff00793          	li	a5,511
    802024f2:	f6e7dfe3          	bge	a5,a4,80202470 <free_pagetable+0x12>
    free_page(pt);
    802024f6:	fc843503          	ld	a0,-56(s0)
    802024fa:	00001097          	auipc	ra,0x1
    802024fe:	d98080e7          	jalr	-616(ra) # 80203292 <free_page>
}
    80202502:	0001                	nop
    80202504:	70e2                	ld	ra,56(sp)
    80202506:	7442                	ld	s0,48(sp)
    80202508:	6121                	addi	sp,sp,64
    8020250a:	8082                	ret

000000008020250c <kvmmake>:
static pagetable_t kvmmake(void) {
    8020250c:	715d                	addi	sp,sp,-80
    8020250e:	e486                	sd	ra,72(sp)
    80202510:	e0a2                	sd	s0,64(sp)
    80202512:	0880                	addi	s0,sp,80
    pagetable_t kpgtbl = create_pagetable();
    80202514:	00000097          	auipc	ra,0x0
    80202518:	b66080e7          	jalr	-1178(ra) # 8020207a <create_pagetable>
    8020251c:	fca43423          	sd	a0,-56(s0)
    if (!kpgtbl){
    80202520:	fc843783          	ld	a5,-56(s0)
    80202524:	eb89                	bnez	a5,80202536 <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    80202526:	00006517          	auipc	a0,0x6
    8020252a:	47250513          	addi	a0,a0,1138 # 80208998 <simple_user_task_bin+0x1d8>
    8020252e:	fffff097          	auipc	ra,0xfffff
    80202532:	1b2080e7          	jalr	434(ra) # 802016e0 <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    80202536:	4785                	li	a5,1
    80202538:	07fe                	slli	a5,a5,0x1f
    8020253a:	fef43423          	sd	a5,-24(s0)
    8020253e:	a8a1                	j	80202596 <kvmmake+0x8a>
        int perm = PTE_R | PTE_W;
    80202540:	4799                	li	a5,6
    80202542:	fef42223          	sw	a5,-28(s0)
        if (pa < (uint64)etext)
    80202546:	00005797          	auipc	a5,0x5
    8020254a:	aba78793          	addi	a5,a5,-1350 # 80207000 <etext>
    8020254e:	fe843703          	ld	a4,-24(s0)
    80202552:	00f77563          	bgeu	a4,a5,8020255c <kvmmake+0x50>
            perm = PTE_R | PTE_X;
    80202556:	47a9                	li	a5,10
    80202558:	fef42223          	sw	a5,-28(s0)
        if (map_page(kpgtbl, pa, pa, perm) != 0)
    8020255c:	fe442783          	lw	a5,-28(s0)
    80202560:	86be                	mv	a3,a5
    80202562:	fe843603          	ld	a2,-24(s0)
    80202566:	fe843583          	ld	a1,-24(s0)
    8020256a:	fc843503          	ld	a0,-56(s0)
    8020256e:	00000097          	auipc	ra,0x0
    80202572:	d7c080e7          	jalr	-644(ra) # 802022ea <map_page>
    80202576:	87aa                	mv	a5,a0
    80202578:	cb89                	beqz	a5,8020258a <kvmmake+0x7e>
            panic("kvmmake: heap map failed");
    8020257a:	00006517          	auipc	a0,0x6
    8020257e:	43650513          	addi	a0,a0,1078 # 802089b0 <simple_user_task_bin+0x1f0>
    80202582:	fffff097          	auipc	ra,0xfffff
    80202586:	15e080e7          	jalr	350(ra) # 802016e0 <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    8020258a:	fe843703          	ld	a4,-24(s0)
    8020258e:	6785                	lui	a5,0x1
    80202590:	97ba                	add	a5,a5,a4
    80202592:	fef43423          	sd	a5,-24(s0)
    80202596:	fe843703          	ld	a4,-24(s0)
    8020259a:	47c5                	li	a5,17
    8020259c:	07ee                	slli	a5,a5,0x1b
    8020259e:	faf761e3          	bltu	a4,a5,80202540 <kvmmake+0x34>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    802025a2:	4699                	li	a3,6
    802025a4:	10000637          	lui	a2,0x10000
    802025a8:	100005b7          	lui	a1,0x10000
    802025ac:	fc843503          	ld	a0,-56(s0)
    802025b0:	00000097          	auipc	ra,0x0
    802025b4:	d3a080e7          	jalr	-710(ra) # 802022ea <map_page>
    802025b8:	87aa                	mv	a5,a0
    802025ba:	cb89                	beqz	a5,802025cc <kvmmake+0xc0>
        panic("kvmmake: uart map failed");
    802025bc:	00006517          	auipc	a0,0x6
    802025c0:	41450513          	addi	a0,a0,1044 # 802089d0 <simple_user_task_bin+0x210>
    802025c4:	fffff097          	auipc	ra,0xfffff
    802025c8:	11c080e7          	jalr	284(ra) # 802016e0 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    802025cc:	0c0007b7          	lui	a5,0xc000
    802025d0:	fcf43c23          	sd	a5,-40(s0)
    802025d4:	a825                	j	8020260c <kvmmake+0x100>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802025d6:	4699                	li	a3,6
    802025d8:	fd843603          	ld	a2,-40(s0)
    802025dc:	fd843583          	ld	a1,-40(s0)
    802025e0:	fc843503          	ld	a0,-56(s0)
    802025e4:	00000097          	auipc	ra,0x0
    802025e8:	d06080e7          	jalr	-762(ra) # 802022ea <map_page>
    802025ec:	87aa                	mv	a5,a0
    802025ee:	cb89                	beqz	a5,80202600 <kvmmake+0xf4>
            panic("kvmmake: plic map failed");
    802025f0:	00006517          	auipc	a0,0x6
    802025f4:	40050513          	addi	a0,a0,1024 # 802089f0 <simple_user_task_bin+0x230>
    802025f8:	fffff097          	auipc	ra,0xfffff
    802025fc:	0e8080e7          	jalr	232(ra) # 802016e0 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80202600:	fd843703          	ld	a4,-40(s0)
    80202604:	6785                	lui	a5,0x1
    80202606:	97ba                	add	a5,a5,a4
    80202608:	fcf43c23          	sd	a5,-40(s0)
    8020260c:	fd843703          	ld	a4,-40(s0)
    80202610:	0c4007b7          	lui	a5,0xc400
    80202614:	fcf761e3          	bltu	a4,a5,802025d6 <kvmmake+0xca>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    80202618:	020007b7          	lui	a5,0x2000
    8020261c:	fcf43823          	sd	a5,-48(s0)
    80202620:	a825                	j	80202658 <kvmmake+0x14c>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202622:	4699                	li	a3,6
    80202624:	fd043603          	ld	a2,-48(s0)
    80202628:	fd043583          	ld	a1,-48(s0)
    8020262c:	fc843503          	ld	a0,-56(s0)
    80202630:	00000097          	auipc	ra,0x0
    80202634:	cba080e7          	jalr	-838(ra) # 802022ea <map_page>
    80202638:	87aa                	mv	a5,a0
    8020263a:	cb89                	beqz	a5,8020264c <kvmmake+0x140>
            panic("kvmmake: clint map failed");
    8020263c:	00006517          	auipc	a0,0x6
    80202640:	3d450513          	addi	a0,a0,980 # 80208a10 <simple_user_task_bin+0x250>
    80202644:	fffff097          	auipc	ra,0xfffff
    80202648:	09c080e7          	jalr	156(ra) # 802016e0 <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    8020264c:	fd043703          	ld	a4,-48(s0)
    80202650:	6785                	lui	a5,0x1
    80202652:	97ba                	add	a5,a5,a4
    80202654:	fcf43823          	sd	a5,-48(s0)
    80202658:	fd043703          	ld	a4,-48(s0)
    8020265c:	020107b7          	lui	a5,0x2010
    80202660:	fcf761e3          	bltu	a4,a5,80202622 <kvmmake+0x116>
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    80202664:	4699                	li	a3,6
    80202666:	10001637          	lui	a2,0x10001
    8020266a:	100015b7          	lui	a1,0x10001
    8020266e:	fc843503          	ld	a0,-56(s0)
    80202672:	00000097          	auipc	ra,0x0
    80202676:	c78080e7          	jalr	-904(ra) # 802022ea <map_page>
    8020267a:	87aa                	mv	a5,a0
    8020267c:	cb89                	beqz	a5,8020268e <kvmmake+0x182>
        panic("kvmmake: virtio map failed");
    8020267e:	00006517          	auipc	a0,0x6
    80202682:	3b250513          	addi	a0,a0,946 # 80208a30 <simple_user_task_bin+0x270>
    80202686:	fffff097          	auipc	ra,0xfffff
    8020268a:	05a080e7          	jalr	90(ra) # 802016e0 <panic>
	void *tramp_phys = alloc_page();
    8020268e:	00001097          	auipc	ra,0x1
    80202692:	b98080e7          	jalr	-1128(ra) # 80203226 <alloc_page>
    80202696:	fca43023          	sd	a0,-64(s0)
	if (!tramp_phys)
    8020269a:	fc043783          	ld	a5,-64(s0)
    8020269e:	eb89                	bnez	a5,802026b0 <kvmmake+0x1a4>
		panic("kvmmake: alloc trampoline page failed");
    802026a0:	00006517          	auipc	a0,0x6
    802026a4:	3b050513          	addi	a0,a0,944 # 80208a50 <simple_user_task_bin+0x290>
    802026a8:	fffff097          	auipc	ra,0xfffff
    802026ac:	038080e7          	jalr	56(ra) # 802016e0 <panic>
	memcpy(tramp_phys, trampoline, PGSIZE);
    802026b0:	6605                	lui	a2,0x1
    802026b2:	00002597          	auipc	a1,0x2
    802026b6:	02e58593          	addi	a1,a1,46 # 802046e0 <trampoline>
    802026ba:	fc043503          	ld	a0,-64(s0)
    802026be:	00000097          	auipc	ra,0x0
    802026c2:	86c080e7          	jalr	-1940(ra) # 80201f2a <memcpy>
	void *trapframe_phys = alloc_page();
    802026c6:	00001097          	auipc	ra,0x1
    802026ca:	b60080e7          	jalr	-1184(ra) # 80203226 <alloc_page>
    802026ce:	faa43c23          	sd	a0,-72(s0)
	if (!trapframe_phys)
    802026d2:	fb843783          	ld	a5,-72(s0)
    802026d6:	eb89                	bnez	a5,802026e8 <kvmmake+0x1dc>
		panic("kvmmake: alloc trapframe page failed");
    802026d8:	00006517          	auipc	a0,0x6
    802026dc:	3a050513          	addi	a0,a0,928 # 80208a78 <simple_user_task_bin+0x2b8>
    802026e0:	fffff097          	auipc	ra,0xfffff
    802026e4:	000080e7          	jalr	ra # 802016e0 <panic>
	memset(trapframe_phys, 0, PGSIZE);
    802026e8:	6605                	lui	a2,0x1
    802026ea:	4581                	li	a1,0
    802026ec:	fb843503          	ld	a0,-72(s0)
    802026f0:	fffff097          	auipc	ra,0xfffff
    802026f4:	72e080e7          	jalr	1838(ra) # 80201e1e <memset>
	if (map_page(kpgtbl, TRAMPOLINE, (uint64)tramp_phys, PTE_R | PTE_X) != 0){
    802026f8:	fc043783          	ld	a5,-64(s0)
    802026fc:	46a9                	li	a3,10
    802026fe:	863e                	mv	a2,a5
    80202700:	75fd                	lui	a1,0xfffff
    80202702:	fc843503          	ld	a0,-56(s0)
    80202706:	00000097          	auipc	ra,0x0
    8020270a:	be4080e7          	jalr	-1052(ra) # 802022ea <map_page>
    8020270e:	87aa                	mv	a5,a0
    80202710:	cb89                	beqz	a5,80202722 <kvmmake+0x216>
		panic("kvmmake: trampoline map failed");
    80202712:	00006517          	auipc	a0,0x6
    80202716:	38e50513          	addi	a0,a0,910 # 80208aa0 <simple_user_task_bin+0x2e0>
    8020271a:	fffff097          	auipc	ra,0xfffff
    8020271e:	fc6080e7          	jalr	-58(ra) # 802016e0 <panic>
	if (map_page(kpgtbl, TRAPFRAME, (uint64)trapframe_phys, PTE_R | PTE_W) != 0){
    80202722:	fb843783          	ld	a5,-72(s0)
    80202726:	4699                	li	a3,6
    80202728:	863e                	mv	a2,a5
    8020272a:	75f9                	lui	a1,0xffffe
    8020272c:	fc843503          	ld	a0,-56(s0)
    80202730:	00000097          	auipc	ra,0x0
    80202734:	bba080e7          	jalr	-1094(ra) # 802022ea <map_page>
    80202738:	87aa                	mv	a5,a0
    8020273a:	cb89                	beqz	a5,8020274c <kvmmake+0x240>
		panic("kvmmake: trapframe map failed");
    8020273c:	00006517          	auipc	a0,0x6
    80202740:	38450513          	addi	a0,a0,900 # 80208ac0 <simple_user_task_bin+0x300>
    80202744:	fffff097          	auipc	ra,0xfffff
    80202748:	f9c080e7          	jalr	-100(ra) # 802016e0 <panic>
	trampoline_phys_addr = (uint64)tramp_phys;
    8020274c:	fc043703          	ld	a4,-64(s0)
    80202750:	0000c797          	auipc	a5,0xc
    80202754:	94878793          	addi	a5,a5,-1720 # 8020e098 <trampoline_phys_addr>
    80202758:	e398                	sd	a4,0(a5)
	trapframe_phys_addr = (uint64)trapframe_phys;
    8020275a:	fb843703          	ld	a4,-72(s0)
    8020275e:	0000c797          	auipc	a5,0xc
    80202762:	94278793          	addi	a5,a5,-1726 # 8020e0a0 <trapframe_phys_addr>
    80202766:	e398                	sd	a4,0(a5)
	printf("trampoline_phy_addr = %lx\n",trampoline_phys_addr);
    80202768:	0000c797          	auipc	a5,0xc
    8020276c:	93078793          	addi	a5,a5,-1744 # 8020e098 <trampoline_phys_addr>
    80202770:	639c                	ld	a5,0(a5)
    80202772:	85be                	mv	a1,a5
    80202774:	00006517          	auipc	a0,0x6
    80202778:	36c50513          	addi	a0,a0,876 # 80208ae0 <simple_user_task_bin+0x320>
    8020277c:	ffffe097          	auipc	ra,0xffffe
    80202780:	518080e7          	jalr	1304(ra) # 80200c94 <printf>
	printf("trapframe_phys_addr = %lx\n",trapframe_phys_addr);
    80202784:	0000c797          	auipc	a5,0xc
    80202788:	91c78793          	addi	a5,a5,-1764 # 8020e0a0 <trapframe_phys_addr>
    8020278c:	639c                	ld	a5,0(a5)
    8020278e:	85be                	mv	a1,a5
    80202790:	00006517          	auipc	a0,0x6
    80202794:	37050513          	addi	a0,a0,880 # 80208b00 <simple_user_task_bin+0x340>
    80202798:	ffffe097          	auipc	ra,0xffffe
    8020279c:	4fc080e7          	jalr	1276(ra) # 80200c94 <printf>
    return kpgtbl;
    802027a0:	fc843783          	ld	a5,-56(s0)
}
    802027a4:	853e                	mv	a0,a5
    802027a6:	60a6                	ld	ra,72(sp)
    802027a8:	6406                	ld	s0,64(sp)
    802027aa:	6161                	addi	sp,sp,80
    802027ac:	8082                	ret

00000000802027ae <w_satp>:
static inline void w_satp(uint64 x) {
    802027ae:	1101                	addi	sp,sp,-32
    802027b0:	ec22                	sd	s0,24(sp)
    802027b2:	1000                	addi	s0,sp,32
    802027b4:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    802027b8:	fe843783          	ld	a5,-24(s0)
    802027bc:	18079073          	csrw	satp,a5
}
    802027c0:	0001                	nop
    802027c2:	6462                	ld	s0,24(sp)
    802027c4:	6105                	addi	sp,sp,32
    802027c6:	8082                	ret

00000000802027c8 <sfence_vma>:
inline void sfence_vma(void) {
    802027c8:	1141                	addi	sp,sp,-16
    802027ca:	e422                	sd	s0,8(sp)
    802027cc:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    802027ce:	12000073          	sfence.vma
}
    802027d2:	0001                	nop
    802027d4:	6422                	ld	s0,8(sp)
    802027d6:	0141                	addi	sp,sp,16
    802027d8:	8082                	ret

00000000802027da <kvminit>:
void kvminit(void) {
    802027da:	1141                	addi	sp,sp,-16
    802027dc:	e406                	sd	ra,8(sp)
    802027de:	e022                	sd	s0,0(sp)
    802027e0:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    802027e2:	00000097          	auipc	ra,0x0
    802027e6:	d2a080e7          	jalr	-726(ra) # 8020250c <kvmmake>
    802027ea:	872a                	mv	a4,a0
    802027ec:	0000c797          	auipc	a5,0xc
    802027f0:	8a478793          	addi	a5,a5,-1884 # 8020e090 <kernel_pagetable>
    802027f4:	e398                	sd	a4,0(a5)
    sfence_vma();
    802027f6:	00000097          	auipc	ra,0x0
    802027fa:	fd2080e7          	jalr	-46(ra) # 802027c8 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    802027fe:	0000c797          	auipc	a5,0xc
    80202802:	89278793          	addi	a5,a5,-1902 # 8020e090 <kernel_pagetable>
    80202806:	639c                	ld	a5,0(a5)
    80202808:	00c7d713          	srli	a4,a5,0xc
    8020280c:	57fd                	li	a5,-1
    8020280e:	17fe                	slli	a5,a5,0x3f
    80202810:	8fd9                	or	a5,a5,a4
    80202812:	853e                	mv	a0,a5
    80202814:	00000097          	auipc	ra,0x0
    80202818:	f9a080e7          	jalr	-102(ra) # 802027ae <w_satp>
    sfence_vma();
    8020281c:	00000097          	auipc	ra,0x0
    80202820:	fac080e7          	jalr	-84(ra) # 802027c8 <sfence_vma>
    printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
    80202824:	0000c797          	auipc	a5,0xc
    80202828:	86c78793          	addi	a5,a5,-1940 # 8020e090 <kernel_pagetable>
    8020282c:	639c                	ld	a5,0(a5)
    8020282e:	00c7d713          	srli	a4,a5,0xc
    80202832:	57fd                	li	a5,-1
    80202834:	17fe                	slli	a5,a5,0x3f
    80202836:	8fd9                	or	a5,a5,a4
    80202838:	85be                	mv	a1,a5
    8020283a:	00006517          	auipc	a0,0x6
    8020283e:	2e650513          	addi	a0,a0,742 # 80208b20 <simple_user_task_bin+0x360>
    80202842:	ffffe097          	auipc	ra,0xffffe
    80202846:	452080e7          	jalr	1106(ra) # 80200c94 <printf>
}
    8020284a:	0001                	nop
    8020284c:	60a2                	ld	ra,8(sp)
    8020284e:	6402                	ld	s0,0(sp)
    80202850:	0141                	addi	sp,sp,16
    80202852:	8082                	ret

0000000080202854 <get_current_pagetable>:
pagetable_t get_current_pagetable(void) {
    80202854:	1141                	addi	sp,sp,-16
    80202856:	e422                	sd	s0,8(sp)
    80202858:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    8020285a:	0000c797          	auipc	a5,0xc
    8020285e:	83678793          	addi	a5,a5,-1994 # 8020e090 <kernel_pagetable>
    80202862:	639c                	ld	a5,0(a5)
}
    80202864:	853e                	mv	a0,a5
    80202866:	6422                	ld	s0,8(sp)
    80202868:	0141                	addi	sp,sp,16
    8020286a:	8082                	ret

000000008020286c <print_pagetable>:
void print_pagetable(pagetable_t pagetable, int level, uint64 va_base) {
    8020286c:	715d                	addi	sp,sp,-80
    8020286e:	e486                	sd	ra,72(sp)
    80202870:	e0a2                	sd	s0,64(sp)
    80202872:	0880                	addi	s0,sp,80
    80202874:	fca43423          	sd	a0,-56(s0)
    80202878:	87ae                	mv	a5,a1
    8020287a:	fac43c23          	sd	a2,-72(s0)
    8020287e:	fcf42223          	sw	a5,-60(s0)
    for (int i = 0; i < 512; i++) {
    80202882:	fe042623          	sw	zero,-20(s0)
    80202886:	a0c5                	j	80202966 <print_pagetable+0xfa>
        pte_t pte = pagetable[i];
    80202888:	fec42783          	lw	a5,-20(s0)
    8020288c:	078e                	slli	a5,a5,0x3
    8020288e:	fc843703          	ld	a4,-56(s0)
    80202892:	97ba                	add	a5,a5,a4
    80202894:	639c                	ld	a5,0(a5)
    80202896:	fef43023          	sd	a5,-32(s0)
        if (pte & PTE_V) {
    8020289a:	fe043783          	ld	a5,-32(s0)
    8020289e:	8b85                	andi	a5,a5,1
    802028a0:	cfd5                	beqz	a5,8020295c <print_pagetable+0xf0>
            uint64 pa = PTE2PA(pte);
    802028a2:	fe043783          	ld	a5,-32(s0)
    802028a6:	83a9                	srli	a5,a5,0xa
    802028a8:	07b2                	slli	a5,a5,0xc
    802028aa:	fcf43c23          	sd	a5,-40(s0)
            uint64 va = va_base + (i << (12 + 9 * (2 - level)));
    802028ae:	4789                	li	a5,2
    802028b0:	fc442703          	lw	a4,-60(s0)
    802028b4:	9f99                	subw	a5,a5,a4
    802028b6:	2781                	sext.w	a5,a5
    802028b8:	873e                	mv	a4,a5
    802028ba:	87ba                	mv	a5,a4
    802028bc:	0037979b          	slliw	a5,a5,0x3
    802028c0:	9fb9                	addw	a5,a5,a4
    802028c2:	2781                	sext.w	a5,a5
    802028c4:	27b1                	addiw	a5,a5,12
    802028c6:	2781                	sext.w	a5,a5
    802028c8:	fec42703          	lw	a4,-20(s0)
    802028cc:	00f717bb          	sllw	a5,a4,a5
    802028d0:	2781                	sext.w	a5,a5
    802028d2:	873e                	mv	a4,a5
    802028d4:	fb843783          	ld	a5,-72(s0)
    802028d8:	97ba                	add	a5,a5,a4
    802028da:	fcf43823          	sd	a5,-48(s0)
            for (int l = 0; l < level; l++) printf("  "); // 缩进
    802028de:	fe042423          	sw	zero,-24(s0)
    802028e2:	a831                	j	802028fe <print_pagetable+0x92>
    802028e4:	00006517          	auipc	a0,0x6
    802028e8:	26c50513          	addi	a0,a0,620 # 80208b50 <simple_user_task_bin+0x390>
    802028ec:	ffffe097          	auipc	ra,0xffffe
    802028f0:	3a8080e7          	jalr	936(ra) # 80200c94 <printf>
    802028f4:	fe842783          	lw	a5,-24(s0)
    802028f8:	2785                	addiw	a5,a5,1
    802028fa:	fef42423          	sw	a5,-24(s0)
    802028fe:	fe842783          	lw	a5,-24(s0)
    80202902:	873e                	mv	a4,a5
    80202904:	fc442783          	lw	a5,-60(s0)
    80202908:	2701                	sext.w	a4,a4
    8020290a:	2781                	sext.w	a5,a5
    8020290c:	fcf74ce3          	blt	a4,a5,802028e4 <print_pagetable+0x78>
            printf("L%d[%3d] VA:0x%lx -> PA:0x%lx flags:0x%lx\n", level, i, va, pa, pte & 0x3FF);
    80202910:	fe043783          	ld	a5,-32(s0)
    80202914:	3ff7f793          	andi	a5,a5,1023
    80202918:	fec42603          	lw	a2,-20(s0)
    8020291c:	fc442583          	lw	a1,-60(s0)
    80202920:	fd843703          	ld	a4,-40(s0)
    80202924:	fd043683          	ld	a3,-48(s0)
    80202928:	00006517          	auipc	a0,0x6
    8020292c:	23050513          	addi	a0,a0,560 # 80208b58 <simple_user_task_bin+0x398>
    80202930:	ffffe097          	auipc	ra,0xffffe
    80202934:	364080e7          	jalr	868(ra) # 80200c94 <printf>
            if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // 不是叶子
    80202938:	fe043783          	ld	a5,-32(s0)
    8020293c:	8bb9                	andi	a5,a5,14
    8020293e:	ef99                	bnez	a5,8020295c <print_pagetable+0xf0>
                print_pagetable((pagetable_t)pa, level + 1, va);
    80202940:	fd843783          	ld	a5,-40(s0)
    80202944:	fc442703          	lw	a4,-60(s0)
    80202948:	2705                	addiw	a4,a4,1
    8020294a:	2701                	sext.w	a4,a4
    8020294c:	fd043603          	ld	a2,-48(s0)
    80202950:	85ba                	mv	a1,a4
    80202952:	853e                	mv	a0,a5
    80202954:	00000097          	auipc	ra,0x0
    80202958:	f18080e7          	jalr	-232(ra) # 8020286c <print_pagetable>
    for (int i = 0; i < 512; i++) {
    8020295c:	fec42783          	lw	a5,-20(s0)
    80202960:	2785                	addiw	a5,a5,1
    80202962:	fef42623          	sw	a5,-20(s0)
    80202966:	fec42783          	lw	a5,-20(s0)
    8020296a:	0007871b          	sext.w	a4,a5
    8020296e:	1ff00793          	li	a5,511
    80202972:	f0e7dbe3          	bge	a5,a4,80202888 <print_pagetable+0x1c>
}
    80202976:	0001                	nop
    80202978:	0001                	nop
    8020297a:	60a6                	ld	ra,72(sp)
    8020297c:	6406                	ld	s0,64(sp)
    8020297e:	6161                	addi	sp,sp,80
    80202980:	8082                	ret

0000000080202982 <handle_page_fault>:
int handle_page_fault(uint64 va, int type) {
    80202982:	715d                	addi	sp,sp,-80
    80202984:	e486                	sd	ra,72(sp)
    80202986:	e0a2                	sd	s0,64(sp)
    80202988:	0880                	addi	s0,sp,80
    8020298a:	faa43c23          	sd	a0,-72(s0)
    8020298e:	87ae                	mv	a5,a1
    80202990:	faf42a23          	sw	a5,-76(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    80202994:	fb442783          	lw	a5,-76(s0)
    80202998:	863e                	mv	a2,a5
    8020299a:	fb843583          	ld	a1,-72(s0)
    8020299e:	00006517          	auipc	a0,0x6
    802029a2:	1ea50513          	addi	a0,a0,490 # 80208b88 <simple_user_task_bin+0x3c8>
    802029a6:	ffffe097          	auipc	ra,0xffffe
    802029aa:	2ee080e7          	jalr	750(ra) # 80200c94 <printf>
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    802029ae:	fb843703          	ld	a4,-72(s0)
    802029b2:	77fd                	lui	a5,0xfffff
    802029b4:	8ff9                	and	a5,a5,a4
    802029b6:	fcf43c23          	sd	a5,-40(s0)
    if (page_va >= MAXVA) {
    802029ba:	fd843703          	ld	a4,-40(s0)
    802029be:	57fd                	li	a5,-1
    802029c0:	83e5                	srli	a5,a5,0x19
    802029c2:	00e7fc63          	bgeu	a5,a4,802029da <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    802029c6:	00006517          	auipc	a0,0x6
    802029ca:	1f250513          	addi	a0,a0,498 # 80208bb8 <simple_user_task_bin+0x3f8>
    802029ce:	ffffe097          	auipc	ra,0xffffe
    802029d2:	2c6080e7          	jalr	710(ra) # 80200c94 <printf>
        return 0;
    802029d6:	4781                	li	a5,0
    802029d8:	aae9                	j	80202bb2 <handle_page_fault+0x230>
    struct proc *p = myproc();
    802029da:	00002097          	auipc	ra,0x2
    802029de:	fa6080e7          	jalr	-90(ra) # 80204980 <myproc>
    802029e2:	fca43823          	sd	a0,-48(s0)
    pagetable_t pt = kernel_pagetable;
    802029e6:	0000b797          	auipc	a5,0xb
    802029ea:	6aa78793          	addi	a5,a5,1706 # 8020e090 <kernel_pagetable>
    802029ee:	639c                	ld	a5,0(a5)
    802029f0:	fef43423          	sd	a5,-24(s0)
    if (p && p->pagetable && p->is_user) {
    802029f4:	fd043783          	ld	a5,-48(s0)
    802029f8:	cf99                	beqz	a5,80202a16 <handle_page_fault+0x94>
    802029fa:	fd043783          	ld	a5,-48(s0)
    802029fe:	7fdc                	ld	a5,184(a5)
    80202a00:	cb99                	beqz	a5,80202a16 <handle_page_fault+0x94>
    80202a02:	fd043783          	ld	a5,-48(s0)
    80202a06:	0a87a783          	lw	a5,168(a5)
    80202a0a:	c791                	beqz	a5,80202a16 <handle_page_fault+0x94>
        pt = p->pagetable;
    80202a0c:	fd043783          	ld	a5,-48(s0)
    80202a10:	7fdc                	ld	a5,184(a5)
    80202a12:	fef43423          	sd	a5,-24(s0)
    pte_t *pte = walk_lookup(pt, page_va);
    80202a16:	fd843583          	ld	a1,-40(s0)
    80202a1a:	fe843503          	ld	a0,-24(s0)
    80202a1e:	fffff097          	auipc	ra,0xfffff
    80202a22:	698080e7          	jalr	1688(ra) # 802020b6 <walk_lookup>
    80202a26:	fca43423          	sd	a0,-56(s0)
    if (pte && (*pte & PTE_V)) {
    80202a2a:	fc843783          	ld	a5,-56(s0)
    80202a2e:	c3dd                	beqz	a5,80202ad4 <handle_page_fault+0x152>
    80202a30:	fc843783          	ld	a5,-56(s0)
    80202a34:	639c                	ld	a5,0(a5)
    80202a36:	8b85                	andi	a5,a5,1
    80202a38:	cfd1                	beqz	a5,80202ad4 <handle_page_fault+0x152>
        int need_perm = 0;
    80202a3a:	fe042223          	sw	zero,-28(s0)
        if (type == 1) need_perm = PTE_X;
    80202a3e:	fb442783          	lw	a5,-76(s0)
    80202a42:	0007871b          	sext.w	a4,a5
    80202a46:	4785                	li	a5,1
    80202a48:	00f71663          	bne	a4,a5,80202a54 <handle_page_fault+0xd2>
    80202a4c:	47a1                	li	a5,8
    80202a4e:	fef42223          	sw	a5,-28(s0)
    80202a52:	a035                	j	80202a7e <handle_page_fault+0xfc>
        else if (type == 2) need_perm = PTE_R;
    80202a54:	fb442783          	lw	a5,-76(s0)
    80202a58:	0007871b          	sext.w	a4,a5
    80202a5c:	4789                	li	a5,2
    80202a5e:	00f71663          	bne	a4,a5,80202a6a <handle_page_fault+0xe8>
    80202a62:	4789                	li	a5,2
    80202a64:	fef42223          	sw	a5,-28(s0)
    80202a68:	a819                	j	80202a7e <handle_page_fault+0xfc>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    80202a6a:	fb442783          	lw	a5,-76(s0)
    80202a6e:	0007871b          	sext.w	a4,a5
    80202a72:	478d                	li	a5,3
    80202a74:	00f71563          	bne	a4,a5,80202a7e <handle_page_fault+0xfc>
    80202a78:	4799                	li	a5,6
    80202a7a:	fef42223          	sw	a5,-28(s0)
        if ((*pte & need_perm) != need_perm) {
    80202a7e:	fc843783          	ld	a5,-56(s0)
    80202a82:	6398                	ld	a4,0(a5)
    80202a84:	fe442783          	lw	a5,-28(s0)
    80202a88:	8f7d                	and	a4,a4,a5
    80202a8a:	fe442783          	lw	a5,-28(s0)
    80202a8e:	02f70963          	beq	a4,a5,80202ac0 <handle_page_fault+0x13e>
            *pte |= need_perm;
    80202a92:	fc843783          	ld	a5,-56(s0)
    80202a96:	6398                	ld	a4,0(a5)
    80202a98:	fe442783          	lw	a5,-28(s0)
    80202a9c:	8f5d                	or	a4,a4,a5
    80202a9e:	fc843783          	ld	a5,-56(s0)
    80202aa2:	e398                	sd	a4,0(a5)
            sfence_vma();
    80202aa4:	00000097          	auipc	ra,0x0
    80202aa8:	d24080e7          	jalr	-732(ra) # 802027c8 <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    80202aac:	00006517          	auipc	a0,0x6
    80202ab0:	13450513          	addi	a0,a0,308 # 80208be0 <simple_user_task_bin+0x420>
    80202ab4:	ffffe097          	auipc	ra,0xffffe
    80202ab8:	1e0080e7          	jalr	480(ra) # 80200c94 <printf>
            return 1;
    80202abc:	4785                	li	a5,1
    80202abe:	a8d5                	j	80202bb2 <handle_page_fault+0x230>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80202ac0:	00006517          	auipc	a0,0x6
    80202ac4:	14850513          	addi	a0,a0,328 # 80208c08 <simple_user_task_bin+0x448>
    80202ac8:	ffffe097          	auipc	ra,0xffffe
    80202acc:	1cc080e7          	jalr	460(ra) # 80200c94 <printf>
        return 1;
    80202ad0:	4785                	li	a5,1
    80202ad2:	a0c5                	j	80202bb2 <handle_page_fault+0x230>
    void* page = alloc_page();
    80202ad4:	00000097          	auipc	ra,0x0
    80202ad8:	752080e7          	jalr	1874(ra) # 80203226 <alloc_page>
    80202adc:	fca43023          	sd	a0,-64(s0)
    if (page == 0) {
    80202ae0:	fc043783          	ld	a5,-64(s0)
    80202ae4:	eb99                	bnez	a5,80202afa <handle_page_fault+0x178>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    80202ae6:	00006517          	auipc	a0,0x6
    80202aea:	15250513          	addi	a0,a0,338 # 80208c38 <simple_user_task_bin+0x478>
    80202aee:	ffffe097          	auipc	ra,0xffffe
    80202af2:	1a6080e7          	jalr	422(ra) # 80200c94 <printf>
        return 0;
    80202af6:	4781                	li	a5,0
    80202af8:	a86d                	j	80202bb2 <handle_page_fault+0x230>
    memset(page, 0, PGSIZE);
    80202afa:	6605                	lui	a2,0x1
    80202afc:	4581                	li	a1,0
    80202afe:	fc043503          	ld	a0,-64(s0)
    80202b02:	fffff097          	auipc	ra,0xfffff
    80202b06:	31c080e7          	jalr	796(ra) # 80201e1e <memset>
    int perm = 0;
    80202b0a:	fe042023          	sw	zero,-32(s0)
    if (type == 1) perm = PTE_X | PTE_R | PTE_U;
    80202b0e:	fb442783          	lw	a5,-76(s0)
    80202b12:	0007871b          	sext.w	a4,a5
    80202b16:	4785                	li	a5,1
    80202b18:	00f71663          	bne	a4,a5,80202b24 <handle_page_fault+0x1a2>
    80202b1c:	47e9                	li	a5,26
    80202b1e:	fef42023          	sw	a5,-32(s0)
    80202b22:	a035                	j	80202b4e <handle_page_fault+0x1cc>
    else if (type == 2) perm = PTE_R | PTE_U;
    80202b24:	fb442783          	lw	a5,-76(s0)
    80202b28:	0007871b          	sext.w	a4,a5
    80202b2c:	4789                	li	a5,2
    80202b2e:	00f71663          	bne	a4,a5,80202b3a <handle_page_fault+0x1b8>
    80202b32:	47c9                	li	a5,18
    80202b34:	fef42023          	sw	a5,-32(s0)
    80202b38:	a819                	j	80202b4e <handle_page_fault+0x1cc>
    else if (type == 3) perm = PTE_R | PTE_W | PTE_U;
    80202b3a:	fb442783          	lw	a5,-76(s0)
    80202b3e:	0007871b          	sext.w	a4,a5
    80202b42:	478d                	li	a5,3
    80202b44:	00f71563          	bne	a4,a5,80202b4e <handle_page_fault+0x1cc>
    80202b48:	47d9                	li	a5,22
    80202b4a:	fef42023          	sw	a5,-32(s0)
    if (map_page(pt, page_va, (uint64)page, perm) != 0) {
    80202b4e:	fc043783          	ld	a5,-64(s0)
    80202b52:	fe042703          	lw	a4,-32(s0)
    80202b56:	86ba                	mv	a3,a4
    80202b58:	863e                	mv	a2,a5
    80202b5a:	fd843583          	ld	a1,-40(s0)
    80202b5e:	fe843503          	ld	a0,-24(s0)
    80202b62:	fffff097          	auipc	ra,0xfffff
    80202b66:	788080e7          	jalr	1928(ra) # 802022ea <map_page>
    80202b6a:	87aa                	mv	a5,a0
    80202b6c:	c38d                	beqz	a5,80202b8e <handle_page_fault+0x20c>
        free_page(page);
    80202b6e:	fc043503          	ld	a0,-64(s0)
    80202b72:	00000097          	auipc	ra,0x0
    80202b76:	720080e7          	jalr	1824(ra) # 80203292 <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    80202b7a:	00006517          	auipc	a0,0x6
    80202b7e:	0ee50513          	addi	a0,a0,238 # 80208c68 <simple_user_task_bin+0x4a8>
    80202b82:	ffffe097          	auipc	ra,0xffffe
    80202b86:	112080e7          	jalr	274(ra) # 80200c94 <printf>
        return 0;
    80202b8a:	4781                	li	a5,0
    80202b8c:	a01d                	j	80202bb2 <handle_page_fault+0x230>
    sfence_vma();
    80202b8e:	00000097          	auipc	ra,0x0
    80202b92:	c3a080e7          	jalr	-966(ra) # 802027c8 <sfence_vma>
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    80202b96:	fc043783          	ld	a5,-64(s0)
    80202b9a:	863e                	mv	a2,a5
    80202b9c:	fd843583          	ld	a1,-40(s0)
    80202ba0:	00006517          	auipc	a0,0x6
    80202ba4:	0f050513          	addi	a0,a0,240 # 80208c90 <simple_user_task_bin+0x4d0>
    80202ba8:	ffffe097          	auipc	ra,0xffffe
    80202bac:	0ec080e7          	jalr	236(ra) # 80200c94 <printf>
    return 1;
    80202bb0:	4785                	li	a5,1
}
    80202bb2:	853e                	mv	a0,a5
    80202bb4:	60a6                	ld	ra,72(sp)
    80202bb6:	6406                	ld	s0,64(sp)
    80202bb8:	6161                	addi	sp,sp,80
    80202bba:	8082                	ret

0000000080202bbc <test_pagetable>:
void test_pagetable(void) {
    80202bbc:	7155                	addi	sp,sp,-208
    80202bbe:	e586                	sd	ra,200(sp)
    80202bc0:	e1a2                	sd	s0,192(sp)
    80202bc2:	fd26                	sd	s1,184(sp)
    80202bc4:	f94a                	sd	s2,176(sp)
    80202bc6:	f54e                	sd	s3,168(sp)
    80202bc8:	f152                	sd	s4,160(sp)
    80202bca:	ed56                	sd	s5,152(sp)
    80202bcc:	e95a                	sd	s6,144(sp)
    80202bce:	e55e                	sd	s7,136(sp)
    80202bd0:	e162                	sd	s8,128(sp)
    80202bd2:	fce6                	sd	s9,120(sp)
    80202bd4:	0980                	addi	s0,sp,208
    80202bd6:	878a                	mv	a5,sp
    80202bd8:	84be                	mv	s1,a5
    printf("[PT TEST] 创建页表...\n");
    80202bda:	00006517          	auipc	a0,0x6
    80202bde:	0f650513          	addi	a0,a0,246 # 80208cd0 <simple_user_task_bin+0x510>
    80202be2:	ffffe097          	auipc	ra,0xffffe
    80202be6:	0b2080e7          	jalr	178(ra) # 80200c94 <printf>
    pagetable_t pt = create_pagetable();
    80202bea:	fffff097          	auipc	ra,0xfffff
    80202bee:	490080e7          	jalr	1168(ra) # 8020207a <create_pagetable>
    80202bf2:	f8a43423          	sd	a0,-120(s0)
    assert(pt != 0);
    80202bf6:	f8843783          	ld	a5,-120(s0)
    80202bfa:	00f037b3          	snez	a5,a5
    80202bfe:	0ff7f793          	zext.b	a5,a5
    80202c02:	2781                	sext.w	a5,a5
    80202c04:	853e                	mv	a0,a5
    80202c06:	fffff097          	auipc	ra,0xfffff
    80202c0a:	38a080e7          	jalr	906(ra) # 80201f90 <assert>
    printf("[PT TEST] 页表创建通过\n");
    80202c0e:	00006517          	auipc	a0,0x6
    80202c12:	0e250513          	addi	a0,a0,226 # 80208cf0 <simple_user_task_bin+0x530>
    80202c16:	ffffe097          	auipc	ra,0xffffe
    80202c1a:	07e080e7          	jalr	126(ra) # 80200c94 <printf>
    uint64 va[] = {
    80202c1e:	00006797          	auipc	a5,0x6
    80202c22:	29278793          	addi	a5,a5,658 # 80208eb0 <simple_user_task_bin+0x6f0>
    80202c26:	638c                	ld	a1,0(a5)
    80202c28:	6790                	ld	a2,8(a5)
    80202c2a:	6b94                	ld	a3,16(a5)
    80202c2c:	6f98                	ld	a4,24(a5)
    80202c2e:	739c                	ld	a5,32(a5)
    80202c30:	f2b43c23          	sd	a1,-200(s0)
    80202c34:	f4c43023          	sd	a2,-192(s0)
    80202c38:	f4d43423          	sd	a3,-184(s0)
    80202c3c:	f4e43823          	sd	a4,-176(s0)
    80202c40:	f4f43c23          	sd	a5,-168(s0)
    int n = sizeof(va) / sizeof(va[0]);
    80202c44:	4795                	li	a5,5
    80202c46:	f8f42223          	sw	a5,-124(s0)
    uint64 pa[n];
    80202c4a:	f8442783          	lw	a5,-124(s0)
    80202c4e:	873e                	mv	a4,a5
    80202c50:	177d                	addi	a4,a4,-1
    80202c52:	f6e43c23          	sd	a4,-136(s0)
    80202c56:	873e                	mv	a4,a5
    80202c58:	8c3a                	mv	s8,a4
    80202c5a:	4c81                	li	s9,0
    80202c5c:	03ac5713          	srli	a4,s8,0x3a
    80202c60:	006c9a93          	slli	s5,s9,0x6
    80202c64:	01576ab3          	or	s5,a4,s5
    80202c68:	006c1a13          	slli	s4,s8,0x6
    80202c6c:	873e                	mv	a4,a5
    80202c6e:	8b3a                	mv	s6,a4
    80202c70:	4b81                	li	s7,0
    80202c72:	03ab5713          	srli	a4,s6,0x3a
    80202c76:	006b9993          	slli	s3,s7,0x6
    80202c7a:	013769b3          	or	s3,a4,s3
    80202c7e:	006b1913          	slli	s2,s6,0x6
    80202c82:	078e                	slli	a5,a5,0x3
    80202c84:	07bd                	addi	a5,a5,15
    80202c86:	8391                	srli	a5,a5,0x4
    80202c88:	0792                	slli	a5,a5,0x4
    80202c8a:	40f10133          	sub	sp,sp,a5
    80202c8e:	878a                	mv	a5,sp
    80202c90:	079d                	addi	a5,a5,7
    80202c92:	838d                	srli	a5,a5,0x3
    80202c94:	078e                	slli	a5,a5,0x3
    80202c96:	f6f43823          	sd	a5,-144(s0)
    for (int i = 0; i < n; i++) {
    80202c9a:	f8042e23          	sw	zero,-100(s0)
    80202c9e:	a201                	j	80202d9e <test_pagetable+0x1e2>
        pa[i] = (uint64)alloc_page();
    80202ca0:	00000097          	auipc	ra,0x0
    80202ca4:	586080e7          	jalr	1414(ra) # 80203226 <alloc_page>
    80202ca8:	87aa                	mv	a5,a0
    80202caa:	86be                	mv	a3,a5
    80202cac:	f7043703          	ld	a4,-144(s0)
    80202cb0:	f9c42783          	lw	a5,-100(s0)
    80202cb4:	078e                	slli	a5,a5,0x3
    80202cb6:	97ba                	add	a5,a5,a4
    80202cb8:	e394                	sd	a3,0(a5)
        assert(pa[i]);
    80202cba:	f7043703          	ld	a4,-144(s0)
    80202cbe:	f9c42783          	lw	a5,-100(s0)
    80202cc2:	078e                	slli	a5,a5,0x3
    80202cc4:	97ba                	add	a5,a5,a4
    80202cc6:	639c                	ld	a5,0(a5)
    80202cc8:	2781                	sext.w	a5,a5
    80202cca:	853e                	mv	a0,a5
    80202ccc:	fffff097          	auipc	ra,0xfffff
    80202cd0:	2c4080e7          	jalr	708(ra) # 80201f90 <assert>
        printf("[PT TEST] 分配物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202cd4:	f7043703          	ld	a4,-144(s0)
    80202cd8:	f9c42783          	lw	a5,-100(s0)
    80202cdc:	078e                	slli	a5,a5,0x3
    80202cde:	97ba                	add	a5,a5,a4
    80202ce0:	6398                	ld	a4,0(a5)
    80202ce2:	f9c42783          	lw	a5,-100(s0)
    80202ce6:	863a                	mv	a2,a4
    80202ce8:	85be                	mv	a1,a5
    80202cea:	00006517          	auipc	a0,0x6
    80202cee:	02650513          	addi	a0,a0,38 # 80208d10 <simple_user_task_bin+0x550>
    80202cf2:	ffffe097          	auipc	ra,0xffffe
    80202cf6:	fa2080e7          	jalr	-94(ra) # 80200c94 <printf>
        int ret = map_page(pt, va[i], pa[i], PTE_R | PTE_W);
    80202cfa:	f9c42783          	lw	a5,-100(s0)
    80202cfe:	078e                	slli	a5,a5,0x3
    80202d00:	fa078793          	addi	a5,a5,-96
    80202d04:	97a2                	add	a5,a5,s0
    80202d06:	f987b583          	ld	a1,-104(a5)
    80202d0a:	f7043703          	ld	a4,-144(s0)
    80202d0e:	f9c42783          	lw	a5,-100(s0)
    80202d12:	078e                	slli	a5,a5,0x3
    80202d14:	97ba                	add	a5,a5,a4
    80202d16:	639c                	ld	a5,0(a5)
    80202d18:	4699                	li	a3,6
    80202d1a:	863e                	mv	a2,a5
    80202d1c:	f8843503          	ld	a0,-120(s0)
    80202d20:	fffff097          	auipc	ra,0xfffff
    80202d24:	5ca080e7          	jalr	1482(ra) # 802022ea <map_page>
    80202d28:	87aa                	mv	a5,a0
    80202d2a:	f6f42223          	sw	a5,-156(s0)
        printf("[PT TEST] 映射 va=0x%lx -> pa=0x%lx %s\n", va[i], pa[i], ret == 0 ? "成功" : "失败");
    80202d2e:	f9c42783          	lw	a5,-100(s0)
    80202d32:	078e                	slli	a5,a5,0x3
    80202d34:	fa078793          	addi	a5,a5,-96
    80202d38:	97a2                	add	a5,a5,s0
    80202d3a:	f987b583          	ld	a1,-104(a5)
    80202d3e:	f7043703          	ld	a4,-144(s0)
    80202d42:	f9c42783          	lw	a5,-100(s0)
    80202d46:	078e                	slli	a5,a5,0x3
    80202d48:	97ba                	add	a5,a5,a4
    80202d4a:	6398                	ld	a4,0(a5)
    80202d4c:	f6442783          	lw	a5,-156(s0)
    80202d50:	2781                	sext.w	a5,a5
    80202d52:	e791                	bnez	a5,80202d5e <test_pagetable+0x1a2>
    80202d54:	00006797          	auipc	a5,0x6
    80202d58:	fe478793          	addi	a5,a5,-28 # 80208d38 <simple_user_task_bin+0x578>
    80202d5c:	a029                	j	80202d66 <test_pagetable+0x1aa>
    80202d5e:	00006797          	auipc	a5,0x6
    80202d62:	fe278793          	addi	a5,a5,-30 # 80208d40 <simple_user_task_bin+0x580>
    80202d66:	86be                	mv	a3,a5
    80202d68:	863a                	mv	a2,a4
    80202d6a:	00006517          	auipc	a0,0x6
    80202d6e:	fde50513          	addi	a0,a0,-34 # 80208d48 <simple_user_task_bin+0x588>
    80202d72:	ffffe097          	auipc	ra,0xffffe
    80202d76:	f22080e7          	jalr	-222(ra) # 80200c94 <printf>
        assert(ret == 0);
    80202d7a:	f6442783          	lw	a5,-156(s0)
    80202d7e:	2781                	sext.w	a5,a5
    80202d80:	0017b793          	seqz	a5,a5
    80202d84:	0ff7f793          	zext.b	a5,a5
    80202d88:	2781                	sext.w	a5,a5
    80202d8a:	853e                	mv	a0,a5
    80202d8c:	fffff097          	auipc	ra,0xfffff
    80202d90:	204080e7          	jalr	516(ra) # 80201f90 <assert>
    for (int i = 0; i < n; i++) {
    80202d94:	f9c42783          	lw	a5,-100(s0)
    80202d98:	2785                	addiw	a5,a5,1
    80202d9a:	f8f42e23          	sw	a5,-100(s0)
    80202d9e:	f9c42783          	lw	a5,-100(s0)
    80202da2:	873e                	mv	a4,a5
    80202da4:	f8442783          	lw	a5,-124(s0)
    80202da8:	2701                	sext.w	a4,a4
    80202daa:	2781                	sext.w	a5,a5
    80202dac:	eef74ae3          	blt	a4,a5,80202ca0 <test_pagetable+0xe4>
    printf("[PT TEST] 多级映射测试通过\n");
    80202db0:	00006517          	auipc	a0,0x6
    80202db4:	fc850513          	addi	a0,a0,-56 # 80208d78 <simple_user_task_bin+0x5b8>
    80202db8:	ffffe097          	auipc	ra,0xffffe
    80202dbc:	edc080e7          	jalr	-292(ra) # 80200c94 <printf>
    for (int i = 0; i < n; i++) {
    80202dc0:	f8042c23          	sw	zero,-104(s0)
    80202dc4:	a861                	j	80202e5c <test_pagetable+0x2a0>
        pte_t *pte = walk_lookup(pt, va[i]);
    80202dc6:	f9842783          	lw	a5,-104(s0)
    80202dca:	078e                	slli	a5,a5,0x3
    80202dcc:	fa078793          	addi	a5,a5,-96
    80202dd0:	97a2                	add	a5,a5,s0
    80202dd2:	f987b783          	ld	a5,-104(a5)
    80202dd6:	85be                	mv	a1,a5
    80202dd8:	f8843503          	ld	a0,-120(s0)
    80202ddc:	fffff097          	auipc	ra,0xfffff
    80202de0:	2da080e7          	jalr	730(ra) # 802020b6 <walk_lookup>
    80202de4:	f6a43423          	sd	a0,-152(s0)
        if (pte && (*pte & PTE_V)) {
    80202de8:	f6843783          	ld	a5,-152(s0)
    80202dec:	c3b1                	beqz	a5,80202e30 <test_pagetable+0x274>
    80202dee:	f6843783          	ld	a5,-152(s0)
    80202df2:	639c                	ld	a5,0(a5)
    80202df4:	8b85                	andi	a5,a5,1
    80202df6:	cf8d                	beqz	a5,80202e30 <test_pagetable+0x274>
            printf("[PT TEST] 检查映射: va=0x%lx -> pa=0x%lx, pte=0x%lx\n", va[i], PTE2PA(*pte), *pte);
    80202df8:	f9842783          	lw	a5,-104(s0)
    80202dfc:	078e                	slli	a5,a5,0x3
    80202dfe:	fa078793          	addi	a5,a5,-96
    80202e02:	97a2                	add	a5,a5,s0
    80202e04:	f987b703          	ld	a4,-104(a5)
    80202e08:	f6843783          	ld	a5,-152(s0)
    80202e0c:	639c                	ld	a5,0(a5)
    80202e0e:	83a9                	srli	a5,a5,0xa
    80202e10:	00c79613          	slli	a2,a5,0xc
    80202e14:	f6843783          	ld	a5,-152(s0)
    80202e18:	639c                	ld	a5,0(a5)
    80202e1a:	86be                	mv	a3,a5
    80202e1c:	85ba                	mv	a1,a4
    80202e1e:	00006517          	auipc	a0,0x6
    80202e22:	f8250513          	addi	a0,a0,-126 # 80208da0 <simple_user_task_bin+0x5e0>
    80202e26:	ffffe097          	auipc	ra,0xffffe
    80202e2a:	e6e080e7          	jalr	-402(ra) # 80200c94 <printf>
    80202e2e:	a015                	j	80202e52 <test_pagetable+0x296>
            printf("[PT TEST] 检查映射: va=0x%lx 未映射\n", va[i]);
    80202e30:	f9842783          	lw	a5,-104(s0)
    80202e34:	078e                	slli	a5,a5,0x3
    80202e36:	fa078793          	addi	a5,a5,-96
    80202e3a:	97a2                	add	a5,a5,s0
    80202e3c:	f987b783          	ld	a5,-104(a5)
    80202e40:	85be                	mv	a1,a5
    80202e42:	00006517          	auipc	a0,0x6
    80202e46:	f9e50513          	addi	a0,a0,-98 # 80208de0 <simple_user_task_bin+0x620>
    80202e4a:	ffffe097          	auipc	ra,0xffffe
    80202e4e:	e4a080e7          	jalr	-438(ra) # 80200c94 <printf>
    for (int i = 0; i < n; i++) {
    80202e52:	f9842783          	lw	a5,-104(s0)
    80202e56:	2785                	addiw	a5,a5,1
    80202e58:	f8f42c23          	sw	a5,-104(s0)
    80202e5c:	f9842783          	lw	a5,-104(s0)
    80202e60:	873e                	mv	a4,a5
    80202e62:	f8442783          	lw	a5,-124(s0)
    80202e66:	2701                	sext.w	a4,a4
    80202e68:	2781                	sext.w	a5,a5
    80202e6a:	f4f74ee3          	blt	a4,a5,80202dc6 <test_pagetable+0x20a>
    printf("[PT TEST] 打印页表结构（递归）\n");
    80202e6e:	00006517          	auipc	a0,0x6
    80202e72:	fa250513          	addi	a0,a0,-94 # 80208e10 <simple_user_task_bin+0x650>
    80202e76:	ffffe097          	auipc	ra,0xffffe
    80202e7a:	e1e080e7          	jalr	-482(ra) # 80200c94 <printf>
    print_pagetable(pt, 0, 0);
    80202e7e:	4601                	li	a2,0
    80202e80:	4581                	li	a1,0
    80202e82:	f8843503          	ld	a0,-120(s0)
    80202e86:	00000097          	auipc	ra,0x0
    80202e8a:	9e6080e7          	jalr	-1562(ra) # 8020286c <print_pagetable>
    for (int i = 0; i < n; i++) {
    80202e8e:	f8042a23          	sw	zero,-108(s0)
    80202e92:	a0a9                	j	80202edc <test_pagetable+0x320>
        free_page((void*)pa[i]);
    80202e94:	f7043703          	ld	a4,-144(s0)
    80202e98:	f9442783          	lw	a5,-108(s0)
    80202e9c:	078e                	slli	a5,a5,0x3
    80202e9e:	97ba                	add	a5,a5,a4
    80202ea0:	639c                	ld	a5,0(a5)
    80202ea2:	853e                	mv	a0,a5
    80202ea4:	00000097          	auipc	ra,0x0
    80202ea8:	3ee080e7          	jalr	1006(ra) # 80203292 <free_page>
        printf("[PT TEST] 释放物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202eac:	f7043703          	ld	a4,-144(s0)
    80202eb0:	f9442783          	lw	a5,-108(s0)
    80202eb4:	078e                	slli	a5,a5,0x3
    80202eb6:	97ba                	add	a5,a5,a4
    80202eb8:	6398                	ld	a4,0(a5)
    80202eba:	f9442783          	lw	a5,-108(s0)
    80202ebe:	863a                	mv	a2,a4
    80202ec0:	85be                	mv	a1,a5
    80202ec2:	00006517          	auipc	a0,0x6
    80202ec6:	f7e50513          	addi	a0,a0,-130 # 80208e40 <simple_user_task_bin+0x680>
    80202eca:	ffffe097          	auipc	ra,0xffffe
    80202ece:	dca080e7          	jalr	-566(ra) # 80200c94 <printf>
    for (int i = 0; i < n; i++) {
    80202ed2:	f9442783          	lw	a5,-108(s0)
    80202ed6:	2785                	addiw	a5,a5,1
    80202ed8:	f8f42a23          	sw	a5,-108(s0)
    80202edc:	f9442783          	lw	a5,-108(s0)
    80202ee0:	873e                	mv	a4,a5
    80202ee2:	f8442783          	lw	a5,-124(s0)
    80202ee6:	2701                	sext.w	a4,a4
    80202ee8:	2781                	sext.w	a5,a5
    80202eea:	faf745e3          	blt	a4,a5,80202e94 <test_pagetable+0x2d8>
    free_pagetable(pt);
    80202eee:	f8843503          	ld	a0,-120(s0)
    80202ef2:	fffff097          	auipc	ra,0xfffff
    80202ef6:	56c080e7          	jalr	1388(ra) # 8020245e <free_pagetable>
    printf("[PT TEST] 释放页表完成\n");
    80202efa:	00006517          	auipc	a0,0x6
    80202efe:	f6e50513          	addi	a0,a0,-146 # 80208e68 <simple_user_task_bin+0x6a8>
    80202f02:	ffffe097          	auipc	ra,0xffffe
    80202f06:	d92080e7          	jalr	-622(ra) # 80200c94 <printf>
    printf("[PT TEST] 所有页表测试通过\n");
    80202f0a:	00006517          	auipc	a0,0x6
    80202f0e:	f7e50513          	addi	a0,a0,-130 # 80208e88 <simple_user_task_bin+0x6c8>
    80202f12:	ffffe097          	auipc	ra,0xffffe
    80202f16:	d82080e7          	jalr	-638(ra) # 80200c94 <printf>
    80202f1a:	8126                	mv	sp,s1
}
    80202f1c:	0001                	nop
    80202f1e:	f3040113          	addi	sp,s0,-208
    80202f22:	60ae                	ld	ra,200(sp)
    80202f24:	640e                	ld	s0,192(sp)
    80202f26:	74ea                	ld	s1,184(sp)
    80202f28:	794a                	ld	s2,176(sp)
    80202f2a:	79aa                	ld	s3,168(sp)
    80202f2c:	7a0a                	ld	s4,160(sp)
    80202f2e:	6aea                	ld	s5,152(sp)
    80202f30:	6b4a                	ld	s6,144(sp)
    80202f32:	6baa                	ld	s7,136(sp)
    80202f34:	6c0a                	ld	s8,128(sp)
    80202f36:	7ce6                	ld	s9,120(sp)
    80202f38:	6169                	addi	sp,sp,208
    80202f3a:	8082                	ret

0000000080202f3c <check_mapping>:
void check_mapping(uint64 va) {
    80202f3c:	7179                	addi	sp,sp,-48
    80202f3e:	f406                	sd	ra,40(sp)
    80202f40:	f022                	sd	s0,32(sp)
    80202f42:	1800                	addi	s0,sp,48
    80202f44:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    80202f48:	0000b797          	auipc	a5,0xb
    80202f4c:	14878793          	addi	a5,a5,328 # 8020e090 <kernel_pagetable>
    80202f50:	639c                	ld	a5,0(a5)
    80202f52:	fd843583          	ld	a1,-40(s0)
    80202f56:	853e                	mv	a0,a5
    80202f58:	fffff097          	auipc	ra,0xfffff
    80202f5c:	15e080e7          	jalr	350(ra) # 802020b6 <walk_lookup>
    80202f60:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    80202f64:	fe843783          	ld	a5,-24(s0)
    80202f68:	cbb9                	beqz	a5,80202fbe <check_mapping+0x82>
    80202f6a:	fe843783          	ld	a5,-24(s0)
    80202f6e:	639c                	ld	a5,0(a5)
    80202f70:	8b85                	andi	a5,a5,1
    80202f72:	c7b1                	beqz	a5,80202fbe <check_mapping+0x82>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80202f74:	fe843783          	ld	a5,-24(s0)
    80202f78:	639c                	ld	a5,0(a5)
    80202f7a:	863e                	mv	a2,a5
    80202f7c:	fd843583          	ld	a1,-40(s0)
    80202f80:	00006517          	auipc	a0,0x6
    80202f84:	f5850513          	addi	a0,a0,-168 # 80208ed8 <simple_user_task_bin+0x718>
    80202f88:	ffffe097          	auipc	ra,0xffffe
    80202f8c:	d0c080e7          	jalr	-756(ra) # 80200c94 <printf>
		volatile unsigned char *p = (unsigned char*)va;
    80202f90:	fd843783          	ld	a5,-40(s0)
    80202f94:	fef43023          	sd	a5,-32(s0)
        printf("Try to read [0x%lx]: 0x%02x\n", va, *p);
    80202f98:	fe043783          	ld	a5,-32(s0)
    80202f9c:	0007c783          	lbu	a5,0(a5)
    80202fa0:	0ff7f793          	zext.b	a5,a5
    80202fa4:	2781                	sext.w	a5,a5
    80202fa6:	863e                	mv	a2,a5
    80202fa8:	fd843583          	ld	a1,-40(s0)
    80202fac:	00006517          	auipc	a0,0x6
    80202fb0:	f5450513          	addi	a0,a0,-172 # 80208f00 <simple_user_task_bin+0x740>
    80202fb4:	ffffe097          	auipc	ra,0xffffe
    80202fb8:	ce0080e7          	jalr	-800(ra) # 80200c94 <printf>
    if(pte && (*pte & PTE_V)) {
    80202fbc:	a821                	j	80202fd4 <check_mapping+0x98>
        printf("Address 0x%lx is NOT mapped\n", va);
    80202fbe:	fd843583          	ld	a1,-40(s0)
    80202fc2:	00006517          	auipc	a0,0x6
    80202fc6:	f5e50513          	addi	a0,a0,-162 # 80208f20 <simple_user_task_bin+0x760>
    80202fca:	ffffe097          	auipc	ra,0xffffe
    80202fce:	cca080e7          	jalr	-822(ra) # 80200c94 <printf>
}
    80202fd2:	0001                	nop
    80202fd4:	0001                	nop
    80202fd6:	70a2                	ld	ra,40(sp)
    80202fd8:	7402                	ld	s0,32(sp)
    80202fda:	6145                	addi	sp,sp,48
    80202fdc:	8082                	ret

0000000080202fde <check_is_mapped>:
int check_is_mapped(uint64 va) {
    80202fde:	7179                	addi	sp,sp,-48
    80202fe0:	f406                	sd	ra,40(sp)
    80202fe2:	f022                	sd	s0,32(sp)
    80202fe4:	1800                	addi	s0,sp,48
    80202fe6:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    80202fea:	00000097          	auipc	ra,0x0
    80202fee:	86a080e7          	jalr	-1942(ra) # 80202854 <get_current_pagetable>
    80202ff2:	87aa                	mv	a5,a0
    80202ff4:	fd843583          	ld	a1,-40(s0)
    80202ff8:	853e                	mv	a0,a5
    80202ffa:	fffff097          	auipc	ra,0xfffff
    80202ffe:	0bc080e7          	jalr	188(ra) # 802020b6 <walk_lookup>
    80203002:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    80203006:	fe843783          	ld	a5,-24(s0)
    8020300a:	c795                	beqz	a5,80203036 <check_is_mapped+0x58>
    8020300c:	fe843783          	ld	a5,-24(s0)
    80203010:	639c                	ld	a5,0(a5)
    80203012:	8b85                	andi	a5,a5,1
    80203014:	c38d                	beqz	a5,80203036 <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80203016:	fe843783          	ld	a5,-24(s0)
    8020301a:	639c                	ld	a5,0(a5)
    8020301c:	863e                	mv	a2,a5
    8020301e:	fd843583          	ld	a1,-40(s0)
    80203022:	00006517          	auipc	a0,0x6
    80203026:	eb650513          	addi	a0,a0,-330 # 80208ed8 <simple_user_task_bin+0x718>
    8020302a:	ffffe097          	auipc	ra,0xffffe
    8020302e:	c6a080e7          	jalr	-918(ra) # 80200c94 <printf>
        return 1;
    80203032:	4785                	li	a5,1
    80203034:	a821                	j	8020304c <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    80203036:	fd843583          	ld	a1,-40(s0)
    8020303a:	00006517          	auipc	a0,0x6
    8020303e:	ee650513          	addi	a0,a0,-282 # 80208f20 <simple_user_task_bin+0x760>
    80203042:	ffffe097          	auipc	ra,0xffffe
    80203046:	c52080e7          	jalr	-942(ra) # 80200c94 <printf>
        return 0;
    8020304a:	4781                	li	a5,0
}
    8020304c:	853e                	mv	a0,a5
    8020304e:	70a2                	ld	ra,40(sp)
    80203050:	7402                	ld	s0,32(sp)
    80203052:	6145                	addi	sp,sp,48
    80203054:	8082                	ret

0000000080203056 <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80203056:	711d                	addi	sp,sp,-96
    80203058:	ec86                	sd	ra,88(sp)
    8020305a:	e8a2                	sd	s0,80(sp)
    8020305c:	1080                	addi	s0,sp,96
    8020305e:	faa43c23          	sd	a0,-72(s0)
    80203062:	fab43823          	sd	a1,-80(s0)
    80203066:	fac43423          	sd	a2,-88(s0)
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    8020306a:	fe043423          	sd	zero,-24(s0)
    8020306e:	a8d1                	j	80203142 <uvmcopy+0xec>
        pte_t *pte = walk_lookup(old, i);
    80203070:	fe843583          	ld	a1,-24(s0)
    80203074:	fb843503          	ld	a0,-72(s0)
    80203078:	fffff097          	auipc	ra,0xfffff
    8020307c:	03e080e7          	jalr	62(ra) # 802020b6 <walk_lookup>
    80203080:	fca43c23          	sd	a0,-40(s0)
        if (pte == 0 || (*pte & PTE_V) == 0)
    80203084:	fd843783          	ld	a5,-40(s0)
    80203088:	c7d5                	beqz	a5,80203134 <uvmcopy+0xde>
    8020308a:	fd843783          	ld	a5,-40(s0)
    8020308e:	639c                	ld	a5,0(a5)
    80203090:	8b85                	andi	a5,a5,1
    80203092:	c3cd                	beqz	a5,80203134 <uvmcopy+0xde>
        uint64 pa = PTE2PA(*pte);
    80203094:	fd843783          	ld	a5,-40(s0)
    80203098:	639c                	ld	a5,0(a5)
    8020309a:	83a9                	srli	a5,a5,0xa
    8020309c:	07b2                	slli	a5,a5,0xc
    8020309e:	fcf43823          	sd	a5,-48(s0)
        int flags = PTE_FLAGS(*pte);
    802030a2:	fd843783          	ld	a5,-40(s0)
    802030a6:	639c                	ld	a5,0(a5)
    802030a8:	2781                	sext.w	a5,a5
    802030aa:	3ff7f793          	andi	a5,a5,1023
    802030ae:	fef42223          	sw	a5,-28(s0)
		if (i < 0x80000000)
    802030b2:	fe843703          	ld	a4,-24(s0)
    802030b6:	800007b7          	lui	a5,0x80000
    802030ba:	fff7c793          	not	a5,a5
    802030be:	00e7e963          	bltu	a5,a4,802030d0 <uvmcopy+0x7a>
			flags |= PTE_U;
    802030c2:	fe442783          	lw	a5,-28(s0)
    802030c6:	0107e793          	ori	a5,a5,16
    802030ca:	fef42223          	sw	a5,-28(s0)
    802030ce:	a031                	j	802030da <uvmcopy+0x84>
			flags &= ~PTE_U;
    802030d0:	fe442783          	lw	a5,-28(s0)
    802030d4:	9bbd                	andi	a5,a5,-17
    802030d6:	fef42223          	sw	a5,-28(s0)
        void *mem = alloc_page();
    802030da:	00000097          	auipc	ra,0x0
    802030de:	14c080e7          	jalr	332(ra) # 80203226 <alloc_page>
    802030e2:	fca43423          	sd	a0,-56(s0)
        if (mem == 0)
    802030e6:	fc843783          	ld	a5,-56(s0)
    802030ea:	e399                	bnez	a5,802030f0 <uvmcopy+0x9a>
            return -1; // 分配失败
    802030ec:	57fd                	li	a5,-1
    802030ee:	a08d                	j	80203150 <uvmcopy+0xfa>
        memmove(mem, (void*)pa, PGSIZE);
    802030f0:	fd043783          	ld	a5,-48(s0)
    802030f4:	6605                	lui	a2,0x1
    802030f6:	85be                	mv	a1,a5
    802030f8:	fc843503          	ld	a0,-56(s0)
    802030fc:	fffff097          	auipc	ra,0xfffff
    80203100:	d72080e7          	jalr	-654(ra) # 80201e6e <memmove>
        if (map_page(new, i, (uint64)mem, flags) != 0) {
    80203104:	fc843783          	ld	a5,-56(s0)
    80203108:	fe442703          	lw	a4,-28(s0)
    8020310c:	86ba                	mv	a3,a4
    8020310e:	863e                	mv	a2,a5
    80203110:	fe843583          	ld	a1,-24(s0)
    80203114:	fb043503          	ld	a0,-80(s0)
    80203118:	fffff097          	auipc	ra,0xfffff
    8020311c:	1d2080e7          	jalr	466(ra) # 802022ea <map_page>
    80203120:	87aa                	mv	a5,a0
    80203122:	cb91                	beqz	a5,80203136 <uvmcopy+0xe0>
            free_page(mem);
    80203124:	fc843503          	ld	a0,-56(s0)
    80203128:	00000097          	auipc	ra,0x0
    8020312c:	16a080e7          	jalr	362(ra) # 80203292 <free_page>
            return -1;
    80203130:	57fd                	li	a5,-1
    80203132:	a839                	j	80203150 <uvmcopy+0xfa>
            continue; // 跳过未分配的页
    80203134:	0001                	nop
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    80203136:	fe843703          	ld	a4,-24(s0)
    8020313a:	6785                	lui	a5,0x1
    8020313c:	97ba                	add	a5,a5,a4
    8020313e:	fef43423          	sd	a5,-24(s0)
    80203142:	fe843703          	ld	a4,-24(s0)
    80203146:	fa843783          	ld	a5,-88(s0)
    8020314a:	f2f763e3          	bltu	a4,a5,80203070 <uvmcopy+0x1a>
    return 0;
    8020314e:	4781                	li	a5,0
    80203150:	853e                	mv	a0,a5
    80203152:	60e6                	ld	ra,88(sp)
    80203154:	6446                	ld	s0,80(sp)
    80203156:	6125                	addi	sp,sp,96
    80203158:	8082                	ret

000000008020315a <assert>:
    8020315a:	1101                	addi	sp,sp,-32
    8020315c:	ec06                	sd	ra,24(sp)
    8020315e:	e822                	sd	s0,16(sp)
    80203160:	1000                	addi	s0,sp,32
    80203162:	87aa                	mv	a5,a0
    80203164:	fef42623          	sw	a5,-20(s0)
    80203168:	fec42783          	lw	a5,-20(s0)
    8020316c:	2781                	sext.w	a5,a5
    8020316e:	e79d                	bnez	a5,8020319c <assert+0x42>
    80203170:	19c00613          	li	a2,412
    80203174:	00006597          	auipc	a1,0x6
    80203178:	01c58593          	addi	a1,a1,28 # 80209190 <simple_user_task_bin+0x58>
    8020317c:	00006517          	auipc	a0,0x6
    80203180:	02450513          	addi	a0,a0,36 # 802091a0 <simple_user_task_bin+0x68>
    80203184:	ffffe097          	auipc	ra,0xffffe
    80203188:	b10080e7          	jalr	-1264(ra) # 80200c94 <printf>
    8020318c:	00006517          	auipc	a0,0x6
    80203190:	03c50513          	addi	a0,a0,60 # 802091c8 <simple_user_task_bin+0x90>
    80203194:	ffffe097          	auipc	ra,0xffffe
    80203198:	54c080e7          	jalr	1356(ra) # 802016e0 <panic>
    8020319c:	0001                	nop
    8020319e:	60e2                	ld	ra,24(sp)
    802031a0:	6442                	ld	s0,16(sp)
    802031a2:	6105                	addi	sp,sp,32
    802031a4:	8082                	ret

00000000802031a6 <freerange>:
static void freerange(void *pa_start, void *pa_end) {
    802031a6:	7179                	addi	sp,sp,-48
    802031a8:	f406                	sd	ra,40(sp)
    802031aa:	f022                	sd	s0,32(sp)
    802031ac:	1800                	addi	s0,sp,48
    802031ae:	fca43c23          	sd	a0,-40(s0)
    802031b2:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    802031b6:	fd843703          	ld	a4,-40(s0)
    802031ba:	6785                	lui	a5,0x1
    802031bc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802031be:	973e                	add	a4,a4,a5
    802031c0:	77fd                	lui	a5,0xfffff
    802031c2:	8ff9                	and	a5,a5,a4
    802031c4:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802031c8:	a829                	j	802031e2 <freerange+0x3c>
    free_page(p);
    802031ca:	fe843503          	ld	a0,-24(s0)
    802031ce:	00000097          	auipc	ra,0x0
    802031d2:	0c4080e7          	jalr	196(ra) # 80203292 <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    802031d6:	fe843703          	ld	a4,-24(s0)
    802031da:	6785                	lui	a5,0x1
    802031dc:	97ba                	add	a5,a5,a4
    802031de:	fef43423          	sd	a5,-24(s0)
    802031e2:	fe843703          	ld	a4,-24(s0)
    802031e6:	6785                	lui	a5,0x1
    802031e8:	97ba                	add	a5,a5,a4
    802031ea:	fd043703          	ld	a4,-48(s0)
    802031ee:	fcf77ee3          	bgeu	a4,a5,802031ca <freerange+0x24>
}
    802031f2:	0001                	nop
    802031f4:	0001                	nop
    802031f6:	70a2                	ld	ra,40(sp)
    802031f8:	7402                	ld	s0,32(sp)
    802031fa:	6145                	addi	sp,sp,48
    802031fc:	8082                	ret

00000000802031fe <pmm_init>:
void pmm_init(void) {
    802031fe:	1141                	addi	sp,sp,-16
    80203200:	e406                	sd	ra,8(sp)
    80203202:	e022                	sd	s0,0(sp)
    80203204:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    80203206:	47c5                	li	a5,17
    80203208:	01b79593          	slli	a1,a5,0x1b
    8020320c:	0000b517          	auipc	a0,0xb
    80203210:	4f450513          	addi	a0,a0,1268 # 8020e700 <_bss_end>
    80203214:	00000097          	auipc	ra,0x0
    80203218:	f92080e7          	jalr	-110(ra) # 802031a6 <freerange>
}
    8020321c:	0001                	nop
    8020321e:	60a2                	ld	ra,8(sp)
    80203220:	6402                	ld	s0,0(sp)
    80203222:	0141                	addi	sp,sp,16
    80203224:	8082                	ret

0000000080203226 <alloc_page>:
void* alloc_page(void) {
    80203226:	1101                	addi	sp,sp,-32
    80203228:	ec06                	sd	ra,24(sp)
    8020322a:	e822                	sd	s0,16(sp)
    8020322c:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    8020322e:	0000b797          	auipc	a5,0xb
    80203232:	03278793          	addi	a5,a5,50 # 8020e260 <freelist>
    80203236:	639c                	ld	a5,0(a5)
    80203238:	fef43423          	sd	a5,-24(s0)
  if(r)
    8020323c:	fe843783          	ld	a5,-24(s0)
    80203240:	cb89                	beqz	a5,80203252 <alloc_page+0x2c>
    freelist = r->next;
    80203242:	fe843783          	ld	a5,-24(s0)
    80203246:	6398                	ld	a4,0(a5)
    80203248:	0000b797          	auipc	a5,0xb
    8020324c:	01878793          	addi	a5,a5,24 # 8020e260 <freelist>
    80203250:	e398                	sd	a4,0(a5)
  if(r)
    80203252:	fe843783          	ld	a5,-24(s0)
    80203256:	cf99                	beqz	a5,80203274 <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    80203258:	fe843783          	ld	a5,-24(s0)
    8020325c:	00878713          	addi	a4,a5,8
    80203260:	6785                	lui	a5,0x1
    80203262:	ff878613          	addi	a2,a5,-8 # ff8 <_entry-0x801ff008>
    80203266:	4595                	li	a1,5
    80203268:	853a                	mv	a0,a4
    8020326a:	fffff097          	auipc	ra,0xfffff
    8020326e:	bb4080e7          	jalr	-1100(ra) # 80201e1e <memset>
    80203272:	a809                	j	80203284 <alloc_page+0x5e>
    panic("alloc_page: out of memory");
    80203274:	00006517          	auipc	a0,0x6
    80203278:	f5c50513          	addi	a0,a0,-164 # 802091d0 <simple_user_task_bin+0x98>
    8020327c:	ffffe097          	auipc	ra,0xffffe
    80203280:	464080e7          	jalr	1124(ra) # 802016e0 <panic>
  return (void*)r;
    80203284:	fe843783          	ld	a5,-24(s0)
}
    80203288:	853e                	mv	a0,a5
    8020328a:	60e2                	ld	ra,24(sp)
    8020328c:	6442                	ld	s0,16(sp)
    8020328e:	6105                	addi	sp,sp,32
    80203290:	8082                	ret

0000000080203292 <free_page>:
void free_page(void* page) {
    80203292:	7179                	addi	sp,sp,-48
    80203294:	f406                	sd	ra,40(sp)
    80203296:	f022                	sd	s0,32(sp)
    80203298:	1800                	addi	s0,sp,48
    8020329a:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    8020329e:	fd843783          	ld	a5,-40(s0)
    802032a2:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    802032a6:	fd843703          	ld	a4,-40(s0)
    802032aa:	6785                	lui	a5,0x1
    802032ac:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802032ae:	8ff9                	and	a5,a5,a4
    802032b0:	ef99                	bnez	a5,802032ce <free_page+0x3c>
    802032b2:	fd843703          	ld	a4,-40(s0)
    802032b6:	0000b797          	auipc	a5,0xb
    802032ba:	44a78793          	addi	a5,a5,1098 # 8020e700 <_bss_end>
    802032be:	00f76863          	bltu	a4,a5,802032ce <free_page+0x3c>
    802032c2:	fd843703          	ld	a4,-40(s0)
    802032c6:	47c5                	li	a5,17
    802032c8:	07ee                	slli	a5,a5,0x1b
    802032ca:	00f76a63          	bltu	a4,a5,802032de <free_page+0x4c>
    panic("free_page: invalid page address");
    802032ce:	00006517          	auipc	a0,0x6
    802032d2:	f2250513          	addi	a0,a0,-222 # 802091f0 <simple_user_task_bin+0xb8>
    802032d6:	ffffe097          	auipc	ra,0xffffe
    802032da:	40a080e7          	jalr	1034(ra) # 802016e0 <panic>
  r->next = freelist;
    802032de:	0000b797          	auipc	a5,0xb
    802032e2:	f8278793          	addi	a5,a5,-126 # 8020e260 <freelist>
    802032e6:	6398                	ld	a4,0(a5)
    802032e8:	fe843783          	ld	a5,-24(s0)
    802032ec:	e398                	sd	a4,0(a5)
  freelist = r;
    802032ee:	0000b797          	auipc	a5,0xb
    802032f2:	f7278793          	addi	a5,a5,-142 # 8020e260 <freelist>
    802032f6:	fe843703          	ld	a4,-24(s0)
    802032fa:	e398                	sd	a4,0(a5)
}
    802032fc:	0001                	nop
    802032fe:	70a2                	ld	ra,40(sp)
    80203300:	7402                	ld	s0,32(sp)
    80203302:	6145                	addi	sp,sp,48
    80203304:	8082                	ret

0000000080203306 <test_physical_memory>:
void test_physical_memory(void) {
    80203306:	7179                	addi	sp,sp,-48
    80203308:	f406                	sd	ra,40(sp)
    8020330a:	f022                	sd	s0,32(sp)
    8020330c:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    8020330e:	00006517          	auipc	a0,0x6
    80203312:	f0250513          	addi	a0,a0,-254 # 80209210 <simple_user_task_bin+0xd8>
    80203316:	ffffe097          	auipc	ra,0xffffe
    8020331a:	97e080e7          	jalr	-1666(ra) # 80200c94 <printf>
    void *page1 = alloc_page();
    8020331e:	00000097          	auipc	ra,0x0
    80203322:	f08080e7          	jalr	-248(ra) # 80203226 <alloc_page>
    80203326:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    8020332a:	00000097          	auipc	ra,0x0
    8020332e:	efc080e7          	jalr	-260(ra) # 80203226 <alloc_page>
    80203332:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    80203336:	fe843783          	ld	a5,-24(s0)
    8020333a:	00f037b3          	snez	a5,a5
    8020333e:	0ff7f793          	zext.b	a5,a5
    80203342:	2781                	sext.w	a5,a5
    80203344:	853e                	mv	a0,a5
    80203346:	00000097          	auipc	ra,0x0
    8020334a:	e14080e7          	jalr	-492(ra) # 8020315a <assert>
    assert(page2 != 0);
    8020334e:	fe043783          	ld	a5,-32(s0)
    80203352:	00f037b3          	snez	a5,a5
    80203356:	0ff7f793          	zext.b	a5,a5
    8020335a:	2781                	sext.w	a5,a5
    8020335c:	853e                	mv	a0,a5
    8020335e:	00000097          	auipc	ra,0x0
    80203362:	dfc080e7          	jalr	-516(ra) # 8020315a <assert>
    assert(page1 != page2);
    80203366:	fe843703          	ld	a4,-24(s0)
    8020336a:	fe043783          	ld	a5,-32(s0)
    8020336e:	40f707b3          	sub	a5,a4,a5
    80203372:	00f037b3          	snez	a5,a5
    80203376:	0ff7f793          	zext.b	a5,a5
    8020337a:	2781                	sext.w	a5,a5
    8020337c:	853e                	mv	a0,a5
    8020337e:	00000097          	auipc	ra,0x0
    80203382:	ddc080e7          	jalr	-548(ra) # 8020315a <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    80203386:	fe843703          	ld	a4,-24(s0)
    8020338a:	6785                	lui	a5,0x1
    8020338c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    8020338e:	8ff9                	and	a5,a5,a4
    80203390:	0017b793          	seqz	a5,a5
    80203394:	0ff7f793          	zext.b	a5,a5
    80203398:	2781                	sext.w	a5,a5
    8020339a:	853e                	mv	a0,a5
    8020339c:	00000097          	auipc	ra,0x0
    802033a0:	dbe080e7          	jalr	-578(ra) # 8020315a <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    802033a4:	fe043703          	ld	a4,-32(s0)
    802033a8:	6785                	lui	a5,0x1
    802033aa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802033ac:	8ff9                	and	a5,a5,a4
    802033ae:	0017b793          	seqz	a5,a5
    802033b2:	0ff7f793          	zext.b	a5,a5
    802033b6:	2781                	sext.w	a5,a5
    802033b8:	853e                	mv	a0,a5
    802033ba:	00000097          	auipc	ra,0x0
    802033be:	da0080e7          	jalr	-608(ra) # 8020315a <assert>
    printf("[PM TEST] 分配测试通过\n");
    802033c2:	00006517          	auipc	a0,0x6
    802033c6:	e6e50513          	addi	a0,a0,-402 # 80209230 <simple_user_task_bin+0xf8>
    802033ca:	ffffe097          	auipc	ra,0xffffe
    802033ce:	8ca080e7          	jalr	-1846(ra) # 80200c94 <printf>
    printf("[PM TEST] 数据写入测试...\n");
    802033d2:	00006517          	auipc	a0,0x6
    802033d6:	e7e50513          	addi	a0,a0,-386 # 80209250 <simple_user_task_bin+0x118>
    802033da:	ffffe097          	auipc	ra,0xffffe
    802033de:	8ba080e7          	jalr	-1862(ra) # 80200c94 <printf>
    *(int*)page1 = 0x12345678;
    802033e2:	fe843783          	ld	a5,-24(s0)
    802033e6:	12345737          	lui	a4,0x12345
    802033ea:	67870713          	addi	a4,a4,1656 # 12345678 <_entry-0x6deba988>
    802033ee:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    802033f0:	fe843783          	ld	a5,-24(s0)
    802033f4:	439c                	lw	a5,0(a5)
    802033f6:	873e                	mv	a4,a5
    802033f8:	123457b7          	lui	a5,0x12345
    802033fc:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6deba988>
    80203400:	40f707b3          	sub	a5,a4,a5
    80203404:	0017b793          	seqz	a5,a5
    80203408:	0ff7f793          	zext.b	a5,a5
    8020340c:	2781                	sext.w	a5,a5
    8020340e:	853e                	mv	a0,a5
    80203410:	00000097          	auipc	ra,0x0
    80203414:	d4a080e7          	jalr	-694(ra) # 8020315a <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    80203418:	00006517          	auipc	a0,0x6
    8020341c:	e6050513          	addi	a0,a0,-416 # 80209278 <simple_user_task_bin+0x140>
    80203420:	ffffe097          	auipc	ra,0xffffe
    80203424:	874080e7          	jalr	-1932(ra) # 80200c94 <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    80203428:	00006517          	auipc	a0,0x6
    8020342c:	e7850513          	addi	a0,a0,-392 # 802092a0 <simple_user_task_bin+0x168>
    80203430:	ffffe097          	auipc	ra,0xffffe
    80203434:	864080e7          	jalr	-1948(ra) # 80200c94 <printf>
    free_page(page1);
    80203438:	fe843503          	ld	a0,-24(s0)
    8020343c:	00000097          	auipc	ra,0x0
    80203440:	e56080e7          	jalr	-426(ra) # 80203292 <free_page>
    void *page3 = alloc_page();
    80203444:	00000097          	auipc	ra,0x0
    80203448:	de2080e7          	jalr	-542(ra) # 80203226 <alloc_page>
    8020344c:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    80203450:	fd843783          	ld	a5,-40(s0)
    80203454:	00f037b3          	snez	a5,a5
    80203458:	0ff7f793          	zext.b	a5,a5
    8020345c:	2781                	sext.w	a5,a5
    8020345e:	853e                	mv	a0,a5
    80203460:	00000097          	auipc	ra,0x0
    80203464:	cfa080e7          	jalr	-774(ra) # 8020315a <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    80203468:	00006517          	auipc	a0,0x6
    8020346c:	e6850513          	addi	a0,a0,-408 # 802092d0 <simple_user_task_bin+0x198>
    80203470:	ffffe097          	auipc	ra,0xffffe
    80203474:	824080e7          	jalr	-2012(ra) # 80200c94 <printf>
    free_page(page2);
    80203478:	fe043503          	ld	a0,-32(s0)
    8020347c:	00000097          	auipc	ra,0x0
    80203480:	e16080e7          	jalr	-490(ra) # 80203292 <free_page>
    free_page(page3);
    80203484:	fd843503          	ld	a0,-40(s0)
    80203488:	00000097          	auipc	ra,0x0
    8020348c:	e0a080e7          	jalr	-502(ra) # 80203292 <free_page>
    printf("[PM TEST] 所有物理内存管理测试通过\n");
    80203490:	00006517          	auipc	a0,0x6
    80203494:	e7050513          	addi	a0,a0,-400 # 80209300 <simple_user_task_bin+0x1c8>
    80203498:	ffffd097          	auipc	ra,0xffffd
    8020349c:	7fc080e7          	jalr	2044(ra) # 80200c94 <printf>
    802034a0:	0001                	nop
    802034a2:	70a2                	ld	ra,40(sp)
    802034a4:	7402                	ld	s0,32(sp)
    802034a6:	6145                	addi	sp,sp,48
    802034a8:	8082                	ret

00000000802034aa <sbi_set_time>:
#include "defs.h"

void sbi_set_time(uint64 time) {
    802034aa:	1101                	addi	sp,sp,-32
    802034ac:	ec22                	sd	s0,24(sp)
    802034ae:	1000                	addi	s0,sp,32
    802034b0:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    802034b4:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    802034b8:	4881                	li	a7,0
    asm volatile ("ecall"
    802034ba:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    802034be:	0001                	nop
    802034c0:	6462                	ld	s0,24(sp)
    802034c2:	6105                	addi	sp,sp,32
    802034c4:	8082                	ret

00000000802034c6 <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    802034c6:	1101                	addi	sp,sp,-32
    802034c8:	ec22                	sd	s0,24(sp)
    802034ca:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    802034cc:	c01027f3          	rdtime	a5
    802034d0:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    802034d4:	fe843783          	ld	a5,-24(s0)
    802034d8:	853e                	mv	a0,a5
    802034da:	6462                	ld	s0,24(sp)
    802034dc:	6105                	addi	sp,sp,32
    802034de:	8082                	ret

00000000802034e0 <timeintr>:
#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    802034e0:	1141                	addi	sp,sp,-16
    802034e2:	e422                	sd	s0,8(sp)
    802034e4:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    802034e6:	0000b797          	auipc	a5,0xb
    802034ea:	bd278793          	addi	a5,a5,-1070 # 8020e0b8 <interrupt_test_flag>
    802034ee:	639c                	ld	a5,0(a5)
    802034f0:	cb99                	beqz	a5,80203506 <timeintr+0x26>
        (*interrupt_test_flag)++;
    802034f2:	0000b797          	auipc	a5,0xb
    802034f6:	bc678793          	addi	a5,a5,-1082 # 8020e0b8 <interrupt_test_flag>
    802034fa:	639c                	ld	a5,0(a5)
    802034fc:	4398                	lw	a4,0(a5)
    802034fe:	2701                	sext.w	a4,a4
    80203500:	2705                	addiw	a4,a4,1
    80203502:	2701                	sext.w	a4,a4
    80203504:	c398                	sw	a4,0(a5)
    80203506:	0001                	nop
    80203508:	6422                	ld	s0,8(sp)
    8020350a:	0141                	addi	sp,sp,16
    8020350c:	8082                	ret

000000008020350e <r_sie>:
    struct trapframe *tf = p->trapframe;

    uint64 scause = r_scause();
    uint64 stval  = r_stval();
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存
    8020350e:	1101                	addi	sp,sp,-32
    80203510:	ec22                	sd	s0,24(sp)
    80203512:	1000                	addi	s0,sp,32

    uint64 code = scause & 0xff;
    80203514:	104027f3          	csrr	a5,sie
    80203518:	fef43423          	sd	a5,-24(s0)
    uint64 is_intr = (scause >> 63);
    8020351c:	fe843783          	ld	a5,-24(s0)

    80203520:	853e                	mv	a0,a5
    80203522:	6462                	ld	s0,24(sp)
    80203524:	6105                	addi	sp,sp,32
    80203526:	8082                	ret

0000000080203528 <w_sie>:
    if (!is_intr && code == 8) { // 用户态 ecall
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80203528:	1101                	addi	sp,sp,-32
    8020352a:	ec22                	sd	s0,24(sp)
    8020352c:	1000                	addi	s0,sp,32
    8020352e:	fea43423          	sd	a0,-24(s0)
        handle_syscall(tf, &info);
    80203532:	fe843783          	ld	a5,-24(s0)
    80203536:	10479073          	csrw	sie,a5
        // handle_syscall 应该已 set_sepc(tf, sepc+4)
    8020353a:	0001                	nop
    8020353c:	6462                	ld	s0,24(sp)
    8020353e:	6105                	addi	sp,sp,32
    80203540:	8082                	ret

0000000080203542 <r_sstatus>:
    } else if (is_intr) {
        if (code == 5) {
    80203542:	1101                	addi	sp,sp,-32
    80203544:	ec22                	sd	s0,24(sp)
    80203546:	1000                	addi	s0,sp,32
            timeintr();
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80203548:	100027f3          	csrr	a5,sstatus
    8020354c:	fef43423          	sd	a5,-24(s0)
        } else if (code == 9) {
    80203550:	fe843783          	ld	a5,-24(s0)
            handle_external_interrupt();
    80203554:	853e                	mv	a0,a5
    80203556:	6462                	ld	s0,24(sp)
    80203558:	6105                	addi	sp,sp,32
    8020355a:	8082                	ret

000000008020355c <w_sstatus>:
        } else {
    8020355c:	1101                	addi	sp,sp,-32
    8020355e:	ec22                	sd	s0,24(sp)
    80203560:	1000                	addi	s0,sp,32
    80203562:	fea43423          	sd	a0,-24(s0)
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    80203566:	fe843783          	ld	a5,-24(s0)
    8020356a:	10079073          	csrw	sstatus,a5
        }
    8020356e:	0001                	nop
    80203570:	6462                	ld	s0,24(sp)
    80203572:	6105                	addi	sp,sp,32
    80203574:	8082                	ret

0000000080203576 <w_sscratch>:
    } else {
    80203576:	1101                	addi	sp,sp,-32
    80203578:	ec22                	sd	s0,24(sp)
    8020357a:	1000                	addi	s0,sp,32
    8020357c:	fea43423          	sd	a0,-24(s0)
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80203580:	fe843783          	ld	a5,-24(s0)
    80203584:	14079073          	csrw	sscratch,a5
        handle_exception(tf, &info);
    80203588:	0001                	nop
    8020358a:	6462                	ld	s0,24(sp)
    8020358c:	6105                	addi	sp,sp,32
    8020358e:	8082                	ret

0000000080203590 <w_sepc>:
    }

    80203590:	1101                	addi	sp,sp,-32
    80203592:	ec22                	sd	s0,24(sp)
    80203594:	1000                	addi	s0,sp,32
    80203596:	fea43423          	sd	a0,-24(s0)
    usertrapret();
    8020359a:	fe843783          	ld	a5,-24(s0)
    8020359e:	14179073          	csrw	sepc,a5
}
    802035a2:	0001                	nop
    802035a4:	6462                	ld	s0,24(sp)
    802035a6:	6105                	addi	sp,sp,32
    802035a8:	8082                	ret

00000000802035aa <intr_off>:

void usertrapret(void) {
    struct proc *p = myproc();

    // 计算 trampoline 中 uservec 的虚拟地址（对双方页表一致）
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    802035aa:	1141                	addi	sp,sp,-16
    802035ac:	e406                	sd	ra,8(sp)
    802035ae:	e022                	sd	s0,0(sp)
    802035b0:	0800                	addi	s0,sp,16
    w_stvec(uservec_va);
    802035b2:	00000097          	auipc	ra,0x0
    802035b6:	f90080e7          	jalr	-112(ra) # 80203542 <r_sstatus>
    802035ba:	87aa                	mv	a5,a0
    802035bc:	9bf5                	andi	a5,a5,-3
    802035be:	853e                	mv	a0,a5
    802035c0:	00000097          	auipc	ra,0x0
    802035c4:	f9c080e7          	jalr	-100(ra) # 8020355c <w_sstatus>

    802035c8:	0001                	nop
    802035ca:	60a2                	ld	ra,8(sp)
    802035cc:	6402                	ld	s0,0(sp)
    802035ce:	0141                	addi	sp,sp,16
    802035d0:	8082                	ret

00000000802035d2 <w_stvec>:
    // sscratch 设为 TRAPFRAME 的虚拟地址（trampoline 代码用它访问 tf）
    w_sscratch((uint64)TRAPFRAME);
    802035d2:	1101                	addi	sp,sp,-32
    802035d4:	ec22                	sd	s0,24(sp)
    802035d6:	1000                	addi	s0,sp,32
    802035d8:	fea43423          	sd	a0,-24(s0)

    802035dc:	fe843783          	ld	a5,-24(s0)
    802035e0:	10579073          	csrw	stvec,a5
    // 准备用户页表的 satp
    802035e4:	0001                	nop
    802035e6:	6462                	ld	s0,24(sp)
    802035e8:	6105                	addi	sp,sp,32
    802035ea:	8082                	ret

00000000802035ec <r_scause>:
    // 计算 trampoline 中 userret 的虚拟地址
    uint64 userret_va = (uint64)TRAMPOLINE + ((uint64)userret - (uint64)trampoline);

    // a0 = TRAPFRAME（虚拟地址，双方页表都映射）
    // a1 = user_satp
    register uint64 a0 asm("a0") = (uint64)TRAPFRAME;
    802035ec:	1101                	addi	sp,sp,-32
    802035ee:	ec22                	sd	s0,24(sp)
    802035f0:	1000                	addi	s0,sp,32
    register uint64 a1 asm("a1") = user_satp;
    register void (*tgt)(uint64, uint64) asm("t0") = (void *)userret_va;
    802035f2:	142027f3          	csrr	a5,scause
    802035f6:	fef43423          	sd	a5,-24(s0)

    802035fa:	fe843783          	ld	a5,-24(s0)
    // 跳到 trampoline 上的 userret
    802035fe:	853e                	mv	a0,a5
    80203600:	6462                	ld	s0,24(sp)
    80203602:	6105                	addi	sp,sp,32
    80203604:	8082                	ret

0000000080203606 <r_sepc>:
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(tgt) : "memory");
}
    80203606:	1101                	addi	sp,sp,-32
    80203608:	ec22                	sd	s0,24(sp)
    8020360a:	1000                	addi	s0,sp,32
    8020360c:	141027f3          	csrr	a5,sepc
    80203610:	fef43423          	sd	a5,-24(s0)
    80203614:	fe843783          	ld	a5,-24(s0)
    80203618:	853e                	mv	a0,a5
    8020361a:	6462                	ld	s0,24(sp)
    8020361c:	6105                	addi	sp,sp,32
    8020361e:	8082                	ret

0000000080203620 <r_stval>:
    80203620:	1101                	addi	sp,sp,-32
    80203622:	ec22                	sd	s0,24(sp)
    80203624:	1000                	addi	s0,sp,32
    80203626:	143027f3          	csrr	a5,stval
    8020362a:	fef43423          	sd	a5,-24(s0)
    8020362e:	fe843783          	ld	a5,-24(s0)
    80203632:	853e                	mv	a0,a5
    80203634:	6462                	ld	s0,24(sp)
    80203636:	6105                	addi	sp,sp,32
    80203638:	8082                	ret

000000008020363a <save_exception_info>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    8020363a:	7139                	addi	sp,sp,-64
    8020363c:	fc22                	sd	s0,56(sp)
    8020363e:	0080                	addi	s0,sp,64
    80203640:	fea43423          	sd	a0,-24(s0)
    80203644:	feb43023          	sd	a1,-32(s0)
    80203648:	fcc43c23          	sd	a2,-40(s0)
    8020364c:	fcd43823          	sd	a3,-48(s0)
    80203650:	fce43423          	sd	a4,-56(s0)
    tf->epc = sepc;
    80203654:	fe843783          	ld	a5,-24(s0)
    80203658:	fe043703          	ld	a4,-32(s0)
    8020365c:	f398                	sd	a4,32(a5)
}
    8020365e:	0001                	nop
    80203660:	7462                	ld	s0,56(sp)
    80203662:	6121                	addi	sp,sp,64
    80203664:	8082                	ret

0000000080203666 <get_sepc>:
static inline uint64 get_sepc(struct trapframe *tf) {
    80203666:	1101                	addi	sp,sp,-32
    80203668:	ec22                	sd	s0,24(sp)
    8020366a:	1000                	addi	s0,sp,32
    8020366c:	fea43423          	sd	a0,-24(s0)
    return tf->epc;
    80203670:	fe843783          	ld	a5,-24(s0)
    80203674:	739c                	ld	a5,32(a5)
}
    80203676:	853e                	mv	a0,a5
    80203678:	6462                	ld	s0,24(sp)
    8020367a:	6105                	addi	sp,sp,32
    8020367c:	8082                	ret

000000008020367e <set_sepc>:
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    8020367e:	1101                	addi	sp,sp,-32
    80203680:	ec22                	sd	s0,24(sp)
    80203682:	1000                	addi	s0,sp,32
    80203684:	fea43423          	sd	a0,-24(s0)
    80203688:	feb43023          	sd	a1,-32(s0)
    tf->epc = sepc;
    8020368c:	fe843783          	ld	a5,-24(s0)
    80203690:	fe043703          	ld	a4,-32(s0)
    80203694:	f398                	sd	a4,32(a5)
}
    80203696:	0001                	nop
    80203698:	6462                	ld	s0,24(sp)
    8020369a:	6105                	addi	sp,sp,32
    8020369c:	8082                	ret

000000008020369e <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    8020369e:	1101                	addi	sp,sp,-32
    802036a0:	ec22                	sd	s0,24(sp)
    802036a2:	1000                	addi	s0,sp,32
    802036a4:	87aa                	mv	a5,a0
    802036a6:	feb43023          	sd	a1,-32(s0)
    802036aa:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    802036ae:	fec42783          	lw	a5,-20(s0)
    802036b2:	2781                	sext.w	a5,a5
    802036b4:	0207c563          	bltz	a5,802036de <register_interrupt+0x40>
    802036b8:	fec42783          	lw	a5,-20(s0)
    802036bc:	0007871b          	sext.w	a4,a5
    802036c0:	03f00793          	li	a5,63
    802036c4:	00e7cd63          	blt	a5,a4,802036de <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    802036c8:	0000b717          	auipc	a4,0xb
    802036cc:	ba070713          	addi	a4,a4,-1120 # 8020e268 <interrupt_vector>
    802036d0:	fec42783          	lw	a5,-20(s0)
    802036d4:	078e                	slli	a5,a5,0x3
    802036d6:	97ba                	add	a5,a5,a4
    802036d8:	fe043703          	ld	a4,-32(s0)
    802036dc:	e398                	sd	a4,0(a5)
}
    802036de:	0001                	nop
    802036e0:	6462                	ld	s0,24(sp)
    802036e2:	6105                	addi	sp,sp,32
    802036e4:	8082                	ret

00000000802036e6 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    802036e6:	1101                	addi	sp,sp,-32
    802036e8:	ec22                	sd	s0,24(sp)
    802036ea:	1000                	addi	s0,sp,32
    802036ec:	87aa                	mv	a5,a0
    802036ee:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    802036f2:	fec42783          	lw	a5,-20(s0)
    802036f6:	2781                	sext.w	a5,a5
    802036f8:	0207c463          	bltz	a5,80203720 <unregister_interrupt+0x3a>
    802036fc:	fec42783          	lw	a5,-20(s0)
    80203700:	0007871b          	sext.w	a4,a5
    80203704:	03f00793          	li	a5,63
    80203708:	00e7cc63          	blt	a5,a4,80203720 <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    8020370c:	0000b717          	auipc	a4,0xb
    80203710:	b5c70713          	addi	a4,a4,-1188 # 8020e268 <interrupt_vector>
    80203714:	fec42783          	lw	a5,-20(s0)
    80203718:	078e                	slli	a5,a5,0x3
    8020371a:	97ba                	add	a5,a5,a4
    8020371c:	0007b023          	sd	zero,0(a5)
}
    80203720:	0001                	nop
    80203722:	6462                	ld	s0,24(sp)
    80203724:	6105                	addi	sp,sp,32
    80203726:	8082                	ret

0000000080203728 <enable_interrupts>:
void enable_interrupts(int irq) {
    80203728:	1101                	addi	sp,sp,-32
    8020372a:	ec06                	sd	ra,24(sp)
    8020372c:	e822                	sd	s0,16(sp)
    8020372e:	1000                	addi	s0,sp,32
    80203730:	87aa                	mv	a5,a0
    80203732:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    80203736:	fec42783          	lw	a5,-20(s0)
    8020373a:	853e                	mv	a0,a5
    8020373c:	00001097          	auipc	ra,0x1
    80203740:	dfe080e7          	jalr	-514(ra) # 8020453a <plic_enable>
}
    80203744:	0001                	nop
    80203746:	60e2                	ld	ra,24(sp)
    80203748:	6442                	ld	s0,16(sp)
    8020374a:	6105                	addi	sp,sp,32
    8020374c:	8082                	ret

000000008020374e <disable_interrupts>:
void disable_interrupts(int irq) {
    8020374e:	1101                	addi	sp,sp,-32
    80203750:	ec06                	sd	ra,24(sp)
    80203752:	e822                	sd	s0,16(sp)
    80203754:	1000                	addi	s0,sp,32
    80203756:	87aa                	mv	a5,a0
    80203758:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    8020375c:	fec42783          	lw	a5,-20(s0)
    80203760:	853e                	mv	a0,a5
    80203762:	00001097          	auipc	ra,0x1
    80203766:	e30080e7          	jalr	-464(ra) # 80204592 <plic_disable>
}
    8020376a:	0001                	nop
    8020376c:	60e2                	ld	ra,24(sp)
    8020376e:	6442                	ld	s0,16(sp)
    80203770:	6105                	addi	sp,sp,32
    80203772:	8082                	ret

0000000080203774 <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    80203774:	1101                	addi	sp,sp,-32
    80203776:	ec06                	sd	ra,24(sp)
    80203778:	e822                	sd	s0,16(sp)
    8020377a:	1000                	addi	s0,sp,32
    8020377c:	87aa                	mv	a5,a0
    8020377e:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    80203782:	fec42783          	lw	a5,-20(s0)
    80203786:	2781                	sext.w	a5,a5
    80203788:	0207ce63          	bltz	a5,802037c4 <interrupt_dispatch+0x50>
    8020378c:	fec42783          	lw	a5,-20(s0)
    80203790:	0007871b          	sext.w	a4,a5
    80203794:	03f00793          	li	a5,63
    80203798:	02e7c663          	blt	a5,a4,802037c4 <interrupt_dispatch+0x50>
    8020379c:	0000b717          	auipc	a4,0xb
    802037a0:	acc70713          	addi	a4,a4,-1332 # 8020e268 <interrupt_vector>
    802037a4:	fec42783          	lw	a5,-20(s0)
    802037a8:	078e                	slli	a5,a5,0x3
    802037aa:	97ba                	add	a5,a5,a4
    802037ac:	639c                	ld	a5,0(a5)
    802037ae:	cb99                	beqz	a5,802037c4 <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    802037b0:	0000b717          	auipc	a4,0xb
    802037b4:	ab870713          	addi	a4,a4,-1352 # 8020e268 <interrupt_vector>
    802037b8:	fec42783          	lw	a5,-20(s0)
    802037bc:	078e                	slli	a5,a5,0x3
    802037be:	97ba                	add	a5,a5,a4
    802037c0:	639c                	ld	a5,0(a5)
    802037c2:	9782                	jalr	a5
}
    802037c4:	0001                	nop
    802037c6:	60e2                	ld	ra,24(sp)
    802037c8:	6442                	ld	s0,16(sp)
    802037ca:	6105                	addi	sp,sp,32
    802037cc:	8082                	ret

00000000802037ce <handle_external_interrupt>:
void handle_external_interrupt(void) {
    802037ce:	1101                	addi	sp,sp,-32
    802037d0:	ec06                	sd	ra,24(sp)
    802037d2:	e822                	sd	s0,16(sp)
    802037d4:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    802037d6:	00001097          	auipc	ra,0x1
    802037da:	e1a080e7          	jalr	-486(ra) # 802045f0 <plic_claim>
    802037de:	87aa                	mv	a5,a0
    802037e0:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    802037e4:	fec42783          	lw	a5,-20(s0)
    802037e8:	2781                	sext.w	a5,a5
    802037ea:	eb91                	bnez	a5,802037fe <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    802037ec:	00006517          	auipc	a0,0x6
    802037f0:	23450513          	addi	a0,a0,564 # 80209a20 <simple_user_task_bin+0x58>
    802037f4:	ffffd097          	auipc	ra,0xffffd
    802037f8:	4a0080e7          	jalr	1184(ra) # 80200c94 <printf>
        return;
    802037fc:	a839                	j	8020381a <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    802037fe:	fec42783          	lw	a5,-20(s0)
    80203802:	853e                	mv	a0,a5
    80203804:	00000097          	auipc	ra,0x0
    80203808:	f70080e7          	jalr	-144(ra) # 80203774 <interrupt_dispatch>
    plic_complete(irq);
    8020380c:	fec42783          	lw	a5,-20(s0)
    80203810:	853e                	mv	a0,a5
    80203812:	00001097          	auipc	ra,0x1
    80203816:	e06080e7          	jalr	-506(ra) # 80204618 <plic_complete>
}
    8020381a:	60e2                	ld	ra,24(sp)
    8020381c:	6442                	ld	s0,16(sp)
    8020381e:	6105                	addi	sp,sp,32
    80203820:	8082                	ret

0000000080203822 <trap_init>:
void trap_init(void) {
    80203822:	1101                	addi	sp,sp,-32
    80203824:	ec06                	sd	ra,24(sp)
    80203826:	e822                	sd	s0,16(sp)
    80203828:	1000                	addi	s0,sp,32
	intr_off();
    8020382a:	00000097          	auipc	ra,0x0
    8020382e:	d80080e7          	jalr	-640(ra) # 802035aa <intr_off>
	printf("trap_init...\n");
    80203832:	00006517          	auipc	a0,0x6
    80203836:	20e50513          	addi	a0,a0,526 # 80209a40 <simple_user_task_bin+0x78>
    8020383a:	ffffd097          	auipc	ra,0xffffd
    8020383e:	45a080e7          	jalr	1114(ra) # 80200c94 <printf>
	w_stvec((uint64)kernelvec);
    80203842:	00001797          	auipc	a5,0x1
    80203846:	e0e78793          	addi	a5,a5,-498 # 80204650 <kernelvec>
    8020384a:	853e                	mv	a0,a5
    8020384c:	00000097          	auipc	ra,0x0
    80203850:	d86080e7          	jalr	-634(ra) # 802035d2 <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    80203854:	fe042623          	sw	zero,-20(s0)
    80203858:	a005                	j	80203878 <trap_init+0x56>
		interrupt_vector[i] = 0;
    8020385a:	0000b717          	auipc	a4,0xb
    8020385e:	a0e70713          	addi	a4,a4,-1522 # 8020e268 <interrupt_vector>
    80203862:	fec42783          	lw	a5,-20(s0)
    80203866:	078e                	slli	a5,a5,0x3
    80203868:	97ba                	add	a5,a5,a4
    8020386a:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    8020386e:	fec42783          	lw	a5,-20(s0)
    80203872:	2785                	addiw	a5,a5,1
    80203874:	fef42623          	sw	a5,-20(s0)
    80203878:	fec42783          	lw	a5,-20(s0)
    8020387c:	0007871b          	sext.w	a4,a5
    80203880:	03f00793          	li	a5,63
    80203884:	fce7dbe3          	bge	a5,a4,8020385a <trap_init+0x38>
	plic_init();
    80203888:	00001097          	auipc	ra,0x1
    8020388c:	c14080e7          	jalr	-1004(ra) # 8020449c <plic_init>
    uint64 sie = r_sie();
    80203890:	00000097          	auipc	ra,0x0
    80203894:	c7e080e7          	jalr	-898(ra) # 8020350e <r_sie>
    80203898:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    8020389c:	fe043783          	ld	a5,-32(s0)
    802038a0:	2207e793          	ori	a5,a5,544
    802038a4:	853e                	mv	a0,a5
    802038a6:	00000097          	auipc	ra,0x0
    802038aa:	c82080e7          	jalr	-894(ra) # 80203528 <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802038ae:	00000097          	auipc	ra,0x0
    802038b2:	c18080e7          	jalr	-1000(ra) # 802034c6 <sbi_get_time>
    802038b6:	872a                	mv	a4,a0
    802038b8:	000f47b7          	lui	a5,0xf4
    802038bc:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802038c0:	97ba                	add	a5,a5,a4
    802038c2:	853e                	mv	a0,a5
    802038c4:	00000097          	auipc	ra,0x0
    802038c8:	be6080e7          	jalr	-1050(ra) # 802034aa <sbi_set_time>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    802038cc:	00001597          	auipc	a1,0x1
    802038d0:	90058593          	addi	a1,a1,-1792 # 802041cc <handle_store_page_fault>
    802038d4:	00006517          	auipc	a0,0x6
    802038d8:	17c50513          	addi	a0,a0,380 # 80209a50 <simple_user_task_bin+0x88>
    802038dc:	ffffd097          	auipc	ra,0xffffd
    802038e0:	3b8080e7          	jalr	952(ra) # 80200c94 <printf>
	printf("trap_init complete.\n");
    802038e4:	00006517          	auipc	a0,0x6
    802038e8:	1a450513          	addi	a0,a0,420 # 80209a88 <simple_user_task_bin+0xc0>
    802038ec:	ffffd097          	auipc	ra,0xffffd
    802038f0:	3a8080e7          	jalr	936(ra) # 80200c94 <printf>
}
    802038f4:	0001                	nop
    802038f6:	60e2                	ld	ra,24(sp)
    802038f8:	6442                	ld	s0,16(sp)
    802038fa:	6105                	addi	sp,sp,32
    802038fc:	8082                	ret

00000000802038fe <kerneltrap>:
void kerneltrap(void) {
    802038fe:	7149                	addi	sp,sp,-368
    80203900:	f686                	sd	ra,360(sp)
    80203902:	f2a2                	sd	s0,352(sp)
    80203904:	1a80                	addi	s0,sp,368
    uint64 sstatus = r_sstatus();
    80203906:	00000097          	auipc	ra,0x0
    8020390a:	c3c080e7          	jalr	-964(ra) # 80203542 <r_sstatus>
    8020390e:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    80203912:	00000097          	auipc	ra,0x0
    80203916:	cda080e7          	jalr	-806(ra) # 802035ec <r_scause>
    8020391a:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    8020391e:	00000097          	auipc	ra,0x0
    80203922:	ce8080e7          	jalr	-792(ra) # 80203606 <r_sepc>
    80203926:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    8020392a:	00000097          	auipc	ra,0x0
    8020392e:	cf6080e7          	jalr	-778(ra) # 80203620 <r_stval>
    80203932:	fca43823          	sd	a0,-48(s0)
    if(scause & 0x8000000000000000) {
    80203936:	fd843783          	ld	a5,-40(s0)
    8020393a:	0607d663          	bgez	a5,802039a6 <kerneltrap+0xa8>
        if((scause & 0xff) == 5) {
    8020393e:	fd843783          	ld	a5,-40(s0)
    80203942:	0ff7f713          	zext.b	a4,a5
    80203946:	4795                	li	a5,5
    80203948:	02f71663          	bne	a4,a5,80203974 <kerneltrap+0x76>
            timeintr();
    8020394c:	00000097          	auipc	ra,0x0
    80203950:	b94080e7          	jalr	-1132(ra) # 802034e0 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80203954:	00000097          	auipc	ra,0x0
    80203958:	b72080e7          	jalr	-1166(ra) # 802034c6 <sbi_get_time>
    8020395c:	872a                	mv	a4,a0
    8020395e:	000f47b7          	lui	a5,0xf4
    80203962:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    80203966:	97ba                	add	a5,a5,a4
    80203968:	853e                	mv	a0,a5
    8020396a:	00000097          	auipc	ra,0x0
    8020396e:	b40080e7          	jalr	-1216(ra) # 802034aa <sbi_set_time>
    80203972:	a855                	j	80203a26 <kerneltrap+0x128>
        } else if((scause & 0xff) == 9) {
    80203974:	fd843783          	ld	a5,-40(s0)
    80203978:	0ff7f713          	zext.b	a4,a5
    8020397c:	47a5                	li	a5,9
    8020397e:	00f71763          	bne	a4,a5,8020398c <kerneltrap+0x8e>
            handle_external_interrupt();
    80203982:	00000097          	auipc	ra,0x0
    80203986:	e4c080e7          	jalr	-436(ra) # 802037ce <handle_external_interrupt>
    8020398a:	a871                	j	80203a26 <kerneltrap+0x128>
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    8020398c:	fe843603          	ld	a2,-24(s0)
    80203990:	fd843583          	ld	a1,-40(s0)
    80203994:	00006517          	auipc	a0,0x6
    80203998:	10c50513          	addi	a0,a0,268 # 80209aa0 <simple_user_task_bin+0xd8>
    8020399c:	ffffd097          	auipc	ra,0xffffd
    802039a0:	2f8080e7          	jalr	760(ra) # 80200c94 <printf>
    802039a4:	a049                	j	80203a26 <kerneltrap+0x128>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    802039a6:	fd043683          	ld	a3,-48(s0)
    802039aa:	fe843603          	ld	a2,-24(s0)
    802039ae:	fd843583          	ld	a1,-40(s0)
    802039b2:	00006517          	auipc	a0,0x6
    802039b6:	12650513          	addi	a0,a0,294 # 80209ad8 <simple_user_task_bin+0x110>
    802039ba:	ffffd097          	auipc	ra,0xffffd
    802039be:	2da080e7          	jalr	730(ra) # 80200c94 <printf>
        save_exception_info(&tf, sepc, sstatus, scause, stval);
    802039c2:	eb840793          	addi	a5,s0,-328
    802039c6:	fd043703          	ld	a4,-48(s0)
    802039ca:	fd843683          	ld	a3,-40(s0)
    802039ce:	fe043603          	ld	a2,-32(s0)
    802039d2:	fe843583          	ld	a1,-24(s0)
    802039d6:	853e                	mv	a0,a5
    802039d8:	00000097          	auipc	ra,0x0
    802039dc:	c62080e7          	jalr	-926(ra) # 8020363a <save_exception_info>
        info.sepc = sepc;
    802039e0:	fe843783          	ld	a5,-24(s0)
    802039e4:	e8f43c23          	sd	a5,-360(s0)
        info.sstatus = sstatus;
    802039e8:	fe043783          	ld	a5,-32(s0)
    802039ec:	eaf43023          	sd	a5,-352(s0)
        info.scause = scause;
    802039f0:	fd843783          	ld	a5,-40(s0)
    802039f4:	eaf43423          	sd	a5,-344(s0)
        info.stval = stval;
    802039f8:	fd043783          	ld	a5,-48(s0)
    802039fc:	eaf43823          	sd	a5,-336(s0)
        handle_exception(&tf, &info);
    80203a00:	e9840713          	addi	a4,s0,-360
    80203a04:	eb840793          	addi	a5,s0,-328
    80203a08:	85ba                	mv	a1,a4
    80203a0a:	853e                	mv	a0,a5
    80203a0c:	00000097          	auipc	ra,0x0
    80203a10:	03c080e7          	jalr	60(ra) # 80203a48 <handle_exception>
        sepc = get_sepc(&tf);
    80203a14:	eb840793          	addi	a5,s0,-328
    80203a18:	853e                	mv	a0,a5
    80203a1a:	00000097          	auipc	ra,0x0
    80203a1e:	c4c080e7          	jalr	-948(ra) # 80203666 <get_sepc>
    80203a22:	fea43423          	sd	a0,-24(s0)
    w_sepc(sepc);
    80203a26:	fe843503          	ld	a0,-24(s0)
    80203a2a:	00000097          	auipc	ra,0x0
    80203a2e:	b66080e7          	jalr	-1178(ra) # 80203590 <w_sepc>
    w_sstatus(sstatus);
    80203a32:	fe043503          	ld	a0,-32(s0)
    80203a36:	00000097          	auipc	ra,0x0
    80203a3a:	b26080e7          	jalr	-1242(ra) # 8020355c <w_sstatus>
}
    80203a3e:	0001                	nop
    80203a40:	70b6                	ld	ra,360(sp)
    80203a42:	7416                	ld	s0,352(sp)
    80203a44:	6175                	addi	sp,sp,368
    80203a46:	8082                	ret

0000000080203a48 <handle_exception>:
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    80203a48:	7179                	addi	sp,sp,-48
    80203a4a:	f406                	sd	ra,40(sp)
    80203a4c:	f022                	sd	s0,32(sp)
    80203a4e:	1800                	addi	s0,sp,48
    80203a50:	fca43c23          	sd	a0,-40(s0)
    80203a54:	fcb43823          	sd	a1,-48(s0)
    uint64 cause = info->scause;  // 使用info中的字段
    80203a58:	fd043783          	ld	a5,-48(s0)
    80203a5c:	6b9c                	ld	a5,16(a5)
    80203a5e:	fef43423          	sd	a5,-24(s0)
    switch (cause) {
    80203a62:	fe843703          	ld	a4,-24(s0)
    80203a66:	47bd                	li	a5,15
    80203a68:	26e7ef63          	bltu	a5,a4,80203ce6 <handle_exception+0x29e>
    80203a6c:	fe843783          	ld	a5,-24(s0)
    80203a70:	00279713          	slli	a4,a5,0x2
    80203a74:	00006797          	auipc	a5,0x6
    80203a78:	22078793          	addi	a5,a5,544 # 80209c94 <simple_user_task_bin+0x2cc>
    80203a7c:	97ba                	add	a5,a5,a4
    80203a7e:	439c                	lw	a5,0(a5)
    80203a80:	0007871b          	sext.w	a4,a5
    80203a84:	00006797          	auipc	a5,0x6
    80203a88:	21078793          	addi	a5,a5,528 # 80209c94 <simple_user_task_bin+0x2cc>
    80203a8c:	97ba                	add	a5,a5,a4
    80203a8e:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80203a90:	fd043783          	ld	a5,-48(s0)
    80203a94:	6f9c                	ld	a5,24(a5)
    80203a96:	85be                	mv	a1,a5
    80203a98:	00006517          	auipc	a0,0x6
    80203a9c:	07050513          	addi	a0,a0,112 # 80209b08 <simple_user_task_bin+0x140>
    80203aa0:	ffffd097          	auipc	ra,0xffffd
    80203aa4:	1f4080e7          	jalr	500(ra) # 80200c94 <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203aa8:	fd043783          	ld	a5,-48(s0)
    80203aac:	639c                	ld	a5,0(a5)
    80203aae:	0791                	addi	a5,a5,4
    80203ab0:	85be                	mv	a1,a5
    80203ab2:	fd843503          	ld	a0,-40(s0)
    80203ab6:	00000097          	auipc	ra,0x0
    80203aba:	bc8080e7          	jalr	-1080(ra) # 8020367e <set_sepc>
            break;
    80203abe:	a495                	j	80203d22 <handle_exception+0x2da>
            printf("Instruction access fault: 0x%lx\n", info->stval);
    80203ac0:	fd043783          	ld	a5,-48(s0)
    80203ac4:	6f9c                	ld	a5,24(a5)
    80203ac6:	85be                	mv	a1,a5
    80203ac8:	00006517          	auipc	a0,0x6
    80203acc:	06850513          	addi	a0,a0,104 # 80209b30 <simple_user_task_bin+0x168>
    80203ad0:	ffffd097          	auipc	ra,0xffffd
    80203ad4:	1c4080e7          	jalr	452(ra) # 80200c94 <printf>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203ad8:	fd043783          	ld	a5,-48(s0)
    80203adc:	639c                	ld	a5,0(a5)
    80203ade:	0791                	addi	a5,a5,4
    80203ae0:	85be                	mv	a1,a5
    80203ae2:	fd843503          	ld	a0,-40(s0)
    80203ae6:	00000097          	auipc	ra,0x0
    80203aea:	b98080e7          	jalr	-1128(ra) # 8020367e <set_sepc>
            break;
    80203aee:	ac15                	j	80203d22 <handle_exception+0x2da>
            printf("Illegal instruction at 0x%lx: 0x%lx\n", info->sepc, info->stval);
    80203af0:	fd043783          	ld	a5,-48(s0)
    80203af4:	6398                	ld	a4,0(a5)
    80203af6:	fd043783          	ld	a5,-48(s0)
    80203afa:	6f9c                	ld	a5,24(a5)
    80203afc:	863e                	mv	a2,a5
    80203afe:	85ba                	mv	a1,a4
    80203b00:	00006517          	auipc	a0,0x6
    80203b04:	05850513          	addi	a0,a0,88 # 80209b58 <simple_user_task_bin+0x190>
    80203b08:	ffffd097          	auipc	ra,0xffffd
    80203b0c:	18c080e7          	jalr	396(ra) # 80200c94 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203b10:	fd043783          	ld	a5,-48(s0)
    80203b14:	639c                	ld	a5,0(a5)
    80203b16:	0791                	addi	a5,a5,4
    80203b18:	85be                	mv	a1,a5
    80203b1a:	fd843503          	ld	a0,-40(s0)
    80203b1e:	00000097          	auipc	ra,0x0
    80203b22:	b60080e7          	jalr	-1184(ra) # 8020367e <set_sepc>
            break;
    80203b26:	aaf5                	j	80203d22 <handle_exception+0x2da>
            printf("Breakpoint at 0x%lx\n", info->sepc);
    80203b28:	fd043783          	ld	a5,-48(s0)
    80203b2c:	639c                	ld	a5,0(a5)
    80203b2e:	85be                	mv	a1,a5
    80203b30:	00006517          	auipc	a0,0x6
    80203b34:	05050513          	addi	a0,a0,80 # 80209b80 <simple_user_task_bin+0x1b8>
    80203b38:	ffffd097          	auipc	ra,0xffffd
    80203b3c:	15c080e7          	jalr	348(ra) # 80200c94 <printf>
            set_sepc(tf, info->sepc + 4);
    80203b40:	fd043783          	ld	a5,-48(s0)
    80203b44:	639c                	ld	a5,0(a5)
    80203b46:	0791                	addi	a5,a5,4
    80203b48:	85be                	mv	a1,a5
    80203b4a:	fd843503          	ld	a0,-40(s0)
    80203b4e:	00000097          	auipc	ra,0x0
    80203b52:	b30080e7          	jalr	-1232(ra) # 8020367e <set_sepc>
            break;
    80203b56:	a2f1                	j	80203d22 <handle_exception+0x2da>
            printf("Load address misaligned: 0x%lx\n", info->stval);
    80203b58:	fd043783          	ld	a5,-48(s0)
    80203b5c:	6f9c                	ld	a5,24(a5)
    80203b5e:	85be                	mv	a1,a5
    80203b60:	00006517          	auipc	a0,0x6
    80203b64:	03850513          	addi	a0,a0,56 # 80209b98 <simple_user_task_bin+0x1d0>
    80203b68:	ffffd097          	auipc	ra,0xffffd
    80203b6c:	12c080e7          	jalr	300(ra) # 80200c94 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203b70:	fd043783          	ld	a5,-48(s0)
    80203b74:	639c                	ld	a5,0(a5)
    80203b76:	0791                	addi	a5,a5,4
    80203b78:	85be                	mv	a1,a5
    80203b7a:	fd843503          	ld	a0,-40(s0)
    80203b7e:	00000097          	auipc	ra,0x0
    80203b82:	b00080e7          	jalr	-1280(ra) # 8020367e <set_sepc>
            break;
    80203b86:	aa71                	j	80203d22 <handle_exception+0x2da>
			printf("Load access fault: 0x%lx\n", info->stval);
    80203b88:	fd043783          	ld	a5,-48(s0)
    80203b8c:	6f9c                	ld	a5,24(a5)
    80203b8e:	85be                	mv	a1,a5
    80203b90:	00006517          	auipc	a0,0x6
    80203b94:	02850513          	addi	a0,a0,40 # 80209bb8 <simple_user_task_bin+0x1f0>
    80203b98:	ffffd097          	auipc	ra,0xffffd
    80203b9c:	0fc080e7          	jalr	252(ra) # 80200c94 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
    80203ba0:	fd043783          	ld	a5,-48(s0)
    80203ba4:	6f9c                	ld	a5,24(a5)
    80203ba6:	853e                	mv	a0,a5
    80203ba8:	fffff097          	auipc	ra,0xfffff
    80203bac:	436080e7          	jalr	1078(ra) # 80202fde <check_is_mapped>
    80203bb0:	87aa                	mv	a5,a0
    80203bb2:	cf89                	beqz	a5,80203bcc <handle_exception+0x184>
    80203bb4:	fd043783          	ld	a5,-48(s0)
    80203bb8:	6f9c                	ld	a5,24(a5)
    80203bba:	4589                	li	a1,2
    80203bbc:	853e                	mv	a0,a5
    80203bbe:	fffff097          	auipc	ra,0xfffff
    80203bc2:	dc4080e7          	jalr	-572(ra) # 80202982 <handle_page_fault>
    80203bc6:	87aa                	mv	a5,a0
    80203bc8:	14079a63          	bnez	a5,80203d1c <handle_exception+0x2d4>
			set_sepc(tf, info->sepc + 4);
    80203bcc:	fd043783          	ld	a5,-48(s0)
    80203bd0:	639c                	ld	a5,0(a5)
    80203bd2:	0791                	addi	a5,a5,4
    80203bd4:	85be                	mv	a1,a5
    80203bd6:	fd843503          	ld	a0,-40(s0)
    80203bda:	00000097          	auipc	ra,0x0
    80203bde:	aa4080e7          	jalr	-1372(ra) # 8020367e <set_sepc>
			break;
    80203be2:	a281                	j	80203d22 <handle_exception+0x2da>
            printf("Store address misaligned: 0x%lx\n", info->stval);
    80203be4:	fd043783          	ld	a5,-48(s0)
    80203be8:	6f9c                	ld	a5,24(a5)
    80203bea:	85be                	mv	a1,a5
    80203bec:	00006517          	auipc	a0,0x6
    80203bf0:	fec50513          	addi	a0,a0,-20 # 80209bd8 <simple_user_task_bin+0x210>
    80203bf4:	ffffd097          	auipc	ra,0xffffd
    80203bf8:	0a0080e7          	jalr	160(ra) # 80200c94 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203bfc:	fd043783          	ld	a5,-48(s0)
    80203c00:	639c                	ld	a5,0(a5)
    80203c02:	0791                	addi	a5,a5,4
    80203c04:	85be                	mv	a1,a5
    80203c06:	fd843503          	ld	a0,-40(s0)
    80203c0a:	00000097          	auipc	ra,0x0
    80203c0e:	a74080e7          	jalr	-1420(ra) # 8020367e <set_sepc>
            break;
    80203c12:	aa01                	j	80203d22 <handle_exception+0x2da>
			printf("Store access fault: 0x%lx\n", info->stval);
    80203c14:	fd043783          	ld	a5,-48(s0)
    80203c18:	6f9c                	ld	a5,24(a5)
    80203c1a:	85be                	mv	a1,a5
    80203c1c:	00006517          	auipc	a0,0x6
    80203c20:	fe450513          	addi	a0,a0,-28 # 80209c00 <simple_user_task_bin+0x238>
    80203c24:	ffffd097          	auipc	ra,0xffffd
    80203c28:	070080e7          	jalr	112(ra) # 80200c94 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
    80203c2c:	fd043783          	ld	a5,-48(s0)
    80203c30:	6f9c                	ld	a5,24(a5)
    80203c32:	853e                	mv	a0,a5
    80203c34:	fffff097          	auipc	ra,0xfffff
    80203c38:	3aa080e7          	jalr	938(ra) # 80202fde <check_is_mapped>
    80203c3c:	87aa                	mv	a5,a0
    80203c3e:	cf81                	beqz	a5,80203c56 <handle_exception+0x20e>
    80203c40:	fd043783          	ld	a5,-48(s0)
    80203c44:	6f9c                	ld	a5,24(a5)
    80203c46:	458d                	li	a1,3
    80203c48:	853e                	mv	a0,a5
    80203c4a:	fffff097          	auipc	ra,0xfffff
    80203c4e:	d38080e7          	jalr	-712(ra) # 80202982 <handle_page_fault>
    80203c52:	87aa                	mv	a5,a0
    80203c54:	e7f1                	bnez	a5,80203d20 <handle_exception+0x2d8>
			set_sepc(tf, info->sepc + 4);
    80203c56:	fd043783          	ld	a5,-48(s0)
    80203c5a:	639c                	ld	a5,0(a5)
    80203c5c:	0791                	addi	a5,a5,4
    80203c5e:	85be                	mv	a1,a5
    80203c60:	fd843503          	ld	a0,-40(s0)
    80203c64:	00000097          	auipc	ra,0x0
    80203c68:	a1a080e7          	jalr	-1510(ra) # 8020367e <set_sepc>
			break;
    80203c6c:	a85d                	j	80203d22 <handle_exception+0x2da>
            handle_syscall(tf,info);
    80203c6e:	fd043583          	ld	a1,-48(s0)
    80203c72:	fd843503          	ld	a0,-40(s0)
    80203c76:	00000097          	auipc	ra,0x0
    80203c7a:	266080e7          	jalr	614(ra) # 80203edc <handle_syscall>
            break;
    80203c7e:	a055                	j	80203d22 <handle_exception+0x2da>
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    80203c80:	fd043783          	ld	a5,-48(s0)
    80203c84:	639c                	ld	a5,0(a5)
    80203c86:	85be                	mv	a1,a5
    80203c88:	00006517          	auipc	a0,0x6
    80203c8c:	f9850513          	addi	a0,a0,-104 # 80209c20 <simple_user_task_bin+0x258>
    80203c90:	ffffd097          	auipc	ra,0xffffd
    80203c94:	004080e7          	jalr	4(ra) # 80200c94 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203c98:	fd043783          	ld	a5,-48(s0)
    80203c9c:	639c                	ld	a5,0(a5)
    80203c9e:	0791                	addi	a5,a5,4
    80203ca0:	85be                	mv	a1,a5
    80203ca2:	fd843503          	ld	a0,-40(s0)
    80203ca6:	00000097          	auipc	ra,0x0
    80203caa:	9d8080e7          	jalr	-1576(ra) # 8020367e <set_sepc>
            break;
    80203cae:	a895                	j	80203d22 <handle_exception+0x2da>
            handle_instruction_page_fault(tf,info);
    80203cb0:	fd043583          	ld	a1,-48(s0)
    80203cb4:	fd843503          	ld	a0,-40(s0)
    80203cb8:	00000097          	auipc	ra,0x0
    80203cbc:	450080e7          	jalr	1104(ra) # 80204108 <handle_instruction_page_fault>
            break;
    80203cc0:	a08d                	j	80203d22 <handle_exception+0x2da>
            handle_load_page_fault(tf,info);
    80203cc2:	fd043583          	ld	a1,-48(s0)
    80203cc6:	fd843503          	ld	a0,-40(s0)
    80203cca:	00000097          	auipc	ra,0x0
    80203cce:	4a0080e7          	jalr	1184(ra) # 8020416a <handle_load_page_fault>
            break;
    80203cd2:	a881                	j	80203d22 <handle_exception+0x2da>
            handle_store_page_fault(tf,info);
    80203cd4:	fd043583          	ld	a1,-48(s0)
    80203cd8:	fd843503          	ld	a0,-40(s0)
    80203cdc:	00000097          	auipc	ra,0x0
    80203ce0:	4f0080e7          	jalr	1264(ra) # 802041cc <handle_store_page_fault>
            break;
    80203ce4:	a83d                	j	80203d22 <handle_exception+0x2da>
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    80203ce6:	fd043783          	ld	a5,-48(s0)
    80203cea:	6398                	ld	a4,0(a5)
    80203cec:	fd043783          	ld	a5,-48(s0)
    80203cf0:	6f9c                	ld	a5,24(a5)
    80203cf2:	86be                	mv	a3,a5
    80203cf4:	863a                	mv	a2,a4
    80203cf6:	fe843583          	ld	a1,-24(s0)
    80203cfa:	00006517          	auipc	a0,0x6
    80203cfe:	f4e50513          	addi	a0,a0,-178 # 80209c48 <simple_user_task_bin+0x280>
    80203d02:	ffffd097          	auipc	ra,0xffffd
    80203d06:	f92080e7          	jalr	-110(ra) # 80200c94 <printf>
            panic("Unknown exception");
    80203d0a:	00006517          	auipc	a0,0x6
    80203d0e:	f7650513          	addi	a0,a0,-138 # 80209c80 <simple_user_task_bin+0x2b8>
    80203d12:	ffffe097          	auipc	ra,0xffffe
    80203d16:	9ce080e7          	jalr	-1586(ra) # 802016e0 <panic>
            break;
    80203d1a:	a021                	j	80203d22 <handle_exception+0x2da>
				return; // 成功处理
    80203d1c:	0001                	nop
    80203d1e:	a011                	j	80203d22 <handle_exception+0x2da>
				return; // 成功处理
    80203d20:	0001                	nop
}
    80203d22:	70a2                	ld	ra,40(sp)
    80203d24:	7402                	ld	s0,32(sp)
    80203d26:	6145                	addi	sp,sp,48
    80203d28:	8082                	ret

0000000080203d2a <user_va2pa>:
void* user_va2pa(pagetable_t pagetable, uint64 va) {
    80203d2a:	7179                	addi	sp,sp,-48
    80203d2c:	f406                	sd	ra,40(sp)
    80203d2e:	f022                	sd	s0,32(sp)
    80203d30:	1800                	addi	s0,sp,48
    80203d32:	fca43c23          	sd	a0,-40(s0)
    80203d36:	fcb43823          	sd	a1,-48(s0)
    pte_t *pte = walk_lookup(pagetable, va);
    80203d3a:	fd043583          	ld	a1,-48(s0)
    80203d3e:	fd843503          	ld	a0,-40(s0)
    80203d42:	ffffe097          	auipc	ra,0xffffe
    80203d46:	374080e7          	jalr	884(ra) # 802020b6 <walk_lookup>
    80203d4a:	fea43423          	sd	a0,-24(s0)
    if (!pte) return 0;
    80203d4e:	fe843783          	ld	a5,-24(s0)
    80203d52:	e399                	bnez	a5,80203d58 <user_va2pa+0x2e>
    80203d54:	4781                	li	a5,0
    80203d56:	a83d                	j	80203d94 <user_va2pa+0x6a>
    if (!(*pte & PTE_V)) return 0;
    80203d58:	fe843783          	ld	a5,-24(s0)
    80203d5c:	639c                	ld	a5,0(a5)
    80203d5e:	8b85                	andi	a5,a5,1
    80203d60:	e399                	bnez	a5,80203d66 <user_va2pa+0x3c>
    80203d62:	4781                	li	a5,0
    80203d64:	a805                	j	80203d94 <user_va2pa+0x6a>
    if (!(*pte & PTE_U)) return 0; // 必须是用户可访问
    80203d66:	fe843783          	ld	a5,-24(s0)
    80203d6a:	639c                	ld	a5,0(a5)
    80203d6c:	8bc1                	andi	a5,a5,16
    80203d6e:	e399                	bnez	a5,80203d74 <user_va2pa+0x4a>
    80203d70:	4781                	li	a5,0
    80203d72:	a00d                	j	80203d94 <user_va2pa+0x6a>
    uint64 pa = (PTE2PA(*pte)) | (va & 0xFFF); // 物理页基址 + 页内偏移
    80203d74:	fe843783          	ld	a5,-24(s0)
    80203d78:	639c                	ld	a5,0(a5)
    80203d7a:	83a9                	srli	a5,a5,0xa
    80203d7c:	00c79713          	slli	a4,a5,0xc
    80203d80:	fd043683          	ld	a3,-48(s0)
    80203d84:	6785                	lui	a5,0x1
    80203d86:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203d88:	8ff5                	and	a5,a5,a3
    80203d8a:	8fd9                	or	a5,a5,a4
    80203d8c:	fef43023          	sd	a5,-32(s0)
    return (void*)pa;
    80203d90:	fe043783          	ld	a5,-32(s0)
}
    80203d94:	853e                	mv	a0,a5
    80203d96:	70a2                	ld	ra,40(sp)
    80203d98:	7402                	ld	s0,32(sp)
    80203d9a:	6145                	addi	sp,sp,48
    80203d9c:	8082                	ret

0000000080203d9e <copyin>:
int copyin(char *dst, uint64 srcva, int maxlen) {
    80203d9e:	715d                	addi	sp,sp,-80
    80203da0:	e486                	sd	ra,72(sp)
    80203da2:	e0a2                	sd	s0,64(sp)
    80203da4:	0880                	addi	s0,sp,80
    80203da6:	fca43423          	sd	a0,-56(s0)
    80203daa:	fcb43023          	sd	a1,-64(s0)
    80203dae:	87b2                	mv	a5,a2
    80203db0:	faf42e23          	sw	a5,-68(s0)
    struct proc *p = myproc();
    80203db4:	00001097          	auipc	ra,0x1
    80203db8:	bcc080e7          	jalr	-1076(ra) # 80204980 <myproc>
    80203dbc:	fea43023          	sd	a0,-32(s0)
    for (int i = 0; i < maxlen; i++) {
    80203dc0:	fe042623          	sw	zero,-20(s0)
    80203dc4:	a085                	j	80203e24 <copyin+0x86>
        char *pa = user_va2pa(p->pagetable, srcva + i); // 你需要实现 user_va2pa
    80203dc6:	fe043783          	ld	a5,-32(s0)
    80203dca:	7fd4                	ld	a3,184(a5)
    80203dcc:	fec42703          	lw	a4,-20(s0)
    80203dd0:	fc043783          	ld	a5,-64(s0)
    80203dd4:	97ba                	add	a5,a5,a4
    80203dd6:	85be                	mv	a1,a5
    80203dd8:	8536                	mv	a0,a3
    80203dda:	00000097          	auipc	ra,0x0
    80203dde:	f50080e7          	jalr	-176(ra) # 80203d2a <user_va2pa>
    80203de2:	fca43c23          	sd	a0,-40(s0)
        if (!pa) return -1;
    80203de6:	fd843783          	ld	a5,-40(s0)
    80203dea:	e399                	bnez	a5,80203df0 <copyin+0x52>
    80203dec:	57fd                	li	a5,-1
    80203dee:	a0a9                	j	80203e38 <copyin+0x9a>
        dst[i] = *pa;
    80203df0:	fec42783          	lw	a5,-20(s0)
    80203df4:	fc843703          	ld	a4,-56(s0)
    80203df8:	97ba                	add	a5,a5,a4
    80203dfa:	fd843703          	ld	a4,-40(s0)
    80203dfe:	00074703          	lbu	a4,0(a4)
    80203e02:	00e78023          	sb	a4,0(a5)
        if (dst[i] == 0) return 0;
    80203e06:	fec42783          	lw	a5,-20(s0)
    80203e0a:	fc843703          	ld	a4,-56(s0)
    80203e0e:	97ba                	add	a5,a5,a4
    80203e10:	0007c783          	lbu	a5,0(a5)
    80203e14:	e399                	bnez	a5,80203e1a <copyin+0x7c>
    80203e16:	4781                	li	a5,0
    80203e18:	a005                	j	80203e38 <copyin+0x9a>
    for (int i = 0; i < maxlen; i++) {
    80203e1a:	fec42783          	lw	a5,-20(s0)
    80203e1e:	2785                	addiw	a5,a5,1
    80203e20:	fef42623          	sw	a5,-20(s0)
    80203e24:	fec42783          	lw	a5,-20(s0)
    80203e28:	873e                	mv	a4,a5
    80203e2a:	fbc42783          	lw	a5,-68(s0)
    80203e2e:	2701                	sext.w	a4,a4
    80203e30:	2781                	sext.w	a5,a5
    80203e32:	f8f74ae3          	blt	a4,a5,80203dc6 <copyin+0x28>
    return 0;
    80203e36:	4781                	li	a5,0
}
    80203e38:	853e                	mv	a0,a5
    80203e3a:	60a6                	ld	ra,72(sp)
    80203e3c:	6406                	ld	s0,64(sp)
    80203e3e:	6161                	addi	sp,sp,80
    80203e40:	8082                	ret

0000000080203e42 <copyinstr>:
int copyinstr(char *dst, pagetable_t pagetable, uint64 srcva, int max) {
    80203e42:	7139                	addi	sp,sp,-64
    80203e44:	fc06                	sd	ra,56(sp)
    80203e46:	f822                	sd	s0,48(sp)
    80203e48:	0080                	addi	s0,sp,64
    80203e4a:	fca43c23          	sd	a0,-40(s0)
    80203e4e:	fcb43823          	sd	a1,-48(s0)
    80203e52:	fcc43423          	sd	a2,-56(s0)
    80203e56:	87b6                	mv	a5,a3
    80203e58:	fcf42223          	sw	a5,-60(s0)
    for (i = 0; i < max; i++) {
    80203e5c:	fe042623          	sw	zero,-20(s0)
    80203e60:	a0b9                	j	80203eae <copyinstr+0x6c>
        if (copyin(&c, srcva + i, 1) < 0)  // 每次拷贝 1 字节
    80203e62:	fec42703          	lw	a4,-20(s0)
    80203e66:	fc843783          	ld	a5,-56(s0)
    80203e6a:	973e                	add	a4,a4,a5
    80203e6c:	feb40793          	addi	a5,s0,-21
    80203e70:	4605                	li	a2,1
    80203e72:	85ba                	mv	a1,a4
    80203e74:	853e                	mv	a0,a5
    80203e76:	00000097          	auipc	ra,0x0
    80203e7a:	f28080e7          	jalr	-216(ra) # 80203d9e <copyin>
    80203e7e:	87aa                	mv	a5,a0
    80203e80:	0007d463          	bgez	a5,80203e88 <copyinstr+0x46>
            return -1;
    80203e84:	57fd                	li	a5,-1
    80203e86:	a0b1                	j	80203ed2 <copyinstr+0x90>
        dst[i] = c;
    80203e88:	fec42783          	lw	a5,-20(s0)
    80203e8c:	fd843703          	ld	a4,-40(s0)
    80203e90:	97ba                	add	a5,a5,a4
    80203e92:	feb44703          	lbu	a4,-21(s0)
    80203e96:	00e78023          	sb	a4,0(a5)
        if (c == '\0')
    80203e9a:	feb44783          	lbu	a5,-21(s0)
    80203e9e:	e399                	bnez	a5,80203ea4 <copyinstr+0x62>
            return 0;
    80203ea0:	4781                	li	a5,0
    80203ea2:	a805                	j	80203ed2 <copyinstr+0x90>
    for (i = 0; i < max; i++) {
    80203ea4:	fec42783          	lw	a5,-20(s0)
    80203ea8:	2785                	addiw	a5,a5,1
    80203eaa:	fef42623          	sw	a5,-20(s0)
    80203eae:	fec42783          	lw	a5,-20(s0)
    80203eb2:	873e                	mv	a4,a5
    80203eb4:	fc442783          	lw	a5,-60(s0)
    80203eb8:	2701                	sext.w	a4,a4
    80203eba:	2781                	sext.w	a5,a5
    80203ebc:	faf743e3          	blt	a4,a5,80203e62 <copyinstr+0x20>
    dst[max-1] = '\0';
    80203ec0:	fc442783          	lw	a5,-60(s0)
    80203ec4:	17fd                	addi	a5,a5,-1
    80203ec6:	fd843703          	ld	a4,-40(s0)
    80203eca:	97ba                	add	a5,a5,a4
    80203ecc:	00078023          	sb	zero,0(a5)
    return -1; // 超过最大长度还没遇到 \0
    80203ed0:	57fd                	li	a5,-1
}
    80203ed2:	853e                	mv	a0,a5
    80203ed4:	70e2                	ld	ra,56(sp)
    80203ed6:	7442                	ld	s0,48(sp)
    80203ed8:	6121                	addi	sp,sp,64
    80203eda:	8082                	ret

0000000080203edc <handle_syscall>:
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    80203edc:	7171                	addi	sp,sp,-176
    80203ede:	f506                	sd	ra,168(sp)
    80203ee0:	f122                	sd	s0,160(sp)
    80203ee2:	1900                	addi	s0,sp,176
    80203ee4:	f4a43c23          	sd	a0,-168(s0)
    80203ee8:	f4b43823          	sd	a1,-176(s0)
	printf("[syscall] entry: pid=%d a7=%ld a0=%ld\n", myproc()->pid, tf->a7, tf->a0);
    80203eec:	00001097          	auipc	ra,0x1
    80203ef0:	a94080e7          	jalr	-1388(ra) # 80204980 <myproc>
    80203ef4:	87aa                	mv	a5,a0
    80203ef6:	43d8                	lw	a4,4(a5)
    80203ef8:	f5843783          	ld	a5,-168(s0)
    80203efc:	7bd0                	ld	a2,176(a5)
    80203efe:	f5843783          	ld	a5,-168(s0)
    80203f02:	7fbc                	ld	a5,120(a5)
    80203f04:	86be                	mv	a3,a5
    80203f06:	85ba                	mv	a1,a4
    80203f08:	00006517          	auipc	a0,0x6
    80203f0c:	dd050513          	addi	a0,a0,-560 # 80209cd8 <simple_user_task_bin+0x310>
    80203f10:	ffffd097          	auipc	ra,0xffffd
    80203f14:	d84080e7          	jalr	-636(ra) # 80200c94 <printf>
	switch (tf->a7) {
    80203f18:	f5843783          	ld	a5,-168(s0)
    80203f1c:	7bdc                	ld	a5,176(a5)
    80203f1e:	6705                	lui	a4,0x1
    80203f20:	177d                	addi	a4,a4,-1 # fff <_entry-0x801ff001>
    80203f22:	18e78563          	beq	a5,a4,802040ac <handle_syscall+0x1d0>
    80203f26:	6705                	lui	a4,0x1
    80203f28:	18e7ff63          	bgeu	a5,a4,802040c6 <handle_syscall+0x1ea>
    80203f2c:	0dd00713          	li	a4,221
    80203f30:	12e78363          	beq	a5,a4,80204056 <handle_syscall+0x17a>
    80203f34:	0dd00713          	li	a4,221
    80203f38:	18f76763          	bltu	a4,a5,802040c6 <handle_syscall+0x1ea>
    80203f3c:	0dc00713          	li	a4,220
    80203f40:	0ee78363          	beq	a5,a4,80204026 <handle_syscall+0x14a>
    80203f44:	0dc00713          	li	a4,220
    80203f48:	16f76f63          	bltu	a4,a5,802040c6 <handle_syscall+0x1ea>
    80203f4c:	0ad00713          	li	a4,173
    80203f50:	12e78963          	beq	a5,a4,80204082 <handle_syscall+0x1a6>
    80203f54:	0ad00713          	li	a4,173
    80203f58:	16f76763          	bltu	a4,a5,802040c6 <handle_syscall+0x1ea>
    80203f5c:	0ac00713          	li	a4,172
    80203f60:	10e78663          	beq	a5,a4,8020406c <handle_syscall+0x190>
    80203f64:	0ac00713          	li	a4,172
    80203f68:	14f76f63          	bltu	a4,a5,802040c6 <handle_syscall+0x1ea>
    80203f6c:	05d00713          	li	a4,93
    80203f70:	08e78563          	beq	a5,a4,80203ffa <handle_syscall+0x11e>
    80203f74:	05d00713          	li	a4,93
    80203f78:	14f76763          	bltu	a4,a5,802040c6 <handle_syscall+0x1ea>
    80203f7c:	4705                	li	a4,1
    80203f7e:	00e78663          	beq	a5,a4,80203f8a <handle_syscall+0xae>
    80203f82:	4709                	li	a4,2
    80203f84:	02e78063          	beq	a5,a4,80203fa4 <handle_syscall+0xc8>
    80203f88:	aa3d                	j	802040c6 <handle_syscall+0x1ea>
			printf("[syscall] print int: %ld\n", tf->a0);
    80203f8a:	f5843783          	ld	a5,-168(s0)
    80203f8e:	7fbc                	ld	a5,120(a5)
    80203f90:	85be                	mv	a1,a5
    80203f92:	00006517          	auipc	a0,0x6
    80203f96:	d6e50513          	addi	a0,a0,-658 # 80209d00 <simple_user_task_bin+0x338>
    80203f9a:	ffffd097          	auipc	ra,0xffffd
    80203f9e:	cfa080e7          	jalr	-774(ra) # 80200c94 <printf>
			break;
    80203fa2:	a299                	j	802040e8 <handle_syscall+0x20c>
			if (copyinstr(buf, myproc()->pagetable, tf->a0, sizeof(buf)) < 0) {
    80203fa4:	00001097          	auipc	ra,0x1
    80203fa8:	9dc080e7          	jalr	-1572(ra) # 80204980 <myproc>
    80203fac:	87aa                	mv	a5,a0
    80203fae:	7fd8                	ld	a4,184(a5)
    80203fb0:	f5843783          	ld	a5,-168(s0)
    80203fb4:	7fb0                	ld	a2,120(a5)
    80203fb6:	f6840793          	addi	a5,s0,-152
    80203fba:	08000693          	li	a3,128
    80203fbe:	85ba                	mv	a1,a4
    80203fc0:	853e                	mv	a0,a5
    80203fc2:	00000097          	auipc	ra,0x0
    80203fc6:	e80080e7          	jalr	-384(ra) # 80203e42 <copyinstr>
    80203fca:	87aa                	mv	a5,a0
    80203fcc:	0007db63          	bgez	a5,80203fe2 <handle_syscall+0x106>
				printf("[syscall] invalid string\n");
    80203fd0:	00006517          	auipc	a0,0x6
    80203fd4:	d5050513          	addi	a0,a0,-688 # 80209d20 <simple_user_task_bin+0x358>
    80203fd8:	ffffd097          	auipc	ra,0xffffd
    80203fdc:	cbc080e7          	jalr	-836(ra) # 80200c94 <printf>
				break;
    80203fe0:	a221                	j	802040e8 <handle_syscall+0x20c>
			printf("[syscall] print str: %s\n", buf);
    80203fe2:	f6840793          	addi	a5,s0,-152
    80203fe6:	85be                	mv	a1,a5
    80203fe8:	00006517          	auipc	a0,0x6
    80203fec:	d5850513          	addi	a0,a0,-680 # 80209d40 <simple_user_task_bin+0x378>
    80203ff0:	ffffd097          	auipc	ra,0xffffd
    80203ff4:	ca4080e7          	jalr	-860(ra) # 80200c94 <printf>
			break;
    80203ff8:	a8c5                	j	802040e8 <handle_syscall+0x20c>
			printf("[syscall] exit(%ld)\n", tf->a0);
    80203ffa:	f5843783          	ld	a5,-168(s0)
    80203ffe:	7fbc                	ld	a5,120(a5)
    80204000:	85be                	mv	a1,a5
    80204002:	00006517          	auipc	a0,0x6
    80204006:	d5e50513          	addi	a0,a0,-674 # 80209d60 <simple_user_task_bin+0x398>
    8020400a:	ffffd097          	auipc	ra,0xffffd
    8020400e:	c8a080e7          	jalr	-886(ra) # 80200c94 <printf>
			exit_proc((int)tf->a0);
    80204012:	f5843783          	ld	a5,-168(s0)
    80204016:	7fbc                	ld	a5,120(a5)
    80204018:	2781                	sext.w	a5,a5
    8020401a:	853e                	mv	a0,a5
    8020401c:	00001097          	auipc	ra,0x1
    80204020:	784080e7          	jalr	1924(ra) # 802057a0 <exit_proc>
			break;
    80204024:	a0d1                	j	802040e8 <handle_syscall+0x20c>
			int child_pid = fork_proc();
    80204026:	00001097          	auipc	ra,0x1
    8020402a:	2e0080e7          	jalr	736(ra) # 80205306 <fork_proc>
    8020402e:	87aa                	mv	a5,a0
    80204030:	fef42623          	sw	a5,-20(s0)
			tf->a0 = child_pid;
    80204034:	fec42703          	lw	a4,-20(s0)
    80204038:	f5843783          	ld	a5,-168(s0)
    8020403c:	ffb8                	sd	a4,120(a5)
			printf("[syscall] fork -> %d\n", child_pid);
    8020403e:	fec42783          	lw	a5,-20(s0)
    80204042:	85be                	mv	a1,a5
    80204044:	00006517          	auipc	a0,0x6
    80204048:	d3450513          	addi	a0,a0,-716 # 80209d78 <simple_user_task_bin+0x3b0>
    8020404c:	ffffd097          	auipc	ra,0xffffd
    80204050:	c48080e7          	jalr	-952(ra) # 80200c94 <printf>
			break;
    80204054:	a851                	j	802040e8 <handle_syscall+0x20c>
			tf->a0 = wait_proc(NULL);
    80204056:	4501                	li	a0,0
    80204058:	00002097          	auipc	ra,0x2
    8020405c:	812080e7          	jalr	-2030(ra) # 8020586a <wait_proc>
    80204060:	87aa                	mv	a5,a0
    80204062:	873e                	mv	a4,a5
    80204064:	f5843783          	ld	a5,-168(s0)
    80204068:	ffb8                	sd	a4,120(a5)
			break;
    8020406a:	a8bd                	j	802040e8 <handle_syscall+0x20c>
			tf->a0 = myproc()->pid;
    8020406c:	00001097          	auipc	ra,0x1
    80204070:	914080e7          	jalr	-1772(ra) # 80204980 <myproc>
    80204074:	87aa                	mv	a5,a0
    80204076:	43dc                	lw	a5,4(a5)
    80204078:	873e                	mv	a4,a5
    8020407a:	f5843783          	ld	a5,-168(s0)
    8020407e:	ffb8                	sd	a4,120(a5)
			break;
    80204080:	a0a5                	j	802040e8 <handle_syscall+0x20c>
			tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
    80204082:	00001097          	auipc	ra,0x1
    80204086:	8fe080e7          	jalr	-1794(ra) # 80204980 <myproc>
    8020408a:	87aa                	mv	a5,a0
    8020408c:	6fdc                	ld	a5,152(a5)
    8020408e:	cb91                	beqz	a5,802040a2 <handle_syscall+0x1c6>
    80204090:	00001097          	auipc	ra,0x1
    80204094:	8f0080e7          	jalr	-1808(ra) # 80204980 <myproc>
    80204098:	87aa                	mv	a5,a0
    8020409a:	6fdc                	ld	a5,152(a5)
    8020409c:	43dc                	lw	a5,4(a5)
    8020409e:	873e                	mv	a4,a5
    802040a0:	a011                	j	802040a4 <handle_syscall+0x1c8>
    802040a2:	4701                	li	a4,0
    802040a4:	f5843783          	ld	a5,-168(s0)
    802040a8:	ffb8                	sd	a4,120(a5)
			break;
    802040aa:	a83d                	j	802040e8 <handle_syscall+0x20c>
			tf->a0 = 0;
    802040ac:	f5843783          	ld	a5,-168(s0)
    802040b0:	0607bc23          	sd	zero,120(a5)
			printf("[syscall] step enabled but do nothing\n");
    802040b4:	00006517          	auipc	a0,0x6
    802040b8:	cdc50513          	addi	a0,a0,-804 # 80209d90 <simple_user_task_bin+0x3c8>
    802040bc:	ffffd097          	auipc	ra,0xffffd
    802040c0:	bd8080e7          	jalr	-1064(ra) # 80200c94 <printf>
			break;
    802040c4:	a015                	j	802040e8 <handle_syscall+0x20c>
			printf("[syscall] unknown syscall: %ld\n", tf->a7);
    802040c6:	f5843783          	ld	a5,-168(s0)
    802040ca:	7bdc                	ld	a5,176(a5)
    802040cc:	85be                	mv	a1,a5
    802040ce:	00006517          	auipc	a0,0x6
    802040d2:	cea50513          	addi	a0,a0,-790 # 80209db8 <simple_user_task_bin+0x3f0>
    802040d6:	ffffd097          	auipc	ra,0xffffd
    802040da:	bbe080e7          	jalr	-1090(ra) # 80200c94 <printf>
			tf->a0 = -1;
    802040de:	f5843783          	ld	a5,-168(s0)
    802040e2:	577d                	li	a4,-1
    802040e4:	ffb8                	sd	a4,120(a5)
			break;
    802040e6:	0001                	nop
	set_sepc(tf, info->sepc + 4);
    802040e8:	f5043783          	ld	a5,-176(s0)
    802040ec:	639c                	ld	a5,0(a5)
    802040ee:	0791                	addi	a5,a5,4
    802040f0:	85be                	mv	a1,a5
    802040f2:	f5843503          	ld	a0,-168(s0)
    802040f6:	fffff097          	auipc	ra,0xfffff
    802040fa:	588080e7          	jalr	1416(ra) # 8020367e <set_sepc>
}
    802040fe:	0001                	nop
    80204100:	70aa                	ld	ra,168(sp)
    80204102:	740a                	ld	s0,160(sp)
    80204104:	614d                	addi	sp,sp,176
    80204106:	8082                	ret

0000000080204108 <handle_instruction_page_fault>:
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    80204108:	1101                	addi	sp,sp,-32
    8020410a:	ec06                	sd	ra,24(sp)
    8020410c:	e822                	sd	s0,16(sp)
    8020410e:	1000                	addi	s0,sp,32
    80204110:	fea43423          	sd	a0,-24(s0)
    80204114:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80204118:	fe043783          	ld	a5,-32(s0)
    8020411c:	6f98                	ld	a4,24(a5)
    8020411e:	fe043783          	ld	a5,-32(s0)
    80204122:	639c                	ld	a5,0(a5)
    80204124:	863e                	mv	a2,a5
    80204126:	85ba                	mv	a1,a4
    80204128:	00006517          	auipc	a0,0x6
    8020412c:	cb050513          	addi	a0,a0,-848 # 80209dd8 <simple_user_task_bin+0x410>
    80204130:	ffffd097          	auipc	ra,0xffffd
    80204134:	b64080e7          	jalr	-1180(ra) # 80200c94 <printf>
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    80204138:	fe043783          	ld	a5,-32(s0)
    8020413c:	6f9c                	ld	a5,24(a5)
    8020413e:	4585                	li	a1,1
    80204140:	853e                	mv	a0,a5
    80204142:	fffff097          	auipc	ra,0xfffff
    80204146:	840080e7          	jalr	-1984(ra) # 80202982 <handle_page_fault>
    8020414a:	87aa                	mv	a5,a0
    8020414c:	eb91                	bnez	a5,80204160 <handle_instruction_page_fault+0x58>
    panic("Unhandled instruction page fault");
    8020414e:	00006517          	auipc	a0,0x6
    80204152:	cba50513          	addi	a0,a0,-838 # 80209e08 <simple_user_task_bin+0x440>
    80204156:	ffffd097          	auipc	ra,0xffffd
    8020415a:	58a080e7          	jalr	1418(ra) # 802016e0 <panic>
    8020415e:	a011                	j	80204162 <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80204160:	0001                	nop
}
    80204162:	60e2                	ld	ra,24(sp)
    80204164:	6442                	ld	s0,16(sp)
    80204166:	6105                	addi	sp,sp,32
    80204168:	8082                	ret

000000008020416a <handle_load_page_fault>:
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    8020416a:	1101                	addi	sp,sp,-32
    8020416c:	ec06                	sd	ra,24(sp)
    8020416e:	e822                	sd	s0,16(sp)
    80204170:	1000                	addi	s0,sp,32
    80204172:	fea43423          	sd	a0,-24(s0)
    80204176:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    8020417a:	fe043783          	ld	a5,-32(s0)
    8020417e:	6f98                	ld	a4,24(a5)
    80204180:	fe043783          	ld	a5,-32(s0)
    80204184:	639c                	ld	a5,0(a5)
    80204186:	863e                	mv	a2,a5
    80204188:	85ba                	mv	a1,a4
    8020418a:	00006517          	auipc	a0,0x6
    8020418e:	ca650513          	addi	a0,a0,-858 # 80209e30 <simple_user_task_bin+0x468>
    80204192:	ffffd097          	auipc	ra,0xffffd
    80204196:	b02080e7          	jalr	-1278(ra) # 80200c94 <printf>
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    8020419a:	fe043783          	ld	a5,-32(s0)
    8020419e:	6f9c                	ld	a5,24(a5)
    802041a0:	4589                	li	a1,2
    802041a2:	853e                	mv	a0,a5
    802041a4:	ffffe097          	auipc	ra,0xffffe
    802041a8:	7de080e7          	jalr	2014(ra) # 80202982 <handle_page_fault>
    802041ac:	87aa                	mv	a5,a0
    802041ae:	eb91                	bnez	a5,802041c2 <handle_load_page_fault+0x58>
    panic("Unhandled load page fault");
    802041b0:	00006517          	auipc	a0,0x6
    802041b4:	cb050513          	addi	a0,a0,-848 # 80209e60 <simple_user_task_bin+0x498>
    802041b8:	ffffd097          	auipc	ra,0xffffd
    802041bc:	528080e7          	jalr	1320(ra) # 802016e0 <panic>
    802041c0:	a011                	j	802041c4 <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802041c2:	0001                	nop
}
    802041c4:	60e2                	ld	ra,24(sp)
    802041c6:	6442                	ld	s0,16(sp)
    802041c8:	6105                	addi	sp,sp,32
    802041ca:	8082                	ret

00000000802041cc <handle_store_page_fault>:
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    802041cc:	1101                	addi	sp,sp,-32
    802041ce:	ec06                	sd	ra,24(sp)
    802041d0:	e822                	sd	s0,16(sp)
    802041d2:	1000                	addi	s0,sp,32
    802041d4:	fea43423          	sd	a0,-24(s0)
    802041d8:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802041dc:	fe043783          	ld	a5,-32(s0)
    802041e0:	6f98                	ld	a4,24(a5)
    802041e2:	fe043783          	ld	a5,-32(s0)
    802041e6:	639c                	ld	a5,0(a5)
    802041e8:	863e                	mv	a2,a5
    802041ea:	85ba                	mv	a1,a4
    802041ec:	00006517          	auipc	a0,0x6
    802041f0:	c9450513          	addi	a0,a0,-876 # 80209e80 <simple_user_task_bin+0x4b8>
    802041f4:	ffffd097          	auipc	ra,0xffffd
    802041f8:	aa0080e7          	jalr	-1376(ra) # 80200c94 <printf>
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    802041fc:	fe043783          	ld	a5,-32(s0)
    80204200:	6f9c                	ld	a5,24(a5)
    80204202:	458d                	li	a1,3
    80204204:	853e                	mv	a0,a5
    80204206:	ffffe097          	auipc	ra,0xffffe
    8020420a:	77c080e7          	jalr	1916(ra) # 80202982 <handle_page_fault>
    8020420e:	87aa                	mv	a5,a0
    80204210:	eb91                	bnez	a5,80204224 <handle_store_page_fault+0x58>
    panic("Unhandled store page fault");
    80204212:	00006517          	auipc	a0,0x6
    80204216:	c9e50513          	addi	a0,a0,-866 # 80209eb0 <simple_user_task_bin+0x4e8>
    8020421a:	ffffd097          	auipc	ra,0xffffd
    8020421e:	4c6080e7          	jalr	1222(ra) # 802016e0 <panic>
    80204222:	a011                	j	80204226 <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80204224:	0001                	nop
}
    80204226:	60e2                	ld	ra,24(sp)
    80204228:	6442                	ld	s0,16(sp)
    8020422a:	6105                	addi	sp,sp,32
    8020422c:	8082                	ret

000000008020422e <usertrap>:
void usertrap(void) {
    8020422e:	7159                	addi	sp,sp,-112
    80204230:	f486                	sd	ra,104(sp)
    80204232:	f0a2                	sd	s0,96(sp)
    80204234:	1880                	addi	s0,sp,112
    struct proc *p = myproc();
    80204236:	00000097          	auipc	ra,0x0
    8020423a:	74a080e7          	jalr	1866(ra) # 80204980 <myproc>
    8020423e:	fea43423          	sd	a0,-24(s0)
    struct trapframe *tf = p->trapframe;
    80204242:	fe843783          	ld	a5,-24(s0)
    80204246:	63fc                	ld	a5,192(a5)
    80204248:	fef43023          	sd	a5,-32(s0)
    uint64 scause = r_scause();
    8020424c:	fffff097          	auipc	ra,0xfffff
    80204250:	3a0080e7          	jalr	928(ra) # 802035ec <r_scause>
    80204254:	fca43c23          	sd	a0,-40(s0)
    uint64 stval  = r_stval();
    80204258:	fffff097          	auipc	ra,0xfffff
    8020425c:	3c8080e7          	jalr	968(ra) # 80203620 <r_stval>
    80204260:	fca43823          	sd	a0,-48(s0)
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    80204264:	fe043783          	ld	a5,-32(s0)
    80204268:	739c                	ld	a5,32(a5)
    8020426a:	fcf43423          	sd	a5,-56(s0)
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存
    8020426e:	fe043783          	ld	a5,-32(s0)
    80204272:	6f9c                	ld	a5,24(a5)
    80204274:	fcf43023          	sd	a5,-64(s0)
    uint64 code = scause & 0xff;
    80204278:	fd843783          	ld	a5,-40(s0)
    8020427c:	0ff7f793          	zext.b	a5,a5
    80204280:	faf43c23          	sd	a5,-72(s0)
    uint64 is_intr = (scause >> 63);
    80204284:	fd843783          	ld	a5,-40(s0)
    80204288:	93fd                	srli	a5,a5,0x3f
    8020428a:	faf43823          	sd	a5,-80(s0)
    if (!is_intr && code == 8) { // 用户态 ecall
    8020428e:	fb043783          	ld	a5,-80(s0)
    80204292:	e3a1                	bnez	a5,802042d2 <usertrap+0xa4>
    80204294:	fb843703          	ld	a4,-72(s0)
    80204298:	47a1                	li	a5,8
    8020429a:	02f71c63          	bne	a4,a5,802042d2 <usertrap+0xa4>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    8020429e:	fc843783          	ld	a5,-56(s0)
    802042a2:	f8f43823          	sd	a5,-112(s0)
    802042a6:	fc043783          	ld	a5,-64(s0)
    802042aa:	f8f43c23          	sd	a5,-104(s0)
    802042ae:	fd843783          	ld	a5,-40(s0)
    802042b2:	faf43023          	sd	a5,-96(s0)
    802042b6:	fd043783          	ld	a5,-48(s0)
    802042ba:	faf43423          	sd	a5,-88(s0)
        handle_syscall(tf, &info);
    802042be:	f9040793          	addi	a5,s0,-112
    802042c2:	85be                	mv	a1,a5
    802042c4:	fe043503          	ld	a0,-32(s0)
    802042c8:	00000097          	auipc	ra,0x0
    802042cc:	c14080e7          	jalr	-1004(ra) # 80203edc <handle_syscall>
    if (!is_intr && code == 8) { // 用户态 ecall
    802042d0:	a869                	j	8020436a <usertrap+0x13c>
    } else if (is_intr) {
    802042d2:	fb043783          	ld	a5,-80(s0)
    802042d6:	c3ad                	beqz	a5,80204338 <usertrap+0x10a>
        if (code == 5) {
    802042d8:	fb843703          	ld	a4,-72(s0)
    802042dc:	4795                	li	a5,5
    802042de:	02f71663          	bne	a4,a5,8020430a <usertrap+0xdc>
            timeintr();
    802042e2:	fffff097          	auipc	ra,0xfffff
    802042e6:	1fe080e7          	jalr	510(ra) # 802034e0 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802042ea:	fffff097          	auipc	ra,0xfffff
    802042ee:	1dc080e7          	jalr	476(ra) # 802034c6 <sbi_get_time>
    802042f2:	872a                	mv	a4,a0
    802042f4:	000f47b7          	lui	a5,0xf4
    802042f8:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802042fc:	97ba                	add	a5,a5,a4
    802042fe:	853e                	mv	a0,a5
    80204300:	fffff097          	auipc	ra,0xfffff
    80204304:	1aa080e7          	jalr	426(ra) # 802034aa <sbi_set_time>
    80204308:	a08d                	j	8020436a <usertrap+0x13c>
        } else if (code == 9) {
    8020430a:	fb843703          	ld	a4,-72(s0)
    8020430e:	47a5                	li	a5,9
    80204310:	00f71763          	bne	a4,a5,8020431e <usertrap+0xf0>
            handle_external_interrupt();
    80204314:	fffff097          	auipc	ra,0xfffff
    80204318:	4ba080e7          	jalr	1210(ra) # 802037ce <handle_external_interrupt>
    8020431c:	a0b9                	j	8020436a <usertrap+0x13c>
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    8020431e:	fc843603          	ld	a2,-56(s0)
    80204322:	fd843583          	ld	a1,-40(s0)
    80204326:	00006517          	auipc	a0,0x6
    8020432a:	baa50513          	addi	a0,a0,-1110 # 80209ed0 <simple_user_task_bin+0x508>
    8020432e:	ffffd097          	auipc	ra,0xffffd
    80204332:	966080e7          	jalr	-1690(ra) # 80200c94 <printf>
    80204336:	a815                	j	8020436a <usertrap+0x13c>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80204338:	fc843783          	ld	a5,-56(s0)
    8020433c:	f8f43823          	sd	a5,-112(s0)
    80204340:	fc043783          	ld	a5,-64(s0)
    80204344:	f8f43c23          	sd	a5,-104(s0)
    80204348:	fd843783          	ld	a5,-40(s0)
    8020434c:	faf43023          	sd	a5,-96(s0)
    80204350:	fd043783          	ld	a5,-48(s0)
    80204354:	faf43423          	sd	a5,-88(s0)
        handle_exception(tf, &info);
    80204358:	f9040793          	addi	a5,s0,-112
    8020435c:	85be                	mv	a1,a5
    8020435e:	fe043503          	ld	a0,-32(s0)
    80204362:	fffff097          	auipc	ra,0xfffff
    80204366:	6e6080e7          	jalr	1766(ra) # 80203a48 <handle_exception>
    usertrapret();
    8020436a:	00000097          	auipc	ra,0x0
    8020436e:	012080e7          	jalr	18(ra) # 8020437c <usertrapret>
}
    80204372:	0001                	nop
    80204374:	70a6                	ld	ra,104(sp)
    80204376:	7406                	ld	s0,96(sp)
    80204378:	6165                	addi	sp,sp,112
    8020437a:	8082                	ret

000000008020437c <usertrapret>:
void usertrapret(void) {
    8020437c:	7179                	addi	sp,sp,-48
    8020437e:	f406                	sd	ra,40(sp)
    80204380:	f022                	sd	s0,32(sp)
    80204382:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80204384:	00000097          	auipc	ra,0x0
    80204388:	5fc080e7          	jalr	1532(ra) # 80204980 <myproc>
    8020438c:	fea43423          	sd	a0,-24(s0)
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    80204390:	00000717          	auipc	a4,0x0
    80204394:	35070713          	addi	a4,a4,848 # 802046e0 <trampoline>
    80204398:	77fd                	lui	a5,0xfffff
    8020439a:	973e                	add	a4,a4,a5
    8020439c:	00000797          	auipc	a5,0x0
    802043a0:	34478793          	addi	a5,a5,836 # 802046e0 <trampoline>
    802043a4:	40f707b3          	sub	a5,a4,a5
    802043a8:	fef43023          	sd	a5,-32(s0)
    w_stvec(uservec_va);
    802043ac:	fe043503          	ld	a0,-32(s0)
    802043b0:	fffff097          	auipc	ra,0xfffff
    802043b4:	222080e7          	jalr	546(ra) # 802035d2 <w_stvec>
    w_sscratch((uint64)TRAPFRAME);
    802043b8:	7579                	lui	a0,0xffffe
    802043ba:	fffff097          	auipc	ra,0xfffff
    802043be:	1bc080e7          	jalr	444(ra) # 80203576 <w_sscratch>
    uint64 user_satp = MAKE_SATP(p->pagetable);
    802043c2:	fe843783          	ld	a5,-24(s0)
    802043c6:	7fdc                	ld	a5,184(a5)
    802043c8:	00c7d713          	srli	a4,a5,0xc
    802043cc:	57fd                	li	a5,-1
    802043ce:	17fe                	slli	a5,a5,0x3f
    802043d0:	8fd9                	or	a5,a5,a4
    802043d2:	fcf43c23          	sd	a5,-40(s0)
    uint64 userret_va = (uint64)TRAMPOLINE + ((uint64)userret - (uint64)trampoline);
    802043d6:	00000717          	auipc	a4,0x0
    802043da:	3a070713          	addi	a4,a4,928 # 80204776 <userret>
    802043de:	77fd                	lui	a5,0xfffff
    802043e0:	973e                	add	a4,a4,a5
    802043e2:	00000797          	auipc	a5,0x0
    802043e6:	2fe78793          	addi	a5,a5,766 # 802046e0 <trampoline>
    802043ea:	40f707b3          	sub	a5,a4,a5
    802043ee:	fcf43823          	sd	a5,-48(s0)
    register uint64 a0 asm("a0") = (uint64)TRAPFRAME;
    802043f2:	7579                	lui	a0,0xffffe
    register uint64 a1 asm("a1") = user_satp;
    802043f4:	fd843583          	ld	a1,-40(s0)
    register void (*tgt)(uint64, uint64) asm("t0") = (void *)userret_va;
    802043f8:	fd043783          	ld	a5,-48(s0)
    802043fc:	82be                	mv	t0,a5
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(tgt) : "memory");
    802043fe:	8282                	jr	t0
}
    80204400:	0001                	nop
    80204402:	70a2                	ld	ra,40(sp)
    80204404:	7402                	ld	s0,32(sp)
    80204406:	6145                	addi	sp,sp,48
    80204408:	8082                	ret

000000008020440a <write32>:
    8020440a:	7179                	addi	sp,sp,-48
    8020440c:	f406                	sd	ra,40(sp)
    8020440e:	f022                	sd	s0,32(sp)
    80204410:	1800                	addi	s0,sp,48
    80204412:	fca43c23          	sd	a0,-40(s0)
    80204416:	87ae                	mv	a5,a1
    80204418:	fcf42a23          	sw	a5,-44(s0)
    8020441c:	fd843783          	ld	a5,-40(s0)
    80204420:	8b8d                	andi	a5,a5,3
    80204422:	eb99                	bnez	a5,80204438 <write32+0x2e>
    80204424:	fd843783          	ld	a5,-40(s0)
    80204428:	fef43423          	sd	a5,-24(s0)
    8020442c:	fe843783          	ld	a5,-24(s0)
    80204430:	fd442703          	lw	a4,-44(s0)
    80204434:	c398                	sw	a4,0(a5)
    80204436:	a819                	j	8020444c <write32+0x42>
    80204438:	fd843583          	ld	a1,-40(s0)
    8020443c:	00006517          	auipc	a0,0x6
    80204440:	d1c50513          	addi	a0,a0,-740 # 8020a158 <simple_user_task_bin+0x58>
    80204444:	ffffd097          	auipc	ra,0xffffd
    80204448:	850080e7          	jalr	-1968(ra) # 80200c94 <printf>
    8020444c:	0001                	nop
    8020444e:	70a2                	ld	ra,40(sp)
    80204450:	7402                	ld	s0,32(sp)
    80204452:	6145                	addi	sp,sp,48
    80204454:	8082                	ret

0000000080204456 <read32>:
    80204456:	7179                	addi	sp,sp,-48
    80204458:	f406                	sd	ra,40(sp)
    8020445a:	f022                	sd	s0,32(sp)
    8020445c:	1800                	addi	s0,sp,48
    8020445e:	fca43c23          	sd	a0,-40(s0)
    80204462:	fd843783          	ld	a5,-40(s0)
    80204466:	8b8d                	andi	a5,a5,3
    80204468:	eb91                	bnez	a5,8020447c <read32+0x26>
    8020446a:	fd843783          	ld	a5,-40(s0)
    8020446e:	fef43423          	sd	a5,-24(s0)
    80204472:	fe843783          	ld	a5,-24(s0)
    80204476:	439c                	lw	a5,0(a5)
    80204478:	2781                	sext.w	a5,a5
    8020447a:	a821                	j	80204492 <read32+0x3c>
    8020447c:	fd843583          	ld	a1,-40(s0)
    80204480:	00006517          	auipc	a0,0x6
    80204484:	d0850513          	addi	a0,a0,-760 # 8020a188 <simple_user_task_bin+0x88>
    80204488:	ffffd097          	auipc	ra,0xffffd
    8020448c:	80c080e7          	jalr	-2036(ra) # 80200c94 <printf>
    80204490:	4781                	li	a5,0
    80204492:	853e                	mv	a0,a5
    80204494:	70a2                	ld	ra,40(sp)
    80204496:	7402                	ld	s0,32(sp)
    80204498:	6145                	addi	sp,sp,48
    8020449a:	8082                	ret

000000008020449c <plic_init>:
void plic_init(void) {
    8020449c:	1101                	addi	sp,sp,-32
    8020449e:	ec06                	sd	ra,24(sp)
    802044a0:	e822                	sd	s0,16(sp)
    802044a2:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    802044a4:	4785                	li	a5,1
    802044a6:	fef42623          	sw	a5,-20(s0)
    802044aa:	a805                	j	802044da <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    802044ac:	fec42783          	lw	a5,-20(s0)
    802044b0:	0027979b          	slliw	a5,a5,0x2
    802044b4:	2781                	sext.w	a5,a5
    802044b6:	873e                	mv	a4,a5
    802044b8:	0c0007b7          	lui	a5,0xc000
    802044bc:	97ba                	add	a5,a5,a4
    802044be:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    802044c2:	4581                	li	a1,0
    802044c4:	fe043503          	ld	a0,-32(s0)
    802044c8:	00000097          	auipc	ra,0x0
    802044cc:	f42080e7          	jalr	-190(ra) # 8020440a <write32>
    for (int i = 1; i <= 32; i++) {
    802044d0:	fec42783          	lw	a5,-20(s0)
    802044d4:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    802044d6:	fef42623          	sw	a5,-20(s0)
    802044da:	fec42783          	lw	a5,-20(s0)
    802044de:	0007871b          	sext.w	a4,a5
    802044e2:	02000793          	li	a5,32
    802044e6:	fce7d3e3          	bge	a5,a4,802044ac <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    802044ea:	4585                	li	a1,1
    802044ec:	0c0007b7          	lui	a5,0xc000
    802044f0:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    802044f4:	00000097          	auipc	ra,0x0
    802044f8:	f16080e7          	jalr	-234(ra) # 8020440a <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    802044fc:	4585                	li	a1,1
    802044fe:	0c0007b7          	lui	a5,0xc000
    80204502:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    80204506:	00000097          	auipc	ra,0x0
    8020450a:	f04080e7          	jalr	-252(ra) # 8020440a <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    8020450e:	40200593          	li	a1,1026
    80204512:	0c0027b7          	lui	a5,0xc002
    80204516:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    8020451a:	00000097          	auipc	ra,0x0
    8020451e:	ef0080e7          	jalr	-272(ra) # 8020440a <write32>
    write32(PLIC_THRESHOLD, 0);
    80204522:	4581                	li	a1,0
    80204524:	0c201537          	lui	a0,0xc201
    80204528:	00000097          	auipc	ra,0x0
    8020452c:	ee2080e7          	jalr	-286(ra) # 8020440a <write32>
}
    80204530:	0001                	nop
    80204532:	60e2                	ld	ra,24(sp)
    80204534:	6442                	ld	s0,16(sp)
    80204536:	6105                	addi	sp,sp,32
    80204538:	8082                	ret

000000008020453a <plic_enable>:
void plic_enable(int irq) {
    8020453a:	7179                	addi	sp,sp,-48
    8020453c:	f406                	sd	ra,40(sp)
    8020453e:	f022                	sd	s0,32(sp)
    80204540:	1800                	addi	s0,sp,48
    80204542:	87aa                	mv	a5,a0
    80204544:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204548:	0c0027b7          	lui	a5,0xc002
    8020454c:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204550:	00000097          	auipc	ra,0x0
    80204554:	f06080e7          	jalr	-250(ra) # 80204456 <read32>
    80204558:	87aa                	mv	a5,a0
    8020455a:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    8020455e:	fdc42783          	lw	a5,-36(s0)
    80204562:	873e                	mv	a4,a5
    80204564:	4785                	li	a5,1
    80204566:	00e797bb          	sllw	a5,a5,a4
    8020456a:	2781                	sext.w	a5,a5
    8020456c:	2781                	sext.w	a5,a5
    8020456e:	fec42703          	lw	a4,-20(s0)
    80204572:	8fd9                	or	a5,a5,a4
    80204574:	2781                	sext.w	a5,a5
    80204576:	85be                	mv	a1,a5
    80204578:	0c0027b7          	lui	a5,0xc002
    8020457c:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204580:	00000097          	auipc	ra,0x0
    80204584:	e8a080e7          	jalr	-374(ra) # 8020440a <write32>
}
    80204588:	0001                	nop
    8020458a:	70a2                	ld	ra,40(sp)
    8020458c:	7402                	ld	s0,32(sp)
    8020458e:	6145                	addi	sp,sp,48
    80204590:	8082                	ret

0000000080204592 <plic_disable>:
void plic_disable(int irq) {
    80204592:	7179                	addi	sp,sp,-48
    80204594:	f406                	sd	ra,40(sp)
    80204596:	f022                	sd	s0,32(sp)
    80204598:	1800                	addi	s0,sp,48
    8020459a:	87aa                	mv	a5,a0
    8020459c:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    802045a0:	0c0027b7          	lui	a5,0xc002
    802045a4:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802045a8:	00000097          	auipc	ra,0x0
    802045ac:	eae080e7          	jalr	-338(ra) # 80204456 <read32>
    802045b0:	87aa                	mv	a5,a0
    802045b2:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    802045b6:	fdc42783          	lw	a5,-36(s0)
    802045ba:	873e                	mv	a4,a5
    802045bc:	4785                	li	a5,1
    802045be:	00e797bb          	sllw	a5,a5,a4
    802045c2:	2781                	sext.w	a5,a5
    802045c4:	fff7c793          	not	a5,a5
    802045c8:	2781                	sext.w	a5,a5
    802045ca:	2781                	sext.w	a5,a5
    802045cc:	fec42703          	lw	a4,-20(s0)
    802045d0:	8ff9                	and	a5,a5,a4
    802045d2:	2781                	sext.w	a5,a5
    802045d4:	85be                	mv	a1,a5
    802045d6:	0c0027b7          	lui	a5,0xc002
    802045da:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802045de:	00000097          	auipc	ra,0x0
    802045e2:	e2c080e7          	jalr	-468(ra) # 8020440a <write32>
}
    802045e6:	0001                	nop
    802045e8:	70a2                	ld	ra,40(sp)
    802045ea:	7402                	ld	s0,32(sp)
    802045ec:	6145                	addi	sp,sp,48
    802045ee:	8082                	ret

00000000802045f0 <plic_claim>:
int plic_claim(void) {
    802045f0:	1141                	addi	sp,sp,-16
    802045f2:	e406                	sd	ra,8(sp)
    802045f4:	e022                	sd	s0,0(sp)
    802045f6:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    802045f8:	0c2017b7          	lui	a5,0xc201
    802045fc:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204600:	00000097          	auipc	ra,0x0
    80204604:	e56080e7          	jalr	-426(ra) # 80204456 <read32>
    80204608:	87aa                	mv	a5,a0
    8020460a:	2781                	sext.w	a5,a5
    8020460c:	2781                	sext.w	a5,a5
}
    8020460e:	853e                	mv	a0,a5
    80204610:	60a2                	ld	ra,8(sp)
    80204612:	6402                	ld	s0,0(sp)
    80204614:	0141                	addi	sp,sp,16
    80204616:	8082                	ret

0000000080204618 <plic_complete>:
void plic_complete(int irq) {
    80204618:	1101                	addi	sp,sp,-32
    8020461a:	ec06                	sd	ra,24(sp)
    8020461c:	e822                	sd	s0,16(sp)
    8020461e:	1000                	addi	s0,sp,32
    80204620:	87aa                	mv	a5,a0
    80204622:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    80204626:	fec42783          	lw	a5,-20(s0)
    8020462a:	85be                	mv	a1,a5
    8020462c:	0c2017b7          	lui	a5,0xc201
    80204630:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204634:	00000097          	auipc	ra,0x0
    80204638:	dd6080e7          	jalr	-554(ra) # 8020440a <write32>
    8020463c:	0001                	nop
    8020463e:	60e2                	ld	ra,24(sp)
    80204640:	6442                	ld	s0,16(sp)
    80204642:	6105                	addi	sp,sp,32
    80204644:	8082                	ret
	...

0000000080204650 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80204650:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80204652:	e006                	sd	ra,0(sp)
        sd gp, 16(sp)
    80204654:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80204656:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80204658:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8020465a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8020465c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    8020465e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80204660:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80204662:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80204664:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80204666:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80204668:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    8020466a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    8020466c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8020466e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80204670:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80204672:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80204674:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80204676:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80204678:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    8020467a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    8020467c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    8020467e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80204680:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80204682:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80204684:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80204686:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80204688:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    8020468a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    8020468c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    8020468e:	fffff097          	auipc	ra,0xfffff
    80204692:	270080e7          	jalr	624(ra) # 802038fe <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80204696:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80204698:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8020469a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8020469c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    8020469e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    802046a0:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    802046a2:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    802046a4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    802046a6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    802046a8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    802046aa:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    802046ac:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    802046ae:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    802046b0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    802046b2:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    802046b4:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    802046b6:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    802046b8:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    802046ba:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    802046bc:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    802046be:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    802046c0:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    802046c2:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    802046c4:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    802046c6:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    802046c8:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    802046ca:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    802046cc:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    802046ce:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    802046d0:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    802046d2:	10200073          	sret
    802046d6:	0001                	nop
    802046d8:	00000013          	nop
    802046dc:	00000013          	nop

00000000802046e0 <trampoline>:
trampoline:
.align 4

uservec:
    # 1. 取 trapframe 指针
    csrrw a0, sscratch, a0      # a0 = TRAPFRAME (用户页表下可访问), sscratch = user a0
    802046e0:	14051573          	csrrw	a0,sscratch,a0

    # 2. 在切换页表前，先读出关键字段到 t3–t6
    ld   t3, 0(a0)              # t3 = kernel_satp
    802046e4:	00053e03          	ld	t3,0(a0) # c201000 <_entry-0x73fff000>
    ld   t4, 8(a0)              # t4 = kernel_sp
    802046e8:	00853e83          	ld	t4,8(a0)
    ld   t5, 264(a0)            # t5 = usertrap
    802046ec:	10853f03          	ld	t5,264(a0)
	ld   t6, 272(a0)			# t6 = kernel_vec
    802046f0:	11053f83          	ld	t6,272(a0)

    # 3. 保存用户寄存器到 trapframe（仍在用户页表下）
    sd   ra, 48(a0)
    802046f4:	02153823          	sd	ra,48(a0)
    sd   sp, 56(a0)
    802046f8:	02253c23          	sd	sp,56(a0)
    sd   gp, 64(a0)
    802046fc:	04353023          	sd	gp,64(a0)
    sd   tp, 72(a0)
    80204700:	04453423          	sd	tp,72(a0)
    sd   t0, 80(a0)
    80204704:	04553823          	sd	t0,80(a0)
    sd   t1, 88(a0)
    80204708:	04653c23          	sd	t1,88(a0)
    sd   t2, 96(a0)
    8020470c:	06753023          	sd	t2,96(a0)
    sd   s0, 104(a0)
    80204710:	f520                	sd	s0,104(a0)
    sd   s1, 112(a0)
    80204712:	f924                	sd	s1,112(a0)

    # 保存用户 a0：先取回 sscratch 里的原值
    csrr t2, sscratch
    80204714:	140023f3          	csrr	t2,sscratch
    sd   t2, 120(a0)
    80204718:	06753c23          	sd	t2,120(a0)

    sd   a1, 128(a0)
    8020471c:	e14c                	sd	a1,128(a0)
    sd   a2, 136(a0)
    8020471e:	e550                	sd	a2,136(a0)
    sd   a3, 144(a0)
    80204720:	e954                	sd	a3,144(a0)
    sd   a4, 152(a0)
    80204722:	ed58                	sd	a4,152(a0)
    sd   a5, 160(a0)
    80204724:	f15c                	sd	a5,160(a0)
    sd   a6, 168(a0)
    80204726:	0b053423          	sd	a6,168(a0)
    sd   a7, 176(a0)
    8020472a:	0b153823          	sd	a7,176(a0)
    sd   s2, 184(a0)
    8020472e:	0b253c23          	sd	s2,184(a0)
    sd   s3, 192(a0)
    80204732:	0d353023          	sd	s3,192(a0)
    sd   s4, 200(a0)
    80204736:	0d453423          	sd	s4,200(a0)
    sd   s5, 208(a0)
    8020473a:	0d553823          	sd	s5,208(a0)
    sd   s6, 216(a0)
    8020473e:	0d653c23          	sd	s6,216(a0)
    sd   s7, 224(a0)
    80204742:	0f753023          	sd	s7,224(a0)
    sd   s8, 232(a0)
    80204746:	0f853423          	sd	s8,232(a0)
    sd   s9, 240(a0)
    8020474a:	0f953823          	sd	s9,240(a0)
    sd   s10, 248(a0)
    8020474e:	0fa53c23          	sd	s10,248(a0)
    sd   s11, 256(a0)
    80204752:	11b53023          	sd	s11,256(a0)

    # 保存控制寄存器
    csrr t0, sstatus
    80204756:	100022f3          	csrr	t0,sstatus
    sd   t0, 24(a0)
    8020475a:	00553c23          	sd	t0,24(a0)
    csrr t1, sepc
    8020475e:	14102373          	csrr	t1,sepc
    sd   t1, 32(a0)
    80204762:	02653023          	sd	t1,32(a0)

    # 4. 切换到内核页表
    csrw satp, t3
    80204766:	180e1073          	csrw	satp,t3
    sfence.vma x0, x0
    8020476a:	12000073          	sfence.vma

    # 5. 切换到内核栈
    mv   sp, t4
    8020476e:	8176                	mv	sp,t4

    # 6. 设置 stvec 并跳转到 C 层 usertrap
    csrw stvec, t6
    80204770:	105f9073          	csrw	stvec,t6
    jr   t5
    80204774:	8f02                	jr	t5

0000000080204776 <userret>:
userret:
        csrw satp, a1
    80204776:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    8020477a:	12000073          	sfence.vma
        ld ra, 48(a0)
    8020477e:	03053083          	ld	ra,48(a0)
        ld sp, 56(a0)
    80204782:	03853103          	ld	sp,56(a0)
        ld gp, 64(a0)
    80204786:	04053183          	ld	gp,64(a0)
        ld tp, 72(a0)
    8020478a:	04853203          	ld	tp,72(a0)
        ld t0, 80(a0)
    8020478e:	05053283          	ld	t0,80(a0)
        ld t1, 88(a0)
    80204792:	05853303          	ld	t1,88(a0)
        ld t2, 96(a0)
    80204796:	06053383          	ld	t2,96(a0)
        ld s0, 104(a0)
    8020479a:	7520                	ld	s0,104(a0)
        ld s1, 112(a0)
    8020479c:	7924                	ld	s1,112(a0)
        ld a1, 128(a0)
    8020479e:	614c                	ld	a1,128(a0)
        ld a2, 136(a0)
    802047a0:	6550                	ld	a2,136(a0)
        ld a3, 144(a0)
    802047a2:	6954                	ld	a3,144(a0)
        ld a4, 152(a0)
    802047a4:	6d58                	ld	a4,152(a0)
        ld a5, 160(a0)
    802047a6:	715c                	ld	a5,160(a0)
        ld a6, 168(a0)
    802047a8:	0a853803          	ld	a6,168(a0)
        ld a7, 176(a0)
    802047ac:	0b053883          	ld	a7,176(a0)
        ld s2, 184(a0)
    802047b0:	0b853903          	ld	s2,184(a0)
        ld s3, 192(a0)
    802047b4:	0c053983          	ld	s3,192(a0)
        ld s4, 200(a0)
    802047b8:	0c853a03          	ld	s4,200(a0)
        ld s5, 208(a0)
    802047bc:	0d053a83          	ld	s5,208(a0)
        ld s6, 216(a0)
    802047c0:	0d853b03          	ld	s6,216(a0)
        ld s7, 224(a0)
    802047c4:	0e053b83          	ld	s7,224(a0)
        ld s8, 232(a0)
    802047c8:	0e853c03          	ld	s8,232(a0)
        ld s9, 240(a0)
    802047cc:	0f053c83          	ld	s9,240(a0)
        ld s10, 248(a0)
    802047d0:	0f853d03          	ld	s10,248(a0)
        ld s11, 256(a0)
    802047d4:	10053d83          	ld	s11,256(a0)

        ld t3, 32(a0)      # 恢复 sepc
    802047d8:	02053e03          	ld	t3,32(a0)
        csrw sepc, t3
    802047dc:	141e1073          	csrw	sepc,t3
        ld t3, 24(a0)      # 恢复 sstatus
    802047e0:	01853e03          	ld	t3,24(a0)
        csrw sstatus, t3
    802047e4:	100e1073          	csrw	sstatus,t3
		csrw sscratch, a0
    802047e8:	14051073          	csrw	sscratch,a0
		ld a0, 120(a0)
    802047ec:	7d28                	ld	a0,120(a0)
    802047ee:	10200073          	sret
    802047f2:	0001                	nop
    802047f4:	00000013          	nop
    802047f8:	00000013          	nop
    802047fc:	00000013          	nop

0000000080204800 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80204800:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80204804:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80204808:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8020480a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8020480c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80204810:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80204814:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80204818:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8020481c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80204820:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80204824:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80204828:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8020482c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80204830:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80204834:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80204838:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8020483c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8020483e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80204840:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80204844:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80204848:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8020484c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80204850:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80204854:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80204858:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8020485c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80204860:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80204864:	0685bd83          	ld	s11,104(a1)
        
        ret
    80204868:	8082                	ret

000000008020486a <r_sstatus>:
    for(int i = 0; i < PROC; i++) {
        struct proc *p = proc_table[i];
      	if(p->state == RUNNABLE) {
			p->state = RUNNING;
			c->proc = p;
			current_proc = p;
    8020486a:	1101                	addi	sp,sp,-32
    8020486c:	ec22                	sd	s0,24(sp)
    8020486e:	1000                	addi	s0,sp,32
			swtch(&c->context, &p->context);
			c = mycpu();
    80204870:	100027f3          	csrr	a5,sstatus
    80204874:	fef43423          	sd	a5,-24(s0)
			c->proc = 0;
    80204878:	fe843783          	ld	a5,-24(s0)
			current_proc = 0;
    8020487c:	853e                	mv	a0,a5
    8020487e:	6462                	ld	s0,24(sp)
    80204880:	6105                	addi	sp,sp,32
    80204882:	8082                	ret

0000000080204884 <w_sstatus>:
      }
    80204884:	1101                	addi	sp,sp,-32
    80204886:	ec22                	sd	s0,24(sp)
    80204888:	1000                	addi	s0,sp,32
    8020488a:	fea43423          	sd	a0,-24(s0)
    }
    8020488e:	fe843783          	ld	a5,-24(s0)
    80204892:	10079073          	csrw	sstatus,a5
  }
    80204896:	0001                	nop
    80204898:	6462                	ld	s0,24(sp)
    8020489a:	6105                	addi	sp,sp,32
    8020489c:	8082                	ret

000000008020489e <intr_on>:
    struct proc *p = myproc();
    if (p == 0) {
        return;
    }
    if (p->state != RUNNING) {
        warning("yield when status is not RUNNING (%d)\n", p->state);
    8020489e:	1141                	addi	sp,sp,-16
    802048a0:	e406                	sd	ra,8(sp)
    802048a2:	e022                	sd	s0,0(sp)
    802048a4:	0800                	addi	s0,sp,16
        return;
    802048a6:	00000097          	auipc	ra,0x0
    802048aa:	fc4080e7          	jalr	-60(ra) # 8020486a <r_sstatus>
    802048ae:	87aa                	mv	a5,a0
    802048b0:	0027e793          	ori	a5,a5,2
    802048b4:	853e                	mv	a0,a5
    802048b6:	00000097          	auipc	ra,0x0
    802048ba:	fce080e7          	jalr	-50(ra) # 80204884 <w_sstatus>
    }
    802048be:	0001                	nop
    802048c0:	60a2                	ld	ra,8(sp)
    802048c2:	6402                	ld	s0,0(sp)
    802048c4:	0141                	addi	sp,sp,16
    802048c6:	8082                	ret

00000000802048c8 <intr_off>:
    intr_off();
    struct cpu *c = mycpu();
    802048c8:	1141                	addi	sp,sp,-16
    802048ca:	e406                	sd	ra,8(sp)
    802048cc:	e022                	sd	s0,0(sp)
    802048ce:	0800                	addi	s0,sp,16
    p->state = RUNNABLE;
    802048d0:	00000097          	auipc	ra,0x0
    802048d4:	f9a080e7          	jalr	-102(ra) # 8020486a <r_sstatus>
    802048d8:	87aa                	mv	a5,a0
    802048da:	9bf5                	andi	a5,a5,-3
    802048dc:	853e                	mv	a0,a5
    802048de:	00000097          	auipc	ra,0x0
    802048e2:	fa6080e7          	jalr	-90(ra) # 80204884 <w_sstatus>
    register uint64 ra asm("ra");
    802048e6:	0001                	nop
    802048e8:	60a2                	ld	ra,8(sp)
    802048ea:	6402                	ld	s0,0(sp)
    802048ec:	0141                	addi	sp,sp,16
    802048ee:	8082                	ret

00000000802048f0 <w_stvec>:
    p->context.ra = ra;
    if (c->context.ra == 0) {
    802048f0:	1101                	addi	sp,sp,-32
    802048f2:	ec22                	sd	s0,24(sp)
    802048f4:	1000                	addi	s0,sp,32
    802048f6:	fea43423          	sd	a0,-24(s0)
        c->context.ra = (uint64)schedule;
    802048fa:	fe843783          	ld	a5,-24(s0)
    802048fe:	10579073          	csrw	stvec,a5
        c->context.sp = (uint64)c + PGSIZE;
    80204902:	0001                	nop
    80204904:	6462                	ld	s0,24(sp)
    80204906:	6105                	addi	sp,sp,32
    80204908:	8082                	ret

000000008020490a <assert>:
    p->state = ZOMBIE;
    
    wakeup((void*)p->parent);
    // 清除当前进程
    current_proc = 0;
    if (mycpu())
    8020490a:	1101                	addi	sp,sp,-32
    8020490c:	ec06                	sd	ra,24(sp)
    8020490e:	e822                	sd	s0,16(sp)
    80204910:	1000                	addi	s0,sp,32
    80204912:	87aa                	mv	a5,a0
    80204914:	fef42623          	sw	a5,-20(s0)
        mycpu()->proc = 0;
    80204918:	fec42783          	lw	a5,-20(s0)
    8020491c:	2781                	sext.w	a5,a5
    8020491e:	e79d                	bnez	a5,8020494c <assert+0x42>
    
    80204920:	19c00613          	li	a2,412
    80204924:	00006597          	auipc	a1,0x6
    80204928:	ae458593          	addi	a1,a1,-1308 # 8020a408 <simple_user_task_bin+0x58>
    8020492c:	00006517          	auipc	a0,0x6
    80204930:	aec50513          	addi	a0,a0,-1300 # 8020a418 <simple_user_task_bin+0x68>
    80204934:	ffffc097          	auipc	ra,0xffffc
    80204938:	360080e7          	jalr	864(ra) # 80200c94 <printf>
    // 让出CPU给其他进程
    8020493c:	00006517          	auipc	a0,0x6
    80204940:	b0450513          	addi	a0,a0,-1276 # 8020a440 <simple_user_task_bin+0x90>
    80204944:	ffffd097          	auipc	ra,0xffffd
    80204948:	d9c080e7          	jalr	-612(ra) # 802016e0 <panic>
    struct cpu *c = mycpu();
    swtch(&p->context, &c->context);
    8020494c:	0001                	nop
    8020494e:	60e2                	ld	ra,24(sp)
    80204950:	6442                	ld	s0,16(sp)
    80204952:	6105                	addi	sp,sp,32
    80204954:	8082                	ret

0000000080204956 <shutdown>:
void shutdown() {
    80204956:	1141                	addi	sp,sp,-16
    80204958:	e406                	sd	ra,8(sp)
    8020495a:	e022                	sd	s0,0(sp)
    8020495c:	0800                	addi	s0,sp,16
	free_proc_table();
    8020495e:	00000097          	auipc	ra,0x0
    80204962:	494080e7          	jalr	1172(ra) # 80204df2 <free_proc_table>
    printf("关机\n");
    80204966:	00006517          	auipc	a0,0x6
    8020496a:	ae250513          	addi	a0,a0,-1310 # 8020a448 <simple_user_task_bin+0x98>
    8020496e:	ffffc097          	auipc	ra,0xffffc
    80204972:	326080e7          	jalr	806(ra) # 80200c94 <printf>
    asm volatile (
    80204976:	48a1                	li	a7,8
    80204978:	00000073          	ecall
    while (1) { }
    8020497c:	0001                	nop
    8020497e:	bffd                	j	8020497c <shutdown+0x26>

0000000080204980 <myproc>:
struct proc* myproc(void) {
    80204980:	1141                	addi	sp,sp,-16
    80204982:	e422                	sd	s0,8(sp)
    80204984:	0800                	addi	s0,sp,16
    return current_proc;
    80204986:	00009797          	auipc	a5,0x9
    8020498a:	72278793          	addi	a5,a5,1826 # 8020e0a8 <current_proc>
    8020498e:	639c                	ld	a5,0(a5)
}
    80204990:	853e                	mv	a0,a5
    80204992:	6422                	ld	s0,8(sp)
    80204994:	0141                	addi	sp,sp,16
    80204996:	8082                	ret

0000000080204998 <mycpu>:
struct cpu* mycpu(void) {
    80204998:	1141                	addi	sp,sp,-16
    8020499a:	e406                	sd	ra,8(sp)
    8020499c:	e022                	sd	s0,0(sp)
    8020499e:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    802049a0:	00009797          	auipc	a5,0x9
    802049a4:	71078793          	addi	a5,a5,1808 # 8020e0b0 <current_cpu>
    802049a8:	639c                	ld	a5,0(a5)
    802049aa:	ebb9                	bnez	a5,80204a00 <mycpu+0x68>
        warning("current_cpu is NULL, initializing...\n");
    802049ac:	00006517          	auipc	a0,0x6
    802049b0:	aa450513          	addi	a0,a0,-1372 # 8020a450 <simple_user_task_bin+0xa0>
    802049b4:	ffffd097          	auipc	ra,0xffffd
    802049b8:	d60080e7          	jalr	-672(ra) # 80201714 <warning>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    802049bc:	07800613          	li	a2,120
    802049c0:	4581                	li	a1,0
    802049c2:	0000a517          	auipc	a0,0xa
    802049c6:	cae50513          	addi	a0,a0,-850 # 8020e670 <cpu_instance.1>
    802049ca:	ffffd097          	auipc	ra,0xffffd
    802049ce:	454080e7          	jalr	1108(ra) # 80201e1e <memset>
		current_cpu = &cpu_instance;
    802049d2:	00009797          	auipc	a5,0x9
    802049d6:	6de78793          	addi	a5,a5,1758 # 8020e0b0 <current_cpu>
    802049da:	0000a717          	auipc	a4,0xa
    802049de:	c9670713          	addi	a4,a4,-874 # 8020e670 <cpu_instance.1>
    802049e2:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    802049e4:	00009797          	auipc	a5,0x9
    802049e8:	6cc78793          	addi	a5,a5,1740 # 8020e0b0 <current_cpu>
    802049ec:	639c                	ld	a5,0(a5)
    802049ee:	85be                	mv	a1,a5
    802049f0:	00006517          	auipc	a0,0x6
    802049f4:	a8850513          	addi	a0,a0,-1400 # 8020a478 <simple_user_task_bin+0xc8>
    802049f8:	ffffc097          	auipc	ra,0xffffc
    802049fc:	29c080e7          	jalr	668(ra) # 80200c94 <printf>
    return current_cpu;
    80204a00:	00009797          	auipc	a5,0x9
    80204a04:	6b078793          	addi	a5,a5,1712 # 8020e0b0 <current_cpu>
    80204a08:	639c                	ld	a5,0(a5)
}
    80204a0a:	853e                	mv	a0,a5
    80204a0c:	60a2                	ld	ra,8(sp)
    80204a0e:	6402                	ld	s0,0(sp)
    80204a10:	0141                	addi	sp,sp,16
    80204a12:	8082                	ret

0000000080204a14 <return_to_user>:
void return_to_user(void) {
    80204a14:	7139                	addi	sp,sp,-64
    80204a16:	fc06                	sd	ra,56(sp)
    80204a18:	f822                	sd	s0,48(sp)
    80204a1a:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80204a1c:	00000097          	auipc	ra,0x0
    80204a20:	f64080e7          	jalr	-156(ra) # 80204980 <myproc>
    80204a24:	fea43423          	sd	a0,-24(s0)
    if (!p) panic("return_to_user: no current process");
    80204a28:	fe843783          	ld	a5,-24(s0)
    80204a2c:	eb89                	bnez	a5,80204a3e <return_to_user+0x2a>
    80204a2e:	00006517          	auipc	a0,0x6
    80204a32:	a6250513          	addi	a0,a0,-1438 # 8020a490 <simple_user_task_bin+0xe0>
    80204a36:	ffffd097          	auipc	ra,0xffffd
    80204a3a:	caa080e7          	jalr	-854(ra) # 802016e0 <panic>
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    80204a3e:	00000717          	auipc	a4,0x0
    80204a42:	ca270713          	addi	a4,a4,-862 # 802046e0 <trampoline>
    80204a46:	00000797          	auipc	a5,0x0
    80204a4a:	c9a78793          	addi	a5,a5,-870 # 802046e0 <trampoline>
    80204a4e:	40f707b3          	sub	a5,a4,a5
    80204a52:	873e                	mv	a4,a5
    80204a54:	77fd                	lui	a5,0xfffff
    80204a56:	97ba                	add	a5,a5,a4
    80204a58:	853e                	mv	a0,a5
    80204a5a:	00000097          	auipc	ra,0x0
    80204a5e:	e96080e7          	jalr	-362(ra) # 802048f0 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80204a62:	00000717          	auipc	a4,0x0
    80204a66:	d1470713          	addi	a4,a4,-748 # 80204776 <userret>
    80204a6a:	00000797          	auipc	a5,0x0
    80204a6e:	c7678793          	addi	a5,a5,-906 # 802046e0 <trampoline>
    80204a72:	40f707b3          	sub	a5,a4,a5
    80204a76:	873e                	mv	a4,a5
    80204a78:	77fd                	lui	a5,0xfffff
    80204a7a:	97ba                	add	a5,a5,a4
    80204a7c:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    80204a80:	fe843783          	ld	a5,-24(s0)
    80204a84:	7fdc                	ld	a5,184(a5)
    80204a86:	00c7d713          	srli	a4,a5,0xc
    80204a8a:	57fd                	li	a5,-1
    80204a8c:	17fe                	slli	a5,a5,0x3f
    80204a8e:	8fd9                	or	a5,a5,a4
    80204a90:	fcf43c23          	sd	a5,-40(s0)
    if ((trampoline_userret & ~(PGSIZE - 1)) != TRAMPOLINE) {
    80204a94:	fe043703          	ld	a4,-32(s0)
    80204a98:	77fd                	lui	a5,0xfffff
    80204a9a:	8f7d                	and	a4,a4,a5
    80204a9c:	77fd                	lui	a5,0xfffff
    80204a9e:	00f70a63          	beq	a4,a5,80204ab2 <return_to_user+0x9e>
        panic("return_to_user: userret outside trampoline page");
    80204aa2:	00006517          	auipc	a0,0x6
    80204aa6:	a1650513          	addi	a0,a0,-1514 # 8020a4b8 <simple_user_task_bin+0x108>
    80204aaa:	ffffd097          	auipc	ra,0xffffd
    80204aae:	c36080e7          	jalr	-970(ra) # 802016e0 <panic>
    printf("[return_to_user] pid=%d\n", p->pid);
    80204ab2:	fe843783          	ld	a5,-24(s0)
    80204ab6:	43dc                	lw	a5,4(a5)
    80204ab8:	85be                	mv	a1,a5
    80204aba:	00006517          	auipc	a0,0x6
    80204abe:	a2e50513          	addi	a0,a0,-1490 # 8020a4e8 <simple_user_task_bin+0x138>
    80204ac2:	ffffc097          	auipc	ra,0xffffc
    80204ac6:	1d2080e7          	jalr	466(ra) # 80200c94 <printf>
    printf("[return_to_user] trapframe kva=%p pa=0x%lx TRAPFRAME=0x%lx\n",
    80204aca:	fe843783          	ld	a5,-24(s0)
    80204ace:	63f8                	ld	a4,192(a5)
           p->trapframe, VA2PA((uint64)p->trapframe), (uint64)TRAPFRAME);
    80204ad0:	fe843783          	ld	a5,-24(s0)
    80204ad4:	63fc                	ld	a5,192(a5)
    printf("[return_to_user] trapframe kva=%p pa=0x%lx TRAPFRAME=0x%lx\n",
    80204ad6:	76f9                	lui	a3,0xffffe
    80204ad8:	863e                	mv	a2,a5
    80204ada:	85ba                	mv	a1,a4
    80204adc:	00006517          	auipc	a0,0x6
    80204ae0:	a2c50513          	addi	a0,a0,-1492 # 8020a508 <simple_user_task_bin+0x158>
    80204ae4:	ffffc097          	auipc	ra,0xffffc
    80204ae8:	1b0080e7          	jalr	432(ra) # 80200c94 <printf>
    pte_t *pte_tf = walk_lookup(p->pagetable, TRAPFRAME);
    80204aec:	fe843783          	ld	a5,-24(s0)
    80204af0:	7fdc                	ld	a5,184(a5)
    80204af2:	75f9                	lui	a1,0xffffe
    80204af4:	853e                	mv	a0,a5
    80204af6:	ffffd097          	auipc	ra,0xffffd
    80204afa:	5c0080e7          	jalr	1472(ra) # 802020b6 <walk_lookup>
    80204afe:	fca43823          	sd	a0,-48(s0)
    if (pte_tf && (*pte_tf & PTE_V)) {
    80204b02:	fd043783          	ld	a5,-48(s0)
    80204b06:	cf9d                	beqz	a5,80204b44 <return_to_user+0x130>
    80204b08:	fd043783          	ld	a5,-48(s0)
    80204b0c:	639c                	ld	a5,0(a5)
    80204b0e:	8b85                	andi	a5,a5,1
    80204b10:	cb95                	beqz	a5,80204b44 <return_to_user+0x130>
        printf("[return_to_user] TRAPFRAME PTE=0x%lx pa=0x%lx flags=0x%lx\n",
    80204b12:	fd043783          	ld	a5,-48(s0)
    80204b16:	6398                	ld	a4,0(a5)
               *pte_tf, PTE2PA(*pte_tf), PTE_FLAGS(*pte_tf));
    80204b18:	fd043783          	ld	a5,-48(s0)
    80204b1c:	639c                	ld	a5,0(a5)
    80204b1e:	83a9                	srli	a5,a5,0xa
        printf("[return_to_user] TRAPFRAME PTE=0x%lx pa=0x%lx flags=0x%lx\n",
    80204b20:	00c79613          	slli	a2,a5,0xc
               *pte_tf, PTE2PA(*pte_tf), PTE_FLAGS(*pte_tf));
    80204b24:	fd043783          	ld	a5,-48(s0)
    80204b28:	639c                	ld	a5,0(a5)
        printf("[return_to_user] TRAPFRAME PTE=0x%lx pa=0x%lx flags=0x%lx\n",
    80204b2a:	3ff7f793          	andi	a5,a5,1023
    80204b2e:	86be                	mv	a3,a5
    80204b30:	85ba                	mv	a1,a4
    80204b32:	00006517          	auipc	a0,0x6
    80204b36:	a1650513          	addi	a0,a0,-1514 # 8020a548 <simple_user_task_bin+0x198>
    80204b3a:	ffffc097          	auipc	ra,0xffffc
    80204b3e:	15a080e7          	jalr	346(ra) # 80200c94 <printf>
    80204b42:	a809                	j	80204b54 <return_to_user+0x140>
        printf("[return_to_user] TRAPFRAME not mapped!\n");
    80204b44:	00006517          	auipc	a0,0x6
    80204b48:	a4450513          	addi	a0,a0,-1468 # 8020a588 <simple_user_task_bin+0x1d8>
    80204b4c:	ffffc097          	auipc	ra,0xffffc
    80204b50:	148080e7          	jalr	328(ra) # 80200c94 <printf>
    pte_t *pte_tr = walk_lookup(p->pagetable, TRAMPOLINE);
    80204b54:	fe843783          	ld	a5,-24(s0)
    80204b58:	7fdc                	ld	a5,184(a5)
    80204b5a:	75fd                	lui	a1,0xfffff
    80204b5c:	853e                	mv	a0,a5
    80204b5e:	ffffd097          	auipc	ra,0xffffd
    80204b62:	558080e7          	jalr	1368(ra) # 802020b6 <walk_lookup>
    80204b66:	fca43423          	sd	a0,-56(s0)
    if (pte_tr && (*pte_tr & PTE_V)) {
    80204b6a:	fc843783          	ld	a5,-56(s0)
    80204b6e:	cf9d                	beqz	a5,80204bac <return_to_user+0x198>
    80204b70:	fc843783          	ld	a5,-56(s0)
    80204b74:	639c                	ld	a5,0(a5)
    80204b76:	8b85                	andi	a5,a5,1
    80204b78:	cb95                	beqz	a5,80204bac <return_to_user+0x198>
        printf("[return_to_user] TRAMPOLINE PTE=0x%lx pa=0x%lx flags=0x%lx\n",
    80204b7a:	fc843783          	ld	a5,-56(s0)
    80204b7e:	6398                	ld	a4,0(a5)
               *pte_tr, PTE2PA(*pte_tr), PTE_FLAGS(*pte_tr));
    80204b80:	fc843783          	ld	a5,-56(s0)
    80204b84:	639c                	ld	a5,0(a5)
    80204b86:	83a9                	srli	a5,a5,0xa
        printf("[return_to_user] TRAMPOLINE PTE=0x%lx pa=0x%lx flags=0x%lx\n",
    80204b88:	00c79613          	slli	a2,a5,0xc
               *pte_tr, PTE2PA(*pte_tr), PTE_FLAGS(*pte_tr));
    80204b8c:	fc843783          	ld	a5,-56(s0)
    80204b90:	639c                	ld	a5,0(a5)
        printf("[return_to_user] TRAMPOLINE PTE=0x%lx pa=0x%lx flags=0x%lx\n",
    80204b92:	3ff7f793          	andi	a5,a5,1023
    80204b96:	86be                	mv	a3,a5
    80204b98:	85ba                	mv	a1,a4
    80204b9a:	00006517          	auipc	a0,0x6
    80204b9e:	a1650513          	addi	a0,a0,-1514 # 8020a5b0 <simple_user_task_bin+0x200>
    80204ba2:	ffffc097          	auipc	ra,0xffffc
    80204ba6:	0f2080e7          	jalr	242(ra) # 80200c94 <printf>
    80204baa:	a809                	j	80204bbc <return_to_user+0x1a8>
        printf("[return_to_user] TRAMPOLINE not mapped!\n");
    80204bac:	00006517          	auipc	a0,0x6
    80204bb0:	a4450513          	addi	a0,a0,-1468 # 8020a5f0 <simple_user_task_bin+0x240>
    80204bb4:	ffffc097          	auipc	ra,0xffffc
    80204bb8:	0e0080e7          	jalr	224(ra) # 80200c94 <printf>
    printf("[return_to_user] satp=0x%lx trampoline_userret=0x%lx\n",
    80204bbc:	fe043603          	ld	a2,-32(s0)
    80204bc0:	fd843583          	ld	a1,-40(s0)
    80204bc4:	00006517          	auipc	a0,0x6
    80204bc8:	a5c50513          	addi	a0,a0,-1444 # 8020a620 <simple_user_task_bin+0x270>
    80204bcc:	ffffc097          	auipc	ra,0xffffc
    80204bd0:	0c8080e7          	jalr	200(ra) # 80200c94 <printf>
    void (*userret_fn)(uint64, uint64) = (void (*)(uint64, uint64))trampoline_userret;
    80204bd4:	fe043783          	ld	a5,-32(s0)
    80204bd8:	fcf43023          	sd	a5,-64(s0)
    userret_fn(TRAPFRAME, satp);
    80204bdc:	fc043783          	ld	a5,-64(s0)
    80204be0:	fd843583          	ld	a1,-40(s0)
    80204be4:	7579                	lui	a0,0xffffe
    80204be6:	9782                	jalr	a5
    panic("return_to_user: should not return");
    80204be8:	00006517          	auipc	a0,0x6
    80204bec:	a7050513          	addi	a0,a0,-1424 # 8020a658 <simple_user_task_bin+0x2a8>
    80204bf0:	ffffd097          	auipc	ra,0xffffd
    80204bf4:	af0080e7          	jalr	-1296(ra) # 802016e0 <panic>
}
    80204bf8:	0001                	nop
    80204bfa:	70e2                	ld	ra,56(sp)
    80204bfc:	7442                	ld	s0,48(sp)
    80204bfe:	6121                	addi	sp,sp,64
    80204c00:	8082                	ret

0000000080204c02 <forkret>:
void forkret(void) {
    80204c02:	1101                	addi	sp,sp,-32
    80204c04:	ec06                	sd	ra,24(sp)
    80204c06:	e822                	sd	s0,16(sp)
    80204c08:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80204c0a:	00000097          	auipc	ra,0x0
    80204c0e:	d76080e7          	jalr	-650(ra) # 80204980 <myproc>
    80204c12:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80204c16:	fe843783          	ld	a5,-24(s0)
    80204c1a:	eb89                	bnez	a5,80204c2c <forkret+0x2a>
        panic("forkret: no current process");
    80204c1c:	00006517          	auipc	a0,0x6
    80204c20:	a6450513          	addi	a0,a0,-1436 # 8020a680 <simple_user_task_bin+0x2d0>
    80204c24:	ffffd097          	auipc	ra,0xffffd
    80204c28:	abc080e7          	jalr	-1348(ra) # 802016e0 <panic>
    if (p->is_user) {
    80204c2c:	fe843783          	ld	a5,-24(s0)
    80204c30:	0a87a783          	lw	a5,168(a5) # fffffffffffff0a8 <_bss_end+0xffffffff7fdf09a8>
    80204c34:	c791                	beqz	a5,80204c40 <forkret+0x3e>
        return_to_user();
    80204c36:	00000097          	auipc	ra,0x0
    80204c3a:	dde080e7          	jalr	-546(ra) # 80204a14 <return_to_user>
}
    80204c3e:	a025                	j	80204c66 <forkret+0x64>
        if (p->trapframe->epc) {
    80204c40:	fe843783          	ld	a5,-24(s0)
    80204c44:	63fc                	ld	a5,192(a5)
    80204c46:	739c                	ld	a5,32(a5)
    80204c48:	cb91                	beqz	a5,80204c5c <forkret+0x5a>
            void (*fn)(void) = (void(*)(void))p->trapframe->epc;
    80204c4a:	fe843783          	ld	a5,-24(s0)
    80204c4e:	63fc                	ld	a5,192(a5)
    80204c50:	739c                	ld	a5,32(a5)
    80204c52:	fef43023          	sd	a5,-32(s0)
            fn();
    80204c56:	fe043783          	ld	a5,-32(s0)
    80204c5a:	9782                	jalr	a5
        exit_proc(0);  // 内核线程函数返回则退出
    80204c5c:	4501                	li	a0,0
    80204c5e:	00001097          	auipc	ra,0x1
    80204c62:	b42080e7          	jalr	-1214(ra) # 802057a0 <exit_proc>
}
    80204c66:	0001                	nop
    80204c68:	60e2                	ld	ra,24(sp)
    80204c6a:	6442                	ld	s0,16(sp)
    80204c6c:	6105                	addi	sp,sp,32
    80204c6e:	8082                	ret

0000000080204c70 <init_proc>:
void init_proc(void){
    80204c70:	1101                	addi	sp,sp,-32
    80204c72:	ec06                	sd	ra,24(sp)
    80204c74:	e822                	sd	s0,16(sp)
    80204c76:	1000                	addi	s0,sp,32
    for (int i = 0; i < PROC; i++) {
    80204c78:	fe042623          	sw	zero,-20(s0)
    80204c7c:	aa81                	j	80204dcc <init_proc+0x15c>
        void *page = alloc_page();
    80204c7e:	ffffe097          	auipc	ra,0xffffe
    80204c82:	5a8080e7          	jalr	1448(ra) # 80203226 <alloc_page>
    80204c86:	fea43023          	sd	a0,-32(s0)
        if (!page) panic("init_proc: alloc_page failed for proc_table");
    80204c8a:	fe043783          	ld	a5,-32(s0)
    80204c8e:	eb89                	bnez	a5,80204ca0 <init_proc+0x30>
    80204c90:	00006517          	auipc	a0,0x6
    80204c94:	a1050513          	addi	a0,a0,-1520 # 8020a6a0 <simple_user_task_bin+0x2f0>
    80204c98:	ffffd097          	auipc	ra,0xffffd
    80204c9c:	a48080e7          	jalr	-1464(ra) # 802016e0 <panic>
        proc_table_mem[i] = page;
    80204ca0:	0000a717          	auipc	a4,0xa
    80204ca4:	8d070713          	addi	a4,a4,-1840 # 8020e570 <proc_table_mem>
    80204ca8:	fec42783          	lw	a5,-20(s0)
    80204cac:	078e                	slli	a5,a5,0x3
    80204cae:	97ba                	add	a5,a5,a4
    80204cb0:	fe043703          	ld	a4,-32(s0)
    80204cb4:	e398                	sd	a4,0(a5)
        proc_table[i] = (struct proc *)page;
    80204cb6:	00009717          	auipc	a4,0x9
    80204cba:	7b270713          	addi	a4,a4,1970 # 8020e468 <proc_table>
    80204cbe:	fec42783          	lw	a5,-20(s0)
    80204cc2:	078e                	slli	a5,a5,0x3
    80204cc4:	97ba                	add	a5,a5,a4
    80204cc6:	fe043703          	ld	a4,-32(s0)
    80204cca:	e398                	sd	a4,0(a5)
        memset(proc_table[i], 0, sizeof(struct proc));
    80204ccc:	00009717          	auipc	a4,0x9
    80204cd0:	79c70713          	addi	a4,a4,1948 # 8020e468 <proc_table>
    80204cd4:	fec42783          	lw	a5,-20(s0)
    80204cd8:	078e                	slli	a5,a5,0x3
    80204cda:	97ba                	add	a5,a5,a4
    80204cdc:	639c                	ld	a5,0(a5)
    80204cde:	0c800613          	li	a2,200
    80204ce2:	4581                	li	a1,0
    80204ce4:	853e                	mv	a0,a5
    80204ce6:	ffffd097          	auipc	ra,0xffffd
    80204cea:	138080e7          	jalr	312(ra) # 80201e1e <memset>
        proc_table[i]->state = UNUSED;
    80204cee:	00009717          	auipc	a4,0x9
    80204cf2:	77a70713          	addi	a4,a4,1914 # 8020e468 <proc_table>
    80204cf6:	fec42783          	lw	a5,-20(s0)
    80204cfa:	078e                	slli	a5,a5,0x3
    80204cfc:	97ba                	add	a5,a5,a4
    80204cfe:	639c                	ld	a5,0(a5)
    80204d00:	0007a023          	sw	zero,0(a5)
        proc_table[i]->pid = 0;
    80204d04:	00009717          	auipc	a4,0x9
    80204d08:	76470713          	addi	a4,a4,1892 # 8020e468 <proc_table>
    80204d0c:	fec42783          	lw	a5,-20(s0)
    80204d10:	078e                	slli	a5,a5,0x3
    80204d12:	97ba                	add	a5,a5,a4
    80204d14:	639c                	ld	a5,0(a5)
    80204d16:	0007a223          	sw	zero,4(a5)
        proc_table[i]->kstack = 0;
    80204d1a:	00009717          	auipc	a4,0x9
    80204d1e:	74e70713          	addi	a4,a4,1870 # 8020e468 <proc_table>
    80204d22:	fec42783          	lw	a5,-20(s0)
    80204d26:	078e                	slli	a5,a5,0x3
    80204d28:	97ba                	add	a5,a5,a4
    80204d2a:	639c                	ld	a5,0(a5)
    80204d2c:	0007b423          	sd	zero,8(a5)
        proc_table[i]->pagetable = 0;
    80204d30:	00009717          	auipc	a4,0x9
    80204d34:	73870713          	addi	a4,a4,1848 # 8020e468 <proc_table>
    80204d38:	fec42783          	lw	a5,-20(s0)
    80204d3c:	078e                	slli	a5,a5,0x3
    80204d3e:	97ba                	add	a5,a5,a4
    80204d40:	639c                	ld	a5,0(a5)
    80204d42:	0a07bc23          	sd	zero,184(a5)
        proc_table[i]->trapframe = 0;
    80204d46:	00009717          	auipc	a4,0x9
    80204d4a:	72270713          	addi	a4,a4,1826 # 8020e468 <proc_table>
    80204d4e:	fec42783          	lw	a5,-20(s0)
    80204d52:	078e                	slli	a5,a5,0x3
    80204d54:	97ba                	add	a5,a5,a4
    80204d56:	639c                	ld	a5,0(a5)
    80204d58:	0c07b023          	sd	zero,192(a5)
        proc_table[i]->parent = 0;
    80204d5c:	00009717          	auipc	a4,0x9
    80204d60:	70c70713          	addi	a4,a4,1804 # 8020e468 <proc_table>
    80204d64:	fec42783          	lw	a5,-20(s0)
    80204d68:	078e                	slli	a5,a5,0x3
    80204d6a:	97ba                	add	a5,a5,a4
    80204d6c:	639c                	ld	a5,0(a5)
    80204d6e:	0807bc23          	sd	zero,152(a5)
        proc_table[i]->chan = 0;
    80204d72:	00009717          	auipc	a4,0x9
    80204d76:	6f670713          	addi	a4,a4,1782 # 8020e468 <proc_table>
    80204d7a:	fec42783          	lw	a5,-20(s0)
    80204d7e:	078e                	slli	a5,a5,0x3
    80204d80:	97ba                	add	a5,a5,a4
    80204d82:	639c                	ld	a5,0(a5)
    80204d84:	0a07b023          	sd	zero,160(a5)
        proc_table[i]->exit_status = 0;
    80204d88:	00009717          	auipc	a4,0x9
    80204d8c:	6e070713          	addi	a4,a4,1760 # 8020e468 <proc_table>
    80204d90:	fec42783          	lw	a5,-20(s0)
    80204d94:	078e                	slli	a5,a5,0x3
    80204d96:	97ba                	add	a5,a5,a4
    80204d98:	639c                	ld	a5,0(a5)
    80204d9a:	0807a223          	sw	zero,132(a5)
        memset(&proc_table[i]->context, 0, sizeof(struct context));
    80204d9e:	00009717          	auipc	a4,0x9
    80204da2:	6ca70713          	addi	a4,a4,1738 # 8020e468 <proc_table>
    80204da6:	fec42783          	lw	a5,-20(s0)
    80204daa:	078e                	slli	a5,a5,0x3
    80204dac:	97ba                	add	a5,a5,a4
    80204dae:	639c                	ld	a5,0(a5)
    80204db0:	07c1                	addi	a5,a5,16
    80204db2:	07000613          	li	a2,112
    80204db6:	4581                	li	a1,0
    80204db8:	853e                	mv	a0,a5
    80204dba:	ffffd097          	auipc	ra,0xffffd
    80204dbe:	064080e7          	jalr	100(ra) # 80201e1e <memset>
    for (int i = 0; i < PROC; i++) {
    80204dc2:	fec42783          	lw	a5,-20(s0)
    80204dc6:	2785                	addiw	a5,a5,1
    80204dc8:	fef42623          	sw	a5,-20(s0)
    80204dcc:	fec42783          	lw	a5,-20(s0)
    80204dd0:	0007871b          	sext.w	a4,a5
    80204dd4:	47fd                	li	a5,31
    80204dd6:	eae7d4e3          	bge	a5,a4,80204c7e <init_proc+0xe>
    proc_table_pages = PROC; // 每个进程一页
    80204dda:	00009797          	auipc	a5,0x9
    80204dde:	78e78793          	addi	a5,a5,1934 # 8020e568 <proc_table_pages>
    80204de2:	02000713          	li	a4,32
    80204de6:	c398                	sw	a4,0(a5)
}
    80204de8:	0001                	nop
    80204dea:	60e2                	ld	ra,24(sp)
    80204dec:	6442                	ld	s0,16(sp)
    80204dee:	6105                	addi	sp,sp,32
    80204df0:	8082                	ret

0000000080204df2 <free_proc_table>:
void free_proc_table(void) {
    80204df2:	1101                	addi	sp,sp,-32
    80204df4:	ec06                	sd	ra,24(sp)
    80204df6:	e822                	sd	s0,16(sp)
    80204df8:	1000                	addi	s0,sp,32
    for (int i = 0; i < proc_table_pages; i++) {
    80204dfa:	fe042623          	sw	zero,-20(s0)
    80204dfe:	a025                	j	80204e26 <free_proc_table+0x34>
        free_page(proc_table_mem[i]);
    80204e00:	00009717          	auipc	a4,0x9
    80204e04:	77070713          	addi	a4,a4,1904 # 8020e570 <proc_table_mem>
    80204e08:	fec42783          	lw	a5,-20(s0)
    80204e0c:	078e                	slli	a5,a5,0x3
    80204e0e:	97ba                	add	a5,a5,a4
    80204e10:	639c                	ld	a5,0(a5)
    80204e12:	853e                	mv	a0,a5
    80204e14:	ffffe097          	auipc	ra,0xffffe
    80204e18:	47e080e7          	jalr	1150(ra) # 80203292 <free_page>
    for (int i = 0; i < proc_table_pages; i++) {
    80204e1c:	fec42783          	lw	a5,-20(s0)
    80204e20:	2785                	addiw	a5,a5,1
    80204e22:	fef42623          	sw	a5,-20(s0)
    80204e26:	00009797          	auipc	a5,0x9
    80204e2a:	74278793          	addi	a5,a5,1858 # 8020e568 <proc_table_pages>
    80204e2e:	4398                	lw	a4,0(a5)
    80204e30:	fec42783          	lw	a5,-20(s0)
    80204e34:	2781                	sext.w	a5,a5
    80204e36:	fce7c5e3          	blt	a5,a4,80204e00 <free_proc_table+0xe>
}
    80204e3a:	0001                	nop
    80204e3c:	0001                	nop
    80204e3e:	60e2                	ld	ra,24(sp)
    80204e40:	6442                	ld	s0,16(sp)
    80204e42:	6105                	addi	sp,sp,32
    80204e44:	8082                	ret

0000000080204e46 <alloc_proc>:
struct proc* alloc_proc(int is_user) {
    80204e46:	7139                	addi	sp,sp,-64
    80204e48:	fc06                	sd	ra,56(sp)
    80204e4a:	f822                	sd	s0,48(sp)
    80204e4c:	0080                	addi	s0,sp,64
    80204e4e:	87aa                	mv	a5,a0
    80204e50:	fcf42623          	sw	a5,-52(s0)
    for(int i = 0;i<PROC;i++) {
    80204e54:	fe042623          	sw	zero,-20(s0)
    80204e58:	aa85                	j	80204fc8 <alloc_proc+0x182>
		struct proc *p = proc_table[i];
    80204e5a:	00009717          	auipc	a4,0x9
    80204e5e:	60e70713          	addi	a4,a4,1550 # 8020e468 <proc_table>
    80204e62:	fec42783          	lw	a5,-20(s0)
    80204e66:	078e                	slli	a5,a5,0x3
    80204e68:	97ba                	add	a5,a5,a4
    80204e6a:	639c                	ld	a5,0(a5)
    80204e6c:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    80204e70:	fe043783          	ld	a5,-32(s0)
    80204e74:	439c                	lw	a5,0(a5)
    80204e76:	14079463          	bnez	a5,80204fbe <alloc_proc+0x178>
            p->pid = i;
    80204e7a:	fe043783          	ld	a5,-32(s0)
    80204e7e:	fec42703          	lw	a4,-20(s0)
    80204e82:	c3d8                	sw	a4,4(a5)
            p->state = USED;
    80204e84:	fe043783          	ld	a5,-32(s0)
    80204e88:	4705                	li	a4,1
    80204e8a:	c398                	sw	a4,0(a5)
			p->is_user = is_user;
    80204e8c:	fe043783          	ld	a5,-32(s0)
    80204e90:	fcc42703          	lw	a4,-52(s0)
    80204e94:	0ae7a423          	sw	a4,168(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    80204e98:	ffffe097          	auipc	ra,0xffffe
    80204e9c:	38e080e7          	jalr	910(ra) # 80203226 <alloc_page>
    80204ea0:	872a                	mv	a4,a0
    80204ea2:	fe043783          	ld	a5,-32(s0)
    80204ea6:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    80204ea8:	fe043783          	ld	a5,-32(s0)
    80204eac:	63fc                	ld	a5,192(a5)
    80204eae:	eb99                	bnez	a5,80204ec4 <alloc_proc+0x7e>
                p->state = UNUSED;
    80204eb0:	fe043783          	ld	a5,-32(s0)
    80204eb4:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80204eb8:	fe043783          	ld	a5,-32(s0)
    80204ebc:	0007a223          	sw	zero,4(a5)
                return 0;
    80204ec0:	4781                	li	a5,0
    80204ec2:	aa19                	j	80204fd8 <alloc_proc+0x192>
			if(p->is_user){
    80204ec4:	fe043783          	ld	a5,-32(s0)
    80204ec8:	0a87a783          	lw	a5,168(a5)
    80204ecc:	c3b9                	beqz	a5,80204f12 <alloc_proc+0xcc>
				p->pagetable = create_pagetable();
    80204ece:	ffffd097          	auipc	ra,0xffffd
    80204ed2:	1ac080e7          	jalr	428(ra) # 8020207a <create_pagetable>
    80204ed6:	872a                	mv	a4,a0
    80204ed8:	fe043783          	ld	a5,-32(s0)
    80204edc:	ffd8                	sd	a4,184(a5)
				if(p->pagetable == 0){
    80204ede:	fe043783          	ld	a5,-32(s0)
    80204ee2:	7fdc                	ld	a5,184(a5)
    80204ee4:	ef9d                	bnez	a5,80204f22 <alloc_proc+0xdc>
					free_page(p->trapframe);
    80204ee6:	fe043783          	ld	a5,-32(s0)
    80204eea:	63fc                	ld	a5,192(a5)
    80204eec:	853e                	mv	a0,a5
    80204eee:	ffffe097          	auipc	ra,0xffffe
    80204ef2:	3a4080e7          	jalr	932(ra) # 80203292 <free_page>
					p->trapframe = 0;
    80204ef6:	fe043783          	ld	a5,-32(s0)
    80204efa:	0c07b023          	sd	zero,192(a5)
					p->state = UNUSED;
    80204efe:	fe043783          	ld	a5,-32(s0)
    80204f02:	0007a023          	sw	zero,0(a5)
					p->pid = 0;
    80204f06:	fe043783          	ld	a5,-32(s0)
    80204f0a:	0007a223          	sw	zero,4(a5)
					return 0;
    80204f0e:	4781                	li	a5,0
    80204f10:	a0e1                	j	80204fd8 <alloc_proc+0x192>
				p->pagetable = kernel_pagetable;
    80204f12:	00009797          	auipc	a5,0x9
    80204f16:	17e78793          	addi	a5,a5,382 # 8020e090 <kernel_pagetable>
    80204f1a:	6398                	ld	a4,0(a5)
    80204f1c:	fe043783          	ld	a5,-32(s0)
    80204f20:	ffd8                	sd	a4,184(a5)
            void *kstack_mem = alloc_page();
    80204f22:	ffffe097          	auipc	ra,0xffffe
    80204f26:	304080e7          	jalr	772(ra) # 80203226 <alloc_page>
    80204f2a:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    80204f2e:	fd843783          	ld	a5,-40(s0)
    80204f32:	e3b9                	bnez	a5,80204f78 <alloc_proc+0x132>
                free_page(p->trapframe);
    80204f34:	fe043783          	ld	a5,-32(s0)
    80204f38:	63fc                	ld	a5,192(a5)
    80204f3a:	853e                	mv	a0,a5
    80204f3c:	ffffe097          	auipc	ra,0xffffe
    80204f40:	356080e7          	jalr	854(ra) # 80203292 <free_page>
                free_pagetable(p->pagetable);
    80204f44:	fe043783          	ld	a5,-32(s0)
    80204f48:	7fdc                	ld	a5,184(a5)
    80204f4a:	853e                	mv	a0,a5
    80204f4c:	ffffd097          	auipc	ra,0xffffd
    80204f50:	512080e7          	jalr	1298(ra) # 8020245e <free_pagetable>
                p->trapframe = 0;
    80204f54:	fe043783          	ld	a5,-32(s0)
    80204f58:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    80204f5c:	fe043783          	ld	a5,-32(s0)
    80204f60:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    80204f64:	fe043783          	ld	a5,-32(s0)
    80204f68:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80204f6c:	fe043783          	ld	a5,-32(s0)
    80204f70:	0007a223          	sw	zero,4(a5)
                return 0;
    80204f74:	4781                	li	a5,0
    80204f76:	a08d                	j	80204fd8 <alloc_proc+0x192>
            p->kstack = (uint64)kstack_mem;
    80204f78:	fd843703          	ld	a4,-40(s0)
    80204f7c:	fe043783          	ld	a5,-32(s0)
    80204f80:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    80204f82:	fe043783          	ld	a5,-32(s0)
    80204f86:	07c1                	addi	a5,a5,16
    80204f88:	07000613          	li	a2,112
    80204f8c:	4581                	li	a1,0
    80204f8e:	853e                	mv	a0,a5
    80204f90:	ffffd097          	auipc	ra,0xffffd
    80204f94:	e8e080e7          	jalr	-370(ra) # 80201e1e <memset>
            p->context.ra = (uint64)forkret;
    80204f98:	00000717          	auipc	a4,0x0
    80204f9c:	c6a70713          	addi	a4,a4,-918 # 80204c02 <forkret>
    80204fa0:	fe043783          	ld	a5,-32(s0)
    80204fa4:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    80204fa6:	fe043783          	ld	a5,-32(s0)
    80204faa:	6798                	ld	a4,8(a5)
    80204fac:	6785                	lui	a5,0x1
    80204fae:	17c1                	addi	a5,a5,-16 # ff0 <_entry-0x801ff010>
    80204fb0:	973e                	add	a4,a4,a5
    80204fb2:	fe043783          	ld	a5,-32(s0)
    80204fb6:	ef98                	sd	a4,24(a5)
            return p;
    80204fb8:	fe043783          	ld	a5,-32(s0)
    80204fbc:	a831                	j	80204fd8 <alloc_proc+0x192>
    for(int i = 0;i<PROC;i++) {
    80204fbe:	fec42783          	lw	a5,-20(s0)
    80204fc2:	2785                	addiw	a5,a5,1
    80204fc4:	fef42623          	sw	a5,-20(s0)
    80204fc8:	fec42783          	lw	a5,-20(s0)
    80204fcc:	0007871b          	sext.w	a4,a5
    80204fd0:	47fd                	li	a5,31
    80204fd2:	e8e7d4e3          	bge	a5,a4,80204e5a <alloc_proc+0x14>
    return 0;
    80204fd6:	4781                	li	a5,0
}
    80204fd8:	853e                	mv	a0,a5
    80204fda:	70e2                	ld	ra,56(sp)
    80204fdc:	7442                	ld	s0,48(sp)
    80204fde:	6121                	addi	sp,sp,64
    80204fe0:	8082                	ret

0000000080204fe2 <free_proc>:
void free_proc(struct proc *p){
    80204fe2:	1101                	addi	sp,sp,-32
    80204fe4:	ec06                	sd	ra,24(sp)
    80204fe6:	e822                	sd	s0,16(sp)
    80204fe8:	1000                	addi	s0,sp,32
    80204fea:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    80204fee:	fe843783          	ld	a5,-24(s0)
    80204ff2:	63fc                	ld	a5,192(a5)
    80204ff4:	cb89                	beqz	a5,80205006 <free_proc+0x24>
        free_page(p->trapframe);
    80204ff6:	fe843783          	ld	a5,-24(s0)
    80204ffa:	63fc                	ld	a5,192(a5)
    80204ffc:	853e                	mv	a0,a5
    80204ffe:	ffffe097          	auipc	ra,0xffffe
    80205002:	294080e7          	jalr	660(ra) # 80203292 <free_page>
    p->trapframe = 0;
    80205006:	fe843783          	ld	a5,-24(s0)
    8020500a:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable && p->pagetable != kernel_pagetable)
    8020500e:	fe843783          	ld	a5,-24(s0)
    80205012:	7fdc                	ld	a5,184(a5)
    80205014:	c39d                	beqz	a5,8020503a <free_proc+0x58>
    80205016:	fe843783          	ld	a5,-24(s0)
    8020501a:	7fd8                	ld	a4,184(a5)
    8020501c:	00009797          	auipc	a5,0x9
    80205020:	07478793          	addi	a5,a5,116 # 8020e090 <kernel_pagetable>
    80205024:	639c                	ld	a5,0(a5)
    80205026:	00f70a63          	beq	a4,a5,8020503a <free_proc+0x58>
        free_pagetable(p->pagetable);
    8020502a:	fe843783          	ld	a5,-24(s0)
    8020502e:	7fdc                	ld	a5,184(a5)
    80205030:	853e                	mv	a0,a5
    80205032:	ffffd097          	auipc	ra,0xffffd
    80205036:	42c080e7          	jalr	1068(ra) # 8020245e <free_pagetable>
    p->pagetable = 0;
    8020503a:	fe843783          	ld	a5,-24(s0)
    8020503e:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    80205042:	fe843783          	ld	a5,-24(s0)
    80205046:	679c                	ld	a5,8(a5)
    80205048:	cb89                	beqz	a5,8020505a <free_proc+0x78>
        free_page((void*)p->kstack);
    8020504a:	fe843783          	ld	a5,-24(s0)
    8020504e:	679c                	ld	a5,8(a5)
    80205050:	853e                	mv	a0,a5
    80205052:	ffffe097          	auipc	ra,0xffffe
    80205056:	240080e7          	jalr	576(ra) # 80203292 <free_page>
    p->kstack = 0;
    8020505a:	fe843783          	ld	a5,-24(s0)
    8020505e:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    80205062:	fe843783          	ld	a5,-24(s0)
    80205066:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    8020506a:	fe843783          	ld	a5,-24(s0)
    8020506e:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    80205072:	fe843783          	ld	a5,-24(s0)
    80205076:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    8020507a:	fe843783          	ld	a5,-24(s0)
    8020507e:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    80205082:	fe843783          	ld	a5,-24(s0)
    80205086:	07c1                	addi	a5,a5,16
    80205088:	07000613          	li	a2,112
    8020508c:	4581                	li	a1,0
    8020508e:	853e                	mv	a0,a5
    80205090:	ffffd097          	auipc	ra,0xffffd
    80205094:	d8e080e7          	jalr	-626(ra) # 80201e1e <memset>
}
    80205098:	0001                	nop
    8020509a:	60e2                	ld	ra,24(sp)
    8020509c:	6442                	ld	s0,16(sp)
    8020509e:	6105                	addi	sp,sp,32
    802050a0:	8082                	ret

00000000802050a2 <create_kernel_proc>:
int create_kernel_proc(void (*entry)(void)) {
    802050a2:	7179                	addi	sp,sp,-48
    802050a4:	f406                	sd	ra,40(sp)
    802050a6:	f022                	sd	s0,32(sp)
    802050a8:	1800                	addi	s0,sp,48
    802050aa:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc(0);
    802050ae:	4501                	li	a0,0
    802050b0:	00000097          	auipc	ra,0x0
    802050b4:	d96080e7          	jalr	-618(ra) # 80204e46 <alloc_proc>
    802050b8:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    802050bc:	fe843783          	ld	a5,-24(s0)
    802050c0:	e399                	bnez	a5,802050c6 <create_kernel_proc+0x24>
    802050c2:	57fd                	li	a5,-1
    802050c4:	a089                	j	80205106 <create_kernel_proc+0x64>
    p->trapframe->epc = (uint64)entry;
    802050c6:	fe843783          	ld	a5,-24(s0)
    802050ca:	63fc                	ld	a5,192(a5)
    802050cc:	fd843703          	ld	a4,-40(s0)
    802050d0:	f398                	sd	a4,32(a5)
    p->state = RUNNABLE;
    802050d2:	fe843783          	ld	a5,-24(s0)
    802050d6:	470d                	li	a4,3
    802050d8:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    802050da:	00000097          	auipc	ra,0x0
    802050de:	8a6080e7          	jalr	-1882(ra) # 80204980 <myproc>
    802050e2:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    802050e6:	fe043783          	ld	a5,-32(s0)
    802050ea:	c799                	beqz	a5,802050f8 <create_kernel_proc+0x56>
        p->parent = parent;
    802050ec:	fe843783          	ld	a5,-24(s0)
    802050f0:	fe043703          	ld	a4,-32(s0)
    802050f4:	efd8                	sd	a4,152(a5)
    802050f6:	a029                	j	80205100 <create_kernel_proc+0x5e>
        p->parent = NULL;
    802050f8:	fe843783          	ld	a5,-24(s0)
    802050fc:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    80205100:	fe843783          	ld	a5,-24(s0)
    80205104:	43dc                	lw	a5,4(a5)
}
    80205106:	853e                	mv	a0,a5
    80205108:	70a2                	ld	ra,40(sp)
    8020510a:	7402                	ld	s0,32(sp)
    8020510c:	6145                	addi	sp,sp,48
    8020510e:	8082                	ret

0000000080205110 <create_user_proc>:
int create_user_proc(const void *user_bin, int bin_size) {
    80205110:	715d                	addi	sp,sp,-80
    80205112:	e486                	sd	ra,72(sp)
    80205114:	e0a2                	sd	s0,64(sp)
    80205116:	0880                	addi	s0,sp,80
    80205118:	faa43c23          	sd	a0,-72(s0)
    8020511c:	87ae                	mv	a5,a1
    8020511e:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = alloc_proc(1); // 1 表示用户进程
    80205122:	4505                	li	a0,1
    80205124:	00000097          	auipc	ra,0x0
    80205128:	d22080e7          	jalr	-734(ra) # 80204e46 <alloc_proc>
    8020512c:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    80205130:	fe843783          	ld	a5,-24(s0)
    80205134:	e399                	bnez	a5,8020513a <create_user_proc+0x2a>
    80205136:	57fd                	li	a5,-1
    80205138:	a2d1                	j	802052fc <create_user_proc+0x1ec>
    uint64 user_entry = 0x10000;
    8020513a:	67c1                	lui	a5,0x10
    8020513c:	fef43023          	sd	a5,-32(s0)
    uint64 user_stack = 0x20000;
    80205140:	000207b7          	lui	a5,0x20
    80205144:	fcf43c23          	sd	a5,-40(s0)
    void *page = alloc_page();
    80205148:	ffffe097          	auipc	ra,0xffffe
    8020514c:	0de080e7          	jalr	222(ra) # 80203226 <alloc_page>
    80205150:	fca43823          	sd	a0,-48(s0)
    if (!page) { free_proc(p); return -1; }
    80205154:	fd043783          	ld	a5,-48(s0)
    80205158:	eb89                	bnez	a5,8020516a <create_user_proc+0x5a>
    8020515a:	fe843503          	ld	a0,-24(s0)
    8020515e:	00000097          	auipc	ra,0x0
    80205162:	e84080e7          	jalr	-380(ra) # 80204fe2 <free_proc>
    80205166:	57fd                	li	a5,-1
    80205168:	aa51                	j	802052fc <create_user_proc+0x1ec>
    map_page(p->pagetable, user_entry, (uint64)page, PTE_R | PTE_W | PTE_X | PTE_U);
    8020516a:	fe843783          	ld	a5,-24(s0)
    8020516e:	7fdc                	ld	a5,184(a5)
    80205170:	fd043703          	ld	a4,-48(s0)
    80205174:	46f9                	li	a3,30
    80205176:	863a                	mv	a2,a4
    80205178:	fe043583          	ld	a1,-32(s0)
    8020517c:	853e                	mv	a0,a5
    8020517e:	ffffd097          	auipc	ra,0xffffd
    80205182:	16c080e7          	jalr	364(ra) # 802022ea <map_page>
    memcpy((void*)page, user_bin, bin_size);
    80205186:	fb442783          	lw	a5,-76(s0)
    8020518a:	863e                	mv	a2,a5
    8020518c:	fb843583          	ld	a1,-72(s0)
    80205190:	fd043503          	ld	a0,-48(s0)
    80205194:	ffffd097          	auipc	ra,0xffffd
    80205198:	d96080e7          	jalr	-618(ra) # 80201f2a <memcpy>
    void *stack_page = alloc_page();
    8020519c:	ffffe097          	auipc	ra,0xffffe
    802051a0:	08a080e7          	jalr	138(ra) # 80203226 <alloc_page>
    802051a4:	fca43423          	sd	a0,-56(s0)
    if (!stack_page) { free_proc(p); return -1; }
    802051a8:	fc843783          	ld	a5,-56(s0)
    802051ac:	eb89                	bnez	a5,802051be <create_user_proc+0xae>
    802051ae:	fe843503          	ld	a0,-24(s0)
    802051b2:	00000097          	auipc	ra,0x0
    802051b6:	e30080e7          	jalr	-464(ra) # 80204fe2 <free_proc>
    802051ba:	57fd                	li	a5,-1
    802051bc:	a281                	j	802052fc <create_user_proc+0x1ec>
    map_page(p->pagetable, user_stack - PGSIZE, (uint64)stack_page, PTE_R | PTE_W | PTE_U);
    802051be:	fe843783          	ld	a5,-24(s0)
    802051c2:	7fc8                	ld	a0,184(a5)
    802051c4:	fd843703          	ld	a4,-40(s0)
    802051c8:	77fd                	lui	a5,0xfffff
    802051ca:	97ba                	add	a5,a5,a4
    802051cc:	fc843703          	ld	a4,-56(s0)
    802051d0:	46d9                	li	a3,22
    802051d2:	863a                	mv	a2,a4
    802051d4:	85be                	mv	a1,a5
    802051d6:	ffffd097          	auipc	ra,0xffffd
    802051da:	114080e7          	jalr	276(ra) # 802022ea <map_page>
	p->sz = user_stack; // 用户空间从 0x10000 到 0x20000
    802051de:	fe843783          	ld	a5,-24(s0)
    802051e2:	fd843703          	ld	a4,-40(s0)
    802051e6:	fbd8                	sd	a4,176(a5)
    if (map_page(p->pagetable, TRAPFRAME, (uint64)p->trapframe, PTE_R | PTE_W) != 0) {
    802051e8:	fe843783          	ld	a5,-24(s0)
    802051ec:	7fd8                	ld	a4,184(a5)
    802051ee:	fe843783          	ld	a5,-24(s0)
    802051f2:	63fc                	ld	a5,192(a5)
    802051f4:	4699                	li	a3,6
    802051f6:	863e                	mv	a2,a5
    802051f8:	75f9                	lui	a1,0xffffe
    802051fa:	853a                	mv	a0,a4
    802051fc:	ffffd097          	auipc	ra,0xffffd
    80205200:	0ee080e7          	jalr	238(ra) # 802022ea <map_page>
    80205204:	87aa                	mv	a5,a0
    80205206:	cb89                	beqz	a5,80205218 <create_user_proc+0x108>
        free_proc(p);
    80205208:	fe843503          	ld	a0,-24(s0)
    8020520c:	00000097          	auipc	ra,0x0
    80205210:	dd6080e7          	jalr	-554(ra) # 80204fe2 <free_proc>
        return -1;
    80205214:	57fd                	li	a5,-1
    80205216:	a0dd                	j	802052fc <create_user_proc+0x1ec>
	memset(p->trapframe, 0, sizeof(*p->trapframe));
    80205218:	fe843783          	ld	a5,-24(s0)
    8020521c:	63fc                	ld	a5,192(a5)
    8020521e:	11800613          	li	a2,280
    80205222:	4581                	li	a1,0
    80205224:	853e                	mv	a0,a5
    80205226:	ffffd097          	auipc	ra,0xffffd
    8020522a:	bf8080e7          	jalr	-1032(ra) # 80201e1e <memset>
	p->trapframe->epc = user_entry; // 应为 0x10000
    8020522e:	fe843783          	ld	a5,-24(s0)
    80205232:	63fc                	ld	a5,192(a5)
    80205234:	fe043703          	ld	a4,-32(s0)
    80205238:	f398                	sd	a4,32(a5)
	p->trapframe->sp = user_stack;  // 应为 0x20000
    8020523a:	fe843783          	ld	a5,-24(s0)
    8020523e:	63fc                	ld	a5,192(a5)
    80205240:	fd843703          	ld	a4,-40(s0)
    80205244:	ff98                	sd	a4,56(a5)
	p->trapframe->sstatus = (1UL << 5); // 0x20
    80205246:	fe843783          	ld	a5,-24(s0)
    8020524a:	63fc                	ld	a5,192(a5)
    8020524c:	02000713          	li	a4,32
    80205250:	ef98                	sd	a4,24(a5)
	p->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable);
    80205252:	00009797          	auipc	a5,0x9
    80205256:	e3e78793          	addi	a5,a5,-450 # 8020e090 <kernel_pagetable>
    8020525a:	639c                	ld	a5,0(a5)
    8020525c:	00c7d693          	srli	a3,a5,0xc
    80205260:	fe843783          	ld	a5,-24(s0)
    80205264:	63fc                	ld	a5,192(a5)
    80205266:	577d                	li	a4,-1
    80205268:	177e                	slli	a4,a4,0x3f
    8020526a:	8f55                	or	a4,a4,a3
    8020526c:	e398                	sd	a4,0(a5)
	p->trapframe->kernel_sp = p->kstack + PGSIZE;   // 内核栈顶
    8020526e:	fe843783          	ld	a5,-24(s0)
    80205272:	6794                	ld	a3,8(a5)
    80205274:	fe843783          	ld	a5,-24(s0)
    80205278:	63fc                	ld	a5,192(a5)
    8020527a:	6705                	lui	a4,0x1
    8020527c:	9736                	add	a4,a4,a3
    8020527e:	e798                	sd	a4,8(a5)
	p->trapframe->usertrap  = (uint64)usertrap;     // C 层 trap 处理函数
    80205280:	fe843783          	ld	a5,-24(s0)
    80205284:	63fc                	ld	a5,192(a5)
    80205286:	fffff717          	auipc	a4,0xfffff
    8020528a:	fa870713          	addi	a4,a4,-88 # 8020422e <usertrap>
    8020528e:	10e7b423          	sd	a4,264(a5)
	p->trapframe->kernel_vec = (uint64)kernelvec;
    80205292:	fe843783          	ld	a5,-24(s0)
    80205296:	63fc                	ld	a5,192(a5)
    80205298:	fffff717          	auipc	a4,0xfffff
    8020529c:	3b870713          	addi	a4,a4,952 # 80204650 <kernelvec>
    802052a0:	10e7b823          	sd	a4,272(a5)
    p->state = RUNNABLE;
    802052a4:	fe843783          	ld	a5,-24(s0)
    802052a8:	470d                	li	a4,3
    802052aa:	c398                	sw	a4,0(a5)
	if (map_page(p->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_X | PTE_R) != 0) {
    802052ac:	fe843783          	ld	a5,-24(s0)
    802052b0:	7fd8                	ld	a4,184(a5)
    802052b2:	00009797          	auipc	a5,0x9
    802052b6:	de678793          	addi	a5,a5,-538 # 8020e098 <trampoline_phys_addr>
    802052ba:	639c                	ld	a5,0(a5)
    802052bc:	46a9                	li	a3,10
    802052be:	863e                	mv	a2,a5
    802052c0:	75fd                	lui	a1,0xfffff
    802052c2:	853a                	mv	a0,a4
    802052c4:	ffffd097          	auipc	ra,0xffffd
    802052c8:	026080e7          	jalr	38(ra) # 802022ea <map_page>
    802052cc:	87aa                	mv	a5,a0
    802052ce:	cb89                	beqz	a5,802052e0 <create_user_proc+0x1d0>
		free_proc(p);
    802052d0:	fe843503          	ld	a0,-24(s0)
    802052d4:	00000097          	auipc	ra,0x0
    802052d8:	d0e080e7          	jalr	-754(ra) # 80204fe2 <free_proc>
		return -1;
    802052dc:	57fd                	li	a5,-1
    802052de:	a839                	j	802052fc <create_user_proc+0x1ec>
    struct proc *parent = myproc();
    802052e0:	fffff097          	auipc	ra,0xfffff
    802052e4:	6a0080e7          	jalr	1696(ra) # 80204980 <myproc>
    802052e8:	fca43023          	sd	a0,-64(s0)
    p->parent = parent ? parent : NULL;
    802052ec:	fe843783          	ld	a5,-24(s0)
    802052f0:	fc043703          	ld	a4,-64(s0)
    802052f4:	efd8                	sd	a4,152(a5)
    return p->pid;
    802052f6:	fe843783          	ld	a5,-24(s0)
    802052fa:	43dc                	lw	a5,4(a5)
}
    802052fc:	853e                	mv	a0,a5
    802052fe:	60a6                	ld	ra,72(sp)
    80205300:	6406                	ld	s0,64(sp)
    80205302:	6161                	addi	sp,sp,80
    80205304:	8082                	ret

0000000080205306 <fork_proc>:
int fork_proc(void) {
    80205306:	7179                	addi	sp,sp,-48
    80205308:	f406                	sd	ra,40(sp)
    8020530a:	f022                	sd	s0,32(sp)
    8020530c:	1800                	addi	s0,sp,48
    struct proc *parent = myproc();
    8020530e:	fffff097          	auipc	ra,0xfffff
    80205312:	672080e7          	jalr	1650(ra) # 80204980 <myproc>
    80205316:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc(parent->is_user);
    8020531a:	fe843783          	ld	a5,-24(s0)
    8020531e:	0a87a783          	lw	a5,168(a5)
    80205322:	853e                	mv	a0,a5
    80205324:	00000097          	auipc	ra,0x0
    80205328:	b22080e7          	jalr	-1246(ra) # 80204e46 <alloc_proc>
    8020532c:	fea43023          	sd	a0,-32(s0)
    if (!child) return -1;
    80205330:	fe043783          	ld	a5,-32(s0)
    80205334:	e399                	bnez	a5,8020533a <fork_proc+0x34>
    80205336:	57fd                	li	a5,-1
    80205338:	a2c1                	j	802054f8 <fork_proc+0x1f2>
    printf("[fork] parent sz: 0x%lx\n", parent->sz);
    8020533a:	fe843783          	ld	a5,-24(s0)
    8020533e:	7bdc                	ld	a5,176(a5)
    80205340:	85be                	mv	a1,a5
    80205342:	00005517          	auipc	a0,0x5
    80205346:	38e50513          	addi	a0,a0,910 # 8020a6d0 <simple_user_task_bin+0x320>
    8020534a:	ffffc097          	auipc	ra,0xffffc
    8020534e:	94a080e7          	jalr	-1718(ra) # 80200c94 <printf>
    if (uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0) {
    80205352:	fe843783          	ld	a5,-24(s0)
    80205356:	7fd8                	ld	a4,184(a5)
    80205358:	fe043783          	ld	a5,-32(s0)
    8020535c:	7fd4                	ld	a3,184(a5)
    8020535e:	fe843783          	ld	a5,-24(s0)
    80205362:	7bdc                	ld	a5,176(a5)
    80205364:	863e                	mv	a2,a5
    80205366:	85b6                	mv	a1,a3
    80205368:	853a                	mv	a0,a4
    8020536a:	ffffe097          	auipc	ra,0xffffe
    8020536e:	cec080e7          	jalr	-788(ra) # 80203056 <uvmcopy>
    80205372:	87aa                	mv	a5,a0
    80205374:	0007da63          	bgez	a5,80205388 <fork_proc+0x82>
        free_proc(child);
    80205378:	fe043503          	ld	a0,-32(s0)
    8020537c:	00000097          	auipc	ra,0x0
    80205380:	c66080e7          	jalr	-922(ra) # 80204fe2 <free_proc>
        return -1;
    80205384:	57fd                	li	a5,-1
    80205386:	aa8d                	j	802054f8 <fork_proc+0x1f2>
    child->sz = parent->sz;
    80205388:	fe843783          	ld	a5,-24(s0)
    8020538c:	7bd8                	ld	a4,176(a5)
    8020538e:	fe043783          	ld	a5,-32(s0)
    80205392:	fbd8                	sd	a4,176(a5)
    uint64 tf_pa = (uint64)child->trapframe;
    80205394:	fe043783          	ld	a5,-32(s0)
    80205398:	63fc                	ld	a5,192(a5)
    8020539a:	fcf43c23          	sd	a5,-40(s0)
    if ((tf_pa & (PGSIZE - 1)) != 0) {
    8020539e:	fd843703          	ld	a4,-40(s0)
    802053a2:	6785                	lui	a5,0x1
    802053a4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802053a6:	8ff9                	and	a5,a5,a4
    802053a8:	c39d                	beqz	a5,802053ce <fork_proc+0xc8>
        printf("[fork] trapframe not aligned: 0x%lx\n", tf_pa);
    802053aa:	fd843583          	ld	a1,-40(s0)
    802053ae:	00005517          	auipc	a0,0x5
    802053b2:	34250513          	addi	a0,a0,834 # 8020a6f0 <simple_user_task_bin+0x340>
    802053b6:	ffffc097          	auipc	ra,0xffffc
    802053ba:	8de080e7          	jalr	-1826(ra) # 80200c94 <printf>
        free_proc(child);
    802053be:	fe043503          	ld	a0,-32(s0)
    802053c2:	00000097          	auipc	ra,0x0
    802053c6:	c20080e7          	jalr	-992(ra) # 80204fe2 <free_proc>
        return -1;
    802053ca:	57fd                	li	a5,-1
    802053cc:	a235                	j	802054f8 <fork_proc+0x1f2>
    if (map_page(child->pagetable, TRAPFRAME, tf_pa, PTE_R | PTE_W) != 0) {
    802053ce:	fe043783          	ld	a5,-32(s0)
    802053d2:	7fdc                	ld	a5,184(a5)
    802053d4:	4699                	li	a3,6
    802053d6:	fd843603          	ld	a2,-40(s0)
    802053da:	75f9                	lui	a1,0xffffe
    802053dc:	853e                	mv	a0,a5
    802053de:	ffffd097          	auipc	ra,0xffffd
    802053e2:	f0c080e7          	jalr	-244(ra) # 802022ea <map_page>
    802053e6:	87aa                	mv	a5,a0
    802053e8:	c38d                	beqz	a5,8020540a <fork_proc+0x104>
        printf("[fork] map TRAPFRAME failed\n");
    802053ea:	00005517          	auipc	a0,0x5
    802053ee:	32e50513          	addi	a0,a0,814 # 8020a718 <simple_user_task_bin+0x368>
    802053f2:	ffffc097          	auipc	ra,0xffffc
    802053f6:	8a2080e7          	jalr	-1886(ra) # 80200c94 <printf>
        free_proc(child);
    802053fa:	fe043503          	ld	a0,-32(s0)
    802053fe:	00000097          	auipc	ra,0x0
    80205402:	be4080e7          	jalr	-1052(ra) # 80204fe2 <free_proc>
        return -1;
    80205406:	57fd                	li	a5,-1
    80205408:	a8c5                	j	802054f8 <fork_proc+0x1f2>
    if (map_page(child->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_R | PTE_X) != 0) {
    8020540a:	fe043783          	ld	a5,-32(s0)
    8020540e:	7fd8                	ld	a4,184(a5)
    80205410:	00009797          	auipc	a5,0x9
    80205414:	c8878793          	addi	a5,a5,-888 # 8020e098 <trampoline_phys_addr>
    80205418:	639c                	ld	a5,0(a5)
    8020541a:	46a9                	li	a3,10
    8020541c:	863e                	mv	a2,a5
    8020541e:	75fd                	lui	a1,0xfffff
    80205420:	853a                	mv	a0,a4
    80205422:	ffffd097          	auipc	ra,0xffffd
    80205426:	ec8080e7          	jalr	-312(ra) # 802022ea <map_page>
    8020542a:	87aa                	mv	a5,a0
    8020542c:	c38d                	beqz	a5,8020544e <fork_proc+0x148>
        printf("[fork] map TRAMPOLINE failed\n");
    8020542e:	00005517          	auipc	a0,0x5
    80205432:	30a50513          	addi	a0,a0,778 # 8020a738 <simple_user_task_bin+0x388>
    80205436:	ffffc097          	auipc	ra,0xffffc
    8020543a:	85e080e7          	jalr	-1954(ra) # 80200c94 <printf>
        free_proc(child);
    8020543e:	fe043503          	ld	a0,-32(s0)
    80205442:	00000097          	auipc	ra,0x0
    80205446:	ba0080e7          	jalr	-1120(ra) # 80204fe2 <free_proc>
        return -1;
    8020544a:	57fd                	li	a5,-1
    8020544c:	a075                	j	802054f8 <fork_proc+0x1f2>
    *(child->trapframe) = *(parent->trapframe);
    8020544e:	fe843783          	ld	a5,-24(s0)
    80205452:	63f8                	ld	a4,192(a5)
    80205454:	fe043783          	ld	a5,-32(s0)
    80205458:	63fc                	ld	a5,192(a5)
    8020545a:	86be                	mv	a3,a5
    8020545c:	11800793          	li	a5,280
    80205460:	863e                	mv	a2,a5
    80205462:	85ba                	mv	a1,a4
    80205464:	8536                	mv	a0,a3
    80205466:	ffffd097          	auipc	ra,0xffffd
    8020546a:	ac4080e7          	jalr	-1340(ra) # 80201f2a <memcpy>
	child->trapframe->kernel_sp = child->kstack + PGSIZE;
    8020546e:	fe043783          	ld	a5,-32(s0)
    80205472:	6794                	ld	a3,8(a5)
    80205474:	fe043783          	ld	a5,-32(s0)
    80205478:	63fc                	ld	a5,192(a5)
    8020547a:	6705                	lui	a4,0x1
    8020547c:	9736                	add	a4,a4,a3
    8020547e:	e798                	sd	a4,8(a5)
	assert(child->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable));
    80205480:	00009797          	auipc	a5,0x9
    80205484:	c1078793          	addi	a5,a5,-1008 # 8020e090 <kernel_pagetable>
    80205488:	639c                	ld	a5,0(a5)
    8020548a:	00c7d693          	srli	a3,a5,0xc
    8020548e:	fe043783          	ld	a5,-32(s0)
    80205492:	63fc                	ld	a5,192(a5)
    80205494:	577d                	li	a4,-1
    80205496:	177e                	slli	a4,a4,0x3f
    80205498:	8f55                	or	a4,a4,a3
    8020549a:	e398                	sd	a4,0(a5)
    8020549c:	639c                	ld	a5,0(a5)
    8020549e:	2781                	sext.w	a5,a5
    802054a0:	853e                	mv	a0,a5
    802054a2:	fffff097          	auipc	ra,0xfffff
    802054a6:	468080e7          	jalr	1128(ra) # 8020490a <assert>
    child->trapframe->epc += 4;  // 跳过 ecall 指令
    802054aa:	fe043783          	ld	a5,-32(s0)
    802054ae:	63fc                	ld	a5,192(a5)
    802054b0:	7398                	ld	a4,32(a5)
    802054b2:	fe043783          	ld	a5,-32(s0)
    802054b6:	63fc                	ld	a5,192(a5)
    802054b8:	0711                	addi	a4,a4,4 # 1004 <_entry-0x801feffc>
    802054ba:	f398                	sd	a4,32(a5)
    child->trapframe->a0 = 0;    // 子进程fork返回0
    802054bc:	fe043783          	ld	a5,-32(s0)
    802054c0:	63fc                	ld	a5,192(a5)
    802054c2:	0607bc23          	sd	zero,120(a5)
    printf("[fork] child EPC: 0x%lx (should be 0x1000a)\n", child->trapframe->epc);
    802054c6:	fe043783          	ld	a5,-32(s0)
    802054ca:	63fc                	ld	a5,192(a5)
    802054cc:	739c                	ld	a5,32(a5)
    802054ce:	85be                	mv	a1,a5
    802054d0:	00005517          	auipc	a0,0x5
    802054d4:	28850513          	addi	a0,a0,648 # 8020a758 <simple_user_task_bin+0x3a8>
    802054d8:	ffffb097          	auipc	ra,0xffffb
    802054dc:	7bc080e7          	jalr	1980(ra) # 80200c94 <printf>
    child->state = RUNNABLE;
    802054e0:	fe043783          	ld	a5,-32(s0)
    802054e4:	470d                	li	a4,3
    802054e6:	c398                	sw	a4,0(a5)
    child->parent = parent;
    802054e8:	fe043783          	ld	a5,-32(s0)
    802054ec:	fe843703          	ld	a4,-24(s0)
    802054f0:	efd8                	sd	a4,152(a5)
    return child->pid;
    802054f2:	fe043783          	ld	a5,-32(s0)
    802054f6:	43dc                	lw	a5,4(a5)
}
    802054f8:	853e                	mv	a0,a5
    802054fa:	70a2                	ld	ra,40(sp)
    802054fc:	7402                	ld	s0,32(sp)
    802054fe:	6145                	addi	sp,sp,48
    80205500:	8082                	ret

0000000080205502 <schedule>:
void schedule(void) {
    80205502:	7179                	addi	sp,sp,-48
    80205504:	f406                	sd	ra,40(sp)
    80205506:	f022                	sd	s0,32(sp)
    80205508:	1800                	addi	s0,sp,48
  struct cpu *c = mycpu();
    8020550a:	fffff097          	auipc	ra,0xfffff
    8020550e:	48e080e7          	jalr	1166(ra) # 80204998 <mycpu>
    80205512:	fea43423          	sd	a0,-24(s0)
  if (!initialized) {
    80205516:	00009797          	auipc	a5,0x9
    8020551a:	1d278793          	addi	a5,a5,466 # 8020e6e8 <initialized.0>
    8020551e:	439c                	lw	a5,0(a5)
    80205520:	ef85                	bnez	a5,80205558 <schedule+0x56>
    if(c == 0) {
    80205522:	fe843783          	ld	a5,-24(s0)
    80205526:	eb89                	bnez	a5,80205538 <schedule+0x36>
      panic("schedule: no current cpu");
    80205528:	00005517          	auipc	a0,0x5
    8020552c:	26050513          	addi	a0,a0,608 # 8020a788 <simple_user_task_bin+0x3d8>
    80205530:	ffffc097          	auipc	ra,0xffffc
    80205534:	1b0080e7          	jalr	432(ra) # 802016e0 <panic>
    c->proc = 0;
    80205538:	fe843783          	ld	a5,-24(s0)
    8020553c:	0007b023          	sd	zero,0(a5)
    current_proc = 0;
    80205540:	00009797          	auipc	a5,0x9
    80205544:	b6878793          	addi	a5,a5,-1176 # 8020e0a8 <current_proc>
    80205548:	0007b023          	sd	zero,0(a5)
    initialized = 1;
    8020554c:	00009797          	auipc	a5,0x9
    80205550:	19c78793          	addi	a5,a5,412 # 8020e6e8 <initialized.0>
    80205554:	4705                	li	a4,1
    80205556:	c398                	sw	a4,0(a5)
    intr_on();
    80205558:	fffff097          	auipc	ra,0xfffff
    8020555c:	346080e7          	jalr	838(ra) # 8020489e <intr_on>
    for(int i = 0; i < PROC; i++) {
    80205560:	fe042223          	sw	zero,-28(s0)
    80205564:	a069                	j	802055ee <schedule+0xec>
        struct proc *p = proc_table[i];
    80205566:	00009717          	auipc	a4,0x9
    8020556a:	f0270713          	addi	a4,a4,-254 # 8020e468 <proc_table>
    8020556e:	fe442783          	lw	a5,-28(s0)
    80205572:	078e                	slli	a5,a5,0x3
    80205574:	97ba                	add	a5,a5,a4
    80205576:	639c                	ld	a5,0(a5)
    80205578:	fcf43c23          	sd	a5,-40(s0)
      	if(p->state == RUNNABLE) {
    8020557c:	fd843783          	ld	a5,-40(s0)
    80205580:	439c                	lw	a5,0(a5)
    80205582:	873e                	mv	a4,a5
    80205584:	478d                	li	a5,3
    80205586:	04f71f63          	bne	a4,a5,802055e4 <schedule+0xe2>
			p->state = RUNNING;
    8020558a:	fd843783          	ld	a5,-40(s0)
    8020558e:	4711                	li	a4,4
    80205590:	c398                	sw	a4,0(a5)
			c->proc = p;
    80205592:	fe843783          	ld	a5,-24(s0)
    80205596:	fd843703          	ld	a4,-40(s0)
    8020559a:	e398                	sd	a4,0(a5)
			current_proc = p;
    8020559c:	00009797          	auipc	a5,0x9
    802055a0:	b0c78793          	addi	a5,a5,-1268 # 8020e0a8 <current_proc>
    802055a4:	fd843703          	ld	a4,-40(s0)
    802055a8:	e398                	sd	a4,0(a5)
			swtch(&c->context, &p->context);
    802055aa:	fe843783          	ld	a5,-24(s0)
    802055ae:	00878713          	addi	a4,a5,8
    802055b2:	fd843783          	ld	a5,-40(s0)
    802055b6:	07c1                	addi	a5,a5,16
    802055b8:	85be                	mv	a1,a5
    802055ba:	853a                	mv	a0,a4
    802055bc:	fffff097          	auipc	ra,0xfffff
    802055c0:	244080e7          	jalr	580(ra) # 80204800 <swtch>
			c = mycpu();
    802055c4:	fffff097          	auipc	ra,0xfffff
    802055c8:	3d4080e7          	jalr	980(ra) # 80204998 <mycpu>
    802055cc:	fea43423          	sd	a0,-24(s0)
			c->proc = 0;
    802055d0:	fe843783          	ld	a5,-24(s0)
    802055d4:	0007b023          	sd	zero,0(a5)
			current_proc = 0;
    802055d8:	00009797          	auipc	a5,0x9
    802055dc:	ad078793          	addi	a5,a5,-1328 # 8020e0a8 <current_proc>
    802055e0:	0007b023          	sd	zero,0(a5)
    for(int i = 0; i < PROC; i++) {
    802055e4:	fe442783          	lw	a5,-28(s0)
    802055e8:	2785                	addiw	a5,a5,1
    802055ea:	fef42223          	sw	a5,-28(s0)
    802055ee:	fe442783          	lw	a5,-28(s0)
    802055f2:	0007871b          	sext.w	a4,a5
    802055f6:	47fd                	li	a5,31
    802055f8:	f6e7d7e3          	bge	a5,a4,80205566 <schedule+0x64>
    intr_on();
    802055fc:	bfb1                	j	80205558 <schedule+0x56>

00000000802055fe <yield>:
void yield(void) {
    802055fe:	1101                	addi	sp,sp,-32
    80205600:	ec06                	sd	ra,24(sp)
    80205602:	e822                	sd	s0,16(sp)
    80205604:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80205606:	fffff097          	auipc	ra,0xfffff
    8020560a:	37a080e7          	jalr	890(ra) # 80204980 <myproc>
    8020560e:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205612:	fe843783          	ld	a5,-24(s0)
    80205616:	c7cd                	beqz	a5,802056c0 <yield+0xc2>
    if (p->state != RUNNING) {
    80205618:	fe843783          	ld	a5,-24(s0)
    8020561c:	439c                	lw	a5,0(a5)
    8020561e:	873e                	mv	a4,a5
    80205620:	4791                	li	a5,4
    80205622:	00f70f63          	beq	a4,a5,80205640 <yield+0x42>
        warning("yield when status is not RUNNING (%d)\n", p->state);
    80205626:	fe843783          	ld	a5,-24(s0)
    8020562a:	439c                	lw	a5,0(a5)
    8020562c:	85be                	mv	a1,a5
    8020562e:	00005517          	auipc	a0,0x5
    80205632:	17a50513          	addi	a0,a0,378 # 8020a7a8 <simple_user_task_bin+0x3f8>
    80205636:	ffffc097          	auipc	ra,0xffffc
    8020563a:	0de080e7          	jalr	222(ra) # 80201714 <warning>
        return;
    8020563e:	a051                	j	802056c2 <yield+0xc4>
    intr_off();
    80205640:	fffff097          	auipc	ra,0xfffff
    80205644:	288080e7          	jalr	648(ra) # 802048c8 <intr_off>
    struct cpu *c = mycpu();
    80205648:	fffff097          	auipc	ra,0xfffff
    8020564c:	350080e7          	jalr	848(ra) # 80204998 <mycpu>
    80205650:	fea43023          	sd	a0,-32(s0)
    p->state = RUNNABLE;
    80205654:	fe843783          	ld	a5,-24(s0)
    80205658:	470d                	li	a4,3
    8020565a:	c398                	sw	a4,0(a5)
    p->context.ra = ra;
    8020565c:	8706                	mv	a4,ra
    8020565e:	fe843783          	ld	a5,-24(s0)
    80205662:	eb98                	sd	a4,16(a5)
    if (c->context.ra == 0) {
    80205664:	fe043783          	ld	a5,-32(s0)
    80205668:	679c                	ld	a5,8(a5)
    8020566a:	ef99                	bnez	a5,80205688 <yield+0x8a>
        c->context.ra = (uint64)schedule;
    8020566c:	00000717          	auipc	a4,0x0
    80205670:	e9670713          	addi	a4,a4,-362 # 80205502 <schedule>
    80205674:	fe043783          	ld	a5,-32(s0)
    80205678:	e798                	sd	a4,8(a5)
        c->context.sp = (uint64)c + PGSIZE;
    8020567a:	fe043703          	ld	a4,-32(s0)
    8020567e:	6785                	lui	a5,0x1
    80205680:	973e                	add	a4,a4,a5
    80205682:	fe043783          	ld	a5,-32(s0)
    80205686:	eb98                	sd	a4,16(a5)
    current_proc = 0;
    80205688:	00009797          	auipc	a5,0x9
    8020568c:	a2078793          	addi	a5,a5,-1504 # 8020e0a8 <current_proc>
    80205690:	0007b023          	sd	zero,0(a5)
    c->proc = 0;
    80205694:	fe043783          	ld	a5,-32(s0)
    80205698:	0007b023          	sd	zero,0(a5)
    swtch(&p->context, &c->context);
    8020569c:	fe843783          	ld	a5,-24(s0)
    802056a0:	01078713          	addi	a4,a5,16
    802056a4:	fe043783          	ld	a5,-32(s0)
    802056a8:	07a1                	addi	a5,a5,8
    802056aa:	85be                	mv	a1,a5
    802056ac:	853a                	mv	a0,a4
    802056ae:	fffff097          	auipc	ra,0xfffff
    802056b2:	152080e7          	jalr	338(ra) # 80204800 <swtch>
    intr_on();
    802056b6:	fffff097          	auipc	ra,0xfffff
    802056ba:	1e8080e7          	jalr	488(ra) # 8020489e <intr_on>
    802056be:	a011                	j	802056c2 <yield+0xc4>
        return;
    802056c0:	0001                	nop
}
    802056c2:	60e2                	ld	ra,24(sp)
    802056c4:	6442                	ld	s0,16(sp)
    802056c6:	6105                	addi	sp,sp,32
    802056c8:	8082                	ret

00000000802056ca <sleep>:
void sleep(void *chan){
    802056ca:	7179                	addi	sp,sp,-48
    802056cc:	f406                	sd	ra,40(sp)
    802056ce:	f022                	sd	s0,32(sp)
    802056d0:	1800                	addi	s0,sp,48
    802056d2:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = myproc();
    802056d6:	fffff097          	auipc	ra,0xfffff
    802056da:	2aa080e7          	jalr	682(ra) # 80204980 <myproc>
    802056de:	fea43423          	sd	a0,-24(s0)
    struct cpu *c = mycpu();
    802056e2:	fffff097          	auipc	ra,0xfffff
    802056e6:	2b6080e7          	jalr	694(ra) # 80204998 <mycpu>
    802056ea:	fea43023          	sd	a0,-32(s0)
    p->context.ra = ra;
    802056ee:	8706                	mv	a4,ra
    802056f0:	fe843783          	ld	a5,-24(s0)
    802056f4:	eb98                	sd	a4,16(a5)
    p->chan = chan;
    802056f6:	fe843783          	ld	a5,-24(s0)
    802056fa:	fd843703          	ld	a4,-40(s0)
    802056fe:	f3d8                	sd	a4,160(a5)
    p->state = SLEEPING;
    80205700:	fe843783          	ld	a5,-24(s0)
    80205704:	4709                	li	a4,2
    80205706:	c398                	sw	a4,0(a5)
    swtch(&p->context, &c->context);
    80205708:	fe843783          	ld	a5,-24(s0)
    8020570c:	01078713          	addi	a4,a5,16
    80205710:	fe043783          	ld	a5,-32(s0)
    80205714:	07a1                	addi	a5,a5,8
    80205716:	85be                	mv	a1,a5
    80205718:	853a                	mv	a0,a4
    8020571a:	fffff097          	auipc	ra,0xfffff
    8020571e:	0e6080e7          	jalr	230(ra) # 80204800 <swtch>
    p->chan = 0;
    80205722:	fe843783          	ld	a5,-24(s0)
    80205726:	0a07b023          	sd	zero,160(a5)
}
    8020572a:	0001                	nop
    8020572c:	70a2                	ld	ra,40(sp)
    8020572e:	7402                	ld	s0,32(sp)
    80205730:	6145                	addi	sp,sp,48
    80205732:	8082                	ret

0000000080205734 <wakeup>:
void wakeup(void *chan) {
    80205734:	7179                	addi	sp,sp,-48
    80205736:	f422                	sd	s0,40(sp)
    80205738:	1800                	addi	s0,sp,48
    8020573a:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < PROC; i++) {
    8020573e:	fe042623          	sw	zero,-20(s0)
    80205742:	a099                	j	80205788 <wakeup+0x54>
        struct proc *p = proc_table[i];
    80205744:	00009717          	auipc	a4,0x9
    80205748:	d2470713          	addi	a4,a4,-732 # 8020e468 <proc_table>
    8020574c:	fec42783          	lw	a5,-20(s0)
    80205750:	078e                	slli	a5,a5,0x3
    80205752:	97ba                	add	a5,a5,a4
    80205754:	639c                	ld	a5,0(a5)
    80205756:	fef43023          	sd	a5,-32(s0)
        if(p->state == SLEEPING && p->chan == chan) {
    8020575a:	fe043783          	ld	a5,-32(s0)
    8020575e:	439c                	lw	a5,0(a5)
    80205760:	873e                	mv	a4,a5
    80205762:	4789                	li	a5,2
    80205764:	00f71d63          	bne	a4,a5,8020577e <wakeup+0x4a>
    80205768:	fe043783          	ld	a5,-32(s0)
    8020576c:	73dc                	ld	a5,160(a5)
    8020576e:	fd843703          	ld	a4,-40(s0)
    80205772:	00f71663          	bne	a4,a5,8020577e <wakeup+0x4a>
            p->state = RUNNABLE;
    80205776:	fe043783          	ld	a5,-32(s0)
    8020577a:	470d                	li	a4,3
    8020577c:	c398                	sw	a4,0(a5)
    for(int i = 0; i < PROC; i++) {
    8020577e:	fec42783          	lw	a5,-20(s0)
    80205782:	2785                	addiw	a5,a5,1
    80205784:	fef42623          	sw	a5,-20(s0)
    80205788:	fec42783          	lw	a5,-20(s0)
    8020578c:	0007871b          	sext.w	a4,a5
    80205790:	47fd                	li	a5,31
    80205792:	fae7d9e3          	bge	a5,a4,80205744 <wakeup+0x10>
}
    80205796:	0001                	nop
    80205798:	0001                	nop
    8020579a:	7422                	ld	s0,40(sp)
    8020579c:	6145                	addi	sp,sp,48
    8020579e:	8082                	ret

00000000802057a0 <exit_proc>:
void exit_proc(int status) {
    802057a0:	7179                	addi	sp,sp,-48
    802057a2:	f406                	sd	ra,40(sp)
    802057a4:	f022                	sd	s0,32(sp)
    802057a6:	1800                	addi	s0,sp,48
    802057a8:	87aa                	mv	a5,a0
    802057aa:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    802057ae:	fffff097          	auipc	ra,0xfffff
    802057b2:	1d2080e7          	jalr	466(ra) # 80204980 <myproc>
    802057b6:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    802057ba:	fe843783          	ld	a5,-24(s0)
    802057be:	eb89                	bnez	a5,802057d0 <exit_proc+0x30>
        panic("exit_proc: no current process");
    802057c0:	00005517          	auipc	a0,0x5
    802057c4:	01050513          	addi	a0,a0,16 # 8020a7d0 <simple_user_task_bin+0x420>
    802057c8:	ffffc097          	auipc	ra,0xffffc
    802057cc:	f18080e7          	jalr	-232(ra) # 802016e0 <panic>
    p->exit_status = status;
    802057d0:	fe843783          	ld	a5,-24(s0)
    802057d4:	fdc42703          	lw	a4,-36(s0)
    802057d8:	08e7a223          	sw	a4,132(a5)
    if (!p->parent) {
    802057dc:	fe843783          	ld	a5,-24(s0)
    802057e0:	6fdc                	ld	a5,152(a5)
    802057e2:	e789                	bnez	a5,802057ec <exit_proc+0x4c>
        shutdown();
    802057e4:	fffff097          	auipc	ra,0xfffff
    802057e8:	172080e7          	jalr	370(ra) # 80204956 <shutdown>
    p->state = ZOMBIE;
    802057ec:	fe843783          	ld	a5,-24(s0)
    802057f0:	4715                	li	a4,5
    802057f2:	c398                	sw	a4,0(a5)
    wakeup((void*)p->parent);
    802057f4:	fe843783          	ld	a5,-24(s0)
    802057f8:	6fdc                	ld	a5,152(a5)
    802057fa:	853e                	mv	a0,a5
    802057fc:	00000097          	auipc	ra,0x0
    80205800:	f38080e7          	jalr	-200(ra) # 80205734 <wakeup>
    current_proc = 0;
    80205804:	00009797          	auipc	a5,0x9
    80205808:	8a478793          	addi	a5,a5,-1884 # 8020e0a8 <current_proc>
    8020580c:	0007b023          	sd	zero,0(a5)
    if (mycpu())
    80205810:	fffff097          	auipc	ra,0xfffff
    80205814:	188080e7          	jalr	392(ra) # 80204998 <mycpu>
    80205818:	87aa                	mv	a5,a0
    8020581a:	cb81                	beqz	a5,8020582a <exit_proc+0x8a>
        mycpu()->proc = 0;
    8020581c:	fffff097          	auipc	ra,0xfffff
    80205820:	17c080e7          	jalr	380(ra) # 80204998 <mycpu>
    80205824:	87aa                	mv	a5,a0
    80205826:	0007b023          	sd	zero,0(a5)
    struct cpu *c = mycpu();
    8020582a:	fffff097          	auipc	ra,0xfffff
    8020582e:	16e080e7          	jalr	366(ra) # 80204998 <mycpu>
    80205832:	fea43023          	sd	a0,-32(s0)
    swtch(&p->context, &c->context);
    80205836:	fe843783          	ld	a5,-24(s0)
    8020583a:	01078713          	addi	a4,a5,16
    8020583e:	fe043783          	ld	a5,-32(s0)
    80205842:	07a1                	addi	a5,a5,8
    80205844:	85be                	mv	a1,a5
    80205846:	853a                	mv	a0,a4
    80205848:	fffff097          	auipc	ra,0xfffff
    8020584c:	fb8080e7          	jalr	-72(ra) # 80204800 <swtch>
    
    panic("exit_proc should not return after schedule");
    80205850:	00005517          	auipc	a0,0x5
    80205854:	fa050513          	addi	a0,a0,-96 # 8020a7f0 <simple_user_task_bin+0x440>
    80205858:	ffffc097          	auipc	ra,0xffffc
    8020585c:	e88080e7          	jalr	-376(ra) # 802016e0 <panic>
}
    80205860:	0001                	nop
    80205862:	70a2                	ld	ra,40(sp)
    80205864:	7402                	ld	s0,32(sp)
    80205866:	6145                	addi	sp,sp,48
    80205868:	8082                	ret

000000008020586a <wait_proc>:
int wait_proc(int *status) {
    8020586a:	711d                	addi	sp,sp,-96
    8020586c:	ec86                	sd	ra,88(sp)
    8020586e:	e8a2                	sd	s0,80(sp)
    80205870:	1080                	addi	s0,sp,96
    80205872:	faa43423          	sd	a0,-88(s0)
    struct proc *p = myproc();
    80205876:	fffff097          	auipc	ra,0xfffff
    8020587a:	10a080e7          	jalr	266(ra) # 80204980 <myproc>
    8020587e:	fca43023          	sd	a0,-64(s0)
    
    if (p == 0) {
    80205882:	fc043783          	ld	a5,-64(s0)
    80205886:	eb99                	bnez	a5,8020589c <wait_proc+0x32>
        printf("Warning: wait_proc called with no current process\n");
    80205888:	00005517          	auipc	a0,0x5
    8020588c:	f9850513          	addi	a0,a0,-104 # 8020a820 <simple_user_task_bin+0x470>
    80205890:	ffffb097          	auipc	ra,0xffffb
    80205894:	404080e7          	jalr	1028(ra) # 80200c94 <printf>
        return -1;
    80205898:	57fd                	li	a5,-1
    8020589a:	aa91                	j	802059ee <wait_proc+0x184>
    }
    
    while (1) {
        // 关中断确保原子操作
        intr_off();
    8020589c:	fffff097          	auipc	ra,0xfffff
    802058a0:	02c080e7          	jalr	44(ra) # 802048c8 <intr_off>
        
        // 优先检查是否有僵尸子进程
        int found_zombie = 0;
    802058a4:	fe042623          	sw	zero,-20(s0)
        int zombie_pid = 0;
    802058a8:	fe042423          	sw	zero,-24(s0)
        int zombie_status = 0;
    802058ac:	fe042223          	sw	zero,-28(s0)
        struct proc *zombie_child = 0;
    802058b0:	fc043c23          	sd	zero,-40(s0)
        
        // 先查找ZOMBIE状态的子进程
        for (int i = 0; i < PROC; i++) {
    802058b4:	fc042a23          	sw	zero,-44(s0)
    802058b8:	a095                	j	8020591c <wait_proc+0xb2>
            struct proc *child = proc_table[i];
    802058ba:	00009717          	auipc	a4,0x9
    802058be:	bae70713          	addi	a4,a4,-1106 # 8020e468 <proc_table>
    802058c2:	fd442783          	lw	a5,-44(s0)
    802058c6:	078e                	slli	a5,a5,0x3
    802058c8:	97ba                	add	a5,a5,a4
    802058ca:	639c                	ld	a5,0(a5)
    802058cc:	faf43c23          	sd	a5,-72(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    802058d0:	fb843783          	ld	a5,-72(s0)
    802058d4:	439c                	lw	a5,0(a5)
    802058d6:	873e                	mv	a4,a5
    802058d8:	4795                	li	a5,5
    802058da:	02f71c63          	bne	a4,a5,80205912 <wait_proc+0xa8>
    802058de:	fb843783          	ld	a5,-72(s0)
    802058e2:	6fdc                	ld	a5,152(a5)
    802058e4:	fc043703          	ld	a4,-64(s0)
    802058e8:	02f71563          	bne	a4,a5,80205912 <wait_proc+0xa8>
                found_zombie = 1;
    802058ec:	4785                	li	a5,1
    802058ee:	fef42623          	sw	a5,-20(s0)
                zombie_pid = child->pid;
    802058f2:	fb843783          	ld	a5,-72(s0)
    802058f6:	43dc                	lw	a5,4(a5)
    802058f8:	fef42423          	sw	a5,-24(s0)
                zombie_status = child->exit_status;
    802058fc:	fb843783          	ld	a5,-72(s0)
    80205900:	0847a783          	lw	a5,132(a5)
    80205904:	fef42223          	sw	a5,-28(s0)
                zombie_child = child;
    80205908:	fb843783          	ld	a5,-72(s0)
    8020590c:	fcf43c23          	sd	a5,-40(s0)
                break;
    80205910:	a829                	j	8020592a <wait_proc+0xc0>
        for (int i = 0; i < PROC; i++) {
    80205912:	fd442783          	lw	a5,-44(s0)
    80205916:	2785                	addiw	a5,a5,1
    80205918:	fcf42a23          	sw	a5,-44(s0)
    8020591c:	fd442783          	lw	a5,-44(s0)
    80205920:	0007871b          	sext.w	a4,a5
    80205924:	47fd                	li	a5,31
    80205926:	f8e7dae3          	bge	a5,a4,802058ba <wait_proc+0x50>
            }
        }
        
        if (found_zombie) {
    8020592a:	fec42783          	lw	a5,-20(s0)
    8020592e:	2781                	sext.w	a5,a5
    80205930:	cb85                	beqz	a5,80205960 <wait_proc+0xf6>
            if (status)
    80205932:	fa843783          	ld	a5,-88(s0)
    80205936:	c791                	beqz	a5,80205942 <wait_proc+0xd8>
                *status = zombie_status;
    80205938:	fa843783          	ld	a5,-88(s0)
    8020593c:	fe442703          	lw	a4,-28(s0)
    80205940:	c398                	sw	a4,0(a5)

            free_proc(zombie_child);
    80205942:	fd843503          	ld	a0,-40(s0)
    80205946:	fffff097          	auipc	ra,0xfffff
    8020594a:	69c080e7          	jalr	1692(ra) # 80204fe2 <free_proc>
            zombie_child = NULL;
    8020594e:	fc043c23          	sd	zero,-40(s0)
            intr_on();
    80205952:	fffff097          	auipc	ra,0xfffff
    80205956:	f4c080e7          	jalr	-180(ra) # 8020489e <intr_on>
            return zombie_pid;
    8020595a:	fe842783          	lw	a5,-24(s0)
    8020595e:	a841                	j	802059ee <wait_proc+0x184>
        }
        
        // 检查是否有任何活跃的子进程（非ZOMBIE状态）
        int havekids = 0;
    80205960:	fc042823          	sw	zero,-48(s0)
        for (int i = 0; i < PROC; i++) {
    80205964:	fc042623          	sw	zero,-52(s0)
    80205968:	a0b9                	j	802059b6 <wait_proc+0x14c>
            struct proc *child = proc_table[i];
    8020596a:	00009717          	auipc	a4,0x9
    8020596e:	afe70713          	addi	a4,a4,-1282 # 8020e468 <proc_table>
    80205972:	fcc42783          	lw	a5,-52(s0)
    80205976:	078e                	slli	a5,a5,0x3
    80205978:	97ba                	add	a5,a5,a4
    8020597a:	639c                	ld	a5,0(a5)
    8020597c:	faf43823          	sd	a5,-80(s0)
            if (child->state != UNUSED && child->state != ZOMBIE && child->parent == p) {
    80205980:	fb043783          	ld	a5,-80(s0)
    80205984:	439c                	lw	a5,0(a5)
    80205986:	c39d                	beqz	a5,802059ac <wait_proc+0x142>
    80205988:	fb043783          	ld	a5,-80(s0)
    8020598c:	439c                	lw	a5,0(a5)
    8020598e:	873e                	mv	a4,a5
    80205990:	4795                	li	a5,5
    80205992:	00f70d63          	beq	a4,a5,802059ac <wait_proc+0x142>
    80205996:	fb043783          	ld	a5,-80(s0)
    8020599a:	6fdc                	ld	a5,152(a5)
    8020599c:	fc043703          	ld	a4,-64(s0)
    802059a0:	00f71663          	bne	a4,a5,802059ac <wait_proc+0x142>
                havekids = 1;
    802059a4:	4785                	li	a5,1
    802059a6:	fcf42823          	sw	a5,-48(s0)
                break;
    802059aa:	a829                	j	802059c4 <wait_proc+0x15a>
        for (int i = 0; i < PROC; i++) {
    802059ac:	fcc42783          	lw	a5,-52(s0)
    802059b0:	2785                	addiw	a5,a5,1
    802059b2:	fcf42623          	sw	a5,-52(s0)
    802059b6:	fcc42783          	lw	a5,-52(s0)
    802059ba:	0007871b          	sext.w	a4,a5
    802059be:	47fd                	li	a5,31
    802059c0:	fae7d5e3          	bge	a5,a4,8020596a <wait_proc+0x100>
            }
        }
        
        if (!havekids) {
    802059c4:	fd042783          	lw	a5,-48(s0)
    802059c8:	2781                	sext.w	a5,a5
    802059ca:	e799                	bnez	a5,802059d8 <wait_proc+0x16e>
            intr_on();
    802059cc:	fffff097          	auipc	ra,0xfffff
    802059d0:	ed2080e7          	jalr	-302(ra) # 8020489e <intr_on>
            return -1;
    802059d4:	57fd                	li	a5,-1
    802059d6:	a821                	j	802059ee <wait_proc+0x184>
        }
        
        // 有活跃子进程但没有僵尸子进程，进入睡眠等待
		intr_on();
    802059d8:	fffff097          	auipc	ra,0xfffff
    802059dc:	ec6080e7          	jalr	-314(ra) # 8020489e <intr_on>
        sleep((void*)p);
    802059e0:	fc043503          	ld	a0,-64(s0)
    802059e4:	00000097          	auipc	ra,0x0
    802059e8:	ce6080e7          	jalr	-794(ra) # 802056ca <sleep>
    while (1) {
    802059ec:	bd45                	j	8020589c <wait_proc+0x32>
    }
}
    802059ee:	853e                	mv	a0,a5
    802059f0:	60e6                	ld	ra,88(sp)
    802059f2:	6446                	ld	s0,80(sp)
    802059f4:	6125                	addi	sp,sp,96
    802059f6:	8082                	ret

00000000802059f8 <print_proc_table>:

void print_proc_table(void) {
    802059f8:	715d                	addi	sp,sp,-80
    802059fa:	e486                	sd	ra,72(sp)
    802059fc:	e0a2                	sd	s0,64(sp)
    802059fe:	0880                	addi	s0,sp,80
    int count = 0;
    80205a00:	fe042623          	sw	zero,-20(s0)
    printf("PID  TYPE STATUS     PPID   FUNC_ADDR      STACK_ADDR    \n");
    80205a04:	00005517          	auipc	a0,0x5
    80205a08:	e5450513          	addi	a0,a0,-428 # 8020a858 <simple_user_task_bin+0x4a8>
    80205a0c:	ffffb097          	auipc	ra,0xffffb
    80205a10:	288080e7          	jalr	648(ra) # 80200c94 <printf>
    printf("----------------------------------------------------------\n");
    80205a14:	00005517          	auipc	a0,0x5
    80205a18:	e8450513          	addi	a0,a0,-380 # 8020a898 <simple_user_task_bin+0x4e8>
    80205a1c:	ffffb097          	auipc	ra,0xffffb
    80205a20:	278080e7          	jalr	632(ra) # 80200c94 <printf>
    for(int i = 0; i < PROC; i++) {
    80205a24:	fe042423          	sw	zero,-24(s0)
    80205a28:	a2a9                	j	80205b72 <print_proc_table+0x17a>
        struct proc *p = proc_table[i];
    80205a2a:	00009717          	auipc	a4,0x9
    80205a2e:	a3e70713          	addi	a4,a4,-1474 # 8020e468 <proc_table>
    80205a32:	fe842783          	lw	a5,-24(s0)
    80205a36:	078e                	slli	a5,a5,0x3
    80205a38:	97ba                	add	a5,a5,a4
    80205a3a:	639c                	ld	a5,0(a5)
    80205a3c:	fcf43c23          	sd	a5,-40(s0)
        if(p->state != UNUSED) {
    80205a40:	fd843783          	ld	a5,-40(s0)
    80205a44:	439c                	lw	a5,0(a5)
    80205a46:	12078163          	beqz	a5,80205b68 <print_proc_table+0x170>
            count++;
    80205a4a:	fec42783          	lw	a5,-20(s0)
    80205a4e:	2785                	addiw	a5,a5,1
    80205a50:	fef42623          	sw	a5,-20(s0)
            const char *type = (p->is_user ? "USR" : "SYS");
    80205a54:	fd843783          	ld	a5,-40(s0)
    80205a58:	0a87a783          	lw	a5,168(a5)
    80205a5c:	c791                	beqz	a5,80205a68 <print_proc_table+0x70>
    80205a5e:	00005797          	auipc	a5,0x5
    80205a62:	e7a78793          	addi	a5,a5,-390 # 8020a8d8 <simple_user_task_bin+0x528>
    80205a66:	a029                	j	80205a70 <print_proc_table+0x78>
    80205a68:	00005797          	auipc	a5,0x5
    80205a6c:	e7878793          	addi	a5,a5,-392 # 8020a8e0 <simple_user_task_bin+0x530>
    80205a70:	fcf43823          	sd	a5,-48(s0)
            const char *status;
            switch(p->state) {
    80205a74:	fd843783          	ld	a5,-40(s0)
    80205a78:	439c                	lw	a5,0(a5)
    80205a7a:	86be                	mv	a3,a5
    80205a7c:	4715                	li	a4,5
    80205a7e:	06d76c63          	bltu	a4,a3,80205af6 <print_proc_table+0xfe>
    80205a82:	00279713          	slli	a4,a5,0x2
    80205a86:	00005797          	auipc	a5,0x5
    80205a8a:	ee278793          	addi	a5,a5,-286 # 8020a968 <simple_user_task_bin+0x5b8>
    80205a8e:	97ba                	add	a5,a5,a4
    80205a90:	439c                	lw	a5,0(a5)
    80205a92:	0007871b          	sext.w	a4,a5
    80205a96:	00005797          	auipc	a5,0x5
    80205a9a:	ed278793          	addi	a5,a5,-302 # 8020a968 <simple_user_task_bin+0x5b8>
    80205a9e:	97ba                	add	a5,a5,a4
    80205aa0:	8782                	jr	a5
                case UNUSED:   status = "UNUSED"; break;
    80205aa2:	00005797          	auipc	a5,0x5
    80205aa6:	e4678793          	addi	a5,a5,-442 # 8020a8e8 <simple_user_task_bin+0x538>
    80205aaa:	fef43023          	sd	a5,-32(s0)
    80205aae:	a899                	j	80205b04 <print_proc_table+0x10c>
                case USED:     status = "USED"; break;
    80205ab0:	00005797          	auipc	a5,0x5
    80205ab4:	e4078793          	addi	a5,a5,-448 # 8020a8f0 <simple_user_task_bin+0x540>
    80205ab8:	fef43023          	sd	a5,-32(s0)
    80205abc:	a0a1                	j	80205b04 <print_proc_table+0x10c>
                case SLEEPING: status = "SLEEP"; break;
    80205abe:	00005797          	auipc	a5,0x5
    80205ac2:	e3a78793          	addi	a5,a5,-454 # 8020a8f8 <simple_user_task_bin+0x548>
    80205ac6:	fef43023          	sd	a5,-32(s0)
    80205aca:	a82d                	j	80205b04 <print_proc_table+0x10c>
                case RUNNABLE: status = "RUNNABLE"; break;
    80205acc:	00005797          	auipc	a5,0x5
    80205ad0:	e3478793          	addi	a5,a5,-460 # 8020a900 <simple_user_task_bin+0x550>
    80205ad4:	fef43023          	sd	a5,-32(s0)
    80205ad8:	a035                	j	80205b04 <print_proc_table+0x10c>
                case RUNNING:  status = "RUNNING"; break;
    80205ada:	00005797          	auipc	a5,0x5
    80205ade:	e3678793          	addi	a5,a5,-458 # 8020a910 <simple_user_task_bin+0x560>
    80205ae2:	fef43023          	sd	a5,-32(s0)
    80205ae6:	a839                	j	80205b04 <print_proc_table+0x10c>
                case ZOMBIE:   status = "ZOMBIE"; break;
    80205ae8:	00005797          	auipc	a5,0x5
    80205aec:	e3078793          	addi	a5,a5,-464 # 8020a918 <simple_user_task_bin+0x568>
    80205af0:	fef43023          	sd	a5,-32(s0)
    80205af4:	a801                	j	80205b04 <print_proc_table+0x10c>
                default:       status = "UNKNOWN"; break;
    80205af6:	00005797          	auipc	a5,0x5
    80205afa:	e2a78793          	addi	a5,a5,-470 # 8020a920 <simple_user_task_bin+0x570>
    80205afe:	fef43023          	sd	a5,-32(s0)
    80205b02:	0001                	nop
            }
            int ppid = p->parent ? p->parent->pid : -1;
    80205b04:	fd843783          	ld	a5,-40(s0)
    80205b08:	6fdc                	ld	a5,152(a5)
    80205b0a:	c791                	beqz	a5,80205b16 <print_proc_table+0x11e>
    80205b0c:	fd843783          	ld	a5,-40(s0)
    80205b10:	6fdc                	ld	a5,152(a5)
    80205b12:	43dc                	lw	a5,4(a5)
    80205b14:	a011                	j	80205b18 <print_proc_table+0x120>
    80205b16:	57fd                	li	a5,-1
    80205b18:	fcf42623          	sw	a5,-52(s0)
            unsigned long func_addr = p->trapframe ? p->trapframe->epc : 0;
    80205b1c:	fd843783          	ld	a5,-40(s0)
    80205b20:	63fc                	ld	a5,192(a5)
    80205b22:	c791                	beqz	a5,80205b2e <print_proc_table+0x136>
    80205b24:	fd843783          	ld	a5,-40(s0)
    80205b28:	63fc                	ld	a5,192(a5)
    80205b2a:	739c                	ld	a5,32(a5)
    80205b2c:	a011                	j	80205b30 <print_proc_table+0x138>
    80205b2e:	4781                	li	a5,0
    80205b30:	fcf43023          	sd	a5,-64(s0)
            unsigned long stack_addr = p->kstack;
    80205b34:	fd843783          	ld	a5,-40(s0)
    80205b38:	679c                	ld	a5,8(a5)
    80205b3a:	faf43c23          	sd	a5,-72(s0)
            printf("%2d  %3s %8s %4d 0x%012lx 0x%012lx\n",
    80205b3e:	fd843783          	ld	a5,-40(s0)
    80205b42:	43cc                	lw	a1,4(a5)
    80205b44:	fcc42703          	lw	a4,-52(s0)
    80205b48:	fb843803          	ld	a6,-72(s0)
    80205b4c:	fc043783          	ld	a5,-64(s0)
    80205b50:	fe043683          	ld	a3,-32(s0)
    80205b54:	fd043603          	ld	a2,-48(s0)
    80205b58:	00005517          	auipc	a0,0x5
    80205b5c:	dd050513          	addi	a0,a0,-560 # 8020a928 <simple_user_task_bin+0x578>
    80205b60:	ffffb097          	auipc	ra,0xffffb
    80205b64:	134080e7          	jalr	308(ra) # 80200c94 <printf>
    for(int i = 0; i < PROC; i++) {
    80205b68:	fe842783          	lw	a5,-24(s0)
    80205b6c:	2785                	addiw	a5,a5,1
    80205b6e:	fef42423          	sw	a5,-24(s0)
    80205b72:	fe842783          	lw	a5,-24(s0)
    80205b76:	0007871b          	sext.w	a4,a5
    80205b7a:	47fd                	li	a5,31
    80205b7c:	eae7d7e3          	bge	a5,a4,80205a2a <print_proc_table+0x32>
                p->pid, type, status, ppid, func_addr, stack_addr);
        }
    }
    printf("----------------------------------------------------------\n");
    80205b80:	00005517          	auipc	a0,0x5
    80205b84:	d1850513          	addi	a0,a0,-744 # 8020a898 <simple_user_task_bin+0x4e8>
    80205b88:	ffffb097          	auipc	ra,0xffffb
    80205b8c:	10c080e7          	jalr	268(ra) # 80200c94 <printf>
    printf("%d active processes\n", count);
    80205b90:	fec42783          	lw	a5,-20(s0)
    80205b94:	85be                	mv	a1,a5
    80205b96:	00005517          	auipc	a0,0x5
    80205b9a:	dba50513          	addi	a0,a0,-582 # 8020a950 <simple_user_task_bin+0x5a0>
    80205b9e:	ffffb097          	auipc	ra,0xffffb
    80205ba2:	0f6080e7          	jalr	246(ra) # 80200c94 <printf>
}
    80205ba6:	0001                	nop
    80205ba8:	60a6                	ld	ra,72(sp)
    80205baa:	6406                	ld	s0,64(sp)
    80205bac:	6161                	addi	sp,sp,80
    80205bae:	8082                	ret

0000000080205bb0 <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    80205bb0:	7179                	addi	sp,sp,-48
    80205bb2:	f422                	sd	s0,40(sp)
    80205bb4:	1800                	addi	s0,sp,48
    80205bb6:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    80205bba:	fe042623          	sw	zero,-20(s0)
    80205bbe:	a031                	j	80205bca <strlen+0x1a>
    80205bc0:	fec42783          	lw	a5,-20(s0)
    80205bc4:	2785                	addiw	a5,a5,1
    80205bc6:	fef42623          	sw	a5,-20(s0)
    80205bca:	fec42783          	lw	a5,-20(s0)
    80205bce:	fd843703          	ld	a4,-40(s0)
    80205bd2:	97ba                	add	a5,a5,a4
    80205bd4:	0007c783          	lbu	a5,0(a5)
    80205bd8:	f7e5                	bnez	a5,80205bc0 <strlen+0x10>
        ;
    return n;
    80205bda:	fec42783          	lw	a5,-20(s0)
}
    80205bde:	853e                	mv	a0,a5
    80205be0:	7422                	ld	s0,40(sp)
    80205be2:	6145                	addi	sp,sp,48
    80205be4:	8082                	ret

0000000080205be6 <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    80205be6:	1101                	addi	sp,sp,-32
    80205be8:	ec22                	sd	s0,24(sp)
    80205bea:	1000                	addi	s0,sp,32
    80205bec:	fea43423          	sd	a0,-24(s0)
    80205bf0:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    80205bf4:	a819                	j	80205c0a <strcmp+0x24>
        p++, q++;
    80205bf6:	fe843783          	ld	a5,-24(s0)
    80205bfa:	0785                	addi	a5,a5,1
    80205bfc:	fef43423          	sd	a5,-24(s0)
    80205c00:	fe043783          	ld	a5,-32(s0)
    80205c04:	0785                	addi	a5,a5,1
    80205c06:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    80205c0a:	fe843783          	ld	a5,-24(s0)
    80205c0e:	0007c783          	lbu	a5,0(a5)
    80205c12:	cb99                	beqz	a5,80205c28 <strcmp+0x42>
    80205c14:	fe843783          	ld	a5,-24(s0)
    80205c18:	0007c703          	lbu	a4,0(a5)
    80205c1c:	fe043783          	ld	a5,-32(s0)
    80205c20:	0007c783          	lbu	a5,0(a5)
    80205c24:	fcf709e3          	beq	a4,a5,80205bf6 <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    80205c28:	fe843783          	ld	a5,-24(s0)
    80205c2c:	0007c783          	lbu	a5,0(a5)
    80205c30:	0007871b          	sext.w	a4,a5
    80205c34:	fe043783          	ld	a5,-32(s0)
    80205c38:	0007c783          	lbu	a5,0(a5)
    80205c3c:	2781                	sext.w	a5,a5
    80205c3e:	40f707bb          	subw	a5,a4,a5
    80205c42:	2781                	sext.w	a5,a5
}
    80205c44:	853e                	mv	a0,a5
    80205c46:	6462                	ld	s0,24(sp)
    80205c48:	6105                	addi	sp,sp,32
    80205c4a:	8082                	ret

0000000080205c4c <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    80205c4c:	7179                	addi	sp,sp,-48
    80205c4e:	f422                	sd	s0,40(sp)
    80205c50:	1800                	addi	s0,sp,48
    80205c52:	fca43c23          	sd	a0,-40(s0)
    80205c56:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    80205c5a:	fd843783          	ld	a5,-40(s0)
    80205c5e:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    80205c62:	0001                	nop
    80205c64:	fd043703          	ld	a4,-48(s0)
    80205c68:	00170793          	addi	a5,a4,1
    80205c6c:	fcf43823          	sd	a5,-48(s0)
    80205c70:	fd843783          	ld	a5,-40(s0)
    80205c74:	00178693          	addi	a3,a5,1
    80205c78:	fcd43c23          	sd	a3,-40(s0)
    80205c7c:	00074703          	lbu	a4,0(a4)
    80205c80:	00e78023          	sb	a4,0(a5)
    80205c84:	0007c783          	lbu	a5,0(a5)
    80205c88:	fff1                	bnez	a5,80205c64 <strcpy+0x18>
        ;
    return os;
    80205c8a:	fe843783          	ld	a5,-24(s0)
}
    80205c8e:	853e                	mv	a0,a5
    80205c90:	7422                	ld	s0,40(sp)
    80205c92:	6145                	addi	sp,sp,48
    80205c94:	8082                	ret

0000000080205c96 <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    80205c96:	7139                	addi	sp,sp,-64
    80205c98:	fc22                	sd	s0,56(sp)
    80205c9a:	0080                	addi	s0,sp,64
    80205c9c:	fca43c23          	sd	a0,-40(s0)
    80205ca0:	fcb43823          	sd	a1,-48(s0)
    80205ca4:	87b2                	mv	a5,a2
    80205ca6:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    80205caa:	fd843783          	ld	a5,-40(s0)
    80205cae:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    80205cb2:	fcc42783          	lw	a5,-52(s0)
    80205cb6:	2781                	sext.w	a5,a5
    80205cb8:	00f04563          	bgtz	a5,80205cc2 <safestrcpy+0x2c>
        return os;
    80205cbc:	fe843783          	ld	a5,-24(s0)
    80205cc0:	a0a9                	j	80205d0a <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    80205cc2:	0001                	nop
    80205cc4:	fcc42783          	lw	a5,-52(s0)
    80205cc8:	37fd                	addiw	a5,a5,-1
    80205cca:	fcf42623          	sw	a5,-52(s0)
    80205cce:	fcc42783          	lw	a5,-52(s0)
    80205cd2:	2781                	sext.w	a5,a5
    80205cd4:	02f05563          	blez	a5,80205cfe <safestrcpy+0x68>
    80205cd8:	fd043703          	ld	a4,-48(s0)
    80205cdc:	00170793          	addi	a5,a4,1
    80205ce0:	fcf43823          	sd	a5,-48(s0)
    80205ce4:	fd843783          	ld	a5,-40(s0)
    80205ce8:	00178693          	addi	a3,a5,1
    80205cec:	fcd43c23          	sd	a3,-40(s0)
    80205cf0:	00074703          	lbu	a4,0(a4)
    80205cf4:	00e78023          	sb	a4,0(a5)
    80205cf8:	0007c783          	lbu	a5,0(a5)
    80205cfc:	f7e1                	bnez	a5,80205cc4 <safestrcpy+0x2e>
        ;
    *s = 0;
    80205cfe:	fd843783          	ld	a5,-40(s0)
    80205d02:	00078023          	sb	zero,0(a5)
    return os;
    80205d06:	fe843783          	ld	a5,-24(s0)
    80205d0a:	853e                	mv	a0,a5
    80205d0c:	7462                	ld	s0,56(sp)
    80205d0e:	6121                	addi	sp,sp,64
    80205d10:	8082                	ret

0000000080205d12 <assert>:
}
void cpu_intensive_task(void) {
    uint64 sum = 0;
    for (uint64 i = 0; i < 10000000; i++) {
        sum += i;
    }
    80205d12:	1101                	addi	sp,sp,-32
    80205d14:	ec06                	sd	ra,24(sp)
    80205d16:	e822                	sd	s0,16(sp)
    80205d18:	1000                	addi	s0,sp,32
    80205d1a:	87aa                	mv	a5,a0
    80205d1c:	fef42623          	sw	a5,-20(s0)
    printf("CPU intensive task done in PID %d, sum=%lu\n", myproc()->pid, sum);
    80205d20:	fec42783          	lw	a5,-20(s0)
    80205d24:	2781                	sext.w	a5,a5
    80205d26:	e79d                	bnez	a5,80205d54 <assert+0x42>
    exit_proc(0);
    80205d28:	19c00613          	li	a2,412
    80205d2c:	00005597          	auipc	a1,0x5
    80205d30:	0f458593          	addi	a1,a1,244 # 8020ae20 <simple_user_task_bin+0x58>
    80205d34:	00005517          	auipc	a0,0x5
    80205d38:	0fc50513          	addi	a0,a0,252 # 8020ae30 <simple_user_task_bin+0x68>
    80205d3c:	ffffb097          	auipc	ra,0xffffb
    80205d40:	f58080e7          	jalr	-168(ra) # 80200c94 <printf>
}
    80205d44:	00005517          	auipc	a0,0x5
    80205d48:	11450513          	addi	a0,a0,276 # 8020ae58 <simple_user_task_bin+0x90>
    80205d4c:	ffffc097          	auipc	ra,0xffffc
    80205d50:	994080e7          	jalr	-1644(ra) # 802016e0 <panic>

void test_scheduler(void) {
    80205d54:	0001                	nop
    80205d56:	60e2                	ld	ra,24(sp)
    80205d58:	6442                	ld	s0,16(sp)
    80205d5a:	6105                	addi	sp,sp,32
    80205d5c:	8082                	ret

0000000080205d5e <get_time>:
uint64 get_time(void) {
    80205d5e:	1141                	addi	sp,sp,-16
    80205d60:	e406                	sd	ra,8(sp)
    80205d62:	e022                	sd	s0,0(sp)
    80205d64:	0800                	addi	s0,sp,16
    return sbi_get_time();
    80205d66:	ffffd097          	auipc	ra,0xffffd
    80205d6a:	760080e7          	jalr	1888(ra) # 802034c6 <sbi_get_time>
    80205d6e:	87aa                	mv	a5,a0
}
    80205d70:	853e                	mv	a0,a5
    80205d72:	60a2                	ld	ra,8(sp)
    80205d74:	6402                	ld	s0,0(sp)
    80205d76:	0141                	addi	sp,sp,16
    80205d78:	8082                	ret

0000000080205d7a <test_timer_interrupt>:
void test_timer_interrupt(void) {
    80205d7a:	7179                	addi	sp,sp,-48
    80205d7c:	f406                	sd	ra,40(sp)
    80205d7e:	f022                	sd	s0,32(sp)
    80205d80:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    80205d82:	00005517          	auipc	a0,0x5
    80205d86:	0de50513          	addi	a0,a0,222 # 8020ae60 <simple_user_task_bin+0x98>
    80205d8a:	ffffb097          	auipc	ra,0xffffb
    80205d8e:	f0a080e7          	jalr	-246(ra) # 80200c94 <printf>
    uint64 start_time = get_time();
    80205d92:	00000097          	auipc	ra,0x0
    80205d96:	fcc080e7          	jalr	-52(ra) # 80205d5e <get_time>
    80205d9a:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    80205d9e:	fc042a23          	sw	zero,-44(s0)
	int last_count = interrupt_count;
    80205da2:	fd442783          	lw	a5,-44(s0)
    80205da6:	fef42623          	sw	a5,-20(s0)
    interrupt_test_flag = &interrupt_count;
    80205daa:	00008797          	auipc	a5,0x8
    80205dae:	30e78793          	addi	a5,a5,782 # 8020e0b8 <interrupt_test_flag>
    80205db2:	fd440713          	addi	a4,s0,-44
    80205db6:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    80205db8:	a899                	j	80205e0e <test_timer_interrupt+0x94>
        if(last_count != interrupt_count) {
    80205dba:	fd442703          	lw	a4,-44(s0)
    80205dbe:	fec42783          	lw	a5,-20(s0)
    80205dc2:	2781                	sext.w	a5,a5
    80205dc4:	02e78163          	beq	a5,a4,80205de6 <test_timer_interrupt+0x6c>
			last_count = interrupt_count;
    80205dc8:	fd442783          	lw	a5,-44(s0)
    80205dcc:	fef42623          	sw	a5,-20(s0)
			printf("Received interrupt %d\n", interrupt_count);
    80205dd0:	fd442783          	lw	a5,-44(s0)
    80205dd4:	85be                	mv	a1,a5
    80205dd6:	00005517          	auipc	a0,0x5
    80205dda:	0aa50513          	addi	a0,a0,170 # 8020ae80 <simple_user_task_bin+0xb8>
    80205dde:	ffffb097          	auipc	ra,0xffffb
    80205de2:	eb6080e7          	jalr	-330(ra) # 80200c94 <printf>
        for (volatile int i = 0; i < 1000000; i++);
    80205de6:	fc042823          	sw	zero,-48(s0)
    80205dea:	a801                	j	80205dfa <test_timer_interrupt+0x80>
    80205dec:	fd042783          	lw	a5,-48(s0)
    80205df0:	2781                	sext.w	a5,a5
    80205df2:	2785                	addiw	a5,a5,1
    80205df4:	2781                	sext.w	a5,a5
    80205df6:	fcf42823          	sw	a5,-48(s0)
    80205dfa:	fd042783          	lw	a5,-48(s0)
    80205dfe:	2781                	sext.w	a5,a5
    80205e00:	873e                	mv	a4,a5
    80205e02:	000f47b7          	lui	a5,0xf4
    80205e06:	23f78793          	addi	a5,a5,575 # f423f <_entry-0x8010bdc1>
    80205e0a:	fee7d1e3          	bge	a5,a4,80205dec <test_timer_interrupt+0x72>
    while (interrupt_count < 5) {
    80205e0e:	fd442783          	lw	a5,-44(s0)
    80205e12:	873e                	mv	a4,a5
    80205e14:	4791                	li	a5,4
    80205e16:	fae7d2e3          	bge	a5,a4,80205dba <test_timer_interrupt+0x40>
    interrupt_test_flag = 0;
    80205e1a:	00008797          	auipc	a5,0x8
    80205e1e:	29e78793          	addi	a5,a5,670 # 8020e0b8 <interrupt_test_flag>
    80205e22:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    80205e26:	00000097          	auipc	ra,0x0
    80205e2a:	f38080e7          	jalr	-200(ra) # 80205d5e <get_time>
    80205e2e:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    80205e32:	fd442683          	lw	a3,-44(s0)
    80205e36:	fd843703          	ld	a4,-40(s0)
    80205e3a:	fe043783          	ld	a5,-32(s0)
    80205e3e:	40f707b3          	sub	a5,a4,a5
    80205e42:	863e                	mv	a2,a5
    80205e44:	85b6                	mv	a1,a3
    80205e46:	00005517          	auipc	a0,0x5
    80205e4a:	05250513          	addi	a0,a0,82 # 8020ae98 <simple_user_task_bin+0xd0>
    80205e4e:	ffffb097          	auipc	ra,0xffffb
    80205e52:	e46080e7          	jalr	-442(ra) # 80200c94 <printf>
}
    80205e56:	0001                	nop
    80205e58:	70a2                	ld	ra,40(sp)
    80205e5a:	7402                	ld	s0,32(sp)
    80205e5c:	6145                	addi	sp,sp,48
    80205e5e:	8082                	ret

0000000080205e60 <test_exception>:
void test_exception(void) {
    80205e60:	715d                	addi	sp,sp,-80
    80205e62:	e486                	sd	ra,72(sp)
    80205e64:	e0a2                	sd	s0,64(sp)
    80205e66:	0880                	addi	s0,sp,80
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    80205e68:	00005517          	auipc	a0,0x5
    80205e6c:	06850513          	addi	a0,a0,104 # 8020aed0 <simple_user_task_bin+0x108>
    80205e70:	ffffb097          	auipc	ra,0xffffb
    80205e74:	e24080e7          	jalr	-476(ra) # 80200c94 <printf>
    printf("1. 测试非法指令异常...\n");
    80205e78:	00005517          	auipc	a0,0x5
    80205e7c:	08850513          	addi	a0,a0,136 # 8020af00 <simple_user_task_bin+0x138>
    80205e80:	ffffb097          	auipc	ra,0xffffb
    80205e84:	e14080e7          	jalr	-492(ra) # 80200c94 <printf>
    80205e88:	ffffffff          	.word	0xffffffff
    printf("✓ 非法指令异常处理成功\n\n");
    80205e8c:	00005517          	auipc	a0,0x5
    80205e90:	09450513          	addi	a0,a0,148 # 8020af20 <simple_user_task_bin+0x158>
    80205e94:	ffffb097          	auipc	ra,0xffffb
    80205e98:	e00080e7          	jalr	-512(ra) # 80200c94 <printf>
    printf("2. 测试存储页故障异常...\n");
    80205e9c:	00005517          	auipc	a0,0x5
    80205ea0:	0ac50513          	addi	a0,a0,172 # 8020af48 <simple_user_task_bin+0x180>
    80205ea4:	ffffb097          	auipc	ra,0xffffb
    80205ea8:	df0080e7          	jalr	-528(ra) # 80200c94 <printf>
    volatile uint64 *invalid_ptr = 0;
    80205eac:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80205eb0:	47a5                	li	a5,9
    80205eb2:	07f2                	slli	a5,a5,0x1c
    80205eb4:	fef43023          	sd	a5,-32(s0)
    80205eb8:	a835                	j	80205ef4 <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    80205eba:	fe043503          	ld	a0,-32(s0)
    80205ebe:	ffffd097          	auipc	ra,0xffffd
    80205ec2:	120080e7          	jalr	288(ra) # 80202fde <check_is_mapped>
    80205ec6:	87aa                	mv	a5,a0
    80205ec8:	e385                	bnez	a5,80205ee8 <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    80205eca:	fe043783          	ld	a5,-32(s0)
    80205ece:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80205ed2:	fe043583          	ld	a1,-32(s0)
    80205ed6:	00005517          	auipc	a0,0x5
    80205eda:	09a50513          	addi	a0,a0,154 # 8020af70 <simple_user_task_bin+0x1a8>
    80205ede:	ffffb097          	auipc	ra,0xffffb
    80205ee2:	db6080e7          	jalr	-586(ra) # 80200c94 <printf>
            break;
    80205ee6:	a829                	j	80205f00 <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80205ee8:	fe043703          	ld	a4,-32(s0)
    80205eec:	6785                	lui	a5,0x1
    80205eee:	97ba                	add	a5,a5,a4
    80205ef0:	fef43023          	sd	a5,-32(s0)
    80205ef4:	fe043703          	ld	a4,-32(s0)
    80205ef8:	47cd                	li	a5,19
    80205efa:	07ee                	slli	a5,a5,0x1b
    80205efc:	faf76fe3          	bltu	a4,a5,80205eba <test_exception+0x5a>
    if (invalid_ptr != 0) {
    80205f00:	fe843783          	ld	a5,-24(s0)
    80205f04:	cb95                	beqz	a5,80205f38 <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80205f06:	fe843783          	ld	a5,-24(s0)
    80205f0a:	85be                	mv	a1,a5
    80205f0c:	00005517          	auipc	a0,0x5
    80205f10:	08450513          	addi	a0,a0,132 # 8020af90 <simple_user_task_bin+0x1c8>
    80205f14:	ffffb097          	auipc	ra,0xffffb
    80205f18:	d80080e7          	jalr	-640(ra) # 80200c94 <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    80205f1c:	fe843783          	ld	a5,-24(s0)
    80205f20:	02a00713          	li	a4,42
    80205f24:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    80205f26:	00005517          	auipc	a0,0x5
    80205f2a:	09a50513          	addi	a0,a0,154 # 8020afc0 <simple_user_task_bin+0x1f8>
    80205f2e:	ffffb097          	auipc	ra,0xffffb
    80205f32:	d66080e7          	jalr	-666(ra) # 80200c94 <printf>
    80205f36:	a809                	j	80205f48 <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80205f38:	00005517          	auipc	a0,0x5
    80205f3c:	0b050513          	addi	a0,a0,176 # 8020afe8 <simple_user_task_bin+0x220>
    80205f40:	ffffb097          	auipc	ra,0xffffb
    80205f44:	d54080e7          	jalr	-684(ra) # 80200c94 <printf>
    printf("3. 测试加载页故障异常...\n");
    80205f48:	00005517          	auipc	a0,0x5
    80205f4c:	0d850513          	addi	a0,a0,216 # 8020b020 <simple_user_task_bin+0x258>
    80205f50:	ffffb097          	auipc	ra,0xffffb
    80205f54:	d44080e7          	jalr	-700(ra) # 80200c94 <printf>
    invalid_ptr = 0;
    80205f58:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80205f5c:	4795                	li	a5,5
    80205f5e:	07f6                	slli	a5,a5,0x1d
    80205f60:	fcf43c23          	sd	a5,-40(s0)
    80205f64:	a835                	j	80205fa0 <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    80205f66:	fd843503          	ld	a0,-40(s0)
    80205f6a:	ffffd097          	auipc	ra,0xffffd
    80205f6e:	074080e7          	jalr	116(ra) # 80202fde <check_is_mapped>
    80205f72:	87aa                	mv	a5,a0
    80205f74:	e385                	bnez	a5,80205f94 <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    80205f76:	fd843783          	ld	a5,-40(s0)
    80205f7a:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80205f7e:	fd843583          	ld	a1,-40(s0)
    80205f82:	00005517          	auipc	a0,0x5
    80205f86:	fee50513          	addi	a0,a0,-18 # 8020af70 <simple_user_task_bin+0x1a8>
    80205f8a:	ffffb097          	auipc	ra,0xffffb
    80205f8e:	d0a080e7          	jalr	-758(ra) # 80200c94 <printf>
            break;
    80205f92:	a829                	j	80205fac <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80205f94:	fd843703          	ld	a4,-40(s0)
    80205f98:	6785                	lui	a5,0x1
    80205f9a:	97ba                	add	a5,a5,a4
    80205f9c:	fcf43c23          	sd	a5,-40(s0)
    80205fa0:	fd843703          	ld	a4,-40(s0)
    80205fa4:	47d5                	li	a5,21
    80205fa6:	07ee                	slli	a5,a5,0x1b
    80205fa8:	faf76fe3          	bltu	a4,a5,80205f66 <test_exception+0x106>
    if (invalid_ptr != 0) {
    80205fac:	fe843783          	ld	a5,-24(s0)
    80205fb0:	c7a9                	beqz	a5,80205ffa <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80205fb2:	fe843783          	ld	a5,-24(s0)
    80205fb6:	85be                	mv	a1,a5
    80205fb8:	00005517          	auipc	a0,0x5
    80205fbc:	09050513          	addi	a0,a0,144 # 8020b048 <simple_user_task_bin+0x280>
    80205fc0:	ffffb097          	auipc	ra,0xffffb
    80205fc4:	cd4080e7          	jalr	-812(ra) # 80200c94 <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    80205fc8:	fe843783          	ld	a5,-24(s0)
    80205fcc:	639c                	ld	a5,0(a5)
    80205fce:	faf43823          	sd	a5,-80(s0)
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    80205fd2:	fb043783          	ld	a5,-80(s0)
    80205fd6:	85be                	mv	a1,a5
    80205fd8:	00005517          	auipc	a0,0x5
    80205fdc:	0a050513          	addi	a0,a0,160 # 8020b078 <simple_user_task_bin+0x2b0>
    80205fe0:	ffffb097          	auipc	ra,0xffffb
    80205fe4:	cb4080e7          	jalr	-844(ra) # 80200c94 <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    80205fe8:	00005517          	auipc	a0,0x5
    80205fec:	0a850513          	addi	a0,a0,168 # 8020b090 <simple_user_task_bin+0x2c8>
    80205ff0:	ffffb097          	auipc	ra,0xffffb
    80205ff4:	ca4080e7          	jalr	-860(ra) # 80200c94 <printf>
    80205ff8:	a809                	j	8020600a <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80205ffa:	00005517          	auipc	a0,0x5
    80205ffe:	fee50513          	addi	a0,a0,-18 # 8020afe8 <simple_user_task_bin+0x220>
    80206002:	ffffb097          	auipc	ra,0xffffb
    80206006:	c92080e7          	jalr	-878(ra) # 80200c94 <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    8020600a:	00005517          	auipc	a0,0x5
    8020600e:	0ae50513          	addi	a0,a0,174 # 8020b0b8 <simple_user_task_bin+0x2f0>
    80206012:	ffffb097          	auipc	ra,0xffffb
    80206016:	c82080e7          	jalr	-894(ra) # 80200c94 <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    8020601a:	ffffd097          	auipc	ra,0xffffd
    8020601e:	20c080e7          	jalr	524(ra) # 80203226 <alloc_page>
    80206022:	87aa                	mv	a5,a0
    80206024:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    80206028:	fd043783          	ld	a5,-48(s0)
    8020602c:	c3a1                	beqz	a5,8020606c <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    8020602e:	fd043783          	ld	a5,-48(s0)
    80206032:	0785                	addi	a5,a5,1 # 1001 <_entry-0x801fefff>
    80206034:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80206038:	fc843583          	ld	a1,-56(s0)
    8020603c:	00005517          	auipc	a0,0x5
    80206040:	0ac50513          	addi	a0,a0,172 # 8020b0e8 <simple_user_task_bin+0x320>
    80206044:	ffffb097          	auipc	ra,0xffffb
    80206048:	c50080e7          	jalr	-944(ra) # 80200c94 <printf>
        asm volatile (
    8020604c:	deadc7b7          	lui	a5,0xdeadc
    80206050:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8cd7ef>
    80206054:	fc843703          	ld	a4,-56(s0)
    80206058:	e31c                	sd	a5,0(a4)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    8020605a:	00005517          	auipc	a0,0x5
    8020605e:	0ae50513          	addi	a0,a0,174 # 8020b108 <simple_user_task_bin+0x340>
    80206062:	ffffb097          	auipc	ra,0xffffb
    80206066:	c32080e7          	jalr	-974(ra) # 80200c94 <printf>
    8020606a:	a809                	j	8020607c <test_exception+0x21c>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    8020606c:	00005517          	auipc	a0,0x5
    80206070:	0cc50513          	addi	a0,a0,204 # 8020b138 <simple_user_task_bin+0x370>
    80206074:	ffffb097          	auipc	ra,0xffffb
    80206078:	c20080e7          	jalr	-992(ra) # 80200c94 <printf>
    printf("5. 测试加载地址未对齐异常...\n");
    8020607c:	00005517          	auipc	a0,0x5
    80206080:	0fc50513          	addi	a0,a0,252 # 8020b178 <simple_user_task_bin+0x3b0>
    80206084:	ffffb097          	auipc	ra,0xffffb
    80206088:	c10080e7          	jalr	-1008(ra) # 80200c94 <printf>
    if (aligned_addr != 0) {
    8020608c:	fd043783          	ld	a5,-48(s0)
    80206090:	cbb1                	beqz	a5,802060e4 <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    80206092:	fd043783          	ld	a5,-48(s0)
    80206096:	0785                	addi	a5,a5,1
    80206098:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    8020609c:	fc043583          	ld	a1,-64(s0)
    802060a0:	00005517          	auipc	a0,0x5
    802060a4:	04850513          	addi	a0,a0,72 # 8020b0e8 <simple_user_task_bin+0x320>
    802060a8:	ffffb097          	auipc	ra,0xffffb
    802060ac:	bec080e7          	jalr	-1044(ra) # 80200c94 <printf>
        uint64 value = 0;
    802060b0:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    802060b4:	fc043783          	ld	a5,-64(s0)
    802060b8:	639c                	ld	a5,0(a5)
    802060ba:	faf43c23          	sd	a5,-72(s0)
        printf("读取的值: 0x%lx\n", value);
    802060be:	fb843583          	ld	a1,-72(s0)
    802060c2:	00005517          	auipc	a0,0x5
    802060c6:	0e650513          	addi	a0,a0,230 # 8020b1a8 <simple_user_task_bin+0x3e0>
    802060ca:	ffffb097          	auipc	ra,0xffffb
    802060ce:	bca080e7          	jalr	-1078(ra) # 80200c94 <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    802060d2:	00005517          	auipc	a0,0x5
    802060d6:	0ee50513          	addi	a0,a0,238 # 8020b1c0 <simple_user_task_bin+0x3f8>
    802060da:	ffffb097          	auipc	ra,0xffffb
    802060de:	bba080e7          	jalr	-1094(ra) # 80200c94 <printf>
    802060e2:	a809                	j	802060f4 <test_exception+0x294>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    802060e4:	00005517          	auipc	a0,0x5
    802060e8:	05450513          	addi	a0,a0,84 # 8020b138 <simple_user_task_bin+0x370>
    802060ec:	ffffb097          	auipc	ra,0xffffb
    802060f0:	ba8080e7          	jalr	-1112(ra) # 80200c94 <printf>
	printf("6. 测试断点异常...\n");
    802060f4:	00005517          	auipc	a0,0x5
    802060f8:	0fc50513          	addi	a0,a0,252 # 8020b1f0 <simple_user_task_bin+0x428>
    802060fc:	ffffb097          	auipc	ra,0xffffb
    80206100:	b98080e7          	jalr	-1128(ra) # 80200c94 <printf>
	asm volatile (
    80206104:	0001                	nop
    80206106:	9002                	ebreak
    80206108:	0001                	nop
	printf("✓ 断点异常处理成功\n\n");
    8020610a:	00005517          	auipc	a0,0x5
    8020610e:	10650513          	addi	a0,a0,262 # 8020b210 <simple_user_task_bin+0x448>
    80206112:	ffffb097          	auipc	ra,0xffffb
    80206116:	b82080e7          	jalr	-1150(ra) # 80200c94 <printf>
    printf("7. 测试环境调用异常...\n");
    8020611a:	00005517          	auipc	a0,0x5
    8020611e:	11650513          	addi	a0,a0,278 # 8020b230 <simple_user_task_bin+0x468>
    80206122:	ffffb097          	auipc	ra,0xffffb
    80206126:	b72080e7          	jalr	-1166(ra) # 80200c94 <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    8020612a:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    8020612e:	00005517          	auipc	a0,0x5
    80206132:	12250513          	addi	a0,a0,290 # 8020b250 <simple_user_task_bin+0x488>
    80206136:	ffffb097          	auipc	ra,0xffffb
    8020613a:	b5e080e7          	jalr	-1186(ra) # 80200c94 <printf>
    printf("===== 异常处理测试完成 =====\n\n");
    8020613e:	00005517          	auipc	a0,0x5
    80206142:	13a50513          	addi	a0,a0,314 # 8020b278 <simple_user_task_bin+0x4b0>
    80206146:	ffffb097          	auipc	ra,0xffffb
    8020614a:	b4e080e7          	jalr	-1202(ra) # 80200c94 <printf>
}
    8020614e:	0001                	nop
    80206150:	60a6                	ld	ra,72(sp)
    80206152:	6406                	ld	s0,64(sp)
    80206154:	6161                	addi	sp,sp,80
    80206156:	8082                	ret

0000000080206158 <simple_task>:
void simple_task(void) {
    80206158:	1141                	addi	sp,sp,-16
    8020615a:	e406                	sd	ra,8(sp)
    8020615c:	e022                	sd	s0,0(sp)
    8020615e:	0800                	addi	s0,sp,16
    printf("Simple kernel task running in PID %d\n", myproc()->pid);
    80206160:	fffff097          	auipc	ra,0xfffff
    80206164:	820080e7          	jalr	-2016(ra) # 80204980 <myproc>
    80206168:	87aa                	mv	a5,a0
    8020616a:	43dc                	lw	a5,4(a5)
    8020616c:	85be                	mv	a1,a5
    8020616e:	00005517          	auipc	a0,0x5
    80206172:	13250513          	addi	a0,a0,306 # 8020b2a0 <simple_user_task_bin+0x4d8>
    80206176:	ffffb097          	auipc	ra,0xffffb
    8020617a:	b1e080e7          	jalr	-1250(ra) # 80200c94 <printf>
}
    8020617e:	0001                	nop
    80206180:	60a2                	ld	ra,8(sp)
    80206182:	6402                	ld	s0,0(sp)
    80206184:	0141                	addi	sp,sp,16
    80206186:	8082                	ret

0000000080206188 <test_process_creation>:
void test_process_creation(void) {
    80206188:	7119                	addi	sp,sp,-128
    8020618a:	fc86                	sd	ra,120(sp)
    8020618c:	f8a2                	sd	s0,112(sp)
    8020618e:	0100                	addi	s0,sp,128
    printf("===== 测试开始: 进程创建与管理测试 =====\n");
    80206190:	00005517          	auipc	a0,0x5
    80206194:	13850513          	addi	a0,a0,312 # 8020b2c8 <simple_user_task_bin+0x500>
    80206198:	ffffb097          	auipc	ra,0xffffb
    8020619c:	afc080e7          	jalr	-1284(ra) # 80200c94 <printf>
    printf("\n----- 第一阶段：测试内核进程创建与管理 -----\n");
    802061a0:	00005517          	auipc	a0,0x5
    802061a4:	16050513          	addi	a0,a0,352 # 8020b300 <simple_user_task_bin+0x538>
    802061a8:	ffffb097          	auipc	ra,0xffffb
    802061ac:	aec080e7          	jalr	-1300(ra) # 80200c94 <printf>
    int pid = create_kernel_proc(simple_task);
    802061b0:	00000517          	auipc	a0,0x0
    802061b4:	fa850513          	addi	a0,a0,-88 # 80206158 <simple_task>
    802061b8:	fffff097          	auipc	ra,0xfffff
    802061bc:	eea080e7          	jalr	-278(ra) # 802050a2 <create_kernel_proc>
    802061c0:	87aa                	mv	a5,a0
    802061c2:	faf42a23          	sw	a5,-76(s0)
    assert(pid > 0);
    802061c6:	fb442783          	lw	a5,-76(s0)
    802061ca:	2781                	sext.w	a5,a5
    802061cc:	00f027b3          	sgtz	a5,a5
    802061d0:	0ff7f793          	zext.b	a5,a5
    802061d4:	2781                	sext.w	a5,a5
    802061d6:	853e                	mv	a0,a5
    802061d8:	00000097          	auipc	ra,0x0
    802061dc:	b3a080e7          	jalr	-1222(ra) # 80205d12 <assert>
    printf("【测试结果】: 基本内核进程创建成功，PID: %d\n", pid);
    802061e0:	fb442783          	lw	a5,-76(s0)
    802061e4:	85be                	mv	a1,a5
    802061e6:	00005517          	auipc	a0,0x5
    802061ea:	15a50513          	addi	a0,a0,346 # 8020b340 <simple_user_task_bin+0x578>
    802061ee:	ffffb097          	auipc	ra,0xffffb
    802061f2:	aa6080e7          	jalr	-1370(ra) # 80200c94 <printf>
    printf("\n----- 用内核进程填满进程表 -----\n");
    802061f6:	00005517          	auipc	a0,0x5
    802061fa:	18a50513          	addi	a0,a0,394 # 8020b380 <simple_user_task_bin+0x5b8>
    802061fe:	ffffb097          	auipc	ra,0xffffb
    80206202:	a96080e7          	jalr	-1386(ra) # 80200c94 <printf>
    int kernel_count = 1; // 已经创建了一个
    80206206:	4785                	li	a5,1
    80206208:	fef42623          	sw	a5,-20(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    8020620c:	4785                	li	a5,1
    8020620e:	fef42423          	sw	a5,-24(s0)
    80206212:	a881                	j	80206262 <test_process_creation+0xda>
        int new_pid = create_kernel_proc(simple_task);
    80206214:	00000517          	auipc	a0,0x0
    80206218:	f4450513          	addi	a0,a0,-188 # 80206158 <simple_task>
    8020621c:	fffff097          	auipc	ra,0xfffff
    80206220:	e86080e7          	jalr	-378(ra) # 802050a2 <create_kernel_proc>
    80206224:	87aa                	mv	a5,a0
    80206226:	faf42823          	sw	a5,-80(s0)
        if (new_pid > 0) {
    8020622a:	fb042783          	lw	a5,-80(s0)
    8020622e:	2781                	sext.w	a5,a5
    80206230:	00f05863          	blez	a5,80206240 <test_process_creation+0xb8>
            kernel_count++; 
    80206234:	fec42783          	lw	a5,-20(s0)
    80206238:	2785                	addiw	a5,a5,1
    8020623a:	fef42623          	sw	a5,-20(s0)
    8020623e:	a829                	j	80206258 <test_process_creation+0xd0>
            warning("process table was full at %d kernel processes\n", kernel_count);
    80206240:	fec42783          	lw	a5,-20(s0)
    80206244:	85be                	mv	a1,a5
    80206246:	00005517          	auipc	a0,0x5
    8020624a:	16a50513          	addi	a0,a0,362 # 8020b3b0 <simple_user_task_bin+0x5e8>
    8020624e:	ffffb097          	auipc	ra,0xffffb
    80206252:	4c6080e7          	jalr	1222(ra) # 80201714 <warning>
            break;
    80206256:	a829                	j	80206270 <test_process_creation+0xe8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206258:	fe842783          	lw	a5,-24(s0)
    8020625c:	2785                	addiw	a5,a5,1
    8020625e:	fef42423          	sw	a5,-24(s0)
    80206262:	fe842783          	lw	a5,-24(s0)
    80206266:	0007871b          	sext.w	a4,a5
    8020626a:	47fd                	li	a5,31
    8020626c:	fae7d4e3          	bge	a5,a4,80206214 <test_process_creation+0x8c>
    printf("【测试结果】: 成功创建 %d 个内核进程 (最大限制: %d)\n", kernel_count, PROC);
    80206270:	fec42783          	lw	a5,-20(s0)
    80206274:	02000613          	li	a2,32
    80206278:	85be                	mv	a1,a5
    8020627a:	00005517          	auipc	a0,0x5
    8020627e:	16650513          	addi	a0,a0,358 # 8020b3e0 <simple_user_task_bin+0x618>
    80206282:	ffffb097          	auipc	ra,0xffffb
    80206286:	a12080e7          	jalr	-1518(ra) # 80200c94 <printf>
    print_proc_table();
    8020628a:	fffff097          	auipc	ra,0xfffff
    8020628e:	76e080e7          	jalr	1902(ra) # 802059f8 <print_proc_table>
    printf("\n----- 等待并清理所有内核进程 -----\n");
    80206292:	00005517          	auipc	a0,0x5
    80206296:	19650513          	addi	a0,a0,406 # 8020b428 <simple_user_task_bin+0x660>
    8020629a:	ffffb097          	auipc	ra,0xffffb
    8020629e:	9fa080e7          	jalr	-1542(ra) # 80200c94 <printf>
    int kernel_success_count = 0;
    802062a2:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < kernel_count; i++) {
    802062a6:	fe042023          	sw	zero,-32(s0)
    802062aa:	a0a5                	j	80206312 <test_process_creation+0x18a>
        int waited_pid = wait_proc(NULL);
    802062ac:	4501                	li	a0,0
    802062ae:	fffff097          	auipc	ra,0xfffff
    802062b2:	5bc080e7          	jalr	1468(ra) # 8020586a <wait_proc>
    802062b6:	87aa                	mv	a5,a0
    802062b8:	f8f42623          	sw	a5,-116(s0)
        if (waited_pid > 0) {
    802062bc:	f8c42783          	lw	a5,-116(s0)
    802062c0:	2781                	sext.w	a5,a5
    802062c2:	02f05863          	blez	a5,802062f2 <test_process_creation+0x16a>
            kernel_success_count++;
    802062c6:	fe442783          	lw	a5,-28(s0)
    802062ca:	2785                	addiw	a5,a5,1
    802062cc:	fef42223          	sw	a5,-28(s0)
            printf("回收内核进程 PID: %d (%d/%d)\n", waited_pid, kernel_success_count, kernel_count);
    802062d0:	fec42683          	lw	a3,-20(s0)
    802062d4:	fe442703          	lw	a4,-28(s0)
    802062d8:	f8c42783          	lw	a5,-116(s0)
    802062dc:	863a                	mv	a2,a4
    802062de:	85be                	mv	a1,a5
    802062e0:	00005517          	auipc	a0,0x5
    802062e4:	17850513          	addi	a0,a0,376 # 8020b458 <simple_user_task_bin+0x690>
    802062e8:	ffffb097          	auipc	ra,0xffffb
    802062ec:	9ac080e7          	jalr	-1620(ra) # 80200c94 <printf>
    802062f0:	a821                	j	80206308 <test_process_creation+0x180>
            printf("【错误】: 等待内核进程失败，错误码: %d\n", waited_pid);
    802062f2:	f8c42783          	lw	a5,-116(s0)
    802062f6:	85be                	mv	a1,a5
    802062f8:	00005517          	auipc	a0,0x5
    802062fc:	18850513          	addi	a0,a0,392 # 8020b480 <simple_user_task_bin+0x6b8>
    80206300:	ffffb097          	auipc	ra,0xffffb
    80206304:	994080e7          	jalr	-1644(ra) # 80200c94 <printf>
    for (int i = 0; i < kernel_count; i++) {
    80206308:	fe042783          	lw	a5,-32(s0)
    8020630c:	2785                	addiw	a5,a5,1
    8020630e:	fef42023          	sw	a5,-32(s0)
    80206312:	fe042783          	lw	a5,-32(s0)
    80206316:	873e                	mv	a4,a5
    80206318:	fec42783          	lw	a5,-20(s0)
    8020631c:	2701                	sext.w	a4,a4
    8020631e:	2781                	sext.w	a5,a5
    80206320:	f8f746e3          	blt	a4,a5,802062ac <test_process_creation+0x124>
    printf("【测试结果】: 回收 %d/%d 个内核进程\n", kernel_success_count, kernel_count);
    80206324:	fec42703          	lw	a4,-20(s0)
    80206328:	fe442783          	lw	a5,-28(s0)
    8020632c:	863a                	mv	a2,a4
    8020632e:	85be                	mv	a1,a5
    80206330:	00005517          	auipc	a0,0x5
    80206334:	18850513          	addi	a0,a0,392 # 8020b4b8 <simple_user_task_bin+0x6f0>
    80206338:	ffffb097          	auipc	ra,0xffffb
    8020633c:	95c080e7          	jalr	-1700(ra) # 80200c94 <printf>
    print_proc_table();
    80206340:	fffff097          	auipc	ra,0xfffff
    80206344:	6b8080e7          	jalr	1720(ra) # 802059f8 <print_proc_table>
    printf("\n----- 第二阶段：测试用户进程创建与管理 -----\n");
    80206348:	00005517          	auipc	a0,0x5
    8020634c:	1a850513          	addi	a0,a0,424 # 8020b4f0 <simple_user_task_bin+0x728>
    80206350:	ffffb097          	auipc	ra,0xffffb
    80206354:	944080e7          	jalr	-1724(ra) # 80200c94 <printf>
    int user_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206358:	05400793          	li	a5,84
    8020635c:	2781                	sext.w	a5,a5
    8020635e:	85be                	mv	a1,a5
    80206360:	00005517          	auipc	a0,0x5
    80206364:	a6850513          	addi	a0,a0,-1432 # 8020adc8 <simple_user_task_bin>
    80206368:	fffff097          	auipc	ra,0xfffff
    8020636c:	da8080e7          	jalr	-600(ra) # 80205110 <create_user_proc>
    80206370:	87aa                	mv	a5,a0
    80206372:	faf42623          	sw	a5,-84(s0)
    if (user_pid > 0) {
    80206376:	fac42783          	lw	a5,-84(s0)
    8020637a:	2781                	sext.w	a5,a5
    8020637c:	02f05c63          	blez	a5,802063b4 <test_process_creation+0x22c>
        printf("【测试结果】: 基本用户进程创建成功，PID: %d\n", user_pid);
    80206380:	fac42783          	lw	a5,-84(s0)
    80206384:	85be                	mv	a1,a5
    80206386:	00005517          	auipc	a0,0x5
    8020638a:	1aa50513          	addi	a0,a0,426 # 8020b530 <simple_user_task_bin+0x768>
    8020638e:	ffffb097          	auipc	ra,0xffffb
    80206392:	906080e7          	jalr	-1786(ra) # 80200c94 <printf>
    printf("\n----- 用用户进程填满进程表 -----\n");
    80206396:	00005517          	auipc	a0,0x5
    8020639a:	20a50513          	addi	a0,a0,522 # 8020b5a0 <simple_user_task_bin+0x7d8>
    8020639e:	ffffb097          	auipc	ra,0xffffb
    802063a2:	8f6080e7          	jalr	-1802(ra) # 80200c94 <printf>
    int user_count = 1; // 已经创建了一个
    802063a6:	4785                	li	a5,1
    802063a8:	fcf42e23          	sw	a5,-36(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    802063ac:	4785                	li	a5,1
    802063ae:	fcf42c23          	sw	a5,-40(s0)
    802063b2:	a841                	j	80206442 <test_process_creation+0x2ba>
        printf("【错误】: 基本用户进程创建失败\n");
    802063b4:	00005517          	auipc	a0,0x5
    802063b8:	1bc50513          	addi	a0,a0,444 # 8020b570 <simple_user_task_bin+0x7a8>
    802063bc:	ffffb097          	auipc	ra,0xffffb
    802063c0:	8d8080e7          	jalr	-1832(ra) # 80200c94 <printf>
        return;
    802063c4:	a615                	j	802066e8 <test_process_creation+0x560>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    802063c6:	05400793          	li	a5,84
    802063ca:	2781                	sext.w	a5,a5
    802063cc:	85be                	mv	a1,a5
    802063ce:	00005517          	auipc	a0,0x5
    802063d2:	9fa50513          	addi	a0,a0,-1542 # 8020adc8 <simple_user_task_bin>
    802063d6:	fffff097          	auipc	ra,0xfffff
    802063da:	d3a080e7          	jalr	-710(ra) # 80205110 <create_user_proc>
    802063de:	87aa                	mv	a5,a0
    802063e0:	faf42423          	sw	a5,-88(s0)
        if (new_pid > 0) {
    802063e4:	fa842783          	lw	a5,-88(s0)
    802063e8:	2781                	sext.w	a5,a5
    802063ea:	02f05b63          	blez	a5,80206420 <test_process_creation+0x298>
            user_count++;
    802063ee:	fdc42783          	lw	a5,-36(s0)
    802063f2:	2785                	addiw	a5,a5,1
    802063f4:	fcf42e23          	sw	a5,-36(s0)
            if (user_count % 5 == 0) { // 每5个进程打印一次进度
    802063f8:	fdc42783          	lw	a5,-36(s0)
    802063fc:	873e                	mv	a4,a5
    802063fe:	4795                	li	a5,5
    80206400:	02f767bb          	remw	a5,a4,a5
    80206404:	2781                	sext.w	a5,a5
    80206406:	eb8d                	bnez	a5,80206438 <test_process_creation+0x2b0>
                printf("已创建 %d 个用户进程...\n", user_count);
    80206408:	fdc42783          	lw	a5,-36(s0)
    8020640c:	85be                	mv	a1,a5
    8020640e:	00005517          	auipc	a0,0x5
    80206412:	1c250513          	addi	a0,a0,450 # 8020b5d0 <simple_user_task_bin+0x808>
    80206416:	ffffb097          	auipc	ra,0xffffb
    8020641a:	87e080e7          	jalr	-1922(ra) # 80200c94 <printf>
    8020641e:	a829                	j	80206438 <test_process_creation+0x2b0>
            warning("process table was full at %d user processes\n", user_count);
    80206420:	fdc42783          	lw	a5,-36(s0)
    80206424:	85be                	mv	a1,a5
    80206426:	00005517          	auipc	a0,0x5
    8020642a:	1d250513          	addi	a0,a0,466 # 8020b5f8 <simple_user_task_bin+0x830>
    8020642e:	ffffb097          	auipc	ra,0xffffb
    80206432:	2e6080e7          	jalr	742(ra) # 80201714 <warning>
            break;
    80206436:	a829                	j	80206450 <test_process_creation+0x2c8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206438:	fd842783          	lw	a5,-40(s0)
    8020643c:	2785                	addiw	a5,a5,1
    8020643e:	fcf42c23          	sw	a5,-40(s0)
    80206442:	fd842783          	lw	a5,-40(s0)
    80206446:	0007871b          	sext.w	a4,a5
    8020644a:	47fd                	li	a5,31
    8020644c:	f6e7dde3          	bge	a5,a4,802063c6 <test_process_creation+0x23e>
    printf("【测试结果】: 成功创建 %d 个用户进程 (最大限制: %d)\n", user_count, PROC);
    80206450:	fdc42783          	lw	a5,-36(s0)
    80206454:	02000613          	li	a2,32
    80206458:	85be                	mv	a1,a5
    8020645a:	00005517          	auipc	a0,0x5
    8020645e:	1ce50513          	addi	a0,a0,462 # 8020b628 <simple_user_task_bin+0x860>
    80206462:	ffffb097          	auipc	ra,0xffffb
    80206466:	832080e7          	jalr	-1998(ra) # 80200c94 <printf>
    print_proc_table();
    8020646a:	fffff097          	auipc	ra,0xfffff
    8020646e:	58e080e7          	jalr	1422(ra) # 802059f8 <print_proc_table>
    printf("\n----- 等待并清理所有用户进程 -----\n");
    80206472:	00005517          	auipc	a0,0x5
    80206476:	1fe50513          	addi	a0,a0,510 # 8020b670 <simple_user_task_bin+0x8a8>
    8020647a:	ffffb097          	auipc	ra,0xffffb
    8020647e:	81a080e7          	jalr	-2022(ra) # 80200c94 <printf>
    int user_success_count = 0;
    80206482:	fc042a23          	sw	zero,-44(s0)
    for (int i = 0; i < user_count; i++) {
    80206486:	fc042823          	sw	zero,-48(s0)
    8020648a:	a895                	j	802064fe <test_process_creation+0x376>
        int waited_pid = wait_proc(NULL);
    8020648c:	4501                	li	a0,0
    8020648e:	fffff097          	auipc	ra,0xfffff
    80206492:	3dc080e7          	jalr	988(ra) # 8020586a <wait_proc>
    80206496:	87aa                	mv	a5,a0
    80206498:	f8f42823          	sw	a5,-112(s0)
        if (waited_pid > 0) {
    8020649c:	f9042783          	lw	a5,-112(s0)
    802064a0:	2781                	sext.w	a5,a5
    802064a2:	02f05e63          	blez	a5,802064de <test_process_creation+0x356>
            user_success_count++;
    802064a6:	fd442783          	lw	a5,-44(s0)
    802064aa:	2785                	addiw	a5,a5,1
    802064ac:	fcf42a23          	sw	a5,-44(s0)
            if (user_success_count % 5 == 0) { // 每5个进程打印一次进度
    802064b0:	fd442783          	lw	a5,-44(s0)
    802064b4:	873e                	mv	a4,a5
    802064b6:	4795                	li	a5,5
    802064b8:	02f767bb          	remw	a5,a4,a5
    802064bc:	2781                	sext.w	a5,a5
    802064be:	eb9d                	bnez	a5,802064f4 <test_process_creation+0x36c>
                printf("已回收 %d/%d 个用户进程...\n", user_success_count, user_count);
    802064c0:	fdc42703          	lw	a4,-36(s0)
    802064c4:	fd442783          	lw	a5,-44(s0)
    802064c8:	863a                	mv	a2,a4
    802064ca:	85be                	mv	a1,a5
    802064cc:	00005517          	auipc	a0,0x5
    802064d0:	1d450513          	addi	a0,a0,468 # 8020b6a0 <simple_user_task_bin+0x8d8>
    802064d4:	ffffa097          	auipc	ra,0xffffa
    802064d8:	7c0080e7          	jalr	1984(ra) # 80200c94 <printf>
    802064dc:	a821                	j	802064f4 <test_process_creation+0x36c>
            printf("【错误】: 等待用户进程失败，错误码: %d\n", waited_pid);
    802064de:	f9042783          	lw	a5,-112(s0)
    802064e2:	85be                	mv	a1,a5
    802064e4:	00005517          	auipc	a0,0x5
    802064e8:	1e450513          	addi	a0,a0,484 # 8020b6c8 <simple_user_task_bin+0x900>
    802064ec:	ffffa097          	auipc	ra,0xffffa
    802064f0:	7a8080e7          	jalr	1960(ra) # 80200c94 <printf>
    for (int i = 0; i < user_count; i++) {
    802064f4:	fd042783          	lw	a5,-48(s0)
    802064f8:	2785                	addiw	a5,a5,1
    802064fa:	fcf42823          	sw	a5,-48(s0)
    802064fe:	fd042783          	lw	a5,-48(s0)
    80206502:	873e                	mv	a4,a5
    80206504:	fdc42783          	lw	a5,-36(s0)
    80206508:	2701                	sext.w	a4,a4
    8020650a:	2781                	sext.w	a5,a5
    8020650c:	f8f740e3          	blt	a4,a5,8020648c <test_process_creation+0x304>
    printf("【测试结果】: 回收 %d/%d 个用户进程\n", user_success_count, user_count);
    80206510:	fdc42703          	lw	a4,-36(s0)
    80206514:	fd442783          	lw	a5,-44(s0)
    80206518:	863a                	mv	a2,a4
    8020651a:	85be                	mv	a1,a5
    8020651c:	00005517          	auipc	a0,0x5
    80206520:	1e450513          	addi	a0,a0,484 # 8020b700 <simple_user_task_bin+0x938>
    80206524:	ffffa097          	auipc	ra,0xffffa
    80206528:	770080e7          	jalr	1904(ra) # 80200c94 <printf>
    print_proc_table();
    8020652c:	fffff097          	auipc	ra,0xfffff
    80206530:	4cc080e7          	jalr	1228(ra) # 802059f8 <print_proc_table>
    printf("\n----- 第三阶段：混合进程测试 -----\n");
    80206534:	00005517          	auipc	a0,0x5
    80206538:	20450513          	addi	a0,a0,516 # 8020b738 <simple_user_task_bin+0x970>
    8020653c:	ffffa097          	auipc	ra,0xffffa
    80206540:	758080e7          	jalr	1880(ra) # 80200c94 <printf>
    int mixed_kernel_count = 0;
    80206544:	fc042623          	sw	zero,-52(s0)
    int mixed_user_count = 0;
    80206548:	fc042423          	sw	zero,-56(s0)
    int target_count = PROC / 2;
    8020654c:	47c1                	li	a5,16
    8020654e:	faf42223          	sw	a5,-92(s0)
    printf("创建 %d 个内核进程和 %d 个用户进程...\n", target_count, target_count);
    80206552:	fa442703          	lw	a4,-92(s0)
    80206556:	fa442783          	lw	a5,-92(s0)
    8020655a:	863a                	mv	a2,a4
    8020655c:	85be                	mv	a1,a5
    8020655e:	00005517          	auipc	a0,0x5
    80206562:	20a50513          	addi	a0,a0,522 # 8020b768 <simple_user_task_bin+0x9a0>
    80206566:	ffffa097          	auipc	ra,0xffffa
    8020656a:	72e080e7          	jalr	1838(ra) # 80200c94 <printf>
    for (int i = 0; i < target_count; i++) {
    8020656e:	fc042223          	sw	zero,-60(s0)
    80206572:	a81d                	j	802065a8 <test_process_creation+0x420>
        int new_pid = create_kernel_proc(simple_task);
    80206574:	00000517          	auipc	a0,0x0
    80206578:	be450513          	addi	a0,a0,-1052 # 80206158 <simple_task>
    8020657c:	fffff097          	auipc	ra,0xfffff
    80206580:	b26080e7          	jalr	-1242(ra) # 802050a2 <create_kernel_proc>
    80206584:	87aa                	mv	a5,a0
    80206586:	faf42023          	sw	a5,-96(s0)
        if (new_pid > 0) {
    8020658a:	fa042783          	lw	a5,-96(s0)
    8020658e:	2781                	sext.w	a5,a5
    80206590:	02f05663          	blez	a5,802065bc <test_process_creation+0x434>
            mixed_kernel_count++;
    80206594:	fcc42783          	lw	a5,-52(s0)
    80206598:	2785                	addiw	a5,a5,1
    8020659a:	fcf42623          	sw	a5,-52(s0)
    for (int i = 0; i < target_count; i++) {
    8020659e:	fc442783          	lw	a5,-60(s0)
    802065a2:	2785                	addiw	a5,a5,1
    802065a4:	fcf42223          	sw	a5,-60(s0)
    802065a8:	fc442783          	lw	a5,-60(s0)
    802065ac:	873e                	mv	a4,a5
    802065ae:	fa442783          	lw	a5,-92(s0)
    802065b2:	2701                	sext.w	a4,a4
    802065b4:	2781                	sext.w	a5,a5
    802065b6:	faf74fe3          	blt	a4,a5,80206574 <test_process_creation+0x3ec>
    802065ba:	a011                	j	802065be <test_process_creation+0x436>
            break;
    802065bc:	0001                	nop
    for (int i = 0; i < target_count; i++) {
    802065be:	fc042023          	sw	zero,-64(s0)
    802065c2:	a83d                	j	80206600 <test_process_creation+0x478>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    802065c4:	05400793          	li	a5,84
    802065c8:	2781                	sext.w	a5,a5
    802065ca:	85be                	mv	a1,a5
    802065cc:	00004517          	auipc	a0,0x4
    802065d0:	7fc50513          	addi	a0,a0,2044 # 8020adc8 <simple_user_task_bin>
    802065d4:	fffff097          	auipc	ra,0xfffff
    802065d8:	b3c080e7          	jalr	-1220(ra) # 80205110 <create_user_proc>
    802065dc:	87aa                	mv	a5,a0
    802065de:	f8f42e23          	sw	a5,-100(s0)
        if (new_pid > 0) {
    802065e2:	f9c42783          	lw	a5,-100(s0)
    802065e6:	2781                	sext.w	a5,a5
    802065e8:	02f05663          	blez	a5,80206614 <test_process_creation+0x48c>
            mixed_user_count++;
    802065ec:	fc842783          	lw	a5,-56(s0)
    802065f0:	2785                	addiw	a5,a5,1
    802065f2:	fcf42423          	sw	a5,-56(s0)
    for (int i = 0; i < target_count; i++) {
    802065f6:	fc042783          	lw	a5,-64(s0)
    802065fa:	2785                	addiw	a5,a5,1
    802065fc:	fcf42023          	sw	a5,-64(s0)
    80206600:	fc042783          	lw	a5,-64(s0)
    80206604:	873e                	mv	a4,a5
    80206606:	fa442783          	lw	a5,-92(s0)
    8020660a:	2701                	sext.w	a4,a4
    8020660c:	2781                	sext.w	a5,a5
    8020660e:	faf74be3          	blt	a4,a5,802065c4 <test_process_creation+0x43c>
    80206612:	a011                	j	80206616 <test_process_creation+0x48e>
            break;
    80206614:	0001                	nop
    printf("【混合测试结果】: 创建了 %d 个内核进程 + %d 个用户进程 = %d 个进程\n", 
    80206616:	fcc42783          	lw	a5,-52(s0)
    8020661a:	873e                	mv	a4,a5
    8020661c:	fc842783          	lw	a5,-56(s0)
    80206620:	9fb9                	addw	a5,a5,a4
    80206622:	0007869b          	sext.w	a3,a5
    80206626:	fc842703          	lw	a4,-56(s0)
    8020662a:	fcc42783          	lw	a5,-52(s0)
    8020662e:	863a                	mv	a2,a4
    80206630:	85be                	mv	a1,a5
    80206632:	00005517          	auipc	a0,0x5
    80206636:	16e50513          	addi	a0,a0,366 # 8020b7a0 <simple_user_task_bin+0x9d8>
    8020663a:	ffffa097          	auipc	ra,0xffffa
    8020663e:	65a080e7          	jalr	1626(ra) # 80200c94 <printf>
    print_proc_table();
    80206642:	fffff097          	auipc	ra,0xfffff
    80206646:	3b6080e7          	jalr	950(ra) # 802059f8 <print_proc_table>
    printf("\n----- 清理混合进程 -----\n");
    8020664a:	00005517          	auipc	a0,0x5
    8020664e:	1b650513          	addi	a0,a0,438 # 8020b800 <simple_user_task_bin+0xa38>
    80206652:	ffffa097          	auipc	ra,0xffffa
    80206656:	642080e7          	jalr	1602(ra) # 80200c94 <printf>
    int mixed_success_count = 0;
    8020665a:	fa042e23          	sw	zero,-68(s0)
    int total_mixed = mixed_kernel_count + mixed_user_count;
    8020665e:	fcc42783          	lw	a5,-52(s0)
    80206662:	873e                	mv	a4,a5
    80206664:	fc842783          	lw	a5,-56(s0)
    80206668:	9fb9                	addw	a5,a5,a4
    8020666a:	f8f42c23          	sw	a5,-104(s0)
    for (int i = 0; i < total_mixed; i++) {
    8020666e:	fa042c23          	sw	zero,-72(s0)
    80206672:	a805                	j	802066a2 <test_process_creation+0x51a>
        int waited_pid = wait_proc(NULL);
    80206674:	4501                	li	a0,0
    80206676:	fffff097          	auipc	ra,0xfffff
    8020667a:	1f4080e7          	jalr	500(ra) # 8020586a <wait_proc>
    8020667e:	87aa                	mv	a5,a0
    80206680:	f8f42a23          	sw	a5,-108(s0)
        if (waited_pid > 0) {
    80206684:	f9442783          	lw	a5,-108(s0)
    80206688:	2781                	sext.w	a5,a5
    8020668a:	00f05763          	blez	a5,80206698 <test_process_creation+0x510>
            mixed_success_count++;
    8020668e:	fbc42783          	lw	a5,-68(s0)
    80206692:	2785                	addiw	a5,a5,1
    80206694:	faf42e23          	sw	a5,-68(s0)
    for (int i = 0; i < total_mixed; i++) {
    80206698:	fb842783          	lw	a5,-72(s0)
    8020669c:	2785                	addiw	a5,a5,1
    8020669e:	faf42c23          	sw	a5,-72(s0)
    802066a2:	fb842783          	lw	a5,-72(s0)
    802066a6:	873e                	mv	a4,a5
    802066a8:	f9842783          	lw	a5,-104(s0)
    802066ac:	2701                	sext.w	a4,a4
    802066ae:	2781                	sext.w	a5,a5
    802066b0:	fcf742e3          	blt	a4,a5,80206674 <test_process_creation+0x4ec>
    printf("【混合测试结果】: 回收 %d/%d 个混合进程\n", mixed_success_count, total_mixed);
    802066b4:	f9842703          	lw	a4,-104(s0)
    802066b8:	fbc42783          	lw	a5,-68(s0)
    802066bc:	863a                	mv	a2,a4
    802066be:	85be                	mv	a1,a5
    802066c0:	00005517          	auipc	a0,0x5
    802066c4:	16850513          	addi	a0,a0,360 # 8020b828 <simple_user_task_bin+0xa60>
    802066c8:	ffffa097          	auipc	ra,0xffffa
    802066cc:	5cc080e7          	jalr	1484(ra) # 80200c94 <printf>
    print_proc_table();
    802066d0:	fffff097          	auipc	ra,0xfffff
    802066d4:	328080e7          	jalr	808(ra) # 802059f8 <print_proc_table>
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    802066d8:	00005517          	auipc	a0,0x5
    802066dc:	18850513          	addi	a0,a0,392 # 8020b860 <simple_user_task_bin+0xa98>
    802066e0:	ffffa097          	auipc	ra,0xffffa
    802066e4:	5b4080e7          	jalr	1460(ra) # 80200c94 <printf>
}
    802066e8:	70e6                	ld	ra,120(sp)
    802066ea:	7446                	ld	s0,112(sp)
    802066ec:	6109                	addi	sp,sp,128
    802066ee:	8082                	ret

00000000802066f0 <test_user_fork>:
void test_user_fork(void) {
    802066f0:	711d                	addi	sp,sp,-96
    802066f2:	ec86                	sd	ra,88(sp)
    802066f4:	e8a2                	sd	s0,80(sp)
    802066f6:	1080                	addi	s0,sp,96
    printf("===== 测试开始: 用户进程Fork测试 =====\n");
    802066f8:	00005517          	auipc	a0,0x5
    802066fc:	1a050513          	addi	a0,a0,416 # 8020b898 <simple_user_task_bin+0xad0>
    80206700:	ffffa097          	auipc	ra,0xffffa
    80206704:	594080e7          	jalr	1428(ra) # 80200c94 <printf>
    printf("\n----- 测试前进程状态 -----\n");
    80206708:	00005517          	auipc	a0,0x5
    8020670c:	1c850513          	addi	a0,a0,456 # 8020b8d0 <simple_user_task_bin+0xb08>
    80206710:	ffffa097          	auipc	ra,0xffffa
    80206714:	584080e7          	jalr	1412(ra) # 80200c94 <printf>
    print_proc_table();
    80206718:	fffff097          	auipc	ra,0xfffff
    8020671c:	2e0080e7          	jalr	736(ra) # 802059f8 <print_proc_table>
    printf("\n----- 第一阶段：基本用户fork测试 -----\n");
    80206720:	00005517          	auipc	a0,0x5
    80206724:	1d850513          	addi	a0,a0,472 # 8020b8f8 <simple_user_task_bin+0xb30>
    80206728:	ffffa097          	auipc	ra,0xffffa
    8020672c:	56c080e7          	jalr	1388(ra) # 80200c94 <printf>
    int fork_test_pid = create_user_proc(fork_user_test_bin, fork_user_test_bin_len);
    80206730:	1ae00793          	li	a5,430
    80206734:	2781                	sext.w	a5,a5
    80206736:	85be                	mv	a1,a5
    80206738:	00004517          	auipc	a0,0x4
    8020673c:	49850513          	addi	a0,a0,1176 # 8020abd0 <fork_user_test_bin>
    80206740:	fffff097          	auipc	ra,0xfffff
    80206744:	9d0080e7          	jalr	-1584(ra) # 80205110 <create_user_proc>
    80206748:	87aa                	mv	a5,a0
    8020674a:	fcf42623          	sw	a5,-52(s0)
    if (fork_test_pid < 0) {
    8020674e:	fcc42783          	lw	a5,-52(s0)
    80206752:	2781                	sext.w	a5,a5
    80206754:	0007db63          	bgez	a5,8020676a <test_user_fork+0x7a>
        printf("【错误】: 创建fork测试进程失败\n");
    80206758:	00005517          	auipc	a0,0x5
    8020675c:	1d850513          	addi	a0,a0,472 # 8020b930 <simple_user_task_bin+0xb68>
    80206760:	ffffa097          	auipc	ra,0xffffa
    80206764:	534080e7          	jalr	1332(ra) # 80200c94 <printf>
    80206768:	a171                	j	80206bf4 <test_user_fork+0x504>
    printf("【测试结果】: 创建fork测试进程成功，PID: %d\n", fork_test_pid);
    8020676a:	fcc42783          	lw	a5,-52(s0)
    8020676e:	85be                	mv	a1,a5
    80206770:	00005517          	auipc	a0,0x5
    80206774:	1f050513          	addi	a0,a0,496 # 8020b960 <simple_user_task_bin+0xb98>
    80206778:	ffffa097          	auipc	ra,0xffffa
    8020677c:	51c080e7          	jalr	1308(ra) # 80200c94 <printf>
    int waited_pid = wait_proc(&status);
    80206780:	fac40793          	addi	a5,s0,-84
    80206784:	853e                	mv	a0,a5
    80206786:	fffff097          	auipc	ra,0xfffff
    8020678a:	0e4080e7          	jalr	228(ra) # 8020586a <wait_proc>
    8020678e:	87aa                	mv	a5,a0
    80206790:	fcf42423          	sw	a5,-56(s0)
    if (waited_pid == fork_test_pid) {
    80206794:	fc842783          	lw	a5,-56(s0)
    80206798:	873e                	mv	a4,a5
    8020679a:	fcc42783          	lw	a5,-52(s0)
    8020679e:	2701                	sext.w	a4,a4
    802067a0:	2781                	sext.w	a5,a5
    802067a2:	02f71163          	bne	a4,a5,802067c4 <test_user_fork+0xd4>
        printf("【测试结果】: fork测试进程(PID: %d)完成，状态码: %d\n", fork_test_pid, status);
    802067a6:	fac42703          	lw	a4,-84(s0)
    802067aa:	fcc42783          	lw	a5,-52(s0)
    802067ae:	863a                	mv	a2,a4
    802067b0:	85be                	mv	a1,a5
    802067b2:	00005517          	auipc	a0,0x5
    802067b6:	1ee50513          	addi	a0,a0,494 # 8020b9a0 <simple_user_task_bin+0xbd8>
    802067ba:	ffffa097          	auipc	ra,0xffffa
    802067be:	4da080e7          	jalr	1242(ra) # 80200c94 <printf>
    802067c2:	a839                	j	802067e0 <test_user_fork+0xf0>
        printf("【错误】: 等待fork测试进程时出错，等待到PID: %d，期望PID: %d\n", waited_pid, fork_test_pid);
    802067c4:	fcc42703          	lw	a4,-52(s0)
    802067c8:	fc842783          	lw	a5,-56(s0)
    802067cc:	863a                	mv	a2,a4
    802067ce:	85be                	mv	a1,a5
    802067d0:	00005517          	auipc	a0,0x5
    802067d4:	21850513          	addi	a0,a0,536 # 8020b9e8 <simple_user_task_bin+0xc20>
    802067d8:	ffffa097          	auipc	ra,0xffffa
    802067dc:	4bc080e7          	jalr	1212(ra) # 80200c94 <printf>
    printf("\n----- 第二阶段：多重fork测试 -----\n");
    802067e0:	00005517          	auipc	a0,0x5
    802067e4:	26050513          	addi	a0,a0,608 # 8020ba40 <simple_user_task_bin+0xc78>
    802067e8:	ffffa097          	auipc	ra,0xffffa
    802067ec:	4ac080e7          	jalr	1196(ra) # 80200c94 <printf>
    printf("创建多个fork测试进程以观察并发行为...\n");
    802067f0:	00005517          	auipc	a0,0x5
    802067f4:	28050513          	addi	a0,a0,640 # 8020ba70 <simple_user_task_bin+0xca8>
    802067f8:	ffffa097          	auipc	ra,0xffffa
    802067fc:	49c080e7          	jalr	1180(ra) # 80200c94 <printf>
    int fork_test_count = 3;
    80206800:	478d                	li	a5,3
    80206802:	fcf42223          	sw	a5,-60(s0)
    int created_count = 0;
    80206806:	fe042623          	sw	zero,-20(s0)
    for (int i = 0; i < fork_test_count; i++) {
    8020680a:	fe042423          	sw	zero,-24(s0)
    8020680e:	a8b5                	j	8020688a <test_user_fork+0x19a>
        int pid = create_user_proc(fork_user_test_bin, fork_user_test_bin_len);
    80206810:	1ae00793          	li	a5,430
    80206814:	2781                	sext.w	a5,a5
    80206816:	85be                	mv	a1,a5
    80206818:	00004517          	auipc	a0,0x4
    8020681c:	3b850513          	addi	a0,a0,952 # 8020abd0 <fork_user_test_bin>
    80206820:	fffff097          	auipc	ra,0xfffff
    80206824:	8f0080e7          	jalr	-1808(ra) # 80205110 <create_user_proc>
    80206828:	87aa                	mv	a5,a0
    8020682a:	fcf42023          	sw	a5,-64(s0)
        if (pid > 0) {
    8020682e:	fc042783          	lw	a5,-64(s0)
    80206832:	2781                	sext.w	a5,a5
    80206834:	02f05863          	blez	a5,80206864 <test_user_fork+0x174>
            created_count++;
    80206838:	fec42783          	lw	a5,-20(s0)
    8020683c:	2785                	addiw	a5,a5,1
    8020683e:	fef42623          	sw	a5,-20(s0)
            printf("创建fork测试进程 %d，PID: %d\n", i + 1, pid);
    80206842:	fe842783          	lw	a5,-24(s0)
    80206846:	2785                	addiw	a5,a5,1
    80206848:	2781                	sext.w	a5,a5
    8020684a:	fc042703          	lw	a4,-64(s0)
    8020684e:	863a                	mv	a2,a4
    80206850:	85be                	mv	a1,a5
    80206852:	00005517          	auipc	a0,0x5
    80206856:	25650513          	addi	a0,a0,598 # 8020baa8 <simple_user_task_bin+0xce0>
    8020685a:	ffffa097          	auipc	ra,0xffffa
    8020685e:	43a080e7          	jalr	1082(ra) # 80200c94 <printf>
    80206862:	a839                	j	80206880 <test_user_fork+0x190>
            printf("【错误】: 创建第 %d 个fork测试进程失败\n", i + 1);
    80206864:	fe842783          	lw	a5,-24(s0)
    80206868:	2785                	addiw	a5,a5,1
    8020686a:	2781                	sext.w	a5,a5
    8020686c:	85be                	mv	a1,a5
    8020686e:	00005517          	auipc	a0,0x5
    80206872:	26250513          	addi	a0,a0,610 # 8020bad0 <simple_user_task_bin+0xd08>
    80206876:	ffffa097          	auipc	ra,0xffffa
    8020687a:	41e080e7          	jalr	1054(ra) # 80200c94 <printf>
            break;
    8020687e:	a839                	j	8020689c <test_user_fork+0x1ac>
    for (int i = 0; i < fork_test_count; i++) {
    80206880:	fe842783          	lw	a5,-24(s0)
    80206884:	2785                	addiw	a5,a5,1
    80206886:	fef42423          	sw	a5,-24(s0)
    8020688a:	fe842783          	lw	a5,-24(s0)
    8020688e:	873e                	mv	a4,a5
    80206890:	fc442783          	lw	a5,-60(s0)
    80206894:	2701                	sext.w	a4,a4
    80206896:	2781                	sext.w	a5,a5
    80206898:	f6f74ce3          	blt	a4,a5,80206810 <test_user_fork+0x120>
    printf("【测试结果】: 成功创建 %d/%d 个fork测试进程\n", created_count, fork_test_count);
    8020689c:	fc442703          	lw	a4,-60(s0)
    802068a0:	fec42783          	lw	a5,-20(s0)
    802068a4:	863a                	mv	a2,a4
    802068a6:	85be                	mv	a1,a5
    802068a8:	00005517          	auipc	a0,0x5
    802068ac:	26050513          	addi	a0,a0,608 # 8020bb08 <simple_user_task_bin+0xd40>
    802068b0:	ffffa097          	auipc	ra,0xffffa
    802068b4:	3e4080e7          	jalr	996(ra) # 80200c94 <printf>
    printf("\n----- Fork执行过程中的进程状态 -----\n");
    802068b8:	00005517          	auipc	a0,0x5
    802068bc:	29050513          	addi	a0,a0,656 # 8020bb48 <simple_user_task_bin+0xd80>
    802068c0:	ffffa097          	auipc	ra,0xffffa
    802068c4:	3d4080e7          	jalr	980(ra) # 80200c94 <printf>
    print_proc_table();
    802068c8:	fffff097          	auipc	ra,0xfffff
    802068cc:	130080e7          	jalr	304(ra) # 802059f8 <print_proc_table>
    printf("\n----- 等待所有fork测试进程完成 -----\n");
    802068d0:	00005517          	auipc	a0,0x5
    802068d4:	2b050513          	addi	a0,a0,688 # 8020bb80 <simple_user_task_bin+0xdb8>
    802068d8:	ffffa097          	auipc	ra,0xffffa
    802068dc:	3bc080e7          	jalr	956(ra) # 80200c94 <printf>
    int completed_count = 0;
    802068e0:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < created_count; i++) {
    802068e4:	fe042023          	sw	zero,-32(s0)
    802068e8:	a0bd                	j	80206956 <test_user_fork+0x266>
        int waited_pid = wait_proc(&status);
    802068ea:	fac40793          	addi	a5,s0,-84
    802068ee:	853e                	mv	a0,a5
    802068f0:	fffff097          	auipc	ra,0xfffff
    802068f4:	f7a080e7          	jalr	-134(ra) # 8020586a <wait_proc>
    802068f8:	87aa                	mv	a5,a0
    802068fa:	faf42823          	sw	a5,-80(s0)
        if (waited_pid > 0) {
    802068fe:	fb042783          	lw	a5,-80(s0)
    80206902:	2781                	sext.w	a5,a5
    80206904:	02f05963          	blez	a5,80206936 <test_user_fork+0x246>
            completed_count++;
    80206908:	fe442783          	lw	a5,-28(s0)
    8020690c:	2785                	addiw	a5,a5,1
    8020690e:	fef42223          	sw	a5,-28(s0)
            printf("回收进程 PID: %d，状态码: %d (%d/%d)\n", 
    80206912:	fac42603          	lw	a2,-84(s0)
    80206916:	fec42703          	lw	a4,-20(s0)
    8020691a:	fe442683          	lw	a3,-28(s0)
    8020691e:	fb042783          	lw	a5,-80(s0)
    80206922:	85be                	mv	a1,a5
    80206924:	00005517          	auipc	a0,0x5
    80206928:	29450513          	addi	a0,a0,660 # 8020bbb8 <simple_user_task_bin+0xdf0>
    8020692c:	ffffa097          	auipc	ra,0xffffa
    80206930:	368080e7          	jalr	872(ra) # 80200c94 <printf>
    80206934:	a821                	j	8020694c <test_user_fork+0x25c>
            printf("【错误】: 等待进程失败，错误码: %d\n", waited_pid);
    80206936:	fb042783          	lw	a5,-80(s0)
    8020693a:	85be                	mv	a1,a5
    8020693c:	00005517          	auipc	a0,0x5
    80206940:	2ac50513          	addi	a0,a0,684 # 8020bbe8 <simple_user_task_bin+0xe20>
    80206944:	ffffa097          	auipc	ra,0xffffa
    80206948:	350080e7          	jalr	848(ra) # 80200c94 <printf>
    for (int i = 0; i < created_count; i++) {
    8020694c:	fe042783          	lw	a5,-32(s0)
    80206950:	2785                	addiw	a5,a5,1
    80206952:	fef42023          	sw	a5,-32(s0)
    80206956:	fe042783          	lw	a5,-32(s0)
    8020695a:	873e                	mv	a4,a5
    8020695c:	fec42783          	lw	a5,-20(s0)
    80206960:	2701                	sext.w	a4,a4
    80206962:	2781                	sext.w	a5,a5
    80206964:	f8f743e3          	blt	a4,a5,802068ea <test_user_fork+0x1fa>
    printf("【测试结果】: 回收 %d/%d 个fork测试进程\n", completed_count, created_count);
    80206968:	fec42703          	lw	a4,-20(s0)
    8020696c:	fe442783          	lw	a5,-28(s0)
    80206970:	863a                	mv	a2,a4
    80206972:	85be                	mv	a1,a5
    80206974:	00005517          	auipc	a0,0x5
    80206978:	2ac50513          	addi	a0,a0,684 # 8020bc20 <simple_user_task_bin+0xe58>
    8020697c:	ffffa097          	auipc	ra,0xffffa
    80206980:	318080e7          	jalr	792(ra) # 80200c94 <printf>
    printf("\n----- 第三阶段：Fork压力测试 -----\n");
    80206984:	00005517          	auipc	a0,0x5
    80206988:	2d450513          	addi	a0,a0,724 # 8020bc58 <simple_user_task_bin+0xe90>
    8020698c:	ffffa097          	auipc	ra,0xffffa
    80206990:	308080e7          	jalr	776(ra) # 80200c94 <printf>
    printf("快速创建多个fork进程进行压力测试...\n");
    80206994:	00005517          	auipc	a0,0x5
    80206998:	2f450513          	addi	a0,a0,756 # 8020bc88 <simple_user_task_bin+0xec0>
    8020699c:	ffffa097          	auipc	ra,0xffffa
    802069a0:	2f8080e7          	jalr	760(ra) # 80200c94 <printf>
    int stress_count = 5;
    802069a4:	4795                	li	a5,5
    802069a6:	faf42e23          	sw	a5,-68(s0)
    int stress_created = 0;
    802069aa:	fc042e23          	sw	zero,-36(s0)
    for (int i = 0; i < stress_count; i++) {
    802069ae:	fc042c23          	sw	zero,-40(s0)
    802069b2:	a8b1                	j	80206a0e <test_user_fork+0x31e>
        int pid = create_user_proc(fork_user_test_bin, fork_user_test_bin_len);
    802069b4:	1ae00793          	li	a5,430
    802069b8:	2781                	sext.w	a5,a5
    802069ba:	85be                	mv	a1,a5
    802069bc:	00004517          	auipc	a0,0x4
    802069c0:	21450513          	addi	a0,a0,532 # 8020abd0 <fork_user_test_bin>
    802069c4:	ffffe097          	auipc	ra,0xffffe
    802069c8:	74c080e7          	jalr	1868(ra) # 80205110 <create_user_proc>
    802069cc:	87aa                	mv	a5,a0
    802069ce:	faf42c23          	sw	a5,-72(s0)
        if (pid > 0) {
    802069d2:	fb842783          	lw	a5,-72(s0)
    802069d6:	2781                	sext.w	a5,a5
    802069d8:	00f05863          	blez	a5,802069e8 <test_user_fork+0x2f8>
            stress_created++;
    802069dc:	fdc42783          	lw	a5,-36(s0)
    802069e0:	2785                	addiw	a5,a5,1
    802069e2:	fcf42e23          	sw	a5,-36(s0)
    802069e6:	a839                	j	80206a04 <test_user_fork+0x314>
            printf("【警告】: 压力测试中第 %d 个进程创建失败\n", i + 1);
    802069e8:	fd842783          	lw	a5,-40(s0)
    802069ec:	2785                	addiw	a5,a5,1
    802069ee:	2781                	sext.w	a5,a5
    802069f0:	85be                	mv	a1,a5
    802069f2:	00005517          	auipc	a0,0x5
    802069f6:	2ce50513          	addi	a0,a0,718 # 8020bcc0 <simple_user_task_bin+0xef8>
    802069fa:	ffffa097          	auipc	ra,0xffffa
    802069fe:	29a080e7          	jalr	666(ra) # 80200c94 <printf>
            break;
    80206a02:	a839                	j	80206a20 <test_user_fork+0x330>
    for (int i = 0; i < stress_count; i++) {
    80206a04:	fd842783          	lw	a5,-40(s0)
    80206a08:	2785                	addiw	a5,a5,1
    80206a0a:	fcf42c23          	sw	a5,-40(s0)
    80206a0e:	fd842783          	lw	a5,-40(s0)
    80206a12:	873e                	mv	a4,a5
    80206a14:	fbc42783          	lw	a5,-68(s0)
    80206a18:	2701                	sext.w	a4,a4
    80206a1a:	2781                	sext.w	a5,a5
    80206a1c:	f8f74ce3          	blt	a4,a5,802069b4 <test_user_fork+0x2c4>
    printf("【压力测试结果】: 创建 %d/%d 个fork进程\n", stress_created, stress_count);
    80206a20:	fbc42703          	lw	a4,-68(s0)
    80206a24:	fdc42783          	lw	a5,-36(s0)
    80206a28:	863a                	mv	a2,a4
    80206a2a:	85be                	mv	a1,a5
    80206a2c:	00005517          	auipc	a0,0x5
    80206a30:	2d450513          	addi	a0,a0,724 # 8020bd00 <simple_user_task_bin+0xf38>
    80206a34:	ffffa097          	auipc	ra,0xffffa
    80206a38:	260080e7          	jalr	608(ra) # 80200c94 <printf>
    printf("\n----- 压力测试过程中的进程状态 -----\n");
    80206a3c:	00005517          	auipc	a0,0x5
    80206a40:	2fc50513          	addi	a0,a0,764 # 8020bd38 <simple_user_task_bin+0xf70>
    80206a44:	ffffa097          	auipc	ra,0xffffa
    80206a48:	250080e7          	jalr	592(ra) # 80200c94 <printf>
    print_proc_table();
    80206a4c:	fffff097          	auipc	ra,0xfffff
    80206a50:	fac080e7          	jalr	-84(ra) # 802059f8 <print_proc_table>
    printf("\n----- 等待压力测试进程完成 -----\n");
    80206a54:	00005517          	auipc	a0,0x5
    80206a58:	31c50513          	addi	a0,a0,796 # 8020bd70 <simple_user_task_bin+0xfa8>
    80206a5c:	ffffa097          	auipc	ra,0xffffa
    80206a60:	238080e7          	jalr	568(ra) # 80200c94 <printf>
    int stress_completed = 0;
    80206a64:	fc042a23          	sw	zero,-44(s0)
    for (int i = 0; i < stress_created; i++) {
    80206a68:	fc042823          	sw	zero,-48(s0)
    80206a6c:	a0b5                	j	80206ad8 <test_user_fork+0x3e8>
        int waited_pid = wait_proc(&status);
    80206a6e:	fac40793          	addi	a5,s0,-84
    80206a72:	853e                	mv	a0,a5
    80206a74:	fffff097          	auipc	ra,0xfffff
    80206a78:	df6080e7          	jalr	-522(ra) # 8020586a <wait_proc>
    80206a7c:	87aa                	mv	a5,a0
    80206a7e:	faf42a23          	sw	a5,-76(s0)
        if (waited_pid > 0) {
    80206a82:	fb442783          	lw	a5,-76(s0)
    80206a86:	2781                	sext.w	a5,a5
    80206a88:	04f05363          	blez	a5,80206ace <test_user_fork+0x3de>
            stress_completed++;
    80206a8c:	fd442783          	lw	a5,-44(s0)
    80206a90:	2785                	addiw	a5,a5,1
    80206a92:	fcf42a23          	sw	a5,-44(s0)
            if (stress_completed % 2 == 0 || stress_completed == stress_created) {
    80206a96:	fd442783          	lw	a5,-44(s0)
    80206a9a:	8b85                	andi	a5,a5,1
    80206a9c:	2781                	sext.w	a5,a5
    80206a9e:	cb91                	beqz	a5,80206ab2 <test_user_fork+0x3c2>
    80206aa0:	fd442783          	lw	a5,-44(s0)
    80206aa4:	873e                	mv	a4,a5
    80206aa6:	fdc42783          	lw	a5,-36(s0)
    80206aaa:	2701                	sext.w	a4,a4
    80206aac:	2781                	sext.w	a5,a5
    80206aae:	02f71063          	bne	a4,a5,80206ace <test_user_fork+0x3de>
                printf("已回收 %d/%d 个压力测试进程\n", stress_completed, stress_created);
    80206ab2:	fdc42703          	lw	a4,-36(s0)
    80206ab6:	fd442783          	lw	a5,-44(s0)
    80206aba:	863a                	mv	a2,a4
    80206abc:	85be                	mv	a1,a5
    80206abe:	00005517          	auipc	a0,0x5
    80206ac2:	2e250513          	addi	a0,a0,738 # 8020bda0 <simple_user_task_bin+0xfd8>
    80206ac6:	ffffa097          	auipc	ra,0xffffa
    80206aca:	1ce080e7          	jalr	462(ra) # 80200c94 <printf>
    for (int i = 0; i < stress_created; i++) {
    80206ace:	fd042783          	lw	a5,-48(s0)
    80206ad2:	2785                	addiw	a5,a5,1
    80206ad4:	fcf42823          	sw	a5,-48(s0)
    80206ad8:	fd042783          	lw	a5,-48(s0)
    80206adc:	873e                	mv	a4,a5
    80206ade:	fdc42783          	lw	a5,-36(s0)
    80206ae2:	2701                	sext.w	a4,a4
    80206ae4:	2781                	sext.w	a5,a5
    80206ae6:	f8f744e3          	blt	a4,a5,80206a6e <test_user_fork+0x37e>
    printf("【压力测试结果】: 回收 %d/%d 个压力测试进程\n", stress_completed, stress_created);
    80206aea:	fdc42703          	lw	a4,-36(s0)
    80206aee:	fd442783          	lw	a5,-44(s0)
    80206af2:	863a                	mv	a2,a4
    80206af4:	85be                	mv	a1,a5
    80206af6:	00005517          	auipc	a0,0x5
    80206afa:	2d250513          	addi	a0,a0,722 # 8020bdc8 <simple_user_task_bin+0x1000>
    80206afe:	ffffa097          	auipc	ra,0xffffa
    80206b02:	196080e7          	jalr	406(ra) # 80200c94 <printf>
    printf("\n----- 测试结束后进程状态 -----\n");
    80206b06:	00005517          	auipc	a0,0x5
    80206b0a:	30250513          	addi	a0,a0,770 # 8020be08 <simple_user_task_bin+0x1040>
    80206b0e:	ffffa097          	auipc	ra,0xffffa
    80206b12:	186080e7          	jalr	390(ra) # 80200c94 <printf>
    print_proc_table();
    80206b16:	fffff097          	auipc	ra,0xfffff
    80206b1a:	ee2080e7          	jalr	-286(ra) # 802059f8 <print_proc_table>
    printf("\n----- Fork测试总结 -----\n");
    80206b1e:	00005517          	auipc	a0,0x5
    80206b22:	31a50513          	addi	a0,a0,794 # 8020be38 <simple_user_task_bin+0x1070>
    80206b26:	ffffa097          	auipc	ra,0xffffa
    80206b2a:	16e080e7          	jalr	366(ra) # 80200c94 <printf>
    printf("✓ 基本fork测试: %s\n", (waited_pid == fork_test_pid) ? "通过" : "失败");
    80206b2e:	fc842783          	lw	a5,-56(s0)
    80206b32:	873e                	mv	a4,a5
    80206b34:	fcc42783          	lw	a5,-52(s0)
    80206b38:	2701                	sext.w	a4,a4
    80206b3a:	2781                	sext.w	a5,a5
    80206b3c:	00f71763          	bne	a4,a5,80206b4a <test_user_fork+0x45a>
    80206b40:	00005797          	auipc	a5,0x5
    80206b44:	31878793          	addi	a5,a5,792 # 8020be58 <simple_user_task_bin+0x1090>
    80206b48:	a029                	j	80206b52 <test_user_fork+0x462>
    80206b4a:	00005797          	auipc	a5,0x5
    80206b4e:	31678793          	addi	a5,a5,790 # 8020be60 <simple_user_task_bin+0x1098>
    80206b52:	85be                	mv	a1,a5
    80206b54:	00005517          	auipc	a0,0x5
    80206b58:	31450513          	addi	a0,a0,788 # 8020be68 <simple_user_task_bin+0x10a0>
    80206b5c:	ffffa097          	auipc	ra,0xffffa
    80206b60:	138080e7          	jalr	312(ra) # 80200c94 <printf>
    printf("✓ 多重fork测试: %s (成功率: %d/%d)\n", 
    80206b64:	fe442783          	lw	a5,-28(s0)
    80206b68:	873e                	mv	a4,a5
    80206b6a:	fec42783          	lw	a5,-20(s0)
    80206b6e:	2701                	sext.w	a4,a4
    80206b70:	2781                	sext.w	a5,a5
    80206b72:	00f71763          	bne	a4,a5,80206b80 <test_user_fork+0x490>
    80206b76:	00005797          	auipc	a5,0x5
    80206b7a:	2e278793          	addi	a5,a5,738 # 8020be58 <simple_user_task_bin+0x1090>
    80206b7e:	a029                	j	80206b88 <test_user_fork+0x498>
    80206b80:	00005797          	auipc	a5,0x5
    80206b84:	30878793          	addi	a5,a5,776 # 8020be88 <simple_user_task_bin+0x10c0>
    80206b88:	fec42683          	lw	a3,-20(s0)
    80206b8c:	fe442703          	lw	a4,-28(s0)
    80206b90:	863a                	mv	a2,a4
    80206b92:	85be                	mv	a1,a5
    80206b94:	00005517          	auipc	a0,0x5
    80206b98:	30450513          	addi	a0,a0,772 # 8020be98 <simple_user_task_bin+0x10d0>
    80206b9c:	ffffa097          	auipc	ra,0xffffa
    80206ba0:	0f8080e7          	jalr	248(ra) # 80200c94 <printf>
    printf("✓ 压力测试: %s (成功率: %d/%d)\n", 
    80206ba4:	fd442783          	lw	a5,-44(s0)
    80206ba8:	873e                	mv	a4,a5
    80206baa:	fdc42783          	lw	a5,-36(s0)
    80206bae:	2701                	sext.w	a4,a4
    80206bb0:	2781                	sext.w	a5,a5
    80206bb2:	00f71763          	bne	a4,a5,80206bc0 <test_user_fork+0x4d0>
    80206bb6:	00005797          	auipc	a5,0x5
    80206bba:	2a278793          	addi	a5,a5,674 # 8020be58 <simple_user_task_bin+0x1090>
    80206bbe:	a029                	j	80206bc8 <test_user_fork+0x4d8>
    80206bc0:	00005797          	auipc	a5,0x5
    80206bc4:	2c878793          	addi	a5,a5,712 # 8020be88 <simple_user_task_bin+0x10c0>
    80206bc8:	fdc42683          	lw	a3,-36(s0)
    80206bcc:	fd442703          	lw	a4,-44(s0)
    80206bd0:	863a                	mv	a2,a4
    80206bd2:	85be                	mv	a1,a5
    80206bd4:	00005517          	auipc	a0,0x5
    80206bd8:	2f450513          	addi	a0,a0,756 # 8020bec8 <simple_user_task_bin+0x1100>
    80206bdc:	ffffa097          	auipc	ra,0xffffa
    80206be0:	0b8080e7          	jalr	184(ra) # 80200c94 <printf>
    printf("===== 测试结束: 用户进程Fork测试 =====\n");
    80206be4:	00005517          	auipc	a0,0x5
    80206be8:	31450513          	addi	a0,a0,788 # 8020bef8 <simple_user_task_bin+0x1130>
    80206bec:	ffffa097          	auipc	ra,0xffffa
    80206bf0:	0a8080e7          	jalr	168(ra) # 80200c94 <printf>
}
    80206bf4:	60e6                	ld	ra,88(sp)
    80206bf6:	6446                	ld	s0,80(sp)
    80206bf8:	6125                	addi	sp,sp,96
    80206bfa:	8082                	ret

0000000080206bfc <cpu_intensive_task>:
void cpu_intensive_task(void) {
    80206bfc:	1101                	addi	sp,sp,-32
    80206bfe:	ec06                	sd	ra,24(sp)
    80206c00:	e822                	sd	s0,16(sp)
    80206c02:	1000                	addi	s0,sp,32
    uint64 sum = 0;
    80206c04:	fe043423          	sd	zero,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    80206c08:	fe043023          	sd	zero,-32(s0)
    80206c0c:	a829                	j	80206c26 <cpu_intensive_task+0x2a>
        sum += i;
    80206c0e:	fe843703          	ld	a4,-24(s0)
    80206c12:	fe043783          	ld	a5,-32(s0)
    80206c16:	97ba                	add	a5,a5,a4
    80206c18:	fef43423          	sd	a5,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    80206c1c:	fe043783          	ld	a5,-32(s0)
    80206c20:	0785                	addi	a5,a5,1
    80206c22:	fef43023          	sd	a5,-32(s0)
    80206c26:	fe043703          	ld	a4,-32(s0)
    80206c2a:	009897b7          	lui	a5,0x989
    80206c2e:	67f78793          	addi	a5,a5,1663 # 98967f <_entry-0x7f876981>
    80206c32:	fce7fee3          	bgeu	a5,a4,80206c0e <cpu_intensive_task+0x12>
    printf("CPU intensive task done in PID %d, sum=%lu\n", myproc()->pid, sum);
    80206c36:	ffffe097          	auipc	ra,0xffffe
    80206c3a:	d4a080e7          	jalr	-694(ra) # 80204980 <myproc>
    80206c3e:	87aa                	mv	a5,a0
    80206c40:	43dc                	lw	a5,4(a5)
    80206c42:	fe843603          	ld	a2,-24(s0)
    80206c46:	85be                	mv	a1,a5
    80206c48:	00005517          	auipc	a0,0x5
    80206c4c:	2e850513          	addi	a0,a0,744 # 8020bf30 <simple_user_task_bin+0x1168>
    80206c50:	ffffa097          	auipc	ra,0xffffa
    80206c54:	044080e7          	jalr	68(ra) # 80200c94 <printf>
    exit_proc(0);
    80206c58:	4501                	li	a0,0
    80206c5a:	fffff097          	auipc	ra,0xfffff
    80206c5e:	b46080e7          	jalr	-1210(ra) # 802057a0 <exit_proc>
}
    80206c62:	0001                	nop
    80206c64:	60e2                	ld	ra,24(sp)
    80206c66:	6442                	ld	s0,16(sp)
    80206c68:	6105                	addi	sp,sp,32
    80206c6a:	8082                	ret

0000000080206c6c <test_scheduler>:
void test_scheduler(void) {
    80206c6c:	7179                	addi	sp,sp,-48
    80206c6e:	f406                	sd	ra,40(sp)
    80206c70:	f022                	sd	s0,32(sp)
    80206c72:	1800                	addi	s0,sp,48
    printf("===== 测试开始: 调度器测试 =====\n");
    80206c74:	00005517          	auipc	a0,0x5
    80206c78:	2ec50513          	addi	a0,a0,748 # 8020bf60 <simple_user_task_bin+0x1198>
    80206c7c:	ffffa097          	auipc	ra,0xffffa
    80206c80:	018080e7          	jalr	24(ra) # 80200c94 <printf>

    // 创建多个计算密集型进程
    for (int i = 0; i < 3; i++) {
    80206c84:	fe042623          	sw	zero,-20(s0)
    80206c88:	a831                	j	80206ca4 <test_scheduler+0x38>
        create_kernel_proc(cpu_intensive_task);
    80206c8a:	00000517          	auipc	a0,0x0
    80206c8e:	f7250513          	addi	a0,a0,-142 # 80206bfc <cpu_intensive_task>
    80206c92:	ffffe097          	auipc	ra,0xffffe
    80206c96:	410080e7          	jalr	1040(ra) # 802050a2 <create_kernel_proc>
    for (int i = 0; i < 3; i++) {
    80206c9a:	fec42783          	lw	a5,-20(s0)
    80206c9e:	2785                	addiw	a5,a5,1
    80206ca0:	fef42623          	sw	a5,-20(s0)
    80206ca4:	fec42783          	lw	a5,-20(s0)
    80206ca8:	0007871b          	sext.w	a4,a5
    80206cac:	4789                	li	a5,2
    80206cae:	fce7dee3          	bge	a5,a4,80206c8a <test_scheduler+0x1e>
    }

    // 观察调度行为
    uint64 start_time = get_time();
    80206cb2:	fffff097          	auipc	ra,0xfffff
    80206cb6:	0ac080e7          	jalr	172(ra) # 80205d5e <get_time>
    80206cba:	fea43023          	sd	a0,-32(s0)
	for (int i = 0; i < 3; i++) {
    80206cbe:	fe042423          	sw	zero,-24(s0)
    80206cc2:	a819                	j	80206cd8 <test_scheduler+0x6c>
    	wait_proc(NULL); // 等待所有子进程结束
    80206cc4:	4501                	li	a0,0
    80206cc6:	fffff097          	auipc	ra,0xfffff
    80206cca:	ba4080e7          	jalr	-1116(ra) # 8020586a <wait_proc>
	for (int i = 0; i < 3; i++) {
    80206cce:	fe842783          	lw	a5,-24(s0)
    80206cd2:	2785                	addiw	a5,a5,1
    80206cd4:	fef42423          	sw	a5,-24(s0)
    80206cd8:	fe842783          	lw	a5,-24(s0)
    80206cdc:	0007871b          	sext.w	a4,a5
    80206ce0:	4789                	li	a5,2
    80206ce2:	fee7d1e3          	bge	a5,a4,80206cc4 <test_scheduler+0x58>
	}
    uint64 end_time = get_time();
    80206ce6:	fffff097          	auipc	ra,0xfffff
    80206cea:	078080e7          	jalr	120(ra) # 80205d5e <get_time>
    80206cee:	fca43c23          	sd	a0,-40(s0)

    printf("Scheduler test completed in %lu cycles\n", end_time - start_time);
    80206cf2:	fd843703          	ld	a4,-40(s0)
    80206cf6:	fe043783          	ld	a5,-32(s0)
    80206cfa:	40f707b3          	sub	a5,a4,a5
    80206cfe:	85be                	mv	a1,a5
    80206d00:	00005517          	auipc	a0,0x5
    80206d04:	29050513          	addi	a0,a0,656 # 8020bf90 <simple_user_task_bin+0x11c8>
    80206d08:	ffffa097          	auipc	ra,0xffffa
    80206d0c:	f8c080e7          	jalr	-116(ra) # 80200c94 <printf>
    printf("===== 测试结束 =====\n");
    80206d10:	00005517          	auipc	a0,0x5
    80206d14:	2a850513          	addi	a0,a0,680 # 8020bfb8 <simple_user_task_bin+0x11f0>
    80206d18:	ffffa097          	auipc	ra,0xffffa
    80206d1c:	f7c080e7          	jalr	-132(ra) # 80200c94 <printf>
}
    80206d20:	0001                	nop
    80206d22:	70a2                	ld	ra,40(sp)
    80206d24:	7402                	ld	s0,32(sp)
    80206d26:	6145                	addi	sp,sp,48
    80206d28:	8082                	ret

0000000080206d2a <shared_buffer_init>:
static int proc_buffer = 0;
static int proc_produced = 0;

void shared_buffer_init() {
    80206d2a:	1141                	addi	sp,sp,-16
    80206d2c:	e422                	sd	s0,8(sp)
    80206d2e:	0800                	addi	s0,sp,16
    proc_buffer = 0;
    80206d30:	00008797          	auipc	a5,0x8
    80206d34:	9bc78793          	addi	a5,a5,-1604 # 8020e6ec <proc_buffer>
    80206d38:	0007a023          	sw	zero,0(a5)
    proc_produced = 0;
    80206d3c:	00008797          	auipc	a5,0x8
    80206d40:	9b478793          	addi	a5,a5,-1612 # 8020e6f0 <proc_produced>
    80206d44:	0007a023          	sw	zero,0(a5)
}
    80206d48:	0001                	nop
    80206d4a:	6422                	ld	s0,8(sp)
    80206d4c:	0141                	addi	sp,sp,16
    80206d4e:	8082                	ret

0000000080206d50 <producer_task>:

void producer_task(void) {
    80206d50:	1141                	addi	sp,sp,-16
    80206d52:	e406                	sd	ra,8(sp)
    80206d54:	e022                	sd	s0,0(sp)
    80206d56:	0800                	addi	s0,sp,16
    proc_buffer = 42;
    80206d58:	00008797          	auipc	a5,0x8
    80206d5c:	99478793          	addi	a5,a5,-1644 # 8020e6ec <proc_buffer>
    80206d60:	02a00713          	li	a4,42
    80206d64:	c398                	sw	a4,0(a5)
    proc_produced = 1;
    80206d66:	00008797          	auipc	a5,0x8
    80206d6a:	98a78793          	addi	a5,a5,-1654 # 8020e6f0 <proc_produced>
    80206d6e:	4705                	li	a4,1
    80206d70:	c398                	sw	a4,0(a5)
    wakeup(&proc_produced); // 唤醒消费者
    80206d72:	00008517          	auipc	a0,0x8
    80206d76:	97e50513          	addi	a0,a0,-1666 # 8020e6f0 <proc_produced>
    80206d7a:	fffff097          	auipc	ra,0xfffff
    80206d7e:	9ba080e7          	jalr	-1606(ra) # 80205734 <wakeup>
    printf("Producer: produced value %d\n", proc_buffer);
    80206d82:	00008797          	auipc	a5,0x8
    80206d86:	96a78793          	addi	a5,a5,-1686 # 8020e6ec <proc_buffer>
    80206d8a:	439c                	lw	a5,0(a5)
    80206d8c:	85be                	mv	a1,a5
    80206d8e:	00005517          	auipc	a0,0x5
    80206d92:	24a50513          	addi	a0,a0,586 # 8020bfd8 <simple_user_task_bin+0x1210>
    80206d96:	ffffa097          	auipc	ra,0xffffa
    80206d9a:	efe080e7          	jalr	-258(ra) # 80200c94 <printf>
    exit_proc(0);
    80206d9e:	4501                	li	a0,0
    80206da0:	fffff097          	auipc	ra,0xfffff
    80206da4:	a00080e7          	jalr	-1536(ra) # 802057a0 <exit_proc>
}
    80206da8:	0001                	nop
    80206daa:	60a2                	ld	ra,8(sp)
    80206dac:	6402                	ld	s0,0(sp)
    80206dae:	0141                	addi	sp,sp,16
    80206db0:	8082                	ret

0000000080206db2 <consumer_task>:

void consumer_task(void) {
    80206db2:	1141                	addi	sp,sp,-16
    80206db4:	e406                	sd	ra,8(sp)
    80206db6:	e022                	sd	s0,0(sp)
    80206db8:	0800                	addi	s0,sp,16
    while (!proc_produced) {
    80206dba:	a809                	j	80206dcc <consumer_task+0x1a>
        sleep(&proc_produced); // 等待生产者
    80206dbc:	00008517          	auipc	a0,0x8
    80206dc0:	93450513          	addi	a0,a0,-1740 # 8020e6f0 <proc_produced>
    80206dc4:	fffff097          	auipc	ra,0xfffff
    80206dc8:	906080e7          	jalr	-1786(ra) # 802056ca <sleep>
    while (!proc_produced) {
    80206dcc:	00008797          	auipc	a5,0x8
    80206dd0:	92478793          	addi	a5,a5,-1756 # 8020e6f0 <proc_produced>
    80206dd4:	439c                	lw	a5,0(a5)
    80206dd6:	d3fd                	beqz	a5,80206dbc <consumer_task+0xa>
    }
    printf("Consumer: consumed value %d\n", proc_buffer);
    80206dd8:	00008797          	auipc	a5,0x8
    80206ddc:	91478793          	addi	a5,a5,-1772 # 8020e6ec <proc_buffer>
    80206de0:	439c                	lw	a5,0(a5)
    80206de2:	85be                	mv	a1,a5
    80206de4:	00005517          	auipc	a0,0x5
    80206de8:	21450513          	addi	a0,a0,532 # 8020bff8 <simple_user_task_bin+0x1230>
    80206dec:	ffffa097          	auipc	ra,0xffffa
    80206df0:	ea8080e7          	jalr	-344(ra) # 80200c94 <printf>
    exit_proc(0);
    80206df4:	4501                	li	a0,0
    80206df6:	fffff097          	auipc	ra,0xfffff
    80206dfa:	9aa080e7          	jalr	-1622(ra) # 802057a0 <exit_proc>
}
    80206dfe:	0001                	nop
    80206e00:	60a2                	ld	ra,8(sp)
    80206e02:	6402                	ld	s0,0(sp)
    80206e04:	0141                	addi	sp,sp,16
    80206e06:	8082                	ret

0000000080206e08 <test_synchronization>:
void test_synchronization(void) {
    80206e08:	1141                	addi	sp,sp,-16
    80206e0a:	e406                	sd	ra,8(sp)
    80206e0c:	e022                	sd	s0,0(sp)
    80206e0e:	0800                	addi	s0,sp,16
    printf("===== 测试开始: 同步机制测试 =====\n");
    80206e10:	00005517          	auipc	a0,0x5
    80206e14:	20850513          	addi	a0,a0,520 # 8020c018 <simple_user_task_bin+0x1250>
    80206e18:	ffffa097          	auipc	ra,0xffffa
    80206e1c:	e7c080e7          	jalr	-388(ra) # 80200c94 <printf>

    // 初始化共享缓冲区
    shared_buffer_init();
    80206e20:	00000097          	auipc	ra,0x0
    80206e24:	f0a080e7          	jalr	-246(ra) # 80206d2a <shared_buffer_init>

    // 创建生产者和消费者进程
    create_kernel_proc(producer_task);
    80206e28:	00000517          	auipc	a0,0x0
    80206e2c:	f2850513          	addi	a0,a0,-216 # 80206d50 <producer_task>
    80206e30:	ffffe097          	auipc	ra,0xffffe
    80206e34:	272080e7          	jalr	626(ra) # 802050a2 <create_kernel_proc>
    create_kernel_proc(consumer_task);
    80206e38:	00000517          	auipc	a0,0x0
    80206e3c:	f7a50513          	addi	a0,a0,-134 # 80206db2 <consumer_task>
    80206e40:	ffffe097          	auipc	ra,0xffffe
    80206e44:	262080e7          	jalr	610(ra) # 802050a2 <create_kernel_proc>

    // 等待两个进程完成
    wait_proc(NULL);
    80206e48:	4501                	li	a0,0
    80206e4a:	fffff097          	auipc	ra,0xfffff
    80206e4e:	a20080e7          	jalr	-1504(ra) # 8020586a <wait_proc>
    wait_proc(NULL);
    80206e52:	4501                	li	a0,0
    80206e54:	fffff097          	auipc	ra,0xfffff
    80206e58:	a16080e7          	jalr	-1514(ra) # 8020586a <wait_proc>

    printf("===== 测试结束 =====\n");
    80206e5c:	00005517          	auipc	a0,0x5
    80206e60:	15c50513          	addi	a0,a0,348 # 8020bfb8 <simple_user_task_bin+0x11f0>
    80206e64:	ffffa097          	auipc	ra,0xffffa
    80206e68:	e30080e7          	jalr	-464(ra) # 80200c94 <printf>
}
    80206e6c:	0001                	nop
    80206e6e:	60a2                	ld	ra,8(sp)
    80206e70:	6402                	ld	s0,0(sp)
    80206e72:	0141                	addi	sp,sp,16
    80206e74:	8082                	ret

0000000080206e76 <sys_access_task>:

void sys_access_task(void) {
    80206e76:	1101                	addi	sp,sp,-32
    80206e78:	ec06                	sd	ra,24(sp)
    80206e7a:	e822                	sd	s0,16(sp)
    80206e7c:	1000                	addi	s0,sp,32
    volatile int *ptr = (int*)0x80200000; // 内核空间地址
    80206e7e:	40100793          	li	a5,1025
    80206e82:	07d6                	slli	a5,a5,0x15
    80206e84:	fef43423          	sd	a5,-24(s0)
    printf("SYS: try read kernel addr 0x80200000\n");
    80206e88:	00005517          	auipc	a0,0x5
    80206e8c:	1c050513          	addi	a0,a0,448 # 8020c048 <simple_user_task_bin+0x1280>
    80206e90:	ffffa097          	auipc	ra,0xffffa
    80206e94:	e04080e7          	jalr	-508(ra) # 80200c94 <printf>
    int val = *ptr;
    80206e98:	fe843783          	ld	a5,-24(s0)
    80206e9c:	439c                	lw	a5,0(a5)
    80206e9e:	fef42223          	sw	a5,-28(s0)
    printf("SYS: read success, value=%d\n", val);
    80206ea2:	fe442783          	lw	a5,-28(s0)
    80206ea6:	85be                	mv	a1,a5
    80206ea8:	00005517          	auipc	a0,0x5
    80206eac:	1c850513          	addi	a0,a0,456 # 8020c070 <simple_user_task_bin+0x12a8>
    80206eb0:	ffffa097          	auipc	ra,0xffffa
    80206eb4:	de4080e7          	jalr	-540(ra) # 80200c94 <printf>
    exit_proc(0);
    80206eb8:	4501                	li	a0,0
    80206eba:	fffff097          	auipc	ra,0xfffff
    80206ebe:	8e6080e7          	jalr	-1818(ra) # 802057a0 <exit_proc>
    80206ec2:	0001                	nop
    80206ec4:	60e2                	ld	ra,24(sp)
    80206ec6:	6442                	ld	s0,16(sp)
    80206ec8:	6105                	addi	sp,sp,32
    80206eca:	8082                	ret
	...
