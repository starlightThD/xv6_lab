
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80200000:	00017117          	auipc	sp,0x17
    80200004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80200008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8020000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8020000c:	00018517          	auipc	a0,0x18
    80200010:	0a450513          	addi	a0,a0,164 # 802180b0 <kernel_pagetable>
        la a1,_bss_end
    80200014:	00018597          	auipc	a1,0x18
    80200018:	6fc58593          	addi	a1,a1,1788 # 80218710 <_bss_end>

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
    80200032:	1101                	addi	sp,sp,-32 # 80216fe0 <simple_user_task_bin+0x1c18>
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
    80200098:	03500793          	li	a5,53
    8020009c:	2781                	sext.w	a5,a5
    8020009e:	85be                	mv	a1,a5
    802000a0:	00009517          	auipc	a0,0x9
    802000a4:	93850513          	addi	a0,a0,-1736 # 802089d8 <hello_world_bin>
    802000a8:	00005097          	auipc	ra,0x5
    802000ac:	124080e7          	jalr	292(ra) # 802051cc <create_user_proc>
	wait_proc(NULL);
    802000b0:	4501                	li	a0,0
    802000b2:	00006097          	auipc	ra,0x6
    802000b6:	860080e7          	jalr	-1952(ra) # 80205912 <wait_proc>
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
    802000f4:	00009517          	auipc	a0,0x9
    802000f8:	ee450513          	addi	a0,a0,-284 # 80208fd8 <simple_user_task_bin+0x140>
    802000fc:	00001097          	auipc	ra,0x1
    80200100:	b98080e7          	jalr	-1128(ra) # 80200c94 <printf>
    printf("        RISC-V Operating System v1.0         \n");
    80200104:	00009517          	auipc	a0,0x9
    80200108:	f0c50513          	addi	a0,a0,-244 # 80209010 <simple_user_task_bin+0x178>
    8020010c:	00001097          	auipc	ra,0x1
    80200110:	b88080e7          	jalr	-1144(ra) # 80200c94 <printf>
    printf("===============================================\n\n");
    80200114:	00009517          	auipc	a0,0x9
    80200118:	f2c50513          	addi	a0,a0,-212 # 80209040 <simple_user_task_bin+0x1a8>
    8020011c:	00001097          	auipc	ra,0x1
    80200120:	b78080e7          	jalr	-1160(ra) # 80200c94 <printf>
	init_proc(); // 初始化进程管理子系统
    80200124:	00005097          	auipc	ra,0x5
    80200128:	b82080e7          	jalr	-1150(ra) # 80204ca6 <init_proc>
	int main_pid = create_kernel_proc(kernel_main);
    8020012c:	00000517          	auipc	a0,0x0
    80200130:	3d250513          	addi	a0,a0,978 # 802004fe <kernel_main>
    80200134:	00005097          	auipc	ra,0x5
    80200138:	fac080e7          	jalr	-84(ra) # 802050e0 <create_kernel_proc>
    8020013c:	87aa                	mv	a5,a0
    8020013e:	fef42623          	sw	a5,-20(s0)
	if (main_pid < 0){
    80200142:	fec42783          	lw	a5,-20(s0)
    80200146:	2781                	sext.w	a5,a5
    80200148:	0007da63          	bgez	a5,8020015c <start+0x98>
		panic("START: create main process failed!\n");
    8020014c:	00009517          	auipc	a0,0x9
    80200150:	f2c50513          	addi	a0,a0,-212 # 80209078 <simple_user_task_bin+0x1e0>
    80200154:	00001097          	auipc	ra,0x1
    80200158:	58c080e7          	jalr	1420(ra) # 802016e0 <panic>
	schedule();
    8020015c:	00005097          	auipc	ra,0x5
    80200160:	430080e7          	jalr	1072(ra) # 8020558c <schedule>
    panic("START: main() exit unexpectedly!!!\n");
    80200164:	00009517          	auipc	a0,0x9
    80200168:	f3c50513          	addi	a0,a0,-196 # 802090a0 <simple_user_task_bin+0x208>
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
    8020018a:	00009517          	auipc	a0,0x9
    8020018e:	f3e50513          	addi	a0,a0,-194 # 802090c8 <simple_user_task_bin+0x230>
    80200192:	00001097          	auipc	ra,0x1
    80200196:	b02080e7          	jalr	-1278(ra) # 80200c94 <printf>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    8020019a:	fe042423          	sw	zero,-24(s0)
    8020019e:	a0b9                	j	802001ec <console+0x6e>
        printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
    802001a0:	00018697          	auipc	a3,0x18
    802001a4:	e6068693          	addi	a3,a3,-416 # 80218000 <command_table>
    802001a8:	fe842703          	lw	a4,-24(s0)
    802001ac:	87ba                	mv	a5,a4
    802001ae:	0786                	slli	a5,a5,0x1
    802001b0:	97ba                	add	a5,a5,a4
    802001b2:	078e                	slli	a5,a5,0x3
    802001b4:	97b6                	add	a5,a5,a3
    802001b6:	638c                	ld	a1,0(a5)
    802001b8:	00018697          	auipc	a3,0x18
    802001bc:	e4868693          	addi	a3,a3,-440 # 80218000 <command_table>
    802001c0:	fe842703          	lw	a4,-24(s0)
    802001c4:	87ba                	mv	a5,a4
    802001c6:	0786                	slli	a5,a5,0x1
    802001c8:	97ba                	add	a5,a5,a4
    802001ca:	078e                	slli	a5,a5,0x3
    802001cc:	97b6                	add	a5,a5,a3
    802001ce:	6b9c                	ld	a5,16(a5)
    802001d0:	863e                	mv	a2,a5
    802001d2:	00009517          	auipc	a0,0x9
    802001d6:	f0650513          	addi	a0,a0,-250 # 802090d8 <simple_user_task_bin+0x240>
    802001da:	00001097          	auipc	ra,0x1
    802001de:	aba080e7          	jalr	-1350(ra) # 80200c94 <printf>
    for (int i = 0; i < COMMAND_COUNT; i++) {
    802001e2:	fe842783          	lw	a5,-24(s0)
    802001e6:	2785                	addiw	a5,a5,1
    802001e8:	fef42423          	sw	a5,-24(s0)
    802001ec:	fe842783          	lw	a5,-24(s0)
    802001f0:	873e                	mv	a4,a5
    802001f2:	4795                	li	a5,5
    802001f4:	fae7f6e3          	bgeu	a5,a4,802001a0 <console+0x22>
    printf("  help          - 显示此帮助\n");
    802001f8:	00009517          	auipc	a0,0x9
    802001fc:	ef050513          	addi	a0,a0,-272 # 802090e8 <simple_user_task_bin+0x250>
    80200200:	00001097          	auipc	ra,0x1
    80200204:	a94080e7          	jalr	-1388(ra) # 80200c94 <printf>
    printf("  exit          - 退出控制台\n");
    80200208:	00009517          	auipc	a0,0x9
    8020020c:	f0850513          	addi	a0,a0,-248 # 80209110 <simple_user_task_bin+0x278>
    80200210:	00001097          	auipc	ra,0x1
    80200214:	a84080e7          	jalr	-1404(ra) # 80200c94 <printf>
    printf("  ps            - 显示进程状态\n");
    80200218:	00009517          	auipc	a0,0x9
    8020021c:	f2050513          	addi	a0,a0,-224 # 80209138 <simple_user_task_bin+0x2a0>
    80200220:	00001097          	auipc	ra,0x1
    80200224:	a74080e7          	jalr	-1420(ra) # 80200c94 <printf>
    while (!exit_requested) {
    80200228:	ac4d                	j	802004da <console+0x35c>
        printf("Console >>> ");
    8020022a:	00009517          	auipc	a0,0x9
    8020022e:	f3650513          	addi	a0,a0,-202 # 80209160 <simple_user_task_bin+0x2c8>
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
    80200250:	00009597          	auipc	a1,0x9
    80200254:	f2058593          	addi	a1,a1,-224 # 80209170 <simple_user_task_bin+0x2d8>
    80200258:	853e                	mv	a0,a5
    8020025a:	00006097          	auipc	ra,0x6
    8020025e:	ab8080e7          	jalr	-1352(ra) # 80205d12 <strcmp>
    80200262:	87aa                	mv	a5,a0
    80200264:	e789                	bnez	a5,8020026e <console+0xf0>
            exit_requested = 1;
    80200266:	4785                	li	a5,1
    80200268:	fef42623          	sw	a5,-20(s0)
    8020026c:	a4bd                	j	802004da <console+0x35c>
        } else if (strcmp(input_buffer, "help") == 0) {
    8020026e:	ed040793          	addi	a5,s0,-304
    80200272:	00009597          	auipc	a1,0x9
    80200276:	f0658593          	addi	a1,a1,-250 # 80209178 <simple_user_task_bin+0x2e0>
    8020027a:	853e                	mv	a0,a5
    8020027c:	00006097          	auipc	ra,0x6
    80200280:	a96080e7          	jalr	-1386(ra) # 80205d12 <strcmp>
    80200284:	87aa                	mv	a5,a0
    80200286:	e3cd                	bnez	a5,80200328 <console+0x1aa>
            printf("可用命令:\n");
    80200288:	00009517          	auipc	a0,0x9
    8020028c:	e4050513          	addi	a0,a0,-448 # 802090c8 <simple_user_task_bin+0x230>
    80200290:	00001097          	auipc	ra,0x1
    80200294:	a04080e7          	jalr	-1532(ra) # 80200c94 <printf>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    80200298:	fe042223          	sw	zero,-28(s0)
    8020029c:	a0b9                	j	802002ea <console+0x16c>
                printf("  %s - %s\n", command_table[i].name, command_table[i].desc);
    8020029e:	00018697          	auipc	a3,0x18
    802002a2:	d6268693          	addi	a3,a3,-670 # 80218000 <command_table>
    802002a6:	fe442703          	lw	a4,-28(s0)
    802002aa:	87ba                	mv	a5,a4
    802002ac:	0786                	slli	a5,a5,0x1
    802002ae:	97ba                	add	a5,a5,a4
    802002b0:	078e                	slli	a5,a5,0x3
    802002b2:	97b6                	add	a5,a5,a3
    802002b4:	638c                	ld	a1,0(a5)
    802002b6:	00018697          	auipc	a3,0x18
    802002ba:	d4a68693          	addi	a3,a3,-694 # 80218000 <command_table>
    802002be:	fe442703          	lw	a4,-28(s0)
    802002c2:	87ba                	mv	a5,a4
    802002c4:	0786                	slli	a5,a5,0x1
    802002c6:	97ba                	add	a5,a5,a4
    802002c8:	078e                	slli	a5,a5,0x3
    802002ca:	97b6                	add	a5,a5,a3
    802002cc:	6b9c                	ld	a5,16(a5)
    802002ce:	863e                	mv	a2,a5
    802002d0:	00009517          	auipc	a0,0x9
    802002d4:	e0850513          	addi	a0,a0,-504 # 802090d8 <simple_user_task_bin+0x240>
    802002d8:	00001097          	auipc	ra,0x1
    802002dc:	9bc080e7          	jalr	-1604(ra) # 80200c94 <printf>
            for (int i = 0; i < COMMAND_COUNT; i++) {
    802002e0:	fe442783          	lw	a5,-28(s0)
    802002e4:	2785                	addiw	a5,a5,1
    802002e6:	fef42223          	sw	a5,-28(s0)
    802002ea:	fe442783          	lw	a5,-28(s0)
    802002ee:	873e                	mv	a4,a5
    802002f0:	4795                	li	a5,5
    802002f2:	fae7f6e3          	bgeu	a5,a4,8020029e <console+0x120>
            printf("  help          - 显示此帮助\n");
    802002f6:	00009517          	auipc	a0,0x9
    802002fa:	df250513          	addi	a0,a0,-526 # 802090e8 <simple_user_task_bin+0x250>
    802002fe:	00001097          	auipc	ra,0x1
    80200302:	996080e7          	jalr	-1642(ra) # 80200c94 <printf>
            printf("  exit          - 退出控制台\n");
    80200306:	00009517          	auipc	a0,0x9
    8020030a:	e0a50513          	addi	a0,a0,-502 # 80209110 <simple_user_task_bin+0x278>
    8020030e:	00001097          	auipc	ra,0x1
    80200312:	986080e7          	jalr	-1658(ra) # 80200c94 <printf>
            printf("  ps            - 显示进程状态\n");
    80200316:	00009517          	auipc	a0,0x9
    8020031a:	e2250513          	addi	a0,a0,-478 # 80209138 <simple_user_task_bin+0x2a0>
    8020031e:	00001097          	auipc	ra,0x1
    80200322:	976080e7          	jalr	-1674(ra) # 80200c94 <printf>
    80200326:	aa55                	j	802004da <console+0x35c>
        } else if (strcmp(input_buffer, "ps") == 0) {
    80200328:	ed040793          	addi	a5,s0,-304
    8020032c:	00009597          	auipc	a1,0x9
    80200330:	e5458593          	addi	a1,a1,-428 # 80209180 <simple_user_task_bin+0x2e8>
    80200334:	853e                	mv	a0,a5
    80200336:	00006097          	auipc	ra,0x6
    8020033a:	9dc080e7          	jalr	-1572(ra) # 80205d12 <strcmp>
    8020033e:	87aa                	mv	a5,a0
    80200340:	e791                	bnez	a5,8020034c <console+0x1ce>
            print_proc_table();
    80200342:	00005097          	auipc	ra,0x5
    80200346:	75e080e7          	jalr	1886(ra) # 80205aa0 <print_proc_table>
    8020034a:	aa41                	j	802004da <console+0x35c>
            int found = 0;
    8020034c:	fe042023          	sw	zero,-32(s0)
            for (int i = 0; i < COMMAND_COUNT; i++) {
    80200350:	fc042e23          	sw	zero,-36(s0)
    80200354:	aa99                	j	802004aa <console+0x32c>
                if (strcmp(input_buffer, command_table[i].name) == 0) {
    80200356:	00018697          	auipc	a3,0x18
    8020035a:	caa68693          	addi	a3,a3,-854 # 80218000 <command_table>
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
    8020037a:	99c080e7          	jalr	-1636(ra) # 80205d12 <strcmp>
    8020037e:	87aa                	mv	a5,a0
    80200380:	12079063          	bnez	a5,802004a0 <console+0x322>
                    int pid = create_kernel_proc(command_table[i].func);
    80200384:	00018697          	auipc	a3,0x18
    80200388:	c7c68693          	addi	a3,a3,-900 # 80218000 <command_table>
    8020038c:	fdc42703          	lw	a4,-36(s0)
    80200390:	87ba                	mv	a5,a4
    80200392:	0786                	slli	a5,a5,0x1
    80200394:	97ba                	add	a5,a5,a4
    80200396:	078e                	slli	a5,a5,0x3
    80200398:	97b6                	add	a5,a5,a3
    8020039a:	679c                	ld	a5,8(a5)
    8020039c:	853e                	mv	a0,a5
    8020039e:	00005097          	auipc	ra,0x5
    802003a2:	d42080e7          	jalr	-702(ra) # 802050e0 <create_kernel_proc>
    802003a6:	87aa                	mv	a5,a0
    802003a8:	fcf42c23          	sw	a5,-40(s0)
                    if (pid < 0) {
    802003ac:	fd842783          	lw	a5,-40(s0)
    802003b0:	2781                	sext.w	a5,a5
    802003b2:	0207d863          	bgez	a5,802003e2 <console+0x264>
                        printf("创建%s进程失败\n", command_table[i].name);
    802003b6:	00018697          	auipc	a3,0x18
    802003ba:	c4a68693          	addi	a3,a3,-950 # 80218000 <command_table>
    802003be:	fdc42703          	lw	a4,-36(s0)
    802003c2:	87ba                	mv	a5,a4
    802003c4:	0786                	slli	a5,a5,0x1
    802003c6:	97ba                	add	a5,a5,a4
    802003c8:	078e                	slli	a5,a5,0x3
    802003ca:	97b6                	add	a5,a5,a3
    802003cc:	639c                	ld	a5,0(a5)
    802003ce:	85be                	mv	a1,a5
    802003d0:	00009517          	auipc	a0,0x9
    802003d4:	db850513          	addi	a0,a0,-584 # 80209188 <simple_user_task_bin+0x2f0>
    802003d8:	00001097          	auipc	ra,0x1
    802003dc:	8bc080e7          	jalr	-1860(ra) # 80200c94 <printf>
    802003e0:	a865                	j	80200498 <console+0x31a>
                        printf("创建%s进程成功，PID: %d\n", command_table[i].name, pid);
    802003e2:	00018697          	auipc	a3,0x18
    802003e6:	c1e68693          	addi	a3,a3,-994 # 80218000 <command_table>
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
    80200402:	00009517          	auipc	a0,0x9
    80200406:	d9e50513          	addi	a0,a0,-610 # 802091a0 <simple_user_task_bin+0x308>
    8020040a:	00001097          	auipc	ra,0x1
    8020040e:	88a080e7          	jalr	-1910(ra) # 80200c94 <printf>
                        int waited_pid = wait_proc(&status);
    80200412:	ecc40793          	addi	a5,s0,-308
    80200416:	853e                	mv	a0,a5
    80200418:	00005097          	auipc	ra,0x5
    8020041c:	4fa080e7          	jalr	1274(ra) # 80205912 <wait_proc>
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
    80200438:	00018697          	auipc	a3,0x18
    8020043c:	bc868693          	addi	a3,a3,-1080 # 80218000 <command_table>
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
    8020045c:	00009517          	auipc	a0,0x9
    80200460:	d6450513          	addi	a0,a0,-668 # 802091c0 <simple_user_task_bin+0x328>
    80200464:	00001097          	auipc	ra,0x1
    80200468:	830080e7          	jalr	-2000(ra) # 80200c94 <printf>
    8020046c:	a035                	j	80200498 <console+0x31a>
                            printf("等待%s进程时发生错误\n", command_table[i].name);
    8020046e:	00018697          	auipc	a3,0x18
    80200472:	b9268693          	addi	a3,a3,-1134 # 80218000 <command_table>
    80200476:	fdc42703          	lw	a4,-36(s0)
    8020047a:	87ba                	mv	a5,a4
    8020047c:	0786                	slli	a5,a5,0x1
    8020047e:	97ba                	add	a5,a5,a4
    80200480:	078e                	slli	a5,a5,0x3
    80200482:	97b6                	add	a5,a5,a3
    80200484:	639c                	ld	a5,0(a5)
    80200486:	85be                	mv	a1,a5
    80200488:	00009517          	auipc	a0,0x9
    8020048c:	d6850513          	addi	a0,a0,-664 # 802091f0 <simple_user_task_bin+0x358>
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
    802004b0:	4795                	li	a5,5
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
    802004ca:	00009517          	auipc	a0,0x9
    802004ce:	d4650513          	addi	a0,a0,-698 # 80209210 <simple_user_task_bin+0x378>
    802004d2:	00000097          	auipc	ra,0x0
    802004d6:	7c2080e7          	jalr	1986(ra) # 80200c94 <printf>
    while (!exit_requested) {
    802004da:	fec42783          	lw	a5,-20(s0)
    802004de:	2781                	sext.w	a5,a5
    802004e0:	d40785e3          	beqz	a5,8020022a <console+0xac>
    printf("控制台进程退出\n");
    802004e4:	00009517          	auipc	a0,0x9
    802004e8:	d4450513          	addi	a0,a0,-700 # 80209228 <simple_user_task_bin+0x390>
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
    8020051a:	bca080e7          	jalr	-1078(ra) # 802050e0 <create_kernel_proc>
    8020051e:	87aa                	mv	a5,a0
    80200520:	fef42623          	sw	a5,-20(s0)
	if (console_pid < 0){
    80200524:	fec42783          	lw	a5,-20(s0)
    80200528:	2781                	sext.w	a5,a5
    8020052a:	0007db63          	bgez	a5,80200540 <kernel_main+0x42>
		panic("KERNEL_MAIN: create console process failed!\n");
    8020052e:	00009517          	auipc	a0,0x9
    80200532:	d1250513          	addi	a0,a0,-750 # 80209240 <simple_user_task_bin+0x3a8>
    80200536:	00001097          	auipc	ra,0x1
    8020053a:	1aa080e7          	jalr	426(ra) # 802016e0 <panic>
    8020053e:	a821                	j	80200556 <kernel_main+0x58>
		printf("KERNEL_MAIN: console process created with PID %d\n", console_pid);
    80200540:	fec42783          	lw	a5,-20(s0)
    80200544:	85be                	mv	a1,a5
    80200546:	00009517          	auipc	a0,0x9
    8020054a:	d2a50513          	addi	a0,a0,-726 # 80209270 <simple_user_task_bin+0x3d8>
    8020054e:	00000097          	auipc	ra,0x0
    80200552:	746080e7          	jalr	1862(ra) # 80200c94 <printf>
	int pid = wait_proc(&status);
    80200556:	fe440793          	addi	a5,s0,-28
    8020055a:	853e                	mv	a0,a5
    8020055c:	00005097          	auipc	ra,0x5
    80200560:	3b6080e7          	jalr	950(ra) # 80205912 <wait_proc>
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
    80200588:	00009517          	auipc	a0,0x9
    8020058c:	d2050513          	addi	a0,a0,-736 # 802092a8 <simple_user_task_bin+0x410>
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
    802005ea:	0000a517          	auipc	a0,0xa
    802005ee:	aee50513          	addi	a0,a0,-1298 # 8020a0d8 <simple_user_task_bin+0x68>
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
    80200738:	00018797          	auipc	a5,0x18
    8020073c:	9a878793          	addi	a5,a5,-1624 # 802180e0 <uart_input_buf>
    80200740:	0847a783          	lw	a5,132(a5)
    80200744:	2785                	addiw	a5,a5,1
    80200746:	2781                	sext.w	a5,a5
    80200748:	2781                	sext.w	a5,a5
    8020074a:	07f7f793          	andi	a5,a5,127
    8020074e:	fef42023          	sw	a5,-32(s0)
                if (next != uart_input_buf.r) {
    80200752:	00018797          	auipc	a5,0x18
    80200756:	98e78793          	addi	a5,a5,-1650 # 802180e0 <uart_input_buf>
    8020075a:	0807a703          	lw	a4,128(a5)
    8020075e:	fe042783          	lw	a5,-32(s0)
    80200762:	04f70363          	beq	a4,a5,802007a8 <uart_intr+0xb2>
                    uart_input_buf.buf[uart_input_buf.w] = linebuf[i];
    80200766:	00018797          	auipc	a5,0x18
    8020076a:	97a78793          	addi	a5,a5,-1670 # 802180e0 <uart_input_buf>
    8020076e:	0847a603          	lw	a2,132(a5)
    80200772:	00018717          	auipc	a4,0x18
    80200776:	9fe70713          	addi	a4,a4,-1538 # 80218170 <linebuf.1>
    8020077a:	fec42783          	lw	a5,-20(s0)
    8020077e:	97ba                	add	a5,a5,a4
    80200780:	0007c703          	lbu	a4,0(a5)
    80200784:	00018697          	auipc	a3,0x18
    80200788:	95c68693          	addi	a3,a3,-1700 # 802180e0 <uart_input_buf>
    8020078c:	02061793          	slli	a5,a2,0x20
    80200790:	9381                	srli	a5,a5,0x20
    80200792:	97b6                	add	a5,a5,a3
    80200794:	00e78023          	sb	a4,0(a5)
                    uart_input_buf.w = next;
    80200798:	fe042703          	lw	a4,-32(s0)
    8020079c:	00018797          	auipc	a5,0x18
    802007a0:	94478793          	addi	a5,a5,-1724 # 802180e0 <uart_input_buf>
    802007a4:	08e7a223          	sw	a4,132(a5)
            for (int i = 0; i < line_len; i++) {
    802007a8:	fec42783          	lw	a5,-20(s0)
    802007ac:	2785                	addiw	a5,a5,1
    802007ae:	fef42623          	sw	a5,-20(s0)
    802007b2:	00018797          	auipc	a5,0x18
    802007b6:	a3e78793          	addi	a5,a5,-1474 # 802181f0 <line_len.0>
    802007ba:	4398                	lw	a4,0(a5)
    802007bc:	fec42783          	lw	a5,-20(s0)
    802007c0:	2781                	sext.w	a5,a5
    802007c2:	f6e7cbe3          	blt	a5,a4,80200738 <uart_intr+0x42>
                }
            }
            // 写入换行符
            int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    802007c6:	00018797          	auipc	a5,0x18
    802007ca:	91a78793          	addi	a5,a5,-1766 # 802180e0 <uart_input_buf>
    802007ce:	0847a783          	lw	a5,132(a5)
    802007d2:	2785                	addiw	a5,a5,1
    802007d4:	2781                	sext.w	a5,a5
    802007d6:	2781                	sext.w	a5,a5
    802007d8:	07f7f793          	andi	a5,a5,127
    802007dc:	fef42223          	sw	a5,-28(s0)
            if (next != uart_input_buf.r) {
    802007e0:	00018797          	auipc	a5,0x18
    802007e4:	90078793          	addi	a5,a5,-1792 # 802180e0 <uart_input_buf>
    802007e8:	0807a703          	lw	a4,128(a5)
    802007ec:	fe442783          	lw	a5,-28(s0)
    802007f0:	02f70a63          	beq	a4,a5,80200824 <uart_intr+0x12e>
                uart_input_buf.buf[uart_input_buf.w] = '\n';
    802007f4:	00018797          	auipc	a5,0x18
    802007f8:	8ec78793          	addi	a5,a5,-1812 # 802180e0 <uart_input_buf>
    802007fc:	0847a783          	lw	a5,132(a5)
    80200800:	00018717          	auipc	a4,0x18
    80200804:	8e070713          	addi	a4,a4,-1824 # 802180e0 <uart_input_buf>
    80200808:	1782                	slli	a5,a5,0x20
    8020080a:	9381                	srli	a5,a5,0x20
    8020080c:	97ba                	add	a5,a5,a4
    8020080e:	4729                	li	a4,10
    80200810:	00e78023          	sb	a4,0(a5)
                uart_input_buf.w = next;
    80200814:	fe442703          	lw	a4,-28(s0)
    80200818:	00018797          	auipc	a5,0x18
    8020081c:	8c878793          	addi	a5,a5,-1848 # 802180e0 <uart_input_buf>
    80200820:	08e7a223          	sw	a4,132(a5)
            }
            line_len = 0;
    80200824:	00018797          	auipc	a5,0x18
    80200828:	9cc78793          	addi	a5,a5,-1588 # 802181f0 <line_len.0>
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
    80200850:	00018797          	auipc	a5,0x18
    80200854:	9a078793          	addi	a5,a5,-1632 # 802181f0 <line_len.0>
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
    8020087e:	00018797          	auipc	a5,0x18
    80200882:	97278793          	addi	a5,a5,-1678 # 802181f0 <line_len.0>
    80200886:	439c                	lw	a5,0(a5)
    80200888:	37fd                	addiw	a5,a5,-1
    8020088a:	0007871b          	sext.w	a4,a5
    8020088e:	00018797          	auipc	a5,0x18
    80200892:	96278793          	addi	a5,a5,-1694 # 802181f0 <line_len.0>
    80200896:	c398                	sw	a4,0(a5)
            if (line_len > 0) {
    80200898:	a889                	j	802008ea <uart_intr+0x1f4>
            }
        } else if (line_len < LINE_BUF_SIZE - 1) {
    8020089a:	00018797          	auipc	a5,0x18
    8020089e:	95678793          	addi	a5,a5,-1706 # 802181f0 <line_len.0>
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
    802008bc:	00018797          	auipc	a5,0x18
    802008c0:	93478793          	addi	a5,a5,-1740 # 802181f0 <line_len.0>
    802008c4:	439c                	lw	a5,0(a5)
    802008c6:	0017871b          	addiw	a4,a5,1
    802008ca:	0007069b          	sext.w	a3,a4
    802008ce:	00018717          	auipc	a4,0x18
    802008d2:	92270713          	addi	a4,a4,-1758 # 802181f0 <line_len.0>
    802008d6:	c314                	sw	a3,0(a4)
    802008d8:	00018717          	auipc	a4,0x18
    802008dc:	89870713          	addi	a4,a4,-1896 # 80218170 <linebuf.1>
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
    80200918:	00017797          	auipc	a5,0x17
    8020091c:	7c878793          	addi	a5,a5,1992 # 802180e0 <uart_input_buf>
    80200920:	0807a703          	lw	a4,128(a5)
    80200924:	00017797          	auipc	a5,0x17
    80200928:	7bc78793          	addi	a5,a5,1980 # 802180e0 <uart_input_buf>
    8020092c:	0847a783          	lw	a5,132(a5)
    80200930:	fef703e3          	beq	a4,a5,80200916 <uart_getc_blocking+0x8>
    }
    
    // 读取字符
    char c = uart_input_buf.buf[uart_input_buf.r];
    80200934:	00017797          	auipc	a5,0x17
    80200938:	7ac78793          	addi	a5,a5,1964 # 802180e0 <uart_input_buf>
    8020093c:	0807a783          	lw	a5,128(a5)
    80200940:	00017717          	auipc	a4,0x17
    80200944:	7a070713          	addi	a4,a4,1952 # 802180e0 <uart_input_buf>
    80200948:	1782                	slli	a5,a5,0x20
    8020094a:	9381                	srli	a5,a5,0x20
    8020094c:	97ba                	add	a5,a5,a4
    8020094e:	0007c783          	lbu	a5,0(a5)
    80200952:	fef407a3          	sb	a5,-17(s0)
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    80200956:	00017797          	auipc	a5,0x17
    8020095a:	78a78793          	addi	a5,a5,1930 # 802180e0 <uart_input_buf>
    8020095e:	0807a783          	lw	a5,128(a5)
    80200962:	2785                	addiw	a5,a5,1
    80200964:	2781                	sext.w	a5,a5
    80200966:	07f7f793          	andi	a5,a5,127
    8020096a:	0007871b          	sext.w	a4,a5
    8020096e:	00017797          	auipc	a5,0x17
    80200972:	77278793          	addi	a5,a5,1906 # 802180e0 <uart_input_buf>
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
    80200a28:	00018797          	auipc	a5,0x18
    80200a2c:	85078793          	addi	a5,a5,-1968 # 80218278 <printf_buf_pos>
    80200a30:	439c                	lw	a5,0(a5)
    80200a32:	02f05c63          	blez	a5,80200a6a <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200a36:	00018797          	auipc	a5,0x18
    80200a3a:	84278793          	addi	a5,a5,-1982 # 80218278 <printf_buf_pos>
    80200a3e:	439c                	lw	a5,0(a5)
    80200a40:	00017717          	auipc	a4,0x17
    80200a44:	7b870713          	addi	a4,a4,1976 # 802181f8 <printf_buffer>
    80200a48:	97ba                	add	a5,a5,a4
    80200a4a:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80200a4e:	00017517          	auipc	a0,0x17
    80200a52:	7aa50513          	addi	a0,a0,1962 # 802181f8 <printf_buffer>
    80200a56:	00000097          	auipc	ra,0x0
    80200a5a:	be8080e7          	jalr	-1048(ra) # 8020063e <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200a5e:	00018797          	auipc	a5,0x18
    80200a62:	81a78793          	addi	a5,a5,-2022 # 80218278 <printf_buf_pos>
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
    80200a82:	00017797          	auipc	a5,0x17
    80200a86:	7f678793          	addi	a5,a5,2038 # 80218278 <printf_buf_pos>
    80200a8a:	439c                	lw	a5,0(a5)
    80200a8c:	873e                	mv	a4,a5
    80200a8e:	07e00793          	li	a5,126
    80200a92:	02e7ca63          	blt	a5,a4,80200ac6 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200a96:	00017797          	auipc	a5,0x17
    80200a9a:	7e278793          	addi	a5,a5,2018 # 80218278 <printf_buf_pos>
    80200a9e:	439c                	lw	a5,0(a5)
    80200aa0:	0017871b          	addiw	a4,a5,1
    80200aa4:	0007069b          	sext.w	a3,a4
    80200aa8:	00017717          	auipc	a4,0x17
    80200aac:	7d070713          	addi	a4,a4,2000 # 80218278 <printf_buf_pos>
    80200ab0:	c314                	sw	a3,0(a4)
    80200ab2:	00017717          	auipc	a4,0x17
    80200ab6:	74670713          	addi	a4,a4,1862 # 802181f8 <printf_buffer>
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
    80200ace:	00017797          	auipc	a5,0x17
    80200ad2:	7aa78793          	addi	a5,a5,1962 # 80218278 <printf_buf_pos>
    80200ad6:	439c                	lw	a5,0(a5)
    80200ad8:	0017871b          	addiw	a4,a5,1
    80200adc:	0007069b          	sext.w	a3,a4
    80200ae0:	00017717          	auipc	a4,0x17
    80200ae4:	79870713          	addi	a4,a4,1944 # 80218278 <printf_buf_pos>
    80200ae8:	c314                	sw	a3,0(a4)
    80200aea:	00017717          	auipc	a4,0x17
    80200aee:	70e70713          	addi	a4,a4,1806 # 802181f8 <printf_buffer>
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
    80200bce:	00017697          	auipc	a3,0x17
    80200bd2:	4c268693          	addi	a3,a3,1218 # 80218090 <digits.0>
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
    80200e4e:	0000a797          	auipc	a5,0xa
    80200e52:	0c678793          	addi	a5,a5,198 # 8020af14 <simple_user_task_bin+0x8c>
    80200e56:	97ba                	add	a5,a5,a4
    80200e58:	439c                	lw	a5,0(a5)
    80200e5a:	0007871b          	sext.w	a4,a5
    80200e5e:	0000a797          	auipc	a5,0xa
    80200e62:	0b678793          	addi	a5,a5,182 # 8020af14 <simple_user_task_bin+0x8c>
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
    80200fa2:	0000a797          	auipc	a5,0xa
    80200fa6:	f4e78793          	addi	a5,a5,-178 # 8020aef0 <simple_user_task_bin+0x68>
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
    80200fce:	0000a517          	auipc	a0,0xa
    80200fd2:	f2a50513          	addi	a0,a0,-214 # 8020aef8 <simple_user_task_bin+0x70>
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
    80201006:	0000a717          	auipc	a4,0xa
    8020100a:	efa70713          	addi	a4,a4,-262 # 8020af00 <simple_user_task_bin+0x78>
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
    802011b4:	0000a517          	auipc	a0,0xa
    802011b8:	dbc50513          	addi	a0,a0,-580 # 8020af70 <simple_user_task_bin+0xe8>
    802011bc:	fffff097          	auipc	ra,0xfffff
    802011c0:	482080e7          	jalr	1154(ra) # 8020063e <uart_puts>
	uart_puts(CURSOR_HOME);
    802011c4:	0000a517          	auipc	a0,0xa
    802011c8:	db450513          	addi	a0,a0,-588 # 8020af78 <simple_user_task_bin+0xf0>
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
    80201498:	0000a517          	auipc	a0,0xa
    8020149c:	ae850513          	addi	a0,a0,-1304 # 8020af80 <simple_user_task_bin+0xf8>
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
    802016f8:	0000a517          	auipc	a0,0xa
    802016fc:	89050513          	addi	a0,a0,-1904 # 8020af88 <simple_user_task_bin+0x100>
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
    8020173a:	0000a517          	auipc	a0,0xa
    8020173e:	85e50513          	addi	a0,a0,-1954 # 8020af98 <simple_user_task_bin+0x110>
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
    80201792:	0000a517          	auipc	a0,0xa
    80201796:	81650513          	addi	a0,a0,-2026 # 8020afa8 <simple_user_task_bin+0x120>
    8020179a:	fffff097          	auipc	ra,0xfffff
    8020179e:	4fa080e7          	jalr	1274(ra) # 80200c94 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    802017a2:	0000a517          	auipc	a0,0xa
    802017a6:	82650513          	addi	a0,a0,-2010 # 8020afc8 <simple_user_task_bin+0x140>
    802017aa:	fffff097          	auipc	ra,0xfffff
    802017ae:	4ea080e7          	jalr	1258(ra) # 80200c94 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    802017b2:	0ff00593          	li	a1,255
    802017b6:	0000a517          	auipc	a0,0xa
    802017ba:	82a50513          	addi	a0,a0,-2006 # 8020afe0 <simple_user_task_bin+0x158>
    802017be:	fffff097          	auipc	ra,0xfffff
    802017c2:	4d6080e7          	jalr	1238(ra) # 80200c94 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    802017c6:	6585                	lui	a1,0x1
    802017c8:	0000a517          	auipc	a0,0xa
    802017cc:	83850513          	addi	a0,a0,-1992 # 8020b000 <simple_user_task_bin+0x178>
    802017d0:	fffff097          	auipc	ra,0xfffff
    802017d4:	4c4080e7          	jalr	1220(ra) # 80200c94 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    802017d8:	1234b7b7          	lui	a5,0x1234b
    802017dc:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    802017e0:	0000a517          	auipc	a0,0xa
    802017e4:	84050513          	addi	a0,a0,-1984 # 8020b020 <simple_user_task_bin+0x198>
    802017e8:	fffff097          	auipc	ra,0xfffff
    802017ec:	4ac080e7          	jalr	1196(ra) # 80200c94 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    802017f0:	0000a517          	auipc	a0,0xa
    802017f4:	84850513          	addi	a0,a0,-1976 # 8020b038 <simple_user_task_bin+0x1b0>
    802017f8:	fffff097          	auipc	ra,0xfffff
    802017fc:	49c080e7          	jalr	1180(ra) # 80200c94 <printf>
    printf("  正数: %d\n", 42);
    80201800:	02a00593          	li	a1,42
    80201804:	0000a517          	auipc	a0,0xa
    80201808:	84c50513          	addi	a0,a0,-1972 # 8020b050 <simple_user_task_bin+0x1c8>
    8020180c:	fffff097          	auipc	ra,0xfffff
    80201810:	488080e7          	jalr	1160(ra) # 80200c94 <printf>
    printf("  负数: %d\n", -42);
    80201814:	fd600593          	li	a1,-42
    80201818:	0000a517          	auipc	a0,0xa
    8020181c:	84850513          	addi	a0,a0,-1976 # 8020b060 <simple_user_task_bin+0x1d8>
    80201820:	fffff097          	auipc	ra,0xfffff
    80201824:	474080e7          	jalr	1140(ra) # 80200c94 <printf>
    printf("  零: %d\n", 0);
    80201828:	4581                	li	a1,0
    8020182a:	0000a517          	auipc	a0,0xa
    8020182e:	84650513          	addi	a0,a0,-1978 # 8020b070 <simple_user_task_bin+0x1e8>
    80201832:	fffff097          	auipc	ra,0xfffff
    80201836:	462080e7          	jalr	1122(ra) # 80200c94 <printf>
    printf("  大数: %d\n", 123456789);
    8020183a:	075bd7b7          	lui	a5,0x75bd
    8020183e:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    80201842:	0000a517          	auipc	a0,0xa
    80201846:	83e50513          	addi	a0,a0,-1986 # 8020b080 <simple_user_task_bin+0x1f8>
    8020184a:	fffff097          	auipc	ra,0xfffff
    8020184e:	44a080e7          	jalr	1098(ra) # 80200c94 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    80201852:	0000a517          	auipc	a0,0xa
    80201856:	83e50513          	addi	a0,a0,-1986 # 8020b090 <simple_user_task_bin+0x208>
    8020185a:	fffff097          	auipc	ra,0xfffff
    8020185e:	43a080e7          	jalr	1082(ra) # 80200c94 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    80201862:	55fd                	li	a1,-1
    80201864:	0000a517          	auipc	a0,0xa
    80201868:	84450513          	addi	a0,a0,-1980 # 8020b0a8 <simple_user_task_bin+0x220>
    8020186c:	fffff097          	auipc	ra,0xfffff
    80201870:	428080e7          	jalr	1064(ra) # 80200c94 <printf>
    printf("  零：%u\n", 0U);
    80201874:	4581                	li	a1,0
    80201876:	0000a517          	auipc	a0,0xa
    8020187a:	84a50513          	addi	a0,a0,-1974 # 8020b0c0 <simple_user_task_bin+0x238>
    8020187e:	fffff097          	auipc	ra,0xfffff
    80201882:	416080e7          	jalr	1046(ra) # 80200c94 <printf>
	printf("  小无符号数：%u\n", 12345U);
    80201886:	678d                	lui	a5,0x3
    80201888:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    8020188c:	0000a517          	auipc	a0,0xa
    80201890:	84450513          	addi	a0,a0,-1980 # 8020b0d0 <simple_user_task_bin+0x248>
    80201894:	fffff097          	auipc	ra,0xfffff
    80201898:	400080e7          	jalr	1024(ra) # 80200c94 <printf>

	// 测试边界
	printf("边界测试:\n");
    8020189c:	0000a517          	auipc	a0,0xa
    802018a0:	84c50513          	addi	a0,a0,-1972 # 8020b0e8 <simple_user_task_bin+0x260>
    802018a4:	fffff097          	auipc	ra,0xfffff
    802018a8:	3f0080e7          	jalr	1008(ra) # 80200c94 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    802018ac:	800007b7          	lui	a5,0x80000
    802018b0:	fff7c593          	not	a1,a5
    802018b4:	0000a517          	auipc	a0,0xa
    802018b8:	84450513          	addi	a0,a0,-1980 # 8020b0f8 <simple_user_task_bin+0x270>
    802018bc:	fffff097          	auipc	ra,0xfffff
    802018c0:	3d8080e7          	jalr	984(ra) # 80200c94 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    802018c4:	800005b7          	lui	a1,0x80000
    802018c8:	0000a517          	auipc	a0,0xa
    802018cc:	84050513          	addi	a0,a0,-1984 # 8020b108 <simple_user_task_bin+0x280>
    802018d0:	fffff097          	auipc	ra,0xfffff
    802018d4:	3c4080e7          	jalr	964(ra) # 80200c94 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    802018d8:	55fd                	li	a1,-1
    802018da:	0000a517          	auipc	a0,0xa
    802018de:	83e50513          	addi	a0,a0,-1986 # 8020b118 <simple_user_task_bin+0x290>
    802018e2:	fffff097          	auipc	ra,0xfffff
    802018e6:	3b2080e7          	jalr	946(ra) # 80200c94 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    802018ea:	55fd                	li	a1,-1
    802018ec:	0000a517          	auipc	a0,0xa
    802018f0:	83c50513          	addi	a0,a0,-1988 # 8020b128 <simple_user_task_bin+0x2a0>
    802018f4:	fffff097          	auipc	ra,0xfffff
    802018f8:	3a0080e7          	jalr	928(ra) # 80200c94 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    802018fc:	0000a517          	auipc	a0,0xa
    80201900:	84450513          	addi	a0,a0,-1980 # 8020b140 <simple_user_task_bin+0x2b8>
    80201904:	fffff097          	auipc	ra,0xfffff
    80201908:	390080e7          	jalr	912(ra) # 80200c94 <printf>
    printf("  空字符串: '%s'\n", "");
    8020190c:	0000a597          	auipc	a1,0xa
    80201910:	84c58593          	addi	a1,a1,-1972 # 8020b158 <simple_user_task_bin+0x2d0>
    80201914:	0000a517          	auipc	a0,0xa
    80201918:	84c50513          	addi	a0,a0,-1972 # 8020b160 <simple_user_task_bin+0x2d8>
    8020191c:	fffff097          	auipc	ra,0xfffff
    80201920:	378080e7          	jalr	888(ra) # 80200c94 <printf>
    printf("  单字符: '%s'\n", "X");
    80201924:	0000a597          	auipc	a1,0xa
    80201928:	85458593          	addi	a1,a1,-1964 # 8020b178 <simple_user_task_bin+0x2f0>
    8020192c:	0000a517          	auipc	a0,0xa
    80201930:	85450513          	addi	a0,a0,-1964 # 8020b180 <simple_user_task_bin+0x2f8>
    80201934:	fffff097          	auipc	ra,0xfffff
    80201938:	360080e7          	jalr	864(ra) # 80200c94 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    8020193c:	0000a597          	auipc	a1,0xa
    80201940:	85c58593          	addi	a1,a1,-1956 # 8020b198 <simple_user_task_bin+0x310>
    80201944:	0000a517          	auipc	a0,0xa
    80201948:	87450513          	addi	a0,a0,-1932 # 8020b1b8 <simple_user_task_bin+0x330>
    8020194c:	fffff097          	auipc	ra,0xfffff
    80201950:	348080e7          	jalr	840(ra) # 80200c94 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    80201954:	0000a597          	auipc	a1,0xa
    80201958:	87c58593          	addi	a1,a1,-1924 # 8020b1d0 <simple_user_task_bin+0x348>
    8020195c:	0000a517          	auipc	a0,0xa
    80201960:	9c450513          	addi	a0,a0,-1596 # 8020b320 <simple_user_task_bin+0x498>
    80201964:	fffff097          	auipc	ra,0xfffff
    80201968:	330080e7          	jalr	816(ra) # 80200c94 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    8020196c:	0000a517          	auipc	a0,0xa
    80201970:	9d450513          	addi	a0,a0,-1580 # 8020b340 <simple_user_task_bin+0x4b8>
    80201974:	fffff097          	auipc	ra,0xfffff
    80201978:	320080e7          	jalr	800(ra) # 80200c94 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    8020197c:	0ff00693          	li	a3,255
    80201980:	f0100613          	li	a2,-255
    80201984:	0ff00593          	li	a1,255
    80201988:	0000a517          	auipc	a0,0xa
    8020198c:	9d050513          	addi	a0,a0,-1584 # 8020b358 <simple_user_task_bin+0x4d0>
    80201990:	fffff097          	auipc	ra,0xfffff
    80201994:	304080e7          	jalr	772(ra) # 80200c94 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80201998:	0000a517          	auipc	a0,0xa
    8020199c:	9e850513          	addi	a0,a0,-1560 # 8020b380 <simple_user_task_bin+0x4f8>
    802019a0:	fffff097          	auipc	ra,0xfffff
    802019a4:	2f4080e7          	jalr	756(ra) # 80200c94 <printf>
	printf("  100%% 完成!\n");
    802019a8:	0000a517          	auipc	a0,0xa
    802019ac:	9f050513          	addi	a0,a0,-1552 # 8020b398 <simple_user_task_bin+0x510>
    802019b0:	fffff097          	auipc	ra,0xfffff
    802019b4:	2e4080e7          	jalr	740(ra) # 80200c94 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    802019b8:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    802019bc:	0000a517          	auipc	a0,0xa
    802019c0:	9f450513          	addi	a0,a0,-1548 # 8020b3b0 <simple_user_task_bin+0x528>
    802019c4:	fffff097          	auipc	ra,0xfffff
    802019c8:	2d0080e7          	jalr	720(ra) # 80200c94 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    802019cc:	fe843583          	ld	a1,-24(s0)
    802019d0:	0000a517          	auipc	a0,0xa
    802019d4:	9f850513          	addi	a0,a0,-1544 # 8020b3c8 <simple_user_task_bin+0x540>
    802019d8:	fffff097          	auipc	ra,0xfffff
    802019dc:	2bc080e7          	jalr	700(ra) # 80200c94 <printf>
	
	// 测试指针格式
	int var = 42;
    802019e0:	02a00793          	li	a5,42
    802019e4:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    802019e8:	0000a517          	auipc	a0,0xa
    802019ec:	9f850513          	addi	a0,a0,-1544 # 8020b3e0 <simple_user_task_bin+0x558>
    802019f0:	fffff097          	auipc	ra,0xfffff
    802019f4:	2a4080e7          	jalr	676(ra) # 80200c94 <printf>
	printf("  Address of var: %p\n", &var);
    802019f8:	fe440793          	addi	a5,s0,-28
    802019fc:	85be                	mv	a1,a5
    802019fe:	0000a517          	auipc	a0,0xa
    80201a02:	9f250513          	addi	a0,a0,-1550 # 8020b3f0 <simple_user_task_bin+0x568>
    80201a06:	fffff097          	auipc	ra,0xfffff
    80201a0a:	28e080e7          	jalr	654(ra) # 80200c94 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80201a0e:	0000a517          	auipc	a0,0xa
    80201a12:	9fa50513          	addi	a0,a0,-1542 # 8020b408 <simple_user_task_bin+0x580>
    80201a16:	fffff097          	auipc	ra,0xfffff
    80201a1a:	27e080e7          	jalr	638(ra) # 80200c94 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201a1e:	55fd                	li	a1,-1
    80201a20:	0000a517          	auipc	a0,0xa
    80201a24:	a0850513          	addi	a0,a0,-1528 # 8020b428 <simple_user_task_bin+0x5a0>
    80201a28:	fffff097          	auipc	ra,0xfffff
    80201a2c:	26c080e7          	jalr	620(ra) # 80200c94 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201a30:	0000a517          	auipc	a0,0xa
    80201a34:	a1050513          	addi	a0,a0,-1520 # 8020b440 <simple_user_task_bin+0x5b8>
    80201a38:	fffff097          	auipc	ra,0xfffff
    80201a3c:	25c080e7          	jalr	604(ra) # 80200c94 <printf>
	printf("  Binary of 5: %b\n", 5);
    80201a40:	4595                	li	a1,5
    80201a42:	0000a517          	auipc	a0,0xa
    80201a46:	a1650513          	addi	a0,a0,-1514 # 8020b458 <simple_user_task_bin+0x5d0>
    80201a4a:	fffff097          	auipc	ra,0xfffff
    80201a4e:	24a080e7          	jalr	586(ra) # 80200c94 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201a52:	45a1                	li	a1,8
    80201a54:	0000a517          	auipc	a0,0xa
    80201a58:	a1c50513          	addi	a0,a0,-1508 # 8020b470 <simple_user_task_bin+0x5e8>
    80201a5c:	fffff097          	auipc	ra,0xfffff
    80201a60:	238080e7          	jalr	568(ra) # 80200c94 <printf>
	printf("=== printf测试结束 ===\n");
    80201a64:	0000a517          	auipc	a0,0xa
    80201a68:	a2450513          	addi	a0,a0,-1500 # 8020b488 <simple_user_task_bin+0x600>
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
    80201a8e:	0000a517          	auipc	a0,0xa
    80201a92:	a1a50513          	addi	a0,a0,-1510 # 8020b4a8 <simple_user_task_bin+0x620>
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
    80201ac2:	0000a517          	auipc	a0,0xa
    80201ac6:	a0650513          	addi	a0,a0,-1530 # 8020b4c8 <simple_user_task_bin+0x640>
    80201aca:	fffff097          	auipc	ra,0xfffff
    80201ace:	1ca080e7          	jalr	458(ra) # 80200c94 <printf>
		for (int j = 1; j <= 10; j++) {
    80201ad2:	fe842783          	lw	a5,-24(s0)
    80201ad6:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffde78f1>
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
    80201b2a:	0000a517          	auipc	a0,0xa
    80201b2e:	9a650513          	addi	a0,a0,-1626 # 8020b4d0 <simple_user_task_bin+0x648>
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
    80201b4e:	0000a517          	auipc	a0,0xa
    80201b52:	98a50513          	addi	a0,a0,-1654 # 8020b4d8 <simple_user_task_bin+0x650>
    80201b56:	fffff097          	auipc	ra,0xfffff
    80201b5a:	13e080e7          	jalr	318(ra) # 80200c94 <printf>
	restore_cursor();
    80201b5e:	00000097          	auipc	ra,0x0
    80201b62:	824080e7          	jalr	-2012(ra) # 80201382 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80201b66:	0000a517          	auipc	a0,0xa
    80201b6a:	97a50513          	addi	a0,a0,-1670 # 8020b4e0 <simple_user_task_bin+0x658>
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
    80201b90:	0000a517          	auipc	a0,0xa
    80201b94:	97850513          	addi	a0,a0,-1672 # 8020b508 <simple_user_task_bin+0x680>
    80201b98:	fffff097          	auipc	ra,0xfffff
    80201b9c:	0fc080e7          	jalr	252(ra) # 80200c94 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80201ba0:	0000a517          	auipc	a0,0xa
    80201ba4:	98850513          	addi	a0,a0,-1656 # 8020b528 <simple_user_task_bin+0x6a0>
    80201ba8:	fffff097          	auipc	ra,0xfffff
    80201bac:	0ec080e7          	jalr	236(ra) # 80200c94 <printf>
    color_red();    printf("红色文字 ");
    80201bb0:	00000097          	auipc	ra,0x0
    80201bb4:	9e4080e7          	jalr	-1564(ra) # 80201594 <color_red>
    80201bb8:	0000a517          	auipc	a0,0xa
    80201bbc:	98850513          	addi	a0,a0,-1656 # 8020b540 <simple_user_task_bin+0x6b8>
    80201bc0:	fffff097          	auipc	ra,0xfffff
    80201bc4:	0d4080e7          	jalr	212(ra) # 80200c94 <printf>
    color_green();  printf("绿色文字 ");
    80201bc8:	00000097          	auipc	ra,0x0
    80201bcc:	9e8080e7          	jalr	-1560(ra) # 802015b0 <color_green>
    80201bd0:	0000a517          	auipc	a0,0xa
    80201bd4:	98050513          	addi	a0,a0,-1664 # 8020b550 <simple_user_task_bin+0x6c8>
    80201bd8:	fffff097          	auipc	ra,0xfffff
    80201bdc:	0bc080e7          	jalr	188(ra) # 80200c94 <printf>
    color_yellow(); printf("黄色文字 ");
    80201be0:	00000097          	auipc	ra,0x0
    80201be4:	9ee080e7          	jalr	-1554(ra) # 802015ce <color_yellow>
    80201be8:	0000a517          	auipc	a0,0xa
    80201bec:	97850513          	addi	a0,a0,-1672 # 8020b560 <simple_user_task_bin+0x6d8>
    80201bf0:	fffff097          	auipc	ra,0xfffff
    80201bf4:	0a4080e7          	jalr	164(ra) # 80200c94 <printf>
    color_blue();   printf("蓝色文字 ");
    80201bf8:	00000097          	auipc	ra,0x0
    80201bfc:	9f4080e7          	jalr	-1548(ra) # 802015ec <color_blue>
    80201c00:	0000a517          	auipc	a0,0xa
    80201c04:	97050513          	addi	a0,a0,-1680 # 8020b570 <simple_user_task_bin+0x6e8>
    80201c08:	fffff097          	auipc	ra,0xfffff
    80201c0c:	08c080e7          	jalr	140(ra) # 80200c94 <printf>
    color_purple(); printf("紫色文字 ");
    80201c10:	00000097          	auipc	ra,0x0
    80201c14:	9fa080e7          	jalr	-1542(ra) # 8020160a <color_purple>
    80201c18:	0000a517          	auipc	a0,0xa
    80201c1c:	96850513          	addi	a0,a0,-1688 # 8020b580 <simple_user_task_bin+0x6f8>
    80201c20:	fffff097          	auipc	ra,0xfffff
    80201c24:	074080e7          	jalr	116(ra) # 80200c94 <printf>
    color_cyan();   printf("青色文字 ");
    80201c28:	00000097          	auipc	ra,0x0
    80201c2c:	a00080e7          	jalr	-1536(ra) # 80201628 <color_cyan>
    80201c30:	0000a517          	auipc	a0,0xa
    80201c34:	96050513          	addi	a0,a0,-1696 # 8020b590 <simple_user_task_bin+0x708>
    80201c38:	fffff097          	auipc	ra,0xfffff
    80201c3c:	05c080e7          	jalr	92(ra) # 80200c94 <printf>
    color_reverse();  printf("反色文字");
    80201c40:	00000097          	auipc	ra,0x0
    80201c44:	a06080e7          	jalr	-1530(ra) # 80201646 <color_reverse>
    80201c48:	0000a517          	auipc	a0,0xa
    80201c4c:	95850513          	addi	a0,a0,-1704 # 8020b5a0 <simple_user_task_bin+0x718>
    80201c50:	fffff097          	auipc	ra,0xfffff
    80201c54:	044080e7          	jalr	68(ra) # 80200c94 <printf>
    reset_color();
    80201c58:	00000097          	auipc	ra,0x0
    80201c5c:	838080e7          	jalr	-1992(ra) # 80201490 <reset_color>
    printf("\n\n");
    80201c60:	0000a517          	auipc	a0,0xa
    80201c64:	95050513          	addi	a0,a0,-1712 # 8020b5b0 <simple_user_task_bin+0x728>
    80201c68:	fffff097          	auipc	ra,0xfffff
    80201c6c:	02c080e7          	jalr	44(ra) # 80200c94 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80201c70:	0000a517          	auipc	a0,0xa
    80201c74:	94850513          	addi	a0,a0,-1720 # 8020b5b8 <simple_user_task_bin+0x730>
    80201c78:	fffff097          	auipc	ra,0xfffff
    80201c7c:	01c080e7          	jalr	28(ra) # 80200c94 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80201c80:	02900513          	li	a0,41
    80201c84:	00000097          	auipc	ra,0x0
    80201c88:	89e080e7          	jalr	-1890(ra) # 80201522 <set_bg_color>
    80201c8c:	0000a517          	auipc	a0,0xa
    80201c90:	94450513          	addi	a0,a0,-1724 # 8020b5d0 <simple_user_task_bin+0x748>
    80201c94:	fffff097          	auipc	ra,0xfffff
    80201c98:	000080e7          	jalr	ra # 80200c94 <printf>
    80201c9c:	fffff097          	auipc	ra,0xfffff
    80201ca0:	7f4080e7          	jalr	2036(ra) # 80201490 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80201ca4:	02a00513          	li	a0,42
    80201ca8:	00000097          	auipc	ra,0x0
    80201cac:	87a080e7          	jalr	-1926(ra) # 80201522 <set_bg_color>
    80201cb0:	0000a517          	auipc	a0,0xa
    80201cb4:	93050513          	addi	a0,a0,-1744 # 8020b5e0 <simple_user_task_bin+0x758>
    80201cb8:	fffff097          	auipc	ra,0xfffff
    80201cbc:	fdc080e7          	jalr	-36(ra) # 80200c94 <printf>
    80201cc0:	fffff097          	auipc	ra,0xfffff
    80201cc4:	7d0080e7          	jalr	2000(ra) # 80201490 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80201cc8:	02b00513          	li	a0,43
    80201ccc:	00000097          	auipc	ra,0x0
    80201cd0:	856080e7          	jalr	-1962(ra) # 80201522 <set_bg_color>
    80201cd4:	0000a517          	auipc	a0,0xa
    80201cd8:	91c50513          	addi	a0,a0,-1764 # 8020b5f0 <simple_user_task_bin+0x768>
    80201cdc:	fffff097          	auipc	ra,0xfffff
    80201ce0:	fb8080e7          	jalr	-72(ra) # 80200c94 <printf>
    80201ce4:	fffff097          	auipc	ra,0xfffff
    80201ce8:	7ac080e7          	jalr	1964(ra) # 80201490 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80201cec:	02c00513          	li	a0,44
    80201cf0:	00000097          	auipc	ra,0x0
    80201cf4:	832080e7          	jalr	-1998(ra) # 80201522 <set_bg_color>
    80201cf8:	0000a517          	auipc	a0,0xa
    80201cfc:	90850513          	addi	a0,a0,-1784 # 8020b600 <simple_user_task_bin+0x778>
    80201d00:	fffff097          	auipc	ra,0xfffff
    80201d04:	f94080e7          	jalr	-108(ra) # 80200c94 <printf>
    80201d08:	fffff097          	auipc	ra,0xfffff
    80201d0c:	788080e7          	jalr	1928(ra) # 80201490 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201d10:	02f00513          	li	a0,47
    80201d14:	00000097          	auipc	ra,0x0
    80201d18:	80e080e7          	jalr	-2034(ra) # 80201522 <set_bg_color>
    80201d1c:	0000a517          	auipc	a0,0xa
    80201d20:	8f450513          	addi	a0,a0,-1804 # 8020b610 <simple_user_task_bin+0x788>
    80201d24:	fffff097          	auipc	ra,0xfffff
    80201d28:	f70080e7          	jalr	-144(ra) # 80200c94 <printf>
    80201d2c:	fffff097          	auipc	ra,0xfffff
    80201d30:	764080e7          	jalr	1892(ra) # 80201490 <reset_color>
    printf("\n\n");
    80201d34:	0000a517          	auipc	a0,0xa
    80201d38:	87c50513          	addi	a0,a0,-1924 # 8020b5b0 <simple_user_task_bin+0x728>
    80201d3c:	fffff097          	auipc	ra,0xfffff
    80201d40:	f58080e7          	jalr	-168(ra) # 80200c94 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201d44:	0000a517          	auipc	a0,0xa
    80201d48:	8dc50513          	addi	a0,a0,-1828 # 8020b620 <simple_user_task_bin+0x798>
    80201d4c:	fffff097          	auipc	ra,0xfffff
    80201d50:	f48080e7          	jalr	-184(ra) # 80200c94 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201d54:	02c00593          	li	a1,44
    80201d58:	457d                	li	a0,31
    80201d5a:	00000097          	auipc	ra,0x0
    80201d5e:	90a080e7          	jalr	-1782(ra) # 80201664 <set_color>
    80201d62:	0000a517          	auipc	a0,0xa
    80201d66:	8d650513          	addi	a0,a0,-1834 # 8020b638 <simple_user_task_bin+0x7b0>
    80201d6a:	fffff097          	auipc	ra,0xfffff
    80201d6e:	f2a080e7          	jalr	-214(ra) # 80200c94 <printf>
    80201d72:	fffff097          	auipc	ra,0xfffff
    80201d76:	71e080e7          	jalr	1822(ra) # 80201490 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201d7a:	02d00593          	li	a1,45
    80201d7e:	02100513          	li	a0,33
    80201d82:	00000097          	auipc	ra,0x0
    80201d86:	8e2080e7          	jalr	-1822(ra) # 80201664 <set_color>
    80201d8a:	0000a517          	auipc	a0,0xa
    80201d8e:	8be50513          	addi	a0,a0,-1858 # 8020b648 <simple_user_task_bin+0x7c0>
    80201d92:	fffff097          	auipc	ra,0xfffff
    80201d96:	f02080e7          	jalr	-254(ra) # 80200c94 <printf>
    80201d9a:	fffff097          	auipc	ra,0xfffff
    80201d9e:	6f6080e7          	jalr	1782(ra) # 80201490 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201da2:	02f00593          	li	a1,47
    80201da6:	02000513          	li	a0,32
    80201daa:	00000097          	auipc	ra,0x0
    80201dae:	8ba080e7          	jalr	-1862(ra) # 80201664 <set_color>
    80201db2:	0000a517          	auipc	a0,0xa
    80201db6:	8a650513          	addi	a0,a0,-1882 # 8020b658 <simple_user_task_bin+0x7d0>
    80201dba:	fffff097          	auipc	ra,0xfffff
    80201dbe:	eda080e7          	jalr	-294(ra) # 80200c94 <printf>
    80201dc2:	fffff097          	auipc	ra,0xfffff
    80201dc6:	6ce080e7          	jalr	1742(ra) # 80201490 <reset_color>
    printf("\n\n");
    80201dca:	00009517          	auipc	a0,0x9
    80201dce:	7e650513          	addi	a0,a0,2022 # 8020b5b0 <simple_user_task_bin+0x728>
    80201dd2:	fffff097          	auipc	ra,0xfffff
    80201dd6:	ec2080e7          	jalr	-318(ra) # 80200c94 <printf>
	reset_color();
    80201dda:	fffff097          	auipc	ra,0xfffff
    80201dde:	6b6080e7          	jalr	1718(ra) # 80201490 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201de2:	0000a517          	auipc	a0,0xa
    80201de6:	88650513          	addi	a0,a0,-1914 # 8020b668 <simple_user_task_bin+0x7e0>
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
    80201e04:	0000a517          	auipc	a0,0xa
    80201e08:	89c50513          	addi	a0,a0,-1892 # 8020b6a0 <simple_user_task_bin+0x818>
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
    80201fa6:	1a200613          	li	a2,418
    80201faa:	0000b597          	auipc	a1,0xb
    80201fae:	2f658593          	addi	a1,a1,758 # 8020d2a0 <simple_user_task_bin+0x68>
    80201fb2:	0000b517          	auipc	a0,0xb
    80201fb6:	2fe50513          	addi	a0,a0,766 # 8020d2b0 <simple_user_task_bin+0x78>
    80201fba:	fffff097          	auipc	ra,0xfffff
    80201fbe:	cda080e7          	jalr	-806(ra) # 80200c94 <printf>
    80201fc2:	0000b517          	auipc	a0,0xb
    80201fc6:	31650513          	addi	a0,a0,790 # 8020d2d8 <simple_user_task_bin+0xa0>
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
    802020e6:	0000b517          	auipc	a0,0xb
    802020ea:	1fa50513          	addi	a0,a0,506 # 8020d2e0 <simple_user_task_bin+0xa8>
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
    8020212a:	0000b517          	auipc	a0,0xb
    8020212e:	1ce50513          	addi	a0,a0,462 # 8020d2f8 <simple_user_task_bin+0xc0>
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
    80202180:	0000b517          	auipc	a0,0xb
    80202184:	1a050513          	addi	a0,a0,416 # 8020d320 <simple_user_task_bin+0xe8>
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
    802021a8:	0000b517          	auipc	a0,0xb
    802021ac:	1c050513          	addi	a0,a0,448 # 8020d368 <simple_user_task_bin+0x130>
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
    80202222:	0000b517          	auipc	a0,0xb
    80202226:	0be50513          	addi	a0,a0,190 # 8020d2e0 <simple_user_task_bin+0xa8>
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
    80202308:	79c080e7          	jalr	1948(ra) # 80204aa0 <myproc>
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
    80202344:	0000b517          	auipc	a0,0xb
    80202348:	05c50513          	addi	a0,a0,92 # 8020d3a0 <simple_user_task_bin+0x168>
    8020234c:	fffff097          	auipc	ra,0xfffff
    80202350:	3c8080e7          	jalr	968(ra) # 80201714 <warning>
		exit_proc(-1);
    80202354:	557d                	li	a0,-1
    80202356:	00003097          	auipc	ra,0x3
    8020235a:	4f2080e7          	jalr	1266(ra) # 80205848 <exit_proc>
    if ((va % PGSIZE) != 0)
    8020235e:	fc043703          	ld	a4,-64(s0)
    80202362:	6785                	lui	a5,0x1
    80202364:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80202366:	8ff9                	and	a5,a5,a4
    80202368:	cb89                	beqz	a5,8020237a <map_page+0x90>
        panic("map_page: va not aligned");
    8020236a:	0000b517          	auipc	a0,0xb
    8020236e:	06650513          	addi	a0,a0,102 # 8020d3d0 <simple_user_task_bin+0x198>
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
    80202428:	0000b517          	auipc	a0,0xb
    8020242c:	fc850513          	addi	a0,a0,-56 # 8020d3f0 <simple_user_task_bin+0x1b8>
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
    802024b6:	0007b023          	sd	zero,0(a5) # ffffffff80000000 <_bss_end+0xfffffffeffde78f0>
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
    80202526:	0000b517          	auipc	a0,0xb
    8020252a:	efa50513          	addi	a0,a0,-262 # 8020d420 <simple_user_task_bin+0x1e8>
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
    80202546:	00006797          	auipc	a5,0x6
    8020254a:	aba78793          	addi	a5,a5,-1350 # 80208000 <etext>
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
    8020257a:	0000b517          	auipc	a0,0xb
    8020257e:	ebe50513          	addi	a0,a0,-322 # 8020d438 <simple_user_task_bin+0x200>
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
    802025bc:	0000b517          	auipc	a0,0xb
    802025c0:	e9c50513          	addi	a0,a0,-356 # 8020d458 <simple_user_task_bin+0x220>
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
    802025f0:	0000b517          	auipc	a0,0xb
    802025f4:	e8850513          	addi	a0,a0,-376 # 8020d478 <simple_user_task_bin+0x240>
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
    8020263c:	0000b517          	auipc	a0,0xb
    80202640:	e5c50513          	addi	a0,a0,-420 # 8020d498 <simple_user_task_bin+0x260>
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
    8020267e:	0000b517          	auipc	a0,0xb
    80202682:	e3a50513          	addi	a0,a0,-454 # 8020d4b8 <simple_user_task_bin+0x280>
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
    802026a0:	0000b517          	auipc	a0,0xb
    802026a4:	e3850513          	addi	a0,a0,-456 # 8020d4d8 <simple_user_task_bin+0x2a0>
    802026a8:	fffff097          	auipc	ra,0xfffff
    802026ac:	038080e7          	jalr	56(ra) # 802016e0 <panic>
	memcpy(tramp_phys, trampoline, PGSIZE);
    802026b0:	6605                	lui	a2,0x1
    802026b2:	00002597          	auipc	a1,0x2
    802026b6:	14e58593          	addi	a1,a1,334 # 80204800 <trampoline>
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
    802026d8:	0000b517          	auipc	a0,0xb
    802026dc:	e2850513          	addi	a0,a0,-472 # 8020d500 <simple_user_task_bin+0x2c8>
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
    80202712:	0000b517          	auipc	a0,0xb
    80202716:	e1650513          	addi	a0,a0,-490 # 8020d528 <simple_user_task_bin+0x2f0>
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
    8020273c:	0000b517          	auipc	a0,0xb
    80202740:	e0c50513          	addi	a0,a0,-500 # 8020d548 <simple_user_task_bin+0x310>
    80202744:	fffff097          	auipc	ra,0xfffff
    80202748:	f9c080e7          	jalr	-100(ra) # 802016e0 <panic>
	trampoline_phys_addr = (uint64)tramp_phys;
    8020274c:	fc043703          	ld	a4,-64(s0)
    80202750:	00016797          	auipc	a5,0x16
    80202754:	96878793          	addi	a5,a5,-1688 # 802180b8 <trampoline_phys_addr>
    80202758:	e398                	sd	a4,0(a5)
	trapframe_phys_addr = (uint64)trapframe_phys;
    8020275a:	fb843703          	ld	a4,-72(s0)
    8020275e:	00016797          	auipc	a5,0x16
    80202762:	96278793          	addi	a5,a5,-1694 # 802180c0 <trapframe_phys_addr>
    80202766:	e398                	sd	a4,0(a5)
	printf("trampoline_phy_addr = %lx\n",trampoline_phys_addr);
    80202768:	00016797          	auipc	a5,0x16
    8020276c:	95078793          	addi	a5,a5,-1712 # 802180b8 <trampoline_phys_addr>
    80202770:	639c                	ld	a5,0(a5)
    80202772:	85be                	mv	a1,a5
    80202774:	0000b517          	auipc	a0,0xb
    80202778:	df450513          	addi	a0,a0,-524 # 8020d568 <simple_user_task_bin+0x330>
    8020277c:	ffffe097          	auipc	ra,0xffffe
    80202780:	518080e7          	jalr	1304(ra) # 80200c94 <printf>
	printf("trapframe_phys_addr = %lx\n",trapframe_phys_addr);
    80202784:	00016797          	auipc	a5,0x16
    80202788:	93c78793          	addi	a5,a5,-1732 # 802180c0 <trapframe_phys_addr>
    8020278c:	639c                	ld	a5,0(a5)
    8020278e:	85be                	mv	a1,a5
    80202790:	0000b517          	auipc	a0,0xb
    80202794:	df850513          	addi	a0,a0,-520 # 8020d588 <simple_user_task_bin+0x350>
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
    802027ec:	00016797          	auipc	a5,0x16
    802027f0:	8c478793          	addi	a5,a5,-1852 # 802180b0 <kernel_pagetable>
    802027f4:	e398                	sd	a4,0(a5)
    sfence_vma();
    802027f6:	00000097          	auipc	ra,0x0
    802027fa:	fd2080e7          	jalr	-46(ra) # 802027c8 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    802027fe:	00016797          	auipc	a5,0x16
    80202802:	8b278793          	addi	a5,a5,-1870 # 802180b0 <kernel_pagetable>
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
    80202824:	00016797          	auipc	a5,0x16
    80202828:	88c78793          	addi	a5,a5,-1908 # 802180b0 <kernel_pagetable>
    8020282c:	639c                	ld	a5,0(a5)
    8020282e:	00c7d713          	srli	a4,a5,0xc
    80202832:	57fd                	li	a5,-1
    80202834:	17fe                	slli	a5,a5,0x3f
    80202836:	8fd9                	or	a5,a5,a4
    80202838:	85be                	mv	a1,a5
    8020283a:	0000b517          	auipc	a0,0xb
    8020283e:	d6e50513          	addi	a0,a0,-658 # 8020d5a8 <simple_user_task_bin+0x370>
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
    8020285a:	00016797          	auipc	a5,0x16
    8020285e:	85678793          	addi	a5,a5,-1962 # 802180b0 <kernel_pagetable>
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
    802028e4:	0000b517          	auipc	a0,0xb
    802028e8:	cf450513          	addi	a0,a0,-780 # 8020d5d8 <simple_user_task_bin+0x3a0>
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
    80202928:	0000b517          	auipc	a0,0xb
    8020292c:	cb850513          	addi	a0,a0,-840 # 8020d5e0 <simple_user_task_bin+0x3a8>
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
    8020299e:	0000b517          	auipc	a0,0xb
    802029a2:	c7250513          	addi	a0,a0,-910 # 8020d610 <simple_user_task_bin+0x3d8>
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
    802029c6:	0000b517          	auipc	a0,0xb
    802029ca:	c7a50513          	addi	a0,a0,-902 # 8020d640 <simple_user_task_bin+0x408>
    802029ce:	ffffe097          	auipc	ra,0xffffe
    802029d2:	2c6080e7          	jalr	710(ra) # 80200c94 <printf>
        return 0;
    802029d6:	4781                	li	a5,0
    802029d8:	aae9                	j	80202bb2 <handle_page_fault+0x230>
    struct proc *p = myproc();
    802029da:	00002097          	auipc	ra,0x2
    802029de:	0c6080e7          	jalr	198(ra) # 80204aa0 <myproc>
    802029e2:	fca43823          	sd	a0,-48(s0)
    pagetable_t pt = kernel_pagetable;
    802029e6:	00015797          	auipc	a5,0x15
    802029ea:	6ca78793          	addi	a5,a5,1738 # 802180b0 <kernel_pagetable>
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
    80202aac:	0000b517          	auipc	a0,0xb
    80202ab0:	bbc50513          	addi	a0,a0,-1092 # 8020d668 <simple_user_task_bin+0x430>
    80202ab4:	ffffe097          	auipc	ra,0xffffe
    80202ab8:	1e0080e7          	jalr	480(ra) # 80200c94 <printf>
            return 1;
    80202abc:	4785                	li	a5,1
    80202abe:	a8d5                	j	80202bb2 <handle_page_fault+0x230>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80202ac0:	0000b517          	auipc	a0,0xb
    80202ac4:	bd050513          	addi	a0,a0,-1072 # 8020d690 <simple_user_task_bin+0x458>
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
    80202ae6:	0000b517          	auipc	a0,0xb
    80202aea:	bda50513          	addi	a0,a0,-1062 # 8020d6c0 <simple_user_task_bin+0x488>
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
    80202b7a:	0000b517          	auipc	a0,0xb
    80202b7e:	b7650513          	addi	a0,a0,-1162 # 8020d6f0 <simple_user_task_bin+0x4b8>
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
    80202ba0:	0000b517          	auipc	a0,0xb
    80202ba4:	b7850513          	addi	a0,a0,-1160 # 8020d718 <simple_user_task_bin+0x4e0>
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
    80202bda:	0000b517          	auipc	a0,0xb
    80202bde:	b7e50513          	addi	a0,a0,-1154 # 8020d758 <simple_user_task_bin+0x520>
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
    80202c0e:	0000b517          	auipc	a0,0xb
    80202c12:	b6a50513          	addi	a0,a0,-1174 # 8020d778 <simple_user_task_bin+0x540>
    80202c16:	ffffe097          	auipc	ra,0xffffe
    80202c1a:	07e080e7          	jalr	126(ra) # 80200c94 <printf>
    uint64 va[] = {
    80202c1e:	0000b797          	auipc	a5,0xb
    80202c22:	d1a78793          	addi	a5,a5,-742 # 8020d938 <simple_user_task_bin+0x700>
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
    80202cea:	0000b517          	auipc	a0,0xb
    80202cee:	aae50513          	addi	a0,a0,-1362 # 8020d798 <simple_user_task_bin+0x560>
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
    80202d54:	0000b797          	auipc	a5,0xb
    80202d58:	a6c78793          	addi	a5,a5,-1428 # 8020d7c0 <simple_user_task_bin+0x588>
    80202d5c:	a029                	j	80202d66 <test_pagetable+0x1aa>
    80202d5e:	0000b797          	auipc	a5,0xb
    80202d62:	a6a78793          	addi	a5,a5,-1430 # 8020d7c8 <simple_user_task_bin+0x590>
    80202d66:	86be                	mv	a3,a5
    80202d68:	863a                	mv	a2,a4
    80202d6a:	0000b517          	auipc	a0,0xb
    80202d6e:	a6650513          	addi	a0,a0,-1434 # 8020d7d0 <simple_user_task_bin+0x598>
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
    80202db0:	0000b517          	auipc	a0,0xb
    80202db4:	a5050513          	addi	a0,a0,-1456 # 8020d800 <simple_user_task_bin+0x5c8>
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
    80202e1e:	0000b517          	auipc	a0,0xb
    80202e22:	a0a50513          	addi	a0,a0,-1526 # 8020d828 <simple_user_task_bin+0x5f0>
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
    80202e42:	0000b517          	auipc	a0,0xb
    80202e46:	a2650513          	addi	a0,a0,-1498 # 8020d868 <simple_user_task_bin+0x630>
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
    80202e6e:	0000b517          	auipc	a0,0xb
    80202e72:	a2a50513          	addi	a0,a0,-1494 # 8020d898 <simple_user_task_bin+0x660>
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
    80202ec2:	0000b517          	auipc	a0,0xb
    80202ec6:	a0650513          	addi	a0,a0,-1530 # 8020d8c8 <simple_user_task_bin+0x690>
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
    80202efa:	0000b517          	auipc	a0,0xb
    80202efe:	9f650513          	addi	a0,a0,-1546 # 8020d8f0 <simple_user_task_bin+0x6b8>
    80202f02:	ffffe097          	auipc	ra,0xffffe
    80202f06:	d92080e7          	jalr	-622(ra) # 80200c94 <printf>
    printf("[PT TEST] 所有页表测试通过\n");
    80202f0a:	0000b517          	auipc	a0,0xb
    80202f0e:	a0650513          	addi	a0,a0,-1530 # 8020d910 <simple_user_task_bin+0x6d8>
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
    80202f48:	00015797          	auipc	a5,0x15
    80202f4c:	16878793          	addi	a5,a5,360 # 802180b0 <kernel_pagetable>
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
    80202f80:	0000b517          	auipc	a0,0xb
    80202f84:	9e050513          	addi	a0,a0,-1568 # 8020d960 <simple_user_task_bin+0x728>
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
    80202fac:	0000b517          	auipc	a0,0xb
    80202fb0:	9dc50513          	addi	a0,a0,-1572 # 8020d988 <simple_user_task_bin+0x750>
    80202fb4:	ffffe097          	auipc	ra,0xffffe
    80202fb8:	ce0080e7          	jalr	-800(ra) # 80200c94 <printf>
    if(pte && (*pte & PTE_V)) {
    80202fbc:	a821                	j	80202fd4 <check_mapping+0x98>
        printf("Address 0x%lx is NOT mapped\n", va);
    80202fbe:	fd843583          	ld	a1,-40(s0)
    80202fc2:	0000b517          	auipc	a0,0xb
    80202fc6:	9e650513          	addi	a0,a0,-1562 # 8020d9a8 <simple_user_task_bin+0x770>
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
    80203022:	0000b517          	auipc	a0,0xb
    80203026:	93e50513          	addi	a0,a0,-1730 # 8020d960 <simple_user_task_bin+0x728>
    8020302a:	ffffe097          	auipc	ra,0xffffe
    8020302e:	c6a080e7          	jalr	-918(ra) # 80200c94 <printf>
        return 1;
    80203032:	4785                	li	a5,1
    80203034:	a821                	j	8020304c <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    80203036:	fd843583          	ld	a1,-40(s0)
    8020303a:	0000b517          	auipc	a0,0xb
    8020303e:	96e50513          	addi	a0,a0,-1682 # 8020d9a8 <simple_user_task_bin+0x770>
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
    80203170:	1a200613          	li	a2,418
    80203174:	0000b597          	auipc	a1,0xb
    80203178:	64458593          	addi	a1,a1,1604 # 8020e7b8 <simple_user_task_bin+0x68>
    8020317c:	0000b517          	auipc	a0,0xb
    80203180:	64c50513          	addi	a0,a0,1612 # 8020e7c8 <simple_user_task_bin+0x78>
    80203184:	ffffe097          	auipc	ra,0xffffe
    80203188:	b10080e7          	jalr	-1264(ra) # 80200c94 <printf>
    8020318c:	0000b517          	auipc	a0,0xb
    80203190:	66450513          	addi	a0,a0,1636 # 8020e7f0 <simple_user_task_bin+0xa0>
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
    8020320c:	00015517          	auipc	a0,0x15
    80203210:	50450513          	addi	a0,a0,1284 # 80218710 <_bss_end>
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
    8020322e:	00015797          	auipc	a5,0x15
    80203232:	05278793          	addi	a5,a5,82 # 80218280 <freelist>
    80203236:	639c                	ld	a5,0(a5)
    80203238:	fef43423          	sd	a5,-24(s0)
  if(r)
    8020323c:	fe843783          	ld	a5,-24(s0)
    80203240:	cb89                	beqz	a5,80203252 <alloc_page+0x2c>
    freelist = r->next;
    80203242:	fe843783          	ld	a5,-24(s0)
    80203246:	6398                	ld	a4,0(a5)
    80203248:	00015797          	auipc	a5,0x15
    8020324c:	03878793          	addi	a5,a5,56 # 80218280 <freelist>
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
    80203274:	0000b517          	auipc	a0,0xb
    80203278:	58450513          	addi	a0,a0,1412 # 8020e7f8 <simple_user_task_bin+0xa8>
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
    802032b6:	00015797          	auipc	a5,0x15
    802032ba:	45a78793          	addi	a5,a5,1114 # 80218710 <_bss_end>
    802032be:	00f76863          	bltu	a4,a5,802032ce <free_page+0x3c>
    802032c2:	fd843703          	ld	a4,-40(s0)
    802032c6:	47c5                	li	a5,17
    802032c8:	07ee                	slli	a5,a5,0x1b
    802032ca:	00f76a63          	bltu	a4,a5,802032de <free_page+0x4c>
    panic("free_page: invalid page address");
    802032ce:	0000b517          	auipc	a0,0xb
    802032d2:	54a50513          	addi	a0,a0,1354 # 8020e818 <simple_user_task_bin+0xc8>
    802032d6:	ffffe097          	auipc	ra,0xffffe
    802032da:	40a080e7          	jalr	1034(ra) # 802016e0 <panic>
  r->next = freelist;
    802032de:	00015797          	auipc	a5,0x15
    802032e2:	fa278793          	addi	a5,a5,-94 # 80218280 <freelist>
    802032e6:	6398                	ld	a4,0(a5)
    802032e8:	fe843783          	ld	a5,-24(s0)
    802032ec:	e398                	sd	a4,0(a5)
  freelist = r;
    802032ee:	00015797          	auipc	a5,0x15
    802032f2:	f9278793          	addi	a5,a5,-110 # 80218280 <freelist>
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
    8020330e:	0000b517          	auipc	a0,0xb
    80203312:	52a50513          	addi	a0,a0,1322 # 8020e838 <simple_user_task_bin+0xe8>
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
    802033c2:	0000b517          	auipc	a0,0xb
    802033c6:	49650513          	addi	a0,a0,1174 # 8020e858 <simple_user_task_bin+0x108>
    802033ca:	ffffe097          	auipc	ra,0xffffe
    802033ce:	8ca080e7          	jalr	-1846(ra) # 80200c94 <printf>
    printf("[PM TEST] 数据写入测试...\n");
    802033d2:	0000b517          	auipc	a0,0xb
    802033d6:	4a650513          	addi	a0,a0,1190 # 8020e878 <simple_user_task_bin+0x128>
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
    80203418:	0000b517          	auipc	a0,0xb
    8020341c:	48850513          	addi	a0,a0,1160 # 8020e8a0 <simple_user_task_bin+0x150>
    80203420:	ffffe097          	auipc	ra,0xffffe
    80203424:	874080e7          	jalr	-1932(ra) # 80200c94 <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    80203428:	0000b517          	auipc	a0,0xb
    8020342c:	4a050513          	addi	a0,a0,1184 # 8020e8c8 <simple_user_task_bin+0x178>
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
    80203468:	0000b517          	auipc	a0,0xb
    8020346c:	49050513          	addi	a0,a0,1168 # 8020e8f8 <simple_user_task_bin+0x1a8>
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
    80203490:	0000b517          	auipc	a0,0xb
    80203494:	49850513          	addi	a0,a0,1176 # 8020e928 <simple_user_task_bin+0x1d8>
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
    802034e6:	00015797          	auipc	a5,0x15
    802034ea:	bf278793          	addi	a5,a5,-1038 # 802180d8 <interrupt_test_flag>
    802034ee:	639c                	ld	a5,0(a5)
    802034f0:	cb99                	beqz	a5,80203506 <timeintr+0x26>
        (*interrupt_test_flag)++;
    802034f2:	00015797          	auipc	a5,0x15
    802034f6:	be678793          	addi	a5,a5,-1050 # 802180d8 <interrupt_test_flag>
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
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled load page fault");
}
    8020350e:	1101                	addi	sp,sp,-32
    80203510:	ec22                	sd	s0,24(sp)
    80203512:	1000                	addi	s0,sp,32

// 处理存储页故障
    80203514:	104027f3          	csrr	a5,sie
    80203518:	fef43423          	sd	a5,-24(s0)
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    8020351c:	fe843783          	ld	a5,-24(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80203520:	853e                	mv	a0,a5
    80203522:	6462                	ld	s0,24(sp)
    80203524:	6105                	addi	sp,sp,32
    80203526:	8082                	ret

0000000080203528 <w_sie>:
    
    // 尝试处理页面故障
    80203528:	1101                	addi	sp,sp,-32
    8020352a:	ec22                	sd	s0,24(sp)
    8020352c:	1000                	addi	s0,sp,32
    8020352e:	fea43423          	sd	a0,-24(s0)
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    80203532:	fe843783          	ld	a5,-24(s0)
    80203536:	10479073          	csrw	sie,a5
        return; // 成功处理页面故障，可以继续执行
    8020353a:	0001                	nop
    8020353c:	6462                	ld	s0,24(sp)
    8020353e:	6105                	addi	sp,sp,32
    80203540:	8082                	ret

0000000080203542 <r_sstatus>:
    }
    
    80203542:	1101                	addi	sp,sp,-32
    80203544:	ec22                	sd	s0,24(sp)
    80203546:	1000                	addi	s0,sp,32
    // 无法处理的页面故障
    panic("Unhandled store page fault");
    80203548:	100027f3          	csrr	a5,sstatus
    8020354c:	fef43423          	sd	a5,-24(s0)
}
    80203550:	fe843783          	ld	a5,-24(s0)

    80203554:	853e                	mv	a0,a5
    80203556:	6462                	ld	s0,24(sp)
    80203558:	6105                	addi	sp,sp,32
    8020355a:	8082                	ret

000000008020355c <w_sstatus>:
void usertrap(void) {
    8020355c:	1101                	addi	sp,sp,-32
    8020355e:	ec22                	sd	s0,24(sp)
    80203560:	1000                	addi	s0,sp,32
    80203562:	fea43423          	sd	a0,-24(s0)
    struct proc *p = myproc();
    80203566:	fe843783          	ld	a5,-24(s0)
    8020356a:	10079073          	csrw	sstatus,a5
    struct trapframe *tf = p->trapframe;
    8020356e:	0001                	nop
    80203570:	6462                	ld	s0,24(sp)
    80203572:	6105                	addi	sp,sp,32
    80203574:	8082                	ret

0000000080203576 <w_sscratch>:

    80203576:	1101                	addi	sp,sp,-32
    80203578:	ec22                	sd	s0,24(sp)
    8020357a:	1000                	addi	s0,sp,32
    8020357c:	fea43423          	sd	a0,-24(s0)
    uint64 scause = r_scause();
    80203580:	fe843783          	ld	a5,-24(s0)
    80203584:	14079073          	csrw	sscratch,a5
    uint64 stval  = r_stval();
    80203588:	0001                	nop
    8020358a:	6462                	ld	s0,24(sp)
    8020358c:	6105                	addi	sp,sp,32
    8020358e:	8082                	ret

0000000080203590 <w_sepc>:
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存
    80203590:	1101                	addi	sp,sp,-32
    80203592:	ec22                	sd	s0,24(sp)
    80203594:	1000                	addi	s0,sp,32
    80203596:	fea43423          	sd	a0,-24(s0)

    8020359a:	fe843783          	ld	a5,-24(s0)
    8020359e:	14179073          	csrw	sepc,a5
    uint64 code = scause & 0xff;
    802035a2:	0001                	nop
    802035a4:	6462                	ld	s0,24(sp)
    802035a6:	6105                	addi	sp,sp,32
    802035a8:	8082                	ret

00000000802035aa <intr_off>:
    uint64 is_intr = (scause >> 63);

    if (!is_intr && code == 8) { // 用户态 ecall
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
        handle_syscall(tf, &info);
        // handle_syscall 应该已 set_sepc(tf, sepc+4)
    802035aa:	1141                	addi	sp,sp,-16
    802035ac:	e406                	sd	ra,8(sp)
    802035ae:	e022                	sd	s0,0(sp)
    802035b0:	0800                	addi	s0,sp,16
    } else if (is_intr) {
    802035b2:	00000097          	auipc	ra,0x0
    802035b6:	f90080e7          	jalr	-112(ra) # 80203542 <r_sstatus>
    802035ba:	87aa                	mv	a5,a0
    802035bc:	9bf5                	andi	a5,a5,-3
    802035be:	853e                	mv	a0,a5
    802035c0:	00000097          	auipc	ra,0x0
    802035c4:	f9c080e7          	jalr	-100(ra) # 8020355c <w_sstatus>
        if (code == 5) {
    802035c8:	0001                	nop
    802035ca:	60a2                	ld	ra,8(sp)
    802035cc:	6402                	ld	s0,0(sp)
    802035ce:	0141                	addi	sp,sp,16
    802035d0:	8082                	ret

00000000802035d2 <w_stvec>:
            timeintr();
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802035d2:	1101                	addi	sp,sp,-32
    802035d4:	ec22                	sd	s0,24(sp)
    802035d6:	1000                	addi	s0,sp,32
    802035d8:	fea43423          	sd	a0,-24(s0)
        } else if (code == 9) {
    802035dc:	fe843783          	ld	a5,-24(s0)
    802035e0:	10579073          	csrw	stvec,a5
            handle_external_interrupt();
    802035e4:	0001                	nop
    802035e6:	6462                	ld	s0,24(sp)
    802035e8:	6105                	addi	sp,sp,32
    802035ea:	8082                	ret

00000000802035ec <r_scause>:
        }
    } else {
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
        handle_exception(tf, &info);
    }

    802035ec:	1101                	addi	sp,sp,-32
    802035ee:	ec22                	sd	s0,24(sp)
    802035f0:	1000                	addi	s0,sp,32
    usertrapret();
}
    802035f2:	142027f3          	csrr	a5,scause
    802035f6:	fef43423          	sd	a5,-24(s0)

    802035fa:	fe843783          	ld	a5,-24(s0)
void usertrapret(void) {
    802035fe:	853e                	mv	a0,a5
    80203600:	6462                	ld	s0,24(sp)
    80203602:	6105                	addi	sp,sp,32
    80203604:	8082                	ret

0000000080203606 <r_sepc>:
    struct proc *p = myproc();

    80203606:	1101                	addi	sp,sp,-32
    80203608:	ec22                	sd	s0,24(sp)
    8020360a:	1000                	addi	s0,sp,32
    // 计算 trampoline 中 uservec 的虚拟地址（对双方页表一致）
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    8020360c:	141027f3          	csrr	a5,sepc
    80203610:	fef43423          	sd	a5,-24(s0)
    w_stvec(uservec_va);
    80203614:	fe843783          	ld	a5,-24(s0)

    80203618:	853e                	mv	a0,a5
    8020361a:	6462                	ld	s0,24(sp)
    8020361c:	6105                	addi	sp,sp,32
    8020361e:	8082                	ret

0000000080203620 <r_stval>:
    // sscratch 设为 TRAPFRAME 的虚拟地址（trampoline 代码用它访问 tf）
    w_sscratch((uint64)TRAPFRAME);
    80203620:	1101                	addi	sp,sp,-32
    80203622:	ec22                	sd	s0,24(sp)
    80203624:	1000                	addi	s0,sp,32

    // 准备用户页表的 satp
    80203626:	143027f3          	csrr	a5,stval
    8020362a:	fef43423          	sd	a5,-24(s0)
    uint64 user_satp = MAKE_SATP(p->pagetable);
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
    802036c8:	00015717          	auipc	a4,0x15
    802036cc:	bc070713          	addi	a4,a4,-1088 # 80218288 <interrupt_vector>
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
    8020370c:	00015717          	auipc	a4,0x15
    80203710:	b7c70713          	addi	a4,a4,-1156 # 80218288 <interrupt_vector>
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
    80203740:	f1c080e7          	jalr	-228(ra) # 80204658 <plic_enable>
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
    80203766:	f4e080e7          	jalr	-178(ra) # 802046b0 <plic_disable>
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
    8020379c:	00015717          	auipc	a4,0x15
    802037a0:	aec70713          	addi	a4,a4,-1300 # 80218288 <interrupt_vector>
    802037a4:	fec42783          	lw	a5,-20(s0)
    802037a8:	078e                	slli	a5,a5,0x3
    802037aa:	97ba                	add	a5,a5,a4
    802037ac:	639c                	ld	a5,0(a5)
    802037ae:	cb99                	beqz	a5,802037c4 <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    802037b0:	00015717          	auipc	a4,0x15
    802037b4:	ad870713          	addi	a4,a4,-1320 # 80218288 <interrupt_vector>
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
    802037da:	f38080e7          	jalr	-200(ra) # 8020470e <plic_claim>
    802037de:	87aa                	mv	a5,a0
    802037e0:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    802037e4:	fec42783          	lw	a5,-20(s0)
    802037e8:	2781                	sext.w	a5,a5
    802037ea:	eb91                	bnez	a5,802037fe <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    802037ec:	0000e517          	auipc	a0,0xe
    802037f0:	b3c50513          	addi	a0,a0,-1220 # 80211328 <simple_user_task_bin+0x68>
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
    80203816:	f24080e7          	jalr	-220(ra) # 80204736 <plic_complete>
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
    80203832:	0000e517          	auipc	a0,0xe
    80203836:	b1650513          	addi	a0,a0,-1258 # 80211348 <simple_user_task_bin+0x88>
    8020383a:	ffffd097          	auipc	ra,0xffffd
    8020383e:	45a080e7          	jalr	1114(ra) # 80200c94 <printf>
	w_stvec((uint64)kernelvec);
    80203842:	00001797          	auipc	a5,0x1
    80203846:	f2e78793          	addi	a5,a5,-210 # 80204770 <kernelvec>
    8020384a:	853e                	mv	a0,a5
    8020384c:	00000097          	auipc	ra,0x0
    80203850:	d86080e7          	jalr	-634(ra) # 802035d2 <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    80203854:	fe042623          	sw	zero,-20(s0)
    80203858:	a005                	j	80203878 <trap_init+0x56>
		interrupt_vector[i] = 0;
    8020385a:	00015717          	auipc	a4,0x15
    8020385e:	a2e70713          	addi	a4,a4,-1490 # 80218288 <interrupt_vector>
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
    8020388c:	d32080e7          	jalr	-718(ra) # 802045ba <plic_init>
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
    802038d0:	a1e58593          	addi	a1,a1,-1506 # 802042ea <handle_store_page_fault>
    802038d4:	0000e517          	auipc	a0,0xe
    802038d8:	a8450513          	addi	a0,a0,-1404 # 80211358 <simple_user_task_bin+0x98>
    802038dc:	ffffd097          	auipc	ra,0xffffd
    802038e0:	3b8080e7          	jalr	952(ra) # 80200c94 <printf>
	printf("trap_init complete.\n");
    802038e4:	0000e517          	auipc	a0,0xe
    802038e8:	aac50513          	addi	a0,a0,-1364 # 80211390 <simple_user_task_bin+0xd0>
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
    80203994:	0000e517          	auipc	a0,0xe
    80203998:	a1450513          	addi	a0,a0,-1516 # 802113a8 <simple_user_task_bin+0xe8>
    8020399c:	ffffd097          	auipc	ra,0xffffd
    802039a0:	2f8080e7          	jalr	760(ra) # 80200c94 <printf>
    802039a4:	a049                	j	80203a26 <kerneltrap+0x128>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    802039a6:	fd043683          	ld	a3,-48(s0)
    802039aa:	fe843603          	ld	a2,-24(s0)
    802039ae:	fd843583          	ld	a1,-40(s0)
    802039b2:	0000e517          	auipc	a0,0xe
    802039b6:	a2e50513          	addi	a0,a0,-1490 # 802113e0 <simple_user_task_bin+0x120>
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
    80203a74:	0000e797          	auipc	a5,0xe
    80203a78:	b2878793          	addi	a5,a5,-1240 # 8021159c <simple_user_task_bin+0x2dc>
    80203a7c:	97ba                	add	a5,a5,a4
    80203a7e:	439c                	lw	a5,0(a5)
    80203a80:	0007871b          	sext.w	a4,a5
    80203a84:	0000e797          	auipc	a5,0xe
    80203a88:	b1878793          	addi	a5,a5,-1256 # 8021159c <simple_user_task_bin+0x2dc>
    80203a8c:	97ba                	add	a5,a5,a4
    80203a8e:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80203a90:	fd043783          	ld	a5,-48(s0)
    80203a94:	6f9c                	ld	a5,24(a5)
    80203a96:	85be                	mv	a1,a5
    80203a98:	0000e517          	auipc	a0,0xe
    80203a9c:	97850513          	addi	a0,a0,-1672 # 80211410 <simple_user_task_bin+0x150>
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
    80203ac8:	0000e517          	auipc	a0,0xe
    80203acc:	97050513          	addi	a0,a0,-1680 # 80211438 <simple_user_task_bin+0x178>
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
    80203b00:	0000e517          	auipc	a0,0xe
    80203b04:	96050513          	addi	a0,a0,-1696 # 80211460 <simple_user_task_bin+0x1a0>
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
    80203b30:	0000e517          	auipc	a0,0xe
    80203b34:	95850513          	addi	a0,a0,-1704 # 80211488 <simple_user_task_bin+0x1c8>
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
    80203b60:	0000e517          	auipc	a0,0xe
    80203b64:	94050513          	addi	a0,a0,-1728 # 802114a0 <simple_user_task_bin+0x1e0>
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
    80203b90:	0000e517          	auipc	a0,0xe
    80203b94:	93050513          	addi	a0,a0,-1744 # 802114c0 <simple_user_task_bin+0x200>
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
    80203bec:	0000e517          	auipc	a0,0xe
    80203bf0:	8f450513          	addi	a0,a0,-1804 # 802114e0 <simple_user_task_bin+0x220>
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
    80203c1c:	0000e517          	auipc	a0,0xe
    80203c20:	8ec50513          	addi	a0,a0,-1812 # 80211508 <simple_user_task_bin+0x248>
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
    80203c7a:	2e2080e7          	jalr	738(ra) # 80203f58 <handle_syscall>
            break;
    80203c7e:	a055                	j	80203d22 <handle_exception+0x2da>
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    80203c80:	fd043783          	ld	a5,-48(s0)
    80203c84:	639c                	ld	a5,0(a5)
    80203c86:	85be                	mv	a1,a5
    80203c88:	0000e517          	auipc	a0,0xe
    80203c8c:	8a050513          	addi	a0,a0,-1888 # 80211528 <simple_user_task_bin+0x268>
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
    80203cbc:	56e080e7          	jalr	1390(ra) # 80204226 <handle_instruction_page_fault>
            break;
    80203cc0:	a08d                	j	80203d22 <handle_exception+0x2da>
            handle_load_page_fault(tf,info);
    80203cc2:	fd043583          	ld	a1,-48(s0)
    80203cc6:	fd843503          	ld	a0,-40(s0)
    80203cca:	00000097          	auipc	ra,0x0
    80203cce:	5be080e7          	jalr	1470(ra) # 80204288 <handle_load_page_fault>
            break;
    80203cd2:	a881                	j	80203d22 <handle_exception+0x2da>
            handle_store_page_fault(tf,info);
    80203cd4:	fd043583          	ld	a1,-48(s0)
    80203cd8:	fd843503          	ld	a0,-40(s0)
    80203cdc:	00000097          	auipc	ra,0x0
    80203ce0:	60e080e7          	jalr	1550(ra) # 802042ea <handle_store_page_fault>
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
    80203cfa:	0000e517          	auipc	a0,0xe
    80203cfe:	85650513          	addi	a0,a0,-1962 # 80211550 <simple_user_task_bin+0x290>
    80203d02:	ffffd097          	auipc	ra,0xffffd
    80203d06:	f92080e7          	jalr	-110(ra) # 80200c94 <printf>
            panic("Unknown exception");
    80203d0a:	0000e517          	auipc	a0,0xe
    80203d0e:	87e50513          	addi	a0,a0,-1922 # 80211588 <simple_user_task_bin+0x2c8>
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
    80203db8:	cec080e7          	jalr	-788(ra) # 80204aa0 <myproc>
    80203dbc:	fea43023          	sd	a0,-32(s0)
    for (int i = 0; i < maxlen; i++) {
    80203dc0:	fe042623          	sw	zero,-20(s0)
    80203dc4:	a085                	j	80203e24 <copyin+0x86>
        char *pa = user_va2pa(p->pagetable, srcva + i);
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

0000000080203e42 <copyout>:
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80203e42:	7139                	addi	sp,sp,-64
    80203e44:	fc06                	sd	ra,56(sp)
    80203e46:	f822                	sd	s0,48(sp)
    80203e48:	0080                	addi	s0,sp,64
    80203e4a:	fca43c23          	sd	a0,-40(s0)
    80203e4e:	fcb43823          	sd	a1,-48(s0)
    80203e52:	fcc43423          	sd	a2,-56(s0)
    80203e56:	fcd43023          	sd	a3,-64(s0)
    for (uint64 i = 0; i < len; i++) {
    80203e5a:	fe043423          	sd	zero,-24(s0)
    80203e5e:	a0a1                	j	80203ea6 <copyout+0x64>
        char *pa = user_va2pa(pagetable, dstva + i);
    80203e60:	fd043703          	ld	a4,-48(s0)
    80203e64:	fe843783          	ld	a5,-24(s0)
    80203e68:	97ba                	add	a5,a5,a4
    80203e6a:	85be                	mv	a1,a5
    80203e6c:	fd843503          	ld	a0,-40(s0)
    80203e70:	00000097          	auipc	ra,0x0
    80203e74:	eba080e7          	jalr	-326(ra) # 80203d2a <user_va2pa>
    80203e78:	fea43023          	sd	a0,-32(s0)
        if (!pa) return -1;
    80203e7c:	fe043783          	ld	a5,-32(s0)
    80203e80:	e399                	bnez	a5,80203e86 <copyout+0x44>
    80203e82:	57fd                	li	a5,-1
    80203e84:	a805                	j	80203eb4 <copyout+0x72>
        *pa = src[i];
    80203e86:	fc843703          	ld	a4,-56(s0)
    80203e8a:	fe843783          	ld	a5,-24(s0)
    80203e8e:	97ba                	add	a5,a5,a4
    80203e90:	0007c703          	lbu	a4,0(a5)
    80203e94:	fe043783          	ld	a5,-32(s0)
    80203e98:	00e78023          	sb	a4,0(a5)
    for (uint64 i = 0; i < len; i++) {
    80203e9c:	fe843783          	ld	a5,-24(s0)
    80203ea0:	0785                	addi	a5,a5,1
    80203ea2:	fef43423          	sd	a5,-24(s0)
    80203ea6:	fe843703          	ld	a4,-24(s0)
    80203eaa:	fc043783          	ld	a5,-64(s0)
    80203eae:	faf769e3          	bltu	a4,a5,80203e60 <copyout+0x1e>
    return 0;
    80203eb2:	4781                	li	a5,0
}
    80203eb4:	853e                	mv	a0,a5
    80203eb6:	70e2                	ld	ra,56(sp)
    80203eb8:	7442                	ld	s0,48(sp)
    80203eba:	6121                	addi	sp,sp,64
    80203ebc:	8082                	ret

0000000080203ebe <copyinstr>:
int copyinstr(char *dst, pagetable_t pagetable, uint64 srcva, int max) {
    80203ebe:	7139                	addi	sp,sp,-64
    80203ec0:	fc06                	sd	ra,56(sp)
    80203ec2:	f822                	sd	s0,48(sp)
    80203ec4:	0080                	addi	s0,sp,64
    80203ec6:	fca43c23          	sd	a0,-40(s0)
    80203eca:	fcb43823          	sd	a1,-48(s0)
    80203ece:	fcc43423          	sd	a2,-56(s0)
    80203ed2:	87b6                	mv	a5,a3
    80203ed4:	fcf42223          	sw	a5,-60(s0)
    for (i = 0; i < max; i++) {
    80203ed8:	fe042623          	sw	zero,-20(s0)
    80203edc:	a0b9                	j	80203f2a <copyinstr+0x6c>
        if (copyin(&c, srcva + i, 1) < 0)  // 每次拷贝 1 字节
    80203ede:	fec42703          	lw	a4,-20(s0)
    80203ee2:	fc843783          	ld	a5,-56(s0)
    80203ee6:	973e                	add	a4,a4,a5
    80203ee8:	feb40793          	addi	a5,s0,-21
    80203eec:	4605                	li	a2,1
    80203eee:	85ba                	mv	a1,a4
    80203ef0:	853e                	mv	a0,a5
    80203ef2:	00000097          	auipc	ra,0x0
    80203ef6:	eac080e7          	jalr	-340(ra) # 80203d9e <copyin>
    80203efa:	87aa                	mv	a5,a0
    80203efc:	0007d463          	bgez	a5,80203f04 <copyinstr+0x46>
            return -1;
    80203f00:	57fd                	li	a5,-1
    80203f02:	a0b1                	j	80203f4e <copyinstr+0x90>
        dst[i] = c;
    80203f04:	fec42783          	lw	a5,-20(s0)
    80203f08:	fd843703          	ld	a4,-40(s0)
    80203f0c:	97ba                	add	a5,a5,a4
    80203f0e:	feb44703          	lbu	a4,-21(s0)
    80203f12:	00e78023          	sb	a4,0(a5)
        if (c == '\0')
    80203f16:	feb44783          	lbu	a5,-21(s0)
    80203f1a:	e399                	bnez	a5,80203f20 <copyinstr+0x62>
            return 0;
    80203f1c:	4781                	li	a5,0
    80203f1e:	a805                	j	80203f4e <copyinstr+0x90>
    for (i = 0; i < max; i++) {
    80203f20:	fec42783          	lw	a5,-20(s0)
    80203f24:	2785                	addiw	a5,a5,1
    80203f26:	fef42623          	sw	a5,-20(s0)
    80203f2a:	fec42783          	lw	a5,-20(s0)
    80203f2e:	873e                	mv	a4,a5
    80203f30:	fc442783          	lw	a5,-60(s0)
    80203f34:	2701                	sext.w	a4,a4
    80203f36:	2781                	sext.w	a5,a5
    80203f38:	faf743e3          	blt	a4,a5,80203ede <copyinstr+0x20>
    dst[max-1] = '\0';
    80203f3c:	fc442783          	lw	a5,-60(s0)
    80203f40:	17fd                	addi	a5,a5,-1
    80203f42:	fd843703          	ld	a4,-40(s0)
    80203f46:	97ba                	add	a5,a5,a4
    80203f48:	00078023          	sb	zero,0(a5)
    return -1; // 超过最大长度还没遇到 \0
    80203f4c:	57fd                	li	a5,-1
}
    80203f4e:	853e                	mv	a0,a5
    80203f50:	70e2                	ld	ra,56(sp)
    80203f52:	7442                	ld	s0,48(sp)
    80203f54:	6121                	addi	sp,sp,64
    80203f56:	8082                	ret

0000000080203f58 <handle_syscall>:
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    80203f58:	7131                	addi	sp,sp,-192
    80203f5a:	fd06                	sd	ra,184(sp)
    80203f5c:	f922                	sd	s0,176(sp)
    80203f5e:	0180                	addi	s0,sp,192
    80203f60:	f4a43423          	sd	a0,-184(s0)
    80203f64:	f4b43023          	sd	a1,-192(s0)
	switch (tf->a7) {
    80203f68:	f4843783          	ld	a5,-184(s0)
    80203f6c:	7bdc                	ld	a5,176(a5)
    80203f6e:	6705                	lui	a4,0x1
    80203f70:	177d                	addi	a4,a4,-1 # fff <_entry-0x801ff001>
    80203f72:	24e78c63          	beq	a5,a4,802041ca <handle_syscall+0x272>
    80203f76:	6705                	lui	a4,0x1
    80203f78:	26e7f663          	bgeu	a5,a4,802041e4 <handle_syscall+0x28c>
    80203f7c:	0de00713          	li	a4,222
    80203f80:	1ee78c63          	beq	a5,a4,80204178 <handle_syscall+0x220>
    80203f84:	0de00713          	li	a4,222
    80203f88:	24f76e63          	bltu	a4,a5,802041e4 <handle_syscall+0x28c>
    80203f8c:	0dd00713          	li	a4,221
    80203f90:	16e78963          	beq	a5,a4,80204102 <handle_syscall+0x1aa>
    80203f94:	0dd00713          	li	a4,221
    80203f98:	24f76663          	bltu	a4,a5,802041e4 <handle_syscall+0x28c>
    80203f9c:	0dc00713          	li	a4,220
    80203fa0:	12e78963          	beq	a5,a4,802040d2 <handle_syscall+0x17a>
    80203fa4:	0dc00713          	li	a4,220
    80203fa8:	22f76e63          	bltu	a4,a5,802041e4 <handle_syscall+0x28c>
    80203fac:	0ad00713          	li	a4,173
    80203fb0:	1ee78863          	beq	a5,a4,802041a0 <handle_syscall+0x248>
    80203fb4:	0ad00713          	li	a4,173
    80203fb8:	22f76663          	bltu	a4,a5,802041e4 <handle_syscall+0x28c>
    80203fbc:	0ac00713          	li	a4,172
    80203fc0:	1ce78563          	beq	a5,a4,8020418a <handle_syscall+0x232>
    80203fc4:	0ac00713          	li	a4,172
    80203fc8:	20f76e63          	bltu	a4,a5,802041e4 <handle_syscall+0x28c>
    80203fcc:	08100713          	li	a4,129
    80203fd0:	0ce78363          	beq	a5,a4,80204096 <handle_syscall+0x13e>
    80203fd4:	08100713          	li	a4,129
    80203fd8:	20f76663          	bltu	a4,a5,802041e4 <handle_syscall+0x28c>
    80203fdc:	05d00713          	li	a4,93
    80203fe0:	08e78563          	beq	a5,a4,8020406a <handle_syscall+0x112>
    80203fe4:	05d00713          	li	a4,93
    80203fe8:	1ef76e63          	bltu	a4,a5,802041e4 <handle_syscall+0x28c>
    80203fec:	4705                	li	a4,1
    80203fee:	00e78663          	beq	a5,a4,80203ffa <handle_syscall+0xa2>
    80203ff2:	4709                	li	a4,2
    80203ff4:	02e78063          	beq	a5,a4,80204014 <handle_syscall+0xbc>
    80203ff8:	a2f5                	j	802041e4 <handle_syscall+0x28c>
			printf("[syscall] print int: %ld\n", tf->a0);
    80203ffa:	f4843783          	ld	a5,-184(s0)
    80203ffe:	7fbc                	ld	a5,120(a5)
    80204000:	85be                	mv	a1,a5
    80204002:	0000d517          	auipc	a0,0xd
    80204006:	5de50513          	addi	a0,a0,1502 # 802115e0 <simple_user_task_bin+0x320>
    8020400a:	ffffd097          	auipc	ra,0xffffd
    8020400e:	c8a080e7          	jalr	-886(ra) # 80200c94 <printf>
			break;
    80204012:	aad5                	j	80204206 <handle_syscall+0x2ae>
			if (copyinstr(buf, myproc()->pagetable, tf->a0, sizeof(buf)) < 0) {
    80204014:	00001097          	auipc	ra,0x1
    80204018:	a8c080e7          	jalr	-1396(ra) # 80204aa0 <myproc>
    8020401c:	87aa                	mv	a5,a0
    8020401e:	7fd8                	ld	a4,184(a5)
    80204020:	f4843783          	ld	a5,-184(s0)
    80204024:	7fb0                	ld	a2,120(a5)
    80204026:	f5840793          	addi	a5,s0,-168
    8020402a:	08000693          	li	a3,128
    8020402e:	85ba                	mv	a1,a4
    80204030:	853e                	mv	a0,a5
    80204032:	00000097          	auipc	ra,0x0
    80204036:	e8c080e7          	jalr	-372(ra) # 80203ebe <copyinstr>
    8020403a:	87aa                	mv	a5,a0
    8020403c:	0007db63          	bgez	a5,80204052 <handle_syscall+0xfa>
				printf("[syscall] invalid string\n");
    80204040:	0000d517          	auipc	a0,0xd
    80204044:	5c050513          	addi	a0,a0,1472 # 80211600 <simple_user_task_bin+0x340>
    80204048:	ffffd097          	auipc	ra,0xffffd
    8020404c:	c4c080e7          	jalr	-948(ra) # 80200c94 <printf>
				break;
    80204050:	aa5d                	j	80204206 <handle_syscall+0x2ae>
			printf("[syscall] print str: %s\n", buf);
    80204052:	f5840793          	addi	a5,s0,-168
    80204056:	85be                	mv	a1,a5
    80204058:	0000d517          	auipc	a0,0xd
    8020405c:	5c850513          	addi	a0,a0,1480 # 80211620 <simple_user_task_bin+0x360>
    80204060:	ffffd097          	auipc	ra,0xffffd
    80204064:	c34080e7          	jalr	-972(ra) # 80200c94 <printf>
			break;
    80204068:	aa79                	j	80204206 <handle_syscall+0x2ae>
			printf("[syscall] exit(%ld)\n", tf->a0);
    8020406a:	f4843783          	ld	a5,-184(s0)
    8020406e:	7fbc                	ld	a5,120(a5)
    80204070:	85be                	mv	a1,a5
    80204072:	0000d517          	auipc	a0,0xd
    80204076:	5ce50513          	addi	a0,a0,1486 # 80211640 <simple_user_task_bin+0x380>
    8020407a:	ffffd097          	auipc	ra,0xffffd
    8020407e:	c1a080e7          	jalr	-998(ra) # 80200c94 <printf>
			exit_proc((int)tf->a0);
    80204082:	f4843783          	ld	a5,-184(s0)
    80204086:	7fbc                	ld	a5,120(a5)
    80204088:	2781                	sext.w	a5,a5
    8020408a:	853e                	mv	a0,a5
    8020408c:	00001097          	auipc	ra,0x1
    80204090:	7bc080e7          	jalr	1980(ra) # 80205848 <exit_proc>
			break;
    80204094:	aa8d                	j	80204206 <handle_syscall+0x2ae>
			if (myproc()->pid == tf->a0){
    80204096:	00001097          	auipc	ra,0x1
    8020409a:	a0a080e7          	jalr	-1526(ra) # 80204aa0 <myproc>
    8020409e:	87aa                	mv	a5,a0
    802040a0:	43dc                	lw	a5,4(a5)
    802040a2:	873e                	mv	a4,a5
    802040a4:	f4843783          	ld	a5,-184(s0)
    802040a8:	7fbc                	ld	a5,120(a5)
    802040aa:	00f71a63          	bne	a4,a5,802040be <handle_syscall+0x166>
				warning("[syscall] will kill itself!!!\n");
    802040ae:	0000d517          	auipc	a0,0xd
    802040b2:	5aa50513          	addi	a0,a0,1450 # 80211658 <simple_user_task_bin+0x398>
    802040b6:	ffffd097          	auipc	ra,0xffffd
    802040ba:	65e080e7          	jalr	1630(ra) # 80201714 <warning>
			kill_proc(tf->a0);
    802040be:	f4843783          	ld	a5,-184(s0)
    802040c2:	7fbc                	ld	a5,120(a5)
    802040c4:	2781                	sext.w	a5,a5
    802040c6:	853e                	mv	a0,a5
    802040c8:	00001097          	auipc	ra,0x1
    802040cc:	71c080e7          	jalr	1820(ra) # 802057e4 <kill_proc>
			break;
    802040d0:	aa1d                	j	80204206 <handle_syscall+0x2ae>
			int child_pid = fork_proc();
    802040d2:	00001097          	auipc	ra,0x1
    802040d6:	2f0080e7          	jalr	752(ra) # 802053c2 <fork_proc>
    802040da:	87aa                	mv	a5,a0
    802040dc:	fcf42e23          	sw	a5,-36(s0)
			tf->a0 = child_pid;
    802040e0:	fdc42703          	lw	a4,-36(s0)
    802040e4:	f4843783          	ld	a5,-184(s0)
    802040e8:	ffb8                	sd	a4,120(a5)
			printf("[syscall] fork -> %d\n", child_pid);
    802040ea:	fdc42783          	lw	a5,-36(s0)
    802040ee:	85be                	mv	a1,a5
    802040f0:	0000d517          	auipc	a0,0xd
    802040f4:	58850513          	addi	a0,a0,1416 # 80211678 <simple_user_task_bin+0x3b8>
    802040f8:	ffffd097          	auipc	ra,0xffffd
    802040fc:	b9c080e7          	jalr	-1124(ra) # 80200c94 <printf>
			break;
    80204100:	a219                	j	80204206 <handle_syscall+0x2ae>
				uint64 uaddr = tf->a0;
    80204102:	f4843783          	ld	a5,-184(s0)
    80204106:	7fbc                	ld	a5,120(a5)
    80204108:	fef43023          	sd	a5,-32(s0)
				int kstatus = 0;
    8020410c:	fc042c23          	sw	zero,-40(s0)
				int pid = wait_proc(uaddr ? &kstatus : NULL);  // 在内核里等待并得到退出码
    80204110:	fe043783          	ld	a5,-32(s0)
    80204114:	c781                	beqz	a5,8020411c <handle_syscall+0x1c4>
    80204116:	fd840793          	addi	a5,s0,-40
    8020411a:	a011                	j	8020411e <handle_syscall+0x1c6>
    8020411c:	4781                	li	a5,0
    8020411e:	853e                	mv	a0,a5
    80204120:	00001097          	auipc	ra,0x1
    80204124:	7f2080e7          	jalr	2034(ra) # 80205912 <wait_proc>
    80204128:	87aa                	mv	a5,a0
    8020412a:	fef42623          	sw	a5,-20(s0)
				if (pid >= 0 && uaddr) {
    8020412e:	fec42783          	lw	a5,-20(s0)
    80204132:	2781                	sext.w	a5,a5
    80204134:	0207cc63          	bltz	a5,8020416c <handle_syscall+0x214>
    80204138:	fe043783          	ld	a5,-32(s0)
    8020413c:	cb85                	beqz	a5,8020416c <handle_syscall+0x214>
					if (copyout(myproc()->pagetable, uaddr, (char *)&kstatus, sizeof(kstatus)) < 0) {
    8020413e:	00001097          	auipc	ra,0x1
    80204142:	962080e7          	jalr	-1694(ra) # 80204aa0 <myproc>
    80204146:	87aa                	mv	a5,a0
    80204148:	7fdc                	ld	a5,184(a5)
    8020414a:	fd840713          	addi	a4,s0,-40
    8020414e:	4691                	li	a3,4
    80204150:	863a                	mv	a2,a4
    80204152:	fe043583          	ld	a1,-32(s0)
    80204156:	853e                	mv	a0,a5
    80204158:	00000097          	auipc	ra,0x0
    8020415c:	cea080e7          	jalr	-790(ra) # 80203e42 <copyout>
    80204160:	87aa                	mv	a5,a0
    80204162:	0007d563          	bgez	a5,8020416c <handle_syscall+0x214>
						pid = -1; // 用户空间地址不可写，视为失败
    80204166:	57fd                	li	a5,-1
    80204168:	fef42623          	sw	a5,-20(s0)
				tf->a0 = pid;
    8020416c:	fec42703          	lw	a4,-20(s0)
    80204170:	f4843783          	ld	a5,-184(s0)
    80204174:	ffb8                	sd	a4,120(a5)
				break;
    80204176:	a841                	j	80204206 <handle_syscall+0x2ae>
			tf->a0 =0;
    80204178:	f4843783          	ld	a5,-184(s0)
    8020417c:	0607bc23          	sd	zero,120(a5)
			yield();
    80204180:	00001097          	auipc	ra,0x1
    80204184:	4ba080e7          	jalr	1210(ra) # 8020563a <yield>
			break;
    80204188:	a8bd                	j	80204206 <handle_syscall+0x2ae>
			tf->a0 = myproc()->pid;
    8020418a:	00001097          	auipc	ra,0x1
    8020418e:	916080e7          	jalr	-1770(ra) # 80204aa0 <myproc>
    80204192:	87aa                	mv	a5,a0
    80204194:	43dc                	lw	a5,4(a5)
    80204196:	873e                	mv	a4,a5
    80204198:	f4843783          	ld	a5,-184(s0)
    8020419c:	ffb8                	sd	a4,120(a5)
			break;
    8020419e:	a0a5                	j	80204206 <handle_syscall+0x2ae>
			tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
    802041a0:	00001097          	auipc	ra,0x1
    802041a4:	900080e7          	jalr	-1792(ra) # 80204aa0 <myproc>
    802041a8:	87aa                	mv	a5,a0
    802041aa:	6fdc                	ld	a5,152(a5)
    802041ac:	cb91                	beqz	a5,802041c0 <handle_syscall+0x268>
    802041ae:	00001097          	auipc	ra,0x1
    802041b2:	8f2080e7          	jalr	-1806(ra) # 80204aa0 <myproc>
    802041b6:	87aa                	mv	a5,a0
    802041b8:	6fdc                	ld	a5,152(a5)
    802041ba:	43dc                	lw	a5,4(a5)
    802041bc:	873e                	mv	a4,a5
    802041be:	a011                	j	802041c2 <handle_syscall+0x26a>
    802041c0:	4701                	li	a4,0
    802041c2:	f4843783          	ld	a5,-184(s0)
    802041c6:	ffb8                	sd	a4,120(a5)
			break;
    802041c8:	a83d                	j	80204206 <handle_syscall+0x2ae>
			tf->a0 = 0;
    802041ca:	f4843783          	ld	a5,-184(s0)
    802041ce:	0607bc23          	sd	zero,120(a5)
			printf("[syscall] step enabled but do nothing\n");
    802041d2:	0000d517          	auipc	a0,0xd
    802041d6:	4be50513          	addi	a0,a0,1214 # 80211690 <simple_user_task_bin+0x3d0>
    802041da:	ffffd097          	auipc	ra,0xffffd
    802041de:	aba080e7          	jalr	-1350(ra) # 80200c94 <printf>
			break;
    802041e2:	a015                	j	80204206 <handle_syscall+0x2ae>
			printf("[syscall] unknown syscall: %ld\n", tf->a7);
    802041e4:	f4843783          	ld	a5,-184(s0)
    802041e8:	7bdc                	ld	a5,176(a5)
    802041ea:	85be                	mv	a1,a5
    802041ec:	0000d517          	auipc	a0,0xd
    802041f0:	4cc50513          	addi	a0,a0,1228 # 802116b8 <simple_user_task_bin+0x3f8>
    802041f4:	ffffd097          	auipc	ra,0xffffd
    802041f8:	aa0080e7          	jalr	-1376(ra) # 80200c94 <printf>
			tf->a0 = -1;
    802041fc:	f4843783          	ld	a5,-184(s0)
    80204200:	577d                	li	a4,-1
    80204202:	ffb8                	sd	a4,120(a5)
			break;
    80204204:	0001                	nop
	set_sepc(tf, info->sepc + 4);
    80204206:	f4043783          	ld	a5,-192(s0)
    8020420a:	639c                	ld	a5,0(a5)
    8020420c:	0791                	addi	a5,a5,4
    8020420e:	85be                	mv	a1,a5
    80204210:	f4843503          	ld	a0,-184(s0)
    80204214:	fffff097          	auipc	ra,0xfffff
    80204218:	46a080e7          	jalr	1130(ra) # 8020367e <set_sepc>
}
    8020421c:	0001                	nop
    8020421e:	70ea                	ld	ra,184(sp)
    80204220:	744a                	ld	s0,176(sp)
    80204222:	6129                	addi	sp,sp,192
    80204224:	8082                	ret

0000000080204226 <handle_instruction_page_fault>:
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    80204226:	1101                	addi	sp,sp,-32
    80204228:	ec06                	sd	ra,24(sp)
    8020422a:	e822                	sd	s0,16(sp)
    8020422c:	1000                	addi	s0,sp,32
    8020422e:	fea43423          	sd	a0,-24(s0)
    80204232:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80204236:	fe043783          	ld	a5,-32(s0)
    8020423a:	6f98                	ld	a4,24(a5)
    8020423c:	fe043783          	ld	a5,-32(s0)
    80204240:	639c                	ld	a5,0(a5)
    80204242:	863e                	mv	a2,a5
    80204244:	85ba                	mv	a1,a4
    80204246:	0000d517          	auipc	a0,0xd
    8020424a:	49250513          	addi	a0,a0,1170 # 802116d8 <simple_user_task_bin+0x418>
    8020424e:	ffffd097          	auipc	ra,0xffffd
    80204252:	a46080e7          	jalr	-1466(ra) # 80200c94 <printf>
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    80204256:	fe043783          	ld	a5,-32(s0)
    8020425a:	6f9c                	ld	a5,24(a5)
    8020425c:	4585                	li	a1,1
    8020425e:	853e                	mv	a0,a5
    80204260:	ffffe097          	auipc	ra,0xffffe
    80204264:	722080e7          	jalr	1826(ra) # 80202982 <handle_page_fault>
    80204268:	87aa                	mv	a5,a0
    8020426a:	eb91                	bnez	a5,8020427e <handle_instruction_page_fault+0x58>
    panic("Unhandled instruction page fault");
    8020426c:	0000d517          	auipc	a0,0xd
    80204270:	49c50513          	addi	a0,a0,1180 # 80211708 <simple_user_task_bin+0x448>
    80204274:	ffffd097          	auipc	ra,0xffffd
    80204278:	46c080e7          	jalr	1132(ra) # 802016e0 <panic>
    8020427c:	a011                	j	80204280 <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    8020427e:	0001                	nop
}
    80204280:	60e2                	ld	ra,24(sp)
    80204282:	6442                	ld	s0,16(sp)
    80204284:	6105                	addi	sp,sp,32
    80204286:	8082                	ret

0000000080204288 <handle_load_page_fault>:
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    80204288:	1101                	addi	sp,sp,-32
    8020428a:	ec06                	sd	ra,24(sp)
    8020428c:	e822                	sd	s0,16(sp)
    8020428e:	1000                	addi	s0,sp,32
    80204290:	fea43423          	sd	a0,-24(s0)
    80204294:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80204298:	fe043783          	ld	a5,-32(s0)
    8020429c:	6f98                	ld	a4,24(a5)
    8020429e:	fe043783          	ld	a5,-32(s0)
    802042a2:	639c                	ld	a5,0(a5)
    802042a4:	863e                	mv	a2,a5
    802042a6:	85ba                	mv	a1,a4
    802042a8:	0000d517          	auipc	a0,0xd
    802042ac:	48850513          	addi	a0,a0,1160 # 80211730 <simple_user_task_bin+0x470>
    802042b0:	ffffd097          	auipc	ra,0xffffd
    802042b4:	9e4080e7          	jalr	-1564(ra) # 80200c94 <printf>
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    802042b8:	fe043783          	ld	a5,-32(s0)
    802042bc:	6f9c                	ld	a5,24(a5)
    802042be:	4589                	li	a1,2
    802042c0:	853e                	mv	a0,a5
    802042c2:	ffffe097          	auipc	ra,0xffffe
    802042c6:	6c0080e7          	jalr	1728(ra) # 80202982 <handle_page_fault>
    802042ca:	87aa                	mv	a5,a0
    802042cc:	eb91                	bnez	a5,802042e0 <handle_load_page_fault+0x58>
    panic("Unhandled load page fault");
    802042ce:	0000d517          	auipc	a0,0xd
    802042d2:	49250513          	addi	a0,a0,1170 # 80211760 <simple_user_task_bin+0x4a0>
    802042d6:	ffffd097          	auipc	ra,0xffffd
    802042da:	40a080e7          	jalr	1034(ra) # 802016e0 <panic>
    802042de:	a011                	j	802042e2 <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802042e0:	0001                	nop
}
    802042e2:	60e2                	ld	ra,24(sp)
    802042e4:	6442                	ld	s0,16(sp)
    802042e6:	6105                	addi	sp,sp,32
    802042e8:	8082                	ret

00000000802042ea <handle_store_page_fault>:
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    802042ea:	1101                	addi	sp,sp,-32
    802042ec:	ec06                	sd	ra,24(sp)
    802042ee:	e822                	sd	s0,16(sp)
    802042f0:	1000                	addi	s0,sp,32
    802042f2:	fea43423          	sd	a0,-24(s0)
    802042f6:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802042fa:	fe043783          	ld	a5,-32(s0)
    802042fe:	6f98                	ld	a4,24(a5)
    80204300:	fe043783          	ld	a5,-32(s0)
    80204304:	639c                	ld	a5,0(a5)
    80204306:	863e                	mv	a2,a5
    80204308:	85ba                	mv	a1,a4
    8020430a:	0000d517          	auipc	a0,0xd
    8020430e:	47650513          	addi	a0,a0,1142 # 80211780 <simple_user_task_bin+0x4c0>
    80204312:	ffffd097          	auipc	ra,0xffffd
    80204316:	982080e7          	jalr	-1662(ra) # 80200c94 <printf>
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    8020431a:	fe043783          	ld	a5,-32(s0)
    8020431e:	6f9c                	ld	a5,24(a5)
    80204320:	458d                	li	a1,3
    80204322:	853e                	mv	a0,a5
    80204324:	ffffe097          	auipc	ra,0xffffe
    80204328:	65e080e7          	jalr	1630(ra) # 80202982 <handle_page_fault>
    8020432c:	87aa                	mv	a5,a0
    8020432e:	eb91                	bnez	a5,80204342 <handle_store_page_fault+0x58>
    panic("Unhandled store page fault");
    80204330:	0000d517          	auipc	a0,0xd
    80204334:	48050513          	addi	a0,a0,1152 # 802117b0 <simple_user_task_bin+0x4f0>
    80204338:	ffffd097          	auipc	ra,0xffffd
    8020433c:	3a8080e7          	jalr	936(ra) # 802016e0 <panic>
    80204340:	a011                	j	80204344 <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80204342:	0001                	nop
}
    80204344:	60e2                	ld	ra,24(sp)
    80204346:	6442                	ld	s0,16(sp)
    80204348:	6105                	addi	sp,sp,32
    8020434a:	8082                	ret

000000008020434c <usertrap>:
void usertrap(void) {
    8020434c:	7159                	addi	sp,sp,-112
    8020434e:	f486                	sd	ra,104(sp)
    80204350:	f0a2                	sd	s0,96(sp)
    80204352:	1880                	addi	s0,sp,112
    struct proc *p = myproc();
    80204354:	00000097          	auipc	ra,0x0
    80204358:	74c080e7          	jalr	1868(ra) # 80204aa0 <myproc>
    8020435c:	fea43423          	sd	a0,-24(s0)
    struct trapframe *tf = p->trapframe;
    80204360:	fe843783          	ld	a5,-24(s0)
    80204364:	63fc                	ld	a5,192(a5)
    80204366:	fef43023          	sd	a5,-32(s0)
    uint64 scause = r_scause();
    8020436a:	fffff097          	auipc	ra,0xfffff
    8020436e:	282080e7          	jalr	642(ra) # 802035ec <r_scause>
    80204372:	fca43c23          	sd	a0,-40(s0)
    uint64 stval  = r_stval();
    80204376:	fffff097          	auipc	ra,0xfffff
    8020437a:	2aa080e7          	jalr	682(ra) # 80203620 <r_stval>
    8020437e:	fca43823          	sd	a0,-48(s0)
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    80204382:	fe043783          	ld	a5,-32(s0)
    80204386:	739c                	ld	a5,32(a5)
    80204388:	fcf43423          	sd	a5,-56(s0)
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存
    8020438c:	fe043783          	ld	a5,-32(s0)
    80204390:	6f9c                	ld	a5,24(a5)
    80204392:	fcf43023          	sd	a5,-64(s0)
    uint64 code = scause & 0xff;
    80204396:	fd843783          	ld	a5,-40(s0)
    8020439a:	0ff7f793          	zext.b	a5,a5
    8020439e:	faf43c23          	sd	a5,-72(s0)
    uint64 is_intr = (scause >> 63);
    802043a2:	fd843783          	ld	a5,-40(s0)
    802043a6:	93fd                	srli	a5,a5,0x3f
    802043a8:	faf43823          	sd	a5,-80(s0)
    if (!is_intr && code == 8) { // 用户态 ecall
    802043ac:	fb043783          	ld	a5,-80(s0)
    802043b0:	e3a1                	bnez	a5,802043f0 <usertrap+0xa4>
    802043b2:	fb843703          	ld	a4,-72(s0)
    802043b6:	47a1                	li	a5,8
    802043b8:	02f71c63          	bne	a4,a5,802043f0 <usertrap+0xa4>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    802043bc:	fc843783          	ld	a5,-56(s0)
    802043c0:	f8f43823          	sd	a5,-112(s0)
    802043c4:	fc043783          	ld	a5,-64(s0)
    802043c8:	f8f43c23          	sd	a5,-104(s0)
    802043cc:	fd843783          	ld	a5,-40(s0)
    802043d0:	faf43023          	sd	a5,-96(s0)
    802043d4:	fd043783          	ld	a5,-48(s0)
    802043d8:	faf43423          	sd	a5,-88(s0)
        handle_syscall(tf, &info);
    802043dc:	f9040793          	addi	a5,s0,-112
    802043e0:	85be                	mv	a1,a5
    802043e2:	fe043503          	ld	a0,-32(s0)
    802043e6:	00000097          	auipc	ra,0x0
    802043ea:	b72080e7          	jalr	-1166(ra) # 80203f58 <handle_syscall>
    if (!is_intr && code == 8) { // 用户态 ecall
    802043ee:	a869                	j	80204488 <usertrap+0x13c>
    } else if (is_intr) {
    802043f0:	fb043783          	ld	a5,-80(s0)
    802043f4:	c3ad                	beqz	a5,80204456 <usertrap+0x10a>
        if (code == 5) {
    802043f6:	fb843703          	ld	a4,-72(s0)
    802043fa:	4795                	li	a5,5
    802043fc:	02f71663          	bne	a4,a5,80204428 <usertrap+0xdc>
            timeintr();
    80204400:	fffff097          	auipc	ra,0xfffff
    80204404:	0e0080e7          	jalr	224(ra) # 802034e0 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80204408:	fffff097          	auipc	ra,0xfffff
    8020440c:	0be080e7          	jalr	190(ra) # 802034c6 <sbi_get_time>
    80204410:	872a                	mv	a4,a0
    80204412:	000f47b7          	lui	a5,0xf4
    80204416:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    8020441a:	97ba                	add	a5,a5,a4
    8020441c:	853e                	mv	a0,a5
    8020441e:	fffff097          	auipc	ra,0xfffff
    80204422:	08c080e7          	jalr	140(ra) # 802034aa <sbi_set_time>
    80204426:	a08d                	j	80204488 <usertrap+0x13c>
        } else if (code == 9) {
    80204428:	fb843703          	ld	a4,-72(s0)
    8020442c:	47a5                	li	a5,9
    8020442e:	00f71763          	bne	a4,a5,8020443c <usertrap+0xf0>
            handle_external_interrupt();
    80204432:	fffff097          	auipc	ra,0xfffff
    80204436:	39c080e7          	jalr	924(ra) # 802037ce <handle_external_interrupt>
    8020443a:	a0b9                	j	80204488 <usertrap+0x13c>
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    8020443c:	fc843603          	ld	a2,-56(s0)
    80204440:	fd843583          	ld	a1,-40(s0)
    80204444:	0000d517          	auipc	a0,0xd
    80204448:	38c50513          	addi	a0,a0,908 # 802117d0 <simple_user_task_bin+0x510>
    8020444c:	ffffd097          	auipc	ra,0xffffd
    80204450:	848080e7          	jalr	-1976(ra) # 80200c94 <printf>
    80204454:	a815                	j	80204488 <usertrap+0x13c>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80204456:	fc843783          	ld	a5,-56(s0)
    8020445a:	f8f43823          	sd	a5,-112(s0)
    8020445e:	fc043783          	ld	a5,-64(s0)
    80204462:	f8f43c23          	sd	a5,-104(s0)
    80204466:	fd843783          	ld	a5,-40(s0)
    8020446a:	faf43023          	sd	a5,-96(s0)
    8020446e:	fd043783          	ld	a5,-48(s0)
    80204472:	faf43423          	sd	a5,-88(s0)
        handle_exception(tf, &info);
    80204476:	f9040793          	addi	a5,s0,-112
    8020447a:	85be                	mv	a1,a5
    8020447c:	fe043503          	ld	a0,-32(s0)
    80204480:	fffff097          	auipc	ra,0xfffff
    80204484:	5c8080e7          	jalr	1480(ra) # 80203a48 <handle_exception>
    usertrapret();
    80204488:	00000097          	auipc	ra,0x0
    8020448c:	012080e7          	jalr	18(ra) # 8020449a <usertrapret>
}
    80204490:	0001                	nop
    80204492:	70a6                	ld	ra,104(sp)
    80204494:	7406                	ld	s0,96(sp)
    80204496:	6165                	addi	sp,sp,112
    80204498:	8082                	ret

000000008020449a <usertrapret>:
void usertrapret(void) {
    8020449a:	7179                	addi	sp,sp,-48
    8020449c:	f406                	sd	ra,40(sp)
    8020449e:	f022                	sd	s0,32(sp)
    802044a0:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    802044a2:	00000097          	auipc	ra,0x0
    802044a6:	5fe080e7          	jalr	1534(ra) # 80204aa0 <myproc>
    802044aa:	fea43423          	sd	a0,-24(s0)
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    802044ae:	00000717          	auipc	a4,0x0
    802044b2:	35270713          	addi	a4,a4,850 # 80204800 <trampoline>
    802044b6:	77fd                	lui	a5,0xfffff
    802044b8:	973e                	add	a4,a4,a5
    802044ba:	00000797          	auipc	a5,0x0
    802044be:	34678793          	addi	a5,a5,838 # 80204800 <trampoline>
    802044c2:	40f707b3          	sub	a5,a4,a5
    802044c6:	fef43023          	sd	a5,-32(s0)
    w_stvec(uservec_va);
    802044ca:	fe043503          	ld	a0,-32(s0)
    802044ce:	fffff097          	auipc	ra,0xfffff
    802044d2:	104080e7          	jalr	260(ra) # 802035d2 <w_stvec>
    w_sscratch((uint64)TRAPFRAME);
    802044d6:	7579                	lui	a0,0xffffe
    802044d8:	fffff097          	auipc	ra,0xfffff
    802044dc:	09e080e7          	jalr	158(ra) # 80203576 <w_sscratch>
    uint64 user_satp = MAKE_SATP(p->pagetable);
    802044e0:	fe843783          	ld	a5,-24(s0)
    802044e4:	7fdc                	ld	a5,184(a5)
    802044e6:	00c7d713          	srli	a4,a5,0xc
    802044ea:	57fd                	li	a5,-1
    802044ec:	17fe                	slli	a5,a5,0x3f
    802044ee:	8fd9                	or	a5,a5,a4
    802044f0:	fcf43c23          	sd	a5,-40(s0)
    // 计算 trampoline 中 userret 的虚拟地址
    uint64 userret_va = (uint64)TRAMPOLINE + ((uint64)userret - (uint64)trampoline);
    802044f4:	00000717          	auipc	a4,0x0
    802044f8:	3a270713          	addi	a4,a4,930 # 80204896 <userret>
    802044fc:	77fd                	lui	a5,0xfffff
    802044fe:	973e                	add	a4,a4,a5
    80204500:	00000797          	auipc	a5,0x0
    80204504:	30078793          	addi	a5,a5,768 # 80204800 <trampoline>
    80204508:	40f707b3          	sub	a5,a4,a5
    8020450c:	fcf43823          	sd	a5,-48(s0)

    // a0 = TRAPFRAME（虚拟地址，双方页表都映射）
    // a1 = user_satp
    register uint64 a0 asm("a0") = (uint64)TRAPFRAME;
    80204510:	7579                	lui	a0,0xffffe
    register uint64 a1 asm("a1") = user_satp;
    80204512:	fd843583          	ld	a1,-40(s0)
    register void (*tgt)(uint64, uint64) asm("t0") = (void *)userret_va;
    80204516:	fd043783          	ld	a5,-48(s0)
    8020451a:	82be                	mv	t0,a5

    // 跳到 trampoline 上的 userret
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(tgt) : "memory");
    8020451c:	8282                	jr	t0
}
    8020451e:	0001                	nop
    80204520:	70a2                	ld	ra,40(sp)
    80204522:	7402                	ld	s0,32(sp)
    80204524:	6145                	addi	sp,sp,48
    80204526:	8082                	ret

0000000080204528 <write32>:
    80204528:	7179                	addi	sp,sp,-48
    8020452a:	f406                	sd	ra,40(sp)
    8020452c:	f022                	sd	s0,32(sp)
    8020452e:	1800                	addi	s0,sp,48
    80204530:	fca43c23          	sd	a0,-40(s0)
    80204534:	87ae                	mv	a5,a1
    80204536:	fcf42a23          	sw	a5,-44(s0)
    8020453a:	fd843783          	ld	a5,-40(s0)
    8020453e:	8b8d                	andi	a5,a5,3
    80204540:	eb99                	bnez	a5,80204556 <write32+0x2e>
    80204542:	fd843783          	ld	a5,-40(s0)
    80204546:	fef43423          	sd	a5,-24(s0)
    8020454a:	fe843783          	ld	a5,-24(s0)
    8020454e:	fd442703          	lw	a4,-44(s0)
    80204552:	c398                	sw	a4,0(a5)
    80204554:	a819                	j	8020456a <write32+0x42>
    80204556:	fd843583          	ld	a1,-40(s0)
    8020455a:	0000e517          	auipc	a0,0xe
    8020455e:	09e50513          	addi	a0,a0,158 # 802125f8 <simple_user_task_bin+0x68>
    80204562:	ffffc097          	auipc	ra,0xffffc
    80204566:	732080e7          	jalr	1842(ra) # 80200c94 <printf>
    8020456a:	0001                	nop
    8020456c:	70a2                	ld	ra,40(sp)
    8020456e:	7402                	ld	s0,32(sp)
    80204570:	6145                	addi	sp,sp,48
    80204572:	8082                	ret

0000000080204574 <read32>:
    80204574:	7179                	addi	sp,sp,-48
    80204576:	f406                	sd	ra,40(sp)
    80204578:	f022                	sd	s0,32(sp)
    8020457a:	1800                	addi	s0,sp,48
    8020457c:	fca43c23          	sd	a0,-40(s0)
    80204580:	fd843783          	ld	a5,-40(s0)
    80204584:	8b8d                	andi	a5,a5,3
    80204586:	eb91                	bnez	a5,8020459a <read32+0x26>
    80204588:	fd843783          	ld	a5,-40(s0)
    8020458c:	fef43423          	sd	a5,-24(s0)
    80204590:	fe843783          	ld	a5,-24(s0)
    80204594:	439c                	lw	a5,0(a5)
    80204596:	2781                	sext.w	a5,a5
    80204598:	a821                	j	802045b0 <read32+0x3c>
    8020459a:	fd843583          	ld	a1,-40(s0)
    8020459e:	0000e517          	auipc	a0,0xe
    802045a2:	08a50513          	addi	a0,a0,138 # 80212628 <simple_user_task_bin+0x98>
    802045a6:	ffffc097          	auipc	ra,0xffffc
    802045aa:	6ee080e7          	jalr	1774(ra) # 80200c94 <printf>
    802045ae:	4781                	li	a5,0
    802045b0:	853e                	mv	a0,a5
    802045b2:	70a2                	ld	ra,40(sp)
    802045b4:	7402                	ld	s0,32(sp)
    802045b6:	6145                	addi	sp,sp,48
    802045b8:	8082                	ret

00000000802045ba <plic_init>:
void plic_init(void) {
    802045ba:	1101                	addi	sp,sp,-32
    802045bc:	ec06                	sd	ra,24(sp)
    802045be:	e822                	sd	s0,16(sp)
    802045c0:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    802045c2:	4785                	li	a5,1
    802045c4:	fef42623          	sw	a5,-20(s0)
    802045c8:	a805                	j	802045f8 <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    802045ca:	fec42783          	lw	a5,-20(s0)
    802045ce:	0027979b          	slliw	a5,a5,0x2
    802045d2:	2781                	sext.w	a5,a5
    802045d4:	873e                	mv	a4,a5
    802045d6:	0c0007b7          	lui	a5,0xc000
    802045da:	97ba                	add	a5,a5,a4
    802045dc:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    802045e0:	4581                	li	a1,0
    802045e2:	fe043503          	ld	a0,-32(s0)
    802045e6:	00000097          	auipc	ra,0x0
    802045ea:	f42080e7          	jalr	-190(ra) # 80204528 <write32>
    for (int i = 1; i <= 32; i++) {
    802045ee:	fec42783          	lw	a5,-20(s0)
    802045f2:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    802045f4:	fef42623          	sw	a5,-20(s0)
    802045f8:	fec42783          	lw	a5,-20(s0)
    802045fc:	0007871b          	sext.w	a4,a5
    80204600:	02000793          	li	a5,32
    80204604:	fce7d3e3          	bge	a5,a4,802045ca <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    80204608:	4585                	li	a1,1
    8020460a:	0c0007b7          	lui	a5,0xc000
    8020460e:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    80204612:	00000097          	auipc	ra,0x0
    80204616:	f16080e7          	jalr	-234(ra) # 80204528 <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    8020461a:	4585                	li	a1,1
    8020461c:	0c0007b7          	lui	a5,0xc000
    80204620:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    80204624:	00000097          	auipc	ra,0x0
    80204628:	f04080e7          	jalr	-252(ra) # 80204528 <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    8020462c:	40200593          	li	a1,1026
    80204630:	0c0027b7          	lui	a5,0xc002
    80204634:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204638:	00000097          	auipc	ra,0x0
    8020463c:	ef0080e7          	jalr	-272(ra) # 80204528 <write32>
    write32(PLIC_THRESHOLD, 0);
    80204640:	4581                	li	a1,0
    80204642:	0c201537          	lui	a0,0xc201
    80204646:	00000097          	auipc	ra,0x0
    8020464a:	ee2080e7          	jalr	-286(ra) # 80204528 <write32>
}
    8020464e:	0001                	nop
    80204650:	60e2                	ld	ra,24(sp)
    80204652:	6442                	ld	s0,16(sp)
    80204654:	6105                	addi	sp,sp,32
    80204656:	8082                	ret

0000000080204658 <plic_enable>:
void plic_enable(int irq) {
    80204658:	7179                	addi	sp,sp,-48
    8020465a:	f406                	sd	ra,40(sp)
    8020465c:	f022                	sd	s0,32(sp)
    8020465e:	1800                	addi	s0,sp,48
    80204660:	87aa                	mv	a5,a0
    80204662:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204666:	0c0027b7          	lui	a5,0xc002
    8020466a:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    8020466e:	00000097          	auipc	ra,0x0
    80204672:	f06080e7          	jalr	-250(ra) # 80204574 <read32>
    80204676:	87aa                	mv	a5,a0
    80204678:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    8020467c:	fdc42783          	lw	a5,-36(s0)
    80204680:	873e                	mv	a4,a5
    80204682:	4785                	li	a5,1
    80204684:	00e797bb          	sllw	a5,a5,a4
    80204688:	2781                	sext.w	a5,a5
    8020468a:	2781                	sext.w	a5,a5
    8020468c:	fec42703          	lw	a4,-20(s0)
    80204690:	8fd9                	or	a5,a5,a4
    80204692:	2781                	sext.w	a5,a5
    80204694:	85be                	mv	a1,a5
    80204696:	0c0027b7          	lui	a5,0xc002
    8020469a:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    8020469e:	00000097          	auipc	ra,0x0
    802046a2:	e8a080e7          	jalr	-374(ra) # 80204528 <write32>
}
    802046a6:	0001                	nop
    802046a8:	70a2                	ld	ra,40(sp)
    802046aa:	7402                	ld	s0,32(sp)
    802046ac:	6145                	addi	sp,sp,48
    802046ae:	8082                	ret

00000000802046b0 <plic_disable>:
void plic_disable(int irq) {
    802046b0:	7179                	addi	sp,sp,-48
    802046b2:	f406                	sd	ra,40(sp)
    802046b4:	f022                	sd	s0,32(sp)
    802046b6:	1800                	addi	s0,sp,48
    802046b8:	87aa                	mv	a5,a0
    802046ba:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    802046be:	0c0027b7          	lui	a5,0xc002
    802046c2:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802046c6:	00000097          	auipc	ra,0x0
    802046ca:	eae080e7          	jalr	-338(ra) # 80204574 <read32>
    802046ce:	87aa                	mv	a5,a0
    802046d0:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    802046d4:	fdc42783          	lw	a5,-36(s0)
    802046d8:	873e                	mv	a4,a5
    802046da:	4785                	li	a5,1
    802046dc:	00e797bb          	sllw	a5,a5,a4
    802046e0:	2781                	sext.w	a5,a5
    802046e2:	fff7c793          	not	a5,a5
    802046e6:	2781                	sext.w	a5,a5
    802046e8:	2781                	sext.w	a5,a5
    802046ea:	fec42703          	lw	a4,-20(s0)
    802046ee:	8ff9                	and	a5,a5,a4
    802046f0:	2781                	sext.w	a5,a5
    802046f2:	85be                	mv	a1,a5
    802046f4:	0c0027b7          	lui	a5,0xc002
    802046f8:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    802046fc:	00000097          	auipc	ra,0x0
    80204700:	e2c080e7          	jalr	-468(ra) # 80204528 <write32>
}
    80204704:	0001                	nop
    80204706:	70a2                	ld	ra,40(sp)
    80204708:	7402                	ld	s0,32(sp)
    8020470a:	6145                	addi	sp,sp,48
    8020470c:	8082                	ret

000000008020470e <plic_claim>:
int plic_claim(void) {
    8020470e:	1141                	addi	sp,sp,-16
    80204710:	e406                	sd	ra,8(sp)
    80204712:	e022                	sd	s0,0(sp)
    80204714:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    80204716:	0c2017b7          	lui	a5,0xc201
    8020471a:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    8020471e:	00000097          	auipc	ra,0x0
    80204722:	e56080e7          	jalr	-426(ra) # 80204574 <read32>
    80204726:	87aa                	mv	a5,a0
    80204728:	2781                	sext.w	a5,a5
    8020472a:	2781                	sext.w	a5,a5
}
    8020472c:	853e                	mv	a0,a5
    8020472e:	60a2                	ld	ra,8(sp)
    80204730:	6402                	ld	s0,0(sp)
    80204732:	0141                	addi	sp,sp,16
    80204734:	8082                	ret

0000000080204736 <plic_complete>:
void plic_complete(int irq) {
    80204736:	1101                	addi	sp,sp,-32
    80204738:	ec06                	sd	ra,24(sp)
    8020473a:	e822                	sd	s0,16(sp)
    8020473c:	1000                	addi	s0,sp,32
    8020473e:	87aa                	mv	a5,a0
    80204740:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    80204744:	fec42783          	lw	a5,-20(s0)
    80204748:	85be                	mv	a1,a5
    8020474a:	0c2017b7          	lui	a5,0xc201
    8020474e:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204752:	00000097          	auipc	ra,0x0
    80204756:	dd6080e7          	jalr	-554(ra) # 80204528 <write32>
    8020475a:	0001                	nop
    8020475c:	60e2                	ld	ra,24(sp)
    8020475e:	6442                	ld	s0,16(sp)
    80204760:	6105                	addi	sp,sp,32
    80204762:	8082                	ret
	...

0000000080204770 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80204770:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80204772:	e006                	sd	ra,0(sp)
        sd gp, 16(sp)
    80204774:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80204776:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80204778:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8020477a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8020477c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    8020477e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80204780:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80204782:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80204784:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80204786:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80204788:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    8020478a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    8020478c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8020478e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80204790:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80204792:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80204794:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80204796:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80204798:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    8020479a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    8020479c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    8020479e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    802047a0:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    802047a2:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    802047a4:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    802047a6:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    802047a8:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    802047aa:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    802047ac:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    802047ae:	fffff097          	auipc	ra,0xfffff
    802047b2:	150080e7          	jalr	336(ra) # 802038fe <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    802047b6:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    802047b8:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    802047ba:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    802047bc:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    802047be:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    802047c0:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    802047c2:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    802047c4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    802047c6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    802047c8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    802047ca:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    802047cc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    802047ce:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    802047d0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    802047d2:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    802047d4:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    802047d6:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    802047d8:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    802047da:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    802047dc:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    802047de:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    802047e0:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    802047e2:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    802047e4:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    802047e6:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    802047e8:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    802047ea:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    802047ec:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    802047ee:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    802047f0:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    802047f2:	10200073          	sret
    802047f6:	0001                	nop
    802047f8:	00000013          	nop
    802047fc:	00000013          	nop

0000000080204800 <trampoline>:
trampoline:
.align 4

uservec:
    # 1. 取 trapframe 指针
    csrrw a0, sscratch, a0      # a0 = TRAPFRAME (用户页表下可访问), sscratch = user a0
    80204800:	14051573          	csrrw	a0,sscratch,a0

    # 2. 在切换页表前，先读出关键字段到 t3–t6
    ld   t3, 0(a0)              # t3 = kernel_satp
    80204804:	00053e03          	ld	t3,0(a0) # c201000 <_entry-0x73fff000>
    ld   t4, 8(a0)              # t4 = kernel_sp
    80204808:	00853e83          	ld	t4,8(a0)
    ld   t5, 264(a0)            # t5 = usertrap
    8020480c:	10853f03          	ld	t5,264(a0)
	ld   t6, 272(a0)			# t6 = kernel_vec
    80204810:	11053f83          	ld	t6,272(a0)

    # 3. 保存用户寄存器到 trapframe（仍在用户页表下）
    sd   ra, 48(a0)
    80204814:	02153823          	sd	ra,48(a0)
    sd   sp, 56(a0)
    80204818:	02253c23          	sd	sp,56(a0)
    sd   gp, 64(a0)
    8020481c:	04353023          	sd	gp,64(a0)
    sd   tp, 72(a0)
    80204820:	04453423          	sd	tp,72(a0)
    sd   t0, 80(a0)
    80204824:	04553823          	sd	t0,80(a0)
    sd   t1, 88(a0)
    80204828:	04653c23          	sd	t1,88(a0)
    sd   t2, 96(a0)
    8020482c:	06753023          	sd	t2,96(a0)
    sd   s0, 104(a0)
    80204830:	f520                	sd	s0,104(a0)
    sd   s1, 112(a0)
    80204832:	f924                	sd	s1,112(a0)

    # 保存用户 a0：先取回 sscratch 里的原值
    csrr t2, sscratch
    80204834:	140023f3          	csrr	t2,sscratch
    sd   t2, 120(a0)
    80204838:	06753c23          	sd	t2,120(a0)

    sd   a1, 128(a0)
    8020483c:	e14c                	sd	a1,128(a0)
    sd   a2, 136(a0)
    8020483e:	e550                	sd	a2,136(a0)
    sd   a3, 144(a0)
    80204840:	e954                	sd	a3,144(a0)
    sd   a4, 152(a0)
    80204842:	ed58                	sd	a4,152(a0)
    sd   a5, 160(a0)
    80204844:	f15c                	sd	a5,160(a0)
    sd   a6, 168(a0)
    80204846:	0b053423          	sd	a6,168(a0)
    sd   a7, 176(a0)
    8020484a:	0b153823          	sd	a7,176(a0)
    sd   s2, 184(a0)
    8020484e:	0b253c23          	sd	s2,184(a0)
    sd   s3, 192(a0)
    80204852:	0d353023          	sd	s3,192(a0)
    sd   s4, 200(a0)
    80204856:	0d453423          	sd	s4,200(a0)
    sd   s5, 208(a0)
    8020485a:	0d553823          	sd	s5,208(a0)
    sd   s6, 216(a0)
    8020485e:	0d653c23          	sd	s6,216(a0)
    sd   s7, 224(a0)
    80204862:	0f753023          	sd	s7,224(a0)
    sd   s8, 232(a0)
    80204866:	0f853423          	sd	s8,232(a0)
    sd   s9, 240(a0)
    8020486a:	0f953823          	sd	s9,240(a0)
    sd   s10, 248(a0)
    8020486e:	0fa53c23          	sd	s10,248(a0)
    sd   s11, 256(a0)
    80204872:	11b53023          	sd	s11,256(a0)

    # 保存控制寄存器
    csrr t0, sstatus
    80204876:	100022f3          	csrr	t0,sstatus
    sd   t0, 24(a0)
    8020487a:	00553c23          	sd	t0,24(a0)
    csrr t1, sepc
    8020487e:	14102373          	csrr	t1,sepc
    sd   t1, 32(a0)
    80204882:	02653023          	sd	t1,32(a0)

    # 4. 切换到内核页表
    csrw satp, t3
    80204886:	180e1073          	csrw	satp,t3
    sfence.vma x0, x0
    8020488a:	12000073          	sfence.vma

    # 5. 切换到内核栈
    mv   sp, t4
    8020488e:	8176                	mv	sp,t4

    # 6. 设置 stvec 并跳转到 C 层 usertrap
    csrw stvec, t6
    80204890:	105f9073          	csrw	stvec,t6
    jr   t5
    80204894:	8f02                	jr	t5

0000000080204896 <userret>:
userret:
        csrw satp, a1
    80204896:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    8020489a:	12000073          	sfence.vma
        ld ra, 48(a0)
    8020489e:	03053083          	ld	ra,48(a0)
        ld sp, 56(a0)
    802048a2:	03853103          	ld	sp,56(a0)
        ld gp, 64(a0)
    802048a6:	04053183          	ld	gp,64(a0)
        ld tp, 72(a0)
    802048aa:	04853203          	ld	tp,72(a0)
        ld t0, 80(a0)
    802048ae:	05053283          	ld	t0,80(a0)
        ld t1, 88(a0)
    802048b2:	05853303          	ld	t1,88(a0)
        ld t2, 96(a0)
    802048b6:	06053383          	ld	t2,96(a0)
        ld s0, 104(a0)
    802048ba:	7520                	ld	s0,104(a0)
        ld s1, 112(a0)
    802048bc:	7924                	ld	s1,112(a0)
        ld a1, 128(a0)
    802048be:	614c                	ld	a1,128(a0)
        ld a2, 136(a0)
    802048c0:	6550                	ld	a2,136(a0)
        ld a3, 144(a0)
    802048c2:	6954                	ld	a3,144(a0)
        ld a4, 152(a0)
    802048c4:	6d58                	ld	a4,152(a0)
        ld a5, 160(a0)
    802048c6:	715c                	ld	a5,160(a0)
        ld a6, 168(a0)
    802048c8:	0a853803          	ld	a6,168(a0)
        ld a7, 176(a0)
    802048cc:	0b053883          	ld	a7,176(a0)
        ld s2, 184(a0)
    802048d0:	0b853903          	ld	s2,184(a0)
        ld s3, 192(a0)
    802048d4:	0c053983          	ld	s3,192(a0)
        ld s4, 200(a0)
    802048d8:	0c853a03          	ld	s4,200(a0)
        ld s5, 208(a0)
    802048dc:	0d053a83          	ld	s5,208(a0)
        ld s6, 216(a0)
    802048e0:	0d853b03          	ld	s6,216(a0)
        ld s7, 224(a0)
    802048e4:	0e053b83          	ld	s7,224(a0)
        ld s8, 232(a0)
    802048e8:	0e853c03          	ld	s8,232(a0)
        ld s9, 240(a0)
    802048ec:	0f053c83          	ld	s9,240(a0)
        ld s10, 248(a0)
    802048f0:	0f853d03          	ld	s10,248(a0)
        ld s11, 256(a0)
    802048f4:	10053d83          	ld	s11,256(a0)

        ld t3, 32(a0)      # 恢复 sepc
    802048f8:	02053e03          	ld	t3,32(a0)
        csrw sepc, t3
    802048fc:	141e1073          	csrw	sepc,t3
        ld t3, 24(a0)      # 恢复 sstatus
    80204900:	01853e03          	ld	t3,24(a0)
        csrw sstatus, t3
    80204904:	100e1073          	csrw	sstatus,t3
		csrw sscratch, a0
    80204908:	14051073          	csrw	sscratch,a0
		ld a0, 120(a0)
    8020490c:	7d28                	ld	a0,120(a0)
    8020490e:	10200073          	sret
    80204912:	0001                	nop
    80204914:	00000013          	nop
    80204918:	00000013          	nop
    8020491c:	00000013          	nop

0000000080204920 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80204920:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80204924:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80204928:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8020492a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8020492c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80204930:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80204934:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80204938:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8020493c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80204940:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80204944:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80204948:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8020494c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80204950:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80204954:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80204958:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8020495c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8020495e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80204960:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80204964:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80204968:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8020496c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80204970:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80204974:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80204978:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8020497c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80204980:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80204984:	0685bd83          	ld	s11,104(a1)
        
        ret
    80204988:	8082                	ret

000000008020498a <r_sstatus>:
    swtch(&p->context, &c->context);
    intr_on();
	if (p->killed) {
        printf("[yield] Process PID %d killed during yield\n", p->pid);
        exit_proc(SYS_kill);
        return;
    8020498a:	1101                	addi	sp,sp,-32
    8020498c:	ec22                	sd	s0,24(sp)
    8020498e:	1000                	addi	s0,sp,32
    }
}
    80204990:	100027f3          	csrr	a5,sstatus
    80204994:	fef43423          	sd	a5,-24(s0)
void sleep(void *chan){
    80204998:	fe843783          	ld	a5,-24(s0)
    struct proc *p = myproc();
    8020499c:	853e                	mv	a0,a5
    8020499e:	6462                	ld	s0,24(sp)
    802049a0:	6105                	addi	sp,sp,32
    802049a2:	8082                	ret

00000000802049a4 <w_sstatus>:
    struct cpu *c = mycpu();
    802049a4:	1101                	addi	sp,sp,-32
    802049a6:	ec22                	sd	s0,24(sp)
    802049a8:	1000                	addi	s0,sp,32
    802049aa:	fea43423          	sd	a0,-24(s0)
    register uint64 ra asm("ra");
    802049ae:	fe843783          	ld	a5,-24(s0)
    802049b2:	10079073          	csrw	sstatus,a5
    p->context.ra = ra;
    802049b6:	0001                	nop
    802049b8:	6462                	ld	s0,24(sp)
    802049ba:	6105                	addi	sp,sp,32
    802049bc:	8082                	ret

00000000802049be <intr_on>:
    p->chan = 0;
	if(p->killed){
		printf("[sleep] Process PID %d killed when wakeup\n", p->pid);
		exit_proc(SYS_kill);
	}
}
    802049be:	1141                	addi	sp,sp,-16
    802049c0:	e406                	sd	ra,8(sp)
    802049c2:	e022                	sd	s0,0(sp)
    802049c4:	0800                	addi	s0,sp,16
void wakeup(void *chan) {
    802049c6:	00000097          	auipc	ra,0x0
    802049ca:	fc4080e7          	jalr	-60(ra) # 8020498a <r_sstatus>
    802049ce:	87aa                	mv	a5,a0
    802049d0:	0027e793          	ori	a5,a5,2
    802049d4:	853e                	mv	a0,a5
    802049d6:	00000097          	auipc	ra,0x0
    802049da:	fce080e7          	jalr	-50(ra) # 802049a4 <w_sstatus>
    for(int i = 0; i < PROC; i++) {
    802049de:	0001                	nop
    802049e0:	60a2                	ld	ra,8(sp)
    802049e2:	6402                	ld	s0,0(sp)
    802049e4:	0141                	addi	sp,sp,16
    802049e6:	8082                	ret

00000000802049e8 <intr_off>:
        struct proc *p = proc_table[i];
        if(p->state == SLEEPING && p->chan == chan) {
    802049e8:	1141                	addi	sp,sp,-16
    802049ea:	e406                	sd	ra,8(sp)
    802049ec:	e022                	sd	s0,0(sp)
    802049ee:	0800                	addi	s0,sp,16
            p->state = RUNNABLE;
    802049f0:	00000097          	auipc	ra,0x0
    802049f4:	f9a080e7          	jalr	-102(ra) # 8020498a <r_sstatus>
    802049f8:	87aa                	mv	a5,a0
    802049fa:	9bf5                	andi	a5,a5,-3
    802049fc:	853e                	mv	a0,a5
    802049fe:	00000097          	auipc	ra,0x0
    80204a02:	fa6080e7          	jalr	-90(ra) # 802049a4 <w_sstatus>
        }
    80204a06:	0001                	nop
    80204a08:	60a2                	ld	ra,8(sp)
    80204a0a:	6402                	ld	s0,0(sp)
    80204a0c:	0141                	addi	sp,sp,16
    80204a0e:	8082                	ret

0000000080204a10 <w_stvec>:
    }
}
    80204a10:	1101                	addi	sp,sp,-32
    80204a12:	ec22                	sd	s0,24(sp)
    80204a14:	1000                	addi	s0,sp,32
    80204a16:	fea43423          	sd	a0,-24(s0)
void kill_proc(int pid){
    80204a1a:	fe843783          	ld	a5,-24(s0)
    80204a1e:	10579073          	csrw	stvec,a5
	for(int i=0;i<PROC;i++){
    80204a22:	0001                	nop
    80204a24:	6462                	ld	s0,24(sp)
    80204a26:	6105                	addi	sp,sp,32
    80204a28:	8082                	ret

0000000080204a2a <assert>:
    
    if (p == 0) {
        printf("Warning: wait_proc called with no current process\n");
        return -1;
    }
    
    80204a2a:	1101                	addi	sp,sp,-32
    80204a2c:	ec06                	sd	ra,24(sp)
    80204a2e:	e822                	sd	s0,16(sp)
    80204a30:	1000                	addi	s0,sp,32
    80204a32:	87aa                	mv	a5,a0
    80204a34:	fef42623          	sw	a5,-20(s0)
    while (1) {
    80204a38:	fec42783          	lw	a5,-20(s0)
    80204a3c:	2781                	sext.w	a5,a5
    80204a3e:	e79d                	bnez	a5,80204a6c <assert+0x42>
        // 关中断确保原子操作
    80204a40:	1a200613          	li	a2,418
    80204a44:	0000f597          	auipc	a1,0xf
    80204a48:	a0458593          	addi	a1,a1,-1532 # 80213448 <simple_user_task_bin+0x68>
    80204a4c:	0000f517          	auipc	a0,0xf
    80204a50:	a0c50513          	addi	a0,a0,-1524 # 80213458 <simple_user_task_bin+0x78>
    80204a54:	ffffc097          	auipc	ra,0xffffc
    80204a58:	240080e7          	jalr	576(ra) # 80200c94 <printf>
        intr_off();
    80204a5c:	0000f517          	auipc	a0,0xf
    80204a60:	a2450513          	addi	a0,a0,-1500 # 80213480 <simple_user_task_bin+0xa0>
    80204a64:	ffffd097          	auipc	ra,0xffffd
    80204a68:	c7c080e7          	jalr	-900(ra) # 802016e0 <panic>
        
        // 优先检查是否有僵尸子进程
    80204a6c:	0001                	nop
    80204a6e:	60e2                	ld	ra,24(sp)
    80204a70:	6442                	ld	s0,16(sp)
    80204a72:	6105                	addi	sp,sp,32
    80204a74:	8082                	ret

0000000080204a76 <shutdown>:
void shutdown() {
    80204a76:	1141                	addi	sp,sp,-16
    80204a78:	e406                	sd	ra,8(sp)
    80204a7a:	e022                	sd	s0,0(sp)
    80204a7c:	0800                	addi	s0,sp,16
	free_proc_table();
    80204a7e:	00000097          	auipc	ra,0x0
    80204a82:	3aa080e7          	jalr	938(ra) # 80204e28 <free_proc_table>
    printf("关机\n");
    80204a86:	0000f517          	auipc	a0,0xf
    80204a8a:	a0250513          	addi	a0,a0,-1534 # 80213488 <simple_user_task_bin+0xa8>
    80204a8e:	ffffc097          	auipc	ra,0xffffc
    80204a92:	206080e7          	jalr	518(ra) # 80200c94 <printf>
    asm volatile (
    80204a96:	48a1                	li	a7,8
    80204a98:	00000073          	ecall
    while (1) { }
    80204a9c:	0001                	nop
    80204a9e:	bffd                	j	80204a9c <shutdown+0x26>

0000000080204aa0 <myproc>:
struct proc* myproc(void) {
    80204aa0:	1141                	addi	sp,sp,-16
    80204aa2:	e422                	sd	s0,8(sp)
    80204aa4:	0800                	addi	s0,sp,16
    return current_proc;
    80204aa6:	00013797          	auipc	a5,0x13
    80204aaa:	62278793          	addi	a5,a5,1570 # 802180c8 <current_proc>
    80204aae:	639c                	ld	a5,0(a5)
}
    80204ab0:	853e                	mv	a0,a5
    80204ab2:	6422                	ld	s0,8(sp)
    80204ab4:	0141                	addi	sp,sp,16
    80204ab6:	8082                	ret

0000000080204ab8 <mycpu>:
struct cpu* mycpu(void) {
    80204ab8:	1141                	addi	sp,sp,-16
    80204aba:	e406                	sd	ra,8(sp)
    80204abc:	e022                	sd	s0,0(sp)
    80204abe:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80204ac0:	00013797          	auipc	a5,0x13
    80204ac4:	61078793          	addi	a5,a5,1552 # 802180d0 <current_cpu>
    80204ac8:	639c                	ld	a5,0(a5)
    80204aca:	ebb9                	bnez	a5,80204b20 <mycpu+0x68>
        warning("current_cpu is NULL, initializing...\n");
    80204acc:	0000f517          	auipc	a0,0xf
    80204ad0:	9c450513          	addi	a0,a0,-1596 # 80213490 <simple_user_task_bin+0xb0>
    80204ad4:	ffffd097          	auipc	ra,0xffffd
    80204ad8:	c40080e7          	jalr	-960(ra) # 80201714 <warning>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    80204adc:	07800613          	li	a2,120
    80204ae0:	4581                	li	a1,0
    80204ae2:	00014517          	auipc	a0,0x14
    80204ae6:	bae50513          	addi	a0,a0,-1106 # 80218690 <cpu_instance.0>
    80204aea:	ffffd097          	auipc	ra,0xffffd
    80204aee:	334080e7          	jalr	820(ra) # 80201e1e <memset>
		current_cpu = &cpu_instance;
    80204af2:	00013797          	auipc	a5,0x13
    80204af6:	5de78793          	addi	a5,a5,1502 # 802180d0 <current_cpu>
    80204afa:	00014717          	auipc	a4,0x14
    80204afe:	b9670713          	addi	a4,a4,-1130 # 80218690 <cpu_instance.0>
    80204b02:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    80204b04:	00013797          	auipc	a5,0x13
    80204b08:	5cc78793          	addi	a5,a5,1484 # 802180d0 <current_cpu>
    80204b0c:	639c                	ld	a5,0(a5)
    80204b0e:	85be                	mv	a1,a5
    80204b10:	0000f517          	auipc	a0,0xf
    80204b14:	9a850513          	addi	a0,a0,-1624 # 802134b8 <simple_user_task_bin+0xd8>
    80204b18:	ffffc097          	auipc	ra,0xffffc
    80204b1c:	17c080e7          	jalr	380(ra) # 80200c94 <printf>
    return current_cpu;
    80204b20:	00013797          	auipc	a5,0x13
    80204b24:	5b078793          	addi	a5,a5,1456 # 802180d0 <current_cpu>
    80204b28:	639c                	ld	a5,0(a5)
}
    80204b2a:	853e                	mv	a0,a5
    80204b2c:	60a2                	ld	ra,8(sp)
    80204b2e:	6402                	ld	s0,0(sp)
    80204b30:	0141                	addi	sp,sp,16
    80204b32:	8082                	ret

0000000080204b34 <return_to_user>:
void return_to_user(void) {
    80204b34:	7179                	addi	sp,sp,-48
    80204b36:	f406                	sd	ra,40(sp)
    80204b38:	f022                	sd	s0,32(sp)
    80204b3a:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80204b3c:	00000097          	auipc	ra,0x0
    80204b40:	f64080e7          	jalr	-156(ra) # 80204aa0 <myproc>
    80204b44:	fea43423          	sd	a0,-24(s0)
    if (!p) panic("return_to_user: no current process");
    80204b48:	fe843783          	ld	a5,-24(s0)
    80204b4c:	eb89                	bnez	a5,80204b5e <return_to_user+0x2a>
    80204b4e:	0000f517          	auipc	a0,0xf
    80204b52:	98250513          	addi	a0,a0,-1662 # 802134d0 <simple_user_task_bin+0xf0>
    80204b56:	ffffd097          	auipc	ra,0xffffd
    80204b5a:	b8a080e7          	jalr	-1142(ra) # 802016e0 <panic>
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    80204b5e:	00000717          	auipc	a4,0x0
    80204b62:	ca270713          	addi	a4,a4,-862 # 80204800 <trampoline>
    80204b66:	00000797          	auipc	a5,0x0
    80204b6a:	c9a78793          	addi	a5,a5,-870 # 80204800 <trampoline>
    80204b6e:	40f707b3          	sub	a5,a4,a5
    80204b72:	873e                	mv	a4,a5
    80204b74:	77fd                	lui	a5,0xfffff
    80204b76:	97ba                	add	a5,a5,a4
    80204b78:	853e                	mv	a0,a5
    80204b7a:	00000097          	auipc	ra,0x0
    80204b7e:	e96080e7          	jalr	-362(ra) # 80204a10 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80204b82:	00000717          	auipc	a4,0x0
    80204b86:	d1470713          	addi	a4,a4,-748 # 80204896 <userret>
    80204b8a:	00000797          	auipc	a5,0x0
    80204b8e:	c7678793          	addi	a5,a5,-906 # 80204800 <trampoline>
    80204b92:	40f707b3          	sub	a5,a4,a5
    80204b96:	873e                	mv	a4,a5
    80204b98:	77fd                	lui	a5,0xfffff
    80204b9a:	97ba                	add	a5,a5,a4
    80204b9c:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    80204ba0:	fe843783          	ld	a5,-24(s0)
    80204ba4:	7fdc                	ld	a5,184(a5)
    80204ba6:	00c7d713          	srli	a4,a5,0xc
    80204baa:	57fd                	li	a5,-1
    80204bac:	17fe                	slli	a5,a5,0x3f
    80204bae:	8fd9                	or	a5,a5,a4
    80204bb0:	fcf43c23          	sd	a5,-40(s0)
    if ((trampoline_userret & ~(PGSIZE - 1)) != TRAMPOLINE) {
    80204bb4:	fe043703          	ld	a4,-32(s0)
    80204bb8:	77fd                	lui	a5,0xfffff
    80204bba:	8f7d                	and	a4,a4,a5
    80204bbc:	77fd                	lui	a5,0xfffff
    80204bbe:	00f70a63          	beq	a4,a5,80204bd2 <return_to_user+0x9e>
        panic("return_to_user: userret outside trampoline page");
    80204bc2:	0000f517          	auipc	a0,0xf
    80204bc6:	93650513          	addi	a0,a0,-1738 # 802134f8 <simple_user_task_bin+0x118>
    80204bca:	ffffd097          	auipc	ra,0xffffd
    80204bce:	b16080e7          	jalr	-1258(ra) # 802016e0 <panic>
    void (*userret_fn)(uint64, uint64) = (void (*)(uint64, uint64))trampoline_userret;
    80204bd2:	fe043783          	ld	a5,-32(s0)
    80204bd6:	fcf43823          	sd	a5,-48(s0)
    userret_fn(TRAPFRAME, satp);
    80204bda:	fd043783          	ld	a5,-48(s0)
    80204bde:	fd843583          	ld	a1,-40(s0)
    80204be2:	7579                	lui	a0,0xffffe
    80204be4:	9782                	jalr	a5
    panic("return_to_user: should not return");
    80204be6:	0000f517          	auipc	a0,0xf
    80204bea:	94250513          	addi	a0,a0,-1726 # 80213528 <simple_user_task_bin+0x148>
    80204bee:	ffffd097          	auipc	ra,0xffffd
    80204bf2:	af2080e7          	jalr	-1294(ra) # 802016e0 <panic>
}
    80204bf6:	0001                	nop
    80204bf8:	70a2                	ld	ra,40(sp)
    80204bfa:	7402                	ld	s0,32(sp)
    80204bfc:	6145                	addi	sp,sp,48
    80204bfe:	8082                	ret

0000000080204c00 <forkret>:
void forkret(void) {
    80204c00:	1101                	addi	sp,sp,-32
    80204c02:	ec06                	sd	ra,24(sp)
    80204c04:	e822                	sd	s0,16(sp)
    80204c06:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80204c08:	00000097          	auipc	ra,0x0
    80204c0c:	e98080e7          	jalr	-360(ra) # 80204aa0 <myproc>
    80204c10:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80204c14:	fe843783          	ld	a5,-24(s0)
    80204c18:	eb89                	bnez	a5,80204c2a <forkret+0x2a>
        panic("forkret: no current process");
    80204c1a:	0000f517          	auipc	a0,0xf
    80204c1e:	93650513          	addi	a0,a0,-1738 # 80213550 <simple_user_task_bin+0x170>
    80204c22:	ffffd097          	auipc	ra,0xffffd
    80204c26:	abe080e7          	jalr	-1346(ra) # 802016e0 <panic>
    if (p->killed) {
    80204c2a:	fe843783          	ld	a5,-24(s0)
    80204c2e:	0807a783          	lw	a5,128(a5) # fffffffffffff080 <_bss_end+0xffffffff7fde6970>
    80204c32:	c785                	beqz	a5,80204c5a <forkret+0x5a>
        printf("[forkret] Process PID %d killed before execution\n", p->pid);
    80204c34:	fe843783          	ld	a5,-24(s0)
    80204c38:	43dc                	lw	a5,4(a5)
    80204c3a:	85be                	mv	a1,a5
    80204c3c:	0000f517          	auipc	a0,0xf
    80204c40:	93450513          	addi	a0,a0,-1740 # 80213570 <simple_user_task_bin+0x190>
    80204c44:	ffffc097          	auipc	ra,0xffffc
    80204c48:	050080e7          	jalr	80(ra) # 80200c94 <printf>
        exit_proc(SYS_kill);
    80204c4c:	08100513          	li	a0,129
    80204c50:	00001097          	auipc	ra,0x1
    80204c54:	bf8080e7          	jalr	-1032(ra) # 80205848 <exit_proc>
        return; // 虽然不会执行到这里，但为了代码清晰
    80204c58:	a099                	j	80204c9e <forkret+0x9e>
    if (p->is_user) {
    80204c5a:	fe843783          	ld	a5,-24(s0)
    80204c5e:	0a87a783          	lw	a5,168(a5)
    80204c62:	c791                	beqz	a5,80204c6e <forkret+0x6e>
        return_to_user();
    80204c64:	00000097          	auipc	ra,0x0
    80204c68:	ed0080e7          	jalr	-304(ra) # 80204b34 <return_to_user>
    80204c6c:	a80d                	j	80204c9e <forkret+0x9e>
		if (p->trapframe->epc) {
    80204c6e:	fe843783          	ld	a5,-24(s0)
    80204c72:	63fc                	ld	a5,192(a5)
    80204c74:	739c                	ld	a5,32(a5)
    80204c76:	cf99                	beqz	a5,80204c94 <forkret+0x94>
			void (*fn)(uint64) = (void(*)(uint64))p->trapframe->epc;
    80204c78:	fe843783          	ld	a5,-24(s0)
    80204c7c:	63fc                	ld	a5,192(a5)
    80204c7e:	739c                	ld	a5,32(a5)
    80204c80:	fef43023          	sd	a5,-32(s0)
			fn(p->trapframe->a0);
    80204c84:	fe843783          	ld	a5,-24(s0)
    80204c88:	63fc                	ld	a5,192(a5)
    80204c8a:	7fb8                	ld	a4,120(a5)
    80204c8c:	fe043783          	ld	a5,-32(s0)
    80204c90:	853a                	mv	a0,a4
    80204c92:	9782                	jalr	a5
        exit_proc(0);  // 内核线程函数返回则退出
    80204c94:	4501                	li	a0,0
    80204c96:	00001097          	auipc	ra,0x1
    80204c9a:	bb2080e7          	jalr	-1102(ra) # 80205848 <exit_proc>
}
    80204c9e:	60e2                	ld	ra,24(sp)
    80204ca0:	6442                	ld	s0,16(sp)
    80204ca2:	6105                	addi	sp,sp,32
    80204ca4:	8082                	ret

0000000080204ca6 <init_proc>:
void init_proc(void){
    80204ca6:	1101                	addi	sp,sp,-32
    80204ca8:	ec06                	sd	ra,24(sp)
    80204caa:	e822                	sd	s0,16(sp)
    80204cac:	1000                	addi	s0,sp,32
    for (int i = 0; i < PROC; i++) {
    80204cae:	fe042623          	sw	zero,-20(s0)
    80204cb2:	aa81                	j	80204e02 <init_proc+0x15c>
        void *page = alloc_page();
    80204cb4:	ffffe097          	auipc	ra,0xffffe
    80204cb8:	572080e7          	jalr	1394(ra) # 80203226 <alloc_page>
    80204cbc:	fea43023          	sd	a0,-32(s0)
        if (!page) panic("init_proc: alloc_page failed for proc_table");
    80204cc0:	fe043783          	ld	a5,-32(s0)
    80204cc4:	eb89                	bnez	a5,80204cd6 <init_proc+0x30>
    80204cc6:	0000f517          	auipc	a0,0xf
    80204cca:	8e250513          	addi	a0,a0,-1822 # 802135a8 <simple_user_task_bin+0x1c8>
    80204cce:	ffffd097          	auipc	ra,0xffffd
    80204cd2:	a12080e7          	jalr	-1518(ra) # 802016e0 <panic>
        proc_table_mem[i] = page;
    80204cd6:	00014717          	auipc	a4,0x14
    80204cda:	8ba70713          	addi	a4,a4,-1862 # 80218590 <proc_table_mem>
    80204cde:	fec42783          	lw	a5,-20(s0)
    80204ce2:	078e                	slli	a5,a5,0x3
    80204ce4:	97ba                	add	a5,a5,a4
    80204ce6:	fe043703          	ld	a4,-32(s0)
    80204cea:	e398                	sd	a4,0(a5)
        proc_table[i] = (struct proc *)page;
    80204cec:	00013717          	auipc	a4,0x13
    80204cf0:	79c70713          	addi	a4,a4,1948 # 80218488 <proc_table>
    80204cf4:	fec42783          	lw	a5,-20(s0)
    80204cf8:	078e                	slli	a5,a5,0x3
    80204cfa:	97ba                	add	a5,a5,a4
    80204cfc:	fe043703          	ld	a4,-32(s0)
    80204d00:	e398                	sd	a4,0(a5)
        memset(proc_table[i], 0, sizeof(struct proc));
    80204d02:	00013717          	auipc	a4,0x13
    80204d06:	78670713          	addi	a4,a4,1926 # 80218488 <proc_table>
    80204d0a:	fec42783          	lw	a5,-20(s0)
    80204d0e:	078e                	slli	a5,a5,0x3
    80204d10:	97ba                	add	a5,a5,a4
    80204d12:	639c                	ld	a5,0(a5)
    80204d14:	0c800613          	li	a2,200
    80204d18:	4581                	li	a1,0
    80204d1a:	853e                	mv	a0,a5
    80204d1c:	ffffd097          	auipc	ra,0xffffd
    80204d20:	102080e7          	jalr	258(ra) # 80201e1e <memset>
        proc_table[i]->state = UNUSED;
    80204d24:	00013717          	auipc	a4,0x13
    80204d28:	76470713          	addi	a4,a4,1892 # 80218488 <proc_table>
    80204d2c:	fec42783          	lw	a5,-20(s0)
    80204d30:	078e                	slli	a5,a5,0x3
    80204d32:	97ba                	add	a5,a5,a4
    80204d34:	639c                	ld	a5,0(a5)
    80204d36:	0007a023          	sw	zero,0(a5)
        proc_table[i]->pid = 0;
    80204d3a:	00013717          	auipc	a4,0x13
    80204d3e:	74e70713          	addi	a4,a4,1870 # 80218488 <proc_table>
    80204d42:	fec42783          	lw	a5,-20(s0)
    80204d46:	078e                	slli	a5,a5,0x3
    80204d48:	97ba                	add	a5,a5,a4
    80204d4a:	639c                	ld	a5,0(a5)
    80204d4c:	0007a223          	sw	zero,4(a5)
        proc_table[i]->kstack = 0;
    80204d50:	00013717          	auipc	a4,0x13
    80204d54:	73870713          	addi	a4,a4,1848 # 80218488 <proc_table>
    80204d58:	fec42783          	lw	a5,-20(s0)
    80204d5c:	078e                	slli	a5,a5,0x3
    80204d5e:	97ba                	add	a5,a5,a4
    80204d60:	639c                	ld	a5,0(a5)
    80204d62:	0007b423          	sd	zero,8(a5)
        proc_table[i]->pagetable = 0;
    80204d66:	00013717          	auipc	a4,0x13
    80204d6a:	72270713          	addi	a4,a4,1826 # 80218488 <proc_table>
    80204d6e:	fec42783          	lw	a5,-20(s0)
    80204d72:	078e                	slli	a5,a5,0x3
    80204d74:	97ba                	add	a5,a5,a4
    80204d76:	639c                	ld	a5,0(a5)
    80204d78:	0a07bc23          	sd	zero,184(a5)
        proc_table[i]->trapframe = 0;
    80204d7c:	00013717          	auipc	a4,0x13
    80204d80:	70c70713          	addi	a4,a4,1804 # 80218488 <proc_table>
    80204d84:	fec42783          	lw	a5,-20(s0)
    80204d88:	078e                	slli	a5,a5,0x3
    80204d8a:	97ba                	add	a5,a5,a4
    80204d8c:	639c                	ld	a5,0(a5)
    80204d8e:	0c07b023          	sd	zero,192(a5)
        proc_table[i]->parent = 0;
    80204d92:	00013717          	auipc	a4,0x13
    80204d96:	6f670713          	addi	a4,a4,1782 # 80218488 <proc_table>
    80204d9a:	fec42783          	lw	a5,-20(s0)
    80204d9e:	078e                	slli	a5,a5,0x3
    80204da0:	97ba                	add	a5,a5,a4
    80204da2:	639c                	ld	a5,0(a5)
    80204da4:	0807bc23          	sd	zero,152(a5)
        proc_table[i]->chan = 0;
    80204da8:	00013717          	auipc	a4,0x13
    80204dac:	6e070713          	addi	a4,a4,1760 # 80218488 <proc_table>
    80204db0:	fec42783          	lw	a5,-20(s0)
    80204db4:	078e                	slli	a5,a5,0x3
    80204db6:	97ba                	add	a5,a5,a4
    80204db8:	639c                	ld	a5,0(a5)
    80204dba:	0a07b023          	sd	zero,160(a5)
        proc_table[i]->exit_status = 0;
    80204dbe:	00013717          	auipc	a4,0x13
    80204dc2:	6ca70713          	addi	a4,a4,1738 # 80218488 <proc_table>
    80204dc6:	fec42783          	lw	a5,-20(s0)
    80204dca:	078e                	slli	a5,a5,0x3
    80204dcc:	97ba                	add	a5,a5,a4
    80204dce:	639c                	ld	a5,0(a5)
    80204dd0:	0807a223          	sw	zero,132(a5)
        memset(&proc_table[i]->context, 0, sizeof(struct context));
    80204dd4:	00013717          	auipc	a4,0x13
    80204dd8:	6b470713          	addi	a4,a4,1716 # 80218488 <proc_table>
    80204ddc:	fec42783          	lw	a5,-20(s0)
    80204de0:	078e                	slli	a5,a5,0x3
    80204de2:	97ba                	add	a5,a5,a4
    80204de4:	639c                	ld	a5,0(a5)
    80204de6:	07c1                	addi	a5,a5,16
    80204de8:	07000613          	li	a2,112
    80204dec:	4581                	li	a1,0
    80204dee:	853e                	mv	a0,a5
    80204df0:	ffffd097          	auipc	ra,0xffffd
    80204df4:	02e080e7          	jalr	46(ra) # 80201e1e <memset>
    for (int i = 0; i < PROC; i++) {
    80204df8:	fec42783          	lw	a5,-20(s0)
    80204dfc:	2785                	addiw	a5,a5,1
    80204dfe:	fef42623          	sw	a5,-20(s0)
    80204e02:	fec42783          	lw	a5,-20(s0)
    80204e06:	0007871b          	sext.w	a4,a5
    80204e0a:	47fd                	li	a5,31
    80204e0c:	eae7d4e3          	bge	a5,a4,80204cb4 <init_proc+0xe>
    proc_table_pages = PROC; // 每个进程一页
    80204e10:	00013797          	auipc	a5,0x13
    80204e14:	77878793          	addi	a5,a5,1912 # 80218588 <proc_table_pages>
    80204e18:	02000713          	li	a4,32
    80204e1c:	c398                	sw	a4,0(a5)
}
    80204e1e:	0001                	nop
    80204e20:	60e2                	ld	ra,24(sp)
    80204e22:	6442                	ld	s0,16(sp)
    80204e24:	6105                	addi	sp,sp,32
    80204e26:	8082                	ret

0000000080204e28 <free_proc_table>:
void free_proc_table(void) {
    80204e28:	1101                	addi	sp,sp,-32
    80204e2a:	ec06                	sd	ra,24(sp)
    80204e2c:	e822                	sd	s0,16(sp)
    80204e2e:	1000                	addi	s0,sp,32
    for (int i = 0; i < proc_table_pages; i++) {
    80204e30:	fe042623          	sw	zero,-20(s0)
    80204e34:	a025                	j	80204e5c <free_proc_table+0x34>
        free_page(proc_table_mem[i]);
    80204e36:	00013717          	auipc	a4,0x13
    80204e3a:	75a70713          	addi	a4,a4,1882 # 80218590 <proc_table_mem>
    80204e3e:	fec42783          	lw	a5,-20(s0)
    80204e42:	078e                	slli	a5,a5,0x3
    80204e44:	97ba                	add	a5,a5,a4
    80204e46:	639c                	ld	a5,0(a5)
    80204e48:	853e                	mv	a0,a5
    80204e4a:	ffffe097          	auipc	ra,0xffffe
    80204e4e:	448080e7          	jalr	1096(ra) # 80203292 <free_page>
    for (int i = 0; i < proc_table_pages; i++) {
    80204e52:	fec42783          	lw	a5,-20(s0)
    80204e56:	2785                	addiw	a5,a5,1
    80204e58:	fef42623          	sw	a5,-20(s0)
    80204e5c:	00013797          	auipc	a5,0x13
    80204e60:	72c78793          	addi	a5,a5,1836 # 80218588 <proc_table_pages>
    80204e64:	4398                	lw	a4,0(a5)
    80204e66:	fec42783          	lw	a5,-20(s0)
    80204e6a:	2781                	sext.w	a5,a5
    80204e6c:	fce7c5e3          	blt	a5,a4,80204e36 <free_proc_table+0xe>
}
    80204e70:	0001                	nop
    80204e72:	0001                	nop
    80204e74:	60e2                	ld	ra,24(sp)
    80204e76:	6442                	ld	s0,16(sp)
    80204e78:	6105                	addi	sp,sp,32
    80204e7a:	8082                	ret

0000000080204e7c <alloc_proc>:
struct proc* alloc_proc(int is_user) {
    80204e7c:	7139                	addi	sp,sp,-64
    80204e7e:	fc06                	sd	ra,56(sp)
    80204e80:	f822                	sd	s0,48(sp)
    80204e82:	0080                	addi	s0,sp,64
    80204e84:	87aa                	mv	a5,a0
    80204e86:	fcf42623          	sw	a5,-52(s0)
    for(int i = 0;i<PROC;i++) {
    80204e8a:	fe042623          	sw	zero,-20(s0)
    80204e8e:	aaa5                	j	80205006 <alloc_proc+0x18a>
		struct proc *p = proc_table[i];
    80204e90:	00013717          	auipc	a4,0x13
    80204e94:	5f870713          	addi	a4,a4,1528 # 80218488 <proc_table>
    80204e98:	fec42783          	lw	a5,-20(s0)
    80204e9c:	078e                	slli	a5,a5,0x3
    80204e9e:	97ba                	add	a5,a5,a4
    80204ea0:	639c                	ld	a5,0(a5)
    80204ea2:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    80204ea6:	fe043783          	ld	a5,-32(s0)
    80204eaa:	439c                	lw	a5,0(a5)
    80204eac:	14079863          	bnez	a5,80204ffc <alloc_proc+0x180>
            p->pid = i;
    80204eb0:	fe043783          	ld	a5,-32(s0)
    80204eb4:	fec42703          	lw	a4,-20(s0)
    80204eb8:	c3d8                	sw	a4,4(a5)
            p->state = USED;
    80204eba:	fe043783          	ld	a5,-32(s0)
    80204ebe:	4705                	li	a4,1
    80204ec0:	c398                	sw	a4,0(a5)
			p->is_user = is_user;
    80204ec2:	fe043783          	ld	a5,-32(s0)
    80204ec6:	fcc42703          	lw	a4,-52(s0)
    80204eca:	0ae7a423          	sw	a4,168(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    80204ece:	ffffe097          	auipc	ra,0xffffe
    80204ed2:	358080e7          	jalr	856(ra) # 80203226 <alloc_page>
    80204ed6:	872a                	mv	a4,a0
    80204ed8:	fe043783          	ld	a5,-32(s0)
    80204edc:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    80204ede:	fe043783          	ld	a5,-32(s0)
    80204ee2:	63fc                	ld	a5,192(a5)
    80204ee4:	eb99                	bnez	a5,80204efa <alloc_proc+0x7e>
                p->state = UNUSED;
    80204ee6:	fe043783          	ld	a5,-32(s0)
    80204eea:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80204eee:	fe043783          	ld	a5,-32(s0)
    80204ef2:	0007a223          	sw	zero,4(a5)
                return 0;
    80204ef6:	4781                	li	a5,0
    80204ef8:	aa39                	j	80205016 <alloc_proc+0x19a>
			if(p->is_user){
    80204efa:	fe043783          	ld	a5,-32(s0)
    80204efe:	0a87a783          	lw	a5,168(a5)
    80204f02:	c3b9                	beqz	a5,80204f48 <alloc_proc+0xcc>
				p->pagetable = create_pagetable();
    80204f04:	ffffd097          	auipc	ra,0xffffd
    80204f08:	176080e7          	jalr	374(ra) # 8020207a <create_pagetable>
    80204f0c:	872a                	mv	a4,a0
    80204f0e:	fe043783          	ld	a5,-32(s0)
    80204f12:	ffd8                	sd	a4,184(a5)
				if(p->pagetable == 0){
    80204f14:	fe043783          	ld	a5,-32(s0)
    80204f18:	7fdc                	ld	a5,184(a5)
    80204f1a:	ef9d                	bnez	a5,80204f58 <alloc_proc+0xdc>
					free_page(p->trapframe);
    80204f1c:	fe043783          	ld	a5,-32(s0)
    80204f20:	63fc                	ld	a5,192(a5)
    80204f22:	853e                	mv	a0,a5
    80204f24:	ffffe097          	auipc	ra,0xffffe
    80204f28:	36e080e7          	jalr	878(ra) # 80203292 <free_page>
					p->trapframe = 0;
    80204f2c:	fe043783          	ld	a5,-32(s0)
    80204f30:	0c07b023          	sd	zero,192(a5)
					p->state = UNUSED;
    80204f34:	fe043783          	ld	a5,-32(s0)
    80204f38:	0007a023          	sw	zero,0(a5)
					p->pid = 0;
    80204f3c:	fe043783          	ld	a5,-32(s0)
    80204f40:	0007a223          	sw	zero,4(a5)
					return 0;
    80204f44:	4781                	li	a5,0
    80204f46:	a8c1                	j	80205016 <alloc_proc+0x19a>
				p->pagetable = kernel_pagetable;
    80204f48:	00013797          	auipc	a5,0x13
    80204f4c:	16878793          	addi	a5,a5,360 # 802180b0 <kernel_pagetable>
    80204f50:	6398                	ld	a4,0(a5)
    80204f52:	fe043783          	ld	a5,-32(s0)
    80204f56:	ffd8                	sd	a4,184(a5)
            void *kstack_mem = alloc_page();
    80204f58:	ffffe097          	auipc	ra,0xffffe
    80204f5c:	2ce080e7          	jalr	718(ra) # 80203226 <alloc_page>
    80204f60:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    80204f64:	fd843783          	ld	a5,-40(s0)
    80204f68:	e3b9                	bnez	a5,80204fae <alloc_proc+0x132>
                free_page(p->trapframe);
    80204f6a:	fe043783          	ld	a5,-32(s0)
    80204f6e:	63fc                	ld	a5,192(a5)
    80204f70:	853e                	mv	a0,a5
    80204f72:	ffffe097          	auipc	ra,0xffffe
    80204f76:	320080e7          	jalr	800(ra) # 80203292 <free_page>
                free_pagetable(p->pagetable);
    80204f7a:	fe043783          	ld	a5,-32(s0)
    80204f7e:	7fdc                	ld	a5,184(a5)
    80204f80:	853e                	mv	a0,a5
    80204f82:	ffffd097          	auipc	ra,0xffffd
    80204f86:	4dc080e7          	jalr	1244(ra) # 8020245e <free_pagetable>
                p->trapframe = 0;
    80204f8a:	fe043783          	ld	a5,-32(s0)
    80204f8e:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    80204f92:	fe043783          	ld	a5,-32(s0)
    80204f96:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    80204f9a:	fe043783          	ld	a5,-32(s0)
    80204f9e:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80204fa2:	fe043783          	ld	a5,-32(s0)
    80204fa6:	0007a223          	sw	zero,4(a5)
                return 0;
    80204faa:	4781                	li	a5,0
    80204fac:	a0ad                	j	80205016 <alloc_proc+0x19a>
            p->kstack = (uint64)kstack_mem;
    80204fae:	fd843703          	ld	a4,-40(s0)
    80204fb2:	fe043783          	ld	a5,-32(s0)
    80204fb6:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    80204fb8:	fe043783          	ld	a5,-32(s0)
    80204fbc:	07c1                	addi	a5,a5,16
    80204fbe:	07000613          	li	a2,112
    80204fc2:	4581                	li	a1,0
    80204fc4:	853e                	mv	a0,a5
    80204fc6:	ffffd097          	auipc	ra,0xffffd
    80204fca:	e58080e7          	jalr	-424(ra) # 80201e1e <memset>
            p->context.ra = (uint64)forkret;
    80204fce:	00000717          	auipc	a4,0x0
    80204fd2:	c3270713          	addi	a4,a4,-974 # 80204c00 <forkret>
    80204fd6:	fe043783          	ld	a5,-32(s0)
    80204fda:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    80204fdc:	fe043783          	ld	a5,-32(s0)
    80204fe0:	6798                	ld	a4,8(a5)
    80204fe2:	6785                	lui	a5,0x1
    80204fe4:	17c1                	addi	a5,a5,-16 # ff0 <_entry-0x801ff010>
    80204fe6:	973e                	add	a4,a4,a5
    80204fe8:	fe043783          	ld	a5,-32(s0)
    80204fec:	ef98                	sd	a4,24(a5)
			p->killed = 0; //重置死亡状态
    80204fee:	fe043783          	ld	a5,-32(s0)
    80204ff2:	0807a023          	sw	zero,128(a5)
            return p;
    80204ff6:	fe043783          	ld	a5,-32(s0)
    80204ffa:	a831                	j	80205016 <alloc_proc+0x19a>
    for(int i = 0;i<PROC;i++) {
    80204ffc:	fec42783          	lw	a5,-20(s0)
    80205000:	2785                	addiw	a5,a5,1
    80205002:	fef42623          	sw	a5,-20(s0)
    80205006:	fec42783          	lw	a5,-20(s0)
    8020500a:	0007871b          	sext.w	a4,a5
    8020500e:	47fd                	li	a5,31
    80205010:	e8e7d0e3          	bge	a5,a4,80204e90 <alloc_proc+0x14>
    return 0;
    80205014:	4781                	li	a5,0
}
    80205016:	853e                	mv	a0,a5
    80205018:	70e2                	ld	ra,56(sp)
    8020501a:	7442                	ld	s0,48(sp)
    8020501c:	6121                	addi	sp,sp,64
    8020501e:	8082                	ret

0000000080205020 <free_proc>:
void free_proc(struct proc *p){
    80205020:	1101                	addi	sp,sp,-32
    80205022:	ec06                	sd	ra,24(sp)
    80205024:	e822                	sd	s0,16(sp)
    80205026:	1000                	addi	s0,sp,32
    80205028:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    8020502c:	fe843783          	ld	a5,-24(s0)
    80205030:	63fc                	ld	a5,192(a5)
    80205032:	cb89                	beqz	a5,80205044 <free_proc+0x24>
        free_page(p->trapframe);
    80205034:	fe843783          	ld	a5,-24(s0)
    80205038:	63fc                	ld	a5,192(a5)
    8020503a:	853e                	mv	a0,a5
    8020503c:	ffffe097          	auipc	ra,0xffffe
    80205040:	256080e7          	jalr	598(ra) # 80203292 <free_page>
    p->trapframe = 0;
    80205044:	fe843783          	ld	a5,-24(s0)
    80205048:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable && p->pagetable != kernel_pagetable)
    8020504c:	fe843783          	ld	a5,-24(s0)
    80205050:	7fdc                	ld	a5,184(a5)
    80205052:	c39d                	beqz	a5,80205078 <free_proc+0x58>
    80205054:	fe843783          	ld	a5,-24(s0)
    80205058:	7fd8                	ld	a4,184(a5)
    8020505a:	00013797          	auipc	a5,0x13
    8020505e:	05678793          	addi	a5,a5,86 # 802180b0 <kernel_pagetable>
    80205062:	639c                	ld	a5,0(a5)
    80205064:	00f70a63          	beq	a4,a5,80205078 <free_proc+0x58>
        free_pagetable(p->pagetable);
    80205068:	fe843783          	ld	a5,-24(s0)
    8020506c:	7fdc                	ld	a5,184(a5)
    8020506e:	853e                	mv	a0,a5
    80205070:	ffffd097          	auipc	ra,0xffffd
    80205074:	3ee080e7          	jalr	1006(ra) # 8020245e <free_pagetable>
    p->pagetable = 0;
    80205078:	fe843783          	ld	a5,-24(s0)
    8020507c:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    80205080:	fe843783          	ld	a5,-24(s0)
    80205084:	679c                	ld	a5,8(a5)
    80205086:	cb89                	beqz	a5,80205098 <free_proc+0x78>
        free_page((void*)p->kstack);
    80205088:	fe843783          	ld	a5,-24(s0)
    8020508c:	679c                	ld	a5,8(a5)
    8020508e:	853e                	mv	a0,a5
    80205090:	ffffe097          	auipc	ra,0xffffe
    80205094:	202080e7          	jalr	514(ra) # 80203292 <free_page>
    p->kstack = 0;
    80205098:	fe843783          	ld	a5,-24(s0)
    8020509c:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    802050a0:	fe843783          	ld	a5,-24(s0)
    802050a4:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    802050a8:	fe843783          	ld	a5,-24(s0)
    802050ac:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    802050b0:	fe843783          	ld	a5,-24(s0)
    802050b4:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    802050b8:	fe843783          	ld	a5,-24(s0)
    802050bc:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    802050c0:	fe843783          	ld	a5,-24(s0)
    802050c4:	07c1                	addi	a5,a5,16
    802050c6:	07000613          	li	a2,112
    802050ca:	4581                	li	a1,0
    802050cc:	853e                	mv	a0,a5
    802050ce:	ffffd097          	auipc	ra,0xffffd
    802050d2:	d50080e7          	jalr	-688(ra) # 80201e1e <memset>
}
    802050d6:	0001                	nop
    802050d8:	60e2                	ld	ra,24(sp)
    802050da:	6442                	ld	s0,16(sp)
    802050dc:	6105                	addi	sp,sp,32
    802050de:	8082                	ret

00000000802050e0 <create_kernel_proc>:
int create_kernel_proc(void (*entry)(void)) {
    802050e0:	7179                	addi	sp,sp,-48
    802050e2:	f406                	sd	ra,40(sp)
    802050e4:	f022                	sd	s0,32(sp)
    802050e6:	1800                	addi	s0,sp,48
    802050e8:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc(0);
    802050ec:	4501                	li	a0,0
    802050ee:	00000097          	auipc	ra,0x0
    802050f2:	d8e080e7          	jalr	-626(ra) # 80204e7c <alloc_proc>
    802050f6:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    802050fa:	fe843783          	ld	a5,-24(s0)
    802050fe:	e399                	bnez	a5,80205104 <create_kernel_proc+0x24>
    80205100:	57fd                	li	a5,-1
    80205102:	a089                	j	80205144 <create_kernel_proc+0x64>
    p->trapframe->epc = (uint64)entry;
    80205104:	fe843783          	ld	a5,-24(s0)
    80205108:	63fc                	ld	a5,192(a5)
    8020510a:	fd843703          	ld	a4,-40(s0)
    8020510e:	f398                	sd	a4,32(a5)
    p->state = RUNNABLE;
    80205110:	fe843783          	ld	a5,-24(s0)
    80205114:	470d                	li	a4,3
    80205116:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    80205118:	00000097          	auipc	ra,0x0
    8020511c:	988080e7          	jalr	-1656(ra) # 80204aa0 <myproc>
    80205120:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    80205124:	fe043783          	ld	a5,-32(s0)
    80205128:	c799                	beqz	a5,80205136 <create_kernel_proc+0x56>
        p->parent = parent;
    8020512a:	fe843783          	ld	a5,-24(s0)
    8020512e:	fe043703          	ld	a4,-32(s0)
    80205132:	efd8                	sd	a4,152(a5)
    80205134:	a029                	j	8020513e <create_kernel_proc+0x5e>
        p->parent = NULL;
    80205136:	fe843783          	ld	a5,-24(s0)
    8020513a:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    8020513e:	fe843783          	ld	a5,-24(s0)
    80205142:	43dc                	lw	a5,4(a5)
}
    80205144:	853e                	mv	a0,a5
    80205146:	70a2                	ld	ra,40(sp)
    80205148:	7402                	ld	s0,32(sp)
    8020514a:	6145                	addi	sp,sp,48
    8020514c:	8082                	ret

000000008020514e <create_kernel_proc1>:
int create_kernel_proc1(void (*entry)(uint64),uint64 arg){
    8020514e:	7179                	addi	sp,sp,-48
    80205150:	f406                	sd	ra,40(sp)
    80205152:	f022                	sd	s0,32(sp)
    80205154:	1800                	addi	s0,sp,48
    80205156:	fca43c23          	sd	a0,-40(s0)
    8020515a:	fcb43823          	sd	a1,-48(s0)
	struct proc *p = alloc_proc(0);
    8020515e:	4501                	li	a0,0
    80205160:	00000097          	auipc	ra,0x0
    80205164:	d1c080e7          	jalr	-740(ra) # 80204e7c <alloc_proc>
    80205168:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    8020516c:	fe843783          	ld	a5,-24(s0)
    80205170:	e399                	bnez	a5,80205176 <create_kernel_proc1+0x28>
    80205172:	57fd                	li	a5,-1
    80205174:	a0b9                	j	802051c2 <create_kernel_proc1+0x74>
    p->trapframe->epc = (uint64)entry;
    80205176:	fe843783          	ld	a5,-24(s0)
    8020517a:	63fc                	ld	a5,192(a5)
    8020517c:	fd843703          	ld	a4,-40(s0)
    80205180:	f398                	sd	a4,32(a5)
	p->trapframe->a0 = (uint64)arg;
    80205182:	fe843783          	ld	a5,-24(s0)
    80205186:	63fc                	ld	a5,192(a5)
    80205188:	fd043703          	ld	a4,-48(s0)
    8020518c:	ffb8                	sd	a4,120(a5)
    p->state = RUNNABLE;
    8020518e:	fe843783          	ld	a5,-24(s0)
    80205192:	470d                	li	a4,3
    80205194:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    80205196:	00000097          	auipc	ra,0x0
    8020519a:	90a080e7          	jalr	-1782(ra) # 80204aa0 <myproc>
    8020519e:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    802051a2:	fe043783          	ld	a5,-32(s0)
    802051a6:	c799                	beqz	a5,802051b4 <create_kernel_proc1+0x66>
        p->parent = parent;
    802051a8:	fe843783          	ld	a5,-24(s0)
    802051ac:	fe043703          	ld	a4,-32(s0)
    802051b0:	efd8                	sd	a4,152(a5)
    802051b2:	a029                	j	802051bc <create_kernel_proc1+0x6e>
        p->parent = NULL;
    802051b4:	fe843783          	ld	a5,-24(s0)
    802051b8:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    802051bc:	fe843783          	ld	a5,-24(s0)
    802051c0:	43dc                	lw	a5,4(a5)
}
    802051c2:	853e                	mv	a0,a5
    802051c4:	70a2                	ld	ra,40(sp)
    802051c6:	7402                	ld	s0,32(sp)
    802051c8:	6145                	addi	sp,sp,48
    802051ca:	8082                	ret

00000000802051cc <create_user_proc>:
int create_user_proc(const void *user_bin, int bin_size) {
    802051cc:	715d                	addi	sp,sp,-80
    802051ce:	e486                	sd	ra,72(sp)
    802051d0:	e0a2                	sd	s0,64(sp)
    802051d2:	0880                	addi	s0,sp,80
    802051d4:	faa43c23          	sd	a0,-72(s0)
    802051d8:	87ae                	mv	a5,a1
    802051da:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = alloc_proc(1); // 1 表示用户进程
    802051de:	4505                	li	a0,1
    802051e0:	00000097          	auipc	ra,0x0
    802051e4:	c9c080e7          	jalr	-868(ra) # 80204e7c <alloc_proc>
    802051e8:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    802051ec:	fe843783          	ld	a5,-24(s0)
    802051f0:	e399                	bnez	a5,802051f6 <create_user_proc+0x2a>
    802051f2:	57fd                	li	a5,-1
    802051f4:	a2d1                	j	802053b8 <create_user_proc+0x1ec>
    uint64 user_entry = 0x10000;
    802051f6:	67c1                	lui	a5,0x10
    802051f8:	fef43023          	sd	a5,-32(s0)
    uint64 user_stack = 0x20000;
    802051fc:	000207b7          	lui	a5,0x20
    80205200:	fcf43c23          	sd	a5,-40(s0)
    void *page = alloc_page();
    80205204:	ffffe097          	auipc	ra,0xffffe
    80205208:	022080e7          	jalr	34(ra) # 80203226 <alloc_page>
    8020520c:	fca43823          	sd	a0,-48(s0)
    if (!page) { free_proc(p); return -1; }
    80205210:	fd043783          	ld	a5,-48(s0)
    80205214:	eb89                	bnez	a5,80205226 <create_user_proc+0x5a>
    80205216:	fe843503          	ld	a0,-24(s0)
    8020521a:	00000097          	auipc	ra,0x0
    8020521e:	e06080e7          	jalr	-506(ra) # 80205020 <free_proc>
    80205222:	57fd                	li	a5,-1
    80205224:	aa51                	j	802053b8 <create_user_proc+0x1ec>
    map_page(p->pagetable, user_entry, (uint64)page, PTE_R | PTE_W | PTE_X | PTE_U);
    80205226:	fe843783          	ld	a5,-24(s0)
    8020522a:	7fdc                	ld	a5,184(a5)
    8020522c:	fd043703          	ld	a4,-48(s0)
    80205230:	46f9                	li	a3,30
    80205232:	863a                	mv	a2,a4
    80205234:	fe043583          	ld	a1,-32(s0)
    80205238:	853e                	mv	a0,a5
    8020523a:	ffffd097          	auipc	ra,0xffffd
    8020523e:	0b0080e7          	jalr	176(ra) # 802022ea <map_page>
    memcpy((void*)page, user_bin, bin_size);
    80205242:	fb442783          	lw	a5,-76(s0)
    80205246:	863e                	mv	a2,a5
    80205248:	fb843583          	ld	a1,-72(s0)
    8020524c:	fd043503          	ld	a0,-48(s0)
    80205250:	ffffd097          	auipc	ra,0xffffd
    80205254:	cda080e7          	jalr	-806(ra) # 80201f2a <memcpy>
    void *stack_page = alloc_page();
    80205258:	ffffe097          	auipc	ra,0xffffe
    8020525c:	fce080e7          	jalr	-50(ra) # 80203226 <alloc_page>
    80205260:	fca43423          	sd	a0,-56(s0)
    if (!stack_page) { free_proc(p); return -1; }
    80205264:	fc843783          	ld	a5,-56(s0)
    80205268:	eb89                	bnez	a5,8020527a <create_user_proc+0xae>
    8020526a:	fe843503          	ld	a0,-24(s0)
    8020526e:	00000097          	auipc	ra,0x0
    80205272:	db2080e7          	jalr	-590(ra) # 80205020 <free_proc>
    80205276:	57fd                	li	a5,-1
    80205278:	a281                	j	802053b8 <create_user_proc+0x1ec>
    map_page(p->pagetable, user_stack - PGSIZE, (uint64)stack_page, PTE_R | PTE_W | PTE_U);
    8020527a:	fe843783          	ld	a5,-24(s0)
    8020527e:	7fc8                	ld	a0,184(a5)
    80205280:	fd843703          	ld	a4,-40(s0)
    80205284:	77fd                	lui	a5,0xfffff
    80205286:	97ba                	add	a5,a5,a4
    80205288:	fc843703          	ld	a4,-56(s0)
    8020528c:	46d9                	li	a3,22
    8020528e:	863a                	mv	a2,a4
    80205290:	85be                	mv	a1,a5
    80205292:	ffffd097          	auipc	ra,0xffffd
    80205296:	058080e7          	jalr	88(ra) # 802022ea <map_page>
	p->sz = user_stack; // 用户空间从 0x10000 到 0x20000
    8020529a:	fe843783          	ld	a5,-24(s0)
    8020529e:	fd843703          	ld	a4,-40(s0)
    802052a2:	fbd8                	sd	a4,176(a5)
    if (map_page(p->pagetable, TRAPFRAME, (uint64)p->trapframe, PTE_R | PTE_W) != 0) {
    802052a4:	fe843783          	ld	a5,-24(s0)
    802052a8:	7fd8                	ld	a4,184(a5)
    802052aa:	fe843783          	ld	a5,-24(s0)
    802052ae:	63fc                	ld	a5,192(a5)
    802052b0:	4699                	li	a3,6
    802052b2:	863e                	mv	a2,a5
    802052b4:	75f9                	lui	a1,0xffffe
    802052b6:	853a                	mv	a0,a4
    802052b8:	ffffd097          	auipc	ra,0xffffd
    802052bc:	032080e7          	jalr	50(ra) # 802022ea <map_page>
    802052c0:	87aa                	mv	a5,a0
    802052c2:	cb89                	beqz	a5,802052d4 <create_user_proc+0x108>
        free_proc(p);
    802052c4:	fe843503          	ld	a0,-24(s0)
    802052c8:	00000097          	auipc	ra,0x0
    802052cc:	d58080e7          	jalr	-680(ra) # 80205020 <free_proc>
        return -1;
    802052d0:	57fd                	li	a5,-1
    802052d2:	a0dd                	j	802053b8 <create_user_proc+0x1ec>
	memset(p->trapframe, 0, sizeof(*p->trapframe));
    802052d4:	fe843783          	ld	a5,-24(s0)
    802052d8:	63fc                	ld	a5,192(a5)
    802052da:	11800613          	li	a2,280
    802052de:	4581                	li	a1,0
    802052e0:	853e                	mv	a0,a5
    802052e2:	ffffd097          	auipc	ra,0xffffd
    802052e6:	b3c080e7          	jalr	-1220(ra) # 80201e1e <memset>
	p->trapframe->epc = user_entry; // 应为 0x10000
    802052ea:	fe843783          	ld	a5,-24(s0)
    802052ee:	63fc                	ld	a5,192(a5)
    802052f0:	fe043703          	ld	a4,-32(s0)
    802052f4:	f398                	sd	a4,32(a5)
	p->trapframe->sp = user_stack;  // 应为 0x20000
    802052f6:	fe843783          	ld	a5,-24(s0)
    802052fa:	63fc                	ld	a5,192(a5)
    802052fc:	fd843703          	ld	a4,-40(s0)
    80205300:	ff98                	sd	a4,56(a5)
	p->trapframe->sstatus = (1UL << 5); // 0x20
    80205302:	fe843783          	ld	a5,-24(s0)
    80205306:	63fc                	ld	a5,192(a5)
    80205308:	02000713          	li	a4,32
    8020530c:	ef98                	sd	a4,24(a5)
	p->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable);
    8020530e:	00013797          	auipc	a5,0x13
    80205312:	da278793          	addi	a5,a5,-606 # 802180b0 <kernel_pagetable>
    80205316:	639c                	ld	a5,0(a5)
    80205318:	00c7d693          	srli	a3,a5,0xc
    8020531c:	fe843783          	ld	a5,-24(s0)
    80205320:	63fc                	ld	a5,192(a5)
    80205322:	577d                	li	a4,-1
    80205324:	177e                	slli	a4,a4,0x3f
    80205326:	8f55                	or	a4,a4,a3
    80205328:	e398                	sd	a4,0(a5)
	p->trapframe->kernel_sp = p->kstack + PGSIZE;   // 内核栈顶
    8020532a:	fe843783          	ld	a5,-24(s0)
    8020532e:	6794                	ld	a3,8(a5)
    80205330:	fe843783          	ld	a5,-24(s0)
    80205334:	63fc                	ld	a5,192(a5)
    80205336:	6705                	lui	a4,0x1
    80205338:	9736                	add	a4,a4,a3
    8020533a:	e798                	sd	a4,8(a5)
	p->trapframe->usertrap  = (uint64)usertrap;     // C 层 trap 处理函数
    8020533c:	fe843783          	ld	a5,-24(s0)
    80205340:	63fc                	ld	a5,192(a5)
    80205342:	fffff717          	auipc	a4,0xfffff
    80205346:	00a70713          	addi	a4,a4,10 # 8020434c <usertrap>
    8020534a:	10e7b423          	sd	a4,264(a5)
	p->trapframe->kernel_vec = (uint64)kernelvec;
    8020534e:	fe843783          	ld	a5,-24(s0)
    80205352:	63fc                	ld	a5,192(a5)
    80205354:	fffff717          	auipc	a4,0xfffff
    80205358:	41c70713          	addi	a4,a4,1052 # 80204770 <kernelvec>
    8020535c:	10e7b823          	sd	a4,272(a5)
    p->state = RUNNABLE;
    80205360:	fe843783          	ld	a5,-24(s0)
    80205364:	470d                	li	a4,3
    80205366:	c398                	sw	a4,0(a5)
	if (map_page(p->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_X | PTE_R) != 0) {
    80205368:	fe843783          	ld	a5,-24(s0)
    8020536c:	7fd8                	ld	a4,184(a5)
    8020536e:	00013797          	auipc	a5,0x13
    80205372:	d4a78793          	addi	a5,a5,-694 # 802180b8 <trampoline_phys_addr>
    80205376:	639c                	ld	a5,0(a5)
    80205378:	46a9                	li	a3,10
    8020537a:	863e                	mv	a2,a5
    8020537c:	75fd                	lui	a1,0xfffff
    8020537e:	853a                	mv	a0,a4
    80205380:	ffffd097          	auipc	ra,0xffffd
    80205384:	f6a080e7          	jalr	-150(ra) # 802022ea <map_page>
    80205388:	87aa                	mv	a5,a0
    8020538a:	cb89                	beqz	a5,8020539c <create_user_proc+0x1d0>
		free_proc(p);
    8020538c:	fe843503          	ld	a0,-24(s0)
    80205390:	00000097          	auipc	ra,0x0
    80205394:	c90080e7          	jalr	-880(ra) # 80205020 <free_proc>
		return -1;
    80205398:	57fd                	li	a5,-1
    8020539a:	a839                	j	802053b8 <create_user_proc+0x1ec>
    struct proc *parent = myproc();
    8020539c:	fffff097          	auipc	ra,0xfffff
    802053a0:	704080e7          	jalr	1796(ra) # 80204aa0 <myproc>
    802053a4:	fca43023          	sd	a0,-64(s0)
    p->parent = parent ? parent : NULL;
    802053a8:	fe843783          	ld	a5,-24(s0)
    802053ac:	fc043703          	ld	a4,-64(s0)
    802053b0:	efd8                	sd	a4,152(a5)
    return p->pid;
    802053b2:	fe843783          	ld	a5,-24(s0)
    802053b6:	43dc                	lw	a5,4(a5)
}
    802053b8:	853e                	mv	a0,a5
    802053ba:	60a6                	ld	ra,72(sp)
    802053bc:	6406                	ld	s0,64(sp)
    802053be:	6161                	addi	sp,sp,80
    802053c0:	8082                	ret

00000000802053c2 <fork_proc>:
int fork_proc(void) {
    802053c2:	7179                	addi	sp,sp,-48
    802053c4:	f406                	sd	ra,40(sp)
    802053c6:	f022                	sd	s0,32(sp)
    802053c8:	1800                	addi	s0,sp,48
    struct proc *parent = myproc();
    802053ca:	fffff097          	auipc	ra,0xfffff
    802053ce:	6d6080e7          	jalr	1750(ra) # 80204aa0 <myproc>
    802053d2:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc(parent->is_user);
    802053d6:	fe843783          	ld	a5,-24(s0)
    802053da:	0a87a783          	lw	a5,168(a5)
    802053de:	853e                	mv	a0,a5
    802053e0:	00000097          	auipc	ra,0x0
    802053e4:	a9c080e7          	jalr	-1380(ra) # 80204e7c <alloc_proc>
    802053e8:	fea43023          	sd	a0,-32(s0)
    if (!child) return -1;
    802053ec:	fe043783          	ld	a5,-32(s0)
    802053f0:	e399                	bnez	a5,802053f6 <fork_proc+0x34>
    802053f2:	57fd                	li	a5,-1
    802053f4:	a279                	j	80205582 <fork_proc+0x1c0>
    if (uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0) {
    802053f6:	fe843783          	ld	a5,-24(s0)
    802053fa:	7fd8                	ld	a4,184(a5)
    802053fc:	fe043783          	ld	a5,-32(s0)
    80205400:	7fd4                	ld	a3,184(a5)
    80205402:	fe843783          	ld	a5,-24(s0)
    80205406:	7bdc                	ld	a5,176(a5)
    80205408:	863e                	mv	a2,a5
    8020540a:	85b6                	mv	a1,a3
    8020540c:	853a                	mv	a0,a4
    8020540e:	ffffe097          	auipc	ra,0xffffe
    80205412:	c48080e7          	jalr	-952(ra) # 80203056 <uvmcopy>
    80205416:	87aa                	mv	a5,a0
    80205418:	0007da63          	bgez	a5,8020542c <fork_proc+0x6a>
        free_proc(child);
    8020541c:	fe043503          	ld	a0,-32(s0)
    80205420:	00000097          	auipc	ra,0x0
    80205424:	c00080e7          	jalr	-1024(ra) # 80205020 <free_proc>
        return -1;
    80205428:	57fd                	li	a5,-1
    8020542a:	aaa1                	j	80205582 <fork_proc+0x1c0>
    child->sz = parent->sz;
    8020542c:	fe843783          	ld	a5,-24(s0)
    80205430:	7bd8                	ld	a4,176(a5)
    80205432:	fe043783          	ld	a5,-32(s0)
    80205436:	fbd8                	sd	a4,176(a5)
    uint64 tf_pa = (uint64)child->trapframe;
    80205438:	fe043783          	ld	a5,-32(s0)
    8020543c:	63fc                	ld	a5,192(a5)
    8020543e:	fcf43c23          	sd	a5,-40(s0)
    if ((tf_pa & (PGSIZE - 1)) != 0) {
    80205442:	fd843703          	ld	a4,-40(s0)
    80205446:	6785                	lui	a5,0x1
    80205448:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    8020544a:	8ff9                	and	a5,a5,a4
    8020544c:	c39d                	beqz	a5,80205472 <fork_proc+0xb0>
        printf("[fork] trapframe not aligned: 0x%lx\n", tf_pa);
    8020544e:	fd843583          	ld	a1,-40(s0)
    80205452:	0000e517          	auipc	a0,0xe
    80205456:	18650513          	addi	a0,a0,390 # 802135d8 <simple_user_task_bin+0x1f8>
    8020545a:	ffffc097          	auipc	ra,0xffffc
    8020545e:	83a080e7          	jalr	-1990(ra) # 80200c94 <printf>
        free_proc(child);
    80205462:	fe043503          	ld	a0,-32(s0)
    80205466:	00000097          	auipc	ra,0x0
    8020546a:	bba080e7          	jalr	-1094(ra) # 80205020 <free_proc>
        return -1;
    8020546e:	57fd                	li	a5,-1
    80205470:	aa09                	j	80205582 <fork_proc+0x1c0>
    if (map_page(child->pagetable, TRAPFRAME, tf_pa, PTE_R | PTE_W) != 0) {
    80205472:	fe043783          	ld	a5,-32(s0)
    80205476:	7fdc                	ld	a5,184(a5)
    80205478:	4699                	li	a3,6
    8020547a:	fd843603          	ld	a2,-40(s0)
    8020547e:	75f9                	lui	a1,0xffffe
    80205480:	853e                	mv	a0,a5
    80205482:	ffffd097          	auipc	ra,0xffffd
    80205486:	e68080e7          	jalr	-408(ra) # 802022ea <map_page>
    8020548a:	87aa                	mv	a5,a0
    8020548c:	c38d                	beqz	a5,802054ae <fork_proc+0xec>
        printf("[fork] map TRAPFRAME failed\n");
    8020548e:	0000e517          	auipc	a0,0xe
    80205492:	17250513          	addi	a0,a0,370 # 80213600 <simple_user_task_bin+0x220>
    80205496:	ffffb097          	auipc	ra,0xffffb
    8020549a:	7fe080e7          	jalr	2046(ra) # 80200c94 <printf>
        free_proc(child);
    8020549e:	fe043503          	ld	a0,-32(s0)
    802054a2:	00000097          	auipc	ra,0x0
    802054a6:	b7e080e7          	jalr	-1154(ra) # 80205020 <free_proc>
        return -1;
    802054aa:	57fd                	li	a5,-1
    802054ac:	a8d9                	j	80205582 <fork_proc+0x1c0>
    if (map_page(child->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_R | PTE_X) != 0) {
    802054ae:	fe043783          	ld	a5,-32(s0)
    802054b2:	7fd8                	ld	a4,184(a5)
    802054b4:	00013797          	auipc	a5,0x13
    802054b8:	c0478793          	addi	a5,a5,-1020 # 802180b8 <trampoline_phys_addr>
    802054bc:	639c                	ld	a5,0(a5)
    802054be:	46a9                	li	a3,10
    802054c0:	863e                	mv	a2,a5
    802054c2:	75fd                	lui	a1,0xfffff
    802054c4:	853a                	mv	a0,a4
    802054c6:	ffffd097          	auipc	ra,0xffffd
    802054ca:	e24080e7          	jalr	-476(ra) # 802022ea <map_page>
    802054ce:	87aa                	mv	a5,a0
    802054d0:	c38d                	beqz	a5,802054f2 <fork_proc+0x130>
        printf("[fork] map TRAMPOLINE failed\n");
    802054d2:	0000e517          	auipc	a0,0xe
    802054d6:	14e50513          	addi	a0,a0,334 # 80213620 <simple_user_task_bin+0x240>
    802054da:	ffffb097          	auipc	ra,0xffffb
    802054de:	7ba080e7          	jalr	1978(ra) # 80200c94 <printf>
        free_proc(child);
    802054e2:	fe043503          	ld	a0,-32(s0)
    802054e6:	00000097          	auipc	ra,0x0
    802054ea:	b3a080e7          	jalr	-1222(ra) # 80205020 <free_proc>
        return -1;
    802054ee:	57fd                	li	a5,-1
    802054f0:	a849                	j	80205582 <fork_proc+0x1c0>
    *(child->trapframe) = *(parent->trapframe);
    802054f2:	fe843783          	ld	a5,-24(s0)
    802054f6:	63f8                	ld	a4,192(a5)
    802054f8:	fe043783          	ld	a5,-32(s0)
    802054fc:	63fc                	ld	a5,192(a5)
    802054fe:	86be                	mv	a3,a5
    80205500:	11800793          	li	a5,280
    80205504:	863e                	mv	a2,a5
    80205506:	85ba                	mv	a1,a4
    80205508:	8536                	mv	a0,a3
    8020550a:	ffffd097          	auipc	ra,0xffffd
    8020550e:	a20080e7          	jalr	-1504(ra) # 80201f2a <memcpy>
	child->trapframe->kernel_sp = child->kstack + PGSIZE;
    80205512:	fe043783          	ld	a5,-32(s0)
    80205516:	6794                	ld	a3,8(a5)
    80205518:	fe043783          	ld	a5,-32(s0)
    8020551c:	63fc                	ld	a5,192(a5)
    8020551e:	6705                	lui	a4,0x1
    80205520:	9736                	add	a4,a4,a3
    80205522:	e798                	sd	a4,8(a5)
	assert(child->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable));
    80205524:	00013797          	auipc	a5,0x13
    80205528:	b8c78793          	addi	a5,a5,-1140 # 802180b0 <kernel_pagetable>
    8020552c:	639c                	ld	a5,0(a5)
    8020552e:	00c7d693          	srli	a3,a5,0xc
    80205532:	fe043783          	ld	a5,-32(s0)
    80205536:	63fc                	ld	a5,192(a5)
    80205538:	577d                	li	a4,-1
    8020553a:	177e                	slli	a4,a4,0x3f
    8020553c:	8f55                	or	a4,a4,a3
    8020553e:	e398                	sd	a4,0(a5)
    80205540:	639c                	ld	a5,0(a5)
    80205542:	2781                	sext.w	a5,a5
    80205544:	853e                	mv	a0,a5
    80205546:	fffff097          	auipc	ra,0xfffff
    8020554a:	4e4080e7          	jalr	1252(ra) # 80204a2a <assert>
    child->trapframe->epc += 4;  // 跳过 ecall 指令
    8020554e:	fe043783          	ld	a5,-32(s0)
    80205552:	63fc                	ld	a5,192(a5)
    80205554:	7398                	ld	a4,32(a5)
    80205556:	fe043783          	ld	a5,-32(s0)
    8020555a:	63fc                	ld	a5,192(a5)
    8020555c:	0711                	addi	a4,a4,4 # 1004 <_entry-0x801feffc>
    8020555e:	f398                	sd	a4,32(a5)
    child->trapframe->a0 = 0;    // 子进程fork返回0
    80205560:	fe043783          	ld	a5,-32(s0)
    80205564:	63fc                	ld	a5,192(a5)
    80205566:	0607bc23          	sd	zero,120(a5)
    child->state = RUNNABLE;
    8020556a:	fe043783          	ld	a5,-32(s0)
    8020556e:	470d                	li	a4,3
    80205570:	c398                	sw	a4,0(a5)
    child->parent = parent;
    80205572:	fe043783          	ld	a5,-32(s0)
    80205576:	fe843703          	ld	a4,-24(s0)
    8020557a:	efd8                	sd	a4,152(a5)
    return child->pid;
    8020557c:	fe043783          	ld	a5,-32(s0)
    80205580:	43dc                	lw	a5,4(a5)
}
    80205582:	853e                	mv	a0,a5
    80205584:	70a2                	ld	ra,40(sp)
    80205586:	7402                	ld	s0,32(sp)
    80205588:	6145                	addi	sp,sp,48
    8020558a:	8082                	ret

000000008020558c <schedule>:
void schedule(void) {
    8020558c:	7179                	addi	sp,sp,-48
    8020558e:	f406                	sd	ra,40(sp)
    80205590:	f022                	sd	s0,32(sp)
    80205592:	1800                	addi	s0,sp,48
  struct cpu *c = mycpu();
    80205594:	fffff097          	auipc	ra,0xfffff
    80205598:	524080e7          	jalr	1316(ra) # 80204ab8 <mycpu>
    8020559c:	fea43023          	sd	a0,-32(s0)
    intr_on();
    802055a0:	fffff097          	auipc	ra,0xfffff
    802055a4:	41e080e7          	jalr	1054(ra) # 802049be <intr_on>
    for(int i = 0; i < PROC; i++) {
    802055a8:	fe042623          	sw	zero,-20(s0)
    802055ac:	a8bd                	j	8020562a <schedule+0x9e>
        struct proc *p = proc_table[i];
    802055ae:	00013717          	auipc	a4,0x13
    802055b2:	eda70713          	addi	a4,a4,-294 # 80218488 <proc_table>
    802055b6:	fec42783          	lw	a5,-20(s0)
    802055ba:	078e                	slli	a5,a5,0x3
    802055bc:	97ba                	add	a5,a5,a4
    802055be:	639c                	ld	a5,0(a5)
    802055c0:	fcf43c23          	sd	a5,-40(s0)
      	if(p->state == RUNNABLE) {
    802055c4:	fd843783          	ld	a5,-40(s0)
    802055c8:	439c                	lw	a5,0(a5)
    802055ca:	873e                	mv	a4,a5
    802055cc:	478d                	li	a5,3
    802055ce:	04f71963          	bne	a4,a5,80205620 <schedule+0x94>
			p->state = RUNNING;
    802055d2:	fd843783          	ld	a5,-40(s0)
    802055d6:	4711                	li	a4,4
    802055d8:	c398                	sw	a4,0(a5)
			c->proc = p;
    802055da:	fe043783          	ld	a5,-32(s0)
    802055de:	fd843703          	ld	a4,-40(s0)
    802055e2:	e398                	sd	a4,0(a5)
			current_proc = p;
    802055e4:	00013797          	auipc	a5,0x13
    802055e8:	ae478793          	addi	a5,a5,-1308 # 802180c8 <current_proc>
    802055ec:	fd843703          	ld	a4,-40(s0)
    802055f0:	e398                	sd	a4,0(a5)
			swtch(&c->context, &p->context);
    802055f2:	fe043783          	ld	a5,-32(s0)
    802055f6:	00878713          	addi	a4,a5,8
    802055fa:	fd843783          	ld	a5,-40(s0)
    802055fe:	07c1                	addi	a5,a5,16
    80205600:	85be                	mv	a1,a5
    80205602:	853a                	mv	a0,a4
    80205604:	fffff097          	auipc	ra,0xfffff
    80205608:	31c080e7          	jalr	796(ra) # 80204920 <swtch>
			c->proc = 0;
    8020560c:	fe043783          	ld	a5,-32(s0)
    80205610:	0007b023          	sd	zero,0(a5)
			current_proc = 0;
    80205614:	00013797          	auipc	a5,0x13
    80205618:	ab478793          	addi	a5,a5,-1356 # 802180c8 <current_proc>
    8020561c:	0007b023          	sd	zero,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205620:	fec42783          	lw	a5,-20(s0)
    80205624:	2785                	addiw	a5,a5,1
    80205626:	fef42623          	sw	a5,-20(s0)
    8020562a:	fec42783          	lw	a5,-20(s0)
    8020562e:	0007871b          	sext.w	a4,a5
    80205632:	47fd                	li	a5,31
    80205634:	f6e7dde3          	bge	a5,a4,802055ae <schedule+0x22>
    intr_on();
    80205638:	b7a5                	j	802055a0 <schedule+0x14>

000000008020563a <yield>:
void yield(void) {
    8020563a:	1101                	addi	sp,sp,-32
    8020563c:	ec06                	sd	ra,24(sp)
    8020563e:	e822                	sd	s0,16(sp)
    80205640:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80205642:	fffff097          	auipc	ra,0xfffff
    80205646:	45e080e7          	jalr	1118(ra) # 80204aa0 <myproc>
    8020564a:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    8020564e:	fe843783          	ld	a5,-24(s0)
    80205652:	c3d1                	beqz	a5,802056d6 <yield+0x9c>
    intr_off();
    80205654:	fffff097          	auipc	ra,0xfffff
    80205658:	394080e7          	jalr	916(ra) # 802049e8 <intr_off>
    struct cpu *c = mycpu();
    8020565c:	fffff097          	auipc	ra,0xfffff
    80205660:	45c080e7          	jalr	1116(ra) # 80204ab8 <mycpu>
    80205664:	fea43023          	sd	a0,-32(s0)
    p->state = RUNNABLE;
    80205668:	fe843783          	ld	a5,-24(s0)
    8020566c:	470d                	li	a4,3
    8020566e:	c398                	sw	a4,0(a5)
    current_proc = 0;
    80205670:	00013797          	auipc	a5,0x13
    80205674:	a5878793          	addi	a5,a5,-1448 # 802180c8 <current_proc>
    80205678:	0007b023          	sd	zero,0(a5)
    c->proc = 0;
    8020567c:	fe043783          	ld	a5,-32(s0)
    80205680:	0007b023          	sd	zero,0(a5)
    swtch(&p->context, &c->context);
    80205684:	fe843783          	ld	a5,-24(s0)
    80205688:	01078713          	addi	a4,a5,16
    8020568c:	fe043783          	ld	a5,-32(s0)
    80205690:	07a1                	addi	a5,a5,8
    80205692:	85be                	mv	a1,a5
    80205694:	853a                	mv	a0,a4
    80205696:	fffff097          	auipc	ra,0xfffff
    8020569a:	28a080e7          	jalr	650(ra) # 80204920 <swtch>
    intr_on();
    8020569e:	fffff097          	auipc	ra,0xfffff
    802056a2:	320080e7          	jalr	800(ra) # 802049be <intr_on>
	if (p->killed) {
    802056a6:	fe843783          	ld	a5,-24(s0)
    802056aa:	0807a783          	lw	a5,128(a5)
    802056ae:	c78d                	beqz	a5,802056d8 <yield+0x9e>
        printf("[yield] Process PID %d killed during yield\n", p->pid);
    802056b0:	fe843783          	ld	a5,-24(s0)
    802056b4:	43dc                	lw	a5,4(a5)
    802056b6:	85be                	mv	a1,a5
    802056b8:	0000e517          	auipc	a0,0xe
    802056bc:	f8850513          	addi	a0,a0,-120 # 80213640 <simple_user_task_bin+0x260>
    802056c0:	ffffb097          	auipc	ra,0xffffb
    802056c4:	5d4080e7          	jalr	1492(ra) # 80200c94 <printf>
        exit_proc(SYS_kill);
    802056c8:	08100513          	li	a0,129
    802056cc:	00000097          	auipc	ra,0x0
    802056d0:	17c080e7          	jalr	380(ra) # 80205848 <exit_proc>
        return;
    802056d4:	a011                	j	802056d8 <yield+0x9e>
        return;
    802056d6:	0001                	nop
}
    802056d8:	60e2                	ld	ra,24(sp)
    802056da:	6442                	ld	s0,16(sp)
    802056dc:	6105                	addi	sp,sp,32
    802056de:	8082                	ret

00000000802056e0 <sleep>:
void sleep(void *chan){
    802056e0:	7179                	addi	sp,sp,-48
    802056e2:	f406                	sd	ra,40(sp)
    802056e4:	f022                	sd	s0,32(sp)
    802056e6:	1800                	addi	s0,sp,48
    802056e8:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = myproc();
    802056ec:	fffff097          	auipc	ra,0xfffff
    802056f0:	3b4080e7          	jalr	948(ra) # 80204aa0 <myproc>
    802056f4:	fea43423          	sd	a0,-24(s0)
    struct cpu *c = mycpu();
    802056f8:	fffff097          	auipc	ra,0xfffff
    802056fc:	3c0080e7          	jalr	960(ra) # 80204ab8 <mycpu>
    80205700:	fea43023          	sd	a0,-32(s0)
    p->context.ra = ra;
    80205704:	8706                	mv	a4,ra
    80205706:	fe843783          	ld	a5,-24(s0)
    8020570a:	eb98                	sd	a4,16(a5)
    p->chan = chan;
    8020570c:	fe843783          	ld	a5,-24(s0)
    80205710:	fd843703          	ld	a4,-40(s0)
    80205714:	f3d8                	sd	a4,160(a5)
    p->state = SLEEPING;
    80205716:	fe843783          	ld	a5,-24(s0)
    8020571a:	4709                	li	a4,2
    8020571c:	c398                	sw	a4,0(a5)
    swtch(&p->context, &c->context);
    8020571e:	fe843783          	ld	a5,-24(s0)
    80205722:	01078713          	addi	a4,a5,16
    80205726:	fe043783          	ld	a5,-32(s0)
    8020572a:	07a1                	addi	a5,a5,8
    8020572c:	85be                	mv	a1,a5
    8020572e:	853a                	mv	a0,a4
    80205730:	fffff097          	auipc	ra,0xfffff
    80205734:	1f0080e7          	jalr	496(ra) # 80204920 <swtch>
    p->chan = 0;
    80205738:	fe843783          	ld	a5,-24(s0)
    8020573c:	0a07b023          	sd	zero,160(a5)
	if(p->killed){
    80205740:	fe843783          	ld	a5,-24(s0)
    80205744:	0807a783          	lw	a5,128(a5)
    80205748:	c39d                	beqz	a5,8020576e <sleep+0x8e>
		printf("[sleep] Process PID %d killed when wakeup\n", p->pid);
    8020574a:	fe843783          	ld	a5,-24(s0)
    8020574e:	43dc                	lw	a5,4(a5)
    80205750:	85be                	mv	a1,a5
    80205752:	0000e517          	auipc	a0,0xe
    80205756:	f1e50513          	addi	a0,a0,-226 # 80213670 <simple_user_task_bin+0x290>
    8020575a:	ffffb097          	auipc	ra,0xffffb
    8020575e:	53a080e7          	jalr	1338(ra) # 80200c94 <printf>
		exit_proc(SYS_kill);
    80205762:	08100513          	li	a0,129
    80205766:	00000097          	auipc	ra,0x0
    8020576a:	0e2080e7          	jalr	226(ra) # 80205848 <exit_proc>
}
    8020576e:	0001                	nop
    80205770:	70a2                	ld	ra,40(sp)
    80205772:	7402                	ld	s0,32(sp)
    80205774:	6145                	addi	sp,sp,48
    80205776:	8082                	ret

0000000080205778 <wakeup>:
void wakeup(void *chan) {
    80205778:	7179                	addi	sp,sp,-48
    8020577a:	f422                	sd	s0,40(sp)
    8020577c:	1800                	addi	s0,sp,48
    8020577e:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < PROC; i++) {
    80205782:	fe042623          	sw	zero,-20(s0)
    80205786:	a099                	j	802057cc <wakeup+0x54>
        struct proc *p = proc_table[i];
    80205788:	00013717          	auipc	a4,0x13
    8020578c:	d0070713          	addi	a4,a4,-768 # 80218488 <proc_table>
    80205790:	fec42783          	lw	a5,-20(s0)
    80205794:	078e                	slli	a5,a5,0x3
    80205796:	97ba                	add	a5,a5,a4
    80205798:	639c                	ld	a5,0(a5)
    8020579a:	fef43023          	sd	a5,-32(s0)
        if(p->state == SLEEPING && p->chan == chan) {
    8020579e:	fe043783          	ld	a5,-32(s0)
    802057a2:	439c                	lw	a5,0(a5)
    802057a4:	873e                	mv	a4,a5
    802057a6:	4789                	li	a5,2
    802057a8:	00f71d63          	bne	a4,a5,802057c2 <wakeup+0x4a>
    802057ac:	fe043783          	ld	a5,-32(s0)
    802057b0:	73dc                	ld	a5,160(a5)
    802057b2:	fd843703          	ld	a4,-40(s0)
    802057b6:	00f71663          	bne	a4,a5,802057c2 <wakeup+0x4a>
            p->state = RUNNABLE;
    802057ba:	fe043783          	ld	a5,-32(s0)
    802057be:	470d                	li	a4,3
    802057c0:	c398                	sw	a4,0(a5)
    for(int i = 0; i < PROC; i++) {
    802057c2:	fec42783          	lw	a5,-20(s0)
    802057c6:	2785                	addiw	a5,a5,1
    802057c8:	fef42623          	sw	a5,-20(s0)
    802057cc:	fec42783          	lw	a5,-20(s0)
    802057d0:	0007871b          	sext.w	a4,a5
    802057d4:	47fd                	li	a5,31
    802057d6:	fae7d9e3          	bge	a5,a4,80205788 <wakeup+0x10>
}
    802057da:	0001                	nop
    802057dc:	0001                	nop
    802057de:	7422                	ld	s0,40(sp)
    802057e0:	6145                	addi	sp,sp,48
    802057e2:	8082                	ret

00000000802057e4 <kill_proc>:
void kill_proc(int pid){
    802057e4:	7179                	addi	sp,sp,-48
    802057e6:	f422                	sd	s0,40(sp)
    802057e8:	1800                	addi	s0,sp,48
    802057ea:	87aa                	mv	a5,a0
    802057ec:	fcf42e23          	sw	a5,-36(s0)
	for(int i=0;i<PROC;i++){
    802057f0:	fe042623          	sw	zero,-20(s0)
    802057f4:	a83d                	j	80205832 <kill_proc+0x4e>
		struct proc *p = proc_table[i];
    802057f6:	00013717          	auipc	a4,0x13
    802057fa:	c9270713          	addi	a4,a4,-878 # 80218488 <proc_table>
    802057fe:	fec42783          	lw	a5,-20(s0)
    80205802:	078e                	slli	a5,a5,0x3
    80205804:	97ba                	add	a5,a5,a4
    80205806:	639c                	ld	a5,0(a5)
    80205808:	fef43023          	sd	a5,-32(s0)
		if(pid == p->pid){
    8020580c:	fe043783          	ld	a5,-32(s0)
    80205810:	43d8                	lw	a4,4(a5)
    80205812:	fdc42783          	lw	a5,-36(s0)
    80205816:	2781                	sext.w	a5,a5
    80205818:	00e79863          	bne	a5,a4,80205828 <kill_proc+0x44>
			p->killed = 1;
    8020581c:	fe043783          	ld	a5,-32(s0)
    80205820:	4705                	li	a4,1
    80205822:	08e7a023          	sw	a4,128(a5)
			break;
    80205826:	a829                	j	80205840 <kill_proc+0x5c>
	for(int i=0;i<PROC;i++){
    80205828:	fec42783          	lw	a5,-20(s0)
    8020582c:	2785                	addiw	a5,a5,1
    8020582e:	fef42623          	sw	a5,-20(s0)
    80205832:	fec42783          	lw	a5,-20(s0)
    80205836:	0007871b          	sext.w	a4,a5
    8020583a:	47fd                	li	a5,31
    8020583c:	fae7dde3          	bge	a5,a4,802057f6 <kill_proc+0x12>
	return;
    80205840:	0001                	nop
}
    80205842:	7422                	ld	s0,40(sp)
    80205844:	6145                	addi	sp,sp,48
    80205846:	8082                	ret

0000000080205848 <exit_proc>:
void exit_proc(int status) {
    80205848:	7179                	addi	sp,sp,-48
    8020584a:	f406                	sd	ra,40(sp)
    8020584c:	f022                	sd	s0,32(sp)
    8020584e:	1800                	addi	s0,sp,48
    80205850:	87aa                	mv	a5,a0
    80205852:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    80205856:	fffff097          	auipc	ra,0xfffff
    8020585a:	24a080e7          	jalr	586(ra) # 80204aa0 <myproc>
    8020585e:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205862:	fe843783          	ld	a5,-24(s0)
    80205866:	eb89                	bnez	a5,80205878 <exit_proc+0x30>
        panic("exit_proc: no current process");
    80205868:	0000e517          	auipc	a0,0xe
    8020586c:	e3850513          	addi	a0,a0,-456 # 802136a0 <simple_user_task_bin+0x2c0>
    80205870:	ffffc097          	auipc	ra,0xffffc
    80205874:	e70080e7          	jalr	-400(ra) # 802016e0 <panic>
    p->exit_status = status;
    80205878:	fe843783          	ld	a5,-24(s0)
    8020587c:	fdc42703          	lw	a4,-36(s0)
    80205880:	08e7a223          	sw	a4,132(a5)
    if (!p->parent) {
    80205884:	fe843783          	ld	a5,-24(s0)
    80205888:	6fdc                	ld	a5,152(a5)
    8020588a:	e789                	bnez	a5,80205894 <exit_proc+0x4c>
        shutdown();
    8020588c:	fffff097          	auipc	ra,0xfffff
    80205890:	1ea080e7          	jalr	490(ra) # 80204a76 <shutdown>
    p->state = ZOMBIE;
    80205894:	fe843783          	ld	a5,-24(s0)
    80205898:	4715                	li	a4,5
    8020589a:	c398                	sw	a4,0(a5)
    wakeup((void*)p->parent);
    8020589c:	fe843783          	ld	a5,-24(s0)
    802058a0:	6fdc                	ld	a5,152(a5)
    802058a2:	853e                	mv	a0,a5
    802058a4:	00000097          	auipc	ra,0x0
    802058a8:	ed4080e7          	jalr	-300(ra) # 80205778 <wakeup>
    current_proc = 0;
    802058ac:	00013797          	auipc	a5,0x13
    802058b0:	81c78793          	addi	a5,a5,-2020 # 802180c8 <current_proc>
    802058b4:	0007b023          	sd	zero,0(a5)
    if (mycpu())
    802058b8:	fffff097          	auipc	ra,0xfffff
    802058bc:	200080e7          	jalr	512(ra) # 80204ab8 <mycpu>
    802058c0:	87aa                	mv	a5,a0
    802058c2:	cb81                	beqz	a5,802058d2 <exit_proc+0x8a>
        mycpu()->proc = 0;
    802058c4:	fffff097          	auipc	ra,0xfffff
    802058c8:	1f4080e7          	jalr	500(ra) # 80204ab8 <mycpu>
    802058cc:	87aa                	mv	a5,a0
    802058ce:	0007b023          	sd	zero,0(a5)
    struct cpu *c = mycpu();
    802058d2:	fffff097          	auipc	ra,0xfffff
    802058d6:	1e6080e7          	jalr	486(ra) # 80204ab8 <mycpu>
    802058da:	fea43023          	sd	a0,-32(s0)
    swtch(&p->context, &c->context);
    802058de:	fe843783          	ld	a5,-24(s0)
    802058e2:	01078713          	addi	a4,a5,16
    802058e6:	fe043783          	ld	a5,-32(s0)
    802058ea:	07a1                	addi	a5,a5,8
    802058ec:	85be                	mv	a1,a5
    802058ee:	853a                	mv	a0,a4
    802058f0:	fffff097          	auipc	ra,0xfffff
    802058f4:	030080e7          	jalr	48(ra) # 80204920 <swtch>
    panic("exit_proc should not return after schedule");
    802058f8:	0000e517          	auipc	a0,0xe
    802058fc:	dc850513          	addi	a0,a0,-568 # 802136c0 <simple_user_task_bin+0x2e0>
    80205900:	ffffc097          	auipc	ra,0xffffc
    80205904:	de0080e7          	jalr	-544(ra) # 802016e0 <panic>
}
    80205908:	0001                	nop
    8020590a:	70a2                	ld	ra,40(sp)
    8020590c:	7402                	ld	s0,32(sp)
    8020590e:	6145                	addi	sp,sp,48
    80205910:	8082                	ret

0000000080205912 <wait_proc>:
int wait_proc(int *status) {
    80205912:	711d                	addi	sp,sp,-96
    80205914:	ec86                	sd	ra,88(sp)
    80205916:	e8a2                	sd	s0,80(sp)
    80205918:	1080                	addi	s0,sp,96
    8020591a:	faa43423          	sd	a0,-88(s0)
    struct proc *p = myproc();
    8020591e:	fffff097          	auipc	ra,0xfffff
    80205922:	182080e7          	jalr	386(ra) # 80204aa0 <myproc>
    80205926:	fca43023          	sd	a0,-64(s0)
    if (p == 0) {
    8020592a:	fc043783          	ld	a5,-64(s0)
    8020592e:	eb99                	bnez	a5,80205944 <wait_proc+0x32>
        printf("Warning: wait_proc called with no current process\n");
    80205930:	0000e517          	auipc	a0,0xe
    80205934:	dc050513          	addi	a0,a0,-576 # 802136f0 <simple_user_task_bin+0x310>
    80205938:	ffffb097          	auipc	ra,0xffffb
    8020593c:	35c080e7          	jalr	860(ra) # 80200c94 <printf>
        return -1;
    80205940:	57fd                	li	a5,-1
    80205942:	aa91                	j	80205a96 <wait_proc+0x184>
        intr_off();
    80205944:	fffff097          	auipc	ra,0xfffff
    80205948:	0a4080e7          	jalr	164(ra) # 802049e8 <intr_off>
        int found_zombie = 0;
    8020594c:	fe042623          	sw	zero,-20(s0)
        int zombie_pid = 0;
    80205950:	fe042423          	sw	zero,-24(s0)
        int zombie_status = 0;
    80205954:	fe042223          	sw	zero,-28(s0)
        struct proc *zombie_child = 0;
    80205958:	fc043c23          	sd	zero,-40(s0)
        
        // 先查找ZOMBIE状态的子进程
        for (int i = 0; i < PROC; i++) {
    8020595c:	fc042a23          	sw	zero,-44(s0)
    80205960:	a095                	j	802059c4 <wait_proc+0xb2>
            struct proc *child = proc_table[i];
    80205962:	00013717          	auipc	a4,0x13
    80205966:	b2670713          	addi	a4,a4,-1242 # 80218488 <proc_table>
    8020596a:	fd442783          	lw	a5,-44(s0)
    8020596e:	078e                	slli	a5,a5,0x3
    80205970:	97ba                	add	a5,a5,a4
    80205972:	639c                	ld	a5,0(a5)
    80205974:	faf43c23          	sd	a5,-72(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    80205978:	fb843783          	ld	a5,-72(s0)
    8020597c:	439c                	lw	a5,0(a5)
    8020597e:	873e                	mv	a4,a5
    80205980:	4795                	li	a5,5
    80205982:	02f71c63          	bne	a4,a5,802059ba <wait_proc+0xa8>
    80205986:	fb843783          	ld	a5,-72(s0)
    8020598a:	6fdc                	ld	a5,152(a5)
    8020598c:	fc043703          	ld	a4,-64(s0)
    80205990:	02f71563          	bne	a4,a5,802059ba <wait_proc+0xa8>
                found_zombie = 1;
    80205994:	4785                	li	a5,1
    80205996:	fef42623          	sw	a5,-20(s0)
                zombie_pid = child->pid;
    8020599a:	fb843783          	ld	a5,-72(s0)
    8020599e:	43dc                	lw	a5,4(a5)
    802059a0:	fef42423          	sw	a5,-24(s0)
                zombie_status = child->exit_status;
    802059a4:	fb843783          	ld	a5,-72(s0)
    802059a8:	0847a783          	lw	a5,132(a5)
    802059ac:	fef42223          	sw	a5,-28(s0)
                zombie_child = child;
    802059b0:	fb843783          	ld	a5,-72(s0)
    802059b4:	fcf43c23          	sd	a5,-40(s0)
                break;
    802059b8:	a829                	j	802059d2 <wait_proc+0xc0>
        for (int i = 0; i < PROC; i++) {
    802059ba:	fd442783          	lw	a5,-44(s0)
    802059be:	2785                	addiw	a5,a5,1
    802059c0:	fcf42a23          	sw	a5,-44(s0)
    802059c4:	fd442783          	lw	a5,-44(s0)
    802059c8:	0007871b          	sext.w	a4,a5
    802059cc:	47fd                	li	a5,31
    802059ce:	f8e7dae3          	bge	a5,a4,80205962 <wait_proc+0x50>
            }
        }
        
        if (found_zombie) {
    802059d2:	fec42783          	lw	a5,-20(s0)
    802059d6:	2781                	sext.w	a5,a5
    802059d8:	cb85                	beqz	a5,80205a08 <wait_proc+0xf6>
            if (status)
    802059da:	fa843783          	ld	a5,-88(s0)
    802059de:	c791                	beqz	a5,802059ea <wait_proc+0xd8>
                *status = zombie_status;
    802059e0:	fa843783          	ld	a5,-88(s0)
    802059e4:	fe442703          	lw	a4,-28(s0)
    802059e8:	c398                	sw	a4,0(a5)

            free_proc(zombie_child);
    802059ea:	fd843503          	ld	a0,-40(s0)
    802059ee:	fffff097          	auipc	ra,0xfffff
    802059f2:	632080e7          	jalr	1586(ra) # 80205020 <free_proc>
            zombie_child = NULL;
    802059f6:	fc043c23          	sd	zero,-40(s0)
            intr_on();
    802059fa:	fffff097          	auipc	ra,0xfffff
    802059fe:	fc4080e7          	jalr	-60(ra) # 802049be <intr_on>
            return zombie_pid;
    80205a02:	fe842783          	lw	a5,-24(s0)
    80205a06:	a841                	j	80205a96 <wait_proc+0x184>
        }
        
        // 检查是否有任何活跃的子进程（非ZOMBIE状态）
        int havekids = 0;
    80205a08:	fc042823          	sw	zero,-48(s0)
        for (int i = 0; i < PROC; i++) {
    80205a0c:	fc042623          	sw	zero,-52(s0)
    80205a10:	a0b9                	j	80205a5e <wait_proc+0x14c>
            struct proc *child = proc_table[i];
    80205a12:	00013717          	auipc	a4,0x13
    80205a16:	a7670713          	addi	a4,a4,-1418 # 80218488 <proc_table>
    80205a1a:	fcc42783          	lw	a5,-52(s0)
    80205a1e:	078e                	slli	a5,a5,0x3
    80205a20:	97ba                	add	a5,a5,a4
    80205a22:	639c                	ld	a5,0(a5)
    80205a24:	faf43823          	sd	a5,-80(s0)
            if (child->state != UNUSED && child->state != ZOMBIE && child->parent == p) {
    80205a28:	fb043783          	ld	a5,-80(s0)
    80205a2c:	439c                	lw	a5,0(a5)
    80205a2e:	c39d                	beqz	a5,80205a54 <wait_proc+0x142>
    80205a30:	fb043783          	ld	a5,-80(s0)
    80205a34:	439c                	lw	a5,0(a5)
    80205a36:	873e                	mv	a4,a5
    80205a38:	4795                	li	a5,5
    80205a3a:	00f70d63          	beq	a4,a5,80205a54 <wait_proc+0x142>
    80205a3e:	fb043783          	ld	a5,-80(s0)
    80205a42:	6fdc                	ld	a5,152(a5)
    80205a44:	fc043703          	ld	a4,-64(s0)
    80205a48:	00f71663          	bne	a4,a5,80205a54 <wait_proc+0x142>
                havekids = 1;
    80205a4c:	4785                	li	a5,1
    80205a4e:	fcf42823          	sw	a5,-48(s0)
                break;
    80205a52:	a829                	j	80205a6c <wait_proc+0x15a>
        for (int i = 0; i < PROC; i++) {
    80205a54:	fcc42783          	lw	a5,-52(s0)
    80205a58:	2785                	addiw	a5,a5,1
    80205a5a:	fcf42623          	sw	a5,-52(s0)
    80205a5e:	fcc42783          	lw	a5,-52(s0)
    80205a62:	0007871b          	sext.w	a4,a5
    80205a66:	47fd                	li	a5,31
    80205a68:	fae7d5e3          	bge	a5,a4,80205a12 <wait_proc+0x100>
            }
        }
        
        if (!havekids) {
    80205a6c:	fd042783          	lw	a5,-48(s0)
    80205a70:	2781                	sext.w	a5,a5
    80205a72:	e799                	bnez	a5,80205a80 <wait_proc+0x16e>
            intr_on();
    80205a74:	fffff097          	auipc	ra,0xfffff
    80205a78:	f4a080e7          	jalr	-182(ra) # 802049be <intr_on>
            return -1;
    80205a7c:	57fd                	li	a5,-1
    80205a7e:	a821                	j	80205a96 <wait_proc+0x184>
        }
        
        // 有活跃子进程但没有僵尸子进程，进入睡眠等待
		intr_on();
    80205a80:	fffff097          	auipc	ra,0xfffff
    80205a84:	f3e080e7          	jalr	-194(ra) # 802049be <intr_on>
        sleep((void*)p);
    80205a88:	fc043503          	ld	a0,-64(s0)
    80205a8c:	00000097          	auipc	ra,0x0
    80205a90:	c54080e7          	jalr	-940(ra) # 802056e0 <sleep>
    while (1) {
    80205a94:	bd45                	j	80205944 <wait_proc+0x32>
    }
}
    80205a96:	853e                	mv	a0,a5
    80205a98:	60e6                	ld	ra,88(sp)
    80205a9a:	6446                	ld	s0,80(sp)
    80205a9c:	6125                	addi	sp,sp,96
    80205a9e:	8082                	ret

0000000080205aa0 <print_proc_table>:

void print_proc_table(void) {
    80205aa0:	715d                	addi	sp,sp,-80
    80205aa2:	e486                	sd	ra,72(sp)
    80205aa4:	e0a2                	sd	s0,64(sp)
    80205aa6:	0880                	addi	s0,sp,80
    int count = 0;
    80205aa8:	fe042623          	sw	zero,-20(s0)
    printf("PID  TYPE STATUS     PPID   FUNC_ADDR      STACK_ADDR    \n");
    80205aac:	0000e517          	auipc	a0,0xe
    80205ab0:	c7c50513          	addi	a0,a0,-900 # 80213728 <simple_user_task_bin+0x348>
    80205ab4:	ffffb097          	auipc	ra,0xffffb
    80205ab8:	1e0080e7          	jalr	480(ra) # 80200c94 <printf>
    printf("----------------------------------------------------------\n");
    80205abc:	0000e517          	auipc	a0,0xe
    80205ac0:	cac50513          	addi	a0,a0,-852 # 80213768 <simple_user_task_bin+0x388>
    80205ac4:	ffffb097          	auipc	ra,0xffffb
    80205ac8:	1d0080e7          	jalr	464(ra) # 80200c94 <printf>
    for(int i = 0; i < PROC; i++) {
    80205acc:	fe042423          	sw	zero,-24(s0)
    80205ad0:	a2a9                	j	80205c1a <print_proc_table+0x17a>
        struct proc *p = proc_table[i];
    80205ad2:	00013717          	auipc	a4,0x13
    80205ad6:	9b670713          	addi	a4,a4,-1610 # 80218488 <proc_table>
    80205ada:	fe842783          	lw	a5,-24(s0)
    80205ade:	078e                	slli	a5,a5,0x3
    80205ae0:	97ba                	add	a5,a5,a4
    80205ae2:	639c                	ld	a5,0(a5)
    80205ae4:	fcf43c23          	sd	a5,-40(s0)
        if(p->state != UNUSED) {
    80205ae8:	fd843783          	ld	a5,-40(s0)
    80205aec:	439c                	lw	a5,0(a5)
    80205aee:	12078163          	beqz	a5,80205c10 <print_proc_table+0x170>
            count++;
    80205af2:	fec42783          	lw	a5,-20(s0)
    80205af6:	2785                	addiw	a5,a5,1
    80205af8:	fef42623          	sw	a5,-20(s0)
            const char *type = (p->is_user ? "USR" : "SYS");
    80205afc:	fd843783          	ld	a5,-40(s0)
    80205b00:	0a87a783          	lw	a5,168(a5)
    80205b04:	c791                	beqz	a5,80205b10 <print_proc_table+0x70>
    80205b06:	0000e797          	auipc	a5,0xe
    80205b0a:	ca278793          	addi	a5,a5,-862 # 802137a8 <simple_user_task_bin+0x3c8>
    80205b0e:	a029                	j	80205b18 <print_proc_table+0x78>
    80205b10:	0000e797          	auipc	a5,0xe
    80205b14:	ca078793          	addi	a5,a5,-864 # 802137b0 <simple_user_task_bin+0x3d0>
    80205b18:	fcf43823          	sd	a5,-48(s0)
            const char *status;
            switch(p->state) {
    80205b1c:	fd843783          	ld	a5,-40(s0)
    80205b20:	439c                	lw	a5,0(a5)
    80205b22:	86be                	mv	a3,a5
    80205b24:	4715                	li	a4,5
    80205b26:	06d76c63          	bltu	a4,a3,80205b9e <print_proc_table+0xfe>
    80205b2a:	00279713          	slli	a4,a5,0x2
    80205b2e:	0000e797          	auipc	a5,0xe
    80205b32:	d0a78793          	addi	a5,a5,-758 # 80213838 <simple_user_task_bin+0x458>
    80205b36:	97ba                	add	a5,a5,a4
    80205b38:	439c                	lw	a5,0(a5)
    80205b3a:	0007871b          	sext.w	a4,a5
    80205b3e:	0000e797          	auipc	a5,0xe
    80205b42:	cfa78793          	addi	a5,a5,-774 # 80213838 <simple_user_task_bin+0x458>
    80205b46:	97ba                	add	a5,a5,a4
    80205b48:	8782                	jr	a5
                case UNUSED:   status = "UNUSED"; break;
    80205b4a:	0000e797          	auipc	a5,0xe
    80205b4e:	c6e78793          	addi	a5,a5,-914 # 802137b8 <simple_user_task_bin+0x3d8>
    80205b52:	fef43023          	sd	a5,-32(s0)
    80205b56:	a899                	j	80205bac <print_proc_table+0x10c>
                case USED:     status = "USED"; break;
    80205b58:	0000e797          	auipc	a5,0xe
    80205b5c:	c6878793          	addi	a5,a5,-920 # 802137c0 <simple_user_task_bin+0x3e0>
    80205b60:	fef43023          	sd	a5,-32(s0)
    80205b64:	a0a1                	j	80205bac <print_proc_table+0x10c>
                case SLEEPING: status = "SLEEP"; break;
    80205b66:	0000e797          	auipc	a5,0xe
    80205b6a:	c6278793          	addi	a5,a5,-926 # 802137c8 <simple_user_task_bin+0x3e8>
    80205b6e:	fef43023          	sd	a5,-32(s0)
    80205b72:	a82d                	j	80205bac <print_proc_table+0x10c>
                case RUNNABLE: status = "RUNNABLE"; break;
    80205b74:	0000e797          	auipc	a5,0xe
    80205b78:	c5c78793          	addi	a5,a5,-932 # 802137d0 <simple_user_task_bin+0x3f0>
    80205b7c:	fef43023          	sd	a5,-32(s0)
    80205b80:	a035                	j	80205bac <print_proc_table+0x10c>
                case RUNNING:  status = "RUNNING"; break;
    80205b82:	0000e797          	auipc	a5,0xe
    80205b86:	c5e78793          	addi	a5,a5,-930 # 802137e0 <simple_user_task_bin+0x400>
    80205b8a:	fef43023          	sd	a5,-32(s0)
    80205b8e:	a839                	j	80205bac <print_proc_table+0x10c>
                case ZOMBIE:   status = "ZOMBIE"; break;
    80205b90:	0000e797          	auipc	a5,0xe
    80205b94:	c5878793          	addi	a5,a5,-936 # 802137e8 <simple_user_task_bin+0x408>
    80205b98:	fef43023          	sd	a5,-32(s0)
    80205b9c:	a801                	j	80205bac <print_proc_table+0x10c>
                default:       status = "UNKNOWN"; break;
    80205b9e:	0000e797          	auipc	a5,0xe
    80205ba2:	c5278793          	addi	a5,a5,-942 # 802137f0 <simple_user_task_bin+0x410>
    80205ba6:	fef43023          	sd	a5,-32(s0)
    80205baa:	0001                	nop
            }
            int ppid = p->parent ? p->parent->pid : -1;
    80205bac:	fd843783          	ld	a5,-40(s0)
    80205bb0:	6fdc                	ld	a5,152(a5)
    80205bb2:	c791                	beqz	a5,80205bbe <print_proc_table+0x11e>
    80205bb4:	fd843783          	ld	a5,-40(s0)
    80205bb8:	6fdc                	ld	a5,152(a5)
    80205bba:	43dc                	lw	a5,4(a5)
    80205bbc:	a011                	j	80205bc0 <print_proc_table+0x120>
    80205bbe:	57fd                	li	a5,-1
    80205bc0:	fcf42623          	sw	a5,-52(s0)
            unsigned long func_addr = p->trapframe ? p->trapframe->epc : 0;
    80205bc4:	fd843783          	ld	a5,-40(s0)
    80205bc8:	63fc                	ld	a5,192(a5)
    80205bca:	c791                	beqz	a5,80205bd6 <print_proc_table+0x136>
    80205bcc:	fd843783          	ld	a5,-40(s0)
    80205bd0:	63fc                	ld	a5,192(a5)
    80205bd2:	739c                	ld	a5,32(a5)
    80205bd4:	a011                	j	80205bd8 <print_proc_table+0x138>
    80205bd6:	4781                	li	a5,0
    80205bd8:	fcf43023          	sd	a5,-64(s0)
            unsigned long stack_addr = p->kstack;
    80205bdc:	fd843783          	ld	a5,-40(s0)
    80205be0:	679c                	ld	a5,8(a5)
    80205be2:	faf43c23          	sd	a5,-72(s0)
            printf("%2d  %3s %8s %4d 0x%012lx 0x%012lx\n",
    80205be6:	fd843783          	ld	a5,-40(s0)
    80205bea:	43cc                	lw	a1,4(a5)
    80205bec:	fcc42703          	lw	a4,-52(s0)
    80205bf0:	fb843803          	ld	a6,-72(s0)
    80205bf4:	fc043783          	ld	a5,-64(s0)
    80205bf8:	fe043683          	ld	a3,-32(s0)
    80205bfc:	fd043603          	ld	a2,-48(s0)
    80205c00:	0000e517          	auipc	a0,0xe
    80205c04:	bf850513          	addi	a0,a0,-1032 # 802137f8 <simple_user_task_bin+0x418>
    80205c08:	ffffb097          	auipc	ra,0xffffb
    80205c0c:	08c080e7          	jalr	140(ra) # 80200c94 <printf>
    for(int i = 0; i < PROC; i++) {
    80205c10:	fe842783          	lw	a5,-24(s0)
    80205c14:	2785                	addiw	a5,a5,1
    80205c16:	fef42423          	sw	a5,-24(s0)
    80205c1a:	fe842783          	lw	a5,-24(s0)
    80205c1e:	0007871b          	sext.w	a4,a5
    80205c22:	47fd                	li	a5,31
    80205c24:	eae7d7e3          	bge	a5,a4,80205ad2 <print_proc_table+0x32>
                p->pid, type, status, ppid, func_addr, stack_addr);
        }
    }
    printf("----------------------------------------------------------\n");
    80205c28:	0000e517          	auipc	a0,0xe
    80205c2c:	b4050513          	addi	a0,a0,-1216 # 80213768 <simple_user_task_bin+0x388>
    80205c30:	ffffb097          	auipc	ra,0xffffb
    80205c34:	064080e7          	jalr	100(ra) # 80200c94 <printf>
    printf("%d active processes\n", count);
    80205c38:	fec42783          	lw	a5,-20(s0)
    80205c3c:	85be                	mv	a1,a5
    80205c3e:	0000e517          	auipc	a0,0xe
    80205c42:	be250513          	addi	a0,a0,-1054 # 80213820 <simple_user_task_bin+0x440>
    80205c46:	ffffb097          	auipc	ra,0xffffb
    80205c4a:	04e080e7          	jalr	78(ra) # 80200c94 <printf>
}
    80205c4e:	0001                	nop
    80205c50:	60a6                	ld	ra,72(sp)
    80205c52:	6406                	ld	s0,64(sp)
    80205c54:	6161                	addi	sp,sp,80
    80205c56:	8082                	ret

0000000080205c58 <get_proc>:

struct proc* get_proc(int pid){
    80205c58:	7179                	addi	sp,sp,-48
    80205c5a:	f422                	sd	s0,40(sp)
    80205c5c:	1800                	addi	s0,sp,48
    80205c5e:	87aa                	mv	a5,a0
    80205c60:	fcf42e23          	sw	a5,-36(s0)
	    // 检查 PID 是否有效
    if (pid < 0 || pid >= PROC) {
    80205c64:	fdc42783          	lw	a5,-36(s0)
    80205c68:	2781                	sext.w	a5,a5
    80205c6a:	0007c963          	bltz	a5,80205c7c <get_proc+0x24>
    80205c6e:	fdc42783          	lw	a5,-36(s0)
    80205c72:	0007871b          	sext.w	a4,a5
    80205c76:	47fd                	li	a5,31
    80205c78:	00e7d463          	bge	a5,a4,80205c80 <get_proc+0x28>
        return 0;
    80205c7c:	4781                	li	a5,0
    80205c7e:	a899                	j	80205cd4 <get_proc+0x7c>
    }
    // 遍历进程表查找匹配的 PID
    for (int i = 0; i < PROC; i++) {
    80205c80:	fe042623          	sw	zero,-20(s0)
    80205c84:	a081                	j	80205cc4 <get_proc+0x6c>
        struct proc *p = proc_table[i];
    80205c86:	00013717          	auipc	a4,0x13
    80205c8a:	80270713          	addi	a4,a4,-2046 # 80218488 <proc_table>
    80205c8e:	fec42783          	lw	a5,-20(s0)
    80205c92:	078e                	slli	a5,a5,0x3
    80205c94:	97ba                	add	a5,a5,a4
    80205c96:	639c                	ld	a5,0(a5)
    80205c98:	fef43023          	sd	a5,-32(s0)
        if (p->state != UNUSED && p->pid == pid) {
    80205c9c:	fe043783          	ld	a5,-32(s0)
    80205ca0:	439c                	lw	a5,0(a5)
    80205ca2:	cf81                	beqz	a5,80205cba <get_proc+0x62>
    80205ca4:	fe043783          	ld	a5,-32(s0)
    80205ca8:	43d8                	lw	a4,4(a5)
    80205caa:	fdc42783          	lw	a5,-36(s0)
    80205cae:	2781                	sext.w	a5,a5
    80205cb0:	00e79563          	bne	a5,a4,80205cba <get_proc+0x62>
            return p;
    80205cb4:	fe043783          	ld	a5,-32(s0)
    80205cb8:	a831                	j	80205cd4 <get_proc+0x7c>
    for (int i = 0; i < PROC; i++) {
    80205cba:	fec42783          	lw	a5,-20(s0)
    80205cbe:	2785                	addiw	a5,a5,1
    80205cc0:	fef42623          	sw	a5,-20(s0)
    80205cc4:	fec42783          	lw	a5,-20(s0)
    80205cc8:	0007871b          	sext.w	a4,a5
    80205ccc:	47fd                	li	a5,31
    80205cce:	fae7dce3          	bge	a5,a4,80205c86 <get_proc+0x2e>
        }
    }
    return 0;
    80205cd2:	4781                	li	a5,0
    80205cd4:	853e                	mv	a0,a5
    80205cd6:	7422                	ld	s0,40(sp)
    80205cd8:	6145                	addi	sp,sp,48
    80205cda:	8082                	ret

0000000080205cdc <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    80205cdc:	7179                	addi	sp,sp,-48
    80205cde:	f422                	sd	s0,40(sp)
    80205ce0:	1800                	addi	s0,sp,48
    80205ce2:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    80205ce6:	fe042623          	sw	zero,-20(s0)
    80205cea:	a031                	j	80205cf6 <strlen+0x1a>
    80205cec:	fec42783          	lw	a5,-20(s0)
    80205cf0:	2785                	addiw	a5,a5,1
    80205cf2:	fef42623          	sw	a5,-20(s0)
    80205cf6:	fec42783          	lw	a5,-20(s0)
    80205cfa:	fd843703          	ld	a4,-40(s0)
    80205cfe:	97ba                	add	a5,a5,a4
    80205d00:	0007c783          	lbu	a5,0(a5)
    80205d04:	f7e5                	bnez	a5,80205cec <strlen+0x10>
        ;
    return n;
    80205d06:	fec42783          	lw	a5,-20(s0)
}
    80205d0a:	853e                	mv	a0,a5
    80205d0c:	7422                	ld	s0,40(sp)
    80205d0e:	6145                	addi	sp,sp,48
    80205d10:	8082                	ret

0000000080205d12 <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    80205d12:	1101                	addi	sp,sp,-32
    80205d14:	ec22                	sd	s0,24(sp)
    80205d16:	1000                	addi	s0,sp,32
    80205d18:	fea43423          	sd	a0,-24(s0)
    80205d1c:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    80205d20:	a819                	j	80205d36 <strcmp+0x24>
        p++, q++;
    80205d22:	fe843783          	ld	a5,-24(s0)
    80205d26:	0785                	addi	a5,a5,1
    80205d28:	fef43423          	sd	a5,-24(s0)
    80205d2c:	fe043783          	ld	a5,-32(s0)
    80205d30:	0785                	addi	a5,a5,1
    80205d32:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    80205d36:	fe843783          	ld	a5,-24(s0)
    80205d3a:	0007c783          	lbu	a5,0(a5)
    80205d3e:	cb99                	beqz	a5,80205d54 <strcmp+0x42>
    80205d40:	fe843783          	ld	a5,-24(s0)
    80205d44:	0007c703          	lbu	a4,0(a5)
    80205d48:	fe043783          	ld	a5,-32(s0)
    80205d4c:	0007c783          	lbu	a5,0(a5)
    80205d50:	fcf709e3          	beq	a4,a5,80205d22 <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    80205d54:	fe843783          	ld	a5,-24(s0)
    80205d58:	0007c783          	lbu	a5,0(a5)
    80205d5c:	0007871b          	sext.w	a4,a5
    80205d60:	fe043783          	ld	a5,-32(s0)
    80205d64:	0007c783          	lbu	a5,0(a5)
    80205d68:	2781                	sext.w	a5,a5
    80205d6a:	40f707bb          	subw	a5,a4,a5
    80205d6e:	2781                	sext.w	a5,a5
}
    80205d70:	853e                	mv	a0,a5
    80205d72:	6462                	ld	s0,24(sp)
    80205d74:	6105                	addi	sp,sp,32
    80205d76:	8082                	ret

0000000080205d78 <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    80205d78:	7179                	addi	sp,sp,-48
    80205d7a:	f422                	sd	s0,40(sp)
    80205d7c:	1800                	addi	s0,sp,48
    80205d7e:	fca43c23          	sd	a0,-40(s0)
    80205d82:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    80205d86:	fd843783          	ld	a5,-40(s0)
    80205d8a:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    80205d8e:	0001                	nop
    80205d90:	fd043703          	ld	a4,-48(s0)
    80205d94:	00170793          	addi	a5,a4,1
    80205d98:	fcf43823          	sd	a5,-48(s0)
    80205d9c:	fd843783          	ld	a5,-40(s0)
    80205da0:	00178693          	addi	a3,a5,1
    80205da4:	fcd43c23          	sd	a3,-40(s0)
    80205da8:	00074703          	lbu	a4,0(a4)
    80205dac:	00e78023          	sb	a4,0(a5)
    80205db0:	0007c783          	lbu	a5,0(a5)
    80205db4:	fff1                	bnez	a5,80205d90 <strcpy+0x18>
        ;
    return os;
    80205db6:	fe843783          	ld	a5,-24(s0)
}
    80205dba:	853e                	mv	a0,a5
    80205dbc:	7422                	ld	s0,40(sp)
    80205dbe:	6145                	addi	sp,sp,48
    80205dc0:	8082                	ret

0000000080205dc2 <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    80205dc2:	7139                	addi	sp,sp,-64
    80205dc4:	fc22                	sd	s0,56(sp)
    80205dc6:	0080                	addi	s0,sp,64
    80205dc8:	fca43c23          	sd	a0,-40(s0)
    80205dcc:	fcb43823          	sd	a1,-48(s0)
    80205dd0:	87b2                	mv	a5,a2
    80205dd2:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    80205dd6:	fd843783          	ld	a5,-40(s0)
    80205dda:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    80205dde:	fcc42783          	lw	a5,-52(s0)
    80205de2:	2781                	sext.w	a5,a5
    80205de4:	00f04563          	bgtz	a5,80205dee <safestrcpy+0x2c>
        return os;
    80205de8:	fe843783          	ld	a5,-24(s0)
    80205dec:	a0a9                	j	80205e36 <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    80205dee:	0001                	nop
    80205df0:	fcc42783          	lw	a5,-52(s0)
    80205df4:	37fd                	addiw	a5,a5,-1
    80205df6:	fcf42623          	sw	a5,-52(s0)
    80205dfa:	fcc42783          	lw	a5,-52(s0)
    80205dfe:	2781                	sext.w	a5,a5
    80205e00:	02f05563          	blez	a5,80205e2a <safestrcpy+0x68>
    80205e04:	fd043703          	ld	a4,-48(s0)
    80205e08:	00170793          	addi	a5,a4,1
    80205e0c:	fcf43823          	sd	a5,-48(s0)
    80205e10:	fd843783          	ld	a5,-40(s0)
    80205e14:	00178693          	addi	a3,a5,1
    80205e18:	fcd43c23          	sd	a3,-40(s0)
    80205e1c:	00074703          	lbu	a4,0(a4)
    80205e20:	00e78023          	sb	a4,0(a5)
    80205e24:	0007c783          	lbu	a5,0(a5)
    80205e28:	f7e1                	bnez	a5,80205df0 <safestrcpy+0x2e>
        ;
    *s = 0;
    80205e2a:	fd843783          	ld	a5,-40(s0)
    80205e2e:	00078023          	sb	zero,0(a5)
    return os;
    80205e32:	fe843783          	ld	a5,-24(s0)
    80205e36:	853e                	mv	a0,a5
    80205e38:	7462                	ld	s0,56(sp)
    80205e3a:	6121                	addi	sp,sp,64
    80205e3c:	8082                	ret

0000000080205e3e <assert>:
	int count =5000;
	while(count){
		count--;
		if(count % 100 == 0)
			printf("Call for help!!\n");
		yield();
    80205e3e:	1101                	addi	sp,sp,-32
    80205e40:	ec06                	sd	ra,24(sp)
    80205e42:	e822                	sd	s0,16(sp)
    80205e44:	1000                	addi	s0,sp,32
    80205e46:	87aa                	mv	a5,a0
    80205e48:	fef42623          	sw	a5,-20(s0)
	}
    80205e4c:	fec42783          	lw	a5,-20(s0)
    80205e50:	2781                	sext.w	a5,a5
    80205e52:	e79d                	bnez	a5,80205e80 <assert+0x42>
	printf("No one can kill me!\n");
    80205e54:	1a200613          	li	a2,418
    80205e58:	0000f597          	auipc	a1,0xf
    80205e5c:	5d858593          	addi	a1,a1,1496 # 80215430 <simple_user_task_bin+0x68>
    80205e60:	0000f517          	auipc	a0,0xf
    80205e64:	5e050513          	addi	a0,a0,1504 # 80215440 <simple_user_task_bin+0x78>
    80205e68:	ffffb097          	auipc	ra,0xffffb
    80205e6c:	e2c080e7          	jalr	-468(ra) # 80200c94 <printf>
	exit_proc(0);
    80205e70:	0000f517          	auipc	a0,0xf
    80205e74:	5f850513          	addi	a0,a0,1528 # 80215468 <simple_user_task_bin+0xa0>
    80205e78:	ffffc097          	auipc	ra,0xffffc
    80205e7c:	868080e7          	jalr	-1944(ra) # 802016e0 <panic>
}

    80205e80:	0001                	nop
    80205e82:	60e2                	ld	ra,24(sp)
    80205e84:	6442                	ld	s0,16(sp)
    80205e86:	6105                	addi	sp,sp,32
    80205e88:	8082                	ret

0000000080205e8a <get_time>:
uint64 get_time(void) {
    80205e8a:	1141                	addi	sp,sp,-16
    80205e8c:	e406                	sd	ra,8(sp)
    80205e8e:	e022                	sd	s0,0(sp)
    80205e90:	0800                	addi	s0,sp,16
    return sbi_get_time();
    80205e92:	ffffd097          	auipc	ra,0xffffd
    80205e96:	634080e7          	jalr	1588(ra) # 802034c6 <sbi_get_time>
    80205e9a:	87aa                	mv	a5,a0
}
    80205e9c:	853e                	mv	a0,a5
    80205e9e:	60a2                	ld	ra,8(sp)
    80205ea0:	6402                	ld	s0,0(sp)
    80205ea2:	0141                	addi	sp,sp,16
    80205ea4:	8082                	ret

0000000080205ea6 <test_timer_interrupt>:
void test_timer_interrupt(void) {
    80205ea6:	7179                	addi	sp,sp,-48
    80205ea8:	f406                	sd	ra,40(sp)
    80205eaa:	f022                	sd	s0,32(sp)
    80205eac:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    80205eae:	0000f517          	auipc	a0,0xf
    80205eb2:	5c250513          	addi	a0,a0,1474 # 80215470 <simple_user_task_bin+0xa8>
    80205eb6:	ffffb097          	auipc	ra,0xffffb
    80205eba:	dde080e7          	jalr	-546(ra) # 80200c94 <printf>
    uint64 start_time = get_time();
    80205ebe:	00000097          	auipc	ra,0x0
    80205ec2:	fcc080e7          	jalr	-52(ra) # 80205e8a <get_time>
    80205ec6:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    80205eca:	fc042a23          	sw	zero,-44(s0)
	int last_count = interrupt_count;
    80205ece:	fd442783          	lw	a5,-44(s0)
    80205ed2:	fef42623          	sw	a5,-20(s0)
    interrupt_test_flag = &interrupt_count;
    80205ed6:	00012797          	auipc	a5,0x12
    80205eda:	20278793          	addi	a5,a5,514 # 802180d8 <interrupt_test_flag>
    80205ede:	fd440713          	addi	a4,s0,-44
    80205ee2:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    80205ee4:	a899                	j	80205f3a <test_timer_interrupt+0x94>
        if(last_count != interrupt_count) {
    80205ee6:	fd442703          	lw	a4,-44(s0)
    80205eea:	fec42783          	lw	a5,-20(s0)
    80205eee:	2781                	sext.w	a5,a5
    80205ef0:	02e78163          	beq	a5,a4,80205f12 <test_timer_interrupt+0x6c>
			last_count = interrupt_count;
    80205ef4:	fd442783          	lw	a5,-44(s0)
    80205ef8:	fef42623          	sw	a5,-20(s0)
			printf("Received interrupt %d\n", interrupt_count);
    80205efc:	fd442783          	lw	a5,-44(s0)
    80205f00:	85be                	mv	a1,a5
    80205f02:	0000f517          	auipc	a0,0xf
    80205f06:	58e50513          	addi	a0,a0,1422 # 80215490 <simple_user_task_bin+0xc8>
    80205f0a:	ffffb097          	auipc	ra,0xffffb
    80205f0e:	d8a080e7          	jalr	-630(ra) # 80200c94 <printf>
        for (volatile int i = 0; i < 1000000; i++);
    80205f12:	fc042823          	sw	zero,-48(s0)
    80205f16:	a801                	j	80205f26 <test_timer_interrupt+0x80>
    80205f18:	fd042783          	lw	a5,-48(s0)
    80205f1c:	2781                	sext.w	a5,a5
    80205f1e:	2785                	addiw	a5,a5,1
    80205f20:	2781                	sext.w	a5,a5
    80205f22:	fcf42823          	sw	a5,-48(s0)
    80205f26:	fd042783          	lw	a5,-48(s0)
    80205f2a:	2781                	sext.w	a5,a5
    80205f2c:	873e                	mv	a4,a5
    80205f2e:	000f47b7          	lui	a5,0xf4
    80205f32:	23f78793          	addi	a5,a5,575 # f423f <_entry-0x8010bdc1>
    80205f36:	fee7d1e3          	bge	a5,a4,80205f18 <test_timer_interrupt+0x72>
    while (interrupt_count < 5) {
    80205f3a:	fd442783          	lw	a5,-44(s0)
    80205f3e:	873e                	mv	a4,a5
    80205f40:	4791                	li	a5,4
    80205f42:	fae7d2e3          	bge	a5,a4,80205ee6 <test_timer_interrupt+0x40>
    interrupt_test_flag = 0;
    80205f46:	00012797          	auipc	a5,0x12
    80205f4a:	19278793          	addi	a5,a5,402 # 802180d8 <interrupt_test_flag>
    80205f4e:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    80205f52:	00000097          	auipc	ra,0x0
    80205f56:	f38080e7          	jalr	-200(ra) # 80205e8a <get_time>
    80205f5a:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n", 
    80205f5e:	fd442683          	lw	a3,-44(s0)
    80205f62:	fd843703          	ld	a4,-40(s0)
    80205f66:	fe043783          	ld	a5,-32(s0)
    80205f6a:	40f707b3          	sub	a5,a4,a5
    80205f6e:	863e                	mv	a2,a5
    80205f70:	85b6                	mv	a1,a3
    80205f72:	0000f517          	auipc	a0,0xf
    80205f76:	53650513          	addi	a0,a0,1334 # 802154a8 <simple_user_task_bin+0xe0>
    80205f7a:	ffffb097          	auipc	ra,0xffffb
    80205f7e:	d1a080e7          	jalr	-742(ra) # 80200c94 <printf>
}
    80205f82:	0001                	nop
    80205f84:	70a2                	ld	ra,40(sp)
    80205f86:	7402                	ld	s0,32(sp)
    80205f88:	6145                	addi	sp,sp,48
    80205f8a:	8082                	ret

0000000080205f8c <test_exception>:
void test_exception(void) {
    80205f8c:	715d                	addi	sp,sp,-80
    80205f8e:	e486                	sd	ra,72(sp)
    80205f90:	e0a2                	sd	s0,64(sp)
    80205f92:	0880                	addi	s0,sp,80
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    80205f94:	0000f517          	auipc	a0,0xf
    80205f98:	54c50513          	addi	a0,a0,1356 # 802154e0 <simple_user_task_bin+0x118>
    80205f9c:	ffffb097          	auipc	ra,0xffffb
    80205fa0:	cf8080e7          	jalr	-776(ra) # 80200c94 <printf>
    printf("1. 测试非法指令异常...\n");
    80205fa4:	0000f517          	auipc	a0,0xf
    80205fa8:	56c50513          	addi	a0,a0,1388 # 80215510 <simple_user_task_bin+0x148>
    80205fac:	ffffb097          	auipc	ra,0xffffb
    80205fb0:	ce8080e7          	jalr	-792(ra) # 80200c94 <printf>
    80205fb4:	ffffffff          	.word	0xffffffff
    printf("✓ 非法指令异常处理成功\n\n");
    80205fb8:	0000f517          	auipc	a0,0xf
    80205fbc:	57850513          	addi	a0,a0,1400 # 80215530 <simple_user_task_bin+0x168>
    80205fc0:	ffffb097          	auipc	ra,0xffffb
    80205fc4:	cd4080e7          	jalr	-812(ra) # 80200c94 <printf>
    printf("2. 测试存储页故障异常...\n");
    80205fc8:	0000f517          	auipc	a0,0xf
    80205fcc:	59050513          	addi	a0,a0,1424 # 80215558 <simple_user_task_bin+0x190>
    80205fd0:	ffffb097          	auipc	ra,0xffffb
    80205fd4:	cc4080e7          	jalr	-828(ra) # 80200c94 <printf>
    volatile uint64 *invalid_ptr = 0;
    80205fd8:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80205fdc:	47a5                	li	a5,9
    80205fde:	07f2                	slli	a5,a5,0x1c
    80205fe0:	fef43023          	sd	a5,-32(s0)
    80205fe4:	a835                	j	80206020 <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    80205fe6:	fe043503          	ld	a0,-32(s0)
    80205fea:	ffffd097          	auipc	ra,0xffffd
    80205fee:	ff4080e7          	jalr	-12(ra) # 80202fde <check_is_mapped>
    80205ff2:	87aa                	mv	a5,a0
    80205ff4:	e385                	bnez	a5,80206014 <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    80205ff6:	fe043783          	ld	a5,-32(s0)
    80205ffa:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    80205ffe:	fe043583          	ld	a1,-32(s0)
    80206002:	0000f517          	auipc	a0,0xf
    80206006:	57e50513          	addi	a0,a0,1406 # 80215580 <simple_user_task_bin+0x1b8>
    8020600a:	ffffb097          	auipc	ra,0xffffb
    8020600e:	c8a080e7          	jalr	-886(ra) # 80200c94 <printf>
            break;
    80206012:	a829                	j	8020602c <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80206014:	fe043703          	ld	a4,-32(s0)
    80206018:	6785                	lui	a5,0x1
    8020601a:	97ba                	add	a5,a5,a4
    8020601c:	fef43023          	sd	a5,-32(s0)
    80206020:	fe043703          	ld	a4,-32(s0)
    80206024:	47cd                	li	a5,19
    80206026:	07ee                	slli	a5,a5,0x1b
    80206028:	faf76fe3          	bltu	a4,a5,80205fe6 <test_exception+0x5a>
    if (invalid_ptr != 0) {
    8020602c:	fe843783          	ld	a5,-24(s0)
    80206030:	cb95                	beqz	a5,80206064 <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    80206032:	fe843783          	ld	a5,-24(s0)
    80206036:	85be                	mv	a1,a5
    80206038:	0000f517          	auipc	a0,0xf
    8020603c:	56850513          	addi	a0,a0,1384 # 802155a0 <simple_user_task_bin+0x1d8>
    80206040:	ffffb097          	auipc	ra,0xffffb
    80206044:	c54080e7          	jalr	-940(ra) # 80200c94 <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    80206048:	fe843783          	ld	a5,-24(s0)
    8020604c:	02a00713          	li	a4,42
    80206050:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    80206052:	0000f517          	auipc	a0,0xf
    80206056:	57e50513          	addi	a0,a0,1406 # 802155d0 <simple_user_task_bin+0x208>
    8020605a:	ffffb097          	auipc	ra,0xffffb
    8020605e:	c3a080e7          	jalr	-966(ra) # 80200c94 <printf>
    80206062:	a809                	j	80206074 <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80206064:	0000f517          	auipc	a0,0xf
    80206068:	59450513          	addi	a0,a0,1428 # 802155f8 <simple_user_task_bin+0x230>
    8020606c:	ffffb097          	auipc	ra,0xffffb
    80206070:	c28080e7          	jalr	-984(ra) # 80200c94 <printf>
    printf("3. 测试加载页故障异常...\n");
    80206074:	0000f517          	auipc	a0,0xf
    80206078:	5bc50513          	addi	a0,a0,1468 # 80215630 <simple_user_task_bin+0x268>
    8020607c:	ffffb097          	auipc	ra,0xffffb
    80206080:	c18080e7          	jalr	-1000(ra) # 80200c94 <printf>
    invalid_ptr = 0;
    80206084:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    80206088:	4795                	li	a5,5
    8020608a:	07f6                	slli	a5,a5,0x1d
    8020608c:	fcf43c23          	sd	a5,-40(s0)
    80206090:	a835                	j	802060cc <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    80206092:	fd843503          	ld	a0,-40(s0)
    80206096:	ffffd097          	auipc	ra,0xffffd
    8020609a:	f48080e7          	jalr	-184(ra) # 80202fde <check_is_mapped>
    8020609e:	87aa                	mv	a5,a0
    802060a0:	e385                	bnez	a5,802060c0 <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    802060a2:	fd843783          	ld	a5,-40(s0)
    802060a6:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    802060aa:	fd843583          	ld	a1,-40(s0)
    802060ae:	0000f517          	auipc	a0,0xf
    802060b2:	4d250513          	addi	a0,a0,1234 # 80215580 <simple_user_task_bin+0x1b8>
    802060b6:	ffffb097          	auipc	ra,0xffffb
    802060ba:	bde080e7          	jalr	-1058(ra) # 80200c94 <printf>
            break;
    802060be:	a829                	j	802060d8 <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802060c0:	fd843703          	ld	a4,-40(s0)
    802060c4:	6785                	lui	a5,0x1
    802060c6:	97ba                	add	a5,a5,a4
    802060c8:	fcf43c23          	sd	a5,-40(s0)
    802060cc:	fd843703          	ld	a4,-40(s0)
    802060d0:	47d5                	li	a5,21
    802060d2:	07ee                	slli	a5,a5,0x1b
    802060d4:	faf76fe3          	bltu	a4,a5,80206092 <test_exception+0x106>
    if (invalid_ptr != 0) {
    802060d8:	fe843783          	ld	a5,-24(s0)
    802060dc:	c7a9                	beqz	a5,80206126 <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    802060de:	fe843783          	ld	a5,-24(s0)
    802060e2:	85be                	mv	a1,a5
    802060e4:	0000f517          	auipc	a0,0xf
    802060e8:	57450513          	addi	a0,a0,1396 # 80215658 <simple_user_task_bin+0x290>
    802060ec:	ffffb097          	auipc	ra,0xffffb
    802060f0:	ba8080e7          	jalr	-1112(ra) # 80200c94 <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    802060f4:	fe843783          	ld	a5,-24(s0)
    802060f8:	639c                	ld	a5,0(a5)
    802060fa:	faf43823          	sd	a5,-80(s0)
        printf("读取的值: %lu\n", value);  // 不太可能执行到这里，除非故障被处理
    802060fe:	fb043783          	ld	a5,-80(s0)
    80206102:	85be                	mv	a1,a5
    80206104:	0000f517          	auipc	a0,0xf
    80206108:	58450513          	addi	a0,a0,1412 # 80215688 <simple_user_task_bin+0x2c0>
    8020610c:	ffffb097          	auipc	ra,0xffffb
    80206110:	b88080e7          	jalr	-1144(ra) # 80200c94 <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    80206114:	0000f517          	auipc	a0,0xf
    80206118:	58c50513          	addi	a0,a0,1420 # 802156a0 <simple_user_task_bin+0x2d8>
    8020611c:	ffffb097          	auipc	ra,0xffffb
    80206120:	b78080e7          	jalr	-1160(ra) # 80200c94 <printf>
    80206124:	a809                	j	80206136 <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80206126:	0000f517          	auipc	a0,0xf
    8020612a:	4d250513          	addi	a0,a0,1234 # 802155f8 <simple_user_task_bin+0x230>
    8020612e:	ffffb097          	auipc	ra,0xffffb
    80206132:	b66080e7          	jalr	-1178(ra) # 80200c94 <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    80206136:	0000f517          	auipc	a0,0xf
    8020613a:	59250513          	addi	a0,a0,1426 # 802156c8 <simple_user_task_bin+0x300>
    8020613e:	ffffb097          	auipc	ra,0xffffb
    80206142:	b56080e7          	jalr	-1194(ra) # 80200c94 <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    80206146:	ffffd097          	auipc	ra,0xffffd
    8020614a:	0e0080e7          	jalr	224(ra) # 80203226 <alloc_page>
    8020614e:	87aa                	mv	a5,a0
    80206150:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    80206154:	fd043783          	ld	a5,-48(s0)
    80206158:	c3a1                	beqz	a5,80206198 <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    8020615a:	fd043783          	ld	a5,-48(s0)
    8020615e:	0785                	addi	a5,a5,1 # 1001 <_entry-0x801fefff>
    80206160:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80206164:	fc843583          	ld	a1,-56(s0)
    80206168:	0000f517          	auipc	a0,0xf
    8020616c:	59050513          	addi	a0,a0,1424 # 802156f8 <simple_user_task_bin+0x330>
    80206170:	ffffb097          	auipc	ra,0xffffb
    80206174:	b24080e7          	jalr	-1244(ra) # 80200c94 <printf>
        asm volatile (
    80206178:	deadc7b7          	lui	a5,0xdeadc
    8020617c:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8c37df>
    80206180:	fc843703          	ld	a4,-56(s0)
    80206184:	e31c                	sd	a5,0(a4)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    80206186:	0000f517          	auipc	a0,0xf
    8020618a:	59250513          	addi	a0,a0,1426 # 80215718 <simple_user_task_bin+0x350>
    8020618e:	ffffb097          	auipc	ra,0xffffb
    80206192:	b06080e7          	jalr	-1274(ra) # 80200c94 <printf>
    80206196:	a809                	j	802061a8 <test_exception+0x21c>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80206198:	0000f517          	auipc	a0,0xf
    8020619c:	5b050513          	addi	a0,a0,1456 # 80215748 <simple_user_task_bin+0x380>
    802061a0:	ffffb097          	auipc	ra,0xffffb
    802061a4:	af4080e7          	jalr	-1292(ra) # 80200c94 <printf>
    printf("5. 测试加载地址未对齐异常...\n");
    802061a8:	0000f517          	auipc	a0,0xf
    802061ac:	5e050513          	addi	a0,a0,1504 # 80215788 <simple_user_task_bin+0x3c0>
    802061b0:	ffffb097          	auipc	ra,0xffffb
    802061b4:	ae4080e7          	jalr	-1308(ra) # 80200c94 <printf>
    if (aligned_addr != 0) {
    802061b8:	fd043783          	ld	a5,-48(s0)
    802061bc:	cbb1                	beqz	a5,80206210 <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    802061be:	fd043783          	ld	a5,-48(s0)
    802061c2:	0785                	addi	a5,a5,1
    802061c4:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    802061c8:	fc043583          	ld	a1,-64(s0)
    802061cc:	0000f517          	auipc	a0,0xf
    802061d0:	52c50513          	addi	a0,a0,1324 # 802156f8 <simple_user_task_bin+0x330>
    802061d4:	ffffb097          	auipc	ra,0xffffb
    802061d8:	ac0080e7          	jalr	-1344(ra) # 80200c94 <printf>
        uint64 value = 0;
    802061dc:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    802061e0:	fc043783          	ld	a5,-64(s0)
    802061e4:	639c                	ld	a5,0(a5)
    802061e6:	faf43c23          	sd	a5,-72(s0)
        printf("读取的值: 0x%lx\n", value);
    802061ea:	fb843583          	ld	a1,-72(s0)
    802061ee:	0000f517          	auipc	a0,0xf
    802061f2:	5ca50513          	addi	a0,a0,1482 # 802157b8 <simple_user_task_bin+0x3f0>
    802061f6:	ffffb097          	auipc	ra,0xffffb
    802061fa:	a9e080e7          	jalr	-1378(ra) # 80200c94 <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    802061fe:	0000f517          	auipc	a0,0xf
    80206202:	5d250513          	addi	a0,a0,1490 # 802157d0 <simple_user_task_bin+0x408>
    80206206:	ffffb097          	auipc	ra,0xffffb
    8020620a:	a8e080e7          	jalr	-1394(ra) # 80200c94 <printf>
    8020620e:	a809                	j	80206220 <test_exception+0x294>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    80206210:	0000f517          	auipc	a0,0xf
    80206214:	53850513          	addi	a0,a0,1336 # 80215748 <simple_user_task_bin+0x380>
    80206218:	ffffb097          	auipc	ra,0xffffb
    8020621c:	a7c080e7          	jalr	-1412(ra) # 80200c94 <printf>
	printf("6. 测试断点异常...\n");
    80206220:	0000f517          	auipc	a0,0xf
    80206224:	5e050513          	addi	a0,a0,1504 # 80215800 <simple_user_task_bin+0x438>
    80206228:	ffffb097          	auipc	ra,0xffffb
    8020622c:	a6c080e7          	jalr	-1428(ra) # 80200c94 <printf>
	asm volatile (
    80206230:	0001                	nop
    80206232:	9002                	ebreak
    80206234:	0001                	nop
	printf("✓ 断点异常处理成功\n\n");
    80206236:	0000f517          	auipc	a0,0xf
    8020623a:	5ea50513          	addi	a0,a0,1514 # 80215820 <simple_user_task_bin+0x458>
    8020623e:	ffffb097          	auipc	ra,0xffffb
    80206242:	a56080e7          	jalr	-1450(ra) # 80200c94 <printf>
    printf("7. 测试环境调用异常...\n");
    80206246:	0000f517          	auipc	a0,0xf
    8020624a:	5fa50513          	addi	a0,a0,1530 # 80215840 <simple_user_task_bin+0x478>
    8020624e:	ffffb097          	auipc	ra,0xffffb
    80206252:	a46080e7          	jalr	-1466(ra) # 80200c94 <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    80206256:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    8020625a:	0000f517          	auipc	a0,0xf
    8020625e:	60650513          	addi	a0,a0,1542 # 80215860 <simple_user_task_bin+0x498>
    80206262:	ffffb097          	auipc	ra,0xffffb
    80206266:	a32080e7          	jalr	-1486(ra) # 80200c94 <printf>
    printf("===== 异常处理测试完成 =====\n\n");
    8020626a:	0000f517          	auipc	a0,0xf
    8020626e:	61e50513          	addi	a0,a0,1566 # 80215888 <simple_user_task_bin+0x4c0>
    80206272:	ffffb097          	auipc	ra,0xffffb
    80206276:	a22080e7          	jalr	-1502(ra) # 80200c94 <printf>
}
    8020627a:	0001                	nop
    8020627c:	60a6                	ld	ra,72(sp)
    8020627e:	6406                	ld	s0,64(sp)
    80206280:	6161                	addi	sp,sp,80
    80206282:	8082                	ret

0000000080206284 <simple_task>:
void simple_task(void) {
    80206284:	1141                	addi	sp,sp,-16
    80206286:	e406                	sd	ra,8(sp)
    80206288:	e022                	sd	s0,0(sp)
    8020628a:	0800                	addi	s0,sp,16
    printf("Simple kernel task running in PID %d\n", myproc()->pid);
    8020628c:	fffff097          	auipc	ra,0xfffff
    80206290:	814080e7          	jalr	-2028(ra) # 80204aa0 <myproc>
    80206294:	87aa                	mv	a5,a0
    80206296:	43dc                	lw	a5,4(a5)
    80206298:	85be                	mv	a1,a5
    8020629a:	0000f517          	auipc	a0,0xf
    8020629e:	61650513          	addi	a0,a0,1558 # 802158b0 <simple_user_task_bin+0x4e8>
    802062a2:	ffffb097          	auipc	ra,0xffffb
    802062a6:	9f2080e7          	jalr	-1550(ra) # 80200c94 <printf>
}
    802062aa:	0001                	nop
    802062ac:	60a2                	ld	ra,8(sp)
    802062ae:	6402                	ld	s0,0(sp)
    802062b0:	0141                	addi	sp,sp,16
    802062b2:	8082                	ret

00000000802062b4 <test_process_creation>:
void test_process_creation(void) {
    802062b4:	7119                	addi	sp,sp,-128
    802062b6:	fc86                	sd	ra,120(sp)
    802062b8:	f8a2                	sd	s0,112(sp)
    802062ba:	0100                	addi	s0,sp,128
    printf("===== 测试开始: 进程创建与管理测试 =====\n");
    802062bc:	0000f517          	auipc	a0,0xf
    802062c0:	61c50513          	addi	a0,a0,1564 # 802158d8 <simple_user_task_bin+0x510>
    802062c4:	ffffb097          	auipc	ra,0xffffb
    802062c8:	9d0080e7          	jalr	-1584(ra) # 80200c94 <printf>
    printf("\n----- 第一阶段：测试内核进程创建与管理 -----\n");
    802062cc:	0000f517          	auipc	a0,0xf
    802062d0:	64450513          	addi	a0,a0,1604 # 80215910 <simple_user_task_bin+0x548>
    802062d4:	ffffb097          	auipc	ra,0xffffb
    802062d8:	9c0080e7          	jalr	-1600(ra) # 80200c94 <printf>
    int pid = create_kernel_proc(simple_task);
    802062dc:	00000517          	auipc	a0,0x0
    802062e0:	fa850513          	addi	a0,a0,-88 # 80206284 <simple_task>
    802062e4:	fffff097          	auipc	ra,0xfffff
    802062e8:	dfc080e7          	jalr	-516(ra) # 802050e0 <create_kernel_proc>
    802062ec:	87aa                	mv	a5,a0
    802062ee:	faf42a23          	sw	a5,-76(s0)
    assert(pid > 0);
    802062f2:	fb442783          	lw	a5,-76(s0)
    802062f6:	2781                	sext.w	a5,a5
    802062f8:	00f027b3          	sgtz	a5,a5
    802062fc:	0ff7f793          	zext.b	a5,a5
    80206300:	2781                	sext.w	a5,a5
    80206302:	853e                	mv	a0,a5
    80206304:	00000097          	auipc	ra,0x0
    80206308:	b3a080e7          	jalr	-1222(ra) # 80205e3e <assert>
    printf("【测试结果】: 基本内核进程创建成功，PID: %d\n", pid);
    8020630c:	fb442783          	lw	a5,-76(s0)
    80206310:	85be                	mv	a1,a5
    80206312:	0000f517          	auipc	a0,0xf
    80206316:	63e50513          	addi	a0,a0,1598 # 80215950 <simple_user_task_bin+0x588>
    8020631a:	ffffb097          	auipc	ra,0xffffb
    8020631e:	97a080e7          	jalr	-1670(ra) # 80200c94 <printf>
    printf("\n----- 用内核进程填满进程表 -----\n");
    80206322:	0000f517          	auipc	a0,0xf
    80206326:	66e50513          	addi	a0,a0,1646 # 80215990 <simple_user_task_bin+0x5c8>
    8020632a:	ffffb097          	auipc	ra,0xffffb
    8020632e:	96a080e7          	jalr	-1686(ra) # 80200c94 <printf>
    int kernel_count = 1; // 已经创建了一个
    80206332:	4785                	li	a5,1
    80206334:	fef42623          	sw	a5,-20(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206338:	4785                	li	a5,1
    8020633a:	fef42423          	sw	a5,-24(s0)
    8020633e:	a881                	j	8020638e <test_process_creation+0xda>
        int new_pid = create_kernel_proc(simple_task);
    80206340:	00000517          	auipc	a0,0x0
    80206344:	f4450513          	addi	a0,a0,-188 # 80206284 <simple_task>
    80206348:	fffff097          	auipc	ra,0xfffff
    8020634c:	d98080e7          	jalr	-616(ra) # 802050e0 <create_kernel_proc>
    80206350:	87aa                	mv	a5,a0
    80206352:	faf42823          	sw	a5,-80(s0)
        if (new_pid > 0) {
    80206356:	fb042783          	lw	a5,-80(s0)
    8020635a:	2781                	sext.w	a5,a5
    8020635c:	00f05863          	blez	a5,8020636c <test_process_creation+0xb8>
            kernel_count++; 
    80206360:	fec42783          	lw	a5,-20(s0)
    80206364:	2785                	addiw	a5,a5,1
    80206366:	fef42623          	sw	a5,-20(s0)
    8020636a:	a829                	j	80206384 <test_process_creation+0xd0>
            warning("process table was full at %d kernel processes\n", kernel_count);
    8020636c:	fec42783          	lw	a5,-20(s0)
    80206370:	85be                	mv	a1,a5
    80206372:	0000f517          	auipc	a0,0xf
    80206376:	64e50513          	addi	a0,a0,1614 # 802159c0 <simple_user_task_bin+0x5f8>
    8020637a:	ffffb097          	auipc	ra,0xffffb
    8020637e:	39a080e7          	jalr	922(ra) # 80201714 <warning>
            break;
    80206382:	a829                	j	8020639c <test_process_creation+0xe8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206384:	fe842783          	lw	a5,-24(s0)
    80206388:	2785                	addiw	a5,a5,1
    8020638a:	fef42423          	sw	a5,-24(s0)
    8020638e:	fe842783          	lw	a5,-24(s0)
    80206392:	0007871b          	sext.w	a4,a5
    80206396:	47fd                	li	a5,31
    80206398:	fae7d4e3          	bge	a5,a4,80206340 <test_process_creation+0x8c>
    printf("【测试结果】: 成功创建 %d 个内核进程 (最大限制: %d)\n", kernel_count, PROC);
    8020639c:	fec42783          	lw	a5,-20(s0)
    802063a0:	02000613          	li	a2,32
    802063a4:	85be                	mv	a1,a5
    802063a6:	0000f517          	auipc	a0,0xf
    802063aa:	64a50513          	addi	a0,a0,1610 # 802159f0 <simple_user_task_bin+0x628>
    802063ae:	ffffb097          	auipc	ra,0xffffb
    802063b2:	8e6080e7          	jalr	-1818(ra) # 80200c94 <printf>
    print_proc_table();
    802063b6:	fffff097          	auipc	ra,0xfffff
    802063ba:	6ea080e7          	jalr	1770(ra) # 80205aa0 <print_proc_table>
    printf("\n----- 等待并清理所有内核进程 -----\n");
    802063be:	0000f517          	auipc	a0,0xf
    802063c2:	67a50513          	addi	a0,a0,1658 # 80215a38 <simple_user_task_bin+0x670>
    802063c6:	ffffb097          	auipc	ra,0xffffb
    802063ca:	8ce080e7          	jalr	-1842(ra) # 80200c94 <printf>
    int kernel_success_count = 0;
    802063ce:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < kernel_count; i++) {
    802063d2:	fe042023          	sw	zero,-32(s0)
    802063d6:	a0a5                	j	8020643e <test_process_creation+0x18a>
        int waited_pid = wait_proc(NULL);
    802063d8:	4501                	li	a0,0
    802063da:	fffff097          	auipc	ra,0xfffff
    802063de:	538080e7          	jalr	1336(ra) # 80205912 <wait_proc>
    802063e2:	87aa                	mv	a5,a0
    802063e4:	f8f42623          	sw	a5,-116(s0)
        if (waited_pid > 0) {
    802063e8:	f8c42783          	lw	a5,-116(s0)
    802063ec:	2781                	sext.w	a5,a5
    802063ee:	02f05863          	blez	a5,8020641e <test_process_creation+0x16a>
            kernel_success_count++;
    802063f2:	fe442783          	lw	a5,-28(s0)
    802063f6:	2785                	addiw	a5,a5,1
    802063f8:	fef42223          	sw	a5,-28(s0)
            printf("回收内核进程 PID: %d (%d/%d)\n", waited_pid, kernel_success_count, kernel_count);
    802063fc:	fec42683          	lw	a3,-20(s0)
    80206400:	fe442703          	lw	a4,-28(s0)
    80206404:	f8c42783          	lw	a5,-116(s0)
    80206408:	863a                	mv	a2,a4
    8020640a:	85be                	mv	a1,a5
    8020640c:	0000f517          	auipc	a0,0xf
    80206410:	65c50513          	addi	a0,a0,1628 # 80215a68 <simple_user_task_bin+0x6a0>
    80206414:	ffffb097          	auipc	ra,0xffffb
    80206418:	880080e7          	jalr	-1920(ra) # 80200c94 <printf>
    8020641c:	a821                	j	80206434 <test_process_creation+0x180>
            printf("【错误】: 等待内核进程失败，错误码: %d\n", waited_pid);
    8020641e:	f8c42783          	lw	a5,-116(s0)
    80206422:	85be                	mv	a1,a5
    80206424:	0000f517          	auipc	a0,0xf
    80206428:	66c50513          	addi	a0,a0,1644 # 80215a90 <simple_user_task_bin+0x6c8>
    8020642c:	ffffb097          	auipc	ra,0xffffb
    80206430:	868080e7          	jalr	-1944(ra) # 80200c94 <printf>
    for (int i = 0; i < kernel_count; i++) {
    80206434:	fe042783          	lw	a5,-32(s0)
    80206438:	2785                	addiw	a5,a5,1
    8020643a:	fef42023          	sw	a5,-32(s0)
    8020643e:	fe042783          	lw	a5,-32(s0)
    80206442:	873e                	mv	a4,a5
    80206444:	fec42783          	lw	a5,-20(s0)
    80206448:	2701                	sext.w	a4,a4
    8020644a:	2781                	sext.w	a5,a5
    8020644c:	f8f746e3          	blt	a4,a5,802063d8 <test_process_creation+0x124>
    printf("【测试结果】: 回收 %d/%d 个内核进程\n", kernel_success_count, kernel_count);
    80206450:	fec42703          	lw	a4,-20(s0)
    80206454:	fe442783          	lw	a5,-28(s0)
    80206458:	863a                	mv	a2,a4
    8020645a:	85be                	mv	a1,a5
    8020645c:	0000f517          	auipc	a0,0xf
    80206460:	66c50513          	addi	a0,a0,1644 # 80215ac8 <simple_user_task_bin+0x700>
    80206464:	ffffb097          	auipc	ra,0xffffb
    80206468:	830080e7          	jalr	-2000(ra) # 80200c94 <printf>
    print_proc_table();
    8020646c:	fffff097          	auipc	ra,0xfffff
    80206470:	634080e7          	jalr	1588(ra) # 80205aa0 <print_proc_table>
    printf("\n----- 第二阶段：测试用户进程创建与管理 -----\n");
    80206474:	0000f517          	auipc	a0,0xf
    80206478:	68c50513          	addi	a0,a0,1676 # 80215b00 <simple_user_task_bin+0x738>
    8020647c:	ffffb097          	auipc	ra,0xffffb
    80206480:	818080e7          	jalr	-2024(ra) # 80200c94 <printf>
    int user_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206484:	06400793          	li	a5,100
    80206488:	2781                	sext.w	a5,a5
    8020648a:	85be                	mv	a1,a5
    8020648c:	0000f517          	auipc	a0,0xf
    80206490:	f3c50513          	addi	a0,a0,-196 # 802153c8 <simple_user_task_bin>
    80206494:	fffff097          	auipc	ra,0xfffff
    80206498:	d38080e7          	jalr	-712(ra) # 802051cc <create_user_proc>
    8020649c:	87aa                	mv	a5,a0
    8020649e:	faf42623          	sw	a5,-84(s0)
    if (user_pid > 0) {
    802064a2:	fac42783          	lw	a5,-84(s0)
    802064a6:	2781                	sext.w	a5,a5
    802064a8:	02f05c63          	blez	a5,802064e0 <test_process_creation+0x22c>
        printf("【测试结果】: 基本用户进程创建成功，PID: %d\n", user_pid);
    802064ac:	fac42783          	lw	a5,-84(s0)
    802064b0:	85be                	mv	a1,a5
    802064b2:	0000f517          	auipc	a0,0xf
    802064b6:	68e50513          	addi	a0,a0,1678 # 80215b40 <simple_user_task_bin+0x778>
    802064ba:	ffffa097          	auipc	ra,0xffffa
    802064be:	7da080e7          	jalr	2010(ra) # 80200c94 <printf>
    printf("\n----- 用用户进程填满进程表 -----\n");
    802064c2:	0000f517          	auipc	a0,0xf
    802064c6:	6ee50513          	addi	a0,a0,1774 # 80215bb0 <simple_user_task_bin+0x7e8>
    802064ca:	ffffa097          	auipc	ra,0xffffa
    802064ce:	7ca080e7          	jalr	1994(ra) # 80200c94 <printf>
    int user_count = 1; // 已经创建了一个
    802064d2:	4785                	li	a5,1
    802064d4:	fcf42e23          	sw	a5,-36(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    802064d8:	4785                	li	a5,1
    802064da:	fcf42c23          	sw	a5,-40(s0)
    802064de:	a841                	j	8020656e <test_process_creation+0x2ba>
        printf("【错误】: 基本用户进程创建失败\n");
    802064e0:	0000f517          	auipc	a0,0xf
    802064e4:	6a050513          	addi	a0,a0,1696 # 80215b80 <simple_user_task_bin+0x7b8>
    802064e8:	ffffa097          	auipc	ra,0xffffa
    802064ec:	7ac080e7          	jalr	1964(ra) # 80200c94 <printf>
        return;
    802064f0:	a615                	j	80206814 <test_process_creation+0x560>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    802064f2:	06400793          	li	a5,100
    802064f6:	2781                	sext.w	a5,a5
    802064f8:	85be                	mv	a1,a5
    802064fa:	0000f517          	auipc	a0,0xf
    802064fe:	ece50513          	addi	a0,a0,-306 # 802153c8 <simple_user_task_bin>
    80206502:	fffff097          	auipc	ra,0xfffff
    80206506:	cca080e7          	jalr	-822(ra) # 802051cc <create_user_proc>
    8020650a:	87aa                	mv	a5,a0
    8020650c:	faf42423          	sw	a5,-88(s0)
        if (new_pid > 0) {
    80206510:	fa842783          	lw	a5,-88(s0)
    80206514:	2781                	sext.w	a5,a5
    80206516:	02f05b63          	blez	a5,8020654c <test_process_creation+0x298>
            user_count++;
    8020651a:	fdc42783          	lw	a5,-36(s0)
    8020651e:	2785                	addiw	a5,a5,1
    80206520:	fcf42e23          	sw	a5,-36(s0)
            if (user_count % 5 == 0) { // 每5个进程打印一次进度
    80206524:	fdc42783          	lw	a5,-36(s0)
    80206528:	873e                	mv	a4,a5
    8020652a:	4795                	li	a5,5
    8020652c:	02f767bb          	remw	a5,a4,a5
    80206530:	2781                	sext.w	a5,a5
    80206532:	eb8d                	bnez	a5,80206564 <test_process_creation+0x2b0>
                printf("已创建 %d 个用户进程...\n", user_count);
    80206534:	fdc42783          	lw	a5,-36(s0)
    80206538:	85be                	mv	a1,a5
    8020653a:	0000f517          	auipc	a0,0xf
    8020653e:	6a650513          	addi	a0,a0,1702 # 80215be0 <simple_user_task_bin+0x818>
    80206542:	ffffa097          	auipc	ra,0xffffa
    80206546:	752080e7          	jalr	1874(ra) # 80200c94 <printf>
    8020654a:	a829                	j	80206564 <test_process_creation+0x2b0>
            warning("process table was full at %d user processes\n", user_count);
    8020654c:	fdc42783          	lw	a5,-36(s0)
    80206550:	85be                	mv	a1,a5
    80206552:	0000f517          	auipc	a0,0xf
    80206556:	6b650513          	addi	a0,a0,1718 # 80215c08 <simple_user_task_bin+0x840>
    8020655a:	ffffb097          	auipc	ra,0xffffb
    8020655e:	1ba080e7          	jalr	442(ra) # 80201714 <warning>
            break;
    80206562:	a829                	j	8020657c <test_process_creation+0x2c8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206564:	fd842783          	lw	a5,-40(s0)
    80206568:	2785                	addiw	a5,a5,1
    8020656a:	fcf42c23          	sw	a5,-40(s0)
    8020656e:	fd842783          	lw	a5,-40(s0)
    80206572:	0007871b          	sext.w	a4,a5
    80206576:	47fd                	li	a5,31
    80206578:	f6e7dde3          	bge	a5,a4,802064f2 <test_process_creation+0x23e>
    printf("【测试结果】: 成功创建 %d 个用户进程 (最大限制: %d)\n", user_count, PROC);
    8020657c:	fdc42783          	lw	a5,-36(s0)
    80206580:	02000613          	li	a2,32
    80206584:	85be                	mv	a1,a5
    80206586:	0000f517          	auipc	a0,0xf
    8020658a:	6b250513          	addi	a0,a0,1714 # 80215c38 <simple_user_task_bin+0x870>
    8020658e:	ffffa097          	auipc	ra,0xffffa
    80206592:	706080e7          	jalr	1798(ra) # 80200c94 <printf>
    print_proc_table();
    80206596:	fffff097          	auipc	ra,0xfffff
    8020659a:	50a080e7          	jalr	1290(ra) # 80205aa0 <print_proc_table>
    printf("\n----- 等待并清理所有用户进程 -----\n");
    8020659e:	0000f517          	auipc	a0,0xf
    802065a2:	6e250513          	addi	a0,a0,1762 # 80215c80 <simple_user_task_bin+0x8b8>
    802065a6:	ffffa097          	auipc	ra,0xffffa
    802065aa:	6ee080e7          	jalr	1774(ra) # 80200c94 <printf>
    int user_success_count = 0;
    802065ae:	fc042a23          	sw	zero,-44(s0)
    for (int i = 0; i < user_count; i++) {
    802065b2:	fc042823          	sw	zero,-48(s0)
    802065b6:	a895                	j	8020662a <test_process_creation+0x376>
        int waited_pid = wait_proc(NULL);
    802065b8:	4501                	li	a0,0
    802065ba:	fffff097          	auipc	ra,0xfffff
    802065be:	358080e7          	jalr	856(ra) # 80205912 <wait_proc>
    802065c2:	87aa                	mv	a5,a0
    802065c4:	f8f42823          	sw	a5,-112(s0)
        if (waited_pid > 0) {
    802065c8:	f9042783          	lw	a5,-112(s0)
    802065cc:	2781                	sext.w	a5,a5
    802065ce:	02f05e63          	blez	a5,8020660a <test_process_creation+0x356>
            user_success_count++;
    802065d2:	fd442783          	lw	a5,-44(s0)
    802065d6:	2785                	addiw	a5,a5,1
    802065d8:	fcf42a23          	sw	a5,-44(s0)
            if (user_success_count % 5 == 0) { // 每5个进程打印一次进度
    802065dc:	fd442783          	lw	a5,-44(s0)
    802065e0:	873e                	mv	a4,a5
    802065e2:	4795                	li	a5,5
    802065e4:	02f767bb          	remw	a5,a4,a5
    802065e8:	2781                	sext.w	a5,a5
    802065ea:	eb9d                	bnez	a5,80206620 <test_process_creation+0x36c>
                printf("已回收 %d/%d 个用户进程...\n", user_success_count, user_count);
    802065ec:	fdc42703          	lw	a4,-36(s0)
    802065f0:	fd442783          	lw	a5,-44(s0)
    802065f4:	863a                	mv	a2,a4
    802065f6:	85be                	mv	a1,a5
    802065f8:	0000f517          	auipc	a0,0xf
    802065fc:	6b850513          	addi	a0,a0,1720 # 80215cb0 <simple_user_task_bin+0x8e8>
    80206600:	ffffa097          	auipc	ra,0xffffa
    80206604:	694080e7          	jalr	1684(ra) # 80200c94 <printf>
    80206608:	a821                	j	80206620 <test_process_creation+0x36c>
            printf("【错误】: 等待用户进程失败，错误码: %d\n", waited_pid);
    8020660a:	f9042783          	lw	a5,-112(s0)
    8020660e:	85be                	mv	a1,a5
    80206610:	0000f517          	auipc	a0,0xf
    80206614:	6c850513          	addi	a0,a0,1736 # 80215cd8 <simple_user_task_bin+0x910>
    80206618:	ffffa097          	auipc	ra,0xffffa
    8020661c:	67c080e7          	jalr	1660(ra) # 80200c94 <printf>
    for (int i = 0; i < user_count; i++) {
    80206620:	fd042783          	lw	a5,-48(s0)
    80206624:	2785                	addiw	a5,a5,1
    80206626:	fcf42823          	sw	a5,-48(s0)
    8020662a:	fd042783          	lw	a5,-48(s0)
    8020662e:	873e                	mv	a4,a5
    80206630:	fdc42783          	lw	a5,-36(s0)
    80206634:	2701                	sext.w	a4,a4
    80206636:	2781                	sext.w	a5,a5
    80206638:	f8f740e3          	blt	a4,a5,802065b8 <test_process_creation+0x304>
    printf("【测试结果】: 回收 %d/%d 个用户进程\n", user_success_count, user_count);
    8020663c:	fdc42703          	lw	a4,-36(s0)
    80206640:	fd442783          	lw	a5,-44(s0)
    80206644:	863a                	mv	a2,a4
    80206646:	85be                	mv	a1,a5
    80206648:	0000f517          	auipc	a0,0xf
    8020664c:	6c850513          	addi	a0,a0,1736 # 80215d10 <simple_user_task_bin+0x948>
    80206650:	ffffa097          	auipc	ra,0xffffa
    80206654:	644080e7          	jalr	1604(ra) # 80200c94 <printf>
    print_proc_table();
    80206658:	fffff097          	auipc	ra,0xfffff
    8020665c:	448080e7          	jalr	1096(ra) # 80205aa0 <print_proc_table>
    printf("\n----- 第三阶段：混合进程测试 -----\n");
    80206660:	0000f517          	auipc	a0,0xf
    80206664:	6e850513          	addi	a0,a0,1768 # 80215d48 <simple_user_task_bin+0x980>
    80206668:	ffffa097          	auipc	ra,0xffffa
    8020666c:	62c080e7          	jalr	1580(ra) # 80200c94 <printf>
    int mixed_kernel_count = 0;
    80206670:	fc042623          	sw	zero,-52(s0)
    int mixed_user_count = 0;
    80206674:	fc042423          	sw	zero,-56(s0)
    int target_count = PROC / 2;
    80206678:	47c1                	li	a5,16
    8020667a:	faf42223          	sw	a5,-92(s0)
    printf("创建 %d 个内核进程和 %d 个用户进程...\n", target_count, target_count);
    8020667e:	fa442703          	lw	a4,-92(s0)
    80206682:	fa442783          	lw	a5,-92(s0)
    80206686:	863a                	mv	a2,a4
    80206688:	85be                	mv	a1,a5
    8020668a:	0000f517          	auipc	a0,0xf
    8020668e:	6ee50513          	addi	a0,a0,1774 # 80215d78 <simple_user_task_bin+0x9b0>
    80206692:	ffffa097          	auipc	ra,0xffffa
    80206696:	602080e7          	jalr	1538(ra) # 80200c94 <printf>
    for (int i = 0; i < target_count; i++) {
    8020669a:	fc042223          	sw	zero,-60(s0)
    8020669e:	a81d                	j	802066d4 <test_process_creation+0x420>
        int new_pid = create_kernel_proc(simple_task);
    802066a0:	00000517          	auipc	a0,0x0
    802066a4:	be450513          	addi	a0,a0,-1052 # 80206284 <simple_task>
    802066a8:	fffff097          	auipc	ra,0xfffff
    802066ac:	a38080e7          	jalr	-1480(ra) # 802050e0 <create_kernel_proc>
    802066b0:	87aa                	mv	a5,a0
    802066b2:	faf42023          	sw	a5,-96(s0)
        if (new_pid > 0) {
    802066b6:	fa042783          	lw	a5,-96(s0)
    802066ba:	2781                	sext.w	a5,a5
    802066bc:	02f05663          	blez	a5,802066e8 <test_process_creation+0x434>
            mixed_kernel_count++;
    802066c0:	fcc42783          	lw	a5,-52(s0)
    802066c4:	2785                	addiw	a5,a5,1
    802066c6:	fcf42623          	sw	a5,-52(s0)
    for (int i = 0; i < target_count; i++) {
    802066ca:	fc442783          	lw	a5,-60(s0)
    802066ce:	2785                	addiw	a5,a5,1
    802066d0:	fcf42223          	sw	a5,-60(s0)
    802066d4:	fc442783          	lw	a5,-60(s0)
    802066d8:	873e                	mv	a4,a5
    802066da:	fa442783          	lw	a5,-92(s0)
    802066de:	2701                	sext.w	a4,a4
    802066e0:	2781                	sext.w	a5,a5
    802066e2:	faf74fe3          	blt	a4,a5,802066a0 <test_process_creation+0x3ec>
    802066e6:	a011                	j	802066ea <test_process_creation+0x436>
            break;
    802066e8:	0001                	nop
    for (int i = 0; i < target_count; i++) {
    802066ea:	fc042023          	sw	zero,-64(s0)
    802066ee:	a83d                	j	8020672c <test_process_creation+0x478>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    802066f0:	06400793          	li	a5,100
    802066f4:	2781                	sext.w	a5,a5
    802066f6:	85be                	mv	a1,a5
    802066f8:	0000f517          	auipc	a0,0xf
    802066fc:	cd050513          	addi	a0,a0,-816 # 802153c8 <simple_user_task_bin>
    80206700:	fffff097          	auipc	ra,0xfffff
    80206704:	acc080e7          	jalr	-1332(ra) # 802051cc <create_user_proc>
    80206708:	87aa                	mv	a5,a0
    8020670a:	f8f42e23          	sw	a5,-100(s0)
        if (new_pid > 0) {
    8020670e:	f9c42783          	lw	a5,-100(s0)
    80206712:	2781                	sext.w	a5,a5
    80206714:	02f05663          	blez	a5,80206740 <test_process_creation+0x48c>
            mixed_user_count++;
    80206718:	fc842783          	lw	a5,-56(s0)
    8020671c:	2785                	addiw	a5,a5,1
    8020671e:	fcf42423          	sw	a5,-56(s0)
    for (int i = 0; i < target_count; i++) {
    80206722:	fc042783          	lw	a5,-64(s0)
    80206726:	2785                	addiw	a5,a5,1
    80206728:	fcf42023          	sw	a5,-64(s0)
    8020672c:	fc042783          	lw	a5,-64(s0)
    80206730:	873e                	mv	a4,a5
    80206732:	fa442783          	lw	a5,-92(s0)
    80206736:	2701                	sext.w	a4,a4
    80206738:	2781                	sext.w	a5,a5
    8020673a:	faf74be3          	blt	a4,a5,802066f0 <test_process_creation+0x43c>
    8020673e:	a011                	j	80206742 <test_process_creation+0x48e>
            break;
    80206740:	0001                	nop
    printf("【混合测试结果】: 创建了 %d 个内核进程 + %d 个用户进程 = %d 个进程\n", 
    80206742:	fcc42783          	lw	a5,-52(s0)
    80206746:	873e                	mv	a4,a5
    80206748:	fc842783          	lw	a5,-56(s0)
    8020674c:	9fb9                	addw	a5,a5,a4
    8020674e:	0007869b          	sext.w	a3,a5
    80206752:	fc842703          	lw	a4,-56(s0)
    80206756:	fcc42783          	lw	a5,-52(s0)
    8020675a:	863a                	mv	a2,a4
    8020675c:	85be                	mv	a1,a5
    8020675e:	0000f517          	auipc	a0,0xf
    80206762:	65250513          	addi	a0,a0,1618 # 80215db0 <simple_user_task_bin+0x9e8>
    80206766:	ffffa097          	auipc	ra,0xffffa
    8020676a:	52e080e7          	jalr	1326(ra) # 80200c94 <printf>
    print_proc_table();
    8020676e:	fffff097          	auipc	ra,0xfffff
    80206772:	332080e7          	jalr	818(ra) # 80205aa0 <print_proc_table>
    printf("\n----- 清理混合进程 -----\n");
    80206776:	0000f517          	auipc	a0,0xf
    8020677a:	69a50513          	addi	a0,a0,1690 # 80215e10 <simple_user_task_bin+0xa48>
    8020677e:	ffffa097          	auipc	ra,0xffffa
    80206782:	516080e7          	jalr	1302(ra) # 80200c94 <printf>
    int mixed_success_count = 0;
    80206786:	fa042e23          	sw	zero,-68(s0)
    int total_mixed = mixed_kernel_count + mixed_user_count;
    8020678a:	fcc42783          	lw	a5,-52(s0)
    8020678e:	873e                	mv	a4,a5
    80206790:	fc842783          	lw	a5,-56(s0)
    80206794:	9fb9                	addw	a5,a5,a4
    80206796:	f8f42c23          	sw	a5,-104(s0)
    for (int i = 0; i < total_mixed; i++) {
    8020679a:	fa042c23          	sw	zero,-72(s0)
    8020679e:	a805                	j	802067ce <test_process_creation+0x51a>
        int waited_pid = wait_proc(NULL);
    802067a0:	4501                	li	a0,0
    802067a2:	fffff097          	auipc	ra,0xfffff
    802067a6:	170080e7          	jalr	368(ra) # 80205912 <wait_proc>
    802067aa:	87aa                	mv	a5,a0
    802067ac:	f8f42a23          	sw	a5,-108(s0)
        if (waited_pid > 0) {
    802067b0:	f9442783          	lw	a5,-108(s0)
    802067b4:	2781                	sext.w	a5,a5
    802067b6:	00f05763          	blez	a5,802067c4 <test_process_creation+0x510>
            mixed_success_count++;
    802067ba:	fbc42783          	lw	a5,-68(s0)
    802067be:	2785                	addiw	a5,a5,1
    802067c0:	faf42e23          	sw	a5,-68(s0)
    for (int i = 0; i < total_mixed; i++) {
    802067c4:	fb842783          	lw	a5,-72(s0)
    802067c8:	2785                	addiw	a5,a5,1
    802067ca:	faf42c23          	sw	a5,-72(s0)
    802067ce:	fb842783          	lw	a5,-72(s0)
    802067d2:	873e                	mv	a4,a5
    802067d4:	f9842783          	lw	a5,-104(s0)
    802067d8:	2701                	sext.w	a4,a4
    802067da:	2781                	sext.w	a5,a5
    802067dc:	fcf742e3          	blt	a4,a5,802067a0 <test_process_creation+0x4ec>
    printf("【混合测试结果】: 回收 %d/%d 个混合进程\n", mixed_success_count, total_mixed);
    802067e0:	f9842703          	lw	a4,-104(s0)
    802067e4:	fbc42783          	lw	a5,-68(s0)
    802067e8:	863a                	mv	a2,a4
    802067ea:	85be                	mv	a1,a5
    802067ec:	0000f517          	auipc	a0,0xf
    802067f0:	64c50513          	addi	a0,a0,1612 # 80215e38 <simple_user_task_bin+0xa70>
    802067f4:	ffffa097          	auipc	ra,0xffffa
    802067f8:	4a0080e7          	jalr	1184(ra) # 80200c94 <printf>
    print_proc_table();
    802067fc:	fffff097          	auipc	ra,0xfffff
    80206800:	2a4080e7          	jalr	676(ra) # 80205aa0 <print_proc_table>
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    80206804:	0000f517          	auipc	a0,0xf
    80206808:	66c50513          	addi	a0,a0,1644 # 80215e70 <simple_user_task_bin+0xaa8>
    8020680c:	ffffa097          	auipc	ra,0xffffa
    80206810:	488080e7          	jalr	1160(ra) # 80200c94 <printf>
}
    80206814:	70e6                	ld	ra,120(sp)
    80206816:	7446                	ld	s0,112(sp)
    80206818:	6109                	addi	sp,sp,128
    8020681a:	8082                	ret

000000008020681c <test_user_fork>:
void test_user_fork(void) {
    8020681c:	1101                	addi	sp,sp,-32
    8020681e:	ec06                	sd	ra,24(sp)
    80206820:	e822                	sd	s0,16(sp)
    80206822:	1000                	addi	s0,sp,32
    printf("===== 测试开始: 用户进程Fork测试 =====\n");
    80206824:	0000f517          	auipc	a0,0xf
    80206828:	68450513          	addi	a0,a0,1668 # 80215ea8 <simple_user_task_bin+0xae0>
    8020682c:	ffffa097          	auipc	ra,0xffffa
    80206830:	468080e7          	jalr	1128(ra) # 80200c94 <printf>
    printf("\n----- 创建fork测试进程 -----\n");
    80206834:	0000f517          	auipc	a0,0xf
    80206838:	6ac50513          	addi	a0,a0,1708 # 80215ee0 <simple_user_task_bin+0xb18>
    8020683c:	ffffa097          	auipc	ra,0xffffa
    80206840:	458080e7          	jalr	1112(ra) # 80200c94 <printf>
    int fork_test_pid = create_user_proc(fork_user_test_bin, fork_user_test_bin_len);
    80206844:	6785                	lui	a5,0x1
    80206846:	8c878793          	addi	a5,a5,-1848 # 8c8 <_entry-0x801ff738>
    8020684a:	2781                	sext.w	a5,a5
    8020684c:	85be                	mv	a1,a5
    8020684e:	0000e517          	auipc	a0,0xe
    80206852:	df250513          	addi	a0,a0,-526 # 80214640 <fork_user_test_bin>
    80206856:	fffff097          	auipc	ra,0xfffff
    8020685a:	976080e7          	jalr	-1674(ra) # 802051cc <create_user_proc>
    8020685e:	87aa                	mv	a5,a0
    80206860:	fef42623          	sw	a5,-20(s0)
    if (fork_test_pid < 0) {
    80206864:	fec42783          	lw	a5,-20(s0)
    80206868:	2781                	sext.w	a5,a5
    8020686a:	0007db63          	bgez	a5,80206880 <test_user_fork+0x64>
        printf("【错误】: 创建fork测试进程失败\n");
    8020686e:	0000f517          	auipc	a0,0xf
    80206872:	69a50513          	addi	a0,a0,1690 # 80215f08 <simple_user_task_bin+0xb40>
    80206876:	ffffa097          	auipc	ra,0xffffa
    8020687a:	41e080e7          	jalr	1054(ra) # 80200c94 <printf>
    8020687e:	a865                	j	80206936 <test_user_fork+0x11a>
    printf("【测试结果】: 创建fork测试进程成功，PID: %d\n", fork_test_pid);
    80206880:	fec42783          	lw	a5,-20(s0)
    80206884:	85be                	mv	a1,a5
    80206886:	0000f517          	auipc	a0,0xf
    8020688a:	6b250513          	addi	a0,a0,1714 # 80215f38 <simple_user_task_bin+0xb70>
    8020688e:	ffffa097          	auipc	ra,0xffffa
    80206892:	406080e7          	jalr	1030(ra) # 80200c94 <printf>
    printf("\n----- 等待fork测试进程完成 -----\n");
    80206896:	0000f517          	auipc	a0,0xf
    8020689a:	6e250513          	addi	a0,a0,1762 # 80215f78 <simple_user_task_bin+0xbb0>
    8020689e:	ffffa097          	auipc	ra,0xffffa
    802068a2:	3f6080e7          	jalr	1014(ra) # 80200c94 <printf>
    int waited_pid = wait_proc(&status);
    802068a6:	fe440793          	addi	a5,s0,-28
    802068aa:	853e                	mv	a0,a5
    802068ac:	fffff097          	auipc	ra,0xfffff
    802068b0:	066080e7          	jalr	102(ra) # 80205912 <wait_proc>
    802068b4:	87aa                	mv	a5,a0
    802068b6:	fef42423          	sw	a5,-24(s0)
    if (waited_pid == fork_test_pid) {
    802068ba:	fe842783          	lw	a5,-24(s0)
    802068be:	873e                	mv	a4,a5
    802068c0:	fec42783          	lw	a5,-20(s0)
    802068c4:	2701                	sext.w	a4,a4
    802068c6:	2781                	sext.w	a5,a5
    802068c8:	02f71963          	bne	a4,a5,802068fa <test_user_fork+0xde>
        printf("【测试结果】: fork测试进程(PID: %d)完成，状态码: %d\n", fork_test_pid, status);
    802068cc:	fe442703          	lw	a4,-28(s0)
    802068d0:	fec42783          	lw	a5,-20(s0)
    802068d4:	863a                	mv	a2,a4
    802068d6:	85be                	mv	a1,a5
    802068d8:	0000f517          	auipc	a0,0xf
    802068dc:	6d050513          	addi	a0,a0,1744 # 80215fa8 <simple_user_task_bin+0xbe0>
    802068e0:	ffffa097          	auipc	ra,0xffffa
    802068e4:	3b4080e7          	jalr	948(ra) # 80200c94 <printf>
        printf("✓ Fork测试: 通过\n");
    802068e8:	0000f517          	auipc	a0,0xf
    802068ec:	70850513          	addi	a0,a0,1800 # 80215ff0 <simple_user_task_bin+0xc28>
    802068f0:	ffffa097          	auipc	ra,0xffffa
    802068f4:	3a4080e7          	jalr	932(ra) # 80200c94 <printf>
    802068f8:	a03d                	j	80206926 <test_user_fork+0x10a>
        printf("【错误】: 等待fork测试进程时出错，等待到PID: %d，期望PID: %d\n", waited_pid, fork_test_pid);
    802068fa:	fec42703          	lw	a4,-20(s0)
    802068fe:	fe842783          	lw	a5,-24(s0)
    80206902:	863a                	mv	a2,a4
    80206904:	85be                	mv	a1,a5
    80206906:	0000f517          	auipc	a0,0xf
    8020690a:	70250513          	addi	a0,a0,1794 # 80216008 <simple_user_task_bin+0xc40>
    8020690e:	ffffa097          	auipc	ra,0xffffa
    80206912:	386080e7          	jalr	902(ra) # 80200c94 <printf>
        printf("✗ Fork测试: 失败\n");
    80206916:	0000f517          	auipc	a0,0xf
    8020691a:	74a50513          	addi	a0,a0,1866 # 80216060 <simple_user_task_bin+0xc98>
    8020691e:	ffffa097          	auipc	ra,0xffffa
    80206922:	376080e7          	jalr	886(ra) # 80200c94 <printf>
    printf("===== 测试结束: 用户进程Fork测试 =====\n");
    80206926:	0000f517          	auipc	a0,0xf
    8020692a:	75250513          	addi	a0,a0,1874 # 80216078 <simple_user_task_bin+0xcb0>
    8020692e:	ffffa097          	auipc	ra,0xffffa
    80206932:	366080e7          	jalr	870(ra) # 80200c94 <printf>
}
    80206936:	60e2                	ld	ra,24(sp)
    80206938:	6442                	ld	s0,16(sp)
    8020693a:	6105                	addi	sp,sp,32
    8020693c:	8082                	ret

000000008020693e <cpu_intensive_task>:
void cpu_intensive_task(void) {
    8020693e:	1101                	addi	sp,sp,-32
    80206940:	ec06                	sd	ra,24(sp)
    80206942:	e822                	sd	s0,16(sp)
    80206944:	1000                	addi	s0,sp,32
    uint64 sum = 0;
    80206946:	fe043423          	sd	zero,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    8020694a:	fe043023          	sd	zero,-32(s0)
    8020694e:	a829                	j	80206968 <cpu_intensive_task+0x2a>
        sum += i;
    80206950:	fe843703          	ld	a4,-24(s0)
    80206954:	fe043783          	ld	a5,-32(s0)
    80206958:	97ba                	add	a5,a5,a4
    8020695a:	fef43423          	sd	a5,-24(s0)
    for (uint64 i = 0; i < 10000000; i++) {
    8020695e:	fe043783          	ld	a5,-32(s0)
    80206962:	0785                	addi	a5,a5,1
    80206964:	fef43023          	sd	a5,-32(s0)
    80206968:	fe043703          	ld	a4,-32(s0)
    8020696c:	009897b7          	lui	a5,0x989
    80206970:	67f78793          	addi	a5,a5,1663 # 98967f <_entry-0x7f876981>
    80206974:	fce7fee3          	bgeu	a5,a4,80206950 <cpu_intensive_task+0x12>
    printf("CPU intensive task done in PID %d, sum=%lu\n", myproc()->pid, sum);
    80206978:	ffffe097          	auipc	ra,0xffffe
    8020697c:	128080e7          	jalr	296(ra) # 80204aa0 <myproc>
    80206980:	87aa                	mv	a5,a0
    80206982:	43dc                	lw	a5,4(a5)
    80206984:	fe843603          	ld	a2,-24(s0)
    80206988:	85be                	mv	a1,a5
    8020698a:	0000f517          	auipc	a0,0xf
    8020698e:	72650513          	addi	a0,a0,1830 # 802160b0 <simple_user_task_bin+0xce8>
    80206992:	ffffa097          	auipc	ra,0xffffa
    80206996:	302080e7          	jalr	770(ra) # 80200c94 <printf>
    exit_proc(0);
    8020699a:	4501                	li	a0,0
    8020699c:	fffff097          	auipc	ra,0xfffff
    802069a0:	eac080e7          	jalr	-340(ra) # 80205848 <exit_proc>
}
    802069a4:	0001                	nop
    802069a6:	60e2                	ld	ra,24(sp)
    802069a8:	6442                	ld	s0,16(sp)
    802069aa:	6105                	addi	sp,sp,32
    802069ac:	8082                	ret

00000000802069ae <test_scheduler>:
void test_scheduler(void) {
    802069ae:	7179                	addi	sp,sp,-48
    802069b0:	f406                	sd	ra,40(sp)
    802069b2:	f022                	sd	s0,32(sp)
    802069b4:	1800                	addi	s0,sp,48
    printf("===== 测试开始: 调度器测试 =====\n");
    802069b6:	0000f517          	auipc	a0,0xf
    802069ba:	72a50513          	addi	a0,a0,1834 # 802160e0 <simple_user_task_bin+0xd18>
    802069be:	ffffa097          	auipc	ra,0xffffa
    802069c2:	2d6080e7          	jalr	726(ra) # 80200c94 <printf>
    for (int i = 0; i < 3; i++) {
    802069c6:	fe042623          	sw	zero,-20(s0)
    802069ca:	a831                	j	802069e6 <test_scheduler+0x38>
        create_kernel_proc(cpu_intensive_task);
    802069cc:	00000517          	auipc	a0,0x0
    802069d0:	f7250513          	addi	a0,a0,-142 # 8020693e <cpu_intensive_task>
    802069d4:	ffffe097          	auipc	ra,0xffffe
    802069d8:	70c080e7          	jalr	1804(ra) # 802050e0 <create_kernel_proc>
    for (int i = 0; i < 3; i++) {
    802069dc:	fec42783          	lw	a5,-20(s0)
    802069e0:	2785                	addiw	a5,a5,1
    802069e2:	fef42623          	sw	a5,-20(s0)
    802069e6:	fec42783          	lw	a5,-20(s0)
    802069ea:	0007871b          	sext.w	a4,a5
    802069ee:	4789                	li	a5,2
    802069f0:	fce7dee3          	bge	a5,a4,802069cc <test_scheduler+0x1e>
    uint64 start_time = get_time();
    802069f4:	fffff097          	auipc	ra,0xfffff
    802069f8:	496080e7          	jalr	1174(ra) # 80205e8a <get_time>
    802069fc:	fea43023          	sd	a0,-32(s0)
	for (int i = 0; i < 3; i++) {
    80206a00:	fe042423          	sw	zero,-24(s0)
    80206a04:	a819                	j	80206a1a <test_scheduler+0x6c>
    	wait_proc(NULL); // 等待所有子进程结束
    80206a06:	4501                	li	a0,0
    80206a08:	fffff097          	auipc	ra,0xfffff
    80206a0c:	f0a080e7          	jalr	-246(ra) # 80205912 <wait_proc>
	for (int i = 0; i < 3; i++) {
    80206a10:	fe842783          	lw	a5,-24(s0)
    80206a14:	2785                	addiw	a5,a5,1
    80206a16:	fef42423          	sw	a5,-24(s0)
    80206a1a:	fe842783          	lw	a5,-24(s0)
    80206a1e:	0007871b          	sext.w	a4,a5
    80206a22:	4789                	li	a5,2
    80206a24:	fee7d1e3          	bge	a5,a4,80206a06 <test_scheduler+0x58>
    uint64 end_time = get_time();
    80206a28:	fffff097          	auipc	ra,0xfffff
    80206a2c:	462080e7          	jalr	1122(ra) # 80205e8a <get_time>
    80206a30:	fca43c23          	sd	a0,-40(s0)
    printf("Scheduler test completed in %lu cycles\n", end_time - start_time);
    80206a34:	fd843703          	ld	a4,-40(s0)
    80206a38:	fe043783          	ld	a5,-32(s0)
    80206a3c:	40f707b3          	sub	a5,a4,a5
    80206a40:	85be                	mv	a1,a5
    80206a42:	0000f517          	auipc	a0,0xf
    80206a46:	6ce50513          	addi	a0,a0,1742 # 80216110 <simple_user_task_bin+0xd48>
    80206a4a:	ffffa097          	auipc	ra,0xffffa
    80206a4e:	24a080e7          	jalr	586(ra) # 80200c94 <printf>
    printf("===== 测试结束 =====\n");
    80206a52:	0000f517          	auipc	a0,0xf
    80206a56:	6e650513          	addi	a0,a0,1766 # 80216138 <simple_user_task_bin+0xd70>
    80206a5a:	ffffa097          	auipc	ra,0xffffa
    80206a5e:	23a080e7          	jalr	570(ra) # 80200c94 <printf>
}
    80206a62:	0001                	nop
    80206a64:	70a2                	ld	ra,40(sp)
    80206a66:	7402                	ld	s0,32(sp)
    80206a68:	6145                	addi	sp,sp,48
    80206a6a:	8082                	ret

0000000080206a6c <shared_buffer_init>:
void shared_buffer_init() {
    80206a6c:	1141                	addi	sp,sp,-16
    80206a6e:	e422                	sd	s0,8(sp)
    80206a70:	0800                	addi	s0,sp,16
    proc_buffer = 0;
    80206a72:	00012797          	auipc	a5,0x12
    80206a76:	c9678793          	addi	a5,a5,-874 # 80218708 <proc_buffer>
    80206a7a:	0007a023          	sw	zero,0(a5)
    proc_produced = 0;
    80206a7e:	00012797          	auipc	a5,0x12
    80206a82:	c8e78793          	addi	a5,a5,-882 # 8021870c <proc_produced>
    80206a86:	0007a023          	sw	zero,0(a5)
}
    80206a8a:	0001                	nop
    80206a8c:	6422                	ld	s0,8(sp)
    80206a8e:	0141                	addi	sp,sp,16
    80206a90:	8082                	ret

0000000080206a92 <producer_task>:
void producer_task(void) {
    80206a92:	1141                	addi	sp,sp,-16
    80206a94:	e406                	sd	ra,8(sp)
    80206a96:	e022                	sd	s0,0(sp)
    80206a98:	0800                	addi	s0,sp,16
    proc_buffer = 42;
    80206a9a:	00012797          	auipc	a5,0x12
    80206a9e:	c6e78793          	addi	a5,a5,-914 # 80218708 <proc_buffer>
    80206aa2:	02a00713          	li	a4,42
    80206aa6:	c398                	sw	a4,0(a5)
    proc_produced = 1;
    80206aa8:	00012797          	auipc	a5,0x12
    80206aac:	c6478793          	addi	a5,a5,-924 # 8021870c <proc_produced>
    80206ab0:	4705                	li	a4,1
    80206ab2:	c398                	sw	a4,0(a5)
    wakeup(&proc_produced); // 唤醒消费者
    80206ab4:	00012517          	auipc	a0,0x12
    80206ab8:	c5850513          	addi	a0,a0,-936 # 8021870c <proc_produced>
    80206abc:	fffff097          	auipc	ra,0xfffff
    80206ac0:	cbc080e7          	jalr	-836(ra) # 80205778 <wakeup>
    printf("Producer: produced value %d\n", proc_buffer);
    80206ac4:	00012797          	auipc	a5,0x12
    80206ac8:	c4478793          	addi	a5,a5,-956 # 80218708 <proc_buffer>
    80206acc:	439c                	lw	a5,0(a5)
    80206ace:	85be                	mv	a1,a5
    80206ad0:	0000f517          	auipc	a0,0xf
    80206ad4:	68850513          	addi	a0,a0,1672 # 80216158 <simple_user_task_bin+0xd90>
    80206ad8:	ffffa097          	auipc	ra,0xffffa
    80206adc:	1bc080e7          	jalr	444(ra) # 80200c94 <printf>
    exit_proc(0);
    80206ae0:	4501                	li	a0,0
    80206ae2:	fffff097          	auipc	ra,0xfffff
    80206ae6:	d66080e7          	jalr	-666(ra) # 80205848 <exit_proc>
}
    80206aea:	0001                	nop
    80206aec:	60a2                	ld	ra,8(sp)
    80206aee:	6402                	ld	s0,0(sp)
    80206af0:	0141                	addi	sp,sp,16
    80206af2:	8082                	ret

0000000080206af4 <consumer_task>:
void consumer_task(void) {
    80206af4:	1141                	addi	sp,sp,-16
    80206af6:	e406                	sd	ra,8(sp)
    80206af8:	e022                	sd	s0,0(sp)
    80206afa:	0800                	addi	s0,sp,16
    while (!proc_produced) {
    80206afc:	a809                	j	80206b0e <consumer_task+0x1a>
        sleep(&proc_produced); // 等待生产者
    80206afe:	00012517          	auipc	a0,0x12
    80206b02:	c0e50513          	addi	a0,a0,-1010 # 8021870c <proc_produced>
    80206b06:	fffff097          	auipc	ra,0xfffff
    80206b0a:	bda080e7          	jalr	-1062(ra) # 802056e0 <sleep>
    while (!proc_produced) {
    80206b0e:	00012797          	auipc	a5,0x12
    80206b12:	bfe78793          	addi	a5,a5,-1026 # 8021870c <proc_produced>
    80206b16:	439c                	lw	a5,0(a5)
    80206b18:	d3fd                	beqz	a5,80206afe <consumer_task+0xa>
    printf("Consumer: consumed value %d\n", proc_buffer);
    80206b1a:	00012797          	auipc	a5,0x12
    80206b1e:	bee78793          	addi	a5,a5,-1042 # 80218708 <proc_buffer>
    80206b22:	439c                	lw	a5,0(a5)
    80206b24:	85be                	mv	a1,a5
    80206b26:	0000f517          	auipc	a0,0xf
    80206b2a:	65250513          	addi	a0,a0,1618 # 80216178 <simple_user_task_bin+0xdb0>
    80206b2e:	ffffa097          	auipc	ra,0xffffa
    80206b32:	166080e7          	jalr	358(ra) # 80200c94 <printf>
    exit_proc(0);
    80206b36:	4501                	li	a0,0
    80206b38:	fffff097          	auipc	ra,0xfffff
    80206b3c:	d10080e7          	jalr	-752(ra) # 80205848 <exit_proc>
}
    80206b40:	0001                	nop
    80206b42:	60a2                	ld	ra,8(sp)
    80206b44:	6402                	ld	s0,0(sp)
    80206b46:	0141                	addi	sp,sp,16
    80206b48:	8082                	ret

0000000080206b4a <test_synchronization>:
void test_synchronization(void) {
    80206b4a:	1141                	addi	sp,sp,-16
    80206b4c:	e406                	sd	ra,8(sp)
    80206b4e:	e022                	sd	s0,0(sp)
    80206b50:	0800                	addi	s0,sp,16
    printf("===== 测试开始: 同步机制测试 =====\n");
    80206b52:	0000f517          	auipc	a0,0xf
    80206b56:	64650513          	addi	a0,a0,1606 # 80216198 <simple_user_task_bin+0xdd0>
    80206b5a:	ffffa097          	auipc	ra,0xffffa
    80206b5e:	13a080e7          	jalr	314(ra) # 80200c94 <printf>
    shared_buffer_init();
    80206b62:	00000097          	auipc	ra,0x0
    80206b66:	f0a080e7          	jalr	-246(ra) # 80206a6c <shared_buffer_init>
    create_kernel_proc(producer_task);
    80206b6a:	00000517          	auipc	a0,0x0
    80206b6e:	f2850513          	addi	a0,a0,-216 # 80206a92 <producer_task>
    80206b72:	ffffe097          	auipc	ra,0xffffe
    80206b76:	56e080e7          	jalr	1390(ra) # 802050e0 <create_kernel_proc>
    create_kernel_proc(consumer_task);
    80206b7a:	00000517          	auipc	a0,0x0
    80206b7e:	f7a50513          	addi	a0,a0,-134 # 80206af4 <consumer_task>
    80206b82:	ffffe097          	auipc	ra,0xffffe
    80206b86:	55e080e7          	jalr	1374(ra) # 802050e0 <create_kernel_proc>
    wait_proc(NULL);
    80206b8a:	4501                	li	a0,0
    80206b8c:	fffff097          	auipc	ra,0xfffff
    80206b90:	d86080e7          	jalr	-634(ra) # 80205912 <wait_proc>
    wait_proc(NULL);
    80206b94:	4501                	li	a0,0
    80206b96:	fffff097          	auipc	ra,0xfffff
    80206b9a:	d7c080e7          	jalr	-644(ra) # 80205912 <wait_proc>
    printf("===== 测试结束 =====\n");
    80206b9e:	0000f517          	auipc	a0,0xf
    80206ba2:	59a50513          	addi	a0,a0,1434 # 80216138 <simple_user_task_bin+0xd70>
    80206ba6:	ffffa097          	auipc	ra,0xffffa
    80206baa:	0ee080e7          	jalr	238(ra) # 80200c94 <printf>
}
    80206bae:	0001                	nop
    80206bb0:	60a2                	ld	ra,8(sp)
    80206bb2:	6402                	ld	s0,0(sp)
    80206bb4:	0141                	addi	sp,sp,16
    80206bb6:	8082                	ret

0000000080206bb8 <sys_access_task>:
void sys_access_task(void) {
    80206bb8:	1101                	addi	sp,sp,-32
    80206bba:	ec06                	sd	ra,24(sp)
    80206bbc:	e822                	sd	s0,16(sp)
    80206bbe:	1000                	addi	s0,sp,32
    volatile int *ptr = (int*)0x80200000; // 内核空间地址
    80206bc0:	40100793          	li	a5,1025
    80206bc4:	07d6                	slli	a5,a5,0x15
    80206bc6:	fef43423          	sd	a5,-24(s0)
    printf("SYS: try read kernel addr 0x80200000\n");
    80206bca:	0000f517          	auipc	a0,0xf
    80206bce:	5fe50513          	addi	a0,a0,1534 # 802161c8 <simple_user_task_bin+0xe00>
    80206bd2:	ffffa097          	auipc	ra,0xffffa
    80206bd6:	0c2080e7          	jalr	194(ra) # 80200c94 <printf>
    int val = *ptr;
    80206bda:	fe843783          	ld	a5,-24(s0)
    80206bde:	439c                	lw	a5,0(a5)
    80206be0:	fef42223          	sw	a5,-28(s0)
    printf("SYS: read success, value=%d\n", val);
    80206be4:	fe442783          	lw	a5,-28(s0)
    80206be8:	85be                	mv	a1,a5
    80206bea:	0000f517          	auipc	a0,0xf
    80206bee:	60650513          	addi	a0,a0,1542 # 802161f0 <simple_user_task_bin+0xe28>
    80206bf2:	ffffa097          	auipc	ra,0xffffa
    80206bf6:	0a2080e7          	jalr	162(ra) # 80200c94 <printf>
    exit_proc(0);
    80206bfa:	4501                	li	a0,0
    80206bfc:	fffff097          	auipc	ra,0xfffff
    80206c00:	c4c080e7          	jalr	-948(ra) # 80205848 <exit_proc>
}
    80206c04:	0001                	nop
    80206c06:	60e2                	ld	ra,24(sp)
    80206c08:	6442                	ld	s0,16(sp)
    80206c0a:	6105                	addi	sp,sp,32
    80206c0c:	8082                	ret

0000000080206c0e <infinite_task>:
void infinite_task(void){
    80206c0e:	1101                	addi	sp,sp,-32
    80206c10:	ec06                	sd	ra,24(sp)
    80206c12:	e822                	sd	s0,16(sp)
    80206c14:	1000                	addi	s0,sp,32
	int count = 5000 ;
    80206c16:	6785                	lui	a5,0x1
    80206c18:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    80206c1c:	fef42623          	sw	a5,-20(s0)
	while(count){
    80206c20:	a835                	j	80206c5c <infinite_task+0x4e>
		count--;
    80206c22:	fec42783          	lw	a5,-20(s0)
    80206c26:	37fd                	addiw	a5,a5,-1
    80206c28:	fef42623          	sw	a5,-20(s0)
		if (count % 100 == 0)
    80206c2c:	fec42783          	lw	a5,-20(s0)
    80206c30:	873e                	mv	a4,a5
    80206c32:	06400793          	li	a5,100
    80206c36:	02f767bb          	remw	a5,a4,a5
    80206c3a:	2781                	sext.w	a5,a5
    80206c3c:	ef81                	bnez	a5,80206c54 <infinite_task+0x46>
			printf("count for %d\n",count);
    80206c3e:	fec42783          	lw	a5,-20(s0)
    80206c42:	85be                	mv	a1,a5
    80206c44:	0000f517          	auipc	a0,0xf
    80206c48:	5cc50513          	addi	a0,a0,1484 # 80216210 <simple_user_task_bin+0xe48>
    80206c4c:	ffffa097          	auipc	ra,0xffffa
    80206c50:	048080e7          	jalr	72(ra) # 80200c94 <printf>
		yield();
    80206c54:	fffff097          	auipc	ra,0xfffff
    80206c58:	9e6080e7          	jalr	-1562(ra) # 8020563a <yield>
	while(count){
    80206c5c:	fec42783          	lw	a5,-20(s0)
    80206c60:	2781                	sext.w	a5,a5
    80206c62:	f3e1                	bnez	a5,80206c22 <infinite_task+0x14>
	warning("INFINITE TASK FINISH WITHOUT KILLED!!\n");
    80206c64:	0000f517          	auipc	a0,0xf
    80206c68:	5bc50513          	addi	a0,a0,1468 # 80216220 <simple_user_task_bin+0xe58>
    80206c6c:	ffffb097          	auipc	ra,0xffffb
    80206c70:	aa8080e7          	jalr	-1368(ra) # 80201714 <warning>
}
    80206c74:	0001                	nop
    80206c76:	60e2                	ld	ra,24(sp)
    80206c78:	6442                	ld	s0,16(sp)
    80206c7a:	6105                	addi	sp,sp,32
    80206c7c:	8082                	ret

0000000080206c7e <killer_task>:
void killer_task(uint64 kill_pid){
    80206c7e:	7179                	addi	sp,sp,-48
    80206c80:	f406                	sd	ra,40(sp)
    80206c82:	f022                	sd	s0,32(sp)
    80206c84:	1800                	addi	s0,sp,48
    80206c86:	fca43c23          	sd	a0,-40(s0)
	int count = 500;
    80206c8a:	1f400793          	li	a5,500
    80206c8e:	fef42623          	sw	a5,-20(s0)
	while(count){
    80206c92:	a81d                	j	80206cc8 <killer_task+0x4a>
		count--;
    80206c94:	fec42783          	lw	a5,-20(s0)
    80206c98:	37fd                	addiw	a5,a5,-1
    80206c9a:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    80206c9e:	fec42783          	lw	a5,-20(s0)
    80206ca2:	873e                	mv	a4,a5
    80206ca4:	06400793          	li	a5,100
    80206ca8:	02f767bb          	remw	a5,a4,a5
    80206cac:	2781                	sext.w	a5,a5
    80206cae:	eb89                	bnez	a5,80206cc0 <killer_task+0x42>
			printf("I see you!!!\n");
    80206cb0:	0000f517          	auipc	a0,0xf
    80206cb4:	59850513          	addi	a0,a0,1432 # 80216248 <simple_user_task_bin+0xe80>
    80206cb8:	ffffa097          	auipc	ra,0xffffa
    80206cbc:	fdc080e7          	jalr	-36(ra) # 80200c94 <printf>
		yield();
    80206cc0:	fffff097          	auipc	ra,0xfffff
    80206cc4:	97a080e7          	jalr	-1670(ra) # 8020563a <yield>
	while(count){
    80206cc8:	fec42783          	lw	a5,-20(s0)
    80206ccc:	2781                	sext.w	a5,a5
    80206cce:	f3f9                	bnez	a5,80206c94 <killer_task+0x16>
	kill_proc((int)kill_pid);
    80206cd0:	fd843783          	ld	a5,-40(s0)
    80206cd4:	2781                	sext.w	a5,a5
    80206cd6:	853e                	mv	a0,a5
    80206cd8:	fffff097          	auipc	ra,0xfffff
    80206cdc:	b0c080e7          	jalr	-1268(ra) # 802057e4 <kill_proc>
	printf("Killed proc %d\n",(int)kill_pid);
    80206ce0:	fd843783          	ld	a5,-40(s0)
    80206ce4:	2781                	sext.w	a5,a5
    80206ce6:	85be                	mv	a1,a5
    80206ce8:	0000f517          	auipc	a0,0xf
    80206cec:	57050513          	addi	a0,a0,1392 # 80216258 <simple_user_task_bin+0xe90>
    80206cf0:	ffffa097          	auipc	ra,0xffffa
    80206cf4:	fa4080e7          	jalr	-92(ra) # 80200c94 <printf>
	exit_proc(0);
    80206cf8:	4501                	li	a0,0
    80206cfa:	fffff097          	auipc	ra,0xfffff
    80206cfe:	b4e080e7          	jalr	-1202(ra) # 80205848 <exit_proc>
}
    80206d02:	0001                	nop
    80206d04:	70a2                	ld	ra,40(sp)
    80206d06:	7402                	ld	s0,32(sp)
    80206d08:	6145                	addi	sp,sp,48
    80206d0a:	8082                	ret

0000000080206d0c <victim_task>:
void victim_task(void){
    80206d0c:	1101                	addi	sp,sp,-32
    80206d0e:	ec06                	sd	ra,24(sp)
    80206d10:	e822                	sd	s0,16(sp)
    80206d12:	1000                	addi	s0,sp,32
	int count =5000;
    80206d14:	6785                	lui	a5,0x1
    80206d16:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    80206d1a:	fef42623          	sw	a5,-20(s0)
	while(count){
    80206d1e:	a81d                	j	80206d54 <victim_task+0x48>
		count--;
    80206d20:	fec42783          	lw	a5,-20(s0)
    80206d24:	37fd                	addiw	a5,a5,-1
    80206d26:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    80206d2a:	fec42783          	lw	a5,-20(s0)
    80206d2e:	873e                	mv	a4,a5
    80206d30:	06400793          	li	a5,100
    80206d34:	02f767bb          	remw	a5,a4,a5
    80206d38:	2781                	sext.w	a5,a5
    80206d3a:	eb89                	bnez	a5,80206d4c <victim_task+0x40>
			printf("Call for help!!\n");
    80206d3c:	0000f517          	auipc	a0,0xf
    80206d40:	52c50513          	addi	a0,a0,1324 # 80216268 <simple_user_task_bin+0xea0>
    80206d44:	ffffa097          	auipc	ra,0xffffa
    80206d48:	f50080e7          	jalr	-176(ra) # 80200c94 <printf>
		yield();
    80206d4c:	fffff097          	auipc	ra,0xfffff
    80206d50:	8ee080e7          	jalr	-1810(ra) # 8020563a <yield>
	while(count){
    80206d54:	fec42783          	lw	a5,-20(s0)
    80206d58:	2781                	sext.w	a5,a5
    80206d5a:	f3f9                	bnez	a5,80206d20 <victim_task+0x14>
	printf("No one can kill me!\n");
    80206d5c:	0000f517          	auipc	a0,0xf
    80206d60:	52450513          	addi	a0,a0,1316 # 80216280 <simple_user_task_bin+0xeb8>
    80206d64:	ffffa097          	auipc	ra,0xffffa
    80206d68:	f30080e7          	jalr	-208(ra) # 80200c94 <printf>
	exit_proc(0);
    80206d6c:	4501                	li	a0,0
    80206d6e:	fffff097          	auipc	ra,0xfffff
    80206d72:	ada080e7          	jalr	-1318(ra) # 80205848 <exit_proc>
}
    80206d76:	0001                	nop
    80206d78:	60e2                	ld	ra,24(sp)
    80206d7a:	6442                	ld	s0,16(sp)
    80206d7c:	6105                	addi	sp,sp,32
    80206d7e:	8082                	ret

0000000080206d80 <test_kill>:
void test_kill(void){
    80206d80:	7179                	addi	sp,sp,-48
    80206d82:	f406                	sd	ra,40(sp)
    80206d84:	f022                	sd	s0,32(sp)
    80206d86:	1800                	addi	s0,sp,48
	printf("\n----- 测试1: 创建后立即杀死 -----\n");
    80206d88:	0000f517          	auipc	a0,0xf
    80206d8c:	51050513          	addi	a0,a0,1296 # 80216298 <simple_user_task_bin+0xed0>
    80206d90:	ffffa097          	auipc	ra,0xffffa
    80206d94:	f04080e7          	jalr	-252(ra) # 80200c94 <printf>
	int pid =create_kernel_proc(simple_task);
    80206d98:	fffff517          	auipc	a0,0xfffff
    80206d9c:	4ec50513          	addi	a0,a0,1260 # 80206284 <simple_task>
    80206da0:	ffffe097          	auipc	ra,0xffffe
    80206da4:	340080e7          	jalr	832(ra) # 802050e0 <create_kernel_proc>
    80206da8:	87aa                	mv	a5,a0
    80206daa:	fef42423          	sw	a5,-24(s0)
	printf("【测试】: 创建进程成功，PID: %d\n", pid);
    80206dae:	fe842783          	lw	a5,-24(s0)
    80206db2:	85be                	mv	a1,a5
    80206db4:	0000f517          	auipc	a0,0xf
    80206db8:	51450513          	addi	a0,a0,1300 # 802162c8 <simple_user_task_bin+0xf00>
    80206dbc:	ffffa097          	auipc	ra,0xffffa
    80206dc0:	ed8080e7          	jalr	-296(ra) # 80200c94 <printf>
	kill_proc(pid);
    80206dc4:	fe842783          	lw	a5,-24(s0)
    80206dc8:	853e                	mv	a0,a5
    80206dca:	fffff097          	auipc	ra,0xfffff
    80206dce:	a1a080e7          	jalr	-1510(ra) # 802057e4 <kill_proc>
	printf("【测试】: 等待被杀死的进程退出,此处被杀死的进程不会有输出...\n");
    80206dd2:	0000f517          	auipc	a0,0xf
    80206dd6:	52650513          	addi	a0,a0,1318 # 802162f8 <simple_user_task_bin+0xf30>
    80206dda:	ffffa097          	auipc	ra,0xffffa
    80206dde:	eba080e7          	jalr	-326(ra) # 80200c94 <printf>
	int ret =0;
    80206de2:	fc042c23          	sw	zero,-40(s0)
	wait_proc(&ret);
    80206de6:	fd840793          	addi	a5,s0,-40
    80206dea:	853e                	mv	a0,a5
    80206dec:	fffff097          	auipc	ra,0xfffff
    80206df0:	b26080e7          	jalr	-1242(ra) # 80205912 <wait_proc>
	printf("【测试】: 进程%d退出，退出码应该为129，此处为%d\n ",pid,ret);
    80206df4:	fd842703          	lw	a4,-40(s0)
    80206df8:	fe842783          	lw	a5,-24(s0)
    80206dfc:	863a                	mv	a2,a4
    80206dfe:	85be                	mv	a1,a5
    80206e00:	0000f517          	auipc	a0,0xf
    80206e04:	55850513          	addi	a0,a0,1368 # 80216358 <simple_user_task_bin+0xf90>
    80206e08:	ffffa097          	auipc	ra,0xffffa
    80206e0c:	e8c080e7          	jalr	-372(ra) # 80200c94 <printf>
	if(SYS_kill == ret){
    80206e10:	fd842783          	lw	a5,-40(s0)
    80206e14:	873e                	mv	a4,a5
    80206e16:	08100793          	li	a5,129
    80206e1a:	00f71b63          	bne	a4,a5,80206e30 <test_kill+0xb0>
		printf("【测试】:尝试立即杀死进程，测试成功\n");
    80206e1e:	0000f517          	auipc	a0,0xf
    80206e22:	58250513          	addi	a0,a0,1410 # 802163a0 <simple_user_task_bin+0xfd8>
    80206e26:	ffffa097          	auipc	ra,0xffffa
    80206e2a:	e6e080e7          	jalr	-402(ra) # 80200c94 <printf>
    80206e2e:	a831                	j	80206e4a <test_kill+0xca>
	}else{
		printf("【测试】:尝试立即杀死进程失败，退出\n");
    80206e30:	0000f517          	auipc	a0,0xf
    80206e34:	5a850513          	addi	a0,a0,1448 # 802163d8 <simple_user_task_bin+0x1010>
    80206e38:	ffffa097          	auipc	ra,0xffffa
    80206e3c:	e5c080e7          	jalr	-420(ra) # 80200c94 <printf>
		exit_proc(0);
    80206e40:	4501                	li	a0,0
    80206e42:	fffff097          	auipc	ra,0xfffff
    80206e46:	a06080e7          	jalr	-1530(ra) # 80205848 <exit_proc>
	}
	printf("\n----- 测试2: 创建后稍后杀死 -----\n");
    80206e4a:	0000f517          	auipc	a0,0xf
    80206e4e:	5c650513          	addi	a0,a0,1478 # 80216410 <simple_user_task_bin+0x1048>
    80206e52:	ffffa097          	auipc	ra,0xffffa
    80206e56:	e42080e7          	jalr	-446(ra) # 80200c94 <printf>
	pid = create_kernel_proc(infinite_task);
    80206e5a:	00000517          	auipc	a0,0x0
    80206e5e:	db450513          	addi	a0,a0,-588 # 80206c0e <infinite_task>
    80206e62:	ffffe097          	auipc	ra,0xffffe
    80206e66:	27e080e7          	jalr	638(ra) # 802050e0 <create_kernel_proc>
    80206e6a:	87aa                	mv	a5,a0
    80206e6c:	fef42423          	sw	a5,-24(s0)
	int count = 500;
    80206e70:	1f400793          	li	a5,500
    80206e74:	fef42623          	sw	a5,-20(s0)
	while(count){
    80206e78:	a811                	j	80206e8c <test_kill+0x10c>
		count--; //等待500次调度
    80206e7a:	fec42783          	lw	a5,-20(s0)
    80206e7e:	37fd                	addiw	a5,a5,-1
    80206e80:	fef42623          	sw	a5,-20(s0)
		yield();
    80206e84:	ffffe097          	auipc	ra,0xffffe
    80206e88:	7b6080e7          	jalr	1974(ra) # 8020563a <yield>
	while(count){
    80206e8c:	fec42783          	lw	a5,-20(s0)
    80206e90:	2781                	sext.w	a5,a5
    80206e92:	f7e5                	bnez	a5,80206e7a <test_kill+0xfa>
	}
	kill_proc(pid);
    80206e94:	fe842783          	lw	a5,-24(s0)
    80206e98:	853e                	mv	a0,a5
    80206e9a:	fffff097          	auipc	ra,0xfffff
    80206e9e:	94a080e7          	jalr	-1718(ra) # 802057e4 <kill_proc>
	wait_proc(&ret);
    80206ea2:	fd840793          	addi	a5,s0,-40
    80206ea6:	853e                	mv	a0,a5
    80206ea8:	fffff097          	auipc	ra,0xfffff
    80206eac:	a6a080e7          	jalr	-1430(ra) # 80205912 <wait_proc>
	if(SYS_kill == ret){
    80206eb0:	fd842783          	lw	a5,-40(s0)
    80206eb4:	873e                	mv	a4,a5
    80206eb6:	08100793          	li	a5,129
    80206eba:	00f71b63          	bne	a4,a5,80206ed0 <test_kill+0x150>
		printf("【测试】:尝试稍后杀死进程，测试成功\n");
    80206ebe:	0000f517          	auipc	a0,0xf
    80206ec2:	58250513          	addi	a0,a0,1410 # 80216440 <simple_user_task_bin+0x1078>
    80206ec6:	ffffa097          	auipc	ra,0xffffa
    80206eca:	dce080e7          	jalr	-562(ra) # 80200c94 <printf>
    80206ece:	a831                	j	80206eea <test_kill+0x16a>
	}else{
		printf("【测试】:尝试稍后杀死进程失败，退出\n");
    80206ed0:	0000f517          	auipc	a0,0xf
    80206ed4:	5a850513          	addi	a0,a0,1448 # 80216478 <simple_user_task_bin+0x10b0>
    80206ed8:	ffffa097          	auipc	ra,0xffffa
    80206edc:	dbc080e7          	jalr	-580(ra) # 80200c94 <printf>
		exit_proc(0);
    80206ee0:	4501                	li	a0,0
    80206ee2:	fffff097          	auipc	ra,0xfffff
    80206ee6:	966080e7          	jalr	-1690(ra) # 80205848 <exit_proc>
	}
	printf("\n----- 测试3: 创建killer 和 victim -----\n");
    80206eea:	0000f517          	auipc	a0,0xf
    80206eee:	5c650513          	addi	a0,a0,1478 # 802164b0 <simple_user_task_bin+0x10e8>
    80206ef2:	ffffa097          	auipc	ra,0xffffa
    80206ef6:	da2080e7          	jalr	-606(ra) # 80200c94 <printf>
	int victim = create_kernel_proc(victim_task);
    80206efa:	00000517          	auipc	a0,0x0
    80206efe:	e1250513          	addi	a0,a0,-494 # 80206d0c <victim_task>
    80206f02:	ffffe097          	auipc	ra,0xffffe
    80206f06:	1de080e7          	jalr	478(ra) # 802050e0 <create_kernel_proc>
    80206f0a:	87aa                	mv	a5,a0
    80206f0c:	fef42223          	sw	a5,-28(s0)
	int killer = create_kernel_proc1(killer_task,victim);
    80206f10:	fe442783          	lw	a5,-28(s0)
    80206f14:	85be                	mv	a1,a5
    80206f16:	00000517          	auipc	a0,0x0
    80206f1a:	d6850513          	addi	a0,a0,-664 # 80206c7e <killer_task>
    80206f1e:	ffffe097          	auipc	ra,0xffffe
    80206f22:	230080e7          	jalr	560(ra) # 8020514e <create_kernel_proc1>
    80206f26:	87aa                	mv	a5,a0
    80206f28:	fef42023          	sw	a5,-32(s0)
	int first_exit = wait_proc(&ret);
    80206f2c:	fd840793          	addi	a5,s0,-40
    80206f30:	853e                	mv	a0,a5
    80206f32:	fffff097          	auipc	ra,0xfffff
    80206f36:	9e0080e7          	jalr	-1568(ra) # 80205912 <wait_proc>
    80206f3a:	87aa                	mv	a5,a0
    80206f3c:	fcf42e23          	sw	a5,-36(s0)
	if(first_exit == killer){
    80206f40:	fdc42783          	lw	a5,-36(s0)
    80206f44:	873e                	mv	a4,a5
    80206f46:	fe042783          	lw	a5,-32(s0)
    80206f4a:	2701                	sext.w	a4,a4
    80206f4c:	2781                	sext.w	a5,a5
    80206f4e:	04f71263          	bne	a4,a5,80206f92 <test_kill+0x212>
		wait_proc(&ret);
    80206f52:	fd840793          	addi	a5,s0,-40
    80206f56:	853e                	mv	a0,a5
    80206f58:	fffff097          	auipc	ra,0xfffff
    80206f5c:	9ba080e7          	jalr	-1606(ra) # 80205912 <wait_proc>
		if(SYS_kill == ret){
    80206f60:	fd842783          	lw	a5,-40(s0)
    80206f64:	873e                	mv	a4,a5
    80206f66:	08100793          	li	a5,129
    80206f6a:	00f71b63          	bne	a4,a5,80206f80 <test_kill+0x200>
			printf("【测试】:killer win\n");
    80206f6e:	0000f517          	auipc	a0,0xf
    80206f72:	57250513          	addi	a0,a0,1394 # 802164e0 <simple_user_task_bin+0x1118>
    80206f76:	ffffa097          	auipc	ra,0xffffa
    80206f7a:	d1e080e7          	jalr	-738(ra) # 80200c94 <printf>
    80206f7e:	a085                	j	80206fde <test_kill+0x25e>
		}else{
			printf("【测试】:出现问题，killer先结束但victim存活\n");
    80206f80:	0000f517          	auipc	a0,0xf
    80206f84:	58050513          	addi	a0,a0,1408 # 80216500 <simple_user_task_bin+0x1138>
    80206f88:	ffffa097          	auipc	ra,0xffffa
    80206f8c:	d0c080e7          	jalr	-756(ra) # 80200c94 <printf>
    80206f90:	a0b9                	j	80206fde <test_kill+0x25e>
		}
	}else if(first_exit == victim){
    80206f92:	fdc42783          	lw	a5,-36(s0)
    80206f96:	873e                	mv	a4,a5
    80206f98:	fe442783          	lw	a5,-28(s0)
    80206f9c:	2701                	sext.w	a4,a4
    80206f9e:	2781                	sext.w	a5,a5
    80206fa0:	02f71f63          	bne	a4,a5,80206fde <test_kill+0x25e>
		wait_proc(NULL);
    80206fa4:	4501                	li	a0,0
    80206fa6:	fffff097          	auipc	ra,0xfffff
    80206faa:	96c080e7          	jalr	-1684(ra) # 80205912 <wait_proc>
		if(SYS_kill == ret){
    80206fae:	fd842783          	lw	a5,-40(s0)
    80206fb2:	873e                	mv	a4,a5
    80206fb4:	08100793          	li	a5,129
    80206fb8:	00f71b63          	bne	a4,a5,80206fce <test_kill+0x24e>
			printf("【测试】:killer win\n");
    80206fbc:	0000f517          	auipc	a0,0xf
    80206fc0:	52450513          	addi	a0,a0,1316 # 802164e0 <simple_user_task_bin+0x1118>
    80206fc4:	ffffa097          	auipc	ra,0xffffa
    80206fc8:	cd0080e7          	jalr	-816(ra) # 80200c94 <printf>
    80206fcc:	a809                	j	80206fde <test_kill+0x25e>
		}else{
			printf("【测试】:出现问题，victim先结束且存活\n");
    80206fce:	0000f517          	auipc	a0,0xf
    80206fd2:	57250513          	addi	a0,a0,1394 # 80216540 <simple_user_task_bin+0x1178>
    80206fd6:	ffffa097          	auipc	ra,0xffffa
    80206fda:	cbe080e7          	jalr	-834(ra) # 80200c94 <printf>
		}
	}
	exit_proc(0);
    80206fde:	4501                	li	a0,0
    80206fe0:	fffff097          	auipc	ra,0xfffff
    80206fe4:	868080e7          	jalr	-1944(ra) # 80205848 <exit_proc>
}
    80206fe8:	0001                	nop
    80206fea:	70a2                	ld	ra,40(sp)
    80206fec:	7402                	ld	s0,32(sp)
    80206fee:	6145                	addi	sp,sp,48
    80206ff0:	8082                	ret

0000000080206ff2 <test_user_kill>:
void test_user_kill(void){
    80206ff2:	1101                	addi	sp,sp,-32
    80206ff4:	ec06                	sd	ra,24(sp)
    80206ff6:	e822                	sd	s0,16(sp)
    80206ff8:	1000                	addi	s0,sp,32
	printf("===== 测试开始: 用户进程Kill测试 =====\n");
    80206ffa:	0000f517          	auipc	a0,0xf
    80206ffe:	57e50513          	addi	a0,a0,1406 # 80216578 <simple_user_task_bin+0x11b0>
    80207002:	ffffa097          	auipc	ra,0xffffa
    80207006:	c92080e7          	jalr	-878(ra) # 80200c94 <printf>
    
    printf("\n----- 创建fork测试进程 -----\n");
    8020700a:	0000f517          	auipc	a0,0xf
    8020700e:	ed650513          	addi	a0,a0,-298 # 80215ee0 <simple_user_task_bin+0xb18>
    80207012:	ffffa097          	auipc	ra,0xffffa
    80207016:	c82080e7          	jalr	-894(ra) # 80200c94 <printf>
    int test_pid = create_user_proc(kill_user_test_bin, kill_user_test_bin_len);
    8020701a:	46000793          	li	a5,1120
    8020701e:	2781                	sext.w	a5,a5
    80207020:	85be                	mv	a1,a5
    80207022:	0000e517          	auipc	a0,0xe
    80207026:	f1e50513          	addi	a0,a0,-226 # 80214f40 <kill_user_test_bin>
    8020702a:	ffffe097          	auipc	ra,0xffffe
    8020702e:	1a2080e7          	jalr	418(ra) # 802051cc <create_user_proc>
    80207032:	87aa                	mv	a5,a0
    80207034:	fef42623          	sw	a5,-20(s0)
    
    if (test_pid < 0) {
    80207038:	fec42783          	lw	a5,-20(s0)
    8020703c:	2781                	sext.w	a5,a5
    8020703e:	0007db63          	bgez	a5,80207054 <test_user_kill+0x62>
        printf("【错误】: 创建fork测试进程失败\n");
    80207042:	0000f517          	auipc	a0,0xf
    80207046:	ec650513          	addi	a0,a0,-314 # 80215f08 <simple_user_task_bin+0xb40>
    8020704a:	ffffa097          	auipc	ra,0xffffa
    8020704e:	c4a080e7          	jalr	-950(ra) # 80200c94 <printf>
    80207052:	a861                	j	802070ea <test_user_kill+0xf8>
        return;
    }
    
    printf("【测试结果】: 创建fork测试进程成功，PID: %d\n", test_pid);
    80207054:	fec42783          	lw	a5,-20(s0)
    80207058:	85be                	mv	a1,a5
    8020705a:	0000f517          	auipc	a0,0xf
    8020705e:	ede50513          	addi	a0,a0,-290 # 80215f38 <simple_user_task_bin+0xb70>
    80207062:	ffffa097          	auipc	ra,0xffffa
    80207066:	c32080e7          	jalr	-974(ra) # 80200c94 <printf>
    
    // 等待fork测试进程完成
    printf("\n----- 等待fork测试进程完成 -----\n");
    8020706a:	0000f517          	auipc	a0,0xf
    8020706e:	f0e50513          	addi	a0,a0,-242 # 80215f78 <simple_user_task_bin+0xbb0>
    80207072:	ffffa097          	auipc	ra,0xffffa
    80207076:	c22080e7          	jalr	-990(ra) # 80200c94 <printf>
    int status;
    int waited_pid = wait_proc(&status);
    8020707a:	fe440793          	addi	a5,s0,-28
    8020707e:	853e                	mv	a0,a5
    80207080:	fffff097          	auipc	ra,0xfffff
    80207084:	892080e7          	jalr	-1902(ra) # 80205912 <wait_proc>
    80207088:	87aa                	mv	a5,a0
    8020708a:	fef42423          	sw	a5,-24(s0)
    if (waited_pid == test_pid) {
    8020708e:	fe842783          	lw	a5,-24(s0)
    80207092:	873e                	mv	a4,a5
    80207094:	fec42783          	lw	a5,-20(s0)
    80207098:	2701                	sext.w	a4,a4
    8020709a:	2781                	sext.w	a5,a5
    8020709c:	02f71163          	bne	a4,a5,802070be <test_user_kill+0xcc>
        printf("【测试结果】: fork测试进程(PID: %d)完成，状态码: %d\n", test_pid, status);
    802070a0:	fe442703          	lw	a4,-28(s0)
    802070a4:	fec42783          	lw	a5,-20(s0)
    802070a8:	863a                	mv	a2,a4
    802070aa:	85be                	mv	a1,a5
    802070ac:	0000f517          	auipc	a0,0xf
    802070b0:	efc50513          	addi	a0,a0,-260 # 80215fa8 <simple_user_task_bin+0xbe0>
    802070b4:	ffffa097          	auipc	ra,0xffffa
    802070b8:	be0080e7          	jalr	-1056(ra) # 80200c94 <printf>
    802070bc:	a839                	j	802070da <test_user_kill+0xe8>
    } else {
        printf("【错误】: 等待fork测试进程时出错，等待到PID: %d，期望PID: %d\n", waited_pid, test_pid);
    802070be:	fec42703          	lw	a4,-20(s0)
    802070c2:	fe842783          	lw	a5,-24(s0)
    802070c6:	863a                	mv	a2,a4
    802070c8:	85be                	mv	a1,a5
    802070ca:	0000f517          	auipc	a0,0xf
    802070ce:	f3e50513          	addi	a0,a0,-194 # 80216008 <simple_user_task_bin+0xc40>
    802070d2:	ffffa097          	auipc	ra,0xffffa
    802070d6:	bc2080e7          	jalr	-1086(ra) # 80200c94 <printf>
    }
    printf("===== 测试结束: 用户进程Kill测试 =====\n");
    802070da:	0000f517          	auipc	a0,0xf
    802070de:	4d650513          	addi	a0,a0,1238 # 802165b0 <simple_user_task_bin+0x11e8>
    802070e2:	ffffa097          	auipc	ra,0xffffa
    802070e6:	bb2080e7          	jalr	-1102(ra) # 80200c94 <printf>
    802070ea:	60e2                	ld	ra,24(sp)
    802070ec:	6442                	ld	s0,16(sp)
    802070ee:	6105                	addi	sp,sp,32
    802070f0:	8082                	ret
	...
