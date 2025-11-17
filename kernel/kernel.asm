
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
    80200032:	1101                	addi	sp,sp,-32 # 80225fe0 <user_test_table+0x1c88>
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
    8020009c:	200080e7          	jalr	512(ra) # 80203298 <pmm_init>
	kvminit();
    802000a0:	00002097          	auipc	ra,0x2
    802000a4:	7d4080e7          	jalr	2004(ra) # 80202874 <kvminit>
	trap_init();
    802000a8:	00004097          	auipc	ra,0x4
    802000ac:	814080e7          	jalr	-2028(ra) # 802038bc <trap_init>
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
    802000cc:	c66080e7          	jalr	-922(ra) # 80200d2e <printf>
    printf("        RISC-V Operating System v1.0         \n");
    802000d0:	0000a517          	auipc	a0,0xa
    802000d4:	18850513          	addi	a0,a0,392 # 8020a258 <user_test_table+0x140>
    802000d8:	00001097          	auipc	ra,0x1
    802000dc:	c56080e7          	jalr	-938(ra) # 80200d2e <printf>
    printf("===============================================\n\n");
    802000e0:	0000a517          	auipc	a0,0xa
    802000e4:	1a850513          	addi	a0,a0,424 # 8020a288 <user_test_table+0x170>
    802000e8:	00001097          	auipc	ra,0x1
    802000ec:	c46080e7          	jalr	-954(ra) # 80200d2e <printf>
	init_proc(); // 初始化进程管理子系统
    802000f0:	00005097          	auipc	ra,0x5
    802000f4:	0c6080e7          	jalr	198(ra) # 802051b6 <init_proc>
	int main_pid = create_kernel_proc(kernel_main);
    802000f8:	00000517          	auipc	a0,0x0
    802000fc:	46050513          	addi	a0,a0,1120 # 80200558 <kernel_main>
    80200100:	00005097          	auipc	ra,0x5
    80200104:	4f0080e7          	jalr	1264(ra) # 802055f0 <create_kernel_proc>
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
    80200124:	65a080e7          	jalr	1626(ra) # 8020177a <panic>
	schedule();
    80200128:	00006097          	auipc	ra,0x6
    8020012c:	9be080e7          	jalr	-1602(ra) # 80205ae6 <schedule>
    panic("START: main() exit unexpectedly!!!\n");
    80200130:	0000a517          	auipc	a0,0xa
    80200134:	1b850513          	addi	a0,a0,440 # 8020a2e8 <user_test_table+0x1d0>
    80200138:	00001097          	auipc	ra,0x1
    8020013c:	642080e7          	jalr	1602(ra) # 8020177a <panic>
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
    8020015e:	bd4080e7          	jalr	-1068(ra) # 80200d2e <printf>
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
    80200194:	b9e080e7          	jalr	-1122(ra) # 80200d2e <printf>
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
    802001ba:	b78080e7          	jalr	-1160(ra) # 80200d2e <printf>
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
    802001f4:	b3e080e7          	jalr	-1218(ra) # 80200d2e <printf>
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
    8020021a:	b18080e7          	jalr	-1256(ra) # 80200d2e <printf>
    printf("  h. help          - 显示此帮助\n");
    8020021e:	0000a517          	auipc	a0,0xa
    80200222:	15a50513          	addi	a0,a0,346 # 8020a378 <user_test_table+0x260>
    80200226:	00001097          	auipc	ra,0x1
    8020022a:	b08080e7          	jalr	-1272(ra) # 80200d2e <printf>
    printf("  e. exit          - 退出控制台\n");
    8020022e:	0000a517          	auipc	a0,0xa
    80200232:	17250513          	addi	a0,a0,370 # 8020a3a0 <user_test_table+0x288>
    80200236:	00001097          	auipc	ra,0x1
    8020023a:	af8080e7          	jalr	-1288(ra) # 80200d2e <printf>
    printf("  p. ps            - 显示进程状态\n");
    8020023e:	0000a517          	auipc	a0,0xa
    80200242:	18a50513          	addi	a0,a0,394 # 8020a3c8 <user_test_table+0x2b0>
    80200246:	00001097          	auipc	ra,0x1
    8020024a:	ae8080e7          	jalr	-1304(ra) # 80200d2e <printf>
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
    8020027a:	ab8080e7          	jalr	-1352(ra) # 80200d2e <printf>
        readline(input_buffer, sizeof(input_buffer));
    8020027e:	ed840793          	addi	a5,s0,-296
    80200282:	10000593          	li	a1,256
    80200286:	853e                	mv	a0,a5
    80200288:	00000097          	auipc	ra,0x0
    8020028c:	798080e7          	jalr	1944(ra) # 80200a20 <readline>
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
    80200312:	cec080e7          	jalr	-788(ra) # 80205ffa <print_proc_table>
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
    80200340:	05c080e7          	jalr	92(ra) # 80206398 <atoi>
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
    80200382:	9b0080e7          	jalr	-1616(ra) # 80200d2e <printf>
                int pid = create_kernel_proc(kernel_test_table[index].func);
    80200386:	00027717          	auipc	a4,0x27
    8020038a:	c7a70713          	addi	a4,a4,-902 # 80227000 <kernel_test_table>
    8020038e:	fe042783          	lw	a5,-32(s0)
    80200392:	0792                	slli	a5,a5,0x4
    80200394:	97ba                	add	a5,a5,a4
    80200396:	679c                	ld	a5,8(a5)
    80200398:	853e                	mv	a0,a5
    8020039a:	00005097          	auipc	ra,0x5
    8020039e:	256080e7          	jalr	598(ra) # 802055f0 <create_kernel_proc>
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
    802003be:	974080e7          	jalr	-1676(ra) # 80200d2e <printf>
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
    802003c2:	a82d                	j	802003fc <console+0x1a4>
                    printf("创建内核测试进程成功，PID: %d\n", pid);
    802003c4:	fdc42783          	lw	a5,-36(s0)
    802003c8:	85be                	mv	a1,a5
    802003ca:	0000a517          	auipc	a0,0xa
    802003ce:	08650513          	addi	a0,a0,134 # 8020a450 <user_test_table+0x338>
    802003d2:	00001097          	auipc	ra,0x1
    802003d6:	95c080e7          	jalr	-1700(ra) # 80200d2e <printf>
                    wait_proc(&status);
    802003da:	ed440793          	addi	a5,s0,-300
    802003de:	853e                	mv	a0,a5
    802003e0:	00006097          	auipc	ra,0x6
    802003e4:	a8c080e7          	jalr	-1396(ra) # 80205e6c <wait_proc>
            if (index >= 0 && index < KERNEL_TEST_COUNT) {
    802003e8:	a811                	j	802003fc <console+0x1a4>
                printf("无效的内核测试序号\n");
    802003ea:	0000a517          	auipc	a0,0xa
    802003ee:	09650513          	addi	a0,a0,150 # 8020a480 <user_test_table+0x368>
    802003f2:	00001097          	auipc	ra,0x1
    802003f6:	93c080e7          	jalr	-1732(ra) # 80200d2e <printf>
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
    80200426:	f76080e7          	jalr	-138(ra) # 80206398 <atoi>
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
    8020046e:	8c4080e7          	jalr	-1852(ra) # 80200d2e <printf>
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
    802004aa:	236080e7          	jalr	566(ra) # 802056dc <create_user_proc>
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
    802004ca:	868080e7          	jalr	-1944(ra) # 80200d2e <printf>
            if (index >= 0 && index < USER_TEST_COUNT) {
    802004ce:	a82d                	j	80200508 <console+0x2b0>
                    printf("创建用户测试进程成功，PID: %d\n", pid);
    802004d0:	fe442783          	lw	a5,-28(s0)
    802004d4:	85be                	mv	a1,a5
    802004d6:	0000a517          	auipc	a0,0xa
    802004da:	01250513          	addi	a0,a0,18 # 8020a4e8 <user_test_table+0x3d0>
    802004de:	00001097          	auipc	ra,0x1
    802004e2:	850080e7          	jalr	-1968(ra) # 80200d2e <printf>
                    wait_proc(&status);
    802004e6:	ed040793          	addi	a5,s0,-304
    802004ea:	853e                	mv	a0,a5
    802004ec:	00006097          	auipc	ra,0x6
    802004f0:	980080e7          	jalr	-1664(ra) # 80205e6c <wait_proc>
            if (index >= 0 && index < USER_TEST_COUNT) {
    802004f4:	a811                	j	80200508 <console+0x2b0>
                printf("无效的用户测试序号\n");
    802004f6:	0000a517          	auipc	a0,0xa
    802004fa:	02250513          	addi	a0,a0,34 # 8020a518 <user_test_table+0x400>
    802004fe:	00001097          	auipc	ra,0x1
    80200502:	830080e7          	jalr	-2000(ra) # 80200d2e <printf>
        } else if (input_buffer[0] == 'u' || input_buffer[0] == 'U') {
    80200506:	a03d                	j	80200534 <console+0x2dc>
    80200508:	a035                	j	80200534 <console+0x2dc>
            printf("无效命令: %s\n", input_buffer);
    8020050a:	ed840793          	addi	a5,s0,-296
    8020050e:	85be                	mv	a1,a5
    80200510:	0000a517          	auipc	a0,0xa
    80200514:	02850513          	addi	a0,a0,40 # 8020a538 <user_test_table+0x420>
    80200518:	00001097          	auipc	ra,0x1
    8020051c:	816080e7          	jalr	-2026(ra) # 80200d2e <printf>
            printf("输入 'h' 查看帮助\n");
    80200520:	0000a517          	auipc	a0,0xa
    80200524:	03050513          	addi	a0,a0,48 # 8020a550 <user_test_table+0x438>
    80200528:	00001097          	auipc	ra,0x1
    8020052c:	806080e7          	jalr	-2042(ra) # 80200d2e <printf>
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
    8020054a:	7e8080e7          	jalr	2024(ra) # 80200d2e <printf>
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
    80200564:	ce6080e7          	jalr	-794(ra) # 80201246 <clear_screen>
	int console_pid = create_kernel_proc(console);
    80200568:	00000517          	auipc	a0,0x0
    8020056c:	cf050513          	addi	a0,a0,-784 # 80200258 <console>
    80200570:	00005097          	auipc	ra,0x5
    80200574:	080080e7          	jalr	128(ra) # 802055f0 <create_kernel_proc>
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
    80200594:	1ea080e7          	jalr	490(ra) # 8020177a <panic>
    80200598:	a821                	j	802005b0 <kernel_main+0x58>
		printf("KERNEL_MAIN: console process created with PID %d\n", console_pid);
    8020059a:	fec42783          	lw	a5,-20(s0)
    8020059e:	85be                	mv	a1,a5
    802005a0:	0000a517          	auipc	a0,0xa
    802005a4:	01850513          	addi	a0,a0,24 # 8020a5b8 <user_test_table+0x4a0>
    802005a8:	00000097          	auipc	ra,0x0
    802005ac:	786080e7          	jalr	1926(ra) # 80200d2e <printf>
	int pid = wait_proc(&status);
    802005b0:	fe440793          	addi	a5,s0,-28
    802005b4:	853e                	mv	a0,a5
    802005b6:	00006097          	auipc	ra,0x6
    802005ba:	8b6080e7          	jalr	-1866(ra) # 80205e6c <wait_proc>
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
    802005ee:	744080e7          	jalr	1860(ra) # 80200d2e <printf>
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
    80200636:	106080e7          	jalr	262(ra) # 80203738 <register_interrupt>
    enable_interrupts(UART0_IRQ);
    8020063a:	4529                	li	a0,10
    8020063c:	00003097          	auipc	ra,0x3
    80200640:	186080e7          	jalr	390(ra) # 802037c2 <enable_interrupts>
    printf("UART initialized with input support\n");
    80200644:	0000c517          	auipc	a0,0xc
    80200648:	0a450513          	addi	a0,a0,164 # 8020c6e8 <user_test_table+0x78>
    8020064c:	00000097          	auipc	ra,0x0
    80200650:	6e2080e7          	jalr	1762(ra) # 80200d2e <printf>
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
    80200758:	a435                	j	80200984 <uart_intr+0x234>
        char c = ReadReg(RHR);
    8020075a:	100007b7          	lui	a5,0x10000
    8020075e:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70200000>
    80200762:	fef405a3          	sb	a5,-21(s0)
		if (c == 0x0c) { // 是'L'与 0x1f按位与的结果
    80200766:	feb44783          	lbu	a5,-21(s0)
    8020076a:	0ff7f713          	zext.b	a4,a5
    8020076e:	47b1                	li	a5,12
    80200770:	02f71963          	bne	a4,a5,802007a2 <uart_intr+0x52>
            clear_screen();
    80200774:	00001097          	auipc	ra,0x1
    80200778:	ad2080e7          	jalr	-1326(ra) # 80201246 <clear_screen>
			if (myproc()->pid == 1){ // 检查当前进程是否为控制台进程
    8020077c:	00005097          	auipc	ra,0x5
    80200780:	834080e7          	jalr	-1996(ra) # 80204fb0 <myproc>
    80200784:	87aa                	mv	a5,a0
    80200786:	43dc                	lw	a5,4(a5)
    80200788:	873e                	mv	a4,a5
    8020078a:	4785                	li	a5,1
    8020078c:	1ef71b63          	bne	a4,a5,80200982 <uart_intr+0x232>
				printf("Console >>> ");
    80200790:	0000c517          	auipc	a0,0xc
    80200794:	f8050513          	addi	a0,a0,-128 # 8020c710 <user_test_table+0xa0>
    80200798:	00000097          	auipc	ra,0x0
    8020079c:	596080e7          	jalr	1430(ra) # 80200d2e <printf>
			}
            continue;
    802007a0:	a2cd                	j	80200982 <uart_intr+0x232>
        }
        if (c == '\r' || c == '\n') {
    802007a2:	feb44783          	lbu	a5,-21(s0)
    802007a6:	0ff7f713          	zext.b	a4,a5
    802007aa:	47b5                	li	a5,13
    802007ac:	00f70963          	beq	a4,a5,802007be <uart_intr+0x6e>
    802007b0:	feb44783          	lbu	a5,-21(s0)
    802007b4:	0ff7f713          	zext.b	a4,a5
    802007b8:	47a9                	li	a5,10
    802007ba:	10f71763          	bne	a4,a5,802008c8 <uart_intr+0x178>
            uart_putc('\n');
    802007be:	4529                	li	a0,10
    802007c0:	00000097          	auipc	ra,0x0
    802007c4:	e9e080e7          	jalr	-354(ra) # 8020065e <uart_putc>
            // 将编辑好的整行写入全局缓冲区
            for (int i = 0; i < line_len; i++) {
    802007c8:	fe042623          	sw	zero,-20(s0)
    802007cc:	a8b5                	j	80200848 <uart_intr+0xf8>
                int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    802007ce:	00027797          	auipc	a5,0x27
    802007d2:	8f278793          	addi	a5,a5,-1806 # 802270c0 <uart_input_buf>
    802007d6:	0847a783          	lw	a5,132(a5)
    802007da:	2785                	addiw	a5,a5,1
    802007dc:	2781                	sext.w	a5,a5
    802007de:	2781                	sext.w	a5,a5
    802007e0:	07f7f793          	andi	a5,a5,127
    802007e4:	fef42023          	sw	a5,-32(s0)
                if (next != uart_input_buf.r) {
    802007e8:	00027797          	auipc	a5,0x27
    802007ec:	8d878793          	addi	a5,a5,-1832 # 802270c0 <uart_input_buf>
    802007f0:	0807a703          	lw	a4,128(a5)
    802007f4:	fe042783          	lw	a5,-32(s0)
    802007f8:	04f70363          	beq	a4,a5,8020083e <uart_intr+0xee>
                    uart_input_buf.buf[uart_input_buf.w] = linebuf[i];
    802007fc:	00027797          	auipc	a5,0x27
    80200800:	8c478793          	addi	a5,a5,-1852 # 802270c0 <uart_input_buf>
    80200804:	0847a603          	lw	a2,132(a5)
    80200808:	00027717          	auipc	a4,0x27
    8020080c:	94870713          	addi	a4,a4,-1720 # 80227150 <linebuf.1>
    80200810:	fec42783          	lw	a5,-20(s0)
    80200814:	97ba                	add	a5,a5,a4
    80200816:	0007c703          	lbu	a4,0(a5)
    8020081a:	00027697          	auipc	a3,0x27
    8020081e:	8a668693          	addi	a3,a3,-1882 # 802270c0 <uart_input_buf>
    80200822:	02061793          	slli	a5,a2,0x20
    80200826:	9381                	srli	a5,a5,0x20
    80200828:	97b6                	add	a5,a5,a3
    8020082a:	00e78023          	sb	a4,0(a5)
                    uart_input_buf.w = next;
    8020082e:	fe042703          	lw	a4,-32(s0)
    80200832:	00027797          	auipc	a5,0x27
    80200836:	88e78793          	addi	a5,a5,-1906 # 802270c0 <uart_input_buf>
    8020083a:	08e7a223          	sw	a4,132(a5)
            for (int i = 0; i < line_len; i++) {
    8020083e:	fec42783          	lw	a5,-20(s0)
    80200842:	2785                	addiw	a5,a5,1
    80200844:	fef42623          	sw	a5,-20(s0)
    80200848:	00027797          	auipc	a5,0x27
    8020084c:	98878793          	addi	a5,a5,-1656 # 802271d0 <line_len.0>
    80200850:	4398                	lw	a4,0(a5)
    80200852:	fec42783          	lw	a5,-20(s0)
    80200856:	2781                	sext.w	a5,a5
    80200858:	f6e7cbe3          	blt	a5,a4,802007ce <uart_intr+0x7e>
                }
            }
            // 写入换行符
            int next = (uart_input_buf.w + 1) % INPUT_BUF_SIZE;
    8020085c:	00027797          	auipc	a5,0x27
    80200860:	86478793          	addi	a5,a5,-1948 # 802270c0 <uart_input_buf>
    80200864:	0847a783          	lw	a5,132(a5)
    80200868:	2785                	addiw	a5,a5,1
    8020086a:	2781                	sext.w	a5,a5
    8020086c:	2781                	sext.w	a5,a5
    8020086e:	07f7f793          	andi	a5,a5,127
    80200872:	fef42223          	sw	a5,-28(s0)
            if (next != uart_input_buf.r) {
    80200876:	00027797          	auipc	a5,0x27
    8020087a:	84a78793          	addi	a5,a5,-1974 # 802270c0 <uart_input_buf>
    8020087e:	0807a703          	lw	a4,128(a5)
    80200882:	fe442783          	lw	a5,-28(s0)
    80200886:	02f70a63          	beq	a4,a5,802008ba <uart_intr+0x16a>
                uart_input_buf.buf[uart_input_buf.w] = '\n';
    8020088a:	00027797          	auipc	a5,0x27
    8020088e:	83678793          	addi	a5,a5,-1994 # 802270c0 <uart_input_buf>
    80200892:	0847a783          	lw	a5,132(a5)
    80200896:	00027717          	auipc	a4,0x27
    8020089a:	82a70713          	addi	a4,a4,-2006 # 802270c0 <uart_input_buf>
    8020089e:	1782                	slli	a5,a5,0x20
    802008a0:	9381                	srli	a5,a5,0x20
    802008a2:	97ba                	add	a5,a5,a4
    802008a4:	4729                	li	a4,10
    802008a6:	00e78023          	sb	a4,0(a5)
                uart_input_buf.w = next;
    802008aa:	fe442703          	lw	a4,-28(s0)
    802008ae:	00027797          	auipc	a5,0x27
    802008b2:	81278793          	addi	a5,a5,-2030 # 802270c0 <uart_input_buf>
    802008b6:	08e7a223          	sw	a4,132(a5)
            }
            line_len = 0;
    802008ba:	00027797          	auipc	a5,0x27
    802008be:	91678793          	addi	a5,a5,-1770 # 802271d0 <line_len.0>
    802008c2:	0007a023          	sw	zero,0(a5)
        if (c == '\r' || c == '\n') {
    802008c6:	a87d                	j	80200984 <uart_intr+0x234>
        } else if (c == 0x7f || c == 0x08) { // 退格
    802008c8:	feb44783          	lbu	a5,-21(s0)
    802008cc:	0ff7f713          	zext.b	a4,a5
    802008d0:	07f00793          	li	a5,127
    802008d4:	00f70963          	beq	a4,a5,802008e6 <uart_intr+0x196>
    802008d8:	feb44783          	lbu	a5,-21(s0)
    802008dc:	0ff7f713          	zext.b	a4,a5
    802008e0:	47a1                	li	a5,8
    802008e2:	04f71763          	bne	a4,a5,80200930 <uart_intr+0x1e0>
            if (line_len > 0) {
    802008e6:	00027797          	auipc	a5,0x27
    802008ea:	8ea78793          	addi	a5,a5,-1814 # 802271d0 <line_len.0>
    802008ee:	439c                	lw	a5,0(a5)
    802008f0:	08f05a63          	blez	a5,80200984 <uart_intr+0x234>
                uart_putc('\b');
    802008f4:	4521                	li	a0,8
    802008f6:	00000097          	auipc	ra,0x0
    802008fa:	d68080e7          	jalr	-664(ra) # 8020065e <uart_putc>
                uart_putc(' ');
    802008fe:	02000513          	li	a0,32
    80200902:	00000097          	auipc	ra,0x0
    80200906:	d5c080e7          	jalr	-676(ra) # 8020065e <uart_putc>
                uart_putc('\b');
    8020090a:	4521                	li	a0,8
    8020090c:	00000097          	auipc	ra,0x0
    80200910:	d52080e7          	jalr	-686(ra) # 8020065e <uart_putc>
                line_len--;
    80200914:	00027797          	auipc	a5,0x27
    80200918:	8bc78793          	addi	a5,a5,-1860 # 802271d0 <line_len.0>
    8020091c:	439c                	lw	a5,0(a5)
    8020091e:	37fd                	addiw	a5,a5,-1
    80200920:	0007871b          	sext.w	a4,a5
    80200924:	00027797          	auipc	a5,0x27
    80200928:	8ac78793          	addi	a5,a5,-1876 # 802271d0 <line_len.0>
    8020092c:	c398                	sw	a4,0(a5)
            if (line_len > 0) {
    8020092e:	a899                	j	80200984 <uart_intr+0x234>
            }
        } else if (line_len < LINE_BUF_SIZE - 1) {
    80200930:	00027797          	auipc	a5,0x27
    80200934:	8a078793          	addi	a5,a5,-1888 # 802271d0 <line_len.0>
    80200938:	439c                	lw	a5,0(a5)
    8020093a:	873e                	mv	a4,a5
    8020093c:	07e00793          	li	a5,126
    80200940:	04e7c263          	blt	a5,a4,80200984 <uart_intr+0x234>
            uart_putc(c);
    80200944:	feb44783          	lbu	a5,-21(s0)
    80200948:	853e                	mv	a0,a5
    8020094a:	00000097          	auipc	ra,0x0
    8020094e:	d14080e7          	jalr	-748(ra) # 8020065e <uart_putc>
            linebuf[line_len++] = c;
    80200952:	00027797          	auipc	a5,0x27
    80200956:	87e78793          	addi	a5,a5,-1922 # 802271d0 <line_len.0>
    8020095a:	439c                	lw	a5,0(a5)
    8020095c:	0017871b          	addiw	a4,a5,1
    80200960:	0007069b          	sext.w	a3,a4
    80200964:	00027717          	auipc	a4,0x27
    80200968:	86c70713          	addi	a4,a4,-1940 # 802271d0 <line_len.0>
    8020096c:	c314                	sw	a3,0(a4)
    8020096e:	00026717          	auipc	a4,0x26
    80200972:	7e270713          	addi	a4,a4,2018 # 80227150 <linebuf.1>
    80200976:	97ba                	add	a5,a5,a4
    80200978:	feb44703          	lbu	a4,-21(s0)
    8020097c:	00e78023          	sb	a4,0(a5)
    80200980:	a011                	j	80200984 <uart_intr+0x234>
            continue;
    80200982:	0001                	nop
    while (ReadReg(LSR) & LSR_RX_READY) {
    80200984:	100007b7          	lui	a5,0x10000
    80200988:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x701ffffb>
    8020098a:	0007c783          	lbu	a5,0(a5)
    8020098e:	0ff7f793          	zext.b	a5,a5
    80200992:	2781                	sext.w	a5,a5
    80200994:	8b85                	andi	a5,a5,1
    80200996:	2781                	sext.w	a5,a5
    80200998:	dc0791e3          	bnez	a5,8020075a <uart_intr+0xa>
        }
    }
}
    8020099c:	0001                	nop
    8020099e:	0001                	nop
    802009a0:	60e2                	ld	ra,24(sp)
    802009a2:	6442                	ld	s0,16(sp)
    802009a4:	6105                	addi	sp,sp,32
    802009a6:	8082                	ret

00000000802009a8 <uart_getc_blocking>:
// 阻塞式读取一个字符
char uart_getc_blocking(void) {
    802009a8:	1101                	addi	sp,sp,-32
    802009aa:	ec22                	sd	s0,24(sp)
    802009ac:	1000                	addi	s0,sp,32
    // 等待直到有字符可读
    while (uart_input_buf.r == uart_input_buf.w) {
    802009ae:	a011                	j	802009b2 <uart_getc_blocking+0xa>
        // 在实际系统中，这里可能需要让进程睡眠
        // 但目前我们使用简单的轮询
        asm volatile("nop");
    802009b0:	0001                	nop
    while (uart_input_buf.r == uart_input_buf.w) {
    802009b2:	00026797          	auipc	a5,0x26
    802009b6:	70e78793          	addi	a5,a5,1806 # 802270c0 <uart_input_buf>
    802009ba:	0807a703          	lw	a4,128(a5)
    802009be:	00026797          	auipc	a5,0x26
    802009c2:	70278793          	addi	a5,a5,1794 # 802270c0 <uart_input_buf>
    802009c6:	0847a783          	lw	a5,132(a5)
    802009ca:	fef703e3          	beq	a4,a5,802009b0 <uart_getc_blocking+0x8>
    }
    
    // 读取字符
    char c = uart_input_buf.buf[uart_input_buf.r];
    802009ce:	00026797          	auipc	a5,0x26
    802009d2:	6f278793          	addi	a5,a5,1778 # 802270c0 <uart_input_buf>
    802009d6:	0807a783          	lw	a5,128(a5)
    802009da:	00026717          	auipc	a4,0x26
    802009de:	6e670713          	addi	a4,a4,1766 # 802270c0 <uart_input_buf>
    802009e2:	1782                	slli	a5,a5,0x20
    802009e4:	9381                	srli	a5,a5,0x20
    802009e6:	97ba                	add	a5,a5,a4
    802009e8:	0007c783          	lbu	a5,0(a5)
    802009ec:	fef407a3          	sb	a5,-17(s0)
    uart_input_buf.r = (uart_input_buf.r + 1) % INPUT_BUF_SIZE;
    802009f0:	00026797          	auipc	a5,0x26
    802009f4:	6d078793          	addi	a5,a5,1744 # 802270c0 <uart_input_buf>
    802009f8:	0807a783          	lw	a5,128(a5)
    802009fc:	2785                	addiw	a5,a5,1
    802009fe:	2781                	sext.w	a5,a5
    80200a00:	07f7f793          	andi	a5,a5,127
    80200a04:	0007871b          	sext.w	a4,a5
    80200a08:	00026797          	auipc	a5,0x26
    80200a0c:	6b878793          	addi	a5,a5,1720 # 802270c0 <uart_input_buf>
    80200a10:	08e7a023          	sw	a4,128(a5)
    return c;
    80200a14:	fef44783          	lbu	a5,-17(s0)
}
    80200a18:	853e                	mv	a0,a5
    80200a1a:	6462                	ld	s0,24(sp)
    80200a1c:	6105                	addi	sp,sp,32
    80200a1e:	8082                	ret

0000000080200a20 <readline>:
// 读取一行输入，最多读取max-1个字符，并在末尾添加\0
int readline(char *buf, int max) {
    80200a20:	7179                	addi	sp,sp,-48
    80200a22:	f406                	sd	ra,40(sp)
    80200a24:	f022                	sd	s0,32(sp)
    80200a26:	1800                	addi	s0,sp,48
    80200a28:	fca43c23          	sd	a0,-40(s0)
    80200a2c:	87ae                	mv	a5,a1
    80200a2e:	fcf42a23          	sw	a5,-44(s0)
    int i = 0;
    80200a32:	fe042623          	sw	zero,-20(s0)
    char c;
    
    while (i < max - 1) {
    80200a36:	a0b9                	j	80200a84 <readline+0x64>
        c = uart_getc_blocking();
    80200a38:	00000097          	auipc	ra,0x0
    80200a3c:	f70080e7          	jalr	-144(ra) # 802009a8 <uart_getc_blocking>
    80200a40:	87aa                	mv	a5,a0
    80200a42:	fef405a3          	sb	a5,-21(s0)
        
        if (c == '\n') {
    80200a46:	feb44783          	lbu	a5,-21(s0)
    80200a4a:	0ff7f713          	zext.b	a4,a5
    80200a4e:	47a9                	li	a5,10
    80200a50:	00f71c63          	bne	a4,a5,80200a68 <readline+0x48>
            buf[i] = '\0';
    80200a54:	fec42783          	lw	a5,-20(s0)
    80200a58:	fd843703          	ld	a4,-40(s0)
    80200a5c:	97ba                	add	a5,a5,a4
    80200a5e:	00078023          	sb	zero,0(a5)
            return i;
    80200a62:	fec42783          	lw	a5,-20(s0)
    80200a66:	a0a9                	j	80200ab0 <readline+0x90>
        } else {
            buf[i++] = c;
    80200a68:	fec42783          	lw	a5,-20(s0)
    80200a6c:	0017871b          	addiw	a4,a5,1
    80200a70:	fee42623          	sw	a4,-20(s0)
    80200a74:	873e                	mv	a4,a5
    80200a76:	fd843783          	ld	a5,-40(s0)
    80200a7a:	97ba                	add	a5,a5,a4
    80200a7c:	feb44703          	lbu	a4,-21(s0)
    80200a80:	00e78023          	sb	a4,0(a5)
    while (i < max - 1) {
    80200a84:	fd442783          	lw	a5,-44(s0)
    80200a88:	37fd                	addiw	a5,a5,-1
    80200a8a:	0007871b          	sext.w	a4,a5
    80200a8e:	fec42783          	lw	a5,-20(s0)
    80200a92:	2781                	sext.w	a5,a5
    80200a94:	fae7c2e3          	blt	a5,a4,80200a38 <readline+0x18>
        }
    }
    
    // 缓冲区满，添加\0并返回
    buf[max-1] = '\0';
    80200a98:	fd442783          	lw	a5,-44(s0)
    80200a9c:	17fd                	addi	a5,a5,-1
    80200a9e:	fd843703          	ld	a4,-40(s0)
    80200aa2:	97ba                	add	a5,a5,a4
    80200aa4:	00078023          	sb	zero,0(a5)
    return max-1;
    80200aa8:	fd442783          	lw	a5,-44(s0)
    80200aac:	37fd                	addiw	a5,a5,-1
    80200aae:	2781                	sext.w	a5,a5
    80200ab0:	853e                	mv	a0,a5
    80200ab2:	70a2                	ld	ra,40(sp)
    80200ab4:	7402                	ld	s0,32(sp)
    80200ab6:	6145                	addi	sp,sp,48
    80200ab8:	8082                	ret

0000000080200aba <flush_printf_buffer>:

extern void uart_putc(char c);

static char printf_buffer[PRINTF_BUFFER_SIZE];
static int printf_buf_pos = 0;
static void flush_printf_buffer(void) {
    80200aba:	1141                	addi	sp,sp,-16
    80200abc:	e406                	sd	ra,8(sp)
    80200abe:	e022                	sd	s0,0(sp)
    80200ac0:	0800                	addi	s0,sp,16
	if (printf_buf_pos > 0) {
    80200ac2:	00026797          	auipc	a5,0x26
    80200ac6:	79678793          	addi	a5,a5,1942 # 80227258 <printf_buf_pos>
    80200aca:	439c                	lw	a5,0(a5)
    80200acc:	02f05c63          	blez	a5,80200b04 <flush_printf_buffer+0x4a>
		printf_buffer[printf_buf_pos] = '\0'; // Null-terminate the string
    80200ad0:	00026797          	auipc	a5,0x26
    80200ad4:	78878793          	addi	a5,a5,1928 # 80227258 <printf_buf_pos>
    80200ad8:	439c                	lw	a5,0(a5)
    80200ada:	00026717          	auipc	a4,0x26
    80200ade:	6fe70713          	addi	a4,a4,1790 # 802271d8 <printf_buffer>
    80200ae2:	97ba                	add	a5,a5,a4
    80200ae4:	00078023          	sb	zero,0(a5)
		uart_puts(printf_buffer); // Send the buffer to UART
    80200ae8:	00026517          	auipc	a0,0x26
    80200aec:	6f050513          	addi	a0,a0,1776 # 802271d8 <printf_buffer>
    80200af0:	00000097          	auipc	ra,0x0
    80200af4:	ba8080e7          	jalr	-1112(ra) # 80200698 <uart_puts>
		printf_buf_pos = 0; // Reset buffer position
    80200af8:	00026797          	auipc	a5,0x26
    80200afc:	76078793          	addi	a5,a5,1888 # 80227258 <printf_buf_pos>
    80200b00:	0007a023          	sw	zero,0(a5)
	}
}
    80200b04:	0001                	nop
    80200b06:	60a2                	ld	ra,8(sp)
    80200b08:	6402                	ld	s0,0(sp)
    80200b0a:	0141                	addi	sp,sp,16
    80200b0c:	8082                	ret

0000000080200b0e <buffer_char>:
static void buffer_char(char c) {
    80200b0e:	1101                	addi	sp,sp,-32
    80200b10:	ec06                	sd	ra,24(sp)
    80200b12:	e822                	sd	s0,16(sp)
    80200b14:	1000                	addi	s0,sp,32
    80200b16:	87aa                	mv	a5,a0
    80200b18:	fef407a3          	sb	a5,-17(s0)
	if (printf_buf_pos < PRINTF_BUFFER_SIZE - 1) { // Leave space for null terminator
    80200b1c:	00026797          	auipc	a5,0x26
    80200b20:	73c78793          	addi	a5,a5,1852 # 80227258 <printf_buf_pos>
    80200b24:	439c                	lw	a5,0(a5)
    80200b26:	873e                	mv	a4,a5
    80200b28:	07e00793          	li	a5,126
    80200b2c:	02e7ca63          	blt	a5,a4,80200b60 <buffer_char+0x52>
		printf_buffer[printf_buf_pos++] = c;
    80200b30:	00026797          	auipc	a5,0x26
    80200b34:	72878793          	addi	a5,a5,1832 # 80227258 <printf_buf_pos>
    80200b38:	439c                	lw	a5,0(a5)
    80200b3a:	0017871b          	addiw	a4,a5,1
    80200b3e:	0007069b          	sext.w	a3,a4
    80200b42:	00026717          	auipc	a4,0x26
    80200b46:	71670713          	addi	a4,a4,1814 # 80227258 <printf_buf_pos>
    80200b4a:	c314                	sw	a3,0(a4)
    80200b4c:	00026717          	auipc	a4,0x26
    80200b50:	68c70713          	addi	a4,a4,1676 # 802271d8 <printf_buffer>
    80200b54:	97ba                	add	a5,a5,a4
    80200b56:	fef44703          	lbu	a4,-17(s0)
    80200b5a:	00e78023          	sb	a4,0(a5)
	} else {
		flush_printf_buffer(); // Buffer full, flush it
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
	}
}
    80200b5e:	a825                	j	80200b96 <buffer_char+0x88>
		flush_printf_buffer(); // Buffer full, flush it
    80200b60:	00000097          	auipc	ra,0x0
    80200b64:	f5a080e7          	jalr	-166(ra) # 80200aba <flush_printf_buffer>
		printf_buffer[printf_buf_pos++] = c; // Add the character after flushing
    80200b68:	00026797          	auipc	a5,0x26
    80200b6c:	6f078793          	addi	a5,a5,1776 # 80227258 <printf_buf_pos>
    80200b70:	439c                	lw	a5,0(a5)
    80200b72:	0017871b          	addiw	a4,a5,1
    80200b76:	0007069b          	sext.w	a3,a4
    80200b7a:	00026717          	auipc	a4,0x26
    80200b7e:	6de70713          	addi	a4,a4,1758 # 80227258 <printf_buf_pos>
    80200b82:	c314                	sw	a3,0(a4)
    80200b84:	00026717          	auipc	a4,0x26
    80200b88:	65470713          	addi	a4,a4,1620 # 802271d8 <printf_buffer>
    80200b8c:	97ba                	add	a5,a5,a4
    80200b8e:	fef44703          	lbu	a4,-17(s0)
    80200b92:	00e78023          	sb	a4,0(a5)
}
    80200b96:	0001                	nop
    80200b98:	60e2                	ld	ra,24(sp)
    80200b9a:	6442                	ld	s0,16(sp)
    80200b9c:	6105                	addi	sp,sp,32
    80200b9e:	8082                	ret

0000000080200ba0 <consputc>:

static void consputc(int c){
    80200ba0:	1101                	addi	sp,sp,-32
    80200ba2:	ec06                	sd	ra,24(sp)
    80200ba4:	e822                	sd	s0,16(sp)
    80200ba6:	1000                	addi	s0,sp,32
    80200ba8:	87aa                	mv	a5,a0
    80200baa:	fef42623          	sw	a5,-20(s0)
	// 实现到多个输出的处理，目前只有串口输出
	uart_putc(c);
    80200bae:	fec42783          	lw	a5,-20(s0)
    80200bb2:	0ff7f793          	zext.b	a5,a5
    80200bb6:	853e                	mv	a0,a5
    80200bb8:	00000097          	auipc	ra,0x0
    80200bbc:	aa6080e7          	jalr	-1370(ra) # 8020065e <uart_putc>
}
    80200bc0:	0001                	nop
    80200bc2:	60e2                	ld	ra,24(sp)
    80200bc4:	6442                	ld	s0,16(sp)
    80200bc6:	6105                	addi	sp,sp,32
    80200bc8:	8082                	ret

0000000080200bca <consputs>:
static void consputs(const char *s){
    80200bca:	7179                	addi	sp,sp,-48
    80200bcc:	f406                	sd	ra,40(sp)
    80200bce:	f022                	sd	s0,32(sp)
    80200bd0:	1800                	addi	s0,sp,48
    80200bd2:	fca43c23          	sd	a0,-40(s0)
	char *str = (char *)s;
    80200bd6:	fd843783          	ld	a5,-40(s0)
    80200bda:	fef43423          	sd	a5,-24(s0)
	// 直接调用uart_puts输出字符串
	uart_puts(str);
    80200bde:	fe843503          	ld	a0,-24(s0)
    80200be2:	00000097          	auipc	ra,0x0
    80200be6:	ab6080e7          	jalr	-1354(ra) # 80200698 <uart_puts>
}
    80200bea:	0001                	nop
    80200bec:	70a2                	ld	ra,40(sp)
    80200bee:	7402                	ld	s0,32(sp)
    80200bf0:	6145                	addi	sp,sp,48
    80200bf2:	8082                	ret

0000000080200bf4 <printint>:
static void printint(long long xx, int base, int sign, int width, int padzero){
    80200bf4:	7159                	addi	sp,sp,-112
    80200bf6:	f486                	sd	ra,104(sp)
    80200bf8:	f0a2                	sd	s0,96(sp)
    80200bfa:	1880                	addi	s0,sp,112
    80200bfc:	faa43423          	sd	a0,-88(s0)
    80200c00:	87ae                	mv	a5,a1
    80200c02:	faf42223          	sw	a5,-92(s0)
    80200c06:	87b2                	mv	a5,a2
    80200c08:	faf42023          	sw	a5,-96(s0)
    80200c0c:	87b6                	mv	a5,a3
    80200c0e:	f8f42e23          	sw	a5,-100(s0)
    80200c12:	87ba                	mv	a5,a4
    80200c14:	f8f42c23          	sw	a5,-104(s0)
    static char digits[] = "0123456789abcdef";
    char buf[32];
    int i = 0;
    80200c18:	fe042623          	sw	zero,-20(s0)
    unsigned long long x;

    if (sign && (sign = xx < 0))
    80200c1c:	fa042783          	lw	a5,-96(s0)
    80200c20:	2781                	sext.w	a5,a5
    80200c22:	c39d                	beqz	a5,80200c48 <printint+0x54>
    80200c24:	fa843783          	ld	a5,-88(s0)
    80200c28:	93fd                	srli	a5,a5,0x3f
    80200c2a:	0ff7f793          	zext.b	a5,a5
    80200c2e:	faf42023          	sw	a5,-96(s0)
    80200c32:	fa042783          	lw	a5,-96(s0)
    80200c36:	2781                	sext.w	a5,a5
    80200c38:	cb81                	beqz	a5,80200c48 <printint+0x54>
        x = -(unsigned long long)xx;
    80200c3a:	fa843783          	ld	a5,-88(s0)
    80200c3e:	40f007b3          	neg	a5,a5
    80200c42:	fef43023          	sd	a5,-32(s0)
    80200c46:	a029                	j	80200c50 <printint+0x5c>
    else
        x = xx;
    80200c48:	fa843783          	ld	a5,-88(s0)
    80200c4c:	fef43023          	sd	a5,-32(s0)

    do {
        buf[i++] = digits[x % base];
    80200c50:	fa442783          	lw	a5,-92(s0)
    80200c54:	fe043703          	ld	a4,-32(s0)
    80200c58:	02f77733          	remu	a4,a4,a5
    80200c5c:	fec42783          	lw	a5,-20(s0)
    80200c60:	0017869b          	addiw	a3,a5,1
    80200c64:	fed42623          	sw	a3,-20(s0)
    80200c68:	00026697          	auipc	a3,0x26
    80200c6c:	40868693          	addi	a3,a3,1032 # 80227070 <digits.0>
    80200c70:	9736                	add	a4,a4,a3
    80200c72:	00074703          	lbu	a4,0(a4)
    80200c76:	17c1                	addi	a5,a5,-16
    80200c78:	97a2                	add	a5,a5,s0
    80200c7a:	fce78423          	sb	a4,-56(a5)
    } while ((x /= base) != 0);
    80200c7e:	fa442783          	lw	a5,-92(s0)
    80200c82:	fe043703          	ld	a4,-32(s0)
    80200c86:	02f757b3          	divu	a5,a4,a5
    80200c8a:	fef43023          	sd	a5,-32(s0)
    80200c8e:	fe043783          	ld	a5,-32(s0)
    80200c92:	ffdd                	bnez	a5,80200c50 <printint+0x5c>

    if (sign)
    80200c94:	fa042783          	lw	a5,-96(s0)
    80200c98:	2781                	sext.w	a5,a5
    80200c9a:	cf89                	beqz	a5,80200cb4 <printint+0xc0>
        buf[i++] = '-';
    80200c9c:	fec42783          	lw	a5,-20(s0)
    80200ca0:	0017871b          	addiw	a4,a5,1
    80200ca4:	fee42623          	sw	a4,-20(s0)
    80200ca8:	17c1                	addi	a5,a5,-16
    80200caa:	97a2                	add	a5,a5,s0
    80200cac:	02d00713          	li	a4,45
    80200cb0:	fce78423          	sb	a4,-56(a5)

    // 计算需要补的填充字符数
    int pad = width - i;
    80200cb4:	f9c42783          	lw	a5,-100(s0)
    80200cb8:	873e                	mv	a4,a5
    80200cba:	fec42783          	lw	a5,-20(s0)
    80200cbe:	40f707bb          	subw	a5,a4,a5
    80200cc2:	fcf42e23          	sw	a5,-36(s0)
    while (pad-- > 0) {
    80200cc6:	a839                	j	80200ce4 <printint+0xf0>
        consputc(padzero ? '0' : ' ');
    80200cc8:	f9842783          	lw	a5,-104(s0)
    80200ccc:	2781                	sext.w	a5,a5
    80200cce:	c781                	beqz	a5,80200cd6 <printint+0xe2>
    80200cd0:	03000793          	li	a5,48
    80200cd4:	a019                	j	80200cda <printint+0xe6>
    80200cd6:	02000793          	li	a5,32
    80200cda:	853e                	mv	a0,a5
    80200cdc:	00000097          	auipc	ra,0x0
    80200ce0:	ec4080e7          	jalr	-316(ra) # 80200ba0 <consputc>
    while (pad-- > 0) {
    80200ce4:	fdc42783          	lw	a5,-36(s0)
    80200ce8:	fff7871b          	addiw	a4,a5,-1
    80200cec:	fce42e23          	sw	a4,-36(s0)
    80200cf0:	fcf04ce3          	bgtz	a5,80200cc8 <printint+0xd4>
    }

    while (--i >= 0)
    80200cf4:	a829                	j	80200d0e <printint+0x11a>
        consputc(buf[i]);
    80200cf6:	fec42783          	lw	a5,-20(s0)
    80200cfa:	17c1                	addi	a5,a5,-16
    80200cfc:	97a2                	add	a5,a5,s0
    80200cfe:	fc87c783          	lbu	a5,-56(a5)
    80200d02:	2781                	sext.w	a5,a5
    80200d04:	853e                	mv	a0,a5
    80200d06:	00000097          	auipc	ra,0x0
    80200d0a:	e9a080e7          	jalr	-358(ra) # 80200ba0 <consputc>
    while (--i >= 0)
    80200d0e:	fec42783          	lw	a5,-20(s0)
    80200d12:	37fd                	addiw	a5,a5,-1
    80200d14:	fef42623          	sw	a5,-20(s0)
    80200d18:	fec42783          	lw	a5,-20(s0)
    80200d1c:	2781                	sext.w	a5,a5
    80200d1e:	fc07dce3          	bgez	a5,80200cf6 <printint+0x102>
}
    80200d22:	0001                	nop
    80200d24:	0001                	nop
    80200d26:	70a6                	ld	ra,104(sp)
    80200d28:	7406                	ld	s0,96(sp)
    80200d2a:	6165                	addi	sp,sp,112
    80200d2c:	8082                	ret

0000000080200d2e <printf>:
void printf(const char *fmt, ...) {
    80200d2e:	7171                	addi	sp,sp,-176
    80200d30:	f486                	sd	ra,104(sp)
    80200d32:	f0a2                	sd	s0,96(sp)
    80200d34:	1880                	addi	s0,sp,112
    80200d36:	f8a43c23          	sd	a0,-104(s0)
    80200d3a:	e40c                	sd	a1,8(s0)
    80200d3c:	e810                	sd	a2,16(s0)
    80200d3e:	ec14                	sd	a3,24(s0)
    80200d40:	f018                	sd	a4,32(s0)
    80200d42:	f41c                	sd	a5,40(s0)
    80200d44:	03043823          	sd	a6,48(s0)
    80200d48:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    80200d4c:	04040793          	addi	a5,s0,64
    80200d50:	f8f43823          	sd	a5,-112(s0)
    80200d54:	f9043783          	ld	a5,-112(s0)
    80200d58:	fc878793          	addi	a5,a5,-56
    80200d5c:	faf43c23          	sd	a5,-72(s0)
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200d60:	fe042623          	sw	zero,-20(s0)
    80200d64:	a945                	j	80201214 <printf+0x4e6>
        if(c != '%'){
    80200d66:	fe842783          	lw	a5,-24(s0)
    80200d6a:	0007871b          	sext.w	a4,a5
    80200d6e:	02500793          	li	a5,37
    80200d72:	00f70c63          	beq	a4,a5,80200d8a <printf+0x5c>
            buffer_char(c);
    80200d76:	fe842783          	lw	a5,-24(s0)
    80200d7a:	0ff7f793          	zext.b	a5,a5
    80200d7e:	853e                	mv	a0,a5
    80200d80:	00000097          	auipc	ra,0x0
    80200d84:	d8e080e7          	jalr	-626(ra) # 80200b0e <buffer_char>
            continue;
    80200d88:	a149                	j	8020120a <printf+0x4dc>
        }
        flush_printf_buffer(); // 遇到格式化标志时，先刷新缓冲区
    80200d8a:	00000097          	auipc	ra,0x0
    80200d8e:	d30080e7          	jalr	-720(ra) # 80200aba <flush_printf_buffer>
		// 解析填充标志和宽度
        int padzero = 0, width = 0;
    80200d92:	fc042e23          	sw	zero,-36(s0)
    80200d96:	fc042c23          	sw	zero,-40(s0)
        c = fmt[++i] & 0xff;
    80200d9a:	fec42783          	lw	a5,-20(s0)
    80200d9e:	2785                	addiw	a5,a5,1
    80200da0:	fef42623          	sw	a5,-20(s0)
    80200da4:	fec42783          	lw	a5,-20(s0)
    80200da8:	f9843703          	ld	a4,-104(s0)
    80200dac:	97ba                	add	a5,a5,a4
    80200dae:	0007c783          	lbu	a5,0(a5)
    80200db2:	fef42423          	sw	a5,-24(s0)
        if (c == '0') {
    80200db6:	fe842783          	lw	a5,-24(s0)
    80200dba:	0007871b          	sext.w	a4,a5
    80200dbe:	03000793          	li	a5,48
    80200dc2:	06f71563          	bne	a4,a5,80200e2c <printf+0xfe>
            padzero = 1;
    80200dc6:	4785                	li	a5,1
    80200dc8:	fcf42e23          	sw	a5,-36(s0)
            c = fmt[++i] & 0xff;
    80200dcc:	fec42783          	lw	a5,-20(s0)
    80200dd0:	2785                	addiw	a5,a5,1
    80200dd2:	fef42623          	sw	a5,-20(s0)
    80200dd6:	fec42783          	lw	a5,-20(s0)
    80200dda:	f9843703          	ld	a4,-104(s0)
    80200dde:	97ba                	add	a5,a5,a4
    80200de0:	0007c783          	lbu	a5,0(a5)
    80200de4:	fef42423          	sw	a5,-24(s0)
        }
        while (c >= '0' && c <= '9') {
    80200de8:	a091                	j	80200e2c <printf+0xfe>
            width = width * 10 + (c - '0');
    80200dea:	fd842783          	lw	a5,-40(s0)
    80200dee:	873e                	mv	a4,a5
    80200df0:	87ba                	mv	a5,a4
    80200df2:	0027979b          	slliw	a5,a5,0x2
    80200df6:	9fb9                	addw	a5,a5,a4
    80200df8:	0017979b          	slliw	a5,a5,0x1
    80200dfc:	0007871b          	sext.w	a4,a5
    80200e00:	fe842783          	lw	a5,-24(s0)
    80200e04:	fd07879b          	addiw	a5,a5,-48
    80200e08:	2781                	sext.w	a5,a5
    80200e0a:	9fb9                	addw	a5,a5,a4
    80200e0c:	fcf42c23          	sw	a5,-40(s0)
            c = fmt[++i] & 0xff;
    80200e10:	fec42783          	lw	a5,-20(s0)
    80200e14:	2785                	addiw	a5,a5,1
    80200e16:	fef42623          	sw	a5,-20(s0)
    80200e1a:	fec42783          	lw	a5,-20(s0)
    80200e1e:	f9843703          	ld	a4,-104(s0)
    80200e22:	97ba                	add	a5,a5,a4
    80200e24:	0007c783          	lbu	a5,0(a5)
    80200e28:	fef42423          	sw	a5,-24(s0)
        while (c >= '0' && c <= '9') {
    80200e2c:	fe842783          	lw	a5,-24(s0)
    80200e30:	0007871b          	sext.w	a4,a5
    80200e34:	02f00793          	li	a5,47
    80200e38:	00e7da63          	bge	a5,a4,80200e4c <printf+0x11e>
    80200e3c:	fe842783          	lw	a5,-24(s0)
    80200e40:	0007871b          	sext.w	a4,a5
    80200e44:	03900793          	li	a5,57
    80200e48:	fae7d1e3          	bge	a5,a4,80200dea <printf+0xbc>
        }
        // 检查是否有长整型标记'l'
        int is_long = 0;
    80200e4c:	fc042a23          	sw	zero,-44(s0)
        if(c == 'l') {
    80200e50:	fe842783          	lw	a5,-24(s0)
    80200e54:	0007871b          	sext.w	a4,a5
    80200e58:	06c00793          	li	a5,108
    80200e5c:	02f71863          	bne	a4,a5,80200e8c <printf+0x15e>
            is_long = 1;
    80200e60:	4785                	li	a5,1
    80200e62:	fcf42a23          	sw	a5,-44(s0)
            c = fmt[++i] & 0xff;
    80200e66:	fec42783          	lw	a5,-20(s0)
    80200e6a:	2785                	addiw	a5,a5,1
    80200e6c:	fef42623          	sw	a5,-20(s0)
    80200e70:	fec42783          	lw	a5,-20(s0)
    80200e74:	f9843703          	ld	a4,-104(s0)
    80200e78:	97ba                	add	a5,a5,a4
    80200e7a:	0007c783          	lbu	a5,0(a5)
    80200e7e:	fef42423          	sw	a5,-24(s0)
            if(c == 0)
    80200e82:	fe842783          	lw	a5,-24(s0)
    80200e86:	2781                	sext.w	a5,a5
    80200e88:	3a078563          	beqz	a5,80201232 <printf+0x504>
                break;
        }
        
        switch(c){
    80200e8c:	fe842783          	lw	a5,-24(s0)
    80200e90:	0007871b          	sext.w	a4,a5
    80200e94:	02500793          	li	a5,37
    80200e98:	2ef70d63          	beq	a4,a5,80201192 <printf+0x464>
    80200e9c:	fe842783          	lw	a5,-24(s0)
    80200ea0:	0007871b          	sext.w	a4,a5
    80200ea4:	02500793          	li	a5,37
    80200ea8:	2ef74c63          	blt	a4,a5,802011a0 <printf+0x472>
    80200eac:	fe842783          	lw	a5,-24(s0)
    80200eb0:	0007871b          	sext.w	a4,a5
    80200eb4:	07800793          	li	a5,120
    80200eb8:	2ee7c463          	blt	a5,a4,802011a0 <printf+0x472>
    80200ebc:	fe842783          	lw	a5,-24(s0)
    80200ec0:	0007871b          	sext.w	a4,a5
    80200ec4:	06200793          	li	a5,98
    80200ec8:	2cf74c63          	blt	a4,a5,802011a0 <printf+0x472>
    80200ecc:	fe842783          	lw	a5,-24(s0)
    80200ed0:	f9e7869b          	addiw	a3,a5,-98
    80200ed4:	0006871b          	sext.w	a4,a3
    80200ed8:	47d9                	li	a5,22
    80200eda:	2ce7e363          	bltu	a5,a4,802011a0 <printf+0x472>
    80200ede:	02069793          	slli	a5,a3,0x20
    80200ee2:	9381                	srli	a5,a5,0x20
    80200ee4:	00279713          	slli	a4,a5,0x2
    80200ee8:	0000e797          	auipc	a5,0xe
    80200eec:	86c78793          	addi	a5,a5,-1940 # 8020e754 <user_test_table+0x84>
    80200ef0:	97ba                	add	a5,a5,a4
    80200ef2:	439c                	lw	a5,0(a5)
    80200ef4:	0007871b          	sext.w	a4,a5
    80200ef8:	0000e797          	auipc	a5,0xe
    80200efc:	85c78793          	addi	a5,a5,-1956 # 8020e754 <user_test_table+0x84>
    80200f00:	97ba                	add	a5,a5,a4
    80200f02:	8782                	jr	a5
        case 'd':
            if(is_long)
    80200f04:	fd442783          	lw	a5,-44(s0)
    80200f08:	2781                	sext.w	a5,a5
    80200f0a:	c785                	beqz	a5,80200f32 <printf+0x204>
                printint(va_arg(ap, long long), 10, 1, width, padzero);
    80200f0c:	fb843783          	ld	a5,-72(s0)
    80200f10:	00878713          	addi	a4,a5,8
    80200f14:	fae43c23          	sd	a4,-72(s0)
    80200f18:	639c                	ld	a5,0(a5)
    80200f1a:	fdc42703          	lw	a4,-36(s0)
    80200f1e:	fd842683          	lw	a3,-40(s0)
    80200f22:	4605                	li	a2,1
    80200f24:	45a9                	li	a1,10
    80200f26:	853e                	mv	a0,a5
    80200f28:	00000097          	auipc	ra,0x0
    80200f2c:	ccc080e7          	jalr	-820(ra) # 80200bf4 <printint>
            else
                printint(va_arg(ap, int), 10, 1, width, padzero);
            break;
    80200f30:	ace9                	j	8020120a <printf+0x4dc>
                printint(va_arg(ap, int), 10, 1, width, padzero);
    80200f32:	fb843783          	ld	a5,-72(s0)
    80200f36:	00878713          	addi	a4,a5,8
    80200f3a:	fae43c23          	sd	a4,-72(s0)
    80200f3e:	439c                	lw	a5,0(a5)
    80200f40:	853e                	mv	a0,a5
    80200f42:	fdc42703          	lw	a4,-36(s0)
    80200f46:	fd842783          	lw	a5,-40(s0)
    80200f4a:	86be                	mv	a3,a5
    80200f4c:	4605                	li	a2,1
    80200f4e:	45a9                	li	a1,10
    80200f50:	00000097          	auipc	ra,0x0
    80200f54:	ca4080e7          	jalr	-860(ra) # 80200bf4 <printint>
            break;
    80200f58:	ac4d                	j	8020120a <printf+0x4dc>
        case 'x':
            if(is_long)
    80200f5a:	fd442783          	lw	a5,-44(s0)
    80200f5e:	2781                	sext.w	a5,a5
    80200f60:	c785                	beqz	a5,80200f88 <printf+0x25a>
                printint(va_arg(ap, long long), 16, 0, width, padzero);
    80200f62:	fb843783          	ld	a5,-72(s0)
    80200f66:	00878713          	addi	a4,a5,8
    80200f6a:	fae43c23          	sd	a4,-72(s0)
    80200f6e:	639c                	ld	a5,0(a5)
    80200f70:	fdc42703          	lw	a4,-36(s0)
    80200f74:	fd842683          	lw	a3,-40(s0)
    80200f78:	4601                	li	a2,0
    80200f7a:	45c1                	li	a1,16
    80200f7c:	853e                	mv	a0,a5
    80200f7e:	00000097          	auipc	ra,0x0
    80200f82:	c76080e7          	jalr	-906(ra) # 80200bf4 <printint>
            else
                printint(va_arg(ap, int), 16, 0, width, padzero);
            break;
    80200f86:	a451                	j	8020120a <printf+0x4dc>
                printint(va_arg(ap, int), 16, 0, width, padzero);
    80200f88:	fb843783          	ld	a5,-72(s0)
    80200f8c:	00878713          	addi	a4,a5,8
    80200f90:	fae43c23          	sd	a4,-72(s0)
    80200f94:	439c                	lw	a5,0(a5)
    80200f96:	853e                	mv	a0,a5
    80200f98:	fdc42703          	lw	a4,-36(s0)
    80200f9c:	fd842783          	lw	a5,-40(s0)
    80200fa0:	86be                	mv	a3,a5
    80200fa2:	4601                	li	a2,0
    80200fa4:	45c1                	li	a1,16
    80200fa6:	00000097          	auipc	ra,0x0
    80200faa:	c4e080e7          	jalr	-946(ra) # 80200bf4 <printint>
            break;
    80200fae:	acb1                	j	8020120a <printf+0x4dc>
        case 'u':
            if(is_long)
    80200fb0:	fd442783          	lw	a5,-44(s0)
    80200fb4:	2781                	sext.w	a5,a5
    80200fb6:	c78d                	beqz	a5,80200fe0 <printf+0x2b2>
                printint(va_arg(ap, unsigned long long), 10, 0, width, padzero);
    80200fb8:	fb843783          	ld	a5,-72(s0)
    80200fbc:	00878713          	addi	a4,a5,8
    80200fc0:	fae43c23          	sd	a4,-72(s0)
    80200fc4:	639c                	ld	a5,0(a5)
    80200fc6:	853e                	mv	a0,a5
    80200fc8:	fdc42703          	lw	a4,-36(s0)
    80200fcc:	fd842783          	lw	a5,-40(s0)
    80200fd0:	86be                	mv	a3,a5
    80200fd2:	4601                	li	a2,0
    80200fd4:	45a9                	li	a1,10
    80200fd6:	00000097          	auipc	ra,0x0
    80200fda:	c1e080e7          	jalr	-994(ra) # 80200bf4 <printint>
            else
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
            break;
    80200fde:	a435                	j	8020120a <printf+0x4dc>
                printint(va_arg(ap, unsigned int), 10, 0, width, padzero);
    80200fe0:	fb843783          	ld	a5,-72(s0)
    80200fe4:	00878713          	addi	a4,a5,8
    80200fe8:	fae43c23          	sd	a4,-72(s0)
    80200fec:	439c                	lw	a5,0(a5)
    80200fee:	1782                	slli	a5,a5,0x20
    80200ff0:	9381                	srli	a5,a5,0x20
    80200ff2:	fdc42703          	lw	a4,-36(s0)
    80200ff6:	fd842683          	lw	a3,-40(s0)
    80200ffa:	4601                	li	a2,0
    80200ffc:	45a9                	li	a1,10
    80200ffe:	853e                	mv	a0,a5
    80201000:	00000097          	auipc	ra,0x0
    80201004:	bf4080e7          	jalr	-1036(ra) # 80200bf4 <printint>
            break;
    80201008:	a409                	j	8020120a <printf+0x4dc>
        case 'c':
            consputc(va_arg(ap, int));
    8020100a:	fb843783          	ld	a5,-72(s0)
    8020100e:	00878713          	addi	a4,a5,8
    80201012:	fae43c23          	sd	a4,-72(s0)
    80201016:	439c                	lw	a5,0(a5)
    80201018:	853e                	mv	a0,a5
    8020101a:	00000097          	auipc	ra,0x0
    8020101e:	b86080e7          	jalr	-1146(ra) # 80200ba0 <consputc>
            break;
    80201022:	a2e5                	j	8020120a <printf+0x4dc>
        case 's':
            if((s = va_arg(ap, char*)) == 0)
    80201024:	fb843783          	ld	a5,-72(s0)
    80201028:	00878713          	addi	a4,a5,8
    8020102c:	fae43c23          	sd	a4,-72(s0)
    80201030:	639c                	ld	a5,0(a5)
    80201032:	fef43023          	sd	a5,-32(s0)
    80201036:	fe043783          	ld	a5,-32(s0)
    8020103a:	e799                	bnez	a5,80201048 <printf+0x31a>
                s = "(null)";
    8020103c:	0000d797          	auipc	a5,0xd
    80201040:	6f478793          	addi	a5,a5,1780 # 8020e730 <user_test_table+0x60>
    80201044:	fef43023          	sd	a5,-32(s0)
            consputs(s);
    80201048:	fe043503          	ld	a0,-32(s0)
    8020104c:	00000097          	auipc	ra,0x0
    80201050:	b7e080e7          	jalr	-1154(ra) # 80200bca <consputs>
            break;
    80201054:	aa5d                	j	8020120a <printf+0x4dc>
        case 'p':
            unsigned long ptr = (unsigned long)va_arg(ap, void*);
    80201056:	fb843783          	ld	a5,-72(s0)
    8020105a:	00878713          	addi	a4,a5,8
    8020105e:	fae43c23          	sd	a4,-72(s0)
    80201062:	639c                	ld	a5,0(a5)
    80201064:	fcf43423          	sd	a5,-56(s0)
            consputs("0x");
    80201068:	0000d517          	auipc	a0,0xd
    8020106c:	6d050513          	addi	a0,a0,1744 # 8020e738 <user_test_table+0x68>
    80201070:	00000097          	auipc	ra,0x0
    80201074:	b5a080e7          	jalr	-1190(ra) # 80200bca <consputs>
            // 输出16位宽，不足补0
            char buf[17];
            int i;
            for (i = 0; i < 16; i++) {
    80201078:	fc042823          	sw	zero,-48(s0)
    8020107c:	a0a1                	j	802010c4 <printf+0x396>
                int shift = (15 - i) * 4;
    8020107e:	47bd                	li	a5,15
    80201080:	fd042703          	lw	a4,-48(s0)
    80201084:	9f99                	subw	a5,a5,a4
    80201086:	2781                	sext.w	a5,a5
    80201088:	0027979b          	slliw	a5,a5,0x2
    8020108c:	fcf42223          	sw	a5,-60(s0)
                buf[i] = "0123456789abcdef"[(ptr >> shift) & 0xf];
    80201090:	fc442783          	lw	a5,-60(s0)
    80201094:	873e                	mv	a4,a5
    80201096:	fc843783          	ld	a5,-56(s0)
    8020109a:	00e7d7b3          	srl	a5,a5,a4
    8020109e:	8bbd                	andi	a5,a5,15
    802010a0:	0000d717          	auipc	a4,0xd
    802010a4:	6a070713          	addi	a4,a4,1696 # 8020e740 <user_test_table+0x70>
    802010a8:	97ba                	add	a5,a5,a4
    802010aa:	0007c703          	lbu	a4,0(a5)
    802010ae:	fd042783          	lw	a5,-48(s0)
    802010b2:	17c1                	addi	a5,a5,-16
    802010b4:	97a2                	add	a5,a5,s0
    802010b6:	fae78823          	sb	a4,-80(a5)
            for (i = 0; i < 16; i++) {
    802010ba:	fd042783          	lw	a5,-48(s0)
    802010be:	2785                	addiw	a5,a5,1
    802010c0:	fcf42823          	sw	a5,-48(s0)
    802010c4:	fd042783          	lw	a5,-48(s0)
    802010c8:	0007871b          	sext.w	a4,a5
    802010cc:	47bd                	li	a5,15
    802010ce:	fae7d8e3          	bge	a5,a4,8020107e <printf+0x350>
            }
            buf[16] = '\0';
    802010d2:	fa040823          	sb	zero,-80(s0)
            consputs(buf);
    802010d6:	fa040793          	addi	a5,s0,-96
    802010da:	853e                	mv	a0,a5
    802010dc:	00000097          	auipc	ra,0x0
    802010e0:	aee080e7          	jalr	-1298(ra) # 80200bca <consputs>
            break;
    802010e4:	a21d                	j	8020120a <printf+0x4dc>
        case 'b':
            if(is_long)
    802010e6:	fd442783          	lw	a5,-44(s0)
    802010ea:	2781                	sext.w	a5,a5
    802010ec:	c785                	beqz	a5,80201114 <printf+0x3e6>
                printint(va_arg(ap, long long), 2, 0, width, padzero);
    802010ee:	fb843783          	ld	a5,-72(s0)
    802010f2:	00878713          	addi	a4,a5,8
    802010f6:	fae43c23          	sd	a4,-72(s0)
    802010fa:	639c                	ld	a5,0(a5)
    802010fc:	fdc42703          	lw	a4,-36(s0)
    80201100:	fd842683          	lw	a3,-40(s0)
    80201104:	4601                	li	a2,0
    80201106:	4589                	li	a1,2
    80201108:	853e                	mv	a0,a5
    8020110a:	00000097          	auipc	ra,0x0
    8020110e:	aea080e7          	jalr	-1302(ra) # 80200bf4 <printint>
            else
                printint(va_arg(ap, int), 2, 0, width, padzero);
            break;
    80201112:	a8e5                	j	8020120a <printf+0x4dc>
                printint(va_arg(ap, int), 2, 0, width, padzero);
    80201114:	fb843783          	ld	a5,-72(s0)
    80201118:	00878713          	addi	a4,a5,8
    8020111c:	fae43c23          	sd	a4,-72(s0)
    80201120:	439c                	lw	a5,0(a5)
    80201122:	853e                	mv	a0,a5
    80201124:	fdc42703          	lw	a4,-36(s0)
    80201128:	fd842783          	lw	a5,-40(s0)
    8020112c:	86be                	mv	a3,a5
    8020112e:	4601                	li	a2,0
    80201130:	4589                	li	a1,2
    80201132:	00000097          	auipc	ra,0x0
    80201136:	ac2080e7          	jalr	-1342(ra) # 80200bf4 <printint>
            break;
    8020113a:	a8c1                	j	8020120a <printf+0x4dc>
        case 'o':
            if(is_long)
    8020113c:	fd442783          	lw	a5,-44(s0)
    80201140:	2781                	sext.w	a5,a5
    80201142:	c785                	beqz	a5,8020116a <printf+0x43c>
                printint(va_arg(ap, long long), 8, 0, width, padzero);
    80201144:	fb843783          	ld	a5,-72(s0)
    80201148:	00878713          	addi	a4,a5,8
    8020114c:	fae43c23          	sd	a4,-72(s0)
    80201150:	639c                	ld	a5,0(a5)
    80201152:	fdc42703          	lw	a4,-36(s0)
    80201156:	fd842683          	lw	a3,-40(s0)
    8020115a:	4601                	li	a2,0
    8020115c:	45a1                	li	a1,8
    8020115e:	853e                	mv	a0,a5
    80201160:	00000097          	auipc	ra,0x0
    80201164:	a94080e7          	jalr	-1388(ra) # 80200bf4 <printint>
            else
                printint(va_arg(ap, int), 8, 0, width, padzero);
            break;
    80201168:	a04d                	j	8020120a <printf+0x4dc>
                printint(va_arg(ap, int), 8, 0, width, padzero);
    8020116a:	fb843783          	ld	a5,-72(s0)
    8020116e:	00878713          	addi	a4,a5,8
    80201172:	fae43c23          	sd	a4,-72(s0)
    80201176:	439c                	lw	a5,0(a5)
    80201178:	853e                	mv	a0,a5
    8020117a:	fdc42703          	lw	a4,-36(s0)
    8020117e:	fd842783          	lw	a5,-40(s0)
    80201182:	86be                	mv	a3,a5
    80201184:	4601                	li	a2,0
    80201186:	45a1                	li	a1,8
    80201188:	00000097          	auipc	ra,0x0
    8020118c:	a6c080e7          	jalr	-1428(ra) # 80200bf4 <printint>
            break;
    80201190:	a8ad                	j	8020120a <printf+0x4dc>
        case '%':
            buffer_char('%');
    80201192:	02500513          	li	a0,37
    80201196:	00000097          	auipc	ra,0x0
    8020119a:	978080e7          	jalr	-1672(ra) # 80200b0e <buffer_char>
            break;
    8020119e:	a0b5                	j	8020120a <printf+0x4dc>
        default:
            buffer_char('%');
    802011a0:	02500513          	li	a0,37
    802011a4:	00000097          	auipc	ra,0x0
    802011a8:	96a080e7          	jalr	-1686(ra) # 80200b0e <buffer_char>
            if(padzero) buffer_char('0');
    802011ac:	fdc42783          	lw	a5,-36(s0)
    802011b0:	2781                	sext.w	a5,a5
    802011b2:	c799                	beqz	a5,802011c0 <printf+0x492>
    802011b4:	03000513          	li	a0,48
    802011b8:	00000097          	auipc	ra,0x0
    802011bc:	956080e7          	jalr	-1706(ra) # 80200b0e <buffer_char>
            if(width) {
    802011c0:	fd842783          	lw	a5,-40(s0)
    802011c4:	2781                	sext.w	a5,a5
    802011c6:	cf91                	beqz	a5,802011e2 <printf+0x4b4>
                // 只支持一位宽度，简单处理
                buffer_char('0' + width);
    802011c8:	fd842783          	lw	a5,-40(s0)
    802011cc:	0ff7f793          	zext.b	a5,a5
    802011d0:	0307879b          	addiw	a5,a5,48
    802011d4:	0ff7f793          	zext.b	a5,a5
    802011d8:	853e                	mv	a0,a5
    802011da:	00000097          	auipc	ra,0x0
    802011de:	934080e7          	jalr	-1740(ra) # 80200b0e <buffer_char>
            }
            if(is_long) buffer_char('l');
    802011e2:	fd442783          	lw	a5,-44(s0)
    802011e6:	2781                	sext.w	a5,a5
    802011e8:	c799                	beqz	a5,802011f6 <printf+0x4c8>
    802011ea:	06c00513          	li	a0,108
    802011ee:	00000097          	auipc	ra,0x0
    802011f2:	920080e7          	jalr	-1760(ra) # 80200b0e <buffer_char>
            buffer_char(c);
    802011f6:	fe842783          	lw	a5,-24(s0)
    802011fa:	0ff7f793          	zext.b	a5,a5
    802011fe:	853e                	mv	a0,a5
    80201200:	00000097          	auipc	ra,0x0
    80201204:	90e080e7          	jalr	-1778(ra) # 80200b0e <buffer_char>
            break;
    80201208:	0001                	nop
    for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8020120a:	fec42783          	lw	a5,-20(s0)
    8020120e:	2785                	addiw	a5,a5,1
    80201210:	fef42623          	sw	a5,-20(s0)
    80201214:	fec42783          	lw	a5,-20(s0)
    80201218:	f9843703          	ld	a4,-104(s0)
    8020121c:	97ba                	add	a5,a5,a4
    8020121e:	0007c783          	lbu	a5,0(a5)
    80201222:	fef42423          	sw	a5,-24(s0)
    80201226:	fe842783          	lw	a5,-24(s0)
    8020122a:	2781                	sext.w	a5,a5
    8020122c:	b2079de3          	bnez	a5,80200d66 <printf+0x38>
    80201230:	a011                	j	80201234 <printf+0x506>
                break;
    80201232:	0001                	nop
        }
    }
    flush_printf_buffer(); // 最后刷新缓冲区
    80201234:	00000097          	auipc	ra,0x0
    80201238:	886080e7          	jalr	-1914(ra) # 80200aba <flush_printf_buffer>
    va_end(ap);
}
    8020123c:	0001                	nop
    8020123e:	70a6                	ld	ra,104(sp)
    80201240:	7406                	ld	s0,96(sp)
    80201242:	614d                	addi	sp,sp,176
    80201244:	8082                	ret

0000000080201246 <clear_screen>:
// 清屏功能
void clear_screen(void) {
    80201246:	1141                	addi	sp,sp,-16
    80201248:	e406                	sd	ra,8(sp)
    8020124a:	e022                	sd	s0,0(sp)
    8020124c:	0800                	addi	s0,sp,16
    uart_puts(CLEAR_SCREEN);
    8020124e:	0000d517          	auipc	a0,0xd
    80201252:	56250513          	addi	a0,a0,1378 # 8020e7b0 <user_test_table+0xe0>
    80201256:	fffff097          	auipc	ra,0xfffff
    8020125a:	442080e7          	jalr	1090(ra) # 80200698 <uart_puts>
	uart_puts(CURSOR_HOME);
    8020125e:	0000d517          	auipc	a0,0xd
    80201262:	55a50513          	addi	a0,a0,1370 # 8020e7b8 <user_test_table+0xe8>
    80201266:	fffff097          	auipc	ra,0xfffff
    8020126a:	432080e7          	jalr	1074(ra) # 80200698 <uart_puts>
}
    8020126e:	0001                	nop
    80201270:	60a2                	ld	ra,8(sp)
    80201272:	6402                	ld	s0,0(sp)
    80201274:	0141                	addi	sp,sp,16
    80201276:	8082                	ret

0000000080201278 <cursor_up>:

// 光标上移
void cursor_up(int lines) {
    80201278:	1101                	addi	sp,sp,-32
    8020127a:	ec06                	sd	ra,24(sp)
    8020127c:	e822                	sd	s0,16(sp)
    8020127e:	1000                	addi	s0,sp,32
    80201280:	87aa                	mv	a5,a0
    80201282:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    80201286:	fec42783          	lw	a5,-20(s0)
    8020128a:	2781                	sext.w	a5,a5
    8020128c:	02f05f63          	blez	a5,802012ca <cursor_up+0x52>
    consputc('\033');
    80201290:	456d                	li	a0,27
    80201292:	00000097          	auipc	ra,0x0
    80201296:	90e080e7          	jalr	-1778(ra) # 80200ba0 <consputc>
    consputc('[');
    8020129a:	05b00513          	li	a0,91
    8020129e:	00000097          	auipc	ra,0x0
    802012a2:	902080e7          	jalr	-1790(ra) # 80200ba0 <consputc>
    printint(lines, 10, 0, 0,0);
    802012a6:	fec42783          	lw	a5,-20(s0)
    802012aa:	4701                	li	a4,0
    802012ac:	4681                	li	a3,0
    802012ae:	4601                	li	a2,0
    802012b0:	45a9                	li	a1,10
    802012b2:	853e                	mv	a0,a5
    802012b4:	00000097          	auipc	ra,0x0
    802012b8:	940080e7          	jalr	-1728(ra) # 80200bf4 <printint>
    consputc('A');
    802012bc:	04100513          	li	a0,65
    802012c0:	00000097          	auipc	ra,0x0
    802012c4:	8e0080e7          	jalr	-1824(ra) # 80200ba0 <consputc>
    802012c8:	a011                	j	802012cc <cursor_up+0x54>
    if (lines <= 0) return;
    802012ca:	0001                	nop
}
    802012cc:	60e2                	ld	ra,24(sp)
    802012ce:	6442                	ld	s0,16(sp)
    802012d0:	6105                	addi	sp,sp,32
    802012d2:	8082                	ret

00000000802012d4 <cursor_down>:

// 光标下移
void cursor_down(int lines) {
    802012d4:	1101                	addi	sp,sp,-32
    802012d6:	ec06                	sd	ra,24(sp)
    802012d8:	e822                	sd	s0,16(sp)
    802012da:	1000                	addi	s0,sp,32
    802012dc:	87aa                	mv	a5,a0
    802012de:	fef42623          	sw	a5,-20(s0)
    if (lines <= 0) return;
    802012e2:	fec42783          	lw	a5,-20(s0)
    802012e6:	2781                	sext.w	a5,a5
    802012e8:	02f05f63          	blez	a5,80201326 <cursor_down+0x52>
    consputc('\033');
    802012ec:	456d                	li	a0,27
    802012ee:	00000097          	auipc	ra,0x0
    802012f2:	8b2080e7          	jalr	-1870(ra) # 80200ba0 <consputc>
    consputc('[');
    802012f6:	05b00513          	li	a0,91
    802012fa:	00000097          	auipc	ra,0x0
    802012fe:	8a6080e7          	jalr	-1882(ra) # 80200ba0 <consputc>
    printint(lines, 10, 0, 0,0);
    80201302:	fec42783          	lw	a5,-20(s0)
    80201306:	4701                	li	a4,0
    80201308:	4681                	li	a3,0
    8020130a:	4601                	li	a2,0
    8020130c:	45a9                	li	a1,10
    8020130e:	853e                	mv	a0,a5
    80201310:	00000097          	auipc	ra,0x0
    80201314:	8e4080e7          	jalr	-1820(ra) # 80200bf4 <printint>
    consputc('B');
    80201318:	04200513          	li	a0,66
    8020131c:	00000097          	auipc	ra,0x0
    80201320:	884080e7          	jalr	-1916(ra) # 80200ba0 <consputc>
    80201324:	a011                	j	80201328 <cursor_down+0x54>
    if (lines <= 0) return;
    80201326:	0001                	nop
}
    80201328:	60e2                	ld	ra,24(sp)
    8020132a:	6442                	ld	s0,16(sp)
    8020132c:	6105                	addi	sp,sp,32
    8020132e:	8082                	ret

0000000080201330 <cursor_right>:

// 光标右移
void cursor_right(int cols) {
    80201330:	1101                	addi	sp,sp,-32
    80201332:	ec06                	sd	ra,24(sp)
    80201334:	e822                	sd	s0,16(sp)
    80201336:	1000                	addi	s0,sp,32
    80201338:	87aa                	mv	a5,a0
    8020133a:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    8020133e:	fec42783          	lw	a5,-20(s0)
    80201342:	2781                	sext.w	a5,a5
    80201344:	02f05f63          	blez	a5,80201382 <cursor_right+0x52>
    consputc('\033');
    80201348:	456d                	li	a0,27
    8020134a:	00000097          	auipc	ra,0x0
    8020134e:	856080e7          	jalr	-1962(ra) # 80200ba0 <consputc>
    consputc('[');
    80201352:	05b00513          	li	a0,91
    80201356:	00000097          	auipc	ra,0x0
    8020135a:	84a080e7          	jalr	-1974(ra) # 80200ba0 <consputc>
    printint(cols, 10, 0,0,0);
    8020135e:	fec42783          	lw	a5,-20(s0)
    80201362:	4701                	li	a4,0
    80201364:	4681                	li	a3,0
    80201366:	4601                	li	a2,0
    80201368:	45a9                	li	a1,10
    8020136a:	853e                	mv	a0,a5
    8020136c:	00000097          	auipc	ra,0x0
    80201370:	888080e7          	jalr	-1912(ra) # 80200bf4 <printint>
    consputc('C');
    80201374:	04300513          	li	a0,67
    80201378:	00000097          	auipc	ra,0x0
    8020137c:	828080e7          	jalr	-2008(ra) # 80200ba0 <consputc>
    80201380:	a011                	j	80201384 <cursor_right+0x54>
    if (cols <= 0) return;
    80201382:	0001                	nop
}
    80201384:	60e2                	ld	ra,24(sp)
    80201386:	6442                	ld	s0,16(sp)
    80201388:	6105                	addi	sp,sp,32
    8020138a:	8082                	ret

000000008020138c <cursor_left>:

// 光标左移
void cursor_left(int cols) {
    8020138c:	1101                	addi	sp,sp,-32
    8020138e:	ec06                	sd	ra,24(sp)
    80201390:	e822                	sd	s0,16(sp)
    80201392:	1000                	addi	s0,sp,32
    80201394:	87aa                	mv	a5,a0
    80201396:	fef42623          	sw	a5,-20(s0)
    if (cols <= 0) return;
    8020139a:	fec42783          	lw	a5,-20(s0)
    8020139e:	2781                	sext.w	a5,a5
    802013a0:	02f05f63          	blez	a5,802013de <cursor_left+0x52>
    consputc('\033');
    802013a4:	456d                	li	a0,27
    802013a6:	fffff097          	auipc	ra,0xfffff
    802013aa:	7fa080e7          	jalr	2042(ra) # 80200ba0 <consputc>
    consputc('[');
    802013ae:	05b00513          	li	a0,91
    802013b2:	fffff097          	auipc	ra,0xfffff
    802013b6:	7ee080e7          	jalr	2030(ra) # 80200ba0 <consputc>
    printint(cols, 10, 0,0,0);
    802013ba:	fec42783          	lw	a5,-20(s0)
    802013be:	4701                	li	a4,0
    802013c0:	4681                	li	a3,0
    802013c2:	4601                	li	a2,0
    802013c4:	45a9                	li	a1,10
    802013c6:	853e                	mv	a0,a5
    802013c8:	00000097          	auipc	ra,0x0
    802013cc:	82c080e7          	jalr	-2004(ra) # 80200bf4 <printint>
    consputc('D');
    802013d0:	04400513          	li	a0,68
    802013d4:	fffff097          	auipc	ra,0xfffff
    802013d8:	7cc080e7          	jalr	1996(ra) # 80200ba0 <consputc>
    802013dc:	a011                	j	802013e0 <cursor_left+0x54>
    if (cols <= 0) return;
    802013de:	0001                	nop
}
    802013e0:	60e2                	ld	ra,24(sp)
    802013e2:	6442                	ld	s0,16(sp)
    802013e4:	6105                	addi	sp,sp,32
    802013e6:	8082                	ret

00000000802013e8 <save_cursor>:
// 保存光标位置
void save_cursor(void) {
    802013e8:	1141                	addi	sp,sp,-16
    802013ea:	e406                	sd	ra,8(sp)
    802013ec:	e022                	sd	s0,0(sp)
    802013ee:	0800                	addi	s0,sp,16
    consputc('\033');
    802013f0:	456d                	li	a0,27
    802013f2:	fffff097          	auipc	ra,0xfffff
    802013f6:	7ae080e7          	jalr	1966(ra) # 80200ba0 <consputc>
    consputc('[');
    802013fa:	05b00513          	li	a0,91
    802013fe:	fffff097          	auipc	ra,0xfffff
    80201402:	7a2080e7          	jalr	1954(ra) # 80200ba0 <consputc>
    consputc('s');
    80201406:	07300513          	li	a0,115
    8020140a:	fffff097          	auipc	ra,0xfffff
    8020140e:	796080e7          	jalr	1942(ra) # 80200ba0 <consputc>
}
    80201412:	0001                	nop
    80201414:	60a2                	ld	ra,8(sp)
    80201416:	6402                	ld	s0,0(sp)
    80201418:	0141                	addi	sp,sp,16
    8020141a:	8082                	ret

000000008020141c <restore_cursor>:

// 恢复光标位置
void restore_cursor(void) {
    8020141c:	1141                	addi	sp,sp,-16
    8020141e:	e406                	sd	ra,8(sp)
    80201420:	e022                	sd	s0,0(sp)
    80201422:	0800                	addi	s0,sp,16
    consputc('\033');
    80201424:	456d                	li	a0,27
    80201426:	fffff097          	auipc	ra,0xfffff
    8020142a:	77a080e7          	jalr	1914(ra) # 80200ba0 <consputc>
    consputc('[');
    8020142e:	05b00513          	li	a0,91
    80201432:	fffff097          	auipc	ra,0xfffff
    80201436:	76e080e7          	jalr	1902(ra) # 80200ba0 <consputc>
    consputc('u');
    8020143a:	07500513          	li	a0,117
    8020143e:	fffff097          	auipc	ra,0xfffff
    80201442:	762080e7          	jalr	1890(ra) # 80200ba0 <consputc>
}
    80201446:	0001                	nop
    80201448:	60a2                	ld	ra,8(sp)
    8020144a:	6402                	ld	s0,0(sp)
    8020144c:	0141                	addi	sp,sp,16
    8020144e:	8082                	ret

0000000080201450 <cursor_to_column>:

// 移动到行首
void cursor_to_column(int col) {
    80201450:	1101                	addi	sp,sp,-32
    80201452:	ec06                	sd	ra,24(sp)
    80201454:	e822                	sd	s0,16(sp)
    80201456:	1000                	addi	s0,sp,32
    80201458:	87aa                	mv	a5,a0
    8020145a:	fef42623          	sw	a5,-20(s0)
    if (col <= 0) col = 1;
    8020145e:	fec42783          	lw	a5,-20(s0)
    80201462:	2781                	sext.w	a5,a5
    80201464:	00f04563          	bgtz	a5,8020146e <cursor_to_column+0x1e>
    80201468:	4785                	li	a5,1
    8020146a:	fef42623          	sw	a5,-20(s0)
    consputc('\033');
    8020146e:	456d                	li	a0,27
    80201470:	fffff097          	auipc	ra,0xfffff
    80201474:	730080e7          	jalr	1840(ra) # 80200ba0 <consputc>
    consputc('[');
    80201478:	05b00513          	li	a0,91
    8020147c:	fffff097          	auipc	ra,0xfffff
    80201480:	724080e7          	jalr	1828(ra) # 80200ba0 <consputc>
    printint(col, 10, 0,0,0);
    80201484:	fec42783          	lw	a5,-20(s0)
    80201488:	4701                	li	a4,0
    8020148a:	4681                	li	a3,0
    8020148c:	4601                	li	a2,0
    8020148e:	45a9                	li	a1,10
    80201490:	853e                	mv	a0,a5
    80201492:	fffff097          	auipc	ra,0xfffff
    80201496:	762080e7          	jalr	1890(ra) # 80200bf4 <printint>
    consputc('G');
    8020149a:	04700513          	li	a0,71
    8020149e:	fffff097          	auipc	ra,0xfffff
    802014a2:	702080e7          	jalr	1794(ra) # 80200ba0 <consputc>
}
    802014a6:	0001                	nop
    802014a8:	60e2                	ld	ra,24(sp)
    802014aa:	6442                	ld	s0,16(sp)
    802014ac:	6105                	addi	sp,sp,32
    802014ae:	8082                	ret

00000000802014b0 <goto_rc>:
// 光标定位到指定行列
void goto_rc(int row, int col) {
    802014b0:	1101                	addi	sp,sp,-32
    802014b2:	ec06                	sd	ra,24(sp)
    802014b4:	e822                	sd	s0,16(sp)
    802014b6:	1000                	addi	s0,sp,32
    802014b8:	87aa                	mv	a5,a0
    802014ba:	872e                	mv	a4,a1
    802014bc:	fef42623          	sw	a5,-20(s0)
    802014c0:	87ba                	mv	a5,a4
    802014c2:	fef42423          	sw	a5,-24(s0)
    consputc('\033');
    802014c6:	456d                	li	a0,27
    802014c8:	fffff097          	auipc	ra,0xfffff
    802014cc:	6d8080e7          	jalr	1752(ra) # 80200ba0 <consputc>
    consputc('[');
    802014d0:	05b00513          	li	a0,91
    802014d4:	fffff097          	auipc	ra,0xfffff
    802014d8:	6cc080e7          	jalr	1740(ra) # 80200ba0 <consputc>
    printint(row, 10, 0,0,0);
    802014dc:	fec42783          	lw	a5,-20(s0)
    802014e0:	4701                	li	a4,0
    802014e2:	4681                	li	a3,0
    802014e4:	4601                	li	a2,0
    802014e6:	45a9                	li	a1,10
    802014e8:	853e                	mv	a0,a5
    802014ea:	fffff097          	auipc	ra,0xfffff
    802014ee:	70a080e7          	jalr	1802(ra) # 80200bf4 <printint>
    consputc(';');
    802014f2:	03b00513          	li	a0,59
    802014f6:	fffff097          	auipc	ra,0xfffff
    802014fa:	6aa080e7          	jalr	1706(ra) # 80200ba0 <consputc>
    printint(col, 10, 0,0,0);
    802014fe:	fe842783          	lw	a5,-24(s0)
    80201502:	4701                	li	a4,0
    80201504:	4681                	li	a3,0
    80201506:	4601                	li	a2,0
    80201508:	45a9                	li	a1,10
    8020150a:	853e                	mv	a0,a5
    8020150c:	fffff097          	auipc	ra,0xfffff
    80201510:	6e8080e7          	jalr	1768(ra) # 80200bf4 <printint>
    consputc('H');
    80201514:	04800513          	li	a0,72
    80201518:	fffff097          	auipc	ra,0xfffff
    8020151c:	688080e7          	jalr	1672(ra) # 80200ba0 <consputc>
}
    80201520:	0001                	nop
    80201522:	60e2                	ld	ra,24(sp)
    80201524:	6442                	ld	s0,16(sp)
    80201526:	6105                	addi	sp,sp,32
    80201528:	8082                	ret

000000008020152a <reset_color>:
// 颜色控制
void reset_color(void) {
    8020152a:	1141                	addi	sp,sp,-16
    8020152c:	e406                	sd	ra,8(sp)
    8020152e:	e022                	sd	s0,0(sp)
    80201530:	0800                	addi	s0,sp,16
	uart_puts(ESC "[0m");
    80201532:	0000d517          	auipc	a0,0xd
    80201536:	28e50513          	addi	a0,a0,654 # 8020e7c0 <user_test_table+0xf0>
    8020153a:	fffff097          	auipc	ra,0xfffff
    8020153e:	15e080e7          	jalr	350(ra) # 80200698 <uart_puts>
}
    80201542:	0001                	nop
    80201544:	60a2                	ld	ra,8(sp)
    80201546:	6402                	ld	s0,0(sp)
    80201548:	0141                	addi	sp,sp,16
    8020154a:	8082                	ret

000000008020154c <set_fg_color>:
// 设置前景色
void set_fg_color(int color) {
    8020154c:	1101                	addi	sp,sp,-32
    8020154e:	ec06                	sd	ra,24(sp)
    80201550:	e822                	sd	s0,16(sp)
    80201552:	1000                	addi	s0,sp,32
    80201554:	87aa                	mv	a5,a0
    80201556:	fef42623          	sw	a5,-20(s0)
	if (color < 30 || color > 37) return; // 支持30-37
    8020155a:	fec42783          	lw	a5,-20(s0)
    8020155e:	0007871b          	sext.w	a4,a5
    80201562:	47f5                	li	a5,29
    80201564:	04e7d763          	bge	a5,a4,802015b2 <set_fg_color+0x66>
    80201568:	fec42783          	lw	a5,-20(s0)
    8020156c:	0007871b          	sext.w	a4,a5
    80201570:	02500793          	li	a5,37
    80201574:	02e7cf63          	blt	a5,a4,802015b2 <set_fg_color+0x66>
	consputc('\033');
    80201578:	456d                	li	a0,27
    8020157a:	fffff097          	auipc	ra,0xfffff
    8020157e:	626080e7          	jalr	1574(ra) # 80200ba0 <consputc>
	consputc('[');
    80201582:	05b00513          	li	a0,91
    80201586:	fffff097          	auipc	ra,0xfffff
    8020158a:	61a080e7          	jalr	1562(ra) # 80200ba0 <consputc>
	printint(color, 10, 0,0,0);
    8020158e:	fec42783          	lw	a5,-20(s0)
    80201592:	4701                	li	a4,0
    80201594:	4681                	li	a3,0
    80201596:	4601                	li	a2,0
    80201598:	45a9                	li	a1,10
    8020159a:	853e                	mv	a0,a5
    8020159c:	fffff097          	auipc	ra,0xfffff
    802015a0:	658080e7          	jalr	1624(ra) # 80200bf4 <printint>
	consputc('m');
    802015a4:	06d00513          	li	a0,109
    802015a8:	fffff097          	auipc	ra,0xfffff
    802015ac:	5f8080e7          	jalr	1528(ra) # 80200ba0 <consputc>
    802015b0:	a011                	j	802015b4 <set_fg_color+0x68>
	if (color < 30 || color > 37) return; // 支持30-37
    802015b2:	0001                	nop
}
    802015b4:	60e2                	ld	ra,24(sp)
    802015b6:	6442                	ld	s0,16(sp)
    802015b8:	6105                	addi	sp,sp,32
    802015ba:	8082                	ret

00000000802015bc <set_bg_color>:
// 设置背景色
void set_bg_color(int color) {
    802015bc:	1101                	addi	sp,sp,-32
    802015be:	ec06                	sd	ra,24(sp)
    802015c0:	e822                	sd	s0,16(sp)
    802015c2:	1000                	addi	s0,sp,32
    802015c4:	87aa                	mv	a5,a0
    802015c6:	fef42623          	sw	a5,-20(s0)
	if (color < 40 || color > 47) return; // 支持40-47
    802015ca:	fec42783          	lw	a5,-20(s0)
    802015ce:	0007871b          	sext.w	a4,a5
    802015d2:	02700793          	li	a5,39
    802015d6:	04e7d763          	bge	a5,a4,80201624 <set_bg_color+0x68>
    802015da:	fec42783          	lw	a5,-20(s0)
    802015de:	0007871b          	sext.w	a4,a5
    802015e2:	02f00793          	li	a5,47
    802015e6:	02e7cf63          	blt	a5,a4,80201624 <set_bg_color+0x68>
	consputc('\033');
    802015ea:	456d                	li	a0,27
    802015ec:	fffff097          	auipc	ra,0xfffff
    802015f0:	5b4080e7          	jalr	1460(ra) # 80200ba0 <consputc>
	consputc('[');
    802015f4:	05b00513          	li	a0,91
    802015f8:	fffff097          	auipc	ra,0xfffff
    802015fc:	5a8080e7          	jalr	1448(ra) # 80200ba0 <consputc>
	printint(color, 10, 0,0,0);
    80201600:	fec42783          	lw	a5,-20(s0)
    80201604:	4701                	li	a4,0
    80201606:	4681                	li	a3,0
    80201608:	4601                	li	a2,0
    8020160a:	45a9                	li	a1,10
    8020160c:	853e                	mv	a0,a5
    8020160e:	fffff097          	auipc	ra,0xfffff
    80201612:	5e6080e7          	jalr	1510(ra) # 80200bf4 <printint>
	consputc('m');
    80201616:	06d00513          	li	a0,109
    8020161a:	fffff097          	auipc	ra,0xfffff
    8020161e:	586080e7          	jalr	1414(ra) # 80200ba0 <consputc>
    80201622:	a011                	j	80201626 <set_bg_color+0x6a>
	if (color < 40 || color > 47) return; // 支持40-47
    80201624:	0001                	nop
}
    80201626:	60e2                	ld	ra,24(sp)
    80201628:	6442                	ld	s0,16(sp)
    8020162a:	6105                	addi	sp,sp,32
    8020162c:	8082                	ret

000000008020162e <color_red>:
// 简易文字颜色
void color_red(void) {
    8020162e:	1141                	addi	sp,sp,-16
    80201630:	e406                	sd	ra,8(sp)
    80201632:	e022                	sd	s0,0(sp)
    80201634:	0800                	addi	s0,sp,16
	set_fg_color(31); // 红色
    80201636:	457d                	li	a0,31
    80201638:	00000097          	auipc	ra,0x0
    8020163c:	f14080e7          	jalr	-236(ra) # 8020154c <set_fg_color>
}
    80201640:	0001                	nop
    80201642:	60a2                	ld	ra,8(sp)
    80201644:	6402                	ld	s0,0(sp)
    80201646:	0141                	addi	sp,sp,16
    80201648:	8082                	ret

000000008020164a <color_green>:
void color_green(void) {
    8020164a:	1141                	addi	sp,sp,-16
    8020164c:	e406                	sd	ra,8(sp)
    8020164e:	e022                	sd	s0,0(sp)
    80201650:	0800                	addi	s0,sp,16
	set_fg_color(32); // 绿色
    80201652:	02000513          	li	a0,32
    80201656:	00000097          	auipc	ra,0x0
    8020165a:	ef6080e7          	jalr	-266(ra) # 8020154c <set_fg_color>
}
    8020165e:	0001                	nop
    80201660:	60a2                	ld	ra,8(sp)
    80201662:	6402                	ld	s0,0(sp)
    80201664:	0141                	addi	sp,sp,16
    80201666:	8082                	ret

0000000080201668 <color_yellow>:
void color_yellow(void) {
    80201668:	1141                	addi	sp,sp,-16
    8020166a:	e406                	sd	ra,8(sp)
    8020166c:	e022                	sd	s0,0(sp)
    8020166e:	0800                	addi	s0,sp,16
	set_fg_color(33); // 黄色
    80201670:	02100513          	li	a0,33
    80201674:	00000097          	auipc	ra,0x0
    80201678:	ed8080e7          	jalr	-296(ra) # 8020154c <set_fg_color>
}
    8020167c:	0001                	nop
    8020167e:	60a2                	ld	ra,8(sp)
    80201680:	6402                	ld	s0,0(sp)
    80201682:	0141                	addi	sp,sp,16
    80201684:	8082                	ret

0000000080201686 <color_blue>:
void color_blue(void) {
    80201686:	1141                	addi	sp,sp,-16
    80201688:	e406                	sd	ra,8(sp)
    8020168a:	e022                	sd	s0,0(sp)
    8020168c:	0800                	addi	s0,sp,16
	set_fg_color(34); // 蓝色
    8020168e:	02200513          	li	a0,34
    80201692:	00000097          	auipc	ra,0x0
    80201696:	eba080e7          	jalr	-326(ra) # 8020154c <set_fg_color>
}
    8020169a:	0001                	nop
    8020169c:	60a2                	ld	ra,8(sp)
    8020169e:	6402                	ld	s0,0(sp)
    802016a0:	0141                	addi	sp,sp,16
    802016a2:	8082                	ret

00000000802016a4 <color_purple>:
void color_purple(void) {
    802016a4:	1141                	addi	sp,sp,-16
    802016a6:	e406                	sd	ra,8(sp)
    802016a8:	e022                	sd	s0,0(sp)
    802016aa:	0800                	addi	s0,sp,16
	set_fg_color(35); // 紫色
    802016ac:	02300513          	li	a0,35
    802016b0:	00000097          	auipc	ra,0x0
    802016b4:	e9c080e7          	jalr	-356(ra) # 8020154c <set_fg_color>
}
    802016b8:	0001                	nop
    802016ba:	60a2                	ld	ra,8(sp)
    802016bc:	6402                	ld	s0,0(sp)
    802016be:	0141                	addi	sp,sp,16
    802016c0:	8082                	ret

00000000802016c2 <color_cyan>:
void color_cyan(void) {
    802016c2:	1141                	addi	sp,sp,-16
    802016c4:	e406                	sd	ra,8(sp)
    802016c6:	e022                	sd	s0,0(sp)
    802016c8:	0800                	addi	s0,sp,16
	set_fg_color(36); // 青色
    802016ca:	02400513          	li	a0,36
    802016ce:	00000097          	auipc	ra,0x0
    802016d2:	e7e080e7          	jalr	-386(ra) # 8020154c <set_fg_color>
}
    802016d6:	0001                	nop
    802016d8:	60a2                	ld	ra,8(sp)
    802016da:	6402                	ld	s0,0(sp)
    802016dc:	0141                	addi	sp,sp,16
    802016de:	8082                	ret

00000000802016e0 <color_reverse>:
void color_reverse(void){
    802016e0:	1141                	addi	sp,sp,-16
    802016e2:	e406                	sd	ra,8(sp)
    802016e4:	e022                	sd	s0,0(sp)
    802016e6:	0800                	addi	s0,sp,16
	set_fg_color(37); // 反色
    802016e8:	02500513          	li	a0,37
    802016ec:	00000097          	auipc	ra,0x0
    802016f0:	e60080e7          	jalr	-416(ra) # 8020154c <set_fg_color>
}
    802016f4:	0001                	nop
    802016f6:	60a2                	ld	ra,8(sp)
    802016f8:	6402                	ld	s0,0(sp)
    802016fa:	0141                	addi	sp,sp,16
    802016fc:	8082                	ret

00000000802016fe <set_color>:
void set_color(int fg, int bg) {
    802016fe:	1101                	addi	sp,sp,-32
    80201700:	ec06                	sd	ra,24(sp)
    80201702:	e822                	sd	s0,16(sp)
    80201704:	1000                	addi	s0,sp,32
    80201706:	87aa                	mv	a5,a0
    80201708:	872e                	mv	a4,a1
    8020170a:	fef42623          	sw	a5,-20(s0)
    8020170e:	87ba                	mv	a5,a4
    80201710:	fef42423          	sw	a5,-24(s0)
	set_bg_color(bg);
    80201714:	fe842783          	lw	a5,-24(s0)
    80201718:	853e                	mv	a0,a5
    8020171a:	00000097          	auipc	ra,0x0
    8020171e:	ea2080e7          	jalr	-350(ra) # 802015bc <set_bg_color>
	set_fg_color(fg);
    80201722:	fec42783          	lw	a5,-20(s0)
    80201726:	853e                	mv	a0,a5
    80201728:	00000097          	auipc	ra,0x0
    8020172c:	e24080e7          	jalr	-476(ra) # 8020154c <set_fg_color>
}
    80201730:	0001                	nop
    80201732:	60e2                	ld	ra,24(sp)
    80201734:	6442                	ld	s0,16(sp)
    80201736:	6105                	addi	sp,sp,32
    80201738:	8082                	ret

000000008020173a <clear_line>:
void clear_line(){
    8020173a:	1141                	addi	sp,sp,-16
    8020173c:	e406                	sd	ra,8(sp)
    8020173e:	e022                	sd	s0,0(sp)
    80201740:	0800                	addi	s0,sp,16
	consputc('\033');
    80201742:	456d                	li	a0,27
    80201744:	fffff097          	auipc	ra,0xfffff
    80201748:	45c080e7          	jalr	1116(ra) # 80200ba0 <consputc>
	consputc('[');
    8020174c:	05b00513          	li	a0,91
    80201750:	fffff097          	auipc	ra,0xfffff
    80201754:	450080e7          	jalr	1104(ra) # 80200ba0 <consputc>
	consputc('2');
    80201758:	03200513          	li	a0,50
    8020175c:	fffff097          	auipc	ra,0xfffff
    80201760:	444080e7          	jalr	1092(ra) # 80200ba0 <consputc>
	consputc('K');
    80201764:	04b00513          	li	a0,75
    80201768:	fffff097          	auipc	ra,0xfffff
    8020176c:	438080e7          	jalr	1080(ra) # 80200ba0 <consputc>
}
    80201770:	0001                	nop
    80201772:	60a2                	ld	ra,8(sp)
    80201774:	6402                	ld	s0,0(sp)
    80201776:	0141                	addi	sp,sp,16
    80201778:	8082                	ret

000000008020177a <panic>:

void panic(const char *msg) {
    8020177a:	1101                	addi	sp,sp,-32
    8020177c:	ec06                	sd	ra,24(sp)
    8020177e:	e822                	sd	s0,16(sp)
    80201780:	1000                	addi	s0,sp,32
    80201782:	fea43423          	sd	a0,-24(s0)
	color_red(); // 可选：红色显示
    80201786:	00000097          	auipc	ra,0x0
    8020178a:	ea8080e7          	jalr	-344(ra) # 8020162e <color_red>
	printf("panic: %s\n", msg);
    8020178e:	fe843583          	ld	a1,-24(s0)
    80201792:	0000d517          	auipc	a0,0xd
    80201796:	03650513          	addi	a0,a0,54 # 8020e7c8 <user_test_table+0xf8>
    8020179a:	fffff097          	auipc	ra,0xfffff
    8020179e:	594080e7          	jalr	1428(ra) # 80200d2e <printf>
	reset_color();
    802017a2:	00000097          	auipc	ra,0x0
    802017a6:	d88080e7          	jalr	-632(ra) # 8020152a <reset_color>
	while (1) { /* 死循环，防止继续执行 */ }
    802017aa:	0001                	nop
    802017ac:	bffd                	j	802017aa <panic+0x30>

00000000802017ae <warning>:
}
void warning(const char *fmt, ...) {
    802017ae:	7159                	addi	sp,sp,-112
    802017b0:	f406                	sd	ra,40(sp)
    802017b2:	f022                	sd	s0,32(sp)
    802017b4:	1800                	addi	s0,sp,48
    802017b6:	fca43c23          	sd	a0,-40(s0)
    802017ba:	e40c                	sd	a1,8(s0)
    802017bc:	e810                	sd	a2,16(s0)
    802017be:	ec14                	sd	a3,24(s0)
    802017c0:	f018                	sd	a4,32(s0)
    802017c2:	f41c                	sd	a5,40(s0)
    802017c4:	03043823          	sd	a6,48(s0)
    802017c8:	03143c23          	sd	a7,56(s0)
    va_list ap;
    color_purple(); // 设置紫色
    802017cc:	00000097          	auipc	ra,0x0
    802017d0:	ed8080e7          	jalr	-296(ra) # 802016a4 <color_purple>
    printf("[WARNING] ");
    802017d4:	0000d517          	auipc	a0,0xd
    802017d8:	00450513          	addi	a0,a0,4 # 8020e7d8 <user_test_table+0x108>
    802017dc:	fffff097          	auipc	ra,0xfffff
    802017e0:	552080e7          	jalr	1362(ra) # 80200d2e <printf>
    va_start(ap, fmt);
    802017e4:	04040793          	addi	a5,s0,64
    802017e8:	fcf43823          	sd	a5,-48(s0)
    802017ec:	fd043783          	ld	a5,-48(s0)
    802017f0:	fc878793          	addi	a5,a5,-56
    802017f4:	fef43423          	sd	a5,-24(s0)
    printf(fmt, ap);
    802017f8:	fe843783          	ld	a5,-24(s0)
    802017fc:	85be                	mv	a1,a5
    802017fe:	fd843503          	ld	a0,-40(s0)
    80201802:	fffff097          	auipc	ra,0xfffff
    80201806:	52c080e7          	jalr	1324(ra) # 80200d2e <printf>
    va_end(ap);
    reset_color(); // 恢复默认颜色
    8020180a:	00000097          	auipc	ra,0x0
    8020180e:	d20080e7          	jalr	-736(ra) # 8020152a <reset_color>
}
    80201812:	0001                	nop
    80201814:	70a2                	ld	ra,40(sp)
    80201816:	7402                	ld	s0,32(sp)
    80201818:	6165                	addi	sp,sp,112
    8020181a:	8082                	ret

000000008020181c <test_printf_precision>:
void test_printf_precision(void) {
    8020181c:	1101                	addi	sp,sp,-32
    8020181e:	ec06                	sd	ra,24(sp)
    80201820:	e822                	sd	s0,16(sp)
    80201822:	1000                	addi	s0,sp,32
	clear_screen();
    80201824:	00000097          	auipc	ra,0x0
    80201828:	a22080e7          	jalr	-1502(ra) # 80201246 <clear_screen>
    printf("=== 详细的printf测试 ===\n");
    8020182c:	0000d517          	auipc	a0,0xd
    80201830:	fbc50513          	addi	a0,a0,-68 # 8020e7e8 <user_test_table+0x118>
    80201834:	fffff097          	auipc	ra,0xfffff
    80201838:	4fa080e7          	jalr	1274(ra) # 80200d2e <printf>
    
    // 测试十六进制格式
    printf("十六进制测试:\n");
    8020183c:	0000d517          	auipc	a0,0xd
    80201840:	fcc50513          	addi	a0,a0,-52 # 8020e808 <user_test_table+0x138>
    80201844:	fffff097          	auipc	ra,0xfffff
    80201848:	4ea080e7          	jalr	1258(ra) # 80200d2e <printf>
    printf("  255 = 0x%x (expected: ff)\n", 255);
    8020184c:	0ff00593          	li	a1,255
    80201850:	0000d517          	auipc	a0,0xd
    80201854:	fd050513          	addi	a0,a0,-48 # 8020e820 <user_test_table+0x150>
    80201858:	fffff097          	auipc	ra,0xfffff
    8020185c:	4d6080e7          	jalr	1238(ra) # 80200d2e <printf>
    printf("  4096 = 0x%x (expected: 1000)\n", 4096);
    80201860:	6585                	lui	a1,0x1
    80201862:	0000d517          	auipc	a0,0xd
    80201866:	fde50513          	addi	a0,a0,-34 # 8020e840 <user_test_table+0x170>
    8020186a:	fffff097          	auipc	ra,0xfffff
    8020186e:	4c4080e7          	jalr	1220(ra) # 80200d2e <printf>
    printf("  0x1234abcd = 0x%x\n", 0x1234abcd);
    80201872:	1234b7b7          	lui	a5,0x1234b
    80201876:	bcd78593          	addi	a1,a5,-1075 # 1234abcd <_entry-0x6deb5433>
    8020187a:	0000d517          	auipc	a0,0xd
    8020187e:	fe650513          	addi	a0,a0,-26 # 8020e860 <user_test_table+0x190>
    80201882:	fffff097          	auipc	ra,0xfffff
    80201886:	4ac080e7          	jalr	1196(ra) # 80200d2e <printf>
    
    // 测试十进制格式  
    printf("十进制测试:\n");
    8020188a:	0000d517          	auipc	a0,0xd
    8020188e:	fee50513          	addi	a0,a0,-18 # 8020e878 <user_test_table+0x1a8>
    80201892:	fffff097          	auipc	ra,0xfffff
    80201896:	49c080e7          	jalr	1180(ra) # 80200d2e <printf>
    printf("  正数: %d\n", 42);
    8020189a:	02a00593          	li	a1,42
    8020189e:	0000d517          	auipc	a0,0xd
    802018a2:	ff250513          	addi	a0,a0,-14 # 8020e890 <user_test_table+0x1c0>
    802018a6:	fffff097          	auipc	ra,0xfffff
    802018aa:	488080e7          	jalr	1160(ra) # 80200d2e <printf>
    printf("  负数: %d\n", -42);
    802018ae:	fd600593          	li	a1,-42
    802018b2:	0000d517          	auipc	a0,0xd
    802018b6:	fee50513          	addi	a0,a0,-18 # 8020e8a0 <user_test_table+0x1d0>
    802018ba:	fffff097          	auipc	ra,0xfffff
    802018be:	474080e7          	jalr	1140(ra) # 80200d2e <printf>
    printf("  零: %d\n", 0);
    802018c2:	4581                	li	a1,0
    802018c4:	0000d517          	auipc	a0,0xd
    802018c8:	fec50513          	addi	a0,a0,-20 # 8020e8b0 <user_test_table+0x1e0>
    802018cc:	fffff097          	auipc	ra,0xfffff
    802018d0:	462080e7          	jalr	1122(ra) # 80200d2e <printf>
    printf("  大数: %d\n", 123456789);
    802018d4:	075bd7b7          	lui	a5,0x75bd
    802018d8:	d1578593          	addi	a1,a5,-747 # 75bcd15 <_entry-0x78c432eb>
    802018dc:	0000d517          	auipc	a0,0xd
    802018e0:	fe450513          	addi	a0,a0,-28 # 8020e8c0 <user_test_table+0x1f0>
    802018e4:	fffff097          	auipc	ra,0xfffff
    802018e8:	44a080e7          	jalr	1098(ra) # 80200d2e <printf>
    
    // 测试无符号格式
    printf("无符号测试:\n");
    802018ec:	0000d517          	auipc	a0,0xd
    802018f0:	fe450513          	addi	a0,a0,-28 # 8020e8d0 <user_test_table+0x200>
    802018f4:	fffff097          	auipc	ra,0xfffff
    802018f8:	43a080e7          	jalr	1082(ra) # 80200d2e <printf>
    printf("  大无符号数：%u\n", 4294967295U);
    802018fc:	55fd                	li	a1,-1
    802018fe:	0000d517          	auipc	a0,0xd
    80201902:	fea50513          	addi	a0,a0,-22 # 8020e8e8 <user_test_table+0x218>
    80201906:	fffff097          	auipc	ra,0xfffff
    8020190a:	428080e7          	jalr	1064(ra) # 80200d2e <printf>
    printf("  零：%u\n", 0U);
    8020190e:	4581                	li	a1,0
    80201910:	0000d517          	auipc	a0,0xd
    80201914:	ff050513          	addi	a0,a0,-16 # 8020e900 <user_test_table+0x230>
    80201918:	fffff097          	auipc	ra,0xfffff
    8020191c:	416080e7          	jalr	1046(ra) # 80200d2e <printf>
	printf("  小无符号数：%u\n", 12345U);
    80201920:	678d                	lui	a5,0x3
    80201922:	03978593          	addi	a1,a5,57 # 3039 <_entry-0x801fcfc7>
    80201926:	0000d517          	auipc	a0,0xd
    8020192a:	fea50513          	addi	a0,a0,-22 # 8020e910 <user_test_table+0x240>
    8020192e:	fffff097          	auipc	ra,0xfffff
    80201932:	400080e7          	jalr	1024(ra) # 80200d2e <printf>

	// 测试边界
	printf("边界测试:\n");
    80201936:	0000d517          	auipc	a0,0xd
    8020193a:	ff250513          	addi	a0,a0,-14 # 8020e928 <user_test_table+0x258>
    8020193e:	fffff097          	auipc	ra,0xfffff
    80201942:	3f0080e7          	jalr	1008(ra) # 80200d2e <printf>
	printf("  INT_MAX: %d\n", 2147483647);
    80201946:	800007b7          	lui	a5,0x80000
    8020194a:	fff7c593          	not	a1,a5
    8020194e:	0000d517          	auipc	a0,0xd
    80201952:	fea50513          	addi	a0,a0,-22 # 8020e938 <user_test_table+0x268>
    80201956:	fffff097          	auipc	ra,0xfffff
    8020195a:	3d8080e7          	jalr	984(ra) # 80200d2e <printf>
	printf("  INT_MIN: %d\n", -2147483648);
    8020195e:	800005b7          	lui	a1,0x80000
    80201962:	0000d517          	auipc	a0,0xd
    80201966:	fe650513          	addi	a0,a0,-26 # 8020e948 <user_test_table+0x278>
    8020196a:	fffff097          	auipc	ra,0xfffff
    8020196e:	3c4080e7          	jalr	964(ra) # 80200d2e <printf>
	printf("  UINT_MAX: %u\n", 4294967295U);
    80201972:	55fd                	li	a1,-1
    80201974:	0000d517          	auipc	a0,0xd
    80201978:	fe450513          	addi	a0,a0,-28 # 8020e958 <user_test_table+0x288>
    8020197c:	fffff097          	auipc	ra,0xfffff
    80201980:	3b2080e7          	jalr	946(ra) # 80200d2e <printf>
	printf(" -1 as unsigned: %u\n", (unsigned int)-1);
    80201984:	55fd                	li	a1,-1
    80201986:	0000d517          	auipc	a0,0xd
    8020198a:	fe250513          	addi	a0,a0,-30 # 8020e968 <user_test_table+0x298>
    8020198e:	fffff097          	auipc	ra,0xfffff
    80201992:	3a0080e7          	jalr	928(ra) # 80200d2e <printf>
    
    // 测试字符串边界情况
    printf("字符串测试:\n");
    80201996:	0000d517          	auipc	a0,0xd
    8020199a:	fea50513          	addi	a0,a0,-22 # 8020e980 <user_test_table+0x2b0>
    8020199e:	fffff097          	auipc	ra,0xfffff
    802019a2:	390080e7          	jalr	912(ra) # 80200d2e <printf>
    printf("  空字符串: '%s'\n", "");
    802019a6:	0000d597          	auipc	a1,0xd
    802019aa:	ff258593          	addi	a1,a1,-14 # 8020e998 <user_test_table+0x2c8>
    802019ae:	0000d517          	auipc	a0,0xd
    802019b2:	ff250513          	addi	a0,a0,-14 # 8020e9a0 <user_test_table+0x2d0>
    802019b6:	fffff097          	auipc	ra,0xfffff
    802019ba:	378080e7          	jalr	888(ra) # 80200d2e <printf>
    printf("  单字符: '%s'\n", "X");
    802019be:	0000d597          	auipc	a1,0xd
    802019c2:	ffa58593          	addi	a1,a1,-6 # 8020e9b8 <user_test_table+0x2e8>
    802019c6:	0000d517          	auipc	a0,0xd
    802019ca:	ffa50513          	addi	a0,a0,-6 # 8020e9c0 <user_test_table+0x2f0>
    802019ce:	fffff097          	auipc	ra,0xfffff
    802019d2:	360080e7          	jalr	864(ra) # 80200d2e <printf>
    printf("  长字符串: '%s'\n", "This is a longer test string");
    802019d6:	0000d597          	auipc	a1,0xd
    802019da:	00258593          	addi	a1,a1,2 # 8020e9d8 <user_test_table+0x308>
    802019de:	0000d517          	auipc	a0,0xd
    802019e2:	01a50513          	addi	a0,a0,26 # 8020e9f8 <user_test_table+0x328>
    802019e6:	fffff097          	auipc	ra,0xfffff
    802019ea:	348080e7          	jalr	840(ra) # 80200d2e <printf>
	printf("  非常长字符串： '%s'\n", "Formal version: Entities should not be multiplied beyond necessity.\nPlain English: If two or more explanations fit the facts equally well, choose the simplest one.\nScientific phrasing: When multiple hypotheses explain the same observation, the simplest hypothesis that requires the fewest assumptions is most likely to be correct.");
    802019ee:	0000d597          	auipc	a1,0xd
    802019f2:	02258593          	addi	a1,a1,34 # 8020ea10 <user_test_table+0x340>
    802019f6:	0000d517          	auipc	a0,0xd
    802019fa:	16a50513          	addi	a0,a0,362 # 8020eb60 <user_test_table+0x490>
    802019fe:	fffff097          	auipc	ra,0xfffff
    80201a02:	330080e7          	jalr	816(ra) # 80200d2e <printf>
	
	// 测试混合格式
	printf("混合格式测试:\n");
    80201a06:	0000d517          	auipc	a0,0xd
    80201a0a:	17a50513          	addi	a0,a0,378 # 8020eb80 <user_test_table+0x4b0>
    80201a0e:	fffff097          	auipc	ra,0xfffff
    80201a12:	320080e7          	jalr	800(ra) # 80200d2e <printf>
	printf("  Hex: 0x%x, Dec: %d, Unsigned: %u\n", 255, -255, 255U);
    80201a16:	0ff00693          	li	a3,255
    80201a1a:	f0100613          	li	a2,-255
    80201a1e:	0ff00593          	li	a1,255
    80201a22:	0000d517          	auipc	a0,0xd
    80201a26:	17650513          	addi	a0,a0,374 # 8020eb98 <user_test_table+0x4c8>
    80201a2a:	fffff097          	auipc	ra,0xfffff
    80201a2e:	304080e7          	jalr	772(ra) # 80200d2e <printf>
	
	// 测试百分号输出
	printf("百分号输出测试:\n");
    80201a32:	0000d517          	auipc	a0,0xd
    80201a36:	18e50513          	addi	a0,a0,398 # 8020ebc0 <user_test_table+0x4f0>
    80201a3a:	fffff097          	auipc	ra,0xfffff
    80201a3e:	2f4080e7          	jalr	756(ra) # 80200d2e <printf>
	printf("  100%% 完成!\n");
    80201a42:	0000d517          	auipc	a0,0xd
    80201a46:	19650513          	addi	a0,a0,406 # 8020ebd8 <user_test_table+0x508>
    80201a4a:	fffff097          	auipc	ra,0xfffff
    80201a4e:	2e4080e7          	jalr	740(ra) # 80200d2e <printf>
	
	// 测试NULL字符串
	char *null_str = 0;
    80201a52:	fe043423          	sd	zero,-24(s0)
	printf("NULL字符串测试:\n");
    80201a56:	0000d517          	auipc	a0,0xd
    80201a5a:	19a50513          	addi	a0,a0,410 # 8020ebf0 <user_test_table+0x520>
    80201a5e:	fffff097          	auipc	ra,0xfffff
    80201a62:	2d0080e7          	jalr	720(ra) # 80200d2e <printf>
	printf("  NULL as string: '%s'\n", null_str);
    80201a66:	fe843583          	ld	a1,-24(s0)
    80201a6a:	0000d517          	auipc	a0,0xd
    80201a6e:	19e50513          	addi	a0,a0,414 # 8020ec08 <user_test_table+0x538>
    80201a72:	fffff097          	auipc	ra,0xfffff
    80201a76:	2bc080e7          	jalr	700(ra) # 80200d2e <printf>
	
	// 测试指针格式
	int var = 42;
    80201a7a:	02a00793          	li	a5,42
    80201a7e:	fef42223          	sw	a5,-28(s0)
	printf("指针测试:\n");
    80201a82:	0000d517          	auipc	a0,0xd
    80201a86:	19e50513          	addi	a0,a0,414 # 8020ec20 <user_test_table+0x550>
    80201a8a:	fffff097          	auipc	ra,0xfffff
    80201a8e:	2a4080e7          	jalr	676(ra) # 80200d2e <printf>
	printf("  Address of var: %p\n", &var);
    80201a92:	fe440793          	addi	a5,s0,-28
    80201a96:	85be                	mv	a1,a5
    80201a98:	0000d517          	auipc	a0,0xd
    80201a9c:	19850513          	addi	a0,a0,408 # 8020ec30 <user_test_table+0x560>
    80201aa0:	fffff097          	auipc	ra,0xfffff
    80201aa4:	28e080e7          	jalr	654(ra) # 80200d2e <printf>
	
	// 测试负数的无符号输出
	printf("负数无符号输出测试:\n");
    80201aa8:	0000d517          	auipc	a0,0xd
    80201aac:	1a050513          	addi	a0,a0,416 # 8020ec48 <user_test_table+0x578>
    80201ab0:	fffff097          	auipc	ra,0xfffff
    80201ab4:	27e080e7          	jalr	638(ra) # 80200d2e <printf>
	printf("  -1 as unsigned: %u\n", (unsigned int)-1);
    80201ab8:	55fd                	li	a1,-1
    80201aba:	0000d517          	auipc	a0,0xd
    80201abe:	1ae50513          	addi	a0,a0,430 # 8020ec68 <user_test_table+0x598>
    80201ac2:	fffff097          	auipc	ra,0xfffff
    80201ac6:	26c080e7          	jalr	620(ra) # 80200d2e <printf>
	
	// 测试不同进制的数字
	printf("不同进制测试:\n");
    80201aca:	0000d517          	auipc	a0,0xd
    80201ace:	1b650513          	addi	a0,a0,438 # 8020ec80 <user_test_table+0x5b0>
    80201ad2:	fffff097          	auipc	ra,0xfffff
    80201ad6:	25c080e7          	jalr	604(ra) # 80200d2e <printf>
	printf("  Binary of 5: %b\n", 5);
    80201ada:	4595                	li	a1,5
    80201adc:	0000d517          	auipc	a0,0xd
    80201ae0:	1bc50513          	addi	a0,a0,444 # 8020ec98 <user_test_table+0x5c8>
    80201ae4:	fffff097          	auipc	ra,0xfffff
    80201ae8:	24a080e7          	jalr	586(ra) # 80200d2e <printf>
	printf("  Octal of 8 : %o\n", 8); 
    80201aec:	45a1                	li	a1,8
    80201aee:	0000d517          	auipc	a0,0xd
    80201af2:	1c250513          	addi	a0,a0,450 # 8020ecb0 <user_test_table+0x5e0>
    80201af6:	fffff097          	auipc	ra,0xfffff
    80201afa:	238080e7          	jalr	568(ra) # 80200d2e <printf>
	printf("=== printf测试结束 ===\n");
    80201afe:	0000d517          	auipc	a0,0xd
    80201b02:	1ca50513          	addi	a0,a0,458 # 8020ecc8 <user_test_table+0x5f8>
    80201b06:	fffff097          	auipc	ra,0xfffff
    80201b0a:	228080e7          	jalr	552(ra) # 80200d2e <printf>
}
    80201b0e:	0001                	nop
    80201b10:	60e2                	ld	ra,24(sp)
    80201b12:	6442                	ld	s0,16(sp)
    80201b14:	6105                	addi	sp,sp,32
    80201b16:	8082                	ret

0000000080201b18 <test_curse_move>:
void test_curse_move(){
    80201b18:	1101                	addi	sp,sp,-32
    80201b1a:	ec06                	sd	ra,24(sp)
    80201b1c:	e822                	sd	s0,16(sp)
    80201b1e:	1000                	addi	s0,sp,32
	clear_screen(); // 清屏
    80201b20:	fffff097          	auipc	ra,0xfffff
    80201b24:	726080e7          	jalr	1830(ra) # 80201246 <clear_screen>
	printf("=== 光标移动测试 ===\n");
    80201b28:	0000d517          	auipc	a0,0xd
    80201b2c:	1c050513          	addi	a0,a0,448 # 8020ece8 <user_test_table+0x618>
    80201b30:	fffff097          	auipc	ra,0xfffff
    80201b34:	1fe080e7          	jalr	510(ra) # 80200d2e <printf>
	for (int i = 3; i <= 7; i++) {
    80201b38:	478d                	li	a5,3
    80201b3a:	fef42623          	sw	a5,-20(s0)
    80201b3e:	a881                	j	80201b8e <test_curse_move+0x76>
		for (int j = 1; j <= 10; j++) {
    80201b40:	4785                	li	a5,1
    80201b42:	fef42423          	sw	a5,-24(s0)
    80201b46:	a805                	j	80201b76 <test_curse_move+0x5e>
			goto_rc(i, j);
    80201b48:	fe842703          	lw	a4,-24(s0)
    80201b4c:	fec42783          	lw	a5,-20(s0)
    80201b50:	85ba                	mv	a1,a4
    80201b52:	853e                	mv	a0,a5
    80201b54:	00000097          	auipc	ra,0x0
    80201b58:	95c080e7          	jalr	-1700(ra) # 802014b0 <goto_rc>
			printf("*");
    80201b5c:	0000d517          	auipc	a0,0xd
    80201b60:	1ac50513          	addi	a0,a0,428 # 8020ed08 <user_test_table+0x638>
    80201b64:	fffff097          	auipc	ra,0xfffff
    80201b68:	1ca080e7          	jalr	458(ra) # 80200d2e <printf>
		for (int j = 1; j <= 10; j++) {
    80201b6c:	fe842783          	lw	a5,-24(s0)
    80201b70:	2785                	addiw	a5,a5,1 # ffffffff80000001 <_bss_end+0xfffffffeffdd8911>
    80201b72:	fef42423          	sw	a5,-24(s0)
    80201b76:	fe842783          	lw	a5,-24(s0)
    80201b7a:	0007871b          	sext.w	a4,a5
    80201b7e:	47a9                	li	a5,10
    80201b80:	fce7d4e3          	bge	a5,a4,80201b48 <test_curse_move+0x30>
	for (int i = 3; i <= 7; i++) {
    80201b84:	fec42783          	lw	a5,-20(s0)
    80201b88:	2785                	addiw	a5,a5,1
    80201b8a:	fef42623          	sw	a5,-20(s0)
    80201b8e:	fec42783          	lw	a5,-20(s0)
    80201b92:	0007871b          	sext.w	a4,a5
    80201b96:	479d                	li	a5,7
    80201b98:	fae7d4e3          	bge	a5,a4,80201b40 <test_curse_move+0x28>
		}
	}
	goto_rc(9, 1);
    80201b9c:	4585                	li	a1,1
    80201b9e:	4525                	li	a0,9
    80201ba0:	00000097          	auipc	ra,0x0
    80201ba4:	910080e7          	jalr	-1776(ra) # 802014b0 <goto_rc>
	save_cursor();
    80201ba8:	00000097          	auipc	ra,0x0
    80201bac:	840080e7          	jalr	-1984(ra) # 802013e8 <save_cursor>
	// 光标移动测试
	cursor_up(5);
    80201bb0:	4515                	li	a0,5
    80201bb2:	fffff097          	auipc	ra,0xfffff
    80201bb6:	6c6080e7          	jalr	1734(ra) # 80201278 <cursor_up>
	cursor_right(2);
    80201bba:	4509                	li	a0,2
    80201bbc:	fffff097          	auipc	ra,0xfffff
    80201bc0:	774080e7          	jalr	1908(ra) # 80201330 <cursor_right>
	printf("+++++");
    80201bc4:	0000d517          	auipc	a0,0xd
    80201bc8:	14c50513          	addi	a0,a0,332 # 8020ed10 <user_test_table+0x640>
    80201bcc:	fffff097          	auipc	ra,0xfffff
    80201bd0:	162080e7          	jalr	354(ra) # 80200d2e <printf>
	cursor_down(2);
    80201bd4:	4509                	li	a0,2
    80201bd6:	fffff097          	auipc	ra,0xfffff
    80201bda:	6fe080e7          	jalr	1790(ra) # 802012d4 <cursor_down>
	cursor_left(5);
    80201bde:	4515                	li	a0,5
    80201be0:	fffff097          	auipc	ra,0xfffff
    80201be4:	7ac080e7          	jalr	1964(ra) # 8020138c <cursor_left>
	printf("-----");
    80201be8:	0000d517          	auipc	a0,0xd
    80201bec:	13050513          	addi	a0,a0,304 # 8020ed18 <user_test_table+0x648>
    80201bf0:	fffff097          	auipc	ra,0xfffff
    80201bf4:	13e080e7          	jalr	318(ra) # 80200d2e <printf>
	restore_cursor();
    80201bf8:	00000097          	auipc	ra,0x0
    80201bfc:	824080e7          	jalr	-2012(ra) # 8020141c <restore_cursor>
	printf("=== 光标移动测试结束 ===\n");
    80201c00:	0000d517          	auipc	a0,0xd
    80201c04:	12050513          	addi	a0,a0,288 # 8020ed20 <user_test_table+0x650>
    80201c08:	fffff097          	auipc	ra,0xfffff
    80201c0c:	126080e7          	jalr	294(ra) # 80200d2e <printf>
}
    80201c10:	0001                	nop
    80201c12:	60e2                	ld	ra,24(sp)
    80201c14:	6442                	ld	s0,16(sp)
    80201c16:	6105                	addi	sp,sp,32
    80201c18:	8082                	ret

0000000080201c1a <test_basic_colors>:

void test_basic_colors(void) {
    80201c1a:	1141                	addi	sp,sp,-16
    80201c1c:	e406                	sd	ra,8(sp)
    80201c1e:	e022                	sd	s0,0(sp)
    80201c20:	0800                	addi	s0,sp,16
    clear_screen();
    80201c22:	fffff097          	auipc	ra,0xfffff
    80201c26:	624080e7          	jalr	1572(ra) # 80201246 <clear_screen>
    printf("=== 基本颜色测试 ===\n\n");
    80201c2a:	0000d517          	auipc	a0,0xd
    80201c2e:	11e50513          	addi	a0,a0,286 # 8020ed48 <user_test_table+0x678>
    80201c32:	fffff097          	auipc	ra,0xfffff
    80201c36:	0fc080e7          	jalr	252(ra) # 80200d2e <printf>
    
    // 测试基本前景色
    printf("前景色测试:\n");
    80201c3a:	0000d517          	auipc	a0,0xd
    80201c3e:	12e50513          	addi	a0,a0,302 # 8020ed68 <user_test_table+0x698>
    80201c42:	fffff097          	auipc	ra,0xfffff
    80201c46:	0ec080e7          	jalr	236(ra) # 80200d2e <printf>
    color_red();    printf("红色文字 ");
    80201c4a:	00000097          	auipc	ra,0x0
    80201c4e:	9e4080e7          	jalr	-1564(ra) # 8020162e <color_red>
    80201c52:	0000d517          	auipc	a0,0xd
    80201c56:	12e50513          	addi	a0,a0,302 # 8020ed80 <user_test_table+0x6b0>
    80201c5a:	fffff097          	auipc	ra,0xfffff
    80201c5e:	0d4080e7          	jalr	212(ra) # 80200d2e <printf>
    color_green();  printf("绿色文字 ");
    80201c62:	00000097          	auipc	ra,0x0
    80201c66:	9e8080e7          	jalr	-1560(ra) # 8020164a <color_green>
    80201c6a:	0000d517          	auipc	a0,0xd
    80201c6e:	12650513          	addi	a0,a0,294 # 8020ed90 <user_test_table+0x6c0>
    80201c72:	fffff097          	auipc	ra,0xfffff
    80201c76:	0bc080e7          	jalr	188(ra) # 80200d2e <printf>
    color_yellow(); printf("黄色文字 ");
    80201c7a:	00000097          	auipc	ra,0x0
    80201c7e:	9ee080e7          	jalr	-1554(ra) # 80201668 <color_yellow>
    80201c82:	0000d517          	auipc	a0,0xd
    80201c86:	11e50513          	addi	a0,a0,286 # 8020eda0 <user_test_table+0x6d0>
    80201c8a:	fffff097          	auipc	ra,0xfffff
    80201c8e:	0a4080e7          	jalr	164(ra) # 80200d2e <printf>
    color_blue();   printf("蓝色文字 ");
    80201c92:	00000097          	auipc	ra,0x0
    80201c96:	9f4080e7          	jalr	-1548(ra) # 80201686 <color_blue>
    80201c9a:	0000d517          	auipc	a0,0xd
    80201c9e:	11650513          	addi	a0,a0,278 # 8020edb0 <user_test_table+0x6e0>
    80201ca2:	fffff097          	auipc	ra,0xfffff
    80201ca6:	08c080e7          	jalr	140(ra) # 80200d2e <printf>
    color_purple(); printf("紫色文字 ");
    80201caa:	00000097          	auipc	ra,0x0
    80201cae:	9fa080e7          	jalr	-1542(ra) # 802016a4 <color_purple>
    80201cb2:	0000d517          	auipc	a0,0xd
    80201cb6:	10e50513          	addi	a0,a0,270 # 8020edc0 <user_test_table+0x6f0>
    80201cba:	fffff097          	auipc	ra,0xfffff
    80201cbe:	074080e7          	jalr	116(ra) # 80200d2e <printf>
    color_cyan();   printf("青色文字 ");
    80201cc2:	00000097          	auipc	ra,0x0
    80201cc6:	a00080e7          	jalr	-1536(ra) # 802016c2 <color_cyan>
    80201cca:	0000d517          	auipc	a0,0xd
    80201cce:	10650513          	addi	a0,a0,262 # 8020edd0 <user_test_table+0x700>
    80201cd2:	fffff097          	auipc	ra,0xfffff
    80201cd6:	05c080e7          	jalr	92(ra) # 80200d2e <printf>
    color_reverse();  printf("反色文字");
    80201cda:	00000097          	auipc	ra,0x0
    80201cde:	a06080e7          	jalr	-1530(ra) # 802016e0 <color_reverse>
    80201ce2:	0000d517          	auipc	a0,0xd
    80201ce6:	0fe50513          	addi	a0,a0,254 # 8020ede0 <user_test_table+0x710>
    80201cea:	fffff097          	auipc	ra,0xfffff
    80201cee:	044080e7          	jalr	68(ra) # 80200d2e <printf>
    reset_color();
    80201cf2:	00000097          	auipc	ra,0x0
    80201cf6:	838080e7          	jalr	-1992(ra) # 8020152a <reset_color>
    printf("\n\n");
    80201cfa:	0000d517          	auipc	a0,0xd
    80201cfe:	0f650513          	addi	a0,a0,246 # 8020edf0 <user_test_table+0x720>
    80201d02:	fffff097          	auipc	ra,0xfffff
    80201d06:	02c080e7          	jalr	44(ra) # 80200d2e <printf>
    
    // 测试背景色
    printf("背景色测试:\n");
    80201d0a:	0000d517          	auipc	a0,0xd
    80201d0e:	0ee50513          	addi	a0,a0,238 # 8020edf8 <user_test_table+0x728>
    80201d12:	fffff097          	auipc	ra,0xfffff
    80201d16:	01c080e7          	jalr	28(ra) # 80200d2e <printf>
    set_bg_color(41); printf(" 红色背景 "); reset_color();
    80201d1a:	02900513          	li	a0,41
    80201d1e:	00000097          	auipc	ra,0x0
    80201d22:	89e080e7          	jalr	-1890(ra) # 802015bc <set_bg_color>
    80201d26:	0000d517          	auipc	a0,0xd
    80201d2a:	0ea50513          	addi	a0,a0,234 # 8020ee10 <user_test_table+0x740>
    80201d2e:	fffff097          	auipc	ra,0xfffff
    80201d32:	000080e7          	jalr	ra # 80200d2e <printf>
    80201d36:	fffff097          	auipc	ra,0xfffff
    80201d3a:	7f4080e7          	jalr	2036(ra) # 8020152a <reset_color>
    set_bg_color(42); printf(" 绿色背景 "); reset_color();
    80201d3e:	02a00513          	li	a0,42
    80201d42:	00000097          	auipc	ra,0x0
    80201d46:	87a080e7          	jalr	-1926(ra) # 802015bc <set_bg_color>
    80201d4a:	0000d517          	auipc	a0,0xd
    80201d4e:	0d650513          	addi	a0,a0,214 # 8020ee20 <user_test_table+0x750>
    80201d52:	fffff097          	auipc	ra,0xfffff
    80201d56:	fdc080e7          	jalr	-36(ra) # 80200d2e <printf>
    80201d5a:	fffff097          	auipc	ra,0xfffff
    80201d5e:	7d0080e7          	jalr	2000(ra) # 8020152a <reset_color>
    set_bg_color(43); printf(" 黄色背景 "); reset_color();
    80201d62:	02b00513          	li	a0,43
    80201d66:	00000097          	auipc	ra,0x0
    80201d6a:	856080e7          	jalr	-1962(ra) # 802015bc <set_bg_color>
    80201d6e:	0000d517          	auipc	a0,0xd
    80201d72:	0c250513          	addi	a0,a0,194 # 8020ee30 <user_test_table+0x760>
    80201d76:	fffff097          	auipc	ra,0xfffff
    80201d7a:	fb8080e7          	jalr	-72(ra) # 80200d2e <printf>
    80201d7e:	fffff097          	auipc	ra,0xfffff
    80201d82:	7ac080e7          	jalr	1964(ra) # 8020152a <reset_color>
    set_bg_color(44); printf(" 蓝色背景 "); reset_color();
    80201d86:	02c00513          	li	a0,44
    80201d8a:	00000097          	auipc	ra,0x0
    80201d8e:	832080e7          	jalr	-1998(ra) # 802015bc <set_bg_color>
    80201d92:	0000d517          	auipc	a0,0xd
    80201d96:	0ae50513          	addi	a0,a0,174 # 8020ee40 <user_test_table+0x770>
    80201d9a:	fffff097          	auipc	ra,0xfffff
    80201d9e:	f94080e7          	jalr	-108(ra) # 80200d2e <printf>
    80201da2:	fffff097          	auipc	ra,0xfffff
    80201da6:	788080e7          	jalr	1928(ra) # 8020152a <reset_color>
	set_bg_color(47); printf(" 反色背景 "); reset_color();
    80201daa:	02f00513          	li	a0,47
    80201dae:	00000097          	auipc	ra,0x0
    80201db2:	80e080e7          	jalr	-2034(ra) # 802015bc <set_bg_color>
    80201db6:	0000d517          	auipc	a0,0xd
    80201dba:	09a50513          	addi	a0,a0,154 # 8020ee50 <user_test_table+0x780>
    80201dbe:	fffff097          	auipc	ra,0xfffff
    80201dc2:	f70080e7          	jalr	-144(ra) # 80200d2e <printf>
    80201dc6:	fffff097          	auipc	ra,0xfffff
    80201dca:	764080e7          	jalr	1892(ra) # 8020152a <reset_color>
    printf("\n\n");
    80201dce:	0000d517          	auipc	a0,0xd
    80201dd2:	02250513          	addi	a0,a0,34 # 8020edf0 <user_test_table+0x720>
    80201dd6:	fffff097          	auipc	ra,0xfffff
    80201dda:	f58080e7          	jalr	-168(ra) # 80200d2e <printf>
    
    // 测试组合效果
    printf("组合效果测试:\n");
    80201dde:	0000d517          	auipc	a0,0xd
    80201de2:	08250513          	addi	a0,a0,130 # 8020ee60 <user_test_table+0x790>
    80201de6:	fffff097          	auipc	ra,0xfffff
    80201dea:	f48080e7          	jalr	-184(ra) # 80200d2e <printf>
    set_color(31, 44); printf(" 红字蓝底 "); reset_color();
    80201dee:	02c00593          	li	a1,44
    80201df2:	457d                	li	a0,31
    80201df4:	00000097          	auipc	ra,0x0
    80201df8:	90a080e7          	jalr	-1782(ra) # 802016fe <set_color>
    80201dfc:	0000d517          	auipc	a0,0xd
    80201e00:	07c50513          	addi	a0,a0,124 # 8020ee78 <user_test_table+0x7a8>
    80201e04:	fffff097          	auipc	ra,0xfffff
    80201e08:	f2a080e7          	jalr	-214(ra) # 80200d2e <printf>
    80201e0c:	fffff097          	auipc	ra,0xfffff
    80201e10:	71e080e7          	jalr	1822(ra) # 8020152a <reset_color>
    set_color(33, 45); printf(" 黄字紫底 "); reset_color();
    80201e14:	02d00593          	li	a1,45
    80201e18:	02100513          	li	a0,33
    80201e1c:	00000097          	auipc	ra,0x0
    80201e20:	8e2080e7          	jalr	-1822(ra) # 802016fe <set_color>
    80201e24:	0000d517          	auipc	a0,0xd
    80201e28:	06450513          	addi	a0,a0,100 # 8020ee88 <user_test_table+0x7b8>
    80201e2c:	fffff097          	auipc	ra,0xfffff
    80201e30:	f02080e7          	jalr	-254(ra) # 80200d2e <printf>
    80201e34:	fffff097          	auipc	ra,0xfffff
    80201e38:	6f6080e7          	jalr	1782(ra) # 8020152a <reset_color>
    set_color(32, 47); printf(" 绿字反底 "); reset_color();
    80201e3c:	02f00593          	li	a1,47
    80201e40:	02000513          	li	a0,32
    80201e44:	00000097          	auipc	ra,0x0
    80201e48:	8ba080e7          	jalr	-1862(ra) # 802016fe <set_color>
    80201e4c:	0000d517          	auipc	a0,0xd
    80201e50:	04c50513          	addi	a0,a0,76 # 8020ee98 <user_test_table+0x7c8>
    80201e54:	fffff097          	auipc	ra,0xfffff
    80201e58:	eda080e7          	jalr	-294(ra) # 80200d2e <printf>
    80201e5c:	fffff097          	auipc	ra,0xfffff
    80201e60:	6ce080e7          	jalr	1742(ra) # 8020152a <reset_color>
    printf("\n\n");
    80201e64:	0000d517          	auipc	a0,0xd
    80201e68:	f8c50513          	addi	a0,a0,-116 # 8020edf0 <user_test_table+0x720>
    80201e6c:	fffff097          	auipc	ra,0xfffff
    80201e70:	ec2080e7          	jalr	-318(ra) # 80200d2e <printf>
	reset_color();
    80201e74:	fffff097          	auipc	ra,0xfffff
    80201e78:	6b6080e7          	jalr	1718(ra) # 8020152a <reset_color>
	printf("重置为默认颜色，本行文字会被清除\n"); 
    80201e7c:	0000d517          	auipc	a0,0xd
    80201e80:	02c50513          	addi	a0,a0,44 # 8020eea8 <user_test_table+0x7d8>
    80201e84:	fffff097          	auipc	ra,0xfffff
    80201e88:	eaa080e7          	jalr	-342(ra) # 80200d2e <printf>
	cursor_up(1); // 光标上移一行
    80201e8c:	4505                	li	a0,1
    80201e8e:	fffff097          	auipc	ra,0xfffff
    80201e92:	3ea080e7          	jalr	1002(ra) # 80201278 <cursor_up>
	clear_line();
    80201e96:	00000097          	auipc	ra,0x0
    80201e9a:	8a4080e7          	jalr	-1884(ra) # 8020173a <clear_line>

	printf("=== 颜色测试结束 ===\n");
    80201e9e:	0000d517          	auipc	a0,0xd
    80201ea2:	04250513          	addi	a0,a0,66 # 8020eee0 <user_test_table+0x810>
    80201ea6:	fffff097          	auipc	ra,0xfffff
    80201eaa:	e88080e7          	jalr	-376(ra) # 80200d2e <printf>
    80201eae:	0001                	nop
    80201eb0:	60a2                	ld	ra,8(sp)
    80201eb2:	6402                	ld	s0,0(sp)
    80201eb4:	0141                	addi	sp,sp,16
    80201eb6:	8082                	ret

0000000080201eb8 <memset>:
#include "defs.h"
// 自行实现memset
void *memset(void *dst, int c, unsigned long n) {
    80201eb8:	7139                	addi	sp,sp,-64
    80201eba:	fc22                	sd	s0,56(sp)
    80201ebc:	0080                	addi	s0,sp,64
    80201ebe:	fca43c23          	sd	a0,-40(s0)
    80201ec2:	87ae                	mv	a5,a1
    80201ec4:	fcc43423          	sd	a2,-56(s0)
    80201ec8:	fcf42a23          	sw	a5,-44(s0)
    unsigned char *p = dst;
    80201ecc:	fd843783          	ld	a5,-40(s0)
    80201ed0:	fef43423          	sd	a5,-24(s0)
    while (n-- > 0)
    80201ed4:	a829                	j	80201eee <memset+0x36>
        *p++ = (unsigned char)c;
    80201ed6:	fe843783          	ld	a5,-24(s0)
    80201eda:	00178713          	addi	a4,a5,1
    80201ede:	fee43423          	sd	a4,-24(s0)
    80201ee2:	fd442703          	lw	a4,-44(s0)
    80201ee6:	0ff77713          	zext.b	a4,a4
    80201eea:	00e78023          	sb	a4,0(a5)
    while (n-- > 0)
    80201eee:	fc843783          	ld	a5,-56(s0)
    80201ef2:	fff78713          	addi	a4,a5,-1
    80201ef6:	fce43423          	sd	a4,-56(s0)
    80201efa:	fff1                	bnez	a5,80201ed6 <memset+0x1e>
    return dst;
    80201efc:	fd843783          	ld	a5,-40(s0)
}
    80201f00:	853e                	mv	a0,a5
    80201f02:	7462                	ld	s0,56(sp)
    80201f04:	6121                	addi	sp,sp,64
    80201f06:	8082                	ret

0000000080201f08 <memmove>:
void *memmove(void *dst, const void *src, unsigned long n) {
    80201f08:	7139                	addi	sp,sp,-64
    80201f0a:	fc22                	sd	s0,56(sp)
    80201f0c:	0080                	addi	s0,sp,64
    80201f0e:	fca43c23          	sd	a0,-40(s0)
    80201f12:	fcb43823          	sd	a1,-48(s0)
    80201f16:	fcc43423          	sd	a2,-56(s0)
	unsigned char *d = dst;
    80201f1a:	fd843783          	ld	a5,-40(s0)
    80201f1e:	fef43423          	sd	a5,-24(s0)
	const unsigned char *s = src;
    80201f22:	fd043783          	ld	a5,-48(s0)
    80201f26:	fef43023          	sd	a5,-32(s0)
	if (d < s) {
    80201f2a:	fe843703          	ld	a4,-24(s0)
    80201f2e:	fe043783          	ld	a5,-32(s0)
    80201f32:	02f77b63          	bgeu	a4,a5,80201f68 <memmove+0x60>
		while (n-- > 0)
    80201f36:	a00d                	j	80201f58 <memmove+0x50>
			*d++ = *s++;
    80201f38:	fe043703          	ld	a4,-32(s0)
    80201f3c:	00170793          	addi	a5,a4,1
    80201f40:	fef43023          	sd	a5,-32(s0)
    80201f44:	fe843783          	ld	a5,-24(s0)
    80201f48:	00178693          	addi	a3,a5,1
    80201f4c:	fed43423          	sd	a3,-24(s0)
    80201f50:	00074703          	lbu	a4,0(a4)
    80201f54:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201f58:	fc843783          	ld	a5,-56(s0)
    80201f5c:	fff78713          	addi	a4,a5,-1
    80201f60:	fce43423          	sd	a4,-56(s0)
    80201f64:	fbf1                	bnez	a5,80201f38 <memmove+0x30>
    80201f66:	a889                	j	80201fb8 <memmove+0xb0>
	} else {
		d += n;
    80201f68:	fe843703          	ld	a4,-24(s0)
    80201f6c:	fc843783          	ld	a5,-56(s0)
    80201f70:	97ba                	add	a5,a5,a4
    80201f72:	fef43423          	sd	a5,-24(s0)
		s += n;
    80201f76:	fe043703          	ld	a4,-32(s0)
    80201f7a:	fc843783          	ld	a5,-56(s0)
    80201f7e:	97ba                	add	a5,a5,a4
    80201f80:	fef43023          	sd	a5,-32(s0)
		while (n-- > 0)
    80201f84:	a01d                	j	80201faa <memmove+0xa2>
			*(--d) = *(--s);
    80201f86:	fe043783          	ld	a5,-32(s0)
    80201f8a:	17fd                	addi	a5,a5,-1
    80201f8c:	fef43023          	sd	a5,-32(s0)
    80201f90:	fe843783          	ld	a5,-24(s0)
    80201f94:	17fd                	addi	a5,a5,-1
    80201f96:	fef43423          	sd	a5,-24(s0)
    80201f9a:	fe043783          	ld	a5,-32(s0)
    80201f9e:	0007c703          	lbu	a4,0(a5)
    80201fa2:	fe843783          	ld	a5,-24(s0)
    80201fa6:	00e78023          	sb	a4,0(a5)
		while (n-- > 0)
    80201faa:	fc843783          	ld	a5,-56(s0)
    80201fae:	fff78713          	addi	a4,a5,-1
    80201fb2:	fce43423          	sd	a4,-56(s0)
    80201fb6:	fbe1                	bnez	a5,80201f86 <memmove+0x7e>
	}
	return dst;
    80201fb8:	fd843783          	ld	a5,-40(s0)
}
    80201fbc:	853e                	mv	a0,a5
    80201fbe:	7462                	ld	s0,56(sp)
    80201fc0:	6121                	addi	sp,sp,64
    80201fc2:	8082                	ret

0000000080201fc4 <memcpy>:
void *memcpy(void *dst, const void *src, size_t n) {
    80201fc4:	715d                	addi	sp,sp,-80
    80201fc6:	e4a2                	sd	s0,72(sp)
    80201fc8:	0880                	addi	s0,sp,80
    80201fca:	fca43423          	sd	a0,-56(s0)
    80201fce:	fcb43023          	sd	a1,-64(s0)
    80201fd2:	fac43c23          	sd	a2,-72(s0)
    char *d = dst;
    80201fd6:	fc843783          	ld	a5,-56(s0)
    80201fda:	fef43023          	sd	a5,-32(s0)
    const char *s = src;
    80201fde:	fc043783          	ld	a5,-64(s0)
    80201fe2:	fcf43c23          	sd	a5,-40(s0)
    for (size_t i = 0; i < n; i++) {
    80201fe6:	fe043423          	sd	zero,-24(s0)
    80201fea:	a025                	j	80202012 <memcpy+0x4e>
        d[i] = s[i];
    80201fec:	fd843703          	ld	a4,-40(s0)
    80201ff0:	fe843783          	ld	a5,-24(s0)
    80201ff4:	973e                	add	a4,a4,a5
    80201ff6:	fe043683          	ld	a3,-32(s0)
    80201ffa:	fe843783          	ld	a5,-24(s0)
    80201ffe:	97b6                	add	a5,a5,a3
    80202000:	00074703          	lbu	a4,0(a4)
    80202004:	00e78023          	sb	a4,0(a5)
    for (size_t i = 0; i < n; i++) {
    80202008:	fe843783          	ld	a5,-24(s0)
    8020200c:	0785                	addi	a5,a5,1
    8020200e:	fef43423          	sd	a5,-24(s0)
    80202012:	fe843703          	ld	a4,-24(s0)
    80202016:	fb843783          	ld	a5,-72(s0)
    8020201a:	fcf769e3          	bltu	a4,a5,80201fec <memcpy+0x28>
    }
    return dst;
    8020201e:	fc843783          	ld	a5,-56(s0)
    80202022:	853e                	mv	a0,a5
    80202024:	6426                	ld	s0,72(sp)
    80202026:	6161                	addi	sp,sp,80
    80202028:	8082                	ret

000000008020202a <assert>:
    8020202a:	1101                	addi	sp,sp,-32
    8020202c:	ec06                	sd	ra,24(sp)
    8020202e:	e822                	sd	s0,16(sp)
    80202030:	1000                	addi	s0,sp,32
    80202032:	87aa                	mv	a5,a0
    80202034:	fef42623          	sw	a5,-20(s0)
    80202038:	fec42783          	lw	a5,-20(s0)
    8020203c:	2781                	sext.w	a5,a5
    8020203e:	e79d                	bnez	a5,8020206c <assert+0x42>
    80202040:	1b700613          	li	a2,439
    80202044:	00011597          	auipc	a1,0x11
    80202048:	edc58593          	addi	a1,a1,-292 # 80212f20 <user_test_table+0x60>
    8020204c:	00011517          	auipc	a0,0x11
    80202050:	ee450513          	addi	a0,a0,-284 # 80212f30 <user_test_table+0x70>
    80202054:	fffff097          	auipc	ra,0xfffff
    80202058:	cda080e7          	jalr	-806(ra) # 80200d2e <printf>
    8020205c:	00011517          	auipc	a0,0x11
    80202060:	efc50513          	addi	a0,a0,-260 # 80212f58 <user_test_table+0x98>
    80202064:	fffff097          	auipc	ra,0xfffff
    80202068:	716080e7          	jalr	1814(ra) # 8020177a <panic>
    8020206c:	0001                	nop
    8020206e:	60e2                	ld	ra,24(sp)
    80202070:	6442                	ld	s0,16(sp)
    80202072:	6105                	addi	sp,sp,32
    80202074:	8082                	ret

0000000080202076 <sv39_sign_extend>:
    80202076:	1101                	addi	sp,sp,-32
    80202078:	ec22                	sd	s0,24(sp)
    8020207a:	1000                	addi	s0,sp,32
    8020207c:	fea43423          	sd	a0,-24(s0)
    80202080:	fe843703          	ld	a4,-24(s0)
    80202084:	4785                	li	a5,1
    80202086:	179a                	slli	a5,a5,0x26
    80202088:	8ff9                	and	a5,a5,a4
    8020208a:	c799                	beqz	a5,80202098 <sv39_sign_extend+0x22>
    8020208c:	fe843703          	ld	a4,-24(s0)
    80202090:	57fd                	li	a5,-1
    80202092:	179e                	slli	a5,a5,0x27
    80202094:	8fd9                	or	a5,a5,a4
    80202096:	a031                	j	802020a2 <sv39_sign_extend+0x2c>
    80202098:	fe843703          	ld	a4,-24(s0)
    8020209c:	57fd                	li	a5,-1
    8020209e:	83e5                	srli	a5,a5,0x19
    802020a0:	8ff9                	and	a5,a5,a4
    802020a2:	853e                	mv	a0,a5
    802020a4:	6462                	ld	s0,24(sp)
    802020a6:	6105                	addi	sp,sp,32
    802020a8:	8082                	ret

00000000802020aa <sv39_check_valid>:
    802020aa:	1101                	addi	sp,sp,-32
    802020ac:	ec22                	sd	s0,24(sp)
    802020ae:	1000                	addi	s0,sp,32
    802020b0:	fea43423          	sd	a0,-24(s0)
    802020b4:	fe843703          	ld	a4,-24(s0)
    802020b8:	57fd                	li	a5,-1
    802020ba:	83e5                	srli	a5,a5,0x19
    802020bc:	00e7f863          	bgeu	a5,a4,802020cc <sv39_check_valid+0x22>
    802020c0:	fe843703          	ld	a4,-24(s0)
    802020c4:	57fd                	li	a5,-1
    802020c6:	179e                	slli	a5,a5,0x27
    802020c8:	00f76463          	bltu	a4,a5,802020d0 <sv39_check_valid+0x26>
    802020cc:	4785                	li	a5,1
    802020ce:	a011                	j	802020d2 <sv39_check_valid+0x28>
    802020d0:	4781                	li	a5,0
    802020d2:	853e                	mv	a0,a5
    802020d4:	6462                	ld	s0,24(sp)
    802020d6:	6105                	addi	sp,sp,32
    802020d8:	8082                	ret

00000000802020da <px>:
static inline uint64 px(int level, uint64 va) {
    802020da:	1101                	addi	sp,sp,-32
    802020dc:	ec22                	sd	s0,24(sp)
    802020de:	1000                	addi	s0,sp,32
    802020e0:	87aa                	mv	a5,a0
    802020e2:	feb43023          	sd	a1,-32(s0)
    802020e6:	fef42623          	sw	a5,-20(s0)
    return VPN_MASK(va, level);
    802020ea:	fec42783          	lw	a5,-20(s0)
    802020ee:	873e                	mv	a4,a5
    802020f0:	87ba                	mv	a5,a4
    802020f2:	0037979b          	slliw	a5,a5,0x3
    802020f6:	9fb9                	addw	a5,a5,a4
    802020f8:	2781                	sext.w	a5,a5
    802020fa:	27b1                	addiw	a5,a5,12
    802020fc:	2781                	sext.w	a5,a5
    802020fe:	873e                	mv	a4,a5
    80202100:	fe043783          	ld	a5,-32(s0)
    80202104:	00e7d7b3          	srl	a5,a5,a4
    80202108:	1ff7f793          	andi	a5,a5,511
}
    8020210c:	853e                	mv	a0,a5
    8020210e:	6462                	ld	s0,24(sp)
    80202110:	6105                	addi	sp,sp,32
    80202112:	8082                	ret

0000000080202114 <create_pagetable>:
pagetable_t create_pagetable(void) {
    80202114:	1101                	addi	sp,sp,-32
    80202116:	ec06                	sd	ra,24(sp)
    80202118:	e822                	sd	s0,16(sp)
    8020211a:	1000                	addi	s0,sp,32
    pagetable_t pt = (pagetable_t)alloc_page();
    8020211c:	00001097          	auipc	ra,0x1
    80202120:	1a4080e7          	jalr	420(ra) # 802032c0 <alloc_page>
    80202124:	fea43423          	sd	a0,-24(s0)
    if (!pt)
    80202128:	fe843783          	ld	a5,-24(s0)
    8020212c:	e399                	bnez	a5,80202132 <create_pagetable+0x1e>
        return 0;
    8020212e:	4781                	li	a5,0
    80202130:	a819                	j	80202146 <create_pagetable+0x32>
    memset(pt, 0, PGSIZE);
    80202132:	6605                	lui	a2,0x1
    80202134:	4581                	li	a1,0
    80202136:	fe843503          	ld	a0,-24(s0)
    8020213a:	00000097          	auipc	ra,0x0
    8020213e:	d7e080e7          	jalr	-642(ra) # 80201eb8 <memset>
    return pt;
    80202142:	fe843783          	ld	a5,-24(s0)
}
    80202146:	853e                	mv	a0,a5
    80202148:	60e2                	ld	ra,24(sp)
    8020214a:	6442                	ld	s0,16(sp)
    8020214c:	6105                	addi	sp,sp,32
    8020214e:	8082                	ret

0000000080202150 <walk_lookup>:
pte_t* walk_lookup(pagetable_t pt, uint64 va) {
    80202150:	7139                	addi	sp,sp,-64
    80202152:	fc06                	sd	ra,56(sp)
    80202154:	f822                	sd	s0,48(sp)
    80202156:	0080                	addi	s0,sp,64
    80202158:	fca43423          	sd	a0,-56(s0)
    8020215c:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    80202160:	fc043503          	ld	a0,-64(s0)
    80202164:	00000097          	auipc	ra,0x0
    80202168:	f12080e7          	jalr	-238(ra) # 80202076 <sv39_sign_extend>
    8020216c:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    80202170:	fc043503          	ld	a0,-64(s0)
    80202174:	00000097          	auipc	ra,0x0
    80202178:	f36080e7          	jalr	-202(ra) # 802020aa <sv39_check_valid>
    8020217c:	87aa                	mv	a5,a0
    8020217e:	eb89                	bnez	a5,80202190 <walk_lookup+0x40>
		panic("va out of sv39 range");
    80202180:	00011517          	auipc	a0,0x11
    80202184:	de050513          	addi	a0,a0,-544 # 80212f60 <user_test_table+0xa0>
    80202188:	fffff097          	auipc	ra,0xfffff
    8020218c:	5f2080e7          	jalr	1522(ra) # 8020177a <panic>
    for (int level = 2; level > 0; level--) {
    80202190:	4789                	li	a5,2
    80202192:	fef42623          	sw	a5,-20(s0)
    80202196:	a0e9                	j	80202260 <walk_lookup+0x110>
        pte_t *pte = &pt[px(level, va)];
    80202198:	fec42783          	lw	a5,-20(s0)
    8020219c:	fc043583          	ld	a1,-64(s0)
    802021a0:	853e                	mv	a0,a5
    802021a2:	00000097          	auipc	ra,0x0
    802021a6:	f38080e7          	jalr	-200(ra) # 802020da <px>
    802021aa:	87aa                	mv	a5,a0
    802021ac:	078e                	slli	a5,a5,0x3
    802021ae:	fc843703          	ld	a4,-56(s0)
    802021b2:	97ba                	add	a5,a5,a4
    802021b4:	fef43023          	sd	a5,-32(s0)
        if (!pte) {
    802021b8:	fe043783          	ld	a5,-32(s0)
    802021bc:	ef91                	bnez	a5,802021d8 <walk_lookup+0x88>
            printf("[WALK_LOOKUP] pte is NULL at level %d\n", level);
    802021be:	fec42783          	lw	a5,-20(s0)
    802021c2:	85be                	mv	a1,a5
    802021c4:	00011517          	auipc	a0,0x11
    802021c8:	db450513          	addi	a0,a0,-588 # 80212f78 <user_test_table+0xb8>
    802021cc:	fffff097          	auipc	ra,0xfffff
    802021d0:	b62080e7          	jalr	-1182(ra) # 80200d2e <printf>
            return 0;
    802021d4:	4781                	li	a5,0
    802021d6:	a075                	j	80202282 <walk_lookup+0x132>
        if (*pte & PTE_V) {
    802021d8:	fe043783          	ld	a5,-32(s0)
    802021dc:	639c                	ld	a5,0(a5)
    802021de:	8b85                	andi	a5,a5,1
    802021e0:	cfa1                	beqz	a5,80202238 <walk_lookup+0xe8>
            uint64 pa = PTE2PA(*pte);
    802021e2:	fe043783          	ld	a5,-32(s0)
    802021e6:	639c                	ld	a5,0(a5)
    802021e8:	83a9                	srli	a5,a5,0xa
    802021ea:	07b2                	slli	a5,a5,0xc
    802021ec:	fcf43c23          	sd	a5,-40(s0)
            if (pa < KERNBASE || pa >= PHYSTOP) {
    802021f0:	fd843703          	ld	a4,-40(s0)
    802021f4:	800007b7          	lui	a5,0x80000
    802021f8:	fff7c793          	not	a5,a5
    802021fc:	00e7f863          	bgeu	a5,a4,8020220c <walk_lookup+0xbc>
    80202200:	fd843703          	ld	a4,-40(s0)
    80202204:	47c5                	li	a5,17
    80202206:	07ee                	slli	a5,a5,0x1b
    80202208:	02f76363          	bltu	a4,a5,8020222e <walk_lookup+0xde>
                printf("[WALK_LOOKUP] 非法页表物理地址: 0x%lx (level %d, va=0x%lx)\n", pa, level, va);
    8020220c:	fec42783          	lw	a5,-20(s0)
    80202210:	fc043683          	ld	a3,-64(s0)
    80202214:	863e                	mv	a2,a5
    80202216:	fd843583          	ld	a1,-40(s0)
    8020221a:	00011517          	auipc	a0,0x11
    8020221e:	d8650513          	addi	a0,a0,-634 # 80212fa0 <user_test_table+0xe0>
    80202222:	fffff097          	auipc	ra,0xfffff
    80202226:	b0c080e7          	jalr	-1268(ra) # 80200d2e <printf>
                return 0;
    8020222a:	4781                	li	a5,0
    8020222c:	a899                	j	80202282 <walk_lookup+0x132>
            pt = (pagetable_t)pa;
    8020222e:	fd843783          	ld	a5,-40(s0)
    80202232:	fcf43423          	sd	a5,-56(s0)
    80202236:	a005                	j	80202256 <walk_lookup+0x106>
            printf("[WALK_LOOKUP] 页表项无效: level=%d va=0x%lx\n", level, va);
    80202238:	fec42783          	lw	a5,-20(s0)
    8020223c:	fc043603          	ld	a2,-64(s0)
    80202240:	85be                	mv	a1,a5
    80202242:	00011517          	auipc	a0,0x11
    80202246:	da650513          	addi	a0,a0,-602 # 80212fe8 <user_test_table+0x128>
    8020224a:	fffff097          	auipc	ra,0xfffff
    8020224e:	ae4080e7          	jalr	-1308(ra) # 80200d2e <printf>
            return 0;
    80202252:	4781                	li	a5,0
    80202254:	a03d                	j	80202282 <walk_lookup+0x132>
    for (int level = 2; level > 0; level--) {
    80202256:	fec42783          	lw	a5,-20(s0)
    8020225a:	37fd                	addiw	a5,a5,-1 # 7fffffff <_entry-0x200001>
    8020225c:	fef42623          	sw	a5,-20(s0)
    80202260:	fec42783          	lw	a5,-20(s0)
    80202264:	2781                	sext.w	a5,a5
    80202266:	f2f049e3          	bgtz	a5,80202198 <walk_lookup+0x48>
    return &pt[px(0, va)];
    8020226a:	fc043583          	ld	a1,-64(s0)
    8020226e:	4501                	li	a0,0
    80202270:	00000097          	auipc	ra,0x0
    80202274:	e6a080e7          	jalr	-406(ra) # 802020da <px>
    80202278:	87aa                	mv	a5,a0
    8020227a:	078e                	slli	a5,a5,0x3
    8020227c:	fc843703          	ld	a4,-56(s0)
    80202280:	97ba                	add	a5,a5,a4
}
    80202282:	853e                	mv	a0,a5
    80202284:	70e2                	ld	ra,56(sp)
    80202286:	7442                	ld	s0,48(sp)
    80202288:	6121                	addi	sp,sp,64
    8020228a:	8082                	ret

000000008020228c <walk_create>:
static pte_t* walk_create(pagetable_t pt, uint64 va) {
    8020228c:	7139                	addi	sp,sp,-64
    8020228e:	fc06                	sd	ra,56(sp)
    80202290:	f822                	sd	s0,48(sp)
    80202292:	0080                	addi	s0,sp,64
    80202294:	fca43423          	sd	a0,-56(s0)
    80202298:	fcb43023          	sd	a1,-64(s0)
	va = sv39_sign_extend(va);
    8020229c:	fc043503          	ld	a0,-64(s0)
    802022a0:	00000097          	auipc	ra,0x0
    802022a4:	dd6080e7          	jalr	-554(ra) # 80202076 <sv39_sign_extend>
    802022a8:	fca43023          	sd	a0,-64(s0)
	if (!sv39_check_valid(va))
    802022ac:	fc043503          	ld	a0,-64(s0)
    802022b0:	00000097          	auipc	ra,0x0
    802022b4:	dfa080e7          	jalr	-518(ra) # 802020aa <sv39_check_valid>
    802022b8:	87aa                	mv	a5,a0
    802022ba:	eb89                	bnez	a5,802022cc <walk_create+0x40>
		panic("va out of sv39 range");
    802022bc:	00011517          	auipc	a0,0x11
    802022c0:	ca450513          	addi	a0,a0,-860 # 80212f60 <user_test_table+0xa0>
    802022c4:	fffff097          	auipc	ra,0xfffff
    802022c8:	4b6080e7          	jalr	1206(ra) # 8020177a <panic>
    for (int level = 2; level > 0; level--) {
    802022cc:	4789                	li	a5,2
    802022ce:	fef42623          	sw	a5,-20(s0)
    802022d2:	a059                	j	80202358 <walk_create+0xcc>
        pte_t *pte = &pt[px(level, va)];
    802022d4:	fec42783          	lw	a5,-20(s0)
    802022d8:	fc043583          	ld	a1,-64(s0)
    802022dc:	853e                	mv	a0,a5
    802022de:	00000097          	auipc	ra,0x0
    802022e2:	dfc080e7          	jalr	-516(ra) # 802020da <px>
    802022e6:	87aa                	mv	a5,a0
    802022e8:	078e                	slli	a5,a5,0x3
    802022ea:	fc843703          	ld	a4,-56(s0)
    802022ee:	97ba                	add	a5,a5,a4
    802022f0:	fef43023          	sd	a5,-32(s0)
        if (*pte & PTE_V) {
    802022f4:	fe043783          	ld	a5,-32(s0)
    802022f8:	639c                	ld	a5,0(a5)
    802022fa:	8b85                	andi	a5,a5,1
    802022fc:	cb89                	beqz	a5,8020230e <walk_create+0x82>
            pt = (pagetable_t)PTE2PA(*pte);
    802022fe:	fe043783          	ld	a5,-32(s0)
    80202302:	639c                	ld	a5,0(a5)
    80202304:	83a9                	srli	a5,a5,0xa
    80202306:	07b2                	slli	a5,a5,0xc
    80202308:	fcf43423          	sd	a5,-56(s0)
    8020230c:	a089                	j	8020234e <walk_create+0xc2>
            pagetable_t new_pt = (pagetable_t)alloc_page();
    8020230e:	00001097          	auipc	ra,0x1
    80202312:	fb2080e7          	jalr	-78(ra) # 802032c0 <alloc_page>
    80202316:	fca43c23          	sd	a0,-40(s0)
            if (!new_pt)
    8020231a:	fd843783          	ld	a5,-40(s0)
    8020231e:	e399                	bnez	a5,80202324 <walk_create+0x98>
                return 0;
    80202320:	4781                	li	a5,0
    80202322:	a8a1                	j	8020237a <walk_create+0xee>
            memset(new_pt, 0, PGSIZE);
    80202324:	6605                	lui	a2,0x1
    80202326:	4581                	li	a1,0
    80202328:	fd843503          	ld	a0,-40(s0)
    8020232c:	00000097          	auipc	ra,0x0
    80202330:	b8c080e7          	jalr	-1140(ra) # 80201eb8 <memset>
            *pte = PA2PTE(new_pt) | PTE_V;
    80202334:	fd843783          	ld	a5,-40(s0)
    80202338:	83b1                	srli	a5,a5,0xc
    8020233a:	07aa                	slli	a5,a5,0xa
    8020233c:	0017e713          	ori	a4,a5,1
    80202340:	fe043783          	ld	a5,-32(s0)
    80202344:	e398                	sd	a4,0(a5)
            pt = new_pt;
    80202346:	fd843783          	ld	a5,-40(s0)
    8020234a:	fcf43423          	sd	a5,-56(s0)
    for (int level = 2; level > 0; level--) {
    8020234e:	fec42783          	lw	a5,-20(s0)
    80202352:	37fd                	addiw	a5,a5,-1
    80202354:	fef42623          	sw	a5,-20(s0)
    80202358:	fec42783          	lw	a5,-20(s0)
    8020235c:	2781                	sext.w	a5,a5
    8020235e:	f6f04be3          	bgtz	a5,802022d4 <walk_create+0x48>
    return &pt[px(0, va)];
    80202362:	fc043583          	ld	a1,-64(s0)
    80202366:	4501                	li	a0,0
    80202368:	00000097          	auipc	ra,0x0
    8020236c:	d72080e7          	jalr	-654(ra) # 802020da <px>
    80202370:	87aa                	mv	a5,a0
    80202372:	078e                	slli	a5,a5,0x3
    80202374:	fc843703          	ld	a4,-56(s0)
    80202378:	97ba                	add	a5,a5,a4
}
    8020237a:	853e                	mv	a0,a5
    8020237c:	70e2                	ld	ra,56(sp)
    8020237e:	7442                	ld	s0,48(sp)
    80202380:	6121                	addi	sp,sp,64
    80202382:	8082                	ret

0000000080202384 <map_page>:
int map_page(pagetable_t pt, uint64 va, uint64 pa, int perm) {
    80202384:	715d                	addi	sp,sp,-80
    80202386:	e486                	sd	ra,72(sp)
    80202388:	e0a2                	sd	s0,64(sp)
    8020238a:	0880                	addi	s0,sp,80
    8020238c:	fca43423          	sd	a0,-56(s0)
    80202390:	fcb43023          	sd	a1,-64(s0)
    80202394:	fac43c23          	sd	a2,-72(s0)
    80202398:	87b6                	mv	a5,a3
    8020239a:	faf42a23          	sw	a5,-76(s0)
    struct proc *p = myproc();
    8020239e:	00003097          	auipc	ra,0x3
    802023a2:	c12080e7          	jalr	-1006(ra) # 80204fb0 <myproc>
    802023a6:	fea43023          	sd	a0,-32(s0)
	if (p && p->is_user && va >= 0x80000000
    802023aa:	fe043783          	ld	a5,-32(s0)
    802023ae:	c7a9                	beqz	a5,802023f8 <map_page+0x74>
    802023b0:	fe043783          	ld	a5,-32(s0)
    802023b4:	0a87a783          	lw	a5,168(a5)
    802023b8:	c3a1                	beqz	a5,802023f8 <map_page+0x74>
    802023ba:	fc043703          	ld	a4,-64(s0)
    802023be:	800007b7          	lui	a5,0x80000
    802023c2:	fff7c793          	not	a5,a5
    802023c6:	02e7f963          	bgeu	a5,a4,802023f8 <map_page+0x74>
		&& va != TRAMPOLINE
    802023ca:	fc043703          	ld	a4,-64(s0)
    802023ce:	77fd                	lui	a5,0xfffff
    802023d0:	02f70463          	beq	a4,a5,802023f8 <map_page+0x74>
		&& va != TRAPFRAME) {
    802023d4:	fc043703          	ld	a4,-64(s0)
    802023d8:	77f9                	lui	a5,0xffffe
    802023da:	00f70f63          	beq	a4,a5,802023f8 <map_page+0x74>
		warning("map_page: 用户进程禁止映射内核空间");
    802023de:	00011517          	auipc	a0,0x11
    802023e2:	c4250513          	addi	a0,a0,-958 # 80213020 <user_test_table+0x160>
    802023e6:	fffff097          	auipc	ra,0xfffff
    802023ea:	3c8080e7          	jalr	968(ra) # 802017ae <warning>
		exit_proc(-1);
    802023ee:	557d                	li	a0,-1
    802023f0:	00004097          	auipc	ra,0x4
    802023f4:	9b2080e7          	jalr	-1614(ra) # 80205da2 <exit_proc>
    if ((va % PGSIZE) != 0)
    802023f8:	fc043703          	ld	a4,-64(s0)
    802023fc:	6785                	lui	a5,0x1
    802023fe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80202400:	8ff9                	and	a5,a5,a4
    80202402:	cb89                	beqz	a5,80202414 <map_page+0x90>
        panic("map_page: va not aligned");
    80202404:	00011517          	auipc	a0,0x11
    80202408:	c4c50513          	addi	a0,a0,-948 # 80213050 <user_test_table+0x190>
    8020240c:	fffff097          	auipc	ra,0xfffff
    80202410:	36e080e7          	jalr	878(ra) # 8020177a <panic>
    pte_t *pte = walk_create(pt, va);
    80202414:	fc043583          	ld	a1,-64(s0)
    80202418:	fc843503          	ld	a0,-56(s0)
    8020241c:	00000097          	auipc	ra,0x0
    80202420:	e70080e7          	jalr	-400(ra) # 8020228c <walk_create>
    80202424:	fca43c23          	sd	a0,-40(s0)
    if (!pte)
    80202428:	fd843783          	ld	a5,-40(s0)
    8020242c:	e399                	bnez	a5,80202432 <map_page+0xae>
        return -1;
    8020242e:	57fd                	li	a5,-1
    80202430:	a87d                	j	802024ee <map_page+0x16a>
    if (va >= 0x80000000)
    80202432:	fc043703          	ld	a4,-64(s0)
    80202436:	800007b7          	lui	a5,0x80000
    8020243a:	fff7c793          	not	a5,a5
    8020243e:	00e7f763          	bgeu	a5,a4,8020244c <map_page+0xc8>
        perm &= ~PTE_U;
    80202442:	fb442783          	lw	a5,-76(s0)
    80202446:	9bbd                	andi	a5,a5,-17
    80202448:	faf42a23          	sw	a5,-76(s0)
    if (*pte & PTE_V) {
    8020244c:	fd843783          	ld	a5,-40(s0)
    80202450:	639c                	ld	a5,0(a5)
    80202452:	8b85                	andi	a5,a5,1
    80202454:	cfbd                	beqz	a5,802024d2 <map_page+0x14e>
        if (PTE2PA(*pte) == pa) {
    80202456:	fd843783          	ld	a5,-40(s0)
    8020245a:	639c                	ld	a5,0(a5)
    8020245c:	83a9                	srli	a5,a5,0xa
    8020245e:	07b2                	slli	a5,a5,0xc
    80202460:	fb843703          	ld	a4,-72(s0)
    80202464:	04f71f63          	bne	a4,a5,802024c2 <map_page+0x13e>
            int new_perm = (PTE_FLAGS(*pte) | perm) & 0x3FF;
    80202468:	fd843783          	ld	a5,-40(s0)
    8020246c:	639c                	ld	a5,0(a5)
    8020246e:	2781                	sext.w	a5,a5
    80202470:	3ff7f793          	andi	a5,a5,1023
    80202474:	0007871b          	sext.w	a4,a5
    80202478:	fb442783          	lw	a5,-76(s0)
    8020247c:	8fd9                	or	a5,a5,a4
    8020247e:	2781                	sext.w	a5,a5
    80202480:	2781                	sext.w	a5,a5
    80202482:	3ff7f793          	andi	a5,a5,1023
    80202486:	fef42623          	sw	a5,-20(s0)
            if (va >= 0x80000000)
    8020248a:	fc043703          	ld	a4,-64(s0)
    8020248e:	800007b7          	lui	a5,0x80000
    80202492:	fff7c793          	not	a5,a5
    80202496:	00e7f763          	bgeu	a5,a4,802024a4 <map_page+0x120>
                new_perm &= ~PTE_U;
    8020249a:	fec42783          	lw	a5,-20(s0)
    8020249e:	9bbd                	andi	a5,a5,-17
    802024a0:	fef42623          	sw	a5,-20(s0)
            *pte = PA2PTE(pa) | new_perm | PTE_V;
    802024a4:	fb843783          	ld	a5,-72(s0)
    802024a8:	83b1                	srli	a5,a5,0xc
    802024aa:	00a79713          	slli	a4,a5,0xa
    802024ae:	fec42783          	lw	a5,-20(s0)
    802024b2:	8fd9                	or	a5,a5,a4
    802024b4:	0017e713          	ori	a4,a5,1
    802024b8:	fd843783          	ld	a5,-40(s0)
    802024bc:	e398                	sd	a4,0(a5)
            return 0;
    802024be:	4781                	li	a5,0
    802024c0:	a03d                	j	802024ee <map_page+0x16a>
            panic("map_page: remap to different physical address");
    802024c2:	00011517          	auipc	a0,0x11
    802024c6:	bae50513          	addi	a0,a0,-1106 # 80213070 <user_test_table+0x1b0>
    802024ca:	fffff097          	auipc	ra,0xfffff
    802024ce:	2b0080e7          	jalr	688(ra) # 8020177a <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    802024d2:	fb843783          	ld	a5,-72(s0)
    802024d6:	83b1                	srli	a5,a5,0xc
    802024d8:	00a79713          	slli	a4,a5,0xa
    802024dc:	fb442783          	lw	a5,-76(s0)
    802024e0:	8fd9                	or	a5,a5,a4
    802024e2:	0017e713          	ori	a4,a5,1
    802024e6:	fd843783          	ld	a5,-40(s0)
    802024ea:	e398                	sd	a4,0(a5)
    return 0;
    802024ec:	4781                	li	a5,0
}
    802024ee:	853e                	mv	a0,a5
    802024f0:	60a6                	ld	ra,72(sp)
    802024f2:	6406                	ld	s0,64(sp)
    802024f4:	6161                	addi	sp,sp,80
    802024f6:	8082                	ret

00000000802024f8 <free_pagetable>:
void free_pagetable(pagetable_t pt) {
    802024f8:	7139                	addi	sp,sp,-64
    802024fa:	fc06                	sd	ra,56(sp)
    802024fc:	f822                	sd	s0,48(sp)
    802024fe:	0080                	addi	s0,sp,64
    80202500:	fca43423          	sd	a0,-56(s0)
    for (int i = 0; i < 512; i++) {
    80202504:	fe042623          	sw	zero,-20(s0)
    80202508:	a8a5                	j	80202580 <free_pagetable+0x88>
        pte_t pte = pt[i];
    8020250a:	fec42783          	lw	a5,-20(s0)
    8020250e:	078e                	slli	a5,a5,0x3
    80202510:	fc843703          	ld	a4,-56(s0)
    80202514:	97ba                	add	a5,a5,a4
    80202516:	639c                	ld	a5,0(a5)
    80202518:	fef43023          	sd	a5,-32(s0)
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    8020251c:	fe043783          	ld	a5,-32(s0)
    80202520:	8b85                	andi	a5,a5,1
    80202522:	cb95                	beqz	a5,80202556 <free_pagetable+0x5e>
    80202524:	fe043783          	ld	a5,-32(s0)
    80202528:	8bb9                	andi	a5,a5,14
    8020252a:	e795                	bnez	a5,80202556 <free_pagetable+0x5e>
            pagetable_t child = (pagetable_t)PTE2PA(pte);
    8020252c:	fe043783          	ld	a5,-32(s0)
    80202530:	83a9                	srli	a5,a5,0xa
    80202532:	07b2                	slli	a5,a5,0xc
    80202534:	fcf43c23          	sd	a5,-40(s0)
            free_pagetable(child);
    80202538:	fd843503          	ld	a0,-40(s0)
    8020253c:	00000097          	auipc	ra,0x0
    80202540:	fbc080e7          	jalr	-68(ra) # 802024f8 <free_pagetable>
            pt[i] = 0;
    80202544:	fec42783          	lw	a5,-20(s0)
    80202548:	078e                	slli	a5,a5,0x3
    8020254a:	fc843703          	ld	a4,-56(s0)
    8020254e:	97ba                	add	a5,a5,a4
    80202550:	0007b023          	sd	zero,0(a5) # ffffffff80000000 <_bss_end+0xfffffffeffdd8910>
        if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80202554:	a00d                	j	80202576 <free_pagetable+0x7e>
        } else if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X))) {
    80202556:	fe043783          	ld	a5,-32(s0)
    8020255a:	8b85                	andi	a5,a5,1
    8020255c:	cf89                	beqz	a5,80202576 <free_pagetable+0x7e>
    8020255e:	fe043783          	ld	a5,-32(s0)
    80202562:	8bb9                	andi	a5,a5,14
    80202564:	cb89                	beqz	a5,80202576 <free_pagetable+0x7e>
            pt[i] = 0;
    80202566:	fec42783          	lw	a5,-20(s0)
    8020256a:	078e                	slli	a5,a5,0x3
    8020256c:	fc843703          	ld	a4,-56(s0)
    80202570:	97ba                	add	a5,a5,a4
    80202572:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
    80202576:	fec42783          	lw	a5,-20(s0)
    8020257a:	2785                	addiw	a5,a5,1
    8020257c:	fef42623          	sw	a5,-20(s0)
    80202580:	fec42783          	lw	a5,-20(s0)
    80202584:	0007871b          	sext.w	a4,a5
    80202588:	1ff00793          	li	a5,511
    8020258c:	f6e7dfe3          	bge	a5,a4,8020250a <free_pagetable+0x12>
    free_page(pt);
    80202590:	fc843503          	ld	a0,-56(s0)
    80202594:	00001097          	auipc	ra,0x1
    80202598:	d98080e7          	jalr	-616(ra) # 8020332c <free_page>
}
    8020259c:	0001                	nop
    8020259e:	70e2                	ld	ra,56(sp)
    802025a0:	7442                	ld	s0,48(sp)
    802025a2:	6121                	addi	sp,sp,64
    802025a4:	8082                	ret

00000000802025a6 <kvmmake>:
static pagetable_t kvmmake(void) {
    802025a6:	715d                	addi	sp,sp,-80
    802025a8:	e486                	sd	ra,72(sp)
    802025aa:	e0a2                	sd	s0,64(sp)
    802025ac:	0880                	addi	s0,sp,80
    pagetable_t kpgtbl = create_pagetable();
    802025ae:	00000097          	auipc	ra,0x0
    802025b2:	b66080e7          	jalr	-1178(ra) # 80202114 <create_pagetable>
    802025b6:	fca43423          	sd	a0,-56(s0)
    if (!kpgtbl){
    802025ba:	fc843783          	ld	a5,-56(s0)
    802025be:	eb89                	bnez	a5,802025d0 <kvmmake+0x2a>
        panic("kvmmake: alloc failed");
    802025c0:	00011517          	auipc	a0,0x11
    802025c4:	ae050513          	addi	a0,a0,-1312 # 802130a0 <user_test_table+0x1e0>
    802025c8:	fffff097          	auipc	ra,0xfffff
    802025cc:	1b2080e7          	jalr	434(ra) # 8020177a <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    802025d0:	4785                	li	a5,1
    802025d2:	07fe                	slli	a5,a5,0x1f
    802025d4:	fef43423          	sd	a5,-24(s0)
    802025d8:	a8a1                	j	80202630 <kvmmake+0x8a>
        int perm = PTE_R | PTE_W;
    802025da:	4799                	li	a5,6
    802025dc:	fef42223          	sw	a5,-28(s0)
        if (pa < (uint64)etext)
    802025e0:	00006797          	auipc	a5,0x6
    802025e4:	a2078793          	addi	a5,a5,-1504 # 80208000 <etext>
    802025e8:	fe843703          	ld	a4,-24(s0)
    802025ec:	00f77563          	bgeu	a4,a5,802025f6 <kvmmake+0x50>
            perm = PTE_R | PTE_X;
    802025f0:	47a9                	li	a5,10
    802025f2:	fef42223          	sw	a5,-28(s0)
        if (map_page(kpgtbl, pa, pa, perm) != 0)
    802025f6:	fe442783          	lw	a5,-28(s0)
    802025fa:	86be                	mv	a3,a5
    802025fc:	fe843603          	ld	a2,-24(s0)
    80202600:	fe843583          	ld	a1,-24(s0)
    80202604:	fc843503          	ld	a0,-56(s0)
    80202608:	00000097          	auipc	ra,0x0
    8020260c:	d7c080e7          	jalr	-644(ra) # 80202384 <map_page>
    80202610:	87aa                	mv	a5,a0
    80202612:	cb89                	beqz	a5,80202624 <kvmmake+0x7e>
            panic("kvmmake: heap map failed");
    80202614:	00011517          	auipc	a0,0x11
    80202618:	aa450513          	addi	a0,a0,-1372 # 802130b8 <user_test_table+0x1f8>
    8020261c:	fffff097          	auipc	ra,0xfffff
    80202620:	15e080e7          	jalr	350(ra) # 8020177a <panic>
	for (uint64 pa = KERNBASE; pa < PHYSTOP; pa += PGSIZE) {
    80202624:	fe843703          	ld	a4,-24(s0)
    80202628:	6785                	lui	a5,0x1
    8020262a:	97ba                	add	a5,a5,a4
    8020262c:	fef43423          	sd	a5,-24(s0)
    80202630:	fe843703          	ld	a4,-24(s0)
    80202634:	47c5                	li	a5,17
    80202636:	07ee                	slli	a5,a5,0x1b
    80202638:	faf761e3          	bltu	a4,a5,802025da <kvmmake+0x34>
    if (map_page(kpgtbl, UART0, UART0, PTE_R | PTE_W) != 0)
    8020263c:	4699                	li	a3,6
    8020263e:	10000637          	lui	a2,0x10000
    80202642:	100005b7          	lui	a1,0x10000
    80202646:	fc843503          	ld	a0,-56(s0)
    8020264a:	00000097          	auipc	ra,0x0
    8020264e:	d3a080e7          	jalr	-710(ra) # 80202384 <map_page>
    80202652:	87aa                	mv	a5,a0
    80202654:	cb89                	beqz	a5,80202666 <kvmmake+0xc0>
        panic("kvmmake: uart map failed");
    80202656:	00011517          	auipc	a0,0x11
    8020265a:	a8250513          	addi	a0,a0,-1406 # 802130d8 <user_test_table+0x218>
    8020265e:	fffff097          	auipc	ra,0xfffff
    80202662:	11c080e7          	jalr	284(ra) # 8020177a <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    80202666:	0c0007b7          	lui	a5,0xc000
    8020266a:	fcf43c23          	sd	a5,-40(s0)
    8020266e:	a825                	j	802026a6 <kvmmake+0x100>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    80202670:	4699                	li	a3,6
    80202672:	fd843603          	ld	a2,-40(s0)
    80202676:	fd843583          	ld	a1,-40(s0)
    8020267a:	fc843503          	ld	a0,-56(s0)
    8020267e:	00000097          	auipc	ra,0x0
    80202682:	d06080e7          	jalr	-762(ra) # 80202384 <map_page>
    80202686:	87aa                	mv	a5,a0
    80202688:	cb89                	beqz	a5,8020269a <kvmmake+0xf4>
            panic("kvmmake: plic map failed");
    8020268a:	00011517          	auipc	a0,0x11
    8020268e:	a6e50513          	addi	a0,a0,-1426 # 802130f8 <user_test_table+0x238>
    80202692:	fffff097          	auipc	ra,0xfffff
    80202696:	0e8080e7          	jalr	232(ra) # 8020177a <panic>
    for (uint64 pa = PLIC; pa < PLIC + 0x400000; pa += PGSIZE) {
    8020269a:	fd843703          	ld	a4,-40(s0)
    8020269e:	6785                	lui	a5,0x1
    802026a0:	97ba                	add	a5,a5,a4
    802026a2:	fcf43c23          	sd	a5,-40(s0)
    802026a6:	fd843703          	ld	a4,-40(s0)
    802026aa:	0c4007b7          	lui	a5,0xc400
    802026ae:	fcf761e3          	bltu	a4,a5,80202670 <kvmmake+0xca>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    802026b2:	020007b7          	lui	a5,0x2000
    802026b6:	fcf43823          	sd	a5,-48(s0)
    802026ba:	a825                	j	802026f2 <kvmmake+0x14c>
        if (map_page(kpgtbl, pa, pa, PTE_R | PTE_W) != 0)
    802026bc:	4699                	li	a3,6
    802026be:	fd043603          	ld	a2,-48(s0)
    802026c2:	fd043583          	ld	a1,-48(s0)
    802026c6:	fc843503          	ld	a0,-56(s0)
    802026ca:	00000097          	auipc	ra,0x0
    802026ce:	cba080e7          	jalr	-838(ra) # 80202384 <map_page>
    802026d2:	87aa                	mv	a5,a0
    802026d4:	cb89                	beqz	a5,802026e6 <kvmmake+0x140>
            panic("kvmmake: clint map failed");
    802026d6:	00011517          	auipc	a0,0x11
    802026da:	a4250513          	addi	a0,a0,-1470 # 80213118 <user_test_table+0x258>
    802026de:	fffff097          	auipc	ra,0xfffff
    802026e2:	09c080e7          	jalr	156(ra) # 8020177a <panic>
    for (uint64 pa = CLINT; pa < CLINT + 0x10000; pa += PGSIZE) {
    802026e6:	fd043703          	ld	a4,-48(s0)
    802026ea:	6785                	lui	a5,0x1
    802026ec:	97ba                	add	a5,a5,a4
    802026ee:	fcf43823          	sd	a5,-48(s0)
    802026f2:	fd043703          	ld	a4,-48(s0)
    802026f6:	020107b7          	lui	a5,0x2010
    802026fa:	fcf761e3          	bltu	a4,a5,802026bc <kvmmake+0x116>
    if (map_page(kpgtbl, VIRTIO0, VIRTIO0, PTE_R | PTE_W) != 0)
    802026fe:	4699                	li	a3,6
    80202700:	10001637          	lui	a2,0x10001
    80202704:	100015b7          	lui	a1,0x10001
    80202708:	fc843503          	ld	a0,-56(s0)
    8020270c:	00000097          	auipc	ra,0x0
    80202710:	c78080e7          	jalr	-904(ra) # 80202384 <map_page>
    80202714:	87aa                	mv	a5,a0
    80202716:	cb89                	beqz	a5,80202728 <kvmmake+0x182>
        panic("kvmmake: virtio map failed");
    80202718:	00011517          	auipc	a0,0x11
    8020271c:	a2050513          	addi	a0,a0,-1504 # 80213138 <user_test_table+0x278>
    80202720:	fffff097          	auipc	ra,0xfffff
    80202724:	05a080e7          	jalr	90(ra) # 8020177a <panic>
	void *tramp_phys = alloc_page();
    80202728:	00001097          	auipc	ra,0x1
    8020272c:	b98080e7          	jalr	-1128(ra) # 802032c0 <alloc_page>
    80202730:	fca43023          	sd	a0,-64(s0)
	if (!tramp_phys)
    80202734:	fc043783          	ld	a5,-64(s0)
    80202738:	eb89                	bnez	a5,8020274a <kvmmake+0x1a4>
		panic("kvmmake: alloc trampoline page failed");
    8020273a:	00011517          	auipc	a0,0x11
    8020273e:	a1e50513          	addi	a0,a0,-1506 # 80213158 <user_test_table+0x298>
    80202742:	fffff097          	auipc	ra,0xfffff
    80202746:	038080e7          	jalr	56(ra) # 8020177a <panic>
	memcpy(tramp_phys, trampoline, PGSIZE);
    8020274a:	6605                	lui	a2,0x1
    8020274c:	00002597          	auipc	a1,0x2
    80202750:	5a458593          	addi	a1,a1,1444 # 80204cf0 <trampoline>
    80202754:	fc043503          	ld	a0,-64(s0)
    80202758:	00000097          	auipc	ra,0x0
    8020275c:	86c080e7          	jalr	-1940(ra) # 80201fc4 <memcpy>
	void *trapframe_phys = alloc_page();
    80202760:	00001097          	auipc	ra,0x1
    80202764:	b60080e7          	jalr	-1184(ra) # 802032c0 <alloc_page>
    80202768:	faa43c23          	sd	a0,-72(s0)
	if (!trapframe_phys)
    8020276c:	fb843783          	ld	a5,-72(s0)
    80202770:	eb89                	bnez	a5,80202782 <kvmmake+0x1dc>
		panic("kvmmake: alloc trapframe page failed");
    80202772:	00011517          	auipc	a0,0x11
    80202776:	a0e50513          	addi	a0,a0,-1522 # 80213180 <user_test_table+0x2c0>
    8020277a:	fffff097          	auipc	ra,0xfffff
    8020277e:	000080e7          	jalr	ra # 8020177a <panic>
	memset(trapframe_phys, 0, PGSIZE);
    80202782:	6605                	lui	a2,0x1
    80202784:	4581                	li	a1,0
    80202786:	fb843503          	ld	a0,-72(s0)
    8020278a:	fffff097          	auipc	ra,0xfffff
    8020278e:	72e080e7          	jalr	1838(ra) # 80201eb8 <memset>
	if (map_page(kpgtbl, TRAMPOLINE, (uint64)tramp_phys, PTE_R | PTE_X) != 0){
    80202792:	fc043783          	ld	a5,-64(s0)
    80202796:	46a9                	li	a3,10
    80202798:	863e                	mv	a2,a5
    8020279a:	75fd                	lui	a1,0xfffff
    8020279c:	fc843503          	ld	a0,-56(s0)
    802027a0:	00000097          	auipc	ra,0x0
    802027a4:	be4080e7          	jalr	-1052(ra) # 80202384 <map_page>
    802027a8:	87aa                	mv	a5,a0
    802027aa:	cb89                	beqz	a5,802027bc <kvmmake+0x216>
		panic("kvmmake: trampoline map failed");
    802027ac:	00011517          	auipc	a0,0x11
    802027b0:	9fc50513          	addi	a0,a0,-1540 # 802131a8 <user_test_table+0x2e8>
    802027b4:	fffff097          	auipc	ra,0xfffff
    802027b8:	fc6080e7          	jalr	-58(ra) # 8020177a <panic>
	if (map_page(kpgtbl, TRAPFRAME, (uint64)trapframe_phys, PTE_R | PTE_W) != 0){
    802027bc:	fb843783          	ld	a5,-72(s0)
    802027c0:	4699                	li	a3,6
    802027c2:	863e                	mv	a2,a5
    802027c4:	75f9                	lui	a1,0xffffe
    802027c6:	fc843503          	ld	a0,-56(s0)
    802027ca:	00000097          	auipc	ra,0x0
    802027ce:	bba080e7          	jalr	-1094(ra) # 80202384 <map_page>
    802027d2:	87aa                	mv	a5,a0
    802027d4:	cb89                	beqz	a5,802027e6 <kvmmake+0x240>
		panic("kvmmake: trapframe map failed");
    802027d6:	00011517          	auipc	a0,0x11
    802027da:	9f250513          	addi	a0,a0,-1550 # 802131c8 <user_test_table+0x308>
    802027de:	fffff097          	auipc	ra,0xfffff
    802027e2:	f9c080e7          	jalr	-100(ra) # 8020177a <panic>
	trampoline_phys_addr = (uint64)tramp_phys;
    802027e6:	fc043703          	ld	a4,-64(s0)
    802027ea:	00025797          	auipc	a5,0x25
    802027ee:	8ae78793          	addi	a5,a5,-1874 # 80227098 <trampoline_phys_addr>
    802027f2:	e398                	sd	a4,0(a5)
	trapframe_phys_addr = (uint64)trapframe_phys;
    802027f4:	fb843703          	ld	a4,-72(s0)
    802027f8:	00025797          	auipc	a5,0x25
    802027fc:	8a878793          	addi	a5,a5,-1880 # 802270a0 <trapframe_phys_addr>
    80202800:	e398                	sd	a4,0(a5)
	printf("trampoline_phy_addr = %lx\n",trampoline_phys_addr);
    80202802:	00025797          	auipc	a5,0x25
    80202806:	89678793          	addi	a5,a5,-1898 # 80227098 <trampoline_phys_addr>
    8020280a:	639c                	ld	a5,0(a5)
    8020280c:	85be                	mv	a1,a5
    8020280e:	00011517          	auipc	a0,0x11
    80202812:	9da50513          	addi	a0,a0,-1574 # 802131e8 <user_test_table+0x328>
    80202816:	ffffe097          	auipc	ra,0xffffe
    8020281a:	518080e7          	jalr	1304(ra) # 80200d2e <printf>
	printf("trapframe_phys_addr = %lx\n",trapframe_phys_addr);
    8020281e:	00025797          	auipc	a5,0x25
    80202822:	88278793          	addi	a5,a5,-1918 # 802270a0 <trapframe_phys_addr>
    80202826:	639c                	ld	a5,0(a5)
    80202828:	85be                	mv	a1,a5
    8020282a:	00011517          	auipc	a0,0x11
    8020282e:	9de50513          	addi	a0,a0,-1570 # 80213208 <user_test_table+0x348>
    80202832:	ffffe097          	auipc	ra,0xffffe
    80202836:	4fc080e7          	jalr	1276(ra) # 80200d2e <printf>
    return kpgtbl;
    8020283a:	fc843783          	ld	a5,-56(s0)
}
    8020283e:	853e                	mv	a0,a5
    80202840:	60a6                	ld	ra,72(sp)
    80202842:	6406                	ld	s0,64(sp)
    80202844:	6161                	addi	sp,sp,80
    80202846:	8082                	ret

0000000080202848 <w_satp>:
static inline void w_satp(uint64 x) {
    80202848:	1101                	addi	sp,sp,-32
    8020284a:	ec22                	sd	s0,24(sp)
    8020284c:	1000                	addi	s0,sp,32
    8020284e:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0" : : "r"(x));
    80202852:	fe843783          	ld	a5,-24(s0)
    80202856:	18079073          	csrw	satp,a5
}
    8020285a:	0001                	nop
    8020285c:	6462                	ld	s0,24(sp)
    8020285e:	6105                	addi	sp,sp,32
    80202860:	8082                	ret

0000000080202862 <sfence_vma>:
inline void sfence_vma(void) {
    80202862:	1141                	addi	sp,sp,-16
    80202864:	e422                	sd	s0,8(sp)
    80202866:	0800                	addi	s0,sp,16
    asm volatile("sfence.vma zero, zero");
    80202868:	12000073          	sfence.vma
}
    8020286c:	0001                	nop
    8020286e:	6422                	ld	s0,8(sp)
    80202870:	0141                	addi	sp,sp,16
    80202872:	8082                	ret

0000000080202874 <kvminit>:
void kvminit(void) {
    80202874:	1141                	addi	sp,sp,-16
    80202876:	e406                	sd	ra,8(sp)
    80202878:	e022                	sd	s0,0(sp)
    8020287a:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    8020287c:	00000097          	auipc	ra,0x0
    80202880:	d2a080e7          	jalr	-726(ra) # 802025a6 <kvmmake>
    80202884:	872a                	mv	a4,a0
    80202886:	00025797          	auipc	a5,0x25
    8020288a:	80a78793          	addi	a5,a5,-2038 # 80227090 <kernel_pagetable>
    8020288e:	e398                	sd	a4,0(a5)
    sfence_vma();
    80202890:	00000097          	auipc	ra,0x0
    80202894:	fd2080e7          	jalr	-46(ra) # 80202862 <sfence_vma>
    w_satp(MAKE_SATP(kernel_pagetable));
    80202898:	00024797          	auipc	a5,0x24
    8020289c:	7f878793          	addi	a5,a5,2040 # 80227090 <kernel_pagetable>
    802028a0:	639c                	ld	a5,0(a5)
    802028a2:	00c7d713          	srli	a4,a5,0xc
    802028a6:	57fd                	li	a5,-1
    802028a8:	17fe                	slli	a5,a5,0x3f
    802028aa:	8fd9                	or	a5,a5,a4
    802028ac:	853e                	mv	a0,a5
    802028ae:	00000097          	auipc	ra,0x0
    802028b2:	f9a080e7          	jalr	-102(ra) # 80202848 <w_satp>
    sfence_vma();
    802028b6:	00000097          	auipc	ra,0x0
    802028ba:	fac080e7          	jalr	-84(ra) # 80202862 <sfence_vma>
    printf("[KVM] 内核分页已启用，satp=0x%lx\n", MAKE_SATP(kernel_pagetable));
    802028be:	00024797          	auipc	a5,0x24
    802028c2:	7d278793          	addi	a5,a5,2002 # 80227090 <kernel_pagetable>
    802028c6:	639c                	ld	a5,0(a5)
    802028c8:	00c7d713          	srli	a4,a5,0xc
    802028cc:	57fd                	li	a5,-1
    802028ce:	17fe                	slli	a5,a5,0x3f
    802028d0:	8fd9                	or	a5,a5,a4
    802028d2:	85be                	mv	a1,a5
    802028d4:	00011517          	auipc	a0,0x11
    802028d8:	95450513          	addi	a0,a0,-1708 # 80213228 <user_test_table+0x368>
    802028dc:	ffffe097          	auipc	ra,0xffffe
    802028e0:	452080e7          	jalr	1106(ra) # 80200d2e <printf>
}
    802028e4:	0001                	nop
    802028e6:	60a2                	ld	ra,8(sp)
    802028e8:	6402                	ld	s0,0(sp)
    802028ea:	0141                	addi	sp,sp,16
    802028ec:	8082                	ret

00000000802028ee <get_current_pagetable>:
pagetable_t get_current_pagetable(void) {
    802028ee:	1141                	addi	sp,sp,-16
    802028f0:	e422                	sd	s0,8(sp)
    802028f2:	0800                	addi	s0,sp,16
    return kernel_pagetable;  // 在没有进程时返回内核页表
    802028f4:	00024797          	auipc	a5,0x24
    802028f8:	79c78793          	addi	a5,a5,1948 # 80227090 <kernel_pagetable>
    802028fc:	639c                	ld	a5,0(a5)
}
    802028fe:	853e                	mv	a0,a5
    80202900:	6422                	ld	s0,8(sp)
    80202902:	0141                	addi	sp,sp,16
    80202904:	8082                	ret

0000000080202906 <print_pagetable>:
void print_pagetable(pagetable_t pagetable, int level, uint64 va_base) {
    80202906:	715d                	addi	sp,sp,-80
    80202908:	e486                	sd	ra,72(sp)
    8020290a:	e0a2                	sd	s0,64(sp)
    8020290c:	0880                	addi	s0,sp,80
    8020290e:	fca43423          	sd	a0,-56(s0)
    80202912:	87ae                	mv	a5,a1
    80202914:	fac43c23          	sd	a2,-72(s0)
    80202918:	fcf42223          	sw	a5,-60(s0)
    for (int i = 0; i < 512; i++) {
    8020291c:	fe042623          	sw	zero,-20(s0)
    80202920:	a0c5                	j	80202a00 <print_pagetable+0xfa>
        pte_t pte = pagetable[i];
    80202922:	fec42783          	lw	a5,-20(s0)
    80202926:	078e                	slli	a5,a5,0x3
    80202928:	fc843703          	ld	a4,-56(s0)
    8020292c:	97ba                	add	a5,a5,a4
    8020292e:	639c                	ld	a5,0(a5)
    80202930:	fef43023          	sd	a5,-32(s0)
        if (pte & PTE_V) {
    80202934:	fe043783          	ld	a5,-32(s0)
    80202938:	8b85                	andi	a5,a5,1
    8020293a:	cfd5                	beqz	a5,802029f6 <print_pagetable+0xf0>
            uint64 pa = PTE2PA(pte);
    8020293c:	fe043783          	ld	a5,-32(s0)
    80202940:	83a9                	srli	a5,a5,0xa
    80202942:	07b2                	slli	a5,a5,0xc
    80202944:	fcf43c23          	sd	a5,-40(s0)
            uint64 va = va_base + (i << (12 + 9 * (2 - level)));
    80202948:	4789                	li	a5,2
    8020294a:	fc442703          	lw	a4,-60(s0)
    8020294e:	9f99                	subw	a5,a5,a4
    80202950:	2781                	sext.w	a5,a5
    80202952:	873e                	mv	a4,a5
    80202954:	87ba                	mv	a5,a4
    80202956:	0037979b          	slliw	a5,a5,0x3
    8020295a:	9fb9                	addw	a5,a5,a4
    8020295c:	2781                	sext.w	a5,a5
    8020295e:	27b1                	addiw	a5,a5,12
    80202960:	2781                	sext.w	a5,a5
    80202962:	fec42703          	lw	a4,-20(s0)
    80202966:	00f717bb          	sllw	a5,a4,a5
    8020296a:	2781                	sext.w	a5,a5
    8020296c:	873e                	mv	a4,a5
    8020296e:	fb843783          	ld	a5,-72(s0)
    80202972:	97ba                	add	a5,a5,a4
    80202974:	fcf43823          	sd	a5,-48(s0)
            for (int l = 0; l < level; l++) printf("  "); // 缩进
    80202978:	fe042423          	sw	zero,-24(s0)
    8020297c:	a831                	j	80202998 <print_pagetable+0x92>
    8020297e:	00011517          	auipc	a0,0x11
    80202982:	8da50513          	addi	a0,a0,-1830 # 80213258 <user_test_table+0x398>
    80202986:	ffffe097          	auipc	ra,0xffffe
    8020298a:	3a8080e7          	jalr	936(ra) # 80200d2e <printf>
    8020298e:	fe842783          	lw	a5,-24(s0)
    80202992:	2785                	addiw	a5,a5,1
    80202994:	fef42423          	sw	a5,-24(s0)
    80202998:	fe842783          	lw	a5,-24(s0)
    8020299c:	873e                	mv	a4,a5
    8020299e:	fc442783          	lw	a5,-60(s0)
    802029a2:	2701                	sext.w	a4,a4
    802029a4:	2781                	sext.w	a5,a5
    802029a6:	fcf74ce3          	blt	a4,a5,8020297e <print_pagetable+0x78>
            printf("L%d[%3d] VA:0x%lx -> PA:0x%lx flags:0x%lx\n", level, i, va, pa, pte & 0x3FF);
    802029aa:	fe043783          	ld	a5,-32(s0)
    802029ae:	3ff7f793          	andi	a5,a5,1023
    802029b2:	fec42603          	lw	a2,-20(s0)
    802029b6:	fc442583          	lw	a1,-60(s0)
    802029ba:	fd843703          	ld	a4,-40(s0)
    802029be:	fd043683          	ld	a3,-48(s0)
    802029c2:	00011517          	auipc	a0,0x11
    802029c6:	89e50513          	addi	a0,a0,-1890 # 80213260 <user_test_table+0x3a0>
    802029ca:	ffffe097          	auipc	ra,0xffffe
    802029ce:	364080e7          	jalr	868(ra) # 80200d2e <printf>
            if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) { // 不是叶子
    802029d2:	fe043783          	ld	a5,-32(s0)
    802029d6:	8bb9                	andi	a5,a5,14
    802029d8:	ef99                	bnez	a5,802029f6 <print_pagetable+0xf0>
                print_pagetable((pagetable_t)pa, level + 1, va);
    802029da:	fd843783          	ld	a5,-40(s0)
    802029de:	fc442703          	lw	a4,-60(s0)
    802029e2:	2705                	addiw	a4,a4,1
    802029e4:	2701                	sext.w	a4,a4
    802029e6:	fd043603          	ld	a2,-48(s0)
    802029ea:	85ba                	mv	a1,a4
    802029ec:	853e                	mv	a0,a5
    802029ee:	00000097          	auipc	ra,0x0
    802029f2:	f18080e7          	jalr	-232(ra) # 80202906 <print_pagetable>
    for (int i = 0; i < 512; i++) {
    802029f6:	fec42783          	lw	a5,-20(s0)
    802029fa:	2785                	addiw	a5,a5,1
    802029fc:	fef42623          	sw	a5,-20(s0)
    80202a00:	fec42783          	lw	a5,-20(s0)
    80202a04:	0007871b          	sext.w	a4,a5
    80202a08:	1ff00793          	li	a5,511
    80202a0c:	f0e7dbe3          	bge	a5,a4,80202922 <print_pagetable+0x1c>
}
    80202a10:	0001                	nop
    80202a12:	0001                	nop
    80202a14:	60a6                	ld	ra,72(sp)
    80202a16:	6406                	ld	s0,64(sp)
    80202a18:	6161                	addi	sp,sp,80
    80202a1a:	8082                	ret

0000000080202a1c <handle_page_fault>:
int handle_page_fault(uint64 va, int type) {
    80202a1c:	715d                	addi	sp,sp,-80
    80202a1e:	e486                	sd	ra,72(sp)
    80202a20:	e0a2                	sd	s0,64(sp)
    80202a22:	0880                	addi	s0,sp,80
    80202a24:	faa43c23          	sd	a0,-72(s0)
    80202a28:	87ae                	mv	a5,a1
    80202a2a:	faf42a23          	sw	a5,-76(s0)
    printf("[PAGE FAULT] 处理地址 0x%lx, 类型 %d\n", va, type);
    80202a2e:	fb442783          	lw	a5,-76(s0)
    80202a32:	863e                	mv	a2,a5
    80202a34:	fb843583          	ld	a1,-72(s0)
    80202a38:	00011517          	auipc	a0,0x11
    80202a3c:	85850513          	addi	a0,a0,-1960 # 80213290 <user_test_table+0x3d0>
    80202a40:	ffffe097          	auipc	ra,0xffffe
    80202a44:	2ee080e7          	jalr	750(ra) # 80200d2e <printf>
    uint64 page_va = (va / PGSIZE) * PGSIZE;
    80202a48:	fb843703          	ld	a4,-72(s0)
    80202a4c:	77fd                	lui	a5,0xfffff
    80202a4e:	8ff9                	and	a5,a5,a4
    80202a50:	fcf43c23          	sd	a5,-40(s0)
    if (page_va >= MAXVA) {
    80202a54:	fd843703          	ld	a4,-40(s0)
    80202a58:	57fd                	li	a5,-1
    80202a5a:	83e5                	srli	a5,a5,0x19
    80202a5c:	00e7fc63          	bgeu	a5,a4,80202a74 <handle_page_fault+0x58>
        printf("[PAGE FAULT] 虚拟地址超出范围\n");
    80202a60:	00011517          	auipc	a0,0x11
    80202a64:	86050513          	addi	a0,a0,-1952 # 802132c0 <user_test_table+0x400>
    80202a68:	ffffe097          	auipc	ra,0xffffe
    80202a6c:	2c6080e7          	jalr	710(ra) # 80200d2e <printf>
        return 0;
    80202a70:	4781                	li	a5,0
    80202a72:	aae9                	j	80202c4c <handle_page_fault+0x230>
    struct proc *p = myproc();
    80202a74:	00002097          	auipc	ra,0x2
    80202a78:	53c080e7          	jalr	1340(ra) # 80204fb0 <myproc>
    80202a7c:	fca43823          	sd	a0,-48(s0)
    pagetable_t pt = kernel_pagetable;
    80202a80:	00024797          	auipc	a5,0x24
    80202a84:	61078793          	addi	a5,a5,1552 # 80227090 <kernel_pagetable>
    80202a88:	639c                	ld	a5,0(a5)
    80202a8a:	fef43423          	sd	a5,-24(s0)
    if (p && p->pagetable && p->is_user) {
    80202a8e:	fd043783          	ld	a5,-48(s0)
    80202a92:	cf99                	beqz	a5,80202ab0 <handle_page_fault+0x94>
    80202a94:	fd043783          	ld	a5,-48(s0)
    80202a98:	7fdc                	ld	a5,184(a5)
    80202a9a:	cb99                	beqz	a5,80202ab0 <handle_page_fault+0x94>
    80202a9c:	fd043783          	ld	a5,-48(s0)
    80202aa0:	0a87a783          	lw	a5,168(a5)
    80202aa4:	c791                	beqz	a5,80202ab0 <handle_page_fault+0x94>
        pt = p->pagetable;
    80202aa6:	fd043783          	ld	a5,-48(s0)
    80202aaa:	7fdc                	ld	a5,184(a5)
    80202aac:	fef43423          	sd	a5,-24(s0)
    pte_t *pte = walk_lookup(pt, page_va);
    80202ab0:	fd843583          	ld	a1,-40(s0)
    80202ab4:	fe843503          	ld	a0,-24(s0)
    80202ab8:	fffff097          	auipc	ra,0xfffff
    80202abc:	698080e7          	jalr	1688(ra) # 80202150 <walk_lookup>
    80202ac0:	fca43423          	sd	a0,-56(s0)
    if (pte && (*pte & PTE_V)) {
    80202ac4:	fc843783          	ld	a5,-56(s0)
    80202ac8:	c3dd                	beqz	a5,80202b6e <handle_page_fault+0x152>
    80202aca:	fc843783          	ld	a5,-56(s0)
    80202ace:	639c                	ld	a5,0(a5)
    80202ad0:	8b85                	andi	a5,a5,1
    80202ad2:	cfd1                	beqz	a5,80202b6e <handle_page_fault+0x152>
        int need_perm = 0;
    80202ad4:	fe042223          	sw	zero,-28(s0)
        if (type == 1) need_perm = PTE_X;
    80202ad8:	fb442783          	lw	a5,-76(s0)
    80202adc:	0007871b          	sext.w	a4,a5
    80202ae0:	4785                	li	a5,1
    80202ae2:	00f71663          	bne	a4,a5,80202aee <handle_page_fault+0xd2>
    80202ae6:	47a1                	li	a5,8
    80202ae8:	fef42223          	sw	a5,-28(s0)
    80202aec:	a035                	j	80202b18 <handle_page_fault+0xfc>
        else if (type == 2) need_perm = PTE_R;
    80202aee:	fb442783          	lw	a5,-76(s0)
    80202af2:	0007871b          	sext.w	a4,a5
    80202af6:	4789                	li	a5,2
    80202af8:	00f71663          	bne	a4,a5,80202b04 <handle_page_fault+0xe8>
    80202afc:	4789                	li	a5,2
    80202afe:	fef42223          	sw	a5,-28(s0)
    80202b02:	a819                	j	80202b18 <handle_page_fault+0xfc>
        else if (type == 3) need_perm = PTE_R | PTE_W;
    80202b04:	fb442783          	lw	a5,-76(s0)
    80202b08:	0007871b          	sext.w	a4,a5
    80202b0c:	478d                	li	a5,3
    80202b0e:	00f71563          	bne	a4,a5,80202b18 <handle_page_fault+0xfc>
    80202b12:	4799                	li	a5,6
    80202b14:	fef42223          	sw	a5,-28(s0)
        if ((*pte & need_perm) != need_perm) {
    80202b18:	fc843783          	ld	a5,-56(s0)
    80202b1c:	6398                	ld	a4,0(a5)
    80202b1e:	fe442783          	lw	a5,-28(s0)
    80202b22:	8f7d                	and	a4,a4,a5
    80202b24:	fe442783          	lw	a5,-28(s0)
    80202b28:	02f70963          	beq	a4,a5,80202b5a <handle_page_fault+0x13e>
            *pte |= need_perm;
    80202b2c:	fc843783          	ld	a5,-56(s0)
    80202b30:	6398                	ld	a4,0(a5)
    80202b32:	fe442783          	lw	a5,-28(s0)
    80202b36:	8f5d                	or	a4,a4,a5
    80202b38:	fc843783          	ld	a5,-56(s0)
    80202b3c:	e398                	sd	a4,0(a5)
            sfence_vma();
    80202b3e:	00000097          	auipc	ra,0x0
    80202b42:	d24080e7          	jalr	-732(ra) # 80202862 <sfence_vma>
            printf("[PAGE FAULT] 已更新页面权限\n");
    80202b46:	00010517          	auipc	a0,0x10
    80202b4a:	7a250513          	addi	a0,a0,1954 # 802132e8 <user_test_table+0x428>
    80202b4e:	ffffe097          	auipc	ra,0xffffe
    80202b52:	1e0080e7          	jalr	480(ra) # 80200d2e <printf>
            return 1;
    80202b56:	4785                	li	a5,1
    80202b58:	a8d5                	j	80202c4c <handle_page_fault+0x230>
        printf("[PAGE FAULT] 页面已映射且权限正确\n");
    80202b5a:	00010517          	auipc	a0,0x10
    80202b5e:	7b650513          	addi	a0,a0,1974 # 80213310 <user_test_table+0x450>
    80202b62:	ffffe097          	auipc	ra,0xffffe
    80202b66:	1cc080e7          	jalr	460(ra) # 80200d2e <printf>
        return 1;
    80202b6a:	4785                	li	a5,1
    80202b6c:	a0c5                	j	80202c4c <handle_page_fault+0x230>
    void* page = alloc_page();
    80202b6e:	00000097          	auipc	ra,0x0
    80202b72:	752080e7          	jalr	1874(ra) # 802032c0 <alloc_page>
    80202b76:	fca43023          	sd	a0,-64(s0)
    if (page == 0) {
    80202b7a:	fc043783          	ld	a5,-64(s0)
    80202b7e:	eb99                	bnez	a5,80202b94 <handle_page_fault+0x178>
        printf("[PAGE FAULT] 内存不足，无法分配页面\n");
    80202b80:	00010517          	auipc	a0,0x10
    80202b84:	7c050513          	addi	a0,a0,1984 # 80213340 <user_test_table+0x480>
    80202b88:	ffffe097          	auipc	ra,0xffffe
    80202b8c:	1a6080e7          	jalr	422(ra) # 80200d2e <printf>
        return 0;
    80202b90:	4781                	li	a5,0
    80202b92:	a86d                	j	80202c4c <handle_page_fault+0x230>
    memset(page, 0, PGSIZE);
    80202b94:	6605                	lui	a2,0x1
    80202b96:	4581                	li	a1,0
    80202b98:	fc043503          	ld	a0,-64(s0)
    80202b9c:	fffff097          	auipc	ra,0xfffff
    80202ba0:	31c080e7          	jalr	796(ra) # 80201eb8 <memset>
    int perm = 0;
    80202ba4:	fe042023          	sw	zero,-32(s0)
    if (type == 1) perm = PTE_X | PTE_R | PTE_U;
    80202ba8:	fb442783          	lw	a5,-76(s0)
    80202bac:	0007871b          	sext.w	a4,a5
    80202bb0:	4785                	li	a5,1
    80202bb2:	00f71663          	bne	a4,a5,80202bbe <handle_page_fault+0x1a2>
    80202bb6:	47e9                	li	a5,26
    80202bb8:	fef42023          	sw	a5,-32(s0)
    80202bbc:	a035                	j	80202be8 <handle_page_fault+0x1cc>
    else if (type == 2) perm = PTE_R | PTE_U;
    80202bbe:	fb442783          	lw	a5,-76(s0)
    80202bc2:	0007871b          	sext.w	a4,a5
    80202bc6:	4789                	li	a5,2
    80202bc8:	00f71663          	bne	a4,a5,80202bd4 <handle_page_fault+0x1b8>
    80202bcc:	47c9                	li	a5,18
    80202bce:	fef42023          	sw	a5,-32(s0)
    80202bd2:	a819                	j	80202be8 <handle_page_fault+0x1cc>
    else if (type == 3) perm = PTE_R | PTE_W | PTE_U;
    80202bd4:	fb442783          	lw	a5,-76(s0)
    80202bd8:	0007871b          	sext.w	a4,a5
    80202bdc:	478d                	li	a5,3
    80202bde:	00f71563          	bne	a4,a5,80202be8 <handle_page_fault+0x1cc>
    80202be2:	47d9                	li	a5,22
    80202be4:	fef42023          	sw	a5,-32(s0)
    if (map_page(pt, page_va, (uint64)page, perm) != 0) {
    80202be8:	fc043783          	ld	a5,-64(s0)
    80202bec:	fe042703          	lw	a4,-32(s0)
    80202bf0:	86ba                	mv	a3,a4
    80202bf2:	863e                	mv	a2,a5
    80202bf4:	fd843583          	ld	a1,-40(s0)
    80202bf8:	fe843503          	ld	a0,-24(s0)
    80202bfc:	fffff097          	auipc	ra,0xfffff
    80202c00:	788080e7          	jalr	1928(ra) # 80202384 <map_page>
    80202c04:	87aa                	mv	a5,a0
    80202c06:	c38d                	beqz	a5,80202c28 <handle_page_fault+0x20c>
        free_page(page);
    80202c08:	fc043503          	ld	a0,-64(s0)
    80202c0c:	00000097          	auipc	ra,0x0
    80202c10:	720080e7          	jalr	1824(ra) # 8020332c <free_page>
        printf("[PAGE FAULT] 页面映射失败\n");
    80202c14:	00010517          	auipc	a0,0x10
    80202c18:	75c50513          	addi	a0,a0,1884 # 80213370 <user_test_table+0x4b0>
    80202c1c:	ffffe097          	auipc	ra,0xffffe
    80202c20:	112080e7          	jalr	274(ra) # 80200d2e <printf>
        return 0;
    80202c24:	4781                	li	a5,0
    80202c26:	a01d                	j	80202c4c <handle_page_fault+0x230>
    sfence_vma();
    80202c28:	00000097          	auipc	ra,0x0
    80202c2c:	c3a080e7          	jalr	-966(ra) # 80202862 <sfence_vma>
    printf("[PAGE FAULT] 成功分配并映射页面 0x%lx -> 0x%lx\n", page_va, (uint64)page);
    80202c30:	fc043783          	ld	a5,-64(s0)
    80202c34:	863e                	mv	a2,a5
    80202c36:	fd843583          	ld	a1,-40(s0)
    80202c3a:	00010517          	auipc	a0,0x10
    80202c3e:	75e50513          	addi	a0,a0,1886 # 80213398 <user_test_table+0x4d8>
    80202c42:	ffffe097          	auipc	ra,0xffffe
    80202c46:	0ec080e7          	jalr	236(ra) # 80200d2e <printf>
    return 1;
    80202c4a:	4785                	li	a5,1
}
    80202c4c:	853e                	mv	a0,a5
    80202c4e:	60a6                	ld	ra,72(sp)
    80202c50:	6406                	ld	s0,64(sp)
    80202c52:	6161                	addi	sp,sp,80
    80202c54:	8082                	ret

0000000080202c56 <test_pagetable>:
void test_pagetable(void) {
    80202c56:	7155                	addi	sp,sp,-208
    80202c58:	e586                	sd	ra,200(sp)
    80202c5a:	e1a2                	sd	s0,192(sp)
    80202c5c:	fd26                	sd	s1,184(sp)
    80202c5e:	f94a                	sd	s2,176(sp)
    80202c60:	f54e                	sd	s3,168(sp)
    80202c62:	f152                	sd	s4,160(sp)
    80202c64:	ed56                	sd	s5,152(sp)
    80202c66:	e95a                	sd	s6,144(sp)
    80202c68:	e55e                	sd	s7,136(sp)
    80202c6a:	e162                	sd	s8,128(sp)
    80202c6c:	fce6                	sd	s9,120(sp)
    80202c6e:	0980                	addi	s0,sp,208
    80202c70:	878a                	mv	a5,sp
    80202c72:	84be                	mv	s1,a5
    printf("[PT TEST] 创建页表...\n");
    80202c74:	00010517          	auipc	a0,0x10
    80202c78:	76450513          	addi	a0,a0,1892 # 802133d8 <user_test_table+0x518>
    80202c7c:	ffffe097          	auipc	ra,0xffffe
    80202c80:	0b2080e7          	jalr	178(ra) # 80200d2e <printf>
    pagetable_t pt = create_pagetable();
    80202c84:	fffff097          	auipc	ra,0xfffff
    80202c88:	490080e7          	jalr	1168(ra) # 80202114 <create_pagetable>
    80202c8c:	f8a43423          	sd	a0,-120(s0)
    assert(pt != 0);
    80202c90:	f8843783          	ld	a5,-120(s0)
    80202c94:	00f037b3          	snez	a5,a5
    80202c98:	0ff7f793          	zext.b	a5,a5
    80202c9c:	2781                	sext.w	a5,a5
    80202c9e:	853e                	mv	a0,a5
    80202ca0:	fffff097          	auipc	ra,0xfffff
    80202ca4:	38a080e7          	jalr	906(ra) # 8020202a <assert>
    printf("[PT TEST] 页表创建通过\n");
    80202ca8:	00010517          	auipc	a0,0x10
    80202cac:	75050513          	addi	a0,a0,1872 # 802133f8 <user_test_table+0x538>
    80202cb0:	ffffe097          	auipc	ra,0xffffe
    80202cb4:	07e080e7          	jalr	126(ra) # 80200d2e <printf>
    uint64 va[] = {
    80202cb8:	00011797          	auipc	a5,0x11
    80202cbc:	90078793          	addi	a5,a5,-1792 # 802135b8 <user_test_table+0x6f8>
    80202cc0:	638c                	ld	a1,0(a5)
    80202cc2:	6790                	ld	a2,8(a5)
    80202cc4:	6b94                	ld	a3,16(a5)
    80202cc6:	6f98                	ld	a4,24(a5)
    80202cc8:	739c                	ld	a5,32(a5)
    80202cca:	f2b43c23          	sd	a1,-200(s0)
    80202cce:	f4c43023          	sd	a2,-192(s0)
    80202cd2:	f4d43423          	sd	a3,-184(s0)
    80202cd6:	f4e43823          	sd	a4,-176(s0)
    80202cda:	f4f43c23          	sd	a5,-168(s0)
    int n = sizeof(va) / sizeof(va[0]);
    80202cde:	4795                	li	a5,5
    80202ce0:	f8f42223          	sw	a5,-124(s0)
    uint64 pa[n];
    80202ce4:	f8442783          	lw	a5,-124(s0)
    80202ce8:	873e                	mv	a4,a5
    80202cea:	177d                	addi	a4,a4,-1
    80202cec:	f6e43c23          	sd	a4,-136(s0)
    80202cf0:	873e                	mv	a4,a5
    80202cf2:	8c3a                	mv	s8,a4
    80202cf4:	4c81                	li	s9,0
    80202cf6:	03ac5713          	srli	a4,s8,0x3a
    80202cfa:	006c9a93          	slli	s5,s9,0x6
    80202cfe:	01576ab3          	or	s5,a4,s5
    80202d02:	006c1a13          	slli	s4,s8,0x6
    80202d06:	873e                	mv	a4,a5
    80202d08:	8b3a                	mv	s6,a4
    80202d0a:	4b81                	li	s7,0
    80202d0c:	03ab5713          	srli	a4,s6,0x3a
    80202d10:	006b9993          	slli	s3,s7,0x6
    80202d14:	013769b3          	or	s3,a4,s3
    80202d18:	006b1913          	slli	s2,s6,0x6
    80202d1c:	078e                	slli	a5,a5,0x3
    80202d1e:	07bd                	addi	a5,a5,15
    80202d20:	8391                	srli	a5,a5,0x4
    80202d22:	0792                	slli	a5,a5,0x4
    80202d24:	40f10133          	sub	sp,sp,a5
    80202d28:	878a                	mv	a5,sp
    80202d2a:	079d                	addi	a5,a5,7
    80202d2c:	838d                	srli	a5,a5,0x3
    80202d2e:	078e                	slli	a5,a5,0x3
    80202d30:	f6f43823          	sd	a5,-144(s0)
    for (int i = 0; i < n; i++) {
    80202d34:	f8042e23          	sw	zero,-100(s0)
    80202d38:	a201                	j	80202e38 <test_pagetable+0x1e2>
        pa[i] = (uint64)alloc_page();
    80202d3a:	00000097          	auipc	ra,0x0
    80202d3e:	586080e7          	jalr	1414(ra) # 802032c0 <alloc_page>
    80202d42:	87aa                	mv	a5,a0
    80202d44:	86be                	mv	a3,a5
    80202d46:	f7043703          	ld	a4,-144(s0)
    80202d4a:	f9c42783          	lw	a5,-100(s0)
    80202d4e:	078e                	slli	a5,a5,0x3
    80202d50:	97ba                	add	a5,a5,a4
    80202d52:	e394                	sd	a3,0(a5)
        assert(pa[i]);
    80202d54:	f7043703          	ld	a4,-144(s0)
    80202d58:	f9c42783          	lw	a5,-100(s0)
    80202d5c:	078e                	slli	a5,a5,0x3
    80202d5e:	97ba                	add	a5,a5,a4
    80202d60:	639c                	ld	a5,0(a5)
    80202d62:	2781                	sext.w	a5,a5
    80202d64:	853e                	mv	a0,a5
    80202d66:	fffff097          	auipc	ra,0xfffff
    80202d6a:	2c4080e7          	jalr	708(ra) # 8020202a <assert>
        printf("[PT TEST] 分配物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202d6e:	f7043703          	ld	a4,-144(s0)
    80202d72:	f9c42783          	lw	a5,-100(s0)
    80202d76:	078e                	slli	a5,a5,0x3
    80202d78:	97ba                	add	a5,a5,a4
    80202d7a:	6398                	ld	a4,0(a5)
    80202d7c:	f9c42783          	lw	a5,-100(s0)
    80202d80:	863a                	mv	a2,a4
    80202d82:	85be                	mv	a1,a5
    80202d84:	00010517          	auipc	a0,0x10
    80202d88:	69450513          	addi	a0,a0,1684 # 80213418 <user_test_table+0x558>
    80202d8c:	ffffe097          	auipc	ra,0xffffe
    80202d90:	fa2080e7          	jalr	-94(ra) # 80200d2e <printf>
        int ret = map_page(pt, va[i], pa[i], PTE_R | PTE_W);
    80202d94:	f9c42783          	lw	a5,-100(s0)
    80202d98:	078e                	slli	a5,a5,0x3
    80202d9a:	fa078793          	addi	a5,a5,-96
    80202d9e:	97a2                	add	a5,a5,s0
    80202da0:	f987b583          	ld	a1,-104(a5)
    80202da4:	f7043703          	ld	a4,-144(s0)
    80202da8:	f9c42783          	lw	a5,-100(s0)
    80202dac:	078e                	slli	a5,a5,0x3
    80202dae:	97ba                	add	a5,a5,a4
    80202db0:	639c                	ld	a5,0(a5)
    80202db2:	4699                	li	a3,6
    80202db4:	863e                	mv	a2,a5
    80202db6:	f8843503          	ld	a0,-120(s0)
    80202dba:	fffff097          	auipc	ra,0xfffff
    80202dbe:	5ca080e7          	jalr	1482(ra) # 80202384 <map_page>
    80202dc2:	87aa                	mv	a5,a0
    80202dc4:	f6f42223          	sw	a5,-156(s0)
        printf("[PT TEST] 映射 va=0x%lx -> pa=0x%lx %s\n", va[i], pa[i], ret == 0 ? "成功" : "失败");
    80202dc8:	f9c42783          	lw	a5,-100(s0)
    80202dcc:	078e                	slli	a5,a5,0x3
    80202dce:	fa078793          	addi	a5,a5,-96
    80202dd2:	97a2                	add	a5,a5,s0
    80202dd4:	f987b583          	ld	a1,-104(a5)
    80202dd8:	f7043703          	ld	a4,-144(s0)
    80202ddc:	f9c42783          	lw	a5,-100(s0)
    80202de0:	078e                	slli	a5,a5,0x3
    80202de2:	97ba                	add	a5,a5,a4
    80202de4:	6398                	ld	a4,0(a5)
    80202de6:	f6442783          	lw	a5,-156(s0)
    80202dea:	2781                	sext.w	a5,a5
    80202dec:	e791                	bnez	a5,80202df8 <test_pagetable+0x1a2>
    80202dee:	00010797          	auipc	a5,0x10
    80202df2:	65278793          	addi	a5,a5,1618 # 80213440 <user_test_table+0x580>
    80202df6:	a029                	j	80202e00 <test_pagetable+0x1aa>
    80202df8:	00010797          	auipc	a5,0x10
    80202dfc:	65078793          	addi	a5,a5,1616 # 80213448 <user_test_table+0x588>
    80202e00:	86be                	mv	a3,a5
    80202e02:	863a                	mv	a2,a4
    80202e04:	00010517          	auipc	a0,0x10
    80202e08:	64c50513          	addi	a0,a0,1612 # 80213450 <user_test_table+0x590>
    80202e0c:	ffffe097          	auipc	ra,0xffffe
    80202e10:	f22080e7          	jalr	-222(ra) # 80200d2e <printf>
        assert(ret == 0);
    80202e14:	f6442783          	lw	a5,-156(s0)
    80202e18:	2781                	sext.w	a5,a5
    80202e1a:	0017b793          	seqz	a5,a5
    80202e1e:	0ff7f793          	zext.b	a5,a5
    80202e22:	2781                	sext.w	a5,a5
    80202e24:	853e                	mv	a0,a5
    80202e26:	fffff097          	auipc	ra,0xfffff
    80202e2a:	204080e7          	jalr	516(ra) # 8020202a <assert>
    for (int i = 0; i < n; i++) {
    80202e2e:	f9c42783          	lw	a5,-100(s0)
    80202e32:	2785                	addiw	a5,a5,1
    80202e34:	f8f42e23          	sw	a5,-100(s0)
    80202e38:	f9c42783          	lw	a5,-100(s0)
    80202e3c:	873e                	mv	a4,a5
    80202e3e:	f8442783          	lw	a5,-124(s0)
    80202e42:	2701                	sext.w	a4,a4
    80202e44:	2781                	sext.w	a5,a5
    80202e46:	eef74ae3          	blt	a4,a5,80202d3a <test_pagetable+0xe4>
    printf("[PT TEST] 多级映射测试通过\n");
    80202e4a:	00010517          	auipc	a0,0x10
    80202e4e:	63650513          	addi	a0,a0,1590 # 80213480 <user_test_table+0x5c0>
    80202e52:	ffffe097          	auipc	ra,0xffffe
    80202e56:	edc080e7          	jalr	-292(ra) # 80200d2e <printf>
    for (int i = 0; i < n; i++) {
    80202e5a:	f8042c23          	sw	zero,-104(s0)
    80202e5e:	a861                	j	80202ef6 <test_pagetable+0x2a0>
        pte_t *pte = walk_lookup(pt, va[i]);
    80202e60:	f9842783          	lw	a5,-104(s0)
    80202e64:	078e                	slli	a5,a5,0x3
    80202e66:	fa078793          	addi	a5,a5,-96
    80202e6a:	97a2                	add	a5,a5,s0
    80202e6c:	f987b783          	ld	a5,-104(a5)
    80202e70:	85be                	mv	a1,a5
    80202e72:	f8843503          	ld	a0,-120(s0)
    80202e76:	fffff097          	auipc	ra,0xfffff
    80202e7a:	2da080e7          	jalr	730(ra) # 80202150 <walk_lookup>
    80202e7e:	f6a43423          	sd	a0,-152(s0)
        if (pte && (*pte & PTE_V)) {
    80202e82:	f6843783          	ld	a5,-152(s0)
    80202e86:	c3b1                	beqz	a5,80202eca <test_pagetable+0x274>
    80202e88:	f6843783          	ld	a5,-152(s0)
    80202e8c:	639c                	ld	a5,0(a5)
    80202e8e:	8b85                	andi	a5,a5,1
    80202e90:	cf8d                	beqz	a5,80202eca <test_pagetable+0x274>
            printf("[PT TEST] 检查映射: va=0x%lx -> pa=0x%lx, pte=0x%lx\n", va[i], PTE2PA(*pte), *pte);
    80202e92:	f9842783          	lw	a5,-104(s0)
    80202e96:	078e                	slli	a5,a5,0x3
    80202e98:	fa078793          	addi	a5,a5,-96
    80202e9c:	97a2                	add	a5,a5,s0
    80202e9e:	f987b703          	ld	a4,-104(a5)
    80202ea2:	f6843783          	ld	a5,-152(s0)
    80202ea6:	639c                	ld	a5,0(a5)
    80202ea8:	83a9                	srli	a5,a5,0xa
    80202eaa:	00c79613          	slli	a2,a5,0xc
    80202eae:	f6843783          	ld	a5,-152(s0)
    80202eb2:	639c                	ld	a5,0(a5)
    80202eb4:	86be                	mv	a3,a5
    80202eb6:	85ba                	mv	a1,a4
    80202eb8:	00010517          	auipc	a0,0x10
    80202ebc:	5f050513          	addi	a0,a0,1520 # 802134a8 <user_test_table+0x5e8>
    80202ec0:	ffffe097          	auipc	ra,0xffffe
    80202ec4:	e6e080e7          	jalr	-402(ra) # 80200d2e <printf>
    80202ec8:	a015                	j	80202eec <test_pagetable+0x296>
            printf("[PT TEST] 检查映射: va=0x%lx 未映射\n", va[i]);
    80202eca:	f9842783          	lw	a5,-104(s0)
    80202ece:	078e                	slli	a5,a5,0x3
    80202ed0:	fa078793          	addi	a5,a5,-96
    80202ed4:	97a2                	add	a5,a5,s0
    80202ed6:	f987b783          	ld	a5,-104(a5)
    80202eda:	85be                	mv	a1,a5
    80202edc:	00010517          	auipc	a0,0x10
    80202ee0:	60c50513          	addi	a0,a0,1548 # 802134e8 <user_test_table+0x628>
    80202ee4:	ffffe097          	auipc	ra,0xffffe
    80202ee8:	e4a080e7          	jalr	-438(ra) # 80200d2e <printf>
    for (int i = 0; i < n; i++) {
    80202eec:	f9842783          	lw	a5,-104(s0)
    80202ef0:	2785                	addiw	a5,a5,1
    80202ef2:	f8f42c23          	sw	a5,-104(s0)
    80202ef6:	f9842783          	lw	a5,-104(s0)
    80202efa:	873e                	mv	a4,a5
    80202efc:	f8442783          	lw	a5,-124(s0)
    80202f00:	2701                	sext.w	a4,a4
    80202f02:	2781                	sext.w	a5,a5
    80202f04:	f4f74ee3          	blt	a4,a5,80202e60 <test_pagetable+0x20a>
    printf("[PT TEST] 打印页表结构（递归）\n");
    80202f08:	00010517          	auipc	a0,0x10
    80202f0c:	61050513          	addi	a0,a0,1552 # 80213518 <user_test_table+0x658>
    80202f10:	ffffe097          	auipc	ra,0xffffe
    80202f14:	e1e080e7          	jalr	-482(ra) # 80200d2e <printf>
    print_pagetable(pt, 0, 0);
    80202f18:	4601                	li	a2,0
    80202f1a:	4581                	li	a1,0
    80202f1c:	f8843503          	ld	a0,-120(s0)
    80202f20:	00000097          	auipc	ra,0x0
    80202f24:	9e6080e7          	jalr	-1562(ra) # 80202906 <print_pagetable>
    for (int i = 0; i < n; i++) {
    80202f28:	f8042a23          	sw	zero,-108(s0)
    80202f2c:	a0a9                	j	80202f76 <test_pagetable+0x320>
        free_page((void*)pa[i]);
    80202f2e:	f7043703          	ld	a4,-144(s0)
    80202f32:	f9442783          	lw	a5,-108(s0)
    80202f36:	078e                	slli	a5,a5,0x3
    80202f38:	97ba                	add	a5,a5,a4
    80202f3a:	639c                	ld	a5,0(a5)
    80202f3c:	853e                	mv	a0,a5
    80202f3e:	00000097          	auipc	ra,0x0
    80202f42:	3ee080e7          	jalr	1006(ra) # 8020332c <free_page>
        printf("[PT TEST] 释放物理页 pa[%d]=0x%lx\n", i, pa[i]);
    80202f46:	f7043703          	ld	a4,-144(s0)
    80202f4a:	f9442783          	lw	a5,-108(s0)
    80202f4e:	078e                	slli	a5,a5,0x3
    80202f50:	97ba                	add	a5,a5,a4
    80202f52:	6398                	ld	a4,0(a5)
    80202f54:	f9442783          	lw	a5,-108(s0)
    80202f58:	863a                	mv	a2,a4
    80202f5a:	85be                	mv	a1,a5
    80202f5c:	00010517          	auipc	a0,0x10
    80202f60:	5ec50513          	addi	a0,a0,1516 # 80213548 <user_test_table+0x688>
    80202f64:	ffffe097          	auipc	ra,0xffffe
    80202f68:	dca080e7          	jalr	-566(ra) # 80200d2e <printf>
    for (int i = 0; i < n; i++) {
    80202f6c:	f9442783          	lw	a5,-108(s0)
    80202f70:	2785                	addiw	a5,a5,1
    80202f72:	f8f42a23          	sw	a5,-108(s0)
    80202f76:	f9442783          	lw	a5,-108(s0)
    80202f7a:	873e                	mv	a4,a5
    80202f7c:	f8442783          	lw	a5,-124(s0)
    80202f80:	2701                	sext.w	a4,a4
    80202f82:	2781                	sext.w	a5,a5
    80202f84:	faf745e3          	blt	a4,a5,80202f2e <test_pagetable+0x2d8>
    free_pagetable(pt);
    80202f88:	f8843503          	ld	a0,-120(s0)
    80202f8c:	fffff097          	auipc	ra,0xfffff
    80202f90:	56c080e7          	jalr	1388(ra) # 802024f8 <free_pagetable>
    printf("[PT TEST] 释放页表完成\n");
    80202f94:	00010517          	auipc	a0,0x10
    80202f98:	5dc50513          	addi	a0,a0,1500 # 80213570 <user_test_table+0x6b0>
    80202f9c:	ffffe097          	auipc	ra,0xffffe
    80202fa0:	d92080e7          	jalr	-622(ra) # 80200d2e <printf>
    printf("[PT TEST] 所有页表测试通过\n");
    80202fa4:	00010517          	auipc	a0,0x10
    80202fa8:	5ec50513          	addi	a0,a0,1516 # 80213590 <user_test_table+0x6d0>
    80202fac:	ffffe097          	auipc	ra,0xffffe
    80202fb0:	d82080e7          	jalr	-638(ra) # 80200d2e <printf>
    80202fb4:	8126                	mv	sp,s1
}
    80202fb6:	0001                	nop
    80202fb8:	f3040113          	addi	sp,s0,-208
    80202fbc:	60ae                	ld	ra,200(sp)
    80202fbe:	640e                	ld	s0,192(sp)
    80202fc0:	74ea                	ld	s1,184(sp)
    80202fc2:	794a                	ld	s2,176(sp)
    80202fc4:	79aa                	ld	s3,168(sp)
    80202fc6:	7a0a                	ld	s4,160(sp)
    80202fc8:	6aea                	ld	s5,152(sp)
    80202fca:	6b4a                	ld	s6,144(sp)
    80202fcc:	6baa                	ld	s7,136(sp)
    80202fce:	6c0a                	ld	s8,128(sp)
    80202fd0:	7ce6                	ld	s9,120(sp)
    80202fd2:	6169                	addi	sp,sp,208
    80202fd4:	8082                	ret

0000000080202fd6 <check_mapping>:
void check_mapping(uint64 va) {
    80202fd6:	7179                	addi	sp,sp,-48
    80202fd8:	f406                	sd	ra,40(sp)
    80202fda:	f022                	sd	s0,32(sp)
    80202fdc:	1800                	addi	s0,sp,48
    80202fde:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(kernel_pagetable, va);
    80202fe2:	00024797          	auipc	a5,0x24
    80202fe6:	0ae78793          	addi	a5,a5,174 # 80227090 <kernel_pagetable>
    80202fea:	639c                	ld	a5,0(a5)
    80202fec:	fd843583          	ld	a1,-40(s0)
    80202ff0:	853e                	mv	a0,a5
    80202ff2:	fffff097          	auipc	ra,0xfffff
    80202ff6:	15e080e7          	jalr	350(ra) # 80202150 <walk_lookup>
    80202ffa:	fea43423          	sd	a0,-24(s0)
    if(pte && (*pte & PTE_V)) {
    80202ffe:	fe843783          	ld	a5,-24(s0)
    80203002:	cbb9                	beqz	a5,80203058 <check_mapping+0x82>
    80203004:	fe843783          	ld	a5,-24(s0)
    80203008:	639c                	ld	a5,0(a5)
    8020300a:	8b85                	andi	a5,a5,1
    8020300c:	c7b1                	beqz	a5,80203058 <check_mapping+0x82>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    8020300e:	fe843783          	ld	a5,-24(s0)
    80203012:	639c                	ld	a5,0(a5)
    80203014:	863e                	mv	a2,a5
    80203016:	fd843583          	ld	a1,-40(s0)
    8020301a:	00010517          	auipc	a0,0x10
    8020301e:	5c650513          	addi	a0,a0,1478 # 802135e0 <user_test_table+0x720>
    80203022:	ffffe097          	auipc	ra,0xffffe
    80203026:	d0c080e7          	jalr	-756(ra) # 80200d2e <printf>
		volatile unsigned char *p = (unsigned char*)va;
    8020302a:	fd843783          	ld	a5,-40(s0)
    8020302e:	fef43023          	sd	a5,-32(s0)
        printf("Try to read [0x%lx]: 0x%02x\n", va, *p);
    80203032:	fe043783          	ld	a5,-32(s0)
    80203036:	0007c783          	lbu	a5,0(a5)
    8020303a:	0ff7f793          	zext.b	a5,a5
    8020303e:	2781                	sext.w	a5,a5
    80203040:	863e                	mv	a2,a5
    80203042:	fd843583          	ld	a1,-40(s0)
    80203046:	00010517          	auipc	a0,0x10
    8020304a:	5c250513          	addi	a0,a0,1474 # 80213608 <user_test_table+0x748>
    8020304e:	ffffe097          	auipc	ra,0xffffe
    80203052:	ce0080e7          	jalr	-800(ra) # 80200d2e <printf>
    if(pte && (*pte & PTE_V)) {
    80203056:	a821                	j	8020306e <check_mapping+0x98>
        printf("Address 0x%lx is NOT mapped\n", va);
    80203058:	fd843583          	ld	a1,-40(s0)
    8020305c:	00010517          	auipc	a0,0x10
    80203060:	5cc50513          	addi	a0,a0,1484 # 80213628 <user_test_table+0x768>
    80203064:	ffffe097          	auipc	ra,0xffffe
    80203068:	cca080e7          	jalr	-822(ra) # 80200d2e <printf>
}
    8020306c:	0001                	nop
    8020306e:	0001                	nop
    80203070:	70a2                	ld	ra,40(sp)
    80203072:	7402                	ld	s0,32(sp)
    80203074:	6145                	addi	sp,sp,48
    80203076:	8082                	ret

0000000080203078 <check_is_mapped>:
int check_is_mapped(uint64 va) {
    80203078:	7179                	addi	sp,sp,-48
    8020307a:	f406                	sd	ra,40(sp)
    8020307c:	f022                	sd	s0,32(sp)
    8020307e:	1800                	addi	s0,sp,48
    80203080:	fca43c23          	sd	a0,-40(s0)
    pte_t *pte = walk_lookup(get_current_pagetable(), va);
    80203084:	00000097          	auipc	ra,0x0
    80203088:	86a080e7          	jalr	-1942(ra) # 802028ee <get_current_pagetable>
    8020308c:	87aa                	mv	a5,a0
    8020308e:	fd843583          	ld	a1,-40(s0)
    80203092:	853e                	mv	a0,a5
    80203094:	fffff097          	auipc	ra,0xfffff
    80203098:	0bc080e7          	jalr	188(ra) # 80202150 <walk_lookup>
    8020309c:	fea43423          	sd	a0,-24(s0)
    if (pte && (*pte & PTE_V)) {
    802030a0:	fe843783          	ld	a5,-24(s0)
    802030a4:	c795                	beqz	a5,802030d0 <check_is_mapped+0x58>
    802030a6:	fe843783          	ld	a5,-24(s0)
    802030aa:	639c                	ld	a5,0(a5)
    802030ac:	8b85                	andi	a5,a5,1
    802030ae:	c38d                	beqz	a5,802030d0 <check_is_mapped+0x58>
        printf("Address 0x%lx is mapped: pte=0x%lx\n", va, *pte);
    802030b0:	fe843783          	ld	a5,-24(s0)
    802030b4:	639c                	ld	a5,0(a5)
    802030b6:	863e                	mv	a2,a5
    802030b8:	fd843583          	ld	a1,-40(s0)
    802030bc:	00010517          	auipc	a0,0x10
    802030c0:	52450513          	addi	a0,a0,1316 # 802135e0 <user_test_table+0x720>
    802030c4:	ffffe097          	auipc	ra,0xffffe
    802030c8:	c6a080e7          	jalr	-918(ra) # 80200d2e <printf>
        return 1;
    802030cc:	4785                	li	a5,1
    802030ce:	a821                	j	802030e6 <check_is_mapped+0x6e>
        printf("Address 0x%lx is NOT mapped\n", va);
    802030d0:	fd843583          	ld	a1,-40(s0)
    802030d4:	00010517          	auipc	a0,0x10
    802030d8:	55450513          	addi	a0,a0,1364 # 80213628 <user_test_table+0x768>
    802030dc:	ffffe097          	auipc	ra,0xffffe
    802030e0:	c52080e7          	jalr	-942(ra) # 80200d2e <printf>
        return 0;
    802030e4:	4781                	li	a5,0
}
    802030e6:	853e                	mv	a0,a5
    802030e8:	70a2                	ld	ra,40(sp)
    802030ea:	7402                	ld	s0,32(sp)
    802030ec:	6145                	addi	sp,sp,48
    802030ee:	8082                	ret

00000000802030f0 <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    802030f0:	711d                	addi	sp,sp,-96
    802030f2:	ec86                	sd	ra,88(sp)
    802030f4:	e8a2                	sd	s0,80(sp)
    802030f6:	1080                	addi	s0,sp,96
    802030f8:	faa43c23          	sd	a0,-72(s0)
    802030fc:	fab43823          	sd	a1,-80(s0)
    80203100:	fac43423          	sd	a2,-88(s0)
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    80203104:	fe043423          	sd	zero,-24(s0)
    80203108:	a8d1                	j	802031dc <uvmcopy+0xec>
        pte_t *pte = walk_lookup(old, i);
    8020310a:	fe843583          	ld	a1,-24(s0)
    8020310e:	fb843503          	ld	a0,-72(s0)
    80203112:	fffff097          	auipc	ra,0xfffff
    80203116:	03e080e7          	jalr	62(ra) # 80202150 <walk_lookup>
    8020311a:	fca43c23          	sd	a0,-40(s0)
        if (pte == 0 || (*pte & PTE_V) == 0)
    8020311e:	fd843783          	ld	a5,-40(s0)
    80203122:	c7d5                	beqz	a5,802031ce <uvmcopy+0xde>
    80203124:	fd843783          	ld	a5,-40(s0)
    80203128:	639c                	ld	a5,0(a5)
    8020312a:	8b85                	andi	a5,a5,1
    8020312c:	c3cd                	beqz	a5,802031ce <uvmcopy+0xde>
        uint64 pa = PTE2PA(*pte);
    8020312e:	fd843783          	ld	a5,-40(s0)
    80203132:	639c                	ld	a5,0(a5)
    80203134:	83a9                	srli	a5,a5,0xa
    80203136:	07b2                	slli	a5,a5,0xc
    80203138:	fcf43823          	sd	a5,-48(s0)
        int flags = PTE_FLAGS(*pte);
    8020313c:	fd843783          	ld	a5,-40(s0)
    80203140:	639c                	ld	a5,0(a5)
    80203142:	2781                	sext.w	a5,a5
    80203144:	3ff7f793          	andi	a5,a5,1023
    80203148:	fef42223          	sw	a5,-28(s0)
		if (i < 0x80000000)
    8020314c:	fe843703          	ld	a4,-24(s0)
    80203150:	800007b7          	lui	a5,0x80000
    80203154:	fff7c793          	not	a5,a5
    80203158:	00e7e963          	bltu	a5,a4,8020316a <uvmcopy+0x7a>
			flags |= PTE_U;
    8020315c:	fe442783          	lw	a5,-28(s0)
    80203160:	0107e793          	ori	a5,a5,16
    80203164:	fef42223          	sw	a5,-28(s0)
    80203168:	a031                	j	80203174 <uvmcopy+0x84>
			flags &= ~PTE_U;
    8020316a:	fe442783          	lw	a5,-28(s0)
    8020316e:	9bbd                	andi	a5,a5,-17
    80203170:	fef42223          	sw	a5,-28(s0)
        void *mem = alloc_page();
    80203174:	00000097          	auipc	ra,0x0
    80203178:	14c080e7          	jalr	332(ra) # 802032c0 <alloc_page>
    8020317c:	fca43423          	sd	a0,-56(s0)
        if (mem == 0)
    80203180:	fc843783          	ld	a5,-56(s0)
    80203184:	e399                	bnez	a5,8020318a <uvmcopy+0x9a>
            return -1; // 分配失败
    80203186:	57fd                	li	a5,-1
    80203188:	a08d                	j	802031ea <uvmcopy+0xfa>
        memmove(mem, (void*)pa, PGSIZE);
    8020318a:	fd043783          	ld	a5,-48(s0)
    8020318e:	6605                	lui	a2,0x1
    80203190:	85be                	mv	a1,a5
    80203192:	fc843503          	ld	a0,-56(s0)
    80203196:	fffff097          	auipc	ra,0xfffff
    8020319a:	d72080e7          	jalr	-654(ra) # 80201f08 <memmove>
        if (map_page(new, i, (uint64)mem, flags) != 0) {
    8020319e:	fc843783          	ld	a5,-56(s0)
    802031a2:	fe442703          	lw	a4,-28(s0)
    802031a6:	86ba                	mv	a3,a4
    802031a8:	863e                	mv	a2,a5
    802031aa:	fe843583          	ld	a1,-24(s0)
    802031ae:	fb043503          	ld	a0,-80(s0)
    802031b2:	fffff097          	auipc	ra,0xfffff
    802031b6:	1d2080e7          	jalr	466(ra) # 80202384 <map_page>
    802031ba:	87aa                	mv	a5,a0
    802031bc:	cb91                	beqz	a5,802031d0 <uvmcopy+0xe0>
            free_page(mem);
    802031be:	fc843503          	ld	a0,-56(s0)
    802031c2:	00000097          	auipc	ra,0x0
    802031c6:	16a080e7          	jalr	362(ra) # 8020332c <free_page>
            return -1;
    802031ca:	57fd                	li	a5,-1
    802031cc:	a839                	j	802031ea <uvmcopy+0xfa>
            continue; // 跳过未分配的页
    802031ce:	0001                	nop
    for (uint64 i = 0; i < sz; i += PGSIZE) {
    802031d0:	fe843703          	ld	a4,-24(s0)
    802031d4:	6785                	lui	a5,0x1
    802031d6:	97ba                	add	a5,a5,a4
    802031d8:	fef43423          	sd	a5,-24(s0)
    802031dc:	fe843703          	ld	a4,-24(s0)
    802031e0:	fa843783          	ld	a5,-88(s0)
    802031e4:	f2f763e3          	bltu	a4,a5,8020310a <uvmcopy+0x1a>
    return 0;
    802031e8:	4781                	li	a5,0
    802031ea:	853e                	mv	a0,a5
    802031ec:	60e6                	ld	ra,88(sp)
    802031ee:	6446                	ld	s0,80(sp)
    802031f0:	6125                	addi	sp,sp,96
    802031f2:	8082                	ret

00000000802031f4 <assert>:
    802031f4:	1101                	addi	sp,sp,-32
    802031f6:	ec06                	sd	ra,24(sp)
    802031f8:	e822                	sd	s0,16(sp)
    802031fa:	1000                	addi	s0,sp,32
    802031fc:	87aa                	mv	a5,a0
    802031fe:	fef42623          	sw	a5,-20(s0)
    80203202:	fec42783          	lw	a5,-20(s0)
    80203206:	2781                	sext.w	a5,a5
    80203208:	e79d                	bnez	a5,80203236 <assert+0x42>
    8020320a:	1b700613          	li	a2,439
    8020320e:	00012597          	auipc	a1,0x12
    80203212:	44a58593          	addi	a1,a1,1098 # 80215658 <user_test_table+0x60>
    80203216:	00012517          	auipc	a0,0x12
    8020321a:	45250513          	addi	a0,a0,1106 # 80215668 <user_test_table+0x70>
    8020321e:	ffffe097          	auipc	ra,0xffffe
    80203222:	b10080e7          	jalr	-1264(ra) # 80200d2e <printf>
    80203226:	00012517          	auipc	a0,0x12
    8020322a:	46a50513          	addi	a0,a0,1130 # 80215690 <user_test_table+0x98>
    8020322e:	ffffe097          	auipc	ra,0xffffe
    80203232:	54c080e7          	jalr	1356(ra) # 8020177a <panic>
    80203236:	0001                	nop
    80203238:	60e2                	ld	ra,24(sp)
    8020323a:	6442                	ld	s0,16(sp)
    8020323c:	6105                	addi	sp,sp,32
    8020323e:	8082                	ret

0000000080203240 <freerange>:
static void freerange(void *pa_start, void *pa_end) {
    80203240:	7179                	addi	sp,sp,-48
    80203242:	f406                	sd	ra,40(sp)
    80203244:	f022                	sd	s0,32(sp)
    80203246:	1800                	addi	s0,sp,48
    80203248:	fca43c23          	sd	a0,-40(s0)
    8020324c:	fcb43823          	sd	a1,-48(s0)
  char *p = (char*)PGROUNDUP((uint64)pa_start);
    80203250:	fd843703          	ld	a4,-40(s0)
    80203254:	6785                	lui	a5,0x1
    80203256:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203258:	973e                	add	a4,a4,a5
    8020325a:	77fd                	lui	a5,0xfffff
    8020325c:	8ff9                	and	a5,a5,a4
    8020325e:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80203262:	a829                	j	8020327c <freerange+0x3c>
    free_page(p);
    80203264:	fe843503          	ld	a0,-24(s0)
    80203268:	00000097          	auipc	ra,0x0
    8020326c:	0c4080e7          	jalr	196(ra) # 8020332c <free_page>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80203270:	fe843703          	ld	a4,-24(s0)
    80203274:	6785                	lui	a5,0x1
    80203276:	97ba                	add	a5,a5,a4
    80203278:	fef43423          	sd	a5,-24(s0)
    8020327c:	fe843703          	ld	a4,-24(s0)
    80203280:	6785                	lui	a5,0x1
    80203282:	97ba                	add	a5,a5,a4
    80203284:	fd043703          	ld	a4,-48(s0)
    80203288:	fcf77ee3          	bgeu	a4,a5,80203264 <freerange+0x24>
}
    8020328c:	0001                	nop
    8020328e:	0001                	nop
    80203290:	70a2                	ld	ra,40(sp)
    80203292:	7402                	ld	s0,32(sp)
    80203294:	6145                	addi	sp,sp,48
    80203296:	8082                	ret

0000000080203298 <pmm_init>:
void pmm_init(void) {
    80203298:	1141                	addi	sp,sp,-16
    8020329a:	e406                	sd	ra,8(sp)
    8020329c:	e022                	sd	s0,0(sp)
    8020329e:	0800                	addi	s0,sp,16
  freerange(end, (void*)PHYSTOP);
    802032a0:	47c5                	li	a5,17
    802032a2:	01b79593          	slli	a1,a5,0x1b
    802032a6:	00024517          	auipc	a0,0x24
    802032aa:	44a50513          	addi	a0,a0,1098 # 802276f0 <_bss_end>
    802032ae:	00000097          	auipc	ra,0x0
    802032b2:	f92080e7          	jalr	-110(ra) # 80203240 <freerange>
}
    802032b6:	0001                	nop
    802032b8:	60a2                	ld	ra,8(sp)
    802032ba:	6402                	ld	s0,0(sp)
    802032bc:	0141                	addi	sp,sp,16
    802032be:	8082                	ret

00000000802032c0 <alloc_page>:
void* alloc_page(void) {
    802032c0:	1101                	addi	sp,sp,-32
    802032c2:	ec06                	sd	ra,24(sp)
    802032c4:	e822                	sd	s0,16(sp)
    802032c6:	1000                	addi	s0,sp,32
  struct run *r = freelist;
    802032c8:	00024797          	auipc	a5,0x24
    802032cc:	f9878793          	addi	a5,a5,-104 # 80227260 <freelist>
    802032d0:	639c                	ld	a5,0(a5)
    802032d2:	fef43423          	sd	a5,-24(s0)
  if(r)
    802032d6:	fe843783          	ld	a5,-24(s0)
    802032da:	cb89                	beqz	a5,802032ec <alloc_page+0x2c>
    freelist = r->next;
    802032dc:	fe843783          	ld	a5,-24(s0)
    802032e0:	6398                	ld	a4,0(a5)
    802032e2:	00024797          	auipc	a5,0x24
    802032e6:	f7e78793          	addi	a5,a5,-130 # 80227260 <freelist>
    802032ea:	e398                	sd	a4,0(a5)
  if(r)
    802032ec:	fe843783          	ld	a5,-24(s0)
    802032f0:	cf99                	beqz	a5,8020330e <alloc_page+0x4e>
    memset((char*)r + sizeof(struct run), 5, PGSIZE - sizeof(struct run));
    802032f2:	fe843783          	ld	a5,-24(s0)
    802032f6:	00878713          	addi	a4,a5,8
    802032fa:	6785                	lui	a5,0x1
    802032fc:	ff878613          	addi	a2,a5,-8 # ff8 <_entry-0x801ff008>
    80203300:	4595                	li	a1,5
    80203302:	853a                	mv	a0,a4
    80203304:	fffff097          	auipc	ra,0xfffff
    80203308:	bb4080e7          	jalr	-1100(ra) # 80201eb8 <memset>
    8020330c:	a809                	j	8020331e <alloc_page+0x5e>
    panic("alloc_page: out of memory");
    8020330e:	00012517          	auipc	a0,0x12
    80203312:	38a50513          	addi	a0,a0,906 # 80215698 <user_test_table+0xa0>
    80203316:	ffffe097          	auipc	ra,0xffffe
    8020331a:	464080e7          	jalr	1124(ra) # 8020177a <panic>
  return (void*)r;
    8020331e:	fe843783          	ld	a5,-24(s0)
}
    80203322:	853e                	mv	a0,a5
    80203324:	60e2                	ld	ra,24(sp)
    80203326:	6442                	ld	s0,16(sp)
    80203328:	6105                	addi	sp,sp,32
    8020332a:	8082                	ret

000000008020332c <free_page>:
void free_page(void* page) {
    8020332c:	7179                	addi	sp,sp,-48
    8020332e:	f406                	sd	ra,40(sp)
    80203330:	f022                	sd	s0,32(sp)
    80203332:	1800                	addi	s0,sp,48
    80203334:	fca43c23          	sd	a0,-40(s0)
  struct run *r = (struct run*)page;
    80203338:	fd843783          	ld	a5,-40(s0)
    8020333c:	fef43423          	sd	a5,-24(s0)
  if(((uint64)page % PGSIZE) != 0 || (char*)page < end || (uint64)page >= PHYSTOP)
    80203340:	fd843703          	ld	a4,-40(s0)
    80203344:	6785                	lui	a5,0x1
    80203346:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203348:	8ff9                	and	a5,a5,a4
    8020334a:	ef99                	bnez	a5,80203368 <free_page+0x3c>
    8020334c:	fd843703          	ld	a4,-40(s0)
    80203350:	00024797          	auipc	a5,0x24
    80203354:	3a078793          	addi	a5,a5,928 # 802276f0 <_bss_end>
    80203358:	00f76863          	bltu	a4,a5,80203368 <free_page+0x3c>
    8020335c:	fd843703          	ld	a4,-40(s0)
    80203360:	47c5                	li	a5,17
    80203362:	07ee                	slli	a5,a5,0x1b
    80203364:	00f76a63          	bltu	a4,a5,80203378 <free_page+0x4c>
    panic("free_page: invalid page address");
    80203368:	00012517          	auipc	a0,0x12
    8020336c:	35050513          	addi	a0,a0,848 # 802156b8 <user_test_table+0xc0>
    80203370:	ffffe097          	auipc	ra,0xffffe
    80203374:	40a080e7          	jalr	1034(ra) # 8020177a <panic>
  r->next = freelist;
    80203378:	00024797          	auipc	a5,0x24
    8020337c:	ee878793          	addi	a5,a5,-280 # 80227260 <freelist>
    80203380:	6398                	ld	a4,0(a5)
    80203382:	fe843783          	ld	a5,-24(s0)
    80203386:	e398                	sd	a4,0(a5)
  freelist = r;
    80203388:	00024797          	auipc	a5,0x24
    8020338c:	ed878793          	addi	a5,a5,-296 # 80227260 <freelist>
    80203390:	fe843703          	ld	a4,-24(s0)
    80203394:	e398                	sd	a4,0(a5)
}
    80203396:	0001                	nop
    80203398:	70a2                	ld	ra,40(sp)
    8020339a:	7402                	ld	s0,32(sp)
    8020339c:	6145                	addi	sp,sp,48
    8020339e:	8082                	ret

00000000802033a0 <test_physical_memory>:
void test_physical_memory(void) {
    802033a0:	7179                	addi	sp,sp,-48
    802033a2:	f406                	sd	ra,40(sp)
    802033a4:	f022                	sd	s0,32(sp)
    802033a6:	1800                	addi	s0,sp,48
    printf("[PM TEST] 分配两个页...\n");
    802033a8:	00012517          	auipc	a0,0x12
    802033ac:	33050513          	addi	a0,a0,816 # 802156d8 <user_test_table+0xe0>
    802033b0:	ffffe097          	auipc	ra,0xffffe
    802033b4:	97e080e7          	jalr	-1666(ra) # 80200d2e <printf>
    void *page1 = alloc_page();
    802033b8:	00000097          	auipc	ra,0x0
    802033bc:	f08080e7          	jalr	-248(ra) # 802032c0 <alloc_page>
    802033c0:	fea43423          	sd	a0,-24(s0)
    void *page2 = alloc_page();
    802033c4:	00000097          	auipc	ra,0x0
    802033c8:	efc080e7          	jalr	-260(ra) # 802032c0 <alloc_page>
    802033cc:	fea43023          	sd	a0,-32(s0)
    assert(page1 != 0);
    802033d0:	fe843783          	ld	a5,-24(s0)
    802033d4:	00f037b3          	snez	a5,a5
    802033d8:	0ff7f793          	zext.b	a5,a5
    802033dc:	2781                	sext.w	a5,a5
    802033de:	853e                	mv	a0,a5
    802033e0:	00000097          	auipc	ra,0x0
    802033e4:	e14080e7          	jalr	-492(ra) # 802031f4 <assert>
    assert(page2 != 0);
    802033e8:	fe043783          	ld	a5,-32(s0)
    802033ec:	00f037b3          	snez	a5,a5
    802033f0:	0ff7f793          	zext.b	a5,a5
    802033f4:	2781                	sext.w	a5,a5
    802033f6:	853e                	mv	a0,a5
    802033f8:	00000097          	auipc	ra,0x0
    802033fc:	dfc080e7          	jalr	-516(ra) # 802031f4 <assert>
    assert(page1 != page2);
    80203400:	fe843703          	ld	a4,-24(s0)
    80203404:	fe043783          	ld	a5,-32(s0)
    80203408:	40f707b3          	sub	a5,a4,a5
    8020340c:	00f037b3          	snez	a5,a5
    80203410:	0ff7f793          	zext.b	a5,a5
    80203414:	2781                	sext.w	a5,a5
    80203416:	853e                	mv	a0,a5
    80203418:	00000097          	auipc	ra,0x0
    8020341c:	ddc080e7          	jalr	-548(ra) # 802031f4 <assert>
    assert(((uint64)page1 & 0xFFF) == 0);
    80203420:	fe843703          	ld	a4,-24(s0)
    80203424:	6785                	lui	a5,0x1
    80203426:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203428:	8ff9                	and	a5,a5,a4
    8020342a:	0017b793          	seqz	a5,a5
    8020342e:	0ff7f793          	zext.b	a5,a5
    80203432:	2781                	sext.w	a5,a5
    80203434:	853e                	mv	a0,a5
    80203436:	00000097          	auipc	ra,0x0
    8020343a:	dbe080e7          	jalr	-578(ra) # 802031f4 <assert>
    assert(((uint64)page2 & 0xFFF) == 0);
    8020343e:	fe043703          	ld	a4,-32(s0)
    80203442:	6785                	lui	a5,0x1
    80203444:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203446:	8ff9                	and	a5,a5,a4
    80203448:	0017b793          	seqz	a5,a5
    8020344c:	0ff7f793          	zext.b	a5,a5
    80203450:	2781                	sext.w	a5,a5
    80203452:	853e                	mv	a0,a5
    80203454:	00000097          	auipc	ra,0x0
    80203458:	da0080e7          	jalr	-608(ra) # 802031f4 <assert>
    printf("[PM TEST] 分配测试通过\n");
    8020345c:	00012517          	auipc	a0,0x12
    80203460:	29c50513          	addi	a0,a0,668 # 802156f8 <user_test_table+0x100>
    80203464:	ffffe097          	auipc	ra,0xffffe
    80203468:	8ca080e7          	jalr	-1846(ra) # 80200d2e <printf>
    printf("[PM TEST] 数据写入测试...\n");
    8020346c:	00012517          	auipc	a0,0x12
    80203470:	2ac50513          	addi	a0,a0,684 # 80215718 <user_test_table+0x120>
    80203474:	ffffe097          	auipc	ra,0xffffe
    80203478:	8ba080e7          	jalr	-1862(ra) # 80200d2e <printf>
    *(int*)page1 = 0x12345678;
    8020347c:	fe843783          	ld	a5,-24(s0)
    80203480:	12345737          	lui	a4,0x12345
    80203484:	67870713          	addi	a4,a4,1656 # 12345678 <_entry-0x6deba988>
    80203488:	c398                	sw	a4,0(a5)
    assert(*(int*)page1 == 0x12345678);
    8020348a:	fe843783          	ld	a5,-24(s0)
    8020348e:	439c                	lw	a5,0(a5)
    80203490:	873e                	mv	a4,a5
    80203492:	123457b7          	lui	a5,0x12345
    80203496:	67878793          	addi	a5,a5,1656 # 12345678 <_entry-0x6deba988>
    8020349a:	40f707b3          	sub	a5,a4,a5
    8020349e:	0017b793          	seqz	a5,a5
    802034a2:	0ff7f793          	zext.b	a5,a5
    802034a6:	2781                	sext.w	a5,a5
    802034a8:	853e                	mv	a0,a5
    802034aa:	00000097          	auipc	ra,0x0
    802034ae:	d4a080e7          	jalr	-694(ra) # 802031f4 <assert>
    printf("[PM TEST] 数据写入测试通过\n");
    802034b2:	00012517          	auipc	a0,0x12
    802034b6:	28e50513          	addi	a0,a0,654 # 80215740 <user_test_table+0x148>
    802034ba:	ffffe097          	auipc	ra,0xffffe
    802034be:	874080e7          	jalr	-1932(ra) # 80200d2e <printf>
    printf("[PM TEST] 释放与重新分配测试...\n");
    802034c2:	00012517          	auipc	a0,0x12
    802034c6:	2a650513          	addi	a0,a0,678 # 80215768 <user_test_table+0x170>
    802034ca:	ffffe097          	auipc	ra,0xffffe
    802034ce:	864080e7          	jalr	-1948(ra) # 80200d2e <printf>
    free_page(page1);
    802034d2:	fe843503          	ld	a0,-24(s0)
    802034d6:	00000097          	auipc	ra,0x0
    802034da:	e56080e7          	jalr	-426(ra) # 8020332c <free_page>
    void *page3 = alloc_page();
    802034de:	00000097          	auipc	ra,0x0
    802034e2:	de2080e7          	jalr	-542(ra) # 802032c0 <alloc_page>
    802034e6:	fca43c23          	sd	a0,-40(s0)
    assert(page3 != 0);
    802034ea:	fd843783          	ld	a5,-40(s0)
    802034ee:	00f037b3          	snez	a5,a5
    802034f2:	0ff7f793          	zext.b	a5,a5
    802034f6:	2781                	sext.w	a5,a5
    802034f8:	853e                	mv	a0,a5
    802034fa:	00000097          	auipc	ra,0x0
    802034fe:	cfa080e7          	jalr	-774(ra) # 802031f4 <assert>
    printf("[PM TEST] 释放与重新分配测试通过\n");
    80203502:	00012517          	auipc	a0,0x12
    80203506:	29650513          	addi	a0,a0,662 # 80215798 <user_test_table+0x1a0>
    8020350a:	ffffe097          	auipc	ra,0xffffe
    8020350e:	824080e7          	jalr	-2012(ra) # 80200d2e <printf>
    free_page(page2);
    80203512:	fe043503          	ld	a0,-32(s0)
    80203516:	00000097          	auipc	ra,0x0
    8020351a:	e16080e7          	jalr	-490(ra) # 8020332c <free_page>
    free_page(page3);
    8020351e:	fd843503          	ld	a0,-40(s0)
    80203522:	00000097          	auipc	ra,0x0
    80203526:	e0a080e7          	jalr	-502(ra) # 8020332c <free_page>
    printf("[PM TEST] 所有物理内存管理测试通过\n");
    8020352a:	00012517          	auipc	a0,0x12
    8020352e:	29e50513          	addi	a0,a0,670 # 802157c8 <user_test_table+0x1d0>
    80203532:	ffffd097          	auipc	ra,0xffffd
    80203536:	7fc080e7          	jalr	2044(ra) # 80200d2e <printf>
    8020353a:	0001                	nop
    8020353c:	70a2                	ld	ra,40(sp)
    8020353e:	7402                	ld	s0,32(sp)
    80203540:	6145                	addi	sp,sp,48
    80203542:	8082                	ret

0000000080203544 <sbi_set_time>:
#include "defs.h"

void sbi_set_time(uint64 time) {
    80203544:	1101                	addi	sp,sp,-32
    80203546:	ec22                	sd	s0,24(sp)
    80203548:	1000                	addi	s0,sp,32
    8020354a:	fea43423          	sd	a0,-24(s0)
    register uint64 a0 asm("a0") = time;
    8020354e:	fe843503          	ld	a0,-24(s0)
    register uint64 a7 asm("a7") = SBI_SET_TIME;
    80203552:	4881                	li	a7,0
    asm volatile ("ecall"
    80203554:	00000073          	ecall
                  : "+r"(a0)
                  : "r"(a7)
                  : "memory");
}
    80203558:	0001                	nop
    8020355a:	6462                	ld	s0,24(sp)
    8020355c:	6105                	addi	sp,sp,32
    8020355e:	8082                	ret

0000000080203560 <sbi_get_time>:
// 直接读取 time CSR 寄存器获取当前时间
uint64 sbi_get_time(void) {
    80203560:	1101                	addi	sp,sp,-32
    80203562:	ec22                	sd	s0,24(sp)
    80203564:	1000                	addi	s0,sp,32
    uint64 time_value;
    
    asm volatile ("rdtime %0" : "=r"(time_value));
    80203566:	c01027f3          	rdtime	a5
    8020356a:	fef43423          	sd	a5,-24(s0)
    
    return time_value;
    8020356e:	fe843783          	ld	a5,-24(s0)
    80203572:	853e                	mv	a0,a5
    80203574:	6462                	ld	s0,24(sp)
    80203576:	6105                	addi	sp,sp,32
    80203578:	8082                	ret

000000008020357a <timeintr>:
#include "defs.h"

// 声明外部测试标志
extern volatile int *interrupt_test_flag;
void timeintr(void){
    8020357a:	1141                	addi	sp,sp,-16
    8020357c:	e422                	sd	s0,8(sp)
    8020357e:	0800                	addi	s0,sp,16
	if (interrupt_test_flag)
    80203580:	00024797          	auipc	a5,0x24
    80203584:	b3878793          	addi	a5,a5,-1224 # 802270b8 <interrupt_test_flag>
    80203588:	639c                	ld	a5,0(a5)
    8020358a:	cb99                	beqz	a5,802035a0 <timeintr+0x26>
        (*interrupt_test_flag)++;
    8020358c:	00024797          	auipc	a5,0x24
    80203590:	b2c78793          	addi	a5,a5,-1236 # 802270b8 <interrupt_test_flag>
    80203594:	639c                	ld	a5,0(a5)
    80203596:	4398                	lw	a4,0(a5)
    80203598:	2701                	sext.w	a4,a4
    8020359a:	2705                	addiw	a4,a4,1
    8020359c:	2701                	sext.w	a4,a4
    8020359e:	c398                	sw	a4,0(a5)
    802035a0:	0001                	nop
    802035a2:	6422                	ld	s0,8(sp)
    802035a4:	0141                	addi	sp,sp,16
    802035a6:	8082                	ret

00000000802035a8 <r_sie>:
		case SYS_pid:
			tf->a0 = myproc()->pid;
			break;
		case SYS_ppid:
			tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
			break;
    802035a8:	1101                	addi	sp,sp,-32
    802035aa:	ec22                	sd	s0,24(sp)
    802035ac:	1000                	addi	s0,sp,32
		case SYS_get_time:
			tf->a0 = get_time();
    802035ae:	104027f3          	csrr	a5,sie
    802035b2:	fef43423          	sd	a5,-24(s0)
			break;
    802035b6:	fe843783          	ld	a5,-24(s0)
		case SYS_step:
    802035ba:	853e                	mv	a0,a5
    802035bc:	6462                	ld	s0,24(sp)
    802035be:	6105                	addi	sp,sp,32
    802035c0:	8082                	ret

00000000802035c2 <w_sie>:
			tf->a0 = 0;
			printf("[syscall] step enabled but do nothing\n");
    802035c2:	1101                	addi	sp,sp,-32
    802035c4:	ec22                	sd	s0,24(sp)
    802035c6:	1000                	addi	s0,sp,32
    802035c8:	fea43423          	sd	a0,-24(s0)
			break;
    802035cc:	fe843783          	ld	a5,-24(s0)
    802035d0:	10479073          	csrw	sie,a5
	case SYS_write: {
    802035d4:	0001                	nop
    802035d6:	6462                	ld	s0,24(sp)
    802035d8:	6105                	addi	sp,sp,32
    802035da:	8082                	ret

00000000802035dc <r_sstatus>:
		int fd = tf->a0;          // 文件描述符
		char buf[128];            // 临时缓冲区
    802035dc:	1101                	addi	sp,sp,-32
    802035de:	ec22                	sd	s0,24(sp)
    802035e0:	1000                	addi	s0,sp,32
		
		// 目前只支持标准输出(fd=1)和标准错误(fd=2)
    802035e2:	100027f3          	csrr	a5,sstatus
    802035e6:	fef43423          	sd	a5,-24(s0)
		if (fd != 1 && fd != 2) {
    802035ea:	fe843783          	ld	a5,-24(s0)
			tf->a0 = -1;
    802035ee:	853e                	mv	a0,a5
    802035f0:	6462                	ld	s0,24(sp)
    802035f2:	6105                	addi	sp,sp,32
    802035f4:	8082                	ret

00000000802035f6 <w_sstatus>:
			break;
    802035f6:	1101                	addi	sp,sp,-32
    802035f8:	ec22                	sd	s0,24(sp)
    802035fa:	1000                	addi	s0,sp,32
    802035fc:	fea43423          	sd	a0,-24(s0)
		}
    80203600:	fe843783          	ld	a5,-24(s0)
    80203604:	10079073          	csrw	sstatus,a5
		
    80203608:	0001                	nop
    8020360a:	6462                	ld	s0,24(sp)
    8020360c:	6105                	addi	sp,sp,32
    8020360e:	8082                	ret

0000000080203610 <w_sscratch>:
		// 检查用户提供的缓冲区地址是否合法
    80203610:	1101                	addi	sp,sp,-32
    80203612:	ec22                	sd	s0,24(sp)
    80203614:	1000                	addi	s0,sp,32
    80203616:	fea43423          	sd	a0,-24(s0)
		if (check_user_addr(tf->a1, tf->a2, 0) < 0) {
    8020361a:	fe843783          	ld	a5,-24(s0)
    8020361e:	14079073          	csrw	sscratch,a5
			printf("[syscall] invalid write buffer address\n");
    80203622:	0001                	nop
    80203624:	6462                	ld	s0,24(sp)
    80203626:	6105                	addi	sp,sp,32
    80203628:	8082                	ret

000000008020362a <w_sepc>:
			tf->a0 = -1;
			break;
    8020362a:	1101                	addi	sp,sp,-32
    8020362c:	ec22                	sd	s0,24(sp)
    8020362e:	1000                	addi	s0,sp,32
    80203630:	fea43423          	sd	a0,-24(s0)
		}
    80203634:	fe843783          	ld	a5,-24(s0)
    80203638:	14179073          	csrw	sepc,a5
		
    8020363c:	0001                	nop
    8020363e:	6462                	ld	s0,24(sp)
    80203640:	6105                	addi	sp,sp,32
    80203642:	8082                	ret

0000000080203644 <intr_off>:
		// 从用户空间安全地复制字符串
		if (copyinstr(buf, myproc()->pagetable, tf->a1, sizeof(buf)) < 0) {
			printf("[syscall] invalid write buffer\n");
			tf->a0 = -1;
			break;
		}
    80203644:	1141                	addi	sp,sp,-16
    80203646:	e406                	sd	ra,8(sp)
    80203648:	e022                	sd	s0,0(sp)
    8020364a:	0800                	addi	s0,sp,16
		
    8020364c:	00000097          	auipc	ra,0x0
    80203650:	f90080e7          	jalr	-112(ra) # 802035dc <r_sstatus>
    80203654:	87aa                	mv	a5,a0
    80203656:	9bf5                	andi	a5,a5,-3
    80203658:	853e                	mv	a0,a5
    8020365a:	00000097          	auipc	ra,0x0
    8020365e:	f9c080e7          	jalr	-100(ra) # 802035f6 <w_sstatus>
		// 输出到控制台
    80203662:	0001                	nop
    80203664:	60a2                	ld	ra,8(sp)
    80203666:	6402                	ld	s0,0(sp)
    80203668:	0141                	addi	sp,sp,16
    8020366a:	8082                	ret

000000008020366c <w_stvec>:
		printf("%s", buf);
		tf->a0 = strlen(buf);  // 返回写入的字节数
    8020366c:	1101                	addi	sp,sp,-32
    8020366e:	ec22                	sd	s0,24(sp)
    80203670:	1000                	addi	s0,sp,32
    80203672:	fea43423          	sd	a0,-24(s0)
		break;
    80203676:	fe843783          	ld	a5,-24(s0)
    8020367a:	10579073          	csrw	stvec,a5
	}
    8020367e:	0001                	nop
    80203680:	6462                	ld	s0,24(sp)
    80203682:	6105                	addi	sp,sp,32
    80203684:	8082                	ret

0000000080203686 <r_scause>:
		int fd = tf->a0;          // 文件描述符
		uint64 buf = tf->a1;      // 用户缓冲区地址
		int n = tf->a2;           // 要读取的字节数
		
		// 目前只支持标准输入(fd=0)
		if (fd != 0) {
    80203686:	1101                	addi	sp,sp,-32
    80203688:	ec22                	sd	s0,24(sp)
    8020368a:	1000                	addi	s0,sp,32
			tf->a0 = -1;
			break;
    8020368c:	142027f3          	csrr	a5,scause
    80203690:	fef43423          	sd	a5,-24(s0)
		}
    80203694:	fe843783          	ld	a5,-24(s0)
		
    80203698:	853e                	mv	a0,a5
    8020369a:	6462                	ld	s0,24(sp)
    8020369c:	6105                	addi	sp,sp,32
    8020369e:	8082                	ret

00000000802036a0 <r_sepc>:
		// 检查用户提供的缓冲区地址是否合法
		if (check_user_addr(buf, n, 1) < 0) {  // 1表示写入访问
    802036a0:	1101                	addi	sp,sp,-32
    802036a2:	ec22                	sd	s0,24(sp)
    802036a4:	1000                	addi	s0,sp,32
			printf("[syscall] invalid read buffer address\n");
			tf->a0 = -1;
    802036a6:	141027f3          	csrr	a5,sepc
    802036aa:	fef43423          	sd	a5,-24(s0)
			break;
    802036ae:	fe843783          	ld	a5,-24(s0)
		}
    802036b2:	853e                	mv	a0,a5
    802036b4:	6462                	ld	s0,24(sp)
    802036b6:	6105                	addi	sp,sp,32
    802036b8:	8082                	ret

00000000802036ba <r_stval>:
		
		// TODO: 实现从控制台读取
    802036ba:	1101                	addi	sp,sp,-32
    802036bc:	ec22                	sd	s0,24(sp)
    802036be:	1000                	addi	s0,sp,32
		tf->a0 = -1;
		break;
    802036c0:	143027f3          	csrr	a5,stval
    802036c4:	fef43423          	sd	a5,-24(s0)
	}
    802036c8:	fe843783          	ld	a5,-24(s0)
        
    802036cc:	853e                	mv	a0,a5
    802036ce:	6462                	ld	s0,24(sp)
    802036d0:	6105                	addi	sp,sp,32
    802036d2:	8082                	ret

00000000802036d4 <save_exception_info>:
static inline void save_exception_info(struct trapframe *tf, uint64 sepc, uint64 sstatus, uint64 scause, uint64 stval) {
    802036d4:	7139                	addi	sp,sp,-64
    802036d6:	fc22                	sd	s0,56(sp)
    802036d8:	0080                	addi	s0,sp,64
    802036da:	fea43423          	sd	a0,-24(s0)
    802036de:	feb43023          	sd	a1,-32(s0)
    802036e2:	fcc43c23          	sd	a2,-40(s0)
    802036e6:	fcd43823          	sd	a3,-48(s0)
    802036ea:	fce43423          	sd	a4,-56(s0)
    tf->epc = sepc;
    802036ee:	fe843783          	ld	a5,-24(s0)
    802036f2:	fe043703          	ld	a4,-32(s0)
    802036f6:	ff98                	sd	a4,56(a5)
}
    802036f8:	0001                	nop
    802036fa:	7462                	ld	s0,56(sp)
    802036fc:	6121                	addi	sp,sp,64
    802036fe:	8082                	ret

0000000080203700 <get_sepc>:
static inline uint64 get_sepc(struct trapframe *tf) {
    80203700:	1101                	addi	sp,sp,-32
    80203702:	ec22                	sd	s0,24(sp)
    80203704:	1000                	addi	s0,sp,32
    80203706:	fea43423          	sd	a0,-24(s0)
    return tf->epc;
    8020370a:	fe843783          	ld	a5,-24(s0)
    8020370e:	7f9c                	ld	a5,56(a5)
}
    80203710:	853e                	mv	a0,a5
    80203712:	6462                	ld	s0,24(sp)
    80203714:	6105                	addi	sp,sp,32
    80203716:	8082                	ret

0000000080203718 <set_sepc>:
static inline void set_sepc(struct trapframe *tf, uint64 sepc) {
    80203718:	1101                	addi	sp,sp,-32
    8020371a:	ec22                	sd	s0,24(sp)
    8020371c:	1000                	addi	s0,sp,32
    8020371e:	fea43423          	sd	a0,-24(s0)
    80203722:	feb43023          	sd	a1,-32(s0)
    tf->epc = sepc;
    80203726:	fe843783          	ld	a5,-24(s0)
    8020372a:	fe043703          	ld	a4,-32(s0)
    8020372e:	ff98                	sd	a4,56(a5)
}
    80203730:	0001                	nop
    80203732:	6462                	ld	s0,24(sp)
    80203734:	6105                	addi	sp,sp,32
    80203736:	8082                	ret

0000000080203738 <register_interrupt>:
void register_interrupt(int irq, interrupt_handler_t h) {
    80203738:	1101                	addi	sp,sp,-32
    8020373a:	ec22                	sd	s0,24(sp)
    8020373c:	1000                	addi	s0,sp,32
    8020373e:	87aa                	mv	a5,a0
    80203740:	feb43023          	sd	a1,-32(s0)
    80203744:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ){
    80203748:	fec42783          	lw	a5,-20(s0)
    8020374c:	2781                	sext.w	a5,a5
    8020374e:	0207c563          	bltz	a5,80203778 <register_interrupt+0x40>
    80203752:	fec42783          	lw	a5,-20(s0)
    80203756:	0007871b          	sext.w	a4,a5
    8020375a:	03f00793          	li	a5,63
    8020375e:	00e7cd63          	blt	a5,a4,80203778 <register_interrupt+0x40>
        interrupt_vector[irq] = h;
    80203762:	00024717          	auipc	a4,0x24
    80203766:	b0670713          	addi	a4,a4,-1274 # 80227268 <interrupt_vector>
    8020376a:	fec42783          	lw	a5,-20(s0)
    8020376e:	078e                	slli	a5,a5,0x3
    80203770:	97ba                	add	a5,a5,a4
    80203772:	fe043703          	ld	a4,-32(s0)
    80203776:	e398                	sd	a4,0(a5)
}
    80203778:	0001                	nop
    8020377a:	6462                	ld	s0,24(sp)
    8020377c:	6105                	addi	sp,sp,32
    8020377e:	8082                	ret

0000000080203780 <unregister_interrupt>:
void unregister_interrupt(int irq) {
    80203780:	1101                	addi	sp,sp,-32
    80203782:	ec22                	sd	s0,24(sp)
    80203784:	1000                	addi	s0,sp,32
    80203786:	87aa                	mv	a5,a0
    80203788:	fef42623          	sw	a5,-20(s0)
    if (irq >= 0 && irq < MAX_IRQ)
    8020378c:	fec42783          	lw	a5,-20(s0)
    80203790:	2781                	sext.w	a5,a5
    80203792:	0207c463          	bltz	a5,802037ba <unregister_interrupt+0x3a>
    80203796:	fec42783          	lw	a5,-20(s0)
    8020379a:	0007871b          	sext.w	a4,a5
    8020379e:	03f00793          	li	a5,63
    802037a2:	00e7cc63          	blt	a5,a4,802037ba <unregister_interrupt+0x3a>
        interrupt_vector[irq] = 0;
    802037a6:	00024717          	auipc	a4,0x24
    802037aa:	ac270713          	addi	a4,a4,-1342 # 80227268 <interrupt_vector>
    802037ae:	fec42783          	lw	a5,-20(s0)
    802037b2:	078e                	slli	a5,a5,0x3
    802037b4:	97ba                	add	a5,a5,a4
    802037b6:	0007b023          	sd	zero,0(a5)
}
    802037ba:	0001                	nop
    802037bc:	6462                	ld	s0,24(sp)
    802037be:	6105                	addi	sp,sp,32
    802037c0:	8082                	ret

00000000802037c2 <enable_interrupts>:
void enable_interrupts(int irq) {
    802037c2:	1101                	addi	sp,sp,-32
    802037c4:	ec06                	sd	ra,24(sp)
    802037c6:	e822                	sd	s0,16(sp)
    802037c8:	1000                	addi	s0,sp,32
    802037ca:	87aa                	mv	a5,a0
    802037cc:	fef42623          	sw	a5,-20(s0)
    plic_enable(irq);
    802037d0:	fec42783          	lw	a5,-20(s0)
    802037d4:	853e                	mv	a0,a5
    802037d6:	00001097          	auipc	ra,0x1
    802037da:	37e080e7          	jalr	894(ra) # 80204b54 <plic_enable>
}
    802037de:	0001                	nop
    802037e0:	60e2                	ld	ra,24(sp)
    802037e2:	6442                	ld	s0,16(sp)
    802037e4:	6105                	addi	sp,sp,32
    802037e6:	8082                	ret

00000000802037e8 <disable_interrupts>:
void disable_interrupts(int irq) {
    802037e8:	1101                	addi	sp,sp,-32
    802037ea:	ec06                	sd	ra,24(sp)
    802037ec:	e822                	sd	s0,16(sp)
    802037ee:	1000                	addi	s0,sp,32
    802037f0:	87aa                	mv	a5,a0
    802037f2:	fef42623          	sw	a5,-20(s0)
    plic_disable(irq);
    802037f6:	fec42783          	lw	a5,-20(s0)
    802037fa:	853e                	mv	a0,a5
    802037fc:	00001097          	auipc	ra,0x1
    80203800:	3b0080e7          	jalr	944(ra) # 80204bac <plic_disable>
}
    80203804:	0001                	nop
    80203806:	60e2                	ld	ra,24(sp)
    80203808:	6442                	ld	s0,16(sp)
    8020380a:	6105                	addi	sp,sp,32
    8020380c:	8082                	ret

000000008020380e <interrupt_dispatch>:
void interrupt_dispatch(int irq) {
    8020380e:	1101                	addi	sp,sp,-32
    80203810:	ec06                	sd	ra,24(sp)
    80203812:	e822                	sd	s0,16(sp)
    80203814:	1000                	addi	s0,sp,32
    80203816:	87aa                	mv	a5,a0
    80203818:	fef42623          	sw	a5,-20(s0)
	if (irq >= 0 && irq < MAX_IRQ && interrupt_vector[irq]){
    8020381c:	fec42783          	lw	a5,-20(s0)
    80203820:	2781                	sext.w	a5,a5
    80203822:	0207ce63          	bltz	a5,8020385e <interrupt_dispatch+0x50>
    80203826:	fec42783          	lw	a5,-20(s0)
    8020382a:	0007871b          	sext.w	a4,a5
    8020382e:	03f00793          	li	a5,63
    80203832:	02e7c663          	blt	a5,a4,8020385e <interrupt_dispatch+0x50>
    80203836:	00024717          	auipc	a4,0x24
    8020383a:	a3270713          	addi	a4,a4,-1486 # 80227268 <interrupt_vector>
    8020383e:	fec42783          	lw	a5,-20(s0)
    80203842:	078e                	slli	a5,a5,0x3
    80203844:	97ba                	add	a5,a5,a4
    80203846:	639c                	ld	a5,0(a5)
    80203848:	cb99                	beqz	a5,8020385e <interrupt_dispatch+0x50>
		interrupt_vector[irq]();
    8020384a:	00024717          	auipc	a4,0x24
    8020384e:	a1e70713          	addi	a4,a4,-1506 # 80227268 <interrupt_vector>
    80203852:	fec42783          	lw	a5,-20(s0)
    80203856:	078e                	slli	a5,a5,0x3
    80203858:	97ba                	add	a5,a5,a4
    8020385a:	639c                	ld	a5,0(a5)
    8020385c:	9782                	jalr	a5
}
    8020385e:	0001                	nop
    80203860:	60e2                	ld	ra,24(sp)
    80203862:	6442                	ld	s0,16(sp)
    80203864:	6105                	addi	sp,sp,32
    80203866:	8082                	ret

0000000080203868 <handle_external_interrupt>:
void handle_external_interrupt(void) {
    80203868:	1101                	addi	sp,sp,-32
    8020386a:	ec06                	sd	ra,24(sp)
    8020386c:	e822                	sd	s0,16(sp)
    8020386e:	1000                	addi	s0,sp,32
    int irq = plic_claim();
    80203870:	00001097          	auipc	ra,0x1
    80203874:	39a080e7          	jalr	922(ra) # 80204c0a <plic_claim>
    80203878:	87aa                	mv	a5,a0
    8020387a:	fef42623          	sw	a5,-20(s0)
    if (irq == 0) {
    8020387e:	fec42783          	lw	a5,-20(s0)
    80203882:	2781                	sext.w	a5,a5
    80203884:	eb91                	bnez	a5,80203898 <handle_external_interrupt+0x30>
        printf("Spurious external interrupt\n");
    80203886:	00018517          	auipc	a0,0x18
    8020388a:	fa250513          	addi	a0,a0,-94 # 8021b828 <user_test_table+0x60>
    8020388e:	ffffd097          	auipc	ra,0xffffd
    80203892:	4a0080e7          	jalr	1184(ra) # 80200d2e <printf>
        return;
    80203896:	a839                	j	802038b4 <handle_external_interrupt+0x4c>
    interrupt_dispatch(irq);
    80203898:	fec42783          	lw	a5,-20(s0)
    8020389c:	853e                	mv	a0,a5
    8020389e:	00000097          	auipc	ra,0x0
    802038a2:	f70080e7          	jalr	-144(ra) # 8020380e <interrupt_dispatch>
    plic_complete(irq);
    802038a6:	fec42783          	lw	a5,-20(s0)
    802038aa:	853e                	mv	a0,a5
    802038ac:	00001097          	auipc	ra,0x1
    802038b0:	386080e7          	jalr	902(ra) # 80204c32 <plic_complete>
}
    802038b4:	60e2                	ld	ra,24(sp)
    802038b6:	6442                	ld	s0,16(sp)
    802038b8:	6105                	addi	sp,sp,32
    802038ba:	8082                	ret

00000000802038bc <trap_init>:
void trap_init(void) {
    802038bc:	1101                	addi	sp,sp,-32
    802038be:	ec06                	sd	ra,24(sp)
    802038c0:	e822                	sd	s0,16(sp)
    802038c2:	1000                	addi	s0,sp,32
	intr_off();
    802038c4:	00000097          	auipc	ra,0x0
    802038c8:	d80080e7          	jalr	-640(ra) # 80203644 <intr_off>
	printf("trap_init...\n");
    802038cc:	00018517          	auipc	a0,0x18
    802038d0:	f7c50513          	addi	a0,a0,-132 # 8021b848 <user_test_table+0x80>
    802038d4:	ffffd097          	auipc	ra,0xffffd
    802038d8:	45a080e7          	jalr	1114(ra) # 80200d2e <printf>
	w_stvec((uint64)kernelvec);
    802038dc:	00001797          	auipc	a5,0x1
    802038e0:	38478793          	addi	a5,a5,900 # 80204c60 <kernelvec>
    802038e4:	853e                	mv	a0,a5
    802038e6:	00000097          	auipc	ra,0x0
    802038ea:	d86080e7          	jalr	-634(ra) # 8020366c <w_stvec>
	for(int i = 0; i < MAX_IRQ; i++){
    802038ee:	fe042623          	sw	zero,-20(s0)
    802038f2:	a005                	j	80203912 <trap_init+0x56>
		interrupt_vector[i] = 0;
    802038f4:	00024717          	auipc	a4,0x24
    802038f8:	97470713          	addi	a4,a4,-1676 # 80227268 <interrupt_vector>
    802038fc:	fec42783          	lw	a5,-20(s0)
    80203900:	078e                	slli	a5,a5,0x3
    80203902:	97ba                	add	a5,a5,a4
    80203904:	0007b023          	sd	zero,0(a5)
	for(int i = 0; i < MAX_IRQ; i++){
    80203908:	fec42783          	lw	a5,-20(s0)
    8020390c:	2785                	addiw	a5,a5,1
    8020390e:	fef42623          	sw	a5,-20(s0)
    80203912:	fec42783          	lw	a5,-20(s0)
    80203916:	0007871b          	sext.w	a4,a5
    8020391a:	03f00793          	li	a5,63
    8020391e:	fce7dbe3          	bge	a5,a4,802038f4 <trap_init+0x38>
	plic_init();// 初始化PLIC（外部中断控制器）
    80203922:	00001097          	auipc	ra,0x1
    80203926:	194080e7          	jalr	404(ra) # 80204ab6 <plic_init>
    uint64 sie = r_sie();
    8020392a:	00000097          	auipc	ra,0x0
    8020392e:	c7e080e7          	jalr	-898(ra) # 802035a8 <r_sie>
    80203932:	fea43023          	sd	a0,-32(s0)
    w_sie(sie | (1L << 5) | (1L<<9)); // 设置SIE.STIE位启用时钟中断和外部中断
    80203936:	fe043783          	ld	a5,-32(s0)
    8020393a:	2207e793          	ori	a5,a5,544
    8020393e:	853e                	mv	a0,a5
    80203940:	00000097          	auipc	ra,0x0
    80203944:	c82080e7          	jalr	-894(ra) # 802035c2 <w_sie>
	sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80203948:	00000097          	auipc	ra,0x0
    8020394c:	c18080e7          	jalr	-1000(ra) # 80203560 <sbi_get_time>
    80203950:	872a                	mv	a4,a0
    80203952:	000f47b7          	lui	a5,0xf4
    80203956:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    8020395a:	97ba                	add	a5,a5,a4
    8020395c:	853e                	mv	a0,a5
    8020395e:	00000097          	auipc	ra,0x0
    80203962:	be6080e7          	jalr	-1050(ra) # 80203544 <sbi_set_time>
	printf("Registered exception handlers: store_page_fault=%p\n", handle_store_page_fault);
    80203966:	00001597          	auipc	a1,0x1
    8020396a:	e8058593          	addi	a1,a1,-384 # 802047e6 <handle_store_page_fault>
    8020396e:	00018517          	auipc	a0,0x18
    80203972:	eea50513          	addi	a0,a0,-278 # 8021b858 <user_test_table+0x90>
    80203976:	ffffd097          	auipc	ra,0xffffd
    8020397a:	3b8080e7          	jalr	952(ra) # 80200d2e <printf>
	printf("trap_init complete.\n");
    8020397e:	00018517          	auipc	a0,0x18
    80203982:	f1250513          	addi	a0,a0,-238 # 8021b890 <user_test_table+0xc8>
    80203986:	ffffd097          	auipc	ra,0xffffd
    8020398a:	3a8080e7          	jalr	936(ra) # 80200d2e <printf>
}
    8020398e:	0001                	nop
    80203990:	60e2                	ld	ra,24(sp)
    80203992:	6442                	ld	s0,16(sp)
    80203994:	6105                	addi	sp,sp,32
    80203996:	8082                	ret

0000000080203998 <kerneltrap>:
void kerneltrap(void) {
    80203998:	7165                	addi	sp,sp,-400
    8020399a:	e706                	sd	ra,392(sp)
    8020399c:	e322                	sd	s0,384(sp)
    8020399e:	0b00                	addi	s0,sp,400
    uint64 sstatus = r_sstatus();
    802039a0:	00000097          	auipc	ra,0x0
    802039a4:	c3c080e7          	jalr	-964(ra) # 802035dc <r_sstatus>
    802039a8:	fea43023          	sd	a0,-32(s0)
    uint64 scause = r_scause();
    802039ac:	00000097          	auipc	ra,0x0
    802039b0:	cda080e7          	jalr	-806(ra) # 80203686 <r_scause>
    802039b4:	fca43c23          	sd	a0,-40(s0)
    uint64 sepc = r_sepc();
    802039b8:	00000097          	auipc	ra,0x0
    802039bc:	ce8080e7          	jalr	-792(ra) # 802036a0 <r_sepc>
    802039c0:	fea43423          	sd	a0,-24(s0)
    uint64 stval = r_stval();
    802039c4:	00000097          	auipc	ra,0x0
    802039c8:	cf6080e7          	jalr	-778(ra) # 802036ba <r_stval>
    802039cc:	fca43823          	sd	a0,-48(s0)
    if(scause & 0x8000000000000000) {
    802039d0:	fd843783          	ld	a5,-40(s0)
    802039d4:	0807da63          	bgez	a5,80203a68 <kerneltrap+0xd0>
        if((scause & 0xff) == 5) {
    802039d8:	fd843783          	ld	a5,-40(s0)
    802039dc:	0ff7f713          	zext.b	a4,a5
    802039e0:	4795                	li	a5,5
    802039e2:	04f71a63          	bne	a4,a5,80203a36 <kerneltrap+0x9e>
            timeintr();
    802039e6:	00000097          	auipc	ra,0x0
    802039ea:	b94080e7          	jalr	-1132(ra) # 8020357a <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    802039ee:	00000097          	auipc	ra,0x0
    802039f2:	b72080e7          	jalr	-1166(ra) # 80203560 <sbi_get_time>
    802039f6:	872a                	mv	a4,a0
    802039f8:	000f47b7          	lui	a5,0xf4
    802039fc:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    80203a00:	97ba                	add	a5,a5,a4
    80203a02:	853e                	mv	a0,a5
    80203a04:	00000097          	auipc	ra,0x0
    80203a08:	b40080e7          	jalr	-1216(ra) # 80203544 <sbi_set_time>
			if(myproc() && myproc()->state == RUNNING) {
    80203a0c:	00001097          	auipc	ra,0x1
    80203a10:	5a4080e7          	jalr	1444(ra) # 80204fb0 <myproc>
    80203a14:	87aa                	mv	a5,a0
    80203a16:	cbe9                	beqz	a5,80203ae8 <kerneltrap+0x150>
    80203a18:	00001097          	auipc	ra,0x1
    80203a1c:	598080e7          	jalr	1432(ra) # 80204fb0 <myproc>
    80203a20:	87aa                	mv	a5,a0
    80203a22:	439c                	lw	a5,0(a5)
    80203a24:	873e                	mv	a4,a5
    80203a26:	4791                	li	a5,4
    80203a28:	0cf71063          	bne	a4,a5,80203ae8 <kerneltrap+0x150>
				yield();  // 当前进程让出 CPU
    80203a2c:	00002097          	auipc	ra,0x2
    80203a30:	168080e7          	jalr	360(ra) # 80205b94 <yield>
    80203a34:	a855                	j	80203ae8 <kerneltrap+0x150>
        } else if((scause & 0xff) == 9) {
    80203a36:	fd843783          	ld	a5,-40(s0)
    80203a3a:	0ff7f713          	zext.b	a4,a5
    80203a3e:	47a5                	li	a5,9
    80203a40:	00f71763          	bne	a4,a5,80203a4e <kerneltrap+0xb6>
            handle_external_interrupt();
    80203a44:	00000097          	auipc	ra,0x0
    80203a48:	e24080e7          	jalr	-476(ra) # 80203868 <handle_external_interrupt>
    80203a4c:	a871                	j	80203ae8 <kerneltrap+0x150>
            printf("kerneltrap: unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    80203a4e:	fe843603          	ld	a2,-24(s0)
    80203a52:	fd843583          	ld	a1,-40(s0)
    80203a56:	00018517          	auipc	a0,0x18
    80203a5a:	e5250513          	addi	a0,a0,-430 # 8021b8a8 <user_test_table+0xe0>
    80203a5e:	ffffd097          	auipc	ra,0xffffd
    80203a62:	2d0080e7          	jalr	720(ra) # 80200d2e <printf>
    80203a66:	a049                	j	80203ae8 <kerneltrap+0x150>
        printf("Exception: scause=%ld, sepc=0x%lx, stval=0x%lx\n", scause, sepc, stval);
    80203a68:	fd043683          	ld	a3,-48(s0)
    80203a6c:	fe843603          	ld	a2,-24(s0)
    80203a70:	fd843583          	ld	a1,-40(s0)
    80203a74:	00018517          	auipc	a0,0x18
    80203a78:	e6c50513          	addi	a0,a0,-404 # 8021b8e0 <user_test_table+0x118>
    80203a7c:	ffffd097          	auipc	ra,0xffffd
    80203a80:	2b2080e7          	jalr	690(ra) # 80200d2e <printf>
        save_exception_info(&tf, sepc, sstatus, scause, stval);
    80203a84:	e9840793          	addi	a5,s0,-360
    80203a88:	fd043703          	ld	a4,-48(s0)
    80203a8c:	fd843683          	ld	a3,-40(s0)
    80203a90:	fe043603          	ld	a2,-32(s0)
    80203a94:	fe843583          	ld	a1,-24(s0)
    80203a98:	853e                	mv	a0,a5
    80203a9a:	00000097          	auipc	ra,0x0
    80203a9e:	c3a080e7          	jalr	-966(ra) # 802036d4 <save_exception_info>
        info.sepc = sepc;
    80203aa2:	fe843783          	ld	a5,-24(s0)
    80203aa6:	e6f43c23          	sd	a5,-392(s0)
        info.sstatus = sstatus;
    80203aaa:	fe043783          	ld	a5,-32(s0)
    80203aae:	e8f43023          	sd	a5,-384(s0)
        info.scause = scause;
    80203ab2:	fd843783          	ld	a5,-40(s0)
    80203ab6:	e8f43423          	sd	a5,-376(s0)
        info.stval = stval;
    80203aba:	fd043783          	ld	a5,-48(s0)
    80203abe:	e8f43823          	sd	a5,-368(s0)
        handle_exception(&tf, &info);
    80203ac2:	e7840713          	addi	a4,s0,-392
    80203ac6:	e9840793          	addi	a5,s0,-360
    80203aca:	85ba                	mv	a1,a4
    80203acc:	853e                	mv	a0,a5
    80203ace:	00000097          	auipc	ra,0x0
    80203ad2:	03c080e7          	jalr	60(ra) # 80203b0a <handle_exception>
        sepc = get_sepc(&tf);
    80203ad6:	e9840793          	addi	a5,s0,-360
    80203ada:	853e                	mv	a0,a5
    80203adc:	00000097          	auipc	ra,0x0
    80203ae0:	c24080e7          	jalr	-988(ra) # 80203700 <get_sepc>
    80203ae4:	fea43423          	sd	a0,-24(s0)
    w_sepc(sepc);
    80203ae8:	fe843503          	ld	a0,-24(s0)
    80203aec:	00000097          	auipc	ra,0x0
    80203af0:	b3e080e7          	jalr	-1218(ra) # 8020362a <w_sepc>
    w_sstatus(sstatus);
    80203af4:	fe043503          	ld	a0,-32(s0)
    80203af8:	00000097          	auipc	ra,0x0
    80203afc:	afe080e7          	jalr	-1282(ra) # 802035f6 <w_sstatus>
}
    80203b00:	0001                	nop
    80203b02:	60ba                	ld	ra,392(sp)
    80203b04:	641a                	ld	s0,384(sp)
    80203b06:	6159                	addi	sp,sp,400
    80203b08:	8082                	ret

0000000080203b0a <handle_exception>:
void handle_exception(struct trapframe *tf, struct trap_info *info) {
    80203b0a:	7139                	addi	sp,sp,-64
    80203b0c:	fc06                	sd	ra,56(sp)
    80203b0e:	f822                	sd	s0,48(sp)
    80203b10:	0080                	addi	s0,sp,64
    80203b12:	fca43423          	sd	a0,-56(s0)
    80203b16:	fcb43023          	sd	a1,-64(s0)
    uint64 cause = info->scause;  // 使用info中的字段
    80203b1a:	fc043783          	ld	a5,-64(s0)
    80203b1e:	6b9c                	ld	a5,16(a5)
    80203b20:	fef43423          	sd	a5,-24(s0)
    switch (cause) {
    80203b24:	fe843703          	ld	a4,-24(s0)
    80203b28:	47bd                	li	a5,15
    80203b2a:	3ee7e763          	bltu	a5,a4,80203f18 <handle_exception+0x40e>
    80203b2e:	fe843783          	ld	a5,-24(s0)
    80203b32:	00279713          	slli	a4,a5,0x2
    80203b36:	00018797          	auipc	a5,0x18
    80203b3a:	fbe78793          	addi	a5,a5,-66 # 8021baf4 <user_test_table+0x32c>
    80203b3e:	97ba                	add	a5,a5,a4
    80203b40:	439c                	lw	a5,0(a5)
    80203b42:	0007871b          	sext.w	a4,a5
    80203b46:	00018797          	auipc	a5,0x18
    80203b4a:	fae78793          	addi	a5,a5,-82 # 8021baf4 <user_test_table+0x32c>
    80203b4e:	97ba                	add	a5,a5,a4
    80203b50:	8782                	jr	a5
            printf("Instruction address misaligned: 0x%lx\n", info->stval);
    80203b52:	fc043783          	ld	a5,-64(s0)
    80203b56:	6f9c                	ld	a5,24(a5)
    80203b58:	85be                	mv	a1,a5
    80203b5a:	00018517          	auipc	a0,0x18
    80203b5e:	db650513          	addi	a0,a0,-586 # 8021b910 <user_test_table+0x148>
    80203b62:	ffffd097          	auipc	ra,0xffffd
    80203b66:	1cc080e7          	jalr	460(ra) # 80200d2e <printf>
			if(myproc()->is_user){
    80203b6a:	00001097          	auipc	ra,0x1
    80203b6e:	446080e7          	jalr	1094(ra) # 80204fb0 <myproc>
    80203b72:	87aa                	mv	a5,a0
    80203b74:	0a87a783          	lw	a5,168(a5)
    80203b78:	c791                	beqz	a5,80203b84 <handle_exception+0x7a>
				exit_proc(-1);
    80203b7a:	557d                	li	a0,-1
    80203b7c:	00002097          	auipc	ra,0x2
    80203b80:	226080e7          	jalr	550(ra) # 80205da2 <exit_proc>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203b84:	fc043783          	ld	a5,-64(s0)
    80203b88:	639c                	ld	a5,0(a5)
    80203b8a:	0791                	addi	a5,a5,4
    80203b8c:	85be                	mv	a1,a5
    80203b8e:	fc843503          	ld	a0,-56(s0)
    80203b92:	00000097          	auipc	ra,0x0
    80203b96:	b86080e7          	jalr	-1146(ra) # 80203718 <set_sepc>
            break;
    80203b9a:	ae6d                	j	80203f54 <handle_exception+0x44a>
            printf("Instruction access fault: 0x%lx\n", info->stval);
    80203b9c:	fc043783          	ld	a5,-64(s0)
    80203ba0:	6f9c                	ld	a5,24(a5)
    80203ba2:	85be                	mv	a1,a5
    80203ba4:	00018517          	auipc	a0,0x18
    80203ba8:	d9450513          	addi	a0,a0,-620 # 8021b938 <user_test_table+0x170>
    80203bac:	ffffd097          	auipc	ra,0xffffd
    80203bb0:	182080e7          	jalr	386(ra) # 80200d2e <printf>
			if(myproc()->is_user){
    80203bb4:	00001097          	auipc	ra,0x1
    80203bb8:	3fc080e7          	jalr	1020(ra) # 80204fb0 <myproc>
    80203bbc:	87aa                	mv	a5,a0
    80203bbe:	0a87a783          	lw	a5,168(a5)
    80203bc2:	c791                	beqz	a5,80203bce <handle_exception+0xc4>
				exit_proc(-1);
    80203bc4:	557d                	li	a0,-1
    80203bc6:	00002097          	auipc	ra,0x2
    80203bca:	1dc080e7          	jalr	476(ra) # 80205da2 <exit_proc>
			set_sepc(tf, info->sepc + 4);  // 使用辅助函数
    80203bce:	fc043783          	ld	a5,-64(s0)
    80203bd2:	639c                	ld	a5,0(a5)
    80203bd4:	0791                	addi	a5,a5,4
    80203bd6:	85be                	mv	a1,a5
    80203bd8:	fc843503          	ld	a0,-56(s0)
    80203bdc:	00000097          	auipc	ra,0x0
    80203be0:	b3c080e7          	jalr	-1220(ra) # 80203718 <set_sepc>
            break;
    80203be4:	ae85                	j	80203f54 <handle_exception+0x44a>
			if (copyin((char*)&instruction, (uint64)info->sepc, 4) == 0) {
    80203be6:	fc043783          	ld	a5,-64(s0)
    80203bea:	6398                	ld	a4,0(a5)
    80203bec:	fdc40793          	addi	a5,s0,-36
    80203bf0:	4611                	li	a2,4
    80203bf2:	85ba                	mv	a1,a4
    80203bf4:	853e                	mv	a0,a5
    80203bf6:	00000097          	auipc	ra,0x0
    80203bfa:	3da080e7          	jalr	986(ra) # 80203fd0 <copyin>
    80203bfe:	87aa                	mv	a5,a0
    80203c00:	ebcd                	bnez	a5,80203cb2 <handle_exception+0x1a8>
				uint32_t opcode = instruction & 0x7f;
    80203c02:	fdc42783          	lw	a5,-36(s0)
    80203c06:	07f7f793          	andi	a5,a5,127
    80203c0a:	fef42223          	sw	a5,-28(s0)
				uint32_t funct3 = (instruction >> 12) & 0x7;
    80203c0e:	fdc42783          	lw	a5,-36(s0)
    80203c12:	00c7d79b          	srliw	a5,a5,0xc
    80203c16:	2781                	sext.w	a5,a5
    80203c18:	8b9d                	andi	a5,a5,7
    80203c1a:	fef42023          	sw	a5,-32(s0)
				if (opcode == 0x33 && (funct3 == 0x4 || funct3 == 0x5 || 
    80203c1e:	fe442783          	lw	a5,-28(s0)
    80203c22:	0007871b          	sext.w	a4,a5
    80203c26:	03300793          	li	a5,51
    80203c2a:	06f71363          	bne	a4,a5,80203c90 <handle_exception+0x186>
    80203c2e:	fe042783          	lw	a5,-32(s0)
    80203c32:	0007871b          	sext.w	a4,a5
    80203c36:	4791                	li	a5,4
    80203c38:	02f70763          	beq	a4,a5,80203c66 <handle_exception+0x15c>
    80203c3c:	fe042783          	lw	a5,-32(s0)
    80203c40:	0007871b          	sext.w	a4,a5
    80203c44:	4795                	li	a5,5
    80203c46:	02f70063          	beq	a4,a5,80203c66 <handle_exception+0x15c>
    80203c4a:	fe042783          	lw	a5,-32(s0)
    80203c4e:	0007871b          	sext.w	a4,a5
    80203c52:	4799                	li	a5,6
    80203c54:	00f70963          	beq	a4,a5,80203c66 <handle_exception+0x15c>
					funct3 == 0x6 || funct3 == 0x7)) {
    80203c58:	fe042783          	lw	a5,-32(s0)
    80203c5c:	0007871b          	sext.w	a4,a5
    80203c60:	479d                	li	a5,7
    80203c62:	02f71763          	bne	a4,a5,80203c90 <handle_exception+0x186>
					printf("[FATAL] Process %d killed by divide by zero\n", myproc()->pid);
    80203c66:	00001097          	auipc	ra,0x1
    80203c6a:	34a080e7          	jalr	842(ra) # 80204fb0 <myproc>
    80203c6e:	87aa                	mv	a5,a0
    80203c70:	43dc                	lw	a5,4(a5)
    80203c72:	85be                	mv	a1,a5
    80203c74:	00018517          	auipc	a0,0x18
    80203c78:	cec50513          	addi	a0,a0,-788 # 8021b960 <user_test_table+0x198>
    80203c7c:	ffffd097          	auipc	ra,0xffffd
    80203c80:	0b2080e7          	jalr	178(ra) # 80200d2e <printf>
            		exit_proc(-1);  // 直接终止进程
    80203c84:	557d                	li	a0,-1
    80203c86:	00002097          	auipc	ra,0x2
    80203c8a:	11c080e7          	jalr	284(ra) # 80205da2 <exit_proc>
    80203c8e:	a091                	j	80203cd2 <handle_exception+0x1c8>
					printf("Illegal instruction at 0x%lx: 0x%lx\n", 
    80203c90:	fc043783          	ld	a5,-64(s0)
    80203c94:	6398                	ld	a4,0(a5)
    80203c96:	fc043783          	ld	a5,-64(s0)
    80203c9a:	6f9c                	ld	a5,24(a5)
    80203c9c:	863e                	mv	a2,a5
    80203c9e:	85ba                	mv	a1,a4
    80203ca0:	00018517          	auipc	a0,0x18
    80203ca4:	cf050513          	addi	a0,a0,-784 # 8021b990 <user_test_table+0x1c8>
    80203ca8:	ffffd097          	auipc	ra,0xffffd
    80203cac:	086080e7          	jalr	134(ra) # 80200d2e <printf>
    80203cb0:	a00d                	j	80203cd2 <handle_exception+0x1c8>
				printf("Illegal instruction at 0x%lx: 0x%lx\n", 
    80203cb2:	fc043783          	ld	a5,-64(s0)
    80203cb6:	6398                	ld	a4,0(a5)
    80203cb8:	fc043783          	ld	a5,-64(s0)
    80203cbc:	6f9c                	ld	a5,24(a5)
    80203cbe:	863e                	mv	a2,a5
    80203cc0:	85ba                	mv	a1,a4
    80203cc2:	00018517          	auipc	a0,0x18
    80203cc6:	cce50513          	addi	a0,a0,-818 # 8021b990 <user_test_table+0x1c8>
    80203cca:	ffffd097          	auipc	ra,0xffffd
    80203cce:	064080e7          	jalr	100(ra) # 80200d2e <printf>
			if(myproc()->is_user){
    80203cd2:	00001097          	auipc	ra,0x1
    80203cd6:	2de080e7          	jalr	734(ra) # 80204fb0 <myproc>
    80203cda:	87aa                	mv	a5,a0
    80203cdc:	0a87a783          	lw	a5,168(a5)
    80203ce0:	c791                	beqz	a5,80203cec <handle_exception+0x1e2>
				exit_proc(-1);
    80203ce2:	557d                	li	a0,-1
    80203ce4:	00002097          	auipc	ra,0x2
    80203ce8:	0be080e7          	jalr	190(ra) # 80205da2 <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203cec:	fc043783          	ld	a5,-64(s0)
    80203cf0:	639c                	ld	a5,0(a5)
    80203cf2:	0791                	addi	a5,a5,4
    80203cf4:	85be                	mv	a1,a5
    80203cf6:	fc843503          	ld	a0,-56(s0)
    80203cfa:	00000097          	auipc	ra,0x0
    80203cfe:	a1e080e7          	jalr	-1506(ra) # 80203718 <set_sepc>
			break;
    80203d02:	ac89                	j	80203f54 <handle_exception+0x44a>
            printf("Breakpoint at 0x%lx\n", info->sepc);
    80203d04:	fc043783          	ld	a5,-64(s0)
    80203d08:	639c                	ld	a5,0(a5)
    80203d0a:	85be                	mv	a1,a5
    80203d0c:	00018517          	auipc	a0,0x18
    80203d10:	cac50513          	addi	a0,a0,-852 # 8021b9b8 <user_test_table+0x1f0>
    80203d14:	ffffd097          	auipc	ra,0xffffd
    80203d18:	01a080e7          	jalr	26(ra) # 80200d2e <printf>
            set_sepc(tf, info->sepc + 4);
    80203d1c:	fc043783          	ld	a5,-64(s0)
    80203d20:	639c                	ld	a5,0(a5)
    80203d22:	0791                	addi	a5,a5,4
    80203d24:	85be                	mv	a1,a5
    80203d26:	fc843503          	ld	a0,-56(s0)
    80203d2a:	00000097          	auipc	ra,0x0
    80203d2e:	9ee080e7          	jalr	-1554(ra) # 80203718 <set_sepc>
            break;
    80203d32:	a40d                	j	80203f54 <handle_exception+0x44a>
            printf("Load address misaligned: 0x%lx\n", info->stval);
    80203d34:	fc043783          	ld	a5,-64(s0)
    80203d38:	6f9c                	ld	a5,24(a5)
    80203d3a:	85be                	mv	a1,a5
    80203d3c:	00018517          	auipc	a0,0x18
    80203d40:	c9450513          	addi	a0,a0,-876 # 8021b9d0 <user_test_table+0x208>
    80203d44:	ffffd097          	auipc	ra,0xffffd
    80203d48:	fea080e7          	jalr	-22(ra) # 80200d2e <printf>
			if(myproc()->is_user){
    80203d4c:	00001097          	auipc	ra,0x1
    80203d50:	264080e7          	jalr	612(ra) # 80204fb0 <myproc>
    80203d54:	87aa                	mv	a5,a0
    80203d56:	0a87a783          	lw	a5,168(a5)
    80203d5a:	c791                	beqz	a5,80203d66 <handle_exception+0x25c>
				exit_proc(-1);
    80203d5c:	557d                	li	a0,-1
    80203d5e:	00002097          	auipc	ra,0x2
    80203d62:	044080e7          	jalr	68(ra) # 80205da2 <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203d66:	fc043783          	ld	a5,-64(s0)
    80203d6a:	639c                	ld	a5,0(a5)
    80203d6c:	0791                	addi	a5,a5,4
    80203d6e:	85be                	mv	a1,a5
    80203d70:	fc843503          	ld	a0,-56(s0)
    80203d74:	00000097          	auipc	ra,0x0
    80203d78:	9a4080e7          	jalr	-1628(ra) # 80203718 <set_sepc>
            break;
    80203d7c:	aae1                	j	80203f54 <handle_exception+0x44a>
			printf("Load access fault: 0x%lx\n", info->stval);
    80203d7e:	fc043783          	ld	a5,-64(s0)
    80203d82:	6f9c                	ld	a5,24(a5)
    80203d84:	85be                	mv	a1,a5
    80203d86:	00018517          	auipc	a0,0x18
    80203d8a:	c6a50513          	addi	a0,a0,-918 # 8021b9f0 <user_test_table+0x228>
    80203d8e:	ffffd097          	auipc	ra,0xffffd
    80203d92:	fa0080e7          	jalr	-96(ra) # 80200d2e <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 2)) {
    80203d96:	fc043783          	ld	a5,-64(s0)
    80203d9a:	6f9c                	ld	a5,24(a5)
    80203d9c:	853e                	mv	a0,a5
    80203d9e:	fffff097          	auipc	ra,0xfffff
    80203da2:	2da080e7          	jalr	730(ra) # 80203078 <check_is_mapped>
    80203da6:	87aa                	mv	a5,a0
    80203da8:	cf89                	beqz	a5,80203dc2 <handle_exception+0x2b8>
    80203daa:	fc043783          	ld	a5,-64(s0)
    80203dae:	6f9c                	ld	a5,24(a5)
    80203db0:	4589                	li	a1,2
    80203db2:	853e                	mv	a0,a5
    80203db4:	fffff097          	auipc	ra,0xfffff
    80203db8:	c68080e7          	jalr	-920(ra) # 80202a1c <handle_page_fault>
    80203dbc:	87aa                	mv	a5,a0
    80203dbe:	18079863          	bnez	a5,80203f4e <handle_exception+0x444>
			set_sepc(tf, info->sepc + 4);
    80203dc2:	fc043783          	ld	a5,-64(s0)
    80203dc6:	639c                	ld	a5,0(a5)
    80203dc8:	0791                	addi	a5,a5,4
    80203dca:	85be                	mv	a1,a5
    80203dcc:	fc843503          	ld	a0,-56(s0)
    80203dd0:	00000097          	auipc	ra,0x0
    80203dd4:	948080e7          	jalr	-1720(ra) # 80203718 <set_sepc>
			break;
    80203dd8:	aab5                	j	80203f54 <handle_exception+0x44a>
            printf("Store address misaligned: 0x%lx\n", info->stval);
    80203dda:	fc043783          	ld	a5,-64(s0)
    80203dde:	6f9c                	ld	a5,24(a5)
    80203de0:	85be                	mv	a1,a5
    80203de2:	00018517          	auipc	a0,0x18
    80203de6:	c2e50513          	addi	a0,a0,-978 # 8021ba10 <user_test_table+0x248>
    80203dea:	ffffd097          	auipc	ra,0xffffd
    80203dee:	f44080e7          	jalr	-188(ra) # 80200d2e <printf>
			if(myproc()->is_user){
    80203df2:	00001097          	auipc	ra,0x1
    80203df6:	1be080e7          	jalr	446(ra) # 80204fb0 <myproc>
    80203dfa:	87aa                	mv	a5,a0
    80203dfc:	0a87a783          	lw	a5,168(a5)
    80203e00:	c791                	beqz	a5,80203e0c <handle_exception+0x302>
				exit_proc(-1);
    80203e02:	557d                	li	a0,-1
    80203e04:	00002097          	auipc	ra,0x2
    80203e08:	f9e080e7          	jalr	-98(ra) # 80205da2 <exit_proc>
			set_sepc(tf, info->sepc + 4); 
    80203e0c:	fc043783          	ld	a5,-64(s0)
    80203e10:	639c                	ld	a5,0(a5)
    80203e12:	0791                	addi	a5,a5,4
    80203e14:	85be                	mv	a1,a5
    80203e16:	fc843503          	ld	a0,-56(s0)
    80203e1a:	00000097          	auipc	ra,0x0
    80203e1e:	8fe080e7          	jalr	-1794(ra) # 80203718 <set_sepc>
            break;
    80203e22:	aa0d                	j	80203f54 <handle_exception+0x44a>
			printf("Store access fault: 0x%lx\n", info->stval);
    80203e24:	fc043783          	ld	a5,-64(s0)
    80203e28:	6f9c                	ld	a5,24(a5)
    80203e2a:	85be                	mv	a1,a5
    80203e2c:	00018517          	auipc	a0,0x18
    80203e30:	c0c50513          	addi	a0,a0,-1012 # 8021ba38 <user_test_table+0x270>
    80203e34:	ffffd097          	auipc	ra,0xffffd
    80203e38:	efa080e7          	jalr	-262(ra) # 80200d2e <printf>
			if (check_is_mapped(info->stval) && handle_page_fault(info->stval, 3)) {
    80203e3c:	fc043783          	ld	a5,-64(s0)
    80203e40:	6f9c                	ld	a5,24(a5)
    80203e42:	853e                	mv	a0,a5
    80203e44:	fffff097          	auipc	ra,0xfffff
    80203e48:	234080e7          	jalr	564(ra) # 80203078 <check_is_mapped>
    80203e4c:	87aa                	mv	a5,a0
    80203e4e:	cf81                	beqz	a5,80203e66 <handle_exception+0x35c>
    80203e50:	fc043783          	ld	a5,-64(s0)
    80203e54:	6f9c                	ld	a5,24(a5)
    80203e56:	458d                	li	a1,3
    80203e58:	853e                	mv	a0,a5
    80203e5a:	fffff097          	auipc	ra,0xfffff
    80203e5e:	bc2080e7          	jalr	-1086(ra) # 80202a1c <handle_page_fault>
    80203e62:	87aa                	mv	a5,a0
    80203e64:	e7fd                	bnez	a5,80203f52 <handle_exception+0x448>
			set_sepc(tf, info->sepc + 4);
    80203e66:	fc043783          	ld	a5,-64(s0)
    80203e6a:	639c                	ld	a5,0(a5)
    80203e6c:	0791                	addi	a5,a5,4
    80203e6e:	85be                	mv	a1,a5
    80203e70:	fc843503          	ld	a0,-56(s0)
    80203e74:	00000097          	auipc	ra,0x0
    80203e78:	8a4080e7          	jalr	-1884(ra) # 80203718 <set_sepc>
			break;
    80203e7c:	a8e1                	j	80203f54 <handle_exception+0x44a>
			if(myproc()->is_user){
    80203e7e:	00001097          	auipc	ra,0x1
    80203e82:	132080e7          	jalr	306(ra) # 80204fb0 <myproc>
    80203e86:	87aa                	mv	a5,a0
    80203e88:	0a87a783          	lw	a5,168(a5)
    80203e8c:	cb91                	beqz	a5,80203ea0 <handle_exception+0x396>
            	handle_syscall(tf,info);
    80203e8e:	fc043583          	ld	a1,-64(s0)
    80203e92:	fc843503          	ld	a0,-56(s0)
    80203e96:	00000097          	auipc	ra,0x0
    80203e9a:	42a080e7          	jalr	1066(ra) # 802042c0 <handle_syscall>
            break;
    80203e9e:	a85d                	j	80203f54 <handle_exception+0x44a>
				warning("[EXCEPTION] ecall was called in S-mode");
    80203ea0:	00018517          	auipc	a0,0x18
    80203ea4:	bb850513          	addi	a0,a0,-1096 # 8021ba58 <user_test_table+0x290>
    80203ea8:	ffffe097          	auipc	ra,0xffffe
    80203eac:	906080e7          	jalr	-1786(ra) # 802017ae <warning>
            break;
    80203eb0:	a055                	j	80203f54 <handle_exception+0x44a>
            printf("Supervisor environment call at 0x%lx\n", info->sepc);
    80203eb2:	fc043783          	ld	a5,-64(s0)
    80203eb6:	639c                	ld	a5,0(a5)
    80203eb8:	85be                	mv	a1,a5
    80203eba:	00018517          	auipc	a0,0x18
    80203ebe:	bc650513          	addi	a0,a0,-1082 # 8021ba80 <user_test_table+0x2b8>
    80203ec2:	ffffd097          	auipc	ra,0xffffd
    80203ec6:	e6c080e7          	jalr	-404(ra) # 80200d2e <printf>
			set_sepc(tf, info->sepc + 4); 
    80203eca:	fc043783          	ld	a5,-64(s0)
    80203ece:	639c                	ld	a5,0(a5)
    80203ed0:	0791                	addi	a5,a5,4
    80203ed2:	85be                	mv	a1,a5
    80203ed4:	fc843503          	ld	a0,-56(s0)
    80203ed8:	00000097          	auipc	ra,0x0
    80203edc:	840080e7          	jalr	-1984(ra) # 80203718 <set_sepc>
            break;
    80203ee0:	a895                	j	80203f54 <handle_exception+0x44a>
            handle_instruction_page_fault(tf,info);
    80203ee2:	fc043583          	ld	a1,-64(s0)
    80203ee6:	fc843503          	ld	a0,-56(s0)
    80203eea:	00001097          	auipc	ra,0x1
    80203eee:	838080e7          	jalr	-1992(ra) # 80204722 <handle_instruction_page_fault>
            break;
    80203ef2:	a08d                	j	80203f54 <handle_exception+0x44a>
            handle_load_page_fault(tf,info);
    80203ef4:	fc043583          	ld	a1,-64(s0)
    80203ef8:	fc843503          	ld	a0,-56(s0)
    80203efc:	00001097          	auipc	ra,0x1
    80203f00:	888080e7          	jalr	-1912(ra) # 80204784 <handle_load_page_fault>
            break;
    80203f04:	a881                	j	80203f54 <handle_exception+0x44a>
            handle_store_page_fault(tf,info);
    80203f06:	fc043583          	ld	a1,-64(s0)
    80203f0a:	fc843503          	ld	a0,-56(s0)
    80203f0e:	00001097          	auipc	ra,0x1
    80203f12:	8d8080e7          	jalr	-1832(ra) # 802047e6 <handle_store_page_fault>
            break;
    80203f16:	a83d                	j	80203f54 <handle_exception+0x44a>
            printf("Unknown exception: cause=%ld, sepc=0x%lx, stval=0x%lx\n", 
    80203f18:	fc043783          	ld	a5,-64(s0)
    80203f1c:	6398                	ld	a4,0(a5)
    80203f1e:	fc043783          	ld	a5,-64(s0)
    80203f22:	6f9c                	ld	a5,24(a5)
    80203f24:	86be                	mv	a3,a5
    80203f26:	863a                	mv	a2,a4
    80203f28:	fe843583          	ld	a1,-24(s0)
    80203f2c:	00018517          	auipc	a0,0x18
    80203f30:	b7c50513          	addi	a0,a0,-1156 # 8021baa8 <user_test_table+0x2e0>
    80203f34:	ffffd097          	auipc	ra,0xffffd
    80203f38:	dfa080e7          	jalr	-518(ra) # 80200d2e <printf>
            panic("Unknown exception");
    80203f3c:	00018517          	auipc	a0,0x18
    80203f40:	ba450513          	addi	a0,a0,-1116 # 8021bae0 <user_test_table+0x318>
    80203f44:	ffffe097          	auipc	ra,0xffffe
    80203f48:	836080e7          	jalr	-1994(ra) # 8020177a <panic>
            break;
    80203f4c:	a021                	j	80203f54 <handle_exception+0x44a>
				return; // 成功处理
    80203f4e:	0001                	nop
    80203f50:	a011                	j	80203f54 <handle_exception+0x44a>
				return; // 成功处理
    80203f52:	0001                	nop
}
    80203f54:	70e2                	ld	ra,56(sp)
    80203f56:	7442                	ld	s0,48(sp)
    80203f58:	6121                	addi	sp,sp,64
    80203f5a:	8082                	ret

0000000080203f5c <user_va2pa>:
void* user_va2pa(pagetable_t pagetable, uint64 va) {
    80203f5c:	7179                	addi	sp,sp,-48
    80203f5e:	f406                	sd	ra,40(sp)
    80203f60:	f022                	sd	s0,32(sp)
    80203f62:	1800                	addi	s0,sp,48
    80203f64:	fca43c23          	sd	a0,-40(s0)
    80203f68:	fcb43823          	sd	a1,-48(s0)
    pte_t *pte = walk_lookup(pagetable, va);
    80203f6c:	fd043583          	ld	a1,-48(s0)
    80203f70:	fd843503          	ld	a0,-40(s0)
    80203f74:	ffffe097          	auipc	ra,0xffffe
    80203f78:	1dc080e7          	jalr	476(ra) # 80202150 <walk_lookup>
    80203f7c:	fea43423          	sd	a0,-24(s0)
    if (!pte) return 0;
    80203f80:	fe843783          	ld	a5,-24(s0)
    80203f84:	e399                	bnez	a5,80203f8a <user_va2pa+0x2e>
    80203f86:	4781                	li	a5,0
    80203f88:	a83d                	j	80203fc6 <user_va2pa+0x6a>
    if (!(*pte & PTE_V)) return 0;
    80203f8a:	fe843783          	ld	a5,-24(s0)
    80203f8e:	639c                	ld	a5,0(a5)
    80203f90:	8b85                	andi	a5,a5,1
    80203f92:	e399                	bnez	a5,80203f98 <user_va2pa+0x3c>
    80203f94:	4781                	li	a5,0
    80203f96:	a805                	j	80203fc6 <user_va2pa+0x6a>
    if (!(*pte & PTE_U)) return 0; // 必须是用户可访问
    80203f98:	fe843783          	ld	a5,-24(s0)
    80203f9c:	639c                	ld	a5,0(a5)
    80203f9e:	8bc1                	andi	a5,a5,16
    80203fa0:	e399                	bnez	a5,80203fa6 <user_va2pa+0x4a>
    80203fa2:	4781                	li	a5,0
    80203fa4:	a00d                	j	80203fc6 <user_va2pa+0x6a>
    uint64 pa = (PTE2PA(*pte)) | (va & 0xFFF); // 物理页基址 + 页内偏移
    80203fa6:	fe843783          	ld	a5,-24(s0)
    80203faa:	639c                	ld	a5,0(a5)
    80203fac:	83a9                	srli	a5,a5,0xa
    80203fae:	00c79713          	slli	a4,a5,0xc
    80203fb2:	fd043683          	ld	a3,-48(s0)
    80203fb6:	6785                	lui	a5,0x1
    80203fb8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    80203fba:	8ff5                	and	a5,a5,a3
    80203fbc:	8fd9                	or	a5,a5,a4
    80203fbe:	fef43023          	sd	a5,-32(s0)
    return (void*)pa;
    80203fc2:	fe043783          	ld	a5,-32(s0)
}
    80203fc6:	853e                	mv	a0,a5
    80203fc8:	70a2                	ld	ra,40(sp)
    80203fca:	7402                	ld	s0,32(sp)
    80203fcc:	6145                	addi	sp,sp,48
    80203fce:	8082                	ret

0000000080203fd0 <copyin>:
int copyin(char *dst, uint64 srcva, int maxlen) {
    80203fd0:	715d                	addi	sp,sp,-80
    80203fd2:	e486                	sd	ra,72(sp)
    80203fd4:	e0a2                	sd	s0,64(sp)
    80203fd6:	0880                	addi	s0,sp,80
    80203fd8:	fca43423          	sd	a0,-56(s0)
    80203fdc:	fcb43023          	sd	a1,-64(s0)
    80203fe0:	87b2                	mv	a5,a2
    80203fe2:	faf42e23          	sw	a5,-68(s0)
    struct proc *p = myproc();
    80203fe6:	00001097          	auipc	ra,0x1
    80203fea:	fca080e7          	jalr	-54(ra) # 80204fb0 <myproc>
    80203fee:	fea43023          	sd	a0,-32(s0)
    for (int i = 0; i < maxlen; i++) {
    80203ff2:	fe042623          	sw	zero,-20(s0)
    80203ff6:	a085                	j	80204056 <copyin+0x86>
        char *pa = user_va2pa(p->pagetable, srcva + i);
    80203ff8:	fe043783          	ld	a5,-32(s0)
    80203ffc:	7fd4                	ld	a3,184(a5)
    80203ffe:	fec42703          	lw	a4,-20(s0)
    80204002:	fc043783          	ld	a5,-64(s0)
    80204006:	97ba                	add	a5,a5,a4
    80204008:	85be                	mv	a1,a5
    8020400a:	8536                	mv	a0,a3
    8020400c:	00000097          	auipc	ra,0x0
    80204010:	f50080e7          	jalr	-176(ra) # 80203f5c <user_va2pa>
    80204014:	fca43c23          	sd	a0,-40(s0)
        if (!pa) return -1;
    80204018:	fd843783          	ld	a5,-40(s0)
    8020401c:	e399                	bnez	a5,80204022 <copyin+0x52>
    8020401e:	57fd                	li	a5,-1
    80204020:	a0a9                	j	8020406a <copyin+0x9a>
        dst[i] = *pa;
    80204022:	fec42783          	lw	a5,-20(s0)
    80204026:	fc843703          	ld	a4,-56(s0)
    8020402a:	97ba                	add	a5,a5,a4
    8020402c:	fd843703          	ld	a4,-40(s0)
    80204030:	00074703          	lbu	a4,0(a4)
    80204034:	00e78023          	sb	a4,0(a5)
        if (dst[i] == 0) return 0;
    80204038:	fec42783          	lw	a5,-20(s0)
    8020403c:	fc843703          	ld	a4,-56(s0)
    80204040:	97ba                	add	a5,a5,a4
    80204042:	0007c783          	lbu	a5,0(a5)
    80204046:	e399                	bnez	a5,8020404c <copyin+0x7c>
    80204048:	4781                	li	a5,0
    8020404a:	a005                	j	8020406a <copyin+0x9a>
    for (int i = 0; i < maxlen; i++) {
    8020404c:	fec42783          	lw	a5,-20(s0)
    80204050:	2785                	addiw	a5,a5,1
    80204052:	fef42623          	sw	a5,-20(s0)
    80204056:	fec42783          	lw	a5,-20(s0)
    8020405a:	873e                	mv	a4,a5
    8020405c:	fbc42783          	lw	a5,-68(s0)
    80204060:	2701                	sext.w	a4,a4
    80204062:	2781                	sext.w	a5,a5
    80204064:	f8f74ae3          	blt	a4,a5,80203ff8 <copyin+0x28>
    return 0;
    80204068:	4781                	li	a5,0
}
    8020406a:	853e                	mv	a0,a5
    8020406c:	60a6                	ld	ra,72(sp)
    8020406e:	6406                	ld	s0,64(sp)
    80204070:	6161                	addi	sp,sp,80
    80204072:	8082                	ret

0000000080204074 <copyout>:
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80204074:	7139                	addi	sp,sp,-64
    80204076:	fc06                	sd	ra,56(sp)
    80204078:	f822                	sd	s0,48(sp)
    8020407a:	0080                	addi	s0,sp,64
    8020407c:	fca43c23          	sd	a0,-40(s0)
    80204080:	fcb43823          	sd	a1,-48(s0)
    80204084:	fcc43423          	sd	a2,-56(s0)
    80204088:	fcd43023          	sd	a3,-64(s0)
    for (uint64 i = 0; i < len; i++) {
    8020408c:	fe043423          	sd	zero,-24(s0)
    80204090:	a0a1                	j	802040d8 <copyout+0x64>
        char *pa = user_va2pa(pagetable, dstva + i);
    80204092:	fd043703          	ld	a4,-48(s0)
    80204096:	fe843783          	ld	a5,-24(s0)
    8020409a:	97ba                	add	a5,a5,a4
    8020409c:	85be                	mv	a1,a5
    8020409e:	fd843503          	ld	a0,-40(s0)
    802040a2:	00000097          	auipc	ra,0x0
    802040a6:	eba080e7          	jalr	-326(ra) # 80203f5c <user_va2pa>
    802040aa:	fea43023          	sd	a0,-32(s0)
        if (!pa) return -1;
    802040ae:	fe043783          	ld	a5,-32(s0)
    802040b2:	e399                	bnez	a5,802040b8 <copyout+0x44>
    802040b4:	57fd                	li	a5,-1
    802040b6:	a805                	j	802040e6 <copyout+0x72>
        *pa = src[i];
    802040b8:	fc843703          	ld	a4,-56(s0)
    802040bc:	fe843783          	ld	a5,-24(s0)
    802040c0:	97ba                	add	a5,a5,a4
    802040c2:	0007c703          	lbu	a4,0(a5)
    802040c6:	fe043783          	ld	a5,-32(s0)
    802040ca:	00e78023          	sb	a4,0(a5)
    for (uint64 i = 0; i < len; i++) {
    802040ce:	fe843783          	ld	a5,-24(s0)
    802040d2:	0785                	addi	a5,a5,1
    802040d4:	fef43423          	sd	a5,-24(s0)
    802040d8:	fe843703          	ld	a4,-24(s0)
    802040dc:	fc043783          	ld	a5,-64(s0)
    802040e0:	faf769e3          	bltu	a4,a5,80204092 <copyout+0x1e>
    return 0;
    802040e4:	4781                	li	a5,0
}
    802040e6:	853e                	mv	a0,a5
    802040e8:	70e2                	ld	ra,56(sp)
    802040ea:	7442                	ld	s0,48(sp)
    802040ec:	6121                	addi	sp,sp,64
    802040ee:	8082                	ret

00000000802040f0 <copyinstr>:
int copyinstr(char *dst, pagetable_t pagetable, uint64 srcva, int max) {
    802040f0:	7139                	addi	sp,sp,-64
    802040f2:	fc06                	sd	ra,56(sp)
    802040f4:	f822                	sd	s0,48(sp)
    802040f6:	0080                	addi	s0,sp,64
    802040f8:	fca43c23          	sd	a0,-40(s0)
    802040fc:	fcb43823          	sd	a1,-48(s0)
    80204100:	fcc43423          	sd	a2,-56(s0)
    80204104:	87b6                	mv	a5,a3
    80204106:	fcf42223          	sw	a5,-60(s0)
    for (i = 0; i < max; i++) {
    8020410a:	fe042623          	sw	zero,-20(s0)
    8020410e:	a0b9                	j	8020415c <copyinstr+0x6c>
        if (copyin(&c, srcva + i, 1) < 0)  // 每次拷贝 1 字节
    80204110:	fec42703          	lw	a4,-20(s0)
    80204114:	fc843783          	ld	a5,-56(s0)
    80204118:	973e                	add	a4,a4,a5
    8020411a:	feb40793          	addi	a5,s0,-21
    8020411e:	4605                	li	a2,1
    80204120:	85ba                	mv	a1,a4
    80204122:	853e                	mv	a0,a5
    80204124:	00000097          	auipc	ra,0x0
    80204128:	eac080e7          	jalr	-340(ra) # 80203fd0 <copyin>
    8020412c:	87aa                	mv	a5,a0
    8020412e:	0007d463          	bgez	a5,80204136 <copyinstr+0x46>
            return -1;
    80204132:	57fd                	li	a5,-1
    80204134:	a0b1                	j	80204180 <copyinstr+0x90>
        dst[i] = c;
    80204136:	fec42783          	lw	a5,-20(s0)
    8020413a:	fd843703          	ld	a4,-40(s0)
    8020413e:	97ba                	add	a5,a5,a4
    80204140:	feb44703          	lbu	a4,-21(s0)
    80204144:	00e78023          	sb	a4,0(a5)
        if (c == '\0')
    80204148:	feb44783          	lbu	a5,-21(s0)
    8020414c:	e399                	bnez	a5,80204152 <copyinstr+0x62>
            return 0;
    8020414e:	4781                	li	a5,0
    80204150:	a805                	j	80204180 <copyinstr+0x90>
    for (i = 0; i < max; i++) {
    80204152:	fec42783          	lw	a5,-20(s0)
    80204156:	2785                	addiw	a5,a5,1
    80204158:	fef42623          	sw	a5,-20(s0)
    8020415c:	fec42783          	lw	a5,-20(s0)
    80204160:	873e                	mv	a4,a5
    80204162:	fc442783          	lw	a5,-60(s0)
    80204166:	2701                	sext.w	a4,a4
    80204168:	2781                	sext.w	a5,a5
    8020416a:	faf743e3          	blt	a4,a5,80204110 <copyinstr+0x20>
    dst[max-1] = '\0';
    8020416e:	fc442783          	lw	a5,-60(s0)
    80204172:	17fd                	addi	a5,a5,-1
    80204174:	fd843703          	ld	a4,-40(s0)
    80204178:	97ba                	add	a5,a5,a4
    8020417a:	00078023          	sb	zero,0(a5)
    return -1; // 超过最大长度还没遇到 \0
    8020417e:	57fd                	li	a5,-1
}
    80204180:	853e                	mv	a0,a5
    80204182:	70e2                	ld	ra,56(sp)
    80204184:	7442                	ld	s0,48(sp)
    80204186:	6121                	addi	sp,sp,64
    80204188:	8082                	ret

000000008020418a <check_user_addr>:
int check_user_addr(uint64 addr, uint64 size, int write) {
    8020418a:	7179                	addi	sp,sp,-48
    8020418c:	f422                	sd	s0,40(sp)
    8020418e:	1800                	addi	s0,sp,48
    80204190:	fea43423          	sd	a0,-24(s0)
    80204194:	feb43023          	sd	a1,-32(s0)
    80204198:	87b2                	mv	a5,a2
    8020419a:	fcf42e23          	sw	a5,-36(s0)
    if (!IS_USER_ADDR(addr) || !IS_USER_ADDR(addr + size - 1))
    8020419e:	fe843703          	ld	a4,-24(s0)
    802041a2:	67c1                	lui	a5,0x10
    802041a4:	02f76d63          	bltu	a4,a5,802041de <check_user_addr+0x54>
    802041a8:	fe843703          	ld	a4,-24(s0)
    802041ac:	57fd                	li	a5,-1
    802041ae:	83e5                	srli	a5,a5,0x19
    802041b0:	02e7e763          	bltu	a5,a4,802041de <check_user_addr+0x54>
    802041b4:	fe843703          	ld	a4,-24(s0)
    802041b8:	fe043783          	ld	a5,-32(s0)
    802041bc:	97ba                	add	a5,a5,a4
    802041be:	fff78713          	addi	a4,a5,-1 # ffff <_entry-0x801f0001>
    802041c2:	67c1                	lui	a5,0x10
    802041c4:	00f76d63          	bltu	a4,a5,802041de <check_user_addr+0x54>
    802041c8:	fe843703          	ld	a4,-24(s0)
    802041cc:	fe043783          	ld	a5,-32(s0)
    802041d0:	97ba                	add	a5,a5,a4
    802041d2:	fff78713          	addi	a4,a5,-1 # ffff <_entry-0x801f0001>
    802041d6:	57fd                	li	a5,-1
    802041d8:	83e5                	srli	a5,a5,0x19
    802041da:	00e7f463          	bgeu	a5,a4,802041e2 <check_user_addr+0x58>
        return -1;
    802041de:	57fd                	li	a5,-1
    802041e0:	a8e1                	j	802042b8 <check_user_addr+0x12e>
    if (IS_USER_STACK(addr)) {
    802041e2:	fe843703          	ld	a4,-24(s0)
    802041e6:	ddfff7b7          	lui	a5,0xddfff
    802041ea:	07b6                	slli	a5,a5,0xd
    802041ec:	83e5                	srli	a5,a5,0x19
    802041ee:	04e7f663          	bgeu	a5,a4,8020423a <check_user_addr+0xb0>
    802041f2:	fe843703          	ld	a4,-24(s0)
    802041f6:	fdfff7b7          	lui	a5,0xfdfff
    802041fa:	07b6                	slli	a5,a5,0xd
    802041fc:	83e5                	srli	a5,a5,0x19
    802041fe:	02e7ee63          	bltu	a5,a4,8020423a <check_user_addr+0xb0>
        if (!IS_USER_STACK(addr + size - 1))
    80204202:	fe843703          	ld	a4,-24(s0)
    80204206:	fe043783          	ld	a5,-32(s0)
    8020420a:	97ba                	add	a5,a5,a4
    8020420c:	fff78713          	addi	a4,a5,-1 # fffffffffdffefff <_bss_end+0xffffffff7ddd790f>
    80204210:	ddfff7b7          	lui	a5,0xddfff
    80204214:	07b6                	slli	a5,a5,0xd
    80204216:	83e5                	srli	a5,a5,0x19
    80204218:	00e7ff63          	bgeu	a5,a4,80204236 <check_user_addr+0xac>
    8020421c:	fe843703          	ld	a4,-24(s0)
    80204220:	fe043783          	ld	a5,-32(s0)
    80204224:	97ba                	add	a5,a5,a4
    80204226:	fff78713          	addi	a4,a5,-1 # ffffffffddffefff <_bss_end+0xffffffff5ddd790f>
    8020422a:	fdfff7b7          	lui	a5,0xfdfff
    8020422e:	07b6                	slli	a5,a5,0xd
    80204230:	83e5                	srli	a5,a5,0x19
    80204232:	06e7ff63          	bgeu	a5,a4,802042b0 <check_user_addr+0x126>
            return -1;  // 跨越栈边界
    80204236:	57fd                	li	a5,-1
    80204238:	a041                	j	802042b8 <check_user_addr+0x12e>
    } else if (IS_USER_HEAP(addr)) {
    8020423a:	fe843703          	ld	a4,-24(s0)
    8020423e:	004007b7          	lui	a5,0x400
    80204242:	04f76463          	bltu	a4,a5,8020428a <check_user_addr+0x100>
    80204246:	fe843703          	ld	a4,-24(s0)
    8020424a:	ddfff7b7          	lui	a5,0xddfff
    8020424e:	07b6                	slli	a5,a5,0xd
    80204250:	83e5                	srli	a5,a5,0x19
    80204252:	02e7ec63          	bltu	a5,a4,8020428a <check_user_addr+0x100>
        if (!IS_USER_HEAP(addr + size - 1))
    80204256:	fe843703          	ld	a4,-24(s0)
    8020425a:	fe043783          	ld	a5,-32(s0)
    8020425e:	97ba                	add	a5,a5,a4
    80204260:	fff78713          	addi	a4,a5,-1 # ffffffffddffefff <_bss_end+0xffffffff5ddd790f>
    80204264:	004007b7          	lui	a5,0x400
    80204268:	00f76f63          	bltu	a4,a5,80204286 <check_user_addr+0xfc>
    8020426c:	fe843703          	ld	a4,-24(s0)
    80204270:	fe043783          	ld	a5,-32(s0)
    80204274:	97ba                	add	a5,a5,a4
    80204276:	fff78713          	addi	a4,a5,-1 # 3fffff <_entry-0x7fe00001>
    8020427a:	ddfff7b7          	lui	a5,0xddfff
    8020427e:	07b6                	slli	a5,a5,0xd
    80204280:	83e5                	srli	a5,a5,0x19
    80204282:	02e7f963          	bgeu	a5,a4,802042b4 <check_user_addr+0x12a>
            return -1;  // 跨越堆边界
    80204286:	57fd                	li	a5,-1
    80204288:	a805                	j	802042b8 <check_user_addr+0x12e>
    } else if (addr < USER_HEAP_START) {
    8020428a:	fe843703          	ld	a4,-24(s0)
    8020428e:	004007b7          	lui	a5,0x400
    80204292:	00f77d63          	bgeu	a4,a5,802042ac <check_user_addr+0x122>
        if (addr + size > USER_HEAP_START)
    80204296:	fe843703          	ld	a4,-24(s0)
    8020429a:	fe043783          	ld	a5,-32(s0)
    8020429e:	973e                	add	a4,a4,a5
    802042a0:	004007b7          	lui	a5,0x400
    802042a4:	00e7f963          	bgeu	a5,a4,802042b6 <check_user_addr+0x12c>
            return -1;  // 跨越代码/数据段边界
    802042a8:	57fd                	li	a5,-1
    802042aa:	a039                	j	802042b8 <check_user_addr+0x12e>
        return -1;  // 在未定义区域
    802042ac:	57fd                	li	a5,-1
    802042ae:	a029                	j	802042b8 <check_user_addr+0x12e>
        if (!IS_USER_STACK(addr + size - 1))
    802042b0:	0001                	nop
    802042b2:	a011                	j	802042b6 <check_user_addr+0x12c>
        if (!IS_USER_HEAP(addr + size - 1))
    802042b4:	0001                	nop
    return 0;  // 地址合法
    802042b6:	4781                	li	a5,0
}
    802042b8:	853e                	mv	a0,a5
    802042ba:	7422                	ld	s0,40(sp)
    802042bc:	6145                	addi	sp,sp,48
    802042be:	8082                	ret

00000000802042c0 <handle_syscall>:
void handle_syscall(struct trapframe *tf, struct trap_info *info) {
    802042c0:	7155                	addi	sp,sp,-208
    802042c2:	e586                	sd	ra,200(sp)
    802042c4:	e1a2                	sd	s0,192(sp)
    802042c6:	0980                	addi	s0,sp,208
    802042c8:	f2a43c23          	sd	a0,-200(s0)
    802042cc:	f2b43823          	sd	a1,-208(s0)
	switch (tf->a7) {
    802042d0:	f3843783          	ld	a5,-200(s0)
    802042d4:	73fc                	ld	a5,224(a5)
    802042d6:	6705                	lui	a4,0x1
    802042d8:	177d                	addi	a4,a4,-1 # fff <_entry-0x801ff001>
    802042da:	28e78563          	beq	a5,a4,80204564 <handle_syscall+0x2a4>
    802042de:	6705                	lui	a4,0x1
    802042e0:	40e7f063          	bgeu	a5,a4,802046e0 <handle_syscall+0x420>
    802042e4:	0de00713          	li	a4,222
    802042e8:	20e78c63          	beq	a5,a4,80204500 <handle_syscall+0x240>
    802042ec:	0de00713          	li	a4,222
    802042f0:	3ef76863          	bltu	a4,a5,802046e0 <handle_syscall+0x420>
    802042f4:	0dd00713          	li	a4,221
    802042f8:	18e78963          	beq	a5,a4,8020448a <handle_syscall+0x1ca>
    802042fc:	0dd00713          	li	a4,221
    80204300:	3ef76063          	bltu	a4,a5,802046e0 <handle_syscall+0x420>
    80204304:	0dc00713          	li	a4,220
    80204308:	14e78963          	beq	a5,a4,8020445a <handle_syscall+0x19a>
    8020430c:	0dc00713          	li	a4,220
    80204310:	3cf76863          	bltu	a4,a5,802046e0 <handle_syscall+0x420>
    80204314:	0ad00713          	li	a4,173
    80204318:	20e78863          	beq	a5,a4,80204528 <handle_syscall+0x268>
    8020431c:	0ad00713          	li	a4,173
    80204320:	3cf76063          	bltu	a4,a5,802046e0 <handle_syscall+0x420>
    80204324:	0ac00713          	li	a4,172
    80204328:	1ee78563          	beq	a5,a4,80204512 <handle_syscall+0x252>
    8020432c:	0ac00713          	li	a4,172
    80204330:	3af76863          	bltu	a4,a5,802046e0 <handle_syscall+0x420>
    80204334:	08100713          	li	a4,129
    80204338:	0ee78363          	beq	a5,a4,8020441e <handle_syscall+0x15e>
    8020433c:	08100713          	li	a4,129
    80204340:	3af76063          	bltu	a4,a5,802046e0 <handle_syscall+0x420>
    80204344:	02a00713          	li	a4,42
    80204348:	02f76863          	bltu	a4,a5,80204378 <handle_syscall+0xb8>
    8020434c:	38078a63          	beqz	a5,802046e0 <handle_syscall+0x420>
    80204350:	02a00713          	li	a4,42
    80204354:	38f76663          	bltu	a4,a5,802046e0 <handle_syscall+0x420>
    80204358:	00279713          	slli	a4,a5,0x2
    8020435c:	00018797          	auipc	a5,0x18
    80204360:	94c78793          	addi	a5,a5,-1716 # 8021bca8 <user_test_table+0x4e0>
    80204364:	97ba                	add	a5,a5,a4
    80204366:	439c                	lw	a5,0(a5)
    80204368:	0007871b          	sext.w	a4,a5
    8020436c:	00018797          	auipc	a5,0x18
    80204370:	93c78793          	addi	a5,a5,-1732 # 8021bca8 <user_test_table+0x4e0>
    80204374:	97ba                	add	a5,a5,a4
    80204376:	8782                	jr	a5
    80204378:	05d00713          	li	a4,93
    8020437c:	06e78b63          	beq	a5,a4,802043f2 <handle_syscall+0x132>
    80204380:	a685                	j	802046e0 <handle_syscall+0x420>
			printf("[syscall] print int: %ld\n", tf->a0);
    80204382:	f3843783          	ld	a5,-200(s0)
    80204386:	77dc                	ld	a5,168(a5)
    80204388:	85be                	mv	a1,a5
    8020438a:	00017517          	auipc	a0,0x17
    8020438e:	7ae50513          	addi	a0,a0,1966 # 8021bb38 <user_test_table+0x370>
    80204392:	ffffd097          	auipc	ra,0xffffd
    80204396:	99c080e7          	jalr	-1636(ra) # 80200d2e <printf>
			break;
    8020439a:	a6a5                	j	80204702 <handle_syscall+0x442>
			if (copyinstr(buf, myproc()->pagetable, tf->a0, sizeof(buf)) < 0) {
    8020439c:	00001097          	auipc	ra,0x1
    802043a0:	c14080e7          	jalr	-1004(ra) # 80204fb0 <myproc>
    802043a4:	87aa                	mv	a5,a0
    802043a6:	7fd8                	ld	a4,184(a5)
    802043a8:	f3843783          	ld	a5,-200(s0)
    802043ac:	77d0                	ld	a2,168(a5)
    802043ae:	f4040793          	addi	a5,s0,-192
    802043b2:	08000693          	li	a3,128
    802043b6:	85ba                	mv	a1,a4
    802043b8:	853e                	mv	a0,a5
    802043ba:	00000097          	auipc	ra,0x0
    802043be:	d36080e7          	jalr	-714(ra) # 802040f0 <copyinstr>
    802043c2:	87aa                	mv	a5,a0
    802043c4:	0007db63          	bgez	a5,802043da <handle_syscall+0x11a>
				printf("[syscall] invalid string\n");
    802043c8:	00017517          	auipc	a0,0x17
    802043cc:	79050513          	addi	a0,a0,1936 # 8021bb58 <user_test_table+0x390>
    802043d0:	ffffd097          	auipc	ra,0xffffd
    802043d4:	95e080e7          	jalr	-1698(ra) # 80200d2e <printf>
				break;
    802043d8:	a62d                	j	80204702 <handle_syscall+0x442>
			printf("[syscall] print str: %s\n", buf);
    802043da:	f4040793          	addi	a5,s0,-192
    802043de:	85be                	mv	a1,a5
    802043e0:	00017517          	auipc	a0,0x17
    802043e4:	79850513          	addi	a0,a0,1944 # 8021bb78 <user_test_table+0x3b0>
    802043e8:	ffffd097          	auipc	ra,0xffffd
    802043ec:	946080e7          	jalr	-1722(ra) # 80200d2e <printf>
			break;
    802043f0:	ae09                	j	80204702 <handle_syscall+0x442>
			printf("[syscall] exit(%ld)\n", tf->a0);
    802043f2:	f3843783          	ld	a5,-200(s0)
    802043f6:	77dc                	ld	a5,168(a5)
    802043f8:	85be                	mv	a1,a5
    802043fa:	00017517          	auipc	a0,0x17
    802043fe:	79e50513          	addi	a0,a0,1950 # 8021bb98 <user_test_table+0x3d0>
    80204402:	ffffd097          	auipc	ra,0xffffd
    80204406:	92c080e7          	jalr	-1748(ra) # 80200d2e <printf>
			exit_proc((int)tf->a0);
    8020440a:	f3843783          	ld	a5,-200(s0)
    8020440e:	77dc                	ld	a5,168(a5)
    80204410:	2781                	sext.w	a5,a5
    80204412:	853e                	mv	a0,a5
    80204414:	00002097          	auipc	ra,0x2
    80204418:	98e080e7          	jalr	-1650(ra) # 80205da2 <exit_proc>
			break;
    8020441c:	a4dd                	j	80204702 <handle_syscall+0x442>
			if (myproc()->pid == tf->a0){
    8020441e:	00001097          	auipc	ra,0x1
    80204422:	b92080e7          	jalr	-1134(ra) # 80204fb0 <myproc>
    80204426:	87aa                	mv	a5,a0
    80204428:	43dc                	lw	a5,4(a5)
    8020442a:	873e                	mv	a4,a5
    8020442c:	f3843783          	ld	a5,-200(s0)
    80204430:	77dc                	ld	a5,168(a5)
    80204432:	00f71a63          	bne	a4,a5,80204446 <handle_syscall+0x186>
				warning("[syscall] will kill itself!!!\n");
    80204436:	00017517          	auipc	a0,0x17
    8020443a:	77a50513          	addi	a0,a0,1914 # 8021bbb0 <user_test_table+0x3e8>
    8020443e:	ffffd097          	auipc	ra,0xffffd
    80204442:	370080e7          	jalr	880(ra) # 802017ae <warning>
			kill_proc(tf->a0);
    80204446:	f3843783          	ld	a5,-200(s0)
    8020444a:	77dc                	ld	a5,168(a5)
    8020444c:	2781                	sext.w	a5,a5
    8020444e:	853e                	mv	a0,a5
    80204450:	00002097          	auipc	ra,0x2
    80204454:	8ee080e7          	jalr	-1810(ra) # 80205d3e <kill_proc>
			break;
    80204458:	a46d                	j	80204702 <handle_syscall+0x442>
			int child_pid = fork_proc();
    8020445a:	00001097          	auipc	ra,0x1
    8020445e:	4c2080e7          	jalr	1218(ra) # 8020591c <fork_proc>
    80204462:	87aa                	mv	a5,a0
    80204464:	fcf42e23          	sw	a5,-36(s0)
			tf->a0 = child_pid;
    80204468:	fdc42703          	lw	a4,-36(s0)
    8020446c:	f3843783          	ld	a5,-200(s0)
    80204470:	f7d8                	sd	a4,168(a5)
			printf("[syscall] fork -> %d\n", child_pid);
    80204472:	fdc42783          	lw	a5,-36(s0)
    80204476:	85be                	mv	a1,a5
    80204478:	00017517          	auipc	a0,0x17
    8020447c:	75850513          	addi	a0,a0,1880 # 8021bbd0 <user_test_table+0x408>
    80204480:	ffffd097          	auipc	ra,0xffffd
    80204484:	8ae080e7          	jalr	-1874(ra) # 80200d2e <printf>
			break;
    80204488:	acad                	j	80204702 <handle_syscall+0x442>
				uint64 uaddr = tf->a0;
    8020448a:	f3843783          	ld	a5,-200(s0)
    8020448e:	77dc                	ld	a5,168(a5)
    80204490:	fef43023          	sd	a5,-32(s0)
				int kstatus = 0;
    80204494:	fc042023          	sw	zero,-64(s0)
				int pid = wait_proc(uaddr ? &kstatus : NULL);  // 在内核里等待并得到退出码
    80204498:	fe043783          	ld	a5,-32(s0)
    8020449c:	c781                	beqz	a5,802044a4 <handle_syscall+0x1e4>
    8020449e:	fc040793          	addi	a5,s0,-64
    802044a2:	a011                	j	802044a6 <handle_syscall+0x1e6>
    802044a4:	4781                	li	a5,0
    802044a6:	853e                	mv	a0,a5
    802044a8:	00002097          	auipc	ra,0x2
    802044ac:	9c4080e7          	jalr	-1596(ra) # 80205e6c <wait_proc>
    802044b0:	87aa                	mv	a5,a0
    802044b2:	fef42623          	sw	a5,-20(s0)
				if (pid >= 0 && uaddr) {
    802044b6:	fec42783          	lw	a5,-20(s0)
    802044ba:	2781                	sext.w	a5,a5
    802044bc:	0207cc63          	bltz	a5,802044f4 <handle_syscall+0x234>
    802044c0:	fe043783          	ld	a5,-32(s0)
    802044c4:	cb85                	beqz	a5,802044f4 <handle_syscall+0x234>
					if (copyout(myproc()->pagetable, uaddr, (char *)&kstatus, sizeof(kstatus)) < 0) {
    802044c6:	00001097          	auipc	ra,0x1
    802044ca:	aea080e7          	jalr	-1302(ra) # 80204fb0 <myproc>
    802044ce:	87aa                	mv	a5,a0
    802044d0:	7fdc                	ld	a5,184(a5)
    802044d2:	fc040713          	addi	a4,s0,-64
    802044d6:	4691                	li	a3,4
    802044d8:	863a                	mv	a2,a4
    802044da:	fe043583          	ld	a1,-32(s0)
    802044de:	853e                	mv	a0,a5
    802044e0:	00000097          	auipc	ra,0x0
    802044e4:	b94080e7          	jalr	-1132(ra) # 80204074 <copyout>
    802044e8:	87aa                	mv	a5,a0
    802044ea:	0007d563          	bgez	a5,802044f4 <handle_syscall+0x234>
						pid = -1; // 用户空间地址不可写，视为失败
    802044ee:	57fd                	li	a5,-1
    802044f0:	fef42623          	sw	a5,-20(s0)
				tf->a0 = pid;
    802044f4:	fec42703          	lw	a4,-20(s0)
    802044f8:	f3843783          	ld	a5,-200(s0)
    802044fc:	f7d8                	sd	a4,168(a5)
				break;
    802044fe:	a411                	j	80204702 <handle_syscall+0x442>
			tf->a0 =0;
    80204500:	f3843783          	ld	a5,-200(s0)
    80204504:	0a07b423          	sd	zero,168(a5)
			yield();
    80204508:	00001097          	auipc	ra,0x1
    8020450c:	68c080e7          	jalr	1676(ra) # 80205b94 <yield>
			break;
    80204510:	aacd                	j	80204702 <handle_syscall+0x442>
			tf->a0 = myproc()->pid;
    80204512:	00001097          	auipc	ra,0x1
    80204516:	a9e080e7          	jalr	-1378(ra) # 80204fb0 <myproc>
    8020451a:	87aa                	mv	a5,a0
    8020451c:	43dc                	lw	a5,4(a5)
    8020451e:	873e                	mv	a4,a5
    80204520:	f3843783          	ld	a5,-200(s0)
    80204524:	f7d8                	sd	a4,168(a5)
			break;
    80204526:	aaf1                	j	80204702 <handle_syscall+0x442>
			tf->a0 = myproc()->parent ? myproc()->parent->pid : 0;
    80204528:	00001097          	auipc	ra,0x1
    8020452c:	a88080e7          	jalr	-1400(ra) # 80204fb0 <myproc>
    80204530:	87aa                	mv	a5,a0
    80204532:	6fdc                	ld	a5,152(a5)
    80204534:	cb91                	beqz	a5,80204548 <handle_syscall+0x288>
    80204536:	00001097          	auipc	ra,0x1
    8020453a:	a7a080e7          	jalr	-1414(ra) # 80204fb0 <myproc>
    8020453e:	87aa                	mv	a5,a0
    80204540:	6fdc                	ld	a5,152(a5)
    80204542:	43dc                	lw	a5,4(a5)
    80204544:	873e                	mv	a4,a5
    80204546:	a011                	j	8020454a <handle_syscall+0x28a>
    80204548:	4701                	li	a4,0
    8020454a:	f3843783          	ld	a5,-200(s0)
    8020454e:	f7d8                	sd	a4,168(a5)
			break;
    80204550:	aa4d                	j	80204702 <handle_syscall+0x442>
			tf->a0 = get_time();
    80204552:	00002097          	auipc	ra,0x2
    80204556:	f88080e7          	jalr	-120(ra) # 802064da <get_time>
    8020455a:	872a                	mv	a4,a0
    8020455c:	f3843783          	ld	a5,-200(s0)
    80204560:	f7d8                	sd	a4,168(a5)
			break;
    80204562:	a245                	j	80204702 <handle_syscall+0x442>
			tf->a0 = 0;
    80204564:	f3843783          	ld	a5,-200(s0)
    80204568:	0a07b423          	sd	zero,168(a5)
			printf("[syscall] step enabled but do nothing\n");
    8020456c:	00017517          	auipc	a0,0x17
    80204570:	67c50513          	addi	a0,a0,1660 # 8021bbe8 <user_test_table+0x420>
    80204574:	ffffc097          	auipc	ra,0xffffc
    80204578:	7ba080e7          	jalr	1978(ra) # 80200d2e <printf>
			break;
    8020457c:	a259                	j	80204702 <handle_syscall+0x442>
		int fd = tf->a0;          // 文件描述符
    8020457e:	f3843783          	ld	a5,-200(s0)
    80204582:	77dc                	ld	a5,168(a5)
    80204584:	fcf42c23          	sw	a5,-40(s0)
		if (fd != 1 && fd != 2) {
    80204588:	fd842783          	lw	a5,-40(s0)
    8020458c:	0007871b          	sext.w	a4,a5
    80204590:	4785                	li	a5,1
    80204592:	00f70e63          	beq	a4,a5,802045ae <handle_syscall+0x2ee>
    80204596:	fd842783          	lw	a5,-40(s0)
    8020459a:	0007871b          	sext.w	a4,a5
    8020459e:	4789                	li	a5,2
    802045a0:	00f70763          	beq	a4,a5,802045ae <handle_syscall+0x2ee>
			tf->a0 = -1;
    802045a4:	f3843783          	ld	a5,-200(s0)
    802045a8:	577d                	li	a4,-1
    802045aa:	f7d8                	sd	a4,168(a5)
			break;
    802045ac:	aa99                	j	80204702 <handle_syscall+0x442>
		if (check_user_addr(tf->a1, tf->a2, 0) < 0) {
    802045ae:	f3843783          	ld	a5,-200(s0)
    802045b2:	7bd8                	ld	a4,176(a5)
    802045b4:	f3843783          	ld	a5,-200(s0)
    802045b8:	7fdc                	ld	a5,184(a5)
    802045ba:	4601                	li	a2,0
    802045bc:	85be                	mv	a1,a5
    802045be:	853a                	mv	a0,a4
    802045c0:	00000097          	auipc	ra,0x0
    802045c4:	bca080e7          	jalr	-1078(ra) # 8020418a <check_user_addr>
    802045c8:	87aa                	mv	a5,a0
    802045ca:	0007df63          	bgez	a5,802045e8 <handle_syscall+0x328>
			printf("[syscall] invalid write buffer address\n");
    802045ce:	00017517          	auipc	a0,0x17
    802045d2:	64250513          	addi	a0,a0,1602 # 8021bc10 <user_test_table+0x448>
    802045d6:	ffffc097          	auipc	ra,0xffffc
    802045da:	758080e7          	jalr	1880(ra) # 80200d2e <printf>
			tf->a0 = -1;
    802045de:	f3843783          	ld	a5,-200(s0)
    802045e2:	577d                	li	a4,-1
    802045e4:	f7d8                	sd	a4,168(a5)
			break;
    802045e6:	aa31                	j	80204702 <handle_syscall+0x442>
		if (copyinstr(buf, myproc()->pagetable, tf->a1, sizeof(buf)) < 0) {
    802045e8:	00001097          	auipc	ra,0x1
    802045ec:	9c8080e7          	jalr	-1592(ra) # 80204fb0 <myproc>
    802045f0:	87aa                	mv	a5,a0
    802045f2:	7fd8                	ld	a4,184(a5)
    802045f4:	f3843783          	ld	a5,-200(s0)
    802045f8:	7bd0                	ld	a2,176(a5)
    802045fa:	f4040793          	addi	a5,s0,-192
    802045fe:	08000693          	li	a3,128
    80204602:	85ba                	mv	a1,a4
    80204604:	853e                	mv	a0,a5
    80204606:	00000097          	auipc	ra,0x0
    8020460a:	aea080e7          	jalr	-1302(ra) # 802040f0 <copyinstr>
    8020460e:	87aa                	mv	a5,a0
    80204610:	0007df63          	bgez	a5,8020462e <handle_syscall+0x36e>
			printf("[syscall] invalid write buffer\n");
    80204614:	00017517          	auipc	a0,0x17
    80204618:	62450513          	addi	a0,a0,1572 # 8021bc38 <user_test_table+0x470>
    8020461c:	ffffc097          	auipc	ra,0xffffc
    80204620:	712080e7          	jalr	1810(ra) # 80200d2e <printf>
			tf->a0 = -1;
    80204624:	f3843783          	ld	a5,-200(s0)
    80204628:	577d                	li	a4,-1
    8020462a:	f7d8                	sd	a4,168(a5)
			break;
    8020462c:	a8d9                	j	80204702 <handle_syscall+0x442>
		printf("%s", buf);
    8020462e:	f4040793          	addi	a5,s0,-192
    80204632:	85be                	mv	a1,a5
    80204634:	00017517          	auipc	a0,0x17
    80204638:	62450513          	addi	a0,a0,1572 # 8021bc58 <user_test_table+0x490>
    8020463c:	ffffc097          	auipc	ra,0xffffc
    80204640:	6f2080e7          	jalr	1778(ra) # 80200d2e <printf>
		tf->a0 = strlen(buf);  // 返回写入的字节数
    80204644:	f4040793          	addi	a5,s0,-192
    80204648:	853e                	mv	a0,a5
    8020464a:	00002097          	auipc	ra,0x2
    8020464e:	bec080e7          	jalr	-1044(ra) # 80206236 <strlen>
    80204652:	87aa                	mv	a5,a0
    80204654:	873e                	mv	a4,a5
    80204656:	f3843783          	ld	a5,-200(s0)
    8020465a:	f7d8                	sd	a4,168(a5)
		break;
    8020465c:	a05d                	j	80204702 <handle_syscall+0x442>
		int fd = tf->a0;          // 文件描述符
    8020465e:	f3843783          	ld	a5,-200(s0)
    80204662:	77dc                	ld	a5,168(a5)
    80204664:	fcf42a23          	sw	a5,-44(s0)
		uint64 buf = tf->a1;      // 用户缓冲区地址
    80204668:	f3843783          	ld	a5,-200(s0)
    8020466c:	7bdc                	ld	a5,176(a5)
    8020466e:	fcf43423          	sd	a5,-56(s0)
		int n = tf->a2;           // 要读取的字节数
    80204672:	f3843783          	ld	a5,-200(s0)
    80204676:	7fdc                	ld	a5,184(a5)
    80204678:	fcf42223          	sw	a5,-60(s0)
		if (fd != 0) {
    8020467c:	fd442783          	lw	a5,-44(s0)
    80204680:	2781                	sext.w	a5,a5
    80204682:	c791                	beqz	a5,8020468e <handle_syscall+0x3ce>
			tf->a0 = -1;
    80204684:	f3843783          	ld	a5,-200(s0)
    80204688:	577d                	li	a4,-1
    8020468a:	f7d8                	sd	a4,168(a5)
			break;
    8020468c:	a89d                	j	80204702 <handle_syscall+0x442>
		if (check_user_addr(buf, n, 1) < 0) {  // 1表示写入访问
    8020468e:	fc442783          	lw	a5,-60(s0)
    80204692:	4605                	li	a2,1
    80204694:	85be                	mv	a1,a5
    80204696:	fc843503          	ld	a0,-56(s0)
    8020469a:	00000097          	auipc	ra,0x0
    8020469e:	af0080e7          	jalr	-1296(ra) # 8020418a <check_user_addr>
    802046a2:	87aa                	mv	a5,a0
    802046a4:	0007df63          	bgez	a5,802046c2 <handle_syscall+0x402>
			printf("[syscall] invalid read buffer address\n");
    802046a8:	00017517          	auipc	a0,0x17
    802046ac:	5b850513          	addi	a0,a0,1464 # 8021bc60 <user_test_table+0x498>
    802046b0:	ffffc097          	auipc	ra,0xffffc
    802046b4:	67e080e7          	jalr	1662(ra) # 80200d2e <printf>
			tf->a0 = -1;
    802046b8:	f3843783          	ld	a5,-200(s0)
    802046bc:	577d                	li	a4,-1
    802046be:	f7d8                	sd	a4,168(a5)
			break;
    802046c0:	a089                	j	80204702 <handle_syscall+0x442>
		tf->a0 = -1;
    802046c2:	f3843783          	ld	a5,-200(s0)
    802046c6:	577d                	li	a4,-1
    802046c8:	f7d8                	sd	a4,168(a5)
		break;
    802046ca:	a825                	j	80204702 <handle_syscall+0x442>
        case SYS_open:
        case SYS_close: 
            // 暂时不支持真实的文件操作
            tf->a0 = -1;
    802046cc:	f3843783          	ld	a5,-200(s0)
    802046d0:	577d                	li	a4,-1
    802046d2:	f7d8                	sd	a4,168(a5)
            break;
    802046d4:	a03d                	j	80204702 <handle_syscall+0x442>
		case SYS_sbrk:
			tf->a0 = -1;
    802046d6:	f3843783          	ld	a5,-200(s0)
    802046da:	577d                	li	a4,-1
    802046dc:	f7d8                	sd	a4,168(a5)
			break;
    802046de:	a015                	j	80204702 <handle_syscall+0x442>
		default:
			printf("[syscall] unknown syscall: %ld\n", tf->a7);
    802046e0:	f3843783          	ld	a5,-200(s0)
    802046e4:	73fc                	ld	a5,224(a5)
    802046e6:	85be                	mv	a1,a5
    802046e8:	00017517          	auipc	a0,0x17
    802046ec:	5a050513          	addi	a0,a0,1440 # 8021bc88 <user_test_table+0x4c0>
    802046f0:	ffffc097          	auipc	ra,0xffffc
    802046f4:	63e080e7          	jalr	1598(ra) # 80200d2e <printf>
			tf->a0 = -1;
    802046f8:	f3843783          	ld	a5,-200(s0)
    802046fc:	577d                	li	a4,-1
    802046fe:	f7d8                	sd	a4,168(a5)
			break;
    80204700:	0001                	nop
	}
	set_sepc(tf, info->sepc + 4);
    80204702:	f3043783          	ld	a5,-208(s0)
    80204706:	639c                	ld	a5,0(a5)
    80204708:	0791                	addi	a5,a5,4
    8020470a:	85be                	mv	a1,a5
    8020470c:	f3843503          	ld	a0,-200(s0)
    80204710:	fffff097          	auipc	ra,0xfffff
    80204714:	008080e7          	jalr	8(ra) # 80203718 <set_sepc>
}
    80204718:	0001                	nop
    8020471a:	60ae                	ld	ra,200(sp)
    8020471c:	640e                	ld	s0,192(sp)
    8020471e:	6169                	addi	sp,sp,208
    80204720:	8082                	ret

0000000080204722 <handle_instruction_page_fault>:



// 处理指令页故障
void handle_instruction_page_fault(struct trapframe *tf, struct trap_info *info) {
    80204722:	1101                	addi	sp,sp,-32
    80204724:	ec06                	sd	ra,24(sp)
    80204726:	e822                	sd	s0,16(sp)
    80204728:	1000                	addi	s0,sp,32
    8020472a:	fea43423          	sd	a0,-24(s0)
    8020472e:	feb43023          	sd	a1,-32(s0)
    printf("Instruction page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80204732:	fe043783          	ld	a5,-32(s0)
    80204736:	6f98                	ld	a4,24(a5)
    80204738:	fe043783          	ld	a5,-32(s0)
    8020473c:	639c                	ld	a5,0(a5)
    8020473e:	863e                	mv	a2,a5
    80204740:	85ba                	mv	a1,a4
    80204742:	00017517          	auipc	a0,0x17
    80204746:	61650513          	addi	a0,a0,1558 # 8021bd58 <user_test_table+0x590>
    8020474a:	ffffc097          	auipc	ra,0xffffc
    8020474e:	5e4080e7          	jalr	1508(ra) # 80200d2e <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 1)) {  // 1表示指令页
    80204752:	fe043783          	ld	a5,-32(s0)
    80204756:	6f9c                	ld	a5,24(a5)
    80204758:	4585                	li	a1,1
    8020475a:	853e                	mv	a0,a5
    8020475c:	ffffe097          	auipc	ra,0xffffe
    80204760:	2c0080e7          	jalr	704(ra) # 80202a1c <handle_page_fault>
    80204764:	87aa                	mv	a5,a0
    80204766:	eb91                	bnez	a5,8020477a <handle_instruction_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled instruction page fault");
    80204768:	00017517          	auipc	a0,0x17
    8020476c:	62050513          	addi	a0,a0,1568 # 8021bd88 <user_test_table+0x5c0>
    80204770:	ffffd097          	auipc	ra,0xffffd
    80204774:	00a080e7          	jalr	10(ra) # 8020177a <panic>
    80204778:	a011                	j	8020477c <handle_instruction_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    8020477a:	0001                	nop
}
    8020477c:	60e2                	ld	ra,24(sp)
    8020477e:	6442                	ld	s0,16(sp)
    80204780:	6105                	addi	sp,sp,32
    80204782:	8082                	ret

0000000080204784 <handle_load_page_fault>:

// 处理加载页故障
void handle_load_page_fault(struct trapframe *tf, struct trap_info *info) {
    80204784:	1101                	addi	sp,sp,-32
    80204786:	ec06                	sd	ra,24(sp)
    80204788:	e822                	sd	s0,16(sp)
    8020478a:	1000                	addi	s0,sp,32
    8020478c:	fea43423          	sd	a0,-24(s0)
    80204790:	feb43023          	sd	a1,-32(s0)
    printf("Load page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    80204794:	fe043783          	ld	a5,-32(s0)
    80204798:	6f98                	ld	a4,24(a5)
    8020479a:	fe043783          	ld	a5,-32(s0)
    8020479e:	639c                	ld	a5,0(a5)
    802047a0:	863e                	mv	a2,a5
    802047a2:	85ba                	mv	a1,a4
    802047a4:	00017517          	auipc	a0,0x17
    802047a8:	60c50513          	addi	a0,a0,1548 # 8021bdb0 <user_test_table+0x5e8>
    802047ac:	ffffc097          	auipc	ra,0xffffc
    802047b0:	582080e7          	jalr	1410(ra) # 80200d2e <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 2)) {  // 2表示读数据页
    802047b4:	fe043783          	ld	a5,-32(s0)
    802047b8:	6f9c                	ld	a5,24(a5)
    802047ba:	4589                	li	a1,2
    802047bc:	853e                	mv	a0,a5
    802047be:	ffffe097          	auipc	ra,0xffffe
    802047c2:	25e080e7          	jalr	606(ra) # 80202a1c <handle_page_fault>
    802047c6:	87aa                	mv	a5,a0
    802047c8:	eb91                	bnez	a5,802047dc <handle_load_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled load page fault");
    802047ca:	00017517          	auipc	a0,0x17
    802047ce:	61650513          	addi	a0,a0,1558 # 8021bde0 <user_test_table+0x618>
    802047d2:	ffffd097          	auipc	ra,0xffffd
    802047d6:	fa8080e7          	jalr	-88(ra) # 8020177a <panic>
    802047da:	a011                	j	802047de <handle_load_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    802047dc:	0001                	nop
}
    802047de:	60e2                	ld	ra,24(sp)
    802047e0:	6442                	ld	s0,16(sp)
    802047e2:	6105                	addi	sp,sp,32
    802047e4:	8082                	ret

00000000802047e6 <handle_store_page_fault>:

// 处理存储页故障
void handle_store_page_fault(struct trapframe *tf, struct trap_info *info) {
    802047e6:	1101                	addi	sp,sp,-32
    802047e8:	ec06                	sd	ra,24(sp)
    802047ea:	e822                	sd	s0,16(sp)
    802047ec:	1000                	addi	s0,sp,32
    802047ee:	fea43423          	sd	a0,-24(s0)
    802047f2:	feb43023          	sd	a1,-32(s0)
    printf("Store page fault at va=0x%lx, sepc=0x%lx\n", info->stval, info->sepc);
    802047f6:	fe043783          	ld	a5,-32(s0)
    802047fa:	6f98                	ld	a4,24(a5)
    802047fc:	fe043783          	ld	a5,-32(s0)
    80204800:	639c                	ld	a5,0(a5)
    80204802:	863e                	mv	a2,a5
    80204804:	85ba                	mv	a1,a4
    80204806:	00017517          	auipc	a0,0x17
    8020480a:	5fa50513          	addi	a0,a0,1530 # 8021be00 <user_test_table+0x638>
    8020480e:	ffffc097          	auipc	ra,0xffffc
    80204812:	520080e7          	jalr	1312(ra) # 80200d2e <printf>
    
    // 尝试处理页面故障
    if (handle_page_fault(info->stval, 3)) {  // 3表示写数据页
    80204816:	fe043783          	ld	a5,-32(s0)
    8020481a:	6f9c                	ld	a5,24(a5)
    8020481c:	458d                	li	a1,3
    8020481e:	853e                	mv	a0,a5
    80204820:	ffffe097          	auipc	ra,0xffffe
    80204824:	1fc080e7          	jalr	508(ra) # 80202a1c <handle_page_fault>
    80204828:	87aa                	mv	a5,a0
    8020482a:	eb91                	bnez	a5,8020483e <handle_store_page_fault+0x58>
        return; // 成功处理页面故障，可以继续执行
    }
    
    // 无法处理的页面故障
    panic("Unhandled store page fault");
    8020482c:	00017517          	auipc	a0,0x17
    80204830:	60450513          	addi	a0,a0,1540 # 8021be30 <user_test_table+0x668>
    80204834:	ffffd097          	auipc	ra,0xffffd
    80204838:	f46080e7          	jalr	-186(ra) # 8020177a <panic>
    8020483c:	a011                	j	80204840 <handle_store_page_fault+0x5a>
        return; // 成功处理页面故障，可以继续执行
    8020483e:	0001                	nop
}
    80204840:	60e2                	ld	ra,24(sp)
    80204842:	6442                	ld	s0,16(sp)
    80204844:	6105                	addi	sp,sp,32
    80204846:	8082                	ret

0000000080204848 <usertrap>:

void usertrap(void) {
    80204848:	7159                	addi	sp,sp,-112
    8020484a:	f486                	sd	ra,104(sp)
    8020484c:	f0a2                	sd	s0,96(sp)
    8020484e:	1880                	addi	s0,sp,112
    struct proc *p = myproc();
    80204850:	00000097          	auipc	ra,0x0
    80204854:	760080e7          	jalr	1888(ra) # 80204fb0 <myproc>
    80204858:	fea43423          	sd	a0,-24(s0)
    struct trapframe *tf = p->trapframe;
    8020485c:	fe843783          	ld	a5,-24(s0)
    80204860:	63fc                	ld	a5,192(a5)
    80204862:	fef43023          	sd	a5,-32(s0)

    uint64 scause = r_scause();
    80204866:	fffff097          	auipc	ra,0xfffff
    8020486a:	e20080e7          	jalr	-480(ra) # 80203686 <r_scause>
    8020486e:	fca43c23          	sd	a0,-40(s0)
    uint64 stval  = r_stval();
    80204872:	fffff097          	auipc	ra,0xfffff
    80204876:	e48080e7          	jalr	-440(ra) # 802036ba <r_stval>
    8020487a:	fca43823          	sd	a0,-48(s0)
    uint64 sepc   = tf->epc;      // 已由 trampoline 保存
    8020487e:	fe043783          	ld	a5,-32(s0)
    80204882:	7f9c                	ld	a5,56(a5)
    80204884:	fcf43423          	sd	a5,-56(s0)
    uint64 sstatus= tf->sstatus;  // 已由 trampoline 保存
    80204888:	fe043783          	ld	a5,-32(s0)
    8020488c:	7b9c                	ld	a5,48(a5)
    8020488e:	fcf43023          	sd	a5,-64(s0)

    uint64 code = scause & 0xff;
    80204892:	fd843783          	ld	a5,-40(s0)
    80204896:	0ff7f793          	zext.b	a5,a5
    8020489a:	faf43c23          	sd	a5,-72(s0)
    uint64 is_intr = (scause >> 63);
    8020489e:	fd843783          	ld	a5,-40(s0)
    802048a2:	93fd                	srli	a5,a5,0x3f
    802048a4:	faf43823          	sd	a5,-80(s0)

    if (!is_intr && code == 8) { // 用户态 ecall
    802048a8:	fb043783          	ld	a5,-80(s0)
    802048ac:	e3a1                	bnez	a5,802048ec <usertrap+0xa4>
    802048ae:	fb843703          	ld	a4,-72(s0)
    802048b2:	47a1                	li	a5,8
    802048b4:	02f71c63          	bne	a4,a5,802048ec <usertrap+0xa4>
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    802048b8:	fc843783          	ld	a5,-56(s0)
    802048bc:	f8f43823          	sd	a5,-112(s0)
    802048c0:	fc043783          	ld	a5,-64(s0)
    802048c4:	f8f43c23          	sd	a5,-104(s0)
    802048c8:	fd843783          	ld	a5,-40(s0)
    802048cc:	faf43023          	sd	a5,-96(s0)
    802048d0:	fd043783          	ld	a5,-48(s0)
    802048d4:	faf43423          	sd	a5,-88(s0)
        handle_syscall(tf, &info);
    802048d8:	f9040793          	addi	a5,s0,-112
    802048dc:	85be                	mv	a1,a5
    802048de:	fe043503          	ld	a0,-32(s0)
    802048e2:	00000097          	auipc	ra,0x0
    802048e6:	9de080e7          	jalr	-1570(ra) # 802042c0 <handle_syscall>
    if (!is_intr && code == 8) { // 用户态 ecall
    802048ea:	a869                	j	80204984 <usertrap+0x13c>
        // handle_syscall 应该已 set_sepc(tf, sepc+4)
    } else if (is_intr) {
    802048ec:	fb043783          	ld	a5,-80(s0)
    802048f0:	c3ad                	beqz	a5,80204952 <usertrap+0x10a>
        if (code == 5) {
    802048f2:	fb843703          	ld	a4,-72(s0)
    802048f6:	4795                	li	a5,5
    802048f8:	02f71663          	bne	a4,a5,80204924 <usertrap+0xdc>
            timeintr();
    802048fc:	fffff097          	auipc	ra,0xfffff
    80204900:	c7e080e7          	jalr	-898(ra) # 8020357a <timeintr>
            sbi_set_time(sbi_get_time() + TIMER_INTERVAL);
    80204904:	fffff097          	auipc	ra,0xfffff
    80204908:	c5c080e7          	jalr	-932(ra) # 80203560 <sbi_get_time>
    8020490c:	872a                	mv	a4,a0
    8020490e:	000f47b7          	lui	a5,0xf4
    80204912:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    80204916:	97ba                	add	a5,a5,a4
    80204918:	853e                	mv	a0,a5
    8020491a:	fffff097          	auipc	ra,0xfffff
    8020491e:	c2a080e7          	jalr	-982(ra) # 80203544 <sbi_set_time>
    80204922:	a08d                	j	80204984 <usertrap+0x13c>
        } else if (code == 9) {
    80204924:	fb843703          	ld	a4,-72(s0)
    80204928:	47a5                	li	a5,9
    8020492a:	00f71763          	bne	a4,a5,80204938 <usertrap+0xf0>
            handle_external_interrupt();
    8020492e:	fffff097          	auipc	ra,0xfffff
    80204932:	f3a080e7          	jalr	-198(ra) # 80203868 <handle_external_interrupt>
    80204936:	a0b9                	j	80204984 <usertrap+0x13c>
        } else {
            printf("[usertrap] unknown interrupt scause=%lx sepc=%lx\n", scause, sepc);
    80204938:	fc843603          	ld	a2,-56(s0)
    8020493c:	fd843583          	ld	a1,-40(s0)
    80204940:	00017517          	auipc	a0,0x17
    80204944:	51050513          	addi	a0,a0,1296 # 8021be50 <user_test_table+0x688>
    80204948:	ffffc097          	auipc	ra,0xffffc
    8020494c:	3e6080e7          	jalr	998(ra) # 80200d2e <printf>
    80204950:	a815                	j	80204984 <usertrap+0x13c>
        }
    } else {
        struct trap_info info = { .sepc = sepc, .sstatus = sstatus, .scause = scause, .stval = stval };
    80204952:	fc843783          	ld	a5,-56(s0)
    80204956:	f8f43823          	sd	a5,-112(s0)
    8020495a:	fc043783          	ld	a5,-64(s0)
    8020495e:	f8f43c23          	sd	a5,-104(s0)
    80204962:	fd843783          	ld	a5,-40(s0)
    80204966:	faf43023          	sd	a5,-96(s0)
    8020496a:	fd043783          	ld	a5,-48(s0)
    8020496e:	faf43423          	sd	a5,-88(s0)
        handle_exception(tf, &info);
    80204972:	f9040793          	addi	a5,s0,-112
    80204976:	85be                	mv	a1,a5
    80204978:	fe043503          	ld	a0,-32(s0)
    8020497c:	fffff097          	auipc	ra,0xfffff
    80204980:	18e080e7          	jalr	398(ra) # 80203b0a <handle_exception>
    }

    usertrapret();
    80204984:	00000097          	auipc	ra,0x0
    80204988:	012080e7          	jalr	18(ra) # 80204996 <usertrapret>
}
    8020498c:	0001                	nop
    8020498e:	70a6                	ld	ra,104(sp)
    80204990:	7406                	ld	s0,96(sp)
    80204992:	6165                	addi	sp,sp,112
    80204994:	8082                	ret

0000000080204996 <usertrapret>:

void usertrapret(void) {
    80204996:	7179                	addi	sp,sp,-48
    80204998:	f406                	sd	ra,40(sp)
    8020499a:	f022                	sd	s0,32(sp)
    8020499c:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    8020499e:	00000097          	auipc	ra,0x0
    802049a2:	612080e7          	jalr	1554(ra) # 80204fb0 <myproc>
    802049a6:	fea43423          	sd	a0,-24(s0)
    // 计算 trampoline 中 uservec 的虚拟地址（对双方页表一致）
    uint64 uservec_va = (uint64)TRAMPOLINE + ((uint64)uservec - (uint64)trampoline);
    802049aa:	00000717          	auipc	a4,0x0
    802049ae:	34670713          	addi	a4,a4,838 # 80204cf0 <trampoline>
    802049b2:	77fd                	lui	a5,0xfffff
    802049b4:	973e                	add	a4,a4,a5
    802049b6:	00000797          	auipc	a5,0x0
    802049ba:	33a78793          	addi	a5,a5,826 # 80204cf0 <trampoline>
    802049be:	40f707b3          	sub	a5,a4,a5
    802049c2:	fef43023          	sd	a5,-32(s0)
    w_stvec(uservec_va);
    802049c6:	fe043503          	ld	a0,-32(s0)
    802049ca:	fffff097          	auipc	ra,0xfffff
    802049ce:	ca2080e7          	jalr	-862(ra) # 8020366c <w_stvec>

    // sscratch 设为 TRAPFRAME 的虚拟地址（trampoline 代码用它访问 tf）
    w_sscratch((uint64)TRAPFRAME);
    802049d2:	7579                	lui	a0,0xffffe
    802049d4:	fffff097          	auipc	ra,0xfffff
    802049d8:	c3c080e7          	jalr	-964(ra) # 80203610 <w_sscratch>

    // 准备用户页表的 satp
    uint64 user_satp = MAKE_SATP(p->pagetable);
    802049dc:	fe843783          	ld	a5,-24(s0)
    802049e0:	7fdc                	ld	a5,184(a5)
    802049e2:	00c7d713          	srli	a4,a5,0xc
    802049e6:	57fd                	li	a5,-1
    802049e8:	17fe                	slli	a5,a5,0x3f
    802049ea:	8fd9                	or	a5,a5,a4
    802049ec:	fcf43c23          	sd	a5,-40(s0)

    // 计算 trampoline 中 userret 的虚拟地址
    uint64 userret_va = (uint64)TRAMPOLINE + ((uint64)userret - (uint64)trampoline);
    802049f0:	00000717          	auipc	a4,0x0
    802049f4:	3a670713          	addi	a4,a4,934 # 80204d96 <userret>
    802049f8:	77fd                	lui	a5,0xfffff
    802049fa:	973e                	add	a4,a4,a5
    802049fc:	00000797          	auipc	a5,0x0
    80204a00:	2f478793          	addi	a5,a5,756 # 80204cf0 <trampoline>
    80204a04:	40f707b3          	sub	a5,a4,a5
    80204a08:	fcf43823          	sd	a5,-48(s0)

    // a0 = TRAPFRAME（虚拟地址，双方页表都映射）
    // a1 = user_satp
    register uint64 a0 asm("a0") = (uint64)TRAPFRAME;
    80204a0c:	7579                	lui	a0,0xffffe
    register uint64 a1 asm("a1") = user_satp;
    80204a0e:	fd843583          	ld	a1,-40(s0)
    register void (*tgt)(uint64, uint64) asm("t0") = (void *)userret_va;
    80204a12:	fd043783          	ld	a5,-48(s0)
    80204a16:	82be                	mv	t0,a5

    // 跳到 trampoline 上的 userret
    asm volatile("jr t0" :: "r"(a0), "r"(a1), "r"(tgt) : "memory");
    80204a18:	8282                	jr	t0
}
    80204a1a:	0001                	nop
    80204a1c:	70a2                	ld	ra,40(sp)
    80204a1e:	7402                	ld	s0,32(sp)
    80204a20:	6145                	addi	sp,sp,48
    80204a22:	8082                	ret

0000000080204a24 <write32>:
    80204a24:	7179                	addi	sp,sp,-48
    80204a26:	f406                	sd	ra,40(sp)
    80204a28:	f022                	sd	s0,32(sp)
    80204a2a:	1800                	addi	s0,sp,48
    80204a2c:	fca43c23          	sd	a0,-40(s0)
    80204a30:	87ae                	mv	a5,a1
    80204a32:	fcf42a23          	sw	a5,-44(s0)
    80204a36:	fd843783          	ld	a5,-40(s0)
    80204a3a:	8b8d                	andi	a5,a5,3
    80204a3c:	eb99                	bnez	a5,80204a52 <write32+0x2e>
    80204a3e:	fd843783          	ld	a5,-40(s0)
    80204a42:	fef43423          	sd	a5,-24(s0)
    80204a46:	fe843783          	ld	a5,-24(s0)
    80204a4a:	fd442703          	lw	a4,-44(s0)
    80204a4e:	c398                	sw	a4,0(a5)
    80204a50:	a819                	j	80204a66 <write32+0x42>
    80204a52:	fd843583          	ld	a1,-40(s0)
    80204a56:	00019517          	auipc	a0,0x19
    80204a5a:	44250513          	addi	a0,a0,1090 # 8021de98 <user_test_table+0x60>
    80204a5e:	ffffc097          	auipc	ra,0xffffc
    80204a62:	2d0080e7          	jalr	720(ra) # 80200d2e <printf>
    80204a66:	0001                	nop
    80204a68:	70a2                	ld	ra,40(sp)
    80204a6a:	7402                	ld	s0,32(sp)
    80204a6c:	6145                	addi	sp,sp,48
    80204a6e:	8082                	ret

0000000080204a70 <read32>:
    80204a70:	7179                	addi	sp,sp,-48
    80204a72:	f406                	sd	ra,40(sp)
    80204a74:	f022                	sd	s0,32(sp)
    80204a76:	1800                	addi	s0,sp,48
    80204a78:	fca43c23          	sd	a0,-40(s0)
    80204a7c:	fd843783          	ld	a5,-40(s0)
    80204a80:	8b8d                	andi	a5,a5,3
    80204a82:	eb91                	bnez	a5,80204a96 <read32+0x26>
    80204a84:	fd843783          	ld	a5,-40(s0)
    80204a88:	fef43423          	sd	a5,-24(s0)
    80204a8c:	fe843783          	ld	a5,-24(s0)
    80204a90:	439c                	lw	a5,0(a5)
    80204a92:	2781                	sext.w	a5,a5
    80204a94:	a821                	j	80204aac <read32+0x3c>
    80204a96:	fd843583          	ld	a1,-40(s0)
    80204a9a:	00019517          	auipc	a0,0x19
    80204a9e:	42e50513          	addi	a0,a0,1070 # 8021dec8 <user_test_table+0x90>
    80204aa2:	ffffc097          	auipc	ra,0xffffc
    80204aa6:	28c080e7          	jalr	652(ra) # 80200d2e <printf>
    80204aaa:	4781                	li	a5,0
    80204aac:	853e                	mv	a0,a5
    80204aae:	70a2                	ld	ra,40(sp)
    80204ab0:	7402                	ld	s0,32(sp)
    80204ab2:	6145                	addi	sp,sp,48
    80204ab4:	8082                	ret

0000000080204ab6 <plic_init>:
void plic_init(void) {
    80204ab6:	1101                	addi	sp,sp,-32
    80204ab8:	ec06                	sd	ra,24(sp)
    80204aba:	e822                	sd	s0,16(sp)
    80204abc:	1000                	addi	s0,sp,32
    for (int i = 1; i <= 32; i++) {
    80204abe:	4785                	li	a5,1
    80204ac0:	fef42623          	sw	a5,-20(s0)
    80204ac4:	a805                	j	80204af4 <plic_init+0x3e>
        uint64 addr = PLIC + i * 4;
    80204ac6:	fec42783          	lw	a5,-20(s0)
    80204aca:	0027979b          	slliw	a5,a5,0x2
    80204ace:	2781                	sext.w	a5,a5
    80204ad0:	873e                	mv	a4,a5
    80204ad2:	0c0007b7          	lui	a5,0xc000
    80204ad6:	97ba                	add	a5,a5,a4
    80204ad8:	fef43023          	sd	a5,-32(s0)
        write32(addr, 0);
    80204adc:	4581                	li	a1,0
    80204ade:	fe043503          	ld	a0,-32(s0)
    80204ae2:	00000097          	auipc	ra,0x0
    80204ae6:	f42080e7          	jalr	-190(ra) # 80204a24 <write32>
    for (int i = 1; i <= 32; i++) {
    80204aea:	fec42783          	lw	a5,-20(s0)
    80204aee:	2785                	addiw	a5,a5,1 # c000001 <_entry-0x741fffff>
    80204af0:	fef42623          	sw	a5,-20(s0)
    80204af4:	fec42783          	lw	a5,-20(s0)
    80204af8:	0007871b          	sext.w	a4,a5
    80204afc:	02000793          	li	a5,32
    80204b00:	fce7d3e3          	bge	a5,a4,80204ac6 <plic_init+0x10>
    write32(PLIC + UART0_IRQ * 4, 1);
    80204b04:	4585                	li	a1,1
    80204b06:	0c0007b7          	lui	a5,0xc000
    80204b0a:	02878513          	addi	a0,a5,40 # c000028 <_entry-0x741fffd8>
    80204b0e:	00000097          	auipc	ra,0x0
    80204b12:	f16080e7          	jalr	-234(ra) # 80204a24 <write32>
    write32(PLIC + VIRTIO0_IRQ * 4, 1);
    80204b16:	4585                	li	a1,1
    80204b18:	0c0007b7          	lui	a5,0xc000
    80204b1c:	00478513          	addi	a0,a5,4 # c000004 <_entry-0x741ffffc>
    80204b20:	00000097          	auipc	ra,0x0
    80204b24:	f04080e7          	jalr	-252(ra) # 80204a24 <write32>
    write32(PLIC_ENABLE, (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));
    80204b28:	40200593          	li	a1,1026
    80204b2c:	0c0027b7          	lui	a5,0xc002
    80204b30:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204b34:	00000097          	auipc	ra,0x0
    80204b38:	ef0080e7          	jalr	-272(ra) # 80204a24 <write32>
    write32(PLIC_THRESHOLD, 0);
    80204b3c:	4581                	li	a1,0
    80204b3e:	0c201537          	lui	a0,0xc201
    80204b42:	00000097          	auipc	ra,0x0
    80204b46:	ee2080e7          	jalr	-286(ra) # 80204a24 <write32>
}
    80204b4a:	0001                	nop
    80204b4c:	60e2                	ld	ra,24(sp)
    80204b4e:	6442                	ld	s0,16(sp)
    80204b50:	6105                	addi	sp,sp,32
    80204b52:	8082                	ret

0000000080204b54 <plic_enable>:
void plic_enable(int irq) {
    80204b54:	7179                	addi	sp,sp,-48
    80204b56:	f406                	sd	ra,40(sp)
    80204b58:	f022                	sd	s0,32(sp)
    80204b5a:	1800                	addi	s0,sp,48
    80204b5c:	87aa                	mv	a5,a0
    80204b5e:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204b62:	0c0027b7          	lui	a5,0xc002
    80204b66:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204b6a:	00000097          	auipc	ra,0x0
    80204b6e:	f06080e7          	jalr	-250(ra) # 80204a70 <read32>
    80204b72:	87aa                	mv	a5,a0
    80204b74:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old | (1 << irq));
    80204b78:	fdc42783          	lw	a5,-36(s0)
    80204b7c:	873e                	mv	a4,a5
    80204b7e:	4785                	li	a5,1
    80204b80:	00e797bb          	sllw	a5,a5,a4
    80204b84:	2781                	sext.w	a5,a5
    80204b86:	2781                	sext.w	a5,a5
    80204b88:	fec42703          	lw	a4,-20(s0)
    80204b8c:	8fd9                	or	a5,a5,a4
    80204b8e:	2781                	sext.w	a5,a5
    80204b90:	85be                	mv	a1,a5
    80204b92:	0c0027b7          	lui	a5,0xc002
    80204b96:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204b9a:	00000097          	auipc	ra,0x0
    80204b9e:	e8a080e7          	jalr	-374(ra) # 80204a24 <write32>
}
    80204ba2:	0001                	nop
    80204ba4:	70a2                	ld	ra,40(sp)
    80204ba6:	7402                	ld	s0,32(sp)
    80204ba8:	6145                	addi	sp,sp,48
    80204baa:	8082                	ret

0000000080204bac <plic_disable>:
void plic_disable(int irq) {
    80204bac:	7179                	addi	sp,sp,-48
    80204bae:	f406                	sd	ra,40(sp)
    80204bb0:	f022                	sd	s0,32(sp)
    80204bb2:	1800                	addi	s0,sp,48
    80204bb4:	87aa                	mv	a5,a0
    80204bb6:	fcf42e23          	sw	a5,-36(s0)
    uint32 old = read32(PLIC_ENABLE);
    80204bba:	0c0027b7          	lui	a5,0xc002
    80204bbe:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204bc2:	00000097          	auipc	ra,0x0
    80204bc6:	eae080e7          	jalr	-338(ra) # 80204a70 <read32>
    80204bca:	87aa                	mv	a5,a0
    80204bcc:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_ENABLE, old & ~(1 << irq));
    80204bd0:	fdc42783          	lw	a5,-36(s0)
    80204bd4:	873e                	mv	a4,a5
    80204bd6:	4785                	li	a5,1
    80204bd8:	00e797bb          	sllw	a5,a5,a4
    80204bdc:	2781                	sext.w	a5,a5
    80204bde:	fff7c793          	not	a5,a5
    80204be2:	2781                	sext.w	a5,a5
    80204be4:	2781                	sext.w	a5,a5
    80204be6:	fec42703          	lw	a4,-20(s0)
    80204bea:	8ff9                	and	a5,a5,a4
    80204bec:	2781                	sext.w	a5,a5
    80204bee:	85be                	mv	a1,a5
    80204bf0:	0c0027b7          	lui	a5,0xc002
    80204bf4:	08078513          	addi	a0,a5,128 # c002080 <_entry-0x741fdf80>
    80204bf8:	00000097          	auipc	ra,0x0
    80204bfc:	e2c080e7          	jalr	-468(ra) # 80204a24 <write32>
}
    80204c00:	0001                	nop
    80204c02:	70a2                	ld	ra,40(sp)
    80204c04:	7402                	ld	s0,32(sp)
    80204c06:	6145                	addi	sp,sp,48
    80204c08:	8082                	ret

0000000080204c0a <plic_claim>:
int plic_claim(void) {
    80204c0a:	1141                	addi	sp,sp,-16
    80204c0c:	e406                	sd	ra,8(sp)
    80204c0e:	e022                	sd	s0,0(sp)
    80204c10:	0800                	addi	s0,sp,16
    return read32(PLIC_CLAIM);
    80204c12:	0c2017b7          	lui	a5,0xc201
    80204c16:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204c1a:	00000097          	auipc	ra,0x0
    80204c1e:	e56080e7          	jalr	-426(ra) # 80204a70 <read32>
    80204c22:	87aa                	mv	a5,a0
    80204c24:	2781                	sext.w	a5,a5
    80204c26:	2781                	sext.w	a5,a5
}
    80204c28:	853e                	mv	a0,a5
    80204c2a:	60a2                	ld	ra,8(sp)
    80204c2c:	6402                	ld	s0,0(sp)
    80204c2e:	0141                	addi	sp,sp,16
    80204c30:	8082                	ret

0000000080204c32 <plic_complete>:
void plic_complete(int irq) {
    80204c32:	1101                	addi	sp,sp,-32
    80204c34:	ec06                	sd	ra,24(sp)
    80204c36:	e822                	sd	s0,16(sp)
    80204c38:	1000                	addi	s0,sp,32
    80204c3a:	87aa                	mv	a5,a0
    80204c3c:	fef42623          	sw	a5,-20(s0)
    write32(PLIC_CLAIM, irq);
    80204c40:	fec42783          	lw	a5,-20(s0)
    80204c44:	85be                	mv	a1,a5
    80204c46:	0c2017b7          	lui	a5,0xc201
    80204c4a:	00478513          	addi	a0,a5,4 # c201004 <_entry-0x73ffeffc>
    80204c4e:	00000097          	auipc	ra,0x0
    80204c52:	dd6080e7          	jalr	-554(ra) # 80204a24 <write32>
    80204c56:	0001                	nop
    80204c58:	60e2                	ld	ra,24(sp)
    80204c5a:	6442                	ld	s0,16(sp)
    80204c5c:	6105                	addi	sp,sp,32
    80204c5e:	8082                	ret

0000000080204c60 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80204c60:	7111                	addi	sp,sp,-256

        # save ALL registers (caller-saved and callee-saved)
        sd ra, 0(sp)
    80204c62:	e006                	sd	ra,0(sp)
        sd gp, 16(sp)
    80204c64:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80204c66:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80204c68:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80204c6a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80204c6c:	f81e                	sd	t2,48(sp)
        sd s0, 56(sp)    # 保存s0/fp
    80204c6e:	fc22                	sd	s0,56(sp)
        sd s1, 64(sp)    # 保存s1
    80204c70:	e0a6                	sd	s1,64(sp)
        sd a0, 72(sp)
    80204c72:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80204c74:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80204c76:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80204c78:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80204c7a:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80204c7c:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80204c7e:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80204c80:	e146                	sd	a7,128(sp)
        sd s2, 136(sp)   # 保存s2
    80204c82:	e54a                	sd	s2,136(sp)
        sd s3, 144(sp)   # 保存s3
    80204c84:	e94e                	sd	s3,144(sp)
        sd s4, 152(sp)   # 保存s4
    80204c86:	ed52                	sd	s4,152(sp)
        sd s5, 160(sp)   # 保存s5
    80204c88:	f156                	sd	s5,160(sp)
        sd s6, 168(sp)   # 保存s6
    80204c8a:	f55a                	sd	s6,168(sp)
        sd s7, 176(sp)   # 保存s7
    80204c8c:	f95e                	sd	s7,176(sp)
        sd s8, 184(sp)   # 保存s8
    80204c8e:	fd62                	sd	s8,184(sp)
        sd s9, 192(sp)   # 保存s9
    80204c90:	e1e6                	sd	s9,192(sp)
        sd s10, 200(sp)  # 保存s10
    80204c92:	e5ea                	sd	s10,200(sp)
        sd s11, 208(sp)  # 保存s11
    80204c94:	e9ee                	sd	s11,208(sp)
        sd t3, 216(sp)
    80204c96:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80204c98:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80204c9a:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80204c9c:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80204c9e:	fffff097          	auipc	ra,0xfffff
    80204ca2:	cfa080e7          	jalr	-774(ra) # 80203998 <kerneltrap>

        # restore ALL registers
        ld ra, 0(sp)
    80204ca6:	6082                	ld	ra,0(sp)
        # 不恢复sp
        ld gp, 16(sp)
    80204ca8:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80204caa:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80204cac:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80204cae:	73c2                	ld	t2,48(sp)
        ld s0, 56(sp)    # 恢复s0/fp
    80204cb0:	7462                	ld	s0,56(sp)
        ld s1, 64(sp)    # 恢复s1
    80204cb2:	6486                	ld	s1,64(sp)
        ld a0, 72(sp)
    80204cb4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80204cb6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80204cb8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80204cba:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80204cbc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80204cbe:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80204cc0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80204cc2:	688a                	ld	a7,128(sp)
        ld s2, 136(sp)   # 恢复s2
    80204cc4:	692a                	ld	s2,136(sp)
        ld s3, 144(sp)   # 恢复s3
    80204cc6:	69ca                	ld	s3,144(sp)
        ld s4, 152(sp)   # 恢复s4
    80204cc8:	6a6a                	ld	s4,152(sp)
        ld s5, 160(sp)   # 恢复s5
    80204cca:	7a8a                	ld	s5,160(sp)
        ld s6, 168(sp)   # 恢复s6
    80204ccc:	7b2a                	ld	s6,168(sp)
        ld s7, 176(sp)   # 恢复s7
    80204cce:	7bca                	ld	s7,176(sp)
        ld s8, 184(sp)   # 恢复s8
    80204cd0:	7c6a                	ld	s8,184(sp)
        ld s9, 192(sp)   # 恢复s9
    80204cd2:	6c8e                	ld	s9,192(sp)
        ld s10, 200(sp)  # 恢复s10
    80204cd4:	6d2e                	ld	s10,200(sp)
        ld s11, 208(sp)  # 恢复s11
    80204cd6:	6dce                	ld	s11,208(sp)
        ld t3, 216(sp)
    80204cd8:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80204cda:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80204cdc:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80204cde:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80204ce0:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
    80204ce2:	10200073          	sret
    80204ce6:	0001                	nop
    80204ce8:	00000013          	nop
    80204cec:	00000013          	nop

0000000080204cf0 <trampoline>:
trampoline:
.align 4

uservec:
    # 1. 取 trapframe 指针
    csrrw a0, sscratch, a0      # a0 = TRAPFRAME (用户页表下可访问), sscratch = user a0
    80204cf0:	14051573          	csrrw	a0,sscratch,a0

    # 2. 按新的trapframe结构保存寄存器
    sd   ra, 64(a0)             # ra offset: 64
    80204cf4:	04153023          	sd	ra,64(a0) # c201040 <_entry-0x73ffefc0>
    sd   sp, 72(a0)             # sp offset: 72
    80204cf8:	04253423          	sd	sp,72(a0)
    sd   gp, 80(a0)             # gp offset: 80
    80204cfc:	04353823          	sd	gp,80(a0)
    sd   tp, 88(a0)             # tp offset: 88
    80204d00:	04453c23          	sd	tp,88(a0)
    sd   t0, 96(a0)             # t0 offset: 96
    80204d04:	06553023          	sd	t0,96(a0)
    sd   t1, 104(a0)            # t1 offset: 104
    80204d08:	06653423          	sd	t1,104(a0)
    sd   t2, 112(a0)            # t2 offset: 112
    80204d0c:	06753823          	sd	t2,112(a0)
    sd   t3, 120(a0)            # t3 offset: 120
    80204d10:	07c53c23          	sd	t3,120(a0)
    sd   t4, 128(a0)            # t4 offset: 128
    80204d14:	09d53023          	sd	t4,128(a0)
    sd   t5, 136(a0)            # t5 offset: 136
    80204d18:	09e53423          	sd	t5,136(a0)
    sd   t6, 144(a0)            # t6 offset: 144
    80204d1c:	09f53823          	sd	t6,144(a0)
    sd   s0, 152(a0)            # s0 offset: 152
    80204d20:	ed40                	sd	s0,152(a0)
    sd   s1, 160(a0)            # s1 offset: 160
    80204d22:	f144                	sd	s1,160(a0)

    # 继续保存其他寄存器
    sd   a1, 176(a0)            # a1 offset: 176
    80204d24:	f94c                	sd	a1,176(a0)
    sd   a2, 184(a0)            # a2 offset: 184
    80204d26:	fd50                	sd	a2,184(a0)
    sd   a3, 192(a0)            # a3 offset: 192
    80204d28:	e174                	sd	a3,192(a0)
    sd   a4, 200(a0)            # a4 offset: 200
    80204d2a:	e578                	sd	a4,200(a0)
    sd   a5, 208(a0)            # a5 offset: 208
    80204d2c:	e97c                	sd	a5,208(a0)
    sd   a6, 216(a0)            # a6 offset: 216
    80204d2e:	0d053c23          	sd	a6,216(a0)
    sd   a7, 224(a0)            # a7 offset: 224
    80204d32:	0f153023          	sd	a7,224(a0)
    sd   s2, 232(a0)            # s2 offset: 232
    80204d36:	0f253423          	sd	s2,232(a0)
    sd   s3, 240(a0)            # s3 offset: 240
    80204d3a:	0f353823          	sd	s3,240(a0)
    sd   s4, 248(a0)            # s4 offset: 248
    80204d3e:	0f453c23          	sd	s4,248(a0)
    sd   s5, 256(a0)            # s5 offset: 256
    80204d42:	11553023          	sd	s5,256(a0)
    sd   s6, 264(a0)            # s6 offset: 264
    80204d46:	11653423          	sd	s6,264(a0)
    sd   s7, 272(a0)            # s7 offset: 272
    80204d4a:	11753823          	sd	s7,272(a0)
    sd   s8, 280(a0)            # s8 offset: 280
    80204d4e:	11853c23          	sd	s8,280(a0)
    sd   s9, 288(a0)            # s9 offset: 288
    80204d52:	13953023          	sd	s9,288(a0)
    sd   s10, 296(a0)           # s10 offset: 296
    80204d56:	13a53423          	sd	s10,296(a0)
    sd   s11, 304(a0)           # s11 offset: 304
    80204d5a:	13b53823          	sd	s11,304(a0)

	# 保存用户 a0：先取回 sscratch 里的原值
    csrr t0, sscratch
    80204d5e:	140022f3          	csrr	t0,sscratch
    sd   t0, 168(a0)
    80204d62:	0a553423          	sd	t0,168(a0)

    # 保存控制寄存器
    csrr t0, sstatus
    80204d66:	100022f3          	csrr	t0,sstatus
    sd   t0, 48(a0)
    80204d6a:	02553823          	sd	t0,48(a0)
    csrr t1, sepc
    80204d6e:	14102373          	csrr	t1,sepc
    sd   t1, 56(a0)
    80204d72:	02653c23          	sd	t1,56(a0)

	# 在切换页表前，先读出关键字段到 t3–t6
    ld   t3, 0(a0)              # t3 = kernel_satp
    80204d76:	00053e03          	ld	t3,0(a0)
    ld   t4, 8(a0)              # t4 = kernel_sp
    80204d7a:	00853e83          	ld	t4,8(a0)
    ld   t5, 24(a0)            # t5 = usertrap
    80204d7e:	01853f03          	ld	t5,24(a0)
	ld   t6, 32(a0)			# t6 = kernel_vec
    80204d82:	02053f83          	ld	t6,32(a0)

    # 4. 切换到内核页表
    csrw satp, t3
    80204d86:	180e1073          	csrw	satp,t3
    sfence.vma x0, x0
    80204d8a:	12000073          	sfence.vma

    # 5. 切换到内核栈
    mv   sp, t4
    80204d8e:	8176                	mv	sp,t4

    # 6. 设置 stvec 并跳转到 C 层 usertrap
    csrw stvec, t6
    80204d90:	105f9073          	csrw	stvec,t6
    jr   t5
    80204d94:	8f02                	jr	t5

0000000080204d96 <userret>:
userret:
        csrw satp, a1
    80204d96:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    80204d9a:	12000073          	sfence.vma
    # 2. 按新的偏移量恢复寄存器
    ld   ra, 64(a0)
    80204d9e:	04053083          	ld	ra,64(a0)
    ld   sp, 72(a0)
    80204da2:	04853103          	ld	sp,72(a0)
    ld   gp, 80(a0)
    80204da6:	05053183          	ld	gp,80(a0)
    ld   tp, 88(a0)
    80204daa:	05853203          	ld	tp,88(a0)
    ld   t0, 96(a0)
    80204dae:	06053283          	ld	t0,96(a0)
    ld   t1, 104(a0)
    80204db2:	06853303          	ld	t1,104(a0)
    ld   t2, 112(a0)
    80204db6:	07053383          	ld	t2,112(a0)
    ld   t3, 120(a0)
    80204dba:	07853e03          	ld	t3,120(a0)
    ld   t4, 128(a0)
    80204dbe:	08053e83          	ld	t4,128(a0)
    ld   t5, 136(a0)
    80204dc2:	08853f03          	ld	t5,136(a0)
    ld   t6, 144(a0)
    80204dc6:	09053f83          	ld	t6,144(a0)
    ld   s0, 152(a0)
    80204dca:	6d40                	ld	s0,152(a0)
    ld   s1, 160(a0)
    80204dcc:	7144                	ld	s1,160(a0)
    ld   a1, 176(a0)
    80204dce:	794c                	ld	a1,176(a0)
    ld   a2, 184(a0)
    80204dd0:	7d50                	ld	a2,184(a0)
    ld   a3, 192(a0)
    80204dd2:	6174                	ld	a3,192(a0)
    ld   a4, 200(a0)
    80204dd4:	6578                	ld	a4,200(a0)
    ld   a5, 208(a0)
    80204dd6:	697c                	ld	a5,208(a0)
    ld   a6, 216(a0)
    80204dd8:	0d853803          	ld	a6,216(a0)
    ld   a7, 224(a0)
    80204ddc:	0e053883          	ld	a7,224(a0)
    ld   s2, 232(a0)
    80204de0:	0e853903          	ld	s2,232(a0)
    ld   s3, 240(a0)
    80204de4:	0f053983          	ld	s3,240(a0)
    ld   s4, 248(a0)
    80204de8:	0f853a03          	ld	s4,248(a0)
    ld   s5, 256(a0)
    80204dec:	10053a83          	ld	s5,256(a0)
    ld   s6, 264(a0)
    80204df0:	10853b03          	ld	s6,264(a0)
    ld   s7, 272(a0)
    80204df4:	11053b83          	ld	s7,272(a0)
    ld   s8, 280(a0)
    80204df8:	11853c03          	ld	s8,280(a0)
    ld   s9, 288(a0)
    80204dfc:	12053c83          	ld	s9,288(a0)
    ld   s10, 296(a0)
    80204e00:	12853d03          	ld	s10,296(a0)
    ld   s11, 304(a0)
    80204e04:	13053d83          	ld	s11,304(a0)

        # 使用临时变量恢复控制寄存器
        ld t0, 56(a0)      # 恢复 sepc
    80204e08:	03853283          	ld	t0,56(a0)
        csrw sepc, t0
    80204e0c:	14129073          	csrw	sepc,t0
        ld t0, 48(a0)      # 恢复 sstatus
    80204e10:	03053283          	ld	t0,48(a0)
        csrw sstatus, t0
    80204e14:	10029073          	csrw	sstatus,t0
		csrw sscratch, a0
    80204e18:	14051073          	csrw	sscratch,a0
		ld a0, 168(a0)
    80204e1c:	7548                	ld	a0,168(a0)
    80204e1e:	10200073          	sret
    80204e22:	0001                	nop
    80204e24:	00000013          	nop
    80204e28:	00000013          	nop
    80204e2c:	00000013          	nop

0000000080204e30 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80204e30:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80204e34:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80204e38:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80204e3a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80204e3c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80204e40:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80204e44:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80204e48:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80204e4c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80204e50:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80204e54:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80204e58:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80204e5c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80204e60:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80204e64:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80204e68:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80204e6c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80204e6e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80204e70:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80204e74:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80204e78:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80204e7c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80204e80:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80204e84:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80204e88:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80204e8c:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80204e90:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80204e94:	0685bd83          	ld	s11,104(a1)
        
        ret
    80204e98:	8082                	ret

0000000080204e9a <r_sstatus>:
    register uint64 ra asm("ra");
    p->context.ra = ra;
    p->chan = chan;
    p->state = SLEEPING;
    swtch(&p->context, &c->context);
    p->chan = 0;
    80204e9a:	1101                	addi	sp,sp,-32
    80204e9c:	ec22                	sd	s0,24(sp)
    80204e9e:	1000                	addi	s0,sp,32
	if(p->killed){
		printf("[sleep] Process PID %d killed when wakeup\n", p->pid);
    80204ea0:	100027f3          	csrr	a5,sstatus
    80204ea4:	fef43423          	sd	a5,-24(s0)
		exit_proc(SYS_kill);
    80204ea8:	fe843783          	ld	a5,-24(s0)
	}
    80204eac:	853e                	mv	a0,a5
    80204eae:	6462                	ld	s0,24(sp)
    80204eb0:	6105                	addi	sp,sp,32
    80204eb2:	8082                	ret

0000000080204eb4 <w_sstatus>:
}
    80204eb4:	1101                	addi	sp,sp,-32
    80204eb6:	ec22                	sd	s0,24(sp)
    80204eb8:	1000                	addi	s0,sp,32
    80204eba:	fea43423          	sd	a0,-24(s0)
void wakeup(void *chan) {
    80204ebe:	fe843783          	ld	a5,-24(s0)
    80204ec2:	10079073          	csrw	sstatus,a5
    for(int i = 0; i < PROC; i++) {
    80204ec6:	0001                	nop
    80204ec8:	6462                	ld	s0,24(sp)
    80204eca:	6105                	addi	sp,sp,32
    80204ecc:	8082                	ret

0000000080204ece <intr_on>:
        }
    }
}
void kill_proc(int pid){
	for(int i=0;i<PROC;i++){
		struct proc *p = proc_table[i];
    80204ece:	1141                	addi	sp,sp,-16
    80204ed0:	e406                	sd	ra,8(sp)
    80204ed2:	e022                	sd	s0,0(sp)
    80204ed4:	0800                	addi	s0,sp,16
		if(pid == p->pid){
    80204ed6:	00000097          	auipc	ra,0x0
    80204eda:	fc4080e7          	jalr	-60(ra) # 80204e9a <r_sstatus>
    80204ede:	87aa                	mv	a5,a0
    80204ee0:	0027e793          	ori	a5,a5,2
    80204ee4:	853e                	mv	a0,a5
    80204ee6:	00000097          	auipc	ra,0x0
    80204eea:	fce080e7          	jalr	-50(ra) # 80204eb4 <w_sstatus>
			p->killed = 1;
    80204eee:	0001                	nop
    80204ef0:	60a2                	ld	ra,8(sp)
    80204ef2:	6402                	ld	s0,0(sp)
    80204ef4:	0141                	addi	sp,sp,16
    80204ef6:	8082                	ret

0000000080204ef8 <intr_off>:
			break;
		}
    80204ef8:	1141                	addi	sp,sp,-16
    80204efa:	e406                	sd	ra,8(sp)
    80204efc:	e022                	sd	s0,0(sp)
    80204efe:	0800                	addi	s0,sp,16
	}
    80204f00:	00000097          	auipc	ra,0x0
    80204f04:	f9a080e7          	jalr	-102(ra) # 80204e9a <r_sstatus>
    80204f08:	87aa                	mv	a5,a0
    80204f0a:	9bf5                	andi	a5,a5,-3
    80204f0c:	853e                	mv	a0,a5
    80204f0e:	00000097          	auipc	ra,0x0
    80204f12:	fa6080e7          	jalr	-90(ra) # 80204eb4 <w_sstatus>
	return;
    80204f16:	0001                	nop
    80204f18:	60a2                	ld	ra,8(sp)
    80204f1a:	6402                	ld	s0,0(sp)
    80204f1c:	0141                	addi	sp,sp,16
    80204f1e:	8082                	ret

0000000080204f20 <w_stvec>:
}
void exit_proc(int status) {
    80204f20:	1101                	addi	sp,sp,-32
    80204f22:	ec22                	sd	s0,24(sp)
    80204f24:	1000                	addi	s0,sp,32
    80204f26:	fea43423          	sd	a0,-24(s0)
    struct proc *p = myproc();
    80204f2a:	fe843783          	ld	a5,-24(s0)
    80204f2e:	10579073          	csrw	stvec,a5
    if (p == 0) {
    80204f32:	0001                	nop
    80204f34:	6462                	ld	s0,24(sp)
    80204f36:	6105                	addi	sp,sp,32
    80204f38:	8082                	ret

0000000080204f3a <assert>:
            struct proc *child = proc_table[i];
            if (child->state == ZOMBIE && child->parent == p) {
                found_zombie = 1;
                zombie_pid = child->pid;
                zombie_status = child->exit_status;
                zombie_child = child;
    80204f3a:	1101                	addi	sp,sp,-32
    80204f3c:	ec06                	sd	ra,24(sp)
    80204f3e:	e822                	sd	s0,16(sp)
    80204f40:	1000                	addi	s0,sp,32
    80204f42:	87aa                	mv	a5,a0
    80204f44:	fef42623          	sw	a5,-20(s0)
                break;
    80204f48:	fec42783          	lw	a5,-20(s0)
    80204f4c:	2781                	sext.w	a5,a5
    80204f4e:	e79d                	bnez	a5,80204f7c <assert+0x42>
            }
    80204f50:	1b700613          	li	a2,439
    80204f54:	0001b597          	auipc	a1,0x1b
    80204f58:	fb458593          	addi	a1,a1,-76 # 8021ff08 <user_test_table+0x60>
    80204f5c:	0001b517          	auipc	a0,0x1b
    80204f60:	fbc50513          	addi	a0,a0,-68 # 8021ff18 <user_test_table+0x70>
    80204f64:	ffffc097          	auipc	ra,0xffffc
    80204f68:	dca080e7          	jalr	-566(ra) # 80200d2e <printf>
        }
    80204f6c:	0001b517          	auipc	a0,0x1b
    80204f70:	fd450513          	addi	a0,a0,-44 # 8021ff40 <user_test_table+0x98>
    80204f74:	ffffd097          	auipc	ra,0xffffd
    80204f78:	806080e7          	jalr	-2042(ra) # 8020177a <panic>
        
        if (found_zombie) {
    80204f7c:	0001                	nop
    80204f7e:	60e2                	ld	ra,24(sp)
    80204f80:	6442                	ld	s0,16(sp)
    80204f82:	6105                	addi	sp,sp,32
    80204f84:	8082                	ret

0000000080204f86 <shutdown>:
void shutdown() {
    80204f86:	1141                	addi	sp,sp,-16
    80204f88:	e406                	sd	ra,8(sp)
    80204f8a:	e022                	sd	s0,0(sp)
    80204f8c:	0800                	addi	s0,sp,16
	free_proc_table();
    80204f8e:	00000097          	auipc	ra,0x0
    80204f92:	3aa080e7          	jalr	938(ra) # 80205338 <free_proc_table>
    printf("关机\n");
    80204f96:	0001b517          	auipc	a0,0x1b
    80204f9a:	fb250513          	addi	a0,a0,-78 # 8021ff48 <user_test_table+0xa0>
    80204f9e:	ffffc097          	auipc	ra,0xffffc
    80204fa2:	d90080e7          	jalr	-624(ra) # 80200d2e <printf>
    asm volatile (
    80204fa6:	48a1                	li	a7,8
    80204fa8:	00000073          	ecall
    while (1) { }
    80204fac:	0001                	nop
    80204fae:	bffd                	j	80204fac <shutdown+0x26>

0000000080204fb0 <myproc>:
struct proc* myproc(void) {
    80204fb0:	1141                	addi	sp,sp,-16
    80204fb2:	e422                	sd	s0,8(sp)
    80204fb4:	0800                	addi	s0,sp,16
    return current_proc;
    80204fb6:	00022797          	auipc	a5,0x22
    80204fba:	0f278793          	addi	a5,a5,242 # 802270a8 <current_proc>
    80204fbe:	639c                	ld	a5,0(a5)
}
    80204fc0:	853e                	mv	a0,a5
    80204fc2:	6422                	ld	s0,8(sp)
    80204fc4:	0141                	addi	sp,sp,16
    80204fc6:	8082                	ret

0000000080204fc8 <mycpu>:
struct cpu* mycpu(void) {
    80204fc8:	1141                	addi	sp,sp,-16
    80204fca:	e406                	sd	ra,8(sp)
    80204fcc:	e022                	sd	s0,0(sp)
    80204fce:	0800                	addi	s0,sp,16
    if (current_cpu == 0) {
    80204fd0:	00022797          	auipc	a5,0x22
    80204fd4:	0e078793          	addi	a5,a5,224 # 802270b0 <current_cpu>
    80204fd8:	639c                	ld	a5,0(a5)
    80204fda:	ebb9                	bnez	a5,80205030 <mycpu+0x68>
        warning("current_cpu is NULL, initializing...\n");
    80204fdc:	0001b517          	auipc	a0,0x1b
    80204fe0:	f7450513          	addi	a0,a0,-140 # 8021ff50 <user_test_table+0xa8>
    80204fe4:	ffffc097          	auipc	ra,0xffffc
    80204fe8:	7ca080e7          	jalr	1994(ra) # 802017ae <warning>
		memset(&cpu_instance, 0, sizeof(struct cpu));
    80204fec:	07800613          	li	a2,120
    80204ff0:	4581                	li	a1,0
    80204ff2:	00022517          	auipc	a0,0x22
    80204ff6:	67e50513          	addi	a0,a0,1662 # 80227670 <cpu_instance.0>
    80204ffa:	ffffd097          	auipc	ra,0xffffd
    80204ffe:	ebe080e7          	jalr	-322(ra) # 80201eb8 <memset>
		current_cpu = &cpu_instance;
    80205002:	00022797          	auipc	a5,0x22
    80205006:	0ae78793          	addi	a5,a5,174 # 802270b0 <current_cpu>
    8020500a:	00022717          	auipc	a4,0x22
    8020500e:	66670713          	addi	a4,a4,1638 # 80227670 <cpu_instance.0>
    80205012:	e398                	sd	a4,0(a5)
		printf("CPU initialized: %p\n", current_cpu);
    80205014:	00022797          	auipc	a5,0x22
    80205018:	09c78793          	addi	a5,a5,156 # 802270b0 <current_cpu>
    8020501c:	639c                	ld	a5,0(a5)
    8020501e:	85be                	mv	a1,a5
    80205020:	0001b517          	auipc	a0,0x1b
    80205024:	f5850513          	addi	a0,a0,-168 # 8021ff78 <user_test_table+0xd0>
    80205028:	ffffc097          	auipc	ra,0xffffc
    8020502c:	d06080e7          	jalr	-762(ra) # 80200d2e <printf>
    return current_cpu;
    80205030:	00022797          	auipc	a5,0x22
    80205034:	08078793          	addi	a5,a5,128 # 802270b0 <current_cpu>
    80205038:	639c                	ld	a5,0(a5)
}
    8020503a:	853e                	mv	a0,a5
    8020503c:	60a2                	ld	ra,8(sp)
    8020503e:	6402                	ld	s0,0(sp)
    80205040:	0141                	addi	sp,sp,16
    80205042:	8082                	ret

0000000080205044 <return_to_user>:
void return_to_user(void) {
    80205044:	7179                	addi	sp,sp,-48
    80205046:	f406                	sd	ra,40(sp)
    80205048:	f022                	sd	s0,32(sp)
    8020504a:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    8020504c:	00000097          	auipc	ra,0x0
    80205050:	f64080e7          	jalr	-156(ra) # 80204fb0 <myproc>
    80205054:	fea43423          	sd	a0,-24(s0)
    if (!p) panic("return_to_user: no current process");
    80205058:	fe843783          	ld	a5,-24(s0)
    8020505c:	eb89                	bnez	a5,8020506e <return_to_user+0x2a>
    8020505e:	0001b517          	auipc	a0,0x1b
    80205062:	f3250513          	addi	a0,a0,-206 # 8021ff90 <user_test_table+0xe8>
    80205066:	ffffc097          	auipc	ra,0xffffc
    8020506a:	714080e7          	jalr	1812(ra) # 8020177a <panic>
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    8020506e:	00000717          	auipc	a4,0x0
    80205072:	c8270713          	addi	a4,a4,-894 # 80204cf0 <trampoline>
    80205076:	00000797          	auipc	a5,0x0
    8020507a:	c7a78793          	addi	a5,a5,-902 # 80204cf0 <trampoline>
    8020507e:	40f707b3          	sub	a5,a4,a5
    80205082:	873e                	mv	a4,a5
    80205084:	77fd                	lui	a5,0xfffff
    80205086:	97ba                	add	a5,a5,a4
    80205088:	853e                	mv	a0,a5
    8020508a:	00000097          	auipc	ra,0x0
    8020508e:	e96080e7          	jalr	-362(ra) # 80204f20 <w_stvec>
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80205092:	00000717          	auipc	a4,0x0
    80205096:	d0470713          	addi	a4,a4,-764 # 80204d96 <userret>
    8020509a:	00000797          	auipc	a5,0x0
    8020509e:	c5678793          	addi	a5,a5,-938 # 80204cf0 <trampoline>
    802050a2:	40f707b3          	sub	a5,a4,a5
    802050a6:	873e                	mv	a4,a5
    802050a8:	77fd                	lui	a5,0xfffff
    802050aa:	97ba                	add	a5,a5,a4
    802050ac:	fef43023          	sd	a5,-32(s0)
    uint64 satp = MAKE_SATP(p->pagetable);
    802050b0:	fe843783          	ld	a5,-24(s0)
    802050b4:	7fdc                	ld	a5,184(a5)
    802050b6:	00c7d713          	srli	a4,a5,0xc
    802050ba:	57fd                	li	a5,-1
    802050bc:	17fe                	slli	a5,a5,0x3f
    802050be:	8fd9                	or	a5,a5,a4
    802050c0:	fcf43c23          	sd	a5,-40(s0)
    if ((trampoline_userret & ~(PGSIZE - 1)) != TRAMPOLINE) {
    802050c4:	fe043703          	ld	a4,-32(s0)
    802050c8:	77fd                	lui	a5,0xfffff
    802050ca:	8f7d                	and	a4,a4,a5
    802050cc:	77fd                	lui	a5,0xfffff
    802050ce:	00f70a63          	beq	a4,a5,802050e2 <return_to_user+0x9e>
        panic("return_to_user: userret outside trampoline page");
    802050d2:	0001b517          	auipc	a0,0x1b
    802050d6:	ee650513          	addi	a0,a0,-282 # 8021ffb8 <user_test_table+0x110>
    802050da:	ffffc097          	auipc	ra,0xffffc
    802050de:	6a0080e7          	jalr	1696(ra) # 8020177a <panic>
    void (*userret_fn)(uint64, uint64) = (void (*)(uint64, uint64))trampoline_userret;
    802050e2:	fe043783          	ld	a5,-32(s0)
    802050e6:	fcf43823          	sd	a5,-48(s0)
    userret_fn(TRAPFRAME, satp);
    802050ea:	fd043783          	ld	a5,-48(s0)
    802050ee:	fd843583          	ld	a1,-40(s0)
    802050f2:	7579                	lui	a0,0xffffe
    802050f4:	9782                	jalr	a5
    panic("return_to_user: should not return");
    802050f6:	0001b517          	auipc	a0,0x1b
    802050fa:	ef250513          	addi	a0,a0,-270 # 8021ffe8 <user_test_table+0x140>
    802050fe:	ffffc097          	auipc	ra,0xffffc
    80205102:	67c080e7          	jalr	1660(ra) # 8020177a <panic>
}
    80205106:	0001                	nop
    80205108:	70a2                	ld	ra,40(sp)
    8020510a:	7402                	ld	s0,32(sp)
    8020510c:	6145                	addi	sp,sp,48
    8020510e:	8082                	ret

0000000080205110 <forkret>:
void forkret(void) {
    80205110:	1101                	addi	sp,sp,-32
    80205112:	ec06                	sd	ra,24(sp)
    80205114:	e822                	sd	s0,16(sp)
    80205116:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80205118:	00000097          	auipc	ra,0x0
    8020511c:	e98080e7          	jalr	-360(ra) # 80204fb0 <myproc>
    80205120:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205124:	fe843783          	ld	a5,-24(s0)
    80205128:	eb89                	bnez	a5,8020513a <forkret+0x2a>
        panic("forkret: no current process");
    8020512a:	0001b517          	auipc	a0,0x1b
    8020512e:	ee650513          	addi	a0,a0,-282 # 80220010 <user_test_table+0x168>
    80205132:	ffffc097          	auipc	ra,0xffffc
    80205136:	648080e7          	jalr	1608(ra) # 8020177a <panic>
    if (p->killed) {
    8020513a:	fe843783          	ld	a5,-24(s0)
    8020513e:	0807a783          	lw	a5,128(a5) # fffffffffffff080 <_bss_end+0xffffffff7fdd7990>
    80205142:	c785                	beqz	a5,8020516a <forkret+0x5a>
        printf("[forkret] Process PID %d killed before execution\n", p->pid);
    80205144:	fe843783          	ld	a5,-24(s0)
    80205148:	43dc                	lw	a5,4(a5)
    8020514a:	85be                	mv	a1,a5
    8020514c:	0001b517          	auipc	a0,0x1b
    80205150:	ee450513          	addi	a0,a0,-284 # 80220030 <user_test_table+0x188>
    80205154:	ffffc097          	auipc	ra,0xffffc
    80205158:	bda080e7          	jalr	-1062(ra) # 80200d2e <printf>
        exit_proc(SYS_kill);
    8020515c:	08100513          	li	a0,129
    80205160:	00001097          	auipc	ra,0x1
    80205164:	c42080e7          	jalr	-958(ra) # 80205da2 <exit_proc>
        return; // 虽然不会执行到这里，但为了代码清晰
    80205168:	a099                	j	802051ae <forkret+0x9e>
    if (p->is_user) {
    8020516a:	fe843783          	ld	a5,-24(s0)
    8020516e:	0a87a783          	lw	a5,168(a5)
    80205172:	c791                	beqz	a5,8020517e <forkret+0x6e>
        return_to_user();
    80205174:	00000097          	auipc	ra,0x0
    80205178:	ed0080e7          	jalr	-304(ra) # 80205044 <return_to_user>
    8020517c:	a80d                	j	802051ae <forkret+0x9e>
		if (p->trapframe->epc) {
    8020517e:	fe843783          	ld	a5,-24(s0)
    80205182:	63fc                	ld	a5,192(a5)
    80205184:	7f9c                	ld	a5,56(a5)
    80205186:	cf99                	beqz	a5,802051a4 <forkret+0x94>
			void (*fn)(uint64) = (void(*)(uint64))p->trapframe->epc;
    80205188:	fe843783          	ld	a5,-24(s0)
    8020518c:	63fc                	ld	a5,192(a5)
    8020518e:	7f9c                	ld	a5,56(a5)
    80205190:	fef43023          	sd	a5,-32(s0)
			fn(p->trapframe->a0);
    80205194:	fe843783          	ld	a5,-24(s0)
    80205198:	63fc                	ld	a5,192(a5)
    8020519a:	77d8                	ld	a4,168(a5)
    8020519c:	fe043783          	ld	a5,-32(s0)
    802051a0:	853a                	mv	a0,a4
    802051a2:	9782                	jalr	a5
        exit_proc(0);  // 内核线程函数返回则退出
    802051a4:	4501                	li	a0,0
    802051a6:	00001097          	auipc	ra,0x1
    802051aa:	bfc080e7          	jalr	-1028(ra) # 80205da2 <exit_proc>
}
    802051ae:	60e2                	ld	ra,24(sp)
    802051b0:	6442                	ld	s0,16(sp)
    802051b2:	6105                	addi	sp,sp,32
    802051b4:	8082                	ret

00000000802051b6 <init_proc>:
void init_proc(void){
    802051b6:	1101                	addi	sp,sp,-32
    802051b8:	ec06                	sd	ra,24(sp)
    802051ba:	e822                	sd	s0,16(sp)
    802051bc:	1000                	addi	s0,sp,32
    for (int i = 0; i < PROC; i++) {
    802051be:	fe042623          	sw	zero,-20(s0)
    802051c2:	aa81                	j	80205312 <init_proc+0x15c>
        void *page = alloc_page();
    802051c4:	ffffe097          	auipc	ra,0xffffe
    802051c8:	0fc080e7          	jalr	252(ra) # 802032c0 <alloc_page>
    802051cc:	fea43023          	sd	a0,-32(s0)
        if (!page) panic("init_proc: alloc_page failed for proc_table");
    802051d0:	fe043783          	ld	a5,-32(s0)
    802051d4:	eb89                	bnez	a5,802051e6 <init_proc+0x30>
    802051d6:	0001b517          	auipc	a0,0x1b
    802051da:	e9250513          	addi	a0,a0,-366 # 80220068 <user_test_table+0x1c0>
    802051de:	ffffc097          	auipc	ra,0xffffc
    802051e2:	59c080e7          	jalr	1436(ra) # 8020177a <panic>
        proc_table_mem[i] = page;
    802051e6:	00022717          	auipc	a4,0x22
    802051ea:	38a70713          	addi	a4,a4,906 # 80227570 <proc_table_mem>
    802051ee:	fec42783          	lw	a5,-20(s0)
    802051f2:	078e                	slli	a5,a5,0x3
    802051f4:	97ba                	add	a5,a5,a4
    802051f6:	fe043703          	ld	a4,-32(s0)
    802051fa:	e398                	sd	a4,0(a5)
        proc_table[i] = (struct proc *)page;
    802051fc:	00022717          	auipc	a4,0x22
    80205200:	26c70713          	addi	a4,a4,620 # 80227468 <proc_table>
    80205204:	fec42783          	lw	a5,-20(s0)
    80205208:	078e                	slli	a5,a5,0x3
    8020520a:	97ba                	add	a5,a5,a4
    8020520c:	fe043703          	ld	a4,-32(s0)
    80205210:	e398                	sd	a4,0(a5)
        memset(proc_table[i], 0, sizeof(struct proc));
    80205212:	00022717          	auipc	a4,0x22
    80205216:	25670713          	addi	a4,a4,598 # 80227468 <proc_table>
    8020521a:	fec42783          	lw	a5,-20(s0)
    8020521e:	078e                	slli	a5,a5,0x3
    80205220:	97ba                	add	a5,a5,a4
    80205222:	639c                	ld	a5,0(a5)
    80205224:	0c800613          	li	a2,200
    80205228:	4581                	li	a1,0
    8020522a:	853e                	mv	a0,a5
    8020522c:	ffffd097          	auipc	ra,0xffffd
    80205230:	c8c080e7          	jalr	-884(ra) # 80201eb8 <memset>
        proc_table[i]->state = UNUSED;
    80205234:	00022717          	auipc	a4,0x22
    80205238:	23470713          	addi	a4,a4,564 # 80227468 <proc_table>
    8020523c:	fec42783          	lw	a5,-20(s0)
    80205240:	078e                	slli	a5,a5,0x3
    80205242:	97ba                	add	a5,a5,a4
    80205244:	639c                	ld	a5,0(a5)
    80205246:	0007a023          	sw	zero,0(a5)
        proc_table[i]->pid = 0;
    8020524a:	00022717          	auipc	a4,0x22
    8020524e:	21e70713          	addi	a4,a4,542 # 80227468 <proc_table>
    80205252:	fec42783          	lw	a5,-20(s0)
    80205256:	078e                	slli	a5,a5,0x3
    80205258:	97ba                	add	a5,a5,a4
    8020525a:	639c                	ld	a5,0(a5)
    8020525c:	0007a223          	sw	zero,4(a5)
        proc_table[i]->kstack = 0;
    80205260:	00022717          	auipc	a4,0x22
    80205264:	20870713          	addi	a4,a4,520 # 80227468 <proc_table>
    80205268:	fec42783          	lw	a5,-20(s0)
    8020526c:	078e                	slli	a5,a5,0x3
    8020526e:	97ba                	add	a5,a5,a4
    80205270:	639c                	ld	a5,0(a5)
    80205272:	0007b423          	sd	zero,8(a5)
        proc_table[i]->pagetable = 0;
    80205276:	00022717          	auipc	a4,0x22
    8020527a:	1f270713          	addi	a4,a4,498 # 80227468 <proc_table>
    8020527e:	fec42783          	lw	a5,-20(s0)
    80205282:	078e                	slli	a5,a5,0x3
    80205284:	97ba                	add	a5,a5,a4
    80205286:	639c                	ld	a5,0(a5)
    80205288:	0a07bc23          	sd	zero,184(a5)
        proc_table[i]->trapframe = 0;
    8020528c:	00022717          	auipc	a4,0x22
    80205290:	1dc70713          	addi	a4,a4,476 # 80227468 <proc_table>
    80205294:	fec42783          	lw	a5,-20(s0)
    80205298:	078e                	slli	a5,a5,0x3
    8020529a:	97ba                	add	a5,a5,a4
    8020529c:	639c                	ld	a5,0(a5)
    8020529e:	0c07b023          	sd	zero,192(a5)
        proc_table[i]->parent = 0;
    802052a2:	00022717          	auipc	a4,0x22
    802052a6:	1c670713          	addi	a4,a4,454 # 80227468 <proc_table>
    802052aa:	fec42783          	lw	a5,-20(s0)
    802052ae:	078e                	slli	a5,a5,0x3
    802052b0:	97ba                	add	a5,a5,a4
    802052b2:	639c                	ld	a5,0(a5)
    802052b4:	0807bc23          	sd	zero,152(a5)
        proc_table[i]->chan = 0;
    802052b8:	00022717          	auipc	a4,0x22
    802052bc:	1b070713          	addi	a4,a4,432 # 80227468 <proc_table>
    802052c0:	fec42783          	lw	a5,-20(s0)
    802052c4:	078e                	slli	a5,a5,0x3
    802052c6:	97ba                	add	a5,a5,a4
    802052c8:	639c                	ld	a5,0(a5)
    802052ca:	0a07b023          	sd	zero,160(a5)
        proc_table[i]->exit_status = 0;
    802052ce:	00022717          	auipc	a4,0x22
    802052d2:	19a70713          	addi	a4,a4,410 # 80227468 <proc_table>
    802052d6:	fec42783          	lw	a5,-20(s0)
    802052da:	078e                	slli	a5,a5,0x3
    802052dc:	97ba                	add	a5,a5,a4
    802052de:	639c                	ld	a5,0(a5)
    802052e0:	0807a223          	sw	zero,132(a5)
        memset(&proc_table[i]->context, 0, sizeof(struct context));
    802052e4:	00022717          	auipc	a4,0x22
    802052e8:	18470713          	addi	a4,a4,388 # 80227468 <proc_table>
    802052ec:	fec42783          	lw	a5,-20(s0)
    802052f0:	078e                	slli	a5,a5,0x3
    802052f2:	97ba                	add	a5,a5,a4
    802052f4:	639c                	ld	a5,0(a5)
    802052f6:	07c1                	addi	a5,a5,16
    802052f8:	07000613          	li	a2,112
    802052fc:	4581                	li	a1,0
    802052fe:	853e                	mv	a0,a5
    80205300:	ffffd097          	auipc	ra,0xffffd
    80205304:	bb8080e7          	jalr	-1096(ra) # 80201eb8 <memset>
    for (int i = 0; i < PROC; i++) {
    80205308:	fec42783          	lw	a5,-20(s0)
    8020530c:	2785                	addiw	a5,a5,1
    8020530e:	fef42623          	sw	a5,-20(s0)
    80205312:	fec42783          	lw	a5,-20(s0)
    80205316:	0007871b          	sext.w	a4,a5
    8020531a:	47fd                	li	a5,31
    8020531c:	eae7d4e3          	bge	a5,a4,802051c4 <init_proc+0xe>
    proc_table_pages = PROC; // 每个进程一页
    80205320:	00022797          	auipc	a5,0x22
    80205324:	24878793          	addi	a5,a5,584 # 80227568 <proc_table_pages>
    80205328:	02000713          	li	a4,32
    8020532c:	c398                	sw	a4,0(a5)
}
    8020532e:	0001                	nop
    80205330:	60e2                	ld	ra,24(sp)
    80205332:	6442                	ld	s0,16(sp)
    80205334:	6105                	addi	sp,sp,32
    80205336:	8082                	ret

0000000080205338 <free_proc_table>:
void free_proc_table(void) {
    80205338:	1101                	addi	sp,sp,-32
    8020533a:	ec06                	sd	ra,24(sp)
    8020533c:	e822                	sd	s0,16(sp)
    8020533e:	1000                	addi	s0,sp,32
    for (int i = 0; i < proc_table_pages; i++) {
    80205340:	fe042623          	sw	zero,-20(s0)
    80205344:	a025                	j	8020536c <free_proc_table+0x34>
        free_page(proc_table_mem[i]);
    80205346:	00022717          	auipc	a4,0x22
    8020534a:	22a70713          	addi	a4,a4,554 # 80227570 <proc_table_mem>
    8020534e:	fec42783          	lw	a5,-20(s0)
    80205352:	078e                	slli	a5,a5,0x3
    80205354:	97ba                	add	a5,a5,a4
    80205356:	639c                	ld	a5,0(a5)
    80205358:	853e                	mv	a0,a5
    8020535a:	ffffe097          	auipc	ra,0xffffe
    8020535e:	fd2080e7          	jalr	-46(ra) # 8020332c <free_page>
    for (int i = 0; i < proc_table_pages; i++) {
    80205362:	fec42783          	lw	a5,-20(s0)
    80205366:	2785                	addiw	a5,a5,1
    80205368:	fef42623          	sw	a5,-20(s0)
    8020536c:	00022797          	auipc	a5,0x22
    80205370:	1fc78793          	addi	a5,a5,508 # 80227568 <proc_table_pages>
    80205374:	4398                	lw	a4,0(a5)
    80205376:	fec42783          	lw	a5,-20(s0)
    8020537a:	2781                	sext.w	a5,a5
    8020537c:	fce7c5e3          	blt	a5,a4,80205346 <free_proc_table+0xe>
}
    80205380:	0001                	nop
    80205382:	0001                	nop
    80205384:	60e2                	ld	ra,24(sp)
    80205386:	6442                	ld	s0,16(sp)
    80205388:	6105                	addi	sp,sp,32
    8020538a:	8082                	ret

000000008020538c <alloc_proc>:
struct proc* alloc_proc(int is_user) {
    8020538c:	7139                	addi	sp,sp,-64
    8020538e:	fc06                	sd	ra,56(sp)
    80205390:	f822                	sd	s0,48(sp)
    80205392:	0080                	addi	s0,sp,64
    80205394:	87aa                	mv	a5,a0
    80205396:	fcf42623          	sw	a5,-52(s0)
    for(int i = 0;i<PROC;i++) {
    8020539a:	fe042623          	sw	zero,-20(s0)
    8020539e:	aaa5                	j	80205516 <alloc_proc+0x18a>
		struct proc *p = proc_table[i];
    802053a0:	00022717          	auipc	a4,0x22
    802053a4:	0c870713          	addi	a4,a4,200 # 80227468 <proc_table>
    802053a8:	fec42783          	lw	a5,-20(s0)
    802053ac:	078e                	slli	a5,a5,0x3
    802053ae:	97ba                	add	a5,a5,a4
    802053b0:	639c                	ld	a5,0(a5)
    802053b2:	fef43023          	sd	a5,-32(s0)
        if(p->state == UNUSED) {
    802053b6:	fe043783          	ld	a5,-32(s0)
    802053ba:	439c                	lw	a5,0(a5)
    802053bc:	14079863          	bnez	a5,8020550c <alloc_proc+0x180>
            p->pid = i;
    802053c0:	fe043783          	ld	a5,-32(s0)
    802053c4:	fec42703          	lw	a4,-20(s0)
    802053c8:	c3d8                	sw	a4,4(a5)
            p->state = USED;
    802053ca:	fe043783          	ld	a5,-32(s0)
    802053ce:	4705                	li	a4,1
    802053d0:	c398                	sw	a4,0(a5)
			p->is_user = is_user;
    802053d2:	fe043783          	ld	a5,-32(s0)
    802053d6:	fcc42703          	lw	a4,-52(s0)
    802053da:	0ae7a423          	sw	a4,168(a5)
            p->trapframe = (struct trapframe*)alloc_page();
    802053de:	ffffe097          	auipc	ra,0xffffe
    802053e2:	ee2080e7          	jalr	-286(ra) # 802032c0 <alloc_page>
    802053e6:	872a                	mv	a4,a0
    802053e8:	fe043783          	ld	a5,-32(s0)
    802053ec:	e3f8                	sd	a4,192(a5)
            if(p->trapframe == 0){
    802053ee:	fe043783          	ld	a5,-32(s0)
    802053f2:	63fc                	ld	a5,192(a5)
    802053f4:	eb99                	bnez	a5,8020540a <alloc_proc+0x7e>
                p->state = UNUSED;
    802053f6:	fe043783          	ld	a5,-32(s0)
    802053fa:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    802053fe:	fe043783          	ld	a5,-32(s0)
    80205402:	0007a223          	sw	zero,4(a5)
                return 0;
    80205406:	4781                	li	a5,0
    80205408:	aa39                	j	80205526 <alloc_proc+0x19a>
			if(p->is_user){
    8020540a:	fe043783          	ld	a5,-32(s0)
    8020540e:	0a87a783          	lw	a5,168(a5)
    80205412:	c3b9                	beqz	a5,80205458 <alloc_proc+0xcc>
				p->pagetable = create_pagetable();
    80205414:	ffffd097          	auipc	ra,0xffffd
    80205418:	d00080e7          	jalr	-768(ra) # 80202114 <create_pagetable>
    8020541c:	872a                	mv	a4,a0
    8020541e:	fe043783          	ld	a5,-32(s0)
    80205422:	ffd8                	sd	a4,184(a5)
				if(p->pagetable == 0){
    80205424:	fe043783          	ld	a5,-32(s0)
    80205428:	7fdc                	ld	a5,184(a5)
    8020542a:	ef9d                	bnez	a5,80205468 <alloc_proc+0xdc>
					free_page(p->trapframe);
    8020542c:	fe043783          	ld	a5,-32(s0)
    80205430:	63fc                	ld	a5,192(a5)
    80205432:	853e                	mv	a0,a5
    80205434:	ffffe097          	auipc	ra,0xffffe
    80205438:	ef8080e7          	jalr	-264(ra) # 8020332c <free_page>
					p->trapframe = 0;
    8020543c:	fe043783          	ld	a5,-32(s0)
    80205440:	0c07b023          	sd	zero,192(a5)
					p->state = UNUSED;
    80205444:	fe043783          	ld	a5,-32(s0)
    80205448:	0007a023          	sw	zero,0(a5)
					p->pid = 0;
    8020544c:	fe043783          	ld	a5,-32(s0)
    80205450:	0007a223          	sw	zero,4(a5)
					return 0;
    80205454:	4781                	li	a5,0
    80205456:	a8c1                	j	80205526 <alloc_proc+0x19a>
				p->pagetable = kernel_pagetable;
    80205458:	00022797          	auipc	a5,0x22
    8020545c:	c3878793          	addi	a5,a5,-968 # 80227090 <kernel_pagetable>
    80205460:	6398                	ld	a4,0(a5)
    80205462:	fe043783          	ld	a5,-32(s0)
    80205466:	ffd8                	sd	a4,184(a5)
            void *kstack_mem = alloc_page();
    80205468:	ffffe097          	auipc	ra,0xffffe
    8020546c:	e58080e7          	jalr	-424(ra) # 802032c0 <alloc_page>
    80205470:	fca43c23          	sd	a0,-40(s0)
            if(kstack_mem == 0) {
    80205474:	fd843783          	ld	a5,-40(s0)
    80205478:	e3b9                	bnez	a5,802054be <alloc_proc+0x132>
                free_page(p->trapframe);
    8020547a:	fe043783          	ld	a5,-32(s0)
    8020547e:	63fc                	ld	a5,192(a5)
    80205480:	853e                	mv	a0,a5
    80205482:	ffffe097          	auipc	ra,0xffffe
    80205486:	eaa080e7          	jalr	-342(ra) # 8020332c <free_page>
                free_pagetable(p->pagetable);
    8020548a:	fe043783          	ld	a5,-32(s0)
    8020548e:	7fdc                	ld	a5,184(a5)
    80205490:	853e                	mv	a0,a5
    80205492:	ffffd097          	auipc	ra,0xffffd
    80205496:	066080e7          	jalr	102(ra) # 802024f8 <free_pagetable>
                p->trapframe = 0;
    8020549a:	fe043783          	ld	a5,-32(s0)
    8020549e:	0c07b023          	sd	zero,192(a5)
                p->pagetable = 0;
    802054a2:	fe043783          	ld	a5,-32(s0)
    802054a6:	0a07bc23          	sd	zero,184(a5)
                p->state = UNUSED;
    802054aa:	fe043783          	ld	a5,-32(s0)
    802054ae:	0007a023          	sw	zero,0(a5)
                p->pid = 0;
    802054b2:	fe043783          	ld	a5,-32(s0)
    802054b6:	0007a223          	sw	zero,4(a5)
                return 0;
    802054ba:	4781                	li	a5,0
    802054bc:	a0ad                	j	80205526 <alloc_proc+0x19a>
            p->kstack = (uint64)kstack_mem;
    802054be:	fd843703          	ld	a4,-40(s0)
    802054c2:	fe043783          	ld	a5,-32(s0)
    802054c6:	e798                	sd	a4,8(a5)
            memset(&p->context, 0, sizeof(p->context));
    802054c8:	fe043783          	ld	a5,-32(s0)
    802054cc:	07c1                	addi	a5,a5,16
    802054ce:	07000613          	li	a2,112
    802054d2:	4581                	li	a1,0
    802054d4:	853e                	mv	a0,a5
    802054d6:	ffffd097          	auipc	ra,0xffffd
    802054da:	9e2080e7          	jalr	-1566(ra) # 80201eb8 <memset>
            p->context.ra = (uint64)forkret;
    802054de:	00000717          	auipc	a4,0x0
    802054e2:	c3270713          	addi	a4,a4,-974 # 80205110 <forkret>
    802054e6:	fe043783          	ld	a5,-32(s0)
    802054ea:	eb98                	sd	a4,16(a5)
            p->context.sp = p->kstack + PGSIZE - 16;  // 16字节对齐
    802054ec:	fe043783          	ld	a5,-32(s0)
    802054f0:	6798                	ld	a4,8(a5)
    802054f2:	6785                	lui	a5,0x1
    802054f4:	17c1                	addi	a5,a5,-16 # ff0 <_entry-0x801ff010>
    802054f6:	973e                	add	a4,a4,a5
    802054f8:	fe043783          	ld	a5,-32(s0)
    802054fc:	ef98                	sd	a4,24(a5)
			p->killed = 0; //重置死亡状态
    802054fe:	fe043783          	ld	a5,-32(s0)
    80205502:	0807a023          	sw	zero,128(a5)
            return p;
    80205506:	fe043783          	ld	a5,-32(s0)
    8020550a:	a831                	j	80205526 <alloc_proc+0x19a>
    for(int i = 0;i<PROC;i++) {
    8020550c:	fec42783          	lw	a5,-20(s0)
    80205510:	2785                	addiw	a5,a5,1
    80205512:	fef42623          	sw	a5,-20(s0)
    80205516:	fec42783          	lw	a5,-20(s0)
    8020551a:	0007871b          	sext.w	a4,a5
    8020551e:	47fd                	li	a5,31
    80205520:	e8e7d0e3          	bge	a5,a4,802053a0 <alloc_proc+0x14>
    return 0;
    80205524:	4781                	li	a5,0
}
    80205526:	853e                	mv	a0,a5
    80205528:	70e2                	ld	ra,56(sp)
    8020552a:	7442                	ld	s0,48(sp)
    8020552c:	6121                	addi	sp,sp,64
    8020552e:	8082                	ret

0000000080205530 <free_proc>:
void free_proc(struct proc *p){
    80205530:	1101                	addi	sp,sp,-32
    80205532:	ec06                	sd	ra,24(sp)
    80205534:	e822                	sd	s0,16(sp)
    80205536:	1000                	addi	s0,sp,32
    80205538:	fea43423          	sd	a0,-24(s0)
    if(p->trapframe)
    8020553c:	fe843783          	ld	a5,-24(s0)
    80205540:	63fc                	ld	a5,192(a5)
    80205542:	cb89                	beqz	a5,80205554 <free_proc+0x24>
        free_page(p->trapframe);
    80205544:	fe843783          	ld	a5,-24(s0)
    80205548:	63fc                	ld	a5,192(a5)
    8020554a:	853e                	mv	a0,a5
    8020554c:	ffffe097          	auipc	ra,0xffffe
    80205550:	de0080e7          	jalr	-544(ra) # 8020332c <free_page>
    p->trapframe = 0;
    80205554:	fe843783          	ld	a5,-24(s0)
    80205558:	0c07b023          	sd	zero,192(a5)
    if(p->pagetable && p->pagetable != kernel_pagetable)
    8020555c:	fe843783          	ld	a5,-24(s0)
    80205560:	7fdc                	ld	a5,184(a5)
    80205562:	c39d                	beqz	a5,80205588 <free_proc+0x58>
    80205564:	fe843783          	ld	a5,-24(s0)
    80205568:	7fd8                	ld	a4,184(a5)
    8020556a:	00022797          	auipc	a5,0x22
    8020556e:	b2678793          	addi	a5,a5,-1242 # 80227090 <kernel_pagetable>
    80205572:	639c                	ld	a5,0(a5)
    80205574:	00f70a63          	beq	a4,a5,80205588 <free_proc+0x58>
        free_pagetable(p->pagetable);
    80205578:	fe843783          	ld	a5,-24(s0)
    8020557c:	7fdc                	ld	a5,184(a5)
    8020557e:	853e                	mv	a0,a5
    80205580:	ffffd097          	auipc	ra,0xffffd
    80205584:	f78080e7          	jalr	-136(ra) # 802024f8 <free_pagetable>
    p->pagetable = 0;
    80205588:	fe843783          	ld	a5,-24(s0)
    8020558c:	0a07bc23          	sd	zero,184(a5)
    if(p->kstack)
    80205590:	fe843783          	ld	a5,-24(s0)
    80205594:	679c                	ld	a5,8(a5)
    80205596:	cb89                	beqz	a5,802055a8 <free_proc+0x78>
        free_page((void*)p->kstack);
    80205598:	fe843783          	ld	a5,-24(s0)
    8020559c:	679c                	ld	a5,8(a5)
    8020559e:	853e                	mv	a0,a5
    802055a0:	ffffe097          	auipc	ra,0xffffe
    802055a4:	d8c080e7          	jalr	-628(ra) # 8020332c <free_page>
    p->kstack = 0;
    802055a8:	fe843783          	ld	a5,-24(s0)
    802055ac:	0007b423          	sd	zero,8(a5)
    p->pid = 0;
    802055b0:	fe843783          	ld	a5,-24(s0)
    802055b4:	0007a223          	sw	zero,4(a5)
    p->state = UNUSED;
    802055b8:	fe843783          	ld	a5,-24(s0)
    802055bc:	0007a023          	sw	zero,0(a5)
    p->parent = 0;
    802055c0:	fe843783          	ld	a5,-24(s0)
    802055c4:	0807bc23          	sd	zero,152(a5)
    p->chan = 0;
    802055c8:	fe843783          	ld	a5,-24(s0)
    802055cc:	0a07b023          	sd	zero,160(a5)
    memset(&p->context, 0, sizeof(p->context));
    802055d0:	fe843783          	ld	a5,-24(s0)
    802055d4:	07c1                	addi	a5,a5,16
    802055d6:	07000613          	li	a2,112
    802055da:	4581                	li	a1,0
    802055dc:	853e                	mv	a0,a5
    802055de:	ffffd097          	auipc	ra,0xffffd
    802055e2:	8da080e7          	jalr	-1830(ra) # 80201eb8 <memset>
}
    802055e6:	0001                	nop
    802055e8:	60e2                	ld	ra,24(sp)
    802055ea:	6442                	ld	s0,16(sp)
    802055ec:	6105                	addi	sp,sp,32
    802055ee:	8082                	ret

00000000802055f0 <create_kernel_proc>:
int create_kernel_proc(void (*entry)(void)) {
    802055f0:	7179                	addi	sp,sp,-48
    802055f2:	f406                	sd	ra,40(sp)
    802055f4:	f022                	sd	s0,32(sp)
    802055f6:	1800                	addi	s0,sp,48
    802055f8:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = alloc_proc(0);
    802055fc:	4501                	li	a0,0
    802055fe:	00000097          	auipc	ra,0x0
    80205602:	d8e080e7          	jalr	-626(ra) # 8020538c <alloc_proc>
    80205606:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    8020560a:	fe843783          	ld	a5,-24(s0)
    8020560e:	e399                	bnez	a5,80205614 <create_kernel_proc+0x24>
    80205610:	57fd                	li	a5,-1
    80205612:	a089                	j	80205654 <create_kernel_proc+0x64>
    p->trapframe->epc = (uint64)entry;
    80205614:	fe843783          	ld	a5,-24(s0)
    80205618:	63fc                	ld	a5,192(a5)
    8020561a:	fd843703          	ld	a4,-40(s0)
    8020561e:	ff98                	sd	a4,56(a5)
    p->state = RUNNABLE;
    80205620:	fe843783          	ld	a5,-24(s0)
    80205624:	470d                	li	a4,3
    80205626:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    80205628:	00000097          	auipc	ra,0x0
    8020562c:	988080e7          	jalr	-1656(ra) # 80204fb0 <myproc>
    80205630:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    80205634:	fe043783          	ld	a5,-32(s0)
    80205638:	c799                	beqz	a5,80205646 <create_kernel_proc+0x56>
        p->parent = parent;
    8020563a:	fe843783          	ld	a5,-24(s0)
    8020563e:	fe043703          	ld	a4,-32(s0)
    80205642:	efd8                	sd	a4,152(a5)
    80205644:	a029                	j	8020564e <create_kernel_proc+0x5e>
        p->parent = NULL;
    80205646:	fe843783          	ld	a5,-24(s0)
    8020564a:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    8020564e:	fe843783          	ld	a5,-24(s0)
    80205652:	43dc                	lw	a5,4(a5)
}
    80205654:	853e                	mv	a0,a5
    80205656:	70a2                	ld	ra,40(sp)
    80205658:	7402                	ld	s0,32(sp)
    8020565a:	6145                	addi	sp,sp,48
    8020565c:	8082                	ret

000000008020565e <create_kernel_proc1>:
int create_kernel_proc1(void (*entry)(uint64),uint64 arg){
    8020565e:	7179                	addi	sp,sp,-48
    80205660:	f406                	sd	ra,40(sp)
    80205662:	f022                	sd	s0,32(sp)
    80205664:	1800                	addi	s0,sp,48
    80205666:	fca43c23          	sd	a0,-40(s0)
    8020566a:	fcb43823          	sd	a1,-48(s0)
	struct proc *p = alloc_proc(0);
    8020566e:	4501                	li	a0,0
    80205670:	00000097          	auipc	ra,0x0
    80205674:	d1c080e7          	jalr	-740(ra) # 8020538c <alloc_proc>
    80205678:	fea43423          	sd	a0,-24(s0)
    if (!p) return -1;
    8020567c:	fe843783          	ld	a5,-24(s0)
    80205680:	e399                	bnez	a5,80205686 <create_kernel_proc1+0x28>
    80205682:	57fd                	li	a5,-1
    80205684:	a0b9                	j	802056d2 <create_kernel_proc1+0x74>
    p->trapframe->epc = (uint64)entry;
    80205686:	fe843783          	ld	a5,-24(s0)
    8020568a:	63fc                	ld	a5,192(a5)
    8020568c:	fd843703          	ld	a4,-40(s0)
    80205690:	ff98                	sd	a4,56(a5)
	p->trapframe->a0 = (uint64)arg;
    80205692:	fe843783          	ld	a5,-24(s0)
    80205696:	63fc                	ld	a5,192(a5)
    80205698:	fd043703          	ld	a4,-48(s0)
    8020569c:	f7d8                	sd	a4,168(a5)
    p->state = RUNNABLE;
    8020569e:	fe843783          	ld	a5,-24(s0)
    802056a2:	470d                	li	a4,3
    802056a4:	c398                	sw	a4,0(a5)
    struct proc *parent = myproc();
    802056a6:	00000097          	auipc	ra,0x0
    802056aa:	90a080e7          	jalr	-1782(ra) # 80204fb0 <myproc>
    802056ae:	fea43023          	sd	a0,-32(s0)
    if (parent != 0) {
    802056b2:	fe043783          	ld	a5,-32(s0)
    802056b6:	c799                	beqz	a5,802056c4 <create_kernel_proc1+0x66>
        p->parent = parent;
    802056b8:	fe843783          	ld	a5,-24(s0)
    802056bc:	fe043703          	ld	a4,-32(s0)
    802056c0:	efd8                	sd	a4,152(a5)
    802056c2:	a029                	j	802056cc <create_kernel_proc1+0x6e>
        p->parent = NULL;
    802056c4:	fe843783          	ld	a5,-24(s0)
    802056c8:	0807bc23          	sd	zero,152(a5)
    return p->pid;
    802056cc:	fe843783          	ld	a5,-24(s0)
    802056d0:	43dc                	lw	a5,4(a5)
}
    802056d2:	853e                	mv	a0,a5
    802056d4:	70a2                	ld	ra,40(sp)
    802056d6:	7402                	ld	s0,32(sp)
    802056d8:	6145                	addi	sp,sp,48
    802056da:	8082                	ret

00000000802056dc <create_user_proc>:
int create_user_proc(const void *user_bin, int bin_size) {
    802056dc:	711d                	addi	sp,sp,-96
    802056de:	ec86                	sd	ra,88(sp)
    802056e0:	e8a2                	sd	s0,80(sp)
    802056e2:	1080                	addi	s0,sp,96
    802056e4:	faa43423          	sd	a0,-88(s0)
    802056e8:	87ae                	mv	a5,a1
    802056ea:	faf42223          	sw	a5,-92(s0)
    struct proc *p = alloc_proc(1); // 1 表示用户进程
    802056ee:	4505                	li	a0,1
    802056f0:	00000097          	auipc	ra,0x0
    802056f4:	c9c080e7          	jalr	-868(ra) # 8020538c <alloc_proc>
    802056f8:	fea43023          	sd	a0,-32(s0)
    if (!p) return -1;
    802056fc:	fe043783          	ld	a5,-32(s0)
    80205700:	e399                	bnez	a5,80205706 <create_user_proc+0x2a>
    80205702:	57fd                	li	a5,-1
    80205704:	a439                	j	80205912 <create_user_proc+0x236>
    uint64 user_entry = USER_TEXT_START;
    80205706:	67c1                	lui	a5,0x10
    80205708:	fcf43c23          	sd	a5,-40(s0)
    uint64 user_stack = USER_STACK_SIZE;
    8020570c:	000207b7          	lui	a5,0x20
    80205710:	fcf43823          	sd	a5,-48(s0)
    void *page = alloc_page();
    80205714:	ffffe097          	auipc	ra,0xffffe
    80205718:	bac080e7          	jalr	-1108(ra) # 802032c0 <alloc_page>
    8020571c:	fca43423          	sd	a0,-56(s0)
    if (!page) { free_proc(p); return -1; }
    80205720:	fc843783          	ld	a5,-56(s0)
    80205724:	eb89                	bnez	a5,80205736 <create_user_proc+0x5a>
    80205726:	fe043503          	ld	a0,-32(s0)
    8020572a:	00000097          	auipc	ra,0x0
    8020572e:	e06080e7          	jalr	-506(ra) # 80205530 <free_proc>
    80205732:	57fd                	li	a5,-1
    80205734:	aaf9                	j	80205912 <create_user_proc+0x236>
    map_page(p->pagetable, user_entry, (uint64)page, PTE_R | PTE_W | PTE_X | PTE_U);
    80205736:	fe043783          	ld	a5,-32(s0)
    8020573a:	7fdc                	ld	a5,184(a5)
    8020573c:	fc843703          	ld	a4,-56(s0)
    80205740:	46f9                	li	a3,30
    80205742:	863a                	mv	a2,a4
    80205744:	fd843583          	ld	a1,-40(s0)
    80205748:	853e                	mv	a0,a5
    8020574a:	ffffd097          	auipc	ra,0xffffd
    8020574e:	c3a080e7          	jalr	-966(ra) # 80202384 <map_page>
    memcpy((void*)page, user_bin, bin_size);
    80205752:	fa442783          	lw	a5,-92(s0)
    80205756:	863e                	mv	a2,a5
    80205758:	fa843583          	ld	a1,-88(s0)
    8020575c:	fc843503          	ld	a0,-56(s0)
    80205760:	ffffd097          	auipc	ra,0xffffd
    80205764:	864080e7          	jalr	-1948(ra) # 80201fc4 <memcpy>
    for(int i = 0; i < 2; i++) {
    80205768:	fe042623          	sw	zero,-20(s0)
    8020576c:	a8bd                	j	802057ea <create_user_proc+0x10e>
        void *stack_page = alloc_page();
    8020576e:	ffffe097          	auipc	ra,0xffffe
    80205772:	b52080e7          	jalr	-1198(ra) # 802032c0 <alloc_page>
    80205776:	faa43c23          	sd	a0,-72(s0)
        if (!stack_page) { 
    8020577a:	fb843783          	ld	a5,-72(s0)
    8020577e:	eb89                	bnez	a5,80205790 <create_user_proc+0xb4>
            free_proc(p); 
    80205780:	fe043503          	ld	a0,-32(s0)
    80205784:	00000097          	auipc	ra,0x0
    80205788:	dac080e7          	jalr	-596(ra) # 80205530 <free_proc>
            return -1; 
    8020578c:	57fd                	li	a5,-1
    8020578e:	a251                	j	80205912 <create_user_proc+0x236>
        uint64 stack_va = USER_STACK_SIZE - PGSIZE * (i + 1);
    80205790:	47fd                	li	a5,31
    80205792:	fec42703          	lw	a4,-20(s0)
    80205796:	9f99                	subw	a5,a5,a4
    80205798:	2781                	sext.w	a5,a5
    8020579a:	00c7979b          	slliw	a5,a5,0xc
    8020579e:	2781                	sext.w	a5,a5
    802057a0:	faf43823          	sd	a5,-80(s0)
        if(map_page(p->pagetable, stack_va, (uint64)stack_page, 
    802057a4:	fe043783          	ld	a5,-32(s0)
    802057a8:	7fdc                	ld	a5,184(a5)
    802057aa:	fb843703          	ld	a4,-72(s0)
    802057ae:	46d9                	li	a3,22
    802057b0:	863a                	mv	a2,a4
    802057b2:	fb043583          	ld	a1,-80(s0)
    802057b6:	853e                	mv	a0,a5
    802057b8:	ffffd097          	auipc	ra,0xffffd
    802057bc:	bcc080e7          	jalr	-1076(ra) # 80202384 <map_page>
    802057c0:	87aa                	mv	a5,a0
    802057c2:	cf99                	beqz	a5,802057e0 <create_user_proc+0x104>
            free_page(stack_page);
    802057c4:	fb843503          	ld	a0,-72(s0)
    802057c8:	ffffe097          	auipc	ra,0xffffe
    802057cc:	b64080e7          	jalr	-1180(ra) # 8020332c <free_page>
            free_proc(p);
    802057d0:	fe043503          	ld	a0,-32(s0)
    802057d4:	00000097          	auipc	ra,0x0
    802057d8:	d5c080e7          	jalr	-676(ra) # 80205530 <free_proc>
            return -1;
    802057dc:	57fd                	li	a5,-1
    802057de:	aa15                	j	80205912 <create_user_proc+0x236>
    for(int i = 0; i < 2; i++) {
    802057e0:	fec42783          	lw	a5,-20(s0)
    802057e4:	2785                	addiw	a5,a5,1 # 20001 <_entry-0x801dffff>
    802057e6:	fef42623          	sw	a5,-20(s0)
    802057ea:	fec42783          	lw	a5,-20(s0)
    802057ee:	0007871b          	sext.w	a4,a5
    802057f2:	4785                	li	a5,1
    802057f4:	f6e7dde3          	bge	a5,a4,8020576e <create_user_proc+0x92>
	p->sz = user_stack; // 用户空间从 0x10000 到 0x20000
    802057f8:	fe043783          	ld	a5,-32(s0)
    802057fc:	fd043703          	ld	a4,-48(s0)
    80205800:	fbd8                	sd	a4,176(a5)
    if (map_page(p->pagetable, TRAPFRAME, (uint64)p->trapframe, PTE_R | PTE_W) != 0) {
    80205802:	fe043783          	ld	a5,-32(s0)
    80205806:	7fd8                	ld	a4,184(a5)
    80205808:	fe043783          	ld	a5,-32(s0)
    8020580c:	63fc                	ld	a5,192(a5)
    8020580e:	4699                	li	a3,6
    80205810:	863e                	mv	a2,a5
    80205812:	75f9                	lui	a1,0xffffe
    80205814:	853a                	mv	a0,a4
    80205816:	ffffd097          	auipc	ra,0xffffd
    8020581a:	b6e080e7          	jalr	-1170(ra) # 80202384 <map_page>
    8020581e:	87aa                	mv	a5,a0
    80205820:	cb89                	beqz	a5,80205832 <create_user_proc+0x156>
        free_proc(p);
    80205822:	fe043503          	ld	a0,-32(s0)
    80205826:	00000097          	auipc	ra,0x0
    8020582a:	d0a080e7          	jalr	-758(ra) # 80205530 <free_proc>
        return -1;
    8020582e:	57fd                	li	a5,-1
    80205830:	a0cd                	j	80205912 <create_user_proc+0x236>
	memset(p->trapframe, 0, sizeof(*p->trapframe));
    80205832:	fe043783          	ld	a5,-32(s0)
    80205836:	63fc                	ld	a5,192(a5)
    80205838:	13800613          	li	a2,312
    8020583c:	4581                	li	a1,0
    8020583e:	853e                	mv	a0,a5
    80205840:	ffffc097          	auipc	ra,0xffffc
    80205844:	678080e7          	jalr	1656(ra) # 80201eb8 <memset>
	p->trapframe->epc = user_entry; // 应为 0x10000
    80205848:	fe043783          	ld	a5,-32(s0)
    8020584c:	63fc                	ld	a5,192(a5)
    8020584e:	fd843703          	ld	a4,-40(s0)
    80205852:	ff98                	sd	a4,56(a5)
	p->trapframe->sp = user_stack;  // 应为 0x20000
    80205854:	fe043783          	ld	a5,-32(s0)
    80205858:	63fc                	ld	a5,192(a5)
    8020585a:	fd043703          	ld	a4,-48(s0)
    8020585e:	e7b8                	sd	a4,72(a5)
	p->trapframe->sstatus = (1UL << 5); // 0x20
    80205860:	fe043783          	ld	a5,-32(s0)
    80205864:	63fc                	ld	a5,192(a5)
    80205866:	02000713          	li	a4,32
    8020586a:	fb98                	sd	a4,48(a5)
	p->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable);
    8020586c:	00022797          	auipc	a5,0x22
    80205870:	82478793          	addi	a5,a5,-2012 # 80227090 <kernel_pagetable>
    80205874:	639c                	ld	a5,0(a5)
    80205876:	00c7d693          	srli	a3,a5,0xc
    8020587a:	fe043783          	ld	a5,-32(s0)
    8020587e:	63fc                	ld	a5,192(a5)
    80205880:	577d                	li	a4,-1
    80205882:	177e                	slli	a4,a4,0x3f
    80205884:	8f55                	or	a4,a4,a3
    80205886:	e398                	sd	a4,0(a5)
	p->trapframe->kernel_sp = p->kstack + PGSIZE;   // 内核栈顶
    80205888:	fe043783          	ld	a5,-32(s0)
    8020588c:	6794                	ld	a3,8(a5)
    8020588e:	fe043783          	ld	a5,-32(s0)
    80205892:	63fc                	ld	a5,192(a5)
    80205894:	6705                	lui	a4,0x1
    80205896:	9736                	add	a4,a4,a3
    80205898:	e798                	sd	a4,8(a5)
	p->trapframe->usertrap  = (uint64)usertrap;     // C 层 trap 处理函数
    8020589a:	fe043783          	ld	a5,-32(s0)
    8020589e:	63fc                	ld	a5,192(a5)
    802058a0:	fffff717          	auipc	a4,0xfffff
    802058a4:	fa870713          	addi	a4,a4,-88 # 80204848 <usertrap>
    802058a8:	ef98                	sd	a4,24(a5)
	p->trapframe->kernel_vec = (uint64)kernelvec;
    802058aa:	fe043783          	ld	a5,-32(s0)
    802058ae:	63fc                	ld	a5,192(a5)
    802058b0:	fffff717          	auipc	a4,0xfffff
    802058b4:	3b070713          	addi	a4,a4,944 # 80204c60 <kernelvec>
    802058b8:	f398                	sd	a4,32(a5)
    p->state = RUNNABLE;
    802058ba:	fe043783          	ld	a5,-32(s0)
    802058be:	470d                	li	a4,3
    802058c0:	c398                	sw	a4,0(a5)
	if (map_page(p->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_X | PTE_R) != 0) {
    802058c2:	fe043783          	ld	a5,-32(s0)
    802058c6:	7fd8                	ld	a4,184(a5)
    802058c8:	00021797          	auipc	a5,0x21
    802058cc:	7d078793          	addi	a5,a5,2000 # 80227098 <trampoline_phys_addr>
    802058d0:	639c                	ld	a5,0(a5)
    802058d2:	46a9                	li	a3,10
    802058d4:	863e                	mv	a2,a5
    802058d6:	75fd                	lui	a1,0xfffff
    802058d8:	853a                	mv	a0,a4
    802058da:	ffffd097          	auipc	ra,0xffffd
    802058de:	aaa080e7          	jalr	-1366(ra) # 80202384 <map_page>
    802058e2:	87aa                	mv	a5,a0
    802058e4:	cb89                	beqz	a5,802058f6 <create_user_proc+0x21a>
		free_proc(p);
    802058e6:	fe043503          	ld	a0,-32(s0)
    802058ea:	00000097          	auipc	ra,0x0
    802058ee:	c46080e7          	jalr	-954(ra) # 80205530 <free_proc>
		return -1;
    802058f2:	57fd                	li	a5,-1
    802058f4:	a839                	j	80205912 <create_user_proc+0x236>
    struct proc *parent = myproc();
    802058f6:	fffff097          	auipc	ra,0xfffff
    802058fa:	6ba080e7          	jalr	1722(ra) # 80204fb0 <myproc>
    802058fe:	fca43023          	sd	a0,-64(s0)
    p->parent = parent ? parent : NULL;
    80205902:	fe043783          	ld	a5,-32(s0)
    80205906:	fc043703          	ld	a4,-64(s0)
    8020590a:	efd8                	sd	a4,152(a5)
    return p->pid;
    8020590c:	fe043783          	ld	a5,-32(s0)
    80205910:	43dc                	lw	a5,4(a5)
}
    80205912:	853e                	mv	a0,a5
    80205914:	60e6                	ld	ra,88(sp)
    80205916:	6446                	ld	s0,80(sp)
    80205918:	6125                	addi	sp,sp,96
    8020591a:	8082                	ret

000000008020591c <fork_proc>:
int fork_proc(void) {
    8020591c:	7179                	addi	sp,sp,-48
    8020591e:	f406                	sd	ra,40(sp)
    80205920:	f022                	sd	s0,32(sp)
    80205922:	1800                	addi	s0,sp,48
    struct proc *parent = myproc();
    80205924:	fffff097          	auipc	ra,0xfffff
    80205928:	68c080e7          	jalr	1676(ra) # 80204fb0 <myproc>
    8020592c:	fea43423          	sd	a0,-24(s0)
    struct proc *child = alloc_proc(parent->is_user);
    80205930:	fe843783          	ld	a5,-24(s0)
    80205934:	0a87a783          	lw	a5,168(a5)
    80205938:	853e                	mv	a0,a5
    8020593a:	00000097          	auipc	ra,0x0
    8020593e:	a52080e7          	jalr	-1454(ra) # 8020538c <alloc_proc>
    80205942:	fea43023          	sd	a0,-32(s0)
    if (!child) return -1;
    80205946:	fe043783          	ld	a5,-32(s0)
    8020594a:	e399                	bnez	a5,80205950 <fork_proc+0x34>
    8020594c:	57fd                	li	a5,-1
    8020594e:	a279                	j	80205adc <fork_proc+0x1c0>
    if (uvmcopy(parent->pagetable, child->pagetable, parent->sz) < 0) {
    80205950:	fe843783          	ld	a5,-24(s0)
    80205954:	7fd8                	ld	a4,184(a5)
    80205956:	fe043783          	ld	a5,-32(s0)
    8020595a:	7fd4                	ld	a3,184(a5)
    8020595c:	fe843783          	ld	a5,-24(s0)
    80205960:	7bdc                	ld	a5,176(a5)
    80205962:	863e                	mv	a2,a5
    80205964:	85b6                	mv	a1,a3
    80205966:	853a                	mv	a0,a4
    80205968:	ffffd097          	auipc	ra,0xffffd
    8020596c:	788080e7          	jalr	1928(ra) # 802030f0 <uvmcopy>
    80205970:	87aa                	mv	a5,a0
    80205972:	0007da63          	bgez	a5,80205986 <fork_proc+0x6a>
        free_proc(child);
    80205976:	fe043503          	ld	a0,-32(s0)
    8020597a:	00000097          	auipc	ra,0x0
    8020597e:	bb6080e7          	jalr	-1098(ra) # 80205530 <free_proc>
        return -1;
    80205982:	57fd                	li	a5,-1
    80205984:	aaa1                	j	80205adc <fork_proc+0x1c0>
    child->sz = parent->sz;
    80205986:	fe843783          	ld	a5,-24(s0)
    8020598a:	7bd8                	ld	a4,176(a5)
    8020598c:	fe043783          	ld	a5,-32(s0)
    80205990:	fbd8                	sd	a4,176(a5)
    uint64 tf_pa = (uint64)child->trapframe;
    80205992:	fe043783          	ld	a5,-32(s0)
    80205996:	63fc                	ld	a5,192(a5)
    80205998:	fcf43c23          	sd	a5,-40(s0)
    if ((tf_pa & (PGSIZE - 1)) != 0) {
    8020599c:	fd843703          	ld	a4,-40(s0)
    802059a0:	6785                	lui	a5,0x1
    802059a2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x801ff001>
    802059a4:	8ff9                	and	a5,a5,a4
    802059a6:	c39d                	beqz	a5,802059cc <fork_proc+0xb0>
        printf("[fork] trapframe not aligned: 0x%lx\n", tf_pa);
    802059a8:	fd843583          	ld	a1,-40(s0)
    802059ac:	0001a517          	auipc	a0,0x1a
    802059b0:	6ec50513          	addi	a0,a0,1772 # 80220098 <user_test_table+0x1f0>
    802059b4:	ffffb097          	auipc	ra,0xffffb
    802059b8:	37a080e7          	jalr	890(ra) # 80200d2e <printf>
        free_proc(child);
    802059bc:	fe043503          	ld	a0,-32(s0)
    802059c0:	00000097          	auipc	ra,0x0
    802059c4:	b70080e7          	jalr	-1168(ra) # 80205530 <free_proc>
        return -1;
    802059c8:	57fd                	li	a5,-1
    802059ca:	aa09                	j	80205adc <fork_proc+0x1c0>
    if (map_page(child->pagetable, TRAPFRAME, tf_pa, PTE_R | PTE_W) != 0) {
    802059cc:	fe043783          	ld	a5,-32(s0)
    802059d0:	7fdc                	ld	a5,184(a5)
    802059d2:	4699                	li	a3,6
    802059d4:	fd843603          	ld	a2,-40(s0)
    802059d8:	75f9                	lui	a1,0xffffe
    802059da:	853e                	mv	a0,a5
    802059dc:	ffffd097          	auipc	ra,0xffffd
    802059e0:	9a8080e7          	jalr	-1624(ra) # 80202384 <map_page>
    802059e4:	87aa                	mv	a5,a0
    802059e6:	c38d                	beqz	a5,80205a08 <fork_proc+0xec>
        printf("[fork] map TRAPFRAME failed\n");
    802059e8:	0001a517          	auipc	a0,0x1a
    802059ec:	6d850513          	addi	a0,a0,1752 # 802200c0 <user_test_table+0x218>
    802059f0:	ffffb097          	auipc	ra,0xffffb
    802059f4:	33e080e7          	jalr	830(ra) # 80200d2e <printf>
        free_proc(child);
    802059f8:	fe043503          	ld	a0,-32(s0)
    802059fc:	00000097          	auipc	ra,0x0
    80205a00:	b34080e7          	jalr	-1228(ra) # 80205530 <free_proc>
        return -1;
    80205a04:	57fd                	li	a5,-1
    80205a06:	a8d9                	j	80205adc <fork_proc+0x1c0>
    if (map_page(child->pagetable, TRAMPOLINE, trampoline_phys_addr, PTE_R | PTE_X) != 0) {
    80205a08:	fe043783          	ld	a5,-32(s0)
    80205a0c:	7fd8                	ld	a4,184(a5)
    80205a0e:	00021797          	auipc	a5,0x21
    80205a12:	68a78793          	addi	a5,a5,1674 # 80227098 <trampoline_phys_addr>
    80205a16:	639c                	ld	a5,0(a5)
    80205a18:	46a9                	li	a3,10
    80205a1a:	863e                	mv	a2,a5
    80205a1c:	75fd                	lui	a1,0xfffff
    80205a1e:	853a                	mv	a0,a4
    80205a20:	ffffd097          	auipc	ra,0xffffd
    80205a24:	964080e7          	jalr	-1692(ra) # 80202384 <map_page>
    80205a28:	87aa                	mv	a5,a0
    80205a2a:	c38d                	beqz	a5,80205a4c <fork_proc+0x130>
        printf("[fork] map TRAMPOLINE failed\n");
    80205a2c:	0001a517          	auipc	a0,0x1a
    80205a30:	6b450513          	addi	a0,a0,1716 # 802200e0 <user_test_table+0x238>
    80205a34:	ffffb097          	auipc	ra,0xffffb
    80205a38:	2fa080e7          	jalr	762(ra) # 80200d2e <printf>
        free_proc(child);
    80205a3c:	fe043503          	ld	a0,-32(s0)
    80205a40:	00000097          	auipc	ra,0x0
    80205a44:	af0080e7          	jalr	-1296(ra) # 80205530 <free_proc>
        return -1;
    80205a48:	57fd                	li	a5,-1
    80205a4a:	a849                	j	80205adc <fork_proc+0x1c0>
    *(child->trapframe) = *(parent->trapframe);
    80205a4c:	fe843783          	ld	a5,-24(s0)
    80205a50:	63f8                	ld	a4,192(a5)
    80205a52:	fe043783          	ld	a5,-32(s0)
    80205a56:	63fc                	ld	a5,192(a5)
    80205a58:	86be                	mv	a3,a5
    80205a5a:	13800793          	li	a5,312
    80205a5e:	863e                	mv	a2,a5
    80205a60:	85ba                	mv	a1,a4
    80205a62:	8536                	mv	a0,a3
    80205a64:	ffffc097          	auipc	ra,0xffffc
    80205a68:	560080e7          	jalr	1376(ra) # 80201fc4 <memcpy>
	child->trapframe->kernel_sp = child->kstack + PGSIZE;
    80205a6c:	fe043783          	ld	a5,-32(s0)
    80205a70:	6794                	ld	a3,8(a5)
    80205a72:	fe043783          	ld	a5,-32(s0)
    80205a76:	63fc                	ld	a5,192(a5)
    80205a78:	6705                	lui	a4,0x1
    80205a7a:	9736                	add	a4,a4,a3
    80205a7c:	e798                	sd	a4,8(a5)
	assert(child->trapframe->kernel_satp = MAKE_SATP(kernel_pagetable));
    80205a7e:	00021797          	auipc	a5,0x21
    80205a82:	61278793          	addi	a5,a5,1554 # 80227090 <kernel_pagetable>
    80205a86:	639c                	ld	a5,0(a5)
    80205a88:	00c7d693          	srli	a3,a5,0xc
    80205a8c:	fe043783          	ld	a5,-32(s0)
    80205a90:	63fc                	ld	a5,192(a5)
    80205a92:	577d                	li	a4,-1
    80205a94:	177e                	slli	a4,a4,0x3f
    80205a96:	8f55                	or	a4,a4,a3
    80205a98:	e398                	sd	a4,0(a5)
    80205a9a:	639c                	ld	a5,0(a5)
    80205a9c:	2781                	sext.w	a5,a5
    80205a9e:	853e                	mv	a0,a5
    80205aa0:	fffff097          	auipc	ra,0xfffff
    80205aa4:	49a080e7          	jalr	1178(ra) # 80204f3a <assert>
    child->trapframe->epc += 4;  // 跳过 ecall 指令
    80205aa8:	fe043783          	ld	a5,-32(s0)
    80205aac:	63fc                	ld	a5,192(a5)
    80205aae:	7f98                	ld	a4,56(a5)
    80205ab0:	fe043783          	ld	a5,-32(s0)
    80205ab4:	63fc                	ld	a5,192(a5)
    80205ab6:	0711                	addi	a4,a4,4 # 1004 <_entry-0x801feffc>
    80205ab8:	ff98                	sd	a4,56(a5)
    child->trapframe->a0 = 0;    // 子进程fork返回0
    80205aba:	fe043783          	ld	a5,-32(s0)
    80205abe:	63fc                	ld	a5,192(a5)
    80205ac0:	0a07b423          	sd	zero,168(a5)
    child->state = RUNNABLE;
    80205ac4:	fe043783          	ld	a5,-32(s0)
    80205ac8:	470d                	li	a4,3
    80205aca:	c398                	sw	a4,0(a5)
    child->parent = parent;
    80205acc:	fe043783          	ld	a5,-32(s0)
    80205ad0:	fe843703          	ld	a4,-24(s0)
    80205ad4:	efd8                	sd	a4,152(a5)
    return child->pid;
    80205ad6:	fe043783          	ld	a5,-32(s0)
    80205ada:	43dc                	lw	a5,4(a5)
}
    80205adc:	853e                	mv	a0,a5
    80205ade:	70a2                	ld	ra,40(sp)
    80205ae0:	7402                	ld	s0,32(sp)
    80205ae2:	6145                	addi	sp,sp,48
    80205ae4:	8082                	ret

0000000080205ae6 <schedule>:
void schedule(void) {
    80205ae6:	7179                	addi	sp,sp,-48
    80205ae8:	f406                	sd	ra,40(sp)
    80205aea:	f022                	sd	s0,32(sp)
    80205aec:	1800                	addi	s0,sp,48
  struct cpu *c = mycpu();
    80205aee:	fffff097          	auipc	ra,0xfffff
    80205af2:	4da080e7          	jalr	1242(ra) # 80204fc8 <mycpu>
    80205af6:	fea43023          	sd	a0,-32(s0)
    intr_on();
    80205afa:	fffff097          	auipc	ra,0xfffff
    80205afe:	3d4080e7          	jalr	980(ra) # 80204ece <intr_on>
    for(int i = 0; i < PROC; i++) {
    80205b02:	fe042623          	sw	zero,-20(s0)
    80205b06:	a8bd                	j	80205b84 <schedule+0x9e>
        struct proc *p = proc_table[i];
    80205b08:	00022717          	auipc	a4,0x22
    80205b0c:	96070713          	addi	a4,a4,-1696 # 80227468 <proc_table>
    80205b10:	fec42783          	lw	a5,-20(s0)
    80205b14:	078e                	slli	a5,a5,0x3
    80205b16:	97ba                	add	a5,a5,a4
    80205b18:	639c                	ld	a5,0(a5)
    80205b1a:	fcf43c23          	sd	a5,-40(s0)
      	if(p->state == RUNNABLE) {
    80205b1e:	fd843783          	ld	a5,-40(s0)
    80205b22:	439c                	lw	a5,0(a5)
    80205b24:	873e                	mv	a4,a5
    80205b26:	478d                	li	a5,3
    80205b28:	04f71963          	bne	a4,a5,80205b7a <schedule+0x94>
			p->state = RUNNING;
    80205b2c:	fd843783          	ld	a5,-40(s0)
    80205b30:	4711                	li	a4,4
    80205b32:	c398                	sw	a4,0(a5)
			c->proc = p;
    80205b34:	fe043783          	ld	a5,-32(s0)
    80205b38:	fd843703          	ld	a4,-40(s0)
    80205b3c:	e398                	sd	a4,0(a5)
			current_proc = p;
    80205b3e:	00021797          	auipc	a5,0x21
    80205b42:	56a78793          	addi	a5,a5,1386 # 802270a8 <current_proc>
    80205b46:	fd843703          	ld	a4,-40(s0)
    80205b4a:	e398                	sd	a4,0(a5)
			swtch(&c->context, &p->context);
    80205b4c:	fe043783          	ld	a5,-32(s0)
    80205b50:	00878713          	addi	a4,a5,8
    80205b54:	fd843783          	ld	a5,-40(s0)
    80205b58:	07c1                	addi	a5,a5,16
    80205b5a:	85be                	mv	a1,a5
    80205b5c:	853a                	mv	a0,a4
    80205b5e:	fffff097          	auipc	ra,0xfffff
    80205b62:	2d2080e7          	jalr	722(ra) # 80204e30 <swtch>
			c->proc = 0;
    80205b66:	fe043783          	ld	a5,-32(s0)
    80205b6a:	0007b023          	sd	zero,0(a5)
			current_proc = 0;
    80205b6e:	00021797          	auipc	a5,0x21
    80205b72:	53a78793          	addi	a5,a5,1338 # 802270a8 <current_proc>
    80205b76:	0007b023          	sd	zero,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205b7a:	fec42783          	lw	a5,-20(s0)
    80205b7e:	2785                	addiw	a5,a5,1
    80205b80:	fef42623          	sw	a5,-20(s0)
    80205b84:	fec42783          	lw	a5,-20(s0)
    80205b88:	0007871b          	sext.w	a4,a5
    80205b8c:	47fd                	li	a5,31
    80205b8e:	f6e7dde3          	bge	a5,a4,80205b08 <schedule+0x22>
    intr_on();
    80205b92:	b7a5                	j	80205afa <schedule+0x14>

0000000080205b94 <yield>:
void yield(void) {
    80205b94:	1101                	addi	sp,sp,-32
    80205b96:	ec06                	sd	ra,24(sp)
    80205b98:	e822                	sd	s0,16(sp)
    80205b9a:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80205b9c:	fffff097          	auipc	ra,0xfffff
    80205ba0:	414080e7          	jalr	1044(ra) # 80204fb0 <myproc>
    80205ba4:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205ba8:	fe843783          	ld	a5,-24(s0)
    80205bac:	c3d1                	beqz	a5,80205c30 <yield+0x9c>
    intr_off();
    80205bae:	fffff097          	auipc	ra,0xfffff
    80205bb2:	34a080e7          	jalr	842(ra) # 80204ef8 <intr_off>
    struct cpu *c = mycpu();
    80205bb6:	fffff097          	auipc	ra,0xfffff
    80205bba:	412080e7          	jalr	1042(ra) # 80204fc8 <mycpu>
    80205bbe:	fea43023          	sd	a0,-32(s0)
    p->state = RUNNABLE;
    80205bc2:	fe843783          	ld	a5,-24(s0)
    80205bc6:	470d                	li	a4,3
    80205bc8:	c398                	sw	a4,0(a5)
    current_proc = 0;
    80205bca:	00021797          	auipc	a5,0x21
    80205bce:	4de78793          	addi	a5,a5,1246 # 802270a8 <current_proc>
    80205bd2:	0007b023          	sd	zero,0(a5)
    c->proc = 0;
    80205bd6:	fe043783          	ld	a5,-32(s0)
    80205bda:	0007b023          	sd	zero,0(a5)
    swtch(&p->context, &c->context);
    80205bde:	fe843783          	ld	a5,-24(s0)
    80205be2:	01078713          	addi	a4,a5,16
    80205be6:	fe043783          	ld	a5,-32(s0)
    80205bea:	07a1                	addi	a5,a5,8
    80205bec:	85be                	mv	a1,a5
    80205bee:	853a                	mv	a0,a4
    80205bf0:	fffff097          	auipc	ra,0xfffff
    80205bf4:	240080e7          	jalr	576(ra) # 80204e30 <swtch>
    intr_on();
    80205bf8:	fffff097          	auipc	ra,0xfffff
    80205bfc:	2d6080e7          	jalr	726(ra) # 80204ece <intr_on>
	if (p->killed) {
    80205c00:	fe843783          	ld	a5,-24(s0)
    80205c04:	0807a783          	lw	a5,128(a5)
    80205c08:	c78d                	beqz	a5,80205c32 <yield+0x9e>
        printf("[yield] Process PID %d killed during yield\n", p->pid);
    80205c0a:	fe843783          	ld	a5,-24(s0)
    80205c0e:	43dc                	lw	a5,4(a5)
    80205c10:	85be                	mv	a1,a5
    80205c12:	0001a517          	auipc	a0,0x1a
    80205c16:	4ee50513          	addi	a0,a0,1262 # 80220100 <user_test_table+0x258>
    80205c1a:	ffffb097          	auipc	ra,0xffffb
    80205c1e:	114080e7          	jalr	276(ra) # 80200d2e <printf>
        exit_proc(SYS_kill);
    80205c22:	08100513          	li	a0,129
    80205c26:	00000097          	auipc	ra,0x0
    80205c2a:	17c080e7          	jalr	380(ra) # 80205da2 <exit_proc>
        return;
    80205c2e:	a011                	j	80205c32 <yield+0x9e>
        return;
    80205c30:	0001                	nop
}
    80205c32:	60e2                	ld	ra,24(sp)
    80205c34:	6442                	ld	s0,16(sp)
    80205c36:	6105                	addi	sp,sp,32
    80205c38:	8082                	ret

0000000080205c3a <sleep>:
void sleep(void *chan){
    80205c3a:	7179                	addi	sp,sp,-48
    80205c3c:	f406                	sd	ra,40(sp)
    80205c3e:	f022                	sd	s0,32(sp)
    80205c40:	1800                	addi	s0,sp,48
    80205c42:	fca43c23          	sd	a0,-40(s0)
    struct proc *p = myproc();
    80205c46:	fffff097          	auipc	ra,0xfffff
    80205c4a:	36a080e7          	jalr	874(ra) # 80204fb0 <myproc>
    80205c4e:	fea43423          	sd	a0,-24(s0)
    struct cpu *c = mycpu();
    80205c52:	fffff097          	auipc	ra,0xfffff
    80205c56:	376080e7          	jalr	886(ra) # 80204fc8 <mycpu>
    80205c5a:	fea43023          	sd	a0,-32(s0)
    p->context.ra = ra;
    80205c5e:	8706                	mv	a4,ra
    80205c60:	fe843783          	ld	a5,-24(s0)
    80205c64:	eb98                	sd	a4,16(a5)
    p->chan = chan;
    80205c66:	fe843783          	ld	a5,-24(s0)
    80205c6a:	fd843703          	ld	a4,-40(s0)
    80205c6e:	f3d8                	sd	a4,160(a5)
    p->state = SLEEPING;
    80205c70:	fe843783          	ld	a5,-24(s0)
    80205c74:	4709                	li	a4,2
    80205c76:	c398                	sw	a4,0(a5)
    swtch(&p->context, &c->context);
    80205c78:	fe843783          	ld	a5,-24(s0)
    80205c7c:	01078713          	addi	a4,a5,16
    80205c80:	fe043783          	ld	a5,-32(s0)
    80205c84:	07a1                	addi	a5,a5,8
    80205c86:	85be                	mv	a1,a5
    80205c88:	853a                	mv	a0,a4
    80205c8a:	fffff097          	auipc	ra,0xfffff
    80205c8e:	1a6080e7          	jalr	422(ra) # 80204e30 <swtch>
    p->chan = 0;
    80205c92:	fe843783          	ld	a5,-24(s0)
    80205c96:	0a07b023          	sd	zero,160(a5)
	if(p->killed){
    80205c9a:	fe843783          	ld	a5,-24(s0)
    80205c9e:	0807a783          	lw	a5,128(a5)
    80205ca2:	c39d                	beqz	a5,80205cc8 <sleep+0x8e>
		printf("[sleep] Process PID %d killed when wakeup\n", p->pid);
    80205ca4:	fe843783          	ld	a5,-24(s0)
    80205ca8:	43dc                	lw	a5,4(a5)
    80205caa:	85be                	mv	a1,a5
    80205cac:	0001a517          	auipc	a0,0x1a
    80205cb0:	48450513          	addi	a0,a0,1156 # 80220130 <user_test_table+0x288>
    80205cb4:	ffffb097          	auipc	ra,0xffffb
    80205cb8:	07a080e7          	jalr	122(ra) # 80200d2e <printf>
		exit_proc(SYS_kill);
    80205cbc:	08100513          	li	a0,129
    80205cc0:	00000097          	auipc	ra,0x0
    80205cc4:	0e2080e7          	jalr	226(ra) # 80205da2 <exit_proc>
}
    80205cc8:	0001                	nop
    80205cca:	70a2                	ld	ra,40(sp)
    80205ccc:	7402                	ld	s0,32(sp)
    80205cce:	6145                	addi	sp,sp,48
    80205cd0:	8082                	ret

0000000080205cd2 <wakeup>:
void wakeup(void *chan) {
    80205cd2:	7179                	addi	sp,sp,-48
    80205cd4:	f422                	sd	s0,40(sp)
    80205cd6:	1800                	addi	s0,sp,48
    80205cd8:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < PROC; i++) {
    80205cdc:	fe042623          	sw	zero,-20(s0)
    80205ce0:	a099                	j	80205d26 <wakeup+0x54>
        struct proc *p = proc_table[i];
    80205ce2:	00021717          	auipc	a4,0x21
    80205ce6:	78670713          	addi	a4,a4,1926 # 80227468 <proc_table>
    80205cea:	fec42783          	lw	a5,-20(s0)
    80205cee:	078e                	slli	a5,a5,0x3
    80205cf0:	97ba                	add	a5,a5,a4
    80205cf2:	639c                	ld	a5,0(a5)
    80205cf4:	fef43023          	sd	a5,-32(s0)
        if(p->state == SLEEPING && p->chan == chan) {
    80205cf8:	fe043783          	ld	a5,-32(s0)
    80205cfc:	439c                	lw	a5,0(a5)
    80205cfe:	873e                	mv	a4,a5
    80205d00:	4789                	li	a5,2
    80205d02:	00f71d63          	bne	a4,a5,80205d1c <wakeup+0x4a>
    80205d06:	fe043783          	ld	a5,-32(s0)
    80205d0a:	73dc                	ld	a5,160(a5)
    80205d0c:	fd843703          	ld	a4,-40(s0)
    80205d10:	00f71663          	bne	a4,a5,80205d1c <wakeup+0x4a>
            p->state = RUNNABLE;
    80205d14:	fe043783          	ld	a5,-32(s0)
    80205d18:	470d                	li	a4,3
    80205d1a:	c398                	sw	a4,0(a5)
    for(int i = 0; i < PROC; i++) {
    80205d1c:	fec42783          	lw	a5,-20(s0)
    80205d20:	2785                	addiw	a5,a5,1
    80205d22:	fef42623          	sw	a5,-20(s0)
    80205d26:	fec42783          	lw	a5,-20(s0)
    80205d2a:	0007871b          	sext.w	a4,a5
    80205d2e:	47fd                	li	a5,31
    80205d30:	fae7d9e3          	bge	a5,a4,80205ce2 <wakeup+0x10>
}
    80205d34:	0001                	nop
    80205d36:	0001                	nop
    80205d38:	7422                	ld	s0,40(sp)
    80205d3a:	6145                	addi	sp,sp,48
    80205d3c:	8082                	ret

0000000080205d3e <kill_proc>:
void kill_proc(int pid){
    80205d3e:	7179                	addi	sp,sp,-48
    80205d40:	f422                	sd	s0,40(sp)
    80205d42:	1800                	addi	s0,sp,48
    80205d44:	87aa                	mv	a5,a0
    80205d46:	fcf42e23          	sw	a5,-36(s0)
	for(int i=0;i<PROC;i++){
    80205d4a:	fe042623          	sw	zero,-20(s0)
    80205d4e:	a83d                	j	80205d8c <kill_proc+0x4e>
		struct proc *p = proc_table[i];
    80205d50:	00021717          	auipc	a4,0x21
    80205d54:	71870713          	addi	a4,a4,1816 # 80227468 <proc_table>
    80205d58:	fec42783          	lw	a5,-20(s0)
    80205d5c:	078e                	slli	a5,a5,0x3
    80205d5e:	97ba                	add	a5,a5,a4
    80205d60:	639c                	ld	a5,0(a5)
    80205d62:	fef43023          	sd	a5,-32(s0)
		if(pid == p->pid){
    80205d66:	fe043783          	ld	a5,-32(s0)
    80205d6a:	43d8                	lw	a4,4(a5)
    80205d6c:	fdc42783          	lw	a5,-36(s0)
    80205d70:	2781                	sext.w	a5,a5
    80205d72:	00e79863          	bne	a5,a4,80205d82 <kill_proc+0x44>
			p->killed = 1;
    80205d76:	fe043783          	ld	a5,-32(s0)
    80205d7a:	4705                	li	a4,1
    80205d7c:	08e7a023          	sw	a4,128(a5)
			break;
    80205d80:	a829                	j	80205d9a <kill_proc+0x5c>
	for(int i=0;i<PROC;i++){
    80205d82:	fec42783          	lw	a5,-20(s0)
    80205d86:	2785                	addiw	a5,a5,1
    80205d88:	fef42623          	sw	a5,-20(s0)
    80205d8c:	fec42783          	lw	a5,-20(s0)
    80205d90:	0007871b          	sext.w	a4,a5
    80205d94:	47fd                	li	a5,31
    80205d96:	fae7dde3          	bge	a5,a4,80205d50 <kill_proc+0x12>
	return;
    80205d9a:	0001                	nop
}
    80205d9c:	7422                	ld	s0,40(sp)
    80205d9e:	6145                	addi	sp,sp,48
    80205da0:	8082                	ret

0000000080205da2 <exit_proc>:
void exit_proc(int status) {
    80205da2:	7179                	addi	sp,sp,-48
    80205da4:	f406                	sd	ra,40(sp)
    80205da6:	f022                	sd	s0,32(sp)
    80205da8:	1800                	addi	s0,sp,48
    80205daa:	87aa                	mv	a5,a0
    80205dac:	fcf42e23          	sw	a5,-36(s0)
    struct proc *p = myproc();
    80205db0:	fffff097          	auipc	ra,0xfffff
    80205db4:	200080e7          	jalr	512(ra) # 80204fb0 <myproc>
    80205db8:	fea43423          	sd	a0,-24(s0)
    if (p == 0) {
    80205dbc:	fe843783          	ld	a5,-24(s0)
    80205dc0:	eb89                	bnez	a5,80205dd2 <exit_proc+0x30>
        panic("exit_proc: no current process");
    80205dc2:	0001a517          	auipc	a0,0x1a
    80205dc6:	39e50513          	addi	a0,a0,926 # 80220160 <user_test_table+0x2b8>
    80205dca:	ffffc097          	auipc	ra,0xffffc
    80205dce:	9b0080e7          	jalr	-1616(ra) # 8020177a <panic>
    p->exit_status = status;
    80205dd2:	fe843783          	ld	a5,-24(s0)
    80205dd6:	fdc42703          	lw	a4,-36(s0)
    80205dda:	08e7a223          	sw	a4,132(a5)
    if (!p->parent) {
    80205dde:	fe843783          	ld	a5,-24(s0)
    80205de2:	6fdc                	ld	a5,152(a5)
    80205de4:	e789                	bnez	a5,80205dee <exit_proc+0x4c>
        shutdown();
    80205de6:	fffff097          	auipc	ra,0xfffff
    80205dea:	1a0080e7          	jalr	416(ra) # 80204f86 <shutdown>
    p->state = ZOMBIE;
    80205dee:	fe843783          	ld	a5,-24(s0)
    80205df2:	4715                	li	a4,5
    80205df4:	c398                	sw	a4,0(a5)
    wakeup((void*)p->parent);
    80205df6:	fe843783          	ld	a5,-24(s0)
    80205dfa:	6fdc                	ld	a5,152(a5)
    80205dfc:	853e                	mv	a0,a5
    80205dfe:	00000097          	auipc	ra,0x0
    80205e02:	ed4080e7          	jalr	-300(ra) # 80205cd2 <wakeup>
    current_proc = 0;
    80205e06:	00021797          	auipc	a5,0x21
    80205e0a:	2a278793          	addi	a5,a5,674 # 802270a8 <current_proc>
    80205e0e:	0007b023          	sd	zero,0(a5)
    if (mycpu())
    80205e12:	fffff097          	auipc	ra,0xfffff
    80205e16:	1b6080e7          	jalr	438(ra) # 80204fc8 <mycpu>
    80205e1a:	87aa                	mv	a5,a0
    80205e1c:	cb81                	beqz	a5,80205e2c <exit_proc+0x8a>
        mycpu()->proc = 0;
    80205e1e:	fffff097          	auipc	ra,0xfffff
    80205e22:	1aa080e7          	jalr	426(ra) # 80204fc8 <mycpu>
    80205e26:	87aa                	mv	a5,a0
    80205e28:	0007b023          	sd	zero,0(a5)
    struct cpu *c = mycpu();
    80205e2c:	fffff097          	auipc	ra,0xfffff
    80205e30:	19c080e7          	jalr	412(ra) # 80204fc8 <mycpu>
    80205e34:	fea43023          	sd	a0,-32(s0)
    swtch(&p->context, &c->context);
    80205e38:	fe843783          	ld	a5,-24(s0)
    80205e3c:	01078713          	addi	a4,a5,16
    80205e40:	fe043783          	ld	a5,-32(s0)
    80205e44:	07a1                	addi	a5,a5,8
    80205e46:	85be                	mv	a1,a5
    80205e48:	853a                	mv	a0,a4
    80205e4a:	fffff097          	auipc	ra,0xfffff
    80205e4e:	fe6080e7          	jalr	-26(ra) # 80204e30 <swtch>
    panic("exit_proc should not return after schedule");
    80205e52:	0001a517          	auipc	a0,0x1a
    80205e56:	32e50513          	addi	a0,a0,814 # 80220180 <user_test_table+0x2d8>
    80205e5a:	ffffc097          	auipc	ra,0xffffc
    80205e5e:	920080e7          	jalr	-1760(ra) # 8020177a <panic>
}
    80205e62:	0001                	nop
    80205e64:	70a2                	ld	ra,40(sp)
    80205e66:	7402                	ld	s0,32(sp)
    80205e68:	6145                	addi	sp,sp,48
    80205e6a:	8082                	ret

0000000080205e6c <wait_proc>:
int wait_proc(int *status) {
    80205e6c:	711d                	addi	sp,sp,-96
    80205e6e:	ec86                	sd	ra,88(sp)
    80205e70:	e8a2                	sd	s0,80(sp)
    80205e72:	1080                	addi	s0,sp,96
    80205e74:	faa43423          	sd	a0,-88(s0)
    struct proc *p = myproc();
    80205e78:	fffff097          	auipc	ra,0xfffff
    80205e7c:	138080e7          	jalr	312(ra) # 80204fb0 <myproc>
    80205e80:	fca43023          	sd	a0,-64(s0)
    if (p == 0) {
    80205e84:	fc043783          	ld	a5,-64(s0)
    80205e88:	eb99                	bnez	a5,80205e9e <wait_proc+0x32>
        printf("Warning: wait_proc called with no current process\n");
    80205e8a:	0001a517          	auipc	a0,0x1a
    80205e8e:	32650513          	addi	a0,a0,806 # 802201b0 <user_test_table+0x308>
    80205e92:	ffffb097          	auipc	ra,0xffffb
    80205e96:	e9c080e7          	jalr	-356(ra) # 80200d2e <printf>
        return -1;
    80205e9a:	57fd                	li	a5,-1
    80205e9c:	aa91                	j	80205ff0 <wait_proc+0x184>
        intr_off();
    80205e9e:	fffff097          	auipc	ra,0xfffff
    80205ea2:	05a080e7          	jalr	90(ra) # 80204ef8 <intr_off>
        int found_zombie = 0;
    80205ea6:	fe042623          	sw	zero,-20(s0)
        int zombie_pid = 0;
    80205eaa:	fe042423          	sw	zero,-24(s0)
        int zombie_status = 0;
    80205eae:	fe042223          	sw	zero,-28(s0)
        struct proc *zombie_child = 0;
    80205eb2:	fc043c23          	sd	zero,-40(s0)
        for (int i = 0; i < PROC; i++) {
    80205eb6:	fc042a23          	sw	zero,-44(s0)
    80205eba:	a095                	j	80205f1e <wait_proc+0xb2>
            struct proc *child = proc_table[i];
    80205ebc:	00021717          	auipc	a4,0x21
    80205ec0:	5ac70713          	addi	a4,a4,1452 # 80227468 <proc_table>
    80205ec4:	fd442783          	lw	a5,-44(s0)
    80205ec8:	078e                	slli	a5,a5,0x3
    80205eca:	97ba                	add	a5,a5,a4
    80205ecc:	639c                	ld	a5,0(a5)
    80205ece:	faf43c23          	sd	a5,-72(s0)
            if (child->state == ZOMBIE && child->parent == p) {
    80205ed2:	fb843783          	ld	a5,-72(s0)
    80205ed6:	439c                	lw	a5,0(a5)
    80205ed8:	873e                	mv	a4,a5
    80205eda:	4795                	li	a5,5
    80205edc:	02f71c63          	bne	a4,a5,80205f14 <wait_proc+0xa8>
    80205ee0:	fb843783          	ld	a5,-72(s0)
    80205ee4:	6fdc                	ld	a5,152(a5)
    80205ee6:	fc043703          	ld	a4,-64(s0)
    80205eea:	02f71563          	bne	a4,a5,80205f14 <wait_proc+0xa8>
                found_zombie = 1;
    80205eee:	4785                	li	a5,1
    80205ef0:	fef42623          	sw	a5,-20(s0)
                zombie_pid = child->pid;
    80205ef4:	fb843783          	ld	a5,-72(s0)
    80205ef8:	43dc                	lw	a5,4(a5)
    80205efa:	fef42423          	sw	a5,-24(s0)
                zombie_status = child->exit_status;
    80205efe:	fb843783          	ld	a5,-72(s0)
    80205f02:	0847a783          	lw	a5,132(a5)
    80205f06:	fef42223          	sw	a5,-28(s0)
                zombie_child = child;
    80205f0a:	fb843783          	ld	a5,-72(s0)
    80205f0e:	fcf43c23          	sd	a5,-40(s0)
                break;
    80205f12:	a829                	j	80205f2c <wait_proc+0xc0>
        for (int i = 0; i < PROC; i++) {
    80205f14:	fd442783          	lw	a5,-44(s0)
    80205f18:	2785                	addiw	a5,a5,1
    80205f1a:	fcf42a23          	sw	a5,-44(s0)
    80205f1e:	fd442783          	lw	a5,-44(s0)
    80205f22:	0007871b          	sext.w	a4,a5
    80205f26:	47fd                	li	a5,31
    80205f28:	f8e7dae3          	bge	a5,a4,80205ebc <wait_proc+0x50>
        if (found_zombie) {
    80205f2c:	fec42783          	lw	a5,-20(s0)
    80205f30:	2781                	sext.w	a5,a5
    80205f32:	cb85                	beqz	a5,80205f62 <wait_proc+0xf6>
            if (status)
    80205f34:	fa843783          	ld	a5,-88(s0)
    80205f38:	c791                	beqz	a5,80205f44 <wait_proc+0xd8>
                *status = zombie_status;
    80205f3a:	fa843783          	ld	a5,-88(s0)
    80205f3e:	fe442703          	lw	a4,-28(s0)
    80205f42:	c398                	sw	a4,0(a5)
			intr_on();
    80205f44:	fffff097          	auipc	ra,0xfffff
    80205f48:	f8a080e7          	jalr	-118(ra) # 80204ece <intr_on>
            free_proc(zombie_child);
    80205f4c:	fd843503          	ld	a0,-40(s0)
    80205f50:	fffff097          	auipc	ra,0xfffff
    80205f54:	5e0080e7          	jalr	1504(ra) # 80205530 <free_proc>
            zombie_child = NULL;
    80205f58:	fc043c23          	sd	zero,-40(s0)
            return zombie_pid;
    80205f5c:	fe842783          	lw	a5,-24(s0)
    80205f60:	a841                	j	80205ff0 <wait_proc+0x184>
        }
        
        // 检查是否有任何活跃的子进程（非ZOMBIE状态）
        int havekids = 0;
    80205f62:	fc042823          	sw	zero,-48(s0)
        for (int i = 0; i < PROC; i++) {
    80205f66:	fc042623          	sw	zero,-52(s0)
    80205f6a:	a0b9                	j	80205fb8 <wait_proc+0x14c>
            struct proc *child = proc_table[i];
    80205f6c:	00021717          	auipc	a4,0x21
    80205f70:	4fc70713          	addi	a4,a4,1276 # 80227468 <proc_table>
    80205f74:	fcc42783          	lw	a5,-52(s0)
    80205f78:	078e                	slli	a5,a5,0x3
    80205f7a:	97ba                	add	a5,a5,a4
    80205f7c:	639c                	ld	a5,0(a5)
    80205f7e:	faf43823          	sd	a5,-80(s0)
            if (child->state != UNUSED && child->state != ZOMBIE && child->parent == p) {
    80205f82:	fb043783          	ld	a5,-80(s0)
    80205f86:	439c                	lw	a5,0(a5)
    80205f88:	c39d                	beqz	a5,80205fae <wait_proc+0x142>
    80205f8a:	fb043783          	ld	a5,-80(s0)
    80205f8e:	439c                	lw	a5,0(a5)
    80205f90:	873e                	mv	a4,a5
    80205f92:	4795                	li	a5,5
    80205f94:	00f70d63          	beq	a4,a5,80205fae <wait_proc+0x142>
    80205f98:	fb043783          	ld	a5,-80(s0)
    80205f9c:	6fdc                	ld	a5,152(a5)
    80205f9e:	fc043703          	ld	a4,-64(s0)
    80205fa2:	00f71663          	bne	a4,a5,80205fae <wait_proc+0x142>
                havekids = 1;
    80205fa6:	4785                	li	a5,1
    80205fa8:	fcf42823          	sw	a5,-48(s0)
                break;
    80205fac:	a829                	j	80205fc6 <wait_proc+0x15a>
        for (int i = 0; i < PROC; i++) {
    80205fae:	fcc42783          	lw	a5,-52(s0)
    80205fb2:	2785                	addiw	a5,a5,1
    80205fb4:	fcf42623          	sw	a5,-52(s0)
    80205fb8:	fcc42783          	lw	a5,-52(s0)
    80205fbc:	0007871b          	sext.w	a4,a5
    80205fc0:	47fd                	li	a5,31
    80205fc2:	fae7d5e3          	bge	a5,a4,80205f6c <wait_proc+0x100>
            }
        }
        
        if (!havekids) {
    80205fc6:	fd042783          	lw	a5,-48(s0)
    80205fca:	2781                	sext.w	a5,a5
    80205fcc:	e799                	bnez	a5,80205fda <wait_proc+0x16e>
            intr_on();
    80205fce:	fffff097          	auipc	ra,0xfffff
    80205fd2:	f00080e7          	jalr	-256(ra) # 80204ece <intr_on>
            return -1;
    80205fd6:	57fd                	li	a5,-1
    80205fd8:	a821                	j	80205ff0 <wait_proc+0x184>
        }
        
        // 有活跃子进程但没有僵尸子进程，进入睡眠等待
		intr_on();
    80205fda:	fffff097          	auipc	ra,0xfffff
    80205fde:	ef4080e7          	jalr	-268(ra) # 80204ece <intr_on>
        sleep((void*)p);
    80205fe2:	fc043503          	ld	a0,-64(s0)
    80205fe6:	00000097          	auipc	ra,0x0
    80205fea:	c54080e7          	jalr	-940(ra) # 80205c3a <sleep>
    while (1) {
    80205fee:	bd45                	j	80205e9e <wait_proc+0x32>
    }
}
    80205ff0:	853e                	mv	a0,a5
    80205ff2:	60e6                	ld	ra,88(sp)
    80205ff4:	6446                	ld	s0,80(sp)
    80205ff6:	6125                	addi	sp,sp,96
    80205ff8:	8082                	ret

0000000080205ffa <print_proc_table>:

void print_proc_table(void) {
    80205ffa:	715d                	addi	sp,sp,-80
    80205ffc:	e486                	sd	ra,72(sp)
    80205ffe:	e0a2                	sd	s0,64(sp)
    80206000:	0880                	addi	s0,sp,80
    int count = 0;
    80206002:	fe042623          	sw	zero,-20(s0)
    printf("PID  TYPE STATUS     PPID   FUNC_ADDR      STACK_ADDR    \n");
    80206006:	0001a517          	auipc	a0,0x1a
    8020600a:	1e250513          	addi	a0,a0,482 # 802201e8 <user_test_table+0x340>
    8020600e:	ffffb097          	auipc	ra,0xffffb
    80206012:	d20080e7          	jalr	-736(ra) # 80200d2e <printf>
    printf("----------------------------------------------------------\n");
    80206016:	0001a517          	auipc	a0,0x1a
    8020601a:	21250513          	addi	a0,a0,530 # 80220228 <user_test_table+0x380>
    8020601e:	ffffb097          	auipc	ra,0xffffb
    80206022:	d10080e7          	jalr	-752(ra) # 80200d2e <printf>
    for(int i = 0; i < PROC; i++) {
    80206026:	fe042423          	sw	zero,-24(s0)
    8020602a:	a2a9                	j	80206174 <print_proc_table+0x17a>
        struct proc *p = proc_table[i];
    8020602c:	00021717          	auipc	a4,0x21
    80206030:	43c70713          	addi	a4,a4,1084 # 80227468 <proc_table>
    80206034:	fe842783          	lw	a5,-24(s0)
    80206038:	078e                	slli	a5,a5,0x3
    8020603a:	97ba                	add	a5,a5,a4
    8020603c:	639c                	ld	a5,0(a5)
    8020603e:	fcf43c23          	sd	a5,-40(s0)
        if(p->state != UNUSED) {
    80206042:	fd843783          	ld	a5,-40(s0)
    80206046:	439c                	lw	a5,0(a5)
    80206048:	12078163          	beqz	a5,8020616a <print_proc_table+0x170>
            count++;
    8020604c:	fec42783          	lw	a5,-20(s0)
    80206050:	2785                	addiw	a5,a5,1
    80206052:	fef42623          	sw	a5,-20(s0)
            const char *type = (p->is_user ? "USR" : "SYS");
    80206056:	fd843783          	ld	a5,-40(s0)
    8020605a:	0a87a783          	lw	a5,168(a5)
    8020605e:	c791                	beqz	a5,8020606a <print_proc_table+0x70>
    80206060:	0001a797          	auipc	a5,0x1a
    80206064:	20878793          	addi	a5,a5,520 # 80220268 <user_test_table+0x3c0>
    80206068:	a029                	j	80206072 <print_proc_table+0x78>
    8020606a:	0001a797          	auipc	a5,0x1a
    8020606e:	20678793          	addi	a5,a5,518 # 80220270 <user_test_table+0x3c8>
    80206072:	fcf43823          	sd	a5,-48(s0)
            const char *status;
            switch(p->state) {
    80206076:	fd843783          	ld	a5,-40(s0)
    8020607a:	439c                	lw	a5,0(a5)
    8020607c:	86be                	mv	a3,a5
    8020607e:	4715                	li	a4,5
    80206080:	06d76c63          	bltu	a4,a3,802060f8 <print_proc_table+0xfe>
    80206084:	00279713          	slli	a4,a5,0x2
    80206088:	0001a797          	auipc	a5,0x1a
    8020608c:	27078793          	addi	a5,a5,624 # 802202f8 <user_test_table+0x450>
    80206090:	97ba                	add	a5,a5,a4
    80206092:	439c                	lw	a5,0(a5)
    80206094:	0007871b          	sext.w	a4,a5
    80206098:	0001a797          	auipc	a5,0x1a
    8020609c:	26078793          	addi	a5,a5,608 # 802202f8 <user_test_table+0x450>
    802060a0:	97ba                	add	a5,a5,a4
    802060a2:	8782                	jr	a5
                case UNUSED:   status = "UNUSED"; break;
    802060a4:	0001a797          	auipc	a5,0x1a
    802060a8:	1d478793          	addi	a5,a5,468 # 80220278 <user_test_table+0x3d0>
    802060ac:	fef43023          	sd	a5,-32(s0)
    802060b0:	a899                	j	80206106 <print_proc_table+0x10c>
                case USED:     status = "USED"; break;
    802060b2:	0001a797          	auipc	a5,0x1a
    802060b6:	1ce78793          	addi	a5,a5,462 # 80220280 <user_test_table+0x3d8>
    802060ba:	fef43023          	sd	a5,-32(s0)
    802060be:	a0a1                	j	80206106 <print_proc_table+0x10c>
                case SLEEPING: status = "SLEEP"; break;
    802060c0:	0001a797          	auipc	a5,0x1a
    802060c4:	1c878793          	addi	a5,a5,456 # 80220288 <user_test_table+0x3e0>
    802060c8:	fef43023          	sd	a5,-32(s0)
    802060cc:	a82d                	j	80206106 <print_proc_table+0x10c>
                case RUNNABLE: status = "RUNNABLE"; break;
    802060ce:	0001a797          	auipc	a5,0x1a
    802060d2:	1c278793          	addi	a5,a5,450 # 80220290 <user_test_table+0x3e8>
    802060d6:	fef43023          	sd	a5,-32(s0)
    802060da:	a035                	j	80206106 <print_proc_table+0x10c>
                case RUNNING:  status = "RUNNING"; break;
    802060dc:	0001a797          	auipc	a5,0x1a
    802060e0:	1c478793          	addi	a5,a5,452 # 802202a0 <user_test_table+0x3f8>
    802060e4:	fef43023          	sd	a5,-32(s0)
    802060e8:	a839                	j	80206106 <print_proc_table+0x10c>
                case ZOMBIE:   status = "ZOMBIE"; break;
    802060ea:	0001a797          	auipc	a5,0x1a
    802060ee:	1be78793          	addi	a5,a5,446 # 802202a8 <user_test_table+0x400>
    802060f2:	fef43023          	sd	a5,-32(s0)
    802060f6:	a801                	j	80206106 <print_proc_table+0x10c>
                default:       status = "UNKNOWN"; break;
    802060f8:	0001a797          	auipc	a5,0x1a
    802060fc:	1b878793          	addi	a5,a5,440 # 802202b0 <user_test_table+0x408>
    80206100:	fef43023          	sd	a5,-32(s0)
    80206104:	0001                	nop
            }
            int ppid = p->parent ? p->parent->pid : -1;
    80206106:	fd843783          	ld	a5,-40(s0)
    8020610a:	6fdc                	ld	a5,152(a5)
    8020610c:	c791                	beqz	a5,80206118 <print_proc_table+0x11e>
    8020610e:	fd843783          	ld	a5,-40(s0)
    80206112:	6fdc                	ld	a5,152(a5)
    80206114:	43dc                	lw	a5,4(a5)
    80206116:	a011                	j	8020611a <print_proc_table+0x120>
    80206118:	57fd                	li	a5,-1
    8020611a:	fcf42623          	sw	a5,-52(s0)
            unsigned long func_addr = p->trapframe ? p->trapframe->epc : 0;
    8020611e:	fd843783          	ld	a5,-40(s0)
    80206122:	63fc                	ld	a5,192(a5)
    80206124:	c791                	beqz	a5,80206130 <print_proc_table+0x136>
    80206126:	fd843783          	ld	a5,-40(s0)
    8020612a:	63fc                	ld	a5,192(a5)
    8020612c:	7f9c                	ld	a5,56(a5)
    8020612e:	a011                	j	80206132 <print_proc_table+0x138>
    80206130:	4781                	li	a5,0
    80206132:	fcf43023          	sd	a5,-64(s0)
            unsigned long stack_addr = p->kstack;
    80206136:	fd843783          	ld	a5,-40(s0)
    8020613a:	679c                	ld	a5,8(a5)
    8020613c:	faf43c23          	sd	a5,-72(s0)
            printf("%2d  %3s %8s %4d 0x%012lx 0x%012lx\n",
    80206140:	fd843783          	ld	a5,-40(s0)
    80206144:	43cc                	lw	a1,4(a5)
    80206146:	fcc42703          	lw	a4,-52(s0)
    8020614a:	fb843803          	ld	a6,-72(s0)
    8020614e:	fc043783          	ld	a5,-64(s0)
    80206152:	fe043683          	ld	a3,-32(s0)
    80206156:	fd043603          	ld	a2,-48(s0)
    8020615a:	0001a517          	auipc	a0,0x1a
    8020615e:	15e50513          	addi	a0,a0,350 # 802202b8 <user_test_table+0x410>
    80206162:	ffffb097          	auipc	ra,0xffffb
    80206166:	bcc080e7          	jalr	-1076(ra) # 80200d2e <printf>
    for(int i = 0; i < PROC; i++) {
    8020616a:	fe842783          	lw	a5,-24(s0)
    8020616e:	2785                	addiw	a5,a5,1
    80206170:	fef42423          	sw	a5,-24(s0)
    80206174:	fe842783          	lw	a5,-24(s0)
    80206178:	0007871b          	sext.w	a4,a5
    8020617c:	47fd                	li	a5,31
    8020617e:	eae7d7e3          	bge	a5,a4,8020602c <print_proc_table+0x32>
                p->pid, type, status, ppid, func_addr, stack_addr);
        }
    }
    printf("----------------------------------------------------------\n");
    80206182:	0001a517          	auipc	a0,0x1a
    80206186:	0a650513          	addi	a0,a0,166 # 80220228 <user_test_table+0x380>
    8020618a:	ffffb097          	auipc	ra,0xffffb
    8020618e:	ba4080e7          	jalr	-1116(ra) # 80200d2e <printf>
    printf("%d active processes\n", count);
    80206192:	fec42783          	lw	a5,-20(s0)
    80206196:	85be                	mv	a1,a5
    80206198:	0001a517          	auipc	a0,0x1a
    8020619c:	14850513          	addi	a0,a0,328 # 802202e0 <user_test_table+0x438>
    802061a0:	ffffb097          	auipc	ra,0xffffb
    802061a4:	b8e080e7          	jalr	-1138(ra) # 80200d2e <printf>
}
    802061a8:	0001                	nop
    802061aa:	60a6                	ld	ra,72(sp)
    802061ac:	6406                	ld	s0,64(sp)
    802061ae:	6161                	addi	sp,sp,80
    802061b0:	8082                	ret

00000000802061b2 <get_proc>:

struct proc* get_proc(int pid){
    802061b2:	7179                	addi	sp,sp,-48
    802061b4:	f422                	sd	s0,40(sp)
    802061b6:	1800                	addi	s0,sp,48
    802061b8:	87aa                	mv	a5,a0
    802061ba:	fcf42e23          	sw	a5,-36(s0)
	    // 检查 PID 是否有效
    if (pid < 0 || pid >= PROC) {
    802061be:	fdc42783          	lw	a5,-36(s0)
    802061c2:	2781                	sext.w	a5,a5
    802061c4:	0007c963          	bltz	a5,802061d6 <get_proc+0x24>
    802061c8:	fdc42783          	lw	a5,-36(s0)
    802061cc:	0007871b          	sext.w	a4,a5
    802061d0:	47fd                	li	a5,31
    802061d2:	00e7d463          	bge	a5,a4,802061da <get_proc+0x28>
        return 0;
    802061d6:	4781                	li	a5,0
    802061d8:	a899                	j	8020622e <get_proc+0x7c>
    }
    // 遍历进程表查找匹配的 PID
    for (int i = 0; i < PROC; i++) {
    802061da:	fe042623          	sw	zero,-20(s0)
    802061de:	a081                	j	8020621e <get_proc+0x6c>
        struct proc *p = proc_table[i];
    802061e0:	00021717          	auipc	a4,0x21
    802061e4:	28870713          	addi	a4,a4,648 # 80227468 <proc_table>
    802061e8:	fec42783          	lw	a5,-20(s0)
    802061ec:	078e                	slli	a5,a5,0x3
    802061ee:	97ba                	add	a5,a5,a4
    802061f0:	639c                	ld	a5,0(a5)
    802061f2:	fef43023          	sd	a5,-32(s0)
        if (p->state != UNUSED && p->pid == pid) {
    802061f6:	fe043783          	ld	a5,-32(s0)
    802061fa:	439c                	lw	a5,0(a5)
    802061fc:	cf81                	beqz	a5,80206214 <get_proc+0x62>
    802061fe:	fe043783          	ld	a5,-32(s0)
    80206202:	43d8                	lw	a4,4(a5)
    80206204:	fdc42783          	lw	a5,-36(s0)
    80206208:	2781                	sext.w	a5,a5
    8020620a:	00e79563          	bne	a5,a4,80206214 <get_proc+0x62>
            return p;
    8020620e:	fe043783          	ld	a5,-32(s0)
    80206212:	a831                	j	8020622e <get_proc+0x7c>
    for (int i = 0; i < PROC; i++) {
    80206214:	fec42783          	lw	a5,-20(s0)
    80206218:	2785                	addiw	a5,a5,1
    8020621a:	fef42623          	sw	a5,-20(s0)
    8020621e:	fec42783          	lw	a5,-20(s0)
    80206222:	0007871b          	sext.w	a4,a5
    80206226:	47fd                	li	a5,31
    80206228:	fae7dce3          	bge	a5,a4,802061e0 <get_proc+0x2e>
        }
    }
    return 0;
    8020622c:	4781                	li	a5,0
    8020622e:	853e                	mv	a0,a5
    80206230:	7422                	ld	s0,40(sp)
    80206232:	6145                	addi	sp,sp,48
    80206234:	8082                	ret

0000000080206236 <strlen>:
#include "defs.h"

// 计算字符串长度
int strlen(const char *s) {
    80206236:	7179                	addi	sp,sp,-48
    80206238:	f422                	sd	s0,40(sp)
    8020623a:	1800                	addi	s0,sp,48
    8020623c:	fca43c23          	sd	a0,-40(s0)
    int n;
    for(n = 0; s[n]; n++)
    80206240:	fe042623          	sw	zero,-20(s0)
    80206244:	a031                	j	80206250 <strlen+0x1a>
    80206246:	fec42783          	lw	a5,-20(s0)
    8020624a:	2785                	addiw	a5,a5,1
    8020624c:	fef42623          	sw	a5,-20(s0)
    80206250:	fec42783          	lw	a5,-20(s0)
    80206254:	fd843703          	ld	a4,-40(s0)
    80206258:	97ba                	add	a5,a5,a4
    8020625a:	0007c783          	lbu	a5,0(a5)
    8020625e:	f7e5                	bnez	a5,80206246 <strlen+0x10>
        ;
    return n;
    80206260:	fec42783          	lw	a5,-20(s0)
}
    80206264:	853e                	mv	a0,a5
    80206266:	7422                	ld	s0,40(sp)
    80206268:	6145                	addi	sp,sp,48
    8020626a:	8082                	ret

000000008020626c <strcmp>:

// 字符串比较
int strcmp(const char *p, const char *q) {
    8020626c:	1101                	addi	sp,sp,-32
    8020626e:	ec22                	sd	s0,24(sp)
    80206270:	1000                	addi	s0,sp,32
    80206272:	fea43423          	sd	a0,-24(s0)
    80206276:	feb43023          	sd	a1,-32(s0)
    while(*p && *p == *q)
    8020627a:	a819                	j	80206290 <strcmp+0x24>
        p++, q++;
    8020627c:	fe843783          	ld	a5,-24(s0)
    80206280:	0785                	addi	a5,a5,1
    80206282:	fef43423          	sd	a5,-24(s0)
    80206286:	fe043783          	ld	a5,-32(s0)
    8020628a:	0785                	addi	a5,a5,1
    8020628c:	fef43023          	sd	a5,-32(s0)
    while(*p && *p == *q)
    80206290:	fe843783          	ld	a5,-24(s0)
    80206294:	0007c783          	lbu	a5,0(a5)
    80206298:	cb99                	beqz	a5,802062ae <strcmp+0x42>
    8020629a:	fe843783          	ld	a5,-24(s0)
    8020629e:	0007c703          	lbu	a4,0(a5)
    802062a2:	fe043783          	ld	a5,-32(s0)
    802062a6:	0007c783          	lbu	a5,0(a5)
    802062aa:	fcf709e3          	beq	a4,a5,8020627c <strcmp+0x10>
    return (uchar)*p - (uchar)*q;
    802062ae:	fe843783          	ld	a5,-24(s0)
    802062b2:	0007c783          	lbu	a5,0(a5)
    802062b6:	0007871b          	sext.w	a4,a5
    802062ba:	fe043783          	ld	a5,-32(s0)
    802062be:	0007c783          	lbu	a5,0(a5)
    802062c2:	2781                	sext.w	a5,a5
    802062c4:	40f707bb          	subw	a5,a4,a5
    802062c8:	2781                	sext.w	a5,a5
}
    802062ca:	853e                	mv	a0,a5
    802062cc:	6462                	ld	s0,24(sp)
    802062ce:	6105                	addi	sp,sp,32
    802062d0:	8082                	ret

00000000802062d2 <strcpy>:

// 字符串复制
char* strcpy(char *s, const char *t) {
    802062d2:	7179                	addi	sp,sp,-48
    802062d4:	f422                	sd	s0,40(sp)
    802062d6:	1800                	addi	s0,sp,48
    802062d8:	fca43c23          	sd	a0,-40(s0)
    802062dc:	fcb43823          	sd	a1,-48(s0)
    char *os;
    
    os = s;
    802062e0:	fd843783          	ld	a5,-40(s0)
    802062e4:	fef43423          	sd	a5,-24(s0)
    while((*s++ = *t++) != 0)
    802062e8:	0001                	nop
    802062ea:	fd043703          	ld	a4,-48(s0)
    802062ee:	00170793          	addi	a5,a4,1
    802062f2:	fcf43823          	sd	a5,-48(s0)
    802062f6:	fd843783          	ld	a5,-40(s0)
    802062fa:	00178693          	addi	a3,a5,1
    802062fe:	fcd43c23          	sd	a3,-40(s0)
    80206302:	00074703          	lbu	a4,0(a4)
    80206306:	00e78023          	sb	a4,0(a5)
    8020630a:	0007c783          	lbu	a5,0(a5)
    8020630e:	fff1                	bnez	a5,802062ea <strcpy+0x18>
        ;
    return os;
    80206310:	fe843783          	ld	a5,-24(s0)
}
    80206314:	853e                	mv	a0,a5
    80206316:	7422                	ld	s0,40(sp)
    80206318:	6145                	addi	sp,sp,48
    8020631a:	8082                	ret

000000008020631c <safestrcpy>:

// 安全的字符串复制（指定最大长度）
char* safestrcpy(char *s, const char *t, int n) {
    8020631c:	7139                	addi	sp,sp,-64
    8020631e:	fc22                	sd	s0,56(sp)
    80206320:	0080                	addi	s0,sp,64
    80206322:	fca43c23          	sd	a0,-40(s0)
    80206326:	fcb43823          	sd	a1,-48(s0)
    8020632a:	87b2                	mv	a5,a2
    8020632c:	fcf42623          	sw	a5,-52(s0)
    char *os;
    
    os = s;
    80206330:	fd843783          	ld	a5,-40(s0)
    80206334:	fef43423          	sd	a5,-24(s0)
    if(n <= 0)
    80206338:	fcc42783          	lw	a5,-52(s0)
    8020633c:	2781                	sext.w	a5,a5
    8020633e:	00f04563          	bgtz	a5,80206348 <safestrcpy+0x2c>
        return os;
    80206342:	fe843783          	ld	a5,-24(s0)
    80206346:	a0a9                	j	80206390 <safestrcpy+0x74>
    while(--n > 0 && (*s++ = *t++) != 0)
    80206348:	0001                	nop
    8020634a:	fcc42783          	lw	a5,-52(s0)
    8020634e:	37fd                	addiw	a5,a5,-1
    80206350:	fcf42623          	sw	a5,-52(s0)
    80206354:	fcc42783          	lw	a5,-52(s0)
    80206358:	2781                	sext.w	a5,a5
    8020635a:	02f05563          	blez	a5,80206384 <safestrcpy+0x68>
    8020635e:	fd043703          	ld	a4,-48(s0)
    80206362:	00170793          	addi	a5,a4,1
    80206366:	fcf43823          	sd	a5,-48(s0)
    8020636a:	fd843783          	ld	a5,-40(s0)
    8020636e:	00178693          	addi	a3,a5,1
    80206372:	fcd43c23          	sd	a3,-40(s0)
    80206376:	00074703          	lbu	a4,0(a4)
    8020637a:	00e78023          	sb	a4,0(a5)
    8020637e:	0007c783          	lbu	a5,0(a5)
    80206382:	f7e1                	bnez	a5,8020634a <safestrcpy+0x2e>
        ;
    *s = 0;
    80206384:	fd843783          	ld	a5,-40(s0)
    80206388:	00078023          	sb	zero,0(a5)
    return os;
    8020638c:	fe843783          	ld	a5,-24(s0)
}
    80206390:	853e                	mv	a0,a5
    80206392:	7462                	ld	s0,56(sp)
    80206394:	6121                	addi	sp,sp,64
    80206396:	8082                	ret

0000000080206398 <atoi>:
// 将字符串转换为整数
int atoi(const char *s) {
    80206398:	7179                	addi	sp,sp,-48
    8020639a:	f422                	sd	s0,40(sp)
    8020639c:	1800                	addi	s0,sp,48
    8020639e:	fca43c23          	sd	a0,-40(s0)
    int n = 0;
    802063a2:	fe042623          	sw	zero,-20(s0)
    int sign = 1;  // 正负号
    802063a6:	4785                	li	a5,1
    802063a8:	fef42423          	sw	a5,-24(s0)

    // 跳过空白字符
    while (*s == ' ' || *s == '\t') {
    802063ac:	a031                	j	802063b8 <atoi+0x20>
        s++;
    802063ae:	fd843783          	ld	a5,-40(s0)
    802063b2:	0785                	addi	a5,a5,1
    802063b4:	fcf43c23          	sd	a5,-40(s0)
    while (*s == ' ' || *s == '\t') {
    802063b8:	fd843783          	ld	a5,-40(s0)
    802063bc:	0007c783          	lbu	a5,0(a5)
    802063c0:	873e                	mv	a4,a5
    802063c2:	02000793          	li	a5,32
    802063c6:	fef704e3          	beq	a4,a5,802063ae <atoi+0x16>
    802063ca:	fd843783          	ld	a5,-40(s0)
    802063ce:	0007c783          	lbu	a5,0(a5)
    802063d2:	873e                	mv	a4,a5
    802063d4:	47a5                	li	a5,9
    802063d6:	fcf70ce3          	beq	a4,a5,802063ae <atoi+0x16>
    }

    // 处理符号
    if (*s == '-') {
    802063da:	fd843783          	ld	a5,-40(s0)
    802063de:	0007c783          	lbu	a5,0(a5)
    802063e2:	873e                	mv	a4,a5
    802063e4:	02d00793          	li	a5,45
    802063e8:	00f71b63          	bne	a4,a5,802063fe <atoi+0x66>
        sign = -1;
    802063ec:	57fd                	li	a5,-1
    802063ee:	fef42423          	sw	a5,-24(s0)
        s++;
    802063f2:	fd843783          	ld	a5,-40(s0)
    802063f6:	0785                	addi	a5,a5,1
    802063f8:	fcf43c23          	sd	a5,-40(s0)
    802063fc:	a899                	j	80206452 <atoi+0xba>
    } else if (*s == '+') {
    802063fe:	fd843783          	ld	a5,-40(s0)
    80206402:	0007c783          	lbu	a5,0(a5)
    80206406:	873e                	mv	a4,a5
    80206408:	02b00793          	li	a5,43
    8020640c:	04f71363          	bne	a4,a5,80206452 <atoi+0xba>
        s++;
    80206410:	fd843783          	ld	a5,-40(s0)
    80206414:	0785                	addi	a5,a5,1
    80206416:	fcf43c23          	sd	a5,-40(s0)
    }

    // 转换数字字符
    while (*s >= '0' && *s <= '9') {
    8020641a:	a825                	j	80206452 <atoi+0xba>
        n = n * 10 + (*s - '0');
    8020641c:	fec42783          	lw	a5,-20(s0)
    80206420:	873e                	mv	a4,a5
    80206422:	87ba                	mv	a5,a4
    80206424:	0027979b          	slliw	a5,a5,0x2
    80206428:	9fb9                	addw	a5,a5,a4
    8020642a:	0017979b          	slliw	a5,a5,0x1
    8020642e:	0007871b          	sext.w	a4,a5
    80206432:	fd843783          	ld	a5,-40(s0)
    80206436:	0007c783          	lbu	a5,0(a5)
    8020643a:	2781                	sext.w	a5,a5
    8020643c:	fd07879b          	addiw	a5,a5,-48
    80206440:	2781                	sext.w	a5,a5
    80206442:	9fb9                	addw	a5,a5,a4
    80206444:	fef42623          	sw	a5,-20(s0)
        s++;
    80206448:	fd843783          	ld	a5,-40(s0)
    8020644c:	0785                	addi	a5,a5,1
    8020644e:	fcf43c23          	sd	a5,-40(s0)
    while (*s >= '0' && *s <= '9') {
    80206452:	fd843783          	ld	a5,-40(s0)
    80206456:	0007c783          	lbu	a5,0(a5)
    8020645a:	873e                	mv	a4,a5
    8020645c:	02f00793          	li	a5,47
    80206460:	00e7fb63          	bgeu	a5,a4,80206476 <atoi+0xde>
    80206464:	fd843783          	ld	a5,-40(s0)
    80206468:	0007c783          	lbu	a5,0(a5)
    8020646c:	873e                	mv	a4,a5
    8020646e:	03900793          	li	a5,57
    80206472:	fae7f5e3          	bgeu	a5,a4,8020641c <atoi+0x84>
    }

    return sign * n;
    80206476:	fe842783          	lw	a5,-24(s0)
    8020647a:	873e                	mv	a4,a5
    8020647c:	fec42783          	lw	a5,-20(s0)
    80206480:	02f707bb          	mulw	a5,a4,a5
    80206484:	2781                	sext.w	a5,a5
    80206486:	853e                	mv	a0,a5
    80206488:	7422                	ld	s0,40(sp)
    8020648a:	6145                	addi	sp,sp,48
    8020648c:	8082                	ret

000000008020648e <assert>:
    while (!proc_produced) {
		printf("wait for producer\n");
        sleep(&proc_produced); // 等待生产者
    }
    printf("Consumer: consumed value %d\n", proc_buffer);
    exit_proc(0);
    8020648e:	1101                	addi	sp,sp,-32
    80206490:	ec06                	sd	ra,24(sp)
    80206492:	e822                	sd	s0,16(sp)
    80206494:	1000                	addi	s0,sp,32
    80206496:	87aa                	mv	a5,a0
    80206498:	fef42623          	sw	a5,-20(s0)
}
    8020649c:	fec42783          	lw	a5,-20(s0)
    802064a0:	2781                	sext.w	a5,a5
    802064a2:	e79d                	bnez	a5,802064d0 <assert+0x42>
void test_synchronization(void) {
    802064a4:	1b300613          	li	a2,435
    802064a8:	0001e597          	auipc	a1,0x1e
    802064ac:	f2858593          	addi	a1,a1,-216 # 802243d0 <user_test_table+0x78>
    802064b0:	0001e517          	auipc	a0,0x1e
    802064b4:	f3050513          	addi	a0,a0,-208 # 802243e0 <user_test_table+0x88>
    802064b8:	ffffb097          	auipc	ra,0xffffb
    802064bc:	876080e7          	jalr	-1930(ra) # 80200d2e <printf>
    printf("===== 测试开始: 同步机制测试 =====\n");
    802064c0:	0001e517          	auipc	a0,0x1e
    802064c4:	f4850513          	addi	a0,a0,-184 # 80224408 <user_test_table+0xb0>
    802064c8:	ffffb097          	auipc	ra,0xffffb
    802064cc:	2b2080e7          	jalr	690(ra) # 8020177a <panic>

    // 初始化共享缓冲区
    802064d0:	0001                	nop
    802064d2:	60e2                	ld	ra,24(sp)
    802064d4:	6442                	ld	s0,16(sp)
    802064d6:	6105                	addi	sp,sp,32
    802064d8:	8082                	ret

00000000802064da <get_time>:
uint64 get_time(void) {
    802064da:	1141                	addi	sp,sp,-16
    802064dc:	e406                	sd	ra,8(sp)
    802064de:	e022                	sd	s0,0(sp)
    802064e0:	0800                	addi	s0,sp,16
    return sbi_get_time();
    802064e2:	ffffd097          	auipc	ra,0xffffd
    802064e6:	07e080e7          	jalr	126(ra) # 80203560 <sbi_get_time>
    802064ea:	87aa                	mv	a5,a0
}
    802064ec:	853e                	mv	a0,a5
    802064ee:	60a2                	ld	ra,8(sp)
    802064f0:	6402                	ld	s0,0(sp)
    802064f2:	0141                	addi	sp,sp,16
    802064f4:	8082                	ret

00000000802064f6 <test_timer_interrupt>:
void test_timer_interrupt(void) {
    802064f6:	7179                	addi	sp,sp,-48
    802064f8:	f406                	sd	ra,40(sp)
    802064fa:	f022                	sd	s0,32(sp)
    802064fc:	1800                	addi	s0,sp,48
    printf("Testing timer interrupt...\n");
    802064fe:	0001e517          	auipc	a0,0x1e
    80206502:	f1250513          	addi	a0,a0,-238 # 80224410 <user_test_table+0xb8>
    80206506:	ffffb097          	auipc	ra,0xffffb
    8020650a:	828080e7          	jalr	-2008(ra) # 80200d2e <printf>
    uint64 start_time = get_time();
    8020650e:	00000097          	auipc	ra,0x0
    80206512:	fcc080e7          	jalr	-52(ra) # 802064da <get_time>
    80206516:	fea43023          	sd	a0,-32(s0)
    int interrupt_count = 0;
    8020651a:	fc042a23          	sw	zero,-44(s0)
    int last_count = 0;
    8020651e:	fe042623          	sw	zero,-20(s0)
    interrupt_test_flag = &interrupt_count;
    80206522:	00021797          	auipc	a5,0x21
    80206526:	b9678793          	addi	a5,a5,-1130 # 802270b8 <interrupt_test_flag>
    8020652a:	fd440713          	addi	a4,s0,-44
    8020652e:	e398                	sd	a4,0(a5)
    while (interrupt_count < 5) {
    80206530:	a899                	j	80206586 <test_timer_interrupt+0x90>
        if (last_count != interrupt_count) {
    80206532:	fd442703          	lw	a4,-44(s0)
    80206536:	fec42783          	lw	a5,-20(s0)
    8020653a:	2781                	sext.w	a5,a5
    8020653c:	02e78163          	beq	a5,a4,8020655e <test_timer_interrupt+0x68>
            last_count = interrupt_count;
    80206540:	fd442783          	lw	a5,-44(s0)
    80206544:	fef42623          	sw	a5,-20(s0)
            printf("Received interrupt %d\n", interrupt_count);
    80206548:	fd442783          	lw	a5,-44(s0)
    8020654c:	85be                	mv	a1,a5
    8020654e:	0001e517          	auipc	a0,0x1e
    80206552:	ee250513          	addi	a0,a0,-286 # 80224430 <user_test_table+0xd8>
    80206556:	ffffa097          	auipc	ra,0xffffa
    8020655a:	7d8080e7          	jalr	2008(ra) # 80200d2e <printf>
        for (volatile int i = 0; i < 1000000; i++);
    8020655e:	fc042823          	sw	zero,-48(s0)
    80206562:	a801                	j	80206572 <test_timer_interrupt+0x7c>
    80206564:	fd042783          	lw	a5,-48(s0)
    80206568:	2781                	sext.w	a5,a5
    8020656a:	2785                	addiw	a5,a5,1
    8020656c:	2781                	sext.w	a5,a5
    8020656e:	fcf42823          	sw	a5,-48(s0)
    80206572:	fd042783          	lw	a5,-48(s0)
    80206576:	2781                	sext.w	a5,a5
    80206578:	873e                	mv	a4,a5
    8020657a:	000f47b7          	lui	a5,0xf4
    8020657e:	23f78793          	addi	a5,a5,575 # f423f <_entry-0x8010bdc1>
    80206582:	fee7d1e3          	bge	a5,a4,80206564 <test_timer_interrupt+0x6e>
    while (interrupt_count < 5) {
    80206586:	fd442783          	lw	a5,-44(s0)
    8020658a:	873e                	mv	a4,a5
    8020658c:	4791                	li	a5,4
    8020658e:	fae7d2e3          	bge	a5,a4,80206532 <test_timer_interrupt+0x3c>
    interrupt_test_flag = 0;
    80206592:	00021797          	auipc	a5,0x21
    80206596:	b2678793          	addi	a5,a5,-1242 # 802270b8 <interrupt_test_flag>
    8020659a:	0007b023          	sd	zero,0(a5)
    uint64 end_time = get_time();
    8020659e:	00000097          	auipc	ra,0x0
    802065a2:	f3c080e7          	jalr	-196(ra) # 802064da <get_time>
    802065a6:	fca43c23          	sd	a0,-40(s0)
    printf("Timer test completed: %d interrupts in %lu cycles\n",
    802065aa:	fd442683          	lw	a3,-44(s0)
    802065ae:	fd843703          	ld	a4,-40(s0)
    802065b2:	fe043783          	ld	a5,-32(s0)
    802065b6:	40f707b3          	sub	a5,a4,a5
    802065ba:	863e                	mv	a2,a5
    802065bc:	85b6                	mv	a1,a3
    802065be:	0001e517          	auipc	a0,0x1e
    802065c2:	e8a50513          	addi	a0,a0,-374 # 80224448 <user_test_table+0xf0>
    802065c6:	ffffa097          	auipc	ra,0xffffa
    802065ca:	768080e7          	jalr	1896(ra) # 80200d2e <printf>
}
    802065ce:	0001                	nop
    802065d0:	70a2                	ld	ra,40(sp)
    802065d2:	7402                	ld	s0,32(sp)
    802065d4:	6145                	addi	sp,sp,48
    802065d6:	8082                	ret

00000000802065d8 <test_exception>:
void test_exception(void) {
    802065d8:	711d                	addi	sp,sp,-96
    802065da:	ec86                	sd	ra,88(sp)
    802065dc:	e8a2                	sd	s0,80(sp)
    802065de:	1080                	addi	s0,sp,96
    printf("\n===== 开始全面异常处理测试 =====\n\n");
    802065e0:	0001e517          	auipc	a0,0x1e
    802065e4:	ea050513          	addi	a0,a0,-352 # 80224480 <user_test_table+0x128>
    802065e8:	ffffa097          	auipc	ra,0xffffa
    802065ec:	746080e7          	jalr	1862(ra) # 80200d2e <printf>
    printf("1. 测试非法指令异常...\n");
    802065f0:	0001e517          	auipc	a0,0x1e
    802065f4:	ec050513          	addi	a0,a0,-320 # 802244b0 <user_test_table+0x158>
    802065f8:	ffffa097          	auipc	ra,0xffffa
    802065fc:	736080e7          	jalr	1846(ra) # 80200d2e <printf>
    80206600:	ffffffff          	.word	0xffffffff
    printf("✓ 识别到指令异常并尝试忽略\n\n");
    80206604:	0001e517          	auipc	a0,0x1e
    80206608:	ecc50513          	addi	a0,a0,-308 # 802244d0 <user_test_table+0x178>
    8020660c:	ffffa097          	auipc	ra,0xffffa
    80206610:	722080e7          	jalr	1826(ra) # 80200d2e <printf>
    printf("2. 测试存储页故障异常...\n");
    80206614:	0001e517          	auipc	a0,0x1e
    80206618:	eec50513          	addi	a0,a0,-276 # 80224500 <user_test_table+0x1a8>
    8020661c:	ffffa097          	auipc	ra,0xffffa
    80206620:	712080e7          	jalr	1810(ra) # 80200d2e <printf>
    volatile uint64 *invalid_ptr = 0;
    80206624:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80206628:	47a5                	li	a5,9
    8020662a:	07f2                	slli	a5,a5,0x1c
    8020662c:	fef43023          	sd	a5,-32(s0)
    80206630:	a835                	j	8020666c <test_exception+0x94>
        if (check_is_mapped(addr) == 0) {
    80206632:	fe043503          	ld	a0,-32(s0)
    80206636:	ffffd097          	auipc	ra,0xffffd
    8020663a:	a42080e7          	jalr	-1470(ra) # 80203078 <check_is_mapped>
    8020663e:	87aa                	mv	a5,a0
    80206640:	e385                	bnez	a5,80206660 <test_exception+0x88>
            invalid_ptr = (uint64*)addr;
    80206642:	fe043783          	ld	a5,-32(s0)
    80206646:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    8020664a:	fe043583          	ld	a1,-32(s0)
    8020664e:	0001e517          	auipc	a0,0x1e
    80206652:	eda50513          	addi	a0,a0,-294 # 80224528 <user_test_table+0x1d0>
    80206656:	ffffa097          	auipc	ra,0xffffa
    8020665a:	6d8080e7          	jalr	1752(ra) # 80200d2e <printf>
            break;
    8020665e:	a829                	j	80206678 <test_exception+0xa0>
    for (uint64 addr = 0x90000000; addr < 0x98000000; addr += 0x1000) {
    80206660:	fe043703          	ld	a4,-32(s0)
    80206664:	6785                	lui	a5,0x1
    80206666:	97ba                	add	a5,a5,a4
    80206668:	fef43023          	sd	a5,-32(s0)
    8020666c:	fe043703          	ld	a4,-32(s0)
    80206670:	47cd                	li	a5,19
    80206672:	07ee                	slli	a5,a5,0x1b
    80206674:	faf76fe3          	bltu	a4,a5,80206632 <test_exception+0x5a>
    if (invalid_ptr != 0) {
    80206678:	fe843783          	ld	a5,-24(s0)
    8020667c:	cb95                	beqz	a5,802066b0 <test_exception+0xd8>
        printf("尝试写入未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    8020667e:	fe843783          	ld	a5,-24(s0)
    80206682:	85be                	mv	a1,a5
    80206684:	0001e517          	auipc	a0,0x1e
    80206688:	ec450513          	addi	a0,a0,-316 # 80224548 <user_test_table+0x1f0>
    8020668c:	ffffa097          	auipc	ra,0xffffa
    80206690:	6a2080e7          	jalr	1698(ra) # 80200d2e <printf>
        *invalid_ptr = 42;  // 触发存储页故障
    80206694:	fe843783          	ld	a5,-24(s0)
    80206698:	02a00713          	li	a4,42
    8020669c:	e398                	sd	a4,0(a5)
        printf("✓ 存储页故障异常处理成功\n\n");
    8020669e:	0001e517          	auipc	a0,0x1e
    802066a2:	eda50513          	addi	a0,a0,-294 # 80224578 <user_test_table+0x220>
    802066a6:	ffffa097          	auipc	ra,0xffffa
    802066aa:	688080e7          	jalr	1672(ra) # 80200d2e <printf>
    802066ae:	a809                	j	802066c0 <test_exception+0xe8>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    802066b0:	0001e517          	auipc	a0,0x1e
    802066b4:	ef050513          	addi	a0,a0,-272 # 802245a0 <user_test_table+0x248>
    802066b8:	ffffa097          	auipc	ra,0xffffa
    802066bc:	676080e7          	jalr	1654(ra) # 80200d2e <printf>
    printf("3. 测试加载页故障异常...\n");
    802066c0:	0001e517          	auipc	a0,0x1e
    802066c4:	f1850513          	addi	a0,a0,-232 # 802245d8 <user_test_table+0x280>
    802066c8:	ffffa097          	auipc	ra,0xffffa
    802066cc:	666080e7          	jalr	1638(ra) # 80200d2e <printf>
    invalid_ptr = 0;
    802066d0:	fe043423          	sd	zero,-24(s0)
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    802066d4:	4795                	li	a5,5
    802066d6:	07f6                	slli	a5,a5,0x1d
    802066d8:	fcf43c23          	sd	a5,-40(s0)
    802066dc:	a835                	j	80206718 <test_exception+0x140>
        if (check_is_mapped(addr) == 0) {
    802066de:	fd843503          	ld	a0,-40(s0)
    802066e2:	ffffd097          	auipc	ra,0xffffd
    802066e6:	996080e7          	jalr	-1642(ra) # 80203078 <check_is_mapped>
    802066ea:	87aa                	mv	a5,a0
    802066ec:	e385                	bnez	a5,8020670c <test_exception+0x134>
            invalid_ptr = (uint64*)addr;
    802066ee:	fd843783          	ld	a5,-40(s0)
    802066f2:	fef43423          	sd	a5,-24(s0)
            printf("找到未映射地址: 0x%lx\n", addr);
    802066f6:	fd843583          	ld	a1,-40(s0)
    802066fa:	0001e517          	auipc	a0,0x1e
    802066fe:	e2e50513          	addi	a0,a0,-466 # 80224528 <user_test_table+0x1d0>
    80206702:	ffffa097          	auipc	ra,0xffffa
    80206706:	62c080e7          	jalr	1580(ra) # 80200d2e <printf>
            break;
    8020670a:	a829                	j	80206724 <test_exception+0x14c>
    for (uint64 addr = 0xA0000000; addr < 0xA8000000; addr += 0x1000) {
    8020670c:	fd843703          	ld	a4,-40(s0)
    80206710:	6785                	lui	a5,0x1
    80206712:	97ba                	add	a5,a5,a4
    80206714:	fcf43c23          	sd	a5,-40(s0)
    80206718:	fd843703          	ld	a4,-40(s0)
    8020671c:	47d5                	li	a5,21
    8020671e:	07ee                	slli	a5,a5,0x1b
    80206720:	faf76fe3          	bltu	a4,a5,802066de <test_exception+0x106>
    if (invalid_ptr != 0) {
    80206724:	fe843783          	ld	a5,-24(s0)
    80206728:	c7a9                	beqz	a5,80206772 <test_exception+0x19a>
        printf("尝试读取未映射内存地址 0x%lx\n", (uint64)invalid_ptr);
    8020672a:	fe843783          	ld	a5,-24(s0)
    8020672e:	85be                	mv	a1,a5
    80206730:	0001e517          	auipc	a0,0x1e
    80206734:	ed050513          	addi	a0,a0,-304 # 80224600 <user_test_table+0x2a8>
    80206738:	ffffa097          	auipc	ra,0xffffa
    8020673c:	5f6080e7          	jalr	1526(ra) # 80200d2e <printf>
        volatile uint64 value = *invalid_ptr;  // 触发加载页故障
    80206740:	fe843783          	ld	a5,-24(s0)
    80206744:	639c                	ld	a5,0(a5)
    80206746:	faf43023          	sd	a5,-96(s0)
        printf("读取的值: %lu\n", value);  // 除非故障被处理
    8020674a:	fa043783          	ld	a5,-96(s0)
    8020674e:	85be                	mv	a1,a5
    80206750:	0001e517          	auipc	a0,0x1e
    80206754:	ee050513          	addi	a0,a0,-288 # 80224630 <user_test_table+0x2d8>
    80206758:	ffffa097          	auipc	ra,0xffffa
    8020675c:	5d6080e7          	jalr	1494(ra) # 80200d2e <printf>
        printf("✓ 加载页故障异常处理成功\n\n");
    80206760:	0001e517          	auipc	a0,0x1e
    80206764:	ee850513          	addi	a0,a0,-280 # 80224648 <user_test_table+0x2f0>
    80206768:	ffffa097          	auipc	ra,0xffffa
    8020676c:	5c6080e7          	jalr	1478(ra) # 80200d2e <printf>
    80206770:	a809                	j	80206782 <test_exception+0x1aa>
        printf("警告: 无法找到未映射地址进行测试!\n\n");
    80206772:	0001e517          	auipc	a0,0x1e
    80206776:	e2e50513          	addi	a0,a0,-466 # 802245a0 <user_test_table+0x248>
    8020677a:	ffffa097          	auipc	ra,0xffffa
    8020677e:	5b4080e7          	jalr	1460(ra) # 80200d2e <printf>
    printf("4. 测试存储地址未对齐异常...\n");
    80206782:	0001e517          	auipc	a0,0x1e
    80206786:	eee50513          	addi	a0,a0,-274 # 80224670 <user_test_table+0x318>
    8020678a:	ffffa097          	auipc	ra,0xffffa
    8020678e:	5a4080e7          	jalr	1444(ra) # 80200d2e <printf>
    uint64 aligned_addr = (uint64)alloc_page();
    80206792:	ffffd097          	auipc	ra,0xffffd
    80206796:	b2e080e7          	jalr	-1234(ra) # 802032c0 <alloc_page>
    8020679a:	87aa                	mv	a5,a0
    8020679c:	fcf43823          	sd	a5,-48(s0)
    if (aligned_addr != 0) {
    802067a0:	fd043783          	ld	a5,-48(s0)
    802067a4:	c3a1                	beqz	a5,802067e4 <test_exception+0x20c>
        uint64 misaligned_addr = aligned_addr + 1;  // 制造未对齐地址
    802067a6:	fd043783          	ld	a5,-48(s0)
    802067aa:	0785                	addi	a5,a5,1 # 1001 <_entry-0x801fefff>
    802067ac:	fcf43423          	sd	a5,-56(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    802067b0:	fc843583          	ld	a1,-56(s0)
    802067b4:	0001e517          	auipc	a0,0x1e
    802067b8:	eec50513          	addi	a0,a0,-276 # 802246a0 <user_test_table+0x348>
    802067bc:	ffffa097          	auipc	ra,0xffffa
    802067c0:	572080e7          	jalr	1394(ra) # 80200d2e <printf>
        asm volatile (
    802067c4:	deadc7b7          	lui	a5,0xdeadc
    802067c8:	eef7879b          	addiw	a5,a5,-273 # ffffffffdeadbeef <_bss_end+0xffffffff5e8b47ff>
    802067cc:	fc843703          	ld	a4,-56(s0)
    802067d0:	e31c                	sd	a5,0(a4)
        printf("✓ 存储地址未对齐异常处理成功\n\n");
    802067d2:	0001e517          	auipc	a0,0x1e
    802067d6:	eee50513          	addi	a0,a0,-274 # 802246c0 <user_test_table+0x368>
    802067da:	ffffa097          	auipc	ra,0xffffa
    802067de:	554080e7          	jalr	1364(ra) # 80200d2e <printf>
    802067e2:	a809                	j	802067f4 <test_exception+0x21c>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    802067e4:	0001e517          	auipc	a0,0x1e
    802067e8:	f0c50513          	addi	a0,a0,-244 # 802246f0 <user_test_table+0x398>
    802067ec:	ffffa097          	auipc	ra,0xffffa
    802067f0:	542080e7          	jalr	1346(ra) # 80200d2e <printf>
    printf("5. 测试加载地址未对齐异常...\n");
    802067f4:	0001e517          	auipc	a0,0x1e
    802067f8:	f3c50513          	addi	a0,a0,-196 # 80224730 <user_test_table+0x3d8>
    802067fc:	ffffa097          	auipc	ra,0xffffa
    80206800:	532080e7          	jalr	1330(ra) # 80200d2e <printf>
    if (aligned_addr != 0) {
    80206804:	fd043783          	ld	a5,-48(s0)
    80206808:	cbb1                	beqz	a5,8020685c <test_exception+0x284>
        uint64 misaligned_addr = aligned_addr + 1;
    8020680a:	fd043783          	ld	a5,-48(s0)
    8020680e:	0785                	addi	a5,a5,1
    80206810:	fcf43023          	sd	a5,-64(s0)
        printf("使用未对齐地址: 0x%lx\n", misaligned_addr);
    80206814:	fc043583          	ld	a1,-64(s0)
    80206818:	0001e517          	auipc	a0,0x1e
    8020681c:	e8850513          	addi	a0,a0,-376 # 802246a0 <user_test_table+0x348>
    80206820:	ffffa097          	auipc	ra,0xffffa
    80206824:	50e080e7          	jalr	1294(ra) # 80200d2e <printf>
        uint64 value = 0;
    80206828:	fa043c23          	sd	zero,-72(s0)
        asm volatile (
    8020682c:	fc043783          	ld	a5,-64(s0)
    80206830:	639c                	ld	a5,0(a5)
    80206832:	faf43c23          	sd	a5,-72(s0)
        printf("读取的值: 0x%lx\n", value);
    80206836:	fb843583          	ld	a1,-72(s0)
    8020683a:	0001e517          	auipc	a0,0x1e
    8020683e:	f2650513          	addi	a0,a0,-218 # 80224760 <user_test_table+0x408>
    80206842:	ffffa097          	auipc	ra,0xffffa
    80206846:	4ec080e7          	jalr	1260(ra) # 80200d2e <printf>
        printf("✓ 加载地址未对齐异常处理成功\n\n");
    8020684a:	0001e517          	auipc	a0,0x1e
    8020684e:	f2e50513          	addi	a0,a0,-210 # 80224778 <user_test_table+0x420>
    80206852:	ffffa097          	auipc	ra,0xffffa
    80206856:	4dc080e7          	jalr	1244(ra) # 80200d2e <printf>
    8020685a:	a809                	j	8020686c <test_exception+0x294>
        printf("警告: 无法分配内存进行未对齐访问测试!\n\n");
    8020685c:	0001e517          	auipc	a0,0x1e
    80206860:	e9450513          	addi	a0,a0,-364 # 802246f0 <user_test_table+0x398>
    80206864:	ffffa097          	auipc	ra,0xffffa
    80206868:	4ca080e7          	jalr	1226(ra) # 80200d2e <printf>
	printf("6. 测试断点异常...\n");
    8020686c:	0001e517          	auipc	a0,0x1e
    80206870:	f3c50513          	addi	a0,a0,-196 # 802247a8 <user_test_table+0x450>
    80206874:	ffffa097          	auipc	ra,0xffffa
    80206878:	4ba080e7          	jalr	1210(ra) # 80200d2e <printf>
	asm volatile (
    8020687c:	0001                	nop
    8020687e:	9002                	ebreak
    80206880:	0001                	nop
	printf("✓ 断点异常处理成功\n\n");
    80206882:	0001e517          	auipc	a0,0x1e
    80206886:	f4650513          	addi	a0,a0,-186 # 802247c8 <user_test_table+0x470>
    8020688a:	ffffa097          	auipc	ra,0xffffa
    8020688e:	4a4080e7          	jalr	1188(ra) # 80200d2e <printf>
    printf("7. 测试环境调用异常...\n");
    80206892:	0001e517          	auipc	a0,0x1e
    80206896:	f5650513          	addi	a0,a0,-170 # 802247e8 <user_test_table+0x490>
    8020689a:	ffffa097          	auipc	ra,0xffffa
    8020689e:	494080e7          	jalr	1172(ra) # 80200d2e <printf>
    asm volatile ("ecall");  // 从S模式生成环境调用
    802068a2:	00000073          	ecall
    printf("✓ 环境调用异常处理成功\n\n");
    802068a6:	0001e517          	auipc	a0,0x1e
    802068aa:	f6250513          	addi	a0,a0,-158 # 80224808 <user_test_table+0x4b0>
    802068ae:	ffffa097          	auipc	ra,0xffffa
    802068b2:	480080e7          	jalr	1152(ra) # 80200d2e <printf>
    printf("===== 部分异常处理测试完成 =====\n\n");
    802068b6:	0001e517          	auipc	a0,0x1e
    802068ba:	f7a50513          	addi	a0,a0,-134 # 80224830 <user_test_table+0x4d8>
    802068be:	ffffa097          	auipc	ra,0xffffa
    802068c2:	470080e7          	jalr	1136(ra) # 80200d2e <printf>
	printf("===== 测试不可恢复的除零异常 ====\n");
    802068c6:	0001e517          	auipc	a0,0x1e
    802068ca:	f9a50513          	addi	a0,a0,-102 # 80224860 <user_test_table+0x508>
    802068ce:	ffffa097          	auipc	ra,0xffffa
    802068d2:	460080e7          	jalr	1120(ra) # 80200d2e <printf>
	unsigned int a = 1;
    802068d6:	4785                	li	a5,1
    802068d8:	faf42a23          	sw	a5,-76(s0)
	unsigned int b =0;
    802068dc:	fa042823          	sw	zero,-80(s0)
	unsigned int result = a/b;
    802068e0:	fb442783          	lw	a5,-76(s0)
    802068e4:	873e                	mv	a4,a5
    802068e6:	fb042783          	lw	a5,-80(s0)
    802068ea:	02f757bb          	divuw	a5,a4,a5
    802068ee:	faf42623          	sw	a5,-84(s0)
	printf("这行不应该被打印，如果打印了，那么result = %d\n",result);
    802068f2:	fac42783          	lw	a5,-84(s0)
    802068f6:	85be                	mv	a1,a5
    802068f8:	0001e517          	auipc	a0,0x1e
    802068fc:	f9850513          	addi	a0,a0,-104 # 80224890 <user_test_table+0x538>
    80206900:	ffffa097          	auipc	ra,0xffffa
    80206904:	42e080e7          	jalr	1070(ra) # 80200d2e <printf>
}
    80206908:	0001                	nop
    8020690a:	60e6                	ld	ra,88(sp)
    8020690c:	6446                	ld	s0,80(sp)
    8020690e:	6125                	addi	sp,sp,96
    80206910:	8082                	ret

0000000080206912 <test_interrupt_overhead>:
void test_interrupt_overhead(void) {
    80206912:	715d                	addi	sp,sp,-80
    80206914:	e486                	sd	ra,72(sp)
    80206916:	e0a2                	sd	s0,64(sp)
    80206918:	0880                	addi	s0,sp,80
    printf("\n===== 开始中断开销测试 =====\n");
    8020691a:	0001e517          	auipc	a0,0x1e
    8020691e:	fb650513          	addi	a0,a0,-74 # 802248d0 <user_test_table+0x578>
    80206922:	ffffa097          	auipc	ra,0xffffa
    80206926:	40c080e7          	jalr	1036(ra) # 80200d2e <printf>
    printf("\n----- 测试1: 时钟中断处理时间 -----\n");
    8020692a:	0001e517          	auipc	a0,0x1e
    8020692e:	fce50513          	addi	a0,a0,-50 # 802248f8 <user_test_table+0x5a0>
    80206932:	ffffa097          	auipc	ra,0xffffa
    80206936:	3fc080e7          	jalr	1020(ra) # 80200d2e <printf>
    int count = 0;
    8020693a:	fa042a23          	sw	zero,-76(s0)
    volatile int *test_flag = &count;
    8020693e:	fb440793          	addi	a5,s0,-76
    80206942:	fef43023          	sd	a5,-32(s0)
    start_cycles = get_time();
    80206946:	00000097          	auipc	ra,0x0
    8020694a:	b94080e7          	jalr	-1132(ra) # 802064da <get_time>
    8020694e:	fca43c23          	sd	a0,-40(s0)
    interrupt_test_flag = test_flag;  // 设置全局标志
    80206952:	00020797          	auipc	a5,0x20
    80206956:	76678793          	addi	a5,a5,1894 # 802270b8 <interrupt_test_flag>
    8020695a:	fe043703          	ld	a4,-32(s0)
    8020695e:	e398                	sd	a4,0(a5)
    while(count < 10) {
    80206960:	a011                	j	80206964 <test_interrupt_overhead+0x52>
        asm volatile("nop");
    80206962:	0001                	nop
    while(count < 10) {
    80206964:	fb442783          	lw	a5,-76(s0)
    80206968:	873e                	mv	a4,a5
    8020696a:	47a5                	li	a5,9
    8020696c:	fee7dbe3          	bge	a5,a4,80206962 <test_interrupt_overhead+0x50>
    end_cycles = get_time();
    80206970:	00000097          	auipc	ra,0x0
    80206974:	b6a080e7          	jalr	-1174(ra) # 802064da <get_time>
    80206978:	fca43823          	sd	a0,-48(s0)
    interrupt_test_flag = 0;  // 清除标志
    8020697c:	00020797          	auipc	a5,0x20
    80206980:	73c78793          	addi	a5,a5,1852 # 802270b8 <interrupt_test_flag>
    80206984:	0007b023          	sd	zero,0(a5)
    uint64 total_cycles = end_cycles - start_cycles;
    80206988:	fd043703          	ld	a4,-48(s0)
    8020698c:	fd843783          	ld	a5,-40(s0)
    80206990:	40f707b3          	sub	a5,a4,a5
    80206994:	fcf43423          	sd	a5,-56(s0)
    uint64 avg_cycles1 = total_cycles / 10;
    80206998:	fc843703          	ld	a4,-56(s0)
    8020699c:	47a9                	li	a5,10
    8020699e:	02f757b3          	divu	a5,a4,a5
    802069a2:	fcf43023          	sd	a5,-64(s0)
    printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    802069a6:	fc043583          	ld	a1,-64(s0)
    802069aa:	0001e517          	auipc	a0,0x1e
    802069ae:	f7e50513          	addi	a0,a0,-130 # 80224928 <user_test_table+0x5d0>
    802069b2:	ffffa097          	auipc	ra,0xffffa
    802069b6:	37c080e7          	jalr	892(ra) # 80200d2e <printf>
    printf("\n----- 测试2: 上下文切换成本 -----\n");
    802069ba:	0001e517          	auipc	a0,0x1e
    802069be:	fa650513          	addi	a0,a0,-90 # 80224960 <user_test_table+0x608>
    802069c2:	ffffa097          	auipc	ra,0xffffa
    802069c6:	36c080e7          	jalr	876(ra) # 80200d2e <printf>
    start_cycles = get_time();
    802069ca:	00000097          	auipc	ra,0x0
    802069ce:	b10080e7          	jalr	-1264(ra) # 802064da <get_time>
    802069d2:	fca43c23          	sd	a0,-40(s0)
    for(int i = 0; i < 1000; i++) {
    802069d6:	fe042623          	sw	zero,-20(s0)
    802069da:	a801                	j	802069ea <test_interrupt_overhead+0xd8>
    802069dc:	ffffffff          	.word	0xffffffff
    802069e0:	fec42783          	lw	a5,-20(s0)
    802069e4:	2785                	addiw	a5,a5,1
    802069e6:	fef42623          	sw	a5,-20(s0)
    802069ea:	fec42783          	lw	a5,-20(s0)
    802069ee:	0007871b          	sext.w	a4,a5
    802069f2:	3e700793          	li	a5,999
    802069f6:	fee7d3e3          	bge	a5,a4,802069dc <test_interrupt_overhead+0xca>
    end_cycles = get_time();
    802069fa:	00000097          	auipc	ra,0x0
    802069fe:	ae0080e7          	jalr	-1312(ra) # 802064da <get_time>
    80206a02:	fca43823          	sd	a0,-48(s0)
    uint64 avg_cycles2 = (end_cycles - start_cycles) / 1000;
    80206a06:	fd043703          	ld	a4,-48(s0)
    80206a0a:	fd843783          	ld	a5,-40(s0)
    80206a0e:	8f1d                	sub	a4,a4,a5
    80206a10:	3e800793          	li	a5,1000
    80206a14:	02f757b3          	divu	a5,a4,a5
    80206a18:	faf43c23          	sd	a5,-72(s0)
	printf("平均每次时钟中断处理耗时: %lu cycles\n", avg_cycles1);
    80206a1c:	fc043583          	ld	a1,-64(s0)
    80206a20:	0001e517          	auipc	a0,0x1e
    80206a24:	f0850513          	addi	a0,a0,-248 # 80224928 <user_test_table+0x5d0>
    80206a28:	ffffa097          	auipc	ra,0xffffa
    80206a2c:	306080e7          	jalr	774(ra) # 80200d2e <printf>
    printf("平均每次上下文切换耗时: %lu cycles\n", avg_cycles2);
    80206a30:	fb843583          	ld	a1,-72(s0)
    80206a34:	0001e517          	auipc	a0,0x1e
    80206a38:	f5c50513          	addi	a0,a0,-164 # 80224990 <user_test_table+0x638>
    80206a3c:	ffffa097          	auipc	ra,0xffffa
    80206a40:	2f2080e7          	jalr	754(ra) # 80200d2e <printf>
    printf("\n===== 中断开销测试完成 =====\n");
    80206a44:	0001e517          	auipc	a0,0x1e
    80206a48:	f7c50513          	addi	a0,a0,-132 # 802249c0 <user_test_table+0x668>
    80206a4c:	ffffa097          	auipc	ra,0xffffa
    80206a50:	2e2080e7          	jalr	738(ra) # 80200d2e <printf>
}
    80206a54:	0001                	nop
    80206a56:	60a6                	ld	ra,72(sp)
    80206a58:	6406                	ld	s0,64(sp)
    80206a5a:	6161                	addi	sp,sp,80
    80206a5c:	8082                	ret

0000000080206a5e <simple_task>:
void simple_task(void) {
    80206a5e:	1141                	addi	sp,sp,-16
    80206a60:	e406                	sd	ra,8(sp)
    80206a62:	e022                	sd	s0,0(sp)
    80206a64:	0800                	addi	s0,sp,16
    printf("Simple kernel task running in PID %d\n", myproc()->pid);
    80206a66:	ffffe097          	auipc	ra,0xffffe
    80206a6a:	54a080e7          	jalr	1354(ra) # 80204fb0 <myproc>
    80206a6e:	87aa                	mv	a5,a0
    80206a70:	43dc                	lw	a5,4(a5)
    80206a72:	85be                	mv	a1,a5
    80206a74:	0001e517          	auipc	a0,0x1e
    80206a78:	f7450513          	addi	a0,a0,-140 # 802249e8 <user_test_table+0x690>
    80206a7c:	ffffa097          	auipc	ra,0xffffa
    80206a80:	2b2080e7          	jalr	690(ra) # 80200d2e <printf>
}
    80206a84:	0001                	nop
    80206a86:	60a2                	ld	ra,8(sp)
    80206a88:	6402                	ld	s0,0(sp)
    80206a8a:	0141                	addi	sp,sp,16
    80206a8c:	8082                	ret

0000000080206a8e <test_process_creation>:
void test_process_creation(void) {
    80206a8e:	7119                	addi	sp,sp,-128
    80206a90:	fc86                	sd	ra,120(sp)
    80206a92:	f8a2                	sd	s0,112(sp)
    80206a94:	0100                	addi	s0,sp,128
    printf("===== 测试开始: 进程创建与管理测试 =====\n");
    80206a96:	0001e517          	auipc	a0,0x1e
    80206a9a:	f7a50513          	addi	a0,a0,-134 # 80224a10 <user_test_table+0x6b8>
    80206a9e:	ffffa097          	auipc	ra,0xffffa
    80206aa2:	290080e7          	jalr	656(ra) # 80200d2e <printf>
    printf("\n----- 第一阶段：测试内核进程创建与管理 -----\n");
    80206aa6:	0001e517          	auipc	a0,0x1e
    80206aaa:	fa250513          	addi	a0,a0,-94 # 80224a48 <user_test_table+0x6f0>
    80206aae:	ffffa097          	auipc	ra,0xffffa
    80206ab2:	280080e7          	jalr	640(ra) # 80200d2e <printf>
    int pid = create_kernel_proc(simple_task);
    80206ab6:	00000517          	auipc	a0,0x0
    80206aba:	fa850513          	addi	a0,a0,-88 # 80206a5e <simple_task>
    80206abe:	fffff097          	auipc	ra,0xfffff
    80206ac2:	b32080e7          	jalr	-1230(ra) # 802055f0 <create_kernel_proc>
    80206ac6:	87aa                	mv	a5,a0
    80206ac8:	faf42a23          	sw	a5,-76(s0)
    assert(pid > 0);
    80206acc:	fb442783          	lw	a5,-76(s0)
    80206ad0:	2781                	sext.w	a5,a5
    80206ad2:	00f027b3          	sgtz	a5,a5
    80206ad6:	0ff7f793          	zext.b	a5,a5
    80206ada:	2781                	sext.w	a5,a5
    80206adc:	853e                	mv	a0,a5
    80206ade:	00000097          	auipc	ra,0x0
    80206ae2:	9b0080e7          	jalr	-1616(ra) # 8020648e <assert>
    printf("【测试结果】: 基本内核进程创建成功，PID: %d\n", pid);
    80206ae6:	fb442783          	lw	a5,-76(s0)
    80206aea:	85be                	mv	a1,a5
    80206aec:	0001e517          	auipc	a0,0x1e
    80206af0:	f9c50513          	addi	a0,a0,-100 # 80224a88 <user_test_table+0x730>
    80206af4:	ffffa097          	auipc	ra,0xffffa
    80206af8:	23a080e7          	jalr	570(ra) # 80200d2e <printf>
    printf("\n----- 用内核进程填满进程表 -----\n");
    80206afc:	0001e517          	auipc	a0,0x1e
    80206b00:	fcc50513          	addi	a0,a0,-52 # 80224ac8 <user_test_table+0x770>
    80206b04:	ffffa097          	auipc	ra,0xffffa
    80206b08:	22a080e7          	jalr	554(ra) # 80200d2e <printf>
    int kernel_count = 1; // 已经创建了一个
    80206b0c:	4785                	li	a5,1
    80206b0e:	fef42623          	sw	a5,-20(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206b12:	4785                	li	a5,1
    80206b14:	fef42423          	sw	a5,-24(s0)
    80206b18:	a881                	j	80206b68 <test_process_creation+0xda>
        int new_pid = create_kernel_proc(simple_task);
    80206b1a:	00000517          	auipc	a0,0x0
    80206b1e:	f4450513          	addi	a0,a0,-188 # 80206a5e <simple_task>
    80206b22:	fffff097          	auipc	ra,0xfffff
    80206b26:	ace080e7          	jalr	-1330(ra) # 802055f0 <create_kernel_proc>
    80206b2a:	87aa                	mv	a5,a0
    80206b2c:	faf42823          	sw	a5,-80(s0)
        if (new_pid > 0) {
    80206b30:	fb042783          	lw	a5,-80(s0)
    80206b34:	2781                	sext.w	a5,a5
    80206b36:	00f05863          	blez	a5,80206b46 <test_process_creation+0xb8>
            kernel_count++; 
    80206b3a:	fec42783          	lw	a5,-20(s0)
    80206b3e:	2785                	addiw	a5,a5,1
    80206b40:	fef42623          	sw	a5,-20(s0)
    80206b44:	a829                	j	80206b5e <test_process_creation+0xd0>
            warning("process table was full at %d kernel processes\n", kernel_count);
    80206b46:	fec42783          	lw	a5,-20(s0)
    80206b4a:	85be                	mv	a1,a5
    80206b4c:	0001e517          	auipc	a0,0x1e
    80206b50:	fac50513          	addi	a0,a0,-84 # 80224af8 <user_test_table+0x7a0>
    80206b54:	ffffb097          	auipc	ra,0xffffb
    80206b58:	c5a080e7          	jalr	-934(ra) # 802017ae <warning>
            break;
    80206b5c:	a829                	j	80206b76 <test_process_creation+0xe8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206b5e:	fe842783          	lw	a5,-24(s0)
    80206b62:	2785                	addiw	a5,a5,1
    80206b64:	fef42423          	sw	a5,-24(s0)
    80206b68:	fe842783          	lw	a5,-24(s0)
    80206b6c:	0007871b          	sext.w	a4,a5
    80206b70:	47fd                	li	a5,31
    80206b72:	fae7d4e3          	bge	a5,a4,80206b1a <test_process_creation+0x8c>
    printf("【测试结果】: 成功创建 %d 个内核进程 (最大限制: %d)\n", kernel_count, PROC);
    80206b76:	fec42783          	lw	a5,-20(s0)
    80206b7a:	02000613          	li	a2,32
    80206b7e:	85be                	mv	a1,a5
    80206b80:	0001e517          	auipc	a0,0x1e
    80206b84:	fa850513          	addi	a0,a0,-88 # 80224b28 <user_test_table+0x7d0>
    80206b88:	ffffa097          	auipc	ra,0xffffa
    80206b8c:	1a6080e7          	jalr	422(ra) # 80200d2e <printf>
    print_proc_table();
    80206b90:	fffff097          	auipc	ra,0xfffff
    80206b94:	46a080e7          	jalr	1130(ra) # 80205ffa <print_proc_table>
    printf("\n----- 等待并清理所有内核进程 -----\n");
    80206b98:	0001e517          	auipc	a0,0x1e
    80206b9c:	fd850513          	addi	a0,a0,-40 # 80224b70 <user_test_table+0x818>
    80206ba0:	ffffa097          	auipc	ra,0xffffa
    80206ba4:	18e080e7          	jalr	398(ra) # 80200d2e <printf>
    int kernel_success_count = 0;
    80206ba8:	fe042223          	sw	zero,-28(s0)
    for (int i = 0; i < kernel_count; i++) {
    80206bac:	fe042023          	sw	zero,-32(s0)
    80206bb0:	a0a5                	j	80206c18 <test_process_creation+0x18a>
        int waited_pid = wait_proc(NULL);
    80206bb2:	4501                	li	a0,0
    80206bb4:	fffff097          	auipc	ra,0xfffff
    80206bb8:	2b8080e7          	jalr	696(ra) # 80205e6c <wait_proc>
    80206bbc:	87aa                	mv	a5,a0
    80206bbe:	f8f42623          	sw	a5,-116(s0)
        if (waited_pid > 0) {
    80206bc2:	f8c42783          	lw	a5,-116(s0)
    80206bc6:	2781                	sext.w	a5,a5
    80206bc8:	02f05863          	blez	a5,80206bf8 <test_process_creation+0x16a>
            kernel_success_count++;
    80206bcc:	fe442783          	lw	a5,-28(s0)
    80206bd0:	2785                	addiw	a5,a5,1
    80206bd2:	fef42223          	sw	a5,-28(s0)
            printf("回收内核进程 PID: %d (%d/%d)\n", waited_pid, kernel_success_count, kernel_count);
    80206bd6:	fec42683          	lw	a3,-20(s0)
    80206bda:	fe442703          	lw	a4,-28(s0)
    80206bde:	f8c42783          	lw	a5,-116(s0)
    80206be2:	863a                	mv	a2,a4
    80206be4:	85be                	mv	a1,a5
    80206be6:	0001e517          	auipc	a0,0x1e
    80206bea:	fba50513          	addi	a0,a0,-70 # 80224ba0 <user_test_table+0x848>
    80206bee:	ffffa097          	auipc	ra,0xffffa
    80206bf2:	140080e7          	jalr	320(ra) # 80200d2e <printf>
    80206bf6:	a821                	j	80206c0e <test_process_creation+0x180>
            printf("【错误】: 等待内核进程失败，错误码: %d\n", waited_pid);
    80206bf8:	f8c42783          	lw	a5,-116(s0)
    80206bfc:	85be                	mv	a1,a5
    80206bfe:	0001e517          	auipc	a0,0x1e
    80206c02:	fca50513          	addi	a0,a0,-54 # 80224bc8 <user_test_table+0x870>
    80206c06:	ffffa097          	auipc	ra,0xffffa
    80206c0a:	128080e7          	jalr	296(ra) # 80200d2e <printf>
    for (int i = 0; i < kernel_count; i++) {
    80206c0e:	fe042783          	lw	a5,-32(s0)
    80206c12:	2785                	addiw	a5,a5,1
    80206c14:	fef42023          	sw	a5,-32(s0)
    80206c18:	fe042783          	lw	a5,-32(s0)
    80206c1c:	873e                	mv	a4,a5
    80206c1e:	fec42783          	lw	a5,-20(s0)
    80206c22:	2701                	sext.w	a4,a4
    80206c24:	2781                	sext.w	a5,a5
    80206c26:	f8f746e3          	blt	a4,a5,80206bb2 <test_process_creation+0x124>
    printf("【测试结果】: 回收 %d/%d 个内核进程\n", kernel_success_count, kernel_count);
    80206c2a:	fec42703          	lw	a4,-20(s0)
    80206c2e:	fe442783          	lw	a5,-28(s0)
    80206c32:	863a                	mv	a2,a4
    80206c34:	85be                	mv	a1,a5
    80206c36:	0001e517          	auipc	a0,0x1e
    80206c3a:	fca50513          	addi	a0,a0,-54 # 80224c00 <user_test_table+0x8a8>
    80206c3e:	ffffa097          	auipc	ra,0xffffa
    80206c42:	0f0080e7          	jalr	240(ra) # 80200d2e <printf>
    print_proc_table();
    80206c46:	fffff097          	auipc	ra,0xfffff
    80206c4a:	3b4080e7          	jalr	948(ra) # 80205ffa <print_proc_table>
    printf("\n----- 第二阶段：测试用户进程创建与管理 -----\n");
    80206c4e:	0001e517          	auipc	a0,0x1e
    80206c52:	fea50513          	addi	a0,a0,-22 # 80224c38 <user_test_table+0x8e0>
    80206c56:	ffffa097          	auipc	ra,0xffffa
    80206c5a:	0d8080e7          	jalr	216(ra) # 80200d2e <printf>
    int user_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206c5e:	06c00793          	li	a5,108
    80206c62:	2781                	sext.w	a5,a5
    80206c64:	85be                	mv	a1,a5
    80206c66:	0001d517          	auipc	a0,0x1d
    80206c6a:	fb250513          	addi	a0,a0,-78 # 80223c18 <simple_user_task_bin>
    80206c6e:	fffff097          	auipc	ra,0xfffff
    80206c72:	a6e080e7          	jalr	-1426(ra) # 802056dc <create_user_proc>
    80206c76:	87aa                	mv	a5,a0
    80206c78:	faf42623          	sw	a5,-84(s0)
    if (user_pid > 0) {
    80206c7c:	fac42783          	lw	a5,-84(s0)
    80206c80:	2781                	sext.w	a5,a5
    80206c82:	02f05c63          	blez	a5,80206cba <test_process_creation+0x22c>
        printf("【测试结果】: 基本用户进程创建成功，PID: %d\n", user_pid);
    80206c86:	fac42783          	lw	a5,-84(s0)
    80206c8a:	85be                	mv	a1,a5
    80206c8c:	0001e517          	auipc	a0,0x1e
    80206c90:	fec50513          	addi	a0,a0,-20 # 80224c78 <user_test_table+0x920>
    80206c94:	ffffa097          	auipc	ra,0xffffa
    80206c98:	09a080e7          	jalr	154(ra) # 80200d2e <printf>
    printf("\n----- 用用户进程填满进程表 -----\n");
    80206c9c:	0001e517          	auipc	a0,0x1e
    80206ca0:	04c50513          	addi	a0,a0,76 # 80224ce8 <user_test_table+0x990>
    80206ca4:	ffffa097          	auipc	ra,0xffffa
    80206ca8:	08a080e7          	jalr	138(ra) # 80200d2e <printf>
    int user_count = 1; // 已经创建了一个
    80206cac:	4785                	li	a5,1
    80206cae:	fcf42e23          	sw	a5,-36(s0)
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206cb2:	4785                	li	a5,1
    80206cb4:	fcf42c23          	sw	a5,-40(s0)
    80206cb8:	a841                	j	80206d48 <test_process_creation+0x2ba>
        printf("【错误】: 基本用户进程创建失败\n");
    80206cba:	0001e517          	auipc	a0,0x1e
    80206cbe:	ffe50513          	addi	a0,a0,-2 # 80224cb8 <user_test_table+0x960>
    80206cc2:	ffffa097          	auipc	ra,0xffffa
    80206cc6:	06c080e7          	jalr	108(ra) # 80200d2e <printf>
        return;
    80206cca:	a615                	j	80206fee <test_process_creation+0x560>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206ccc:	06c00793          	li	a5,108
    80206cd0:	2781                	sext.w	a5,a5
    80206cd2:	85be                	mv	a1,a5
    80206cd4:	0001d517          	auipc	a0,0x1d
    80206cd8:	f4450513          	addi	a0,a0,-188 # 80223c18 <simple_user_task_bin>
    80206cdc:	fffff097          	auipc	ra,0xfffff
    80206ce0:	a00080e7          	jalr	-1536(ra) # 802056dc <create_user_proc>
    80206ce4:	87aa                	mv	a5,a0
    80206ce6:	faf42423          	sw	a5,-88(s0)
        if (new_pid > 0) {
    80206cea:	fa842783          	lw	a5,-88(s0)
    80206cee:	2781                	sext.w	a5,a5
    80206cf0:	02f05b63          	blez	a5,80206d26 <test_process_creation+0x298>
            user_count++;
    80206cf4:	fdc42783          	lw	a5,-36(s0)
    80206cf8:	2785                	addiw	a5,a5,1
    80206cfa:	fcf42e23          	sw	a5,-36(s0)
            if (user_count % 5 == 0) { // 每5个进程打印一次进度
    80206cfe:	fdc42783          	lw	a5,-36(s0)
    80206d02:	873e                	mv	a4,a5
    80206d04:	4795                	li	a5,5
    80206d06:	02f767bb          	remw	a5,a4,a5
    80206d0a:	2781                	sext.w	a5,a5
    80206d0c:	eb8d                	bnez	a5,80206d3e <test_process_creation+0x2b0>
                printf("已创建 %d 个用户进程...\n", user_count);
    80206d0e:	fdc42783          	lw	a5,-36(s0)
    80206d12:	85be                	mv	a1,a5
    80206d14:	0001e517          	auipc	a0,0x1e
    80206d18:	00450513          	addi	a0,a0,4 # 80224d18 <user_test_table+0x9c0>
    80206d1c:	ffffa097          	auipc	ra,0xffffa
    80206d20:	012080e7          	jalr	18(ra) # 80200d2e <printf>
    80206d24:	a829                	j	80206d3e <test_process_creation+0x2b0>
            warning("process table was full at %d user processes\n", user_count);
    80206d26:	fdc42783          	lw	a5,-36(s0)
    80206d2a:	85be                	mv	a1,a5
    80206d2c:	0001e517          	auipc	a0,0x1e
    80206d30:	01450513          	addi	a0,a0,20 # 80224d40 <user_test_table+0x9e8>
    80206d34:	ffffb097          	auipc	ra,0xffffb
    80206d38:	a7a080e7          	jalr	-1414(ra) # 802017ae <warning>
            break;
    80206d3c:	a829                	j	80206d56 <test_process_creation+0x2c8>
    for (int i = 1; i < PROC; i++) { // 从1开始，因为已经创建了一个
    80206d3e:	fd842783          	lw	a5,-40(s0)
    80206d42:	2785                	addiw	a5,a5,1
    80206d44:	fcf42c23          	sw	a5,-40(s0)
    80206d48:	fd842783          	lw	a5,-40(s0)
    80206d4c:	0007871b          	sext.w	a4,a5
    80206d50:	47fd                	li	a5,31
    80206d52:	f6e7dde3          	bge	a5,a4,80206ccc <test_process_creation+0x23e>
    printf("【测试结果】: 成功创建 %d 个用户进程 (最大限制: %d)\n", user_count, PROC);
    80206d56:	fdc42783          	lw	a5,-36(s0)
    80206d5a:	02000613          	li	a2,32
    80206d5e:	85be                	mv	a1,a5
    80206d60:	0001e517          	auipc	a0,0x1e
    80206d64:	01050513          	addi	a0,a0,16 # 80224d70 <user_test_table+0xa18>
    80206d68:	ffffa097          	auipc	ra,0xffffa
    80206d6c:	fc6080e7          	jalr	-58(ra) # 80200d2e <printf>
    print_proc_table();
    80206d70:	fffff097          	auipc	ra,0xfffff
    80206d74:	28a080e7          	jalr	650(ra) # 80205ffa <print_proc_table>
    printf("\n----- 等待并清理所有用户进程 -----\n");
    80206d78:	0001e517          	auipc	a0,0x1e
    80206d7c:	04050513          	addi	a0,a0,64 # 80224db8 <user_test_table+0xa60>
    80206d80:	ffffa097          	auipc	ra,0xffffa
    80206d84:	fae080e7          	jalr	-82(ra) # 80200d2e <printf>
    int user_success_count = 0;
    80206d88:	fc042a23          	sw	zero,-44(s0)
    for (int i = 0; i < user_count; i++) {
    80206d8c:	fc042823          	sw	zero,-48(s0)
    80206d90:	a895                	j	80206e04 <test_process_creation+0x376>
        int waited_pid = wait_proc(NULL);
    80206d92:	4501                	li	a0,0
    80206d94:	fffff097          	auipc	ra,0xfffff
    80206d98:	0d8080e7          	jalr	216(ra) # 80205e6c <wait_proc>
    80206d9c:	87aa                	mv	a5,a0
    80206d9e:	f8f42823          	sw	a5,-112(s0)
        if (waited_pid > 0) {
    80206da2:	f9042783          	lw	a5,-112(s0)
    80206da6:	2781                	sext.w	a5,a5
    80206da8:	02f05e63          	blez	a5,80206de4 <test_process_creation+0x356>
            user_success_count++;
    80206dac:	fd442783          	lw	a5,-44(s0)
    80206db0:	2785                	addiw	a5,a5,1
    80206db2:	fcf42a23          	sw	a5,-44(s0)
            if (user_success_count % 5 == 0) { // 每5个进程打印一次进度
    80206db6:	fd442783          	lw	a5,-44(s0)
    80206dba:	873e                	mv	a4,a5
    80206dbc:	4795                	li	a5,5
    80206dbe:	02f767bb          	remw	a5,a4,a5
    80206dc2:	2781                	sext.w	a5,a5
    80206dc4:	eb9d                	bnez	a5,80206dfa <test_process_creation+0x36c>
                printf("已回收 %d/%d 个用户进程...\n", user_success_count, user_count);
    80206dc6:	fdc42703          	lw	a4,-36(s0)
    80206dca:	fd442783          	lw	a5,-44(s0)
    80206dce:	863a                	mv	a2,a4
    80206dd0:	85be                	mv	a1,a5
    80206dd2:	0001e517          	auipc	a0,0x1e
    80206dd6:	01650513          	addi	a0,a0,22 # 80224de8 <user_test_table+0xa90>
    80206dda:	ffffa097          	auipc	ra,0xffffa
    80206dde:	f54080e7          	jalr	-172(ra) # 80200d2e <printf>
    80206de2:	a821                	j	80206dfa <test_process_creation+0x36c>
            printf("【错误】: 等待用户进程失败，错误码: %d\n", waited_pid);
    80206de4:	f9042783          	lw	a5,-112(s0)
    80206de8:	85be                	mv	a1,a5
    80206dea:	0001e517          	auipc	a0,0x1e
    80206dee:	02650513          	addi	a0,a0,38 # 80224e10 <user_test_table+0xab8>
    80206df2:	ffffa097          	auipc	ra,0xffffa
    80206df6:	f3c080e7          	jalr	-196(ra) # 80200d2e <printf>
    for (int i = 0; i < user_count; i++) {
    80206dfa:	fd042783          	lw	a5,-48(s0)
    80206dfe:	2785                	addiw	a5,a5,1
    80206e00:	fcf42823          	sw	a5,-48(s0)
    80206e04:	fd042783          	lw	a5,-48(s0)
    80206e08:	873e                	mv	a4,a5
    80206e0a:	fdc42783          	lw	a5,-36(s0)
    80206e0e:	2701                	sext.w	a4,a4
    80206e10:	2781                	sext.w	a5,a5
    80206e12:	f8f740e3          	blt	a4,a5,80206d92 <test_process_creation+0x304>
    printf("【测试结果】: 回收 %d/%d 个用户进程\n", user_success_count, user_count);
    80206e16:	fdc42703          	lw	a4,-36(s0)
    80206e1a:	fd442783          	lw	a5,-44(s0)
    80206e1e:	863a                	mv	a2,a4
    80206e20:	85be                	mv	a1,a5
    80206e22:	0001e517          	auipc	a0,0x1e
    80206e26:	02650513          	addi	a0,a0,38 # 80224e48 <user_test_table+0xaf0>
    80206e2a:	ffffa097          	auipc	ra,0xffffa
    80206e2e:	f04080e7          	jalr	-252(ra) # 80200d2e <printf>
    print_proc_table();
    80206e32:	fffff097          	auipc	ra,0xfffff
    80206e36:	1c8080e7          	jalr	456(ra) # 80205ffa <print_proc_table>
    printf("\n----- 第三阶段：混合进程测试 -----\n");
    80206e3a:	0001e517          	auipc	a0,0x1e
    80206e3e:	04650513          	addi	a0,a0,70 # 80224e80 <user_test_table+0xb28>
    80206e42:	ffffa097          	auipc	ra,0xffffa
    80206e46:	eec080e7          	jalr	-276(ra) # 80200d2e <printf>
    int mixed_kernel_count = 0;
    80206e4a:	fc042623          	sw	zero,-52(s0)
    int mixed_user_count = 0;
    80206e4e:	fc042423          	sw	zero,-56(s0)
    int target_count = PROC / 2;
    80206e52:	47c1                	li	a5,16
    80206e54:	faf42223          	sw	a5,-92(s0)
    printf("创建 %d 个内核进程和 %d 个用户进程...\n", target_count, target_count);
    80206e58:	fa442703          	lw	a4,-92(s0)
    80206e5c:	fa442783          	lw	a5,-92(s0)
    80206e60:	863a                	mv	a2,a4
    80206e62:	85be                	mv	a1,a5
    80206e64:	0001e517          	auipc	a0,0x1e
    80206e68:	04c50513          	addi	a0,a0,76 # 80224eb0 <user_test_table+0xb58>
    80206e6c:	ffffa097          	auipc	ra,0xffffa
    80206e70:	ec2080e7          	jalr	-318(ra) # 80200d2e <printf>
    for (int i = 0; i < target_count; i++) {
    80206e74:	fc042223          	sw	zero,-60(s0)
    80206e78:	a81d                	j	80206eae <test_process_creation+0x420>
        int new_pid = create_kernel_proc(simple_task);
    80206e7a:	00000517          	auipc	a0,0x0
    80206e7e:	be450513          	addi	a0,a0,-1052 # 80206a5e <simple_task>
    80206e82:	ffffe097          	auipc	ra,0xffffe
    80206e86:	76e080e7          	jalr	1902(ra) # 802055f0 <create_kernel_proc>
    80206e8a:	87aa                	mv	a5,a0
    80206e8c:	faf42023          	sw	a5,-96(s0)
        if (new_pid > 0) {
    80206e90:	fa042783          	lw	a5,-96(s0)
    80206e94:	2781                	sext.w	a5,a5
    80206e96:	02f05663          	blez	a5,80206ec2 <test_process_creation+0x434>
            mixed_kernel_count++;
    80206e9a:	fcc42783          	lw	a5,-52(s0)
    80206e9e:	2785                	addiw	a5,a5,1
    80206ea0:	fcf42623          	sw	a5,-52(s0)
    for (int i = 0; i < target_count; i++) {
    80206ea4:	fc442783          	lw	a5,-60(s0)
    80206ea8:	2785                	addiw	a5,a5,1
    80206eaa:	fcf42223          	sw	a5,-60(s0)
    80206eae:	fc442783          	lw	a5,-60(s0)
    80206eb2:	873e                	mv	a4,a5
    80206eb4:	fa442783          	lw	a5,-92(s0)
    80206eb8:	2701                	sext.w	a4,a4
    80206eba:	2781                	sext.w	a5,a5
    80206ebc:	faf74fe3          	blt	a4,a5,80206e7a <test_process_creation+0x3ec>
    80206ec0:	a011                	j	80206ec4 <test_process_creation+0x436>
            break;
    80206ec2:	0001                	nop
    for (int i = 0; i < target_count; i++) {
    80206ec4:	fc042023          	sw	zero,-64(s0)
    80206ec8:	a83d                	j	80206f06 <test_process_creation+0x478>
        int new_pid = create_user_proc(simple_user_task_bin, simple_user_task_bin_len);
    80206eca:	06c00793          	li	a5,108
    80206ece:	2781                	sext.w	a5,a5
    80206ed0:	85be                	mv	a1,a5
    80206ed2:	0001d517          	auipc	a0,0x1d
    80206ed6:	d4650513          	addi	a0,a0,-698 # 80223c18 <simple_user_task_bin>
    80206eda:	fffff097          	auipc	ra,0xfffff
    80206ede:	802080e7          	jalr	-2046(ra) # 802056dc <create_user_proc>
    80206ee2:	87aa                	mv	a5,a0
    80206ee4:	f8f42e23          	sw	a5,-100(s0)
        if (new_pid > 0) {
    80206ee8:	f9c42783          	lw	a5,-100(s0)
    80206eec:	2781                	sext.w	a5,a5
    80206eee:	02f05663          	blez	a5,80206f1a <test_process_creation+0x48c>
            mixed_user_count++;
    80206ef2:	fc842783          	lw	a5,-56(s0)
    80206ef6:	2785                	addiw	a5,a5,1
    80206ef8:	fcf42423          	sw	a5,-56(s0)
    for (int i = 0; i < target_count; i++) {
    80206efc:	fc042783          	lw	a5,-64(s0)
    80206f00:	2785                	addiw	a5,a5,1
    80206f02:	fcf42023          	sw	a5,-64(s0)
    80206f06:	fc042783          	lw	a5,-64(s0)
    80206f0a:	873e                	mv	a4,a5
    80206f0c:	fa442783          	lw	a5,-92(s0)
    80206f10:	2701                	sext.w	a4,a4
    80206f12:	2781                	sext.w	a5,a5
    80206f14:	faf74be3          	blt	a4,a5,80206eca <test_process_creation+0x43c>
    80206f18:	a011                	j	80206f1c <test_process_creation+0x48e>
            break;
    80206f1a:	0001                	nop
    printf("【混合测试结果】: 创建了 %d 个内核进程 + %d 个用户进程 = %d 个进程\n", 
    80206f1c:	fcc42783          	lw	a5,-52(s0)
    80206f20:	873e                	mv	a4,a5
    80206f22:	fc842783          	lw	a5,-56(s0)
    80206f26:	9fb9                	addw	a5,a5,a4
    80206f28:	0007869b          	sext.w	a3,a5
    80206f2c:	fc842703          	lw	a4,-56(s0)
    80206f30:	fcc42783          	lw	a5,-52(s0)
    80206f34:	863a                	mv	a2,a4
    80206f36:	85be                	mv	a1,a5
    80206f38:	0001e517          	auipc	a0,0x1e
    80206f3c:	fb050513          	addi	a0,a0,-80 # 80224ee8 <user_test_table+0xb90>
    80206f40:	ffffa097          	auipc	ra,0xffffa
    80206f44:	dee080e7          	jalr	-530(ra) # 80200d2e <printf>
    print_proc_table();
    80206f48:	fffff097          	auipc	ra,0xfffff
    80206f4c:	0b2080e7          	jalr	178(ra) # 80205ffa <print_proc_table>
    printf("\n----- 清理混合进程 -----\n");
    80206f50:	0001e517          	auipc	a0,0x1e
    80206f54:	ff850513          	addi	a0,a0,-8 # 80224f48 <user_test_table+0xbf0>
    80206f58:	ffffa097          	auipc	ra,0xffffa
    80206f5c:	dd6080e7          	jalr	-554(ra) # 80200d2e <printf>
    int mixed_success_count = 0;
    80206f60:	fa042e23          	sw	zero,-68(s0)
    int total_mixed = mixed_kernel_count + mixed_user_count;
    80206f64:	fcc42783          	lw	a5,-52(s0)
    80206f68:	873e                	mv	a4,a5
    80206f6a:	fc842783          	lw	a5,-56(s0)
    80206f6e:	9fb9                	addw	a5,a5,a4
    80206f70:	f8f42c23          	sw	a5,-104(s0)
    for (int i = 0; i < total_mixed; i++) {
    80206f74:	fa042c23          	sw	zero,-72(s0)
    80206f78:	a805                	j	80206fa8 <test_process_creation+0x51a>
        int waited_pid = wait_proc(NULL);
    80206f7a:	4501                	li	a0,0
    80206f7c:	fffff097          	auipc	ra,0xfffff
    80206f80:	ef0080e7          	jalr	-272(ra) # 80205e6c <wait_proc>
    80206f84:	87aa                	mv	a5,a0
    80206f86:	f8f42a23          	sw	a5,-108(s0)
        if (waited_pid > 0) {
    80206f8a:	f9442783          	lw	a5,-108(s0)
    80206f8e:	2781                	sext.w	a5,a5
    80206f90:	00f05763          	blez	a5,80206f9e <test_process_creation+0x510>
            mixed_success_count++;
    80206f94:	fbc42783          	lw	a5,-68(s0)
    80206f98:	2785                	addiw	a5,a5,1
    80206f9a:	faf42e23          	sw	a5,-68(s0)
    for (int i = 0; i < total_mixed; i++) {
    80206f9e:	fb842783          	lw	a5,-72(s0)
    80206fa2:	2785                	addiw	a5,a5,1
    80206fa4:	faf42c23          	sw	a5,-72(s0)
    80206fa8:	fb842783          	lw	a5,-72(s0)
    80206fac:	873e                	mv	a4,a5
    80206fae:	f9842783          	lw	a5,-104(s0)
    80206fb2:	2701                	sext.w	a4,a4
    80206fb4:	2781                	sext.w	a5,a5
    80206fb6:	fcf742e3          	blt	a4,a5,80206f7a <test_process_creation+0x4ec>
    printf("【混合测试结果】: 回收 %d/%d 个混合进程\n", mixed_success_count, total_mixed);
    80206fba:	f9842703          	lw	a4,-104(s0)
    80206fbe:	fbc42783          	lw	a5,-68(s0)
    80206fc2:	863a                	mv	a2,a4
    80206fc4:	85be                	mv	a1,a5
    80206fc6:	0001e517          	auipc	a0,0x1e
    80206fca:	faa50513          	addi	a0,a0,-86 # 80224f70 <user_test_table+0xc18>
    80206fce:	ffffa097          	auipc	ra,0xffffa
    80206fd2:	d60080e7          	jalr	-672(ra) # 80200d2e <printf>
    print_proc_table();
    80206fd6:	fffff097          	auipc	ra,0xfffff
    80206fda:	024080e7          	jalr	36(ra) # 80205ffa <print_proc_table>
    printf("===== 测试结束: 进程创建与管理测试 =====\n");
    80206fde:	0001e517          	auipc	a0,0x1e
    80206fe2:	fca50513          	addi	a0,a0,-54 # 80224fa8 <user_test_table+0xc50>
    80206fe6:	ffffa097          	auipc	ra,0xffffa
    80206fea:	d48080e7          	jalr	-696(ra) # 80200d2e <printf>
}
    80206fee:	70e6                	ld	ra,120(sp)
    80206ff0:	7446                	ld	s0,112(sp)
    80206ff2:	6109                	addi	sp,sp,128
    80206ff4:	8082                	ret

0000000080206ff6 <cpu_intensive_task>:
void cpu_intensive_task(void) {
    80206ff6:	7139                	addi	sp,sp,-64
    80206ff8:	fc06                	sd	ra,56(sp)
    80206ffa:	f822                	sd	s0,48(sp)
    80206ffc:	0080                	addi	s0,sp,64
    int pid = myproc()->pid;
    80206ffe:	ffffe097          	auipc	ra,0xffffe
    80207002:	fb2080e7          	jalr	-78(ra) # 80204fb0 <myproc>
    80207006:	87aa                	mv	a5,a0
    80207008:	43dc                	lw	a5,4(a5)
    8020700a:	fcf42e23          	sw	a5,-36(s0)
    printf("[进程 %d] 开始CPU密集计算\n", pid);
    8020700e:	fdc42783          	lw	a5,-36(s0)
    80207012:	85be                	mv	a1,a5
    80207014:	0001e517          	auipc	a0,0x1e
    80207018:	fcc50513          	addi	a0,a0,-52 # 80224fe0 <user_test_table+0xc88>
    8020701c:	ffffa097          	auipc	ra,0xffffa
    80207020:	d12080e7          	jalr	-750(ra) # 80200d2e <printf>
    uint64 sum = 0;
    80207024:	fe043423          	sd	zero,-24(s0)
    const uint64 TOTAL_ITERATIONS = 100000000;
    80207028:	05f5e7b7          	lui	a5,0x5f5e
    8020702c:	10078793          	addi	a5,a5,256 # 5f5e100 <_entry-0x7a2a1f00>
    80207030:	fcf43823          	sd	a5,-48(s0)
    const uint64 REPORT_INTERVAL = TOTAL_ITERATIONS / 100;  // 每完成1%报告一次
    80207034:	fd043703          	ld	a4,-48(s0)
    80207038:	06400793          	li	a5,100
    8020703c:	02f757b3          	divu	a5,a4,a5
    80207040:	fcf43423          	sd	a5,-56(s0)
    for (uint64 i = 0; i < TOTAL_ITERATIONS; i++) {
    80207044:	fe043023          	sd	zero,-32(s0)
    80207048:	a8b5                	j	802070c4 <cpu_intensive_task+0xce>
        sum += (i * i) % 1000000007;  // 添加乘法和取模运算
    8020704a:	fe043783          	ld	a5,-32(s0)
    8020704e:	02f78733          	mul	a4,a5,a5
    80207052:	3b9ad7b7          	lui	a5,0x3b9ad
    80207056:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_entry-0x448535f9>
    8020705a:	02f777b3          	remu	a5,a4,a5
    8020705e:	fe843703          	ld	a4,-24(s0)
    80207062:	97ba                	add	a5,a5,a4
    80207064:	fef43423          	sd	a5,-24(s0)
        if (i % REPORT_INTERVAL == 0) {
    80207068:	fe043703          	ld	a4,-32(s0)
    8020706c:	fc843783          	ld	a5,-56(s0)
    80207070:	02f777b3          	remu	a5,a4,a5
    80207074:	e3b9                	bnez	a5,802070ba <cpu_intensive_task+0xc4>
            uint64 percent = (i * 100) / TOTAL_ITERATIONS;
    80207076:	fe043703          	ld	a4,-32(s0)
    8020707a:	06400793          	li	a5,100
    8020707e:	02f70733          	mul	a4,a4,a5
    80207082:	fd043783          	ld	a5,-48(s0)
    80207086:	02f757b3          	divu	a5,a4,a5
    8020708a:	fcf43023          	sd	a5,-64(s0)
            printf("[进程 %d] 完成度: %lu%%，当前sum=%lu\n", 
    8020708e:	fdc42783          	lw	a5,-36(s0)
    80207092:	fe843683          	ld	a3,-24(s0)
    80207096:	fc043603          	ld	a2,-64(s0)
    8020709a:	85be                	mv	a1,a5
    8020709c:	0001e517          	auipc	a0,0x1e
    802070a0:	f6c50513          	addi	a0,a0,-148 # 80225008 <user_test_table+0xcb0>
    802070a4:	ffffa097          	auipc	ra,0xffffa
    802070a8:	c8a080e7          	jalr	-886(ra) # 80200d2e <printf>
            if (i > 0) {
    802070ac:	fe043783          	ld	a5,-32(s0)
    802070b0:	c789                	beqz	a5,802070ba <cpu_intensive_task+0xc4>
                yield();
    802070b2:	fffff097          	auipc	ra,0xfffff
    802070b6:	ae2080e7          	jalr	-1310(ra) # 80205b94 <yield>
    for (uint64 i = 0; i < TOTAL_ITERATIONS; i++) {
    802070ba:	fe043783          	ld	a5,-32(s0)
    802070be:	0785                	addi	a5,a5,1
    802070c0:	fef43023          	sd	a5,-32(s0)
    802070c4:	fe043703          	ld	a4,-32(s0)
    802070c8:	fd043783          	ld	a5,-48(s0)
    802070cc:	f6f76fe3          	bltu	a4,a5,8020704a <cpu_intensive_task+0x54>
    printf("[进程 %d] 计算完成，最终sum=%lu\n", pid, sum);
    802070d0:	fdc42783          	lw	a5,-36(s0)
    802070d4:	fe843603          	ld	a2,-24(s0)
    802070d8:	85be                	mv	a1,a5
    802070da:	0001e517          	auipc	a0,0x1e
    802070de:	f5e50513          	addi	a0,a0,-162 # 80225038 <user_test_table+0xce0>
    802070e2:	ffffa097          	auipc	ra,0xffffa
    802070e6:	c4c080e7          	jalr	-948(ra) # 80200d2e <printf>
    exit_proc(0);
    802070ea:	4501                	li	a0,0
    802070ec:	fffff097          	auipc	ra,0xfffff
    802070f0:	cb6080e7          	jalr	-842(ra) # 80205da2 <exit_proc>
}
    802070f4:	0001                	nop
    802070f6:	70e2                	ld	ra,56(sp)
    802070f8:	7442                	ld	s0,48(sp)
    802070fa:	6121                	addi	sp,sp,64
    802070fc:	8082                	ret

00000000802070fe <test_scheduler>:
void test_scheduler(void) {
    802070fe:	715d                	addi	sp,sp,-80
    80207100:	e486                	sd	ra,72(sp)
    80207102:	e0a2                	sd	s0,64(sp)
    80207104:	0880                	addi	s0,sp,80
    printf("\n===== 测试开始: 调度器公平性测试 =====\n");
    80207106:	0001e517          	auipc	a0,0x1e
    8020710a:	f6250513          	addi	a0,a0,-158 # 80225068 <user_test_table+0xd10>
    8020710e:	ffffa097          	auipc	ra,0xffffa
    80207112:	c20080e7          	jalr	-992(ra) # 80200d2e <printf>
    for (int i = 0; i < 3; i++) {
    80207116:	fe042623          	sw	zero,-20(s0)
    8020711a:	a8a5                	j	80207192 <test_scheduler+0x94>
        pids[i] = create_kernel_proc(cpu_intensive_task);
    8020711c:	00000517          	auipc	a0,0x0
    80207120:	eda50513          	addi	a0,a0,-294 # 80206ff6 <cpu_intensive_task>
    80207124:	ffffe097          	auipc	ra,0xffffe
    80207128:	4cc080e7          	jalr	1228(ra) # 802055f0 <create_kernel_proc>
    8020712c:	87aa                	mv	a5,a0
    8020712e:	873e                	mv	a4,a5
    80207130:	fec42783          	lw	a5,-20(s0)
    80207134:	078a                	slli	a5,a5,0x2
    80207136:	17c1                	addi	a5,a5,-16
    80207138:	97a2                	add	a5,a5,s0
    8020713a:	fce7a823          	sw	a4,-48(a5)
        if (pids[i] < 0) {
    8020713e:	fec42783          	lw	a5,-20(s0)
    80207142:	078a                	slli	a5,a5,0x2
    80207144:	17c1                	addi	a5,a5,-16
    80207146:	97a2                	add	a5,a5,s0
    80207148:	fd07a783          	lw	a5,-48(a5)
    8020714c:	0007de63          	bgez	a5,80207168 <test_scheduler+0x6a>
            printf("【错误】创建进程 %d 失败\n", i);
    80207150:	fec42783          	lw	a5,-20(s0)
    80207154:	85be                	mv	a1,a5
    80207156:	0001e517          	auipc	a0,0x1e
    8020715a:	f4a50513          	addi	a0,a0,-182 # 802250a0 <user_test_table+0xd48>
    8020715e:	ffffa097          	auipc	ra,0xffffa
    80207162:	bd0080e7          	jalr	-1072(ra) # 80200d2e <printf>
    80207166:	a239                	j	80207274 <test_scheduler+0x176>
        printf("创建进程成功，PID: %d\n", pids[i]);
    80207168:	fec42783          	lw	a5,-20(s0)
    8020716c:	078a                	slli	a5,a5,0x2
    8020716e:	17c1                	addi	a5,a5,-16
    80207170:	97a2                	add	a5,a5,s0
    80207172:	fd07a783          	lw	a5,-48(a5)
    80207176:	85be                	mv	a1,a5
    80207178:	0001e517          	auipc	a0,0x1e
    8020717c:	f5050513          	addi	a0,a0,-176 # 802250c8 <user_test_table+0xd70>
    80207180:	ffffa097          	auipc	ra,0xffffa
    80207184:	bae080e7          	jalr	-1106(ra) # 80200d2e <printf>
    for (int i = 0; i < 3; i++) {
    80207188:	fec42783          	lw	a5,-20(s0)
    8020718c:	2785                	addiw	a5,a5,1
    8020718e:	fef42623          	sw	a5,-20(s0)
    80207192:	fec42783          	lw	a5,-20(s0)
    80207196:	0007871b          	sext.w	a4,a5
    8020719a:	4789                	li	a5,2
    8020719c:	f8e7d0e3          	bge	a5,a4,8020711c <test_scheduler+0x1e>
    uint64 start_time = get_time();
    802071a0:	fffff097          	auipc	ra,0xfffff
    802071a4:	33a080e7          	jalr	826(ra) # 802064da <get_time>
    802071a8:	fea43023          	sd	a0,-32(s0)
    int completed = 0;
    802071ac:	fe042423          	sw	zero,-24(s0)
    while (completed < 3) {
    802071b0:	a0a9                	j	802071fa <test_scheduler+0xfc>
        int pid = wait_proc(&status);
    802071b2:	fbc40793          	addi	a5,s0,-68
    802071b6:	853e                	mv	a0,a5
    802071b8:	fffff097          	auipc	ra,0xfffff
    802071bc:	cb4080e7          	jalr	-844(ra) # 80205e6c <wait_proc>
    802071c0:	87aa                	mv	a5,a0
    802071c2:	fcf42623          	sw	a5,-52(s0)
        if (pid > 0) {
    802071c6:	fcc42783          	lw	a5,-52(s0)
    802071ca:	2781                	sext.w	a5,a5
    802071cc:	02f05763          	blez	a5,802071fa <test_scheduler+0xfc>
            completed++;
    802071d0:	fe842783          	lw	a5,-24(s0)
    802071d4:	2785                	addiw	a5,a5,1
    802071d6:	fef42423          	sw	a5,-24(s0)
            printf("进程 %d 已完成，退出状态: %d (%d/3)\n", 
    802071da:	fbc42703          	lw	a4,-68(s0)
    802071de:	fe842683          	lw	a3,-24(s0)
    802071e2:	fcc42783          	lw	a5,-52(s0)
    802071e6:	863a                	mv	a2,a4
    802071e8:	85be                	mv	a1,a5
    802071ea:	0001e517          	auipc	a0,0x1e
    802071ee:	efe50513          	addi	a0,a0,-258 # 802250e8 <user_test_table+0xd90>
    802071f2:	ffffa097          	auipc	ra,0xffffa
    802071f6:	b3c080e7          	jalr	-1220(ra) # 80200d2e <printf>
    while (completed < 3) {
    802071fa:	fe842783          	lw	a5,-24(s0)
    802071fe:	0007871b          	sext.w	a4,a5
    80207202:	4789                	li	a5,2
    80207204:	fae7d7e3          	bge	a5,a4,802071b2 <test_scheduler+0xb4>
    uint64 end_time = get_time();
    80207208:	fffff097          	auipc	ra,0xfffff
    8020720c:	2d2080e7          	jalr	722(ra) # 802064da <get_time>
    80207210:	fca43c23          	sd	a0,-40(s0)
    uint64 total_cycles = end_time - start_time;
    80207214:	fd843703          	ld	a4,-40(s0)
    80207218:	fe043783          	ld	a5,-32(s0)
    8020721c:	40f707b3          	sub	a5,a4,a5
    80207220:	fcf43823          	sd	a5,-48(s0)
    printf("\n----- 测试结果 -----\n");
    80207224:	0001e517          	auipc	a0,0x1e
    80207228:	ef450513          	addi	a0,a0,-268 # 80225118 <user_test_table+0xdc0>
    8020722c:	ffffa097          	auipc	ra,0xffffa
    80207230:	b02080e7          	jalr	-1278(ra) # 80200d2e <printf>
    printf("总执行时间: %lu cycles\n", total_cycles);
    80207234:	fd043583          	ld	a1,-48(s0)
    80207238:	0001e517          	auipc	a0,0x1e
    8020723c:	f0050513          	addi	a0,a0,-256 # 80225138 <user_test_table+0xde0>
    80207240:	ffffa097          	auipc	ra,0xffffa
    80207244:	aee080e7          	jalr	-1298(ra) # 80200d2e <printf>
    printf("平均每个进程执行时间: %lu cycles\n", total_cycles / 3);
    80207248:	fd043703          	ld	a4,-48(s0)
    8020724c:	478d                	li	a5,3
    8020724e:	02f757b3          	divu	a5,a4,a5
    80207252:	85be                	mv	a1,a5
    80207254:	0001e517          	auipc	a0,0x1e
    80207258:	f0450513          	addi	a0,a0,-252 # 80225158 <user_test_table+0xe00>
    8020725c:	ffffa097          	auipc	ra,0xffffa
    80207260:	ad2080e7          	jalr	-1326(ra) # 80200d2e <printf>
    printf("===== 调度器测试完成 =====\n");
    80207264:	0001e517          	auipc	a0,0x1e
    80207268:	f2450513          	addi	a0,a0,-220 # 80225188 <user_test_table+0xe30>
    8020726c:	ffffa097          	auipc	ra,0xffffa
    80207270:	ac2080e7          	jalr	-1342(ra) # 80200d2e <printf>
}
    80207274:	60a6                	ld	ra,72(sp)
    80207276:	6406                	ld	s0,64(sp)
    80207278:	6161                	addi	sp,sp,80
    8020727a:	8082                	ret

000000008020727c <shared_buffer_init>:
void shared_buffer_init() {
    8020727c:	1141                	addi	sp,sp,-16
    8020727e:	e422                	sd	s0,8(sp)
    80207280:	0800                	addi	s0,sp,16
    proc_buffer = 0;
    80207282:	00020797          	auipc	a5,0x20
    80207286:	46678793          	addi	a5,a5,1126 # 802276e8 <proc_buffer>
    8020728a:	0007a023          	sw	zero,0(a5)
    proc_produced = 0;
    8020728e:	00020797          	auipc	a5,0x20
    80207292:	45e78793          	addi	a5,a5,1118 # 802276ec <proc_produced>
    80207296:	0007a023          	sw	zero,0(a5)
}
    8020729a:	0001                	nop
    8020729c:	6422                	ld	s0,8(sp)
    8020729e:	0141                	addi	sp,sp,16
    802072a0:	8082                	ret

00000000802072a2 <producer_task>:
void producer_task(void) {
    802072a2:	7179                	addi	sp,sp,-48
    802072a4:	f406                	sd	ra,40(sp)
    802072a6:	f022                	sd	s0,32(sp)
    802072a8:	1800                	addi	s0,sp,48
	int pid = myproc()->pid;
    802072aa:	ffffe097          	auipc	ra,0xffffe
    802072ae:	d06080e7          	jalr	-762(ra) # 80204fb0 <myproc>
    802072b2:	87aa                	mv	a5,a0
    802072b4:	43dc                	lw	a5,4(a5)
    802072b6:	fcf42e23          	sw	a5,-36(s0)
    uint64 sum = 0;
    802072ba:	fe043423          	sd	zero,-24(s0)
    const uint64 ITERATIONS = 10000000;  // 一千万次循环
    802072be:	009897b7          	lui	a5,0x989
    802072c2:	68078793          	addi	a5,a5,1664 # 989680 <_entry-0x7f876980>
    802072c6:	fcf43823          	sd	a5,-48(s0)
    for(uint64 i = 0; i < ITERATIONS; i++) {
    802072ca:	fe043023          	sd	zero,-32(s0)
    802072ce:	a0bd                	j	8020733c <producer_task+0x9a>
        sum += (i * i) % 1000000007;  // 复杂计算
    802072d0:	fe043783          	ld	a5,-32(s0)
    802072d4:	02f78733          	mul	a4,a5,a5
    802072d8:	3b9ad7b7          	lui	a5,0x3b9ad
    802072dc:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_entry-0x448535f9>
    802072e0:	02f777b3          	remu	a5,a4,a5
    802072e4:	fe843703          	ld	a4,-24(s0)
    802072e8:	97ba                	add	a5,a5,a4
    802072ea:	fef43423          	sd	a5,-24(s0)
        if(i % (ITERATIONS/10) == 0) {
    802072ee:	fd043703          	ld	a4,-48(s0)
    802072f2:	47a9                	li	a5,10
    802072f4:	02f757b3          	divu	a5,a4,a5
    802072f8:	fe043703          	ld	a4,-32(s0)
    802072fc:	02f777b3          	remu	a5,a4,a5
    80207300:	eb8d                	bnez	a5,80207332 <producer_task+0x90>
                   pid, (int)(i * 100 / ITERATIONS));
    80207302:	fe043703          	ld	a4,-32(s0)
    80207306:	06400793          	li	a5,100
    8020730a:	02f70733          	mul	a4,a4,a5
    8020730e:	fd043783          	ld	a5,-48(s0)
    80207312:	02f757b3          	divu	a5,a4,a5
            printf("[Producer %d] 计算进度: %d%%\n", 
    80207316:	0007871b          	sext.w	a4,a5
    8020731a:	fdc42783          	lw	a5,-36(s0)
    8020731e:	863a                	mv	a2,a4
    80207320:	85be                	mv	a1,a5
    80207322:	0001e517          	auipc	a0,0x1e
    80207326:	e8e50513          	addi	a0,a0,-370 # 802251b0 <user_test_table+0xe58>
    8020732a:	ffffa097          	auipc	ra,0xffffa
    8020732e:	a04080e7          	jalr	-1532(ra) # 80200d2e <printf>
    for(uint64 i = 0; i < ITERATIONS; i++) {
    80207332:	fe043783          	ld	a5,-32(s0)
    80207336:	0785                	addi	a5,a5,1
    80207338:	fef43023          	sd	a5,-32(s0)
    8020733c:	fe043703          	ld	a4,-32(s0)
    80207340:	fd043783          	ld	a5,-48(s0)
    80207344:	f8f766e3          	bltu	a4,a5,802072d0 <producer_task+0x2e>
    proc_buffer = 42;
    80207348:	00020797          	auipc	a5,0x20
    8020734c:	3a078793          	addi	a5,a5,928 # 802276e8 <proc_buffer>
    80207350:	02a00713          	li	a4,42
    80207354:	c398                	sw	a4,0(a5)
    proc_produced = 1;
    80207356:	00020797          	auipc	a5,0x20
    8020735a:	39678793          	addi	a5,a5,918 # 802276ec <proc_produced>
    8020735e:	4705                	li	a4,1
    80207360:	c398                	sw	a4,0(a5)
    wakeup(&proc_produced); // 唤醒消费者
    80207362:	00020517          	auipc	a0,0x20
    80207366:	38a50513          	addi	a0,a0,906 # 802276ec <proc_produced>
    8020736a:	fffff097          	auipc	ra,0xfffff
    8020736e:	968080e7          	jalr	-1688(ra) # 80205cd2 <wakeup>
    printf("Producer: produced value %d\n", proc_buffer);
    80207372:	00020797          	auipc	a5,0x20
    80207376:	37678793          	addi	a5,a5,886 # 802276e8 <proc_buffer>
    8020737a:	439c                	lw	a5,0(a5)
    8020737c:	85be                	mv	a1,a5
    8020737e:	0001e517          	auipc	a0,0x1e
    80207382:	e5a50513          	addi	a0,a0,-422 # 802251d8 <user_test_table+0xe80>
    80207386:	ffffa097          	auipc	ra,0xffffa
    8020738a:	9a8080e7          	jalr	-1624(ra) # 80200d2e <printf>
    exit_proc(0);
    8020738e:	4501                	li	a0,0
    80207390:	fffff097          	auipc	ra,0xfffff
    80207394:	a12080e7          	jalr	-1518(ra) # 80205da2 <exit_proc>
}
    80207398:	0001                	nop
    8020739a:	70a2                	ld	ra,40(sp)
    8020739c:	7402                	ld	s0,32(sp)
    8020739e:	6145                	addi	sp,sp,48
    802073a0:	8082                	ret

00000000802073a2 <consumer_task>:
void consumer_task(void) {
    802073a2:	1141                	addi	sp,sp,-16
    802073a4:	e406                	sd	ra,8(sp)
    802073a6:	e022                	sd	s0,0(sp)
    802073a8:	0800                	addi	s0,sp,16
    while (!proc_produced) {
    802073aa:	a00d                	j	802073cc <consumer_task+0x2a>
		printf("wait for producer\n");
    802073ac:	0001e517          	auipc	a0,0x1e
    802073b0:	e4c50513          	addi	a0,a0,-436 # 802251f8 <user_test_table+0xea0>
    802073b4:	ffffa097          	auipc	ra,0xffffa
    802073b8:	97a080e7          	jalr	-1670(ra) # 80200d2e <printf>
        sleep(&proc_produced); // 等待生产者
    802073bc:	00020517          	auipc	a0,0x20
    802073c0:	33050513          	addi	a0,a0,816 # 802276ec <proc_produced>
    802073c4:	fffff097          	auipc	ra,0xfffff
    802073c8:	876080e7          	jalr	-1930(ra) # 80205c3a <sleep>
    while (!proc_produced) {
    802073cc:	00020797          	auipc	a5,0x20
    802073d0:	32078793          	addi	a5,a5,800 # 802276ec <proc_produced>
    802073d4:	439c                	lw	a5,0(a5)
    802073d6:	dbf9                	beqz	a5,802073ac <consumer_task+0xa>
    printf("Consumer: consumed value %d\n", proc_buffer);
    802073d8:	00020797          	auipc	a5,0x20
    802073dc:	31078793          	addi	a5,a5,784 # 802276e8 <proc_buffer>
    802073e0:	439c                	lw	a5,0(a5)
    802073e2:	85be                	mv	a1,a5
    802073e4:	0001e517          	auipc	a0,0x1e
    802073e8:	e2c50513          	addi	a0,a0,-468 # 80225210 <user_test_table+0xeb8>
    802073ec:	ffffa097          	auipc	ra,0xffffa
    802073f0:	942080e7          	jalr	-1726(ra) # 80200d2e <printf>
    exit_proc(0);
    802073f4:	4501                	li	a0,0
    802073f6:	fffff097          	auipc	ra,0xfffff
    802073fa:	9ac080e7          	jalr	-1620(ra) # 80205da2 <exit_proc>
}
    802073fe:	0001                	nop
    80207400:	60a2                	ld	ra,8(sp)
    80207402:	6402                	ld	s0,0(sp)
    80207404:	0141                	addi	sp,sp,16
    80207406:	8082                	ret

0000000080207408 <test_synchronization>:
void test_synchronization(void) {
    80207408:	1141                	addi	sp,sp,-16
    8020740a:	e406                	sd	ra,8(sp)
    8020740c:	e022                	sd	s0,0(sp)
    8020740e:	0800                	addi	s0,sp,16
    printf("===== 测试开始: 同步机制测试 =====\n");
    80207410:	0001e517          	auipc	a0,0x1e
    80207414:	e2050513          	addi	a0,a0,-480 # 80225230 <user_test_table+0xed8>
    80207418:	ffffa097          	auipc	ra,0xffffa
    8020741c:	916080e7          	jalr	-1770(ra) # 80200d2e <printf>
    shared_buffer_init();
    80207420:	00000097          	auipc	ra,0x0
    80207424:	e5c080e7          	jalr	-420(ra) # 8020727c <shared_buffer_init>

    // 创建生产者和消费者进程
    create_kernel_proc(producer_task);
    80207428:	00000517          	auipc	a0,0x0
    8020742c:	e7a50513          	addi	a0,a0,-390 # 802072a2 <producer_task>
    80207430:	ffffe097          	auipc	ra,0xffffe
    80207434:	1c0080e7          	jalr	448(ra) # 802055f0 <create_kernel_proc>
    create_kernel_proc(consumer_task);
    80207438:	00000517          	auipc	a0,0x0
    8020743c:	f6a50513          	addi	a0,a0,-150 # 802073a2 <consumer_task>
    80207440:	ffffe097          	auipc	ra,0xffffe
    80207444:	1b0080e7          	jalr	432(ra) # 802055f0 <create_kernel_proc>

    // 等待两个进程完成
    wait_proc(NULL);
    80207448:	4501                	li	a0,0
    8020744a:	fffff097          	auipc	ra,0xfffff
    8020744e:	a22080e7          	jalr	-1502(ra) # 80205e6c <wait_proc>
    wait_proc(NULL);
    80207452:	4501                	li	a0,0
    80207454:	fffff097          	auipc	ra,0xfffff
    80207458:	a18080e7          	jalr	-1512(ra) # 80205e6c <wait_proc>

    printf("===== 测试结束 =====\n");
    8020745c:	0001e517          	auipc	a0,0x1e
    80207460:	e0450513          	addi	a0,a0,-508 # 80225260 <user_test_table+0xf08>
    80207464:	ffffa097          	auipc	ra,0xffffa
    80207468:	8ca080e7          	jalr	-1846(ra) # 80200d2e <printf>
}
    8020746c:	0001                	nop
    8020746e:	60a2                	ld	ra,8(sp)
    80207470:	6402                	ld	s0,0(sp)
    80207472:	0141                	addi	sp,sp,16
    80207474:	8082                	ret

0000000080207476 <sys_access_task>:

void sys_access_task(void) {
    80207476:	1101                	addi	sp,sp,-32
    80207478:	ec06                	sd	ra,24(sp)
    8020747a:	e822                	sd	s0,16(sp)
    8020747c:	1000                	addi	s0,sp,32
    volatile int *ptr = (int*)0x80200000; // 内核空间地址
    8020747e:	40100793          	li	a5,1025
    80207482:	07d6                	slli	a5,a5,0x15
    80207484:	fef43423          	sd	a5,-24(s0)
    printf("SYS: try read kernel addr 0x80200000\n");
    80207488:	0001e517          	auipc	a0,0x1e
    8020748c:	df850513          	addi	a0,a0,-520 # 80225280 <user_test_table+0xf28>
    80207490:	ffffa097          	auipc	ra,0xffffa
    80207494:	89e080e7          	jalr	-1890(ra) # 80200d2e <printf>
    int val = *ptr;
    80207498:	fe843783          	ld	a5,-24(s0)
    8020749c:	439c                	lw	a5,0(a5)
    8020749e:	fef42223          	sw	a5,-28(s0)
    printf("SYS: read success, value=%d\n", val);
    802074a2:	fe442783          	lw	a5,-28(s0)
    802074a6:	85be                	mv	a1,a5
    802074a8:	0001e517          	auipc	a0,0x1e
    802074ac:	e0050513          	addi	a0,a0,-512 # 802252a8 <user_test_table+0xf50>
    802074b0:	ffffa097          	auipc	ra,0xffffa
    802074b4:	87e080e7          	jalr	-1922(ra) # 80200d2e <printf>
    exit_proc(0);
    802074b8:	4501                	li	a0,0
    802074ba:	fffff097          	auipc	ra,0xfffff
    802074be:	8e8080e7          	jalr	-1816(ra) # 80205da2 <exit_proc>
}
    802074c2:	0001                	nop
    802074c4:	60e2                	ld	ra,24(sp)
    802074c6:	6442                	ld	s0,16(sp)
    802074c8:	6105                	addi	sp,sp,32
    802074ca:	8082                	ret

00000000802074cc <infinite_task>:

void infinite_task(void){
    802074cc:	1101                	addi	sp,sp,-32
    802074ce:	ec06                	sd	ra,24(sp)
    802074d0:	e822                	sd	s0,16(sp)
    802074d2:	1000                	addi	s0,sp,32
	int count = 5000 ;
    802074d4:	6785                	lui	a5,0x1
    802074d6:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    802074da:	fef42623          	sw	a5,-20(s0)
	while(count){
    802074de:	a835                	j	8020751a <infinite_task+0x4e>
		count--;
    802074e0:	fec42783          	lw	a5,-20(s0)
    802074e4:	37fd                	addiw	a5,a5,-1
    802074e6:	fef42623          	sw	a5,-20(s0)
		if (count % 100 == 0)
    802074ea:	fec42783          	lw	a5,-20(s0)
    802074ee:	873e                	mv	a4,a5
    802074f0:	06400793          	li	a5,100
    802074f4:	02f767bb          	remw	a5,a4,a5
    802074f8:	2781                	sext.w	a5,a5
    802074fa:	ef81                	bnez	a5,80207512 <infinite_task+0x46>
			printf("count for %d\n",count);
    802074fc:	fec42783          	lw	a5,-20(s0)
    80207500:	85be                	mv	a1,a5
    80207502:	0001e517          	auipc	a0,0x1e
    80207506:	dc650513          	addi	a0,a0,-570 # 802252c8 <user_test_table+0xf70>
    8020750a:	ffffa097          	auipc	ra,0xffffa
    8020750e:	824080e7          	jalr	-2012(ra) # 80200d2e <printf>
		yield();
    80207512:	ffffe097          	auipc	ra,0xffffe
    80207516:	682080e7          	jalr	1666(ra) # 80205b94 <yield>
	while(count){
    8020751a:	fec42783          	lw	a5,-20(s0)
    8020751e:	2781                	sext.w	a5,a5
    80207520:	f3e1                	bnez	a5,802074e0 <infinite_task+0x14>
	}
	warning("INFINITE TASK FINISH WITHOUT KILLED!!\n");
    80207522:	0001e517          	auipc	a0,0x1e
    80207526:	db650513          	addi	a0,a0,-586 # 802252d8 <user_test_table+0xf80>
    8020752a:	ffffa097          	auipc	ra,0xffffa
    8020752e:	284080e7          	jalr	644(ra) # 802017ae <warning>
}
    80207532:	0001                	nop
    80207534:	60e2                	ld	ra,24(sp)
    80207536:	6442                	ld	s0,16(sp)
    80207538:	6105                	addi	sp,sp,32
    8020753a:	8082                	ret

000000008020753c <killer_task>:

void killer_task(uint64 kill_pid){
    8020753c:	7179                	addi	sp,sp,-48
    8020753e:	f406                	sd	ra,40(sp)
    80207540:	f022                	sd	s0,32(sp)
    80207542:	1800                	addi	s0,sp,48
    80207544:	fca43c23          	sd	a0,-40(s0)
	int count = 500;
    80207548:	1f400793          	li	a5,500
    8020754c:	fef42623          	sw	a5,-20(s0)
	while(count){
    80207550:	a81d                	j	80207586 <killer_task+0x4a>
		count--;
    80207552:	fec42783          	lw	a5,-20(s0)
    80207556:	37fd                	addiw	a5,a5,-1
    80207558:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    8020755c:	fec42783          	lw	a5,-20(s0)
    80207560:	873e                	mv	a4,a5
    80207562:	06400793          	li	a5,100
    80207566:	02f767bb          	remw	a5,a4,a5
    8020756a:	2781                	sext.w	a5,a5
    8020756c:	eb89                	bnez	a5,8020757e <killer_task+0x42>
			printf("I see you!!!\n");
    8020756e:	0001e517          	auipc	a0,0x1e
    80207572:	d9250513          	addi	a0,a0,-622 # 80225300 <user_test_table+0xfa8>
    80207576:	ffff9097          	auipc	ra,0xffff9
    8020757a:	7b8080e7          	jalr	1976(ra) # 80200d2e <printf>
		yield();
    8020757e:	ffffe097          	auipc	ra,0xffffe
    80207582:	616080e7          	jalr	1558(ra) # 80205b94 <yield>
	while(count){
    80207586:	fec42783          	lw	a5,-20(s0)
    8020758a:	2781                	sext.w	a5,a5
    8020758c:	f3f9                	bnez	a5,80207552 <killer_task+0x16>
	}
	kill_proc((int)kill_pid);
    8020758e:	fd843783          	ld	a5,-40(s0)
    80207592:	2781                	sext.w	a5,a5
    80207594:	853e                	mv	a0,a5
    80207596:	ffffe097          	auipc	ra,0xffffe
    8020759a:	7a8080e7          	jalr	1960(ra) # 80205d3e <kill_proc>
	printf("Killed proc %d\n",(int)kill_pid);
    8020759e:	fd843783          	ld	a5,-40(s0)
    802075a2:	2781                	sext.w	a5,a5
    802075a4:	85be                	mv	a1,a5
    802075a6:	0001e517          	auipc	a0,0x1e
    802075aa:	d6a50513          	addi	a0,a0,-662 # 80225310 <user_test_table+0xfb8>
    802075ae:	ffff9097          	auipc	ra,0xffff9
    802075b2:	780080e7          	jalr	1920(ra) # 80200d2e <printf>
	exit_proc(0);
    802075b6:	4501                	li	a0,0
    802075b8:	ffffe097          	auipc	ra,0xffffe
    802075bc:	7ea080e7          	jalr	2026(ra) # 80205da2 <exit_proc>
}
    802075c0:	0001                	nop
    802075c2:	70a2                	ld	ra,40(sp)
    802075c4:	7402                	ld	s0,32(sp)
    802075c6:	6145                	addi	sp,sp,48
    802075c8:	8082                	ret

00000000802075ca <victim_task>:
void victim_task(void){
    802075ca:	1101                	addi	sp,sp,-32
    802075cc:	ec06                	sd	ra,24(sp)
    802075ce:	e822                	sd	s0,16(sp)
    802075d0:	1000                	addi	s0,sp,32
	int count =5000;
    802075d2:	6785                	lui	a5,0x1
    802075d4:	38878793          	addi	a5,a5,904 # 1388 <_entry-0x801fec78>
    802075d8:	fef42623          	sw	a5,-20(s0)
	while(count){
    802075dc:	a81d                	j	80207612 <victim_task+0x48>
		count--;
    802075de:	fec42783          	lw	a5,-20(s0)
    802075e2:	37fd                	addiw	a5,a5,-1
    802075e4:	fef42623          	sw	a5,-20(s0)
		if(count % 100 == 0)
    802075e8:	fec42783          	lw	a5,-20(s0)
    802075ec:	873e                	mv	a4,a5
    802075ee:	06400793          	li	a5,100
    802075f2:	02f767bb          	remw	a5,a4,a5
    802075f6:	2781                	sext.w	a5,a5
    802075f8:	eb89                	bnez	a5,8020760a <victim_task+0x40>
			printf("Call for help!!\n");
    802075fa:	0001e517          	auipc	a0,0x1e
    802075fe:	d2650513          	addi	a0,a0,-730 # 80225320 <user_test_table+0xfc8>
    80207602:	ffff9097          	auipc	ra,0xffff9
    80207606:	72c080e7          	jalr	1836(ra) # 80200d2e <printf>
		yield();
    8020760a:	ffffe097          	auipc	ra,0xffffe
    8020760e:	58a080e7          	jalr	1418(ra) # 80205b94 <yield>
	while(count){
    80207612:	fec42783          	lw	a5,-20(s0)
    80207616:	2781                	sext.w	a5,a5
    80207618:	f3f9                	bnez	a5,802075de <victim_task+0x14>
	}
	printf("No one can kill me!\n");
    8020761a:	0001e517          	auipc	a0,0x1e
    8020761e:	d1e50513          	addi	a0,a0,-738 # 80225338 <user_test_table+0xfe0>
    80207622:	ffff9097          	auipc	ra,0xffff9
    80207626:	70c080e7          	jalr	1804(ra) # 80200d2e <printf>
	exit_proc(0);
    8020762a:	4501                	li	a0,0
    8020762c:	ffffe097          	auipc	ra,0xffffe
    80207630:	776080e7          	jalr	1910(ra) # 80205da2 <exit_proc>
}
    80207634:	0001                	nop
    80207636:	60e2                	ld	ra,24(sp)
    80207638:	6442                	ld	s0,16(sp)
    8020763a:	6105                	addi	sp,sp,32
    8020763c:	8082                	ret

000000008020763e <test_kill>:

void test_kill(void){
    8020763e:	7179                	addi	sp,sp,-48
    80207640:	f406                	sd	ra,40(sp)
    80207642:	f022                	sd	s0,32(sp)
    80207644:	1800                	addi	s0,sp,48
	printf("\n----- 测试1: 创建后立即杀死 -----\n");
    80207646:	0001e517          	auipc	a0,0x1e
    8020764a:	d0a50513          	addi	a0,a0,-758 # 80225350 <user_test_table+0xff8>
    8020764e:	ffff9097          	auipc	ra,0xffff9
    80207652:	6e0080e7          	jalr	1760(ra) # 80200d2e <printf>
	int pid =create_kernel_proc(simple_task);
    80207656:	fffff517          	auipc	a0,0xfffff
    8020765a:	40850513          	addi	a0,a0,1032 # 80206a5e <simple_task>
    8020765e:	ffffe097          	auipc	ra,0xffffe
    80207662:	f92080e7          	jalr	-110(ra) # 802055f0 <create_kernel_proc>
    80207666:	87aa                	mv	a5,a0
    80207668:	fef42423          	sw	a5,-24(s0)
	printf("【测试】: 创建进程成功，PID: %d\n", pid);
    8020766c:	fe842783          	lw	a5,-24(s0)
    80207670:	85be                	mv	a1,a5
    80207672:	0001e517          	auipc	a0,0x1e
    80207676:	d0e50513          	addi	a0,a0,-754 # 80225380 <user_test_table+0x1028>
    8020767a:	ffff9097          	auipc	ra,0xffff9
    8020767e:	6b4080e7          	jalr	1716(ra) # 80200d2e <printf>
	kill_proc(pid);
    80207682:	fe842783          	lw	a5,-24(s0)
    80207686:	853e                	mv	a0,a5
    80207688:	ffffe097          	auipc	ra,0xffffe
    8020768c:	6b6080e7          	jalr	1718(ra) # 80205d3e <kill_proc>
	printf("【测试】: 等待被杀死的进程退出,此处被杀死的进程不会有输出...\n");
    80207690:	0001e517          	auipc	a0,0x1e
    80207694:	d2050513          	addi	a0,a0,-736 # 802253b0 <user_test_table+0x1058>
    80207698:	ffff9097          	auipc	ra,0xffff9
    8020769c:	696080e7          	jalr	1686(ra) # 80200d2e <printf>
	int ret =0;
    802076a0:	fc042c23          	sw	zero,-40(s0)
	wait_proc(&ret);
    802076a4:	fd840793          	addi	a5,s0,-40
    802076a8:	853e                	mv	a0,a5
    802076aa:	ffffe097          	auipc	ra,0xffffe
    802076ae:	7c2080e7          	jalr	1986(ra) # 80205e6c <wait_proc>
	printf("【测试】: 进程%d退出，退出码应该为129，此处为%d\n ",pid,ret);
    802076b2:	fd842703          	lw	a4,-40(s0)
    802076b6:	fe842783          	lw	a5,-24(s0)
    802076ba:	863a                	mv	a2,a4
    802076bc:	85be                	mv	a1,a5
    802076be:	0001e517          	auipc	a0,0x1e
    802076c2:	d5250513          	addi	a0,a0,-686 # 80225410 <user_test_table+0x10b8>
    802076c6:	ffff9097          	auipc	ra,0xffff9
    802076ca:	668080e7          	jalr	1640(ra) # 80200d2e <printf>
	if(SYS_kill == ret){
    802076ce:	fd842783          	lw	a5,-40(s0)
    802076d2:	873e                	mv	a4,a5
    802076d4:	08100793          	li	a5,129
    802076d8:	00f71b63          	bne	a4,a5,802076ee <test_kill+0xb0>
		printf("【测试】:尝试立即杀死进程，测试成功\n");
    802076dc:	0001e517          	auipc	a0,0x1e
    802076e0:	d7c50513          	addi	a0,a0,-644 # 80225458 <user_test_table+0x1100>
    802076e4:	ffff9097          	auipc	ra,0xffff9
    802076e8:	64a080e7          	jalr	1610(ra) # 80200d2e <printf>
    802076ec:	a831                	j	80207708 <test_kill+0xca>
	}else{
		printf("【测试】:尝试立即杀死进程失败，退出\n");
    802076ee:	0001e517          	auipc	a0,0x1e
    802076f2:	da250513          	addi	a0,a0,-606 # 80225490 <user_test_table+0x1138>
    802076f6:	ffff9097          	auipc	ra,0xffff9
    802076fa:	638080e7          	jalr	1592(ra) # 80200d2e <printf>
		exit_proc(0);
    802076fe:	4501                	li	a0,0
    80207700:	ffffe097          	auipc	ra,0xffffe
    80207704:	6a2080e7          	jalr	1698(ra) # 80205da2 <exit_proc>
	}
	printf("\n----- 测试2: 创建后稍后杀死 -----\n");
    80207708:	0001e517          	auipc	a0,0x1e
    8020770c:	dc050513          	addi	a0,a0,-576 # 802254c8 <user_test_table+0x1170>
    80207710:	ffff9097          	auipc	ra,0xffff9
    80207714:	61e080e7          	jalr	1566(ra) # 80200d2e <printf>
	pid = create_kernel_proc(infinite_task);
    80207718:	00000517          	auipc	a0,0x0
    8020771c:	db450513          	addi	a0,a0,-588 # 802074cc <infinite_task>
    80207720:	ffffe097          	auipc	ra,0xffffe
    80207724:	ed0080e7          	jalr	-304(ra) # 802055f0 <create_kernel_proc>
    80207728:	87aa                	mv	a5,a0
    8020772a:	fef42423          	sw	a5,-24(s0)
	int count = 500;
    8020772e:	1f400793          	li	a5,500
    80207732:	fef42623          	sw	a5,-20(s0)
	while(count){
    80207736:	a811                	j	8020774a <test_kill+0x10c>
		count--; //等待500次调度
    80207738:	fec42783          	lw	a5,-20(s0)
    8020773c:	37fd                	addiw	a5,a5,-1
    8020773e:	fef42623          	sw	a5,-20(s0)
		yield();
    80207742:	ffffe097          	auipc	ra,0xffffe
    80207746:	452080e7          	jalr	1106(ra) # 80205b94 <yield>
	while(count){
    8020774a:	fec42783          	lw	a5,-20(s0)
    8020774e:	2781                	sext.w	a5,a5
    80207750:	f7e5                	bnez	a5,80207738 <test_kill+0xfa>
	}
	kill_proc(pid);
    80207752:	fe842783          	lw	a5,-24(s0)
    80207756:	853e                	mv	a0,a5
    80207758:	ffffe097          	auipc	ra,0xffffe
    8020775c:	5e6080e7          	jalr	1510(ra) # 80205d3e <kill_proc>
	wait_proc(&ret);
    80207760:	fd840793          	addi	a5,s0,-40
    80207764:	853e                	mv	a0,a5
    80207766:	ffffe097          	auipc	ra,0xffffe
    8020776a:	706080e7          	jalr	1798(ra) # 80205e6c <wait_proc>
	if(SYS_kill == ret){
    8020776e:	fd842783          	lw	a5,-40(s0)
    80207772:	873e                	mv	a4,a5
    80207774:	08100793          	li	a5,129
    80207778:	00f71b63          	bne	a4,a5,8020778e <test_kill+0x150>
		printf("【测试】:尝试稍后杀死进程，测试成功\n");
    8020777c:	0001e517          	auipc	a0,0x1e
    80207780:	d7c50513          	addi	a0,a0,-644 # 802254f8 <user_test_table+0x11a0>
    80207784:	ffff9097          	auipc	ra,0xffff9
    80207788:	5aa080e7          	jalr	1450(ra) # 80200d2e <printf>
    8020778c:	a831                	j	802077a8 <test_kill+0x16a>
	}else{
		printf("【测试】:尝试稍后杀死进程失败，退出\n");
    8020778e:	0001e517          	auipc	a0,0x1e
    80207792:	da250513          	addi	a0,a0,-606 # 80225530 <user_test_table+0x11d8>
    80207796:	ffff9097          	auipc	ra,0xffff9
    8020779a:	598080e7          	jalr	1432(ra) # 80200d2e <printf>
		exit_proc(0);
    8020779e:	4501                	li	a0,0
    802077a0:	ffffe097          	auipc	ra,0xffffe
    802077a4:	602080e7          	jalr	1538(ra) # 80205da2 <exit_proc>
	}
	printf("\n----- 测试3: 创建killer 和 victim -----\n");
    802077a8:	0001e517          	auipc	a0,0x1e
    802077ac:	dc050513          	addi	a0,a0,-576 # 80225568 <user_test_table+0x1210>
    802077b0:	ffff9097          	auipc	ra,0xffff9
    802077b4:	57e080e7          	jalr	1406(ra) # 80200d2e <printf>
	int victim = create_kernel_proc(victim_task);
    802077b8:	00000517          	auipc	a0,0x0
    802077bc:	e1250513          	addi	a0,a0,-494 # 802075ca <victim_task>
    802077c0:	ffffe097          	auipc	ra,0xffffe
    802077c4:	e30080e7          	jalr	-464(ra) # 802055f0 <create_kernel_proc>
    802077c8:	87aa                	mv	a5,a0
    802077ca:	fef42223          	sw	a5,-28(s0)
	int killer = create_kernel_proc1(killer_task,victim);
    802077ce:	fe442783          	lw	a5,-28(s0)
    802077d2:	85be                	mv	a1,a5
    802077d4:	00000517          	auipc	a0,0x0
    802077d8:	d6850513          	addi	a0,a0,-664 # 8020753c <killer_task>
    802077dc:	ffffe097          	auipc	ra,0xffffe
    802077e0:	e82080e7          	jalr	-382(ra) # 8020565e <create_kernel_proc1>
    802077e4:	87aa                	mv	a5,a0
    802077e6:	fef42023          	sw	a5,-32(s0)
	int first_exit = wait_proc(&ret);
    802077ea:	fd840793          	addi	a5,s0,-40
    802077ee:	853e                	mv	a0,a5
    802077f0:	ffffe097          	auipc	ra,0xffffe
    802077f4:	67c080e7          	jalr	1660(ra) # 80205e6c <wait_proc>
    802077f8:	87aa                	mv	a5,a0
    802077fa:	fcf42e23          	sw	a5,-36(s0)
	if(first_exit == killer){
    802077fe:	fdc42783          	lw	a5,-36(s0)
    80207802:	873e                	mv	a4,a5
    80207804:	fe042783          	lw	a5,-32(s0)
    80207808:	2701                	sext.w	a4,a4
    8020780a:	2781                	sext.w	a5,a5
    8020780c:	04f71263          	bne	a4,a5,80207850 <test_kill+0x212>
		wait_proc(&ret);
    80207810:	fd840793          	addi	a5,s0,-40
    80207814:	853e                	mv	a0,a5
    80207816:	ffffe097          	auipc	ra,0xffffe
    8020781a:	656080e7          	jalr	1622(ra) # 80205e6c <wait_proc>
		if(SYS_kill == ret){
    8020781e:	fd842783          	lw	a5,-40(s0)
    80207822:	873e                	mv	a4,a5
    80207824:	08100793          	li	a5,129
    80207828:	00f71b63          	bne	a4,a5,8020783e <test_kill+0x200>
			printf("【测试】:killer win\n");
    8020782c:	0001e517          	auipc	a0,0x1e
    80207830:	d6c50513          	addi	a0,a0,-660 # 80225598 <user_test_table+0x1240>
    80207834:	ffff9097          	auipc	ra,0xffff9
    80207838:	4fa080e7          	jalr	1274(ra) # 80200d2e <printf>
    8020783c:	a085                	j	8020789c <test_kill+0x25e>
		}else{
			printf("【测试】:出现问题，killer先结束但victim存活\n");
    8020783e:	0001e517          	auipc	a0,0x1e
    80207842:	d7a50513          	addi	a0,a0,-646 # 802255b8 <user_test_table+0x1260>
    80207846:	ffff9097          	auipc	ra,0xffff9
    8020784a:	4e8080e7          	jalr	1256(ra) # 80200d2e <printf>
    8020784e:	a0b9                	j	8020789c <test_kill+0x25e>
		}
	}else if(first_exit == victim){
    80207850:	fdc42783          	lw	a5,-36(s0)
    80207854:	873e                	mv	a4,a5
    80207856:	fe442783          	lw	a5,-28(s0)
    8020785a:	2701                	sext.w	a4,a4
    8020785c:	2781                	sext.w	a5,a5
    8020785e:	02f71f63          	bne	a4,a5,8020789c <test_kill+0x25e>
		wait_proc(NULL);
    80207862:	4501                	li	a0,0
    80207864:	ffffe097          	auipc	ra,0xffffe
    80207868:	608080e7          	jalr	1544(ra) # 80205e6c <wait_proc>
		if(SYS_kill == ret){
    8020786c:	fd842783          	lw	a5,-40(s0)
    80207870:	873e                	mv	a4,a5
    80207872:	08100793          	li	a5,129
    80207876:	00f71b63          	bne	a4,a5,8020788c <test_kill+0x24e>
			printf("【测试】:killer win\n");
    8020787a:	0001e517          	auipc	a0,0x1e
    8020787e:	d1e50513          	addi	a0,a0,-738 # 80225598 <user_test_table+0x1240>
    80207882:	ffff9097          	auipc	ra,0xffff9
    80207886:	4ac080e7          	jalr	1196(ra) # 80200d2e <printf>
    8020788a:	a809                	j	8020789c <test_kill+0x25e>
		}else{
			printf("【测试】:出现问题，victim先结束且存活\n");
    8020788c:	0001e517          	auipc	a0,0x1e
    80207890:	d6c50513          	addi	a0,a0,-660 # 802255f8 <user_test_table+0x12a0>
    80207894:	ffff9097          	auipc	ra,0xffff9
    80207898:	49a080e7          	jalr	1178(ra) # 80200d2e <printf>
		}
	}
	exit_proc(0);
    8020789c:	4501                	li	a0,0
    8020789e:	ffffe097          	auipc	ra,0xffffe
    802078a2:	504080e7          	jalr	1284(ra) # 80205da2 <exit_proc>
    802078a6:	0001                	nop
    802078a8:	70a2                	ld	ra,40(sp)
    802078aa:	7402                	ld	s0,32(sp)
    802078ac:	6145                	addi	sp,sp,48
    802078ae:	8082                	ret
	...
