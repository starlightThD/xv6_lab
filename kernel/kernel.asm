
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80200000:	0000e117          	auipc	sp,0xe
    80200004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80200008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8020000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8020000c:	0000f517          	auipc	a0,0xf
    80200010:	08450513          	addi	a0,a0,132 # 8020f090 <kernel_pagetable>
        la a1,_bss_end
    80200014:	0000f597          	auipc	a1,0xf
    80200018:	6ec58593          	addi	a1,a1,1772 # 8020f700 <_bss_end>

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
    80200032:	1101                	addi	sp,sp,-32 # 8020dfe0 <simple_user_task_bin+0x1248>
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
    802000a4:	47850513          	addi	a0,a0,1144 # 80207518 <hello_world_bin>
    802000a8:	00005097          	auipc	ra,0x5
    802000ac:	f16080e7          	jalr	-234(ra) # 80204fbe <create_user_proc>
	wait_proc(NULL);
    802000b0:	4501                	li	a0,0
    802000b2:	00005097          	auipc	ra,0x5
    802000b6:	634080e7          	jalr	1588(ra) # 802056e6 <wait_proc>
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
    802000f8:	57450513          	addi	a0,a0,1396 # 80207668 <simple_user_task_bin+0x108>
    802000fc:	00001097          	auipc	ra,0x1
    80200100:	b98080e7          	jalr	-1128(ra) # 80200c94 <printf>
    printf("        RISC-V Operating System v1.0         \n");
    80200104:	00007517          	auipc	a0,0x7
    80200108:	59c50513          	addi	a0,a0,1436 # 802076a0 <simple_user_task_bin+0x140>
    8020010c:	00001097          	auipc	ra,0x1
    80200110:	b88080e7          	jalr	-1144(ra) # 80200c94 <printf>
    printf("===============================================\n\n");
    80200114:	00007517          	auipc	a0,0x7
    80200118:	5bc50513          	addi	a0,a0,1468 # 802076d0 <simple_user_task_bin+0x170>
    8020011c:	00001097          	auipc	ra,0x1
    80200120:	b78080e7          	jalr	-1160(ra) # 80200c94 <printf>
	init_proc(); // 初始化进程管理子系统
    80200124:	00005097          	auipc	ra,0x5
    80200128:	9fa080e7          	jalr	-1542(ra) # 80204b1e <init_proc>
	int main_pid = create_kernel_proc(kernel_main);
    8020012c:	00000517          	auipc	a0,0x0
    80200130:	3d250513          	addi	a0,a0,978 # 802004fe <kernel_main>
    80200134:	00005097          	auipc	ra,0x5
    80200138:	e1c080e7          	jalr	-484(ra) # 80204f50 <create_kernel_proc>
    8020013c:	87aa                	mv	a5,a0
    8020013e:	fef42623          	sw	a5,-20(s0)
	if (main_pid < 0){
    80200142:	fec42783          	lw	a5,-20(s0)
    80200146:	2781                	sext.w	a5,a5
    80200148:	0007da63          	bgez	a5,8020015c <start+0x98>
		panic("START: create main process failed!\n");
    8020014c:	00007517          	auipc	a0,0x7
    80200150:	5bc50513          	addi	a0,a0,1468 # 80207708 <simple_user_task_bin+0x1a8>
    80200154:	00001097          	auipc	ra,0x1
    80200158:	58c080e7          	jalr	1420(ra) # 802016e0 <panic>
	schedule();
    8020015c:	00005097          	auipc	ra,0x5
    80200160:	222080e7          	jalr	546(ra) # 8020537e <schedule>
    panic("START: main() exit unexpectedly!!!\n");
    80200164:	00007517          	auipc	a0,0x7
    80200168:	5cc50513          	addi	a0,a0,1484 # 80207730 <simple_user_task_bin+0x1d0>
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
    8020018e:	5ce50513          	addi	a0,a0,1486 # 80207758 <simple_user_task_bin+0x1f8>
    80200192:	00001097          	auipc	ra,0x1
    80200196:	b02080e7          	jalr	-1278(ra) # 80200c94 <printf>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    8020019a:	fe042423          	sw	zero,-24(s0)
    8020019e:	a0b9                	j	802001ec <console+0x6e>
        printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
    802001a0:	0000f697          	auipc	a3,0xf
    802001a4:	e6068693          	addi	a3,a3,-416 # 8020f000 <command_table>
    802001a8:	fe842703          	lw	a4,-24(s0)
    802001ac:	87ba                	mv	a5,a4
    802001ae:	0786                	slli	a5,a5,0x1
    802001b0:	97ba                	add	a5,a5,a4
    802001b2:	078e                	slli	a5,a5,0x3
    802001b4:	97b6                	add	a5,a5,a3
    802001b6:	638c                	ld	a1,0(a5)
    802001b8:	0000f697          	auipc	a3,0xf
    802001bc:	e4868693          	addi	a3,a3,-440 # 8020f000 <command_table>
    802001c0:	fe842703          	lw	a4,-24(s0)
    802001c4:	87ba                	mv	a5,a4
    802001c6:	0786                	slli	a5,a5,0x1
    802001c8:	97ba                	add	a5,a5,a4
    802001ca:	078e                	slli	a5,a5,0x3
    802001cc:	97b6                	add	a5,a5,a3
    802001ce:	6b9c                	ld	a5,16(a5)
    802001d0:	863e                	mv	a2,a5
    802001d2:	00007517          	auipc	a0,0x7
    802001d6:	59650513          	addi	a0,a0,1430 # 80207768 <simple_user_task_bin+0x208>
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
    802001fc:	58050513          	addi	a0,a0,1408 # 80207778 <simple_user_task_bin+0x218>
    80200200:	00001097          	auipc	ra,0x1
    80200204:	a94080e7          	jalr	-1388(ra) # 80200c94 <printf>
    printf("  exit          - 退出控制台\n");
    80200208:	00007517          	auipc	a0,0x7
    8020020c:	59850513          	addi	a0,a0,1432 # 802077a0 <simple_user_task_bin+0x240>
    80200210:	00001097          	auipc	ra,0x1
    80200214:	a84080e7          	jalr	-1404(ra) # 80200c94 <printf>
    printf("  ps            - 显示进程状态\n");
    80200218:	00007517          	auipc	a0,0x7
    8020021c:	5b050513          	addi	a0,a0,1456 # 802077c8 <simple_user_task_bin+0x268>
    80200220:	00001097          	auipc	ra,0x1
    80200224:	a74080e7          	jalr	-1420(ra) # 80200c94 <printf>
    while (!exit_requested) {
    80200228:	ac4d                	j	802004da <console+0x35c>
        printf("Console >>> ");
    8020022a:	00007517          	auipc	a0,0x7
    8020022e:	5c650513          	addi	a0,a0,1478 # 802077f0 <simple_user_task_bin+0x290>
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
    80200254:	5b058593          	addi	a1,a1,1456 # 80207800 <simple_user_task_bin+0x2a0>
    80200258:	853e                	mv	a0,a5
    8020025a:	00006097          	auipc	ra,0x6
    8020025e:	808080e7          	jalr	-2040(ra) # 80205a62 <strcmp>
    80200262:	87aa                	mv	a5,a0
    80200264:	e789                	bnez	a5,8020026e <console+0xf0>
            exit_requested = 1;
    80200266:	4785                	li	a5,1
    80200268:	fef42623          	sw	a5,-20(s0)
    8020026c:	a4bd                	j	802004da <console+0x35c>
        } else if (strcmp(input_buffer, "help") == 0) {
    8020026e:	ed040793          	addi	a5,s0,-304
    80200272:	00007597          	auipc	a1,0x7
    80200276:	59658593          	addi	a1,a1,1430 # 80207808 <simple_user_task_bin+0x2a8>
    8020027a:	853e                	mv	a0,a5
    8020027c:	00005097          	auipc	ra,0x5
    80200280:	7e6080e7          	jalr	2022(ra) # 80205a62 <strcmp>
    80200284:	87aa                	mv	a5,a0
    80200286:	e3cd                	bnez	a5,80200328 <console+0x1aa>
            printf("可用命令:\n");
    80200288:	00007517          	auipc	a0,0x7
    8020028c:	4d050513          	addi	a0,a0,1232 # 80207758 <simple_user_task_bin+0x1f8>
    80200290:	00001097          	auipc	ra,0x1
    80200294:	a04080e7          	jalr	-1532(ra) # 80200c94 <printf>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    80200298:	fe042223          	sw	zero,-28(s0)
    8020029c:	a0b9                	j	802002ea <console+0x16c>
                printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
    8020029e:	0000f697          	auipc	a3,0xf
    802002a2:	d6268693          	addi	a3,a3,-670 # 8020f000 <command_table>
    802002a6:	fe442703          	lw	a4,-28(s0)
    802002aa:	87ba                	mv	a5,a4
    802002ac:	0786                	slli	a5,a5,0x1
    802002ae:	97ba                	add	a5,a5,a4
    802002b0:	078e                	slli	a5,a5,0x3
    802002b2:	97b6                	add	a5,a5,a3
    802002b4:	638c                	ld	a1,0(a5)
    802002b6:	0000f697          	auipc	a3,0xf
    802002ba:	d4a68693          	addi	a3,a3,-694 # 8020f000 <command_table>
    802002be:	fe442703          	lw	a4,-28(s0)
    802002c2:	87ba                	mv	a5,a4
    802002c4:	0786                	slli	a5,a5,0x1
    802002c6:	97ba                	add	a5,a5,a4
    802002c8:	078e                	slli	a5,a5,0x3
    802002ca:	97b6                	add	a5,a5,a3
    802002cc:	6b9c                	ld	a5,16(a5)
    802002ce:	863e                	mv	a2,a5
    802002d0:	00007517          	auipc	a0,0x7
    802002d4:	49850513          	addi	a0,a0,1176 # 80207768 <simple_user_task_bin+0x208>
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
    802002fa:	48250513          	addi	a0,a0,1154 # 80207778 <simple_user_task_bin+0x218>
    802002fe:	00001097          	auipc	ra,0x1
    80200302:	996080e7          	jalr	-1642(ra) # 80200c94 <printf>
            printf("  exit          - 退出控制台\n");
    80200306:	00007517          	auipc	a0,0x7
    8020030a:	49a50513          	addi	a0,a0,1178 # 802077a0 <simple_user_task_bin+0x240>
    8020030e:	00001097          	auipc	ra,0x1
    80200312:	986080e7          	jalr	-1658(ra) # 80200c94 <printf>
            printf("  ps            - 显示进程状态\n");
    80200316:	00007517          	auipc	a0,0x7
    8020031a:	4b250513          	addi	a0,a0,1202 # 802077c8 <simple_user_task_bin+0x268>
    8020031e:	00001097          	auipc	ra,0x1
    80200322:	976080e7          	jalr	-1674(ra) # 80200c94 <printf>
    80200326:	aa55                	j	802004da <console+0x35c>
        } else if (strcmp(input_buffer, "ps") == 0) {
    80200328:	ed040793          	addi	a5,s0,-304
    8020032c:	00007597          	auipc	a1,0x7
    80200330:	4e458593          	addi	a1,a1,1252 # 80207810 <simple_user_task_bin+0x2b0>
    80200334:	853e                	mv	a0,a5
    80200336:	00005097          	auipc	ra,0x5
    8020033a:	72c080e7          	jalr	1836(ra) # 80205a62 <strcmp>
    8020033e:	87aa                	mv	a5,a0
    80200340:	e791                	bnez	a5,8020034c <console+0x1ce>
            print_proc_table();
    80200342:	00005097          	auipc	ra,0x5
    80200346:	532080e7          	jalr	1330(ra) # 80205874 <print_proc_table>
    8020034a:	aa41                	j	802004da <console+0x35c>
            int found = 0;
    8020034c:	fe042023          	sw	zero,-32(s0)
            for (int i = 0; i < COMMAND_COUNT; i++) {
    80200350:	fc042e23          	sw	zero,-36(s0)
    80200354:	aa99                	j	802004aa <console+0x32c>
                if (strcmp(input_buffer, command_table[i].name) == 0) {
    80200356:	0000f697          	auipc	a3,0xf
    8020035a:	caa68693          	addi	a3,a3,-854 # 8020f000 <command_table>
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
    80200376:	00005097          	auipc	ra,0x5
    8020037a:	6ec080e7          	jalr	1772(ra) # 80205a62 <strcmp>
    8020037e:	87aa                	mv	a5,a0
    80200380:	12079063          	bnez	a5,802004a0 <console+0x322>
                    int pid = create_kernel_proc(command_table[i].func);
    80200384:	0000f697          	auipc	a3,0xf
    80200388:	c7c68693          	addi	a3,a3,-900 # 8020f000 <command_table>
    8020038c:	fdc42703          	lw	a4,-36(s0)
    80200390:	87ba                	mv	a5,a4
    80200392:	0786                	slli	a5,a5,0x1
    80200394:	97ba                	add	a5,a5,a4
    80200396:	078e                	slli	a5,a5,0x3
    80200398:	97b6                	add	a5,a5,a3
    8020039a:	679c                	ld	a5,8(a5)
    8020039c:	853e                	mv	a0,a5
    8020039e:	00005097          	auipc	ra,0x5
    802003a2:	bb2080e7          	jalr	-1102(ra) # 80204f50 <create_kernel_proc>
    802003a6:	87aa                	mv	a5,a0
    802003a8:	fcf42c23          	sw	a5,-40(s0)
                    if (pid < 0) {
    802003ac:	fd842783          	lw	a5,-40(s0)
    802003b0:	2781                	sext.w	a5,a5
    802003b2:	0207d863          	bgez	a5,802003e2 <console+0x264>
                        printf("创建%s进程失败\n", command_table[i].name);
    802003b6:	0000f697          	auipc	a3,0xf
    802003ba:	c4a68693          	addi	a3,a3,-950 # 8020f000 <command_table>
    802003be:	fdc42703          	lw	a4,-36(s0)
    802003c2:	87ba                	mv	a5,a4
    802003c4:	0786                	slli	a5,a5,0x1
    802003c6:	97ba                	add	a5,a5,a4
    802003c8:	078e                	slli	a5,a5,0x3
    802003ca:	97b6                	add	a5,a5,a3
    802003cc:	639c                	ld	a5,0(a5)
    802003ce:	85be                	mv	a1,a5
    802003d0:	00007517          	auipc	a0,0x7
    802003d4:	44850513          	addi	a0,a0,1096 # 80207818 <simple_user_task_bin+0x2b8>
    802003d8:	00001097          	auipc	ra,0x1
    802003dc:	8bc080e7          	jalr	-1860(ra) # 80200c94 <printf>
    802003e0:	a865                	j	80200498 <console+0x31a>
                        printf("创建%s进程成功，PID: %d\n", command_table[i].name, pid);
    802003e2:	0000f697          	auipc	a3,0xf
    802003e6:	c1e68693          	addi	a3,a3,-994 # 8020f000 <command_table>
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
    80200406:	42e50513          	addi	a0,a0,1070 # 80207830 <simple_user_task_bin+0x2d0>
    8020040a:	00001097          	auipc	ra,0x1
    8020040e:	88a080e7          	jalr	-1910(ra) # 80200c94 <printf>
                        int waited_pid = wait_proc(&status);
    80200412:	ecc40793          	addi	a5,s0,-308
    80200416:	853e                	mv	a0,a5
    80200418:	00005097          	auipc	ra,0x5
    8020041c:	2ce080e7          	jalr	718(ra) # 802056e6 <wait_proc>
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
    80200438:	0000f697          	auipc	a3,0xf
    8020043c:	bc868693          	addi	a3,a3,-1080 # 8020f000 <command_table>
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
    80200460:	3f450513          	addi	a0,a0,1012 # 80207850 <simple_user_task_bin+0x2f0>
    80200464:	00001097          	auipc	ra,0x1
    80200468:	830080e7          	jalr	-2000(ra) # 80200c94 <printf>
    8020046c:	a035                	j	80200498 <console+0x31a>
                            printf("等待%s进程时发生错误\n", command_table[i].name);
    8020046e:	0000f697          	auipc	a3,0xf
    80200472:	b9268693          	addi	a3,a3,-1134 # 8020f000 <command_table>
    80200476:	fdc42703          	lw	a4,-36(s0)
    8020047a:	87ba                	mv	a5,a4
    8020047c:	0786                	slli	a5,a5,0x1
    8020047e:	97ba                	add	a5,a5,a4
    80200480:	078e                	slli	a5,a5,0x3
    80200482:	97b6                	add	a5,a5,a3
    80200484:	639c                	ld	a5,0(a5)
    80200486:	85be                	mv	a1,a5
    80200488:	00007517          	auipc	a0,0x7
    8020048c:	3f850513          	addi	a0,a0,1016 # 80207880 <simple_user_task_bin+0x320>
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
    802004ce:	3d650513          	addi	a0,a0,982 # 802078a0 <simple_user_task_bin+0x340>
    802004d2:	00000097          	auipc	ra,0x0
    802004d6:	7c2080e7          	jalr	1986(ra) # 80200c94 <printf>
    while (!exit_requested) {
    802004da:	fec42783          	lw	a5,-20(s0)
    802004de:	2781                	sext.w	a5,a5
    802004e0:	d40785e3          	beqz	a5,8020022a <console+0xac>
    printf("控制台进程退出\n");
    802004e4:	00007517          	auipc	a0,0x7
    802004e8:	3d450513          	addi	a0,a0,980 # 802078b8 <simple_user_task_bin+0x358>
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
    8020051a:	a3a080e7          	jalr	-1478(ra) # 80204f50 <create_kernel_proc>
    8020051e:	87aa                	mv	a5,a0
    80200520:	fef42623          	sw	a5,-20(s0)
	if (console_pid < 0){
    80200524:	fec42783          	lw	a5,-20(s0)
    80200528:	2781                	sext.w	a5,a5
    8020052a:	0007db63          	bgez	a5,80200540 <kernel_main+0x42>
		panic("KERNEL_MAIN: create console process failed!\n");
    8020052e:	00007517          	auipc	a0,0x7
    80200532:	3a250513          	addi	a0,a0,930 # 802078d0 <simple_user_task_bin+0x370>
    80200536:	00001097          	auipc	ra,0x1
    8020053a:	1aa080e7          	jalr	426(ra) # 802016e0 <panic>
    8020053e:	a821                	j	80200556 <kernel_main+0x58>
		printf("KERNEL_MAIN: console process created with PID %d\n", console_pid);
    80200540:	fec42783          	lw	a5,-20(s0)
    80200544:	85be                	mv	a1,a5
    80200546:	00007517          	auipc	a0,0x7
    8020054a:	3ba50513          	addi	a0,a0,954 # 80207900 <simple_user_task_bin+0x3a0>
    8020054e:	00000097          	auipc	ra,0x0
    80200552:	746080e7          	jalr	1862(ra) # 80200c94 <printf>
	int pid = wait_proc(&status);
    80200556:	fe440793          	addi	a5,s0,-28
    8020055a:	853e                	mv	a0,a5
    8020055c:	00005097          	auipc	ra,0x5
    80200560:	18a080e7          	jalr	394(ra) # 802056e6 <wait_proc>
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
    8020058c:	3b050513          	addi	a0,a0,944 # 80207938 <simple_user_task_bin+0x3d8>
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
    802005ea:	00008517          	auipc	a0,0x8
    802005ee:	87650513          	addi	a0,a0,-1930 # 80207e60 <simple_user_task_bin+0x58>
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
    80200738:	0000f797          	auipc	a5,0xf
    8020073c:	98878793          	addi	a5,a5,-1656 # 8020f0c0 <uart_input_buf>
    80200740:	0847a783          	lw	a5,132(a5)
    80200744:	2785                	addiw	a5,a5,1
    80200746:	2781                	sext.w	a5,a5
    80200748:	2781                	sext.w	a5,a5
    8020074a:	07f7f793          	andi	a5,a5,127
    8020074e:	fef42023          	sw	a5,-32(s0)
                if (next != uart_input_buf.r) {
    80200752:	0000f797          	auipc	a5,0xf
    80200756:	96e78793          	addi	a5,a5,-1682 # 8020f0c0 <uart_input_buf>
    8020075a:	0807a703          	lw	a4,128(a5)
    8020075e:	fe042783          	lw	a5,-32(s0)
    80200762:	04f70363          	beq	a4,a5,802007a8 <uart_intr+0xb2>
                    uart_input_buf.buf[uart_input_buf.w] = linebuf[i];
    80200766:	0000f797          	auipc	a5,0xf
    8020076a:	95a78793          	addi	a5,a5,-1702 # 8020f0c0 <uart_input_buf>
    8020076e:	0847a603          	lw	a2,132(a5)
    80200772:	0000f717          	auipc	a4,0xf
    80200776:	9de70713          	addi	a4,a4,-1570 # 8020f150 <linebuf.1>
    8020077a:	fec42783          	lw	a5,-20(s0)
    8020077e:	97ba                	add	a5,a5,a4
    80200780:	0007c703          	lbu	a4,0(a5)
    80200784:	0000f697          	auipc	a3,0xf
    80200788:	93c68693          	addi	a3,a3,-1732 # 8020f0c0 <uart_input_buf>
    8020078c:	02061793          	slli	a5,a2,0x20
    80200790:	9381                	srli	a5,a5,0x20
    80200792:	97b6                	add	a5,a5,a3
    80200794:	00e78023          	sb	a4,0(a5)
                    uart_input_buf.w = next;
    80200798:	fe042703          	lw	a4,-32(s0)
    8020079c:	0000f797          	auipc	a5,0xf
    802007a0:	92478793          	addi	a5,a5,-1756 # 8020f0c0 <uart_input_buf>
    802007a4:	08e7a223          	sw	a4,132(a5)
            for (int i = 0; i < line_len; i++) {
    802007a8:	fec42783          	lw	a5,-20(s0)
    802007ac:	2785                	addiw	a5,a5,1
    802007ae:	fef42623          	sw	a5,-20(s0)
    802007b2:	0000f797          	auipc	a5,0xf
    802007b6:	a1e78793          	addi	a5,a5,-1506 # 8020f1d0 <line_len.0>
    802007ba:	4398                	lw	a4,0(a5)
    802007bc:	fec42783          	lw	a5,-20(s0)
    802007c0:	2781                	sext.w	a5,a5
    802007c2:	f6e7cbe3          	blt	a5,a4,80200738 <uart_intr+0x42>
                }
            }
            // 写入换行符
            int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    802007c6:	0000f797          	auipc	a5,0xf
    802007ca:	8fa78793          	addi	a5,a5,-1798 # 8020f0c0 <uart_input_buf>
    802007ce:	0847a783          	lw	a5,132(a5)
    802007d2:	2785                	addiw	a5,a5,1
    802007d4:	2781                	sext.w	a5,a5
    802007d6:	2781                	sext.w	a5,a5
    802007d8:	07f7f793          	andi	a5,a5,127
    802007dc:	fef42223          	sw	a5,-28(s0)
            if (next != uart_input_buf.r) {
    802007e0:	0000f797          	auipc	a5,0xf
    802007e4:	8e078793          	addi	a5,a5,-1824 # 8020f0c0 <uart_input_buf>
    802007e8:	0807a703          	lw	a4,128(a5)
    802007ec:	fe442783          	lw	a5,-28(s0)
    802007f0:	02f70a63          	beq	a4,a5,80200824 <uart_intr+0x12e>
                uart_input_buf.buf[uart_input_buf.w] = '\n';
    802007f4:	0000f797          	auipc	a5,0xf
    802007f8:	8cc78793          	addi	a5,a5,-1844 # 8020f0c0 <uart_input_buf>
    802007fc:	0847a783          	lw	a5,132(a5)
    80200800:	0000f717          	auipc	a4,0xf
    80200804:	8c070713          	addi	a4,a4,-1856 # 8020f0c0 <uart_input_buf>
    80200808:	1782                	slli	a5,a5,0x20
    8020080a:	9381                	srli	a5,a5,0x20
    8020080c:	97ba                	add	a5,a5,a4
    8020080e:	4729                	li	a4,10
    80200810:	00e78023          	sb	a4,0(a5)
                uart_input_buf.w = next;
    80200814:	fe442703          	lw	a4,-28(s0)
    80200818:	0000f797          	auipc	a5,0xf
    8020081c:	8a878793          	addi	a5,a5,-1880 # 8020f0c0 <uart_input_buf>
    80200820:	08e7a223          	sw	a4,132(a5)
            }
            line_len = 0;
    80200824:	0000f797          	auipc	a5,0xf
    80200828:	9ac78793          	addi	a5,a5,-1620 # 8020f1d0 <line_len.0>
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
    80200850:	0000f797          	auipc	a5,0xf
    80200854:	98078793          	addi	a5,a5,-1664 # 8020f1d0 <line_len.0>
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
    8020087e:	0000f797          	auipc	a5,0xf
    80200882:	95278793          	addi	a5,a5,-1710 # 8020f1d0 <line_len.0>
    80200886:	439c                	lw	a5,0(a5)
    80200888:	37fd                	addiw	a5,a5,-1
    8020088a:	0007871b          	sext.w	a4,a5
    8020088e:	0000f797          	auipc	a5,0xf
    80200892:	94278793          	addi	a5,a5,-1726 # 8020f1d0 <line_len.0>
    80200896:	c398                	sw	a4,0(a5)
            if (line_len > 0) {
    80200898:	a889                	j	802008ea <uart_intr+0x1f4>
            }
        } else if (line_len < LINE_BUF_SIZE - 1) {
    8020089a:	0000f797          	auipc	a5,0xf
    8020089e:	93678793          	addi	a5,a5,-1738 # 8020f1d0 <line_len.0>
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
    802008bc:	0000f797          	auipc	a5,0xf
    802008c0:	91478793          	addi	a5,a5,-1772 # 8020f1d0 <line_len.0>
    802008c4:	439c                	lw	a5,0(a5)
    802008c6:	0017871b          	addiw	a4,a5,1
    802008ca:	0007069b          	sext.w	a3,a4
    802008ce:	0000f717          	auipc	a4,0xf
    802008d2:	90270713          	addi	a4,a4,-1790 # 8020f1d0 <line_len.0>
    802008d6:	c314                	sw	a3,0(a4)
    802008d8:	0000f717          	auipc	a4,0xf
    802008dc:	87870713          	addi	a4,a4,-1928 # 8020f150 <linebuf.1>
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
    80200918:	0000e797          	auipc	a5,0xe
    8020091c:	7a878793          	addi	a5,a5,1960 # 8020f0c0 <uart_input_buf>
    80200920:	0807a703          	lw	a4,128(a5)
    80200924:	0000e797          	auipc	a5,0xe
    80200928:	79c78793          	addi	a5,a5,1948 # 8020f0c0 <uart_input_buf>
    8020092c:	0847a783          	lw	a5,132(a5)
    80200930:	fef703e3          	beq	a4,a5,80200916 <uart_getc_blocking+0x8>
    }
    
    // 读取字符
    char c = uart_input_buf.buf[uart_input_buf.r];
    80200934:	0000e797          	auipc	a5,0xe
    80200938:	78c78793          	addi	a5,a5,1932 # 8020f0c0 <uart_input_buf>
    8020093c:	0807a783          	lw	a5,128(a5)
    80200940:	0000e717          	auipc	a4,0xe
    80200944:	78070713          	addi	a4,a4,1920 # 8020f0c0 <uart_input_buf>
    80200948:	1782                	slli	a5,a5,0x20
    8020094a:	9381                	srli	a5,a5,0x20
    8020094c:	97ba                	add	a5,a5,a4
    8020094e:	0007c783          	lbu	a5,0(a5)
    80200952:	fef407a3          	sb	a5,-17(s0)
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    80200956:	0000e797          	auipc	a5,0xe
    8020095a:	76a78793          	addi	a5,a5,1898 # 8020f0c0 <uart_input_buf>
    8020095e:	0807a783          	lw	a5,128(a5)
    80200962:	2785                	addiw	a5,a5,1
    80200964:	2781                	sext.w	a5,a5
    80200966:	07f7f793          	andi	a5,a5,127
    8020096a:	0007871b          	sext.w	a4,a5
    8020096e:	0000e797          	auipc	a5,0xe
    80200972:	75278793          	addi	a5,a5,1874 # 8020f0c0 <uart_input_buf>
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
    80200a28:	0000f797          	auipc	a5,0xf
    80200a2c:	83078793          	addi	a5,a5,-2000 # 8020f258 <printf_buf_pos>
    80200a30:	439c                	lw	a5,0(a5)
    80200a32:	02f05c63          	blez	a5,80200a6a <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200a36:	0000f797          	auipc	a5,0xf
    80200a3a:	82278793          	addi	a5,a5,-2014 # 8020f258 <printf_buf_pos>
    80200a3e:	439c                	lw	a5,0(a5)
    80200a40:	0000e717          	auipc	a4,0xe
    80200a44:	79870713          	addi	a4,a4,1944 # 8020f1d8 <printf_buffer>
    80200a48:	97ba                	add	a5,a5,a4
    80200a4a:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80200a4e:	0000e517          	auipc	a0,0xe
    80200a52:	78a50513          	addi	a0,a0,1930 # 8020f1d8 <printf_buffer>
    80200a56:	00000097          	auipc	ra,0x0
    80200a5a:	be8080e7          	jalr	-1048(ra) # 8020063e <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200a5e:	0000e797          	auipc	a5,0xe
    80200a62:	7fa78793          	addi	a5,a5,2042 # 8020f258 <printf_buf_pos>
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
    80200a82:	0000e797          	auipc	a5,0xe
    80200a86:	7d678793          	addi	a5,a5,2006 # 8020f258 <printf_buf_pos>
    80200a8a:	439c                	lw	a5,0(a5)
    80200a8c:	873e                	mv	a4,a5
    80200a8e:	07e00793          	li	a5,126
    80200a92:	02e7ca63          	blt	a5,a4,80200ac6 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200a96:	0000e797          	auipc	a5,0xe
    80200a9a:	7c278793          	addi	a5,a5,1986 # 8020f258 <printf_buf_pos>
    80200a9e:	439c                	lw	a5,0(a5)
    80200aa0:	0017871b          	addiw	a4,a5,1
    80200aa4:	0007069b          	sext.w	a3,a4
    80200aa8:	0000e717          	auipc	a4,0xe
    80200aac:	7b070713          	addi	a4,a4,1968 # 8020f258 <printf_buf_pos>
    80200ab0:	c314                	sw	a3,0(a4)
    80200ab2:	0000e717          	auipc	a4,0xe
    80200ab6:	72670713          	addi	a4,a4,1830 # 8020f1d8 <printf_buffer>
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
    80200ace:	0000e797          	auipc	a5,0xe
    80200ad2:	78a78793          	addi	a5,a5,1930 # 8020f258 <printf_buf_pos>
    80200ad6:	439c                	lw	a5,0(a5)
    80200ad8:	0017871b          	addiw	a4,a5,1
    80200adc:	0007069b          	sext.w	a3,a4
    80200ae0:	0000e717          	auipc	a4,0xe
    80200ae4:	77870713          	addi	a4,a4,1912 # 8020f258 <printf_buf_pos>
    80200ae8:	c314                	sw	a3,0(a4)
    80200aea:	0000e717          	auipc	a4,0xe
    80200aee:	6ee70713          	addi	a4,a4,1774 # 8020f1d8 <printf_buffer>
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
    80200bce:	0000e697          	auipc	a3,0xe
    80200bd2:	4aa68693          	addi	a3,a3,1194 # 8020f078 <digits.0>
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
    80200e52:	54678793          	addi	a5,a5,1350 # 80208394 <simple_user_task_bin+0x7c>
    80200e56:	97ba                	add	a5,a5,a4
    80200e58:	439c                	lw	a5,0(a5)
    80200e5a:	0007871b          	sext.w	a4,a5
    80200e5e:	00007797          	auipc	a5,0x7
    80200e62:	53678793          	addi	a5,a5,1334 # 80208394 <simple_user_task_bin+0x7c>
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
    80200fa6:	3ce78793          	addi	a5,a5,974 # 80208370 <simple_user_task_bin+0x58>
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
    80200fd2:	3aa50513          	addi	a0,a0,938 # 80208378 <simple_user_task_bin+0x60>
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
    8020100a:	37a70713          	addi	a4,a4,890 # 80208380 <simple_user_task_bin+0x68>
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
    802011b8:	23c50513          	addi	a0,a0,572 # 802083f0 <simple_user_task_bin+0xd8>
    802011bc:	fffff097          	auipc	ra,0xfffff
    802011c0:	482080e7          	jalr	1154(ra) # 8020063e <uart_puts>
	uart_puts(CURSOR_HOME);
    802011c4:	00007517          	auipc	a0,0x7
    802011c8:	23450513          	addi	a0,a0,564 # 802083f8 <simple_user_task_bin+0xe0>
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
    80201498:	00007517          	auipc	a0,0x7
    8020149c:	f6850513          	addi	a0,a0,-152 # 80208400 <simple_user_task_bin+0xe8>
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
    802016f8:	00007517          	auipc	a0,0x7
    802016fc:	d1050513          	addi	a0,a0,-752 # 80208408 <simple_user_task_bin+0xf0>
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
    8020173a:	00007517          	auipc	a0,0x7
    8020173e:	cde50513          	addi	a0,a0,-802 # 80208418 <simple_user_task_bin+0x100>
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
    80201792:	00007517          	auipc	a0,0x7
    80201796:	c9650513          	addi	a0,a0,-874 # 80208428 <simple_user_task_bin+0x110>
    8020179a:	fffff097          	auipc	ra,0xfffff
    8020179e:	4fa080e7          	jalr	1274(ra) # 80200c94 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    802017a2:	00007517          	auipc	a0,0x7
    802017a6:	ca650513          	addi	a0,a0,-858 # 80208448 <simple_user_task_bin+0x130>
    802017aa:	fffff097          	auipc	ra,0xfffff
    802017ae:	4ea080e7          	jalr	1258(ra) # 80200c94 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    802017b2:	0ff00593          	li	a1,255
    802017b6:	00007517          	auipc	a0,0x7
    802017ba:	caa50513          	addi	a0,a0,-854 # 80208460 <simple_user_task_bin+0x148>
    802017be:	fffff097          	auipc	ra,0xfffff
    802017c2:	4d6080e7          	jalr	1238(ra) # 80200c94 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    802017c6:	6585                	lui	a1,0x1
    802017c8:	00007517          	auipc	a0,0x7
    802017cc:	cb850513          	addi	a0,a0,-840 # 80208480 <simple_user_task_bin+0x168>
    802017d0:	fffff097          	auipc	ra,0xfffff
    802017d4:	4c4080e7          	jalr	1220(ra) # 80200c94 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    802017d8:	1234b7b7          	lui	a5,0x1234b
    802017dc:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    802017e0:	00007517          	auipc	a0,0x7
    802017e4:	cc050513          	addi	a0,a0,-832 # 802084a0 <simple_user_task_bin+0x188>
    802017e8:	fffff097          	auipc	ra,0xfffff
    802017ec:	4ac080e7          	jalr	1196(ra) # 80200c94 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    802017f0:	00007517          	auipc	a0,0x7
    802017f4:	cc850513          	addi	a0,a0,-824 # 802084b8 <simple_user_task_bin+0x1a0>
    802017f8:	fffff097          	auipc	ra,0xfffff
    802017fc:	49c080e7          	jalr	1180(ra) # 80200c94 <printf>
    printf("  正数: %d\n", 42);
    80201800:	02a00593          	li	a1,42
    80201804:	00007517          	auipc	a0,0x7
    80201808:	ccc50513          	addi	a0,a0,-820 # 802084d0 <simple_user_task_bin+0x1b8>
    8020180c:	fffff097          	auipc	ra,0xfffff
    80201810:	488080e7          	jalr	1160(ra) # 80200c94 <printf>
    printf("  负数: %d\n", -42);
    80201814:	fd600593          	li	a1,-42
    80201818:	00007517          	auipc	a0,0x7
    8020181c:	cc850513          	addi	a0,a0,-824 # 802084e0 <simple_user_task_bin+0x1c8>
    80201820:	fffff097          	auipc	ra,0xfffff
    80201824:	474080e7          	jalr	1140(ra) # 80200c94 <printf>
    printf("  零: %d\n", 0);
    80201828:	4581                	li	a1,0
    8020182a:	00007517          	auipc	a0,0x7
    8020182e:	cc650513          	addi	a0,a0,-826 # 802084f0 <simple_user_task_bin+0x1d8>
    80201832:	fffff097          	auipc	ra,0xfffff
    80201836:	462080e7          	jalr	1122(ra) # 80200c94 <printf>
    printf("  大数: %d\n", 123456789);
    8020183a:	075bd7b7          	lui	a5,0x75bd
    8020183e:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    80201842:	00007517          	auipc	a0,0x7
    80201846:	cbe50513          	addi	a0,a0,-834 # 80208500 <simple_user_task_bin+0x1e8>
    8020184a:	fffff097          	auipc	ra,0xfffff
    8020184e:	44a080e7          	jalr	1098(ra) # 80200c94 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80201852:	00007517          	auipc	a0,0x7
    80201856:	cbe50513          	addi	a0,a0,-834 # 80208510 <simple_user_task_bin+0x1f8>
    8020185a:	fffff097          	auipc	ra,0xfffff
    8020185e:	43a080e7          	jalr	1082(ra) # 80200c94 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80201862:	55fd                	li	a1,-1
    80201864:	00007517          	auipc	a0,0x7
    80201868:	cc450513          	addi	a0,a0,-828 # 80208528 <simple_user_task_bin+0x210>
    8020186c:	fffff097          	auipc	ra,0xfffff
    80201870:	428080e7          	jalr	1064(ra) # 80200c94 <printf>
    printf("  零：%u\n", 0U);
    80201874:	4581                	li	a1,0
    80201876:	00007517          	auipc	a0,0x7
    8020187a:	cca50513          	addi	a0,a0,-822 # 80208540 <simple_user_task_bin+0x228>
    8020187e:	fffff097          	auipc	ra,0xfffff
    80201882:	416080e7          	jalr	1046(ra) # 80200c94 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80201886:	678d                	lui	a5,0x3
    80201888:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    8020188c:	00007517          	auipc	a0,0x7
    80201890:	cc450513          	addi	a0,a0,-828 # 80208550 <simple_user_task_bin+0x238>
    80201894:	fffff097          	auipc	ra,0xfffff
    80201898:	400080e7          	jalr	1024(ra) # 80200c94 <printf>

	// 测试边界
	printf("边界测试:\n");
    8020189c:	00007517          	auipc	a0,0x7
    802018a0:	ccc50513          	addi	a0,a0,-820 # 80208568 <simple_user_task_bin+0x250>
    802018a4:	fffff097          	auipc	ra,0xfffff
    802018a8:	3f0080e7          	jalr	1008(ra) # 80200c94 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    802018ac:	800007b7          	lui	a5,0x80000
    802018b0:	fff7c593          	not	a1,a5
    802018b4:	00007517          	auipc	a0,0x7
    802018b8:	cc450513          	addi	a0,a0,-828 # 80208578 <simple_user_task_bin+0x260>
    802018bc:	fffff097          	auipc	ra,0xfffff
    802018c0:	3d8080e7          	jalr	984(ra) # 80200c94 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    802018c4:	800005b7          	lui	a1,0x80000
    802018c8:	00007517          	auipc	a0,0x7
    802018cc:	cc050513          	addi	a0,a0,-832 # 80208588 <simple_user_task_bin+0x270>
    802018d0:	fffff097          	auipc	ra,0xfffff
    802018d4:	3c4080e7          	jalr	964(ra) # 80200c94 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    802018d8:	55fd                	li	a1,-1
    802018da:	00007517          	auipc	a0,0x7
    802018de:	cbe50513          	addi	a0,a0,-834 # 80208598 <simple_user_task_bin+0x280>
    802018e2:	fffff097          	auipc	ra,0xfffff
    802018e6:	3b2080e7          	jalr	946(ra) # 80200c94 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    802018ea:	55fd                	li	a1,-1
    802018ec:	00007517          	auipc	a0,0x7
    802018f0:	cbc50513          	addi	a0,a0,-836 # 802085a8 <simple_user_task_bin+0x290>
    802018f4:	fffff097          	auipc	ra,0xfffff
    802018f8:	3a0080e7          	jalr	928(ra) # 80200c94 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    802018fc:	00007517          	auipc	a0,0x7
    80201900:	cc450513          	addi	a0,a0,-828 # 802085c0 <simple_user_task_bin+0x2a8>
    80201904:	fffff097          	auipc	ra,0xfffff
    80201908:	390080e7          	jalr	912(ra) # 80200c94 <printf>
    printf("  空字符串: '%s'\n", "");
    8020190c:	00007597          	auipc	a1,0x7
    80201910:	ccc58593          	addi	a1,a1,-820 # 802085d8 <simple_user_task_bin+0x2c0>
    80201914:	00007517          	auipc	a0,0x7
    80201918:	ccc50513          	addi	a0,a0,-820 # 802085e0 <simple_user_task_bin+0x2c8>
    8020191c:	fffff097          	auipc	ra,0xfffff
    80201920:	378080e7          	jalr	888(ra) # 80200c94 <printf>
    printf("  单字符: '%s'\n", "X");
    80201924:	00007597          	auipc	a1,0x7
    80201928:	cd458593          	addi	a1,a1,-812 # 802085f8 <simple_user_task_bin+0x2e0>
    8020192c:	00007517          	auipc	a0,0x7
    80201930:	cd450513          	addi	a0,a0,-812 # 80208600 <simple_user_task_bin+0x2e8>
    80201934:	fffff097          	auipc	ra,0xfffff
    80201938:	360080e7          	jalr	864(ra) # 80200c94 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    8020193c:	00007597          	auipc	a1,0x7
    80201940:	cdc58593          	addi	a1,a1,-804 # 80208618 <simple_user_task_bin+0x300>
    80201944:	00007517          	auipc	a0,0x7
    80201948:	cf450513          	addi	a0,a0,-780 # 80208638 <simple_user_task_bin+0x320>
    8020194c:	fffff097          	auipc	ra,0xfffff
    80201950:	348080e7          	jalr	840(ra) # 80200c94 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80201954:	00007597          	auipc	a1,0x7
    80201958:	cfc58593          	addi	a1,a1,-772 # 80208650 <simple_user_task_bin+0x338>
    8020195c:	00007517          	auipc	a0,0x7
    80201960:	e4450513          	addi	a0,a0,-444 # 802087a0 <simple_user_task_bin+0x488>
    80201964:	fffff097          	auipc	ra,0xfffff
    80201968:	330080e7          	jalr	816(ra) # 80200c94 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    8020196c:	00007517          	auipc	a0,0x7
    80201970:	e5450513          	addi	a0,a0,-428 # 802087c0 <simple_user_task_bin+0x4a8>
    80201974:	fffff097          	auipc	ra,0xfffff
    80201978:	320080e7          	jalr	800(ra) # 80200c94 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    8020197c:	0ff00693          	li	a3,255
    80201980:	f0100613          	li	a2,-255
    80201984:	0ff00593          	li	a1,255
    80201988:	00007517          	auipc	a0,0x7
    8020198c:	e5050513          	addi	a0,a0,-432 # 802087d8 <simple_user_task_bin+0x4c0>
    80201990:	fffff097          	auipc	ra,0xfffff
    80201994:	304080e7          	jalr	772(ra) # 80200c94 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80201998:	00007517          	auipc	a0,0x7
    8020199c:	e6850513          	addi	a0,a0,-408 # 80208800 <simple_user_task_bin+0x4e8>
    802019a0:	fffff097          	auipc	ra,0xfffff
    802019a4:	2f4080e7          	jalr	756(ra) # 80200c94 <printf>
	printf("  100%% 完成!\n");
    802019a8:	00007517          	auipc	a0,0x7
    802019ac:	e7050513          	addi	a0,a0,-400 # 80208818 <simple_user_task_bin+0x500>
    802019b0:	fffff097          	auipc	ra,0xfffff
    802019b4:	2e4080e7          	jalr	740(ra) # 80200c94 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    802019b8:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    802019bc:	00007517          	auipc	a0,0x7
    802019c0:	e7450513          	addi	a0,a0,-396 # 80208830 <simple_user_task_bin+0x518>
    802019c4:	fffff097          	auipc	ra,0xfffff
    802019c8:	2d0080e7          	jalr	720(ra) # 80200c94 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    802019cc:	fe843583          	ld	a1,-24(s0)
    802019d0:	00007517          	auipc	a0,0x7
    802019d4:	e7850513          	addi	a0,a0,-392 # 80208848 <simple_user_task_bin+0x530>
    802019d8:	fffff097          	auipc	ra,0xfffff
    802019dc:	2bc080e7          	jalr	700(ra) # 80200c94 <printf>
	
	// 测试指针格式
	int var = 42;
    802019e0:	02a00793          	li	a5,42
    802019e4:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    802019e8:	00007517          	auipc	a0,0x7
    802019ec:	e7850513          	addi	a0,a0,-392 # 80208860 <simple_user_task_bin+0x548>
    802019f0:	fffff097          	auipc	ra,0xfffff
    802019f4:	2a4080e7          	jalr	676(ra) # 80200c94 <printf>
	printf("  Address of var: %p\n", &var);
    802019f8:	fe440793          	addi	a5,s0,-28
    802019fc:	85be                	mv	a1,a5
    802019fe:	00007517          	auipc	a0,0x7
    80201a02:	e7250513          	addi	a0,a0,-398 # 80208870 <simple_user_task_bin+0x558>
    80201a06:	fffff097          	auipc	ra,0xfffff
    80201a0a:	28e080e7          	jalr	654(ra) # 80200c94 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80201a0e:	00007517          	auipc	a0,0x7
    80201a12:	e7a50513          	addi	a0,a0,-390 # 80208888 <simple_user_task_bin+0x570>
    80201a16:	fffff097          	auipc	ra,0xfffff
    80201a1a:	27e080e7          	jalr	638(ra) # 80200c94 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201a1e:	55fd                	li	a1,-1
    80201a20:	00007517          	auipc	a0,0x7
    80201a24:	e8850513          	addi	a0,a0,-376 # 802088a8 <simple_user_task_bin+0x590>
    80201a28:	fffff097          	auipc	ra,0xfffff
    80201a2c:	26c080e7          	jalr	620(ra) # 80200c94 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201a30:	00007517          	auipc	a0,0x7
    80201a34:	e9050513          	addi	a0,a0,-368 # 802088c0 <simple_user_task_bin+0x5a8>
    80201a38:	fffff097          	auipc	ra,0xfffff
    80201a3c:	25c080e7          	jalr	604(ra) # 80200c94 <printf>
	printf("  Binary of 5: %b\n", 5);
    80201a40:	4595                	li	a1,5
    80201a42:	00007517          	auipc	a0,0x7
    80201a46:	e9650513          	addi	a0,a0,-362 # 802088d8 <simple_user_task_bin+0x5c0>
    80201a4a:	fffff097          	auipc	ra,0xfffff
    80201a4e:	24a080e7          	jalr	586(ra) # 80200c94 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201a52:	45a1                	li	a1,8
    80201a54:	00007517          	auipc	a0,0x7
    80201a58:	e9c50513          	addi	a0,a0,-356 # 802088f0 <simple_user_task_bin+0x5d8>
    80201a5c:	fffff097          	auipc	ra,0xfffff
    80201a60:	238080e7          	jalr	568(ra) # 80200c94 <printf>
	printf("=== printf测试结束 ===\n");
    80201a64:	00007517          	auipc	a0,0x7
    80201a68:	ea450513          	addi	a0,a0,-348 # 80208908 <simple_user_task_bin+0x5f0>
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
    80201a8e:	00007517          	auipc	a0,0x7
    80201a92:	e9a50513          	addi	a0,a0,-358 # 80208928 <simple_user_task_bin+0x610>
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
    80201ac2:	00007517          	auipc	a0,0x7
    80201ac6:	e8650513          	addi	a0,a0,-378 # 80208948 <simple_user_task_bin+0x630>
    80201aca:	fffff097          	auipc	ra,0xfffff
    80201ace:	1ca080e7          	jalr	458(ra) # 80200c94 <printf>
		for (int j = 1; j <= 10; j++) {
    80201ad2:	fe842783          	lw	a5,-24(s0)
    80201ad6:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdf0901>
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
    80201b2a:	00007517          	auipc	a0,0x7
    80201b2e:	e2650513          	addi	a0,a0,-474 # 80208950 <simple_user_task_bin+0x638>
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
    80201b4e:	00007517          	auipc	a0,0x7
    80201b52:	e0a50513          	addi	a0,a0,-502 # 80208958 <simple_user_task_bin+0x640>
    80201b56:	fffff097          	auipc	ra,0xfffff
    80201b5a:	13e080e7          	jalr	318(ra) # 80200c94 <printf>
	restore_cursor();
    80201b5e:	00000097          	auipc	ra,0x0
    80201b62:	824080e7          	jalr	-2012(ra) # 80201382 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80201b66:	00007517          	auipc	a0,0x7
    80201b6a:	dfa50513          	addi	a0,a0,-518 # 80208960 <simple_user_task_bin+0x648>
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
    80201b90:	00007517          	auipc	a0,0x7
    80201b94:	df850513          	addi	a0,a0,-520 # 80208988 <simple_user_task_bin+0x670>
    80201b98:	fffff097          	auipc	ra,0xfffff
    80201b9c:	0fc080e7          	jalr	252(ra) # 80200c94 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80201ba0:	00007517          	auipc	a0,0x7
    80201ba4:	e0850513          	addi	a0,a0,-504 # 802089a8 <simple_user_task_bin+0x690>
    80201ba8:	fffff097          	auipc	ra,0xfffff
    80201bac:	0ec080e7          	jalr	236(ra) # 80200c94 <printf>
    color_red();    printf("红色文字 ");
    80201bb0:	00000097          	auipc	ra,0x0
    80201bb4:	9e4080e7          	jalr	-1564(ra) # 80201594 <color_red>
    80201bb8:	00007517          	auipc	a0,0x7
    80201bbc:	e0850513          	addi	a0,a0,-504 # 802089c0 <simple_user_task_bin+0x6a8>
    80201bc0:	fffff097          	auipc	ra,0xfffff
    80201bc4:	0d4080e7          	jalr	212(ra) # 80200c94 <printf>
    color_green();  printf("绿色文字 ");
    80201bc8:	00000097          	auipc	ra,0x0
    80201bcc:	9e8080e7          	jalr	-1560(ra) # 802015b0 <color_green>
    80201bd0:	00007517          	auipc	a0,0x7
    80201bd4:	e0050513          	addi	a0,a0,-512 # 802089d0 <simple_user_task_bin+0x6b8>
    80201bd8:	fffff097          	auipc	ra,0xfffff
    80201bdc:	0bc080e7          	jalr	188(ra) # 80200c94 <printf>
    color_yellow(); printf("黄色文字 ");
    80201be0:	00000097          	auipc	ra,0x0
    80201be4:	9ee080e7          	jalr	-1554(ra) # 802015ce <color_yellow>
    80201be8:	00007517          	auipc	a0,0x7
    80201bec:	df850513          	addi	a0,a0,-520 # 802089e0 <simple_user_task_bin+0x6c8>
    80201bf0:	fffff097          	auipc	ra,0xfffff
    80201bf4:	0a4080e7          	jalr	164(ra) # 80200c94 <printf>
    color_blue();   printf("蓝色文字 ");
    80201bf8:	00000097          	auipc	ra,0x0
    80201bfc:	9f4080e7          	jalr	-1548(ra) # 802015ec <color_blue>
    80201c00:	00007517          	auipc	a0,0x7
    80201c04:	df050513          	addi	a0,a0,-528 # 802089f0 <simple_user_task_bin+0x6d8>
    80201c08:	fffff097          	auipc	ra,0xfffff
    80201c0c:	08c080e7          	jalr	140(ra) # 80200c94 <printf>
    color_purple(); printf("紫色文字 ");
    80201c10:	00000097          	auipc	ra,0x0
    80201c14:	9fa080e7          	jalr	-1542(ra) # 8020160a <color_purple>
    80201c18:	00007517          	auipc	a0,0x7
    80201c1c:	de850513          	addi	a0,a0,-536 # 80208a00 <simple_user_task_bin+0x6e8>
    80201c20:	fffff097          	auipc	ra,0xfffff
    80201c24:	074080e7          	jalr	116(ra) # 80200c94 <printf>
    color_cyan();   printf("青色文字 ");
    80201c28:	00000097          	auipc	ra,0x0
    80201c2c:	a00080e7          	jalr	-1536(ra) # 80201628 <color_cyan>
    80201c30:	00007517          	auipc	a0,0x7
    80201c34:	de050513          	addi	a0,a0,-544 # 80208a10 <simple_user_task_bin+0x6f8>
    80201c38:	fffff097          	auipc	ra,0xfffff
    80201c3c:	05c080e7          	jalr	92(ra) # 80200c94 <printf>
    color_reverse();  printf("反色文字");
    80201c40:	00000097          	auipc	ra,0x0
    80201c44:	a06080e7          	jalr	-1530(ra) # 80201646 <color_reverse>
    80201c48:	00007517          	auipc	a0,0x7
    80201c4c:	dd850513          	addi	a0,a0,-552 # 80208a20 <simple_user_task_bin+0x708>
    80201c50:	fffff097          	auipc	ra,0xfffff
    80201c54:	044080e7          	jalr	68(ra) # 80200c94 <printf>
    reset_color();
    80201c58:	00000097          	auipc	ra,0x0
    80201c5c:	838080e7          	jalr	-1992(ra) # 80201490 <reset_color>
    printf("\n\n");
    80201c60:	00007517          	auipc	a0,0x7
    80201c64:	dd050513          	addi	a0,a0,-560 # 80208a30 <simple_user_task_bin+0x718>
    80201c68:	fffff097          	auipc	ra,0xfffff
    80201c6c:	02c080e7          	jalr	44(ra) # 80200c94 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80201c70:	00007517          	auipc	a0,0x7
    80201c74:	dc850513          	addi	a0,a0,-568 # 80208a38 <simple_user_task_bin+0x720>
    80201c78:	fffff097          	auipc	ra,0xfffff
    80201c7c:	01c080e7          	jalr	28(ra) # 80200c94 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80201c80:	02900513          	li	a0,41
    80201c84:	00000097          	auipc	ra,0x0
    80201c88:	89e080e7          	jalr	-1890(ra) # 80201522 <set_bg_color>
    80201c8c:	00007517          	auipc	a0,0x7
    80201c90:	dc450513          	addi	a0,a0,-572 # 80208a50 <simple_user_task_bin+0x738>
    80201c94:	fffff097          	auipc	ra,0xfffff
    80201c98:	000080e7          	jalr	ra # 80200c94 <printf>
    80201c9c:	fffff097          	auipc	ra,0xfffff
    80201ca0:	7f4080e7          	jalr	2036(ra) # 80201490 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80201ca4:	02a00513          	li	a0,42
    80201ca8:	00000097          	auipc	ra,0x0
    80201cac:	87a080e7          	jalr	-1926(ra) # 80201522 <set_bg_color>
    80201cb0:	00007517          	auipc	a0,0x7
    80201cb4:	db050513          	addi	a0,a0,-592 # 80208a60 <simple_user_task_bin+0x748>
    80201cb8:	fffff097          	auipc	ra,0xfffff
    80201cbc:	fdc080e7          	jalr	-36(ra) # 80200c94 <printf>
    80201cc0:	fffff097          	auipc	ra,0xfffff
    80201cc4:	7d0080e7          	jalr	2000(ra) # 80201490 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80201cc8:	02b00513          	li	a0,43
    80201ccc:	00000097          	auipc	ra,0x0
    80201cd0:	856080e7          	jalr	-1962(ra) # 80201522 <set_bg_color>
    80201cd4:	00007517          	auipc	a0,0x7
    80201cd8:	d9c50513          	addi	a0,a0,-612 # 80208a70 <simple_user_task_bin+0x758>
    80201cdc:	fffff097          	auipc	ra,0xfffff
    80201ce0:	fb8080e7          	jalr	-72(ra) # 80200c94 <printf>
    80201ce4:	fffff097          	auipc	ra,0xfffff
    80201ce8:	7ac080e7          	jalr	1964(ra) # 80201490 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80201cec:	02c00513          	li	a0,44
    80201cf0:	00000097          	auipc	ra,0x0
    80201cf4:	832080e7          	jalr	-1998(ra) # 80201522 <set_bg_color>
    80201cf8:	00007517          	auipc	a0,0x7
    80201cfc:	d8850513          	addi	a0,a0,-632 # 80208a80 <simple_user_task_bin+0x768>
    80201d00:	fffff097          	auipc	ra,0xfffff
    80201d04:	f94080e7          	jalr	-108(ra) # 80200c94 <printf>
    80201d08:	fffff097          	auipc	ra,0xfffff
    80201d0c:	788080e7          	jalr	1928(ra) # 80201490 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201d10:	02f00513          	li	a0,47
    80201d14:	00000097          	auipc	ra,0x0
    80201d18:	80e080e7          	jalr	-2034(ra) # 80201522 <set_bg_color>
    80201d1c:	00007517          	auipc	a0,0x7
    80201d20:	d7450513          	addi	a0,a0,-652 # 80208a90 <simple_user_task_bin+0x778>
    80201d24:	fffff097          	auipc	ra,0xfffff
    80201d28:	f70080e7          	jalr	-144(ra) # 80200c94 <printf>
    80201d2c:	fffff097          	auipc	ra,0xfffff
    80201d30:	764080e7          	jalr	1892(ra) # 80201490 <reset_color>
    printf("\n\n");
    80201d34:	00007517          	auipc	a0,0x7
    80201d38:	cfc50513          	addi	a0,a0,-772 # 80208a30 <simple_user_task_bin+0x718>
    80201d3c:	fffff097          	auipc	ra,0xfffff
    80201d40:	f58080e7          	jalr	-168(ra) # 80200c94 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201d44:	00007517          	auipc	a0,0x7
    80201d48:	d5c50513          	addi	a0,a0,-676 # 80208aa0 <simple_user_task_bin+0x788>
    80201d4c:	fffff097          	auipc	ra,0xfffff
    80201d50:	f48080e7          	jalr	-184(ra) # 80200c94 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201d54:	02c00593          	li	a1,44
    80201d58:	457d                	li	a0,31
    80201d5a:	00000097          	auipc	ra,0x0
    80201d5e:	90a080e7          	jalr	-1782(ra) # 80201664 <set_color>
    80201d62:	00007517          	auipc	a0,0x7
    80201d66:	d5650513          	addi	a0,a0,-682 # 80208ab8 <simple_user_task_bin+0x7a0>
    80201d6a:	fffff097          	auipc	ra,0xfffff
    80201d6e:	f2a080e7          	jalr	-214(ra) # 80200c94 <printf>
    80201d72:	fffff097          	auipc	ra,0xfffff
    80201d76:	71e080e7          	jalr	1822(ra) # 80201490 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201d7a:	02d00593          	li	a1,45
    80201d7e:	02100513          	li	a0,33
    80201d82:	00000097          	auipc	ra,0x0
    80201d86:	8e2080e7          	jalr	-1822(ra) # 80201664 <set_color>
    80201d8a:	00007517          	auipc	a0,0x7
    80201d8e:	d3e50513          	addi	a0,a0,-706 # 80208ac8 <simple_user_task_bin+0x7b0>
    80201d92:	fffff097          	auipc	ra,0xfffff
    80201d96:	f02080e7          	jalr	-254(ra) # 80200c94 <printf>
    80201d9a:	fffff097          	auipc	ra,0xfffff
    80201d9e:	6f6080e7          	jalr	1782(ra) # 80201490 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201da2:	02f00593          	li	a1,47
    80201da6:	02000513          	li	a0,32
    80201daa:	00000097          	auipc	ra,0x0
    80201dae:	8ba080e7          	jalr	-1862(ra) # 80201664 <set_color>
    80201db2:	00007517          	auipc	a0,0x7
    80201db6:	d2650513          	addi	a0,a0,-730 # 80208ad8 <simple_user_task_bin+0x7c0>
    80201dba:	fffff097          	auipc	ra,0xfffff
    80201dbe:	eda080e7          	jalr	-294(ra) # 80200c94 <printf>
    80201dc2:	fffff097          	auipc	ra,0xfffff
    80201dc6:	6ce080e7          	jalr	1742(ra) # 80201490 <reset_color>
    printf("\n\n");
    80201dca:	00007517          	auipc	a0,0x7
    80201dce:	c6650513          	addi	a0,a0,-922 # 80208a30 <simple_user_task_bin+0x718>
    80201dd2:	fffff097          	auipc	ra,0xfffff
    80201dd6:	ec2080e7          	jalr	-318(ra) # 80200c94 <printf>
	reset_color();
    80201dda:	fffff097          	auipc	ra,0xfffff
    80201dde:	6b6080e7          	jalr	1718(ra) # 80201490 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201de2:	00007517          	auipc	a0,0x7
    80201de6:	d0650513          	addi	a0,a0,-762 # 80208ae8 <simple_user_task_bin+0x7d0>
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
    80201e04:	00007517          	auipc	a0,0x7
    80201e08:	d1c50513          	addi	a0,a0,-740 # 80208b20 <simple_user_task_bin+0x808>
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
    80201fae:	56658593          	addi	a1,a1,1382 # 80209510 <simple_user_task_bin+0x58>
    80201fb2:	00007517          	auipc	a0,0x7
    80201fb6:	56e50513          	addi	a0,a0,1390 # 80209520 <simple_user_task_bin+0x68>
    80201fba:	fffff097          	auipc	ra,0xfffff
    80201fbe:	cda080e7          	jalr	-806(ra) # 80200c94 <printf>
    80201fc2:	00007517          	auipc	a0,0x7
    80201fc6:	58650513          	addi	a0,a0,1414 # 80209548 <simple_user_task_bin+0x90>
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
    802020e6:	00007517          	auipc	a0,0x7
    802020ea:	46a50513          	addi	a0,a0,1130 # 80209550 <simple_user_task_bin+0x98>
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
    8020212a:	00007517          	auipc	a0,0x7
    8020212e:	43e50513          	addi	a0,a0,1086 # 80209568 <simple_user_task_bin+0xb0>
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
    80202180:	00007517          	auipc	a0,0x7
    80202184:	41050513          	addi	a0,a0,1040 # 80209590 <simple_user_task_bin+0xd8>
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
    802021a8:	00007517          	auipc	a0,0x7
    802021ac:	43050513          	addi	a0,a0,1072 # 802095d8 <simple_user_task_bin+0x120>
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
    80202222:	00007517          	auipc	a0,0x7
    80202226:	32e50513          	addi	a0,a0,814 # 80209550 <simple_user_task_bin+0x98>
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
    80202308:	64c080e7          	jalr	1612(ra) # 80204950 <myproc>
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
    80202344:	00007517          	auipc	a0,0x7
    80202348:	2cc50513          	addi	a0,a0,716 # 80209610 <simple_user_task_bin+0x158>
    8020234c:	fffff097          	auipc	ra,0xfffff
    80202350:	3c8080e7          	jalr	968(ra) # 80201714 <warning>
		exit_proc(-1);
    80202354:	557d                	li	a0,-1
    80202356:	00003097          	auipc	ra,0x3
    8020235a:	2c6080e7          	jalr	710(ra) # 8020561c <exit_proc>
    if ((va % PGSIZE) != 0)
    8020235e:	fc043703          	ld	a4,-64(s0)
    80202362:	6785                	lui	a5,0x1
    80202364:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80202366:	8ff9                	and	a5,a5,a4
    80202368:	cb89                	beqz	a5,8020237a <map_page+0x90>
        panic("map_page: va not aligned");
    8020236a:	00007517          	auipc	a0,0x7
    8020236e:	2d650513          	addi	a0,a0,726 # 80209640 <simple_user_task_bin+0x188>
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
    80202428:	00007517          	auipc	a0,0x7
    8020242c:	23850513          	addi	a0,a0,568 # 80209660 <simple_user_task_bin+0x1a8>
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
    802024b6:	0007b023          	sd	zero,0(a5) # ffffffff80000000 <_bss_end+0xfffffffeffdf0900>
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
    80202526:	00007517          	auipc	a0,0x7
    8020252a:	16a50513          	addi	a0,a0,362 # 80209690 <simple_user_task_bin+0x1d8>
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
    8020257a:	00007517          	auipc	a0,0x7
    8020257e:	12e50513          	addi	a0,a0,302 # 802096a8 <simple_user_task_bin+0x1f0>
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
    802025bc:	00007517          	auipc	a0,0x7
    802025c0:	10c50513          	addi	a0,a0,268 # 802096c8 <simple_user_task_bin+0x210>
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
    802025f0:	00007517          	auipc	a0,0x7
    802025f4:	0f850513          	addi	a0,a0,248 # 802096e8 <simple_user_task_bin+0x230>
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
    8020263c:	00007517          	auipc	a0,0x7
    80202640:	0cc50513          	addi	a0,a0,204 # 80209708 <simple_user_task_bin+0x250>
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
    8020267e:	00007517          	auipc	a0,0x7
    80202682:	0aa50513          	addi	a0,a0,170 # 80209728 <simple_user_task_bin+0x270>
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
    802026a0:	00007517          	auipc	a0,0x7
    802026a4:	0a850513          	addi	a0,a0,168 # 80209748 <simple_user_task_bin+0x290>
    802026a8:	fffff097          	auipc	ra,0xfffff
    802026ac:	038080e7          	jalr	56(ra) # 802016e0 <panic>
	memcpy(tramp_phys, trampoline, PGSIZE);
    802026b0:	6605                	lui	a2,0x1
    802026b2:	00002597          	auipc	a1,0x2
    802026b6:	ffe58593          	addi	a1,a1,-2 # 802046b0 <trampoline>
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
    802026d8:	00007517          	auipc	a0,0x7
    802026dc:	09850513          	addi	a0,a0,152 # 80209770 <simple_user_task_bin+0x2b8>
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
    80202712:	00007517          	auipc	a0,0x7
    80202716:	08650513          	addi	a0,a0,134 # 80209798 <simple_user_task_bin+0x2e0>
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
    8020273c:	00007517          	auipc	a0,0x7
    80202740:	07c50513          	addi	a0,a0,124 # 802097b8 <simple_user_task_bin+0x300>
    80202744:	fffff097          	auipc	ra,0xfffff
    80202748:	f9c080e7          	jalr	-100(ra) # 802016e0 <panic>
	trampoline_phys_addr = (uint64)tramp_phys;
    8020274c:	fc043703          	ld	a4,-64(s0)
    80202750:	0000d797          	auipc	a5,0xd
    80202754:	94878793          	addi	a5,a5,-1720 # 8020f098 <trampoline_phys_addr>
    80202758:	e398                	sd	a4,0(a5)
	trapframe_phys_addr = (uint64)trapframe_phys;
    8020275a:	fb843703          	ld	a4,-72(s0)
    8020275e:	0000d797          	auipc	a5,0xd
    80202762:	94278793          	addi	a5,a5,-1726 # 8020f0a0 <trapframe_phys_addr>
    80202766:	e398                	sd	a4,0(a5)
	printf("trampoline_phy_addr = %lx\n",trampoline_phys_addr);
    80202768:	0000d797          	auipc	a5,0xd
    8020276c:	93078793          	addi	a5,a5,-1744 # 8020f098 <trampoline_phys_addr>
    80202770:	639c                	ld	a5,0(a5)
    80202772:	85be                	mv	a1,a5
    80202774:	00007517          	auipc	a0,0x7
    80202778:	06450513          	addi	a0,a0,100 # 802097d8 <simple_user_task_bin+0x320>
    8020277c:	ffffe097          	auipc	ra,0xffffe
    80202780:	518080e7          	jalr	1304(ra) # 80200c94 <printf>
	printf("trapframe_phys_addr = %lx\n",trapframe_phys_addr);
    80202784:	0000d797          	auipc	a5,0xd
    80202788:	91c78793          	addi	a5,a5,-1764 # 8020f0a0 <trapframe_phys_addr>
    8020278c:	639c                	ld	a5,0(a5)
    8020278e:	85be                	mv	a1,a5
    80202790:	00007517          	auipc	a0,0x7
    80202794:	06850513          	addi	a0,a0,104 # 802097f8 <simple_user_task_bin+0x340>
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
    802027ec:	0000d797          	auipc	a5,0xd
    802027f0:	8a478793          	addi	a5,a5,-1884 # 8020f090 <kernel_pagetable>
    802027f4:	e398                	sd	a4,0(a5)
    sfence_vma();
    802027f6:	00000097          	auipc	ra,0x0
    802027fa:	fd2080e7          	jalr	-46(ra) # 802027c8 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    802027fe:	0000d797          	auipc	a5,0xd
    80202802:	89278793          	addi	a5,a5,-1902 # 8020f090 <kernel_pagetable>
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
    80202824:	0000d797          	auipc	a5,0xd
    80202828:	86c78793          	addi	a5,a5,-1940 # 8020f090 <kernel_pagetable>
    8020282c:	639c                	ld	a5,0(a5)
    8020282e:	00c7d713          	srli	a4,a5,0xc
    80202832:	57fd                	li	a5,-1
    80202834:	17fe                	slli	a5,a5,0x3f
    80202836:	8fd9                	or	a5,a5,a4
    80202838:	85be                	mv	a1,a5
    8020283a:	00007517          	auipc	a0,0x7
    8020283e:	fde50513          	addi	a0,a0,-34 # 80209818 <simple_user_task_bin+0x360>
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
    8020285a:	0000d797          	auipc	a5,0xd
    8020285e:	83678793          	addi	a5,a5,-1994 # 8020f090 <kernel_pagetable>
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
    802028e4:	00007517          	auipc	a0,0x7
    802028e8:	f6450513          	addi	a0,a0,-156 # 80209848 <simple_user_task_bin+0x390>
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
    80202928:	00007517          	auipc	a0,0x7
    8020292c:	f2850513          	addi	a0,a0,-216 # 80209850 <simple_user_task_bin+0x398>
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
    8020299e:	00007517          	auipc	a0,0x7
    802029a2:	ee250513          	addi	a0,a0,-286 # 80209880 <simple_user_task_bin+0x3c8>
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
    802029c6:	00007517          	auipc	a0,0x7
    802029ca:	eea50513          	addi	a0,a0,-278 # 802098b0 <simple_user_task_bin+0x3f8>
    802029ce:	ffffe097          	auipc	ra,0xffffe
    802029d2:	2c6080e7          	jalr	710(ra) # 80200c94 <printf>
        return 0;
    802029d6:	4781                	li	a5,0
    802029d8:	aae9                	j	80202bb2 <handle_page_fault+0x230>
    struct proc *p = myproc();
    802029da:	00002097          	auipc	ra,0x2
    802029de:	f76080e7          	jalr	-138(ra) # 80204950 <myproc>
    802029e2:	fca43823          	sd	a0,-48(s0)
    pagetable_t pt = kernel_pagetable;
    802029e6:	0000c797          	auipc	a5,0xc
    802029ea:	6aa78793          	addi	a5,a5,1706 # 8020f090 <kernel_pagetable>
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
    80202aac:	00007517          	auipc	a0,0x7
    80202ab0:	e2c50513          	addi	a0,a0,-468 # 802098d8 <simple_user_task_bin+0x420>
    80202ab4:	ffffe097          	auipc	ra,0xffffe
    80202ab8:	1e0080e7          	jalr	480(ra) # 80200c94 <printf>
            return 1;
    80202abc:	4785                	li	a5,1
    80202abe:	a8d5                	j	80202bb2 <handle_page_fault+0x230>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80202ac0:	00007517          	auipc	a0,0x7
    80202ac4:	e4050513          	addi	a0,a0,-448 # 80209900 <simple_user_task_bin+0x448>
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
    80202ae6:	00007517          	auipc	a0,0x7
    80202aea:	e4a50513          	addi	a0,a0,-438 # 80209930 <simple_user_task_bin+0x478>
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
    80202b7a:	00007517          	auipc	a0,0x7
    80202b7e:	de650513          	addi	a0,a0,-538 # 80209960 <simple_user_task_bin+0x4a8>
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
    80202ba0:	00007517          	auipc	a0,0x7
    80202ba4:	de850513          	addi	a0,a0,-536 # 80209988 <simple_user_task_bin+0x4d0>
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
    80202bda:	00007517          	auipc	a0,0x7
    80202bde:	dee50513          	addi	a0,a0,-530 # 802099c8 <simple_user_task_bin+0x510>
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
    80202c0e:	00007517          	auipc	a0,0x7
    80202c12:	dda50513          	addi	a0,a0,-550 # 802099e8 <simple_user_task_bin+0x530>
    80202c16:	ffffe097          	auipc	ra,0xffffe
    80202c1a:	07e080e7          	jalr	126(ra) # 80200c94 <printf>
    uint64 va[] = {
    80202c1e:	00007797          	auipc	a5,0x7
    80202c22:	f8a78793          	addi	a5,a5,-118 # 80209ba8 <simple_user_task_bin+0x6f0>
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
    80202cea:	00007517          	auipc	a0,0x7
    80202cee:	d1e50513          	addi	a0,a0,-738 # 80209a08 <simple_user_task_bin+0x550>
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
    80202d54:	00007797          	auipc	a5,0x7
    80202d58:	cdc78793          	addi	a5,a5,-804 # 80209a30 <simple_user_task_bin+0x578>
    80202d5c:	a029                	j	80202d66 <test_pagetable+0x1aa>
    80202d5e:	00007797          	auipc	a5,0x7
    80202d62:	cda78793          	addi	a5,a5,-806 # 80209a38 <simple_user_task_bin+0x580>
    80202d66:	86be                	mv	a3,a5
    80202d68:	863a                	mv	a2,a4
    80202d6a:	00007517          	auipc	a0,0x7
    80202d6e:	cd650513          	addi	a0,a0,-810 # 80209a40 <simple_user_task_bin+0x588>
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
    80202db0:	00007517          	auipc	a0,0x7
    80202db4:	cc050513          	addi	a0,a0,-832 # 80209a70 <simple_user_task_bin+0x5b8>
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
    80202e1e:	00007517          	auipc	a0,0x7
    80202e22:	c7a50513          	addi	a0,a0,-902 # 80209a98 <simple_user_task_bin+0x5e0>
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
    80202e42:	00007517          	auipc	a0,0x7
    80202e46:	c9650513          	addi	a0,a0,-874 # 80209ad8 <simple_user_task_bin+0x620>
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
    80202e6e:	00007517          	auipc	a0,0x7
    80202e72:	c9a50513          	addi	a0,a0,-870 # 80209b08 <simple_user_task_bin+0x650>
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
    80202ec2:	00007517          	auipc	a0,0x7
    80202ec6:	c7650513          	addi	a0,a0,-906 # 80209b38 <simple_user_task_bin+0x680>
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
    80202efa:	00007517          	auipc	a0,0x7
    80202efe:	c6650513          	addi	a0,a0,-922 # 80209b60 <simple_user_task_bin+0x6a8>
    80202f02:	ffffe097          	auipc	ra,0xffffe
    80202f06:	d92080e7          	jalr	-622(ra) # 80200c94 <printf>
    printf("[PT TEST] 所有页表测试通过\n");
    80202f0a:	00007517          	auipc	a0,0x7
    80202f0e:	c7650513          	addi	a0,a0,-906 # 80209b80 <simple_user_task_bin+0x6c8>
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
    80202f48:	0000c797          	auipc	a5,0xc
    80202f4c:	14878793          	addi	a5,a5,328 # 8020f090 <kernel_pagetable>
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
    80202f80:	00007517          	auipc	a0,0x7
    80202f84:	c5050513          	addi	a0,a0,-944 # 80209bd0 <simple_user_task_bin+0x718>
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
    80202fac:	00007517          	auipc	a0,0x7
    80202fb0:	c4c50513          	addi	a0,a0,-948 # 80209bf8 <simple_user_task_bin+0x740>
    80202fb4:	ffffe097          	auipc	ra,0xffffe
    80202fb8:	ce0080e7          	jalr	-800(ra) # 80200c94 <printf>
    if(pte && (*pte & PTE_V)) {
    80202fbc:	a821                	j	80202fd4 <check_mapping+0x98>
        printf("Address 0x%lx is NOT mapped\n", va);
    80202fbe:	fd843583          	ld	a1,-40(s0)
    80202fc2:	00007517          	auipc	a0,0x7
    80202fc6:	c5650513          	addi	a0,a0,-938 # 80209c18 <simple_user_task_bin+0x760>
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
    80203022:	00007517          	auipc	a0,0x7
    80203026:	bae50513          	addi	a0,a0,-1106 # 80209bd0 <simple_user_task_bin+0x718>
    8020302a:	ffffe097          	auipc	ra,0xffffe
    8020302e:	c6a080e7          	jalr	-918(ra) # 80200c94 <printf>
        return 1;
    80203032:	4785                	li	a5,1
    80203034:	a821                	j	8020304c <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    80203036:	fd843583          	ld	a1,-40(s0)
    8020303a:	00007517          	auipc	a0,0x7
    8020303e:	bde50513          	addi	a0,a0,-1058 # 80209c18 <simple_user_task_bin+0x760>
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
    80203174:	00007597          	auipc	a1,0x7
    80203178:	fac58593          	addi	a1,a1,-84 # 8020a120 <simple_user_task_bin+0x58>
    8020317c:	00007517          	auipc	a0,0x7
    80203180:	fb450513          	addi	a0,a0,-76 # 8020a130 <simple_user_task_bin+0x68>
    80203184:	ffffe097          	auipc	ra,0xffffe
    80203188:	b10080e7          	jalr	-1264(ra) # 80200c94 <printf>
    8020318c:	00007517          	auipc	a0,0x7
    80203190:	fcc50513          	addi	a0,a0,-52 # 8020a158 <simple_user_task_bin+0x90>
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
    8020320c:	0000c517          	auipc	a0,0xc
    80203210:	4f450513          	addi	a0,a0,1268 # 8020f700 <_bss_end>
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
    8020322e:	0000c797          	auipc	a5,0xc
    80203232:	03278793          	addi	a5,a5,50 # 8020f260 <freelist>
    80203236:	639c                	ld	a5,0(a5)
    80203238:	fef43423          	sd	a5,-24(s0)
  if(r)
    8020323c:	fe843783          	ld	a5,-24(s0)
    80203240:	cb89                	beqz	a5,80203252 <alloc_page+0x2c>
    freelist = r->next;
    80203242:	fe843783          	ld	a5,-24(s0)
    80203246:	6398                	ld	a4,0(a5)
    80203248:	0000c797          	auipc	a5,0xc
    8020324c:	01878793          	addi	a5,a5,24 # 8020f260 <freelist>
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
    80203274:	00007517          	auipc	a0,0x7
    80203278:	eec50513          	addi	a0,a0,-276 # 8020a160 <simple_user_task_bin+0x98>
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
    802032b6:	0000c797          	auipc	a5,0xc
    802032ba:	44a78793          	addi	a5,a5,1098 # 8020f700 <_bss_end>
    802032be:	00f76863          	bltu	a4,a5,802032ce <free_page+0x3c>
    802032c2:	fd843703          	ld	a4,-40(s0)
    802032c6:	47c5                	li	a5,17
    802032c8:	07ee                	slli	a5,a5,0x1b
    802032ca:	00f76a63          	bltu	a4,a5,802032de <free_page+0x4c>
    panic("free_page: invalid page address");
    802032ce:	00007517          	auipc	a0,0x7
    802032d2:	eb250513          	addi	a0,a0,-334 # 8020a180 <simple_user_task_bin+0xb8>
    802032d6:	ffffe097          	auipc	ra,0xffffe
    802032da:	40a080e7          	jalr	1034(ra) # 802016e0 <panic>
  r->next = freelist;
    802032de:	0000c797          	auipc	a5,0xc
    802032e2:	f8278793          	addi	a5,a5,-126 # 8020f260 <freelist>
    802032e6:	6398                	ld	a4,0(a5)
    802032e8:	fe843783          	ld	a5,-24(s0)
    802032ec:	e398                	sd	a4,0(a5)
  freelist = r;
    802032ee:	0000c797          	auipc	a5,0xc
    802032f2:	f7278793          	addi	a5,a5,-142 # 8020f260 <freelist>
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
    8020330e:	00007517          	auipc	a0,0x7
    80203312:	e9250513          	addi	a0,a0,-366 # 8020a1a0 <simple_user_task_bin+0xd8>
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
    802033c2:	00007517          	auipc	a0,0x7
    802033c6:	dfe50513          	addi	a0,a0,-514 # 8020a1c0 <simple_user_task_bin+0xf8>
    802033ca:	ffffe097          	auipc	ra,0xffffe
    802033ce:	8ca080e7          	jalr	-1846(ra) # 80200c94 <printf>
    printf("[PM TEST] 数据写入测试...\n");
    802033d2:	00007517          	auipc	a0,0x7
    802033d6:	e0e50513          	addi	a0,a0,-498 # 8020a1e0 <simple_user_task_bin+0x118>
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
    80203418:	00007517          	auipc	a0,0x7
    8020341c:	df050513          	addi	a0,a0,-528 # 8020a208 <simple_user_task_bin+0x140>
    80203420:	ffffe097          	auipc	ra,0xffffe
    80203424:	874080e7          	jalr	-1932(ra) # 80200c94 <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    80203428:	00007517          	auipc	a0,0x7
    8020342c:	e0850513          	addi	a0,a0,-504 # 8020a230 <simple_user_task_bin+0x168>
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
    80203468:	00007517          	auipc	a0,0x7
    8020346c:	df850513          	addi	a0,a0,-520 # 8020a260 <simple_user_task_bin+0x198>
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
    80203490:	00007517          	auipc	a0,0x7
    80203494:	e0050513          	addi	a0,a0,-512 # 8020a290 <simple_user_task_bin+0x1c8>
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
    802034e6:	0000c797          	auipc	a5,0xc
    802034ea:	bd278793          	addi	a5,a5,-1070 # 8020f0b8 <interrupt_test_flag>
    802034ee:	639c                	ld	a5,0(a5)
    802034f0:	cb99                	beqz	a5,80203506 <timeintr+0x26>
        (*interrupt_test_flag)++;
    802034f2:	0000c797          	auipc	a5,0xc
    802034f6:	bc678793          	addi	a5,a5,-1082 # 8020f0b8 <interrupt_test_flag>
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

    uint64 scause = r_scause();
    uint64 stval  = r_stval();
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存

    8020350e:	1101                	addi	sp,sp,-32
    80203510:	ec22                	sd	s0,24(sp)
    80203512:	1000                	addi	s0,sp,32
    uint64 code = scause & 0xff;
    uint64 is_intr = (scause >> 63);
    80203514:	104027f3          	csrr	a5,sie
    80203518:	fef43423          	sd	a5,-24(s0)

    8020351c:	fe843783          	ld	a5,-24(s0)
    if (!is_intr && code == 8) { // 用户态 ecall
    80203520:	853e                	mv	a0,a5
    80203522:	6462                	ld	s0,24(sp)
    80203524:	6105                	addi	sp,sp,32
    80203526:	8082                	ret

0000000080203528 <w_sie>:
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
        handle_syscall(tf, &info);
    80203528:	1101                	addi	sp,sp,-32
    8020352a:	ec22                	sd	s0,24(sp)
    8020352c:	1000                	addi	s0,sp,32
    8020352e:	fea43423          	sd	a0,-24(s0)
        // handle_syscall 应该已 set_sepc(tf, sepc+4)
    80203532:	fe843783          	ld	a5,-24(s0)
    80203536:	10479073          	csrw	sie,a5
    } else if (is_intr) {
    8020353a:	0001                	nop
    8020353c:	6462                	ld	s0,24(sp)
    8020353e:	6105                	addi	sp,sp,32
    80203540:	8082                	ret

0000000080203542 <r_sstatus>:
        if (code == 5) {
            timeintr();
    80203542:	1101                	addi	sp,sp,-32
    80203544:	ec22                	sd	s0,24(sp)
    80203546:	1000                	addi	s0,sp,32
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
        } else if (code == 9) {
    80203548:	100027f3          	csrr	a5,sstatus
    8020354c:	fef43423          	sd	a5,-24(s0)
            handle_external_interrupt();
    80203550:	fe843783          	ld	a5,-24(s0)
        } else {
    80203554:	853e                	mv	a0,a5
    80203556:	6462                	ld	s0,24(sp)
    80203558:	6105                	addi	sp,sp,32
    8020355a:	8082                	ret

000000008020355c <w_sstatus>:
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    8020355c:	1101                	addi	sp,sp,-32
    8020355e:	ec22                	sd	s0,24(sp)
    80203560:	1000                	addi	s0,sp,32
    80203562:	fea43423          	sd	a0,-24(s0)
        }
    80203566:	fe843783          	ld	a5,-24(s0)
    8020356a:	10079073          	csrw	sstatus,a5
    } else {
    8020356e:	0001                	nop
    80203570:	6462                	ld	s0,24(sp)
    80203572:	6105                	addi	sp,sp,32
    80203574:	8082                	ret

0000000080203576 <w_sscratch>:
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80203576:	1101                	addi	sp,sp,-32
    80203578:	ec22                	sd	s0,24(sp)
    8020357a:	1000                	addi	s0,sp,32
    8020357c:	fea43423          	sd	a0,-24(s0)
        handle_exception(tf, &info);
    80203580:	fe843783          	ld	a5,-24(s0)
    80203584:	14079073          	csrw	sscratch,a5
    }
    80203588:	0001                	nop
    8020358a:	6462                	ld	s0,24(sp)
    8020358c:	6105                	addi	sp,sp,32
    8020358e:	8082                	ret

0000000080203590 <w_sepc>:

    usertrapret();
    80203590:	1101                	addi	sp,sp,-32
    80203592:	ec22                	sd	s0,24(sp)
    80203594:	1000                	addi	s0,sp,32
    80203596:	fea43423          	sd	a0,-24(s0)
}
    8020359a:	fe843783          	ld	a5,-24(s0)
    8020359e:	14179073          	csrw	sepc,a5

    802035a2:	0001                	nop
    802035a4:	6462                	ld	s0,24(sp)
    802035a6:	6105                	addi	sp,sp,32
    802035a8:	8082                	ret

00000000802035aa <intr_off>:
void usertrapret(void) {
    struct proc *p = myproc();

    // 计算 trampoline 中 uservec 的虚拟地址（对双方页表一致）
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    w_stvec(uservec_va);
    802035aa:	1141                	addi	sp,sp,-16
    802035ac:	e406                	sd	ra,8(sp)
    802035ae:	e022                	sd	s0,0(sp)
    802035b0:	0800                	addi	s0,sp,16

    802035b2:	00000097          	auipc	ra,0x0
    802035b6:	f90080e7          	jalr	-112(ra) # 80203542 <r_sstatus>
    802035ba:	87aa                	mv	a5,a0
    802035bc:	9bf5                	andi	a5,a5,-3
    802035be:	853e                	mv	a0,a5
    802035c0:	00000097          	auipc	ra,0x0
    802035c4:	f9c080e7          	jalr	-100(ra) # 8020355c <w_sstatus>
    // sscratch 设为 TRAPFRAME 的虚拟地址（trampoline 代码用它访问 tf）
    802035c8:	0001                	nop
    802035ca:	60a2                	ld	ra,8(sp)
    802035cc:	6402                	ld	s0,0(sp)
    802035ce:	0141                	addi	sp,sp,16
    802035d0:	8082                	ret

00000000802035d2 <w_stvec>:
    w_sscratch((uint64)TRAPFRAME);

    802035d2:	1101                	addi	sp,sp,-32
    802035d4:	ec22                	sd	s0,24(sp)
    802035d6:	1000                	addi	s0,sp,32
    802035d8:	fea43423          	sd	a0,-24(s0)
    // 准备用户页表的 satp
    802035dc:	fe843783          	ld	a5,-24(s0)
    802035e0:	10579073          	csrw	stvec,a5
    uint64 user_satp = MAKE_SATP(p->pagetable);
    802035e4:	0001                	nop
    802035e6:	6462                	ld	s0,24(sp)
    802035e8:	6105                	addi	sp,sp,32
    802035ea:	8082                	ret

00000000802035ec <r_scause>:
    uint64 userret_va = (uint64)TRAMPOLINE + ((uint64)userret - (uint64)trampoline);

    // a0 = TRAPFRAME（虚拟地址，双方页表都映射）
    // a1 = user_satp
    register uint64 a0 asm("a0") = (uint64)TRAPFRAME;
    register uint64 a1 asm("a1") = user_satp;
    802035ec:	1101                	addi	sp,sp,-32
    802035ee:	ec22                	sd	s0,24(sp)
    802035f0:	1000                	addi	s0,sp,32
    register void (*tgt)(uint64, uint64) asm("t0") = (void *)userret_va;

    802035f2:	142027f3          	csrr	a5,scause
    802035f6:	fef43423          	sd	a5,-24(s0)
    // 跳到 trampoline 上的 userret
    802035fa:	fe843783          	ld	a5,-24(s0)
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(tgt) : "memory");
    802035fe:	853e                	mv	a0,a5
    80203600:	6462                	ld	s0,24(sp)
    80203602:	6105                	addi	sp,sp,32
    80203604:	8082                	ret

0000000080203606 <r_sepc>:
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
    802036c8:	0000c717          	auipc	a4,0xc
    802036cc:	ba070713          	addi	a4,a4,-1120 # 8020f268 <interrupt_vector>
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
    8020370c:	0000c717          	auipc	a4,0xc
    80203710:	b5c70713          	addi	a4,a4,-1188 # 8020f268 <interrupt_vector>
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
    80203740:	dd2080e7          	jalr	-558(ra) # 8020450e <plic_enable>
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
    80203766:	e04080e7          	jalr	-508(ra) # 80204566 <plic_disable>
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
    8020379c:	0000c717          	auipc	a4,0xc
    802037a0:	acc70713          	addi	a4,a4,-1332 # 8020f268 <interrupt_vector>
    802037a4:	fec42783          	lw	a5,-20(s0)
    802037a8:	078e                	slli	a5,a5,0x3
    802037aa:	97ba                	add	a5,a5,a4
    802037ac:	639c                	ld	a5,0(a5)
    802037ae:	cb99                	beqz	a5,802037c4 <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    802037b0:	0000c717          	auipc	a4,0xc
    802037b4:	ab870713          	addi	a4,a4,-1352 # 8020f268 <interrupt_vector>
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
    802037da:	dee080e7          	jalr	-530(ra) # 802045c4 <plic_claim>
    802037de:	87aa                	mv	a5,a0
    802037e0:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    802037e4:	fec42783          	lw	a5,-20(s0)
    802037e8:	2781                	sext.w	a5,a5
    802037ea:	eb91                	bnez	a5,802037fe <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    802037ec:	00008517          	auipc	a0,0x8
    802037f0:	98c50513          	addi	a0,a0,-1652 # 8020b178 <simple_user_task_bin+0x58>
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
    80203816:	dda080e7          	jalr	-550(ra) # 802045ec <plic_complete>
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
    80203832:	00008517          	auipc	a0,0x8
    80203836:	96650513          	addi	a0,a0,-1690 # 8020b198 <simple_user_task_bin+0x78>
    8020383a:	ffffd097          	auipc	ra,0xffffd
    8020383e:	45a080e7          	jalr	1114(ra) # 80200c94 <printf>
	w_stvec((uint64)kernelvec);
    80203842:	00001797          	auipc	a5,0x1
    80203846:	dde78793          	addi	a5,a5,-546 # 80204620 <kernelvec>
    8020384a:	853e                	mv	a0,a5
    8020384c:	00000097          	auipc	ra,0x0
    80203850:	d86080e7          	jalr	-634(ra) # 802035d2 <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    80203854:	fe042623          	sw	zero,-20(s0)
    80203858:	a005                	j	80203878 <trap_init+0x56>
		interrupt_vector[i] = 0;
    8020385a:	0000c717          	auipc	a4,0xc
    8020385e:	a0e70713          	addi	a4,a4,-1522 # 8020f268 <interrupt_vector>
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
    8020388c:	be8080e7          	jalr	-1048(ra) # 80204470 <plic_init>
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
    802038d0:	8d458593          	addi	a1,a1,-1836 # 802041a0 <handle_store_page_fault>
    802038d4:	00008517          	auipc	a0,0x8
    802038d8:	8d450513          	addi	a0,a0,-1836 # 8020b1a8 <simple_user_task_bin+0x88>
    802038dc:	ffffd097          	auipc	ra,0xffffd
    802038e0:	3b8080e7          	jalr	952(ra) # 80200c94 <printf>
	printf("trap_init complete.\n");
    802038e4:	00008517          	auipc	a0,0x8
    802038e8:	8fc50513          	addi	a0,a0,-1796 # 8020b1e0 <simple_user_task_bin+0xc0>
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
    80203994:	00008517          	auipc	a0,0x8
    80203998:	86450513          	addi	a0,a0,-1948 # 8020b1f8 <simple_user_task_bin+0xd8>
    8020399c:	ffffd097          	auipc	ra,0xffffd
    802039a0:	2f8080e7          	jalr	760(ra) # 80200c94 <printf>
    802039a4:	a049                	j	80203a26 <kerneltrap+0x128>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    802039a6:	fd043683          	ld	a3,-48(s0)
    802039aa:	fe843603          	ld	a2,-24(s0)
    802039ae:	fd843583          	ld	a1,-40(s0)
    802039b2:	00008517          	auipc	a0,0x8
    802039b6:	87e50513          	addi	a0,a0,-1922 # 8020b230 <simple_user_task_bin+0x110>
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
    80203a74:	00008797          	auipc	a5,0x8
    80203a78:	97878793          	addi	a5,a5,-1672 # 8020b3ec <simple_user_task_bin+0x2cc>
    80203a7c:	97ba                	add	a5,a5,a4
    80203a7e:	439c                	lw	a5,0(a5)
    80203a80:	0007871b          	sext.w	a4,a5
    80203a84:	00008797          	auipc	a5,0x8
    80203a88:	96878793          	addi	a5,a5,-1688 # 8020b3ec <simple_user_task_bin+0x2cc>
    80203a8c:	97ba                	add	a5,a5,a4
    80203a8e:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80203a90:	fd043783          	ld	a5,-48(s0)
    80203a94:	6f9c                	ld	a5,24(a5)
    80203a96:	85be                	mv	a1,a5
    80203a98:	00007517          	auipc	a0,0x7
    80203a9c:	7c850513          	addi	a0,a0,1992 # 8020b260 <simple_user_task_bin+0x140>
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
    80203ac8:	00007517          	auipc	a0,0x7
    80203acc:	7c050513          	addi	a0,a0,1984 # 8020b288 <simple_user_task_bin+0x168>
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
    80203b00:	00007517          	auipc	a0,0x7
    80203b04:	7b050513          	addi	a0,a0,1968 # 8020b2b0 <simple_user_task_bin+0x190>
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
    80203b30:	00007517          	auipc	a0,0x7
    80203b34:	7a850513          	addi	a0,a0,1960 # 8020b2d8 <simple_user_task_bin+0x1b8>
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
    80203b60:	00007517          	auipc	a0,0x7
    80203b64:	79050513          	addi	a0,a0,1936 # 8020b2f0 <simple_user_task_bin+0x1d0>
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
    80203b90:	00007517          	auipc	a0,0x7
    80203b94:	78050513          	addi	a0,a0,1920 # 8020b310 <simple_user_task_bin+0x1f0>
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
    80203bec:	00007517          	auipc	a0,0x7
    80203bf0:	74450513          	addi	a0,a0,1860 # 8020b330 <simple_user_task_bin+0x210>
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
    80203c1c:	00007517          	auipc	a0,0x7
    80203c20:	73c50513          	addi	a0,a0,1852 # 8020b358 <simple_user_task_bin+0x238>
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
    80203c88:	00007517          	auipc	a0,0x7
    80203c8c:	6f050513          	addi	a0,a0,1776 # 8020b378 <simple_user_task_bin+0x258>
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
    80203cbc:	424080e7          	jalr	1060(ra) # 802040dc <handle_instruction_page_fault>
            break;
    80203cc0:	a08d                	j	80203d22 <handle_exception+0x2da>
            handle_load_page_fault(tf,info);
    80203cc2:	fd043583          	ld	a1,-48(s0)
    80203cc6:	fd843503          	ld	a0,-40(s0)
    80203cca:	00000097          	auipc	ra,0x0
    80203cce:	474080e7          	jalr	1140(ra) # 8020413e <handle_load_page_fault>
            break;
    80203cd2:	a881                	j	80203d22 <handle_exception+0x2da>
            handle_store_page_fault(tf,info);
    80203cd4:	fd043583          	ld	a1,-48(s0)
    80203cd8:	fd843503          	ld	a0,-40(s0)
    80203cdc:	00000097          	auipc	ra,0x0
    80203ce0:	4c4080e7          	jalr	1220(ra) # 802041a0 <handle_store_page_fault>
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
    80203cfa:	00007517          	auipc	a0,0x7
    80203cfe:	6a650513          	addi	a0,a0,1702 # 8020b3a0 <simple_user_task_bin+0x280>
    80203d02:	ffffd097          	auipc	ra,0xffffd
    80203d06:	f92080e7          	jalr	-110(ra) # 80200c94 <printf>
            panic("Unknown exception");
    80203d0a:	00007517          	auipc	a0,0x7
    80203d0e:	6ce50513          	addi	a0,a0,1742 # 8020b3d8 <simple_user_task_bin+0x2b8>
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
    80203db8:	b9c080e7          	jalr	-1124(ra) # 80204950 <myproc>
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
	switch (tf->a7) {
    80203eec:	f5843783          	ld	a5,-168(s0)
    80203ef0:	7bdc                	ld	a5,176(a5)
    80203ef2:	6705                	lui	a4,0x1
    80203ef4:	177d                	addi	a4,a4,-1 # fff <_entry-0x801ff001>
    80203ef6:	18e78563          	beq	a5,a4,80204080 <handle_syscall+0x1a4>
    80203efa:	6705                	lui	a4,0x1
    80203efc:	18e7ff63          	bgeu	a5,a4,8020409a <handle_syscall+0x1be>
    80203f00:	0dd00713          	li	a4,221
    80203f04:	12e78363          	beq	a5,a4,8020402a <handle_syscall+0x14e>
    80203f08:	0dd00713          	li	a4,221
    80203f0c:	18f76763          	bltu	a4,a5,8020409a <handle_syscall+0x1be>
    80203f10:	0dc00713          	li	a4,220
    80203f14:	0ee78363          	beq	a5,a4,80203ffa <handle_syscall+0x11e>
    80203f18:	0dc00713          	li	a4,220
    80203f1c:	16f76f63          	bltu	a4,a5,8020409a <handle_syscall+0x1be>
    80203f20:	0ad00713          	li	a4,173
    80203f24:	12e78963          	beq	a5,a4,80204056 <handle_syscall+0x17a>
    80203f28:	0ad00713          	li	a4,173
    80203f2c:	16f76763          	bltu	a4,a5,8020409a <handle_syscall+0x1be>
    80203f30:	0ac00713          	li	a4,172
    80203f34:	10e78663          	beq	a5,a4,80204040 <handle_syscall+0x164>
    80203f38:	0ac00713          	li	a4,172
    80203f3c:	14f76f63          	bltu	a4,a5,8020409a <handle_syscall+0x1be>
    80203f40:	05d00713          	li	a4,93
    80203f44:	08e78563          	beq	a5,a4,80203fce <handle_syscall+0xf2>
    80203f48:	05d00713          	li	a4,93
    80203f4c:	14f76763          	bltu	a4,a5,8020409a <handle_syscall+0x1be>
    80203f50:	4705                	li	a4,1
    80203f52:	00e78663          	beq	a5,a4,80203f5e <handle_syscall+0x82>
    80203f56:	4709                	li	a4,2
    80203f58:	02e78063          	beq	a5,a4,80203f78 <handle_syscall+0x9c>
    80203f5c:	aa3d                	j	8020409a <handle_syscall+0x1be>
			printf("[syscall] print int: %ld\n", tf->a0);
    80203f5e:	f5843783          	ld	a5,-168(s0)
    80203f62:	7fbc                	ld	a5,120(a5)
    80203f64:	85be                	mv	a1,a5
    80203f66:	00007517          	auipc	a0,0x7
    80203f6a:	4ca50513          	addi	a0,a0,1226 # 8020b430 <simple_user_task_bin+0x310>
    80203f6e:	ffffd097          	auipc	ra,0xffffd
    80203f72:	d26080e7          	jalr	-730(ra) # 80200c94 <printf>
			break;
    80203f76:	a299                	j	802040bc <handle_syscall+0x1e0>
			if (copyinstr(buf, myproc()->pagetable, tf->a0, sizeof(buf)) < 0) {
    80203f78:	00001097          	auipc	ra,0x1
    80203f7c:	9d8080e7          	jalr	-1576(ra) # 80204950 <myproc>
    80203f80:	87aa                	mv	a5,a0
    80203f82:	7fd8                	ld	a4,184(a5)
    80203f84:	f5843783          	ld	a5,-168(s0)
    80203f88:	7fb0                	ld	a2,120(a5)
    80203f8a:	f6840793          	addi	a5,s0,-152
    80203f8e:	08000693          	li	a3,128
    80203f92:	85ba                	mv	a1,a4
    80203f94:	853e                	mv	a0,a5
    80203f96:	00000097          	auipc	ra,0x0
    80203f9a:	eac080e7          	jalr	-340(ra) # 80203e42 <copyinstr>
    80203f9e:	87aa                	mv	a5,a0
    80203fa0:	0007db63          	bgez	a5,80203fb6 <handle_syscall+0xda>
				printf("[syscall] invalid string\n");
    80203fa4:	00007517          	auipc	a0,0x7
    80203fa8:	4ac50513          	addi	a0,a0,1196 # 8020b450 <simple_user_task_bin+0x330>
    80203fac:	ffffd097          	auipc	ra,0xffffd
    80203fb0:	ce8080e7          	jalr	-792(ra) # 80200c94 <printf>
				break;
    80203fb4:	a221                	j	802040bc <handle_syscall+0x1e0>
			printf("[syscall] print str: %s\n", buf);
    80203fb6:	f6840793          	addi	a5,s0,-152
    80203fba:	85be                	mv	a1,a5
    80203fbc:	00007517          	auipc	a0,0x7
    80203fc0:	4b450513          	addi	a0,a0,1204 # 8020b470 <simple_user_task_bin+0x350>
    80203fc4:	ffffd097          	auipc	ra,0xffffd
    80203fc8:	cd0080e7          	jalr	-816(ra) # 80200c94 <printf>
			break;
    80203fcc:	a8c5                	j	802040bc <handle_syscall+0x1e0>
			printf("[syscall] exit(%ld)\n", tf->a0);
    80203fce:	f5843783          	ld	a5,-168(s0)
    80203fd2:	7fbc                	ld	a5,120(a5)
    80203fd4:	85be                	mv	a1,a5
    80203fd6:	00007517          	auipc	a0,0x7
    80203fda:	4ba50513          	addi	a0,a0,1210 # 8020b490 <simple_user_task_bin+0x370>
    80203fde:	ffffd097          	auipc	ra,0xffffd
    80203fe2:	cb6080e7          	jalr	-842(ra) # 80200c94 <printf>
			exit_proc((int)tf->a0);
    80203fe6:	f5843783          	ld	a5,-168(s0)
    80203fea:	7fbc                	ld	a5,120(a5)
    80203fec:	2781                	sext.w	a5,a5
    80203fee:	853e                	mv	a0,a5
    80203ff0:	00001097          	auipc	ra,0x1
    80203ff4:	62c080e7          	jalr	1580(ra) # 8020561c <exit_proc>
			break;
    80203ff8:	a0d1                	j	802040bc <handle_syscall+0x1e0>
			int child_pid = fork_proc();
    80203ffa:	00001097          	auipc	ra,0x1
    80203ffe:	1ba080e7          	jalr	442(ra) # 802051b4 <fork_proc>
    80204002:	87aa                	mv	a5,a0
    80204004:	fef42623          	sw	a5,-20(s0)
			tf->a0 = child_pid;
    80204008:	fec42703          	lw	a4,-20(s0)
    8020400c:	f5843783          	ld	a5,-168(s0)
    80204010:	ffb8                	sd	a4,120(a5)
			printf("[syscall] fork -> %d\n", child_pid);
    80204012:	fec42783          	lw	a5,-20(s0)
    80204016:	85be                	mv	a1,a5
    80204018:	00007517          	auipc	a0,0x7
    8020401c:	49050513          	addi	a0,a0,1168 # 8020b4a8 <simple_user_task_bin+0x388>
    80204020:	ffffd097          	auipc	ra,0xffffd
    80204024:	c74080e7          	jalr	-908(ra) # 80200c94 <printf>
			break;
    80204028:	a851                	j	802040bc <handle_syscall+0x1e0>
			tf->a0 = wait_proc(NULL);
    8020402a:	4501                	li	a0,0
    8020402c:	00001097          	auipc	ra,0x1
    80204030:	6ba080e7          	jalr	1722(ra) # 802056e6 <wait_proc>
    80204034:	87aa                	mv	a5,a0
    80204036:	873e                	mv	a4,a5
    80204038:	f5843783          	ld	a5,-168(s0)
    8020403c:	ffb8                	sd	a4,120(a5)
			break;
    8020403e:	a8bd                	j	802040bc <handle_syscall+0x1e0>
			tf->a0 = myproc()->pid;
    80204040:	00001097          	auipc	ra,0x1
    80204044:	910080e7          	jalr	-1776(ra) # 80204950 <myproc>
    80204048:	87aa                	mv	a5,a0
    8020404a:	43dc                	lw	a5,4(a5)
    8020404c:	873e                	mv	a4,a5
    8020404e:	f5843783          	ld	a5,-168(s0)
    80204052:	ffb8                	sd	a4,120(a5)
			break;
    80204054:	a0a5                	j	802040bc <handle_syscall+0x1e0>
			tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
    80204056:	00001097          	auipc	ra,0x1
    8020405a:	8fa080e7          	jalr	-1798(ra) # 80204950 <myproc>
    8020405e:	87aa                	mv	a5,a0
    80204060:	6fdc                	ld	a5,152(a5)
    80204062:	cb91                	beqz	a5,80204076 <handle_syscall+0x19a>
    80204064:	00001097          	auipc	ra,0x1
    80204068:	8ec080e7          	jalr	-1812(ra) # 80204950 <myproc>
    8020406c:	87aa                	mv	a5,a0
    8020406e:	6fdc                	ld	a5,152(a5)
    80204070:	43dc                	lw	a5,4(a5)
    80204072:	873e                	mv	a4,a5
    80204074:	a011                	j	80204078 <handle_syscall+0x19c>
    80204076:	4701                	li	a4,0
    80204078:	f5843783          	ld	a5,-168(s0)
    8020407c:	ffb8                	sd	a4,120(a5)
			break;
    8020407e:	a83d                	j	802040bc <handle_syscall+0x1e0>
			tf->a0 = 0;
    80204080:	f5843783          	ld	a5,-168(s0)
    80204084:	0607bc23          	sd	zero,120(a5)
			printf("[syscall] step enabled but do nothing\n");
    80204088:	00007517          	auipc	a0,0x7
    8020408c:	43850513          	addi	a0,a0,1080 # 8020b4c0 <simple_user_task_bin+0x3a0>
    80204090:	ffffd097          	auipc	ra,0xffffd
    80204094:	c04080e7          	jalr	-1020(ra) # 80200c94 <printf>
			break;
    80204098:	a015                	j	802040bc <handle_syscall+0x1e0>
			printf("[syscall] unknown syscall: %ld\n", tf->a7);
    8020409a:	f5843783          	ld	a5,-168(s0)
    8020409e:	7bdc                	ld	a5,176(a5)
    802040a0:	85be                	mv	a1,a5
    802040a2:	00007517          	auipc	a0,0x7
    802040a6:	44650513          	addi	a0,a0,1094 # 8020b4e8 <simple_user_task_bin+0x3c8>
    802040aa:	ffffd097          	auipc	ra,0xffffd
    802040ae:	bea080e7          	jalr	-1046(ra) # 80200c94 <printf>
			tf->a0 = -1;
    802040b2:	f5843783          	ld	a5,-168(s0)
    802040b6:	577d                	li	a4,-1
    802040b8:	ffb8                	sd	a4,120(a5)
			break;
    802040ba:	0001                	nop
	set_sepc(tf, info->sepc + 4);
    802040bc:	f5043783          	ld	a5,-176(s0)
    802040c0:	639c                	ld	a5,0(a5)
    802040c2:	0791                	addi	a5,a5,4
    802040c4:	85be                	mv	a1,a5
    802040c6:	f5843503          	ld	a0,-168(s0)
    802040ca:	fffff097          	auipc	ra,0xfffff
    802040ce:	5b4080e7          	jalr	1460(ra) # 8020367e <set_sepc>
}
    802040d2:	0001                	nop
    802040d4:	70aa                	ld	ra,168(sp)
    802040d6:	740a                	ld	s0,160(sp)
    802040d8:	614d                	addi	sp,sp,176
    802040da:	8082                	ret

00000000802040dc <handle_instruction_page_fault>:
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    802040dc:	1101                	addi	sp,sp,-32
    802040de:	ec06                	sd	ra,24(sp)
    802040e0:	e822                	sd	s0,16(sp)
    802040e2:	1000                	addi	s0,sp,32
    802040e4:	fea43423          	sd	a0,-24(s0)
    802040e8:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802040ec:	fe043783          	ld	a5,-32(s0)
    802040f0:	6f98                	ld	a4,24(a5)
    802040f2:	fe043783          	ld	a5,-32(s0)
    802040f6:	639c                	ld	a5,0(a5)
    802040f8:	863e                	mv	a2,a5
    802040fa:	85ba                	mv	a1,a4
    802040fc:	00007517          	auipc	a0,0x7
    80204100:	40c50513          	addi	a0,a0,1036 # 8020b508 <simple_user_task_bin+0x3e8>
    80204104:	ffffd097          	auipc	ra,0xffffd
    80204108:	b90080e7          	jalr	-1136(ra) # 80200c94 <printf>
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    8020410c:	fe043783          	ld	a5,-32(s0)
    80204110:	6f9c                	ld	a5,24(a5)
    80204112:	4585                	li	a1,1
    80204114:	853e                	mv	a0,a5
    80204116:	fffff097          	auipc	ra,0xfffff
    8020411a:	86c080e7          	jalr	-1940(ra) # 80202982 <handle_page_fault>
    8020411e:	87aa                	mv	a5,a0
    80204120:	eb91                	bnez	a5,80204134 <handle_instruction_page_fault+0x58>
    panic("Unhandled instruction page fault");
    80204122:	00007517          	auipc	a0,0x7
    80204126:	41650513          	addi	a0,a0,1046 # 8020b538 <simple_user_task_bin+0x418>
    8020412a:	ffffd097          	auipc	ra,0xffffd
    8020412e:	5b6080e7          	jalr	1462(ra) # 802016e0 <panic>
    80204132:	a011                	j	80204136 <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80204134:	0001                	nop
}
    80204136:	60e2                	ld	ra,24(sp)
    80204138:	6442                	ld	s0,16(sp)
    8020413a:	6105                	addi	sp,sp,32
    8020413c:	8082                	ret

000000008020413e <handle_load_page_fault>:
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    8020413e:	1101                	addi	sp,sp,-32
    80204140:	ec06                	sd	ra,24(sp)
    80204142:	e822                	sd	s0,16(sp)
    80204144:	1000                	addi	s0,sp,32
    80204146:	fea43423          	sd	a0,-24(s0)
    8020414a:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    8020414e:	fe043783          	ld	a5,-32(s0)
    80204152:	6f98                	ld	a4,24(a5)
    80204154:	fe043783          	ld	a5,-32(s0)
    80204158:	639c                	ld	a5,0(a5)
    8020415a:	863e                	mv	a2,a5
    8020415c:	85ba                	mv	a1,a4
    8020415e:	00007517          	auipc	a0,0x7
    80204162:	40250513          	addi	a0,a0,1026 # 8020b560 <simple_user_task_bin+0x440>
    80204166:	ffffd097          	auipc	ra,0xffffd
    8020416a:	b2e080e7          	jalr	-1234(ra) # 80200c94 <printf>
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    8020416e:	fe043783          	ld	a5,-32(s0)
    80204172:	6f9c                	ld	a5,24(a5)
    80204174:	4589                	li	a1,2
    80204176:	853e                	mv	a0,a5
    80204178:	fffff097          	auipc	ra,0xfffff
    8020417c:	80a080e7          	jalr	-2038(ra) # 80202982 <handle_page_fault>
    80204180:	87aa                	mv	a5,a0
    80204182:	eb91                	bnez	a5,80204196 <handle_load_page_fault+0x58>
    panic("Unhandled load page fault");
    80204184:	00007517          	auipc	a0,0x7
    80204188:	40c50513          	addi	a0,a0,1036 # 8020b590 <simple_user_task_bin+0x470>
    8020418c:	ffffd097          	auipc	ra,0xffffd
    80204190:	554080e7          	jalr	1364(ra) # 802016e0 <panic>
    80204194:	a011                	j	80204198 <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80204196:	0001                	nop
}
    80204198:	60e2                	ld	ra,24(sp)
    8020419a:	6442                	ld	s0,16(sp)
    8020419c:	6105                	addi	sp,sp,32
    8020419e:	8082                	ret

00000000802041a0 <handle_store_page_fault>:
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    802041a0:	1101                	addi	sp,sp,-32
    802041a2:	ec06                	sd	ra,24(sp)
    802041a4:	e822                	sd	s0,16(sp)
    802041a6:	1000                	addi	s0,sp,32
    802041a8:	fea43423          	sd	a0,-24(s0)
    802041ac:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802041b0:	fe043783          	ld	a5,-32(s0)
    802041b4:	6f98                	ld	a4,24(a5)
    802041b6:	fe043783          	ld	a5,-32(s0)
    802041ba:	639c                	ld	a5,0(a5)
    802041bc:	863e                	mv	a2,a5
    802041be:	85ba                	mv	a1,a4
    802041c0:	00007517          	auipc	a0,0x7
    802041c4:	3f050513          	addi	a0,a0,1008 # 8020b5b0 <simple_user_task_bin+0x490>
    802041c8:	ffffd097          	auipc	ra,0xffffd
    802041cc:	acc080e7          	jalr	-1332(ra) # 80200c94 <printf>
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    802041d0:	fe043783          	ld	a5,-32(s0)
    802041d4:	6f9c                	ld	a5,24(a5)
    802041d6:	458d                	li	a1,3
    802041d8:	853e                	mv	a0,a5
    802041da:	ffffe097          	auipc	ra,0xffffe
    802041de:	7a8080e7          	jalr	1960(ra) # 80202982 <handle_page_fault>
    802041e2:	87aa                	mv	a5,a0
    802041e4:	eb91                	bnez	a5,802041f8 <handle_store_page_fault+0x58>
    panic("Unhandled store page fault");
    802041e6:	00007517          	auipc	a0,0x7
    802041ea:	3fa50513          	addi	a0,a0,1018 # 8020b5e0 <simple_user_task_bin+0x4c0>
    802041ee:	ffffd097          	auipc	ra,0xffffd
    802041f2:	4f2080e7          	jalr	1266(ra) # 802016e0 <panic>
    802041f6:	a011                	j	802041fa <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802041f8:	0001                	nop
}
    802041fa:	60e2                	ld	ra,24(sp)
    802041fc:	6442                	ld	s0,16(sp)
    802041fe:	6105                	addi	sp,sp,32
    80204200:	8082                	ret

0000000080204202 <usertrap>:
void usertrap(void) {
    80204202:	7159                	addi	sp,sp,-112
    80204204:	f486                	sd	ra,104(sp)
    80204206:	f0a2                	sd	s0,96(sp)
    80204208:	1880                	addi	s0,sp,112
    struct proc *p = myproc();
    8020420a:	00000097          	auipc	ra,0x0
    8020420e:	746080e7          	jalr	1862(ra) # 80204950 <myproc>
    80204212:	fea43423          	sd	a0,-24(s0)
    struct trapframe *tf = p->trapframe;
    80204216:	fe843783          	ld	a5,-24(s0)
    8020421a:	63fc                	ld	a5,192(a5)
    8020421c:	fef43023          	sd	a5,-32(s0)
    uint64 scause = r_scause();
    80204220:	fffff097          	auipc	ra,0xfffff
    80204224:	3cc080e7          	jalr	972(ra) # 802035ec <r_scause>
    80204228:	fca43c23          	sd	a0,-40(s0)
    uint64 stval  = r_stval();
    8020422c:	fffff097          	auipc	ra,0xfffff
    80204230:	3f4080e7          	jalr	1012(ra) # 80203620 <r_stval>
    80204234:	fca43823          	sd	a0,-48(s0)
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    80204238:	fe043783          	ld	a5,-32(s0)
    8020423c:	739c                	ld	a5,32(a5)
    8020423e:	fcf43423          	sd	a5,-56(s0)
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存
    80204242:	fe043783          	ld	a5,-32(s0)
    80204246:	6f9c                	ld	a5,24(a5)
    80204248:	fcf43023          	sd	a5,-64(s0)
    uint64 code = scause & 0xff;
    8020424c:	fd843783          	ld	a5,-40(s0)
    80204250:	0ff7f793          	zext.b	a5,a5
    80204254:	faf43c23          	sd	a5,-72(s0)
    uint64 is_intr = (scause >> 63);
    80204258:	fd843783          	ld	a5,-40(s0)
    8020425c:	93fd                	srli	a5,a5,0x3f
    8020425e:	faf43823          	sd	a5,-80(s0)
    if (!is_intr && code == 8) { // 用户态 ecall
    80204262:	fb043783          	ld	a5,-80(s0)
    80204266:	e3a1                	bnez	a5,802042a6 <usertrap+0xa4>
    80204268:	fb843703          	ld	a4,-72(s0)
    8020426c:	47a1                	li	a5,8
    8020426e:	02f71c63          	bne	a4,a5,802042a6 <usertrap+0xa4>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80204272:	fc843783          	ld	a5,-56(s0)
    80204276:	f8f43823          	sd	a5,-112(s0)
    8020427a:	fc043783          	ld	a5,-64(s0)
    8020427e:	f8f43c23          	sd	a5,-104(s0)
    80204282:	fd843783          	ld	a5,-40(s0)
    80204286:	faf43023          	sd	a5,-96(s0)
    8020428a:	fd043783          	ld	a5,-48(s0)
    8020428e:	faf43423          	sd	a5,-88(s0)
        handle_syscall(tf, &info);
    80204292:	f9040793          	addi	a5,s0,-112
    80204296:	85be                	mv	a1,a5
    80204298:	fe043503          	ld	a0,-32(s0)
    8020429c:	00000097          	auipc	ra,0x0
    802042a0:	c40080e7          	jalr	-960(ra) # 80203edc <handle_syscall>
    if (!is_intr && code == 8) { // 用户态 ecall
    802042a4:	a869                	j	8020433e <usertrap+0x13c>
    } else if (is_intr) {
    802042a6:	fb043783          	ld	a5,-80(s0)
    802042aa:	c3ad                	beqz	a5,8020430c <usertrap+0x10a>
        if (code == 5) {
    802042ac:	fb843703          	ld	a4,-72(s0)
    802042b0:	4795                	li	a5,5
    802042b2:	02f71663          	bne	a4,a5,802042de <usertrap+0xdc>
            timeintr();
    802042b6:	fffff097          	auipc	ra,0xfffff
    802042ba:	22a080e7          	jalr	554(ra) # 802034e0 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802042be:	fffff097          	auipc	ra,0xfffff
    802042c2:	208080e7          	jalr	520(ra) # 802034c6 <sbi_get_time>
    802042c6:	872a                	mv	a4,a0
    802042c8:	000f47b7          	lui	a5,0xf4
    802042cc:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802042d0:	97ba                	add	a5,a5,a4
    802042d2:	853e                	mv	a0,a5
    802042d4:	fffff097          	auipc	ra,0xfffff
    802042d8:	1d6080e7          	jalr	470(ra) # 802034aa <sbi_set_time>
    802042dc:	a08d                	j	8020433e <usertrap+0x13c>
        } else if (code == 9) {
    802042de:	fb843703          	ld	a4,-72(s0)
    802042e2:	47a5                	li	a5,9
    802042e4:	00f71763          	bne	a4,a5,802042f2 <usertrap+0xf0>
            handle_external_interrupt();
    802042e8:	fffff097          	auipc	ra,0xfffff
    802042ec:	4e6080e7          	jalr	1254(ra) # 802037ce <handle_external_interrupt>
    802042f0:	a0b9                	j	8020433e <usertrap+0x13c>
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    802042f2:	fc843603          	ld	a2,-56(s0)
    802042f6:	fd843583          	ld	a1,-40(s0)
    802042fa:	00007517          	auipc	a0,0x7
    802042fe:	30650513          	addi	a0,a0,774 # 8020b600 <simple_user_task_bin+0x4e0>
    80204302:	ffffd097          	auipc	ra,0xffffd
    80204306:	992080e7          	jalr	-1646(ra) # 80200c94 <printf>
    8020430a:	a815                	j	8020433e <usertrap+0x13c>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    8020430c:	fc843783          	ld	a5,-56(s0)
    80204310:	f8f43823          	sd	a5,-112(s0)
    80204314:	fc043783          	ld	a5,-64(s0)
    80204318:	f8f43c23          	sd	a5,-104(s0)
    8020431c:	fd843783          	ld	a5,-40(s0)
    80204320:	faf43023          	sd	a5,-96(s0)
    80204324:	fd043783          	ld	a5,-48(s0)
    80204328:	faf43423          	sd	a5,-88(s0)
        handle_exception(tf, &info);
    8020432c:	f9040793          	addi	a5,s0,-112
    80204330:	85be                	mv	a1,a5
    80204332:	fe043503          	ld	a0,-32(s0)
    80204336:	fffff097          	auipc	ra,0xfffff
    8020433a:	712080e7          	jalr	1810(ra) # 80203a48 <handle_exception>
    usertrapret();
    8020433e:	00000097          	auipc	ra,0x0
    80204342:	012080e7          	jalr	18(ra) # 80204350 <usertrapret>
}
    80204346:	0001                	nop
    80204348:	70a6                	ld	ra,104(sp)
    8020434a:	7406                	ld	s0,96(sp)
    8020434c:	6165                	addi	sp,sp,112
    8020434e:	8082                	ret

0000000080204350 <usertrapret>:
void usertrapret(void) {
    80204350:	7179                	addi	sp,sp,-48
    80204352:	f406                	sd	ra,40(sp)
    80204354:	f022                	sd	s0,32(sp)
    80204356:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80204358:	00000097          	auipc	ra,0x0
    8020435c:	5f8080e7          	jalr	1528(ra) # 80204950 <myproc>
    80204360:	fea43423          	sd	a0,-24(s0)
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    80204364:	00000717          	auipc	a4,0x0
    80204368:	34c70713          	addi	a4,a4,844 # 802046b0 <trampoline>
    8020436c:	77fd                	lui	a5,0xfffff
    8020436e:	973e                	add	a4,a4,a5
    80204370:	00000797          	auipc	a5,0x0
    80204374:	34078793          	addi	a5,a5,832 # 802046b0 <trampoline>
    80204378:	40f707b3          	sub	a5,a4,a5
    8020437c:	fef43023          	sd	a5,-32(s0)
    w_stvec(uservec_va);
    80204380:	fe043503          	ld	a0,-32(s0)
    80204384:	fffff097          	auipc	ra,0xfffff
    80204388:	24e080e7          	jalr	590(ra) # 802035d2 <w_stvec>
    w_sscratch((uint64)TRAPFRAME);
    8020438c:	7579                	lui	a0,0xffffe
    8020438e:	fffff097          	auipc	ra,0xfffff
    80204392:	1e8080e7          	jalr	488(ra) # 80203576 <w_sscratch>
    uint64 user_satp = MAKE_SATP(p->pagetable);
    80204396:	fe843783          	ld	a5,-24(s0)
    8020439a:	7fdc                	ld	a5,184(a5)
    8020439c:	00c7d713          	srli	a4,a5,0xc
    802043a0:	57fd                	li	a5,-1
    802043a2:	17fe                	slli	a5,a5,0x3f
    802043a4:	8fd9                	or	a5,a5,a4
    802043a6:	fcf43c23          	sd	a5,-40(s0)
    uint64 userret_va = (uint64)TRAMPOLINE + ((uint64)userret - (uint64)trampoline);
    802043aa:	00000717          	auipc	a4,0x0
    802043ae:	39c70713          	addi	a4,a4,924 # 80204746 <userret>
    802043b2:	77fd                	lui	a5,0xfffff
    802043b4:	973e                	add	a4,a4,a5
    802043b6:	00000797          	auipc	a5,0x0
    802043ba:	2fa78793          	addi	a5,a5,762 # 802046b0 <trampoline>
    802043be:	40f707b3          	sub	a5,a4,a5
    802043c2:	fcf43823          	sd	a5,-48(s0)
    register uint64 a0 asm("a0") = (uint64)TRAPFRAME;
    802043c6:	7579                	lui	a0,0xffffe
    register uint64 a1 asm("a1") = user_satp;
    802043c8:	fd843583          	ld	a1,-40(s0)
    register void (*tgt)(uint64, uint64) asm("t0") = (void *)userret_va;
    802043cc:	fd043783          	ld	a5,-48(s0)
    802043d0:	82be                	mv	t0,a5
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(tgt) : "memory");
    802043d2:	8282                	jr	t0
}
    802043d4:	0001                	nop
    802043d6:	70a2                	ld	ra,40(sp)
    802043d8:	7402                	ld	s0,32(sp)
    802043da:	6145                	addi	sp,sp,48
    802043dc:	8082                	ret

00000000802043de <write32>:
    802043de:	7179                	addi	sp,sp,-48
    802043e0:	f406                	sd	ra,40(sp)
    802043e2:	f022                	sd	s0,32(sp)
    802043e4:	1800                	addi	s0,sp,48
    802043e6:	fca43c23          	sd	a0,-40(s0)
    802043ea:	87ae                	mv	a5,a1
    802043ec:	fcf42a23          	sw	a5,-44(s0)
    802043f0:	fd843783          	ld	a5,-40(s0)
    802043f4:	8b8d                	andi	a5,a5,3
    802043f6:	eb99                	bnez	a5,8020440c <write32+0x2e>
    802043f8:	fd843783          	ld	a5,-40(s0)
    802043fc:	fef43423          	sd	a5,-24(s0)
    80204400:	fe843783          	ld	a5,-24(s0)
    80204404:	fd442703          	lw	a4,-44(s0)
    80204408:	c398                	sw	a4,0(a5)
    8020440a:	a819                	j	80204420 <write32+0x42>
    8020440c:	fd843583          	ld	a1,-40(s0)
    80204410:	00007517          	auipc	a0,0x7
    80204414:	71050513          	addi	a0,a0,1808 # 8020bb20 <simple_user_task_bin+0x58>
    80204418:	ffffd097          	auipc	ra,0xffffd
    8020441c:	87c080e7          	jalr	-1924(ra) # 80200c94 <printf>
    80204420:	0001                	nop
    80204422:	70a2                	ld	ra,40(sp)
    80204424:	7402                	ld	s0,32(sp)
    80204426:	6145                	addi	sp,sp,48
    80204428:	8082                	ret

000000008020442a <read32>:
    8020442a:	7179                	addi	sp,sp,-48
    8020442c:	f406                	sd	ra,40(sp)
    8020442e:	f022                	sd	s0,32(sp)
    80204430:	1800                	addi	s0,sp,48
    80204432:	fca43c23          	sd	a0,-40(s0)
    80204436:	fd843783          	ld	a5,-40(s0)
    8020443a:	8b8d                	andi	a5,a5,3
    8020443c:	eb91                	bnez	a5,80204450 <read32+0x26>
    8020443e:	fd843783          	ld	a5,-40(s0)
    80204442:	fef43423          	sd	a5,-24(s0)
    80204446:	fe843783          	ld	a5,-24(s0)
    8020444a:	439c                	lw	a5,0(a5)
    8020444c:	2781                	sext.w	a5,a5
    8020444e:	a821                	j	80204466 <read32+0x3c>
    80204450:	fd843583          	ld	a1,-40(s0)
    80204454:	00007517          	auipc	a0,0x7
    80204458:	6fc50513          	addi	a0,a0,1788 # 8020bb50 <simple_user_task_bin+0x88>
    8020445c:	ffffd097          	auipc	ra,0xffffd
    80204460:	838080e7          	jalr	-1992(ra) # 80200c94 <printf>
    80204464:	4781                	li	a5,0
    80204466:	853e                	mv	a0,a5
    80204468:	70a2                	ld	ra,40(sp)
    8020446a:	7402                	ld	s0,32(sp)
    8020446c:	6145                	addi	sp,sp,48
    8020446e:	8082                	ret

0000000080204470 <plic_init>:
void plic_init(void) {
    80204470:	1101                	addi	sp,sp,-32
    80204472:	ec06                	sd	ra,24(sp)
    80204474:	e822                	sd	s0,16(sp)
    80204476:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80204478:	4785                	li	a5,1
    8020447a:	fef42623          	sw	a5,-20(s0)
    8020447e:	a805                	j	802044ae <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    80204480:	fec42783          	lw	a5,-20(s0)
    80204484:	0027979b          	slliw	a5,a5,0x2
    80204488:	2781                	sext.w	a5,a5
    8020448a:	873e                	mv	a4,a5
    8020448c:	0c0007b7          	lui	a5,0xc000
    80204490:	97ba                	add	a5,a5,a4
    80204492:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80204496:	4581                	li	a1,0
    80204498:	fe043503          	ld	a0,-32(s0)
    8020449c:	00000097          	auipc	ra,0x0
    802044a0:	f42080e7          	jalr	-190(ra) # 802043de <write32>
    for (int i = 1; i <= 32; i++) {
    802044a4:	fec42783          	lw	a5,-20(s0)
    802044a8:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    802044aa:	fef42623          	sw	a5,-20(s0)
    802044ae:	fec42783          	lw	a5,-20(s0)
    802044b2:	0007871b          	sext.w	a4,a5
    802044b6:	02000793          	li	a5,32
    802044ba:	fce7d3e3          	bge	a5,a4,80204480 <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    802044be:	4585                	li	a1,1
    802044c0:	0c0007b7          	lui	a5,0xc000
    802044c4:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    802044c8:	00000097          	auipc	ra,0x0
    802044cc:	f16080e7          	jalr	-234(ra) # 802043de <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    802044d0:	4585                	li	a1,1
    802044d2:	0c0007b7          	lui	a5,0xc000
    802044d6:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    802044da:	00000097          	auipc	ra,0x0
    802044de:	f04080e7          	jalr	-252(ra) # 802043de <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    802044e2:	40200593          	li	a1,1026
    802044e6:	0c0027b7          	lui	a5,0xc002
    802044ea:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802044ee:	00000097          	auipc	ra,0x0
    802044f2:	ef0080e7          	jalr	-272(ra) # 802043de <write32>
    write32(PLIC_THRESHOLD, 0);
    802044f6:	4581                	li	a1,0
    802044f8:	0c201537          	lui	a0,0xc201
    802044fc:	00000097          	auipc	ra,0x0
    80204500:	ee2080e7          	jalr	-286(ra) # 802043de <write32>
}
    80204504:	0001                	nop
    80204506:	60e2                	ld	ra,24(sp)
    80204508:	6442                	ld	s0,16(sp)
    8020450a:	6105                	addi	sp,sp,32
    8020450c:	8082                	ret

000000008020450e <plic_enable>:
void plic_enable(int irq) {
    8020450e:	7179                	addi	sp,sp,-48
    80204510:	f406                	sd	ra,40(sp)
    80204512:	f022                	sd	s0,32(sp)
    80204514:	1800                	addi	s0,sp,48
    80204516:	87aa                	mv	a5,a0
    80204518:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    8020451c:	0c0027b7          	lui	a5,0xc002
    80204520:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204524:	00000097          	auipc	ra,0x0
    80204528:	f06080e7          	jalr	-250(ra) # 8020442a <read32>
    8020452c:	87aa                	mv	a5,a0
    8020452e:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    80204532:	fdc42783          	lw	a5,-36(s0)
    80204536:	873e                	mv	a4,a5
    80204538:	4785                	li	a5,1
    8020453a:	00e797bb          	sllw	a5,a5,a4
    8020453e:	2781                	sext.w	a5,a5
    80204540:	2781                	sext.w	a5,a5
    80204542:	fec42703          	lw	a4,-20(s0)
    80204546:	8fd9                	or	a5,a5,a4
    80204548:	2781                	sext.w	a5,a5
    8020454a:	85be                	mv	a1,a5
    8020454c:	0c0027b7          	lui	a5,0xc002
    80204550:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204554:	00000097          	auipc	ra,0x0
    80204558:	e8a080e7          	jalr	-374(ra) # 802043de <write32>
}
    8020455c:	0001                	nop
    8020455e:	70a2                	ld	ra,40(sp)
    80204560:	7402                	ld	s0,32(sp)
    80204562:	6145                	addi	sp,sp,48
    80204564:	8082                	ret

0000000080204566 <plic_disable>:
void plic_disable(int irq) {
    80204566:	7179                	addi	sp,sp,-48
    80204568:	f406                	sd	ra,40(sp)
    8020456a:	f022                	sd	s0,32(sp)
    8020456c:	1800                	addi	s0,sp,48
    8020456e:	87aa                	mv	a5,a0
    80204570:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204574:	0c0027b7          	lui	a5,0xc002
    80204578:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    8020457c:	00000097          	auipc	ra,0x0
    80204580:	eae080e7          	jalr	-338(ra) # 8020442a <read32>
    80204584:	87aa                	mv	a5,a0
    80204586:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    8020458a:	fdc42783          	lw	a5,-36(s0)
    8020458e:	873e                	mv	a4,a5
    80204590:	4785                	li	a5,1
    80204592:	00e797bb          	sllw	a5,a5,a4
    80204596:	2781                	sext.w	a5,a5
    80204598:	fff7c793          	not	a5,a5
    8020459c:	2781                	sext.w	a5,a5
    8020459e:	2781                	sext.w	a5,a5
    802045a0:	fec42703          	lw	a4,-20(s0)
    802045a4:	8ff9                	and	a5,a5,a4
    802045a6:	2781                	sext.w	a5,a5
    802045a8:	85be                	mv	a1,a5
    802045aa:	0c0027b7          	lui	a5,0xc002
    802045ae:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802045b2:	00000097          	auipc	ra,0x0
    802045b6:	e2c080e7          	jalr	-468(ra) # 802043de <write32>
}
    802045ba:	0001                	nop
    802045bc:	70a2                	ld	ra,40(sp)
    802045be:	7402                	ld	s0,32(sp)
    802045c0:	6145                	addi	sp,sp,48
    802045c2:	8082                	ret

00000000802045c4 <plic_claim>:
int plic_claim(void) {
    802045c4:	1141                	addi	sp,sp,-16
    802045c6:	e406                	sd	ra,8(sp)
    802045c8:	e022                	sd	s0,0(sp)
    802045ca:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    802045cc:	0c2017b7          	lui	a5,0xc201
    802045d0:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    802045d4:	00000097          	auipc	ra,0x0
    802045d8:	e56080e7          	jalr	-426(ra) # 8020442a <read32>
    802045dc:	87aa                	mv	a5,a0
    802045de:	2781                	sext.w	a5,a5
    802045e0:	2781                	sext.w	a5,a5
}
    802045e2:	853e                	mv	a0,a5
    802045e4:	60a2                	ld	ra,8(sp)
    802045e6:	6402                	ld	s0,0(sp)
    802045e8:	0141                	addi	sp,sp,16
    802045ea:	8082                	ret

00000000802045ec <plic_complete>:
void plic_complete(int irq) {
    802045ec:	1101                	addi	sp,sp,-32
    802045ee:	ec06                	sd	ra,24(sp)
    802045f0:	e822                	sd	s0,16(sp)
    802045f2:	1000                	addi	s0,sp,32
    802045f4:	87aa                	mv	a5,a0
    802045f6:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    802045fa:	fec42783          	lw	a5,-20(s0)
    802045fe:	85be                	mv	a1,a5
    80204600:	0c2017b7          	lui	a5,0xc201
    80204604:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204608:	00000097          	auipc	ra,0x0
    8020460c:	dd6080e7          	jalr	-554(ra) # 802043de <write32>
    80204610:	0001                	nop
    80204612:	60e2                	ld	ra,24(sp)
    80204614:	6442                	ld	s0,16(sp)
    80204616:	6105                	addi	sp,sp,32
    80204618:	8082                	ret
    8020461a:	0000                	unimp
    8020461c:	0000                	unimp
	...

0000000080204620 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80204620:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80204622:	e006                	sd	ra,0(sp)
        sd gp, 16(sp)
    80204624:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80204626:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80204628:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8020462a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8020462c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    8020462e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80204630:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80204632:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80204634:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80204636:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80204638:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    8020463a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    8020463c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8020463e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80204640:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80204642:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80204644:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80204646:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80204648:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    8020464a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    8020464c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    8020464e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80204650:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80204652:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80204654:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80204656:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80204658:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    8020465a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    8020465c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    8020465e:	fffff097          	auipc	ra,0xfffff
    80204662:	2a0080e7          	jalr	672(ra) # 802038fe <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80204666:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80204668:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8020466a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8020466c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    8020466e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80204670:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80204672:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80204674:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80204676:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80204678:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8020467a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8020467c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8020467e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80204680:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80204682:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80204684:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80204686:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80204688:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    8020468a:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    8020468c:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    8020468e:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80204690:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80204692:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80204694:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80204696:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80204698:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    8020469a:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    8020469c:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8020469e:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    802046a0:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    802046a2:	10200073          	sret
    802046a6:	0001                	nop
    802046a8:	00000013          	nop
    802046ac:	00000013          	nop

00000000802046b0 <trampoline>:
trampoline:
.align 4

uservec:
    # 1. 取 trapframe 指针
    csrrw a0, sscratch, a0      # a0 = TRAPFRAME (用户页表下可访问), sscratch = user a0
    802046b0:	14051573          	csrrw	a0,sscratch,a0

    # 2. 在切换页表前，先读出关键字段到 t3–t6
    ld   t3, 0(a0)              # t3 = kernel_satp
    802046b4:	00053e03          	ld	t3,0(a0) # c201000 <_entry-0x73fff000>
    ld   t4, 8(a0)              # t4 = kernel_sp
    802046b8:	00853e83          	ld	t4,8(a0)
    ld   t5, 264(a0)            # t5 = usertrap
    802046bc:	10853f03          	ld	t5,264(a0)
	ld   t6, 272(a0)			# t6 = kernel_vec
    802046c0:	11053f83          	ld	t6,272(a0)

    # 3. 保存用户寄存器到 trapframe（仍在用户页表下）
    sd   ra, 48(a0)
    802046c4:	02153823          	sd	ra,48(a0)
    sd   sp, 56(a0)
    802046c8:	02253c23          	sd	sp,56(a0)
    sd   gp, 64(a0)
    802046cc:	04353023          	sd	gp,64(a0)
    sd   tp, 72(a0)
    802046d0:	04453423          	sd	tp,72(a0)
    sd   t0, 80(a0)
    802046d4:	04553823          	sd	t0,80(a0)
    sd   t1, 88(a0)
    802046d8:	04653c23          	sd	t1,88(a0)
    sd   t2, 96(a0)
    802046dc:	06753023          	sd	t2,96(a0)
    sd   s0, 104(a0)
    802046e0:	f520                	sd	s0,104(a0)
    sd   s1, 112(a0)
    802046e2:	f924                	sd	s1,112(a0)

    # 保存用户 a0：先取回 sscratch 里的原值
    csrr t2, sscratch
    802046e4:	140023f3          	csrr	t2,sscratch
    sd   t2, 120(a0)
    802046e8:	06753c23          	sd	t2,120(a0)

    sd   a1, 128(a0)
    802046ec:	e14c                	sd	a1,128(a0)
    sd   a2, 136(a0)
    802046ee:	e550                	sd	a2,136(a0)
    sd   a3, 144(a0)
    802046f0:	e954                	sd	a3,144(a0)
    sd   a4, 152(a0)
    802046f2:	ed58                	sd	a4,152(a0)
    sd   a5, 160(a0)
    802046f4:	f15c                	sd	a5,160(a0)
    sd   a6, 168(a0)
    802046f6:	0b053423          	sd	a6,168(a0)
    sd   a7, 176(a0)
    802046fa:	0b153823          	sd	a7,176(a0)
    sd   s2, 184(a0)
    802046fe:	0b253c23          	sd	s2,184(a0)
    sd   s3, 192(a0)
    80204702:	0d353023          	sd	s3,192(a0)
    sd   s4, 200(a0)
    80204706:	0d453423          	sd	s4,200(a0)
    sd   s5, 208(a0)
    8020470a:	0d553823          	sd	s5,208(a0)
    sd   s6, 216(a0)
    8020470e:	0d653c23          	sd	s6,216(a0)
    sd   s7, 224(a0)
    80204712:	0f753023          	sd	s7,224(a0)
    sd   s8, 232(a0)
    80204716:	0f853423          	sd	s8,232(a0)
    sd   s9, 240(a0)
    8020471a:	0f953823          	sd	s9,240(a0)
    sd   s10, 248(a0)
    8020471e:	0fa53c23          	sd	s10,248(a0)
    sd   s11, 256(a0)
    80204722:	11b53023          	sd	s11,256(a0)

    # 保存控制寄存器
    csrr t0, sstatus
    80204726:	100022f3          	csrr	t0,sstatus
    sd   t0, 24(a0)
    8020472a:	00553c23          	sd	t0,24(a0)
    csrr t1, sepc
    8020472e:	14102373          	csrr	t1,sepc
    sd   t1, 32(a0)
    80204732:	02653023          	sd	t1,32(a0)

    # 4. 切换到内核页表
    csrw satp, t3
    80204736:	180e1073          	csrw	satp,t3
    sfence.vma x0, x0
    8020473a:	12000073          	sfence.vma

    # 5. 切换到内核栈
    mv   sp, t4
    8020473e:	8176                	mv	sp,t4

    # 6. 设置 stvec 并跳转到 C 层 usertrap
    csrw stvec, t6
    80204740:	105f9073          	csrw	stvec,t6
    jr   t5
    80204744:	8f02                	jr	t5

0000000080204746 <userret>:
userret:
        csrw satp, a1
    80204746:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    8020474a:	12000073          	sfence.vma
        ld ra, 48(a0)
    8020474e:	03053083          	ld	ra,48(a0)
        ld sp, 56(a0)
    80204752:	03853103          	ld	sp,56(a0)
        ld gp, 64(a0)
    80204756:	04053183          	ld	gp,64(a0)
        ld tp, 72(a0)
    8020475a:	04853203          	ld	tp,72(a0)
        ld t0, 80(a0)
    8020475e:	05053283          	ld	t0,80(a0)
        ld t1, 88(a0)
    80204762:	05853303          	ld	t1,88(a0)
        ld t2, 96(a0)
    80204766:	06053383          	ld	t2,96(a0)
        ld s0, 104(a0)
    8020476a:	7520                	ld	s0,104(a0)
        ld s1, 112(a0)
    8020476c:	7924                	ld	s1,112(a0)
        ld a1, 128(a0)
    8020476e:	614c                	ld	a1,128(a0)
        ld a2, 136(a0)
    80204770:	6550                	ld	a2,136(a0)
        ld a3, 144(a0)
    80204772:	6954                	ld	a3,144(a0)
        ld a4, 152(a0)
    80204774:	6d58                	ld	a4,152(a0)
        ld a5, 160(a0)
    80204776:	715c                	ld	a5,160(a0)
        ld a6, 168(a0)
    80204778:	0a853803          	ld	a6,168(a0)
        ld a7, 176(a0)
    8020477c:	0b053883          	ld	a7,176(a0)
        ld s2, 184(a0)
    80204780:	0b853903          	ld	s2,184(a0)
        ld s3, 192(a0)
    80204784:	0c053983          	ld	s3,192(a0)
        ld s4, 200(a0)
    80204788:	0c853a03          	ld	s4,200(a0)
        ld s5, 208(a0)
    8020478c:	0d053a83          	ld	s5,208(a0)
        ld s6, 216(a0)
    80204790:	0d853b03          	ld	s6,216(a0)
        ld s7, 224(a0)
    80204794:	0e053b83          	ld	s7,224(a0)
        ld s8, 232(a0)
    80204798:	0e853c03          	ld	s8,232(a0)
        ld s9, 240(a0)
    8020479c:	0f053c83          	ld	s9,240(a0)
        ld s10, 248(a0)
    802047a0:	0f853d03          	ld	s10,248(a0)
        ld s11, 256(a0)
    802047a4:	10053d83          	ld	s11,256(a0)

        ld t3, 32(a0)      # 恢复 sepc
    802047a8:	02053e03          	ld	t3,32(a0)
        csrw sepc, t3
    802047ac:	141e1073          	csrw	sepc,t3
        ld t3, 24(a0)      # 恢复 sstatus
    802047b0:	01853e03          	ld	t3,24(a0)
        csrw sstatus, t3
    802047b4:	100e1073          	csrw	sstatus,t3
		csrw sscratch, a0
    802047b8:	14051073          	csrw	sscratch,a0
		ld a0, 120(a0)
    802047bc:	7d28                	ld	a0,120(a0)
    802047be:	10200073          	sret
    802047c2:	0001                	nop
    802047c4:	00000013          	nop
    802047c8:	00000013          	nop
    802047cc:	00000013          	nop

00000000802047d0 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    802047d0:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    802047d4:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    802047d8:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    802047da:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    802047dc:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    802047e0:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    802047e4:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    802047e8:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    802047ec:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    802047f0:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    802047f4:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    802047f8:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    802047fc:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80204800:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80204804:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80204808:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8020480c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8020480e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80204810:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80204814:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80204818:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8020481c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80204820:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80204824:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80204828:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8020482c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80204830:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80204834:	0685bd83          	ld	s11,104(a1)
        
        ret
    80204838:	8082                	ret

000000008020483a <r_sstatus>:
        c->context.ra = (uint64)schedule;
        c->context.sp = (uint64)c + PGSIZE;
    }
    current_proc = 0;
    c->proc = 0;
    swtch(&p->context, &c->context);
    8020483a:	1101                	addi	sp,sp,-32
    8020483c:	ec22                	sd	s0,24(sp)
    8020483e:	1000                	addi	s0,sp,32
    intr_on();
}
    80204840:	100027f3          	csrr	a5,sstatus
    80204844:	fef43423          	sd	a5,-24(s0)
void sleep(void *chan){
    80204848:	fe843783          	ld	a5,-24(s0)
    struct proc *p = myproc();
    8020484c:	853e                	mv	a0,a5
    8020484e:	6462                	ld	s0,24(sp)
    80204850:	6105                	addi	sp,sp,32
    80204852:	8082                	ret

0000000080204854 <w_sstatus>:
    struct cpu *c = mycpu();
    80204854:	1101                	addi	sp,sp,-32
    80204856:	ec22                	sd	s0,24(sp)
    80204858:	1000                	addi	s0,sp,32
    8020485a:	fea43423          	sd	a0,-24(s0)
    register uint64 ra asm("ra");
    8020485e:	fe843783          	ld	a5,-24(s0)
    80204862:	10079073          	csrw	sstatus,a5
    p->context.ra = ra;
    80204866:	0001                	nop
    80204868:	6462                	ld	s0,24(sp)
    8020486a:	6105                	addi	sp,sp,32
    8020486c:	8082                	ret

000000008020486e <intr_on>:
    p->chan = 0;
}
void wakeup(void *chan) {
    for(int i = 0; i < PROC; i++) {
        struct proc *p = proc_table[i];
        if(p->state == SLEEPING && p->chan == chan) {
    8020486e:	1141                	addi	sp,sp,-16
    80204870:	e406                	sd	ra,8(sp)
    80204872:	e022                	sd	s0,0(sp)
    80204874:	0800                	addi	s0,sp,16
            p->state = RUNNABLE;
    80204876:	00000097          	auipc	ra,0x0
    8020487a:	fc4080e7          	jalr	-60(ra) # 8020483a <r_sstatus>
    8020487e:	87aa                	mv	a5,a0
    80204880:	0027e793          	ori	a5,a5,2
    80204884:	853e                	mv	a0,a5
    80204886:	00000097          	auipc	ra,0x0
    8020488a:	fce080e7          	jalr	-50(ra) # 80204854 <w_sstatus>
        }
    8020488e:	0001                	nop
    80204890:	60a2                	ld	ra,8(sp)
    80204892:	6402                	ld	s0,0(sp)
    80204894:	0141                	addi	sp,sp,16
    80204896:	8082                	ret

0000000080204898 <intr_off>:
    }
}
    80204898:	1141                	addi	sp,sp,-16
    8020489a:	e406                	sd	ra,8(sp)
    8020489c:	e022                	sd	s0,0(sp)
    8020489e:	0800                	addi	s0,sp,16
void exit_proc(int status) {
    802048a0:	00000097          	auipc	ra,0x0
    802048a4:	f9a080e7          	jalr	-102(ra) # 8020483a <r_sstatus>
    802048a8:	87aa                	mv	a5,a0
    802048aa:	9bf5                	andi	a5,a5,-3
    802048ac:	853e                	mv	a0,a5
    802048ae:	00000097          	auipc	ra,0x0
    802048b2:	fa6080e7          	jalr	-90(ra) # 80204854 <w_sstatus>
    struct proc *p = myproc();
    802048b6:	0001                	nop
    802048b8:	60a2                	ld	ra,8(sp)
    802048ba:	6402                	ld	s0,0(sp)
    802048bc:	0141                	addi	sp,sp,16
    802048be:	8082                	ret

00000000802048c0 <w_stvec>:
    
    if (p == 0) {
    802048c0:	1101                	addi	sp,sp,-32
    802048c2:	ec22                	sd	s0,24(sp)
    802048c4:	1000                	addi	s0,sp,32
    802048c6:	fea43423          	sd	a0,-24(s0)
        panic("exit_proc: no current process");
    802048ca:	fe843783          	ld	a5,-24(s0)
    802048ce:	10579073          	csrw	stvec,a5
    }
    802048d2:	0001                	nop
    802048d4:	6462                	ld	s0,24(sp)
    802048d6:	6105                	addi	sp,sp,32
    802048d8:	8082                	ret

00000000802048da <assert>:
        struct proc *zombie_child = 0;
        
        // 先查找ZOMBIE状态的子进程
        for (int i = 0; i < PROC; i++) {
            struct proc *child = proc_table[i];
            if (child->state == ZOMBIE && child->parent == p) {
    802048da:	1101                	addi	sp,sp,-32
    802048dc:	ec06                	sd	ra,24(sp)
    802048de:	e822                	sd	s0,16(sp)
    802048e0:	1000                	addi	s0,sp,32
    802048e2:	87aa                	mv	a5,a0
    802048e4:	fef42623          	sw	a5,-20(s0)
                found_zombie = 1;
    802048e8:	fec42783          	lw	a5,-20(s0)
    802048ec:	2781                	sext.w	a5,a5
    802048ee:	e79d                	bnez	a5,8020491c <assert+0x42>
                zombie_pid = child->pid;
    802048f0:	19c00613          	li	a2,412
    802048f4:	00007597          	auipc	a1,0x7
    802048f8:	77458593          	addi	a1,a1,1908 # 8020c068 <simple_user_task_bin+0x58>
    802048fc:	00007517          	auipc	a0,0x7
    80204900:	77c50513          	addi	a0,a0,1916 # 8020c078 <simple_user_task_bin+0x68>
    80204904:	ffffc097          	auipc	ra,0xffffc
    80204908:	390080e7          	jalr	912(ra) # 80200c94 <printf>
                zombie_status = child->exit_status;
    8020490c:	00007517          	auipc	a0,0x7
    80204910:	79450513          	addi	a0,a0,1940 # 8020c0a0 <simple_user_task_bin+0x90>
    80204914:	ffffd097          	auipc	ra,0xffffd
    80204918:	dcc080e7          	jalr	-564(ra) # 802016e0 <panic>
                zombie_child = child;
                break;
    8020491c:	0001                	nop
    8020491e:	60e2                	ld	ra,24(sp)
    80204920:	6442                	ld	s0,16(sp)
    80204922:	6105                	addi	sp,sp,32
    80204924:	8082                	ret

0000000080204926 <shutdown>:
void shutdown() {
    80204926:	1141                	addi	sp,sp,-16
    80204928:	e406                	sd	ra,8(sp)
    8020492a:	e022                	sd	s0,0(sp)
    8020492c:	0800                	addi	s0,sp,16
	free_proc_table();
    8020492e:	00000097          	auipc	ra,0x0
    80204932:	372080e7          	jalr	882(ra) # 80204ca0 <free_proc_table>
    printf("关机\n");
    80204936:	00007517          	auipc	a0,0x7
    8020493a:	77250513          	addi	a0,a0,1906 # 8020c0a8 <simple_user_task_bin+0x98>
    8020493e:	ffffc097          	auipc	ra,0xffffc
    80204942:	356080e7          	jalr	854(ra) # 80200c94 <printf>
    asm volatile (
    80204946:	48a1                	li	a7,8
    80204948:	00000073          	ecall
    while (1) { }
    8020494c:	0001                	nop
    8020494e:	bffd                	j	8020494c <shutdown+0x26>

0000000080204950 <myproc>:
struct proc* myproc(void) {
    80204950:	1141                	addi	sp,sp,-16
    80204952:	e422                	sd	s0,8(sp)
    80204954:	0800                	addi	s0,sp,16
    return current_proc;
    80204956:	0000a797          	auipc	a5,0xa
    8020495a:	75278793          	addi	a5,a5,1874 # 8020f0a8 <current_proc>
    8020495e:	639c                	ld	a5,0(a5)
}
    80204960:	853e                	mv	a0,a5
    80204962:	6422                	ld	s0,8(sp)
    80204964:	0141                	addi	sp,sp,16
    80204966:	8082                	ret

0000000080204968 <mycpu>:
struct cpu* mycpu(void) {
    80204968:	1141                	addi	sp,sp,-16
    8020496a:	e406                	sd	ra,8(sp)
    8020496c:	e022                	sd	s0,0(sp)
    8020496e:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80204970:	0000a797          	auipc	a5,0xa
    80204974:	74078793          	addi	a5,a5,1856 # 8020f0b0 <current_cpu>
    80204978:	639c                	ld	a5,0(a5)
    8020497a:	ebb9                	bnez	a5,802049d0 <mycpu+0x68>
        warning("current_cpu is NULL, initializing...\n");
    8020497c:	00007517          	auipc	a0,0x7
    80204980:	73450513          	addi	a0,a0,1844 # 8020c0b0 <simple_user_task_bin+0xa0>
    80204984:	ffffd097          	auipc	ra,0xffffd
    80204988:	d90080e7          	jalr	-624(ra) # 80201714 <warning>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    8020498c:	07800613          	li	a2,120
    80204990:	4581                	li	a1,0
    80204992:	0000b517          	auipc	a0,0xb
    80204996:	cde50513          	addi	a0,a0,-802 # 8020f670 <cpu_instance.1>
    8020499a:	ffffd097          	auipc	ra,0xffffd
    8020499e:	484080e7          	jalr	1156(ra) # 80201e1e <memset>
		current_cpu = &cpu_instance;
    802049a2:	0000a797          	auipc	a5,0xa
    802049a6:	70e78793          	addi	a5,a5,1806 # 8020f0b0 <current_cpu>
    802049aa:	0000b717          	auipc	a4,0xb
    802049ae:	cc670713          	addi	a4,a4,-826 # 8020f670 <cpu_instance.1>
    802049b2:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    802049b4:	0000a797          	auipc	a5,0xa
    802049b8:	6fc78793          	addi	a5,a5,1788 # 8020f0b0 <current_cpu>
    802049bc:	639c                	ld	a5,0(a5)
    802049be:	85be                	mv	a1,a5
    802049c0:	00007517          	auipc	a0,0x7
    802049c4:	71850513          	addi	a0,a0,1816 # 8020c0d8 <simple_user_task_bin+0xc8>
    802049c8:	ffffc097          	auipc	ra,0xffffc
    802049cc:	2cc080e7          	jalr	716(ra) # 80200c94 <printf>
    return current_cpu;
    802049d0:	0000a797          	auipc	a5,0xa
    802049d4:	6e078793          	addi	a5,a5,1760 # 8020f0b0 <current_cpu>
    802049d8:	639c                	ld	a5,0(a5)
}
    802049da:	853e                	mv	a0,a5
    802049dc:	60a2                	ld	ra,8(sp)
    802049de:	6402                	ld	s0,0(sp)
    802049e0:	0141                	addi	sp,sp,16
    802049e2:	8082                	ret

00000000802049e4 <return_to_user>:
void return_to_user(void) {
    802049e4:	7179                	addi	sp,sp,-48
    802049e6:	f406                	sd	ra,40(sp)
    802049e8:	f022                	sd	s0,32(sp)
    802049ea:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    802049ec:	00000097          	auipc	ra,0x0
    802049f0:	f64080e7          	jalr	-156(ra) # 80204950 <myproc>
    802049f4:	fea43423          	sd	a0,-24(s0)
    if (!p) panic("return_to_user: no current process");
    802049f8:	fe843783          	ld	a5,-24(s0)
    802049fc:	eb89                	bnez	a5,80204a0e <return_to_user+0x2a>
    802049fe:	00007517          	auipc	a0,0x7
    80204a02:	6f250513          	addi	a0,a0,1778 # 8020c0f0 <simple_user_task_bin+0xe0>
    80204a06:	ffffd097          	auipc	ra,0xffffd
    80204a0a:	cda080e7          	jalr	-806(ra) # 802016e0 <panic>
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    80204a0e:	00000717          	auipc	a4,0x0
    80204a12:	ca270713          	addi	a4,a4,-862 # 802046b0 <trampoline>
    80204a16:	00000797          	auipc	a5,0x0
    80204a1a:	c9a78793          	addi	a5,a5,-870 # 802046b0 <trampoline>
    80204a1e:	40f707b3          	sub	a5,a4,a5
    80204a22:	873e                	mv	a4,a5
    80204a24:	77fd                	lui	a5,0xfffff
    80204a26:	97ba                	add	a5,a5,a4
    80204a28:	853e                	mv	a0,a5
    80204a2a:	00000097          	auipc	ra,0x0
    80204a2e:	e96080e7          	jalr	-362(ra) # 802048c0 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80204a32:	00000717          	auipc	a4,0x0
    80204a36:	d1470713          	addi	a4,a4,-748 # 80204746 <userret>
    80204a3a:	00000797          	auipc	a5,0x0
    80204a3e:	c7678793          	addi	a5,a5,-906 # 802046b0 <trampoline>
    80204a42:	40f707b3          	sub	a5,a4,a5
    80204a46:	873e                	mv	a4,a5
    80204a48:	77fd                	lui	a5,0xfffff
    80204a4a:	97ba                	add	a5,a5,a4
    80204a4c:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    80204a50:	fe843783          	ld	a5,-24(s0)
    80204a54:	7fdc                	ld	a5,184(a5)
    80204a56:	00c7d713          	srli	a4,a5,0xc
    80204a5a:	57fd                	li	a5,-1
    80204a5c:	17fe                	slli	a5,a5,0x3f
    80204a5e:	8fd9                	or	a5,a5,a4
    80204a60:	fcf43c23          	sd	a5,-40(s0)
    if ((trampoline_userret & ~(PGSIZE - 1)) != TRAMPOLINE) {
    80204a64:	fe043703          	ld	a4,-32(s0)
    80204a68:	77fd                	lui	a5,0xfffff
    80204a6a:	8f7d                	and	a4,a4,a5
    80204a6c:	77fd                	lui	a5,0xfffff
    80204a6e:	00f70a63          	beq	a4,a5,80204a82 <return_to_user+0x9e>
        panic("return_to_user: userret outside trampoline page");
    80204a72:	00007517          	auipc	a0,0x7
    80204a76:	6a650513          	addi	a0,a0,1702 # 8020c118 <simple_user_task_bin+0x108>
    80204a7a:	ffffd097          	auipc	ra,0xffffd
    80204a7e:	c66080e7          	jalr	-922(ra) # 802016e0 <panic>
    void (*userret_fn)(uint64, uint64) = (void (*)(uint64, uint64))trampoline_userret;
    80204a82:	fe043783          	ld	a5,-32(s0)
    80204a86:	fcf43823          	sd	a5,-48(s0)
    userret_fn(TRAPFRAME, satp);
    80204a8a:	fd043783          	ld	a5,-48(s0)
    80204a8e:	fd843583          	ld	a1,-40(s0)
    80204a92:	7579                	lui	a0,0xffffe
    80204a94:	9782                	jalr	a5
    panic("return_to_user: should not return");
    80204a96:	00007517          	auipc	a0,0x7
    80204a9a:	6b250513          	addi	a0,a0,1714 # 8020c148 <simple_user_task_bin+0x138>
    80204a9e:	ffffd097          	auipc	ra,0xffffd
    80204aa2:	c42080e7          	jalr	-958(ra) # 802016e0 <panic>
}
    80204aa6:	0001                	nop
    80204aa8:	70a2                	ld	ra,40(sp)
    80204aaa:	7402                	ld	s0,32(sp)
    80204aac:	6145                	addi	sp,sp,48
    80204aae:	8082                	ret

0000000080204ab0 <forkret>:
void forkret(void) {
    80204ab0:	1101                	addi	sp,sp,-32
    80204ab2:	ec06                	sd	ra,24(sp)
    80204ab4:	e822                	sd	s0,16(sp)
    80204ab6:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80204ab8:	00000097          	auipc	ra,0x0
    80204abc:	e98080e7          	jalr	-360(ra) # 80204950 <myproc>
    80204ac0:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80204ac4:	fe843783          	ld	a5,-24(s0)
    80204ac8:	eb89                	bnez	a5,80204ada <forkret+0x2a>
        panic("forkret: no current process");
    80204aca:	00007517          	auipc	a0,0x7
    80204ace:	6a650513          	addi	a0,a0,1702 # 8020c170 <simple_user_task_bin+0x160>
    80204ad2:	ffffd097          	auipc	ra,0xffffd
    80204ad6:	c0e080e7          	jalr	-1010(ra) # 802016e0 <panic>
    if (p->is_user) {
    80204ada:	fe843783          	ld	a5,-24(s0)
    80204ade:	0a87a783          	lw	a5,168(a5) # fffffffffffff0a8 <_bss_end+0xffffffff7fdef9a8>
    80204ae2:	c791                	beqz	a5,80204aee <forkret+0x3e>
        return_to_user();
    80204ae4:	00000097          	auipc	ra,0x0
    80204ae8:	f00080e7          	jalr	-256(ra) # 802049e4 <return_to_user>
}
    80204aec:	a025                	j	80204b14 <forkret+0x64>
        if (p->trapframe->epc) {
    80204aee:	fe843783          	ld	a5,-24(s0)
    80204af2:	63fc                	ld	a5,192(a5)
    80204af4:	739c                	ld	a5,32(a5)
    80204af6:	cb91                	beqz	a5,80204b0a <forkret+0x5a>
            void (*fn)(void) = (void(*)(void))p->trapframe->epc;
    80204af8:	fe843783          	ld	a5,-24(s0)
    80204afc:	63fc                	ld	a5,192(a5)
    80204afe:	739c                	ld	a5,32(a5)
    80204b00:	fef43023          	sd	a5,-32(s0)
            fn();
    80204b04:	fe043783          	ld	a5,-32(s0)
    80204b08:	9782                	jalr	a5
        exit_proc(0);  // 内核线程函数返回则退出
    80204b0a:	4501                	li	a0,0
    80204b0c:	00001097          	auipc	ra,0x1
    80204b10:	b10080e7          	jalr	-1264(ra) # 8020561c <exit_proc>
}
    80204b14:	0001                	nop
    80204b16:	60e2                	ld	ra,24(sp)
    80204b18:	6442                	ld	s0,16(sp)
    80204b1a:	6105                	addi	sp,sp,32
    80204b1c:	8082                	ret

0000000080204b1e <init_proc>:
void init_proc(void){
    80204b1e:	1101                	addi	sp,sp,-32
    80204b20:	ec06                	sd	ra,24(sp)
    80204b22:	e822                	sd	s0,16(sp)
    80204b24:	1000                	addi	s0,sp,32
    for (int i = 0; i < PROC; i++) {
    80204b26:	fe042623          	sw	zero,-20(s0)
    80204b2a:	aa81                	j	80204c7a <init_proc+0x15c>
        void *page = alloc_page();
    80204b2c:	ffffe097          	auipc	ra,0xffffe
    80204b30:	6fa080e7          	jalr	1786(ra) # 80203226 <alloc_page>
    80204b34:	fea43023          	sd	a0,-32(s0)
        if (!page) panic("init_proc: alloc_page failed for proc_table");
    80204b38:	fe043783          	ld	a5,-32(s0)
    80204b3c:	eb89                	bnez	a5,80204b4e <init_proc+0x30>
    80204b3e:	00007517          	auipc	a0,0x7
    80204b42:	65250513          	addi	a0,a0,1618 # 8020c190 <simple_user_task_bin+0x180>
    80204b46:	ffffd097          	auipc	ra,0xffffd
    80204b4a:	b9a080e7          	jalr	-1126(ra) # 802016e0 <panic>
        proc_table_mem[i] = page;
    80204b4e:	0000b717          	auipc	a4,0xb
    80204b52:	a2270713          	addi	a4,a4,-1502 # 8020f570 <proc_table_mem>
    80204b56:	fec42783          	lw	a5,-20(s0)
    80204b5a:	078e                	slli	a5,a5,0x3
    80204b5c:	97ba                	add	a5,a5,a4
    80204b5e:	fe043703          	ld	a4,-32(s0)
    80204b62:	e398                	sd	a4,0(a5)
        proc_table[i] = (struct proc *)page;
    80204b64:	0000b717          	auipc	a4,0xb
    80204b68:	90470713          	addi	a4,a4,-1788 # 8020f468 <proc_table>
    80204b6c:	fec42783          	lw	a5,-20(s0)
    80204b70:	078e                	slli	a5,a5,0x3
    80204b72:	97ba                	add	a5,a5,a4
    80204b74:	fe043703          	ld	a4,-32(s0)
    80204b78:	e398                	sd	a4,0(a5)
        memset(proc_table[i], 0, sizeof(struct proc));
    80204b7a:	0000b717          	auipc	a4,0xb
    80204b7e:	8ee70713          	addi	a4,a4,-1810 # 8020f468 <proc_table>
    80204b82:	fec42783          	lw	a5,-20(s0)
    80204b86:	078e                	slli	a5,a5,0x3
    80204b88:	97ba                	add	a5,a5,a4
    80204b8a:	639c                	ld	a5,0(a5)
    80204b8c:	0c800613          	li	a2,200
    80204b90:	4581                	li	a1,0
    80204b92:	853e                	mv	a0,a5
    80204b94:	ffffd097          	auipc	ra,0xffffd
    80204b98:	28a080e7          	jalr	650(ra) # 80201e1e <memset>
        proc_table[i]->state = UNUSED;
    80204b9c:	0000b717          	auipc	a4,0xb
    80204ba0:	8cc70713          	addi	a4,a4,-1844 # 8020f468 <proc_table>
    80204ba4:	fec42783          	lw	a5,-20(s0)
    80204ba8:	078e                	slli	a5,a5,0x3
    80204baa:	97ba                	add	a5,a5,a4
    80204bac:	639c                	ld	a5,0(a5)
    80204bae:	0007a023          	sw	zero,0(a5)
        proc_table[i]->pid = 0;
    80204bb2:	0000b717          	auipc	a4,0xb
    80204bb6:	8b670713          	addi	a4,a4,-1866 # 8020f468 <proc_table>
    80204bba:	fec42783          	lw	a5,-20(s0)
    80204bbe:	078e                	slli	a5,a5,0x3
    80204bc0:	97ba                	add	a5,a5,a4
    80204bc2:	639c                	ld	a5,0(a5)
    80204bc4:	0007a223          	sw	zero,4(a5)
        proc_table[i]->kstack = 0;
    80204bc8:	0000b717          	auipc	a4,0xb
    80204bcc:	8a070713          	addi	a4,a4,-1888 # 8020f468 <proc_table>
    80204bd0:	fec42783          	lw	a5,-20(s0)
    80204bd4:	078e                	slli	a5,a5,0x3
    80204bd6:	97ba                	add	a5,a5,a4
    80204bd8:	639c                	ld	a5,0(a5)
    80204bda:	0007b423          	sd	zero,8(a5)
        proc_table[i]->pagetable = 0;
    80204bde:	0000b717          	auipc	a4,0xb
    80204be2:	88a70713          	addi	a4,a4,-1910 # 8020f468 <proc_table>
    80204be6:	fec42783          	lw	a5,-20(s0)
    80204bea:	078e                	slli	a5,a5,0x3
    80204bec:	97ba                	add	a5,a5,a4
    80204bee:	639c                	ld	a5,0(a5)
    80204bf0:	0a07bc23          	sd	zero,184(a5)
        proc_table[i]->trapframe = 0;
    80204bf4:	0000b717          	auipc	a4,0xb
    80204bf8:	87470713          	addi	a4,a4,-1932 # 8020f468 <proc_table>
    80204bfc:	fec42783          	lw	a5,-20(s0)
    80204c00:	078e                	slli	a5,a5,0x3
    80204c02:	97ba                	add	a5,a5,a4
    80204c04:	639c                	ld	a5,0(a5)
    80204c06:	0c07b023          	sd	zero,192(a5)
        proc_table[i]->parent = 0;
    80204c0a:	0000b717          	auipc	a4,0xb
    80204c0e:	85e70713          	addi	a4,a4,-1954 # 8020f468 <proc_table>
    80204c12:	fec42783          	lw	a5,-20(s0)
    80204c16:	078e                	slli	a5,a5,0x3
    80204c18:	97ba                	add	a5,a5,a4
    80204c1a:	639c                	ld	a5,0(a5)
    80204c1c:	0807bc23          	sd	zero,152(a5)
        proc_table[i]->chan = 0;
    80204c20:	0000b717          	auipc	a4,0xb
    80204c24:	84870713          	addi	a4,a4,-1976 # 8020f468 <proc_table>
    80204c28:	fec42783          	lw	a5,-20(s0)
    80204c2c:	078e                	slli	a5,a5,0x3
    80204c2e:	97ba                	add	a5,a5,a4
    80204c30:	639c                	ld	a5,0(a5)
    80204c32:	0a07b023          	sd	zero,160(a5)
        proc_table[i]->exit_status = 0;
    80204c36:	0000b717          	auipc	a4,0xb
    80204c3a:	83270713          	addi	a4,a4,-1998 # 8020f468 <proc_table>
    80204c3e:	fec42783          	lw	a5,-20(s0)
    80204c42:	078e                	slli	a5,a5,0x3
    80204c44:	97ba                	add	a5,a5,a4
    80204c46:	639c                	ld	a5,0(a5)
    80204c48:	0807a223          	sw	zero,132(a5)
        memset(&proc_table[i]->context, 0, sizeof(struct context));
    80204c4c:	0000b717          	auipc	a4,0xb
    80204c50:	81c70713          	addi	a4,a4,-2020 # 8020f468 <proc_table>
    80204c54:	fec42783          	lw	a5,-20(s0)
    80204c58:	078e                	slli	a5,a5,0x3
    80204c5a:	97ba                	add	a5,a5,a4
    80204c5c:	639c                	ld	a5,0(a5)
    80204c5e:	07c1                	addi	a5,a5,16
    80204c60:	07000613          	li	a2,112
    80204c64:	4581                	li	a1,0
    80204c66:	853e                	mv	a0,a5
    80204c68:	ffffd097          	auipc	ra,0xffffd
    80204c6c:	1b6080e7          	jalr	438(ra) # 80201e1e <memset>
    for (int i = 0; i < PROC; i++) {
    80204c70:	fec42783          	lw	a5,-20(s0)
    80204c74:	2785                	addiw	a5,a5,1
    80204c76:	fef42623          	sw	a5,-20(s0)
    80204c7a:	fec42783          	lw	a5,-20(s0)
    80204c7e:	0007871b          	sext.w	a4,a5
    80204c82:	47fd                	li	a5,31
    80204c84:	eae7d4e3          	bge	a5,a4,80204b2c <init_proc+0xe>
    proc_table_pages = PROC; // 每个进程一页
    80204c88:	0000b797          	auipc	a5,0xb
    80204c8c:	8e078793          	addi	a5,a5,-1824 # 8020f568 <proc_table_pages>
    80204c90:	02000713          	li	a4,32
    80204c94:	c398                	sw	a4,0(a5)
}
    80204c96:	0001                	nop
    80204c98:	60e2                	ld	ra,24(sp)
    80204c9a:	6442                	ld	s0,16(sp)
    80204c9c:	6105                	addi	sp,sp,32
    80204c9e:	8082                	ret

0000000080204ca0 <free_proc_table>:
void free_proc_table(void) {
    80204ca0:	1101                	addi	sp,sp,-32
    80204ca2:	ec06                	sd	ra,24(sp)
    80204ca4:	e822                	sd	s0,16(sp)
    80204ca6:	1000                	addi	s0,sp,32
    for (int i = 0; i < proc_table_pages; i++) {
    80204ca8:	fe042623          	sw	zero,-20(s0)
    80204cac:	a025                	j	80204cd4 <free_proc_table+0x34>
        free_page(proc_table_mem[i]);
    80204cae:	0000b717          	auipc	a4,0xb
    80204cb2:	8c270713          	addi	a4,a4,-1854 # 8020f570 <proc_table_mem>
    80204cb6:	fec42783          	lw	a5,-20(s0)
    80204cba:	078e                	slli	a5,a5,0x3
    80204cbc:	97ba                	add	a5,a5,a4
    80204cbe:	639c                	ld	a5,0(a5)
    80204cc0:	853e                	mv	a0,a5
    80204cc2:	ffffe097          	auipc	ra,0xffffe
    80204cc6:	5d0080e7          	jalr	1488(ra) # 80203292 <free_page>
    for (int i = 0; i < proc_table_pages; i++) {
    80204cca:	fec42783          	lw	a5,-20(s0)
    80204cce:	2785                	addiw	a5,a5,1
    80204cd0:	fef42623          	sw	a5,-20(s0)
    80204cd4:	0000b797          	auipc	a5,0xb
    80204cd8:	89478793          	addi	a5,a5,-1900 # 8020f568 <proc_table_pages>
    80204cdc:	4398                	lw	a4,0(a5)
    80204cde:	fec42783          	lw	a5,-20(s0)
    80204ce2:	2781                	sext.w	a5,a5
    80204ce4:	fce7c5e3          	blt	a5,a4,80204cae <free_proc_table+0xe>
}
    80204ce8:	0001                	nop
    80204cea:	0001                	nop
    80204cec:	60e2                	ld	ra,24(sp)
    80204cee:	6442                	ld	s0,16(sp)
    80204cf0:	6105                	addi	sp,sp,32
    80204cf2:	8082                	ret

0000000080204cf4 <alloc_proc>:
struct proc* alloc_proc(int is_user) {
    80204cf4:	7139                	addi	sp,sp,-64
    80204cf6:	fc06                	sd	ra,56(sp)
    80204cf8:	f822                	sd	s0,48(sp)
    80204cfa:	0080                	addi	s0,sp,64
    80204cfc:	87aa                	mv	a5,a0
    80204cfe:	fcf42623          	sw	a5,-52(s0)
    for(int i = 0;i<PROC;i++) {
    80204d02:	fe042623          	sw	zero,-20(s0)
    80204d06:	aa85                	j	80204e76 <alloc_proc+0x182>
		struct proc *p = proc_table[i];
    80204d08:	0000a717          	auipc	a4,0xa
    80204d0c:	76070713          	addi	a4,a4,1888 # 8020f468 <proc_table>
    80204d10:	fec42783          	lw	a5,-20(s0)
    80204d14:	078e                	slli	a5,a5,0x3
    80204d16:	97ba                	add	a5,a5,a4
    80204d18:	639c                	ld	a5,0(a5)
    80204d1a:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    80204d1e:	fe043783          	ld	a5,-32(s0)
    80204d22:	439c                	lw	a5,0(a5)
    80204d24:	14079463          	bnez	a5,80204e6c <alloc_proc+0x178>
            p->pid = i;
    80204d28:	fe043783          	ld	a5,-32(s0)
    80204d2c:	fec42703          	lw	a4,-20(s0)
    80204d30:	c3d8                	sw	a4,4(a5)
            p->state = USED;
    80204d32:	fe043783          	ld	a5,-32(s0)
    80204d36:	4705                	li	a4,1
    80204d38:	c398                	sw	a4,0(a5)
			p->is_user = is_user;
    80204d3a:	fe043783          	ld	a5,-32(s0)
    80204d3e:	fcc42703          	lw	a4,-52(s0)
    80204d42:	0ae7a423          	sw	a4,168(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    80204d46:	ffffe097          	auipc	ra,0xffffe
    80204d4a:	4e0080e7          	jalr	1248(ra) # 80203226 <alloc_page>
    80204d4e:	872a                	mv	a4,a0
    80204d50:	fe043783          	ld	a5,-32(s0)
    80204d54:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    80204d56:	fe043783          	ld	a5,-32(s0)
    80204d5a:	63fc                	ld	a5,192(a5)
    80204d5c:	eb99                	bnez	a5,80204d72 <alloc_proc+0x7e>
                p->state = UNUSED;
    80204d5e:	fe043783          	ld	a5,-32(s0)
    80204d62:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80204d66:	fe043783          	ld	a5,-32(s0)
    80204d6a:	0007a223          	sw	zero,4(a5)
                return 0;
    80204d6e:	4781                	li	a5,0
    80204d70:	aa19                	j	80204e86 <alloc_proc+0x192>
			if(p->is_user){
    80204d72:	fe043783          	ld	a5,-32(s0)
    80204d76:	0a87a783          	lw	a5,168(a5)
    80204d7a:	c3b9                	beqz	a5,80204dc0 <alloc_proc+0xcc>
				p->pagetable = create_pagetable();
    80204d7c:	ffffd097          	auipc	ra,0xffffd
    80204d80:	2fe080e7          	jalr	766(ra) # 8020207a <create_pagetable>
    80204d84:	872a                	mv	a4,a0
    80204d86:	fe043783          	ld	a5,-32(s0)
    80204d8a:	ffd8                	sd	a4,184(a5)
				if(p->pagetable == 0){
    80204d8c:	fe043783          	ld	a5,-32(s0)
    80204d90:	7fdc                	ld	a5,184(a5)
    80204d92:	ef9d                	bnez	a5,80204dd0 <alloc_proc+0xdc>
					free_page(p->trapframe);
    80204d94:	fe043783          	ld	a5,-32(s0)
    80204d98:	63fc                	ld	a5,192(a5)
    80204d9a:	853e                	mv	a0,a5
    80204d9c:	ffffe097          	auipc	ra,0xffffe
    80204da0:	4f6080e7          	jalr	1270(ra) # 80203292 <free_page>
					p->trapframe = 0;
    80204da4:	fe043783          	ld	a5,-32(s0)
    80204da8:	0c07b023          	sd	zero,192(a5)
					p->state = UNUSED;
    80204dac:	fe043783          	ld	a5,-32(s0)
    80204db0:	0007a023          	sw	zero,0(a5)
					p->pid = 0;
    80204db4:	fe043783          	ld	a5,-32(s0)
    80204db8:	0007a223          	sw	zero,4(a5)
					return 0;
    80204dbc:	4781                	li	a5,0
    80204dbe:	a0e1                	j	80204e86 <alloc_proc+0x192>
				p->pagetable = kernel_pagetable;
    80204dc0:	0000a797          	auipc	a5,0xa
    80204dc4:	2d078793          	addi	a5,a5,720 # 8020f090 <kernel_pagetable>
    80204dc8:	6398                	ld	a4,0(a5)
    80204dca:	fe043783          	ld	a5,-32(s0)
    80204dce:	ffd8                	sd	a4,184(a5)
            void *kstack_mem = alloc_page();
    80204dd0:	ffffe097          	auipc	ra,0xffffe
    80204dd4:	456080e7          	jalr	1110(ra) # 80203226 <alloc_page>
    80204dd8:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    80204ddc:	fd843783          	ld	a5,-40(s0)
    80204de0:	e3b9                	bnez	a5,80204e26 <alloc_proc+0x132>
                free_page(p->trapframe);
    80204de2:	fe043783          	ld	a5,-32(s0)
    80204de6:	63fc                	ld	a5,192(a5)
    80204de8:	853e                	mv	a0,a5
    80204dea:	ffffe097          	auipc	ra,0xffffe
    80204dee:	4a8080e7          	jalr	1192(ra) # 80203292 <free_page>
                free_pagetable(p->pagetable);
    80204df2:	fe043783          	ld	a5,-32(s0)
    80204df6:	7fdc                	ld	a5,184(a5)
    80204df8:	853e                	mv	a0,a5
    80204dfa:	ffffd097          	auipc	ra,0xffffd
    80204dfe:	664080e7          	jalr	1636(ra) # 8020245e <free_pagetable>
                p->trapframe = 0;
    80204e02:	fe043783          	ld	a5,-32(s0)
    80204e06:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    80204e0a:	fe043783          	ld	a5,-32(s0)
    80204e0e:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    80204e12:	fe043783          	ld	a5,-32(s0)
    80204e16:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80204e1a:	fe043783          	ld	a5,-32(s0)
    80204e1e:	0007a223          	sw	zero,4(a5)
                return 0;
    80204e22:	4781                	li	a5,0
    80204e24:	a08d                	j	80204e86 <alloc_proc+0x192>
            p->kstack = (uint64)kstack_mem;
    80204e26:	fd843703          	ld	a4,-40(s0)
    80204e2a:	fe043783          	ld	a5,-32(s0)
    80204e2e:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    80204e30:	fe043783          	ld	a5,-32(s0)
    80204e34:	07c1                	addi	a5,a5,16
    80204e36:	07000613          	li	a2,112
    80204e3a:	4581                	li	a1,0
    80204e3c:	853e                	mv	a0,a5
    80204e3e:	ffffd097          	auipc	ra,0xffffd
    80204e42:	fe0080e7          	jalr	-32(ra) # 80201e1e <memset>
            p->context.ra = (uint64)forkret;
    80204e46:	00000717          	auipc	a4,0x0
    80204e4a:	c6a70713          	addi	a4,a4,-918 # 80204ab0 <forkret>
    80204e4e:	fe043783          	ld	a5,-32(s0)
    80204e52:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    80204e54:	fe043783          	ld	a5,-32(s0)
    80204e58:	6798                	ld	a4,8(a5)
    80204e5a:	6785                	lui	a5,0x1
    80204e5c:	17c1                	addi	a5,a5,-16 # ff0 <_entry-0x801ff010>
    80204e5e:	973e                	add	a4,a4,a5
    80204e60:	fe043783          	ld	a5,-32(s0)
    80204e64:	ef98                	sd	a4,24(a5)
            return p;
    80204e66:	fe043783          	ld	a5,-32(s0)
    80204e6a:	a831                	j	80204e86 <alloc_proc+0x192>
    for(int i = 0;i<PROC;i++) {
    80204e6c:	fec42783          	lw	a5,-20(s0)
    80204e70:	2785                	addiw	a5,a5,1
    80204e72:	fef42623          	sw	a5,-20(s0)
    80204e76:	fec42783          	lw	a5,-20(s0)
    80204e7a:	0007871b          	sext.w	a4,a5
    80204e7e:	47fd                	li	a5,31
    80204e80:	e8e7d4e3          	bge	a5,a4,80204d08 <alloc_proc+0x14>
    return 0;
    80204e84:	4781                	li	a5,0
}
    80204e86:	853e                	mv	a0,a5
    80204e88:	70e2                	ld	ra,56(sp)
    80204e8a:	7442                	ld	s0,48(sp)
    80204e8c:	6121                	addi	sp,sp,64
    80204e8e:	8082                	ret

0000000080204e90 <free_proc>:
void free_proc(struct proc *p){
    80204e90:	1101                	addi	sp,sp,-32
    80204e92:	ec06                	sd	ra,24(sp)
    80204e94:	e822                	sd	s0,16(sp)
    80204e96:	1000                	addi	s0,sp,32
    80204e98:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    80204e9c:	fe843783          	ld	a5,-24(s0)
    80204ea0:	63fc                	ld	a5,192(a5)
    80204ea2:	cb89                	beqz	a5,80204eb4 <free_proc+0x24>
        free_page(p->trapframe);
    80204ea4:	fe843783          	ld	a5,-24(s0)
    80204ea8:	63fc                	ld	a5,192(a5)
    80204eaa:	853e                	mv	a0,a5
    80204eac:	ffffe097          	auipc	ra,0xffffe
    80204eb0:	3e6080e7          	jalr	998(ra) # 80203292 <free_page>
    p->trapframe = 0;
    80204eb4:	fe843783          	ld	a5,-24(s0)
    80204eb8:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable && p->pagetable != kernel_pagetable)
    80204ebc:	fe843783          	ld	a5,-24(s0)
    80204ec0:	7fdc                	ld	a5,184(a5)
    80204ec2:	c39d                	beqz	a5,80204ee8 <free_proc+0x58>
    80204ec4:	fe843783          	ld	a5,-24(s0)
    80204ec8:	7fd8                	ld	a4,184(a5)
    80204eca:	0000a797          	auipc	a5,0xa
    80204ece:	1c678793          	addi	a5,a5,454 # 8020f090 <kernel_pagetable>
    80204ed2:	639c                	ld	a5,0(a5)
    80204ed4:	00f70a63          	beq	a4,a5,80204ee8 <free_proc+0x58>
        free_pagetable(p->pagetable);
    80204ed8:	fe843783          	ld	a5,-24(s0)
    80204edc:	7fdc                	ld	a5,184(a5)
    80204ede:	853e                	mv	a0,a5
    80204ee0:	ffffd097          	auipc	ra,0xffffd
    80204ee4:	57e080e7          	jalr	1406(ra) # 8020245e <free_pagetable>
    p->pagetable = 0;
    80204ee8:	fe843783          	ld	a5,-24(s0)
    80204eec:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    80204ef0:	fe843783          	ld	a5,-24(s0)
    80204ef4:	679c                	ld	a5,8(a5)
    80204ef6:	cb89                	beqz	a5,80204f08 <free_proc+0x78>
        free_page((void*)p->kstack);
    80204ef8:	fe843783          	ld	a5,-24(s0)
    80204efc:	679c                	ld	a5,8(a5)
    80204efe:	853e                	mv	a0,a5
    80204f00:	ffffe097          	auipc	ra,0xffffe
    80204f04:	392080e7          	jalr	914(ra) # 80203292 <free_page>
    p->kstack = 0;
    80204f08:	fe843783          	ld	a5,-24(s0)
    80204f0c:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    80204f10:	fe843783          	ld	a5,-24(s0)
    80204f14:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    80204f18:	fe843783          	ld	a5,-24(s0)
    80204f1c:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    80204f20:	fe843783          	ld	a5,-24(s0)
    80204f24:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    80204f28:	fe843783          	ld	a5,-24(s0)
    80204f2c:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    80204f30:	fe843783          	ld	a5,-24(s0)
    80204f34:	07c1                	addi	a5,a5,16
    80204f36:	07000613          	li	a2,112
    80204f3a:	4581                	li	a1,0
    80204f3c:	853e                	mv	a0,a5
    80204f3e:	ffffd097          	auipc	ra,0xffffd
    80204f42:	ee0080e7          	jalr	-288(ra) # 80201e1e <memset>
}
    80204f46:	0001                	nop
    80204f48:	60e2                	ld	ra,24(sp)
    80204f4a:	6442                	ld	s0,16(sp)
    80204f4c:	6105                	addi	sp,sp,32
    80204f4e:	8082                	ret

0000000080204f50 <create_kernel_proc>:
int create_kernel_proc(void (*entry)(void)) {
    80204f50:	7179                	addi	sp,sp,-48
    80204f52:	f406                	sd	ra,40(sp)
    80204f54:	f022                	sd	s0,32(sp)
    80204f56:	1800                	addi	s0,sp,48
    80204f58:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc(0);
    80204f5c:	4501                	li	a0,0
    80204f5e:	00000097          	auipc	ra,0x0
    80204f62:	d96080e7          	jalr	-618(ra) # 80204cf4 <alloc_proc>
    80204f66:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    80204f6a:	fe843783          	ld	a5,-24(s0)
    80204f6e:	e399                	bnez	a5,80204f74 <create_kernel_proc+0x24>
    80204f70:	57fd                	li	a5,-1
    80204f72:	a089                	j	80204fb4 <create_kernel_proc+0x64>
    p->trapframe->epc = (uint64)entry;
    80204f74:	fe843783          	ld	a5,-24(s0)
    80204f78:	63fc                	ld	a5,192(a5)
    80204f7a:	fd843703          	ld	a4,-40(s0)
    80204f7e:	f398                	sd	a4,32(a5)
    p->state = RUNNABLE;
    80204f80:	fe843783          	ld	a5,-24(s0)
    80204f84:	470d                	li	a4,3
    80204f86:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    80204f88:	00000097          	auipc	ra,0x0
    80204f8c:	9c8080e7          	jalr	-1592(ra) # 80204950 <myproc>
    80204f90:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    80204f94:	fe043783          	ld	a5,-32(s0)
    80204f98:	c799                	beqz	a5,80204fa6 <create_kernel_proc+0x56>
        p->parent = parent;
    80204f9a:	fe843783          	ld	a5,-24(s0)
    80204f9e:	fe043703          	ld	a4,-32(s0)
    80204fa2:	efd8                	sd	a4,152(a5)
    80204fa4:	a029                	j	80204fae <create_kernel_proc+0x5e>
        p->parent = NULL;
    80204fa6:	fe843783          	ld	a5,-24(s0)
    80204faa:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    80204fae:	fe843783          	ld	a5,-24(s0)
    80204fb2:	43dc                	lw	a5,4(a5)
}
    80204fb4:	853e                	mv	a0,a5
    80204fb6:	70a2                	ld	ra,40(sp)
    80204fb8:	7402                	ld	s0,32(sp)
    80204fba:	6145                	addi	sp,sp,48
    80204fbc:	8082                	ret

0000000080204fbe <create_user_proc>:
int create_user_proc(const void *user_bin, int bin_size) {
    80204fbe:	715d                	addi	sp,sp,-80
    80204fc0:	e486                	sd	ra,72(sp)
    80204fc2:	e0a2                	sd	s0,64(sp)
    80204fc4:	0880                	addi	s0,sp,80
    80204fc6:	faa43c23          	sd	a0,-72(s0)
    80204fca:	87ae                	mv	a5,a1
    80204fcc:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = alloc_proc(1); // 1 表示用户进程
    80204fd0:	4505                	li	a0,1
    80204fd2:	00000097          	auipc	ra,0x0
    80204fd6:	d22080e7          	jalr	-734(ra) # 80204cf4 <alloc_proc>
    80204fda:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    80204fde:	fe843783          	ld	a5,-24(s0)
    80204fe2:	e399                	bnez	a5,80204fe8 <create_user_proc+0x2a>
    80204fe4:	57fd                	li	a5,-1
    80204fe6:	a2d1                	j	802051aa <create_user_proc+0x1ec>
    uint64 user_entry = 0x10000;
    80204fe8:	67c1                	lui	a5,0x10
    80204fea:	fef43023          	sd	a5,-32(s0)
    uint64 user_stack = 0x20000;
    80204fee:	000207b7          	lui	a5,0x20
    80204ff2:	fcf43c23          	sd	a5,-40(s0)
    void *page = alloc_page();
    80204ff6:	ffffe097          	auipc	ra,0xffffe
    80204ffa:	230080e7          	jalr	560(ra) # 80203226 <alloc_page>
    80204ffe:	fca43823          	sd	a0,-48(s0)
    if (!page) { free_proc(p); return -1; }
    80205002:	fd043783          	ld	a5,-48(s0)
    80205006:	eb89                	bnez	a5,80205018 <create_user_proc+0x5a>
    80205008:	fe843503          	ld	a0,-24(s0)
    8020500c:	00000097          	auipc	ra,0x0
    80205010:	e84080e7          	jalr	-380(ra) # 80204e90 <free_proc>
    80205014:	57fd                	li	a5,-1
    80205016:	aa51                	j	802051aa <create_user_proc+0x1ec>
    map_page(p->pagetable, user_entry, (uint64)page, PTE_R | PTE_W | PTE_X | PTE_U);
    80205018:	fe843783          	ld	a5,-24(s0)
    8020501c:	7fdc                	ld	a5,184(a5)
    8020501e:	fd043703          	ld	a4,-48(s0)
    80205022:	46f9                	li	a3,30
    80205024:	863a                	mv	a2,a4
    80205026:	fe043583          	ld	a1,-32(s0)
    8020502a:	853e                	mv	a0,a5
    8020502c:	ffffd097          	auipc	ra,0xffffd
    80205030:	2be080e7          	jalr	702(ra) # 802022ea <map_page>
    memcpy((void*)page, user_bin, bin_size);
    80205034:	fb442783          	lw	a5,-76(s0)
    80205038:	863e                	mv	a2,a5
    8020503a:	fb843583          	ld	a1,-72(s0)
    8020503e:	fd043503          	ld	a0,-48(s0)
    80205042:	ffffd097          	auipc	ra,0xffffd
    80205046:	ee8080e7          	jalr	-280(ra) # 80201f2a <memcpy>
    void *stack_page = alloc_page();
    8020504a:	ffffe097          	auipc	ra,0xffffe
    8020504e:	1dc080e7          	jalr	476(ra) # 80203226 <alloc_page>
    80205052:	fca43423          	sd	a0,-56(s0)
    if (!stack_page) { free_proc(p); return -1; }
    80205056:	fc843783          	ld	a5,-56(s0)
    8020505a:	eb89                	bnez	a5,8020506c <create_user_proc+0xae>
    8020505c:	fe843503          	ld	a0,-24(s0)
    80205060:	00000097          	auipc	ra,0x0
    80205064:	e30080e7          	jalr	-464(ra) # 80204e90 <free_proc>
    80205068:	57fd                	li	a5,-1
    8020506a:	a281                	j	802051aa <create_user_proc+0x1ec>
    map_page(p->pagetable, user_stack - PGSIZE, (uint64)stack_page, PTE_R | PTE_W | PTE_U);
    8020506c:	fe843783          	ld	a5,-24(s0)
    80205070:	7fc8                	ld	a0,184(a5)
    80205072:	fd843703          	ld	a4,-40(s0)
    80205076:	77fd                	lui	a5,0xfffff
    80205078:	97ba                	add	a5,a5,a4
    8020507a:	fc843703          	ld	a4,-56(s0)
    8020507e:	46d9                	li	a3,22
    80205080:	863a                	mv	a2,a4
    80205082:	85be                	mv	a1,a5
    80205084:	ffffd097          	auipc	ra,0xffffd
    80205088:	266080e7          	jalr	614(ra) # 802022ea <map_page>
	p->sz = user_stack; // 用户空间从 0x10000 到 0x20000
    8020508c:	fe843783          	ld	a5,-24(s0)
    80205090:	fd843703          	ld	a4,-40(s0)
    80205094:	fbd8                	sd	a4,176(a5)
    if (map_page(p->pagetable, TRAPFRAME, (uint64)p->trapframe, PTE_R | PTE_W) != 0) {
    80205096:	fe843783          	ld	a5,-24(s0)
    8020509a:	7fd8                	ld	a4,184(a5)
    8020509c:	fe843783          	ld	a5,-24(s0)
    802050a0:	63fc                	ld	a5,192(a5)
    802050a2:	4699                	li	a3,6
    802050a4:	863e                	mv	a2,a5
    802050a6:	75f9                	lui	a1,0xffffe
    802050a8:	853a                	mv	a0,a4
    802050aa:	ffffd097          	auipc	ra,0xffffd
    802050ae:	240080e7          	jalr	576(ra) # 802022ea <map_page>
    802050b2:	87aa                	mv	a5,a0
    802050b4:	cb89                	beqz	a5,802050c6 <create_user_proc+0x108>
        free_proc(p);
    802050b6:	fe843503          	ld	a0,-24(s0)
    802050ba:	00000097          	auipc	ra,0x0
    802050be:	dd6080e7          	jalr	-554(ra) # 80204e90 <free_proc>
        return -1;
    802050c2:	57fd                	li	a5,-1
    802050c4:	a0dd                	j	802051aa <create_user_proc+0x1ec>
	memset(p->trapframe, 0, sizeof(*p->trapframe));
    802050c6:	fe843783          	ld	a5,-24(s0)
    802050ca:	63fc                	ld	a5,192(a5)
    802050cc:	11800613          	li	a2,280
    802050d0:	4581                	li	a1,0
    802050d2:	853e                	mv	a0,a5
    802050d4:	ffffd097          	auipc	ra,0xffffd
    802050d8:	d4a080e7          	jalr	-694(ra) # 80201e1e <memset>
	p->trapframe->epc = user_entry; // 应为 0x10000
    802050dc:	fe843783          	ld	a5,-24(s0)
    802050e0:	63fc                	ld	a5,192(a5)
    802050e2:	fe043703          	ld	a4,-32(s0)
    802050e6:	f398                	sd	a4,32(a5)
	p->trapframe->sp = user_stack;  // 应为 0x20000
    802050e8:	fe843783          	ld	a5,-24(s0)
    802050ec:	63fc                	ld	a5,192(a5)
    802050ee:	fd843703          	ld	a4,-40(s0)
    802050f2:	ff98                	sd	a4,56(a5)
	p->trapframe->sstatus = (1UL << 5); // 0x20
    802050f4:	fe843783          	ld	a5,-24(s0)
    802050f8:	63fc                	ld	a5,192(a5)
    802050fa:	02000713          	li	a4,32
    802050fe:	ef98                	sd	a4,24(a5)
	p->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable);
    80205100:	0000a797          	auipc	a5,0xa
    80205104:	f9078793          	addi	a5,a5,-112 # 8020f090 <kernel_pagetable>
    80205108:	639c                	ld	a5,0(a5)
    8020510a:	00c7d693          	srli	a3,a5,0xc
    8020510e:	fe843783          	ld	a5,-24(s0)
    80205112:	63fc                	ld	a5,192(a5)
    80205114:	577d                	li	a4,-1
    80205116:	177e                	slli	a4,a4,0x3f
    80205118:	8f55                	or	a4,a4,a3
    8020511a:	e398                	sd	a4,0(a5)
	p->trapframe->kernel_sp = p->kstack + PGSIZE;   // 内核栈顶
    8020511c:	fe843783          	ld	a5,-24(s0)
    80205120:	6794                	ld	a3,8(a5)
    80205122:	fe843783          	ld	a5,-24(s0)
    80205126:	63fc                	ld	a5,192(a5)
    80205128:	6705                	lui	a4,0x1
    8020512a:	9736                	add	a4,a4,a3
    8020512c:	e798                	sd	a4,8(a5)
	p->trapframe->usertrap  = (uint64)usertrap;     // C 层 trap 处理函数
    8020512e:	fe843783          	ld	a5,-24(s0)
    80205132:	63fc                	ld	a5,192(a5)
    80205134:	fffff717          	auipc	a4,0xfffff
    80205138:	0ce70713          	addi	a4,a4,206 # 80204202 <usertrap>
    8020513c:	10e7b423          	sd	a4,264(a5)
	p->trapframe->kernel_vec = (uint64)kernelvec;
    80205140:	fe843783          	ld	a5,-24(s0)
    80205144:	63fc                	ld	a5,192(a5)
    80205146:	fffff717          	auipc	a4,0xfffff
    8020514a:	4da70713          	addi	a4,a4,1242 # 80204620 <kernelvec>
    8020514e:	10e7b823          	sd	a4,272(a5)
    p->state = RUNNABLE;
    80205152:	fe843783          	ld	a5,-24(s0)
    80205156:	470d                	li	a4,3
    80205158:	c398                	sw	a4,0(a5)
	if (map_page(p->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_X | PTE_R) != 0) {
    8020515a:	fe843783          	ld	a5,-24(s0)
    8020515e:	7fd8                	ld	a4,184(a5)
    80205160:	0000a797          	auipc	a5,0xa
    80205164:	f3878793          	addi	a5,a5,-200 # 8020f098 <trampoline_phys_addr>
    80205168:	639c                	ld	a5,0(a5)
    8020516a:	46a9                	li	a3,10
    8020516c:	863e                	mv	a2,a5
    8020516e:	75fd                	lui	a1,0xfffff
    80205170:	853a                	mv	a0,a4
    80205172:	ffffd097          	auipc	ra,0xffffd
    80205176:	178080e7          	jalr	376(ra) # 802022ea <map_page>
    8020517a:	87aa                	mv	a5,a0
    8020517c:	cb89                	beqz	a5,8020518e <create_user_proc+0x1d0>
		free_proc(p);
    8020517e:	fe843503          	ld	a0,-24(s0)
    80205182:	00000097          	auipc	ra,0x0
    80205186:	d0e080e7          	jalr	-754(ra) # 80204e90 <free_proc>
		return -1;
    8020518a:	57fd                	li	a5,-1
    8020518c:	a839                	j	802051aa <create_user_proc+0x1ec>
    struct proc *parent = myproc();
    8020518e:	fffff097          	auipc	ra,0xfffff
    80205192:	7c2080e7          	jalr	1986(ra) # 80204950 <myproc>
    80205196:	fca43023          	sd	a0,-64(s0)
    p->parent = parent ? parent : NULL;
    8020519a:	fe843783          	ld	a5,-24(s0)
    8020519e:	fc043703          	ld	a4,-64(s0)
    802051a2:	efd8                	sd	a4,152(a5)
    return p->pid;
    802051a4:	fe843783          	ld	a5,-24(s0)
    802051a8:	43dc                	lw	a5,4(a5)
}
    802051aa:	853e                	mv	a0,a5
    802051ac:	60a6                	ld	ra,72(sp)
    802051ae:	6406                	ld	s0,64(sp)
    802051b0:	6161                	addi	sp,sp,80
    802051b2:	8082                	ret

00000000802051b4 <fork_proc>:
int fork_proc(void) {
    802051b4:	7179                	addi	sp,sp,-48
    802051b6:	f406                	sd	ra,40(sp)
    802051b8:	f022                	sd	s0,32(sp)
    802051ba:	1800                	addi	s0,sp,48
    struct proc *parent = myproc();
    802051bc:	fffff097          	auipc	ra,0xfffff
    802051c0:	794080e7          	jalr	1940(ra) # 80204950 <myproc>
    802051c4:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc(parent->is_user);
    802051c8:	fe843783          	ld	a5,-24(s0)
    802051cc:	0a87a783          	lw	a5,168(a5)
    802051d0:	853e                	mv	a0,a5
    802051d2:	00000097          	auipc	ra,0x0
    802051d6:	b22080e7          	jalr	-1246(ra) # 80204cf4 <alloc_proc>
    802051da:	fea43023          	sd	a0,-32(s0)
    if (!child) return -1;
    802051de:	fe043783          	ld	a5,-32(s0)
    802051e2:	e399                	bnez	a5,802051e8 <fork_proc+0x34>
    802051e4:	57fd                	li	a5,-1
    802051e6:	a279                	j	80205374 <fork_proc+0x1c0>
    if (uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0) {
    802051e8:	fe843783          	ld	a5,-24(s0)
    802051ec:	7fd8                	ld	a4,184(a5)
    802051ee:	fe043783          	ld	a5,-32(s0)
    802051f2:	7fd4                	ld	a3,184(a5)
    802051f4:	fe843783          	ld	a5,-24(s0)
    802051f8:	7bdc                	ld	a5,176(a5)
    802051fa:	863e                	mv	a2,a5
    802051fc:	85b6                	mv	a1,a3
    802051fe:	853a                	mv	a0,a4
    80205200:	ffffe097          	auipc	ra,0xffffe
    80205204:	e56080e7          	jalr	-426(ra) # 80203056 <uvmcopy>
    80205208:	87aa                	mv	a5,a0
    8020520a:	0007da63          	bgez	a5,8020521e <fork_proc+0x6a>
        free_proc(child);
    8020520e:	fe043503          	ld	a0,-32(s0)
    80205212:	00000097          	auipc	ra,0x0
    80205216:	c7e080e7          	jalr	-898(ra) # 80204e90 <free_proc>
        return -1;
    8020521a:	57fd                	li	a5,-1
    8020521c:	aaa1                	j	80205374 <fork_proc+0x1c0>
    child->sz = parent->sz;
    8020521e:	fe843783          	ld	a5,-24(s0)
    80205222:	7bd8                	ld	a4,176(a5)
    80205224:	fe043783          	ld	a5,-32(s0)
    80205228:	fbd8                	sd	a4,176(a5)
    uint64 tf_pa = (uint64)child->trapframe;
    8020522a:	fe043783          	ld	a5,-32(s0)
    8020522e:	63fc                	ld	a5,192(a5)
    80205230:	fcf43c23          	sd	a5,-40(s0)
    if ((tf_pa & (PGSIZE - 1)) != 0) {
    80205234:	fd843703          	ld	a4,-40(s0)
    80205238:	6785                	lui	a5,0x1
    8020523a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    8020523c:	8ff9                	and	a5,a5,a4
    8020523e:	c39d                	beqz	a5,80205264 <fork_proc+0xb0>
        printf("[fork] trapframe not aligned: 0x%lx\n", tf_pa);
    80205240:	fd843583          	ld	a1,-40(s0)
    80205244:	00007517          	auipc	a0,0x7
    80205248:	f7c50513          	addi	a0,a0,-132 # 8020c1c0 <simple_user_task_bin+0x1b0>
    8020524c:	ffffc097          	auipc	ra,0xffffc
    80205250:	a48080e7          	jalr	-1464(ra) # 80200c94 <printf>
        free_proc(child);
    80205254:	fe043503          	ld	a0,-32(s0)
    80205258:	00000097          	auipc	ra,0x0
    8020525c:	c38080e7          	jalr	-968(ra) # 80204e90 <free_proc>
        return -1;
    80205260:	57fd                	li	a5,-1
    80205262:	aa09                	j	80205374 <fork_proc+0x1c0>
    if (map_page(child->pagetable, TRAPFRAME, tf_pa, PTE_R | PTE_W) != 0) {
    80205264:	fe043783          	ld	a5,-32(s0)
    80205268:	7fdc                	ld	a5,184(a5)
    8020526a:	4699                	li	a3,6
    8020526c:	fd843603          	ld	a2,-40(s0)
    80205270:	75f9                	lui	a1,0xffffe
    80205272:	853e                	mv	a0,a5
    80205274:	ffffd097          	auipc	ra,0xffffd
    80205278:	076080e7          	jalr	118(ra) # 802022ea <map_page>
    8020527c:	87aa                	mv	a5,a0
    8020527e:	c38d                	beqz	a5,802052a0 <fork_proc+0xec>
        printf("[fork] map TRAPFRAME failed\n");
    80205280:	00007517          	auipc	a0,0x7
    80205284:	f6850513          	addi	a0,a0,-152 # 8020c1e8 <simple_user_task_bin+0x1d8>
    80205288:	ffffc097          	auipc	ra,0xffffc
    8020528c:	a0c080e7          	jalr	-1524(ra) # 80200c94 <printf>
        free_proc(child);
    80205290:	fe043503          	ld	a0,-32(s0)
    80205294:	00000097          	auipc	ra,0x0
    80205298:	bfc080e7          	jalr	-1028(ra) # 80204e90 <free_proc>
        return -1;
    8020529c:	57fd                	li	a5,-1
    8020529e:	a8d9                	j	80205374 <fork_proc+0x1c0>
    if (map_page(child->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_R | PTE_X) != 0) {
    802052a0:	fe043783          	ld	a5,-32(s0)
    802052a4:	7fd8                	ld	a4,184(a5)
    802052a6:	0000a797          	auipc	a5,0xa
    802052aa:	df278793          	addi	a5,a5,-526 # 8020f098 <trampoline_phys_addr>
    802052ae:	639c                	ld	a5,0(a5)
    802052b0:	46a9                	li	a3,10
    802052b2:	863e                	mv	a2,a5
    802052b4:	75fd                	lui	a1,0xfffff
    802052b6:	853a                	mv	a0,a4
    802052b8:	ffffd097          	auipc	ra,0xffffd
    802052bc:	032080e7          	jalr	50(ra) # 802022ea <map_page>
    802052c0:	87aa                	mv	a5,a0
    802052c2:	c38d                	beqz	a5,802052e4 <fork_proc+0x130>
        printf("[fork] map TRAMPOLINE failed\n");
    802052c4:	00007517          	auipc	a0,0x7
    802052c8:	f4450513          	addi	a0,a0,-188 # 8020c208 <simple_user_task_bin+0x1f8>
    802052cc:	ffffc097          	auipc	ra,0xffffc
    802052d0:	9c8080e7          	jalr	-1592(ra) # 80200c94 <printf>
        free_proc(child);
    802052d4:	fe043503          	ld	a0,-32(s0)
    802052d8:	00000097          	auipc	ra,0x0
    802052dc:	bb8080e7          	jalr	-1096(ra) # 80204e90 <free_proc>
        return -1;
    802052e0:	57fd                	li	a5,-1
    802052e2:	a849                	j	80205374 <fork_proc+0x1c0>
    *(child->trapframe) = *(parent->trapframe);
    802052e4:	fe843783          	ld	a5,-24(s0)
    802052e8:	63f8                	ld	a4,192(a5)
    802052ea:	fe043783          	ld	a5,-32(s0)
    802052ee:	63fc                	ld	a5,192(a5)
    802052f0:	86be                	mv	a3,a5
    802052f2:	11800793          	li	a5,280
    802052f6:	863e                	mv	a2,a5
    802052f8:	85ba                	mv	a1,a4
    802052fa:	8536                	mv	a0,a3
    802052fc:	ffffd097          	auipc	ra,0xffffd
    80205300:	c2e080e7          	jalr	-978(ra) # 80201f2a <memcpy>
	child->trapframe->kernel_sp = child->kstack + PGSIZE;
    80205304:	fe043783          	ld	a5,-32(s0)
    80205308:	6794                	ld	a3,8(a5)
    8020530a:	fe043783          	ld	a5,-32(s0)
    8020530e:	63fc                	ld	a5,192(a5)
    80205310:	6705                	lui	a4,0x1
    80205312:	9736                	add	a4,a4,a3
    80205314:	e798                	sd	a4,8(a5)
	assert(child->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable));
    80205316:	0000a797          	auipc	a5,0xa
    8020531a:	d7a78793          	addi	a5,a5,-646 # 8020f090 <kernel_pagetable>
    8020531e:	639c                	ld	a5,0(a5)
    80205320:	00c7d693          	srli	a3,a5,0xc
    80205324:	fe043783          	ld	a5,-32(s0)
    80205328:	63fc                	ld	a5,192(a5)
    8020532a:	577d                	li	a4,-1
    8020532c:	177e                	slli	a4,a4,0x3f
    8020532e:	8f55                	or	a4,a4,a3
    80205330:	e398                	sd	a4,0(a5)
    80205332:	639c                	ld	a5,0(a5)
    80205334:	2781                	sext.w	a5,a5
    80205336:	853e                	mv	a0,a5
    80205338:	fffff097          	auipc	ra,0xfffff
    8020533c:	5a2080e7          	jalr	1442(ra) # 802048da <assert>
    child->trapframe->epc += 4;  // 跳过 ecall 指令
    80205340:	fe043783          	ld	a5,-32(s0)
    80205344:	63fc                	ld	a5,192(a5)
    80205346:	7398                	ld	a4,32(a5)
    80205348:	fe043783          	ld	a5,-32(s0)
    8020534c:	63fc                	ld	a5,192(a5)
    8020534e:	0711                	addi	a4,a4,4 # 1004 <_entry-0x801feffc>
    80205350:	f398                	sd	a4,32(a5)
    child->trapframe->a0 = 0;    // 子进程fork返回0
    80205352:	fe043783          	ld	a5,-32(s0)
    80205356:	63fc                	ld	a5,192(a5)
    80205358:	0607bc23          	sd	zero,120(a5)
    child->state = RUNNABLE;
    8020535c:	fe043783          	ld	a5,-32(s0)
    80205360:	470d                	li	a4,3
    80205362:	c398                	sw	a4,0(a5)
    child->parent = parent;
    80205364:	fe043783          	ld	a5,-32(s0)
    80205368:	fe843703          	ld	a4,-24(s0)
    8020536c:	efd8                	sd	a4,152(a5)
    return child->pid;
    8020536e:	fe043783          	ld	a5,-32(s0)
    80205372:	43dc                	lw	a5,4(a5)
}
    80205374:	853e                	mv	a0,a5
    80205376:	70a2                	ld	ra,40(sp)
    80205378:	7402                	ld	s0,32(sp)
    8020537a:	6145                	addi	sp,sp,48
    8020537c:	8082                	ret

000000008020537e <schedule>:
void schedule(void) {
    8020537e:	7179                	addi	sp,sp,-48
    80205380:	f406                	sd	ra,40(sp)
    80205382:	f022                	sd	s0,32(sp)
    80205384:	1800                	addi	s0,sp,48
  struct cpu *c = mycpu();
    80205386:	fffff097          	auipc	ra,0xfffff
    8020538a:	5e2080e7          	jalr	1506(ra) # 80204968 <mycpu>
    8020538e:	fea43423          	sd	a0,-24(s0)
  if (!initialized) {
    80205392:	0000a797          	auipc	a5,0xa
    80205396:	35678793          	addi	a5,a5,854 # 8020f6e8 <initialized.0>
    8020539a:	439c                	lw	a5,0(a5)
    8020539c:	ef85                	bnez	a5,802053d4 <schedule+0x56>
    if(c == 0) {
    8020539e:	fe843783          	ld	a5,-24(s0)
    802053a2:	eb89                	bnez	a5,802053b4 <schedule+0x36>
      panic("schedule: no current cpu");
    802053a4:	00007517          	auipc	a0,0x7
    802053a8:	e8450513          	addi	a0,a0,-380 # 8020c228 <simple_user_task_bin+0x218>
    802053ac:	ffffc097          	auipc	ra,0xffffc
    802053b0:	334080e7          	jalr	820(ra) # 802016e0 <panic>
    c->proc = 0;
    802053b4:	fe843783          	ld	a5,-24(s0)
    802053b8:	0007b023          	sd	zero,0(a5)
    current_proc = 0;
    802053bc:	0000a797          	auipc	a5,0xa
    802053c0:	cec78793          	addi	a5,a5,-788 # 8020f0a8 <current_proc>
    802053c4:	0007b023          	sd	zero,0(a5)
    initialized = 1;
    802053c8:	0000a797          	auipc	a5,0xa
    802053cc:	32078793          	addi	a5,a5,800 # 8020f6e8 <initialized.0>
    802053d0:	4705                	li	a4,1
    802053d2:	c398                	sw	a4,0(a5)
    intr_on();
    802053d4:	fffff097          	auipc	ra,0xfffff
    802053d8:	49a080e7          	jalr	1178(ra) # 8020486e <intr_on>
    for(int i = 0; i < PROC; i++) {
    802053dc:	fe042223          	sw	zero,-28(s0)
    802053e0:	a069                	j	8020546a <schedule+0xec>
        struct proc *p = proc_table[i];
    802053e2:	0000a717          	auipc	a4,0xa
    802053e6:	08670713          	addi	a4,a4,134 # 8020f468 <proc_table>
    802053ea:	fe442783          	lw	a5,-28(s0)
    802053ee:	078e                	slli	a5,a5,0x3
    802053f0:	97ba                	add	a5,a5,a4
    802053f2:	639c                	ld	a5,0(a5)
    802053f4:	fcf43c23          	sd	a5,-40(s0)
      	if(p->state == RUNNABLE) {
    802053f8:	fd843783          	ld	a5,-40(s0)
    802053fc:	439c                	lw	a5,0(a5)
    802053fe:	873e                	mv	a4,a5
    80205400:	478d                	li	a5,3
    80205402:	04f71f63          	bne	a4,a5,80205460 <schedule+0xe2>
			p->state = RUNNING;
    80205406:	fd843783          	ld	a5,-40(s0)
    8020540a:	4711                	li	a4,4
    8020540c:	c398                	sw	a4,0(a5)
			c->proc = p;
    8020540e:	fe843783          	ld	a5,-24(s0)
    80205412:	fd843703          	ld	a4,-40(s0)
    80205416:	e398                	sd	a4,0(a5)
			current_proc = p;
    80205418:	0000a797          	auipc	a5,0xa
    8020541c:	c9078793          	addi	a5,a5,-880 # 8020f0a8 <current_proc>
    80205420:	fd843703          	ld	a4,-40(s0)
    80205424:	e398                	sd	a4,0(a5)
			swtch(&c->context, &p->context);
    80205426:	fe843783          	ld	a5,-24(s0)
    8020542a:	00878713          	addi	a4,a5,8
    8020542e:	fd843783          	ld	a5,-40(s0)
    80205432:	07c1                	addi	a5,a5,16
    80205434:	85be                	mv	a1,a5
    80205436:	853a                	mv	a0,a4
    80205438:	fffff097          	auipc	ra,0xfffff
    8020543c:	398080e7          	jalr	920(ra) # 802047d0 <swtch>
			c = mycpu();
    80205440:	fffff097          	auipc	ra,0xfffff
    80205444:	528080e7          	jalr	1320(ra) # 80204968 <mycpu>
    80205448:	fea43423          	sd	a0,-24(s0)
			c->proc = 0;
    8020544c:	fe843783          	ld	a5,-24(s0)
    80205450:	0007b023          	sd	zero,0(a5)
			current_proc = 0;
    80205454:	0000a797          	auipc	a5,0xa
    80205458:	c5478793          	addi	a5,a5,-940 # 8020f0a8 <current_proc>
    8020545c:	0007b023          	sd	zero,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205460:	fe442783          	lw	a5,-28(s0)
    80205464:	2785                	addiw	a5,a5,1
    80205466:	fef42223          	sw	a5,-28(s0)
    8020546a:	fe442783          	lw	a5,-28(s0)
    8020546e:	0007871b          	sext.w	a4,a5
    80205472:	47fd                	li	a5,31
    80205474:	f6e7d7e3          	bge	a5,a4,802053e2 <schedule+0x64>
    intr_on();
    80205478:	bfb1                	j	802053d4 <schedule+0x56>

000000008020547a <yield>:
void yield(void) {
    8020547a:	1101                	addi	sp,sp,-32
    8020547c:	ec06                	sd	ra,24(sp)
    8020547e:	e822                	sd	s0,16(sp)
    80205480:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80205482:	fffff097          	auipc	ra,0xfffff
    80205486:	4ce080e7          	jalr	1230(ra) # 80204950 <myproc>
    8020548a:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    8020548e:	fe843783          	ld	a5,-24(s0)
    80205492:	c7cd                	beqz	a5,8020553c <yield+0xc2>
    if (p->state != RUNNING) {
    80205494:	fe843783          	ld	a5,-24(s0)
    80205498:	439c                	lw	a5,0(a5)
    8020549a:	873e                	mv	a4,a5
    8020549c:	4791                	li	a5,4
    8020549e:	00f70f63          	beq	a4,a5,802054bc <yield+0x42>
        warning("yield when status is not RUNNING (%d)\n", p->state);
    802054a2:	fe843783          	ld	a5,-24(s0)
    802054a6:	439c                	lw	a5,0(a5)
    802054a8:	85be                	mv	a1,a5
    802054aa:	00007517          	auipc	a0,0x7
    802054ae:	d9e50513          	addi	a0,a0,-610 # 8020c248 <simple_user_task_bin+0x238>
    802054b2:	ffffc097          	auipc	ra,0xffffc
    802054b6:	262080e7          	jalr	610(ra) # 80201714 <warning>
        return;
    802054ba:	a051                	j	8020553e <yield+0xc4>
    intr_off();
    802054bc:	fffff097          	auipc	ra,0xfffff
    802054c0:	3dc080e7          	jalr	988(ra) # 80204898 <intr_off>
    struct cpu *c = mycpu();
    802054c4:	fffff097          	auipc	ra,0xfffff
    802054c8:	4a4080e7          	jalr	1188(ra) # 80204968 <mycpu>
    802054cc:	fea43023          	sd	a0,-32(s0)
    p->state = RUNNABLE;
    802054d0:	fe843783          	ld	a5,-24(s0)
    802054d4:	470d                	li	a4,3
    802054d6:	c398                	sw	a4,0(a5)
    p->context.ra = ra;
    802054d8:	8706                	mv	a4,ra
    802054da:	fe843783          	ld	a5,-24(s0)
    802054de:	eb98                	sd	a4,16(a5)
    if (c->context.ra == 0) {
    802054e0:	fe043783          	ld	a5,-32(s0)
    802054e4:	679c                	ld	a5,8(a5)
    802054e6:	ef99                	bnez	a5,80205504 <yield+0x8a>
        c->context.ra = (uint64)schedule;
    802054e8:	00000717          	auipc	a4,0x0
    802054ec:	e9670713          	addi	a4,a4,-362 # 8020537e <schedule>
    802054f0:	fe043783          	ld	a5,-32(s0)
    802054f4:	e798                	sd	a4,8(a5)
        c->context.sp = (uint64)c + PGSIZE;
    802054f6:	fe043703          	ld	a4,-32(s0)
    802054fa:	6785                	lui	a5,0x1
    802054fc:	973e                	add	a4,a4,a5
    802054fe:	fe043783          	ld	a5,-32(s0)
    80205502:	eb98                	sd	a4,16(a5)
    current_proc = 0;
    80205504:	0000a797          	auipc	a5,0xa
    80205508:	ba478793          	addi	a5,a5,-1116 # 8020f0a8 <current_proc>
    8020550c:	0007b023          	sd	zero,0(a5)
    c->proc = 0;
    80205510:	fe043783          	ld	a5,-32(s0)
    80205514:	0007b023          	sd	zero,0(a5)
    swtch(&p->context, &c->context);
    80205518:	fe843783          	ld	a5,-24(s0)
    8020551c:	01078713          	addi	a4,a5,16
    80205520:	fe043783          	ld	a5,-32(s0)
    80205524:	07a1                	addi	a5,a5,8
    80205526:	85be                	mv	a1,a5
    80205528:	853a                	mv	a0,a4
    8020552a:	fffff097          	auipc	ra,0xfffff
    8020552e:	2a6080e7          	jalr	678(ra) # 802047d0 <swtch>
    intr_on();
    80205532:	fffff097          	auipc	ra,0xfffff
    80205536:	33c080e7          	jalr	828(ra) # 8020486e <intr_on>
    8020553a:	a011                	j	8020553e <yield+0xc4>
        return;
    8020553c:	0001                	nop
}
    8020553e:	60e2                	ld	ra,24(sp)
    80205540:	6442                	ld	s0,16(sp)
    80205542:	6105                	addi	sp,sp,32
    80205544:	8082                	ret

0000000080205546 <sleep>:
void sleep(void *chan){
    80205546:	7179                	addi	sp,sp,-48
    80205548:	f406                	sd	ra,40(sp)
    8020554a:	f022                	sd	s0,32(sp)
    8020554c:	1800                	addi	s0,sp,48
    8020554e:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = myproc();
    80205552:	fffff097          	auipc	ra,0xfffff
    80205556:	3fe080e7          	jalr	1022(ra) # 80204950 <myproc>
    8020555a:	fea43423          	sd	a0,-24(s0)
    struct cpu *c = mycpu();
    8020555e:	fffff097          	auipc	ra,0xfffff
    80205562:	40a080e7          	jalr	1034(ra) # 80204968 <mycpu>
    80205566:	fea43023          	sd	a0,-32(s0)
    p->context.ra = ra;
    8020556a:	8706                	mv	a4,ra
    8020556c:	fe843783          	ld	a5,-24(s0)
    80205570:	eb98                	sd	a4,16(a5)
    p->chan = chan;
    80205572:	fe843783          	ld	a5,-24(s0)
    80205576:	fd843703          	ld	a4,-40(s0)
    8020557a:	f3d8                	sd	a4,160(a5)
    p->state = SLEEPING;
    8020557c:	fe843783          	ld	a5,-24(s0)
    80205580:	4709                	li	a4,2
    80205582:	c398                	sw	a4,0(a5)
    swtch(&p->context, &c->context);
    80205584:	fe843783          	ld	a5,-24(s0)
    80205588:	01078713          	addi	a4,a5,16
    8020558c:	fe043783          	ld	a5,-32(s0)
    80205590:	07a1                	addi	a5,a5,8
    80205592:	85be                	mv	a1,a5
    80205594:	853a                	mv	a0,a4
    80205596:	fffff097          	auipc	ra,0xfffff
    8020559a:	23a080e7          	jalr	570(ra) # 802047d0 <swtch>
    p->chan = 0;
    8020559e:	fe843783          	ld	a5,-24(s0)
    802055a2:	0a07b023          	sd	zero,160(a5)
}
    802055a6:	0001                	nop
    802055a8:	70a2                	ld	ra,40(sp)
    802055aa:	7402                	ld	s0,32(sp)
    802055ac:	6145                	addi	sp,sp,48
    802055ae:	8082                	ret

00000000802055b0 <wakeup>:
void wakeup(void *chan) {
    802055b0:	7179                	addi	sp,sp,-48
    802055b2:	f422                	sd	s0,40(sp)
    802055b4:	1800                	addi	s0,sp,48
    802055b6:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < PROC; i++) {
    802055ba:	fe042623          	sw	zero,-20(s0)
    802055be:	a099                	j	80205604 <wakeup+0x54>
        struct proc *p = proc_table[i];
    802055c0:	0000a717          	auipc	a4,0xa
    802055c4:	ea870713          	addi	a4,a4,-344 # 8020f468 <proc_table>
    802055c8:	fec42783          	lw	a5,-20(s0)
    802055cc:	078e                	slli	a5,a5,0x3
    802055ce:	97ba                	add	a5,a5,a4
    802055d0:	639c                	ld	a5,0(a5)
    802055d2:	fef43023          	sd	a5,-32(s0)
        if(p->state == SLEEPING && p->chan == chan) {
    802055d6:	fe043783          	ld	a5,-32(s0)
    802055da:	439c                	lw	a5,0(a5)
    802055dc:	873e                	mv	a4,a5
    802055de:	4789                	li	a5,2
    802055e0:	00f71d63          	bne	a4,a5,802055fa <wakeup+0x4a>
    802055e4:	fe043783          	ld	a5,-32(s0)
    802055e8:	73dc                	ld	a5,160(a5)
    802055ea:	fd843703          	ld	a4,-40(s0)
    802055ee:	00f71663          	bne	a4,a5,802055fa <wakeup+0x4a>
            p->state = RUNNABLE;
    802055f2:	fe043783          	ld	a5,-32(s0)
    802055f6:	470d                	li	a4,3
    802055f8:	c398                	sw	a4,0(a5)
    for(int i = 0; i < PROC; i++) {
    802055fa:	fec42783          	lw	a5,-20(s0)
    802055fe:	2785                	addiw	a5,a5,1
    80205600:	fef42623          	sw	a5,-20(s0)
    80205604:	fec42783          	lw	a5,-20(s0)
    80205608:	0007871b          	sext.w	a4,a5
    8020560c:	47fd                	li	a5,31
    8020560e:	fae7d9e3          	bge	a5,a4,802055c0 <wakeup+0x10>
}
    80205612:	0001                	nop
    80205614:	0001                	nop
    80205616:	7422                	ld	s0,40(sp)
    80205618:	6145                	addi	sp,sp,48
    8020561a:	8082                	ret

000000008020561c <exit_proc>:
void exit_proc(int status) {
    8020561c:	7179                	addi	sp,sp,-48
    8020561e:	f406                	sd	ra,40(sp)
    80205620:	f022                	sd	s0,32(sp)
    80205622:	1800                	addi	s0,sp,48
    80205624:	87aa                	mv	a5,a0
    80205626:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    8020562a:	fffff097          	auipc	ra,0xfffff
    8020562e:	326080e7          	jalr	806(ra) # 80204950 <myproc>
    80205632:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205636:	fe843783          	ld	a5,-24(s0)
    8020563a:	eb89                	bnez	a5,8020564c <exit_proc+0x30>
        panic("exit_proc: no current process");
    8020563c:	00007517          	auipc	a0,0x7
    80205640:	c3450513          	addi	a0,a0,-972 # 8020c270 <simple_user_task_bin+0x260>
    80205644:	ffffc097          	auipc	ra,0xffffc
    80205648:	09c080e7          	jalr	156(ra) # 802016e0 <panic>
    p->exit_status = status;
    8020564c:	fe843783          	ld	a5,-24(s0)
    80205650:	fdc42703          	lw	a4,-36(s0)
    80205654:	08e7a223          	sw	a4,132(a5)
    if (!p->parent) {
    80205658:	fe843783          	ld	a5,-24(s0)
    8020565c:	6fdc                	ld	a5,152(a5)
    8020565e:	e789                	bnez	a5,80205668 <exit_proc+0x4c>
        shutdown();
    80205660:	fffff097          	auipc	ra,0xfffff
    80205664:	2c6080e7          	jalr	710(ra) # 80204926 <shutdown>
    p->state = ZOMBIE;
    80205668:	fe843783          	ld	a5,-24(s0)
    8020566c:	4715                	li	a4,5
    8020566e:	c398                	sw	a4,0(a5)
    wakeup((void*)p->parent);
    80205670:	fe843783          	ld	a5,-24(s0)
    80205674:	6fdc                	ld	a5,152(a5)
    80205676:	853e                	mv	a0,a5
    80205678:	00000097          	auipc	ra,0x0
    8020567c:	f38080e7          	jalr	-200(ra) # 802055b0 <wakeup>
    current_proc = 0;
    80205680:	0000a797          	auipc	a5,0xa
    80205684:	a2878793          	addi	a5,a5,-1496 # 8020f0a8 <current_proc>
    80205688:	0007b023          	sd	zero,0(a5)
    if (mycpu())
    8020568c:	fffff097          	auipc	ra,0xfffff
    80205690:	2dc080e7          	jalr	732(ra) # 80204968 <mycpu>
    80205694:	87aa                	mv	a5,a0
    80205696:	cb81                	beqz	a5,802056a6 <exit_proc+0x8a>
        mycpu()->proc = 0;
    80205698:	fffff097          	auipc	ra,0xfffff
    8020569c:	2d0080e7          	jalr	720(ra) # 80204968 <mycpu>
    802056a0:	87aa                	mv	a5,a0
    802056a2:	0007b023          	sd	zero,0(a5)
    struct cpu *c = mycpu();
    802056a6:	fffff097          	auipc	ra,0xfffff
    802056aa:	2c2080e7          	jalr	706(ra) # 80204968 <mycpu>
    802056ae:	fea43023          	sd	a0,-32(s0)
    swtch(&p->context, &c->context);
    802056b2:	fe843783          	ld	a5,-24(s0)
    802056b6:	01078713          	addi	a4,a5,16
    802056ba:	fe043783          	ld	a5,-32(s0)
    802056be:	07a1                	addi	a5,a5,8
    802056c0:	85be                	mv	a1,a5
    802056c2:	853a                	mv	a0,a4
    802056c4:	fffff097          	auipc	ra,0xfffff
    802056c8:	10c080e7          	jalr	268(ra) # 802047d0 <swtch>
    panic("exit_proc should not return after schedule");
    802056cc:	00007517          	auipc	a0,0x7
    802056d0:	bc450513          	addi	a0,a0,-1084 # 8020c290 <simple_user_task_bin+0x280>
    802056d4:	ffffc097          	auipc	ra,0xffffc
    802056d8:	00c080e7          	jalr	12(ra) # 802016e0 <panic>
}
    802056dc:	0001                	nop
    802056de:	70a2                	ld	ra,40(sp)
    802056e0:	7402                	ld	s0,32(sp)
    802056e2:	6145                	addi	sp,sp,48
    802056e4:	8082                	ret

00000000802056e6 <wait_proc>:
int wait_proc(int *status) {
    802056e6:	711d                	addi	sp,sp,-96
    802056e8:	ec86                	sd	ra,88(sp)
    802056ea:	e8a2                	sd	s0,80(sp)
    802056ec:	1080                	addi	s0,sp,96
    802056ee:	faa43423          	sd	a0,-88(s0)
    struct proc *p = myproc();
    802056f2:	fffff097          	auipc	ra,0xfffff
    802056f6:	25e080e7          	jalr	606(ra) # 80204950 <myproc>
    802056fa:	fca43023          	sd	a0,-64(s0)
    if (p == 0) {
    802056fe:	fc043783          	ld	a5,-64(s0)
    80205702:	eb99                	bnez	a5,80205718 <wait_proc+0x32>
        printf("Warning: wait_proc called with no current process\n");
    80205704:	00007517          	auipc	a0,0x7
    80205708:	bbc50513          	addi	a0,a0,-1092 # 8020c2c0 <simple_user_task_bin+0x2b0>
    8020570c:	ffffb097          	auipc	ra,0xffffb
    80205710:	588080e7          	jalr	1416(ra) # 80200c94 <printf>
        return -1;
    80205714:	57fd                	li	a5,-1
    80205716:	aa91                	j	8020586a <wait_proc+0x184>
        intr_off();
    80205718:	fffff097          	auipc	ra,0xfffff
    8020571c:	180080e7          	jalr	384(ra) # 80204898 <intr_off>
        int found_zombie = 0;
    80205720:	fe042623          	sw	zero,-20(s0)
        int zombie_pid = 0;
    80205724:	fe042423          	sw	zero,-24(s0)
        int zombie_status = 0;
    80205728:	fe042223          	sw	zero,-28(s0)
        struct proc *zombie_child = 0;
    8020572c:	fc043c23          	sd	zero,-40(s0)
        for (int i = 0; i < PROC; i++) {
    80205730:	fc042a23          	sw	zero,-44(s0)
    80205734:	a095                	j	80205798 <wait_proc+0xb2>
            struct proc *child = proc_table[i];
    80205736:	0000a717          	auipc	a4,0xa
    8020573a:	d3270713          	addi	a4,a4,-718 # 8020f468 <proc_table>
    8020573e:	fd442783          	lw	a5,-44(s0)
    80205742:	078e                	slli	a5,a5,0x3
    80205744:	97ba                	add	a5,a5,a4
    80205746:	639c                	ld	a5,0(a5)
    80205748:	faf43c23          	sd	a5,-72(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    8020574c:	fb843783          	ld	a5,-72(s0)
    80205750:	439c                	lw	a5,0(a5)
    80205752:	873e                	mv	a4,a5
    80205754:	4795                	li	a5,5
    80205756:	02f71c63          	bne	a4,a5,8020578e <wait_proc+0xa8>
    8020575a:	fb843783          	ld	a5,-72(s0)
    8020575e:	6fdc                	ld	a5,152(a5)
    80205760:	fc043703          	ld	a4,-64(s0)
    80205764:	02f71563          	bne	a4,a5,8020578e <wait_proc+0xa8>
                found_zombie = 1;
    80205768:	4785                	li	a5,1
    8020576a:	fef42623          	sw	a5,-20(s0)
                zombie_pid = child->pid;
    8020576e:	fb843783          	ld	a5,-72(s0)
    80205772:	43dc                	lw	a5,4(a5)
    80205774:	fef42423          	sw	a5,-24(s0)
                zombie_status = child->exit_status;
    80205778:	fb843783          	ld	a5,-72(s0)
    8020577c:	0847a783          	lw	a5,132(a5)
    80205780:	fef42223          	sw	a5,-28(s0)
                zombie_child = child;
    80205784:	fb843783          	ld	a5,-72(s0)
    80205788:	fcf43c23          	sd	a5,-40(s0)
                break;
    8020578c:	a829                	j	802057a6 <wait_proc+0xc0>
        for (int i = 0; i < PROC; i++) {
    8020578e:	fd442783          	lw	a5,-44(s0)
    80205792:	2785                	addiw	a5,a5,1
    80205794:	fcf42a23          	sw	a5,-44(s0)
    80205798:	fd442783          	lw	a5,-44(s0)
    8020579c:	0007871b          	sext.w	a4,a5
    802057a0:	47fd                	li	a5,31
    802057a2:	f8e7dae3          	bge	a5,a4,80205736 <wait_proc+0x50>
            }
        }
        
        if (found_zombie) {
    802057a6:	fec42783          	lw	a5,-20(s0)
    802057aa:	2781                	sext.w	a5,a5
    802057ac:	cb85                	beqz	a5,802057dc <wait_proc+0xf6>
            if (status)
    802057ae:	fa843783          	ld	a5,-88(s0)
    802057b2:	c791                	beqz	a5,802057be <wait_proc+0xd8>
                *status = zombie_status;
    802057b4:	fa843783          	ld	a5,-88(s0)
    802057b8:	fe442703          	lw	a4,-28(s0)
    802057bc:	c398                	sw	a4,0(a5)

            free_proc(zombie_child);
    802057be:	fd843503          	ld	a0,-40(s0)
    802057c2:	fffff097          	auipc	ra,0xfffff
    802057c6:	6ce080e7          	jalr	1742(ra) # 80204e90 <free_proc>
            zombie_child = NULL;
    802057ca:	fc043c23          	sd	zero,-40(s0)
            intr_on();
    802057ce:	fffff097          	auipc	ra,0xfffff
    802057d2:	0a0080e7          	jalr	160(ra) # 8020486e <intr_on>
            return zombie_pid;
    802057d6:	fe842783          	lw	a5,-24(s0)
    802057da:	a841                	j	8020586a <wait_proc+0x184>
        }
        
        // 检查是否有任何活跃的子进程（非ZOMBIE状态）
        int havekids = 0;
    802057dc:	fc042823          	sw	zero,-48(s0)
        for (int i = 0; i < PROC; i++) {
    802057e0:	fc042623          	sw	zero,-52(s0)
    802057e4:	a0b9                	j	80205832 <wait_proc+0x14c>
            struct proc *child = proc_table[i];
    802057e6:	0000a717          	auipc	a4,0xa
    802057ea:	c8270713          	addi	a4,a4,-894 # 8020f468 <proc_table>
    802057ee:	fcc42783          	lw	a5,-52(s0)
    802057f2:	078e                	slli	a5,a5,0x3
    802057f4:	97ba                	add	a5,a5,a4
    802057f6:	639c                	ld	a5,0(a5)
    802057f8:	faf43823          	sd	a5,-80(s0)
            if (child->state != UNUSED && child->state != ZOMBIE && child->parent == p) {
    802057fc:	fb043783          	ld	a5,-80(s0)
    80205800:	439c                	lw	a5,0(a5)
    80205802:	c39d                	beqz	a5,80205828 <wait_proc+0x142>
    80205804:	fb043783          	ld	a5,-80(s0)
    80205808:	439c                	lw	a5,0(a5)
    8020580a:	873e                	mv	a4,a5
    8020580c:	4795                	li	a5,5
    8020580e:	00f70d63          	beq	a4,a5,80205828 <wait_proc+0x142>
    80205812:	fb043783          	ld	a5,-80(s0)
    80205816:	6fdc                	ld	a5,152(a5)
    80205818:	fc043703          	ld	a4,-64(s0)
    8020581c:	00f71663          	bne	a4,a5,80205828 <wait_proc+0x142>
                havekids = 1;
    80205820:	4785                	li	a5,1
    80205822:	fcf42823          	sw	a5,-48(s0)
                break;
    80205826:	a829                	j	80205840 <wait_proc+0x15a>
        for (int i = 0; i < PROC; i++) {
    80205828:	fcc42783          	lw	a5,-52(s0)
    8020582c:	2785                	addiw	a5,a5,1
    8020582e:	fcf42623          	sw	a5,-52(s0)
    80205832:	fcc42783          	lw	a5,-52(s0)
    80205836:	0007871b          	sext.w	a4,a5
    8020583a:	47fd                	li	a5,31
    8020583c:	fae7d5e3          	bge	a5,a4,802057e6 <wait_proc+0x100>
            }
        }
        
        if (!havekids) {
    80205840:	fd042783          	lw	a5,-48(s0)
    80205844:	2781                	sext.w	a5,a5
    80205846:	e799                	bnez	a5,80205854 <wait_proc+0x16e>
            intr_on();
    80205848:	fffff097          	auipc	ra,0xfffff
    8020584c:	026080e7          	jalr	38(ra) # 8020486e <intr_on>
            return -1;
    80205850:	57fd                	li	a5,-1
    80205852:	a821                	j	8020586a <wait_proc+0x184>
        }
        
        // 有活跃子进程但没有僵尸子进程，进入睡眠等待
		intr_on();
    80205854:	fffff097          	auipc	ra,0xfffff
    80205858:	01a080e7          	jalr	26(ra) # 8020486e <intr_on>
        sleep((void*)p);
    8020585c:	fc043503          	ld	a0,-64(s0)
    80205860:	00000097          	auipc	ra,0x0
    80205864:	ce6080e7          	jalr	-794(ra) # 80205546 <sleep>
    while (1) {
    80205868:	bd45                	j	80205718 <wait_proc+0x32>
    }
}
    8020586a:	853e                	mv	a0,a5
    8020586c:	60e6                	ld	ra,88(sp)
    8020586e:	6446                	ld	s0,80(sp)
    80205870:	6125                	addi	sp,sp,96
    80205872:	8082                	ret

0000000080205874 <print_proc_table>:

void print_proc_table(void) {
    80205874:	715d                	addi	sp,sp,-80
    80205876:	e486                	sd	ra,72(sp)
    80205878:	e0a2                	sd	s0,64(sp)
    8020587a:	0880                	addi	s0,sp,80
    int count = 0;
    8020587c:	fe042623          	sw	zero,-20(s0)
    printf("PID  TYPE STATUS     PPID   FUNC_ADDR      STACK_ADDR    \n");
    80205880:	00007517          	auipc	a0,0x7
    80205884:	a7850513          	addi	a0,a0,-1416 # 8020c2f8 <simple_user_task_bin+0x2e8>
    80205888:	ffffb097          	auipc	ra,0xffffb
    8020588c:	40c080e7          	jalr	1036(ra) # 80200c94 <printf>
    printf("----------------------------------------------------------\n");
    80205890:	00007517          	auipc	a0,0x7
    80205894:	aa850513          	addi	a0,a0,-1368 # 8020c338 <simple_user_task_bin+0x328>
    80205898:	ffffb097          	auipc	ra,0xffffb
    8020589c:	3fc080e7          	jalr	1020(ra) # 80200c94 <printf>
    for(int i = 0; i < PROC; i++) {
    802058a0:	fe042423          	sw	zero,-24(s0)
    802058a4:	a2a9                	j	802059ee <print_proc_table+0x17a>
        struct proc *p = proc_table[i];
    802058a6:	0000a717          	auipc	a4,0xa
    802058aa:	bc270713          	addi	a4,a4,-1086 # 8020f468 <proc_table>
    802058ae:	fe842783          	lw	a5,-24(s0)
    802058b2:	078e                	slli	a5,a5,0x3
    802058b4:	97ba                	add	a5,a5,a4
    802058b6:	639c                	ld	a5,0(a5)
    802058b8:	fcf43c23          	sd	a5,-40(s0)
        if(p->state != UNUSED) {
    802058bc:	fd843783          	ld	a5,-40(s0)
    802058c0:	439c                	lw	a5,0(a5)
    802058c2:	12078163          	beqz	a5,802059e4 <print_proc_table+0x170>
            count++;
    802058c6:	fec42783          	lw	a5,-20(s0)
    802058ca:	2785                	addiw	a5,a5,1
    802058cc:	fef42623          	sw	a5,-20(s0)
            const char *type = (p->is_user ? "USR" : "SYS");
    802058d0:	fd843783          	ld	a5,-40(s0)
    802058d4:	0a87a783          	lw	a5,168(a5)
    802058d8:	c791                	beqz	a5,802058e4 <print_proc_table+0x70>
    802058da:	00007797          	auipc	a5,0x7
    802058de:	a9e78793          	addi	a5,a5,-1378 # 8020c378 <simple_user_task_bin+0x368>
    802058e2:	a029                	j	802058ec <print_proc_table+0x78>
    802058e4:	00007797          	auipc	a5,0x7
    802058e8:	a9c78793          	addi	a5,a5,-1380 # 8020c380 <simple_user_task_bin+0x370>
    802058ec:	fcf43823          	sd	a5,-48(s0)
            const char *status;
            switch(p->state) {
    802058f0:	fd843783          	ld	a5,-40(s0)
    802058f4:	439c                	lw	a5,0(a5)
    802058f6:	86be                	mv	a3,a5
    802058f8:	4715                	li	a4,5
    802058fa:	06d76c63          	bltu	a4,a3,80205972 <print_proc_table+0xfe>
    802058fe:	00279713          	slli	a4,a5,0x2
    80205902:	00007797          	auipc	a5,0x7
    80205906:	b0678793          	addi	a5,a5,-1274 # 8020c408 <simple_user_task_bin+0x3f8>
    8020590a:	97ba                	add	a5,a5,a4
    8020590c:	439c                	lw	a5,0(a5)
    8020590e:	0007871b          	sext.w	a4,a5
    80205912:	00007797          	auipc	a5,0x7
    80205916:	af678793          	addi	a5,a5,-1290 # 8020c408 <simple_user_task_bin+0x3f8>
    8020591a:	97ba                	add	a5,a5,a4
    8020591c:	8782                	jr	a5
                case UNUSED:   status = "UNUSED"; break;
    8020591e:	00007797          	auipc	a5,0x7
    80205922:	a6a78793          	addi	a5,a5,-1430 # 8020c388 <simple_user_task_bin+0x378>
    80205926:	fef43023          	sd	a5,-32(s0)
    8020592a:	a899                	j	80205980 <print_proc_table+0x10c>
                case USED:     status = "USED"; break;
    8020592c:	00007797          	auipc	a5,0x7
    80205930:	a6478793          	addi	a5,a5,-1436 # 8020c390 <simple_user_task_bin+0x380>
    80205934:	fef43023          	sd	a5,-32(s0)
    80205938:	a0a1                	j	80205980 <print_proc_table+0x10c>
                case SLEEPING: status = "SLEEP"; break;
    8020593a:	00007797          	auipc	a5,0x7
    8020593e:	a5e78793          	addi	a5,a5,-1442 # 8020c398 <simple_user_task_bin+0x388>
    80205942:	fef43023          	sd	a5,-32(s0)
    80205946:	a82d                	j	80205980 <print_proc_table+0x10c>
                case RUNNABLE: status = "RUNNABLE"; break;
    80205948:	00007797          	auipc	a5,0x7
    8020594c:	a5878793          	addi	a5,a5,-1448 # 8020c3a0 <simple_user_task_bin+0x390>
    80205950:	fef43023          	sd	a5,-32(s0)
    80205954:	a035                	j	80205980 <print_proc_table+0x10c>
                case RUNNING:  status = "RUNNING"; break;
    80205956:	00007797          	auipc	a5,0x7
    8020595a:	a5a78793          	addi	a5,a5,-1446 # 8020c3b0 <simple_user_task_bin+0x3a0>
    8020595e:	fef43023          	sd	a5,-32(s0)
    80205962:	a839                	j	80205980 <print_proc_table+0x10c>
                case ZOMBIE:   status = "ZOMBIE"; break;
    80205964:	00007797          	auipc	a5,0x7
    80205968:	a5478793          	addi	a5,a5,-1452 # 8020c3b8 <simple_user_task_bin+0x3a8>
    8020596c:	fef43023          	sd	a5,-32(s0)
    80205970:	a801                	j	80205980 <print_proc_table+0x10c>
                default:       status = "UNKNOWN"; break;
    80205972:	00007797          	auipc	a5,0x7
    80205976:	a4e78793          	addi	a5,a5,-1458 # 8020c3c0 <simple_user_task_bin+0x3b0>
    8020597a:	fef43023          	sd	a5,-32(s0)
    8020597e:	0001                	nop
            }
            int ppid = p->parent ? p->parent->pid : -1;
    80205980:	fd843783          	ld	a5,-40(s0)
    80205984:	6fdc                	ld	a5,152(a5)
    80205986:	c791                	beqz	a5,80205992 <print_proc_table+0x11e>
    80205988:	fd843783          	ld	a5,-40(s0)
    8020598c:	6fdc                	ld	a5,152(a5)
    8020598e:	43dc                	lw	a5,4(a5)
    80205990:	a011                	j	80205994 <print_proc_table+0x120>
    80205992:	57fd                	li	a5,-1
    80205994:	fcf42623          	sw	a5,-52(s0)
            unsigned long func_addr = p->trapframe ? p->trapframe->epc : 0;
    80205998:	fd843783          	ld	a5,-40(s0)
    8020599c:	63fc                	ld	a5,192(a5)
    8020599e:	c791                	beqz	a5,802059aa <print_proc_table+0x136>
    802059a0:	fd843783          	ld	a5,-40(s0)
    802059a4:	63fc                	ld	a5,192(a5)
    802059a6:	739c                	ld	a5,32(a5)
    802059a8:	a011                	j	802059ac <print_proc_table+0x138>
    802059aa:	4781                	li	a5,0
    802059ac:	fcf43023          	sd	a5,-64(s0)
            unsigned long stack_addr = p->kstack;
    802059b0:	fd843783          	ld	a5,-40(s0)
    802059b4:	679c                	ld	a5,8(a5)
    802059b6:	faf43c23          	sd	a5,-72(s0)
            printf("%2d  %3s %8s %4d 0x%012lx 0x%012lx\n",
    802059ba:	fd843783          	ld	a5,-40(s0)
    802059be:	43cc                	lw	a1,4(a5)
    802059c0:	fcc42703          	lw	a4,-52(s0)
    802059c4:	fb843803          	ld	a6,-72(s0)
    802059c8:	fc043783          	ld	a5,-64(s0)
    802059cc:	fe043683          	ld	a3,-32(s0)
    802059d0:	fd043603          	ld	a2,-48(s0)
    802059d4:	00007517          	auipc	a0,0x7
    802059d8:	9f450513          	addi	a0,a0,-1548 # 8020c3c8 <simple_user_task_bin+0x3b8>
    802059dc:	ffffb097          	auipc	ra,0xffffb
    802059e0:	2b8080e7          	jalr	696(ra) # 80200c94 <printf>
    for(int i = 0; i < PROC; i++) {
    802059e4:	fe842783          	lw	a5,-24(s0)
    802059e8:	2785                	addiw	a5,a5,1
    802059ea:	fef42423          	sw	a5,-24(s0)
    802059ee:	fe842783          	lw	a5,-24(s0)
    802059f2:	0007871b          	sext.w	a4,a5
    802059f6:	47fd                	li	a5,31
    802059f8:	eae7d7e3          	bge	a5,a4,802058a6 <print_proc_table+0x32>
                p->pid, type, status, ppid, func_addr, stack_addr);
        }
    }
    printf("----------------------------------------------------------\n");
    802059fc:	00007517          	auipc	a0,0x7
    80205a00:	93c50513          	addi	a0,a0,-1732 # 8020c338 <simple_user_task_bin+0x328>
    80205a04:	ffffb097          	auipc	ra,0xffffb
    80205a08:	290080e7          	jalr	656(ra) # 80200c94 <printf>
    printf("%d active processes\n", count);
    80205a0c:	fec42783          	lw	a5,-20(s0)
    80205a10:	85be                	mv	a1,a5
    80205a12:	00007517          	auipc	a0,0x7
    80205a16:	9de50513          	addi	a0,a0,-1570 # 8020c3f0 <simple_user_task_bin+0x3e0>
    80205a1a:	ffffb097          	auipc	ra,0xffffb
    80205a1e:	27a080e7          	jalr	634(ra) # 80200c94 <printf>
}
    80205a22:	0001                	nop
    80205a24:	60a6                	ld	ra,72(sp)
    80205a26:	6406                	ld	s0,64(sp)
    80205a28:	6161                	addi	sp,sp,80
    80205a2a:	8082                	ret

0000000080205a2c <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    80205a2c:	7179                	addi	sp,sp,-48
    80205a2e:	f422                	sd	s0,40(sp)
    80205a30:	1800                	addi	s0,sp,48
    80205a32:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    80205a36:	fe042623          	sw	zero,-20(s0)
    80205a3a:	a031                	j	80205a46 <strlen+0x1a>
    80205a3c:	fec42783          	lw	a5,-20(s0)
    80205a40:	2785                	addiw	a5,a5,1
    80205a42:	fef42623          	sw	a5,-20(s0)
    80205a46:	fec42783          	lw	a5,-20(s0)
    80205a4a:	fd843703          	ld	a4,-40(s0)
    80205a4e:	97ba                	add	a5,a5,a4
    80205a50:	0007c783          	lbu	a5,0(a5)
    80205a54:	f7e5                	bnez	a5,80205a3c <strlen+0x10>
        ;
    return n;
    80205a56:	fec42783          	lw	a5,-20(s0)
}
    80205a5a:	853e                	mv	a0,a5
    80205a5c:	7422                	ld	s0,40(sp)
    80205a5e:	6145                	addi	sp,sp,48
    80205a60:	8082                	ret

0000000080205a62 <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    80205a62:	1101                	addi	sp,sp,-32
    80205a64:	ec22                	sd	s0,24(sp)
    80205a66:	1000                	addi	s0,sp,32
    80205a68:	fea43423          	sd	a0,-24(s0)
    80205a6c:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    80205a70:	a819                	j	80205a86 <strcmp+0x24>
        p++, q++;
    80205a72:	fe843783          	ld	a5,-24(s0)
    80205a76:	0785                	addi	a5,a5,1
    80205a78:	fef43423          	sd	a5,-24(s0)
    80205a7c:	fe043783          	ld	a5,-32(s0)
    80205a80:	0785                	addi	a5,a5,1
    80205a82:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    80205a86:	fe843783          	ld	a5,-24(s0)
    80205a8a:	0007c783          	lbu	a5,0(a5)
    80205a8e:	cb99                	beqz	a5,80205aa4 <strcmp+0x42>
    80205a90:	fe843783          	ld	a5,-24(s0)
    80205a94:	0007c703          	lbu	a4,0(a5)
    80205a98:	fe043783          	ld	a5,-32(s0)
    80205a9c:	0007c783          	lbu	a5,0(a5)
    80205aa0:	fcf709e3          	beq	a4,a5,80205a72 <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    80205aa4:	fe843783          	ld	a5,-24(s0)
    80205aa8:	0007c783          	lbu	a5,0(a5)
    80205aac:	0007871b          	sext.w	a4,a5
    80205ab0:	fe043783          	ld	a5,-32(s0)
    80205ab4:	0007c783          	lbu	a5,0(a5)
    80205ab8:	2781                	sext.w	a5,a5
    80205aba:	40f707bb          	subw	a5,a4,a5
    80205abe:	2781                	sext.w	a5,a5
}
    80205ac0:	853e                	mv	a0,a5
    80205ac2:	6462                	ld	s0,24(sp)
    80205ac4:	6105                	addi	sp,sp,32
    80205ac6:	8082                	ret

0000000080205ac8 <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    80205ac8:	7179                	addi	sp,sp,-48
    80205aca:	f422                	sd	s0,40(sp)
    80205acc:	1800                	addi	s0,sp,48
    80205ace:	fca43c23          	sd	a0,-40(s0)
    80205ad2:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    80205ad6:	fd843783          	ld	a5,-40(s0)
    80205ada:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    80205ade:	0001                	nop
    80205ae0:	fd043703          	ld	a4,-48(s0)
    80205ae4:	00170793          	addi	a5,a4,1
    80205ae8:	fcf43823          	sd	a5,-48(s0)
    80205aec:	fd843783          	ld	a5,-40(s0)
    80205af0:	00178693          	addi	a3,a5,1
    80205af4:	fcd43c23          	sd	a3,-40(s0)
    80205af8:	00074703          	lbu	a4,0(a4)
    80205afc:	00e78023          	sb	a4,0(a5)
    80205b00:	0007c783          	lbu	a5,0(a5)
    80205b04:	fff1                	bnez	a5,80205ae0 <strcpy+0x18>
        ;
    return os;
    80205b06:	fe843783          	ld	a5,-24(s0)
}
    80205b0a:	853e                	mv	a0,a5
    80205b0c:	7422                	ld	s0,40(sp)
    80205b0e:	6145                	addi	sp,sp,48
    80205b10:	8082                	ret

0000000080205b12 <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    80205b12:	7139                	addi	sp,sp,-64
    80205b14:	fc22                	sd	s0,56(sp)
    80205b16:	0080                	addi	s0,sp,64
    80205b18:	fca43c23          	sd	a0,-40(s0)
    80205b1c:	fcb43823          	sd	a1,-48(s0)
    80205b20:	87b2                	mv	a5,a2
    80205b22:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    80205b26:	fd843783          	ld	a5,-40(s0)
    80205b2a:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    80205b2e:	fcc42783          	lw	a5,-52(s0)
    80205b32:	2781                	sext.w	a5,a5
    80205b34:	00f04563          	bgtz	a5,80205b3e <safestrcpy+0x2c>
        return os;
    80205b38:	fe843783          	ld	a5,-24(s0)
    80205b3c:	a0a9                	j	80205b86 <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    80205b3e:	0001                	nop
    80205b40:	fcc42783          	lw	a5,-52(s0)
    80205b44:	37fd                	addiw	a5,a5,-1
    80205b46:	fcf42623          	sw	a5,-52(s0)
    80205b4a:	fcc42783          	lw	a5,-52(s0)
    80205b4e:	2781                	sext.w	a5,a5
    80205b50:	02f05563          	blez	a5,80205b7a <safestrcpy+0x68>
    80205b54:	fd043703          	ld	a4,-48(s0)
    80205b58:	00170793          	addi	a5,a4,1
    80205b5c:	fcf43823          	sd	a5,-48(s0)
    80205b60:	fd843783          	ld	a5,-40(s0)
    80205b64:	00178693          	addi	a3,a5,1
    80205b68:	fcd43c23          	sd	a3,-40(s0)
    80205b6c:	00074703          	lbu	a4,0(a4)
    80205b70:	00e78023          	sb	a4,0(a5)
    80205b74:	0007c783          	lbu	a5,0(a5)
    80205b78:	f7e1                	bnez	a5,80205b40 <safestrcpy+0x2e>
        ;
    *s = 0;
    80205b7a:	fd843783          	ld	a5,-40(s0)
    80205b7e:	00078023          	sb	zero,0(a5)
    return os;
    80205b82:	fe843783          	ld	a5,-24(s0)
    80205b86:	853e                	mv	a0,a5
    80205b88:	7462                	ld	s0,56(sp)
    80205b8a:	6121                	addi	sp,sp,64
    80205b8c:	8082                	ret

0000000080205b8e <assert>:
    80205b8e:	1101                	addi	sp,sp,-32
    80205b90:	ec06                	sd	ra,24(sp)
    80205b92:	e822                	sd	s0,16(sp)
    80205b94:	1000                	addi	s0,sp,32
    80205b96:	87aa                	mv	a5,a0
    80205b98:	fef42623          	sw	a5,-20(s0)
    80205b9c:	fec42783          	lw	a5,-20(s0)
    80205ba0:	2781                	sext.w	a5,a5
    80205ba2:	e79d                	bnez	a5,80205bd0 <assert+0x42>
    80205ba4:	19c00613          	li	a2,412
    80205ba8:	00007597          	auipc	a1,0x7
    80205bac:	24858593          	addi	a1,a1,584 # 8020cdf0 <simple_user_task_bin+0x58>
    80205bb0:	00007517          	auipc	a0,0x7
    80205bb4:	25050513          	addi	a0,a0,592 # 8020ce00 <simple_user_task_bin+0x68>
    80205bb8:	ffffb097          	auipc	ra,0xffffb
    80205bbc:	0dc080e7          	jalr	220(ra) # 80200c94 <printf>
    80205bc0:	00007517          	auipc	a0,0x7
    80205bc4:	26850513          	addi	a0,a0,616 # 8020ce28 <simple_user_task_bin+0x90>
    80205bc8:	ffffc097          	auipc	ra,0xffffc
    80205bcc:	b18080e7          	jalr	-1256(ra) # 802016e0 <panic>
    80205bd0:	0001                	nop
    80205bd2:	60e2                	ld	ra,24(sp)
    80205bd4:	6442                	ld	s0,16(sp)
    80205bd6:	6105                	addi	sp,sp,32
    80205bd8:	8082                	ret

0000000080205bda <get_time>:
uint64 get_time(void) {
    80205bda:	1141                	addi	sp,sp,-16
    80205bdc:	e406                	sd	ra,8(sp)
    80205bde:	e022                	sd	s0,0(sp)
    80205be0:	0800                	addi	s0,sp,16
    return sbi_get_time();
    80205be2:	ffffe097          	auipc	ra,0xffffe
    80205be6:	8e4080e7          	jalr	-1820(ra) # 802034c6 <sbi_get_time>
    80205bea:	87aa                	mv	a5,a0
}
    80205bec:	853e                	mv	a0,a5
    80205bee:	60a2                	ld	ra,8(sp)
    80205bf0:	6402                	ld	s0,0(sp)
    80205bf2:	0141                	addi	sp,sp,16
    80205bf4:	8082                	ret

0000000080205bf6 <test_timer_interrupt>:
void test_timer_interrupt(void) {
    80205bf6:	7179                	addi	sp,sp,-48
    80205bf8:	f406                	sd	ra,40(sp)
    80205bfa:	f022                	sd	s0,32(sp)
    80205bfc:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    80205bfe:	00007517          	auipc	a0,0x7
    80205c02:	23250513          	addi	a0,a0,562 # 8020ce30 <simple_user_task_bin+0x98>
    80205c06:	ffffb097          	auipc	ra,0xffffb
    80205c0a:	08e080e7          	jalr	142(ra) # 80200c94 <printf>
    uint64 start_time = get_time();
    80205c0e:	00000097          	auipc	ra,0x0
    80205c12:	fcc080e7          	jalr	-52(ra) # 80205bda <get_time>
    80205c16:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    80205c1a:	fc042a23          	sw	zero,-44(s0)
	int last_count = interrupt_count;
    80205c1e:	fd442783          	lw	a5,-44(s0)
    80205c22:	fef42623          	sw	a5,-20(s0)
    interrupt_test_flag = &interrupt_count;
    80205c26:	00009797          	auipc	a5,0x9
    80205c2a:	49278793          	addi	a5,a5,1170 # 8020f0b8 <interrupt_test_flag>
    80205c2e:	fd440713          	addi	a4,s0,-44
    80205c32:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    80205c34:	a899                	j	80205c8a <test_timer_interrupt+0x94>
        if(last_count != interrupt_count) {
    80205c36:	fd442703          	lw	a4,-44(s0)
    80205c3a:	fec42783          	lw	a5,-20(s0)
    80205c3e:	2781                	sext.w	a5,a5
    80205c40:	02e78163          	beq	a5,a4,80205c62 <test_timer_interrupt+0x6c>
			last_count = interrupt_count;
    80205c44:	fd442783          	lw	a5,-44(s0)
    80205c48:	fef42623          	sw	a5,-20(s0)
			printf("Received interrupt %d\n", interrupt_count);
    80205c4c:	fd442783          	lw	a5,-44(s0)
    80205c50:	85be                	mv	a1,a5
    80205c52:	00007517          	auipc	a0,0x7
    80205c56:	1fe50513          	addi	a0,a0,510 # 8020ce50 <simple_user_task_bin+0xb8>
    80205c5a:	ffffb097          	auipc	ra,0xffffb
    80205c5e:	03a080e7          	jalr	58(ra) # 80200c94 <printf>
        for (volatile int i = 0; i < 1000000; i++);
    80205c62:	fc042823          	sw	zero,-48(s0)
    80205c66:	a801                	j	80205c76 <test_timer_interrupt+0x80>
    80205c68:	fd042783          	lw	a5,-48(s0)
    80205c6c:	2781                	sext.w	a5,a5
    80205c6e:	2785                	addiw	a5,a5,1
    80205c70:	2781                	sext.w	a5,a5
    80205c72:	fcf42823          	sw	a5,-48(s0)
    80205c76:	fd042783          	lw	a5,-48(s0)
    80205c7a:	2781                	sext.w	a5,a5
    80205c7c:	873e                	mv	a4,a5
    80205c7e:	000f47b7          	lui	a5,0xf4
    80205c82:	23f78793          	addi	a5,a5,575 # f423f <_entry-0x8010bdc1>
    80205c86:	fee7d1e3          	bge	a5,a4,80205c68 <test_timer_interrupt+0x72>
    while (interrupt_count < 5) {
    80205c8a:	fd442783          	lw	a5,-44(s0)
    80205c8e:	873e                	mv	a4,a5
    80205c90:	4791                	li	a5,4
    80205c92:	fae7d2e3          	bge	a5,a4,80205c36 <test_timer_interrupt+0x40>
    interrupt_test_flag = 0;
    80205c96:	00009797          	auipc	a5,0x9
    80205c9a:	42278793          	addi	a5,a5,1058 # 8020f0b8 <interrupt_test_flag>
    80205c9e:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    80205ca2:	00000097          	auipc	ra,0x0
    80205ca6:	f38080e7          	jalr	-200(ra) # 80205bda <get_time>
    80205caa:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    80205cae:	fd442683          	lw	a3,-44(s0)
    80205cb2:	fd843703          	ld	a4,-40(s0)
    80205cb6:	fe043783          	ld	a5,-32(s0)
    80205cba:	40f707b3          	sub	a5,a4,a5
    80205cbe:	863e                	mv	a2,a5
    80205cc0:	85b6                	mv	a1,a3
    80205cc2:	00007517          	auipc	a0,0x7
    80205cc6:	1a650513          	addi	a0,a0,422 # 8020ce68 <simple_user_task_bin+0xd0>
    80205cca:	ffffb097          	auipc	ra,0xffffb
    80205cce:	fca080e7          	jalr	-54(ra) # 80200c94 <printf>
}
    80205cd2:	0001                	nop
    80205cd4:	70a2                	ld	ra,40(sp)
    80205cd6:	7402                	ld	s0,32(sp)
    80205cd8:	6145                	addi	sp,sp,48
    80205cda:	8082                	ret

0000000080205cdc <test_exception>:
void test_exception(void) {
    80205cdc:	715d                	addi	sp,sp,-80
    80205cde:	e486                	sd	ra,72(sp)
    80205ce0:	e0a2                	sd	s0,64(sp)
    80205ce2:	0880                	addi	s0,sp,80
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    80205ce4:	00007517          	auipc	a0,0x7
    80205ce8:	1bc50513          	addi	a0,a0,444 # 8020cea0 <simple_user_task_bin+0x108>
    80205cec:	ffffb097          	auipc	ra,0xffffb
    80205cf0:	fa8080e7          	jalr	-88(ra) # 80200c94 <printf>
    printf("1. 测试非法指令异常...\n");
    80205cf4:	00007517          	auipc	a0,0x7
    80205cf8:	1dc50513          	addi	a0,a0,476 # 8020ced0 <simple_user_task_bin+0x138>
    80205cfc:	ffffb097          	auipc	ra,0xffffb
    80205d00:	f98080e7          	jalr	-104(ra) # 80200c94 <printf>
    80205d04:	ffffffff          	.word	0xffffffff
    printf("✓ 非法指令异常处理成功\n\n");
    80205d08:	00007517          	auipc	a0,0x7
    80205d0c:	1e850513          	addi	a0,a0,488 # 8020cef0 <simple_user_task_bin+0x158>
    80205d10:	ffffb097          	auipc	ra,0xffffb
    80205d14:	f84080e7          	jalr	-124(ra) # 80200c94 <printf>
    printf("2. 测试存储页故障异常...\n");
    80205d18:	00007517          	auipc	a0,0x7
    80205d1c:	20050513          	addi	a0,a0,512 # 8020cf18 <simple_user_task_bin+0x180>
    80205d20:	ffffb097          	auipc	ra,0xffffb
    80205d24:	f74080e7          	jalr	-140(ra) # 80200c94 <printf>
    volatile uint64 *invalid_ptr = 0;
    80205d28:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80205d2c:	47a5                	li	a5,9
    80205d2e:	07f2                	slli	a5,a5,0x1c
    80205d30:	fef43023          	sd	a5,-32(s0)
    80205d34:	a835                	j	80205d70 <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    80205d36:	fe043503          	ld	a0,-32(s0)
    80205d3a:	ffffd097          	auipc	ra,0xffffd
    80205d3e:	2a4080e7          	jalr	676(ra) # 80202fde <check_is_mapped>
    80205d42:	87aa                	mv	a5,a0
    80205d44:	e385                	bnez	a5,80205d64 <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    80205d46:	fe043783          	ld	a5,-32(s0)
    80205d4a:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80205d4e:	fe043583          	ld	a1,-32(s0)
    80205d52:	00007517          	auipc	a0,0x7
    80205d56:	1ee50513          	addi	a0,a0,494 # 8020cf40 <simple_user_task_bin+0x1a8>
    80205d5a:	ffffb097          	auipc	ra,0xffffb
    80205d5e:	f3a080e7          	jalr	-198(ra) # 80200c94 <printf>
            break;
    80205d62:	a829                	j	80205d7c <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80205d64:	fe043703          	ld	a4,-32(s0)
    80205d68:	6785                	lui	a5,0x1
    80205d6a:	97ba                	add	a5,a5,a4
    80205d6c:	fef43023          	sd	a5,-32(s0)
    80205d70:	fe043703          	ld	a4,-32(s0)
    80205d74:	47cd                	li	a5,19
    80205d76:	07ee                	slli	a5,a5,0x1b
    80205d78:	faf76fe3          	bltu	a4,a5,80205d36 <test_exception+0x5a>
    if (invalid_ptr != 0) {
    80205d7c:	fe843783          	ld	a5,-24(s0)
    80205d80:	cb95                	beqz	a5,80205db4 <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80205d82:	fe843783          	ld	a5,-24(s0)
    80205d86:	85be                	mv	a1,a5
    80205d88:	00007517          	auipc	a0,0x7
    80205d8c:	1d850513          	addi	a0,a0,472 # 8020cf60 <simple_user_task_bin+0x1c8>
    80205d90:	ffffb097          	auipc	ra,0xffffb
    80205d94:	f04080e7          	jalr	-252(ra) # 80200c94 <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    80205d98:	fe843783          	ld	a5,-24(s0)
    80205d9c:	02a00713          	li	a4,42
    80205da0:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    80205da2:	00007517          	auipc	a0,0x7
    80205da6:	1ee50513          	addi	a0,a0,494 # 8020cf90 <simple_user_task_bin+0x1f8>
    80205daa:	ffffb097          	auipc	ra,0xffffb
    80205dae:	eea080e7          	jalr	-278(ra) # 80200c94 <printf>
    80205db2:	a809                	j	80205dc4 <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80205db4:	00007517          	auipc	a0,0x7
    80205db8:	20450513          	addi	a0,a0,516 # 8020cfb8 <simple_user_task_bin+0x220>
    80205dbc:	ffffb097          	auipc	ra,0xffffb
    80205dc0:	ed8080e7          	jalr	-296(ra) # 80200c94 <printf>
    printf("3. 测试加载页故障异常...\n");
    80205dc4:	00007517          	auipc	a0,0x7
    80205dc8:	22c50513          	addi	a0,a0,556 # 8020cff0 <simple_user_task_bin+0x258>
    80205dcc:	ffffb097          	auipc	ra,0xffffb
    80205dd0:	ec8080e7          	jalr	-312(ra) # 80200c94 <printf>
    invalid_ptr = 0;
    80205dd4:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80205dd8:	4795                	li	a5,5
    80205dda:	07f6                	slli	a5,a5,0x1d
    80205ddc:	fcf43c23          	sd	a5,-40(s0)
    80205de0:	a835                	j	80205e1c <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    80205de2:	fd843503          	ld	a0,-40(s0)
    80205de6:	ffffd097          	auipc	ra,0xffffd
    80205dea:	1f8080e7          	jalr	504(ra) # 80202fde <check_is_mapped>
    80205dee:	87aa                	mv	a5,a0
    80205df0:	e385                	bnez	a5,80205e10 <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    80205df2:	fd843783          	ld	a5,-40(s0)
    80205df6:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80205dfa:	fd843583          	ld	a1,-40(s0)
    80205dfe:	00007517          	auipc	a0,0x7
    80205e02:	14250513          	addi	a0,a0,322 # 8020cf40 <simple_user_task_bin+0x1a8>
    80205e06:	ffffb097          	auipc	ra,0xffffb
    80205e0a:	e8e080e7          	jalr	-370(ra) # 80200c94 <printf>
            break;
    80205e0e:	a829                	j	80205e28 <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80205e10:	fd843703          	ld	a4,-40(s0)
    80205e14:	6785                	lui	a5,0x1
    80205e16:	97ba                	add	a5,a5,a4
    80205e18:	fcf43c23          	sd	a5,-40(s0)
    80205e1c:	fd843703          	ld	a4,-40(s0)
    80205e20:	47d5                	li	a5,21
    80205e22:	07ee                	slli	a5,a5,0x1b
    80205e24:	faf76fe3          	bltu	a4,a5,80205de2 <test_exception+0x106>
    if (invalid_ptr != 0) {
    80205e28:	fe843783          	ld	a5,-24(s0)
    80205e2c:	c7a9                	beqz	a5,80205e76 <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80205e2e:	fe843783          	ld	a5,-24(s0)
    80205e32:	85be                	mv	a1,a5
    80205e34:	00007517          	auipc	a0,0x7
    80205e38:	1e450513          	addi	a0,a0,484 # 8020d018 <simple_user_task_bin+0x280>
    80205e3c:	ffffb097          	auipc	ra,0xffffb
    80205e40:	e58080e7          	jalr	-424(ra) # 80200c94 <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    80205e44:	fe843783          	ld	a5,-24(s0)
    80205e48:	639c                	ld	a5,0(a5)
    80205e4a:	faf43823          	sd	a5,-80(s0)
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    80205e4e:	fb043783          	ld	a5,-80(s0)
    80205e52:	85be                	mv	a1,a5
    80205e54:	00007517          	auipc	a0,0x7
    80205e58:	1f450513          	addi	a0,a0,500 # 8020d048 <simple_user_task_bin+0x2b0>
    80205e5c:	ffffb097          	auipc	ra,0xffffb
    80205e60:	e38080e7          	jalr	-456(ra) # 80200c94 <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    80205e64:	00007517          	auipc	a0,0x7
    80205e68:	1fc50513          	addi	a0,a0,508 # 8020d060 <simple_user_task_bin+0x2c8>
    80205e6c:	ffffb097          	auipc	ra,0xffffb
    80205e70:	e28080e7          	jalr	-472(ra) # 80200c94 <printf>
    80205e74:	a809                	j	80205e86 <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80205e76:	00007517          	auipc	a0,0x7
    80205e7a:	14250513          	addi	a0,a0,322 # 8020cfb8 <simple_user_task_bin+0x220>
    80205e7e:	ffffb097          	auipc	ra,0xffffb
    80205e82:	e16080e7          	jalr	-490(ra) # 80200c94 <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    80205e86:	00007517          	auipc	a0,0x7
    80205e8a:	20250513          	addi	a0,a0,514 # 8020d088 <simple_user_task_bin+0x2f0>
    80205e8e:	ffffb097          	auipc	ra,0xffffb
    80205e92:	e06080e7          	jalr	-506(ra) # 80200c94 <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    80205e96:	ffffd097          	auipc	ra,0xffffd
    80205e9a:	390080e7          	jalr	912(ra) # 80203226 <alloc_page>
    80205e9e:	87aa                	mv	a5,a0
    80205ea0:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    80205ea4:	fd043783          	ld	a5,-48(s0)
    80205ea8:	c3a1                	beqz	a5,80205ee8 <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    80205eaa:	fd043783          	ld	a5,-48(s0)
    80205eae:	0785                	addi	a5,a5,1 # 1001 <_entry-0x801fefff>
    80205eb0:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80205eb4:	fc843583          	ld	a1,-56(s0)
    80205eb8:	00007517          	auipc	a0,0x7
    80205ebc:	20050513          	addi	a0,a0,512 # 8020d0b8 <simple_user_task_bin+0x320>
    80205ec0:	ffffb097          	auipc	ra,0xffffb
    80205ec4:	dd4080e7          	jalr	-556(ra) # 80200c94 <printf>
        asm volatile (
    80205ec8:	deadc7b7          	lui	a5,0xdeadc
    80205ecc:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8cc7ef>
    80205ed0:	fc843703          	ld	a4,-56(s0)
    80205ed4:	e31c                	sd	a5,0(a4)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    80205ed6:	00007517          	auipc	a0,0x7
    80205eda:	20250513          	addi	a0,a0,514 # 8020d0d8 <simple_user_task_bin+0x340>
    80205ede:	ffffb097          	auipc	ra,0xffffb
    80205ee2:	db6080e7          	jalr	-586(ra) # 80200c94 <printf>
    80205ee6:	a809                	j	80205ef8 <test_exception+0x21c>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80205ee8:	00007517          	auipc	a0,0x7
    80205eec:	22050513          	addi	a0,a0,544 # 8020d108 <simple_user_task_bin+0x370>
    80205ef0:	ffffb097          	auipc	ra,0xffffb
    80205ef4:	da4080e7          	jalr	-604(ra) # 80200c94 <printf>
    printf("5. 测试加载地址未对齐异常...\n");
    80205ef8:	00007517          	auipc	a0,0x7
    80205efc:	25050513          	addi	a0,a0,592 # 8020d148 <simple_user_task_bin+0x3b0>
    80205f00:	ffffb097          	auipc	ra,0xffffb
    80205f04:	d94080e7          	jalr	-620(ra) # 80200c94 <printf>
    if (aligned_addr != 0) {
    80205f08:	fd043783          	ld	a5,-48(s0)
    80205f0c:	cbb1                	beqz	a5,80205f60 <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    80205f0e:	fd043783          	ld	a5,-48(s0)
    80205f12:	0785                	addi	a5,a5,1
    80205f14:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80205f18:	fc043583          	ld	a1,-64(s0)
    80205f1c:	00007517          	auipc	a0,0x7
    80205f20:	19c50513          	addi	a0,a0,412 # 8020d0b8 <simple_user_task_bin+0x320>
    80205f24:	ffffb097          	auipc	ra,0xffffb
    80205f28:	d70080e7          	jalr	-656(ra) # 80200c94 <printf>
        uint64 value = 0;
    80205f2c:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    80205f30:	fc043783          	ld	a5,-64(s0)
    80205f34:	639c                	ld	a5,0(a5)
    80205f36:	faf43c23          	sd	a5,-72(s0)
        printf("读取的值: 0x%lx\n", value);
    80205f3a:	fb843583          	ld	a1,-72(s0)
    80205f3e:	00007517          	auipc	a0,0x7
    80205f42:	23a50513          	addi	a0,a0,570 # 8020d178 <simple_user_task_bin+0x3e0>
    80205f46:	ffffb097          	auipc	ra,0xffffb
    80205f4a:	d4e080e7          	jalr	-690(ra) # 80200c94 <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    80205f4e:	00007517          	auipc	a0,0x7
    80205f52:	24250513          	addi	a0,a0,578 # 8020d190 <simple_user_task_bin+0x3f8>
    80205f56:	ffffb097          	auipc	ra,0xffffb
    80205f5a:	d3e080e7          	jalr	-706(ra) # 80200c94 <printf>
    80205f5e:	a809                	j	80205f70 <test_exception+0x294>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80205f60:	00007517          	auipc	a0,0x7
    80205f64:	1a850513          	addi	a0,a0,424 # 8020d108 <simple_user_task_bin+0x370>
    80205f68:	ffffb097          	auipc	ra,0xffffb
    80205f6c:	d2c080e7          	jalr	-724(ra) # 80200c94 <printf>
	printf("6. 测试断点异常...\n");
    80205f70:	00007517          	auipc	a0,0x7
    80205f74:	25050513          	addi	a0,a0,592 # 8020d1c0 <simple_user_task_bin+0x428>
    80205f78:	ffffb097          	auipc	ra,0xffffb
    80205f7c:	d1c080e7          	jalr	-740(ra) # 80200c94 <printf>
	asm volatile (
    80205f80:	0001                	nop
    80205f82:	9002                	ebreak
    80205f84:	0001                	nop
	printf("✓ 断点异常处理成功\n\n");
    80205f86:	00007517          	auipc	a0,0x7
    80205f8a:	25a50513          	addi	a0,a0,602 # 8020d1e0 <simple_user_task_bin+0x448>
    80205f8e:	ffffb097          	auipc	ra,0xffffb
    80205f92:	d06080e7          	jalr	-762(ra) # 80200c94 <printf>
    printf("7. 测试环境调用异常...\n");
    80205f96:	00007517          	auipc	a0,0x7
    80205f9a:	26a50513          	addi	a0,a0,618 # 8020d200 <simple_user_task_bin+0x468>
    80205f9e:	ffffb097          	auipc	ra,0xffffb
    80205fa2:	cf6080e7          	jalr	-778(ra) # 80200c94 <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    80205fa6:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    80205faa:	00007517          	auipc	a0,0x7
    80205fae:	27650513          	addi	a0,a0,630 # 8020d220 <simple_user_task_bin+0x488>
    80205fb2:	ffffb097          	auipc	ra,0xffffb
    80205fb6:	ce2080e7          	jalr	-798(ra) # 80200c94 <printf>
    printf("===== 异常处理测试完成 =====\n\n");
    80205fba:	00007517          	auipc	a0,0x7
    80205fbe:	28e50513          	addi	a0,a0,654 # 8020d248 <simple_user_task_bin+0x4b0>
    80205fc2:	ffffb097          	auipc	ra,0xffffb
    80205fc6:	cd2080e7          	jalr	-814(ra) # 80200c94 <printf>
}
    80205fca:	0001                	nop
    80205fcc:	60a6                	ld	ra,72(sp)
    80205fce:	6406                	ld	s0,64(sp)
    80205fd0:	6161                	addi	sp,sp,80
    80205fd2:	8082                	ret

0000000080205fd4 <simple_task>:
void simple_task(void) {
    80205fd4:	1141                	addi	sp,sp,-16
    80205fd6:	e406                	sd	ra,8(sp)
    80205fd8:	e022                	sd	s0,0(sp)
    80205fda:	0800                	addi	s0,sp,16
    printf("Simple kernel task running in PID %d\n", myproc()->pid);
    80205fdc:	fffff097          	auipc	ra,0xfffff
    80205fe0:	974080e7          	jalr	-1676(ra) # 80204950 <myproc>
    80205fe4:	87aa                	mv	a5,a0
    80205fe6:	43dc                	lw	a5,4(a5)
    80205fe8:	85be                	mv	a1,a5
    80205fea:	00007517          	auipc	a0,0x7
    80205fee:	28650513          	addi	a0,a0,646 # 8020d270 <simple_user_task_bin+0x4d8>
    80205ff2:	ffffb097          	auipc	ra,0xffffb
    80205ff6:	ca2080e7          	jalr	-862(ra) # 80200c94 <printf>
}
    80205ffa:	0001                	nop
    80205ffc:	60a2                	ld	ra,8(sp)
    80205ffe:	6402                	ld	s0,0(sp)
    80206000:	0141                	addi	sp,sp,16
    80206002:	8082                	ret

0000000080206004 <test_process_creation>:
void test_process_creation(void) {
    80206004:	7119                	addi	sp,sp,-128
    80206006:	fc86                	sd	ra,120(sp)
    80206008:	f8a2                	sd	s0,112(sp)
    8020600a:	0100                	addi	s0,sp,128
    printf("===== 测试开始: 进程创建与管理测试 =====\n");
    8020600c:	00007517          	auipc	a0,0x7
    80206010:	28c50513          	addi	a0,a0,652 # 8020d298 <simple_user_task_bin+0x500>
    80206014:	ffffb097          	auipc	ra,0xffffb
    80206018:	c80080e7          	jalr	-896(ra) # 80200c94 <printf>
    printf("\n----- 第一阶段：测试内核进程创建与管理 -----\n");
    8020601c:	00007517          	auipc	a0,0x7
    80206020:	2b450513          	addi	a0,a0,692 # 8020d2d0 <simple_user_task_bin+0x538>
    80206024:	ffffb097          	auipc	ra,0xffffb
    80206028:	c70080e7          	jalr	-912(ra) # 80200c94 <printf>
    int pid = create_kernel_proc(simple_task);
    8020602c:	00000517          	auipc	a0,0x0
    80206030:	fa850513          	addi	a0,a0,-88 # 80205fd4 <simple_task>
    80206034:	fffff097          	auipc	ra,0xfffff
    80206038:	f1c080e7          	jalr	-228(ra) # 80204f50 <create_kernel_proc>
    8020603c:	87aa                	mv	a5,a0
    8020603e:	faf42a23          	sw	a5,-76(s0)
    assert(pid > 0);
    80206042:	fb442783          	lw	a5,-76(s0)
    80206046:	2781                	sext.w	a5,a5
    80206048:	00f027b3          	sgtz	a5,a5
    8020604c:	0ff7f793          	zext.b	a5,a5
    80206050:	2781                	sext.w	a5,a5
    80206052:	853e                	mv	a0,a5
    80206054:	00000097          	auipc	ra,0x0
    80206058:	b3a080e7          	jalr	-1222(ra) # 80205b8e <assert>
    printf("【测试结果】: 基本内核进程创建成功，PID: %d\n", pid);
    8020605c:	fb442783          	lw	a5,-76(s0)
    80206060:	85be                	mv	a1,a5
    80206062:	00007517          	auipc	a0,0x7
    80206066:	2ae50513          	addi	a0,a0,686 # 8020d310 <simple_user_task_bin+0x578>
    8020606a:	ffffb097          	auipc	ra,0xffffb
    8020606e:	c2a080e7          	jalr	-982(ra) # 80200c94 <printf>
    printf("\n----- 用内核进程填满进程表 -----\n");
    80206072:	00007517          	auipc	a0,0x7
    80206076:	2de50513          	addi	a0,a0,734 # 8020d350 <simple_user_task_bin+0x5b8>
    8020607a:	ffffb097          	auipc	ra,0xffffb
    8020607e:	c1a080e7          	jalr	-998(ra) # 80200c94 <printf>
    int kernel_count = 1; // 已经创建了一个
    80206082:	4785                	li	a5,1
    80206084:	fef42623          	sw	a5,-20(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206088:	4785                	li	a5,1
    8020608a:	fef42423          	sw	a5,-24(s0)
    8020608e:	a881                	j	802060de <test_process_creation+0xda>
        int new_pid = create_kernel_proc(simple_task);
    80206090:	00000517          	auipc	a0,0x0
    80206094:	f4450513          	addi	a0,a0,-188 # 80205fd4 <simple_task>
    80206098:	fffff097          	auipc	ra,0xfffff
    8020609c:	eb8080e7          	jalr	-328(ra) # 80204f50 <create_kernel_proc>
    802060a0:	87aa                	mv	a5,a0
    802060a2:	faf42823          	sw	a5,-80(s0)
        if (new_pid > 0) {
    802060a6:	fb042783          	lw	a5,-80(s0)
    802060aa:	2781                	sext.w	a5,a5
    802060ac:	00f05863          	blez	a5,802060bc <test_process_creation+0xb8>
            kernel_count++; 
    802060b0:	fec42783          	lw	a5,-20(s0)
    802060b4:	2785                	addiw	a5,a5,1
    802060b6:	fef42623          	sw	a5,-20(s0)
    802060ba:	a829                	j	802060d4 <test_process_creation+0xd0>
            warning("process table was full at %d kernel processes\n", kernel_count);
    802060bc:	fec42783          	lw	a5,-20(s0)
    802060c0:	85be                	mv	a1,a5
    802060c2:	00007517          	auipc	a0,0x7
    802060c6:	2be50513          	addi	a0,a0,702 # 8020d380 <simple_user_task_bin+0x5e8>
    802060ca:	ffffb097          	auipc	ra,0xffffb
    802060ce:	64a080e7          	jalr	1610(ra) # 80201714 <warning>
            break;
    802060d2:	a829                	j	802060ec <test_process_creation+0xe8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    802060d4:	fe842783          	lw	a5,-24(s0)
    802060d8:	2785                	addiw	a5,a5,1
    802060da:	fef42423          	sw	a5,-24(s0)
    802060de:	fe842783          	lw	a5,-24(s0)
    802060e2:	0007871b          	sext.w	a4,a5
    802060e6:	47fd                	li	a5,31
    802060e8:	fae7d4e3          	bge	a5,a4,80206090 <test_process_creation+0x8c>
    printf("【测试结果】: 成功创建 %d 个内核进程 (最大限制: %d)\n", kernel_count, PROC);
    802060ec:	fec42783          	lw	a5,-20(s0)
    802060f0:	02000613          	li	a2,32
    802060f4:	85be                	mv	a1,a5
    802060f6:	00007517          	auipc	a0,0x7
    802060fa:	2ba50513          	addi	a0,a0,698 # 8020d3b0 <simple_user_task_bin+0x618>
    802060fe:	ffffb097          	auipc	ra,0xffffb
    80206102:	b96080e7          	jalr	-1130(ra) # 80200c94 <printf>
    print_proc_table();
    80206106:	fffff097          	auipc	ra,0xfffff
    8020610a:	76e080e7          	jalr	1902(ra) # 80205874 <print_proc_table>
    printf("\n----- 等待并清理所有内核进程 -----\n");
    8020610e:	00007517          	auipc	a0,0x7
    80206112:	2ea50513          	addi	a0,a0,746 # 8020d3f8 <simple_user_task_bin+0x660>
    80206116:	ffffb097          	auipc	ra,0xffffb
    8020611a:	b7e080e7          	jalr	-1154(ra) # 80200c94 <printf>
    int kernel_success_count = 0;
    8020611e:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < kernel_count; i++) {
    80206122:	fe042023          	sw	zero,-32(s0)
    80206126:	a0a5                	j	8020618e <test_process_creation+0x18a>
        int waited_pid = wait_proc(NULL);
    80206128:	4501                	li	a0,0
    8020612a:	fffff097          	auipc	ra,0xfffff
    8020612e:	5bc080e7          	jalr	1468(ra) # 802056e6 <wait_proc>
    80206132:	87aa                	mv	a5,a0
    80206134:	f8f42623          	sw	a5,-116(s0)
        if (waited_pid > 0) {
    80206138:	f8c42783          	lw	a5,-116(s0)
    8020613c:	2781                	sext.w	a5,a5
    8020613e:	02f05863          	blez	a5,8020616e <test_process_creation+0x16a>
            kernel_success_count++;
    80206142:	fe442783          	lw	a5,-28(s0)
    80206146:	2785                	addiw	a5,a5,1
    80206148:	fef42223          	sw	a5,-28(s0)
            printf("回收内核进程 PID: %d (%d/%d)\n", waited_pid, kernel_success_count, kernel_count);
    8020614c:	fec42683          	lw	a3,-20(s0)
    80206150:	fe442703          	lw	a4,-28(s0)
    80206154:	f8c42783          	lw	a5,-116(s0)
    80206158:	863a                	mv	a2,a4
    8020615a:	85be                	mv	a1,a5
    8020615c:	00007517          	auipc	a0,0x7
    80206160:	2cc50513          	addi	a0,a0,716 # 8020d428 <simple_user_task_bin+0x690>
    80206164:	ffffb097          	auipc	ra,0xffffb
    80206168:	b30080e7          	jalr	-1232(ra) # 80200c94 <printf>
    8020616c:	a821                	j	80206184 <test_process_creation+0x180>
            printf("【错误】: 等待内核进程失败，错误码: %d\n", waited_pid);
    8020616e:	f8c42783          	lw	a5,-116(s0)
    80206172:	85be                	mv	a1,a5
    80206174:	00007517          	auipc	a0,0x7
    80206178:	2dc50513          	addi	a0,a0,732 # 8020d450 <simple_user_task_bin+0x6b8>
    8020617c:	ffffb097          	auipc	ra,0xffffb
    80206180:	b18080e7          	jalr	-1256(ra) # 80200c94 <printf>
    for (int i = 0; i < kernel_count; i++) {
    80206184:	fe042783          	lw	a5,-32(s0)
    80206188:	2785                	addiw	a5,a5,1
    8020618a:	fef42023          	sw	a5,-32(s0)
    8020618e:	fe042783          	lw	a5,-32(s0)
    80206192:	873e                	mv	a4,a5
    80206194:	fec42783          	lw	a5,-20(s0)
    80206198:	2701                	sext.w	a4,a4
    8020619a:	2781                	sext.w	a5,a5
    8020619c:	f8f746e3          	blt	a4,a5,80206128 <test_process_creation+0x124>
    printf("【测试结果】: 回收 %d/%d 个内核进程\n", kernel_success_count, kernel_count);
    802061a0:	fec42703          	lw	a4,-20(s0)
    802061a4:	fe442783          	lw	a5,-28(s0)
    802061a8:	863a                	mv	a2,a4
    802061aa:	85be                	mv	a1,a5
    802061ac:	00007517          	auipc	a0,0x7
    802061b0:	2dc50513          	addi	a0,a0,732 # 8020d488 <simple_user_task_bin+0x6f0>
    802061b4:	ffffb097          	auipc	ra,0xffffb
    802061b8:	ae0080e7          	jalr	-1312(ra) # 80200c94 <printf>
    print_proc_table();
    802061bc:	fffff097          	auipc	ra,0xfffff
    802061c0:	6b8080e7          	jalr	1720(ra) # 80205874 <print_proc_table>
    printf("\n----- 第二阶段：测试用户进程创建与管理 -----\n");
    802061c4:	00007517          	auipc	a0,0x7
    802061c8:	2fc50513          	addi	a0,a0,764 # 8020d4c0 <simple_user_task_bin+0x728>
    802061cc:	ffffb097          	auipc	ra,0xffffb
    802061d0:	ac8080e7          	jalr	-1336(ra) # 80200c94 <printf>
    int user_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    802061d4:	05400793          	li	a5,84
    802061d8:	2781                	sext.w	a5,a5
    802061da:	85be                	mv	a1,a5
    802061dc:	00007517          	auipc	a0,0x7
    802061e0:	bbc50513          	addi	a0,a0,-1092 # 8020cd98 <simple_user_task_bin>
    802061e4:	fffff097          	auipc	ra,0xfffff
    802061e8:	dda080e7          	jalr	-550(ra) # 80204fbe <create_user_proc>
    802061ec:	87aa                	mv	a5,a0
    802061ee:	faf42623          	sw	a5,-84(s0)
    if (user_pid > 0) {
    802061f2:	fac42783          	lw	a5,-84(s0)
    802061f6:	2781                	sext.w	a5,a5
    802061f8:	02f05c63          	blez	a5,80206230 <test_process_creation+0x22c>
        printf("【测试结果】: 基本用户进程创建成功，PID: %d\n", user_pid);
    802061fc:	fac42783          	lw	a5,-84(s0)
    80206200:	85be                	mv	a1,a5
    80206202:	00007517          	auipc	a0,0x7
    80206206:	2fe50513          	addi	a0,a0,766 # 8020d500 <simple_user_task_bin+0x768>
    8020620a:	ffffb097          	auipc	ra,0xffffb
    8020620e:	a8a080e7          	jalr	-1398(ra) # 80200c94 <printf>
    printf("\n----- 用用户进程填满进程表 -----\n");
    80206212:	00007517          	auipc	a0,0x7
    80206216:	35e50513          	addi	a0,a0,862 # 8020d570 <simple_user_task_bin+0x7d8>
    8020621a:	ffffb097          	auipc	ra,0xffffb
    8020621e:	a7a080e7          	jalr	-1414(ra) # 80200c94 <printf>
    int user_count = 1; // 已经创建了一个
    80206222:	4785                	li	a5,1
    80206224:	fcf42e23          	sw	a5,-36(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206228:	4785                	li	a5,1
    8020622a:	fcf42c23          	sw	a5,-40(s0)
    8020622e:	a841                	j	802062be <test_process_creation+0x2ba>
        printf("【错误】: 基本用户进程创建失败\n");
    80206230:	00007517          	auipc	a0,0x7
    80206234:	31050513          	addi	a0,a0,784 # 8020d540 <simple_user_task_bin+0x7a8>
    80206238:	ffffb097          	auipc	ra,0xffffb
    8020623c:	a5c080e7          	jalr	-1444(ra) # 80200c94 <printf>
        return;
    80206240:	a615                	j	80206564 <test_process_creation+0x560>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206242:	05400793          	li	a5,84
    80206246:	2781                	sext.w	a5,a5
    80206248:	85be                	mv	a1,a5
    8020624a:	00007517          	auipc	a0,0x7
    8020624e:	b4e50513          	addi	a0,a0,-1202 # 8020cd98 <simple_user_task_bin>
    80206252:	fffff097          	auipc	ra,0xfffff
    80206256:	d6c080e7          	jalr	-660(ra) # 80204fbe <create_user_proc>
    8020625a:	87aa                	mv	a5,a0
    8020625c:	faf42423          	sw	a5,-88(s0)
        if (new_pid > 0) {
    80206260:	fa842783          	lw	a5,-88(s0)
    80206264:	2781                	sext.w	a5,a5
    80206266:	02f05b63          	blez	a5,8020629c <test_process_creation+0x298>
            user_count++;
    8020626a:	fdc42783          	lw	a5,-36(s0)
    8020626e:	2785                	addiw	a5,a5,1
    80206270:	fcf42e23          	sw	a5,-36(s0)
            if (user_count % 5 == 0) { // 每5个进程打印一次进度
    80206274:	fdc42783          	lw	a5,-36(s0)
    80206278:	873e                	mv	a4,a5
    8020627a:	4795                	li	a5,5
    8020627c:	02f767bb          	remw	a5,a4,a5
    80206280:	2781                	sext.w	a5,a5
    80206282:	eb8d                	bnez	a5,802062b4 <test_process_creation+0x2b0>
                printf("已创建 %d 个用户进程...\n", user_count);
    80206284:	fdc42783          	lw	a5,-36(s0)
    80206288:	85be                	mv	a1,a5
    8020628a:	00007517          	auipc	a0,0x7
    8020628e:	31650513          	addi	a0,a0,790 # 8020d5a0 <simple_user_task_bin+0x808>
    80206292:	ffffb097          	auipc	ra,0xffffb
    80206296:	a02080e7          	jalr	-1534(ra) # 80200c94 <printf>
    8020629a:	a829                	j	802062b4 <test_process_creation+0x2b0>
            warning("process table was full at %d user processes\n", user_count);
    8020629c:	fdc42783          	lw	a5,-36(s0)
    802062a0:	85be                	mv	a1,a5
    802062a2:	00007517          	auipc	a0,0x7
    802062a6:	32650513          	addi	a0,a0,806 # 8020d5c8 <simple_user_task_bin+0x830>
    802062aa:	ffffb097          	auipc	ra,0xffffb
    802062ae:	46a080e7          	jalr	1130(ra) # 80201714 <warning>
            break;
    802062b2:	a829                	j	802062cc <test_process_creation+0x2c8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    802062b4:	fd842783          	lw	a5,-40(s0)
    802062b8:	2785                	addiw	a5,a5,1
    802062ba:	fcf42c23          	sw	a5,-40(s0)
    802062be:	fd842783          	lw	a5,-40(s0)
    802062c2:	0007871b          	sext.w	a4,a5
    802062c6:	47fd                	li	a5,31
    802062c8:	f6e7dde3          	bge	a5,a4,80206242 <test_process_creation+0x23e>
    printf("【测试结果】: 成功创建 %d 个用户进程 (最大限制: %d)\n", user_count, PROC);
    802062cc:	fdc42783          	lw	a5,-36(s0)
    802062d0:	02000613          	li	a2,32
    802062d4:	85be                	mv	a1,a5
    802062d6:	00007517          	auipc	a0,0x7
    802062da:	32250513          	addi	a0,a0,802 # 8020d5f8 <simple_user_task_bin+0x860>
    802062de:	ffffb097          	auipc	ra,0xffffb
    802062e2:	9b6080e7          	jalr	-1610(ra) # 80200c94 <printf>
    print_proc_table();
    802062e6:	fffff097          	auipc	ra,0xfffff
    802062ea:	58e080e7          	jalr	1422(ra) # 80205874 <print_proc_table>
    printf("\n----- 等待并清理所有用户进程 -----\n");
    802062ee:	00007517          	auipc	a0,0x7
    802062f2:	35250513          	addi	a0,a0,850 # 8020d640 <simple_user_task_bin+0x8a8>
    802062f6:	ffffb097          	auipc	ra,0xffffb
    802062fa:	99e080e7          	jalr	-1634(ra) # 80200c94 <printf>
    int user_success_count = 0;
    802062fe:	fc042a23          	sw	zero,-44(s0)
    for (int i = 0; i < user_count; i++) {
    80206302:	fc042823          	sw	zero,-48(s0)
    80206306:	a895                	j	8020637a <test_process_creation+0x376>
        int waited_pid = wait_proc(NULL);
    80206308:	4501                	li	a0,0
    8020630a:	fffff097          	auipc	ra,0xfffff
    8020630e:	3dc080e7          	jalr	988(ra) # 802056e6 <wait_proc>
    80206312:	87aa                	mv	a5,a0
    80206314:	f8f42823          	sw	a5,-112(s0)
        if (waited_pid > 0) {
    80206318:	f9042783          	lw	a5,-112(s0)
    8020631c:	2781                	sext.w	a5,a5
    8020631e:	02f05e63          	blez	a5,8020635a <test_process_creation+0x356>
            user_success_count++;
    80206322:	fd442783          	lw	a5,-44(s0)
    80206326:	2785                	addiw	a5,a5,1
    80206328:	fcf42a23          	sw	a5,-44(s0)
            if (user_success_count % 5 == 0) { // 每5个进程打印一次进度
    8020632c:	fd442783          	lw	a5,-44(s0)
    80206330:	873e                	mv	a4,a5
    80206332:	4795                	li	a5,5
    80206334:	02f767bb          	remw	a5,a4,a5
    80206338:	2781                	sext.w	a5,a5
    8020633a:	eb9d                	bnez	a5,80206370 <test_process_creation+0x36c>
                printf("已回收 %d/%d 个用户进程...\n", user_success_count, user_count);
    8020633c:	fdc42703          	lw	a4,-36(s0)
    80206340:	fd442783          	lw	a5,-44(s0)
    80206344:	863a                	mv	a2,a4
    80206346:	85be                	mv	a1,a5
    80206348:	00007517          	auipc	a0,0x7
    8020634c:	32850513          	addi	a0,a0,808 # 8020d670 <simple_user_task_bin+0x8d8>
    80206350:	ffffb097          	auipc	ra,0xffffb
    80206354:	944080e7          	jalr	-1724(ra) # 80200c94 <printf>
    80206358:	a821                	j	80206370 <test_process_creation+0x36c>
            printf("【错误】: 等待用户进程失败，错误码: %d\n", waited_pid);
    8020635a:	f9042783          	lw	a5,-112(s0)
    8020635e:	85be                	mv	a1,a5
    80206360:	00007517          	auipc	a0,0x7
    80206364:	33850513          	addi	a0,a0,824 # 8020d698 <simple_user_task_bin+0x900>
    80206368:	ffffb097          	auipc	ra,0xffffb
    8020636c:	92c080e7          	jalr	-1748(ra) # 80200c94 <printf>
    for (int i = 0; i < user_count; i++) {
    80206370:	fd042783          	lw	a5,-48(s0)
    80206374:	2785                	addiw	a5,a5,1
    80206376:	fcf42823          	sw	a5,-48(s0)
    8020637a:	fd042783          	lw	a5,-48(s0)
    8020637e:	873e                	mv	a4,a5
    80206380:	fdc42783          	lw	a5,-36(s0)
    80206384:	2701                	sext.w	a4,a4
    80206386:	2781                	sext.w	a5,a5
    80206388:	f8f740e3          	blt	a4,a5,80206308 <test_process_creation+0x304>
    printf("【测试结果】: 回收 %d/%d 个用户进程\n", user_success_count, user_count);
    8020638c:	fdc42703          	lw	a4,-36(s0)
    80206390:	fd442783          	lw	a5,-44(s0)
    80206394:	863a                	mv	a2,a4
    80206396:	85be                	mv	a1,a5
    80206398:	00007517          	auipc	a0,0x7
    8020639c:	33850513          	addi	a0,a0,824 # 8020d6d0 <simple_user_task_bin+0x938>
    802063a0:	ffffb097          	auipc	ra,0xffffb
    802063a4:	8f4080e7          	jalr	-1804(ra) # 80200c94 <printf>
    print_proc_table();
    802063a8:	fffff097          	auipc	ra,0xfffff
    802063ac:	4cc080e7          	jalr	1228(ra) # 80205874 <print_proc_table>
    printf("\n----- 第三阶段：混合进程测试 -----\n");
    802063b0:	00007517          	auipc	a0,0x7
    802063b4:	35850513          	addi	a0,a0,856 # 8020d708 <simple_user_task_bin+0x970>
    802063b8:	ffffb097          	auipc	ra,0xffffb
    802063bc:	8dc080e7          	jalr	-1828(ra) # 80200c94 <printf>
    int mixed_kernel_count = 0;
    802063c0:	fc042623          	sw	zero,-52(s0)
    int mixed_user_count = 0;
    802063c4:	fc042423          	sw	zero,-56(s0)
    int target_count = PROC / 2;
    802063c8:	47c1                	li	a5,16
    802063ca:	faf42223          	sw	a5,-92(s0)
    printf("创建 %d 个内核进程和 %d 个用户进程...\n", target_count, target_count);
    802063ce:	fa442703          	lw	a4,-92(s0)
    802063d2:	fa442783          	lw	a5,-92(s0)
    802063d6:	863a                	mv	a2,a4
    802063d8:	85be                	mv	a1,a5
    802063da:	00007517          	auipc	a0,0x7
    802063de:	35e50513          	addi	a0,a0,862 # 8020d738 <simple_user_task_bin+0x9a0>
    802063e2:	ffffb097          	auipc	ra,0xffffb
    802063e6:	8b2080e7          	jalr	-1870(ra) # 80200c94 <printf>
    for (int i = 0; i < target_count; i++) {
    802063ea:	fc042223          	sw	zero,-60(s0)
    802063ee:	a81d                	j	80206424 <test_process_creation+0x420>
        int new_pid = create_kernel_proc(simple_task);
    802063f0:	00000517          	auipc	a0,0x0
    802063f4:	be450513          	addi	a0,a0,-1052 # 80205fd4 <simple_task>
    802063f8:	fffff097          	auipc	ra,0xfffff
    802063fc:	b58080e7          	jalr	-1192(ra) # 80204f50 <create_kernel_proc>
    80206400:	87aa                	mv	a5,a0
    80206402:	faf42023          	sw	a5,-96(s0)
        if (new_pid > 0) {
    80206406:	fa042783          	lw	a5,-96(s0)
    8020640a:	2781                	sext.w	a5,a5
    8020640c:	02f05663          	blez	a5,80206438 <test_process_creation+0x434>
            mixed_kernel_count++;
    80206410:	fcc42783          	lw	a5,-52(s0)
    80206414:	2785                	addiw	a5,a5,1
    80206416:	fcf42623          	sw	a5,-52(s0)
    for (int i = 0; i < target_count; i++) {
    8020641a:	fc442783          	lw	a5,-60(s0)
    8020641e:	2785                	addiw	a5,a5,1
    80206420:	fcf42223          	sw	a5,-60(s0)
    80206424:	fc442783          	lw	a5,-60(s0)
    80206428:	873e                	mv	a4,a5
    8020642a:	fa442783          	lw	a5,-92(s0)
    8020642e:	2701                	sext.w	a4,a4
    80206430:	2781                	sext.w	a5,a5
    80206432:	faf74fe3          	blt	a4,a5,802063f0 <test_process_creation+0x3ec>
    80206436:	a011                	j	8020643a <test_process_creation+0x436>
            break;
    80206438:	0001                	nop
    for (int i = 0; i < target_count; i++) {
    8020643a:	fc042023          	sw	zero,-64(s0)
    8020643e:	a83d                	j	8020647c <test_process_creation+0x478>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206440:	05400793          	li	a5,84
    80206444:	2781                	sext.w	a5,a5
    80206446:	85be                	mv	a1,a5
    80206448:	00007517          	auipc	a0,0x7
    8020644c:	95050513          	addi	a0,a0,-1712 # 8020cd98 <simple_user_task_bin>
    80206450:	fffff097          	auipc	ra,0xfffff
    80206454:	b6e080e7          	jalr	-1170(ra) # 80204fbe <create_user_proc>
    80206458:	87aa                	mv	a5,a0
    8020645a:	f8f42e23          	sw	a5,-100(s0)
        if (new_pid > 0) {
    8020645e:	f9c42783          	lw	a5,-100(s0)
    80206462:	2781                	sext.w	a5,a5
    80206464:	02f05663          	blez	a5,80206490 <test_process_creation+0x48c>
            mixed_user_count++;
    80206468:	fc842783          	lw	a5,-56(s0)
    8020646c:	2785                	addiw	a5,a5,1
    8020646e:	fcf42423          	sw	a5,-56(s0)
    for (int i = 0; i < target_count; i++) {
    80206472:	fc042783          	lw	a5,-64(s0)
    80206476:	2785                	addiw	a5,a5,1
    80206478:	fcf42023          	sw	a5,-64(s0)
    8020647c:	fc042783          	lw	a5,-64(s0)
    80206480:	873e                	mv	a4,a5
    80206482:	fa442783          	lw	a5,-92(s0)
    80206486:	2701                	sext.w	a4,a4
    80206488:	2781                	sext.w	a5,a5
    8020648a:	faf74be3          	blt	a4,a5,80206440 <test_process_creation+0x43c>
    8020648e:	a011                	j	80206492 <test_process_creation+0x48e>
            break;
    80206490:	0001                	nop
    printf("【混合测试结果】: 创建了 %d 个内核进程 + %d 个用户进程 = %d 个进程\n", 
    80206492:	fcc42783          	lw	a5,-52(s0)
    80206496:	873e                	mv	a4,a5
    80206498:	fc842783          	lw	a5,-56(s0)
    8020649c:	9fb9                	addw	a5,a5,a4
    8020649e:	0007869b          	sext.w	a3,a5
    802064a2:	fc842703          	lw	a4,-56(s0)
    802064a6:	fcc42783          	lw	a5,-52(s0)
    802064aa:	863a                	mv	a2,a4
    802064ac:	85be                	mv	a1,a5
    802064ae:	00007517          	auipc	a0,0x7
    802064b2:	2c250513          	addi	a0,a0,706 # 8020d770 <simple_user_task_bin+0x9d8>
    802064b6:	ffffa097          	auipc	ra,0xffffa
    802064ba:	7de080e7          	jalr	2014(ra) # 80200c94 <printf>
    print_proc_table();
    802064be:	fffff097          	auipc	ra,0xfffff
    802064c2:	3b6080e7          	jalr	950(ra) # 80205874 <print_proc_table>
    printf("\n----- 清理混合进程 -----\n");
    802064c6:	00007517          	auipc	a0,0x7
    802064ca:	30a50513          	addi	a0,a0,778 # 8020d7d0 <simple_user_task_bin+0xa38>
    802064ce:	ffffa097          	auipc	ra,0xffffa
    802064d2:	7c6080e7          	jalr	1990(ra) # 80200c94 <printf>
    int mixed_success_count = 0;
    802064d6:	fa042e23          	sw	zero,-68(s0)
    int total_mixed = mixed_kernel_count + mixed_user_count;
    802064da:	fcc42783          	lw	a5,-52(s0)
    802064de:	873e                	mv	a4,a5
    802064e0:	fc842783          	lw	a5,-56(s0)
    802064e4:	9fb9                	addw	a5,a5,a4
    802064e6:	f8f42c23          	sw	a5,-104(s0)
    for (int i = 0; i < total_mixed; i++) {
    802064ea:	fa042c23          	sw	zero,-72(s0)
    802064ee:	a805                	j	8020651e <test_process_creation+0x51a>
        int waited_pid = wait_proc(NULL);
    802064f0:	4501                	li	a0,0
    802064f2:	fffff097          	auipc	ra,0xfffff
    802064f6:	1f4080e7          	jalr	500(ra) # 802056e6 <wait_proc>
    802064fa:	87aa                	mv	a5,a0
    802064fc:	f8f42a23          	sw	a5,-108(s0)
        if (waited_pid > 0) {
    80206500:	f9442783          	lw	a5,-108(s0)
    80206504:	2781                	sext.w	a5,a5
    80206506:	00f05763          	blez	a5,80206514 <test_process_creation+0x510>
            mixed_success_count++;
    8020650a:	fbc42783          	lw	a5,-68(s0)
    8020650e:	2785                	addiw	a5,a5,1
    80206510:	faf42e23          	sw	a5,-68(s0)
    for (int i = 0; i < total_mixed; i++) {
    80206514:	fb842783          	lw	a5,-72(s0)
    80206518:	2785                	addiw	a5,a5,1
    8020651a:	faf42c23          	sw	a5,-72(s0)
    8020651e:	fb842783          	lw	a5,-72(s0)
    80206522:	873e                	mv	a4,a5
    80206524:	f9842783          	lw	a5,-104(s0)
    80206528:	2701                	sext.w	a4,a4
    8020652a:	2781                	sext.w	a5,a5
    8020652c:	fcf742e3          	blt	a4,a5,802064f0 <test_process_creation+0x4ec>
    printf("【混合测试结果】: 回收 %d/%d 个混合进程\n", mixed_success_count, total_mixed);
    80206530:	f9842703          	lw	a4,-104(s0)
    80206534:	fbc42783          	lw	a5,-68(s0)
    80206538:	863a                	mv	a2,a4
    8020653a:	85be                	mv	a1,a5
    8020653c:	00007517          	auipc	a0,0x7
    80206540:	2bc50513          	addi	a0,a0,700 # 8020d7f8 <simple_user_task_bin+0xa60>
    80206544:	ffffa097          	auipc	ra,0xffffa
    80206548:	750080e7          	jalr	1872(ra) # 80200c94 <printf>
    print_proc_table();
    8020654c:	fffff097          	auipc	ra,0xfffff
    80206550:	328080e7          	jalr	808(ra) # 80205874 <print_proc_table>
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    80206554:	00007517          	auipc	a0,0x7
    80206558:	2dc50513          	addi	a0,a0,732 # 8020d830 <simple_user_task_bin+0xa98>
    8020655c:	ffffa097          	auipc	ra,0xffffa
    80206560:	738080e7          	jalr	1848(ra) # 80200c94 <printf>
}
    80206564:	70e6                	ld	ra,120(sp)
    80206566:	7446                	ld	s0,112(sp)
    80206568:	6109                	addi	sp,sp,128
    8020656a:	8082                	ret

000000008020656c <test_user_fork>:
void test_user_fork(void) {
    8020656c:	1101                	addi	sp,sp,-32
    8020656e:	ec06                	sd	ra,24(sp)
    80206570:	e822                	sd	s0,16(sp)
    80206572:	1000                	addi	s0,sp,32
    printf("===== 测试开始: 用户进程Fork测试 =====\n");
    80206574:	00007517          	auipc	a0,0x7
    80206578:	2f450513          	addi	a0,a0,756 # 8020d868 <simple_user_task_bin+0xad0>
    8020657c:	ffffa097          	auipc	ra,0xffffa
    80206580:	718080e7          	jalr	1816(ra) # 80200c94 <printf>
    printf("\n----- 创建fork测试进程 -----\n");
    80206584:	00007517          	auipc	a0,0x7
    80206588:	31c50513          	addi	a0,a0,796 # 8020d8a0 <simple_user_task_bin+0xb08>
    8020658c:	ffffa097          	auipc	ra,0xffffa
    80206590:	708080e7          	jalr	1800(ra) # 80200c94 <printf>
    int fork_test_pid = create_user_proc(fork_user_test_bin, fork_user_test_bin_len);
    80206594:	44600793          	li	a5,1094
    80206598:	2781                	sext.w	a5,a5
    8020659a:	85be                	mv	a1,a5
    8020659c:	00006517          	auipc	a0,0x6
    802065a0:	36c50513          	addi	a0,a0,876 # 8020c908 <fork_user_test_bin>
    802065a4:	fffff097          	auipc	ra,0xfffff
    802065a8:	a1a080e7          	jalr	-1510(ra) # 80204fbe <create_user_proc>
    802065ac:	87aa                	mv	a5,a0
    802065ae:	fef42623          	sw	a5,-20(s0)
    if (fork_test_pid < 0) {
    802065b2:	fec42783          	lw	a5,-20(s0)
    802065b6:	2781                	sext.w	a5,a5
    802065b8:	0007db63          	bgez	a5,802065ce <test_user_fork+0x62>
        printf("【错误】: 创建fork测试进程失败\n");
    802065bc:	00007517          	auipc	a0,0x7
    802065c0:	30c50513          	addi	a0,a0,780 # 8020d8c8 <simple_user_task_bin+0xb30>
    802065c4:	ffffa097          	auipc	ra,0xffffa
    802065c8:	6d0080e7          	jalr	1744(ra) # 80200c94 <printf>
    802065cc:	a865                	j	80206684 <test_user_fork+0x118>
    printf("【测试结果】: 创建fork测试进程成功，PID: %d\n", fork_test_pid);
    802065ce:	fec42783          	lw	a5,-20(s0)
    802065d2:	85be                	mv	a1,a5
    802065d4:	00007517          	auipc	a0,0x7
    802065d8:	32450513          	addi	a0,a0,804 # 8020d8f8 <simple_user_task_bin+0xb60>
    802065dc:	ffffa097          	auipc	ra,0xffffa
    802065e0:	6b8080e7          	jalr	1720(ra) # 80200c94 <printf>
    printf("\n----- 等待fork测试进程完成 -----\n");
    802065e4:	00007517          	auipc	a0,0x7
    802065e8:	35450513          	addi	a0,a0,852 # 8020d938 <simple_user_task_bin+0xba0>
    802065ec:	ffffa097          	auipc	ra,0xffffa
    802065f0:	6a8080e7          	jalr	1704(ra) # 80200c94 <printf>
    int waited_pid = wait_proc(&status);
    802065f4:	fe440793          	addi	a5,s0,-28
    802065f8:	853e                	mv	a0,a5
    802065fa:	fffff097          	auipc	ra,0xfffff
    802065fe:	0ec080e7          	jalr	236(ra) # 802056e6 <wait_proc>
    80206602:	87aa                	mv	a5,a0
    80206604:	fef42423          	sw	a5,-24(s0)
    if (waited_pid == fork_test_pid) {
    80206608:	fe842783          	lw	a5,-24(s0)
    8020660c:	873e                	mv	a4,a5
    8020660e:	fec42783          	lw	a5,-20(s0)
    80206612:	2701                	sext.w	a4,a4
    80206614:	2781                	sext.w	a5,a5
    80206616:	02f71963          	bne	a4,a5,80206648 <test_user_fork+0xdc>
        printf("【测试结果】: fork测试进程(PID: %d)完成，状态码: %d\n", fork_test_pid, status);
    8020661a:	fe442703          	lw	a4,-28(s0)
    8020661e:	fec42783          	lw	a5,-20(s0)
    80206622:	863a                	mv	a2,a4
    80206624:	85be                	mv	a1,a5
    80206626:	00007517          	auipc	a0,0x7
    8020662a:	34250513          	addi	a0,a0,834 # 8020d968 <simple_user_task_bin+0xbd0>
    8020662e:	ffffa097          	auipc	ra,0xffffa
    80206632:	666080e7          	jalr	1638(ra) # 80200c94 <printf>
        printf("✓ Fork测试: 通过\n");
    80206636:	00007517          	auipc	a0,0x7
    8020663a:	37a50513          	addi	a0,a0,890 # 8020d9b0 <simple_user_task_bin+0xc18>
    8020663e:	ffffa097          	auipc	ra,0xffffa
    80206642:	656080e7          	jalr	1622(ra) # 80200c94 <printf>
    80206646:	a03d                	j	80206674 <test_user_fork+0x108>
        printf("【错误】: 等待fork测试进程时出错，等待到PID: %d，期望PID: %d\n", waited_pid, fork_test_pid);
    80206648:	fec42703          	lw	a4,-20(s0)
    8020664c:	fe842783          	lw	a5,-24(s0)
    80206650:	863a                	mv	a2,a4
    80206652:	85be                	mv	a1,a5
    80206654:	00007517          	auipc	a0,0x7
    80206658:	37450513          	addi	a0,a0,884 # 8020d9c8 <simple_user_task_bin+0xc30>
    8020665c:	ffffa097          	auipc	ra,0xffffa
    80206660:	638080e7          	jalr	1592(ra) # 80200c94 <printf>
        printf("✗ Fork测试: 失败\n");
    80206664:	00007517          	auipc	a0,0x7
    80206668:	3bc50513          	addi	a0,a0,956 # 8020da20 <simple_user_task_bin+0xc88>
    8020666c:	ffffa097          	auipc	ra,0xffffa
    80206670:	628080e7          	jalr	1576(ra) # 80200c94 <printf>
    printf("===== 测试结束: 用户进程Fork测试 =====\n");
    80206674:	00007517          	auipc	a0,0x7
    80206678:	3c450513          	addi	a0,a0,964 # 8020da38 <simple_user_task_bin+0xca0>
    8020667c:	ffffa097          	auipc	ra,0xffffa
    80206680:	618080e7          	jalr	1560(ra) # 80200c94 <printf>
}
    80206684:	60e2                	ld	ra,24(sp)
    80206686:	6442                	ld	s0,16(sp)
    80206688:	6105                	addi	sp,sp,32
    8020668a:	8082                	ret

000000008020668c <cpu_intensive_task>:
void cpu_intensive_task(void) {
    8020668c:	1101                	addi	sp,sp,-32
    8020668e:	ec06                	sd	ra,24(sp)
    80206690:	e822                	sd	s0,16(sp)
    80206692:	1000                	addi	s0,sp,32
    uint64 sum = 0;
    80206694:	fe043423          	sd	zero,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    80206698:	fe043023          	sd	zero,-32(s0)
    8020669c:	a829                	j	802066b6 <cpu_intensive_task+0x2a>
        sum += i;
    8020669e:	fe843703          	ld	a4,-24(s0)
    802066a2:	fe043783          	ld	a5,-32(s0)
    802066a6:	97ba                	add	a5,a5,a4
    802066a8:	fef43423          	sd	a5,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    802066ac:	fe043783          	ld	a5,-32(s0)
    802066b0:	0785                	addi	a5,a5,1
    802066b2:	fef43023          	sd	a5,-32(s0)
    802066b6:	fe043703          	ld	a4,-32(s0)
    802066ba:	009897b7          	lui	a5,0x989
    802066be:	67f78793          	addi	a5,a5,1663 # 98967f <_entry-0x7f876981>
    802066c2:	fce7fee3          	bgeu	a5,a4,8020669e <cpu_intensive_task+0x12>
    printf("CPU intensive task done in PID %d, sum=%lu\n", myproc()->pid, sum);
    802066c6:	ffffe097          	auipc	ra,0xffffe
    802066ca:	28a080e7          	jalr	650(ra) # 80204950 <myproc>
    802066ce:	87aa                	mv	a5,a0
    802066d0:	43dc                	lw	a5,4(a5)
    802066d2:	fe843603          	ld	a2,-24(s0)
    802066d6:	85be                	mv	a1,a5
    802066d8:	00007517          	auipc	a0,0x7
    802066dc:	39850513          	addi	a0,a0,920 # 8020da70 <simple_user_task_bin+0xcd8>
    802066e0:	ffffa097          	auipc	ra,0xffffa
    802066e4:	5b4080e7          	jalr	1460(ra) # 80200c94 <printf>
    exit_proc(0);
    802066e8:	4501                	li	a0,0
    802066ea:	fffff097          	auipc	ra,0xfffff
    802066ee:	f32080e7          	jalr	-206(ra) # 8020561c <exit_proc>
}
    802066f2:	0001                	nop
    802066f4:	60e2                	ld	ra,24(sp)
    802066f6:	6442                	ld	s0,16(sp)
    802066f8:	6105                	addi	sp,sp,32
    802066fa:	8082                	ret

00000000802066fc <test_scheduler>:
void test_scheduler(void) {
    802066fc:	7179                	addi	sp,sp,-48
    802066fe:	f406                	sd	ra,40(sp)
    80206700:	f022                	sd	s0,32(sp)
    80206702:	1800                	addi	s0,sp,48
    printf("===== 测试开始: 调度器测试 =====\n");
    80206704:	00007517          	auipc	a0,0x7
    80206708:	39c50513          	addi	a0,a0,924 # 8020daa0 <simple_user_task_bin+0xd08>
    8020670c:	ffffa097          	auipc	ra,0xffffa
    80206710:	588080e7          	jalr	1416(ra) # 80200c94 <printf>
    for (int i = 0; i < 3; i++) {
    80206714:	fe042623          	sw	zero,-20(s0)
    80206718:	a831                	j	80206734 <test_scheduler+0x38>
        create_kernel_proc(cpu_intensive_task);
    8020671a:	00000517          	auipc	a0,0x0
    8020671e:	f7250513          	addi	a0,a0,-142 # 8020668c <cpu_intensive_task>
    80206722:	fffff097          	auipc	ra,0xfffff
    80206726:	82e080e7          	jalr	-2002(ra) # 80204f50 <create_kernel_proc>
    for (int i = 0; i < 3; i++) {
    8020672a:	fec42783          	lw	a5,-20(s0)
    8020672e:	2785                	addiw	a5,a5,1
    80206730:	fef42623          	sw	a5,-20(s0)
    80206734:	fec42783          	lw	a5,-20(s0)
    80206738:	0007871b          	sext.w	a4,a5
    8020673c:	4789                	li	a5,2
    8020673e:	fce7dee3          	bge	a5,a4,8020671a <test_scheduler+0x1e>
    uint64 start_time = get_time();
    80206742:	fffff097          	auipc	ra,0xfffff
    80206746:	498080e7          	jalr	1176(ra) # 80205bda <get_time>
    8020674a:	fea43023          	sd	a0,-32(s0)
	for (int i = 0; i < 3; i++) {
    8020674e:	fe042423          	sw	zero,-24(s0)
    80206752:	a819                	j	80206768 <test_scheduler+0x6c>
    	wait_proc(NULL); // 等待所有子进程结束
    80206754:	4501                	li	a0,0
    80206756:	fffff097          	auipc	ra,0xfffff
    8020675a:	f90080e7          	jalr	-112(ra) # 802056e6 <wait_proc>
	for (int i = 0; i < 3; i++) {
    8020675e:	fe842783          	lw	a5,-24(s0)
    80206762:	2785                	addiw	a5,a5,1
    80206764:	fef42423          	sw	a5,-24(s0)
    80206768:	fe842783          	lw	a5,-24(s0)
    8020676c:	0007871b          	sext.w	a4,a5
    80206770:	4789                	li	a5,2
    80206772:	fee7d1e3          	bge	a5,a4,80206754 <test_scheduler+0x58>
    uint64 end_time = get_time();
    80206776:	fffff097          	auipc	ra,0xfffff
    8020677a:	464080e7          	jalr	1124(ra) # 80205bda <get_time>
    8020677e:	fca43c23          	sd	a0,-40(s0)
    printf("Scheduler test completed in %lu cycles\n", end_time - start_time);
    80206782:	fd843703          	ld	a4,-40(s0)
    80206786:	fe043783          	ld	a5,-32(s0)
    8020678a:	40f707b3          	sub	a5,a4,a5
    8020678e:	85be                	mv	a1,a5
    80206790:	00007517          	auipc	a0,0x7
    80206794:	34050513          	addi	a0,a0,832 # 8020dad0 <simple_user_task_bin+0xd38>
    80206798:	ffffa097          	auipc	ra,0xffffa
    8020679c:	4fc080e7          	jalr	1276(ra) # 80200c94 <printf>
    printf("===== 测试结束 =====\n");
    802067a0:	00007517          	auipc	a0,0x7
    802067a4:	35850513          	addi	a0,a0,856 # 8020daf8 <simple_user_task_bin+0xd60>
    802067a8:	ffffa097          	auipc	ra,0xffffa
    802067ac:	4ec080e7          	jalr	1260(ra) # 80200c94 <printf>
}
    802067b0:	0001                	nop
    802067b2:	70a2                	ld	ra,40(sp)
    802067b4:	7402                	ld	s0,32(sp)
    802067b6:	6145                	addi	sp,sp,48
    802067b8:	8082                	ret

00000000802067ba <shared_buffer_init>:
void shared_buffer_init() {
    802067ba:	1141                	addi	sp,sp,-16
    802067bc:	e422                	sd	s0,8(sp)
    802067be:	0800                	addi	s0,sp,16
    proc_buffer = 0;
    802067c0:	00009797          	auipc	a5,0x9
    802067c4:	f2c78793          	addi	a5,a5,-212 # 8020f6ec <proc_buffer>
    802067c8:	0007a023          	sw	zero,0(a5)
    proc_produced = 0;
    802067cc:	00009797          	auipc	a5,0x9
    802067d0:	f2478793          	addi	a5,a5,-220 # 8020f6f0 <proc_produced>
    802067d4:	0007a023          	sw	zero,0(a5)
}
    802067d8:	0001                	nop
    802067da:	6422                	ld	s0,8(sp)
    802067dc:	0141                	addi	sp,sp,16
    802067de:	8082                	ret

00000000802067e0 <producer_task>:
void producer_task(void) {
    802067e0:	1141                	addi	sp,sp,-16
    802067e2:	e406                	sd	ra,8(sp)
    802067e4:	e022                	sd	s0,0(sp)
    802067e6:	0800                	addi	s0,sp,16
    proc_buffer = 42;
    802067e8:	00009797          	auipc	a5,0x9
    802067ec:	f0478793          	addi	a5,a5,-252 # 8020f6ec <proc_buffer>
    802067f0:	02a00713          	li	a4,42
    802067f4:	c398                	sw	a4,0(a5)
    proc_produced = 1;
    802067f6:	00009797          	auipc	a5,0x9
    802067fa:	efa78793          	addi	a5,a5,-262 # 8020f6f0 <proc_produced>
    802067fe:	4705                	li	a4,1
    80206800:	c398                	sw	a4,0(a5)
    wakeup(&proc_produced); // 唤醒消费者
    80206802:	00009517          	auipc	a0,0x9
    80206806:	eee50513          	addi	a0,a0,-274 # 8020f6f0 <proc_produced>
    8020680a:	fffff097          	auipc	ra,0xfffff
    8020680e:	da6080e7          	jalr	-602(ra) # 802055b0 <wakeup>
    printf("Producer: produced value %d\n", proc_buffer);
    80206812:	00009797          	auipc	a5,0x9
    80206816:	eda78793          	addi	a5,a5,-294 # 8020f6ec <proc_buffer>
    8020681a:	439c                	lw	a5,0(a5)
    8020681c:	85be                	mv	a1,a5
    8020681e:	00007517          	auipc	a0,0x7
    80206822:	2fa50513          	addi	a0,a0,762 # 8020db18 <simple_user_task_bin+0xd80>
    80206826:	ffffa097          	auipc	ra,0xffffa
    8020682a:	46e080e7          	jalr	1134(ra) # 80200c94 <printf>
    exit_proc(0);
    8020682e:	4501                	li	a0,0
    80206830:	fffff097          	auipc	ra,0xfffff
    80206834:	dec080e7          	jalr	-532(ra) # 8020561c <exit_proc>
}
    80206838:	0001                	nop
    8020683a:	60a2                	ld	ra,8(sp)
    8020683c:	6402                	ld	s0,0(sp)
    8020683e:	0141                	addi	sp,sp,16
    80206840:	8082                	ret

0000000080206842 <consumer_task>:
void consumer_task(void) {
    80206842:	1141                	addi	sp,sp,-16
    80206844:	e406                	sd	ra,8(sp)
    80206846:	e022                	sd	s0,0(sp)
    80206848:	0800                	addi	s0,sp,16
    while (!proc_produced) {
    8020684a:	a809                	j	8020685c <consumer_task+0x1a>
        sleep(&proc_produced); // 等待生产者
    8020684c:	00009517          	auipc	a0,0x9
    80206850:	ea450513          	addi	a0,a0,-348 # 8020f6f0 <proc_produced>
    80206854:	fffff097          	auipc	ra,0xfffff
    80206858:	cf2080e7          	jalr	-782(ra) # 80205546 <sleep>
    while (!proc_produced) {
    8020685c:	00009797          	auipc	a5,0x9
    80206860:	e9478793          	addi	a5,a5,-364 # 8020f6f0 <proc_produced>
    80206864:	439c                	lw	a5,0(a5)
    80206866:	d3fd                	beqz	a5,8020684c <consumer_task+0xa>
    printf("Consumer: consumed value %d\n", proc_buffer);
    80206868:	00009797          	auipc	a5,0x9
    8020686c:	e8478793          	addi	a5,a5,-380 # 8020f6ec <proc_buffer>
    80206870:	439c                	lw	a5,0(a5)
    80206872:	85be                	mv	a1,a5
    80206874:	00007517          	auipc	a0,0x7
    80206878:	2c450513          	addi	a0,a0,708 # 8020db38 <simple_user_task_bin+0xda0>
    8020687c:	ffffa097          	auipc	ra,0xffffa
    80206880:	418080e7          	jalr	1048(ra) # 80200c94 <printf>
    exit_proc(0);
    80206884:	4501                	li	a0,0
    80206886:	fffff097          	auipc	ra,0xfffff
    8020688a:	d96080e7          	jalr	-618(ra) # 8020561c <exit_proc>
}
    8020688e:	0001                	nop
    80206890:	60a2                	ld	ra,8(sp)
    80206892:	6402                	ld	s0,0(sp)
    80206894:	0141                	addi	sp,sp,16
    80206896:	8082                	ret

0000000080206898 <test_synchronization>:
void test_synchronization(void) {
    80206898:	1141                	addi	sp,sp,-16
    8020689a:	e406                	sd	ra,8(sp)
    8020689c:	e022                	sd	s0,0(sp)
    8020689e:	0800                	addi	s0,sp,16
    printf("===== 测试开始: 同步机制测试 =====\n");
    802068a0:	00007517          	auipc	a0,0x7
    802068a4:	2b850513          	addi	a0,a0,696 # 8020db58 <simple_user_task_bin+0xdc0>
    802068a8:	ffffa097          	auipc	ra,0xffffa
    802068ac:	3ec080e7          	jalr	1004(ra) # 80200c94 <printf>
    shared_buffer_init();
    802068b0:	00000097          	auipc	ra,0x0
    802068b4:	f0a080e7          	jalr	-246(ra) # 802067ba <shared_buffer_init>
    create_kernel_proc(producer_task);
    802068b8:	00000517          	auipc	a0,0x0
    802068bc:	f2850513          	addi	a0,a0,-216 # 802067e0 <producer_task>
    802068c0:	ffffe097          	auipc	ra,0xffffe
    802068c4:	690080e7          	jalr	1680(ra) # 80204f50 <create_kernel_proc>
    create_kernel_proc(consumer_task);
    802068c8:	00000517          	auipc	a0,0x0
    802068cc:	f7a50513          	addi	a0,a0,-134 # 80206842 <consumer_task>
    802068d0:	ffffe097          	auipc	ra,0xffffe
    802068d4:	680080e7          	jalr	1664(ra) # 80204f50 <create_kernel_proc>
    wait_proc(NULL);
    802068d8:	4501                	li	a0,0
    802068da:	fffff097          	auipc	ra,0xfffff
    802068de:	e0c080e7          	jalr	-500(ra) # 802056e6 <wait_proc>
    wait_proc(NULL);
    802068e2:	4501                	li	a0,0
    802068e4:	fffff097          	auipc	ra,0xfffff
    802068e8:	e02080e7          	jalr	-510(ra) # 802056e6 <wait_proc>
    printf("===== 测试结束 =====\n");
    802068ec:	00007517          	auipc	a0,0x7
    802068f0:	20c50513          	addi	a0,a0,524 # 8020daf8 <simple_user_task_bin+0xd60>
    802068f4:	ffffa097          	auipc	ra,0xffffa
    802068f8:	3a0080e7          	jalr	928(ra) # 80200c94 <printf>
}
    802068fc:	0001                	nop
    802068fe:	60a2                	ld	ra,8(sp)
    80206900:	6402                	ld	s0,0(sp)
    80206902:	0141                	addi	sp,sp,16
    80206904:	8082                	ret

0000000080206906 <sys_access_task>:
void sys_access_task(void) {
    80206906:	1101                	addi	sp,sp,-32
    80206908:	ec06                	sd	ra,24(sp)
    8020690a:	e822                	sd	s0,16(sp)
    8020690c:	1000                	addi	s0,sp,32
    volatile int *ptr = (int*)0x80200000; // 内核空间地址
    8020690e:	40100793          	li	a5,1025
    80206912:	07d6                	slli	a5,a5,0x15
    80206914:	fef43423          	sd	a5,-24(s0)
    printf("SYS: try read kernel addr 0x80200000\n");
    80206918:	00007517          	auipc	a0,0x7
    8020691c:	27050513          	addi	a0,a0,624 # 8020db88 <simple_user_task_bin+0xdf0>
    80206920:	ffffa097          	auipc	ra,0xffffa
    80206924:	374080e7          	jalr	884(ra) # 80200c94 <printf>
    int val = *ptr;
    80206928:	fe843783          	ld	a5,-24(s0)
    8020692c:	439c                	lw	a5,0(a5)
    8020692e:	fef42223          	sw	a5,-28(s0)
    printf("SYS: read success, value=%d\n", val);
    80206932:	fe442783          	lw	a5,-28(s0)
    80206936:	85be                	mv	a1,a5
    80206938:	00007517          	auipc	a0,0x7
    8020693c:	27850513          	addi	a0,a0,632 # 8020dbb0 <simple_user_task_bin+0xe18>
    80206940:	ffffa097          	auipc	ra,0xffffa
    80206944:	354080e7          	jalr	852(ra) # 80200c94 <printf>
    exit_proc(0);
    80206948:	4501                	li	a0,0
    8020694a:	fffff097          	auipc	ra,0xfffff
    8020694e:	cd2080e7          	jalr	-814(ra) # 8020561c <exit_proc>
    80206952:	0001                	nop
    80206954:	60e2                	ld	ra,24(sp)
    80206956:	6442                	ld	s0,16(sp)
    80206958:	6105                	addi	sp,sp,32
    8020695a:	8082                	ret
	...
