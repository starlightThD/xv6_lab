
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text # 设置代码段，基于内存的段式管理
.global _entry # 设置全局入口点，告知连接器入口地址

_entry: # 定义入口点标签
		la sp, stack0
    80200000:	00026117          	auipc	sp,0x26
    80200004:	00010113          	mv	sp,sp
        li a0,4096*4 # 表示4096个字节单位
    80200008:	6511                	lui	a0,0x4
        add sp,sp,a0 # 初始化栈指针
    8020000a:	912a                	add	sp,sp,a0

        la a0,_bss_start
    8020000c:	00027517          	auipc	a0,0x27
    80200010:	08450513          	addi	a0,a0,132 # 80227090 <kernel_pagetable>
        la a1,_bss_end
    80200014:	00027597          	auipc	a1,0x27
    80200018:	6dc58593          	addi	a1,a1,1756 # 802276f0 <_bss_end>

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
    8020002c:	068080e7          	jalr	104(ra) # 80200090 <start>

0000000080200030 <spin>:
spin:
        j spin # 无限循环，防止程序退出
    80200030:	a001                	j	80200030 <spin>

0000000080200032 <r_sstatus>:
    80200032:	1101                	addi	sp,sp,-32 # 80225fe0 <user_test_table+0x1d38>
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

0000000080200090 <start>:
void start(){
    80200090:	1101                	addi	sp,sp,-32
    80200092:	ec06                	sd	ra,24(sp)
    80200094:	e822                	sd	s0,16(sp)
    80200096:	1000                	addi	s0,sp,32
	pmm_init();
    80200098:	00003097          	auipc	ra,0x3
    8020009c:	1d8080e7          	jalr	472(ra) # 80203270 <pmm_init>
	kvminit();
    802000a0:	00002097          	auipc	ra,0x2
    802000a4:	7ac080e7          	jalr	1964(ra) # 8020284c <kvminit>
	trap_init();
    802000a8:	00003097          	auipc	ra,0x3
    802000ac:	7ec080e7          	jalr	2028(ra) # 80203894 <trap_init>
	uart_init();
    802000b0:	00000097          	auipc	ra,0x0
    802000b4:	54e080e7          	jalr	1358(ra) # 802005fe <uart_init>
	intr_on();
    802000b8:	00000097          	auipc	ra,0x0
    802000bc:	fae080e7          	jalr	-82(ra) # 80200066 <intr_on>
    printf("===============================================\n");
    802000c0:	0000a517          	auipc	a0,0xa
    802000c4:	16050513          	addi	a0,a0,352 # 8020a220 <user_test_table+0x108>
    802000c8:	00001097          	auipc	ra,0x1
    802000cc:	c3e080e7          	jalr	-962(ra) # 80200d06 <printf>
    printf("        RISC-V Operating System v1.0         \n");
    802000d0:	0000a517          	auipc	a0,0xa
    802000d4:	18850513          	addi	a0,a0,392 # 8020a258 <user_test_table+0x140>
    802000d8:	00001097          	auipc	ra,0x1
    802000dc:	c2e080e7          	jalr	-978(ra) # 80200d06 <printf>
    printf("===============================================\n\n");
    802000e0:	0000a517          	auipc	a0,0xa
    802000e4:	1a850513          	addi	a0,a0,424 # 8020a288 <user_test_table+0x170>
    802000e8:	00001097          	auipc	ra,0x1
    802000ec:	c1e080e7          	jalr	-994(ra) # 80200d06 <printf>
	init_proc(); // 初始化进程管理子系统
    802000f0:	00005097          	auipc	ra,0x5
    802000f4:	0a6080e7          	jalr	166(ra) # 80205196 <init_proc>
	int main_pid = create_kernel_proc(kernel_main);
    802000f8:	00000517          	auipc	a0,0x0
    802000fc:	46050513          	addi	a0,a0,1120 # 80200558 <kernel_main>
    80200100:	00005097          	auipc	ra,0x5
    80200104:	4d0080e7          	jalr	1232(ra) # 802055d0 <create_kernel_proc>
    80200108:	87aa                	mv	a5,a0
    8020010a:	fef42623          	sw	a5,-20(s0)
	if (main_pid < 0){
    8020010e:	fec42783          	lw	a5,-20(s0)
    80200112:	2781                	sext.w	a5,a5
    80200114:	0007da63          	bgez	a5,80200128 <start+0x98>
		panic("START: create main process failed!\n");
    80200118:	0000a517          	auipc	a0,0xa
    8020011c:	1a850513          	addi	a0,a0,424 # 8020a2c0 <user_test_table+0x1a8>
    80200120:	00001097          	auipc	ra,0x1
    80200124:	632080e7          	jalr	1586(ra) # 80201752 <panic>
	schedule();
    80200128:	00006097          	auipc	ra,0x6
    8020012c:	99e080e7          	jalr	-1634(ra) # 80205ac6 <schedule>
    panic("START: main() exit unexpectedly!!!\n");
    80200130:	0000a517          	auipc	a0,0xa
    80200134:	1b850513          	addi	a0,a0,440 # 8020a2e8 <user_test_table+0x1d0>
    80200138:	00001097          	auipc	ra,0x1
    8020013c:	61a080e7          	jalr	1562(ra) # 80201752 <panic>
}
    80200140:	0001                	nop
    80200142:	60e2                	ld	ra,24(sp)
    80200144:	6442                	ld	s0,16(sp)
    80200146:	6105                	addi	sp,sp,32
    80200148:	8082                	ret

000000008020014a <print_menu>:
void print_menu(void) {
    8020014a:	1101                	addi	sp,sp,-32
    8020014c:	ec06                	sd	ra,24(sp)
    8020014e:	e822                	sd	s0,16(sp)
    80200150:	1000                	addi	s0,sp,32
    printf("\n=== 内核测试 ===\n");
    80200152:	0000a517          	auipc	a0,0xa
    80200156:	1be50513          	addi	a0,a0,446 # 8020a310 <user_test_table+0x1f8>
    8020015a:	00001097          	auipc	ra,0x1
    8020015e:	bac080e7          	jalr	-1108(ra) # 80200d06 <printf>
    for (int i = 0; i < KERNEL_TEST_COUNT; i++) {
    80200162:	fe042623          	sw	zero,-20(s0)
    80200166:	a835                	j	802001a2 <print_menu+0x58>
        printf("  k%d. %s\n", i+1, kernel_test_table[i].name);
    80200168:	fec42783          	lw	a5,-20(s0)
    8020016c:	2785                	addiw	a5,a5,1
    8020016e:	0007869b          	sext.w	a3,a5
    80200172:	00027717          	auipc	a4,0x27
    80200176:	e8e70713          	addi	a4,a4,-370 # 80227000 <kernel_test_table>
    8020017a:	fec42783          	lw	a5,-20(s0)
    8020017e:	0792                	slli	a5,a5,0x4
    80200180:	97ba                	add	a5,a5,a4
    80200182:	639c                	ld	a5,0(a5)
    80200184:	863e                	mv	a2,a5
    80200186:	85b6                	mv	a1,a3
    80200188:	0000a517          	auipc	a0,0xa
    8020018c:	1a050513          	addi	a0,a0,416 # 8020a328 <user_test_table+0x210>
    80200190:	00001097          	auipc	ra,0x1
    80200194:	b76080e7          	jalr	-1162(ra) # 80200d06 <printf>
    for (int i = 0; i < KERNEL_TEST_COUNT; i++) {
    80200198:	fec42783          	lw	a5,-20(s0)
    8020019c:	2785                	addiw	a5,a5,1
    8020019e:	fef42623          	sw	a5,-20(s0)
    802001a2:	fec42783          	lw	a5,-20(s0)
    802001a6:	873e                	mv	a4,a5
    802001a8:	4799                	li	a5,6
    802001aa:	fae7ffe3          	bgeu	a5,a4,80200168 <print_menu+0x1e>
    printf("\n=== 用户测试 ===\n");
    802001ae:	0000a517          	auipc	a0,0xa
    802001b2:	18a50513          	addi	a0,a0,394 # 8020a338 <user_test_table+0x220>
    802001b6:	00001097          	auipc	ra,0x1
    802001ba:	b50080e7          	jalr	-1200(ra) # 80200d06 <printf>
    for (int i = 0; i < USER_TEST_COUNT; i++) {
    802001be:	fe042423          	sw	zero,-24(s0)
    802001c2:	a081                	j	80200202 <print_menu+0xb8>
        printf("  u%d. %s\n", i+1, user_test_table[i].name);
    802001c4:	fe842783          	lw	a5,-24(s0)
    802001c8:	2785                	addiw	a5,a5,1
    802001ca:	0007859b          	sext.w	a1,a5
    802001ce:	0000a697          	auipc	a3,0xa
    802001d2:	f4a68693          	addi	a3,a3,-182 # 8020a118 <user_test_table>
    802001d6:	fe842703          	lw	a4,-24(s0)
    802001da:	87ba                	mv	a5,a4
    802001dc:	0786                	slli	a5,a5,0x1
    802001de:	97ba                	add	a5,a5,a4
    802001e0:	078e                	slli	a5,a5,0x3
    802001e2:	97b6                	add	a5,a5,a3
    802001e4:	639c                	ld	a5,0(a5)
    802001e6:	863e                	mv	a2,a5
    802001e8:	0000a517          	auipc	a0,0xa
    802001ec:	16850513          	addi	a0,a0,360 # 8020a350 <user_test_table+0x238>
    802001f0:	00001097          	auipc	ra,0x1
    802001f4:	b16080e7          	jalr	-1258(ra) # 80200d06 <printf>
    for (int i = 0; i < USER_TEST_COUNT; i++) {
    802001f8:	fe842783          	lw	a5,-24(s0)
    802001fc:	2785                	addiw	a5,a5,1
    802001fe:	fef42423          	sw	a5,-24(s0)
    80200202:	fe842783          	lw	a5,-24(s0)
    80200206:	873e                	mv	a4,a5
    80200208:	4791                	li	a5,4
    8020020a:	fae7fde3          	bgeu	a5,a4,802001c4 <print_menu+0x7a>
    printf("\n=== 基础命令 ===\n");
    8020020e:	0000a517          	auipc	a0,0xa
    80200212:	15250513          	addi	a0,a0,338 # 8020a360 <user_test_table+0x248>
    80200216:	00001097          	auipc	ra,0x1
    8020021a:	af0080e7          	jalr	-1296(ra) # 80200d06 <printf>
    printf("  h. help          - 显示此帮助\n");
    8020021e:	0000a517          	auipc	a0,0xa
    80200222:	15a50513          	addi	a0,a0,346 # 8020a378 <user_test_table+0x260>
    80200226:	00001097          	auipc	ra,0x1
    8020022a:	ae0080e7          	jalr	-1312(ra) # 80200d06 <printf>
    printf("  e. exit          - 退出控制台\n");
    8020022e:	0000a517          	auipc	a0,0xa
    80200232:	17250513          	addi	a0,a0,370 # 8020a3a0 <user_test_table+0x288>
    80200236:	00001097          	auipc	ra,0x1
    8020023a:	ad0080e7          	jalr	-1328(ra) # 80200d06 <printf>
    printf("  p. ps            - 显示进程状态\n");
    8020023e:	0000a517          	auipc	a0,0xa
    80200242:	18a50513          	addi	a0,a0,394 # 8020a3c8 <user_test_table+0x2b0>
    80200246:	00001097          	auipc	ra,0x1
    8020024a:	ac0080e7          	jalr	-1344(ra) # 80200d06 <printf>
}
    8020024e:	0001                	nop
    80200250:	60e2                	ld	ra,24(sp)
    80200252:	6442                	ld	s0,16(sp)
    80200254:	6105                	addi	sp,sp,32
    80200256:	8082                	ret

0000000080200258 <console>:
void console(void) {
    80200258:	7169                	addi	sp,sp,-304
    8020025a:	f606                	sd	ra,296(sp)
    8020025c:	f222                	sd	s0,288(sp)
    8020025e:	1a00                	addi	s0,sp,304
    int exit_requested = 0;
    80200260:	fe042623          	sw	zero,-20(s0)
    print_menu();
    80200264:	00000097          	auipc	ra,0x0
    80200268:	ee6080e7          	jalr	-282(ra) # 8020014a <print_menu>
    while (!exit_requested) {
    8020026c:	a4e1                	j	80200534 <console+0x2dc>
        printf("\nConsole >>> ");
    8020026e:	0000a517          	auipc	a0,0xa
    80200272:	18a50513          	addi	a0,a0,394 # 8020a3f8 <user_test_table+0x2e0>
    80200276:	00001097          	auipc	ra,0x1
    8020027a:	a90080e7          	jalr	-1392(ra) # 80200d06 <printf>
        readline(input_buffer, sizeof(input_buffer));
    8020027e:	ed840793          	addi	a5,s0,-296
    80200282:	10000593          	li	a1,256
    80200286:	853e                	mv	a0,a5
    80200288:	00000097          	auipc	ra,0x0
    8020028c:	770080e7          	jalr	1904(ra) # 802009f8 <readline>
        if (input_buffer[0] == '\0') continue;
    80200290:	ed844783          	lbu	a5,-296(s0)
    80200294:	28078f63          	beqz	a5,80200532 <console+0x2da>
        switch(input_buffer[0]) {
    80200298:	ed844783          	lbu	a5,-296(s0)
    8020029c:	2781                	sext.w	a5,a5
    8020029e:	2781                	sext.w	a5,a5
    802002a0:	fbb7879b          	addiw	a5,a5,-69
    802002a4:	0007871b          	sext.w	a4,a5
    802002a8:	86ba                	mv	a3,a4
    802002aa:	02b00793          	li	a5,43
    802002ae:	00d7b7b3          	sltu	a5,a5,a3
    802002b2:	0ff7f793          	zext.b	a5,a5
    802002b6:	e3ad                	bnez	a5,80200318 <console+0xc0>
    802002b8:	4785                	li	a5,1
    802002ba:	00e797b3          	sll	a5,a5,a4
    802002be:	0000a717          	auipc	a4,0xa
    802002c2:	37270713          	addi	a4,a4,882 # 8020a630 <user_test_table+0x518>
    802002c6:	6318                	ld	a4,0(a4)
    802002c8:	8f7d                	and	a4,a4,a5
    802002ca:	00e03733          	snez	a4,a4
    802002ce:	0ff77713          	zext.b	a4,a4
    802002d2:	ef15                	bnez	a4,8020030e <console+0xb6>
    802002d4:	46a1                	li	a3,8
    802002d6:	4721                	li	a4,8
    802002d8:	1682                	slli	a3,a3,0x20
    802002da:	9736                	add	a4,a4,a3
    802002dc:	8f7d                	and	a4,a4,a5
    802002de:	00e03733          	snez	a4,a4
    802002e2:	0ff77713          	zext.b	a4,a4
    802002e6:	ef19                	bnez	a4,80200304 <console+0xac>
    802002e8:	4685                	li	a3,1
    802002ea:	4705                	li	a4,1
    802002ec:	1682                	slli	a3,a3,0x20
    802002ee:	9736                	add	a4,a4,a3
    802002f0:	8ff9                	and	a5,a5,a4
    802002f2:	00f037b3          	snez	a5,a5
    802002f6:	0ff7f793          	zext.b	a5,a5
    802002fa:	cf99                	beqz	a5,80200318 <console+0xc0>
                exit_requested = 1;
    802002fc:	4785                	li	a5,1
    802002fe:	fef42623          	sw	a5,-20(s0)
                continue;
    80200302:	ac0d                	j	80200534 <console+0x2dc>
                print_menu();
    80200304:	00000097          	auipc	ra,0x0
    80200308:	e46080e7          	jalr	-442(ra) # 8020014a <print_menu>
                continue;
    8020030c:	a425                	j	80200534 <console+0x2dc>
                print_proc_table();
    8020030e:	00006097          	auipc	ra,0x6
    80200312:	ccc080e7          	jalr	-820(ra) # 80205fda <print_proc_table>
                continue;
    80200316:	ac39                	j	80200534 <console+0x2dc>
        if (input_buffer[0] == 'k' || input_buffer[0] == 'K') {
    80200318:	ed844783          	lbu	a5,-296(s0)
    8020031c:	873e                	mv	a4,a5
    8020031e:	06b00793          	li	a5,107
    80200322:	00f70963          	beq	a4,a5,80200334 <console+0xdc>
    80200326:	ed844783          	lbu	a5,-296(s0)
    8020032a:	873e                	mv	a4,a5
    8020032c:	04b00793          	li	a5,75
    80200330:	0cf71763          	bne	a4,a5,802003fe <console+0x1a6>
            int index = atoi(input_buffer + 1) - 1;
    80200334:	ed840793          	addi	a5,s0,-296
    80200338:	0785                	addi	a5,a5,1
    8020033a:	853e                	mv	a0,a5
    8020033c:	00006097          	auipc	ra,0x6
    80200340:	03c080e7          	jalr	60(ra) # 80206378 <atoi>
    80200344:	87aa                	mv	a5,a0
    80200346:	37fd                	addiw	a5,a5,-1
    80200348:	fef42023          	sw	a5,-32(s0)
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
    8020034c:	fe042783          	lw	a5,-32(s0)
    80200350:	2781                	sext.w	a5,a5
    80200352:	0807cc63          	bltz	a5,802003ea <console+0x192>
    80200356:	fe042783          	lw	a5,-32(s0)
    8020035a:	873e                	mv	a4,a5
    8020035c:	4799                	li	a5,6
    8020035e:	08e7e663          	bltu	a5,a4,802003ea <console+0x192>
                printf("\n----- 执行内核测试: %s -----\n", 
    80200362:	00027717          	auipc	a4,0x27
    80200366:	c9e70713          	addi	a4,a4,-866 # 80227000 <kernel_test_table>
    8020036a:	fe042783          	lw	a5,-32(s0)
    8020036e:	0792                	slli	a5,a5,0x4
    80200370:	97ba                	add	a5,a5,a4
    80200372:	639c                	ld	a5,0(a5)
    80200374:	85be                	mv	a1,a5
    80200376:	0000a517          	auipc	a0,0xa
    8020037a:	09250513          	addi	a0,a0,146 # 8020a408 <user_test_table+0x2f0>
    8020037e:	00001097          	auipc	ra,0x1
    80200382:	988080e7          	jalr	-1656(ra) # 80200d06 <printf>
                int pid = create_kernel_proc(kernel_test_table[index].func);
    80200386:	00027717          	auipc	a4,0x27
    8020038a:	c7a70713          	addi	a4,a4,-902 # 80227000 <kernel_test_table>
    8020038e:	fe042783          	lw	a5,-32(s0)
    80200392:	0792                	slli	a5,a5,0x4
    80200394:	97ba                	add	a5,a5,a4
    80200396:	679c                	ld	a5,8(a5)
    80200398:	853e                	mv	a0,a5
    8020039a:	00005097          	auipc	ra,0x5
    8020039e:	236080e7          	jalr	566(ra) # 802055d0 <create_kernel_proc>
    802003a2:	87aa                	mv	a5,a0
    802003a4:	fcf42e23          	sw	a5,-36(s0)
                if (pid < 0) {
    802003a8:	fdc42783          	lw	a5,-36(s0)
    802003ac:	2781                	sext.w	a5,a5
    802003ae:	0007db63          	bgez	a5,802003c4 <console+0x16c>
                    printf("创建内核测试进程失败\n");
    802003b2:	0000a517          	auipc	a0,0xa
    802003b6:	07e50513          	addi	a0,a0,126 # 8020a430 <user_test_table+0x318>
    802003ba:	00001097          	auipc	ra,0x1
    802003be:	94c080e7          	jalr	-1716(ra) # 80200d06 <printf>
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
    802003c2:	a82d                	j	802003fc <console+0x1a4>
                    printf("创建内核测试进程成功，PID: %d\n", pid);
    802003c4:	fdc42783          	lw	a5,-36(s0)
    802003c8:	85be                	mv	a1,a5
    802003ca:	0000a517          	auipc	a0,0xa
    802003ce:	08650513          	addi	a0,a0,134 # 8020a450 <user_test_table+0x338>
    802003d2:	00001097          	auipc	ra,0x1
    802003d6:	934080e7          	jalr	-1740(ra) # 80200d06 <printf>
                    wait_proc(&status);
    802003da:	ed440793          	addi	a5,s0,-300
    802003de:	853e                	mv	a0,a5
    802003e0:	00006097          	auipc	ra,0x6
    802003e4:	a6c080e7          	jalr	-1428(ra) # 80205e4c <wait_proc>
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
    802003e8:	a811                	j	802003fc <console+0x1a4>
                printf("无效的内核测试序号\n");
    802003ea:	0000a517          	auipc	a0,0xa
    802003ee:	09650513          	addi	a0,a0,150 # 8020a480 <user_test_table+0x368>
    802003f2:	00001097          	auipc	ra,0x1
    802003f6:	914080e7          	jalr	-1772(ra) # 80200d06 <printf>
        if (input_buffer[0] == 'k' || input_buffer[0] == 'K') {
    802003fa:	aa2d                	j	80200534 <console+0x2dc>
    802003fc:	aa25                	j	80200534 <console+0x2dc>
        } else if (input_buffer[0] == 'u' || input_buffer[0] == 'U') {
    802003fe:	ed844783          	lbu	a5,-296(s0)
    80200402:	873e                	mv	a4,a5
    80200404:	07500793          	li	a5,117
    80200408:	00f70963          	beq	a4,a5,8020041a <console+0x1c2>
    8020040c:	ed844783          	lbu	a5,-296(s0)
    80200410:	873e                	mv	a4,a5
    80200412:	05500793          	li	a5,85
    80200416:	0ef71a63          	bne	a4,a5,8020050a <console+0x2b2>
            int index = atoi(input_buffer + 1) - 1;
    8020041a:	ed840793          	addi	a5,s0,-296
    8020041e:	0785                	addi	a5,a5,1
    80200420:	853e                	mv	a0,a5
    80200422:	00006097          	auipc	ra,0x6
    80200426:	f56080e7          	jalr	-170(ra) # 80206378 <atoi>
    8020042a:	87aa                	mv	a5,a0
    8020042c:	37fd                	addiw	a5,a5,-1
    8020042e:	fef42423          	sw	a5,-24(s0)
            if (index >= 0 && index < USER_TEST_COUNT) {
    80200432:	fe842783          	lw	a5,-24(s0)
    80200436:	2781                	sext.w	a5,a5
    80200438:	0a07cf63          	bltz	a5,802004f6 <console+0x29e>
    8020043c:	fe842783          	lw	a5,-24(s0)
    80200440:	873e                	mv	a4,a5
    80200442:	4791                	li	a5,4
    80200444:	0ae7e963          	bltu	a5,a4,802004f6 <console+0x29e>
                       user_test_table[index].name);
    80200448:	0000a697          	auipc	a3,0xa
    8020044c:	cd068693          	addi	a3,a3,-816 # 8020a118 <user_test_table>
    80200450:	fe842703          	lw	a4,-24(s0)
    80200454:	87ba                	mv	a5,a4
    80200456:	0786                	slli	a5,a5,0x1
    80200458:	97ba                	add	a5,a5,a4
    8020045a:	078e                	slli	a5,a5,0x3
    8020045c:	97b6                	add	a5,a5,a3
    8020045e:	639c                	ld	a5,0(a5)
                printf("\n----- 执行用户测试: %s -----\n", 
    80200460:	85be                	mv	a1,a5
    80200462:	0000a517          	auipc	a0,0xa
    80200466:	03e50513          	addi	a0,a0,62 # 8020a4a0 <user_test_table+0x388>
    8020046a:	00001097          	auipc	ra,0x1
    8020046e:	89c080e7          	jalr	-1892(ra) # 80200d06 <printf>
                int pid = create_user_proc(user_test_table[index].binary,
    80200472:	0000a697          	auipc	a3,0xa
    80200476:	ca668693          	addi	a3,a3,-858 # 8020a118 <user_test_table>
    8020047a:	fe842703          	lw	a4,-24(s0)
    8020047e:	87ba                	mv	a5,a4
    80200480:	0786                	slli	a5,a5,0x1
    80200482:	97ba                	add	a5,a5,a4
    80200484:	078e                	slli	a5,a5,0x3
    80200486:	97b6                	add	a5,a5,a3
    80200488:	6790                	ld	a2,8(a5)
                                         user_test_table[index].size);
    8020048a:	0000a697          	auipc	a3,0xa
    8020048e:	c8e68693          	addi	a3,a3,-882 # 8020a118 <user_test_table>
    80200492:	fe842703          	lw	a4,-24(s0)
    80200496:	87ba                	mv	a5,a4
    80200498:	0786                	slli	a5,a5,0x1
    8020049a:	97ba                	add	a5,a5,a4
    8020049c:	078e                	slli	a5,a5,0x3
    8020049e:	97b6                	add	a5,a5,a3
    802004a0:	4b9c                	lw	a5,16(a5)
                int pid = create_user_proc(user_test_table[index].binary,
    802004a2:	85be                	mv	a1,a5
    802004a4:	8532                	mv	a0,a2
    802004a6:	00005097          	auipc	ra,0x5
    802004aa:	216080e7          	jalr	534(ra) # 802056bc <create_user_proc>
    802004ae:	87aa                	mv	a5,a0
    802004b0:	fef42223          	sw	a5,-28(s0)
                if (pid < 0) {
    802004b4:	fe442783          	lw	a5,-28(s0)
    802004b8:	2781                	sext.w	a5,a5
    802004ba:	0007db63          	bgez	a5,802004d0 <console+0x278>
                    printf("创建用户测试进程失败\n");
    802004be:	0000a517          	auipc	a0,0xa
    802004c2:	00a50513          	addi	a0,a0,10 # 8020a4c8 <user_test_table+0x3b0>
    802004c6:	00001097          	auipc	ra,0x1
    802004ca:	840080e7          	jalr	-1984(ra) # 80200d06 <printf>
            if (index >= 0 && index < USER_TEST_COUNT) {
    802004ce:	a82d                	j	80200508 <console+0x2b0>
                    printf("创建用户测试进程成功，PID: %d\n", pid);
    802004d0:	fe442783          	lw	a5,-28(s0)
    802004d4:	85be                	mv	a1,a5
    802004d6:	0000a517          	auipc	a0,0xa
    802004da:	01250513          	addi	a0,a0,18 # 8020a4e8 <user_test_table+0x3d0>
    802004de:	00001097          	auipc	ra,0x1
    802004e2:	828080e7          	jalr	-2008(ra) # 80200d06 <printf>
                    wait_proc(&status);
    802004e6:	ed040793          	addi	a5,s0,-304
    802004ea:	853e                	mv	a0,a5
    802004ec:	00006097          	auipc	ra,0x6
    802004f0:	960080e7          	jalr	-1696(ra) # 80205e4c <wait_proc>
            if (index >= 0 && index < USER_TEST_COUNT) {
    802004f4:	a811                	j	80200508 <console+0x2b0>
                printf("无效的用户测试序号\n");
    802004f6:	0000a517          	auipc	a0,0xa
    802004fa:	02250513          	addi	a0,a0,34 # 8020a518 <user_test_table+0x400>
    802004fe:	00001097          	auipc	ra,0x1
    80200502:	808080e7          	jalr	-2040(ra) # 80200d06 <printf>
        } else if (input_buffer[0] == 'u' || input_buffer[0] == 'U') {
    80200506:	a03d                	j	80200534 <console+0x2dc>
    80200508:	a035                	j	80200534 <console+0x2dc>
            printf("无效命令: %s\n", input_buffer);
    8020050a:	ed840793          	addi	a5,s0,-296
    8020050e:	85be                	mv	a1,a5
    80200510:	0000a517          	auipc	a0,0xa
    80200514:	02850513          	addi	a0,a0,40 # 8020a538 <user_test_table+0x420>
    80200518:	00000097          	auipc	ra,0x0
    8020051c:	7ee080e7          	jalr	2030(ra) # 80200d06 <printf>
            printf("输入 'h' 查看帮助\n");
    80200520:	0000a517          	auipc	a0,0xa
    80200524:	03050513          	addi	a0,a0,48 # 8020a550 <user_test_table+0x438>
    80200528:	00000097          	auipc	ra,0x0
    8020052c:	7de080e7          	jalr	2014(ra) # 80200d06 <printf>
    80200530:	a011                	j	80200534 <console+0x2dc>
        if (input_buffer[0] == '\0') continue;
    80200532:	0001                	nop
    while (!exit_requested) {
    80200534:	fec42783          	lw	a5,-20(s0)
    80200538:	2781                	sext.w	a5,a5
    8020053a:	d2078ae3          	beqz	a5,8020026e <console+0x16>
    printf("控制台进程退出\n");
    8020053e:	0000a517          	auipc	a0,0xa
    80200542:	03250513          	addi	a0,a0,50 # 8020a570 <user_test_table+0x458>
    80200546:	00000097          	auipc	ra,0x0
    8020054a:	7c0080e7          	jalr	1984(ra) # 80200d06 <printf>
}
    8020054e:	0001                	nop
    80200550:	70b2                	ld	ra,296(sp)
    80200552:	7412                	ld	s0,288(sp)
    80200554:	6155                	addi	sp,sp,304
    80200556:	8082                	ret

0000000080200558 <kernel_main>:
void kernel_main(void){
    80200558:	1101                	addi	sp,sp,-32
    8020055a:	ec06                	sd	ra,24(sp)
    8020055c:	e822                	sd	s0,16(sp)
    8020055e:	1000                	addi	s0,sp,32
	clear_screen();
    80200560:	00001097          	auipc	ra,0x1
    80200564:	cbe080e7          	jalr	-834(ra) # 8020121e <clear_screen>
	int console_pid = create_kernel_proc(console);
    80200568:	00000517          	auipc	a0,0x0
    8020056c:	cf050513          	addi	a0,a0,-784 # 80200258 <console>
    80200570:	00005097          	auipc	ra,0x5
    80200574:	060080e7          	jalr	96(ra) # 802055d0 <create_kernel_proc>
    80200578:	87aa                	mv	a5,a0
    8020057a:	fef42623          	sw	a5,-20(s0)
	if (console_pid < 0){
    8020057e:	fec42783          	lw	a5,-20(s0)
    80200582:	2781                	sext.w	a5,a5
    80200584:	0007db63          	bgez	a5,8020059a <kernel_main+0x42>
		panic("KERNEL_MAIN: create console process failed!\n");
    80200588:	0000a517          	auipc	a0,0xa
    8020058c:	00050513          	mv	a0,a0
    80200590:	00001097          	auipc	ra,0x1
    80200594:	1c2080e7          	jalr	450(ra) # 80201752 <panic>
    80200598:	a821                	j	802005b0 <kernel_main+0x58>
		printf("KERNEL_MAIN: console process created with PID %d\n", console_pid);
    8020059a:	fec42783          	lw	a5,-20(s0)
    8020059e:	85be                	mv	a1,a5
    802005a0:	0000a517          	auipc	a0,0xa
    802005a4:	01850513          	addi	a0,a0,24 # 8020a5b8 <user_test_table+0x4a0>
    802005a8:	00000097          	auipc	ra,0x0
    802005ac:	75e080e7          	jalr	1886(ra) # 80200d06 <printf>
	int pid = wait_proc(&status);
    802005b0:	fe440793          	addi	a5,s0,-28
    802005b4:	853e                	mv	a0,a5
    802005b6:	00006097          	auipc	ra,0x6
    802005ba:	896080e7          	jalr	-1898(ra) # 80205e4c <wait_proc>
    802005be:	87aa                	mv	a5,a0
    802005c0:	fef42423          	sw	a5,-24(s0)
	if(pid != console_pid){
    802005c4:	fe842783          	lw	a5,-24(s0)
    802005c8:	873e                	mv	a4,a5
    802005ca:	fec42783          	lw	a5,-20(s0)
    802005ce:	2701                	sext.w	a4,a4
    802005d0:	2781                	sext.w	a5,a5
    802005d2:	02f70163          	beq	a4,a5,802005f4 <kernel_main+0x9c>
		printf("KERNEL_MAIN: unexpected process %d exited with status %d\n", pid, status);
    802005d6:	fe442703          	lw	a4,-28(s0)
    802005da:	fe842783          	lw	a5,-24(s0)
    802005de:	863a                	mv	a2,a4
    802005e0:	85be                	mv	a1,a5
    802005e2:	0000a517          	auipc	a0,0xa
    802005e6:	00e50513          	addi	a0,a0,14 # 8020a5f0 <user_test_table+0x4d8>
    802005ea:	00000097          	auipc	ra,0x0
    802005ee:	71c080e7          	jalr	1820(ra) # 80200d06 <printf>
	return;
    802005f2:	0001                	nop
    802005f4:	0001                	nop
    802005f6:	60e2                	ld	ra,24(sp)
    802005f8:	6442                	ld	s0,16(sp)
    802005fa:	6105                	addi	sp,sp,32
    802005fc:	8082                	ret

00000000802005fe <uart_init>:
#include "defs.h"
#define LINE_BUF_SIZE 128
struct uart_input_buf_t uart_input_buf;
// UART初始化函数
void uart_init(void) {
    802005fe:	1141                	addi	sp,sp,-16
    80200600:	e406                	sd	ra,8(sp)
    80200602:	e022                	sd	s0,0(sp)
    80200604:	0800                	addi	s0,sp,16

    WriteReg(IER, 0x00);
    80200606:	100007b7          	lui	a5,0x10000
    8020060a:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    8020060c:	00078023          	sb	zero,0(a5)
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80200610:	100007b7          	lui	a5,0x10000
    80200614:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x701ffffe>
    80200616:	471d                	li	a4,7
    80200618:	00e78023          	sb	a4,0(a5)
    WriteReg(IER, IER_RX_ENABLE);
    8020061c:	100007b7          	lui	a5,0x10000
    80200620:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x701fffff>
    80200622:	4705                	li	a4,1
    80200624:	00e78023          	sb	a4,0(a5)
    register_interrupt(UART0_IRQ, uart_intr);//注册键盘输入的中断处理函数
    80200628:	00000597          	auipc	a1,0x0
    8020062c:	12858593          	addi	a1,a1,296 # 80200750 <uart_intr>
    80200630:	4529                	li	a0,10
    80200632:	00003097          	auipc	ra,0x3
    80200636:	0de080e7          	jalr	222(ra) # 80203710 <register_interrupt>
    enable_interrupts(UART0_IRQ);
    8020063a:	4529                	li	a0,10
    8020063c:	00003097          	auipc	ra,0x3
    80200640:	15e080e7          	jalr	350(ra) # 8020379a <enable_interrupts>
    printf("UART initialized with input support\n");
    80200644:	0000c517          	auipc	a0,0xc
    80200648:	00450513          	addi	a0,a0,4 # 8020c648 <user_test_table+0x60>
    8020064c:	00000097          	auipc	ra,0x0
    80200650:	6ba080e7          	jalr	1722(ra) # 80200d06 <printf>
}
    80200654:	0001                	nop
    80200656:	60a2                	ld	ra,8(sp)
    80200658:	6402                	ld	s0,0(sp)
    8020065a:	0141                	addi	sp,sp,16
    8020065c:	8082                	ret

000000008020065e <uart_putc>:

// 发送单个字符
void uart_putc(char c) {
    8020065e:	1101                	addi	sp,sp,-32
    80200660:	ec22                	sd	s0,24(sp)
    80200662:	1000                	addi	s0,sp,32
    80200664:	87aa                	mv	a5,a0
    80200666:	fef407a3          	sb	a5,-17(s0)
    // 等待发送缓冲区空闲
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    8020066a:	0001                	nop
    8020066c:	100007b7          	lui	a5,0x10000
    80200670:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200672:	0007c783          	lbu	a5,0(a5)
    80200676:	0ff7f793          	zext.b	a5,a5
    8020067a:	2781                	sext.w	a5,a5
    8020067c:	0207f793          	andi	a5,a5,32
    80200680:	2781                	sext.w	a5,a5
    80200682:	d7ed                	beqz	a5,8020066c <uart_putc+0xe>
    WriteReg(THR, c);
    80200684:	100007b7          	lui	a5,0x10000
    80200688:	fef44703          	lbu	a4,-17(s0)
    8020068c:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
}
    80200690:	0001                	nop
    80200692:	6462                	ld	s0,24(sp)
    80200694:	6105                	addi	sp,sp,32
    80200696:	8082                	ret

0000000080200698 <uart_puts>:

void uart_puts(char *s) {
    80200698:	7179                	addi	sp,sp,-48
    8020069a:	f422                	sd	s0,40(sp)
    8020069c:	1800                	addi	s0,sp,48
    8020069e:	fca43c23          	sd	a0,-40(s0)
    if (!s) return;
    802006a2:	fd843783          	ld	a5,-40(s0)
    802006a6:	c7b5                	beqz	a5,80200712 <uart_puts+0x7a>
    
    while (*s) {
    802006a8:	a8b9                	j	80200706 <uart_puts+0x6e>
        while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
    802006aa:	0001                	nop
    802006ac:	100007b7          	lui	a5,0x10000
    802006b0:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    802006b2:	0007c783          	lbu	a5,0(a5)
    802006b6:	0ff7f793          	zext.b	a5,a5
    802006ba:	2781                	sext.w	a5,a5
    802006bc:	0207f793          	andi	a5,a5,32
    802006c0:	2781                	sext.w	a5,a5
    802006c2:	d7ed                	beqz	a5,802006ac <uart_puts+0x14>
        int sent_count = 0;
    802006c4:	fe042623          	sw	zero,-20(s0)
        while (*s && sent_count < 4) { 
    802006c8:	a01d                	j	802006ee <uart_puts+0x56>
            WriteReg(THR, *s);
    802006ca:	100007b7          	lui	a5,0x10000
    802006ce:	fd843703          	ld	a4,-40(s0)
    802006d2:	00074703          	lbu	a4,0(a4)
    802006d6:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70200000>
            s++;
    802006da:	fd843783          	ld	a5,-40(s0)
    802006de:	0785                	addi	a5,a5,1
    802006e0:	fcf43c23          	sd	a5,-40(s0)
            sent_count++;
    802006e4:	fec42783          	lw	a5,-20(s0)
    802006e8:	2785                	addiw	a5,a5,1
    802006ea:	fef42623          	sw	a5,-20(s0)
        while (*s && sent_count < 4) { 
    802006ee:	fd843783          	ld	a5,-40(s0)
    802006f2:	0007c783          	lbu	a5,0(a5)
    802006f6:	cb81                	beqz	a5,80200706 <uart_puts+0x6e>
    802006f8:	fec42783          	lw	a5,-20(s0)
    802006fc:	0007871b          	sext.w	a4,a5
    80200700:	478d                	li	a5,3
    80200702:	fce7d4e3          	bge	a5,a4,802006ca <uart_puts+0x32>
    while (*s) {
    80200706:	fd843783          	ld	a5,-40(s0)
    8020070a:	0007c783          	lbu	a5,0(a5)
    8020070e:	ffd1                	bnez	a5,802006aa <uart_puts+0x12>
    80200710:	a011                	j	80200714 <uart_puts+0x7c>
    if (!s) return;
    80200712:	0001                	nop
        }
    }
}
    80200714:	7422                	ld	s0,40(sp)
    80200716:	6145                	addi	sp,sp,48
    80200718:	8082                	ret

000000008020071a <uart_getc>:

int uart_getc(void) {
    8020071a:	1141                	addi	sp,sp,-16
    8020071c:	e422                	sd	s0,8(sp)
    8020071e:	0800                	addi	s0,sp,16
    if ((ReadReg(LSR) & LSR_RX_READY) == 0)
    80200720:	100007b7          	lui	a5,0x10000
    80200724:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200726:	0007c783          	lbu	a5,0(a5)
    8020072a:	0ff7f793          	zext.b	a5,a5
    8020072e:	2781                	sext.w	a5,a5
    80200730:	8b85                	andi	a5,a5,1
    80200732:	2781                	sext.w	a5,a5
    80200734:	e399                	bnez	a5,8020073a <uart_getc+0x20>
        return -1; 
    80200736:	57fd                	li	a5,-1
    80200738:	a801                	j	80200748 <uart_getc+0x2e>
    return ReadReg(RHR); 
    8020073a:	100007b7          	lui	a5,0x10000
    8020073e:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    80200742:	0ff7f793          	zext.b	a5,a5
    80200746:	2781                	sext.w	a5,a5
}
    80200748:	853e                	mv	a0,a5
    8020074a:	6422                	ld	s0,8(sp)
    8020074c:	0141                	addi	sp,sp,16
    8020074e:	8082                	ret

0000000080200750 <uart_intr>:

void uart_intr(void) {
    80200750:	1101                	addi	sp,sp,-32
    80200752:	ec06                	sd	ra,24(sp)
    80200754:	e822                	sd	s0,16(sp)
    80200756:	1000                	addi	s0,sp,32
    static char linebuf[LINE_BUF_SIZE];
    static int line_len = 0;

    while (ReadReg(LSR) & LSR_RX_READY) {
    80200758:	a411                	j	8020095c <uart_intr+0x20c>
        char c = ReadReg(RHR);
    8020075a:	100007b7          	lui	a5,0x10000
    8020075e:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    80200762:	fef405a3          	sb	a5,-21(s0)
		if (c == 0x0c) { // 是'L'与 0x1f按位与的结果
    80200766:	feb44783          	lbu	a5,-21(s0)
    8020076a:	0ff7f713          	zext.b	a4,a5
    8020076e:	47b1                	li	a5,12
    80200770:	00f71763          	bne	a4,a5,8020077e <uart_intr+0x2e>
            clear_screen();
    80200774:	00001097          	auipc	ra,0x1
    80200778:	aaa080e7          	jalr	-1366(ra) # 8020121e <clear_screen>
            continue;
    8020077c:	a2c5                	j	8020095c <uart_intr+0x20c>
        }
        if (c == '\r' || c == '\n') {
    8020077e:	feb44783          	lbu	a5,-21(s0)
    80200782:	0ff7f713          	zext.b	a4,a5
    80200786:	47b5                	li	a5,13
    80200788:	00f70963          	beq	a4,a5,8020079a <uart_intr+0x4a>
    8020078c:	feb44783          	lbu	a5,-21(s0)
    80200790:	0ff7f713          	zext.b	a4,a5
    80200794:	47a9                	li	a5,10
    80200796:	10f71763          	bne	a4,a5,802008a4 <uart_intr+0x154>
            uart_putc('\n');
    8020079a:	4529                	li	a0,10
    8020079c:	00000097          	auipc	ra,0x0
    802007a0:	ec2080e7          	jalr	-318(ra) # 8020065e <uart_putc>
            // 将编辑好的整行写入全局缓冲区
            for (int i = 0; i < line_len; i++) {
    802007a4:	fe042623          	sw	zero,-20(s0)
    802007a8:	a8b5                	j	80200824 <uart_intr+0xd4>
                int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    802007aa:	00027797          	auipc	a5,0x27
    802007ae:	91678793          	addi	a5,a5,-1770 # 802270c0 <uart_input_buf>
    802007b2:	0847a783          	lw	a5,132(a5)
    802007b6:	2785                	addiw	a5,a5,1
    802007b8:	2781                	sext.w	a5,a5
    802007ba:	2781                	sext.w	a5,a5
    802007bc:	07f7f793          	andi	a5,a5,127
    802007c0:	fef42023          	sw	a5,-32(s0)
                if (next != uart_input_buf.r) {
    802007c4:	00027797          	auipc	a5,0x27
    802007c8:	8fc78793          	addi	a5,a5,-1796 # 802270c0 <uart_input_buf>
    802007cc:	0807a703          	lw	a4,128(a5)
    802007d0:	fe042783          	lw	a5,-32(s0)
    802007d4:	04f70363          	beq	a4,a5,8020081a <uart_intr+0xca>
                    uart_input_buf.buf[uart_input_buf.w] = linebuf[i];
    802007d8:	00027797          	auipc	a5,0x27
    802007dc:	8e878793          	addi	a5,a5,-1816 # 802270c0 <uart_input_buf>
    802007e0:	0847a603          	lw	a2,132(a5)
    802007e4:	00027717          	auipc	a4,0x27
    802007e8:	96c70713          	addi	a4,a4,-1684 # 80227150 <linebuf.1>
    802007ec:	fec42783          	lw	a5,-20(s0)
    802007f0:	97ba                	add	a5,a5,a4
    802007f2:	0007c703          	lbu	a4,0(a5)
    802007f6:	00027697          	auipc	a3,0x27
    802007fa:	8ca68693          	addi	a3,a3,-1846 # 802270c0 <uart_input_buf>
    802007fe:	02061793          	slli	a5,a2,0x20
    80200802:	9381                	srli	a5,a5,0x20
    80200804:	97b6                	add	a5,a5,a3
    80200806:	00e78023          	sb	a4,0(a5)
                    uart_input_buf.w = next;
    8020080a:	fe042703          	lw	a4,-32(s0)
    8020080e:	00027797          	auipc	a5,0x27
    80200812:	8b278793          	addi	a5,a5,-1870 # 802270c0 <uart_input_buf>
    80200816:	08e7a223          	sw	a4,132(a5)
            for (int i = 0; i < line_len; i++) {
    8020081a:	fec42783          	lw	a5,-20(s0)
    8020081e:	2785                	addiw	a5,a5,1
    80200820:	fef42623          	sw	a5,-20(s0)
    80200824:	00027797          	auipc	a5,0x27
    80200828:	9ac78793          	addi	a5,a5,-1620 # 802271d0 <line_len.0>
    8020082c:	4398                	lw	a4,0(a5)
    8020082e:	fec42783          	lw	a5,-20(s0)
    80200832:	2781                	sext.w	a5,a5
    80200834:	f6e7cbe3          	blt	a5,a4,802007aa <uart_intr+0x5a>
                }
            }
            // 写入换行符
            int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    80200838:	00027797          	auipc	a5,0x27
    8020083c:	88878793          	addi	a5,a5,-1912 # 802270c0 <uart_input_buf>
    80200840:	0847a783          	lw	a5,132(a5)
    80200844:	2785                	addiw	a5,a5,1
    80200846:	2781                	sext.w	a5,a5
    80200848:	2781                	sext.w	a5,a5
    8020084a:	07f7f793          	andi	a5,a5,127
    8020084e:	fef42223          	sw	a5,-28(s0)
            if (next != uart_input_buf.r) {
    80200852:	00027797          	auipc	a5,0x27
    80200856:	86e78793          	addi	a5,a5,-1938 # 802270c0 <uart_input_buf>
    8020085a:	0807a703          	lw	a4,128(a5)
    8020085e:	fe442783          	lw	a5,-28(s0)
    80200862:	02f70a63          	beq	a4,a5,80200896 <uart_intr+0x146>
                uart_input_buf.buf[uart_input_buf.w] = '\n';
    80200866:	00027797          	auipc	a5,0x27
    8020086a:	85a78793          	addi	a5,a5,-1958 # 802270c0 <uart_input_buf>
    8020086e:	0847a783          	lw	a5,132(a5)
    80200872:	00027717          	auipc	a4,0x27
    80200876:	84e70713          	addi	a4,a4,-1970 # 802270c0 <uart_input_buf>
    8020087a:	1782                	slli	a5,a5,0x20
    8020087c:	9381                	srli	a5,a5,0x20
    8020087e:	97ba                	add	a5,a5,a4
    80200880:	4729                	li	a4,10
    80200882:	00e78023          	sb	a4,0(a5)
                uart_input_buf.w = next;
    80200886:	fe442703          	lw	a4,-28(s0)
    8020088a:	00027797          	auipc	a5,0x27
    8020088e:	83678793          	addi	a5,a5,-1994 # 802270c0 <uart_input_buf>
    80200892:	08e7a223          	sw	a4,132(a5)
            }
            line_len = 0;
    80200896:	00027797          	auipc	a5,0x27
    8020089a:	93a78793          	addi	a5,a5,-1734 # 802271d0 <line_len.0>
    8020089e:	0007a023          	sw	zero,0(a5)
        if (c == '\r' || c == '\n') {
    802008a2:	a86d                	j	8020095c <uart_intr+0x20c>
        } else if (c == 0x7f || c == 0x08) { // 退格
    802008a4:	feb44783          	lbu	a5,-21(s0)
    802008a8:	0ff7f713          	zext.b	a4,a5
    802008ac:	07f00793          	li	a5,127
    802008b0:	00f70963          	beq	a4,a5,802008c2 <uart_intr+0x172>
    802008b4:	feb44783          	lbu	a5,-21(s0)
    802008b8:	0ff7f713          	zext.b	a4,a5
    802008bc:	47a1                	li	a5,8
    802008be:	04f71763          	bne	a4,a5,8020090c <uart_intr+0x1bc>
            if (line_len > 0) {
    802008c2:	00027797          	auipc	a5,0x27
    802008c6:	90e78793          	addi	a5,a5,-1778 # 802271d0 <line_len.0>
    802008ca:	439c                	lw	a5,0(a5)
    802008cc:	08f05863          	blez	a5,8020095c <uart_intr+0x20c>
                uart_putc('\b');
    802008d0:	4521                	li	a0,8
    802008d2:	00000097          	auipc	ra,0x0
    802008d6:	d8c080e7          	jalr	-628(ra) # 8020065e <uart_putc>
                uart_putc(' ');
    802008da:	02000513          	li	a0,32
    802008de:	00000097          	auipc	ra,0x0
    802008e2:	d80080e7          	jalr	-640(ra) # 8020065e <uart_putc>
                uart_putc('\b');
    802008e6:	4521                	li	a0,8
    802008e8:	00000097          	auipc	ra,0x0
    802008ec:	d76080e7          	jalr	-650(ra) # 8020065e <uart_putc>
                line_len--;
    802008f0:	00027797          	auipc	a5,0x27
    802008f4:	8e078793          	addi	a5,a5,-1824 # 802271d0 <line_len.0>
    802008f8:	439c                	lw	a5,0(a5)
    802008fa:	37fd                	addiw	a5,a5,-1
    802008fc:	0007871b          	sext.w	a4,a5
    80200900:	00027797          	auipc	a5,0x27
    80200904:	8d078793          	addi	a5,a5,-1840 # 802271d0 <line_len.0>
    80200908:	c398                	sw	a4,0(a5)
            if (line_len > 0) {
    8020090a:	a889                	j	8020095c <uart_intr+0x20c>
            }
        } else if (line_len < LINE_BUF_SIZE - 1) {
    8020090c:	00027797          	auipc	a5,0x27
    80200910:	8c478793          	addi	a5,a5,-1852 # 802271d0 <line_len.0>
    80200914:	439c                	lw	a5,0(a5)
    80200916:	873e                	mv	a4,a5
    80200918:	07e00793          	li	a5,126
    8020091c:	04e7c063          	blt	a5,a4,8020095c <uart_intr+0x20c>
            uart_putc(c);
    80200920:	feb44783          	lbu	a5,-21(s0)
    80200924:	853e                	mv	a0,a5
    80200926:	00000097          	auipc	ra,0x0
    8020092a:	d38080e7          	jalr	-712(ra) # 8020065e <uart_putc>
            linebuf[line_len++] = c;
    8020092e:	00027797          	auipc	a5,0x27
    80200932:	8a278793          	addi	a5,a5,-1886 # 802271d0 <line_len.0>
    80200936:	439c                	lw	a5,0(a5)
    80200938:	0017871b          	addiw	a4,a5,1
    8020093c:	0007069b          	sext.w	a3,a4
    80200940:	00027717          	auipc	a4,0x27
    80200944:	89070713          	addi	a4,a4,-1904 # 802271d0 <line_len.0>
    80200948:	c314                	sw	a3,0(a4)
    8020094a:	00027717          	auipc	a4,0x27
    8020094e:	80670713          	addi	a4,a4,-2042 # 80227150 <linebuf.1>
    80200952:	97ba                	add	a5,a5,a4
    80200954:	feb44703          	lbu	a4,-21(s0)
    80200958:	00e78023          	sb	a4,0(a5)
    while (ReadReg(LSR) & LSR_RX_READY) {
    8020095c:	100007b7          	lui	a5,0x10000
    80200960:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    80200962:	0007c783          	lbu	a5,0(a5)
    80200966:	0ff7f793          	zext.b	a5,a5
    8020096a:	2781                	sext.w	a5,a5
    8020096c:	8b85                	andi	a5,a5,1
    8020096e:	2781                	sext.w	a5,a5
    80200970:	de0795e3          	bnez	a5,8020075a <uart_intr+0xa>
        }
    }
}
    80200974:	0001                	nop
    80200976:	0001                	nop
    80200978:	60e2                	ld	ra,24(sp)
    8020097a:	6442                	ld	s0,16(sp)
    8020097c:	6105                	addi	sp,sp,32
    8020097e:	8082                	ret

0000000080200980 <uart_getc_blocking>:
// 阻塞式读取一个字符
char uart_getc_blocking(void) {
    80200980:	1101                	addi	sp,sp,-32
    80200982:	ec22                	sd	s0,24(sp)
    80200984:	1000                	addi	s0,sp,32
    // 等待直到有字符可读
    while (uart_input_buf.r == uart_input_buf.w) {
    80200986:	a011                	j	8020098a <uart_getc_blocking+0xa>
        // 在实际系统中，这里可能需要让进程睡眠
        // 但目前我们使用简单的轮询
        asm volatile("nop");
    80200988:	0001                	nop
    while (uart_input_buf.r == uart_input_buf.w) {
    8020098a:	00026797          	auipc	a5,0x26
    8020098e:	73678793          	addi	a5,a5,1846 # 802270c0 <uart_input_buf>
    80200992:	0807a703          	lw	a4,128(a5)
    80200996:	00026797          	auipc	a5,0x26
    8020099a:	72a78793          	addi	a5,a5,1834 # 802270c0 <uart_input_buf>
    8020099e:	0847a783          	lw	a5,132(a5)
    802009a2:	fef703e3          	beq	a4,a5,80200988 <uart_getc_blocking+0x8>
    }
    
    // 读取字符
    char c = uart_input_buf.buf[uart_input_buf.r];
    802009a6:	00026797          	auipc	a5,0x26
    802009aa:	71a78793          	addi	a5,a5,1818 # 802270c0 <uart_input_buf>
    802009ae:	0807a783          	lw	a5,128(a5)
    802009b2:	00026717          	auipc	a4,0x26
    802009b6:	70e70713          	addi	a4,a4,1806 # 802270c0 <uart_input_buf>
    802009ba:	1782                	slli	a5,a5,0x20
    802009bc:	9381                	srli	a5,a5,0x20
    802009be:	97ba                	add	a5,a5,a4
    802009c0:	0007c783          	lbu	a5,0(a5)
    802009c4:	fef407a3          	sb	a5,-17(s0)
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    802009c8:	00026797          	auipc	a5,0x26
    802009cc:	6f878793          	addi	a5,a5,1784 # 802270c0 <uart_input_buf>
    802009d0:	0807a783          	lw	a5,128(a5)
    802009d4:	2785                	addiw	a5,a5,1
    802009d6:	2781                	sext.w	a5,a5
    802009d8:	07f7f793          	andi	a5,a5,127
    802009dc:	0007871b          	sext.w	a4,a5
    802009e0:	00026797          	auipc	a5,0x26
    802009e4:	6e078793          	addi	a5,a5,1760 # 802270c0 <uart_input_buf>
    802009e8:	08e7a023          	sw	a4,128(a5)
    return c;
    802009ec:	fef44783          	lbu	a5,-17(s0)
}
    802009f0:	853e                	mv	a0,a5
    802009f2:	6462                	ld	s0,24(sp)
    802009f4:	6105                	addi	sp,sp,32
    802009f6:	8082                	ret

00000000802009f8 <readline>:
// 读取一行输入，最多读取max-1个字符，并在末尾添加\0
int readline(char *buf, int max) {
    802009f8:	7179                	addi	sp,sp,-48
    802009fa:	f406                	sd	ra,40(sp)
    802009fc:	f022                	sd	s0,32(sp)
    802009fe:	1800                	addi	s0,sp,48
    80200a00:	fca43c23          	sd	a0,-40(s0)
    80200a04:	87ae                	mv	a5,a1
    80200a06:	fcf42a23          	sw	a5,-44(s0)
    int i = 0;
    80200a0a:	fe042623          	sw	zero,-20(s0)
    char c;
    
    while (i < max - 1) {
    80200a0e:	a0b9                	j	80200a5c <readline+0x64>
        c = uart_getc_blocking();
    80200a10:	00000097          	auipc	ra,0x0
    80200a14:	f70080e7          	jalr	-144(ra) # 80200980 <uart_getc_blocking>
    80200a18:	87aa                	mv	a5,a0
    80200a1a:	fef405a3          	sb	a5,-21(s0)
        
        if (c == '\n') {
    80200a1e:	feb44783          	lbu	a5,-21(s0)
    80200a22:	0ff7f713          	zext.b	a4,a5
    80200a26:	47a9                	li	a5,10
    80200a28:	00f71c63          	bne	a4,a5,80200a40 <readline+0x48>
            buf[i] = '\0';
    80200a2c:	fec42783          	lw	a5,-20(s0)
    80200a30:	fd843703          	ld	a4,-40(s0)
    80200a34:	97ba                	add	a5,a5,a4
    80200a36:	00078023          	sb	zero,0(a5)
            return i;
    80200a3a:	fec42783          	lw	a5,-20(s0)
    80200a3e:	a0a9                	j	80200a88 <readline+0x90>
        } else {
            buf[i++] = c;
    80200a40:	fec42783          	lw	a5,-20(s0)
    80200a44:	0017871b          	addiw	a4,a5,1
    80200a48:	fee42623          	sw	a4,-20(s0)
    80200a4c:	873e                	mv	a4,a5
    80200a4e:	fd843783          	ld	a5,-40(s0)
    80200a52:	97ba                	add	a5,a5,a4
    80200a54:	feb44703          	lbu	a4,-21(s0)
    80200a58:	00e78023          	sb	a4,0(a5)
    while (i < max - 1) {
    80200a5c:	fd442783          	lw	a5,-44(s0)
    80200a60:	37fd                	addiw	a5,a5,-1
    80200a62:	0007871b          	sext.w	a4,a5
    80200a66:	fec42783          	lw	a5,-20(s0)
    80200a6a:	2781                	sext.w	a5,a5
    80200a6c:	fae7c2e3          	blt	a5,a4,80200a10 <readline+0x18>
        }
    }
    
    // 缓冲区满，添加\0并返回
    buf[max-1] = '\0';
    80200a70:	fd442783          	lw	a5,-44(s0)
    80200a74:	17fd                	addi	a5,a5,-1
    80200a76:	fd843703          	ld	a4,-40(s0)
    80200a7a:	97ba                	add	a5,a5,a4
    80200a7c:	00078023          	sb	zero,0(a5)
    return max-1;
    80200a80:	fd442783          	lw	a5,-44(s0)
    80200a84:	37fd                	addiw	a5,a5,-1
    80200a86:	2781                	sext.w	a5,a5
    80200a88:	853e                	mv	a0,a5
    80200a8a:	70a2                	ld	ra,40(sp)
    80200a8c:	7402                	ld	s0,32(sp)
    80200a8e:	6145                	addi	sp,sp,48
    80200a90:	8082                	ret

0000000080200a92 <flush_printf_buffer>:

extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    80200a92:	1141                	addi	sp,sp,-16
    80200a94:	e406                	sd	ra,8(sp)
    80200a96:	e022                	sd	s0,0(sp)
    80200a98:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    80200a9a:	00026797          	auipc	a5,0x26
    80200a9e:	7be78793          	addi	a5,a5,1982 # 80227258 <printf_buf_pos>
    80200aa2:	439c                	lw	a5,0(a5)
    80200aa4:	02f05c63          	blez	a5,80200adc <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200aa8:	00026797          	auipc	a5,0x26
    80200aac:	7b078793          	addi	a5,a5,1968 # 80227258 <printf_buf_pos>
    80200ab0:	439c                	lw	a5,0(a5)
    80200ab2:	00026717          	auipc	a4,0x26
    80200ab6:	72670713          	addi	a4,a4,1830 # 802271d8 <printf_buffer>
    80200aba:	97ba                	add	a5,a5,a4
    80200abc:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80200ac0:	00026517          	auipc	a0,0x26
    80200ac4:	71850513          	addi	a0,a0,1816 # 802271d8 <printf_buffer>
    80200ac8:	00000097          	auipc	ra,0x0
    80200acc:	bd0080e7          	jalr	-1072(ra) # 80200698 <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200ad0:	00026797          	auipc	a5,0x26
    80200ad4:	78878793          	addi	a5,a5,1928 # 80227258 <printf_buf_pos>
    80200ad8:	0007a023          	sw	zero,0(a5)
	}
}
    80200adc:	0001                	nop
    80200ade:	60a2                	ld	ra,8(sp)
    80200ae0:	6402                	ld	s0,0(sp)
    80200ae2:	0141                	addi	sp,sp,16
    80200ae4:	8082                	ret

0000000080200ae6 <buffer_char>:
static void buffer_char(char c) {
    80200ae6:	1101                	addi	sp,sp,-32
    80200ae8:	ec06                	sd	ra,24(sp)
    80200aea:	e822                	sd	s0,16(sp)
    80200aec:	1000                	addi	s0,sp,32
    80200aee:	87aa                	mv	a5,a0
    80200af0:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    80200af4:	00026797          	auipc	a5,0x26
    80200af8:	76478793          	addi	a5,a5,1892 # 80227258 <printf_buf_pos>
    80200afc:	439c                	lw	a5,0(a5)
    80200afe:	873e                	mv	a4,a5
    80200b00:	07e00793          	li	a5,126
    80200b04:	02e7ca63          	blt	a5,a4,80200b38 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200b08:	00026797          	auipc	a5,0x26
    80200b0c:	75078793          	addi	a5,a5,1872 # 80227258 <printf_buf_pos>
    80200b10:	439c                	lw	a5,0(a5)
    80200b12:	0017871b          	addiw	a4,a5,1
    80200b16:	0007069b          	sext.w	a3,a4
    80200b1a:	00026717          	auipc	a4,0x26
    80200b1e:	73e70713          	addi	a4,a4,1854 # 80227258 <printf_buf_pos>
    80200b22:	c314                	sw	a3,0(a4)
    80200b24:	00026717          	auipc	a4,0x26
    80200b28:	6b470713          	addi	a4,a4,1716 # 802271d8 <printf_buffer>
    80200b2c:	97ba                	add	a5,a5,a4
    80200b2e:	fef44703          	lbu	a4,-17(s0)
    80200b32:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    80200b36:	a825                	j	80200b6e <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    80200b38:	00000097          	auipc	ra,0x0
    80200b3c:	f5a080e7          	jalr	-166(ra) # 80200a92 <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    80200b40:	00026797          	auipc	a5,0x26
    80200b44:	71878793          	addi	a5,a5,1816 # 80227258 <printf_buf_pos>
    80200b48:	439c                	lw	a5,0(a5)
    80200b4a:	0017871b          	addiw	a4,a5,1
    80200b4e:	0007069b          	sext.w	a3,a4
    80200b52:	00026717          	auipc	a4,0x26
    80200b56:	70670713          	addi	a4,a4,1798 # 80227258 <printf_buf_pos>
    80200b5a:	c314                	sw	a3,0(a4)
    80200b5c:	00026717          	auipc	a4,0x26
    80200b60:	67c70713          	addi	a4,a4,1660 # 802271d8 <printf_buffer>
    80200b64:	97ba                	add	a5,a5,a4
    80200b66:	fef44703          	lbu	a4,-17(s0)
    80200b6a:	00e78023          	sb	a4,0(a5)
}
    80200b6e:	0001                	nop
    80200b70:	60e2                	ld	ra,24(sp)
    80200b72:	6442                	ld	s0,16(sp)
    80200b74:	6105                	addi	sp,sp,32
    80200b76:	8082                	ret

0000000080200b78 <consputc>:

static void consputc(int c){
    80200b78:	1101                	addi	sp,sp,-32
    80200b7a:	ec06                	sd	ra,24(sp)
    80200b7c:	e822                	sd	s0,16(sp)
    80200b7e:	1000                	addi	s0,sp,32
    80200b80:	87aa                	mv	a5,a0
    80200b82:	fef42623          	sw	a5,-20(s0)
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
    80200b86:	fec42783          	lw	a5,-20(s0)
    80200b8a:	0ff7f793          	zext.b	a5,a5
    80200b8e:	853e                	mv	a0,a5
    80200b90:	00000097          	auipc	ra,0x0
    80200b94:	ace080e7          	jalr	-1330(ra) # 8020065e <uart_putc>
}
    80200b98:	0001                	nop
    80200b9a:	60e2                	ld	ra,24(sp)
    80200b9c:	6442                	ld	s0,16(sp)
    80200b9e:	6105                	addi	sp,sp,32
    80200ba0:	8082                	ret

0000000080200ba2 <consputs>:
static void consputs(const char *s){
    80200ba2:	7179                	addi	sp,sp,-48
    80200ba4:	f406                	sd	ra,40(sp)
    80200ba6:	f022                	sd	s0,32(sp)
    80200ba8:	1800                	addi	s0,sp,48
    80200baa:	fca43c23          	sd	a0,-40(s0)
	char *str = (char *)s;
    80200bae:	fd843783          	ld	a5,-40(s0)
    80200bb2:	fef43423          	sd	a5,-24(s0)
	// 直接调用uart_puts输出字符串
	uart_puts(str);
    80200bb6:	fe843503          	ld	a0,-24(s0)
    80200bba:	00000097          	auipc	ra,0x0
    80200bbe:	ade080e7          	jalr	-1314(ra) # 80200698 <uart_puts>
}
    80200bc2:	0001                	nop
    80200bc4:	70a2                	ld	ra,40(sp)
    80200bc6:	7402                	ld	s0,32(sp)
    80200bc8:	6145                	addi	sp,sp,48
    80200bca:	8082                	ret

0000000080200bcc <printint>:
static void printint(long long xx, int base, int sign, int width, int padzero){
    80200bcc:	7159                	addi	sp,sp,-112
    80200bce:	f486                	sd	ra,104(sp)
    80200bd0:	f0a2                	sd	s0,96(sp)
    80200bd2:	1880                	addi	s0,sp,112
    80200bd4:	faa43423          	sd	a0,-88(s0)
    80200bd8:	87ae                	mv	a5,a1
    80200bda:	faf42223          	sw	a5,-92(s0)
    80200bde:	87b2                	mv	a5,a2
    80200be0:	faf42023          	sw	a5,-96(s0)
    80200be4:	87b6                	mv	a5,a3
    80200be6:	f8f42e23          	sw	a5,-100(s0)
    80200bea:	87ba                	mv	a5,a4
    80200bec:	f8f42c23          	sw	a5,-104(s0)
    static char digits[] = "0123456789abcdef";
    char buf[32];
    int i = 0;
    80200bf0:	fe042623          	sw	zero,-20(s0)
    unsigned long long x;

    if (sign && (sign = xx < 0))
    80200bf4:	fa042783          	lw	a5,-96(s0)
    80200bf8:	2781                	sext.w	a5,a5
    80200bfa:	c39d                	beqz	a5,80200c20 <printint+0x54>
    80200bfc:	fa843783          	ld	a5,-88(s0)
    80200c00:	93fd                	srli	a5,a5,0x3f
    80200c02:	0ff7f793          	zext.b	a5,a5
    80200c06:	faf42023          	sw	a5,-96(s0)
    80200c0a:	fa042783          	lw	a5,-96(s0)
    80200c0e:	2781                	sext.w	a5,a5
    80200c10:	cb81                	beqz	a5,80200c20 <printint+0x54>
        x = -(unsigned long long)xx;
    80200c12:	fa843783          	ld	a5,-88(s0)
    80200c16:	40f007b3          	neg	a5,a5
    80200c1a:	fef43023          	sd	a5,-32(s0)
    80200c1e:	a029                	j	80200c28 <printint+0x5c>
    else
        x = xx;
    80200c20:	fa843783          	ld	a5,-88(s0)
    80200c24:	fef43023          	sd	a5,-32(s0)

    do {
        buf[i++] = digits[x % base];
    80200c28:	fa442783          	lw	a5,-92(s0)
    80200c2c:	fe043703          	ld	a4,-32(s0)
    80200c30:	02f77733          	remu	a4,a4,a5
    80200c34:	fec42783          	lw	a5,-20(s0)
    80200c38:	0017869b          	addiw	a3,a5,1
    80200c3c:	fed42623          	sw	a3,-20(s0)
    80200c40:	00026697          	auipc	a3,0x26
    80200c44:	43068693          	addi	a3,a3,1072 # 80227070 <digits.0>
    80200c48:	9736                	add	a4,a4,a3
    80200c4a:	00074703          	lbu	a4,0(a4)
    80200c4e:	17c1                	addi	a5,a5,-16
    80200c50:	97a2                	add	a5,a5,s0
    80200c52:	fce78423          	sb	a4,-56(a5)
    } while ((x /= base) != 0);
    80200c56:	fa442783          	lw	a5,-92(s0)
    80200c5a:	fe043703          	ld	a4,-32(s0)
    80200c5e:	02f757b3          	divu	a5,a4,a5
    80200c62:	fef43023          	sd	a5,-32(s0)
    80200c66:	fe043783          	ld	a5,-32(s0)
    80200c6a:	ffdd                	bnez	a5,80200c28 <printint+0x5c>

    if (sign)
    80200c6c:	fa042783          	lw	a5,-96(s0)
    80200c70:	2781                	sext.w	a5,a5
    80200c72:	cf89                	beqz	a5,80200c8c <printint+0xc0>
        buf[i++] = '-';
    80200c74:	fec42783          	lw	a5,-20(s0)
    80200c78:	0017871b          	addiw	a4,a5,1
    80200c7c:	fee42623          	sw	a4,-20(s0)
    80200c80:	17c1                	addi	a5,a5,-16
    80200c82:	97a2                	add	a5,a5,s0
    80200c84:	02d00713          	li	a4,45
    80200c88:	fce78423          	sb	a4,-56(a5)

    // 计算需要补的填充字符数
    int pad = width - i;
    80200c8c:	f9c42783          	lw	a5,-100(s0)
    80200c90:	873e                	mv	a4,a5
    80200c92:	fec42783          	lw	a5,-20(s0)
    80200c96:	40f707bb          	subw	a5,a4,a5
    80200c9a:	fcf42e23          	sw	a5,-36(s0)
    while (pad-- > 0) {
    80200c9e:	a839                	j	80200cbc <printint+0xf0>
        consputc(padzero ? '0' : ' ');
    80200ca0:	f9842783          	lw	a5,-104(s0)
    80200ca4:	2781                	sext.w	a5,a5
    80200ca6:	c781                	beqz	a5,80200cae <printint+0xe2>
    80200ca8:	03000793          	li	a5,48
    80200cac:	a019                	j	80200cb2 <printint+0xe6>
    80200cae:	02000793          	li	a5,32
    80200cb2:	853e                	mv	a0,a5
    80200cb4:	00000097          	auipc	ra,0x0
    80200cb8:	ec4080e7          	jalr	-316(ra) # 80200b78 <consputc>
    while (pad-- > 0) {
    80200cbc:	fdc42783          	lw	a5,-36(s0)
    80200cc0:	fff7871b          	addiw	a4,a5,-1
    80200cc4:	fce42e23          	sw	a4,-36(s0)
    80200cc8:	fcf04ce3          	bgtz	a5,80200ca0 <printint+0xd4>
    }

    while (--i >= 0)
    80200ccc:	a829                	j	80200ce6 <printint+0x11a>
        consputc(buf[i]);
    80200cce:	fec42783          	lw	a5,-20(s0)
    80200cd2:	17c1                	addi	a5,a5,-16
    80200cd4:	97a2                	add	a5,a5,s0
    80200cd6:	fc87c783          	lbu	a5,-56(a5)
    80200cda:	2781                	sext.w	a5,a5
    80200cdc:	853e                	mv	a0,a5
    80200cde:	00000097          	auipc	ra,0x0
    80200ce2:	e9a080e7          	jalr	-358(ra) # 80200b78 <consputc>
    while (--i >= 0)
    80200ce6:	fec42783          	lw	a5,-20(s0)
    80200cea:	37fd                	addiw	a5,a5,-1
    80200cec:	fef42623          	sw	a5,-20(s0)
    80200cf0:	fec42783          	lw	a5,-20(s0)
    80200cf4:	2781                	sext.w	a5,a5
    80200cf6:	fc07dce3          	bgez	a5,80200cce <printint+0x102>
}
    80200cfa:	0001                	nop
    80200cfc:	0001                	nop
    80200cfe:	70a6                	ld	ra,104(sp)
    80200d00:	7406                	ld	s0,96(sp)
    80200d02:	6165                	addi	sp,sp,112
    80200d04:	8082                	ret

0000000080200d06 <printf>:
void printf(const char *fmt, ...) {
    80200d06:	7171                	addi	sp,sp,-176
    80200d08:	f486                	sd	ra,104(sp)
    80200d0a:	f0a2                	sd	s0,96(sp)
    80200d0c:	1880                	addi	s0,sp,112
    80200d0e:	f8a43c23          	sd	a0,-104(s0)
    80200d12:	e40c                	sd	a1,8(s0)
    80200d14:	e810                	sd	a2,16(s0)
    80200d16:	ec14                	sd	a3,24(s0)
    80200d18:	f018                	sd	a4,32(s0)
    80200d1a:	f41c                	sd	a5,40(s0)
    80200d1c:	03043823          	sd	a6,48(s0)
    80200d20:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    80200d24:	04040793          	addi	a5,s0,64
    80200d28:	f8f43823          	sd	a5,-112(s0)
    80200d2c:	f9043783          	ld	a5,-112(s0)
    80200d30:	fc878793          	addi	a5,a5,-56
    80200d34:	faf43c23          	sd	a5,-72(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200d38:	fe042623          	sw	zero,-20(s0)
    80200d3c:	a945                	j	802011ec <printf+0x4e6>
        if(c != '%'){
    80200d3e:	fe842783          	lw	a5,-24(s0)
    80200d42:	0007871b          	sext.w	a4,a5
    80200d46:	02500793          	li	a5,37
    80200d4a:	00f70c63          	beq	a4,a5,80200d62 <printf+0x5c>
            buffer_char(c);
    80200d4e:	fe842783          	lw	a5,-24(s0)
    80200d52:	0ff7f793          	zext.b	a5,a5
    80200d56:	853e                	mv	a0,a5
    80200d58:	00000097          	auipc	ra,0x0
    80200d5c:	d8e080e7          	jalr	-626(ra) # 80200ae6 <buffer_char>
            continue;
    80200d60:	a149                	j	802011e2 <printf+0x4dc>
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    80200d62:	00000097          	auipc	ra,0x0
    80200d66:	d30080e7          	jalr	-720(ra) # 80200a92 <flush_printf_buffer>
		// 解析填充标志和宽度
        int padzero = 0, width = 0;
    80200d6a:	fc042e23          	sw	zero,-36(s0)
    80200d6e:	fc042c23          	sw	zero,-40(s0)
        c = fmt[++i] & 0xff;
    80200d72:	fec42783          	lw	a5,-20(s0)
    80200d76:	2785                	addiw	a5,a5,1
    80200d78:	fef42623          	sw	a5,-20(s0)
    80200d7c:	fec42783          	lw	a5,-20(s0)
    80200d80:	f9843703          	ld	a4,-104(s0)
    80200d84:	97ba                	add	a5,a5,a4
    80200d86:	0007c783          	lbu	a5,0(a5)
    80200d8a:	fef42423          	sw	a5,-24(s0)
        if (c == '0') {
    80200d8e:	fe842783          	lw	a5,-24(s0)
    80200d92:	0007871b          	sext.w	a4,a5
    80200d96:	03000793          	li	a5,48
    80200d9a:	06f71563          	bne	a4,a5,80200e04 <printf+0xfe>
            padzero = 1;
    80200d9e:	4785                	li	a5,1
    80200da0:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    80200da4:	fec42783          	lw	a5,-20(s0)
    80200da8:	2785                	addiw	a5,a5,1
    80200daa:	fef42623          	sw	a5,-20(s0)
    80200dae:	fec42783          	lw	a5,-20(s0)
    80200db2:	f9843703          	ld	a4,-104(s0)
    80200db6:	97ba                	add	a5,a5,a4
    80200db8:	0007c783          	lbu	a5,0(a5)
    80200dbc:	fef42423          	sw	a5,-24(s0)
        }
        while (c >= '0' && c <= '9') {
    80200dc0:	a091                	j	80200e04 <printf+0xfe>
            width = width * 10 + (c - '0');
    80200dc2:	fd842783          	lw	a5,-40(s0)
    80200dc6:	873e                	mv	a4,a5
    80200dc8:	87ba                	mv	a5,a4
    80200dca:	0027979b          	slliw	a5,a5,0x2
    80200dce:	9fb9                	addw	a5,a5,a4
    80200dd0:	0017979b          	slliw	a5,a5,0x1
    80200dd4:	0007871b          	sext.w	a4,a5
    80200dd8:	fe842783          	lw	a5,-24(s0)
    80200ddc:	fd07879b          	addiw	a5,a5,-48
    80200de0:	2781                	sext.w	a5,a5
    80200de2:	9fb9                	addw	a5,a5,a4
    80200de4:	fcf42c23          	sw	a5,-40(s0)
            c = fmt[++i] & 0xff;
    80200de8:	fec42783          	lw	a5,-20(s0)
    80200dec:	2785                	addiw	a5,a5,1
    80200dee:	fef42623          	sw	a5,-20(s0)
    80200df2:	fec42783          	lw	a5,-20(s0)
    80200df6:	f9843703          	ld	a4,-104(s0)
    80200dfa:	97ba                	add	a5,a5,a4
    80200dfc:	0007c783          	lbu	a5,0(a5)
    80200e00:	fef42423          	sw	a5,-24(s0)
        while (c >= '0' && c <= '9') {
    80200e04:	fe842783          	lw	a5,-24(s0)
    80200e08:	0007871b          	sext.w	a4,a5
    80200e0c:	02f00793          	li	a5,47
    80200e10:	00e7da63          	bge	a5,a4,80200e24 <printf+0x11e>
    80200e14:	fe842783          	lw	a5,-24(s0)
    80200e18:	0007871b          	sext.w	a4,a5
    80200e1c:	03900793          	li	a5,57
    80200e20:	fae7d1e3          	bge	a5,a4,80200dc2 <printf+0xbc>
        }
        // 检查是否有长整型标记'l'
        int is_long = 0;
    80200e24:	fc042a23          	sw	zero,-44(s0)
        if(c == 'l') {
    80200e28:	fe842783          	lw	a5,-24(s0)
    80200e2c:	0007871b          	sext.w	a4,a5
    80200e30:	06c00793          	li	a5,108
    80200e34:	02f71863          	bne	a4,a5,80200e64 <printf+0x15e>
            is_long = 1;
    80200e38:	4785                	li	a5,1
    80200e3a:	fcf42a23          	sw	a5,-44(s0)
            c = fmt[++i] & 0xff;
    80200e3e:	fec42783          	lw	a5,-20(s0)
    80200e42:	2785                	addiw	a5,a5,1
    80200e44:	fef42623          	sw	a5,-20(s0)
    80200e48:	fec42783          	lw	a5,-20(s0)
    80200e4c:	f9843703          	ld	a4,-104(s0)
    80200e50:	97ba                	add	a5,a5,a4
    80200e52:	0007c783          	lbu	a5,0(a5)
    80200e56:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    80200e5a:	fe842783          	lw	a5,-24(s0)
    80200e5e:	2781                	sext.w	a5,a5
    80200e60:	3a078563          	beqz	a5,8020120a <printf+0x504>
                break;
        }
        
        switch(c){
    80200e64:	fe842783          	lw	a5,-24(s0)
    80200e68:	0007871b          	sext.w	a4,a5
    80200e6c:	02500793          	li	a5,37
    80200e70:	2ef70d63          	beq	a4,a5,8020116a <printf+0x464>
    80200e74:	fe842783          	lw	a5,-24(s0)
    80200e78:	0007871b          	sext.w	a4,a5
    80200e7c:	02500793          	li	a5,37
    80200e80:	2ef74c63          	blt	a4,a5,80201178 <printf+0x472>
    80200e84:	fe842783          	lw	a5,-24(s0)
    80200e88:	0007871b          	sext.w	a4,a5
    80200e8c:	07800793          	li	a5,120
    80200e90:	2ee7c463          	blt	a5,a4,80201178 <printf+0x472>
    80200e94:	fe842783          	lw	a5,-24(s0)
    80200e98:	0007871b          	sext.w	a4,a5
    80200e9c:	06200793          	li	a5,98
    80200ea0:	2cf74c63          	blt	a4,a5,80201178 <printf+0x472>
    80200ea4:	fe842783          	lw	a5,-24(s0)
    80200ea8:	f9e7869b          	addiw	a3,a5,-98
    80200eac:	0006871b          	sext.w	a4,a3
    80200eb0:	47d9                	li	a5,22
    80200eb2:	2ce7e363          	bltu	a5,a4,80201178 <printf+0x472>
    80200eb6:	02069793          	slli	a5,a3,0x20
    80200eba:	9381                	srli	a5,a5,0x20
    80200ebc:	00279713          	slli	a4,a5,0x2
    80200ec0:	0000d797          	auipc	a5,0xd
    80200ec4:	7e478793          	addi	a5,a5,2020 # 8020e6a4 <user_test_table+0x84>
    80200ec8:	97ba                	add	a5,a5,a4
    80200eca:	439c                	lw	a5,0(a5)
    80200ecc:	0007871b          	sext.w	a4,a5
    80200ed0:	0000d797          	auipc	a5,0xd
    80200ed4:	7d478793          	addi	a5,a5,2004 # 8020e6a4 <user_test_table+0x84>
    80200ed8:	97ba                	add	a5,a5,a4
    80200eda:	8782                	jr	a5
        case 'd':
            if(is_long)
    80200edc:	fd442783          	lw	a5,-44(s0)
    80200ee0:	2781                	sext.w	a5,a5
    80200ee2:	c785                	beqz	a5,80200f0a <printf+0x204>
                printint(va_arg(ap, long long), 10, 1, width, padzero);
    80200ee4:	fb843783          	ld	a5,-72(s0)
    80200ee8:	00878713          	addi	a4,a5,8
    80200eec:	fae43c23          	sd	a4,-72(s0)
    80200ef0:	639c                	ld	a5,0(a5)
    80200ef2:	fdc42703          	lw	a4,-36(s0)
    80200ef6:	fd842683          	lw	a3,-40(s0)
    80200efa:	4605                	li	a2,1
    80200efc:	45a9                	li	a1,10
    80200efe:	853e                	mv	a0,a5
    80200f00:	00000097          	auipc	ra,0x0
    80200f04:	ccc080e7          	jalr	-820(ra) # 80200bcc <printint>
            else
                printint(va_arg(ap, int), 10, 1, width, padzero);
            break;
    80200f08:	ace9                	j	802011e2 <printf+0x4dc>
                printint(va_arg(ap, int), 10, 1, width, padzero);
    80200f0a:	fb843783          	ld	a5,-72(s0)
    80200f0e:	00878713          	addi	a4,a5,8
    80200f12:	fae43c23          	sd	a4,-72(s0)
    80200f16:	439c                	lw	a5,0(a5)
    80200f18:	853e                	mv	a0,a5
    80200f1a:	fdc42703          	lw	a4,-36(s0)
    80200f1e:	fd842783          	lw	a5,-40(s0)
    80200f22:	86be                	mv	a3,a5
    80200f24:	4605                	li	a2,1
    80200f26:	45a9                	li	a1,10
    80200f28:	00000097          	auipc	ra,0x0
    80200f2c:	ca4080e7          	jalr	-860(ra) # 80200bcc <printint>
            break;
    80200f30:	ac4d                	j	802011e2 <printf+0x4dc>
        case 'x':
            if(is_long)
    80200f32:	fd442783          	lw	a5,-44(s0)
    80200f36:	2781                	sext.w	a5,a5
    80200f38:	c785                	beqz	a5,80200f60 <printf+0x25a>
                printint(va_arg(ap, long long), 16, 0, width, padzero);
    80200f3a:	fb843783          	ld	a5,-72(s0)
    80200f3e:	00878713          	addi	a4,a5,8
    80200f42:	fae43c23          	sd	a4,-72(s0)
    80200f46:	639c                	ld	a5,0(a5)
    80200f48:	fdc42703          	lw	a4,-36(s0)
    80200f4c:	fd842683          	lw	a3,-40(s0)
    80200f50:	4601                	li	a2,0
    80200f52:	45c1                	li	a1,16
    80200f54:	853e                	mv	a0,a5
    80200f56:	00000097          	auipc	ra,0x0
    80200f5a:	c76080e7          	jalr	-906(ra) # 80200bcc <printint>
            else
                printint(va_arg(ap, int), 16, 0, width, padzero);
            break;
    80200f5e:	a451                	j	802011e2 <printf+0x4dc>
                printint(va_arg(ap, int), 16, 0, width, padzero);
    80200f60:	fb843783          	ld	a5,-72(s0)
    80200f64:	00878713          	addi	a4,a5,8
    80200f68:	fae43c23          	sd	a4,-72(s0)
    80200f6c:	439c                	lw	a5,0(a5)
    80200f6e:	853e                	mv	a0,a5
    80200f70:	fdc42703          	lw	a4,-36(s0)
    80200f74:	fd842783          	lw	a5,-40(s0)
    80200f78:	86be                	mv	a3,a5
    80200f7a:	4601                	li	a2,0
    80200f7c:	45c1                	li	a1,16
    80200f7e:	00000097          	auipc	ra,0x0
    80200f82:	c4e080e7          	jalr	-946(ra) # 80200bcc <printint>
            break;
    80200f86:	acb1                	j	802011e2 <printf+0x4dc>
        case 'u':
            if(is_long)
    80200f88:	fd442783          	lw	a5,-44(s0)
    80200f8c:	2781                	sext.w	a5,a5
    80200f8e:	c78d                	beqz	a5,80200fb8 <printf+0x2b2>
                printint(va_arg(ap, unsigned long long), 10, 0, width, padzero);
    80200f90:	fb843783          	ld	a5,-72(s0)
    80200f94:	00878713          	addi	a4,a5,8
    80200f98:	fae43c23          	sd	a4,-72(s0)
    80200f9c:	639c                	ld	a5,0(a5)
    80200f9e:	853e                	mv	a0,a5
    80200fa0:	fdc42703          	lw	a4,-36(s0)
    80200fa4:	fd842783          	lw	a5,-40(s0)
    80200fa8:	86be                	mv	a3,a5
    80200faa:	4601                	li	a2,0
    80200fac:	45a9                	li	a1,10
    80200fae:	00000097          	auipc	ra,0x0
    80200fb2:	c1e080e7          	jalr	-994(ra) # 80200bcc <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
            break;
    80200fb6:	a435                	j	802011e2 <printf+0x4dc>
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
    80200fb8:	fb843783          	ld	a5,-72(s0)
    80200fbc:	00878713          	addi	a4,a5,8
    80200fc0:	fae43c23          	sd	a4,-72(s0)
    80200fc4:	439c                	lw	a5,0(a5)
    80200fc6:	1782                	slli	a5,a5,0x20
    80200fc8:	9381                	srli	a5,a5,0x20
    80200fca:	fdc42703          	lw	a4,-36(s0)
    80200fce:	fd842683          	lw	a3,-40(s0)
    80200fd2:	4601                	li	a2,0
    80200fd4:	45a9                	li	a1,10
    80200fd6:	853e                	mv	a0,a5
    80200fd8:	00000097          	auipc	ra,0x0
    80200fdc:	bf4080e7          	jalr	-1036(ra) # 80200bcc <printint>
            break;
    80200fe0:	a409                	j	802011e2 <printf+0x4dc>
        case 'c':
            consputc(va_arg(ap, int));
    80200fe2:	fb843783          	ld	a5,-72(s0)
    80200fe6:	00878713          	addi	a4,a5,8
    80200fea:	fae43c23          	sd	a4,-72(s0)
    80200fee:	439c                	lw	a5,0(a5)
    80200ff0:	853e                	mv	a0,a5
    80200ff2:	00000097          	auipc	ra,0x0
    80200ff6:	b86080e7          	jalr	-1146(ra) # 80200b78 <consputc>
            break;
    80200ffa:	a2e5                	j	802011e2 <printf+0x4dc>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80200ffc:	fb843783          	ld	a5,-72(s0)
    80201000:	00878713          	addi	a4,a5,8
    80201004:	fae43c23          	sd	a4,-72(s0)
    80201008:	639c                	ld	a5,0(a5)
    8020100a:	fef43023          	sd	a5,-32(s0)
    8020100e:	fe043783          	ld	a5,-32(s0)
    80201012:	e799                	bnez	a5,80201020 <printf+0x31a>
                s = "(null)";
    80201014:	0000d797          	auipc	a5,0xd
    80201018:	66c78793          	addi	a5,a5,1644 # 8020e680 <user_test_table+0x60>
    8020101c:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    80201020:	fe043503          	ld	a0,-32(s0)
    80201024:	00000097          	auipc	ra,0x0
    80201028:	b7e080e7          	jalr	-1154(ra) # 80200ba2 <consputs>
            break;
    8020102c:	aa5d                	j	802011e2 <printf+0x4dc>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    8020102e:	fb843783          	ld	a5,-72(s0)
    80201032:	00878713          	addi	a4,a5,8
    80201036:	fae43c23          	sd	a4,-72(s0)
    8020103a:	639c                	ld	a5,0(a5)
    8020103c:	fcf43423          	sd	a5,-56(s0)
            consputs("0x");
    80201040:	0000d517          	auipc	a0,0xd
    80201044:	64850513          	addi	a0,a0,1608 # 8020e688 <user_test_table+0x68>
    80201048:	00000097          	auipc	ra,0x0
    8020104c:	b5a080e7          	jalr	-1190(ra) # 80200ba2 <consputs>
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    80201050:	fc042823          	sw	zero,-48(s0)
    80201054:	a0a1                	j	8020109c <printf+0x396>
                int shift = (15 - i) * 4;
    80201056:	47bd                	li	a5,15
    80201058:	fd042703          	lw	a4,-48(s0)
    8020105c:	9f99                	subw	a5,a5,a4
    8020105e:	2781                	sext.w	a5,a5
    80201060:	0027979b          	slliw	a5,a5,0x2
    80201064:	fcf42223          	sw	a5,-60(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80201068:	fc442783          	lw	a5,-60(s0)
    8020106c:	873e                	mv	a4,a5
    8020106e:	fc843783          	ld	a5,-56(s0)
    80201072:	00e7d7b3          	srl	a5,a5,a4
    80201076:	8bbd                	andi	a5,a5,15
    80201078:	0000d717          	auipc	a4,0xd
    8020107c:	61870713          	addi	a4,a4,1560 # 8020e690 <user_test_table+0x70>
    80201080:	97ba                	add	a5,a5,a4
    80201082:	0007c703          	lbu	a4,0(a5)
    80201086:	fd042783          	lw	a5,-48(s0)
    8020108a:	17c1                	addi	a5,a5,-16
    8020108c:	97a2                	add	a5,a5,s0
    8020108e:	fae78823          	sb	a4,-80(a5)
            for (i = 0; i < 16; i++) {
    80201092:	fd042783          	lw	a5,-48(s0)
    80201096:	2785                	addiw	a5,a5,1
    80201098:	fcf42823          	sw	a5,-48(s0)
    8020109c:	fd042783          	lw	a5,-48(s0)
    802010a0:	0007871b          	sext.w	a4,a5
    802010a4:	47bd                	li	a5,15
    802010a6:	fae7d8e3          	bge	a5,a4,80201056 <printf+0x350>
            }
            buf[16] = '\0';
    802010aa:	fa040823          	sb	zero,-80(s0)
            consputs(buf);
    802010ae:	fa040793          	addi	a5,s0,-96
    802010b2:	853e                	mv	a0,a5
    802010b4:	00000097          	auipc	ra,0x0
    802010b8:	aee080e7          	jalr	-1298(ra) # 80200ba2 <consputs>
            break;
    802010bc:	a21d                	j	802011e2 <printf+0x4dc>
        case 'b':
            if(is_long)
    802010be:	fd442783          	lw	a5,-44(s0)
    802010c2:	2781                	sext.w	a5,a5
    802010c4:	c785                	beqz	a5,802010ec <printf+0x3e6>
                printint(va_arg(ap, long long), 2, 0, width, padzero);
    802010c6:	fb843783          	ld	a5,-72(s0)
    802010ca:	00878713          	addi	a4,a5,8
    802010ce:	fae43c23          	sd	a4,-72(s0)
    802010d2:	639c                	ld	a5,0(a5)
    802010d4:	fdc42703          	lw	a4,-36(s0)
    802010d8:	fd842683          	lw	a3,-40(s0)
    802010dc:	4601                	li	a2,0
    802010de:	4589                	li	a1,2
    802010e0:	853e                	mv	a0,a5
    802010e2:	00000097          	auipc	ra,0x0
    802010e6:	aea080e7          	jalr	-1302(ra) # 80200bcc <printint>
            else
                printint(va_arg(ap, int), 2, 0, width, padzero);
            break;
    802010ea:	a8e5                	j	802011e2 <printf+0x4dc>
                printint(va_arg(ap, int), 2, 0, width, padzero);
    802010ec:	fb843783          	ld	a5,-72(s0)
    802010f0:	00878713          	addi	a4,a5,8
    802010f4:	fae43c23          	sd	a4,-72(s0)
    802010f8:	439c                	lw	a5,0(a5)
    802010fa:	853e                	mv	a0,a5
    802010fc:	fdc42703          	lw	a4,-36(s0)
    80201100:	fd842783          	lw	a5,-40(s0)
    80201104:	86be                	mv	a3,a5
    80201106:	4601                	li	a2,0
    80201108:	4589                	li	a1,2
    8020110a:	00000097          	auipc	ra,0x0
    8020110e:	ac2080e7          	jalr	-1342(ra) # 80200bcc <printint>
            break;
    80201112:	a8c1                	j	802011e2 <printf+0x4dc>
        case 'o':
            if(is_long)
    80201114:	fd442783          	lw	a5,-44(s0)
    80201118:	2781                	sext.w	a5,a5
    8020111a:	c785                	beqz	a5,80201142 <printf+0x43c>
                printint(va_arg(ap, long long), 8, 0, width, padzero);
    8020111c:	fb843783          	ld	a5,-72(s0)
    80201120:	00878713          	addi	a4,a5,8
    80201124:	fae43c23          	sd	a4,-72(s0)
    80201128:	639c                	ld	a5,0(a5)
    8020112a:	fdc42703          	lw	a4,-36(s0)
    8020112e:	fd842683          	lw	a3,-40(s0)
    80201132:	4601                	li	a2,0
    80201134:	45a1                	li	a1,8
    80201136:	853e                	mv	a0,a5
    80201138:	00000097          	auipc	ra,0x0
    8020113c:	a94080e7          	jalr	-1388(ra) # 80200bcc <printint>
            else
                printint(va_arg(ap, int), 8, 0, width, padzero);
            break;
    80201140:	a04d                	j	802011e2 <printf+0x4dc>
                printint(va_arg(ap, int), 8, 0, width, padzero);
    80201142:	fb843783          	ld	a5,-72(s0)
    80201146:	00878713          	addi	a4,a5,8
    8020114a:	fae43c23          	sd	a4,-72(s0)
    8020114e:	439c                	lw	a5,0(a5)
    80201150:	853e                	mv	a0,a5
    80201152:	fdc42703          	lw	a4,-36(s0)
    80201156:	fd842783          	lw	a5,-40(s0)
    8020115a:	86be                	mv	a3,a5
    8020115c:	4601                	li	a2,0
    8020115e:	45a1                	li	a1,8
    80201160:	00000097          	auipc	ra,0x0
    80201164:	a6c080e7          	jalr	-1428(ra) # 80200bcc <printint>
            break;
    80201168:	a8ad                	j	802011e2 <printf+0x4dc>
        case '%':
            buffer_char('%');
    8020116a:	02500513          	li	a0,37
    8020116e:	00000097          	auipc	ra,0x0
    80201172:	978080e7          	jalr	-1672(ra) # 80200ae6 <buffer_char>
            break;
    80201176:	a0b5                	j	802011e2 <printf+0x4dc>
        default:
            buffer_char('%');
    80201178:	02500513          	li	a0,37
    8020117c:	00000097          	auipc	ra,0x0
    80201180:	96a080e7          	jalr	-1686(ra) # 80200ae6 <buffer_char>
            if(padzero) buffer_char('0');
    80201184:	fdc42783          	lw	a5,-36(s0)
    80201188:	2781                	sext.w	a5,a5
    8020118a:	c799                	beqz	a5,80201198 <printf+0x492>
    8020118c:	03000513          	li	a0,48
    80201190:	00000097          	auipc	ra,0x0
    80201194:	956080e7          	jalr	-1706(ra) # 80200ae6 <buffer_char>
            if(width) {
    80201198:	fd842783          	lw	a5,-40(s0)
    8020119c:	2781                	sext.w	a5,a5
    8020119e:	cf91                	beqz	a5,802011ba <printf+0x4b4>
                // 只支持一位宽度，简单处理
                buffer_char('0' + width);
    802011a0:	fd842783          	lw	a5,-40(s0)
    802011a4:	0ff7f793          	zext.b	a5,a5
    802011a8:	0307879b          	addiw	a5,a5,48
    802011ac:	0ff7f793          	zext.b	a5,a5
    802011b0:	853e                	mv	a0,a5
    802011b2:	00000097          	auipc	ra,0x0
    802011b6:	934080e7          	jalr	-1740(ra) # 80200ae6 <buffer_char>
            }
            if(is_long) buffer_char('l');
    802011ba:	fd442783          	lw	a5,-44(s0)
    802011be:	2781                	sext.w	a5,a5
    802011c0:	c799                	beqz	a5,802011ce <printf+0x4c8>
    802011c2:	06c00513          	li	a0,108
    802011c6:	00000097          	auipc	ra,0x0
    802011ca:	920080e7          	jalr	-1760(ra) # 80200ae6 <buffer_char>
            buffer_char(c);
    802011ce:	fe842783          	lw	a5,-24(s0)
    802011d2:	0ff7f793          	zext.b	a5,a5
    802011d6:	853e                	mv	a0,a5
    802011d8:	00000097          	auipc	ra,0x0
    802011dc:	90e080e7          	jalr	-1778(ra) # 80200ae6 <buffer_char>
            break;
    802011e0:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    802011e2:	fec42783          	lw	a5,-20(s0)
    802011e6:	2785                	addiw	a5,a5,1
    802011e8:	fef42623          	sw	a5,-20(s0)
    802011ec:	fec42783          	lw	a5,-20(s0)
    802011f0:	f9843703          	ld	a4,-104(s0)
    802011f4:	97ba                	add	a5,a5,a4
    802011f6:	0007c783          	lbu	a5,0(a5)
    802011fa:	fef42423          	sw	a5,-24(s0)
    802011fe:	fe842783          	lw	a5,-24(s0)
    80201202:	2781                	sext.w	a5,a5
    80201204:	b2079de3          	bnez	a5,80200d3e <printf+0x38>
    80201208:	a011                	j	8020120c <printf+0x506>
                break;
    8020120a:	0001                	nop
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    8020120c:	00000097          	auipc	ra,0x0
    80201210:	886080e7          	jalr	-1914(ra) # 80200a92 <flush_printf_buffer>
    va_end(ap);
}
    80201214:	0001                	nop
    80201216:	70a6                	ld	ra,104(sp)
    80201218:	7406                	ld	s0,96(sp)
    8020121a:	614d                	addi	sp,sp,176
    8020121c:	8082                	ret

000000008020121e <clear_screen>:
// 清屏功能
void clear_screen(void) {
    8020121e:	1141                	addi	sp,sp,-16
    80201220:	e406                	sd	ra,8(sp)
    80201222:	e022                	sd	s0,0(sp)
    80201224:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    80201226:	0000d517          	auipc	a0,0xd
    8020122a:	4da50513          	addi	a0,a0,1242 # 8020e700 <user_test_table+0xe0>
    8020122e:	fffff097          	auipc	ra,0xfffff
    80201232:	46a080e7          	jalr	1130(ra) # 80200698 <uart_puts>
	uart_puts(CURSOR_HOME);
    80201236:	0000d517          	auipc	a0,0xd
    8020123a:	4d250513          	addi	a0,a0,1234 # 8020e708 <user_test_table+0xe8>
    8020123e:	fffff097          	auipc	ra,0xfffff
    80201242:	45a080e7          	jalr	1114(ra) # 80200698 <uart_puts>
}
    80201246:	0001                	nop
    80201248:	60a2                	ld	ra,8(sp)
    8020124a:	6402                	ld	s0,0(sp)
    8020124c:	0141                	addi	sp,sp,16
    8020124e:	8082                	ret

0000000080201250 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    80201250:	1101                	addi	sp,sp,-32
    80201252:	ec06                	sd	ra,24(sp)
    80201254:	e822                	sd	s0,16(sp)
    80201256:	1000                	addi	s0,sp,32
    80201258:	87aa                	mv	a5,a0
    8020125a:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    8020125e:	fec42783          	lw	a5,-20(s0)
    80201262:	2781                	sext.w	a5,a5
    80201264:	02f05f63          	blez	a5,802012a2 <cursor_up+0x52>
    consputc('\033');
    80201268:	456d                	li	a0,27
    8020126a:	00000097          	auipc	ra,0x0
    8020126e:	90e080e7          	jalr	-1778(ra) # 80200b78 <consputc>
    consputc('[');
    80201272:	05b00513          	li	a0,91
    80201276:	00000097          	auipc	ra,0x0
    8020127a:	902080e7          	jalr	-1790(ra) # 80200b78 <consputc>
    printint(lines, 10, 0, 0,0);
    8020127e:	fec42783          	lw	a5,-20(s0)
    80201282:	4701                	li	a4,0
    80201284:	4681                	li	a3,0
    80201286:	4601                	li	a2,0
    80201288:	45a9                	li	a1,10
    8020128a:	853e                	mv	a0,a5
    8020128c:	00000097          	auipc	ra,0x0
    80201290:	940080e7          	jalr	-1728(ra) # 80200bcc <printint>
    consputc('A');
    80201294:	04100513          	li	a0,65
    80201298:	00000097          	auipc	ra,0x0
    8020129c:	8e0080e7          	jalr	-1824(ra) # 80200b78 <consputc>
    802012a0:	a011                	j	802012a4 <cursor_up+0x54>
    if (lines <= 0) return;
    802012a2:	0001                	nop
}
    802012a4:	60e2                	ld	ra,24(sp)
    802012a6:	6442                	ld	s0,16(sp)
    802012a8:	6105                	addi	sp,sp,32
    802012aa:	8082                	ret

00000000802012ac <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    802012ac:	1101                	addi	sp,sp,-32
    802012ae:	ec06                	sd	ra,24(sp)
    802012b0:	e822                	sd	s0,16(sp)
    802012b2:	1000                	addi	s0,sp,32
    802012b4:	87aa                	mv	a5,a0
    802012b6:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    802012ba:	fec42783          	lw	a5,-20(s0)
    802012be:	2781                	sext.w	a5,a5
    802012c0:	02f05f63          	blez	a5,802012fe <cursor_down+0x52>
    consputc('\033');
    802012c4:	456d                	li	a0,27
    802012c6:	00000097          	auipc	ra,0x0
    802012ca:	8b2080e7          	jalr	-1870(ra) # 80200b78 <consputc>
    consputc('[');
    802012ce:	05b00513          	li	a0,91
    802012d2:	00000097          	auipc	ra,0x0
    802012d6:	8a6080e7          	jalr	-1882(ra) # 80200b78 <consputc>
    printint(lines, 10, 0, 0,0);
    802012da:	fec42783          	lw	a5,-20(s0)
    802012de:	4701                	li	a4,0
    802012e0:	4681                	li	a3,0
    802012e2:	4601                	li	a2,0
    802012e4:	45a9                	li	a1,10
    802012e6:	853e                	mv	a0,a5
    802012e8:	00000097          	auipc	ra,0x0
    802012ec:	8e4080e7          	jalr	-1820(ra) # 80200bcc <printint>
    consputc('B');
    802012f0:	04200513          	li	a0,66
    802012f4:	00000097          	auipc	ra,0x0
    802012f8:	884080e7          	jalr	-1916(ra) # 80200b78 <consputc>
    802012fc:	a011                	j	80201300 <cursor_down+0x54>
    if (lines <= 0) return;
    802012fe:	0001                	nop
}
    80201300:	60e2                	ld	ra,24(sp)
    80201302:	6442                	ld	s0,16(sp)
    80201304:	6105                	addi	sp,sp,32
    80201306:	8082                	ret

0000000080201308 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    80201308:	1101                	addi	sp,sp,-32
    8020130a:	ec06                	sd	ra,24(sp)
    8020130c:	e822                	sd	s0,16(sp)
    8020130e:	1000                	addi	s0,sp,32
    80201310:	87aa                	mv	a5,a0
    80201312:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80201316:	fec42783          	lw	a5,-20(s0)
    8020131a:	2781                	sext.w	a5,a5
    8020131c:	02f05f63          	blez	a5,8020135a <cursor_right+0x52>
    consputc('\033');
    80201320:	456d                	li	a0,27
    80201322:	00000097          	auipc	ra,0x0
    80201326:	856080e7          	jalr	-1962(ra) # 80200b78 <consputc>
    consputc('[');
    8020132a:	05b00513          	li	a0,91
    8020132e:	00000097          	auipc	ra,0x0
    80201332:	84a080e7          	jalr	-1974(ra) # 80200b78 <consputc>
    printint(cols, 10, 0,0,0);
    80201336:	fec42783          	lw	a5,-20(s0)
    8020133a:	4701                	li	a4,0
    8020133c:	4681                	li	a3,0
    8020133e:	4601                	li	a2,0
    80201340:	45a9                	li	a1,10
    80201342:	853e                	mv	a0,a5
    80201344:	00000097          	auipc	ra,0x0
    80201348:	888080e7          	jalr	-1912(ra) # 80200bcc <printint>
    consputc('C');
    8020134c:	04300513          	li	a0,67
    80201350:	00000097          	auipc	ra,0x0
    80201354:	828080e7          	jalr	-2008(ra) # 80200b78 <consputc>
    80201358:	a011                	j	8020135c <cursor_right+0x54>
    if (cols <= 0) return;
    8020135a:	0001                	nop
}
    8020135c:	60e2                	ld	ra,24(sp)
    8020135e:	6442                	ld	s0,16(sp)
    80201360:	6105                	addi	sp,sp,32
    80201362:	8082                	ret

0000000080201364 <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    80201364:	1101                	addi	sp,sp,-32
    80201366:	ec06                	sd	ra,24(sp)
    80201368:	e822                	sd	s0,16(sp)
    8020136a:	1000                	addi	s0,sp,32
    8020136c:	87aa                	mv	a5,a0
    8020136e:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    80201372:	fec42783          	lw	a5,-20(s0)
    80201376:	2781                	sext.w	a5,a5
    80201378:	02f05f63          	blez	a5,802013b6 <cursor_left+0x52>
    consputc('\033');
    8020137c:	456d                	li	a0,27
    8020137e:	fffff097          	auipc	ra,0xfffff
    80201382:	7fa080e7          	jalr	2042(ra) # 80200b78 <consputc>
    consputc('[');
    80201386:	05b00513          	li	a0,91
    8020138a:	fffff097          	auipc	ra,0xfffff
    8020138e:	7ee080e7          	jalr	2030(ra) # 80200b78 <consputc>
    printint(cols, 10, 0,0,0);
    80201392:	fec42783          	lw	a5,-20(s0)
    80201396:	4701                	li	a4,0
    80201398:	4681                	li	a3,0
    8020139a:	4601                	li	a2,0
    8020139c:	45a9                	li	a1,10
    8020139e:	853e                	mv	a0,a5
    802013a0:	00000097          	auipc	ra,0x0
    802013a4:	82c080e7          	jalr	-2004(ra) # 80200bcc <printint>
    consputc('D');
    802013a8:	04400513          	li	a0,68
    802013ac:	fffff097          	auipc	ra,0xfffff
    802013b0:	7cc080e7          	jalr	1996(ra) # 80200b78 <consputc>
    802013b4:	a011                	j	802013b8 <cursor_left+0x54>
    if (cols <= 0) return;
    802013b6:	0001                	nop
}
    802013b8:	60e2                	ld	ra,24(sp)
    802013ba:	6442                	ld	s0,16(sp)
    802013bc:	6105                	addi	sp,sp,32
    802013be:	8082                	ret

00000000802013c0 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    802013c0:	1141                	addi	sp,sp,-16
    802013c2:	e406                	sd	ra,8(sp)
    802013c4:	e022                	sd	s0,0(sp)
    802013c6:	0800                	addi	s0,sp,16
    consputc('\033');
    802013c8:	456d                	li	a0,27
    802013ca:	fffff097          	auipc	ra,0xfffff
    802013ce:	7ae080e7          	jalr	1966(ra) # 80200b78 <consputc>
    consputc('[');
    802013d2:	05b00513          	li	a0,91
    802013d6:	fffff097          	auipc	ra,0xfffff
    802013da:	7a2080e7          	jalr	1954(ra) # 80200b78 <consputc>
    consputc('s');
    802013de:	07300513          	li	a0,115
    802013e2:	fffff097          	auipc	ra,0xfffff
    802013e6:	796080e7          	jalr	1942(ra) # 80200b78 <consputc>
}
    802013ea:	0001                	nop
    802013ec:	60a2                	ld	ra,8(sp)
    802013ee:	6402                	ld	s0,0(sp)
    802013f0:	0141                	addi	sp,sp,16
    802013f2:	8082                	ret

00000000802013f4 <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    802013f4:	1141                	addi	sp,sp,-16
    802013f6:	e406                	sd	ra,8(sp)
    802013f8:	e022                	sd	s0,0(sp)
    802013fa:	0800                	addi	s0,sp,16
    consputc('\033');
    802013fc:	456d                	li	a0,27
    802013fe:	fffff097          	auipc	ra,0xfffff
    80201402:	77a080e7          	jalr	1914(ra) # 80200b78 <consputc>
    consputc('[');
    80201406:	05b00513          	li	a0,91
    8020140a:	fffff097          	auipc	ra,0xfffff
    8020140e:	76e080e7          	jalr	1902(ra) # 80200b78 <consputc>
    consputc('u');
    80201412:	07500513          	li	a0,117
    80201416:	fffff097          	auipc	ra,0xfffff
    8020141a:	762080e7          	jalr	1890(ra) # 80200b78 <consputc>
}
    8020141e:	0001                	nop
    80201420:	60a2                	ld	ra,8(sp)
    80201422:	6402                	ld	s0,0(sp)
    80201424:	0141                	addi	sp,sp,16
    80201426:	8082                	ret

0000000080201428 <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    80201428:	1101                	addi	sp,sp,-32
    8020142a:	ec06                	sd	ra,24(sp)
    8020142c:	e822                	sd	s0,16(sp)
    8020142e:	1000                	addi	s0,sp,32
    80201430:	87aa                	mv	a5,a0
    80201432:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    80201436:	fec42783          	lw	a5,-20(s0)
    8020143a:	2781                	sext.w	a5,a5
    8020143c:	00f04563          	bgtz	a5,80201446 <cursor_to_column+0x1e>
    80201440:	4785                	li	a5,1
    80201442:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    80201446:	456d                	li	a0,27
    80201448:	fffff097          	auipc	ra,0xfffff
    8020144c:	730080e7          	jalr	1840(ra) # 80200b78 <consputc>
    consputc('[');
    80201450:	05b00513          	li	a0,91
    80201454:	fffff097          	auipc	ra,0xfffff
    80201458:	724080e7          	jalr	1828(ra) # 80200b78 <consputc>
    printint(col, 10, 0,0,0);
    8020145c:	fec42783          	lw	a5,-20(s0)
    80201460:	4701                	li	a4,0
    80201462:	4681                	li	a3,0
    80201464:	4601                	li	a2,0
    80201466:	45a9                	li	a1,10
    80201468:	853e                	mv	a0,a5
    8020146a:	fffff097          	auipc	ra,0xfffff
    8020146e:	762080e7          	jalr	1890(ra) # 80200bcc <printint>
    consputc('G');
    80201472:	04700513          	li	a0,71
    80201476:	fffff097          	auipc	ra,0xfffff
    8020147a:	702080e7          	jalr	1794(ra) # 80200b78 <consputc>
}
    8020147e:	0001                	nop
    80201480:	60e2                	ld	ra,24(sp)
    80201482:	6442                	ld	s0,16(sp)
    80201484:	6105                	addi	sp,sp,32
    80201486:	8082                	ret

0000000080201488 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    80201488:	1101                	addi	sp,sp,-32
    8020148a:	ec06                	sd	ra,24(sp)
    8020148c:	e822                	sd	s0,16(sp)
    8020148e:	1000                	addi	s0,sp,32
    80201490:	87aa                	mv	a5,a0
    80201492:	872e                	mv	a4,a1
    80201494:	fef42623          	sw	a5,-20(s0)
    80201498:	87ba                	mv	a5,a4
    8020149a:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    8020149e:	456d                	li	a0,27
    802014a0:	fffff097          	auipc	ra,0xfffff
    802014a4:	6d8080e7          	jalr	1752(ra) # 80200b78 <consputc>
    consputc('[');
    802014a8:	05b00513          	li	a0,91
    802014ac:	fffff097          	auipc	ra,0xfffff
    802014b0:	6cc080e7          	jalr	1740(ra) # 80200b78 <consputc>
    printint(row, 10, 0,0,0);
    802014b4:	fec42783          	lw	a5,-20(s0)
    802014b8:	4701                	li	a4,0
    802014ba:	4681                	li	a3,0
    802014bc:	4601                	li	a2,0
    802014be:	45a9                	li	a1,10
    802014c0:	853e                	mv	a0,a5
    802014c2:	fffff097          	auipc	ra,0xfffff
    802014c6:	70a080e7          	jalr	1802(ra) # 80200bcc <printint>
    consputc(';');
    802014ca:	03b00513          	li	a0,59
    802014ce:	fffff097          	auipc	ra,0xfffff
    802014d2:	6aa080e7          	jalr	1706(ra) # 80200b78 <consputc>
    printint(col, 10, 0,0,0);
    802014d6:	fe842783          	lw	a5,-24(s0)
    802014da:	4701                	li	a4,0
    802014dc:	4681                	li	a3,0
    802014de:	4601                	li	a2,0
    802014e0:	45a9                	li	a1,10
    802014e2:	853e                	mv	a0,a5
    802014e4:	fffff097          	auipc	ra,0xfffff
    802014e8:	6e8080e7          	jalr	1768(ra) # 80200bcc <printint>
    consputc('H');
    802014ec:	04800513          	li	a0,72
    802014f0:	fffff097          	auipc	ra,0xfffff
    802014f4:	688080e7          	jalr	1672(ra) # 80200b78 <consputc>
}
    802014f8:	0001                	nop
    802014fa:	60e2                	ld	ra,24(sp)
    802014fc:	6442                	ld	s0,16(sp)
    802014fe:	6105                	addi	sp,sp,32
    80201500:	8082                	ret

0000000080201502 <reset_color>:
// 颜色控制
void reset_color(void) {
    80201502:	1141                	addi	sp,sp,-16
    80201504:	e406                	sd	ra,8(sp)
    80201506:	e022                	sd	s0,0(sp)
    80201508:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    8020150a:	0000d517          	auipc	a0,0xd
    8020150e:	20650513          	addi	a0,a0,518 # 8020e710 <user_test_table+0xf0>
    80201512:	fffff097          	auipc	ra,0xfffff
    80201516:	186080e7          	jalr	390(ra) # 80200698 <uart_puts>
}
    8020151a:	0001                	nop
    8020151c:	60a2                	ld	ra,8(sp)
    8020151e:	6402                	ld	s0,0(sp)
    80201520:	0141                	addi	sp,sp,16
    80201522:	8082                	ret

0000000080201524 <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    80201524:	1101                	addi	sp,sp,-32
    80201526:	ec06                	sd	ra,24(sp)
    80201528:	e822                	sd	s0,16(sp)
    8020152a:	1000                	addi	s0,sp,32
    8020152c:	87aa                	mv	a5,a0
    8020152e:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    80201532:	fec42783          	lw	a5,-20(s0)
    80201536:	0007871b          	sext.w	a4,a5
    8020153a:	47f5                	li	a5,29
    8020153c:	04e7d763          	bge	a5,a4,8020158a <set_fg_color+0x66>
    80201540:	fec42783          	lw	a5,-20(s0)
    80201544:	0007871b          	sext.w	a4,a5
    80201548:	02500793          	li	a5,37
    8020154c:	02e7cf63          	blt	a5,a4,8020158a <set_fg_color+0x66>
	consputc('\033');
    80201550:	456d                	li	a0,27
    80201552:	fffff097          	auipc	ra,0xfffff
    80201556:	626080e7          	jalr	1574(ra) # 80200b78 <consputc>
	consputc('[');
    8020155a:	05b00513          	li	a0,91
    8020155e:	fffff097          	auipc	ra,0xfffff
    80201562:	61a080e7          	jalr	1562(ra) # 80200b78 <consputc>
	printint(color, 10, 0,0,0);
    80201566:	fec42783          	lw	a5,-20(s0)
    8020156a:	4701                	li	a4,0
    8020156c:	4681                	li	a3,0
    8020156e:	4601                	li	a2,0
    80201570:	45a9                	li	a1,10
    80201572:	853e                	mv	a0,a5
    80201574:	fffff097          	auipc	ra,0xfffff
    80201578:	658080e7          	jalr	1624(ra) # 80200bcc <printint>
	consputc('m');
    8020157c:	06d00513          	li	a0,109
    80201580:	fffff097          	auipc	ra,0xfffff
    80201584:	5f8080e7          	jalr	1528(ra) # 80200b78 <consputc>
    80201588:	a011                	j	8020158c <set_fg_color+0x68>
	if (color < 30 || color > 37) return; // 支持30-37
    8020158a:	0001                	nop
}
    8020158c:	60e2                	ld	ra,24(sp)
    8020158e:	6442                	ld	s0,16(sp)
    80201590:	6105                	addi	sp,sp,32
    80201592:	8082                	ret

0000000080201594 <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    80201594:	1101                	addi	sp,sp,-32
    80201596:	ec06                	sd	ra,24(sp)
    80201598:	e822                	sd	s0,16(sp)
    8020159a:	1000                	addi	s0,sp,32
    8020159c:	87aa                	mv	a5,a0
    8020159e:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    802015a2:	fec42783          	lw	a5,-20(s0)
    802015a6:	0007871b          	sext.w	a4,a5
    802015aa:	02700793          	li	a5,39
    802015ae:	04e7d763          	bge	a5,a4,802015fc <set_bg_color+0x68>
    802015b2:	fec42783          	lw	a5,-20(s0)
    802015b6:	0007871b          	sext.w	a4,a5
    802015ba:	02f00793          	li	a5,47
    802015be:	02e7cf63          	blt	a5,a4,802015fc <set_bg_color+0x68>
	consputc('\033');
    802015c2:	456d                	li	a0,27
    802015c4:	fffff097          	auipc	ra,0xfffff
    802015c8:	5b4080e7          	jalr	1460(ra) # 80200b78 <consputc>
	consputc('[');
    802015cc:	05b00513          	li	a0,91
    802015d0:	fffff097          	auipc	ra,0xfffff
    802015d4:	5a8080e7          	jalr	1448(ra) # 80200b78 <consputc>
	printint(color, 10, 0,0,0);
    802015d8:	fec42783          	lw	a5,-20(s0)
    802015dc:	4701                	li	a4,0
    802015de:	4681                	li	a3,0
    802015e0:	4601                	li	a2,0
    802015e2:	45a9                	li	a1,10
    802015e4:	853e                	mv	a0,a5
    802015e6:	fffff097          	auipc	ra,0xfffff
    802015ea:	5e6080e7          	jalr	1510(ra) # 80200bcc <printint>
	consputc('m');
    802015ee:	06d00513          	li	a0,109
    802015f2:	fffff097          	auipc	ra,0xfffff
    802015f6:	586080e7          	jalr	1414(ra) # 80200b78 <consputc>
    802015fa:	a011                	j	802015fe <set_bg_color+0x6a>
	if (color < 40 || color > 47) return; // 支持40-47
    802015fc:	0001                	nop
}
    802015fe:	60e2                	ld	ra,24(sp)
    80201600:	6442                	ld	s0,16(sp)
    80201602:	6105                	addi	sp,sp,32
    80201604:	8082                	ret

0000000080201606 <color_red>:
// 简易文字颜色
void color_red(void) {
    80201606:	1141                	addi	sp,sp,-16
    80201608:	e406                	sd	ra,8(sp)
    8020160a:	e022                	sd	s0,0(sp)
    8020160c:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    8020160e:	457d                	li	a0,31
    80201610:	00000097          	auipc	ra,0x0
    80201614:	f14080e7          	jalr	-236(ra) # 80201524 <set_fg_color>
}
    80201618:	0001                	nop
    8020161a:	60a2                	ld	ra,8(sp)
    8020161c:	6402                	ld	s0,0(sp)
    8020161e:	0141                	addi	sp,sp,16
    80201620:	8082                	ret

0000000080201622 <color_green>:
void color_green(void) {
    80201622:	1141                	addi	sp,sp,-16
    80201624:	e406                	sd	ra,8(sp)
    80201626:	e022                	sd	s0,0(sp)
    80201628:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    8020162a:	02000513          	li	a0,32
    8020162e:	00000097          	auipc	ra,0x0
    80201632:	ef6080e7          	jalr	-266(ra) # 80201524 <set_fg_color>
}
    80201636:	0001                	nop
    80201638:	60a2                	ld	ra,8(sp)
    8020163a:	6402                	ld	s0,0(sp)
    8020163c:	0141                	addi	sp,sp,16
    8020163e:	8082                	ret

0000000080201640 <color_yellow>:
void color_yellow(void) {
    80201640:	1141                	addi	sp,sp,-16
    80201642:	e406                	sd	ra,8(sp)
    80201644:	e022                	sd	s0,0(sp)
    80201646:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    80201648:	02100513          	li	a0,33
    8020164c:	00000097          	auipc	ra,0x0
    80201650:	ed8080e7          	jalr	-296(ra) # 80201524 <set_fg_color>
}
    80201654:	0001                	nop
    80201656:	60a2                	ld	ra,8(sp)
    80201658:	6402                	ld	s0,0(sp)
    8020165a:	0141                	addi	sp,sp,16
    8020165c:	8082                	ret

000000008020165e <color_blue>:
void color_blue(void) {
    8020165e:	1141                	addi	sp,sp,-16
    80201660:	e406                	sd	ra,8(sp)
    80201662:	e022                	sd	s0,0(sp)
    80201664:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    80201666:	02200513          	li	a0,34
    8020166a:	00000097          	auipc	ra,0x0
    8020166e:	eba080e7          	jalr	-326(ra) # 80201524 <set_fg_color>
}
    80201672:	0001                	nop
    80201674:	60a2                	ld	ra,8(sp)
    80201676:	6402                	ld	s0,0(sp)
    80201678:	0141                	addi	sp,sp,16
    8020167a:	8082                	ret

000000008020167c <color_purple>:
void color_purple(void) {
    8020167c:	1141                	addi	sp,sp,-16
    8020167e:	e406                	sd	ra,8(sp)
    80201680:	e022                	sd	s0,0(sp)
    80201682:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    80201684:	02300513          	li	a0,35
    80201688:	00000097          	auipc	ra,0x0
    8020168c:	e9c080e7          	jalr	-356(ra) # 80201524 <set_fg_color>
}
    80201690:	0001                	nop
    80201692:	60a2                	ld	ra,8(sp)
    80201694:	6402                	ld	s0,0(sp)
    80201696:	0141                	addi	sp,sp,16
    80201698:	8082                	ret

000000008020169a <color_cyan>:
void color_cyan(void) {
    8020169a:	1141                	addi	sp,sp,-16
    8020169c:	e406                	sd	ra,8(sp)
    8020169e:	e022                	sd	s0,0(sp)
    802016a0:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    802016a2:	02400513          	li	a0,36
    802016a6:	00000097          	auipc	ra,0x0
    802016aa:	e7e080e7          	jalr	-386(ra) # 80201524 <set_fg_color>
}
    802016ae:	0001                	nop
    802016b0:	60a2                	ld	ra,8(sp)
    802016b2:	6402                	ld	s0,0(sp)
    802016b4:	0141                	addi	sp,sp,16
    802016b6:	8082                	ret

00000000802016b8 <color_reverse>:
void color_reverse(void){
    802016b8:	1141                	addi	sp,sp,-16
    802016ba:	e406                	sd	ra,8(sp)
    802016bc:	e022                	sd	s0,0(sp)
    802016be:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    802016c0:	02500513          	li	a0,37
    802016c4:	00000097          	auipc	ra,0x0
    802016c8:	e60080e7          	jalr	-416(ra) # 80201524 <set_fg_color>
}
    802016cc:	0001                	nop
    802016ce:	60a2                	ld	ra,8(sp)
    802016d0:	6402                	ld	s0,0(sp)
    802016d2:	0141                	addi	sp,sp,16
    802016d4:	8082                	ret

00000000802016d6 <set_color>:
void set_color(int fg, int bg) {
    802016d6:	1101                	addi	sp,sp,-32
    802016d8:	ec06                	sd	ra,24(sp)
    802016da:	e822                	sd	s0,16(sp)
    802016dc:	1000                	addi	s0,sp,32
    802016de:	87aa                	mv	a5,a0
    802016e0:	872e                	mv	a4,a1
    802016e2:	fef42623          	sw	a5,-20(s0)
    802016e6:	87ba                	mv	a5,a4
    802016e8:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    802016ec:	fe842783          	lw	a5,-24(s0)
    802016f0:	853e                	mv	a0,a5
    802016f2:	00000097          	auipc	ra,0x0
    802016f6:	ea2080e7          	jalr	-350(ra) # 80201594 <set_bg_color>
	set_fg_color(fg);
    802016fa:	fec42783          	lw	a5,-20(s0)
    802016fe:	853e                	mv	a0,a5
    80201700:	00000097          	auipc	ra,0x0
    80201704:	e24080e7          	jalr	-476(ra) # 80201524 <set_fg_color>
}
    80201708:	0001                	nop
    8020170a:	60e2                	ld	ra,24(sp)
    8020170c:	6442                	ld	s0,16(sp)
    8020170e:	6105                	addi	sp,sp,32
    80201710:	8082                	ret

0000000080201712 <clear_line>:
void clear_line(){
    80201712:	1141                	addi	sp,sp,-16
    80201714:	e406                	sd	ra,8(sp)
    80201716:	e022                	sd	s0,0(sp)
    80201718:	0800                	addi	s0,sp,16
	consputc('\033');
    8020171a:	456d                	li	a0,27
    8020171c:	fffff097          	auipc	ra,0xfffff
    80201720:	45c080e7          	jalr	1116(ra) # 80200b78 <consputc>
	consputc('[');
    80201724:	05b00513          	li	a0,91
    80201728:	fffff097          	auipc	ra,0xfffff
    8020172c:	450080e7          	jalr	1104(ra) # 80200b78 <consputc>
	consputc('2');
    80201730:	03200513          	li	a0,50
    80201734:	fffff097          	auipc	ra,0xfffff
    80201738:	444080e7          	jalr	1092(ra) # 80200b78 <consputc>
	consputc('K');
    8020173c:	04b00513          	li	a0,75
    80201740:	fffff097          	auipc	ra,0xfffff
    80201744:	438080e7          	jalr	1080(ra) # 80200b78 <consputc>
}
    80201748:	0001                	nop
    8020174a:	60a2                	ld	ra,8(sp)
    8020174c:	6402                	ld	s0,0(sp)
    8020174e:	0141                	addi	sp,sp,16
    80201750:	8082                	ret

0000000080201752 <panic>:

void panic(const char *msg) {
    80201752:	1101                	addi	sp,sp,-32
    80201754:	ec06                	sd	ra,24(sp)
    80201756:	e822                	sd	s0,16(sp)
    80201758:	1000                	addi	s0,sp,32
    8020175a:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    8020175e:	00000097          	auipc	ra,0x0
    80201762:	ea8080e7          	jalr	-344(ra) # 80201606 <color_red>
	printf("panic: %s\n", msg);
    80201766:	fe843583          	ld	a1,-24(s0)
    8020176a:	0000d517          	auipc	a0,0xd
    8020176e:	fae50513          	addi	a0,a0,-82 # 8020e718 <user_test_table+0xf8>
    80201772:	fffff097          	auipc	ra,0xfffff
    80201776:	594080e7          	jalr	1428(ra) # 80200d06 <printf>
	reset_color();
    8020177a:	00000097          	auipc	ra,0x0
    8020177e:	d88080e7          	jalr	-632(ra) # 80201502 <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    80201782:	0001                	nop
    80201784:	bffd                	j	80201782 <panic+0x30>

0000000080201786 <warning>:
}
void warning(const char *fmt, ...) {
    80201786:	7159                	addi	sp,sp,-112
    80201788:	f406                	sd	ra,40(sp)
    8020178a:	f022                	sd	s0,32(sp)
    8020178c:	1800                	addi	s0,sp,48
    8020178e:	fca43c23          	sd	a0,-40(s0)
    80201792:	e40c                	sd	a1,8(s0)
    80201794:	e810                	sd	a2,16(s0)
    80201796:	ec14                	sd	a3,24(s0)
    80201798:	f018                	sd	a4,32(s0)
    8020179a:	f41c                	sd	a5,40(s0)
    8020179c:	03043823          	sd	a6,48(s0)
    802017a0:	03143c23          	sd	a7,56(s0)
    va_list ap;
    color_purple(); // 设置紫色
    802017a4:	00000097          	auipc	ra,0x0
    802017a8:	ed8080e7          	jalr	-296(ra) # 8020167c <color_purple>
    printf("[WARNING] ");
    802017ac:	0000d517          	auipc	a0,0xd
    802017b0:	f7c50513          	addi	a0,a0,-132 # 8020e728 <user_test_table+0x108>
    802017b4:	fffff097          	auipc	ra,0xfffff
    802017b8:	552080e7          	jalr	1362(ra) # 80200d06 <printf>
    va_start(ap, fmt);
    802017bc:	04040793          	addi	a5,s0,64
    802017c0:	fcf43823          	sd	a5,-48(s0)
    802017c4:	fd043783          	ld	a5,-48(s0)
    802017c8:	fc878793          	addi	a5,a5,-56
    802017cc:	fef43423          	sd	a5,-24(s0)
    printf(fmt, ap);
    802017d0:	fe843783          	ld	a5,-24(s0)
    802017d4:	85be                	mv	a1,a5
    802017d6:	fd843503          	ld	a0,-40(s0)
    802017da:	fffff097          	auipc	ra,0xfffff
    802017de:	52c080e7          	jalr	1324(ra) # 80200d06 <printf>
    va_end(ap);
    reset_color(); // 恢复默认颜色
    802017e2:	00000097          	auipc	ra,0x0
    802017e6:	d20080e7          	jalr	-736(ra) # 80201502 <reset_color>
}
    802017ea:	0001                	nop
    802017ec:	70a2                	ld	ra,40(sp)
    802017ee:	7402                	ld	s0,32(sp)
    802017f0:	6165                	addi	sp,sp,112
    802017f2:	8082                	ret

00000000802017f4 <test_printf_precision>:
void test_printf_precision(void) {
    802017f4:	1101                	addi	sp,sp,-32
    802017f6:	ec06                	sd	ra,24(sp)
    802017f8:	e822                	sd	s0,16(sp)
    802017fa:	1000                	addi	s0,sp,32
	clear_screen();
    802017fc:	00000097          	auipc	ra,0x0
    80201800:	a22080e7          	jalr	-1502(ra) # 8020121e <clear_screen>
    printf("=== 详细的printf测试 ===\n");
    80201804:	0000d517          	auipc	a0,0xd
    80201808:	f3450513          	addi	a0,a0,-204 # 8020e738 <user_test_table+0x118>
    8020180c:	fffff097          	auipc	ra,0xfffff
    80201810:	4fa080e7          	jalr	1274(ra) # 80200d06 <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    80201814:	0000d517          	auipc	a0,0xd
    80201818:	f4450513          	addi	a0,a0,-188 # 8020e758 <user_test_table+0x138>
    8020181c:	fffff097          	auipc	ra,0xfffff
    80201820:	4ea080e7          	jalr	1258(ra) # 80200d06 <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    80201824:	0ff00593          	li	a1,255
    80201828:	0000d517          	auipc	a0,0xd
    8020182c:	f4850513          	addi	a0,a0,-184 # 8020e770 <user_test_table+0x150>
    80201830:	fffff097          	auipc	ra,0xfffff
    80201834:	4d6080e7          	jalr	1238(ra) # 80200d06 <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    80201838:	6585                	lui	a1,0x1
    8020183a:	0000d517          	auipc	a0,0xd
    8020183e:	f5650513          	addi	a0,a0,-170 # 8020e790 <user_test_table+0x170>
    80201842:	fffff097          	auipc	ra,0xfffff
    80201846:	4c4080e7          	jalr	1220(ra) # 80200d06 <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    8020184a:	1234b7b7          	lui	a5,0x1234b
    8020184e:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    80201852:	0000d517          	auipc	a0,0xd
    80201856:	f5e50513          	addi	a0,a0,-162 # 8020e7b0 <user_test_table+0x190>
    8020185a:	fffff097          	auipc	ra,0xfffff
    8020185e:	4ac080e7          	jalr	1196(ra) # 80200d06 <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    80201862:	0000d517          	auipc	a0,0xd
    80201866:	f6650513          	addi	a0,a0,-154 # 8020e7c8 <user_test_table+0x1a8>
    8020186a:	fffff097          	auipc	ra,0xfffff
    8020186e:	49c080e7          	jalr	1180(ra) # 80200d06 <printf>
    printf("  正数: %d\n", 42);
    80201872:	02a00593          	li	a1,42
    80201876:	0000d517          	auipc	a0,0xd
    8020187a:	f6a50513          	addi	a0,a0,-150 # 8020e7e0 <user_test_table+0x1c0>
    8020187e:	fffff097          	auipc	ra,0xfffff
    80201882:	488080e7          	jalr	1160(ra) # 80200d06 <printf>
    printf("  负数: %d\n", -42);
    80201886:	fd600593          	li	a1,-42
    8020188a:	0000d517          	auipc	a0,0xd
    8020188e:	f6650513          	addi	a0,a0,-154 # 8020e7f0 <user_test_table+0x1d0>
    80201892:	fffff097          	auipc	ra,0xfffff
    80201896:	474080e7          	jalr	1140(ra) # 80200d06 <printf>
    printf("  零: %d\n", 0);
    8020189a:	4581                	li	a1,0
    8020189c:	0000d517          	auipc	a0,0xd
    802018a0:	f6450513          	addi	a0,a0,-156 # 8020e800 <user_test_table+0x1e0>
    802018a4:	fffff097          	auipc	ra,0xfffff
    802018a8:	462080e7          	jalr	1122(ra) # 80200d06 <printf>
    printf("  大数: %d\n", 123456789);
    802018ac:	075bd7b7          	lui	a5,0x75bd
    802018b0:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    802018b4:	0000d517          	auipc	a0,0xd
    802018b8:	f5c50513          	addi	a0,a0,-164 # 8020e810 <user_test_table+0x1f0>
    802018bc:	fffff097          	auipc	ra,0xfffff
    802018c0:	44a080e7          	jalr	1098(ra) # 80200d06 <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    802018c4:	0000d517          	auipc	a0,0xd
    802018c8:	f5c50513          	addi	a0,a0,-164 # 8020e820 <user_test_table+0x200>
    802018cc:	fffff097          	auipc	ra,0xfffff
    802018d0:	43a080e7          	jalr	1082(ra) # 80200d06 <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    802018d4:	55fd                	li	a1,-1
    802018d6:	0000d517          	auipc	a0,0xd
    802018da:	f6250513          	addi	a0,a0,-158 # 8020e838 <user_test_table+0x218>
    802018de:	fffff097          	auipc	ra,0xfffff
    802018e2:	428080e7          	jalr	1064(ra) # 80200d06 <printf>
    printf("  零：%u\n", 0U);
    802018e6:	4581                	li	a1,0
    802018e8:	0000d517          	auipc	a0,0xd
    802018ec:	f6850513          	addi	a0,a0,-152 # 8020e850 <user_test_table+0x230>
    802018f0:	fffff097          	auipc	ra,0xfffff
    802018f4:	416080e7          	jalr	1046(ra) # 80200d06 <printf>
	printf("  小无符号数：%u\n", 12345U);
    802018f8:	678d                	lui	a5,0x3
    802018fa:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    802018fe:	0000d517          	auipc	a0,0xd
    80201902:	f6250513          	addi	a0,a0,-158 # 8020e860 <user_test_table+0x240>
    80201906:	fffff097          	auipc	ra,0xfffff
    8020190a:	400080e7          	jalr	1024(ra) # 80200d06 <printf>

	// 测试边界
	printf("边界测试:\n");
    8020190e:	0000d517          	auipc	a0,0xd
    80201912:	f6a50513          	addi	a0,a0,-150 # 8020e878 <user_test_table+0x258>
    80201916:	fffff097          	auipc	ra,0xfffff
    8020191a:	3f0080e7          	jalr	1008(ra) # 80200d06 <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    8020191e:	800007b7          	lui	a5,0x80000
    80201922:	fff7c593          	not	a1,a5
    80201926:	0000d517          	auipc	a0,0xd
    8020192a:	f6250513          	addi	a0,a0,-158 # 8020e888 <user_test_table+0x268>
    8020192e:	fffff097          	auipc	ra,0xfffff
    80201932:	3d8080e7          	jalr	984(ra) # 80200d06 <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    80201936:	800005b7          	lui	a1,0x80000
    8020193a:	0000d517          	auipc	a0,0xd
    8020193e:	f5e50513          	addi	a0,a0,-162 # 8020e898 <user_test_table+0x278>
    80201942:	fffff097          	auipc	ra,0xfffff
    80201946:	3c4080e7          	jalr	964(ra) # 80200d06 <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    8020194a:	55fd                	li	a1,-1
    8020194c:	0000d517          	auipc	a0,0xd
    80201950:	f5c50513          	addi	a0,a0,-164 # 8020e8a8 <user_test_table+0x288>
    80201954:	fffff097          	auipc	ra,0xfffff
    80201958:	3b2080e7          	jalr	946(ra) # 80200d06 <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    8020195c:	55fd                	li	a1,-1
    8020195e:	0000d517          	auipc	a0,0xd
    80201962:	f5a50513          	addi	a0,a0,-166 # 8020e8b8 <user_test_table+0x298>
    80201966:	fffff097          	auipc	ra,0xfffff
    8020196a:	3a0080e7          	jalr	928(ra) # 80200d06 <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    8020196e:	0000d517          	auipc	a0,0xd
    80201972:	f6250513          	addi	a0,a0,-158 # 8020e8d0 <user_test_table+0x2b0>
    80201976:	fffff097          	auipc	ra,0xfffff
    8020197a:	390080e7          	jalr	912(ra) # 80200d06 <printf>
    printf("  空字符串: '%s'\n", "");
    8020197e:	0000d597          	auipc	a1,0xd
    80201982:	f6a58593          	addi	a1,a1,-150 # 8020e8e8 <user_test_table+0x2c8>
    80201986:	0000d517          	auipc	a0,0xd
    8020198a:	f6a50513          	addi	a0,a0,-150 # 8020e8f0 <user_test_table+0x2d0>
    8020198e:	fffff097          	auipc	ra,0xfffff
    80201992:	378080e7          	jalr	888(ra) # 80200d06 <printf>
    printf("  单字符: '%s'\n", "X");
    80201996:	0000d597          	auipc	a1,0xd
    8020199a:	f7258593          	addi	a1,a1,-142 # 8020e908 <user_test_table+0x2e8>
    8020199e:	0000d517          	auipc	a0,0xd
    802019a2:	f7250513          	addi	a0,a0,-142 # 8020e910 <user_test_table+0x2f0>
    802019a6:	fffff097          	auipc	ra,0xfffff
    802019aa:	360080e7          	jalr	864(ra) # 80200d06 <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    802019ae:	0000d597          	auipc	a1,0xd
    802019b2:	f7a58593          	addi	a1,a1,-134 # 8020e928 <user_test_table+0x308>
    802019b6:	0000d517          	auipc	a0,0xd
    802019ba:	f9250513          	addi	a0,a0,-110 # 8020e948 <user_test_table+0x328>
    802019be:	fffff097          	auipc	ra,0xfffff
    802019c2:	348080e7          	jalr	840(ra) # 80200d06 <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    802019c6:	0000d597          	auipc	a1,0xd
    802019ca:	f9a58593          	addi	a1,a1,-102 # 8020e960 <user_test_table+0x340>
    802019ce:	0000d517          	auipc	a0,0xd
    802019d2:	0e250513          	addi	a0,a0,226 # 8020eab0 <user_test_table+0x490>
    802019d6:	fffff097          	auipc	ra,0xfffff
    802019da:	330080e7          	jalr	816(ra) # 80200d06 <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    802019de:	0000d517          	auipc	a0,0xd
    802019e2:	0f250513          	addi	a0,a0,242 # 8020ead0 <user_test_table+0x4b0>
    802019e6:	fffff097          	auipc	ra,0xfffff
    802019ea:	320080e7          	jalr	800(ra) # 80200d06 <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    802019ee:	0ff00693          	li	a3,255
    802019f2:	f0100613          	li	a2,-255
    802019f6:	0ff00593          	li	a1,255
    802019fa:	0000d517          	auipc	a0,0xd
    802019fe:	0ee50513          	addi	a0,a0,238 # 8020eae8 <user_test_table+0x4c8>
    80201a02:	fffff097          	auipc	ra,0xfffff
    80201a06:	304080e7          	jalr	772(ra) # 80200d06 <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80201a0a:	0000d517          	auipc	a0,0xd
    80201a0e:	10650513          	addi	a0,a0,262 # 8020eb10 <user_test_table+0x4f0>
    80201a12:	fffff097          	auipc	ra,0xfffff
    80201a16:	2f4080e7          	jalr	756(ra) # 80200d06 <printf>
	printf("  100%% 完成!\n");
    80201a1a:	0000d517          	auipc	a0,0xd
    80201a1e:	10e50513          	addi	a0,a0,270 # 8020eb28 <user_test_table+0x508>
    80201a22:	fffff097          	auipc	ra,0xfffff
    80201a26:	2e4080e7          	jalr	740(ra) # 80200d06 <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    80201a2a:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    80201a2e:	0000d517          	auipc	a0,0xd
    80201a32:	11250513          	addi	a0,a0,274 # 8020eb40 <user_test_table+0x520>
    80201a36:	fffff097          	auipc	ra,0xfffff
    80201a3a:	2d0080e7          	jalr	720(ra) # 80200d06 <printf>
	printf("  NULL as string: '%s'\n", null_str);
    80201a3e:	fe843583          	ld	a1,-24(s0)
    80201a42:	0000d517          	auipc	a0,0xd
    80201a46:	11650513          	addi	a0,a0,278 # 8020eb58 <user_test_table+0x538>
    80201a4a:	fffff097          	auipc	ra,0xfffff
    80201a4e:	2bc080e7          	jalr	700(ra) # 80200d06 <printf>
	
	// 测试指针格式
	int var = 42;
    80201a52:	02a00793          	li	a5,42
    80201a56:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    80201a5a:	0000d517          	auipc	a0,0xd
    80201a5e:	11650513          	addi	a0,a0,278 # 8020eb70 <user_test_table+0x550>
    80201a62:	fffff097          	auipc	ra,0xfffff
    80201a66:	2a4080e7          	jalr	676(ra) # 80200d06 <printf>
	printf("  Address of var: %p\n", &var);
    80201a6a:	fe440793          	addi	a5,s0,-28
    80201a6e:	85be                	mv	a1,a5
    80201a70:	0000d517          	auipc	a0,0xd
    80201a74:	11050513          	addi	a0,a0,272 # 8020eb80 <user_test_table+0x560>
    80201a78:	fffff097          	auipc	ra,0xfffff
    80201a7c:	28e080e7          	jalr	654(ra) # 80200d06 <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80201a80:	0000d517          	auipc	a0,0xd
    80201a84:	11850513          	addi	a0,a0,280 # 8020eb98 <user_test_table+0x578>
    80201a88:	fffff097          	auipc	ra,0xfffff
    80201a8c:	27e080e7          	jalr	638(ra) # 80200d06 <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201a90:	55fd                	li	a1,-1
    80201a92:	0000d517          	auipc	a0,0xd
    80201a96:	12650513          	addi	a0,a0,294 # 8020ebb8 <user_test_table+0x598>
    80201a9a:	fffff097          	auipc	ra,0xfffff
    80201a9e:	26c080e7          	jalr	620(ra) # 80200d06 <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201aa2:	0000d517          	auipc	a0,0xd
    80201aa6:	12e50513          	addi	a0,a0,302 # 8020ebd0 <user_test_table+0x5b0>
    80201aaa:	fffff097          	auipc	ra,0xfffff
    80201aae:	25c080e7          	jalr	604(ra) # 80200d06 <printf>
	printf("  Binary of 5: %b\n", 5);
    80201ab2:	4595                	li	a1,5
    80201ab4:	0000d517          	auipc	a0,0xd
    80201ab8:	13450513          	addi	a0,a0,308 # 8020ebe8 <user_test_table+0x5c8>
    80201abc:	fffff097          	auipc	ra,0xfffff
    80201ac0:	24a080e7          	jalr	586(ra) # 80200d06 <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201ac4:	45a1                	li	a1,8
    80201ac6:	0000d517          	auipc	a0,0xd
    80201aca:	13a50513          	addi	a0,a0,314 # 8020ec00 <user_test_table+0x5e0>
    80201ace:	fffff097          	auipc	ra,0xfffff
    80201ad2:	238080e7          	jalr	568(ra) # 80200d06 <printf>
	printf("=== printf测试结束 ===\n");
    80201ad6:	0000d517          	auipc	a0,0xd
    80201ada:	14250513          	addi	a0,a0,322 # 8020ec18 <user_test_table+0x5f8>
    80201ade:	fffff097          	auipc	ra,0xfffff
    80201ae2:	228080e7          	jalr	552(ra) # 80200d06 <printf>
}
    80201ae6:	0001                	nop
    80201ae8:	60e2                	ld	ra,24(sp)
    80201aea:	6442                	ld	s0,16(sp)
    80201aec:	6105                	addi	sp,sp,32
    80201aee:	8082                	ret

0000000080201af0 <test_curse_move>:
void test_curse_move(){
    80201af0:	1101                	addi	sp,sp,-32
    80201af2:	ec06                	sd	ra,24(sp)
    80201af4:	e822                	sd	s0,16(sp)
    80201af6:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    80201af8:	fffff097          	auipc	ra,0xfffff
    80201afc:	726080e7          	jalr	1830(ra) # 8020121e <clear_screen>
	printf("=== 光标移动测试 ===\n");
    80201b00:	0000d517          	auipc	a0,0xd
    80201b04:	13850513          	addi	a0,a0,312 # 8020ec38 <user_test_table+0x618>
    80201b08:	fffff097          	auipc	ra,0xfffff
    80201b0c:	1fe080e7          	jalr	510(ra) # 80200d06 <printf>
	for (int i = 3; i <= 7; i++) {
    80201b10:	478d                	li	a5,3
    80201b12:	fef42623          	sw	a5,-20(s0)
    80201b16:	a881                	j	80201b66 <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    80201b18:	4785                	li	a5,1
    80201b1a:	fef42423          	sw	a5,-24(s0)
    80201b1e:	a805                	j	80201b4e <test_curse_move+0x5e>
			goto_rc(i, j);
    80201b20:	fe842703          	lw	a4,-24(s0)
    80201b24:	fec42783          	lw	a5,-20(s0)
    80201b28:	85ba                	mv	a1,a4
    80201b2a:	853e                	mv	a0,a5
    80201b2c:	00000097          	auipc	ra,0x0
    80201b30:	95c080e7          	jalr	-1700(ra) # 80201488 <goto_rc>
			printf("*");
    80201b34:	0000d517          	auipc	a0,0xd
    80201b38:	12450513          	addi	a0,a0,292 # 8020ec58 <user_test_table+0x638>
    80201b3c:	fffff097          	auipc	ra,0xfffff
    80201b40:	1ca080e7          	jalr	458(ra) # 80200d06 <printf>
		for (int j = 1; j <= 10; j++) {
    80201b44:	fe842783          	lw	a5,-24(s0)
    80201b48:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdd8911>
    80201b4a:	fef42423          	sw	a5,-24(s0)
    80201b4e:	fe842783          	lw	a5,-24(s0)
    80201b52:	0007871b          	sext.w	a4,a5
    80201b56:	47a9                	li	a5,10
    80201b58:	fce7d4e3          	bge	a5,a4,80201b20 <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    80201b5c:	fec42783          	lw	a5,-20(s0)
    80201b60:	2785                	addiw	a5,a5,1
    80201b62:	fef42623          	sw	a5,-20(s0)
    80201b66:	fec42783          	lw	a5,-20(s0)
    80201b6a:	0007871b          	sext.w	a4,a5
    80201b6e:	479d                	li	a5,7
    80201b70:	fae7d4e3          	bge	a5,a4,80201b18 <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201b74:	4585                	li	a1,1
    80201b76:	4525                	li	a0,9
    80201b78:	00000097          	auipc	ra,0x0
    80201b7c:	910080e7          	jalr	-1776(ra) # 80201488 <goto_rc>
	save_cursor();
    80201b80:	00000097          	auipc	ra,0x0
    80201b84:	840080e7          	jalr	-1984(ra) # 802013c0 <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201b88:	4515                	li	a0,5
    80201b8a:	fffff097          	auipc	ra,0xfffff
    80201b8e:	6c6080e7          	jalr	1734(ra) # 80201250 <cursor_up>
	cursor_right(2);
    80201b92:	4509                	li	a0,2
    80201b94:	fffff097          	auipc	ra,0xfffff
    80201b98:	774080e7          	jalr	1908(ra) # 80201308 <cursor_right>
	printf("+++++");
    80201b9c:	0000d517          	auipc	a0,0xd
    80201ba0:	0c450513          	addi	a0,a0,196 # 8020ec60 <user_test_table+0x640>
    80201ba4:	fffff097          	auipc	ra,0xfffff
    80201ba8:	162080e7          	jalr	354(ra) # 80200d06 <printf>
	cursor_down(2);
    80201bac:	4509                	li	a0,2
    80201bae:	fffff097          	auipc	ra,0xfffff
    80201bb2:	6fe080e7          	jalr	1790(ra) # 802012ac <cursor_down>
	cursor_left(5);
    80201bb6:	4515                	li	a0,5
    80201bb8:	fffff097          	auipc	ra,0xfffff
    80201bbc:	7ac080e7          	jalr	1964(ra) # 80201364 <cursor_left>
	printf("-----");
    80201bc0:	0000d517          	auipc	a0,0xd
    80201bc4:	0a850513          	addi	a0,a0,168 # 8020ec68 <user_test_table+0x648>
    80201bc8:	fffff097          	auipc	ra,0xfffff
    80201bcc:	13e080e7          	jalr	318(ra) # 80200d06 <printf>
	restore_cursor();
    80201bd0:	00000097          	auipc	ra,0x0
    80201bd4:	824080e7          	jalr	-2012(ra) # 802013f4 <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80201bd8:	0000d517          	auipc	a0,0xd
    80201bdc:	09850513          	addi	a0,a0,152 # 8020ec70 <user_test_table+0x650>
    80201be0:	fffff097          	auipc	ra,0xfffff
    80201be4:	126080e7          	jalr	294(ra) # 80200d06 <printf>
}
    80201be8:	0001                	nop
    80201bea:	60e2                	ld	ra,24(sp)
    80201bec:	6442                	ld	s0,16(sp)
    80201bee:	6105                	addi	sp,sp,32
    80201bf0:	8082                	ret

0000000080201bf2 <test_basic_colors>:

void test_basic_colors(void) {
    80201bf2:	1141                	addi	sp,sp,-16
    80201bf4:	e406                	sd	ra,8(sp)
    80201bf6:	e022                	sd	s0,0(sp)
    80201bf8:	0800                	addi	s0,sp,16
    clear_screen();
    80201bfa:	fffff097          	auipc	ra,0xfffff
    80201bfe:	624080e7          	jalr	1572(ra) # 8020121e <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    80201c02:	0000d517          	auipc	a0,0xd
    80201c06:	09650513          	addi	a0,a0,150 # 8020ec98 <user_test_table+0x678>
    80201c0a:	fffff097          	auipc	ra,0xfffff
    80201c0e:	0fc080e7          	jalr	252(ra) # 80200d06 <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80201c12:	0000d517          	auipc	a0,0xd
    80201c16:	0a650513          	addi	a0,a0,166 # 8020ecb8 <user_test_table+0x698>
    80201c1a:	fffff097          	auipc	ra,0xfffff
    80201c1e:	0ec080e7          	jalr	236(ra) # 80200d06 <printf>
    color_red();    printf("红色文字 ");
    80201c22:	00000097          	auipc	ra,0x0
    80201c26:	9e4080e7          	jalr	-1564(ra) # 80201606 <color_red>
    80201c2a:	0000d517          	auipc	a0,0xd
    80201c2e:	0a650513          	addi	a0,a0,166 # 8020ecd0 <user_test_table+0x6b0>
    80201c32:	fffff097          	auipc	ra,0xfffff
    80201c36:	0d4080e7          	jalr	212(ra) # 80200d06 <printf>
    color_green();  printf("绿色文字 ");
    80201c3a:	00000097          	auipc	ra,0x0
    80201c3e:	9e8080e7          	jalr	-1560(ra) # 80201622 <color_green>
    80201c42:	0000d517          	auipc	a0,0xd
    80201c46:	09e50513          	addi	a0,a0,158 # 8020ece0 <user_test_table+0x6c0>
    80201c4a:	fffff097          	auipc	ra,0xfffff
    80201c4e:	0bc080e7          	jalr	188(ra) # 80200d06 <printf>
    color_yellow(); printf("黄色文字 ");
    80201c52:	00000097          	auipc	ra,0x0
    80201c56:	9ee080e7          	jalr	-1554(ra) # 80201640 <color_yellow>
    80201c5a:	0000d517          	auipc	a0,0xd
    80201c5e:	09650513          	addi	a0,a0,150 # 8020ecf0 <user_test_table+0x6d0>
    80201c62:	fffff097          	auipc	ra,0xfffff
    80201c66:	0a4080e7          	jalr	164(ra) # 80200d06 <printf>
    color_blue();   printf("蓝色文字 ");
    80201c6a:	00000097          	auipc	ra,0x0
    80201c6e:	9f4080e7          	jalr	-1548(ra) # 8020165e <color_blue>
    80201c72:	0000d517          	auipc	a0,0xd
    80201c76:	08e50513          	addi	a0,a0,142 # 8020ed00 <user_test_table+0x6e0>
    80201c7a:	fffff097          	auipc	ra,0xfffff
    80201c7e:	08c080e7          	jalr	140(ra) # 80200d06 <printf>
    color_purple(); printf("紫色文字 ");
    80201c82:	00000097          	auipc	ra,0x0
    80201c86:	9fa080e7          	jalr	-1542(ra) # 8020167c <color_purple>
    80201c8a:	0000d517          	auipc	a0,0xd
    80201c8e:	08650513          	addi	a0,a0,134 # 8020ed10 <user_test_table+0x6f0>
    80201c92:	fffff097          	auipc	ra,0xfffff
    80201c96:	074080e7          	jalr	116(ra) # 80200d06 <printf>
    color_cyan();   printf("青色文字 ");
    80201c9a:	00000097          	auipc	ra,0x0
    80201c9e:	a00080e7          	jalr	-1536(ra) # 8020169a <color_cyan>
    80201ca2:	0000d517          	auipc	a0,0xd
    80201ca6:	07e50513          	addi	a0,a0,126 # 8020ed20 <user_test_table+0x700>
    80201caa:	fffff097          	auipc	ra,0xfffff
    80201cae:	05c080e7          	jalr	92(ra) # 80200d06 <printf>
    color_reverse();  printf("反色文字");
    80201cb2:	00000097          	auipc	ra,0x0
    80201cb6:	a06080e7          	jalr	-1530(ra) # 802016b8 <color_reverse>
    80201cba:	0000d517          	auipc	a0,0xd
    80201cbe:	07650513          	addi	a0,a0,118 # 8020ed30 <user_test_table+0x710>
    80201cc2:	fffff097          	auipc	ra,0xfffff
    80201cc6:	044080e7          	jalr	68(ra) # 80200d06 <printf>
    reset_color();
    80201cca:	00000097          	auipc	ra,0x0
    80201cce:	838080e7          	jalr	-1992(ra) # 80201502 <reset_color>
    printf("\n\n");
    80201cd2:	0000d517          	auipc	a0,0xd
    80201cd6:	06e50513          	addi	a0,a0,110 # 8020ed40 <user_test_table+0x720>
    80201cda:	fffff097          	auipc	ra,0xfffff
    80201cde:	02c080e7          	jalr	44(ra) # 80200d06 <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80201ce2:	0000d517          	auipc	a0,0xd
    80201ce6:	06650513          	addi	a0,a0,102 # 8020ed48 <user_test_table+0x728>
    80201cea:	fffff097          	auipc	ra,0xfffff
    80201cee:	01c080e7          	jalr	28(ra) # 80200d06 <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80201cf2:	02900513          	li	a0,41
    80201cf6:	00000097          	auipc	ra,0x0
    80201cfa:	89e080e7          	jalr	-1890(ra) # 80201594 <set_bg_color>
    80201cfe:	0000d517          	auipc	a0,0xd
    80201d02:	06250513          	addi	a0,a0,98 # 8020ed60 <user_test_table+0x740>
    80201d06:	fffff097          	auipc	ra,0xfffff
    80201d0a:	000080e7          	jalr	ra # 80200d06 <printf>
    80201d0e:	fffff097          	auipc	ra,0xfffff
    80201d12:	7f4080e7          	jalr	2036(ra) # 80201502 <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80201d16:	02a00513          	li	a0,42
    80201d1a:	00000097          	auipc	ra,0x0
    80201d1e:	87a080e7          	jalr	-1926(ra) # 80201594 <set_bg_color>
    80201d22:	0000d517          	auipc	a0,0xd
    80201d26:	04e50513          	addi	a0,a0,78 # 8020ed70 <user_test_table+0x750>
    80201d2a:	fffff097          	auipc	ra,0xfffff
    80201d2e:	fdc080e7          	jalr	-36(ra) # 80200d06 <printf>
    80201d32:	fffff097          	auipc	ra,0xfffff
    80201d36:	7d0080e7          	jalr	2000(ra) # 80201502 <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80201d3a:	02b00513          	li	a0,43
    80201d3e:	00000097          	auipc	ra,0x0
    80201d42:	856080e7          	jalr	-1962(ra) # 80201594 <set_bg_color>
    80201d46:	0000d517          	auipc	a0,0xd
    80201d4a:	03a50513          	addi	a0,a0,58 # 8020ed80 <user_test_table+0x760>
    80201d4e:	fffff097          	auipc	ra,0xfffff
    80201d52:	fb8080e7          	jalr	-72(ra) # 80200d06 <printf>
    80201d56:	fffff097          	auipc	ra,0xfffff
    80201d5a:	7ac080e7          	jalr	1964(ra) # 80201502 <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80201d5e:	02c00513          	li	a0,44
    80201d62:	00000097          	auipc	ra,0x0
    80201d66:	832080e7          	jalr	-1998(ra) # 80201594 <set_bg_color>
    80201d6a:	0000d517          	auipc	a0,0xd
    80201d6e:	02650513          	addi	a0,a0,38 # 8020ed90 <user_test_table+0x770>
    80201d72:	fffff097          	auipc	ra,0xfffff
    80201d76:	f94080e7          	jalr	-108(ra) # 80200d06 <printf>
    80201d7a:	fffff097          	auipc	ra,0xfffff
    80201d7e:	788080e7          	jalr	1928(ra) # 80201502 <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201d82:	02f00513          	li	a0,47
    80201d86:	00000097          	auipc	ra,0x0
    80201d8a:	80e080e7          	jalr	-2034(ra) # 80201594 <set_bg_color>
    80201d8e:	0000d517          	auipc	a0,0xd
    80201d92:	01250513          	addi	a0,a0,18 # 8020eda0 <user_test_table+0x780>
    80201d96:	fffff097          	auipc	ra,0xfffff
    80201d9a:	f70080e7          	jalr	-144(ra) # 80200d06 <printf>
    80201d9e:	fffff097          	auipc	ra,0xfffff
    80201da2:	764080e7          	jalr	1892(ra) # 80201502 <reset_color>
    printf("\n\n");
    80201da6:	0000d517          	auipc	a0,0xd
    80201daa:	f9a50513          	addi	a0,a0,-102 # 8020ed40 <user_test_table+0x720>
    80201dae:	fffff097          	auipc	ra,0xfffff
    80201db2:	f58080e7          	jalr	-168(ra) # 80200d06 <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201db6:	0000d517          	auipc	a0,0xd
    80201dba:	ffa50513          	addi	a0,a0,-6 # 8020edb0 <user_test_table+0x790>
    80201dbe:	fffff097          	auipc	ra,0xfffff
    80201dc2:	f48080e7          	jalr	-184(ra) # 80200d06 <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201dc6:	02c00593          	li	a1,44
    80201dca:	457d                	li	a0,31
    80201dcc:	00000097          	auipc	ra,0x0
    80201dd0:	90a080e7          	jalr	-1782(ra) # 802016d6 <set_color>
    80201dd4:	0000d517          	auipc	a0,0xd
    80201dd8:	ff450513          	addi	a0,a0,-12 # 8020edc8 <user_test_table+0x7a8>
    80201ddc:	fffff097          	auipc	ra,0xfffff
    80201de0:	f2a080e7          	jalr	-214(ra) # 80200d06 <printf>
    80201de4:	fffff097          	auipc	ra,0xfffff
    80201de8:	71e080e7          	jalr	1822(ra) # 80201502 <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201dec:	02d00593          	li	a1,45
    80201df0:	02100513          	li	a0,33
    80201df4:	00000097          	auipc	ra,0x0
    80201df8:	8e2080e7          	jalr	-1822(ra) # 802016d6 <set_color>
    80201dfc:	0000d517          	auipc	a0,0xd
    80201e00:	fdc50513          	addi	a0,a0,-36 # 8020edd8 <user_test_table+0x7b8>
    80201e04:	fffff097          	auipc	ra,0xfffff
    80201e08:	f02080e7          	jalr	-254(ra) # 80200d06 <printf>
    80201e0c:	fffff097          	auipc	ra,0xfffff
    80201e10:	6f6080e7          	jalr	1782(ra) # 80201502 <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201e14:	02f00593          	li	a1,47
    80201e18:	02000513          	li	a0,32
    80201e1c:	00000097          	auipc	ra,0x0
    80201e20:	8ba080e7          	jalr	-1862(ra) # 802016d6 <set_color>
    80201e24:	0000d517          	auipc	a0,0xd
    80201e28:	fc450513          	addi	a0,a0,-60 # 8020ede8 <user_test_table+0x7c8>
    80201e2c:	fffff097          	auipc	ra,0xfffff
    80201e30:	eda080e7          	jalr	-294(ra) # 80200d06 <printf>
    80201e34:	fffff097          	auipc	ra,0xfffff
    80201e38:	6ce080e7          	jalr	1742(ra) # 80201502 <reset_color>
    printf("\n\n");
    80201e3c:	0000d517          	auipc	a0,0xd
    80201e40:	f0450513          	addi	a0,a0,-252 # 8020ed40 <user_test_table+0x720>
    80201e44:	fffff097          	auipc	ra,0xfffff
    80201e48:	ec2080e7          	jalr	-318(ra) # 80200d06 <printf>
	reset_color();
    80201e4c:	fffff097          	auipc	ra,0xfffff
    80201e50:	6b6080e7          	jalr	1718(ra) # 80201502 <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201e54:	0000d517          	auipc	a0,0xd
    80201e58:	fa450513          	addi	a0,a0,-92 # 8020edf8 <user_test_table+0x7d8>
    80201e5c:	fffff097          	auipc	ra,0xfffff
    80201e60:	eaa080e7          	jalr	-342(ra) # 80200d06 <printf>
	cursor_up(1); // 光标上移一行
    80201e64:	4505                	li	a0,1
    80201e66:	fffff097          	auipc	ra,0xfffff
    80201e6a:	3ea080e7          	jalr	1002(ra) # 80201250 <cursor_up>
	clear_line();
    80201e6e:	00000097          	auipc	ra,0x0
    80201e72:	8a4080e7          	jalr	-1884(ra) # 80201712 <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201e76:	0000d517          	auipc	a0,0xd
    80201e7a:	fba50513          	addi	a0,a0,-70 # 8020ee30 <user_test_table+0x810>
    80201e7e:	fffff097          	auipc	ra,0xfffff
    80201e82:	e88080e7          	jalr	-376(ra) # 80200d06 <printf>
    80201e86:	0001                	nop
    80201e88:	60a2                	ld	ra,8(sp)
    80201e8a:	6402                	ld	s0,0(sp)
    80201e8c:	0141                	addi	sp,sp,16
    80201e8e:	8082                	ret

0000000080201e90 <memset>:
#include "defs.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201e90:	7139                	addi	sp,sp,-64
    80201e92:	fc22                	sd	s0,56(sp)
    80201e94:	0080                	addi	s0,sp,64
    80201e96:	fca43c23          	sd	a0,-40(s0)
    80201e9a:	87ae                	mv	a5,a1
    80201e9c:	fcc43423          	sd	a2,-56(s0)
    80201ea0:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201ea4:	fd843783          	ld	a5,-40(s0)
    80201ea8:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    80201eac:	a829                	j	80201ec6 <memset+0x36>
        *p++ = (unsigned char)c;
    80201eae:	fe843783          	ld	a5,-24(s0)
    80201eb2:	00178713          	addi	a4,a5,1
    80201eb6:	fee43423          	sd	a4,-24(s0)
    80201eba:	fd442703          	lw	a4,-44(s0)
    80201ebe:	0ff77713          	zext.b	a4,a4
    80201ec2:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    80201ec6:	fc843783          	ld	a5,-56(s0)
    80201eca:	fff78713          	addi	a4,a5,-1
    80201ece:	fce43423          	sd	a4,-56(s0)
    80201ed2:	fff1                	bnez	a5,80201eae <memset+0x1e>
    return dst;
    80201ed4:	fd843783          	ld	a5,-40(s0)
}
    80201ed8:	853e                	mv	a0,a5
    80201eda:	7462                	ld	s0,56(sp)
    80201edc:	6121                	addi	sp,sp,64
    80201ede:	8082                	ret

0000000080201ee0 <memmove>:
void *memmove(void *dst, const void *src, unsigned long n) {
    80201ee0:	7139                	addi	sp,sp,-64
    80201ee2:	fc22                	sd	s0,56(sp)
    80201ee4:	0080                	addi	s0,sp,64
    80201ee6:	fca43c23          	sd	a0,-40(s0)
    80201eea:	fcb43823          	sd	a1,-48(s0)
    80201eee:	fcc43423          	sd	a2,-56(s0)
	unsigned char *d = dst;
    80201ef2:	fd843783          	ld	a5,-40(s0)
    80201ef6:	fef43423          	sd	a5,-24(s0)
	const unsigned char *s = src;
    80201efa:	fd043783          	ld	a5,-48(s0)
    80201efe:	fef43023          	sd	a5,-32(s0)
	if (d < s) {
    80201f02:	fe843703          	ld	a4,-24(s0)
    80201f06:	fe043783          	ld	a5,-32(s0)
    80201f0a:	02f77b63          	bgeu	a4,a5,80201f40 <memmove+0x60>
		while (n-- > 0)
    80201f0e:	a00d                	j	80201f30 <memmove+0x50>
			*d++ = *s++;
    80201f10:	fe043703          	ld	a4,-32(s0)
    80201f14:	00170793          	addi	a5,a4,1
    80201f18:	fef43023          	sd	a5,-32(s0)
    80201f1c:	fe843783          	ld	a5,-24(s0)
    80201f20:	00178693          	addi	a3,a5,1
    80201f24:	fed43423          	sd	a3,-24(s0)
    80201f28:	00074703          	lbu	a4,0(a4)
    80201f2c:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201f30:	fc843783          	ld	a5,-56(s0)
    80201f34:	fff78713          	addi	a4,a5,-1
    80201f38:	fce43423          	sd	a4,-56(s0)
    80201f3c:	fbf1                	bnez	a5,80201f10 <memmove+0x30>
    80201f3e:	a889                	j	80201f90 <memmove+0xb0>
	} else {
		d += n;
    80201f40:	fe843703          	ld	a4,-24(s0)
    80201f44:	fc843783          	ld	a5,-56(s0)
    80201f48:	97ba                	add	a5,a5,a4
    80201f4a:	fef43423          	sd	a5,-24(s0)
		s += n;
    80201f4e:	fe043703          	ld	a4,-32(s0)
    80201f52:	fc843783          	ld	a5,-56(s0)
    80201f56:	97ba                	add	a5,a5,a4
    80201f58:	fef43023          	sd	a5,-32(s0)
		while (n-- > 0)
    80201f5c:	a01d                	j	80201f82 <memmove+0xa2>
			*(--d) = *(--s);
    80201f5e:	fe043783          	ld	a5,-32(s0)
    80201f62:	17fd                	addi	a5,a5,-1
    80201f64:	fef43023          	sd	a5,-32(s0)
    80201f68:	fe843783          	ld	a5,-24(s0)
    80201f6c:	17fd                	addi	a5,a5,-1
    80201f6e:	fef43423          	sd	a5,-24(s0)
    80201f72:	fe043783          	ld	a5,-32(s0)
    80201f76:	0007c703          	lbu	a4,0(a5)
    80201f7a:	fe843783          	ld	a5,-24(s0)
    80201f7e:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201f82:	fc843783          	ld	a5,-56(s0)
    80201f86:	fff78713          	addi	a4,a5,-1
    80201f8a:	fce43423          	sd	a4,-56(s0)
    80201f8e:	fbe1                	bnez	a5,80201f5e <memmove+0x7e>
	}
	return dst;
    80201f90:	fd843783          	ld	a5,-40(s0)
}
    80201f94:	853e                	mv	a0,a5
    80201f96:	7462                	ld	s0,56(sp)
    80201f98:	6121                	addi	sp,sp,64
    80201f9a:	8082                	ret

0000000080201f9c <memcpy>:
void *memcpy(void *dst, const void *src, size_t n) {
    80201f9c:	715d                	addi	sp,sp,-80
    80201f9e:	e4a2                	sd	s0,72(sp)
    80201fa0:	0880                	addi	s0,sp,80
    80201fa2:	fca43423          	sd	a0,-56(s0)
    80201fa6:	fcb43023          	sd	a1,-64(s0)
    80201faa:	fac43c23          	sd	a2,-72(s0)
    char *d = dst;
    80201fae:	fc843783          	ld	a5,-56(s0)
    80201fb2:	fef43023          	sd	a5,-32(s0)
    const char *s = src;
    80201fb6:	fc043783          	ld	a5,-64(s0)
    80201fba:	fcf43c23          	sd	a5,-40(s0)
    for (size_t i = 0; i < n; i++) {
    80201fbe:	fe043423          	sd	zero,-24(s0)
    80201fc2:	a025                	j	80201fea <memcpy+0x4e>
        d[i] = s[i];
    80201fc4:	fd843703          	ld	a4,-40(s0)
    80201fc8:	fe843783          	ld	a5,-24(s0)
    80201fcc:	973e                	add	a4,a4,a5
    80201fce:	fe043683          	ld	a3,-32(s0)
    80201fd2:	fe843783          	ld	a5,-24(s0)
    80201fd6:	97b6                	add	a5,a5,a3
    80201fd8:	00074703          	lbu	a4,0(a4)
    80201fdc:	00e78023          	sb	a4,0(a5)
    for (size_t i = 0; i < n; i++) {
    80201fe0:	fe843783          	ld	a5,-24(s0)
    80201fe4:	0785                	addi	a5,a5,1
    80201fe6:	fef43423          	sd	a5,-24(s0)
    80201fea:	fe843703          	ld	a4,-24(s0)
    80201fee:	fb843783          	ld	a5,-72(s0)
    80201ff2:	fcf769e3          	bltu	a4,a5,80201fc4 <memcpy+0x28>
    }
    return dst;
    80201ff6:	fc843783          	ld	a5,-56(s0)
    80201ffa:	853e                	mv	a0,a5
    80201ffc:	6426                	ld	s0,72(sp)
    80201ffe:	6161                	addi	sp,sp,80
    80202000:	8082                	ret

0000000080202002 <assert>:
    80202002:	1101                	addi	sp,sp,-32
    80202004:	ec06                	sd	ra,24(sp)
    80202006:	e822                	sd	s0,16(sp)
    80202008:	1000                	addi	s0,sp,32
    8020200a:	87aa                	mv	a5,a0
    8020200c:	fef42623          	sw	a5,-20(s0)
    80202010:	fec42783          	lw	a5,-20(s0)
    80202014:	2781                	sext.w	a5,a5
    80202016:	e79d                	bnez	a5,80202044 <assert+0x42>
    80202018:	1b700613          	li	a2,439
    8020201c:	00011597          	auipc	a1,0x11
    80202020:	e5458593          	addi	a1,a1,-428 # 80212e70 <user_test_table+0x60>
    80202024:	00011517          	auipc	a0,0x11
    80202028:	e5c50513          	addi	a0,a0,-420 # 80212e80 <user_test_table+0x70>
    8020202c:	fffff097          	auipc	ra,0xfffff
    80202030:	cda080e7          	jalr	-806(ra) # 80200d06 <printf>
    80202034:	00011517          	auipc	a0,0x11
    80202038:	e7450513          	addi	a0,a0,-396 # 80212ea8 <user_test_table+0x98>
    8020203c:	fffff097          	auipc	ra,0xfffff
    80202040:	716080e7          	jalr	1814(ra) # 80201752 <panic>
    80202044:	0001                	nop
    80202046:	60e2                	ld	ra,24(sp)
    80202048:	6442                	ld	s0,16(sp)
    8020204a:	6105                	addi	sp,sp,32
    8020204c:	8082                	ret

000000008020204e <sv39_sign_extend>:
    8020204e:	1101                	addi	sp,sp,-32
    80202050:	ec22                	sd	s0,24(sp)
    80202052:	1000                	addi	s0,sp,32
    80202054:	fea43423          	sd	a0,-24(s0)
    80202058:	fe843703          	ld	a4,-24(s0)
    8020205c:	4785                	li	a5,1
    8020205e:	179a                	slli	a5,a5,0x26
    80202060:	8ff9                	and	a5,a5,a4
    80202062:	c799                	beqz	a5,80202070 <sv39_sign_extend+0x22>
    80202064:	fe843703          	ld	a4,-24(s0)
    80202068:	57fd                	li	a5,-1
    8020206a:	179e                	slli	a5,a5,0x27
    8020206c:	8fd9                	or	a5,a5,a4
    8020206e:	a031                	j	8020207a <sv39_sign_extend+0x2c>
    80202070:	fe843703          	ld	a4,-24(s0)
    80202074:	57fd                	li	a5,-1
    80202076:	83e5                	srli	a5,a5,0x19
    80202078:	8ff9                	and	a5,a5,a4
    8020207a:	853e                	mv	a0,a5
    8020207c:	6462                	ld	s0,24(sp)
    8020207e:	6105                	addi	sp,sp,32
    80202080:	8082                	ret

0000000080202082 <sv39_check_valid>:
    80202082:	1101                	addi	sp,sp,-32
    80202084:	ec22                	sd	s0,24(sp)
    80202086:	1000                	addi	s0,sp,32
    80202088:	fea43423          	sd	a0,-24(s0)
    8020208c:	fe843703          	ld	a4,-24(s0)
    80202090:	57fd                	li	a5,-1
    80202092:	83e5                	srli	a5,a5,0x19
    80202094:	00e7f863          	bgeu	a5,a4,802020a4 <sv39_check_valid+0x22>
    80202098:	fe843703          	ld	a4,-24(s0)
    8020209c:	57fd                	li	a5,-1
    8020209e:	179e                	slli	a5,a5,0x27
    802020a0:	00f76463          	bltu	a4,a5,802020a8 <sv39_check_valid+0x26>
    802020a4:	4785                	li	a5,1
    802020a6:	a011                	j	802020aa <sv39_check_valid+0x28>
    802020a8:	4781                	li	a5,0
    802020aa:	853e                	mv	a0,a5
    802020ac:	6462                	ld	s0,24(sp)
    802020ae:	6105                	addi	sp,sp,32
    802020b0:	8082                	ret

00000000802020b2 <px>:
static inline uint64 px(int level, uint64 va) {
    802020b2:	1101                	addi	sp,sp,-32
    802020b4:	ec22                	sd	s0,24(sp)
    802020b6:	1000                	addi	s0,sp,32
    802020b8:	87aa                	mv	a5,a0
    802020ba:	feb43023          	sd	a1,-32(s0)
    802020be:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    802020c2:	fec42783          	lw	a5,-20(s0)
    802020c6:	873e                	mv	a4,a5
    802020c8:	87ba                	mv	a5,a4
    802020ca:	0037979b          	slliw	a5,a5,0x3
    802020ce:	9fb9                	addw	a5,a5,a4
    802020d0:	2781                	sext.w	a5,a5
    802020d2:	27b1                	addiw	a5,a5,12
    802020d4:	2781                	sext.w	a5,a5
    802020d6:	873e                	mv	a4,a5
    802020d8:	fe043783          	ld	a5,-32(s0)
    802020dc:	00e7d7b3          	srl	a5,a5,a4
    802020e0:	1ff7f793          	andi	a5,a5,511
}
    802020e4:	853e                	mv	a0,a5
    802020e6:	6462                	ld	s0,24(sp)
    802020e8:	6105                	addi	sp,sp,32
    802020ea:	8082                	ret

00000000802020ec <create_pagetable>:
pagetable_t create_pagetable(void) {
    802020ec:	1101                	addi	sp,sp,-32
    802020ee:	ec06                	sd	ra,24(sp)
    802020f0:	e822                	sd	s0,16(sp)
    802020f2:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    802020f4:	00001097          	auipc	ra,0x1
    802020f8:	1a4080e7          	jalr	420(ra) # 80203298 <alloc_page>
    802020fc:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    80202100:	fe843783          	ld	a5,-24(s0)
    80202104:	e399                	bnez	a5,8020210a <create_pagetable+0x1e>
        return 0;
    80202106:	4781                	li	a5,0
    80202108:	a819                	j	8020211e <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    8020210a:	6605                	lui	a2,0x1
    8020210c:	4581                	li	a1,0
    8020210e:	fe843503          	ld	a0,-24(s0)
    80202112:	00000097          	auipc	ra,0x0
    80202116:	d7e080e7          	jalr	-642(ra) # 80201e90 <memset>
    return pt;
    8020211a:	fe843783          	ld	a5,-24(s0)
}
    8020211e:	853e                	mv	a0,a5
    80202120:	60e2                	ld	ra,24(sp)
    80202122:	6442                	ld	s0,16(sp)
    80202124:	6105                	addi	sp,sp,32
    80202126:	8082                	ret

0000000080202128 <walk_lookup>:
pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    80202128:	7139                	addi	sp,sp,-64
    8020212a:	fc06                	sd	ra,56(sp)
    8020212c:	f822                	sd	s0,48(sp)
    8020212e:	0080                	addi	s0,sp,64
    80202130:	fca43423          	sd	a0,-56(s0)
    80202134:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    80202138:	fc043503          	ld	a0,-64(s0)
    8020213c:	00000097          	auipc	ra,0x0
    80202140:	f12080e7          	jalr	-238(ra) # 8020204e <sv39_sign_extend>
    80202144:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    80202148:	fc043503          	ld	a0,-64(s0)
    8020214c:	00000097          	auipc	ra,0x0
    80202150:	f36080e7          	jalr	-202(ra) # 80202082 <sv39_check_valid>
    80202154:	87aa                	mv	a5,a0
    80202156:	eb89                	bnez	a5,80202168 <walk_lookup+0x40>
		panic("va out of sv39 range");
    80202158:	00011517          	auipc	a0,0x11
    8020215c:	d5850513          	addi	a0,a0,-680 # 80212eb0 <user_test_table+0xa0>
    80202160:	fffff097          	auipc	ra,0xfffff
    80202164:	5f2080e7          	jalr	1522(ra) # 80201752 <panic>
    for (int level = 2; level > 0; level--) {
    80202168:	4789                	li	a5,2
    8020216a:	fef42623          	sw	a5,-20(s0)
    8020216e:	a0e9                	j	80202238 <walk_lookup+0x110>
        pte_t *pte = &pt[px(level, va)];
    80202170:	fec42783          	lw	a5,-20(s0)
    80202174:	fc043583          	ld	a1,-64(s0)
    80202178:	853e                	mv	a0,a5
    8020217a:	00000097          	auipc	ra,0x0
    8020217e:	f38080e7          	jalr	-200(ra) # 802020b2 <px>
    80202182:	87aa                	mv	a5,a0
    80202184:	078e                	slli	a5,a5,0x3
    80202186:	fc843703          	ld	a4,-56(s0)
    8020218a:	97ba                	add	a5,a5,a4
    8020218c:	fef43023          	sd	a5,-32(s0)
        if (!pte) {
    80202190:	fe043783          	ld	a5,-32(s0)
    80202194:	ef91                	bnez	a5,802021b0 <walk_lookup+0x88>
            printf("[WALK_LOOKUP] pte is NULL at level %d\n", level);
    80202196:	fec42783          	lw	a5,-20(s0)
    8020219a:	85be                	mv	a1,a5
    8020219c:	00011517          	auipc	a0,0x11
    802021a0:	d2c50513          	addi	a0,a0,-724 # 80212ec8 <user_test_table+0xb8>
    802021a4:	fffff097          	auipc	ra,0xfffff
    802021a8:	b62080e7          	jalr	-1182(ra) # 80200d06 <printf>
            return 0;
    802021ac:	4781                	li	a5,0
    802021ae:	a075                	j	8020225a <walk_lookup+0x132>
        if (*pte & PTE_V) {
    802021b0:	fe043783          	ld	a5,-32(s0)
    802021b4:	639c                	ld	a5,0(a5)
    802021b6:	8b85                	andi	a5,a5,1
    802021b8:	cfa1                	beqz	a5,80202210 <walk_lookup+0xe8>
            uint64 pa = PTE2PA(*pte);
    802021ba:	fe043783          	ld	a5,-32(s0)
    802021be:	639c                	ld	a5,0(a5)
    802021c0:	83a9                	srli	a5,a5,0xa
    802021c2:	07b2                	slli	a5,a5,0xc
    802021c4:	fcf43c23          	sd	a5,-40(s0)
            if (pa < KERNBASE || pa >= PHYSTOP) {
    802021c8:	fd843703          	ld	a4,-40(s0)
    802021cc:	800007b7          	lui	a5,0x80000
    802021d0:	fff7c793          	not	a5,a5
    802021d4:	00e7f863          	bgeu	a5,a4,802021e4 <walk_lookup+0xbc>
    802021d8:	fd843703          	ld	a4,-40(s0)
    802021dc:	47c5                	li	a5,17
    802021de:	07ee                	slli	a5,a5,0x1b
    802021e0:	02f76363          	bltu	a4,a5,80202206 <walk_lookup+0xde>
                printf("[WALK_LOOKUP] 非法页表物理地址: 0x%lx (level %d, va=0x%lx)\n", pa, level, va);
    802021e4:	fec42783          	lw	a5,-20(s0)
    802021e8:	fc043683          	ld	a3,-64(s0)
    802021ec:	863e                	mv	a2,a5
    802021ee:	fd843583          	ld	a1,-40(s0)
    802021f2:	00011517          	auipc	a0,0x11
    802021f6:	cfe50513          	addi	a0,a0,-770 # 80212ef0 <user_test_table+0xe0>
    802021fa:	fffff097          	auipc	ra,0xfffff
    802021fe:	b0c080e7          	jalr	-1268(ra) # 80200d06 <printf>
                return 0;
    80202202:	4781                	li	a5,0
    80202204:	a899                	j	8020225a <walk_lookup+0x132>
            pt = (pagetable_t)pa;
    80202206:	fd843783          	ld	a5,-40(s0)
    8020220a:	fcf43423          	sd	a5,-56(s0)
    8020220e:	a005                	j	8020222e <walk_lookup+0x106>
            printf("[WALK_LOOKUP] 页表项无效: level=%d va=0x%lx\n", level, va);
    80202210:	fec42783          	lw	a5,-20(s0)
    80202214:	fc043603          	ld	a2,-64(s0)
    80202218:	85be                	mv	a1,a5
    8020221a:	00011517          	auipc	a0,0x11
    8020221e:	d1e50513          	addi	a0,a0,-738 # 80212f38 <user_test_table+0x128>
    80202222:	fffff097          	auipc	ra,0xfffff
    80202226:	ae4080e7          	jalr	-1308(ra) # 80200d06 <printf>
            return 0;
    8020222a:	4781                	li	a5,0
    8020222c:	a03d                	j	8020225a <walk_lookup+0x132>
    for (int level = 2; level > 0; level--) {
    8020222e:	fec42783          	lw	a5,-20(s0)
    80202232:	37fd                	addiw	a5,a5,-1 # 7fffffff <_entry-0x200001>
    80202234:	fef42623          	sw	a5,-20(s0)
    80202238:	fec42783          	lw	a5,-20(s0)
    8020223c:	2781                	sext.w	a5,a5
    8020223e:	f2f049e3          	bgtz	a5,80202170 <walk_lookup+0x48>
    return &pt[px(0, va)];
    80202242:	fc043583          	ld	a1,-64(s0)
    80202246:	4501                	li	a0,0
    80202248:	00000097          	auipc	ra,0x0
    8020224c:	e6a080e7          	jalr	-406(ra) # 802020b2 <px>
    80202250:	87aa                	mv	a5,a0
    80202252:	078e                	slli	a5,a5,0x3
    80202254:	fc843703          	ld	a4,-56(s0)
    80202258:	97ba                	add	a5,a5,a4
}
    8020225a:	853e                	mv	a0,a5
    8020225c:	70e2                	ld	ra,56(sp)
    8020225e:	7442                	ld	s0,48(sp)
    80202260:	6121                	addi	sp,sp,64
    80202262:	8082                	ret

0000000080202264 <walk_create>:
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    80202264:	7139                	addi	sp,sp,-64
    80202266:	fc06                	sd	ra,56(sp)
    80202268:	f822                	sd	s0,48(sp)
    8020226a:	0080                	addi	s0,sp,64
    8020226c:	fca43423          	sd	a0,-56(s0)
    80202270:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    80202274:	fc043503          	ld	a0,-64(s0)
    80202278:	00000097          	auipc	ra,0x0
    8020227c:	dd6080e7          	jalr	-554(ra) # 8020204e <sv39_sign_extend>
    80202280:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    80202284:	fc043503          	ld	a0,-64(s0)
    80202288:	00000097          	auipc	ra,0x0
    8020228c:	dfa080e7          	jalr	-518(ra) # 80202082 <sv39_check_valid>
    80202290:	87aa                	mv	a5,a0
    80202292:	eb89                	bnez	a5,802022a4 <walk_create+0x40>
		panic("va out of sv39 range");
    80202294:	00011517          	auipc	a0,0x11
    80202298:	c1c50513          	addi	a0,a0,-996 # 80212eb0 <user_test_table+0xa0>
    8020229c:	fffff097          	auipc	ra,0xfffff
    802022a0:	4b6080e7          	jalr	1206(ra) # 80201752 <panic>
    for (int level = 2; level > 0; level--) {
    802022a4:	4789                	li	a5,2
    802022a6:	fef42623          	sw	a5,-20(s0)
    802022aa:	a059                	j	80202330 <walk_create+0xcc>
        pte_t *pte = &pt[px(level, va)];
    802022ac:	fec42783          	lw	a5,-20(s0)
    802022b0:	fc043583          	ld	a1,-64(s0)
    802022b4:	853e                	mv	a0,a5
    802022b6:	00000097          	auipc	ra,0x0
    802022ba:	dfc080e7          	jalr	-516(ra) # 802020b2 <px>
    802022be:	87aa                	mv	a5,a0
    802022c0:	078e                	slli	a5,a5,0x3
    802022c2:	fc843703          	ld	a4,-56(s0)
    802022c6:	97ba                	add	a5,a5,a4
    802022c8:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    802022cc:	fe043783          	ld	a5,-32(s0)
    802022d0:	639c                	ld	a5,0(a5)
    802022d2:	8b85                	andi	a5,a5,1
    802022d4:	cb89                	beqz	a5,802022e6 <walk_create+0x82>
            pt = (pagetable_t)PTE2PA(*pte);
    802022d6:	fe043783          	ld	a5,-32(s0)
    802022da:	639c                	ld	a5,0(a5)
    802022dc:	83a9                	srli	a5,a5,0xa
    802022de:	07b2                	slli	a5,a5,0xc
    802022e0:	fcf43423          	sd	a5,-56(s0)
    802022e4:	a089                	j	80202326 <walk_create+0xc2>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    802022e6:	00001097          	auipc	ra,0x1
    802022ea:	fb2080e7          	jalr	-78(ra) # 80203298 <alloc_page>
    802022ee:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    802022f2:	fd843783          	ld	a5,-40(s0)
    802022f6:	e399                	bnez	a5,802022fc <walk_create+0x98>
                return 0;
    802022f8:	4781                	li	a5,0
    802022fa:	a8a1                	j	80202352 <walk_create+0xee>
            memset(new_pt, 0, PGSIZE);
    802022fc:	6605                	lui	a2,0x1
    802022fe:	4581                	li	a1,0
    80202300:	fd843503          	ld	a0,-40(s0)
    80202304:	00000097          	auipc	ra,0x0
    80202308:	b8c080e7          	jalr	-1140(ra) # 80201e90 <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    8020230c:	fd843783          	ld	a5,-40(s0)
    80202310:	83b1                	srli	a5,a5,0xc
    80202312:	07aa                	slli	a5,a5,0xa
    80202314:	0017e713          	ori	a4,a5,1
    80202318:	fe043783          	ld	a5,-32(s0)
    8020231c:	e398                	sd	a4,0(a5)
            pt = new_pt;
    8020231e:	fd843783          	ld	a5,-40(s0)
    80202322:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    80202326:	fec42783          	lw	a5,-20(s0)
    8020232a:	37fd                	addiw	a5,a5,-1
    8020232c:	fef42623          	sw	a5,-20(s0)
    80202330:	fec42783          	lw	a5,-20(s0)
    80202334:	2781                	sext.w	a5,a5
    80202336:	f6f04be3          	bgtz	a5,802022ac <walk_create+0x48>
    return &pt[px(0, va)];
    8020233a:	fc043583          	ld	a1,-64(s0)
    8020233e:	4501                	li	a0,0
    80202340:	00000097          	auipc	ra,0x0
    80202344:	d72080e7          	jalr	-654(ra) # 802020b2 <px>
    80202348:	87aa                	mv	a5,a0
    8020234a:	078e                	slli	a5,a5,0x3
    8020234c:	fc843703          	ld	a4,-56(s0)
    80202350:	97ba                	add	a5,a5,a4
}
    80202352:	853e                	mv	a0,a5
    80202354:	70e2                	ld	ra,56(sp)
    80202356:	7442                	ld	s0,48(sp)
    80202358:	6121                	addi	sp,sp,64
    8020235a:	8082                	ret

000000008020235c <map_page>:
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    8020235c:	715d                	addi	sp,sp,-80
    8020235e:	e486                	sd	ra,72(sp)
    80202360:	e0a2                	sd	s0,64(sp)
    80202362:	0880                	addi	s0,sp,80
    80202364:	fca43423          	sd	a0,-56(s0)
    80202368:	fcb43023          	sd	a1,-64(s0)
    8020236c:	fac43c23          	sd	a2,-72(s0)
    80202370:	87b6                	mv	a5,a3
    80202372:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = myproc();
    80202376:	00003097          	auipc	ra,0x3
    8020237a:	c1a080e7          	jalr	-998(ra) # 80204f90 <myproc>
    8020237e:	fea43023          	sd	a0,-32(s0)
	if (p && p->is_user && va >= 0x80000000
    80202382:	fe043783          	ld	a5,-32(s0)
    80202386:	c7a9                	beqz	a5,802023d0 <map_page+0x74>
    80202388:	fe043783          	ld	a5,-32(s0)
    8020238c:	0a87a783          	lw	a5,168(a5)
    80202390:	c3a1                	beqz	a5,802023d0 <map_page+0x74>
    80202392:	fc043703          	ld	a4,-64(s0)
    80202396:	800007b7          	lui	a5,0x80000
    8020239a:	fff7c793          	not	a5,a5
    8020239e:	02e7f963          	bgeu	a5,a4,802023d0 <map_page+0x74>
		&& va != TRAMPOLINE
    802023a2:	fc043703          	ld	a4,-64(s0)
    802023a6:	77fd                	lui	a5,0xfffff
    802023a8:	02f70463          	beq	a4,a5,802023d0 <map_page+0x74>
		&& va != TRAPFRAME) {
    802023ac:	fc043703          	ld	a4,-64(s0)
    802023b0:	77f9                	lui	a5,0xffffe
    802023b2:	00f70f63          	beq	a4,a5,802023d0 <map_page+0x74>
		warning("map_page: 用户进程禁止映射内核空间");
    802023b6:	00011517          	auipc	a0,0x11
    802023ba:	bba50513          	addi	a0,a0,-1094 # 80212f70 <user_test_table+0x160>
    802023be:	fffff097          	auipc	ra,0xfffff
    802023c2:	3c8080e7          	jalr	968(ra) # 80201786 <warning>
		exit_proc(-1);
    802023c6:	557d                	li	a0,-1
    802023c8:	00004097          	auipc	ra,0x4
    802023cc:	9ba080e7          	jalr	-1606(ra) # 80205d82 <exit_proc>
    if ((va % PGSIZE) != 0)
    802023d0:	fc043703          	ld	a4,-64(s0)
    802023d4:	6785                	lui	a5,0x1
    802023d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802023d8:	8ff9                	and	a5,a5,a4
    802023da:	cb89                	beqz	a5,802023ec <map_page+0x90>
        panic("map_page: va not aligned");
    802023dc:	00011517          	auipc	a0,0x11
    802023e0:	bc450513          	addi	a0,a0,-1084 # 80212fa0 <user_test_table+0x190>
    802023e4:	fffff097          	auipc	ra,0xfffff
    802023e8:	36e080e7          	jalr	878(ra) # 80201752 <panic>
    pte_t *pte = walk_create(pt, va);
    802023ec:	fc043583          	ld	a1,-64(s0)
    802023f0:	fc843503          	ld	a0,-56(s0)
    802023f4:	00000097          	auipc	ra,0x0
    802023f8:	e70080e7          	jalr	-400(ra) # 80202264 <walk_create>
    802023fc:	fca43c23          	sd	a0,-40(s0)
    if (!pte)
    80202400:	fd843783          	ld	a5,-40(s0)
    80202404:	e399                	bnez	a5,8020240a <map_page+0xae>
        return -1;
    80202406:	57fd                	li	a5,-1
    80202408:	a87d                	j	802024c6 <map_page+0x16a>
    if (va >= 0x80000000)
    8020240a:	fc043703          	ld	a4,-64(s0)
    8020240e:	800007b7          	lui	a5,0x80000
    80202412:	fff7c793          	not	a5,a5
    80202416:	00e7f763          	bgeu	a5,a4,80202424 <map_page+0xc8>
        perm &= ~PTE_U;
    8020241a:	fb442783          	lw	a5,-76(s0)
    8020241e:	9bbd                	andi	a5,a5,-17
    80202420:	faf42a23          	sw	a5,-76(s0)
    if (*pte & PTE_V) {
    80202424:	fd843783          	ld	a5,-40(s0)
    80202428:	639c                	ld	a5,0(a5)
    8020242a:	8b85                	andi	a5,a5,1
    8020242c:	cfbd                	beqz	a5,802024aa <map_page+0x14e>
        if (PTE2PA(*pte) == pa) {
    8020242e:	fd843783          	ld	a5,-40(s0)
    80202432:	639c                	ld	a5,0(a5)
    80202434:	83a9                	srli	a5,a5,0xa
    80202436:	07b2                	slli	a5,a5,0xc
    80202438:	fb843703          	ld	a4,-72(s0)
    8020243c:	04f71f63          	bne	a4,a5,8020249a <map_page+0x13e>
            int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
    80202440:	fd843783          	ld	a5,-40(s0)
    80202444:	639c                	ld	a5,0(a5)
    80202446:	2781                	sext.w	a5,a5
    80202448:	3ff7f793          	andi	a5,a5,1023
    8020244c:	0007871b          	sext.w	a4,a5
    80202450:	fb442783          	lw	a5,-76(s0)
    80202454:	8fd9                	or	a5,a5,a4
    80202456:	2781                	sext.w	a5,a5
    80202458:	2781                	sext.w	a5,a5
    8020245a:	3ff7f793          	andi	a5,a5,1023
    8020245e:	fef42623          	sw	a5,-20(s0)
            if (va >= 0x80000000)
    80202462:	fc043703          	ld	a4,-64(s0)
    80202466:	800007b7          	lui	a5,0x80000
    8020246a:	fff7c793          	not	a5,a5
    8020246e:	00e7f763          	bgeu	a5,a4,8020247c <map_page+0x120>
                new_perm &= ~PTE_U;
    80202472:	fec42783          	lw	a5,-20(s0)
    80202476:	9bbd                	andi	a5,a5,-17
    80202478:	fef42623          	sw	a5,-20(s0)
            *pte = PA2PTE(pa) | new_perm | PTE_V;
    8020247c:	fb843783          	ld	a5,-72(s0)
    80202480:	83b1                	srli	a5,a5,0xc
    80202482:	00a79713          	slli	a4,a5,0xa
    80202486:	fec42783          	lw	a5,-20(s0)
    8020248a:	8fd9                	or	a5,a5,a4
    8020248c:	0017e713          	ori	a4,a5,1
    80202490:	fd843783          	ld	a5,-40(s0)
    80202494:	e398                	sd	a4,0(a5)
            return 0;
    80202496:	4781                	li	a5,0
    80202498:	a03d                	j	802024c6 <map_page+0x16a>
            panic("map_page: remap to different physical address");
    8020249a:	00011517          	auipc	a0,0x11
    8020249e:	b2650513          	addi	a0,a0,-1242 # 80212fc0 <user_test_table+0x1b0>
    802024a2:	fffff097          	auipc	ra,0xfffff
    802024a6:	2b0080e7          	jalr	688(ra) # 80201752 <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    802024aa:	fb843783          	ld	a5,-72(s0)
    802024ae:	83b1                	srli	a5,a5,0xc
    802024b0:	00a79713          	slli	a4,a5,0xa
    802024b4:	fb442783          	lw	a5,-76(s0)
    802024b8:	8fd9                	or	a5,a5,a4
    802024ba:	0017e713          	ori	a4,a5,1
    802024be:	fd843783          	ld	a5,-40(s0)
    802024c2:	e398                	sd	a4,0(a5)
    return 0;
    802024c4:	4781                	li	a5,0
}
    802024c6:	853e                	mv	a0,a5
    802024c8:	60a6                	ld	ra,72(sp)
    802024ca:	6406                	ld	s0,64(sp)
    802024cc:	6161                	addi	sp,sp,80
    802024ce:	8082                	ret

00000000802024d0 <free_pagetable>:
void free_pagetable(pagetable_t pt) {
    802024d0:	7139                	addi	sp,sp,-64
    802024d2:	fc06                	sd	ra,56(sp)
    802024d4:	f822                	sd	s0,48(sp)
    802024d6:	0080                	addi	s0,sp,64
    802024d8:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    802024dc:	fe042623          	sw	zero,-20(s0)
    802024e0:	a8a5                	j	80202558 <free_pagetable+0x88>
        pte_t pte = pt[i];
    802024e2:	fec42783          	lw	a5,-20(s0)
    802024e6:	078e                	slli	a5,a5,0x3
    802024e8:	fc843703          	ld	a4,-56(s0)
    802024ec:	97ba                	add	a5,a5,a4
    802024ee:	639c                	ld	a5,0(a5)
    802024f0:	fef43023          	sd	a5,-32(s0)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    802024f4:	fe043783          	ld	a5,-32(s0)
    802024f8:	8b85                	andi	a5,a5,1
    802024fa:	cb95                	beqz	a5,8020252e <free_pagetable+0x5e>
    802024fc:	fe043783          	ld	a5,-32(s0)
    80202500:	8bb9                	andi	a5,a5,14
    80202502:	e795                	bnez	a5,8020252e <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    80202504:	fe043783          	ld	a5,-32(s0)
    80202508:	83a9                	srli	a5,a5,0xa
    8020250a:	07b2                	slli	a5,a5,0xc
    8020250c:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    80202510:	fd843503          	ld	a0,-40(s0)
    80202514:	00000097          	auipc	ra,0x0
    80202518:	fbc080e7          	jalr	-68(ra) # 802024d0 <free_pagetable>
            pt[i] = 0;
    8020251c:	fec42783          	lw	a5,-20(s0)
    80202520:	078e                	slli	a5,a5,0x3
    80202522:	fc843703          	ld	a4,-56(s0)
    80202526:	97ba                	add	a5,a5,a4
    80202528:	0007b023          	sd	zero,0(a5) # ffffffff80000000 <_bss_end+0xfffffffeffdd8910>
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    8020252c:	a00d                	j	8020254e <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    8020252e:	fe043783          	ld	a5,-32(s0)
    80202532:	8b85                	andi	a5,a5,1
    80202534:	cf89                	beqz	a5,8020254e <free_pagetable+0x7e>
    80202536:	fe043783          	ld	a5,-32(s0)
    8020253a:	8bb9                	andi	a5,a5,14
    8020253c:	cb89                	beqz	a5,8020254e <free_pagetable+0x7e>
            pt[i] = 0;
    8020253e:	fec42783          	lw	a5,-20(s0)
    80202542:	078e                	slli	a5,a5,0x3
    80202544:	fc843703          	ld	a4,-56(s0)
    80202548:	97ba                	add	a5,a5,a4
    8020254a:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    8020254e:	fec42783          	lw	a5,-20(s0)
    80202552:	2785                	addiw	a5,a5,1
    80202554:	fef42623          	sw	a5,-20(s0)
    80202558:	fec42783          	lw	a5,-20(s0)
    8020255c:	0007871b          	sext.w	a4,a5
    80202560:	1ff00793          	li	a5,511
    80202564:	f6e7dfe3          	bge	a5,a4,802024e2 <free_pagetable+0x12>
    free_page(pt);
    80202568:	fc843503          	ld	a0,-56(s0)
    8020256c:	00001097          	auipc	ra,0x1
    80202570:	d98080e7          	jalr	-616(ra) # 80203304 <free_page>
}
    80202574:	0001                	nop
    80202576:	70e2                	ld	ra,56(sp)
    80202578:	7442                	ld	s0,48(sp)
    8020257a:	6121                	addi	sp,sp,64
    8020257c:	8082                	ret

000000008020257e <kvmmake>:
static pagetable_t kvmmake(void) {
    8020257e:	715d                	addi	sp,sp,-80
    80202580:	e486                	sd	ra,72(sp)
    80202582:	e0a2                	sd	s0,64(sp)
    80202584:	0880                	addi	s0,sp,80
    pagetable_t kpgtbl = create_pagetable();
    80202586:	00000097          	auipc	ra,0x0
    8020258a:	b66080e7          	jalr	-1178(ra) # 802020ec <create_pagetable>
    8020258e:	fca43423          	sd	a0,-56(s0)
    if (!kpgtbl){
    80202592:	fc843783          	ld	a5,-56(s0)
    80202596:	eb89                	bnez	a5,802025a8 <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    80202598:	00011517          	auipc	a0,0x11
    8020259c:	a5850513          	addi	a0,a0,-1448 # 80212ff0 <user_test_table+0x1e0>
    802025a0:	fffff097          	auipc	ra,0xfffff
    802025a4:	1b2080e7          	jalr	434(ra) # 80201752 <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    802025a8:	4785                	li	a5,1
    802025aa:	07fe                	slli	a5,a5,0x1f
    802025ac:	fef43423          	sd	a5,-24(s0)
    802025b0:	a8a1                	j	80202608 <kvmmake+0x8a>
        int perm = PTE_R | PTE_W;
    802025b2:	4799                	li	a5,6
    802025b4:	fef42223          	sw	a5,-28(s0)
        if (pa < (uint64)etext)
    802025b8:	00006797          	auipc	a5,0x6
    802025bc:	a4878793          	addi	a5,a5,-1464 # 80208000 <etext>
    802025c0:	fe843703          	ld	a4,-24(s0)
    802025c4:	00f77563          	bgeu	a4,a5,802025ce <kvmmake+0x50>
            perm = PTE_R | PTE_X;
    802025c8:	47a9                	li	a5,10
    802025ca:	fef42223          	sw	a5,-28(s0)
        if (map_page(kpgtbl, pa, pa, perm) != 0)
    802025ce:	fe442783          	lw	a5,-28(s0)
    802025d2:	86be                	mv	a3,a5
    802025d4:	fe843603          	ld	a2,-24(s0)
    802025d8:	fe843583          	ld	a1,-24(s0)
    802025dc:	fc843503          	ld	a0,-56(s0)
    802025e0:	00000097          	auipc	ra,0x0
    802025e4:	d7c080e7          	jalr	-644(ra) # 8020235c <map_page>
    802025e8:	87aa                	mv	a5,a0
    802025ea:	cb89                	beqz	a5,802025fc <kvmmake+0x7e>
            panic("kvmmake: heap map failed");
    802025ec:	00011517          	auipc	a0,0x11
    802025f0:	a1c50513          	addi	a0,a0,-1508 # 80213008 <user_test_table+0x1f8>
    802025f4:	fffff097          	auipc	ra,0xfffff
    802025f8:	15e080e7          	jalr	350(ra) # 80201752 <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    802025fc:	fe843703          	ld	a4,-24(s0)
    80202600:	6785                	lui	a5,0x1
    80202602:	97ba                	add	a5,a5,a4
    80202604:	fef43423          	sd	a5,-24(s0)
    80202608:	fe843703          	ld	a4,-24(s0)
    8020260c:	47c5                	li	a5,17
    8020260e:	07ee                	slli	a5,a5,0x1b
    80202610:	faf761e3          	bltu	a4,a5,802025b2 <kvmmake+0x34>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    80202614:	4699                	li	a3,6
    80202616:	10000637          	lui	a2,0x10000
    8020261a:	100005b7          	lui	a1,0x10000
    8020261e:	fc843503          	ld	a0,-56(s0)
    80202622:	00000097          	auipc	ra,0x0
    80202626:	d3a080e7          	jalr	-710(ra) # 8020235c <map_page>
    8020262a:	87aa                	mv	a5,a0
    8020262c:	cb89                	beqz	a5,8020263e <kvmmake+0xc0>
        panic("kvmmake: uart map failed");
    8020262e:	00011517          	auipc	a0,0x11
    80202632:	9fa50513          	addi	a0,a0,-1542 # 80213028 <user_test_table+0x218>
    80202636:	fffff097          	auipc	ra,0xfffff
    8020263a:	11c080e7          	jalr	284(ra) # 80201752 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    8020263e:	0c0007b7          	lui	a5,0xc000
    80202642:	fcf43c23          	sd	a5,-40(s0)
    80202646:	a825                	j	8020267e <kvmmake+0x100>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202648:	4699                	li	a3,6
    8020264a:	fd843603          	ld	a2,-40(s0)
    8020264e:	fd843583          	ld	a1,-40(s0)
    80202652:	fc843503          	ld	a0,-56(s0)
    80202656:	00000097          	auipc	ra,0x0
    8020265a:	d06080e7          	jalr	-762(ra) # 8020235c <map_page>
    8020265e:	87aa                	mv	a5,a0
    80202660:	cb89                	beqz	a5,80202672 <kvmmake+0xf4>
            panic("kvmmake: plic map failed");
    80202662:	00011517          	auipc	a0,0x11
    80202666:	9e650513          	addi	a0,a0,-1562 # 80213048 <user_test_table+0x238>
    8020266a:	fffff097          	auipc	ra,0xfffff
    8020266e:	0e8080e7          	jalr	232(ra) # 80201752 <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80202672:	fd843703          	ld	a4,-40(s0)
    80202676:	6785                	lui	a5,0x1
    80202678:	97ba                	add	a5,a5,a4
    8020267a:	fcf43c23          	sd	a5,-40(s0)
    8020267e:	fd843703          	ld	a4,-40(s0)
    80202682:	0c4007b7          	lui	a5,0xc400
    80202686:	fcf761e3          	bltu	a4,a5,80202648 <kvmmake+0xca>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    8020268a:	020007b7          	lui	a5,0x2000
    8020268e:	fcf43823          	sd	a5,-48(s0)
    80202692:	a825                	j	802026ca <kvmmake+0x14c>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202694:	4699                	li	a3,6
    80202696:	fd043603          	ld	a2,-48(s0)
    8020269a:	fd043583          	ld	a1,-48(s0)
    8020269e:	fc843503          	ld	a0,-56(s0)
    802026a2:	00000097          	auipc	ra,0x0
    802026a6:	cba080e7          	jalr	-838(ra) # 8020235c <map_page>
    802026aa:	87aa                	mv	a5,a0
    802026ac:	cb89                	beqz	a5,802026be <kvmmake+0x140>
            panic("kvmmake: clint map failed");
    802026ae:	00011517          	auipc	a0,0x11
    802026b2:	9ba50513          	addi	a0,a0,-1606 # 80213068 <user_test_table+0x258>
    802026b6:	fffff097          	auipc	ra,0xfffff
    802026ba:	09c080e7          	jalr	156(ra) # 80201752 <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    802026be:	fd043703          	ld	a4,-48(s0)
    802026c2:	6785                	lui	a5,0x1
    802026c4:	97ba                	add	a5,a5,a4
    802026c6:	fcf43823          	sd	a5,-48(s0)
    802026ca:	fd043703          	ld	a4,-48(s0)
    802026ce:	020107b7          	lui	a5,0x2010
    802026d2:	fcf761e3          	bltu	a4,a5,80202694 <kvmmake+0x116>
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    802026d6:	4699                	li	a3,6
    802026d8:	10001637          	lui	a2,0x10001
    802026dc:	100015b7          	lui	a1,0x10001
    802026e0:	fc843503          	ld	a0,-56(s0)
    802026e4:	00000097          	auipc	ra,0x0
    802026e8:	c78080e7          	jalr	-904(ra) # 8020235c <map_page>
    802026ec:	87aa                	mv	a5,a0
    802026ee:	cb89                	beqz	a5,80202700 <kvmmake+0x182>
        panic("kvmmake: virtio map failed");
    802026f0:	00011517          	auipc	a0,0x11
    802026f4:	99850513          	addi	a0,a0,-1640 # 80213088 <user_test_table+0x278>
    802026f8:	fffff097          	auipc	ra,0xfffff
    802026fc:	05a080e7          	jalr	90(ra) # 80201752 <panic>
	void *tramp_phys = alloc_page();
    80202700:	00001097          	auipc	ra,0x1
    80202704:	b98080e7          	jalr	-1128(ra) # 80203298 <alloc_page>
    80202708:	fca43023          	sd	a0,-64(s0)
	if (!tramp_phys)
    8020270c:	fc043783          	ld	a5,-64(s0)
    80202710:	eb89                	bnez	a5,80202722 <kvmmake+0x1a4>
		panic("kvmmake: alloc trampoline page failed");
    80202712:	00011517          	auipc	a0,0x11
    80202716:	99650513          	addi	a0,a0,-1642 # 802130a8 <user_test_table+0x298>
    8020271a:	fffff097          	auipc	ra,0xfffff
    8020271e:	038080e7          	jalr	56(ra) # 80201752 <panic>
	memcpy(tramp_phys, trampoline, PGSIZE);
    80202722:	6605                	lui	a2,0x1
    80202724:	00002597          	auipc	a1,0x2
    80202728:	5ac58593          	addi	a1,a1,1452 # 80204cd0 <trampoline>
    8020272c:	fc043503          	ld	a0,-64(s0)
    80202730:	00000097          	auipc	ra,0x0
    80202734:	86c080e7          	jalr	-1940(ra) # 80201f9c <memcpy>
	void *trapframe_phys = alloc_page();
    80202738:	00001097          	auipc	ra,0x1
    8020273c:	b60080e7          	jalr	-1184(ra) # 80203298 <alloc_page>
    80202740:	faa43c23          	sd	a0,-72(s0)
	if (!trapframe_phys)
    80202744:	fb843783          	ld	a5,-72(s0)
    80202748:	eb89                	bnez	a5,8020275a <kvmmake+0x1dc>
		panic("kvmmake: alloc trapframe page failed");
    8020274a:	00011517          	auipc	a0,0x11
    8020274e:	98650513          	addi	a0,a0,-1658 # 802130d0 <user_test_table+0x2c0>
    80202752:	fffff097          	auipc	ra,0xfffff
    80202756:	000080e7          	jalr	ra # 80201752 <panic>
	memset(trapframe_phys, 0, PGSIZE);
    8020275a:	6605                	lui	a2,0x1
    8020275c:	4581                	li	a1,0
    8020275e:	fb843503          	ld	a0,-72(s0)
    80202762:	fffff097          	auipc	ra,0xfffff
    80202766:	72e080e7          	jalr	1838(ra) # 80201e90 <memset>
	if (map_page(kpgtbl, TRAMPOLINE, (uint64)tramp_phys, PTE_R | PTE_X) != 0){
    8020276a:	fc043783          	ld	a5,-64(s0)
    8020276e:	46a9                	li	a3,10
    80202770:	863e                	mv	a2,a5
    80202772:	75fd                	lui	a1,0xfffff
    80202774:	fc843503          	ld	a0,-56(s0)
    80202778:	00000097          	auipc	ra,0x0
    8020277c:	be4080e7          	jalr	-1052(ra) # 8020235c <map_page>
    80202780:	87aa                	mv	a5,a0
    80202782:	cb89                	beqz	a5,80202794 <kvmmake+0x216>
		panic("kvmmake: trampoline map failed");
    80202784:	00011517          	auipc	a0,0x11
    80202788:	97450513          	addi	a0,a0,-1676 # 802130f8 <user_test_table+0x2e8>
    8020278c:	fffff097          	auipc	ra,0xfffff
    80202790:	fc6080e7          	jalr	-58(ra) # 80201752 <panic>
	if (map_page(kpgtbl, TRAPFRAME, (uint64)trapframe_phys, PTE_R | PTE_W) != 0){
    80202794:	fb843783          	ld	a5,-72(s0)
    80202798:	4699                	li	a3,6
    8020279a:	863e                	mv	a2,a5
    8020279c:	75f9                	lui	a1,0xffffe
    8020279e:	fc843503          	ld	a0,-56(s0)
    802027a2:	00000097          	auipc	ra,0x0
    802027a6:	bba080e7          	jalr	-1094(ra) # 8020235c <map_page>
    802027aa:	87aa                	mv	a5,a0
    802027ac:	cb89                	beqz	a5,802027be <kvmmake+0x240>
		panic("kvmmake: trapframe map failed");
    802027ae:	00011517          	auipc	a0,0x11
    802027b2:	96a50513          	addi	a0,a0,-1686 # 80213118 <user_test_table+0x308>
    802027b6:	fffff097          	auipc	ra,0xfffff
    802027ba:	f9c080e7          	jalr	-100(ra) # 80201752 <panic>
	trampoline_phys_addr = (uint64)tramp_phys;
    802027be:	fc043703          	ld	a4,-64(s0)
    802027c2:	00025797          	auipc	a5,0x25
    802027c6:	8d678793          	addi	a5,a5,-1834 # 80227098 <trampoline_phys_addr>
    802027ca:	e398                	sd	a4,0(a5)
	trapframe_phys_addr = (uint64)trapframe_phys;
    802027cc:	fb843703          	ld	a4,-72(s0)
    802027d0:	00025797          	auipc	a5,0x25
    802027d4:	8d078793          	addi	a5,a5,-1840 # 802270a0 <trapframe_phys_addr>
    802027d8:	e398                	sd	a4,0(a5)
	printf("trampoline_phy_addr = %lx\n",trampoline_phys_addr);
    802027da:	00025797          	auipc	a5,0x25
    802027de:	8be78793          	addi	a5,a5,-1858 # 80227098 <trampoline_phys_addr>
    802027e2:	639c                	ld	a5,0(a5)
    802027e4:	85be                	mv	a1,a5
    802027e6:	00011517          	auipc	a0,0x11
    802027ea:	95250513          	addi	a0,a0,-1710 # 80213138 <user_test_table+0x328>
    802027ee:	ffffe097          	auipc	ra,0xffffe
    802027f2:	518080e7          	jalr	1304(ra) # 80200d06 <printf>
	printf("trapframe_phys_addr = %lx\n",trapframe_phys_addr);
    802027f6:	00025797          	auipc	a5,0x25
    802027fa:	8aa78793          	addi	a5,a5,-1878 # 802270a0 <trapframe_phys_addr>
    802027fe:	639c                	ld	a5,0(a5)
    80202800:	85be                	mv	a1,a5
    80202802:	00011517          	auipc	a0,0x11
    80202806:	95650513          	addi	a0,a0,-1706 # 80213158 <user_test_table+0x348>
    8020280a:	ffffe097          	auipc	ra,0xffffe
    8020280e:	4fc080e7          	jalr	1276(ra) # 80200d06 <printf>
    return kpgtbl;
    80202812:	fc843783          	ld	a5,-56(s0)
}
    80202816:	853e                	mv	a0,a5
    80202818:	60a6                	ld	ra,72(sp)
    8020281a:	6406                	ld	s0,64(sp)
    8020281c:	6161                	addi	sp,sp,80
    8020281e:	8082                	ret

0000000080202820 <w_satp>:
static inline void w_satp(uint64 x) {
    80202820:	1101                	addi	sp,sp,-32
    80202822:	ec22                	sd	s0,24(sp)
    80202824:	1000                	addi	s0,sp,32
    80202826:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    8020282a:	fe843783          	ld	a5,-24(s0)
    8020282e:	18079073          	csrw	satp,a5
}
    80202832:	0001                	nop
    80202834:	6462                	ld	s0,24(sp)
    80202836:	6105                	addi	sp,sp,32
    80202838:	8082                	ret

000000008020283a <sfence_vma>:
inline void sfence_vma(void) {
    8020283a:	1141                	addi	sp,sp,-16
    8020283c:	e422                	sd	s0,8(sp)
    8020283e:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    80202840:	12000073          	sfence.vma
}
    80202844:	0001                	nop
    80202846:	6422                	ld	s0,8(sp)
    80202848:	0141                	addi	sp,sp,16
    8020284a:	8082                	ret

000000008020284c <kvminit>:
void kvminit(void) {
    8020284c:	1141                	addi	sp,sp,-16
    8020284e:	e406                	sd	ra,8(sp)
    80202850:	e022                	sd	s0,0(sp)
    80202852:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    80202854:	00000097          	auipc	ra,0x0
    80202858:	d2a080e7          	jalr	-726(ra) # 8020257e <kvmmake>
    8020285c:	872a                	mv	a4,a0
    8020285e:	00025797          	auipc	a5,0x25
    80202862:	83278793          	addi	a5,a5,-1998 # 80227090 <kernel_pagetable>
    80202866:	e398                	sd	a4,0(a5)
    sfence_vma();
    80202868:	00000097          	auipc	ra,0x0
    8020286c:	fd2080e7          	jalr	-46(ra) # 8020283a <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    80202870:	00025797          	auipc	a5,0x25
    80202874:	82078793          	addi	a5,a5,-2016 # 80227090 <kernel_pagetable>
    80202878:	639c                	ld	a5,0(a5)
    8020287a:	00c7d713          	srli	a4,a5,0xc
    8020287e:	57fd                	li	a5,-1
    80202880:	17fe                	slli	a5,a5,0x3f
    80202882:	8fd9                	or	a5,a5,a4
    80202884:	853e                	mv	a0,a5
    80202886:	00000097          	auipc	ra,0x0
    8020288a:	f9a080e7          	jalr	-102(ra) # 80202820 <w_satp>
    sfence_vma();
    8020288e:	00000097          	auipc	ra,0x0
    80202892:	fac080e7          	jalr	-84(ra) # 8020283a <sfence_vma>
    printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
    80202896:	00024797          	auipc	a5,0x24
    8020289a:	7fa78793          	addi	a5,a5,2042 # 80227090 <kernel_pagetable>
    8020289e:	639c                	ld	a5,0(a5)
    802028a0:	00c7d713          	srli	a4,a5,0xc
    802028a4:	57fd                	li	a5,-1
    802028a6:	17fe                	slli	a5,a5,0x3f
    802028a8:	8fd9                	or	a5,a5,a4
    802028aa:	85be                	mv	a1,a5
    802028ac:	00011517          	auipc	a0,0x11
    802028b0:	8cc50513          	addi	a0,a0,-1844 # 80213178 <user_test_table+0x368>
    802028b4:	ffffe097          	auipc	ra,0xffffe
    802028b8:	452080e7          	jalr	1106(ra) # 80200d06 <printf>
}
    802028bc:	0001                	nop
    802028be:	60a2                	ld	ra,8(sp)
    802028c0:	6402                	ld	s0,0(sp)
    802028c2:	0141                	addi	sp,sp,16
    802028c4:	8082                	ret

00000000802028c6 <get_current_pagetable>:
pagetable_t get_current_pagetable(void) {
    802028c6:	1141                	addi	sp,sp,-16
    802028c8:	e422                	sd	s0,8(sp)
    802028ca:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    802028cc:	00024797          	auipc	a5,0x24
    802028d0:	7c478793          	addi	a5,a5,1988 # 80227090 <kernel_pagetable>
    802028d4:	639c                	ld	a5,0(a5)
}
    802028d6:	853e                	mv	a0,a5
    802028d8:	6422                	ld	s0,8(sp)
    802028da:	0141                	addi	sp,sp,16
    802028dc:	8082                	ret

00000000802028de <print_pagetable>:
void print_pagetable(pagetable_t pagetable, int level, uint64 va_base) {
    802028de:	715d                	addi	sp,sp,-80
    802028e0:	e486                	sd	ra,72(sp)
    802028e2:	e0a2                	sd	s0,64(sp)
    802028e4:	0880                	addi	s0,sp,80
    802028e6:	fca43423          	sd	a0,-56(s0)
    802028ea:	87ae                	mv	a5,a1
    802028ec:	fac43c23          	sd	a2,-72(s0)
    802028f0:	fcf42223          	sw	a5,-60(s0)
    for (int i = 0; i < 512; i++) {
    802028f4:	fe042623          	sw	zero,-20(s0)
    802028f8:	a0c5                	j	802029d8 <print_pagetable+0xfa>
        pte_t pte = pagetable[i];
    802028fa:	fec42783          	lw	a5,-20(s0)
    802028fe:	078e                	slli	a5,a5,0x3
    80202900:	fc843703          	ld	a4,-56(s0)
    80202904:	97ba                	add	a5,a5,a4
    80202906:	639c                	ld	a5,0(a5)
    80202908:	fef43023          	sd	a5,-32(s0)
        if (pte & PTE_V) {
    8020290c:	fe043783          	ld	a5,-32(s0)
    80202910:	8b85                	andi	a5,a5,1
    80202912:	cfd5                	beqz	a5,802029ce <print_pagetable+0xf0>
            uint64 pa = PTE2PA(pte);
    80202914:	fe043783          	ld	a5,-32(s0)
    80202918:	83a9                	srli	a5,a5,0xa
    8020291a:	07b2                	slli	a5,a5,0xc
    8020291c:	fcf43c23          	sd	a5,-40(s0)
            uint64 va = va_base + (i << (12 + 9 * (2 - level)));
    80202920:	4789                	li	a5,2
    80202922:	fc442703          	lw	a4,-60(s0)
    80202926:	9f99                	subw	a5,a5,a4
    80202928:	2781                	sext.w	a5,a5
    8020292a:	873e                	mv	a4,a5
    8020292c:	87ba                	mv	a5,a4
    8020292e:	0037979b          	slliw	a5,a5,0x3
    80202932:	9fb9                	addw	a5,a5,a4
    80202934:	2781                	sext.w	a5,a5
    80202936:	27b1                	addiw	a5,a5,12
    80202938:	2781                	sext.w	a5,a5
    8020293a:	fec42703          	lw	a4,-20(s0)
    8020293e:	00f717bb          	sllw	a5,a4,a5
    80202942:	2781                	sext.w	a5,a5
    80202944:	873e                	mv	a4,a5
    80202946:	fb843783          	ld	a5,-72(s0)
    8020294a:	97ba                	add	a5,a5,a4
    8020294c:	fcf43823          	sd	a5,-48(s0)
            for (int l = 0; l < level; l++) printf("  "); // 缩进
    80202950:	fe042423          	sw	zero,-24(s0)
    80202954:	a831                	j	80202970 <print_pagetable+0x92>
    80202956:	00011517          	auipc	a0,0x11
    8020295a:	85250513          	addi	a0,a0,-1966 # 802131a8 <user_test_table+0x398>
    8020295e:	ffffe097          	auipc	ra,0xffffe
    80202962:	3a8080e7          	jalr	936(ra) # 80200d06 <printf>
    80202966:	fe842783          	lw	a5,-24(s0)
    8020296a:	2785                	addiw	a5,a5,1
    8020296c:	fef42423          	sw	a5,-24(s0)
    80202970:	fe842783          	lw	a5,-24(s0)
    80202974:	873e                	mv	a4,a5
    80202976:	fc442783          	lw	a5,-60(s0)
    8020297a:	2701                	sext.w	a4,a4
    8020297c:	2781                	sext.w	a5,a5
    8020297e:	fcf74ce3          	blt	a4,a5,80202956 <print_pagetable+0x78>
            printf("L%d[%3d] VA:0x%lx -> PA:0x%lx flags:0x%lx\n", level, i, va, pa, pte & 0x3FF);
    80202982:	fe043783          	ld	a5,-32(s0)
    80202986:	3ff7f793          	andi	a5,a5,1023
    8020298a:	fec42603          	lw	a2,-20(s0)
    8020298e:	fc442583          	lw	a1,-60(s0)
    80202992:	fd843703          	ld	a4,-40(s0)
    80202996:	fd043683          	ld	a3,-48(s0)
    8020299a:	00011517          	auipc	a0,0x11
    8020299e:	81650513          	addi	a0,a0,-2026 # 802131b0 <user_test_table+0x3a0>
    802029a2:	ffffe097          	auipc	ra,0xffffe
    802029a6:	364080e7          	jalr	868(ra) # 80200d06 <printf>
            if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // 不是叶子
    802029aa:	fe043783          	ld	a5,-32(s0)
    802029ae:	8bb9                	andi	a5,a5,14
    802029b0:	ef99                	bnez	a5,802029ce <print_pagetable+0xf0>
                print_pagetable((pagetable_t)pa, level + 1, va);
    802029b2:	fd843783          	ld	a5,-40(s0)
    802029b6:	fc442703          	lw	a4,-60(s0)
    802029ba:	2705                	addiw	a4,a4,1
    802029bc:	2701                	sext.w	a4,a4
    802029be:	fd043603          	ld	a2,-48(s0)
    802029c2:	85ba                	mv	a1,a4
    802029c4:	853e                	mv	a0,a5
    802029c6:	00000097          	auipc	ra,0x0
    802029ca:	f18080e7          	jalr	-232(ra) # 802028de <print_pagetable>
    for (int i = 0; i < 512; i++) {
    802029ce:	fec42783          	lw	a5,-20(s0)
    802029d2:	2785                	addiw	a5,a5,1
    802029d4:	fef42623          	sw	a5,-20(s0)
    802029d8:	fec42783          	lw	a5,-20(s0)
    802029dc:	0007871b          	sext.w	a4,a5
    802029e0:	1ff00793          	li	a5,511
    802029e4:	f0e7dbe3          	bge	a5,a4,802028fa <print_pagetable+0x1c>
}
    802029e8:	0001                	nop
    802029ea:	0001                	nop
    802029ec:	60a6                	ld	ra,72(sp)
    802029ee:	6406                	ld	s0,64(sp)
    802029f0:	6161                	addi	sp,sp,80
    802029f2:	8082                	ret

00000000802029f4 <handle_page_fault>:
int handle_page_fault(uint64 va, int type) {
    802029f4:	715d                	addi	sp,sp,-80
    802029f6:	e486                	sd	ra,72(sp)
    802029f8:	e0a2                	sd	s0,64(sp)
    802029fa:	0880                	addi	s0,sp,80
    802029fc:	faa43c23          	sd	a0,-72(s0)
    80202a00:	87ae                	mv	a5,a1
    80202a02:	faf42a23          	sw	a5,-76(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    80202a06:	fb442783          	lw	a5,-76(s0)
    80202a0a:	863e                	mv	a2,a5
    80202a0c:	fb843583          	ld	a1,-72(s0)
    80202a10:	00010517          	auipc	a0,0x10
    80202a14:	7d050513          	addi	a0,a0,2000 # 802131e0 <user_test_table+0x3d0>
    80202a18:	ffffe097          	auipc	ra,0xffffe
    80202a1c:	2ee080e7          	jalr	750(ra) # 80200d06 <printf>
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    80202a20:	fb843703          	ld	a4,-72(s0)
    80202a24:	77fd                	lui	a5,0xfffff
    80202a26:	8ff9                	and	a5,a5,a4
    80202a28:	fcf43c23          	sd	a5,-40(s0)
    if (page_va >= MAXVA) {
    80202a2c:	fd843703          	ld	a4,-40(s0)
    80202a30:	57fd                	li	a5,-1
    80202a32:	83e5                	srli	a5,a5,0x19
    80202a34:	00e7fc63          	bgeu	a5,a4,80202a4c <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    80202a38:	00010517          	auipc	a0,0x10
    80202a3c:	7d850513          	addi	a0,a0,2008 # 80213210 <user_test_table+0x400>
    80202a40:	ffffe097          	auipc	ra,0xffffe
    80202a44:	2c6080e7          	jalr	710(ra) # 80200d06 <printf>
        return 0;
    80202a48:	4781                	li	a5,0
    80202a4a:	aae9                	j	80202c24 <handle_page_fault+0x230>
    struct proc *p = myproc();
    80202a4c:	00002097          	auipc	ra,0x2
    80202a50:	544080e7          	jalr	1348(ra) # 80204f90 <myproc>
    80202a54:	fca43823          	sd	a0,-48(s0)
    pagetable_t pt = kernel_pagetable;
    80202a58:	00024797          	auipc	a5,0x24
    80202a5c:	63878793          	addi	a5,a5,1592 # 80227090 <kernel_pagetable>
    80202a60:	639c                	ld	a5,0(a5)
    80202a62:	fef43423          	sd	a5,-24(s0)
    if (p && p->pagetable && p->is_user) {
    80202a66:	fd043783          	ld	a5,-48(s0)
    80202a6a:	cf99                	beqz	a5,80202a88 <handle_page_fault+0x94>
    80202a6c:	fd043783          	ld	a5,-48(s0)
    80202a70:	7fdc                	ld	a5,184(a5)
    80202a72:	cb99                	beqz	a5,80202a88 <handle_page_fault+0x94>
    80202a74:	fd043783          	ld	a5,-48(s0)
    80202a78:	0a87a783          	lw	a5,168(a5)
    80202a7c:	c791                	beqz	a5,80202a88 <handle_page_fault+0x94>
        pt = p->pagetable;
    80202a7e:	fd043783          	ld	a5,-48(s0)
    80202a82:	7fdc                	ld	a5,184(a5)
    80202a84:	fef43423          	sd	a5,-24(s0)
    pte_t *pte = walk_lookup(pt, page_va);
    80202a88:	fd843583          	ld	a1,-40(s0)
    80202a8c:	fe843503          	ld	a0,-24(s0)
    80202a90:	fffff097          	auipc	ra,0xfffff
    80202a94:	698080e7          	jalr	1688(ra) # 80202128 <walk_lookup>
    80202a98:	fca43423          	sd	a0,-56(s0)
    if (pte && (*pte & PTE_V)) {
    80202a9c:	fc843783          	ld	a5,-56(s0)
    80202aa0:	c3dd                	beqz	a5,80202b46 <handle_page_fault+0x152>
    80202aa2:	fc843783          	ld	a5,-56(s0)
    80202aa6:	639c                	ld	a5,0(a5)
    80202aa8:	8b85                	andi	a5,a5,1
    80202aaa:	cfd1                	beqz	a5,80202b46 <handle_page_fault+0x152>
        int need_perm = 0;
    80202aac:	fe042223          	sw	zero,-28(s0)
        if (type == 1) need_perm = PTE_X;
    80202ab0:	fb442783          	lw	a5,-76(s0)
    80202ab4:	0007871b          	sext.w	a4,a5
    80202ab8:	4785                	li	a5,1
    80202aba:	00f71663          	bne	a4,a5,80202ac6 <handle_page_fault+0xd2>
    80202abe:	47a1                	li	a5,8
    80202ac0:	fef42223          	sw	a5,-28(s0)
    80202ac4:	a035                	j	80202af0 <handle_page_fault+0xfc>
        else if (type == 2) need_perm = PTE_R;
    80202ac6:	fb442783          	lw	a5,-76(s0)
    80202aca:	0007871b          	sext.w	a4,a5
    80202ace:	4789                	li	a5,2
    80202ad0:	00f71663          	bne	a4,a5,80202adc <handle_page_fault+0xe8>
    80202ad4:	4789                	li	a5,2
    80202ad6:	fef42223          	sw	a5,-28(s0)
    80202ada:	a819                	j	80202af0 <handle_page_fault+0xfc>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    80202adc:	fb442783          	lw	a5,-76(s0)
    80202ae0:	0007871b          	sext.w	a4,a5
    80202ae4:	478d                	li	a5,3
    80202ae6:	00f71563          	bne	a4,a5,80202af0 <handle_page_fault+0xfc>
    80202aea:	4799                	li	a5,6
    80202aec:	fef42223          	sw	a5,-28(s0)
        if ((*pte & need_perm) != need_perm) {
    80202af0:	fc843783          	ld	a5,-56(s0)
    80202af4:	6398                	ld	a4,0(a5)
    80202af6:	fe442783          	lw	a5,-28(s0)
    80202afa:	8f7d                	and	a4,a4,a5
    80202afc:	fe442783          	lw	a5,-28(s0)
    80202b00:	02f70963          	beq	a4,a5,80202b32 <handle_page_fault+0x13e>
            *pte |= need_perm;
    80202b04:	fc843783          	ld	a5,-56(s0)
    80202b08:	6398                	ld	a4,0(a5)
    80202b0a:	fe442783          	lw	a5,-28(s0)
    80202b0e:	8f5d                	or	a4,a4,a5
    80202b10:	fc843783          	ld	a5,-56(s0)
    80202b14:	e398                	sd	a4,0(a5)
            sfence_vma();
    80202b16:	00000097          	auipc	ra,0x0
    80202b1a:	d24080e7          	jalr	-732(ra) # 8020283a <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    80202b1e:	00010517          	auipc	a0,0x10
    80202b22:	71a50513          	addi	a0,a0,1818 # 80213238 <user_test_table+0x428>
    80202b26:	ffffe097          	auipc	ra,0xffffe
    80202b2a:	1e0080e7          	jalr	480(ra) # 80200d06 <printf>
            return 1;
    80202b2e:	4785                	li	a5,1
    80202b30:	a8d5                	j	80202c24 <handle_page_fault+0x230>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80202b32:	00010517          	auipc	a0,0x10
    80202b36:	72e50513          	addi	a0,a0,1838 # 80213260 <user_test_table+0x450>
    80202b3a:	ffffe097          	auipc	ra,0xffffe
    80202b3e:	1cc080e7          	jalr	460(ra) # 80200d06 <printf>
        return 1;
    80202b42:	4785                	li	a5,1
    80202b44:	a0c5                	j	80202c24 <handle_page_fault+0x230>
    void* page = alloc_page();
    80202b46:	00000097          	auipc	ra,0x0
    80202b4a:	752080e7          	jalr	1874(ra) # 80203298 <alloc_page>
    80202b4e:	fca43023          	sd	a0,-64(s0)
    if (page == 0) {
    80202b52:	fc043783          	ld	a5,-64(s0)
    80202b56:	eb99                	bnez	a5,80202b6c <handle_page_fault+0x178>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    80202b58:	00010517          	auipc	a0,0x10
    80202b5c:	73850513          	addi	a0,a0,1848 # 80213290 <user_test_table+0x480>
    80202b60:	ffffe097          	auipc	ra,0xffffe
    80202b64:	1a6080e7          	jalr	422(ra) # 80200d06 <printf>
        return 0;
    80202b68:	4781                	li	a5,0
    80202b6a:	a86d                	j	80202c24 <handle_page_fault+0x230>
    memset(page, 0, PGSIZE);
    80202b6c:	6605                	lui	a2,0x1
    80202b6e:	4581                	li	a1,0
    80202b70:	fc043503          	ld	a0,-64(s0)
    80202b74:	fffff097          	auipc	ra,0xfffff
    80202b78:	31c080e7          	jalr	796(ra) # 80201e90 <memset>
    int perm = 0;
    80202b7c:	fe042023          	sw	zero,-32(s0)
    if (type == 1) perm = PTE_X | PTE_R | PTE_U;
    80202b80:	fb442783          	lw	a5,-76(s0)
    80202b84:	0007871b          	sext.w	a4,a5
    80202b88:	4785                	li	a5,1
    80202b8a:	00f71663          	bne	a4,a5,80202b96 <handle_page_fault+0x1a2>
    80202b8e:	47e9                	li	a5,26
    80202b90:	fef42023          	sw	a5,-32(s0)
    80202b94:	a035                	j	80202bc0 <handle_page_fault+0x1cc>
    else if (type == 2) perm = PTE_R | PTE_U;
    80202b96:	fb442783          	lw	a5,-76(s0)
    80202b9a:	0007871b          	sext.w	a4,a5
    80202b9e:	4789                	li	a5,2
    80202ba0:	00f71663          	bne	a4,a5,80202bac <handle_page_fault+0x1b8>
    80202ba4:	47c9                	li	a5,18
    80202ba6:	fef42023          	sw	a5,-32(s0)
    80202baa:	a819                	j	80202bc0 <handle_page_fault+0x1cc>
    else if (type == 3) perm = PTE_R | PTE_W | PTE_U;
    80202bac:	fb442783          	lw	a5,-76(s0)
    80202bb0:	0007871b          	sext.w	a4,a5
    80202bb4:	478d                	li	a5,3
    80202bb6:	00f71563          	bne	a4,a5,80202bc0 <handle_page_fault+0x1cc>
    80202bba:	47d9                	li	a5,22
    80202bbc:	fef42023          	sw	a5,-32(s0)
    if (map_page(pt, page_va, (uint64)page, perm) != 0) {
    80202bc0:	fc043783          	ld	a5,-64(s0)
    80202bc4:	fe042703          	lw	a4,-32(s0)
    80202bc8:	86ba                	mv	a3,a4
    80202bca:	863e                	mv	a2,a5
    80202bcc:	fd843583          	ld	a1,-40(s0)
    80202bd0:	fe843503          	ld	a0,-24(s0)
    80202bd4:	fffff097          	auipc	ra,0xfffff
    80202bd8:	788080e7          	jalr	1928(ra) # 8020235c <map_page>
    80202bdc:	87aa                	mv	a5,a0
    80202bde:	c38d                	beqz	a5,80202c00 <handle_page_fault+0x20c>
        free_page(page);
    80202be0:	fc043503          	ld	a0,-64(s0)
    80202be4:	00000097          	auipc	ra,0x0
    80202be8:	720080e7          	jalr	1824(ra) # 80203304 <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    80202bec:	00010517          	auipc	a0,0x10
    80202bf0:	6d450513          	addi	a0,a0,1748 # 802132c0 <user_test_table+0x4b0>
    80202bf4:	ffffe097          	auipc	ra,0xffffe
    80202bf8:	112080e7          	jalr	274(ra) # 80200d06 <printf>
        return 0;
    80202bfc:	4781                	li	a5,0
    80202bfe:	a01d                	j	80202c24 <handle_page_fault+0x230>
    sfence_vma();
    80202c00:	00000097          	auipc	ra,0x0
    80202c04:	c3a080e7          	jalr	-966(ra) # 8020283a <sfence_vma>
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    80202c08:	fc043783          	ld	a5,-64(s0)
    80202c0c:	863e                	mv	a2,a5
    80202c0e:	fd843583          	ld	a1,-40(s0)
    80202c12:	00010517          	auipc	a0,0x10
    80202c16:	6d650513          	addi	a0,a0,1750 # 802132e8 <user_test_table+0x4d8>
    80202c1a:	ffffe097          	auipc	ra,0xffffe
    80202c1e:	0ec080e7          	jalr	236(ra) # 80200d06 <printf>
    return 1;
    80202c22:	4785                	li	a5,1
}
    80202c24:	853e                	mv	a0,a5
    80202c26:	60a6                	ld	ra,72(sp)
    80202c28:	6406                	ld	s0,64(sp)
    80202c2a:	6161                	addi	sp,sp,80
    80202c2c:	8082                	ret

0000000080202c2e <test_pagetable>:
void test_pagetable(void) {
    80202c2e:	7155                	addi	sp,sp,-208
    80202c30:	e586                	sd	ra,200(sp)
    80202c32:	e1a2                	sd	s0,192(sp)
    80202c34:	fd26                	sd	s1,184(sp)
    80202c36:	f94a                	sd	s2,176(sp)
    80202c38:	f54e                	sd	s3,168(sp)
    80202c3a:	f152                	sd	s4,160(sp)
    80202c3c:	ed56                	sd	s5,152(sp)
    80202c3e:	e95a                	sd	s6,144(sp)
    80202c40:	e55e                	sd	s7,136(sp)
    80202c42:	e162                	sd	s8,128(sp)
    80202c44:	fce6                	sd	s9,120(sp)
    80202c46:	0980                	addi	s0,sp,208
    80202c48:	878a                	mv	a5,sp
    80202c4a:	84be                	mv	s1,a5
    printf("[PT TEST] 创建页表...\n");
    80202c4c:	00010517          	auipc	a0,0x10
    80202c50:	6dc50513          	addi	a0,a0,1756 # 80213328 <user_test_table+0x518>
    80202c54:	ffffe097          	auipc	ra,0xffffe
    80202c58:	0b2080e7          	jalr	178(ra) # 80200d06 <printf>
    pagetable_t pt = create_pagetable();
    80202c5c:	fffff097          	auipc	ra,0xfffff
    80202c60:	490080e7          	jalr	1168(ra) # 802020ec <create_pagetable>
    80202c64:	f8a43423          	sd	a0,-120(s0)
    assert(pt != 0);
    80202c68:	f8843783          	ld	a5,-120(s0)
    80202c6c:	00f037b3          	snez	a5,a5
    80202c70:	0ff7f793          	zext.b	a5,a5
    80202c74:	2781                	sext.w	a5,a5
    80202c76:	853e                	mv	a0,a5
    80202c78:	fffff097          	auipc	ra,0xfffff
    80202c7c:	38a080e7          	jalr	906(ra) # 80202002 <assert>
    printf("[PT TEST] 页表创建通过\n");
    80202c80:	00010517          	auipc	a0,0x10
    80202c84:	6c850513          	addi	a0,a0,1736 # 80213348 <user_test_table+0x538>
    80202c88:	ffffe097          	auipc	ra,0xffffe
    80202c8c:	07e080e7          	jalr	126(ra) # 80200d06 <printf>
    uint64 va[] = {
    80202c90:	00011797          	auipc	a5,0x11
    80202c94:	87878793          	addi	a5,a5,-1928 # 80213508 <user_test_table+0x6f8>
    80202c98:	638c                	ld	a1,0(a5)
    80202c9a:	6790                	ld	a2,8(a5)
    80202c9c:	6b94                	ld	a3,16(a5)
    80202c9e:	6f98                	ld	a4,24(a5)
    80202ca0:	739c                	ld	a5,32(a5)
    80202ca2:	f2b43c23          	sd	a1,-200(s0)
    80202ca6:	f4c43023          	sd	a2,-192(s0)
    80202caa:	f4d43423          	sd	a3,-184(s0)
    80202cae:	f4e43823          	sd	a4,-176(s0)
    80202cb2:	f4f43c23          	sd	a5,-168(s0)
    int n = sizeof(va) / sizeof(va[0]);
    80202cb6:	4795                	li	a5,5
    80202cb8:	f8f42223          	sw	a5,-124(s0)
    uint64 pa[n];
    80202cbc:	f8442783          	lw	a5,-124(s0)
    80202cc0:	873e                	mv	a4,a5
    80202cc2:	177d                	addi	a4,a4,-1
    80202cc4:	f6e43c23          	sd	a4,-136(s0)
    80202cc8:	873e                	mv	a4,a5
    80202cca:	8c3a                	mv	s8,a4
    80202ccc:	4c81                	li	s9,0
    80202cce:	03ac5713          	srli	a4,s8,0x3a
    80202cd2:	006c9a93          	slli	s5,s9,0x6
    80202cd6:	01576ab3          	or	s5,a4,s5
    80202cda:	006c1a13          	slli	s4,s8,0x6
    80202cde:	873e                	mv	a4,a5
    80202ce0:	8b3a                	mv	s6,a4
    80202ce2:	4b81                	li	s7,0
    80202ce4:	03ab5713          	srli	a4,s6,0x3a
    80202ce8:	006b9993          	slli	s3,s7,0x6
    80202cec:	013769b3          	or	s3,a4,s3
    80202cf0:	006b1913          	slli	s2,s6,0x6
    80202cf4:	078e                	slli	a5,a5,0x3
    80202cf6:	07bd                	addi	a5,a5,15
    80202cf8:	8391                	srli	a5,a5,0x4
    80202cfa:	0792                	slli	a5,a5,0x4
    80202cfc:	40f10133          	sub	sp,sp,a5
    80202d00:	878a                	mv	a5,sp
    80202d02:	079d                	addi	a5,a5,7
    80202d04:	838d                	srli	a5,a5,0x3
    80202d06:	078e                	slli	a5,a5,0x3
    80202d08:	f6f43823          	sd	a5,-144(s0)
    for (int i = 0; i < n; i++) {
    80202d0c:	f8042e23          	sw	zero,-100(s0)
    80202d10:	a201                	j	80202e10 <test_pagetable+0x1e2>
        pa[i] = (uint64)alloc_page();
    80202d12:	00000097          	auipc	ra,0x0
    80202d16:	586080e7          	jalr	1414(ra) # 80203298 <alloc_page>
    80202d1a:	87aa                	mv	a5,a0
    80202d1c:	86be                	mv	a3,a5
    80202d1e:	f7043703          	ld	a4,-144(s0)
    80202d22:	f9c42783          	lw	a5,-100(s0)
    80202d26:	078e                	slli	a5,a5,0x3
    80202d28:	97ba                	add	a5,a5,a4
    80202d2a:	e394                	sd	a3,0(a5)
        assert(pa[i]);
    80202d2c:	f7043703          	ld	a4,-144(s0)
    80202d30:	f9c42783          	lw	a5,-100(s0)
    80202d34:	078e                	slli	a5,a5,0x3
    80202d36:	97ba                	add	a5,a5,a4
    80202d38:	639c                	ld	a5,0(a5)
    80202d3a:	2781                	sext.w	a5,a5
    80202d3c:	853e                	mv	a0,a5
    80202d3e:	fffff097          	auipc	ra,0xfffff
    80202d42:	2c4080e7          	jalr	708(ra) # 80202002 <assert>
        printf("[PT TEST] 分配物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202d46:	f7043703          	ld	a4,-144(s0)
    80202d4a:	f9c42783          	lw	a5,-100(s0)
    80202d4e:	078e                	slli	a5,a5,0x3
    80202d50:	97ba                	add	a5,a5,a4
    80202d52:	6398                	ld	a4,0(a5)
    80202d54:	f9c42783          	lw	a5,-100(s0)
    80202d58:	863a                	mv	a2,a4
    80202d5a:	85be                	mv	a1,a5
    80202d5c:	00010517          	auipc	a0,0x10
    80202d60:	60c50513          	addi	a0,a0,1548 # 80213368 <user_test_table+0x558>
    80202d64:	ffffe097          	auipc	ra,0xffffe
    80202d68:	fa2080e7          	jalr	-94(ra) # 80200d06 <printf>
        int ret = map_page(pt, va[i], pa[i], PTE_R | PTE_W);
    80202d6c:	f9c42783          	lw	a5,-100(s0)
    80202d70:	078e                	slli	a5,a5,0x3
    80202d72:	fa078793          	addi	a5,a5,-96
    80202d76:	97a2                	add	a5,a5,s0
    80202d78:	f987b583          	ld	a1,-104(a5)
    80202d7c:	f7043703          	ld	a4,-144(s0)
    80202d80:	f9c42783          	lw	a5,-100(s0)
    80202d84:	078e                	slli	a5,a5,0x3
    80202d86:	97ba                	add	a5,a5,a4
    80202d88:	639c                	ld	a5,0(a5)
    80202d8a:	4699                	li	a3,6
    80202d8c:	863e                	mv	a2,a5
    80202d8e:	f8843503          	ld	a0,-120(s0)
    80202d92:	fffff097          	auipc	ra,0xfffff
    80202d96:	5ca080e7          	jalr	1482(ra) # 8020235c <map_page>
    80202d9a:	87aa                	mv	a5,a0
    80202d9c:	f6f42223          	sw	a5,-156(s0)
        printf("[PT TEST] 映射 va=0x%lx -> pa=0x%lx %s\n", va[i], pa[i], ret == 0 ? "成功" : "失败");
    80202da0:	f9c42783          	lw	a5,-100(s0)
    80202da4:	078e                	slli	a5,a5,0x3
    80202da6:	fa078793          	addi	a5,a5,-96
    80202daa:	97a2                	add	a5,a5,s0
    80202dac:	f987b583          	ld	a1,-104(a5)
    80202db0:	f7043703          	ld	a4,-144(s0)
    80202db4:	f9c42783          	lw	a5,-100(s0)
    80202db8:	078e                	slli	a5,a5,0x3
    80202dba:	97ba                	add	a5,a5,a4
    80202dbc:	6398                	ld	a4,0(a5)
    80202dbe:	f6442783          	lw	a5,-156(s0)
    80202dc2:	2781                	sext.w	a5,a5
    80202dc4:	e791                	bnez	a5,80202dd0 <test_pagetable+0x1a2>
    80202dc6:	00010797          	auipc	a5,0x10
    80202dca:	5ca78793          	addi	a5,a5,1482 # 80213390 <user_test_table+0x580>
    80202dce:	a029                	j	80202dd8 <test_pagetable+0x1aa>
    80202dd0:	00010797          	auipc	a5,0x10
    80202dd4:	5c878793          	addi	a5,a5,1480 # 80213398 <user_test_table+0x588>
    80202dd8:	86be                	mv	a3,a5
    80202dda:	863a                	mv	a2,a4
    80202ddc:	00010517          	auipc	a0,0x10
    80202de0:	5c450513          	addi	a0,a0,1476 # 802133a0 <user_test_table+0x590>
    80202de4:	ffffe097          	auipc	ra,0xffffe
    80202de8:	f22080e7          	jalr	-222(ra) # 80200d06 <printf>
        assert(ret == 0);
    80202dec:	f6442783          	lw	a5,-156(s0)
    80202df0:	2781                	sext.w	a5,a5
    80202df2:	0017b793          	seqz	a5,a5
    80202df6:	0ff7f793          	zext.b	a5,a5
    80202dfa:	2781                	sext.w	a5,a5
    80202dfc:	853e                	mv	a0,a5
    80202dfe:	fffff097          	auipc	ra,0xfffff
    80202e02:	204080e7          	jalr	516(ra) # 80202002 <assert>
    for (int i = 0; i < n; i++) {
    80202e06:	f9c42783          	lw	a5,-100(s0)
    80202e0a:	2785                	addiw	a5,a5,1
    80202e0c:	f8f42e23          	sw	a5,-100(s0)
    80202e10:	f9c42783          	lw	a5,-100(s0)
    80202e14:	873e                	mv	a4,a5
    80202e16:	f8442783          	lw	a5,-124(s0)
    80202e1a:	2701                	sext.w	a4,a4
    80202e1c:	2781                	sext.w	a5,a5
    80202e1e:	eef74ae3          	blt	a4,a5,80202d12 <test_pagetable+0xe4>
    printf("[PT TEST] 多级映射测试通过\n");
    80202e22:	00010517          	auipc	a0,0x10
    80202e26:	5ae50513          	addi	a0,a0,1454 # 802133d0 <user_test_table+0x5c0>
    80202e2a:	ffffe097          	auipc	ra,0xffffe
    80202e2e:	edc080e7          	jalr	-292(ra) # 80200d06 <printf>
    for (int i = 0; i < n; i++) {
    80202e32:	f8042c23          	sw	zero,-104(s0)
    80202e36:	a861                	j	80202ece <test_pagetable+0x2a0>
        pte_t *pte = walk_lookup(pt, va[i]);
    80202e38:	f9842783          	lw	a5,-104(s0)
    80202e3c:	078e                	slli	a5,a5,0x3
    80202e3e:	fa078793          	addi	a5,a5,-96
    80202e42:	97a2                	add	a5,a5,s0
    80202e44:	f987b783          	ld	a5,-104(a5)
    80202e48:	85be                	mv	a1,a5
    80202e4a:	f8843503          	ld	a0,-120(s0)
    80202e4e:	fffff097          	auipc	ra,0xfffff
    80202e52:	2da080e7          	jalr	730(ra) # 80202128 <walk_lookup>
    80202e56:	f6a43423          	sd	a0,-152(s0)
        if (pte && (*pte & PTE_V)) {
    80202e5a:	f6843783          	ld	a5,-152(s0)
    80202e5e:	c3b1                	beqz	a5,80202ea2 <test_pagetable+0x274>
    80202e60:	f6843783          	ld	a5,-152(s0)
    80202e64:	639c                	ld	a5,0(a5)
    80202e66:	8b85                	andi	a5,a5,1
    80202e68:	cf8d                	beqz	a5,80202ea2 <test_pagetable+0x274>
            printf("[PT TEST] 检查映射: va=0x%lx -> pa=0x%lx, pte=0x%lx\n", va[i], PTE2PA(*pte), *pte);
    80202e6a:	f9842783          	lw	a5,-104(s0)
    80202e6e:	078e                	slli	a5,a5,0x3
    80202e70:	fa078793          	addi	a5,a5,-96
    80202e74:	97a2                	add	a5,a5,s0
    80202e76:	f987b703          	ld	a4,-104(a5)
    80202e7a:	f6843783          	ld	a5,-152(s0)
    80202e7e:	639c                	ld	a5,0(a5)
    80202e80:	83a9                	srli	a5,a5,0xa
    80202e82:	00c79613          	slli	a2,a5,0xc
    80202e86:	f6843783          	ld	a5,-152(s0)
    80202e8a:	639c                	ld	a5,0(a5)
    80202e8c:	86be                	mv	a3,a5
    80202e8e:	85ba                	mv	a1,a4
    80202e90:	00010517          	auipc	a0,0x10
    80202e94:	56850513          	addi	a0,a0,1384 # 802133f8 <user_test_table+0x5e8>
    80202e98:	ffffe097          	auipc	ra,0xffffe
    80202e9c:	e6e080e7          	jalr	-402(ra) # 80200d06 <printf>
    80202ea0:	a015                	j	80202ec4 <test_pagetable+0x296>
            printf("[PT TEST] 检查映射: va=0x%lx 未映射\n", va[i]);
    80202ea2:	f9842783          	lw	a5,-104(s0)
    80202ea6:	078e                	slli	a5,a5,0x3
    80202ea8:	fa078793          	addi	a5,a5,-96
    80202eac:	97a2                	add	a5,a5,s0
    80202eae:	f987b783          	ld	a5,-104(a5)
    80202eb2:	85be                	mv	a1,a5
    80202eb4:	00010517          	auipc	a0,0x10
    80202eb8:	58450513          	addi	a0,a0,1412 # 80213438 <user_test_table+0x628>
    80202ebc:	ffffe097          	auipc	ra,0xffffe
    80202ec0:	e4a080e7          	jalr	-438(ra) # 80200d06 <printf>
    for (int i = 0; i < n; i++) {
    80202ec4:	f9842783          	lw	a5,-104(s0)
    80202ec8:	2785                	addiw	a5,a5,1
    80202eca:	f8f42c23          	sw	a5,-104(s0)
    80202ece:	f9842783          	lw	a5,-104(s0)
    80202ed2:	873e                	mv	a4,a5
    80202ed4:	f8442783          	lw	a5,-124(s0)
    80202ed8:	2701                	sext.w	a4,a4
    80202eda:	2781                	sext.w	a5,a5
    80202edc:	f4f74ee3          	blt	a4,a5,80202e38 <test_pagetable+0x20a>
    printf("[PT TEST] 打印页表结构（递归）\n");
    80202ee0:	00010517          	auipc	a0,0x10
    80202ee4:	58850513          	addi	a0,a0,1416 # 80213468 <user_test_table+0x658>
    80202ee8:	ffffe097          	auipc	ra,0xffffe
    80202eec:	e1e080e7          	jalr	-482(ra) # 80200d06 <printf>
    print_pagetable(pt, 0, 0);
    80202ef0:	4601                	li	a2,0
    80202ef2:	4581                	li	a1,0
    80202ef4:	f8843503          	ld	a0,-120(s0)
    80202ef8:	00000097          	auipc	ra,0x0
    80202efc:	9e6080e7          	jalr	-1562(ra) # 802028de <print_pagetable>
    for (int i = 0; i < n; i++) {
    80202f00:	f8042a23          	sw	zero,-108(s0)
    80202f04:	a0a9                	j	80202f4e <test_pagetable+0x320>
        free_page((void*)pa[i]);
    80202f06:	f7043703          	ld	a4,-144(s0)
    80202f0a:	f9442783          	lw	a5,-108(s0)
    80202f0e:	078e                	slli	a5,a5,0x3
    80202f10:	97ba                	add	a5,a5,a4
    80202f12:	639c                	ld	a5,0(a5)
    80202f14:	853e                	mv	a0,a5
    80202f16:	00000097          	auipc	ra,0x0
    80202f1a:	3ee080e7          	jalr	1006(ra) # 80203304 <free_page>
        printf("[PT TEST] 释放物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202f1e:	f7043703          	ld	a4,-144(s0)
    80202f22:	f9442783          	lw	a5,-108(s0)
    80202f26:	078e                	slli	a5,a5,0x3
    80202f28:	97ba                	add	a5,a5,a4
    80202f2a:	6398                	ld	a4,0(a5)
    80202f2c:	f9442783          	lw	a5,-108(s0)
    80202f30:	863a                	mv	a2,a4
    80202f32:	85be                	mv	a1,a5
    80202f34:	00010517          	auipc	a0,0x10
    80202f38:	56450513          	addi	a0,a0,1380 # 80213498 <user_test_table+0x688>
    80202f3c:	ffffe097          	auipc	ra,0xffffe
    80202f40:	dca080e7          	jalr	-566(ra) # 80200d06 <printf>
    for (int i = 0; i < n; i++) {
    80202f44:	f9442783          	lw	a5,-108(s0)
    80202f48:	2785                	addiw	a5,a5,1
    80202f4a:	f8f42a23          	sw	a5,-108(s0)
    80202f4e:	f9442783          	lw	a5,-108(s0)
    80202f52:	873e                	mv	a4,a5
    80202f54:	f8442783          	lw	a5,-124(s0)
    80202f58:	2701                	sext.w	a4,a4
    80202f5a:	2781                	sext.w	a5,a5
    80202f5c:	faf745e3          	blt	a4,a5,80202f06 <test_pagetable+0x2d8>
    free_pagetable(pt);
    80202f60:	f8843503          	ld	a0,-120(s0)
    80202f64:	fffff097          	auipc	ra,0xfffff
    80202f68:	56c080e7          	jalr	1388(ra) # 802024d0 <free_pagetable>
    printf("[PT TEST] 释放页表完成\n");
    80202f6c:	00010517          	auipc	a0,0x10
    80202f70:	55450513          	addi	a0,a0,1364 # 802134c0 <user_test_table+0x6b0>
    80202f74:	ffffe097          	auipc	ra,0xffffe
    80202f78:	d92080e7          	jalr	-622(ra) # 80200d06 <printf>
    printf("[PT TEST] 所有页表测试通过\n");
    80202f7c:	00010517          	auipc	a0,0x10
    80202f80:	56450513          	addi	a0,a0,1380 # 802134e0 <user_test_table+0x6d0>
    80202f84:	ffffe097          	auipc	ra,0xffffe
    80202f88:	d82080e7          	jalr	-638(ra) # 80200d06 <printf>
    80202f8c:	8126                	mv	sp,s1
}
    80202f8e:	0001                	nop
    80202f90:	f3040113          	addi	sp,s0,-208
    80202f94:	60ae                	ld	ra,200(sp)
    80202f96:	640e                	ld	s0,192(sp)
    80202f98:	74ea                	ld	s1,184(sp)
    80202f9a:	794a                	ld	s2,176(sp)
    80202f9c:	79aa                	ld	s3,168(sp)
    80202f9e:	7a0a                	ld	s4,160(sp)
    80202fa0:	6aea                	ld	s5,152(sp)
    80202fa2:	6b4a                	ld	s6,144(sp)
    80202fa4:	6baa                	ld	s7,136(sp)
    80202fa6:	6c0a                	ld	s8,128(sp)
    80202fa8:	7ce6                	ld	s9,120(sp)
    80202faa:	6169                	addi	sp,sp,208
    80202fac:	8082                	ret

0000000080202fae <check_mapping>:
void check_mapping(uint64 va) {
    80202fae:	7179                	addi	sp,sp,-48
    80202fb0:	f406                	sd	ra,40(sp)
    80202fb2:	f022                	sd	s0,32(sp)
    80202fb4:	1800                	addi	s0,sp,48
    80202fb6:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    80202fba:	00024797          	auipc	a5,0x24
    80202fbe:	0d678793          	addi	a5,a5,214 # 80227090 <kernel_pagetable>
    80202fc2:	639c                	ld	a5,0(a5)
    80202fc4:	fd843583          	ld	a1,-40(s0)
    80202fc8:	853e                	mv	a0,a5
    80202fca:	fffff097          	auipc	ra,0xfffff
    80202fce:	15e080e7          	jalr	350(ra) # 80202128 <walk_lookup>
    80202fd2:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    80202fd6:	fe843783          	ld	a5,-24(s0)
    80202fda:	cbb9                	beqz	a5,80203030 <check_mapping+0x82>
    80202fdc:	fe843783          	ld	a5,-24(s0)
    80202fe0:	639c                	ld	a5,0(a5)
    80202fe2:	8b85                	andi	a5,a5,1
    80202fe4:	c7b1                	beqz	a5,80203030 <check_mapping+0x82>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80202fe6:	fe843783          	ld	a5,-24(s0)
    80202fea:	639c                	ld	a5,0(a5)
    80202fec:	863e                	mv	a2,a5
    80202fee:	fd843583          	ld	a1,-40(s0)
    80202ff2:	00010517          	auipc	a0,0x10
    80202ff6:	53e50513          	addi	a0,a0,1342 # 80213530 <user_test_table+0x720>
    80202ffa:	ffffe097          	auipc	ra,0xffffe
    80202ffe:	d0c080e7          	jalr	-756(ra) # 80200d06 <printf>
		volatile unsigned char *p = (unsigned char*)va;
    80203002:	fd843783          	ld	a5,-40(s0)
    80203006:	fef43023          	sd	a5,-32(s0)
        printf("Try to read [0x%lx]: 0x%02x\n", va, *p);
    8020300a:	fe043783          	ld	a5,-32(s0)
    8020300e:	0007c783          	lbu	a5,0(a5)
    80203012:	0ff7f793          	zext.b	a5,a5
    80203016:	2781                	sext.w	a5,a5
    80203018:	863e                	mv	a2,a5
    8020301a:	fd843583          	ld	a1,-40(s0)
    8020301e:	00010517          	auipc	a0,0x10
    80203022:	53a50513          	addi	a0,a0,1338 # 80213558 <user_test_table+0x748>
    80203026:	ffffe097          	auipc	ra,0xffffe
    8020302a:	ce0080e7          	jalr	-800(ra) # 80200d06 <printf>
    if(pte && (*pte & PTE_V)) {
    8020302e:	a821                	j	80203046 <check_mapping+0x98>
        printf("Address 0x%lx is NOT mapped\n", va);
    80203030:	fd843583          	ld	a1,-40(s0)
    80203034:	00010517          	auipc	a0,0x10
    80203038:	54450513          	addi	a0,a0,1348 # 80213578 <user_test_table+0x768>
    8020303c:	ffffe097          	auipc	ra,0xffffe
    80203040:	cca080e7          	jalr	-822(ra) # 80200d06 <printf>
}
    80203044:	0001                	nop
    80203046:	0001                	nop
    80203048:	70a2                	ld	ra,40(sp)
    8020304a:	7402                	ld	s0,32(sp)
    8020304c:	6145                	addi	sp,sp,48
    8020304e:	8082                	ret

0000000080203050 <check_is_mapped>:
int check_is_mapped(uint64 va) {
    80203050:	7179                	addi	sp,sp,-48
    80203052:	f406                	sd	ra,40(sp)
    80203054:	f022                	sd	s0,32(sp)
    80203056:	1800                	addi	s0,sp,48
    80203058:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    8020305c:	00000097          	auipc	ra,0x0
    80203060:	86a080e7          	jalr	-1942(ra) # 802028c6 <get_current_pagetable>
    80203064:	87aa                	mv	a5,a0
    80203066:	fd843583          	ld	a1,-40(s0)
    8020306a:	853e                	mv	a0,a5
    8020306c:	fffff097          	auipc	ra,0xfffff
    80203070:	0bc080e7          	jalr	188(ra) # 80202128 <walk_lookup>
    80203074:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    80203078:	fe843783          	ld	a5,-24(s0)
    8020307c:	c795                	beqz	a5,802030a8 <check_is_mapped+0x58>
    8020307e:	fe843783          	ld	a5,-24(s0)
    80203082:	639c                	ld	a5,0(a5)
    80203084:	8b85                	andi	a5,a5,1
    80203086:	c38d                	beqz	a5,802030a8 <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    80203088:	fe843783          	ld	a5,-24(s0)
    8020308c:	639c                	ld	a5,0(a5)
    8020308e:	863e                	mv	a2,a5
    80203090:	fd843583          	ld	a1,-40(s0)
    80203094:	00010517          	auipc	a0,0x10
    80203098:	49c50513          	addi	a0,a0,1180 # 80213530 <user_test_table+0x720>
    8020309c:	ffffe097          	auipc	ra,0xffffe
    802030a0:	c6a080e7          	jalr	-918(ra) # 80200d06 <printf>
        return 1;
    802030a4:	4785                	li	a5,1
    802030a6:	a821                	j	802030be <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    802030a8:	fd843583          	ld	a1,-40(s0)
    802030ac:	00010517          	auipc	a0,0x10
    802030b0:	4cc50513          	addi	a0,a0,1228 # 80213578 <user_test_table+0x768>
    802030b4:	ffffe097          	auipc	ra,0xffffe
    802030b8:	c52080e7          	jalr	-942(ra) # 80200d06 <printf>
        return 0;
    802030bc:	4781                	li	a5,0
}
    802030be:	853e                	mv	a0,a5
    802030c0:	70a2                	ld	ra,40(sp)
    802030c2:	7402                	ld	s0,32(sp)
    802030c4:	6145                	addi	sp,sp,48
    802030c6:	8082                	ret

00000000802030c8 <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    802030c8:	711d                	addi	sp,sp,-96
    802030ca:	ec86                	sd	ra,88(sp)
    802030cc:	e8a2                	sd	s0,80(sp)
    802030ce:	1080                	addi	s0,sp,96
    802030d0:	faa43c23          	sd	a0,-72(s0)
    802030d4:	fab43823          	sd	a1,-80(s0)
    802030d8:	fac43423          	sd	a2,-88(s0)
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    802030dc:	fe043423          	sd	zero,-24(s0)
    802030e0:	a8d1                	j	802031b4 <uvmcopy+0xec>
        pte_t *pte = walk_lookup(old, i);
    802030e2:	fe843583          	ld	a1,-24(s0)
    802030e6:	fb843503          	ld	a0,-72(s0)
    802030ea:	fffff097          	auipc	ra,0xfffff
    802030ee:	03e080e7          	jalr	62(ra) # 80202128 <walk_lookup>
    802030f2:	fca43c23          	sd	a0,-40(s0)
        if (pte == 0 || (*pte & PTE_V) == 0)
    802030f6:	fd843783          	ld	a5,-40(s0)
    802030fa:	c7d5                	beqz	a5,802031a6 <uvmcopy+0xde>
    802030fc:	fd843783          	ld	a5,-40(s0)
    80203100:	639c                	ld	a5,0(a5)
    80203102:	8b85                	andi	a5,a5,1
    80203104:	c3cd                	beqz	a5,802031a6 <uvmcopy+0xde>
        uint64 pa = PTE2PA(*pte);
    80203106:	fd843783          	ld	a5,-40(s0)
    8020310a:	639c                	ld	a5,0(a5)
    8020310c:	83a9                	srli	a5,a5,0xa
    8020310e:	07b2                	slli	a5,a5,0xc
    80203110:	fcf43823          	sd	a5,-48(s0)
        int flags = PTE_FLAGS(*pte);
    80203114:	fd843783          	ld	a5,-40(s0)
    80203118:	639c                	ld	a5,0(a5)
    8020311a:	2781                	sext.w	a5,a5
    8020311c:	3ff7f793          	andi	a5,a5,1023
    80203120:	fef42223          	sw	a5,-28(s0)
		if (i < 0x80000000)
    80203124:	fe843703          	ld	a4,-24(s0)
    80203128:	800007b7          	lui	a5,0x80000
    8020312c:	fff7c793          	not	a5,a5
    80203130:	00e7e963          	bltu	a5,a4,80203142 <uvmcopy+0x7a>
			flags |= PTE_U;
    80203134:	fe442783          	lw	a5,-28(s0)
    80203138:	0107e793          	ori	a5,a5,16
    8020313c:	fef42223          	sw	a5,-28(s0)
    80203140:	a031                	j	8020314c <uvmcopy+0x84>
			flags &= ~PTE_U;
    80203142:	fe442783          	lw	a5,-28(s0)
    80203146:	9bbd                	andi	a5,a5,-17
    80203148:	fef42223          	sw	a5,-28(s0)
        void *mem = alloc_page();
    8020314c:	00000097          	auipc	ra,0x0
    80203150:	14c080e7          	jalr	332(ra) # 80203298 <alloc_page>
    80203154:	fca43423          	sd	a0,-56(s0)
        if (mem == 0)
    80203158:	fc843783          	ld	a5,-56(s0)
    8020315c:	e399                	bnez	a5,80203162 <uvmcopy+0x9a>
            return -1; // 分配失败
    8020315e:	57fd                	li	a5,-1
    80203160:	a08d                	j	802031c2 <uvmcopy+0xfa>
        memmove(mem, (void*)pa, PGSIZE);
    80203162:	fd043783          	ld	a5,-48(s0)
    80203166:	6605                	lui	a2,0x1
    80203168:	85be                	mv	a1,a5
    8020316a:	fc843503          	ld	a0,-56(s0)
    8020316e:	fffff097          	auipc	ra,0xfffff
    80203172:	d72080e7          	jalr	-654(ra) # 80201ee0 <memmove>
        if (map_page(new, i, (uint64)mem, flags) != 0) {
    80203176:	fc843783          	ld	a5,-56(s0)
    8020317a:	fe442703          	lw	a4,-28(s0)
    8020317e:	86ba                	mv	a3,a4
    80203180:	863e                	mv	a2,a5
    80203182:	fe843583          	ld	a1,-24(s0)
    80203186:	fb043503          	ld	a0,-80(s0)
    8020318a:	fffff097          	auipc	ra,0xfffff
    8020318e:	1d2080e7          	jalr	466(ra) # 8020235c <map_page>
    80203192:	87aa                	mv	a5,a0
    80203194:	cb91                	beqz	a5,802031a8 <uvmcopy+0xe0>
            free_page(mem);
    80203196:	fc843503          	ld	a0,-56(s0)
    8020319a:	00000097          	auipc	ra,0x0
    8020319e:	16a080e7          	jalr	362(ra) # 80203304 <free_page>
            return -1;
    802031a2:	57fd                	li	a5,-1
    802031a4:	a839                	j	802031c2 <uvmcopy+0xfa>
            continue; // 跳过未分配的页
    802031a6:	0001                	nop
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    802031a8:	fe843703          	ld	a4,-24(s0)
    802031ac:	6785                	lui	a5,0x1
    802031ae:	97ba                	add	a5,a5,a4
    802031b0:	fef43423          	sd	a5,-24(s0)
    802031b4:	fe843703          	ld	a4,-24(s0)
    802031b8:	fa843783          	ld	a5,-88(s0)
    802031bc:	f2f763e3          	bltu	a4,a5,802030e2 <uvmcopy+0x1a>
    return 0;
    802031c0:	4781                	li	a5,0
    802031c2:	853e                	mv	a0,a5
    802031c4:	60e6                	ld	ra,88(sp)
    802031c6:	6446                	ld	s0,80(sp)
    802031c8:	6125                	addi	sp,sp,96
    802031ca:	8082                	ret

00000000802031cc <assert>:
    802031cc:	1101                	addi	sp,sp,-32
    802031ce:	ec06                	sd	ra,24(sp)
    802031d0:	e822                	sd	s0,16(sp)
    802031d2:	1000                	addi	s0,sp,32
    802031d4:	87aa                	mv	a5,a0
    802031d6:	fef42623          	sw	a5,-20(s0)
    802031da:	fec42783          	lw	a5,-20(s0)
    802031de:	2781                	sext.w	a5,a5
    802031e0:	e79d                	bnez	a5,8020320e <assert+0x42>
    802031e2:	1b700613          	li	a2,439
    802031e6:	00012597          	auipc	a1,0x12
    802031ea:	3c258593          	addi	a1,a1,962 # 802155a8 <user_test_table+0x60>
    802031ee:	00012517          	auipc	a0,0x12
    802031f2:	3ca50513          	addi	a0,a0,970 # 802155b8 <user_test_table+0x70>
    802031f6:	ffffe097          	auipc	ra,0xffffe
    802031fa:	b10080e7          	jalr	-1264(ra) # 80200d06 <printf>
    802031fe:	00012517          	auipc	a0,0x12
    80203202:	3e250513          	addi	a0,a0,994 # 802155e0 <user_test_table+0x98>
    80203206:	ffffe097          	auipc	ra,0xffffe
    8020320a:	54c080e7          	jalr	1356(ra) # 80201752 <panic>
    8020320e:	0001                	nop
    80203210:	60e2                	ld	ra,24(sp)
    80203212:	6442                	ld	s0,16(sp)
    80203214:	6105                	addi	sp,sp,32
    80203216:	8082                	ret

0000000080203218 <freerange>:
static void freerange(void *pa_start, void *pa_end) {
    80203218:	7179                	addi	sp,sp,-48
    8020321a:	f406                	sd	ra,40(sp)
    8020321c:	f022                	sd	s0,32(sp)
    8020321e:	1800                	addi	s0,sp,48
    80203220:	fca43c23          	sd	a0,-40(s0)
    80203224:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    80203228:	fd843703          	ld	a4,-40(s0)
    8020322c:	6785                	lui	a5,0x1
    8020322e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203230:	973e                	add	a4,a4,a5
    80203232:	77fd                	lui	a5,0xfffff
    80203234:	8ff9                	and	a5,a5,a4
    80203236:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8020323a:	a829                	j	80203254 <freerange+0x3c>
    free_page(p);
    8020323c:	fe843503          	ld	a0,-24(s0)
    80203240:	00000097          	auipc	ra,0x0
    80203244:	0c4080e7          	jalr	196(ra) # 80203304 <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80203248:	fe843703          	ld	a4,-24(s0)
    8020324c:	6785                	lui	a5,0x1
    8020324e:	97ba                	add	a5,a5,a4
    80203250:	fef43423          	sd	a5,-24(s0)
    80203254:	fe843703          	ld	a4,-24(s0)
    80203258:	6785                	lui	a5,0x1
    8020325a:	97ba                	add	a5,a5,a4
    8020325c:	fd043703          	ld	a4,-48(s0)
    80203260:	fcf77ee3          	bgeu	a4,a5,8020323c <freerange+0x24>
}
    80203264:	0001                	nop
    80203266:	0001                	nop
    80203268:	70a2                	ld	ra,40(sp)
    8020326a:	7402                	ld	s0,32(sp)
    8020326c:	6145                	addi	sp,sp,48
    8020326e:	8082                	ret

0000000080203270 <pmm_init>:
void pmm_init(void) {
    80203270:	1141                	addi	sp,sp,-16
    80203272:	e406                	sd	ra,8(sp)
    80203274:	e022                	sd	s0,0(sp)
    80203276:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    80203278:	47c5                	li	a5,17
    8020327a:	01b79593          	slli	a1,a5,0x1b
    8020327e:	00024517          	auipc	a0,0x24
    80203282:	47250513          	addi	a0,a0,1138 # 802276f0 <_bss_end>
    80203286:	00000097          	auipc	ra,0x0
    8020328a:	f92080e7          	jalr	-110(ra) # 80203218 <freerange>
}
    8020328e:	0001                	nop
    80203290:	60a2                	ld	ra,8(sp)
    80203292:	6402                	ld	s0,0(sp)
    80203294:	0141                	addi	sp,sp,16
    80203296:	8082                	ret

0000000080203298 <alloc_page>:
void* alloc_page(void) {
    80203298:	1101                	addi	sp,sp,-32
    8020329a:	ec06                	sd	ra,24(sp)
    8020329c:	e822                	sd	s0,16(sp)
    8020329e:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    802032a0:	00024797          	auipc	a5,0x24
    802032a4:	fc078793          	addi	a5,a5,-64 # 80227260 <freelist>
    802032a8:	639c                	ld	a5,0(a5)
    802032aa:	fef43423          	sd	a5,-24(s0)
  if(r)
    802032ae:	fe843783          	ld	a5,-24(s0)
    802032b2:	cb89                	beqz	a5,802032c4 <alloc_page+0x2c>
    freelist = r->next;
    802032b4:	fe843783          	ld	a5,-24(s0)
    802032b8:	6398                	ld	a4,0(a5)
    802032ba:	00024797          	auipc	a5,0x24
    802032be:	fa678793          	addi	a5,a5,-90 # 80227260 <freelist>
    802032c2:	e398                	sd	a4,0(a5)
  if(r)
    802032c4:	fe843783          	ld	a5,-24(s0)
    802032c8:	cf99                	beqz	a5,802032e6 <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    802032ca:	fe843783          	ld	a5,-24(s0)
    802032ce:	00878713          	addi	a4,a5,8
    802032d2:	6785                	lui	a5,0x1
    802032d4:	ff878613          	addi	a2,a5,-8 # ff8 <_entry-0x801ff008>
    802032d8:	4595                	li	a1,5
    802032da:	853a                	mv	a0,a4
    802032dc:	fffff097          	auipc	ra,0xfffff
    802032e0:	bb4080e7          	jalr	-1100(ra) # 80201e90 <memset>
    802032e4:	a809                	j	802032f6 <alloc_page+0x5e>
    panic("alloc_page: out of memory");
    802032e6:	00012517          	auipc	a0,0x12
    802032ea:	30250513          	addi	a0,a0,770 # 802155e8 <user_test_table+0xa0>
    802032ee:	ffffe097          	auipc	ra,0xffffe
    802032f2:	464080e7          	jalr	1124(ra) # 80201752 <panic>
  return (void*)r;
    802032f6:	fe843783          	ld	a5,-24(s0)
}
    802032fa:	853e                	mv	a0,a5
    802032fc:	60e2                	ld	ra,24(sp)
    802032fe:	6442                	ld	s0,16(sp)
    80203300:	6105                	addi	sp,sp,32
    80203302:	8082                	ret

0000000080203304 <free_page>:
void free_page(void* page) {
    80203304:	7179                	addi	sp,sp,-48
    80203306:	f406                	sd	ra,40(sp)
    80203308:	f022                	sd	s0,32(sp)
    8020330a:	1800                	addi	s0,sp,48
    8020330c:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    80203310:	fd843783          	ld	a5,-40(s0)
    80203314:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    80203318:	fd843703          	ld	a4,-40(s0)
    8020331c:	6785                	lui	a5,0x1
    8020331e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203320:	8ff9                	and	a5,a5,a4
    80203322:	ef99                	bnez	a5,80203340 <free_page+0x3c>
    80203324:	fd843703          	ld	a4,-40(s0)
    80203328:	00024797          	auipc	a5,0x24
    8020332c:	3c878793          	addi	a5,a5,968 # 802276f0 <_bss_end>
    80203330:	00f76863          	bltu	a4,a5,80203340 <free_page+0x3c>
    80203334:	fd843703          	ld	a4,-40(s0)
    80203338:	47c5                	li	a5,17
    8020333a:	07ee                	slli	a5,a5,0x1b
    8020333c:	00f76a63          	bltu	a4,a5,80203350 <free_page+0x4c>
    panic("free_page: invalid page address");
    80203340:	00012517          	auipc	a0,0x12
    80203344:	2c850513          	addi	a0,a0,712 # 80215608 <user_test_table+0xc0>
    80203348:	ffffe097          	auipc	ra,0xffffe
    8020334c:	40a080e7          	jalr	1034(ra) # 80201752 <panic>
  r->next = freelist;
    80203350:	00024797          	auipc	a5,0x24
    80203354:	f1078793          	addi	a5,a5,-240 # 80227260 <freelist>
    80203358:	6398                	ld	a4,0(a5)
    8020335a:	fe843783          	ld	a5,-24(s0)
    8020335e:	e398                	sd	a4,0(a5)
  freelist = r;
    80203360:	00024797          	auipc	a5,0x24
    80203364:	f0078793          	addi	a5,a5,-256 # 80227260 <freelist>
    80203368:	fe843703          	ld	a4,-24(s0)
    8020336c:	e398                	sd	a4,0(a5)
}
    8020336e:	0001                	nop
    80203370:	70a2                	ld	ra,40(sp)
    80203372:	7402                	ld	s0,32(sp)
    80203374:	6145                	addi	sp,sp,48
    80203376:	8082                	ret

0000000080203378 <test_physical_memory>:
void test_physical_memory(void) {
    80203378:	7179                	addi	sp,sp,-48
    8020337a:	f406                	sd	ra,40(sp)
    8020337c:	f022                	sd	s0,32(sp)
    8020337e:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    80203380:	00012517          	auipc	a0,0x12
    80203384:	2a850513          	addi	a0,a0,680 # 80215628 <user_test_table+0xe0>
    80203388:	ffffe097          	auipc	ra,0xffffe
    8020338c:	97e080e7          	jalr	-1666(ra) # 80200d06 <printf>
    void *page1 = alloc_page();
    80203390:	00000097          	auipc	ra,0x0
    80203394:	f08080e7          	jalr	-248(ra) # 80203298 <alloc_page>
    80203398:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    8020339c:	00000097          	auipc	ra,0x0
    802033a0:	efc080e7          	jalr	-260(ra) # 80203298 <alloc_page>
    802033a4:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    802033a8:	fe843783          	ld	a5,-24(s0)
    802033ac:	00f037b3          	snez	a5,a5
    802033b0:	0ff7f793          	zext.b	a5,a5
    802033b4:	2781                	sext.w	a5,a5
    802033b6:	853e                	mv	a0,a5
    802033b8:	00000097          	auipc	ra,0x0
    802033bc:	e14080e7          	jalr	-492(ra) # 802031cc <assert>
    assert(page2 != 0);
    802033c0:	fe043783          	ld	a5,-32(s0)
    802033c4:	00f037b3          	snez	a5,a5
    802033c8:	0ff7f793          	zext.b	a5,a5
    802033cc:	2781                	sext.w	a5,a5
    802033ce:	853e                	mv	a0,a5
    802033d0:	00000097          	auipc	ra,0x0
    802033d4:	dfc080e7          	jalr	-516(ra) # 802031cc <assert>
    assert(page1 != page2);
    802033d8:	fe843703          	ld	a4,-24(s0)
    802033dc:	fe043783          	ld	a5,-32(s0)
    802033e0:	40f707b3          	sub	a5,a4,a5
    802033e4:	00f037b3          	snez	a5,a5
    802033e8:	0ff7f793          	zext.b	a5,a5
    802033ec:	2781                	sext.w	a5,a5
    802033ee:	853e                	mv	a0,a5
    802033f0:	00000097          	auipc	ra,0x0
    802033f4:	ddc080e7          	jalr	-548(ra) # 802031cc <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    802033f8:	fe843703          	ld	a4,-24(s0)
    802033fc:	6785                	lui	a5,0x1
    802033fe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203400:	8ff9                	and	a5,a5,a4
    80203402:	0017b793          	seqz	a5,a5
    80203406:	0ff7f793          	zext.b	a5,a5
    8020340a:	2781                	sext.w	a5,a5
    8020340c:	853e                	mv	a0,a5
    8020340e:	00000097          	auipc	ra,0x0
    80203412:	dbe080e7          	jalr	-578(ra) # 802031cc <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    80203416:	fe043703          	ld	a4,-32(s0)
    8020341a:	6785                	lui	a5,0x1
    8020341c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    8020341e:	8ff9                	and	a5,a5,a4
    80203420:	0017b793          	seqz	a5,a5
    80203424:	0ff7f793          	zext.b	a5,a5
    80203428:	2781                	sext.w	a5,a5
    8020342a:	853e                	mv	a0,a5
    8020342c:	00000097          	auipc	ra,0x0
    80203430:	da0080e7          	jalr	-608(ra) # 802031cc <assert>
    printf("[PM TEST] 分配测试通过\n");
    80203434:	00012517          	auipc	a0,0x12
    80203438:	21450513          	addi	a0,a0,532 # 80215648 <user_test_table+0x100>
    8020343c:	ffffe097          	auipc	ra,0xffffe
    80203440:	8ca080e7          	jalr	-1846(ra) # 80200d06 <printf>
    printf("[PM TEST] 数据写入测试...\n");
    80203444:	00012517          	auipc	a0,0x12
    80203448:	22450513          	addi	a0,a0,548 # 80215668 <user_test_table+0x120>
    8020344c:	ffffe097          	auipc	ra,0xffffe
    80203450:	8ba080e7          	jalr	-1862(ra) # 80200d06 <printf>
    *(int*)page1 = 0x12345678;
    80203454:	fe843783          	ld	a5,-24(s0)
    80203458:	12345737          	lui	a4,0x12345
    8020345c:	67870713          	addi	a4,a4,1656 # 12345678 <_entry-0x6deba988>
    80203460:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    80203462:	fe843783          	ld	a5,-24(s0)
    80203466:	439c                	lw	a5,0(a5)
    80203468:	873e                	mv	a4,a5
    8020346a:	123457b7          	lui	a5,0x12345
    8020346e:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6deba988>
    80203472:	40f707b3          	sub	a5,a4,a5
    80203476:	0017b793          	seqz	a5,a5
    8020347a:	0ff7f793          	zext.b	a5,a5
    8020347e:	2781                	sext.w	a5,a5
    80203480:	853e                	mv	a0,a5
    80203482:	00000097          	auipc	ra,0x0
    80203486:	d4a080e7          	jalr	-694(ra) # 802031cc <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    8020348a:	00012517          	auipc	a0,0x12
    8020348e:	20650513          	addi	a0,a0,518 # 80215690 <user_test_table+0x148>
    80203492:	ffffe097          	auipc	ra,0xffffe
    80203496:	874080e7          	jalr	-1932(ra) # 80200d06 <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    8020349a:	00012517          	auipc	a0,0x12
    8020349e:	21e50513          	addi	a0,a0,542 # 802156b8 <user_test_table+0x170>
    802034a2:	ffffe097          	auipc	ra,0xffffe
    802034a6:	864080e7          	jalr	-1948(ra) # 80200d06 <printf>
    free_page(page1);
    802034aa:	fe843503          	ld	a0,-24(s0)
    802034ae:	00000097          	auipc	ra,0x0
    802034b2:	e56080e7          	jalr	-426(ra) # 80203304 <free_page>
    void *page3 = alloc_page();
    802034b6:	00000097          	auipc	ra,0x0
    802034ba:	de2080e7          	jalr	-542(ra) # 80203298 <alloc_page>
    802034be:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    802034c2:	fd843783          	ld	a5,-40(s0)
    802034c6:	00f037b3          	snez	a5,a5
    802034ca:	0ff7f793          	zext.b	a5,a5
    802034ce:	2781                	sext.w	a5,a5
    802034d0:	853e                	mv	a0,a5
    802034d2:	00000097          	auipc	ra,0x0
    802034d6:	cfa080e7          	jalr	-774(ra) # 802031cc <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    802034da:	00012517          	auipc	a0,0x12
    802034de:	20e50513          	addi	a0,a0,526 # 802156e8 <user_test_table+0x1a0>
    802034e2:	ffffe097          	auipc	ra,0xffffe
    802034e6:	824080e7          	jalr	-2012(ra) # 80200d06 <printf>
    free_page(page2);
    802034ea:	fe043503          	ld	a0,-32(s0)
    802034ee:	00000097          	auipc	ra,0x0
    802034f2:	e16080e7          	jalr	-490(ra) # 80203304 <free_page>
    free_page(page3);
    802034f6:	fd843503          	ld	a0,-40(s0)
    802034fa:	00000097          	auipc	ra,0x0
    802034fe:	e0a080e7          	jalr	-502(ra) # 80203304 <free_page>
    printf("[PM TEST] 所有物理内存管理测试通过\n");
    80203502:	00012517          	auipc	a0,0x12
    80203506:	21650513          	addi	a0,a0,534 # 80215718 <user_test_table+0x1d0>
    8020350a:	ffffd097          	auipc	ra,0xffffd
    8020350e:	7fc080e7          	jalr	2044(ra) # 80200d06 <printf>
    80203512:	0001                	nop
    80203514:	70a2                	ld	ra,40(sp)
    80203516:	7402                	ld	s0,32(sp)
    80203518:	6145                	addi	sp,sp,48
    8020351a:	8082                	ret

000000008020351c <sbi_set_time>:
#include "defs.h"

void sbi_set_time(uint64 time) {
    8020351c:	1101                	addi	sp,sp,-32
    8020351e:	ec22                	sd	s0,24(sp)
    80203520:	1000                	addi	s0,sp,32
    80203522:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    80203526:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    8020352a:	4881                	li	a7,0
    asm volatile ("ecall"
    8020352c:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    80203530:	0001                	nop
    80203532:	6462                	ld	s0,24(sp)
    80203534:	6105                	addi	sp,sp,32
    80203536:	8082                	ret

0000000080203538 <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    80203538:	1101                	addi	sp,sp,-32
    8020353a:	ec22                	sd	s0,24(sp)
    8020353c:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    8020353e:	c01027f3          	rdtime	a5
    80203542:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    80203546:	fe843783          	ld	a5,-24(s0)
    8020354a:	853e                	mv	a0,a5
    8020354c:	6462                	ld	s0,24(sp)
    8020354e:	6105                	addi	sp,sp,32
    80203550:	8082                	ret

0000000080203552 <timeintr>:
#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    80203552:	1141                	addi	sp,sp,-16
    80203554:	e422                	sd	s0,8(sp)
    80203556:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    80203558:	00024797          	auipc	a5,0x24
    8020355c:	b6078793          	addi	a5,a5,-1184 # 802270b8 <interrupt_test_flag>
    80203560:	639c                	ld	a5,0(a5)
    80203562:	cb99                	beqz	a5,80203578 <timeintr+0x26>
        (*interrupt_test_flag)++;
    80203564:	00024797          	auipc	a5,0x24
    80203568:	b5478793          	addi	a5,a5,-1196 # 802270b8 <interrupt_test_flag>
    8020356c:	639c                	ld	a5,0(a5)
    8020356e:	4398                	lw	a4,0(a5)
    80203570:	2701                	sext.w	a4,a4
    80203572:	2705                	addiw	a4,a4,1
    80203574:	2701                	sext.w	a4,a4
    80203576:	c398                	sw	a4,0(a5)
    80203578:	0001                	nop
    8020357a:	6422                	ld	s0,8(sp)
    8020357c:	0141                	addi	sp,sp,16
    8020357e:	8082                	ret

0000000080203580 <r_sie>:
		case SYS_pid:
			tf->a0 = myproc()->pid;
			break;
		case SYS_ppid:
			tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
			break;
    80203580:	1101                	addi	sp,sp,-32
    80203582:	ec22                	sd	s0,24(sp)
    80203584:	1000                	addi	s0,sp,32
		case SYS_get_time:
			tf->a0 = get_time();
    80203586:	104027f3          	csrr	a5,sie
    8020358a:	fef43423          	sd	a5,-24(s0)
			break;
    8020358e:	fe843783          	ld	a5,-24(s0)
		case SYS_step:
    80203592:	853e                	mv	a0,a5
    80203594:	6462                	ld	s0,24(sp)
    80203596:	6105                	addi	sp,sp,32
    80203598:	8082                	ret

000000008020359a <w_sie>:
			tf->a0 = 0;
			printf("[syscall] step enabled but do nothing\n");
    8020359a:	1101                	addi	sp,sp,-32
    8020359c:	ec22                	sd	s0,24(sp)
    8020359e:	1000                	addi	s0,sp,32
    802035a0:	fea43423          	sd	a0,-24(s0)
			break;
    802035a4:	fe843783          	ld	a5,-24(s0)
    802035a8:	10479073          	csrw	sie,a5
	case SYS_write: {
    802035ac:	0001                	nop
    802035ae:	6462                	ld	s0,24(sp)
    802035b0:	6105                	addi	sp,sp,32
    802035b2:	8082                	ret

00000000802035b4 <r_sstatus>:
		int fd = tf->a0;          // 文件描述符
		char buf[128];            // 临时缓冲区
    802035b4:	1101                	addi	sp,sp,-32
    802035b6:	ec22                	sd	s0,24(sp)
    802035b8:	1000                	addi	s0,sp,32
		
		// 目前只支持标准输出(fd=1)和标准错误(fd=2)
    802035ba:	100027f3          	csrr	a5,sstatus
    802035be:	fef43423          	sd	a5,-24(s0)
		if (fd != 1 && fd != 2) {
    802035c2:	fe843783          	ld	a5,-24(s0)
			tf->a0 = -1;
    802035c6:	853e                	mv	a0,a5
    802035c8:	6462                	ld	s0,24(sp)
    802035ca:	6105                	addi	sp,sp,32
    802035cc:	8082                	ret

00000000802035ce <w_sstatus>:
			break;
    802035ce:	1101                	addi	sp,sp,-32
    802035d0:	ec22                	sd	s0,24(sp)
    802035d2:	1000                	addi	s0,sp,32
    802035d4:	fea43423          	sd	a0,-24(s0)
		}
    802035d8:	fe843783          	ld	a5,-24(s0)
    802035dc:	10079073          	csrw	sstatus,a5
		
    802035e0:	0001                	nop
    802035e2:	6462                	ld	s0,24(sp)
    802035e4:	6105                	addi	sp,sp,32
    802035e6:	8082                	ret

00000000802035e8 <w_sscratch>:
		// 检查用户提供的缓冲区地址是否合法
    802035e8:	1101                	addi	sp,sp,-32
    802035ea:	ec22                	sd	s0,24(sp)
    802035ec:	1000                	addi	s0,sp,32
    802035ee:	fea43423          	sd	a0,-24(s0)
		if (check_user_addr(tf->a1, tf->a2, 0) < 0) {
    802035f2:	fe843783          	ld	a5,-24(s0)
    802035f6:	14079073          	csrw	sscratch,a5
			printf("[syscall] invalid write buffer address\n");
    802035fa:	0001                	nop
    802035fc:	6462                	ld	s0,24(sp)
    802035fe:	6105                	addi	sp,sp,32
    80203600:	8082                	ret

0000000080203602 <w_sepc>:
			tf->a0 = -1;
			break;
    80203602:	1101                	addi	sp,sp,-32
    80203604:	ec22                	sd	s0,24(sp)
    80203606:	1000                	addi	s0,sp,32
    80203608:	fea43423          	sd	a0,-24(s0)
		}
    8020360c:	fe843783          	ld	a5,-24(s0)
    80203610:	14179073          	csrw	sepc,a5
		
    80203614:	0001                	nop
    80203616:	6462                	ld	s0,24(sp)
    80203618:	6105                	addi	sp,sp,32
    8020361a:	8082                	ret

000000008020361c <intr_off>:
		// 从用户空间安全地复制字符串
		if (copyinstr(buf, myproc()->pagetable, tf->a1, sizeof(buf)) < 0) {
			printf("[syscall] invalid write buffer\n");
			tf->a0 = -1;
			break;
		}
    8020361c:	1141                	addi	sp,sp,-16
    8020361e:	e406                	sd	ra,8(sp)
    80203620:	e022                	sd	s0,0(sp)
    80203622:	0800                	addi	s0,sp,16
		
    80203624:	00000097          	auipc	ra,0x0
    80203628:	f90080e7          	jalr	-112(ra) # 802035b4 <r_sstatus>
    8020362c:	87aa                	mv	a5,a0
    8020362e:	9bf5                	andi	a5,a5,-3
    80203630:	853e                	mv	a0,a5
    80203632:	00000097          	auipc	ra,0x0
    80203636:	f9c080e7          	jalr	-100(ra) # 802035ce <w_sstatus>
		// 输出到控制台
    8020363a:	0001                	nop
    8020363c:	60a2                	ld	ra,8(sp)
    8020363e:	6402                	ld	s0,0(sp)
    80203640:	0141                	addi	sp,sp,16
    80203642:	8082                	ret

0000000080203644 <w_stvec>:
		printf("%s", buf);
		tf->a0 = strlen(buf);  // 返回写入的字节数
    80203644:	1101                	addi	sp,sp,-32
    80203646:	ec22                	sd	s0,24(sp)
    80203648:	1000                	addi	s0,sp,32
    8020364a:	fea43423          	sd	a0,-24(s0)
		break;
    8020364e:	fe843783          	ld	a5,-24(s0)
    80203652:	10579073          	csrw	stvec,a5
	}
    80203656:	0001                	nop
    80203658:	6462                	ld	s0,24(sp)
    8020365a:	6105                	addi	sp,sp,32
    8020365c:	8082                	ret

000000008020365e <r_scause>:
		int fd = tf->a0;          // 文件描述符
		uint64 buf = tf->a1;      // 用户缓冲区地址
		int n = tf->a2;           // 要读取的字节数
		
		// 目前只支持标准输入(fd=0)
		if (fd != 0) {
    8020365e:	1101                	addi	sp,sp,-32
    80203660:	ec22                	sd	s0,24(sp)
    80203662:	1000                	addi	s0,sp,32
			tf->a0 = -1;
			break;
    80203664:	142027f3          	csrr	a5,scause
    80203668:	fef43423          	sd	a5,-24(s0)
		}
    8020366c:	fe843783          	ld	a5,-24(s0)
		
    80203670:	853e                	mv	a0,a5
    80203672:	6462                	ld	s0,24(sp)
    80203674:	6105                	addi	sp,sp,32
    80203676:	8082                	ret

0000000080203678 <r_sepc>:
		// 检查用户提供的缓冲区地址是否合法
		if (check_user_addr(buf, n, 1) < 0) {  // 1表示写入访问
    80203678:	1101                	addi	sp,sp,-32
    8020367a:	ec22                	sd	s0,24(sp)
    8020367c:	1000                	addi	s0,sp,32
			printf("[syscall] invalid read buffer address\n");
			tf->a0 = -1;
    8020367e:	141027f3          	csrr	a5,sepc
    80203682:	fef43423          	sd	a5,-24(s0)
			break;
    80203686:	fe843783          	ld	a5,-24(s0)
		}
    8020368a:	853e                	mv	a0,a5
    8020368c:	6462                	ld	s0,24(sp)
    8020368e:	6105                	addi	sp,sp,32
    80203690:	8082                	ret

0000000080203692 <r_stval>:
		
		// TODO: 实现从控制台读取
    80203692:	1101                	addi	sp,sp,-32
    80203694:	ec22                	sd	s0,24(sp)
    80203696:	1000                	addi	s0,sp,32
		tf->a0 = -1;
		break;
    80203698:	143027f3          	csrr	a5,stval
    8020369c:	fef43423          	sd	a5,-24(s0)
	}
    802036a0:	fe843783          	ld	a5,-24(s0)
        
    802036a4:	853e                	mv	a0,a5
    802036a6:	6462                	ld	s0,24(sp)
    802036a8:	6105                	addi	sp,sp,32
    802036aa:	8082                	ret

00000000802036ac <save_exception_info>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    802036ac:	7139                	addi	sp,sp,-64
    802036ae:	fc22                	sd	s0,56(sp)
    802036b0:	0080                	addi	s0,sp,64
    802036b2:	fea43423          	sd	a0,-24(s0)
    802036b6:	feb43023          	sd	a1,-32(s0)
    802036ba:	fcc43c23          	sd	a2,-40(s0)
    802036be:	fcd43823          	sd	a3,-48(s0)
    802036c2:	fce43423          	sd	a4,-56(s0)
    tf->epc = sepc;
    802036c6:	fe843783          	ld	a5,-24(s0)
    802036ca:	fe043703          	ld	a4,-32(s0)
    802036ce:	ff98                	sd	a4,56(a5)
}
    802036d0:	0001                	nop
    802036d2:	7462                	ld	s0,56(sp)
    802036d4:	6121                	addi	sp,sp,64
    802036d6:	8082                	ret

00000000802036d8 <get_sepc>:
static inline uint64 get_sepc(struct trapframe *tf) {
    802036d8:	1101                	addi	sp,sp,-32
    802036da:	ec22                	sd	s0,24(sp)
    802036dc:	1000                	addi	s0,sp,32
    802036de:	fea43423          	sd	a0,-24(s0)
    return tf->epc;
    802036e2:	fe843783          	ld	a5,-24(s0)
    802036e6:	7f9c                	ld	a5,56(a5)
}
    802036e8:	853e                	mv	a0,a5
    802036ea:	6462                	ld	s0,24(sp)
    802036ec:	6105                	addi	sp,sp,32
    802036ee:	8082                	ret

00000000802036f0 <set_sepc>:
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    802036f0:	1101                	addi	sp,sp,-32
    802036f2:	ec22                	sd	s0,24(sp)
    802036f4:	1000                	addi	s0,sp,32
    802036f6:	fea43423          	sd	a0,-24(s0)
    802036fa:	feb43023          	sd	a1,-32(s0)
    tf->epc = sepc;
    802036fe:	fe843783          	ld	a5,-24(s0)
    80203702:	fe043703          	ld	a4,-32(s0)
    80203706:	ff98                	sd	a4,56(a5)
}
    80203708:	0001                	nop
    8020370a:	6462                	ld	s0,24(sp)
    8020370c:	6105                	addi	sp,sp,32
    8020370e:	8082                	ret

0000000080203710 <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    80203710:	1101                	addi	sp,sp,-32
    80203712:	ec22                	sd	s0,24(sp)
    80203714:	1000                	addi	s0,sp,32
    80203716:	87aa                	mv	a5,a0
    80203718:	feb43023          	sd	a1,-32(s0)
    8020371c:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    80203720:	fec42783          	lw	a5,-20(s0)
    80203724:	2781                	sext.w	a5,a5
    80203726:	0207c563          	bltz	a5,80203750 <register_interrupt+0x40>
    8020372a:	fec42783          	lw	a5,-20(s0)
    8020372e:	0007871b          	sext.w	a4,a5
    80203732:	03f00793          	li	a5,63
    80203736:	00e7cd63          	blt	a5,a4,80203750 <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    8020373a:	00024717          	auipc	a4,0x24
    8020373e:	b2e70713          	addi	a4,a4,-1234 # 80227268 <interrupt_vector>
    80203742:	fec42783          	lw	a5,-20(s0)
    80203746:	078e                	slli	a5,a5,0x3
    80203748:	97ba                	add	a5,a5,a4
    8020374a:	fe043703          	ld	a4,-32(s0)
    8020374e:	e398                	sd	a4,0(a5)
}
    80203750:	0001                	nop
    80203752:	6462                	ld	s0,24(sp)
    80203754:	6105                	addi	sp,sp,32
    80203756:	8082                	ret

0000000080203758 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    80203758:	1101                	addi	sp,sp,-32
    8020375a:	ec22                	sd	s0,24(sp)
    8020375c:	1000                	addi	s0,sp,32
    8020375e:	87aa                	mv	a5,a0
    80203760:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    80203764:	fec42783          	lw	a5,-20(s0)
    80203768:	2781                	sext.w	a5,a5
    8020376a:	0207c463          	bltz	a5,80203792 <unregister_interrupt+0x3a>
    8020376e:	fec42783          	lw	a5,-20(s0)
    80203772:	0007871b          	sext.w	a4,a5
    80203776:	03f00793          	li	a5,63
    8020377a:	00e7cc63          	blt	a5,a4,80203792 <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    8020377e:	00024717          	auipc	a4,0x24
    80203782:	aea70713          	addi	a4,a4,-1302 # 80227268 <interrupt_vector>
    80203786:	fec42783          	lw	a5,-20(s0)
    8020378a:	078e                	slli	a5,a5,0x3
    8020378c:	97ba                	add	a5,a5,a4
    8020378e:	0007b023          	sd	zero,0(a5)
}
    80203792:	0001                	nop
    80203794:	6462                	ld	s0,24(sp)
    80203796:	6105                	addi	sp,sp,32
    80203798:	8082                	ret

000000008020379a <enable_interrupts>:
void enable_interrupts(int irq) {
    8020379a:	1101                	addi	sp,sp,-32
    8020379c:	ec06                	sd	ra,24(sp)
    8020379e:	e822                	sd	s0,16(sp)
    802037a0:	1000                	addi	s0,sp,32
    802037a2:	87aa                	mv	a5,a0
    802037a4:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    802037a8:	fec42783          	lw	a5,-20(s0)
    802037ac:	853e                	mv	a0,a5
    802037ae:	00001097          	auipc	ra,0x1
    802037b2:	37e080e7          	jalr	894(ra) # 80204b2c <plic_enable>
}
    802037b6:	0001                	nop
    802037b8:	60e2                	ld	ra,24(sp)
    802037ba:	6442                	ld	s0,16(sp)
    802037bc:	6105                	addi	sp,sp,32
    802037be:	8082                	ret

00000000802037c0 <disable_interrupts>:
void disable_interrupts(int irq) {
    802037c0:	1101                	addi	sp,sp,-32
    802037c2:	ec06                	sd	ra,24(sp)
    802037c4:	e822                	sd	s0,16(sp)
    802037c6:	1000                	addi	s0,sp,32
    802037c8:	87aa                	mv	a5,a0
    802037ca:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    802037ce:	fec42783          	lw	a5,-20(s0)
    802037d2:	853e                	mv	a0,a5
    802037d4:	00001097          	auipc	ra,0x1
    802037d8:	3b0080e7          	jalr	944(ra) # 80204b84 <plic_disable>
}
    802037dc:	0001                	nop
    802037de:	60e2                	ld	ra,24(sp)
    802037e0:	6442                	ld	s0,16(sp)
    802037e2:	6105                	addi	sp,sp,32
    802037e4:	8082                	ret

00000000802037e6 <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    802037e6:	1101                	addi	sp,sp,-32
    802037e8:	ec06                	sd	ra,24(sp)
    802037ea:	e822                	sd	s0,16(sp)
    802037ec:	1000                	addi	s0,sp,32
    802037ee:	87aa                	mv	a5,a0
    802037f0:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    802037f4:	fec42783          	lw	a5,-20(s0)
    802037f8:	2781                	sext.w	a5,a5
    802037fa:	0207ce63          	bltz	a5,80203836 <interrupt_dispatch+0x50>
    802037fe:	fec42783          	lw	a5,-20(s0)
    80203802:	0007871b          	sext.w	a4,a5
    80203806:	03f00793          	li	a5,63
    8020380a:	02e7c663          	blt	a5,a4,80203836 <interrupt_dispatch+0x50>
    8020380e:	00024717          	auipc	a4,0x24
    80203812:	a5a70713          	addi	a4,a4,-1446 # 80227268 <interrupt_vector>
    80203816:	fec42783          	lw	a5,-20(s0)
    8020381a:	078e                	slli	a5,a5,0x3
    8020381c:	97ba                	add	a5,a5,a4
    8020381e:	639c                	ld	a5,0(a5)
    80203820:	cb99                	beqz	a5,80203836 <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    80203822:	00024717          	auipc	a4,0x24
    80203826:	a4670713          	addi	a4,a4,-1466 # 80227268 <interrupt_vector>
    8020382a:	fec42783          	lw	a5,-20(s0)
    8020382e:	078e                	slli	a5,a5,0x3
    80203830:	97ba                	add	a5,a5,a4
    80203832:	639c                	ld	a5,0(a5)
    80203834:	9782                	jalr	a5
}
    80203836:	0001                	nop
    80203838:	60e2                	ld	ra,24(sp)
    8020383a:	6442                	ld	s0,16(sp)
    8020383c:	6105                	addi	sp,sp,32
    8020383e:	8082                	ret

0000000080203840 <handle_external_interrupt>:
void handle_external_interrupt(void) {
    80203840:	1101                	addi	sp,sp,-32
    80203842:	ec06                	sd	ra,24(sp)
    80203844:	e822                	sd	s0,16(sp)
    80203846:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    80203848:	00001097          	auipc	ra,0x1
    8020384c:	39a080e7          	jalr	922(ra) # 80204be2 <plic_claim>
    80203850:	87aa                	mv	a5,a0
    80203852:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    80203856:	fec42783          	lw	a5,-20(s0)
    8020385a:	2781                	sext.w	a5,a5
    8020385c:	eb91                	bnez	a5,80203870 <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    8020385e:	00018517          	auipc	a0,0x18
    80203862:	f1a50513          	addi	a0,a0,-230 # 8021b778 <user_test_table+0x60>
    80203866:	ffffd097          	auipc	ra,0xffffd
    8020386a:	4a0080e7          	jalr	1184(ra) # 80200d06 <printf>
        return;
    8020386e:	a839                	j	8020388c <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    80203870:	fec42783          	lw	a5,-20(s0)
    80203874:	853e                	mv	a0,a5
    80203876:	00000097          	auipc	ra,0x0
    8020387a:	f70080e7          	jalr	-144(ra) # 802037e6 <interrupt_dispatch>
    plic_complete(irq);
    8020387e:	fec42783          	lw	a5,-20(s0)
    80203882:	853e                	mv	a0,a5
    80203884:	00001097          	auipc	ra,0x1
    80203888:	386080e7          	jalr	902(ra) # 80204c0a <plic_complete>
}
    8020388c:	60e2                	ld	ra,24(sp)
    8020388e:	6442                	ld	s0,16(sp)
    80203890:	6105                	addi	sp,sp,32
    80203892:	8082                	ret

0000000080203894 <trap_init>:
void trap_init(void) {
    80203894:	1101                	addi	sp,sp,-32
    80203896:	ec06                	sd	ra,24(sp)
    80203898:	e822                	sd	s0,16(sp)
    8020389a:	1000                	addi	s0,sp,32
	intr_off();
    8020389c:	00000097          	auipc	ra,0x0
    802038a0:	d80080e7          	jalr	-640(ra) # 8020361c <intr_off>
	printf("trap_init...\n");
    802038a4:	00018517          	auipc	a0,0x18
    802038a8:	ef450513          	addi	a0,a0,-268 # 8021b798 <user_test_table+0x80>
    802038ac:	ffffd097          	auipc	ra,0xffffd
    802038b0:	45a080e7          	jalr	1114(ra) # 80200d06 <printf>
	w_stvec((uint64)kernelvec);
    802038b4:	00001797          	auipc	a5,0x1
    802038b8:	38c78793          	addi	a5,a5,908 # 80204c40 <kernelvec>
    802038bc:	853e                	mv	a0,a5
    802038be:	00000097          	auipc	ra,0x0
    802038c2:	d86080e7          	jalr	-634(ra) # 80203644 <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    802038c6:	fe042623          	sw	zero,-20(s0)
    802038ca:	a005                	j	802038ea <trap_init+0x56>
		interrupt_vector[i] = 0;
    802038cc:	00024717          	auipc	a4,0x24
    802038d0:	99c70713          	addi	a4,a4,-1636 # 80227268 <interrupt_vector>
    802038d4:	fec42783          	lw	a5,-20(s0)
    802038d8:	078e                	slli	a5,a5,0x3
    802038da:	97ba                	add	a5,a5,a4
    802038dc:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    802038e0:	fec42783          	lw	a5,-20(s0)
    802038e4:	2785                	addiw	a5,a5,1
    802038e6:	fef42623          	sw	a5,-20(s0)
    802038ea:	fec42783          	lw	a5,-20(s0)
    802038ee:	0007871b          	sext.w	a4,a5
    802038f2:	03f00793          	li	a5,63
    802038f6:	fce7dbe3          	bge	a5,a4,802038cc <trap_init+0x38>
	plic_init();// 初始化PLIC（外部中断控制器）
    802038fa:	00001097          	auipc	ra,0x1
    802038fe:	194080e7          	jalr	404(ra) # 80204a8e <plic_init>
    uint64 sie = r_sie();
    80203902:	00000097          	auipc	ra,0x0
    80203906:	c7e080e7          	jalr	-898(ra) # 80203580 <r_sie>
    8020390a:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    8020390e:	fe043783          	ld	a5,-32(s0)
    80203912:	2207e793          	ori	a5,a5,544
    80203916:	853e                	mv	a0,a5
    80203918:	00000097          	auipc	ra,0x0
    8020391c:	c82080e7          	jalr	-894(ra) # 8020359a <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80203920:	00000097          	auipc	ra,0x0
    80203924:	c18080e7          	jalr	-1000(ra) # 80203538 <sbi_get_time>
    80203928:	872a                	mv	a4,a0
    8020392a:	000f47b7          	lui	a5,0xf4
    8020392e:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    80203932:	97ba                	add	a5,a5,a4
    80203934:	853e                	mv	a0,a5
    80203936:	00000097          	auipc	ra,0x0
    8020393a:	be6080e7          	jalr	-1050(ra) # 8020351c <sbi_set_time>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    8020393e:	00001597          	auipc	a1,0x1
    80203942:	e8058593          	addi	a1,a1,-384 # 802047be <handle_store_page_fault>
    80203946:	00018517          	auipc	a0,0x18
    8020394a:	e6250513          	addi	a0,a0,-414 # 8021b7a8 <user_test_table+0x90>
    8020394e:	ffffd097          	auipc	ra,0xffffd
    80203952:	3b8080e7          	jalr	952(ra) # 80200d06 <printf>
	printf("trap_init complete.\n");
    80203956:	00018517          	auipc	a0,0x18
    8020395a:	e8a50513          	addi	a0,a0,-374 # 8021b7e0 <user_test_table+0xc8>
    8020395e:	ffffd097          	auipc	ra,0xffffd
    80203962:	3a8080e7          	jalr	936(ra) # 80200d06 <printf>
}
    80203966:	0001                	nop
    80203968:	60e2                	ld	ra,24(sp)
    8020396a:	6442                	ld	s0,16(sp)
    8020396c:	6105                	addi	sp,sp,32
    8020396e:	8082                	ret

0000000080203970 <kerneltrap>:
void kerneltrap(void) {
    80203970:	7165                	addi	sp,sp,-400
    80203972:	e706                	sd	ra,392(sp)
    80203974:	e322                	sd	s0,384(sp)
    80203976:	0b00                	addi	s0,sp,400
    uint64 sstatus = r_sstatus();
    80203978:	00000097          	auipc	ra,0x0
    8020397c:	c3c080e7          	jalr	-964(ra) # 802035b4 <r_sstatus>
    80203980:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    80203984:	00000097          	auipc	ra,0x0
    80203988:	cda080e7          	jalr	-806(ra) # 8020365e <r_scause>
    8020398c:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    80203990:	00000097          	auipc	ra,0x0
    80203994:	ce8080e7          	jalr	-792(ra) # 80203678 <r_sepc>
    80203998:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    8020399c:	00000097          	auipc	ra,0x0
    802039a0:	cf6080e7          	jalr	-778(ra) # 80203692 <r_stval>
    802039a4:	fca43823          	sd	a0,-48(s0)
    if(scause & 0x8000000000000000) {
    802039a8:	fd843783          	ld	a5,-40(s0)
    802039ac:	0807da63          	bgez	a5,80203a40 <kerneltrap+0xd0>
        if((scause & 0xff) == 5) {
    802039b0:	fd843783          	ld	a5,-40(s0)
    802039b4:	0ff7f713          	zext.b	a4,a5
    802039b8:	4795                	li	a5,5
    802039ba:	04f71a63          	bne	a4,a5,80203a0e <kerneltrap+0x9e>
            timeintr();
    802039be:	00000097          	auipc	ra,0x0
    802039c2:	b94080e7          	jalr	-1132(ra) # 80203552 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802039c6:	00000097          	auipc	ra,0x0
    802039ca:	b72080e7          	jalr	-1166(ra) # 80203538 <sbi_get_time>
    802039ce:	872a                	mv	a4,a0
    802039d0:	000f47b7          	lui	a5,0xf4
    802039d4:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802039d8:	97ba                	add	a5,a5,a4
    802039da:	853e                	mv	a0,a5
    802039dc:	00000097          	auipc	ra,0x0
    802039e0:	b40080e7          	jalr	-1216(ra) # 8020351c <sbi_set_time>
			if(myproc() && myproc()->state == RUNNING) {
    802039e4:	00001097          	auipc	ra,0x1
    802039e8:	5ac080e7          	jalr	1452(ra) # 80204f90 <myproc>
    802039ec:	87aa                	mv	a5,a0
    802039ee:	cbe9                	beqz	a5,80203ac0 <kerneltrap+0x150>
    802039f0:	00001097          	auipc	ra,0x1
    802039f4:	5a0080e7          	jalr	1440(ra) # 80204f90 <myproc>
    802039f8:	87aa                	mv	a5,a0
    802039fa:	439c                	lw	a5,0(a5)
    802039fc:	873e                	mv	a4,a5
    802039fe:	4791                	li	a5,4
    80203a00:	0cf71063          	bne	a4,a5,80203ac0 <kerneltrap+0x150>
				yield();  // 当前进程让出 CPU
    80203a04:	00002097          	auipc	ra,0x2
    80203a08:	170080e7          	jalr	368(ra) # 80205b74 <yield>
    80203a0c:	a855                	j	80203ac0 <kerneltrap+0x150>
        } else if((scause & 0xff) == 9) {
    80203a0e:	fd843783          	ld	a5,-40(s0)
    80203a12:	0ff7f713          	zext.b	a4,a5
    80203a16:	47a5                	li	a5,9
    80203a18:	00f71763          	bne	a4,a5,80203a26 <kerneltrap+0xb6>
            handle_external_interrupt();
    80203a1c:	00000097          	auipc	ra,0x0
    80203a20:	e24080e7          	jalr	-476(ra) # 80203840 <handle_external_interrupt>
    80203a24:	a871                	j	80203ac0 <kerneltrap+0x150>
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    80203a26:	fe843603          	ld	a2,-24(s0)
    80203a2a:	fd843583          	ld	a1,-40(s0)
    80203a2e:	00018517          	auipc	a0,0x18
    80203a32:	dca50513          	addi	a0,a0,-566 # 8021b7f8 <user_test_table+0xe0>
    80203a36:	ffffd097          	auipc	ra,0xffffd
    80203a3a:	2d0080e7          	jalr	720(ra) # 80200d06 <printf>
    80203a3e:	a049                	j	80203ac0 <kerneltrap+0x150>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    80203a40:	fd043683          	ld	a3,-48(s0)
    80203a44:	fe843603          	ld	a2,-24(s0)
    80203a48:	fd843583          	ld	a1,-40(s0)
    80203a4c:	00018517          	auipc	a0,0x18
    80203a50:	de450513          	addi	a0,a0,-540 # 8021b830 <user_test_table+0x118>
    80203a54:	ffffd097          	auipc	ra,0xffffd
    80203a58:	2b2080e7          	jalr	690(ra) # 80200d06 <printf>
        save_exception_info(&tf, sepc, sstatus, scause, stval);
    80203a5c:	e9840793          	addi	a5,s0,-360
    80203a60:	fd043703          	ld	a4,-48(s0)
    80203a64:	fd843683          	ld	a3,-40(s0)
    80203a68:	fe043603          	ld	a2,-32(s0)
    80203a6c:	fe843583          	ld	a1,-24(s0)
    80203a70:	853e                	mv	a0,a5
    80203a72:	00000097          	auipc	ra,0x0
    80203a76:	c3a080e7          	jalr	-966(ra) # 802036ac <save_exception_info>
        info.sepc = sepc;
    80203a7a:	fe843783          	ld	a5,-24(s0)
    80203a7e:	e6f43c23          	sd	a5,-392(s0)
        info.sstatus = sstatus;
    80203a82:	fe043783          	ld	a5,-32(s0)
    80203a86:	e8f43023          	sd	a5,-384(s0)
        info.scause = scause;
    80203a8a:	fd843783          	ld	a5,-40(s0)
    80203a8e:	e8f43423          	sd	a5,-376(s0)
        info.stval = stval;
    80203a92:	fd043783          	ld	a5,-48(s0)
    80203a96:	e8f43823          	sd	a5,-368(s0)
        handle_exception(&tf, &info);
    80203a9a:	e7840713          	addi	a4,s0,-392
    80203a9e:	e9840793          	addi	a5,s0,-360
    80203aa2:	85ba                	mv	a1,a4
    80203aa4:	853e                	mv	a0,a5
    80203aa6:	00000097          	auipc	ra,0x0
    80203aaa:	03c080e7          	jalr	60(ra) # 80203ae2 <handle_exception>
        sepc = get_sepc(&tf);
    80203aae:	e9840793          	addi	a5,s0,-360
    80203ab2:	853e                	mv	a0,a5
    80203ab4:	00000097          	auipc	ra,0x0
    80203ab8:	c24080e7          	jalr	-988(ra) # 802036d8 <get_sepc>
    80203abc:	fea43423          	sd	a0,-24(s0)
    w_sepc(sepc);
    80203ac0:	fe843503          	ld	a0,-24(s0)
    80203ac4:	00000097          	auipc	ra,0x0
    80203ac8:	b3e080e7          	jalr	-1218(ra) # 80203602 <w_sepc>
    w_sstatus(sstatus);
    80203acc:	fe043503          	ld	a0,-32(s0)
    80203ad0:	00000097          	auipc	ra,0x0
    80203ad4:	afe080e7          	jalr	-1282(ra) # 802035ce <w_sstatus>
}
    80203ad8:	0001                	nop
    80203ada:	60ba                	ld	ra,392(sp)
    80203adc:	641a                	ld	s0,384(sp)
    80203ade:	6159                	addi	sp,sp,400
    80203ae0:	8082                	ret

0000000080203ae2 <handle_exception>:
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    80203ae2:	7139                	addi	sp,sp,-64
    80203ae4:	fc06                	sd	ra,56(sp)
    80203ae6:	f822                	sd	s0,48(sp)
    80203ae8:	0080                	addi	s0,sp,64
    80203aea:	fca43423          	sd	a0,-56(s0)
    80203aee:	fcb43023          	sd	a1,-64(s0)
    uint64 cause = info->scause;  // 使用info中的字段
    80203af2:	fc043783          	ld	a5,-64(s0)
    80203af6:	6b9c                	ld	a5,16(a5)
    80203af8:	fef43423          	sd	a5,-24(s0)
    switch (cause) {
    80203afc:	fe843703          	ld	a4,-24(s0)
    80203b00:	47bd                	li	a5,15
    80203b02:	3ee7e763          	bltu	a5,a4,80203ef0 <handle_exception+0x40e>
    80203b06:	fe843783          	ld	a5,-24(s0)
    80203b0a:	00279713          	slli	a4,a5,0x2
    80203b0e:	00018797          	auipc	a5,0x18
    80203b12:	f3678793          	addi	a5,a5,-202 # 8021ba44 <user_test_table+0x32c>
    80203b16:	97ba                	add	a5,a5,a4
    80203b18:	439c                	lw	a5,0(a5)
    80203b1a:	0007871b          	sext.w	a4,a5
    80203b1e:	00018797          	auipc	a5,0x18
    80203b22:	f2678793          	addi	a5,a5,-218 # 8021ba44 <user_test_table+0x32c>
    80203b26:	97ba                	add	a5,a5,a4
    80203b28:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80203b2a:	fc043783          	ld	a5,-64(s0)
    80203b2e:	6f9c                	ld	a5,24(a5)
    80203b30:	85be                	mv	a1,a5
    80203b32:	00018517          	auipc	a0,0x18
    80203b36:	d2e50513          	addi	a0,a0,-722 # 8021b860 <user_test_table+0x148>
    80203b3a:	ffffd097          	auipc	ra,0xffffd
    80203b3e:	1cc080e7          	jalr	460(ra) # 80200d06 <printf>
			if(myproc()->is_user){
    80203b42:	00001097          	auipc	ra,0x1
    80203b46:	44e080e7          	jalr	1102(ra) # 80204f90 <myproc>
    80203b4a:	87aa                	mv	a5,a0
    80203b4c:	0a87a783          	lw	a5,168(a5)
    80203b50:	c791                	beqz	a5,80203b5c <handle_exception+0x7a>
				exit_proc(-1);
    80203b52:	557d                	li	a0,-1
    80203b54:	00002097          	auipc	ra,0x2
    80203b58:	22e080e7          	jalr	558(ra) # 80205d82 <exit_proc>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203b5c:	fc043783          	ld	a5,-64(s0)
    80203b60:	639c                	ld	a5,0(a5)
    80203b62:	0791                	addi	a5,a5,4
    80203b64:	85be                	mv	a1,a5
    80203b66:	fc843503          	ld	a0,-56(s0)
    80203b6a:	00000097          	auipc	ra,0x0
    80203b6e:	b86080e7          	jalr	-1146(ra) # 802036f0 <set_sepc>
            break;
    80203b72:	ae6d                	j	80203f2c <handle_exception+0x44a>
            printf("Instruction access fault: 0x%lx\n", info->stval);
    80203b74:	fc043783          	ld	a5,-64(s0)
    80203b78:	6f9c                	ld	a5,24(a5)
    80203b7a:	85be                	mv	a1,a5
    80203b7c:	00018517          	auipc	a0,0x18
    80203b80:	d0c50513          	addi	a0,a0,-756 # 8021b888 <user_test_table+0x170>
    80203b84:	ffffd097          	auipc	ra,0xffffd
    80203b88:	182080e7          	jalr	386(ra) # 80200d06 <printf>
			if(myproc()->is_user){
    80203b8c:	00001097          	auipc	ra,0x1
    80203b90:	404080e7          	jalr	1028(ra) # 80204f90 <myproc>
    80203b94:	87aa                	mv	a5,a0
    80203b96:	0a87a783          	lw	a5,168(a5)
    80203b9a:	c791                	beqz	a5,80203ba6 <handle_exception+0xc4>
				exit_proc(-1);
    80203b9c:	557d                	li	a0,-1
    80203b9e:	00002097          	auipc	ra,0x2
    80203ba2:	1e4080e7          	jalr	484(ra) # 80205d82 <exit_proc>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203ba6:	fc043783          	ld	a5,-64(s0)
    80203baa:	639c                	ld	a5,0(a5)
    80203bac:	0791                	addi	a5,a5,4
    80203bae:	85be                	mv	a1,a5
    80203bb0:	fc843503          	ld	a0,-56(s0)
    80203bb4:	00000097          	auipc	ra,0x0
    80203bb8:	b3c080e7          	jalr	-1220(ra) # 802036f0 <set_sepc>
            break;
    80203bbc:	ae85                	j	80203f2c <handle_exception+0x44a>
			if (copyin((char*)&instruction, (uint64)info->sepc, 4) == 0) {
    80203bbe:	fc043783          	ld	a5,-64(s0)
    80203bc2:	6398                	ld	a4,0(a5)
    80203bc4:	fdc40793          	addi	a5,s0,-36
    80203bc8:	4611                	li	a2,4
    80203bca:	85ba                	mv	a1,a4
    80203bcc:	853e                	mv	a0,a5
    80203bce:	00000097          	auipc	ra,0x0
    80203bd2:	3da080e7          	jalr	986(ra) # 80203fa8 <copyin>
    80203bd6:	87aa                	mv	a5,a0
    80203bd8:	ebcd                	bnez	a5,80203c8a <handle_exception+0x1a8>
				uint32_t opcode = instruction & 0x7f;
    80203bda:	fdc42783          	lw	a5,-36(s0)
    80203bde:	07f7f793          	andi	a5,a5,127
    80203be2:	fef42223          	sw	a5,-28(s0)
				uint32_t funct3 = (instruction >> 12) & 0x7;
    80203be6:	fdc42783          	lw	a5,-36(s0)
    80203bea:	00c7d79b          	srliw	a5,a5,0xc
    80203bee:	2781                	sext.w	a5,a5
    80203bf0:	8b9d                	andi	a5,a5,7
    80203bf2:	fef42023          	sw	a5,-32(s0)
				if (opcode == 0x33 && (funct3 == 0x4 || funct3 == 0x5 || 
    80203bf6:	fe442783          	lw	a5,-28(s0)
    80203bfa:	0007871b          	sext.w	a4,a5
    80203bfe:	03300793          	li	a5,51
    80203c02:	06f71363          	bne	a4,a5,80203c68 <handle_exception+0x186>
    80203c06:	fe042783          	lw	a5,-32(s0)
    80203c0a:	0007871b          	sext.w	a4,a5
    80203c0e:	4791                	li	a5,4
    80203c10:	02f70763          	beq	a4,a5,80203c3e <handle_exception+0x15c>
    80203c14:	fe042783          	lw	a5,-32(s0)
    80203c18:	0007871b          	sext.w	a4,a5
    80203c1c:	4795                	li	a5,5
    80203c1e:	02f70063          	beq	a4,a5,80203c3e <handle_exception+0x15c>
    80203c22:	fe042783          	lw	a5,-32(s0)
    80203c26:	0007871b          	sext.w	a4,a5
    80203c2a:	4799                	li	a5,6
    80203c2c:	00f70963          	beq	a4,a5,80203c3e <handle_exception+0x15c>
					funct3 == 0x6 || funct3 == 0x7)) {
    80203c30:	fe042783          	lw	a5,-32(s0)
    80203c34:	0007871b          	sext.w	a4,a5
    80203c38:	479d                	li	a5,7
    80203c3a:	02f71763          	bne	a4,a5,80203c68 <handle_exception+0x186>
					printf("[FATAL] Process %d killed by divide by zero\n", myproc()->pid);
    80203c3e:	00001097          	auipc	ra,0x1
    80203c42:	352080e7          	jalr	850(ra) # 80204f90 <myproc>
    80203c46:	87aa                	mv	a5,a0
    80203c48:	43dc                	lw	a5,4(a5)
    80203c4a:	85be                	mv	a1,a5
    80203c4c:	00018517          	auipc	a0,0x18
    80203c50:	c6450513          	addi	a0,a0,-924 # 8021b8b0 <user_test_table+0x198>
    80203c54:	ffffd097          	auipc	ra,0xffffd
    80203c58:	0b2080e7          	jalr	178(ra) # 80200d06 <printf>
            		exit_proc(-1);  // 直接终止进程
    80203c5c:	557d                	li	a0,-1
    80203c5e:	00002097          	auipc	ra,0x2
    80203c62:	124080e7          	jalr	292(ra) # 80205d82 <exit_proc>
    80203c66:	a091                	j	80203caa <handle_exception+0x1c8>
					printf("Illegal instruction at 0x%lx: 0x%lx\n", 
    80203c68:	fc043783          	ld	a5,-64(s0)
    80203c6c:	6398                	ld	a4,0(a5)
    80203c6e:	fc043783          	ld	a5,-64(s0)
    80203c72:	6f9c                	ld	a5,24(a5)
    80203c74:	863e                	mv	a2,a5
    80203c76:	85ba                	mv	a1,a4
    80203c78:	00018517          	auipc	a0,0x18
    80203c7c:	c6850513          	addi	a0,a0,-920 # 8021b8e0 <user_test_table+0x1c8>
    80203c80:	ffffd097          	auipc	ra,0xffffd
    80203c84:	086080e7          	jalr	134(ra) # 80200d06 <printf>
    80203c88:	a00d                	j	80203caa <handle_exception+0x1c8>
				printf("Illegal instruction at 0x%lx: 0x%lx\n", 
    80203c8a:	fc043783          	ld	a5,-64(s0)
    80203c8e:	6398                	ld	a4,0(a5)
    80203c90:	fc043783          	ld	a5,-64(s0)
    80203c94:	6f9c                	ld	a5,24(a5)
    80203c96:	863e                	mv	a2,a5
    80203c98:	85ba                	mv	a1,a4
    80203c9a:	00018517          	auipc	a0,0x18
    80203c9e:	c4650513          	addi	a0,a0,-954 # 8021b8e0 <user_test_table+0x1c8>
    80203ca2:	ffffd097          	auipc	ra,0xffffd
    80203ca6:	064080e7          	jalr	100(ra) # 80200d06 <printf>
			if(myproc()->is_user){
    80203caa:	00001097          	auipc	ra,0x1
    80203cae:	2e6080e7          	jalr	742(ra) # 80204f90 <myproc>
    80203cb2:	87aa                	mv	a5,a0
    80203cb4:	0a87a783          	lw	a5,168(a5)
    80203cb8:	c791                	beqz	a5,80203cc4 <handle_exception+0x1e2>
				exit_proc(-1);
    80203cba:	557d                	li	a0,-1
    80203cbc:	00002097          	auipc	ra,0x2
    80203cc0:	0c6080e7          	jalr	198(ra) # 80205d82 <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203cc4:	fc043783          	ld	a5,-64(s0)
    80203cc8:	639c                	ld	a5,0(a5)
    80203cca:	0791                	addi	a5,a5,4
    80203ccc:	85be                	mv	a1,a5
    80203cce:	fc843503          	ld	a0,-56(s0)
    80203cd2:	00000097          	auipc	ra,0x0
    80203cd6:	a1e080e7          	jalr	-1506(ra) # 802036f0 <set_sepc>
			break;
    80203cda:	ac89                	j	80203f2c <handle_exception+0x44a>
            printf("Breakpoint at 0x%lx\n", info->sepc);
    80203cdc:	fc043783          	ld	a5,-64(s0)
    80203ce0:	639c                	ld	a5,0(a5)
    80203ce2:	85be                	mv	a1,a5
    80203ce4:	00018517          	auipc	a0,0x18
    80203ce8:	c2450513          	addi	a0,a0,-988 # 8021b908 <user_test_table+0x1f0>
    80203cec:	ffffd097          	auipc	ra,0xffffd
    80203cf0:	01a080e7          	jalr	26(ra) # 80200d06 <printf>
            set_sepc(tf, info->sepc + 4);
    80203cf4:	fc043783          	ld	a5,-64(s0)
    80203cf8:	639c                	ld	a5,0(a5)
    80203cfa:	0791                	addi	a5,a5,4
    80203cfc:	85be                	mv	a1,a5
    80203cfe:	fc843503          	ld	a0,-56(s0)
    80203d02:	00000097          	auipc	ra,0x0
    80203d06:	9ee080e7          	jalr	-1554(ra) # 802036f0 <set_sepc>
            break;
    80203d0a:	a40d                	j	80203f2c <handle_exception+0x44a>
            printf("Load address misaligned: 0x%lx\n", info->stval);
    80203d0c:	fc043783          	ld	a5,-64(s0)
    80203d10:	6f9c                	ld	a5,24(a5)
    80203d12:	85be                	mv	a1,a5
    80203d14:	00018517          	auipc	a0,0x18
    80203d18:	c0c50513          	addi	a0,a0,-1012 # 8021b920 <user_test_table+0x208>
    80203d1c:	ffffd097          	auipc	ra,0xffffd
    80203d20:	fea080e7          	jalr	-22(ra) # 80200d06 <printf>
			if(myproc()->is_user){
    80203d24:	00001097          	auipc	ra,0x1
    80203d28:	26c080e7          	jalr	620(ra) # 80204f90 <myproc>
    80203d2c:	87aa                	mv	a5,a0
    80203d2e:	0a87a783          	lw	a5,168(a5)
    80203d32:	c791                	beqz	a5,80203d3e <handle_exception+0x25c>
				exit_proc(-1);
    80203d34:	557d                	li	a0,-1
    80203d36:	00002097          	auipc	ra,0x2
    80203d3a:	04c080e7          	jalr	76(ra) # 80205d82 <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203d3e:	fc043783          	ld	a5,-64(s0)
    80203d42:	639c                	ld	a5,0(a5)
    80203d44:	0791                	addi	a5,a5,4
    80203d46:	85be                	mv	a1,a5
    80203d48:	fc843503          	ld	a0,-56(s0)
    80203d4c:	00000097          	auipc	ra,0x0
    80203d50:	9a4080e7          	jalr	-1628(ra) # 802036f0 <set_sepc>
            break;
    80203d54:	aae1                	j	80203f2c <handle_exception+0x44a>
			printf("Load access fault: 0x%lx\n", info->stval);
    80203d56:	fc043783          	ld	a5,-64(s0)
    80203d5a:	6f9c                	ld	a5,24(a5)
    80203d5c:	85be                	mv	a1,a5
    80203d5e:	00018517          	auipc	a0,0x18
    80203d62:	be250513          	addi	a0,a0,-1054 # 8021b940 <user_test_table+0x228>
    80203d66:	ffffd097          	auipc	ra,0xffffd
    80203d6a:	fa0080e7          	jalr	-96(ra) # 80200d06 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
    80203d6e:	fc043783          	ld	a5,-64(s0)
    80203d72:	6f9c                	ld	a5,24(a5)
    80203d74:	853e                	mv	a0,a5
    80203d76:	fffff097          	auipc	ra,0xfffff
    80203d7a:	2da080e7          	jalr	730(ra) # 80203050 <check_is_mapped>
    80203d7e:	87aa                	mv	a5,a0
    80203d80:	cf89                	beqz	a5,80203d9a <handle_exception+0x2b8>
    80203d82:	fc043783          	ld	a5,-64(s0)
    80203d86:	6f9c                	ld	a5,24(a5)
    80203d88:	4589                	li	a1,2
    80203d8a:	853e                	mv	a0,a5
    80203d8c:	fffff097          	auipc	ra,0xfffff
    80203d90:	c68080e7          	jalr	-920(ra) # 802029f4 <handle_page_fault>
    80203d94:	87aa                	mv	a5,a0
    80203d96:	18079863          	bnez	a5,80203f26 <handle_exception+0x444>
			set_sepc(tf, info->sepc + 4);
    80203d9a:	fc043783          	ld	a5,-64(s0)
    80203d9e:	639c                	ld	a5,0(a5)
    80203da0:	0791                	addi	a5,a5,4
    80203da2:	85be                	mv	a1,a5
    80203da4:	fc843503          	ld	a0,-56(s0)
    80203da8:	00000097          	auipc	ra,0x0
    80203dac:	948080e7          	jalr	-1720(ra) # 802036f0 <set_sepc>
			break;
    80203db0:	aab5                	j	80203f2c <handle_exception+0x44a>
            printf("Store address misaligned: 0x%lx\n", info->stval);
    80203db2:	fc043783          	ld	a5,-64(s0)
    80203db6:	6f9c                	ld	a5,24(a5)
    80203db8:	85be                	mv	a1,a5
    80203dba:	00018517          	auipc	a0,0x18
    80203dbe:	ba650513          	addi	a0,a0,-1114 # 8021b960 <user_test_table+0x248>
    80203dc2:	ffffd097          	auipc	ra,0xffffd
    80203dc6:	f44080e7          	jalr	-188(ra) # 80200d06 <printf>
			if(myproc()->is_user){
    80203dca:	00001097          	auipc	ra,0x1
    80203dce:	1c6080e7          	jalr	454(ra) # 80204f90 <myproc>
    80203dd2:	87aa                	mv	a5,a0
    80203dd4:	0a87a783          	lw	a5,168(a5)
    80203dd8:	c791                	beqz	a5,80203de4 <handle_exception+0x302>
				exit_proc(-1);
    80203dda:	557d                	li	a0,-1
    80203ddc:	00002097          	auipc	ra,0x2
    80203de0:	fa6080e7          	jalr	-90(ra) # 80205d82 <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203de4:	fc043783          	ld	a5,-64(s0)
    80203de8:	639c                	ld	a5,0(a5)
    80203dea:	0791                	addi	a5,a5,4
    80203dec:	85be                	mv	a1,a5
    80203dee:	fc843503          	ld	a0,-56(s0)
    80203df2:	00000097          	auipc	ra,0x0
    80203df6:	8fe080e7          	jalr	-1794(ra) # 802036f0 <set_sepc>
            break;
    80203dfa:	aa0d                	j	80203f2c <handle_exception+0x44a>
			printf("Store access fault: 0x%lx\n", info->stval);
    80203dfc:	fc043783          	ld	a5,-64(s0)
    80203e00:	6f9c                	ld	a5,24(a5)
    80203e02:	85be                	mv	a1,a5
    80203e04:	00018517          	auipc	a0,0x18
    80203e08:	b8450513          	addi	a0,a0,-1148 # 8021b988 <user_test_table+0x270>
    80203e0c:	ffffd097          	auipc	ra,0xffffd
    80203e10:	efa080e7          	jalr	-262(ra) # 80200d06 <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
    80203e14:	fc043783          	ld	a5,-64(s0)
    80203e18:	6f9c                	ld	a5,24(a5)
    80203e1a:	853e                	mv	a0,a5
    80203e1c:	fffff097          	auipc	ra,0xfffff
    80203e20:	234080e7          	jalr	564(ra) # 80203050 <check_is_mapped>
    80203e24:	87aa                	mv	a5,a0
    80203e26:	cf81                	beqz	a5,80203e3e <handle_exception+0x35c>
    80203e28:	fc043783          	ld	a5,-64(s0)
    80203e2c:	6f9c                	ld	a5,24(a5)
    80203e2e:	458d                	li	a1,3
    80203e30:	853e                	mv	a0,a5
    80203e32:	fffff097          	auipc	ra,0xfffff
    80203e36:	bc2080e7          	jalr	-1086(ra) # 802029f4 <handle_page_fault>
    80203e3a:	87aa                	mv	a5,a0
    80203e3c:	e7fd                	bnez	a5,80203f2a <handle_exception+0x448>
			set_sepc(tf, info->sepc + 4);
    80203e3e:	fc043783          	ld	a5,-64(s0)
    80203e42:	639c                	ld	a5,0(a5)
    80203e44:	0791                	addi	a5,a5,4
    80203e46:	85be                	mv	a1,a5
    80203e48:	fc843503          	ld	a0,-56(s0)
    80203e4c:	00000097          	auipc	ra,0x0
    80203e50:	8a4080e7          	jalr	-1884(ra) # 802036f0 <set_sepc>
			break;
    80203e54:	a8e1                	j	80203f2c <handle_exception+0x44a>
			if(myproc()->is_user){
    80203e56:	00001097          	auipc	ra,0x1
    80203e5a:	13a080e7          	jalr	314(ra) # 80204f90 <myproc>
    80203e5e:	87aa                	mv	a5,a0
    80203e60:	0a87a783          	lw	a5,168(a5)
    80203e64:	cb91                	beqz	a5,80203e78 <handle_exception+0x396>
            	handle_syscall(tf,info);
    80203e66:	fc043583          	ld	a1,-64(s0)
    80203e6a:	fc843503          	ld	a0,-56(s0)
    80203e6e:	00000097          	auipc	ra,0x0
    80203e72:	42a080e7          	jalr	1066(ra) # 80204298 <handle_syscall>
            break;
    80203e76:	a85d                	j	80203f2c <handle_exception+0x44a>
				warning("[EXCEPTION] ecall was called in S-mode");
    80203e78:	00018517          	auipc	a0,0x18
    80203e7c:	b3050513          	addi	a0,a0,-1232 # 8021b9a8 <user_test_table+0x290>
    80203e80:	ffffe097          	auipc	ra,0xffffe
    80203e84:	906080e7          	jalr	-1786(ra) # 80201786 <warning>
            break;
    80203e88:	a055                	j	80203f2c <handle_exception+0x44a>
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    80203e8a:	fc043783          	ld	a5,-64(s0)
    80203e8e:	639c                	ld	a5,0(a5)
    80203e90:	85be                	mv	a1,a5
    80203e92:	00018517          	auipc	a0,0x18
    80203e96:	b3e50513          	addi	a0,a0,-1218 # 8021b9d0 <user_test_table+0x2b8>
    80203e9a:	ffffd097          	auipc	ra,0xffffd
    80203e9e:	e6c080e7          	jalr	-404(ra) # 80200d06 <printf>
			set_sepc(tf, info->sepc + 4); 
    80203ea2:	fc043783          	ld	a5,-64(s0)
    80203ea6:	639c                	ld	a5,0(a5)
    80203ea8:	0791                	addi	a5,a5,4
    80203eaa:	85be                	mv	a1,a5
    80203eac:	fc843503          	ld	a0,-56(s0)
    80203eb0:	00000097          	auipc	ra,0x0
    80203eb4:	840080e7          	jalr	-1984(ra) # 802036f0 <set_sepc>
            break;
    80203eb8:	a895                	j	80203f2c <handle_exception+0x44a>
            handle_instruction_page_fault(tf,info);
    80203eba:	fc043583          	ld	a1,-64(s0)
    80203ebe:	fc843503          	ld	a0,-56(s0)
    80203ec2:	00001097          	auipc	ra,0x1
    80203ec6:	838080e7          	jalr	-1992(ra) # 802046fa <handle_instruction_page_fault>
            break;
    80203eca:	a08d                	j	80203f2c <handle_exception+0x44a>
            handle_load_page_fault(tf,info);
    80203ecc:	fc043583          	ld	a1,-64(s0)
    80203ed0:	fc843503          	ld	a0,-56(s0)
    80203ed4:	00001097          	auipc	ra,0x1
    80203ed8:	888080e7          	jalr	-1912(ra) # 8020475c <handle_load_page_fault>
            break;
    80203edc:	a881                	j	80203f2c <handle_exception+0x44a>
            handle_store_page_fault(tf,info);
    80203ede:	fc043583          	ld	a1,-64(s0)
    80203ee2:	fc843503          	ld	a0,-56(s0)
    80203ee6:	00001097          	auipc	ra,0x1
    80203eea:	8d8080e7          	jalr	-1832(ra) # 802047be <handle_store_page_fault>
            break;
    80203eee:	a83d                	j	80203f2c <handle_exception+0x44a>
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    80203ef0:	fc043783          	ld	a5,-64(s0)
    80203ef4:	6398                	ld	a4,0(a5)
    80203ef6:	fc043783          	ld	a5,-64(s0)
    80203efa:	6f9c                	ld	a5,24(a5)
    80203efc:	86be                	mv	a3,a5
    80203efe:	863a                	mv	a2,a4
    80203f00:	fe843583          	ld	a1,-24(s0)
    80203f04:	00018517          	auipc	a0,0x18
    80203f08:	af450513          	addi	a0,a0,-1292 # 8021b9f8 <user_test_table+0x2e0>
    80203f0c:	ffffd097          	auipc	ra,0xffffd
    80203f10:	dfa080e7          	jalr	-518(ra) # 80200d06 <printf>
            panic("Unknown exception");
    80203f14:	00018517          	auipc	a0,0x18
    80203f18:	b1c50513          	addi	a0,a0,-1252 # 8021ba30 <user_test_table+0x318>
    80203f1c:	ffffe097          	auipc	ra,0xffffe
    80203f20:	836080e7          	jalr	-1994(ra) # 80201752 <panic>
            break;
    80203f24:	a021                	j	80203f2c <handle_exception+0x44a>
				return; // 成功处理
    80203f26:	0001                	nop
    80203f28:	a011                	j	80203f2c <handle_exception+0x44a>
				return; // 成功处理
    80203f2a:	0001                	nop
}
    80203f2c:	70e2                	ld	ra,56(sp)
    80203f2e:	7442                	ld	s0,48(sp)
    80203f30:	6121                	addi	sp,sp,64
    80203f32:	8082                	ret

0000000080203f34 <user_va2pa>:
void* user_va2pa(pagetable_t pagetable, uint64 va) {
    80203f34:	7179                	addi	sp,sp,-48
    80203f36:	f406                	sd	ra,40(sp)
    80203f38:	f022                	sd	s0,32(sp)
    80203f3a:	1800                	addi	s0,sp,48
    80203f3c:	fca43c23          	sd	a0,-40(s0)
    80203f40:	fcb43823          	sd	a1,-48(s0)
    pte_t *pte = walk_lookup(pagetable, va);
    80203f44:	fd043583          	ld	a1,-48(s0)
    80203f48:	fd843503          	ld	a0,-40(s0)
    80203f4c:	ffffe097          	auipc	ra,0xffffe
    80203f50:	1dc080e7          	jalr	476(ra) # 80202128 <walk_lookup>
    80203f54:	fea43423          	sd	a0,-24(s0)
    if (!pte) return 0;
    80203f58:	fe843783          	ld	a5,-24(s0)
    80203f5c:	e399                	bnez	a5,80203f62 <user_va2pa+0x2e>
    80203f5e:	4781                	li	a5,0
    80203f60:	a83d                	j	80203f9e <user_va2pa+0x6a>
    if (!(*pte & PTE_V)) return 0;
    80203f62:	fe843783          	ld	a5,-24(s0)
    80203f66:	639c                	ld	a5,0(a5)
    80203f68:	8b85                	andi	a5,a5,1
    80203f6a:	e399                	bnez	a5,80203f70 <user_va2pa+0x3c>
    80203f6c:	4781                	li	a5,0
    80203f6e:	a805                	j	80203f9e <user_va2pa+0x6a>
    if (!(*pte & PTE_U)) return 0; // 必须是用户可访问
    80203f70:	fe843783          	ld	a5,-24(s0)
    80203f74:	639c                	ld	a5,0(a5)
    80203f76:	8bc1                	andi	a5,a5,16
    80203f78:	e399                	bnez	a5,80203f7e <user_va2pa+0x4a>
    80203f7a:	4781                	li	a5,0
    80203f7c:	a00d                	j	80203f9e <user_va2pa+0x6a>
    uint64 pa = (PTE2PA(*pte)) | (va & 0xFFF); // 物理页基址 + 页内偏移
    80203f7e:	fe843783          	ld	a5,-24(s0)
    80203f82:	639c                	ld	a5,0(a5)
    80203f84:	83a9                	srli	a5,a5,0xa
    80203f86:	00c79713          	slli	a4,a5,0xc
    80203f8a:	fd043683          	ld	a3,-48(s0)
    80203f8e:	6785                	lui	a5,0x1
    80203f90:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203f92:	8ff5                	and	a5,a5,a3
    80203f94:	8fd9                	or	a5,a5,a4
    80203f96:	fef43023          	sd	a5,-32(s0)
    return (void*)pa;
    80203f9a:	fe043783          	ld	a5,-32(s0)
}
    80203f9e:	853e                	mv	a0,a5
    80203fa0:	70a2                	ld	ra,40(sp)
    80203fa2:	7402                	ld	s0,32(sp)
    80203fa4:	6145                	addi	sp,sp,48
    80203fa6:	8082                	ret

0000000080203fa8 <copyin>:
int copyin(char *dst, uint64 srcva, int maxlen) {
    80203fa8:	715d                	addi	sp,sp,-80
    80203faa:	e486                	sd	ra,72(sp)
    80203fac:	e0a2                	sd	s0,64(sp)
    80203fae:	0880                	addi	s0,sp,80
    80203fb0:	fca43423          	sd	a0,-56(s0)
    80203fb4:	fcb43023          	sd	a1,-64(s0)
    80203fb8:	87b2                	mv	a5,a2
    80203fba:	faf42e23          	sw	a5,-68(s0)
    struct proc *p = myproc();
    80203fbe:	00001097          	auipc	ra,0x1
    80203fc2:	fd2080e7          	jalr	-46(ra) # 80204f90 <myproc>
    80203fc6:	fea43023          	sd	a0,-32(s0)
    for (int i = 0; i < maxlen; i++) {
    80203fca:	fe042623          	sw	zero,-20(s0)
    80203fce:	a085                	j	8020402e <copyin+0x86>
        char *pa = user_va2pa(p->pagetable, srcva + i);
    80203fd0:	fe043783          	ld	a5,-32(s0)
    80203fd4:	7fd4                	ld	a3,184(a5)
    80203fd6:	fec42703          	lw	a4,-20(s0)
    80203fda:	fc043783          	ld	a5,-64(s0)
    80203fde:	97ba                	add	a5,a5,a4
    80203fe0:	85be                	mv	a1,a5
    80203fe2:	8536                	mv	a0,a3
    80203fe4:	00000097          	auipc	ra,0x0
    80203fe8:	f50080e7          	jalr	-176(ra) # 80203f34 <user_va2pa>
    80203fec:	fca43c23          	sd	a0,-40(s0)
        if (!pa) return -1;
    80203ff0:	fd843783          	ld	a5,-40(s0)
    80203ff4:	e399                	bnez	a5,80203ffa <copyin+0x52>
    80203ff6:	57fd                	li	a5,-1
    80203ff8:	a0a9                	j	80204042 <copyin+0x9a>
        dst[i] = *pa;
    80203ffa:	fec42783          	lw	a5,-20(s0)
    80203ffe:	fc843703          	ld	a4,-56(s0)
    80204002:	97ba                	add	a5,a5,a4
    80204004:	fd843703          	ld	a4,-40(s0)
    80204008:	00074703          	lbu	a4,0(a4)
    8020400c:	00e78023          	sb	a4,0(a5)
        if (dst[i] == 0) return 0;
    80204010:	fec42783          	lw	a5,-20(s0)
    80204014:	fc843703          	ld	a4,-56(s0)
    80204018:	97ba                	add	a5,a5,a4
    8020401a:	0007c783          	lbu	a5,0(a5)
    8020401e:	e399                	bnez	a5,80204024 <copyin+0x7c>
    80204020:	4781                	li	a5,0
    80204022:	a005                	j	80204042 <copyin+0x9a>
    for (int i = 0; i < maxlen; i++) {
    80204024:	fec42783          	lw	a5,-20(s0)
    80204028:	2785                	addiw	a5,a5,1
    8020402a:	fef42623          	sw	a5,-20(s0)
    8020402e:	fec42783          	lw	a5,-20(s0)
    80204032:	873e                	mv	a4,a5
    80204034:	fbc42783          	lw	a5,-68(s0)
    80204038:	2701                	sext.w	a4,a4
    8020403a:	2781                	sext.w	a5,a5
    8020403c:	f8f74ae3          	blt	a4,a5,80203fd0 <copyin+0x28>
    return 0;
    80204040:	4781                	li	a5,0
}
    80204042:	853e                	mv	a0,a5
    80204044:	60a6                	ld	ra,72(sp)
    80204046:	6406                	ld	s0,64(sp)
    80204048:	6161                	addi	sp,sp,80
    8020404a:	8082                	ret

000000008020404c <copyout>:
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    8020404c:	7139                	addi	sp,sp,-64
    8020404e:	fc06                	sd	ra,56(sp)
    80204050:	f822                	sd	s0,48(sp)
    80204052:	0080                	addi	s0,sp,64
    80204054:	fca43c23          	sd	a0,-40(s0)
    80204058:	fcb43823          	sd	a1,-48(s0)
    8020405c:	fcc43423          	sd	a2,-56(s0)
    80204060:	fcd43023          	sd	a3,-64(s0)
    for (uint64 i = 0; i < len; i++) {
    80204064:	fe043423          	sd	zero,-24(s0)
    80204068:	a0a1                	j	802040b0 <copyout+0x64>
        char *pa = user_va2pa(pagetable, dstva + i);
    8020406a:	fd043703          	ld	a4,-48(s0)
    8020406e:	fe843783          	ld	a5,-24(s0)
    80204072:	97ba                	add	a5,a5,a4
    80204074:	85be                	mv	a1,a5
    80204076:	fd843503          	ld	a0,-40(s0)
    8020407a:	00000097          	auipc	ra,0x0
    8020407e:	eba080e7          	jalr	-326(ra) # 80203f34 <user_va2pa>
    80204082:	fea43023          	sd	a0,-32(s0)
        if (!pa) return -1;
    80204086:	fe043783          	ld	a5,-32(s0)
    8020408a:	e399                	bnez	a5,80204090 <copyout+0x44>
    8020408c:	57fd                	li	a5,-1
    8020408e:	a805                	j	802040be <copyout+0x72>
        *pa = src[i];
    80204090:	fc843703          	ld	a4,-56(s0)
    80204094:	fe843783          	ld	a5,-24(s0)
    80204098:	97ba                	add	a5,a5,a4
    8020409a:	0007c703          	lbu	a4,0(a5)
    8020409e:	fe043783          	ld	a5,-32(s0)
    802040a2:	00e78023          	sb	a4,0(a5)
    for (uint64 i = 0; i < len; i++) {
    802040a6:	fe843783          	ld	a5,-24(s0)
    802040aa:	0785                	addi	a5,a5,1
    802040ac:	fef43423          	sd	a5,-24(s0)
    802040b0:	fe843703          	ld	a4,-24(s0)
    802040b4:	fc043783          	ld	a5,-64(s0)
    802040b8:	faf769e3          	bltu	a4,a5,8020406a <copyout+0x1e>
    return 0;
    802040bc:	4781                	li	a5,0
}
    802040be:	853e                	mv	a0,a5
    802040c0:	70e2                	ld	ra,56(sp)
    802040c2:	7442                	ld	s0,48(sp)
    802040c4:	6121                	addi	sp,sp,64
    802040c6:	8082                	ret

00000000802040c8 <copyinstr>:
int copyinstr(char *dst, pagetable_t pagetable, uint64 srcva, int max) {
    802040c8:	7139                	addi	sp,sp,-64
    802040ca:	fc06                	sd	ra,56(sp)
    802040cc:	f822                	sd	s0,48(sp)
    802040ce:	0080                	addi	s0,sp,64
    802040d0:	fca43c23          	sd	a0,-40(s0)
    802040d4:	fcb43823          	sd	a1,-48(s0)
    802040d8:	fcc43423          	sd	a2,-56(s0)
    802040dc:	87b6                	mv	a5,a3
    802040de:	fcf42223          	sw	a5,-60(s0)
    for (i = 0; i < max; i++) {
    802040e2:	fe042623          	sw	zero,-20(s0)
    802040e6:	a0b9                	j	80204134 <copyinstr+0x6c>
        if (copyin(&c, srcva + i, 1) < 0)  // 每次拷贝 1 字节
    802040e8:	fec42703          	lw	a4,-20(s0)
    802040ec:	fc843783          	ld	a5,-56(s0)
    802040f0:	973e                	add	a4,a4,a5
    802040f2:	feb40793          	addi	a5,s0,-21
    802040f6:	4605                	li	a2,1
    802040f8:	85ba                	mv	a1,a4
    802040fa:	853e                	mv	a0,a5
    802040fc:	00000097          	auipc	ra,0x0
    80204100:	eac080e7          	jalr	-340(ra) # 80203fa8 <copyin>
    80204104:	87aa                	mv	a5,a0
    80204106:	0007d463          	bgez	a5,8020410e <copyinstr+0x46>
            return -1;
    8020410a:	57fd                	li	a5,-1
    8020410c:	a0b1                	j	80204158 <copyinstr+0x90>
        dst[i] = c;
    8020410e:	fec42783          	lw	a5,-20(s0)
    80204112:	fd843703          	ld	a4,-40(s0)
    80204116:	97ba                	add	a5,a5,a4
    80204118:	feb44703          	lbu	a4,-21(s0)
    8020411c:	00e78023          	sb	a4,0(a5)
        if (c == '\0')
    80204120:	feb44783          	lbu	a5,-21(s0)
    80204124:	e399                	bnez	a5,8020412a <copyinstr+0x62>
            return 0;
    80204126:	4781                	li	a5,0
    80204128:	a805                	j	80204158 <copyinstr+0x90>
    for (i = 0; i < max; i++) {
    8020412a:	fec42783          	lw	a5,-20(s0)
    8020412e:	2785                	addiw	a5,a5,1
    80204130:	fef42623          	sw	a5,-20(s0)
    80204134:	fec42783          	lw	a5,-20(s0)
    80204138:	873e                	mv	a4,a5
    8020413a:	fc442783          	lw	a5,-60(s0)
    8020413e:	2701                	sext.w	a4,a4
    80204140:	2781                	sext.w	a5,a5
    80204142:	faf743e3          	blt	a4,a5,802040e8 <copyinstr+0x20>
    dst[max-1] = '\0';
    80204146:	fc442783          	lw	a5,-60(s0)
    8020414a:	17fd                	addi	a5,a5,-1
    8020414c:	fd843703          	ld	a4,-40(s0)
    80204150:	97ba                	add	a5,a5,a4
    80204152:	00078023          	sb	zero,0(a5)
    return -1; // 超过最大长度还没遇到 \0
    80204156:	57fd                	li	a5,-1
}
    80204158:	853e                	mv	a0,a5
    8020415a:	70e2                	ld	ra,56(sp)
    8020415c:	7442                	ld	s0,48(sp)
    8020415e:	6121                	addi	sp,sp,64
    80204160:	8082                	ret

0000000080204162 <check_user_addr>:
int check_user_addr(uint64 addr, uint64 size, int write) {
    80204162:	7179                	addi	sp,sp,-48
    80204164:	f422                	sd	s0,40(sp)
    80204166:	1800                	addi	s0,sp,48
    80204168:	fea43423          	sd	a0,-24(s0)
    8020416c:	feb43023          	sd	a1,-32(s0)
    80204170:	87b2                	mv	a5,a2
    80204172:	fcf42e23          	sw	a5,-36(s0)
    if (!IS_USER_ADDR(addr) || !IS_USER_ADDR(addr + size - 1))
    80204176:	fe843703          	ld	a4,-24(s0)
    8020417a:	67c1                	lui	a5,0x10
    8020417c:	02f76d63          	bltu	a4,a5,802041b6 <check_user_addr+0x54>
    80204180:	fe843703          	ld	a4,-24(s0)
    80204184:	57fd                	li	a5,-1
    80204186:	83e5                	srli	a5,a5,0x19
    80204188:	02e7e763          	bltu	a5,a4,802041b6 <check_user_addr+0x54>
    8020418c:	fe843703          	ld	a4,-24(s0)
    80204190:	fe043783          	ld	a5,-32(s0)
    80204194:	97ba                	add	a5,a5,a4
    80204196:	fff78713          	addi	a4,a5,-1 # ffff <_entry-0x801f0001>
    8020419a:	67c1                	lui	a5,0x10
    8020419c:	00f76d63          	bltu	a4,a5,802041b6 <check_user_addr+0x54>
    802041a0:	fe843703          	ld	a4,-24(s0)
    802041a4:	fe043783          	ld	a5,-32(s0)
    802041a8:	97ba                	add	a5,a5,a4
    802041aa:	fff78713          	addi	a4,a5,-1 # ffff <_entry-0x801f0001>
    802041ae:	57fd                	li	a5,-1
    802041b0:	83e5                	srli	a5,a5,0x19
    802041b2:	00e7f463          	bgeu	a5,a4,802041ba <check_user_addr+0x58>
        return -1;
    802041b6:	57fd                	li	a5,-1
    802041b8:	a8e1                	j	80204290 <check_user_addr+0x12e>
    if (IS_USER_STACK(addr)) {
    802041ba:	fe843703          	ld	a4,-24(s0)
    802041be:	ddfff7b7          	lui	a5,0xddfff
    802041c2:	07b6                	slli	a5,a5,0xd
    802041c4:	83e5                	srli	a5,a5,0x19
    802041c6:	04e7f663          	bgeu	a5,a4,80204212 <check_user_addr+0xb0>
    802041ca:	fe843703          	ld	a4,-24(s0)
    802041ce:	fdfff7b7          	lui	a5,0xfdfff
    802041d2:	07b6                	slli	a5,a5,0xd
    802041d4:	83e5                	srli	a5,a5,0x19
    802041d6:	02e7ee63          	bltu	a5,a4,80204212 <check_user_addr+0xb0>
        if (!IS_USER_STACK(addr + size - 1))
    802041da:	fe843703          	ld	a4,-24(s0)
    802041de:	fe043783          	ld	a5,-32(s0)
    802041e2:	97ba                	add	a5,a5,a4
    802041e4:	fff78713          	addi	a4,a5,-1 # fffffffffdffefff <_bss_end+0xffffffff7ddd790f>
    802041e8:	ddfff7b7          	lui	a5,0xddfff
    802041ec:	07b6                	slli	a5,a5,0xd
    802041ee:	83e5                	srli	a5,a5,0x19
    802041f0:	00e7ff63          	bgeu	a5,a4,8020420e <check_user_addr+0xac>
    802041f4:	fe843703          	ld	a4,-24(s0)
    802041f8:	fe043783          	ld	a5,-32(s0)
    802041fc:	97ba                	add	a5,a5,a4
    802041fe:	fff78713          	addi	a4,a5,-1 # ffffffffddffefff <_bss_end+0xffffffff5ddd790f>
    80204202:	fdfff7b7          	lui	a5,0xfdfff
    80204206:	07b6                	slli	a5,a5,0xd
    80204208:	83e5                	srli	a5,a5,0x19
    8020420a:	06e7ff63          	bgeu	a5,a4,80204288 <check_user_addr+0x126>
            return -1;  // 跨越栈边界
    8020420e:	57fd                	li	a5,-1
    80204210:	a041                	j	80204290 <check_user_addr+0x12e>
    } else if (IS_USER_HEAP(addr)) {
    80204212:	fe843703          	ld	a4,-24(s0)
    80204216:	004007b7          	lui	a5,0x400
    8020421a:	04f76463          	bltu	a4,a5,80204262 <check_user_addr+0x100>
    8020421e:	fe843703          	ld	a4,-24(s0)
    80204222:	ddfff7b7          	lui	a5,0xddfff
    80204226:	07b6                	slli	a5,a5,0xd
    80204228:	83e5                	srli	a5,a5,0x19
    8020422a:	02e7ec63          	bltu	a5,a4,80204262 <check_user_addr+0x100>
        if (!IS_USER_HEAP(addr + size - 1))
    8020422e:	fe843703          	ld	a4,-24(s0)
    80204232:	fe043783          	ld	a5,-32(s0)
    80204236:	97ba                	add	a5,a5,a4
    80204238:	fff78713          	addi	a4,a5,-1 # ffffffffddffefff <_bss_end+0xffffffff5ddd790f>
    8020423c:	004007b7          	lui	a5,0x400
    80204240:	00f76f63          	bltu	a4,a5,8020425e <check_user_addr+0xfc>
    80204244:	fe843703          	ld	a4,-24(s0)
    80204248:	fe043783          	ld	a5,-32(s0)
    8020424c:	97ba                	add	a5,a5,a4
    8020424e:	fff78713          	addi	a4,a5,-1 # 3fffff <_entry-0x7fe00001>
    80204252:	ddfff7b7          	lui	a5,0xddfff
    80204256:	07b6                	slli	a5,a5,0xd
    80204258:	83e5                	srli	a5,a5,0x19
    8020425a:	02e7f963          	bgeu	a5,a4,8020428c <check_user_addr+0x12a>
            return -1;  // 跨越堆边界
    8020425e:	57fd                	li	a5,-1
    80204260:	a805                	j	80204290 <check_user_addr+0x12e>
    } else if (addr < USER_HEAP_START) {
    80204262:	fe843703          	ld	a4,-24(s0)
    80204266:	004007b7          	lui	a5,0x400
    8020426a:	00f77d63          	bgeu	a4,a5,80204284 <check_user_addr+0x122>
        if (addr + size > USER_HEAP_START)
    8020426e:	fe843703          	ld	a4,-24(s0)
    80204272:	fe043783          	ld	a5,-32(s0)
    80204276:	973e                	add	a4,a4,a5
    80204278:	004007b7          	lui	a5,0x400
    8020427c:	00e7f963          	bgeu	a5,a4,8020428e <check_user_addr+0x12c>
            return -1;  // 跨越代码/数据段边界
    80204280:	57fd                	li	a5,-1
    80204282:	a039                	j	80204290 <check_user_addr+0x12e>
        return -1;  // 在未定义区域
    80204284:	57fd                	li	a5,-1
    80204286:	a029                	j	80204290 <check_user_addr+0x12e>
        if (!IS_USER_STACK(addr + size - 1))
    80204288:	0001                	nop
    8020428a:	a011                	j	8020428e <check_user_addr+0x12c>
        if (!IS_USER_HEAP(addr + size - 1))
    8020428c:	0001                	nop
    return 0;  // 地址合法
    8020428e:	4781                	li	a5,0
}
    80204290:	853e                	mv	a0,a5
    80204292:	7422                	ld	s0,40(sp)
    80204294:	6145                	addi	sp,sp,48
    80204296:	8082                	ret

0000000080204298 <handle_syscall>:
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    80204298:	7155                	addi	sp,sp,-208
    8020429a:	e586                	sd	ra,200(sp)
    8020429c:	e1a2                	sd	s0,192(sp)
    8020429e:	0980                	addi	s0,sp,208
    802042a0:	f2a43c23          	sd	a0,-200(s0)
    802042a4:	f2b43823          	sd	a1,-208(s0)
	switch (tf->a7) {
    802042a8:	f3843783          	ld	a5,-200(s0)
    802042ac:	73fc                	ld	a5,224(a5)
    802042ae:	6705                	lui	a4,0x1
    802042b0:	177d                	addi	a4,a4,-1 # fff <_entry-0x801ff001>
    802042b2:	28e78563          	beq	a5,a4,8020453c <handle_syscall+0x2a4>
    802042b6:	6705                	lui	a4,0x1
    802042b8:	40e7f063          	bgeu	a5,a4,802046b8 <handle_syscall+0x420>
    802042bc:	0de00713          	li	a4,222
    802042c0:	20e78c63          	beq	a5,a4,802044d8 <handle_syscall+0x240>
    802042c4:	0de00713          	li	a4,222
    802042c8:	3ef76863          	bltu	a4,a5,802046b8 <handle_syscall+0x420>
    802042cc:	0dd00713          	li	a4,221
    802042d0:	18e78963          	beq	a5,a4,80204462 <handle_syscall+0x1ca>
    802042d4:	0dd00713          	li	a4,221
    802042d8:	3ef76063          	bltu	a4,a5,802046b8 <handle_syscall+0x420>
    802042dc:	0dc00713          	li	a4,220
    802042e0:	14e78963          	beq	a5,a4,80204432 <handle_syscall+0x19a>
    802042e4:	0dc00713          	li	a4,220
    802042e8:	3cf76863          	bltu	a4,a5,802046b8 <handle_syscall+0x420>
    802042ec:	0ad00713          	li	a4,173
    802042f0:	20e78863          	beq	a5,a4,80204500 <handle_syscall+0x268>
    802042f4:	0ad00713          	li	a4,173
    802042f8:	3cf76063          	bltu	a4,a5,802046b8 <handle_syscall+0x420>
    802042fc:	0ac00713          	li	a4,172
    80204300:	1ee78563          	beq	a5,a4,802044ea <handle_syscall+0x252>
    80204304:	0ac00713          	li	a4,172
    80204308:	3af76863          	bltu	a4,a5,802046b8 <handle_syscall+0x420>
    8020430c:	08100713          	li	a4,129
    80204310:	0ee78363          	beq	a5,a4,802043f6 <handle_syscall+0x15e>
    80204314:	08100713          	li	a4,129
    80204318:	3af76063          	bltu	a4,a5,802046b8 <handle_syscall+0x420>
    8020431c:	02a00713          	li	a4,42
    80204320:	02f76863          	bltu	a4,a5,80204350 <handle_syscall+0xb8>
    80204324:	38078a63          	beqz	a5,802046b8 <handle_syscall+0x420>
    80204328:	02a00713          	li	a4,42
    8020432c:	38f76663          	bltu	a4,a5,802046b8 <handle_syscall+0x420>
    80204330:	00279713          	slli	a4,a5,0x2
    80204334:	00018797          	auipc	a5,0x18
    80204338:	8c478793          	addi	a5,a5,-1852 # 8021bbf8 <user_test_table+0x4e0>
    8020433c:	97ba                	add	a5,a5,a4
    8020433e:	439c                	lw	a5,0(a5)
    80204340:	0007871b          	sext.w	a4,a5
    80204344:	00018797          	auipc	a5,0x18
    80204348:	8b478793          	addi	a5,a5,-1868 # 8021bbf8 <user_test_table+0x4e0>
    8020434c:	97ba                	add	a5,a5,a4
    8020434e:	8782                	jr	a5
    80204350:	05d00713          	li	a4,93
    80204354:	06e78b63          	beq	a5,a4,802043ca <handle_syscall+0x132>
    80204358:	a685                	j	802046b8 <handle_syscall+0x420>
			printf("[syscall] print int: %ld\n", tf->a0);
    8020435a:	f3843783          	ld	a5,-200(s0)
    8020435e:	77dc                	ld	a5,168(a5)
    80204360:	85be                	mv	a1,a5
    80204362:	00017517          	auipc	a0,0x17
    80204366:	72650513          	addi	a0,a0,1830 # 8021ba88 <user_test_table+0x370>
    8020436a:	ffffd097          	auipc	ra,0xffffd
    8020436e:	99c080e7          	jalr	-1636(ra) # 80200d06 <printf>
			break;
    80204372:	a6a5                	j	802046da <handle_syscall+0x442>
			if (copyinstr(buf, myproc()->pagetable, tf->a0, sizeof(buf)) < 0) {
    80204374:	00001097          	auipc	ra,0x1
    80204378:	c1c080e7          	jalr	-996(ra) # 80204f90 <myproc>
    8020437c:	87aa                	mv	a5,a0
    8020437e:	7fd8                	ld	a4,184(a5)
    80204380:	f3843783          	ld	a5,-200(s0)
    80204384:	77d0                	ld	a2,168(a5)
    80204386:	f4040793          	addi	a5,s0,-192
    8020438a:	08000693          	li	a3,128
    8020438e:	85ba                	mv	a1,a4
    80204390:	853e                	mv	a0,a5
    80204392:	00000097          	auipc	ra,0x0
    80204396:	d36080e7          	jalr	-714(ra) # 802040c8 <copyinstr>
    8020439a:	87aa                	mv	a5,a0
    8020439c:	0007db63          	bgez	a5,802043b2 <handle_syscall+0x11a>
				printf("[syscall] invalid string\n");
    802043a0:	00017517          	auipc	a0,0x17
    802043a4:	70850513          	addi	a0,a0,1800 # 8021baa8 <user_test_table+0x390>
    802043a8:	ffffd097          	auipc	ra,0xffffd
    802043ac:	95e080e7          	jalr	-1698(ra) # 80200d06 <printf>
				break;
    802043b0:	a62d                	j	802046da <handle_syscall+0x442>
			printf("[syscall] print str: %s\n", buf);
    802043b2:	f4040793          	addi	a5,s0,-192
    802043b6:	85be                	mv	a1,a5
    802043b8:	00017517          	auipc	a0,0x17
    802043bc:	71050513          	addi	a0,a0,1808 # 8021bac8 <user_test_table+0x3b0>
    802043c0:	ffffd097          	auipc	ra,0xffffd
    802043c4:	946080e7          	jalr	-1722(ra) # 80200d06 <printf>
			break;
    802043c8:	ae09                	j	802046da <handle_syscall+0x442>
			printf("[syscall] exit(%ld)\n", tf->a0);
    802043ca:	f3843783          	ld	a5,-200(s0)
    802043ce:	77dc                	ld	a5,168(a5)
    802043d0:	85be                	mv	a1,a5
    802043d2:	00017517          	auipc	a0,0x17
    802043d6:	71650513          	addi	a0,a0,1814 # 8021bae8 <user_test_table+0x3d0>
    802043da:	ffffd097          	auipc	ra,0xffffd
    802043de:	92c080e7          	jalr	-1748(ra) # 80200d06 <printf>
			exit_proc((int)tf->a0);
    802043e2:	f3843783          	ld	a5,-200(s0)
    802043e6:	77dc                	ld	a5,168(a5)
    802043e8:	2781                	sext.w	a5,a5
    802043ea:	853e                	mv	a0,a5
    802043ec:	00002097          	auipc	ra,0x2
    802043f0:	996080e7          	jalr	-1642(ra) # 80205d82 <exit_proc>
			break;
    802043f4:	a4dd                	j	802046da <handle_syscall+0x442>
			if (myproc()->pid == tf->a0){
    802043f6:	00001097          	auipc	ra,0x1
    802043fa:	b9a080e7          	jalr	-1126(ra) # 80204f90 <myproc>
    802043fe:	87aa                	mv	a5,a0
    80204400:	43dc                	lw	a5,4(a5)
    80204402:	873e                	mv	a4,a5
    80204404:	f3843783          	ld	a5,-200(s0)
    80204408:	77dc                	ld	a5,168(a5)
    8020440a:	00f71a63          	bne	a4,a5,8020441e <handle_syscall+0x186>
				warning("[syscall] will kill itself!!!\n");
    8020440e:	00017517          	auipc	a0,0x17
    80204412:	6f250513          	addi	a0,a0,1778 # 8021bb00 <user_test_table+0x3e8>
    80204416:	ffffd097          	auipc	ra,0xffffd
    8020441a:	370080e7          	jalr	880(ra) # 80201786 <warning>
			kill_proc(tf->a0);
    8020441e:	f3843783          	ld	a5,-200(s0)
    80204422:	77dc                	ld	a5,168(a5)
    80204424:	2781                	sext.w	a5,a5
    80204426:	853e                	mv	a0,a5
    80204428:	00002097          	auipc	ra,0x2
    8020442c:	8f6080e7          	jalr	-1802(ra) # 80205d1e <kill_proc>
			break;
    80204430:	a46d                	j	802046da <handle_syscall+0x442>
			int child_pid = fork_proc();
    80204432:	00001097          	auipc	ra,0x1
    80204436:	4ca080e7          	jalr	1226(ra) # 802058fc <fork_proc>
    8020443a:	87aa                	mv	a5,a0
    8020443c:	fcf42e23          	sw	a5,-36(s0)
			tf->a0 = child_pid;
    80204440:	fdc42703          	lw	a4,-36(s0)
    80204444:	f3843783          	ld	a5,-200(s0)
    80204448:	f7d8                	sd	a4,168(a5)
			printf("[syscall] fork -> %d\n", child_pid);
    8020444a:	fdc42783          	lw	a5,-36(s0)
    8020444e:	85be                	mv	a1,a5
    80204450:	00017517          	auipc	a0,0x17
    80204454:	6d050513          	addi	a0,a0,1744 # 8021bb20 <user_test_table+0x408>
    80204458:	ffffd097          	auipc	ra,0xffffd
    8020445c:	8ae080e7          	jalr	-1874(ra) # 80200d06 <printf>
			break;
    80204460:	acad                	j	802046da <handle_syscall+0x442>
				uint64 uaddr = tf->a0;
    80204462:	f3843783          	ld	a5,-200(s0)
    80204466:	77dc                	ld	a5,168(a5)
    80204468:	fef43023          	sd	a5,-32(s0)
				int kstatus = 0;
    8020446c:	fc042023          	sw	zero,-64(s0)
				int pid = wait_proc(uaddr ? &kstatus : NULL);  // 在内核里等待并得到退出码
    80204470:	fe043783          	ld	a5,-32(s0)
    80204474:	c781                	beqz	a5,8020447c <handle_syscall+0x1e4>
    80204476:	fc040793          	addi	a5,s0,-64
    8020447a:	a011                	j	8020447e <handle_syscall+0x1e6>
    8020447c:	4781                	li	a5,0
    8020447e:	853e                	mv	a0,a5
    80204480:	00002097          	auipc	ra,0x2
    80204484:	9cc080e7          	jalr	-1588(ra) # 80205e4c <wait_proc>
    80204488:	87aa                	mv	a5,a0
    8020448a:	fef42623          	sw	a5,-20(s0)
				if (pid >= 0 && uaddr) {
    8020448e:	fec42783          	lw	a5,-20(s0)
    80204492:	2781                	sext.w	a5,a5
    80204494:	0207cc63          	bltz	a5,802044cc <handle_syscall+0x234>
    80204498:	fe043783          	ld	a5,-32(s0)
    8020449c:	cb85                	beqz	a5,802044cc <handle_syscall+0x234>
					if (copyout(myproc()->pagetable, uaddr, (char *)&kstatus, sizeof(kstatus)) < 0) {
    8020449e:	00001097          	auipc	ra,0x1
    802044a2:	af2080e7          	jalr	-1294(ra) # 80204f90 <myproc>
    802044a6:	87aa                	mv	a5,a0
    802044a8:	7fdc                	ld	a5,184(a5)
    802044aa:	fc040713          	addi	a4,s0,-64
    802044ae:	4691                	li	a3,4
    802044b0:	863a                	mv	a2,a4
    802044b2:	fe043583          	ld	a1,-32(s0)
    802044b6:	853e                	mv	a0,a5
    802044b8:	00000097          	auipc	ra,0x0
    802044bc:	b94080e7          	jalr	-1132(ra) # 8020404c <copyout>
    802044c0:	87aa                	mv	a5,a0
    802044c2:	0007d563          	bgez	a5,802044cc <handle_syscall+0x234>
						pid = -1; // 用户空间地址不可写，视为失败
    802044c6:	57fd                	li	a5,-1
    802044c8:	fef42623          	sw	a5,-20(s0)
				tf->a0 = pid;
    802044cc:	fec42703          	lw	a4,-20(s0)
    802044d0:	f3843783          	ld	a5,-200(s0)
    802044d4:	f7d8                	sd	a4,168(a5)
				break;
    802044d6:	a411                	j	802046da <handle_syscall+0x442>
			tf->a0 =0;
    802044d8:	f3843783          	ld	a5,-200(s0)
    802044dc:	0a07b423          	sd	zero,168(a5)
			yield();
    802044e0:	00001097          	auipc	ra,0x1
    802044e4:	694080e7          	jalr	1684(ra) # 80205b74 <yield>
			break;
    802044e8:	aacd                	j	802046da <handle_syscall+0x442>
			tf->a0 = myproc()->pid;
    802044ea:	00001097          	auipc	ra,0x1
    802044ee:	aa6080e7          	jalr	-1370(ra) # 80204f90 <myproc>
    802044f2:	87aa                	mv	a5,a0
    802044f4:	43dc                	lw	a5,4(a5)
    802044f6:	873e                	mv	a4,a5
    802044f8:	f3843783          	ld	a5,-200(s0)
    802044fc:	f7d8                	sd	a4,168(a5)
			break;
    802044fe:	aaf1                	j	802046da <handle_syscall+0x442>
			tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
    80204500:	00001097          	auipc	ra,0x1
    80204504:	a90080e7          	jalr	-1392(ra) # 80204f90 <myproc>
    80204508:	87aa                	mv	a5,a0
    8020450a:	6fdc                	ld	a5,152(a5)
    8020450c:	cb91                	beqz	a5,80204520 <handle_syscall+0x288>
    8020450e:	00001097          	auipc	ra,0x1
    80204512:	a82080e7          	jalr	-1406(ra) # 80204f90 <myproc>
    80204516:	87aa                	mv	a5,a0
    80204518:	6fdc                	ld	a5,152(a5)
    8020451a:	43dc                	lw	a5,4(a5)
    8020451c:	873e                	mv	a4,a5
    8020451e:	a011                	j	80204522 <handle_syscall+0x28a>
    80204520:	4701                	li	a4,0
    80204522:	f3843783          	ld	a5,-200(s0)
    80204526:	f7d8                	sd	a4,168(a5)
			break;
    80204528:	aa4d                	j	802046da <handle_syscall+0x442>
			tf->a0 = get_time();
    8020452a:	00002097          	auipc	ra,0x2
    8020452e:	f90080e7          	jalr	-112(ra) # 802064ba <get_time>
    80204532:	872a                	mv	a4,a0
    80204534:	f3843783          	ld	a5,-200(s0)
    80204538:	f7d8                	sd	a4,168(a5)
			break;
    8020453a:	a245                	j	802046da <handle_syscall+0x442>
			tf->a0 = 0;
    8020453c:	f3843783          	ld	a5,-200(s0)
    80204540:	0a07b423          	sd	zero,168(a5)
			printf("[syscall] step enabled but do nothing\n");
    80204544:	00017517          	auipc	a0,0x17
    80204548:	5f450513          	addi	a0,a0,1524 # 8021bb38 <user_test_table+0x420>
    8020454c:	ffffc097          	auipc	ra,0xffffc
    80204550:	7ba080e7          	jalr	1978(ra) # 80200d06 <printf>
			break;
    80204554:	a259                	j	802046da <handle_syscall+0x442>
		int fd = tf->a0;          // 文件描述符
    80204556:	f3843783          	ld	a5,-200(s0)
    8020455a:	77dc                	ld	a5,168(a5)
    8020455c:	fcf42c23          	sw	a5,-40(s0)
		if (fd != 1 && fd != 2) {
    80204560:	fd842783          	lw	a5,-40(s0)
    80204564:	0007871b          	sext.w	a4,a5
    80204568:	4785                	li	a5,1
    8020456a:	00f70e63          	beq	a4,a5,80204586 <handle_syscall+0x2ee>
    8020456e:	fd842783          	lw	a5,-40(s0)
    80204572:	0007871b          	sext.w	a4,a5
    80204576:	4789                	li	a5,2
    80204578:	00f70763          	beq	a4,a5,80204586 <handle_syscall+0x2ee>
			tf->a0 = -1;
    8020457c:	f3843783          	ld	a5,-200(s0)
    80204580:	577d                	li	a4,-1
    80204582:	f7d8                	sd	a4,168(a5)
			break;
    80204584:	aa99                	j	802046da <handle_syscall+0x442>
		if (check_user_addr(tf->a1, tf->a2, 0) < 0) {
    80204586:	f3843783          	ld	a5,-200(s0)
    8020458a:	7bd8                	ld	a4,176(a5)
    8020458c:	f3843783          	ld	a5,-200(s0)
    80204590:	7fdc                	ld	a5,184(a5)
    80204592:	4601                	li	a2,0
    80204594:	85be                	mv	a1,a5
    80204596:	853a                	mv	a0,a4
    80204598:	00000097          	auipc	ra,0x0
    8020459c:	bca080e7          	jalr	-1078(ra) # 80204162 <check_user_addr>
    802045a0:	87aa                	mv	a5,a0
    802045a2:	0007df63          	bgez	a5,802045c0 <handle_syscall+0x328>
			printf("[syscall] invalid write buffer address\n");
    802045a6:	00017517          	auipc	a0,0x17
    802045aa:	5ba50513          	addi	a0,a0,1466 # 8021bb60 <user_test_table+0x448>
    802045ae:	ffffc097          	auipc	ra,0xffffc
    802045b2:	758080e7          	jalr	1880(ra) # 80200d06 <printf>
			tf->a0 = -1;
    802045b6:	f3843783          	ld	a5,-200(s0)
    802045ba:	577d                	li	a4,-1
    802045bc:	f7d8                	sd	a4,168(a5)
			break;
    802045be:	aa31                	j	802046da <handle_syscall+0x442>
		if (copyinstr(buf, myproc()->pagetable, tf->a1, sizeof(buf)) < 0) {
    802045c0:	00001097          	auipc	ra,0x1
    802045c4:	9d0080e7          	jalr	-1584(ra) # 80204f90 <myproc>
    802045c8:	87aa                	mv	a5,a0
    802045ca:	7fd8                	ld	a4,184(a5)
    802045cc:	f3843783          	ld	a5,-200(s0)
    802045d0:	7bd0                	ld	a2,176(a5)
    802045d2:	f4040793          	addi	a5,s0,-192
    802045d6:	08000693          	li	a3,128
    802045da:	85ba                	mv	a1,a4
    802045dc:	853e                	mv	a0,a5
    802045de:	00000097          	auipc	ra,0x0
    802045e2:	aea080e7          	jalr	-1302(ra) # 802040c8 <copyinstr>
    802045e6:	87aa                	mv	a5,a0
    802045e8:	0007df63          	bgez	a5,80204606 <handle_syscall+0x36e>
			printf("[syscall] invalid write buffer\n");
    802045ec:	00017517          	auipc	a0,0x17
    802045f0:	59c50513          	addi	a0,a0,1436 # 8021bb88 <user_test_table+0x470>
    802045f4:	ffffc097          	auipc	ra,0xffffc
    802045f8:	712080e7          	jalr	1810(ra) # 80200d06 <printf>
			tf->a0 = -1;
    802045fc:	f3843783          	ld	a5,-200(s0)
    80204600:	577d                	li	a4,-1
    80204602:	f7d8                	sd	a4,168(a5)
			break;
    80204604:	a8d9                	j	802046da <handle_syscall+0x442>
		printf("%s", buf);
    80204606:	f4040793          	addi	a5,s0,-192
    8020460a:	85be                	mv	a1,a5
    8020460c:	00017517          	auipc	a0,0x17
    80204610:	59c50513          	addi	a0,a0,1436 # 8021bba8 <user_test_table+0x490>
    80204614:	ffffc097          	auipc	ra,0xffffc
    80204618:	6f2080e7          	jalr	1778(ra) # 80200d06 <printf>
		tf->a0 = strlen(buf);  // 返回写入的字节数
    8020461c:	f4040793          	addi	a5,s0,-192
    80204620:	853e                	mv	a0,a5
    80204622:	00002097          	auipc	ra,0x2
    80204626:	bf4080e7          	jalr	-1036(ra) # 80206216 <strlen>
    8020462a:	87aa                	mv	a5,a0
    8020462c:	873e                	mv	a4,a5
    8020462e:	f3843783          	ld	a5,-200(s0)
    80204632:	f7d8                	sd	a4,168(a5)
		break;
    80204634:	a05d                	j	802046da <handle_syscall+0x442>
		int fd = tf->a0;          // 文件描述符
    80204636:	f3843783          	ld	a5,-200(s0)
    8020463a:	77dc                	ld	a5,168(a5)
    8020463c:	fcf42a23          	sw	a5,-44(s0)
		uint64 buf = tf->a1;      // 用户缓冲区地址
    80204640:	f3843783          	ld	a5,-200(s0)
    80204644:	7bdc                	ld	a5,176(a5)
    80204646:	fcf43423          	sd	a5,-56(s0)
		int n = tf->a2;           // 要读取的字节数
    8020464a:	f3843783          	ld	a5,-200(s0)
    8020464e:	7fdc                	ld	a5,184(a5)
    80204650:	fcf42223          	sw	a5,-60(s0)
		if (fd != 0) {
    80204654:	fd442783          	lw	a5,-44(s0)
    80204658:	2781                	sext.w	a5,a5
    8020465a:	c791                	beqz	a5,80204666 <handle_syscall+0x3ce>
			tf->a0 = -1;
    8020465c:	f3843783          	ld	a5,-200(s0)
    80204660:	577d                	li	a4,-1
    80204662:	f7d8                	sd	a4,168(a5)
			break;
    80204664:	a89d                	j	802046da <handle_syscall+0x442>
		if (check_user_addr(buf, n, 1) < 0) {  // 1表示写入访问
    80204666:	fc442783          	lw	a5,-60(s0)
    8020466a:	4605                	li	a2,1
    8020466c:	85be                	mv	a1,a5
    8020466e:	fc843503          	ld	a0,-56(s0)
    80204672:	00000097          	auipc	ra,0x0
    80204676:	af0080e7          	jalr	-1296(ra) # 80204162 <check_user_addr>
    8020467a:	87aa                	mv	a5,a0
    8020467c:	0007df63          	bgez	a5,8020469a <handle_syscall+0x402>
			printf("[syscall] invalid read buffer address\n");
    80204680:	00017517          	auipc	a0,0x17
    80204684:	53050513          	addi	a0,a0,1328 # 8021bbb0 <user_test_table+0x498>
    80204688:	ffffc097          	auipc	ra,0xffffc
    8020468c:	67e080e7          	jalr	1662(ra) # 80200d06 <printf>
			tf->a0 = -1;
    80204690:	f3843783          	ld	a5,-200(s0)
    80204694:	577d                	li	a4,-1
    80204696:	f7d8                	sd	a4,168(a5)
			break;
    80204698:	a089                	j	802046da <handle_syscall+0x442>
		tf->a0 = -1;
    8020469a:	f3843783          	ld	a5,-200(s0)
    8020469e:	577d                	li	a4,-1
    802046a0:	f7d8                	sd	a4,168(a5)
		break;
    802046a2:	a825                	j	802046da <handle_syscall+0x442>
        case SYS_open:
        case SYS_close: 
            // 暂时不支持真实的文件操作
            tf->a0 = -1;
    802046a4:	f3843783          	ld	a5,-200(s0)
    802046a8:	577d                	li	a4,-1
    802046aa:	f7d8                	sd	a4,168(a5)
            break;
    802046ac:	a03d                	j	802046da <handle_syscall+0x442>
		case SYS_sbrk:
			tf->a0 = -1;
    802046ae:	f3843783          	ld	a5,-200(s0)
    802046b2:	577d                	li	a4,-1
    802046b4:	f7d8                	sd	a4,168(a5)
			break;
    802046b6:	a015                	j	802046da <handle_syscall+0x442>
		default:
			printf("[syscall] unknown syscall: %ld\n", tf->a7);
    802046b8:	f3843783          	ld	a5,-200(s0)
    802046bc:	73fc                	ld	a5,224(a5)
    802046be:	85be                	mv	a1,a5
    802046c0:	00017517          	auipc	a0,0x17
    802046c4:	51850513          	addi	a0,a0,1304 # 8021bbd8 <user_test_table+0x4c0>
    802046c8:	ffffc097          	auipc	ra,0xffffc
    802046cc:	63e080e7          	jalr	1598(ra) # 80200d06 <printf>
			tf->a0 = -1;
    802046d0:	f3843783          	ld	a5,-200(s0)
    802046d4:	577d                	li	a4,-1
    802046d6:	f7d8                	sd	a4,168(a5)
			break;
    802046d8:	0001                	nop
	}
	set_sepc(tf, info->sepc + 4);
    802046da:	f3043783          	ld	a5,-208(s0)
    802046de:	639c                	ld	a5,0(a5)
    802046e0:	0791                	addi	a5,a5,4
    802046e2:	85be                	mv	a1,a5
    802046e4:	f3843503          	ld	a0,-200(s0)
    802046e8:	fffff097          	auipc	ra,0xfffff
    802046ec:	008080e7          	jalr	8(ra) # 802036f0 <set_sepc>
}
    802046f0:	0001                	nop
    802046f2:	60ae                	ld	ra,200(sp)
    802046f4:	640e                	ld	s0,192(sp)
    802046f6:	6169                	addi	sp,sp,208
    802046f8:	8082                	ret

00000000802046fa <handle_instruction_page_fault>:



// 处理指令页故障
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    802046fa:	1101                	addi	sp,sp,-32
    802046fc:	ec06                	sd	ra,24(sp)
    802046fe:	e822                	sd	s0,16(sp)
    80204700:	1000                	addi	s0,sp,32
    80204702:	fea43423          	sd	a0,-24(s0)
    80204706:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    8020470a:	fe043783          	ld	a5,-32(s0)
    8020470e:	6f98                	ld	a4,24(a5)
    80204710:	fe043783          	ld	a5,-32(s0)
    80204714:	639c                	ld	a5,0(a5)
    80204716:	863e                	mv	a2,a5
    80204718:	85ba                	mv	a1,a4
    8020471a:	00017517          	auipc	a0,0x17
    8020471e:	58e50513          	addi	a0,a0,1422 # 8021bca8 <user_test_table+0x590>
    80204722:	ffffc097          	auipc	ra,0xffffc
    80204726:	5e4080e7          	jalr	1508(ra) # 80200d06 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    8020472a:	fe043783          	ld	a5,-32(s0)
    8020472e:	6f9c                	ld	a5,24(a5)
    80204730:	4585                	li	a1,1
    80204732:	853e                	mv	a0,a5
    80204734:	ffffe097          	auipc	ra,0xffffe
    80204738:	2c0080e7          	jalr	704(ra) # 802029f4 <handle_page_fault>
    8020473c:	87aa                	mv	a5,a0
    8020473e:	eb91                	bnez	a5,80204752 <handle_instruction_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled instruction page fault");
    80204740:	00017517          	auipc	a0,0x17
    80204744:	59850513          	addi	a0,a0,1432 # 8021bcd8 <user_test_table+0x5c0>
    80204748:	ffffd097          	auipc	ra,0xffffd
    8020474c:	00a080e7          	jalr	10(ra) # 80201752 <panic>
    80204750:	a011                	j	80204754 <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80204752:	0001                	nop
}
    80204754:	60e2                	ld	ra,24(sp)
    80204756:	6442                	ld	s0,16(sp)
    80204758:	6105                	addi	sp,sp,32
    8020475a:	8082                	ret

000000008020475c <handle_load_page_fault>:

// 处理加载页故障
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    8020475c:	1101                	addi	sp,sp,-32
    8020475e:	ec06                	sd	ra,24(sp)
    80204760:	e822                	sd	s0,16(sp)
    80204762:	1000                	addi	s0,sp,32
    80204764:	fea43423          	sd	a0,-24(s0)
    80204768:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    8020476c:	fe043783          	ld	a5,-32(s0)
    80204770:	6f98                	ld	a4,24(a5)
    80204772:	fe043783          	ld	a5,-32(s0)
    80204776:	639c                	ld	a5,0(a5)
    80204778:	863e                	mv	a2,a5
    8020477a:	85ba                	mv	a1,a4
    8020477c:	00017517          	auipc	a0,0x17
    80204780:	58450513          	addi	a0,a0,1412 # 8021bd00 <user_test_table+0x5e8>
    80204784:	ffffc097          	auipc	ra,0xffffc
    80204788:	582080e7          	jalr	1410(ra) # 80200d06 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    8020478c:	fe043783          	ld	a5,-32(s0)
    80204790:	6f9c                	ld	a5,24(a5)
    80204792:	4589                	li	a1,2
    80204794:	853e                	mv	a0,a5
    80204796:	ffffe097          	auipc	ra,0xffffe
    8020479a:	25e080e7          	jalr	606(ra) # 802029f4 <handle_page_fault>
    8020479e:	87aa                	mv	a5,a0
    802047a0:	eb91                	bnez	a5,802047b4 <handle_load_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled load page fault");
    802047a2:	00017517          	auipc	a0,0x17
    802047a6:	58e50513          	addi	a0,a0,1422 # 8021bd30 <user_test_table+0x618>
    802047aa:	ffffd097          	auipc	ra,0xffffd
    802047ae:	fa8080e7          	jalr	-88(ra) # 80201752 <panic>
    802047b2:	a011                	j	802047b6 <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802047b4:	0001                	nop
}
    802047b6:	60e2                	ld	ra,24(sp)
    802047b8:	6442                	ld	s0,16(sp)
    802047ba:	6105                	addi	sp,sp,32
    802047bc:	8082                	ret

00000000802047be <handle_store_page_fault>:

// 处理存储页故障
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    802047be:	1101                	addi	sp,sp,-32
    802047c0:	ec06                	sd	ra,24(sp)
    802047c2:	e822                	sd	s0,16(sp)
    802047c4:	1000                	addi	s0,sp,32
    802047c6:	fea43423          	sd	a0,-24(s0)
    802047ca:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802047ce:	fe043783          	ld	a5,-32(s0)
    802047d2:	6f98                	ld	a4,24(a5)
    802047d4:	fe043783          	ld	a5,-32(s0)
    802047d8:	639c                	ld	a5,0(a5)
    802047da:	863e                	mv	a2,a5
    802047dc:	85ba                	mv	a1,a4
    802047de:	00017517          	auipc	a0,0x17
    802047e2:	57250513          	addi	a0,a0,1394 # 8021bd50 <user_test_table+0x638>
    802047e6:	ffffc097          	auipc	ra,0xffffc
    802047ea:	520080e7          	jalr	1312(ra) # 80200d06 <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    802047ee:	fe043783          	ld	a5,-32(s0)
    802047f2:	6f9c                	ld	a5,24(a5)
    802047f4:	458d                	li	a1,3
    802047f6:	853e                	mv	a0,a5
    802047f8:	ffffe097          	auipc	ra,0xffffe
    802047fc:	1fc080e7          	jalr	508(ra) # 802029f4 <handle_page_fault>
    80204800:	87aa                	mv	a5,a0
    80204802:	eb91                	bnez	a5,80204816 <handle_store_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled store page fault");
    80204804:	00017517          	auipc	a0,0x17
    80204808:	57c50513          	addi	a0,a0,1404 # 8021bd80 <user_test_table+0x668>
    8020480c:	ffffd097          	auipc	ra,0xffffd
    80204810:	f46080e7          	jalr	-186(ra) # 80201752 <panic>
    80204814:	a011                	j	80204818 <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    80204816:	0001                	nop
}
    80204818:	60e2                	ld	ra,24(sp)
    8020481a:	6442                	ld	s0,16(sp)
    8020481c:	6105                	addi	sp,sp,32
    8020481e:	8082                	ret

0000000080204820 <usertrap>:

void usertrap(void) {
    80204820:	7159                	addi	sp,sp,-112
    80204822:	f486                	sd	ra,104(sp)
    80204824:	f0a2                	sd	s0,96(sp)
    80204826:	1880                	addi	s0,sp,112
    struct proc *p = myproc();
    80204828:	00000097          	auipc	ra,0x0
    8020482c:	768080e7          	jalr	1896(ra) # 80204f90 <myproc>
    80204830:	fea43423          	sd	a0,-24(s0)
    struct trapframe *tf = p->trapframe;
    80204834:	fe843783          	ld	a5,-24(s0)
    80204838:	63fc                	ld	a5,192(a5)
    8020483a:	fef43023          	sd	a5,-32(s0)

    uint64 scause = r_scause();
    8020483e:	fffff097          	auipc	ra,0xfffff
    80204842:	e20080e7          	jalr	-480(ra) # 8020365e <r_scause>
    80204846:	fca43c23          	sd	a0,-40(s0)
    uint64 stval  = r_stval();
    8020484a:	fffff097          	auipc	ra,0xfffff
    8020484e:	e48080e7          	jalr	-440(ra) # 80203692 <r_stval>
    80204852:	fca43823          	sd	a0,-48(s0)
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    80204856:	fe043783          	ld	a5,-32(s0)
    8020485a:	7f9c                	ld	a5,56(a5)
    8020485c:	fcf43423          	sd	a5,-56(s0)
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存
    80204860:	fe043783          	ld	a5,-32(s0)
    80204864:	7b9c                	ld	a5,48(a5)
    80204866:	fcf43023          	sd	a5,-64(s0)

    uint64 code = scause & 0xff;
    8020486a:	fd843783          	ld	a5,-40(s0)
    8020486e:	0ff7f793          	zext.b	a5,a5
    80204872:	faf43c23          	sd	a5,-72(s0)
    uint64 is_intr = (scause >> 63);
    80204876:	fd843783          	ld	a5,-40(s0)
    8020487a:	93fd                	srli	a5,a5,0x3f
    8020487c:	faf43823          	sd	a5,-80(s0)

    if (!is_intr && code == 8) { // 用户态 ecall
    80204880:	fb043783          	ld	a5,-80(s0)
    80204884:	e3a1                	bnez	a5,802048c4 <usertrap+0xa4>
    80204886:	fb843703          	ld	a4,-72(s0)
    8020488a:	47a1                	li	a5,8
    8020488c:	02f71c63          	bne	a4,a5,802048c4 <usertrap+0xa4>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80204890:	fc843783          	ld	a5,-56(s0)
    80204894:	f8f43823          	sd	a5,-112(s0)
    80204898:	fc043783          	ld	a5,-64(s0)
    8020489c:	f8f43c23          	sd	a5,-104(s0)
    802048a0:	fd843783          	ld	a5,-40(s0)
    802048a4:	faf43023          	sd	a5,-96(s0)
    802048a8:	fd043783          	ld	a5,-48(s0)
    802048ac:	faf43423          	sd	a5,-88(s0)
        handle_syscall(tf, &info);
    802048b0:	f9040793          	addi	a5,s0,-112
    802048b4:	85be                	mv	a1,a5
    802048b6:	fe043503          	ld	a0,-32(s0)
    802048ba:	00000097          	auipc	ra,0x0
    802048be:	9de080e7          	jalr	-1570(ra) # 80204298 <handle_syscall>
    if (!is_intr && code == 8) { // 用户态 ecall
    802048c2:	a869                	j	8020495c <usertrap+0x13c>
        // handle_syscall 应该已 set_sepc(tf, sepc+4)
    } else if (is_intr) {
    802048c4:	fb043783          	ld	a5,-80(s0)
    802048c8:	c3ad                	beqz	a5,8020492a <usertrap+0x10a>
        if (code == 5) {
    802048ca:	fb843703          	ld	a4,-72(s0)
    802048ce:	4795                	li	a5,5
    802048d0:	02f71663          	bne	a4,a5,802048fc <usertrap+0xdc>
            timeintr();
    802048d4:	fffff097          	auipc	ra,0xfffff
    802048d8:	c7e080e7          	jalr	-898(ra) # 80203552 <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802048dc:	fffff097          	auipc	ra,0xfffff
    802048e0:	c5c080e7          	jalr	-932(ra) # 80203538 <sbi_get_time>
    802048e4:	872a                	mv	a4,a0
    802048e6:	000f47b7          	lui	a5,0xf4
    802048ea:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802048ee:	97ba                	add	a5,a5,a4
    802048f0:	853e                	mv	a0,a5
    802048f2:	fffff097          	auipc	ra,0xfffff
    802048f6:	c2a080e7          	jalr	-982(ra) # 8020351c <sbi_set_time>
    802048fa:	a08d                	j	8020495c <usertrap+0x13c>
        } else if (code == 9) {
    802048fc:	fb843703          	ld	a4,-72(s0)
    80204900:	47a5                	li	a5,9
    80204902:	00f71763          	bne	a4,a5,80204910 <usertrap+0xf0>
            handle_external_interrupt();
    80204906:	fffff097          	auipc	ra,0xfffff
    8020490a:	f3a080e7          	jalr	-198(ra) # 80203840 <handle_external_interrupt>
    8020490e:	a0b9                	j	8020495c <usertrap+0x13c>
        } else {
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    80204910:	fc843603          	ld	a2,-56(s0)
    80204914:	fd843583          	ld	a1,-40(s0)
    80204918:	00017517          	auipc	a0,0x17
    8020491c:	48850513          	addi	a0,a0,1160 # 8021bda0 <user_test_table+0x688>
    80204920:	ffffc097          	auipc	ra,0xffffc
    80204924:	3e6080e7          	jalr	998(ra) # 80200d06 <printf>
    80204928:	a815                	j	8020495c <usertrap+0x13c>
        }
    } else {
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    8020492a:	fc843783          	ld	a5,-56(s0)
    8020492e:	f8f43823          	sd	a5,-112(s0)
    80204932:	fc043783          	ld	a5,-64(s0)
    80204936:	f8f43c23          	sd	a5,-104(s0)
    8020493a:	fd843783          	ld	a5,-40(s0)
    8020493e:	faf43023          	sd	a5,-96(s0)
    80204942:	fd043783          	ld	a5,-48(s0)
    80204946:	faf43423          	sd	a5,-88(s0)
        handle_exception(tf, &info);
    8020494a:	f9040793          	addi	a5,s0,-112
    8020494e:	85be                	mv	a1,a5
    80204950:	fe043503          	ld	a0,-32(s0)
    80204954:	fffff097          	auipc	ra,0xfffff
    80204958:	18e080e7          	jalr	398(ra) # 80203ae2 <handle_exception>
    }

    usertrapret();
    8020495c:	00000097          	auipc	ra,0x0
    80204960:	012080e7          	jalr	18(ra) # 8020496e <usertrapret>
}
    80204964:	0001                	nop
    80204966:	70a6                	ld	ra,104(sp)
    80204968:	7406                	ld	s0,96(sp)
    8020496a:	6165                	addi	sp,sp,112
    8020496c:	8082                	ret

000000008020496e <usertrapret>:

void usertrapret(void) {
    8020496e:	7179                	addi	sp,sp,-48
    80204970:	f406                	sd	ra,40(sp)
    80204972:	f022                	sd	s0,32(sp)
    80204974:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80204976:	00000097          	auipc	ra,0x0
    8020497a:	61a080e7          	jalr	1562(ra) # 80204f90 <myproc>
    8020497e:	fea43423          	sd	a0,-24(s0)
    // 计算 trampoline 中 uservec 的虚拟地址（对双方页表一致）
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    80204982:	00000717          	auipc	a4,0x0
    80204986:	34e70713          	addi	a4,a4,846 # 80204cd0 <trampoline>
    8020498a:	77fd                	lui	a5,0xfffff
    8020498c:	973e                	add	a4,a4,a5
    8020498e:	00000797          	auipc	a5,0x0
    80204992:	34278793          	addi	a5,a5,834 # 80204cd0 <trampoline>
    80204996:	40f707b3          	sub	a5,a4,a5
    8020499a:	fef43023          	sd	a5,-32(s0)
    w_stvec(uservec_va);
    8020499e:	fe043503          	ld	a0,-32(s0)
    802049a2:	fffff097          	auipc	ra,0xfffff
    802049a6:	ca2080e7          	jalr	-862(ra) # 80203644 <w_stvec>

    // sscratch 设为 TRAPFRAME 的虚拟地址（trampoline 代码用它访问 tf）
    w_sscratch((uint64)TRAPFRAME);
    802049aa:	7579                	lui	a0,0xffffe
    802049ac:	fffff097          	auipc	ra,0xfffff
    802049b0:	c3c080e7          	jalr	-964(ra) # 802035e8 <w_sscratch>

    // 准备用户页表的 satp
    uint64 user_satp = MAKE_SATP(p->pagetable);
    802049b4:	fe843783          	ld	a5,-24(s0)
    802049b8:	7fdc                	ld	a5,184(a5)
    802049ba:	00c7d713          	srli	a4,a5,0xc
    802049be:	57fd                	li	a5,-1
    802049c0:	17fe                	slli	a5,a5,0x3f
    802049c2:	8fd9                	or	a5,a5,a4
    802049c4:	fcf43c23          	sd	a5,-40(s0)

    // 计算 trampoline 中 userret 的虚拟地址
    uint64 userret_va = (uint64)TRAMPOLINE + ((uint64)userret - (uint64)trampoline);
    802049c8:	00000717          	auipc	a4,0x0
    802049cc:	3ae70713          	addi	a4,a4,942 # 80204d76 <userret>
    802049d0:	77fd                	lui	a5,0xfffff
    802049d2:	973e                	add	a4,a4,a5
    802049d4:	00000797          	auipc	a5,0x0
    802049d8:	2fc78793          	addi	a5,a5,764 # 80204cd0 <trampoline>
    802049dc:	40f707b3          	sub	a5,a4,a5
    802049e0:	fcf43823          	sd	a5,-48(s0)

    // a0 = TRAPFRAME（虚拟地址，双方页表都映射）
    // a1 = user_satp
    register uint64 a0 asm("a0") = (uint64)TRAPFRAME;
    802049e4:	7579                	lui	a0,0xffffe
    register uint64 a1 asm("a1") = user_satp;
    802049e6:	fd843583          	ld	a1,-40(s0)
    register void (*tgt)(uint64, uint64) asm("t0") = (void *)userret_va;
    802049ea:	fd043783          	ld	a5,-48(s0)
    802049ee:	82be                	mv	t0,a5

    // 跳到 trampoline 上的 userret
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(tgt) : "memory");
    802049f0:	8282                	jr	t0
}
    802049f2:	0001                	nop
    802049f4:	70a2                	ld	ra,40(sp)
    802049f6:	7402                	ld	s0,32(sp)
    802049f8:	6145                	addi	sp,sp,48
    802049fa:	8082                	ret

00000000802049fc <write32>:
    802049fc:	7179                	addi	sp,sp,-48
    802049fe:	f406                	sd	ra,40(sp)
    80204a00:	f022                	sd	s0,32(sp)
    80204a02:	1800                	addi	s0,sp,48
    80204a04:	fca43c23          	sd	a0,-40(s0)
    80204a08:	87ae                	mv	a5,a1
    80204a0a:	fcf42a23          	sw	a5,-44(s0)
    80204a0e:	fd843783          	ld	a5,-40(s0)
    80204a12:	8b8d                	andi	a5,a5,3
    80204a14:	eb99                	bnez	a5,80204a2a <write32+0x2e>
    80204a16:	fd843783          	ld	a5,-40(s0)
    80204a1a:	fef43423          	sd	a5,-24(s0)
    80204a1e:	fe843783          	ld	a5,-24(s0)
    80204a22:	fd442703          	lw	a4,-44(s0)
    80204a26:	c398                	sw	a4,0(a5)
    80204a28:	a819                	j	80204a3e <write32+0x42>
    80204a2a:	fd843583          	ld	a1,-40(s0)
    80204a2e:	00019517          	auipc	a0,0x19
    80204a32:	3ba50513          	addi	a0,a0,954 # 8021dde8 <user_test_table+0x60>
    80204a36:	ffffc097          	auipc	ra,0xffffc
    80204a3a:	2d0080e7          	jalr	720(ra) # 80200d06 <printf>
    80204a3e:	0001                	nop
    80204a40:	70a2                	ld	ra,40(sp)
    80204a42:	7402                	ld	s0,32(sp)
    80204a44:	6145                	addi	sp,sp,48
    80204a46:	8082                	ret

0000000080204a48 <read32>:
    80204a48:	7179                	addi	sp,sp,-48
    80204a4a:	f406                	sd	ra,40(sp)
    80204a4c:	f022                	sd	s0,32(sp)
    80204a4e:	1800                	addi	s0,sp,48
    80204a50:	fca43c23          	sd	a0,-40(s0)
    80204a54:	fd843783          	ld	a5,-40(s0)
    80204a58:	8b8d                	andi	a5,a5,3
    80204a5a:	eb91                	bnez	a5,80204a6e <read32+0x26>
    80204a5c:	fd843783          	ld	a5,-40(s0)
    80204a60:	fef43423          	sd	a5,-24(s0)
    80204a64:	fe843783          	ld	a5,-24(s0)
    80204a68:	439c                	lw	a5,0(a5)
    80204a6a:	2781                	sext.w	a5,a5
    80204a6c:	a821                	j	80204a84 <read32+0x3c>
    80204a6e:	fd843583          	ld	a1,-40(s0)
    80204a72:	00019517          	auipc	a0,0x19
    80204a76:	3a650513          	addi	a0,a0,934 # 8021de18 <user_test_table+0x90>
    80204a7a:	ffffc097          	auipc	ra,0xffffc
    80204a7e:	28c080e7          	jalr	652(ra) # 80200d06 <printf>
    80204a82:	4781                	li	a5,0
    80204a84:	853e                	mv	a0,a5
    80204a86:	70a2                	ld	ra,40(sp)
    80204a88:	7402                	ld	s0,32(sp)
    80204a8a:	6145                	addi	sp,sp,48
    80204a8c:	8082                	ret

0000000080204a8e <plic_init>:
void plic_init(void) {
    80204a8e:	1101                	addi	sp,sp,-32
    80204a90:	ec06                	sd	ra,24(sp)
    80204a92:	e822                	sd	s0,16(sp)
    80204a94:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80204a96:	4785                	li	a5,1
    80204a98:	fef42623          	sw	a5,-20(s0)
    80204a9c:	a805                	j	80204acc <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    80204a9e:	fec42783          	lw	a5,-20(s0)
    80204aa2:	0027979b          	slliw	a5,a5,0x2
    80204aa6:	2781                	sext.w	a5,a5
    80204aa8:	873e                	mv	a4,a5
    80204aaa:	0c0007b7          	lui	a5,0xc000
    80204aae:	97ba                	add	a5,a5,a4
    80204ab0:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80204ab4:	4581                	li	a1,0
    80204ab6:	fe043503          	ld	a0,-32(s0)
    80204aba:	00000097          	auipc	ra,0x0
    80204abe:	f42080e7          	jalr	-190(ra) # 802049fc <write32>
    for (int i = 1; i <= 32; i++) {
    80204ac2:	fec42783          	lw	a5,-20(s0)
    80204ac6:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    80204ac8:	fef42623          	sw	a5,-20(s0)
    80204acc:	fec42783          	lw	a5,-20(s0)
    80204ad0:	0007871b          	sext.w	a4,a5
    80204ad4:	02000793          	li	a5,32
    80204ad8:	fce7d3e3          	bge	a5,a4,80204a9e <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    80204adc:	4585                	li	a1,1
    80204ade:	0c0007b7          	lui	a5,0xc000
    80204ae2:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    80204ae6:	00000097          	auipc	ra,0x0
    80204aea:	f16080e7          	jalr	-234(ra) # 802049fc <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    80204aee:	4585                	li	a1,1
    80204af0:	0c0007b7          	lui	a5,0xc000
    80204af4:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    80204af8:	00000097          	auipc	ra,0x0
    80204afc:	f04080e7          	jalr	-252(ra) # 802049fc <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    80204b00:	40200593          	li	a1,1026
    80204b04:	0c0027b7          	lui	a5,0xc002
    80204b08:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204b0c:	00000097          	auipc	ra,0x0
    80204b10:	ef0080e7          	jalr	-272(ra) # 802049fc <write32>
    write32(PLIC_THRESHOLD, 0);
    80204b14:	4581                	li	a1,0
    80204b16:	0c201537          	lui	a0,0xc201
    80204b1a:	00000097          	auipc	ra,0x0
    80204b1e:	ee2080e7          	jalr	-286(ra) # 802049fc <write32>
}
    80204b22:	0001                	nop
    80204b24:	60e2                	ld	ra,24(sp)
    80204b26:	6442                	ld	s0,16(sp)
    80204b28:	6105                	addi	sp,sp,32
    80204b2a:	8082                	ret

0000000080204b2c <plic_enable>:
void plic_enable(int irq) {
    80204b2c:	7179                	addi	sp,sp,-48
    80204b2e:	f406                	sd	ra,40(sp)
    80204b30:	f022                	sd	s0,32(sp)
    80204b32:	1800                	addi	s0,sp,48
    80204b34:	87aa                	mv	a5,a0
    80204b36:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204b3a:	0c0027b7          	lui	a5,0xc002
    80204b3e:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204b42:	00000097          	auipc	ra,0x0
    80204b46:	f06080e7          	jalr	-250(ra) # 80204a48 <read32>
    80204b4a:	87aa                	mv	a5,a0
    80204b4c:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    80204b50:	fdc42783          	lw	a5,-36(s0)
    80204b54:	873e                	mv	a4,a5
    80204b56:	4785                	li	a5,1
    80204b58:	00e797bb          	sllw	a5,a5,a4
    80204b5c:	2781                	sext.w	a5,a5
    80204b5e:	2781                	sext.w	a5,a5
    80204b60:	fec42703          	lw	a4,-20(s0)
    80204b64:	8fd9                	or	a5,a5,a4
    80204b66:	2781                	sext.w	a5,a5
    80204b68:	85be                	mv	a1,a5
    80204b6a:	0c0027b7          	lui	a5,0xc002
    80204b6e:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204b72:	00000097          	auipc	ra,0x0
    80204b76:	e8a080e7          	jalr	-374(ra) # 802049fc <write32>
}
    80204b7a:	0001                	nop
    80204b7c:	70a2                	ld	ra,40(sp)
    80204b7e:	7402                	ld	s0,32(sp)
    80204b80:	6145                	addi	sp,sp,48
    80204b82:	8082                	ret

0000000080204b84 <plic_disable>:
void plic_disable(int irq) {
    80204b84:	7179                	addi	sp,sp,-48
    80204b86:	f406                	sd	ra,40(sp)
    80204b88:	f022                	sd	s0,32(sp)
    80204b8a:	1800                	addi	s0,sp,48
    80204b8c:	87aa                	mv	a5,a0
    80204b8e:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204b92:	0c0027b7          	lui	a5,0xc002
    80204b96:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204b9a:	00000097          	auipc	ra,0x0
    80204b9e:	eae080e7          	jalr	-338(ra) # 80204a48 <read32>
    80204ba2:	87aa                	mv	a5,a0
    80204ba4:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    80204ba8:	fdc42783          	lw	a5,-36(s0)
    80204bac:	873e                	mv	a4,a5
    80204bae:	4785                	li	a5,1
    80204bb0:	00e797bb          	sllw	a5,a5,a4
    80204bb4:	2781                	sext.w	a5,a5
    80204bb6:	fff7c793          	not	a5,a5
    80204bba:	2781                	sext.w	a5,a5
    80204bbc:	2781                	sext.w	a5,a5
    80204bbe:	fec42703          	lw	a4,-20(s0)
    80204bc2:	8ff9                	and	a5,a5,a4
    80204bc4:	2781                	sext.w	a5,a5
    80204bc6:	85be                	mv	a1,a5
    80204bc8:	0c0027b7          	lui	a5,0xc002
    80204bcc:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204bd0:	00000097          	auipc	ra,0x0
    80204bd4:	e2c080e7          	jalr	-468(ra) # 802049fc <write32>
}
    80204bd8:	0001                	nop
    80204bda:	70a2                	ld	ra,40(sp)
    80204bdc:	7402                	ld	s0,32(sp)
    80204bde:	6145                	addi	sp,sp,48
    80204be0:	8082                	ret

0000000080204be2 <plic_claim>:
int plic_claim(void) {
    80204be2:	1141                	addi	sp,sp,-16
    80204be4:	e406                	sd	ra,8(sp)
    80204be6:	e022                	sd	s0,0(sp)
    80204be8:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    80204bea:	0c2017b7          	lui	a5,0xc201
    80204bee:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204bf2:	00000097          	auipc	ra,0x0
    80204bf6:	e56080e7          	jalr	-426(ra) # 80204a48 <read32>
    80204bfa:	87aa                	mv	a5,a0
    80204bfc:	2781                	sext.w	a5,a5
    80204bfe:	2781                	sext.w	a5,a5
}
    80204c00:	853e                	mv	a0,a5
    80204c02:	60a2                	ld	ra,8(sp)
    80204c04:	6402                	ld	s0,0(sp)
    80204c06:	0141                	addi	sp,sp,16
    80204c08:	8082                	ret

0000000080204c0a <plic_complete>:
void plic_complete(int irq) {
    80204c0a:	1101                	addi	sp,sp,-32
    80204c0c:	ec06                	sd	ra,24(sp)
    80204c0e:	e822                	sd	s0,16(sp)
    80204c10:	1000                	addi	s0,sp,32
    80204c12:	87aa                	mv	a5,a0
    80204c14:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    80204c18:	fec42783          	lw	a5,-20(s0)
    80204c1c:	85be                	mv	a1,a5
    80204c1e:	0c2017b7          	lui	a5,0xc201
    80204c22:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204c26:	00000097          	auipc	ra,0x0
    80204c2a:	dd6080e7          	jalr	-554(ra) # 802049fc <write32>
    80204c2e:	0001                	nop
    80204c30:	60e2                	ld	ra,24(sp)
    80204c32:	6442                	ld	s0,16(sp)
    80204c34:	6105                	addi	sp,sp,32
    80204c36:	8082                	ret
	...

0000000080204c40 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80204c40:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80204c42:	e006                	sd	ra,0(sp)
        sd gp, 16(sp)
    80204c44:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80204c46:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80204c48:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80204c4a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80204c4c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    80204c4e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80204c50:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80204c52:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80204c54:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80204c56:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80204c58:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80204c5a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80204c5c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80204c5e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80204c60:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80204c62:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80204c64:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80204c66:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80204c68:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    80204c6a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    80204c6c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    80204c6e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80204c70:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80204c72:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80204c74:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80204c76:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80204c78:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80204c7a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80204c7c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80204c7e:	fffff097          	auipc	ra,0xfffff
    80204c82:	cf2080e7          	jalr	-782(ra) # 80203970 <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80204c86:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80204c88:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80204c8a:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80204c8c:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80204c8e:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80204c90:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80204c92:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80204c94:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80204c96:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80204c98:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80204c9a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80204c9c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80204c9e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80204ca0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80204ca2:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80204ca4:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80204ca6:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80204ca8:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    80204caa:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    80204cac:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    80204cae:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80204cb0:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80204cb2:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80204cb4:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80204cb6:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80204cb8:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80204cba:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80204cbc:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80204cbe:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80204cc0:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80204cc2:	10200073          	sret
    80204cc6:	0001                	nop
    80204cc8:	00000013          	nop
    80204ccc:	00000013          	nop

0000000080204cd0 <trampoline>:
trampoline:
.align 4

uservec:
    # 1. 取 trapframe 指针
    csrrw a0, sscratch, a0      # a0 = TRAPFRAME (用户页表下可访问), sscratch = user a0
    80204cd0:	14051573          	csrrw	a0,sscratch,a0

    # 2. 按新的trapframe结构保存寄存器
    sd   ra, 64(a0)             # ra offset: 64
    80204cd4:	04153023          	sd	ra,64(a0) # c201040 <_entry-0x73ffefc0>
    sd   sp, 72(a0)             # sp offset: 72
    80204cd8:	04253423          	sd	sp,72(a0)
    sd   gp, 80(a0)             # gp offset: 80
    80204cdc:	04353823          	sd	gp,80(a0)
    sd   tp, 88(a0)             # tp offset: 88
    80204ce0:	04453c23          	sd	tp,88(a0)
    sd   t0, 96(a0)             # t0 offset: 96
    80204ce4:	06553023          	sd	t0,96(a0)
    sd   t1, 104(a0)            # t1 offset: 104
    80204ce8:	06653423          	sd	t1,104(a0)
    sd   t2, 112(a0)            # t2 offset: 112
    80204cec:	06753823          	sd	t2,112(a0)
    sd   t3, 120(a0)            # t3 offset: 120
    80204cf0:	07c53c23          	sd	t3,120(a0)
    sd   t4, 128(a0)            # t4 offset: 128
    80204cf4:	09d53023          	sd	t4,128(a0)
    sd   t5, 136(a0)            # t5 offset: 136
    80204cf8:	09e53423          	sd	t5,136(a0)
    sd   t6, 144(a0)            # t6 offset: 144
    80204cfc:	09f53823          	sd	t6,144(a0)
    sd   s0, 152(a0)            # s0 offset: 152
    80204d00:	ed40                	sd	s0,152(a0)
    sd   s1, 160(a0)            # s1 offset: 160
    80204d02:	f144                	sd	s1,160(a0)

    # 继续保存其他寄存器
    sd   a1, 176(a0)            # a1 offset: 176
    80204d04:	f94c                	sd	a1,176(a0)
    sd   a2, 184(a0)            # a2 offset: 184
    80204d06:	fd50                	sd	a2,184(a0)
    sd   a3, 192(a0)            # a3 offset: 192
    80204d08:	e174                	sd	a3,192(a0)
    sd   a4, 200(a0)            # a4 offset: 200
    80204d0a:	e578                	sd	a4,200(a0)
    sd   a5, 208(a0)            # a5 offset: 208
    80204d0c:	e97c                	sd	a5,208(a0)
    sd   a6, 216(a0)            # a6 offset: 216
    80204d0e:	0d053c23          	sd	a6,216(a0)
    sd   a7, 224(a0)            # a7 offset: 224
    80204d12:	0f153023          	sd	a7,224(a0)
    sd   s2, 232(a0)            # s2 offset: 232
    80204d16:	0f253423          	sd	s2,232(a0)
    sd   s3, 240(a0)            # s3 offset: 240
    80204d1a:	0f353823          	sd	s3,240(a0)
    sd   s4, 248(a0)            # s4 offset: 248
    80204d1e:	0f453c23          	sd	s4,248(a0)
    sd   s5, 256(a0)            # s5 offset: 256
    80204d22:	11553023          	sd	s5,256(a0)
    sd   s6, 264(a0)            # s6 offset: 264
    80204d26:	11653423          	sd	s6,264(a0)
    sd   s7, 272(a0)            # s7 offset: 272
    80204d2a:	11753823          	sd	s7,272(a0)
    sd   s8, 280(a0)            # s8 offset: 280
    80204d2e:	11853c23          	sd	s8,280(a0)
    sd   s9, 288(a0)            # s9 offset: 288
    80204d32:	13953023          	sd	s9,288(a0)
    sd   s10, 296(a0)           # s10 offset: 296
    80204d36:	13a53423          	sd	s10,296(a0)
    sd   s11, 304(a0)           # s11 offset: 304
    80204d3a:	13b53823          	sd	s11,304(a0)

	# 保存用户 a0：先取回 sscratch 里的原值
    csrr t0, sscratch
    80204d3e:	140022f3          	csrr	t0,sscratch
    sd   t0, 168(a0)
    80204d42:	0a553423          	sd	t0,168(a0)

    # 保存控制寄存器
    csrr t0, sstatus
    80204d46:	100022f3          	csrr	t0,sstatus
    sd   t0, 48(a0)
    80204d4a:	02553823          	sd	t0,48(a0)
    csrr t1, sepc
    80204d4e:	14102373          	csrr	t1,sepc
    sd   t1, 56(a0)
    80204d52:	02653c23          	sd	t1,56(a0)

	# 在切换页表前，先读出关键字段到 t3–t6
    ld   t3, 0(a0)              # t3 = kernel_satp
    80204d56:	00053e03          	ld	t3,0(a0)
    ld   t4, 8(a0)              # t4 = kernel_sp
    80204d5a:	00853e83          	ld	t4,8(a0)
    ld   t5, 24(a0)            # t5 = usertrap
    80204d5e:	01853f03          	ld	t5,24(a0)
	ld   t6, 32(a0)			# t6 = kernel_vec
    80204d62:	02053f83          	ld	t6,32(a0)

    # 4. 切换到内核页表
    csrw satp, t3
    80204d66:	180e1073          	csrw	satp,t3
    sfence.vma x0, x0
    80204d6a:	12000073          	sfence.vma

    # 5. 切换到内核栈
    mv   sp, t4
    80204d6e:	8176                	mv	sp,t4

    # 6. 设置 stvec 并跳转到 C 层 usertrap
    csrw stvec, t6
    80204d70:	105f9073          	csrw	stvec,t6
    jr   t5
    80204d74:	8f02                	jr	t5

0000000080204d76 <userret>:
userret:
        csrw satp, a1
    80204d76:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    80204d7a:	12000073          	sfence.vma
    # 2. 按新的偏移量恢复寄存器
    ld   ra, 64(a0)
    80204d7e:	04053083          	ld	ra,64(a0)
    ld   sp, 72(a0)
    80204d82:	04853103          	ld	sp,72(a0)
    ld   gp, 80(a0)
    80204d86:	05053183          	ld	gp,80(a0)
    ld   tp, 88(a0)
    80204d8a:	05853203          	ld	tp,88(a0)
    ld   t0, 96(a0)
    80204d8e:	06053283          	ld	t0,96(a0)
    ld   t1, 104(a0)
    80204d92:	06853303          	ld	t1,104(a0)
    ld   t2, 112(a0)
    80204d96:	07053383          	ld	t2,112(a0)
    ld   t3, 120(a0)
    80204d9a:	07853e03          	ld	t3,120(a0)
    ld   t4, 128(a0)
    80204d9e:	08053e83          	ld	t4,128(a0)
    ld   t5, 136(a0)
    80204da2:	08853f03          	ld	t5,136(a0)
    ld   t6, 144(a0)
    80204da6:	09053f83          	ld	t6,144(a0)
    ld   s0, 152(a0)
    80204daa:	6d40                	ld	s0,152(a0)
    ld   s1, 160(a0)
    80204dac:	7144                	ld	s1,160(a0)
    ld   a1, 176(a0)
    80204dae:	794c                	ld	a1,176(a0)
    ld   a2, 184(a0)
    80204db0:	7d50                	ld	a2,184(a0)
    ld   a3, 192(a0)
    80204db2:	6174                	ld	a3,192(a0)
    ld   a4, 200(a0)
    80204db4:	6578                	ld	a4,200(a0)
    ld   a5, 208(a0)
    80204db6:	697c                	ld	a5,208(a0)
    ld   a6, 216(a0)
    80204db8:	0d853803          	ld	a6,216(a0)
    ld   a7, 224(a0)
    80204dbc:	0e053883          	ld	a7,224(a0)
    ld   s2, 232(a0)
    80204dc0:	0e853903          	ld	s2,232(a0)
    ld   s3, 240(a0)
    80204dc4:	0f053983          	ld	s3,240(a0)
    ld   s4, 248(a0)
    80204dc8:	0f853a03          	ld	s4,248(a0)
    ld   s5, 256(a0)
    80204dcc:	10053a83          	ld	s5,256(a0)
    ld   s6, 264(a0)
    80204dd0:	10853b03          	ld	s6,264(a0)
    ld   s7, 272(a0)
    80204dd4:	11053b83          	ld	s7,272(a0)
    ld   s8, 280(a0)
    80204dd8:	11853c03          	ld	s8,280(a0)
    ld   s9, 288(a0)
    80204ddc:	12053c83          	ld	s9,288(a0)
    ld   s10, 296(a0)
    80204de0:	12853d03          	ld	s10,296(a0)
    ld   s11, 304(a0)
    80204de4:	13053d83          	ld	s11,304(a0)

        # 使用临时变量恢复控制寄存器
        ld t0, 56(a0)      # 恢复 sepc
    80204de8:	03853283          	ld	t0,56(a0)
        csrw sepc, t0
    80204dec:	14129073          	csrw	sepc,t0
        ld t0, 48(a0)      # 恢复 sstatus
    80204df0:	03053283          	ld	t0,48(a0)
        csrw sstatus, t0
    80204df4:	10029073          	csrw	sstatus,t0
		csrw sscratch, a0
    80204df8:	14051073          	csrw	sscratch,a0
		ld a0, 168(a0)
    80204dfc:	7548                	ld	a0,168(a0)
    80204dfe:	10200073          	sret
    80204e02:	0001                	nop
    80204e04:	00000013          	nop
    80204e08:	00000013          	nop
    80204e0c:	00000013          	nop

0000000080204e10 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80204e10:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80204e14:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80204e18:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80204e1a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80204e1c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80204e20:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80204e24:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80204e28:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80204e2c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80204e30:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80204e34:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80204e38:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80204e3c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80204e40:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80204e44:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80204e48:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80204e4c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80204e4e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80204e50:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80204e54:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80204e58:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80204e5c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80204e60:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80204e64:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80204e68:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80204e6c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80204e70:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80204e74:	0685bd83          	ld	s11,104(a1)
        
        ret
    80204e78:	8082                	ret

0000000080204e7a <r_sstatus>:
    register uint64 ra asm("ra");
    p->context.ra = ra;
    p->chan = chan;
    p->state = SLEEPING;
    swtch(&p->context, &c->context);
    p->chan = 0;
    80204e7a:	1101                	addi	sp,sp,-32
    80204e7c:	ec22                	sd	s0,24(sp)
    80204e7e:	1000                	addi	s0,sp,32
	if(p->killed){
		printf("[sleep] Process PID %d killed when wakeup\n", p->pid);
    80204e80:	100027f3          	csrr	a5,sstatus
    80204e84:	fef43423          	sd	a5,-24(s0)
		exit_proc(SYS_kill);
    80204e88:	fe843783          	ld	a5,-24(s0)
	}
    80204e8c:	853e                	mv	a0,a5
    80204e8e:	6462                	ld	s0,24(sp)
    80204e90:	6105                	addi	sp,sp,32
    80204e92:	8082                	ret

0000000080204e94 <w_sstatus>:
}
    80204e94:	1101                	addi	sp,sp,-32
    80204e96:	ec22                	sd	s0,24(sp)
    80204e98:	1000                	addi	s0,sp,32
    80204e9a:	fea43423          	sd	a0,-24(s0)
void wakeup(void *chan) {
    80204e9e:	fe843783          	ld	a5,-24(s0)
    80204ea2:	10079073          	csrw	sstatus,a5
    for(int i = 0; i < PROC; i++) {
    80204ea6:	0001                	nop
    80204ea8:	6462                	ld	s0,24(sp)
    80204eaa:	6105                	addi	sp,sp,32
    80204eac:	8082                	ret

0000000080204eae <intr_on>:
        }
    }
}
void kill_proc(int pid){
	for(int i=0;i<PROC;i++){
		struct proc *p = proc_table[i];
    80204eae:	1141                	addi	sp,sp,-16
    80204eb0:	e406                	sd	ra,8(sp)
    80204eb2:	e022                	sd	s0,0(sp)
    80204eb4:	0800                	addi	s0,sp,16
		if(pid == p->pid){
    80204eb6:	00000097          	auipc	ra,0x0
    80204eba:	fc4080e7          	jalr	-60(ra) # 80204e7a <r_sstatus>
    80204ebe:	87aa                	mv	a5,a0
    80204ec0:	0027e793          	ori	a5,a5,2
    80204ec4:	853e                	mv	a0,a5
    80204ec6:	00000097          	auipc	ra,0x0
    80204eca:	fce080e7          	jalr	-50(ra) # 80204e94 <w_sstatus>
			p->killed = 1;
    80204ece:	0001                	nop
    80204ed0:	60a2                	ld	ra,8(sp)
    80204ed2:	6402                	ld	s0,0(sp)
    80204ed4:	0141                	addi	sp,sp,16
    80204ed6:	8082                	ret

0000000080204ed8 <intr_off>:
			break;
		}
    80204ed8:	1141                	addi	sp,sp,-16
    80204eda:	e406                	sd	ra,8(sp)
    80204edc:	e022                	sd	s0,0(sp)
    80204ede:	0800                	addi	s0,sp,16
	}
    80204ee0:	00000097          	auipc	ra,0x0
    80204ee4:	f9a080e7          	jalr	-102(ra) # 80204e7a <r_sstatus>
    80204ee8:	87aa                	mv	a5,a0
    80204eea:	9bf5                	andi	a5,a5,-3
    80204eec:	853e                	mv	a0,a5
    80204eee:	00000097          	auipc	ra,0x0
    80204ef2:	fa6080e7          	jalr	-90(ra) # 80204e94 <w_sstatus>
	return;
    80204ef6:	0001                	nop
    80204ef8:	60a2                	ld	ra,8(sp)
    80204efa:	6402                	ld	s0,0(sp)
    80204efc:	0141                	addi	sp,sp,16
    80204efe:	8082                	ret

0000000080204f00 <w_stvec>:
}
void exit_proc(int status) {
    80204f00:	1101                	addi	sp,sp,-32
    80204f02:	ec22                	sd	s0,24(sp)
    80204f04:	1000                	addi	s0,sp,32
    80204f06:	fea43423          	sd	a0,-24(s0)
    struct proc *p = myproc();
    80204f0a:	fe843783          	ld	a5,-24(s0)
    80204f0e:	10579073          	csrw	stvec,a5
    if (p == 0) {
    80204f12:	0001                	nop
    80204f14:	6462                	ld	s0,24(sp)
    80204f16:	6105                	addi	sp,sp,32
    80204f18:	8082                	ret

0000000080204f1a <assert>:
            struct proc *child = proc_table[i];
            if (child->state == ZOMBIE && child->parent == p) {
                found_zombie = 1;
                zombie_pid = child->pid;
                zombie_status = child->exit_status;
                zombie_child = child;
    80204f1a:	1101                	addi	sp,sp,-32
    80204f1c:	ec06                	sd	ra,24(sp)
    80204f1e:	e822                	sd	s0,16(sp)
    80204f20:	1000                	addi	s0,sp,32
    80204f22:	87aa                	mv	a5,a0
    80204f24:	fef42623          	sw	a5,-20(s0)
                break;
    80204f28:	fec42783          	lw	a5,-20(s0)
    80204f2c:	2781                	sext.w	a5,a5
    80204f2e:	e79d                	bnez	a5,80204f5c <assert+0x42>
            }
    80204f30:	1b700613          	li	a2,439
    80204f34:	0001b597          	auipc	a1,0x1b
    80204f38:	f2458593          	addi	a1,a1,-220 # 8021fe58 <user_test_table+0x60>
    80204f3c:	0001b517          	auipc	a0,0x1b
    80204f40:	f2c50513          	addi	a0,a0,-212 # 8021fe68 <user_test_table+0x70>
    80204f44:	ffffc097          	auipc	ra,0xffffc
    80204f48:	dc2080e7          	jalr	-574(ra) # 80200d06 <printf>
        }
    80204f4c:	0001b517          	auipc	a0,0x1b
    80204f50:	f4450513          	addi	a0,a0,-188 # 8021fe90 <user_test_table+0x98>
    80204f54:	ffffc097          	auipc	ra,0xffffc
    80204f58:	7fe080e7          	jalr	2046(ra) # 80201752 <panic>
        
        if (found_zombie) {
    80204f5c:	0001                	nop
    80204f5e:	60e2                	ld	ra,24(sp)
    80204f60:	6442                	ld	s0,16(sp)
    80204f62:	6105                	addi	sp,sp,32
    80204f64:	8082                	ret

0000000080204f66 <shutdown>:
void shutdown() {
    80204f66:	1141                	addi	sp,sp,-16
    80204f68:	e406                	sd	ra,8(sp)
    80204f6a:	e022                	sd	s0,0(sp)
    80204f6c:	0800                	addi	s0,sp,16
	free_proc_table();
    80204f6e:	00000097          	auipc	ra,0x0
    80204f72:	3aa080e7          	jalr	938(ra) # 80205318 <free_proc_table>
    printf("关机\n");
    80204f76:	0001b517          	auipc	a0,0x1b
    80204f7a:	f2250513          	addi	a0,a0,-222 # 8021fe98 <user_test_table+0xa0>
    80204f7e:	ffffc097          	auipc	ra,0xffffc
    80204f82:	d88080e7          	jalr	-632(ra) # 80200d06 <printf>
    asm volatile (
    80204f86:	48a1                	li	a7,8
    80204f88:	00000073          	ecall
    while (1) { }
    80204f8c:	0001                	nop
    80204f8e:	bffd                	j	80204f8c <shutdown+0x26>

0000000080204f90 <myproc>:
struct proc* myproc(void) {
    80204f90:	1141                	addi	sp,sp,-16
    80204f92:	e422                	sd	s0,8(sp)
    80204f94:	0800                	addi	s0,sp,16
    return current_proc;
    80204f96:	00022797          	auipc	a5,0x22
    80204f9a:	11278793          	addi	a5,a5,274 # 802270a8 <current_proc>
    80204f9e:	639c                	ld	a5,0(a5)
}
    80204fa0:	853e                	mv	a0,a5
    80204fa2:	6422                	ld	s0,8(sp)
    80204fa4:	0141                	addi	sp,sp,16
    80204fa6:	8082                	ret

0000000080204fa8 <mycpu>:
struct cpu* mycpu(void) {
    80204fa8:	1141                	addi	sp,sp,-16
    80204faa:	e406                	sd	ra,8(sp)
    80204fac:	e022                	sd	s0,0(sp)
    80204fae:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80204fb0:	00022797          	auipc	a5,0x22
    80204fb4:	10078793          	addi	a5,a5,256 # 802270b0 <current_cpu>
    80204fb8:	639c                	ld	a5,0(a5)
    80204fba:	ebb9                	bnez	a5,80205010 <mycpu+0x68>
        warning("current_cpu is NULL, initializing...\n");
    80204fbc:	0001b517          	auipc	a0,0x1b
    80204fc0:	ee450513          	addi	a0,a0,-284 # 8021fea0 <user_test_table+0xa8>
    80204fc4:	ffffc097          	auipc	ra,0xffffc
    80204fc8:	7c2080e7          	jalr	1986(ra) # 80201786 <warning>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    80204fcc:	07800613          	li	a2,120
    80204fd0:	4581                	li	a1,0
    80204fd2:	00022517          	auipc	a0,0x22
    80204fd6:	69e50513          	addi	a0,a0,1694 # 80227670 <cpu_instance.0>
    80204fda:	ffffd097          	auipc	ra,0xffffd
    80204fde:	eb6080e7          	jalr	-330(ra) # 80201e90 <memset>
		current_cpu = &cpu_instance;
    80204fe2:	00022797          	auipc	a5,0x22
    80204fe6:	0ce78793          	addi	a5,a5,206 # 802270b0 <current_cpu>
    80204fea:	00022717          	auipc	a4,0x22
    80204fee:	68670713          	addi	a4,a4,1670 # 80227670 <cpu_instance.0>
    80204ff2:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    80204ff4:	00022797          	auipc	a5,0x22
    80204ff8:	0bc78793          	addi	a5,a5,188 # 802270b0 <current_cpu>
    80204ffc:	639c                	ld	a5,0(a5)
    80204ffe:	85be                	mv	a1,a5
    80205000:	0001b517          	auipc	a0,0x1b
    80205004:	ec850513          	addi	a0,a0,-312 # 8021fec8 <user_test_table+0xd0>
    80205008:	ffffc097          	auipc	ra,0xffffc
    8020500c:	cfe080e7          	jalr	-770(ra) # 80200d06 <printf>
    return current_cpu;
    80205010:	00022797          	auipc	a5,0x22
    80205014:	0a078793          	addi	a5,a5,160 # 802270b0 <current_cpu>
    80205018:	639c                	ld	a5,0(a5)
}
    8020501a:	853e                	mv	a0,a5
    8020501c:	60a2                	ld	ra,8(sp)
    8020501e:	6402                	ld	s0,0(sp)
    80205020:	0141                	addi	sp,sp,16
    80205022:	8082                	ret

0000000080205024 <return_to_user>:
void return_to_user(void) {
    80205024:	7179                	addi	sp,sp,-48
    80205026:	f406                	sd	ra,40(sp)
    80205028:	f022                	sd	s0,32(sp)
    8020502a:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    8020502c:	00000097          	auipc	ra,0x0
    80205030:	f64080e7          	jalr	-156(ra) # 80204f90 <myproc>
    80205034:	fea43423          	sd	a0,-24(s0)
    if (!p) panic("return_to_user: no current process");
    80205038:	fe843783          	ld	a5,-24(s0)
    8020503c:	eb89                	bnez	a5,8020504e <return_to_user+0x2a>
    8020503e:	0001b517          	auipc	a0,0x1b
    80205042:	ea250513          	addi	a0,a0,-350 # 8021fee0 <user_test_table+0xe8>
    80205046:	ffffc097          	auipc	ra,0xffffc
    8020504a:	70c080e7          	jalr	1804(ra) # 80201752 <panic>
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    8020504e:	00000717          	auipc	a4,0x0
    80205052:	c8270713          	addi	a4,a4,-894 # 80204cd0 <trampoline>
    80205056:	00000797          	auipc	a5,0x0
    8020505a:	c7a78793          	addi	a5,a5,-902 # 80204cd0 <trampoline>
    8020505e:	40f707b3          	sub	a5,a4,a5
    80205062:	873e                	mv	a4,a5
    80205064:	77fd                	lui	a5,0xfffff
    80205066:	97ba                	add	a5,a5,a4
    80205068:	853e                	mv	a0,a5
    8020506a:	00000097          	auipc	ra,0x0
    8020506e:	e96080e7          	jalr	-362(ra) # 80204f00 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80205072:	00000717          	auipc	a4,0x0
    80205076:	d0470713          	addi	a4,a4,-764 # 80204d76 <userret>
    8020507a:	00000797          	auipc	a5,0x0
    8020507e:	c5678793          	addi	a5,a5,-938 # 80204cd0 <trampoline>
    80205082:	40f707b3          	sub	a5,a4,a5
    80205086:	873e                	mv	a4,a5
    80205088:	77fd                	lui	a5,0xfffff
    8020508a:	97ba                	add	a5,a5,a4
    8020508c:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    80205090:	fe843783          	ld	a5,-24(s0)
    80205094:	7fdc                	ld	a5,184(a5)
    80205096:	00c7d713          	srli	a4,a5,0xc
    8020509a:	57fd                	li	a5,-1
    8020509c:	17fe                	slli	a5,a5,0x3f
    8020509e:	8fd9                	or	a5,a5,a4
    802050a0:	fcf43c23          	sd	a5,-40(s0)
    if ((trampoline_userret & ~(PGSIZE - 1)) != TRAMPOLINE) {
    802050a4:	fe043703          	ld	a4,-32(s0)
    802050a8:	77fd                	lui	a5,0xfffff
    802050aa:	8f7d                	and	a4,a4,a5
    802050ac:	77fd                	lui	a5,0xfffff
    802050ae:	00f70a63          	beq	a4,a5,802050c2 <return_to_user+0x9e>
        panic("return_to_user: userret outside trampoline page");
    802050b2:	0001b517          	auipc	a0,0x1b
    802050b6:	e5650513          	addi	a0,a0,-426 # 8021ff08 <user_test_table+0x110>
    802050ba:	ffffc097          	auipc	ra,0xffffc
    802050be:	698080e7          	jalr	1688(ra) # 80201752 <panic>
    void (*userret_fn)(uint64, uint64) = (void (*)(uint64, uint64))trampoline_userret;
    802050c2:	fe043783          	ld	a5,-32(s0)
    802050c6:	fcf43823          	sd	a5,-48(s0)
    userret_fn(TRAPFRAME, satp);
    802050ca:	fd043783          	ld	a5,-48(s0)
    802050ce:	fd843583          	ld	a1,-40(s0)
    802050d2:	7579                	lui	a0,0xffffe
    802050d4:	9782                	jalr	a5
    panic("return_to_user: should not return");
    802050d6:	0001b517          	auipc	a0,0x1b
    802050da:	e6250513          	addi	a0,a0,-414 # 8021ff38 <user_test_table+0x140>
    802050de:	ffffc097          	auipc	ra,0xffffc
    802050e2:	674080e7          	jalr	1652(ra) # 80201752 <panic>
}
    802050e6:	0001                	nop
    802050e8:	70a2                	ld	ra,40(sp)
    802050ea:	7402                	ld	s0,32(sp)
    802050ec:	6145                	addi	sp,sp,48
    802050ee:	8082                	ret

00000000802050f0 <forkret>:
void forkret(void) {
    802050f0:	1101                	addi	sp,sp,-32
    802050f2:	ec06                	sd	ra,24(sp)
    802050f4:	e822                	sd	s0,16(sp)
    802050f6:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    802050f8:	00000097          	auipc	ra,0x0
    802050fc:	e98080e7          	jalr	-360(ra) # 80204f90 <myproc>
    80205100:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205104:	fe843783          	ld	a5,-24(s0)
    80205108:	eb89                	bnez	a5,8020511a <forkret+0x2a>
        panic("forkret: no current process");
    8020510a:	0001b517          	auipc	a0,0x1b
    8020510e:	e5650513          	addi	a0,a0,-426 # 8021ff60 <user_test_table+0x168>
    80205112:	ffffc097          	auipc	ra,0xffffc
    80205116:	640080e7          	jalr	1600(ra) # 80201752 <panic>
    if (p->killed) {
    8020511a:	fe843783          	ld	a5,-24(s0)
    8020511e:	0807a783          	lw	a5,128(a5) # fffffffffffff080 <_bss_end+0xffffffff7fdd7990>
    80205122:	c785                	beqz	a5,8020514a <forkret+0x5a>
        printf("[forkret] Process PID %d killed before execution\n", p->pid);
    80205124:	fe843783          	ld	a5,-24(s0)
    80205128:	43dc                	lw	a5,4(a5)
    8020512a:	85be                	mv	a1,a5
    8020512c:	0001b517          	auipc	a0,0x1b
    80205130:	e5450513          	addi	a0,a0,-428 # 8021ff80 <user_test_table+0x188>
    80205134:	ffffc097          	auipc	ra,0xffffc
    80205138:	bd2080e7          	jalr	-1070(ra) # 80200d06 <printf>
        exit_proc(SYS_kill);
    8020513c:	08100513          	li	a0,129
    80205140:	00001097          	auipc	ra,0x1
    80205144:	c42080e7          	jalr	-958(ra) # 80205d82 <exit_proc>
        return; // 虽然不会执行到这里，但为了代码清晰
    80205148:	a099                	j	8020518e <forkret+0x9e>
    if (p->is_user) {
    8020514a:	fe843783          	ld	a5,-24(s0)
    8020514e:	0a87a783          	lw	a5,168(a5)
    80205152:	c791                	beqz	a5,8020515e <forkret+0x6e>
        return_to_user();
    80205154:	00000097          	auipc	ra,0x0
    80205158:	ed0080e7          	jalr	-304(ra) # 80205024 <return_to_user>
    8020515c:	a80d                	j	8020518e <forkret+0x9e>
		if (p->trapframe->epc) {
    8020515e:	fe843783          	ld	a5,-24(s0)
    80205162:	63fc                	ld	a5,192(a5)
    80205164:	7f9c                	ld	a5,56(a5)
    80205166:	cf99                	beqz	a5,80205184 <forkret+0x94>
			void (*fn)(uint64) = (void(*)(uint64))p->trapframe->epc;
    80205168:	fe843783          	ld	a5,-24(s0)
    8020516c:	63fc                	ld	a5,192(a5)
    8020516e:	7f9c                	ld	a5,56(a5)
    80205170:	fef43023          	sd	a5,-32(s0)
			fn(p->trapframe->a0);
    80205174:	fe843783          	ld	a5,-24(s0)
    80205178:	63fc                	ld	a5,192(a5)
    8020517a:	77d8                	ld	a4,168(a5)
    8020517c:	fe043783          	ld	a5,-32(s0)
    80205180:	853a                	mv	a0,a4
    80205182:	9782                	jalr	a5
        exit_proc(0);  // 内核线程函数返回则退出
    80205184:	4501                	li	a0,0
    80205186:	00001097          	auipc	ra,0x1
    8020518a:	bfc080e7          	jalr	-1028(ra) # 80205d82 <exit_proc>
}
    8020518e:	60e2                	ld	ra,24(sp)
    80205190:	6442                	ld	s0,16(sp)
    80205192:	6105                	addi	sp,sp,32
    80205194:	8082                	ret

0000000080205196 <init_proc>:
void init_proc(void){
    80205196:	1101                	addi	sp,sp,-32
    80205198:	ec06                	sd	ra,24(sp)
    8020519a:	e822                	sd	s0,16(sp)
    8020519c:	1000                	addi	s0,sp,32
    for (int i = 0; i < PROC; i++) {
    8020519e:	fe042623          	sw	zero,-20(s0)
    802051a2:	aa81                	j	802052f2 <init_proc+0x15c>
        void *page = alloc_page();
    802051a4:	ffffe097          	auipc	ra,0xffffe
    802051a8:	0f4080e7          	jalr	244(ra) # 80203298 <alloc_page>
    802051ac:	fea43023          	sd	a0,-32(s0)
        if (!page) panic("init_proc: alloc_page failed for proc_table");
    802051b0:	fe043783          	ld	a5,-32(s0)
    802051b4:	eb89                	bnez	a5,802051c6 <init_proc+0x30>
    802051b6:	0001b517          	auipc	a0,0x1b
    802051ba:	e0250513          	addi	a0,a0,-510 # 8021ffb8 <user_test_table+0x1c0>
    802051be:	ffffc097          	auipc	ra,0xffffc
    802051c2:	594080e7          	jalr	1428(ra) # 80201752 <panic>
        proc_table_mem[i] = page;
    802051c6:	00022717          	auipc	a4,0x22
    802051ca:	3aa70713          	addi	a4,a4,938 # 80227570 <proc_table_mem>
    802051ce:	fec42783          	lw	a5,-20(s0)
    802051d2:	078e                	slli	a5,a5,0x3
    802051d4:	97ba                	add	a5,a5,a4
    802051d6:	fe043703          	ld	a4,-32(s0)
    802051da:	e398                	sd	a4,0(a5)
        proc_table[i] = (struct proc *)page;
    802051dc:	00022717          	auipc	a4,0x22
    802051e0:	28c70713          	addi	a4,a4,652 # 80227468 <proc_table>
    802051e4:	fec42783          	lw	a5,-20(s0)
    802051e8:	078e                	slli	a5,a5,0x3
    802051ea:	97ba                	add	a5,a5,a4
    802051ec:	fe043703          	ld	a4,-32(s0)
    802051f0:	e398                	sd	a4,0(a5)
        memset(proc_table[i], 0, sizeof(struct proc));
    802051f2:	00022717          	auipc	a4,0x22
    802051f6:	27670713          	addi	a4,a4,630 # 80227468 <proc_table>
    802051fa:	fec42783          	lw	a5,-20(s0)
    802051fe:	078e                	slli	a5,a5,0x3
    80205200:	97ba                	add	a5,a5,a4
    80205202:	639c                	ld	a5,0(a5)
    80205204:	0c800613          	li	a2,200
    80205208:	4581                	li	a1,0
    8020520a:	853e                	mv	a0,a5
    8020520c:	ffffd097          	auipc	ra,0xffffd
    80205210:	c84080e7          	jalr	-892(ra) # 80201e90 <memset>
        proc_table[i]->state = UNUSED;
    80205214:	00022717          	auipc	a4,0x22
    80205218:	25470713          	addi	a4,a4,596 # 80227468 <proc_table>
    8020521c:	fec42783          	lw	a5,-20(s0)
    80205220:	078e                	slli	a5,a5,0x3
    80205222:	97ba                	add	a5,a5,a4
    80205224:	639c                	ld	a5,0(a5)
    80205226:	0007a023          	sw	zero,0(a5)
        proc_table[i]->pid = 0;
    8020522a:	00022717          	auipc	a4,0x22
    8020522e:	23e70713          	addi	a4,a4,574 # 80227468 <proc_table>
    80205232:	fec42783          	lw	a5,-20(s0)
    80205236:	078e                	slli	a5,a5,0x3
    80205238:	97ba                	add	a5,a5,a4
    8020523a:	639c                	ld	a5,0(a5)
    8020523c:	0007a223          	sw	zero,4(a5)
        proc_table[i]->kstack = 0;
    80205240:	00022717          	auipc	a4,0x22
    80205244:	22870713          	addi	a4,a4,552 # 80227468 <proc_table>
    80205248:	fec42783          	lw	a5,-20(s0)
    8020524c:	078e                	slli	a5,a5,0x3
    8020524e:	97ba                	add	a5,a5,a4
    80205250:	639c                	ld	a5,0(a5)
    80205252:	0007b423          	sd	zero,8(a5)
        proc_table[i]->pagetable = 0;
    80205256:	00022717          	auipc	a4,0x22
    8020525a:	21270713          	addi	a4,a4,530 # 80227468 <proc_table>
    8020525e:	fec42783          	lw	a5,-20(s0)
    80205262:	078e                	slli	a5,a5,0x3
    80205264:	97ba                	add	a5,a5,a4
    80205266:	639c                	ld	a5,0(a5)
    80205268:	0a07bc23          	sd	zero,184(a5)
        proc_table[i]->trapframe = 0;
    8020526c:	00022717          	auipc	a4,0x22
    80205270:	1fc70713          	addi	a4,a4,508 # 80227468 <proc_table>
    80205274:	fec42783          	lw	a5,-20(s0)
    80205278:	078e                	slli	a5,a5,0x3
    8020527a:	97ba                	add	a5,a5,a4
    8020527c:	639c                	ld	a5,0(a5)
    8020527e:	0c07b023          	sd	zero,192(a5)
        proc_table[i]->parent = 0;
    80205282:	00022717          	auipc	a4,0x22
    80205286:	1e670713          	addi	a4,a4,486 # 80227468 <proc_table>
    8020528a:	fec42783          	lw	a5,-20(s0)
    8020528e:	078e                	slli	a5,a5,0x3
    80205290:	97ba                	add	a5,a5,a4
    80205292:	639c                	ld	a5,0(a5)
    80205294:	0807bc23          	sd	zero,152(a5)
        proc_table[i]->chan = 0;
    80205298:	00022717          	auipc	a4,0x22
    8020529c:	1d070713          	addi	a4,a4,464 # 80227468 <proc_table>
    802052a0:	fec42783          	lw	a5,-20(s0)
    802052a4:	078e                	slli	a5,a5,0x3
    802052a6:	97ba                	add	a5,a5,a4
    802052a8:	639c                	ld	a5,0(a5)
    802052aa:	0a07b023          	sd	zero,160(a5)
        proc_table[i]->exit_status = 0;
    802052ae:	00022717          	auipc	a4,0x22
    802052b2:	1ba70713          	addi	a4,a4,442 # 80227468 <proc_table>
    802052b6:	fec42783          	lw	a5,-20(s0)
    802052ba:	078e                	slli	a5,a5,0x3
    802052bc:	97ba                	add	a5,a5,a4
    802052be:	639c                	ld	a5,0(a5)
    802052c0:	0807a223          	sw	zero,132(a5)
        memset(&proc_table[i]->context, 0, sizeof(struct context));
    802052c4:	00022717          	auipc	a4,0x22
    802052c8:	1a470713          	addi	a4,a4,420 # 80227468 <proc_table>
    802052cc:	fec42783          	lw	a5,-20(s0)
    802052d0:	078e                	slli	a5,a5,0x3
    802052d2:	97ba                	add	a5,a5,a4
    802052d4:	639c                	ld	a5,0(a5)
    802052d6:	07c1                	addi	a5,a5,16
    802052d8:	07000613          	li	a2,112
    802052dc:	4581                	li	a1,0
    802052de:	853e                	mv	a0,a5
    802052e0:	ffffd097          	auipc	ra,0xffffd
    802052e4:	bb0080e7          	jalr	-1104(ra) # 80201e90 <memset>
    for (int i = 0; i < PROC; i++) {
    802052e8:	fec42783          	lw	a5,-20(s0)
    802052ec:	2785                	addiw	a5,a5,1
    802052ee:	fef42623          	sw	a5,-20(s0)
    802052f2:	fec42783          	lw	a5,-20(s0)
    802052f6:	0007871b          	sext.w	a4,a5
    802052fa:	47fd                	li	a5,31
    802052fc:	eae7d4e3          	bge	a5,a4,802051a4 <init_proc+0xe>
    proc_table_pages = PROC; // 每个进程一页
    80205300:	00022797          	auipc	a5,0x22
    80205304:	26878793          	addi	a5,a5,616 # 80227568 <proc_table_pages>
    80205308:	02000713          	li	a4,32
    8020530c:	c398                	sw	a4,0(a5)
}
    8020530e:	0001                	nop
    80205310:	60e2                	ld	ra,24(sp)
    80205312:	6442                	ld	s0,16(sp)
    80205314:	6105                	addi	sp,sp,32
    80205316:	8082                	ret

0000000080205318 <free_proc_table>:
void free_proc_table(void) {
    80205318:	1101                	addi	sp,sp,-32
    8020531a:	ec06                	sd	ra,24(sp)
    8020531c:	e822                	sd	s0,16(sp)
    8020531e:	1000                	addi	s0,sp,32
    for (int i = 0; i < proc_table_pages; i++) {
    80205320:	fe042623          	sw	zero,-20(s0)
    80205324:	a025                	j	8020534c <free_proc_table+0x34>
        free_page(proc_table_mem[i]);
    80205326:	00022717          	auipc	a4,0x22
    8020532a:	24a70713          	addi	a4,a4,586 # 80227570 <proc_table_mem>
    8020532e:	fec42783          	lw	a5,-20(s0)
    80205332:	078e                	slli	a5,a5,0x3
    80205334:	97ba                	add	a5,a5,a4
    80205336:	639c                	ld	a5,0(a5)
    80205338:	853e                	mv	a0,a5
    8020533a:	ffffe097          	auipc	ra,0xffffe
    8020533e:	fca080e7          	jalr	-54(ra) # 80203304 <free_page>
    for (int i = 0; i < proc_table_pages; i++) {
    80205342:	fec42783          	lw	a5,-20(s0)
    80205346:	2785                	addiw	a5,a5,1
    80205348:	fef42623          	sw	a5,-20(s0)
    8020534c:	00022797          	auipc	a5,0x22
    80205350:	21c78793          	addi	a5,a5,540 # 80227568 <proc_table_pages>
    80205354:	4398                	lw	a4,0(a5)
    80205356:	fec42783          	lw	a5,-20(s0)
    8020535a:	2781                	sext.w	a5,a5
    8020535c:	fce7c5e3          	blt	a5,a4,80205326 <free_proc_table+0xe>
}
    80205360:	0001                	nop
    80205362:	0001                	nop
    80205364:	60e2                	ld	ra,24(sp)
    80205366:	6442                	ld	s0,16(sp)
    80205368:	6105                	addi	sp,sp,32
    8020536a:	8082                	ret

000000008020536c <alloc_proc>:
struct proc* alloc_proc(int is_user) {
    8020536c:	7139                	addi	sp,sp,-64
    8020536e:	fc06                	sd	ra,56(sp)
    80205370:	f822                	sd	s0,48(sp)
    80205372:	0080                	addi	s0,sp,64
    80205374:	87aa                	mv	a5,a0
    80205376:	fcf42623          	sw	a5,-52(s0)
    for(int i = 0;i<PROC;i++) {
    8020537a:	fe042623          	sw	zero,-20(s0)
    8020537e:	aaa5                	j	802054f6 <alloc_proc+0x18a>
		struct proc *p = proc_table[i];
    80205380:	00022717          	auipc	a4,0x22
    80205384:	0e870713          	addi	a4,a4,232 # 80227468 <proc_table>
    80205388:	fec42783          	lw	a5,-20(s0)
    8020538c:	078e                	slli	a5,a5,0x3
    8020538e:	97ba                	add	a5,a5,a4
    80205390:	639c                	ld	a5,0(a5)
    80205392:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    80205396:	fe043783          	ld	a5,-32(s0)
    8020539a:	439c                	lw	a5,0(a5)
    8020539c:	14079863          	bnez	a5,802054ec <alloc_proc+0x180>
            p->pid = i;
    802053a0:	fe043783          	ld	a5,-32(s0)
    802053a4:	fec42703          	lw	a4,-20(s0)
    802053a8:	c3d8                	sw	a4,4(a5)
            p->state = USED;
    802053aa:	fe043783          	ld	a5,-32(s0)
    802053ae:	4705                	li	a4,1
    802053b0:	c398                	sw	a4,0(a5)
			p->is_user = is_user;
    802053b2:	fe043783          	ld	a5,-32(s0)
    802053b6:	fcc42703          	lw	a4,-52(s0)
    802053ba:	0ae7a423          	sw	a4,168(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    802053be:	ffffe097          	auipc	ra,0xffffe
    802053c2:	eda080e7          	jalr	-294(ra) # 80203298 <alloc_page>
    802053c6:	872a                	mv	a4,a0
    802053c8:	fe043783          	ld	a5,-32(s0)
    802053cc:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    802053ce:	fe043783          	ld	a5,-32(s0)
    802053d2:	63fc                	ld	a5,192(a5)
    802053d4:	eb99                	bnez	a5,802053ea <alloc_proc+0x7e>
                p->state = UNUSED;
    802053d6:	fe043783          	ld	a5,-32(s0)
    802053da:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    802053de:	fe043783          	ld	a5,-32(s0)
    802053e2:	0007a223          	sw	zero,4(a5)
                return 0;
    802053e6:	4781                	li	a5,0
    802053e8:	aa39                	j	80205506 <alloc_proc+0x19a>
			if(p->is_user){
    802053ea:	fe043783          	ld	a5,-32(s0)
    802053ee:	0a87a783          	lw	a5,168(a5)
    802053f2:	c3b9                	beqz	a5,80205438 <alloc_proc+0xcc>
				p->pagetable = create_pagetable();
    802053f4:	ffffd097          	auipc	ra,0xffffd
    802053f8:	cf8080e7          	jalr	-776(ra) # 802020ec <create_pagetable>
    802053fc:	872a                	mv	a4,a0
    802053fe:	fe043783          	ld	a5,-32(s0)
    80205402:	ffd8                	sd	a4,184(a5)
				if(p->pagetable == 0){
    80205404:	fe043783          	ld	a5,-32(s0)
    80205408:	7fdc                	ld	a5,184(a5)
    8020540a:	ef9d                	bnez	a5,80205448 <alloc_proc+0xdc>
					free_page(p->trapframe);
    8020540c:	fe043783          	ld	a5,-32(s0)
    80205410:	63fc                	ld	a5,192(a5)
    80205412:	853e                	mv	a0,a5
    80205414:	ffffe097          	auipc	ra,0xffffe
    80205418:	ef0080e7          	jalr	-272(ra) # 80203304 <free_page>
					p->trapframe = 0;
    8020541c:	fe043783          	ld	a5,-32(s0)
    80205420:	0c07b023          	sd	zero,192(a5)
					p->state = UNUSED;
    80205424:	fe043783          	ld	a5,-32(s0)
    80205428:	0007a023          	sw	zero,0(a5)
					p->pid = 0;
    8020542c:	fe043783          	ld	a5,-32(s0)
    80205430:	0007a223          	sw	zero,4(a5)
					return 0;
    80205434:	4781                	li	a5,0
    80205436:	a8c1                	j	80205506 <alloc_proc+0x19a>
				p->pagetable = kernel_pagetable;
    80205438:	00022797          	auipc	a5,0x22
    8020543c:	c5878793          	addi	a5,a5,-936 # 80227090 <kernel_pagetable>
    80205440:	6398                	ld	a4,0(a5)
    80205442:	fe043783          	ld	a5,-32(s0)
    80205446:	ffd8                	sd	a4,184(a5)
            void *kstack_mem = alloc_page();
    80205448:	ffffe097          	auipc	ra,0xffffe
    8020544c:	e50080e7          	jalr	-432(ra) # 80203298 <alloc_page>
    80205450:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    80205454:	fd843783          	ld	a5,-40(s0)
    80205458:	e3b9                	bnez	a5,8020549e <alloc_proc+0x132>
                free_page(p->trapframe);
    8020545a:	fe043783          	ld	a5,-32(s0)
    8020545e:	63fc                	ld	a5,192(a5)
    80205460:	853e                	mv	a0,a5
    80205462:	ffffe097          	auipc	ra,0xffffe
    80205466:	ea2080e7          	jalr	-350(ra) # 80203304 <free_page>
                free_pagetable(p->pagetable);
    8020546a:	fe043783          	ld	a5,-32(s0)
    8020546e:	7fdc                	ld	a5,184(a5)
    80205470:	853e                	mv	a0,a5
    80205472:	ffffd097          	auipc	ra,0xffffd
    80205476:	05e080e7          	jalr	94(ra) # 802024d0 <free_pagetable>
                p->trapframe = 0;
    8020547a:	fe043783          	ld	a5,-32(s0)
    8020547e:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    80205482:	fe043783          	ld	a5,-32(s0)
    80205486:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    8020548a:	fe043783          	ld	a5,-32(s0)
    8020548e:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    80205492:	fe043783          	ld	a5,-32(s0)
    80205496:	0007a223          	sw	zero,4(a5)
                return 0;
    8020549a:	4781                	li	a5,0
    8020549c:	a0ad                	j	80205506 <alloc_proc+0x19a>
            p->kstack = (uint64)kstack_mem;
    8020549e:	fd843703          	ld	a4,-40(s0)
    802054a2:	fe043783          	ld	a5,-32(s0)
    802054a6:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    802054a8:	fe043783          	ld	a5,-32(s0)
    802054ac:	07c1                	addi	a5,a5,16
    802054ae:	07000613          	li	a2,112
    802054b2:	4581                	li	a1,0
    802054b4:	853e                	mv	a0,a5
    802054b6:	ffffd097          	auipc	ra,0xffffd
    802054ba:	9da080e7          	jalr	-1574(ra) # 80201e90 <memset>
            p->context.ra = (uint64)forkret;
    802054be:	00000717          	auipc	a4,0x0
    802054c2:	c3270713          	addi	a4,a4,-974 # 802050f0 <forkret>
    802054c6:	fe043783          	ld	a5,-32(s0)
    802054ca:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    802054cc:	fe043783          	ld	a5,-32(s0)
    802054d0:	6798                	ld	a4,8(a5)
    802054d2:	6785                	lui	a5,0x1
    802054d4:	17c1                	addi	a5,a5,-16 # ff0 <_entry-0x801ff010>
    802054d6:	973e                	add	a4,a4,a5
    802054d8:	fe043783          	ld	a5,-32(s0)
    802054dc:	ef98                	sd	a4,24(a5)
			p->killed = 0; //重置死亡状态
    802054de:	fe043783          	ld	a5,-32(s0)
    802054e2:	0807a023          	sw	zero,128(a5)
            return p;
    802054e6:	fe043783          	ld	a5,-32(s0)
    802054ea:	a831                	j	80205506 <alloc_proc+0x19a>
    for(int i = 0;i<PROC;i++) {
    802054ec:	fec42783          	lw	a5,-20(s0)
    802054f0:	2785                	addiw	a5,a5,1
    802054f2:	fef42623          	sw	a5,-20(s0)
    802054f6:	fec42783          	lw	a5,-20(s0)
    802054fa:	0007871b          	sext.w	a4,a5
    802054fe:	47fd                	li	a5,31
    80205500:	e8e7d0e3          	bge	a5,a4,80205380 <alloc_proc+0x14>
    return 0;
    80205504:	4781                	li	a5,0
}
    80205506:	853e                	mv	a0,a5
    80205508:	70e2                	ld	ra,56(sp)
    8020550a:	7442                	ld	s0,48(sp)
    8020550c:	6121                	addi	sp,sp,64
    8020550e:	8082                	ret

0000000080205510 <free_proc>:
void free_proc(struct proc *p){
    80205510:	1101                	addi	sp,sp,-32
    80205512:	ec06                	sd	ra,24(sp)
    80205514:	e822                	sd	s0,16(sp)
    80205516:	1000                	addi	s0,sp,32
    80205518:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    8020551c:	fe843783          	ld	a5,-24(s0)
    80205520:	63fc                	ld	a5,192(a5)
    80205522:	cb89                	beqz	a5,80205534 <free_proc+0x24>
        free_page(p->trapframe);
    80205524:	fe843783          	ld	a5,-24(s0)
    80205528:	63fc                	ld	a5,192(a5)
    8020552a:	853e                	mv	a0,a5
    8020552c:	ffffe097          	auipc	ra,0xffffe
    80205530:	dd8080e7          	jalr	-552(ra) # 80203304 <free_page>
    p->trapframe = 0;
    80205534:	fe843783          	ld	a5,-24(s0)
    80205538:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable && p->pagetable != kernel_pagetable)
    8020553c:	fe843783          	ld	a5,-24(s0)
    80205540:	7fdc                	ld	a5,184(a5)
    80205542:	c39d                	beqz	a5,80205568 <free_proc+0x58>
    80205544:	fe843783          	ld	a5,-24(s0)
    80205548:	7fd8                	ld	a4,184(a5)
    8020554a:	00022797          	auipc	a5,0x22
    8020554e:	b4678793          	addi	a5,a5,-1210 # 80227090 <kernel_pagetable>
    80205552:	639c                	ld	a5,0(a5)
    80205554:	00f70a63          	beq	a4,a5,80205568 <free_proc+0x58>
        free_pagetable(p->pagetable);
    80205558:	fe843783          	ld	a5,-24(s0)
    8020555c:	7fdc                	ld	a5,184(a5)
    8020555e:	853e                	mv	a0,a5
    80205560:	ffffd097          	auipc	ra,0xffffd
    80205564:	f70080e7          	jalr	-144(ra) # 802024d0 <free_pagetable>
    p->pagetable = 0;
    80205568:	fe843783          	ld	a5,-24(s0)
    8020556c:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    80205570:	fe843783          	ld	a5,-24(s0)
    80205574:	679c                	ld	a5,8(a5)
    80205576:	cb89                	beqz	a5,80205588 <free_proc+0x78>
        free_page((void*)p->kstack);
    80205578:	fe843783          	ld	a5,-24(s0)
    8020557c:	679c                	ld	a5,8(a5)
    8020557e:	853e                	mv	a0,a5
    80205580:	ffffe097          	auipc	ra,0xffffe
    80205584:	d84080e7          	jalr	-636(ra) # 80203304 <free_page>
    p->kstack = 0;
    80205588:	fe843783          	ld	a5,-24(s0)
    8020558c:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    80205590:	fe843783          	ld	a5,-24(s0)
    80205594:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    80205598:	fe843783          	ld	a5,-24(s0)
    8020559c:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    802055a0:	fe843783          	ld	a5,-24(s0)
    802055a4:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    802055a8:	fe843783          	ld	a5,-24(s0)
    802055ac:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    802055b0:	fe843783          	ld	a5,-24(s0)
    802055b4:	07c1                	addi	a5,a5,16
    802055b6:	07000613          	li	a2,112
    802055ba:	4581                	li	a1,0
    802055bc:	853e                	mv	a0,a5
    802055be:	ffffd097          	auipc	ra,0xffffd
    802055c2:	8d2080e7          	jalr	-1838(ra) # 80201e90 <memset>
}
    802055c6:	0001                	nop
    802055c8:	60e2                	ld	ra,24(sp)
    802055ca:	6442                	ld	s0,16(sp)
    802055cc:	6105                	addi	sp,sp,32
    802055ce:	8082                	ret

00000000802055d0 <create_kernel_proc>:
int create_kernel_proc(void (*entry)(void)) {
    802055d0:	7179                	addi	sp,sp,-48
    802055d2:	f406                	sd	ra,40(sp)
    802055d4:	f022                	sd	s0,32(sp)
    802055d6:	1800                	addi	s0,sp,48
    802055d8:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc(0);
    802055dc:	4501                	li	a0,0
    802055de:	00000097          	auipc	ra,0x0
    802055e2:	d8e080e7          	jalr	-626(ra) # 8020536c <alloc_proc>
    802055e6:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    802055ea:	fe843783          	ld	a5,-24(s0)
    802055ee:	e399                	bnez	a5,802055f4 <create_kernel_proc+0x24>
    802055f0:	57fd                	li	a5,-1
    802055f2:	a089                	j	80205634 <create_kernel_proc+0x64>
    p->trapframe->epc = (uint64)entry;
    802055f4:	fe843783          	ld	a5,-24(s0)
    802055f8:	63fc                	ld	a5,192(a5)
    802055fa:	fd843703          	ld	a4,-40(s0)
    802055fe:	ff98                	sd	a4,56(a5)
    p->state = RUNNABLE;
    80205600:	fe843783          	ld	a5,-24(s0)
    80205604:	470d                	li	a4,3
    80205606:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    80205608:	00000097          	auipc	ra,0x0
    8020560c:	988080e7          	jalr	-1656(ra) # 80204f90 <myproc>
    80205610:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    80205614:	fe043783          	ld	a5,-32(s0)
    80205618:	c799                	beqz	a5,80205626 <create_kernel_proc+0x56>
        p->parent = parent;
    8020561a:	fe843783          	ld	a5,-24(s0)
    8020561e:	fe043703          	ld	a4,-32(s0)
    80205622:	efd8                	sd	a4,152(a5)
    80205624:	a029                	j	8020562e <create_kernel_proc+0x5e>
        p->parent = NULL;
    80205626:	fe843783          	ld	a5,-24(s0)
    8020562a:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    8020562e:	fe843783          	ld	a5,-24(s0)
    80205632:	43dc                	lw	a5,4(a5)
}
    80205634:	853e                	mv	a0,a5
    80205636:	70a2                	ld	ra,40(sp)
    80205638:	7402                	ld	s0,32(sp)
    8020563a:	6145                	addi	sp,sp,48
    8020563c:	8082                	ret

000000008020563e <create_kernel_proc1>:
int create_kernel_proc1(void (*entry)(uint64),uint64 arg){
    8020563e:	7179                	addi	sp,sp,-48
    80205640:	f406                	sd	ra,40(sp)
    80205642:	f022                	sd	s0,32(sp)
    80205644:	1800                	addi	s0,sp,48
    80205646:	fca43c23          	sd	a0,-40(s0)
    8020564a:	fcb43823          	sd	a1,-48(s0)
	struct proc *p = alloc_proc(0);
    8020564e:	4501                	li	a0,0
    80205650:	00000097          	auipc	ra,0x0
    80205654:	d1c080e7          	jalr	-740(ra) # 8020536c <alloc_proc>
    80205658:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    8020565c:	fe843783          	ld	a5,-24(s0)
    80205660:	e399                	bnez	a5,80205666 <create_kernel_proc1+0x28>
    80205662:	57fd                	li	a5,-1
    80205664:	a0b9                	j	802056b2 <create_kernel_proc1+0x74>
    p->trapframe->epc = (uint64)entry;
    80205666:	fe843783          	ld	a5,-24(s0)
    8020566a:	63fc                	ld	a5,192(a5)
    8020566c:	fd843703          	ld	a4,-40(s0)
    80205670:	ff98                	sd	a4,56(a5)
	p->trapframe->a0 = (uint64)arg;
    80205672:	fe843783          	ld	a5,-24(s0)
    80205676:	63fc                	ld	a5,192(a5)
    80205678:	fd043703          	ld	a4,-48(s0)
    8020567c:	f7d8                	sd	a4,168(a5)
    p->state = RUNNABLE;
    8020567e:	fe843783          	ld	a5,-24(s0)
    80205682:	470d                	li	a4,3
    80205684:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    80205686:	00000097          	auipc	ra,0x0
    8020568a:	90a080e7          	jalr	-1782(ra) # 80204f90 <myproc>
    8020568e:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    80205692:	fe043783          	ld	a5,-32(s0)
    80205696:	c799                	beqz	a5,802056a4 <create_kernel_proc1+0x66>
        p->parent = parent;
    80205698:	fe843783          	ld	a5,-24(s0)
    8020569c:	fe043703          	ld	a4,-32(s0)
    802056a0:	efd8                	sd	a4,152(a5)
    802056a2:	a029                	j	802056ac <create_kernel_proc1+0x6e>
        p->parent = NULL;
    802056a4:	fe843783          	ld	a5,-24(s0)
    802056a8:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    802056ac:	fe843783          	ld	a5,-24(s0)
    802056b0:	43dc                	lw	a5,4(a5)
}
    802056b2:	853e                	mv	a0,a5
    802056b4:	70a2                	ld	ra,40(sp)
    802056b6:	7402                	ld	s0,32(sp)
    802056b8:	6145                	addi	sp,sp,48
    802056ba:	8082                	ret

00000000802056bc <create_user_proc>:
int create_user_proc(const void *user_bin, int bin_size) {
    802056bc:	711d                	addi	sp,sp,-96
    802056be:	ec86                	sd	ra,88(sp)
    802056c0:	e8a2                	sd	s0,80(sp)
    802056c2:	1080                	addi	s0,sp,96
    802056c4:	faa43423          	sd	a0,-88(s0)
    802056c8:	87ae                	mv	a5,a1
    802056ca:	faf42223          	sw	a5,-92(s0)
    struct proc *p = alloc_proc(1); // 1 表示用户进程
    802056ce:	4505                	li	a0,1
    802056d0:	00000097          	auipc	ra,0x0
    802056d4:	c9c080e7          	jalr	-868(ra) # 8020536c <alloc_proc>
    802056d8:	fea43023          	sd	a0,-32(s0)
    if (!p) return -1;
    802056dc:	fe043783          	ld	a5,-32(s0)
    802056e0:	e399                	bnez	a5,802056e6 <create_user_proc+0x2a>
    802056e2:	57fd                	li	a5,-1
    802056e4:	a439                	j	802058f2 <create_user_proc+0x236>
    uint64 user_entry = USER_TEXT_START;
    802056e6:	67c1                	lui	a5,0x10
    802056e8:	fcf43c23          	sd	a5,-40(s0)
    uint64 user_stack = USER_STACK_SIZE;
    802056ec:	000207b7          	lui	a5,0x20
    802056f0:	fcf43823          	sd	a5,-48(s0)
    void *page = alloc_page();
    802056f4:	ffffe097          	auipc	ra,0xffffe
    802056f8:	ba4080e7          	jalr	-1116(ra) # 80203298 <alloc_page>
    802056fc:	fca43423          	sd	a0,-56(s0)
    if (!page) { free_proc(p); return -1; }
    80205700:	fc843783          	ld	a5,-56(s0)
    80205704:	eb89                	bnez	a5,80205716 <create_user_proc+0x5a>
    80205706:	fe043503          	ld	a0,-32(s0)
    8020570a:	00000097          	auipc	ra,0x0
    8020570e:	e06080e7          	jalr	-506(ra) # 80205510 <free_proc>
    80205712:	57fd                	li	a5,-1
    80205714:	aaf9                	j	802058f2 <create_user_proc+0x236>
    map_page(p->pagetable, user_entry, (uint64)page, PTE_R | PTE_W | PTE_X | PTE_U);
    80205716:	fe043783          	ld	a5,-32(s0)
    8020571a:	7fdc                	ld	a5,184(a5)
    8020571c:	fc843703          	ld	a4,-56(s0)
    80205720:	46f9                	li	a3,30
    80205722:	863a                	mv	a2,a4
    80205724:	fd843583          	ld	a1,-40(s0)
    80205728:	853e                	mv	a0,a5
    8020572a:	ffffd097          	auipc	ra,0xffffd
    8020572e:	c32080e7          	jalr	-974(ra) # 8020235c <map_page>
    memcpy((void*)page, user_bin, bin_size);
    80205732:	fa442783          	lw	a5,-92(s0)
    80205736:	863e                	mv	a2,a5
    80205738:	fa843583          	ld	a1,-88(s0)
    8020573c:	fc843503          	ld	a0,-56(s0)
    80205740:	ffffd097          	auipc	ra,0xffffd
    80205744:	85c080e7          	jalr	-1956(ra) # 80201f9c <memcpy>
    for(int i = 0; i < 2; i++) {
    80205748:	fe042623          	sw	zero,-20(s0)
    8020574c:	a8bd                	j	802057ca <create_user_proc+0x10e>
        void *stack_page = alloc_page();
    8020574e:	ffffe097          	auipc	ra,0xffffe
    80205752:	b4a080e7          	jalr	-1206(ra) # 80203298 <alloc_page>
    80205756:	faa43c23          	sd	a0,-72(s0)
        if (!stack_page) { 
    8020575a:	fb843783          	ld	a5,-72(s0)
    8020575e:	eb89                	bnez	a5,80205770 <create_user_proc+0xb4>
            free_proc(p); 
    80205760:	fe043503          	ld	a0,-32(s0)
    80205764:	00000097          	auipc	ra,0x0
    80205768:	dac080e7          	jalr	-596(ra) # 80205510 <free_proc>
            return -1; 
    8020576c:	57fd                	li	a5,-1
    8020576e:	a251                	j	802058f2 <create_user_proc+0x236>
        uint64 stack_va = USER_STACK_SIZE - PGSIZE * (i + 1);
    80205770:	47fd                	li	a5,31
    80205772:	fec42703          	lw	a4,-20(s0)
    80205776:	9f99                	subw	a5,a5,a4
    80205778:	2781                	sext.w	a5,a5
    8020577a:	00c7979b          	slliw	a5,a5,0xc
    8020577e:	2781                	sext.w	a5,a5
    80205780:	faf43823          	sd	a5,-80(s0)
        if(map_page(p->pagetable, stack_va, (uint64)stack_page, 
    80205784:	fe043783          	ld	a5,-32(s0)
    80205788:	7fdc                	ld	a5,184(a5)
    8020578a:	fb843703          	ld	a4,-72(s0)
    8020578e:	46d9                	li	a3,22
    80205790:	863a                	mv	a2,a4
    80205792:	fb043583          	ld	a1,-80(s0)
    80205796:	853e                	mv	a0,a5
    80205798:	ffffd097          	auipc	ra,0xffffd
    8020579c:	bc4080e7          	jalr	-1084(ra) # 8020235c <map_page>
    802057a0:	87aa                	mv	a5,a0
    802057a2:	cf99                	beqz	a5,802057c0 <create_user_proc+0x104>
            free_page(stack_page);
    802057a4:	fb843503          	ld	a0,-72(s0)
    802057a8:	ffffe097          	auipc	ra,0xffffe
    802057ac:	b5c080e7          	jalr	-1188(ra) # 80203304 <free_page>
            free_proc(p);
    802057b0:	fe043503          	ld	a0,-32(s0)
    802057b4:	00000097          	auipc	ra,0x0
    802057b8:	d5c080e7          	jalr	-676(ra) # 80205510 <free_proc>
            return -1;
    802057bc:	57fd                	li	a5,-1
    802057be:	aa15                	j	802058f2 <create_user_proc+0x236>
    for(int i = 0; i < 2; i++) {
    802057c0:	fec42783          	lw	a5,-20(s0)
    802057c4:	2785                	addiw	a5,a5,1 # 20001 <_entry-0x801dffff>
    802057c6:	fef42623          	sw	a5,-20(s0)
    802057ca:	fec42783          	lw	a5,-20(s0)
    802057ce:	0007871b          	sext.w	a4,a5
    802057d2:	4785                	li	a5,1
    802057d4:	f6e7dde3          	bge	a5,a4,8020574e <create_user_proc+0x92>
	p->sz = user_stack; // 用户空间从 0x10000 到 0x20000
    802057d8:	fe043783          	ld	a5,-32(s0)
    802057dc:	fd043703          	ld	a4,-48(s0)
    802057e0:	fbd8                	sd	a4,176(a5)
    if (map_page(p->pagetable, TRAPFRAME, (uint64)p->trapframe, PTE_R | PTE_W) != 0) {
    802057e2:	fe043783          	ld	a5,-32(s0)
    802057e6:	7fd8                	ld	a4,184(a5)
    802057e8:	fe043783          	ld	a5,-32(s0)
    802057ec:	63fc                	ld	a5,192(a5)
    802057ee:	4699                	li	a3,6
    802057f0:	863e                	mv	a2,a5
    802057f2:	75f9                	lui	a1,0xffffe
    802057f4:	853a                	mv	a0,a4
    802057f6:	ffffd097          	auipc	ra,0xffffd
    802057fa:	b66080e7          	jalr	-1178(ra) # 8020235c <map_page>
    802057fe:	87aa                	mv	a5,a0
    80205800:	cb89                	beqz	a5,80205812 <create_user_proc+0x156>
        free_proc(p);
    80205802:	fe043503          	ld	a0,-32(s0)
    80205806:	00000097          	auipc	ra,0x0
    8020580a:	d0a080e7          	jalr	-758(ra) # 80205510 <free_proc>
        return -1;
    8020580e:	57fd                	li	a5,-1
    80205810:	a0cd                	j	802058f2 <create_user_proc+0x236>
	memset(p->trapframe, 0, sizeof(*p->trapframe));
    80205812:	fe043783          	ld	a5,-32(s0)
    80205816:	63fc                	ld	a5,192(a5)
    80205818:	13800613          	li	a2,312
    8020581c:	4581                	li	a1,0
    8020581e:	853e                	mv	a0,a5
    80205820:	ffffc097          	auipc	ra,0xffffc
    80205824:	670080e7          	jalr	1648(ra) # 80201e90 <memset>
	p->trapframe->epc = user_entry; // 应为 0x10000
    80205828:	fe043783          	ld	a5,-32(s0)
    8020582c:	63fc                	ld	a5,192(a5)
    8020582e:	fd843703          	ld	a4,-40(s0)
    80205832:	ff98                	sd	a4,56(a5)
	p->trapframe->sp = user_stack;  // 应为 0x20000
    80205834:	fe043783          	ld	a5,-32(s0)
    80205838:	63fc                	ld	a5,192(a5)
    8020583a:	fd043703          	ld	a4,-48(s0)
    8020583e:	e7b8                	sd	a4,72(a5)
	p->trapframe->sstatus = (1UL << 5); // 0x20
    80205840:	fe043783          	ld	a5,-32(s0)
    80205844:	63fc                	ld	a5,192(a5)
    80205846:	02000713          	li	a4,32
    8020584a:	fb98                	sd	a4,48(a5)
	p->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable);
    8020584c:	00022797          	auipc	a5,0x22
    80205850:	84478793          	addi	a5,a5,-1980 # 80227090 <kernel_pagetable>
    80205854:	639c                	ld	a5,0(a5)
    80205856:	00c7d693          	srli	a3,a5,0xc
    8020585a:	fe043783          	ld	a5,-32(s0)
    8020585e:	63fc                	ld	a5,192(a5)
    80205860:	577d                	li	a4,-1
    80205862:	177e                	slli	a4,a4,0x3f
    80205864:	8f55                	or	a4,a4,a3
    80205866:	e398                	sd	a4,0(a5)
	p->trapframe->kernel_sp = p->kstack + PGSIZE;   // 内核栈顶
    80205868:	fe043783          	ld	a5,-32(s0)
    8020586c:	6794                	ld	a3,8(a5)
    8020586e:	fe043783          	ld	a5,-32(s0)
    80205872:	63fc                	ld	a5,192(a5)
    80205874:	6705                	lui	a4,0x1
    80205876:	9736                	add	a4,a4,a3
    80205878:	e798                	sd	a4,8(a5)
	p->trapframe->usertrap  = (uint64)usertrap;     // C 层 trap 处理函数
    8020587a:	fe043783          	ld	a5,-32(s0)
    8020587e:	63fc                	ld	a5,192(a5)
    80205880:	fffff717          	auipc	a4,0xfffff
    80205884:	fa070713          	addi	a4,a4,-96 # 80204820 <usertrap>
    80205888:	ef98                	sd	a4,24(a5)
	p->trapframe->kernel_vec = (uint64)kernelvec;
    8020588a:	fe043783          	ld	a5,-32(s0)
    8020588e:	63fc                	ld	a5,192(a5)
    80205890:	fffff717          	auipc	a4,0xfffff
    80205894:	3b070713          	addi	a4,a4,944 # 80204c40 <kernelvec>
    80205898:	f398                	sd	a4,32(a5)
    p->state = RUNNABLE;
    8020589a:	fe043783          	ld	a5,-32(s0)
    8020589e:	470d                	li	a4,3
    802058a0:	c398                	sw	a4,0(a5)
	if (map_page(p->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_X | PTE_R) != 0) {
    802058a2:	fe043783          	ld	a5,-32(s0)
    802058a6:	7fd8                	ld	a4,184(a5)
    802058a8:	00021797          	auipc	a5,0x21
    802058ac:	7f078793          	addi	a5,a5,2032 # 80227098 <trampoline_phys_addr>
    802058b0:	639c                	ld	a5,0(a5)
    802058b2:	46a9                	li	a3,10
    802058b4:	863e                	mv	a2,a5
    802058b6:	75fd                	lui	a1,0xfffff
    802058b8:	853a                	mv	a0,a4
    802058ba:	ffffd097          	auipc	ra,0xffffd
    802058be:	aa2080e7          	jalr	-1374(ra) # 8020235c <map_page>
    802058c2:	87aa                	mv	a5,a0
    802058c4:	cb89                	beqz	a5,802058d6 <create_user_proc+0x21a>
		free_proc(p);
    802058c6:	fe043503          	ld	a0,-32(s0)
    802058ca:	00000097          	auipc	ra,0x0
    802058ce:	c46080e7          	jalr	-954(ra) # 80205510 <free_proc>
		return -1;
    802058d2:	57fd                	li	a5,-1
    802058d4:	a839                	j	802058f2 <create_user_proc+0x236>
    struct proc *parent = myproc();
    802058d6:	fffff097          	auipc	ra,0xfffff
    802058da:	6ba080e7          	jalr	1722(ra) # 80204f90 <myproc>
    802058de:	fca43023          	sd	a0,-64(s0)
    p->parent = parent ? parent : NULL;
    802058e2:	fe043783          	ld	a5,-32(s0)
    802058e6:	fc043703          	ld	a4,-64(s0)
    802058ea:	efd8                	sd	a4,152(a5)
    return p->pid;
    802058ec:	fe043783          	ld	a5,-32(s0)
    802058f0:	43dc                	lw	a5,4(a5)
}
    802058f2:	853e                	mv	a0,a5
    802058f4:	60e6                	ld	ra,88(sp)
    802058f6:	6446                	ld	s0,80(sp)
    802058f8:	6125                	addi	sp,sp,96
    802058fa:	8082                	ret

00000000802058fc <fork_proc>:
int fork_proc(void) {
    802058fc:	7179                	addi	sp,sp,-48
    802058fe:	f406                	sd	ra,40(sp)
    80205900:	f022                	sd	s0,32(sp)
    80205902:	1800                	addi	s0,sp,48
    struct proc *parent = myproc();
    80205904:	fffff097          	auipc	ra,0xfffff
    80205908:	68c080e7          	jalr	1676(ra) # 80204f90 <myproc>
    8020590c:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc(parent->is_user);
    80205910:	fe843783          	ld	a5,-24(s0)
    80205914:	0a87a783          	lw	a5,168(a5)
    80205918:	853e                	mv	a0,a5
    8020591a:	00000097          	auipc	ra,0x0
    8020591e:	a52080e7          	jalr	-1454(ra) # 8020536c <alloc_proc>
    80205922:	fea43023          	sd	a0,-32(s0)
    if (!child) return -1;
    80205926:	fe043783          	ld	a5,-32(s0)
    8020592a:	e399                	bnez	a5,80205930 <fork_proc+0x34>
    8020592c:	57fd                	li	a5,-1
    8020592e:	a279                	j	80205abc <fork_proc+0x1c0>
    if (uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0) {
    80205930:	fe843783          	ld	a5,-24(s0)
    80205934:	7fd8                	ld	a4,184(a5)
    80205936:	fe043783          	ld	a5,-32(s0)
    8020593a:	7fd4                	ld	a3,184(a5)
    8020593c:	fe843783          	ld	a5,-24(s0)
    80205940:	7bdc                	ld	a5,176(a5)
    80205942:	863e                	mv	a2,a5
    80205944:	85b6                	mv	a1,a3
    80205946:	853a                	mv	a0,a4
    80205948:	ffffd097          	auipc	ra,0xffffd
    8020594c:	780080e7          	jalr	1920(ra) # 802030c8 <uvmcopy>
    80205950:	87aa                	mv	a5,a0
    80205952:	0007da63          	bgez	a5,80205966 <fork_proc+0x6a>
        free_proc(child);
    80205956:	fe043503          	ld	a0,-32(s0)
    8020595a:	00000097          	auipc	ra,0x0
    8020595e:	bb6080e7          	jalr	-1098(ra) # 80205510 <free_proc>
        return -1;
    80205962:	57fd                	li	a5,-1
    80205964:	aaa1                	j	80205abc <fork_proc+0x1c0>
    child->sz = parent->sz;
    80205966:	fe843783          	ld	a5,-24(s0)
    8020596a:	7bd8                	ld	a4,176(a5)
    8020596c:	fe043783          	ld	a5,-32(s0)
    80205970:	fbd8                	sd	a4,176(a5)
    uint64 tf_pa = (uint64)child->trapframe;
    80205972:	fe043783          	ld	a5,-32(s0)
    80205976:	63fc                	ld	a5,192(a5)
    80205978:	fcf43c23          	sd	a5,-40(s0)
    if ((tf_pa & (PGSIZE - 1)) != 0) {
    8020597c:	fd843703          	ld	a4,-40(s0)
    80205980:	6785                	lui	a5,0x1
    80205982:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80205984:	8ff9                	and	a5,a5,a4
    80205986:	c39d                	beqz	a5,802059ac <fork_proc+0xb0>
        printf("[fork] trapframe not aligned: 0x%lx\n", tf_pa);
    80205988:	fd843583          	ld	a1,-40(s0)
    8020598c:	0001a517          	auipc	a0,0x1a
    80205990:	65c50513          	addi	a0,a0,1628 # 8021ffe8 <user_test_table+0x1f0>
    80205994:	ffffb097          	auipc	ra,0xffffb
    80205998:	372080e7          	jalr	882(ra) # 80200d06 <printf>
        free_proc(child);
    8020599c:	fe043503          	ld	a0,-32(s0)
    802059a0:	00000097          	auipc	ra,0x0
    802059a4:	b70080e7          	jalr	-1168(ra) # 80205510 <free_proc>
        return -1;
    802059a8:	57fd                	li	a5,-1
    802059aa:	aa09                	j	80205abc <fork_proc+0x1c0>
    if (map_page(child->pagetable, TRAPFRAME, tf_pa, PTE_R | PTE_W) != 0) {
    802059ac:	fe043783          	ld	a5,-32(s0)
    802059b0:	7fdc                	ld	a5,184(a5)
    802059b2:	4699                	li	a3,6
    802059b4:	fd843603          	ld	a2,-40(s0)
    802059b8:	75f9                	lui	a1,0xffffe
    802059ba:	853e                	mv	a0,a5
    802059bc:	ffffd097          	auipc	ra,0xffffd
    802059c0:	9a0080e7          	jalr	-1632(ra) # 8020235c <map_page>
    802059c4:	87aa                	mv	a5,a0
    802059c6:	c38d                	beqz	a5,802059e8 <fork_proc+0xec>
        printf("[fork] map TRAPFRAME failed\n");
    802059c8:	0001a517          	auipc	a0,0x1a
    802059cc:	64850513          	addi	a0,a0,1608 # 80220010 <user_test_table+0x218>
    802059d0:	ffffb097          	auipc	ra,0xffffb
    802059d4:	336080e7          	jalr	822(ra) # 80200d06 <printf>
        free_proc(child);
    802059d8:	fe043503          	ld	a0,-32(s0)
    802059dc:	00000097          	auipc	ra,0x0
    802059e0:	b34080e7          	jalr	-1228(ra) # 80205510 <free_proc>
        return -1;
    802059e4:	57fd                	li	a5,-1
    802059e6:	a8d9                	j	80205abc <fork_proc+0x1c0>
    if (map_page(child->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_R | PTE_X) != 0) {
    802059e8:	fe043783          	ld	a5,-32(s0)
    802059ec:	7fd8                	ld	a4,184(a5)
    802059ee:	00021797          	auipc	a5,0x21
    802059f2:	6aa78793          	addi	a5,a5,1706 # 80227098 <trampoline_phys_addr>
    802059f6:	639c                	ld	a5,0(a5)
    802059f8:	46a9                	li	a3,10
    802059fa:	863e                	mv	a2,a5
    802059fc:	75fd                	lui	a1,0xfffff
    802059fe:	853a                	mv	a0,a4
    80205a00:	ffffd097          	auipc	ra,0xffffd
    80205a04:	95c080e7          	jalr	-1700(ra) # 8020235c <map_page>
    80205a08:	87aa                	mv	a5,a0
    80205a0a:	c38d                	beqz	a5,80205a2c <fork_proc+0x130>
        printf("[fork] map TRAMPOLINE failed\n");
    80205a0c:	0001a517          	auipc	a0,0x1a
    80205a10:	62450513          	addi	a0,a0,1572 # 80220030 <user_test_table+0x238>
    80205a14:	ffffb097          	auipc	ra,0xffffb
    80205a18:	2f2080e7          	jalr	754(ra) # 80200d06 <printf>
        free_proc(child);
    80205a1c:	fe043503          	ld	a0,-32(s0)
    80205a20:	00000097          	auipc	ra,0x0
    80205a24:	af0080e7          	jalr	-1296(ra) # 80205510 <free_proc>
        return -1;
    80205a28:	57fd                	li	a5,-1
    80205a2a:	a849                	j	80205abc <fork_proc+0x1c0>
    *(child->trapframe) = *(parent->trapframe);
    80205a2c:	fe843783          	ld	a5,-24(s0)
    80205a30:	63f8                	ld	a4,192(a5)
    80205a32:	fe043783          	ld	a5,-32(s0)
    80205a36:	63fc                	ld	a5,192(a5)
    80205a38:	86be                	mv	a3,a5
    80205a3a:	13800793          	li	a5,312
    80205a3e:	863e                	mv	a2,a5
    80205a40:	85ba                	mv	a1,a4
    80205a42:	8536                	mv	a0,a3
    80205a44:	ffffc097          	auipc	ra,0xffffc
    80205a48:	558080e7          	jalr	1368(ra) # 80201f9c <memcpy>
	child->trapframe->kernel_sp = child->kstack + PGSIZE;
    80205a4c:	fe043783          	ld	a5,-32(s0)
    80205a50:	6794                	ld	a3,8(a5)
    80205a52:	fe043783          	ld	a5,-32(s0)
    80205a56:	63fc                	ld	a5,192(a5)
    80205a58:	6705                	lui	a4,0x1
    80205a5a:	9736                	add	a4,a4,a3
    80205a5c:	e798                	sd	a4,8(a5)
	assert(child->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable));
    80205a5e:	00021797          	auipc	a5,0x21
    80205a62:	63278793          	addi	a5,a5,1586 # 80227090 <kernel_pagetable>
    80205a66:	639c                	ld	a5,0(a5)
    80205a68:	00c7d693          	srli	a3,a5,0xc
    80205a6c:	fe043783          	ld	a5,-32(s0)
    80205a70:	63fc                	ld	a5,192(a5)
    80205a72:	577d                	li	a4,-1
    80205a74:	177e                	slli	a4,a4,0x3f
    80205a76:	8f55                	or	a4,a4,a3
    80205a78:	e398                	sd	a4,0(a5)
    80205a7a:	639c                	ld	a5,0(a5)
    80205a7c:	2781                	sext.w	a5,a5
    80205a7e:	853e                	mv	a0,a5
    80205a80:	fffff097          	auipc	ra,0xfffff
    80205a84:	49a080e7          	jalr	1178(ra) # 80204f1a <assert>
    child->trapframe->epc += 4;  // 跳过 ecall 指令
    80205a88:	fe043783          	ld	a5,-32(s0)
    80205a8c:	63fc                	ld	a5,192(a5)
    80205a8e:	7f98                	ld	a4,56(a5)
    80205a90:	fe043783          	ld	a5,-32(s0)
    80205a94:	63fc                	ld	a5,192(a5)
    80205a96:	0711                	addi	a4,a4,4 # 1004 <_entry-0x801feffc>
    80205a98:	ff98                	sd	a4,56(a5)
    child->trapframe->a0 = 0;    // 子进程fork返回0
    80205a9a:	fe043783          	ld	a5,-32(s0)
    80205a9e:	63fc                	ld	a5,192(a5)
    80205aa0:	0a07b423          	sd	zero,168(a5)
    child->state = RUNNABLE;
    80205aa4:	fe043783          	ld	a5,-32(s0)
    80205aa8:	470d                	li	a4,3
    80205aaa:	c398                	sw	a4,0(a5)
    child->parent = parent;
    80205aac:	fe043783          	ld	a5,-32(s0)
    80205ab0:	fe843703          	ld	a4,-24(s0)
    80205ab4:	efd8                	sd	a4,152(a5)
    return child->pid;
    80205ab6:	fe043783          	ld	a5,-32(s0)
    80205aba:	43dc                	lw	a5,4(a5)
}
    80205abc:	853e                	mv	a0,a5
    80205abe:	70a2                	ld	ra,40(sp)
    80205ac0:	7402                	ld	s0,32(sp)
    80205ac2:	6145                	addi	sp,sp,48
    80205ac4:	8082                	ret

0000000080205ac6 <schedule>:
void schedule(void) {
    80205ac6:	7179                	addi	sp,sp,-48
    80205ac8:	f406                	sd	ra,40(sp)
    80205aca:	f022                	sd	s0,32(sp)
    80205acc:	1800                	addi	s0,sp,48
  struct cpu *c = mycpu();
    80205ace:	fffff097          	auipc	ra,0xfffff
    80205ad2:	4da080e7          	jalr	1242(ra) # 80204fa8 <mycpu>
    80205ad6:	fea43023          	sd	a0,-32(s0)
    intr_on();
    80205ada:	fffff097          	auipc	ra,0xfffff
    80205ade:	3d4080e7          	jalr	980(ra) # 80204eae <intr_on>
    for(int i = 0; i < PROC; i++) {
    80205ae2:	fe042623          	sw	zero,-20(s0)
    80205ae6:	a8bd                	j	80205b64 <schedule+0x9e>
        struct proc *p = proc_table[i];
    80205ae8:	00022717          	auipc	a4,0x22
    80205aec:	98070713          	addi	a4,a4,-1664 # 80227468 <proc_table>
    80205af0:	fec42783          	lw	a5,-20(s0)
    80205af4:	078e                	slli	a5,a5,0x3
    80205af6:	97ba                	add	a5,a5,a4
    80205af8:	639c                	ld	a5,0(a5)
    80205afa:	fcf43c23          	sd	a5,-40(s0)
      	if(p->state == RUNNABLE) {
    80205afe:	fd843783          	ld	a5,-40(s0)
    80205b02:	439c                	lw	a5,0(a5)
    80205b04:	873e                	mv	a4,a5
    80205b06:	478d                	li	a5,3
    80205b08:	04f71963          	bne	a4,a5,80205b5a <schedule+0x94>
			p->state = RUNNING;
    80205b0c:	fd843783          	ld	a5,-40(s0)
    80205b10:	4711                	li	a4,4
    80205b12:	c398                	sw	a4,0(a5)
			c->proc = p;
    80205b14:	fe043783          	ld	a5,-32(s0)
    80205b18:	fd843703          	ld	a4,-40(s0)
    80205b1c:	e398                	sd	a4,0(a5)
			current_proc = p;
    80205b1e:	00021797          	auipc	a5,0x21
    80205b22:	58a78793          	addi	a5,a5,1418 # 802270a8 <current_proc>
    80205b26:	fd843703          	ld	a4,-40(s0)
    80205b2a:	e398                	sd	a4,0(a5)
			swtch(&c->context, &p->context);
    80205b2c:	fe043783          	ld	a5,-32(s0)
    80205b30:	00878713          	addi	a4,a5,8
    80205b34:	fd843783          	ld	a5,-40(s0)
    80205b38:	07c1                	addi	a5,a5,16
    80205b3a:	85be                	mv	a1,a5
    80205b3c:	853a                	mv	a0,a4
    80205b3e:	fffff097          	auipc	ra,0xfffff
    80205b42:	2d2080e7          	jalr	722(ra) # 80204e10 <swtch>
			c->proc = 0;
    80205b46:	fe043783          	ld	a5,-32(s0)
    80205b4a:	0007b023          	sd	zero,0(a5)
			current_proc = 0;
    80205b4e:	00021797          	auipc	a5,0x21
    80205b52:	55a78793          	addi	a5,a5,1370 # 802270a8 <current_proc>
    80205b56:	0007b023          	sd	zero,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205b5a:	fec42783          	lw	a5,-20(s0)
    80205b5e:	2785                	addiw	a5,a5,1
    80205b60:	fef42623          	sw	a5,-20(s0)
    80205b64:	fec42783          	lw	a5,-20(s0)
    80205b68:	0007871b          	sext.w	a4,a5
    80205b6c:	47fd                	li	a5,31
    80205b6e:	f6e7dde3          	bge	a5,a4,80205ae8 <schedule+0x22>
    intr_on();
    80205b72:	b7a5                	j	80205ada <schedule+0x14>

0000000080205b74 <yield>:
void yield(void) {
    80205b74:	1101                	addi	sp,sp,-32
    80205b76:	ec06                	sd	ra,24(sp)
    80205b78:	e822                	sd	s0,16(sp)
    80205b7a:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80205b7c:	fffff097          	auipc	ra,0xfffff
    80205b80:	414080e7          	jalr	1044(ra) # 80204f90 <myproc>
    80205b84:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205b88:	fe843783          	ld	a5,-24(s0)
    80205b8c:	c3d1                	beqz	a5,80205c10 <yield+0x9c>
    intr_off();
    80205b8e:	fffff097          	auipc	ra,0xfffff
    80205b92:	34a080e7          	jalr	842(ra) # 80204ed8 <intr_off>
    struct cpu *c = mycpu();
    80205b96:	fffff097          	auipc	ra,0xfffff
    80205b9a:	412080e7          	jalr	1042(ra) # 80204fa8 <mycpu>
    80205b9e:	fea43023          	sd	a0,-32(s0)
    p->state = RUNNABLE;
    80205ba2:	fe843783          	ld	a5,-24(s0)
    80205ba6:	470d                	li	a4,3
    80205ba8:	c398                	sw	a4,0(a5)
    current_proc = 0;
    80205baa:	00021797          	auipc	a5,0x21
    80205bae:	4fe78793          	addi	a5,a5,1278 # 802270a8 <current_proc>
    80205bb2:	0007b023          	sd	zero,0(a5)
    c->proc = 0;
    80205bb6:	fe043783          	ld	a5,-32(s0)
    80205bba:	0007b023          	sd	zero,0(a5)
    swtch(&p->context, &c->context);
    80205bbe:	fe843783          	ld	a5,-24(s0)
    80205bc2:	01078713          	addi	a4,a5,16
    80205bc6:	fe043783          	ld	a5,-32(s0)
    80205bca:	07a1                	addi	a5,a5,8
    80205bcc:	85be                	mv	a1,a5
    80205bce:	853a                	mv	a0,a4
    80205bd0:	fffff097          	auipc	ra,0xfffff
    80205bd4:	240080e7          	jalr	576(ra) # 80204e10 <swtch>
    intr_on();
    80205bd8:	fffff097          	auipc	ra,0xfffff
    80205bdc:	2d6080e7          	jalr	726(ra) # 80204eae <intr_on>
	if (p->killed) {
    80205be0:	fe843783          	ld	a5,-24(s0)
    80205be4:	0807a783          	lw	a5,128(a5)
    80205be8:	c78d                	beqz	a5,80205c12 <yield+0x9e>
        printf("[yield] Process PID %d killed during yield\n", p->pid);
    80205bea:	fe843783          	ld	a5,-24(s0)
    80205bee:	43dc                	lw	a5,4(a5)
    80205bf0:	85be                	mv	a1,a5
    80205bf2:	0001a517          	auipc	a0,0x1a
    80205bf6:	45e50513          	addi	a0,a0,1118 # 80220050 <user_test_table+0x258>
    80205bfa:	ffffb097          	auipc	ra,0xffffb
    80205bfe:	10c080e7          	jalr	268(ra) # 80200d06 <printf>
        exit_proc(SYS_kill);
    80205c02:	08100513          	li	a0,129
    80205c06:	00000097          	auipc	ra,0x0
    80205c0a:	17c080e7          	jalr	380(ra) # 80205d82 <exit_proc>
        return;
    80205c0e:	a011                	j	80205c12 <yield+0x9e>
        return;
    80205c10:	0001                	nop
}
    80205c12:	60e2                	ld	ra,24(sp)
    80205c14:	6442                	ld	s0,16(sp)
    80205c16:	6105                	addi	sp,sp,32
    80205c18:	8082                	ret

0000000080205c1a <sleep>:
void sleep(void *chan){
    80205c1a:	7179                	addi	sp,sp,-48
    80205c1c:	f406                	sd	ra,40(sp)
    80205c1e:	f022                	sd	s0,32(sp)
    80205c20:	1800                	addi	s0,sp,48
    80205c22:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = myproc();
    80205c26:	fffff097          	auipc	ra,0xfffff
    80205c2a:	36a080e7          	jalr	874(ra) # 80204f90 <myproc>
    80205c2e:	fea43423          	sd	a0,-24(s0)
    struct cpu *c = mycpu();
    80205c32:	fffff097          	auipc	ra,0xfffff
    80205c36:	376080e7          	jalr	886(ra) # 80204fa8 <mycpu>
    80205c3a:	fea43023          	sd	a0,-32(s0)
    p->context.ra = ra;
    80205c3e:	8706                	mv	a4,ra
    80205c40:	fe843783          	ld	a5,-24(s0)
    80205c44:	eb98                	sd	a4,16(a5)
    p->chan = chan;
    80205c46:	fe843783          	ld	a5,-24(s0)
    80205c4a:	fd843703          	ld	a4,-40(s0)
    80205c4e:	f3d8                	sd	a4,160(a5)
    p->state = SLEEPING;
    80205c50:	fe843783          	ld	a5,-24(s0)
    80205c54:	4709                	li	a4,2
    80205c56:	c398                	sw	a4,0(a5)
    swtch(&p->context, &c->context);
    80205c58:	fe843783          	ld	a5,-24(s0)
    80205c5c:	01078713          	addi	a4,a5,16
    80205c60:	fe043783          	ld	a5,-32(s0)
    80205c64:	07a1                	addi	a5,a5,8
    80205c66:	85be                	mv	a1,a5
    80205c68:	853a                	mv	a0,a4
    80205c6a:	fffff097          	auipc	ra,0xfffff
    80205c6e:	1a6080e7          	jalr	422(ra) # 80204e10 <swtch>
    p->chan = 0;
    80205c72:	fe843783          	ld	a5,-24(s0)
    80205c76:	0a07b023          	sd	zero,160(a5)
	if(p->killed){
    80205c7a:	fe843783          	ld	a5,-24(s0)
    80205c7e:	0807a783          	lw	a5,128(a5)
    80205c82:	c39d                	beqz	a5,80205ca8 <sleep+0x8e>
		printf("[sleep] Process PID %d killed when wakeup\n", p->pid);
    80205c84:	fe843783          	ld	a5,-24(s0)
    80205c88:	43dc                	lw	a5,4(a5)
    80205c8a:	85be                	mv	a1,a5
    80205c8c:	0001a517          	auipc	a0,0x1a
    80205c90:	3f450513          	addi	a0,a0,1012 # 80220080 <user_test_table+0x288>
    80205c94:	ffffb097          	auipc	ra,0xffffb
    80205c98:	072080e7          	jalr	114(ra) # 80200d06 <printf>
		exit_proc(SYS_kill);
    80205c9c:	08100513          	li	a0,129
    80205ca0:	00000097          	auipc	ra,0x0
    80205ca4:	0e2080e7          	jalr	226(ra) # 80205d82 <exit_proc>
}
    80205ca8:	0001                	nop
    80205caa:	70a2                	ld	ra,40(sp)
    80205cac:	7402                	ld	s0,32(sp)
    80205cae:	6145                	addi	sp,sp,48
    80205cb0:	8082                	ret

0000000080205cb2 <wakeup>:
void wakeup(void *chan) {
    80205cb2:	7179                	addi	sp,sp,-48
    80205cb4:	f422                	sd	s0,40(sp)
    80205cb6:	1800                	addi	s0,sp,48
    80205cb8:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < PROC; i++) {
    80205cbc:	fe042623          	sw	zero,-20(s0)
    80205cc0:	a099                	j	80205d06 <wakeup+0x54>
        struct proc *p = proc_table[i];
    80205cc2:	00021717          	auipc	a4,0x21
    80205cc6:	7a670713          	addi	a4,a4,1958 # 80227468 <proc_table>
    80205cca:	fec42783          	lw	a5,-20(s0)
    80205cce:	078e                	slli	a5,a5,0x3
    80205cd0:	97ba                	add	a5,a5,a4
    80205cd2:	639c                	ld	a5,0(a5)
    80205cd4:	fef43023          	sd	a5,-32(s0)
        if(p->state == SLEEPING && p->chan == chan) {
    80205cd8:	fe043783          	ld	a5,-32(s0)
    80205cdc:	439c                	lw	a5,0(a5)
    80205cde:	873e                	mv	a4,a5
    80205ce0:	4789                	li	a5,2
    80205ce2:	00f71d63          	bne	a4,a5,80205cfc <wakeup+0x4a>
    80205ce6:	fe043783          	ld	a5,-32(s0)
    80205cea:	73dc                	ld	a5,160(a5)
    80205cec:	fd843703          	ld	a4,-40(s0)
    80205cf0:	00f71663          	bne	a4,a5,80205cfc <wakeup+0x4a>
            p->state = RUNNABLE;
    80205cf4:	fe043783          	ld	a5,-32(s0)
    80205cf8:	470d                	li	a4,3
    80205cfa:	c398                	sw	a4,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205cfc:	fec42783          	lw	a5,-20(s0)
    80205d00:	2785                	addiw	a5,a5,1
    80205d02:	fef42623          	sw	a5,-20(s0)
    80205d06:	fec42783          	lw	a5,-20(s0)
    80205d0a:	0007871b          	sext.w	a4,a5
    80205d0e:	47fd                	li	a5,31
    80205d10:	fae7d9e3          	bge	a5,a4,80205cc2 <wakeup+0x10>
}
    80205d14:	0001                	nop
    80205d16:	0001                	nop
    80205d18:	7422                	ld	s0,40(sp)
    80205d1a:	6145                	addi	sp,sp,48
    80205d1c:	8082                	ret

0000000080205d1e <kill_proc>:
void kill_proc(int pid){
    80205d1e:	7179                	addi	sp,sp,-48
    80205d20:	f422                	sd	s0,40(sp)
    80205d22:	1800                	addi	s0,sp,48
    80205d24:	87aa                	mv	a5,a0
    80205d26:	fcf42e23          	sw	a5,-36(s0)
	for(int i=0;i<PROC;i++){
    80205d2a:	fe042623          	sw	zero,-20(s0)
    80205d2e:	a83d                	j	80205d6c <kill_proc+0x4e>
		struct proc *p = proc_table[i];
    80205d30:	00021717          	auipc	a4,0x21
    80205d34:	73870713          	addi	a4,a4,1848 # 80227468 <proc_table>
    80205d38:	fec42783          	lw	a5,-20(s0)
    80205d3c:	078e                	slli	a5,a5,0x3
    80205d3e:	97ba                	add	a5,a5,a4
    80205d40:	639c                	ld	a5,0(a5)
    80205d42:	fef43023          	sd	a5,-32(s0)
		if(pid == p->pid){
    80205d46:	fe043783          	ld	a5,-32(s0)
    80205d4a:	43d8                	lw	a4,4(a5)
    80205d4c:	fdc42783          	lw	a5,-36(s0)
    80205d50:	2781                	sext.w	a5,a5
    80205d52:	00e79863          	bne	a5,a4,80205d62 <kill_proc+0x44>
			p->killed = 1;
    80205d56:	fe043783          	ld	a5,-32(s0)
    80205d5a:	4705                	li	a4,1
    80205d5c:	08e7a023          	sw	a4,128(a5)
			break;
    80205d60:	a829                	j	80205d7a <kill_proc+0x5c>
	for(int i=0;i<PROC;i++){
    80205d62:	fec42783          	lw	a5,-20(s0)
    80205d66:	2785                	addiw	a5,a5,1
    80205d68:	fef42623          	sw	a5,-20(s0)
    80205d6c:	fec42783          	lw	a5,-20(s0)
    80205d70:	0007871b          	sext.w	a4,a5
    80205d74:	47fd                	li	a5,31
    80205d76:	fae7dde3          	bge	a5,a4,80205d30 <kill_proc+0x12>
	return;
    80205d7a:	0001                	nop
}
    80205d7c:	7422                	ld	s0,40(sp)
    80205d7e:	6145                	addi	sp,sp,48
    80205d80:	8082                	ret

0000000080205d82 <exit_proc>:
void exit_proc(int status) {
    80205d82:	7179                	addi	sp,sp,-48
    80205d84:	f406                	sd	ra,40(sp)
    80205d86:	f022                	sd	s0,32(sp)
    80205d88:	1800                	addi	s0,sp,48
    80205d8a:	87aa                	mv	a5,a0
    80205d8c:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    80205d90:	fffff097          	auipc	ra,0xfffff
    80205d94:	200080e7          	jalr	512(ra) # 80204f90 <myproc>
    80205d98:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205d9c:	fe843783          	ld	a5,-24(s0)
    80205da0:	eb89                	bnez	a5,80205db2 <exit_proc+0x30>
        panic("exit_proc: no current process");
    80205da2:	0001a517          	auipc	a0,0x1a
    80205da6:	30e50513          	addi	a0,a0,782 # 802200b0 <user_test_table+0x2b8>
    80205daa:	ffffc097          	auipc	ra,0xffffc
    80205dae:	9a8080e7          	jalr	-1624(ra) # 80201752 <panic>
    p->exit_status = status;
    80205db2:	fe843783          	ld	a5,-24(s0)
    80205db6:	fdc42703          	lw	a4,-36(s0)
    80205dba:	08e7a223          	sw	a4,132(a5)
    if (!p->parent) {
    80205dbe:	fe843783          	ld	a5,-24(s0)
    80205dc2:	6fdc                	ld	a5,152(a5)
    80205dc4:	e789                	bnez	a5,80205dce <exit_proc+0x4c>
        shutdown();
    80205dc6:	fffff097          	auipc	ra,0xfffff
    80205dca:	1a0080e7          	jalr	416(ra) # 80204f66 <shutdown>
    p->state = ZOMBIE;
    80205dce:	fe843783          	ld	a5,-24(s0)
    80205dd2:	4715                	li	a4,5
    80205dd4:	c398                	sw	a4,0(a5)
    wakeup((void*)p->parent);
    80205dd6:	fe843783          	ld	a5,-24(s0)
    80205dda:	6fdc                	ld	a5,152(a5)
    80205ddc:	853e                	mv	a0,a5
    80205dde:	00000097          	auipc	ra,0x0
    80205de2:	ed4080e7          	jalr	-300(ra) # 80205cb2 <wakeup>
    current_proc = 0;
    80205de6:	00021797          	auipc	a5,0x21
    80205dea:	2c278793          	addi	a5,a5,706 # 802270a8 <current_proc>
    80205dee:	0007b023          	sd	zero,0(a5)
    if (mycpu())
    80205df2:	fffff097          	auipc	ra,0xfffff
    80205df6:	1b6080e7          	jalr	438(ra) # 80204fa8 <mycpu>
    80205dfa:	87aa                	mv	a5,a0
    80205dfc:	cb81                	beqz	a5,80205e0c <exit_proc+0x8a>
        mycpu()->proc = 0;
    80205dfe:	fffff097          	auipc	ra,0xfffff
    80205e02:	1aa080e7          	jalr	426(ra) # 80204fa8 <mycpu>
    80205e06:	87aa                	mv	a5,a0
    80205e08:	0007b023          	sd	zero,0(a5)
    struct cpu *c = mycpu();
    80205e0c:	fffff097          	auipc	ra,0xfffff
    80205e10:	19c080e7          	jalr	412(ra) # 80204fa8 <mycpu>
    80205e14:	fea43023          	sd	a0,-32(s0)
    swtch(&p->context, &c->context);
    80205e18:	fe843783          	ld	a5,-24(s0)
    80205e1c:	01078713          	addi	a4,a5,16
    80205e20:	fe043783          	ld	a5,-32(s0)
    80205e24:	07a1                	addi	a5,a5,8
    80205e26:	85be                	mv	a1,a5
    80205e28:	853a                	mv	a0,a4
    80205e2a:	fffff097          	auipc	ra,0xfffff
    80205e2e:	fe6080e7          	jalr	-26(ra) # 80204e10 <swtch>
    panic("exit_proc should not return after schedule");
    80205e32:	0001a517          	auipc	a0,0x1a
    80205e36:	29e50513          	addi	a0,a0,670 # 802200d0 <user_test_table+0x2d8>
    80205e3a:	ffffc097          	auipc	ra,0xffffc
    80205e3e:	918080e7          	jalr	-1768(ra) # 80201752 <panic>
}
    80205e42:	0001                	nop
    80205e44:	70a2                	ld	ra,40(sp)
    80205e46:	7402                	ld	s0,32(sp)
    80205e48:	6145                	addi	sp,sp,48
    80205e4a:	8082                	ret

0000000080205e4c <wait_proc>:
int wait_proc(int *status) {
    80205e4c:	711d                	addi	sp,sp,-96
    80205e4e:	ec86                	sd	ra,88(sp)
    80205e50:	e8a2                	sd	s0,80(sp)
    80205e52:	1080                	addi	s0,sp,96
    80205e54:	faa43423          	sd	a0,-88(s0)
    struct proc *p = myproc();
    80205e58:	fffff097          	auipc	ra,0xfffff
    80205e5c:	138080e7          	jalr	312(ra) # 80204f90 <myproc>
    80205e60:	fca43023          	sd	a0,-64(s0)
    if (p == 0) {
    80205e64:	fc043783          	ld	a5,-64(s0)
    80205e68:	eb99                	bnez	a5,80205e7e <wait_proc+0x32>
        printf("Warning: wait_proc called with no current process\n");
    80205e6a:	0001a517          	auipc	a0,0x1a
    80205e6e:	29650513          	addi	a0,a0,662 # 80220100 <user_test_table+0x308>
    80205e72:	ffffb097          	auipc	ra,0xffffb
    80205e76:	e94080e7          	jalr	-364(ra) # 80200d06 <printf>
        return -1;
    80205e7a:	57fd                	li	a5,-1
    80205e7c:	aa91                	j	80205fd0 <wait_proc+0x184>
        intr_off();
    80205e7e:	fffff097          	auipc	ra,0xfffff
    80205e82:	05a080e7          	jalr	90(ra) # 80204ed8 <intr_off>
        int found_zombie = 0;
    80205e86:	fe042623          	sw	zero,-20(s0)
        int zombie_pid = 0;
    80205e8a:	fe042423          	sw	zero,-24(s0)
        int zombie_status = 0;
    80205e8e:	fe042223          	sw	zero,-28(s0)
        struct proc *zombie_child = 0;
    80205e92:	fc043c23          	sd	zero,-40(s0)
        for (int i = 0; i < PROC; i++) {
    80205e96:	fc042a23          	sw	zero,-44(s0)
    80205e9a:	a095                	j	80205efe <wait_proc+0xb2>
            struct proc *child = proc_table[i];
    80205e9c:	00021717          	auipc	a4,0x21
    80205ea0:	5cc70713          	addi	a4,a4,1484 # 80227468 <proc_table>
    80205ea4:	fd442783          	lw	a5,-44(s0)
    80205ea8:	078e                	slli	a5,a5,0x3
    80205eaa:	97ba                	add	a5,a5,a4
    80205eac:	639c                	ld	a5,0(a5)
    80205eae:	faf43c23          	sd	a5,-72(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    80205eb2:	fb843783          	ld	a5,-72(s0)
    80205eb6:	439c                	lw	a5,0(a5)
    80205eb8:	873e                	mv	a4,a5
    80205eba:	4795                	li	a5,5
    80205ebc:	02f71c63          	bne	a4,a5,80205ef4 <wait_proc+0xa8>
    80205ec0:	fb843783          	ld	a5,-72(s0)
    80205ec4:	6fdc                	ld	a5,152(a5)
    80205ec6:	fc043703          	ld	a4,-64(s0)
    80205eca:	02f71563          	bne	a4,a5,80205ef4 <wait_proc+0xa8>
                found_zombie = 1;
    80205ece:	4785                	li	a5,1
    80205ed0:	fef42623          	sw	a5,-20(s0)
                zombie_pid = child->pid;
    80205ed4:	fb843783          	ld	a5,-72(s0)
    80205ed8:	43dc                	lw	a5,4(a5)
    80205eda:	fef42423          	sw	a5,-24(s0)
                zombie_status = child->exit_status;
    80205ede:	fb843783          	ld	a5,-72(s0)
    80205ee2:	0847a783          	lw	a5,132(a5)
    80205ee6:	fef42223          	sw	a5,-28(s0)
                zombie_child = child;
    80205eea:	fb843783          	ld	a5,-72(s0)
    80205eee:	fcf43c23          	sd	a5,-40(s0)
                break;
    80205ef2:	a829                	j	80205f0c <wait_proc+0xc0>
        for (int i = 0; i < PROC; i++) {
    80205ef4:	fd442783          	lw	a5,-44(s0)
    80205ef8:	2785                	addiw	a5,a5,1
    80205efa:	fcf42a23          	sw	a5,-44(s0)
    80205efe:	fd442783          	lw	a5,-44(s0)
    80205f02:	0007871b          	sext.w	a4,a5
    80205f06:	47fd                	li	a5,31
    80205f08:	f8e7dae3          	bge	a5,a4,80205e9c <wait_proc+0x50>
        if (found_zombie) {
    80205f0c:	fec42783          	lw	a5,-20(s0)
    80205f10:	2781                	sext.w	a5,a5
    80205f12:	cb85                	beqz	a5,80205f42 <wait_proc+0xf6>
            if (status)
    80205f14:	fa843783          	ld	a5,-88(s0)
    80205f18:	c791                	beqz	a5,80205f24 <wait_proc+0xd8>
                *status = zombie_status;
    80205f1a:	fa843783          	ld	a5,-88(s0)
    80205f1e:	fe442703          	lw	a4,-28(s0)
    80205f22:	c398                	sw	a4,0(a5)
			intr_on();
    80205f24:	fffff097          	auipc	ra,0xfffff
    80205f28:	f8a080e7          	jalr	-118(ra) # 80204eae <intr_on>
            free_proc(zombie_child);
    80205f2c:	fd843503          	ld	a0,-40(s0)
    80205f30:	fffff097          	auipc	ra,0xfffff
    80205f34:	5e0080e7          	jalr	1504(ra) # 80205510 <free_proc>
            zombie_child = NULL;
    80205f38:	fc043c23          	sd	zero,-40(s0)
            return zombie_pid;
    80205f3c:	fe842783          	lw	a5,-24(s0)
    80205f40:	a841                	j	80205fd0 <wait_proc+0x184>
        }
        
        // 检查是否有任何活跃的子进程（非ZOMBIE状态）
        int havekids = 0;
    80205f42:	fc042823          	sw	zero,-48(s0)
        for (int i = 0; i < PROC; i++) {
    80205f46:	fc042623          	sw	zero,-52(s0)
    80205f4a:	a0b9                	j	80205f98 <wait_proc+0x14c>
            struct proc *child = proc_table[i];
    80205f4c:	00021717          	auipc	a4,0x21
    80205f50:	51c70713          	addi	a4,a4,1308 # 80227468 <proc_table>
    80205f54:	fcc42783          	lw	a5,-52(s0)
    80205f58:	078e                	slli	a5,a5,0x3
    80205f5a:	97ba                	add	a5,a5,a4
    80205f5c:	639c                	ld	a5,0(a5)
    80205f5e:	faf43823          	sd	a5,-80(s0)
            if (child->state != UNUSED && child->state != ZOMBIE && child->parent == p) {
    80205f62:	fb043783          	ld	a5,-80(s0)
    80205f66:	439c                	lw	a5,0(a5)
    80205f68:	c39d                	beqz	a5,80205f8e <wait_proc+0x142>
    80205f6a:	fb043783          	ld	a5,-80(s0)
    80205f6e:	439c                	lw	a5,0(a5)
    80205f70:	873e                	mv	a4,a5
    80205f72:	4795                	li	a5,5
    80205f74:	00f70d63          	beq	a4,a5,80205f8e <wait_proc+0x142>
    80205f78:	fb043783          	ld	a5,-80(s0)
    80205f7c:	6fdc                	ld	a5,152(a5)
    80205f7e:	fc043703          	ld	a4,-64(s0)
    80205f82:	00f71663          	bne	a4,a5,80205f8e <wait_proc+0x142>
                havekids = 1;
    80205f86:	4785                	li	a5,1
    80205f88:	fcf42823          	sw	a5,-48(s0)
                break;
    80205f8c:	a829                	j	80205fa6 <wait_proc+0x15a>
        for (int i = 0; i < PROC; i++) {
    80205f8e:	fcc42783          	lw	a5,-52(s0)
    80205f92:	2785                	addiw	a5,a5,1
    80205f94:	fcf42623          	sw	a5,-52(s0)
    80205f98:	fcc42783          	lw	a5,-52(s0)
    80205f9c:	0007871b          	sext.w	a4,a5
    80205fa0:	47fd                	li	a5,31
    80205fa2:	fae7d5e3          	bge	a5,a4,80205f4c <wait_proc+0x100>
            }
        }
        
        if (!havekids) {
    80205fa6:	fd042783          	lw	a5,-48(s0)
    80205faa:	2781                	sext.w	a5,a5
    80205fac:	e799                	bnez	a5,80205fba <wait_proc+0x16e>
            intr_on();
    80205fae:	fffff097          	auipc	ra,0xfffff
    80205fb2:	f00080e7          	jalr	-256(ra) # 80204eae <intr_on>
            return -1;
    80205fb6:	57fd                	li	a5,-1
    80205fb8:	a821                	j	80205fd0 <wait_proc+0x184>
        }
        
        // 有活跃子进程但没有僵尸子进程，进入睡眠等待
		intr_on();
    80205fba:	fffff097          	auipc	ra,0xfffff
    80205fbe:	ef4080e7          	jalr	-268(ra) # 80204eae <intr_on>
        sleep((void*)p);
    80205fc2:	fc043503          	ld	a0,-64(s0)
    80205fc6:	00000097          	auipc	ra,0x0
    80205fca:	c54080e7          	jalr	-940(ra) # 80205c1a <sleep>
    while (1) {
    80205fce:	bd45                	j	80205e7e <wait_proc+0x32>
    }
}
    80205fd0:	853e                	mv	a0,a5
    80205fd2:	60e6                	ld	ra,88(sp)
    80205fd4:	6446                	ld	s0,80(sp)
    80205fd6:	6125                	addi	sp,sp,96
    80205fd8:	8082                	ret

0000000080205fda <print_proc_table>:

void print_proc_table(void) {
    80205fda:	715d                	addi	sp,sp,-80
    80205fdc:	e486                	sd	ra,72(sp)
    80205fde:	e0a2                	sd	s0,64(sp)
    80205fe0:	0880                	addi	s0,sp,80
    int count = 0;
    80205fe2:	fe042623          	sw	zero,-20(s0)
    printf("PID  TYPE STATUS     PPID   FUNC_ADDR      STACK_ADDR    \n");
    80205fe6:	0001a517          	auipc	a0,0x1a
    80205fea:	15250513          	addi	a0,a0,338 # 80220138 <user_test_table+0x340>
    80205fee:	ffffb097          	auipc	ra,0xffffb
    80205ff2:	d18080e7          	jalr	-744(ra) # 80200d06 <printf>
    printf("----------------------------------------------------------\n");
    80205ff6:	0001a517          	auipc	a0,0x1a
    80205ffa:	18250513          	addi	a0,a0,386 # 80220178 <user_test_table+0x380>
    80205ffe:	ffffb097          	auipc	ra,0xffffb
    80206002:	d08080e7          	jalr	-760(ra) # 80200d06 <printf>
    for(int i = 0; i < PROC; i++) {
    80206006:	fe042423          	sw	zero,-24(s0)
    8020600a:	a2a9                	j	80206154 <print_proc_table+0x17a>
        struct proc *p = proc_table[i];
    8020600c:	00021717          	auipc	a4,0x21
    80206010:	45c70713          	addi	a4,a4,1116 # 80227468 <proc_table>
    80206014:	fe842783          	lw	a5,-24(s0)
    80206018:	078e                	slli	a5,a5,0x3
    8020601a:	97ba                	add	a5,a5,a4
    8020601c:	639c                	ld	a5,0(a5)
    8020601e:	fcf43c23          	sd	a5,-40(s0)
        if(p->state != UNUSED) {
    80206022:	fd843783          	ld	a5,-40(s0)
    80206026:	439c                	lw	a5,0(a5)
    80206028:	12078163          	beqz	a5,8020614a <print_proc_table+0x170>
            count++;
    8020602c:	fec42783          	lw	a5,-20(s0)
    80206030:	2785                	addiw	a5,a5,1
    80206032:	fef42623          	sw	a5,-20(s0)
            const char *type = (p->is_user ? "USR" : "SYS");
    80206036:	fd843783          	ld	a5,-40(s0)
    8020603a:	0a87a783          	lw	a5,168(a5)
    8020603e:	c791                	beqz	a5,8020604a <print_proc_table+0x70>
    80206040:	0001a797          	auipc	a5,0x1a
    80206044:	17878793          	addi	a5,a5,376 # 802201b8 <user_test_table+0x3c0>
    80206048:	a029                	j	80206052 <print_proc_table+0x78>
    8020604a:	0001a797          	auipc	a5,0x1a
    8020604e:	17678793          	addi	a5,a5,374 # 802201c0 <user_test_table+0x3c8>
    80206052:	fcf43823          	sd	a5,-48(s0)
            const char *status;
            switch(p->state) {
    80206056:	fd843783          	ld	a5,-40(s0)
    8020605a:	439c                	lw	a5,0(a5)
    8020605c:	86be                	mv	a3,a5
    8020605e:	4715                	li	a4,5
    80206060:	06d76c63          	bltu	a4,a3,802060d8 <print_proc_table+0xfe>
    80206064:	00279713          	slli	a4,a5,0x2
    80206068:	0001a797          	auipc	a5,0x1a
    8020606c:	1e078793          	addi	a5,a5,480 # 80220248 <user_test_table+0x450>
    80206070:	97ba                	add	a5,a5,a4
    80206072:	439c                	lw	a5,0(a5)
    80206074:	0007871b          	sext.w	a4,a5
    80206078:	0001a797          	auipc	a5,0x1a
    8020607c:	1d078793          	addi	a5,a5,464 # 80220248 <user_test_table+0x450>
    80206080:	97ba                	add	a5,a5,a4
    80206082:	8782                	jr	a5
                case UNUSED:   status = "UNUSED"; break;
    80206084:	0001a797          	auipc	a5,0x1a
    80206088:	14478793          	addi	a5,a5,324 # 802201c8 <user_test_table+0x3d0>
    8020608c:	fef43023          	sd	a5,-32(s0)
    80206090:	a899                	j	802060e6 <print_proc_table+0x10c>
                case USED:     status = "USED"; break;
    80206092:	0001a797          	auipc	a5,0x1a
    80206096:	13e78793          	addi	a5,a5,318 # 802201d0 <user_test_table+0x3d8>
    8020609a:	fef43023          	sd	a5,-32(s0)
    8020609e:	a0a1                	j	802060e6 <print_proc_table+0x10c>
                case SLEEPING: status = "SLEEP"; break;
    802060a0:	0001a797          	auipc	a5,0x1a
    802060a4:	13878793          	addi	a5,a5,312 # 802201d8 <user_test_table+0x3e0>
    802060a8:	fef43023          	sd	a5,-32(s0)
    802060ac:	a82d                	j	802060e6 <print_proc_table+0x10c>
                case RUNNABLE: status = "RUNNABLE"; break;
    802060ae:	0001a797          	auipc	a5,0x1a
    802060b2:	13278793          	addi	a5,a5,306 # 802201e0 <user_test_table+0x3e8>
    802060b6:	fef43023          	sd	a5,-32(s0)
    802060ba:	a035                	j	802060e6 <print_proc_table+0x10c>
                case RUNNING:  status = "RUNNING"; break;
    802060bc:	0001a797          	auipc	a5,0x1a
    802060c0:	13478793          	addi	a5,a5,308 # 802201f0 <user_test_table+0x3f8>
    802060c4:	fef43023          	sd	a5,-32(s0)
    802060c8:	a839                	j	802060e6 <print_proc_table+0x10c>
                case ZOMBIE:   status = "ZOMBIE"; break;
    802060ca:	0001a797          	auipc	a5,0x1a
    802060ce:	12e78793          	addi	a5,a5,302 # 802201f8 <user_test_table+0x400>
    802060d2:	fef43023          	sd	a5,-32(s0)
    802060d6:	a801                	j	802060e6 <print_proc_table+0x10c>
                default:       status = "UNKNOWN"; break;
    802060d8:	0001a797          	auipc	a5,0x1a
    802060dc:	12878793          	addi	a5,a5,296 # 80220200 <user_test_table+0x408>
    802060e0:	fef43023          	sd	a5,-32(s0)
    802060e4:	0001                	nop
            }
            int ppid = p->parent ? p->parent->pid : -1;
    802060e6:	fd843783          	ld	a5,-40(s0)
    802060ea:	6fdc                	ld	a5,152(a5)
    802060ec:	c791                	beqz	a5,802060f8 <print_proc_table+0x11e>
    802060ee:	fd843783          	ld	a5,-40(s0)
    802060f2:	6fdc                	ld	a5,152(a5)
    802060f4:	43dc                	lw	a5,4(a5)
    802060f6:	a011                	j	802060fa <print_proc_table+0x120>
    802060f8:	57fd                	li	a5,-1
    802060fa:	fcf42623          	sw	a5,-52(s0)
            unsigned long func_addr = p->trapframe ? p->trapframe->epc : 0;
    802060fe:	fd843783          	ld	a5,-40(s0)
    80206102:	63fc                	ld	a5,192(a5)
    80206104:	c791                	beqz	a5,80206110 <print_proc_table+0x136>
    80206106:	fd843783          	ld	a5,-40(s0)
    8020610a:	63fc                	ld	a5,192(a5)
    8020610c:	7f9c                	ld	a5,56(a5)
    8020610e:	a011                	j	80206112 <print_proc_table+0x138>
    80206110:	4781                	li	a5,0
    80206112:	fcf43023          	sd	a5,-64(s0)
            unsigned long stack_addr = p->kstack;
    80206116:	fd843783          	ld	a5,-40(s0)
    8020611a:	679c                	ld	a5,8(a5)
    8020611c:	faf43c23          	sd	a5,-72(s0)
            printf("%2d  %3s %8s %4d 0x%012lx 0x%012lx\n",
    80206120:	fd843783          	ld	a5,-40(s0)
    80206124:	43cc                	lw	a1,4(a5)
    80206126:	fcc42703          	lw	a4,-52(s0)
    8020612a:	fb843803          	ld	a6,-72(s0)
    8020612e:	fc043783          	ld	a5,-64(s0)
    80206132:	fe043683          	ld	a3,-32(s0)
    80206136:	fd043603          	ld	a2,-48(s0)
    8020613a:	0001a517          	auipc	a0,0x1a
    8020613e:	0ce50513          	addi	a0,a0,206 # 80220208 <user_test_table+0x410>
    80206142:	ffffb097          	auipc	ra,0xffffb
    80206146:	bc4080e7          	jalr	-1084(ra) # 80200d06 <printf>
    for(int i = 0; i < PROC; i++) {
    8020614a:	fe842783          	lw	a5,-24(s0)
    8020614e:	2785                	addiw	a5,a5,1
    80206150:	fef42423          	sw	a5,-24(s0)
    80206154:	fe842783          	lw	a5,-24(s0)
    80206158:	0007871b          	sext.w	a4,a5
    8020615c:	47fd                	li	a5,31
    8020615e:	eae7d7e3          	bge	a5,a4,8020600c <print_proc_table+0x32>
                p->pid, type, status, ppid, func_addr, stack_addr);
        }
    }
    printf("----------------------------------------------------------\n");
    80206162:	0001a517          	auipc	a0,0x1a
    80206166:	01650513          	addi	a0,a0,22 # 80220178 <user_test_table+0x380>
    8020616a:	ffffb097          	auipc	ra,0xffffb
    8020616e:	b9c080e7          	jalr	-1124(ra) # 80200d06 <printf>
    printf("%d active processes\n", count);
    80206172:	fec42783          	lw	a5,-20(s0)
    80206176:	85be                	mv	a1,a5
    80206178:	0001a517          	auipc	a0,0x1a
    8020617c:	0b850513          	addi	a0,a0,184 # 80220230 <user_test_table+0x438>
    80206180:	ffffb097          	auipc	ra,0xffffb
    80206184:	b86080e7          	jalr	-1146(ra) # 80200d06 <printf>
}
    80206188:	0001                	nop
    8020618a:	60a6                	ld	ra,72(sp)
    8020618c:	6406                	ld	s0,64(sp)
    8020618e:	6161                	addi	sp,sp,80
    80206190:	8082                	ret

0000000080206192 <get_proc>:

struct proc* get_proc(int pid){
    80206192:	7179                	addi	sp,sp,-48
    80206194:	f422                	sd	s0,40(sp)
    80206196:	1800                	addi	s0,sp,48
    80206198:	87aa                	mv	a5,a0
    8020619a:	fcf42e23          	sw	a5,-36(s0)
	    // 检查 PID 是否有效
    if (pid < 0 || pid >= PROC) {
    8020619e:	fdc42783          	lw	a5,-36(s0)
    802061a2:	2781                	sext.w	a5,a5
    802061a4:	0007c963          	bltz	a5,802061b6 <get_proc+0x24>
    802061a8:	fdc42783          	lw	a5,-36(s0)
    802061ac:	0007871b          	sext.w	a4,a5
    802061b0:	47fd                	li	a5,31
    802061b2:	00e7d463          	bge	a5,a4,802061ba <get_proc+0x28>
        return 0;
    802061b6:	4781                	li	a5,0
    802061b8:	a899                	j	8020620e <get_proc+0x7c>
    }
    // 遍历进程表查找匹配的 PID
    for (int i = 0; i < PROC; i++) {
    802061ba:	fe042623          	sw	zero,-20(s0)
    802061be:	a081                	j	802061fe <get_proc+0x6c>
        struct proc *p = proc_table[i];
    802061c0:	00021717          	auipc	a4,0x21
    802061c4:	2a870713          	addi	a4,a4,680 # 80227468 <proc_table>
    802061c8:	fec42783          	lw	a5,-20(s0)
    802061cc:	078e                	slli	a5,a5,0x3
    802061ce:	97ba                	add	a5,a5,a4
    802061d0:	639c                	ld	a5,0(a5)
    802061d2:	fef43023          	sd	a5,-32(s0)
        if (p->state != UNUSED && p->pid == pid) {
    802061d6:	fe043783          	ld	a5,-32(s0)
    802061da:	439c                	lw	a5,0(a5)
    802061dc:	cf81                	beqz	a5,802061f4 <get_proc+0x62>
    802061de:	fe043783          	ld	a5,-32(s0)
    802061e2:	43d8                	lw	a4,4(a5)
    802061e4:	fdc42783          	lw	a5,-36(s0)
    802061e8:	2781                	sext.w	a5,a5
    802061ea:	00e79563          	bne	a5,a4,802061f4 <get_proc+0x62>
            return p;
    802061ee:	fe043783          	ld	a5,-32(s0)
    802061f2:	a831                	j	8020620e <get_proc+0x7c>
    for (int i = 0; i < PROC; i++) {
    802061f4:	fec42783          	lw	a5,-20(s0)
    802061f8:	2785                	addiw	a5,a5,1
    802061fa:	fef42623          	sw	a5,-20(s0)
    802061fe:	fec42783          	lw	a5,-20(s0)
    80206202:	0007871b          	sext.w	a4,a5
    80206206:	47fd                	li	a5,31
    80206208:	fae7dce3          	bge	a5,a4,802061c0 <get_proc+0x2e>
        }
    }
    return 0;
    8020620c:	4781                	li	a5,0
    8020620e:	853e                	mv	a0,a5
    80206210:	7422                	ld	s0,40(sp)
    80206212:	6145                	addi	sp,sp,48
    80206214:	8082                	ret

0000000080206216 <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    80206216:	7179                	addi	sp,sp,-48
    80206218:	f422                	sd	s0,40(sp)
    8020621a:	1800                	addi	s0,sp,48
    8020621c:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    80206220:	fe042623          	sw	zero,-20(s0)
    80206224:	a031                	j	80206230 <strlen+0x1a>
    80206226:	fec42783          	lw	a5,-20(s0)
    8020622a:	2785                	addiw	a5,a5,1
    8020622c:	fef42623          	sw	a5,-20(s0)
    80206230:	fec42783          	lw	a5,-20(s0)
    80206234:	fd843703          	ld	a4,-40(s0)
    80206238:	97ba                	add	a5,a5,a4
    8020623a:	0007c783          	lbu	a5,0(a5)
    8020623e:	f7e5                	bnez	a5,80206226 <strlen+0x10>
        ;
    return n;
    80206240:	fec42783          	lw	a5,-20(s0)
}
    80206244:	853e                	mv	a0,a5
    80206246:	7422                	ld	s0,40(sp)
    80206248:	6145                	addi	sp,sp,48
    8020624a:	8082                	ret

000000008020624c <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    8020624c:	1101                	addi	sp,sp,-32
    8020624e:	ec22                	sd	s0,24(sp)
    80206250:	1000                	addi	s0,sp,32
    80206252:	fea43423          	sd	a0,-24(s0)
    80206256:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    8020625a:	a819                	j	80206270 <strcmp+0x24>
        p++, q++;
    8020625c:	fe843783          	ld	a5,-24(s0)
    80206260:	0785                	addi	a5,a5,1
    80206262:	fef43423          	sd	a5,-24(s0)
    80206266:	fe043783          	ld	a5,-32(s0)
    8020626a:	0785                	addi	a5,a5,1
    8020626c:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    80206270:	fe843783          	ld	a5,-24(s0)
    80206274:	0007c783          	lbu	a5,0(a5)
    80206278:	cb99                	beqz	a5,8020628e <strcmp+0x42>
    8020627a:	fe843783          	ld	a5,-24(s0)
    8020627e:	0007c703          	lbu	a4,0(a5)
    80206282:	fe043783          	ld	a5,-32(s0)
    80206286:	0007c783          	lbu	a5,0(a5)
    8020628a:	fcf709e3          	beq	a4,a5,8020625c <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    8020628e:	fe843783          	ld	a5,-24(s0)
    80206292:	0007c783          	lbu	a5,0(a5)
    80206296:	0007871b          	sext.w	a4,a5
    8020629a:	fe043783          	ld	a5,-32(s0)
    8020629e:	0007c783          	lbu	a5,0(a5)
    802062a2:	2781                	sext.w	a5,a5
    802062a4:	40f707bb          	subw	a5,a4,a5
    802062a8:	2781                	sext.w	a5,a5
}
    802062aa:	853e                	mv	a0,a5
    802062ac:	6462                	ld	s0,24(sp)
    802062ae:	6105                	addi	sp,sp,32
    802062b0:	8082                	ret

00000000802062b2 <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    802062b2:	7179                	addi	sp,sp,-48
    802062b4:	f422                	sd	s0,40(sp)
    802062b6:	1800                	addi	s0,sp,48
    802062b8:	fca43c23          	sd	a0,-40(s0)
    802062bc:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    802062c0:	fd843783          	ld	a5,-40(s0)
    802062c4:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    802062c8:	0001                	nop
    802062ca:	fd043703          	ld	a4,-48(s0)
    802062ce:	00170793          	addi	a5,a4,1
    802062d2:	fcf43823          	sd	a5,-48(s0)
    802062d6:	fd843783          	ld	a5,-40(s0)
    802062da:	00178693          	addi	a3,a5,1
    802062de:	fcd43c23          	sd	a3,-40(s0)
    802062e2:	00074703          	lbu	a4,0(a4)
    802062e6:	00e78023          	sb	a4,0(a5)
    802062ea:	0007c783          	lbu	a5,0(a5)
    802062ee:	fff1                	bnez	a5,802062ca <strcpy+0x18>
        ;
    return os;
    802062f0:	fe843783          	ld	a5,-24(s0)
}
    802062f4:	853e                	mv	a0,a5
    802062f6:	7422                	ld	s0,40(sp)
    802062f8:	6145                	addi	sp,sp,48
    802062fa:	8082                	ret

00000000802062fc <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    802062fc:	7139                	addi	sp,sp,-64
    802062fe:	fc22                	sd	s0,56(sp)
    80206300:	0080                	addi	s0,sp,64
    80206302:	fca43c23          	sd	a0,-40(s0)
    80206306:	fcb43823          	sd	a1,-48(s0)
    8020630a:	87b2                	mv	a5,a2
    8020630c:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    80206310:	fd843783          	ld	a5,-40(s0)
    80206314:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    80206318:	fcc42783          	lw	a5,-52(s0)
    8020631c:	2781                	sext.w	a5,a5
    8020631e:	00f04563          	bgtz	a5,80206328 <safestrcpy+0x2c>
        return os;
    80206322:	fe843783          	ld	a5,-24(s0)
    80206326:	a0a9                	j	80206370 <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    80206328:	0001                	nop
    8020632a:	fcc42783          	lw	a5,-52(s0)
    8020632e:	37fd                	addiw	a5,a5,-1
    80206330:	fcf42623          	sw	a5,-52(s0)
    80206334:	fcc42783          	lw	a5,-52(s0)
    80206338:	2781                	sext.w	a5,a5
    8020633a:	02f05563          	blez	a5,80206364 <safestrcpy+0x68>
    8020633e:	fd043703          	ld	a4,-48(s0)
    80206342:	00170793          	addi	a5,a4,1
    80206346:	fcf43823          	sd	a5,-48(s0)
    8020634a:	fd843783          	ld	a5,-40(s0)
    8020634e:	00178693          	addi	a3,a5,1
    80206352:	fcd43c23          	sd	a3,-40(s0)
    80206356:	00074703          	lbu	a4,0(a4)
    8020635a:	00e78023          	sb	a4,0(a5)
    8020635e:	0007c783          	lbu	a5,0(a5)
    80206362:	f7e1                	bnez	a5,8020632a <safestrcpy+0x2e>
        ;
    *s = 0;
    80206364:	fd843783          	ld	a5,-40(s0)
    80206368:	00078023          	sb	zero,0(a5)
    return os;
    8020636c:	fe843783          	ld	a5,-24(s0)
}
    80206370:	853e                	mv	a0,a5
    80206372:	7462                	ld	s0,56(sp)
    80206374:	6121                	addi	sp,sp,64
    80206376:	8082                	ret

0000000080206378 <atoi>:
// 将字符串转换为整数
int atoi(const char *s) {
    80206378:	7179                	addi	sp,sp,-48
    8020637a:	f422                	sd	s0,40(sp)
    8020637c:	1800                	addi	s0,sp,48
    8020637e:	fca43c23          	sd	a0,-40(s0)
    int n = 0;
    80206382:	fe042623          	sw	zero,-20(s0)
    int sign = 1;  // 正负号
    80206386:	4785                	li	a5,1
    80206388:	fef42423          	sw	a5,-24(s0)

    // 跳过空白字符
    while (*s == ' ' || *s == '\t') {
    8020638c:	a031                	j	80206398 <atoi+0x20>
        s++;
    8020638e:	fd843783          	ld	a5,-40(s0)
    80206392:	0785                	addi	a5,a5,1
    80206394:	fcf43c23          	sd	a5,-40(s0)
    while (*s == ' ' || *s == '\t') {
    80206398:	fd843783          	ld	a5,-40(s0)
    8020639c:	0007c783          	lbu	a5,0(a5)
    802063a0:	873e                	mv	a4,a5
    802063a2:	02000793          	li	a5,32
    802063a6:	fef704e3          	beq	a4,a5,8020638e <atoi+0x16>
    802063aa:	fd843783          	ld	a5,-40(s0)
    802063ae:	0007c783          	lbu	a5,0(a5)
    802063b2:	873e                	mv	a4,a5
    802063b4:	47a5                	li	a5,9
    802063b6:	fcf70ce3          	beq	a4,a5,8020638e <atoi+0x16>
    }

    // 处理符号
    if (*s == '-') {
    802063ba:	fd843783          	ld	a5,-40(s0)
    802063be:	0007c783          	lbu	a5,0(a5)
    802063c2:	873e                	mv	a4,a5
    802063c4:	02d00793          	li	a5,45
    802063c8:	00f71b63          	bne	a4,a5,802063de <atoi+0x66>
        sign = -1;
    802063cc:	57fd                	li	a5,-1
    802063ce:	fef42423          	sw	a5,-24(s0)
        s++;
    802063d2:	fd843783          	ld	a5,-40(s0)
    802063d6:	0785                	addi	a5,a5,1
    802063d8:	fcf43c23          	sd	a5,-40(s0)
    802063dc:	a899                	j	80206432 <atoi+0xba>
    } else if (*s == '+') {
    802063de:	fd843783          	ld	a5,-40(s0)
    802063e2:	0007c783          	lbu	a5,0(a5)
    802063e6:	873e                	mv	a4,a5
    802063e8:	02b00793          	li	a5,43
    802063ec:	04f71363          	bne	a4,a5,80206432 <atoi+0xba>
        s++;
    802063f0:	fd843783          	ld	a5,-40(s0)
    802063f4:	0785                	addi	a5,a5,1
    802063f6:	fcf43c23          	sd	a5,-40(s0)
    }

    // 转换数字字符
    while (*s >= '0' && *s <= '9') {
    802063fa:	a825                	j	80206432 <atoi+0xba>
        n = n * 10 + (*s - '0');
    802063fc:	fec42783          	lw	a5,-20(s0)
    80206400:	873e                	mv	a4,a5
    80206402:	87ba                	mv	a5,a4
    80206404:	0027979b          	slliw	a5,a5,0x2
    80206408:	9fb9                	addw	a5,a5,a4
    8020640a:	0017979b          	slliw	a5,a5,0x1
    8020640e:	0007871b          	sext.w	a4,a5
    80206412:	fd843783          	ld	a5,-40(s0)
    80206416:	0007c783          	lbu	a5,0(a5)
    8020641a:	2781                	sext.w	a5,a5
    8020641c:	fd07879b          	addiw	a5,a5,-48
    80206420:	2781                	sext.w	a5,a5
    80206422:	9fb9                	addw	a5,a5,a4
    80206424:	fef42623          	sw	a5,-20(s0)
        s++;
    80206428:	fd843783          	ld	a5,-40(s0)
    8020642c:	0785                	addi	a5,a5,1
    8020642e:	fcf43c23          	sd	a5,-40(s0)
    while (*s >= '0' && *s <= '9') {
    80206432:	fd843783          	ld	a5,-40(s0)
    80206436:	0007c783          	lbu	a5,0(a5)
    8020643a:	873e                	mv	a4,a5
    8020643c:	02f00793          	li	a5,47
    80206440:	00e7fb63          	bgeu	a5,a4,80206456 <atoi+0xde>
    80206444:	fd843783          	ld	a5,-40(s0)
    80206448:	0007c783          	lbu	a5,0(a5)
    8020644c:	873e                	mv	a4,a5
    8020644e:	03900793          	li	a5,57
    80206452:	fae7f5e3          	bgeu	a5,a4,802063fc <atoi+0x84>
    }

    return sign * n;
    80206456:	fe842783          	lw	a5,-24(s0)
    8020645a:	873e                	mv	a4,a5
    8020645c:	fec42783          	lw	a5,-20(s0)
    80206460:	02f707bb          	mulw	a5,a4,a5
    80206464:	2781                	sext.w	a5,a5
    80206466:	853e                	mv	a0,a5
    80206468:	7422                	ld	s0,40(sp)
    8020646a:	6145                	addi	sp,sp,48
    8020646c:	8082                	ret

000000008020646e <assert>:
    while (!proc_produced) {
		printf("wait for producer\n");
        sleep(&proc_produced); // 等待生产者
    }
    printf("Consumer: consumed value %d\n", proc_buffer);
    exit_proc(0);
    8020646e:	1101                	addi	sp,sp,-32
    80206470:	ec06                	sd	ra,24(sp)
    80206472:	e822                	sd	s0,16(sp)
    80206474:	1000                	addi	s0,sp,32
    80206476:	87aa                	mv	a5,a0
    80206478:	fef42623          	sw	a5,-20(s0)
}
    8020647c:	fec42783          	lw	a5,-20(s0)
    80206480:	2781                	sext.w	a5,a5
    80206482:	e79d                	bnez	a5,802064b0 <assert+0x42>
void test_synchronization(void) {
    80206484:	1b300613          	li	a2,435
    80206488:	0001e597          	auipc	a1,0x1e
    8020648c:	e9858593          	addi	a1,a1,-360 # 80224320 <user_test_table+0x78>
    80206490:	0001e517          	auipc	a0,0x1e
    80206494:	ea050513          	addi	a0,a0,-352 # 80224330 <user_test_table+0x88>
    80206498:	ffffb097          	auipc	ra,0xffffb
    8020649c:	86e080e7          	jalr	-1938(ra) # 80200d06 <printf>
    printf("===== 测试开始: 同步机制测试 =====\n");
    802064a0:	0001e517          	auipc	a0,0x1e
    802064a4:	eb850513          	addi	a0,a0,-328 # 80224358 <user_test_table+0xb0>
    802064a8:	ffffb097          	auipc	ra,0xffffb
    802064ac:	2aa080e7          	jalr	682(ra) # 80201752 <panic>

    // 初始化共享缓冲区
    802064b0:	0001                	nop
    802064b2:	60e2                	ld	ra,24(sp)
    802064b4:	6442                	ld	s0,16(sp)
    802064b6:	6105                	addi	sp,sp,32
    802064b8:	8082                	ret

00000000802064ba <get_time>:
uint64 get_time(void) {
    802064ba:	1141                	addi	sp,sp,-16
    802064bc:	e406                	sd	ra,8(sp)
    802064be:	e022                	sd	s0,0(sp)
    802064c0:	0800                	addi	s0,sp,16
    return sbi_get_time();
    802064c2:	ffffd097          	auipc	ra,0xffffd
    802064c6:	076080e7          	jalr	118(ra) # 80203538 <sbi_get_time>
    802064ca:	87aa                	mv	a5,a0
}
    802064cc:	853e                	mv	a0,a5
    802064ce:	60a2                	ld	ra,8(sp)
    802064d0:	6402                	ld	s0,0(sp)
    802064d2:	0141                	addi	sp,sp,16
    802064d4:	8082                	ret

00000000802064d6 <test_timer_interrupt>:
void test_timer_interrupt(void) {
    802064d6:	7179                	addi	sp,sp,-48
    802064d8:	f406                	sd	ra,40(sp)
    802064da:	f022                	sd	s0,32(sp)
    802064dc:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    802064de:	0001e517          	auipc	a0,0x1e
    802064e2:	e8250513          	addi	a0,a0,-382 # 80224360 <user_test_table+0xb8>
    802064e6:	ffffb097          	auipc	ra,0xffffb
    802064ea:	820080e7          	jalr	-2016(ra) # 80200d06 <printf>
    uint64 start_time = get_time();
    802064ee:	00000097          	auipc	ra,0x0
    802064f2:	fcc080e7          	jalr	-52(ra) # 802064ba <get_time>
    802064f6:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    802064fa:	fc042a23          	sw	zero,-44(s0)
    int last_count = 0;
    802064fe:	fe042623          	sw	zero,-20(s0)
    interrupt_test_flag = &interrupt_count;
    80206502:	00021797          	auipc	a5,0x21
    80206506:	bb678793          	addi	a5,a5,-1098 # 802270b8 <interrupt_test_flag>
    8020650a:	fd440713          	addi	a4,s0,-44
    8020650e:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    80206510:	a899                	j	80206566 <test_timer_interrupt+0x90>
        if (last_count != interrupt_count) {
    80206512:	fd442703          	lw	a4,-44(s0)
    80206516:	fec42783          	lw	a5,-20(s0)
    8020651a:	2781                	sext.w	a5,a5
    8020651c:	02e78163          	beq	a5,a4,8020653e <test_timer_interrupt+0x68>
            last_count = interrupt_count;
    80206520:	fd442783          	lw	a5,-44(s0)
    80206524:	fef42623          	sw	a5,-20(s0)
            printf("Received interrupt %d\n", interrupt_count);
    80206528:	fd442783          	lw	a5,-44(s0)
    8020652c:	85be                	mv	a1,a5
    8020652e:	0001e517          	auipc	a0,0x1e
    80206532:	e5250513          	addi	a0,a0,-430 # 80224380 <user_test_table+0xd8>
    80206536:	ffffa097          	auipc	ra,0xffffa
    8020653a:	7d0080e7          	jalr	2000(ra) # 80200d06 <printf>
        for (volatile int i = 0; i < 1000000; i++);
    8020653e:	fc042823          	sw	zero,-48(s0)
    80206542:	a801                	j	80206552 <test_timer_interrupt+0x7c>
    80206544:	fd042783          	lw	a5,-48(s0)
    80206548:	2781                	sext.w	a5,a5
    8020654a:	2785                	addiw	a5,a5,1
    8020654c:	2781                	sext.w	a5,a5
    8020654e:	fcf42823          	sw	a5,-48(s0)
    80206552:	fd042783          	lw	a5,-48(s0)
    80206556:	2781                	sext.w	a5,a5
    80206558:	873e                	mv	a4,a5
    8020655a:	000f47b7          	lui	a5,0xf4
    8020655e:	23f78793          	addi	a5,a5,575 # f423f <_entry-0x8010bdc1>
    80206562:	fee7d1e3          	bge	a5,a4,80206544 <test_timer_interrupt+0x6e>
    while (interrupt_count < 5) {
    80206566:	fd442783          	lw	a5,-44(s0)
    8020656a:	873e                	mv	a4,a5
    8020656c:	4791                	li	a5,4
    8020656e:	fae7d2e3          	bge	a5,a4,80206512 <test_timer_interrupt+0x3c>
    interrupt_test_flag = 0;
    80206572:	00021797          	auipc	a5,0x21
    80206576:	b4678793          	addi	a5,a5,-1210 # 802270b8 <interrupt_test_flag>
    8020657a:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    8020657e:	00000097          	auipc	ra,0x0
    80206582:	f3c080e7          	jalr	-196(ra) # 802064ba <get_time>
    80206586:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n",
    8020658a:	fd442683          	lw	a3,-44(s0)
    8020658e:	fd843703          	ld	a4,-40(s0)
    80206592:	fe043783          	ld	a5,-32(s0)
    80206596:	40f707b3          	sub	a5,a4,a5
    8020659a:	863e                	mv	a2,a5
    8020659c:	85b6                	mv	a1,a3
    8020659e:	0001e517          	auipc	a0,0x1e
    802065a2:	dfa50513          	addi	a0,a0,-518 # 80224398 <user_test_table+0xf0>
    802065a6:	ffffa097          	auipc	ra,0xffffa
    802065aa:	760080e7          	jalr	1888(ra) # 80200d06 <printf>
}
    802065ae:	0001                	nop
    802065b0:	70a2                	ld	ra,40(sp)
    802065b2:	7402                	ld	s0,32(sp)
    802065b4:	6145                	addi	sp,sp,48
    802065b6:	8082                	ret

00000000802065b8 <test_exception>:
void test_exception(void) {
    802065b8:	711d                	addi	sp,sp,-96
    802065ba:	ec86                	sd	ra,88(sp)
    802065bc:	e8a2                	sd	s0,80(sp)
    802065be:	1080                	addi	s0,sp,96
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    802065c0:	0001e517          	auipc	a0,0x1e
    802065c4:	e1050513          	addi	a0,a0,-496 # 802243d0 <user_test_table+0x128>
    802065c8:	ffffa097          	auipc	ra,0xffffa
    802065cc:	73e080e7          	jalr	1854(ra) # 80200d06 <printf>
    printf("1. 测试非法指令异常...\n");
    802065d0:	0001e517          	auipc	a0,0x1e
    802065d4:	e3050513          	addi	a0,a0,-464 # 80224400 <user_test_table+0x158>
    802065d8:	ffffa097          	auipc	ra,0xffffa
    802065dc:	72e080e7          	jalr	1838(ra) # 80200d06 <printf>
    802065e0:	ffffffff          	.word	0xffffffff
    printf("✓ 识别到指令异常并尝试忽略\n\n");
    802065e4:	0001e517          	auipc	a0,0x1e
    802065e8:	e3c50513          	addi	a0,a0,-452 # 80224420 <user_test_table+0x178>
    802065ec:	ffffa097          	auipc	ra,0xffffa
    802065f0:	71a080e7          	jalr	1818(ra) # 80200d06 <printf>
    printf("2. 测试存储页故障异常...\n");
    802065f4:	0001e517          	auipc	a0,0x1e
    802065f8:	e5c50513          	addi	a0,a0,-420 # 80224450 <user_test_table+0x1a8>
    802065fc:	ffffa097          	auipc	ra,0xffffa
    80206600:	70a080e7          	jalr	1802(ra) # 80200d06 <printf>
    volatile uint64 *invalid_ptr = 0;
    80206604:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80206608:	47a5                	li	a5,9
    8020660a:	07f2                	slli	a5,a5,0x1c
    8020660c:	fef43023          	sd	a5,-32(s0)
    80206610:	a835                	j	8020664c <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    80206612:	fe043503          	ld	a0,-32(s0)
    80206616:	ffffd097          	auipc	ra,0xffffd
    8020661a:	a3a080e7          	jalr	-1478(ra) # 80203050 <check_is_mapped>
    8020661e:	87aa                	mv	a5,a0
    80206620:	e385                	bnez	a5,80206640 <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    80206622:	fe043783          	ld	a5,-32(s0)
    80206626:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    8020662a:	fe043583          	ld	a1,-32(s0)
    8020662e:	0001e517          	auipc	a0,0x1e
    80206632:	e4a50513          	addi	a0,a0,-438 # 80224478 <user_test_table+0x1d0>
    80206636:	ffffa097          	auipc	ra,0xffffa
    8020663a:	6d0080e7          	jalr	1744(ra) # 80200d06 <printf>
            break;
    8020663e:	a829                	j	80206658 <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80206640:	fe043703          	ld	a4,-32(s0)
    80206644:	6785                	lui	a5,0x1
    80206646:	97ba                	add	a5,a5,a4
    80206648:	fef43023          	sd	a5,-32(s0)
    8020664c:	fe043703          	ld	a4,-32(s0)
    80206650:	47cd                	li	a5,19
    80206652:	07ee                	slli	a5,a5,0x1b
    80206654:	faf76fe3          	bltu	a4,a5,80206612 <test_exception+0x5a>
    if (invalid_ptr != 0) {
    80206658:	fe843783          	ld	a5,-24(s0)
    8020665c:	cb95                	beqz	a5,80206690 <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    8020665e:	fe843783          	ld	a5,-24(s0)
    80206662:	85be                	mv	a1,a5
    80206664:	0001e517          	auipc	a0,0x1e
    80206668:	e3450513          	addi	a0,a0,-460 # 80224498 <user_test_table+0x1f0>
    8020666c:	ffffa097          	auipc	ra,0xffffa
    80206670:	69a080e7          	jalr	1690(ra) # 80200d06 <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    80206674:	fe843783          	ld	a5,-24(s0)
    80206678:	02a00713          	li	a4,42
    8020667c:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    8020667e:	0001e517          	auipc	a0,0x1e
    80206682:	e4a50513          	addi	a0,a0,-438 # 802244c8 <user_test_table+0x220>
    80206686:	ffffa097          	auipc	ra,0xffffa
    8020668a:	680080e7          	jalr	1664(ra) # 80200d06 <printf>
    8020668e:	a809                	j	802066a0 <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80206690:	0001e517          	auipc	a0,0x1e
    80206694:	e6050513          	addi	a0,a0,-416 # 802244f0 <user_test_table+0x248>
    80206698:	ffffa097          	auipc	ra,0xffffa
    8020669c:	66e080e7          	jalr	1646(ra) # 80200d06 <printf>
    printf("3. 测试加载页故障异常...\n");
    802066a0:	0001e517          	auipc	a0,0x1e
    802066a4:	e8850513          	addi	a0,a0,-376 # 80224528 <user_test_table+0x280>
    802066a8:	ffffa097          	auipc	ra,0xffffa
    802066ac:	65e080e7          	jalr	1630(ra) # 80200d06 <printf>
    invalid_ptr = 0;
    802066b0:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802066b4:	4795                	li	a5,5
    802066b6:	07f6                	slli	a5,a5,0x1d
    802066b8:	fcf43c23          	sd	a5,-40(s0)
    802066bc:	a835                	j	802066f8 <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    802066be:	fd843503          	ld	a0,-40(s0)
    802066c2:	ffffd097          	auipc	ra,0xffffd
    802066c6:	98e080e7          	jalr	-1650(ra) # 80203050 <check_is_mapped>
    802066ca:	87aa                	mv	a5,a0
    802066cc:	e385                	bnez	a5,802066ec <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    802066ce:	fd843783          	ld	a5,-40(s0)
    802066d2:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    802066d6:	fd843583          	ld	a1,-40(s0)
    802066da:	0001e517          	auipc	a0,0x1e
    802066de:	d9e50513          	addi	a0,a0,-610 # 80224478 <user_test_table+0x1d0>
    802066e2:	ffffa097          	auipc	ra,0xffffa
    802066e6:	624080e7          	jalr	1572(ra) # 80200d06 <printf>
            break;
    802066ea:	a829                	j	80206704 <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802066ec:	fd843703          	ld	a4,-40(s0)
    802066f0:	6785                	lui	a5,0x1
    802066f2:	97ba                	add	a5,a5,a4
    802066f4:	fcf43c23          	sd	a5,-40(s0)
    802066f8:	fd843703          	ld	a4,-40(s0)
    802066fc:	47d5                	li	a5,21
    802066fe:	07ee                	slli	a5,a5,0x1b
    80206700:	faf76fe3          	bltu	a4,a5,802066be <test_exception+0x106>
    if (invalid_ptr != 0) {
    80206704:	fe843783          	ld	a5,-24(s0)
    80206708:	c7a9                	beqz	a5,80206752 <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    8020670a:	fe843783          	ld	a5,-24(s0)
    8020670e:	85be                	mv	a1,a5
    80206710:	0001e517          	auipc	a0,0x1e
    80206714:	e4050513          	addi	a0,a0,-448 # 80224550 <user_test_table+0x2a8>
    80206718:	ffffa097          	auipc	ra,0xffffa
    8020671c:	5ee080e7          	jalr	1518(ra) # 80200d06 <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    80206720:	fe843783          	ld	a5,-24(s0)
    80206724:	639c                	ld	a5,0(a5)
    80206726:	faf43023          	sd	a5,-96(s0)
        printf("读取的值: %lu\n", value);  // 除非故障被处理
    8020672a:	fa043783          	ld	a5,-96(s0)
    8020672e:	85be                	mv	a1,a5
    80206730:	0001e517          	auipc	a0,0x1e
    80206734:	e5050513          	addi	a0,a0,-432 # 80224580 <user_test_table+0x2d8>
    80206738:	ffffa097          	auipc	ra,0xffffa
    8020673c:	5ce080e7          	jalr	1486(ra) # 80200d06 <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    80206740:	0001e517          	auipc	a0,0x1e
    80206744:	e5850513          	addi	a0,a0,-424 # 80224598 <user_test_table+0x2f0>
    80206748:	ffffa097          	auipc	ra,0xffffa
    8020674c:	5be080e7          	jalr	1470(ra) # 80200d06 <printf>
    80206750:	a809                	j	80206762 <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80206752:	0001e517          	auipc	a0,0x1e
    80206756:	d9e50513          	addi	a0,a0,-610 # 802244f0 <user_test_table+0x248>
    8020675a:	ffffa097          	auipc	ra,0xffffa
    8020675e:	5ac080e7          	jalr	1452(ra) # 80200d06 <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    80206762:	0001e517          	auipc	a0,0x1e
    80206766:	e5e50513          	addi	a0,a0,-418 # 802245c0 <user_test_table+0x318>
    8020676a:	ffffa097          	auipc	ra,0xffffa
    8020676e:	59c080e7          	jalr	1436(ra) # 80200d06 <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    80206772:	ffffd097          	auipc	ra,0xffffd
    80206776:	b26080e7          	jalr	-1242(ra) # 80203298 <alloc_page>
    8020677a:	87aa                	mv	a5,a0
    8020677c:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    80206780:	fd043783          	ld	a5,-48(s0)
    80206784:	c3a1                	beqz	a5,802067c4 <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    80206786:	fd043783          	ld	a5,-48(s0)
    8020678a:	0785                	addi	a5,a5,1 # 1001 <_entry-0x801fefff>
    8020678c:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80206790:	fc843583          	ld	a1,-56(s0)
    80206794:	0001e517          	auipc	a0,0x1e
    80206798:	e5c50513          	addi	a0,a0,-420 # 802245f0 <user_test_table+0x348>
    8020679c:	ffffa097          	auipc	ra,0xffffa
    802067a0:	56a080e7          	jalr	1386(ra) # 80200d06 <printf>
        asm volatile (
    802067a4:	deadc7b7          	lui	a5,0xdeadc
    802067a8:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8b47ff>
    802067ac:	fc843703          	ld	a4,-56(s0)
    802067b0:	e31c                	sd	a5,0(a4)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    802067b2:	0001e517          	auipc	a0,0x1e
    802067b6:	e5e50513          	addi	a0,a0,-418 # 80224610 <user_test_table+0x368>
    802067ba:	ffffa097          	auipc	ra,0xffffa
    802067be:	54c080e7          	jalr	1356(ra) # 80200d06 <printf>
    802067c2:	a809                	j	802067d4 <test_exception+0x21c>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    802067c4:	0001e517          	auipc	a0,0x1e
    802067c8:	e7c50513          	addi	a0,a0,-388 # 80224640 <user_test_table+0x398>
    802067cc:	ffffa097          	auipc	ra,0xffffa
    802067d0:	53a080e7          	jalr	1338(ra) # 80200d06 <printf>
    printf("5. 测试加载地址未对齐异常...\n");
    802067d4:	0001e517          	auipc	a0,0x1e
    802067d8:	eac50513          	addi	a0,a0,-340 # 80224680 <user_test_table+0x3d8>
    802067dc:	ffffa097          	auipc	ra,0xffffa
    802067e0:	52a080e7          	jalr	1322(ra) # 80200d06 <printf>
    if (aligned_addr != 0) {
    802067e4:	fd043783          	ld	a5,-48(s0)
    802067e8:	cbb1                	beqz	a5,8020683c <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    802067ea:	fd043783          	ld	a5,-48(s0)
    802067ee:	0785                	addi	a5,a5,1
    802067f0:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    802067f4:	fc043583          	ld	a1,-64(s0)
    802067f8:	0001e517          	auipc	a0,0x1e
    802067fc:	df850513          	addi	a0,a0,-520 # 802245f0 <user_test_table+0x348>
    80206800:	ffffa097          	auipc	ra,0xffffa
    80206804:	506080e7          	jalr	1286(ra) # 80200d06 <printf>
        uint64 value = 0;
    80206808:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    8020680c:	fc043783          	ld	a5,-64(s0)
    80206810:	639c                	ld	a5,0(a5)
    80206812:	faf43c23          	sd	a5,-72(s0)
        printf("读取的值: 0x%lx\n", value);
    80206816:	fb843583          	ld	a1,-72(s0)
    8020681a:	0001e517          	auipc	a0,0x1e
    8020681e:	e9650513          	addi	a0,a0,-362 # 802246b0 <user_test_table+0x408>
    80206822:	ffffa097          	auipc	ra,0xffffa
    80206826:	4e4080e7          	jalr	1252(ra) # 80200d06 <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    8020682a:	0001e517          	auipc	a0,0x1e
    8020682e:	e9e50513          	addi	a0,a0,-354 # 802246c8 <user_test_table+0x420>
    80206832:	ffffa097          	auipc	ra,0xffffa
    80206836:	4d4080e7          	jalr	1236(ra) # 80200d06 <printf>
    8020683a:	a809                	j	8020684c <test_exception+0x294>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    8020683c:	0001e517          	auipc	a0,0x1e
    80206840:	e0450513          	addi	a0,a0,-508 # 80224640 <user_test_table+0x398>
    80206844:	ffffa097          	auipc	ra,0xffffa
    80206848:	4c2080e7          	jalr	1218(ra) # 80200d06 <printf>
	printf("6. 测试断点异常...\n");
    8020684c:	0001e517          	auipc	a0,0x1e
    80206850:	eac50513          	addi	a0,a0,-340 # 802246f8 <user_test_table+0x450>
    80206854:	ffffa097          	auipc	ra,0xffffa
    80206858:	4b2080e7          	jalr	1202(ra) # 80200d06 <printf>
	asm volatile (
    8020685c:	0001                	nop
    8020685e:	9002                	ebreak
    80206860:	0001                	nop
	printf("✓ 断点异常处理成功\n\n");
    80206862:	0001e517          	auipc	a0,0x1e
    80206866:	eb650513          	addi	a0,a0,-330 # 80224718 <user_test_table+0x470>
    8020686a:	ffffa097          	auipc	ra,0xffffa
    8020686e:	49c080e7          	jalr	1180(ra) # 80200d06 <printf>
    printf("7. 测试环境调用异常...\n");
    80206872:	0001e517          	auipc	a0,0x1e
    80206876:	ec650513          	addi	a0,a0,-314 # 80224738 <user_test_table+0x490>
    8020687a:	ffffa097          	auipc	ra,0xffffa
    8020687e:	48c080e7          	jalr	1164(ra) # 80200d06 <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    80206882:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    80206886:	0001e517          	auipc	a0,0x1e
    8020688a:	ed250513          	addi	a0,a0,-302 # 80224758 <user_test_table+0x4b0>
    8020688e:	ffffa097          	auipc	ra,0xffffa
    80206892:	478080e7          	jalr	1144(ra) # 80200d06 <printf>
    printf("===== 部分异常处理测试完成 =====\n\n");
    80206896:	0001e517          	auipc	a0,0x1e
    8020689a:	eea50513          	addi	a0,a0,-278 # 80224780 <user_test_table+0x4d8>
    8020689e:	ffffa097          	auipc	ra,0xffffa
    802068a2:	468080e7          	jalr	1128(ra) # 80200d06 <printf>
	printf("===== 测试不可恢复的除零异常 ====\n");
    802068a6:	0001e517          	auipc	a0,0x1e
    802068aa:	f0a50513          	addi	a0,a0,-246 # 802247b0 <user_test_table+0x508>
    802068ae:	ffffa097          	auipc	ra,0xffffa
    802068b2:	458080e7          	jalr	1112(ra) # 80200d06 <printf>
	unsigned int a = 1;
    802068b6:	4785                	li	a5,1
    802068b8:	faf42a23          	sw	a5,-76(s0)
	unsigned int b =0;
    802068bc:	fa042823          	sw	zero,-80(s0)
	unsigned int result = a/b;
    802068c0:	fb442783          	lw	a5,-76(s0)
    802068c4:	873e                	mv	a4,a5
    802068c6:	fb042783          	lw	a5,-80(s0)
    802068ca:	02f757bb          	divuw	a5,a4,a5
    802068ce:	faf42623          	sw	a5,-84(s0)
	printf("这行不应该被打印，如果打印了，那么result = %d\n",result);
    802068d2:	fac42783          	lw	a5,-84(s0)
    802068d6:	85be                	mv	a1,a5
    802068d8:	0001e517          	auipc	a0,0x1e
    802068dc:	f0850513          	addi	a0,a0,-248 # 802247e0 <user_test_table+0x538>
    802068e0:	ffffa097          	auipc	ra,0xffffa
    802068e4:	426080e7          	jalr	1062(ra) # 80200d06 <printf>
}
    802068e8:	0001                	nop
    802068ea:	60e6                	ld	ra,88(sp)
    802068ec:	6446                	ld	s0,80(sp)
    802068ee:	6125                	addi	sp,sp,96
    802068f0:	8082                	ret

00000000802068f2 <test_interrupt_overhead>:
void test_interrupt_overhead(void) {
    802068f2:	715d                	addi	sp,sp,-80
    802068f4:	e486                	sd	ra,72(sp)
    802068f6:	e0a2                	sd	s0,64(sp)
    802068f8:	0880                	addi	s0,sp,80
    printf("\n===== 开始中断开销测试 =====\n");
    802068fa:	0001e517          	auipc	a0,0x1e
    802068fe:	f2650513          	addi	a0,a0,-218 # 80224820 <user_test_table+0x578>
    80206902:	ffffa097          	auipc	ra,0xffffa
    80206906:	404080e7          	jalr	1028(ra) # 80200d06 <printf>
    printf("\n----- 测试1: 时钟中断处理时间 -----\n");
    8020690a:	0001e517          	auipc	a0,0x1e
    8020690e:	f3e50513          	addi	a0,a0,-194 # 80224848 <user_test_table+0x5a0>
    80206912:	ffffa097          	auipc	ra,0xffffa
    80206916:	3f4080e7          	jalr	1012(ra) # 80200d06 <printf>
    int count = 0;
    8020691a:	fa042a23          	sw	zero,-76(s0)
    volatile int *test_flag = &count;
    8020691e:	fb440793          	addi	a5,s0,-76
    80206922:	fef43023          	sd	a5,-32(s0)
    start_cycles = get_time();
    80206926:	00000097          	auipc	ra,0x0
    8020692a:	b94080e7          	jalr	-1132(ra) # 802064ba <get_time>
    8020692e:	fca43c23          	sd	a0,-40(s0)
    interrupt_test_flag = test_flag;  // 设置全局标志
    80206932:	00020797          	auipc	a5,0x20
    80206936:	78678793          	addi	a5,a5,1926 # 802270b8 <interrupt_test_flag>
    8020693a:	fe043703          	ld	a4,-32(s0)
    8020693e:	e398                	sd	a4,0(a5)
    while(count < 10) {
    80206940:	a011                	j	80206944 <test_interrupt_overhead+0x52>
        asm volatile("nop");
    80206942:	0001                	nop
    while(count < 10) {
    80206944:	fb442783          	lw	a5,-76(s0)
    80206948:	873e                	mv	a4,a5
    8020694a:	47a5                	li	a5,9
    8020694c:	fee7dbe3          	bge	a5,a4,80206942 <test_interrupt_overhead+0x50>
    end_cycles = get_time();
    80206950:	00000097          	auipc	ra,0x0
    80206954:	b6a080e7          	jalr	-1174(ra) # 802064ba <get_time>
    80206958:	fca43823          	sd	a0,-48(s0)
    interrupt_test_flag = 0;  // 清除标志
    8020695c:	00020797          	auipc	a5,0x20
    80206960:	75c78793          	addi	a5,a5,1884 # 802270b8 <interrupt_test_flag>
    80206964:	0007b023          	sd	zero,0(a5)
    uint64 total_cycles = end_cycles - start_cycles;
    80206968:	fd043703          	ld	a4,-48(s0)
    8020696c:	fd843783          	ld	a5,-40(s0)
    80206970:	40f707b3          	sub	a5,a4,a5
    80206974:	fcf43423          	sd	a5,-56(s0)
    uint64 avg_cycles1 = total_cycles / 10;
    80206978:	fc843703          	ld	a4,-56(s0)
    8020697c:	47a9                	li	a5,10
    8020697e:	02f757b3          	divu	a5,a4,a5
    80206982:	fcf43023          	sd	a5,-64(s0)
    printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    80206986:	fc043583          	ld	a1,-64(s0)
    8020698a:	0001e517          	auipc	a0,0x1e
    8020698e:	eee50513          	addi	a0,a0,-274 # 80224878 <user_test_table+0x5d0>
    80206992:	ffffa097          	auipc	ra,0xffffa
    80206996:	374080e7          	jalr	884(ra) # 80200d06 <printf>
    printf("\n----- 测试2: 上下文切换成本 -----\n");
    8020699a:	0001e517          	auipc	a0,0x1e
    8020699e:	f1650513          	addi	a0,a0,-234 # 802248b0 <user_test_table+0x608>
    802069a2:	ffffa097          	auipc	ra,0xffffa
    802069a6:	364080e7          	jalr	868(ra) # 80200d06 <printf>
    start_cycles = get_time();
    802069aa:	00000097          	auipc	ra,0x0
    802069ae:	b10080e7          	jalr	-1264(ra) # 802064ba <get_time>
    802069b2:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < 1000; i++) {
    802069b6:	fe042623          	sw	zero,-20(s0)
    802069ba:	a801                	j	802069ca <test_interrupt_overhead+0xd8>
    802069bc:	ffffffff          	.word	0xffffffff
    802069c0:	fec42783          	lw	a5,-20(s0)
    802069c4:	2785                	addiw	a5,a5,1
    802069c6:	fef42623          	sw	a5,-20(s0)
    802069ca:	fec42783          	lw	a5,-20(s0)
    802069ce:	0007871b          	sext.w	a4,a5
    802069d2:	3e700793          	li	a5,999
    802069d6:	fee7d3e3          	bge	a5,a4,802069bc <test_interrupt_overhead+0xca>
    end_cycles = get_time();
    802069da:	00000097          	auipc	ra,0x0
    802069de:	ae0080e7          	jalr	-1312(ra) # 802064ba <get_time>
    802069e2:	fca43823          	sd	a0,-48(s0)
    uint64 avg_cycles2 = (end_cycles - start_cycles) / 1000;
    802069e6:	fd043703          	ld	a4,-48(s0)
    802069ea:	fd843783          	ld	a5,-40(s0)
    802069ee:	8f1d                	sub	a4,a4,a5
    802069f0:	3e800793          	li	a5,1000
    802069f4:	02f757b3          	divu	a5,a4,a5
    802069f8:	faf43c23          	sd	a5,-72(s0)
	printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    802069fc:	fc043583          	ld	a1,-64(s0)
    80206a00:	0001e517          	auipc	a0,0x1e
    80206a04:	e7850513          	addi	a0,a0,-392 # 80224878 <user_test_table+0x5d0>
    80206a08:	ffffa097          	auipc	ra,0xffffa
    80206a0c:	2fe080e7          	jalr	766(ra) # 80200d06 <printf>
    printf("平均每次上下文切换耗时: %lu cycles\n", avg_cycles2);
    80206a10:	fb843583          	ld	a1,-72(s0)
    80206a14:	0001e517          	auipc	a0,0x1e
    80206a18:	ecc50513          	addi	a0,a0,-308 # 802248e0 <user_test_table+0x638>
    80206a1c:	ffffa097          	auipc	ra,0xffffa
    80206a20:	2ea080e7          	jalr	746(ra) # 80200d06 <printf>
    printf("\n===== 中断开销测试完成 =====\n");
    80206a24:	0001e517          	auipc	a0,0x1e
    80206a28:	eec50513          	addi	a0,a0,-276 # 80224910 <user_test_table+0x668>
    80206a2c:	ffffa097          	auipc	ra,0xffffa
    80206a30:	2da080e7          	jalr	730(ra) # 80200d06 <printf>
}
    80206a34:	0001                	nop
    80206a36:	60a6                	ld	ra,72(sp)
    80206a38:	6406                	ld	s0,64(sp)
    80206a3a:	6161                	addi	sp,sp,80
    80206a3c:	8082                	ret

0000000080206a3e <simple_task>:
void simple_task(void) {
    80206a3e:	1141                	addi	sp,sp,-16
    80206a40:	e406                	sd	ra,8(sp)
    80206a42:	e022                	sd	s0,0(sp)
    80206a44:	0800                	addi	s0,sp,16
    printf("Simple kernel task running in PID %d\n", myproc()->pid);
    80206a46:	ffffe097          	auipc	ra,0xffffe
    80206a4a:	54a080e7          	jalr	1354(ra) # 80204f90 <myproc>
    80206a4e:	87aa                	mv	a5,a0
    80206a50:	43dc                	lw	a5,4(a5)
    80206a52:	85be                	mv	a1,a5
    80206a54:	0001e517          	auipc	a0,0x1e
    80206a58:	ee450513          	addi	a0,a0,-284 # 80224938 <user_test_table+0x690>
    80206a5c:	ffffa097          	auipc	ra,0xffffa
    80206a60:	2aa080e7          	jalr	682(ra) # 80200d06 <printf>
}
    80206a64:	0001                	nop
    80206a66:	60a2                	ld	ra,8(sp)
    80206a68:	6402                	ld	s0,0(sp)
    80206a6a:	0141                	addi	sp,sp,16
    80206a6c:	8082                	ret

0000000080206a6e <test_process_creation>:
void test_process_creation(void) {
    80206a6e:	7119                	addi	sp,sp,-128
    80206a70:	fc86                	sd	ra,120(sp)
    80206a72:	f8a2                	sd	s0,112(sp)
    80206a74:	0100                	addi	s0,sp,128
    printf("===== 测试开始: 进程创建与管理测试 =====\n");
    80206a76:	0001e517          	auipc	a0,0x1e
    80206a7a:	eea50513          	addi	a0,a0,-278 # 80224960 <user_test_table+0x6b8>
    80206a7e:	ffffa097          	auipc	ra,0xffffa
    80206a82:	288080e7          	jalr	648(ra) # 80200d06 <printf>
    printf("\n----- 第一阶段：测试内核进程创建与管理 -----\n");
    80206a86:	0001e517          	auipc	a0,0x1e
    80206a8a:	f1250513          	addi	a0,a0,-238 # 80224998 <user_test_table+0x6f0>
    80206a8e:	ffffa097          	auipc	ra,0xffffa
    80206a92:	278080e7          	jalr	632(ra) # 80200d06 <printf>
    int pid = create_kernel_proc(simple_task);
    80206a96:	00000517          	auipc	a0,0x0
    80206a9a:	fa850513          	addi	a0,a0,-88 # 80206a3e <simple_task>
    80206a9e:	fffff097          	auipc	ra,0xfffff
    80206aa2:	b32080e7          	jalr	-1230(ra) # 802055d0 <create_kernel_proc>
    80206aa6:	87aa                	mv	a5,a0
    80206aa8:	faf42a23          	sw	a5,-76(s0)
    assert(pid > 0);
    80206aac:	fb442783          	lw	a5,-76(s0)
    80206ab0:	2781                	sext.w	a5,a5
    80206ab2:	00f027b3          	sgtz	a5,a5
    80206ab6:	0ff7f793          	zext.b	a5,a5
    80206aba:	2781                	sext.w	a5,a5
    80206abc:	853e                	mv	a0,a5
    80206abe:	00000097          	auipc	ra,0x0
    80206ac2:	9b0080e7          	jalr	-1616(ra) # 8020646e <assert>
    printf("【测试结果】: 基本内核进程创建成功，PID: %d\n", pid);
    80206ac6:	fb442783          	lw	a5,-76(s0)
    80206aca:	85be                	mv	a1,a5
    80206acc:	0001e517          	auipc	a0,0x1e
    80206ad0:	f0c50513          	addi	a0,a0,-244 # 802249d8 <user_test_table+0x730>
    80206ad4:	ffffa097          	auipc	ra,0xffffa
    80206ad8:	232080e7          	jalr	562(ra) # 80200d06 <printf>
    printf("\n----- 用内核进程填满进程表 -----\n");
    80206adc:	0001e517          	auipc	a0,0x1e
    80206ae0:	f3c50513          	addi	a0,a0,-196 # 80224a18 <user_test_table+0x770>
    80206ae4:	ffffa097          	auipc	ra,0xffffa
    80206ae8:	222080e7          	jalr	546(ra) # 80200d06 <printf>
    int kernel_count = 1; // 已经创建了一个
    80206aec:	4785                	li	a5,1
    80206aee:	fef42623          	sw	a5,-20(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206af2:	4785                	li	a5,1
    80206af4:	fef42423          	sw	a5,-24(s0)
    80206af8:	a881                	j	80206b48 <test_process_creation+0xda>
        int new_pid = create_kernel_proc(simple_task);
    80206afa:	00000517          	auipc	a0,0x0
    80206afe:	f4450513          	addi	a0,a0,-188 # 80206a3e <simple_task>
    80206b02:	fffff097          	auipc	ra,0xfffff
    80206b06:	ace080e7          	jalr	-1330(ra) # 802055d0 <create_kernel_proc>
    80206b0a:	87aa                	mv	a5,a0
    80206b0c:	faf42823          	sw	a5,-80(s0)
        if (new_pid > 0) {
    80206b10:	fb042783          	lw	a5,-80(s0)
    80206b14:	2781                	sext.w	a5,a5
    80206b16:	00f05863          	blez	a5,80206b26 <test_process_creation+0xb8>
            kernel_count++; 
    80206b1a:	fec42783          	lw	a5,-20(s0)
    80206b1e:	2785                	addiw	a5,a5,1
    80206b20:	fef42623          	sw	a5,-20(s0)
    80206b24:	a829                	j	80206b3e <test_process_creation+0xd0>
            warning("process table was full at %d kernel processes\n", kernel_count);
    80206b26:	fec42783          	lw	a5,-20(s0)
    80206b2a:	85be                	mv	a1,a5
    80206b2c:	0001e517          	auipc	a0,0x1e
    80206b30:	f1c50513          	addi	a0,a0,-228 # 80224a48 <user_test_table+0x7a0>
    80206b34:	ffffb097          	auipc	ra,0xffffb
    80206b38:	c52080e7          	jalr	-942(ra) # 80201786 <warning>
            break;
    80206b3c:	a829                	j	80206b56 <test_process_creation+0xe8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206b3e:	fe842783          	lw	a5,-24(s0)
    80206b42:	2785                	addiw	a5,a5,1
    80206b44:	fef42423          	sw	a5,-24(s0)
    80206b48:	fe842783          	lw	a5,-24(s0)
    80206b4c:	0007871b          	sext.w	a4,a5
    80206b50:	47fd                	li	a5,31
    80206b52:	fae7d4e3          	bge	a5,a4,80206afa <test_process_creation+0x8c>
    printf("【测试结果】: 成功创建 %d 个内核进程 (最大限制: %d)\n", kernel_count, PROC);
    80206b56:	fec42783          	lw	a5,-20(s0)
    80206b5a:	02000613          	li	a2,32
    80206b5e:	85be                	mv	a1,a5
    80206b60:	0001e517          	auipc	a0,0x1e
    80206b64:	f1850513          	addi	a0,a0,-232 # 80224a78 <user_test_table+0x7d0>
    80206b68:	ffffa097          	auipc	ra,0xffffa
    80206b6c:	19e080e7          	jalr	414(ra) # 80200d06 <printf>
    print_proc_table();
    80206b70:	fffff097          	auipc	ra,0xfffff
    80206b74:	46a080e7          	jalr	1130(ra) # 80205fda <print_proc_table>
    printf("\n----- 等待并清理所有内核进程 -----\n");
    80206b78:	0001e517          	auipc	a0,0x1e
    80206b7c:	f4850513          	addi	a0,a0,-184 # 80224ac0 <user_test_table+0x818>
    80206b80:	ffffa097          	auipc	ra,0xffffa
    80206b84:	186080e7          	jalr	390(ra) # 80200d06 <printf>
    int kernel_success_count = 0;
    80206b88:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < kernel_count; i++) {
    80206b8c:	fe042023          	sw	zero,-32(s0)
    80206b90:	a0a5                	j	80206bf8 <test_process_creation+0x18a>
        int waited_pid = wait_proc(NULL);
    80206b92:	4501                	li	a0,0
    80206b94:	fffff097          	auipc	ra,0xfffff
    80206b98:	2b8080e7          	jalr	696(ra) # 80205e4c <wait_proc>
    80206b9c:	87aa                	mv	a5,a0
    80206b9e:	f8f42623          	sw	a5,-116(s0)
        if (waited_pid > 0) {
    80206ba2:	f8c42783          	lw	a5,-116(s0)
    80206ba6:	2781                	sext.w	a5,a5
    80206ba8:	02f05863          	blez	a5,80206bd8 <test_process_creation+0x16a>
            kernel_success_count++;
    80206bac:	fe442783          	lw	a5,-28(s0)
    80206bb0:	2785                	addiw	a5,a5,1
    80206bb2:	fef42223          	sw	a5,-28(s0)
            printf("回收内核进程 PID: %d (%d/%d)\n", waited_pid, kernel_success_count, kernel_count);
    80206bb6:	fec42683          	lw	a3,-20(s0)
    80206bba:	fe442703          	lw	a4,-28(s0)
    80206bbe:	f8c42783          	lw	a5,-116(s0)
    80206bc2:	863a                	mv	a2,a4
    80206bc4:	85be                	mv	a1,a5
    80206bc6:	0001e517          	auipc	a0,0x1e
    80206bca:	f2a50513          	addi	a0,a0,-214 # 80224af0 <user_test_table+0x848>
    80206bce:	ffffa097          	auipc	ra,0xffffa
    80206bd2:	138080e7          	jalr	312(ra) # 80200d06 <printf>
    80206bd6:	a821                	j	80206bee <test_process_creation+0x180>
            printf("【错误】: 等待内核进程失败，错误码: %d\n", waited_pid);
    80206bd8:	f8c42783          	lw	a5,-116(s0)
    80206bdc:	85be                	mv	a1,a5
    80206bde:	0001e517          	auipc	a0,0x1e
    80206be2:	f3a50513          	addi	a0,a0,-198 # 80224b18 <user_test_table+0x870>
    80206be6:	ffffa097          	auipc	ra,0xffffa
    80206bea:	120080e7          	jalr	288(ra) # 80200d06 <printf>
    for (int i = 0; i < kernel_count; i++) {
    80206bee:	fe042783          	lw	a5,-32(s0)
    80206bf2:	2785                	addiw	a5,a5,1
    80206bf4:	fef42023          	sw	a5,-32(s0)
    80206bf8:	fe042783          	lw	a5,-32(s0)
    80206bfc:	873e                	mv	a4,a5
    80206bfe:	fec42783          	lw	a5,-20(s0)
    80206c02:	2701                	sext.w	a4,a4
    80206c04:	2781                	sext.w	a5,a5
    80206c06:	f8f746e3          	blt	a4,a5,80206b92 <test_process_creation+0x124>
    printf("【测试结果】: 回收 %d/%d 个内核进程\n", kernel_success_count, kernel_count);
    80206c0a:	fec42703          	lw	a4,-20(s0)
    80206c0e:	fe442783          	lw	a5,-28(s0)
    80206c12:	863a                	mv	a2,a4
    80206c14:	85be                	mv	a1,a5
    80206c16:	0001e517          	auipc	a0,0x1e
    80206c1a:	f3a50513          	addi	a0,a0,-198 # 80224b50 <user_test_table+0x8a8>
    80206c1e:	ffffa097          	auipc	ra,0xffffa
    80206c22:	0e8080e7          	jalr	232(ra) # 80200d06 <printf>
    print_proc_table();
    80206c26:	fffff097          	auipc	ra,0xfffff
    80206c2a:	3b4080e7          	jalr	948(ra) # 80205fda <print_proc_table>
    printf("\n----- 第二阶段：测试用户进程创建与管理 -----\n");
    80206c2e:	0001e517          	auipc	a0,0x1e
    80206c32:	f5a50513          	addi	a0,a0,-166 # 80224b88 <user_test_table+0x8e0>
    80206c36:	ffffa097          	auipc	ra,0xffffa
    80206c3a:	0d0080e7          	jalr	208(ra) # 80200d06 <printf>
    int user_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206c3e:	06c00793          	li	a5,108
    80206c42:	2781                	sext.w	a5,a5
    80206c44:	85be                	mv	a1,a5
    80206c46:	0001d517          	auipc	a0,0x1d
    80206c4a:	f2250513          	addi	a0,a0,-222 # 80223b68 <simple_user_task_bin>
    80206c4e:	fffff097          	auipc	ra,0xfffff
    80206c52:	a6e080e7          	jalr	-1426(ra) # 802056bc <create_user_proc>
    80206c56:	87aa                	mv	a5,a0
    80206c58:	faf42623          	sw	a5,-84(s0)
    if (user_pid > 0) {
    80206c5c:	fac42783          	lw	a5,-84(s0)
    80206c60:	2781                	sext.w	a5,a5
    80206c62:	02f05c63          	blez	a5,80206c9a <test_process_creation+0x22c>
        printf("【测试结果】: 基本用户进程创建成功，PID: %d\n", user_pid);
    80206c66:	fac42783          	lw	a5,-84(s0)
    80206c6a:	85be                	mv	a1,a5
    80206c6c:	0001e517          	auipc	a0,0x1e
    80206c70:	f5c50513          	addi	a0,a0,-164 # 80224bc8 <user_test_table+0x920>
    80206c74:	ffffa097          	auipc	ra,0xffffa
    80206c78:	092080e7          	jalr	146(ra) # 80200d06 <printf>
    printf("\n----- 用用户进程填满进程表 -----\n");
    80206c7c:	0001e517          	auipc	a0,0x1e
    80206c80:	fbc50513          	addi	a0,a0,-68 # 80224c38 <user_test_table+0x990>
    80206c84:	ffffa097          	auipc	ra,0xffffa
    80206c88:	082080e7          	jalr	130(ra) # 80200d06 <printf>
    int user_count = 1; // 已经创建了一个
    80206c8c:	4785                	li	a5,1
    80206c8e:	fcf42e23          	sw	a5,-36(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206c92:	4785                	li	a5,1
    80206c94:	fcf42c23          	sw	a5,-40(s0)
    80206c98:	a841                	j	80206d28 <test_process_creation+0x2ba>
        printf("【错误】: 基本用户进程创建失败\n");
    80206c9a:	0001e517          	auipc	a0,0x1e
    80206c9e:	f6e50513          	addi	a0,a0,-146 # 80224c08 <user_test_table+0x960>
    80206ca2:	ffffa097          	auipc	ra,0xffffa
    80206ca6:	064080e7          	jalr	100(ra) # 80200d06 <printf>
        return;
    80206caa:	a615                	j	80206fce <test_process_creation+0x560>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206cac:	06c00793          	li	a5,108
    80206cb0:	2781                	sext.w	a5,a5
    80206cb2:	85be                	mv	a1,a5
    80206cb4:	0001d517          	auipc	a0,0x1d
    80206cb8:	eb450513          	addi	a0,a0,-332 # 80223b68 <simple_user_task_bin>
    80206cbc:	fffff097          	auipc	ra,0xfffff
    80206cc0:	a00080e7          	jalr	-1536(ra) # 802056bc <create_user_proc>
    80206cc4:	87aa                	mv	a5,a0
    80206cc6:	faf42423          	sw	a5,-88(s0)
        if (new_pid > 0) {
    80206cca:	fa842783          	lw	a5,-88(s0)
    80206cce:	2781                	sext.w	a5,a5
    80206cd0:	02f05b63          	blez	a5,80206d06 <test_process_creation+0x298>
            user_count++;
    80206cd4:	fdc42783          	lw	a5,-36(s0)
    80206cd8:	2785                	addiw	a5,a5,1
    80206cda:	fcf42e23          	sw	a5,-36(s0)
            if (user_count % 5 == 0) { // 每5个进程打印一次进度
    80206cde:	fdc42783          	lw	a5,-36(s0)
    80206ce2:	873e                	mv	a4,a5
    80206ce4:	4795                	li	a5,5
    80206ce6:	02f767bb          	remw	a5,a4,a5
    80206cea:	2781                	sext.w	a5,a5
    80206cec:	eb8d                	bnez	a5,80206d1e <test_process_creation+0x2b0>
                printf("已创建 %d 个用户进程...\n", user_count);
    80206cee:	fdc42783          	lw	a5,-36(s0)
    80206cf2:	85be                	mv	a1,a5
    80206cf4:	0001e517          	auipc	a0,0x1e
    80206cf8:	f7450513          	addi	a0,a0,-140 # 80224c68 <user_test_table+0x9c0>
    80206cfc:	ffffa097          	auipc	ra,0xffffa
    80206d00:	00a080e7          	jalr	10(ra) # 80200d06 <printf>
    80206d04:	a829                	j	80206d1e <test_process_creation+0x2b0>
            warning("process table was full at %d user processes\n", user_count);
    80206d06:	fdc42783          	lw	a5,-36(s0)
    80206d0a:	85be                	mv	a1,a5
    80206d0c:	0001e517          	auipc	a0,0x1e
    80206d10:	f8450513          	addi	a0,a0,-124 # 80224c90 <user_test_table+0x9e8>
    80206d14:	ffffb097          	auipc	ra,0xffffb
    80206d18:	a72080e7          	jalr	-1422(ra) # 80201786 <warning>
            break;
    80206d1c:	a829                	j	80206d36 <test_process_creation+0x2c8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206d1e:	fd842783          	lw	a5,-40(s0)
    80206d22:	2785                	addiw	a5,a5,1
    80206d24:	fcf42c23          	sw	a5,-40(s0)
    80206d28:	fd842783          	lw	a5,-40(s0)
    80206d2c:	0007871b          	sext.w	a4,a5
    80206d30:	47fd                	li	a5,31
    80206d32:	f6e7dde3          	bge	a5,a4,80206cac <test_process_creation+0x23e>
    printf("【测试结果】: 成功创建 %d 个用户进程 (最大限制: %d)\n", user_count, PROC);
    80206d36:	fdc42783          	lw	a5,-36(s0)
    80206d3a:	02000613          	li	a2,32
    80206d3e:	85be                	mv	a1,a5
    80206d40:	0001e517          	auipc	a0,0x1e
    80206d44:	f8050513          	addi	a0,a0,-128 # 80224cc0 <user_test_table+0xa18>
    80206d48:	ffffa097          	auipc	ra,0xffffa
    80206d4c:	fbe080e7          	jalr	-66(ra) # 80200d06 <printf>
    print_proc_table();
    80206d50:	fffff097          	auipc	ra,0xfffff
    80206d54:	28a080e7          	jalr	650(ra) # 80205fda <print_proc_table>
    printf("\n----- 等待并清理所有用户进程 -----\n");
    80206d58:	0001e517          	auipc	a0,0x1e
    80206d5c:	fb050513          	addi	a0,a0,-80 # 80224d08 <user_test_table+0xa60>
    80206d60:	ffffa097          	auipc	ra,0xffffa
    80206d64:	fa6080e7          	jalr	-90(ra) # 80200d06 <printf>
    int user_success_count = 0;
    80206d68:	fc042a23          	sw	zero,-44(s0)
    for (int i = 0; i < user_count; i++) {
    80206d6c:	fc042823          	sw	zero,-48(s0)
    80206d70:	a895                	j	80206de4 <test_process_creation+0x376>
        int waited_pid = wait_proc(NULL);
    80206d72:	4501                	li	a0,0
    80206d74:	fffff097          	auipc	ra,0xfffff
    80206d78:	0d8080e7          	jalr	216(ra) # 80205e4c <wait_proc>
    80206d7c:	87aa                	mv	a5,a0
    80206d7e:	f8f42823          	sw	a5,-112(s0)
        if (waited_pid > 0) {
    80206d82:	f9042783          	lw	a5,-112(s0)
    80206d86:	2781                	sext.w	a5,a5
    80206d88:	02f05e63          	blez	a5,80206dc4 <test_process_creation+0x356>
            user_success_count++;
    80206d8c:	fd442783          	lw	a5,-44(s0)
    80206d90:	2785                	addiw	a5,a5,1
    80206d92:	fcf42a23          	sw	a5,-44(s0)
            if (user_success_count % 5 == 0) { // 每5个进程打印一次进度
    80206d96:	fd442783          	lw	a5,-44(s0)
    80206d9a:	873e                	mv	a4,a5
    80206d9c:	4795                	li	a5,5
    80206d9e:	02f767bb          	remw	a5,a4,a5
    80206da2:	2781                	sext.w	a5,a5
    80206da4:	eb9d                	bnez	a5,80206dda <test_process_creation+0x36c>
                printf("已回收 %d/%d 个用户进程...\n", user_success_count, user_count);
    80206da6:	fdc42703          	lw	a4,-36(s0)
    80206daa:	fd442783          	lw	a5,-44(s0)
    80206dae:	863a                	mv	a2,a4
    80206db0:	85be                	mv	a1,a5
    80206db2:	0001e517          	auipc	a0,0x1e
    80206db6:	f8650513          	addi	a0,a0,-122 # 80224d38 <user_test_table+0xa90>
    80206dba:	ffffa097          	auipc	ra,0xffffa
    80206dbe:	f4c080e7          	jalr	-180(ra) # 80200d06 <printf>
    80206dc2:	a821                	j	80206dda <test_process_creation+0x36c>
            printf("【错误】: 等待用户进程失败，错误码: %d\n", waited_pid);
    80206dc4:	f9042783          	lw	a5,-112(s0)
    80206dc8:	85be                	mv	a1,a5
    80206dca:	0001e517          	auipc	a0,0x1e
    80206dce:	f9650513          	addi	a0,a0,-106 # 80224d60 <user_test_table+0xab8>
    80206dd2:	ffffa097          	auipc	ra,0xffffa
    80206dd6:	f34080e7          	jalr	-204(ra) # 80200d06 <printf>
    for (int i = 0; i < user_count; i++) {
    80206dda:	fd042783          	lw	a5,-48(s0)
    80206dde:	2785                	addiw	a5,a5,1
    80206de0:	fcf42823          	sw	a5,-48(s0)
    80206de4:	fd042783          	lw	a5,-48(s0)
    80206de8:	873e                	mv	a4,a5
    80206dea:	fdc42783          	lw	a5,-36(s0)
    80206dee:	2701                	sext.w	a4,a4
    80206df0:	2781                	sext.w	a5,a5
    80206df2:	f8f740e3          	blt	a4,a5,80206d72 <test_process_creation+0x304>
    printf("【测试结果】: 回收 %d/%d 个用户进程\n", user_success_count, user_count);
    80206df6:	fdc42703          	lw	a4,-36(s0)
    80206dfa:	fd442783          	lw	a5,-44(s0)
    80206dfe:	863a                	mv	a2,a4
    80206e00:	85be                	mv	a1,a5
    80206e02:	0001e517          	auipc	a0,0x1e
    80206e06:	f9650513          	addi	a0,a0,-106 # 80224d98 <user_test_table+0xaf0>
    80206e0a:	ffffa097          	auipc	ra,0xffffa
    80206e0e:	efc080e7          	jalr	-260(ra) # 80200d06 <printf>
    print_proc_table();
    80206e12:	fffff097          	auipc	ra,0xfffff
    80206e16:	1c8080e7          	jalr	456(ra) # 80205fda <print_proc_table>
    printf("\n----- 第三阶段：混合进程测试 -----\n");
    80206e1a:	0001e517          	auipc	a0,0x1e
    80206e1e:	fb650513          	addi	a0,a0,-74 # 80224dd0 <user_test_table+0xb28>
    80206e22:	ffffa097          	auipc	ra,0xffffa
    80206e26:	ee4080e7          	jalr	-284(ra) # 80200d06 <printf>
    int mixed_kernel_count = 0;
    80206e2a:	fc042623          	sw	zero,-52(s0)
    int mixed_user_count = 0;
    80206e2e:	fc042423          	sw	zero,-56(s0)
    int target_count = PROC / 2;
    80206e32:	47c1                	li	a5,16
    80206e34:	faf42223          	sw	a5,-92(s0)
    printf("创建 %d 个内核进程和 %d 个用户进程...\n", target_count, target_count);
    80206e38:	fa442703          	lw	a4,-92(s0)
    80206e3c:	fa442783          	lw	a5,-92(s0)
    80206e40:	863a                	mv	a2,a4
    80206e42:	85be                	mv	a1,a5
    80206e44:	0001e517          	auipc	a0,0x1e
    80206e48:	fbc50513          	addi	a0,a0,-68 # 80224e00 <user_test_table+0xb58>
    80206e4c:	ffffa097          	auipc	ra,0xffffa
    80206e50:	eba080e7          	jalr	-326(ra) # 80200d06 <printf>
    for (int i = 0; i < target_count; i++) {
    80206e54:	fc042223          	sw	zero,-60(s0)
    80206e58:	a81d                	j	80206e8e <test_process_creation+0x420>
        int new_pid = create_kernel_proc(simple_task);
    80206e5a:	00000517          	auipc	a0,0x0
    80206e5e:	be450513          	addi	a0,a0,-1052 # 80206a3e <simple_task>
    80206e62:	ffffe097          	auipc	ra,0xffffe
    80206e66:	76e080e7          	jalr	1902(ra) # 802055d0 <create_kernel_proc>
    80206e6a:	87aa                	mv	a5,a0
    80206e6c:	faf42023          	sw	a5,-96(s0)
        if (new_pid > 0) {
    80206e70:	fa042783          	lw	a5,-96(s0)
    80206e74:	2781                	sext.w	a5,a5
    80206e76:	02f05663          	blez	a5,80206ea2 <test_process_creation+0x434>
            mixed_kernel_count++;
    80206e7a:	fcc42783          	lw	a5,-52(s0)
    80206e7e:	2785                	addiw	a5,a5,1
    80206e80:	fcf42623          	sw	a5,-52(s0)
    for (int i = 0; i < target_count; i++) {
    80206e84:	fc442783          	lw	a5,-60(s0)
    80206e88:	2785                	addiw	a5,a5,1
    80206e8a:	fcf42223          	sw	a5,-60(s0)
    80206e8e:	fc442783          	lw	a5,-60(s0)
    80206e92:	873e                	mv	a4,a5
    80206e94:	fa442783          	lw	a5,-92(s0)
    80206e98:	2701                	sext.w	a4,a4
    80206e9a:	2781                	sext.w	a5,a5
    80206e9c:	faf74fe3          	blt	a4,a5,80206e5a <test_process_creation+0x3ec>
    80206ea0:	a011                	j	80206ea4 <test_process_creation+0x436>
            break;
    80206ea2:	0001                	nop
    for (int i = 0; i < target_count; i++) {
    80206ea4:	fc042023          	sw	zero,-64(s0)
    80206ea8:	a83d                	j	80206ee6 <test_process_creation+0x478>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206eaa:	06c00793          	li	a5,108
    80206eae:	2781                	sext.w	a5,a5
    80206eb0:	85be                	mv	a1,a5
    80206eb2:	0001d517          	auipc	a0,0x1d
    80206eb6:	cb650513          	addi	a0,a0,-842 # 80223b68 <simple_user_task_bin>
    80206eba:	fffff097          	auipc	ra,0xfffff
    80206ebe:	802080e7          	jalr	-2046(ra) # 802056bc <create_user_proc>
    80206ec2:	87aa                	mv	a5,a0
    80206ec4:	f8f42e23          	sw	a5,-100(s0)
        if (new_pid > 0) {
    80206ec8:	f9c42783          	lw	a5,-100(s0)
    80206ecc:	2781                	sext.w	a5,a5
    80206ece:	02f05663          	blez	a5,80206efa <test_process_creation+0x48c>
            mixed_user_count++;
    80206ed2:	fc842783          	lw	a5,-56(s0)
    80206ed6:	2785                	addiw	a5,a5,1
    80206ed8:	fcf42423          	sw	a5,-56(s0)
    for (int i = 0; i < target_count; i++) {
    80206edc:	fc042783          	lw	a5,-64(s0)
    80206ee0:	2785                	addiw	a5,a5,1
    80206ee2:	fcf42023          	sw	a5,-64(s0)
    80206ee6:	fc042783          	lw	a5,-64(s0)
    80206eea:	873e                	mv	a4,a5
    80206eec:	fa442783          	lw	a5,-92(s0)
    80206ef0:	2701                	sext.w	a4,a4
    80206ef2:	2781                	sext.w	a5,a5
    80206ef4:	faf74be3          	blt	a4,a5,80206eaa <test_process_creation+0x43c>
    80206ef8:	a011                	j	80206efc <test_process_creation+0x48e>
            break;
    80206efa:	0001                	nop
    printf("【混合测试结果】: 创建了 %d 个内核进程 + %d 个用户进程 = %d 个进程\n", 
    80206efc:	fcc42783          	lw	a5,-52(s0)
    80206f00:	873e                	mv	a4,a5
    80206f02:	fc842783          	lw	a5,-56(s0)
    80206f06:	9fb9                	addw	a5,a5,a4
    80206f08:	0007869b          	sext.w	a3,a5
    80206f0c:	fc842703          	lw	a4,-56(s0)
    80206f10:	fcc42783          	lw	a5,-52(s0)
    80206f14:	863a                	mv	a2,a4
    80206f16:	85be                	mv	a1,a5
    80206f18:	0001e517          	auipc	a0,0x1e
    80206f1c:	f2050513          	addi	a0,a0,-224 # 80224e38 <user_test_table+0xb90>
    80206f20:	ffffa097          	auipc	ra,0xffffa
    80206f24:	de6080e7          	jalr	-538(ra) # 80200d06 <printf>
    print_proc_table();
    80206f28:	fffff097          	auipc	ra,0xfffff
    80206f2c:	0b2080e7          	jalr	178(ra) # 80205fda <print_proc_table>
    printf("\n----- 清理混合进程 -----\n");
    80206f30:	0001e517          	auipc	a0,0x1e
    80206f34:	f6850513          	addi	a0,a0,-152 # 80224e98 <user_test_table+0xbf0>
    80206f38:	ffffa097          	auipc	ra,0xffffa
    80206f3c:	dce080e7          	jalr	-562(ra) # 80200d06 <printf>
    int mixed_success_count = 0;
    80206f40:	fa042e23          	sw	zero,-68(s0)
    int total_mixed = mixed_kernel_count + mixed_user_count;
    80206f44:	fcc42783          	lw	a5,-52(s0)
    80206f48:	873e                	mv	a4,a5
    80206f4a:	fc842783          	lw	a5,-56(s0)
    80206f4e:	9fb9                	addw	a5,a5,a4
    80206f50:	f8f42c23          	sw	a5,-104(s0)
    for (int i = 0; i < total_mixed; i++) {
    80206f54:	fa042c23          	sw	zero,-72(s0)
    80206f58:	a805                	j	80206f88 <test_process_creation+0x51a>
        int waited_pid = wait_proc(NULL);
    80206f5a:	4501                	li	a0,0
    80206f5c:	fffff097          	auipc	ra,0xfffff
    80206f60:	ef0080e7          	jalr	-272(ra) # 80205e4c <wait_proc>
    80206f64:	87aa                	mv	a5,a0
    80206f66:	f8f42a23          	sw	a5,-108(s0)
        if (waited_pid > 0) {
    80206f6a:	f9442783          	lw	a5,-108(s0)
    80206f6e:	2781                	sext.w	a5,a5
    80206f70:	00f05763          	blez	a5,80206f7e <test_process_creation+0x510>
            mixed_success_count++;
    80206f74:	fbc42783          	lw	a5,-68(s0)
    80206f78:	2785                	addiw	a5,a5,1
    80206f7a:	faf42e23          	sw	a5,-68(s0)
    for (int i = 0; i < total_mixed; i++) {
    80206f7e:	fb842783          	lw	a5,-72(s0)
    80206f82:	2785                	addiw	a5,a5,1
    80206f84:	faf42c23          	sw	a5,-72(s0)
    80206f88:	fb842783          	lw	a5,-72(s0)
    80206f8c:	873e                	mv	a4,a5
    80206f8e:	f9842783          	lw	a5,-104(s0)
    80206f92:	2701                	sext.w	a4,a4
    80206f94:	2781                	sext.w	a5,a5
    80206f96:	fcf742e3          	blt	a4,a5,80206f5a <test_process_creation+0x4ec>
    printf("【混合测试结果】: 回收 %d/%d 个混合进程\n", mixed_success_count, total_mixed);
    80206f9a:	f9842703          	lw	a4,-104(s0)
    80206f9e:	fbc42783          	lw	a5,-68(s0)
    80206fa2:	863a                	mv	a2,a4
    80206fa4:	85be                	mv	a1,a5
    80206fa6:	0001e517          	auipc	a0,0x1e
    80206faa:	f1a50513          	addi	a0,a0,-230 # 80224ec0 <user_test_table+0xc18>
    80206fae:	ffffa097          	auipc	ra,0xffffa
    80206fb2:	d58080e7          	jalr	-680(ra) # 80200d06 <printf>
    print_proc_table();
    80206fb6:	fffff097          	auipc	ra,0xfffff
    80206fba:	024080e7          	jalr	36(ra) # 80205fda <print_proc_table>
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    80206fbe:	0001e517          	auipc	a0,0x1e
    80206fc2:	f3a50513          	addi	a0,a0,-198 # 80224ef8 <user_test_table+0xc50>
    80206fc6:	ffffa097          	auipc	ra,0xffffa
    80206fca:	d40080e7          	jalr	-704(ra) # 80200d06 <printf>
}
    80206fce:	70e6                	ld	ra,120(sp)
    80206fd0:	7446                	ld	s0,112(sp)
    80206fd2:	6109                	addi	sp,sp,128
    80206fd4:	8082                	ret

0000000080206fd6 <cpu_intensive_task>:
void cpu_intensive_task(void) {
    80206fd6:	7139                	addi	sp,sp,-64
    80206fd8:	fc06                	sd	ra,56(sp)
    80206fda:	f822                	sd	s0,48(sp)
    80206fdc:	0080                	addi	s0,sp,64
    int pid = myproc()->pid;
    80206fde:	ffffe097          	auipc	ra,0xffffe
    80206fe2:	fb2080e7          	jalr	-78(ra) # 80204f90 <myproc>
    80206fe6:	87aa                	mv	a5,a0
    80206fe8:	43dc                	lw	a5,4(a5)
    80206fea:	fcf42e23          	sw	a5,-36(s0)
    printf("[进程 %d] 开始CPU密集计算\n", pid);
    80206fee:	fdc42783          	lw	a5,-36(s0)
    80206ff2:	85be                	mv	a1,a5
    80206ff4:	0001e517          	auipc	a0,0x1e
    80206ff8:	f3c50513          	addi	a0,a0,-196 # 80224f30 <user_test_table+0xc88>
    80206ffc:	ffffa097          	auipc	ra,0xffffa
    80207000:	d0a080e7          	jalr	-758(ra) # 80200d06 <printf>
    uint64 sum = 0;
    80207004:	fe043423          	sd	zero,-24(s0)
    const uint64 TOTAL_ITERATIONS = 100000000;
    80207008:	05f5e7b7          	lui	a5,0x5f5e
    8020700c:	10078793          	addi	a5,a5,256 # 5f5e100 <_entry-0x7a2a1f00>
    80207010:	fcf43823          	sd	a5,-48(s0)
    const uint64 REPORT_INTERVAL = TOTAL_ITERATIONS / 100;  // 每完成1%报告一次
    80207014:	fd043703          	ld	a4,-48(s0)
    80207018:	06400793          	li	a5,100
    8020701c:	02f757b3          	divu	a5,a4,a5
    80207020:	fcf43423          	sd	a5,-56(s0)
    for (uint64 i = 0; i < TOTAL_ITERATIONS; i++) {
    80207024:	fe043023          	sd	zero,-32(s0)
    80207028:	a8b5                	j	802070a4 <cpu_intensive_task+0xce>
        sum += (i * i) % 1000000007;  // 添加乘法和取模运算
    8020702a:	fe043783          	ld	a5,-32(s0)
    8020702e:	02f78733          	mul	a4,a5,a5
    80207032:	3b9ad7b7          	lui	a5,0x3b9ad
    80207036:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_entry-0x448535f9>
    8020703a:	02f777b3          	remu	a5,a4,a5
    8020703e:	fe843703          	ld	a4,-24(s0)
    80207042:	97ba                	add	a5,a5,a4
    80207044:	fef43423          	sd	a5,-24(s0)
        if (i % REPORT_INTERVAL == 0) {
    80207048:	fe043703          	ld	a4,-32(s0)
    8020704c:	fc843783          	ld	a5,-56(s0)
    80207050:	02f777b3          	remu	a5,a4,a5
    80207054:	e3b9                	bnez	a5,8020709a <cpu_intensive_task+0xc4>
            uint64 percent = (i * 100) / TOTAL_ITERATIONS;
    80207056:	fe043703          	ld	a4,-32(s0)
    8020705a:	06400793          	li	a5,100
    8020705e:	02f70733          	mul	a4,a4,a5
    80207062:	fd043783          	ld	a5,-48(s0)
    80207066:	02f757b3          	divu	a5,a4,a5
    8020706a:	fcf43023          	sd	a5,-64(s0)
            printf("[进程 %d] 完成度: %lu%%，当前sum=%lu\n", 
    8020706e:	fdc42783          	lw	a5,-36(s0)
    80207072:	fe843683          	ld	a3,-24(s0)
    80207076:	fc043603          	ld	a2,-64(s0)
    8020707a:	85be                	mv	a1,a5
    8020707c:	0001e517          	auipc	a0,0x1e
    80207080:	edc50513          	addi	a0,a0,-292 # 80224f58 <user_test_table+0xcb0>
    80207084:	ffffa097          	auipc	ra,0xffffa
    80207088:	c82080e7          	jalr	-894(ra) # 80200d06 <printf>
            if (i > 0) {
    8020708c:	fe043783          	ld	a5,-32(s0)
    80207090:	c789                	beqz	a5,8020709a <cpu_intensive_task+0xc4>
                yield();
    80207092:	fffff097          	auipc	ra,0xfffff
    80207096:	ae2080e7          	jalr	-1310(ra) # 80205b74 <yield>
    for (uint64 i = 0; i < TOTAL_ITERATIONS; i++) {
    8020709a:	fe043783          	ld	a5,-32(s0)
    8020709e:	0785                	addi	a5,a5,1
    802070a0:	fef43023          	sd	a5,-32(s0)
    802070a4:	fe043703          	ld	a4,-32(s0)
    802070a8:	fd043783          	ld	a5,-48(s0)
    802070ac:	f6f76fe3          	bltu	a4,a5,8020702a <cpu_intensive_task+0x54>
    printf("[进程 %d] 计算完成，最终sum=%lu\n", pid, sum);
    802070b0:	fdc42783          	lw	a5,-36(s0)
    802070b4:	fe843603          	ld	a2,-24(s0)
    802070b8:	85be                	mv	a1,a5
    802070ba:	0001e517          	auipc	a0,0x1e
    802070be:	ece50513          	addi	a0,a0,-306 # 80224f88 <user_test_table+0xce0>
    802070c2:	ffffa097          	auipc	ra,0xffffa
    802070c6:	c44080e7          	jalr	-956(ra) # 80200d06 <printf>
    exit_proc(0);
    802070ca:	4501                	li	a0,0
    802070cc:	fffff097          	auipc	ra,0xfffff
    802070d0:	cb6080e7          	jalr	-842(ra) # 80205d82 <exit_proc>
}
    802070d4:	0001                	nop
    802070d6:	70e2                	ld	ra,56(sp)
    802070d8:	7442                	ld	s0,48(sp)
    802070da:	6121                	addi	sp,sp,64
    802070dc:	8082                	ret

00000000802070de <test_scheduler>:
void test_scheduler(void) {
    802070de:	715d                	addi	sp,sp,-80
    802070e0:	e486                	sd	ra,72(sp)
    802070e2:	e0a2                	sd	s0,64(sp)
    802070e4:	0880                	addi	s0,sp,80
    printf("\n===== 测试开始: 调度器公平性测试 =====\n");
    802070e6:	0001e517          	auipc	a0,0x1e
    802070ea:	ed250513          	addi	a0,a0,-302 # 80224fb8 <user_test_table+0xd10>
    802070ee:	ffffa097          	auipc	ra,0xffffa
    802070f2:	c18080e7          	jalr	-1000(ra) # 80200d06 <printf>
    for (int i = 0; i < 3; i++) {
    802070f6:	fe042623          	sw	zero,-20(s0)
    802070fa:	a8a5                	j	80207172 <test_scheduler+0x94>
        pids[i] = create_kernel_proc(cpu_intensive_task);
    802070fc:	00000517          	auipc	a0,0x0
    80207100:	eda50513          	addi	a0,a0,-294 # 80206fd6 <cpu_intensive_task>
    80207104:	ffffe097          	auipc	ra,0xffffe
    80207108:	4cc080e7          	jalr	1228(ra) # 802055d0 <create_kernel_proc>
    8020710c:	87aa                	mv	a5,a0
    8020710e:	873e                	mv	a4,a5
    80207110:	fec42783          	lw	a5,-20(s0)
    80207114:	078a                	slli	a5,a5,0x2
    80207116:	17c1                	addi	a5,a5,-16
    80207118:	97a2                	add	a5,a5,s0
    8020711a:	fce7a823          	sw	a4,-48(a5)
        if (pids[i] < 0) {
    8020711e:	fec42783          	lw	a5,-20(s0)
    80207122:	078a                	slli	a5,a5,0x2
    80207124:	17c1                	addi	a5,a5,-16
    80207126:	97a2                	add	a5,a5,s0
    80207128:	fd07a783          	lw	a5,-48(a5)
    8020712c:	0007de63          	bgez	a5,80207148 <test_scheduler+0x6a>
            printf("【错误】创建进程 %d 失败\n", i);
    80207130:	fec42783          	lw	a5,-20(s0)
    80207134:	85be                	mv	a1,a5
    80207136:	0001e517          	auipc	a0,0x1e
    8020713a:	eba50513          	addi	a0,a0,-326 # 80224ff0 <user_test_table+0xd48>
    8020713e:	ffffa097          	auipc	ra,0xffffa
    80207142:	bc8080e7          	jalr	-1080(ra) # 80200d06 <printf>
    80207146:	a239                	j	80207254 <test_scheduler+0x176>
        printf("创建进程成功，PID: %d\n", pids[i]);
    80207148:	fec42783          	lw	a5,-20(s0)
    8020714c:	078a                	slli	a5,a5,0x2
    8020714e:	17c1                	addi	a5,a5,-16
    80207150:	97a2                	add	a5,a5,s0
    80207152:	fd07a783          	lw	a5,-48(a5)
    80207156:	85be                	mv	a1,a5
    80207158:	0001e517          	auipc	a0,0x1e
    8020715c:	ec050513          	addi	a0,a0,-320 # 80225018 <user_test_table+0xd70>
    80207160:	ffffa097          	auipc	ra,0xffffa
    80207164:	ba6080e7          	jalr	-1114(ra) # 80200d06 <printf>
    for (int i = 0; i < 3; i++) {
    80207168:	fec42783          	lw	a5,-20(s0)
    8020716c:	2785                	addiw	a5,a5,1
    8020716e:	fef42623          	sw	a5,-20(s0)
    80207172:	fec42783          	lw	a5,-20(s0)
    80207176:	0007871b          	sext.w	a4,a5
    8020717a:	4789                	li	a5,2
    8020717c:	f8e7d0e3          	bge	a5,a4,802070fc <test_scheduler+0x1e>
    uint64 start_time = get_time();
    80207180:	fffff097          	auipc	ra,0xfffff
    80207184:	33a080e7          	jalr	826(ra) # 802064ba <get_time>
    80207188:	fea43023          	sd	a0,-32(s0)
    int completed = 0;
    8020718c:	fe042423          	sw	zero,-24(s0)
    while (completed < 3) {
    80207190:	a0a9                	j	802071da <test_scheduler+0xfc>
        int pid = wait_proc(&status);
    80207192:	fbc40793          	addi	a5,s0,-68
    80207196:	853e                	mv	a0,a5
    80207198:	fffff097          	auipc	ra,0xfffff
    8020719c:	cb4080e7          	jalr	-844(ra) # 80205e4c <wait_proc>
    802071a0:	87aa                	mv	a5,a0
    802071a2:	fcf42623          	sw	a5,-52(s0)
        if (pid > 0) {
    802071a6:	fcc42783          	lw	a5,-52(s0)
    802071aa:	2781                	sext.w	a5,a5
    802071ac:	02f05763          	blez	a5,802071da <test_scheduler+0xfc>
            completed++;
    802071b0:	fe842783          	lw	a5,-24(s0)
    802071b4:	2785                	addiw	a5,a5,1
    802071b6:	fef42423          	sw	a5,-24(s0)
            printf("进程 %d 已完成，退出状态: %d (%d/3)\n", 
    802071ba:	fbc42703          	lw	a4,-68(s0)
    802071be:	fe842683          	lw	a3,-24(s0)
    802071c2:	fcc42783          	lw	a5,-52(s0)
    802071c6:	863a                	mv	a2,a4
    802071c8:	85be                	mv	a1,a5
    802071ca:	0001e517          	auipc	a0,0x1e
    802071ce:	e6e50513          	addi	a0,a0,-402 # 80225038 <user_test_table+0xd90>
    802071d2:	ffffa097          	auipc	ra,0xffffa
    802071d6:	b34080e7          	jalr	-1228(ra) # 80200d06 <printf>
    while (completed < 3) {
    802071da:	fe842783          	lw	a5,-24(s0)
    802071de:	0007871b          	sext.w	a4,a5
    802071e2:	4789                	li	a5,2
    802071e4:	fae7d7e3          	bge	a5,a4,80207192 <test_scheduler+0xb4>
    uint64 end_time = get_time();
    802071e8:	fffff097          	auipc	ra,0xfffff
    802071ec:	2d2080e7          	jalr	722(ra) # 802064ba <get_time>
    802071f0:	fca43c23          	sd	a0,-40(s0)
    uint64 total_cycles = end_time - start_time;
    802071f4:	fd843703          	ld	a4,-40(s0)
    802071f8:	fe043783          	ld	a5,-32(s0)
    802071fc:	40f707b3          	sub	a5,a4,a5
    80207200:	fcf43823          	sd	a5,-48(s0)
    printf("\n----- 测试结果 -----\n");
    80207204:	0001e517          	auipc	a0,0x1e
    80207208:	e6450513          	addi	a0,a0,-412 # 80225068 <user_test_table+0xdc0>
    8020720c:	ffffa097          	auipc	ra,0xffffa
    80207210:	afa080e7          	jalr	-1286(ra) # 80200d06 <printf>
    printf("总执行时间: %lu cycles\n", total_cycles);
    80207214:	fd043583          	ld	a1,-48(s0)
    80207218:	0001e517          	auipc	a0,0x1e
    8020721c:	e7050513          	addi	a0,a0,-400 # 80225088 <user_test_table+0xde0>
    80207220:	ffffa097          	auipc	ra,0xffffa
    80207224:	ae6080e7          	jalr	-1306(ra) # 80200d06 <printf>
    printf("平均每个进程执行时间: %lu cycles\n", total_cycles / 3);
    80207228:	fd043703          	ld	a4,-48(s0)
    8020722c:	478d                	li	a5,3
    8020722e:	02f757b3          	divu	a5,a4,a5
    80207232:	85be                	mv	a1,a5
    80207234:	0001e517          	auipc	a0,0x1e
    80207238:	e7450513          	addi	a0,a0,-396 # 802250a8 <user_test_table+0xe00>
    8020723c:	ffffa097          	auipc	ra,0xffffa
    80207240:	aca080e7          	jalr	-1334(ra) # 80200d06 <printf>
    printf("===== 调度器测试完成 =====\n");
    80207244:	0001e517          	auipc	a0,0x1e
    80207248:	e9450513          	addi	a0,a0,-364 # 802250d8 <user_test_table+0xe30>
    8020724c:	ffffa097          	auipc	ra,0xffffa
    80207250:	aba080e7          	jalr	-1350(ra) # 80200d06 <printf>
}
    80207254:	60a6                	ld	ra,72(sp)
    80207256:	6406                	ld	s0,64(sp)
    80207258:	6161                	addi	sp,sp,80
    8020725a:	8082                	ret

000000008020725c <shared_buffer_init>:
void shared_buffer_init() {
    8020725c:	1141                	addi	sp,sp,-16
    8020725e:	e422                	sd	s0,8(sp)
    80207260:	0800                	addi	s0,sp,16
    proc_buffer = 0;
    80207262:	00020797          	auipc	a5,0x20
    80207266:	48678793          	addi	a5,a5,1158 # 802276e8 <proc_buffer>
    8020726a:	0007a023          	sw	zero,0(a5)
    proc_produced = 0;
    8020726e:	00020797          	auipc	a5,0x20
    80207272:	47e78793          	addi	a5,a5,1150 # 802276ec <proc_produced>
    80207276:	0007a023          	sw	zero,0(a5)
}
    8020727a:	0001                	nop
    8020727c:	6422                	ld	s0,8(sp)
    8020727e:	0141                	addi	sp,sp,16
    80207280:	8082                	ret

0000000080207282 <producer_task>:
void producer_task(void) {
    80207282:	7179                	addi	sp,sp,-48
    80207284:	f406                	sd	ra,40(sp)
    80207286:	f022                	sd	s0,32(sp)
    80207288:	1800                	addi	s0,sp,48
	int pid = myproc()->pid;
    8020728a:	ffffe097          	auipc	ra,0xffffe
    8020728e:	d06080e7          	jalr	-762(ra) # 80204f90 <myproc>
    80207292:	87aa                	mv	a5,a0
    80207294:	43dc                	lw	a5,4(a5)
    80207296:	fcf42e23          	sw	a5,-36(s0)
    uint64 sum = 0;
    8020729a:	fe043423          	sd	zero,-24(s0)
    const uint64 ITERATIONS = 10000000;  // 一千万次循环
    8020729e:	009897b7          	lui	a5,0x989
    802072a2:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f876980>
    802072a6:	fcf43823          	sd	a5,-48(s0)
    for(uint64 i = 0; i < ITERATIONS; i++) {
    802072aa:	fe043023          	sd	zero,-32(s0)
    802072ae:	a0bd                	j	8020731c <producer_task+0x9a>
        sum += (i * i) % 1000000007;  // 复杂计算
    802072b0:	fe043783          	ld	a5,-32(s0)
    802072b4:	02f78733          	mul	a4,a5,a5
    802072b8:	3b9ad7b7          	lui	a5,0x3b9ad
    802072bc:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_entry-0x448535f9>
    802072c0:	02f777b3          	remu	a5,a4,a5
    802072c4:	fe843703          	ld	a4,-24(s0)
    802072c8:	97ba                	add	a5,a5,a4
    802072ca:	fef43423          	sd	a5,-24(s0)
        if(i % (ITERATIONS/10) == 0) {
    802072ce:	fd043703          	ld	a4,-48(s0)
    802072d2:	47a9                	li	a5,10
    802072d4:	02f757b3          	divu	a5,a4,a5
    802072d8:	fe043703          	ld	a4,-32(s0)
    802072dc:	02f777b3          	remu	a5,a4,a5
    802072e0:	eb8d                	bnez	a5,80207312 <producer_task+0x90>
                   pid, (int)(i * 100 / ITERATIONS));
    802072e2:	fe043703          	ld	a4,-32(s0)
    802072e6:	06400793          	li	a5,100
    802072ea:	02f70733          	mul	a4,a4,a5
    802072ee:	fd043783          	ld	a5,-48(s0)
    802072f2:	02f757b3          	divu	a5,a4,a5
            printf("[Producer %d] 计算进度: %d%%\n", 
    802072f6:	0007871b          	sext.w	a4,a5
    802072fa:	fdc42783          	lw	a5,-36(s0)
    802072fe:	863a                	mv	a2,a4
    80207300:	85be                	mv	a1,a5
    80207302:	0001e517          	auipc	a0,0x1e
    80207306:	dfe50513          	addi	a0,a0,-514 # 80225100 <user_test_table+0xe58>
    8020730a:	ffffa097          	auipc	ra,0xffffa
    8020730e:	9fc080e7          	jalr	-1540(ra) # 80200d06 <printf>
    for(uint64 i = 0; i < ITERATIONS; i++) {
    80207312:	fe043783          	ld	a5,-32(s0)
    80207316:	0785                	addi	a5,a5,1
    80207318:	fef43023          	sd	a5,-32(s0)
    8020731c:	fe043703          	ld	a4,-32(s0)
    80207320:	fd043783          	ld	a5,-48(s0)
    80207324:	f8f766e3          	bltu	a4,a5,802072b0 <producer_task+0x2e>
    proc_buffer = 42;
    80207328:	00020797          	auipc	a5,0x20
    8020732c:	3c078793          	addi	a5,a5,960 # 802276e8 <proc_buffer>
    80207330:	02a00713          	li	a4,42
    80207334:	c398                	sw	a4,0(a5)
    proc_produced = 1;
    80207336:	00020797          	auipc	a5,0x20
    8020733a:	3b678793          	addi	a5,a5,950 # 802276ec <proc_produced>
    8020733e:	4705                	li	a4,1
    80207340:	c398                	sw	a4,0(a5)
    wakeup(&proc_produced); // 唤醒消费者
    80207342:	00020517          	auipc	a0,0x20
    80207346:	3aa50513          	addi	a0,a0,938 # 802276ec <proc_produced>
    8020734a:	fffff097          	auipc	ra,0xfffff
    8020734e:	968080e7          	jalr	-1688(ra) # 80205cb2 <wakeup>
    printf("Producer: produced value %d\n", proc_buffer);
    80207352:	00020797          	auipc	a5,0x20
    80207356:	39678793          	addi	a5,a5,918 # 802276e8 <proc_buffer>
    8020735a:	439c                	lw	a5,0(a5)
    8020735c:	85be                	mv	a1,a5
    8020735e:	0001e517          	auipc	a0,0x1e
    80207362:	dca50513          	addi	a0,a0,-566 # 80225128 <user_test_table+0xe80>
    80207366:	ffffa097          	auipc	ra,0xffffa
    8020736a:	9a0080e7          	jalr	-1632(ra) # 80200d06 <printf>
    exit_proc(0);
    8020736e:	4501                	li	a0,0
    80207370:	fffff097          	auipc	ra,0xfffff
    80207374:	a12080e7          	jalr	-1518(ra) # 80205d82 <exit_proc>
}
    80207378:	0001                	nop
    8020737a:	70a2                	ld	ra,40(sp)
    8020737c:	7402                	ld	s0,32(sp)
    8020737e:	6145                	addi	sp,sp,48
    80207380:	8082                	ret

0000000080207382 <consumer_task>:
void consumer_task(void) {
    80207382:	1141                	addi	sp,sp,-16
    80207384:	e406                	sd	ra,8(sp)
    80207386:	e022                	sd	s0,0(sp)
    80207388:	0800                	addi	s0,sp,16
    while (!proc_produced) {
    8020738a:	a00d                	j	802073ac <consumer_task+0x2a>
		printf("wait for producer\n");
    8020738c:	0001e517          	auipc	a0,0x1e
    80207390:	dbc50513          	addi	a0,a0,-580 # 80225148 <user_test_table+0xea0>
    80207394:	ffffa097          	auipc	ra,0xffffa
    80207398:	972080e7          	jalr	-1678(ra) # 80200d06 <printf>
        sleep(&proc_produced); // 等待生产者
    8020739c:	00020517          	auipc	a0,0x20
    802073a0:	35050513          	addi	a0,a0,848 # 802276ec <proc_produced>
    802073a4:	fffff097          	auipc	ra,0xfffff
    802073a8:	876080e7          	jalr	-1930(ra) # 80205c1a <sleep>
    while (!proc_produced) {
    802073ac:	00020797          	auipc	a5,0x20
    802073b0:	34078793          	addi	a5,a5,832 # 802276ec <proc_produced>
    802073b4:	439c                	lw	a5,0(a5)
    802073b6:	dbf9                	beqz	a5,8020738c <consumer_task+0xa>
    printf("Consumer: consumed value %d\n", proc_buffer);
    802073b8:	00020797          	auipc	a5,0x20
    802073bc:	33078793          	addi	a5,a5,816 # 802276e8 <proc_buffer>
    802073c0:	439c                	lw	a5,0(a5)
    802073c2:	85be                	mv	a1,a5
    802073c4:	0001e517          	auipc	a0,0x1e
    802073c8:	d9c50513          	addi	a0,a0,-612 # 80225160 <user_test_table+0xeb8>
    802073cc:	ffffa097          	auipc	ra,0xffffa
    802073d0:	93a080e7          	jalr	-1734(ra) # 80200d06 <printf>
    exit_proc(0);
    802073d4:	4501                	li	a0,0
    802073d6:	fffff097          	auipc	ra,0xfffff
    802073da:	9ac080e7          	jalr	-1620(ra) # 80205d82 <exit_proc>
}
    802073de:	0001                	nop
    802073e0:	60a2                	ld	ra,8(sp)
    802073e2:	6402                	ld	s0,0(sp)
    802073e4:	0141                	addi	sp,sp,16
    802073e6:	8082                	ret

00000000802073e8 <test_synchronization>:
void test_synchronization(void) {
    802073e8:	1141                	addi	sp,sp,-16
    802073ea:	e406                	sd	ra,8(sp)
    802073ec:	e022                	sd	s0,0(sp)
    802073ee:	0800                	addi	s0,sp,16
    printf("===== 测试开始: 同步机制测试 =====\n");
    802073f0:	0001e517          	auipc	a0,0x1e
    802073f4:	d9050513          	addi	a0,a0,-624 # 80225180 <user_test_table+0xed8>
    802073f8:	ffffa097          	auipc	ra,0xffffa
    802073fc:	90e080e7          	jalr	-1778(ra) # 80200d06 <printf>
    shared_buffer_init();
    80207400:	00000097          	auipc	ra,0x0
    80207404:	e5c080e7          	jalr	-420(ra) # 8020725c <shared_buffer_init>

    // 创建生产者和消费者进程
    create_kernel_proc(producer_task);
    80207408:	00000517          	auipc	a0,0x0
    8020740c:	e7a50513          	addi	a0,a0,-390 # 80207282 <producer_task>
    80207410:	ffffe097          	auipc	ra,0xffffe
    80207414:	1c0080e7          	jalr	448(ra) # 802055d0 <create_kernel_proc>
    create_kernel_proc(consumer_task);
    80207418:	00000517          	auipc	a0,0x0
    8020741c:	f6a50513          	addi	a0,a0,-150 # 80207382 <consumer_task>
    80207420:	ffffe097          	auipc	ra,0xffffe
    80207424:	1b0080e7          	jalr	432(ra) # 802055d0 <create_kernel_proc>

    // 等待两个进程完成
    wait_proc(NULL);
    80207428:	4501                	li	a0,0
    8020742a:	fffff097          	auipc	ra,0xfffff
    8020742e:	a22080e7          	jalr	-1502(ra) # 80205e4c <wait_proc>
    wait_proc(NULL);
    80207432:	4501                	li	a0,0
    80207434:	fffff097          	auipc	ra,0xfffff
    80207438:	a18080e7          	jalr	-1512(ra) # 80205e4c <wait_proc>

    printf("===== 测试结束 =====\n");
    8020743c:	0001e517          	auipc	a0,0x1e
    80207440:	d7450513          	addi	a0,a0,-652 # 802251b0 <user_test_table+0xf08>
    80207444:	ffffa097          	auipc	ra,0xffffa
    80207448:	8c2080e7          	jalr	-1854(ra) # 80200d06 <printf>
}
    8020744c:	0001                	nop
    8020744e:	60a2                	ld	ra,8(sp)
    80207450:	6402                	ld	s0,0(sp)
    80207452:	0141                	addi	sp,sp,16
    80207454:	8082                	ret

0000000080207456 <sys_access_task>:

void sys_access_task(void) {
    80207456:	1101                	addi	sp,sp,-32
    80207458:	ec06                	sd	ra,24(sp)
    8020745a:	e822                	sd	s0,16(sp)
    8020745c:	1000                	addi	s0,sp,32
    volatile int *ptr = (int*)0x80200000; // 内核空间地址
    8020745e:	40100793          	li	a5,1025
    80207462:	07d6                	slli	a5,a5,0x15
    80207464:	fef43423          	sd	a5,-24(s0)
    printf("SYS: try read kernel addr 0x80200000\n");
    80207468:	0001e517          	auipc	a0,0x1e
    8020746c:	d6850513          	addi	a0,a0,-664 # 802251d0 <user_test_table+0xf28>
    80207470:	ffffa097          	auipc	ra,0xffffa
    80207474:	896080e7          	jalr	-1898(ra) # 80200d06 <printf>
    int val = *ptr;
    80207478:	fe843783          	ld	a5,-24(s0)
    8020747c:	439c                	lw	a5,0(a5)
    8020747e:	fef42223          	sw	a5,-28(s0)
    printf("SYS: read success, value=%d\n", val);
    80207482:	fe442783          	lw	a5,-28(s0)
    80207486:	85be                	mv	a1,a5
    80207488:	0001e517          	auipc	a0,0x1e
    8020748c:	d7050513          	addi	a0,a0,-656 # 802251f8 <user_test_table+0xf50>
    80207490:	ffffa097          	auipc	ra,0xffffa
    80207494:	876080e7          	jalr	-1930(ra) # 80200d06 <printf>
    exit_proc(0);
    80207498:	4501                	li	a0,0
    8020749a:	fffff097          	auipc	ra,0xfffff
    8020749e:	8e8080e7          	jalr	-1816(ra) # 80205d82 <exit_proc>
}
    802074a2:	0001                	nop
    802074a4:	60e2                	ld	ra,24(sp)
    802074a6:	6442                	ld	s0,16(sp)
    802074a8:	6105                	addi	sp,sp,32
    802074aa:	8082                	ret

00000000802074ac <infinite_task>:

void infinite_task(void){
    802074ac:	1101                	addi	sp,sp,-32
    802074ae:	ec06                	sd	ra,24(sp)
    802074b0:	e822                	sd	s0,16(sp)
    802074b2:	1000                	addi	s0,sp,32
	int count = 5000 ;
    802074b4:	6785                	lui	a5,0x1
    802074b6:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    802074ba:	fef42623          	sw	a5,-20(s0)
	while(count){
    802074be:	a835                	j	802074fa <infinite_task+0x4e>
		count--;
    802074c0:	fec42783          	lw	a5,-20(s0)
    802074c4:	37fd                	addiw	a5,a5,-1
    802074c6:	fef42623          	sw	a5,-20(s0)
		if (count % 100 == 0)
    802074ca:	fec42783          	lw	a5,-20(s0)
    802074ce:	873e                	mv	a4,a5
    802074d0:	06400793          	li	a5,100
    802074d4:	02f767bb          	remw	a5,a4,a5
    802074d8:	2781                	sext.w	a5,a5
    802074da:	ef81                	bnez	a5,802074f2 <infinite_task+0x46>
			printf("count for %d\n",count);
    802074dc:	fec42783          	lw	a5,-20(s0)
    802074e0:	85be                	mv	a1,a5
    802074e2:	0001e517          	auipc	a0,0x1e
    802074e6:	d3650513          	addi	a0,a0,-714 # 80225218 <user_test_table+0xf70>
    802074ea:	ffffa097          	auipc	ra,0xffffa
    802074ee:	81c080e7          	jalr	-2020(ra) # 80200d06 <printf>
		yield();
    802074f2:	ffffe097          	auipc	ra,0xffffe
    802074f6:	682080e7          	jalr	1666(ra) # 80205b74 <yield>
	while(count){
    802074fa:	fec42783          	lw	a5,-20(s0)
    802074fe:	2781                	sext.w	a5,a5
    80207500:	f3e1                	bnez	a5,802074c0 <infinite_task+0x14>
	}
	warning("INFINITE TASK FINISH WITHOUT KILLED!!\n");
    80207502:	0001e517          	auipc	a0,0x1e
    80207506:	d2650513          	addi	a0,a0,-730 # 80225228 <user_test_table+0xf80>
    8020750a:	ffffa097          	auipc	ra,0xffffa
    8020750e:	27c080e7          	jalr	636(ra) # 80201786 <warning>
}
    80207512:	0001                	nop
    80207514:	60e2                	ld	ra,24(sp)
    80207516:	6442                	ld	s0,16(sp)
    80207518:	6105                	addi	sp,sp,32
    8020751a:	8082                	ret

000000008020751c <killer_task>:

void killer_task(uint64 kill_pid){
    8020751c:	7179                	addi	sp,sp,-48
    8020751e:	f406                	sd	ra,40(sp)
    80207520:	f022                	sd	s0,32(sp)
    80207522:	1800                	addi	s0,sp,48
    80207524:	fca43c23          	sd	a0,-40(s0)
	int count = 500;
    80207528:	1f400793          	li	a5,500
    8020752c:	fef42623          	sw	a5,-20(s0)
	while(count){
    80207530:	a81d                	j	80207566 <killer_task+0x4a>
		count--;
    80207532:	fec42783          	lw	a5,-20(s0)
    80207536:	37fd                	addiw	a5,a5,-1
    80207538:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    8020753c:	fec42783          	lw	a5,-20(s0)
    80207540:	873e                	mv	a4,a5
    80207542:	06400793          	li	a5,100
    80207546:	02f767bb          	remw	a5,a4,a5
    8020754a:	2781                	sext.w	a5,a5
    8020754c:	eb89                	bnez	a5,8020755e <killer_task+0x42>
			printf("I see you!!!\n");
    8020754e:	0001e517          	auipc	a0,0x1e
    80207552:	d0250513          	addi	a0,a0,-766 # 80225250 <user_test_table+0xfa8>
    80207556:	ffff9097          	auipc	ra,0xffff9
    8020755a:	7b0080e7          	jalr	1968(ra) # 80200d06 <printf>
		yield();
    8020755e:	ffffe097          	auipc	ra,0xffffe
    80207562:	616080e7          	jalr	1558(ra) # 80205b74 <yield>
	while(count){
    80207566:	fec42783          	lw	a5,-20(s0)
    8020756a:	2781                	sext.w	a5,a5
    8020756c:	f3f9                	bnez	a5,80207532 <killer_task+0x16>
	}
	kill_proc((int)kill_pid);
    8020756e:	fd843783          	ld	a5,-40(s0)
    80207572:	2781                	sext.w	a5,a5
    80207574:	853e                	mv	a0,a5
    80207576:	ffffe097          	auipc	ra,0xffffe
    8020757a:	7a8080e7          	jalr	1960(ra) # 80205d1e <kill_proc>
	printf("Killed proc %d\n",(int)kill_pid);
    8020757e:	fd843783          	ld	a5,-40(s0)
    80207582:	2781                	sext.w	a5,a5
    80207584:	85be                	mv	a1,a5
    80207586:	0001e517          	auipc	a0,0x1e
    8020758a:	cda50513          	addi	a0,a0,-806 # 80225260 <user_test_table+0xfb8>
    8020758e:	ffff9097          	auipc	ra,0xffff9
    80207592:	778080e7          	jalr	1912(ra) # 80200d06 <printf>
	exit_proc(0);
    80207596:	4501                	li	a0,0
    80207598:	ffffe097          	auipc	ra,0xffffe
    8020759c:	7ea080e7          	jalr	2026(ra) # 80205d82 <exit_proc>
}
    802075a0:	0001                	nop
    802075a2:	70a2                	ld	ra,40(sp)
    802075a4:	7402                	ld	s0,32(sp)
    802075a6:	6145                	addi	sp,sp,48
    802075a8:	8082                	ret

00000000802075aa <victim_task>:
void victim_task(void){
    802075aa:	1101                	addi	sp,sp,-32
    802075ac:	ec06                	sd	ra,24(sp)
    802075ae:	e822                	sd	s0,16(sp)
    802075b0:	1000                	addi	s0,sp,32
	int count =5000;
    802075b2:	6785                	lui	a5,0x1
    802075b4:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    802075b8:	fef42623          	sw	a5,-20(s0)
	while(count){
    802075bc:	a81d                	j	802075f2 <victim_task+0x48>
		count--;
    802075be:	fec42783          	lw	a5,-20(s0)
    802075c2:	37fd                	addiw	a5,a5,-1
    802075c4:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    802075c8:	fec42783          	lw	a5,-20(s0)
    802075cc:	873e                	mv	a4,a5
    802075ce:	06400793          	li	a5,100
    802075d2:	02f767bb          	remw	a5,a4,a5
    802075d6:	2781                	sext.w	a5,a5
    802075d8:	eb89                	bnez	a5,802075ea <victim_task+0x40>
			printf("Call for help!!\n");
    802075da:	0001e517          	auipc	a0,0x1e
    802075de:	c9650513          	addi	a0,a0,-874 # 80225270 <user_test_table+0xfc8>
    802075e2:	ffff9097          	auipc	ra,0xffff9
    802075e6:	724080e7          	jalr	1828(ra) # 80200d06 <printf>
		yield();
    802075ea:	ffffe097          	auipc	ra,0xffffe
    802075ee:	58a080e7          	jalr	1418(ra) # 80205b74 <yield>
	while(count){
    802075f2:	fec42783          	lw	a5,-20(s0)
    802075f6:	2781                	sext.w	a5,a5
    802075f8:	f3f9                	bnez	a5,802075be <victim_task+0x14>
	}
	printf("No one can kill me!\n");
    802075fa:	0001e517          	auipc	a0,0x1e
    802075fe:	c8e50513          	addi	a0,a0,-882 # 80225288 <user_test_table+0xfe0>
    80207602:	ffff9097          	auipc	ra,0xffff9
    80207606:	704080e7          	jalr	1796(ra) # 80200d06 <printf>
	exit_proc(0);
    8020760a:	4501                	li	a0,0
    8020760c:	ffffe097          	auipc	ra,0xffffe
    80207610:	776080e7          	jalr	1910(ra) # 80205d82 <exit_proc>
}
    80207614:	0001                	nop
    80207616:	60e2                	ld	ra,24(sp)
    80207618:	6442                	ld	s0,16(sp)
    8020761a:	6105                	addi	sp,sp,32
    8020761c:	8082                	ret

000000008020761e <test_kill>:

void test_kill(void){
    8020761e:	7179                	addi	sp,sp,-48
    80207620:	f406                	sd	ra,40(sp)
    80207622:	f022                	sd	s0,32(sp)
    80207624:	1800                	addi	s0,sp,48
	printf("\n----- 测试1: 创建后立即杀死 -----\n");
    80207626:	0001e517          	auipc	a0,0x1e
    8020762a:	c7a50513          	addi	a0,a0,-902 # 802252a0 <user_test_table+0xff8>
    8020762e:	ffff9097          	auipc	ra,0xffff9
    80207632:	6d8080e7          	jalr	1752(ra) # 80200d06 <printf>
	int pid =create_kernel_proc(simple_task);
    80207636:	fffff517          	auipc	a0,0xfffff
    8020763a:	40850513          	addi	a0,a0,1032 # 80206a3e <simple_task>
    8020763e:	ffffe097          	auipc	ra,0xffffe
    80207642:	f92080e7          	jalr	-110(ra) # 802055d0 <create_kernel_proc>
    80207646:	87aa                	mv	a5,a0
    80207648:	fef42423          	sw	a5,-24(s0)
	printf("【测试】: 创建进程成功，PID: %d\n", pid);
    8020764c:	fe842783          	lw	a5,-24(s0)
    80207650:	85be                	mv	a1,a5
    80207652:	0001e517          	auipc	a0,0x1e
    80207656:	c7e50513          	addi	a0,a0,-898 # 802252d0 <user_test_table+0x1028>
    8020765a:	ffff9097          	auipc	ra,0xffff9
    8020765e:	6ac080e7          	jalr	1708(ra) # 80200d06 <printf>
	kill_proc(pid);
    80207662:	fe842783          	lw	a5,-24(s0)
    80207666:	853e                	mv	a0,a5
    80207668:	ffffe097          	auipc	ra,0xffffe
    8020766c:	6b6080e7          	jalr	1718(ra) # 80205d1e <kill_proc>
	printf("【测试】: 等待被杀死的进程退出,此处被杀死的进程不会有输出...\n");
    80207670:	0001e517          	auipc	a0,0x1e
    80207674:	c9050513          	addi	a0,a0,-880 # 80225300 <user_test_table+0x1058>
    80207678:	ffff9097          	auipc	ra,0xffff9
    8020767c:	68e080e7          	jalr	1678(ra) # 80200d06 <printf>
	int ret =0;
    80207680:	fc042c23          	sw	zero,-40(s0)
	wait_proc(&ret);
    80207684:	fd840793          	addi	a5,s0,-40
    80207688:	853e                	mv	a0,a5
    8020768a:	ffffe097          	auipc	ra,0xffffe
    8020768e:	7c2080e7          	jalr	1986(ra) # 80205e4c <wait_proc>
	printf("【测试】: 进程%d退出，退出码应该为129，此处为%d\n ",pid,ret);
    80207692:	fd842703          	lw	a4,-40(s0)
    80207696:	fe842783          	lw	a5,-24(s0)
    8020769a:	863a                	mv	a2,a4
    8020769c:	85be                	mv	a1,a5
    8020769e:	0001e517          	auipc	a0,0x1e
    802076a2:	cc250513          	addi	a0,a0,-830 # 80225360 <user_test_table+0x10b8>
    802076a6:	ffff9097          	auipc	ra,0xffff9
    802076aa:	660080e7          	jalr	1632(ra) # 80200d06 <printf>
	if(SYS_kill == ret){
    802076ae:	fd842783          	lw	a5,-40(s0)
    802076b2:	873e                	mv	a4,a5
    802076b4:	08100793          	li	a5,129
    802076b8:	00f71b63          	bne	a4,a5,802076ce <test_kill+0xb0>
		printf("【测试】:尝试立即杀死进程，测试成功\n");
    802076bc:	0001e517          	auipc	a0,0x1e
    802076c0:	cec50513          	addi	a0,a0,-788 # 802253a8 <user_test_table+0x1100>
    802076c4:	ffff9097          	auipc	ra,0xffff9
    802076c8:	642080e7          	jalr	1602(ra) # 80200d06 <printf>
    802076cc:	a831                	j	802076e8 <test_kill+0xca>
	}else{
		printf("【测试】:尝试立即杀死进程失败，退出\n");
    802076ce:	0001e517          	auipc	a0,0x1e
    802076d2:	d1250513          	addi	a0,a0,-750 # 802253e0 <user_test_table+0x1138>
    802076d6:	ffff9097          	auipc	ra,0xffff9
    802076da:	630080e7          	jalr	1584(ra) # 80200d06 <printf>
		exit_proc(0);
    802076de:	4501                	li	a0,0
    802076e0:	ffffe097          	auipc	ra,0xffffe
    802076e4:	6a2080e7          	jalr	1698(ra) # 80205d82 <exit_proc>
	}
	printf("\n----- 测试2: 创建后稍后杀死 -----\n");
    802076e8:	0001e517          	auipc	a0,0x1e
    802076ec:	d3050513          	addi	a0,a0,-720 # 80225418 <user_test_table+0x1170>
    802076f0:	ffff9097          	auipc	ra,0xffff9
    802076f4:	616080e7          	jalr	1558(ra) # 80200d06 <printf>
	pid = create_kernel_proc(infinite_task);
    802076f8:	00000517          	auipc	a0,0x0
    802076fc:	db450513          	addi	a0,a0,-588 # 802074ac <infinite_task>
    80207700:	ffffe097          	auipc	ra,0xffffe
    80207704:	ed0080e7          	jalr	-304(ra) # 802055d0 <create_kernel_proc>
    80207708:	87aa                	mv	a5,a0
    8020770a:	fef42423          	sw	a5,-24(s0)
	int count = 500;
    8020770e:	1f400793          	li	a5,500
    80207712:	fef42623          	sw	a5,-20(s0)
	while(count){
    80207716:	a811                	j	8020772a <test_kill+0x10c>
		count--; //等待500次调度
    80207718:	fec42783          	lw	a5,-20(s0)
    8020771c:	37fd                	addiw	a5,a5,-1
    8020771e:	fef42623          	sw	a5,-20(s0)
		yield();
    80207722:	ffffe097          	auipc	ra,0xffffe
    80207726:	452080e7          	jalr	1106(ra) # 80205b74 <yield>
	while(count){
    8020772a:	fec42783          	lw	a5,-20(s0)
    8020772e:	2781                	sext.w	a5,a5
    80207730:	f7e5                	bnez	a5,80207718 <test_kill+0xfa>
	}
	kill_proc(pid);
    80207732:	fe842783          	lw	a5,-24(s0)
    80207736:	853e                	mv	a0,a5
    80207738:	ffffe097          	auipc	ra,0xffffe
    8020773c:	5e6080e7          	jalr	1510(ra) # 80205d1e <kill_proc>
	wait_proc(&ret);
    80207740:	fd840793          	addi	a5,s0,-40
    80207744:	853e                	mv	a0,a5
    80207746:	ffffe097          	auipc	ra,0xffffe
    8020774a:	706080e7          	jalr	1798(ra) # 80205e4c <wait_proc>
	if(SYS_kill == ret){
    8020774e:	fd842783          	lw	a5,-40(s0)
    80207752:	873e                	mv	a4,a5
    80207754:	08100793          	li	a5,129
    80207758:	00f71b63          	bne	a4,a5,8020776e <test_kill+0x150>
		printf("【测试】:尝试稍后杀死进程，测试成功\n");
    8020775c:	0001e517          	auipc	a0,0x1e
    80207760:	cec50513          	addi	a0,a0,-788 # 80225448 <user_test_table+0x11a0>
    80207764:	ffff9097          	auipc	ra,0xffff9
    80207768:	5a2080e7          	jalr	1442(ra) # 80200d06 <printf>
    8020776c:	a831                	j	80207788 <test_kill+0x16a>
	}else{
		printf("【测试】:尝试稍后杀死进程失败，退出\n");
    8020776e:	0001e517          	auipc	a0,0x1e
    80207772:	d1250513          	addi	a0,a0,-750 # 80225480 <user_test_table+0x11d8>
    80207776:	ffff9097          	auipc	ra,0xffff9
    8020777a:	590080e7          	jalr	1424(ra) # 80200d06 <printf>
		exit_proc(0);
    8020777e:	4501                	li	a0,0
    80207780:	ffffe097          	auipc	ra,0xffffe
    80207784:	602080e7          	jalr	1538(ra) # 80205d82 <exit_proc>
	}
	printf("\n----- 测试3: 创建killer 和 victim -----\n");
    80207788:	0001e517          	auipc	a0,0x1e
    8020778c:	d3050513          	addi	a0,a0,-720 # 802254b8 <user_test_table+0x1210>
    80207790:	ffff9097          	auipc	ra,0xffff9
    80207794:	576080e7          	jalr	1398(ra) # 80200d06 <printf>
	int victim = create_kernel_proc(victim_task);
    80207798:	00000517          	auipc	a0,0x0
    8020779c:	e1250513          	addi	a0,a0,-494 # 802075aa <victim_task>
    802077a0:	ffffe097          	auipc	ra,0xffffe
    802077a4:	e30080e7          	jalr	-464(ra) # 802055d0 <create_kernel_proc>
    802077a8:	87aa                	mv	a5,a0
    802077aa:	fef42223          	sw	a5,-28(s0)
	int killer = create_kernel_proc1(killer_task,victim);
    802077ae:	fe442783          	lw	a5,-28(s0)
    802077b2:	85be                	mv	a1,a5
    802077b4:	00000517          	auipc	a0,0x0
    802077b8:	d6850513          	addi	a0,a0,-664 # 8020751c <killer_task>
    802077bc:	ffffe097          	auipc	ra,0xffffe
    802077c0:	e82080e7          	jalr	-382(ra) # 8020563e <create_kernel_proc1>
    802077c4:	87aa                	mv	a5,a0
    802077c6:	fef42023          	sw	a5,-32(s0)
	int first_exit = wait_proc(&ret);
    802077ca:	fd840793          	addi	a5,s0,-40
    802077ce:	853e                	mv	a0,a5
    802077d0:	ffffe097          	auipc	ra,0xffffe
    802077d4:	67c080e7          	jalr	1660(ra) # 80205e4c <wait_proc>
    802077d8:	87aa                	mv	a5,a0
    802077da:	fcf42e23          	sw	a5,-36(s0)
	if(first_exit == killer){
    802077de:	fdc42783          	lw	a5,-36(s0)
    802077e2:	873e                	mv	a4,a5
    802077e4:	fe042783          	lw	a5,-32(s0)
    802077e8:	2701                	sext.w	a4,a4
    802077ea:	2781                	sext.w	a5,a5
    802077ec:	04f71263          	bne	a4,a5,80207830 <test_kill+0x212>
		wait_proc(&ret);
    802077f0:	fd840793          	addi	a5,s0,-40
    802077f4:	853e                	mv	a0,a5
    802077f6:	ffffe097          	auipc	ra,0xffffe
    802077fa:	656080e7          	jalr	1622(ra) # 80205e4c <wait_proc>
		if(SYS_kill == ret){
    802077fe:	fd842783          	lw	a5,-40(s0)
    80207802:	873e                	mv	a4,a5
    80207804:	08100793          	li	a5,129
    80207808:	00f71b63          	bne	a4,a5,8020781e <test_kill+0x200>
			printf("【测试】:killer win\n");
    8020780c:	0001e517          	auipc	a0,0x1e
    80207810:	cdc50513          	addi	a0,a0,-804 # 802254e8 <user_test_table+0x1240>
    80207814:	ffff9097          	auipc	ra,0xffff9
    80207818:	4f2080e7          	jalr	1266(ra) # 80200d06 <printf>
    8020781c:	a085                	j	8020787c <test_kill+0x25e>
		}else{
			printf("【测试】:出现问题，killer先结束但victim存活\n");
    8020781e:	0001e517          	auipc	a0,0x1e
    80207822:	cea50513          	addi	a0,a0,-790 # 80225508 <user_test_table+0x1260>
    80207826:	ffff9097          	auipc	ra,0xffff9
    8020782a:	4e0080e7          	jalr	1248(ra) # 80200d06 <printf>
    8020782e:	a0b9                	j	8020787c <test_kill+0x25e>
		}
	}else if(first_exit == victim){
    80207830:	fdc42783          	lw	a5,-36(s0)
    80207834:	873e                	mv	a4,a5
    80207836:	fe442783          	lw	a5,-28(s0)
    8020783a:	2701                	sext.w	a4,a4
    8020783c:	2781                	sext.w	a5,a5
    8020783e:	02f71f63          	bne	a4,a5,8020787c <test_kill+0x25e>
		wait_proc(NULL);
    80207842:	4501                	li	a0,0
    80207844:	ffffe097          	auipc	ra,0xffffe
    80207848:	608080e7          	jalr	1544(ra) # 80205e4c <wait_proc>
		if(SYS_kill == ret){
    8020784c:	fd842783          	lw	a5,-40(s0)
    80207850:	873e                	mv	a4,a5
    80207852:	08100793          	li	a5,129
    80207856:	00f71b63          	bne	a4,a5,8020786c <test_kill+0x24e>
			printf("【测试】:killer win\n");
    8020785a:	0001e517          	auipc	a0,0x1e
    8020785e:	c8e50513          	addi	a0,a0,-882 # 802254e8 <user_test_table+0x1240>
    80207862:	ffff9097          	auipc	ra,0xffff9
    80207866:	4a4080e7          	jalr	1188(ra) # 80200d06 <printf>
    8020786a:	a809                	j	8020787c <test_kill+0x25e>
		}else{
			printf("【测试】:出现问题，victim先结束且存活\n");
    8020786c:	0001e517          	auipc	a0,0x1e
    80207870:	cdc50513          	addi	a0,a0,-804 # 80225548 <user_test_table+0x12a0>
    80207874:	ffff9097          	auipc	ra,0xffff9
    80207878:	492080e7          	jalr	1170(ra) # 80200d06 <printf>
		}
	}
	exit_proc(0);
    8020787c:	4501                	li	a0,0
    8020787e:	ffffe097          	auipc	ra,0xffffe
    80207882:	504080e7          	jalr	1284(ra) # 80205d82 <exit_proc>
    80207886:	0001                	nop
    80207888:	70a2                	ld	ra,40(sp)
    8020788a:	7402                	ld	s0,32(sp)
    8020788c:	6145                	addi	sp,sp,48
    8020788e:	8082                	ret
	...
